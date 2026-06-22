# DartRestorer 完整转换规则与实现细节

> 本文档全面分析 `lib/restorer/` 下 Dart → 静态 Dart（OOP-Lowered Dart）的全部转换规则、GC 机制、异步（Promise）实现，以及语法转换管线的每一步细节。

---

## 目录

- [1. 架构总览](#1-架构总览)
- [2. 转换管线（三遍扫描）](#2-转换管线三遍扫描)
- [3. OOP Lowering：类 → 值对象 + 静态函数 + 虚表](#3-oop-lowering类--值对象--静态函数--虚表)
- [4. 类型映射规则](#4-类型映射规则)
- [5. 表达式转换规则](#5-表达式转换规则)
- [6. 语句转换规则](#6-语句转换规则)
- [7. 常量还原规则](#7-常量还原规则)
- [8. 闭包 Lowering](#8-闭包-lowering)
- [9. async/await Lowering 与 Promise 系统](#9-asyncawait-lowering-与-promise-系统)
- [10. GC（垃圾回收）机制](#10-gc垃圾回收机制)
- [11. 运行时静态包装类](#11-运行时静态包装类)
- [12. 已知问题与设计取舍](#12-已知问题与设计取舍)

---

## 1. 架构总览

### 1.1 文件结构

```
lib/restorer/
├── dart_restorer.dart          # 1727行 · 入口、DartRestorer、_DartRestorerBase、捕获分析、Box预分析
├── declaration_restorer.dart   # 3234行 · 类/混入/枚举/扩展/typedef 的声明还原
├── expression_restorer.dart    # 2073行 · 所有表达式节点的转换
├── statement_restorer.dart     #  313行 · 所有语句节点的转换
├── type_utils.dart             #  320行 · 类型映射与辅助函数
├── constant_restorer.dart      #  382行 · Kernel常量还原
└── runtime_classes.dart        # 2017行 · 独立运行时库（非part of）
```

`dart_restorer.dart` 是 library 根文件，通过 `part` 指令组合其余5个文件（`runtime_classes.dart` 是独立库，被生成的代码 `import`）。

### 1.2 类组合

```
class DartRestorer extends _DartRestorerBase
    with _TypeUtils,
         _ConstantRestorer,
         _ExpressionRestorer,
         _StatementRestorer,
         _DeclarationRestorer
```

### 1.3 核心设计思想

将 Dart 的「对象 + 虚方法」模型展开为「**值对象 + 顶层静态函数 + 字典型虚表**」，使得后续可以机械地翻译到 C++。三大核心产物：

| 产物 | 说明 |
|------|------|
| `XValue` 类 | 只含字段，不含方法；继承 `VPtr` 基类 |
| `X_new()` 函数 | 替代构造函数，接收 `dynamic this__` 作为首参 |
| `X_method()` 静态函数 | 替代实例方法，首参为 `dynamic this__` |

---

## 2. 转换管线（三遍扫描）

### 2.1 入口 `restore(Component)`

```dart
String restore(Component component) {
  // ── 重置所有状态 ──
  _buf.clear();
  _userClasses.clear(); _mixinNames.clear(); _enumNames.clear();
  _classHierarchy.clear(); _classVTableEntries.clear();
  _classNodes.clear(); _syntheticLoweredNames.clear();

  // ── Pass 1：类信息预扫描 + 虚表构建 ──
  for (final lib in component.libraries) {
    if (uri.startsWith('dart:') || uri.startsWith('package:')) continue;
    _collectClassInfo(lib);
  }

  // ── Pass 2：方法级泛型特化扫描 ──
  _methodTypeSpecializations.clear();
  for (final lib in component.libraries) {
    if (uri.startsWith('dart:') || uri.startsWith('package:')) continue;
    _collectMethodTypeSpecializations(lib);
  }

  // ── 写运行时 import ──
  _emitRuntimeImport();

  // ── Pass 3：完整代码生成 ──
  for (final lib in component.libraries) {
    if (uri.startsWith('dart:') || uri.startsWith('package:')) continue;
    _restoreLibrary(lib);
  }
  return _buf.toString();
}
```

### 2.2 Pass 1：`_collectClassInfo`

遍历非 `dart:`/`package:` 库的所有 `Class` 节点，分三类：

| 类别 | 判定条件 | 注册到 | 是否参与虚表 |
|------|---------|--------|------------|
| Mixin 声明 | `cls.isMixinDeclaration` | `_mixinNames` | ❌ 无自己的虚表 |
| 枚举 | `cls.supertype.classNode.name == '_Enum'` | `_enumNames` | ❌ |
| 普通类（含合成中间类） | 兜底 | `_userClasses` | ✅ |

**合成中间类识别**：名字含 `&` 的类（如 `_Dog&Animal&Printable`）是 Kernel 为 `class Dog extends Animal with Printable` 生成的 mixin 应用中间类。经 `_sanitizeSyntheticName` 规范化（`_Dog&Animal&Printable` → `Dog_Animal_Printable`），注册到 `_syntheticLoweredNames`。

**继承链登记**：`_classHierarchy[child] = parent`，跳过 `Object` 父类。

**拓扑排序后构建虚表**：调用 `_topologicalSort` 确保父类先于子类处理，然后对每个类调用 `_collectVTableEntries`。

### 2.3 `_topologicalSort` — 父→子排序

递归 DFS，每个类先访问父类再添加自己：

```
visit('SpecialCircle') → visit('Circle') → visit('Shape') → 输出 Shape → Circle → SpecialCircle
```

只处理同一库内的父子关系（`dart:` 库的父类不在列表中，递归自然停止）。

### 2.4 `_collectVTableEntries` — 虚表构建

对每个类按三步构建完整虚表：

```
1. 继承父类虚表（浅拷贝）
2. 合并 implements 接口条目（去重）
3. 覆盖/新增自身方法
```

每个方法生成一个 `_VTableEntry`：

| 字段 | 说明 |
|------|------|
| `name` | 方法名（`area`、`get_radius`） |
| `kind` | `'method'` / `'getter'` / `'setter'` / `'operator'` |
| `staticFuncName` | 静态函数名（`Circle_area`、`Circle_get_radius`） |
| `signature` | 类型签名（`double Function(CircleValue this_)`） |
| `declaringClassName` | 首次声明该槽位的类名 |

**排除规则**：`static` 方法、`factory` 构造函数、私有方法（`_` 开头）不进虚表。

### 2.5 Pass 2：`_collectMethodTypeSpecializations`

**解决的问题**：泛型方法（如 `Either.fold<T>`）经 OOP lowering 后，`vptr['fold']` 无法携带类型参数。解决方案是注册带后缀的特化条目：`vptr['fold_String'] = Either_fold<String>`。

**算法**：递归扫描所有 `InstanceInvocation` 节点，筛选条件：
1. 方法有自身的类型参数（`methodTypeParams.isNotEmpty`）
2. 接收者属于用户类
3. 方法级类型实参**全部为具体类型**（不含 `TypeParameterType`）
4. 去重与类级类型参数同名的参数

**数据结构**：
```
_methodTypeSpecializations = {
  'Either': {
    'fold': { MethodSpecEntry('String', ['String']), MethodSpecEntry('int', ['int']) }
  }
}
```

### 2.6 Pass 3：`_restoreLibrary`

按顺序输出每个库的内容：

```
1. typedef 声明
2. mixin 静态函数
3. 用户类（含合成中间类）→ Value + _new + 静态方法
4. 顶层 procedure
5. 顶层 field
6. _pendingTopLevelDecls（共享虚表常量）
7. _pendingClosureDecls（所有 ClosureEnv 类 + _call 函数）
```

---

## 3. OOP Lowering：类 → 值对象 + 静态函数 + 虚表

### 3.1 完整转换示例

**原始 Dart**：
```dart
class Circle extends Shape {
  double _radius;
  Circle(this._radius);
  double get radius => _radius;
  set radius(double v) { _radius = v; }
  @override double area() => 3.14159 * _radius * _radius;
}
```

**还原后**：
```dart
// ① Value 类（只含字段）
class CircleValue extends ShapeValue {
  late double _radius;
  CircleValue() {
    vptr['get_radius'] = Circle_get_radius;
    vptr['set_radius'] = Circle_set_radius;
    vptr['area'] = Circle_area;
  }
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
    // double 不是 AnyGC，不需要递归标记
  }
}

// ② 构造函数
CircleValue Circle_new(dynamic this__, double _radius) {
  final this_ = this__ as CircleValue;
  Shape_new(this_);         // 调用父类构造函数
  this_._radius = _radius;
  return this_;
}

// ③ 静态方法
double Circle_get_radius(dynamic this__) {
  final this_ = this__ as CircleValue;
  return this_._radius;
}
void Circle_set_radius(dynamic this__, double v) {
  final this_ = this__ as CircleValue;
  this_._radius = v;
}
double Circle_area(dynamic this__) {
  final this_ = this__ as CircleValue;
  return 3.14159 * this_._radius * this_._radius;
}
```

### 3.2 `_emitValueClass` — Value 类生成规则

| 规则 | 说明 |
|------|------|
| 继承 | 用户类父类 → `extends ParentValue`；无父类 → `extends VPtr`；运行时父类 → `extends RuntimeParent` |
| 字段 | 所有字段标 `late`（在 `_new` 中赋值）；子类只声明自身新增字段 |
| 接口 | `implements` 的用户类 → `implements IfaceValue` |
| GC | 生成 `gcMark` 方法，递归标记所有 `AnyGC` 类型的字段 |

### 3.3 `_emitConstructorFunction` — 构造函数生成规则

**初始化序列**（按顺序执行）：

```
1. 重定向构造函数 → 调用 X_new_other(this_, args)
2. super 初始化 → Parent_new(this_, ...)（跳过合成中间类）
3. 方法级泛型特化 → vptr['fold_String'] = Either_fold<String>
4. 字段初始化器 → this_.field = expr
5. this.field 参数 → this_.field = param
6. 默认字段值 → this_.field = defaultValue
7. 构造函数体 → 执行，this → this_
8. return this_
```

### 3.4 `_emitInstanceMethodAsStatic` — 实例方法静态化

**命名规则**：

| 方法类型 | 静态函数名 |
|---------|-----------|
| 普通方法 `speak()` | `Dog_speak` |
| getter `get name` | `Dog_get_name` |
| setter `set name(v)` | `Dog_set_name` |
| 运算符 `+(other)` | `Dog_operatorPlus` |

**函数签名**：
```dart
ReturnType ClassName_methodName<T1, T2>(dynamic this__, ParamType1 p1, ...) {
  final this_ = this__ as ClassNameValue<T1, T2>;
  // 方法体，this → this_
}
```

- `this__` 始终为 `dynamic`（消除逆变问题）
- 可选位置参数的默认值在调用侧填充，函数签名中全部变为必需参数
- 类级+方法级类型参数合并去重

### 3.5 Mixin Lowering

Mixin **不**生成 Value 类，只生成静态函数：

```dart
// 原始
mixin Printable {
  void print_info() { print('Printable: $this'); }
}

// 还原后
void Printable_print_info(dynamic this__) {
  final this_ = this__;
  staticPrint('Printable: $this_');
}
```

### 3.6 委托方法生成（`_emitDelegateFromProc`）

当子类继承父类方法但不覆盖时，生成委托包装：

```dart
// Dog 继承了 Animal.speak 但没有覆盖
void Dog_speak(dynamic this__) {
  final this_ = this__ as DogValue;
  return Animal_speak(this_);
}
```

**四级回退策略**确定原始定义类：
1. `stubTarget` 链
2. 合成类名解析（提取最后一个 mixin 名）
3. 父类型链遍历
4. `_getParentClassName` 链兜底

### 3.7 枚举处理

枚举保持 `enum` 语法，方法提取为静态函数：

```dart
// 原始
enum Color {
  red(0xFF0000), green(0x00FF00), blue(0x0000FF);
  final int hex;
  const Color(this.hex);
  String describe() => 'Color($hex)';
}

// 还原后
enum Color {
  red(0xFF0000), green(0x00FF00), blue(0x0000FF);
  final int hex;
  const Color(this.hex);
}
String Color_describe(Color this_) {
  return 'Color(${this_.hex})';
}
```

### 3.8 扩展处理

扩展方法转成顶层静态函数，`|` 分隔符替换为 `_`：

```dart
// 原始
extension StringExtensions on String {
  String capitalize() => this[0].toUpperCase() + substring(1);
}

// 还原后
String StringExtensions_capitalize(String this_) {
  return this_[0].toUpperCase() + substring(1);
}
```

### 3.9 虚表调度机制

**注册**（在 Value 类构造函数中）：
```dart
vptr['area'] = Circle_area;
vptr['get_radius'] = Circle_get_radius;
```

**调度**（调用点）：
```dart
// shape.area() 被转成：
(shape.vptr['area'] as double Function(dynamic))(shape)
```

`VPtr` 基类桥接 `toString`、`==`、`hashCode`——检查 vptr 中是否有对应条目，有则调用，无则回退 `super.*`。

**覆盖机制**：由于 Dart 构造函数链先调 `super()`，父类 vptr 赋值先发生，子类构造函数体覆盖它们。

---

## 4. 类型映射规则

### 4.1 完整类型映射表

| 原类型 (Kernel `DartType`) | 还原为 | 说明 |
|---|---|---|
| **用户类** `X` | `XValue` | OOP lowering 核心 |
| `List`, `_GrowableList`, `_List` | `StaticList` | 静态化集合 |
| `Map`, `_Map`, `LinkedHashMap`, `_InternalLinkedHashMap` | `StaticMap` | |
| `Set`, `_Set`, `LinkedHashSet`, `_CompactLinkedHashSet` | `StaticSet` | |
| `Future`, `_Future` | `Promise` | 异步模型替换 |
| `StringBuffer` | `StaticStringBuffer` | |
| `Iterator`, `_ListIterator` | `StaticIterator` | |
| `MapEntry` | `StaticMapEntry` | |
| `Duration` | `StaticDuration` | |
| `DateTime` | `StaticDateTime` | |
| `RegExp`, `_RegExp` | `StaticRegExp` | |
| `Function`（顶层） | `dynamic` | 无 arity 信息 |
| `FunctionType`（有 arity） | `TypeFunctionN<R, T1..TN>` | N = 参数个数，上限16 |
| `TypeParameterType` `T` | `T`（或替换后的名字） | 参见 §4.3 |
| `DynamicType` | `dynamic` | |
| `VoidType` | `void` | |
| `NeverType` | `Never` | |
| `FutureOr<T>` | `FutureOr<T>` | 保持不变 |
| `RecordType` | `(int, String name)` | 保持不变 |
| `int`, `double`, `bool`, `String` | 不变 | 基础类型透传 |

### 4.2 可空类型处理

统一规则：若 `type.nullability == Nullability.nullable`，追加 `?` 后缀：

```
Circle → CircleValue
Circle? → CircleValue?
String? → String?
List<int>? → StaticList<int>?
```

### 4.3 类型参数替换

`_activeTypeParamSubstitution` 实现 mixin 字段的类型特化：

```
// Observable<T> 有字段类型 T
// ReactiveStore<V> extends Observable<V>
// 替换映射：T → V
TypeParameterType(T) → V
```

`_activeTypeParamTargets` 精确限制只替换特定 `TypeParameter` **引用**，避免误替无关作用域的同名参数。

### 4.4 函数类型转换

```
int Function(String, bool)        → TypeFunction2<int, String, bool>
void Function()                   → TypeFunction0<void>
void Function(int x, {int y})     → TypeFunction<void>     // 有命名参数→退化为基类
int Function(String, [int?])      → TypeFunction<int>       // 有可选位置参数→退化为基类
超过16个参数                        → TypeFunction<R>          // arity 溢出
```

### 4.5 Box 类型判定（`_boxTypeNameFor`）

| 变量类型 | Box 类型 | 原因 |
|---------|---------|------|
| `int` | `IntBox` | 值类型→需要引用语义 |
| `double` | `DoubleBox` | |
| `bool` | `BoolBox` | |
| `String` | `StringBox` | |
| `TypeParameterType` (`T`) | `ObjectBox<T>` | 运行时可能是值类型 |
| `List`, `Map`, 用户类, 函数等 | `null`（不装箱） | 已经是引用类型 |

---

## 5. 表达式转换规则

### 5.1 方法调用 → 静态函数调用（`_restoreInstanceInvocation`）

这是最复杂的规则，根据接收者类型有多个分支：

#### 5.1.1 用户类普通方法

```
BEFORE:  recv.method(arg1, arg2)
AFTER:   (recv.vptr['method'] as R Function(dynamic, T1, T2))(recv, arg1, arg2)
```

签名精确构建：`returnType Function(dynamic, ...positionalTypes, ...namedTypes)`。命名参数展平为位置参数（"Lowered ABI"），缺失的可选参数在调用侧填默认值。

#### 5.1.2 二元运算符

```
BEFORE:  a + b
AFTER:   (a.vptr['operatorPlus'] as R Function(dynamic, T))(a, b)
```

运算符名映射：`+` → `operatorPlus`，`-` → `operatorMinus`，`*` → `operatorMul`，`==` → `operatorEq`，`<` → `operatorLt`，`[]` → `operatorIndex`，etc.

#### 5.1.3 私有方法（直接调用，不走 vptr）

```
BEFORE:  recv._helper(arg)
AFTER:   ClassName__helper<T1, T2>(recv, arg)
```

#### 5.1.4 方法级泛型特化

```
BEFORE:  either.fold<String>(leftFn, rightFn)
AFTER:   (either.vptr['fold_String'] as R Function(dynamic, ...))(either, leftFn, rightFn)
```

当类型实参含未解析的类型参数时，回退到直接静态调用：

```
BEFORE:  either.fold<T>(leftFn, rightFn)   // T 是类型参数
AFTER:   Either_fold<T1, T2>(either, leftFn, rightFn)
```

#### 5.1.5 枚举方法调用

```
BEFORE:  color.describe()
AFTER:   Color_describe(color)
```

#### 5.1.6 非用户类（保持原样）

```
BEFORE:  list.add(x)
AFTER:   list.add(x)
```

### 5.2 静态方法调用（`_restoreStaticInvocation`）

#### 5.2.1 集合工厂构造函数

```
BEFORE:  List<int>.filled(5, 0)              AFTER: StaticList<int>.filled(5, 0)
BEFORE:  Map<String, int>.from(entries)      AFTER: StaticMap<String, int>.of(entries)
BEFORE:  Set<int>.from(items)                AFTER: StaticSet<int>.of(items)
```

#### 5.2.2 Future → Promise

```
BEFORE:  Future<String>.delayed(dur, comp)   AFTER: promiseDelayed<String>(dur, comp)
BEFORE:  Future<int>.value(42)               AFTER: Promise<int>.value(42)
```

#### 5.2.3 用户类静态方法/工厂

```
BEFORE:  MyClass.staticMethod(args)          AFTER: MyClass_staticMethod<T>(args)
BEFORE:  MyClass.named(arg)                  AFTER: MyClass_new_named<T>(arg)
```

#### 5.2.4 print → staticPrint

```
BEFORE:  print('hello')                      AFTER: staticPrint('hello')
```

### 5.3 构造函数调用（`_restoreConstructorInvocation`）

#### 5.3.1 用户类

```
BEFORE:  new Circle(5.0)
AFTER:   Circle_new(GC.allocateLocal(CircleValue()), 5.0)

BEFORE:  new Point<int>(1, 2)
AFTER:   Point_new<int>(GC.allocateLocal(PointValue<int>()), 1, 2)
```

#### 5.3.2 SDK 类名映射

| 原始 | 映射 |
|------|------|
| `StringBuffer` | `StaticStringBuffer` |
| `MapEntry` | `StaticMapEntry` |
| `RegExp` | `StaticRegExp` |
| `Duration` | `StaticDuration` |
| `DateTime` | `StaticDateTime` |
| `StateError` | `DartStateError` |
| `ArgumentError` | `DartArgumentError` |
| `RangeError` | `DartRangeError` |
| `FormatException` | `DartFormatException` |

### 5.4 属性访问

#### 5.4.1 私有字段（直接访问）

```
BEFORE:  obj._radius                          AFTER: obj._radius
```

#### 5.4.2 用户类公开 getter（走 vptr）

```
BEFORE:  shape.area                           AFTER: (shape.vptr['get_area'] as R Function(dynamic))(shape)
```

#### 5.4.3 setter

```
BEFORE:  shape.area = 10.0
AFTER:   (shape.vptr['set_area'] as void Function(dynamic, double))(shape, 10.0)
```

### 5.5 `this` 改写

| 上下文 | `this` 被改写为 |
|--------|----------------|
| 实例方法体 | `this_` |
| 构造函数体 | `obj` |
| 闭包内且被捕获 | `env.this_` |
| 非 lowered 上下文 | `this`（保持） |

**`super` 访问**：

```
BEFORE:  super.name                          AFTER: ParentClass_get_name(this_)
BEFORE:  super.method(arg)                   AFTER: ParentClass_method<T>(this_, arg)
```

合成中间类（含 `&`）被跳过，找到真正的父类。

### 5.6 变量访问与 Box

| 情况 | 读 | 写 |
|------|---|---|
| 普通变量 | `x` | `x = 5` |
| 被捕获变量 | `env.x` | `env.x = 5` |
| Boxed 变量 | `x.value` | `x.value = 5` |
| 被捕获 + Boxed | `env.x.value` | `env.x.value = 5` |

### 5.7 Null 安全操作

Kernel 将 `expr?.member` 反糖为 `Let(tmp = expr, tmp == null ? null : tmp.member)`。

**非用户类**：恢复为 `?.` 语法
```
AFTER:  str?.length
```

**用户类**：IIFE（因为 `?.` 无法触发 vptr 调度）
```
AFTER:  (() { final tmp = shape; return (tmp == null) ? null : (tmp.vptr['area'] as double Function(dynamic))(tmp); })()
```

### 5.8 `??`（Null 合并）

```
BEFORE:  expr ?? fallback
AFTER:   (expr ?? fallback)
```

### 5.9 级联表达式（`..`）

**非用户类**：恢复 `..` 语法
```
AFTER:  (list..add(1)..add(2))
```

**用户类**：IIFE（需要 vptr 调度）
```
AFTER:  (() { final tmp = builder; (tmp.vptr['setX'] as ...)(tmp, 1); (tmp.vptr['setY'] as ...)(tmp, 2); return tmp; })()
```

### 5.10 集合字面量

```
[1, 2, 3]               → StaticList<int>.of([1, 2, 3])
{'a': 1, 'b': 2}        → StaticMap<String, int>.of({'a': 1, 'b': 2})
{1, 2, 3}               → StaticSet<int>.of([1, 2, 3])
```

### 5.11 字符串插值

```
'hello $name, ${age}'    → 'hello ${name}, ${age}'
```

枚举有自定义 `toString` 时，在插值中替换为显式调用：

```
'Status: $status'        → 'Status: ${Priority_toString(status)}'
```

### 5.12 类型检查与强制转换

```
x is Circle              → (x is CircleValue)
x as int                 → (x as int)
```

### 5.13 await 表达式

```
BEFORE:  await someFuture
AFTER:   smAwait(someFuture)
```

### 5.14 闭包调用（`FunctionInvocation`）

```
BEFORE:  fn(1, 2)
AFTER:   fn.closureCall(fn, 1, 2)
```

### 5.15 Tear-off 表达式

用户类方法的 tear-off 生成 ClosureEnv 包装，捕获接收者并通过 vptr 调度：

```
BEFORE:  circle.area    // tear-off，未调用

AFTER:   ClosureEnv_main_0_new(GC.allocateLocal(ClosureEnv_main_0()), circle)
// 延迟输出：
class ClosureEnv_main_0 extends TypeFunction1<double, dynamic> { ... }
double ClosureEnv_main_0_call(dynamic env__, dynamic a1) {
  final _r = (env__ as ClosureEnv_main_0)._r;
  return (_r.vptr['area'] as double Function(dynamic))(_r);
}
```

---

## 6. 语句转换规则

### 6.1 语句类型映射总表

| 语句类型 | 转换规则 |
|---------|---------|
| `Block` | `{ ... }` + 缩进 |
| `ReturnStatement` | `return expr;`（async 模式下改写） |
| `ExpressionStatement` | `expr;`（跳过 `ReachabilityError`） |
| `VariableDeclaration` | 三种路径（见下） |
| `IfStatement` | `if (cond) then else` |
| `ForStatement` | `for (init; cond; update) { body }` |
| `WhileStatement` | `while (cond) { body }` |
| `DoStatement` | `do { body } while (cond);` |
| `ForInStatement` | `for (final item in iterable) { body }` |
| `SwitchStatement` | `switch (x) { case ...: ... default: ... }` |
| `TryCatch` | `try { ... } on Type catch (e) { ... }` |
| `TryFinally` | 合并为 `try { ... } catch { ... } finally { ... }` |
| `YieldStatement` | `yield 42;` |
| `AssertStatement` | `assert(cond, msg);` |
| `LabeledStatement` | `do { ... break; ... } while (false);` |
| `BreakStatement` | `break;` |
| `FunctionDeclaration` | `ReturnType name(params) { body }` |

### 6.2 Return 的 async 改写

当 `_insideAsyncFunction == true` 且有返回值时：

```
BEFORE:  return 'hello';
AFTER:   env._promise.complete('hello');
         return;
```

原因：async 函数体位于 `ClosureEnv_*_call` 函数中，返回类型为 `void`，实际结果通过 `Promise` 传递。

### 6.3 变量声明三路径

**(a) `_alreadyDeclared_` 前缀**（Kernel 重复声明）：
```
_alreadyDeclared_x = 5    →    x = 5;
```

**(b) Boxed 变量**（被闭包捕获的值类型）：
```
int count = 0             →    IntBox count = IntBox(0);
T val = expr              →    ObjectBox<T> val = ObjectBox<T>(expr);
```

**(c) 普通变量**：
```
final int x = 10          →    final int x = 10;
int n;                    →    late int n;     // 无初始值 + 非空类型 → 加 late
```

**集合适配**（`_adaptInitForStaticCollection`）：
```
final List<String> parts = str.split(',');
→ final StaticList<String> parts = StaticList<String>.of(str.split(','));
```

### 6.4 LabeledStatement → `do-while(false)`

Kernel 将 switch-pattern 的 break 目标反糖为 `LabeledStatement`。还原为 `do { ... } while (false);`，保持 `break` 语义。

---

## 7. 常量还原规则

### 7.1 基础常量

| 常量类型 | 还原结果 |
|---------|---------|
| `IntConstant(42)` | `42` |
| `DoubleConstant(3.0)` | `3.0`（确保有小数点） |
| `BoolConstant(true)` | `true` |
| `NullConstant()` | `null` |
| `StringConstant("hello\nworld")` | `'hello\nworld'`（转义 `\`、`'`、`\n`） |
| `SymbolConstant('foo')` | `#foo` |

### 7.2 集合常量（保持 `const` 字面量）

```
ListConstant([1, 2])              → const [1, 2]
SetConstant({'a', 'b'})           → const {'a', 'b'}
MapConstant({1: 'one'})           → const {1: 'one'}
RecordConstant((1, name: 'x'))    → const (1, name: 'x')
```

### 7.3 InstanceConstant — 非用户类

通过评分匹配 `const` 构造函数：

```
// 匹配成功
const Point(1, 2)                → const Point(1, 2)
// 命名构造函数
const Color.rgb(255, 0, 0)       → const Color.rgb(255, 0, 0)
// 默认值匹配时省略
const Config()                    → const Config()   // timeout=30 匹配默认，省略
// 兜底
const Foo(a: 1, b: 'hi')         → const Foo(a: 1, b: 'hi')
```

### 7.4 InstanceConstant — 用户类（OOP Lowering）

```
BEFORE:  InstanceConstant(Point, {x: 3, y: 4})
AFTER:   Point_new(PointValue(), 3, 4)
```

### 7.5 枚举常量

```
// 通过静态字段匹配
Color.green                      → Color.green
// 兜底：读 _name 字段
Color._name='red'                → Color.red
```

### 7.6 Tear-off 常量

```
// 用户类实例方法
Circle_area                      → Circle_area
// 非用户类静态方法
int.parse                        → int.parse
// 构造函数 tear-off（用户类）
Point_new                        → Point_new
// 构造函数 tear-off（非用户类）
DateTime.now                     → DateTime.now
```

---

## 8. 闭包 Lowering

### 8.1 捕获分析

**`analyzeCapturedVarsFromFunc`** 纯 AST 遍历：

1. 将函数自身参数加入 `localDecls`
2. 递归遍历函数体，调用 `_collectCaptured`
3. 凡引用了 `localDecls` 之外的变量 → 捕获
4. `ThisExpression` → `capturesThis = true`

**嵌套闭包处理**：内层闭包独立分析，其捕获的变量如果也不在外层的 `localDecls` 中，则冒泡到外层的捕获集合。

### 8.2 Box 化预分析（`_preanalyzeBoxedVarsForFunc`）

在进入函数体前运行，确定哪些变量需要 Box 包装：

| 条件 | 说明 |
|------|------|
| 属于当前函数作用域 | `localOfThisLevel.contains` |
| 不是命名参数 | 改名会破坏 named-arg 调用语义 |
| 不是 for 循环变量 | Dart 语义每轮独立 |
| 类型为 `int`/`double`/`bool`/`String`/`TypeParameterType` | 值类型需要引用语义 |

### 8.3 ClosureEnv 生成（`_restoreFuncExprAsClosure`）

**所有闭包**（无论是否捕获变量）都转成 ClosureEnv 类：

```
BEFORE:
int captured = 10;
var fn = (int x) => x + captured;

AFTER (使用点):
ClosureEnv_main_0_new(GC.allocateLocal(ClosureEnv_main_0()), captured)

AFTER (延迟输出):
class ClosureEnv_main_0 extends TypeFunction1<int, int> {
  late int captured;
  ClosureEnv_main_0();
  @override int call(int x) => closureCall(this, x);
  @override void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
    if (captured is AnyGC) (captured as AnyGC).gcMark(flag);
  }
}
ClosureEnv_main_0 ClosureEnv_main_0_new(ClosureEnv_main_0 env_, int captured) {
  env_.closureCall = ClosureEnv_main_0_call;
  env_.captured = captured;
  return env_;
}
int ClosureEnv_main_0_call(dynamic env__, int x) {
  final env = env__ as ClosureEnv_main_0;
  return x + env.captured;
}
```

### 8.4 Box 化变量捕获

```
BEFORE:
int counter = 0;
var inc = () => counter++;

AFTER:
class ClosureEnv_foo_0 extends TypeFunction0<void> {
  late IntBox counter;    // Box 类型
  ...
}
// _call 内部：
return env.counter.value++;    // .value 访问
```

### 8.5 `this` 捕获

```
BEFORE:  class Foo { Function makeFn() => () => this.x; }

AFTER:
class ClosureEnv_Foo_0 extends TypeFunction0<int> {
  late FooValue this_;
}
// _call 内部：
return env.this_.x;
// 使用点：
ClosureEnv_Foo_0_new(GC.allocateLocal(ClosureEnv_Foo_0()), this_)
```

### 8.6 泛型类型参数

```
BEFORE:  class Box<T> { Function id() => (T x) => x; }

AFTER:
class ClosureEnv_Box_0<T> extends TypeFunction1<T, T> { ... }
T ClosureEnv_Box_0_call<T>(dynamic env__, T x) { ... }
```

### 8.7 嵌套闭包

通过 `_pushClosureContext` / `_popClosureContext` 栈管理，层级命名：

```
ClosureEnv_ClosureEnv_outer_0_1    // 嵌套在 ClosureEnv_outer_0 内部
```

### 8.8 TypeFunction 基类选择

| 条件 | 继承 |
|------|------|
| 无命名参数 且 arity ≤ 16 | `extends TypeFunctionN<R, T1, ..., TN>`（有 `@override call`） |
| 有命名参数 或 arity > 16 | `extends TypeFunction`（基类，无 override） |

---

## 9. async/await Lowering 与 Promise 系统

### 9.1 异步函数展开

```
BEFORE:
Future<String> greet(String name) async {
  return 'hello $name';
}

AFTER:
// ① 包装函数（替代原始函数）
Promise<String> greet(String name) {
  final env = ClosureEnv_greet_0(name);
  env._promise.setStartCallback(env.call);
  return env._promise;
}

// ② ClosureEnv 类
class ClosureEnv_greet_0 {
  StringBox name;
  Promise<String> _promise;
  ClosureEnv_greet_0(String name)
      : _promise = Promise<String>(), name = StringBox(name);
  void call() => ClosureEnv_greet_0_call(this);
}

// ③ 静态 _call 函数（包含原始函数体）
void ClosureEnv_greet_0_call(ClosureEnv_greet_0 env) {
  env._promise.complete('hello ${env.name.value}');
  return;
}
```

### 9.2 异步转换规则表

| 原始 | 还原后 |
|------|--------|
| `Future<T>` 返回类型 | `Promise<T>` |
| `return value;`（async 体中） | `env._promise.complete(value); return;` |
| `await expr` | `smAwait(expr)` |
| `int`/`double`/`bool`/`String` 参数 | ClosureEnv 中装箱（`IntBox`、`StringBox` 等） |
| `TypeParameter` 参数 | `ObjectBox<T>` |
| 引用类型参数 | 直接存储（不装箱） |
| `this`（实例方法中） | `env.this_` 字段 |

### 9.3 实例方法的异步展开

```
BEFORE:
class Server {
  Future<String> fetch(String url) async {
    return 'data from $url';
  }
}

AFTER:
Promise<String> Server_fetch<T>(dynamic this__, String url) {
  final this_ = this__ as ServerValue<T>;
  final env = ClosureEnv_Server_fetch_0(this_, url);
  env._promise.setStartCallback(env.call);
  return env._promise;
}

class ClosureEnv_Server_fetch_0 {
  ServerValue<dynamic> this_;
  StringBox url;
  Promise<String> _promise;
  ClosureEnv_Server_fetch_0(this.this_, String url)
      : _promise = Promise<String>(), url = StringBox(url);
  void call() => ClosureEnv_Server_fetch_0_call(this);
}

void ClosureEnv_Server_fetch_0_call(ClosureEnv_Server_fetch_0 env) {
  env._promise.complete('data from ${env.url.value}');
  return;
}
```

### 9.4 `Promise<T>` 运行时

**状态机**：
```
ready → pending → completed
                ↘ error
```

| 状态 | 说明 |
|------|------|
| `ready` | 已注册启动回调，等待调度器触发 |
| `pending` | 正在执行，被 `_onTick` 每个 tick 驱动 |
| `completed` | 成功完成，`_result` 持有值 |
| `error` | 出错，`error` 持有异常 |

**关键方法**：

- `setStartCallback(callback)` → 注册启动回调，状态 → `ready`，注册到 `GlobalScheduler`
- `complete(value)` → 终态转换
- `Promise.value<T>(val)` → 创建已完成 Promise
- `Promise.delayed<T>(ticks, computation)` → 延迟任务
- `then<R>(onValue)` → 链式调用，支持 flatMap 语义（如果 `onValue` 返回 `Promise<R>`，则替换 `_onTick` 等待内层）
- `catchError(onError)` → 错误恢复
- `whenComplete(action)` → 无论成功失败都执行

### 9.5 `GlobalScheduler` — 三阶段事件循环

```dart
void tick() {
  _currentTick++;

  // 阶段1：触发所有 ready 的 Promise 的启动回调
  for (final promise in readySnapshot) {
    if (promise.isReady) promise._fireStartCallback();
  }

  // 阶段2：执行过期的延迟任务
  for (final task in expired) task.callback();

  // 阶段3：驱动所有 active Promise 前进一步
  for (final promise in snapshot) {
    if (onTick != null && onTick()) finished.add(promise);
  }
}
```

### 9.6 `smAwait` — 阻塞等待

```dart
T smAwait<T>(dynamic promiseOrFuture) {
  _smAwaitDepth++;
  if (_smAwaitDepth > 500) throw ...;  // 递归保护
  try { return _smAwaitImpl<T>(promiseOrFuture); }
  finally { _smAwaitDepth--; }
}
```

**`_smAwaitImpl`** 处理三种情况：
1. `Promise<T>` → 自旋调用 `tick()` 直到完成（上限 100,000 ticks）
2. `Future<T>`（原生 Dart future）→ 附加 `.then`/`.onError` 回调，自旋等待
3. `Promise`（非泛型匹配）→ 同 1

### 9.7 `AsyncStateMachine<T>` — 状态机基类

```dart
abstract class AsyncStateMachine<T> extends AnyGC {
  int smState = 0;
  final Promise<T> promise = Promise<T>();
  bool step();                    // 子类实现，每次调用推进一个状态
  Promise<T> start() {
    promise._onTick = step;
    GlobalScheduler.instance.registerActivePromise(promise);
    return promise;
  }
}
```

用于 `state_machine_*` 测试路径的状态机风格异步函数。

### 9.8 `promiseDelayed` — Duration → ticks 映射

```dart
Promise<T> promiseDelayed<T>(StaticDuration duration, [T Function()? computation]) {
  final ticks = (duration.inMilliseconds / 10).ceil().clamp(1, 100000);
  // 10ms = 1 tick
}
```

---

## 10. GC（垃圾回收）机制

### 10.1 `AnyGC` — GC 管理基类

```dart
abstract class AnyGC {
  int gcFlag = 0;
  void gcMark(int flag) {
    if (gcFlag == flag) return;   // 循环保护
    gcFlag = flag;
  }
}
```

- **单字段 `gcFlag`**：整数戳。GC 用单调递增的 `_currentFlag` 代替重置标记
- **循环检测**：`if (gcFlag == flag) return;` 防止循环引用导致无限递归
- **子类契约**：子类覆盖 `gcMark`，先调 `super.gcMark(flag)`（设置戳并提供循环保护），然后递归标记所有 `AnyGC` 类型的字段

### 10.2 `GC` — 全局标记-清除收集器

**数据结构**：
```dart
static int _currentFlag = 0;
static final List<AnyGC> _objects = [];       // 所有注册对象
static final List<AnyGC> _roots = [];         // 根集合（全局/静态变量）
static final Set<AnyGC> _registered = {};     // 去重集合
```

**`allocateLocal<T extends AnyGC>(T object) → T`**：
- 注册非根（堆局部）对象
- 使用 `_registered.add(object)` 做 O(1) 去重
- 返回对象，可内联包装 `new` 表达式：`GC.allocateLocal(X_new(XValue(), args))`

**`allocateGlobal<T extends AnyGC>(T object) → T`**：
- 同 `allocateLocal`，但额外加入 `_roots`（GC 根）
- 根对象永远不会被清除

**`removeRoot(AnyGC object)`**：
- 将根降级为普通对象

### 10.3 `collect()` — 标记-清除算法

```
1. _currentFlag++（无效化上一轮所有对象，无需逐个清零）
2. 标记阶段：遍历 _roots，调用 root.gcMark(flag)，递归标记所有可达对象
3. 清除阶段：_objects.removeWhere(obj => obj.gcFlag != flag)
4. 返回被清除对象数量
```

**特点**：
- **协作式**：无写屏障、无分代，完全靠显式调用
- **确定性**：给定相同的 `tick()` 调用序列，输出完全可复现
- **根集合显式管理**：代码生成器在发射时决定哪些变量是全局/静态的

### 10.4 各类的 GC 参与

| 类型 | `gcMark` 实现 |
|------|-------------|
| `IntBox`/`DoubleBox`/`StringBox`/`BoolBox` | 只需 `super.gcMark(flag)`（值类型不需要递归） |
| `ObjectBox<T>` | `super.gcMark(flag)` + 如果 `value is AnyGC` 则递归 |
| `Array<T>` | 遍历所有元素，`AnyGC` 类型的递归标记 |
| `StaticList<T>` | 委托给 `_data.gcMark(flag)` |
| `StaticMap<K,V>` | 标记 `_keys` 和 `_values` 两个 Array |
| `StaticSet<T>` | 委托给 `_data.gcMark(flag)` |
| `Promise<T>` | 标记 `_result` 和 `error`（如果是 `AnyGC`） |
| `VPtr`（Value 类基类） | 子类生成 `gcMark` 递归标记所有非基础类型字段 |
| `TypeFunction` | 继承 `AnyGC`，`closureCall` 字段由子类处理 |

### 10.5 GC 注册时机

| 对象 | 注册方式 |
|------|---------|
| `XValue` 实例 | 构造函数调用点：`GC.allocateLocal(X_new(XValue(), ...))` |
| `ClosureEnv` 实例 | 同上：`GC.allocateLocal(ClosureEnv_xxx_new(...))` |
| Box 实例 | 构造函数内自动：`IntBox(this.value) { GC.allocateLocal(this); }` |
| 全局/静态变量 | `GC.allocateGlobal(...)` |
| 集合实例 | 构造函数内或调用点 |

---

## 11. 运行时静态包装类

### 11.1 `TypeFunction` 家族

```
TypeFunction (abstract, extends AnyGC)
├── TypeFunction0<R>
├── TypeFunction1<R, T1>
├── TypeFunction2<R, T1, T2>
├── ...
└── TypeFunction16<R, T1, ..., T16>
```

- 替代裸 `Function` 类型，每个 arity 一个具体类
- `closureCall` 字段持有实际实现
- 参与 GC 管理
- 上限 16 个参数，超出退化为 `TypeFunction<R>`

### 11.2 `VPtr` — 虚表基类

```dart
class VPtr extends AnyGC {
  late Map<String, dynamic> vptr;
  VPtr() {
    vptr = <String, dynamic>{'toString': null, 'operatorEq': null, 'get_hashCode': null};
  }
  // 桥接 toString、==、hashCode → vptr 条目
}
```

**vptr key 命名约定**：

| 类型 | key 格式 | 示例 |
|------|---------|------|
| 方法 | `name` | `speak` |
| getter | `get_name` | `get_radius` |
| setter | `set_name` | `set_radius` |
| 运算符 | `operatorXxx` | `operatorPlus`, `operatorEq`, `operatorIndex` |

### 11.3 静态集合

| 类型 | 内部存储 | 特点 |
|------|---------|------|
| `Array<T>` | `List<T> _storage` | 基础存储，固定/动态两种模式 |
| `StaticList<T>` | `Array<T> _data` | 完整 List API（~360行），`implements Iterable<T>` |
| `StaticMap<K,V>` | `Array<K> _keys` + `Array<V> _values` | 并行数组，O(n) 查找 |
| `StaticSet<T>` | `Array<T> _data` | `add()` 检查 `contains` 后追加，O(n) |

**所有集合都 `extends AnyGC`**，通过 `gcMark` 递归标记元素。

### 11.4 其他静态包装

| 包装类 | 替代 | 说明 |
|--------|------|------|
| `staticPrint` | `print` | 顶层函数 |
| `StaticStringBuffer` | `StringBuffer` | 委托实现 |
| `StaticMapEntry<K,V>` | `MapEntry` | `MapEntry` 是 `final` 无法继承 |
| `StaticIterator<T>` | `Iterator<T>` | 含 `_ArrayIterator<T>` 内部实现 |
| `StaticRegExp` | `RegExp` | 实现 `Pattern` 接口 |
| `StaticDuration` | `Duration` | 委托实现 |
| `StaticDateTime` | `DateTime` | 完整工厂方法 + 算术运算 |
| `StaticComparable<T>` | `Comparable<T>` | 只有 `compareTo` |

### 11.5 异常层次

| 类 | 继承 | 用途 |
|----|------|------|
| `DartException` | `implements Exception` | 基础异常 |
| `DartStateError` | `StateError` | 非法状态 |
| `DartArgumentError` | `ArgumentError` | 参数错误 |
| `DartRangeError` | `RangeError` | 越界（含 `.range()`、`.value()` 命名构造） |
| `DartFormatException` | `FormatException` | 解析错误 |
| `DartUnsupportedError` | `UnsupportedError` | 不支持的操作 |
| `DartUnimplementedError` | `UnimplementedError` | 未实现的方法 |

---

## 12. 已知问题与设计取舍

### 12.1 已知问题

| 问题 | 说明 |
|------|------|
| **vptr 重复赋值** | 同一 key 在构造函数中可能出现多次（继承链各级各登记一次），最后一次胜出，语义正确但视觉冗余 |
| **SDK platform dill 硬编码** | runner 中三处路径互不一致，跨机器需逐一更新 |
| **`dart:`/`package:` 库不参与还原** | 只对用户库做 OOP lowering |
| **async 模型非真状态机** | 当前把整个异步体放到一个 `_call` 函数，`state_machine_*` 测试路径才有真正的状态机风格 |

### 12.2 设计取舍

| 取舍 | 选择 | 原因 |
|------|------|------|
| **所有闭包 → ClosureEnv** | 即使无捕获也转 | 统一为命名类，C++ 可引用 |
| **`this__` 始终 `dynamic`** | 不用精确类型 | 消除逆变问题，简化 vptr 调度 |
| **命名参数展平** | 全部变位置参数 | "Lowered ABI"——vptr 条目和静态函数不用命名参数 |
| **集合全部替换** | `List → StaticList` 等 | 脱离 `dart:collection` 依赖，自实现便于翻译到 C++ |
| **GC 协作式** | 无写屏障/分代 | 简单可控，适合代码生成场景 |
| **Promise 自旋** | `smAwait` 阻塞循环 | 单线程模拟异步，确定性可复现 |

### 12.3 测试产物膨胀率

| 测试 | 原始行数 | 还原后行数 | 膨胀率 |
|------|---------|-----------|-------|
| advanced | 1,151 | 2,414 | 2.1× |
| full | 1,052 | 2,179 | 2.1× |
| stress | 963 | 2,226 | 2.3× |
| complex_oop | 591 | 2,008 | 3.4× |
| complex | 299 | 604 | 2.0× |
| async | 77 | 133 | 1.7× |
| **总计** | **~4,133** | **~35,480** | **~8.5×** |

OOP lowering（Value + `_new` + 静态方法）和 ClosureEnv 生成是膨胀的主要来源。

---

## 附录：状态字段全览

### 输出缓冲

| 字段 | 类型 | 用途 |
|------|------|------|
| `_buf` | `StringBuffer` | 生成代码累积缓冲 |
| `_indent` | `int` | 当前缩进层级 |
| `_varCounter` | `int` | 唯一临时变量名计数器 |
| `_cleanedNames` | `Map<String, String>` | 清理后名称缓存 |

### OOP Lowering — 类注册

| 字段 | 类型 | 用途 |
|------|------|------|
| `_userClasses` | `Set<String>` | 所有用户定义类名 |
| `_mixinNames` | `Set<String>` | 所有 mixin 名 |
| `_enumNames` | `Set<String>` | 所有枚举类名 |
| `_enumsWithCustomToString` | `Set<String>` | 有自定义 toString 的枚举 |
| `_classHierarchy` | `Map<String, String>` | 子→父映射 |
| `_classVTableEntries` | `Map<String, List<_VTableEntry>>` | 类→完整虚表 |
| `_classNodes` | `Map<String, Class>` | 类名→AST 节点 |
| `_syntheticLoweredNames` | `Set<String>` | 合成中间类名 |

### OOP Lowering — 函数上下文

| 字段 | 类型 | 用途 |
|------|------|------|
| `_currentClass` | `Class?` | 当前处理的类 |
| `_activeTypeParamSubstitution` | `Map<String, String>` | 类型参数替换映射 |
| `_activeTypeParamTargets` | `Set<TypeParameter>` | 精确替换目标集合 |
| `_insideMethodBody` | `bool` | 是否在实例方法体内 |
| `_isStaticFieldContext` | `bool` | 是否在静态字段上下文 |
| `_thisReplacementName` | `String` | this 替换名（`this_` 或 `obj`） |
| `_insideAsyncFunction` | `bool` | 是否在异步函数体内 |
| `_asyncInnerReturnType` | `String` | 异步函数的内部返回类型 |

### 闭包 & Box

| 字段 | 类型 | 用途 |
|------|------|------|
| `_closureCounter` | `int` | ClosureEnv 类名计数器 |
| `_closureContextStack` | `List<String>` | 嵌套闭包命名上下文栈 |
| `_pendingClosureDecls` | `List<String>` | 延迟输出的闭包类定义 |
| `_pendingTopLevelDecls` | `List<String>` | 延迟输出的共享虚表常量 |
| `_capturedVarEnvPrefix` | `Map<VariableDeclaration, String>` | 闭包内捕获变量→`env.` 前缀 |
| `_thisIsCapturedInEnv` | `bool` | this 是否被当前闭包捕获 |
| `_boxedVars` | `Set<VariableDeclaration>` | 需要 Box 包装的变量 |
| `_currentFunctionParams` | `Set<VariableDeclaration>` | 当前函数参数 |
| `_methodTypeSpecializations` | `Map<String, Map<String, Set<MethodSpecEntry>>>` | 方法级泛型特化 |
