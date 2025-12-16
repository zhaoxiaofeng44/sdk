import 'dart:io';

import 'package:kernel/kernel.dart';
import 'package:kernel/ast.dart';
import 'type_analyzer.dart';

// ============================================================================
// Dart 到 C++ 转换器 - 基于现有 base 项目的完整实现
// ============================================================================

/// 清理标识符名称，将特殊字符替换为下划线
String _sanitizeIdentifier(String name) {
  if (name.isEmpty) return 'unnamed';

  // 移除开头的特殊字符
  if (name.startsWith(':') || name.startsWith('#')) {
    name = name.substring(1);
  }

  // 替换所有特殊字符为下划线
  name = name.replaceAll(RegExp(r'[^a-zA-Z0-9_]'), '_');

  // 确保不以数字开头
  if (name.isNotEmpty && RegExp(r'^[0-9]').hasMatch(name)) {
    name = 'var_$name';
  }

  return name.isEmpty ? 'unnamed' : name;
}

/// C++ 代码常量定义
class CppConstants {
  // 基础类型映射
  static const Map<String, String> typeMapping = {
    'int': 'Int',
    'double': 'Double',
    'bool': 'Bool',
    'String': 'String',
    'void': 'Nullable',
    'dynamic': 'Any',
    'Object': 'Object',
    'List': 'List',
    'Set': 'Set',
    'Map': 'Map',
    'Future': 'Future',
    'Stream': 'Stream',
    'StringBuffer': 'StringBuffer',
    'RegExp': 'RegExp',
    'Timer': 'Timer',
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
    '~/': 'truncatingDivision',
    '==': '==',
    '!=': '!=',
    '<': '<',
    '<=': '<=',
    '>': '>',
    '>=': '>=',
    '&&': '&&',
    '||': '||',
    '!': '!',
    '&': 'operator_bitwise_and',
    '|': 'operator_bitwise_or',
    '^': 'operator_bitwise_xor',
    '<<': 'operator_shift_left',
    '>>': 'operator_shift_right',
    '~': 'operator_bitwise_not',
    'unary-': 'operator_negate',
    '??': 'dart_null_coalesce',
    '?.': 'dart_null_check',
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
    '#include "dart2cpp.h"',
  ];

  // 便利宏定义
  static const List<String> utilityMacros = [
    // '#define dart_print(value) \\',
    // '    do { \\',
    // '        std::cout << (value).toString().getValue() << std::endl; \\',
    // '    } while(0)',
    // '',
    // '#define dart_int(value) Int(value)',
    // '#define dart_double(value) Double(value)',
    // '#define dart_bool(value) Bool(value)',
    // '#define dart_string(value) String(value)',
  ];
}

/// 类型转换器
class CppTypeConverter {
  static String convertType(DartType type, {bool isAsync = false}) {
    if (type is InterfaceType) {
      final className = type.classNode.name;

      // 处理可空类型：String? -> String（可以赋值为Null）
      if (type.nullability.toString().contains('nullable')) {
        // 获取非空版本的类型
        final nonNullType =
            convertType(type.withDeclaredNullability(Nullability.nonNullable));

        // 对于基础类型，直接返回非空类型（运行时可以赋值为Null）
        if (_isBasicType(className)) {
          return nonNullType;
        }
        // 对于对象类型，也返回非空类型（运行时使用nullptr表示null）
        return nonNullType;
      }

      // 基础类型映射
      if (CppConstants.typeMapping.containsKey(className)) {
        String cppType = CppConstants.typeMapping[className]!;

        // 泛型类型处理 - 递归转换泛型参数，确保嵌套类型也正确包装
        if (type.typeArguments.isNotEmpty) {
          final typeArgs =
              type.typeArguments.map((arg) => convertType(arg)).join(', ');
          cppType = '$cppType<$typeArgs>';
        }

        // 异步类型处理
        if (isAsync && className == 'Future') {
          return cppType;
        }

        // 检查是否需要ObjectPtr包装
        // 容器类型（List、Set、Map等）和自定义类型都需要包装
        if (_needsObjectPtr(className)) {
          return 'ObjectPtr<$cppType>';
        }
        return cppType;
      }

      // 自定义类型 - 只有非基本类型才用 ObjectPtr 包装
      if (_isBasicType(className)) {
        return className;
      }
      return 'ObjectPtr<$className>';
    } else if (type is FunctionType) {
      // 改进的函数类型转换，生成具体的 std::function 类型
      return _convertFunctionType(type);
    } else if (type is VoidType) {
      return 'Nullable';
    } else if (type is DynamicType) {
      return 'Any';
    } else if (type is TypeParameterType) {
      // 泛型参数类型 - 保持原样，由具体实例化时确定
      return type.parameter.name ?? 'T';
    }

    return 'Any'; // 默认类型
  }

  static String convertLiteral(dynamic value) {
    if (value is String) {
      // Escape special characters in strings
      final escaped = value
          .replaceAll('\\', '\\\\') // Backslash must be first
          .replaceAll('"', '\\"') // Double quote
          .replaceAll('\n', '\\n') // Newline
          .replaceAll('\r', '\\r') // Carriage return
          .replaceAll('\t', '\\t') // Tab
          .replaceAll('\$', '\\\$'); // Dollar sign (for string interpolation)
      return 'dart_string("$escaped")';
    } else if (value is int) {
      return 'dart_int($value)';
    } else if (value is double) {
      return 'dart_double($value)';
    } else if (value is bool) {
      return 'dart_bool($value)';
    }
    return value.toString();
  }

  static bool _needsObjectPtr(String className) {
    // 基本类型不需要ObjectPtr包装
    return !_isBasicType(className);
  }

  /// 检查是否是基本类型 - 使用全局统一定义
  static bool _isBasicType(String className) {
    return TypeAnalyzer.isBasicType(className);
  }

  /// 转换函数类型为 ObjectPtr<TypedFunction<...>>
  /// 使用TypeFunction类型进行参数传递
  static String _convertFunctionType(FunctionType type) {
    final returnType = convertType(type.returnType);

    // 处理位置参数 - 确保参数类型也正确转换（包括 ObjectPtr 包装）
    final positionalParams =
        type.positionalParameters.map((param) => convertType(param)).toList();

    // 处理命名参数（转换为额外的位置参数）- 确保参数类型也正确转换
    final namedParams =
        type.namedParameters.map((param) => convertType(param.type)).toList();

    // 合并所有参数
    final allParams = [...positionalParams, ...namedParams];

    // 构造 std::function 类型作为 TypedFunction 的第一个模板参数
    String stdFunctionType;
    if (allParams.isEmpty) {
      stdFunctionType = 'std::function<$returnType()>';
    } else {
      final paramTypes = allParams.join(', ');
      stdFunctionType = 'std::function<$returnType($paramTypes)>';
    }

    // 生成 ObjectPtr<TypedFunction<F, ReturnType, Args...>> 格式
    // 使用TypeFunction类型替代原来的复杂模板参数
    if (allParams.isEmpty) {
      return 'ObjectPtr<TypedFunction<$stdFunctionType, $returnType>>';
    } else {
      final paramTypes = allParams.join(', ');
      return 'ObjectPtr<TypedFunction<$stdFunctionType, $returnType, $paramTypes>>';
    }
  }
}

class ExpressionConverter {
  final DartToCppTransformer transformer;
  final CppStatementConverter statementConverter;
  final Map<VariableDeclaration, String> _letVariableMap = {};
  final Map<Expression, String> _expressionTypeCache = {};

  ExpressionConverter(this.transformer, this.statementConverter);

  String convertExpression(Expression expr) {
    // 优先级1：字面量表达式（最常用，最快）
    if (expr is StringLiteral)
      return CppTypeConverter.convertLiteral(expr.value);
    if (expr is IntLiteral) return _convertIntLiteralWithTypeInference(expr);
    if (expr is DoubleLiteral)
      return CppTypeConverter.convertLiteral(expr.value);
    if (expr is BoolLiteral) return CppTypeConverter.convertLiteral(expr.value);
    if (expr is NullLiteral) return 'Null';

    // 优先级2：变量访问（非常常用）
    if (expr is VariableGet) return _convertVariableGet(expr);
    if (expr is ThisExpression) return 'this';

    // 优先级3：方法调用（最复杂，需要特殊处理）
    if (expr is InstanceInvocation) return _convertInstanceInvocation(expr);
    if (expr is StaticInvocation) return _convertStaticInvocation(expr);
    if (expr is ConstructorInvocation)
      return _convertConstructorInvocation(expr);

    // 优先级4：属性访问
    if (expr is InstanceGet) return _convertInstanceGet(expr);
    if (expr is InstanceSet) return _convertInstanceSet(expr);

    // 优先级5：集合字面量
    if (expr is ListLiteral) return _convertListLiteral(expr);
    if (expr is SetLiteral) return _convertSetLiteral(expr);
    if (expr is MapLiteral) return _convertMapLiteral(expr);

    // 优先级6：逻辑和条件表达式
    if (expr is LogicalExpression) return _convertLogicalExpression(expr);
    if (expr is ConditionalExpression)
      return _convertConditionalExpression(expr);
    if (expr is Not) return '!(${convertExpression(expr.operand)})';

    // 优先级7：其他表达式类型
    return _convertOtherExpression(expr);
  }

  String _convertVariableGet(VariableGet expr) {
    // 检查是否是 Let 变量
    if (_letVariableMap.containsKey(expr.variable)) {
      return _letVariableMap[expr.variable]!;
    }

    // 清理变量名，移除无效的前缀字符
    String varName = expr.variable.name ?? 'unnamed_var';
    if (varName.startsWith(':')) {
      varName = varName.substring(1);
    }
    varName = _sanitizeIdentifier(varName);

    // 特殊处理dynamic类型的变量
    if (expr.variable.type is DynamicType) {
      // 对于dynamic类型变量，我们会在使用时进行特殊处理
      // 但变量名本身不需要改变
      return varName;
    }

    return varName;
  }

  String _convertOtherExpression(Expression expr) {
    // 处理其他不太常用的表达式类型
    if (expr is SymbolLiteral) return _convertSymbolLiteral(expr);
    if (expr is TypeLiteral) return _convertTypeLiteral(expr);
    if (expr is VariableSet) return _convertVariableSet(expr);
    if (expr is DynamicGet) return _convertDynamicGet(expr);
    if (expr is DynamicSet) return _convertDynamicSet(expr);
    if (expr is InstanceTearOff) return _convertInstanceTearOff(expr);
    if (expr is StaticGet) return _convertStaticGet(expr);
    if (expr is StaticSet) return _convertStaticSet(expr);
    if (expr is StaticTearOff) return _convertStaticTearOff(expr);
    if (expr is SuperPropertyGet) return _convertSuperPropertyGet(expr);
    if (expr is SuperPropertySet) return _convertSuperPropertySet(expr);
    if (expr is DynamicInvocation) return _convertDynamicInvocation(expr);
    if (expr is FunctionInvocation) return _convertFunctionInvocation(expr);
    if (expr is LocalFunctionInvocation)
      return _convertLocalFunctionInvocation(expr);
    if (expr is SuperMethodInvocation)
      return _convertSuperMethodInvocation(expr);
    if (expr is EqualsCall) return _convertEqualsCall(expr);
    if (expr is EqualsNull) return _convertEqualsNull(expr);
    if (expr is IsExpression) return _convertIsExpression(expr);
    if (expr is AsExpression) return _convertAsExpression(expr);
    if (expr is NullCheck) return _convertNullCheck(expr);
    if (expr is StringConcatenation) return _convertStringConcatenation(expr);
    if (expr is Throw) return _convertThrow(expr);
    if (expr is Rethrow) return 'throw';
    if (expr is AwaitExpression)
      return 'DART_AWAIT(${convertExpression(expr.operand)})';
    if (expr is FunctionExpression) return _convertFunctionExpression(expr);
    if (expr is Let) return _convertLet(expr);
    if (expr is Instantiation) return _convertInstantiation(expr);
    if (expr is LoadLibrary) return 'Future<void>::completed()';
    if (expr is CheckLibraryIsLoaded) return '/* Library check */';
    if (expr is ConstantExpression) return _convertConstantExpression(expr);
    if (expr is InvalidExpression) return '/* Invalid: ${expr.message} */';
    if (expr is BlockExpression) return _convertBlockExpression(expr);

    // 修复#19: 展开操作符支持
    if (expr is ListConcatenation) return _convertListConcatenation(expr);
    if (expr is SetConcatenation) return _convertSetConcatenation(expr);
    if (expr is MapConcatenation) return _convertMapConcatenation(expr);

    return '/* TODO: ${expr.runtimeType} */';
  }

  /// 类型推断：推断表达式的实际类型
  String _inferExpressionType(Expression expr) {
    if (_expressionTypeCache.containsKey(expr)) {
      return _expressionTypeCache[expr]!;
    }

    String inferredType;

    if (expr is StringLiteral) {
      inferredType = 'String';
    } else if (expr is IntLiteral) {
      inferredType = 'int';
    } else if (expr is DoubleLiteral) {
      inferredType = 'double';
    } else if (expr is BoolLiteral) {
      inferredType = 'bool';
    } else if (expr is NullLiteral) {
      inferredType = 'Null';
    } else if (expr is VariableGet) {
      // 从变量类型推断
      final type = expr.promotedType ?? expr.variable.type;
      if (type is InterfaceType) {
        inferredType = type.classNode.name;
      } else {
        inferredType = 'dynamic';
      }
    } else if (expr is InstanceInvocation) {
      // 从方法调用推断返回类型
      final target = expr.interfaceTarget;
      if (target is Procedure) {
        final returnType = target.function.returnType;
        if (returnType is InterfaceType) {
          inferredType = returnType.classNode.name;
        } else {
          inferredType = 'dynamic';
        }
      } else {
        inferredType = _inferBinaryOperationType(expr);
      }
    } else if (expr is ConditionalExpression) {
      // 三元表达式：推断 then 和 else 分支的公共类型
      final thenType = _inferExpressionType(expr.then);
      final elseType = _inferExpressionType(expr.otherwise);
      inferredType = _findCommonType(thenType, elseType);
    } else {
      inferredType = 'dynamic';
    }

    _expressionTypeCache[expr] = inferredType;
    return inferredType;
  }

  /// 推断二元运算的结果类型
  String _inferBinaryOperationType(InstanceInvocation expr) {
    final methodName = expr.name.text;
    final leftType = _inferExpressionType(expr.receiver);

    if (expr.arguments.positional.isNotEmpty) {
      final rightType = _inferExpressionType(expr.arguments.positional.first);

      // 算术运算类型推断规则
      if (_isArithmeticOperator(methodName)) {
        return _inferArithmeticResultType(leftType, rightType);
      }

      // 比较运算返回 bool
      if (_isComparisonOperator(methodName)) {
        return 'bool';
      }

      // 字符串连接
      if (methodName == '+' &&
          (leftType == 'String' || rightType == 'String')) {
        return 'String';
      }
    }

    return leftType; // 默认返回左操作数类型
  }

  /// 推断算术运算结果类型
  String _inferArithmeticResultType(String leftType, String rightType) {
    // double + any_number -> double
    if (leftType == 'double' || rightType == 'double') {
      return 'double';
    }

    // int + int -> int
    if (leftType == 'int' && rightType == 'int') {
      return 'int';
    }

    // 默认为 double（更安全的选择）
    return 'double';
  }

  /// 找到两个类型的公共类型
  String _findCommonType(String type1, String type2) {
    if (type1 == type2) return type1;

    // 数值类型的公共类型推断
    if (_isNumericType(type1) && _isNumericType(type2)) {
      if (type1 == 'double' || type2 == 'double') {
        return 'double';
      }
      return 'int';
    }

    return 'dynamic'; // 无法确定公共类型时使用 dynamic
  }

  /// 检查是否是算术运算符
  bool _isArithmeticOperator(String op) {
    return const {'+', '-', '*', '/', '%', '~/'}.contains(op);
  }

  /// 检查是否是比较运算符
  bool _isComparisonOperator(String op) {
    return const {'==', '!=', '<', '>', '<=', '>='}.contains(op);
  }

  /// 检查是否是数值类型
  bool _isNumericType(String type) {
    return const {'int', 'double', 'num'}.contains(type);
  }

  /// 带类型推断的整数字面量转换
  String _convertIntLiteralWithTypeInference(IntLiteral expr) {
    // 检查上下文是否需要 double 类型
    if (_shouldConvertToDouble(expr)) {
      return 'dart_double(${expr.value}.0)';
    }
    return CppTypeConverter.convertLiteral(expr.value);
  }

  /// 判断整数字面量是否应该转换为 double
  bool _shouldConvertToDouble(IntLiteral expr) {
    // 查找父表达式来判断上下文
    return _isInDoubleContext(expr);
  }

  /// 检查表达式是否在 double 上下文中
  bool _isInDoubleContext(Expression expr) {
    // 这里可以通过遍历 AST 父节点来判断上下文
    // 简化实现：检查是否与 double 类型进行运算

    // 注意：这是一个简化的实现，实际应该通过 AST 遍历来获取父节点信息
    // 在实际使用中，可能需要在转换过程中维护上下文信息

    return false; // 默认不转换，避免过度转换
  }

  /// 带类型推断的算术运算转换
  String _convertArithmeticOperation(InstanceInvocation expr, String receiver,
      String right, String methodName) {
    final leftType = _inferExpressionType(expr.receiver);
    final rightType = _inferExpressionType(expr.arguments.positional.first);

    // 只有当涉及字面量时才进行类型转换
    // 变量之间不进行自动类型转换
    if (_hasMixedTypesWithLiterals(
        expr.receiver, expr.arguments.positional.first, leftType, rightType)) {
      final convertedReceiver =
          _convertLiteralIfNeeded(expr.receiver, receiver, leftType, rightType);
      final convertedRight = _convertLiteralIfNeeded(
          expr.arguments.positional.first, right, rightType, leftType);

      final operatorMethodName =
          transformer._convertOperatorMethodName(methodName);
      return '$convertedReceiver->$operatorMethodName($convertedRight)';
    }

    // 默认处理 - 不进行类型转换
    final operatorMethodName =
        transformer._convertOperatorMethodName(methodName);
    return '$receiver->$operatorMethodName($right)';
  }

  /// 检查是否有混合类型且涉及字面量
  bool _hasMixedTypesWithLiterals(
      Expression left, Expression right, String leftType, String rightType) {
    // 只有在类型不同且至少有一个是字面量时才返回 true
    if (leftType == rightType) return false;

    final hasLiteral = (left is IntLiteral || left is DoubleLiteral) ||
        (right is IntLiteral || right is DoubleLiteral);

    final hasMixedNumericTypes =
        _isNumericType(leftType) && _isNumericType(rightType);

    return hasLiteral && hasMixedNumericTypes;
  }

  /// 仅在需要时转换字面量类型
  String _convertLiteralIfNeeded(Expression expr, String convertedExpr,
      String currentType, String otherType) {
    // 只转换字面量，不转换变量
    if (expr is IntLiteral && otherType == 'double') {
      // 整数字面量 + double变量 -> 将整数字面量转换为 double
      return 'dart_double(${expr.value}.0)';
    }

    // 其他情况保持不变
    return convertedExpr;
  }

  String _convertStaticInvocation(StaticInvocation expr) {
    final target = expr.target;
    final methodName = target.name.text;

    // 修复#18: 处理工厂构造函数调用
    if (target.isFactory) {
      final className = target.enclosingClass!.name;
      final args = _convertArguments(expr.arguments, target.function);
      // 工厂构造函数转换为静态方法调用
      // 默认工厂构造函数使用 'create'，命名工厂使用原名称
      final factoryName =
          methodName.isEmpty ? 'create' : _sanitizeIdentifier(methodName);
      return '$className::$factoryName($args)';
    }

    // 处理特殊的静态方法调用
    if (methodName == 'print') {
      final arg = convertExpression(expr.arguments.positional.first);
      return 'dart_print($arg)';
    }

    // 处理数学函数
    if (target.enclosingClass?.name == 'dart.math') {
      final args = expr.arguments.positional
          .map((arg) => convertExpression(arg))
          .join(', ');
      return 'dart_math_$methodName($args)';
    }

    // 修复问题1A: 增强处理内部List构造函数调用
    // 处理 _GrowableList::_literalN 和其他内部List类型
    final enclosingClassName = target.enclosingClass?.name ?? '';
    if (enclosingClassName == '_GrowableList' ||
        enclosingClassName == '_List' ||
        (enclosingClassName.startsWith('_') &&
            methodName.startsWith('_literal'))) {
      final args = expr.arguments.positional
          .map((arg) => convertExpression(arg))
          .join(', ');
      // 转换为dart_literal调用
      return 'dart_literal($args)';
    }

    // 也处理直接调用 _literalN 的情况
    if (methodName.startsWith('_literal')) {
      final args = expr.arguments.positional
          .map((arg) => convertExpression(arg))
          .join(', ');
      return 'dart_literal($args)';
    }

    // 处理内部Set构造函数调用
    if (target.enclosingClass?.name == '_Set') {
      // 转换为标准的Set创建
      return 'Set<Any>::create()';
    }

    // 一般静态方法调用 - 使用目标函数信息进行参数补全
    final args = _convertArguments(expr.arguments, target.function);

    // 如果是顶级函数（没有enclosingClass），直接调用，不需要类名前缀
    if (target.enclosingClass == null) {
      return '$methodName($args)';
    }

    final className = target.enclosingClass!.name;
    return '${className}::$methodName($args)';
  }

  String _convertInstanceInvocation(InstanceInvocation expr) {
    final receiver = convertExpression(expr.receiver);
    final originalMethodName = expr.name.text;
    final methodName = _fixMethodName(expr.receiver, originalMethodName);

    // 检查是否是扩展方法调用 - 通用转换为静态方法
    final receiverType = transformer._getReceiverType(expr.receiver);
    if (receiverType != null &&
        transformer._isExtensionMethod(receiverType, methodName)) {
      return transformer._convertExtensionMethodCall(
          receiverType, methodName, receiver, expr.arguments);
    }

    // 特殊处理：Dart 迭代器 API 映射到 C++ Iterator API
    if (methodName == 'moveNext') {
      // Dart 的 moveNext() 映射到 C++ 的 hasNext()
      return '$receiver->hasNext()';
    }

    // 处理一元负号运算符
    if (methodName == 'unary-') {
      // 对于字面量，直接在字面量阶段处理
      if (expr.receiver is IntLiteral) {
        final value = (expr.receiver as IntLiteral).value;
        return 'dart_int(${-value})';
      } else if (expr.receiver is DoubleLiteral) {
        final value = (expr.receiver as DoubleLiteral).value;
        return 'dart_double(${-value})';
      }
      // 对于其他表达式，使用operator_negate方法
      return '$receiver->operator_negate()';
    }

    // 处理一元取反运算符
    if (methodName == '~') {
      return '$receiver->operator_bitwise_not()';
    }

    // 处理整数除法运算符 ~/
    if (methodName == '~/') {
      final right = convertExpression(expr.arguments.positional.first);
      return '$receiver->truncatingDivision($right)';
    }

    // 处理位运算符
    if (methodName == '&') {
      final right = convertExpression(expr.arguments.positional.first);
      return '$receiver->operator_bitwise_and($right)';
    }

    if (methodName == '|') {
      final right = convertExpression(expr.arguments.positional.first);
      return '$receiver->operator_bitwise_or($right)';
    }

    if (methodName == '^') {
      final right = convertExpression(expr.arguments.positional.first);
      return '$receiver->operator_bitwise_xor($right)';
    }

    if (methodName == '<<') {
      final right = convertExpression(expr.arguments.positional.first);
      return '$receiver->operator_shift_left($right)';
    }

    if (methodName == '>>') {
      final right = convertExpression(expr.arguments.positional.first);
      return '$receiver->operator_shift_right($right)';
    }

    // 修复#10: String 乘法运算 - 转换为 repeat 方法调用
    if (methodName == '*') {
      final receiverTypeName = transformer._getReceiverType(expr.receiver);
      if (receiverTypeName == 'String') {
        final times = convertExpression(expr.arguments.positional.first);
        return '$receiver->repeat($times)';
      }
    }

    // 处理数组访问操作符
    if (methodName == '[]') {
      final index = convertExpression(expr.arguments.positional.first);
      return '$receiver->operator_index($index)';
    }

    if (methodName == '[]=') {
      final index = convertExpression(expr.arguments.positional.first);
      final value = convertExpression(expr.arguments.positional[1]);
      return '$receiver->operator_index_set($index, $value)';
    }

    // 运算符重载处理 - 带类型推断的转换
    if (CppConstants.operatorMapping.containsKey(methodName)) {
      final operator = CppConstants.operatorMapping[methodName]!;

      if (expr.arguments.positional.isNotEmpty) {
        final rightExpr = expr.arguments.positional.first;
        final right = convertExpression(rightExpr);

        // 类型推断：检查运算结果类型并进行必要的类型转换
        if (_isArithmeticOperator(methodName)) {
          return _convertArithmeticOperation(expr, receiver, right, methodName);
        }

        // 统一使用 operator_ 方法调用（包括基础类型和自定义类）
        if (transformer._isOperatorMethod(methodName)) {
          final operatorMethodName =
              transformer._convertOperatorMethodName(methodName);
          return '$receiver->$operatorMethodName($right)';
        }

        // 对于非运算符的特殊操作（如 dart_ 开头的辅助函数）
        if (operator.startsWith('dart_')) {
          return '$operator($receiver, $right)';
        } else {
          // 默认也转换为函数调用
          final operatorMethodName =
              transformer._convertOperatorMethodName(methodName);
          return '$receiver->$operatorMethodName($right)';
        }
      } else {
        // 一元运算符
        if (transformer._isOperatorMethod(methodName)) {
          final operatorMethodName =
              transformer._convertOperatorMethodName(methodName);
          return '$receiver->$operatorMethodName()';
        }
        return '($operator$receiver)';
      }
    }

    // 特殊处理dynamic类型变量的方法调用
    if (expr.receiver is VariableGet &&
        (expr.receiver as VariableGet).variable.type is DynamicType) {
      // 对于dynamic类型变量，使用特殊的宏来调用方法
      final args = expr.arguments.positional
          .map((arg) => convertExpression(arg))
          .join(', ');

      // 如果有参数，使用带参数的宏
      if (args.isNotEmpty) {
        return 'DART_ANY_CALL($receiver, $methodName)($args)';
      } else {
        return 'DART_ANY_CALL($receiver, $methodName)';
      }
    }

    // Future 链式调用特殊处理
    if (transformer._isFutureType(expr.receiver)) {
      return transformer._convertFutureChainCall(
          expr.receiver, methodName, expr.arguments);
    }

    // 集合类型也使用统一的方法调用处理

    final args = expr.arguments.positional
        .map((arg) => convertExpression(arg))
        .join(', ');

    // 统一使用 -> 调用
    return '$receiver->$methodName($args)';
  }

  String _convertConditionalExpression(ConditionalExpression expr) {
    final condition = convertExpression(expr.condition);

    // 修复#8: 啴处理 is 类型判断的智能类型转换
    // 如果条件是 is 表达式，在 then 分支中自动进行类型转换
    if (expr.condition is IsExpression) {
      final isExpr = expr.condition as IsExpression;
      final thenExpr = _convertExpressionWithIsTypeContext(expr.then, isExpr);
      final elseExpr = convertExpression(expr.otherwise);
      return '$condition ? $thenExpr : $elseExpr';
    }

    // 处理负 is 表达式 (!is)
    if (expr.condition is Not &&
        (expr.condition as Not).operand is IsExpression) {
      final isExpr = (expr.condition as Not).operand as IsExpression;
      // else 分支中进行类型转换
      final thenExpr = convertExpression(expr.then);
      final elseExpr =
          _convertExpressionWithIsTypeContext(expr.otherwise, isExpr);
      return '$condition ? $thenExpr : $elseExpr';
    }

    final thenExpr = convertExpression(expr.then);
    final elseExpr = convertExpression(expr.otherwise);
    return '$condition ? $thenExpr : $elseExpr';
  }

  /// 在 is 类型上下文中转换表达式（修复#8）
  /// 当表达式使用 is 检查的变量时，自动进行类型转换
  String _convertExpressionWithIsTypeContext(
      Expression expr, IsExpression typeContext) {
    // 检查是否是直接访问 is 表达式中的变量
    if (_isSameVariable(expr, typeContext.operand)) {
      final targetType = CppTypeConverter.convertType(typeContext.type);
      final varName = convertExpression(typeContext.operand);
      return 'dart_cast<$targetType>($varName)';
    }

    // 检查是否是对 is 表达式中变量的成员访问
    if (expr is InstanceGet) {
      if (_isSameVariable(expr.receiver, typeContext.operand)) {
        final targetType = CppTypeConverter.convertType(typeContext.type);
        final varName = convertExpression(typeContext.operand);
        final propName = expr.name.text;
        return 'dart_cast<$targetType>($varName)->$propName';
      }
    }

    // 检查是否是对 is 表达式中变量的方法调用
    if (expr is InstanceInvocation) {
      if (_isSameVariable(expr.receiver, typeContext.operand)) {
        final targetType = CppTypeConverter.convertType(typeContext.type);
        final varName = convertExpression(typeContext.operand);
        final methodName = expr.name.text;
        final args = _convertArguments(expr.arguments);
        return 'dart_cast<$targetType>($varName)->$methodName($args)';
      }
    }

    // 递归处理三元表达式
    if (expr is ConditionalExpression) {
      final cond = convertExpression(expr.condition);
      final thenPart =
          _convertExpressionWithIsTypeContext(expr.then, typeContext);
      final elsePart =
          _convertExpressionWithIsTypeContext(expr.otherwise, typeContext);
      return '$cond ? $thenPart : $elsePart';
    }

    // 递归处理二元操作
    if (expr is InstanceInvocation && _isOperatorMethod(expr.name.text)) {
      final left =
          _convertExpressionWithIsTypeContext(expr.receiver, typeContext);
      final right = _convertExpressionWithIsTypeContext(
          expr.arguments.positional[0], typeContext);
      final op = expr.name.text;
      if (op == '+' || op == '-' || op == '*' || op == '/') {
        return '$left $op $right';
      } else if (op == '==') {
        return '($left == $right)';
      }
    }

    // 默认返回普通转换
    return convertExpression(expr);
  }

  bool _isOperatorMethod(String name) {
    return {'+', '-', '*', '/', '%', '==', '!=', '<', '<=', '>', '>='}
        .contains(name);
  }

  String _convertLogicalExpression(LogicalExpression expr) {
    final left = convertExpression(expr.left);
    final right = convertExpression(expr.right);
    final operator =
        expr.operatorEnum == LogicalExpressionOperator.AND ? '&&' : '||';

    // 处理 "other is Vector && xxx" 模式的智能类型转换
    if (expr.operatorEnum == LogicalExpressionOperator.AND &&
        expr.left is IsExpression) {
      final isExpr = expr.left as IsExpression;
      final rightConverted =
          _convertExpressionWithTypeContext(expr.right, isExpr);
      return '$left && $rightConverted';
    }

    return '$left $operator $right';
  }

  /// 在类型上下文中转换表达式，处理智能类型转换
  String _convertExpressionWithTypeContext(
      Expression expr, IsExpression typeContext) {
    if (expr is LogicalExpression &&
        expr.operatorEnum == LogicalExpressionOperator.AND) {
      // 递归处理嵌套的逻辑表达式
      final leftConverted =
          _convertExpressionWithTypeContext(expr.left, typeContext);
      final rightConverted =
          _convertExpressionWithTypeContext(expr.right, typeContext);
      return '$leftConverted && $rightConverted';
    }

    if (expr is InstanceInvocation && expr.name.text == '==') {
      // 处理 x == other.x 模式
      return _convertEqualityWithTypeContext(expr, typeContext);
    }

    return convertExpression(expr);
  }

  /// 处理带类型上下文的相等比较
  String _convertEqualityWithTypeContext(
      InstanceInvocation expr, IsExpression typeContext) {
    final left = convertExpression(expr.arguments.positional[0]);
    final receiver = convertExpression(expr.receiver);

    // 检查是否是对类型检查变量的成员访问
    if (expr.arguments.positional[0] is InstanceGet) {
      final propGet = expr.arguments.positional[0] as InstanceGet;
      if (_isSameVariable(propGet.receiver, typeContext.operand)) {
        // 这是对类型检查变量的访问，需要进行类型转换
        final targetType = CppTypeConverter.convertType(typeContext.type);
        final varName = convertExpression(typeContext.operand);
        final propName = propGet.name.text;
        final castVar = 'dart_cast<$targetType>($varName)';
        return '($receiver == $castVar->$propName)';
      }
    }

    return '$receiver->operator_eq($left)';
  }

  /// 检查两个表达式是否引用同一个变量
  bool _isSameVariable(Expression? expr1, Expression expr2) {
    if (expr1 is VariableGet && expr2 is VariableGet) {
      return expr1.variable == expr2.variable;
    }
    return false;
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
      return 'ObjectPtr<Set<$elementType>>(new Set<$elementType>())';
    }
    final elements =
        expr.expressions.map((e) => convertExpression(e)).join(', ');
    return 'ObjectPtr<Set<$elementType>>(new Set<$elementType>({$elements}))';
  }

  // 修复#19: 展开操作符支持
  String _convertListConcatenation(ListConcatenation expr) {
    final elementType = CppTypeConverter.convertType(expr.typeArgument);
    if (expr.lists.isEmpty) {
      return 'List<$elementType>::create()';
    }
    if (expr.lists.length == 1) {
      return convertExpression(expr.lists.first);
    }
    // 使用 dart_spread 函数合并多个列表
    final lists = expr.lists.map((e) => convertExpression(e)).join(', ');
    return 'dart_spread<$elementType>($lists)';
  }

  String _convertSetConcatenation(SetConcatenation expr) {
    final elementType = CppTypeConverter.convertType(expr.typeArgument);
    if (expr.sets.isEmpty) {
      return 'Set<$elementType>::create()';
    }
    if (expr.sets.length == 1) {
      return convertExpression(expr.sets.first);
    }
    // 使用 dart_spread_set 函数合并多个集合
    final sets = expr.sets.map((e) => convertExpression(e)).join(', ');
    return 'dart_spread_set<$elementType>($sets)';
  }

  String _convertMapConcatenation(MapConcatenation expr) {
    final keyType = CppTypeConverter.convertType(expr.keyType);
    final valueType = CppTypeConverter.convertType(expr.valueType);
    if (expr.maps.isEmpty) {
      return 'Map<$keyType, $valueType>::create()';
    }
    if (expr.maps.length == 1) {
      return convertExpression(expr.maps.first);
    }
    // 使用 dart_spread_map 函数合并多个映射
    final maps = expr.maps.map((e) => convertExpression(e)).join(', ');
    return 'dart_spread_map<$keyType, $valueType>($maps)';
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

    // 特殊处理dynamic类型变量的赋值
    // 如果变量是dynamic类型，需要确保赋值兼容Any类型
    if (expr.variable.type is DynamicType) {
      // 对于dynamic类型变量，直接赋值即可，因为Any可以接受任何类型
      return '$varName = $value';
    }

    return '$varName = $value';
  }

  String _convertInstanceGet(InstanceGet expr) {
    final receiver = convertExpression(expr.receiver);
    final memberName = expr.name.text;

    // 特殊处理dynamic类型变量的成员访问
    if (expr.receiver is VariableGet &&
        (expr.receiver as VariableGet).variable.type is DynamicType) {
      // 对于dynamic类型变量，使用特殊的宏来访问成员
      // 这样可以避免编译时类型检查错误
      return 'DART_ANY_CALL($receiver, $memberName)';
    }

    // 特殊处理：Dart 迭代器 API 映射到 C++ Iterator API
    if (memberName == 'current') {
      // Dart 的 current getter 映射到 C++ 的 next() 方法
      return '$receiver->next()';
    }

    // 特殊处理：某些getter需要作为方法调用
    final methodLikeGetters = {
      'isEmpty',
      'isNotEmpty',
      'iterator',
      'first',
      'last',
      'single',
      'reversed'
    };

    // Future 特殊方法处理
    if (transformer._isFutureType(expr.receiver)) {
      return transformer._convertFutureMethod(expr.receiver, memberName);
    }

    // 智能类型推断：区分属性访问和getter方法调用
    // 使用 interfaceTarget 来判断是字段还是 getter
    final isRealProperty = _isRealProperty(expr);

    // 统一使用 -> 访问
    // 对于 List、Set、Map 等容器类型，length 转换为 size()
    if (memberName == 'length') {
      return '$receiver->size()';
    }
    // 某些getter需要作为方法调用
    if (methodLikeGetters.contains(memberName)) {
      return '$receiver->$memberName()';
    }
    // 根据类型推断决定是属性访问还是getter调用
    if (isRealProperty) {
      return '$receiver->$memberName'; // 直接属性访问
    } else {
      return '$receiver->$memberName()'; // getter方法调用
    }
  }

  String _convertInstanceSet(InstanceSet expr) {
    final receiver = convertExpression(expr.receiver);
    final memberName = expr.name.text;
    final value = convertExpression(expr.value);

    // 使用 interfaceTarget 判断是字段还是 setter
    final target = expr.interfaceTarget;
    final isRealField = target is Field;

    // 统一使用 -> 访问
    if (isRealField) {
      return '$receiver->$memberName = $value'; // 直接字段赋值
    } else {
      return '$receiver->set_$memberName($value)'; // setter 方法调用
    }
  }

  /// 判断表达式的类型是否是自定义类（而不是基础类型）
  bool _isCustomClass(Expression expr) {
    // 基础类型列表
    const basicTypes = {
      'int',
      'double',
      'bool',
      'String',
      'Int',
      'Double',
      'Bool',
      'List',
      'Set',
      'Map',
      'Object',
      'Null',
      'dynamic',
      'Future',
      'Stream',
      'StringBuffer',
      'RegExp',
      'Timer',
    };

    // 尝试从 interfaceTarget 获取返回类型信息（对于 InstanceInvocation - 方法调用）
    if (expr is InstanceInvocation) {
      final target = expr.interfaceTarget;
      if (target is Procedure) {
        // 获取方法的返回类型，而不是方法所属的类
        final returnType = target.function.returnType;
        if (returnType is InterfaceType) {
          final className = returnType.classNode.name;
          return !basicTypes.contains(className);
        }
      }
    }

    // 尝试从 interfaceTarget 获取字段类型信息（对于 InstanceGet）
    if (expr is InstanceGet) {
      final target = expr.interfaceTarget;
      if (target is Field) {
        // 获取字段的类型
        final fieldType = target.type;
        if (fieldType is InterfaceType) {
          final className = fieldType.classNode.name;
          return !basicTypes.contains(className);
        }
      } else if (target is Procedure && target.enclosingClass != null) {
        // 对于 getter，获取返回类型
        final returnType = target.function.returnType;
        if (returnType is InterfaceType) {
          final className = returnType.classNode.name;
          return !basicTypes.contains(className);
        }
      }
    }

    // 对于其他表达式，使用保守策略：假设不是自定义类
    return false;
  }

  // 辅助方法：判断表达式是否可能是值类型
  bool _isLikelyValueType(Expression expr) {
    // 字面量肯定是值类型
    if (expr is IntLiteral ||
        expr is DoubleLiteral ||
        expr is BoolLiteral ||
        expr is StringLiteral) {
      return true;
    }

    // 检查静态调用是否是值类型构造
    if (expr is StaticInvocation) {
      final targetName = expr.target.name.text;
      if (targetName == 'dart_int' ||
          targetName == 'dart_double' ||
          targetName == 'dart_bool' ||
          targetName == 'dart_string') {
        return true;
      }
    }

    // 检查变量引用 - 通过类型和初始化表达式判断
    if (expr is VariableGet) {
      // 首先检查变量的初始化表达式
      if (expr.variable.initializer != null) {
        // 递归检查初始化表达式是否为值类型
        if (_isLikelyValueType(expr.variable.initializer!)) {
          return true;
        }
      }

      // 然后检查类型信息
      final type = expr.promotedType ?? expr.variable.type;
      final typeName = type.toString();
      // 基本值类型
      if (typeName == 'int' ||
          typeName == 'double' ||
          typeName == 'bool' ||
          typeName == 'String' ||
          typeName == 'Int' ||
          typeName == 'Double' ||
          typeName == 'Bool') {
        return true;
      }
    }

    // 检查实例调用的结果 - 如果是值类型的方法调用，结果也是值类型
    if (expr is InstanceInvocation) {
      // toString() 返回 String，是值类型
      if (expr.name.text == 'toString') {
        return true;
      }
      // 算术运算的结果是值类型
      if (_isLikelyValueType(expr.receiver)) {
        final methodName = expr.name.text;
        if (methodName == '+' ||
            methodName == '-' ||
            methodName == '*' ||
            methodName == '/' ||
            methodName == '%' ||
            methodName == '~/' ||
            methodName == 'truncatingDivision' ||
            methodName == 'operator_negate') {
          return true;
        }
      }
    }

    // 默认假设是对象类型（使用 ->）
    return false;
  }

  // 智能类型推断：判断是否为真实属性（而非getter方法）
  bool _isRealProperty(InstanceGet expr) {
    final memberName = expr.name.text;

    // 已知的getter方法（应该作为方法调用）
    final knownGetters = {
      'length',
      'size',
      'isEmpty',
      'isNotEmpty',
      'iterator',
      'first',
      'last',
      'single',
      'runtimeType',
      'hashCode'
    };

    if (knownGetters.contains(memberName)) {
      return false; // 这些是getter方法
    }

    // 关键：使用 interfaceTarget 来判断目标成员的类型
    final target = expr.interfaceTarget;

    // 如果 target 是 Field，说明是真实的字段
    if (target is Field) {
      return true; // 这是一个字段，直接访问
    }

    // 如果 target 是 Procedure，需要进一步判断
    if (target is Procedure) {
      // Getter 方法需要调用
      if (target.isGetter) {
        return false; // 这是 getter 方法
      }
      // 其他类型的 Procedure（如普通方法）也不是属性
      return false;
    }

    // 如果无法确定 target，检查接收者类型作为后备方案
    final receiver = expr.receiver;
    if (receiver is VariableGet) {
      final type = receiver.promotedType ?? receiver.variable.type;
      final typeName = type.toString();

      // 基础类型的成员都是方法
      if (typeName == 'int' ||
          typeName == 'double' ||
          typeName == 'bool' ||
          typeName == 'String' ||
          typeName == 'Int' ||
          typeName == 'Double' ||
          typeName == 'Bool' ||
          typeName.startsWith('List<') ||
          typeName.startsWith('Set<') ||
          typeName.startsWith('Map<')) {
        return false; // 基础类型成员都是方法
      }

      // 用户定义的类，如果无法确定，保守地假设是真实属性
      return true;
    }

    // 默认假设是getter方法
    return false;
  }

  // 修复方法名映射
  String _fixMethodName(Expression receiver, String memberName) {
    // String 类型的特殊方法映射
    if (receiver is VariableGet) {
      final type = receiver.promotedType ?? receiver.variable.type;
      final typeName = type.toString();

      if (typeName == 'String') {
        if (memberName == 'size') {
          return 'length'; // String.size() -> String.length()
        }
      }
    }

    return memberName; // 默认不修改
  }

  String _convertDynamicGet(DynamicGet expr) {
    final receiver = convertExpression(expr.receiver);
    final memberName = expr.name.text;

    // 特殊处理dynamic类型变量的成员访问
    // 如果接收者是dynamic类型，需要使用特殊的访问方式
    if (expr.receiver is VariableGet &&
        (expr.receiver as VariableGet).variable.type is DynamicType) {
      // 对于Any类型的变量，我们需要先进行类型转换再访问成员
      // 这里我们生成特殊的宏或函数调用来处理
      return '$receiver.$memberName';
    }

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
    // 使用 makeFunction 包装实例方法指针
    // 现在的 makeFunction 支持自动推导参数类型，不再需要指定具体类型
    return 'makeFunction(&$receiver->$memberName)';
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
    // 处理函数引用：使用 makeFunction 包装函数指针
    final target = expr.target;
    final className = target.enclosingClass?.name ?? '';
    final methodName = target.name.text;

    // 生成函数指针
    final functionPtr =
        className.isNotEmpty ? '&$className::$methodName' : '&$methodName';

    // 使用 makeFunction 包装函数指针
    // 现在的 makeFunction 支持自动推导参数类型，不再需要指定具体类型
    return 'makeFunction($functionPtr)';
  }

  String _convertSuperPropertyGet(SuperPropertyGet expr) {
    final memberName = expr.name.text;
    return 'this->$memberName()';
  }

  String _convertSuperPropertySet(SuperPropertySet expr) {
    final memberName = expr.name.text;
    final value = convertExpression(expr.value);
    return 'this->set_$memberName($value)';
  }

  String _convertDynamicInvocation(DynamicInvocation expr) {
    final receiver = convertExpression(expr.receiver);
    final methodName = expr.name.text;
    // 动态调用无法静态获取函数信息，使用原有逻辑
    final args = _convertArguments(expr.arguments);
    return '$receiver.$methodName($args)';
  }

  String _convertFunctionInvocation(FunctionInvocation expr) {
    final receiver = convertExpression(expr.receiver);
    // Function对象调用无法静态获取函数签名，使用原有逻辑
    final args = _convertArguments(expr.arguments);
    // 使用 call 方法直接调用 Function 对象
    // call 方法直接接受参数，不需要包装为 std::vector<Any>
    // 确保使用TypeFunction类型进行参数传递
    return '$receiver->call($args)';
  }

  String _convertLocalFunctionInvocation(LocalFunctionInvocation expr) {
    final functionName = expr.variable.name ?? 'unnamed_func';
    // 尝试获取函数节点信息进行参数补全
    FunctionNode? targetFunction;
    if (expr.variable.initializer is FunctionExpression) {
      targetFunction =
          (expr.variable.initializer as FunctionExpression).function;
    }
    final args = _convertArguments(expr.arguments, targetFunction);
    return '$functionName($args)';
  }

  String _convertSuperMethodInvocation(SuperMethodInvocation expr) {
    final methodName = expr.name.text;
    // 对于父类方法调用，暂时使用原有逻辑（需要更复杂的类型分析来获取父类方法信息）
    final args = _convertArguments(expr.arguments);
    return 'this->$methodName($args)';
  }

  String _convertEqualsCall(EqualsCall expr) {
    final left = convertExpression(expr.left);
    final right = convertExpression(expr.right);
    return '($left == $right)';
  }

  String _convertEqualsNull(EqualsNull expr) {
    final operand = convertExpression(expr.expression);
    return 'dart_is_null($operand)';
  }

  String _convertConstructorInvocation(ConstructorInvocation expr) {
    final className = expr.target.enclosingClass.name;
    // 对于无参构造函数，不进行参数补全
    final args =
        expr.arguments.positional.isEmpty && expr.arguments.named.isEmpty
            ? _convertArguments(expr.arguments)
            : _convertArguments(expr.arguments, expr.target.function);

    // 使用 TypeAnalyzer 判断是否需要 ObjectPtr
    final needsObjectPtr =
        transformer.typeAnalyzer.customClasses.contains(className) ||
            transformer.typeAnalyzer.containerTypes.contains(className);

    if (expr.isConst) {
      if (needsObjectPtr) {
        return 'ObjectPtr<$className>::createConst($args)';
      } else {
        return '$className::createConst($args)';
      }
    }

    // 修复内部类型名称
    final fixedClassName = className
        .replaceAll('_Set', 'Set')
        .replaceAll('_Map', 'Map')
        .replaceAll('_List', 'List');

    // 修复问题3A: 推导泛型参数
    // 对于 Set、List、Map 等容器类型，需要推导泛型参数
    String typeParams = '';
    if (expr.arguments.types.isNotEmpty) {
      // 使用构造函数调用提供的类型参数
      final types = expr.arguments.types
          .map((t) => CppTypeConverter.convertType(t))
          .join(', ');
      typeParams = '<$types>';
    }

    if (needsObjectPtr) {
      return 'ObjectPtr<$fixedClassName$typeParams>(new $fixedClassName$typeParams($args))';
    } else {
      return '$fixedClassName$typeParams($args)';
    }
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
    // NullCheck (obj!) 表示非空断言，直接返回表达式
    final operand = convertExpression(expr.operand);
    // 根据规则文档，obj! 转换为直接访问，不需要特殊处理
    return operand;
  }

  String _convertStringConcatenation(StringConcatenation expr) {
    if (expr.expressions.length == 1) {
      final converted = convertExpression(expr.expressions[0]);
      // 如果不是字符串类型，需要调用 toString()
      if (!_isStringExpression(expr.expressions[0])) {
        return '($converted).toString()';
      }
      return converted;
    }

    // 优化：连续的字符串字面量可以合并
    final optimizedParts = _optimizeStringParts(expr.expressions);

    if (optimizedParts.length == 1) {
      return optimizedParts[0];
    } else if (optimizedParts.length == 2) {
      // 两个部分直接用 + 连接
      return '${optimizedParts[0]} + ${optimizedParts[1]}';
    } else {
      // 多个部分使用 dart_concat
      return 'dart_concat(${optimizedParts.join(', ')})';
    }
  }

  /// 检查表达式是否是字符串类型
  bool _isStringExpression(Expression expr) {
    return expr is StringLiteral;
  }

  /// 优化字符串部分，合并连续的字符串字面量
  List<String> _optimizeStringParts(List<Expression> expressions) {
    final List<String> parts = [];
    String currentLiteralGroup = '';

    for (final expr in expressions) {
      if (expr is StringLiteral) {
        // 累积字符串字面量
        currentLiteralGroup += expr.value;
      } else {
        // 非字符串表达式，先处理累积的字面量
        if (currentLiteralGroup.isNotEmpty) {
          parts.add(CppTypeConverter.convertLiteral(currentLiteralGroup));
          currentLiteralGroup = '';
        }

        // 处理非字符串表达式
        final converted = convertExpression(expr);
        if (_isStringExpression(expr)) {
          parts.add(converted);
        } else {
          parts.add('($converted).toString()');
        }
      }
    }

    // 处理最后的字符串字面量
    if (currentLiteralGroup.isNotEmpty) {
      parts.add(CppTypeConverter.convertLiteral(currentLiteralGroup));
    }

    return parts;
  }

  String _convertThrow(Throw expr) {
    final operand = convertExpression(expr.expression);
    // 根据异常类型选择合适的 C++ 异常
    if (expr.expression is StringLiteral) {
      return 'throw std::runtime_error($operand.getValue())';
    } else {
      return 'throw DartException($operand)';
    }
  }

  String _convertFunctionExpression(FunctionExpression expr) {
    // 生成参数列表，使用具体类型（makeFunction 需要明确的类型才能正确推导）
    final params = expr.function.positionalParameters
        .map((p) => '${CppTypeConverter.convertType(p.type)} ${p.name}')
        .join(', ');

    // 生成 lambda 函数体
    String body = 'return Void;';
    if (expr.function.body != null) {
      body =
          transformer.statementConverter.convertStatement(expr.function.body!);
    }

    // 使用 makeFunction 创建 Function 对象
    // makeFunction 通过 std::function 的 CTAD 推导参数类型，需要明确的类型签名
    // 确保返回Void类型以符合Function规范
    return 'makeFunction([&]($params) { $body })';
  }

  String _convertLet(Let expr) {
    final varName = expr.variable.name ?? 'let_var';
    final value = convertExpression(expr.variable.initializer!);

    // 注册 Let 变量映射
    _letVariableMap[expr.variable] = varName;

    // 转换 body，此时 VariableGet 会使用映射的变量名
    final body = convertExpression(expr.body);

    // 清除映射
    _letVariableMap.remove(expr.variable);

    // 优化：检测空值合并模式 (value ?? default)
    // 如果 body 是三元表达式且形式为：dart_is_null(varName) ? default : varName
    // 则使用 dart_null_coalesce 宏
    if (body.contains('dart_is_null($varName)') &&
        body.contains('? ') &&
        body.contains(' : $varName')) {
      // 提取三元表达式的默认值部分
      final pattern = RegExp(r'dart_is_null\(' +
          RegExp.escape(varName) +
          r'\)\s*\?\s*(.+?)\s*:\s*' +
          RegExp.escape(varName));
      final match = pattern.firstMatch(body);
      if (match != null) {
        final defaultValue = match.group(1);
        // 使用 dart_null_coalesce 宏确保类型安全
        return 'dart_null_coalesce($value, $defaultValue)';
      }
    }

    // 默认：使用 auto 来自动推导类型，避免 Nullable 到具体类型的转换问题
    return '([&]() { auto $varName = $value; return $body; })()';
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
    } else if (constant is StaticTearOffConstant) {
      // 处理函数引用：使用 makeFunction 包装函数指针
      final target = constant.target;
      final functionName = target.name.text;
      // 现在的 makeFunction 支持自动推导参数类型，不再需要指定具体类型
      return 'makeFunction(&$functionName)';
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

  String _convertArguments(Arguments args, [FunctionNode? targetFunction]) {
    final positional =
        args.positional.map((a) => convertExpression(a)).toList();

    // 如果有目标函数信息，进行参数补全和重排
    if (targetFunction != null) {
      return _convertArgumentsWithFunction(args, targetFunction);
    }

    // 原有逻辑：命名参数直接添加注释
    final named = args.named
        .map((a) => '/*${a.name}:*/ ${convertExpression(a.value)}')
        .toList();
    return [...positional, ...named].join(', ');
  }

  String _convertArgumentsWithFunction(
      Arguments args, FunctionNode targetFunction) {
    final result = <String>[];

    // 1. 处理位置参数
    final totalPositional = targetFunction.positionalParameters.length;
    final requiredCount = targetFunction.requiredParameterCount;

    for (int i = 0; i < totalPositional; i++) {
      if (i < args.positional.length) {
        // 有提供的位置参数
        result.add(convertExpression(args.positional[i]));
      } else if (i >= requiredCount) {
        // 可选位置参数，优先使用默认值
        final param = targetFunction.positionalParameters[i];
        if (param.initializer != null) {
          result.add(convertExpression(param.initializer!));
        } else {
          final paramType = CppTypeConverter.convertType(param.type);
          if (paramType.startsWith('ObjectPtr<')) {
            result.add('nullptr');
          } else {
            result.add('$paramType(Null)');
          }
        }
      }
    }

    // 2. 处理命名参数 - 修复#14: 按函数定义顺序，使用默认值
    final namedArgsMap = <String, String>{};
    for (final namedArg in args.named) {
      namedArgsMap[namedArg.name] = convertExpression(namedArg.value);
    }

    for (final namedParam in targetFunction.namedParameters) {
      final paramName = namedParam.name ?? 'param';
      final paramType = CppTypeConverter.convertType(namedParam.type);

      if (namedArgsMap.containsKey(paramName)) {
        // 有提供的命名参数
        result.add(namedArgsMap[paramName]!);
      } else {
        // 未提供的命名参数，使用默认值
        if (namedParam.initializer != null) {
          // 使用参数的默认值
          result.add(convertExpression(namedParam.initializer!));
        } else {
          // 没有默认值，使用类型默认值
          if (paramType.startsWith('ObjectPtr<')) {
            result.add('nullptr');
          } else if (paramType == 'Int') {
            result.add('Int(0)');
          } else if (paramType == 'Double') {
            result.add('Double(0.0)');
          } else if (paramType == 'Bool') {
            result.add('Bool(false)');
          } else if (paramType == 'String') {
            result.add('String("")');
          } else {
            result.add('$paramType(Null)');
          }
        }
      }
    }

    return result.join(', ');
  }
}

/// 语句转换器
class CppStatementConverter {
  final DartToCppTransformer transformer;

  CppStatementConverter(this.transformer);

  String convertStatement(Statement stmt) {
    if (stmt is ExpressionStatement) {
      final exprCode =
          transformer.expressionConverter.convertExpression(stmt.expression);

      // 特殊处理：检测空值合并赋值运算符 ??= 的模式
      // 形式为: dart_is_null(var) ? var = value : Null
      // 转换为: if (dart_is_null(var)) var = value;
      final nullAssignPattern =
          RegExp(r'dart_is_null\((\w+)\)\s*\?\s*\1\s*=\s*(.+?)\s*:\s*Null');
      final match = nullAssignPattern.firstMatch(exprCode);
      if (match != null) {
        final varName = match.group(1);
        final value = match.group(2);
        return 'if (dart_is_null($varName)) $varName = $value;';
      }

      return exprCode + ';';
    } else if (stmt is VariableDeclaration) {
      return _convertVariableDeclaration(stmt);
    } else if (stmt is Block) {
      return _convertBlock(stmt);
    } else if (stmt is IfStatement) {
      return _convertIfStatement(stmt);
    } else if (stmt is ForStatement) {
      return _convertForStatement(stmt);
    } else if (stmt.runtimeType.toString() == 'ForInStatement') {
      return _convertForInStatement(stmt as dynamic);
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
    String name = decl.name ?? 'unnamed_var';

    // 使用统一的标识符清理函数
    name = _sanitizeIdentifier(name);
    // 为变量添加前缀以避免关键字冲突
    if (name == 'unnamed') {
      name = 'var_$name';
    }

    final type = CppTypeConverter.convertType(decl.type);
    final isLate = decl.isLate;

    if (decl.initializer != null) {
      final init =
          transformer.expressionConverter.convertExpression(decl.initializer!);

      // late 变量处理
      if (isLate) {
        if (decl.isFinal) {
          return 'mutable std::optional<$type> ${name}_storage; '
              'const auto& $name = [&]() -> const $type& { '
              'if (!${name}_storage.has_value()) ${name}_storage = $init; '
              'return ${name}_storage.value(); }();';
        } else {
          return 'std::optional<$type> ${name}_storage; '
              'auto $name = [&]() -> $type& { '
              'if (!${name}_storage.has_value()) ${name}_storage = $init; '
              'return ${name}_storage.value(); }();';
        }
      }

      // 特殊处理dynamic类型变量
      if (decl.type is DynamicType) {
        // 对于dynamic类型变量，声明为Any类型以支持多种类型赋值
        if (decl.isFinal) {
          return 'const Any $name = $init;';
        } else {
          return 'Any $name = $init;';
        }
      }

      // 检查是否使用auto
      if (decl.isFinal) {
        return 'const auto $name = $init;';
      } else {
        return 'auto $name = $init;';
      }
    } else {
      // late 变量没有初始化器
      if (isLate) {
        if (decl.isFinal) {
          return 'mutable std::optional<$type> ${name}_storage; '
              'const auto& $name = [&]() -> const $type& { '
              'if (!${name}_storage.has_value()) throw std::runtime_error("Late variable \'$name\' not initialized"); '
              'return ${name}_storage.value(); }();';
        } else {
          return 'std::optional<$type> ${name}_storage; '
              'auto& $name = [&]() -> $type& { '
              'if (!${name}_storage.has_value()) throw std::runtime_error("Late variable \'$name\' not initialized"); '
              'return ${name}_storage.value(); }();';
        }
      }

      // 对于可空类型，使用具体类型并显式调用Null构造函数
      // 例如 int? -> Int nullableInt(Null)
      if (decl.type.nullability.toString().contains('nullable')) {
        // 获取非空版本的类型
        final nonNullType = CppTypeConverter.convertType(
            decl.type.withDeclaredNullability(Nullability.nonNullable));

        // 基本类型的可空版本仍然是基本类型，不使用ObjectPtr包装
        if (_isBasicType(nonNullType)) {
          return '$nonNullType $name(Null);';
        } else {
          // 只有非基本类型才使用ObjectPtr包装
          return 'ObjectPtr<$nonNullType> $name(nullptr);';
        }
      }
      // 其他非可空类型，使用默认构造
      return '$type $name;';
    }
  }

  String _convertBlock(Block stmt) {
    final statements = stmt.statements
        .map((s) => convertStatement(s))
        .where((s) => s.isNotEmpty)
        .join('\n');
    return statements;
  }

  String _convertIfStatement(IfStatement stmt) {
    final condition =
        transformer.expressionConverter.convertExpression(stmt.condition);
    final thenStmt = convertStatement(stmt.then);

    String result = 'if ($condition) {\n$thenStmt\n}';

    if (stmt.otherwise != null) {
      final elseStmt = convertStatement(stmt.otherwise!);
      result += ' else {\n$elseStmt\n}';
    }

    return result;
  }

  String _convertForStatement(ForStatement stmt) {
    // For loop variables should not include the full declaration syntax
    final variables = stmt.variables.map((v) {
      final name = v.name ?? 'unnamed_var';
      if (v.initializer != null) {
        final init =
            transformer.expressionConverter.convertExpression(v.initializer!);
        return 'auto $name = $init';
      } else {
        final type = CppTypeConverter.convertType(v.type);
        return '$type $name';
      }
    }).join(', ');

    final condition = stmt.condition != null
        ? transformer.expressionConverter.convertExpression(stmt.condition!)
        : 'true';

    // 优化 increment 表达式处理
    final updates = stmt.updates.map((u) {
      final updateExpr = transformer.expressionConverter.convertExpression(u);
      // 如果是简单的赋值表达式，尝试转换为 ++ 或 -- 操作符
      if (updateExpr.contains(' = ') && updateExpr.contains(' + dart_int(1)')) {
        final varName = updateExpr.split(' = ')[0];
        return '++$varName';
      } else if (updateExpr.contains(' = ') &&
          updateExpr.contains(' - dart_int(1)')) {
        final varName = updateExpr.split(' = ')[0];
        return '--$varName';
      }
      return updateExpr;
    }).join(', ');

    final body = convertStatement(stmt.body);

    return 'for ($variables; $condition; $updates) {\n$body\n}';
  }

  String _convertForInStatement(dynamic stmt) {
    // 获取循环变量名
    final variable = stmt.variable;
    String varName = variable.name ?? 'item';

    // 使用统一的标识符清理函数
    varName = _sanitizeIdentifier(varName);
    if (varName == 'unnamed') {
      varName = 'var_$varName';
    }

    final varType = CppTypeConverter.convertType(variable.type);

    // 获取可迭代对象
    final iterable =
        transformer.expressionConverter.convertExpression(stmt.iterable);

    // 生成迭代器变量名（使用合法的C++标识符）
    final iteratorVarName = 'sync_for_iterator';

    // 转换循环体
    final body = convertStatement(stmt.body);

    // 生成正确的C++ for-in循环代码，使用 hasNext() 和 next() 方法
    return '''for (auto $iteratorVarName = $iterable->iterator(); $iteratorVarName->hasNext(); ) {
auto $varName = $iteratorVarName->next();
$body
}''';
  }

  String _convertWhileStatement(WhileStatement stmt) {
    final condition =
        transformer.expressionConverter.convertExpression(stmt.condition);
    final body = convertStatement(stmt.body);
    return 'while ($condition) {\n$body\n}';
  }

  String _convertReturnStatement(ReturnStatement stmt) {
    if (stmt.expression != null) {
      var expr =
          transformer.expressionConverter.convertExpression(stmt.expression!);

      // 特殊处理 return this 的情况
      if (expr == 'this') {
        // 检查当前方法的返回类型，如果是ObjectPtr类型，则需要包装
        // 使用std::remove_reference移除引用类型
        expr = 'ObjectPtr<std::remove_reference_t<decltype(*this)>>(this)';
      }

      return 'return $expr;';
    } else {
      return 'return Void;';
    }
  }

  String _convertTryStatement(dynamic stmt) {
    try {
      final tryBody = convertStatement(stmt.body);
      String result = 'try {\n$tryBody\n}';

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
    // 在 C++ 中，对于简单的循环，我们直接转换循环体，不生成标签
    // 因为 C++ 的 break/continue 默认作用于最近的循环
    final body = convertStatement(stmt.body);
    return body;
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
    String name = stmt.variable.name ?? 'anonymous';

    // 使用统一的标识符清理函数
    name = _sanitizeIdentifier(name);
    if (name == 'unnamed') {
      name = 'func_$name';
    }

    final returnType = CppTypeConverter.convertType(stmt.function.returnType);
    final params = stmt.function.positionalParameters
        .map((p) => '${CppTypeConverter.convertType(p.type)} ${p.name}')
        .join(', ');

    String body = '{ }';
    if (stmt.function.body != null) {
      final isVoidFunction =
          CppTypeConverter.convertType(stmt.function.returnType) == 'Nullable';
      body = transformer._transformFunctionBody(stmt.function.body!,
          isVoidFunction: isVoidFunction);
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
    return 'do {\n$body\n} while (($condition).toBool());';
  }

  String _convertSwitchStatement(SwitchStatement stmt) {
    final expr =
        transformer.expressionConverter.convertExpression(stmt.expression);

    // 将所有 switch 语句都转换为 if-else if 链
    return _convertToIfElseChain(stmt, expr);
  }

  String _convertToIfElseChain(SwitchStatement stmt, String expr) {
    StringBuffer result = StringBuffer();
    bool isFirst = true;

    // 分组处理 case，将连续的没有 break 的 case 合并
    List<List<SwitchCase>> caseGroups = _groupSwitchCases(stmt.cases);

    for (final group in caseGroups) {
      if (group.length == 1 && group[0].isDefault) {
        // 处理 default case
        result.write('else {\n');
        final body = convertStatement(group[0].body);
        final cleanBody = _removeBreakStatements(body);
        result.write('  $cleanBody\n');
        result.write('}');
      } else {
        // 收集所有条件表达式
        List<String> allConditions = [];
        for (final case_ in group) {
          if (!case_.isDefault) {
            for (final caseExpr in case_.expressions) {
              final caseValue =
                  transformer.expressionConverter.convertExpression(caseExpr);
              allConditions.add('$expr == $caseValue');
            }
          }
        }

        if (allConditions.isNotEmpty) {
          // 生成 if 或 else if 条件
          if (isFirst) {
            result.write('if (${allConditions.join(' || ')}) {\n');
            isFirst = false;
          } else {
            result.write(' else if (${allConditions.join(' || ')}) {\n');
          }

          // 使用最后一个有实际代码的 case 的 body
          String body = '';
          for (int i = group.length - 1; i >= 0; i--) {
            final caseBody = convertStatement(group[i].body);
            if (caseBody.trim().isNotEmpty &&
                !caseBody.trim().startsWith('break')) {
              body = caseBody;
              break;
            }
          }

          final cleanBody = _removeBreakStatements(body);
          result.write('  $cleanBody\n');
          result.write('}');
        }
      }
    }

    return result.toString();
  }

  List<List<SwitchCase>> _groupSwitchCases(List<SwitchCase> cases) {
    List<List<SwitchCase>> groups = [];
    List<SwitchCase> currentGroup = [];

    for (int i = 0; i < cases.length; i++) {
      final case_ = cases[i];
      currentGroup.add(case_);

      // 更精确的 break 检测
      final body = convertStatement(case_.body);
      final hasBreak = _hasBreakOrReturn(body);
      final isLast = i == cases.length - 1;
      final isEmpty = _isEmptyCase(body);

      // 如果是空 case 且不是最后一个，继续合并到下一个 case
      if (isEmpty && !isLast) {
        continue;
      }

      // 如果有明确的 break/return 或者是最后一个 case 或者是 default case
      if (hasBreak || isLast || case_.isDefault) {
        groups.add(List.from(currentGroup));
        currentGroup.clear();
      }
    }

    if (currentGroup.isNotEmpty) {
      groups.add(currentGroup);
    }

    return groups;
  }

  /// 检查是否有 break 或 return 语句
  bool _hasBreakOrReturn(String body) {
    // 更精确的检测，避免误判注释或字符串中的 break
    final trimmedBody = body.trim();
    return trimmedBody.endsWith('break;') ||
        trimmedBody.endsWith('return;') ||
        trimmedBody.contains('return ') ||
        RegExp(r'\bbreak\s*;').hasMatch(trimmedBody) ||
        RegExp(r'\breturn\b').hasMatch(trimmedBody);
  }

  /// 检查是否是空的 case
  bool _isEmptyCase(String body) {
    final cleanBody = body
        .trim()
        .replaceAll(RegExp(r'//.*'), '') // 移除单行注释
        .replaceAll(RegExp(r'/\*.*?\*/'), '') // 移除多行注释
        .replaceAll(RegExp(r'\s+'), ''); // 移除空白字符
    return cleanBody.isEmpty || cleanBody == '{}';
  }

  String _removeBreakStatements(String body) {
    // 移除 break 语句，因为 if-else 不需要 break
    return body
        .replaceAll(RegExp(r'\s*break\s*;\s*'), '')
        .replaceAll(RegExp(r'\s*break\s*'), '');
  }

  bool _hasStringCaseValues(SwitchStatement stmt) {
    for (final case_ in stmt.cases) {
      for (final expr in case_.expressions) {
        if (expr is StringLiteral) {
          return true;
        }
      }
    }
    return false;
  }

  bool _hasStringCaseExpressions(SwitchStatement stmt) {
    for (final case_ in stmt.cases) {
      for (final expr in case_.expressions) {
        final convertedExpr =
            transformer.expressionConverter.convertExpression(expr);
        if (convertedExpr.contains('dart_string')) {
          return true;
        }
      }
    }
    return false;
  }

  String _convertStringSwitch(SwitchStatement stmt, String expr) {
    StringBuffer result = StringBuffer();
    bool isFirst = true;

    for (final case_ in stmt.cases) {
      if (case_.isDefault) {
        // 处理 default case
        result.write('else {\n');
        final body = convertStatement(case_.body);
        result.write('  $body\n');
        result.write('}');
      } else {
        // 处理普通 case
        for (int i = 0; i < case_.expressions.length; i++) {
          final caseValue = transformer.expressionConverter
              .convertExpression(case_.expressions[i]);

          if (isFirst) {
            result.write('if ($expr == $caseValue) {\n');
            isFirst = false;
          } else {
            result.write(' else if ($expr == $caseValue) {\n');
          }

          final body = convertStatement(case_.body);
          result.write('  $body\n');
          result.write('}');

          // 如果一个 case 有多个表达式，只处理第一个，其他的用 || 连接
          if (i == 0 && case_.expressions.length > 1) {
            // 重新构建条件，包含所有表达式
            List<String> conditions = case_.expressions
                .map((e) =>
                    '$expr == ${transformer.expressionConverter.convertExpression(e)}')
                .toList();

            result.clear();
            if (isFirst) {
              result.write('if (${conditions.join(' || ')}) {\n');
              isFirst = false;
            } else {
              result.write(' else if (${conditions.join(' || ')}) {\n');
            }
            final body = convertStatement(case_.body);
            result.write('  $body\n');
            result.write('}');
            break; // 跳出内层循环
          }
        }
      }
    }

    return result.toString();
  }

  /// 检查是否是基本类型 - 使用全局统一定义
  bool _isBasicType(String className) {
    return TypeAnalyzer.isBasicType(className);
  }
}

/// 主要的 Dart 到 C++ 转换器
class DartToCppTransformer {
  final StringBuffer _buffer = StringBuffer();
  int _indentLevel = 0;

  late final ExpressionConverter expressionConverter;
  late final CppStatementConverter statementConverter;
  late final TypeAnalyzer typeAnalyzer;

  // 扩展方法注册表：目标类型 -> 扩展方法映射
  final Map<String, Map<String, String>> _extensionMethods = {};

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
    statementConverter = CppStatementConverter(this);
    expressionConverter = ExpressionConverter(this, statementConverter);
  }

  /// 转换整个组件
  String transformComponent(Component component) {
    _buffer.clear();

    // 初始化类型分析器并扫描所有类
    typeAnalyzer = TypeAnalyzer();
    typeAnalyzer.scanClasses(component);

    // 写入头文件
    _writeHeaders();
    _writeLine('');

    // 写入工具宏
    _writeUtilityMacros();
    _writeLine('');

    // 验证转换器配置
    _validateTransformerSetup();

    // 预注册常用扩展方法
    _registerCommonExtensionMethods();

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

      // 修复#17: 处理Extension声明 - 转换为命名空间和静态方法
      for (final extension in library.extensions) {
        _transformExtension(extension);
      }
    }

    // 生成顶级函数的前向声明
    for (final library in component.libraries) {
      if (_shouldSkipLibrary(library)) {
        continue;
      }

      for (final procedure in library.procedures) {
        if (procedure.name.text == 'main') {
          continue; // 跳过 main 函数
        }
        _writeFunctionDeclaration(procedure);
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

    // 统计信息已移至verbose模式单独输出
    return _buffer.toString();
  }

  /// 打印转换统计信息
  void _printTransformationSummary(int totalLibraries, int skippedLibraries,
      int processedClasses, int processedProcedures) {
    print('📊 转换统计:');
    print('   总库数: $totalLibraries');
    print('   跳过基础库: $skippedLibraries');
    print('   处理业务库: ${totalLibraries - skippedLibraries}');
    print('   转换类数: $processedClasses');
    print('   转换函数数: $processedProcedures');
    print(
        '   注册扩展方法: ${_extensionMethods.values.fold(0, (sum, methods) => (sum as int) + methods.length)}');
    print('   TypeAnalyzer 自定义类: ${typeAnalyzer.customClasses.length}');
    print('');
    print('🎯 转换器功能:');
    print('   ✅ 基础类型转换');
    print('   ✅ ObjectPtr 智能包装');
    print('   ✅ 泛型约束支持');
    print('   ✅ 扩展方法语法糖');
    print('   ✅ Future 链式调用');
    print('   ✅ 集合操作完整支持');
    print('   ✅ late 变量支持');
    print('   ✅ 函数类型转换');
    print('   ✅ Switch fall-through 处理');
    print('   ✅ 字符串插值优化');
    print('');
  }

  /// 验证转换器设置
  void _validateTransformerSetup() {
    // 检查 TypeAnalyzer 是否正确初始化
    if (typeAnalyzer.customClasses.isEmpty && typeAnalyzer.basicTypes.isEmpty) {
      print('⚠️ 警告：TypeAnalyzer 可能未正确初始化');
    }

    // 检查转换器是否正确设置
    if (expressionConverter.transformer != this) {
      print('⚠️ 警告：ExpressionConverter 的 transformer 引用不正确');
    }

    if (statementConverter.transformer != this) {
      print('⚠️ 警告：StatementConverter 的 transformer 引用不正确');
    }
  }

  /// 获取接收者类型
  String? _getReceiverType(Expression receiver) {
    if (receiver is VariableGet) {
      final type = receiver.variable.type;
      if (type is InterfaceType) {
        return type.classNode.name;
      }
    }
    // 可以扩展更多类型推断
    return null;
  }

  /// 检查是否是扩展方法
  bool _isExtensionMethod(String receiverType, String methodName) {
    return _extensionMethods.containsKey(receiverType) &&
        _extensionMethods[receiverType]!.containsKey(methodName);
  }

  /// 获取扩展方法所在的类
  String _getExtensionClass(String receiverType, String methodName) {
    return _extensionMethods[receiverType]![methodName] ?? 'UnknownExtension';
  }

  /// 通用扩展方法转换 - 将扩展方法转换为静态方法调用
  /// 格式：ExtensionClass::methodName(receiver, ...args)
  String _convertExtensionMethodCall(
      String receiverType, String methodName, String receiver, Arguments args) {
    final extensionClass = _getExtensionClass(receiverType, methodName);

    // 特殊处理数学扩展方法
    if (extensionClass == 'MathExtension' && methodName == 'sqrt') {
      // 将 MathExtension|sqrt 转换为 MathExtension::sqrt
      return 'MathExtension::sqrt($receiver)';
    }

    final staticMethodName = '${extensionClass}::$methodName';

    // 构建参数列表，receiver作为第一个参数
    final argList = <String>[receiver];
    argList.addAll(args.positional
        .map((arg) => expressionConverter.convertExpression(arg)));

    // 添加命名参数（如果有）
    for (final namedArg in args.named) {
      argList.add(
          '/*${namedArg.name}:*/ ${expressionConverter.convertExpression(namedArg.value)}');
    }

    return '$staticMethodName(${argList.join(', ')})';
  }

  /// 注册扩展方法
  void _registerExtensionMethod(
      String targetType, String methodName, String extensionClass) {
    _extensionMethods.putIfAbsent(targetType, () => {});
    _extensionMethods[targetType]![methodName] = extensionClass;
  }

  /// 预注册常用扩展方法
  void _registerCommonExtensionMethods() {
    // String 扩展方法
    _registerExtensionMethod('String', 'capitalize', 'StringExtensions');
    _registerExtensionMethod('String', 'isPalindrome', 'StringExtensions');
    _registerExtensionMethod('String', 'reverse', 'StringExtensions');
    _registerExtensionMethod('String', 'isEmail', 'StringExtensions');

    // List 扩展方法
    _registerExtensionMethod('List', 'chunk', 'ListExtensions');
    _registerExtensionMethod('List', 'groupBy', 'ListExtensions');
    _registerExtensionMethod('List', 'distinct', 'ListExtensions');

    // int 扩展方法
    _registerExtensionMethod('int', 'isEven', 'IntExtensions');
    _registerExtensionMethod('int', 'isOdd', 'IntExtensions');
    _registerExtensionMethod('int', 'times', 'IntExtensions');

    // double 扩展方法 (MathExtension)
    _registerExtensionMethod('double', 'sqrt', 'MathExtension');
    _registerExtensionMethod('Double', 'sqrt', 'MathExtension');
  }

  /// 检查是否是 Future 类型
  bool _isFutureType(Expression expr) {
    if (expr is VariableGet) {
      final type = expr.variable.type;
      if (type is InterfaceType) {
        return type.classNode.name == 'Future';
      }
    }
    return false;
  }

  /// 转换 Future 方法调用
  String _convertFutureMethod(Expression receiver, String methodName) {
    final receiverCode = expressionConverter.convertExpression(receiver);

    switch (methodName) {
      case 'isCompleted':
        return '$receiverCode->isCompleted()';
      case 'value':
        return '$receiverCode->getValue()';
      case 'error':
        return '$receiverCode->getError()';
      case 'hasError':
        return '$receiverCode->hasError()';
      case 'hasValue':
        return '$receiverCode->hasValue()';
      default:
        // 默认处理 - 统一使用 -> 调用
        return '$receiverCode->$methodName()';
    }
  }

  /// 转换 Future 链式调用
  String _convertFutureChainCall(
      Expression receiver, String methodName, Arguments arguments) {
    final receiverCode = expressionConverter.convertExpression(receiver);

    switch (methodName) {
      case 'then':
        if (arguments.positional.isNotEmpty) {
          final callback =
              expressionConverter.convertExpression(arguments.positional.first);
          // 检查是否有类型参数
          final typeArgs = arguments.types;
          if (typeArgs.isNotEmpty) {
            final returnType = CppTypeConverter.convertType(typeArgs.first);
            return '$receiverCode->then<$returnType>($callback)';
          }
          return '$receiverCode->then($callback)';
        }
        break;

      case 'catchError':
        if (arguments.positional.isNotEmpty) {
          final errorHandler =
              expressionConverter.convertExpression(arguments.positional.first);
          return '$receiverCode->catchError($errorHandler)';
        }
        break;

      case 'whenComplete':
        if (arguments.positional.isNotEmpty) {
          final completeHandler =
              expressionConverter.convertExpression(arguments.positional.first);
          return '$receiverCode->whenComplete($completeHandler)';
        }
        break;

      case 'timeout':
        if (arguments.positional.isNotEmpty) {
          final timeout =
              expressionConverter.convertExpression(arguments.positional.first);
          return '$receiverCode->timeout($timeout)';
        }
        break;

      case 'wait':
        return '$receiverCode->wait()';

      case 'waitFor':
        if (arguments.positional.isNotEmpty) {
          final duration =
              expressionConverter.convertExpression(arguments.positional.first);
          return '$receiverCode->waitFor($duration)';
        }
        break;
    }

    // 默认处理
    final args = arguments.positional
        .map((arg) => expressionConverter.convertExpression(arg))
        .join(', ');
    return '$receiverCode->$methodName($args)';
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

    // 生成泛型约束（如果有）
    if (cls.typeParameters.isNotEmpty) {
      _writeGenericConstraints(cls);
    }

    if (isAbstract) {
      _writeInterface(cls);
    } else {
      _writeClass(cls, hasSuperclass, hasInterfaces);
    }
  }

  /// 修复#17: 将Extension转换为namespace和静态方法
  void _transformExtension(Extension ext) {
    final extensionName = ext.name;

    _writeLine(
        '// ============================================================================');
    _writeLine('// Extension: $extensionName');
    _writeLine(
        '// ============================================================================');
    _writeLine('');

    // 将Extension转换为namespace
    _writeLine('namespace $extensionName {');
    _indent();

    // 转换Extension中的每个方法为静态方法
    for (final member in ext.memberDescriptors) {
      // 获取方法引用
      final memberRef = member.memberReference;
      if (memberRef != null && memberRef.asProcedure != null) {
        final procedure = memberRef.asProcedure!;
        // 生成静态方法
        _writeProcedureAsStaticMethod(procedure, ext.onType);
      }
    }

    _unindent();
    _writeLine('} // namespace $extensionName');
    _writeLine('');

    // 注册扩展方法，以便调用时能正确转换
    _registerExtensionFromDeclaration(ext);
  }

  /// 将Procedure转换为静态方法
  void _writeProcedureAsStaticMethod(Procedure procedure, DartType onType) {
    final returnType =
        CppTypeConverter.convertType(procedure.function.returnType);
    final methodName = procedure.name.text;
    final receiverType = CppTypeConverter.convertType(onType);

    // 构建参数列表 - 第一个参数是 receiver
    final params = <String>['const $receiverType& self'];
    for (final param in procedure.function.positionalParameters) {
      final paramType = CppTypeConverter.convertType(param.type);
      final paramName = param.name ?? 'param';
      params.add('$paramType $paramName');
    }
    for (final param in procedure.function.namedParameters) {
      final paramType = CppTypeConverter.convertType(param.type);
      final paramName = param.name ?? 'param';
      params.add('$paramType $paramName');
    }

    _writeLine('inline $returnType $methodName(${params.join(', ')}) {');
    _indent();

    // 转换函数体
    if (procedure.function.body != null) {
      final body =
          statementConverter.convertStatement(procedure.function.body!);
      // 将 'this' 替换为 'self'
      final modifiedBody = body.replaceAll('this->', 'self.');
      _writeLine(modifiedBody);
    }

    _unindent();
    _writeLine('}');
    _writeLine('');
  }

  /// 从 Extension 声明注册扩展方法
  void _registerExtensionFromDeclaration(Extension ext) {
    final extensionName = ext.name;
    final onType = ext.onType;
    String targetType = 'Unknown';

    if (onType is InterfaceType) {
      targetType = onType.classNode.name;
    }

    for (final member in ext.memberDescriptors) {
      final memberRef = member.memberReference;
      if (memberRef != null && memberRef.asProcedure != null) {
        final methodName = memberRef.asProcedure!.name.text;
        _registerExtensionMethod(targetType, methodName, extensionName);
      }
    }
  }

  /// 生成泛型约束
  void _writeGenericConstraints(Class cls) {
    for (final typeParam in cls.typeParameters) {
      if (typeParam.bound != null) {
        final paramName = typeParam.name;
        final boundType = CppTypeConverter.convertType(typeParam.bound!);

        // 修复泛型约束 - 不再使用有问题的is_base_of_v和num类型
        _writeLine('template<typename $paramName>');
        _writeLine('');
      }
    }
  }

  void _writeInterface(Class cls) {
    // 修复#3: 将抽象类转换为标准C++纯虚类
    // 生成泛型模板声明（如果有）
    String templateDecl = '';
    if (cls.typeParameters.isNotEmpty) {
      final typeParams =
          cls.typeParameters.map((p) => 'typename ${p.name}').join(', ');
      templateDecl = 'template<$typeParams>\n';
    }

    // 构建继承列表
    final inheritanceList = <String>[];
    if (cls.superclass != null && cls.superclass!.name != 'Object') {
      inheritanceList.add('public ${cls.superclass!.name}');
    }
    for (final interface in cls.implementedTypes) {
      inheritanceList.add('virtual public ${interface.classNode.name}');
    }
    final inheritance =
        inheritanceList.isNotEmpty ? ' : ${inheritanceList.join(", ")}' : '';

    _writeLine('${templateDecl}class ${cls.name}$inheritance {');
    _writeLine('public:');
    _indent();

    // 生成虚析构函数
    _writeLine('virtual ~${cls.name}() = default;');
    _writeLine('');

    // 处理抽象方法 - 转换为纯虚函数
    for (final procedure in cls.procedures) {
      if (procedure.isAbstract) {
        final returnType =
            CppTypeConverter.convertType(procedure.function.returnType);
        final name = procedure.name.text;
        final params = _buildParameterList(procedure.function);
        _writeLine('virtual $returnType $name($params) = 0;');
      } else {
        // 非抽象方法正常处理
        _writeProcedure(procedure, isClassMember: true);
      }
    }

    // 处理抽象getter
    for (final field in cls.fields) {
      final type = CppTypeConverter.convertType(field.type);
      final name = field.name.text;
      _writeLine('virtual $type get_$name() = 0;');
    }

    _unindent();
    _writeLine('};');
    _writeLine('');
  }

  void _writeClass(Class cls, bool hasSuperclass, bool hasInterfaces) {
    // 修复#2: 泛型类继承正确处理
    // 生成泛型模板声明（如果有）
    String templateDecl = '';
    String typeParamList = '';
    if (cls.typeParameters.isNotEmpty) {
      final typeParams =
          cls.typeParameters.map((p) => 'typename ${p.name}').join(', ');
      templateDecl = 'template<$typeParams>\n';
      typeParamList = '<${cls.typeParameters.map((p) => p.name).join(', ')}>';
    }

    // 构建继承列表 - 正确传递泛型参数
    final inheritanceList = <String>[];

    if (hasSuperclass) {
      final superclassName = cls.superclass!.name;
      // 检查父类是否有泛型参数，并传递过去
      if (cls.supertype != null && cls.supertype!.typeArguments.isNotEmpty) {
        final superTypeArgs = cls.supertype!.typeArguments
            .map((t) => CppTypeConverter.convertType(t))
            .join(', ');
        inheritanceList.add('public $superclassName<$superTypeArgs>');
      } else if (cls.typeParameters.isNotEmpty &&
          cls.superclass!.typeParameters.isNotEmpty) {
        // 父类也有泛型，传递当前类的类型参数
        inheritanceList.add('public $superclassName$typeParamList');
      } else {
        inheritanceList.add('public $superclassName');
      }
    }

    for (final interface in cls.implementedTypes) {
      final interfaceName = interface.classNode.name;
      if (interface.typeArguments.isNotEmpty) {
        final interfaceTypeArgs = interface.typeArguments
            .map((t) => CppTypeConverter.convertType(t))
            .join(', ');
        inheritanceList
            .add('virtual public $interfaceName<$interfaceTypeArgs>');
      } else {
        inheritanceList.add('virtual public $interfaceName');
      }
    }

    // 处理Mixin（修复#16）- 使用多重继承模拟
    if (cls.mixedInType != null) {
      final mixedInSupertype = cls.mixedInType!;
      final mixinName = mixedInSupertype.classNode.name;
      if (mixedInSupertype.typeArguments.isNotEmpty) {
        final mixinTypeArgs = mixedInSupertype.typeArguments
            .map((t) => CppTypeConverter.convertType(t))
            .join(', ');
        inheritanceList.add('public $mixinName<$mixinTypeArgs>');
      } else {
        inheritanceList.add('public $mixinName');
      }
    }

    final inheritance =
        inheritanceList.isNotEmpty ? ' : ${inheritanceList.join(", ")}' : '';

    _writeLine('${templateDecl}class ${cls.name}$inheritance {');

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
      // 构造函数不应该有返回语句
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
    // Skip main function as it will be handled separately
    if (procedure.name.text == 'main') {
      return;
    }
    _writeProcedure(procedure, isClassMember: false);
  }

  void _writeFunctionDeclaration(Procedure procedure) {
    // 生成函数前向声明（仅函数签名，无函数体）
    final name = procedure.name.text;
    final returnType =
        CppTypeConverter.convertType(procedure.function.returnType);

    // 处理泛型函数
    if (procedure.function.typeParameters.isNotEmpty) {
      // 为泛型函数生成模板声明
      for (final typeParam in procedure.function.typeParameters) {
        final paramName = typeParam.name;
        _writeLine('template<typename $paramName>');
      }
    }

    final params = _buildParameterList(procedure.function);
    _writeLine('$returnType $name($params);');
  }

  void _writeProcedure(Procedure procedure, {required bool isClassMember}) {
    var name = procedure.name.text;

    // 修复#18: 工厂构造函数转换为静态方法
    if (procedure.isFactory) {
      _writeFactoryAsStaticMethod(procedure);
      return;
    }

    // 对于类成员的运算符方法，必须先转换为 operator_ 前缀的方法名，再进行 sanitize
    // 这样可以避免 operator+ 和 operator- 都被 sanitize 成同一个名字
    if (isClassMember && _isOperatorMethod(name)) {
      name = _convertOperatorMethodName(name);
    }

    // 最后对名字进行清理（此时运算符方法名已经是合法的 operator_add 等形式）
    name = _sanitizeIdentifier(name);

    // 修复问题2A: 处理泛型函数 - 避免在泛型类内部重复声明模板
    // 只有当方法本身有泛型参数且不是类成员时，才生成模板声明
    // 如果是类成员，模板已经在类声明中生成，不需要重复
    final shouldWriteTemplate =
        procedure.function.typeParameters.isNotEmpty && !isClassMember;

    if (shouldWriteTemplate) {
      // 为泛型函数生成模板声明
      for (final typeParam in procedure.function.typeParameters) {
        final paramName = typeParam.name;
        _writeLine('template<typename $paramName>');
      }
    }

    final returnType =
        CppTypeConverter.convertType(procedure.function.returnType);
    // 在函数定义中，不应该有默认参数值（C++要求默认参数只在声明中）
    final params = _buildParameterListWithoutDefaults(procedure.function);

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
      final isVoidFunction =
          CppTypeConverter.convertType(procedure.function.returnType) ==
              'Nullable';
      final body = _transformFunctionBody(procedure.function.body!,
          isVoidFunction: isVoidFunction);
      _writeLine(body);
      _unindent();
    }

    if (isAsync) {
      _writeLine('    DART_ASYNC_END');
    }

    _writeLine('}');
    _writeLine('');
  }

  /// 修复#18: 将工厂构造函数转换为静态方法
  void _writeFactoryAsStaticMethod(Procedure procedure) {
    final className = procedure.enclosingClass!.name;
    // 工厂方法名：如果是默认工厂构造函数，使用 'create'；否则使用方法名
    var factoryName = procedure.name.text;
    if (factoryName.isEmpty) {
      factoryName = 'create';
    } else {
      factoryName = _sanitizeIdentifier(factoryName);
    }

    // 处理泛型
    String templateDecl = '';
    String typeParamList = '';
    if (procedure.function.typeParameters.isNotEmpty) {
      final typeParams = procedure.function.typeParameters
          .map((p) => 'typename ${p.name}')
          .join(', ');
      templateDecl = 'template<$typeParams>\n';
      typeParamList =
          '<${procedure.function.typeParameters.map((p) => p.name).join(', ')}>';
    } else if (procedure.enclosingClass!.typeParameters.isNotEmpty) {
      final typeParams = procedure.enclosingClass!.typeParameters
          .map((p) => 'typename ${p.name}')
          .join(', ');
      templateDecl = 'template<$typeParams>\n';
      typeParamList =
          '<${procedure.enclosingClass!.typeParameters.map((p) => p.name).join(', ')}>';
    }

    final returnType = 'ObjectPtr<$className$typeParamList>';
    final params = _buildParameterListWithoutDefaults(procedure.function);

    if (templateDecl.isNotEmpty) {
      _writeLine(templateDecl.trim());
    }
    _writeLine('static $returnType $factoryName($params) {');

    if (procedure.function.body != null) {
      _indent();
      final body =
          statementConverter.convertStatement(procedure.function.body!);
      _writeLine(body);
      _unindent();
    }

    _writeLine('}');
    _writeLine('');
  }

  String _buildParameterListWithoutDefaults(FunctionNode function) {
    // 不带默认值的参数列表，用于函数定义
    final params = <String>[];

    for (final param in function.positionalParameters) {
      final type = CppTypeConverter.convertType(param.type);
      final name = _sanitizeIdentifier(param.name ?? 'param');
      params.add('$type $name');
    }

    for (final param in function.namedParameters) {
      final type = CppTypeConverter.convertType(param.type);
      final name = _sanitizeIdentifier(param.name ?? 'param');
      params.add('$type $name');
    }

    return params.join(', ');
  }

  String _buildParameterList(FunctionNode function) {
    final params = <String>[];

    // 位置参数
    final requiredCount = function.requiredParameterCount;
    for (int i = 0; i < function.positionalParameters.length; i++) {
      final param = function.positionalParameters[i];
      final type = CppTypeConverter.convertType(param.type);
      final name = param.name ?? 'param';

      // 如果是可选参数，添加默认值
      if (i >= requiredCount) {
        // 可选参数，添加默认值
        // 对于 ObjectPtr 类型，使用 nullptr；对于值类型，使用 Type(Null)
        if (type.startsWith('ObjectPtr<')) {
          params.add('$type $name = nullptr');
        } else {
          params.add('$type $name = $type(Null)');
        }
      } else {
        params.add('$type $name');
      }
    }

    // 命名参数 - 全部是可选的
    for (final param in function.namedParameters) {
      final type = CppTypeConverter.convertType(param.type);
      final name = param.name ?? 'param';
      // 命名参数需要默认值
      // 对于 ObjectPtr 类型，使用 nullptr；对于值类型，使用 Type(Null)
      if (type.startsWith('ObjectPtr<')) {
        params.add('$type $name = nullptr');
      } else {
        params.add('$type $name = $type(Null)');
      }
    }

    return params.join(', ');
  }

  String _transformFunctionBody(Statement body, {bool isVoidFunction = false}) {
    String bodyCode = statementConverter.convertStatement(body);

    // 如果是 void 函数，检查最后一行是否是 return 语句
    if (isVoidFunction) {
      final trimmedBody = bodyCode.trim();
      // 检查最后一行是否以 return 开头（避免被 lambda 中的 return 误判）
      final lines = trimmedBody.split('\n');
      final lastLine = lines.isNotEmpty ? lines.last.trim() : '';

      // 如果最后一行不是 return 语句，添加 return Void;
      if (!lastLine.startsWith('return')) {
        if (bodyCode.isNotEmpty && !bodyCode.endsWith(';')) {
          bodyCode += ';';
        }
        if (bodyCode.isNotEmpty) {
          bodyCode += '\n';
        }
        bodyCode += 'return Void;';
      }
    }

    return bodyCode;
  }

  bool _isAsyncFunction(FunctionNode function) {
    return function.asyncMarker == AsyncMarker.Async ||
        function.asyncMarker == AsyncMarker.AsyncStar;
  }

  bool _isPrivate(String name) {
    return name.startsWith('_');
  }

  /// 判断是否是运算符方法
  bool _isOperatorMethod(String name) {
    const operators = {
      '+',
      '-',
      '*',
      '/',
      '%',
      '~/',
      '==',
      '!=',
      '<',
      '>',
      '<=',
      '>=',
      '[]',
      '[]=',
      '&',
      '|',
      '^',
      '<<',
      '>>',
      '~',
      'unary-'
    };
    return operators.contains(name);
  }

  /// 将运算符方法名转换为 operator_ 前缀的方法名
  String _convertOperatorMethodName(String operatorName) {
    const operatorNameMap = {
      '+': 'operator_add',
      '-': 'operator_sub',
      '*': 'operator_mul',
      '/': 'operator_div',
      '%': 'operator_mod',
      '~/': 'operator_truncating_div',
      '==': 'operator_equals',
      '!=': 'operator_not_equals',
      '<': 'operator_less',
      '>': 'operator_greater',
      '<=': 'operator_less_equals',
      '>=': 'operator_greater_equals',
      '[]': 'operator_index',
      '[]=': 'operator_index_set',
      '&': 'operator_bitwise_and',
      '|': 'operator_bitwise_or',
      '^': 'operator_bitwise_xor',
      '<<': 'operator_shift_left',
      '>>': 'operator_shift_right',
      '~': 'operator_bitwise_not',
      'unary-': 'operator_negate',
    };
    return operatorNameMap[operatorName] ?? operatorName;
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

    // 查找main函数（只在用户代码库中查找）
    for (final library in component.libraries) {
      // Skip system libraries
      if (_shouldSkipLibrary(library)) {
        continue;
      }

      for (final procedure in library.procedures) {
        if (procedure.name.text == 'main') {
          // main 函数在 C++ 中返回 int，不应该被当作 void 函数处理
          final body = _transformFunctionBody(procedure.function.body!,
              isVoidFunction: false);
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

    // 注意：不再需要后处理，所有标识符已在生成时正确处理
    var processedCode = cppCode;

    // 写入输出文件
    print('正在写入 C++ 文件: $outputFile');
    await File(outputFile).writeAsString(processedCode);

    print('✅ 转换完成！');
    print('生成的 C++ 文件: $outputFile');
  } catch (e, stackTrace) {
    print('❌ 转换失败: $e');
    print('堆栈跟踪: $stackTrace');
    rethrow;
  }
}
