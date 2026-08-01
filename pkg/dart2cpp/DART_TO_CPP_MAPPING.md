# Dart(静态) → C++ 转换对照文档

> 基于 Restorer 的 OOP Lowering 输出（Value对象 + 静态方法 + ClassInfo 虚表），将还原后的静态 Dart 代码映射为 C++ 代码的完整对照表。ClassInfo.dispatch 在 C++ 端等价于 vptr map。

---

## 目录

1. [架构总览](#1-架构总览)
2. [核心类型映射](#2-核心类型映射)
3. [ClassInfo / vptr 虚表](#3-classinfo--vptr-虚表)
4. [AnyPtr 类型擦除](#4-anyptr-类型擦除)
5. [TypeFunction + 闭包系统](#5-typefunction--闭包系统)
6. [Box类型（闭包可变捕获）](#6-box类型闭包可变捕获)
7. [GC标记-清除系统](#7-gc标记-清除系统)
8. [静态集合类](#8-静态集合类)
9. [异步状态机（Promise + Scheduler + smAwait）](#9-异步状态机promise--scheduler--smawait)
10. [异常体系](#10-异常体系)
11. [null语义 + 可空类型](#11-null语义--可空类型)
12. [is / as 运行时类型检查](#12-is--as-运行时类型检查)
13. [enum映射](#13-enum映射)
14. [扩展方法](#14-扩展方法)
15. [语义脱钩包装类型](#15-语义脱钩包装类型)
16. [字符串操作](#16-字符串操作)
17. [运算符映射](#17-运算符映射)
18. [控制流映射](#18-控制流映射)
19. [字段与构造器映射](#19-字段与构造器映射)
20. [mixin委托映射](#20-mixin委托映射)
21. [泛型映射](#21-泛型映射)
22. [综合可行性评估](#22-综合可行性评估)

---

## 1. 架构总览

Restorer已完成 OOP Lowering，将 Dart 类体系降级为：

- **Value对象**：`class XxxValue extends AnyGC { fields }` — 仅存数据字段，无方法体
- **静态方法**：`Xxx_method(AnyGC this__)` — 所有方法转为自由函数，首参数为 `this`（`AnyGC` 对应 C++ `AnyPtr`）
- **ClassInfo 虚表**：每类生成 `XxxClassInfo extends ClassInfo`，字段为精确函数类型（`R Function(AnyGC, ...)?`），另有 `Map<String, Function> dispatch` 供动态派发；根 Value 类覆写 `toString`/`==`/`hashCode` 委托给 ClassInfo
- **闭包展开**：`ClosureEnv_N extends TypeFunctionN` — 每个闭包生成具名类
- **Box装箱**：`IntBox/DoubleBox/BoolBox/ObjectBox` — 闭包可变捕获
- **GC管理**：`AnyGC + GC.allocateLocal/Global` — 标记-清除垃圾回收

C++端完全沿用这套架构，不需要传统C++ OOP（虚函数、继承多态）。

---

## 2. 核心类型映射

### 2.1 基本类型

| 静态 Dart 类型 | C++ 类型 | 说明 |
|---|---|---|
| `int` | `int64_t` | Dart int 是64位，C++用int64_t对齐 |
| `double` | `double` | 直接映射 |
| `bool` | `bool` | 直接映射 |
| `String` | `std::string` | Dart String 是UTF-16，C++ std::string 是UTF-8字节流。初期仅保证ASCII场景正确 |
| `dynamic` | `AnyPtr` | 类型擦除容器（见第4节） |
| `void` | `void` | 直接映射 |
| `Null` / `null` | `AnyPtr::null()` | AnyPtr的NULL_TAG |

### 2.2 集合类型

| 静态 Dart 类型 | C++ 类型 | 说明 |
|---|---|---|
| `StaticList<T>` | `StaticList<T>` | 自定义模板类，基于 `std::vector<T>` |
| `StaticMap<K, V>` | `StaticMap<K, V>` | 自定义模板类，基于 `std::unordered_map<K,V>` |
| `StaticSet<T>` | `StaticSet<T>` | 自定义模板类，基于 `std::unordered_set<T>` |
| `Array<T>` | `Array<T>` | 底层存储，基于 `std::vector<T>` |
| `StaticIterator<T>` | `StaticIterator<T>` | 迭代器包装 |

### 2.3 特殊类型

| 静态 Dart 类型 | C++ 类型 | 说明 |
|---|---|---|
| `ClassInfo` / `AnyGC` | `VPtr` (struct) | 虚表基类；Dart 侧拆分为 `ClassInfo` + `AnyGC`，C++ 侧仍可用 `VPtr` 兼容表示 |
| `AnyGC` | `AnyGC` (struct) | GC基类 |
| `TypeFunction` | `TypeFunction` (struct) | 闭包基类 |
| `TypeFunction0<R>` | `TypeFunction0<R>` | 0参闭包模板 |
| `TypeFunction1<R,T1>` | `TypeFunction1<R,T1>` | 1参闭包模板 |
| `TypeFunctionN<R,T1..Tn>` | `TypeFunctionN<R,T1..Tn>` | N参闭包模板（N=0..16） |
| `IntBox/DoubleBox/BoolBox/StringBox/ObjectBox` | 同名struct | Box装箱类型 |
| `Promise<T>` | `PromiseBase*` | 异步结果容器（统一为AnyPtr） |
| `AsyncStateMachine<T>` | `AsyncStateMachine` (struct) | 异步状态机基类 |

---

## 3. ClassInfo / vptr 虚表

### 3.1 设计原则

Dart 侧使用 `ClassInfo` 子类保存**带类型的函数指针字段**（如 `double Function(AnyGC)? area`），同时维护一个 `Map<String, Function?> dispatch` 用于 `dynamic` 调用查找。`AnyGC` 基类不再桥接 `toString`/`==`/`hashCode`；根 `Value` 类直接覆写这些方法并委托给 `ClassInfo` 对应条目。

C++ 侧仍可用 **匿名指针（`void*`）的 `vptr` map** 来等价表示 `ClassInfo.dispatch`：键相同，值存储为 `void*`，使用时按已知签名 `reinterpret_cast` 调用。不需要统一函数签名。

### 3.2 基类定义

**Dart:**

```dart
class ClassInfo {
  Map<String, Function?> dispatch = {};
  String Function(AnyGC)? toString_;
  bool Function(AnyGC, Object)? operatorEq;
  int Function(AnyGC)? get_hashCode;
  // ... 每类一个子类添加具体方法字段
}

class AnyGC {
  ClassInfo? get classInfo => null;
  // 不再桥接 toString/==/hashCode
}

class ShapeValue extends AnyGC {
  @override
  ClassInfo get classInfo => _shapeClassInfo;

  @override
  String toString() {
    final fn = (classInfo as ShapeClassInfo).toString_;
    if (fn != null) return fn(this);
    return super.toString();
  }

  @override
  bool operator ==(Object other) {
    final fn = (classInfo as ShapeClassInfo).operatorEq;
    if (fn != null) return fn(this, other);
    return identical(this, other);
  }

  @override
  int get hashCode {
    final fn = (classInfo as ShapeClassInfo).get_hashCode;
    if (fn != null) return fn(this);
    return super.hashCode;
  }
}
```

**C++:**

```cpp
struct VPtr : AnyGC {
    std::string _typeName;  // 类型标签，支持 is/as 检查
    std::unordered_map<std::string, void*> vptr;

    VPtr() : _typeName("VPtr") {
        vptr["toString"]     = nullptr;
        vptr["operatorEq"]   = nullptr;
        vptr["get_hashCode"] = nullptr;
    }

    std::string toString() {
        auto fn = vptr["toString"];
        if (fn != nullptr) {
            auto typedFn = reinterpret_cast<std::string(*)(AnyPtr)>(fn);
            return typedFn(AnyPtr::fromVPtr(this));
        }
        return "VPtr@" + std::to_string((uintptr_t)this);
    }

    bool operator==(const VPtr& other) {
        auto fn = vptr["operatorEq"];
        if (fn != nullptr) {
            auto typedFn = reinterpret_cast<bool(*)(AnyPtr, AnyPtr)>(fn);
            return typedFn(AnyPtr::fromVPtr(this),
                           AnyPtr::fromVPtr(const_cast<VPtr*>(&other)));
        }
        return this == &other;
    }

    int64_t getHashCode() {
        auto fn = vptr["get_hashCode"];
        if (fn != nullptr) {
            auto typedFn = reinterpret_cast<int64_t(*)(AnyPtr)>(fn);
            return typedFn(AnyPtr::fromVPtr(this));
        }
        return (int64_t)(uintptr_t)this;
    }

    // 类型转换（支持 as 检查）
    template<typename T>
    T* castTo() {
        if (_typeName != T::staticTypeName()) {
            throw DartException("Type cast error: expected " + T::staticTypeName()
                                + " got " + _typeName);
        }
        return static_cast<T*>(this);
    }
};
```

### 3.3 Value子类定义

**Dart:**

```dart
class ShapeClassInfo extends ClassInfo {
  String Function(AnyGC)? get_name;
  double Function(AnyGC)? area;
  double Function(AnyGC)? perimeter;
}

class ShapeValue extends AnyGC {
  @override
  ClassInfo get classInfo => ClassInfoRegistry.get<ShapeClassInfo>(runtimeType, _initClassInfo);
  static ShapeClassInfo _initClassInfo() {
    final ci = ShapeClassInfo();
    ci.get_name = Shape_get_name;
    ci.dispatch['get_name'] = Shape_get_name;
    ci.area = Shape_area;
    ci.dispatch['area'] = Shape_area;
    ci.perimeter = Shape_perimeter;
    ci.dispatch['perimeter'] = Shape_perimeter;
    ci.toString_ = Shape_toString;
    ci.dispatch['toString_'] = Shape_toString;
    return ci;
  }
}

class CircleClassInfo extends ShapeClassInfo {
  double Function(AnyGC)? get_radius;
  void Function(AnyGC, double)? set_radius;
}

class CircleValue extends ShapeValue {
  late double _radius;
  @override
  ClassInfo get classInfo => ClassInfoRegistry.get<CircleClassInfo>(runtimeType, _initClassInfo);
  static CircleClassInfo _initClassInfo() {
    final ci = CircleClassInfo();
    ci.get_name = Circle_get_name;
    ci.dispatch['get_name'] = Circle_get_name;
    ci.area = Circle_area;
    ci.dispatch['area'] = Circle_area;
    ci.perimeter = Circle_perimeter;
    ci.dispatch['perimeter'] = Circle_perimeter;
    ci.toString_ = Circle_toString;
    ci.dispatch['toString_'] = Circle_toString;
    ci.get_radius = Circle_get_radius;
    ci.dispatch['get_radius'] = Circle_get_radius;
    ci.set_radius = Circle_set_radius;
    ci.dispatch['set_radius'] = Circle_set_radius;
    return ci;
  }
}
```

**C++:**

```cpp
struct ShapeValue : VPtr {
    static const char* staticTypeName() { return "ShapeValue"; }
    ShapeValue() : VPtr() {
        _typeName = "ShapeValue";
        vptr["get_name"]  = reinterpret_cast<void*>(Shape_get_name);
        vptr["area"]      = reinterpret_cast<void*>(Shape_area);
        vptr["perimeter"] = reinterpret_cast<void*>(Shape_perimeter);
        vptr["toString"]  = reinterpret_cast<void*>(Shape_toString);
    }
};

struct CircleValue : ShapeValue {
    double _radius = 0.0;
    static const char* staticTypeName() { return "CircleValue"; }
    CircleValue() {
        _typeName = "CircleValue";
        vptr["get_name"]    = reinterpret_cast<void*>(Circle_get_name);
        vptr["area"]        = reinterpret_cast<void*>(Circle_area);
        vptr["perimeter"]   = reinterpret_cast<void*>(Circle_perimeter);
        vptr["toString"]    = reinterpret_cast<void*>(Circle_toString);
        vptr["get_radius"]  = reinterpret_cast<void*>(Circle_get_radius);
        vptr["set_radius"]  = reinterpret_cast<void*>(Circle_set_radius);
    }
};
```

### 3.4 ClassInfo 调用

**Dart:**

```dart
// 单参数调用
(shape.classInfo as ShapeClassInfo).area!(shape)
// 多参数调用
(this_.classInfo as ComparableClassInfo).compareTo!(this_, other)
// void返回调用
(circle.classInfo as CircleClassInfo).set_radius!(circle, 5.0)
// dynamic 调用（运行时查找 dispatch）
dynamicDispatch(shape, 'area', [shape])
```

**C++:**

```cpp
// 单参数调用
auto areaFn = reinterpret_cast<double(*)(AnyPtr)>(shape.vptr["area"]);
double area = areaFn(AnyPtr::fromVPtr(&shape));

// 多参数调用
auto compareFn = reinterpret_cast<int64_t(*)(AnyPtr, AnyPtr)>(this_.vptr["compareTo"]);
int64_t result = compareFn(AnyPtr::fromVPtr(&this_), AnyPtr::fromAuto(other));

// void返回调用
auto setRadiusFn = reinterpret_cast<void(*)(AnyPtr, double)>(circle.vptr["set_radius"]);
setRadiusFn(AnyPtr::fromVPtr(&circle), 5.0);
```

### 3.5 映射规则汇总

| Dart模式 | C++生成 |
|---|---|
| `ci.method = Xxx_method` 并 `ci.dispatch['method'] = Xxx_method` | `vptr["method"] = reinterpret_cast<void*>(Xxx_method)` |
| `(recv.classInfo as XxxClassInfo).method!(recv)` | `reinterpret_cast<R(*)(AnyPtr)>(vptr["method"])(AnyPtr::fromVPtr(recv))` |
| `(recv.classInfo as XxxClassInfo).method!(recv, arg)` | `reinterpret_cast<R(*)(AnyPtr, TCpp)>(vptr["method"])(AnyPtr::fromVPtr(recv), arg)` |
| `dynamicDispatch(recv, 'method', [args])` | 运行时按 `vptr["method"]` 查找并调用 |
| `ci.method != null` / `ci.dispatch['method'] != null` | `vptr["method"] != nullptr` |

**可行性**：⭐⭐⭐⭐⭐ — Dart 侧直接字段访问为零开销；`dynamicDispatch` 回退到 1 次 map 查找。C++ 侧 `void*` + `reinterpret_cast` 仍是经典手法，与 `ClassInfo.dispatch` map 完全等价。

---

## 4. AnyPtr 类型擦除

### 4.1 设计原则

Dart的 `dynamic` 可以存任意类型值，C++没有等价物。AnyPtr是tagged union，用枚举标签+union存储实现类型擦除。

### 4.2 AnyPtr定义

```cpp
struct AnyPtr {
    enum Tag {
        NULL_TAG, INT, DOUBLE, BOOL, STRING, VPTR, TYPE_FUNCTION, OTHER
    };

    Tag tag;

    union Data {
        int64_t          intVal;
        double           doubleVal;
        bool             boolVal;
        std::string*     stringPtr;     // 指针，避免union内非trivial类型
        VPtr*            vptrPtr;
        TypeFunction*    typeFnPtr;
        AnyGC*           gcPtr;
        void*            rawPtr;
    };

    Data data;

    // ---- 构造 ----
    AnyPtr() : tag(NULL_TAG) { data.rawPtr = nullptr; }

    static AnyPtr null()                            { AnyPtr p; p.tag = NULL_TAG; return p; }
    static AnyPtr fromInt(int64_t v)                { AnyPtr p; p.tag = INT; p.data.intVal = v; return p; }
    static AnyPtr fromDouble(double v)              { AnyPtr p; p.tag = DOUBLE; p.data.doubleVal = v; return p; }
    static AnyPtr fromBool(bool v)                  { AnyPtr p; p.tag = BOOL; p.data.boolVal = v; return p; }
    static AnyPtr fromString(const std::string& v)  { AnyPtr p; p.tag = STRING; p.data.stringPtr = new std::string(v); return p; }
    static AnyPtr fromVPtr(VPtr* v)                 { AnyPtr p; p.tag = VPTR; p.data.vptrPtr = v; return p; }
    static AnyPtr fromTypeFunction(TypeFunction* v) { AnyPtr p; p.tag = TYPE_FUNCTION; p.data.typeFnPtr = v; return p; }
    static AnyPtr fromGC(AnyGC* v)                  { AnyPtr p; p.tag = OTHER; p.data.gcPtr = v; return p; }

    // ---- 类型查询（对应 Dart is） ----
    bool isNull()         const { return tag == NULL_TAG; }
    bool isInt()          const { return tag == INT; }
    bool isDouble()       const { return tag == DOUBLE; }
    bool isBool()         const { return tag == BOOL; }
    bool isString()       const { return tag == STRING; }
    bool isVPtr()         const { return tag == VPTR; }
    bool isTypeFunction() const { return tag == TYPE_FUNCTION; }

    // ---- 类型提取（对应 Dart as） ----
    int64_t       toInt()    const { return data.intVal; }
    double        toDouble() const { return data.doubleVal; }
    bool          toBool()   const { return data.boolVal; }
    std::string   toString() const { return *data.stringPtr; }
    VPtr*         toVPtr()   const { return data.vptrPtr; }
    TypeFunction* toTypeFunction() const { return data.typeFnPtr; }

    // ---- 通用模板提取 ----
    template<typename T> T castTo();  // 编译期特化

    // ---- 比较运算符（用于集合 contains/indexOf 和 == 比较） ----
    bool operator==(const AnyPtr& other) const {
        if (tag != other.tag) return false;
        switch (tag) {
            case NULL_TAG:      return true;
            case INT:           return data.intVal == other.data.intVal;
            case DOUBLE:        return data.doubleVal == other.data.doubleVal;
            case BOOL:          return data.boolVal == other.data.boolVal;
            case STRING:        return *data.stringPtr == *other.data.stringPtr;
            case VPTR:          return data.vptrPtr == other.data.vptrPtr;
            case TYPE_FUNCTION: return data.typeFnPtr == other.data.typeFnPtr;
            case OTHER:         return data.gcPtr == other.data.gcPtr;
            default:            return data.rawPtr == other.data.rawPtr;
        }
    }
    bool operator!=(const AnyPtr& other) const { return !(*this == other); }

    // ---- 通用toString（用于staticPrint和字符串插值） ----
    std::string toStringValue() const {
        switch (tag) {
            case NULL_TAG:      return "null";
            case INT:           return std::to_string(data.intVal);
            case DOUBLE:        return doubleToString(data.doubleVal);
            case BOOL:          return data.boolVal ? "true" : "false";
            case STRING:        return *data.stringPtr;
            case VPTR:          return data.vptrPtr->toString();
            case TYPE_FUNCTION: return "Function";
            default:            return "Object";
        }
    }
};
```

### 4.3 使用场景映射

| Dart `dynamic` 场景 | C++ `AnyPtr` 映射 |
|---|---|
| `Xxx_method(dynamic this__)` | `R Xxx_method(AnyPtr this__)` |
| `ClosureEnv_N_call(dynamic env__, args)` | `R ClosureEnv_N_call(AnyPtr env__, args)` |
| `final dynamic value = 42` | `AnyPtr value = AnyPtr::fromInt(42)` |
| `dynamic makeAdder(int base)` | `AnyPtr makeAdder(int64_t base)` |
| `env__.closureCall(env__, args)` | `env__.toTypeFunction()->closureCall(env__, args)` |

**可行性**：⭐⭐⭐⭐⭐ — tagged union是成熟的类型擦除方案。Restorer中 `dynamic` 出现位置有规律模式，不是随意动态类型滥用。

---

## 5. TypeFunction + 闭包系统

### 5.1 TypeFunction基类族

**Dart:**

```dart
abstract class TypeFunction extends AnyGC {
  TypeFunction();
  late dynamic closureCall;
}

abstract class TypeFunction0<R> extends TypeFunction {
  TypeFunction0();
  R call();
}

abstract class TypeFunction1<R, T1> extends TypeFunction {
  TypeFunction1();
  R call(T1 a1);
}
// ... TypeFunction2..16
```

**C++:**

```cpp
struct TypeFunction : AnyGC {
    void* closureCall = nullptr;  // 匿名函数指针，使用时按签名强制转换
};

template<typename R>
struct TypeFunction0 : TypeFunction {
    AnyPtr call() {
        auto fn = reinterpret_cast<AnyPtr(*)(AnyPtr)>(closureCall);
        return fn(AnyPtr::fromTypeFunction(this));
    }
};

template<typename R, typename T1>
struct TypeFunction1 : TypeFunction {
    AnyPtr call(AnyPtr a1) {
        auto fn = reinterpret_cast<AnyPtr(*)(AnyPtr, AnyPtr)>(closureCall);
        return fn(AnyPtr::fromTypeFunction(this), a1);
    }
};

// TypeFunction2<R,T1,T2> .. TypeFunction16<R,T1..T16> 同理展开
```

### 5.2 闭包类定义

**Dart:**

```dart
class ClosureEnv_makeAdder_3 extends TypeFunction1<int, int> {
  late IntBox base;
  ClosureEnv_makeAdder_3();
  @override
  int call(int x) => closureCall(this, x);
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
    if (base is AnyGC) (base as AnyGC).gcMark(flag);
  }
}
```

**C++:**

```cpp
struct ClosureEnv_makeAdder_3 : TypeFunction1<int64_t, int64_t> {
    IntBox* base;

    void gcMark(int flag) override {
        if (gcFlag == flag) return;
        TypeFunction::gcMark(flag);
        if (base) base->gcMark(flag);
    }
};
```

### 5.3 闭包构造函数

**Dart:**

```dart
ClosureEnv_makeAdder_3 ClosureEnv_makeAdder_3_new(
    ClosureEnv_makeAdder_3 env_, IntBox base) {
  env_.closureCall = ClosureEnv_makeAdder_3_call;
  env_.base = base;
  return env_;
}
```

**C++:**

```cpp
ClosureEnv_makeAdder_3* ClosureEnv_makeAdder_3_new(
    ClosureEnv_makeAdder_3* env_, IntBox* base) {
    env_->closureCall = reinterpret_cast<void*>(ClosureEnv_makeAdder_3_call);
    env_->base = base;
    return env_;
}
```

### 5.4 闭包执行函数

**Dart:**

```dart
int ClosureEnv_makeAdder_3_call(dynamic env__, int x) {
  final env = env__ as ClosureEnv_makeAdder_3;
  return (env.base.value + x);
}
```

**C++:**

```cpp
int64_t ClosureEnv_makeAdder_3_call(AnyPtr env__, int64_t x) {
    ClosureEnv_makeAdder_3* env = env__.toTypeFunction()->castTo<ClosureEnv_makeAdder_3>();
    return env->base->value + x;
}
```

### 5.5 闭包使用

**Dart:**

```dart
dynamic add10 = makeAdder(10);
add10.closureCall(add10, 5);  // => 15
predicate.closureCall(predicate, item);
```

**C++:**

```cpp
AnyPtr add10 = makeAdder(10);
// 通过 TypeFunction::call 间接调用
add10.toTypeFunction()->call(AnyPtr::fromInt(5));  // => AnyPtr::fromInt(15)

// 或直接调用闭包执行函数（编译器已知具体类型时更高效）
ClosureEnv_makeAdder_3_call(add10, 5);
```

### 5.6 异步闭包模式（非TypeFunction子类）

**Dart:**

```dart
class ClosureEnv_fetchData_4 {
  StringBox url;
  Promise<String> _promise;
  ClosureEnv_fetchData_4(String url) : _promise = Promise<String>(), url = StringBox(url);
  void call() => ClosureEnv_fetchData_4_call(this);
}
void ClosureEnv_fetchData_4_call(ClosureEnv_fetchData_4 env) {
  smAwait(promiseDelayed<dynamic>(StaticDuration(milliseconds: 10)));
  env._promise.complete('data from ${env.url.value}');
}
```

**C++:**

```cpp
struct ClosureEnv_fetchData_4 : AnyGC {
    StringBox* url;
    PromiseBase* _promise;

    ClosureEnv_fetchData_4(const std::string& url_) {
        _promise = new PromiseBase();
        url = new StringBox(url_);
        GC::allocateLocal(this);
    }

    void call() { ClosureEnv_fetchData_4_call(this); }

    void gcMark(int flag) override {
        if (gcFlag == flag) return;
        AnyGC::gcMark(flag);
        if (url) url->gcMark(flag);
    }
};

void ClosureEnv_fetchData_4_call(ClosureEnv_fetchData_4* env) {
    smAwait<AnyPtr>(promiseDelayed(10));
    env->_promise->complete(AnyPtr::fromString("data from " + env->url->value));
}
```

**映射规则**：异步闭包中的 `setStartCallback(env.call)` → `promise->setStartCallback([env]() { env->call(); })`。

**可行性**：⭐⭐⭐⭐⭐ — 直接1:1映射。每个闭包生成3个C++实体（struct + new函数 + call函数），模式固定。

---

## 6. Box类型（闭包可变捕获）

### 6.1 定义映射

**Dart:**

```dart
class IntBox extends AnyGC {
  int value;
  IntBox(this.value) { GC.allocateLocal(this); }
}
class DoubleBox extends AnyGC {
  double value;
  DoubleBox(this.value) { GC.allocateLocal(this); }
}
class BoolBox extends AnyGC {
  bool value;
  BoolBox(this.value) { GC.allocateLocal(this); }
}
class StringBox extends AnyGC {
  String value;
  StringBox(this.value) { GC.allocateLocal(this); }
}
class ObjectBox<T> extends AnyGC {
  T value;
  ObjectBox(this.value) { GC.allocateLocal(this); }
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
    final v = value;
    if (v is AnyGC) (v as AnyGC).gcMark(flag);
  }
}
```

**C++:**

```cpp
struct IntBox : AnyGC {
    int64_t value;
    IntBox(int64_t v) : value(v) { GC::allocateLocal(this); }
};

struct DoubleBox : AnyGC {
    double value;
    DoubleBox(double v) : value(v) { GC::allocateLocal(this); }
};

struct BoolBox : AnyGC {
    bool value;
    BoolBox(bool v) : value(v) { GC::allocateLocal(this); }
};

struct StringBox : AnyGC {
    std::string value;
    StringBox(const std::string& v) : value(v) { GC::allocateLocal(this); }
};

struct ObjectBox : AnyGC {    // 统一为 AnyPtr（非泛型）
    AnyPtr value;
    ObjectBox(AnyPtr v) : value(v) { GC::allocateLocal(this); }

    void gcMark(int flag) override {
        if (gcFlag == flag) return;
        AnyGC::gcMark(flag);
        if (value.isVPtr()) value.toVPtr()->gcMark(flag);
        if (value.isTypeFunction()) value.toTypeFunction()->gcMark(flag);
    }
};
```

### 6.2 使用映射

**Dart:**

```dart
IntBox counter = IntBox(0);
env.counter.value = (env.counter.value + 1);
ObjectBox<T> item = ObjectBox<T>(item_raw);
```

**C++:**

```cpp
IntBox* counter = GC::allocateLocal(new IntBox(0));
env->counter->value = env->counter->value + 1;
ObjectBox* item = GC::allocateLocal(new ObjectBox(AnyPtr::fromAuto(item_raw)));
```

**可行性**：⭐⭐⭐⭐⭐ — 最简单的组件，直接映射。

---

## 7. GC标记-清除系统

### 7.1 AnyGC基类

**Dart:**

```dart
abstract class AnyGC {
  int gcFlag = 0;
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    gcFlag = flag;
  }
}
```

**C++:**

```cpp
struct AnyGC {
    int gcFlag = 0;

    virtual void gcMark(int flag) {
        if (gcFlag == flag) return;
        gcFlag = flag;
    }

    virtual ~AnyGC() = default;  // 支持delete回收
};
```

### 7.2 GC类

**Dart:**

```dart
class GC {
  static int _currentFlag = 0;
  static final List<AnyGC> _objects = [];
  static final List<AnyGC> _roots = [];
  static final Set<AnyGC> _registered = {};

  static T allocateLocal<T extends AnyGC>(T object) {
    if (_registered.add(object)) { _objects.add(object); }
    return object;
  }

  static T allocateGlobal<T extends AnyGC>(T object) {
    if (_registered.add(object)) { _objects.add(object); }
    if (!_roots.contains(object)) { _roots.add(object); }
    return object;
  }

  static int collect() {
    _currentFlag++;
    final flag = _currentFlag;
    for (final root in _roots) { root.gcMark(flag); }
    final beforeCount = _objects.length;
    _objects.removeWhere((obj) => obj.gcFlag != flag);
    _registered.removeWhere((obj) => obj.gcFlag != flag);
    _roots.removeWhere((obj) => obj.gcFlag != flag);
    return beforeCount - _objects.length;
  }
}
```

**C++:**

```cpp
class GC {
    static int _currentFlag;
    static std::vector<AnyGC*> _objects;
    static std::vector<AnyGC*> _roots;
    static std::unordered_set<AnyGC*> _registered;

public:
    template<typename T>
    static T* allocateLocal(T* obj) {
        if (_registered.insert(obj).second) {
            _objects.push_back(obj);
        }
        return obj;
    }

    template<typename T>
    static T* allocateGlobal(T* obj) {
        allocateLocal(obj);
        _roots.push_back(obj);
        return obj;
    }

    static int collect() {
        _currentFlag++;
        int flag = _currentFlag;

        // 标记阶段
        for (auto root : _roots) root->gcMark(flag);

        // 清除阶段（C++需要显式delete，与Dart版不同）
        int beforeCount = _objects.size();
        auto it = _objects.begin();
        while (it != _objects.end()) {
            if ((*it)->gcFlag != flag) {
                _registered.erase(*it);
                delete *it;  // C++需要显式释放内存
                it = _objects.erase(it);
            } else {
                ++it;
            }
        }

        // 同步清理roots
        _roots.erase(
            std::remove_if(_roots.begin(), _roots.end(),
                [flag](AnyGC* obj) { return obj->gcFlag != flag; }),
            _roots.end());

        return beforeCount - _objects.size();
    }

    // 从root集合中移除（不删除对象本身，仅取消root标记）
    static void removeRoot(AnyGC* obj) {
        _roots.erase(
            std::remove(_roots.begin(), _roots.end(), obj),
            _roots.end());
    }

    // 获取当前管理的对象总数
    static int objectCount() { return _objects.size(); }

    // 获取当前root数量
    static int rootCount() { return _roots.size(); }

    static void reset() {
        for (auto obj : _objects) delete obj;
        _objects.clear();
        _roots.clear();
        _registered.clear();
        _currentFlag = 0;
    }
};
```

### 7.3 使用映射

**Dart:**

```dart
GC.allocateLocal(X_new(XValue(), args))
GC.allocateGlobal(staticVar)
GC.collect()
```

**C++:**

```cpp
GC::allocateLocal(X_new(new XValue(), args))
GC::allocateGlobal(staticVar)
GC::collect()
```

### 7.4 gcMark生成规则

**Dart:**

```dart
@override
void gcMark(int flag) {
  if (gcFlag == flag) return;
  super.gcMark(flag);
  if (first is AnyGC) (first as AnyGC).gcMark(flag);
  if (second is AnyGC) (second as AnyGC).gcMark(flag);
}
```

**C++:**

```cpp
void gcMark(int flag) override {
    if (gcFlag == flag) return;
    VPtr::gcMark(flag);  // super
    // 递归标记GC字段
    if (first.isVPtr()) first.toVPtr()->gcMark(flag);
    if (second.isVPtr()) second.toVPtr()->gcMark(flag);
}
```

**可行性**：⭐⭐⭐⭐⭐ — 直接1:1映射Dart版标记-清除GC。唯一差异是C++清除阶段需显式 `delete`。

---

## 8. 静态集合类

### 8.1 Array\<T\>

**Dart:**

```dart
class Array<T> {
  final List<T> _storage;
  int _length;
  Array(int size, {T? fill});
  Array.from(Iterable<T> elements);
  Array.empty();
  int get length;
  T operator [](int index);       // 越界抛 DartRangeError
  void operator []=(int index, T value);  // 越界抛 DartRangeError
  void add(T element);
  void insert(int index, T element);
  T removeAt(int index);
  bool remove(T element);
  int indexOf(T element);
  bool contains(T element);
  void clear();
  Iterable<T> get iterable;
}
```

**C++:**

```cpp
template<typename T>
struct Array {
    std::vector<T> _storage;
    int64_t _length = 0;

    // 构造函数
    Array(int64_t size, T fill = T()) : _storage(size, fill), _length(size) {}
    Array(std::initializer_list<T> init) : _storage(init), _length(init.size()) {}
    Array() : _storage() {}

    // 属性
    int64_t length() const { return _length; }

    // 索引访问（越界抛 DartRangeError）
    T& operator[](int64_t index) {
        if (index < 0 || index >= _length) throw DartRangeError("Index out of range");
        return _storage[index];
    }
    void set(int64_t index, const T& value) {
        if (index < 0 || index >= _length) throw DartRangeError("Index out of range");
        _storage[index] = value;
    }

    // 修改
    void add(const T& element) { _storage.push_back(element); _length++; }
    void insert(int64_t index, const T& element) { _storage.insert(_storage.begin() + index, element); _length++; }
    T removeAt(int64_t index) {
        if (index < 0 || index >= _length) throw DartRangeError("Index out of range");
        T removed = _storage[index];
        _storage.erase(_storage.begin() + index);
        _length--;
        return removed;
    }
    bool remove(const T& element) {
        int64_t idx = indexOf(element);
        if (idx == -1) return false;
        removeAt(idx);
        return true;
    }
    void clear() { _storage.clear(); _length = 0; }

    // 查询
    int64_t indexOf(const T& element) const {
        for (int64_t i = 0; i < _length; i++) {
            if (_storage[i] == element) return i;
        }
        return -1;
    }
    bool contains(const T& element) const { return indexOf(element) != -1; }
};
```

### 8.2 StaticList\<T\>

**Dart:** 基于 `Array<T>` 内部存储，提供完整列表操作。约60个方法。

**C++:** 基于 `Array<T>` 逐一映射，内部存储为双Array（与Dart版一致）。

```cpp
template<typename T>
struct StaticList {
    Array<T> _data;

    // ---- 构造函数 ----
    StaticList() : _data() {}
    StaticList(std::initializer_list<T> init) : _data(init) {}
    StaticList(int64_t length, T fill) : _data(length, fill) {}
    StaticList(const StaticList<T>& other) : _data(other._data) {}

    // ---- 核心属性 ----
    int64_t length() const { return _data.length(); }
    bool isEmpty() const { return _data.length() == 0; }
    bool isNotEmpty() const { return _data.length() > 0; }
    T get first() { if (isEmpty()) throw DartStateError("No element"); return _data[0]; }
    T get last() { if (isEmpty()) throw DartStateError("No element"); return _data[_data.length() - 1]; }
    T get single() { if (_data.length() != 1) throw DartStateError("Not single element"); return _data[0]; }

    // ---- 索引访问 ----
    T& operator[](int64_t i) { return _data[i]; }
    void set(int64_t i, const T& v) { _data.set(i, v); }

    // ---- 修改操作 ----
    void add(const T& v) { _data.add(v); }
    void addAll(const StaticList<T>& elements) { for (int64_t i = 0; i < elements.length(); i++) _data.add(elements[i]); }
    void insert(int64_t index, const T& v) { _data.insert(index, v); }
    void insertAll(int64_t index, const StaticList<T>& elements) {
        for (int64_t i = 0; i < elements.length(); i++) _data.insert(index + i, elements[i]);
    }
    T removeAt(int64_t index) { return _data.removeAt(index); }
    bool remove(const T& v) { return _data.remove(v); }
    void removeLast() { if (isEmpty()) throw DartRangeError("Cannot removeLast on empty list"); _data.removeAt(_data.length() - 1); }
    void removeWhere(std::function<bool(const T&)> test) {
        for (int64_t i = _data.length() - 1; i >= 0; i--) {
            if (test(_data[i])) _data.removeAt(i);
        }
    }
    void retainWhere(std::function<bool(const T&)> test) {
        for (int64_t i = _data.length() - 1; i >= 0; i--) {
            if (!test(_data[i])) _data.removeAt(i);
        }
    }
    void clear() { _data.clear(); }

    // ---- 查询操作 ----
    bool contains(const T& v) const { return _data.contains(v); }
    int64_t indexOf(const T& v, int64_t start = 0) const {
        for (int64_t i = start; i < _data.length(); i++) {
            if (_data[i] == v) return i;
        }
        return -1;
    }
    int64_t lastIndexOf(const T& v, int64_t end = -1) const {
        int64_t endIdx = (end == -1) ? _data.length() - 1 : end;
        for (int64_t i = endIdx; i >= 0; i--) {
            if (_data[i] == v) return i;
        }
        return -1;
    }
    int64_t indexWhere(std::function<bool(const T&)> test, int64_t start = 0) const {
        for (int64_t i = start; i < _data.length(); i++) {
            if (test(_data[i])) return i;
        }
        return -1;
    }
    T elementAt(int64_t index) { return _data[index]; }

    // ---- 迭代 / 函数式 ----
    void forEach(std::function<void(const T&)> action) {
        for (int64_t i = 0; i < _data.length(); i++) action(_data[i]);
    }

    template<typename R>
    StaticList<R> map(std::function<R(const T&)> convert) {
        StaticList<R> result;
        for (int64_t i = 0; i < _data.length(); i++) result.add(convert(_data[i]));
        return result;
    }

    StaticList<T> where(std::function<bool(const T&)> test) {
        StaticList<T> result;
        for (int64_t i = 0; i < _data.length(); i++) {
            if (test(_data[i])) result.add(_data[i]);
        }
        return result;
    }

    template<typename R>
    StaticList<R> whereType() {
        StaticList<R> result;
        for (int64_t i = 0; i < _data.length(); i++) {
            // 对AnyPtr场景用tag检查；对具体类型用typeid
            result.add(_data[i]);  // 编译器生成时已知类型
        }
        return result;
    }

    template<typename R>
    StaticList<R> expand(std::function<StaticList<R>(const T&)> convert) {
        StaticList<R> result;
        for (int64_t i = 0; i < _data.length(); i++) {
            auto expanded = convert(_data[i]);
            result.addAll(expanded);
        }
        return result;
    }

    T reduce(std::function<T(T, T)> combine) {
        if (isEmpty()) throw DartStateError("No element");
        T value = _data[0];
        for (int64_t i = 1; i < _data.length(); i++) value = combine(value, _data[i]);
        return value;
    }

    template<typename R>
    R fold(R initialValue, std::function<R(R, T)> combine) {
        R value = initialValue;
        for (int64_t i = 0; i < _data.length(); i++) value = combine(value, _data[i]);
        return value;
    }

    bool any(std::function<bool(const T&)> test) {
        for (int64_t i = 0; i < _data.length(); i++) { if (test(_data[i])) return true; }
        return false;
    }
    bool every(std::function<bool(const T&)> test) {
        for (int64_t i = 0; i < _data.length(); i++) { if (!test(_data[i])) return false; }
        return true;
    }

    T firstWhere(std::function<bool(const T&)> test, std::function<T()> orElse = nullptr) {
        for (int64_t i = 0; i < _data.length(); i++) { if (test(_data[i])) return _data[i]; }
        if (orElse) return orElse();
        throw DartStateError("No element");
    }
    T lastWhere(std::function<bool(const T&)> test, std::function<T()> orElse = nullptr) {
        for (int64_t i = _data.length() - 1; i >= 0; i--) { if (test(_data[i])) return _data[i]; }
        if (orElse) return orElse();
        throw DartStateError("No element");
    }

    // ---- 子列表 / 变换 ----
    StaticList<T> take(int64_t count) {
        StaticList<T> result;
        int64_t end = (count < _data.length()) ? count : _data.length();
        for (int64_t i = 0; i < end; i++) result.add(_data[i]);
        return result;
    }
    StaticList<T> skip(int64_t count) {
        StaticList<T> result;
        for (int64_t i = count; i < _data.length(); i++) result.add(_data[i]);
        return result;
    }
    StaticList<T> sublist(int64_t start, int64_t end = -1) {
        int64_t actualEnd = (end == -1) ? _data.length() : end;
        StaticList<T> result;
        for (int64_t i = start; i < actualEnd; i++) result.add(_data[i]);
        return result;
    }
    StaticList<T> toStaticList() { return StaticList<T>(*this); }
    StaticSet<T> toStaticSet();

    template<typename R>
    StaticList<R> cast() {
        StaticList<R> result;
        for (int64_t i = 0; i < _data.length(); i++) result.add(static_cast<R>(_data[i]));
        return result;
    }

    StaticList<T> get reversed() {
        StaticList<T> result;
        for (int64_t i = _data.length() - 1; i >= 0; i--) result.add(_data[i]);
        return result;
    }

    StaticList<T> operator+(const StaticList<T>& other) {
        StaticList<T> result(*this);
        result.addAll(other);
        return result;
    }

    // ---- 排序 ----
    void sort(std::function<int64_t(T, T)> compare = nullptr) {
        if (compare) std::sort(_data._storage.begin(), _data._storage.end(),
            [&compare](const T& a, const T& b) { return compare(a, b) < 0; });
        else std::sort(_data._storage.begin(), _data._storage.end());
    }

    // ---- Map辅助 ----
    StaticMap<int64_t, T> asMap() {
        StaticMap<int64_t, T> result;
        for (int64_t i = 0; i < _data.length(); i++) result[i] = _data[i];
        return result;
    }

    // ---- 字符串 ----
    std::string join(const std::string& sep = "") {
        if (isEmpty()) return "";
        std::string result = anyToString(AnyPtr::fromAuto(_data[0]));
        for (int64_t i = 1; i < _data.length(); i++) {
            result += sep + anyToString(AnyPtr::fromAuto(_data[i]));
        }
        return result;
    }
    std::string toString() { return "[" + join(", ") + "]"; }
};
```

### 8.3 StaticMap\<K, V\>

**设计**：内部基于 `Array<K> + Array<V>` 双数组存储（与Dart版完全一致），而非 `std::unordered_map`。这是因为Restorer要求所有集合内部存储基于Array，且需要保持键值对的插入顺序和索引一致性。

```cpp
template<typename K, typename V>
struct StaticMap {
    Array<K> _keys;
    Array<V> _values;

    // ---- 构造函数 ----
    StaticMap() : _keys(), _values() {}
    StaticMap(const StaticMap<K, V>& other) : _keys(other._keys), _values(other._values) {}
    StaticMap(std::initializer_list<std::pair<K, V>> init) : _keys(), _values() {
        for (auto& p : init) { _keys.add(p.first); _values.add(p.second); }
    }
    StaticMap fromIterables(const StaticList<K>& keys, const StaticList<V>& values) {
        StaticMap<K, V> result;
        for (int64_t i = 0; i < keys.length(); i++) { result._keys.add(keys[i]); result._values.add(values[i]); }
        return result;
    }

    // ---- 核心属性 ----
    int64_t length() const { return _keys.length(); }
    bool isEmpty() const { return _keys.length() == 0; }
    bool isNotEmpty() const { return _keys.length() > 0; }

    // ---- 访问 ----
    V* operator[](const K& key) {
        int64_t idx = _keys.indexOf(key);
        if (idx == -1) { _keys.add(key); _values.add(V()); idx = _keys.length() - 1; }
        return &_values[idx];
    }
    V getOrNull(const K& key) {
        int64_t idx = _keys.indexOf(key);
        return (idx == -1) ? AnyPtr::null() : _values[idx];
    }
    bool containsKey(const K& key) const { return _keys.indexOf(key) != -1; }
    bool containsValue(const V& value) const { return _values.indexOf(value) != -1; }

    // ---- 集合视图 ----
    StaticList<K> keys() const { return StaticList<K>(_keys); }
    StaticList<V> values() const { return StaticList<V>(_values); }
    StaticList<StaticMapEntry<K, V>> entries() const {
        StaticList<StaticMapEntry<K, V>> result;
        for (int64_t i = 0; i < _keys.length(); i++) result.add(StaticMapEntry<K, V>(_keys[i], _values[i]));
        return result;
    }

    // ---- 修改 ----
    void set(const K& key, const V& value) {
        int64_t idx = _keys.indexOf(key);
        if (idx != -1) _values.set(idx, value);
        else { _keys.add(key); _values.add(value); }
    }
    V remove(const K& key) {
        int64_t idx = _keys.indexOf(key);
        if (idx == -1) return AnyPtr::null();
        _keys.removeAt(idx);
        return _values.removeAt(idx);
    }
    void removeWhere(std::function<bool(K, V)> test) {
        for (int64_t i = _keys.length() - 1; i >= 0; i--) {
            if (test(_keys[i], _values[i])) { _keys.removeAt(i); _values.removeAt(i); }
        }
    }
    void clear() { _keys.clear(); _values.clear(); }
    V putIfAbsent(const K& key, std::function<V()> ifAbsent) {
        int64_t idx = _keys.indexOf(key);
        if (idx != -1) return _values[idx];
        V value = ifAbsent();
        _keys.add(key); _values.add(value);
        return value;
    }
    V update(const K& key, std::function<V(V)> updateFn, std::function<V()> ifAbsent = nullptr) {
        int64_t idx = _keys.indexOf(key);
        if (idx != -1) { V newVal = updateFn(_values[idx]); _values.set(idx, newVal); return newVal; }
        if (ifAbsent) { V newVal = ifAbsent(); _keys.add(key); _values.add(newVal); return newVal; }
        throw DartArgumentError("Key not found");
    }
    void updateAll(std::function<V(K, V)> updateFn) {
        for (int64_t i = 0; i < _keys.length(); i++) _values.set(i, updateFn(_keys[i], _values[i]));
    }
    void addAll(const StaticMap<K, V>& other) {
        for (int64_t i = 0; i < other._keys.length(); i++) set(other._keys[i], other._values[i]);
    }
    void addEntries(const StaticList<StaticMapEntry<K, V>>& newEntries) {
        for (int64_t i = 0; i < newEntries.length(); i++) set(newEntries[i].key, newEntries[i].value);
    }

    // ---- 函数式 ----
    template<typename K2, typename V2>
    StaticMap<K2, V2> map(std::function<StaticMapEntry<K2, V2>(K, V)> convert) {
        StaticMap<K2, V2> result;
        for (int64_t i = 0; i < _keys.length(); i++) {
            auto entry = convert(_keys[i], _values[i]);
            result.set(entry.key, entry.value);
        }
        return result;
    }
    void forEach(std::function<void(K, V)> action) {
        for (int64_t i = 0; i < _keys.length(); i++) action(_keys[i], _values[i]);
    }

    template<typename RK, typename RV>
    StaticMap<RK, RV> cast() {
        StaticMap<RK, RV> result;
        for (int64_t i = 0; i < _keys.length(); i++) result.set(static_cast<RK>(_keys[i]), static_cast<RV>(_values[i]));
        return result;
    }

    // ---- 字符串 ----
    std::string toString() {
        if (isEmpty()) return "{}";
        std::string result = "{";
        for (int64_t i = 0; i < _keys.length(); i++) {
            if (i > 0) result += ", ";
            result += anyToString(AnyPtr::fromAuto(_keys[i])) + ": " + anyToString(AnyPtr::fromAuto(_values[i]));
        }
        return result + "}";
    }
};
```

### 8.4 StaticMapEntry\<K, V\>

**Dart:** 替代原生 `MapEntry`（MapEntry是final class无法继承）。

**C++:**

```cpp
template<typename K, typename V>
struct StaticMapEntry {
    K key;
    V value;

    StaticMapEntry(K k, V v) : key(k), value(v) {}

    std::string toString() {
        return "StaticMapEntry(" + anyToString(AnyPtr::fromAuto(key)) + ": " + anyToString(AnyPtr::fromAuto(value)) + ")";
    }

    bool operator==(const StaticMapEntry<K, V>& other) const {
        return key == other.key && value == other.value;
    }
    int64_t hashCode() const {
        return std::hash<K>()(key) ^ std::hash<V>()(value);
    }
};
```

### 8.5 StaticSet\<T\>

**设计**：内部基于 `Array<T>` 存储（与Dart版一致），而非 `std::unordered_set`。add时先检查contains保证唯一性。

```cpp
template<typename T>
struct StaticSet {
    Array<T> _data;

    // ---- 构造函数 ----
    StaticSet() : _data() {}
    StaticSet(std::initializer_list<T> init) : _data() {
        for (auto& v : init) add(v);
    }

    // ---- 核心属性 ----
    int64_t length() const { return _data.length(); }
    bool isEmpty() const { return _data.length() == 0; }
    bool isNotEmpty() const { return _data.length() > 0; }

    // ---- 修改 ----
    bool add(const T& v) {
        if (_data.contains(v)) return false;
        _data.add(v);
        return true;
    }
    void addAll(const StaticList<T>& elements) { for (int64_t i = 0; i < elements.length(); i++) add(elements[i]); }
    bool remove(const T& v) { return _data.remove(v); }
    void removeWhere(std::function<bool(const T&)> test) {
        for (int64_t i = _data.length() - 1; i >= 0; i--) { if (test(_data[i])) _data.removeAt(i); }
    }
    void retainWhere(std::function<bool(const T&)> test) {
        for (int64_t i = _data.length() - 1; i >= 0; i--) { if (!test(_data[i])) _data.removeAt(i); }
    }
    void clear() { _data.clear(); }

    // ---- 查询 ----
    bool contains(const T& v) const { return _data.contains(v); }
    T* lookup(const T& v) {
        int64_t idx = _data.indexOf(v);
        return (idx == -1) ? nullptr : &_data[idx];
    }

    // ---- 迭代 / 函数式 ----
    void forEach(std::function<void(const T&)> action) { for (int64_t i = 0; i < _data.length(); i++) action(_data[i]); }
    template<typename R> StaticList<R> map(std::function<R(const T&)> convert) {
        StaticList<R> result;
        for (int64_t i = 0; i < _data.length(); i++) result.add(convert(_data[i]));
        return result;
    }
    StaticSet<T> where(std::function<bool(const T&)> test) {
        StaticSet<T> result;
        for (int64_t i = 0; i < _data.length(); i++) { if (test(_data[i])) result.add(_data[i]); }
        return result;
    }
    bool any(std::function<bool(const T&)> test) { for (int64_t i = 0; i < _data.length(); i++) { if (test(_data[i])) return true; } return false; }
    bool every(std::function<bool(const T&)> test) { for (int64_t i = 0; i < _data.length(); i++) { if (!test(_data[i])) return false; } return true; }
    T reduce(std::function<T(T, T)> combine) {
        if (isEmpty()) throw DartStateError("No element");
        T value = _data[0];
        for (int64_t i = 1; i < _data.length(); i++) value = combine(value, _data[i]);
        return value;
    }
    template<typename R> R fold(R initial, std::function<R(R, T)> combine) {
        R value = initial;
        for (int64_t i = 0; i < _data.length(); i++) value = combine(value, _data[i]);
        return value;
    }

    // ---- 集合操作 ----
    StaticSet<T> union_(const StaticSet<T>& other) {
        StaticSet<T> result(*this);
        for (int64_t i = 0; i < other._data.length(); i++) result.add(other._data[i]);
        return result;
    }
    StaticSet<T> intersection(const StaticSet<T>& other) {
        StaticSet<T> result;
        for (int64_t i = 0; i < _data.length(); i++) { if (other.contains(_data[i])) result.add(_data[i]); }
        return result;
    }
    StaticSet<T> difference(const StaticSet<T>& other) {
        StaticSet<T> result;
        for (int64_t i = 0; i < _data.length(); i++) { if (!other.contains(_data[i])) result.add(_data[i]); }
        return result;
    }

    // ---- 变换 ----
    StaticList<T> toStaticList() { return StaticList<T>(_data); }
    StaticSet<T> toStaticSet() { return StaticSet<T>(*this); }
    template<typename R> StaticSet<R> cast() {
        StaticSet<R> result;
        for (int64_t i = 0; i < _data.length(); i++) result.add(static_cast<R>(_data[i]));
        return result;
    }

    // ---- 字符串 ----
    std::string join(const std::string& sep = "") {
        if (isEmpty()) return "";
        std::string result = anyToString(AnyPtr::fromAuto(_data[0]));
        for (int64_t i = 1; i < _data.length(); i++) result += sep + anyToString(AnyPtr::fromAuto(_data[i]));
        return result;
    }
    std::string toString() { return "{" + join(", ") + "}"; }
};
```

### 8.6 StaticIterator\<T\>

**Dart:** 统一迭代器，支持从 `Array<T>` 构造。

**C++:**

```cpp
template<typename T>
struct StaticIterator {
    Array<T>* _array;
    int64_t _index = -1;

    StaticIterator(Array<T>* arr) : _array(arr) {}

    bool moveNext() { _index++; return _index < _array->length(); }
    T current() { return _array->operator[](_index); }
};
```

### 8.7 AnyPtr在集合中的特化

当集合元素类型为 `AnyPtr` 时，由于StaticMap/StaticSet底层基于Array而非hash容器，**不需要hash特化**。Array的indexOf/contains通过AnyPtr的 `operator==` 实现：

```cpp
bool operator==(const AnyPtr& other) const {
    if (tag != other.tag) return false;
    switch (tag) {
        case INT:      return data.intVal == other.data.intVal;
        case DOUBLE:   return data.doubleVal == other.data.doubleVal;
        case BOOL:     return data.boolVal == other.data.boolVal;
        case STRING:   return *data.stringPtr == *other.data.stringPtr;
        case VPTR:     return data.vptrPtr == other.data.vptrPtr;
        case NULL_TAG: return true;
        default:       return data.rawPtr == other.data.rawPtr;
    }
}
```

当StaticMap的K=AnyPtr或StaticSet的T=AnyPtr需要O(1)查找性能时，可额外提供基于 `std::unordered_map` 的加速索引，但基础实现保持Array一致性。

**可行性**：⭐⭐⭐⭐⭐ — 基于Array逐一映射，与Dart版存储结构完全一致。AnyPtr的operator==支持集合的contains/indexOf操作。

---

## 9. 异步状态机（Promise + Scheduler + smAwait）

### 9.1 PromiseBase

**Dart:** `Promise<T>` 有完整的状态管理、then/catchError/whenComplete链式调用、flatMap语义。

**C++:** 统一为 `PromiseBase`（运行时T=AnyPtr），1:1映射Dart版逻辑：

```cpp
enum class PromiseState { ready, pending, completed, error };

struct PromiseBase {
    PromiseState state = PromiseState::pending;
    AnyPtr _result;
    AnyPtr _error;
    std::function<void()> _startCallback;
    std::function<bool()> _onTick;

    bool isCompleted() const { return state == PromiseState::completed; }
    bool isError() const { return state == PromiseState::error; }
    bool isPending() const { return state == PromiseState::pending; }
    bool isReady() const { return state == PromiseState::ready; }

    AnyPtr result() {
        if (state == PromiseState::error) throw _error;
        if (state != PromiseState::completed) throw DartStateError("Promise not yet completed");
        return _result;
    }

    void setStartCallback(std::function<void()> cb) {
        _startCallback = cb;
        state = PromiseState::ready;
        GlobalScheduler::instance().registerReadyPromise(this);
    }

    void _fireStartCallback() {
        if (state != PromiseState::ready || !_startCallback) return;
        state = PromiseState::pending;
        _startCallback();
        _startCallback = nullptr;
    }

    void complete(AnyPtr value) {
        if (state == PromiseState::completed || state == PromiseState::error) {
            throw DartStateError("Promise already resolved");
        }
        _result = value;
        state = PromiseState::completed;
    }

    void completeError(AnyPtr err) {
        if (state == PromiseState::completed || state == PromiseState::error) {
            throw DartStateError("Promise already resolved");
        }
        _error = err;
        state = PromiseState::error;
    }

    // 工厂方法
    static PromiseBase* value(AnyPtr val) {
        auto* p = new PromiseBase();
        p->complete(val);
        return p;
    }

    static PromiseBase* delayed(int delayTicks, std::function<AnyPtr()> computation) {
        auto* promise = new PromiseBase();
        GlobalScheduler::instance().registerDelayedTask(delayTicks, [promise, computation]() {
            try { promise->complete(computation()); }
            catch (std::exception& e) { promise->completeError(AnyPtr::fromString(e.what())); }
        });
        return promise;
    }
};
```

### 9.2 Promise链式调用（then/catchError/whenComplete）

**Dart:** then支持flatMap语义 — 若onValue返回Promise<R>，自动展平为Promise<R>。

**C++:** 1:1映射Dart版逻辑：

```cpp
// Promise_then — 链式调用，支持flatMap语义
PromiseBase* Promise_then(PromiseBase* promise, std::function<AnyPtr(AnyPtr)> onValue) {
    auto* nextPromise = new PromiseBase();
    nextPromise->_onTick = [promise, nextPromise, onValue]() -> bool {
        if (promise->isCompleted()) {
            try {
                AnyPtr callbackResult = onValue(promise->result());
                // flatMap: 如果回调返回另一个Promise，等待其完成
                if (callbackResult.isVPtr()) {
                    VPtr* vptr = callbackResult.toVPtr();
                    if (vptr->_typeName == "PromiseBase") {
                        auto* innerPromise = static_cast<PromiseBase*>(vptr);
                        nextPromise->_onTick = [innerPromise, nextPromise]() -> bool {
                            if (innerPromise->isCompleted()) {
                                nextPromise->complete(innerPromise->result());
                                return true;
                            }
                            if (innerPromise->isError()) {
                                nextPromise->completeError(innerPromise->_error);
                                return true;
                            }
                            return false;  // 保持活跃，等内层完成
                        };
                        return false;  // 保持活跃，等内层完成
                    }
                }
                nextPromise->complete(callbackResult);
            } catch (std::exception& e) {
                nextPromise->completeError(AnyPtr::fromString(e.what()));
            }
            return true;
        }
        if (promise->isError()) {
            nextPromise->completeError(promise->_error);
            return true;
        }
        return false;
    };
    GlobalScheduler::instance().registerActivePromise(nextPromise);
    return nextPromise;
}

// Promise_catchError — 错误恢复链
PromiseBase* Promise_catchError(PromiseBase* promise, std::function<AnyPtr(AnyPtr)> onError) {
    auto* nextPromise = new PromiseBase();
    nextPromise->_onTick = [promise, nextPromise, onError]() -> bool {
        if (promise->isCompleted()) {
            nextPromise->complete(promise->result());
            return true;
        }
        if (promise->isError()) {
            try {
                nextPromise->complete(onError(promise->_error));
            } catch (std::exception& e) {
                nextPromise->completeError(AnyPtr::fromString(e.what()));
            }
            return true;
        }
        return false;
    };
    GlobalScheduler::instance().registerActivePromise(nextPromise);
    return nextPromise;
}

// Promise_whenComplete — 无论成功失败都执行action，然后传递原始结果/错误
PromiseBase* Promise_whenComplete(PromiseBase* promise, std::function<void()> action) {
    auto* nextPromise = new PromiseBase();
    nextPromise->_onTick = [promise, nextPromise, action]() -> bool {
        if (promise->isCompleted()) {
            try {
                action();
                nextPromise->complete(promise->result());
            } catch (std::exception& e) {
                nextPromise->completeError(AnyPtr::fromString(e.what()));
            }
            return true;
        }
        if (promise->isError()) {
            try { action(); } catch (...) {}
            nextPromise->completeError(promise->_error);
            return true;
        }
        return false;
    };
    GlobalScheduler::instance().registerActivePromise(nextPromise);
    return nextPromise;
}
```

### 9.3 GlobalScheduler

**Dart:** 三阶段tick（fireStartCallback → delayedTasks → activePromises）

**C++:** 1:1映射完整三阶段逻辑：

```cpp
struct DelayedTask {
    int targetTick;
    std::function<void()> callback;
    DelayedTask(int t, std::function<void()> cb) : targetTick(t), callback(cb) {}
};

struct GlobalScheduler {
    static GlobalScheduler& instance() {
        static GlobalScheduler inst;
        return inst;
    }

    std::vector<PromiseBase*> _activePromises;
    std::vector<DelayedTask> _delayedTasks;
    std::vector<PromiseBase*> _readyPromises;
    int _currentTick = 0;

    int currentTick() const { return _currentTick; }

    void registerActivePromise(PromiseBase* p) { _activePromises.push_back(p); }

    void registerDelayedTask(int delayTicks, std::function<void()> cb) {
        _delayedTasks.emplace_back(_currentTick + delayTicks, cb);
    }

    void registerReadyPromise(PromiseBase* p) { _readyPromises.push_back(p); }

    void tick() {
        _currentTick++;

        // 第一阶段：触发所有 ready 状态的 Promise 的启动回调
        auto readySnapshot = _readyPromises;
        _readyPromises.clear();
        for (auto* promise : readySnapshot) {
            if (promise->isReady()) {
                promise->_fireStartCallback();
            }
        }

        // 第二阶段：触发到期的延迟任务
        std::vector<DelayedTask> expired;
        auto it = _delayedTasks.begin();
        while (it != _delayedTasks.end()) {
            if (it->targetTick <= _currentTick) {
                expired.push_back(*it);
                it = _delayedTasks.erase(it);
            } else {
                ++it;
            }
        }
        for (auto& task : expired) {
            task.callback();
        }

        // 第三阶段：驱动所有活跃 Promise
        auto snapshot = _activePromises;
        std::unordered_set<PromiseBase*> finished;
        for (auto* promise : snapshot) {
            if (promise->isCompleted() || promise->isError()) {
                finished.insert(promise);
                continue;
            }
            if (promise->_onTick && promise->_onTick()) {
                finished.insert(promise);
            }
        }
        _activePromises.erase(
            std::remove_if(_activePromises.begin(), _activePromises.end(),
                [&finished](PromiseBase* p) { return finished.count(p) > 0; }),
            _activePromises.end());
    }

    void reset() {
        _activePromises.clear();
        _delayedTasks.clear();
        _readyPromises.clear();
        _currentTick = 0;
    }
};
```

### 9.4 smAwait

**Dart:** 同步等待Promise完成，支持递归深度限制。有三个分支：1) Promise\<T\>精确匹配；2) 原生Future兼容；3) Promise非精确匹配（泛型擦除场景）。

**C++:** 由于C++端不存在原生Future，只需要两个分支：1) Promise精确匹配；2) Promise非精确匹配。递归深度限制1:1映射。

```cpp
static int _smAwaitDepth = 0;
const int _smAwaitMaxDepth = 500;

// smAwait — 状态机版 await，循环调 tick() 直到 promise 完成
// 也兼容非精确匹配的 Promise（如 Promise<dynamic>）
AnyPtr smAwait(AnyPtr promiseOrFuture) {
    _smAwaitDepth++;
    if (_smAwaitDepth > _smAwaitMaxDepth) {
        _smAwaitDepth--;
        throw DartStateError("smAwait recursion depth exceeded " + std::to_string(_smAwaitMaxDepth)
                             + " — consider using AsyncStateMachine for deep async nesting");
    }
    try {
        return _smAwaitImpl(promiseOrFuture);
    } catch (...) {
        _smAwaitDepth--;
        throw;
    }
    _smAwaitDepth--;
}

AnyPtr _smAwaitImpl(AnyPtr promiseOrFuture) {
    // 分支1: Promise 精确匹配或非精确匹配
    if (promiseOrFuture.isVPtr() &&
        promiseOrFuture.toVPtr()->_typeName == "PromiseBase") {
        auto* promise = static_cast<PromiseBase*>(promiseOrFuture.toVPtr());
        int roundCount = 0;
        while (!promise->isCompleted() && !promise->isError()) {
            GlobalScheduler::instance().tick();
            roundCount++;
            if (roundCount > 100000) {
                throw DartStateError("smAwait exceeded max rounds — possible deadlock");
            }
        }
        if (promise->isError()) throw promise->_error;
        return promise->result();
    }

    // 分支2: 未知类型
    throw DartStateError("smAwait: unsupported type");
}

// Dart版还有原生Future兼容分支（C++端不需要）：
// if (promiseOrFuture is Future<T>) { ... 同步阻塞等待 ... }
// C++端不存在原生Future，此分支可省略。
```

### 9.5 AsyncStateMachine

**Dart:**

```dart
abstract class AsyncStateMachine<T> extends AnyGC {
  int smState = 0;
  final Promise<T> promise = Promise<T>();
  bool step();
  Promise<T> start();
}
```

**C++:**

```cpp
struct AsyncStateMachine : AnyGC {
    int smState = 0;
    PromiseBase* promise;

    AsyncStateMachine() { promise = new PromiseBase(); }
    virtual bool step() = 0;

    void completeWith(AnyPtr value) { promise->complete(value); }
    void completeWithError(AnyPtr err) { promise->completeError(err); }

    PromiseBase* start() {
        promise->_onTick = [this]() { return this->step(); };
        GlobalScheduler::instance().registerActivePromise(promise);
        return promise;
    }
};
```

### 9.5 promiseDelayed

**Dart:**

```dart
Promise<T> promiseDelayed<T>(StaticDuration duration, [T Function()? computation]) {
  final ticks = (duration.inMilliseconds / 10).ceil().clamp(1, 100000);
  final promise = Promise<T>();
  GlobalScheduler.instance.registerDelayedTask(ticks, () { ... });
  return promise;
}
```

**C++:**

```cpp
PromiseBase* promiseDelayed(int64_t milliseconds, std::function<AnyPtr()> computation = nullptr) {
    int ticks = std::max(1, std::min(100000, (int)(milliseconds / 10.0 + 0.5)));
    auto* promise = new PromiseBase();
    GlobalScheduler::instance().registerDelayedTask(ticks, [promise, computation]() {
        if (computation) {
            try { promise->complete(computation()); }
            catch (std::exception& e) { promise->completeError(AnyPtr::fromString(e.what())); }
        } else {
            promise->complete(AnyPtr::null());
        }
    });
    return promise;
}
```

**可行性**：⭐⭐⭐⭐ — 直接1:1翻译Dart版Promise系统，所有边界情况已解决。

---

## 10. 异常体系

### 10.1 定义映射

**Dart:**

```dart
class DartException implements Exception { final String? message; }
class DartStateError extends StateError { ... }
class DartArgumentError extends ArgumentError { ... }
class DartRangeError extends RangeError { ... }
class DartFormatException extends FormatException { ... }
class DartUnsupportedError extends UnsupportedError { ... }
class DartUnimplementedError extends UnimplementedError { ... }
```

**Dart（完整定义）:**

```dart
class DartException implements Exception {
  final String? message;
  DartException([this.message]);
  @override
  String toString() => message ?? 'DartException';
}

class DartStateError extends StateError {
  DartStateError(String message) : super(message);
}

class DartArgumentError extends ArgumentError {
  DartArgumentError([dynamic message]) : super(message);
}

class DartRangeError extends RangeError {
  DartRangeError([dynamic message]) : super(message);
  DartRangeError.range(int invalidValue, int minValue, int maxValue,
      [String? name, String? message])
      : super.range(invalidValue, minValue, maxValue, name, message);
  DartRangeError.value(num value, [String? name, String? message])
      : super.value(value, name, message);
}

// dartRangeErrorIndex — 工厂函数，替代 RangeError.index
DartRangeError dartRangeErrorIndex(int index, dynamic indexable,
    [String? name, String? message, int? length]) {
  try {
    throw RangeError.index(index, indexable, name, message, length);
  } on RangeError catch (e) {
    return DartRangeError(e.message);
  }
}

class DartFormatException extends FormatException {
  const DartFormatException([String message = '', dynamic source, int? offset])
      : super(message, source, offset);
}

class DartUnsupportedError extends UnsupportedError {
  DartUnsupportedError([String? message]) : super(message ?? '');
}

class DartUnimplementedError extends UnimplementedError {
  DartUnimplementedError([String? message]) : super(message);
}
```

**C++:**

```cpp
struct DartException : std::exception {
    std::string message;
    DartException(const std::string& msg = "") : message(msg) {}
    const char* what() const noexcept override { return message.c_str(); }
    std::string toString() const {
        return message.empty() ? "DartException" : message;
    }
};

struct DartStateError : DartException {
    DartStateError(const std::string& msg) : DartException(msg) {}
};

struct DartArgumentError : DartException {
    DartArgumentError(const std::string& msg = "") : DartException(msg) {}
};

struct DartRangeError : DartException {
    int invalidValue = 0;
    int minValue = 0;
    int maxValue = 0;

    DartRangeError(const std::string& msg = "") : DartException(msg) {}

    static DartRangeError range(int invalid, int min, int max,
                                const std::string& name = "",
                                const std::string& msg = "") {
        DartRangeError err(msg.empty()
            ? "RangeError: Invalid value: " + std::to_string(invalid)
              + " not in range " + std::to_string(min) + ".." + std::to_string(max)
            : msg);
        err.invalidValue = invalid;
        err.minValue = min;
        err.maxValue = max;
        return err;
    }

    static DartRangeError value(double v,
                                const std::string& name = "",
                                const std::string& msg = "") {
        DartRangeError err(msg.empty()
            ? "RangeError: Value not in range: " + std::to_string(v)
            : msg);
        return err;
    }

    // dartRangeErrorIndex — 工厂函数，替代 RangeError.index
    static DartRangeError index(int idx, int64_t indexableLength,
                                const std::string& name = "",
                                const std::string& msg = "") {
        std::string errMsg = msg.empty()
            ? "RangeError: Index " + std::to_string(idx)
              + " out of range for length " + std::to_string(indexableLength)
            : msg;
        return DartRangeError(errMsg);
    }
};

struct DartFormatException : DartException {
    std::string source;
    int64_t offset = -1;

    DartFormatException(const std::string& msg = "",
                        const std::string& src = "",
                        int64_t off = -1)
        : DartException(msg), source(src), offset(off) {}
};

struct DartUnsupportedError : DartException {
    DartUnsupportedError(const std::string& msg = "") : DartException(msg) {}
};

struct DartUnimplementedError : DartException {
    DartUnimplementedError(const std::string& msg = "") : DartException(msg) {}
};
```

### 10.2 try/catch映射

**Dart:**

```dart
try { ... }
on StateError catch (e) { ... }
on ArgumentError catch (e) { ... }
catch (e) { ... }
finally { ... }
```

**C++:**

```cpp
try { ... }
catch (const DartStateError& e) { ... }
catch (const DartArgumentError& e) { ... }
catch (const DartException& e) { ... }     // 通用catch

// finally：C++无finally，用嵌套try-catch模拟
// 或用RAII guard模式
try {
    // body
} catch (...) {
    // cleanup
    throw;
}
// cleanup (normal path)
```

### 10.3 throw映射

**Dart:**

```dart
throw DartStateError('test error');
throw DartArgumentError('Radius must be non-negative');
```

**C++:**

```cpp
throw DartStateError("test error");
throw DartArgumentError("Radius must be non-negative");
```

**可行性**：⭐⭐⭐⭐⭐ — 最直接映射。唯一注意是finally需用RAII或嵌套try模拟。

---

## 11. null语义 + 可空类型

### 11.1 null值映射

**Dart:**

```dart
return null;
final String? found = findFirst(items, predicate);
```

**C++:**

```cpp
return AnyPtr::null();
AnyPtr found = findFirst(items, predicate);  // T? 统一为AnyPtr
```

### 11.2 ?. 空安全访问

**Dart:**

```dart
text?.length
```

**C++:**

```cpp
text.isNull() ? AnyPtr::null() : AnyPtr::fromInt(text.toString().size())
```

### 11.3 ?? 空合并

**Dart:**

```dart
text?.length ?? 0
```

**C++:**

```cpp
text.isNull() ? AnyPtr::fromInt(0) : AnyPtr::fromInt(text.toString().size())
```

### 11.4 T?类型映射

| Dart类型 | C++类型 | 说明 |
|---|---|---|
| `String?` | `AnyPtr` | 可能是STRING_TAG或NULL_TAG |
| `int?` | `AnyPtr` | 可能是INT_TAG或NULL_TAG |
| `XxxValue?` | `AnyPtr` | 可能是VPTR_TAG或NULL_TAG |
| `T?` (泛型) | `AnyPtr` | AnyPtr内含null语义，无需std::optional |

**可行性**：⭐⭐⭐⭐⭐ — AnyPtr天然含null语义，`?.`和`??`由编译器生成条件检查。

---

## 12. is / as 运行时类型检查

### 12.1 AnyPtr的is检查

**Dart:**

```dart
value is int
value is String
value is CircleValue
```

**C++:**

```cpp
value.isInt()
value.isString()
value.toVPtr()->_typeName == "CircleValue"  // VPtr需类型名标签
```

### 12.2 AnyPtr的as转换

**Dart:**

```dart
value as int
env__ as ClosureEnv_makeAdder_3
this__ as CircleValue
```

**C++:**

```cpp
value.toInt()                          // tag检查+提取
env__.toTypeFunction()->castTo<ClosureEnv_makeAdder_3>()  // 编译期已知类型
this__.toVPtr()->castTo<CircleValue>()  // 需typeName检查
```

### 12.3 VPtr类型标签机制

```cpp
// VPtr子类需携带类型名，由编译器在构造函数中设置
struct VPtr : AnyGC {
    std::string _typeName;  // "ShapeValue", "CircleValue" 等
    // ...
};

// castTo 实现
template<typename T>
T* VPtr::castTo() {
    if (_typeName != T::staticTypeName()) {
        throw DartException("Type cast error: expected " + T::staticTypeName()
                            + " got " + _typeName);
    }
    return static_cast<T*>(this);
}
```

**可行性**：⭐⭐⭐⭐ — AnyPtr的is检查直接用tag（零开销），VPtr子类的is检查用typeName字符串（O(1)比较）。每个VPtr对象多约32字节（std::string typeName）。

---

## 13. enum映射

**Dart:**

```dart
enum Direction { north, south, east, west; }
// 使用：Direction.north, dir == Direction.south, dir.index, dir.name
```

**C++:**

```cpp
enum class Direction : int64_t {
    north = 0, south = 1, east = 2, west = 3
};

struct DirectionMeta {
    static int64_t index(Direction d) { return static_cast<int64_t>(d); }
    static const char* name(Direction d) {
        static const char* names[] = {"north", "south", "east", "west"};
        return names[static_cast<int64_t>(d)];
    }
    static std::vector<Direction> values() {
        return {Direction::north, Direction::south, Direction::east, Direction::west};
    }
};
```

### switch映射

**Dart:**

```dart
switch (dir) {
  case Direction.north: _v2 = 'N'; break;
  case Direction.south: _v2 = 'S'; break;
}
```

**C++:**

```cpp
switch (dir) {
    case Direction::north: v2 = "N"; break;
    case Direction::south: v2 = "S"; break;
}
```

### enum扩展方法映射

**Dart:**

```dart
String Color_get_hex(Color this_) { ... }
bool Color_get_isWarm(Color this_) { ... }
```

**C++:**

```cpp
std::string Color_get_hex(Direction this_) { ... }
bool Color_get_isWarm(Direction this_) { ... }
```

**可行性**：⭐⭐⭐⭐⭐ — 直接映射，约25行C++代码/enum。

---

## 14. 扩展方法

**Dart:**

```dart
StringExtensions_capitalize(word)
StringExtensions_get_isPalindrome('racecar')
ListExtensions_filterWhere<T>(list, predicate)
StringExtensions_get_capitalize(word)  // getter扩展，返回闭包
```

**C++:**

```cpp
std::string StringExtensions_capitalize(const std::string& word);
bool StringExtensions_get_isPalindrome(const std::string& word);
template<typename T>
StaticList<T> ListExtensions_filterWhere(StaticList<T>& list, TypeFunction1<bool, T>* predicate);
TypeFunction0<std::string>* StringExtensions_get_capitalize(const std::string& word);
```

**可行性**：⭐⭐⭐⭐⭐ — 直接映射为自由函数，零额外复杂度。

---

## 15. 语义脱钩包装类型

### 15.1 staticPrint

**Dart:**

```dart
void staticPrint(Object? object) => print(object);
staticPrint('hello ${name}');
```

**C++:**

```cpp
void staticPrint(const AnyPtr& obj) {
    std::cout << anyToString(obj) << std::endl;
}
```

### 15.2 StaticStringBuffer

**Dart（完整定义）:**

```dart
class StaticStringBuffer {
  final StringBuffer _delegate;
  StaticStringBuffer([Object content = '']);
  void write(Object? obj);
  void writeln([Object? obj = '']);
  void writeAll(Iterable objects, [String separator = '']);
  void writeCharCode(int charCode);
  int get length;
  bool get isEmpty;
  bool get isNotEmpty;
  void clear();
  @override
  String toString();
}
```

**C++:**

```cpp
struct StaticStringBuffer {
    std::ostringstream _delegate;

    StaticStringBuffer(const AnyPtr& content = AnyPtr::fromString("")) {
        if (!content.isNull()) _delegate << anyToString(content);
    }

    void write(const AnyPtr& obj) { _delegate << anyToString(obj); }
    void writeln(const AnyPtr& obj = AnyPtr::fromString("")) {
        _delegate << anyToString(obj) << "\n";
    }
    void writeAll(const StaticList<AnyPtr>& objects, const std::string& separator = "") {
        for (int64_t i = 0; i < objects.length(); i++) {
            if (i > 0 && !separator.empty()) _delegate << separator;
            _delegate << anyToString(objects[i]);
        }
    }
    void writeCharCode(int64_t charCode) { _delegate << static_cast<char>(charCode); }

    int64_t length() const { return (int64_t)_delegate.str().size(); }
    bool isEmpty() const { return _delegate.str().empty(); }
    bool isNotEmpty() const { return !_delegate.str().empty(); }
    void clear() { _delegate.str(""); }
    std::string toString() const { return _delegate.str(); }
};
```

### 15.3 StaticRegExp

**Dart（完整定义）:**

```dart
class StaticRegExp implements Pattern {
  final RegExp _delegate;
  StaticRegExp(String source, {bool multiLine, bool caseSensitive, bool unicode, bool dotAll});
  bool hasMatch(String input);
  RegExpMatch? firstMatch(String input);
  Iterable<RegExpMatch> allMatches(String string, [int start = 0]);
  Match? matchAsPrefix(String string, [int start = 0]);
  String get pattern;
  bool get isMultiLine;
  bool get isCaseSensitive;
  bool get isUnicode;
  bool get isDotAll;
  static String escape(String text);
}
```

**C++:**

```cpp
struct StaticRegExp {
    std::regex _delegate;
    std::string _source;
    bool _multiLine = false;
    bool _caseSensitive = true;
    bool _unicode = false;
    bool _dotAll = false;

    StaticRegExp(const std::string& source,
                 bool multiLine = false,
                 bool caseSensitive = true,
                 bool unicode = false,
                 bool dotAll = false)
        : _source(source), _multiLine(multiLine),
          _caseSensitive(caseSensitive), _unicode(unicode), _dotAll(dotAll) {
        auto flags = std::regex::ECMAScript;
        if (multiLine)    flags |= std::regex::multiline;
        if (!caseSensitive) flags |= std::regex::icase;
        _delegate = std::regex(source, flags);
    }

    bool hasMatch(const std::string& input) {
        return std::regex_search(input, _delegate);
    }
    std::string firstMatch(const std::string& input) {
        std::smatch match;
        if (std::regex_search(input, match, _delegate)) return match.str();
        return "";  // Dart返回null → C++返回空串
    }
    StaticList<std::string> allMatches(const std::string& string, int64_t start = 0) {
        StaticList<std::string> result;
        std::smatch match;
        auto it = std::sregex_iterator(string.begin() + start, string.end(), _delegate);
        for (; it != std::sregex_iterator(); ++it) {
            result.add(it->str());
        }
        return result;
    }
    std::string matchAsPrefix(const std::string& string, int64_t start = 0) {
        std::smatch match;
        if (std::regex_search(string.begin() + start, string.end(), match, _delegate,
                              std::regex_constants::match_continuous)) {
            return match.str();
        }
        return "";
    }

    const std::string& pattern() const { return _source; }
    bool isMultiLine() const { return _multiLine; }
    bool isCaseSensitive() const { return _caseSensitive; }
    bool isUnicode() const { return _unicode; }
    bool isDotAll() const { return _dotAll; }

    static std::string escape(const std::string& text) {
        std::string result;
        for (char c : text) {
            if (std::string(".^$*+?()[{}\\|").find(c) != std::string::npos) result += '\\';
            result += c;
        }
        return result;
    }
};
```

**注**：`std::regex` 性能较差但无需额外依赖。生产环境推荐re2或PCRE。Dart版 `unicode`/`dotAll` 选项在 `std::regex` 中无完整对应（ECMAScript模式不支持），初版可忽略这两项。

### 15.4 StaticDuration

**Dart（完整定义）:**

```dart
class StaticDuration {
  final Duration _delegate;
  StaticDuration({int days, int hours, int minutes, int seconds, int milliseconds, int microseconds});
  int get inDays;
  int get inHours;
  int get inMinutes;
  int get inSeconds;
  int get inMilliseconds;
  int get inMicroseconds;
  Duration toDuration();
  @override
  bool operator ==(Object other);
  @override
  int get hashCode;
}
```

**C++:**

```cpp
struct StaticDuration {
    int64_t _milliseconds;

    StaticDuration(int64_t days = 0, int64_t hours = 0, int64_t minutes = 0,
                   int64_t seconds = 0, int64_t milliseconds = 0, int64_t microseconds = 0)
        : _milliseconds(days * 86400000 + hours * 3600000 + minutes * 60000
                        + seconds * 1000 + milliseconds + microseconds / 1000) {}

    int64_t inDays()         const { return _milliseconds / 86400000; }
    int64_t inHours()        const { return _milliseconds / 3600000; }
    int64_t inMinutes()      const { return _milliseconds / 60000; }
    int64_t inSeconds()      const { return _milliseconds / 1000; }
    int64_t inMilliseconds() const { return _milliseconds; }
    int64_t inMicroseconds() const { return _milliseconds * 1000; }

    bool operator==(const StaticDuration& other) const { return _milliseconds == other._milliseconds; }
    int64_t hashCode() const { return std::hash<int64_t>()(_milliseconds); }
    std::string toString() const {
        return "StaticDuration(" + std::to_string(_milliseconds) + "ms)";
    }
};
```

### 15.5 StaticDateTime

**Dart（完整定义）:**

```dart
class StaticDateTime {
  final DateTime _delegate;
  StaticDateTime(int year, [int month, int day, int hour, int minute, int second, int millisecond, int microsecond]);
  factory StaticDateTime.now();
  factory StaticDateTime.utc(int year, ...);
  factory StaticDateTime.parse(String formattedString);
  factory StaticDateTime.tryParse(String formattedString);
  factory StaticDateTime.fromMillisecondsSinceEpoch(int ms, {bool isUtc});
  factory StaticDateTime.fromMicrosecondsSinceEpoch(int us, {bool isUtc});
  int get year/month/day/hour/minute/second/millisecond/microsecond/weekday;
  int get millisecondsSinceEpoch/microsecondsSinceEpoch;
  bool get isUtc;
  StaticDateTime add(StaticDuration duration);
  StaticDateTime subtract(StaticDuration duration);
  StaticDuration difference(StaticDateTime other);
  bool isBefore/isAfter/isAtSameMomentAs(StaticDateTime other);
  String toIso8601String();
  StaticDateTime toUtc()/toLocal();
}
```

**C++:**

```cpp
struct StaticDateTime {
    int64_t _timestampMs;  // 毫秒时间戳
    bool _isUtc = false;

    // 构造函数
    StaticDateTime(int64_t year, int64_t month = 1, int64_t day = 1,
                   int64_t hour = 0, int64_t minute = 0, int64_t second = 0,
                   int64_t millisecond = 0, int64_t microsecond = 0);
    static StaticDateTime now();
    static StaticDateTime utc(int64_t year, int64_t month = 1, int64_t day = 1,
                              int64_t hour = 0, int64_t minute = 0, int64_t second = 0,
                              int64_t millisecond = 0, int64_t microsecond = 0);
    static StaticDateTime parse(const std::string& formattedString);
    static StaticDateTime tryParse(const std::string& formattedString);  // 解析失败抛DartFormatException
    static StaticDateTime fromMillisecondsSinceEpoch(int64_t ms, bool isUtc = false);
    static StaticDateTime fromMicrosecondsSinceEpoch(int64_t us, bool isUtc = false);

    // 属性（需日期库支持，底层用tm结构体分解）
    int64_t year() const;
    int64_t month() const;
    int64_t day() const;
    int64_t hour() const;
    int64_t minute() const;
    int64_t second() const;
    int64_t millisecond() const;
    int64_t microsecond() const { return (_timestampMs % 1000) * 1000; }
    int64_t weekday() const;
    int64_t millisecondsSinceEpoch() const { return _timestampMs; }
    int64_t microsecondsSinceEpoch() const { return _timestampMs * 1000; }
    bool isUtc() const { return _isUtc; }

    // 操作
    StaticDateTime add(StaticDuration dur) const { return StaticDateTime(_timestampMs + dur._milliseconds, _isUtc); }
    StaticDateTime subtract(StaticDuration dur) const { return StaticDateTime(_timestampMs - dur._milliseconds, _isUtc); }
    StaticDuration difference(const StaticDateTime& other) const { return StaticDuration(0, 0, 0, 0, 0, _timestampMs - other._timestampMs); }
    bool isBefore(const StaticDateTime& other) const { return _timestampMs < other._timestampMs; }
    bool isAfter(const StaticDateTime& other) const { return _timestampMs > other._timestampMs; }
    bool isAtSameMomentAs(const StaticDateTime& other) const { return _timestampMs == other._timestampMs; }

    std::string toIso8601String() const;
    StaticDateTime toUtc() const { return StaticDateTime(_timestampMs, true); }
    StaticDateTime toLocal() const { return StaticDateTime(_timestampMs, false); }

    std::string toString() const;

    bool operator==(const StaticDateTime& other) const { return _timestampMs == other._timestampMs && _isUtc == other._isUtc; }
    int64_t hashCode() const { return std::hash<int64_t>()(_timestampMs); }
};
```

**日期库选型**：`year()/month()/day()` 等属性需要从时间戳分解为日期字段。C++标准库 `<ctime>` 的 `localtime/gmtime` 可满足基本需求。生产环境推荐 Howard Hinnant 的 `date` 库（C++20 `<chrono>` 扩展）。

### 15.6 StaticMapEntry\<K, V\>

**Dart:**

```dart
class StaticMapEntry<K, V> {
  final K key;
  final V value;
  const StaticMapEntry(this.key, this.value);
  MapEntry<K, V> toMapEntry();
  @override
  String toString();
  @override
  bool operator ==(Object other);
  @override
  int get hashCode;
}
```

**C++:** 见 [8.4 StaticMapEntry](#84-staticmapentrykv)

### 15.7 StaticComparable\<T\>

**Dart:**

```dart
abstract class StaticComparable<T> {
  int compareTo(T other);
}
```

**C++:**

```cpp
template<typename T>
struct StaticComparable {
    virtual int64_t compareTo(const T& other) = 0;
};
```

**注**：Restorer中使用 `StaticComparable<T>` 替代原生 `Comparable<T>`，C++端直接映射为抽象基类模板。Value对象实现compareTo时通过ClassInfo.dispatch委托：`ci.dispatch['compareTo']` 指向 `Xxx_compareTo` 静态方法。

### 15.8 StaticIterator\<T\>

**Dart:**

```dart
class StaticIterator<T> implements Iterator<T> {
  final Iterator<T> _delegate;
  StaticIterator(this._delegate);
  StaticIterator._fromArray(Array<T> array);
  @override
  bool moveNext();
  @override
  T get current;
}
```

**C++:** 见 [8.6 StaticIterator](#86-staticiterator-t)

**可行性**：⭐⭐⭐⭐ — staticPrint/StringBuffer/Duration/MapEntry/Comparable/Iterator直接映射。RegExp需注意unicode/dotAll选项限制。DateTime需选日期库。

---

## 16. 字符串操作

### 16.1 字符串插值

**Dart:**

```dart
'Hello, ${name} ${version}!'
'Sum: ${((1 + 2) + 3)}, Upper: ${name.toUpperCase()}'
```

**C++:**

```cpp
// 编译器展开为拼接表达式
std::string("Hello, ") + anyToString(name) + " " + anyToString(version) + "!"
std::string("Sum: ") + anyToString(AnyPtr::fromInt((1 + 2) + 3))
    + ", Upper: " + DartString::toUpperCase(name)
```

### 16.2 字符串方法映射

| Dart方法 | C++函数 | 说明 |
|---|---|---|
| `s.length` | `s.size()` | 直接映射 |
| `s.isEmpty` | `s.empty()` | 直接映射 |
| `s.toUpperCase()` | `DartString::toUpperCase(s)` | 需包装 |
| `s.toLowerCase()` | `DartString::toLowerCase(s)` | 需包装 |
| `s.startsWith(prefix)` | `DartString::startsWith(s, prefix)` | 需包装 |
| `s.endsWith(suffix)` | `DartString::endsWith(s, suffix)` | 需包装 |
| `s.split(sep)` | `DartString::split(s, sep)` → `StaticList<std::string>` | 需包装 |
| `s.substring(start, end)` | `s.substr(start, end-start)` | 基本映射 |
| `s.replaceAll(from, to)` | `DartString::replaceAll(s, from, to)` | 需包装 |
| `s.trim()` | `DartString::trim(s)` | 需包装 |
| `s.contains(sub)` | `s.find(sub) != std::string::npos` | 基本映射 |
| `s.indexOf(sub)` | `(int64_t)s.find(sub)` | 基本映射 |
| `s[0]` | `s[0]` | **仅ASCII安全** |
| `d.toStringAsFixed(2)` | `doubleToString(val, 2)` | 需包装 |

### 16.3 anyToString（AnyPtr→字符串，支持插值）

```cpp
std::string anyToString(const AnyPtr& p) {
    switch (p.tag) {
        case AnyPtr::INT:         return std::to_string(p.toInt());
        case AnyPtr::DOUBLE:      return doubleToString(p.toDouble());
        case AnyPtr::BOOL:        return p.toBool() ? "true" : "false";
        case AnyPtr::STRING:      return p.toString();
        case AnyPtr::VPTR:        return p.toVPtr()->toString();
        case AnyPtr::NULL_TAG:    return "null";
        case AnyPtr::TYPE_FUNCTION: return "Function";
        default:                  return "Object";
    }
}

std::string doubleToString(double val, int precision = -1) {
    if (precision >= 0) {
        std::ostringstream oss;
        oss << std::fixed << std::setprecision(precision) << val;
        return oss.str();
    }
    return std::to_string(val);
}
```

**限制**：初期仅保证ASCII场景正确。UTF-8多字节字符的 `s[0]` / `toUpperCase` / `split` 需额外UTF-8解码层。

---

## 17. 运算符映射

### 17.1 算术运算符

| Dart运算符 | C++运算符 | 说明 |
|---|---|---|
| `a + b` | `a + b` | 直接映射（int/double） |
| `a - b` | `a - b` | 直接映射 |
| `a * b` | `a * b` | 直接映射 |
| `a / b` | `a / b` | Dart double除法，C++同 |
| `a % b` | `a % b` | 直接映射 |
| `-a` | `-a` | 直接映射 |

### 17.2 比较运算符

| Dart运算符 | C++运算符 | 说明 |
|---|---|---|
| `a == b` | `a == b` | 基本类型直接映射 |
| `a != b` | `a != b` | 直接映射 |
| `a < b` / `a > b` / `a <= b` / `a >= b` | 同 | 直接映射 |

### 17.3 逻辑运算符

| Dart运算符 | C++运算符 | 说明 |
|---|---|---|
| `a && b` | `a && b` | 直接映射 |
| `a || b` | `a || b` | 直接映射 |
| `!a` | `!a` | 直接映射 |

### 17.4 自定义运算符（通过ClassInfo.dispatch/静态方法）

**Dart:**

```dart
Money_operatorPlus(this__, other)
Money_operatorMinus(this__, other)
```

**C++:**

```cpp
// 保持为自由函数，不映射为C++ operator重载
MoneyValue* Money_operatorPlus(AnyPtr this__, MoneyValue* other);
MoneyValue* Money_operatorMinus(AnyPtr this__, MoneyValue* other);
```

**设计决策**：Value对象间的自定义运算符保持为自由函数，与ClassInfo.dispatch模式一致。只在基本类型（int/double/bool/String）上直接使用C++内置运算符。

---

## 18. 控制流映射

### 18.1 if/else — 完全一致

```dart
if (cond) { ... } else { ... }
```

```cpp
if (cond) { ... } else { ... }
```

### 18.2 for循环

**Dart:**

```dart
for (var i = 1; (i <= 5); i = (i + 1)) { ... }
for (final item in items) { ... }
```

**C++:**

```cpp
for (int64_t i = 1; i <= 5; i = i + 1) { ... }
for (int64_t i = 0; i < items.length(); i = i + 1) { auto item = items[i]; ... }
// 或 StaticList 支持迭代器时
for (auto& item : items) { ... }
```

### 18.3 while / do-while — 完全一致

### 18.4 switch-case

**Dart:**

```dart
switch (dir) {
  case Direction.north: { _v2 = 'N'; break; }
  default: { _v2 = 'unknown'; break; }
}
```

**C++:**

```cpp
switch (dir) {
    case Direction::north: { v2 = "N"; break; }
    default: { v2 = "unknown"; break; }
}
```

### 18.5 break / continue — 完全一致

### 18.6 late变量

**Dart:**

```dart
late double _radius;
late A first;
```

**C++:**

```cpp
double _radius = 0.0;           // 数值类型默认值
AnyPtr first = AnyPtr::null();  // AnyPtr默认null
```

### 18.7 do-while包装块（Restorer生成的赋值模式）

**Dart:**

```dart
final String label = (() { late String _v2; do { switch(dir) { ... } } while(false); return _v2; })();
```

**C++:**

```cpp
// 可简化为普通switch赋值
std::string label;
switch (dir) {
    case Direction::north: label = "N"; break;
    case Direction::south: label = "S"; break;
    default: label = "unknown"; break;
}
```

---

## 19. 字段与构造器映射

### 19.1 Value对象字段

**Dart:**

```dart
class PairValue<A, B> extends VPtr { late A first; late B second; }
class CircleValue extends ShapeValue { late double _radius; }
```

**C++:**

```cpp
struct PairValue : VPtr {
    AnyPtr first;    // 泛型A → AnyPtr
    AnyPtr second;   // 泛型B → AnyPtr
};
struct CircleValue : ShapeValue {
    double _radius = 0.0;
};
```

**泛型字段映射规则**：
- 具体类型字段（`double`, `int`, `String`）→ C++对应类型
- 泛型类型字段（`A`, `B`, `T`）→ `AnyPtr`
- VPtr子类字段（`XxxValue`）→ `XxxValue*`（指针，参与GC）

### 19.2 构造函数（_new函数）

**Dart:**

```dart
CircleValue Circle_new(dynamic this__, double _radius) {
  final this_ = this__ as CircleValue;
  Shape_new(this_);
  this_._radius = _radius;
  return this_;
}
```

**C++:**

```cpp
CircleValue* Circle_new(AnyPtr this__, double _radius) {
    CircleValue* this_ = this__.toVPtr()->castTo<CircleValue>();
    Shape_new(this__);  // 调用父类构造
    this_->_radius = _radius;
    return this_;
}
```

### 19.3 对象创建

**Dart:**

```dart
GC.allocateLocal(CircleValue())
GC.allocateLocal(PairValue<String, int>())
```

**C++:**

```cpp
GC::allocateLocal(new CircleValue())
GC::allocateLocal(new PairValue())   // 泛型参数在运行时无意义
```

---

## 20. mixin委托映射

### 20.1 mixin静态方法

**Dart:**

```dart
String Printable_toPrettyString(dynamic this__) {
  final this_ = this__;
  return '[${(this_.classInfo as PrintableClassInfo).get_label!(this_)}]';
}
```

**C++:**

```cpp
std::string Printable_toPrettyString(AnyPtr this__) {
    auto labelFn = reinterpret_cast<std::string(*)(AnyPtr)>(
        this__.toVPtr()->vptr["get_label"]);
    return "[" + labelFn(this__) + "]";
}
```

### 20.2 合成中间类（多mixin叠加）

**Dart:**

```dart
class Entity_Object_Printable_CacheableClassInfo<ID> extends ObjectClassInfo {
  Function? get_label;
  Function? toPrettyString;
}

class Entity_Object_Printable_CacheableValue<ID> extends ObjectValue {
  @override
  ClassInfo get classInfo => ClassInfoRegistry.get<Entity_Object_Printable_CacheableClassInfo<ID>>(runtimeType, _initClassInfo<ID>);
  static Entity_Object_Printable_CacheableClassInfo<ID> _initClassInfo<ID>() {
    final ci = Entity_Object_Printable_CacheableClassInfo<ID>();
    ci.get_label = Entity_get_label<ID>;
    ci.dispatch['get_label'] = Entity_get_label<ID>;
    ci.toPrettyString = Entity_toPrettyString<ID>;
    ci.dispatch['toPrettyString'] = Entity_toPrettyString<ID>;
    return ci;
  }
}
```

**C++:**

```cpp
struct Entity_Object_Printable_CacheableValue : ObjectValue {
    Entity_Object_Printable_CacheableValue() {
        _typeName = "Entity_Object_Printable_CacheableValue";
        vptr["get_label"]      = reinterpret_cast<void*>(Entity_get_label);
        vptr["toPrettyString"] = reinterpret_cast<void*>(Entity_toPrettyString);
    }
};
```

**可行性**：⭐⭐⭐⭐⭐ — mixin已完全展平为静态函数+ClassInfo.dispatch委托，C++端无需任何特殊mixin机制。

---

## 21. 泛型映射

### 21.1 泛型类型

**Dart:**

```dart
class PairValue<A, B> extends VPtr { late A first; late B second; }
class Comparable2Value<T> extends VPtr { ... }
```

**C++:**

```cpp
struct PairValue : VPtr { AnyPtr first; AnyPtr second; };  // A,B→AnyPtr
struct Comparable2Value : VPtr { ... };  // T在运行时是AnyPtr
```

**核心规则**：Dart泛型是reified（运行时保留T），C++泛型是erased（编译后消失）。在Value对象模式中，泛型字段统一为 `AnyPtr`，因为运行时T的具体类型由AnyPtr的tag决定。

### 21.2 泛型静态方法

**Dart:**

```dart
PairValue<A, B> Pair_new<A, B>(dynamic this__, A first, B second)
PairValue<B, A> Pair_swap<A, B>(dynamic this__)
```

**C++:**

```cpp
// 泛型参数在运行时由AnyPtr承载，方法签名不需要显式模板参数
PairValue* Pair_new(AnyPtr this__, AnyPtr first, AnyPtr second)
PairValue* Pair_swap(AnyPtr this__)
```

### 21.3 泛型闭包

**Dart:**

```dart
class ClosureEnv_repeat_2<T> extends TypeFunction1<T, int> {
  late ObjectBox<T> item;
}
```

**C++:**

```cpp
// ObjectBox统一为AnyPtr，泛型T消失
struct ClosureEnv_repeat_2 : TypeFunction1 {
    ObjectBox* item;
}
```

### 21.4 typedef映射

**Dart:**

```dart
typedef Predicate<T> = TypeFunction1<bool, T>;
typedef Transformer<A, B> = TypeFunction1<B, A>;
typedef Reducer<T> = TypeFunction2<T, T, T>;
```

**C++:**

```cpp
using Predicate = TypeFunction1*;
using Transformer = TypeFunction1*;
using Reducer = TypeFunction2*;
// 或保持具体模板
template<typename T> using Predicate = TypeFunction1<bool, T>*;
```

---

## 22. 综合可行性评估

### 22.1 各组件评估汇总

| # | 组件 | 可行性 | 工作量(C++代码行数) | 性能影响(vs纯C++) | 风险等级 |
|---|---|---|---|---|---|
| 3 | **VPtr + vptr虚表** | ⭐⭐⭐⭐⭐ | ~50行 | ~1x (hash+间接调用) | 低 |
| 4 | **AnyPtr类型擦除** | ⭐⭐⭐⭐⭐ | ~200行 | 2-3x vs强类型 | 低 |
| 5 | **TypeFunction + 闭包** | ⭐⭐⭐⭐⭐ | ~300行 | 2-3x vslambda | 低 |
| 6 | **Box类型** | ⭐⭐⭐⭐⭐ | ~50行 | ~1x | 极低 |
| 7 | **GC标记-清除** | ⭐⭐⭐⭐⭐ | ~100行 | 0(增量回收) | 低 |
| 8 | **静态集合类** | ⭐⭐⭐⭐⭐ | ~1500行 | ~1x vs STL | 低(AnyPtr==) |
| 9 | **异步状态机** | ⭐⭐⭐⭐ | ~250行 | busy-wait阻塞 | 中(逻辑复杂) |
| 10 | **异常体系** | ⭐⭐⭐⭐⭐ | ~50行 | ~0 | 极低 |
| 15 | **语义脱钩包装** | ⭐⭐⭐⭐ | ~400行 | ~0 | 低(RegExp选库) |
| 16 | **字符串操作** | ⭐⭐⭐ | ~200行 | ~1x | 中(UTF编码) |
| 11 | **null语义** | ⭐⭐⭐⭐⭐ | 0(AnyPtr内含) | ~0 | 极低 |
| 12 | **is/as检查** | ⭐⭐⭐⭐ | ~20行+typeName | O(1) | 低 |
| 13 | **enum映射** | ⭐⭐⭐⭐⭐ | ~25行/enum | ~0 | 极低 |
| 14 | **扩展方法** | ⭐⭐⭐⭐⭐ | 0额外 | ~0 | 极低 |
| — | **代码转换器** | ⭐⭐⭐⭐ | ~3000-5000行 | — | 中 |

### 22.2 关键设计决策确认

| 决策项 | 确认方案 | 理由 |
|---|---|---|
| vptr函数存储 | `void*` + `reinterpret_cast` | 与Dart版 `dynamic` + `as Function` 完全对齐，零额外开销 |
| GC方案 | 标记-清除（1:1映射Dart版） | 正确处理循环引用，与Dart运行时一致 |
| 异步方案 | Promise+Scheduler+smAwait（1:1翻译） | 已有完整设计，无需重新发明 |
| `dynamic`映射 | AnyPtr tagged union | 类型擦除的唯一可行方案，影响面可控 |
| `T?`映射 | AnyPtr(内含null语义) | 不引入std::optional，简化系统 |
| 泛型字段映射 | AnyPtr | Dart reified泛型在C++中需运行时类型标签 |
| 自定义运算符 | 自由函数（不映射为C++ operator） | 与ClassInfo.dispatch/静态方法模式一致 |
| finally | RAII guard或嵌套try-catch | C++无finally关键字 |

### 22.3 建议的实施顺序

1. **Phase 1 — 核心运行时**：AnyPtr + VPtr + AnyGC/GC + Box类型 + 异常体系
2. **Phase 2 — 基础功能**：静态集合类 + 字符串操作 + 语义脱钩包装 + enum + 控制流
3. **Phase 3 — 高级功能**：TypeFunction + 闭包系统 + is/as类型检查 + 扩展方法
4. **Phase 4 — 异步支持**：Promise + GlobalScheduler + smAwait + AsyncStateMachine
5. **Phase 5 — 代码转换器**：实现完整的静态Dart→C++编译器后端

### 22.4 总体结论

**整体可行性：高**。由于Restorer已完成OOP Lowering的全部困难工作，C++转换器不需要重新处理继承/方法重写/mixin展开等OOP语义。核心挑战是 `dynamic → AnyPtr` 的类型擦除，这有成熟方案（tagged union）。vptr采用 `void*` + 强制转换方案后，性能开销大幅降低（从统一签名的3-5x降为~1x）。GC和异步系统直接1:1映射，无需设计决策。

预计总工作量：**C++运行时库约3500行 + 编译器后端约3000-5000行**。