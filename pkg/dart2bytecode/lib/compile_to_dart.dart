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
  // 保留占位，未来可能用于需要上下文返回类型场景（目前未使用）
  // ignore: unused_field
  DartType? _currentFunctionReturnType;

  // 存储转换后的类信息
  final Map<Class, ClassInfo> _classInfoMap = {};

  // 当前正在处理的类名（已移除未使用字段）

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

  /// 判断是否应该跳过某个库
  bool _shouldSkipLibrary(Library library) {
    final libraryUri = library.fileUri;
    final filePath =
        libraryUri.isScheme('file') ? libraryUri.path : libraryUri.toString();

    final libraryName = library.toStringInternal();
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
  // 已移除未使用方法 _debugPrintAnnotations

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

    // 生成全局函数和变量
    for (final library in component.libraries) {
      if (!_shouldSkipLibrary(library)) {
        _generateGlobalMembersFromLibrary(library);
      }
    }
  }

  /// 写入库导入
  void _writeLibraryImports(Component component) {
    // 添加基本的导入
    _writeLine("import 'dart:core';");
    _writeLine("import 'dart:io';");
    _writeLine("import 'dart:math';");
    _writeLine("import 'dart:typed_data';");
    _writeLine('');

    // 添加全局Void类型变量
    _writeLine("/// 全局Void类型变量，用于替代void返回值");
    _writeLine("final Void = null;");
    _writeLine('');
  }

  /// 生成转换后的类
  void _generateTransformedClass(Class cls) {
    // 设置当前类名（已移除未使用字段）
    // 标记当前 emitting 类名（用于在构造调用时补齐类型参数）
    // 此处仅为可读性保留调用，实际使用的是下方的 className
    /* final currentClassName = */ _getCppPatchPragma(cls) ?? cls.name;
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

        // 对于没有初始化器的非空字段，添加 late 以避免编译期未初始化错误（含静态/实例）
        if (!field.isLate &&
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
    final name = constructor.name.text;
    final constructorName = name.isEmpty ? cls.name : '${cls.name}.$name';

    // 参数列表（包含必需位置、可选位置与命名参数，正确分组 [] / {}）
    final parameters = _writeParametersToString(constructor.function);

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
    return _generateStatementCode(statement,
        replaceThis: true, allowReturn: true);
  }

  // 已移除未使用方法 _writeTransformedStatement

  /// 生成单个成员方法
  void _generateMemberMethod(Procedure procedure) {
    final returnType = _getDartType(procedure.function.returnType);
    final name = procedure.name.text;
    final parameters = _writeParametersToString(procedure.function);

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

    // 处理范型参数
    String methodName = name;
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
    if (name.isEmpty) {
      factoryName = cls.name;
    } else {
      factoryName = '${cls.name}.$name';
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
  }

  /// 生成全局函数
  void _generateGlobalFunction(Procedure procedure) {
    final returnType = _getDartType(procedure.function.returnType);
    final name = procedure.name.text;
    final parameters = _writeParametersToString(procedure.function);

    // 处理范型参数
    String methodName = name;
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

    // 对于没有初始化器的非空字段，添加 late 以避免编译期未初始化错误
    if (!field.isLate &&
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
    _writeLine('');
  }

  /// 生成操作符方法
  void _generateOperatorMethod(Procedure procedure) {
    final returnType = _getDartType(procedure.function.returnType);
    final op = procedure.name.text;
    final parameters = _writeParametersToString(procedure.function);
    _writeLine('$returnType operator $op($parameters) {');
    _indent();
    if (procedure.function.body != null) {
      final bodyStr = _generateStatementCode(procedure.function.body!,
          replaceThis: false, allowReturn: true);
      _writeLine(_normalizeBody(bodyStr, isVoid: returnType.trim() == 'void'));
    }
    _unindent();
    _writeLine('}');
    _writeLine('');
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
      String defaultValue = '';
      if (param.initializer != null) {
        defaultValue =
            ' = ${_generateExpressionCode(param.initializer!, replaceThis: false, asStatement: false)}';
      }
      return '$type $name$defaultValue';
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
        String defaultValue = '';
        if (param.initializer != null) {
          defaultValue =
              ' = ${_generateExpressionCode(param.initializer!, replaceThis: false, asStatement: false)}';
        }
        return '$type $name$defaultValue';
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
    String baseType;

    if (type is DynamicType) {
      baseType = 'dynamic';
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
      // 对于类型参数，直接使用其名称（允许多字符名称如 RK、RV、K2、V2）
      final paramName = type.parameter.name;
      baseType =
          (paramName != null && paramName.isNotEmpty) ? paramName : 'Object';
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

  // 已移除未使用方法 _generateUniqueId

  /// 转换表达式，将this替换为self
  String _expressionToString(Expression expression) {
    return _generateExpressionCode(expression,
        replaceThis: true, asStatement: false);
  }

  // 已移除未使用方法 _expressionToStringForOperator

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
      final outputFile = File(
          '/Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/transformed_dart.dart');
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
final Map<String, int> _usedNamesAtPosition = {};

// 基于源位置和变量声明生成作用域内唯一的临时变量名
String _uniqueLocalNameForNode(String suggestedBase, TreeNode node) {
  final base = _cleanVariableName(
      (suggestedBase.isEmpty || suggestedBase == 'unnamed')
          ? 'temp'
          : suggestedBase);
  final offset = node.fileOffset;
  if (offset != null && offset >= 0) {
    return '${base}_${offset}';
  }
  final fallback = DateTime.now().microsecondsSinceEpoch % 1000000;
  return '${base}_${fallback}';
}

// 为Let表达式中的变量生成唯一的变量名，确保在嵌套Let表达式中不会冲突
String _generateUniqueLetVarName(
    VariableDeclaration variable, Expression letExpression) {
  final baseName = variable.name ?? 'temp';
  final cleanBase = _cleanVariableName(baseName);

  // 使用Let表达式的位置信息和变量本身的信息来生成唯一标识符
  final offset = letExpression.fileOffset;
  final varId = variable.hashCode.abs() % 10000;

  if (offset != null && offset >= 0) {
    // 组合位置信息和变量ID来确保即使在同一位置的嵌套Let表达式也有唯一名称
    final baseKey = '${cleanBase}_${offset}_${varId}';
    return baseKey;
  }

  // 如果没有位置信息，使用变量的哈希值作为后缀
  return '${cleanBase}_${varId}';
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
  String baseType;

  if (type is DynamicType) {
    baseType = 'dynamic';
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
    // 直接使用类型参数名称（允许多字符：如 RK、RV、K2、V2）
    final paramName = type.parameter.name;
    baseType =
        (paramName != null && paramName.isNotEmpty) ? paramName : 'Object';
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

/// 全局版本的获取逻辑运算符函数
String _getLogicalOperator(LogicalExpressionOperator operator) {
  switch (operator) {
    case LogicalExpressionOperator.AND:
      return '&&';
    case LogicalExpressionOperator.OR:
      return '||';
  }
}

// 已移除未使用方法 _getUnaryOperator

/// 检查是否为数字字面量
bool _isNumericLiteral(String expr) {
  // 移除可能的括号
  final cleanExpr = expr.trim().replaceAll(RegExp(r'^\(|\)$'), '');
  // 检查是否为整数或浮点数
  return RegExp(r'^-?\d+(\.\d+)?$').hasMatch(cleanExpr);
}

// 已移除未使用方法 _getBinaryOperator

String _generateExpressionCode(Expression expression,
    {bool replaceThis = false,
    bool asStatement = false,
    bool allowReturn = true}) {
  return //"/*${expression.runtimeType}*/" +
      _generateExpressionCode2(expression,
          replaceThis: replaceThis,
          asStatement: asStatement,
          allowReturn: allowReturn);
}

String _generateExpressionCode2(Expression expression,
    {bool replaceThis = false,
    bool asStatement = false,
    bool allowReturn = true}) {
  print('expression: $expression');
  if (expression is ThisExpression) {
    return replaceThis ? 'this' : 'this';
  } else if (expression is VariableGet) {
    // 获取变量类型信息
    //final type = _getDartType(expression.variable.type);
    final alias = _letAliasNames[expression.variable];
    if (alias != null) return alias;
    final name = _cleanVariableName(expression.variable.name ?? 'unnamed');
    // 如果类型不是 Object，则包含类型信息
    // if (type != 'Object') {
    //   return '($name as $type)';
    // }
    return name;
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
    String className = expression.target.enclosingClass?.name ?? 'Unknown';
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
    final name = expression.target.name.text;
    return encl == null ? name : '${encl.name}.$name';
  } else if (expression is StaticSet) {
    final encl = expression.target.enclosingClass;
    final name = expression.target.name.text;
    final value = _generateExpressionCode(expression.value,
        replaceThis: replaceThis, asStatement: false);
    return encl == null ? '$name = $value' : '${encl.name}.$name = $value';
  } else if (expression is StaticTearOff) {
    final encl = expression.target.enclosingClass;
    final name = expression.target.name.text;
    return encl == null ? name : '${encl.name}.$name';
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
    return '$receiver.$name($allArgs)';
  } else if (expression is ConstructorInvocation) {
    String className = expression.target.enclosingClass.name;
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
      // 避免使用外部库的私有命名构造（如 MapEntry._），改用公有默认构造
      final ctorName = expression.target.name.text;
      if (!ctorName.startsWith('_')) {
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
    // 生成正确的函数表达式语法
    final parameters = expression.function.positionalParameters
        .map((p) =>
            '${_getDartType(p.type)} ${_cleanVariableName(p.name ?? 'param')}')
        .join(', ');
    final body = expression.function.body != null
        ? _generateStatementCode(expression.function.body!,
            replaceThis: replaceThis, allowReturn: true)
        : '{}';
    return '($parameters) { $body}';
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
      return '(${code}).toString()';
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
    // 优化 Let 模式，尽量消除 IIFE：
    // 场景1：body 形如 (v == null ? a : v) -> 生成 (init ?? a)
    final varName = expression.variable.name ?? 'temp';
    final initializerCode = _generateExpressionCode(
        expression.variable.initializer!,
        replaceThis: replaceThis,
        allowReturn: false);

    // 如果 Let 绑定的变量类型为 void，则无需声明该变量。
    // 直接顺序执行初始化表达式，然后返回 body 的值。
    String varType = _getDartType(expression.variable.type);
    if (varType == 'void') {
      String body = _generateExpressionCode(expression.body,
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
    final encl = expression.target.enclosingClass;
    final className = encl?.name;
    final methodName = expression.target.name.text;

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
  print('expression: $statement');
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
      if (type.startsWith('Map') && initExpr.trim() == '{}') {
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
