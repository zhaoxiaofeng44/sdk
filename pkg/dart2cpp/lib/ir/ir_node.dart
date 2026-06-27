/// IR 节点基类与 Visitor 模式定义。
///
/// 所有 IR 节点都是不可变数据载体（`final` 字段），
/// 承载 lowering 决策结果，供 Dart/C++ 发射器解释输出。
library ir_node;

import 'ir_types.dart';
import 'ir_expressions.dart';
import 'ir_statements.dart';
import 'ir_declarations.dart';

// ---------------------------------------------------------------------------
// 基类
// ---------------------------------------------------------------------------

/// 所有 IR 节点的根基类。
abstract class IrNode {
  const IrNode();

  /// 双重分派 — 子类调用 `visitor.visitXxx(this)`。
  R accept<R>(IrVisitor<R> visitor);
}

// ---------------------------------------------------------------------------
// Visitor
// ---------------------------------------------------------------------------

/// 泛型 Visitor 基类，所有 `visitXxx` 提供默认实现（返回 [defaultValue]）。
/// 子类只需 override 关心的节点。
abstract class IrVisitor<R> {
  R get defaultValue;

  // -- Types --
  R visitVoidType(IrVoidType node) => defaultValue;
  R visitPrimitiveType(IrPrimitiveType node) => defaultValue;
  R visitDynamicType(IrDynamicType node) => defaultValue;
  R visitUserType(IrUserType node) => defaultValue;
  R visitCollectionType(IrCollectionType node) => defaultValue;
  R visitPromiseType(IrPromiseType node) => defaultValue;
  R visitFunctionType(IrFunctionType node) => defaultValue;
  R visitBoxType(IrBoxType node) => defaultValue;
  R visitTypeParameterType(IrTypeParameterType node) => defaultValue;
  R visitNullableType(IrNullableType node) => defaultValue;
  R visitAnyPtrType(IrAnyPtrType node) => defaultValue;
  R visitRecordType(IrRecordType node) => defaultValue;

  // -- Expressions --
  R visitIntLiteral(IrIntLiteral node) => defaultValue;
  R visitDoubleLiteral(IrDoubleLiteral node) => defaultValue;
  R visitBoolLiteral(IrBoolLiteral node) => defaultValue;
  R visitStringLiteral(IrStringLiteral node) => defaultValue;
  R visitNullLiteral(IrNullLiteral node) => defaultValue;
  R visitStringConcat(IrStringConcat node) => defaultValue;
  R visitVariableGet(IrVariableGet node) => defaultValue;
  R visitVariableSet(IrVariableSet node) => defaultValue;
  R visitVptrDispatch(IrVptrDispatch node) => defaultValue;
  R visitStaticCall(IrStaticCall node) => defaultValue;
  R visitDynamicCall(IrDynamicCall node) => defaultValue;
  R visitConstructorCall(IrConstructorCall node) => defaultValue;
  R visitFieldGet(IrFieldGet node) => defaultValue;
  R visitFieldSet(IrFieldSet node) => defaultValue;
  R visitStaticFieldSet(IrStaticFieldSet node) => defaultValue;
  R visitClosureExpr(IrClosureExpr node) => defaultValue;
  R visitListLiteral(IrListLiteral node) => defaultValue;
  R visitMapLiteral(IrMapLiteral node) => defaultValue;
  R visitSetLiteral(IrSetLiteral node) => defaultValue;
  R visitConditional(IrConditional node) => defaultValue;
  R visitLogicalExpr(IrLogicalExpr node) => defaultValue;
  R visitNotExpr(IrNotExpr node) => defaultValue;
  R visitThrowExpr(IrThrowExpr node) => defaultValue;
  R visitAwaitExpr(IrAwaitExpr node) => defaultValue;
  R visitIsCheck(IrIsCheck node) => defaultValue;
  R visitCastExpr(IrCastExpr node) => defaultValue;
  R visitLetExpr(IrLetExpr node) => defaultValue;
  R visitSuperCall(IrSuperCall node) => defaultValue;
  R visitThisExpr(IrThisExpr node) => defaultValue;
  R visitRecordLiteral(IrRecordLiteral node) => defaultValue;
  R visitRecordGet(IrRecordGet node) => defaultValue;
  R visitTearOff(IrTearOff node) => defaultValue;
  R visitBlockExpr(IrBlockExpr node) => defaultValue;
  R visitSuperFieldGet(IrSuperFieldGet node) => defaultValue;
  R visitSuperFieldSet(IrSuperFieldSet node) => defaultValue;
  R visitNullCheck(IrNullCheck node) => defaultValue;
  R visitFunctionInvocation(IrFunctionInvocation node) => defaultValue;
  R visitTypeLiteral(IrTypeLiteral node) => defaultValue;
  R visitRethrowExpr(IrRethrowExpr node) => defaultValue;
  R visitSymbolLiteral(IrSymbolLiteral node) => defaultValue;
  R visitEqualsNull(IrEqualsNull node) => defaultValue;
  R visitEqualsCall(IrEqualsCall node) => defaultValue;
  R visitRawCode(IrRawCode node) => defaultValue;
  R visitNativeOp(IrNativeOpExpr node) => defaultValue;

  // -- Statements --
  R visitBlockStmt(IrBlockStmt node) => defaultValue;
  R visitVarDecl(IrVarDecl node) => defaultValue;
  R visitReturnStmt(IrReturnStmt node) => defaultValue;
  R visitIfStmt(IrIfStmt node) => defaultValue;
  R visitForStmt(IrForStmt node) => defaultValue;
  R visitForInStmt(IrForInStmt node) => defaultValue;
  R visitWhileStmt(IrWhileStmt node) => defaultValue;
  R visitDoWhileStmt(IrDoWhileStmt node) => defaultValue;
  R visitTryCatch(IrTryCatch node) => defaultValue;
  R visitSwitchStmt(IrSwitchStmt node) => defaultValue;
  R visitBreakStmt(IrBreakStmt node) => defaultValue;
  R visitLabeledStmt(IrLabeledStmt node) => defaultValue;
  R visitYieldStmt(IrYieldStmt node) => defaultValue;
  R visitExprStmt(IrExprStmt node) => defaultValue;
  R visitFuncDecl(IrFuncDecl node) => defaultValue;
  R visitContinueStmt(IrContinueStmt node) => defaultValue;
  R visitAssertStmt(IrAssertStmt node) => defaultValue;

  // -- Declarations --
  R visitProgram(IrProgram node) => defaultValue;
  R visitLibrary(IrLibrary node) => defaultValue;
  R visitValueClass(IrValueClass node) => defaultValue;
  R visitStaticFunc(IrStaticFunc node) => defaultValue;
  R visitConstructorFunc(IrConstructorFunc node) => defaultValue;
  R visitDelegateFunc(IrDelegateFunc node) => defaultValue;
  R visitClosureClass(IrClosureClass node) => defaultValue;
  R visitTypedef(IrTypedef node) => defaultValue;
  R visitEnumDecl(IrEnumDecl node) => defaultValue;
  R visitTopLevelField(IrTopLevelField node) => defaultValue;
  R visitMixinFuncs(IrMixinFuncs node) => defaultValue;
  R visitVptrRegistration(IrVptrRegistration node) => defaultValue;
}
