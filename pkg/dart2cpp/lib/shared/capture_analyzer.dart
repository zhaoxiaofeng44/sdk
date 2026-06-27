/// 闭包捕获分析器 — 纯 AST 遍历，输出捕获变量集合。
///
/// 提取自 `restorer/dart_restorer.dart` 的 `analyzeCapturedVarsFromFunc`。
/// 逻辑与目标语言无关。
library capture_analyzer;

import 'package:kernel/kernel.dart';

/// 捕获分析结果。
class CaptureAnalysis {
  /// 被捕获的外部变量声明。
  final List<VariableDeclaration> capturedDecls;

  /// 是否捕获了 `this`。
  final bool capturesThis;

  const CaptureAnalysis(this.capturedDecls, this.capturesThis);
}

/// 闭包捕获分析器。
///
/// 分析一个 `FunctionNode` 捕获了哪些外部变量和是否捕获 `this`。
class CaptureAnalyzer {
  CaptureAnalyzer();

  /// 分析函数节点的捕获情况。
  CaptureAnalysis analyze(FunctionNode func) {
    // 收集本层声明的变量（参数 + 局部变量）
    final localDecls = <VariableDeclaration>{};
    for (final p in func.positionalParameters) {
      localDecls.add(p);
    }
    for (final p in func.namedParameters) {
      localDecls.add(p);
    }
    if (func.body != null) {
      _collectLocalDecls(func.body!, localDecls);
    }

    // 收集被引用的外部变量
    final captured = <VariableDeclaration>{};
    var capturesThis = false;

    if (func.body != null) {
      _collectCaptures(func.body!, localDecls, captured, () => capturesThis,
          (v) => capturesThis = v);
    }

    return CaptureAnalysis(captured.toList(), capturesThis);
  }

  /// 收集函数体内声明的所有局部变量。
  void _collectLocalDecls(
      TreeNode node, Set<VariableDeclaration> localDecls) {
    if (node is VariableDeclaration) {
      localDecls.add(node);
    }
    if (node is FunctionExpression) {
      // 不进入嵌套闭包（它们的捕获由各自分析）
      return;
    }
    _visitChildren(node, (child) => _collectLocalDecls(child, localDecls));
  }

  /// 收集被引用的、不在本地声明集中的变量。
  void _collectCaptures(
    TreeNode node,
    Set<VariableDeclaration> localDecls,
    Set<VariableDeclaration> captured,
    bool Function() getCapturesThis,
    void Function(bool) setCapturesThis,
  ) {
    if (node is VariableGet) {
      if (!localDecls.contains(node.variable)) {
        captured.add(node.variable);
      }
    } else if (node is VariableSet) {
      if (!localDecls.contains(node.variable)) {
        captured.add(node.variable);
      }
    } else if (node is ThisExpression) {
      setCapturesThis(true);
    } else if (node is FunctionExpression) {
      // 嵌套闭包：递归分析其捕获，将结果合并到本层
      final innerAnalysis = analyze(node.function);
      for (final decl in innerAnalysis.capturedDecls) {
        if (!localDecls.contains(decl)) {
          captured.add(decl);
        }
      }
      if (innerAnalysis.capturesThis && !localDecls.any((d) => d.name == '#this')) {
        setCapturesThis(true);
      }
      return; // 不继续递归进入闭包体
    }
    _visitChildren(
        node,
        (child) =>
            _collectCaptures(child, localDecls, captured, getCapturesThis, setCapturesThis));
  }

  /// 通用子节点遍历。
  void _visitChildren(TreeNode node, void Function(TreeNode) visit) {
    if (node is Block) {
      for (final stmt in node.statements) {
        visit(stmt);
      }
    } else if (node is ExpressionStatement) {
      visit(node.expression);
    } else if (node is ReturnStatement) {
      if (node.expression != null) visit(node.expression!);
    } else if (node is VariableDeclaration) {
      if (node.initializer != null) visit(node.initializer!);
    } else if (node is VariableSet) {
      visit(node.value);
    } else if (node is IfStatement) {
      visit(node.condition);
      visit(node.then);
      if (node.otherwise != null) visit(node.otherwise!);
    } else if (node is ForStatement) {
      for (final v in node.variables) {
        visit(v);
      }
      if (node.condition != null) visit(node.condition!);
      for (final u in node.updates) {
        visit(u);
      }
      visit(node.body);
    } else if (node is ForInStatement) {
      visit(node.iterable);
      visit(node.body);
    } else if (node is WhileStatement) {
      visit(node.condition);
      visit(node.body);
    } else if (node is DoStatement) {
      visit(node.body);
      visit(node.condition);
    } else if (node is TryCatch) {
      visit(node.body);
      for (final c in node.catches) {
        visit(c.body);
      }
    } else if (node is TryFinally) {
      visit(node.body);
      visit(node.finalizer);
    } else if (node is SwitchStatement) {
      visit(node.expression);
      for (final c in node.cases) {
        for (final e in c.expressions) {
          visit(e);
        }
        visit(c.body);
      }
    } else if (node is InstanceInvocation) {
      visit(node.receiver);
      for (final arg in node.arguments.positional) {
        visit(arg);
      }
      for (final arg in node.arguments.named) {
        visit(arg.value);
      }
    } else if (node is InstanceGet) {
      visit(node.receiver);
    } else if (node is InstanceSet) {
      visit(node.receiver);
      visit(node.value);
    } else if (node is StaticInvocation) {
      for (final arg in node.arguments.positional) {
        visit(arg);
      }
      for (final arg in node.arguments.named) {
        visit(arg.value);
      }
    } else if (node is ConstructorInvocation) {
      for (final arg in node.arguments.positional) {
        visit(arg);
      }
      for (final arg in node.arguments.named) {
        visit(arg.value);
      }
    } else if (node is ConditionalExpression) {
      visit(node.condition);
      visit(node.then);
      visit(node.otherwise);
    } else if (node is EqualsCall) {
      visit(node.left);
      visit(node.right);
    } else if (node is LogicalExpression) {
      visit(node.left);
      visit(node.right);
    } else if (node is Not) {
      visit(node.operand);
    } else if (node is StringConcatenation) {
      for (final part in node.expressions) {
        visit(part);
      }
    } else if (node is Let) {
      visit(node.variable);
      visit(node.body);
    } else if (node is BlockExpression) {
      for (final stmt in node.body.statements) {
        visit(stmt);
      }
      visit(node.value);
    } else if (node is AsExpression) {
      visit(node.operand);
    } else if (node is IsExpression) {
      visit(node.operand);
    } else if (node is FunctionInvocation) {
      visit(node.receiver);
      for (final arg in node.arguments.positional) {
        visit(arg);
      }
    } else if (node is Throw) {
      visit(node.expression);
    } else if (node is AwaitExpression) {
      visit(node.operand);
    } else if (node is ListLiteral) {
      for (final e in node.expressions) {
        visit(e);
      }
    } else if (node is MapLiteral) {
      for (final e in node.entries) {
        visit(e.key);
        visit(e.value);
      }
    } else if (node is SetLiteral) {
      for (final e in node.expressions) {
        visit(e);
      }
    } else if (node is SuperMethodInvocation) {
      for (final arg in node.arguments.positional) {
        visit(arg);
      }
    } else if (node is SuperPropertyGet) {
      // no receiver to visit
    } else if (node is SuperPropertySet) {
      visit(node.value);
    } else if (node is YieldStatement) {
      visit(node.expression);
    } else if (node is AssertStatement) {
      visit(node.condition);
      if (node.message != null) visit(node.message!);
    } else if (node is LabeledStatement) {
      visit(node.body);
    }
  }
}
