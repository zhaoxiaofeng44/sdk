/// IR 表达式节点层次。
///
/// 所有表达式节点承载已完成的 lowering 决策，
/// 发射器只需解释为目标语言的表达式字符串。
library ir_expressions;

import 'ir_node.dart';
import 'ir_types.dart';
import 'ir_statements.dart';

// ---------------------------------------------------------------------------
// 基类
// ---------------------------------------------------------------------------

/// 所有表达式节点的根基类。
abstract class IrExpression extends IrNode {
  const IrExpression();

  /// 表达式结果的类型（供发射器做类型相关决策，如 AnyPtr wrap）。
  IrType? get resultType => null;
}

// ---------------------------------------------------------------------------
// 字面量
// ---------------------------------------------------------------------------

/// 整数字面量。
class IrIntLiteral extends IrExpression {
  final int value;
  const IrIntLiteral(this.value);
  @override
  IrType get resultType => const IrPrimitiveType(PrimitiveKind.int_);
  @override
  R accept<R>(IrVisitor<R> visitor) => visitor.visitIntLiteral(this);
  @override
  String toString() => '$value';
}

/// 浮点字面量。
class IrDoubleLiteral extends IrExpression {
  final double value;
  const IrDoubleLiteral(this.value);
  @override
  IrType get resultType => const IrPrimitiveType(PrimitiveKind.double_);
  @override
  R accept<R>(IrVisitor<R> visitor) => visitor.visitDoubleLiteral(this);
  @override
  String toString() => '$value';
}

/// 布尔字面量。
class IrBoolLiteral extends IrExpression {
  final bool value;
  const IrBoolLiteral(this.value);
  @override
  IrType get resultType => const IrPrimitiveType(PrimitiveKind.bool_);
  @override
  R accept<R>(IrVisitor<R> visitor) => visitor.visitBoolLiteral(this);
  @override
  String toString() => '$value';
}

/// 字符串字面量。
class IrStringLiteral extends IrExpression {
  final String value;
  const IrStringLiteral(this.value);
  @override
  IrType get resultType => const IrPrimitiveType(PrimitiveKind.string_);
  @override
  R accept<R>(IrVisitor<R> visitor) => visitor.visitStringLiteral(this);
  @override
  String toString() => '"$value"';
}

/// null 字面量。
class IrNullLiteral extends IrExpression {
  const IrNullLiteral();
  @override
  R accept<R>(IrVisitor<R> visitor) => visitor.visitNullLiteral(this);
  @override
  String toString() => 'null';
}

/// Symbol 字面量 (`#name`)。
class IrSymbolLiteral extends IrExpression {
  final String name;
  const IrSymbolLiteral(this.name);
  @override
  R accept<R>(IrVisitor<R> visitor) => visitor.visitSymbolLiteral(this);
  @override
  String toString() => '#$name';
}

/// 类型字面量（如 `int`、`MyClass`，作为值使用时）。
class IrTypeLiteral extends IrExpression {
  final IrType type;
  const IrTypeLiteral(this.type);
  @override
  R accept<R>(IrVisitor<R> visitor) => visitor.visitTypeLiteral(this);
  @override
  String toString() => '$type';
}

/// 字符串拼接（插值）。
class IrStringConcat extends IrExpression {
  final List<IrExpression> parts;
  const IrStringConcat(this.parts);
  @override
  IrType get resultType => const IrPrimitiveType(PrimitiveKind.string_);
  @override
  R accept<R>(IrVisitor<R> visitor) => visitor.visitStringConcat(this);
}

// ---------------------------------------------------------------------------
// 变量读写
// ---------------------------------------------------------------------------

/// 变量读取。
class IrVariableGet extends IrExpression {
  /// 变量名（已清洗）。
  final String name;

  /// 是否需要 `.value` 后缀（Box 化变量）。
  final bool isBoxed;

  /// 闭包环境前缀（如 `env.` 或 `env->`），`null` 表示无。
  final String? envPrefix;

  final IrType? type;

  const IrVariableGet(this.name,
      {this.isBoxed = false, this.envPrefix, this.type});

  @override
  IrType? get resultType => type;
  @override
  R accept<R>(IrVisitor<R> visitor) => visitor.visitVariableGet(this);
}

/// 变量赋值。
class IrVariableSet extends IrExpression {
  final String name;
  final IrExpression value;
  final bool isBoxed;
  final String? envPrefix;
  final IrType? type;

  const IrVariableSet(this.name, this.value,
      {this.isBoxed = false, this.envPrefix, this.type});

  @override
  IrType? get resultType => type;
  @override
  R accept<R>(IrVisitor<R> visitor) => visitor.visitVariableSet(this);
}

// ---------------------------------------------------------------------------
// 虚表调度（OOP Lowering 核心）
// ---------------------------------------------------------------------------

/// 通过虚表调度实例方法/运算符。
///
/// 已完成的决策：
/// - [vptrKey]：vptr 键名（如 `speak`、`get_name`、`operatorPlus`）
/// - [signature]：函数签名（用于发射器的类型转换）
/// - [isPrivateDirectCall]：私有方法绕过 vptr，直接静态调用
class IrVptrDispatch extends IrExpression {
  /// 接收者表达式。
  final IrExpression receiver;

  /// vptr 键（如 `'speak'`、`'get_name'`、`'operatorPlus'`）。
  final String vptrKey;

  /// 参数列表。
  final List<IrExpression> args;

  /// 命名参数（如 `onSuccess: ...`、`onFailure: ...`）。
  final Map<String, IrExpression> namedArgs;

  /// 返回类型。
  final IrType returnType;

  /// 参数类型列表（用于构建函数签名）。
  final List<IrType> paramTypes;

  /// 是否为私有方法直接调用（绕过 vptr）。
  final bool isPrivateDirectCall;

  /// 私有方法直接调用时的静态函数名（如 `ClassName__privateMethod`）。
  final String? directStaticFuncName;

  /// 方法级泛型特化后缀（如 `_String`、`_int`）。
  final String? specializationSuffix;

  /// 泛型特化时的类型实参（如 `['String']`）。
  final List<String>? specializationTypeArgs;

  const IrVptrDispatch(
    this.receiver,
    this.vptrKey,
    this.args, {
    this.namedArgs = const {},
    required this.returnType,
    this.paramTypes = const [],
    this.isPrivateDirectCall = false,
    this.directStaticFuncName,
    this.specializationSuffix,
    this.specializationTypeArgs,
  });

  @override
  IrType get resultType => returnType;
  @override
  R accept<R>(IrVisitor<R> visitor) => visitor.visitVptrDispatch(this);
}

// ---------------------------------------------------------------------------
// 静态调用
// ---------------------------------------------------------------------------

/// 静态函数/顶层函数调用。
class IrStaticCall extends IrExpression {
  /// 函数名（已映射，如 `staticPrint` 替代 `print`）。
  final String funcName;

  /// 位置参数。
  final List<IrExpression> args;

  /// 命名参数（如 `seconds: 1`、`milliseconds: 10`）。
  final Map<String, IrExpression> namedArgs;

  /// 类型参数（如 `<int, String>`）。
  final List<IrType> typeArgs;

  /// 返回类型。
  final IrType? returnType;

  /// 是否为静态方法调用（true → `Cls.method<T>(args)`，
  /// false → 命名构造函数 `Cls<T>.method(args)`）。
  final bool isStaticMethod;

  const IrStaticCall(this.funcName, this.args,
      {this.namedArgs = const {},
      this.typeArgs = const [],
      this.returnType,
      this.isStaticMethod = false});

  @override
  IrType? get resultType => returnType;
  @override
  R accept<R>(IrVisitor<R> visitor) => visitor.visitStaticCall(this);
}

/// 动态调用（receiver 类型不确定时的调用）。
class IrDynamicCall extends IrExpression {
  final IrExpression receiver;
  final String methodName;
  final List<IrExpression> args;
  final IrType? returnType;

  const IrDynamicCall(this.receiver, this.methodName, this.args,
      {this.returnType});

  @override
  IrType? get resultType => returnType;
  @override
  R accept<R>(IrVisitor<R> visitor) => visitor.visitDynamicCall(this);
}

/// 函数对象调用（FunctionInvocation）。
class IrFunctionInvocation extends IrExpression {
  final IrExpression target;
  final List<IrExpression> args;
  final IrType? returnType;

  const IrFunctionInvocation(this.target, this.args, {this.returnType});

  @override
  IrType? get resultType => returnType;
  @override
  R accept<R>(IrVisitor<R> visitor) => visitor.visitFunctionInvocation(this);
}

// ---------------------------------------------------------------------------
// 构造函数调用
// ---------------------------------------------------------------------------

/// 构造函数调用（`X_new(XValue(), args)` 或 `GC::allocateLocal(new XValue())`）。
class IrConstructorCall extends IrExpression {
  /// 类名（原始名，如 `Circle`）。
  final String className;

  /// 构造后的 `_new` 函数名（如 `Circle_new`）。
  final String newFuncName;

  /// 参数。
  final List<IrExpression> args;

  /// 命名参数。
  final Map<String, IrExpression> namedArgs;

  /// 类型参数。
  final List<IrType> typeArgs;

  /// 构造函数名（非默认构造时，如 `Circle.named` → `Circle_new_named`）。
  final String? ctorName;

  /// 是否为工厂构造函数（不需要传入 this__）。
  final bool isFactory;

  const IrConstructorCall(this.className, this.newFuncName, this.args,
      {this.namedArgs = const {},
       this.typeArgs = const [],
       this.ctorName,
       this.isFactory = false});

  @override
  IrType get resultType => IrUserType(className, typeArgs);
  @override
  R accept<R>(IrVisitor<R> visitor) => visitor.visitConstructorCall(this);
}

// ---------------------------------------------------------------------------
// 字段读写
// ---------------------------------------------------------------------------

/// 实例字段读取。
class IrFieldGet extends IrExpression {
  final IrExpression receiver;
  final String fieldName;
  final IrType? type;

  /// 是否为枚举 getter（走静态函数 `EnumName_get_field(recv)`）。
  final bool isEnumGetter;

  /// 枚举 getter 时的静态函数名。
  final String? enumGetterFuncName;

  const IrFieldGet(this.receiver, this.fieldName,
      {this.type, this.isEnumGetter = false, this.enumGetterFuncName});

  @override
  IrType? get resultType => type;
  @override
  R accept<R>(IrVisitor<R> visitor) => visitor.visitFieldGet(this);
}

/// 实例字段赋值。
class IrFieldSet extends IrExpression {
  final IrExpression receiver;
  final String fieldName;
  final IrExpression value;
  final IrType? type;

  const IrFieldSet(this.receiver, this.fieldName, this.value, {this.type});

  @override
  IrType? get resultType => type;
  @override
  R accept<R>(IrVisitor<R> visitor) => visitor.visitFieldSet(this);
}

/// 静态字段赋值。
class IrStaticFieldSet extends IrExpression {
  final String className;
  final String fieldName;
  final IrExpression value;
  final IrType? type;

  const IrStaticFieldSet(this.className, this.fieldName, this.value, {this.type});

  @override
  IrType? get resultType => type;
  @override
  R accept<R>(IrVisitor<R> visitor) => visitor.visitStaticFieldSet(this);
}

// ---------------------------------------------------------------------------
// 闭包表达式
// ---------------------------------------------------------------------------

/// 闭包捕获字段信息。
class IrCapturedField {
  final String name;
  final IrType type;
  final bool isThis;
  final bool isBoxed;
  final IrBoxType? boxType;
  final String? envPrefix;

  const IrCapturedField(this.name, this.type,
      {this.isThis = false, this.isBoxed = false, this.boxType, this.envPrefix});
}

/// 闭包参数信息。
class IrClosureParam {
  final String name;
  final IrType type;
  final bool isBoxed;
  final IrBoxType? boxType;
  final IrExpression? defaultValue;

  const IrClosureParam(this.name, this.type,
      {this.isBoxed = false, this.boxType, this.defaultValue});
}

/// 闭包表达式 → ClosureEnv 类 + `_call` 静态函数。
///
/// 已完成的决策：
/// - 捕获变量列表（含 Box 装箱）
/// - `this` 捕获
/// - 泛型参数收集（Dart 需要，C++ 忽略）
/// - TypeFunctionN arity 选择
class IrClosureExpr extends IrExpression {
  /// 闭包环境类名（如 `ClosureEnv_foo_0`）。
  final String envClassName;

  /// 捕获字段。
  final List<IrCapturedField> capturedFields;

  /// 闭包参数。
  final List<IrClosureParam> params;

  /// 闭包体。
  final IrStatement body;

  /// 返回类型。
  final IrType returnType;

  /// 是否 async。
  final bool isAsync;

  /// async 时的 Promise 内部类型。
  final IrType? asyncInnerType;

  /// 泛型类型参数（Dart 闭包类需要，C++ 忽略）。
  final List<IrTypeParameterType> typeParams;

  /// TypeFunctionN 的 arity。
  final int arity;

  /// 是否有命名参数（退化为 TypeFunction）。
  final bool hasNamedParams;

  const IrClosureExpr({
    required this.envClassName,
    required this.capturedFields,
    required this.params,
    required this.body,
    required this.returnType,
    this.isAsync = false,
    this.asyncInnerType,
    this.typeParams = const [],
    this.arity = 0,
    this.hasNamedParams = false,
  });

  @override
  R accept<R>(IrVisitor<R> visitor) => visitor.visitClosureExpr(this);
}

// ---------------------------------------------------------------------------
// 集合字面量
// ---------------------------------------------------------------------------

/// 列表字面量。
class IrListLiteral extends IrExpression {
  final List<IrExpression> elements;
  final List<IrType> typeArgs;
  final bool isConst;

  const IrListLiteral(this.elements,
      {this.typeArgs = const [], this.isConst = false});

  @override
  R accept<R>(IrVisitor<R> visitor) => visitor.visitListLiteral(this);
}

/// Map 字面量。
class IrMapEntry {
  final IrExpression key;
  final IrExpression value;
  const IrMapEntry(this.key, this.value);
}

class IrMapLiteral extends IrExpression {
  final List<IrMapEntry> entries;
  final List<IrType> typeArgs;
  final bool isConst;

  const IrMapLiteral(this.entries,
      {this.typeArgs = const [], this.isConst = false});

  @override
  R accept<R>(IrVisitor<R> visitor) => visitor.visitMapLiteral(this);
}

/// Set 字面量。
class IrSetLiteral extends IrExpression {
  final List<IrExpression> elements;
  final List<IrType> typeArgs;
  final bool isConst;

  const IrSetLiteral(this.elements,
      {this.typeArgs = const [], this.isConst = false});

  @override
  R accept<R>(IrVisitor<R> visitor) => visitor.visitSetLiteral(this);
}

// ---------------------------------------------------------------------------
// 控制表达式
// ---------------------------------------------------------------------------

/// 三元条件表达式。
class IrConditional extends IrExpression {
  final IrExpression condition;
  final IrExpression thenExpr;
  final IrExpression elseExpr;
  final IrType? type;

  const IrConditional(this.condition, this.thenExpr, this.elseExpr,
      {this.type});

  @override
  IrType? get resultType => type;
  @override
  R accept<R>(IrVisitor<R> visitor) => visitor.visitConditional(this);
}

/// 逻辑运算符（`&&` / `||`）。
enum LogicalOp { and, or }

class IrLogicalExpr extends IrExpression {
  final IrExpression left;
  final LogicalOp op;
  final IrExpression right;

  const IrLogicalExpr(this.left, this.op, this.right);

  @override
  IrType get resultType => const IrPrimitiveType(PrimitiveKind.bool_);
  @override
  R accept<R>(IrVisitor<R> visitor) => visitor.visitLogicalExpr(this);
}

/// 逻辑非 (`!`)。
class IrNotExpr extends IrExpression {
  final IrExpression operand;
  const IrNotExpr(this.operand);

  @override
  IrType get resultType => const IrPrimitiveType(PrimitiveKind.bool_);
  @override
  R accept<R>(IrVisitor<R> visitor) => visitor.visitNotExpr(this);
}

/// `throw` 表达式。
class IrThrowExpr extends IrExpression {
  final IrExpression exception;
  const IrThrowExpr(this.exception);
  @override
  R accept<R>(IrVisitor<R> visitor) => visitor.visitThrowExpr(this);
}

/// `rethrow` 表达式。
class IrRethrowExpr extends IrExpression {
  const IrRethrowExpr();
  @override
  R accept<R>(IrVisitor<R> visitor) => visitor.visitRethrowExpr(this);
}

/// `await` 表达式。
class IrAwaitExpr extends IrExpression {
  final IrExpression operand;
  final IrType innerType;

  const IrAwaitExpr(this.operand, this.innerType);

  @override
  IrType get resultType => innerType;
  @override
  R accept<R>(IrVisitor<R> visitor) => visitor.visitAwaitExpr(this);
}

// ---------------------------------------------------------------------------
// 类型操作
// ---------------------------------------------------------------------------

/// `is` 类型检查。
class IrIsCheck extends IrExpression {
  final IrExpression operand;
  final IrType checkType;

  const IrIsCheck(this.operand, this.checkType);

  @override
  IrType get resultType => const IrPrimitiveType(PrimitiveKind.bool_);
  @override
  R accept<R>(IrVisitor<R> visitor) => visitor.visitIsCheck(this);
}

/// `as` 类型转换。
class IrCastExpr extends IrExpression {
  final IrExpression operand;
  final IrType castType;

  const IrCastExpr(this.operand, this.castType);

  @override
  IrType get resultType => castType;
  @override
  R accept<R>(IrVisitor<R> visitor) => visitor.visitCastExpr(this);
}

/// `!` null 断言。
class IrNullCheck extends IrExpression {
  final IrExpression operand;
  final IrType? type;

  const IrNullCheck(this.operand, {this.type});

  @override
  IrType? get resultType => type;
  @override
  R accept<R>(IrVisitor<R> visitor) => visitor.visitNullCheck(this);
}

/// Let 表达式（临时变量绑定）。
///
/// 用于表示 `??`（null 合并）、`?.`（null 安全访问）、`..`（级联）等
/// 模式，以及通用临时变量绑定。
class IrLetExpr extends IrExpression {
  final String varName;
  final IrExpression init;
  final IrExpression body;
  final IrType? type;

  const IrLetExpr(this.varName, this.init, this.body, {this.type});

  @override
  IrType? get resultType => type;
  @override
  R accept<R>(IrVisitor<R> visitor) => visitor.visitLetExpr(this);
}

// ---------------------------------------------------------------------------
// this / super
// ---------------------------------------------------------------------------

/// `this` 表达式（可能已被改写为 `this_` / `env.this_`）。
class IrThisExpr extends IrExpression {
  /// 替换名（`this_` 或 `obj`）。
  final String replacementName;

  /// 是否在闭包环境中（需要加 `env.` 前缀）。
  final bool inClosureEnv;

  /// 类名（用于类型推断）。
  final String? className;

  final IrType? type;

  const IrThisExpr({
    this.replacementName = 'this_',
    this.inClosureEnv = false,
    this.className,
    this.type,
  });

  @override
  IrType? get resultType => type;
  @override
  R accept<R>(IrVisitor<R> visitor) => visitor.visitThisExpr(this);
}

/// super 方法调用。
class IrSuperCall extends IrExpression {
  final String staticFuncName;
  final List<IrExpression> args;
  final IrType? returnType;

  const IrSuperCall(this.staticFuncName, this.args, {this.returnType});

  @override
  IrType? get resultType => returnType;
  @override
  R accept<R>(IrVisitor<R> visitor) => visitor.visitSuperCall(this);
}

/// super 字段读取。
class IrSuperFieldGet extends IrExpression {
  final String fieldName;
  final IrType? type;

  /// 是否走 vptr getter（`true`）还是直接字段访问（`false`）。
  final bool isVptrGetter;

  /// vptr getter 时的签名。
  final IrFunctionType? getterSignature;

  const IrSuperFieldGet(this.fieldName,
      {this.type, this.isVptrGetter = false, this.getterSignature});

  @override
  IrType? get resultType => type;
  @override
  R accept<R>(IrVisitor<R> visitor) => visitor.visitSuperFieldGet(this);
}

/// super 字段赋值。
class IrSuperFieldSet extends IrExpression {
  final String fieldName;
  final IrExpression value;

  const IrSuperFieldSet(this.fieldName, this.value);

  @override
  R accept<R>(IrVisitor<R> visitor) => visitor.visitSuperFieldSet(this);
}

// ---------------------------------------------------------------------------
// Record
// ---------------------------------------------------------------------------

/// Record 字面量。
class IrRecordLiteral extends IrExpression {
  final List<IrExpression> positional;
  final Map<String, IrExpression> named;

  const IrRecordLiteral(this.positional, [this.named = const {}]);

  @override
  R accept<R>(IrVisitor<R> visitor) => visitor.visitRecordLiteral(this);
}

/// Record 字段访问（索引或命名）。
class IrRecordGet extends IrExpression {
  final IrExpression receiver;
  final int? index;
  final String? name;
  final IrType? type;

  const IrRecordGet(this.receiver, {this.index, this.name, this.type});

  @override
  IrType? get resultType => type;
  @override
  R accept<R>(IrVisitor<R> visitor) => visitor.visitRecordGet(this);
}

// ---------------------------------------------------------------------------
// Tear-off
// ---------------------------------------------------------------------------

/// 方法 tear-off（`obj.method` 不跟 `()`）。
class IrTearOff extends IrExpression {
  final IrExpression receiver;
  final String methodName;
  final String staticFuncName;
  final IrFunctionType funcType;

  const IrTearOff(this.receiver, this.methodName, this.staticFuncName,
      this.funcType);

  @override
  IrType get resultType => funcType;
  @override
  R accept<R>(IrVisitor<R> visitor) => visitor.visitTearOff(this);
}

// ---------------------------------------------------------------------------
// 块表达式
// ---------------------------------------------------------------------------

/// 块表达式（多条语句 + 最后一个表达式作为值）。
class IrBlockExpr extends IrExpression {
  final List<IrStatement> statements;
  final IrExpression? result;

  const IrBlockExpr(this.statements, [this.result]);

  @override
  R accept<R>(IrVisitor<R> visitor) => visitor.visitBlockExpr(this);
}

// ---------------------------------------------------------------------------
// 相等检查
// ---------------------------------------------------------------------------

/// `== null` 检查。
class IrEqualsNull extends IrExpression {
  final IrExpression operand;
  const IrEqualsNull(this.operand);

  @override
  IrType get resultType => const IrPrimitiveType(PrimitiveKind.bool_);
  @override
  R accept<R>(IrVisitor<R> visitor) => visitor.visitEqualsNull(this);
}

/// `==` 调用（EqualsCall）。
class IrEqualsCall extends IrExpression {
  final IrExpression left;
  final IrExpression right;

  /// 是否走 vptr `operator==` 调度。
  final bool isVptrDispatch;

  const IrEqualsCall(this.left, this.right, {this.isVptrDispatch = false});

  @override
  IrType get resultType => const IrPrimitiveType(PrimitiveKind.bool_);
  @override
  R accept<R>(IrVisitor<R> visitor) => visitor.visitEqualsCall(this);
}

// ---------------------------------------------------------------------------
// 原生运算符（内置类型直接输出运算符语法）
// ---------------------------------------------------------------------------

/// 原生运算符表达式（如 `a + b`、`-a`、`a[b]`）。
///
/// 用于内置类型（int, double, String 等）的运算符，
/// 直接输出原生运算符语法而非 vptr 调度。
class IrNativeOpExpr extends IrExpression {
  /// 运算符名称（如 `+`, `-`, `<`, `[]`, `[]=`, `unary-`, `~`）
  final String op;

  /// 左操作数（对于一元运算符就是唯一的操作数）
  final IrExpression left;

  /// 右操作数（对于一元运算符为 null）
  final IrExpression? right;

  /// 对于 `[]=`，还有值操作数
  final IrExpression? indexSetValue;

  final IrType? type;

  const IrNativeOpExpr(this.op, this.left, {this.right, this.indexSetValue, this.type});

  @override
  IrType? get resultType => type;
  @override
  R accept<R>(IrVisitor<R> visitor) => visitor.visitNativeOp(this);
}

// ---------------------------------------------------------------------------
// 原始代码（用于无法建模的特殊情况）
// ---------------------------------------------------------------------------

/// 原始代码片段（直接嵌入目标语言字符串）。
/// 仅用于极少数无法用 IR 节点表达的情况。
class IrRawCode extends IrExpression {
  final String dartCode;
  final String cppCode;
  final IrType? type;

  const IrRawCode({required this.dartCode, required this.cppCode, this.type});

  @override
  IrType? get resultType => type;
  @override
  R accept<R>(IrVisitor<R> visitor) => visitor.visitRawCode(this);
}
