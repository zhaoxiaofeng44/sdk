/// 函数内联优化器
///
/// 自动识别可以内联的函数，添加inline标记以提升性能
/// 适合小函数和简单表达式函数
///
/// 使用示例：
/// ```dart
/// final optimizer = InlineOptimizer(statementConverter);
/// final result = optimizer.analyzeFunction(procedure);
/// if (result.shouldInline) {
///   print('建议内联: ${result.reason}');
/// }
/// ```

import 'package:kernel/ast.dart';
import 'package:kernel/kernel.dart';
import '../dart_to_cpp_compiler.dart';

/// 函数内联分析结果
class InlineAnalysisResult {
  final bool shouldInline;
  final String reason;
  final String? optimizationNote;

  const InlineAnalysisResult({
    required this.shouldInline,
    required this.reason,
    this.optimizationNote,
  });
}

/// 函数内联优化器
class InlineOptimizer {
  final CppStatementConverter _statementConverter;

  InlineOptimizer(this._statementConverter);

  /// 分析函数是否应该内联
  InlineAnalysisResult analyzeFunction(Procedure procedure) {
    final name = procedure.name.text;
    final body = procedure.function.body;
    final paramCount = procedure.function.positionalParameters.length;

    // 空函数或抽象方法
    if (body == null || body is EmptyStatement) {
      return const InlineAnalysisResult(
        shouldInline: true,
        reason: '空函数',
        optimizationNote: '无实际代码',
      );
    }

    // 构造函数
    if (procedure.isConstructor) {
      return InlineAnalysisResult(
        shouldInline: paramCount <= 3,
        reason: paramCount <= 3 ? '简单构造函数' : '复杂构造函数',
        optimizationNote: '参数数量: $paramCount',
      );
    }

    // 析构函数
    if (procedure.isDestructor) {
      return const InlineAnalysisResult(
        shouldInline: true,
        reason: '析构函数',
        optimizationNote: '通常很简短',
      );
    }

    // Getter方法
    if (procedure.isGetter) {
      return const InlineAnalysisResult(
        shouldInline: true,
        reason: 'Getter方法',
        optimizationNote: 'Getter通常很简短',
      );
    }

    // Setter方法
    if (procedure.isSetter) {
      return const InlineAnalysisResult(
        shouldInline: true,
        reason: 'Setter方法',
        optimizationNote: 'Setter通常很简短',
      );
    }

    // 工厂构造函数
    if (procedure.isFactory) {
      return InlineAnalysisResult(
        shouldInline: paramCount <= 2,
        reason: paramCount <= 2 ? '简单工厂方法' : '复杂工厂方法',
        optimizationNote: '参数数量: $paramCount',
      );
    }

    // 静态方法且函数体简单
    if (procedure.isStatic && _isSimpleFunction(procedure)) {
      return const InlineAnalysisResult(
        shouldInline: true,
        reason: '静态简单函数',
        optimizationNote: '静态函数调用频繁，内联可提升性能',
      );
    }

    // 只有返回语句的小函数
    if (body is ReturnStatement) {
      final expr = body.expression;
      if (expr != null) {
        // 简单表达式（1-2个操作符）
        if (_isVerySimpleExpression(expr)) {
          return const InlineAnalysisResult(
            shouldInline: true,
            reason: '非常简单的表达式',
            optimizationNote: '1-2个操作符，可以完全内联',
          );
        }

        // 简单表达式（最多3个操作符）
        if (_isSimpleExpression(expr)) {
          return const InlineAnalysisResult(
            shouldInline: true,
            reason: '简单返回表达式',
            optimizationNote: '表达式简单，适合内联',
          );
        }

        // 单一二元运算
        if (expr is BinaryExpression && _countOperators(expr) == 1) {
          return const InlineAnalysisResult(
            shouldInline: true,
            reason: '单一二元运算',
            optimizationNote: '运算简单，可消除函数调用开销',
          );
        }
      }
    }

    // 只有单个语句的块
    if (body is Block) {
      final statements = body.statements;
      if (statements.length == 1) {
        final stmt = statements.first;
        if (stmt is ReturnStatement && stmt.expression != null) {
          return InlineAnalysisResult(
            shouldInline: _countOperators(stmt.expression!) <= 3,
            reason: '单语句返回',
            optimizationNote: '包含${_countOperators(stmt.expression!)}个操作符',
          );
        }
      }
    }

    // 参数过多的函数不建议内联
    if (paramCount > 5) {
      return InlineAnalysisResult(
        shouldInline: false,
        reason: '参数过多',
        optimizationNote: '参数数量: $paramCount，内联可能导致代码膨胀',
      );
    }

    // 根据函数大小判断
    final stmtCount = _countStatements(body);
    if (stmtCount <= 2) {
      return const InlineAnalysisResult(
        shouldInline: true,
        reason: '函数体很小',
        optimizationNote: '只有1-2个语句',
      );
    } else if (stmtCount <= 5) {
      return const InlineAnalysisResult(
        shouldInline: true,
        reason: '函数体较小',
        optimizationNote: '少于5个语句，可以内联',
      );
    }

    // 不建议内联
    return InlineAnalysisResult(
      shouldInline: false,
      reason: '函数体复杂',
      optimizationNote:
          '包含$stmtCount个语句和$paramCount个参数，不建议内联',
    );
  }

  /// 生成内联函数代码
  String generateInlineFunction(Procedure procedure) {
    final name = procedure.name.text;
    final returnType =
        CppTypeConverter.convertType(procedure.function.returnType);
    final params = _buildParameterList(procedure.function);
    final body = _convertBody(procedure.function.body!);

    return 'inline $returnType $name($params) $body';
  }

  /// 生成普通函数代码
  String generateNormalFunction(Procedure procedure) {
    final name = procedure.name.text;
    final returnType =
        CppTypeConverter.convertType(procedure.function.returnType);
    final params = _buildParameterList(procedure.function);
    final body = _convertBody(procedure.function.body!);

    return '$returnType $name($params) $body';
  }

  /// 判断是否是简单表达式
  bool _isSimpleExpression(Expression expr) {
    return expr is Literal || // 字面量
        expr is VariableGet || // 变量访问
        expr is ThisExpression || // this
        _countOperators(expr) <= 3; // 操作符不超过3个
  }

  /// 判断是否是非常简单的表达式
  bool _isVerySimpleExpression(Expression expr) {
    return expr is Literal || // 字面量
        expr is VariableGet || // 变量访问
        expr is ThisExpression || // this
        (expr is BinaryExpression && _countOperators(expr) <= 2) || // 二元运算
        (expr is UnaryExpression); // 一元运算
  }

  /// 判断是否是简单函数
  bool _isSimpleFunction(Procedure procedure) {
    final body = procedure.function.body;
    if (body == null) return true;

    // 统计语句数量
    final stmtCount = _countStatements(body);

    // 少于等于5个语句认为是简单函数
    return stmtCount <= 5;
  }

  /// 统计语句数量
  int _countStatements(Statement? body) {
    if (body == null) return 0;
    if (body is Block) {
      return body.statements.length;
    }
    return 1;
  }

  /// 统计表达式中的操作符数量
  int _countOperators(Expression expr) {
    if (expr is BinaryExpression) {
      return 1 + _countOperators(expr.left) + _countOperators(expr.right);
    } else if (expr is UnaryExpression) {
      return 1 + _countOperators(expr.operand);
    } else if (expr is ConditionalExpression) {
      return 1 + _countOperators(expr.condition) +
          _countOperators(expr.thenExpression) +
          _countOperators(expr.elseExpression);
    } else if (expr is StringConcatenation) {
      return expr.expressions.length - 1;
    }
    return 0;
  }

  /// 计算内联收益分数
  double calculateInlineBenefit(Procedure procedure) {
    final stmtCount = _countStatements(procedure.function.body);
    final paramCount = procedure.function.positionalParameters.length;
    final isHotPath = _isHotPath(procedure);
    final callFrequency = _estimateCallFrequency(procedure);

    // 基础分数：语句越少分数越高
    double score = 100 - (stmtCount * 10) - (paramCount * 5);

    // 热门路径加成
    if (isHotPath) {
      score *= 1.5;
    }

    // 高频调用加成
    score *= (1 + callFrequency * 0.1);

    // Getter/Setter加成
    if (procedure.isGetter || procedure.isSetter) {
      score *= 1.3;
    }

    return score;
  }

  /// 判断是否是热门路径（简化版判断）
  bool _isHotPath(Procedure procedure) {
    // 简化实现：构造函数和工厂方法通常在热点路径
    return procedure.isConstructor ||
        procedure.isFactory ||
        procedure.isGetter ||
        procedure.name.text.startsWith('get_') ||
        procedure.name.text.startsWith('set_');
  }

  /// 估算调用频率（简化版）
  double _estimateCallFrequency(Procedure procedure) {
    // 简化实现：静态方法和操作符重载通常被频繁调用
    if (procedure.isStatic) {
      return 5.0;
    }
    if (procedure.name.text.startsWith('operator')) {
      return 3.0;
    }
    return 1.0;
  }

  /// 构建参数列表
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

  /// 转换函数体
  String _convertBody(Statement body) {
    return _statementConverter.convertStatement(body);
  }
}

/// 扩展方法：为Procedure添加内联优化
extension ProcedureOptimization on Procedure {
  /// 分析是否应该内联
  InlineAnalysisResult analyzeInline(InlineOptimizer optimizer) {
    return optimizer.analyzeFunction(this);
  }

  /// 生成优化后的函数代码
  String generateOptimizedCode(InlineOptimizer optimizer) {
    final result = analyzeInline(optimizer);
    if (result.shouldInline) {
      return optimizer.generateInlineFunction(this);
    } else {
      return optimizer.generateNormalFunction(this);
    }
  }
}
