import 'dart:io';

import 'package:kernel/kernel.dart';
import 'package:kernel/ast.dart';

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

  /// 主要转换入口
  void transformComponent(Component component) {
    _buffer.clear();

    // 收集所有类信息
    for (final library in component.libraries) {
      for (final cls in library.classes) {
        if (!_shouldSkipClass(cls)) {
          _collectClassInfo(cls);
        }
      }
    }

    // 生成转换后的代码
    _generateTransformedCode(component);

    // 输出到文件
    _writeOutput();
  }

  /// 判断是否应该跳过某个类
  bool _shouldSkipClass(Class cls) {
    // 跳过系统类、内置类等
    final libraryName = cls.enclosingLibrary.toStringInternal();
    return libraryName.startsWith('dart:') ||
        libraryName.startsWith('package:flutter') ||
        cls.name.startsWith('_');
  }

  /// 收集类信息
  void _collectClassInfo(Class cls) {
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
          !procedure.isFactory) {
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
    final classInfo = _classInfoMap[cls]!;

    // 类注释
    _writeLine('/// 转换后的类: ${cls.name}');

    // 类声明
    _write('class ${cls.name}');

    // 继承关系
    String? extendsClause;
    String? implementsClause;
    if (cls.superclass != null && cls.superclass!.name != 'Object') {
      // 修复类型名称中的特殊符号
      String className = cls.superclass!.name;
      if (className.contains('&')) {
        // 将&替换为下划线，保持类型名称的完整性
        className = className.replaceAll('&', '_');
      }
      extendsClause = 'extends $className';
    }
    // 接口实现
    if (cls.implementedTypes.isNotEmpty) {
      final impls =
          cls.implementedTypes.map((t) => t.classNode.name).join(', ');
      implementsClause = (implementsClause == null)
          ? 'implements $impls'
          : '$implementsClause, $impls';
    }
    // 拼接
    if (extendsClause != null) _write(' $extendsClause');
    if (implementsClause != null) _write(' $implementsClause');

    _writeLine(' {');
    _indent();

    // 生成late字段
    _generateLateFields(classInfo);

    // 生成无参构造方法
    _generateDefaultConstructor(cls);

    // 生成静态create方法
    _generateStaticCreateMethods(classInfo);

    // 生成静态成员方法
    _generateStaticMethods(classInfo);

    // 生成运算符重载方法
    _generateOperatorMethods(cls);

    _unindent();
    _writeLine('}');
    _writeLine('');
  }

  /// 生成late字段
  void _generateLateFields(ClassInfo classInfo) {
    for (final field in classInfo.lateFields) {
      _writeLine('late ${_getDartType(field.type)} ${field.name.text};');
    }
    if (classInfo.lateFields.isNotEmpty) {
      _writeLine('');
    }
  }

  /// 生成无参构造方法
  void _generateDefaultConstructor(Class cls) {
    _writeLine('${cls.name}();');
    _writeLine('');
  }

  /// 生成静态create方法
  void _generateStaticCreateMethods(ClassInfo classInfo) {
    for (final constructor in classInfo.constructors) {
      // 为所有构造函数生成create方法，包括没有名称的构造函数
      _generateStaticCreateMethod(classInfo.cls, constructor);
    }
  }

  /// 生成单个静态create方法
  void _generateStaticCreateMethod(Class cls, Constructor constructor) {
    // 如果构造函数没有名称，使用固定名称create
    final constructorName = constructor.name.text;
    final methodName =
        constructorName.isEmpty ? 'create' : 'create_${constructorName}';

    // 方法签名
    _write('static ${cls.name} $methodName(');
    _writeParameters(constructor.function);
    _writeLine(') {');
    _indent();

    // 创建实例
    _writeLine('final instance = ${cls.name}();');

    // 初始化字段
    if (constructor.initializers.isNotEmpty) {
      for (final initializer in constructor.initializers) {
        if (initializer is FieldInitializer) {
          _writeLine(
              'instance.${initializer.field.name.text} = ${_expressionToString(initializer.value)};');
        }
      }
    }

    // 执行构造方法体
    if (constructor.function.body != null) {
      _writeTransformedStatement(constructor.function.body!);
    }

    _writeLine('return instance;');
    _unindent();
    _writeLine('}');
    _writeLine('');
  }

  /// 生成静态成员方法
  void _generateStaticMethods(ClassInfo classInfo) {
    for (final procedure in classInfo.staticMethods) {
      _generateStaticMethod(classInfo.cls, procedure);
    }
  }

  /// 生成单个静态方法
  void _generateStaticMethod(Class cls, Procedure procedure) {
    final function = procedure.function;
    final methodName = procedure.name.text;

    // 处理运算符重载方法 - 改为普通方法
    String convertedMethodName = methodName;

    if (methodName == '[]') {
      convertedMethodName = 'getElement';
    } else if (methodName == '[]=') {
      convertedMethodName = 'setElement';
    } else if (methodName == '+') {
      convertedMethodName = 'add';
    } else if (methodName == '-') {
      convertedMethodName = 'subtract';
    } else if (methodName == '*') {
      convertedMethodName = 'multiply';
    } else if (methodName == '/') {
      convertedMethodName = 'divide';
    } else if (methodName == '%') {
      convertedMethodName = 'modulo';
    } else if (methodName == '==') {
      convertedMethodName = 'equals';
    } else if (methodName == '!=') {
      convertedMethodName = 'notEquals';
    } else if (methodName == '<') {
      convertedMethodName = 'lessThan';
    } else if (methodName == '>') {
      convertedMethodName = 'greaterThan';
    } else if (methodName == '<=') {
      convertedMethodName = 'lessThanOrEqual';
    } else if (methodName == '>=') {
      convertedMethodName = 'greaterThanOrEqual';
    } else if (methodName == '&') {
      convertedMethodName = 'bitwiseAnd';
    } else if (methodName == '|') {
      convertedMethodName = 'bitwiseOr';
    } else if (methodName == '^') {
      convertedMethodName = 'bitwiseXor';
    } else if (methodName == '<<') {
      convertedMethodName = 'leftShift';
    } else if (methodName == '>>') {
      convertedMethodName = 'rightShift';
    } else if (methodName == '>>>') {
      convertedMethodName = 'unsignedRightShift';
    } else if (methodName == '~') {
      convertedMethodName = 'bitwiseNot';
    } else if (methodName == 'unary-') {
      convertedMethodName = 'negate';
    } else if (methodName == 'unary+') {
      convertedMethodName = 'positive';
    } else if (methodName == '!') {
      convertedMethodName = 'logicalNot';
    } else if (methodName == '++') {
      convertedMethodName = 'increment';
    } else if (methodName == '--') {
      convertedMethodName = 'decrement';
    } else if (methodName == '+=') {
      convertedMethodName = 'addAssign';
    } else if (methodName == '-=') {
      convertedMethodName = 'subtractAssign';
    } else if (methodName == '*=') {
      convertedMethodName = 'multiplyAssign';
    } else if (methodName == '/=') {
      convertedMethodName = 'divideAssign';
    } else if (methodName == '%=') {
      convertedMethodName = 'moduloAssign';
    } else if (methodName == '&=') {
      convertedMethodName = 'bitwiseAndAssign';
    } else if (methodName == '|=') {
      convertedMethodName = 'bitwiseOrAssign';
    } else if (methodName == '^=') {
      convertedMethodName = 'bitwiseXorAssign';
    } else if (methodName == '<<=') {
      convertedMethodName = 'leftShiftAssign';
    } else if (methodName == '>>=') {
      convertedMethodName = 'rightShiftAssign';
    } else if (methodName == '>>>=') {
      convertedMethodName = 'unsignedRightShiftAssign';
    } else if (methodName == '??') {
      convertedMethodName = 'nullCoalesce';
    } else if (methodName == '&&') {
      convertedMethodName = 'logicalAnd';
    } else if (methodName == '||') {
      convertedMethodName = 'logicalOr';
    }

    // 方法签名
    _write('static ${_getDartType(function.returnType)} $convertedMethodName(');
    _write('${cls.name} self');

    // 添加其他参数
    for (final param in function.positionalParameters) {
      _write(
          ', ${_getDartType(param.type)} ${_cleanVariableName(param.name ?? 'param')}');
    }

    for (final param in function.namedParameters) {
      _write(
          ', ${_getDartType(param.type)} ${_cleanVariableName(param.name ?? 'param')}');
    }

    _writeLine(') {');
    _indent();

    // 转换方法体，将this替换为self
    if (function.body != null) {
      _writeTransformedStatement(function.body!);
    } else {
      _writeLine('// TODO: 实现方法体');
    }

    _unindent();
    _writeLine('}');
    _writeLine('');
  }

  /// 生成运算符重载方法
  void _generateOperatorMethods(Class cls) {
    for (final procedure in cls.procedures) {
      if (!procedure.isStatic &&
          !procedure.isAbstract &&
          !procedure.isFactory) {
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

        if (isOperator) {
          _generateOperatorMethod(cls, procedure);
        }
      }
    }
  }

  /// 生成单个运算符重载方法
  void _generateOperatorMethod(Class cls, Procedure procedure) {
    final function = procedure.function;
    final methodName = procedure.name.text;

    // 处理运算符重载方法 - 改为普通方法
    String convertedMethodName = methodName;

    if (methodName == '[]') {
      convertedMethodName = 'getElement';
    } else if (methodName == '[]=') {
      convertedMethodName = 'setElement';
    } else if (methodName == '+') {
      convertedMethodName = 'add';
    } else if (methodName == '-') {
      convertedMethodName = 'subtract';
    } else if (methodName == '*') {
      convertedMethodName = 'multiply';
    } else if (methodName == '/') {
      convertedMethodName = 'divide';
    } else if (methodName == '%') {
      convertedMethodName = 'modulo';
    } else if (methodName == '==') {
      convertedMethodName = 'equals';
    } else if (methodName == '!=') {
      convertedMethodName = 'notEquals';
    } else if (methodName == '<') {
      convertedMethodName = 'lessThan';
    } else if (methodName == '>') {
      convertedMethodName = 'greaterThan';
    } else if (methodName == '<=') {
      convertedMethodName = 'lessThanOrEqual';
    } else if (methodName == '>=') {
      convertedMethodName = 'greaterThanOrEqual';
    } else if (methodName == '&') {
      convertedMethodName = 'bitwiseAnd';
    } else if (methodName == '|') {
      convertedMethodName = 'bitwiseOr';
    } else if (methodName == '^') {
      convertedMethodName = 'bitwiseXor';
    } else if (methodName == '<<') {
      convertedMethodName = 'leftShift';
    } else if (methodName == '>>') {
      convertedMethodName = 'rightShift';
    } else if (methodName == '>>>') {
      convertedMethodName = 'unsignedRightShift';
    } else if (methodName == '~') {
      convertedMethodName = 'bitwiseNot';
    } else if (methodName == 'unary-') {
      convertedMethodName = 'negate';
    } else if (methodName == 'unary+') {
      convertedMethodName = 'positive';
    } else if (methodName == '!') {
      convertedMethodName = 'logicalNot';
    } else if (methodName == '++') {
      convertedMethodName = 'increment';
    } else if (methodName == '--') {
      convertedMethodName = 'decrement';
    } else if (methodName == '+=') {
      convertedMethodName = 'addAssign';
    } else if (methodName == '-=') {
      convertedMethodName = 'subtractAssign';
    } else if (methodName == '*=') {
      convertedMethodName = 'multiplyAssign';
    } else if (methodName == '/=') {
      convertedMethodName = 'divideAssign';
    } else if (methodName == '%=') {
      convertedMethodName = 'moduloAssign';
    } else if (methodName == '&=') {
      convertedMethodName = 'bitwiseAndAssign';
    } else if (methodName == '|=') {
      convertedMethodName = 'bitwiseOrAssign';
    } else if (methodName == '^=') {
      convertedMethodName = 'bitwiseXorAssign';
    } else if (methodName == '<<=') {
      convertedMethodName = 'leftShiftAssign';
    } else if (methodName == '>>=') {
      convertedMethodName = 'rightShiftAssign';
    } else if (methodName == '>>>=') {
      convertedMethodName = 'unsignedRightShiftAssign';
    } else if (methodName == '??') {
      convertedMethodName = 'nullCoalesce';
    } else if (methodName == '&&') {
      convertedMethodName = 'logicalAnd';
    } else if (methodName == '||') {
      convertedMethodName = 'logicalOr';
    }

    // 方法签名 - 生成静态方法
    _write('static ${_getDartType(function.returnType)} $convertedMethodName(');
    _write('${cls.name} self');

    // 添加参数
    bool first = false;
    for (final param in function.positionalParameters) {
      if (!first) _write(', ');
      _write(
          '${_getDartType(param.type)} ${_cleanVariableName(param.name ?? 'param')}');
      first = true;
    }

    for (final param in function.namedParameters) {
      if (!first) _write(', ');
      _write(
          '${_getDartType(param.type)} ${_cleanVariableName(param.name ?? 'param')}');
      first = true;
    }

    _writeLine(') {');
    _indent();

    // 转换方法体，将this替换为self
    if (function.body != null) {
      _writeTransformedStatement(function.body!);
    } else {
      _writeLine('// TODO: 实现方法体');
    }

    _unindent();
    _writeLine('}');
    _writeLine('');
  }

  /// 写入参数列表
  void _writeParameters(FunctionNode function) {
    bool first = true;

    for (final param in function.positionalParameters) {
      if (!first) _write(', ');
      _write(
          '${_getDartType(param.type)} ${_cleanVariableName(param.name ?? 'param')}');
      first = false;
    }

    for (final param in function.namedParameters) {
      if (!first) _write(', ');
      _write(
          '${_getDartType(param.type)} ${_cleanVariableName(param.name ?? 'param')}');
      first = false;
    }
  }

  /// 获取Dart类型字符串
  String _getDartType(DartType type) {
    if (type is InterfaceType) {
      return type.classNode.name;
    } else if (type is DynamicType) {
      return 'dynamic';
    } else if (type is VoidType) {
      // 将void类型转换为dynamic，以支持返回Void
      return 'dynamic';
    } else if (type is NullType) {
      return 'Null';
    } else if (type is NeverType) {
      return 'Never';
    } else if (type is FunctionType) {
      return 'Function';
    }
    return 'dynamic';
  }

  /// 清理变量名，将不合法的变量名转换为合法的Dart变量名
  String _cleanVariableName(String name) {
    if (name.isEmpty) return 'unnamed';

    // 处理包含特殊字符的变量名
    if (name.contains('#')) {
      // 提取数字部分作为后缀
      final match = RegExp(r'_#wc(\d+)#formal').firstMatch(name);
      if (match != null) {
        final number = match.group(1);
        return 'formal_$number';
      }

      // 其他包含#的变量名
      return name
          .replaceAll('#', '_')
          .replaceAll(RegExp(r'[^a-zA-Z0-9_]'), '_');
    }

    // 处理以数字开头的变量名
    if (RegExp(r'^\d').hasMatch(name)) {
      return 'var_$name';
    }

    // 处理包含其他特殊字符的变量名
    if (RegExp(r'[^a-zA-Z0-9_]').hasMatch(name)) {
      return name.replaceAll(RegExp(r'[^a-zA-Z0-9_]'), '_');
    }

    return name;
  }

  /// 转换语句，将this替换为self
  void _writeTransformedStatement(Statement statement) {
    if (statement is Block) {
      _writeLine('{');
      _indent();
      for (final stmt in statement.statements) {
        _writeTransformedStatement(stmt);
      }
      _unindent();
      _writeLine('}');
    } else if (statement is ExpressionStatement) {
      _writeLine('${_expressionToString(statement.expression)};');
    } else if (statement is ReturnStatement) {
      if (statement.expression != null) {
        _writeLine('return ${_expressionToString(statement.expression!)};');
      } else {
        // 当没有表达式时，返回Void而不是空返回
        _writeLine('return Void;');
      }
    } else if (statement is VariableDeclaration) {
      _writeLine(
          '${_getDartType(statement.type)} ${_cleanVariableName(statement.name ?? 'var')}${statement.initializer != null ? ' = ${_expressionToString(statement.initializer!)}' : ''};');
    } else if (statement is IfStatement) {
      _write('if (${_expressionToString(statement.condition)}) ');
      _writeTransformedStatement(statement.then);
      if (statement.otherwise != null) {
        _write(' else ');
        _writeTransformedStatement(statement.otherwise!);
      }
    } else if (statement is ForStatement) {
      _write('for (');
      if (statement.variables.isNotEmpty) {
        final vars = statement.variables
            .map((v) =>
                '${_getDartType(v.type)} ${_cleanVariableName(v.name ?? 'var')}${v.initializer != null ? ' = ${_expressionToString(v.initializer!)}' : ''}')
            .join(', ');
        _write(vars);
      }
      _write('; ');
      if (statement.condition != null) {
        _write(_expressionToString(statement.condition!));
      }
      _write('; ');
      if (statement.updates.isNotEmpty) {
        final updates =
            statement.updates.map((u) => _expressionToString(u)).join(', ');
        _write(updates);
      }
      _write(') ');
      _writeTransformedStatement(statement.body);
    } else if (statement is ForInStatement) {
      // 标准Dart for-in语法
      _write(
          'for (final ${_cleanVariableName(statement.variable.name ?? 'item')} in ${_expressionToString(statement.iterable)}) ');
      _writeTransformedStatement(statement.body);
    } else if (statement is WhileStatement) {
      _write('while (${_expressionToString(statement.condition)}) ');
      _writeTransformedStatement(statement.body);
    } else if (statement is DoStatement) {
      _write('do ');
      _writeTransformedStatement(statement.body);
      _write(' while (${_expressionToString(statement.condition)});');
    } else if (statement is SwitchStatement) {
      _write('switch (${_expressionToString(statement.expression)}) {');
      _writeLine('// TODO: 实现switch语句');
      _writeLine('}');
    } else if (statement is TryCatch) {
      _write('try ');
      _writeTransformedStatement(statement.body);
      _writeLine('// TODO: 实现try-catch语句');
    } else if (statement is AssertStatement) {
      _write('assert(${_expressionToString(statement.condition)}');
      if (statement.message != null) {
        _write(', ${_expressionToString(statement.message!)}');
      }
      _writeLine(');');
    } else if (statement is LabeledStatement) {
      _writeLine('// TODO: 实现标签语句');
      _writeTransformedStatement(statement.body);
    } else if (statement is BreakStatement) {
      _writeLine('break;');
    } else if (statement is ContinueSwitchStatement) {
      _writeLine('continue;');
    } else if (statement is EmptyStatement) {
      _writeLine(';');
    } else {
      _writeLine('// TODO: 处理语句类型 ${statement.runtimeType}');
    }
  }

  /// 转换语句，用于运算符重载方法（保持this引用）
  void _writeTransformedStatementForOperator(Statement statement) {
    if (statement is Block) {
      _writeLine('{');
      _indent();
      for (final stmt in statement.statements) {
        _writeTransformedStatementForOperator(stmt);
      }
      _unindent();
      _writeLine('}');
    } else if (statement is ExpressionStatement) {
      _writeLine('${_expressionToStringForOperator(statement.expression)};');
    } else if (statement is ReturnStatement) {
      if (statement.expression != null) {
        _writeLine(
            'return ${_expressionToStringForOperator(statement.expression!)};');
      } else {
        // 当没有表达式时，返回Void而不是空返回
        _writeLine('return Void;');
      }
    } else if (statement is VariableDeclaration) {
      _writeLine(
          '${_getDartType(statement.type)} ${_cleanVariableName(statement.name ?? 'var')}${statement.initializer != null ? ' = ${_expressionToStringForOperator(statement.initializer!)}' : ''};');
    } else if (statement is IfStatement) {
      _write('if (${_expressionToStringForOperator(statement.condition)}) ');
      _writeTransformedStatementForOperator(statement.then);
      if (statement.otherwise != null) {
        _write(' else ');
        _writeTransformedStatementForOperator(statement.otherwise!);
      }
    } else {
      _writeLine('// TODO: 处理语句类型 ${statement.runtimeType}');
    }
  }

  /// 将语句转换为字符串
  String _writeTransformedStatementToString(Statement statement) {
    if (statement is Block) {
      final statements = statement.statements
          .map((s) => _writeTransformedStatementToString(s))
          .join('\n    ');
      return '{\n    $statements\n  }';
    } else if (statement is ExpressionStatement) {
      return '${_expressionToString(statement.expression)};';
    } else if (statement is ReturnStatement) {
      if (statement.expression != null) {
        return 'return ${_expressionToString(statement.expression!)};';
      } else {
        // 当没有表达式时，返回Void而不是空返回
        return 'return Void;';
      }
    } else if (statement is VariableDeclaration) {
      return '${_getDartType(statement.type)} ${_cleanVariableName(statement.name ?? 'var')}${statement.initializer != null ? ' = ${_expressionToString(statement.initializer!)}' : ''};';
    } else if (statement is IfStatement) {
      final condition = _expressionToString(statement.condition);
      final then = _writeTransformedStatementToString(statement.then);
      final otherwise = statement.otherwise != null
          ? ' else ${_writeTransformedStatementToString(statement.otherwise!)}'
          : '';
      return 'if ($condition) $then$otherwise';
    } else {
      return '// TODO: 处理语句类型 ${statement.runtimeType}';
    }
  }

  /// 转换表达式，将this替换为self
  String _expressionToString(Expression expression) {
    if (expression is ThisExpression) {
      return 'self';
    } else if (expression is VariableGet) {
      final originalName = expression.variable.name ?? 'unknown';
      return _cleanVariableName(originalName);
    } else if (expression is VariableSet) {
      final originalName = expression.variable.name ?? 'unknown';
      final cleanName = _cleanVariableName(originalName);
      return '$cleanName = ${_expressionToString(expression.value)}';
    } else if (expression is InstanceGet) {
      return 'self.${expression.name.text}';
    } else if (expression is InstanceSet) {
      return 'self.${expression.name.text} = ${_expressionToString(expression.value)}';
    } else if (expression is InstanceInvocation) {
      final args = expression.arguments.positional
          .map((e) => _expressionToString(e))
          .join(', ');

      // 处理运算符调用 - 转换为方法调用
      final methodName = expression.interfaceTarget.name.text;

      // 特殊处理 moveNext(self, ) 转换为静态方法调用
      if (methodName == 'moveNext' && args.isEmpty) {
        return 'moveNext(self)';
      }

      if (methodName == '[]') {
        return 'getElement(self, ${args})';
      } else if (methodName == '[]=') {
        final parts = args.split(', ');
        if (parts.length >= 2) {
          final index = parts[0];
          final value = parts.sublist(1).join(', ');
          return 'setElement(self, $index, $value)';
        }
        return 'setElement(self, ${args})';
      } else if (methodName == '+' ||
          methodName == '-' ||
          methodName == '*' ||
          methodName == '/') {
        final parts = args.split(', ');
        if (parts.length == 1) {
          String methodNameConverted = methodName;
          if (methodName == '+')
            methodNameConverted = 'add';
          else if (methodName == '-')
            methodNameConverted = 'subtract';
          else if (methodName == '*')
            methodNameConverted = 'multiply';
          else if (methodName == '/') methodNameConverted = 'divide';
          return '$methodNameConverted(self, ${parts[0]})';
        }
        return '$methodName(self, ${args})';
      } else if (methodName == '>' ||
          methodName == '<' ||
          methodName == '>=' ||
          methodName == '<=' ||
          methodName == '==' ||
          methodName == '!=') {
        final parts = args.split(', ');
        if (parts.length == 2) {
          String methodNameConverted = methodName;
          if (methodName == '>')
            methodNameConverted = 'greaterThan';
          else if (methodName == '<')
            methodNameConverted = 'lessThan';
          else if (methodName == '>=')
            methodNameConverted = 'greaterThanOrEqual';
          else if (methodName == '<=')
            methodNameConverted = 'lessThanOrEqual';
          else if (methodName == '==')
            methodNameConverted = 'equals';
          else if (methodName == '!=') methodNameConverted = 'notEquals';
          return '$methodNameConverted(self, ${parts[0]}, ${parts[1]})';
        } else if (parts.length == 1) {
          // 处理只有一个参数的情况
          String methodNameConverted = methodName;
          if (methodName == '>')
            methodNameConverted = 'greaterThan';
          else if (methodName == '<')
            methodNameConverted = 'lessThan';
          else if (methodName == '>=')
            methodNameConverted = 'greaterThanOrEqual';
          else if (methodName == '<=')
            methodNameConverted = 'lessThanOrEqual';
          else if (methodName == '==')
            methodNameConverted = 'equals';
          else if (methodName == '!=') methodNameConverted = 'notEquals';
          return '$methodNameConverted(self, ${parts[0]})';
        }
        return '$methodName(self, ${args})';
      } else if (methodName == '%' ||
          methodName == '&' ||
          methodName == '|' ||
          methodName == '^' ||
          methodName == '<<' ||
          methodName == '>>' ||
          methodName == '>>>') {
        final parts = args.split(', ');
        if (parts.length == 2) {
          String methodNameConverted = methodName;
          if (methodName == '%')
            methodNameConverted = 'modulo';
          else if (methodName == '&')
            methodNameConverted = 'bitwiseAnd';
          else if (methodName == '|')
            methodNameConverted = 'bitwiseOr';
          else if (methodName == '^')
            methodNameConverted = 'bitwiseXor';
          else if (methodName == '<<')
            methodNameConverted = 'leftShift';
          else if (methodName == '>>')
            methodNameConverted = 'rightShift';
          else if (methodName == '>>>')
            methodNameConverted = 'unsignedRightShift';
          return '$methodNameConverted(self, ${parts[0]}, ${parts[1]})';
        } else if (parts.length == 1) {
          // 处理只有一个参数的情况
          String methodNameConverted = methodName;
          if (methodName == '%')
            methodNameConverted = 'modulo';
          else if (methodName == '&')
            methodNameConverted = 'bitwiseAnd';
          else if (methodName == '|')
            methodNameConverted = 'bitwiseOr';
          else if (methodName == '^')
            methodNameConverted = 'bitwiseXor';
          else if (methodName == '<<')
            methodNameConverted = 'leftShift';
          else if (methodName == '>>')
            methodNameConverted = 'rightShift';
          else if (methodName == '>>>')
            methodNameConverted = 'unsignedRightShift';
          return '$methodNameConverted(self, ${parts[0]})';
        }
        return '$methodName(self, ${args})';
      } else if (methodName == '~' ||
          methodName == 'unary-' ||
          methodName == 'unary+' ||
          methodName == '!') {
        String methodNameConverted = methodName;
        if (methodName == '~')
          methodNameConverted = 'bitwiseNot';
        else if (methodName == 'unary-')
          methodNameConverted = 'negate';
        else if (methodName == 'unary+')
          methodNameConverted = 'positive';
        else if (methodName == '!') methodNameConverted = 'logicalNot';
        return '$methodNameConverted(self)';
      } else if (methodName == '++' || methodName == '--') {
        String methodNameConverted = methodName;
        if (methodName == '++')
          methodNameConverted = 'increment';
        else if (methodName == '--') methodNameConverted = 'decrement';
        return '$methodNameConverted(self)';
      } else if (methodName == '+=' ||
          methodName == '-=' ||
          methodName == '*=' ||
          methodName == '/=' ||
          methodName == '%=' ||
          methodName == '&=' ||
          methodName == '|=' ||
          methodName == '^=' ||
          methodName == '<<=' ||
          methodName == '>>=' ||
          methodName == '>>>=') {
        final parts = args.split(', ');
        if (parts.length == 1) {
          String methodNameConverted = methodName;
          if (methodName == '+=')
            methodNameConverted = 'addAssign';
          else if (methodName == '-=')
            methodNameConverted = 'subtractAssign';
          else if (methodName == '*=')
            methodNameConverted = 'multiplyAssign';
          else if (methodName == '/=')
            methodNameConverted = 'divideAssign';
          else if (methodName == '%=')
            methodNameConverted = 'moduloAssign';
          else if (methodName == '&=')
            methodNameConverted = 'bitwiseAndAssign';
          else if (methodName == '|=')
            methodNameConverted = 'bitwiseOrAssign';
          else if (methodName == '^=')
            methodNameConverted = 'bitwiseXorAssign';
          else if (methodName == '<<=')
            methodNameConverted = 'leftShiftAssign';
          else if (methodName == '>>=')
            methodNameConverted = 'rightShiftAssign';
          else if (methodName == '>>>=')
            methodNameConverted = 'unsignedRightShiftAssign';
          return '$methodNameConverted(self, ${parts[0]})';
        }
        return '$methodName(self, ${args})';
      } else if (methodName == '??' ||
          methodName == '&&' ||
          methodName == '||') {
        final parts = args.split(', ');
        if (parts.length == 2) {
          String methodNameConverted = methodName;
          if (methodName == '??')
            methodNameConverted = 'nullCoalesce';
          else if (methodName == '&&')
            methodNameConverted = 'logicalAnd';
          else if (methodName == '||') methodNameConverted = 'logicalOr';
          return '$methodNameConverted(self, ${parts[0]}, ${parts[1]})';
        }
        return '$methodName(self, ${args})';
      } else {
        // 对于其他方法调用，直接转换为静态方法调用
        return '$methodName(self, ${args})';
      }
    } else if (expression is IntLiteral) {
      return expression.value.toString();
    } else if (expression is DoubleLiteral) {
      return expression.value.toString();
    } else if (expression is StringLiteral) {
      return '"${expression.value}"';
    } else if (expression is BoolLiteral) {
      return expression.value.toString();
    } else if (expression is NullLiteral) {
      return 'null';
    } else if (expression is ConstructorInvocation) {
      final args = expression.arguments.positional
          .map((e) => _expressionToString(e))
          .join(', ');

      // 检查构造函数名称
      final constructorName = expression.target.name.text;
      final className = expression.target.enclosingClass.name;

      // 特殊处理内置类型
      //if (className == '_GrowableList') {
      //   if (constructorName.isEmpty) {
      //     // 对于_GrowableList的无名称构造函数，使用List构造函数
      //     return 'List($args)';
      //   } else {
      //     // 对于_GrowableList的有名称构造函数，使用_literal方法
      //     return '_GrowableList._literal$constructorName($args)';
      //   }
      // } else

      if (constructorName.isEmpty) {
        // 无名称构造函数，使用create方法
        return '${className}.create($args)';
      } else {
        // 有名称构造函数，使用create_ConstructorName方法
        return '${className}.create_${constructorName}($args)';
      }
    } else if (expression is StaticInvocation) {
      final args = expression.arguments.positional
          .map((e) => _expressionToString(e))
          .join(', ');
      final className = expression.target.enclosingClass?.name;
      if (className != null && className.isNotEmpty) {
        return '$className.${expression.target.name.text}($args)';
      } else {
        // 对于没有类名的静态调用，直接使用方法名
        return '${expression.target.name.text}($args)';
      }
    } else if (expression is LogicalExpression) {
      final left = _expressionToString(expression.left);
      final right = _expressionToString(expression.right);
      final op = _getLogicalOperator(expression.operatorEnum);
      return '$left $op $right';
    } else if (expression is StaticGet) {
      return 'self.${expression.target.name.text}';
    } else if (expression is StaticSet) {
      return 'self.${expression.target.name.text} = ${_expressionToString(expression.value)}';
    } else if (expression is DynamicInvocation) {
      final args = expression.arguments.positional
          .map((e) => _expressionToString(e))
          .join(', ');

      // 处理运算符调用 - 转换为方法调用
      final methodName = expression.name.text;

      // 特殊处理 moveNext(self, ) 转换为静态方法调用
      if (methodName == 'moveNext' && args.isEmpty) {
        return 'moveNext(self)';
      }

      if (methodName == '[]') {
        return 'getElement(self, ${args})';
      } else if (methodName == '[]=') {
        final parts = args.split(', ');
        if (parts.length >= 2) {
          final index = parts[0];
          final value = parts.sublist(1).join(', ');
          return 'setElement(self, $index, $value)';
        }
        return 'setElement(self, ${args})';
      } else if (methodName == '+' ||
          methodName == '-' ||
          methodName == '*' ||
          methodName == '/') {
        final parts = args.split(', ');
        if (parts.length == 1) {
          String methodNameConverted = methodName;
          if (methodName == '+')
            methodNameConverted = 'add';
          else if (methodName == '-')
            methodNameConverted = 'subtract';
          else if (methodName == '*')
            methodNameConverted = 'multiply';
          else if (methodName == '/') methodNameConverted = 'divide';
          return '$methodNameConverted(self, ${parts[0]})';
        }
        return '$methodName(self, ${args})';
      } else if (methodName == '>' ||
          methodName == '<' ||
          methodName == '>=' ||
          methodName == '<=' ||
          methodName == '==' ||
          methodName == '!=') {
        final parts = args.split(', ');
        if (parts.length == 2) {
          String methodNameConverted = methodName;
          if (methodName == '>')
            methodNameConverted = 'greaterThan';
          else if (methodName == '<')
            methodNameConverted = 'lessThan';
          else if (methodName == '>=')
            methodNameConverted = 'greaterThanOrEqual';
          else if (methodName == '<=')
            methodNameConverted = 'lessThanOrEqual';
          else if (methodName == '==')
            methodNameConverted = 'equals';
          else if (methodName == '!=') methodNameConverted = 'notEquals';
          return '$methodNameConverted(self, ${parts[0]}, ${parts[1]})';
        } else if (parts.length == 1) {
          // 处理只有一个参数的情况
          String methodNameConverted = methodName;
          if (methodName == '>')
            methodNameConverted = 'greaterThan';
          else if (methodName == '<')
            methodNameConverted = 'lessThan';
          else if (methodName == '>=')
            methodNameConverted = 'greaterThanOrEqual';
          else if (methodName == '<=')
            methodNameConverted = 'lessThanOrEqual';
          else if (methodName == '==')
            methodNameConverted = 'equals';
          else if (methodName == '!=') methodNameConverted = 'notEquals';
          return '$methodNameConverted(self, ${parts[0]})';
        }
        return '$methodName(self, ${args})';
      } else if (methodName == '%' ||
          methodName == '&' ||
          methodName == '|' ||
          methodName == '^' ||
          methodName == '<<' ||
          methodName == '>>' ||
          methodName == '>>>') {
        final parts = args.split(', ');
        if (parts.length == 2) {
          String methodNameConverted = methodName;
          if (methodName == '%')
            methodNameConverted = 'modulo';
          else if (methodName == '&')
            methodNameConverted = 'bitwiseAnd';
          else if (methodName == '|')
            methodNameConverted = 'bitwiseOr';
          else if (methodName == '^')
            methodNameConverted = 'bitwiseXor';
          else if (methodName == '<<')
            methodNameConverted = 'leftShift';
          else if (methodName == '>>')
            methodNameConverted = 'rightShift';
          else if (methodName == '>>>')
            methodNameConverted = 'unsignedRightShift';
          return '$methodNameConverted(self, ${parts[0]}, ${parts[1]})';
        } else if (parts.length == 1) {
          // 处理只有一个参数的情况
          String methodNameConverted = methodName;
          if (methodName == '%')
            methodNameConverted = 'modulo';
          else if (methodName == '&')
            methodNameConverted = 'bitwiseAnd';
          else if (methodName == '|')
            methodNameConverted = 'bitwiseOr';
          else if (methodName == '^')
            methodNameConverted = 'bitwiseXor';
          else if (methodName == '<<')
            methodNameConverted = 'leftShift';
          else if (methodName == '>>')
            methodNameConverted = 'rightShift';
          else if (methodName == '>>>')
            methodNameConverted = 'unsignedRightShift';
          return '$methodNameConverted(self, ${parts[0]})';
        }
        return '$methodName(self, ${args})';
      } else if (methodName == '~' ||
          methodName == 'unary-' ||
          methodName == 'unary+' ||
          methodName == '!') {
        String methodNameConverted = methodName;
        if (methodName == '~')
          methodNameConverted = 'bitwiseNot';
        else if (methodName == 'unary-')
          methodNameConverted = 'negate';
        else if (methodName == 'unary+')
          methodNameConverted = 'positive';
        else if (methodName == '!') methodNameConverted = 'logicalNot';
        return '$methodNameConverted(self)';
      } else if (methodName == '++' || methodName == '--') {
        String methodNameConverted = methodName;
        if (methodName == '++')
          methodNameConverted = 'increment';
        else if (methodName == '--') methodNameConverted = 'decrement';
        return '$methodNameConverted(self)';
      } else if (methodName == '+=' ||
          methodName == '-=' ||
          methodName == '*=' ||
          methodName == '/=' ||
          methodName == '%=' ||
          methodName == '&=' ||
          methodName == '|=' ||
          methodName == '^=' ||
          methodName == '<<=' ||
          methodName == '>>=' ||
          methodName == '>>>=') {
        final parts = args.split(', ');
        if (parts.length == 1) {
          String methodNameConverted = methodName;
          if (methodName == '+=')
            methodNameConverted = 'addAssign';
          else if (methodName == '-=')
            methodNameConverted = 'subtractAssign';
          else if (methodName == '*=')
            methodNameConverted = 'multiplyAssign';
          else if (methodName == '/=')
            methodNameConverted = 'divideAssign';
          else if (methodName == '%=')
            methodNameConverted = 'moduloAssign';
          else if (methodName == '&=')
            methodNameConverted = 'bitwiseAndAssign';
          else if (methodName == '|=')
            methodNameConverted = 'bitwiseOrAssign';
          else if (methodName == '^=')
            methodNameConverted = 'bitwiseXorAssign';
          else if (methodName == '<<=')
            methodNameConverted = 'leftShiftAssign';
          else if (methodName == '>>=')
            methodNameConverted = 'rightShiftAssign';
          else if (methodName == '>>>=')
            methodNameConverted = 'unsignedRightShiftAssign';
          return '$methodNameConverted(self, ${parts[0]})';
        }
        return '$methodName(self, ${args})';
      } else if (methodName == '??' ||
          methodName == '&&' ||
          methodName == '||') {
        final parts = args.split(', ');
        if (parts.length == 2) {
          String methodNameConverted = methodName;
          if (methodName == '??')
            methodNameConverted = 'nullCoalesce';
          else if (methodName == '&&')
            methodNameConverted = 'logicalAnd';
          else if (methodName == '||') methodNameConverted = 'logicalOr';
          return '$methodNameConverted(self, ${parts[0]}, ${parts[1]})';
        }
        return '$methodName(self, ${args})';
      } else {
        return '$methodName(self, ${args})';
      }
    } else if (expression is ListLiteral) {
      final elements =
          expression.expressions.map((e) => _expressionToString(e)).join(', ');
      return '[$elements]';
    } else if (expression is MapLiteral) {
      final entries = expression.entries
          .map((e) =>
              '${_expressionToString(e.key)}: ${_expressionToString(e.value)}')
          .join(', ');
      return '{$entries}';
    } else if (expression is SetLiteral) {
      final elements =
          expression.expressions.map((e) => _expressionToString(e)).join(', ');
      return '{$elements}';
    } else if (expression is ConditionalExpression) {
      final condition = _expressionToString(expression.condition);
      final then = _expressionToString(expression.then);
      final otherwise = _expressionToString(expression.otherwise);
      return '$condition ? $then : $otherwise';
    } else if (expression is Not) {
      final operand = _expressionToString(expression.operand);
      return '!$operand';
    } else if (expression is SuperPropertyGet) {
      return 'super.${expression.name.text}';
    } else if (expression is SuperPropertySet) {
      return 'super.${expression.name.text} = ${_expressionToString(expression.value)}';
    } else if (expression is SuperMethodInvocation) {
      final args = expression.arguments.positional
          .map((e) => _expressionToString(e))
          .join(', ');
      return 'super.${expression.name.text}($args)';
    } else if (expression is FunctionTearOff) {
      return 'function_tearoff';
    } else if (expression is InstanceTearOff) {
      return 'instance_tearoff';
    } else if (expression is StaticTearOff) {
      return 'static_tearoff';
    } else if (expression is Let) {
      // 处理Let表达式
      return 'let_expression';
    } else if (expression is FunctionInvocation) {
      // 处理函数调用
      final args = expression.arguments.positional
          .map((e) => _expressionToString(e))
          .join(', ');
      return 'functionInvocation($args)';
    } else if (expression is AsExpression) {
      // 处理类型转换
      final operand = _expressionToString(expression.operand);
      final type = _getDartType(expression.type);
      return '$operand as $type';
    } else if (expression is EqualsCall) {
      // 处理相等性调用
      final left = _expressionToString(expression.left);
      final right = _expressionToString(expression.right);
      return '$left == $right';
    } else if (expression is StringConcatenation) {
      // 处理字符串连接
      final expressions =
          expression.expressions.map((e) => _expressionToString(e)).join(' + ');
      return expressions;
    } else if (expression is Throw) {
      // 处理抛出异常
      final expressionStr = _expressionToString(expression.expression);
      return 'throw $expressionStr';
    } else if (expression is ConstantExpression) {
      // 处理常量表达式
      return 'const ${expression.constant}';
    } else if (expression is EqualsNull) {
      // 处理空值检查
      final operand = _expressionToString(expression.expression);
      return '$operand == null';
    } else if (expression is FunctionExpression) {
      // 处理匿名函数/闭包表达式
      final function = expression.function;
      final parameters = function.positionalParameters
          .map((p) =>
              '${_getDartType(p.type)} ${_cleanVariableName(p.name ?? 'param')}')
          .join(', ');
      final returnType = _getDartType(function.returnType);
      return '($parameters) { /* TODO: 实现匿名函数 */ return null as $returnType; }';
    } else if (expression is IsExpression) {
      // 处理类型判断表达式
      final operand = _expressionToString(expression.operand);
      final type = _getDartType(expression.type);
      return '$operand is $type';
    } else if (expression is NullCheck) {
      // 处理空安全断言表达式
      final operand = _expressionToString(expression.operand);
      return '$operand!';
    } else if (expression is BlockExpression) {
      // 处理块表达式
      final statements = expression.body.statements
          .map((s) => _writeTransformedStatementToString(s))
          .join('\n    ');
      return '(() {\n    $statements\n    return null;\n  })()';
    } else if (expression is LocalFunctionInvocation) {
      // 处理局部函数调用
      final args = expression.arguments.positional
          .map((e) => _expressionToString(e))
          .join(', ');
      return '${expression.name.text}($args)';
    } else if (expression is RecordLiteral) {
      // 处理记录字面量
      final fields =
          expression.positional.map((f) => _expressionToString(f)).join(', ');
      return '($fields)';
    } else if (expression is TypeLiteral) {
      // 处理类型字面量
      return _getDartType(expression.type);
    } else if (expression is AwaitExpression) {
      // 处理await表达式
      final operand = _expressionToString(expression.operand);
      return 'await $operand';
    } else if (expression is RecordNameGet) {
      // 处理记录字段访问
      final record = _expressionToString(expression.receiver);
      return '$record.${expression.name}';
    } else {
      return '/* 未处理的表达式类型: ${expression.runtimeType} - ${expression.toString()} */';
    }
  }

  /// 转换表达式，用于运算符重载方法（保持this引用）
  String _expressionToStringForOperator(Expression expression) {
    if (expression is ThisExpression) {
      return 'this';
    } else if (expression is VariableGet) {
      final originalName = expression.variable.name ?? 'unknown';
      return _cleanVariableName(originalName);
    } else if (expression is VariableSet) {
      final originalName = expression.variable.name ?? 'unknown';
      final cleanName = _cleanVariableName(originalName);
      return '$cleanName = ${_expressionToStringForOperator(expression.value)}';
    } else if (expression is InstanceGet) {
      return 'this.${expression.name.text}';
    } else if (expression is InstanceSet) {
      return 'this.${expression.name.text} = ${_expressionToStringForOperator(expression.value)}';
    } else if (expression is InstanceInvocation) {
      final args = expression.arguments.positional
          .map((e) => _expressionToStringForOperator(e))
          .join(', ');

      // 处理运算符调用 - 转换为方法调用
      final methodName = expression.interfaceTarget.name.text;

      // 特殊处理 moveNext(this, ) 转换为静态方法调用
      if (methodName == 'moveNext' && args.isEmpty) {
        return 'moveNext(this)';
      }

      if (methodName == '[]') {
        return 'getElement(this, ${args})';
      } else if (methodName == '[]=') {
        final parts = args.split(', ');
        if (parts.length >= 2) {
          final index = parts[0];
          final value = parts.sublist(1).join(', ');
          return 'setElement(this, $index, $value)';
        }
        return 'setElement(this, ${args})';
      } else if (methodName == '+' ||
          methodName == '-' ||
          methodName == '*' ||
          methodName == '/') {
        final parts = args.split(', ');
        if (parts.length == 1) {
          String methodNameConverted = methodName;
          if (methodName == '+')
            methodNameConverted = 'add';
          else if (methodName == '-')
            methodNameConverted = 'subtract';
          else if (methodName == '*')
            methodNameConverted = 'multiply';
          else if (methodName == '/') methodNameConverted = 'divide';
          return '$methodNameConverted(this, ${parts[0]})';
        }
        return '$methodName(this, ${args})';
      } else if (methodName == '>' ||
          methodName == '<' ||
          methodName == '>=' ||
          methodName == '<=' ||
          methodName == '==' ||
          methodName == '!=') {
        final parts = args.split(', ');
        if (parts.length == 2) {
          String methodNameConverted = methodName;
          if (methodName == '>')
            methodNameConverted = 'greaterThan';
          else if (methodName == '<')
            methodNameConverted = 'lessThan';
          else if (methodName == '>=')
            methodNameConverted = 'greaterThanOrEqual';
          else if (methodName == '<=')
            methodNameConverted = 'lessThanOrEqual';
          else if (methodName == '==')
            methodNameConverted = 'equals';
          else if (methodName == '!=') methodNameConverted = 'notEquals';
          return '$methodNameConverted(this, ${parts[0]}, ${parts[1]})';
        }
        return '$methodName(this, ${args})';
      } else if (methodName == '%' ||
          methodName == '&' ||
          methodName == '|' ||
          methodName == '^' ||
          methodName == '<<' ||
          methodName == '>>' ||
          methodName == '>>>') {
        final parts = args.split(', ');
        if (parts.length == 2) {
          String methodNameConverted = methodName;
          if (methodName == '%')
            methodNameConverted = 'modulo';
          else if (methodName == '&')
            methodNameConverted = 'bitwiseAnd';
          else if (methodName == '|')
            methodNameConverted = 'bitwiseOr';
          else if (methodName == '^')
            methodNameConverted = 'bitwiseXor';
          else if (methodName == '<<')
            methodNameConverted = 'leftShift';
          else if (methodName == '>>')
            methodNameConverted = 'rightShift';
          else if (methodName == '>>>')
            methodNameConverted = 'unsignedRightShift';
          return '$methodNameConverted(this, ${parts[0]}, ${parts[1]})';
        } else if (parts.length == 1) {
          // 处理只有一个参数的情况
          String methodNameConverted = methodName;
          if (methodName == '%')
            methodNameConverted = 'modulo';
          else if (methodName == '&')
            methodNameConverted = 'bitwiseAnd';
          else if (methodName == '|')
            methodNameConverted = 'bitwiseOr';
          else if (methodName == '^')
            methodNameConverted = 'bitwiseXor';
          else if (methodName == '<<')
            methodNameConverted = 'leftShift';
          else if (methodName == '>>')
            methodNameConverted = 'rightShift';
          else if (methodName == '>>>')
            methodNameConverted = 'unsignedRightShift';
          return '$methodNameConverted(this, ${parts[0]})';
        }
        return '$methodName(this, ${args})';
      } else if (methodName == '~' ||
          methodName == 'unary-' ||
          methodName == 'unary+' ||
          methodName == '!') {
        String methodNameConverted = methodName;
        if (methodName == '~')
          methodNameConverted = 'bitwiseNot';
        else if (methodName == 'unary-')
          methodNameConverted = 'negate';
        else if (methodName == 'unary+')
          methodNameConverted = 'positive';
        else if (methodName == '!') methodNameConverted = 'logicalNot';
        return '$methodNameConverted(this)';
      } else if (methodName == '++' || methodName == '--') {
        String methodNameConverted = methodName;
        if (methodName == '++')
          methodNameConverted = 'increment';
        else if (methodName == '--') methodNameConverted = 'decrement';
        return '$methodNameConverted(this)';
      } else if (methodName == '+=' ||
          methodName == '-=' ||
          methodName == '*=' ||
          methodName == '/=' ||
          methodName == '%=' ||
          methodName == '&=' ||
          methodName == '|=' ||
          methodName == '^=' ||
          methodName == '<<=' ||
          methodName == '>>=' ||
          methodName == '>>>=') {
        final parts = args.split(', ');
        if (parts.length == 1) {
          String methodNameConverted = methodName;
          if (methodName == '+=')
            methodNameConverted = 'addAssign';
          else if (methodName == '-=')
            methodNameConverted = 'subtractAssign';
          else if (methodName == '*=')
            methodNameConverted = 'multiplyAssign';
          else if (methodName == '/=')
            methodNameConverted = 'divideAssign';
          else if (methodName == '%=')
            methodNameConverted = 'moduloAssign';
          else if (methodName == '&=')
            methodNameConverted = 'bitwiseAndAssign';
          else if (methodName == '|=')
            methodNameConverted = 'bitwiseOrAssign';
          else if (methodName == '^=')
            methodNameConverted = 'bitwiseXorAssign';
          else if (methodName == '<<=')
            methodNameConverted = 'leftShiftAssign';
          else if (methodName == '>>=')
            methodNameConverted = 'rightShiftAssign';
          else if (methodName == '>>>=')
            methodNameConverted = 'unsignedRightShiftAssign';
          return '$methodNameConverted(this, ${parts[0]})';
        }
        return '$methodName(this, ${args})';
      } else if (methodName == '??' ||
          methodName == '&&' ||
          methodName == '||') {
        final parts = args.split(', ');
        if (parts.length == 2) {
          String methodNameConverted = methodName;
          if (methodName == '??')
            methodNameConverted = 'nullCoalesce';
          else if (methodName == '&&')
            methodNameConverted = 'logicalAnd';
          else if (methodName == '||') methodNameConverted = 'logicalOr';
          return '$methodNameConverted(this, ${parts[0]}, ${parts[1]})';
        }
        return '$methodName(this, ${args})';
      } else {
        return '$methodName(this, ${args})';
      }
    } else if (expression is IntLiteral) {
      return expression.value.toString();
    } else if (expression is DoubleLiteral) {
      return expression.value.toString();
    } else if (expression is StringLiteral) {
      return '"${expression.value}"';
    } else if (expression is BoolLiteral) {
      return expression.value.toString();
    } else if (expression is NullLiteral) {
      return 'null';
    } else if (expression is ConstructorInvocation) {
      final args = expression.arguments.positional
          .map((e) => _expressionToStringForOperator(e))
          .join(', ');

      // 检查构造函数名称
      final constructorName = expression.target.name.text;
      final className = expression.target.enclosingClass.name;

      // 特殊处理内置类型
      if (className == '_GrowableList') {
        if (constructorName.isEmpty) {
          // 对于_GrowableList的无名称构造函数，使用List构造函数
          return 'List($args)';
        } else {
          // 对于_GrowableList的有名称构造函数，使用_literal方法
          return '_GrowableList._literal$constructorName($args)';
        }
      } else if (constructorName.isEmpty) {
        // 无名称构造函数，使用create方法
        return '${className}.create($args)';
      } else {
        // 有名称构造函数，使用create_ConstructorName方法
        return '${className}.create_${constructorName}($args)';
      }
    } else if (expression is StaticInvocation) {
      final args = expression.arguments.positional
          .map((e) => _expressionToStringForOperator(e))
          .join(', ');
      final className = expression.target.enclosingClass?.name;
      if (className != null && className.isNotEmpty) {
        return '$className.${expression.target.name.text}($args)';
      } else {
        // 对于没有类名的静态调用，直接使用方法名
        return '${expression.target.name.text}($args)';
      }
    } else if (expression is LogicalExpression) {
      final left = _expressionToStringForOperator(expression.left);
      final right = _expressionToStringForOperator(expression.right);
      final op = _getLogicalOperator(expression.operatorEnum);
      return '$left $op $right';
    } else if (expression is StaticGet) {
      return 'this.${expression.target.name.text}';
    } else if (expression is StaticSet) {
      return 'this.${expression.target.name.text} = ${_expressionToStringForOperator(expression.value)}';
    } else if (expression is DynamicInvocation) {
      final args = expression.arguments.positional
          .map((e) => _expressionToStringForOperator(e))
          .join(', ');

      // 处理运算符调用 - 转换为方法调用
      final methodName = expression.name.text;

      // 特殊处理 moveNext(this, ) 转换为静态方法调用
      if (methodName == 'moveNext' && args.isEmpty) {
        return 'moveNext(this)';
      }

      if (methodName == '[]') {
        return 'getElement(this, ${args})';
      } else if (methodName == '[]=') {
        final parts = args.split(', ');
        if (parts.length >= 2) {
          final index = parts[0];
          final value = parts.sublist(1).join(', ');
          return 'setElement(this, $index, $value)';
        }
        return 'setElement(this, ${args})';
      } else if (methodName == '+' ||
          methodName == '-' ||
          methodName == '*' ||
          methodName == '/') {
        final parts = args.split(', ');
        if (parts.length == 1) {
          String methodNameConverted = methodName;
          if (methodName == '+')
            methodNameConverted = 'add';
          else if (methodName == '-')
            methodNameConverted = 'subtract';
          else if (methodName == '*')
            methodNameConverted = 'multiply';
          else if (methodName == '/') methodNameConverted = 'divide';
          return '$methodNameConverted(this, ${parts[0]})';
        }
        return '$methodName(this, ${args})';
      } else if (methodName == '>' ||
          methodName == '<' ||
          methodName == '>=' ||
          methodName == '<=' ||
          methodName == '==' ||
          methodName == '!=') {
        final parts = args.split(', ');
        if (parts.length == 2) {
          String methodNameConverted = methodName;
          if (methodName == '>')
            methodNameConverted = 'greaterThan';
          else if (methodName == '<')
            methodNameConverted = 'lessThan';
          else if (methodName == '>=')
            methodNameConverted = 'greaterThanOrEqual';
          else if (methodName == '<=')
            methodNameConverted = 'lessThanOrEqual';
          else if (methodName == '==')
            methodNameConverted = 'equals';
          else if (methodName == '!=') methodNameConverted = 'notEquals';
          return '$methodNameConverted(this, ${parts[0]}, ${parts[1]})';
        }
        return '$methodName(this, ${args})';
      } else {
        return '$methodName(this, ${args})';
      }
    } else if (expression is ListLiteral) {
      final elements = expression.expressions
          .map((e) => _expressionToStringForOperator(e))
          .join(', ');
      return '[$elements]';
    } else if (expression is MapLiteral) {
      final entries = expression.entries
          .map((e) =>
              '${_expressionToStringForOperator(e.key)}: ${_expressionToStringForOperator(e.value)}')
          .join(', ');
      return '{$entries}';
    } else if (expression is SetLiteral) {
      final elements = expression.expressions
          .map((e) => _expressionToStringForOperator(e))
          .join(', ');
      return '{$elements}';
    } else if (expression is ConditionalExpression) {
      final condition = _expressionToStringForOperator(expression.condition);
      final then = _expressionToStringForOperator(expression.then);
      final otherwise = _expressionToStringForOperator(expression.otherwise);
      return '$condition ? $then : $otherwise';
    } else if (expression is Not) {
      final operand = _expressionToStringForOperator(expression.operand);
      return '!$operand';
    } else if (expression is SuperPropertyGet) {
      return 'super.${expression.name.text}';
    } else if (expression is SuperPropertySet) {
      return 'super.${expression.name.text} = ${_expressionToStringForOperator(expression.value)}';
    } else if (expression is SuperMethodInvocation) {
      final args = expression.arguments.positional
          .map((e) => _expressionToStringForOperator(e))
          .join(', ');
      return 'super.${expression.name.text}($args)';
    } else if (expression is FunctionTearOff) {
      return 'function_tearoff';
    } else if (expression is InstanceTearOff) {
      return 'instance_tearoff';
    } else if (expression is StaticTearOff) {
      return 'static_tearoff';
    } else {
      return '/* 未处理的表达式类型: ${expression.runtimeType} */';
    }
  }

  /// 获取逻辑运算符
  String _getLogicalOperator(LogicalExpressionOperator operator) {
    switch (operator) {
      case LogicalExpressionOperator.AND:
        return '&&';
      case LogicalExpressionOperator.OR:
        return '||';
    }
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
      print('成功生成转换后的Dart代码: ${outputFile.absolute.path}');
    } catch (e) {
      print('写入文件时发生错误: $e');
    }
  }

  /// 获取生成的代码
  String getGeneratedCode() {
    return _buffer.toString();
  }
}

/// 全局转换函数
void transformDartToDart(Component component) {
  final transformer = DartToDartTransformer();
  transformer.transformComponent(component);
}
