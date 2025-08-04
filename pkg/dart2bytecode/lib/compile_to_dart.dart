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

  // 当前正在处理的类名，用于内部函数调用
  String? _currentClassName;

  // 类名替换映射，用于 @pragma('cpp:patch', 'Error') 注解
  final Map<String, String> _classNameReplacements = {};

  /// 主要转换入口
  void transformComponent(Component component) {
    _buffer.clear();

    // 生成转换后的代码
    _generateTransformedCode(component);

    // 输出到文件
    _writeOutput();
  }

  /// 判断是否应该跳过某个类
  bool _shouldSkipClass(Class cls) {
    print('DEBUG: 检查类 ${cls.name}，注解数量: ${cls.annotations.length}');

    // 调试：打印注解信息
    _debugPrintAnnotations(cls);

    // 检查是否有 @pragma('cpp:native', xxx) 注解
    if (_hasCppNativePragma(cls)) {
      print('DEBUG: 跳过类 ${cls.name}，因为它有 @pragma("cpp:native") 注解');
      return true; // 跳过带有 cpp:native 注解的类
    }

    // 跳过系统类、内置类等
    // 获取文件路径信息
    final libraryUri = cls.enclosingLibrary.fileUri;
    final filePath =
        libraryUri.isScheme('file') ? libraryUri.path : libraryUri.toString();

    final libraryName = cls.enclosingLibrary.toStringInternal();
    final shouldSkip = libraryName.startsWith('dart.') ||
        libraryName.startsWith('dart:') ||
        libraryName.startsWith('package:flutter') ||
        filePath.contains('org-dartlang-sdk');

    if (shouldSkip) {
      print('DEBUG: 跳过类 ${cls.name}，因为它是系统类');
    }

    return shouldSkip;
  }

  /// 检查类是否有 @pragma('cpp:native', xxx) 注解
  bool _hasCppNativePragma(Class cls) {
    for (final annotation in cls.annotations) {
      // 打印注解的字符串表示，用于调试
      final annotationStr = annotation.toString();
      print('DEBUG: 注解字符串: $annotationStr');

      if (annotation is ConstantExpression) {
        final constant = annotation.constant;
        print('DEBUG: 常量类型: ${constant.runtimeType}');

        if (constant is InstanceConstant) {
          final classNode = constant.classNode;
          print('DEBUG: 类名: ${classNode.name}');
          print('DEBUG: 字段值: ${constant.fieldValues}');

          if (classNode.name == 'pragma') {
            // 检查参数
            if (constant.fieldValues.containsKey('name')) {
              final nameValue = constant.fieldValues['name'];
              print('DEBUG: name值: $nameValue');
              if (nameValue is StringConstant &&
                  nameValue.value == 'cpp:native') {
                print('DEBUG: 找到 cpp:native 注解');
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
  void _debugPrintAnnotations(Class cls) {
    print('DEBUG: 检查类 ${cls.name} 的注解:');
    for (final annotation in cls.annotations) {
      print('  - 注解类型: ${annotation.runtimeType}');
      if (annotation is ConstantExpression) {
        final constant = annotation.constant;
        print('  - 常量类型: ${constant.runtimeType}');
        if (constant is InstanceConstant) {
          print('  - 类名: ${constant.classNode.name}');
          print('  - 字段值: ${constant.fieldValues}');
        }
      }
    }
  }

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
      print('DEBUG: 处理库: ${library.toStringInternal()}');
      for (final cls in library.classes) {
        // 调试信息：打印类名和库名
        final libraryName = cls.enclosingLibrary.toStringInternal();
        print('DEBUG: 检查类 ${cls.name} 来自库 $libraryName');

        if (!_shouldSkipClass(cls)) {
          print('DEBUG: 转换类 ${cls.name}');
          _generateTransformedClass(cls);
        } else {
          print('DEBUG: 跳过类 ${cls.name}');
        }
      }
    }

    print('DEBUG: 转换完成，生成的代码长度: ${_buffer.length}');
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

    // 获取文件路径信息
    final libraryUri = cls.enclosingLibrary.fileUri;
    final filePath =
        libraryUri.isScheme('file') ? libraryUri.path : libraryUri.toString();

    // 类注释 - 包含文件路径信息
    _writeLine('/// 转换后的类: ${cls.name}');
    _writeLine('/// 源文件路径: $filePath');
    _writeLine('');

    // 类声明
    _write('class ${cls.name}');
    // 泛型参数
    String typeParams = '';
    if (cls.typeParameters.isNotEmpty) {
      typeParams = '<${cls.typeParameters.map((t) => t.name).join(', ')}>';
      _write(typeParams);
    }
    // 继承关系
    String? extendsClause;
    if (cls.superclass != null && cls.superclass!.name != 'Object') {
      String className = cls.superclass!.name;
      // 传递泛型参数给父类
      if (cls.superclass!.typeParameters.isNotEmpty &&
          cls.typeParameters.isNotEmpty) {
        className += '<${cls.typeParameters.map((t) => t.name).join(', ')}>';
      }
      extendsClause = 'extends $className';
    }
    // 接口实现
    String? implementsClause;
    if (cls.implementedTypes.isNotEmpty) {
      final impls = cls.implementedTypes.map((t) {
        String name = t.classNode.name;
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
    // 跳过带有 @pragma('cpp:native') 注解的类
    if (_hasCppNativePragma(cls)) {
      return;
    }

    // 生成所有字段，包括静态字段
    for (final field in cls.fields) {
      // 注解
      for (final annotation in field.annotations) {
        _writeLine(_annotationToString(annotation));
      }

      // 字段声明
      final buffer = StringBuffer();
      if (field.isStatic) buffer.write('static ');
      if (field.isLate) buffer.write('late ');
      if (field.isFinal) buffer.write('final ');
      final fieldType = _getDartType(field.type);
      final fieldName = field.name.text;
      buffer.write('$fieldType $fieldName');
      if (field.initializer != null) {
        buffer.write(' = ${_expressionToString(field.initializer!)}');
      }
      buffer.write(';');
      _writeLine(buffer.toString());
    }

    if (cls.fields.isNotEmpty) {
      _writeLine('');
    }
  }

  /// 生成late字段
  void _generateLateFields(Class cls) {
    // 跳过带有 @pragma('cpp:native') 注解的类
    if (_hasCppNativePragma(cls)) {
      return;
    }

    for (final field in cls.fields) {
      if (!field.isStatic && field.isFinal) {
        _writeLine('late ${_getDartType(field.type)} ${field.name.text};');
      }
    }
    _writeLine('');
  }

  /// 生成成员方法
  void _generateMemberMethods(Class cls) {
    // 跳过带有 @pragma('cpp:native') 注解的类
    if (_hasCppNativePragma(cls)) {
      return;
    }

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
          _generateMemberMethod(procedure);
        }
      }
    }

    // 生成 getter/setter 方法
    for (final procedure in cls.procedures) {
      if (!procedure.isStatic &&
          !procedure.isAbstract &&
          !procedure.isFactory) {
        if (procedure.isGetter) {
          _generateGetter(cls, procedure);
        } else if (procedure.isSetter) {
          _generateSetter(cls, procedure);
        }
      }
    }
  }

  /// 生成无参构造方法
  void _generateDefaultConstructor(Class cls) {
    // 跳过带有 @pragma('cpp:native') 注解的类
    if (_hasCppNativePragma(cls)) {
      return;
    }

    _writeLine('${cls.name}();');
    _writeLine('');
  }

  /// 生成构造方法
  void _generateConstructors(Class cls) {
    if (_hasCppNativePragma(cls)) return;
    for (final constructor in cls.constructors) {
      // 注解
      for (final annotation in constructor.annotations) {
        _writeLine(_annotationToString(annotation));
      }
      // 构造函数声明
      _write(cls.name);
      if (constructor.name.text.isNotEmpty) {
        _write('.${constructor.name.text}');
      }
      _write('(');
      _writeParameters(constructor.function);
      _write(') {');
      _indent();
      if (constructor.function.body != null) {
        _writeTransformedStatement(constructor.function.body!);
      }
      _unindent();
      _writeLine('}');
      _writeLine('');
    }
  }

  /// 生成单个构造方法
  void _generateConstructor(Class cls, Constructor constructor) {
    final function = constructor.function;
    final constructorName = constructor.name.text;

    // 生成构造方法签名
    if (constructorName.isEmpty) {
      _write('${cls.name}(');
    } else {
      _write('${cls.name}.$constructorName(');
    }
    _writeParameters(function);
    _writeLine(') {');
    _indent();

    // 生成方法体
    if (function.body != null) {
      _writeTransformedStatement(function.body!);
    } else {
      _writeLine('// TODO: 实现构造方法体');
    }

    _unindent();
    _writeLine('}');
    _writeLine('');
  }

  /// 生成成员方法
  void _generateStaticMethods(ClassInfo classInfo) {
    // 跳过带有 @pragma('cpp:native') 注解的类
    if (_hasCppNativePragma(classInfo.cls)) {
      return;
    }

    // 生成普通成员方法（不转换为静态方法）
    for (final procedure in classInfo.staticMethods) {
      _generateMemberMethod(procedure);
    }

    // 生成 getter/setter 方法
    for (final procedure in classInfo.cls.procedures) {
      if (!procedure.isStatic &&
          !procedure.isAbstract &&
          !procedure.isFactory) {
        if (procedure.isGetter) {
          _generateGetter(classInfo.cls, procedure);
        } else if (procedure.isSetter) {
          _generateSetter(classInfo.cls, procedure);
        }
      }
    }
  }

  /// 生成 getter 方法
  void _generateGetter(Class cls, Procedure procedure) {
    final function = procedure.function;
    final getterName = procedure.name.text;
    final returnType = _getDartType(function.returnType);

    // 生成 getter 声明
    _writeLine(
        '$returnType get $getterName => ${_generateGetterBody(function)};');
    _writeLine('');
  }

  /// 生成 setter 方法
  void _generateSetter(Class cls, Procedure procedure) {
    final function = procedure.function;
    final setterName = procedure.name.text;
    final paramType = function.positionalParameters.isNotEmpty
        ? _getDartType(function.positionalParameters[0].type)
        : 'dynamic';

    // 生成 setter 声明
    _writeLine('set $setterName($paramType value) {');
    _indent();
    if (function.body != null) {
      _writeTransformedStatement(function.body!);
    } else {
      _writeLine('// TODO: 实现 setter 逻辑');
    }
    _unindent();
    _writeLine('}');
    _writeLine('');
  }

  /// 生成 getter 方法体
  String _generateGetterBody(FunctionNode function) {
    if (function.body != null) {
      // 如果 body 是表达式语句，提取表达式
      if (function.body is ExpressionStatement) {
        final exprStmt = function.body as ExpressionStatement;
        return _expressionToString(exprStmt.expression);
      } else {
        // 对于其他类型的语句，生成默认返回值
        return 'null';
      }
    } else {
      return 'null'; // 默认返回值
    }
  }

  /// 将语句转换为字符串
  String _statementToString(Statement statement) {
    if (statement is ForInStatement) {
      final variable = _cleanVariableName(statement.variable.name ?? 'item');
      final iterable = _expressionToString(statement.iterable);
      String bodyStr;
      if (statement.body is Block) {
        final block = statement.body as Block;
        if (block.statements.length == 1) {
          bodyStr = _statementToString(block.statements.first);
        } else {
          bodyStr = _statementToString(block);
        }
      } else {
        bodyStr = '{${_statementToString(statement.body)}}';
      }
      return 'for (final $variable in $iterable) $bodyStr';
    } else if (statement is Block) {
      if (statement.statements.isEmpty) return '{}';
      if (statement.statements.length == 1) {
        return _statementToString(statement.statements.first);
      }
      // 检查是否为手写迭代器模式
      if (statement.statements.length == 3) {
        final stmt1 = statement.statements[0];
        final stmt2 = statement.statements[1];
        final stmt3 = statement.statements[2];
        if (stmt1 is VariableDeclaration &&
            stmt1.name == '_sync_for_iterator' &&
            stmt1.initializer != null) {
          if (stmt2 is ForStatement &&
              stmt2.variables.isEmpty &&
              stmt2.condition != null &&
              stmt2.condition is InstanceInvocation &&
              (stmt2.condition as InstanceInvocation).name.text == 'moveNext' &&
              stmt2.updates.isEmpty) {
            if (stmt3 is ExpressionStatement) {
              final iteratorSource = _expressionToString(stmt1.initializer!);
              final iterable = iteratorSource.replaceAll('.iterator', '');
              final body = _statementToString(stmt3);
              return 'for (final entry in $iterable) $body';
            }
          }
        }
      }
      final stmts = statement.statements.map(_statementToString).join('\n');
      return '{\n$stmts\n}';
    } else if (statement is VariableDeclaration) {
      final type = _getDartType(statement.type);
      final name = _cleanVariableName(statement.name ?? 'var');
      if (statement.initializer != null) {
        final init = _expressionToString(statement.initializer!);
        if (name == init) return '';
        return '$type $name = $init;';
      }
      return '$type $name;';
    } else if (statement is ExpressionStatement) {
      return '${_expressionToString(statement.expression)};';
    } else if (statement is ReturnStatement) {
      if (statement.expression != null) {
        return 'return ${_expressionToString(statement.expression!)};';
      } else {
        return 'return;';
      }
    } else if (statement is IfStatement) {
      final cond = _expressionToString(statement.condition);
      final thenStr = _statementToString(statement.then);
      final elseStr = statement.otherwise != null
          ? ' else ' + _statementToString(statement.otherwise!)
          : '';
      return 'if ($cond) $thenStr$elseStr';
    } else if (statement is ForStatement) {
      // 检查是否为手写迭代器模式
      if (statement.variables.isEmpty &&
          statement.condition != null &&
          statement.updates.length == 1) {
        final condition = statement.condition!;
        final update = statement.updates[0];

        // 检查是否为手写迭代器模式
        if (condition is InstanceInvocation &&
            condition.name.text == 'moveNext' &&
            update is VariableSet &&
            update.variable.name == 'element' &&
            update.value is VariableGet &&
            (update.value as VariableGet).variable.name == 'entry') {
          print('DEBUG: 匹配到手写迭代器模式！');
          // 这里需要从上下文获取迭代器源，暂时使用占位符
          _write('for (final element in iterable) ');
          _writeTransformedStatement(statement.body);
        } else {
          // 普通 for 循环
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
        }
      } else {
        // 普通 for 循环
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
      }
    } else if (statement is WhileStatement) {
      final cond = _expressionToString(statement.condition);
      final body = _statementToString(statement.body);
      return 'while ($cond) $body';
    } else if (statement is DoStatement) {
      final body = _statementToString(statement.body);
      final cond = _expressionToString(statement.condition);
      return 'do $body while ($cond);';
    } else if (statement is SwitchStatement) {
      final expression = _expressionToString(statement.expression);
      return 'switch ($expression) { /* TODO: 实现switch语句 */ }';
    } else if (statement is TryCatch) {
      final body = _statementToString(statement.body);
      return 'try $body catch (e) { /* TODO: 实现try-catch */ }';
    } else if (statement is AssertStatement) {
      final condition = _expressionToString(statement.condition);
      final message = statement.message != null
          ? ', ${_expressionToString(statement.message!)}'
          : '';
      return 'assert($condition$message);';
    } else if (statement is BreakStatement) {
      return 'break;';
    } else if (statement is ContinueSwitchStatement) {
      return 'continue;';
    } else if (statement is LabeledStatement) {
      return _statementToString(statement.body);
    } else if (statement is EmptyStatement) {
      return ';';
    }
    return '/* TODO: 未处理的语句类型: ${statement.runtimeType} */';
  }

  /// 生成单个成员方法
  void _generateMemberMethod(Procedure procedure) {
    final function = procedure.function;
    final name = procedure.name.text;

    // 写入方法签名
    _write('${_getDartType(function.returnType)} $name(');
    _writeParameters(function);
    _writeLine(') {');
    _indent();
    if (function.body != null) {
      _writeTransformedStatement(function.body!);
    }
    _unindent();
    _writeLine('}');
    _writeLine('');
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
    // 跳过带有 @pragma('cpp:native') 注解的类
    if (_hasCppNativePragma(cls)) {
      return;
    }

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
          _generateOperatorMethod(procedure);
        }
      }
    }
  }

  /// 生成操作符方法
  void _generateOperatorMethod(Procedure procedure) {
    final function = procedure.function;
    final name = procedure.name.text;

    // 写入操作符方法签名
    _write('${_getDartType(function.returnType)} operator $name(');
    _writeParameters(function);
    _writeLine(') {');
    _indent();
    if (function.body != null) {
      _writeTransformedStatement(function.body!);
    }
    _unindent();
    _writeLine('}');
    _writeLine('');
  }

  /// 写入参数列表
  void _writeParameters(FunctionNode function, {bool onlyFirst = false}) {
    final params = function.positionalParameters;
    final named = function.namedParameters;
    List<String> paramStrs = [];

    for (int i = 0; i < params.length; i++) {
      final p = params[i];
      if (onlyFirst && i > 0) break;
      String s = '${_getDartType(p.type)} ${p.name ?? 'param$i'}';
      if (p.initializer != null)
        s += ' = ${_expressionToString(p.initializer!)}';
      paramStrs.add(s);
    }

    if (named.isNotEmpty) {
      _write(paramStrs.join(', '));
      if (paramStrs.isNotEmpty) _write(', ');
      _write('{' +
          named.map((p) {
            String s = '${_getDartType(p.type)} ${p.name}';
            if (p.initializer != null)
              s += ' = ${_expressionToString(p.initializer!)}';
            return s;
          }).join(', ') +
          '}');
    } else {
      _write(paramStrs.join(', '));
    }
  }

  /// 生成参数列表
  String _writeParameterList(List<VariableDeclaration> parameters) {
    final positional = <String>[];
    final named = <String>[];
    final optional = <String>[];

    for (final param in parameters) {
      final type = _getDartType(param.type);
      final name = _cleanVariableName(param.name ?? 'param');
      final defaultValue = param.initializer != null
          ? ' = ${_expressionToString(param.initializer!)}'
          : '';

      final paramStr = '$type $name$defaultValue';

      // 简化处理，假设所有参数都是位置参数
      positional.add(paramStr);
    }

    return positional.join(', ');
  }

  /// 获取Dart类型字符串
  String _getDartType(DartType? type) {
    if (type == null) return 'dynamic';

    if (type is InterfaceType) {
      final className = type.classNode.name;
      if (className == 'dynamic') return 'dynamic';
      if (className == 'void') return 'void';
      if (className == 'Null') return 'Object?';
      if (className == 'Never') return 'Object';

      // 处理泛型类型
      if (type.typeArguments.isNotEmpty) {
        final args = type.typeArguments.map(_getDartType).join(', ');
        return '$className<$args>';
      }
      return className;
    } else if (type is TypeParameterType) {
      return type.parameter.name ?? 'T';
    } else if (type is FunctionType) {
      // 简化函数类型处理
      return 'Function';
    } else if (type is DynamicType) {
      return 'dynamic';
    } else if (type is VoidType) {
      return 'void';
    } else if (type is NullType) {
      return 'Object?';
    } else if (type is NeverType) {
      return 'Object';
    }

    return 'dynamic';
  }

  /// 注解转字符串
  String _annotationToString(Expression annotation) {
    if (annotation is ConstantExpression) {
      final constant = annotation.constant;
      if (constant is InstanceConstant) {
        final className = constant.classNode.name;
        // 处理 @pragma
        if (className == 'pragma') {
          final nameValue = constant.fieldValues['name'];
          final optionsValue = constant.fieldValues['options'];
          String nameStr = '';
          String optionsStr = '';
          if (nameValue is StringConstant) {
            nameStr = "'${nameValue.value}'";
          }
          if (optionsValue is StringConstant) {
            optionsStr = ", '${optionsValue.value}'";
          } else if (optionsValue is NullConstant || optionsValue == null) {
            optionsStr = '';
          } else if (optionsValue != null) {
            optionsStr = ", ${optionsValue.toString()}";
          }
          return '@pragma($nameStr$optionsStr)';
        }
        // 处理 @override
        if (className == 'override' || className == '_Override') {
          return '@override';
        }
        // 处理 @Deprecated
        if (className == 'Deprecated') {
          final message = constant.fieldValues['message'];
          if (message is StringConstant) {
            return "@Deprecated('${message.value}')";
          }
          return '@Deprecated';
        }
        // 其他注解类型可按需扩展
        return '@$className';
      }
      // 其他常量类型
      return '@${constant.toString()}';
    }
    // 兜底
    return '@${annotation.toString()}';
  }

  /// 构造函数初始化列表
  String _initializerToString(Initializer init) {
    if (init is FieldInitializer) {
      return '${init.field.name.text} = ${_expressionToString(init.value)}';
    }
    if (init is SuperInitializer) {
      return 'super(${init.arguments.positional.map(_expressionToString).join(', ')})';
    }
    if (init is RedirectingInitializer) {
      return 'this.${init.target.name.text}(${init.arguments.positional.map(_expressionToString).join(', ')})';
    }
    return '';
  }

  /// 方法体/表达式体
  void _writeBlockOrExpr(Statement? body) {
    if (body == null) {
      _writeLine(';');
      return;
    }
    if (body is ReturnStatement && body.expression != null) {
      _write('=> ${_expressionToString(body.expression!)};\n');
    } else if (body is ExpressionStatement) {
      _write('=> ${_expressionToString(body.expression)};\n');
    } else if (body is Block) {
      // 保证即使Block为空也输出{}
      _writeLine('{');
      _indent();
      for (final stmt in body.statements) {
        print('DEBUG: 处理 Block 中的语句: ${stmt.runtimeType}');
        _writeTransformedStatement(stmt);
      }
      _unindent();
      _writeLine('}');
    } else {
      _writeLine('{');
      _indent();
      print('DEBUG: 处理单个语句: ${body.runtimeType}');
      _writeTransformedStatement(body);
      _unindent();
      _writeLine('}');
    }
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
      // 对于Block，直接处理其中的语句，不添加额外的花括号
      for (final stmt in statement.statements) {
        _writeTransformedStatement(stmt);
      }
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
      // 调试信息
      print('DEBUG: 处理 ForStatement');
      print('DEBUG: variables.length = ${statement.variables.length}');
      print('DEBUG: condition = ${statement.condition?.runtimeType}');
      print('DEBUG: updates.length = ${statement.updates.length}');

      if (statement.variables.isNotEmpty) {
        final varDecl = statement.variables[0];
        print('DEBUG: varDecl.name = ${varDecl.name}');
        print(
            'DEBUG: varDecl.initializer = ${varDecl.initializer?.runtimeType}');
      }

      if (statement.condition != null) {
        print('DEBUG: condition type = ${statement.condition!.runtimeType}');
        if (statement.condition is InstanceInvocation) {
          final inv = statement.condition as InstanceInvocation;
          print('DEBUG: condition method = ${inv.name.text}');
        }
      }

      if (statement.updates.isNotEmpty) {
        final update = statement.updates[0];
        print('DEBUG: update type = ${update.runtimeType}');
        if (update is VariableSet) {
          print('DEBUG: update variable = ${update.variable.name}');
          print('DEBUG: update value type = ${update.value.runtimeType}');
          if (update.value is InstanceGet) {
            final get = update.value as InstanceGet;
            print('DEBUG: update value name = ${get.name.text}');
          }
        }
      }

      // 检查是否为手写迭代器模式
      if (statement.variables.length == 1 &&
          statement.condition != null &&
          statement.updates.length == 1) {
        final varDecl = statement.variables[0];
        final condition = statement.condition!;
        final update = statement.updates[0];

        // 检查是否为手写迭代器模式
        if (varDecl.name == '_sync_for_iterator' &&
            varDecl.initializer != null &&
            condition is InstanceInvocation &&
            condition.name.text == 'moveNext' &&
            update is VariableSet &&
            update.variable.name == 'entry' &&
            update.value is InstanceGet &&
            (update.value as InstanceGet).name.text == 'current') {
          print('DEBUG: 匹配到手写迭代器模式！');
          // 提取迭代器源
          final iteratorSource = _expressionToString(varDecl.initializer!);
          // 移除 .iterator 后缀
          final iterable = iteratorSource.replaceAll('.iterator', '');

          // 转换为标准 for-in
          _write('for (final entry in $iterable) ');
          _writeTransformedStatement(statement.body);
          return;
        } else {
          print('DEBUG: 不匹配手写迭代器模式');
        }
      } else {
        print('DEBUG: 基本条件不满足');
      }

      // 普通 for 循环
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
      final variable = _cleanVariableName(statement.variable.name ?? 'item');
      final iterable = _expressionToString(statement.iterable);
      _write('for (final $variable in $iterable) ');
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
    } else if (statement is BreakStatement) {
      _writeLine('break;');
    } else if (statement is ContinueSwitchStatement) {
      _writeLine('continue;');
    } else if (statement is LabeledStatement) {
      _writeLine('// TODO: 实现标签语句');
      _writeTransformedStatement(statement.body);
    } else if (statement is EmptyStatement) {
      _writeLine(';');
    } else {
      _writeLine('/* TODO: 实现语句 ${statement.runtimeType} */');
    }
  }

  /// 转换语句，用于运算符重载方法（保持this引用）
  void _writeTransformedStatementForOperator(Statement statement) {
    if (statement is Block) {
      // 对于Block，直接处理其中的语句，不添加额外的花括号
      for (final stmt in statement.statements) {
        _writeTransformedStatementForOperator(stmt);
      }
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

  /// 转换表达式，将this替换为this
  String _expressionToString(Expression expression) {
    if (expression is ThisExpression) {
      return 'this';
    } else if (expression is VariableGet) {
      final originalName = expression.variable.name ?? 'unknown';
      return _cleanVariableName(originalName);
    } else if (expression is VariableSet) {
      final originalName = expression.variable.name ?? 'unknown';
      final cleanName = _cleanVariableName(originalName);
      return '$cleanName = ${_expressionToString(expression.value)}';
    } else if (expression is InstanceGet) {
      final receiver = _expressionToString(expression.receiver);
      final name = expression.name.text;
      // 修正 for-in 伪迭代器 current 访问
      if (name == 'current' && receiver.startsWith('_sync_for_iterator')) {
        return 'entry';
      }
      return '$receiver.$name';
    } else if (expression is InstanceSet) {
      return 'this.${expression.name.text} = ${_expressionToString(expression.value)}';
    } else if (expression is InstanceInvocation) {
      final args = expression.arguments.positional
          .map((e) => _expressionToString(e))
          .join(', ');

      // 处理实例方法调用 - 保持原本形式
      final methodName = expression.interfaceTarget.name.text;
      final receiver = _expressionToString(expression.receiver);

      // 特殊处理运算符调用
      if (methodName == '[]') {
        return '$receiver[$args]';
      } else if (methodName == '[]=') {
        final parts = args.split(', ');
        if (parts.length >= 2) {
          final index = parts[0];
          final value = parts.sublist(1).join(', ');
          return '$receiver[$index] = $value';
        }
        return '$receiver[$args]';
      } else if (methodName == '+' ||
          methodName == '-' ||
          methodName == '*' ||
          methodName == '/' ||
          methodName == '%' ||
          methodName == '&' ||
          methodName == '|' ||
          methodName == '^' ||
          methodName == '<<' ||
          methodName == '>>' ||
          methodName == '>>>' ||
          methodName == '==' ||
          methodName == '!=' ||
          methodName == '<' ||
          methodName == '>' ||
          methodName == '<=' ||
          methodName == '>=') {
        // 保持运算符的原本形式
        return '$receiver $methodName $args';
      } else if (methodName == '~' ||
          methodName == 'unary-' ||
          methodName == 'unary+' ||
          methodName == '!') {
        // 一元运算符
        if (methodName == 'unary-') {
          return '-$receiver';
        } else if (methodName == 'unary+') {
          return '+$receiver';
        } else if (methodName == '!') {
          return '!$receiver';
        } else {
          return '$methodName$receiver';
        }
      } else if (methodName == '++' || methodName == '--') {
        // 自增自减运算符
        return '$receiver$methodName';
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
        // 复合赋值运算符
        return '$receiver $methodName $args';
      } else {
        // 普通方法调用，保持原本形式
        return '$receiver.$methodName($args)';
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
      final originalClassName = expression.target.enclosingClass.name;
      final className =
          _classNameReplacements[originalClassName] ?? originalClassName;

      // 保持构造函数的原本形式
      if (constructorName.isEmpty) {
        // 无名称构造函数
        return '${className}($args)';
      } else {
        // 有名称构造函数
        return '${className}.$constructorName($args)';
      }
    } else if (expression is StaticInvocation) {
      final args = expression.arguments.positional
          .map((e) => _expressionToString(e))
          .join(', ');
      final originalClassName = expression.target.enclosingClass?.name;
      final className = originalClassName != null
          ? (_classNameReplacements[originalClassName] ?? originalClassName)
          : null;
      final methodName = expression.target.name.text;

      // 检查是否为内部函数调用（没有类名的静态调用）
      if (className == null || className.isEmpty) {
        // 对于内部函数调用，使用当前正在处理的类名
        if (_currentClassName != null) {
          return '$_currentClassName.${methodName}($args)';
        } else {
          // 如果无法确定类名，使用默认处理
          return '${methodName}($args)';
        }
      } else {
        // 对于有类名的静态调用，使用完整的类名.方法名格式
        return '$className.${methodName}($args)';
      }
    } else if (expression is LogicalExpression) {
      final left = _expressionToString(expression.left);
      final right = _expressionToString(expression.right);
      final op = _getLogicalOperator(expression.operatorEnum);
      return '$left $op $right';
    } else if (expression is StaticGet) {
      return 'this.${expression.target.name.text}';
    } else if (expression is StaticSet) {
      return 'this.${expression.target.name.text} = ${_expressionToString(expression.value)}';
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
      // Let表达式包含一个变量声明和一个表达式体
      final variable = expression.variable;
      final variableName = _cleanVariableName(variable.name ?? 'var');
      final variableType = _getDartType(variable.type);
      final initializer = variable.initializer != null
          ? ' = ${_expressionToString(variable.initializer!)}'
          : '';
      final body = _expressionToString(expression.body);
      // 简化Let表达式，直接返回变量名或表达式
      if (body == variableName) {
        return variableName;
      } else {
        return body;
      }
    } else if (expression is FunctionInvocation) {
      // 处理函数调用
      final args = expression.arguments.positional
          .map((e) => _expressionToString(e))
          .join(', ');

      // 对于函数调用，我们需要找到函数名
      // 这里我们假设函数调用应该使用当前类的静态方法
      if (_currentClassName != null) {
        return '$_currentClassName.functionInvocation($args)';
      } else {
        return 'functionInvocation($args)';
      }
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
      final c = expression.constant;
      if (c is BoolConstant) return c.value ? 'true' : 'false';
      if (c is IntConstant) return c.value.toString();
      if (c is DoubleConstant) return c.value.toString();
      if (c is StringConstant) return "'${c.value}'";
      if (c is NullConstant) return 'null';
      // 处理List/Map/Set等常量
      if (c is ListConstant) {
        final elems = c.entries
            .map((e) => _expressionToString(ConstantExpression(e)))
            .join(', ');
        return 'const [${elems}]';
      }
      if (c is MapConstant) {
        final entries = c.entries
            .map((e) =>
                '${_expressionToString(ConstantExpression(e.key))}: ${_expressionToString(ConstantExpression(e.value))}')
            .join(', ');
        return 'const {${entries}}';
      }
      if (c is SetConstant) {
        final elems = c.entries
            .map((e) => _expressionToString(ConstantExpression(e)))
            .join(', ');
        return 'const {${elems}}';
      }
      // 兜底
      return c.toString();
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
    } else if (expression is InstanceTearOff) {
      // 处理实例方法引用
      final receiver = _expressionToString(expression.receiver);
      return '$receiver.${expression.name.text}';
    } else if (expression is StaticTearOff) {
      // 处理静态方法引用
      final className = expression.target.enclosingClass?.name ?? '';
      return '$className.${expression.target.name.text}';
    } else if (expression is FunctionTearOff) {
      // 处理函数引用
      return 'function_tearoff';
    } else if (expression is InstanceSet) {
      // 处理实例属性设置
      final receiver = _expressionToString(expression.receiver);
      return '$receiver.${expression.name.text} = ${_expressionToString(expression.value)}';
    } else if (expression is StaticSet) {
      // 处理静态属性设置
      final className = expression.target.enclosingClass?.name ?? '';
      return '$className.${expression.target.name.text} = ${_expressionToString(expression.value)}';
    } else if (expression is InstanceGet) {
      // 处理实例属性获取
      final receiver = _expressionToString(expression.receiver);
      final name = expression.name.text;
      // 修正 for-in 伪迭代器 current 访问
      if (name == 'current' && receiver.startsWith('_sync_for_iterator')) {
        return 'entry';
      }
      return '$receiver.$name';
    } else if (expression is StaticGet) {
      // 处理静态属性获取
      final className = expression.target.enclosingClass?.name ?? '';
      return '$className.${expression.target.name.text}';
    } else if (expression is VariableGet) {
      // 处理变量获取
      final name = expression.variable.name ?? 'var';
      return _cleanVariableName(name);
    } else if (expression is VariableSet) {
      // 处理变量设置
      final name = expression.variable.name ?? 'var';
      final cleanName = _cleanVariableName(name);
      return '$cleanName = ${_expressionToString(expression.value)}';
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
    } else if (expression is LogicalExpression) {
      final left = _expressionToString(expression.left);
      final right = _expressionToString(expression.right);
      final op = _getLogicalOperator(expression.operatorEnum);
      return '$left $op $right';
    } else if (expression is AsExpression) {
      final operand = _expressionToString(expression.operand);
      final type = _getDartType(expression.type);
      return '$operand as $type';
    } else if (expression is IsExpression) {
      final operand = _expressionToString(expression.operand);
      final type = _getDartType(expression.type);
      return '$operand is $type';
    } else if (expression is NullCheck) {
      final operand = _expressionToString(expression.operand);
      return '$operand!';
    } else if (expression is AwaitExpression) {
      final operand = _expressionToString(expression.operand);
      return 'await $operand';
    } else if (expression is StringConcatenation) {
      final expressions =
          expression.expressions.map((e) => _expressionToString(e)).join(' + ');
      return expressions;
    } else if (expression is Throw) {
      final expressionStr = _expressionToString(expression.expression);
      return 'throw $expressionStr';
    } else if (expression is ConstantExpression) {
      return 'const ${expression.constant}';
    } else if (expression is EqualsNull) {
      final operand = _expressionToString(expression.expression);
      return '$operand == null';
    } else if (expression is EqualsCall) {
      final left = _expressionToString(expression.left);
      final right = _expressionToString(expression.right);
      return '$left == $right';
    } else if (expression is FunctionExpression) {
      final function = expression.function;
      final parameters = function.positionalParameters
          .map((p) =>
              '${_getDartType(p.type)} ${_cleanVariableName(p.name ?? 'param')}')
          .join(', ');
      final returnType = _getDartType(function.returnType);
      return '($parameters) { /* TODO: 实现匿名函数 */ return null as $returnType; }';
    } else if (expression is BlockExpression) {
      final statements = expression.body.statements
          .map((s) => _writeTransformedStatementToString(s))
          .join('\n    ');
      return '(() {\n    $statements\n    return null;\n  })()';
    } else if (expression is LocalFunctionInvocation) {
      final args = expression.arguments.positional
          .map((e) => _expressionToString(e))
          .join(', ');
      return '${expression.name.text}($args)';
    } else if (expression is RecordLiteral) {
      final fields =
          expression.positional.map((f) => _expressionToString(f)).join(', ');
      return '($fields)';
    } else if (expression is TypeLiteral) {
      return _getDartType(expression.type);
    } else if (expression is RecordNameGet) {
      final record = _expressionToString(expression.receiver);
      return '$record.${expression.name}';
    } else if (expression is Let) {
      final variable = expression.variable;
      final variableName = _cleanVariableName(variable.name ?? 'var');
      final body = _expressionToString(expression.body);
      if (body == variableName) {
        return variableName;
      } else {
        return body;
      }
    } else if (expression is FunctionInvocation) {
      final args = expression.arguments.positional
          .map((e) => _expressionToString(e))
          .join(', ');
      if (_currentClassName != null) {
        return '$_currentClassName.functionInvocation($args)';
      } else {
        return 'functionInvocation($args)';
      }
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
      final receiver = _expressionToString(expression.receiver);
      final name = expression.name.text;
      // 修正 for-in 伪迭代器 current 访问
      if (name == 'current' && receiver.startsWith('_sync_for_iterator')) {
        return 'entry';
      }
      return '$receiver.$name';
    } else if (expression is InstanceSet) {
      return 'this.${expression.name.text} = ${_expressionToStringForOperator(expression.value)}';
    } else if (expression is InstanceInvocation) {
      final args = expression.arguments.positional
          .map((e) => _expressionToStringForOperator(e))
          .join(', ');

      // 处理实例方法调用 - 保持原本形式
      final methodName = expression.interfaceTarget.name.text;
      final receiver = _expressionToStringForOperator(expression.receiver);

      // 特殊处理运算符调用
      if (methodName == '[]') {
        return '$receiver[$args]';
      } else if (methodName == '[]=') {
        final parts = args.split(', ');
        if (parts.length >= 2) {
          final index = parts[0];
          final value = parts.sublist(1).join(', ');
          return '$receiver[$index] = $value';
        }
        return '$receiver[$args]';
      } else if (methodName == '+' ||
          methodName == '-' ||
          methodName == '*' ||
          methodName == '/' ||
          methodName == '%' ||
          methodName == '&' ||
          methodName == '|' ||
          methodName == '^' ||
          methodName == '<<' ||
          methodName == '>>' ||
          methodName == '>>>' ||
          methodName == '==' ||
          methodName == '!=' ||
          methodName == '<' ||
          methodName == '>' ||
          methodName == '<=' ||
          methodName == '>=') {
        // 保持运算符的原本形式
        return '$receiver $methodName $args';
      } else if (methodName == '~' ||
          methodName == 'unary-' ||
          methodName == 'unary+' ||
          methodName == '!') {
        // 一元运算符
        if (methodName == 'unary-') {
          return '-$receiver';
        } else if (methodName == 'unary+') {
          return '+$receiver';
        } else if (methodName == '!') {
          return '!$receiver';
        } else {
          return '$methodName$receiver';
        }
      } else if (methodName == '++' || methodName == '--') {
        // 自增自减运算符
        return '$receiver$methodName';
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
        // 复合赋值运算符
        return '$receiver $methodName $args';
      } else {
        // 普通方法调用，保持原本形式
        return '$receiver.$methodName($args)';
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
      final originalClassName = expression.target.enclosingClass.name;
      final className =
          _classNameReplacements[originalClassName] ?? originalClassName;

      // 保持构造函数的原本形式
      if (constructorName.isEmpty) {
        // 无名称构造函数
        return '${className}($args)';
      } else {
        // 有名称构造函数
        return '${className}.$constructorName($args)';
      }
    } else if (expression is StaticInvocation) {
      final args = expression.arguments.positional
          .map((e) => _expressionToStringForOperator(e))
          .join(', ');
      final originalClassName = expression.target.enclosingClass?.name;
      final className = originalClassName != null
          ? (_classNameReplacements[originalClassName] ?? originalClassName)
          : null;
      final methodName = expression.target.name.text;

      // 检查是否为内部函数调用（没有类名的静态调用）
      if (className == null || className.isEmpty) {
        // 对于内部函数调用，使用当前正在处理的类名
        if (_currentClassName != null) {
          return '$_currentClassName.${methodName}($args)';
        } else {
          // 如果无法确定类名，使用默认处理
          return '${methodName}($args)';
        }
      } else {
        // 对于有类名的静态调用，使用完整的类名.方法名格式
        return '$className.${methodName}($args)';
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
    } else if (expression is Let) {
      // 处理Let表达式
      // Let表达式包含一个变量声明和一个表达式体
      final variable = expression.variable;
      final variableName = _cleanVariableName(variable.name ?? 'var');
      final variableType = _getDartType(variable.type);
      final initializer = variable.initializer != null
          ? ' = ${_expressionToStringForOperator(variable.initializer!)}'
          : '';
      final body = _expressionToStringForOperator(expression.body);
      return '(() { $variableType $variableName$initializer; return $body; })()';
    } else if (expression is FunctionInvocation) {
      // 处理函数调用
      final args = expression.arguments.positional
          .map((e) => _expressionToStringForOperator(e))
          .join(', ');

      // 对于函数调用，我们需要找到函数名
      // 这里我们假设函数调用应该使用当前类的静态方法
      if (_currentClassName != null) {
        return '$_currentClassName.functionInvocation($args)';
      } else {
        return 'functionInvocation($args)';
      }
    } else if (expression is AsExpression) {
      // 处理类型转换
      final operand = _expressionToStringForOperator(expression.operand);
      final type = _getDartType(expression.type);
      return '$operand as $type';
    } else if (expression is IsExpression) {
      // 处理类型判断表达式
      final operand = _expressionToStringForOperator(expression.operand);
      final type = _getDartType(expression.type);
      return '$operand is $type';
    } else if (expression is NullCheck) {
      // 处理空安全断言表达式
      final operand = _expressionToStringForOperator(expression.operand);
      return '$operand!';
    } else if (expression is AwaitExpression) {
      // 处理await表达式
      final operand = _expressionToStringForOperator(expression.operand);
      return 'await $operand';
    } else if (expression is StringConcatenation) {
      // 处理字符串连接
      final expressions = expression.expressions
          .map((e) => _expressionToStringForOperator(e))
          .join(' + ');
      return expressions;
    } else if (expression is Throw) {
      // 处理抛出异常
      final expressionStr =
          _expressionToStringForOperator(expression.expression);
      return 'throw $expressionStr';
    } else if (expression is ConstantExpression) {
      // 处理常量表达式
      final c = expression.constant;
      if (c is BoolConstant) return c.value ? 'true' : 'false';
      if (c is IntConstant) return c.value.toString();
      if (c is DoubleConstant) return c.value.toString();
      if (c is StringConstant) return "'${c.value}'";
      if (c is NullConstant) return 'null';
      // 处理List/Map/Set等常量
      if (c is ListConstant) {
        final elems = c.entries
            .map((e) => _expressionToStringForOperator(ConstantExpression(e)))
            .join(', ');
        return 'const [${elems}]';
      }
      if (c is MapConstant) {
        final entries = c.entries
            .map((e) =>
                '${_expressionToStringForOperator(ConstantExpression(e.key))}: ${_expressionToStringForOperator(ConstantExpression(e.value))}')
            .join(', ');
        return 'const {${entries}}';
      }
      if (c is SetConstant) {
        final elems = c.entries
            .map((e) => _expressionToStringForOperator(ConstantExpression(e)))
            .join(', ');
        return 'const {${elems}}';
      }
      // 兜底
      return c.toString();
    } else if (expression is EqualsNull) {
      // 处理空值检查
      final operand = _expressionToStringForOperator(expression.expression);
      return '$operand == null';
    } else if (expression is EqualsCall) {
      // 处理相等性调用
      final left = _expressionToStringForOperator(expression.left);
      final right = _expressionToStringForOperator(expression.right);
      return '$left == $right';
    } else if (expression is FunctionExpression) {
      // 处理匿名函数/闭包表达式
      final function = expression.function;
      final parameters = function.positionalParameters
          .map((p) =>
              '${_getDartType(p.type)} ${_cleanVariableName(p.name ?? 'param')}')
          .join(', ');
      final returnType = _getDartType(function.returnType);
      return '($parameters) { /* TODO: 实现匿名函数 */ return null as $returnType; }';
    } else if (expression is BlockExpression) {
      // 处理块表达式
      final statements = expression.body.statements
          .map((s) => _writeTransformedStatementToString(s))
          .join('\n    ');
      return '(() {\n    $statements\n    return null;\n  })()';
    } else if (expression is LocalFunctionInvocation) {
      // 处理局部函数调用
      final args = expression.arguments.positional
          .map((e) => _expressionToStringForOperator(e))
          .join(', ');
      return '${expression.name.text}($args)';
    } else if (expression is RecordLiteral) {
      // 处理记录字面量
      final fields = expression.positional
          .map((f) => _expressionToStringForOperator(f))
          .join(', ');
      return '($fields)';
    } else if (expression is TypeLiteral) {
      // 处理类型字面量
      return _getDartType(expression.type);
    } else if (expression is RecordNameGet) {
      // 处理记录字段访问
      final record = _expressionToStringForOperator(expression.receiver);
      return '$record.${expression.name}';
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
