import 'dart:io';

import 'package:kernel/kernel.dart';
import 'package:kernel/ast.dart';
import 'package:kernel/visitor.dart';

part 'cpp_emitter.dart';

// ============================================================================
// 公共 API
// ============================================================================

/// 记录一个方法级泛型调用的特化信息。
/// [vptrSuffix] 用于生成 vptr key（如 'String'、'int'），
/// [typeArgStrs] 是原始类型字符串列表（如 ['String']、['int']），用于生成调用类型实参。
class MethodSpecEntry {
  final String vptrSuffix;
  final List<String> typeArgStrs;

  MethodSpecEntry(this.vptrSuffix, this.typeArgStrs);

  @override
  bool operator ==(Object other) =>
      other is MethodSpecEntry && other.vptrSuffix == vptrSuffix;

  @override
  int get hashCode => vptrSuffix.hashCode;
}

// ============================================================================
// 虚表条目
// ============================================================================

/// 虚表条目：记录方法签名信息
class _VTableEntry {
  final String name;
  final String kind; // 'method', 'getter', 'setter', 'operator'
  final String staticFuncName;
  final String signature; // Function type signature for VTable field
  final Procedure? proc; // 原始 Procedure 引用（用于泛型 lambda wrapper 生成）
  final String? declaringClassName; // 首次声明该方法的类名（用于 this_ 参数类型）

  _VTableEntry({
    required this.name,
    required this.kind,
    required this.staticFuncName,
    required this.signature,
    this.proc,
    this.declaringClassName,
  });
}

// ============================================================================
// 类信息收集器（供 CppEmitter 复用的分析逻辑）
// ============================================================================

class _ClassInfoCollector {
  /// 所有用户自定义类名集合（排除 dart: / package: 中的类）
  final Set<String> _userClasses = {};

  /// 所有 mixin 名称集合
  final Set<String> _mixinNames = {};

  /// 所有 enum 名称集合
  final Set<String> _enumNames = {};

  /// 有自定义 toString 方法的枚举名称集合
  final Set<String> _enumsWithCustomToString = {};

  /// 类继承关系：子类名 → 父类名（仅用户自定义类）
  final Map<String, String> _classHierarchy = {};

  /// 类 → 其所有虚方法名列表（含 getter/setter/operator）
  final Map<String, List<_VTableEntry>> _classVTableEntries = {};

  /// 类 → 其 Class AST 节点（用于查询字段等）
  final Map<String, Class> _classNodes = {};

  /// 合成 mixin 中间类的 lowered 名称集合（如 Dog_Animal_Printable_Orderable）
  /// 这些类不生成构造函数，需要在 super init 时跳过
  final Set<String> _syntheticLoweredNames = {};

  /// 方法级泛型特化收集：className → { methodName → { 特化条目 } }
  /// 预扫描 AST 收集所有调用处的方法级类型实参，用于在构造函数中按特化 key 注册。
  /// 每个特化条目包含：vptrSuffix（用于 vptr key）和 typeArgStrs（用于生成调用类型实参）。
  /// 例如 Either.fold<String> → { 'Either': { 'fold': { MethodSpecEntry('String', ['String']) } } }
  final Map<String, Map<String, Set<MethodSpecEntry>>> _methodTypeSpecializations = {};

  /// 判断是否是运算符名称
  bool _isOperatorName(String name) {
    return const {'+', '-', '*', '/', '%', '~/', '>', '<', '>=', '<=', '&', '|', '^', '<<', '>>', '>>>', '==', '[]', '[]=', '~', 'unary-'}.contains(name);
  }

  /// 根据类名获取 VTable 条目（用于查找父类或接口的条目）
  List<_VTableEntry>? _getVTableEntriesByName(String className) {
    return _classVTableEntries[className];
  }

  /// 检查 DartType 是否包含（或就是）TypeParameterType。
  /// 用于过滤泛型上下文中的调用（如递归调用），这类调用不应该生成特化条目。
  bool _containsTypeParameter(DartType type) {
    if (type is TypeParameterType) return true;
    if (type is InterfaceType) {
      return type.typeArguments.any((t) => _containsTypeParameter(t));
    }
    if (type is FunctionType) {
      if (_containsTypeParameter(type.returnType)) return true;
      return type.positionalParameters.any((t) => _containsTypeParameter(t));
    }
    if (type is FutureOrType) {
      return _containsTypeParameter(type.typeArgument);
    }
    return false;
  }

  /// 将 DartType 转为简化的类型字符串。
  /// [asSuffix] 为 true 时用 '_' 分隔（用于 vptr key 后缀，如 'List_int'）；
  /// 为 false 时保留完整泛型语法（用于类型实参，如 'List<int>'）。
  String _typeToSpecStr(DartType type, {bool asSuffix = false}) {
    if (type is InterfaceType) {
      final name = type.classNode.name;
      if (type.typeArguments.isEmpty) return name;
      final separator = asSuffix ? '_' : ', ';
      final args = type.typeArguments.map((t) => _typeToSpecStr(t, asSuffix: asSuffix)).join(separator);
      return asSuffix ? '${name}_$args' : '$name<$args>';
    }
    if (type is TypeParameterType) return type.parameter.name ?? 'T';
    if (type is DynamicType) return 'dynamic';
    if (type is VoidType) return 'void';
    if (type is FunctionType) {
      // vptr key / spec 后缀里不带 `<...>`，否则会污染 key 命名空间；这里
      // 只用一个稳定的标记词，使用 `TypeFunction` 即可（不出现 `Function`
      // 字面量）。
      return 'TypeFunction';
    }
    return 'dynamic';
  }

  /// 便捷方法：生成 vptr key 后缀（如 'String', 'List_int'）
  String _typeToSpecSuffix(DartType type) => _typeToSpecStr(type, asSuffix: true);

  /// 便捷方法：生成类型实参字符串（如 'String', 'List<int>'）
  String _typeToSpecRestoreStr(DartType type) => _typeToSpecStr(type, asSuffix: false);

  /// 通用 AST 子节点遍历器。
  /// 对 [node] 的每个直接子节点调用 [visit]。
  /// [onTryCatchVar]：TryCatch 中的 exception/stackTrace 变量声明回调（可选）。
  /// [onLetVar]：Let 表达式中的变量声明回调（可选）。
  void _forEachChildNode(
    TreeNode node,
    void Function(TreeNode) visit, {
    void Function(VariableDeclaration)? onTryCatchVar,
    void Function(VariableDeclaration)? onLetVar,
  }) {
    if (node is Block) {
      for (final s in node.statements) visit(s);
    } else if (node is ExpressionStatement) {
      visit(node.expression);
    } else if (node is ReturnStatement) {
      if (node.expression != null) visit(node.expression!);
    } else if (node is IfStatement) {
      visit(node.condition);
      visit(node.then);
      if (node.otherwise != null) visit(node.otherwise!);
    } else if (node is ForStatement) {
      for (final v in node.variables) visit(v);
      if (node.condition != null) visit(node.condition!);
      for (final u in node.updates) visit(u);
      visit(node.body);
    } else if (node is ForInStatement) {
      visit(node.variable);
      visit(node.iterable);
      visit(node.body);
    } else if (node is WhileStatement) {
      visit(node.condition);
      visit(node.body);
    } else if (node is DoStatement) {
      visit(node.body);
      visit(node.condition);
    } else if (node is TryCatch) {
      visit(node.body);
      for (final c in node.catches) {
        if (onTryCatchVar != null) {
          if (c.exception != null) onTryCatchVar(c.exception!);
          if (c.stackTrace != null) onTryCatchVar(c.stackTrace!);
        }
        visit(c.body);
      }
    } else if (node is TryFinally) {
      visit(node.body);
      visit(node.finalizer);
    } else if (node is SwitchStatement) {
      visit(node.expression);
      for (final c in node.cases) visit(c.body);
    } else if (node is LabeledStatement) {
      visit(node.body);
    } else if (node is YieldStatement) {
      visit(node.expression);
    } else if (node is AssertStatement) {
      visit(node.condition);
      if (node.message != null) visit(node.message!);
    } else if (node is VariableDeclaration) {
      if (node.initializer != null) visit(node.initializer!);
    } else if (node is Let) {
      if (onLetVar != null) onLetVar(node.variable);
      if (node.variable.initializer != null) visit(node.variable.initializer!);
      visit(node.body);
    } else if (node is BlockExpression) {
      visit(node.body);
      visit(node.value);
    } else if (node is InstanceInvocation) {
      visit(node.receiver);
      for (final a in node.arguments.positional) visit(a);
      for (final a in node.arguments.named) visit(a.value);
    } else if (node is StaticInvocation) {
      for (final a in node.arguments.positional) visit(a);
      for (final a in node.arguments.named) visit(a.value);
    } else if (node is ConstructorInvocation) {
      for (final a in node.arguments.positional) visit(a);
      for (final a in node.arguments.named) visit(a.value);
    } else if (node is InstanceGet) {
      visit(node.receiver);
    } else if (node is InstanceSet) {
      visit(node.receiver);
      visit(node.value);
    } else if (node is VariableSet) {
      visit(node.value);
    } else if (node is ConditionalExpression) {
      visit(node.condition);
      visit(node.then);
      visit(node.otherwise);
    } else if (node is LogicalExpression) {
      visit(node.left);
      visit(node.right);
    } else if (node is Not) {
      visit(node.operand);
    } else if (node is StringConcatenation) {
      for (final e in node.expressions) visit(e);
    } else if (node is AsExpression) {
      visit(node.operand);
    } else if (node is IsExpression) {
      visit(node.operand);
    } else if (node is NullCheck) {
      visit(node.operand);
    } else if (node is AwaitExpression) {
      visit(node.operand);
    } else if (node is ListLiteral) {
      for (final e in node.expressions) visit(e);
    } else if (node is SetLiteral) {
      for (final e in node.expressions) visit(e);
    } else if (node is MapLiteral) {
      for (final e in node.entries) {
        visit(e.key);
        visit(e.value);
      }
    } else if (node is Throw) {
      visit(node.expression);
    } else if (node is EqualsCall) {
      visit(node.left);
      visit(node.right);
    } else if (node is EqualsNull) {
      visit(node.expression);
    } else if (node is FunctionInvocation) {
      visit(node.receiver);
      for (final a in node.arguments.positional) visit(a);
      for (final a in node.arguments.named) visit(a.value);
    } else if (node is DynamicInvocation) {
      visit(node.receiver);
      for (final a in node.arguments.positional) visit(a);
      for (final a in node.arguments.named) visit(a.value);
    } else if (node is LocalFunctionInvocation) {
      for (final a in node.arguments.positional) visit(a);
      for (final a in node.arguments.named) visit(a.value);
    }
    // 其他叶子节点（字面量、VariableGet、ThisExpression 等）无子节点，跳过
  }

  /// 简化版类型还原（用于签名生成）
  /// 将 Kernel DartType 转换为 Dart 类型字符串，用户自定义类映射为 XValue 形式
  String _restoreTypeForSignature(DartType type) {
    final nullable = type.nullability == Nullability.nullable;
    final suffix = nullable ? '?' : '';
    if (type is InterfaceType) {
      final name = type.classNode.name;
      // 集合静态化映射（与 _restoreType 保持一致）
      String mappedName;
      if (_isUserClass(name)) {
        mappedName = '${name}Value';
      } else if (name == 'List' || name == '_GrowableList' || name == '_List') {
        mappedName = 'List';
      } else if (name == 'Map' || name == '_Map' || name == 'LinkedHashMap' || name == '_InternalLinkedHashMap') {
        mappedName = 'Map';
      } else if (name == 'Set' || name == '_Set' || name == 'LinkedHashSet' || name == '_CompactLinkedHashSet') {
        mappedName = 'Set';
      } else if (name == 'Future' || name == '_Future') {
        mappedName = 'Promise';
      } else if (name == 'Function') {
        // dart:core 的 `Function` interface type 缺少 arity → 退化到 `dynamic`
        // （在函数签名中保持 dynamic 以支持协变）
        return 'dynamic';
      } else if (name == 'StringBuffer') {
        mappedName = 'StringBuffer';
      } else if (name == 'Iterator' || name == '_ListIterator') {
        mappedName = 'Iterator';
      } else if (name == 'MapEntry') {
        mappedName = 'MapEntry';
      } else if (name == 'Duration') {
        mappedName = 'Duration';
      } else if (name == 'DateTime') {
        mappedName = 'DateTime';
      } else if (name == 'RegExp' || name == '_RegExp') {
        mappedName = 'RegExp';
      } else {
        mappedName = name;
      }
      if (type.typeArguments.isEmpty) return '$mappedName$suffix';
      final args = type.typeArguments.map((t) => _restoreTypeForSignature(t)).join(', ');
      return '$mappedName<$args>$suffix';
    }
    if (type is FunctionType) {
      final ret = _restoreTypeForSignature(type.returnType);
      final hasNamed = type.namedParameters.isNotEmpty;
      final positional = type.positionalParameters;
      final required = type.requiredParameterCount;
      final hasOptional = positional.length > required;
      const kMax = 16;
      if (hasNamed || hasOptional || positional.length > kMax) {
        return 'TypeFunction<$ret>$suffix';
      }
      final arity = positional.length;
      final paramTexts =
          [for (final p in positional) _restoreTypeForSignature(p)];
      final args = [ret, ...paramTexts].join(', ');
      return 'TypeFunction$arity<$args>$suffix';
    }
    if (type is TypeParameterType) {
      // 分析路径下类型参数不可用，统一退化为 dynamic
      return 'dynamic';
    }
    // OOP lowering 后对象引用统一走 AnyGC，不再保留 dynamic
    if (type is DynamicType) return 'AnyGC';
    if (type is VoidType) return 'void';
    if (type is NeverType) return 'Never$suffix';
    return 'AnyGC';
  }

  /// 判断类名是否是用户自定义类（包括合成 mixin 中间类）
  bool _isUserClass(String name) {
    if (_userClasses.contains(name)) return true;
    // 合成 mixin 中间类：原始名包含 &，规范化后在 _userClasses 中
    if (name.contains('&')) {
      return _userClasses.contains(_sanitizeSyntheticName(name));
    }
    return false;
  }

  /// 判断类名是否是 mixin 声明
  bool _isMixinName(String name) => _mixinNames.contains(name);

  /// 规范化合成 mixin 类名：`_Dog&Animal&Printable` → `Dog_Animal_Printable`
  String _sanitizeSyntheticName(String name) {
    // 去掉前缀 _ 并将 & 替换为 _
    var result = name;
    if (result.startsWith('_')) result = result.substring(1);
    return result.replaceAll('&', '_');
  }

  /// 获取用户自定义类的父类名（如果有）
  String? _getParentClassName(String className) => _classHierarchy[className];

  /// 获取运算符的函数名后缀
  String _operatorFuncName(String operatorSymbol) {
    const mapping = {
      '+': 'Plus', '-': 'Minus', '*': 'Star', '/': 'Div',
      '%': 'Mod', '~/': 'TruncDiv', '>': 'Gt', '<': 'Lt',
      '>=': 'Gte', '<=': 'Lte', '&': 'BitAnd', '|': 'BitOr',
      '^': 'BitXor', '<<': 'Shl', '>>': 'Shr', '>>>': 'Ushr', '==': 'Eq',
      '[]': 'Index', '[]=': 'IndexSet', '~': 'BitNot', 'unary-': 'Neg',
    };
    return mapping[operatorSymbol] ?? operatorSymbol;
  }

  /// 生成方法的静态函数名
  String _staticMethodName(String className, String methodName) {
    if (_isOperatorName(methodName)) {
      return '${className}_operator${_operatorFuncName(methodName)}';
    }
    return '${className}_$methodName';
  }

  /// 生成 getter 的静态函数名
  String _staticGetterName(String className, String propName) {
    return '${className}_get_$propName';
  }

  /// 生成 setter 的静态函数名
  String _staticSetterName(String className, String propName) {
    return '${className}_set_$propName';
  }

  /// 判断一个 Class 是否是 enum（父类为 _Enum）
  bool _isEnumClass(Class cls) {
    if (cls.supertype == null) return false;
    return cls.supertype!.classNode.name == '_Enum';
  }

  /// 查找合成中间类对应的实际用户类名
  /// 例如：Dog_Animal_Printable → Dog（Dog 的继承链包含 Dog_Animal_Printable）
  String _findUserClassForSynthetic(String syntheticClassName) {
    for (final userClass in _userClasses) {
      if (_syntheticLoweredNames.contains(userClass)) continue;
      if (_isMixinName(userClass)) continue;
      // 检查 userClass 的继承链是否包含 syntheticClassName
      var current = _getParentClassName(userClass);
      while (current != null) {
        if (current == syntheticClassName) return userClass;
        current = _getParentClassName(current);
      }
    }
    // fallback: 返回合成中间类名本身
    return syntheticClassName;
  }

  // ==========================================================================
  // 第一遍：收集类信息
  // ==========================================================================

  void _collectClassInfo(Library lib) {
    // 第一遍：收集所有类的基本信息（名称、继承关系），但不收集虚表
    final userClassEntries = <(String className, Class cls)>[];

    for (final cls in lib.classes) {
      // mixin 声明：记录名称（不做 lowering，方法通过合成中间类处理）
      if (cls.isMixinDeclaration) {
        _mixinNames.add(cls.name);
        _classNodes[cls.name] = cls;
        continue;
      }

      // enum: 记录名称和节点，检查是否有自定义 toString
      if (_isEnumClass(cls)) {
        _enumNames.add(cls.name);
        _classNodes[cls.name] = cls;
        final hasCustomToString = cls.procedures.any((p) =>
            p.name.text == 'toString' && !p.isAbstract && p.function.body != null);
        if (hasCustomToString) {
          _enumsWithCustomToString.add(cls.name);
        }
        continue;
      }

      // 合成 mixin 中间类（名字包含 &）：作为普通用户类收集
      final isSynthetic = cls.name.contains('&');
      final className = isSynthetic
          ? _sanitizeSyntheticName(cls.name)
          : cls.name;

      _userClasses.add(className);
      if (isSynthetic) {
        _syntheticLoweredNames.add(className);
      }
      _classNodes[className] = cls;

      // 记录继承关系
      if (cls.supertype != null) {
        final superName = cls.supertype!.classNode.name;
        if (superName.contains('&')) {
          final parentLowered = _sanitizeSyntheticName(superName);
          _classHierarchy[className] = parentLowered;
        } else if (superName != 'Object') {
          _classHierarchy[className] = superName;
        }
      }

      userClassEntries.add((className, cls));
    }

    // 第二遍：按拓扑排序收集虚表（确保父类在子类之前处理）
    final sorted = _topologicalSort(userClassEntries);
    for (final (className, cls) in sorted) {
      _collectVTableEntries(cls, overrideName: className);
    }
  }

  /// 按继承关系拓扑排序：父类在子类之前
  List<(String, Class)> _topologicalSort(List<(String, Class)> entries) {
    final nameToEntry = <String, (String, Class)>{};
    for (final entry in entries) {
      nameToEntry[entry.$1] = entry;
    }

    final sorted = <(String, Class)>[];
    final visited = <String>{};

    void visit(String className) {
      if (visited.contains(className)) return;
      visited.add(className);
      // 先处理父类
      final parent = _classHierarchy[className];
      if (parent != null && nameToEntry.containsKey(parent)) {
        visit(parent);
      }
      final entry = nameToEntry[className];
      if (entry != null) {
        sorted.add(entry);
      }
    }

    for (final entry in entries) {
      visit(entry.$1);
    }
    return sorted;
  }

  // ---- 第二遍：预扫描方法级泛型特化 ----

  /// 遍历 Library 中所有 AST 节点，收集带方法级泛型参数的 InstanceInvocation，
  /// 记录每个类每个方法的所有具体类型实参后缀到 _methodTypeSpecializations。
  void _collectMethodTypeSpecializations(Library lib) {
    for (final cls in lib.classes) {
      for (final proc in cls.procedures) {
        if (proc.function.body != null) {
          _scanNodeForMethodTypeSpecs(proc.function.body!);
        }
      }
      for (final ctor in cls.constructors) {
        if (ctor.function.body != null) {
          _scanNodeForMethodTypeSpecs(ctor.function.body!);
        }
        for (final init in ctor.initializers) {
          if (init is FieldInitializer) {
            _scanNodeForMethodTypeSpecs(init.value);
          }
        }
      }
      for (final field in cls.fields) {
        if (field.initializer != null) {
          _scanNodeForMethodTypeSpecs(field.initializer!);
        }
      }
    }
    for (final proc in lib.procedures) {
      if (proc.function.body != null) {
        _scanNodeForMethodTypeSpecs(proc.function.body!);
      }
    }
    for (final field in lib.fields) {
      if (field.initializer != null) {
        _scanNodeForMethodTypeSpecs(field.initializer!);
      }
    }
  }

  /// 递归扫描 AST 节点，查找带方法级泛型的 InstanceInvocation 并记录特化信息。
  void _scanNodeForMethodTypeSpecs(TreeNode node) {
    if (node is InstanceInvocation) {
      _checkAndRecordMethodTypeSpec(node);
      // 继续扫描子节点
      _scanNodeForMethodTypeSpecs(node.receiver);
      for (final a in node.arguments.positional) {
        _scanNodeForMethodTypeSpecs(a);
      }
      for (final a in node.arguments.named) {
        _scanNodeForMethodTypeSpecs(a.value);
      }
      return;
    }
    // 通用子节点遍历
    _scanChildrenForMethodTypeSpecs(node);
  }

  /// 检查一个 InstanceInvocation 是否是带方法级泛型的调用，
  /// 如果是，将其具体类型后缀记录到 _methodTypeSpecializations。
  void _checkAndRecordMethodTypeSpec(InstanceInvocation node) {
    final target = node.interfaceTarget;
    final methodTypeParams = target.function.typeParameters;
    if (methodTypeParams.isEmpty) return;

    // 确定 receiver 的类名
    final enclosingClass = target.enclosingClass;
    if (enclosingClass == null) return;

    var className = enclosingClass.name;
    if (className.contains('&')) {
      className = _sanitizeSyntheticName(className);
    }
    // 只处理用户自定义类
    if (!_userClasses.contains(className)) return;
    // 合成中间类 → 找到实际用户类
    if (_syntheticLoweredNames.contains(className)) {
      className = _findUserClassForSynthetic(className);
    }

    // 去重方法级泛型：与类同名的被去除
    final classTpNames = enclosingClass.typeParameters.map((tp) => tp.name).toSet();
    final dedupedMethodTps = methodTypeParams
        .where((tp) => !classTpNames.contains(tp.name))
        .toList();
    if (dedupedMethodTps.isEmpty) return;

    // 从 arguments.types 中提取方法级泛型的实际类型实参
    // 在 Kernel AST 中，InstanceInvocation.arguments.types 仅包含方法的类型实参
    // （类的类型参数已通过 receiver 的静态类型携带）
    final methodTypeArgs = node.arguments.types;
    if (methodTypeArgs.isEmpty) return;

    // 关键过滤：只有当所有方法级类型实参都是**具体类型**（非 TypeParameterType）时
    // 才生成特化条目。如果任意类型实参仍然是类型参数引用（如递归调用中的 R），
    // 说明调用在泛型上下文中，无法在 vptr 中以具体类型注册。
    final hasAbstractTypeArg = methodTypeArgs.any((ta) => _containsTypeParameter(ta));
    if (hasAbstractTypeArg) return;

    // 生成特化后缀：用所有方法级类型实参的名称连接
    final methodName = target.name.text;
    final typeSuffix = methodTypeArgs.map((ta) => _typeToSpecSuffix(ta)).join('_');
    if (typeSuffix.isEmpty) return;

    // 同时记录原始类型字符串（用于生成正确的调用类型实参）
    final typeArgStrs = methodTypeArgs.map((ta) => _typeToSpecRestoreStr(ta)).toList();

    // 记录到 _methodTypeSpecializations
    _methodTypeSpecializations
        .putIfAbsent(className, () => {})
        .putIfAbsent(methodName, () => {})
        .add(MethodSpecEntry(typeSuffix, typeArgStrs));
  }

  /// 通用子节点遍历（用于预扫描方法级泛型特化）
  /// 使用 _forEachChildNode 避免重复的遍历逻辑
  void _scanChildrenForMethodTypeSpecs(TreeNode node) {
    _forEachChildNode(node, _scanNodeForMethodTypeSpecs);
  }

  void _collectVTableEntries(Class cls, {String? overrideName}) {
    final className = overrideName ?? cls.name;
    final entries = <_VTableEntry>[];

    // 先继承父类的虚表条目
    final parentName = _classHierarchy[className];
    if (parentName != null) {
      final parentEntries = _getVTableEntriesByName(parentName);
      if (parentEntries != null) {
        entries.addAll(parentEntries);
      }
    }

    // 收集 implements 接口中的方法（如果本类或父类尚未声明）
    for (final impl in cls.implementedTypes) {
      final ifaceName = impl.classNode.name;
      final ifaceEntries = _getVTableEntriesByName(ifaceName);
      if (ifaceEntries != null) {
        for (final ifaceEntry in ifaceEntries) {
          final alreadyExists = entries.any(
              (e) => e.name == ifaceEntry.name && e.kind == ifaceEntry.kind);
          if (!alreadyExists) {
            entries.add(_VTableEntry(
              name: ifaceEntry.name,
              kind: ifaceEntry.kind,
              staticFuncName: ifaceEntry.staticFuncName,
              signature: ifaceEntry.signature,
              proc: ifaceEntry.proc,
              declaringClassName: ifaceEntry.declaringClassName,
            ));
          }
        }
      }
    }

    // 收集本类自身的方法
    for (final proc in cls.procedures) {
      if (proc.isStatic) continue;
      if (proc.isFactory) continue;
      if (proc.name.text.startsWith('_')) continue;

      final methodName = proc.name.text;
      final entry = _buildVTableEntry(cls, proc, methodName, className);

      final existingIdx = entries.indexWhere((e) => e.name == methodName && e.kind == entry.kind);
      if (existingIdx >= 0) {
        // 重载：保留首次声明类的 declaringClassName
        final existingDeclaringClass = entries[existingIdx].declaringClassName ?? className;
        entries[existingIdx] = _VTableEntry(
          name: entry.name,
          kind: entry.kind,
          staticFuncName: entry.staticFuncName,
          signature: entry.signature,
          proc: entry.proc,
          declaringClassName: existingDeclaringClass,
        );
      } else {
        // 新方法：声明类就是当前类
        entries.add(_VTableEntry(
          name: entry.name,
          kind: entry.kind,
          staticFuncName: entry.staticFuncName,
          signature: entry.signature,
          proc: entry.proc,
          declaringClassName: className,
        ));
      }
    }

    _classVTableEntries[className] = entries;
  }

  /// 从 Procedure 构建 VTable 条目
  /// [loweredName] 是规范化后的类名（合成类名去掉 & 等）
  _VTableEntry _buildVTableEntry(Class cls, Procedure proc, String methodName, [String? loweredName]) {
    final className = loweredName ?? cls.name;
    String kind;
    String staticFuncName;
    String signature;

    if (proc.isGetter) {
      kind = 'getter';
      staticFuncName = _staticGetterName(className, methodName);
      final retType = _restoreTypeForSignature(proc.function.returnType);
      signature = '$retType Function(${className}Value this_)';
    } else if (proc.isSetter) {
      kind = 'setter';
      staticFuncName = _staticSetterName(className, methodName);
      final paramType = proc.function.positionalParameters.isNotEmpty
          ? _restoreTypeForSignature(proc.function.positionalParameters.first.type)
          : 'dynamic';
      signature = 'void Function(${className}Value this_, $paramType value)';
    } else if (_isOperatorName(methodName)) {
      kind = 'operator';
      staticFuncName = _staticMethodName(className, methodName);
      final retType = _restoreTypeForSignature(proc.function.returnType);
      final paramTypes = proc.function.positionalParameters
          .map((p) => _restoreTypeForSignature(p.type))
          .join(', ');
      final paramPart = paramTypes.isEmpty
          ? '${className}Value this_'
          : '${className}Value this_, $paramTypes';
      signature = '$retType Function($paramPart)';
    } else {
      kind = 'method';
      staticFuncName = _staticMethodName(className, methodName);
      final retType = _restoreTypeForSignature(proc.function.returnType);
      final paramTypes = <String>[];
      for (final p in proc.function.positionalParameters) {
        paramTypes.add(_restoreTypeForSignature(p.type));
      }
      for (final p in proc.function.namedParameters) {
        paramTypes.add(_restoreTypeForSignature(p.type));
      }
      final paramPart = paramTypes.isEmpty
          ? '${className}Value this_'
          : '${className}Value this_, ${paramTypes.join(', ')}';
      signature = '$retType Function($paramPart)';
    }

    return _VTableEntry(
      name: methodName,
      kind: kind,
      staticFuncName: staticFuncName,
      signature: signature,
      proc: proc,
    );
  }
}
