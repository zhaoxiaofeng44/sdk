/// IR 声明节点层次（类、函数、字段、枚举等）。
library ir_declarations;

import 'ir_node.dart';
import 'ir_types.dart';
import 'ir_expressions.dart';
import 'ir_statements.dart';

// ---------------------------------------------------------------------------
// 程序与库
// ---------------------------------------------------------------------------

/// 完整程序（多个库）。
class IrProgram extends IrNode {
  final List<IrLibrary> libraries;
  const IrProgram(this.libraries);
  @override
  R accept<R>(IrVisitor<R> visitor) => visitor.visitProgram(this);
}

/// 单个库。
class IrLibrary extends IrNode {
  final String name;
  final List<IrTypedef> typedefs;
  final List<IrMixinFuncs> mixins;
  final List<IrNode> declarations; // IrValueClass / IrStaticFunc / etc.
  final List<IrTopLevelField> fields;

  /// 延迟输出的闭包类 + 函数。
  final List<IrClosureClass> pendingClosures;

  /// 延迟输出的顶层声明（共享 vtable 常量等）。
  final List<IrNode> pendingTopLevel;

  /// main 函数（如果有）。
  final IrStaticFunc? mainFunc;

  const IrLibrary({
    required this.name,
    this.typedefs = const [],
    this.mixins = const [],
    this.declarations = const [],
    this.fields = const [],
    this.pendingClosures = const [],
    this.pendingTopLevel = const [],
    this.mainFunc,
  });

  @override
  R accept<R>(IrVisitor<R> visitor) => visitor.visitLibrary(this);
}

// ---------------------------------------------------------------------------
// 虚表注册条目
// ---------------------------------------------------------------------------

/// 虚表注册条目（在 Value 类构造函数中执行）。
class IrVptrRegistration extends IrNode {
  /// vptr key（如 `speak`、`get_name`、`operatorPlus`）。
  final String key;

  /// 注册值 — 通常是函数 tear-off。
  final IrExpression value;

  const IrVptrRegistration(this.key, this.value);

  @override
  R accept<R>(IrVisitor<R> visitor) => visitor.visitVptrRegistration(this);
}

// ---------------------------------------------------------------------------
// Value 类（OOP Lowering 核心产物）
// ---------------------------------------------------------------------------

/// 实例字段定义。
class IrFieldDef {
  final String name;
  final IrType type;
  final IrExpression? defaultValue;
  final bool isLate;

  const IrFieldDef(this.name, this.type,
      {this.defaultValue, this.isLate = true});
}

/// Value 类（`class XValue extends ParentValue { fields; vptr; gcMark; }`）。
class IrValueClass extends IrNode {
  final String className;
  final String? parentClassName;
  final List<IrType> parentTypeArgs;
  final List<String> implementsNames;
  final List<IrTypeParameterType> typeParams;
  final List<IrFieldDef> fields;

  /// 构造函数体中注册的 vptr 条目。
  final List<IrVptrRegistration> vptrEntries;

  /// 方法级泛型特化的 vptr 条目（在 `_new` 中注册）。
  final List<IrVptrRegistration> specializedVptrEntries;

  /// 是否为合成 mixin 中间类（如 `Dog_Animal_Printable`）。
  final bool isSyntheticMixin;

  /// 是否继承自非用户类基类（如 `AsyncStateMachine`）。
  final bool hasRuntimeBridgeParent;

  const IrValueClass({
    required this.className,
    this.parentClassName,
    this.parentTypeArgs = const [],
    this.implementsNames = const [],
    this.typeParams = const [],
    this.fields = const [],
    this.vptrEntries = const [],
    this.specializedVptrEntries = const [],
    this.isSyntheticMixin = false,
    this.hasRuntimeBridgeParent = false,
  });

  @override
  R accept<R>(IrVisitor<R> visitor) => visitor.visitValueClass(this);
}

// ---------------------------------------------------------------------------
// 静态函数（实例方法 / 顶层函数 / mixin 方法的统一形式）
// ---------------------------------------------------------------------------

/// 静态函数参数。
class IrFuncParam {
  final String name;
  final IrType type;
  final bool isOptional;
  final bool isNamed;
  final bool isRequired;
  final IrExpression? defaultValue;

  const IrFuncParam(this.name, this.type,
      {this.isOptional = false,
      this.isNamed = false,
      this.isRequired = false,
      this.defaultValue});
}

/// 静态函数（`ReturnType ClassName_method(dynamic this__, params) { body }`）。
class IrStaticFunc extends IrNode {
  final String name;
  final List<IrFuncParam> params;
  final IrType returnType;
  final IrStatement body;
  final List<IrTypeParameterType> typeParams;

  /// 是否为 getter（无参数，直接返回字段值）。
  final bool isGetter;

  /// 是否为 setter（一个参数，赋值字段）。
  final bool isSetter;

  /// 是否为 async（需要 ClosureEnv 包装）。
  final bool isAsync;

  /// async 时的 Promise 内部返回类型。
  final IrType? asyncInnerType;

  /// 是否为抽象方法（生成占位符）。
  final bool isAbstract;

  /// 是否为 sync* 生成器函数。
  final bool isSyncStar;

  /// 函数来源的类名（用于注释/调试）。
  final String? sourceClassName;

  const IrStaticFunc({
    required this.name,
    required this.params,
    required this.returnType,
    required this.body,
    this.typeParams = const [],
    this.isGetter = false,
    this.isSetter = false,
    this.isAsync = false,
    this.asyncInnerType,
    this.isAbstract = false,
    this.isSyncStar = false,
    this.sourceClassName,
  });

  @override
  R accept<R>(IrVisitor<R> visitor) => visitor.visitStaticFunc(this);
}

// ---------------------------------------------------------------------------
// 构造函数（`XValue X_new(dynamic this__, params) { ... }`）
// ---------------------------------------------------------------------------

/// 构造函数。
class IrConstructorFunc extends IrNode {
  /// 函数名（如 `Circle_new`、`Circle_new_named`）。
  final String name;

  /// 所属类。
  final String className;

  /// 父类名（用于调用 `ParentClass_new(this_, ...)`）。
  final String? parentClassName;

  /// 父类构造后的 `_new` 函数名。
  final String? parentNewFuncName;

  /// 是否为合成 mixin 中间类（跳过 super-init）。
  final bool isSyntheticMixin;

  final List<IrFuncParam> params;
  final List<IrTypeParameterType> typeParams;

  /// 构造函数体中的语句。
  final List<IrStatement> bodyStatements;

  /// 字段初始化（`this.field = init`）。
  final Map<String, IrExpression> fieldInitializers;

  /// 方法级泛型特化的 vptr 条目。
  final List<IrVptrRegistration> specializedVptrEntries;

  /// 父类构造调用参数（如果不同于默认）。
  final List<IrExpression>? superArgs;

  /// 父类构造调用的命名参数。
  final Map<String, IrExpression>? superNamedArgs;

  /// 重定向构造函数的目标构造函数名（如 `Shape_new`）。
  final String? redirectTargetName;

  /// 重定向构造函数的位置参数。
  final List<IrExpression>? redirectArgs;

  /// 重定向构造函数的命名参数。
  final Map<String, IrExpression>? redirectNamedArgs;

  const IrConstructorFunc({
    required this.name,
    required this.className,
    this.parentClassName,
    this.parentNewFuncName,
    this.isSyntheticMixin = false,
    this.params = const [],
    this.typeParams = const [],
    this.bodyStatements = const [],
    this.fieldInitializers = const {},
    this.specializedVptrEntries = const [],
    this.superArgs,
    this.superNamedArgs,
    this.redirectTargetName,
    this.redirectArgs,
    this.redirectNamedArgs,
  });

  @override
  R accept<R>(IrVisitor<R> visitor) => visitor.visitConstructorFunc(this);
}

// ---------------------------------------------------------------------------
// 委托函数（继承但未覆盖的方法）
// ---------------------------------------------------------------------------

/// 委托函数 — 调用父类/其他类的静态函数。
class IrDelegateFunc extends IrNode {
  /// 委托函数名（如 `Cat_speak`）。
  final String name;

  /// 目标静态函数名（如 `Animal_speak`）。
  final String targetFuncName;

  /// 传递给目标函数的类型参数（如 `['A', 'C']` for `DataTransformer_transform<A, C>`）。
  final List<String> targetTypeArgs;

  final List<IrFuncParam> params;
  final IrType returnType;
  final List<IrTypeParameterType> typeParams;

  /// 是否为 getter/setter。
  final bool isGetter;
  final bool isSetter;

  const IrDelegateFunc({
    required this.name,
    required this.targetFuncName,
    required this.params,
    required this.returnType,
    this.typeParams = const [],
    this.targetTypeArgs = const [],
    this.isGetter = false,
    this.isSetter = false,
  });

  @override
  R accept<R>(IrVisitor<R> visitor) => visitor.visitDelegateFunc(this);
}

// ---------------------------------------------------------------------------
// 闭包类（ClosureEnv + _call 函数）
// ---------------------------------------------------------------------------

/// 闭包类（`class ClosureEnv_xxx { ... }` + `void ClosureEnv_xxx_call(...)`）。
class IrClosureClass extends IrNode {
  /// 类名。
  final String envClassName;

  /// 捕获字段。
  final List<IrCapturedField> capturedFields;

  /// 闭包参数。
  final List<IrClosureParam> params;

  /// `_call` 函数体。
  final IrStatement callBody;

  /// 返回类型。
  final IrType returnType;

  /// 是否 async。
  final bool isAsync;

  /// async 时的 Promise 内部类型。
  final IrType? asyncInnerType;

  /// 泛型类型参数（Dart 需要）。
  final List<IrTypeParameterType> typeParams;

  /// TypeFunctionN 的 arity。
  final int arity;

  /// 是否有命名参数。
  final bool hasNamedParams;

  const IrClosureClass({
    required this.envClassName,
    required this.capturedFields,
    required this.params,
    required this.callBody,
    required this.returnType,
    this.isAsync = false,
    this.asyncInnerType,
    this.typeParams = const [],
    this.arity = 0,
    this.hasNamedParams = false,
  });

  @override
  R accept<R>(IrVisitor<R> visitor) => visitor.visitClosureClass(this);
}

// ---------------------------------------------------------------------------
// typedef
// ---------------------------------------------------------------------------

/// typedef 声明。
class IrTypedef extends IrNode {
  final String name;
  final IrType type;
  final List<IrTypeParameterType> typeParams;

  const IrTypedef(this.name, this.type, {this.typeParams = const []});

  @override
  R accept<R>(IrVisitor<R> visitor) => visitor.visitTypedef(this);
}

// ---------------------------------------------------------------------------
// 枚举
// ---------------------------------------------------------------------------

/// 枚举值定义。
class IrEnumValue {
  final String name;
  final List<IrExpression> args;

  const IrEnumValue(this.name, [this.args = const []]);
}

/// 枚举字段定义（用户自定义的实例字段）。
class IrEnumFieldDef {
  final String name;
  final IrType type;
  final IrExpression? defaultValue;

  const IrEnumFieldDef(this.name, this.type, {this.defaultValue});
}

/// 枚举声明。
class IrEnumDecl extends IrNode {
  final String name;
  final List<IrTypeParameterType> typeParams;
  final List<IrEnumValue> values;
  final List<IrEnumFieldDef> userFields;
  final List<IrStaticFunc> methods;
  final List<String> userParamNames;

  const IrEnumDecl({
    required this.name,
    this.typeParams = const [],
    this.values = const [],
    this.userFields = const [],
    this.methods = const [],
    this.userParamNames = const [],
  });

  @override
  R accept<R>(IrVisitor<R> visitor) => visitor.visitEnumDecl(this);
}

// ---------------------------------------------------------------------------
// 顶层字段
// ---------------------------------------------------------------------------

/// 顶层字段声明。
class IrTopLevelField extends IrNode {
  final String name;
  final IrType type;
  final IrExpression? init;

  /// 是否为 `final`。
  final bool isFinal;

  /// 是否为静态字段（类级别）。
  final bool isStatic;

  /// 所属类名（静态字段时）。
  final String? className;

  const IrTopLevelField(this.name, this.type,
      {this.init,
      this.isFinal = false,
      this.isStatic = false,
      this.className});

  @override
  R accept<R>(IrVisitor<R> visitor) => visitor.visitTopLevelField(this);
}

// ---------------------------------------------------------------------------
// Mixin 静态函数集合
// ---------------------------------------------------------------------------

/// Mixin 的所有静态方法。
class IrMixinFuncs extends IrNode {
  final String mixinName;
  final List<IrStaticFunc> funcs;
  final List<IrTopLevelField> staticFields;
  final List<IrFieldDef> instanceFields;

  const IrMixinFuncs(this.mixinName,
      {this.funcs = const [],
       this.staticFields = const [],
       this.instanceFields = const []});

  @override
  R accept<R>(IrVisitor<R> visitor) => visitor.visitMixinFuncs(this);
}
