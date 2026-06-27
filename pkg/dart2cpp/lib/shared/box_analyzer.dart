/// Box 化预分析器 — 识别闭包捕获中需要装箱的变量。
///
/// 提取自 `restorer/dart_restorer.dart` 的 `_preanalyzeBoxedVarsForFunc`。
/// 逻辑与目标语言无关。
library box_analyzer;

import 'package:kernel/kernel.dart';

/// Box 化预分析器。
///
/// 规则：本层参数/局部变量中，凡是被嵌套 `FunctionExpression` 捕获、
/// 且类型为 `int`/`double`/`bool`/`String` 或 `TypeParameterType` 的，
/// 需要装箱（Box）以实现引用语义。
///
/// 排除：
/// - 命名参数（改名会破坏 named-arg 调用语义）
/// - for 循环变量（Dart 语义本就是每轮独立）
class BoxAnalyzer {
  BoxAnalyzer();

  /// 分析函数体中需要装箱的变量。
  ///
  /// 返回需要装箱的 `VariableDeclaration` 集合。
  Set<VariableDeclaration> analyze(FunctionNode func) {
    final result = <VariableDeclaration>{};

    // 收集本层参数（排除命名参数）
    final candidates = <VariableDeclaration>{};
    for (final p in func.positionalParameters) {
      candidates.add(p);
    }
    // 命名参数不装箱（改名会破坏语义）

    // 收集本层局部变量
    if (func.body != null) {
      _collectLocalVars(func.body!, candidates);
    }

    // 检查每个候选变量是否被嵌套闭包捕获且被修改
    for (final candidate in candidates) {
      if (_isBoxableType(candidate.type) &&
          _isCapturedByInnerClosure(func, candidate) &&
          _isMutated(func, candidate)) {
        result.add(candidate);
      }
    }

    return result;
  }

  /// 检查变量是否在函数体内被修改。
  bool _isMutated(FunctionNode func, VariableDeclaration variable) {
    if (func.body == null) return false;
    return _searchMutations(func.body!, variable);
  }

  /// 在表达式/语句树中搜索是否修改了指定变量。
  bool _searchMutations(TreeNode node, VariableDeclaration variable) {
    if (node is VariableSet && node.variable == variable) return true;
    if (node is FunctionExpression) {
      // 进入嵌套闭包：检查它是否修改了 variable
      return _closureMutates(node.function, variable);
    }
    // 递归搜索
    return _visitChildrenForMutation(node, variable);
  }

  /// 检查闭包函数体是否修改了指定变量。
  bool _closureMutates(FunctionNode func, VariableDeclaration variable) {
    if (func.body == null) return false;
    return _searchMutations(func.body!, variable);
  }

  bool _visitChildrenForMutation(TreeNode node, VariableDeclaration variable) {
    if (node is Block) {
      return node.statements.any((s) => _searchMutations(s, variable));
    }
    if (node is ExpressionStatement) {
      return _searchMutations(node.expression, variable);
    }
    if (node is ReturnStatement) {
      return node.expression != null
          ? _searchMutations(node.expression!, variable)
          : false;
    }
    if (node is VariableDeclaration) {
      return node.initializer != null
          ? _searchMutations(node.initializer!, variable)
          : false;
    }
    if (node is IfStatement) {
      return _searchMutations(node.condition, variable) ||
          _searchMutations(node.then, variable) ||
          (node.otherwise != null
              ? _searchMutations(node.otherwise!, variable)
              : false);
    }
    if (node is ForStatement) {
      return _searchMutations(node.body, variable) ||
          (node.condition != null
              ? _searchMutations(node.condition!, variable)
              : false);
    }
    if (node is ForInStatement) {
      return _searchMutations(node.body, variable) ||
          _searchMutations(node.iterable, variable);
    }
    if (node is WhileStatement) {
      return _searchMutations(node.condition, variable) ||
          _searchMutations(node.body, variable);
    }
    if (node is DoStatement) {
      return _searchMutations(node.body, variable) ||
          _searchMutations(node.condition, variable);
    }
    if (node is TryCatch) {
      return _searchMutations(node.body, variable) ||
          node.catches.any((c) => _searchMutations(c.body, variable));
    }
    if (node is TryFinally) {
      return _searchMutations(node.body, variable) ||
          _searchMutations(node.finalizer, variable);
    }
    if (node is InstanceInvocation) {
      return _searchMutations(node.receiver, variable) ||
          node.arguments.positional.any((a) => _searchMutations(a, variable));
    }
    if (node is SwitchStatement) {
      return node.cases.any((c) =>
          c.expressions.any((e) => _searchMutations(e, variable)) ||
          _searchMutations(c.body, variable));
    }
    return false;
  }

  /// 判断类型是否需要装箱。
  ///
  /// 基础值类型（int/double/bool/String）和泛型参数需要装箱；
  /// 确定的引用类型（List/Map/函数/用户类）不需要。
  bool _isBoxableType(DartType type) {
    if (type is InterfaceType) {
      final name = type.classNode.name;
      return name == 'int' ||
          name == 'double' ||
          name == 'bool' ||
          name == 'String';
    }
    if (type is TypeParameterType) return true;
    return false;
  }

  /// 检查变量是否被嵌套闭包捕获。
  bool _isCapturedByInnerClosure(
      FunctionNode func, VariableDeclaration variable) {
    if (func.body == null) return false;
    return _searchCapturedInClosures(func.body!, variable);
  }

  /// 在嵌套闭包中搜索是否引用了指定变量。
  bool _searchCapturedInClosures(
      TreeNode node, VariableDeclaration variable) {
    if (node is FunctionExpression) {
      // 进入嵌套闭包：检查它是否引用了 variable
      return _closureReferences(node.function, variable);
    }
    // 递归搜索
    return _visitChildrenForCapture(node, variable);
  }

  /// 检查闭包函数体是否引用了指定变量。
  bool _closureReferences(FunctionNode func, VariableDeclaration variable) {
    if (func.body == null) return false;
    return _bodyReferences(func.body!, variable);
  }

  /// 递归检查表达式/语句树是否引用了指定变量。
  bool _bodyReferences(TreeNode node, VariableDeclaration variable) {
    if (node is VariableGet && node.variable == variable) return true;
    if (node is VariableSet && node.variable == variable) return true;
    if (node is FunctionExpression) {
      // 递归进入更深层的闭包
      return _closureReferences(node.function, variable);
    }
    return _visitChildrenForRef(node, variable);
  }

  bool _visitChildrenForCapture(
      TreeNode node, VariableDeclaration variable) {
    if (node is Block) {
      return node.statements
          .any((s) => _searchCapturedInClosures(s, variable));
    }
    if (node is ExpressionStatement) {
      return _searchCapturedInClosures(node.expression, variable);
    }
    if (node is ReturnStatement) {
      return node.expression != null
          ? _searchCapturedInClosures(node.expression!, variable)
          : false;
    }
    if (node is VariableDeclaration) {
      return node.initializer != null
          ? _searchCapturedInClosures(node.initializer!, variable)
          : false;
    }
    if (node is IfStatement) {
      return _searchCapturedInClosures(node.condition, variable) ||
          _searchCapturedInClosures(node.then, variable) ||
          (node.otherwise != null
              ? _searchCapturedInClosures(node.otherwise!, variable)
              : false);
    }
    if (node is ForStatement) {
      return _searchCapturedInClosures(node.body, variable);
    }
    if (node is WhileStatement) {
      return _searchCapturedInClosures(node.condition, variable) ||
          _searchCapturedInClosures(node.body, variable);
    }
    if (node is DoStatement) {
      return _searchCapturedInClosures(node.body, variable) ||
          _searchCapturedInClosures(node.condition, variable);
    }
    if (node is TryCatch) {
      return _searchCapturedInClosures(node.body, variable) ||
          node.catches.any((c) => _searchCapturedInClosures(c.body, variable));
    }
    if (node is TryFinally) {
      return _searchCapturedInClosures(node.body, variable) ||
          _searchCapturedInClosures(node.finalizer, variable);
    }
    if (node is InstanceInvocation) {
      return _searchCapturedInClosures(node.receiver, variable) ||
          node.arguments.positional
              .any((a) => _searchCapturedInClosures(a, variable));
    }
    if (node is ForInStatement) {
      return _searchCapturedInClosures(node.body, variable);
    }
    if (node is SwitchStatement) {
      return node.cases
          .any((c) => _searchCapturedInClosures(c.body, variable));
    }
    return false;
  }

  bool _visitChildrenForRef(TreeNode node, VariableDeclaration variable) {
    if (node is Block) {
      return node.statements.any((s) => _bodyReferences(s, variable));
    }
    if (node is ExpressionStatement) {
      return _bodyReferences(node.expression, variable);
    }
    if (node is ReturnStatement) {
      return node.expression != null
          ? _bodyReferences(node.expression!, variable)
          : false;
    }
    if (node is VariableDeclaration) {
      return node.initializer != null
          ? _bodyReferences(node.initializer!, variable)
          : false;
    }
    if (node is VariableSet) {
      return _bodyReferences(node.value, variable);
    }
    if (node is IfStatement) {
      return _bodyReferences(node.condition, variable) ||
          _bodyReferences(node.then, variable) ||
          (node.otherwise != null
              ? _bodyReferences(node.otherwise!, variable)
              : false);
    }
    if (node is ForStatement) {
      return _bodyReferences(node.body, variable) ||
          (node.condition != null
              ? _bodyReferences(node.condition!, variable)
              : false);
    }
    if (node is ForInStatement) {
      return _bodyReferences(node.body, variable) ||
          _bodyReferences(node.iterable, variable);
    }
    if (node is WhileStatement) {
      return _bodyReferences(node.condition, variable) ||
          _bodyReferences(node.body, variable);
    }
    if (node is DoStatement) {
      return _bodyReferences(node.body, variable) ||
          _bodyReferences(node.condition, variable);
    }
    if (node is TryCatch) {
      return _bodyReferences(node.body, variable) ||
          node.catches.any((c) => _bodyReferences(c.body, variable));
    }
    if (node is TryFinally) {
      return _bodyReferences(node.body, variable) ||
          _bodyReferences(node.finalizer, variable);
    }
    if (node is InstanceInvocation) {
      return _bodyReferences(node.receiver, variable) ||
          node.arguments.positional.any((a) => _bodyReferences(a, variable)) ||
          node.arguments.named.any((a) => _bodyReferences(a.value, variable));
    }
    if (node is InstanceGet) {
      return _bodyReferences(node.receiver, variable);
    }
    if (node is InstanceSet) {
      return _bodyReferences(node.receiver, variable) ||
          _bodyReferences(node.value, variable);
    }
    if (node is StaticInvocation) {
      return node.arguments.positional.any((a) => _bodyReferences(a, variable));
    }
    if (node is ConstructorInvocation) {
      return node.arguments.positional.any((a) => _bodyReferences(a, variable));
    }
    if (node is ConditionalExpression) {
      return _bodyReferences(node.condition, variable) ||
          _bodyReferences(node.then, variable) ||
          _bodyReferences(node.otherwise, variable);
    }
    if (node is LogicalExpression) {
      return _bodyReferences(node.left, variable) ||
          _bodyReferences(node.right, variable);
    }
    if (node is Not) {
      return _bodyReferences(node.operand, variable);
    }
    if (node is StringConcatenation) {
      return node.expressions.any((p) => _bodyReferences(p, variable));
    }
    if (node is Let) {
      return _bodyReferences(node.variable, variable) ||
          _bodyReferences(node.body, variable);
    }
    if (node is BlockExpression) {
      return node.body.statements.any((s) => _bodyReferences(s, variable)) ||
          _bodyReferences(node.value, variable);
    }
    if (node is AsExpression) {
      return _bodyReferences(node.operand, variable);
    }
    if (node is IsExpression) {
      return _bodyReferences(node.operand, variable);
    }
    if (node is FunctionInvocation) {
      return _bodyReferences(node.receiver, variable) ||
          node.arguments.positional.any((a) => _bodyReferences(a, variable));
    }
    if (node is Throw) {
      return _bodyReferences(node.expression, variable);
    }
    if (node is AwaitExpression) {
      return _bodyReferences(node.operand, variable);
    }
    if (node is ListLiteral) {
      return node.expressions.any((e) => _bodyReferences(e, variable));
    }
    if (node is MapLiteral) {
      return node.entries.any(
          (e) => _bodyReferences(e.key, variable) || _bodyReferences(e.value, variable));
    }
    if (node is SetLiteral) {
      return node.expressions.any((e) => _bodyReferences(e, variable));
    }
    if (node is SwitchStatement) {
      return node.cases.any((c) =>
          c.expressions.any((e) => _bodyReferences(e, variable)) ||
          _bodyReferences(c.body, variable));
    }
    if (node is YieldStatement) {
      return _bodyReferences(node.expression, variable);
    }
    if (node is AssertStatement) {
      return _bodyReferences(node.condition, variable);
    }
    if (node is LabeledStatement) {
      return _bodyReferences(node.body, variable);
    }
    return false;
  }

  /// 收集函数体内声明的所有局部变量。
  void _collectLocalVars(TreeNode node, Set<VariableDeclaration> vars) {
    if (node is VariableDeclaration) {
      vars.add(node);
    }
    if (node is FunctionExpression) return; // 不进入嵌套闭包
    if (node is Block) {
      for (final stmt in node.statements) {
        _collectLocalVars(stmt, vars);
      }
    } else if (node is ExpressionStatement) {
      _collectLocalVars(node.expression, vars);
    } else if (node is IfStatement) {
      _collectLocalVars(node.then, vars);
      if (node.otherwise != null) _collectLocalVars(node.otherwise!, vars);
    } else if (node is ForStatement) {
      for (final v in node.variables) {
        vars.add(v);
      }
      _collectLocalVars(node.body, vars);
    } else if (node is ForInStatement) {
      vars.add(node.variable);
      _collectLocalVars(node.body, vars);
    } else if (node is WhileStatement) {
      _collectLocalVars(node.body, vars);
    } else if (node is DoStatement) {
      _collectLocalVars(node.body, vars);
    } else if (node is TryCatch) {
      _collectLocalVars(node.body, vars);
      for (final c in node.catches) {
        _collectLocalVars(c.body, vars);
      }
    } else if (node is TryFinally) {
      _collectLocalVars(node.body, vars);
      _collectLocalVars(node.finalizer, vars);
    } else if (node is SwitchStatement) {
      for (final c in node.cases) {
        _collectLocalVars(c.body, vars);
      }
    }
  }
}
