# dart2cpp · DartRestorer 工作笔记

本文件聚焦本包中 **Dart → Dart 静态代码转换（DartRestorer）** 的实现与验证。
> 仓库目录虽叫 `dart2cpp`，但 `lib/restorer/` 是一个独立的子系统：把 Dart Kernel AST 还原成一份 *OOP-lowered* 的纯 Dart 源码，再用 `dart run` 验证其与原始程序的输出等价。Dart→C++ 部分在 `lib/dart_to_cpp_compiler.dart` / `cpp/`，本文不展开。

---

## 1. 对外 API

- 入口：`String restoreDartFromComponent(Component component)`
  位置：`lib/restorer/dart_restorer.dart:16`
- 兼容 re-export：`lib/dart_to_dart_restorer.dart` 只做 `export 'restorer/dart_restorer.dart';`
- 实现拆分（`part of` 组合，主文件用 `part`）：
  - `restorer/dart_restorer.dart` — 入口、`DartRestorer`、`_DartRestorerBase`、`_VTableEntry`、`MethodSpecEntry`
  - `restorer/type_utils.dart` — `_restoreType`、集合静态化、`Future→Promise`
  - `restorer/constant_restorer.dart` — Kernel `Constant` 还原（含 tear-off）
  - `restorer/expression_restorer.dart` — 表达式（含闭包/方法调用/`this` 改写）
  - `restorer/statement_restorer.dart` — 语句（含 async 体的 `return → _promise.complete`）
  - `restorer/declaration_restorer.dart` — class / mixin / extension / typedef 输出
  - `restorer/runtime_classes.dart` — 还原输出顶部 import 的运行时库（`VPtr`/`*Box`/`Static*`/`Promise`）

`DartRestorer` 通过 mixin 把上述 part 组装：
`class DartRestorer extends _DartRestorerBase with _TypeUtils, _ConstantRestorer, _ExpressionRestorer, _StatementRestorer, _DeclarationRestorer`。

每次调用 `restore()` 都会清空 `_DartRestorerBase` 的所有状态字段（`_userClasses`、`_classHierarchy`、`_classVTableEntries`、`_methodTypeSpecializations`、`_boxedVars`、`_pendingClosureDecls`…），不要在 `DartRestorer` 实例间共享上下文。

---

## 2. 转换管线（restore 流程）

1. **类信息预扫描**：遍历 *非* `dart:`/`package:` 库，将 `Class` 分流到 `_userClasses` / `_mixinNames` / `_enumNames`；登记 `_classHierarchy`（子→父）、`_classNodes`；Kernel 合成的 mixin 中间类（名字含 `&`，例如 `_Dog&Animal&Printable`）登记到 `_syntheticLoweredNames`，并经 `_sanitizeSyntheticName` 规范成 `Dog_Animal_Printable`。
2. **拓扑构建虚表**：按父→子顺序对每个用户类调用 `_collectVTableEntries`，把方法/getter/setter/operator 抽象为 `_VTableEntry { kind, staticFuncName, signature, declaringClassName }`；`implements` 接口同样并入。
3. **方法级泛型特化收集**：`_collectMethodTypeSpecializations` 递归扫描所有 `InstanceInvocation`，对带泛型 *且类型实参全部为具体类型* 的调用，按 `className → methodName → Set<MethodSpecEntry(vptrSuffix, typeArgStrs)>` 登记。用于解决 `dynamic` 接收者在动态调度时丢失类型信息的问题。
4. **写运行时 import**：`_emitRuntimeImport()` 在输出顶部插入 `import 'package:dart2cpp/restorer/runtime_classes.dart';`。
5. **声明输出**：`_restoreLibrary` 依次写 `typedef` → `mixin` 的静态函数 → 用户 `class`（含合成中间类）→ 顶层 `procedure` → 顶层 `field`。
6. **延迟尾部追加**：
   - `_pendingTopLevelDecls`：类级共享的 vtable 常量（多构造函数共享同一表，避免重复输出）
   - `_pendingClosureDecls`：所有 ClosureEnv 类 + 其 `_call` 静态函数

---

## 3. OOP Lowering

把 Dart 的"对象 + 虚方法"模型展开成"值对象 + 顶层静态函数 + 字典型虚表"：

- **类拆三件套**（`declaration_restorer.dart` 的 `_restoreClassLowered` 系列）：
  1. `class XValue extends ParentValue/VPtr implements IfaceValue` — *只含字段*，不含方法；构造体内向 `vptr` 注册当前类的所有虚条目（覆盖父类同 key）。
  2. `X_new(dynamic this__, args)` / `X_new_named(...)` — 替代构造函数，按 Initializer 顺序调用 `Parent_new(this_, ...)` 再赋字段，最后返回 `this_`。
  3. 每个实例方法转成顶层静态函数 `X_method(dynamic this__, args)`；函数首行 `final this_ = this__ as XValue;`。getter/setter/operator 同样静态化。
- **虚表**：基类为 `runtime_classes.dart` 中的 `VPtr`，自带 `late Map<String, dynamic> vptr`。key 由 `_vptrEntryKey` 生成：方法名为 `name`、getter 为 `get_name`、setter 为 `set_name`、运算符为 `operatorPlus` / `operatorEq` 等。`VPtr` 在 `toString` / `operator==` / `hashCode` 上做了桥接，命中 vptr 条目则调用，否则回落到 `super.*`。
- **mixin lowering**：mixin 本身 *不* 生成 Value 类，`_restoreMixin` 只为其方法生成 `Mixin_method(dynamic this__, ...)` 静态函数。Kernel 合成的 `_Dog&Animal&Printable` 中间类作为额外用户类参与 extends 链，本身不生成构造函数（在 `_syntheticLoweredNames` 中被识别，super-init 时跳过）。继承未覆盖的方法用 `_emitDelegateFromProc` 生成委托静态函数，沿 `stubTarget` / 继承链找到真实定义类（mixin 或祖先类）转发。
- **类型参数具体化**：`_activeTypeParamSubstitution` + `_activeTypeParamTargets` 做按 `TypeParameter` *引用* 的精确替换；`_buildMixinFieldTypeSubstitution` 处理 mixin 字段在子类中的命名重写（`Observable<T>` → `ReactiveStore<V>` 这种 `T→V`）。
- **方法级泛型特化**：构造函数中按 `_methodTypeSpecializations` 注册形如 `vptr['fold_String'] = Either_fold<String>`；调用侧 `_restoreInstanceInvocation` 用相同后缀查表。
- **运行时基类桥接**：当用户类继承自非用户类基类（如 `AsyncStateMachine`）时，`_emitRuntimeParentBridgeMethods` 会塞入 `late Map<String, dynamic> vptr` 与抽象方法占位，使桥接保持类型完整。

---

## 4. 闭包 Lowering

- **捕获分析**：`analyzeCapturedVarsFromFunc()` 纯 AST 遍历，输出捕获的 `VariableDeclaration` 集合与是否捕获 `this`。
- **Box 化预分析**：`_preanalyzeBoxedVarsForFunc()` 在进入函数体前运行。规则：本层参数/局部变量中，凡是被嵌套 `FunctionExpression` 捕获、且类型为 `int/double/bool/String` 或 `TypeParameterType` 的，加入 `_boxedVars`；其他确定的引用类型（List/Map/函数/用户类）不装箱。**排除**：命名参数（改名会破坏 named-arg 调用语义）、for 循环变量（Dart 语义本就是每轮独立）。
- **Box 类型**：`IntBox` / `DoubleBox` / `StringBox` / `BoolBox` / `ObjectBox<T>`（`runtime_classes.dart`）。一个 `_boxedVars` 变量在还原中三处统一加 `.value`：声明、读、写；多个闭包共享同一 Box → 引用语义。
- **ClosureEnv 生成**（`_restoreFuncExprAsClosure`）：每个有捕获的闭包生成
  ```dart
  class ClosureEnv_<ctx>_<id> {
    /* 捕获字段 */
    ClosureEnv_<ctx>_<id>(...) : /* 初始化包成 Box */;
    void call() => ClosureEnv_<ctx>_<id>_call(this);
  }
  void ClosureEnv_<ctx>_<id>_call(ClosureEnv_<ctx>_<id> env) { /* 原闭包体，捕获变量加 env. 前缀 */ }
  ```
  闭包体内通过 `_capturedVarEnvPrefix` 让捕获变量自动加 `env.`；`this` 捕获走 `_thisIsCapturedInEnv` → `env.this_`；ClosureEnv 类与 `_call` 函数延迟到尾部输出（`_pendingClosureDecls`）。
- **无捕获**退化为 `_restoreFuncExprAsLambda`，输出普通 `(args) => body`。
- **`this` 改写**：实例方法体内 `this` → `this_`；构造函数体内 → `obj`；闭包内若被捕获则进一步 `env.this_`。

---

## 5. async/await Lowering

异步函数被**展平为同步函数 + ClosureEnv + 顶层 `_call`**：

```dart
// 原 Dart
Future<String> greetAsync(String name) async {
  return 'hello $name';
}
// 还原后
Promise<String> greetAsync(String name) {
  final env = ClosureEnv_greetAsync_0(name);
  env._promise.setStartCallback(env.call);
  return env._promise;
}
class ClosureEnv_greetAsync_0 {
  StringBox name;
  Promise<String> _promise;
  ClosureEnv_greetAsync_0(String name)
      : _promise = Promise<String>(), name = StringBox(name);
  void call() => ClosureEnv_greetAsync_0_call(this);
}
void ClosureEnv_greetAsync_0_call(ClosureEnv_greetAsync_0 env) {
  env._promise.complete('hello ${env.name.value}');
  return;
}
```

要点：
- `Future<T>` / `_Future` → `Promise<T>`；`await x` → `smAwait(x)`（运行时 trampoline）。
- async 函数体的 `return v` 在 `statement_restorer.dart` 中改写为 `env._promise.complete(v); return;`。
- 参数与原来一致，但若被异步体捕获则在 ClosureEnv 构造里装箱（基础类型）。

---

## 6. 类型映射（`type_utils.dart`）

| 原类型 | 还原为 | 说明 |
|---|---|---|
| 用户类 `X` | `XValue` | 仅含字段；方法走静态函数 + vptr |
| `List`, `_GrowableList`, `_List` | `StaticList` | 基于 `Array<T>` 的静态化容器（`runtime_classes.dart`） |
| `Map`, `_Map`, `LinkedHashMap`, `_InternalLinkedHashMap` | `StaticMap` | |
| `Set` 系 | `StaticSet` | |
| `Future`, `_Future` | `Promise<T>` | 配合 `GlobalScheduler` tick 推进 |
| 基础值类型在闭包捕获时 | `IntBox/DoubleBox/StringBox/BoolBox` | 引用语义 |
| 泛型参数 `T` 在闭包捕获时 | `ObjectBox<T>` | 运行时可能是值类型，统一装箱 |
| 可空 `T?` | 透传 `?` 后缀 | |
| `FutureOr<T>` | 保留 | |

---

## 7. 测试与验证

### 7.1 目录约定

`test/` 下成对存在：
```
restorer_async_test.dart          # 原始 Dart 程序（手写、可独立运行）
restorer_async_test_restored.dart # 跑完 restorer 后写出的产物（受版本控制，便于人审）
```
其它对：`restorer_advanced_*`、`restorer_complex_*`、`restorer_complex_oop_*`、`restorer_full_*`、`restorer_stress_*`、`state_machine_advanced_*`、`state_machine_coroutine_*`。

只有 *原始* `_test.dart` 由人维护；`_restored.dart` 是 runner 的输出快照。审 diff 时把它当成生成文件看待。

### 7.2 完整链路 runner

`test/run_restorer_test.dart`（功能版）— 9 步：

1. 读原始 `.dart`
2. front_end `compileToKernel` → `Component` + 落 `.dill`
3. `restoreDartFromComponent(component)` → 还原源码
4. 写到 `<name>_restored.dart`
5. 语法存在性检查 `_analyzeRestoredSource`：按测试名挑选检查表（`full` 检查 `mixin`/`async*`/`sync*`/`switch (`/`...`/`late` 等，`complex` 检查 `extension`/`Future<`/`for (final` 等），逐项判断字符串是否出现
6. `dart run` 还原文件，收集 stdout/exit
7. `dart run` 原始文件，收集 stdout/exit
8. 逐行对比两次 stdout，给出匹配率与前 10 处差异
9. 清理 `.dill`

判通过的标准：还原文件 `exit==0` **且** 两次 stdout `trim()` 完全一致。

调用方式：
```bash
cd pkg/dart2cpp
dart test/run_restorer_test.dart                       # 默认 restorer_complex_test
dart test/run_restorer_test.dart restorer_async_test
dart test/run_restorer_test.dart restorer_full_test
```

> SDK platform dill 路径硬编码在 `_sdkPlatformDill`：
> `/Users/tbsg/Project/MyProject.bundle/sdk/mydart/sdk/xcodebuild/DebugX64/dart-sdk/lib/_internal/vm_platform_strong.dill`
> 换机器 / 换 build dir 时记得改这一行（`run_restorer_simple.dart` 用 `/Users/tbsg/Project/MyProject/sdk/mydart/sdk/xcodebuild/...`，与 `run_restorer_test.dart` 不一致，注意区分）。

### 7.3 极简 runner

`test/run_restorer_simple.dart` — 用 `kernelForProgram`（不依赖 `vm/kernel_front_end.dart` target 配置），步骤简化为 6 步，没有 syntax-check，只跑还原 / 执行 / 输出对比。适合快速验证。

### 7.4 专项 runner

- `test/mixin_lowering_test.dart` — 自写一段 mixin 源码到 `/tmp/mixin_test_source.dart`，编译 + 还原 + 执行，验证 mixin lowering 是否产出可运行代码。注意其 `_sdkPlatformDill` 写的是 `/Users/alsc/...`（历史路径），换机器需手改。
- `test/static_collections_test.dart` — 直接 import `runtime_classes.dart` 测 `Array/StaticList/StaticMap/StaticSet` 的语义；这是运行时库的单元测试，不经过 restorer。
- `test/promise_enhanced_test.dart` — `Promise` 行为的独立测试。

### 7.5 还原产物的形态（看一眼即可对齐预期）

`restorer_complex_test.dart` 中：

```dart
class Circle extends Shape {
  double _radius;
  Circle(this._radius);
  double get radius => _radius;
  set radius(double v) { ... _radius = v; }
  @override double area() => 3.14159 * _radius * _radius;
}
```

还原成：

```dart
class CircleValue extends ShapeValue {
  late double _radius;
  CircleValue() {
    vptr['get_radius'] = Circle_get_radius;
    vptr['set_radius'] = Circle_set_radius;
    vptr['area'] = Circle_area;
    // ...
  }
}
CircleValue Circle_new(dynamic this__, double _radius) {
  final this_ = this__ as CircleValue;
  Shape_new(this_);
  this_._radius = _radius;
  return this_;
}
double Circle_get_radius(dynamic this__) {
  final this_ = this__ as CircleValue;
  return this_._radius;
}
double Circle_area(dynamic this__) { ... }
```

`new Circle(r)` 调用点会被改写为 `Circle_new(CircleValue(), r)`；虚调用 `shape.area()` 被改写为 `(shape.vptr['area'] as double Function(dynamic))(shape)`。

---

## 8. 已知/常见坑

- **vptr 重复赋值**：可见还原产物中同一 key 会出现多次赋值（例如 `Circle` 的 `vptr['get_name']` 出现两次）。这是按继承链 + 当前类各自登记导致的累加；语义正确（最后一次胜出），但视觉上冗余，目前未做去重。
- **SDK platform dill 硬编码**：runner 中三处路径互不一致，跨机器要逐一更新。
- **`dart:`/`package:` 库不参与还原**：只对用户库做 OOP lowering，运行时类（`VPtr`、`*Box`、`Static*`、`Promise`）通过 import 提供，不是 restorer 的输出。
- **`_test.dart` ↔ `_restored.dart` 必须配对**：若改了 restorer，记得对所有 `*_test.dart` 重跑 runner 让 `_restored.dart` 同步更新，再审 diff。
- **async 模型不是 state machine 真转写**：当前实现把整个异步体放到一个 `_call` 函数里，多 `await` 之间靠 `smAwait` trampoline，并非分裂为多个 case 的状态机。若要看真正 state-machine 风格的转写，参考 `state_machine_*_test*.dart`（这条路径下还原器会按状态机模式产出）。

---

## 9. 速查：关键符号位置

| 关心的事 | 文件 : 符号 |
|---|---|
| 入口 | `lib/restorer/dart_restorer.dart` : `restoreDartFromComponent` |
| 主类与共享状态 | `lib/restorer/dart_restorer.dart` : `DartRestorer` / `_DartRestorerBase` |
| 类信息预扫描 | `lib/restorer/dart_restorer.dart` : `_collectClassInfo` |
| vtable 收集 | `lib/restorer/dart_restorer.dart` : `_collectVTableEntries` / `_VTableEntry` |
| 方法泛型特化 | `lib/restorer/dart_restorer.dart` : `_collectMethodTypeSpecializations` / `MethodSpecEntry` |
| Box 化预分析 | `lib/restorer/dart_restorer.dart` : `_preanalyzeBoxedVarsForFunc` / `_needsBoxing` / `_primitiveBoxName` |
| 类→Value+静态 | `lib/restorer/declaration_restorer.dart` : `_restoreClassLowered` / `_emitValueClass` / `_emitValueClassConstructor` / `_emitConstructorFunction` / `_emitInstanceMethodAsStatic` |
| mixin lowering | `lib/restorer/declaration_restorer.dart` : `_restoreMixin` / `_emitMixinMethodAsStatic` / `_emitDelegateFromProc` |
| 接口收集 | `lib/restorer/declaration_restorer.dart` : `_collectUserImplementedInterfaces` |
| 调用→静态调用 | `lib/restorer/expression_restorer.dart` : `_restoreInstanceInvocation` / `_restoreInstanceGet` / `_restoreInstanceSet` / `_restoreConstructorInvocation` |
| 闭包转 ClosureEnv | `lib/restorer/expression_restorer.dart` : `_restoreFuncExprAsClosure` / `_restoreFuncExprAsLambda` |
| async return 改写 | `lib/restorer/statement_restorer.dart` : `_restoreStmt` |
| 类型还原 | `lib/restorer/type_utils.dart` : `_restoreType` / `_boxTypeNameFor` |
| 常量与 tear-off | `lib/restorer/constant_restorer.dart` : `_restoreConstant` |
| 运行时库 | `lib/restorer/runtime_classes.dart` : `VPtr` / `IntBox` 系 / `Array<T>` / `StaticList` 系 / `Promise<T>` / `GlobalScheduler` / `smAwait` |
| 完整 runner | `test/run_restorer_test.dart` |
| 极简 runner | `test/run_restorer_simple.dart` |
| 配对测试 | `test/restorer_*_test.dart` ↔ `test/*_restored.dart` |
