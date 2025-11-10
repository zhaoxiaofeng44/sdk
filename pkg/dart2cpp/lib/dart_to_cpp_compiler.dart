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
    '#include "./core/object.h"',
    '#include "./core/dart_oop_extensions.h"',
    '#include "./core/dart_async.h"',
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

/// 表达式转换器 - 支持所有 Dart 表达式类型
class CppExpressionConverter {
  final DartToCppTransformer transformer;

  // 跟踪 Let 变量的映射：原始变量 -> Let 变量名
  final Map<VariableDeclaration, String> _letVariableMap = {};

  CppExpressionConverter(this.transformer);

  String convertExpression(Expression expr) {
    // 1. 字面量表达式
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
    } else if (expr is SymbolLiteral) {
      return _convertSymbolLiteral(expr);
    } else if (expr is TypeLiteral) {
      return _convertTypeLiteral(expr);
    }

    // 2. 集合字面量
    else if (expr is ListLiteral) {
      return _convertListLiteral(expr);
    } else if (expr is SetLiteral) {
      return _convertSetLiteral(expr);
    } else if (expr is MapLiteral) {
      return _convertMapLiteral(expr);
    }

    // 3. 变量访问
    else if (expr is VariableGet) {
      // 检查是否是 Let 变量
      if (_letVariableMap.containsKey(expr.variable)) {
        return _letVariableMap[expr.variable]!;
      }
      return expr.variable.name ?? 'unnamed_var';
    } else if (expr is VariableSet) {
      return _convertVariableSet(expr);
    } else if (expr is ThisExpression) {
      return 'this';
    }

    // 4. 属性访问
    else if (expr is InstanceGet) {
      return _convertInstanceGet(expr);
    } else if (expr is InstanceSet) {
      return _convertInstanceSet(expr);
    } else if (expr is DynamicGet) {
      return _convertDynamicGet(expr);
    } else if (expr is DynamicSet) {
      return _convertDynamicSet(expr);
    } else if (expr is InstanceTearOff) {
      return _convertInstanceTearOff(expr);
    }

    // 5. 静态访问
    else if (expr is StaticGet) {
      return _convertStaticGet(expr);
    } else if (expr is StaticSet) {
      return _convertStaticSet(expr);
    } else if (expr is StaticTearOff) {
      return _convertStaticTearOff(expr);
    }

    // 6. Super访问
    else if (expr is SuperPropertyGet) {
      return _convertSuperPropertyGet(expr);
    } else if (expr is SuperPropertySet) {
      return _convertSuperPropertySet(expr);
    }

    // 7. 方法调用
    else if (expr is InstanceInvocation) {
      return _convertInstanceInvocation(expr);
    } else if (expr is DynamicInvocation) {
      return _convertDynamicInvocation(expr);
    } else if (expr is FunctionInvocation) {
      return _convertFunctionInvocation(expr);
    } else if (expr is LocalFunctionInvocation) {
      return _convertLocalFunctionInvocation(expr);
    } else if (expr is StaticInvocation) {
      return _convertStaticInvocation(expr);
    } else if (expr is SuperMethodInvocation) {
      return _convertSuperMethodInvocation(expr);
    } else if (expr is EqualsCall) {
      return _convertEqualsCall(expr);
    } else if (expr is EqualsNull) {
      return _convertEqualsNull(expr);
    }

    // 8. 构造函数调用
    else if (expr is ConstructorInvocation) {
      return _convertConstructorInvocation(expr);
    }

    // 9. 逻辑和条件表达式
    else if (expr is LogicalExpression) {
      return _convertLogicalExpression(expr);
    } else if (expr is ConditionalExpression) {
      return _convertConditionalExpression(expr);
    } else if (expr is Not) {
      return '!(${convertExpression(expr.operand)})';
    }

    // 10. 类型测试和转换
    else if (expr is IsExpression) {
      return _convertIsExpression(expr);
    } else if (expr is AsExpression) {
      return _convertAsExpression(expr);
    } else if (expr is NullCheck) {
      return _convertNullCheck(expr);
    }

    // 11. 字符串连接
    else if (expr is StringConcatenation) {
      return _convertStringConcatenation(expr);
    }

    // 12. 异常相关
    else if (expr is Throw) {
      return _convertThrow(expr);
    } else if (expr is Rethrow) {
      return 'throw';
    }

    // 13. 异步相关
    else if (expr is AwaitExpression) {
      return 'DART_AWAIT(${convertExpression(expr.operand)})';
    }

    // 14. 函数表达式
    else if (expr is FunctionExpression) {
      return _convertFunctionExpression(expr);
    }

    // 15. Let表达式
    else if (expr is Let) {
      return _convertLet(expr);
    }

    // 16. 泛型实例化
    else if (expr is Instantiation) {
      return _convertInstantiation(expr);
    }

    // 17. 库加载
    else if (expr is LoadLibrary) {
      return 'Future<void>::completed()';
    } else if (expr is CheckLibraryIsLoaded) {
      return '/* Library check */';
    }

    // 18. 常量表达式
    else if (expr is ConstantExpression) {
      return _convertConstantExpression(expr);
    }

    // 19. 错误恢复
    else if (expr is InvalidExpression) {
      return '/* Invalid: ${expr.message} */';
    }

    // 20. BlockExpression
    else if (expr is BlockExpression) {
      return _convertBlockExpression(expr);
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

    // 处理一元负号运算符
    if (methodName == 'unary-') {
      return '(-$receiver)';
    }

    // 处理一元取反运算符
    if (methodName == '~') {
      return '(~$receiver)';
    }

    // 运算符重载处理
    if (CppConstants.operatorMapping.containsKey(methodName)) {
      final operator = CppConstants.operatorMapping[methodName]!;
      if (expr.arguments.positional.isNotEmpty) {
        final right = convertExpression(expr.arguments.positional.first);
        if (operator.startsWith('dart_')) {
          return '$operator($receiver, $right)';
        } else {
          return '($receiver $operator $right)';
        }
      } else {
        return '($operator$receiver)';
      }
    }

    final args = expr.arguments.positional
        .map((arg) => convertExpression(arg))
        .join(', ');
    return '$receiver->$methodName($args)';
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

  String _convertSetLiteral(SetLiteral expr) {
    final elementType = CppTypeConverter.convertType(expr.typeArgument);
    if (expr.expressions.isEmpty) {
      return 'Set<$elementType>::create()';
    }
    final elements =
        expr.expressions.map((e) => convertExpression(e)).join(', ');
    return 'Set<$elementType>::createFromValues({$elements})';
  }

  String _convertMapLiteral(MapLiteral expr) {
    final keyType = CppTypeConverter.convertType(expr.keyType);
    final valueType = CppTypeConverter.convertType(expr.valueType);

    if (expr.entries.isEmpty) {
      return 'Map<$keyType, $valueType>::create()';
    }

    final entries = expr.entries.map((entry) {
      final key = convertExpression(entry.key);
      final value = convertExpression(entry.value);
      return '{$key, $value}';
    }).join(', ');

    return 'Map<$keyType, $valueType>::createFromEntries({$entries})';
  }

  // 新增的转换方法

  String _convertSymbolLiteral(SymbolLiteral expr) {
    return 'Symbol(dart_string("${expr.value}"))';
  }

  String _convertTypeLiteral(TypeLiteral expr) {
    final typeName = expr.type.toString();
    return 'Type::of<$typeName>()';
  }

  String _convertVariableSet(VariableSet expr) {
    final varName = expr.variable.name ?? 'unnamed_var';
    final value = convertExpression(expr.value);
    return '$varName = $value';
  }

  String _convertInstanceGet(InstanceGet expr) {
    final receiver = convertExpression(expr.receiver);
    final memberName = expr.name.text;
    return '$receiver->$memberName';
  }

  String _convertInstanceSet(InstanceSet expr) {
    final receiver = convertExpression(expr.receiver);
    final memberName = expr.name.text;
    final value = convertExpression(expr.value);
    return '$receiver->$memberName = $value';
  }

  String _convertDynamicGet(DynamicGet expr) {
    final receiver = convertExpression(expr.receiver);
    final memberName = expr.name.text;
    return '$receiver.$memberName';
  }

  String _convertDynamicSet(DynamicSet expr) {
    final receiver = convertExpression(expr.receiver);
    final memberName = expr.name.text;
    final value = convertExpression(expr.value);
    return '$receiver.$memberName = $value';
  }

  String _convertInstanceTearOff(InstanceTearOff expr) {
    final receiver = convertExpression(expr.receiver);
    final memberName = expr.name.text;
    return '&$receiver->$memberName';
  }

  String _convertStaticGet(StaticGet expr) {
    final target = expr.target;
    if (target is Field) {
      final className = target.enclosingClass?.name ?? '';
      final fieldName = target.name.text;
      if (className.isNotEmpty) {
        return '$className::$fieldName';
      }
      return fieldName;
    }
    return '/* StaticGet */';
  }

  String _convertStaticSet(StaticSet expr) {
    final target = expr.target;
    final className = target.enclosingClass?.name ?? '';
    final fieldName = target.name.text;
    final value = convertExpression(expr.value);
    if (className.isNotEmpty) {
      return '$className::$fieldName = $value';
    }
    return '$fieldName = $value';
  }

  String _convertStaticTearOff(StaticTearOff expr) {
    final target = expr.target;
    final className = target.enclosingClass?.name ?? '';
    final methodName = target.name.text;
    if (className.isNotEmpty) {
      return '&$className::$methodName';
    }
    return '&$methodName';
  }

  String _convertSuperPropertyGet(SuperPropertyGet expr) {
    final memberName = expr.name.text;
    return 'super::$memberName';
  }

  String _convertSuperPropertySet(SuperPropertySet expr) {
    final memberName = expr.name.text;
    final value = convertExpression(expr.value);
    return 'super::$memberName = $value';
  }

  String _convertDynamicInvocation(DynamicInvocation expr) {
    final receiver = convertExpression(expr.receiver);
    final methodName = expr.name.text;
    final args = _convertArguments(expr.arguments);
    return '$receiver.$methodName($args)';
  }

  String _convertFunctionInvocation(FunctionInvocation expr) {
    final receiver = convertExpression(expr.receiver);
    final args = _convertArguments(expr.arguments);
    return '$receiver($args)';
  }

  String _convertLocalFunctionInvocation(LocalFunctionInvocation expr) {
    final functionName = expr.variable.name ?? 'unnamed_func';
    final args = _convertArguments(expr.arguments);
    return '$functionName($args)';
  }

  String _convertSuperMethodInvocation(SuperMethodInvocation expr) {
    final methodName = expr.name.text;
    final args = _convertArguments(expr.arguments);
    return 'super::$methodName($args)';
  }

  String _convertEqualsCall(EqualsCall expr) {
    final left = convertExpression(expr.left);
    final right = convertExpression(expr.right);
    return '($left == $right)';
  }

  String _convertEqualsNull(EqualsNull expr) {
    final operand = convertExpression(expr.expression);
    return '($operand == nullptr)';
  }

  String _convertConstructorInvocation(ConstructorInvocation expr) {
    final className = expr.target.enclosingClass.name;
    final args = _convertArguments(expr.arguments);
    if (expr.isConst) {
      return 'ObjectPtr<$className>::createConst($args)';
    }
    return 'ObjectPtr<$className>(new $className($args))';
  }

  String _convertIsExpression(IsExpression expr) {
    final operand = convertExpression(expr.operand);
    final type = CppTypeConverter.convertType(expr.type);
    return 'dart_is<$type>($operand)';
  }

  String _convertAsExpression(AsExpression expr) {
    final operand = convertExpression(expr.operand);
    final type = CppTypeConverter.convertType(expr.type);
    return 'dart_cast<$type>($operand)';
  }

  String _convertNullCheck(NullCheck expr) {
    final operand = convertExpression(expr.operand);
    return 'dart_null_check($operand)';
  }

  String _convertStringConcatenation(StringConcatenation expr) {
    if (expr.expressions.length == 1) {
      return '${convertExpression(expr.expressions[0])}.toString()';
    }
    final parts = expr.expressions.map((e) {
      if (e is StringLiteral) {
        return convertExpression(e);
      } else {
        return '${convertExpression(e)}.toString()';
      }
    }).toList();
    return parts.join(' + ');
  }

  String _convertThrow(Throw expr) {
    final operand = convertExpression(expr.expression);
    return 'throw DartException($operand)';
  }

  String _convertFunctionExpression(FunctionExpression expr) {
    final params = expr.function.positionalParameters
        .map((p) => '${CppTypeConverter.convertType(p.type)} ${p.name}')
        .join(', ');

    // 生成 lambda 函数体
    String body = '/* empty */';
    if (expr.function.body != null) {
      body =
          transformer.statementConverter.convertStatement(expr.function.body!);
      // 如果是表达式语句，提取返回值
      if (expr.function.body is ReturnStatement) {
        body = body; // 保持 return 语句
      } else if (expr.function.body is Block) {
        body = body; // 保持块语句
      }
    }

    return '[&]($params) { $body }';
  }

  String _convertLet(Let expr) {
    final varName = expr.variable.name ?? 'let_var';
    final varType = CppTypeConverter.convertType(expr.variable.type);
    final value = convertExpression(expr.variable.initializer!);

    // 注册 Let 变量映射
    _letVariableMap[expr.variable] = varName;

    // 转换 body，此时 VariableGet 会使用映射的变量名
    final body = convertExpression(expr.body);

    // 清除映射
    _letVariableMap.remove(expr.variable);

    // 使用立即调用的 lambda，确保变量名在作用域内
    return '([&]() { $varType $varName = $value; return $body; })()';
  }

  String _convertInstantiation(Instantiation expr) {
    final operand = convertExpression(expr.expression);
    final typeArgs = expr.typeArguments
        .map((t) => CppTypeConverter.convertType(t))
        .join(', ');
    return '$operand<$typeArgs>';
  }

  String _convertConstantExpression(ConstantExpression expr) {
    final constant = expr.constant;
    return _convertConstant(constant);
  }

  String _convertConstant(Constant constant) {
    if (constant is NullConstant) {
      return 'nullptr';
    } else if (constant is BoolConstant) {
      return CppTypeConverter.convertLiteral(constant.value);
    } else if (constant is IntConstant) {
      return CppTypeConverter.convertLiteral(constant.value);
    } else if (constant is DoubleConstant) {
      return CppTypeConverter.convertLiteral(constant.value);
    } else if (constant is StringConstant) {
      return CppTypeConverter.convertLiteral(constant.value);
    } else if (constant is ListConstant) {
      final elementType = CppTypeConverter.convertType(constant.typeArgument);
      final elements =
          constant.entries.map((c) => _convertConstant(c)).join(', ');
      return 'List<$elementType>::createConst({$elements})';
    } else if (constant is SetConstant) {
      final elementType = CppTypeConverter.convertType(constant.typeArgument);
      final elements =
          constant.entries.map((c) => _convertConstant(c)).join(', ');
      return 'Set<$elementType>::createConst({$elements})';
    } else if (constant is MapConstant) {
      final keyType = CppTypeConverter.convertType(constant.keyType);
      final valueType = CppTypeConverter.convertType(constant.valueType);
      return 'Map<$keyType, $valueType>::createConst()';
    } else if (constant is InstanceConstant) {
      final className = constant.classNode.name;
      return 'ObjectPtr<$className>::createConst()';
    }
    return '/* Constant: ${constant.runtimeType} */';
  }

  String _convertBlockExpression(BlockExpression expr) {
    // BlockExpression 包含一个语句块和一个值表达式
    // 使用立即调用的 lambda 来实现
    final statements = expr.body.statements
        .map((s) => transformer.statementConverter.convertStatement(s))
        .where((s) => s.isNotEmpty)
        .join(' ');
    final value = convertExpression(expr.value);

    if (statements.isEmpty) {
      return value;
    }

    return '([&]() { $statements return $value; })()';
  }

  String _convertArguments(Arguments args) {
    final positional =
        args.positional.map((a) => convertExpression(a)).toList();
    final named = args.named
        .map((a) => '/*${a.name}:*/ ${convertExpression(a.value)}')
        .toList();
    return [...positional, ...named].join(', ');
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
    } else if (stmt is EmptyStatement) {
      return ''; // 空语句 - 不生成任何代码
    } else if (stmt is LabeledStatement) {
      return _convertLabeledStatement(stmt);
    } else if (stmt is AssertStatement) {
      return _convertAssertStatement(stmt);
    } else if (stmt is FunctionDeclaration) {
      return _convertFunctionDeclaration(stmt);
    } else if (stmt is YieldStatement) {
      return _convertYieldStatement(stmt);
    } else if (stmt is DoStatement) {
      return _convertDoStatement(stmt);
    } else if (stmt is SwitchStatement) {
      return _convertSwitchStatement(stmt);
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

  String _convertLabeledStatement(LabeledStatement stmt) {
    // LabeledStatement 在 Dart 中用于 break/continue 的目标
    // 在 C++ 中，我们可以生成一个标签
    final body = convertStatement(stmt.body);
    return 'label_${stmt.hashCode}: $body';
  }

  String _convertAssertStatement(AssertStatement stmt) {
    final condition =
        transformer.expressionConverter.convertExpression(stmt.condition);
    if (stmt.message != null) {
      final message =
          transformer.expressionConverter.convertExpression(stmt.message!);
      return 'assert(($condition).toBool() && "$message");';
    }
    return 'assert(($condition).toBool());';
  }

  String _convertFunctionDeclaration(FunctionDeclaration stmt) {
    final name = stmt.variable.name ?? 'anonymous';
    final returnType = CppTypeConverter.convertType(stmt.function.returnType);
    final params = stmt.function.positionalParameters
        .map((p) => '${CppTypeConverter.convertType(p.type)} ${p.name}')
        .join(', ');

    String body = '{ }';
    if (stmt.function.body != null) {
      body = convertStatement(stmt.function.body!);
    }

    return 'auto $name = [&]($params) -> $returnType $body;';
  }

  String _convertYieldStatement(YieldStatement stmt) {
    final value =
        transformer.expressionConverter.convertExpression(stmt.expression);
    return 'co_yield $value;  // C++20 coroutine';
  }

  String _convertDoStatement(DoStatement stmt) {
    final condition =
        transformer.expressionConverter.convertExpression(stmt.condition);
    final body = convertStatement(stmt.body);
    return 'do $body while (($condition).toBool());';
  }

  String _convertSwitchStatement(SwitchStatement stmt) {
    final expr =
        transformer.expressionConverter.convertExpression(stmt.expression);
    StringBuffer result = StringBuffer('switch ($expr) {\n');

    for (final case_ in stmt.cases) {
      for (final expr in case_.expressions) {
        final caseValue =
            transformer.expressionConverter.convertExpression(expr);
        result.write('  case $caseValue:\n');
      }

      if (case_.isDefault) {
        result.write('  default:\n');
      }

      final body = convertStatement(case_.body);
      result.write('    $body\n');

      if (!case_.body.toString().contains('break') &&
          !case_.body.toString().contains('return')) {
        result.write('    break;\n');
      }
    }

    result.write('}');
    return result.toString();
  }
}

/// 主要的 Dart 到 C++ 转换器
class DartToCppTransformer {
  final StringBuffer _buffer = StringBuffer();
  int _indentLevel = 0;

  late final CppExpressionConverter expressionConverter;
  late final CppStatementConverter statementConverter;

  /// 需要跳过的基础库前缀列表
  static const List<String> skipLibraryPrefixes = [
    'dart.',
    'dart:',
    'package:flutter',
    'package:meta',
    'package:collection',
    'package:async',
    'package:typed_data',
    'package:convert',
    'package:io',
    'package:isolate',
    'package:math',
    'package:mirrors',
    'package:developer',
    'package:ffi',
    'package:js',
    'package:html',
    'package:indexed_db',
    'package:svg',
    'package:web_audio',
    'package:web_gl',
    'package:web_sql',
  ];

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

    // 统计过滤信息
    int totalLibraries = component.libraries.length;
    int skippedLibraries = 0;
    int processedClasses = 0;
    int processedProcedures = 0;

    // 处理类定义 - 只处理非基础库的类
    for (final library in component.libraries) {
      if (_shouldSkipLibrary(library)) {
        skippedLibraries++;
        continue;
      }

      for (final cls in library.classes) {
        _transformClass(cls);
        processedClasses++;
      }
    }

    // 处理全局函数 - 只处理非基础库的函数
    for (final library in component.libraries) {
      if (_shouldSkipLibrary(library)) {
        continue;
      }

      for (final procedure in library.procedures) {
        _transformProcedure(procedure);
        processedProcedures++;
      }
    }

    // 写入主函数
    _writeMainFunction(component);

    // 输出过滤统计信息
    print('📊 转换统计:');
    print('   总库数: $totalLibraries');
    print('   跳过基础库: $skippedLibraries');
    print('   处理业务库: ${totalLibraries - skippedLibraries}');
    print('   转换类数: $processedClasses');
    print('   转换函数数: $processedProcedures');

    return _buffer.toString();
  }

  /// 检查是否应该跳过某个库
  bool _shouldSkipLibrary(Library library) {
    final libraryUri = library.importUri.toString();

    // 检查是否匹配跳过的前缀
    for (final prefix in skipLibraryPrefixes) {
      if (libraryUri.startsWith(prefix)) {
        return true;
      }
    }

    return false;
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

    // 构建初始化列表
    final initializers = <String>[];
    for (final initializer in constructor.initializers) {
      if (initializer is FieldInitializer) {
        final fieldName = initializer.field.name.text;
        final value = expressionConverter.convertExpression(initializer.value);
        initializers.add('$fieldName($value)');
      } else if (initializer is SuperInitializer) {
        final args =
            expressionConverter._convertArguments(initializer.arguments);
        // 如果有参数，使用父类构造函数；否则跳过
        if (args.isNotEmpty) {
          // C++ 不支持 super，需要使用基类名
          if (constructor.enclosingClass.superclass != null) {
            final superName = constructor.enclosingClass.superclass!.name;
            initializers.add('$superName($args)');
          }
        }
      }
    }

    // 写入构造函数签名和初始化列表
    if (initializers.isNotEmpty) {
      _writeLine('$className($params) : ${initializers.join(', ')} {');
    } else {
      _writeLine('$className($params) {');
    }

    if (constructor.function.body != null) {
      _indent();
      final body =
          statementConverter.convertStatement(constructor.function.body!);
      if (body.isNotEmpty) {
        _writeLine(body);
      }
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
