/// Dart→C++ 类型映射器
///
/// 将 Dart Kernel `DartType` 转换为 C++ 类型字符串。
/// 设计镜像 `lib/restorer/type_utils.dart`，但输出 C++ 语法。
///
/// 核心映射：
///   int → int64_t, double → double, bool → bool, String → std::string
///   dynamic/Object → AnyPtr, 用户类 X → XValue*
///   List<T> → StaticList<CppT>*, Map<K,V> → StaticMap<CppK,CppV>*
///   Future<T> → Promise<CppT>*, Function → TypeFunctionN*
library;

import 'package:kernel/kernel.dart';
import 'package:kernel/ast.dart';

/// Dart Kernel DartType → C++ 类型字符串的映射器。
///
/// 需要外部提供 `_userClasses` 集合以判断用户自定义类。
class TypeMapper {
  /// 用户自定义类名集合（由 ClassInfoCollector 填充）
  final Set<String> userClasses;

  /// 已注册的 mixin 名称
  final Set<String> mixinNames;

  /// 活跃的泛型参数替换映射（mixin 字段场景）
  Map<String, String> activeTypeParamSubstitution;

  /// 精确替换目标集合
  Set<TypeParameter> activeTypeParamTargets;

  TypeMapper({
    required this.userClasses,
    required this.mixinNames,
    this.activeTypeParamSubstitution = const {},
    this.activeTypeParamTargets = const {},
  });

  // ============================================================================
  // C++ 关键字避让
  // ============================================================================

  static const _cppKeywords = <String>{
    'alignas', 'alignof', 'and', 'and_eq', 'asm', 'auto', 'bitand', 'bitor',
    'bool', 'break', 'case', 'catch', 'char', 'char8_t', 'char16_t', 'char32_t',
    'class', 'compl', 'concept', 'const', 'consteval', 'constexpr', 'constinit',
    'const_cast', 'continue', 'co_await', 'co_return', 'co_yield', 'decltype',
    'default', 'delete', 'do', 'double', 'dynamic_cast', 'else', 'enum',
    'explicit', 'export', 'extern', 'false', 'float', 'for', 'friend', 'goto',
    'if', 'inline', 'int', 'long', 'mutable', 'namespace', 'new', 'noexcept',
    'not', 'not_eq', 'nullptr', 'operator', 'or', 'or_eq', 'private',
    'protected', 'public', 'register', 'reinterpret_cast', 'requires', 'return',
    'short', 'signed', 'sizeof', 'static', 'static_assert', 'static_cast',
    'struct', 'switch', 'template', 'this', 'thread_local', 'throw', 'true',
    'try', 'typedef', 'typeid', 'typename', 'union', 'unsigned', 'using',
    'virtual', 'void', 'volatile', 'wchar_t', 'while', 'xor', 'xor_eq',
    'override', 'final',
    // 常用的宏/类型名也要避让
    'NULL', 'string', 'vector', 'map', 'set', 'list', 'array',
  };

  /// 清理变量名：去掉前缀特殊字符、替换非法字符、避让 C++ 关键字
  String cleanIdentifier(String name) {
    if (name.startsWith(':')) {
      name = name.substring(1);
    } else if (name.startsWith('#')) {
      name = name.substring(1);
    } else if (name.contains('#')) {
      final parts = name.split('#');
      name = parts.last;
      if (name.isEmpty || RegExp(r'^[0-9]').hasMatch(name)) {
        name = '_v$name';
      }
    }

    // 替换非法字符
    name = name.replaceAll(RegExp(r'[^a-zA-Z0-9_]'), '_');

    // 数字开头加下划线
    if (name.isNotEmpty && RegExp(r'^[0-9]').hasMatch(name)) {
      name = '_$name';
    }

    // C++ 关键字避让
    if (_cppKeywords.contains(name)) {
      name = '${name}_';
    }

    // 空名称
    if (name.isEmpty) name = '_unnamed';

    return name;
  }

  // ============================================================================
  // 核心类型映射
  // ============================================================================

  /// 将 DartType 转换为 C++ 类型字符串
  String cppType(DartType type) {
    if (type is InterfaceType) {
      return _mapInterfaceType(type);
    }
    if (type is FunctionType) {
      return _mapFunctionType(type);
    }
    if (type is TypeParameterType) {
      return _mapTypeParameterType(type);
    }
    if (type is DynamicType) return 'AnyPtr';
    if (type is VoidType) return 'void';
    if (type is NeverType) return 'void';  // [[noreturn]] void
    if (type is FutureOrType) {
      return 'AnyPtr';  // FutureOr<T> 可能是 T 或 Promise<T>*
    }
    if (type is RecordType) {
      // Dart RecordType（如 (int, String)）在C++中映射为StaticTuple
      // 但由于Record的字段名和数量是动态的，且运行时使用较少，
      // 统一退化为AnyPtr以保证类型安全
      return 'AnyPtr';
    }
    if (type is InvalidType) return 'AnyPtr';
    return 'AnyPtr';
  }

  /// 判断一个 DartType 是否为用户自定义类
  bool isUserClass(String name) {
    return userClasses.contains(name);
  }

  /// 获取基础类型名称（不含指针、不含模板参数）
  String baseTypeName(DartType type) {
    if (type is InterfaceType) {
      return type.classNode.name;
    }
    return 'dynamic';
  }

  // ============================================================================
  // InterfaceType 映射
  // ============================================================================

  String _mapInterfaceType(InterfaceType type) {
    final rawName = type.classNode.name;

    // 基础类型直接映射
    switch (rawName) {
      case 'int':
        return 'int64_t';
      case 'double':
        return 'double';
      case 'bool':
        return 'bool';
      case 'String':
        return 'std::string';
      case 'num':
        return 'AnyPtr';  // num 可能是 int 或 double
      case 'Null':
        return 'AnyPtr';  // null 值
      case 'Object':
        return 'AnyPtr';
      case 'Symbol':
        return 'std::string';
      case 'Type':
        return 'std::string';
    }

    // 集合类型静态化
    if (_isListType(rawName)) {
      final inner = _mapTypeArgs(type.typeArguments);
      return 'StaticList<$inner>*';
    }
    if (_isMapType(rawName)) {
      final args = type.typeArguments;
      if (args.length >= 2) {
        return 'StaticMap<${cppType(args[0])}, ${cppType(args[1])}>*';
      }
      return 'StaticMap<AnyPtr, AnyPtr>*';
    }
    if (_isSetType(rawName)) {
      final inner = _mapTypeArgs(type.typeArguments);
      return 'StaticSet<$inner>*';
    }

    // Future → Promise
    if (rawName == 'Future' || rawName == '_Future') {
      final inner = _mapTypeArgs(type.typeArguments);
      return 'Promise<$inner>*';
    }

    // Function 顶层类型
    if (rawName == 'Function') {
      return 'TypeFunction*';
    }

    // StringBuffer → StaticStringBuffer
    if (rawName == 'StringBuffer') {
      return 'StaticStringBuffer*';
    }

    // Iterator → StaticIterator
    if (rawName == 'Iterator' || rawName == '_ListIterator' ||
        rawName == '_IterableIterator') {
      final inner = _mapTypeArgs(type.typeArguments);
      return 'StaticIterator<$inner>*';
    }

    // Iterable → StaticList（Dart的Iterable是lazy序列，C++中用StaticList作为具体容器承载，
    // 通过StaticIterator提供lazy遍历能力）
    if (rawName == 'Iterable' || rawName == '_Iterable') {
      final inner = _mapTypeArgs(type.typeArguments);
      return 'StaticList<$inner>*';
    }

    // MapEntry → StaticMapEntry
    if (rawName == 'MapEntry') {
      final args = type.typeArguments;
      if (args.length >= 2) {
        return 'StaticMapEntry<${cppType(args[0])}, ${cppType(args[1])}>';
      }
      return 'StaticMapEntry<AnyPtr, AnyPtr>';
    }

    // Duration → StaticDuration
    if (rawName == 'Duration') {
      return 'StaticDuration';
    }

    // DateTime → StaticDateTime
    if (rawName == 'DateTime') {
      return 'StaticDateTime';
    }

    // RegExp → StaticRegExp
    if (rawName == 'RegExp' || rawName == '_RegExp') {
      return 'StaticRegExp';
    }

    // 异常类型
    if (_isExceptionType(rawName)) {
      return _mapExceptionType(rawName);
    }

    // 用户自定义类 → XValue*
    if (isUserClass(rawName)) {
      final suffix = _mapTypeArgsSuffix(type.typeArguments);
      if (suffix.isNotEmpty) {
        return '${rawName}Value$suffix*';
      }
      return '${rawName}Value*';
    }

    // 其他（SDK 类、未识别）→ AnyPtr
    return 'AnyPtr';
  }

  // ============================================================================
  // FunctionType 映射
  // ============================================================================

  String _mapFunctionType(FunctionType type) {
    final ret = cppType(type.returnType);
    final hasNamed = type.namedParameters.isNotEmpty;
    final positional = type.positionalParameters;
    final required = type.requiredParameterCount;
    final hasOptionalPositional = positional.length > required;

    // 有命名参数、可选位置参数或 arity 超限时回退到 TypeFunction*
    if (hasNamed || hasOptionalPositional || positional.length > kMaxArity) {
      return 'TypeFunction*';
    }

    final arity = positional.length;
    final paramTypes = positional.map((p) => cppType(p)).toList();
    final args = [ret, ...paramTypes].join(', ');
    return 'TypeFunction$arity<$args>*';
  }

  // ============================================================================
  // TypeParameterType 映射
  // ============================================================================

  String _mapTypeParameterType(TypeParameterType type) {
    final paramName = type.parameter.name ?? 'T';
    // 泛型参数替换（mixin 字段场景）
    final replacement = activeTypeParamSubstitution[paramName];
    if (replacement != null) {
      if (activeTypeParamTargets.isEmpty ||
          activeTypeParamTargets.contains(type.parameter)) {
        return replacement;
      }
    }
    // C++ 模板参数名直接使用
    return paramName;
  }

  // ============================================================================
  // Box 类型判断
  // ============================================================================

  /// 判断一个 DartType 被闭包捕获时是否需要装箱，返回 Box 类型名或 null
  String? boxTypeNameFor(DartType type) {
    final primitive = _primitiveBoxName(type);
    if (primitive != null) return primitive;
    // 泛型参数类型运行时可能是值类型
    if (type is TypeParameterType) {
      return 'ObjectBox';
    }
    return null;
  }

  /// 基础类型 → 对应 Box 名称
  String? _primitiveBoxName(DartType type) {
    if (type is InterfaceType) {
      switch (type.classNode.name) {
        case 'int': return 'IntBox';
        case 'double': return 'DoubleBox';
        case 'bool': return 'BoolBox';
        case 'String': return 'StringBox';
      }
    }
    return null;
  }

  /// 判断一个类型是否是基础值类型（int, double, bool, String）
  bool isPrimitiveValueType(DartType type) {
    if (type is InterfaceType) {
      return const {'int', 'double', 'bool', 'String'}
          .contains(type.classNode.name);
    }
    return false;
  }

  /// 获取类型的默认值表达式
  String defaultValueForType(DartType type) {
    if (type is InterfaceType) {
      switch (type.classNode.name) {
        case 'int': return '0';
        case 'double': return '0.0';
        case 'bool': return 'false';
        case 'String': return '""';
        case 'List':
        case '_GrowableList':
        case '_List':
          return 'StaticList<${_mapTypeArgs(type.typeArguments)}>::empty()';
        case 'Map':
        case '_Map':
        case 'LinkedHashMap':
        case '_InternalLinkedHashMap':
          return 'StaticMap<AnyPtr, AnyPtr>::empty()';
        case 'Set':
        case '_Set':
        case 'LinkedHashSet':
        case '_CompactLinkedHashSet':
          return 'StaticSet<${_mapTypeArgs(type.typeArguments)}>::empty()';
      }
      if (isUserClass(type.classNode.name)) {
        return 'nullptr';
      }
    }
    if (type is DynamicType) return 'AnyPtr()';
    if (type is VoidType) return '';
    if (type is TypeParameterType) return 'AnyPtr()';
    if (type is FunctionType) return 'nullptr';
    return 'AnyPtr()';
  }

  // ============================================================================
  // 运算符名称映射
  // ============================================================================

  /// 将 Dart 运算符名称映射到 vptr key 名称
  static String operatorVptrKey(String op) {
    switch (op) {
      case '+': return 'operatorPlus';
      case '-': return 'operatorMinus';
      case '*': return 'operatorMul';
      case '/': return 'operatorDiv';
      case '%': return 'operatorMod';
      case '~/': return 'operatorTruncDiv';
      case '==': return 'operatorEq';
      case '<': return 'operatorLt';
      case '>': return 'operatorGt';
      case '<=': return 'operatorLe';
      case '>=': return 'operatorGe';
      case '[]': return 'operatorIndex';
      case '[]=': return 'operatorIndexSet';
      case '~': return 'operatorBitNot';
      case '&': return 'operatorBitAnd';
      case '|': return 'operatorBitOr';
      case '^': return 'operatorBitXor';
      case '<<': return 'operatorShl';
      case '>>': return 'operatorShr';
      case 'unary-': return 'operatorNeg';
      default: return 'operator_${cleanIdentifierStatic(op)}';
    }
  }

  /// 将 Dart 运算符名称映射到 C++ 方法名（用于静态函数名）
  static String operatorCppSuffix(String op) {
    switch (op) {
      case '+': return 'Plus';
      case '-': return 'Minus';
      case '*': return 'Mul';
      case '/': return 'Div';
      case '%': return 'Mod';
      case '~/': return 'TruncDiv';
      case '==': return 'Eq';
      case '<': return 'Lt';
      case '>': return 'Gt';
      case '<=': return 'Le';
      case '>=': return 'Ge';
      case '[]': return 'Index';
      case '[]=': return 'IndexSet';
      case '~': return 'BitNot';
      case '&': return 'BitAnd';
      case '|': return 'BitOr';
      case '^': return 'BitXor';
      case '<<': return 'Shl';
      case '>>': return 'Shr';
      case 'unary-': return 'Neg';
      default: return cleanIdentifierStatic(op);
    }
  }

  /// 判断是否是运算符名称
  static bool isOperatorName(String name) {
    return const {
      '+', '-', '*', '/', '%', '~/', '>', '<', '>=', '<=',
      '&', '|', '^', '<<', '>>', '==', '[]', '[]=', '~', 'unary-'
    }.contains(name);
  }

  /// 判断是否是二元运算符
  static bool isBinaryOp(String name) {
    return const {
      '+', '-', '*', '/', '%', '~/', '>', '<', '>=', '<=',
      '&', '|', '^', '<<', '>>'
    }.contains(name);
  }

  // ============================================================================
  // 辅助方法
  // ============================================================================

  /// 将 DartType 转为 vptr key 后缀（如 'String', 'List_int'）
  String typeToSpecSuffix(DartType type) {
    return _typeToSpecStr(type, asSuffix: true);
  }

  /// 将 DartType 转为类型实参字符串（如 'String', 'List<int>'）
  String typeToSpecRestoreStr(DartType type) {
    return _typeToSpecStr(type, asSuffix: false);
  }

  String _typeToSpecStr(DartType type, {bool asSuffix = false}) {
    if (type is InterfaceType) {
      final name = type.classNode.name;
      if (type.typeArguments.isEmpty) return name;
      final separator = asSuffix ? '_' : ', ';
      final args = type.typeArguments
          .map((t) => _typeToSpecStr(t, asSuffix: asSuffix))
          .join(separator);
      return asSuffix ? '${name}_$args' : '$name<$args>';
    }
    if (type is TypeParameterType) return type.parameter.name ?? 'T';
    if (type is DynamicType) return 'dynamic';
    if (type is VoidType) return 'void';
    if (type is FunctionType) return 'TypeFunction';
    return 'dynamic';
  }

  /// 检查 DartType 是否包含 TypeParameterType
  bool containsTypeParameter(DartType type) {
    if (type is TypeParameterType) return true;
    if (type is InterfaceType) {
      return type.typeArguments.any((t) => containsTypeParameter(t));
    }
    if (type is FunctionType) {
      if (containsTypeParameter(type.returnType)) return true;
      return type.positionalParameters.any((t) => containsTypeParameter(t));
    }
    if (type is FutureOrType) {
      return containsTypeParameter(type.typeArgument);
    }
    return false;
  }

  /// 生成 AnyPtr::fromXxx 包装表达式
  String wrapInAnyPtr(String expr, DartType type) {
    if (type is InterfaceType) {
      switch (type.classNode.name) {
        case 'int': return 'AnyPtr::fromInt($expr)';
        case 'double': return 'AnyPtr::fromDouble($expr)';
        case 'bool': return 'AnyPtr::fromBool($expr)';
        case 'String': return 'AnyPtr::fromString($expr)';
      }
      if (isUserClass(type.classNode.name)) {
        return 'AnyPtr::fromVPtr($expr)';
      }
      if (_isCollectionType(type.classNode.name)) {
        return 'AnyPtr::fromGC($expr)';
      }
    }
    if (type is FunctionType) {
      return 'AnyPtr::fromTypeFunction($expr)';
    }
    if (type is DynamicType) return expr;  // 已经是 AnyPtr
    return 'AnyPtr::fromAuto($expr)';
  }

  /// 从 AnyPtr 提取为指定 C++ 类型
  String unwrapFromAnyPtr(String expr, DartType type) {
    final cppT = cppType(type);
    if (type is InterfaceType) {
      switch (type.classNode.name) {
        case 'int': return '$expr.toInt()';
        case 'double': return '$expr.toDouble()';
        case 'bool': return '$expr.toBool()';
        case 'String': return '$expr.castTo<std::string>()';
      }
      if (isUserClass(type.classNode.name)) {
        return 'static_cast<${cppT}>($expr.toVPtr())';
      }
    }
    if (type is DynamicType) return expr;
    return '$expr.castTo<$cppT>()';
  }

  // ============================================================================
  // 内部辅助
  // ============================================================================

  String _mapTypeArgs(List<DartType> args) {
    if (args.isEmpty) return 'AnyPtr';
    return args.map((t) => cppType(t)).join(', ');
  }

  String _mapTypeArgsSuffix(List<DartType> args) {
    if (args.isEmpty) return '';
    return '<${args.map((t) => cppType(t)).join(', ')}>';
  }

  bool _isListType(String name) {
    return const {
      'List', '_GrowableList', '_List', '_ImmutableList',
      '_ArrayBase', '_EfficientLengthIterable',
    }.contains(name);
  }

  bool _isMapType(String name) {
    return const {
      'Map', '_Map', 'LinkedHashMap', '_InternalLinkedHashMap',
      '_HashMap', '_LinkedHashMap',
    }.contains(name);
  }

  bool _isSetType(String name) {
    return const {
      'Set', '_Set', 'LinkedHashSet', '_CompactLinkedHashSet',
      '_HashSet',
    }.contains(name);
  }

  bool _isCollectionType(String name) {
    return _isListType(name) || _isMapType(name) || _isSetType(name) ||
        name == 'Future' || name == '_Future';
  }

  bool _isExceptionType(String name) {
    return const {
      'Exception', 'FormatException', 'StateError',
      'ArgumentError', 'RangeError', 'UnsupportedError',
      'UnimplementedError',
    }.contains(name);
  }

  String _mapExceptionType(String name) {
    switch (name) {
      case 'StateError': return 'DartStateError';
      case 'ArgumentError': return 'DartArgumentError';
      case 'RangeError': return 'DartRangeError';
      case 'FormatException': return 'DartFormatException';
      case 'UnsupportedError': return 'DartUnsupportedError';
      case 'UnimplementedError': return 'DartUnimplementedError';
      default: return 'DartException';
    }
  }

  /// 静态版标识符清理（不依赖实例状态）
  static String cleanIdentifierStatic(String name) {
    name = name.replaceAll(RegExp(r'[^a-zA-Z0-9_]'), '_');
    if (name.isNotEmpty && RegExp(r'^[0-9]').hasMatch(name)) {
      name = '_$name';
    }
    if (_cppKeywords.contains(name)) {
      name = '${name}_';
    }
    if (name.isEmpty) name = '_unnamed';
    return name;
  }

  /// arity 上限；与 dart2cpp_lowered.h 的 TypeFunctionN 一致
  static const int kMaxArity = 8;
}
