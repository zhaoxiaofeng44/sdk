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

    // 收集静态方法
    for (final procedure in cls.procedures) {
      if (procedure.isStatic &&
          !procedure.isAbstract &&
          !procedure.isFactory &&
          !procedure.isGetter &&
          !procedure.isSetter) {
        classInfo.staticMethods.add(procedure);
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
      if (_classNameReplacements.containsKey(superName)) {
        superName = _classNameReplacements[superName]!;
      }
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
      } else if (!procedure.isStatic && !procedure.isFactory) {
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
      print(
          'Static methods for ${cls.name}: ${classInfo.staticMethods.length}');
      for (final procedure in classInfo.staticMethods) {
        print('Generating static method: ${procedure.name.text}');
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

    if (procedure.isAbstract) {
      // 抽象getter没有方法体
      _writeLine('$returnType get $name;');
      _writeLine('');
    } else {
      // 具体getter有方法体
      _writeLine('$returnType get $name {');
      _indent();
      if (procedure.function.body != null) {
        final bodyStr =
            _writeTransformedStatementToString(procedure.function.body!);
        _writeLine(bodyStr);
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
    // 不使用字符串替换，而是检查是否以 = 结尾
    final name = procedure.name.text.endsWith('=')
        ? procedure.name.text.substring(0, procedure.name.text.length - 1)
        : procedure.name.text;

    if (procedure.isAbstract) {
      // 抽象setter没有方法体
      _writeLine('set $name($paramType $paramName);');
      _writeLine('');
    } else {
      // 具体setter有方法体
      _writeLine('set $name($paramType $paramName) {');
      _indent();
      final bodyStr =
          _writeTransformedStatementToString(procedure.function.body!);
      _writeLine(bodyStr);
      _unindent();
      _writeLine('}');
      _writeLine('');
    }
  }

  /// 生成 getter 方法体
  String _generateGetterBody(FunctionNode function) {
    if (function.body != null) {
      // 对于getter，我们需要表达式而不是语句
      if (function.body is ReturnStatement) {
        final returnStmt = function.body as ReturnStatement;
        if (returnStmt.expression != null) {
          return _generateExpressionCode(returnStmt.expression!,
              replaceThis: true, asStatement: false);
        }
      } else if (function.body is Expression) {
        // 如果不是ReturnStatement，尝试作为表达式处理
        return _generateExpressionCode(function.body as Expression,
            replaceThis: true, asStatement: false);
      }
    }
    return 'null'; // 默认返回值
  }

  /// 将语句转换为字符串
  String _statementToString(Statement statement) {
    return _generateStatementCode(statement,
        replaceThis: false, allowReturn: true);
  }

  /// 将语句转换为字符串（转换后）
  String _writeTransformedStatementToString(Statement statement) {
    return _generateStatementCode(statement,
        replaceThis: true, allowReturn: true);
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

    // 处理范型参数
    String methodName = name;
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
        final bodyStr =
            _writeTransformedStatementToString(procedure.function.body!);
        _writeLine(bodyStr);
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
    final parameters =
        _writeParameterList(procedure.function.positionalParameters);
    _writeLine('static $returnType $name($parameters) {');
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
      // 检查是否是运算符方法
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
      final bodyStr = _generateStatementCode(procedure.function.body!,
          replaceThis: false, allowReturn: true);
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
    String baseType;

    if (type is DynamicType) {
      baseType = 'Object';
    } else if (type is InterfaceType) {
      String typeName = type.classNode.name;
      // 处理范型参数
      if (type.typeArguments.isNotEmpty) {
        final typeArgs =
            type.typeArguments.map((t) => _getDartType(t)).join(', ');
        typeName += '<$typeArgs>';
      }
      baseType = typeName;
    } else if (type is FunctionType) {
      // 正确处理函数类型
      final paramTypes = type.positionalParameters
          .map((param) => _getDartType(param))
          .join(', ');
      final returnType = _getDartType(type.returnType);
      baseType = '$returnType Function($paramTypes)';
    } else if (type is TypeParameterType) {
      // 对于类型参数，我们应该保持类型参数名称
      // 但确保它们是有效的类型名称
      final paramName = type.parameter.name;
      if (paramName != null && paramName.isNotEmpty) {
        // 检查是否是有效的类型名称（单字母类型参数）
        if (paramName.length == 1 &&
            paramName.codeUnitAt(0) >= 65 &&
            paramName.codeUnitAt(0) <= 90) {
          baseType = paramName; // 单字母大写类型参数（如 E、T、R）
        } else {
          baseType = 'Object';
        }
      } else {
        baseType = 'Object';
      }
    } else if (type is VoidType) {
      baseType = 'void';
    } else {
      baseType = 'Object';
    }

    // 处理可空类型
    if (type.nullability == Nullability.nullable) {
      // void 类型不能是可空的
      if (baseType == 'void') {
        return 'void';
      }
      return '$baseType?';
    }

    return baseType;
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

  /// 生成唯一ID
  int _generateUniqueId() {
    return DateTime.now().microsecondsSinceEpoch % 1000000;
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
    // 正确处理函数类型
    final paramTypes = type.positionalParameters
        .map((param) => _getDartType(param))
        .join(', ');
    final returnType = _getDartType(type.returnType);
    return '$returnType Function($paramTypes)';
  } else if (type is TypeParameterType) {
    // 保持范型类型参数名称
    return type.parameter.name ?? 'Object';
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
    {bool replaceThis = false,
    bool asStatement = false,
    bool allowReturn = true}) {
  print('expression: $expression');
  if (expression is ThisExpression) {
    return replaceThis ? 'this' : 'this';
  } else if (expression is VariableGet) {
    // 获取变量类型信息
    //final type = _getDartType(expression.variable.type);
    final name = _cleanVariableName(expression.variable.name ?? 'unnamed');
    // 如果类型不是 Object，则包含类型信息
    // if (type != 'Object') {
    //   return '($name as $type)';
    // }
    return name;
  } else if (expression is VariableGetImpl) {
    // 获取变量类型信息
    // final type = _getDartType(expression.variable.type);
    final name = _cleanVariableName(expression.variable.name ?? 'unnamed');
    // // 如果类型不是 Object，则包含类型信息
    // if (type != 'Object') {
    //   return '($name as $type)';
    // }
    return name;
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
    return '$receiver.$name';
  } else if (expression is InstanceGet) {
    final receiver = _generateExpressionCode(expression.receiver,
        replaceThis: replaceThis, asStatement: false);
    final propertyName = expression.name.text;
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

    // 处理参数，根据目标方法的参数类型要求进行类型转换
    final processedArgs = <String>[];

    // 处理位置参数
    for (int i = 0; i < argsList.length; i++) {
      final arg = argsList[i];
      final argCode = _generateExpressionCode(arg,
          replaceThis: replaceThis, asStatement: false);

      // 如果是 cppSetPointerArrayItem 的最后一个参数，需要转换为 Object
      if (name == 'cppSetPointerArrayItem' && i == 2) {
        processedArgs.add('($argCode as Object)');
      } else {
        processedArgs.add(argCode);
      }
    }

    // 处理命名参数
    final namedArgs = expression.arguments.named
        .map((na) =>
            '${na.name}: ${_generateExpressionCode(na.value, replaceThis: replaceThis, asStatement: false)}')
        .toList();

    final allArgs = [...processedArgs, ...namedArgs].join(', ');

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

    // 特殊处理 cppSetPointerArrayItem 调用，确保参数类型正确
    if (name == 'cppSetPointerArrayItem') {
      // 在AST层面处理类型转换，而不是字符串替换
      // 这里我们需要分析参数的类型信息，并在生成代码时进行适当的类型转换
      return '$receiver.$name($allArgs)';
    }

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
    // 生成正确的函数表达式语法
    final parameters = expression.function.positionalParameters
        .map((p) =>
            '${_getDartType(p.type)} ${_cleanVariableName(p.name ?? 'param')}')
        .join(', ');
    final body = expression.function.body != null
        ? _generateStatementCode(expression.function.body!,
            replaceThis: replaceThis, allowReturn: true)
        : '{}';
    return '($parameters) => $body';
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
    final typeArgs = expression.typeArguments.isNotEmpty
        ? '<${expression.typeArguments.map(_getDartType).join(', ')}>'
        : '';
    final fields = expression.fieldValues.entries
        .map((e) =>
            '${e.key.asField.name}: ${_generateExpressionCode(e.value, replaceThis: replaceThis, asStatement: false)}')
        .join(', ');
    return '$className$typeArgs{$fields}';
  } else if (expression is Not) {
    return '!(${_generateExpressionCode(expression.operand, replaceThis: replaceThis, asStatement: false)})';
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
  } else if (expression is AuxiliaryExpression) {
    // 根据AuxiliaryExpression的具体类型进行处理
    if (expression is BinaryExpression) {
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
      if (opName == '!=' || opName == '.!=') return '$left != $right';
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
      // 对于否定操作符，需要给表达式加括号以避免优先级问题
      if (op == '!') {
        return '$op($expr)';
      }
      return '$op$expr';
    } else if (expression is ParenthesizedExpression) {
      return '(${_generateExpressionCode(expression.expression, replaceThis: replaceThis, asStatement: false)})';
    } else if (expression is MethodInvocation) {
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
      return '$receiver.$name($allArgs)';
    } else if (expression is PropertyGet) {
      final receiver = _generateExpressionCode(expression.receiver,
          replaceThis: replaceThis, asStatement: false);
      final name = expression.name.text;
      return '$receiver.$name';
    } else if (expression is PropertySet) {
      final receiver = _generateExpressionCode(expression.receiver,
          replaceThis: replaceThis, asStatement: false);
      final name = expression.name.text;
      final value = _generateExpressionCode(expression.value,
          replaceThis: replaceThis, asStatement: false);
      return '$receiver.$name = $value';
    } else if (expression is IndexGet) {
      final receiver = _generateExpressionCode(expression.receiver,
          replaceThis: replaceThis, asStatement: false);
      final index = _generateExpressionCode(expression.index,
          replaceThis: replaceThis, asStatement: false);
      return '$receiver[$index]';
    } else if (expression is IndexSet) {
      final receiver = _generateExpressionCode(expression.receiver,
          replaceThis: replaceThis, asStatement: false);
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
    } else {
      // 对于其他未知的AuxiliaryExpression类型，返回占位符
      return '/* auxiliary expression */';
    }
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
    return '$receiver.$name($allArgs)';
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
  } else if (expression is FileUriExpression) {
    final expr = _generateExpressionCode(expression.expression,
        replaceThis: replaceThis, asStatement: false);
    return '/* file: ${expression.fileUri} */ $expr';
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
    // 为嵌套的 Let 表达式生成唯一的变量名
    final baseName = _cleanVariableName(expression.variable.name ?? 'temp');
    // 使用更简单的变量名生成策略，避免嵌套冲突
    final variable =
        '${baseName}_${DateTime.now().microsecondsSinceEpoch % 1000000}';
    final value = _generateExpressionCode(expression.variable.initializer!,
        replaceThis: replaceThis, allowReturn: false);

    // 在生成 body 之前，记录当前变量名映射
    final originalVariableName = expression.variable.name ?? 'temp';
    final variableMapping = <String, String>{originalVariableName: variable};

    // 生成 body，并替换其中的变量引用
    String body = _generateExpressionCode(expression.body,
        replaceThis: replaceThis, asStatement: false, allowReturn: false);

    final type = _getDartType(expression.variable.type);

    // 替换 body 中的变量引用
    for (final entry in variableMapping.entries) {
      final originalName = entry.key;
      final newName = entry.value;
      // 使用正则表达式替换变量引用，确保只替换完整的变量名
      body = body.replaceAll(
          RegExp(r'\b' + RegExp.escape(originalName) + r'\b'), newName);
    }

    // // 如果变量类型是泛型类型参数，需要转换为 Object
    // if (type != 'Object' &&
    //     type.length == 1 &&
    //     type.codeUnitAt(0) >= 65 &&
    //     type.codeUnitAt(0) <= 90) {
    //   // 单字母大写类型参数（如 E、T、R），需要转换为 Object
    //   body = body.replaceAll(RegExp(r'\b' + RegExp.escape(variable) + r'\b'),
    //       '($variable as Object)');
    // }

    // 如果 value 是泛型类型参数，也需要转换为 Object
    // if (value.contains('value') &&
    //     type != 'Object' &&
    //     type.length == 1 &&
    //     type.codeUnitAt(0) >= 65 &&
    //     type.codeUnitAt(0) <= 90) {
    //   body = body.replaceAll(RegExp(r'\bvalue\b'), '(value as Object)');
    // }

    // 表达式上下文，用 IIFE 包裹，确保只生成单一表达式
    return '(() { final $type $variable = $value; return $body; })()';
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
      final value = constant.value;
      final escaped = value
          .replaceAll('\\', '\\\\')
          .replaceAll('"', '\\"')
          .replaceAll('\n', '\\n')
          .replaceAll('\r', '\\r')
          .replaceAll('\t', '\\t');
      return '"$escaped"';
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
      return '($all)';
    } else if (constant is SetConstant) {
      final entries = constant.entries
          .map((e) => _generateExpressionCode(ConstantExpression(e),
              replaceThis: replaceThis, asStatement: false))
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
    String className = expression.target.enclosingClass.name;
    // 处理范型参数 - 使用当前上下文的范型参数
    if (expression.target.enclosingClass.typeParameters.isNotEmpty) {
      // 这里需要根据当前上下文来确定范型参数
      // 暂时使用类定义的范型参数，但需要改进
      final typeArgs = expression.target.enclosingClass.typeParameters
          .map((t) => t.name ?? 'Object')
          .join(', ');
      className += '<$typeArgs>';
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
    return 'new $className($allArgs)';
  } else if (expression is FactoryConstructorInvocation) {
    final className = expression.target.enclosingClass?.name ?? 'Unknown';
    final args = expression.arguments.positional
        .map((e) => _generateExpressionCode(e,
            replaceThis: replaceThis, asStatement: false))
        .join(', ');
    final namedArgs = expression.arguments.named
        .map((na) =>
            '${na.name}: ${_generateExpressionCode(na.value, replaceThis: replaceThis, asStatement: false)}')
        .join(', ');
    final allArgs = [args, namedArgs].where((s) => s.isNotEmpty).join(', ');
    return 'new $className($allArgs)';
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
    // 使用正确的字符串转义，不使用字符串替换
    final value = expression.value;
    final escaped = value
        .replaceAll('\\', '\\\\')
        .replaceAll('"', '\\"')
        .replaceAll('\n', '\\n')
        .replaceAll('\r', '\\r')
        .replaceAll('\t', '\\t');
    return '"$escaped"';
  } else if (expression is SwitchExpression) {
    final switchExpr = _generateExpressionCode(expression.expression,
        replaceThis: replaceThis, asStatement: false);
    final cases = expression.cases
        .map((c) => _generateSwitchExpressionCase(c, replaceThis))
        .join(', ');
    return 'switch ($switchExpr) { $cases }';
  } else {
    return expression.toString();
  }
}

String _generateStatementCode(Statement statement,
    {bool replaceThis = false, bool allowReturn = true}) {
  print('expression: $statement');
  if (statement is ReturnStatement) {
    if (!allowReturn) {
      // 如果不允许return，则只返回表达式部分
      if (statement.expression != null) {
        return _generateExpressionCode(statement.expression!,
            replaceThis: replaceThis, asStatement: false, allowReturn: false);
      } else {
        return 'null';
      }
    }
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
    // 避免重复的 return/throw 关键字
    if (expr.startsWith('return ') || expr.startsWith('throw ')) {
      return expr;
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

    final body = _generateStatementCode(statement.body,
        replaceThis: replaceThis, allowReturn: true);

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
    // BreakStatement的target是LabeledStatement，需要通过printer获取标签名
    final label = statement.target != null ? 'label' : null;
    return label != null ? 'break $label;' : 'break;';
  } else if (statement is ContinueSwitchStatement) {
    // ContinueSwitchStatement的target是LabeledStatement，需要通过printer获取标签名
    final label = statement.target != null ? 'label' : null;
    return label != null ? 'continue $label;' : 'continue;';
  } else if (statement is LabeledStatement) {
    // LabeledStatement没有直接的label属性，需要通过printer获取
    final label = 'label'; // 使用默认标签名
    final body = _generateStatementCode(statement.body,
        replaceThis: replaceThis, allowReturn: true);
    return '$label: $body';
  } else if (statement is AssertStatement) {
    final condition = _generateExpressionCode(statement.condition,
        replaceThis: replaceThis, asStatement: false);
    final message = statement.message != null
        ? ': ${_generateExpressionCode(statement.message!, replaceThis: replaceThis, asStatement: false)}'
        : '';
    return 'assert $condition$message;';
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
    final patternGuard = statement.patternGuard != null
        ? ' when ${statement.patternGuard.toString()}' // PatternGuard不是Expression类型
        : '';
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
      return '@override\noperator $name($parameters) {\n  ${_generateStatementCode(member.function.body!, replaceThis: replaceThis, allowReturn: true)}\n}';
    } else {
      return '$returnType $name($parameters) {\n  ${_generateStatementCode(member.function.body!, replaceThis: replaceThis, allowReturn: true)}\n}';
    }
  }
  return '// ${member.runtimeType}';
}
