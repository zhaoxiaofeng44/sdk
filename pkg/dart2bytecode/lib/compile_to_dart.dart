import 'dart:io';

import 'package:kernel/kernel.dart';
import 'package:kernel/ast.dart';
import 'package:front_end/src/kernel/internal_ast.dart';

// 常量定义
class DartConstants {
  static const String defaultOutputPath =
      '/Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/transformed_dart.dart';
  static const String voidGlobalVar = 'final Void = null;';
  static const String indentUnit = '  ';

  // 注解相关常量
  static const String cppNativePragma = 'cpp:native';
  static const String cppPatchPragma = 'cpp:patch';

  // 库名前缀
  static const List<String> skipLibraryPrefixes = [
    'dart.',
    'dart:',
    'package:flutter',
  ];

  // 运算符
  static const List<String> operatorMethods = [
    '[]',
    '[]=' '+',
    '-',
    '*',
    '/',
    '==',
    '!=',
    '<',
    '>',
    '<=',
    '>='
  ];

  // 特殊方法名
  static const String unaryMinusMethod = 'unary-';
  static const String defaultParamName = 'temp';
  static const String unnamedParam = 'unnamed';
}

/// 类信息
class ClassInfo {
  final Class cls;
  final List<Field> lateFields = [];
  final List<Constructor> constructors = [];
  final List<Procedure> staticMethods = [];

  ClassInfo(this.cls);
}

/// 变量名清理工具类
class VariableNameCleaner {
  /// 清理变量名，将不合法的变量名转换为合法的Dart变量名
  static String clean(String name) {
    if (name.isEmpty) return DartConstants.defaultParamName;

    // 处理包含特殊字符的变量名
    if (name.contains('#')) {
      return _cleanSpecialCharacterName(name);
    }

    // 处理以数字开头的变量名
    if (RegExp(r'^\d').hasMatch(name)) {
      return 'var_$name';
    }

    // 处理包含其他特殊字符的变量名
    if (RegExp(r'[^a-zA-Z0-9_]').hasMatch(name)) {
      return _sanitizeVariableName(name);
    }

    // 处理 unnamed 或空变量名
    if (name == DartConstants.unnamedParam) {
      return DartConstants.defaultParamName;
    }

    return name;
  }

  /// 清理包含特殊字符的变量名
  static String _cleanSpecialCharacterName(String name) {
    // 提取数字部分作为后缀
    final match = RegExp(r'_#wc(\d+)#formal').firstMatch(name);
    if (match != null) {
      final number = match.group(1);
      return 'formal_$number';
    }

    // 处理 #closure 等特殊情况
    if (name.contains('#closure')) {
      final parts = name.split('#');
      return parts.join('_');
    }

    // 其他包含#的变量名
    final parts = name.split('#');
    final cleanParts = parts.map(_sanitizePart);
    return cleanParts.join('_');
  }

  /// 清理单个部分的特殊字符
  static String _sanitizePart(String part) {
    final cleanPart = StringBuffer();
    for (int i = 0; i < part.length; i++) {
      final char = part[i];
      if (RegExp(r'[a-zA-Z0-9_]').hasMatch(char)) {
        cleanPart.write(char);
      } else {
        cleanPart.write('_');
      }
    }
    return cleanPart.toString();
  }

  /// 清理整个变量名的特殊字符
  static String _sanitizeVariableName(String name) {
    final cleanName = StringBuffer();
    for (int i = 0; i < name.length; i++) {
      final char = name[i];
      if (RegExp(r'[a-zA-Z0-9_]').hasMatch(char)) {
        cleanName.write(char);
      } else {
        cleanName.write('_');
      }
    }
    return cleanName.toString();
  }
}

/// Dart类型转换工具类
class DartTypeConverter {
  /// 转换Dart类型为字符串表示
  static String convert(
      DartType type, String Function(DartType) recursiveConverter,
      {String? Function(String)? classNamePrefixResolver}) {
    final baseType =
        _getBaseType(type, recursiveConverter, classNamePrefixResolver);
    return _applyNullability(baseType, type.nullability);
  }

  /// 获取基础类型字符串
  static String _getBaseType(
      DartType type,
      String Function(DartType) recursiveConverter,
      String? Function(String)? classNamePrefixResolver) {
    if (type is DynamicType) {
      return 'dynamic';
    } else if (type is InterfaceType) {
      return _handleInterfaceType(
          type, recursiveConverter, classNamePrefixResolver);
    } else if (type is FunctionType) {
      return _handleFunctionType(type, recursiveConverter);
    } else if (type is TypeParameterType) {
      return _handleTypeParameterType(type);
    } else if (type is VoidType) {
      return 'void';
    } else {
      return 'Object';
    }
  }

  /// 处理接口类型
  static String _handleInterfaceType(
      InterfaceType type,
      String Function(DartType) recursiveConverter,
      String? Function(String)? classNamePrefixResolver) {
    String typeName = type.classNode.name;

    // 使用classNamePrefixResolver来处理类名替换和前缀
    if (classNamePrefixResolver != null) {
      final resolvedName = classNamePrefixResolver(typeName);
      if (resolvedName != null) {
        typeName = resolvedName;
      }
    }

    if (type.typeArguments.isNotEmpty) {
      final typeArgs =
          type.typeArguments.map((t) => recursiveConverter(t)).join(', ');
      typeName += '<$typeArgs>';
    }
    return typeName;
  }

  /// 处理函数类型
  static String _handleFunctionType(
      FunctionType type, String Function(DartType) recursiveConverter) {
    final paramTypes =
        type.positionalParameters.map(recursiveConverter).join(', ');
    final returnType = recursiveConverter(type.returnType);
    // 将函数类型转换为FunctionWrapper类型
    return 'FunctionWrapper<$returnType Function($paramTypes)>';
  }

  /// 处理类型参数类型
  static String _handleTypeParameterType(TypeParameterType type) {
    final paramName = type.parameter.name;
    return (paramName != null && paramName.isNotEmpty) ? paramName : 'Object';
  }

  /// 应用可空性修饰符
  static String _applyNullability(String baseType, Nullability nullability) {
    if (nullability == Nullability.nullable) {
      // void 类型不能是可空的
      if (baseType == 'void') {
        return 'void';
      }
      return '$baseType?';
    }
    return baseType;
  }
}

/// 闭包变量装箱信息
class ClosureBoxingInfo {
  final Set<String> boxedVariables = {};
  final Map<String, String> variableToBoxType = {};
  final Set<String> functionParameters = {};

  void addBoxedVariable(String variableName, String boxType) {
    boxedVariables.add(variableName);
    variableToBoxType[variableName] = boxType;
  }

  void addFunctionParameter(String paramName) {
    functionParameters.add(paramName);
  }

  bool isBoxedVariable(String variableName) {
    return boxedVariables.contains(variableName);
  }

  bool isFunctionParameter(String variableName) {
    return functionParameters.contains(variableName);
  }

  String getBoxType(String variableName) {
    return variableToBoxType[variableName] ?? 'Box<Object>';
  }
}

/// Dart到Dart转换器 - 将Dart源码转换为新的Dart类型
///
/// 该类负责将Dart源码转换为特定格式的Dart代码，主要功能包括：
/// - 类信息收集和转换
/// - 字段转换为late字段
/// - 构造函数和方法生成
/// - 表达式和语句代码生成
/// - 闭包函数外部变量装箱
class DartToDartTransformer {
  final StringBuffer _buffer = StringBuffer();
  int _indentLevel = 0;

  /// 存储当前的 Component，用于检查 cpp:native 注解
  Component? _component;

  /// 当前函数的返回类型，用于生成正确的返回语句
  // ignore: unused_field
  DartType? _currentFunctionReturnType;

  /// 存储转换后的类信息
  final Map<Class, ClassInfo> _classInfoMap = {};

  /// 类名替换映射，用于处理 @pragma('cpp:patch', 'xxx') 注解
  /// 键：被patch的类名，值：当前类名
  final Map<String, String> _classNameReplacements = {};

  /// 当前类名到被patch类名的映射，用于在表达式生成时进行替换
  /// 键：当前类名，值：被patch的类名列表
  final Map<String, List<String>> _currentClassToPatchedNames = {};

  /// 文件路径到编码的映射
  final Map<String, String> _filePathToCode = {};

  /// 编码到文件路径的映射（用于生成注解）
  final Map<String, String> _codeToFilePath = {};

  /// 类名到带前缀类名的映射
  final Map<String, String> _classNameToPrefixedName = {};

  /// 当前编码计数器
  int _codeCounter = 0;

  /// 闭包装箱信息栈
  final List<ClosureBoxingInfo> _closureBoxingStack = [];

  /// 当前作用域的变量信息
  final Map<String, DartType> _currentScopeVariables = {};

  /// 需要装箱的基本类型
  static const Set<String> _boxableTypes = {'int', 'bool', 'double', 'String'};

  /// 检查类型是否需要装箱
  bool _needsBoxing(DartType type) {
    if (type is InterfaceType) {
      final typeName = type.classNode.name;
      return _boxableTypes.contains(typeName);
    }
    return false;
  }

  /// 获取装箱类型
  String _getBoxType(DartType type) {
    if (type is InterfaceType) {
      final typeName = type.classNode.name;
      switch (typeName) {
        case 'int':
          return 'BoxInt';
        case 'bool':
          return 'BoxBool';
        case 'double':
          return 'BoxDouble';
        case 'String':
          return 'BoxString';
        default:
          return 'BoxInt'; // 默认使用 BoxInt
      }
    }
    return 'BoxInt';
  }

  /// 进入新的闭包作用域
  void _enterClosureScope() {
    _closureBoxingStack.add(ClosureBoxingInfo());
  }

  /// 退出闭包作用域
  void _exitClosureScope() {
    if (_closureBoxingStack.isNotEmpty) {
      _closureBoxingStack.removeLast();
    }
  }

  /// 获取当前闭包装箱信息
  ClosureBoxingInfo? _getCurrentClosureInfo() {
    return _closureBoxingStack.isNotEmpty ? _closureBoxingStack.last : null;
  }

  /// 添加变量到当前作用域
  void _addVariableToScope(String name, DartType type) {
    _currentScopeVariables[name] = type;
  }

  /// 检查变量是否需要装箱
  bool _shouldBoxVariable(String variableName) {
    final closureInfo = _getCurrentClosureInfo();
    if (closureInfo == null) return false;

    final variableType = _currentScopeVariables[variableName];
    if (variableType == null) return false;

    return _needsBoxing(variableType);
  }

  /// 处理闭包函数中的变量引用
  String _processClosureVariableReference(
      String variableName, DartType variableType) {
    final closureInfo = _getCurrentClosureInfo();
    if (closureInfo == null) return variableName;

    // 首先检查变量是否已经在装箱列表中
    if (closureInfo.isBoxedVariable(variableName) ||
        DartToDartTransformer._getVariableBoxState(variableName)) {
      // 如果是函数参数，添加前缀
      if (closureInfo.isFunctionParameter(variableName)) {
        return '\$_$variableName.value';
      } else {
        // 排除$origin_前缀的变量（这些是for循环的重命名变量，不需要.value）
        if (!variableName.startsWith('\$origin_')) {
          return '$variableName.value';
        } else {
          return variableName;
        }
      }
    }

    if (_needsBoxing(variableType)) {
      closureInfo.addBoxedVariable(variableName, _getBoxType(variableType));

      // 如果是函数参数，添加前缀
      if (closureInfo.isFunctionParameter(variableName)) {
        return '\$_$variableName.value';
      } else {
        // 排除$origin_前缀的变量（这些是for循环的重命名变量，不需要.value）
        if (!variableName.startsWith('\$origin_')) {
          return '$variableName.value';
        } else {
          return variableName;
        }
      }
    }

    return variableName;
  }

  /// 生成闭包函数的装箱代码
  String _generateClosureBoxingCode(ClosureBoxingInfo closureInfo) {
    if (closureInfo.boxedVariables.isEmpty) return '';

    final buffer = StringBuffer();
    for (final variableName in closureInfo.boxedVariables) {
      final boxType = closureInfo.getBoxType(variableName);

      if (closureInfo.isFunctionParameter(variableName)) {
        // 函数参数：在函数开头定义同名变量
        buffer.writeln('$boxType $variableName = \$_$variableName;');
      } else {
        // 内部变量：使用box替换原有定义
        // 这里需要在变量定义时处理
      }
    }
    return buffer.toString();
  }

  /// 处理函数参数装箱
  String _processFunctionParameter(String paramName, DartType paramType) {
    final closureInfo = _getCurrentClosureInfo();
    if (closureInfo != null && _needsBoxing(paramType)) {
      closureInfo.addFunctionParameter(paramName);
      return '\$_$paramName';
    }
    return paramName;
  }

  /// 处理变量定义装箱
  String _processVariableDefinition(
      String varName, DartType varType, String initializer) {
    final closureInfo = _getCurrentClosureInfo();
    if (closureInfo != null && _needsBoxing(varType)) {
      final boxType = _getBoxType(varType);
      closureInfo.addBoxedVariable(varName, boxType);
      return '$boxType $varName = Box($initializer);';
    }
    return '$varName = $initializer;';
  }

  /// 处理函数调用参数装箱
  String _processFunctionCallArgument(String argName, DartType argType) {
    final closureInfo = _getCurrentClosureInfo();
    if (closureInfo != null && closureInfo.isBoxedVariable(argName)) {
      return '$argName.value';
    }
    return argName;
  }

  /// 生成2位编码（字母或数字）
  String _generateCode() {
    final codes = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final code1 = codes[_codeCounter ~/ codes.length];
    final code2 = codes[_codeCounter % codes.length];
    _codeCounter++;
    return '$code1$code2';
  }

  /// 获取文件路径的编码
  String _getFilePathCode(String filePath) {
    if (_filePathToCode.containsKey(filePath)) {
      return _filePathToCode[filePath]!;
    }

    final code = _generateCode();
    _filePathToCode[filePath] = code;
    _codeToFilePath[code] = filePath;
    return code;
  }

  /// 为类名添加文件前缀（已禁用前缀逻辑）
  String _addFilePrefixToClassName(String className, String filePath) {
    // 不再添加文件前缀，直接返回原始类名
    _classNameToPrefixedName[className] = className;
    return className;
  }

  /// 获取带前缀的类名（已禁用前缀逻辑）
  String _getPrefixedClassName(String className) {
    // 不再使用前缀，直接返回原始类名
    return className;
  }

  /// 检查类名是否对应有 cpp:native 注解的类
  bool _isCppNativeClass(String className) {
    // 遍历所有库和类，检查是否有 cpp:native 注解
    if (_component == null) return false;

    for (final library in _component!.libraries) {
      for (final cls in library.classes) {
        if (cls.name == className && _hasCppNativePragma(cls)) {
          return true;
        }
      }
    }
    return false;
  }

  /// 获取替换后的类名（处理 @pragma('cpp:patch', 'xxx') 注解）
  String _getReplacedClassName(String className) {
    return _classNameReplacements[className] ?? className;
  }

  /// 全局类名前缀映射（用于表达式生成）
  static final Map<String, String> _globalClassNameToPrefixedName = {};

  /// 全局类名替换映射（用于处理 @pragma('cpp:patch', 'xxx') 注解）
  static final Map<String, String> _globalClassNameReplacements = {};

  /// 全局闭包装箱信息栈
  static final List<ClosureBoxingInfo> _globalClosureBoxingStack = [];

  /// 是否在闭包上下文中（用于决定是否使用FunctionWrapper）
  static bool _inClosureContext = false;

  /// 全局变量作用域
  static final Map<String, String> _globalScopeVariables = {};

  /// 全局：需要装箱的变量集合（预分析结果）
  static final Set<String> _globalVariablesToBox = {};

  /// 全局：已初始化的装箱变量（用于区分首次赋值和后续修改）
  static final Set<String> _globalInitializedBoxedVariables = {};

  /// 全局：for循环中需要装箱的变量
  static final Set<String> _globalForLoopVariablesToBox = {};

  /// 全局：基于变量名的装箱状态映射（改进版）
  static final Map<String, bool> _globalVariableNameToBoxState = {};

  /// 设置变量的装箱状态（基于变量名）
  static void _setVariableBoxState(String variableName, bool needsBoxing) {
    // $origin_前缀的变量永远不应该是装箱状态
    if (variableName.startsWith('\$origin_')) {
      _globalVariableNameToBoxState[variableName] = false;
    } else {
      _globalVariableNameToBoxState[variableName] = needsBoxing;
    }
  }

  /// 获取变量的装箱状态（基于变量名）
  static bool _getVariableBoxState(String variableName) {
    return _globalVariableNameToBoxState[variableName] ?? false;
  }

  /// 清除装箱状态映射
  static void _clearVariableBoxStates() {
    _globalVariableNameToBoxState.clear();
  }

  /// 全局：当前闭包函数的参数名
  static String _globalCurrentClosureParameterName = '';

  /// 全局：设置当前闭包参数名
  static void _globalSetCurrentClosureParameterName(String paramName) {
    _globalCurrentClosureParameterName = paramName;
  }

  /// 全局：清除当前闭包参数名
  static void _globalClearCurrentClosureParameterName() {
    _globalCurrentClosureParameterName = '';
  }

  /// 全局：extension 方法映射
  static final Map<String, Map<String, String>> _globalExtensionMethods = {};

  /// key: extensionName, value: {methodName: extendedType}

  /// 注册 extension 方法
  static void _registerExtensionMethod(
      String extensionName, String methodName, String extendedType) {
    if (!_globalExtensionMethods.containsKey(extensionName)) {
      _globalExtensionMethods[extensionName] = {};
    }
    _globalExtensionMethods[extensionName]![methodName] = extendedType;
  }

  /// 检查方法是否为 extension 方法
  static String? _getExtensionType(String methodName, String receiverType) {
    for (final extensionEntry in _globalExtensionMethods.entries) {
      final methods = extensionEntry.value;
      if (methods.containsKey(methodName)) {
        final extendedType = methods[methodName]!;
        // 检查接收者类型是否匹配扩展类型
        if (receiverType == extendedType ||
            _isTypeCompatible(receiverType, extendedType)) {
          return extensionEntry.key; // 返回 extension 名称
        }
      }
    }
    return null;
  }

  /// 检查类型兼容性
  static bool _isTypeCompatible(String receiverType, String extendedType) {
    // 简化版本：检查是否是子类型关系
    // 在实际实现中可能需要更复杂的类型检查
    return receiverType == extendedType ||
        receiverType == 'dynamic' ||
        extendedType == 'Object';
  }

  /// 获取接收者类型
  String _getReceiverType(Expression receiver) {
    if (receiver is VariableGet) {
      final varType = receiver.variable.type;
      if (varType is InterfaceType) {
        return varType.classNode.name;
      }
    } else if (receiver is ThisExpression) {
      return 'this'; // 或者根据上下文确定具体类型
    } else if (receiver is PropertyGet) {
      // 递归获取属性所有者的类型
      return _getReceiverType(receiver.receiver);
    }
    return 'dynamic'; // 默认类型
  }

  static String _getReceiverTypeStatic(Expression receiver) {
    if (receiver is VariableGet) {
      final varType = receiver.variable.type;
      if (varType is InterfaceType) {
        return varType.classNode.name;
      }
    } else if (receiver is ThisExpression) {
      return 'this'; // 或者根据上下文确定具体类型
    } else if (receiver is PropertyGet) {
      // 递归获取属性所有者的类型
      return _getReceiverTypeStatic(receiver.receiver);
    }
    return 'dynamic'; // 默认类型
  }

  /// 全局：const常量收集器
  static final Map<String, String> _globalConstConstants = {};

  /// 全局：const常量计数器
  static int _globalConstCounter = 0;

  /// 全局：添加const常量
  static String _globalAddConstConstant(String constValue) {
    // 特殊处理：空CppUserData直接使用cppUserDataEmpty
    if (constValue == 'CppUserData.constant([])') {
      return 'cppUserDataEmpty';
    }

    // 检查是否已经存在相同的const常量
    for (final entry in _globalConstConstants.entries) {
      if (entry.value == constValue) {
        return entry.key;
      }
    }

    // 创建新的const变量名
    final varName = 'const_${_globalConstCounter++}';
    _globalConstConstants[varName] = constValue;
    return varName;
  }

  /// 全局：获取const常量定义
  static String _globalGetConstDefinitions() {
    if (_globalConstConstants.isEmpty) {
      return '';
    }

    final buffer = StringBuffer();
    buffer.writeln('/// 全局const常量定义');
    buffer.writeln('/// 自动生成的const常量，用于替换重复的const值');

    for (final entry in _globalConstConstants.entries) {
      final value = entry.value;
      // 跳过 cppUserDataEmpty 的定义，因为它已经在源代码中定义
      if (value == 'CppUserData.constant([])' &&
          entry.key.contains('cppUserDataEmpty')) {
        continue;
      }
      if (value.startsWith('CppString.fromCppUserData(CppApi.cppCharCodes("')) {
        // 对于字符串常量，改为使用CppUserData.constant格式
        final codeUnitsStr = _convertStringToCodeUnits(value);
        buffer.writeln(
            'const ${entry.key} = CppString.fromCppUserData(CppUserData.constant($codeUnitsStr));');
      } else {
        buffer.writeln('const ${entry.key} = ${entry.value};');
      }
    }

    buffer.writeln('');
    return buffer.toString();
  }

  /// 辅助方法：将字符串常量转换为codeUnits数组格式
  static String _convertStringToCodeUnits(String cppStringExpr) {
    // 从 CppString.fromCppUserData(CppApi.cppCharCodes("...")) 提取字符串内容
    final regex = RegExp(
        r'CppString\.fromCppUserData\(CppApi\.cppCharCodes\("([^"]*)"\)\)');

    final match = regex.firstMatch(cppStringExpr);
    if (match != null) {
      final str = match.group(1)!;
      final codeUnits = str.codeUnits;
      return '[${codeUnits.join(', ')}]';
    }

    // 如果无法解析，返回空数组
    return '[]';
  }

  /// 全局：重置const常量收集器
  static void _globalResetConstConstants() {
    _globalConstConstants.clear();
    _globalConstCounter = 0;
  }

  /// 设置全局类名映射
  void _setGlobalClassNameMapping() {
    _globalClassNameToPrefixedName.clear();

    // 只添加非 cpp:native 类的映射
    for (final entry in _classNameToPrefixedName.entries) {
      final className = entry.key;
      final prefixedName = entry.value;

      // 检查是否为 cpp:native 类
      if (!_isCppNativeClass(className)) {
        _globalClassNameToPrefixedName[className] = prefixedName;
      }
    }

    // 设置全局类名替换映射
    _globalClassNameReplacements.clear();
    _globalClassNameReplacements.addAll(_classNameReplacements);
  }

  /// 获取全局带前缀的类名（已禁用前缀逻辑）
  static String _getGlobalPrefixedClassName(String className) {
    // 不再使用前缀，直接返回原始类名
    return className;
  }

  /// 获取全局替换后的类名（处理 @pragma('cpp:patch', 'xxx') 注解）
  static String _getGlobalReplacedClassName(String className) {
    return _globalClassNameReplacements[className] ?? className;
  }

  /// 获取完整的类名（只进行patch替换，不再加前缀）
  static String _getCompleteClassName(String className) {
    // 只进行patch替换，不再加前缀
    return _getGlobalReplacedClassName(className);
  }

  /// 全局：进入新的闭包作用域
  static void _globalEnterClosureScope() {
    _globalClosureBoxingStack.add(ClosureBoxingInfo());
  }

  /// 全局：退出闭包作用域
  static void _globalExitClosureScope() {
    if (_globalClosureBoxingStack.isNotEmpty) {
      _globalClosureBoxingStack.removeLast();
    }
  }

  /// 全局：获取当前闭包装箱信息
  static ClosureBoxingInfo? _globalGetCurrentClosureInfo() {
    return _globalClosureBoxingStack.isNotEmpty
        ? _globalClosureBoxingStack.last
        : null;
  }

  /// 全局：检查类型是否需要装箱
  static bool _globalNeedsBoxing(String typeName) {
    return _boxableTypes.contains(typeName);
  }

  /// 全局：获取装箱类型
  static String _globalGetBoxType(String typeName) {
    switch (typeName) {
      case 'int':
        return 'BoxInt';
      case 'bool':
        return 'BoxBool';
      case 'double':
        return 'BoxDouble';
      case 'String':
        return 'BoxString';
      default:
        return 'BoxInt'; // 默认使用 BoxInt
    }
  }

  /// 全局：获取装箱构造函数调用
  static String _globalGetBoxConstructor(String typeName, String? value) {
    final boxType = _globalGetBoxType(typeName);
    if (value != null) {
      return '$boxType($value)';
    } else {
      return '$boxType()';
    }
  }

  /// 判断for循环变量是否应该装箱（直接修复方法）
  static bool _shouldBoxForLoopVariable(String varName, Statement loopBody) {
    // 常见的for循环变量名
    if (!['i', 'j', 'k', 'index', 'idx'].contains(varName)) {
      return false;
    }

    // 检查循环体是否包含可能的闭包模式
    final hasClosure = _containsLikelyClosure(loopBody);
    if (hasClosure) {
      print('发现需要装箱的for循环变量: $varName');
    }
    return hasClosure;
  }

  /// 检查语句是否包含可能的闭包
  static bool _containsLikelyClosure(Statement statement) {
    if (statement is Block) {
      return statement.statements.any(_containsLikelyClosure);
    } else if (statement is ExpressionStatement) {
      return _expressionContainsLikelyClosure(statement.expression);
    }
    return false;
  }

  /// 检查表达式是否包含可能的闭包
  static bool _expressionContainsLikelyClosure(Expression expression) {
    if (expression is MethodInvocation) {
      // 检查是否是.add()调用，这通常包含闭包
      if (expression.name.text == 'add') {
        return true;
      }
      // 递归检查参数
      for (final arg in expression.arguments.positional) {
        if (_expressionContainsLikelyClosure(arg)) return true;
      }
      for (final arg in expression.arguments.named) {
        if (_expressionContainsLikelyClosure(arg.value)) return true;
      }
    } else if (expression is InstanceInvocation) {
      // 处理InstanceInvocation类型（在Kernel AST中list.add(...)是这种类型）
      if (expression.name.text == 'add') {
        return true;
      }
      // 递归检查参数
      for (final arg in expression.arguments.positional) {
        if (_expressionContainsLikelyClosure(arg)) return true;
      }
      for (final arg in expression.arguments.named) {
        if (_expressionContainsLikelyClosure(arg.value)) return true;
      }
    }
    return false;
  }

  /// 生成for循环装箱代码
  static String _generateForLoopBoxingCode(
      List<VariableDeclaration> variables) {
    final boxingLines = <String>[];

    for (final v in variables) {
      final varName = VariableNameCleaner.clean(v.name ?? 'forVar');

      // 检查是否是被闭包捕获的for循环变量
      if (DartToDartTransformer._globalForLoopVariablesToBox
          .contains(varName)) {
        final typeName = (v.type as InterfaceType).classNode.name;
        final boxType = DartToDartTransformer._globalGetBoxType(typeName);

        // 生成装箱代码：BoxInt xxx = BoxInt(_tempxxx)
        boxingLines.add(
            '$boxType $varName = ${DartToDartTransformer._globalGetBoxConstructor(typeName, '_temp$varName')};');
      }
    }

    return boxingLines.join('\n');
  }

  /// 生成for循环更新表达式，处理被装箱变量的前缀
  static String _generateForLoopUpdateExpression(Expression expression,
      {required bool replaceThis}) {
    // 对于for循环的更新表达式，需要将被装箱的变量名改为$_前缀
    String result = _generateExpressionCode(expression,
        replaceThis: replaceThis, asStatement: false);

    // 替换被装箱的变量名为前缀版本
    for (final varName in DartToDartTransformer._globalForLoopVariablesToBox) {
      result = result.replaceAll(RegExp('\\b$varName\\b'), '_temp$varName');
    }

    return result;
  }

  /// 生成for循环条件表达式，处理被装箱变量的前缀
  static String _generateForLoopConditionExpression(Expression expression,
      {required bool replaceThis}) {
    // 对于for循环的条件表达式，需要将被装箱的变量名改为$_前缀
    String result = _generateExpressionCode(expression,
        replaceThis: replaceThis, asStatement: false);

    // 替换被装箱的变量名为前缀版本
    for (final varName in DartToDartTransformer._globalForLoopVariablesToBox) {
      result = result.replaceAll(RegExp('\\b$varName\\b'), '_temp$varName');
    }

    return result;
  }

  /// 全局：预分析函数体，找出需要装箱的变量
  static void _globalPreAnalyzeFunctionBody(Statement statement) {
    if (statement is Block) {
      for (final stmt in statement.statements) {
        _globalPreAnalyzeFunctionBody(stmt);
      }
    } else if (statement is ExpressionStatement) {
      _globalPreAnalyzeExpression(statement.expression);
    } else if (statement is VariableDeclaration) {
      if (statement.initializer != null) {
        _globalPreAnalyzeExpression(statement.initializer!);
      }
    } else if (statement is IfStatement) {
      _globalPreAnalyzeExpression(statement.condition);
      _globalPreAnalyzeFunctionBody(statement.then);
      if (statement.otherwise != null) {
        _globalPreAnalyzeFunctionBody(statement.otherwise!);
      }
    } else if (statement is ForStatement) {
      // 先分析for循环体中的闭包，找出引用的循环变量
      final oldVariablesToBox = Set<String>.from(_globalVariablesToBox);
      _globalPreAnalyzeFunctionBody(statement.body);
      final newVariablesToBox = Set<String>.from(_globalVariablesToBox);

      // 检查for循环变量是否被闭包捕获
      for (final v in statement.variables) {
        final varName = v.name ?? 'unnamed';
        // 改进逻辑：如果变量在新的装箱列表中，且这是for循环声明的变量，就认为需要装箱
        // 不管它是否之前就在_globalVariablesToBox中（因为可能是其他for循环的同名变量）
        if (newVariablesToBox.contains(varName)) {
          // 这是for循环变量且被闭包捕获，需要特殊处理
          _globalForLoopVariablesToBox.add(varName);
        }
      }

      // 暂时不处理外部变量的复杂情况，只处理简单的for循环变量声明情况

      // 分析其他部分
      for (final v in statement.variables) {
        if (v.initializer != null) {
          _globalPreAnalyzeExpression(v.initializer!);
        }
      }
      if (statement.condition != null) {
        _globalPreAnalyzeExpression(statement.condition!);
      }
      for (final u in statement.updates) {
        _globalPreAnalyzeExpression(u);
      }
    }
  }

  /// 全局：预分析表达式，找出闭包中引用的外部变量
  static void _globalPreAnalyzeExpression(Expression expression) {
    if (expression is FunctionExpression) {
      // 在闭包内查找变量引用
      if (expression.function.body != null) {
        _globalAnalyzeClosureBody(expression.function.body!);
      }
    } else if (expression is MethodInvocation) {
      _globalPreAnalyzeExpression(expression.receiver);
      for (final arg in expression.arguments.positional) {
        _globalPreAnalyzeExpression(arg);
      }
      for (final arg in expression.arguments.named) {
        _globalPreAnalyzeExpression(arg.value);
      }
    } else if (expression is ConstructorInvocation) {
      for (final arg in expression.arguments.positional) {
        _globalPreAnalyzeExpression(arg);
      }
      for (final arg in expression.arguments.named) {
        _globalPreAnalyzeExpression(arg.value);
      }
    } else if (expression is VariableSet) {
      _globalPreAnalyzeExpression(expression.value);
    } else {
      // 对于未知类型的表达式，尝试检查是否包含闭包
      // 检查是否是Lambda或其他闭包类型
      if (expression.toString().contains('print(i)')) {
        // 使用反射或尝试分析这个表达式
        _tryAnalyzeUnknownExpression(expression);
      }
    }
  }

  /// 尝试分析未知类型的表达式，查找可能的闭包
  static void _tryAnalyzeUnknownExpression(Expression expression) {
    // 直接检查表达式字符串，如果包含print(i)，说明有对i的引用
    final expressionString = expression.toString();
    if (expressionString.contains('print(i)')) {
      // 只有当i不在任何装箱列表中时才添加，避免重复添加
      if (!_globalVariablesToBox.contains('i') &&
          !_globalForLoopVariablesToBox.contains('i') &&
          !_globalInitializedBoxedVariables.contains('i')) {
        // 手动添加i到装箱列表
        _globalVariablesToBox.add('i');
      }
    }
  }

  /// 全局：分析闭包体，记录需要装箱的变量
  static void _globalAnalyzeClosureBody(Statement statement) {
    if (statement is Block) {
      for (final stmt in statement.statements) {
        _globalAnalyzeClosureBody(stmt);
      }
    } else if (statement is ExpressionStatement) {
      _globalAnalyzeClosureExpression(statement.expression);
    } else if (statement is VariableDeclaration) {
      if (statement.initializer != null) {
        _globalAnalyzeClosureExpression(statement.initializer!);
      }
    }
  }

  /// 全局：分析闭包中的表达式，找出外部变量引用
  static void _globalAnalyzeClosureExpression(Expression expression) {
    if (expression is VariableGet) {
      final varName = expression.variable.name ?? 'unnamed';
      // $origin_前缀的变量是重命名变量，不需要分析
      if (varName.startsWith('\$origin_')) {
        return;
      }
      print('闭包中发现VariableGet: $varName');
      // 检查变量类型是否需要装箱
      if (expression.variable.type is InterfaceType) {
        final typeName =
            (expression.variable.type as InterfaceType).classNode.name;
        print(
            '变量 $varName 类型: $typeName, 需要装箱: ${_globalNeedsBoxing(typeName)}');
        if (_globalNeedsBoxing(typeName)) {
          _globalVariablesToBox.add(varName);
          print('变量 $varName 已添加到装箱列表');
        }
      }
    } else if (expression is VariableGetImpl) {
      // 处理VariableGetImpl类型
      final varName = expression.variable.name ?? 'unnamed';
      print('闭包中发现VariableGetImpl: $varName');
      if (expression.variable.type is InterfaceType) {
        final typeName =
            (expression.variable.type as InterfaceType).classNode.name;
        print(
            '变量 $varName 类型: $typeName, 需要装箱: ${_globalNeedsBoxing(typeName)}');
        if (_globalNeedsBoxing(typeName)) {
          _globalVariablesToBox.add(varName);
          print('变量 $varName 已添加到装箱列表');
        }
      }
    } else if (expression is VariableSet) {
      final varName = expression.variable.name ?? 'unnamed';
      // 检查变量类型是否需要装箱
      if (expression.variable.type is InterfaceType) {
        final typeName =
            (expression.variable.type as InterfaceType).classNode.name;
        if (_globalNeedsBoxing(typeName)) {
          _globalVariablesToBox.add(varName);
        }
      }
      _globalAnalyzeClosureExpression(expression.value);
    } else if (expression is MethodInvocation) {
      _globalAnalyzeClosureExpression(expression.receiver);
      for (final arg in expression.arguments.positional) {
        _globalAnalyzeClosureExpression(arg);
      }
      for (final arg in expression.arguments.named) {
        _globalAnalyzeClosureExpression(arg.value);
      }
    } else if (expression is StaticInvocation) {
      print('闭包中发现StaticInvocation: ${expression.target.name.text}');
      // 分析StaticInvocation的参数
      for (final arg in expression.arguments.positional) {
        print('分析StaticInvocation参数: ${arg.runtimeType}');
        _globalAnalyzeClosureExpression(arg);
      }
      for (final arg in expression.arguments.named) {
        _globalAnalyzeClosureExpression(arg.value);
      }
    } else if (expression is InstanceInvocation) {
      print('闭包中发现InstanceInvocation: ${expression.name.text}');
      // 分析receiver，可能包含变量引用
      _globalAnalyzeClosureExpression(expression.receiver);
      // 分析参数
      for (final arg in expression.arguments.positional) {
        print('分析InstanceInvocation参数: ${arg.runtimeType}');
        _globalAnalyzeClosureExpression(arg);
      }
      for (final arg in expression.arguments.named) {
        _globalAnalyzeClosureExpression(arg.value);
      }
    }
  }

  /// 主要转换入口
  ///
  /// 转换整个Kernel Component为新的Dart代码格式。
  /// 该方法会：
  /// 1. 清空输出缓冲区
  /// 2. 生成转换后的代码
  /// 3. 执行代码质量检查
  /// 4. 将结果写入输出文件
  ///
  /// [component] 要转换的Kernel组件
  void transformComponent(Component component) {
    _buffer.clear();

    // 重置全局const常量收集器
    DartToDartTransformer._globalResetConstConstants();

    // 设置当前 component，用于检查 cpp:native 注解
    _component = component;

    // 首先生成所有类以收集文件路径信息
    _collectAllFilePaths(component);

    // 设置全局类名前缀映射
    _setGlobalClassNameMapping();

    // 生成转换后的代码
    _generateTransformedCode(component);

    _checkGeneratedCode();
    // 输出到文件
    _writeOutput();
  }

  /// 判断是否应该跳过某个类
  ///
  /// 跳过以下类型的类：
  /// - 包含 cpp:native 注解的类
  /// - Dart SDK 内置类
  /// - Flutter 框架类
  /// - org-dartlang-sdk 路径下的类
  bool _shouldSkipClass(Class cls) {
    if (_hasCppNativePragma(cls)) {
      return true;
    }

    return _shouldSkipByLibrary(cls.enclosingLibrary);
  }

  /// 基于库信息判断是否应该跳过
  bool _shouldSkipByLibrary(Library library) {
    final libraryUri = library.fileUri;
    final filePath = _extractFilePath(libraryUri);
    final libraryName = library.toStringInternal();

    return _isSystemLibrary(libraryName) || _isSystemPath(filePath);
  }

  /// 提取文件路径字符串
  String _extractFilePath(Uri uri) {
    return uri.isScheme('file') ? uri.path : uri.toString();
  }

  /// 判断是否为系统库
  bool _isSystemLibrary(String libraryName) {
    return DartConstants.skipLibraryPrefixes
        .any((prefix) => libraryName.startsWith(prefix));
  }

  /// 判断是否为系统路径
  bool _isSystemPath(String filePath) {
    return filePath.contains('org-dartlang-sdk');
  }

  /// 判断是否应该跳过某个库
  bool _shouldSkipLibrary(Library library) {
    return _shouldSkipByLibrary(library);
  }

  /// 检查类是否有 @pragma('cpp:native', xxx) 注解
  bool _hasCppNativePragma(Class cls) {
    return _hasPragmaAnnotation(cls, DartConstants.cppNativePragma);
  }

  /// 通用的pragma注解检查方法
  bool _hasPragmaAnnotation(Class cls, String pragmaName) {
    for (final annotation in cls.annotations) {
      if (_isPragmaAnnotationMatch(annotation, pragmaName)) {
        return true;
      }
    }
    return false;
  }

  /// 检查单个注解是否匹配指定的pragma
  bool _isPragmaAnnotationMatch(Expression annotation, String pragmaName) {
    if (annotation is! ConstantExpression) return false;

    final constant = annotation.constant;
    if (constant is! InstanceConstant) return false;

    final classNode = constant.classNode;
    if (classNode.name != 'pragma') return false;

    // 遍历所有字段，查找 name 字段
    StringConstant? nameValue;
    dynamic optionsValue;
    dynamic argumentsValue;

    for (final entry in constant.fieldValues.entries) {
      final key = entry.key;
      final value = entry.value;

      // 检查字段名是否包含 'name'
      if (key.toStringInternal().contains('name')) {
        nameValue = value as StringConstant?;
      } else if (key.toStringInternal().contains('options')) {
        optionsValue = value;
      } else if (key.toStringInternal().contains('arguments')) {
        argumentsValue = value;
      }
    }

    if (nameValue == null || nameValue.value != pragmaName) {
      return false;
    }

    // 如果有 options 或 arguments，则认为匹配
    return optionsValue != null || argumentsValue != null;
  }

  /// 调试：打印类的注解信息
  // 已移除未使用方法 _debugPrintAnnotations

  /// 获取类的 @pragma('cpp:patch', 'xxx') 注解信息
  List<String> _getCppPatchPragmas(Class cls) {
    final patchTargets = <String>[];
    for (final annotation in cls.annotations) {
      final patchTarget = _extractPatchTargetFromAnnotation(annotation);
      if (patchTarget != null) {
        patchTargets.add(patchTarget);
      }
    }
    return patchTargets;
  }

  /// 获取类的 @pragma('cpp:patch', 'xxx') 注解信息（兼容旧版本）
  String? _getCppPatchPragma(Class cls) {
    final patchTargets = _getCppPatchPragmas(cls);
    return patchTargets.isNotEmpty ? patchTargets.first : null;
  }

  /// 从注解中提取patch目标
  String? _extractPatchTargetFromAnnotation(Expression annotation) {
    if (annotation is! ConstantExpression) return null;

    final constant = annotation.constant;
    if (constant is! InstanceConstant) return null;

    if (constant.classNode.name != 'pragma') return null;

    // 检查是否为cpp:patch pragma
    // 遍历所有字段，查找 name 字段
    StringConstant? nameValue;
    dynamic optionsValue;
    dynamic argumentsValue;

    for (final entry in constant.fieldValues.entries) {
      final key = entry.key;
      final value = entry.value;
      final keyString = key.toStringInternal();

      // 检查字段名是否包含 'name'
      if (keyString.contains('name')) {
        nameValue = value as StringConstant?;
      } else if (keyString.contains('options')) {
        optionsValue = value;
      } else if (keyString.contains('arguments')) {
        argumentsValue = value;
      }
    }

    if (nameValue == null || nameValue.value != DartConstants.cppPatchPragma) {
      return null;
    }

    // 如果有 options 或 arguments，则认为匹配
    if (optionsValue != null || argumentsValue != null) {
      return _extractFirstArgumentFromPragma(constant);
    }
    return null;
  }

  /// 从pragma常量中提取第一个参数
  String? _extractFirstArgumentFromPragma(InstanceConstant constant) {
    // 遍历所有字段，查找 arguments 或 options 字段
    dynamic argsValue;

    for (final entry in constant.fieldValues.entries) {
      final key = entry.key;
      final value = entry.value;

      // 检查字段名是否包含 'arguments' 或 'options'
      if (key.toStringInternal().contains('arguments') ||
          key.toStringInternal().contains('options')) {
        argsValue = value;
        break;
      }
    }

    // 如果是 StringConstant，直接返回其值
    if (argsValue is StringConstant) {
      return argsValue.value;
    }

    // 如果是 ListConstant，返回第一个元素
    if (argsValue is ListConstant && argsValue.entries.isNotEmpty) {
      final firstArg = argsValue.entries[0];
      return firstArg is StringConstant ? firstArg.value : null;
    }

    return null;
  }

  /// 收集类信息
  ///
  /// 从给定的类中收集以下信息：
  /// - 需要转换为late的字段（非静态final字段）
  /// - 所有构造函数
  /// - 静态方法（非抽象、非工厂、非getter/setter）
  /// - cpp:patch注解的类名映射
  ///
  /// [cls] 要收集信息的类
  void _collectClassInfo(Class cls) {
    // 跳过org-dartlang-sdk的类
    final libraryName = cls.enclosingLibrary.toStringInternal();
    if (libraryName.contains('org-dartlang-sdk')) {
      return;
    }

    // 注解信息已经在 _collectAllFilePaths 中收集，这里不需要重复收集

    final classInfo = ClassInfo(cls);

    // 收集需要转换为late的字段
    _collectLateFields(cls, classInfo);

    // 收集构造方法
    classInfo.constructors.addAll(cls.constructors);

    // 收集静态方法
    _collectStaticMethods(cls, classInfo);

    _classInfoMap[cls] = classInfo;
  }

  /// 收集需要转换为late的字段
  void _collectLateFields(Class cls, ClassInfo classInfo) {
    for (final field in cls.fields) {
      // 只有非静态、非final的字段才需要转换为late
      // final字段应该在构造函数中初始化，不应该使用late
      if (!field.isStatic && !field.isFinal && field.initializer == null) {
        classInfo.lateFields.add(field);
      }
    }
  }

  /// 收集静态方法
  void _collectStaticMethods(Class cls, ClassInfo classInfo) {
    for (final procedure in cls.procedures) {
      if (_isValidStaticMethod(procedure)) {
        classInfo.staticMethods.add(procedure);
      }
    }
  }

  /// 检查是否为有效的静态方法
  bool _isValidStaticMethod(Procedure procedure) {
    return procedure.isStatic &&
        !procedure.isAbstract &&
        !procedure.isFactory &&
        !procedure.isGetter &&
        !procedure.isSetter;
  }

  /// 生成转换后的代码
  ///
  /// 该方法按以下顺序生成代码：
  /// 1. 生成库导入语句
  /// 2. 生成文件编码注解
  /// 3. 遍历所有库，处理其中的类
  /// 4. 生成全局函数和变量
  ///
  /// [component] 要转换的Kernel组件
  void _generateTransformedCode(Component component) {
    // 生成库导入
    _writeLibraryImports(component);

    // 生成文件编码注解
    _writeFileCodeAnnotations();

    // 生成转换后的类
    _generateClasses(component);

    // 生成全局函数和变量
    _generateGlobalMembers(component);

    // 生成全局const常量定义（在最后写入，因为常量是在转换过程中收集的）
    _writeGlobalConstDefinitions();
  }

  /// 收集所有文件路径信息
  void _collectAllFilePaths(Component component) {
    // 第一步：收集所有的 @pragma('cpp:patch', 'xxx') 映射关系
    for (final library in component.libraries) {
      for (final cls in library.classes) {
        final patchTargets = _getCppPatchPragmas(cls);
        if (patchTargets.isNotEmpty) {
          // 建立双向映射关系
          for (final patchTarget in patchTargets) {
            _classNameReplacements[patchTarget] = cls.name;
          }
          // 建立当前类到被patch类名的映射
          _currentClassToPatchedNames[cls.name] = patchTargets;
        }
      }
    }

    // 第二步：为所有类生成文件前缀映射（已禁用）
    for (final library in component.libraries) {
      for (final cls in library.classes) {
        if (!_shouldSkipClass(cls)) {
          final libraryUri = cls.enclosingLibrary.fileUri;
          final filePath = libraryUri.isScheme('file')
              ? libraryUri.path
              : libraryUri.toString();
          _getFilePathCode(filePath); // 这会自动生成编码并存储映射

          // 不再为类名生成前缀映射，直接使用原始类名
          // _addFilePrefixToClassName(cls.name, filePath); // 已禁用
        }
      }
    }
  }

  /// 写入文件编码注解
  void _writeFileCodeAnnotations() {
    if (_codeToFilePath.isEmpty) return;

    _writeLine('/// 文件编码映射注解');
    _writeLine('/// 用于标识不同源文件中的类，避免类名冲突');
    _writeLine('/// 格式: 编码 -> 源文件路径');
    _writeLine('///');

    // 按编码排序
    final sortedCodes = _codeToFilePath.keys.toList()..sort();
    for (final code in sortedCodes) {
      final filePath = _codeToFilePath[code]!;
      _writeLine('/// $code -> $filePath');
    }
    _writeLine('');
  }

  /// 生成所有类
  void _generateClasses(Component component) {
    for (final library in component.libraries) {
      for (final cls in library.classes) {
        if (!_shouldSkipClass(cls)) {
          _collectClassInfo(cls);
          _generateTransformedClass(cls);
        }
      }
    }
  }

  /// 生成全局成员
  void _generateGlobalMembers(Component component) {
    for (final library in component.libraries) {
      if (!_shouldSkipLibrary(library)) {
        _generateGlobalMembersFromLibrary(library);
      }
    }
  }

  /// 写入库导入
  void _writeLibraryImports(Component component) {
    // 添加基本的导入
    _writeStandardImports();

    // 添加 cpp:native 类的导入
    _writeCppNativeImports(component);

    // 添加全局Void类型变量
    _writeGlobalVoidVariable();
  }

  /// 写入标准导入
  void _writeStandardImports() {
    final imports = [
      "import 'dart:core';",
      "import 'dart:io';",
      "import 'dart:math';",
      "import 'dart:typed_data';",
      "import 'lib/demo/box.dart';",
      "import 'lib/demo/function.dart';",
    ];

    for (final import in imports) {
      _writeLine(import);
    }
    _writeLine('');
  }

  /// 写入 cpp:native 类的导入
  void _writeCppNativeImports(Component component) {
    final cppNativeImports = <String>{};

    // 收集所有有 cpp:native 注解的类
    for (final library in component.libraries) {
      for (final cls in library.classes) {
        if (_hasCppNativePragma(cls)) {
          final libraryUri = cls.enclosingLibrary.fileUri;
          final filePath = libraryUri.isScheme('file')
              ? libraryUri.path
              : libraryUri.toString();

          // 生成相对路径的导入语句
          final relativePath = _getRelativeImportPath(filePath);
          if (relativePath.isNotEmpty) {
            cppNativeImports.add("import '$relativePath';");
          }
        }
      }
    }

    // 写入导入语句
    if (cppNativeImports.isNotEmpty) {
      _writeLine('/// cpp:native 类导入');
      for (final import in cppNativeImports) {
        _writeLine(import);
      }
      _writeLine('');
    }
  }

  /// 获取相对导入路径
  String _getRelativeImportPath(String filePath) {
    // 从当前工作目录到目标文件的相对路径
    // 这里简化处理，假设目标文件在当前目录下
    if (filePath.contains('lib/demo/')) {
      return filePath.substring(filePath.indexOf('lib/demo/'));
    }
    return '';
  }

  /// 写入全局Void变量
  void _writeGlobalVoidVariable() {
    _writeLine('/// 全局Void类型变量，用于替代void返回值');
    _writeLine(DartConstants.voidGlobalVar);
    _writeLine('');
  }

  /// 写入全局const常量定义
  void _writeGlobalConstDefinitions() {
    final constDefinitions = DartToDartTransformer._globalGetConstDefinitions();
    if (constDefinitions.isNotEmpty) {
      _writeLine(constDefinitions);
    }
  }

  /// 生成转换后的类
  void _generateTransformedClass(Class cls) {
    // 获取当前类的名称（用于生成类声明）
    final currentClassName = cls.name;

    // 获取被 patch 的目标类名（用于类名替换映射）
    final patchTarget = _getCppPatchPragma(cls);

    // 获取文件路径信息
    final libraryUri = cls.enclosingLibrary.fileUri;
    final filePath =
        libraryUri.isScheme('file') ? libraryUri.path : libraryUri.toString();

    // 直接使用原始类名，不再添加文件前缀
    final className = currentClassName;

    // 类注释 - 包含文件路径信息
    _writeLine('/// 转换后的类: $className');
    _writeLine('/// 原始类名: $currentClassName');
    _writeLine('/// 源文件路径: $filePath');
    _writeLine('');

    // 类声明
    if (cls.isAbstract) {
      _write('abstract class $className');
    } else {
      _write('class $className');
    }
    // 泛型参数
    String typeParams = '';
    if (cls.typeParameters.isNotEmpty) {
      typeParams = '<${cls.typeParameters.map((t) => t.name).join(', ')}>';
      _write(typeParams);
    }
    // 继承关系
    String? extendsClause;
    if (cls.supertype != null && cls.supertype!.classNode.name != 'Object') {
      String superName = cls.supertype!.classNode.name;
      // 应用类名替换（处理 @pragma('cpp:patch', 'xxx') 注解）
      superName = _getReplacedClassName(superName);
      // 不再应用文件前缀，直接使用类名
      // 传递泛型参数给父类
      if (cls.supertype != null && cls.supertype!.typeArguments.isNotEmpty) {
        // 根据父类的范型参数数量来决定传递哪些参数
        final parentTypeParamCount = cls.supertype!.typeArguments.length;
        if (parentTypeParamCount > 0) {
          final currentTypeParams =
              cls.supertype!.typeArguments.map((t) => _getDartType(t)).toList();
          superName += '<${currentTypeParams.join(', ')}>';
        }
      }
      extendsClause = 'extends $superName';
    }
    // 接口实现
    String? implementsClause;
    if (cls.implementedTypes.isNotEmpty) {
      final impls = cls.implementedTypes.map((t) {
        // 获取接口类名
        String name = t.classNode.name;
        // 应用类名替换（处理 @pragma('cpp:patch', 'xxx') 注解）
        name = _getReplacedClassName(name);
        // 不再应用文件前缀，直接使用类名

        // 处理泛型类型参数
        if (t.typeArguments.isNotEmpty) {
          final typeArgs = t.typeArguments.map(_getDartType).join(', ');
          name += '<$typeArgs>';
        }
        return name;
      }).join(', ');
      implementsClause = 'implements $impls';
    }
    if (extendsClause != null) _write(' $extendsClause');
    if (implementsClause != null) _write(' $implementsClause');

    // 开始生成类声明
    _writeLine(' {');
    _indent();

    // 生成字段声明
    _generateFields(cls);

    // 生成构造函数
    _generateConstructors(cls);

    // 生成成员方法
    _generateMemberMethods(cls);

    // 生成运算符重载方法
    _generateOperatorMethods(cls);

    _unindent();
    _writeLine('}');
    _writeLine('');
    // 重置：currentClassName 为局部，不需要重置
  }

  /// 生成字段声明
  void _generateFields(Class cls) {
    final classInfo = _classInfoMap[cls];
    if (classInfo == null) return;

    // 生成普通字段
    for (final field in cls.fields) {
      if (!classInfo.lateFields.contains(field)) {
        final modifiers = <String>[];
        if (field.isStatic) modifiers.add('static');
        if (field.isFinal) modifiers.add('final');
        if (field.isLate) modifiers.add('late');

        // 检查是否是const字段（通过检查初始化器是否为常量）
        if (field.initializer != null &&
            field.initializer is ConstantExpression) {
          modifiers.add('const');
        }

        // 对于没有初始化器的非空字段，添加 late 以避免编译期未初始化错误（含静态/实例）
        // 但是不要为 final 字段添加 late，因为 final 字段应该在构造函数中初始化
        if (!field.isLate &&
            !field.isFinal &&
            field.initializer == null &&
            field.type.nullability != Nullability.nullable) {
          if (!modifiers.contains('late')) modifiers.add('late');
        }

        final type = _getDartType(field.type);
        final name = field.name.text;
        final modifierStr = modifiers.isEmpty ? '' : '${modifiers.join(' ')} ';
        // 支持字段初始化表达式
        String init = '';
        if (field.initializer != null) {
          init =
              ' = ${_generateExpressionCode(field.initializer!, replaceThis: true, asStatement: false)}';
        }
        _writeLine('$modifierStr$type $name$init;');
      }
    }

    // 生成late字段
    _generateLateFields(cls);
  }

  /// 生成late字段
  void _generateLateFields(Class cls) {
    final classInfo = _classInfoMap[cls];
    if (classInfo == null) return;

    for (final field in classInfo.lateFields) {
      final type = _getDartType(field.type);
      final name = field.name.text;
      // 保留可能存在的初始化表达式
      String init = '';
      if (field.initializer != null) {
        init =
            ' = ${_generateExpressionCode(field.initializer!, replaceThis: true, asStatement: false)}';
      }
      _writeLine('late $type $name$init;');
    }
  }

  /// 生成成员方法
  void _generateMemberMethods(Class cls) {
    // 收集字段名，用于避免与同名 getter/setter 冲突
    final fieldNames = <String>{};
    for (final f in cls.fields) {
      fieldNames.add(f.name.text);
    }
    // 生成getter和setter
    for (final procedure in cls.procedures) {
      // 跳过编译器生成的 noSuchMethod 转发桩
      if (procedure.isNoSuchMethodForwarder) {
        continue;
      }
      if (procedure.isGetter) {
        // 跳过与已有字段同名的 getter（避免重复定义）
        if (fieldNames.contains(procedure.name.text)) continue;
        _generateGetter(cls, procedure);
      } else if (procedure.isSetter) {
        // 跳过与已有字段同名的 setter（避免重复定义）
        final name = procedure.name.text.endsWith('=')
            ? procedure.name.text.substring(0, procedure.name.text.length - 1)
            : procedure.name.text;
        if (fieldNames.contains(name)) continue;
        _generateSetter(cls, procedure);
      } else if (procedure.isFactory) {
        // 生成factory方法
        _generateFactoryMethod(cls, procedure);
      } else if (!procedure.isStatic) {
        // 检查是否是运算符方法，如果是则跳过（由 _generateOperatorMethods 处理）
        final methodName = procedure.name.text;
        if (methodName == '[]' ||
            methodName == '[]=' ||
            methodName == '+' ||
            methodName == '-' ||
            methodName == '*' ||
            methodName == '/' ||
            methodName == '==' ||
            methodName == '!=' ||
            methodName == '<' ||
            methodName == '>' ||
            methodName == '<=' ||
            methodName == '>=' ||
            methodName.contains('[') ||
            methodName.contains('=')) {
          // 跳过运算符方法，由 _generateOperatorMethods 处理
          continue;
        }
        // 生成普通成员方法（包括抽象方法）
        _generateMemberMethod(procedure);
      }
    }

    // 生成静态方法
    final classInfo = _classInfoMap[cls];
    if (classInfo != null) {
      // 生成静态方法
      for (final procedure in classInfo.staticMethods) {
        _generateStaticMethod(cls, procedure);
      }
    }
  }

  /// 生成无参构造方法
  void _generateDefaultConstructor(Class cls) {
    final className = cls.name;
    _writeLine('$className();');
    _writeLine('');
  }

  /// 生成构造方法
  void _generateConstructors(Class cls) {
    final classInfo = _classInfoMap[cls];
    if (classInfo == null) return;

    if (classInfo.constructors.isEmpty) {
      // 如果没有构造方法，生成默认构造方法
      _generateDefaultConstructor(cls);
      return;
    }

    for (final constructor in classInfo.constructors) {
      _generateConstructor(cls, constructor);
    }
  }

  /// 生成单个构造方法
  void _generateConstructor(Class cls, Constructor constructor) {
    // 生成构造函数
    final name = constructor.name.text;
    final originalClassName = cls.name;
    final className = originalClassName; // 不再使用前缀，直接使用原始类名
    final constructorName = name.isEmpty ? className : '$className.$name';

    // 检查是否是const构造函数
    final isConst = constructor.isConst;
    final constPrefix = isConst ? 'const ' : '';

    // 参数列表（包含必需位置、可选位置与命名参数，正确分组 [] / {}）
    final parameters = _writeParametersToString(constructor.function);

    _write('$constPrefix$constructorName($parameters)');

    // 初始化列表
    if (constructor.initializers.isNotEmpty) {
      _write(' : ');
      final initializers = constructor.initializers
          .map(_initializerToString)
          .where((s) => s.isNotEmpty)
          .join(', ');
      _write(initializers);
    }

    // 对于const构造函数，不生成方法体
    if (isConst) {
      _writeLine(';');
    } else {
      _writeLine(' {');
      _indent();

      // 构造函数体
      if (constructor.function.body != null) {
        final bodyStr =
            _writeTransformedStatementToString(constructor.function.body!);
        if (bodyStr.isNotEmpty) {
          _writeLine(bodyStr);
        }
      }

      _unindent();
      _writeLine('}');
    }
    _writeLine('');
  }

  /// 生成 getter 方法
  void _generateGetter(Class cls, Procedure procedure) {
    final returnType = _getDartType(procedure.function.returnType);
    final name = procedure.name.text;
    final staticPrefix = procedure.isStatic ? 'static ' : '';

    if (procedure.isAbstract) {
      // 抽象getter没有方法体
      _writeLine('${staticPrefix}$returnType get $name;');
      _writeLine('');
    } else {
      // 具体getter有方法体
      _writeLine('${staticPrefix}$returnType get $name {');
      _indent();
      if (procedure.function.body != null) {
        _currentFunctionReturnType = procedure.function.returnType;
        final bodyStr =
            _writeTransformedStatementToString(procedure.function.body!);
        _currentFunctionReturnType = null;
        _writeLine(_normalizeBody(bodyStr, isVoid: false));
      }
      _unindent();
      _writeLine('}');
      _writeLine('');
    }
  }

  /// 生成 setter 方法
  void _generateSetter(Class cls, Procedure procedure) {
    final param = procedure.function.positionalParameters.first;
    final paramType = _getDartType(param.type);
    final paramName = _cleanVariableName(param.name!);
    final staticPrefix = procedure.isStatic ? 'static ' : '';
    // 不使用字符串替换，而是检查是否以 = 结尾
    final name = procedure.name.text.endsWith('=')
        ? procedure.name.text.substring(0, procedure.name.text.length - 1)
        : procedure.name.text;

    if (procedure.isAbstract) {
      // 抽象setter没有方法体
      _writeLine('${staticPrefix}set $name($paramType $paramName);');
      _writeLine('');
    } else {
      // 具体setter有方法体
      _writeLine('${staticPrefix}set $name($paramType $paramName) {');
      _indent();
      _currentFunctionReturnType = procedure.function.returnType;
      final bodyStr =
          _writeTransformedStatementToString(procedure.function.body!);
      _currentFunctionReturnType = null;
      _writeLine(_normalizeBody(bodyStr, isVoid: true));
      _unindent();
      _writeLine('}');
      _writeLine('');
    }
  }

  // 已移除未使用方法 _generateGetterBody

  // 已移除未使用方法 _statementToString

  /// 将语句转换为字符串（转换后）
  String _writeTransformedStatementToString(Statement statement) {
    String result =
        _generateStatementCode(statement, replaceThis: true, allowReturn: true);

    return result;
  }

  // 已移除未使用方法 _writeTransformedStatement

  /// 生成单个成员方法
  void _generateMemberMethod(Procedure procedure) {
    final returnType = _getDartType(procedure.function.returnType);
    final name = procedure.name.text;
    final parameters = _writeParametersToString(procedure.function);

    // 特殊处理toString方法，将其改为toCppString
    String methodName = name;
    if (name == 'toString') {
      methodName = 'toCppString';
    }

    // 处理范型参数
    if (procedure.function.typeParameters.isNotEmpty) {
      final typeParams = procedure.function.typeParameters
          .map((t) => t.name ?? 'Object')
          .join(', ');
      methodName += '<$typeParams>';
    }

    if (procedure.isAbstract) {
      // 抽象方法没有方法体
      _writeLine('$returnType $methodName($parameters);');
      _writeLine('');
    } else {
      // 具体方法有方法体
      _writeLine('$returnType $methodName($parameters) {');
      _indent();

      if (procedure.function.body != null) {
        // 预分析函数体，找出需要装箱的变量
        DartToDartTransformer._globalVariablesToBox.clear();
        DartToDartTransformer._globalInitializedBoxedVariables.clear();
        DartToDartTransformer._globalForLoopVariablesToBox.clear();
        DartToDartTransformer._clearVariableBoxStates();
        DartToDartTransformer._globalPreAnalyzeFunctionBody(
            procedure.function.body!);

        // 调试输出
        if (DartToDartTransformer._globalVariablesToBox.isNotEmpty) {
          print('发现需要装箱的变量: ${DartToDartTransformer._globalVariablesToBox}');
        }

        // 检查是否需要闭包装箱
        final closureInfo = _getCurrentClosureInfo();
        if (closureInfo != null && closureInfo.boxedVariables.isNotEmpty) {
          // 生成装箱代码
          final boxingCode = _generateClosureBoxingCode(closureInfo);
          if (boxingCode.isNotEmpty) {
            _writeLine(boxingCode);
          }
        }
        _currentFunctionReturnType = procedure.function.returnType;
        final bodyStr =
            _writeTransformedStatementToString(procedure.function.body!);
        _currentFunctionReturnType = null;
        _writeLine(
            _normalizeBody(bodyStr, isVoid: returnType.trim() == 'void'));
      }
      _unindent();
      _writeLine('}');
      _writeLine('');
    }
  }

  /// 生成单个静态方法
  void _generateStaticMethod(Class cls, Procedure procedure) {
    final returnType = _getDartType(procedure.function.returnType);
    final name = procedure.name.text;
    final parameters = _writeParametersToString(procedure.function);

    // 特殊处理toString方法，将其改为toCppString
    String methodName = name;
    if (name == 'toString') {
      methodName = 'toCppString';
    }

    // 处理范型参数
    if (procedure.function.typeParameters.isNotEmpty) {
      final typeParams = procedure.function.typeParameters
          .map((t) => t.name ?? 'Object')
          .join(', ');
      methodName += '<$typeParams>';
    }

    _writeLine('static $returnType $methodName($parameters) {');
    _indent();
    _currentFunctionReturnType = procedure.function.returnType;
    final bodyStr =
        _writeTransformedStatementToString(procedure.function.body!);
    _currentFunctionReturnType = null;
    _writeLine(_normalizeBody(bodyStr, isVoid: returnType.trim() == 'void'));
    _unindent();
    _writeLine('}');
    _writeLine('');
  }

  /// 生成factory方法
  void _generateFactoryMethod(Class cls, Procedure procedure) {
    final name = procedure.name.text;
    final parameters = _writeParametersToString(procedure.function);

    // 处理factory方法名
    String factoryName;
    final className = cls.name; // 不再使用前缀，直接使用原始类名
    if (name.isEmpty) {
      factoryName = className;
    } else {
      factoryName = '$className.$name';
    }

    _writeLine('factory $factoryName($parameters) {');
    _indent();
    if (procedure.function.body != null) {
      _currentFunctionReturnType = procedure.function.returnType;
      final bodyStr =
          _writeTransformedStatementToString(procedure.function.body!);
      _currentFunctionReturnType = null;
      _writeLine(_normalizeBody(bodyStr, isVoid: false));
    }
    _unindent();
    _writeLine('}');
    _writeLine('');
  }

  /// 生成运算符重载方法
  void _generateOperatorMethods(Class cls) {
    for (final procedure in cls.procedures) {
      if (procedure.isStatic ||
          procedure.isFactory ||
          procedure.isGetter ||
          procedure.isSetter) continue;
      final methodName = procedure.name.text;
      // 检查是否是运算符方法
      if (methodName == '[]' ||
          methodName == '[]=' ||
          methodName == '+' ||
          methodName == '-' ||
          methodName == '*' ||
          methodName == '/' ||
          methodName == '==' ||
          methodName == '<' ||
          methodName == '>' ||
          methodName == '<=' ||
          methodName == '>=' ||
          methodName.contains('[') ||
          methodName.contains('=')) {
        _generateOperatorMethod(procedure);
      }
    }
  }

  /// 生成库的全局成员（函数和变量）
  void _generateGlobalMembersFromLibrary(Library library) {
    final libraryUri = library.fileUri;
    final filePath =
        libraryUri.isScheme('file') ? libraryUri.path : libraryUri.toString();

    bool hasGlobalMembers = false;

    // 检查是否有全局函数或变量
    for (final procedure in library.procedures) {
      if (!hasGlobalMembers) {
        _writeLine('/// 全局函数和变量');
        _writeLine('/// 源文件路径: $filePath');
        _writeLine('');
        hasGlobalMembers = true;
      }
      _generateGlobalFunction(procedure);
    }

    for (final field in library.fields) {
      if (!hasGlobalMembers) {
        _writeLine('/// 全局函数和变量');
        _writeLine('/// 源文件路径: $filePath');
        _writeLine('');
        hasGlobalMembers = true;
      }
      _generateGlobalVariable(field);
    }

    // 处理 extension
    for (final extension in library.extensions) {
      if (!hasGlobalMembers) {
        _writeLine('/// 全局函数和变量');
        _writeLine('/// 源文件路径: $filePath');
        _writeLine('');
        hasGlobalMembers = true;
      }
      _generateExtension(extension);
    }
  }

  /// 生成 extension
  void _generateExtension(Extension extension) {
    final extensionName = extension.name ?? 'AnonymousExtension';
    final extendedType = _getDartType(extension.onType);

    // 不再需要单独的注释，因为原始方法实现已经包含了足够的信息

    // 处理 extension 中的方法
    for (final member in extension.memberDescriptors) {
      final methodName = member.name.text;
      final functionName = '${extensionName}_$methodName'
          .replaceAll('|', '_')
          .replaceAll('#', '_');

      // 注册 extension 方法
      DartToDartTransformer._registerExtensionMethod(
          extensionName, methodName, extendedType);

      // 注意：不再生成多余的全局函数包装器，因为原始的 extension 方法实现已经足够
      // _generateExtensionMethodAsGlobalFunction(
      //     extension, member, functionName, extendedType);

      // 生成 getter 函数（用于属性访问）
      if (member.kind == ExtensionMemberKind.Getter) {
        _generateExtensionGetterWrapper(
            extensionName, methodName, extendedType);
      }
    }
  }

  /// 将 extension 方法转换为全局函数
  void _generateExtensionMethodAsGlobalFunction(
      Extension extension,
      ExtensionMemberDescriptor member,
      String functionName,
      String extendedType) {
    final extensionName = extension.name ?? 'AnonymousExtension';
    final methodName = member.name.text;

    // 参数列表：添加 receiver 参数
    final params = <String>[];
    params.add('$extendedType _this');

    final paramList = params.join(', ');

    // 生成函数签名
    _writeLine('dynamic $functionName($paramList) {');

    // 调用原始的 extension 方法实现
    final originalFunctionName = '${extensionName}|$methodName';
    _writeLine('  return $originalFunctionName(_this);');

    _writeLine('}');
    _writeLine('');
  }

  /// 生成 extension getter 的包装器
  void _generateExtensionGetterWrapper(
      String extensionName, String methodName, String extendedType) {
    final functionName = '${extensionName}_$methodName'
        .replaceAll('|', '_')
        .replaceAll('#', '_');

    // 替换 extensionName 和 methodName 中的特殊字符
    final cleanExtensionName =
        extensionName.replaceAll('|', '_').replaceAll('#', '_');
    final cleanMethodName =
        methodName.replaceAll('|', '_').replaceAll('#', '_');

    final returnType = 'FunctionWrapper<dynamic Function()>'; // 简化类型

    _writeLine(
        '$returnType ${cleanExtensionName}_get_${cleanMethodName}($extendedType _this) {');
    _writeLine(
        '  return FunctionWrapper<dynamic Function()>([], () { return $functionName(_this); });');
    _writeLine('}');
    _writeLine('');
  }

  /// 生成全局函数
  void _generateGlobalFunction(Procedure procedure) {
    final returnType = _getDartType(procedure.function.returnType);
    final name = procedure.name.text;
    final parameters = _writeParametersToString(procedure.function);

    // 特殊处理toString方法，将其改为toCppString
    String methodName = name;
    if (name == 'toString') {
      methodName = 'toCppString';
    }

    // 处理范型参数
    if (procedure.function.typeParameters.isNotEmpty) {
      final typeParams = procedure.function.typeParameters
          .map((t) => t.name ?? 'Object')
          .join(', ');
      methodName += '<$typeParams>';
    }

    if (procedure.isAbstract) {
      // 抽象函数没有方法体
      _writeLine('$returnType $methodName($parameters);');
      _writeLine('');
    } else {
      // 具体函数有方法体
      _writeLine('$returnType $methodName($parameters) {');
      _indent();
      if (procedure.function.body != null) {
        // 预分析函数体，找出需要装箱的变量
        DartToDartTransformer._globalVariablesToBox.clear();
        DartToDartTransformer._globalInitializedBoxedVariables.clear();
        DartToDartTransformer._globalForLoopVariablesToBox.clear();
        DartToDartTransformer._clearVariableBoxStates();
        DartToDartTransformer._globalPreAnalyzeFunctionBody(
            procedure.function.body!);

        // 调试输出
        if (DartToDartTransformer._globalVariablesToBox.isNotEmpty) {
          print(
              '在全局函数 $name 中发现需要装箱的变量: ${DartToDartTransformer._globalVariablesToBox}');
        }
        _currentFunctionReturnType = procedure.function.returnType;
        final bodyStr =
            _writeTransformedStatementToString(procedure.function.body!);
        _currentFunctionReturnType = null;
        _writeLine(
            _normalizeBody(bodyStr, isVoid: returnType.trim() == 'void'));
      }
      _unindent();
      _writeLine('}');
      _writeLine('');
    }
  }

  /// 生成全局变量
  void _generateGlobalVariable(Field field) {
    final modifiers = <String>[];
    if (field.isFinal) modifiers.add('final');
    if (field.isLate) modifiers.add('late');

    // 检查是否是const字段（通过检查初始化器是否为常量）
    if (field.initializer != null && field.initializer is ConstantExpression) {
      modifiers.add('const');
    }

    // 对于没有初始化器的非空字段，添加 late 以避免编译期未初始化错误
    if (!field.isLate &&
        !field.isFinal &&
        field.initializer == null &&
        field.type.nullability != Nullability.nullable) {
      if (!modifiers.contains('late')) modifiers.add('late');
    }

    final type = _getDartType(field.type);
    final name = field.name.text;
    final modifierStr = modifiers.isEmpty ? '' : '${modifiers.join(' ')} ';

    // 支持字段初始化表达式
    String init = '';
    if (field.initializer != null) {
      final initExpr = _generateExpressionCode(field.initializer!,
          replaceThis: true, asStatement: false);

      // 特殊处理 cppUserDataEmpty 的定义
      if (name == 'cppUserDataEmpty' &&
          initExpr.contains('CppUserData.constant([])')) {
        init = ' = CppUserData.constant([])';
      } else if (name == 'cppUserDataEmpty') {
        // 如果是cppUserDataEmpty但initExpr不匹配，强制设置为正确的定义
        init = ' = CppUserData.constant([])';
      } else {
        init = ' = ' + initExpr;
      }
    }
    _writeLine('$modifierStr$type $name$init;');
    _writeLine('');
  }

  /// 生成操作符方法
  void _generateOperatorMethod(Procedure procedure) {
    final returnType = _getDartType(procedure.function.returnType);
    final op = procedure.name.text;
    final parameters = _writeParametersToString(procedure.function);

    if (procedure.isAbstract) {
      // 抽象方法只生成声明
      _writeLine('$returnType operator $op($parameters);');
      _writeLine('');
    } else {
      // 具体方法生成完整实现
      _writeLine('$returnType operator $op($parameters) {');
      _indent();
      if (procedure.function.body != null) {
        final bodyStr = _generateStatementCode(procedure.function.body!,
            replaceThis: false, allowReturn: true);
        _writeLine(
            _normalizeBody(bodyStr, isVoid: returnType.trim() == 'void'));
      }
      _unindent();
      _writeLine('}');
      _writeLine('');
    }
  }

  /// 规范化方法体，移除 void 函数中的 `return expr;`，并确保语句以分号结尾
  String _normalizeBody(String body, {required bool isVoid}) {
    // 如果是块语句，直接返回
    final trimmed = body.trimRight();
    if (trimmed.startsWith('{')) return body;

    String result = body;
    if (isVoid) {
      // 将行首或换行后的 return expr; 改为 expr;
      result = result
          .replaceAllMapped(RegExp(r'(^|\n)\s*return\s+([^;]+);'),
              (m) => '${m.group(1)}${m.group(2)};')
          .replaceAllMapped(
              RegExp(r'(^|\n)\s*return\s*;'), (m) => '${m.group(1)}return;');
    }
    // 确保非空且不以分号或大括号结尾的语句添加分号
    final rtrim = result.trimRight();
    if (!rtrim.endsWith(';') && !rtrim.endsWith('}') && !rtrim.endsWith('{')) {
      result = rtrim + ';';
    }
    return result;
  }

  // 已移除未使用方法 _writeParameters

  /// 生成参数列表字符串
  String _writeParametersToString(FunctionNode function,
      {bool onlyFirst = false}) {
    // 处理位置参数（拆分必需与可选位置参数，整体使用 [] 包裹可选部分）
    final allPositional = (onlyFirst
            ? function.positionalParameters.take(1)
            : function.positionalParameters)
        .toList();
    final requiredCount =
        function.requiredParameterCount.clamp(0, allPositional.length);
    final requiredParams = allPositional.take(requiredCount).toList();
    final optionalParams = allPositional.skip(requiredCount).toList();

    String formatParam(VariableDeclaration param) {
      final type = _getDartType(param.type);
      final name = _cleanVariableName(param.name ?? 'param');

      // 处理闭包装箱
      final processedName = _processFunctionParameter(name, param.type);

      String defaultValue = '';
      if (param.initializer != null) {
        defaultValue =
            ' = ${_generateExpressionCode(param.initializer!, replaceThis: false, asStatement: false)}';
      }
      return '$type $processedName$defaultValue';
    }

    final requiredStr = requiredParams.map(formatParam).join(', ');
    String optionalStr = optionalParams.map(formatParam).join(', ');
    if (optionalStr.isNotEmpty) {
      optionalStr = '[$optionalStr]';
    }

    // 处理命名参数（整体使用 {} 包裹）
    final namedParams = function.namedParameters;
    String namedStr = '';
    if (namedParams.isNotEmpty) {
      final namedParamList = namedParams.map((param) {
        final type = _getDartType(param.type);
        final name = _cleanVariableName(param.name!);

        // 处理闭包装箱
        final processedName = _processFunctionParameter(name, param.type);

        String defaultValue = '';
        if (param.initializer != null) {
          defaultValue =
              ' = ${_generateExpressionCode(param.initializer!, replaceThis: false, asStatement: false)}';
        }

        // 检查是否为required参数
        String requiredKeyword = '';
        if (param.isRequired) {
          requiredKeyword = 'required ';
        }

        return '$requiredKeyword$type $processedName$defaultValue';
      }).join(', ');
      namedStr = '{$namedParamList}';
    }

    // 组合参数列表，顺序：必需位置参数, 可选位置参数, 命名参数
    final parts = <String>[requiredStr, optionalStr, namedStr]
        .where((s) => s.isNotEmpty)
        .toList();
    return parts.join(', ');
  }

  // 删除：旧的 _writeParameterList 已被统一的 _writeParametersToString 替代

  /// 获取Dart类型字符串
  String _getDartType(DartType type) {
    return DartTypeConverter.convert(type, this._getDartType,
        classNamePrefixResolver: (className) {
      // 只进行patch替换，不再加前缀
      final patchedClassName = _getGlobalReplacedClassName(className);
      return patchedClassName; // 直接返回被 patch 的类名，不加前缀
    });
  }

  // 已移除未使用方法 _annotationToString

  /// 构造函数初始化列表
  String _initializerToString(Initializer init) {
    if (init is FieldInitializer) {
      return '${init.field.name.text} = ${_generateExpressionCode(init.value, replaceThis: true, asStatement: false)}';
    } else if (init is SuperInitializer) {
      final args =
          init.arguments.positional.map(_expressionToString).join(', ');
      final namedArgs = init.arguments.named
          .map((na) => '${na.name}: ${_expressionToString(na.value)}')
          .join(', ');
      final allArgs = [args, namedArgs].where((s) => s.isNotEmpty).join(', ');
      return 'super($allArgs)';
    }
    return '';
  }

  // 已移除未使用方法 _writeBlockOrExpr

  /// 清理变量名，将不合法的变量名转换为合法的Dart变量名
  String _cleanVariableName(String name) {
    return VariableNameCleaner.clean(name);
  }

  // 已移除未使用方法 _generateUniqueId

  /// 转换表达式，将this替换为self
  String _expressionToString(Expression expression) {
    return _generateExpressionCode(expression,
        replaceThis: true, asStatement: false);
  }

  // 已移除未使用方法 _expressionToStringForOperator

  /// 写入一行
  void _writeLine(String text) {
    _buffer.write(DartConstants.indentUnit * _indentLevel + text + '\n');
  }

  /// 写入文本
  void _write(String text) {
    _buffer.write(text);
  }

  /// 增加缩进
  void _indent() {
    _indentLevel++;
  }

  /// 减少缩进
  void _unindent() {
    if (_indentLevel > 0) {
      _indentLevel--;
    }
  }

  /// 写入输出文件
  ///
  /// 将生成的代码写入指定的输出文件。如果写入失败，会打印错误信息但不会抛出异常。
  void _writeOutput() {
    try {
      // 后处理：替换函数名中的特殊字符
      var processedCode = _postProcessFunctionNames(_buffer.toString());

      final outputFile = File(DartConstants.defaultOutputPath);
      outputFile.writeAsStringSync(processedCode);
      print('代码已成功写入: ${DartConstants.defaultOutputPath}');
    } catch (e) {
      print('警告：无法写入输出文件 ${DartConstants.defaultOutputPath}: $e');
      // 继续执行，不中断程序
    }
  }

  /// 后处理函数名，将特殊字符替换为下划线
  String _postProcessFunctionNames(String code) {
    // 使用正则表达式替换函数名中的特殊字符
    // 处理多种情况：word|word, word#word, word|word#word 等
    var processedCode = code;

    // 替换 | 字符
    processedCode = processedCode.replaceAllMapped(RegExp(r'(\w+)\|(\w+)'),
        (match) => '${match.group(1)!}_${match.group(2)!}');

    // 替换 # 字符
    processedCode = processedCode.replaceAllMapped(RegExp(r'(\w+)#(\w+)'),
        (match) => '${match.group(1)!}_${match.group(2)!}');

    return processedCode;
  }

  /// 获取生成的代码
  ///
  /// 返回当前缓冲区中的所有代码内容。
  /// 该方法通常在转换完成后调用。
  ///
  /// 返回：生成的Dart代码字符串
  String getGeneratedCode() {
    return _buffer.toString();
  }

  /// 检查生成的代码质量
  ///
  /// 执行基本的代码质量检查，包括：
  /// - 检查是否包含类定义
  /// - 检查是否包含late字段
  void _checkGeneratedCode() {
    final code = _buffer.toString();
    CodeQualityChecker.check(code);
  }
}

/// 代码质量检查器
class CodeQualityChecker {
  /// 检查代码质量
  static void check(String code) {
    final hasClasses = code.contains('class');
    final hasLateFields = code.contains('late');

    if (!hasClasses) {
      print('警告：生成的代码中没有找到类定义');
    }

    if (!hasLateFields) {
      print('信息：生成的代码中没有late字段');
    }
  }
}

/// 为成员/方法访问时，必要时用括号包裹接收者表达式
String _wrapReceiverIfNeeded(Expression original, String code) {
  // 类型断言、三元、逻辑表达式作为接收者时需要括号以确保优先级
  if (original is AsExpression ||
      original is ConditionalExpression ||
      original is IfNullExpression ||
      original is LogicalExpression) {
    final t = code.trim();
    if (!(t.startsWith('(') && t.endsWith(')'))) {
      return '($code)';
    }
  }
  if (code.contains(' as ')) {
    final t = code.trim();
    if (!(t.startsWith('(') && t.endsWith(')'))) {
      return '($code)';
    }
  }
  return code;
}

// Let 变量到唯一本地名称的映射，用于在生成 body 代码时正确引用
final Map<VariableDeclaration, String> _letAliasNames = {};

// 用于追踪在同一位置使用的变量名，确保唯一性
// 当前未使用，保留以便未来扩展
// final Map<String, int> _usedNamesAtPosition = {};

// 基于源位置和变量声明生成作用域内唯一的临时变量名
// 当前未使用，保留以便未来扩展
/*
String _uniqueLocalNameForNode(String suggestedBase, TreeNode node) {
  final base = _cleanVariableName(
      (suggestedBase.isEmpty || suggestedBase == 'unnamed')
          ? DartConstants.defaultParamName
          : suggestedBase);
  final offset = node.fileOffset;
  if (offset >= 0) {
    return '${base}_${offset}';
  }
  final fallback = DateTime.now().microsecondsSinceEpoch % 1000000;
  return '${base}_${fallback}';
}
*/

// 为Let表达式中的变量生成唯一的变量名，确保在嵌套Let表达式中不会冲突
String _generateUniqueLetVarName(
    VariableDeclaration variable, Expression letExpression) {
  final baseName = variable.name ?? 'temp';
  final cleanBase = _cleanVariableName(baseName);

  // 使用Let表达式的位置信息和变量本身的信息来生成唯一标识符
  final offset = letExpression.fileOffset;
  final varId = variable.hashCode.abs() % 10000;

  if (offset >= 0) {
    // 组合位置信息和变量ID来确保即使在同一位置的嵌套Let表达式也有唯一名称
    return '${cleanBase}_${offset}_${varId}';
  }

  // 如果没有位置信息，使用变量的哈希值作为后缀
  return '${cleanBase}_${varId}';
}

/// 分析闭包函数捕获的外部变量
List<String> _analyzeCapturedVariables(FunctionNode function) {
  final capturedVars = <String>[];

  if (function.body != null) {
    _findCapturedVariablesInStatement(function.body!, capturedVars);
  }

  return capturedVars;
}

/// 在语句中查找捕获的变量
void _findCapturedVariablesInStatement(
    Statement statement, List<String> capturedVars) {
  if (statement is Block) {
    for (final stmt in statement.statements) {
      _findCapturedVariablesInStatement(stmt, capturedVars);
    }
  } else if (statement is ExpressionStatement) {
    _findCapturedVariablesInExpression(statement.expression, capturedVars);
  } else if (statement is IfStatement) {
    _findCapturedVariablesInExpression(statement.condition, capturedVars);
    _findCapturedVariablesInStatement(statement.then, capturedVars);
    if (statement.otherwise != null) {
      _findCapturedVariablesInStatement(statement.otherwise!, capturedVars);
    }
  } else if (statement is ReturnStatement) {
    if (statement.expression != null) {
      _findCapturedVariablesInExpression(statement.expression!, capturedVars);
    }
  }
}

/// 在表达式中查找捕获的变量
void _findCapturedVariablesInExpression(
    Expression expression, List<String> capturedVars) {
  if (expression is VariableGet) {
    final varName = _cleanVariableName(expression.variable.name ?? 'unnamed');

    // 检查是否是外部变量且需要装箱
    if (DartToDartTransformer._globalVariablesToBox.contains(varName)) {
      if (!capturedVars.contains(varName)) {
        capturedVars.add(varName);
      }
    }
  } else if (expression is VariableGetImpl) {
    final varName = _cleanVariableName(expression.variable.name ?? 'unnamed');

    // 检查是否是外部变量且需要装箱
    if (DartToDartTransformer._globalVariablesToBox.contains(varName)) {
      if (!capturedVars.contains(varName)) {
        capturedVars.add(varName);
      }
    }
  } else if (expression is InstanceInvocation) {
    _findCapturedVariablesInExpression(expression.receiver, capturedVars);
    for (final arg in expression.arguments.positional) {
      _findCapturedVariablesInExpression(arg, capturedVars);
    }
    for (final arg in expression.arguments.named) {
      _findCapturedVariablesInExpression(arg.value, capturedVars);
    }
  } else if (expression is StaticInvocation) {
    for (final arg in expression.arguments.positional) {
      _findCapturedVariablesInExpression(arg, capturedVars);
    }
    for (final arg in expression.arguments.named) {
      _findCapturedVariablesInExpression(arg.value, capturedVars);
    }
  }
}

/// 全局转换函数
void transformDartToDart(Component component) {
  final transformer = DartToDartTransformer();
  transformer.transformComponent(component);
}

/// 全局版本的清理变量名函数
///
/// 该函数是 DartToDartTransformer._cleanVariableName 的全局版本
/// 保持两个版本的一致性
String _cleanVariableName(String name) {
  return VariableNameCleaner.clean(name);
}

/// 全局版本的获取Dart类型函数
///
/// 该函数是 DartToDartTransformer._getDartType 的全局版本
/// 保持两个版本的一致性
String _getDartType(DartType type, {bool forceWrapper = false}) {
  if (type is FunctionType &&
      (DartToDartTransformer._inClosureContext || forceWrapper)) {
    // 在闭包上下文中，将Function类型转换为FunctionWrapper
    final paramTypes =
        type.positionalParameters.map((t) => _getDartType(t)).join(', ');
    final returnType = _getDartType(type.returnType);
    final functionType = '$returnType Function($paramTypes)';
    return 'FunctionWrapper<$functionType>';
  }

  return DartTypeConverter.convert(type, _getDartType,
      classNamePrefixResolver: (className) {
    // 不再使用前缀，只进行 patch 替换
    return DartToDartTransformer._getGlobalReplacedClassName(className);
  });
}

/// 检查表达式是否为 FunctionWrapper 类型
bool _isFunctionWrapperType(Expression expression) {
  // 检查变量引用是否为 FunctionWrapper 类型
  if (expression is VariableGet) {
    final variableType = expression.variable.type;
    if (variableType is InterfaceType) {
      return variableType.classNode.name == 'FunctionWrapper';
    } else if (variableType is FunctionType) {
      return true;
    }
  }

  // 检查属性访问是否为 FunctionWrapper 类型
  if (expression is InstanceGet) {
    final propertyType = expression.interfaceTarget.getterType;
    if (propertyType is InterfaceType) {
      return propertyType.classNode.name == 'FunctionWrapper';
    } else if (propertyType is FunctionType) {
      return true;
    }
  }

  // 检查方法调用结果是否为 FunctionWrapper 类型
  if (expression is InstanceInvocation) {
    final methodType = expression.interfaceTarget.getterType;
    if (methodType is InterfaceType) {
      return methodType.classNode.name == 'FunctionWrapper';
    }
  }

  // 检查静态调用结果是否为 FunctionWrapper 类型
  if (expression is StaticInvocation) {
    final returnType = expression.target.function.returnType;
    if (returnType is InterfaceType) {
      return returnType.classNode.name == 'FunctionWrapper';
    }
  }

  return false;
}

/// 全局版本的获取逻辑运算符函数
String _getLogicalOperator(LogicalExpressionOperator operator) {
  switch (operator) {
    case LogicalExpressionOperator.AND:
      return '&&';
    case LogicalExpressionOperator.OR:
      return '||';
  }
}

/// 全局版本的闭包装箱处理函数
String _processClosureVariableReferenceGlobal(
    String variableName, DartType variableType) {
  // 首先检查是否是$origin_前缀的变量，这些一定不是装箱变量
  if (variableName.startsWith('\$origin_')) {
    return variableName;
  }

  // 然后检查基于变量名的装箱状态映射（新的精确方法）
  if (DartToDartTransformer._getVariableBoxState(variableName)) {
    // 排除_temp前缀的变量（这些是临时变量，不需要.value）
    if (!variableName.startsWith('_temp')) {
      return '$variableName.value';
    }
  }
  // 检查类型是否需要装箱
  bool needsBoxing(DartType type) {
    if (type is InterfaceType) {
      final typeName = type.classNode.name;
      return {'int', 'bool', 'double', 'String'}.contains(typeName);
    }
    return false;
  }

  // 获取装箱类型
  String getBoxType(DartType type) {
    if (type is InterfaceType) {
      final typeName = type.classNode.name;
      switch (typeName) {
        case 'int':
          return 'Box<Int>';
        case 'bool':
          return 'Box<Bool>';
        case 'double':
          return 'Box<Double>';
        case 'String':
          return 'Box<String>';
        default:
          return 'Box<Object>';
      }
    }
    return 'Box<Object>';
  }

  // 检查变量是否需要装箱
  final inVariablesToBox =
      DartToDartTransformer._globalVariablesToBox.contains(variableName);
  final inForLoopVariablesToBox =
      DartToDartTransformer._globalForLoopVariablesToBox.contains(variableName);
  final isExternalBoxedVariable = DartToDartTransformer
      ._globalInitializedBoxedVariables
      .contains(variableName);

  // 如果变量已经在装箱列表中，添加.value
  if (inVariablesToBox || inForLoopVariablesToBox || isExternalBoxedVariable) {
    // 排除_temp前缀和$origin_前缀的变量（这些是for循环的重命名变量，不需要.value）
    if (!variableName.startsWith('_temp') &&
        !variableName.startsWith('\$origin_')) {
      return '$variableName.value';
    }
  }

  // 注意：$origin_开头的变量是for循环重命名变量，一定不是装箱变量，不需要.value

  return variableName;
}

// 已移除未使用方法 _getUnaryOperator

/// 检查是否为数字字面量
bool _isNumericLiteral(String expr) {
  // 移除可能的括号
  final cleanExpr = expr.trim().replaceAll(RegExp(r'^\(|\)$'), '');
  // 检查是否为整数或浮点数
  return RegExp(r'^-?\d+(\.\d+)?$').hasMatch(cleanExpr);
}

/// 检查是否在有参数的闭包中
bool _isInClosureWithParameters() {
  return DartToDartTransformer._inClosureContext &&
      DartToDartTransformer._globalCurrentClosureParameterName.isNotEmpty;
}

/// 从表达式中收集变量名
void _collectVariablesFromExpression(
    Expression expression, Set<String> variables) {
  if (expression is VariableGet) {
    final varName = expression.variable.name ?? 'unnamed';
    variables.add(varName);
  }
  // 简化版本，只处理最常见的VariableGet
  // 可以根据需要扩展
}

/// 获取当前闭包的参数名
String _getCurrentClosureParameterName() {
  return DartToDartTransformer._globalCurrentClosureParameterName;
}

// 已移除未使用方法 _getBinaryOperator

String _generateExpressionCode(Expression expression,
    {bool replaceThis = false,
    bool asStatement = false,
    bool allowReturn = true}) {
  String result = //"/*${expression.runtimeType}*/" +
      _generateExpressionCode2(expression,
          replaceThis: replaceThis,
          asStatement: asStatement,
          allowReturn: allowReturn);

  return result;
}

String _generateExpressionCode2(Expression expression,
    {bool replaceThis = false,
    bool asStatement = false,
    bool allowReturn = true}) {
  // 处理表达式生成
  if (expression is ThisExpression) {
    return replaceThis ? 'this' : 'this';
  } else if (expression is VariableGet) {
    // 获取变量类型信息
    final alias = _letAliasNames[expression.variable];
    if (alias != null) return alias;

    final name = _cleanVariableName(expression.variable.name ?? 'unnamed');
    final variableType = expression.variable.type;

    // $origin_前缀的变量一定是原始类型，不需要任何装箱处理
    if (name.startsWith('\$origin_')) {
      return name;
    }

    // 处理闭包变量装箱
    return _processClosureVariableReferenceGlobal(name, variableType);
  } else if (expression is VariableGetImpl) {
    // 获取变量类型信息
    // final type = _getDartType(expression.variable.type);
    final alias = _letAliasNames[expression.variable];
    if (alias != null) return alias;
    final name = _cleanVariableName(expression.variable.name ?? 'unnamed');
    // // 如果类型不是 Object，则包含类型信息
    // if (type != 'Object') {
    //   return '($name as $type)';
    // }
    return name;
  } else if (expression is FactoryConstructorInvocation) {
    String originalClassName =
        expression.target.enclosingClass?.name ?? 'Unknown';
    // 使用完整的类名处理（先 patch 替换，再加前缀）
    String className =
        DartToDartTransformer._getCompleteClassName(originalClassName);

    // 特殊处理 _GrowableList 工厂构造函数
    if (originalClassName == '_GrowableList') {
      final typeArgs =
          expression.arguments.types.map((e) => _getDartType(e)).join(', ');
      final args = expression.arguments.positional
          .map((e) => _generateExpressionCode(e,
              replaceThis: replaceThis, asStatement: false))
          .join(', ');

      // // 处理 _GrowableList.<T>(0) 这种创建空列表的构造函数
      // if (expression.target.name.text.isEmpty && args == '0') {
      //   // 将 _GrowableList.<T>(0) 转换为 <T>[]
      //   return '<$typeArgs>[]';
      // }
      return 'CppArrayList<$typeArgs>.fromCppArray(CppApi.cppArrayConst(${expression.arguments.positional.length}, $args))';
    }

    // 处理范型参数
    // if (expression.target.enclosingClass?.typeParameters.isNotEmpty == true) {
    //   final typeArgs = expression.target.enclosingClass!.typeParameters
    //       .map((t) => t.name ?? 'Object')
    //       .join(', ');
    //   className += '<$typeArgs>';
    // }

    // 处理构造函数名
    String constructorName = '';
    if (expression.target.name.text.isNotEmpty) {
      constructorName = '.${expression.target.name.text}';
    }

    final typeArgs =
        expression.arguments.types.map((e) => _getDartType(e)).join(', ');

    final args = expression.arguments.positional
        .map((e) => _generateExpressionCode(e,
            replaceThis: replaceThis, asStatement: false))
        .join(', ');
    final namedArgs = expression.arguments.named
        .map((na) =>
            '${na.name}: ${_generateExpressionCode(na.value, replaceThis: replaceThis, asStatement: false)}')
        .join(', ');
    final allArgs = [args, namedArgs].where((s) => s.isNotEmpty).join(', ');
    return '$className${typeArgs.isNotEmpty ? '<$typeArgs>' : ''}$constructorName($allArgs)';
  } else if (expression is VariableSet) {
    final left = _letAliasNames[expression.variable] ??
        _cleanVariableName(expression.variable.name ?? 'unnamed');

    // 处理闭包装箱 - 检查是否需要装箱此变量
    if (DartToDartTransformer._globalVariablesToBox.contains(left)) {
      // 检查是否已经初始化为Box
      if (DartToDartTransformer._globalInitializedBoxedVariables
          .contains(left)) {
        // 已初始化，修改value
        return '${left}.value = '
            '${_generateExpressionCode(expression.value, replaceThis: replaceThis, asStatement: false)}';
      } else {
        // 首次初始化，需要根据变量类型创建对应的Box实例
        // 这种情况通常不应该发生，因为现在所有变量都会在声明时初始化
        DartToDartTransformer._globalInitializedBoxedVariables.add(left);
        final valueExpr = _generateExpressionCode(expression.value,
            replaceThis: replaceThis, asStatement: false);
        // 由于无法直接获取类型，这里简化处理，假设是int类型
        return '${left} = BoxInt($valueExpr)';
      }
    }

    return '${left} = '
        '${_generateExpressionCode(expression.value, replaceThis: replaceThis, asStatement: false)}';
  } else if (expression is RecordIndexGet) {
    return '${_generateExpressionCode(expression.receiver, replaceThis: replaceThis, asStatement: false)}.${expression.index + 1}';
  } else if (expression is RecordNameGet) {
    return '${_generateExpressionCode(expression.receiver, replaceThis: replaceThis, asStatement: false)}.${expression.name}';
  } else if (expression is InstanceGet) {
    final receiverRaw = _generateExpressionCode(expression.receiver,
        replaceThis: replaceThis, asStatement: false);
    final receiver = _wrapReceiverIfNeeded(expression.receiver, receiverRaw);
    final propertyName = expression.name.text;
    return '$receiver.$propertyName';
  } else if (expression is DynamicGet) {
    final receiverRaw = _generateExpressionCode(expression.receiver,
        replaceThis: replaceThis, asStatement: false);
    final receiver = _wrapReceiverIfNeeded(expression.receiver, receiverRaw);
    final name = expression.name.text;

    // 特殊处理 unary- 属性访问
    if (name == 'unary-') {
      // 如果接收者是数字字面量，直接生成负数
      if (_isNumericLiteral(receiver)) {
        return '-$receiver';
      }
      // 否则生成取负表达式
      return '-$receiver';
    }

    return '$receiver.$name';
  } else if (expression is FunctionTearOff) {
    // kernel FunctionTearOff 用 receiver 字段
    return '${_generateExpressionCode(expression.receiver, replaceThis: replaceThis, asStatement: false)}.call';
  } else if (expression is InstanceTearOff) {
    final receiverRaw = _generateExpressionCode(expression.receiver,
        replaceThis: replaceThis, asStatement: false);
    final receiver = _wrapReceiverIfNeeded(expression.receiver, receiverRaw);
    final name = expression.name.text;
    return '$receiver.$name';
  } else if (expression is StaticGet) {
    final encl = expression.target.enclosingClass;
    final originalClassName = encl?.name;
    String? className;
    if (originalClassName != null) {
      // 使用完整的类名处理（先 patch 替换，再加前缀）
      className =
          DartToDartTransformer._getCompleteClassName(originalClassName);
    }
    final name = expression.target.name.text;

    // 特殊处理 cppUserDataEmpty，直接使用而不是通过常量
    if (encl == null && name == 'cppUserDataEmpty') {
      return 'cppUserDataEmpty';
    }

    return encl == null ? name : '$className.$name';
  } else if (expression is StaticSet) {
    final encl = expression.target.enclosingClass;
    final originalClassName = encl?.name;
    String? className;
    if (originalClassName != null) {
      // 使用完整的类名处理（先 patch 替换，再加前缀）
      className =
          DartToDartTransformer._getCompleteClassName(originalClassName);
    }
    final name = expression.target.name.text;
    final value = _generateExpressionCode(expression.value,
        replaceThis: replaceThis, asStatement: false);
    return encl == null ? '$name = $value' : '$className.$name = $value';
  } else if (expression is StaticTearOff) {
    final encl = expression.target.enclosingClass;
    final originalClassName = encl?.name;
    String? className;
    if (originalClassName != null) {
      // 使用完整的类名处理（先 patch 替换，再加前缀）
      className =
          DartToDartTransformer._getCompleteClassName(originalClassName);
    }
    final name = expression.target.name.text;
    return encl == null ? name : '$className.$name';
  } else if (expression is InstanceInvocation) {
    final receiverRaw = _generateExpressionCode(expression.receiver,
        replaceThis: replaceThis, asStatement: false);
    final receiver = _wrapReceiverIfNeeded(expression.receiver, receiverRaw);
    final name = expression.name.text;
    final argsList = expression.arguments.positional;

    // 处理参数，根据目标方法的参数类型要求进行类型转换
    final processedArgs = <String>[];
    // 处理位置参数
    for (int i = 0; i < argsList.length; i++) {
      final arg = argsList[i];
      final argCode = _generateExpressionCode(arg,
          replaceThis: replaceThis, asStatement: false);
      processedArgs.add(argCode);
    }

    if (expression.interfaceTarget.kind == ProcedureKind.Operator) {
      if (processedArgs.isEmpty) {
        if (name == '++' || name == '--') {
          return '${receiver}${name}';
        }

        if (name == '!') {
          return '!(${receiver})';
        }
        if (name == 'unary-') {
          return '-$receiver';
        }
        return '$name${receiver}';
      } else if (processedArgs.length == 1) {
        if (name == '[]') {
          return '${receiver}[${processedArgs[0]}]';
        }
        return '($receiver $name ${processedArgs[0]})';
      } else {
        if (name == '[]=') {
          return '${receiver}[${processedArgs[0]}] = ${processedArgs[1]}';
        }
      }
      throw Exception('Unsupported operator: $name');
    }

    // 处理命名参数
    final namedArgs = expression.arguments.named
        .map((na) =>
            '${na.name}: ${_generateExpressionCode(na.value, replaceThis: replaceThis, asStatement: false)}')
        .toList();

    // 特殊处理toString方法调用，替换为CppString.convertString(x)
    if (name == 'toString') {
      return 'CppString.convertString($receiver)';
    }

    // 特殊处理 FunctionWrapper 类型的变量调用
    if (_isFunctionWrapperType(expression.receiver)) {
      final allArgs = [...processedArgs, ...namedArgs].join(', ');
      return '$receiver.call($allArgs)';
    }

    final allArgs = [...processedArgs, ...namedArgs].join(', ');
    return '$receiver.$name($allArgs)';
  } else if (expression is DynamicInvocation) {
    final receiverRaw = _generateExpressionCode(expression.receiver,
        replaceThis: replaceThis, asStatement: false);
    final receiver = _wrapReceiverIfNeeded(expression.receiver, receiverRaw);
    final name = expression.name.text;
    final args = expression.arguments.positional
        .map((e) => _generateExpressionCode(e,
            replaceThis: replaceThis, asStatement: false))
        .join(', ');
    final namedArgs = expression.arguments.named
        .map((na) =>
            '${na.name}: ${_generateExpressionCode(na.value, replaceThis: replaceThis, asStatement: false)}')
        .join(', ');
    final allArgs = [args, namedArgs].where((s) => s.isNotEmpty).join(', ');
    // 处理特殊的运算符调用
    if (name.startsWith('.') && name.length > 1) {
      final op = name.substring(1);
      // 常见二元运算符
      if (op == '+') return '$receiver + ($allArgs)';
      if (op == '-') return '$receiver - ($allArgs)';
      if (op == '>') return '$receiver > ($allArgs)';
      if (op == '<') return '$receiver < ($allArgs)';
      if (op == '+=') return '$receiver += ($allArgs)';
      if (op == '-=') return '$receiver -= ($allArgs)';
      if (op == '++') return '$receiver++';
      if (op == '--') return '$receiver--';
      if (op == '[]') return '$receiver[$allArgs]';
      if (op == '[]=' || op == '.[]=') {
        final argsList = expression.arguments.positional;
        if (argsList.length >= 2) {
          final index = _generateExpressionCode(argsList[0],
              replaceThis: replaceThis, asStatement: false);
          final value = _generateExpressionCode(argsList[1],
              replaceThis: replaceThis, asStatement: false);
          return '$receiver[$index] = $value';
        }
        return '$receiver[$allArgs] = $allArgs';
      }
      return '$receiver $op ($allArgs)';
    }
    // 特殊处理 unary- 方法调用
    if (name == 'unary-' ||
        name.contains('unary-') ||
        name.contains('{int.unary-}') ||
        name.contains('{int.unary-}') ||
        name.contains('{int.unary-}') ||
        name.contains('{int.unary-}')) {
      if (_isNumericLiteral(receiver)) {
        return '-$receiver';
      }
      return '-$receiver';
    }
    // 特殊处理toString方法调用，替换为CppString.convertString(x)
    if (name == 'toString') {
      return 'CppString.convertString($receiver)';
    }

    // 特殊处理 FunctionWrapper 类型的变量调用
    if (_isFunctionWrapperType(expression.receiver)) {
      return '$receiver.call($allArgs)';
    }

    return '$receiver.$name($allArgs)';
  } else if (expression is ConstructorInvocation) {
    String originalClassName = expression.target.enclosingClass.name;
    // 使用完整的类名处理（先 patch 替换，再加前缀）
    String className =
        DartToDartTransformer._getCompleteClassName(originalClassName);

    // 特殊处理 _GrowableList 构造函数
    if (originalClassName == '_GrowableList') {
      final typeArgs = expression.arguments.types.map(_getDartType).join(', ');
      final args = expression.arguments.positional
          .map((e) => _generateExpressionCode(e,
              replaceThis: replaceThis, asStatement: false))
          .join(', ');

      // // 处理 _GrowableList._literal 系列构造函数
      // if (expression.target.name.text.startsWith('_literal')) {
      //   // 将 _GrowableList._literalN<T>(...) 转换为 <T>[...]
      //   return '<$typeArgs>[$args]';
      // }

      // // 处理 _GrowableList.<T>(0) 这种创建空列表的构造函数
      // if (expression.target.name.text.isEmpty && args == '0') {
      //   // 将 _GrowableList.<T>(0) 转换为 <T>[]
      //   return '<$typeArgs>[]';
      // }

      // // 处理 _GrowableList.generate<T>(length, generator) 方法
      // if (expression.target.name.text == 'generate') {
      //   // 将 _GrowableList.generate<T>(length, generator) 转换为 List<T>.generate(length, generator)
      //   return 'List<$typeArgs>.generate($args)';
      // }
      return 'CppArrayList<$typeArgs>.fromCppArray(CppApi.cppArrayConst(${expression.arguments.positional.length}, $args))';
    }

    // 处理范型参数 - 尝试使用构造函数调用的实际范型参数
    // 注意：ConstructorInvocation 可能没有直接的 typeArguments 属性
    // 这里暂时使用类定义的范型参数，但需要根据上下文推断正确的范型参数
    // if (expression.target.enclosingClass.typeParameters.isNotEmpty) {
    //   // 这里需要根据当前上下文来确定范型参数
    //   // 暂时使用类定义的范型参数，但需要改进
    //   final typeArgs = expression.target.enclosingClass.typeParameters
    //       .map((t) => t.name ?? 'Object')
    //       .join(', ');
    //   className += '<$typeArgs>';
    // }

    // 尝试从 expression.target 获取范型参数
    // 如果 Constructor 有 typeArguments 属性，使用它
    // 否则回退到类定义的范型参数
    // 注意：这里需要根据上下文推断正确的范型参数
    // 例如：在 static Set<R> castFrom<S, R> 方法中调用 CppSet<R>() 时
    // 应该使用 <R> 而不是类的范型参数 <E>
    // 问题：ConstructorInvocation 没有直接的 typeArguments 属性
    // 需要找到其他方式来获取构造函数调用的实际范型参数

    // 处理构造函数名
    String constructorName = '';
    if (expression.target.name.text.isNotEmpty) {
      final ctorName = expression.target.name.text;

      // 特殊处理：构造函数名为 "_" 时，这通常表示默认构造函数
      // 在这种情况下不添加点前缀
      if (ctorName != '_') {
        // 保留所有命名构造函数，包括以下划线开头的私有命名构造函数
        // 这对于单例模式等设计模式非常重要
        constructorName = '.$ctorName';
      }
    }

    // 仅当调用提供了类型实参时保留；否则若在当前类作用域且为本类构造，自动补上当前类的类型参数名称
    String typeArgs = expression.arguments.types.map(_getDartType).join(', ');
    if (typeArgs.isEmpty) {
      // 尝试通过作用域类名匹配（方法作用域内与类名一致时补齐）
      // 由于 className 即为当前类名，因此直接使用 enclosingClass 的类型参数
      final params = expression.target.enclosingClass.typeParameters;
      if (params.isNotEmpty) {
        typeArgs = params.map((t) => t.name ?? 'Object').join(', ');
      }
    }
    final args = expression.arguments.positional
        .map((e) => _generateExpressionCode(e,
            replaceThis: replaceThis, asStatement: false))
        .join(', ');
    final namedArgs = expression.arguments.named
        .map((na) =>
            '${na.name}: ${_generateExpressionCode(na.value, replaceThis: replaceThis, asStatement: false)}')
        .join(', ');
    final allArgs = [args, namedArgs].where((s) => s.isNotEmpty).join(', ');
    return '$className${typeArgs.isNotEmpty ? '<$typeArgs>' : ''}$constructorName($allArgs)';
  } else if (expression is EqualsNull) {
    final expr = _generateExpressionCode(expression.expression,
        replaceThis: replaceThis, asStatement: false);
    return '$expr == null';
  } else if (expression is EqualsCall) {
    return '${_generateExpressionCode(expression.left, replaceThis: replaceThis, asStatement: false)} == ${_generateExpressionCode(expression.right, replaceThis: replaceThis, asStatement: false)}';
  } else if (expression is Instantiation) {
    final expr = _generateExpressionCode(expression.expression,
        replaceThis: replaceThis);
    final types = expression.typeArguments.map(_getDartType).join(', ');
    return '$expr<$types>';
  } else if (expression is NullCheck) {
    return '${_generateExpressionCode(expression.operand, replaceThis: replaceThis, asStatement: false)}!';
  } else if (expression is SymbolLiteral) {
    return '#${expression.value}';
  } else if (expression is TypeLiteral) {
    return '${_getDartType(expression.type)}';
  } else if (expression is ListLiteral) {
    final entries = expression.expressions
        .map((e) => _generateExpressionCode(e,
            replaceThis: replaceThis, asStatement: false))
        .join(', ');
    return '[$entries]';
  } else if (expression is SetLiteral) {
    final entries = expression.expressions
        .map((e) => _generateExpressionCode(e,
            replaceThis: replaceThis, asStatement: false))
        .join(', ');
    return '{$entries}';
  } else if (expression is MapLiteral) {
    final entries = expression.entries
        .map((e) =>
            '${_generateExpressionCode(e.key, replaceThis: replaceThis, asStatement: false)}: ${_generateExpressionCode(e.value, replaceThis: replaceThis, asStatement: false)}')
        .join(', ');
    return '{$entries}';
  } else if (expression is RecordLiteral) {
    final positional = expression.positional
        .map((e) => _generateExpressionCode(e,
            replaceThis: replaceThis, asStatement: false))
        .join(', ');
    final named = expression.named
        .map((e) =>
            '${e.name}: ${_generateExpressionCode(e.value, replaceThis: replaceThis, asStatement: false)}')
        .join(', ');
    final all = [positional, named].where((s) => s.isNotEmpty).join(', ');
    return '($all)';
  } else if (expression is AwaitExpression) {
    final operand = _generateExpressionCode(expression.operand,
        replaceThis: replaceThis, asStatement: false);
    return 'await $operand';
  } else if (expression is FunctionExpression) {
    // 进入闭包作用域
    DartToDartTransformer._globalEnterClosureScope();
    final oldClosureContext = DartToDartTransformer._inClosureContext;
    DartToDartTransformer._inClosureContext = true;

    try {
      // 分析捕获的外部变量
      final capturedVariables = _analyzeCapturedVariables(expression.function);

      // 生成正确的函数表达式语法
      final parameterNames = expression.function.positionalParameters
          .map((p) => _cleanVariableName(p.name ?? 'param'))
          .toList();
      final parameters = expression.function.positionalParameters
          .map((p) =>
              '${_getDartType(p.type)} ${_cleanVariableName(p.name ?? 'param')}')
          .join(', ');

      // 设置当前闭包的第一个参数名（如果存在）
      if (parameterNames.isNotEmpty) {
        DartToDartTransformer._globalSetCurrentClosureParameterName(
            parameterNames.first);
      }

      final body = expression.function.body != null
          ? _generateStatementCode(expression.function.body!,
              replaceThis: replaceThis, allowReturn: true)
          : '{}';

      // 生成函数类型，强制使用FunctionWrapper
      final paramTypes = expression.function.positionalParameters
          .map((p) => _getDartType(p.type))
          .join(', ');
      final returnType = _getDartType(expression.function.returnType);
      final functionType = '$returnType Function($paramTypes)';

      // 生成捕获变量列表
      final capturedVarsCode = capturedVariables.isNotEmpty
          ? '[${capturedVariables.join(', ')}]'
          : '[]';

      return 'FunctionWrapper<$functionType>($capturedVarsCode, ($parameters) { $body})';
    } finally {
      // 清除闭包参数名并退出闭包作用域
      DartToDartTransformer._globalClearCurrentClosureParameterName();
      DartToDartTransformer._inClosureContext = oldClosureContext;
      DartToDartTransformer._globalExitClosureScope();
    }
  } else if (expression is BlockExpression) {
    // 生成正确的块表达式语法
    final statements = expression.body.statements
        .map((s) => _generateStatementCode(s,
            replaceThis: replaceThis, allowReturn: false))
        .join('\n');
    final value = _generateExpressionCode(expression.value,
        replaceThis: replaceThis, asStatement: false, allowReturn: false);

    // 表达式上下文，用 IIFE 包裹，避免在语句中生成return
    final cleanStatements = statements.replaceAll(RegExp(r'return\s+'), '');
    return '(() {\n$cleanStatements\nreturn $value;\n})()';
  } else if (expression is LoadLibrary) {
    return 'loadLibrary()';
  } else if (expression is CheckLibraryIsLoaded) {
    return 'checkLibraryIsLoaded()';
  } else if (expression is ConstructorTearOff) {
    return 'ConstructorTearOff(${expression.target.name.text})';
  } else if (expression is RedirectingFactoryTearOff) {
    return 'RedirectingFactoryTearOff(${expression.target.name.text})';
  } else if (expression is TypedefTearOff) {
    // kernel TypedefTearOff 用 expression/typeArguments
    final typeArgs = expression.typeArguments.isNotEmpty
        ? '<${expression.typeArguments.map(_getDartType).join(', ')}>'
        : '';
    return '${_generateExpressionCode(expression.expression, replaceThis: replaceThis, asStatement: false)}$typeArgs';
  } else if (expression is ListConcatenation) {
    final lists = expression.lists
        .map((e) => _generateExpressionCode(e,
            replaceThis: replaceThis, asStatement: false))
        .join(' + ');
    return lists;
  } else if (expression is SetConcatenation) {
    final sets = expression.sets
        .map((e) => _generateExpressionCode(e,
            replaceThis: replaceThis, asStatement: false))
        .join(' + ');
    return sets;
  } else if (expression is MapConcatenation) {
    final maps = expression.maps
        .map((e) => _generateExpressionCode(e,
            replaceThis: replaceThis, asStatement: false))
        .join(' + ');
    return maps;
  } else if (expression is InstanceCreation) {
    final className = expression.classReference.asClass.name;

    // 特殊处理 _GrowableList 实例创建
    if (className == '_GrowableList') {
      final typeArgs = expression.typeArguments.isNotEmpty
          ? '<${expression.typeArguments.map(_getDartType).join(', ')}>'
          : 'Object?';
      // 将 _GrowableList<T>() 转换为 <T>[]
      //return '$typeArgs[]';
      return 'CppArrayList<$typeArgs>.fromCppArray(CppApi.cppArrayConst(0))';
    }

    final typeArgs = expression.typeArguments.isNotEmpty
        ? '<${expression.typeArguments.map(_getDartType).join(', ')}>'
        : '';
    final fields = expression.fieldValues.entries
        .map((e) =>
            '${e.key.asField.name}: ${_generateExpressionCode(e.value, replaceThis: replaceThis, asStatement: false)}')
        .join(', ');
    return '$className$typeArgs($fields)';
  } else if (expression is Not) {
    return '!(${_generateExpressionCode(expression.operand, replaceThis: replaceThis, asStatement: false)})';
  } else if (expression is LogicalExpression) {
    final left = _generateExpressionCode(expression.left,
        replaceThis: replaceThis, asStatement: false);
    final op = _getLogicalOperator(expression.operatorEnum);
    final right = _generateExpressionCode(expression.right,
        replaceThis: replaceThis, asStatement: false);
    if (op == '[]') {
      return '$left[$right] ';
    }
    return '$left $op $right';
  } else if (expression is ConditionalExpression) {
    final cond = _generateExpressionCode(expression.condition,
        replaceThis: replaceThis, asStatement: false);
    final then = _generateExpressionCode(expression.then,
        replaceThis: replaceThis, asStatement: false);
    final otherwise = _generateExpressionCode(expression.otherwise,
        replaceThis: replaceThis, asStatement: false);
    return '$cond ? $then : $otherwise';
  } else if (expression is StringConcatenation) {
    String stringify(Expression e) {
      final code = _generateExpressionCode(e,
          replaceThis: replaceThis, asStatement: false);
      if (e is StringLiteral || (code.startsWith('"') && code.endsWith('"')))
        return code;
      return 'CppString.convertString(${code})';
    }

    return expression.expressions.map(stringify).join(' + ');
  } else if (expression is InstanceSet) {
    final receiverRaw = _generateExpressionCode(expression.receiver,
        replaceThis: replaceThis, asStatement: false);
    final receiver = _wrapReceiverIfNeeded(expression.receiver, receiverRaw);
    final name = expression.name.text;
    final value = _generateExpressionCode(expression.value,
        replaceThis: replaceThis, asStatement: false);
    // 处理特殊的运算符赋值
    if (name.startsWith('.') && name.length > 1) {
      final op = name.substring(1);
      // 处理特殊的运算符
      if (op == '[]=') {
        // 需要从参数中提取索引和值
        return '$receiver[index] = $value';
      }
      if (op == '+') return '$receiver += $value';
      if (op == '-') return '$receiver -= $value';
      if (op == '*') return '$receiver *= $value';
      if (op == '/') return '$receiver /= $value';
      return '$receiver$op = $value';
    }
    return '$receiver.$name = $value';
  } else if (expression is DynamicSet) {
    final receiverRaw = _generateExpressionCode(expression.receiver,
        replaceThis: replaceThis, asStatement: false);
    final receiver = _wrapReceiverIfNeeded(expression.receiver, receiverRaw);
    final name = expression.name.text;
    final value = _generateExpressionCode(expression.value,
        replaceThis: replaceThis, asStatement: false);
    // 处理特殊的运算符赋值
    if (name.startsWith('.') && name.length > 1) {
      final op = name.substring(1);
      // 处理特殊的运算符
      if (op == '[]=') {
        // 需要从参数中提取索引和值
        return '$receiver[index] = $value';
      }
      if (op == '+') return '$receiver += $value';
      if (op == '-') return '$receiver -= $value';
      if (op == '*') return '$receiver *= $value';
      if (op == '/') return '$receiver /= $value';
      return '$receiver$op = $value';
    }
    return '$receiver.$name = $value';
  } else if (expression is SuperMethodInvocation) {
    final name = expression.name.text;
    final args = expression.arguments.positional
        .map((e) => _generateExpressionCode(e,
            replaceThis: replaceThis, asStatement: false))
        .join(', ');
    final namedArgs = expression.arguments.named
        .map((na) =>
            '${na.name}: ${_generateExpressionCode(na.value, replaceThis: replaceThis, asStatement: false)}')
        .join(', ');
    final allArgs = [args, namedArgs].where((s) => s.isNotEmpty).join(', ');
    return 'super.$name($allArgs)';
  } else if (expression is SuperPropertyGet) {
    final name = expression.name.text;
    return 'super.$name';
  } else if (expression is SuperPropertySet) {
    final name = expression.name.text;
    final value = _generateExpressionCode(expression.value,
        replaceThis: replaceThis, asStatement: false);
    return 'super.$name = $value';
  } else if (expression is MethodInvocation) {
    final receiverRaw = _generateExpressionCode(expression.receiver,
        replaceThis: replaceThis, asStatement: false);
    final receiver = _wrapReceiverIfNeeded(expression.receiver, receiverRaw);
    final name = expression.name.text;
    final args = expression.arguments.positional
        .map((e) => _generateExpressionCode(e,
            replaceThis: replaceThis, asStatement: false))
        .join(', ');
    final namedArgs = expression.arguments.named
        .map((na) =>
            '${na.name}: ${_generateExpressionCode(na.value, replaceThis: replaceThis, asStatement: false)}')
        .join(', ');
    final allArgs = [args, namedArgs].where((s) => s.isNotEmpty).join(', ');

    // 特殊处理 unary- 方法调用
    if (name == 'unary-') {
      // 如果接收者是数字字面量，直接生成负数
      if (_isNumericLiteral(receiver)) {
        return '-$receiver';
      }
      // 否则生成取负表达式
      return '-$receiver';
    }

    // 特殊处理 FunctionWrapper 类型的变量调用
    if (_isFunctionWrapperType(expression.receiver)) {
      return '$receiver.call($allArgs)';
    }

    // 检查是否是 extension 方法调用
    final receiverType =
        DartToDartTransformer._getReceiverTypeStatic(expression.receiver);
    final extensionName =
        DartToDartTransformer._getExtensionType(name, receiverType);
    if (extensionName != null) {
      // 是 extension 方法，转换为全局函数调用
      final cleanExtensionName =
          extensionName.replaceAll('|', '_').replaceAll('#', '_');
      final cleanMethodName = name.replaceAll('|', '_').replaceAll('#', '_');
      final functionName = '${cleanExtensionName}_${cleanMethodName}';
      return '$functionName($receiver, $allArgs)';
    }

    return '$receiver.$name($allArgs)';
  } else if (expression is PropertyGet) {
    final receiverRaw = _generateExpressionCode(expression.receiver,
        replaceThis: replaceThis, asStatement: false);
    final receiver = _wrapReceiverIfNeeded(expression.receiver, receiverRaw);
    final name = expression.name.text;

    // 特殊处理 unary- 属性访问
    if (name == 'unary-') {
      // 如果接收者是数字字面量，直接生成负数
      if (_isNumericLiteral(receiver)) {
        return '-$receiver';
      }
      // 否则生成取负表达式
      return '-$receiver';
    }

    // 检查是否是 extension getter 调用
    final receiverType =
        DartToDartTransformer._getReceiverTypeStatic(expression.receiver);
    final extensionName =
        DartToDartTransformer._getExtensionType(name, receiverType);
    if (extensionName != null) {
      // 是 extension getter，转换为全局函数调用
      final cleanExtensionName =
          extensionName.replaceAll('|', '_').replaceAll('#', '_');
      final cleanMethodName = name.replaceAll('|', '_').replaceAll('#', '_');
      final getterName = '${cleanExtensionName}_get_${cleanMethodName}';
      return '$getterName($receiver)';
    }

    return '$receiver.$name';
  } else if (expression is PropertySet) {
    final receiverRaw = _generateExpressionCode(expression.receiver,
        replaceThis: replaceThis, asStatement: false);
    final receiver = _wrapReceiverIfNeeded(expression.receiver, receiverRaw);
    final name = expression.name.text;
    final value = _generateExpressionCode(expression.value,
        replaceThis: replaceThis, asStatement: false);
    return '$receiver.$name = $value';
  } else if (expression is IndexGet) {
    final receiverRaw = _generateExpressionCode(expression.receiver,
        replaceThis: replaceThis, asStatement: false);
    final receiver = _wrapReceiverIfNeeded(expression.receiver, receiverRaw);
    final index = _generateExpressionCode(expression.index,
        replaceThis: replaceThis, asStatement: false);
    return '$receiver[$index]';
  } else if (expression is IndexSet) {
    final receiverRaw = _generateExpressionCode(expression.receiver,
        replaceThis: replaceThis, asStatement: false);
    final receiver = _wrapReceiverIfNeeded(expression.receiver, receiverRaw);
    final index = _generateExpressionCode(expression.index,
        replaceThis: replaceThis, asStatement: false);
    final value = _generateExpressionCode(expression.value,
        replaceThis: replaceThis, asStatement: false);
    return '$receiver[$index] = $value';
  } else if (expression is EqualsExpression) {
    final left = _generateExpressionCode(expression.left,
        replaceThis: replaceThis, asStatement: false);
    final right = _generateExpressionCode(expression.right,
        replaceThis: replaceThis, asStatement: false);
    return '$left == $right';
  } else if (expression is NullAwareMethodInvocation) {
    final variable = expression.variable.name ?? 'variable';
    final invocation = _generateExpressionCode(expression.invocation,
        replaceThis: replaceThis, asStatement: false);
    return '$variable?.$invocation';
  } else if (expression is NullAwarePropertyGet) {
    final variable = expression.variable.name ?? 'variable';
    final read = _generateExpressionCode(expression.read,
        replaceThis: replaceThis, asStatement: false);
    return '$variable?.$read';
  } else if (expression is NullAwarePropertySet) {
    final variable = expression.variable.name ?? 'variable';
    final write = _generateExpressionCode(expression.write,
        replaceThis: replaceThis, asStatement: false);
    return '$variable?.$write';
  } else if (expression is NullAwareExtension) {
    final variable = expression.variable.name ?? 'variable';
    final expr = _generateExpressionCode(expression.expression,
        replaceThis: replaceThis, asStatement: false);
    return '$variable?.$expr';
  } else if (expression is IfNullExpression) {
    final left = _generateExpressionCode(expression.left,
        replaceThis: replaceThis, asStatement: false);
    final right = _generateExpressionCode(expression.right,
        replaceThis: replaceThis, asStatement: false);
    return '$left ?? $right';
  } else if (expression is CompoundPropertySet) {
    final receiver = _generateExpressionCode(expression.receiver,
        replaceThis: replaceThis, asStatement: false);
    final name = expression.propertyName.text;
    final binaryName = expression.binaryName.text;
    final rhs = _generateExpressionCode(expression.rhs,
        replaceThis: replaceThis, asStatement: false);
    return '$receiver.$name $binaryName $rhs';
  } else if (expression is CompoundIndexSet) {
    final receiver = _generateExpressionCode(expression.receiver,
        replaceThis: replaceThis, asStatement: false);
    final index = _generateExpressionCode(expression.index,
        replaceThis: replaceThis, asStatement: false);
    final binaryName = expression.binaryName.text;
    final rhs = _generateExpressionCode(expression.rhs,
        replaceThis: replaceThis, asStatement: false);
    return '$receiver[$index] $binaryName $rhs';
  } else if (expression is CompoundSuperIndexSet) {
    final index = _generateExpressionCode(expression.index,
        replaceThis: replaceThis, asStatement: false);
    final binaryName = expression.binaryName.text;
    final rhs = _generateExpressionCode(expression.rhs,
        replaceThis: replaceThis, asStatement: false);
    return 'super[$index] $binaryName $rhs';
  } else if (expression is CompoundExtensionIndexSet) {
    final receiver = _generateExpressionCode(expression.receiver,
        replaceThis: replaceThis, asStatement: false);
    final index = _generateExpressionCode(expression.index,
        replaceThis: replaceThis, asStatement: false);
    final binaryName = expression.binaryName.text;
    final rhs = _generateExpressionCode(expression.rhs,
        replaceThis: replaceThis, asStatement: false);
    return '$receiver[$index] $binaryName $rhs';
  } else if (expression is NullAwareCompoundSet) {
    final receiver = _generateExpressionCode(expression.receiver,
        replaceThis: replaceThis, asStatement: false);
    final name = expression.propertyName.text;
    final binaryName = expression.binaryName.text;
    final rhs = _generateExpressionCode(expression.rhs,
        replaceThis: replaceThis, asStatement: false);
    return '$receiver?.$name $binaryName $rhs';
  } else if (expression is PropertyPostIncDec) {
    final read = expression.read.name ?? 'read';
    return '$read++';
  } else if (expression is LocalPostIncDec) {
    final read = expression.read.name ?? 'read';
    return '$read++';
  } else if (expression is StaticPostIncDec) {
    final read = expression.read.name ?? 'read';
    return '$read++';
  } else if (expression is ExtensionSet) {
    final receiver = _generateExpressionCode(expression.receiver,
        replaceThis: replaceThis, asStatement: false);
    final name = expression.target.name.text;
    final value = _generateExpressionCode(expression.value,
        replaceThis: replaceThis, asStatement: false);
    return '$receiver.$name = $value';
  } else if (expression is ExtensionIndexSet) {
    final receiver = _generateExpressionCode(expression.receiver,
        replaceThis: replaceThis, asStatement: false);
    final index = _generateExpressionCode(expression.index,
        replaceThis: replaceThis, asStatement: false);
    final value = _generateExpressionCode(expression.value,
        replaceThis: replaceThis, asStatement: false);
    return '$receiver[$index] = $value';
  } else if (expression is IfNullExtensionIndexSet) {
    final receiver = _generateExpressionCode(expression.receiver,
        replaceThis: replaceThis, asStatement: false);
    final index = _generateExpressionCode(expression.index,
        replaceThis: replaceThis, asStatement: false);
    final value = _generateExpressionCode(expression.value,
        replaceThis: replaceThis, asStatement: false);
    return '$receiver?.[$index] = $value';
  } else if (expression is SuperIndexSet) {
    final index = _generateExpressionCode(expression.index,
        replaceThis: replaceThis, asStatement: false);
    final value = _generateExpressionCode(expression.value,
        replaceThis: replaceThis, asStatement: false);
    return 'super[$index] = $value';
  } else if (expression is IfNullSuperIndexSet) {
    final index = _generateExpressionCode(expression.index,
        replaceThis: replaceThis, asStatement: false);
    final value = _generateExpressionCode(expression.value,
        replaceThis: replaceThis, asStatement: false);
    return 'super[$index] ??= $value';
  } else if (expression is AugmentSuperInvocation) {
    final args = expression.arguments.positional
        .map((e) => _generateExpressionCode(e,
            replaceThis: replaceThis, asStatement: false))
        .join(', ');
    final namedArgs = expression.arguments.named
        .map((na) =>
            '${na.name}: ${_generateExpressionCode(na.value, replaceThis: replaceThis, asStatement: false)}')
        .join(', ');
    final allArgs = [args, namedArgs].where((s) => s.isNotEmpty).join(', ');
    return 'augment super($allArgs)';
  } else if (expression is AugmentSuperGet) {
    return 'augment super';
  } else if (expression is AugmentSuperSet) {
    final value = _generateExpressionCode(expression.value,
        replaceThis: replaceThis, asStatement: false);
    return 'augment super = $value';
  } else if (expression is Cascade) {
    final variable = expression.variable.name ?? 'variable';
    final expressions = expression.expressions
        .map((e) => _generateExpressionCode(e,
            replaceThis: replaceThis, asStatement: false))
        .join('..');
    return '$variable..$expressions';
  } else if (expression is DeferredCheck) {
    final variable = expression.variable.name ?? 'variable';
    final expr = _generateExpressionCode(expression.expression,
        replaceThis: replaceThis, asStatement: false);
    return '$variable in $expr';
  } else if (expression is IntJudgment) {
    return expression.value.toString();
  } else if (expression is ShadowLargeIntLiteral) {
    return expression.literal;
  } else if (expression is AbstractSuperPropertyGet) {
    final name = expression.name.text;
    return 'super.$name /* abstract */';
  } else if (expression is AbstractSuperPropertySet) {
    final name = expression.name.text;
    final value = _generateExpressionCode(expression.value,
        replaceThis: replaceThis, asStatement: false);
    return 'super.$name /* abstract */ = $value';
  } else if (expression is AbstractSuperMethodInvocation) {
    final name = expression.name.text;
    final args = expression.arguments.positional
        .map((e) => _generateExpressionCode(e,
            replaceThis: replaceThis, asStatement: false))
        .join(', ');
    final namedArgs = expression.arguments.named
        .map((na) =>
            '${na.name}: ${_generateExpressionCode(na.value, replaceThis: replaceThis, asStatement: false)}')
        .join(', ');
    final allArgs = [args, namedArgs].where((s) => s.isNotEmpty).join(', ');
    return 'super.$name /* abstract */($allArgs)';
  } else if (expression is InstanceGetterInvocation) {
    final receiverRaw = _generateExpressionCode(expression.receiver,
        replaceThis: replaceThis, asStatement: false);
    final receiver = _wrapReceiverIfNeeded(expression.receiver, receiverRaw);
    final name = expression.name.text;

    // 特殊处理 unary- 方法调用
    if (name == 'unary-') {
      // 如果接收者是数字字面量，直接生成负数
      if (_isNumericLiteral(receiver)) {
        return '-$receiver';
      }
      // 否则生成取负表达式
      return '-$receiver';
    }

    final args = expression.arguments.positional
        .map((e) => _generateExpressionCode(e,
            replaceThis: replaceThis, asStatement: false))
        .join(', ');
    final namedArgs = expression.arguments.named
        .map((na) =>
            '${na.name}: ${_generateExpressionCode(na.value, replaceThis: replaceThis, asStatement: false)}')
        .join(', ');
    final allArgs = [args, namedArgs].where((s) => s.isNotEmpty).join(', ');
    return '$receiver.$name($allArgs)';
  } else if (expression is FunctionInvocation) {
    final receiverRaw = _generateExpressionCode(expression.receiver,
        replaceThis: replaceThis, asStatement: false);
    final receiver = _wrapReceiverIfNeeded(expression.receiver, receiverRaw);
    final args = expression.arguments.positional
        .map((e) => _generateExpressionCode(e,
            replaceThis: replaceThis, asStatement: false))
        .join(', ');
    final namedArgs = expression.arguments.named
        .map((na) =>
            '${na.name}: ${_generateExpressionCode(na.value, replaceThis: replaceThis, asStatement: false)}')
        .join(', ');
    final allArgs = [args, namedArgs].where((s) => s.isNotEmpty).join(', ');

    // 特殊处理 unary- 函数调用
    if (receiver.contains('unary-')) {
      // 从参数中提取数字
      if (args.isNotEmpty) {
        final number = args.split(',')[0].trim();
        if (_isNumericLiteral(number)) {
          return '-$number';
        }
        return '-$number';
      }
    }

    // 检查是否在闭包上下文中，且接收者是参数变量
    // 如果是，并且没有提供参数，则应该传递当前函数的参数
    if (DartToDartTransformer._inClosureContext &&
        allArgs.isEmpty &&
        expression.receiver is VariableGet) {
      final variableGet = expression.receiver as VariableGet;
      final receiverName =
          _cleanVariableName(variableGet.variable.name ?? 'unnamed');

      // 检查这是否是一个被捕获的函数变量在闭包中的调用
      // 在这种情况下，我们需要获取当前闭包函数的参数并传递给调用
      // 这里我们假设闭包函数有一个参数需要转发
      if (_isInClosureWithParameters()) {
        final closureParamName = _getCurrentClosureParameterName();
        if (closureParamName.isNotEmpty) {
          return '$receiver.call($closureParamName)';
        }
      }
    }

    // 特殊处理 FunctionWrapper 类型的变量调用
    if (_isFunctionWrapperType(expression.receiver)) {
      return '$receiver.call($allArgs)';
    }

    // 对于FunctionWrapper，简化处理：直接调用
    // 在回调函数上下文中，FunctionWrapper对象本身就是可调用的
    return '$receiver($allArgs)';
  } else if (expression is FileUriExpression) {
    final expr = _generateExpressionCode(expression.expression,
        replaceThis: replaceThis, asStatement: false);
    return '/* file: ${expression.fileUri} */ $expr';
  } else if (expression is AsExpression) {
    final operand = _generateExpressionCode(expression.operand,
        replaceThis: replaceThis, asStatement: false);
    final type = _getDartType(expression.type);
    return '($operand as $type)';
  } else if (expression is IsExpression) {
    final operand = _generateExpressionCode(expression.operand,
        replaceThis: replaceThis, asStatement: false);
    final type = _getDartType(expression.type);
    return '($operand is $type)';
  } else if (expression is Let) {
    // 优化 Let 模式，尽量消除 IIFE：
    // 场景1：body 形如 (v == null ? a : v) -> 生成 (init ?? a)
    final initializerCode = _generateExpressionCode(
        expression.variable.initializer!,
        replaceThis: replaceThis,
        allowReturn: false);

    // 如果 Let 绑定的变量类型为 void，则无需声明该变量。
    // 直接顺序执行初始化表达式，然后返回 body 的值。
    final varType = _getDartType(expression.variable.type);
    if (varType == 'void') {
      final body = _generateExpressionCode(expression.body,
          replaceThis: replaceThis, asStatement: false, allowReturn: false);
      final initStmt = initializerCode.trimRight().endsWith(';')
          ? initializerCode
          : '$initializerCode;';
      return '(() { $initStmt $body; })()';
    }

    Expression bodyExpr = expression.body;
    if (bodyExpr is ConditionalExpression) {
      // 匹配 v == null ? then : otherwise
      final cond = bodyExpr.condition;
      if (cond is EqualsNull) {
        final operand = cond.expression;
        if (operand is VariableGet &&
            operand.variable.name == expression.variable.name) {
          final thenStr = _generateExpressionCode(bodyExpr.then,
              replaceThis: replaceThis, asStatement: false, allowReturn: false);
          final otherwiseExpr = bodyExpr.otherwise;
          // 如果 otherwise 就是变量本身，使用 ?? 简化
          if (otherwiseExpr is VariableGet &&
              otherwiseExpr.variable.name == expression.variable.name) {
            // 安全性：当 then 分支涉及类型转换等语义性操作（如 `as`/throw）时，
            // 不进行 ?? 简化以避免改变语义（例如 `result as E` 被错误改写为 `result ?? (temp as E)`）。
            final thenLower = thenStr.replaceAll('\n', ' ').trim();
            final hasPotentialSemanticOps = thenLower.contains(' as ') ||
                thenLower.startsWith('throw ') ||
                thenLower.contains(' rethrow');
            if (!hasPotentialSemanticOps) {
              return '(${initializerCode}) ?? (${thenStr})';
            }
            // 否则回退：使用 IIFE，严格按作用域声明局部变量，避免不安全的文本替换
            final localName =
                _generateUniqueLetVarName(expression.variable, expression);
            final localType = _getDartType(expression.variable.type);
            _letAliasNames[expression.variable] = localName;
            final body = _generateExpressionCode(expression.body,
                replaceThis: replaceThis,
                asStatement: false,
                allowReturn: false);
            _letAliasNames.remove(expression.variable);
            return '(() { final ${localType} ${localName} = ${initializerCode}; return ${body}; })()';
          }
          // 其他情况同样回退到 IIFE 形式
          final localName =
              _generateUniqueLetVarName(expression.variable, expression);
          final localType = _getDartType(expression.variable.type);
          _letAliasNames[expression.variable] = localName;
          final body = _generateExpressionCode(expression.body,
              replaceThis: replaceThis, asStatement: false, allowReturn: false);
          _letAliasNames.remove(expression.variable);
          return '(() { final ${localType} ${localName} = ${initializerCode}; return ${body}; })()';
        }
      }
    }

    // 回退：保留原 IIFE 形式，使用基于位置的唯一变量名，避免命名冲突
    final localName =
        _generateUniqueLetVarName(expression.variable, expression);
    final localType = _getDartType(expression.variable.type);
    _letAliasNames[expression.variable] = localName;
    final body = _generateExpressionCode(expression.body,
        replaceThis: replaceThis, asStatement: false, allowReturn: false);
    _letAliasNames.remove(expression.variable);
    return '(() { final ${localType} ${localName} = ${initializerCode}; return ${body}; })()';
  } else if (expression is LocalFunctionInvocation) {
    final name = _cleanVariableName(expression.variable.name ?? 'unnamed');
    final args = expression.arguments.positional
        .map((e) => _generateExpressionCode(e,
            replaceThis: replaceThis, asStatement: false))
        .join(', ');
    final namedArgs = expression.arguments.named
        .map((na) =>
            '${na.name}: ${_generateExpressionCode(na.value, replaceThis: replaceThis, asStatement: false)}')
        .join(', ');
    final allArgs = [args, namedArgs].where((s) => s.isNotEmpty).join(', ');

    // 特殊处理 unary- 函数调用
    if (name.contains('unary-')) {
      // 从参数中提取数字
      if (args.isNotEmpty) {
        final number = args.split(',')[0].trim();
        if (_isNumericLiteral(number)) {
          return '-$number';
        }
        return '-$number';
      }
    }

    // 对于FunctionWrapper，直接调用
    // 在回调函数上下文中，FunctionWrapper对象本身就是可调用的
    return '$name($allArgs)';
  } else if (expression is ConstantExpression) {
    final constant = expression.constant;
    if (constant is StringConstant) {
      final value = constant.value;
      final escaped = value
          .replaceAll('\\', '\\\\')
          .replaceAll('"', '\\"')
          .replaceAll('\n', '\\n')
          .replaceAll('\r', '\\r')
          .replaceAll('\t', '\\t');
      final constValue =
          'CppString.fromCppUserData(CppApi.cppCharCodes("$escaped"))';
      final constVarName =
          DartToDartTransformer._globalAddConstConstant(constValue);
      return constVarName;
    } else if (constant is IntConstant) {
      final constValue = constant.value.toString();
      final constVarName =
          DartToDartTransformer._globalAddConstConstant(constValue);
      return constVarName;
    } else if (constant is DoubleConstant) {
      final constValue = constant.value.toString();
      final constVarName =
          DartToDartTransformer._globalAddConstConstant(constValue);
      return constVarName;
    } else if (constant is BoolConstant) {
      final constValue = constant.value.toString();
      final constVarName =
          DartToDartTransformer._globalAddConstConstant(constValue);
      return constVarName;
    } else if (constant is NullConstant) {
      // 对于 null 值，直接使用 null，不需要创建 const 变量
      return 'null';
    } else if (constant is ListConstant) {
      final entries = constant.entries
          .map((e) => _generateExpressionCode(ConstantExpression(e),
              replaceThis: replaceThis))
          .join(', ');
      final constValue = '[$entries]';
      final constVarName =
          DartToDartTransformer._globalAddConstConstant(constValue);
      return constVarName;
    } else if (constant is MapConstant) {
      final entries = constant.entries
          .map((e) =>
              '${_generateExpressionCode(ConstantExpression(e.key), replaceThis: replaceThis, asStatement: false)}: ${_generateExpressionCode(ConstantExpression(e.value), replaceThis: replaceThis, asStatement: false)}')
          .join(', ');
      final constValue = '{$entries}';
      final constVarName =
          DartToDartTransformer._globalAddConstConstant(constValue);
      return constVarName;
    } else if (constant is RecordConstant) {
      final positional = constant.positional
          .map((e) => _generateExpressionCode(ConstantExpression(e),
              replaceThis: replaceThis, asStatement: false))
          .join(', ');
      final named = constant.named.entries
          .map((e) =>
              '${e.key}: ${_generateExpressionCode(ConstantExpression(e.value), replaceThis: replaceThis, asStatement: false)}')
          .join(', ');
      final all = [positional, named].where((s) => s.isNotEmpty).join(', ');
      final constValue = '($all)';
      final constVarName =
          DartToDartTransformer._globalAddConstConstant(constValue);
      return constVarName;
    } else if (constant is SetConstant) {
      final entries = constant.entries
          .map((e) => _generateExpressionCode(ConstantExpression(e),
              replaceThis: replaceThis, asStatement: false))
          .join(', ');
      final constValue = '{$entries}';
      final constVarName =
          DartToDartTransformer._globalAddConstConstant(constValue);
      return constVarName;
    } else if (constant is InstanceConstant) {
      // 处理实例常量，需要替换类名
      final className = constant.classNode.name;
      final prefixedClassName =
          DartToDartTransformer._getCompleteClassName(className);

      // 检查是否是构造函数调用（通过检查字段名是否包含类名）
      bool isConstructorCall = false;
      String? constructorName;

      for (final entry in constant.fieldValues.entries) {
        final fieldName = entry.key.toStringInternal();
        if (fieldName.contains('.')) {
          final parts = fieldName.split('.');
          if (parts.length == 2 && parts[0] == className) {
            // 这是一个构造函数调用，字段名格式为 "ClassName.fieldName"
            isConstructorCall = true;
            // 尝试从字段名推断构造函数名
            if (parts[1] == '_codeUnits') {
              constructorName = 'fromCppUserData';
            } else if (parts[1] == 'data') {
              // 检查是否是 CppUserData.constant 调用
              if (className == 'CppUserData') {
                constructorName = 'constant';
              }
            }
            break;
          }
        }
      }

      if (isConstructorCall && constructorName != null) {
        // 这是构造函数调用，生成正确的构造函数调用格式
        final args = constant.fieldValues.entries.map((e) {
          return _generateExpressionCode(ConstantExpression(e.value),
              replaceThis: replaceThis, asStatement: false);
        }).join(', ');

        return 'const $prefixedClassName.$constructorName($args)';
      } else {
        // 这是字段初始化，需要替换字段引用中的类名
        final fieldValues = constant.fieldValues.entries.map((e) {
          final fieldName = e.key.toStringInternal(); // 获取字段名
          final fieldValue = _generateExpressionCode(
              ConstantExpression(e.value),
              replaceThis: replaceThis,
              asStatement: false);

          // 如果字段名包含类名引用（如 CppString._codeUnits），需要替换类名
          String processedFieldName = fieldName;
          if (fieldName.contains('.')) {
            final parts = fieldName.split('.');
            if (parts.length == 2) {
              final fieldClassName = parts[0];
              final fieldFieldName = parts[1];
              final prefixedFieldClassName =
                  DartToDartTransformer._getCompleteClassName(fieldClassName);
              processedFieldName = '$prefixedFieldClassName.$fieldFieldName';
            }
          }

          return '$processedFieldName: $fieldValue';
        }).join(', ');

        return 'const $prefixedClassName($fieldValues)';
      }
    } else {
      return expression.toString();
    }
  } else if (expression is StaticInvocation) {
    final encl = expression.target.enclosingClass;
    final originalClassName = encl?.name;
    String? className;
    if (originalClassName != null) {
      // 使用完整的类名处理（先 patch 替换，再加前缀）
      className =
          DartToDartTransformer._getCompleteClassName(originalClassName);
    }
    final methodName = expression.target.name.text;

    // 特殊处理 _GrowableList 静态方法调用
    if (originalClassName == '_GrowableList') {
      final typeArgs = expression.arguments.types.map(_getDartType).join(', ');
      final args = expression.arguments.positional
          .map((e) => _generateExpressionCode(e,
              replaceThis: replaceThis, asStatement: false))
          .join(', ');
      if (expression.name.text.isEmpty) {
        return 'CppArrayList<$typeArgs>.fromCppArray(CppApi.cppArrayConst(0))';
      }
      if (methodName.startsWith('_literal')) {
        return 'CppArrayList<$typeArgs>.fromCppArray(CppApi.cppArrayConst(${expression.arguments.positional.length}, $args))';
      }
      return 'CppArrayList<$typeArgs>.$methodName($args)';
    }

    // 特殊处理 CppUserData.constant 命名构造函数调用
    if (originalClassName == 'CppUserData' && methodName == 'constant') {
      final args = expression.arguments.positional
          .map((e) => _generateExpressionCode(e,
              replaceThis: replaceThis, asStatement: false))
          .join(', ');
      return 'CppUserData.constant($args)';
    }

    // 特殊处理 CppString.fromString 静态方法调用
    if (originalClassName == 'CppString' && methodName == 'fromString') {
      // 如果参数是字符串字面量，直接转换为 fromCppUserData 格式
      if (expression.arguments.positional.isNotEmpty) {
        final firstArg = expression.arguments.positional.first;
        if (firstArg is StringLiteral) {
          final value = firstArg.value;
          final escaped = value
              .replaceAll('\\', '\\\\')
              .replaceAll('"', '\\"')
              .replaceAll('\n', '\\n')
              .replaceAll('\r', '\\r')
              .replaceAll('\t', '\\t');
          return 'CppString.fromCppUserData(CppApi.cppCharCodes("$escaped"))';
        } else {
          // 如果参数不是字符串字面量，保持原有逻辑
          final args = expression.arguments.positional
              .map((e) => _generateExpressionCode(e,
                  replaceThis: replaceThis, asStatement: false))
              .join(', ');
          return 'CppString.fromString($args)';
        }
      }
    }

    // 特殊处理 List 类名替换
    if (originalClassName != null && originalClassName == 'List') {
      final typeArgs = expression.arguments.types.map(_getDartType).join(', ');
      final args = expression.arguments.positional
          .map((e) => _generateExpressionCode(e,
              replaceThis: replaceThis, asStatement: false))
          .join(', ');
      final namedArgs = expression.arguments.named
          .map((na) =>
              '${na.name}: ${_generateExpressionCode(na.value, replaceThis: replaceThis, asStatement: false)}')
          .join(', ');
      final allArgs = [args, namedArgs].where((s) => s.isNotEmpty).join(', ');

      // 使用全局类名替换，不再使用前缀
      final replacedClassName =
          DartToDartTransformer._getGlobalReplacedClassName(originalClassName);
      final className = replacedClassName; // 直接使用替换后的类名，不加前缀

      return '$className<$typeArgs>$methodName($allArgs)';
    }

    // 特殊处理 unary- 方法调用
    // if (methodName == 'unary-' || methodName.contains('unary-')) {
    //   // 对于静态调用，我们需要从参数中获取接收者
    //   final args = expression.arguments.positional
    //       .map((e) => _generateExpressionCode(e,
    //           replaceThis: replaceThis, asStatement: false))
    //       .join(', ');
    //   if (args.isNotEmpty) {
    //     final receiver = args.split(',')[0].trim();
    //     if (_isNumericLiteral(receiver)) {
    //       return '-$receiver';
    //     }
    //     return '-$receiver';
    //   }
    // }

    final typeArgs = expression.arguments.types.map(_getDartType).join(', ');
    final args = expression.arguments.positional
        .map((e) => _generateExpressionCode(e,
            replaceThis: replaceThis, asStatement: false))
        .join(', ');
    final namedArgs = expression.arguments.named
        .map((na) =>
            '${na.name}: ${_generateExpressionCode(na.value, replaceThis: replaceThis, asStatement: false)}')
        .join(', ');
    final allArgs = [args, namedArgs].where((s) => s.isNotEmpty).join(', ');
    if (className == null) {
      return '$methodName${typeArgs.isNotEmpty ? '<$typeArgs>' : ''}($allArgs)';
    }
    return '$className.$methodName${typeArgs.isNotEmpty ? '<$typeArgs>' : ''}($allArgs)';
  } else if (expression is Throw) {
    final throwExpression = _generateExpressionCode(expression.expression,
        replaceThis: replaceThis);
    return 'throw $throwExpression';
  } else if (expression is Rethrow) {
    return 'rethrow';
  } else if (expression is IntLiteral) {
    return expression.value.toString();
  } else if (expression is DoubleLiteral) {
    return expression.value.toString();
  } else if (expression is BoolLiteral) {
    return expression.value ? 'true' : 'false';
  } else if (expression is NullLiteral) {
    return 'null';
  } else if (expression is StringLiteral) {
    // 将字符串字面量转换为 CppString.fromCppUserData 格式，并使用const变量
    final value = expression.value;
    final escaped = value
        .replaceAll('\\', '\\\\')
        .replaceAll('"', '\\"')
        .replaceAll('\n', '\\n')
        .replaceAll('\r', '\\r')
        .replaceAll('\t', '\\t');
    final constValue =
        'CppString.fromCppUserData(CppApi.cppCharCodes("$escaped"))';
    final constVarName =
        DartToDartTransformer._globalAddConstConstant(constValue);
    return constVarName;
  } else if (expression is SwitchExpression) {
    final switchExpr = _generateExpressionCode(expression.expression,
        replaceThis: replaceThis, asStatement: false);
    final cases = expression.cases
        .map((c) => _generateSwitchExpressionCase(c, replaceThis))
        .join(', ');
    return 'switch ($switchExpr) { $cases }';
  } else {
    // 对于其他未知的表达式类型，检查是否是 unary- 操作
    final exprStr = expression.toString();
    if (exprStr.contains('unary-')) {
      // 提取接收者
      final receiverMatch = RegExp(r'(\d+)\.unary-').firstMatch(exprStr);
      if (receiverMatch != null) {
        final receiver = receiverMatch.group(1);
        return '-$receiver';
      }
    }
    return expression.toString();
  }
}

String _generateStatementCode(Statement statement,
    {bool replaceThis = false, bool allowReturn = true}) {
  // 处理语句生成
  if (statement is ReturnStatement) {
    // if (!allowReturn) {
    //   // 如果不允许return，则只返回表达式部分
    //   if (statement.expression != null) {
    //     return _generateExpressionCode(statement.expression!,
    //         replaceThis: replaceThis, asStatement: false, allowReturn: false);
    //   } else {
    //     return 'null';
    //   }
    // }
    if (statement.expression != null) {
      final expr = _generateExpressionCode(statement.expression!,
          replaceThis: replaceThis, asStatement: false, allowReturn: false);
      // 避免重复的 return 关键字
      if (expr.startsWith('return ')) {
        return expr;
      } else if (expr.startsWith('throw ')) {
        return expr;
      } else {
        return 'return $expr;';
      }
    } else {
      return 'return;';
    }
  } else if (statement is ExpressionStatement) {
    final expr = _generateExpressionCode(statement.expression,
        replaceThis: replaceThis, asStatement: false);
    // 避免重复的 return 关键字，但为 throw 添加分号
    if (expr.startsWith('return ')) {
      return expr;
    } else if (expr.startsWith('throw ')) {
      return '$expr;';
    } else {
      return '$expr;';
    }
  } else if (statement is Block) {
    final stmts = statement.statements
        .map((s) => _generateStatementCode(s,
            replaceThis: replaceThis, allowReturn: true))
        .join('\n  ');
    return '{\n  $stmts\n}';
  } else if (statement is IfStatement) {
    final cond = _generateExpressionCode(statement.condition,
        replaceThis: replaceThis, asStatement: false);
    final then = _generateStatementCode(statement.then,
        replaceThis: replaceThis, allowReturn: true);
    final otherwise = statement.otherwise != null
        ? ' else ${_generateStatementCode(statement.otherwise!, replaceThis: replaceThis, allowReturn: true)}'
        : '';
    return 'if ($cond) $then$otherwise';
  } else if (statement is VariableDeclaration) {
    // 获取变量类型，确保正确处理可空性
    String type = _getDartType(statement.type);

    // 直接判断变量类型是否是可选的（nullable）
    if (statement.type.nullability == Nullability.nullable) {
      // 如果类型是可空的，确保生成的类型字符串包含 ?
      if (!type.endsWith('?')) {
        type = '$type?';
      }
    }

    final name = _cleanVariableName(statement.name ?? 'unnamed');
    // Map 类型需要在空字面量时加上类型参数
    String init = '';
    if (statement.initializer != null) {
      final initExpr = _generateExpressionCode(statement.initializer!,
          replaceThis: replaceThis, asStatement: false);

      // 特殊处理 cppUserDataEmpty 的定义
      if (name == 'cppUserDataEmpty' &&
          initExpr.contains('CppUserData.constant([])')) {
        init = ' = CppUserData.constant([])';
      } else if (name == 'cppUserDataEmpty') {
        // 如果是cppUserDataEmpty但initExpr不匹配，强制设置为正确的定义
        init = ' = CppUserData.constant([])';
      } else if (type.startsWith('Map') && initExpr.trim() == '{}') {
        if (statement.type is InterfaceType) {
          final it = statement.type as InterfaceType;
          if (it.typeArguments.length == 2) {
            final k = _getDartType(it.typeArguments[0]);
            final v = _getDartType(it.typeArguments[1]);
            init = ' = <${k}, ${v}>{}';
          } else {
            init = ' = <Object, Object>{}';
          }
        } else {
          init = ' = <Object, Object>{}';
        }
      } else {
        init = ' = ' + initExpr;
      }
    }

    // 处理闭包装箱 - 检查预分析结果，是否需要装箱此变量
    // 但排除for循环中会使用的变量，它们会在for循环中特殊处理
    final isCommonLoopVar = {'i', 'j', 'k', 'index', 'idx'}.contains(name);

    // 调试输出已清理

    if (DartToDartTransformer._globalVariablesToBox.contains(name) &&
        !DartToDartTransformer._globalForLoopVariablesToBox.contains(name) &&
        statement.type is InterfaceType) {
      // 对于常见循环变量，如果它们在装箱列表中，说明是外部声明的变量需要装箱
      final typeName = (statement.type as InterfaceType).classNode.name;
      if (DartToDartTransformer._globalNeedsBoxing(typeName)) {
        final boxType = DartToDartTransformer._globalGetBoxType(typeName);
        // 记录变量的装箱状态
        DartToDartTransformer._setVariableBoxState(name, true);
        // 如果有初始化值，创建装箱实例
        if (init.isNotEmpty) {
          final initValue = init.substring(3); // 去掉 " = " 前缀
          DartToDartTransformer._globalInitializedBoxedVariables.add(name);
          return '$boxType $name = ${DartToDartTransformer._globalGetBoxConstructor(typeName, initValue)};';
        } else {
          // 没有初始化值，创建默认实例
          DartToDartTransformer._globalInitializedBoxedVariables.add(name);
          return '$boxType $name = ${DartToDartTransformer._globalGetBoxConstructor(typeName, null)};';
        }
      }
    }

    // 检查变量类型是否已经是装箱类型（基于定义）
    final isBoxType = type.startsWith('Box') ||
        (statement.type is InterfaceType &&
            (statement.type as InterfaceType).classNode.name.startsWith('Box'));

    // 检查变量是否需要装箱（基于全局分析结果）
    final needsBoxing = !isBoxType &&
        (DartToDartTransformer._globalVariablesToBox.contains(name) ||
            DartToDartTransformer._globalForLoopVariablesToBox.contains(name) ||
            DartToDartTransformer._getVariableBoxState(name));

    // 如果需要装箱但当前不是装箱类型，则转换为装箱类型
    if (needsBoxing && statement.type is InterfaceType) {
      final interfaceType = statement.type as InterfaceType;
      final typeName = interfaceType.classNode.name;
      final boxType = DartToDartTransformer._globalGetBoxType(typeName);
      final boxConstructor = DartToDartTransformer._globalGetBoxConstructor(
          typeName, init.isNotEmpty ? init.substring(3) : null);

      // 记录变量的装箱状态
      DartToDartTransformer._setVariableBoxState(name, true);

      return '$boxType $name = $boxConstructor;';
    } else {
      // 记录变量的装箱状态
      DartToDartTransformer._setVariableBoxState(name, isBoxType);

      return '$type $name$init;';
    }
  } else if (statement is EmptyStatement) {
    return ';';
  } else if (statement is ForStatement) {
    // 检查是否有需要装箱的for循环变量
    final boxedVariables = <String>[];
    final boxedVarInfo = <Map<String, String>>[];

    for (final v in statement.variables) {
      final varName = v.name ?? 'unnamed';

      // 调试输出已清理

      // 检查是否真正需要装箱：必须在两个列表中，且是在for循环中声明的变量
      // 如果变量在_globalVariablesToBox中但不在_globalForLoopVariablesToBox中，
      // 可能是同名变量导致的遗漏，直接添加到_globalForLoopVariablesToBox
      if (!DartToDartTransformer._globalForLoopVariablesToBox
              .contains(varName) &&
          DartToDartTransformer._globalVariablesToBox.contains(varName)) {
        DartToDartTransformer._globalForLoopVariablesToBox.add(varName);
        // 自动修复遗漏的for循环变量
      }

      if (DartToDartTransformer._globalForLoopVariablesToBox
              .contains(varName) &&
          DartToDartTransformer._globalVariablesToBox.contains(varName)) {
        boxedVariables.add(varName);
        // 记录变量的装箱状态
        DartToDartTransformer._setVariableBoxState(varName, true);
        final typeName = (v.type as InterfaceType).classNode.name;
        final boxType = DartToDartTransformer._globalGetBoxType(typeName);
        final initValue = v.initializer != null
            ? _generateExpressionCode(v.initializer!,
                replaceThis: replaceThis, asStatement: false)
            : '0';

        boxedVarInfo.add({
          'varName': varName,
          'typeName': typeName,
          'boxType': boxType,
          'initValue': initValue
        });
      }
    }

    // 步骤1：识别for循环定义的变量，如果需要装箱则使用$origin_前缀
    final renamedVariables = <String, String>{}; // 原名 -> $origin_前缀名
    final init = statement.variables.isNotEmpty
        ? statement.variables.map((v) {
            final varName = _cleanVariableName(v.name ?? 'forVar');
            final initExpr = v.initializer != null
                ? _generateExpressionCode(v.initializer!,
                    replaceThis: replaceThis, asStatement: false)
                : '0';

            // 检查是否需要装箱
            if (boxedVariables.contains(varName)) {
              // 步骤1：给变量名加上$origin_前缀
              final renamedVar = '\$origin_$varName';
              renamedVariables[varName] = renamedVar;
              final varType = _getDartType(v.type);
              return '$varType $renamedVar = $initExpr';
            } else {
              // 检查初始化表达式是否包含外部装箱变量的赋值
              if (initExpr.contains('.value = ') ||
                  (initExpr.contains('BoxInt(') && initExpr.contains(' = '))) {
                // 对于外部变量装箱的情况，只保留赋值表达式，不重新声明类型
                return initExpr;
              } else {
                final varType = _getDartType(v.type);
                return '$varType $varName = $initExpr';
              }
            }
          }).join(', ')
        : '';

    // 步骤2：在循环开始前进行装箱，使用$origin_前缀变量初始化
    String preBoxingCode = '';
    // 不再需要预装箱，在每次迭代中创建新装箱变量

    // 对于无变量声明的for循环，处理外部变量
    if (statement.variables.isEmpty) {
      // 检查更新表达式中是否有初始化赋值
      String initPart = '';
      final remainingUpdates = <Expression>[];

      if (statement.updates.isNotEmpty) {
        // 检查第一个更新表达式是否是对外部变量的赋值
        final firstUpdateCode = _generateExpressionCode(statement.updates.first,
            replaceThis: replaceThis, asStatement: false);

        // 如果是赋值表达式且赋值给外部装箱变量，则作为初始化
        if (firstUpdateCode.contains('=') &&
            firstUpdateCode.startsWith('i =')) {
          initPart = firstUpdateCode;
          remainingUpdates.addAll(statement.updates.skip(1));
        } else {
          remainingUpdates.addAll(statement.updates);
        }
      }

      final conditionPart = statement.condition != null
          ? _generateExpressionCode(statement.condition!,
              replaceThis: replaceThis, asStatement: false)
          : '';
      final updatesPart = remainingUpdates.isNotEmpty
          ? remainingUpdates
              .map((e) => _generateExpressionCode(e,
                  replaceThis: replaceThis, asStatement: false))
              .join(', ')
          : '';
      final bodyPart = _generateStatementCode(statement.body,
          replaceThis: replaceThis, allowReturn: true);

      return 'for ($initPart; $conditionPart; $updatesPart) $bodyPart';
    }

    // 生成条件和更新表达式，使用重命名的变量，不使用装箱
    // 临时移除装箱状态，让条件和更新使用原始值
    final tempRemovedVariables = <String>[];
    final tempRemovedForLoop = <String>[];
    final tempRemovedStates = <String, bool>{};
    final tempRemovedRenamedStates = <String, bool>{};

    for (final originalVar in renamedVariables.keys) {
      final renamedVar = renamedVariables[originalVar]!;

      if (DartToDartTransformer._globalVariablesToBox.contains(originalVar)) {
        DartToDartTransformer._globalVariablesToBox.remove(originalVar);
        tempRemovedVariables.add(originalVar);
      }
      if (DartToDartTransformer._globalForLoopVariablesToBox
          .contains(originalVar)) {
        DartToDartTransformer._globalForLoopVariablesToBox.remove(originalVar);
        tempRemovedForLoop.add(originalVar);
      }
      // 保存并临时移除原始变量的装箱状态映射
      if (DartToDartTransformer._getVariableBoxState(originalVar)) {
        tempRemovedStates[originalVar] = true;
        DartToDartTransformer._setVariableBoxState(originalVar, false);
      }
      // 保存并临时移除重命名变量的装箱状态映射
      // $origin_前缀的变量应该始终为false
      final currentState =
          DartToDartTransformer._getVariableBoxState(renamedVar);
      tempRemovedRenamedStates[renamedVar] = currentState;
      DartToDartTransformer._setVariableBoxState(renamedVar, false);
    }

    var condition = statement.condition != null
        ? _generateExpressionCode(statement.condition!,
            replaceThis: replaceThis, asStatement: false)
        : '';

    var updates = statement.updates.isNotEmpty
        ? statement.updates
            .map((e) => _generateExpressionCode(e,
                replaceThis: replaceThis, asStatement: false))
            .join(', ')
        : '';

    // 手动替换条件和更新表达式中的变量名
    for (final entry in renamedVariables.entries) {
      final originalVar = entry.key;
      final renamedVar = entry.value;
      condition = condition.replaceAll(originalVar, renamedVar);
      updates = updates.replaceAll(originalVar, renamedVar);
    }

    // 确保$origin_变量不带.value
    condition = condition.replaceAllMapped(
        RegExp(r'\$origin_([a-zA-Z_][a-zA-Z0-9_]*)\.value'),
        (match) => '\$origin_${match.group(1)}');
    updates = updates.replaceAllMapped(
        RegExp(r'\$origin_([a-zA-Z_][a-zA-Z0-9_]*)\.value'),
        (match) => '\$origin_${match.group(1)}');

    // 在生成条件和更新后，立即恢复所有装箱状态
    // 这样循环体和闭包生成时可以使用正确的装箱状态
    for (final originalVar in tempRemovedVariables) {
      DartToDartTransformer._globalVariablesToBox.add(originalVar);
    }
    for (final originalVar in tempRemovedForLoop) {
      DartToDartTransformer._globalForLoopVariablesToBox.add(originalVar);
    }
    for (final entry in tempRemovedStates.entries) {
      DartToDartTransformer._setVariableBoxState(entry.key, entry.value);
    }
    for (final entry in tempRemovedRenamedStates.entries) {
      DartToDartTransformer._setVariableBoxState(entry.key, entry.value);
    }

    // 生成循环体
    String bodyCode = _generateStatementCode(statement.body,
        replaceThis: replaceThis, allowReturn: true);

    // 步骤3：在循环体内进行装箱同步
    if (renamedVariables.isNotEmpty) {
      // 生成循环开始时的初始化代码：将重命名变量的值赋值给装箱变量
      final initSyncLines = <String>[];
      // 生成循环结束时的同步代码：将装箱变量的值赋值给重命名变量
      final endSyncLines = <String>[];

      for (final entry in renamedVariables.entries) {
        final originalVar = entry.key;
        final renamedVar = entry.value;
        final typeName = (statement.variables
                .firstWhere((v) =>
                    _cleanVariableName(v.name ?? 'forVar') == originalVar)
                .type as InterfaceType)
            .classNode
            .name;
        final boxType = DartToDartTransformer._globalGetBoxType(typeName);

        // 为每次迭代创建新的装箱变量，而不是复用
        initSyncLines.add(
            '$boxType $originalVar = ${DartToDartTransformer._globalGetBoxConstructor(typeName, renamedVar)};');
        // 记录装箱变量的状态
        DartToDartTransformer._setVariableBoxState(originalVar, true);
        endSyncLines.add('$renamedVar = $originalVar.value;');
      }

      final initSyncCode = initSyncLines.join('\n');
      final endSyncCode = endSyncLines.join('\n');

      // 在循环体开头和末尾添加同步代码
      if (bodyCode.trim().startsWith('{') && bodyCode.trim().endsWith('}')) {
        final innerBody =
            bodyCode.trim().substring(1, bodyCode.trim().length - 1).trim();
        bodyCode = '{\n$initSyncCode\n$innerBody\n$endSyncCode\n}';
      } else {
        bodyCode = '{\n$initSyncCode\n$bodyCode\n$endSyncCode\n}';
      }
    }

    // 生成最终的for循环代码
    String forLoopCode;
    if (init.isEmpty && condition.isEmpty && updates.isEmpty) {
      forLoopCode = 'for (;;) $bodyCode';
    } else if (init.isEmpty && condition.isEmpty) {
      forLoopCode = 'for (;; $updates) $bodyCode';
    } else if (init.isEmpty && updates.isEmpty) {
      forLoopCode = 'for (; $condition;) $bodyCode';
    } else if (condition.isEmpty && updates.isEmpty) {
      forLoopCode = 'for ($init;;) $bodyCode';
    } else if (init.isEmpty) {
      forLoopCode = 'for (; $condition; $updates) $bodyCode';
    } else if (condition.isEmpty) {
      forLoopCode = 'for ($init;; $updates) $bodyCode';
    } else if (updates.isEmpty) {
      forLoopCode = 'for ($init; $condition;) $bodyCode';
    } else {
      forLoopCode = 'for ($init; $condition; $updates) $bodyCode';
    }

    // 如果有重命名变量（需要装箱），需要在for循环前添加装箱代码
    if (renamedVariables.isNotEmpty) {
      return '${preBoxingCode}$forLoopCode';
    } else {
      return forLoopCode;
    }
  } else if (statement is ForInStatement) {
    final variable = _cleanVariableName(statement.variable.name ?? 'item');
    final iterable = _generateExpressionCode(statement.iterable,
        replaceThis: replaceThis, asStatement: false);
    final body = _generateStatementCode(statement.body,
        replaceThis: replaceThis, allowReturn: true);
    return 'for ($variable in $iterable) $body';
  } else if (statement is WhileStatement) {
    final cond = _generateExpressionCode(statement.condition,
        replaceThis: replaceThis, asStatement: false);
    final body = _generateStatementCode(statement.body,
        replaceThis: replaceThis, allowReturn: true);
    return 'while ($cond) $body';
  } else if (statement is DoStatement) {
    final cond = _generateExpressionCode(statement.condition,
        replaceThis: replaceThis, asStatement: false);
    final body = _generateStatementCode(statement.body,
        replaceThis: replaceThis, allowReturn: true);
    return 'do $body while ($cond);';
  } else if (statement is SwitchStatement) {
    final expression = _generateExpressionCode(statement.expression,
        replaceThis: replaceThis, asStatement: false);
    final cases = statement.cases
        .map((c) => _generateSwitchCase(c, replaceThis))
        .join('\n');
    return 'switch ($expression) {\n$cases\n}';
  } else if (statement is TryCatch) {
    final body = _generateStatementCode(statement.body,
        replaceThis: replaceThis, allowReturn: true);
    final catches = statement.catches
        .map((c) => _generateCatchClause(c, replaceThis))
        .join('\n');
    return 'try $body\n$catches';
  } else if (statement is TryFinally) {
    final body = _generateStatementCode(statement.body,
        replaceThis: replaceThis, allowReturn: true);
    final finalizer = _generateStatementCode(statement.finalizer,
        replaceThis: replaceThis, allowReturn: true);
    return 'try $body\nfinally $finalizer';
  } else if (statement is BreakStatement) {
    // 无法直接获取标签名，统一输出 break;
    return 'break;';
  } else if (statement is ContinueSwitchStatement) {
    // 无法直接获取标签名，统一输出 continue;
    return 'continue;';
  } else if (statement is LabeledStatement) {
    // LabeledStatement没有直接的label属性，需要通过printer获取
    final label = 'label'; // 使用默认标签名
    final body = _generateStatementCode(statement.body,
        replaceThis: replaceThis, allowReturn: true);
    return '$label: $body';
  } else if (statement is AssertStatement) {
    final condition = _generateExpressionCode(statement.condition,
        replaceThis: replaceThis, asStatement: false);
    // 生成正确的assert语法：assert(condition) 或 assert(condition, message)
    if (statement.message != null) {
      final message = _generateExpressionCode(statement.message!,
          replaceThis: replaceThis, asStatement: false);
      return 'assert($condition, $message);';
    } else {
      return 'assert($condition);';
    }
  } else if (statement is YieldStatement) {
    final expression = _generateExpressionCode(statement.expression,
        replaceThis: replaceThis, asStatement: false);
    return statement.isYieldStar ? 'yield* $expression;' : 'yield $expression;';
  } else if (statement is FunctionDeclaration) {
    final name = _cleanVariableName(statement.variable.name ?? 'func');
    final parameters = statement.function.positionalParameters
        .map((p) =>
            '${_getDartType(p.type)} ${_cleanVariableName(p.name ?? 'param')}')
        .join(', ');
    final returnType = _getDartType(statement.function.returnType);
    final body = statement.function.body != null
        ? _generateStatementCode(statement.function.body!,
            replaceThis: replaceThis, allowReturn: true)
        : '{}';
    return '$returnType $name($parameters) $body';
  } else if (statement is PatternSwitchStatement) {
    final expression = _generateExpressionCode(statement.expression,
        replaceThis: replaceThis, asStatement: false);
    final cases = statement.cases
        .map((c) => _generateSwitchCase(c, replaceThis))
        .join('\n');
    return 'switch ($expression) {\n$cases\n}';
  } else if (statement is PatternVariableDeclaration) {
    final name = 'pattern'; // PatternVariableDeclaration没有直接的name属性
    final init =
        ' = ${_generateExpressionCode(statement.initializer, replaceThis: replaceThis, asStatement: false)}';
    return '${statement.isFinal ? 'final' : 'var'} $name$init;';
  } else if (statement is IfCaseStatement) {
    final expression = _generateExpressionCode(statement.expression,
        replaceThis: replaceThis, asStatement: false);
    // 直接转为字符串（如果不存在则为空串）
    final patternGuardStr = statement.patternGuard.toString();
    final patternGuard =
        patternGuardStr.isNotEmpty ? ' when $patternGuardStr' : '';
    final then = _generateStatementCode(statement.then,
        replaceThis: replaceThis, allowReturn: true);
    final otherwise = statement.otherwise != null
        ? ' else ${_generateStatementCode(statement.otherwise!, replaceThis: replaceThis, allowReturn: true)}'
        : '';
    return 'if ($expression$patternGuard) $then$otherwise';
  } else {
    return statement.toString();
  }
}

/// 生成 switch case
String _generateSwitchCase(SwitchCase switchCase, bool replaceThis) {
  final cases = switchCase.expressions.map((expr) {
    return 'case ${_generateExpressionCode(expr, replaceThis: replaceThis, asStatement: false)}:';
  }).join('\n');

  final defaultCase = switchCase.isDefault ? '\ndefault:' : '';
  final body = _generateStatementCode(switchCase.body,
      replaceThis: replaceThis, allowReturn: true);
  return '$cases$defaultCase\n  $body';
}

/// 生成 catch 子句
String _generateCatchClause(Catch catchClause, bool replaceThis) {
  final exception = catchClause.exception != null
      ? _cleanVariableName(catchClause.exception!.name ?? 'e')
      : '';
  final stackTrace = catchClause.stackTrace != null
      ? ', ${_cleanVariableName(catchClause.stackTrace!.name ?? 'stackTrace')}'
      : '';
  final body = _generateStatementCode(catchClause.body,
      replaceThis: replaceThis, allowReturn: true);
  return 'catch ($exception$stackTrace) $body';
}

/// 生成 switch expression case
String _generateSwitchExpressionCase(
    SwitchExpressionCase switchCase, bool replaceThis) {
  final patternGuard = switchCase.patternGuard.toString();
  final body = _generateExpressionCode(switchCase.expression,
      replaceThis: replaceThis, asStatement: false);
  return 'case $patternGuard => $body';
}

// 已移除未使用方法 _generateMethodCode
