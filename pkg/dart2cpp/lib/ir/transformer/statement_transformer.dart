/// 语句转换器 — 将 Kernel Statement 转为 IrStatement。
///
/// 合并自：
/// - `restorer/statement_restorer.dart`
/// - `cpp_compiler/statement_emitter.dart`
library statement_transformer;

import 'package:kernel/kernel.dart';
import 'package:dart2cpp/ir/ir_nodes.dart';
import 'package:dart2cpp/shared/shared.dart';
import 'ir_transformer.dart';

/// 语句转换器。
class StatementTransformer {
  final IrTransformer ir;

  StatementTransformer(this.ir);

  /// 将 Kernel Statement 转为 IrStatement。
  IrStatement transform(Statement stmt) {
    if (stmt is Block) return _transformBlock(stmt);
    if (stmt is ExpressionStatement) return _transformExprStmt(stmt);
    if (stmt is ReturnStatement) return _transformReturn(stmt);
    if (stmt is VariableDeclaration) return _transformVarDecl(stmt);
    if (stmt is IfStatement) return _transformIf(stmt);
    if (stmt is ForStatement) return _transformFor(stmt);
    if (stmt is ForInStatement) return _transformForIn(stmt);
    if (stmt is WhileStatement) return _transformWhile(stmt);
    if (stmt is DoStatement) return _transformDoWhile(stmt);
    if (stmt is TryCatch) return _transformTryCatch(stmt);
    if (stmt is TryFinally) return _transformTryFinally(stmt);
    if (stmt is SwitchStatement) return _transformSwitch(stmt);
    if (stmt is BreakStatement) return const IrBreakStmt();
    if (stmt is LabeledStatement) return _transformLabeled(stmt);
    if (stmt is YieldStatement) return _transformYield(stmt);
    if (stmt is FunctionDeclaration) return _transformFuncDecl(stmt);
    if (stmt is AssertStatement) {
      return IrAssertStmt(
        ir.expressionTransformer.transform(stmt.condition),
        stmt.message != null
            ? ir.expressionTransformer.transform(stmt.message!)
            : null,
      );
    }
    if (stmt is EmptyStatement) return const IrBlockStmt([]);

    // Fallback
    return IrExprStmt(IrRawCode(
      dartCode: '/* unknown stmt: ${stmt.runtimeType} */',
      cppCode: '/* unknown stmt: ${stmt.runtimeType} */',
    ));
  }

  IrBlockStmt _transformBlock(Block block) {
    return IrBlockStmt(
        block.statements.map((s) => transform(s)).toList());
  }

  IrExprStmt _transformExprStmt(ExpressionStatement stmt) {
    // 过滤 ReachabilityError throw
    if (stmt.expression is Throw) {
      final throwExpr = stmt.expression as Throw;
      if (throwExpr.expression is StaticInvocation) {
        final target = (throwExpr.expression as StaticInvocation).target;
        if (target.name.text == '_throwRangeError' ||
            target.name.text == '_throwConcurrentModificationError') {
          // 过滤掉 — 这些是 Kernel 合成的
        }
      }
    }
    return IrExprStmt(ir.expressionTransformer.transform(stmt.expression));
  }

  IrStatement _transformReturn(ReturnStatement stmt) {
    // Async functions return Promise<T>, so wrap the value with Promise.value()
    if (ir.insideAsyncFunction && stmt.expression != null) {
      final value = ir.expressionTransformer.transform(stmt.expression!);
      return IrReturnStmt(
        value: IrStaticCall('Promise.value', [value],
            typeArgs: [ir.asyncInnerReturnType],
            isStaticMethod: true),
        returnType: ir.currentFunctionReturnType,
      );
    }
    // void functions: discard return value — emit expr as side effect + bare return
    if (ir.currentFunctionReturnType is IrVoidType && stmt.expression != null) {
      final value = ir.expressionTransformer.transform(stmt.expression!);
      return IrBlockStmt([
        IrExprStmt(value),
        IrReturnStmt(value: null, returnType: ir.currentFunctionReturnType),
      ]);
    }
    return IrReturnStmt(
      value: stmt.expression != null
          ? ir.expressionTransformer.transform(stmt.expression!)
          : null,
      returnType: ir.currentFunctionReturnType,
    );
  }

  IrVarDecl _transformVarDecl(VariableDeclaration decl) {
    final name = _cleanVarName(decl.name);
    final dartType = decl.type;
    final irType = ir.typeTransformer.transform(dartType);

    final isBoxed = ir.boxedVars.contains(decl);
    IrBoxType? boxType;
    if (isBoxed) {
      boxType = ir.typeTransformer.getBoxType(dartType);
    }

    IrExpression? init;
    if (decl.initializer != null) {
      init = ir.expressionTransformer.transform(decl.initializer!);
    }

    // 检查是否需要 late 修饰（Dart：未初始化的非空变量）
    final isLate = decl.initializer == null &&
        !irType.toString().endsWith('?') &&
        irType is! IrDynamicType &&
        irType is! IrVoidType;

    // 检查是否需要静态集合包装
    bool needsStaticWrap = false;
    String? staticWrapClass;
    if (init != null && _needsStaticCollectionWrap(dartType, decl.initializer!)) {
      needsStaticWrap = true;
      final category = TypeClassifier.classify(dartType);
      switch (category) {
        case TypeCategory.collectionList:
          staticWrapClass = 'StaticList';
          break;
        case TypeCategory.collectionMap:
          staticWrapClass = 'StaticMap';
          break;
        case TypeCategory.collectionSet:
          staticWrapClass = 'StaticSet';
          break;
        default:
          break;
      }
    }

    return IrVarDecl(
      name,
      irType,
      init: init,
      isLate: isLate,
      isBoxed: isBoxed,
      boxType: boxType,
      needsStaticWrap: needsStaticWrap,
      staticWrapClass: staticWrapClass,
    );
  }

  IrIfStmt _transformIf(IfStatement stmt) {
    return IrIfStmt(
      ir.expressionTransformer.transform(stmt.condition),
      transform(stmt.then),
      stmt.otherwise != null ? transform(stmt.otherwise!) : null,
    );
  }

  IrForStmt _transformFor(ForStatement stmt) {
    IrStatement? init;
    if (stmt.variables.isNotEmpty) {
      // 单个变量声明作为初始化
      if (stmt.variables.length == 1) {
        init = _transformVarDecl(stmt.variables.first);
      } else {
        init = IrBlockStmt(
            stmt.variables.map((v) => _transformVarDecl(v)).toList());
      }
    }

    IrExpression? condition;
    if (stmt.condition != null) {
      condition = ir.expressionTransformer.transform(stmt.condition!);
    }

    final updaters =
        stmt.updates.map((u) => ir.expressionTransformer.transform(u)).toList();

    return IrForStmt(
      transform(stmt.body),
      init: init,
      condition: condition,
      updaters: updaters,
    );
  }

  IrForInStmt _transformForIn(ForInStatement stmt) {
    final varName = _cleanVarName(stmt.variable.name);
    final varType = ir.typeTransformer.transform(stmt.variable.type);
    return IrForInStmt(
      varName,
      varType,
      ir.expressionTransformer.transform(stmt.iterable),
      transform(stmt.body),
    );
  }

  IrWhileStmt _transformWhile(WhileStatement stmt) {
    return IrWhileStmt(
      ir.expressionTransformer.transform(stmt.condition),
      transform(stmt.body),
    );
  }

  IrDoWhileStmt _transformDoWhile(DoStatement stmt) {
    return IrDoWhileStmt(
      transform(stmt.body),
      ir.expressionTransformer.transform(stmt.condition),
    );
  }

  IrTryCatch _transformTryCatch(TryCatch stmt) {
    final catches = stmt.catches.map((c) {
      return IrCatchClause(
        transform(c.body),
        exceptionType: ir.typeTransformer.transform(c.guard, isExceptionType: true),
        exceptionVar: c.exception != null
            ? _cleanVarName(c.exception!.name)
            : null,
        stackTraceVar: c.stackTrace != null
            ? _cleanVarName(c.stackTrace!.name)
            : null,
      );
    }).toList();

    return IrTryCatch(
      transform(stmt.body),
      catches: catches,
    );
  }

  IrTryCatch _transformTryFinally(TryFinally stmt) {
    // TryFinally 可能包裹 TryCatch → 合并为 try { } catch { } finally { }
    if (stmt.body is TryCatch) {
      final tryCatch = stmt.body as TryCatch;
      final catches = tryCatch.catches.map((c) {
        return IrCatchClause(
          transform(c.body),
          exceptionType: ir.typeTransformer.transform(c.guard, isExceptionType: true),
          exceptionVar: c.exception != null
              ? _cleanVarName(c.exception!.name)
              : null,
          stackTraceVar: c.stackTrace != null
              ? _cleanVarName(c.stackTrace!.name)
              : null,
        );
      }).toList();

      return IrTryCatch(
        transform(tryCatch.body),
        catches: catches,
        finallyBody: transform(stmt.finalizer),
      );
    }

    return IrTryCatch(
      transform(stmt.body),
      finallyBody: transform(stmt.finalizer),
    );
  }

  IrSwitchStmt _transformSwitch(SwitchStatement stmt) {
    final subject = ir.expressionTransformer.transform(stmt.expression);
    final cases = <IrSwitchCase>[];
    IrStatement? defaultCase;

    for (final sc in stmt.cases) {
      if (sc.expressions.isEmpty) {
        // default case
        defaultCase = transform(sc.body);
      } else {
        final values = sc.expressions
            .map((e) => ir.expressionTransformer.transform(e))
            .toList();
        cases.add(IrSwitchCase(values, transform(sc.body)));
      }
    }

    return IrSwitchStmt(subject, cases, defaultCase);
  }

  IrLabeledStmt _transformLabeled(LabeledStatement stmt) {
    return IrLabeledStmt(
      '',
      transform(stmt.body),
    );
  }

  IrYieldStmt _transformYield(YieldStatement stmt) {
    return IrYieldStmt(
      ir.expressionTransformer.transform(stmt.expression),
      isYieldStar: stmt.isYieldStar,
    );
  }

  IrFuncDecl _transformFuncDecl(FunctionDeclaration stmt) {
    final name = _cleanVarName(stmt.variable.name);
    final func = stmt.function;

    final params = <IrClosureParam>[];
    for (final p in func.positionalParameters) {
      params.add(IrClosureParam(
        _cleanVarName(p.name),
        ir.typeTransformer.transform(p.type),
      ));
    }

    final returnType = ir.typeTransformer.transform(func.returnType);

    // 保存并设置当前本地函数名（用于处理递归调用）
    final savedLocalFuncName = ir.currentLocalFunctionName;
    ir.currentLocalFunctionName = name;

    final body = func.body != null ? transform(func.body!) : const IrBlockStmt([]);

    // 恢复之前的本地函数名
    ir.currentLocalFunctionName = savedLocalFuncName;

    return IrFuncDecl(name, params, returnType, body);
  }

  /// 清洗变量名。
  String _cleanVarName(String? name) {
    if (name == null || name.isEmpty) return '_unnamed';
    var result = name;
    if (result.startsWith(':#')) result = result.substring(2);
    if (result.startsWith('#')) result = result.substring(1);
    result = result.replaceAll('#', '_').replaceAll(':', '_');
    // Prefix digit-starting names with underscore (e.g., `0_0` → `_0_0`)
    if (result.isNotEmpty && result.codeUnitAt(0) >= 0x30 && result.codeUnitAt(0) <= 0x39) {
      result = '_$result';
    }
    // Dart 关键字
    const keywords = {
      'abstract', 'as', 'assert', 'async', 'await', 'break', 'case',
      'catch', 'class', 'const', 'continue', 'covariant', 'default',
      'deferred', 'do', 'dynamic', 'else', 'enum', 'export', 'extends',
      'extension', 'external', 'factory', 'false', 'final', 'finally',
      'for', 'Function', 'get', 'hide', 'if', 'implements', 'import',
      'in', 'interface', 'is', 'late', 'library', 'mixin', 'new',
      'null', 'on', 'operator', 'part', 'required', 'rethrow', 'return',
      'set', 'show', 'static', 'super', 'switch', 'sync', 'this',
      'throw', 'true', 'try', 'typedef', 'var', 'void', 'while',
      'with', 'yield',
    };
    if (keywords.contains(result)) return '${result}_';
    return result;
  }

  /// 检查是否需要静态集合包装。
  bool _needsStaticCollectionWrap(DartType type, Expression init) {
    final category = TypeClassifier.classify(type);
    if (category != TypeCategory.collectionList &&
        category != TypeCategory.collectionMap &&
        category != TypeCategory.collectionSet) {
      return false;
    }
    // 如果初始值已经是 VariableGet，不包装
    if (init is VariableGet) return false;
    return true;
  }
}
