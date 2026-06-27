/// IR 语句节点层次。
library ir_statements;

import 'ir_node.dart';
import 'ir_types.dart';
import 'ir_expressions.dart';

// ---------------------------------------------------------------------------
// 基类
// ---------------------------------------------------------------------------

/// 所有语句节点的根基类。
abstract class IrStatement extends IrNode {
  const IrStatement();
}

// ---------------------------------------------------------------------------
// 块
// ---------------------------------------------------------------------------

/// 代码块。
class IrBlockStmt extends IrStatement {
  final List<IrStatement> statements;
  const IrBlockStmt(this.statements);
  @override
  R accept<R>(IrVisitor<R> visitor) => visitor.visitBlockStmt(this);
}

// ---------------------------------------------------------------------------
// 变量声明
// ---------------------------------------------------------------------------

/// 变量声明。
///
/// 已完成的决策：
/// - [isBoxed]：是否装箱
/// - [boxType]：装箱时的 Box 类型
/// - [isLate]：是否需要 `late` 修饰（Dart）
class IrVarDecl extends IrStatement {
  final String name;
  final IrType type;
  final IrExpression? init;
  final bool isLate;
  final bool isBoxed;
  final IrBoxType? boxType;

  /// 是否为 `final`。
  final bool isFinal;

  /// 静态集合包装（如 `StaticList.of(list)`）。
  final bool needsStaticWrap;

  /// 静态集合包装的目标类名（如 `StaticList`、`StaticMap`）。
  final String? staticWrapClass;

  const IrVarDecl(this.name, this.type,
      {this.init,
      this.isLate = false,
      this.isBoxed = false,
      this.boxType,
      this.isFinal = false,
      this.needsStaticWrap = false,
      this.staticWrapClass});

  @override
  R accept<R>(IrVisitor<R> visitor) => visitor.visitVarDecl(this);
}

// ---------------------------------------------------------------------------
// return
// ---------------------------------------------------------------------------

/// return 语句。
///
/// [isAsync] 标记 async 函数体，发射器将 `return v` 改写为
/// `env._promise.complete(v); return;` (Dart) 或
/// `env->_promise->complete(...); return;` (C++)。
class IrReturnStmt extends IrStatement {
  final IrExpression? value;
  final bool isAsync;
  final IrType? asyncInnerType;
  /// 函数的返回类型（用于类型转换）
  final IrType? returnType;

  const IrReturnStmt({this.value, this.isAsync = false, this.asyncInnerType, this.returnType});

  @override
  R accept<R>(IrVisitor<R> visitor) => visitor.visitReturnStmt(this);
}

// ---------------------------------------------------------------------------
// 控制流
// ---------------------------------------------------------------------------

/// if-else。
class IrIfStmt extends IrStatement {
  final IrExpression condition;
  final IrStatement thenBranch;
  final IrStatement? elseBranch;

  const IrIfStmt(this.condition, this.thenBranch, [this.elseBranch]);

  @override
  R accept<R>(IrVisitor<R> visitor) => visitor.visitIfStmt(this);
}

/// for 循环。
class IrForStmt extends IrStatement {
  /// 初始化（变量声明或表达式）。
  final IrStatement? init;

  /// 条件。
  final IrExpression? condition;

  /// 更新（多个表达式）。
  final List<IrExpression> updaters;

  final IrStatement body;

  /// 循环变量是否被闭包捕获需要装箱。
  final bool boxedLoopVar;

  const IrForStmt(this.body,
      {this.init,
      this.condition,
      this.updaters = const [],
      this.boxedLoopVar = false});

  @override
  R accept<R>(IrVisitor<R> visitor) => visitor.visitForStmt(this);
}

/// for-in 循环。
class IrForInStmt extends IrStatement {
  final String varName;
  final IrType varType;
  final IrExpression iterable;
  final IrStatement body;
  final bool isBoxed;

  const IrForInStmt(this.varName, this.varType, this.iterable, this.body,
      {this.isBoxed = false});

  @override
  R accept<R>(IrVisitor<R> visitor) => visitor.visitForInStmt(this);
}

/// while 循环。
class IrWhileStmt extends IrStatement {
  final IrExpression condition;
  final IrStatement body;

  const IrWhileStmt(this.condition, this.body);

  @override
  R accept<R>(IrVisitor<R> visitor) => visitor.visitWhileStmt(this);
}

/// do-while 循环。
class IrDoWhileStmt extends IrStatement {
  final IrStatement body;
  final IrExpression condition;

  const IrDoWhileStmt(this.body, this.condition);

  @override
  R accept<R>(IrVisitor<R> visitor) => visitor.visitDoWhileStmt(this);
}

/// switch 语句。
class IrSwitchCase {
  final List<IrExpression> values;
  final IrStatement body;
  const IrSwitchCase(this.values, this.body);
}

class IrSwitchStmt extends IrStatement {
  final IrExpression subject;
  final List<IrSwitchCase> cases;
  final IrStatement? defaultCase;

  const IrSwitchStmt(this.subject, this.cases, [this.defaultCase]);

  @override
  R accept<R>(IrVisitor<R> visitor) => visitor.visitSwitchStmt(this);
}

/// break 语句。
class IrBreakStmt extends IrStatement {
  final String? target;
  const IrBreakStmt([this.target]);
  @override
  R accept<R>(IrVisitor<R> visitor) => visitor.visitBreakStmt(this);
}

/// continue 语句。
class IrContinueStmt extends IrStatement {
  final String? target;
  const IrContinueStmt([this.target]);
  @override
  R accept<R>(IrVisitor<R> visitor) => visitor.visitContinueStmt(this);
}

/// 标签语句。
class IrLabeledStmt extends IrStatement {
  final String label;
  final IrStatement body;

  const IrLabeledStmt(this.label, this.body);

  @override
  R accept<R>(IrVisitor<R> visitor) => visitor.visitLabeledStmt(this);
}

/// yield 语句（sync*/async* 生成器）。
class IrYieldStmt extends IrStatement {
  final IrExpression value;
  final bool isYieldStar;

  const IrYieldStmt(this.value, {this.isYieldStar = false});

  @override
  R accept<R>(IrVisitor<R> visitor) => visitor.visitYieldStmt(this);
}

// ---------------------------------------------------------------------------
// try-catch-finally
// ---------------------------------------------------------------------------

/// catch 子句。
class IrCatchClause {
  /// 异常类型（`null` 表示 catch-all）。
  final IrType? exceptionType;

  /// 异常变量名。
  final String? exceptionVar;

  /// 堆栈跟踪变量名。
  final String? stackTraceVar;

  final IrStatement body;

  const IrCatchClause(this.body,
      {this.exceptionType, this.exceptionVar, this.stackTraceVar});
}

/// try-catch-finally。
class IrTryCatch extends IrStatement {
  final IrStatement tryBody;
  final List<IrCatchClause> catches;
  final IrStatement? finallyBody;

  const IrTryCatch(this.tryBody,
      {this.catches = const [], this.finallyBody});

  @override
  R accept<R>(IrVisitor<R> visitor) => visitor.visitTryCatch(this);
}

// ---------------------------------------------------------------------------
// 表达式语句
// ---------------------------------------------------------------------------

/// 表达式语句。
class IrExprStmt extends IrStatement {
  final IrExpression expression;
  const IrExprStmt(this.expression);
  @override
  R accept<R>(IrVisitor<R> visitor) => visitor.visitExprStmt(this);
}

// ---------------------------------------------------------------------------
// 局部函数声明
// ---------------------------------------------------------------------------

/// 局部函数声明。
class IrFuncDecl extends IrStatement {
  final String name;
  final List<IrClosureParam> params;
  final IrType returnType;
  final IrStatement body;

  /// 是否为 async。
  final bool isAsync;

  const IrFuncDecl(this.name, this.params, this.returnType, this.body,
      {this.isAsync = false});

  @override
  R accept<R>(IrVisitor<R> visitor) => visitor.visitFuncDecl(this);
}

// ---------------------------------------------------------------------------
// assert
// ---------------------------------------------------------------------------

/// assert 语句。
class IrAssertStmt extends IrStatement {
  final IrExpression condition;
  final IrExpression? message;

  const IrAssertStmt(this.condition, [this.message]);

  @override
  R accept<R>(IrVisitor<R> visitor) => visitor.visitAssertStmt(this);
}
