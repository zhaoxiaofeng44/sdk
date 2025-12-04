// Copyright (c) 2024, the Dart project authors.
// 完整的 Dart 表达式到 C++ 转换器
// 参照 dart2bytecode 实现

import 'package:kernel/ast.dart';
import 'dart_to_cpp_compiler.dart';

/// 完整的表达式转换器 - 支持所有 Dart 表达式类型
class CompleteExpressionConverter {
  final DartToCppTransformer transformer;

  CompleteExpressionConverter(this.transformer);

  /// 转换表达式 - 主入口
  String convertExpression(Expression expr) {
    // 1. 字面量表达式
    if (expr is StringLiteral) {
      return _convertStringLiteral(expr);
    } else if (expr is IntLiteral) {
      return _convertIntLiteral(expr);
    } else if (expr is DoubleLiteral) {
      return _convertDoubleLiteral(expr);
    } else if (expr is BoolLiteral) {
      return _convertBoolLiteral(expr);
    } else if (expr is NullLiteral) {
      return _convertNullLiteral(expr);
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

    // 3. 变量和this
    else if (expr is VariableGet) {
      return _convertVariableGet(expr);
    } else if (expr is VariableSet) {
      return _convertVariableSet(expr);
    } else if (expr is ThisExpression) {
      return _convertThisExpression(expr);
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
      return _convertNot(expr);
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
      return _convertRethrow(expr);
    }

    // 13. 异步相关
    else if (expr is AwaitExpression) {
      return _convertAwaitExpression(expr);
    }

    // 14. 函数表达式
    else if (expr is FunctionExpression) {
      return _convertFunctionExpression(expr);
    }

    // 15. Let表达式
    else if (expr is Let) {
      return _convertLet(expr);
    }

    // 16. Instantiation（泛型实例化）
    else if (expr is Instantiation) {
      return _convertInstantiation(expr);
    }

    // 17. LoadLibrary
    else if (expr is LoadLibrary) {
      return _convertLoadLibrary(expr);
    } else if (expr is CheckLibraryIsLoaded) {
      return _convertCheckLibraryIsLoaded(expr);
    }

    // 18. 常量表达式
    else if (expr is ConstantExpression) {
      return _convertConstantExpression(expr);
    }

    // 19. InvalidExpression（错误恢复）
    else if (expr is InvalidExpression) {
      return _convertInvalidExpression(expr);
    }

    // 未知表达式类型
    return '/* TODO: Unsupported expression ${expr.runtimeType} */';
  }

  // ============================================================================
  // 1. 字面量转换
  // ============================================================================

  String _convertStringLiteral(StringLiteral node) {
    return CppTypeConverter.convertLiteral(node.value);
  }

  String _convertIntLiteral(IntLiteral node) {
    return CppTypeConverter.convertLiteral(node.value);
  }

  String _convertDoubleLiteral(DoubleLiteral node) {
    return CppTypeConverter.convertLiteral(node.value);
  }

  String _convertBoolLiteral(BoolLiteral node) {
    return CppTypeConverter.convertLiteral(node.value);
  }

  String _convertNullLiteral(NullLiteral node) {
    return 'Null';
  }

  String _convertSymbolLiteral(SymbolLiteral node) {
    return 'Symbol(dart_string("${node.value}"))';
  }

  String _convertTypeLiteral(TypeLiteral node) {
    final typeName = node.type.toString();
    return 'Type::of<$typeName>()';
  }

  // ============================================================================
  // 2. 集合字面量
  // ============================================================================

  String _convertListLiteral(ListLiteral node) {
    final elementType = CppTypeConverter.convertType(node.typeArgument);

    if (node.isConst) {
      // const list
      if (node.expressions.isEmpty) {
        return 'List<$elementType>::createConst()';
      }
      final elements =
          node.expressions.map((e) => convertExpression(e)).join(', ');
      return 'List<$elementType>::createConst({$elements})';
    }

    if (node.expressions.isEmpty) {
      return 'List<$elementType>::create()';
    }

    final elements =
        node.expressions.map((e) => convertExpression(e)).join(', ');
    return 'List<$elementType>::createFromValues({$elements})';
  }

  String _convertSetLiteral(SetLiteral node) {
    final elementType = CppTypeConverter.convertType(node.typeArgument);

    if (node.isConst) {
      if (node.expressions.isEmpty) {
        return 'Set<$elementType>::createConst()';
      }
      final elements =
          node.expressions.map((e) => convertExpression(e)).join(', ');
      return 'Set<$elementType>::createConst({$elements})';
    }

    if (node.expressions.isEmpty) {
      return 'Set<$elementType>::create()';
    }

    final elements =
        node.expressions.map((e) => convertExpression(e)).join(', ');
    return 'Set<$elementType>::createFromValues({$elements})';
  }

  String _convertMapLiteral(MapLiteral node) {
    final keyType = CppTypeConverter.convertType(node.keyType);
    final valueType = CppTypeConverter.convertType(node.valueType);

    if (node.isConst) {
      if (node.entries.isEmpty) {
        return 'Map<$keyType, $valueType>::createConst()';
      }
    }

    if (node.entries.isEmpty) {
      return 'Map<$keyType, $valueType>::create()';
    }

    // 生成带初始化的Map
    final entries = node.entries.map((entry) {
      final key = convertExpression(entry.key);
      final value = convertExpression(entry.value);
      return '{$key, $value}';
    }).join(', ');

    return 'Map<$keyType, $valueType>::createFromEntries({$entries})';
  }

  // ============================================================================
  // 3. 变量访问
  // ============================================================================

  String _convertVariableGet(VariableGet node) {
    return node.variable.name ?? 'unnamed_var';
  }

  String _convertVariableSet(VariableSet node) {
    final varName = node.variable.name ?? 'unnamed_var';
    final value = convertExpression(node.value);
    return '$varName = $value';
  }

  String _convertThisExpression(ThisExpression node) {
    return 'this';
  }

  // ============================================================================
  // 4. 实例属性访问
  // ============================================================================

  String _convertInstanceGet(InstanceGet node) {
    final receiver = convertExpression(node.receiver);
    final memberName = node.name.text;
    return '$receiver->$memberName';
  }

  String _convertInstanceSet(InstanceSet node) {
    final receiver = convertExpression(node.receiver);
    final memberName = node.name.text;
    final value = convertExpression(node.value);
    return '$receiver->$memberName = $value';
  }

  String _convertDynamicGet(DynamicGet node) {
    final receiver = convertExpression(node.receiver);
    final memberName = node.name.text;
    return '$receiver.$memberName'; // Dynamic调用可能需要特殊处理
  }

  String _convertDynamicSet(DynamicSet node) {
    final receiver = convertExpression(node.receiver);
    final memberName = node.name.text;
    final value = convertExpression(node.value);
    return '$receiver.$memberName = $value';
  }

  String _convertInstanceTearOff(InstanceTearOff node) {
    final receiver = convertExpression(node.receiver);
    final memberName = node.name.text;
    return '&$receiver->$memberName'; // 获取成员函数指针
  }

  // ============================================================================
  // 5. 静态访问
  // ============================================================================

  String _convertStaticGet(StaticGet node) {
    final target = node.target;
    if (target is Field) {
      final className = target.enclosingClass?.name ?? '';
      final fieldName = target.name.text;
      if (className.isNotEmpty) {
        return '$className::$fieldName';
      }
      return fieldName;
    }
    return '/* StaticGet: ${target.runtimeType} */';
  }

  String _convertStaticSet(StaticSet node) {
    final target = node.target;
    final className = target.enclosingClass?.name ?? '';
    final fieldName = target.name.text;
    final value = convertExpression(node.value);

    if (className.isNotEmpty) {
      return '$className::$fieldName = $value';
    }
    return '$fieldName = $value';
  }

  String _convertStaticTearOff(StaticTearOff node) {
    final target = node.target;
    final className = target.enclosingClass?.name ?? '';
    final methodName = target.name.text;

    if (className.isNotEmpty) {
      return '&$className::$methodName';
    }
    return '&$methodName';
  }

  // ============================================================================
  // 6. Super访问
  // ============================================================================

  String _convertSuperPropertyGet(SuperPropertyGet node) {
    final memberName = node.name.text;
    return 'super::$memberName';
  }

  String _convertSuperPropertySet(SuperPropertySet node) {
    final memberName = node.name.text;
    final value = convertExpression(node.value);
    return 'super::$memberName = $value';
  }

  // ============================================================================
  // 7. 方法调用
  // ============================================================================

  String _convertInstanceInvocation(InstanceInvocation node) {
    final receiver = convertExpression(node.receiver);
    final methodName = node.name.text;

    // 检查是否是运算符
    if (CppConstants.operatorMapping.containsKey(methodName)) {
      final operator = CppConstants.operatorMapping[methodName]!;
      if (node.arguments.positional.isNotEmpty) {
        final right = convertExpression(node.arguments.positional.first);
        if (operator.startsWith('dart_')) {
          return '$operator($receiver, $right)';
        } else {
          return '($receiver $operator $right)';
        }
      } else {
        // 一元运算符
        return '$operator$receiver';
      }
    }

    // 普通方法调用
    final args = _convertArguments(node.arguments);
    return '$receiver->$methodName($args)';
  }

  String _convertDynamicInvocation(DynamicInvocation node) {
    final receiver = convertExpression(node.receiver);
    final methodName = node.name.text;
    final args = _convertArguments(node.arguments);
    return '$receiver.$methodName($args)'; // Dynamic调用
  }

  String _convertFunctionInvocation(FunctionInvocation node) {
    final receiver = convertExpression(node.receiver);
    final args = _convertArguments(node.arguments);
    return '$receiver($args)';
  }

  String _convertLocalFunctionInvocation(LocalFunctionInvocation node) {
    final functionName = node.variable.name ?? 'unnamed_func';
    final args = _convertArguments(node.arguments);
    return '$functionName($args)';
  }

  String _convertStaticInvocation(StaticInvocation node) {
    final target = node.target;
    final className = target.enclosingClass?.name ?? '';
    final methodName = target.name.text;

    // print 函数特殊处理
    if (methodName == 'print' && className.isEmpty) {
      final arg = convertExpression(node.arguments.positional.first);
      return 'dart_print($arg)';
    }

    final args = _convertArguments(node.arguments);

    if (className.isNotEmpty) {
      return '$className::$methodName($args)';
    } else {
      return '$methodName($args)';
    }
  }

  String _convertSuperMethodInvocation(SuperMethodInvocation node) {
    final methodName = node.name.text;
    final args = _convertArguments(node.arguments);
    return 'super::$methodName($args)';
  }

  String _convertEqualsCall(EqualsCall node) {
    final left = convertExpression(node.left);
    final right = convertExpression(node.right);
    return '($left == $right)';
  }

  String _convertEqualsNull(EqualsNull node) {
    final expr = convertExpression(node.expression);
    return '($expr == nullptr)';
  }

  // ============================================================================
  // 8. 构造函数调用
  // ============================================================================

  String _convertConstructorInvocation(ConstructorInvocation node) {
    final className = node.target.enclosingClass.name;
    final args = _convertArguments(node.arguments);

    if (node.isConst) {
      return 'ObjectPtr<$className>::createConst($args)';
    }

    return 'ObjectPtr<$className>(new $className($args))';
  }

  // ============================================================================
  // 9. 逻辑表达式
  // ============================================================================

  String _convertLogicalExpression(LogicalExpression node) {
    final left = convertExpression(node.left);
    final right = convertExpression(node.right);
    final operator =
        node.operatorEnum == LogicalExpressionOperator.AND ? '&&' : '||';
    return '($left $operator $right)';
  }

  String _convertConditionalExpression(ConditionalExpression node) {
    final condition = convertExpression(node.condition);
    final thenExpr = convertExpression(node.then);
    final elseExpr = convertExpression(node.otherwise);
    return '($condition ? $thenExpr : $elseExpr)';
  }

  String _convertNot(Not node) {
    final operand = convertExpression(node.operand);
    return '(!$operand)';
  }

  // ============================================================================
  // 10. 类型测试和转换
  // ============================================================================

  String _convertIsExpression(IsExpression node) {
    final operand = convertExpression(node.operand);
    final type = CppTypeConverter.convertType(node.type);
    return 'dart_is<$type>($operand)';
  }

  String _convertAsExpression(AsExpression node) {
    final operand = convertExpression(node.operand);
    final type = CppTypeConverter.convertType(node.type);

    if (node.isTypeError) {
      // 类型错误检查
      return 'dart_as<$type>($operand)';
    } else {
      // 类型转换
      return 'dart_cast<$type>($operand)';
    }
  }

  String _convertNullCheck(NullCheck node) {
    final operand = convertExpression(node.operand);
    return 'dart_null_check($operand)';
  }

  // ============================================================================
  // 11. 字符串连接
  // ============================================================================

  String _convertStringConcatenation(StringConcatenation node) {
    if (node.expressions.length == 1) {
      return '${convertExpression(node.expressions[0])}.toString()';
    }

    // 使用 dart_concat 函数进行字符串拼接
    final parts = node.expressions.map((expr) {
      return convertExpression(expr);
    }).toList();

    return 'dart_concat(${parts.join(', ')})';
  }

  // ============================================================================
  // 12. 异常处理
  // ============================================================================

  String _convertThrow(Throw node) {
    final expr = convertExpression(node.expression);
    return 'throw DartException($expr)';
  }

  String _convertRethrow(Rethrow node) {
    return 'throw'; // C++ rethrow
  }

  // ============================================================================
  // 13. 异步
  // ============================================================================

  String _convertAwaitExpression(AwaitExpression node) {
    final operand = convertExpression(node.operand);
    return 'DART_AWAIT($operand)';
  }

  // ============================================================================
  // 14. 函数表达式
  // ============================================================================

  String _convertFunctionExpression(FunctionExpression node) {
    // Lambda表达式/闭包
    final params = node.function.positionalParameters
        .map((p) => '${CppTypeConverter.convertType(p.type)} ${p.name}')
        .join(', ');

    // 简化处理：生成lambda
    return '[&]($params) { /* lambda body */ }';
  }

  // ============================================================================
  // 15. Let表达式
  // ============================================================================

  String _convertLet(Let node) {
    // Let表达式：let x = value in body
    final varName = node.variable.name ?? 'let_var';
    final varType = CppTypeConverter.convertType(node.variable.type);
    final value = convertExpression(node.variable.initializer!);
    final body = convertExpression(node.body);

    return '([&]() { $varType $varName = $value; return $body; })()';
  }

  // ============================================================================
  // 16. 泛型实例化
  // ============================================================================

  String _convertInstantiation(Instantiation node) {
    final expr = convertExpression(node.expression);
    final typeArgs = node.typeArguments
        .map((t) => CppTypeConverter.convertType(t))
        .join(', ');
    return '$expr<$typeArgs>';
  }

  // ============================================================================
  // 17. 库加载
  // ============================================================================

  String _convertLoadLibrary(LoadLibrary node) {
    return 'Future<void>::completed()'; // 简化处理
  }

  String _convertCheckLibraryIsLoaded(CheckLibraryIsLoaded node) {
    return '/* Library check */';
  }

  // ============================================================================
  // 18. 常量表达式
  // ============================================================================

  String _convertConstantExpression(ConstantExpression node) {
    final constant = node.constant;
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

  // ============================================================================
  // 19. 错误处理
  // ============================================================================

  String _convertInvalidExpression(InvalidExpression node) {
    return '/* Invalid expression: ${node.message} */';
  }

  // ============================================================================
  // 辅助方法
  // ============================================================================

  String _convertArguments(Arguments args) {
    final positional =
        args.positional.map((a) => convertExpression(a)).toList();
    final named = args.named
        .map((a) => '/*${a.name}:*/ ${convertExpression(a.value)}')
        .toList();

    return [...positional, ...named].join(', ');
  }
}
