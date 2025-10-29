/// 字符串操作优化器
///
/// 优化字符串拼接和插值操作，减少临时对象创建
/// 支持StringBuilder模式和格式化函数模式
///
/// 使用示例：
/// ```dart
/// final optimizer = StringOptimizer(expressionConverter);
/// final result = optimizer.optimizeStringConcatenation(concatExpr);
/// print('优化策略: ${result.optimizationStrategy}');
/// ```

import 'package:kernel/ast.dart';
import '../dart_to_cpp_compiler.dart';

/// 字符串优化结果
class StringOptimizationResult {
  final bool isOptimized;
  final String optimizedCode;
  final String optimizationStrategy;
  final int tempObjectCount; // 减少的临时对象数量

  const StringOptimizationResult({
    required this.isOptimized,
    required this.optimizedCode,
    required this.optimizationStrategy,
    required this.tempObjectCount,
  });
}

/// 字符串操作优化器
class StringOptimizer {
  final CppExpressionConverter _expressionConverter;
  int _counter = 0; // 用于生成唯一变量名
  final String _prefix; // 变量名前缀

  StringOptimizer(this._expressionConverter, [this._prefix = 's']);

  /// 优化字符串拼接
  StringOptimizationResult optimizeStringConcatenation(
      StringConcatenation expr) {
    final parts = expr.expressions;
    final stringParts = <String>[];
    final expressionParts = <Expression>[];

    // 分离字符串常量和表达式
    for (final part in parts) {
      if (part is StringLiteral) {
        stringParts.add(part.value);
      } else {
        expressionParts.add(part);
      }
    }

    // 没有表达式，只有纯字符串
    if (expressionParts.isEmpty) {
      final result = stringParts.join('');
      return StringOptimizationResult(
        isOptimized: true,
        optimizedCode: 'String("${_escapeString(result)}")',
        optimizationStrategy: '纯字符串合并',
        tempObjectCount: parts.length - 1,
      );
    }

    // 表达式数量很少，直接拼接
    if (expressionParts.length <= 2) {
      return _optimizeSimpleConcatenation(parts);
    }

    // 表达式较多，使用StringBuilder
    return _optimizeWithStringBuilder(parts);
  }

  /// 优化简单的字符串拼接
  StringOptimizationResult _optimizeSimpleConcatenation(
      List<Expression> parts) {
    final code = _expressionConverter.convertExpression(
      StringConcatenation(expressions: parts),
    );

    return StringOptimizationResult(
      isOptimized: false,
      optimizedCode: code,
      optimizationStrategy: '直接拼接',
      tempObjectCount: 0,
    );
  }

  /// 使用StringBuilder优化
  StringOptimizationResult _optimizeWithStringBuilder(
      List<Expression> parts) {
    final bufferVar = '${_prefix}_sb_${_counter++}';
    final codeParts = <String>[];

    // 创建StringBuilder
    codeParts.add('ObjectPtr<StringBuilder> $bufferVar(new StringBuilder())');

    // 添加每个部分
    for (final part in parts) {
      if (part is StringLiteral) {
        codeParts.add('$bufferVar->append(String("${_escapeString(part.value)}"))');
      } else {
        final exprCode = _expressionConverter.convertExpression(part);
        codeParts.add('$bufferVar->append(($exprCode).toString())');
      }
    }

    // 构建最终字符串
    final resultVar = '${_prefix}_result_${_counter++}';
    codeParts.add('String $resultVar = $bufferVar->build()');

    final optimizedCode = codeParts.join('; ');

    return StringOptimizationResult(
      isOptimized: true,
      optimizedCode: optimizedCode,
      optimizationStrategy: 'StringBuilder模式',
      tempObjectCount: parts.length - 1,
    );
  }

  /// 优化字符串插值
  StringOptimizationResult optimizeStringInterpolation(
      StringConcatenation expr) {
    final parts = expr.expressions;

    // 只有一个表达式，直接转换
    if (parts.length == 1 &&
        parts[0] is! StringLiteral) {
      final exprCode = _expressionConverter.convertExpression(parts[0]);
      return StringOptimizationResult(
        isOptimized: false,
        optimizedCode: '($exprCode).toString()',
        optimizationStrategy: '直接转换',
        tempObjectCount: 0,
      );
    }

    // 使用StringBuilder处理复杂插值
    return optimizeStringConcatenation(expr);
  }

  /// 转义字符串中的特殊字符
  String _escapeString(String s) {
    return s
        .replaceAll('\\', '\\\\')
        .replaceAll('"', '\\"')
        .replaceAll('\n', '\\n')
        .replaceAll('\r', '\\r')
        .replaceAll('\t', '\\t')
        .replaceAll('\b', '\\b')
        .replaceAll('\f', '\\f');
  }

  /// 重置计数器
  void resetCounter() {
    _counter = 0;
  }

  /// 设置变量名前缀
  void setPrefix(String prefix) {
    _prefix = prefix;
    resetCounter();
  }

  /// 优化字符串格式化
  StringOptimizationResult optimizeStringFormat(StringLiteral formatExpr,
      List<Expression> arguments) {
    final format = formatExpr.value;
    final bufferVar = '${_prefix}_fmt_${_counter++}';
    final codeParts = <String>[];

    // 创建StringBuilder
    codeParts.add('ObjectPtr<StringBuilder> $bufferVar(new StringBuilder())');

    // 解析格式字符串并添加参数
    int argIndex = 0;
    final regex = RegExp(r'\{(\*)?\}');
    for (Match match in regex.allMatches(format)) {
      final beforeMatch = format.substring(
          match.start == 0 ? 0 : match.start - 1, match.start);
      codeParts.add('$bufferVar->append(String("${_escapeString(beforeMatch)}"))');

      if (argIndex < arguments.length) {
        final argExpr = arguments[argIndex++];
        final argCode = _expressionConverter.convertExpression(argExpr);
        codeParts.add('$bufferVar->append(($argCode).toString())');
      }
    }

    // 添加剩余的格式字符串
    final lastMatch = regex.allMatches(format).last;
    if (lastMatch.end < format.length) {
      final afterFormat = format.substring(lastMatch.end);
      codeParts.add('$bufferVar->append(String("${_escapeString(afterFormat)}"))');
    }

    // 构建最终字符串
    final resultVar = '${_prefix}_result_${_counter++}';
    codeParts.add('String $resultVar = $bufferVar->build()');

    final optimizedCode = codeParts.join('; ');

    return StringOptimizationResult(
      isOptimized: true,
      optimizedCode: optimizedCode,
      optimizationStrategy: '字符串格式化优化',
      tempObjectCount: arguments.length,
    );
  }
}

/// 扩展方法：为StringConcatenation添加字符串优化
extension StringOptimizationExtension on StringConcatenation {
  /// 应用字符串优化
  StringOptimizationResult optimizeString(
      StringOptimizer optimizer) {
    return optimizer.optimizeStringConcatenation(this);
  }
}
