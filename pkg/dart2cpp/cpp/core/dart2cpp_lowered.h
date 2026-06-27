// ============================================================================
// dart2cpp_lowered.h — OOP-lowered Dart → C++ 运行时库
// ============================================================================
// 本头文件为 dart2cpp 新编译器模块（lib/cpp_compiler/）生成的 C++ 代码
// 提供完整的运行时支持。设计镜像 lib/restorer/runtime_classes.dart。
//
// 组件清单：
//   1. AnyGC — GC 管理基类
//   2. GC — 标记-清除垃圾回收器
//   3. AnyPtr — 标签联合（替代 Dart 的 dynamic）
//   4. VPtr — 虚表基类
//   5. Box 类型 — 闭包捕获引用语义
//   6. TypeFunction 层级 — 可调用闭包基类
//   7. 静态集合 — Array / StaticList / StaticMap / StaticSet / StaticIterator
//   8. Promise / GlobalScheduler / smAwait — 协作式异步
//   9. 语义包装 — staticPrint / StaticStringBuffer / StaticMapEntry
//  10. 异常层级 — DartException / DartStateError / ...
//  11. 辅助函数 — dart_cast / dart_is / dart_str
// ============================================================================

#ifndef DART2CPP_LOWERED_H
#define DART2CPP_LOWERED_H

#include <algorithm>
#include <any>
#include <cassert>
#include <cmath>
#include <cstdint>
#include <functional>
#include <iomanip>
#include <iostream>
#include <memory>
#include <sstream>
#include <stdexcept>
#include <string>
#include <type_traits>
#include <unordered_map>
#include <unordered_set>
#include <vector>

// ============================================================================
// 1. AnyGC — GC 管理基类
// ============================================================================

struct AnyGC {
    int gcFlag = 0;

    virtual void gcMark(int flag) {
        if (gcFlag == flag) return;  // 循环保护
        gcFlag = flag;
    }

    virtual ~AnyGC() = default;
};

// ============================================================================
// 2. GC — 标记-清除垃圾回收器
// ============================================================================

class GC {
    static int _currentFlag;
    static std::vector<AnyGC*> _objects;
    static std::vector<AnyGC*> _roots;
    static std::unordered_set<AnyGC*> _registered;

public:
    /// 分配局部对象（非 root），注册到 GC 并返回
    template<typename T>
    static T* allocateLocal(T* obj) {
        if (_registered.insert(static_cast<AnyGC*>(obj)).second) {
            _objects.push_back(static_cast<AnyGC*>(obj));
        }
        return obj;
    }

    /// 分配全局对象（root），注册到 GC 并标记为 root
    template<typename T>
    static T* allocateGlobal(T* obj) {
        auto* base = static_cast<AnyGC*>(obj);
        if (_registered.insert(base).second) {
            _objects.push_back(base);
        }
        // 添加到 roots（避免重复）
        bool found = false;
        for (auto* r : _roots) {
            if (r == base) { found = true; break; }
        }
        if (!found) {
            _roots.push_back(base);
        }
        return obj;
    }

    /// 从 root 集合移除
    static void removeRoot(AnyGC* obj) {
        _roots.erase(
            std::remove(_roots.begin(), _roots.end(), obj),
            _roots.end());
    }

    /// 执行一轮标记-清除，返回回收数量
    static int collect() {
        _currentFlag++;
        int flag = _currentFlag;

        // 标记阶段
        for (auto* root : _roots) {
            root->gcMark(flag);
        }

        // 清除阶段
        int before = static_cast<int>(_objects.size());
        auto newEnd = std::remove_if(_objects.begin(), _objects.end(),
            [flag](AnyGC* obj) { return obj->gcFlag != flag; });
        // 删除未被标记的对象
        for (auto it = newEnd; it != _objects.end(); ++it) {
            _registered.erase(*it);
            delete *it;
        }
        _objects.erase(newEnd, _objects.end());

        // 同步清理 roots
        _roots.erase(
            std::remove_if(_roots.begin(), _roots.end(),
                [flag](AnyGC* obj) { return obj->gcFlag != flag; }),
            _roots.end());

        return before - static_cast<int>(_objects.size());
    }

    static int objectCount() { return static_cast<int>(_objects.size()); }
    static int rootCount() { return static_cast<int>(_roots.size()); }

    /// 重置 GC 状态（测试用，会泄漏未删除对象）
    static void reset() {
        for (auto* obj : _objects) delete obj;
        _objects.clear();
        _roots.clear();
        _registered.clear();
        _currentFlag = 0;
    }
};

// 静态成员定义（放在 .cpp 或 inline）
inline int GC::_currentFlag = 0;
inline std::vector<AnyGC*> GC::_objects;
inline std::vector<AnyGC*> GC::_roots;
inline std::unordered_set<AnyGC*> GC::_registered;

// ============================================================================
// 前向声明
// ============================================================================

struct VPtr;
struct TypeFunction;

// ============================================================================
// 3. AnyPtr — 标签联合（替代 Dart 的 dynamic）
// ============================================================================

struct AnyPtr {
    enum Tag {
        NULL_TAG = 0,
        INT_TAG,
        DOUBLE_TAG,
        BOOL_TAG,
        STRING_TAG,
        VPTR_TAG,
        TYPE_FUNC_TAG,
        GC_TAG      // 其他 AnyGC 子类
    };

    Tag tag;
    union Data {
        int64_t intVal;
        double doubleVal;
        bool boolVal;
        std::string* stringPtr;   // 堆分配（union 不能放非 POD）
        VPtr* vptrPtr;
        TypeFunction* typeFnPtr;
        AnyGC* gcPtr;
        void* rawPtr;

        Data() : intVal(0) {}
    } data;

    // ── 构造函数 ──

    AnyPtr() : tag(NULL_TAG) { data.intVal = 0; }

    // 拷贝构造
    AnyPtr(const AnyPtr& other) : tag(other.tag) {
        _copyFrom(other);
    }

    // 移动构造
    AnyPtr(AnyPtr&& other) noexcept : tag(other.tag) {
        data = other.data;
        other.tag = NULL_TAG;
        other.data.intVal = 0;
    }

    // 隐式转换构造函数 - 允许 TypeFunction* 隐式转换为 AnyPtr
    AnyPtr(TypeFunction* fn) : tag(TYPE_FUNC_TAG) {
        data.typeFnPtr = fn;
    }

    // 隐式转换构造函数 - 允许 VPtr* 隐式转换为 AnyPtr
    AnyPtr(VPtr* vptr) : tag(VPTR_TAG) {
        data.vptrPtr = vptr;
    }

    // 隐式转换构造函数 - 允许 AnyGC* 隐式转换为 AnyPtr
    AnyPtr(AnyGC* gc) : tag(GC_TAG) {
        data.gcPtr = gc;
    }

    // 拷贝赋值
    AnyPtr& operator=(const AnyPtr& other) {
        if (this != &other) {
            _cleanup();
            tag = other.tag;
            _copyFrom(other);
        }
        return *this;
    }

    // 移动赋值
    AnyPtr& operator=(AnyPtr&& other) noexcept {
        if (this != &other) {
            _cleanup();
            tag = other.tag;
            data = other.data;
            other.tag = NULL_TAG;
            other.data.intVal = 0;
        }
        return *this;
    }

    ~AnyPtr() { _cleanup(); }

    // ── 工厂方法 ──

    static AnyPtr null() { return AnyPtr(); }

    static AnyPtr fromInt(int64_t v) {
        AnyPtr p;
        p.tag = INT_TAG;
        p.data.intVal = v;
        return p;
    }

    static AnyPtr fromDouble(double v) {
        AnyPtr p;
        p.tag = DOUBLE_TAG;
        p.data.doubleVal = v;
        return p;
    }

    static AnyPtr fromBool(bool v) {
        AnyPtr p;
        p.tag = BOOL_TAG;
        p.data.boolVal = v;
        return p;
    }

    static AnyPtr fromString(const std::string& v) {
        AnyPtr p;
        p.tag = STRING_TAG;
        p.data.stringPtr = new std::string(v);
        return p;
    }

    static AnyPtr fromString(std::string&& v) {
        AnyPtr p;
        p.tag = STRING_TAG;
        p.data.stringPtr = new std::string(std::move(v));
        return p;
    }

    static AnyPtr fromVPtr(VPtr* v) {
        AnyPtr p;
        p.tag = VPTR_TAG;
        p.data.vptrPtr = v;
        return p;
    }

    static AnyPtr fromTypeFunction(TypeFunction* v) {
        AnyPtr p;
        p.tag = TYPE_FUNC_TAG;
        p.data.typeFnPtr = v;
        return p;
    }

    static AnyPtr fromGC(AnyGC* v) {
        AnyPtr p;
        p.tag = GC_TAG;
        p.data.gcPtr = v;
        return p;
    }

    /// 自动分发：根据 C++ 类型选择正确的工厂方法
    static AnyPtr fromAuto(int64_t v) { return fromInt(v); }
    static AnyPtr fromAuto(int v) { return fromInt(static_cast<int64_t>(v)); }
    static AnyPtr fromAuto(double v) { return fromDouble(v); }
    static AnyPtr fromAuto(bool v) { return fromBool(v); }
    static AnyPtr fromAuto(const std::string& v) { return fromString(v); }
    static AnyPtr fromAuto(const char* v) { return fromString(std::string(v)); }
    static AnyPtr fromAuto(VPtr* v) { return fromVPtr(v); }
    static AnyPtr fromAuto(TypeFunction* v) { return fromTypeFunction(v); }
    static AnyPtr fromAuto(AnyGC* v) { return fromGC(v); }
    static AnyPtr fromAuto(AnyPtr v) { return v; }

    // ── 类型查询 ──

    bool isNull() const { return tag == NULL_TAG; }
    bool isInt() const { return tag == INT_TAG; }
    bool isDouble() const { return tag == DOUBLE_TAG; }
    bool isBool() const { return tag == BOOL_TAG; }
    bool isString() const { return tag == STRING_TAG; }
    bool isVPtr() const { return tag == VPTR_TAG; }
    bool isTypeFunction() const { return tag == TYPE_FUNC_TAG; }
    bool isGC() const { return tag == GC_TAG; }

    // ── 提取器 ──

    int64_t toInt() const {
        switch (tag) {
            case INT_TAG: return data.intVal;
            case DOUBLE_TAG: return static_cast<int64_t>(data.doubleVal);
            case BOOL_TAG: return data.boolVal ? 1 : 0;
            default: return 0;
        }
    }

    double toDouble() const {
        switch (tag) {
            case INT_TAG: return static_cast<double>(data.intVal);
            case DOUBLE_TAG: return data.doubleVal;
            case BOOL_TAG: return data.boolVal ? 1.0 : 0.0;
            default: return 0.0;
        }
    }

    bool toBool() const {
        switch (tag) {
            case INT_TAG: return data.intVal != 0;
            case DOUBLE_TAG: return data.doubleVal != 0.0;
            case BOOL_TAG: return data.boolVal;
            case STRING_TAG: return data.stringPtr && !data.stringPtr->empty();
            case NULL_TAG: return false;
            default: return true;  // 非空对象为 true
        }
    }

    std::string toStringValue() const;  // 声明，实现在 VPtr 之后

    VPtr* toVPtr() const;          // 声明，实现在 VPtr 定义之后
    TypeFunction* toTypeFunction() const;  // 声明，实现在 TypeFunction 定义之后
    AnyGC* toGC() const;           // 声明，实现在 VPtr 定义之后

    /// 模板 cast：将 AnyPtr 中的值提取为指定 C++ 类型
    template<typename T>
    T castTo() const;

    // ── 比较 ──

    bool operator==(const AnyPtr& other) const {
        if (tag != other.tag) return false;
        switch (tag) {
            case NULL_TAG: return true;
            case INT_TAG: return data.intVal == other.data.intVal;
            case DOUBLE_TAG: return data.doubleVal == other.data.doubleVal;
            case BOOL_TAG: return data.boolVal == other.data.boolVal;
            case STRING_TAG: return *data.stringPtr == *other.data.stringPtr;
            case VPTR_TAG: return data.vptrPtr == other.data.vptrPtr;
            case TYPE_FUNC_TAG: return data.typeFnPtr == other.data.typeFnPtr;
            case GC_TAG: return data.gcPtr == other.data.gcPtr;
            default: return false;
        }
    }

    bool operator!=(const AnyPtr& other) const { return !(*this == other); }

private:
    void _cleanup() {
        if (tag == STRING_TAG && data.stringPtr) {
            delete data.stringPtr;
            data.stringPtr = nullptr;
        }
    }

    void _copyFrom(const AnyPtr& other) {
        if (other.tag == STRING_TAG && other.data.stringPtr) {
            data.stringPtr = new std::string(*other.data.stringPtr);
        } else {
            data = other.data;
        }
    }
};

// ============================================================================
// 4. VPtr — 虚表基类
// ============================================================================

struct VPtr : AnyGC {
    std::string _typeName;
    std::unordered_map<std::string, void*> vptr;

    VPtr() : _typeName("VPtr") {
        vptr["toString"] = nullptr;
        vptr["operatorEq"] = nullptr;
        vptr["get_hashCode"] = nullptr;
    }

    virtual std::string toString() {
        auto it = vptr.find("toString");
        if (it != vptr.end() && it->second != nullptr) {
            using Fn = std::string(*)(AnyPtr);
            auto fn = reinterpret_cast<Fn>(it->second);
            return fn(AnyPtr::fromVPtr(this));
        }
        return _typeName;
    }

    bool equals(const VPtr& other) const {
        auto it = vptr.find("operatorEq");
        if (it != vptr.end() && it->second != nullptr) {
            using Fn = bool(*)(AnyPtr, AnyPtr);
            auto fn = reinterpret_cast<Fn>(it->second);
            return fn(AnyPtr::fromVPtr(const_cast<VPtr*>(this)),
                      AnyPtr::fromVPtr(const_cast<VPtr*>(&other)));
        }
        return this == &other;
    }

    int64_t getHashCode() const {
        auto it = vptr.find("get_hashCode");
        if (it != vptr.end() && it->second != nullptr) {
            using Fn = int64_t(*)(AnyPtr);
            auto fn = reinterpret_cast<Fn>(it->second);
            return fn(AnyPtr::fromVPtr(const_cast<VPtr*>(this)));
        }
        return reinterpret_cast<int64_t>(this);
    }

    /// 类型安全的向下转型
    template<typename T>
    T* castTo() {
        return static_cast<T*>(this);
    }

    void gcMark(int flag) override {
        if (gcFlag == flag) return;
        AnyGC::gcMark(flag);
        // 子类应覆写 gcMark 来标记自身字段
    }
};

// AnyPtr::toStringValue 实现（依赖 VPtr）
inline std::string AnyPtr::toStringValue() const {
    switch (tag) {
        case NULL_TAG: return "null";
        case INT_TAG: return std::to_string(data.intVal);
        case DOUBLE_TAG: {
            std::ostringstream oss;
            oss << data.doubleVal;
            return oss.str();
        }
        case BOOL_TAG: return data.boolVal ? "true" : "false";
        case STRING_TAG: return data.stringPtr ? *data.stringPtr : "null";
        case VPTR_TAG:
            if (data.vptrPtr) return data.vptrPtr->toString();
            return "null";
        case TYPE_FUNC_TAG: return "Closure";
        case GC_TAG: return "Instance";
        default: return "unknown";
    }
}

// AnyPtr::toVPtr 实现（依赖 VPtr 完整类型）
inline VPtr* AnyPtr::toVPtr() const {
    if (tag == VPTR_TAG) return data.vptrPtr;
    if (tag == GC_TAG) return dynamic_cast<VPtr*>(data.gcPtr);
    return nullptr;
}

// AnyPtr::castTo 特化
template<> inline int64_t AnyPtr::castTo<int64_t>() const { return toInt(); }
template<> inline double AnyPtr::castTo<double>() const { return toDouble(); }
template<> inline bool AnyPtr::castTo<bool>() const { return toBool(); }
template<> inline std::string AnyPtr::castTo<std::string>() const {
    if (tag == STRING_TAG && data.stringPtr) return *data.stringPtr;
    return toStringValue();
}
template<> inline AnyPtr AnyPtr::castTo<AnyPtr>() const { return *this; }

// ============================================================================
// 5. Box 类型 — 闭包捕获引用语义
// ============================================================================

struct IntBox : AnyGC {
    int64_t value;
    IntBox(int64_t v) : value(v) {}
};

struct DoubleBox : AnyGC {
    double value;
    DoubleBox(double v) : value(v) {}
};

struct BoolBox : AnyGC {
    bool value;
    BoolBox(bool v) : value(v) {}
};

struct StringBox : AnyGC {
    std::string value;
    StringBox(const std::string& v) : value(v) {}
};

struct ObjectBox : AnyGC {
    AnyPtr value;
    ObjectBox(AnyPtr v) : value(std::move(v)) {}

    void gcMark(int flag) override {
        if (gcFlag == flag) return;
        AnyGC::gcMark(flag);
        AnyGC* held = value.toGC();
        if (held) held->gcMark(flag);
    }
};

// ============================================================================
// 6. TypeFunction 层级 — 可调用闭包基类
// ============================================================================

struct TypeFunction : AnyGC {
    void* closureCall = nullptr;

    void gcMark(int flag) override {
        if (gcFlag == flag) return;
        AnyGC::gcMark(flag);
    }
};

// AnyPtr::toTypeFunction 实现（依赖 TypeFunction 完整类型）
inline TypeFunction* AnyPtr::toTypeFunction() const {
    if (tag == TYPE_FUNC_TAG) return data.typeFnPtr;
    if (tag == GC_TAG) return dynamic_cast<TypeFunction*>(data.gcPtr);
    return nullptr;
}

// AnyPtr::toGC 实现（依赖 VPtr + TypeFunction 完整类型）
inline AnyGC* AnyPtr::toGC() const {
    switch (tag) {
        case VPTR_TAG: return static_cast<AnyGC*>(data.vptrPtr);
        case TYPE_FUNC_TAG: return static_cast<AnyGC*>(data.typeFnPtr);
        case GC_TAG: return data.gcPtr;
        default: return nullptr;
    }
}

// TypeFunction0<R>
template<typename R>
struct TypeFunction0 : TypeFunction {
    R call() {
        using Fn = R(*)(AnyPtr);
        auto fn = reinterpret_cast<Fn>(closureCall);
        return fn(AnyPtr::fromTypeFunction(this));
    }
};

// TypeFunction1<R, T1>
template<typename R, typename T1>
struct TypeFunction1 : TypeFunction {
    R call(T1 a1) {
        using Fn = R(*)(AnyPtr, T1);
        auto fn = reinterpret_cast<Fn>(closureCall);
        return fn(AnyPtr::fromTypeFunction(this), a1);
    }
};

// TypeFunction2<R, T1, T2>
template<typename R, typename T1, typename T2>
struct TypeFunction2 : TypeFunction {
    R call(T1 a1, T2 a2) {
        using Fn = R(*)(AnyPtr, T1, T2);
        auto fn = reinterpret_cast<Fn>(closureCall);
        return fn(AnyPtr::fromTypeFunction(this), a1, a2);
    }
};

// TypeFunction3
template<typename R, typename T1, typename T2, typename T3>
struct TypeFunction3 : TypeFunction {
    R call(T1 a1, T2 a2, T3 a3) {
        using Fn = R(*)(AnyPtr, T1, T2, T3);
        auto fn = reinterpret_cast<Fn>(closureCall);
        return fn(AnyPtr::fromTypeFunction(this), a1, a2, a3);
    }
};

// TypeFunction4
template<typename R, typename T1, typename T2, typename T3, typename T4>
struct TypeFunction4 : TypeFunction {
    R call(T1 a1, T2 a2, T3 a3, T4 a4) {
        using Fn = R(*)(AnyPtr, T1, T2, T3, T4);
        auto fn = reinterpret_cast<Fn>(closureCall);
        return fn(AnyPtr::fromTypeFunction(this), a1, a2, a3, a4);
    }
};

// TypeFunction5
template<typename R, typename T1, typename T2, typename T3, typename T4, typename T5>
struct TypeFunction5 : TypeFunction {
    R call(T1 a1, T2 a2, T3 a3, T4 a4, T5 a5) {
        using Fn = R(*)(AnyPtr, T1, T2, T3, T4, T5);
        auto fn = reinterpret_cast<Fn>(closureCall);
        return fn(AnyPtr::fromTypeFunction(this), a1, a2, a3, a4, a5);
    }
};

// TypeFunction6
template<typename R, typename T1, typename T2, typename T3, typename T4,
         typename T5, typename T6>
struct TypeFunction6 : TypeFunction {
    R call(T1 a1, T2 a2, T3 a3, T4 a4, T5 a5, T6 a6) {
        using Fn = R(*)(AnyPtr, T1, T2, T3, T4, T5, T6);
        auto fn = reinterpret_cast<Fn>(closureCall);
        return fn(AnyPtr::fromTypeFunction(this), a1, a2, a3, a4, a5, a6);
    }
};

// TypeFunction7
template<typename R, typename T1, typename T2, typename T3, typename T4,
         typename T5, typename T6, typename T7>
struct TypeFunction7 : TypeFunction {
    R call(T1 a1, T2 a2, T3 a3, T4 a4, T5 a5, T6 a6, T7 a7) {
        using Fn = R(*)(AnyPtr, T1, T2, T3, T4, T5, T6, T7);
        auto fn = reinterpret_cast<Fn>(closureCall);
        return fn(AnyPtr::fromTypeFunction(this), a1, a2, a3, a4, a5, a6, a7);
    }
};

// TypeFunction8
template<typename R, typename T1, typename T2, typename T3, typename T4,
         typename T5, typename T6, typename T7, typename T8>
struct TypeFunction8 : TypeFunction {
    R call(T1 a1, T2 a2, T3 a3, T4 a4, T5 a5, T6 a6, T7 a7, T8 a8) {
        using Fn = R(*)(AnyPtr, T1, T2, T3, T4, T5, T6, T7, T8);
        auto fn = reinterpret_cast<Fn>(closureCall);
        return fn(AnyPtr::fromTypeFunction(this), a1, a2, a3, a4, a5, a6, a7, a8);
    }
};

// ============================================================================
// 7. 静态集合 — Array / StaticList / StaticMap / StaticSet / StaticIterator
// ============================================================================

// ── 异常前向声明 ──

struct DartException;
struct DartRangeError;
struct DartStateError;

// ── Array<T> ──

template<typename T>
struct Array : AnyGC {
    std::vector<T> _storage;

    Array() = default;
    Array(int size, T fill = T()) : _storage(size, fill) {}
    Array(std::initializer_list<T> init) : _storage(init) {}

    template<typename Iter>
    Array(Iter begin, Iter end) : _storage(begin, end) {}

    int length() const { return static_cast<int>(_storage.size()); }

    T& operator[](int index) {
        if (index < 0 || index >= length()) {
            throw std::out_of_range("Index " + std::to_string(index) +
                " out of range [0.." + std::to_string(length()) + ")");
        }
        return _storage[index];
    }

    const T& operator[](int index) const {
        if (index < 0 || index >= length()) {
            throw std::out_of_range("Index " + std::to_string(index) +
                " out of range [0.." + std::to_string(length()) + ")");
        }
        return _storage[index];
    }

    void add(const T& element) { _storage.push_back(element); }
    void add(T&& element) { _storage.push_back(std::move(element)); }

    void insert(int index, const T& element) {
        if (index < 0 || index > length()) {
            throw std::out_of_range("Insert index out of range");
        }
        _storage.insert(_storage.begin() + index, element);
    }

    T removeAt(int index) {
        if (index < 0 || index >= length()) {
            throw std::out_of_range("RemoveAt index out of range");
        }
        T val = std::move(_storage[index]);
        _storage.erase(_storage.begin() + index);
        return val;
    }

    int indexOf(const T& element) const {
        for (int i = 0; i < length(); i++) {
            if (_storage[i] == element) return i;
        }
        return -1;
    }

    bool contains(const T& element) const { return indexOf(element) != -1; }

    void clear() { _storage.clear(); }

    void gcMark(int flag) override {
        if (gcFlag == flag) return;
        AnyGC::gcMark(flag);
        // 递归标记元素（如果 T 是指针类型）
        if constexpr (std::is_pointer_v<T>) {
            using Pointee = std::remove_pointer_t<T>;
            if constexpr (std::is_base_of_v<AnyGC, Pointee>) {
                for (auto& elem : _storage) {
                    if (elem) elem->gcMark(flag);
                }
            }
        }
    }
};

// ── StaticIterator<T> ──

template<typename T>
struct StaticIterator : AnyGC {
    Array<T>* _data;
    int _index;

    StaticIterator(Array<T>* data) : _data(data), _index(0) {}

    bool moveNext() {
        _index++;
        return _index <= _data->length();
    }

    T current() const {
        return (*_data)[_index - 1];
    }

    void reset() { _index = 0; }
};

// ── StaticList<T> ──

template<typename T>
struct StaticList : AnyGC {
    Array<T>* _data;

    StaticList() : _data(GC::allocateLocal(new Array<T>())) {}

    StaticList(std::initializer_list<T> init)
        : _data(GC::allocateLocal(new Array<T>(init))) {}

    static StaticList* of(std::initializer_list<T> elements) {
        return GC::allocateLocal(new StaticList(elements));
    }

    static StaticList* empty() {
        return GC::allocateLocal(new StaticList());
    }

    int length() const { return _data->length(); }
    bool isEmpty() const { return _data->length() == 0; }
    bool isNotEmpty() const { return _data->length() > 0; }

    T& operator[](int index) { return (*_data)[index]; }
    const T& operator[](int index) const { return (*_data)[index]; }

    void add(const T& element) { _data->add(element); }
    void add(T&& element) { _data->add(std::move(element)); }

    void insert(int index, const T& element) { _data->insert(index, element); }

    T removeAt(int index) { return _data->removeAt(index); }

    bool remove(const T& element) {
        int idx = _data->indexOf(element);
        if (idx == -1) return false;
        _data->removeAt(idx);
        return true;
    }

    int indexOf(const T& element) const { return _data->indexOf(element); }
    bool contains(const T& element) const { return _data->contains(element); }
    void clear() { _data->clear(); }

    T first() const {
        if (isEmpty()) throw std::runtime_error("No element");
        return (*_data)[0];
    }

    T last() const {
        if (isEmpty()) throw std::runtime_error("No element");
        return (*_data)[_data->length() - 1];
    }

    StaticIterator<T>* iterator() {
        return GC::allocateLocal(new StaticIterator<T>(_data));
    }

    // Iterator support for range-based for loops
    T* begin() { return _data->begin(); }
    T* end() { return _data->end(); }
    const T* begin() const { return _data->begin(); }
    const T* end() const { return _data->end(); }

    // reversed property - returns a new reversed list
    StaticList<T>* reversed() const {
        auto* result = new StaticList<T>();
        for (int i = _data->length() - 1; i >= 0; i--) {
            result->add((*_data)[i]);
        }
        return GC::allocateLocal(result);
    }

    // join method
    std::string join(const std::string& separator = "") const {
        std::string result;
        for (int i = 0; i < _data->length(); i++) {
            if (i > 0) result += separator;
            result += dart_str((*_data)[i]);
        }
        return result;
    }

    // 高阶方法

    template<typename R>
    StaticList<R>* map(R (*func)(T)) const {
        auto* result = new StaticList<R>();
        for (int i = 0; i < _data->length(); i++) {
            result->add(func((*_data)[i]));
        }
        return GC::allocateLocal(result);
    }

    // Overload for TypeFunction1
    template<typename R>
    StaticList<R>* map(TypeFunction1<R, T>* func) const {
        auto* result = new StaticList<R>();
        for (int i = 0; i < _data->length(); i++) {
            result->add(func->call((*_data)[i]));
        }
        return GC::allocateLocal(result);
    }

    StaticList<T>* where(bool (*func)(T)) const {
        auto* result = new StaticList<T>();
        for (int i = 0; i < _data->length(); i++) {
            if (func((*_data)[i])) {
                result->add((*_data)[i]);
            }
        }
        return GC::allocateLocal(result);
    }

    void forEach(void (*func)(T)) const {
        for (int i = 0; i < _data->length(); i++) {
            func((*_data)[i]);
        }
    }

    void gcMark(int flag) override {
        if (gcFlag == flag) return;
        AnyGC::gcMark(flag);
        if (_data) _data->gcMark(flag);
    }
};

// ── StaticMap<K,V> ──

template<typename K, typename V>
struct StaticMap : AnyGC {
    Array<K>* _keys;
    Array<V>* _values;

    StaticMap()
        : _keys(GC::allocateLocal(new Array<K>())),
          _values(GC::allocateLocal(new Array<V>())) {}

    static StaticMap* empty() {
        return GC::allocateLocal(new StaticMap());
    }

    int length() const { return _keys->length(); }
    bool isEmpty() const { return _keys->length() == 0; }
    bool isNotEmpty() const { return _keys->length() > 0; }

    bool containsKey(const K& key) const {
        return _keys->indexOf(key) != -1;
    }

    V* operator[](const K& key) {
        int idx = _keys->indexOf(key);
        if (idx == -1) return nullptr;
        return &(*_values)[idx];
    }

    void set(const K& key, const V& value) {
        int idx = _keys->indexOf(key);
        if (idx != -1) {
            (*_values)[idx] = value;
        } else {
            _keys->add(key);
            _values->add(value);
        }
    }

    V remove(const K& key) {
        int idx = _keys->indexOf(key);
        if (idx == -1) return V();
        _keys->removeAt(idx);
        return _values->removeAt(idx);
    }

    Array<K>* keys() const { return _keys; }
    Array<V>* values() const { return _values; }

    void clear() {
        _keys->clear();
        _values->clear();
    }

    void gcMark(int flag) override {
        if (gcFlag == flag) return;
        AnyGC::gcMark(flag);
        if (_keys) _keys->gcMark(flag);
        if (_values) _values->gcMark(flag);
    }
};

// ── StaticSet<T> ──

template<typename T>
struct StaticSet : AnyGC {
    Array<T>* _data;

    StaticSet() : _data(GC::allocateLocal(new Array<T>())) {}

    StaticSet(std::initializer_list<T> init)
        : _data(GC::allocateLocal(new Array<T>(init))) {}

    static StaticSet* of(std::initializer_list<T> elements) {
        return GC::allocateLocal(new StaticSet(elements));
    }

    static StaticSet* empty() {
        return GC::allocateLocal(new StaticSet());
    }

    int length() const { return _data->length(); }
    bool isEmpty() const { return _data->length() == 0; }

    bool contains(const T& element) const {
        return _data->contains(element);
    }

    bool add(const T& element) {
        if (_data->contains(element)) return false;
        _data->add(element);
        return true;
    }

    bool remove(const T& element) {
        return _data->remove(element);
    }

    void clear() { _data->clear(); }

    StaticIterator<T>* iterator() {
        return GC::allocateLocal(new StaticIterator<T>(_data));
    }

    void gcMark(int flag) override {
        if (gcFlag == flag) return;
        AnyGC::gcMark(flag);
        if (_data) _data->gcMark(flag);
    }
};

// ── StaticMapEntry<K,V> ──

template<typename K, typename V>
struct StaticMapEntry {
    K key;
    V value;

    StaticMapEntry(K k, V v) : key(std::move(k)), value(std::move(v)) {}
};

// ============================================================================
// 8. Promise / GlobalScheduler / smAwait — 协作式异步
// ============================================================================

// ── PromiseBase ──

struct PromiseBase : AnyGC {
    enum State { READY, PENDING, COMPLETED, ERROR };

    State state = PENDING;
    AnyPtr result;
    AnyPtr error;
    std::function<void()> startCallback;
    std::function<bool()> onTick;

    void setStartCallback(std::function<void()> cb) {
        startCallback = std::move(cb);
        state = READY;
    }

    void complete(AnyPtr value) {
        result = std::move(value);
        state = COMPLETED;
    }

    void completeError(AnyPtr err) {
        error = std::move(err);
        state = ERROR;
    }

    bool isCompleted() const { return state == COMPLETED; }
    bool isError() const { return state == ERROR; }
    bool isReady() const { return state == READY; }
    bool isPending() const { return state == PENDING; }

    void gcMark(int flag) override {
        if (gcFlag == flag) return;
        AnyGC::gcMark(flag);
        AnyGC* r = result.toGC();
        if (r) r->gcMark(flag);
        AnyGC* e = error.toGC();
        if (e) e->gcMark(flag);
    }
};

// ── Promise<T> ──

template<typename T>
struct Promise : PromiseBase {
    T typedResult() const { return result.castTo<T>(); }

    void completeTyped(T value) {
        complete(AnyPtr::fromAuto(std::move(value)));
    }

    // Static factory methods for creating resolved promises
    static Promise<T>* resolved(T value) {
        auto* promise = GC::allocateLocal(new Promise<T>());
        promise->complete(AnyPtr::fromAuto(std::move(value)));
        return promise;
    }

    // Alias for resolved() - Dart compatibility
    static Promise<T>* value(T value) {
        return resolved(std::move(value));
    }
};

// ── GlobalScheduler ──

class GlobalScheduler {
    std::vector<PromiseBase*> _activePromises;
    std::vector<std::pair<int, std::function<void()>>> _delayedTasks;
    std::vector<PromiseBase*> _readyPromises;
    int _tickCount = 0;

    GlobalScheduler() = default;

public:
    static GlobalScheduler& instance() {
        static GlobalScheduler inst;
        return inst;
    }

    void registerActivePromise(PromiseBase* p) {
        _activePromises.push_back(p);
    }

    void registerDelayedTask(int ticks, std::function<void()> cb) {
        _delayedTasks.push_back({_tickCount + ticks, std::move(cb)});
    }

    void registerReadyPromise(PromiseBase* p) {
        _readyPromises.push_back(p);
    }

    void tick() {
        _tickCount++;

        // 处理 ready 的 Promise
        auto readyCopy = _readyPromises;
        _readyPromises.clear();
        for (auto* p : readyCopy) {
            if (p->isReady() && p->startCallback) {
                p->state = PromiseBase::PENDING;
                p->startCallback();
            }
        }

        // 处理延迟任务
        for (auto it = _delayedTasks.begin(); it != _delayedTasks.end(); ) {
            if (it->first <= _tickCount) {
                it->second();
                it = _delayedTasks.erase(it);
            } else {
                ++it;
            }
        }

        // 处理 active promises
        auto activeCopy = _activePromises;
        _activePromises.clear();
        for (auto* p : activeCopy) {
            if (p->isCompleted() || p->isError()) continue;
            if (p->onTick) {
                p->onTick();
            }
            if (!p->isCompleted() && !p->isError()) {
                _activePromises.push_back(p);
            }
        }
    }

    int tickCount() const { return _tickCount; }

    void reset() {
        _activePromises.clear();
        _delayedTasks.clear();
        _readyPromises.clear();
        _tickCount = 0;
    }
};

// ── smAwait<T> — 阻塞式 await ──

template<typename T>
T smAwait(PromiseBase* promise) {
    if (!promise) {
        throw std::runtime_error("smAwait: null promise");
    }

    // 如果已完成，直接返回
    if (promise->isCompleted()) return promise->result.castTo<T>();
    if (promise->isError()) {
        throw std::runtime_error("Promise completed with error: " +
            promise->error.toStringValue());
    }

    // 如果是 READY，启动回调
    if (promise->isReady() && promise->startCallback) {
        promise->state = PromiseBase::PENDING;
        promise->startCallback();
        if (promise->isCompleted()) return promise->result.castTo<T>();
        if (promise->isError()) {
            throw std::runtime_error("Promise completed with error");
        }
    }

    // 循环 tick 直到完成
    int maxRounds = 100000;
    int rounds = 0;
    while (!promise->isCompleted() && !promise->isError() && rounds < maxRounds) {
        GlobalScheduler::instance().tick();
        rounds++;
    }

    if (rounds >= maxRounds) {
        throw std::runtime_error("smAwait: deadlock detected after " +
            std::to_string(maxRounds) + " ticks");
    }

    if (promise->isError()) {
        throw std::runtime_error("Promise completed with error: " +
            promise->error.toStringValue());
    }

    return promise->result.castTo<T>();
}

// ── promiseDelayed ──

inline PromiseBase* promiseDelayed(int ticks, std::function<AnyPtr()> computation) {
    auto* promise = GC::allocateLocal(new PromiseBase());
    GlobalScheduler::instance().registerDelayedTask(ticks, [promise, computation]() {
        try {
            AnyPtr result = computation();
            promise->complete(std::move(result));
        } catch (const std::exception& e) {
            promise->completeError(AnyPtr::fromString(e.what()));
        }
    });
    return promise;
}

// ── AsyncStateMachine<T> ──

template<typename T>
struct AsyncStateMachine : AnyGC {
    int _state = 0;
    Promise<T>* _promise;

    AsyncStateMachine() {
        _promise = GC::allocateLocal(new Promise<T>());
    }

    virtual void step() = 0;

    void gcMark(int flag) override {
        if (gcFlag == flag) return;
        AnyGC::gcMark(flag);
        if (_promise) _promise->gcMark(flag);
    }
};

// ============================================================================
// 9. 语义包装 — staticPrint / StaticStringBuffer
// ============================================================================

/// 替代 Dart 的 print()，将 AnyPtr 转为字符串输出
inline void staticPrint(const AnyPtr& value) {
    std::cout << value.toStringValue() << std::endl;
}

/// 替代 Dart 的 print()，支持各种类型
inline void staticPrint(int64_t value) {
    std::cout << value << std::endl;
}

inline void staticPrint(double value) {
    std::cout << value << std::endl;
}

inline void staticPrint(bool value) {
    std::cout << (value ? "true" : "false") << std::endl;
}

inline void staticPrint(const std::string& value) {
    std::cout << value << std::endl;
}

inline void staticPrint(const char* value) {
    std::cout << value << std::endl;
}

/// StaticStringBuffer — 替代 Dart 的 StringBuffer
struct StaticStringBuffer : AnyGC {
    std::ostringstream _buf;

    void write(const AnyPtr& value) {
        _buf << value.toStringValue();
    }

    void write(const std::string& value) {
        _buf << value;
    }

    void write(int64_t value) {
        _buf << value;
    }

    void write(double value) {
        _buf << value;
    }

    void write(bool value) {
        _buf << (value ? "true" : "false");
    }

    std::string toString() const {
        return _buf.str();
    }

    int length() const {
        return static_cast<int>(_buf.str().length());
    }

    void clear() {
        _buf.str("");
        _buf.clear();
    }
};

// ============================================================================
// 10. 异常层级
// ============================================================================

struct DartException : std::exception {
    std::string message;
    DartException(const std::string& msg) : message(msg) {}
    const char* what() const noexcept override { return message.c_str(); }
    virtual std::string toString() const { return "Exception: " + message; }
};

struct DartStateError : DartException {
    DartStateError(const std::string& msg) : DartException(msg) {}
    std::string toString() const override { return "StateError: " + message; }
};

struct DartArgumentError : DartException {
    DartArgumentError(const std::string& msg) : DartException(msg) {}
    std::string toString() const override { return "ArgumentError: " + message; }
};

struct DartRangeError : DartException {
    DartRangeError(const std::string& msg) : DartException(msg) {}
    std::string toString() const override { return "RangeError: " + message; }
};

struct DartFormatException : DartException {
    DartFormatException(const std::string& msg) : DartException(msg) {}
    std::string toString() const override { return "FormatException: " + message; }
};

struct DartUnsupportedError : DartException {
    DartUnsupportedError(const std::string& msg) : DartException(msg) {}
    std::string toString() const override { return "UnsupportedError: " + message; }
};

struct DartUnimplementedError : DartException {
    DartUnimplementedError(const std::string& msg) : DartException(msg) {}
    std::string toString() const override { return "UnimplementedError: " + message; }
};

// ============================================================================
// 11. 辅助函数
// ============================================================================

/// dart_is<T> — 运行时类型检查（基于 VPtr 的 _typeName）
template<typename T>
bool dart_is(VPtr* obj) {
    if (!obj) return false;
    return dynamic_cast<T*>(obj) != nullptr;
}

/// dart_is<T> — AnyPtr 版本
template<typename T>
bool dart_is(const AnyPtr& ptr) {
    VPtr* vp = ptr.toVPtr();
    if (!vp) return false;
    return dynamic_cast<T*>(vp) != nullptr;
}

/// dart_cast<T> — 运行时类型转换
template<typename T>
T* dart_cast(VPtr* obj) {
    if (!obj) return nullptr;
    T* result = dynamic_cast<T*>(obj);
    if (!result) {
        throw DartException("Type cast failed: " + obj->_typeName +
            " is not " + std::string(T::staticTypeName()));
    }
    return result;
}

/// dart_cast<T> — AnyPtr 版本
template<typename T>
T* dart_cast(const AnyPtr& ptr) {
    VPtr* vp = ptr.toVPtr();
    if (!vp) {
        throw DartException("Type cast failed: null or non-VPtr");
    }
    return dart_cast<T>(vp);
}

// _toStr 重载集（必须在 dart_str 模板之前声明）
inline std::string _toStr(int64_t v) { return std::to_string(v); }
inline std::string _toStr(int v) { return std::to_string(v); }
inline std::string _toStr(double v) {
    std::ostringstream oss;
    oss << v;
    return oss.str();
}
inline std::string _toStr(bool v) { return v ? "true" : "false"; }
inline std::string _toStr(const std::string& v) { return v; }
inline std::string _toStr(const char* v) { return v ? v : "null"; }
inline std::string _toStr(const AnyPtr& v) { return v.toStringValue(); }
inline std::string _toStr(VPtr* v) { return v ? v->toString() : "null"; }

/// dart_str — 字符串插值辅助（可变参数拼接）
template<typename... Args>
std::string dart_str(Args&&... args) {
    std::ostringstream oss;
    (void)(int[]){0, ((oss << _toStr(std::forward<Args>(args))), 0)...};
    return oss.str();
}

// ============================================================================
// 11.5 String 方法辅助
// ============================================================================

/// dart_str_toUpper — 转换为大写
inline std::string dart_str_toUpper(const std::string& s) {
    std::string result = s;
    std::transform(result.begin(), result.end(), result.begin(), ::toupper);
    return result;
}

/// dart_str_toLower — 转换为小写
inline std::string dart_str_toLower(const std::string& s) {
    std::string result = s;
    std::transform(result.begin(), result.end(), result.begin(), ::tolower);
    return result;
}

/// dart_str_trim — 去除首尾空白
inline std::string dart_str_trim(const std::string& s) {
    size_t start = s.find_first_not_of(" \t\n\r\f\v");
    if (start == std::string::npos) return "";
    size_t end = s.find_last_not_of(" \t\n\r\f\v");
    return s.substr(start, end - start + 1);
}

/// dart_str_trimLeft — 去除左侧空白
inline std::string dart_str_trimLeft(const std::string& s) {
    size_t start = s.find_first_not_of(" \t\n\r\f\v");
    if (start == std::string::npos) return "";
    return s.substr(start);
}

/// dart_str_trimRight — 去除右侧空白
inline std::string dart_str_trimRight(const std::string& s) {
    size_t end = s.find_last_not_of(" \t\n\r\f\v");
    if (end == std::string::npos) return "";
    return s.substr(0, end + 1);
}

/// dart_str_split — 分割字符串
inline StaticList<std::string>* dart_str_split(const std::string& s, const std::string& delimiter) {
    auto* result = new StaticList<std::string>();
    if (delimiter.empty()) {
        // Split into individual characters
        for (char c : s) {
            result->add(std::string(1, c));
        }
    } else {
        size_t start = 0;
        size_t end = s.find(delimiter);
        while (end != std::string::npos) {
            result->add(s.substr(start, end - start));
            start = end + delimiter.length();
            end = s.find(delimiter, start);
        }
        result->add(s.substr(start));
    }
    return GC::allocateLocal(result);
}

/// dart_str_replaceAll — 替换所有匹配
inline std::string dart_str_replaceAll(const std::string& s, const std::string& from, const std::string& to) {
    if (from.empty()) return s;
    std::string result = s;
    size_t start_pos = 0;
    while ((start_pos = result.find(from, start_pos)) != std::string::npos) {
        result.replace(start_pos, from.length(), to);
        start_pos += to.length();
    }
    return result;
}

/// dart_str_padLeft — 左填充
inline std::string dart_str_padLeft(const std::string& s, int width, const std::string& padding) {
    if (s.length() >= width || padding.empty()) return s;
    int padCount = width - s.length();
    std::string result = "";
    while (result.length() < padCount) {
        result += padding;
    }
    return result.substr(0, padCount) + s;
}

/// dart_str_padRight — 右填充
inline std::string dart_str_padRight(const std::string& s, int width, const std::string& padding) {
    if (s.length() >= width || padding.empty()) return s;
    int padCount = width - s.length();
    std::string result = s;
    while (result.length() < width) {
        result += padding;
    }
    return result.substr(0, width);
}

/// dart_str_toStringAsFixed — 格式化浮点数为固定小数位
inline std::string dart_str_toStringAsFixed(double value, int fractionDigits) {
    std::ostringstream oss;
    oss << std::fixed << std::setprecision(fractionDigits) << value;
    return oss.str();
}

// ============================================================================
// 12. Math 辅助
// ============================================================================

namespace DartMath {
    constexpr double PI = 3.14159265358979323846;
    constexpr double E = 2.71828182845904523536;

    inline double sqrt(double x) { return std::sqrt(x); }
    inline double pow(double base, double exp) { return std::pow(base, exp); }
    inline int64_t pow_int(int64_t base, int64_t exp) {
        int64_t result = 1;
        for (int64_t i = 0; i < exp; i++) result *= base;
        return result;
    }
    inline double sin(double x) { return std::sin(x); }
    inline double cos(double x) { return std::cos(x); }
    inline double abs(double x) { return std::abs(x); }
    inline int64_t abs_int(int64_t x) { return x < 0 ? -x : x; }
    inline double min(double a, double b) { return std::min(a, b); }
    inline double max(double a, double b) { return std::max(a, b); }
}

// ============================================================================
// 13. Duration / DateTime / RegExp 包装
// ============================================================================

struct StaticDuration : AnyGC {
    int64_t inMicroseconds;

    StaticDuration(int64_t us = 0) : inMicroseconds(us) {}

    static StaticDuration milliseconds(int64_t ms) {
        return StaticDuration(ms * 1000);
    }
    static StaticDuration seconds(int64_t s) {
        return StaticDuration(s * 1000000);
    }
    static StaticDuration minutes(int64_t m) {
        return StaticDuration(m * 60000000LL);
    }

    int64_t inMilliseconds() const { return inMicroseconds / 1000; }
    int64_t inSeconds() const { return inMicroseconds / 1000000; }
};

struct StaticDateTime : AnyGC {
    int64_t _epochMs;  // 毫秒 since epoch

    StaticDateTime() : _epochMs(0) {}
    StaticDateTime(int64_t epochMs) : _epochMs(epochMs) {}

    static StaticDateTime now() {
        auto now = std::chrono::system_clock::now();
        auto ms = std::chrono::duration_cast<std::chrono::milliseconds>(
            now.time_since_epoch()).count();
        return StaticDateTime(static_cast<int64_t>(ms));
    }

    int64_t millisecondsSinceEpoch() const { return _epochMs; }
};

struct StaticRegExp {
    std::string pattern;

    StaticRegExp(const std::string& pat) : pattern(pat) {}

    bool hasMatch(const std::string& input) const {
        // 简化实现：使用 std::string::find
        return input.find(pattern) != std::string::npos;
    }

    std::string toString() const { return "RegExp(" + pattern + ")"; }
};

#endif // DART2CPP_LOWERED_H
