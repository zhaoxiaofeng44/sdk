import 'dart:io';

import 'package:kernel/kernel.dart';
import 'package:kernel/ast.dart';
import 'package:front_end/src/kernel/internal_ast.dart';

/// 类信息
class ClassInfo {
  final Class cls;
  final List<Field> lateFields = [];
  final List<Constructor> constructors = [];
  final List<Procedure> staticMethods = [];

  ClassInfo(this.cls);
}

/// Dart到Dart转换器 - 将Dart源码转换为新的Dart类型
class DartToDartTransformer {
  final StringBuffer _buffer = StringBuffer();
  int _indentLevel = 0;

  // 存储转换后的类信息
  final Map<Class, ClassInfo> _classInfoMap = {};

  // 当前正在处理的类名，用于内部函数调用
  String? _currentClassName;

  // 类名替换映射，用于 @pragma('cpp:patch', 'Error') 注解
  final Map<String, String> _classNameReplacements = {};

  /// 主要转换入口
  void transformComponent(Component component) {
    _buffer.clear();

    // 生成转换后的代码
    _generateTransformedCode(component);
    _checkGeneratedCode();
    // 输出到文件
    _writeOutput();
  }

  /// 判断是否应该跳过某个类
  bool _shouldSkipClass(Class cls) {
    if (_hasCppNativePragma(cls)) {
      return true;
    }

    final libraryUri = cls.enclosingLibrary.fileUri;
    final filePath =
        libraryUri.isScheme('file') ? libraryUri.path : libraryUri.toString();

    final libraryName = cls.enclosingLibrary.toStringInternal();
    final shouldSkip = libraryName.startsWith('dart.') ||
        libraryName.startsWith('dart:') ||
        libraryName.startsWith('package:flutter') ||
        filePath.contains('org-dartlang-sdk');

    return shouldSkip;
  }

  /// 检查类是否有 @pragma('cpp:native', xxx) 注解
  bool _hasCppNativePragma(Class cls) {
    for (final annotation in cls.annotations) {
      if (annotation is ConstantExpression) {
        final constant = annotation.constant;
        if (constant is InstanceConstant) {
          final classNode = constant.classNode;
          if (classNode.name == 'pragma') {
            if (constant.fieldValues.containsKey('name')) {
              final nameValue = constant.fieldValues['name'];
              if (nameValue is StringConstant &&
                  nameValue.value == 'cpp:native') {
                return true;
              }
            }
          }
        }
      }
    }
    return false;
  }

  /// 调试：打印类的注解信息
  void _debugPrintAnnotations(Class cls) {}

  /// 获取类的 @pragma('cpp:patch', 'Error') 注解信息
  String? _getCppPatchPragma(Class cls) {
    for (final annotation in cls.annotations) {
      if (annotation is ConstantExpression) {
        final constant = annotation.constant;
        if (constant is InstanceConstant) {
          final classNode = constant.classNode;
          if (classNode.name == 'pragma') {
            // 检查参数
            if (constant.fieldValues.containsKey('name')) {
              final nameValue = constant.fieldValues['name'];
              if (nameValue is StringConstant &&
                  nameValue.value == 'cpp:patch') {
                // 检查第二个参数
                if (constant.fieldValues.containsKey('arguments')) {
                  final argsValue = constant.fieldValues['arguments'];
                  if (argsValue is ListConstant &&
                      argsValue.entries.isNotEmpty) {
                    final firstArg = argsValue.entries[0];
                    if (firstArg is StringConstant) {
                      return firstArg.value;
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
    return null;
  }

  /// 收集类信息
  void _collectClassInfo(Class cls) {
    // 跳过org-dartlang-sdk的类
    final libraryName = cls.enclosingLibrary.toStringInternal();
    if (libraryName.contains('org-dartlang-sdk')) {
      return;
    }

    // 检查是否有 @pragma('cpp:patch', 'Error') 注解
    final patchTarget = _getCppPatchPragma(cls);
    if (patchTarget != null) {
      _classNameReplacements[patchTarget] = cls.name;
    }

    final classInfo = ClassInfo(cls);

    // 收集需要转换为late的字段
    for (final field in cls.fields) {
      if (!field.isStatic && field.isFinal) {
        classInfo.lateFields.add(field);
      }
    }

    // 收集构造方法
    classInfo.constructors.addAll(cls.constructors);

    // 收集需要转换为静态方法的成员方法
    for (final procedure in cls.procedures) {
      if (!procedure.isStatic &&
          !procedure.isAbstract &&
          !procedure.isFactory &&
          !procedure.isGetter &&
          !procedure.isSetter) {
        // 检查是否为运算符重载方法
        final methodName = procedure.name.text;
        final isOperator = methodName == '[]' ||
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
            methodName == '>=';

        if (!isOperator) {
          classInfo.staticMethods.add(procedure);
        }
      }
    }

    _classInfoMap[cls] = classInfo;
  }

  /// 生成转换后的代码
  void _generateTransformedCode(Component component) {
    // 生成库导入
    _writeLibraryImports(component);

    // 生成转换后的类
    for (final library in component.libraries) {
      for (final cls in library.classes) {
        if (!_shouldSkipClass(cls)) {
          _collectClassInfo(cls);
          _generateTransformedClass(cls);
        }
      }
    }
  }

  /// 写入库导入
  void _writeLibraryImports(Component component) {
    // 添加基本的导入
    _writeLine("import 'dart:core';");
    _writeLine("import 'dart:io';");
    _writeLine('');

    // 添加全局Void类型变量
    _writeLine("/// 全局Void类型变量，用于替代void返回值");
    _writeLine("final Void = null;");
    _writeLine('');
  }

  /// 生成转换后的类
  void _generateTransformedClass(Class cls) {
    // 设置当前类名，用于内部函数调用
    _currentClassName = cls.name;

    final patchTarget = _getCppPatchPragma(cls);
    final className = patchTarget ?? cls.name;

    // 获取文件路径信息
    final libraryUri = cls.enclosingLibrary.fileUri;
    final filePath =
        libraryUri.isScheme('file') ? libraryUri.path : libraryUri.toString();

    // 类注释 - 包含文件路径信息
    _writeLine('/// 转换后的类: $className');
    _writeLine('/// 源文件路径: $filePath');
    _writeLine('');

    // 类声明
    _write('class $className');
    // 泛型参数
    String typeParams = '';
    if (cls.typeParameters.isNotEmpty) {
      typeParams = '<${cls.typeParameters.map((t) => t.name).join(', ')}>';
      _write(typeParams);
    }
    // 继承关系
    String? extendsClause;
    if (cls.superclass != null && cls.superclass!.name != 'Object') {
      String superName = cls.superclass!.name;
      if (_classNameReplacements.containsKey(superName)) {
        superName = _classNameReplacements[superName]!;
      }
      // 传递泛型参数给父类
      if (cls.superclass!.typeParameters.isNotEmpty &&
          cls.typeParameters.isNotEmpty) {
        superName += '<${cls.typeParameters.map((t) => t.name).join(', ')}>';
      }
      extendsClause = 'extends $superName';
    }
    // 接口实现
    String? implementsClause;
    if (cls.implementedTypes.isNotEmpty) {
      final impls = cls.implementedTypes.map((t) {
        String name = t.classNode.name;
        if (_classNameReplacements.containsKey(name)) {
          name = _classNameReplacements[name]!;
        }
        if (t.classNode.typeParameters.isNotEmpty &&
            cls.typeParameters.isNotEmpty) {
          name += '<${cls.typeParameters.map((tp) => tp.name).join(', ')}>';
        }
        return name;
      }).join(', ');
      implementsClause = 'implements $impls';
    }
    if (extendsClause != null) _write(' $extendsClause');
    if (implementsClause != null) _write(' $implementsClause');

    print('constructor: $cls');
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

        final type = _getDartType(field.type);
        final name = field.name?.text ?? 'unnamed';
        final modifierStr = modifiers.isEmpty ? '' : '${modifiers.join(' ')} ';

        _writeLine('$modifierStr$type $name;');
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
      final name = field.name?.text ?? 'unnamed';
      _writeLine('late $type $name;');
    }
  }

  /// 生成成员方法
  void _generateMemberMethods(Class cls) {
    // 生成getter和setter
    for (final procedure in cls.procedures) {
      if (procedure.isGetter) {
        _generateGetter(cls, procedure);
      } else if (procedure.isSetter) {
        _generateSetter(cls, procedure);
      } else if (!procedure.isStatic &&
          !procedure.isAbstract &&
          !procedure.isFactory) {
        // 生成普通成员方法
        _generateMemberMethod(procedure);
      }
    }

    // 生成静态方法
    final classInfo = _classInfoMap[cls];
    if (classInfo != null) {
      for (final procedure in classInfo.staticMethods) {
        _generateStaticMethod(cls, procedure);
      }
    }
  }

  /// 生成无参构造方法
  void _generateDefaultConstructor(Class cls) {
    _writeLine('${cls.name}();');
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
    print('constructor: $constructor');
    final name = constructor.name?.text ?? '';
    final constructorName = name.isEmpty ? cls.name : '${cls.name}.$name';

    // 参数列表
    final parameters =
        _writeParameterList(constructor.function.positionalParameters);

    _write('$constructorName($parameters)');

    // 初始化列表
    if (constructor.initializers.isNotEmpty) {
      _write(' : ');
      final initializers = constructor.initializers
          .map(_initializerToString)
          .where((s) => s.isNotEmpty)
          .join(', ');
      _write(initializers);
    }

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
    _writeLine('');
  }

  /// 生成 getter 方法
  void _generateGetter(Class cls, Procedure procedure) {
    final returnType = _getDartType(procedure.function.returnType);
    final name = procedure.name.text;

    _writeLine('static $returnType $name(Object self) {');
    _indent();

    final body = _generateGetterBody(procedure.function);
    _writeLine('return $body;');

    _unindent();
    _writeLine('}');
    _writeLine('');
  }

  /// 生成 setter 方法
  void _generateSetter(Class cls, Procedure procedure) {
    final param = procedure.function.positionalParameters.first;
    final paramType = _getDartType(param.type);
    final paramName = _cleanVariableName(param.name!);
    // 不使用字符串替换，而是检查是否以 = 结尾
    final name = procedure.name.text.endsWith('=')
        ? procedure.name.text.substring(0, procedure.name.text.length - 1)
        : procedure.name.text;
    _writeLine('static set $name(Object self, $paramType $paramName) {');
    _indent();
    final bodyStr =
        _writeTransformedStatementToString(procedure.function.body!);
    _writeLine(bodyStr);
    _unindent();
    _writeLine('}');
    _writeLine('');
  }

  /// 生成 getter 方法体
  String _generateGetterBody(FunctionNode function) {
    if (function.body != null) {
      return _writeTransformedStatementToString(function.body!);
    }
    return 'null'; // 默认返回值
  }

  /// 将语句转换为字符串
  String _statementToString(Statement statement) {
    return _generateStatementCode(statement, replaceThis: false);
  }

  /// 将语句转换为字符串（转换后）
  String _writeTransformedStatementToString(Statement statement) {
    return _generateStatementCode(statement, replaceThis: true);
  }

  /// 转换语句并写入
  void _writeTransformedStatement(Statement statement) {
    final str = _writeTransformedStatementToString(statement);
    _writeLine(str);
  }

  /// 生成单个成员方法
  void _generateMemberMethod(Procedure procedure) {
    final returnType = _getDartType(procedure.function.returnType);
    final name = procedure.name.text;
    final parameters =
        _writeParameterList(procedure.function.positionalParameters);
    _writeLine('$returnType $name($parameters) {');
    _indent();
    final bodyStr =
        _writeTransformedStatementToString(procedure.function.body!);
    _writeLine(bodyStr);
    _unindent();
    _writeLine('}');
    _writeLine('');
  }

  /// 生成单个静态方法
  void _generateStaticMethod(Class cls, Procedure procedure) {
    final returnType = _getDartType(procedure.function.returnType);
    final name = procedure.name.text;
    final parameters =
        _writeParameterList(procedure.function.positionalParameters);
    _writeLine(
        'static $returnType $name(Object self${parameters.isEmpty ? '' : ', $parameters'}) {');
    _indent();
    final bodyStr =
        _writeTransformedStatementToString(procedure.function.body!);
    _writeLine(bodyStr);
    _unindent();
    _writeLine('}');
    _writeLine('');
  }

  /// 生成运算符重载方法
  void _generateOperatorMethods(Class cls) {
    for (final procedure in cls.procedures) {
      if (procedure.isStatic ||
          procedure.isAbstract ||
          procedure.isFactory ||
          procedure.isGetter ||
          procedure.isSetter) continue;
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
          methodName == '>=') {
        _generateOperatorMethod(procedure);
      }
    }
  }

  /// 生成操作符方法
  void _generateOperatorMethod(Procedure procedure) {
    final returnType = _getDartType(procedure.function.returnType);
    final op = procedure.name.text;
    final parameters =
        _writeParameterList(procedure.function.positionalParameters);
    _writeLine('$returnType operator $op($parameters) {');
    _indent();
    if (procedure.function.body != null) {
      final bodyStr =
          _generateStatementCode(procedure.function.body!, replaceThis: false);
      _writeLine(bodyStr);
    }
    _unindent();
    _writeLine('}');
    _writeLine('');
  }

  /// 写入参数列表
  void _writeParameters(FunctionNode function, {bool onlyFirst = false}) {
    final params = onlyFirst
        ? function.positionalParameters.take(1)
        : function.positionalParameters;
    _write(_writeParameterList(params.toList()));
  }

  /// 生成参数列表
  String _writeParameterList(List<VariableDeclaration> parameters) {
    return parameters.map((param) {
      final type = _getDartType(param.type);
      final name = _cleanVariableName(param.name!);
      return '$type $name';
    }).join(', ');
  }

  /// 获取Dart类型字符串
  String _getDartType(DartType type) {
    if (type is DynamicType) {
      return 'Object';
    } else if (type is InterfaceType) {
      return type.classNode.name;
    } else if (type is FunctionType) {
      final params = type.requiredParameterCount > 0
          ? 'Object' * type.requiredParameterCount
          : '';
      return 'Function($params) => Object';
    } else {
      return 'Object';
    }
  }

  /// 注解转字符串
  String _annotationToString(Expression annotation) {
    if (annotation is ConstantExpression) {
      final constant = annotation.constant;
      if (constant is StringConstant) {
        return '"${constant.value}"';
      } else if (constant is IntConstant) {
        return constant.value.toString();
      } else if (constant is BoolConstant) {
        return constant.value.toString();
      } else if (constant is DoubleConstant) {
        return constant.value.toString();
      }
    }
    return annotation.toString();
  }

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

  /// 方法体/表达式体
  void _writeBlockOrExpr(Statement? body) {
    if (body is ExpressionStatement) {
      final expr = _expressionToString(body.expression);
      // 避免重复的 return 关键字
      if (expr.startsWith('return ')) {
        _writeLine('$expr;');
      } else if (expr.startsWith('throw ')) {
        _writeLine('$expr;');
      } else {
        _writeLine('return $expr;');
      }
    } else if (body is Block) {
      for (final stmt in body.statements) {
        _writeTransformedStatement(stmt);
      }
    }
  }

  /// 清理变量名，将不合法的变量名转换为合法的Dart变量名
  String _cleanVariableName(String name) {
    if (name.isEmpty) return 'temp';

    // 处理包含特殊字符的变量名
    if (name.contains('#')) {
      // 提取数字部分作为后缀
      final match = RegExp(r'_#wc(\d+)#formal').firstMatch(name);
      if (match != null) {
        final number = match.group(1);
        return 'formal_$number';
      }

      // 处理 #closure 等特殊情况
      if (name.contains('#closure')) {
        // 不使用字符串替换，而是构建新的字符串
        final parts = name.split('#');
        return parts.join('_');
      }

      // 其他包含#的变量名
      final parts = name.split('#');
      final cleanParts = parts.map((part) {
        // 移除非字母数字下划线字符
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
      });
      return cleanParts.join('_');
    }

    // 处理以数字开头的变量名
    if (RegExp(r'^\d').hasMatch(name)) {
      return 'var_$name';
    }

    // 处理包含其他特殊字符的变量名
    if (RegExp(r'[^a-zA-Z0-9_]').hasMatch(name)) {
      // 不使用字符串替换，而是构建新的字符串
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

    return name;
  }

  /// 转换表达式，将this替换为self
  String _expressionToString(Expression expression) {
    return _generateExpressionCode(expression,
        replaceThis: true, asStatement: false);
  }

  /// 转换表达式，用于运算符重载方法（保持this引用）
  String _expressionToStringForOperator(Expression expression) {
    return _generateExpressionCode(expression,
        replaceThis: false, asStatement: false);
  }

  /// 写入一行
  void _writeLine(String text) {
    _buffer.write('  ' * _indentLevel + text + '\n');
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
  void _writeOutput() {
    try {
      final outputFile = File('./transformed_dart.dart');
      outputFile.writeAsStringSync(_buffer.toString());
    } catch (e) {}
  }

  /// 获取生成的代码
  String getGeneratedCode() {
    return _buffer.toString();
  }

  /// 自动检查生成的代码
  void _checkGeneratedCode() {
    final code = _buffer.toString();
    if (!code.contains('class') || !code.contains('late')) {
    } else {}
  }
}

/// 全局转换函数
void transformDartToDart(Component component) {
  final transformer = DartToDartTransformer();
  transformer.transformComponent(component);
}

/// 全局版本的清理变量名函数
String _cleanVariableName(String name) {
  if (name.isEmpty) return 'temp';

  // 处理包含特殊字符的变量名
  if (name.contains('#')) {
    // 提取数字部分作为后缀
    final match = RegExp(r'_#wc(\d+)#formal').firstMatch(name);
    if (match != null) {
      final number = match.group(1);
      return 'formal_$number';
    }

    // 处理 #closure 等特殊情况
    if (name.contains('#closure')) {
      // 不使用字符串替换，而是构建新的字符串
      final parts = name.split('#');
      return parts.join('_');
    }

    // 其他包含#的变量名
    final parts = name.split('#');
    final cleanParts = parts.map((part) {
      // 移除非字母数字下划线字符
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
    });
    return cleanParts.join('_');
  }

  // 处理以数字开头的变量名
  if (RegExp(r'^\d').hasMatch(name)) {
    return 'var_$name';
  }

  // 处理包含其他特殊字符的变量名
  if (RegExp(r'[^a-zA-Z0-9_]').hasMatch(name)) {
    // 不使用字符串替换，而是构建新的字符串
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

  // 处理 unnamed 或空变量名
  if (name == 'unnamed' || name.isEmpty) {
    return 'temp';
  }

  return name;
}

/// 全局版本的获取Dart类型函数
String _getDartType(DartType type) {
  if (type is DynamicType) {
    return 'Object';
  } else if (type is InterfaceType) {
    return type.classNode.name;
  } else if (type is FunctionType) {
    final params = type.requiredParameterCount > 0
        ? 'Object' * type.requiredParameterCount
        : '';
    return 'Function($params) => Object';
  } else {
    return 'Object';
  }
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

/// 获取一元运算符
String _getUnaryOperator(String operator) {
  switch (operator) {
    case 'unary-':
      return '-';
    case '!':
      return '!';
    case '~':
      return '~';
    default:
      return operator;
  }
}

/// 获取二元运算符
String _getBinaryOperator(String operator) {
  switch (operator) {
    case 'LESS_THAN':
      return '<';
    case 'GREATER_THAN':
      return '>';
    case 'LESS_THAN_OR_EQUALS':
      return '<=';
    case 'GREATER_THAN_OR_EQUALS':
      return '>=';
    case 'EQUALS':
      return '==';
    case 'NOT_EQUALS':
      return '!=';
    case 'ADD':
      return '+';
    case 'SUBTRACT':
      return '-';
    case 'MULTIPLY':
      return '*';
    case 'DIVIDE':
      return '/';
    case 'MODULO':
      return '%';
    case '[]':
      return '[]';
    case '[]=':
      return '[]=';
    default:
      return operator;
  }
}

String _generateExpressionCode(Expression expression,
    {bool replaceThis = false, bool asStatement = false}) {
  print('expression: $expression');
  if (expression is ThisExpression) {
    return 'this';
  } else if (expression is VariableGet) {
    return _cleanVariableName(expression.variable.name ?? 'unnamed');
  } else if (expression is VariableSet) {
    return '${_cleanVariableName(expression.variable.name ?? 'unnamed')} = '
        '${_generateExpressionCode(expression.value, replaceThis: replaceThis, asStatement: false)}';
  } else if (expression is RecordIndexGet) {
    return '${_generateExpressionCode(expression.receiver, replaceThis: replaceThis, asStatement: false)}.${expression.index + 1}';
  } else if (expression is RecordNameGet) {
    return '${_generateExpressionCode(expression.receiver, replaceThis: replaceThis, asStatement: false)}.${expression.name}';
  } else if (expression is DynamicGet) {
    final receiver = _generateExpressionCode(expression.receiver,
        replaceThis: replaceThis, asStatement: false);
    final name = expression.name.text;

    // 处理包含类型信息的属性访问
    if (name.contains('{num.<}')) return '$receiver < 0';
    if (name.contains('{num.>}')) return '$receiver > 0';
    if (name.contains('{num.<=}')) return '$receiver <= 0';
    if (name.contains('{num.>=}')) return '$receiver >= 0';
    if (name.contains('{num.+}')) return '$receiver + 1';
    if (name.contains('{num.-}')) return '$receiver - 1';
    if (name.contains('{num.*}')) return '$receiver * 1';
    if (name.contains('{num./}')) return '$receiver / 1';
    if (name.contains('{num.%}')) return '$receiver % 1';
    if (name.contains('{num.==}')) return '$receiver == 0';
    if (name.contains('{num.!=}')) return '$receiver != 0';
    if (name.contains('{num.+=}')) return '$receiver += 1';
    if (name.contains('{num.-=}')) return '$receiver -= 1';
    if (name.contains('{num.++}')) return '$receiver++';
    if (name.contains('{num.--}')) return '$receiver--';

    if (name.contains('{Iterator.moveNext}')) return '$receiver.moveNext()';
    if (name.contains('{Iterator.current}')) return '$receiver.current';
    if (name.contains('{CppList._array}')) return '$receiver._array';
    if (name.contains('{CppList.length}')) return '$receiver.length';
    if (name.contains('{CppSet._list}')) return '$receiver._list';
    if (name.contains('{CppMap._list}')) return '$receiver._list';
    if (name.contains('{CppSkipIterator._count}')) return '$receiver._count';
    if (name.contains('{CppMappedIterator._iterator}'))
      return '$receiver._iterator';
    if (name.contains('{CppMappedIterator._current}'))
      return '$receiver._current';
    if (name.contains('{CppMappedIterator._f}')) return '$receiver._f';
    if (name.contains('{CppWhereIterator._iterator}'))
      return '$receiver._iterator';
    if (name.contains('{CppWhereIterator._test}')) return '$receiver._test';
    if (name.contains('{CppWhereTypeIterator._iterator}'))
      return '$receiver._iterator';
    if (name.contains('{CppExpandIterator._iterator}'))
      return '$receiver._iterator';
    if (name.contains('{CppExpandIterator._currentIterator}'))
      return '$receiver._currentIterator';
    if (name.contains('{CppExpandIterator._f}')) return '$receiver._f';
    if (name.contains('{CppTakeIterator._iterator}'))
      return '$receiver._iterator';
    if (name.contains('{CppTakeWhileIterator._iterator}'))
      return '$receiver._iterator';
    if (name.contains('{CppTakeWhileIterator._test}')) return '$receiver._test';
    if (name.contains('{CppSkipIterator._iterator}'))
      return '$receiver._iterator';
    if (name.contains('{CppSkipWhileIterator._iterator}'))
      return '$receiver._iterator';
    if (name.contains('{CppSkipWhileIterator._test}')) return '$receiver._test';
    if (name.contains('{CppFollowedByIterable._first}'))
      return '$receiver._first';
    if (name.contains('{CppFollowedByIterable._second}'))
      return '$receiver._second';
    if (name.contains('{CppFollowedByIterator._first}'))
      return '$receiver._first';
    if (name.contains('{CppFollowedByIterator._second}'))
      return '$receiver._second';
    if (name.contains('{CppFollowedByIterator._usingFirst}'))
      return '$receiver._usingFirst';
    if (name.contains('{CppCastIterator._iterator}'))
      return '$receiver._iterator';
    if (name.contains('{_CppGenerateIterator._index}'))
      return '$receiver._index';
    if (name.contains('{_CppGenerateIterator._count}'))
      return '$receiver._count';
    if (name.contains('{_CppGenerateIterator._current}'))
      return '$receiver._current';
    if (name.contains('{_CppGenerateIterator._generator}'))
      return '$receiver._generator';
    if (name.contains('{_CppCastFromIterator._iterator}'))
      return '$receiver._iterator';
    if (name.contains('{CppStringBuffer._parts}')) return '$receiver._parts';
    if (name.contains('{Object.toString}')) return '$receiver.toString()';
    if (name.contains('{String.length}')) return '$receiver.length';
    if (name.contains('{Iterable.iterator}')) return '$receiver.iterator';
    if (name.contains('{Iterable.length}')) return '$receiver.length';

    if (name == '.<' || name == '<') return '$receiver < 0';
    if (name == '.>' || name == '>') return '$receiver > 0';
    if (name == '.+' || name == '+') return '$receiver + 1';
    if (name == '.-' || name == '-') return '$receiver - 1';
    if (name == '.++' || name == '++') return '$receiver++';
    if (name == '.--' || name == '--') return '$receiver--';
    if (name == '.+=' || name == '+=') return '$receiver += 1';
    if (name == '.-=' || name == '-=') return '$receiver -= 1';
    if (name == '.[]' || name == '[]') return '$receiver[]';
    if (name == '.[]=' || name == '[]=') return '$receiver[]=';
    if (name.startsWith('.') && name.length > 1) {
      final op = name.substring(1);
      return '$receiver $op';
    }
    return '$receiver.$name';
  } else if (expression is InstanceGet) {
    final receiver = _generateExpressionCode(expression.receiver,
        replaceThis: replaceThis, asStatement: false);
    final propertyName = expression.name.text;

    // 处理包含类型信息的属性访问
    if (propertyName.contains('{Iterator.moveNext}'))
      return '$receiver.moveNext()';
    if (propertyName.contains('{Iterator.current}')) return '$receiver.current';
    if (propertyName.contains('{CppList._array}')) return '$receiver._array';
    if (propertyName.contains('{CppList.length}')) return '$receiver.length';
    if (propertyName.contains('{CppSet._list}')) return '$receiver._list';
    if (propertyName.contains('{CppMap._list}')) return '$receiver._list';
    if (propertyName.contains('{CppSkipIterator._count}'))
      return '$receiver._count';
    if (propertyName.contains('{CppMappedIterator._iterator}'))
      return '$receiver._iterator';
    if (propertyName.contains('{CppMappedIterator._current}'))
      return '$receiver._current';
    if (propertyName.contains('{CppMappedIterator._f}')) return '$receiver._f';
    if (propertyName.contains('{CppWhereIterator._iterator}'))
      return '$receiver._iterator';
    if (propertyName.contains('{CppWhereIterator._test}'))
      return '$receiver._test';
    if (propertyName.contains('{CppWhereTypeIterator._iterator}'))
      return '$receiver._iterator';
    if (propertyName.contains('{CppExpandIterator._iterator}'))
      return '$receiver._iterator';
    if (propertyName.contains('{CppExpandIterator._currentIterator}'))
      return '$receiver._currentIterator';
    if (propertyName.contains('{CppExpandIterator._f}')) return '$receiver._f';
    if (propertyName.contains('{CppTakeIterator._iterator}'))
      return '$receiver._iterator';
    if (propertyName.contains('{CppTakeWhileIterator._iterator}'))
      return '$receiver._iterator';
    if (propertyName.contains('{CppTakeWhileIterator._test}'))
      return '$receiver._test';
    if (propertyName.contains('{CppSkipIterator._iterator}'))
      return '$receiver._iterator';
    if (propertyName.contains('{CppSkipWhileIterator._iterator}'))
      return '$receiver._iterator';
    if (propertyName.contains('{CppSkipWhileIterator._test}'))
      return '$receiver._test';
    if (propertyName.contains('{CppFollowedByIterable._first}'))
      return '$receiver._first';
    if (propertyName.contains('{CppFollowedByIterable._second}'))
      return '$receiver._second';
    if (propertyName.contains('{CppFollowedByIterator._first}'))
      return '$receiver._first';
    if (propertyName.contains('{CppFollowedByIterator._second}'))
      return '$receiver._second';
    if (propertyName.contains('{CppFollowedByIterator._usingFirst}'))
      return '$receiver._usingFirst';
    if (propertyName.contains('{CppCastIterator._iterator}'))
      return '$receiver._iterator';
    if (propertyName.contains('{_CppGenerateIterator._index}'))
      return '$receiver._index';
    if (propertyName.contains('{_CppGenerateIterator._count}'))
      return '$receiver._count';
    if (propertyName.contains('{_CppGenerateIterator._current}'))
      return '$receiver._current';
    if (propertyName.contains('{_CppGenerateIterator._generator}'))
      return '$receiver._generator';
    if (propertyName.contains('{_CppCastFromIterator._iterator}'))
      return '$receiver._iterator';
    if (propertyName.contains('{CppStringBuffer._parts}'))
      return '$receiver._parts';
    if (propertyName.contains('{Object.toString}'))
      return '$receiver.toString()';
    if (propertyName.contains('{String.length}')) return '$receiver.length';
    if (propertyName.contains('{Iterable.iterator}'))
      return '$receiver.iterator';
    if (propertyName.contains('{Iterable.length}')) return '$receiver.length';

    if (propertyName == '.<' || propertyName == '<') return '$receiver < 0';
    if (propertyName == '.>' || propertyName == '>') return '$receiver > 0';
    if (propertyName == '.+' || propertyName == '+') return '$receiver + 1';
    if (propertyName == '.-' || propertyName == '-') return '$receiver - 1';
    if (propertyName == '.++' || propertyName == '++') return '$receiver++';
    if (propertyName == '.--' || propertyName == '--') return '$receiver--';
    if (propertyName == '.+=' || propertyName == '+=') return '$receiver += 1';
    if (propertyName == '.-=' || propertyName == '-=') return '$receiver -= 1';
    if (propertyName == '.[]' || propertyName == '[]') return '$receiver[]';
    if (propertyName == '.[]=' || propertyName == '[]=') return '$receiver[]=';
    if (propertyName.startsWith('.') && propertyName.length > 1) {
      final op = propertyName.substring(1);
      return '$receiver $op';
    }
    return '$receiver.$propertyName';
  } else if (expression is FunctionTearOff) {
    // kernel FunctionTearOff 用 receiver 字段
    return '${_generateExpressionCode(expression.receiver, replaceThis: replaceThis, asStatement: false)}.call';
  } else if (expression is InstanceTearOff) {
    final receiver = _generateExpressionCode(expression.receiver,
        replaceThis: replaceThis, asStatement: false);
    final name = expression.name.text;
    return '$receiver.$name';
  } else if (expression is StaticGet) {
    return expression.target.name.text;
  } else if (expression is StaticSet) {
    return '${expression.target.name.text} = ${_generateExpressionCode(expression.value, replaceThis: replaceThis, asStatement: false)}';
  } else if (expression is StaticTearOff) {
    return expression.target.name.text;
  } else if (expression is DynamicInvocation) {
    final receiver = _generateExpressionCode(expression.receiver,
        replaceThis: replaceThis, asStatement: false);
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
      if (op == '[]=') {
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
    return '$receiver.$name($allArgs)';
  } else if (expression is InstanceInvocation) {
    final receiver = _generateExpressionCode(expression.receiver,
        replaceThis: replaceThis, asStatement: false);
    final name = expression.name.text;
    final argsList = expression.arguments.positional;
    final args = argsList
        .map((e) => _generateExpressionCode(e,
            replaceThis: replaceThis, asStatement: false))
        .join(', ');
    final namedArgs = expression.arguments.named
        .map((na) =>
            '${na.name}: ${_generateExpressionCode(na.value, replaceThis: replaceThis, asStatement: false)}')
        .join(', ');
    final allArgs = [args, namedArgs].where((s) => s.isNotEmpty).join(', ');

    // 处理 num 类型的运算符（当 receiver 是数字类型时）
    if (name == '<' &&
        (receiver.contains('i') ||
            receiver.contains('j') ||
            receiver.contains('index') ||
            receiver.contains('count') ||
            receiver.contains('start') ||
            receiver.contains('end') ||
            receiver.contains('high') ||
            receiver.contains('low'))) {
      return '$receiver < ($allArgs)';
    }
    if (name == '>' &&
        (receiver.contains('i') ||
            receiver.contains('j') ||
            receiver.contains('index') ||
            receiver.contains('count') ||
            receiver.contains('start') ||
            receiver.contains('end') ||
            receiver.contains('high') ||
            receiver.contains('low'))) {
      return '$receiver > ($allArgs)';
    }
    if (name == '<=' &&
        (receiver.contains('i') ||
            receiver.contains('j') ||
            receiver.contains('index') ||
            receiver.contains('count') ||
            receiver.contains('start') ||
            receiver.contains('end') ||
            receiver.contains('high') ||
            receiver.contains('low'))) {
      return '$receiver <= ($allArgs)';
    }
    if (name == '>=' &&
        (receiver.contains('i') ||
            receiver.contains('j') ||
            receiver.contains('index') ||
            receiver.contains('count') ||
            receiver.contains('start') ||
            receiver.contains('end') ||
            receiver.contains('high') ||
            receiver.contains('low'))) {
      return '$receiver >= ($allArgs)';
    }
    if (name == '+' &&
        (receiver.contains('i') ||
            receiver.contains('j') ||
            receiver.contains('index') ||
            receiver.contains('count') ||
            receiver.contains('start') ||
            receiver.contains('end') ||
            receiver.contains('high') ||
            receiver.contains('low'))) {
      return '$receiver + ($allArgs)';
    }
    if (name == '-' &&
        (receiver.contains('i') ||
            receiver.contains('j') ||
            receiver.contains('index') ||
            receiver.contains('count') ||
            receiver.contains('start') ||
            receiver.contains('end') ||
            receiver.contains('high') ||
            receiver.contains('low'))) {
      return '$receiver - ($allArgs)';
    }

    // 处理包含类型信息的运算符名称
    if (name.contains('{num.<}')) return '$receiver < ($allArgs)';
    if (name.contains('{num.>}')) return '$receiver > ($allArgs)';
    if (name.contains('{num.<=}')) return '$receiver <= ($allArgs)';
    if (name.contains('{num.>=}')) return '$receiver >= ($allArgs)';
    if (name.contains('{num.+}')) return '$receiver + ($allArgs)';
    if (name.contains('{num.-}')) return '$receiver - ($allArgs)';
    if (name.contains('{num.*}')) return '$receiver * ($allArgs)';
    if (name.contains('{num./}')) return '$receiver / ($allArgs)';
    if (name.contains('{num.%}')) return '$receiver % ($allArgs)';
    if (name.contains('{num.==}')) return '$receiver == ($allArgs)';
    if (name.contains('{num.!=}')) return '$receiver != ($allArgs)';
    if (name.contains('{num.+=}')) return '$receiver += ($allArgs)';
    if (name.contains('{num.-=}')) return '$receiver -= ($allArgs)';
    if (name.contains('{num.++}')) return '$receiver++';
    if (name.contains('{num.--}')) return '$receiver--';

    // 处理其他类型的方法调用
    if (name.contains('{Iterator.moveNext}')) return '$receiver.moveNext()';
    if (name.contains('{Iterator.current}')) return '$receiver.current';
    if (name.contains('{CppList._array}')) return '$receiver._array';
    if (name.contains('{CppList.length}')) return '$receiver.length';
    if (name.contains('{CppSet._list}')) return '$receiver._list';
    if (name.contains('{CppMap._list}')) return '$receiver._list';
    if (name.contains('{CppSkipIterator._count}')) return '$receiver._count';

    // 处理标准运算符
    if (name == '<') return '$receiver < ($allArgs)';
    if (name == '>') return '$receiver > ($allArgs)';
    if (name == '<=') return '$receiver <= ($allArgs)';
    if (name == '>=') return '$receiver >= ($allArgs)';
    if (name == '+') return '$receiver + ($allArgs)';
    if (name == '-') return '$receiver - ($allArgs)';
    if (name == '*') return '$receiver * ($allArgs)';
    if (name == '/') return '$receiver / ($allArgs)';
    if (name == '%') return '$receiver % ($allArgs)';
    if (name == '==') return '$receiver == ($allArgs)';
    if (name == '!=') return '$receiver != ($allArgs)';
    if (name == '[]') return '$receiver[$allArgs]';
    if (name == '[]=') {
      if (argsList.length >= 2) {
        final index = _generateExpressionCode(argsList[0],
            replaceThis: replaceThis, asStatement: false);
        final value = _generateExpressionCode(argsList[1],
            replaceThis: replaceThis, asStatement: false);
        return '$receiver[$index] = $value';
      }
      return '$receiver[$allArgs] = $allArgs';
    }

    // 处理特殊运算符
    if (name == '.<' || name == '<') return '$receiver < ($allArgs)';
    if (name == '.>' || name == '>') return '$receiver > ($allArgs)';
    if (name == '.+' || name == '+') return '$receiver + ($allArgs)';
    if (name == '.-' || name == '-') return '$receiver - ($allArgs)';
    if (name == '.++' || name == '++') return '$receiver++';
    if (name == '.--' || name == '--') return '$receiver--';
    if (name == '.+=' || name == '+=') return '$receiver += ($allArgs)';
    if (name == '.-=' || name == '-=') return '$receiver -= ($allArgs)';
    if (name == '.[]' || name == '[]') return '$receiver[$allArgs]';
    if (name == '.[]=' || name == '[]=') {
      if (argsList.length >= 2) {
        final index = _generateExpressionCode(argsList[0],
            replaceThis: replaceThis, asStatement: false);
        final value = _generateExpressionCode(argsList[1],
            replaceThis: replaceThis, asStatement: false);
        return '$receiver[$index] = $value';
      }
      return '$receiver[$allArgs] = $allArgs';
    }

    if (name.startsWith('.') && name.length > 1) {
      final op = name.substring(1);
      return '$receiver $op ($allArgs)';
    }
    return '$receiver.$name($allArgs)';
  } else if (expression is EqualsNull) {
    return '${_generateExpressionCode(expression.expression, replaceThis: replaceThis, asStatement: false)} == null';
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
    // 生成正确的函数表达式语法
    final parameters = expression.function.positionalParameters
        .map((p) =>
            '${_getDartType(p.type)} ${_cleanVariableName(p.name ?? 'param')}')
        .join(', ');
    final body = expression.function.body != null
        ? _generateStatementCode(expression.function.body!,
            replaceThis: replaceThis)
        : '{}';
    return '($parameters) => $body';
  } else if (expression is BlockExpression) {
    // 生成正确的块表达式语法
    final statements = expression.body.statements
        .map((s) => _generateStatementCode(s, replaceThis: replaceThis))
        .join('\n');
    final value = _generateExpressionCode(expression.value,
        replaceThis: replaceThis, asStatement: false);

    // 表达式上下文，用 IIFE 包裹
    return '(() {\n$statements\nreturn $value;\n})()';
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
    final typeArgs = expression.typeArguments.isNotEmpty
        ? '<${expression.typeArguments.map(_getDartType).join(', ')}>'
        : '';
    final fields = expression.fieldValues.entries
        .map((e) =>
            '${e.key.asField.name}: ${_generateExpressionCode(e.value, replaceThis: replaceThis, asStatement: false)}')
        .join(', ');
    return '$className$typeArgs{$fields}';
  } else if (expression is Not) {
    return '!${_generateExpressionCode(expression.operand, replaceThis: replaceThis, asStatement: false)}';
  } else if (expression is LogicalExpression) {
    final left = _generateExpressionCode(expression.left,
        replaceThis: replaceThis, asStatement: false);
    final op = _getLogicalOperator(expression.operatorEnum);
    final right = _generateExpressionCode(expression.right,
        replaceThis: replaceThis, asStatement: false);
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
    return expression.expressions
        .map((e) => _generateExpressionCode(e,
            replaceThis: replaceThis, asStatement: false))
        .join(' + ');
  } else if (expression is DynamicSet) {
    final receiver = _generateExpressionCode(expression.receiver,
        replaceThis: replaceThis, asStatement: false);
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
  } else if (expression is InstanceSet) {
    final receiver = _generateExpressionCode(expression.receiver,
        replaceThis: replaceThis, asStatement: false);
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
    return 'super.$name($args)';
  } else if (expression is SuperPropertyGet) {
    final name = expression.name.text;
    return 'super.$name';
  } else if (expression is SuperPropertySet) {
    final name = expression.name.text;
    final value = _generateExpressionCode(expression.value,
        replaceThis: replaceThis, asStatement: false);
    return 'super.$name = $value';
  } else if (expression is AsExpression) {
    final operand = _generateExpressionCode(expression.operand,
        replaceThis: replaceThis, asStatement: false);
    final type = _getDartType(expression.type);
    return '$operand as $type';
  } else if (expression is IsExpression) {
    final operand = _generateExpressionCode(expression.operand,
        replaceThis: replaceThis, asStatement: false);
    final type = _getDartType(expression.type);
    return '$operand is $type';
  } else if (expression is Let) {
    final variable = _cleanVariableName(expression.variable.name ?? 'temp');
    final value = _generateExpressionCode(expression.variable.initializer!,
        replaceThis: replaceThis);
    final body = _generateExpressionCode(expression.body,
        replaceThis: replaceThis, asStatement: false);
    final type = _getDartType(expression.variable.type);

    // 表达式上下文，用 IIFE 包裹，确保只生成单一表达式
    return '(() { final $type $variable = $value; return $body; })()';
  } else if (expression is BlockExpression) {
    // 生成正确的块表达式语法
    final statements = expression.body.statements
        .map((s) => _generateStatementCode(s, replaceThis: replaceThis))
        .join('\n');
    final value = _generateExpressionCode(expression.value,
        replaceThis: replaceThis, asStatement: false);

    // 表达式上下文，用 IIFE 包裹，确保只生成单一表达式
    return '(() {\n$statements\nreturn $value;\n})()';
  } else if (expression is BinaryExpression) {
    final left = _generateExpressionCode(expression.left,
        replaceThis: replaceThis, asStatement: false);
    final opName = expression.binaryName.text;
    final right = _generateExpressionCode(expression.right,
        replaceThis: replaceThis, asStatement: false);
    // 处理所有特殊运算符
    if (opName == '<' || opName == '.<') return '$left < $right';
    if (opName == '>' || opName == '.>') return '$left > $right';
    if (opName == '+' || opName == '.+') return '$left + $right';
    if (opName == '-' || opName == '.-') return '$left - $right';
    if (opName == '++' || opName == '.++') return '$left++';
    if (opName == '--' || opName == '.--') return '$left--';
    if (opName == '+=' || opName == '.+=') return '$left += $right';
    if (opName == '-=' || opName == '.-=') return '$left -= $right';
    if (opName == '[]' || opName == '.[]') return '$left[$right]';
    if (opName == '[]=' || opName == '.[]=') return '$left[$right] = $right';
    final op = _getBinaryOperator(opName);
    return '$left $op $right';
  } else if (expression is UnaryExpression) {
    final op = _getUnaryOperator(expression.unaryName.text);
    final expr = _generateExpressionCode(expression.expression,
        replaceThis: replaceThis);
    return '$op$expr';
  } else if (expression is ParenthesizedExpression) {
    return '(${_generateExpressionCode(expression.expression, replaceThis: replaceThis, asStatement: false)})';
  } else if (expression is FunctionInvocation) {
    final receiver = _generateExpressionCode(expression.receiver,
        replaceThis: replaceThis, asStatement: false);
    final args = expression.arguments.positional
        .map((e) => _generateExpressionCode(e,
            replaceThis: replaceThis, asStatement: false))
        .join(', ');
    final namedArgs = expression.arguments.named
        .map((na) =>
            '${na.name}: ${_generateExpressionCode(na.value, replaceThis: replaceThis, asStatement: false)}')
        .join(', ');
    final allArgs = [args, namedArgs].where((s) => s.isNotEmpty).join(', ');
    return '$receiver($allArgs)';
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
    return '$name($allArgs)';
  } else if (expression is ConstantExpression) {
    final constant = expression.constant;
    if (constant is StringConstant) {
      return '"${constant.value}"';
    } else if (constant is IntConstant) {
      return constant.value.toString();
    } else if (constant is DoubleConstant) {
      return constant.value.toString();
    } else if (constant is BoolConstant) {
      return constant.value.toString();
    } else if (constant is NullConstant) {
      return 'null';
    } else if (constant is ListConstant) {
      final entries = constant.entries
          .map((e) => _generateExpressionCode(ConstantExpression(e),
              replaceThis: replaceThis))
          .join(', ');
      return '[$entries]';
    } else if (constant is MapConstant) {
      final entries = constant.entries
          .map((e) =>
              '${_generateExpressionCode(ConstantExpression(e.key), replaceThis: replaceThis, asStatement: false)}: ${_generateExpressionCode(ConstantExpression(e.value), replaceThis: replaceThis, asStatement: false)}')
          .join(', ');
      return '{$entries}';
    } else {
      return expression.toString();
    }
  } else if (expression is StaticInvocation) {
    final className = expression.target.enclosingClass?.name ?? 'UnknownClass';
    final methodName = expression.target.name.text;
    final args = expression.arguments.positional
        .map((e) => _generateExpressionCode(e,
            replaceThis: replaceThis, asStatement: false))
        .join(', ');
    final namedArgs = expression.arguments.named
        .map((na) =>
            '${na.name}: ${_generateExpressionCode(na.value, replaceThis: replaceThis, asStatement: false)}')
        .join(', ');
    final allArgs = [args, namedArgs].where((s) => s.isNotEmpty).join(', ');
    return '$className.$methodName($allArgs)';
  } else if (expression is ConstructorInvocation) {
    final name = expression.target.name.text.isEmpty
        ? expression.target.enclosingClass.name
        : '${expression.target.enclosingClass.name}.${expression.target.name.text}';
    final args = expression.arguments.positional
        .map((e) => _generateExpressionCode(e,
            replaceThis: replaceThis, asStatement: false))
        .join(', ');
    final namedArgs = expression.arguments.named
        .map((na) =>
            '${na.name}: ${_generateExpressionCode(na.value, replaceThis: replaceThis, asStatement: false)}')
        .join(', ');
    final allArgs = [args, namedArgs].where((s) => s.isNotEmpty).join(', ');
    return 'new $name($allArgs)';
  } else if (expression is Throw) {
    final throwExpression = _generateExpressionCode(expression.expression,
        replaceThis: replaceThis);
    return 'throw $throwExpression';
  } else if (expression is Rethrow) {
    return 'rethrow';
  } else if (expression is InstanceGetterInvocation) {
    final receiver = _generateExpressionCode(expression.receiver,
        replaceThis: replaceThis, asStatement: false);
    final name = expression.name.text;
    return '$receiver.$name';
  } else if (expression is IntLiteral) {
    return expression.value.toString();
  } else if (expression is DoubleLiteral) {
    return expression.value.toString();
  } else if (expression is BoolLiteral) {
    return expression.value ? 'true' : 'false';
  } else if (expression is NullLiteral) {
    return 'null';
  } else if (expression is StringLiteral) {
    // 使用正确的字符串转义，不使用字符串替换
    final value = expression.value;
    final escaped = value.replaceAll('\\', '\\\\').replaceAll('"', '\\"');
    return '"$escaped"';
  } else {
    return expression.toString();
  }
}

String _generateStatementCode(Statement statement, {bool replaceThis = false}) {
  print('expression: $statement');
  if (statement is ReturnStatement) {
    if (statement.expression != null) {
      final expr = _generateExpressionCode(statement.expression!,
          replaceThis: replaceThis, asStatement: false);
      // 避免重复的 return 关键字
      if (expr.startsWith('return ')) {
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
    // 避免重复的 return/throw 关键字
    if (expr.startsWith('return ') || expr.startsWith('throw ')) {
      return expr;
    } else {
      return '$expr;';
    }
  } else if (statement is Block) {
    final stmts = statement.statements
        .map((s) => _generateStatementCode(s, replaceThis: replaceThis))
        .join('\n  ');
    return '{\n  $stmts\n}';
  } else if (statement is IfStatement) {
    final cond = _generateExpressionCode(statement.condition,
        replaceThis: replaceThis, asStatement: false);
    final then =
        _generateStatementCode(statement.then, replaceThis: replaceThis);
    final otherwise = statement.otherwise != null
        ? ' else ${_generateStatementCode(statement.otherwise!, replaceThis: replaceThis)}'
        : '';
    return 'if ($cond) $then$otherwise';
  } else if (statement is VariableDeclaration) {
    final type = _getDartType(statement.type);
    final name = _cleanVariableName(statement.name ?? 'unnamed');
    final init = statement.initializer != null
        ? ' = ${_generateExpressionCode(statement.initializer!, replaceThis: replaceThis, asStatement: false)}'
        : '';
    return '$type $name$init;';
  } else if (statement is EmptyStatement) {
    return ';';
  } else if (statement is ForStatement) {
    final init = statement.variables.isNotEmpty
        ? statement.variables
            .map((v) =>
                '${_getDartType(v.type)} ${_cleanVariableName(v.name ?? 'var')} = ${_generateExpressionCode(v.initializer!, replaceThis: replaceThis, asStatement: false)}')
            .join(', ')
        : '';
    final condition = statement.condition != null
        ? _generateExpressionCode(statement.condition!,
            replaceThis: replaceThis, asStatement: false)
        : '';
    final updates = statement.updates.isNotEmpty
        ? statement.updates
            .map((e) => _generateExpressionCode(e,
                replaceThis: replaceThis, asStatement: false))
            .join(', ')
        : '';

    final body =
        _generateStatementCode(statement.body, replaceThis: replaceThis);

    // 修复 for 循环语法
    if (init.isEmpty && condition.isEmpty && updates.isEmpty) {
      return 'for (;;) {\n  $body\n}';
    } else if (init.isEmpty && condition.isEmpty) {
      return 'for (;; $updates) {\n  $body\n}';
    } else if (init.isEmpty && updates.isEmpty) {
      return 'for (; $condition;) {\n  $body\n}';
    } else if (condition.isEmpty && updates.isEmpty) {
      return 'for ($init;;) {\n  $body\n}';
    } else if (init.isEmpty) {
      return 'for (; $condition; $updates) {\n  $body\n}';
    } else if (condition.isEmpty) {
      return 'for ($init;; $updates) {\n  $body\n}';
    } else if (updates.isEmpty) {
      return 'for ($init; $condition;) {\n  $body\n}';
    } else {
      return 'for ($init; $condition; $updates) {\n  $body\n}';
    }
  } else if (statement is WhileStatement) {
    final cond = _generateExpressionCode(statement.condition,
        replaceThis: replaceThis, asStatement: false);
    final body =
        _generateStatementCode(statement.body, replaceThis: replaceThis);
    return 'while ($cond) $body';
  } else if (statement is DoStatement) {
    final cond = _generateExpressionCode(statement.condition,
        replaceThis: replaceThis, asStatement: false);
    final body =
        _generateStatementCode(statement.body, replaceThis: replaceThis);
    return 'do $body while ($cond);';
  } else if (statement is SwitchStatement) {
    final expression = _generateExpressionCode(statement.expression,
        replaceThis: replaceThis, asStatement: false);
    final cases = statement.cases
        .map((c) => _generateSwitchCase(c, replaceThis))
        .join('\n');
    return 'switch ($expression) {\n$cases\n}';
  } else if (statement is TryCatch) {
    final body =
        _generateStatementCode(statement.body, replaceThis: replaceThis);
    final catches = statement.catches
        .map((c) => _generateCatchClause(c, replaceThis))
        .join('\n');
    return 'try $body\n$catches';
  } else if (statement is TryFinally) {
    final body =
        _generateStatementCode(statement.body, replaceThis: replaceThis);
    final finalizer =
        _generateStatementCode(statement.finalizer, replaceThis: replaceThis);
    return 'try $body\nfinally $finalizer';
  } else if (statement is BreakStatement) {
    return 'break;';
  } else if (statement is ContinueSwitchStatement) {
    return 'continue;';
  } else if (statement is AssertStatement) {
    final condition = _generateExpressionCode(statement.condition,
        replaceThis: replaceThis, asStatement: false);
    final message = statement.message != null
        ? ': ${_generateExpressionCode(statement.message!, replaceThis: replaceThis, asStatement: false)}'
        : '';
    return 'assert $condition$message;';
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
  final body =
      _generateStatementCode(switchCase.body, replaceThis: replaceThis);
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
  final body =
      _generateStatementCode(catchClause.body, replaceThis: replaceThis);
  return 'catch ($exception$stackTrace) $body';
}

String _generateMethodCode(Member member, {bool replaceThis = false}) {
  if (member is Procedure) {
    final name = member.name.text;
    final returnType = _getDartType(member.function.returnType);
    final parameters = member.function.positionalParameters
        .map((p) =>
            '${_getDartType(p.type)} ${_cleanVariableName(p.name ?? 'param')}')
        .join(', ');

    // 检查是否是操作符方法
    if (name == '[]' ||
        name == '[]=' ||
        name == '+' ||
        name == '-' ||
        name == '*' ||
        name == '/' ||
        name == '==' ||
        name == '!=' ||
        name == '<' ||
        name == '>' ||
        name == '<=' ||
        name == '>=') {
      return '@override\noperator $name($parameters) {\n  ${_generateStatementCode(member.function.body!, replaceThis: replaceThis)}\n}';
    } else {
      return '$returnType $name($parameters) {\n  ${_generateStatementCode(member.function.body!, replaceThis: replaceThis)}\n}';
    }
  }
  return '// ${member.runtimeType}';
}
