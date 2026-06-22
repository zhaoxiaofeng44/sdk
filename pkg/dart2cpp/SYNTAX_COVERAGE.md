# Dart 语法覆盖对比：原写法 × 静态 Dart × C++ 写法

> 对比 DartRestorer（已完成）与新 C++ 编译器（进行中）对每种语法的转换结果。
> ✅ = 已完整实现 ⚠️ = 部分实现/有缺陷 ❌ = 未实现

---

## 目录

- [1. 表达式](#1-表达式)
- [2. 语句](#2-语句)
- [3. 声明](#3-声明)
- [4. 常量](#4-常量)
- [5. 运行时支持](#5-运行时支持)
- [6. 闭包与异步](#6-闭包与异步)
- [7. 汇总统计](#7-汇总统计)

---

## 1. 表达式

### 1.1 空值操作符 `??`

| | 代码 |
|---|---|
| **Dart 原写法** | `var x = a ?? b;` |
| **Kernel AST（反糖后）** | `Let(tmp = a, Conditional(EqualsNull(tmp), then: b, otherwise: tmp))` |
| **Dart→静态 Dart** ✅ | `var x = (a ?? b);` |
| **Dart→C++** ❌ | 当前输出 IIFE `([&](){ auto tmp = a; return tmp; })()` 丢失 `??` 语义 |

**C++ 应该输出：**
```cpp
auto x = (a).isNull() ? (b) : (a);
// 或：
auto x = dart_null_coalesce(a, b);
```

---

### 1.2 空安全访问 `?.`

| | 代码 |
|---|---|
| **Dart 原写法** | `var x = obj?.name;` |
| **Kernel AST** | `Let(tmp = obj, Conditional(EqualsNull(tmp), then: null, otherwise: tmp.name))` |
| **Dart→静态 Dart** ✅ | `var x = obj?.name;` （非用户类）<br>`var x = (() { final tmp = obj; return tmp == null ? null : tmp.name; })();` （用户类） |
| **Dart→C++** ❌ | 丢失模式识别，直接输出 Let 的 IIFE |

**C++ 应该输出：**
```cpp
auto x = (obj == nullptr) ? AnyPtr() : AnyPtr::fromString(obj->name);
```

---

### 1.3 级联 `..`

| | 代码 |
|---|---|
| **Dart 原写法** | `list..add(1)..add(2)..add(3);` |
| **Kernel AST** | `Let(tmp = list, Block([tmp.add(1), tmp.add(2), tmp.add(3)], tmp))` |
| **Dart→静态 Dart** ✅ | `(list..add(1)..add(2)..add(3));` |
| **Dart→C++** ⚠️ | 输出 IIFE 但 BlockExpression 中语句被丢弃 |

**C++ 应该输出：**
```cpp
([&]() -> auto {
    auto tmp = list;
    tmp->add(1);
    tmp->add(2);
    tmp->add(3);
    return tmp;
})()
```

---

### 1.4 `EqualsNull` / `EqualsCall`

| | 代码 |
|---|---|
| **Dart 原写法** | `if (x == null) { ... }` / `if (a == b) { ... }` |
| **Dart→静态 Dart** ✅ | `(x == null)` / `(a == b)` |
| **Dart→C++** ❌ | 未处理，落入 `/* TODO: runtimeType */` |

**C++ 应该输出：**
```cpp
// EqualsNull:
(x).isNull()
// EqualsCall:
(a) == (b)
```

---

### 1.5 `DynamicGet` / `DynamicSet`

| | 代码 |
|---|---|
| **Dart 原写法** | `obj.field`（obj 为 `dynamic` 类型） |
| **Dart→静态 Dart** ✅ | `obj.field`（普通）<br>`(recv.vptr['set_field'] as void Function(dynamic, dynamic))(recv, val)` （mixin 内） |
| **Dart→C++** ❌ | 未处理 |

**C++ 应该输出：**
```cpp
// DynamicGet — 已知字段:
obj->field
// DynamicGet — vptr getter:
reinterpret_cast<AnyPtr(*)(AnyPtr)>(obj->vptr["get_field"])(AnyPtr::fromVPtr(obj))
```

---

### 1.6 `SuperPropertyGet` / `SuperPropertySet`

| | 代码 |
|---|---|
| **Dart 原写法** | `class Dog extends Animal { foo() { return super.name; } }` |
| **Dart→静态 Dart** ✅ | `Animal_get_name(this_)` （getter）/ `this_.name`（普通字段） |
| **Dart→C++** ❌ | 未处理 |

**C++ 应该输出：**
```cpp
// SuperPropertyGet (getter):
Animal_get_name(AnyPtr::fromVPtr(this_))
// SuperPropertyGet (field):
this_->name
// SuperPropertySet:
this_->name = val
```

---

### 1.7 `InstanceTearOff`

| | 代码 |
|---|---|
| **Dart 原写法** | `var fn = dog.speak;` （方法撕取） |
| **Dart→静态 Dart** ✅ | 生成完整 `ClosureEnv` 类：<br>`ClosureEnv_xxx_new(GC.allocateLocal(ClosureEnv_xxx()), dog)` |
| **Dart→C++** ❌ | 未处理，落入 TODO |

**C++ 应该输出：**
```cpp
// 生成 ClosureEnv struct:
struct ClosureEnv_foo_0 : TypeFunction0<std::string> {
    VPtr* _r{};
    ClosureEnv_foo_0() {}
    void gcMark(int flag) override {
        if (gcFlag == flag) return;
        TypeFunction::gcMark(flag);
        if (_r) _r->gcMark(flag);
    }
};
ClosureEnv_foo_0* ClosureEnv_foo_0_new(ClosureEnv_foo_0* env_, VPtr* _r) {
    env_->_r = _r;
    env_->closureCall = reinterpret_cast<void*>(&ClosureEnv_foo_0_call);
    GC::allocateLocal(env_);
    return env_;
}
std::string ClosureEnv_foo_0_call(AnyPtr env__) {
    auto env = static_cast<ClosureEnv_foo_0*>(env__.toTypeFunction());
    auto fn = reinterpret_cast<std::string(*)(AnyPtr)>(env->_r->vptr["speak"]);
    return fn(AnyPtr::fromVPtr(env->_r));
}
// 使用处：
auto fn = ClosureEnv_foo_0_new(GC::allocateLocal(new ClosureEnv_foo_0()), dog);
```

---

### 1.8 `Rethrow`

| | 代码 |
|---|---|
| **Dart 原写法** | `try { ... } catch (e) { rethrow; }` |
| **Dart→静态 Dart** ✅ | `rethrow;` |
| **Dart→C++** ❌ | 未处理 |

**C++ 应该输出：**
```cpp
throw;
```

---

### 1.9 `LocalFunctionInvocation`

| | 代码 |
|---|---|
| **Dart 原写法** | `void helper() {} void main() { helper(); }` |
| **Dart→静态 Dart** ✅ | `helper();` |
| **Dart→C++** ❌ | 未处理 |

**C++ 应该输出：**
```cpp
helper();
```

---

### 1.10 `SymbolLiteral` / `TypeLiteral`

| | 代码 |
|---|---|
| **Dart 原写法** | `#foo` / `int` (作为 Type 对象) |
| **Dart→静态 Dart** ✅ | `#foo` / `int` |
| **Dart→C++** ❌ | 未处理 |

**C++ 应该输出：**
```cpp
// SymbolLiteral:
std::string("foo")
// TypeLiteral:
std::string("int64_t")
```

---

### 1.11 `MapLiteral`

| | 代码 |
|---|---|
| **Dart 原写法** | `var m = {'a': 1, 'b': 2};` |
| **Dart→静态 Dart** ✅ | `var m = StaticMap<String, int>.of({'a': 1, 'b': 2});` |
| **Dart→C++** ⚠️ | 始终输出 `StaticMap<AnyPtr, AnyPtr>::empty()`，entries 丢失 |

**C++ 应该输出：**
```cpp
auto m = ([]() -> StaticMap<std::string, int64_t>* {
    auto _m = GC::allocateLocal(new StaticMap<std::string, int64_t>());
    _m->set("a", 1);
    _m->set("b", 2);
    return _m;
})();
```

---

### 1.12 `BlockExpression`

| | 代码 |
|---|---|
| **Dart 原写法** | `var x = (a; b; expr);`（`Let` 表达式的 body） |
| **Dart→静态 Dart** ✅ | `(() { stmt1; stmt2; ...; return expr; })()` |
| **Dart→C++** ⚠️ | 只输出值表达式，丢弃块中的语句 |

**C++ 应该输出：**
```cpp
([&]() {
    stmt1;
    stmt2;
    return expr;
})()
```

---

## 2. 语句

### 2.1 `ContinueStatement`

| | 代码 |
|---|---|
| **Dart 原写法** | `for (var i = 0; i < 10; i++) { if (i == 5) continue; }` |
| **Dart→静态 Dart** ❌ | Restorer 也未处理（静默丢弃） |
| **Dart→C++** ❌ | 未处理，落入 TODO |

**C++ 应该输出：**
```cpp
for (int64_t i = 0; i < 10; i++) {
    if (i == 5) continue;
}
```

---

### 2.2 `TryFinally` — finally 块

| | 代码 |
|---|---|
| **Dart 原写法** | `try { foo(); } finally { cleanup(); }` |
| **Dart→静态 Dart** ✅ | `try { foo(); } finally { cleanup(); }` |
| **Dart→C++** ⚠️ | try 体正常输出，**finally 块被丢弃** |

**C++ 应该输出：**
```cpp
try {
    foo();
} catch (...) {
    cleanup();
    throw;
}
cleanup();
// 或使用 RAII / scope guard 模式
```

---

### 2.3 `YieldStatement` (sync*/async*)

| | 代码 |
|---|---|
| **Dart 原写法** | `Iterable<int> count() sync* { yield 1; yield 2; }` |
| **Dart→静态 Dart** ✅ | `yield 1;` / `yield 2;` |
| **Dart→C++** ❌ | 输出注释 `// yield value; // C++20 coroutine not supported` |

**C++ 应该输出（基于回调/状态机）：**
```cpp
StaticList<int64_t>* count() {
    auto _result = GC::allocateLocal(new StaticList<int64_t>());
    _result->add(1);
    _result->add(2);
    return _result;
}
```

---

### 2.4 `EmptyStatement`

| | 代码 |
|---|---|
| **Dart 原写法** | `;`（空语句） |
| **Dart→静态 Dart** ❌ | 静默跳过 |
| **Dart→C++** ❌ | 输出 `/* TODO: ... */` |

**C++ 应该输出：**
```cpp
// (空，不输出任何内容)
```

---

## 3. 声明

### 3.1 Extension 方法

| | 代码 |
|---|---|
| **Dart 原写法** | `extension StrExt on String { String capitalize() { ... } }` |
| **Dart→静态 Dart** ✅ | `String StrExt_capitalize(String this_) { ... }` |
| **Dart→C++** ❌ | 未处理 |

**C++ 应该输出：**
```cpp
std::string StrExt_capitalize(std::string this_) {
    // body
}
```

---

### 3.2 Factory 构造函数

| | 代码 |
|---|---|
| **Dart 原写法** | `factory Point.fromJson(Map j) { return Point(j['x'], j['y']); }` |
| **Dart→静态 Dart** ✅ | `PointValue Point_new_fromJson(params) { body }` |
| **Dart→C++** ❌ | `proc.isFactory` 时直接跳过 |

**C++ 应该输出：**
```cpp
PointValue* Point_new_fromJson(StaticMap<AnyPtr, AnyPtr>* j) {
    // body
}
```

---

### 3.3 `SuperInitializer`

| | 代码 |
|---|---|
| **Dart 原写法** | `class Dog extends Animal { Dog(String n) : super(n); }` |
| **Dart→静态 Dart** ✅ | `Animal_new(this_, n);` |
| **Dart→C++** ⚠️ | 只处理 `FieldInitializer`，`SuperInitializer` 被忽略 |

**C++ 应该输出：**
```cpp
DogValue* Dog_new(DogValue* this__, std::string n) {
    Animal_new(this__, n);    // ← SuperInitializer
    this__->name = n;
    return this__;
}
```

---

### 3.4 Abstract 方法

| | 代码 |
|---|---|
| **Dart 原写法** | `abstract class Shape { double area(); }` |
| **Dart→静态 Dart** ✅ | `dynamic Shape_area(dynamic this_) { throw UnimplementedError('Shape.area is abstract'); }` |
| **Dart→C++** ❌ | 无处理 |

**C++ 应该输出：**
```cpp
double Shape_area(AnyPtr this__) {
    throw DartUnimplementedError("Shape.area is abstract");
}
```

---

### 3.5 Redirecting 构造函数

| | 代码 |
|---|---|
| **Dart 原写法** | `Point.origin() : this(0, 0);` |
| **Dart→静态 Dart** ✅ | `Point_new_origin(this_) => Point_new(this_, 0, 0);` |
| **Dart→C++** ❌ | 未处理 |

**C++ 应该输出：**
```cpp
PointValue* Point_new_origin(PointValue* this__) {
    return Point_new(this__, 0, 0);
}
```

---

### 3.6 类级泛型模板参数

| | 代码 |
|---|---|
| **Dart 原写法** | `class Box<T> { T value; Box(this.value); }` |
| **Dart→静态 Dart** ✅ | `class BoxValue extends VPtr { late T value; }` |
| **Dart→C++** ⚠️ | 输出 `struct BoxValue : VPtr { T value{}; }` 但缺少模板声明 |

**C++ 应该输出：**
```cpp
template<typename T>
struct BoxValue : VPtr {
    T value{};
    BoxValue() { _typeName = "Box"; }
    static const char* staticTypeName() { return "Box"; }
};
```

---

## 4. 常量

### 4.1 `MapConstant`

| | 代码 |
|---|---|
| **Dart 原写法** | `const m = {1: 'a', 2: 'b'};` |
| **Dart→静态 Dart** ✅ | `const {1: 'a', 2: 'b'}` |
| **Dart→C++** ❌ | 输出 `StaticMap<AnyPtr, AnyPtr>::empty()` |

**C++ 应该输出：**
```cpp
([]() -> StaticMap<int64_t, std::string>* {
    auto _m = GC::allocateLocal(new StaticMap<int64_t, std::string>());
    _m->set(1, "a");
    _m->set(2, "b");
    return _m;
})()
```

---

### 4.2 `InstanceConstant`（SDK 类）

| | 代码 |
|---|---|
| **Dart 原写法** | `const Duration(seconds: 5)` / `@override` |
| **Dart→静态 Dart** ✅ | `StaticDuration(seconds: 5)` / `@override` |
| **Dart→C++** ❌ | 输出 `/* TODO: InstanceConstant Duration */` |

**C++ 应该输出：**
```cpp
// Duration:
StaticDuration::seconds(5)
// @override — 注解在 C++ 中无需输出
// (skip)
```

---

### 4.3 `TearOffConstant`

| | 代码 |
|---|---|
| **Dart 原写法** | `const fn = MyClass.myMethod;`（编译期常量） |
| **Dart→静态 Dart** ✅ | `MyClass_myMethod` |
| **Dart→C++** ⚠️ | 尝试动态分发，失败时输出 `/* TODO: TearOffConstant */` |

**C++ 应该输出：**
```cpp
&MyClass_myMethod
```

---

### 4.4 `PartialInstantiationConstant`

| | 代码 |
|---|---|
| **Dart 原写法** | `const fn = genericFunc<int>;`（部分特化） |
| **Dart→静态 Dart** ❌ | 未处理 |
| **Dart→C++** ❌ | 未处理 |

---

## 5. 运行时支持

### 5.1 `StaticList` 高阶方法

| 方法 | 原写法 | 静态 Dart ✅ | C++ ❌ |
|------|--------|-------------|--------|
| `.map()` | `[1,2,3].map((x) => x * 2)` | `list.map((x) => x * 2)` | 缺失 |
| `.where()` | `[1,2,3].where((x) => x > 1)` | `list.where(...)` | 缺失 |
| `.fold()` | `[1,2,3].fold(0, (a, b) => a + b)` | `list.fold(...)` | 缺失 |
| `.sort()` | `list.sort()` | `list.sort()` | 缺失 |
| `.join()` | `[1,2,3].join(', ')` | `list.join(', ')` | 缺失 |
| `.sublist()` | `list.sublist(1, 3)` | `list.sublist(1, 3)` | 缺失 |
| `.any()` | `list.any((x) => x > 0)` | `list.any(...)` | 缺失 |
| `.every()` | `list.every((x) => x > 0)` | `list.every(...)` | 缺失 |
| `.firstWhere()` | `list.firstWhere((x) => x > 0)` | `list.firstWhere(...)` | 缺失 |
| `.reduce()` | `list.reduce((a, b) => a + b)` | `list.reduce(...)` | 缺失 |

**C++ 应该添加的示例：**
```cpp
// map:
template<typename R>
StaticList<R>* map(TypeFunction1<R, T>* fn) {
    auto result = GC::allocateLocal(new StaticList<R>());
    for (int i = 0; i < length(); i++) {
        result->add(fn->call((*this)[i]));
    }
    return result;
}

// where:
StaticList<T>* where(TypeFunction1<bool, T>* fn) { ... }

// join:
std::string join(const std::string& separator) {
    std::ostringstream oss;
    for (int i = 0; i < length(); i++) {
        if (i > 0) oss << separator;
        oss << _toStr((*this)[i]);
    }
    return oss.str();
}
```

### 5.2 `Promise` 链式操作

| 方法 | 原写法 | 静态 Dart ✅ | C++ ❌ |
|------|--------|-------------|--------|
| `.then()` | `future.then((v) => v + 1)` | `promise.then((v) => v + 1)` | 缺失 |
| `.catchError()` | `future.catchError((e) => 0)` | `promise.catchError(...)` | 缺失 |
| `.whenComplete()` | `future.whenComplete(() => ...)` | `promise.whenComplete(...)` | 缺失 |

### 5.3 `StaticStringBuffer` 方法

| 方法 | 原写法 | 静态 Dart ✅ | C++ ❌ |
|------|--------|-------------|--------|
| `.writeln()` | `buf.writeln('hello')` | `buf.writeln('hello')` | 缺失 |
| `.writeAll()` | `buf.writeAll(list)` | `buf.writeAll(list)` | 缺失 |

### 5.4 `StaticRegExp`

| | 代码 |
|---|---|
| **Dart 原写法** | `RegExp(r'\d+').hasMatch('abc123')` |
| **Dart→静态 Dart** ✅ | `StaticRegExp(r'\d+').hasMatch('abc123')` （使用 `dart:core` RegExp） |
| **Dart→C++** ⚠️ | 使用 `std::string::find`（不支持正则） |

**C++ 应该输出：**
```cpp
std::regex(r"\d+"); // 使用 std::regex
```

### 5.5 `TypeFunction` 扩展至 arity 16

| | 代码 |
|---|---|
| **Dart→静态 Dart** ✅ | `TypeFunction0` 到 `TypeFunction16`（17 个） |
| **Dart→C++** ⚠️ | `TypeFunction0` 到 `TypeFunction8`（9 个），缺少 9-16 |

---

## 6. 闭包与异步

### 6.1 闭包体生成（P0 阻塞）

| | 代码 |
|---|---|
| **Dart 原写法** | `var add = (int a, int b) => a + b;` |
| **Dart→静态 Dart** ✅ | 完整生成 `ClosureEnv` 类 + `_call` 函数（含体） |
| **Dart→C++** ⚠️ | struct 和 `_new` 正常生成，**`_call` 函数体是空的** |

**C++ 当前输出：**
```cpp
int64_t ClosureEnv_main_0_call(AnyPtr env__, int64_t a, int64_t b) {
    auto env = static_cast<ClosureEnv_main_0*>(env__.toTypeFunction());
    // TODO: emit closure body           ← ❌ 空
    return 0;                            ← ❌ 硬编码默认值
}
```

**C++ 应该输出：**
```cpp
int64_t ClosureEnv_main_0_call(AnyPtr env__, int64_t a, int64_t b) {
    auto env = static_cast<ClosureEnv_main_0*>(env__.toTypeFunction());
    return a + b;   // ← 实际闭包体
}
```

### 6.2 Async 闭包体生成

| | 代码 |
|---|---|
| **Dart 原写法** | `Future<int> compute(int x) async { return x * 2; }` |
| **Dart→静态 Dart** ✅ | 完整 async ClosureEnv + `_promise.complete(x * 2)` |
| **Dart→C++** ⚠️ | struct 和 `_new` 正常，**`_call` 体是空的** |

**C++ 应该输出：**
```cpp
void ClosureEnv_compute_0_call(ClosureEnv_compute_0* env) {
    env->_promise->complete(AnyPtr::fromInt(env->x->value * 2));
    return;
}
```

### 6.3 闭包泛型参数

| | 代码 |
|---|---|
| **Dart 原写法** | `T identity<T>(T x) { var fn = (T v) => v; return fn(x); }` |
| **Dart→静态 Dart** ✅ | `class ClosureEnv_identity_0<T> extends TypeFunction1<T, T> { ... }` |
| **Dart→C++** ❌ | 闭包不携带泛型模板参数 |

---

## 7. 汇总统计

### 7.1 按类别统计

| 类别 | 总计 | ✅ 完整 | ⚠️ 部分 | ❌ 缺失 |
|------|------|---------|---------|---------|
| 表达式（核心） | 15 | 15 | 0 | 0 |
| 表达式（扩展） | 20 | 5 | 3 | 12 |
| 语句 | 16 | 13 | 2 | 1 |
| 声明 | 15 | 10 | 2 | 3 |
| 常量 | 12 | 7 | 2 | 3 |
| 运行时方法 | 30+ | ~10 | 5 | 15+ |
| 闭包/异步 | 8 | 4 | 3 | 1 |
| **合计** | **~116** | **~64 (55%)** | **~17 (15%)** | **~35 (30%)** |

### 7.2 按优先级分组

#### P0 — 阻塞性（必须修复才能编译常见程序）

| # | 特性 | 影响范围 |
|---|------|----------|
| 1 | **闭包体生成** | 所有含闭包/回调的代码 |
| 2 | **Async 闭包体生成** | 所有 `async` 函数 |
| 3 | **`BlockExpression` 语句丢失** | `let` 表达式的副作用 |

#### P1 — 高频语法（常见代码会用）

| # | 特性 | 影响范围 |
|---|------|----------|
| 4 | `??` 空值合并 | 大量使用 |
| 5 | `?.` 空安全访问 | 大量使用 |
| 6 | `..` 级联 | 中等使用 |
| 7 | `SuperInitializer` | 所有有继承的构造函数 |
| 8 | `TryFinally` finally 块 | 资源清理代码 |
| 9 | `MapLiteral` entries | 所有 map 字面量 |
| 10 | `EqualsNull` / `EqualsCall` | 所有 `==` 比较 |

#### P2 — 中频语法

| # | 特性 | 影响范围 |
|---|------|----------|
| 11 | `InstanceTearOff` | 方法作为参数传递 |
| 12 | `DynamicGet`/`Set` | mixin 中的属性访问 |
| 13 | `SuperPropertyGet`/`Set` | 访问父类属性 |
| 14 | `Rethrow` | 异常处理 |
| 15 | `Factory` 构造函数 | 设计模式 |
| 16 | `Abstract` 方法 | 抽象类 |
| 17 | `Extension` 方法 | 扩展 |
| 18 | `ContinueStatement` | 循环控制 |
| 19 | 类级泛型模板 | 泛型类 |

#### P3 — 低频 / 运行时补全

| # | 特性 | 影响范围 |
|---|------|----------|
| 20 | 集合高阶方法 (`map`/`where`/`fold`/`sort`/`join`...) | 函数式编程 |
| 21 | `Promise.then`/`catchError`/`whenComplete` | 异步链 |
| 22 | `StaticStringBuffer.writeln`/`writeAll` | 字符串构建 |
| 23 | `StaticRegExp` 真正正则 | 字符串匹配 |
| 24 | `TypeFunction9-16` | 高参数闭包 |
| 25 | `YieldStatement` (sync*/async*) | 生成器 |
| 26 | `SymbolLiteral`/`TypeLiteral` | 元编程 |
| 27 | `Record` 类型 | Dart 3 新特性 |
| 28 | `MapConstant` | 常量 map |
| 29 | `TearOffConstant` | 常量函数引用 |
| 30 | `LocalFunctionInvocation` | 局部函数调用 |

### 7.3 测试用例覆盖

| 测试文件 | 状态 | 覆盖特性 |
|----------|------|----------|
| `samples/hello_world.dart` | ✅ 存在 | print、main |
| `samples/class_inheritance.dart` | ✅ 存在 | 类、继承、多态、for-in |
| `samples/closure_capture.dart` | ❌ 缺失 | 闭包、捕获、Box |
| `samples/async_promise.dart` | ❌ 缺失 | async/await、Promise |
| `samples/mixin_lowering.dart` | ❌ 缺失 | mixin、合成中间类 |
| `samples/enum_test.dart` | ❌ 缺失 | enum |
| `samples/generics_test.dart` | ❌ 缺失 | 泛型 |
| `samples/null_safety.dart` | ❌ 缺失 | `??`、`?.`、`late` |
| `samples/collections.dart` | ❌ 缺失 | List/Map/Set 操作 |
| `samples/try_catch.dart` | ❌ 缺失 | 异常处理 |
| `samples/extension_test.dart` | ❌ 缺失 | extension 方法 |

### 7.4 与 Restorer 的功能差距总结

```
Restorer (Dart→Dart):     ████████████████████████████  ~11,000 行  ~95% 覆盖
C++ Compiler (Dart→C++):  ████████████████░░░░░░░░░░░░  ~5,100 行   ~55% 覆盖

已完成（可直接使用）:       ████████████████  64 项
部分完成（需修复）:         ████              17 项
未实现:                     ████████          35 项
```

**核心差距：** 闭包体生成（P0）+ 空值操作符模式识别（P1）+ 集合高阶方法（P3）
