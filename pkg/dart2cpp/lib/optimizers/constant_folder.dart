/// 常量折叠优化器
///
/// 在编译时计算常量表达式，减少运行时开销
/// 支持：整型运算、浮点运算、字符串拼接
///
/// 使用示例：
/// ```dart
/// final optimizer = ConstantFoldingOptimizer(expressionConverter);
/// final result = optimizer.optimizeExpression(binaryExpr);
/// if (result.isOptimized) {
///   print('优化后: ${result.optimizedCode}');
/// }
/// ```

import 'package:kernel/ast.dart';
import '../dart_to_cpp_compiler.dart';

/// 常量折叠结果
class ConstantFoldingResult {
  final bool isOptimized;
  final String optimizedCode;
  final String? originalCode;

  const ConstantFoldingResult({
    required this.isOptimized,
    required this.optimizedCode,
    this.originalCode,
  });
}

/// 常量折叠优化器
class ConstantFoldingOptimizer {
  final CppExpressionConverter _expressionConverter;

  ConstantFoldingOptimizer(this._expressionConverter);

  /// 优化表达式
  ConstantFoldingResult optimizeExpression(Expression expr) {
    try {
      // 二元运算
      if (expr is BinaryExpression) {
        return _foldBinaryExpression(expr);
      }

      // 一元运算
      if (expr is UnaryExpression) {
        return _foldUnaryExpression(expr);
      }

      // 条件表达式（三目运算符）
      if (expr is ConditionalExpression) {
        return _foldConditionalExpression(expr);
      }

      // 字面量（已经是常量）
      if (expr is IntLiteral ||
          expr is DoubleLiteral ||
          expr is BoolLiteral ||
          expr is StringLiteral) {
        final code = _expressionConverter.convertExpression(expr);
        return ConstantFoldingResult(
          isOptimized: false,
          optimizedCode: code,
        );
      }

      // 无法优化的表达式
      return ConstantFoldingResult(
        isOptimized: false,
        optimizedCode: _expressionConverter.convertExpression(expr),
      );
    } catch (e) {
      // 优化失败，回退到原始转换
      return ConstantFoldingResult(
        isOptimized: false,
        optimizedCode: _expressionConverter.convertExpression(expr),
      );
    }
  }

  /// 折叠二元运算
  ConstantFoldingResult _foldBinaryExpression(BinaryExpression expr) {
    final left = expr.left;
    final right = expr.right;
    final operator = expr.operator;

    // Int常量折叠
    if (left is IntLiteral && right is IntLiteral) {
      final l = left.value;
      final r = right.value;
      final result = _computeIntegerResult(operator, l, r);
      return ConstantFoldingResult(
        isOptimized: true,
        optimizedCode: 'Int($result)',
        originalCode: _expressionConverter.convertExpression(expr),
      );
    }

    // Double常量折叠
    if (left is DoubleLiteral && right is DoubleLiteral) {
      final l = left.value;
      final r = right.value;
      final result = _computeDoubleResult(operator, l, r);
      return ConstantFoldingResult(
        isOptimized: true,
        optimizedCode: 'Double($result)',
        originalCode: _expressionConverter.convertExpression(expr),
      );
    }

    // Int和Double混合运算
    if ((left is IntLiteral && right is DoubleLiteral) ||
        (left is DoubleLiteral && right is IntLiteral)) {
      final l = left is IntLiteral ? left.value.toDouble() : left.value;
      final r = right is IntLiteral ? right.value.toDouble() : right.value;
      final result = _computeDoubleResult(operator, l, r);
      return ConstantFoldingResult(
        isOptimized: true,
        optimizedCode: 'Double($result)',
        originalCode: _expressionConverter.convertExpression(expr),
      );
    }

    // String常量折叠（仅支持+运算）
    if (operator == '+' && left is StringLiteral && right is StringLiteral) {
      final l = left.value;
      final r = right.value;
      final result = l + r;
      return ConstantFoldingResult(
        isOptimized: true,
        optimizedCode: 'String("${_escapeString(result)}")',
        originalCode: _expressionConverter.convertExpression(expr),
      );
    }

    // Bool常量折叠
    if (operator == '==' && left is BoolLiteral && right is BoolLiteral) {
      final l = left.value;
      const r = right.value;
      final result = l == r;
      return ConstantFoldingResult(
        isOptimized: true,
        optimizedCode: 'Bool($result)',
        originalCode: _expressionConverter.convertExpression(expr),
      );
    }

    // 无法优化
    return ConstantFoldingResult(
      isOptimized: false,
      optimizedCode: _expressionConverter.convertExpression(expr),
    );
  }

  /// 折叠一元运算
  ConstantFoldingResult _foldUnaryExpression(UnaryExpression expr) {
    final operand = expr.operand;

    // Int取负
    if (expr.isMinus && operand is IntLiteral) {
      final result = -operand.value;
      return ConstantFoldingResult(
        isOptimized: true,
        optimizedCode: 'Int($result)',
        originalCode: _expressionConverter.convertExpression(expr),
      );
    }

    // Double取负
    if (expr.isMinus && operand is DoubleLiteral) {
      final result = -operand.value;
      return ConstantFoldingResult(
        isOptimized: true,
        optimizedCode: 'Double($result)',
        originalCode: _expressionConverter.convertExpression(expr),
      );
    }

    // Bool取反
    if (expr.isNot && operand is BoolLiteral) {
      final result = !operand.value;
      return ConstantFoldingResult(
        isOptimized: true,
        optimizedCode: 'Bool($result)',
        originalCode: _expressionConverter.convertExpression(expr),
      );
    }

    // 无法优化
    return ConstantFoldingResult(
      isOptimized: false,
      optimizedCode: _expressionConverter.convertExpression(expr),
    );
  }

  /// 计算整数运算结果
  int _computeIntegerResult(String operator, int left, int right) {
    switch (operator) {
      case '+':
        return left + right;
      case '-':
        return left - right;
      case '*':
        return left * right;
      case '/':
        return right != 0 ? (left / right).round() : 0;
      case '~/':
        return right != 0 ? left ~/ right : 0;
      case '%':
        return right != 0 ? left % right : 0;
      case '&':
        return left & right;
      case '|':
        return left | right;
      case '^':
        return left ^ right;
      case '<<':
        return right >= 0 ? left << right : 0;
      case '>>':
        return right >= 0 ? left >> right : 0;
      default:
        throw UnsupportedError('不支持的整数运算符: $operator');
    }
  }

  /// 计算浮点运算结果
  double _computeDoubleResult(String operator, double left, double right) {
    switch (operator) {
      case '+':
        return left + right;
      case '-':
        return left - right;
      case '*':
        return left * right;
      case '/':
        return right != 0.0 ? left / right : 0.0;
      case '%':
        return right != 0.0 ? left % right : 0.0;
      default:
        throw UnsupportedError('不支持的浮点运算符: $operator');
    }
  }

  /// 转义字符串中的特殊字符
  String _escapeString(String s) {
    return s
        .replaceAll('\\', '\\\\')
        .replaceAll('"', '\\"')
        .replaceAll('\n', '\\n')
        .replaceAll('\r', '\\r')
        .replaceAll('\t', '\\t');
  }
}

  /// 折叠条件表达式
  ConstantFoldingResult _foldConditionalExpression(ConditionalExpression expr) {
    final condition = expr.condition;

    // 条件是布尔常量
    if (condition is BoolLiteral) {
      final chosenExpr = condition.value ? expr.thenExpression : expr.elseExpression;
      final chosenCode = _expressionConverter.convertExpression(chosenExpr);
      return ConstantFoldingResult(
        isOptimized: true,
        optimizedCode: chosenCode,
        originalCode: _expressionConverter.convertExpression(expr),
      );
    }

    // 无法优化
    return ConstantFoldingResult(
      isOptimized: false,
      optimizedCode: _expressionConverter.convertExpression(expr),
    );
  }

  /// 折叠比较表达式
  ConstantFoldingResult _foldComparisonExpression(BinaryExpression expr) {
    final left = expr.left;
    final right = expr.right;
    final operator = expr.operator;

    // Int比较
    if (left is IntLiteral && right is IntLiteral) {
      final l = left.value;
      final r = right.value;
      final result = _computeComparisonResult(operator, l, r);
      return ConstantFoldingResult(
        isOptimized: true,
        optimizedCode: 'Bool($result)',
        originalCode: _expressionConverter.convertExpression(expr),
      );
    }

    // Double比较
    if (left is DoubleLiteral && right is DoubleLiteral) {
      final l = left.value;
      final r = right.value;
      final result = _computeComparisonResult(operator, l, r);
      return ConstantFoldingResult(
        isOptimized: true,
        optimizedCode: 'Bool($result)',
        originalCode: _expressionConverter.convertExpression(expr),
      );
    }

    // Bool比较
    if (left is BoolLiteral && right is BoolLiteral) {
      final l = left.value;
      final r = right.value;
      final result = _computeComparisonResult(operator, l, r);
      return ConstantFoldingResult(
        isOptimized: true,
        optimizedCode: 'Bool($result)',
        originalCode: _expressionConverter.convertExpression(expr),
      );
    }

    // 无法优化
    return ConstantFoldingResult(
      isOptimized: false,
      optimizedCode: _expressionConverter.convertExpression(expr),
    );
  }

  /// 计算比较结果
  bool _computeComparisonResult(String operator, dynamic left, dynamic right) {
    switch (operator) {
      case '==':
        return left == right;
      case '!=':
        return left != right;
      case '<':
        return left < right;
      case '<=':
        return left <= right;
      case '>':
        return left > right;
      case '>=':
        return left >= right;
      default:
        throw UnsupportedError('不支持的比较运算符: $operator');
    }
  }

  /// 折叠逻辑表达式
  ConstantFoldingResult _foldLogicalExpression(BinaryExpression expr) {
    final left = expr.left;
    final right = expr.right;
    final operator = expr.operator;

    // Bool逻辑运算
    if (left is BoolLiteral && right is BoolLiteral) {
      final l = left.value;
      final r = right.value;
      final result = _computeLogicalResult(operator, l, r);
      return ConstantFoldingResult(
        isOptimized: true,
        optimizedCode: 'Bool($result)',
        originalCode: _expressionConverter.convertExpression(expr),
      );
    }

    // 无法优化
    return ConstantFoldingResult(
      isOptimized: false,
      optimizedCode: _expressionConverter.convertExpression(expr),
    );
  }

  /// 计算逻辑运算结果
  bool _computeLogicalResult(String operator, bool left, bool right) {
    switch (operator) {
      case '&&':
        return left && right;
      case '||':
        return left || right;
      default:
        throw UnsupportedError('不支持的逻辑运算符: $operator');
    }
  }

  /// 检查并折叠常量表达式（主入口）
  String foldConstants(String cppCode) {
    // 这里可以实现更复杂的常量传播
    // 目前主要通过AST级别的优化实现
    return cppCode;
  }
}

/// 扩展方法：为Expression添加常量折叠
extension ExpressionOptimization on Expression {
  /// 应用常量折叠优化
  String optimizeWithConstantFolding(ConstantFoldingOptimizer optimizer) {
    final result = optimizer.optimizeExpression(this);
    return result.optimizedCode;
  }
}
