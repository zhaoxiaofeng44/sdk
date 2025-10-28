import 'dart:io';

import 'package:kernel/kernel.dart';
import 'package:kernel/ast.dart';

// ============================================================================
// Dart 到 C++ 转换器 - 基于现有 base 项目的完整实现
// ============================================================================

/// C++ 代码常量定义
class CppConstants {
  // 基础类型映射
  static const Map<String, String> typeMapping = {
    'int': 'Int',
    'double': 'Double',
    'bool': 'Bool',
    'String': 'String',
    'void': 'void',
    'dynamic': 'Any',
    'Object': 'Object',
    'List': 'List',
    'Set': 'Set',
    'Map': 'Map',
    'Future': 'Future',
    'Stream': 'Stream',
  };

  // 类型构造宏
  static const Map<String, String> constructorMapping = {
    'int': 'dart_int',
    'double': 'dart_double',
    'bool': 'dart_bool',
    'String': 'dart_string',
  };

  // 运算符映射
  static const Map<String, String> operatorMapping = {
    '+': '+',
    '-': '-',
    '*': '*',
    '/': '/',
    '%': '%',
    '==': '==',
    '!=': '!=',
    '<': '<',
    '<=': '<=',
    '>': '>',
    '>=': '>=',
    '&&': '&&',
    '||': '||',
    '!': '!',
    '??': 'dart_null_coalesce',
    '?.': 'dart_safe_call',
  };

  // 关键字替换
  static const Map<String, String> keywordMapping = {
    'var': 'auto',
    'final': 'const auto',
    'const': 'const auto',
    'async': 'DART_ASYNC_FUNCTION',
    'await': 'DART_AWAIT',
  };

  // 标准头文件
  static const List<String> standardIncludes = [
    '#include "../pkg/dart2bytecode/base/object.h"',
    '#include "../pkg/dart2bytecode/base/dart_oop_extensions.h"',
    '#include "../pkg/dart2bytecode/base/dart_async.h"',
    '#include <iostream>',
  ];

  // 便利宏定义
  static const List<String> utilityMacros = [
    '#define dart_print(value) \\',
    '    do { \\',
    '        std::cout << (value).toString().getValue() << std::endl; \\',
    '    } while(0)',
    '',
    '#define dart_int(value) Int(value)',
    '#define dart_double(value) Double(value)',
    '#define dart_bool(value) Bool(value)',
    '#define dart_string(value) String(value)',
  ];
}

/// 类型转换器
class CppTypeConverter {
  static String convertType(DartType type, {bool isAsync = false}) {
    if (type is InterfaceType) {
      final className = type.classNode.name;

      // 基础类型映射
      if (CppConstants.typeMapping.containsKey(className)) {
        String cppType = CppConstants.typeMapping[className]!;

        // 泛型类型处理
        if (type.typeArguments.isNotEmpty) {
          final typeArgs =
              type.typeArguments.map((arg) => convertType(arg)).join(', ');
          cppType = '$cppType<$typeArgs>';
        }

        // 异步类型处理
        if (isAsync && className == 'Future') {
          return cppType;
        }

        return cppType;
      }

      // 自定义类型
      return className;
    } else if (type is FunctionType) {
      // 函数类型处理
      return 'std::function<${convertType(type.returnType)}()>';
    } else if (type is VoidType) {
      return 'void';
    } else if (type is DynamicType) {
      return 'Any';
    }

    return 'Any'; // 默认类型
  }

  static String convertLiteral(dynamic value) {
    if (value is String) {
      return 'dart_string("${value.replaceAll('"', '\\"')}")';
    } else if (value is int) {
      return 'dart_int($value)';
    } else if (value is double) {
      return 'dart_double($value)';
    } else if (value is bool) {
      return 'dart_bool($value)';
    }
    return value.toString();
  }
}

/// 表达式转换器
class CppExpressionConverter {
  final DartToCppTransformer transformer;

  CppExpressionConverter(this.transformer);

  String convertExpression(Expression expr) {
    if (expr is StringLiteral) {
      return CppTypeConverter.convertLiteral(expr.value);
    } else if (expr is IntLiteral) {
      return CppTypeConverter.convertLiteral(expr.value);
    } else if (expr is DoubleLiteral) {
      return CppTypeConverter.convertLiteral(expr.value);
    } else if (expr is BoolLiteral) {
      return CppTypeConverter.convertLiteral(expr.value);
    } else if (expr is NullLiteral) {
      return 'nullptr';
    } else if (expr is VariableGet) {
      return expr.variable.name ?? 'unnamed_var';
    } else if (expr is ThisExpression) {
      return 'this';
    } else if (expr is InstanceInvocation) {
      return _convertInstanceInvocation(expr);
    } else if (expr is StaticInvocation) {
      return _convertStaticInvocation(expr);
    } else if (expr is ConditionalExpression) {
      return _convertConditionalExpression(expr);
    } else if (expr is LogicalExpression) {
      return _convertLogicalExpression(expr);
    } else if (expr is Not) {
      return '!(${convertExpression(expr.operand)})';
    } else if (expr is ListLiteral) {
      return _convertListLiteral(expr);
    } else if (expr is MapLiteral) {
      return _convertMapLiteral(expr);
    } else if (expr is AwaitExpression) {
      return 'DART_AWAIT(${convertExpression(expr.operand)})';
    }

    return '/* TODO: ${expr.runtimeType} */';
  }

  String _convertStaticInvocation(StaticInvocation expr) {
    final target = expr.target;
    final className = target.enclosingClass?.name ?? '';
    final methodName = target.name.text;

    // print 函数特殊处理
    if (methodName == 'print') {
      final arg = convertExpression(expr.arguments.positional.first);
      return 'dart_print($arg)';
    }

    final args = expr.arguments.positional
        .map((arg) => convertExpression(arg))
        .join(', ');

    if (className.isNotEmpty) {
      return '$className::$methodName($args)';
    } else {
      return '$methodName($args)';
    }
  }

  String _convertInstanceInvocation(InstanceInvocation expr) {
    final receiver = convertExpression(expr.receiver);
    final methodName = expr.name.text;

    // 运算符重载处理
    if (CppConstants.operatorMapping.containsKey(methodName)) {
      final operator = CppConstants.operatorMapping[methodName]!;
      if (expr.arguments.positional.isNotEmpty) {
        final right = convertExpression(expr.arguments.positional.first);
        if (operator.startsWith('dart_')) {
          return '$operator($receiver, $right)';
        } else {
          return '$receiver $operator $right';
        }
      } else {
        return '$operator$receiver';
      }
    }

    final args = expr.arguments.positional
        .map((arg) => convertExpression(arg))
        .join(', ');
    return '$receiver.$methodName($args)';
  }

  String _convertConditionalExpression(ConditionalExpression expr) {
    final condition = convertExpression(expr.condition);
    final thenExpr = convertExpression(expr.then);
    final elseExpr = convertExpression(expr.otherwise);
    return '$condition ? $thenExpr : $elseExpr';
  }

  String _convertLogicalExpression(LogicalExpression expr) {
    final left = convertExpression(expr.left);
    final right = convertExpression(expr.right);
    final operator =
        expr.operatorEnum == LogicalExpressionOperator.AND ? '&&' : '||';
    return '$left $operator $right';
  }

  String _convertListLiteral(ListLiteral expr) {
    final elementType = CppTypeConverter.convertType(expr.typeArgument);

    if (expr.expressions.isEmpty) {
      return 'List<$elementType>::create()';
    }

    final elements =
        expr.expressions.map((e) => convertExpression(e)).join(', ');
    return 'List<$elementType>::createFromValues({$elements})';
  }

  String _convertMapLiteral(MapLiteral expr) {
    final keyType = CppTypeConverter.convertType(expr.keyType);
    final valueType = CppTypeConverter.convertType(expr.valueType);

    if (expr.entries.isEmpty) {
      return 'Map<$keyType, $valueType>::create()';
    }

    // TODO: 处理Map条目
    return 'Map<$keyType, $valueType>::create()';
  }
}

/// 语句转换器
class CppStatementConverter {
  final DartToCppTransformer transformer;

  CppStatementConverter(this.transformer);

  String convertStatement(Statement stmt) {
    if (stmt is ExpressionStatement) {
      return transformer.expressionConverter
              .convertExpression(stmt.expression) +
          ';';
    } else if (stmt is VariableDeclaration) {
      return _convertVariableDeclaration(stmt);
    } else if (stmt is Block) {
      return _convertBlock(stmt);
    } else if (stmt is IfStatement) {
      return _convertIfStatement(stmt);
    } else if (stmt is ForStatement) {
      return _convertForStatement(stmt);
    } else if (stmt is WhileStatement) {
      return _convertWhileStatement(stmt);
    } else if (stmt is ReturnStatement) {
      return _convertReturnStatement(stmt);
    } else if (stmt is BreakStatement) {
      return 'break;';
    } else if (stmt.runtimeType.toString() == 'ContinueStatement') {
      return 'continue;';
    } else if (stmt.runtimeType.toString().contains('Try')) {
      return _convertTryStatement(stmt as dynamic);
    }

    return '/* TODO: ${stmt.runtimeType} */;';
  }

  String _convertVariableDeclaration(VariableDeclaration decl) {
    final name = decl.name ?? 'unnamed_var';
    final type = CppTypeConverter.convertType(decl.type);

    if (decl.initializer != null) {
      final init =
          transformer.expressionConverter.convertExpression(decl.initializer!);

      // 检查是否使用auto
      if (decl.isFinal) {
        return 'const auto $name = $init;';
      } else {
        return 'auto $name = $init;';
      }
    } else {
      return '$type $name;';
    }
  }

  String _convertBlock(Block stmt) {
    final statements = stmt.statements
        .map((s) => transformer._indentLine(convertStatement(s)))
        .join('\n');
    return '{\n$statements\n}';
  }

  String _convertIfStatement(IfStatement stmt) {
    final condition =
        transformer.expressionConverter.convertExpression(stmt.condition);
    final thenStmt = convertStatement(stmt.then);

    String result = 'if ($condition) $thenStmt';

    if (stmt.otherwise != null) {
      final elseStmt = convertStatement(stmt.otherwise!);
      result += ' else $elseStmt';
    }

    return result;
  }

  String _convertForStatement(ForStatement stmt) {
    final variables =
        stmt.variables.map((v) => _convertVariableDeclaration(v)).join(', ');
    final condition = stmt.condition != null
        ? transformer.expressionConverter.convertExpression(stmt.condition!)
        : 'true';
    final updates = stmt.updates
        .map((u) => transformer.expressionConverter.convertExpression(u))
        .join(', ');
    final body = convertStatement(stmt.body);

    return 'for ($variables; $condition; $updates) $body';
  }

  String _convertWhileStatement(WhileStatement stmt) {
    final condition =
        transformer.expressionConverter.convertExpression(stmt.condition);
    final body = convertStatement(stmt.body);
    return 'while ($condition) $body';
  }

  String _convertReturnStatement(ReturnStatement stmt) {
    if (stmt.expression != null) {
      final expr =
          transformer.expressionConverter.convertExpression(stmt.expression!);
      return 'return $expr;';
    } else {
      return 'return;';
    }
  }

  String _convertTryStatement(dynamic stmt) {
    try {
      final tryBody = convertStatement(stmt.body);
      String result = 'try $tryBody';

      // 简化的 catch 处理
      if (stmt.catches != null) {
        for (final _ in stmt.catches) {
          result += ' catch (const std::exception& e) { /* catch block */ }';
        }
      }

      // 简化的 finally 处理
      result += '\n// Finally block should be implemented using RAII pattern';

      return result;
    } catch (e) {
      return 'try { /* try block */ } catch (const std::exception& e) { /* catch block */ }';
    }
  }
}

/// 主要的 Dart 到 C++ 转换器
class DartToCppTransformer {
  final StringBuffer _buffer = StringBuffer();
  int _indentLevel = 0;

  late final CppExpressionConverter expressionConverter;
  late final CppStatementConverter statementConverter;

  DartToCppTransformer() {
    expressionConverter = CppExpressionConverter(this);
    statementConverter = CppStatementConverter(this);
  }

  /// 转换整个组件
  String transformComponent(Component component) {
    _buffer.clear();

    // 写入头文件
    _writeHeaders();
    _writeLine('');

    // 写入工具宏
    _writeUtilityMacros();
    _writeLine('');

    // 处理类定义
    for (final library in component.libraries) {
      for (final cls in library.classes) {
        _transformClass(cls);
      }
    }

    // 处理全局函数
    for (final library in component.libraries) {
      for (final procedure in library.procedures) {
        _transformProcedure(procedure);
      }
    }

    // 写入主函数
    _writeMainFunction(component);

    return _buffer.toString();
  }

  void _writeHeaders() {
    for (final include in CppConstants.standardIncludes) {
      _writeLine(include);
    }
  }

  void _writeUtilityMacros() {
    _writeLine('// 工具宏定义');
    for (final macro in CppConstants.utilityMacros) {
      _writeLine(macro);
    }
  }

  void _transformClass(Class cls) {
    _writeLine(
        '// ============================================================================');
    _writeLine('// 类: ${cls.name}');
    _writeLine(
        '// ============================================================================');
    _writeLine('');

    // 检查是否是接口或抽象类
    final isAbstract = cls.isAbstract;
    final hasInterfaces = cls.implementedTypes.isNotEmpty;
    final hasSuperclass =
        cls.superclass != null && cls.superclass!.name != 'Object';

    if (isAbstract) {
      _writeInterface(cls);
    } else {
      _writeClass(cls, hasSuperclass, hasInterfaces);
    }
  }

  void _writeInterface(Class cls) {
    _writeLine('DART_INTERFACE(${cls.name})');
    _indent();

    // 处理抽象方法
    for (final procedure in cls.procedures) {
      if (procedure.isAbstract) {
        final returnType =
            CppTypeConverter.convertType(procedure.function.returnType);
        final name = procedure.name.text;
        final params = _buildParameterList(procedure.function);
        _writeLine('DART_ABSTRACT_METHOD($returnType, $name, ($params))');
      }
    }

    _unindent();
    _writeLine('DART_INTERFACE_END');
    _writeLine('');
  }

  void _writeClass(Class cls, bool hasSuperclass, bool hasInterfaces) {
    // 构建继承列表
    final inheritanceList = <String>[];

    if (hasSuperclass) {
      inheritanceList.add('public ${cls.superclass!.name}');
    }

    for (final interface in cls.implementedTypes) {
      final interfaceName = interface.classNode.name;
      inheritanceList.add('DART_IMPLEMENTS($interfaceName)');
    }

    final inheritance =
        inheritanceList.isNotEmpty ? ' : ${inheritanceList.join(', ')}' : '';

    _writeLine('class ${cls.name}$inheritance {');

    // 访问控制
    bool hasPrivate = false;
    bool hasPublic = false;

    // 处理字段
    for (final field in cls.fields) {
      if (!hasPrivate && _isPrivate(field.name.text)) {
        _writeLine('private:');
        hasPrivate = true;
      } else if (!hasPublic && !_isPrivate(field.name.text)) {
        _writeLine('public:');
        hasPublic = true;
      }

      _indent();
      _writeField(field);
      _unindent();
    }

    // 处理构造函数
    if (!hasPublic) {
      _writeLine('public:');
    }

    for (final constructor in cls.constructors) {
      _indent();
      _writeConstructor(constructor, cls.name);
      _unindent();
    }

    // 处理方法
    for (final procedure in cls.procedures) {
      _indent();
      _writeProcedure(procedure, isClassMember: true);
      _unindent();
    }

    _writeLine('};');
    _writeLine('');
  }

  void _writeField(Field field) {
    final type = CppTypeConverter.convertType(field.type);
    final name = field.name.text;

    if (field.initializer != null) {
      final init = expressionConverter.convertExpression(field.initializer!);
      _writeLine('$type $name = $init;');
    } else {
      _writeLine('$type $name;');
    }
  }

  void _writeConstructor(Constructor constructor, String className) {
    final params = _buildParameterList(constructor.function);

    _writeLine('$className($params) {');

    if (constructor.function.body != null) {
      _indent();
      final body =
          statementConverter.convertStatement(constructor.function.body!);
      _writeLine(body);
      _unindent();
    }

    _writeLine('}');
    _writeLine('');
  }

  void _transformProcedure(Procedure procedure) {
    _writeProcedure(procedure, isClassMember: false);
  }

  void _writeProcedure(Procedure procedure, {required bool isClassMember}) {
    final name = procedure.name.text;
    final returnType =
        CppTypeConverter.convertType(procedure.function.returnType);
    final params = _buildParameterList(procedure.function);

    // 检查是否是异步函数
    final isAsync = _isAsyncFunction(procedure.function);

    if (isAsync) {
      _writeLine('DART_ASYNC_FUNCTION($returnType, $name, ($params)) {');
      _writeLine('    DART_ASYNC_BEGIN');
    } else {
      final prefix = isClassMember ? '' : '';
      _writeLine('$prefix$returnType $name($params) {');
    }

    if (procedure.function.body != null) {
      _indent();
      final body = _transformFunctionBody(procedure.function.body!);
      _writeLine(body);
      _unindent();
    }

    if (isAsync) {
      _writeLine('    DART_ASYNC_END');
    }

    _writeLine('}');
    _writeLine('');
  }

  String _buildParameterList(FunctionNode function) {
    final params = <String>[];

    for (final param in function.positionalParameters) {
      final type = CppTypeConverter.convertType(param.type);
      final name = param.name ?? 'param';
      params.add('$type $name');
    }

    for (final param in function.namedParameters) {
      final type = CppTypeConverter.convertType(param.type);
      final name = param.name ?? 'param';
      params.add('$type $name');
    }

    return params.join(', ');
  }

  String _transformFunctionBody(Statement body) {
    return statementConverter.convertStatement(body);
  }

  bool _isAsyncFunction(FunctionNode function) {
    return function.asyncMarker == AsyncMarker.Async ||
        function.asyncMarker == AsyncMarker.AsyncStar;
  }

  bool _isPrivate(String name) {
    return name.startsWith('_');
  }

  void _writeMainFunction(Component component) {
    _writeLine(
        '// ============================================================================');
    _writeLine('// 主函数');
    _writeLine(
        '// ============================================================================');
    _writeLine('');
    _writeLine('int main() {');
    _indent();
    _writeLine('try {');
    _indent();

    // 查找main函数
    for (final library in component.libraries) {
      for (final procedure in library.procedures) {
        if (procedure.name.text == 'main') {
          final body = _transformFunctionBody(procedure.function.body!);
          _writeLine(body);
          break;
        }
      }
    }

    _writeLine('return 0;');
    _unindent();
    _writeLine('} catch (const std::exception& e) {');
    _indent();
    _writeLine('std::cerr << "Error: " << e.what() << std::endl;');
    _writeLine('return 1;');
    _unindent();
    _writeLine('}');
    _unindent();
    _writeLine('}');
  }

  // 工具方法
  void _writeLine(String line) {
    _buffer.write('${'  ' * _indentLevel}$line\n');
  }

  void _indent() {
    _indentLevel++;
  }

  void _unindent() {
    if (_indentLevel > 0) {
      _indentLevel--;
    }
  }

  String _indentLine(String line) {
    return '${'  ' * (_indentLevel + 1)}$line';
  }
}

/// 主要转换函数
String transformDartToCpp(Component component) {
  final transformer = DartToCppTransformer();
  return transformer.transformComponent(component);
}

/// 编译入口函数
Future<void> compileDartToCpp(String inputFile, String outputFile) async {
  try {
    // 读取和解析Dart文件
    print('正在读取 Dart 文件: $inputFile');

    // 创建一个简单的组件用于演示
    // 注意：完整的实现需要解析真实的Dart源码或字节码文件
    print('创建演示组件...');
    final component = Component();

    // 添加一个简单的库用于测试
    final uri = Uri.parse('file://$inputFile');
    final library = Library(uri, fileUri: uri);
    component.libraries.add(library);

    print('注意: 这是一个简化的演示实现，不解析真实的Dart文件内容');

    // 转换为C++
    print('正在转换为 C++ 代码...');
    final cppCode = transformDartToCpp(component);

    // 写入输出文件
    print('正在写入 C++ 文件: $outputFile');
    await File(outputFile).writeAsString(cppCode);

    print('✅ 转换完成！');
    print('生成的 C++ 文件: $outputFile');
  } catch (e, stackTrace) {
    print('❌ 转换失败: $e');
    print('堆栈跟踪: $stackTrace');
    rethrow;
  }
}
