// ============================================================================
// dart2cpp_lowered.h — OOP-lowered Dart → C++ 运行时库
// ============================================================================
// 本头文件为 dart2cpp 新编译器模块（lib/cpp_compiler/）生成的 C++ 代码
// 提供完整的运行时支持。设计镜像 lib/platform/dart/ 下的分层运行时文件。
//
// 组件清单：
//   1. AnyGC — GC 管理基类
//   2. GC — 标记-清除垃圾回收器
//   3. DartString — 带引用计数的字符串池
//   4. AnyGC — 通用 GC 对象基类（替代 Dart 的 dynamic，基本类型通过 _box 装箱）
//   5. 异常层级 — DartException / DartStateError / ...
//   6. VPtr — 虚表基类
//   7. Box 类型 — 闭包捕获引用语义
//   8. TypeFunction 层级 — 可调用闭包基类（可变参数模板）
//   9. 静态集合 — StaticMapEntry / Array / StaticList / StaticMap / StaticSet
//  10. Promise / GlobalScheduler / smAwait — 协作式异步
//  11. 语义包装 — staticPrint / StaticStringBuffer
//  12. 辅助函数 — dart_cast / dart_is / dart_str
//  13. String 方法辅助
//  14. Math 辅助
//  15. Duration / DateTime / RegExp 包装
// ============================================================================

#ifndef DART2CPP_LOWERED_H
#define DART2CPP_LOWERED_H

#include <algorithm>
#include <any>
#include <atomic>
#include <cassert>
#include <cmath>
#include <cstdint>
#include <functional>
#include <iomanip>
#include <iostream>
#include <memory>
#include <mutex>
#include <sstream>
#include <stdexcept>
#include <string>
#include <type_traits>
#include <unordered_map>
#include <unordered_set>
#include <vector>

// Forward declarations for template functions used in collection templates
template<typename... Args>
std::string dart_str(Args&&... args);

// ============================================================================
// 1. AnyGC — GC 管理基类
// ============================================================================

struct AnyGC {
    int gcFlag = 0;
    bool _gcStatic = false;  // true = 非堆分配（如 singleton），GC 不 delete

    virtual void gcMark(int flag) {
        if (gcFlag == flag) return;  // 循环保护
        gcFlag = flag;
    }

    virtual std::string toString() const { return "Instance"; }

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
    /// 版本1: 接受已创建的对象指针（向后兼容）
    template<typename T>
    static T* allocateLocal(T* obj) {
        if (_registered.insert(static_cast<AnyGC*>(obj)).second) {
            _objects.push_back(static_cast<AnyGC*>(obj));
        }
        return obj;
    }

    /// 版本2: 接受类型和构造参数，内部创建对象（新 API）
    /// 用法: GC::allocateLocal<StaticList<int>>({1, 2, 3})
    template<typename T, typename... Args>
    static T* createLocal(Args&&... args) {
        T* obj = new T(std::forward<Args>(args)...);
        if (_registered.insert(static_cast<AnyGC*>(obj)).second) {
            _objects.push_back(static_cast<AnyGC*>(obj));
        }
        return obj;
    }

    /// 版本3: 专门处理 initializer_list
    template<typename T, typename U>
    static T* createLocal(std::initializer_list<U> init) {
        T* obj = new T(init);
        if (_registered.insert(static_cast<AnyGC*>(obj)).second) {
            _objects.push_back(static_cast<AnyGC*>(obj));
        }
        return obj;
    }

    /// 分配全局对象（root），注册到 GC 并标记为 root
    /// 版本1: 接受已创建的对象指针（向后兼容）
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

    /// 版本2: 接受类型和构造参数，内部创建对象（新 API）
    template<typename T, typename... Args>
    static T* createGlobal(Args&&... args) {
        T* obj = new T(std::forward<Args>(args)...);
        auto* base = static_cast<AnyGC*>(obj);
        if (_registered.insert(base).second) {
            _objects.push_back(base);
        }
        bool found = false;
        for (auto* r : _roots) {
            if (r == base) { found = true; break; }
        }
        if (!found) {
            _roots.push_back(base);
        }
        return obj;
    }

    /// 版本3: 专门处理 initializer_list
    template<typename T, typename U>
    static T* createGlobal(std::initializer_list<U> init) {
        T* obj = new T(init);
        auto* base = static_cast<AnyGC*>(obj);
        if (_registered.insert(base).second) {
            _objects.push_back(base);
        }
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
        // 删除未被标记的对象（跳过 _gcStatic 对象）
        for (auto it = newEnd; it != _objects.end(); ++it) {
            _registered.erase(*it);
            if (!(*it)->_gcStatic) delete *it;
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
        for (auto* obj : _objects) {
            if (!obj->_gcStatic) delete obj;
        }
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
// 3. DartString — 带引用计数的字符串池
// ============================================================================
// 优化：避免频繁分配 std::string
// 使用全局字符串池 + 引用计数，相同字符串共享同一份数据

class StringPool {
public:
    struct Entry {
        std::string data;
        std::atomic<int> refCount;
        Entry(const std::string& s) : data(s), refCount(1) {}
    };

private:
    std::unordered_map<std::string, Entry*> _pool;
    mutable std::mutex _mutex;

    StringPool() = default;
    ~StringPool() {
        for (auto& pair : _pool) {
            delete pair.second;
        }
    }

public:
    static StringPool& instance() {
        static StringPool pool;
        return pool;
    }

    // 禁用拷贝
    StringPool(const StringPool&) = delete;
    StringPool& operator=(const StringPool&) = delete;

    Entry* intern(const std::string& str) {
        std::lock_guard<std::mutex> lock(_mutex);
        auto it = _pool.find(str);
        if (it != _pool.end()) {
            ++it->second->refCount;
            return it->second;
        }
        auto* entry = new Entry(str);
        _pool[str] = entry;
        return entry;
    }

    void release(Entry* entry) {
        if (!entry) return;
        std::lock_guard<std::mutex> lock(_mutex);
        if (--entry->refCount == 0) {
            _pool.erase(entry->data);
            delete entry;
        }
    }

    size_t size() const {
        std::lock_guard<std::mutex> lock(_mutex);
        return _pool.size();
    }
};

// DartString — 轻量级字符串包装，支持高效的拷贝和移动
class DartString {
private:
    StringPool::Entry* _entry;

public:
    DartString() : _entry(nullptr) {}

    DartString(const std::string& str) : _entry(StringPool::instance().intern(str)) {}

    DartString(const char* str) : _entry(StringPool::instance().intern(str ? str : "")) {}

    DartString(const DartString& other) : _entry(other._entry) {
        if (_entry) {
            ++_entry->refCount;
        }
    }

    DartString(DartString&& other) noexcept : _entry(other._entry) {
        other._entry = nullptr;
    }

    ~DartString() {
        if (_entry) {
            StringPool::instance().release(_entry);
        }
    }

    DartString& operator=(const DartString& other) {
        if (this != &other) {
            if (_entry) {
                StringPool::instance().release(_entry);
            }
            _entry = other._entry;
            if (_entry) {
                ++_entry->refCount;
            }
        }
        return *this;
    }

    DartString& operator=(DartString&& other) noexcept {
        if (this != &other) {
            if (_entry) {
                StringPool::instance().release(_entry);
            }
            _entry = other._entry;
            other._entry = nullptr;
        }
        return *this;
    }

    const std::string& str() const {
        static const std::string empty;
        return _entry ? _entry->data : empty;
    }

    const char* c_str() const {
        return _entry ? _entry->data.c_str() : "";
    }

    bool empty() const {
        return !_entry || _entry->data.empty();
    }

    size_t size() const {
        return _entry ? _entry->data.size() : 0;
    }

    bool operator==(const DartString& other) const {
        if (_entry == other._entry) return true;
        if (!_entry || !other._entry) return false;
        return _entry->data == other._entry->data;
    }

    bool operator!=(const DartString& other) const {
        return !(*this == other);
    }

    bool operator<(const DartString& other) const {
        if (!_entry && !other._entry) return false;
        if (!_entry) return true;
        if (!other._entry) return false;
        return _entry->data < other._entry->data;
    }

    DartString operator+(const DartString& other) const {
        return DartString(str() + other.str());
    }

    DartString operator+(const std::string& other) const {
        return DartString(str() + other);
    }

    friend std::ostream& operator<<(std::ostream& os, const DartString& s) {
        return os << s.str();
    }
};

// std::hash 特化，支持 DartString 用于 unordered 容器
namespace std {
    template<>
    struct hash<DartString> {
        size_t operator()(const DartString& s) const {
            return hash<string>()(s.str());
        }
    };
}

// ============================================================================
// 前向声明
// ============================================================================

struct VPtr;
struct TypeFunction;

// Forward declaration for DartException (defined later)
struct DartException;

// ============================================================================
// 4. 异常层级 — DartException / DartStateError / ...
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

inline int64_t dart_stoll(const std::string& s) {
    try {
        return std::stoll(s);
    } catch (...) {
        throw DartFormatException(s);
    }
}

inline double dart_stod(const std::string& s) {
    try {
        return std::stod(s);
    } catch (...) {
        throw DartFormatException(s);
    }
}

struct DartUnsupportedError : DartException {
    DartUnsupportedError(const std::string& msg) : DartException(msg) {}
    std::string toString() const override { return "UnsupportedError: " + message; }
};

struct DartUnimplementedError : DartException {
    DartUnimplementedError(const std::string& msg) : DartException(msg) {}
    std::string toString() const override { return "UnimplementedError: " + message; }
};

/// ReachabilityErrorValue — 用于模式匹配穷尽性检查的占位类型
struct ReachabilityErrorValue : AnyGC {};

struct ReachabilityError {
    std::string _msg;
    std::string toStringValue() const { return _msg; }
};

inline ReachabilityError ReachabilityError_new(ReachabilityErrorValue* /*this_*/, const std::string& msg) {
    return ReachabilityError{msg};
}

// Forward declaration of dynAs (used by VPtr methods below)
template<typename T> T dynAs(AnyGC* obj);

// ============================================================================
// 5. VPtr — 虚表基类
// ============================================================================

struct VPtr : AnyGC {
    std::string _typeName;

    VPtr() : _typeName("VPtr") {}

    virtual std::unordered_map<std::string, void*>& getVptrMap() {
        static std::unordered_map<std::string, void*> baseMap;
        return baseMap;
    }

    virtual std::string toString() const {
        auto& vmap = const_cast<VPtr*>(this)->getVptrMap();
        auto it = vmap.find("toString");
        if (it != vmap.end() && it->second != nullptr) {
            using Fn = AnyGC*(*)(AnyGC*);
            auto fn = reinterpret_cast<Fn>(it->second);
            AnyGC* result = fn(static_cast<AnyGC*>(const_cast<VPtr*>(this)));
            return result ? result->toString() : "null";
        }
        return _typeName;
    }

    bool equals(const VPtr& other) const {
        auto& vmap = const_cast<VPtr*>(this)->getVptrMap();
        auto it = vmap.find("operatorEq");
        if (it != vmap.end() && it->second != nullptr) {
            using Fn = AnyGC*(*)(AnyGC*, AnyGC*);
            auto fn = reinterpret_cast<Fn>(it->second);
            AnyGC* result = fn(static_cast<AnyGC*>(const_cast<VPtr*>(this)),
                               static_cast<AnyGC*>(const_cast<VPtr*>(&other)));
            return dynAs<bool>(result);
        }
        return this == &other;
    }

    int64_t getHashCode() const {
        auto& vmap = const_cast<VPtr*>(this)->getVptrMap();
        auto it = vmap.find("get_hashCode");
        if (it != vmap.end() && it->second != nullptr) {
            using Fn = AnyGC*(*)(AnyGC*);
            auto fn = reinterpret_cast<Fn>(it->second);
            AnyGC* result = fn(static_cast<AnyGC*>(const_cast<VPtr*>(this)));
            return dynAs<int64_t>(result);
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

// ============================================================================
// 6. Box 类型 — 闭包捕获引用语义
// ============================================================================

// Forward declarations for string helpers used in StringBox vptrMap
inline std::string dart_str_toUpper(const std::string& s);
inline std::string dart_str_toLower(const std::string& s);
inline std::string dart_str_trim(const std::string& s);

struct IntBox : VPtr {
    int64_t value;
    IntBox(int64_t v) : VPtr(), value(v) { _typeName = "int"; GC::allocateLocal(this); }
    std::string toString() const override { return std::to_string(value); }

    static AnyGC* _vptr_toString(AnyGC* self);
    static AnyGC* _vptr_runtimeType(AnyGC*);
    static AnyGC* _vptr_compareTo(AnyGC* self, AnyGC* other);
    std::unordered_map<std::string, void*>& getVptrMap() override {
        static std::unordered_map<std::string, void*> map;
        if (map.empty()) {
            map["toString"] = reinterpret_cast<void*>(&_vptr_toString);
            map["get_runtimeType"] = reinterpret_cast<void*>(&_vptr_runtimeType);
            map["compareTo"] = reinterpret_cast<void*>(&_vptr_compareTo);
        }
        return map;
    }
};

struct DoubleBox : VPtr {
    double value;
    DoubleBox(double v) : VPtr(), value(v) { _typeName = "double"; GC::allocateLocal(this); }
    std::string toString() const override {
        std::ostringstream oss;
        oss << value;
        return oss.str();
    }

    static AnyGC* _vptr_toString(AnyGC* self);
    static AnyGC* _vptr_runtimeType(AnyGC*);
    static AnyGC* _vptr_compareTo(AnyGC* self, AnyGC* other);
    std::unordered_map<std::string, void*>& getVptrMap() override {
        static std::unordered_map<std::string, void*> map;
        if (map.empty()) {
            map["toString"] = reinterpret_cast<void*>(&_vptr_toString);
            map["get_runtimeType"] = reinterpret_cast<void*>(&_vptr_runtimeType);
            map["compareTo"] = reinterpret_cast<void*>(&_vptr_compareTo);
        }
        return map;
    }
};

struct BoolBox : VPtr {
    bool value;
    BoolBox(bool v) : VPtr(), value(v) { _typeName = "bool"; GC::allocateLocal(this); }
    std::string toString() const override { return value ? "true" : "false"; }

    static AnyGC* _vptr_toString(AnyGC* self);
    static AnyGC* _vptr_runtimeType(AnyGC*);
    static AnyGC* _vptr_compareTo(AnyGC* self, AnyGC* other);
    std::unordered_map<std::string, void*>& getVptrMap() override {
        static std::unordered_map<std::string, void*> map;
        if (map.empty()) {
            map["toString"] = reinterpret_cast<void*>(&_vptr_toString);
            map["get_runtimeType"] = reinterpret_cast<void*>(&_vptr_runtimeType);
            map["compareTo"] = reinterpret_cast<void*>(&_vptr_compareTo);
        }
        return map;
    }
};

struct StringBox : VPtr {
    std::string value;
    StringBox(const std::string& v) : VPtr(), value(v) { _typeName = "String"; GC::allocateLocal(this); }
    std::string toString() const override { return value; }

    static AnyGC* _vptr_toString(AnyGC* self);
    static AnyGC* _vptr_runtimeType(AnyGC*);
    static AnyGC* _vptr_toUpperCase(AnyGC* self);
    static AnyGC* _vptr_toLowerCase(AnyGC* self);
    static AnyGC* _vptr_contains(AnyGC* self, AnyGC* other);
    static AnyGC* _vptr_length(AnyGC* self);
    static AnyGC* _vptr_trim(AnyGC* self);
    static AnyGC* _vptr_compareTo(AnyGC* self, AnyGC* other);
    std::unordered_map<std::string, void*>& getVptrMap() override {
        static std::unordered_map<std::string, void*> map;
        if (map.empty()) {
            map["toString"] = reinterpret_cast<void*>(&_vptr_toString);
            map["get_runtimeType"] = reinterpret_cast<void*>(&_vptr_runtimeType);
            map["toUpperCase"] = reinterpret_cast<void*>(&_vptr_toUpperCase);
            map["toLowerCase"] = reinterpret_cast<void*>(&_vptr_toLowerCase);
            map["contains"] = reinterpret_cast<void*>(&_vptr_contains);
            map["get_length"] = reinterpret_cast<void*>(&_vptr_length);
            map["trim"] = reinterpret_cast<void*>(&_vptr_trim);
            map["compareTo"] = reinterpret_cast<void*>(&_vptr_compareTo);
        }
        return map;
    }
};

// TupleBox — wraps std::tuple* as a VPtr for record types (Dart records)
struct TupleBox : VPtr {
    void* data;
    std::string str;
    TupleBox(void* d, std::string s) : VPtr(), data(d), str(std::move(s)) {
        _typeName = "Record";
        GC::allocateLocal(this);
    }
    std::string toString() const override { return str; }
    void gcMark(int flag) override {
        if (gcFlag == flag) return;
        VPtr::gcMark(flag);
    }
};

// ValueBox<T> — wraps any value type as a VPtr for dynamic dispatch
template<typename T>
struct ValueBox : VPtr {
    T value;
    ValueBox(const T& v) : VPtr(), value(v) { _typeName = "ValueBox"; }
    ValueBox(T&& v) : VPtr(), value(std::move(v)) { _typeName = "ValueBox"; }
    void gcMark(int flag) override {
        if (gcFlag == flag) return;
        VPtr::gcMark(flag);
    }
};

// ============================================================================
// _box — universal boxing helper (replaces AnyPtr::fromAuto)
// ============================================================================

inline AnyGC* _box(AnyGC* v) { return v; }
inline AnyGC* _box(VPtr* v) { return static_cast<AnyGC*>(v); }
inline AnyGC* _box(TypeFunction* v) { return reinterpret_cast<AnyGC*>(v); }
inline AnyGC* _box(std::nullptr_t) { return nullptr; }
inline AnyGC* _box(int64_t v) { return GC::allocateLocal(new IntBox(v)); }
inline AnyGC* _box(int v) { return GC::allocateLocal(new IntBox(static_cast<int64_t>(v))); }
inline AnyGC* _box(double v) { return GC::allocateLocal(new DoubleBox(v)); }
inline AnyGC* _box(bool v) { return GC::allocateLocal(new BoolBox(v)); }
inline AnyGC* _box(const std::string& v) { return GC::allocateLocal(new StringBox(v)); }
inline AnyGC* _box(const char* v) { return GC::allocateLocal(new StringBox(std::string(v))); }

// _box overload for DartException — converts to StringBox
inline AnyGC* _box(const DartException& v) {
    return GC::allocateLocal(new StringBox(v.message));
}

/// _anyToString — convert AnyGC* to string (null-safe)
inline std::string _anyToString(AnyGC* val) {
    return val ? val->toString() : "null";
}

// Generic _box overload for value types not covered above
template<typename T, typename = std::enable_if_t<
    !std::is_pointer_v<std::decay_t<T>> &&
    !std::is_same_v<std::decay_t<T>, int64_t> &&
    !std::is_same_v<std::decay_t<T>, int> &&
    !std::is_same_v<std::decay_t<T>, double> &&
    !std::is_same_v<std::decay_t<T>, bool> &&
    !std::is_same_v<std::decay_t<T>, std::string> &&
    !std::is_same_v<std::decay_t<T>, DartException>
>>
AnyGC* _box(const T& v) {
    return GC::allocateLocal(new ValueBox<T>(v));
}

// ── Box type vptrMap method definitions (after _box is available) ──

inline AnyGC* IntBox::_vptr_toString(AnyGC* self) {
    return _box(static_cast<IntBox*>(self)->toString());
}
inline AnyGC* IntBox::_vptr_runtimeType(AnyGC*) {
    return _box(std::string("int"));
}
inline AnyGC* IntBox::_vptr_compareTo(AnyGC* self, AnyGC* other) {
    int64_t a = static_cast<IntBox*>(self)->value;
    int64_t b = dynAs<int64_t>(other);
    return _box(static_cast<int64_t>(a > b ? 1 : (a < b ? -1 : 0)));
}

inline AnyGC* DoubleBox::_vptr_toString(AnyGC* self) {
    return _box(static_cast<DoubleBox*>(self)->toString());
}
inline AnyGC* DoubleBox::_vptr_runtimeType(AnyGC*) {
    return _box(std::string("double"));
}
inline AnyGC* DoubleBox::_vptr_compareTo(AnyGC* self, AnyGC* other) {
    double a = static_cast<DoubleBox*>(self)->value;
    double b = dynAs<double>(other);
    return _box(static_cast<int64_t>(a > b ? 1 : (a < b ? -1 : 0)));
}

inline AnyGC* BoolBox::_vptr_toString(AnyGC* self) {
    return _box(static_cast<BoolBox*>(self)->toString());
}
inline AnyGC* BoolBox::_vptr_runtimeType(AnyGC*) {
    return _box(std::string("bool"));
}
inline AnyGC* BoolBox::_vptr_compareTo(AnyGC* self, AnyGC* other) {
    bool a = static_cast<BoolBox*>(self)->value;
    bool b = dynAs<bool>(other);
    return _box(static_cast<int64_t>(a == b ? 0 : (a ? 1 : -1)));
}

inline AnyGC* StringBox::_vptr_toString(AnyGC* self) {
    return _box(static_cast<StringBox*>(self)->value);
}
inline AnyGC* StringBox::_vptr_runtimeType(AnyGC*) {
    return _box(std::string("String"));
}
inline AnyGC* StringBox::_vptr_toUpperCase(AnyGC* self) {
    return _box(dart_str_toUpper(static_cast<StringBox*>(self)->value));
}
inline AnyGC* StringBox::_vptr_toLowerCase(AnyGC* self) {
    return _box(dart_str_toLower(static_cast<StringBox*>(self)->value));
}
inline AnyGC* StringBox::_vptr_contains(AnyGC* self, AnyGC* other) {
    return _box(static_cast<StringBox*>(self)->value.find(dynAs<std::string>(other)) != std::string::npos);
}
inline AnyGC* StringBox::_vptr_length(AnyGC* self) {
    return _box(static_cast<int64_t>(static_cast<StringBox*>(self)->value.size()));
}
inline AnyGC* StringBox::_vptr_trim(AnyGC* self) {
    return _box(dart_str_trim(static_cast<StringBox*>(self)->value));
}
inline AnyGC* StringBox::_vptr_compareTo(AnyGC* self, AnyGC* other) {
    const auto& a = static_cast<StringBox*>(self)->value;
    std::string b = dynAs<std::string>(other);
    return _box(static_cast<int64_t>(a.compare(b)));
}

// ============================================================================
// dynAs<T> — 类型安全转换：拆箱 + 向下转型
// ============================================================================

/// 将 AnyGC* 对象转换为目标类型 T。
/// 自动处理基本类型的拆箱（IntBox → int64_t 等）和 AnyGC 子类的向下转型。
template<typename T>
T dynAs(AnyGC* obj) {
    if (!obj) {
        if constexpr (std::is_pointer_v<T>) return nullptr;
        else return T{};
    }
    if constexpr (std::is_same_v<T, int64_t>) {
        if (auto* box = dynamic_cast<IntBox*>(obj)) return box->value;
        if (auto* box = dynamic_cast<DoubleBox*>(obj)) return static_cast<int64_t>(box->value);
        if (auto* box = dynamic_cast<BoolBox*>(obj)) return box->value ? 1 : 0;
        return 0;
    }
    else if constexpr (std::is_same_v<T, double>) {
        if (auto* box = dynamic_cast<DoubleBox*>(obj)) return box->value;
        if (auto* box = dynamic_cast<IntBox*>(obj)) return static_cast<double>(box->value);
        if (auto* box = dynamic_cast<BoolBox*>(obj)) return box->value ? 1.0 : 0.0;
        return 0.0;
    }
    else if constexpr (std::is_same_v<T, bool>) {
        if (auto* box = dynamic_cast<BoolBox*>(obj)) return box->value;
        if (auto* box = dynamic_cast<IntBox*>(obj)) return box->value != 0;
        return false;
    }
    else if constexpr (std::is_same_v<T, std::string>) {
        if (auto* box = dynamic_cast<StringBox*>(obj)) return box->value;
        return obj->toString();
    }
    else if constexpr (std::is_pointer_v<T>) {
        return static_cast<T>(obj);
    }
    else {
        if (auto* vbox = dynamic_cast<ValueBox<T>*>(obj)) return vbox->value;
        return T{};
    }
}

// ============================================================================
// 8. TypeFunction 层级 — 可调用闭包基类（可变参数模板）
// ============================================================================

struct TypeFunction : AnyGC {
    void* closureCall = nullptr;

    AnyGC* dynCall() {
        using Fn = AnyGC*(*)(AnyGC*);
        auto fn = reinterpret_cast<Fn>(closureCall);
        return fn(this);
    }

    AnyGC* dynCall(AnyGC* arg1) {
        using Fn = AnyGC*(*)(AnyGC*, AnyGC*);
        auto fn = reinterpret_cast<Fn>(closureCall);
        return fn(this, arg1);
    }

    AnyGC* dynCall(AnyGC* arg1, AnyGC* arg2) {
        using Fn = AnyGC*(*)(AnyGC*, AnyGC*, AnyGC*);
        auto fn = reinterpret_cast<Fn>(closureCall);
        return fn(this, arg1, arg2);
    }

    void gcMark(int flag) override {
        if (gcFlag == flag) return;
        AnyGC::gcMark(flag);
    }
};

// Helper to generate function pointer type with N AnyGC* parameters
template<size_t N>
struct AnyGCFnType;

template<>
struct AnyGCFnType<0> { using type = AnyGC*(*)(AnyGC*); };

template<>
struct AnyGCFnType<1> { using type = AnyGC*(*)(AnyGC*, AnyGC*); };

template<>
struct AnyGCFnType<2> { using type = AnyGC*(*)(AnyGC*, AnyGC*, AnyGC*); };

template<>
struct AnyGCFnType<3> { using type = AnyGC*(*)(AnyGC*, AnyGC*, AnyGC*, AnyGC*); };

template<>
struct AnyGCFnType<4> { using type = AnyGC*(*)(AnyGC*, AnyGC*, AnyGC*, AnyGC*, AnyGC*); };

// TypeFunctionN<R, Args...> — 可变参数模板版本
template<typename R, typename... Args>
struct TypeFunctionN : TypeFunction {
    virtual R call(Args... args) {
        using Fn = typename AnyGCFnType<sizeof...(Args)>::type;
        auto fn = reinterpret_cast<Fn>(closureCall);
        AnyGC* result = fn(this, _box(args)...);
        if constexpr (std::is_same_v<R, AnyGC*>) {
            return result;
        } else if constexpr (std::is_same_v<R, int64_t>) {
            return dynAs<int64_t>(result);
        } else if constexpr (std::is_same_v<R, double>) {
            return dynAs<double>(result);
        } else if constexpr (std::is_same_v<R, bool>) {
            return dynAs<bool>(result);
        } else if constexpr (std::is_same_v<R, std::string>) {
            return dynAs<std::string>(result);
        } else if constexpr (std::is_same_v<R, void>) {
            return;
        } else if constexpr (std::is_pointer_v<R>) {
            return static_cast<R>(result);
        } else {
            return R{};
        }
    }
};

// 向后兼容的类型别名（保持 TypeFunction0-16 的命名）
template<typename R>
using TypeFunction0 = TypeFunctionN<R>;

template<typename R, typename T1>
using TypeFunction1 = TypeFunctionN<R, T1>;

template<typename R, typename T1, typename T2>
using TypeFunction2 = TypeFunctionN<R, T1, T2>;

// Adapters for vptr dispatch: wrap type-erased TypeFunction* as typed TypeFunctionN<AnyGC*, ...>
struct _TypeFnAdapter0 : TypeFunction0<AnyGC*> {
    TypeFunction* inner;
    _TypeFnAdapter0(TypeFunction* fn) : inner(fn) {
        this->closureCall = reinterpret_cast<void*>(&_trampoline);
    }
    static AnyGC* _trampoline(AnyGC* _env) {
        auto* self = static_cast<_TypeFnAdapter0*>(_env);
        return self->inner->dynCall();
    }
    AnyGC* call() override { return inner->dynCall(); }
};

template<typename T>
struct _TypeFnAdapter1 : TypeFunction1<AnyGC*, T> {
    TypeFunction* inner;
    _TypeFnAdapter1(TypeFunction* fn) : inner(fn) {
        this->closureCall = reinterpret_cast<void*>(&_trampoline);
    }
    static AnyGC* _trampoline(AnyGC* _env, AnyGC* _p0) {
        auto* self = static_cast<_TypeFnAdapter1*>(_env);
        return self->inner->dynCall(_p0);
    }
    AnyGC* call(T arg) override { return inner->dynCall(_box(arg)); }
};

template<typename T1, typename T2>
struct _TypeFnAdapter2 : TypeFunction2<AnyGC*, T1, T2> {
    TypeFunction* inner;
    _TypeFnAdapter2(TypeFunction* fn) : inner(fn) {
        this->closureCall = reinterpret_cast<void*>(&_trampoline);
    }
    static AnyGC* _trampoline(AnyGC* _env, AnyGC* _p0, AnyGC* _p1) {
        auto* self = static_cast<_TypeFnAdapter2*>(_env);
        return self->inner->dynCall(_p0, _p1);
    }
    AnyGC* call(T1 arg1, T2 arg2) override { return inner->dynCall(_box(arg1), _box(arg2)); }
};

template<typename R, typename T1, typename T2, typename T3>
using TypeFunction3 = TypeFunctionN<R, T1, T2, T3>;

template<typename R, typename T1, typename T2, typename T3, typename T4>
using TypeFunction4 = TypeFunctionN<R, T1, T2, T3, T4>;

template<typename R, typename T1, typename T2, typename T3, typename T4, typename T5>
using TypeFunction5 = TypeFunctionN<R, T1, T2, T3, T4, T5>;

template<typename R, typename T1, typename T2, typename T3, typename T4,
         typename T5, typename T6>
using TypeFunction6 = TypeFunctionN<R, T1, T2, T3, T4, T5, T6>;

template<typename R, typename T1, typename T2, typename T3, typename T4,
         typename T5, typename T6, typename T7>
using TypeFunction7 = TypeFunctionN<R, T1, T2, T3, T4, T5, T6, T7>;

template<typename R, typename T1, typename T2, typename T3, typename T4,
         typename T5, typename T6, typename T7, typename T8>
using TypeFunction8 = TypeFunctionN<R, T1, T2, T3, T4, T5, T6, T7, T8>;

template<typename R, typename T1, typename T2, typename T3, typename T4,
         typename T5, typename T6, typename T7, typename T8, typename T9>
using TypeFunction9 = TypeFunctionN<R, T1, T2, T3, T4, T5, T6, T7, T8, T9>;

template<typename R, typename T1, typename T2, typename T3, typename T4,
         typename T5, typename T6, typename T7, typename T8, typename T9,
         typename T10>
using TypeFunction10 = TypeFunctionN<R, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10>;

template<typename R, typename T1, typename T2, typename T3, typename T4,
         typename T5, typename T6, typename T7, typename T8, typename T9,
         typename T10, typename T11>
using TypeFunction11 = TypeFunctionN<R, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11>;

template<typename R, typename T1, typename T2, typename T3, typename T4,
         typename T5, typename T6, typename T7, typename T8, typename T9,
         typename T10, typename T11, typename T12>
using TypeFunction12 = TypeFunctionN<R, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12>;

template<typename R, typename T1, typename T2, typename T3, typename T4,
         typename T5, typename T6, typename T7, typename T8, typename T9,
         typename T10, typename T11, typename T12, typename T13>
using TypeFunction13 = TypeFunctionN<R, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13>;

template<typename R, typename T1, typename T2, typename T3, typename T4,
         typename T5, typename T6, typename T7, typename T8, typename T9,
         typename T10, typename T11, typename T12, typename T13, typename T14>
using TypeFunction14 = TypeFunctionN<R, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14>;

template<typename R, typename T1, typename T2, typename T3, typename T4,
         typename T5, typename T6, typename T7, typename T8, typename T9,
         typename T10, typename T11, typename T12, typename T13, typename T14,
         typename T15>
using TypeFunction15 = TypeFunctionN<R, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15>;

template<typename R, typename T1, typename T2, typename T3, typename T4,
         typename T5, typename T6, typename T7, typename T8, typename T9,
         typename T10, typename T11, typename T12, typename T13, typename T14,
         typename T15, typename T16>
using TypeFunction16 = TypeFunctionN<R, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16>;

// ============================================================================
// ============================================================================
// 8. 静态集合 — StaticMapEntry / Array / StaticList / StaticMap / StaticSet
// ============================================================================

// ── StaticMapEntry<K,V> ──

// 前向声明
template<typename T> struct StaticList;
template<typename T> struct StaticSet;
template<typename K, typename V> struct StaticMap;

// ── Array<T> ──

template<typename T>
struct Array : AnyGC {
    std::vector<T> _storage;

    Array() = default;
    Array(int size, T fill = T()) : _storage(size, fill) {}
    Array(std::initializer_list<T> init) : _storage(init) {}

    template<typename Iter>
    Array(Iter begin, Iter end) : _storage(begin, end) {}

    // 从 StaticList 构造（前向声明，实现在 StaticList 定义之后）
    Array(StaticList<T>* list);

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

    bool remove(const T& element) {
        int idx = indexOf(element);
        if (idx == -1) return false;
        removeAt(idx);
        return true;
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

    // ── 迭代器支持（对齐 Dart Array.iterable） ──

    typename std::vector<T>::iterator begin() { return _storage.begin(); }
    typename std::vector<T>::iterator end() { return _storage.end(); }
    typename std::vector<T>::const_iterator begin() const { return _storage.begin(); }
    typename std::vector<T>::const_iterator end() const { return _storage.end(); }
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
// 对齐 Dart _collections.dart StaticList<T>

// 前向声明（用于 asMap / toStaticSet）
template<typename K, typename V> struct StaticMap;
template<typename T> struct StaticSet;

template<typename T>
struct StaticList : VPtr {
    Array<T>* _data;

    StaticList() : VPtr(), _data(GC::allocateLocal(new Array<T>())) { _typeName = "List"; }

    StaticList(std::initializer_list<T> init)
        : VPtr(), _data(GC::allocateLocal(new Array<T>(init))) { _typeName = "List"; }

    static StaticList* of(std::initializer_list<T> elements) {
        return GC::allocateLocal(new StaticList(elements));
    }

    static StaticList* empty() {
        return GC::allocateLocal(new StaticList());
    }

    /// 对齐 Dart: StaticList.filled(length, fill)
    static StaticList* filled(int length, T fill) {
        auto* result = GC::allocateLocal(new StaticList());
        for (int i = 0; i < length; i++) result->add(fill);
        return result;
    }

    /// 对齐 Dart: StaticList.generate(length, generator)
    static StaticList* generate(int length, std::function<T(int)> generator) {
        auto* result = GC::allocateLocal(new StaticList());
        for (int i = 0; i < length; i++) result->add(generator(i));
        return result;
    }

    /// 对齐 Dart: StaticList.generate(length, generator) — TypeFunction 版本
    static StaticList* generate(int length, TypeFunction1<T, int64_t>* generator) {
        auto* result = GC::allocateLocal(new StaticList());
        if (generator) {
            for (int i = 0; i < length; i++) result->add(generator->call(static_cast<int64_t>(i)));
        }
        return result;
    }

    /// 对齐 Dart: StaticList.from(elements)
    static StaticList* from(StaticList<T>* source) {
        auto* result = GC::allocateLocal(new StaticList());
        if (source) {
            for (int i = 0; i < source->length(); i++) result->add((*source)[i]);
        }
        return result;
    }

    // ── 核心属性 ──

    int length() const { return _data->length(); }
    bool isEmpty() const { return _data->length() == 0; }
    bool isNotEmpty() const { return _data->length() > 0; }

    T first() const {
        if (isEmpty()) throw DartStateError("No element");
        return (*_data)[0];
    }

    T last() const {
        if (isEmpty()) throw DartStateError("No element");
        return (*_data)[_data->length() - 1];
    }

    T single() const {
        if (_data->length() != 1) throw DartStateError("Not single element");
        return (*_data)[0];
    }

    StaticList<T>* toList() const {
        auto* result = GC::allocateLocal(new StaticList<T>());
        for (int i = 0; i < _data->length(); i++) result->add((*_data)[i]);
        return result;
    }

    // ── 索引访问 ──

    T& operator[](int index) { return (*_data)[index]; }
    const T& operator[](int index) const { return (*_data)[index]; }

    T elementAt(int index) const { return (*_data)[index]; }

    // ── 修改操作 ──

    void add(const T& element) { _data->add(element); }
    void add(T&& element) { _data->add(std::move(element)); }

    void addAll(StaticList<T>* other) {
        if (!other) return;
        for (int i = 0; i < other->length(); i++) _data->add((*other)[i]);
    }

    void insert(int index, const T& element) { _data->insert(index, element); }

    void insertAll(int index, StaticList<T>* other) {
        if (!other) return;
        int i = index;
        for (int j = 0; j < other->length(); j++) {
            _data->insert(i, (*other)[j]);
            i++;
        }
    }

    T removeAt(int index) { return _data->removeAt(index); }

    bool remove(const T& element) {
        int idx = _data->indexOf(element);
        if (idx == -1) return false;
        _data->removeAt(idx);
        return true;
    }

    void removeLast() {
        if (isEmpty()) throw DartRangeError("Cannot removeLast on empty list");
        _data->removeAt(_data->length() - 1);
    }

    void removeWhere(std::function<bool(T)> test) {
        for (int i = _data->length() - 1; i >= 0; i--) {
            if (test((*_data)[i])) _data->removeAt(i);
        }
    }
    void removeWhere(TypeFunction1<bool, T>* test) {
        for (int i = _data->length() - 1; i >= 0; i--) {
            if (test->call((*_data)[i])) _data->removeAt(i);
        }
    }

    void retainWhere(std::function<bool(T)> test) {
        for (int i = _data->length() - 1; i >= 0; i--) {
            if (!test((*_data)[i])) _data->removeAt(i);
        }
    }
    void retainWhere(TypeFunction1<bool, T>* test) {
        for (int i = _data->length() - 1; i >= 0; i--) {
            if (!test->call((*_data)[i])) _data->removeAt(i);
        }
    }

    void clear() { _data->clear(); }

    /// 对齐 Dart: list.sort([compare]) — 使用 TypeFunction2 比较器
    void sort(TypeFunction2<int64_t, T, T>* compare) {
        if (!compare || _data->length() <= 1) return;
        std::sort(_data->_storage.begin(), _data->_storage.end(),
            [compare](const T& a, const T& b) {
                return compare->call(a, b) < 0;
            });
    }

    /// 对齐 Dart: list.sort() — 默认排序（要求 T 支持 < 运算符）
    void sort() {
        if (_data->length() <= 1) return;
        std::sort(_data->_storage.begin(), _data->_storage.end());
    }

    // ── 查询操作 ──

    int indexOf(const T& element, int start = 0) const {
        for (int i = start; i < _data->length(); i++) {
            if ((*_data)[i] == element) return i;
        }
        return -1;
    }

    int lastIndexOf(const T& element, int end = -1) const {
        int endIdx = (end == -1) ? _data->length() - 1 : end;
        for (int i = endIdx; i >= 0; i--) {
            if ((*_data)[i] == element) return i;
        }
        return -1;
    }

    int indexWhere(std::function<bool(T)> test, int start = 0) const {
        for (int i = start; i < _data->length(); i++) {
            if (test((*_data)[i])) return i;
        }
        return -1;
    }
    int indexWhere(TypeFunction1<bool, T>* test, int start = 0) const {
        for (int i = start; i < _data->length(); i++) {
            if (test->call((*_data)[i])) return i;
        }
        return -1;
    }

    bool contains(const T& element) const { return _data->contains(element); }

    // ── 迭代器 ──

    StaticIterator<T>* iterator() {
        return GC::allocateLocal(new StaticIterator<T>(_data));
    }

    // Range-for support for C++
    typename std::vector<T>::iterator begin() { return _data->begin(); }
    typename std::vector<T>::iterator end() { return _data->end(); }
    typename std::vector<T>::const_iterator begin() const { return _data->begin(); }
    typename std::vector<T>::const_iterator end() const { return _data->end(); }

    // ── 高阶方法（函数指针版 + std::function 版 + TypeFunction 版） ──

    void forEach(std::function<void(T)> func) const {
        for (int i = 0; i < _data->length(); i++) func((*_data)[i]);
    }
    void forEach(void (*func)(T)) const {
        for (int i = 0; i < _data->length(); i++) func((*_data)[i]);
    }
    void forEach(TypeFunction1<void, T>* func) const {
        for (int i = 0; i < _data->length(); i++) func->call((*_data)[i]);
    }

    template<typename R>
    StaticList<R>* map(std::function<R(T)> func) const {
        auto* result = new StaticList<R>();
        for (int i = 0; i < _data->length(); i++) result->add(func((*_data)[i]));
        return GC::allocateLocal(result);
    }
    template<typename R>
    StaticList<R>* map(R (*func)(T)) const {
        auto* result = new StaticList<R>();
        for (int i = 0; i < _data->length(); i++) result->add(func((*_data)[i]));
        return GC::allocateLocal(result);
    }
    template<typename R>
    StaticList<R>* map(TypeFunction1<R, T>* func) const {
        auto* result = new StaticList<R>();
        for (int i = 0; i < _data->length(); i++) result->add(func->call((*_data)[i]));
        return GC::allocateLocal(result);
    }

    template<typename R>
    StaticList<R>* expand(TypeFunction1<StaticList<R>*, T>* func) const {
        auto* result = new StaticList<R>();
        for (int i = 0; i < _data->length(); i++) {
            auto* inner = func->call((*_data)[i]);
            if (inner) {
                for (int j = 0; j < inner->length(); j++) result->add((*inner)[j]);
            }
        }
        return GC::allocateLocal(result);
    }

    StaticList<T>* where(std::function<bool(T)> func) const {
        auto* result = new StaticList<T>();
        for (int i = 0; i < _data->length(); i++) {
            if (func((*_data)[i])) result->add((*_data)[i]);
        }
        return GC::allocateLocal(result);
    }
    StaticList<T>* where(bool (*func)(T)) const {
        auto* result = new StaticList<T>();
        for (int i = 0; i < _data->length(); i++) {
            if (func((*_data)[i])) result->add((*_data)[i]);
        }
        return GC::allocateLocal(result);
    }
    StaticList<T>* where(TypeFunction1<bool, T>* func) const {
        auto* result = new StaticList<T>();
        for (int i = 0; i < _data->length(); i++) {
            if (func->call((*_data)[i])) result->add((*_data)[i]);
        }
        return GC::allocateLocal(result);
    }

    bool any(std::function<bool(T)> test) const {
        for (int i = 0; i < _data->length(); i++) {
            if (test((*_data)[i])) return true;
        }
        return false;
    }
    bool any(TypeFunction1<bool, T>* test) const {
        for (int i = 0; i < _data->length(); i++) {
            if (test->call((*_data)[i])) return true;
        }
        return false;
    }

    bool every(std::function<bool(T)> test) const {
        for (int i = 0; i < _data->length(); i++) {
            if (!test((*_data)[i])) return false;
        }
        return true;
    }
    bool every(TypeFunction1<bool, T>* test) const {
        for (int i = 0; i < _data->length(); i++) {
            if (!test->call((*_data)[i])) return false;
        }
        return true;
    }

    T firstWhere(std::function<bool(T)> test, std::function<T()> orElse = nullptr) const {
        for (int i = 0; i < _data->length(); i++) {
            if (test((*_data)[i])) return (*_data)[i];
        }
        if (orElse) return orElse();
        throw DartStateError("No element");
    }
    T firstWhere(TypeFunction1<bool, T>* test, TypeFunction0<T>* orElse = nullptr) const {
        for (int i = 0; i < _data->length(); i++) {
            if (test->call((*_data)[i])) return (*_data)[i];
        }
        if (orElse) return orElse->call();
        throw DartStateError("No element");
    }

    T lastWhere(std::function<bool(T)> test, std::function<T()> orElse = nullptr) const {
        for (int i = _data->length() - 1; i >= 0; i--) {
            if (test((*_data)[i])) return (*_data)[i];
        }
        if (orElse) return orElse();
        throw DartStateError("No element");
    }
    T lastWhere(TypeFunction1<bool, T>* test, TypeFunction0<T>* orElse = nullptr) const {
        for (int i = _data->length() - 1; i >= 0; i--) {
            if (test->call((*_data)[i])) return (*_data)[i];
        }
        if (orElse) return orElse->call();
        throw DartStateError("No element");
    }

    T singleWhere(std::function<bool(T)> test, std::function<T()> orElse = nullptr) const {
        bool foundMultiple = false;
        T found{};
        bool hasFound = false;
        for (int i = 0; i < _data->length(); i++) {
            if (test((*_data)[i])) {
                if (hasFound) { foundMultiple = true; break; }
                found = (*_data)[i];
                hasFound = true;
            }
        }
        if (foundMultiple) throw DartStateError("Too many elements");
        if (hasFound) return found;
        if (orElse) return orElse();
        throw DartStateError("No element");
    }
    T singleWhere(TypeFunction1<bool, T>* test, TypeFunction0<T>* orElse = nullptr) const {
        bool foundMultiple = false;
        T found{};
        bool hasFound = false;
        for (int i = 0; i < _data->length(); i++) {
            if (test->call((*_data)[i])) {
                if (hasFound) { foundMultiple = true; break; }
                found = (*_data)[i];
                hasFound = true;
            }
        }
        if (foundMultiple) throw DartStateError("Too many elements");
        if (hasFound) return found;
        if (orElse) return orElse->call();
        throw DartStateError("No element");
    }

    template<typename R>
    R fold(R initialValue, std::function<R(R, T)> combine) const {
        R value = initialValue;
        for (int i = 0; i < _data->length(); i++) value = combine(value, (*_data)[i]);
        return value;
    }

    template<typename R>
    R fold(R initialValue, TypeFunction2<R, R, T>* combine) const {
        R value = initialValue;
        for (int i = 0; i < _data->length(); i++) value = combine->call(value, (*_data)[i]);
        return value;
    }

    T reduce(std::function<T(T, T)> combine) const {
        if (isEmpty()) throw DartStateError("No element");
        T value = (*_data)[0];
        for (int i = 1; i < _data->length(); i++) value = combine(value, (*_data)[i]);
        return value;
    }
    T reduce(TypeFunction2<T, T, T>* combine) const {
        if (isEmpty()) throw DartStateError("No element");
        T value = (*_data)[0];
        for (int i = 1; i < _data->length(); i++) value = combine->call(value, (*_data)[i]);
        return value;
    }

    // ── 切片 ──

    StaticList<T>* take(int count) const {
        auto* result = new StaticList<T>();
        int end = count < _data->length() ? count : _data->length();
        for (int i = 0; i < end; i++) result->add((*_data)[i]);
        return GC::allocateLocal(result);
    }

    StaticList<T>* skip(int count) const {
        auto* result = new StaticList<T>();
        for (int i = count; i < _data->length(); i++) result->add((*_data)[i]);
        return GC::allocateLocal(result);
    }

    StaticList<T>* takeWhile(std::function<bool(T)> test) const {
        auto* result = new StaticList<T>();
        for (int i = 0; i < _data->length(); i++) {
            if (!test((*_data)[i])) break;
            result->add((*_data)[i]);
        }
        return GC::allocateLocal(result);
    }
    StaticList<T>* takeWhile(TypeFunction1<bool, T>* test) const {
        auto* result = new StaticList<T>();
        for (int i = 0; i < _data->length(); i++) {
            if (!test->call((*_data)[i])) break;
            result->add((*_data)[i]);
        }
        return GC::allocateLocal(result);
    }

    StaticList<T>* skipWhile(std::function<bool(T)> test) const {
        auto* result = new StaticList<T>();
        bool skipping = true;
        for (int i = 0; i < _data->length(); i++) {
            if (skipping && test((*_data)[i])) continue;
            skipping = false;
            result->add((*_data)[i]);
        }
        return GC::allocateLocal(result);
    }
    StaticList<T>* skipWhile(TypeFunction1<bool, T>* test) const {
        auto* result = new StaticList<T>();
        bool skipping = true;
        for (int i = 0; i < _data->length(); i++) {
            if (skipping && test->call((*_data)[i])) continue;
            skipping = false;
            result->add((*_data)[i]);
        }
        return GC::allocateLocal(result);
    }

    template<typename R>
    StaticList<R>* expand(std::function<StaticList<R>*(T)> convert) const {
        auto* result = new StaticList<R>();
        for (int i = 0; i < _data->length(); i++) {
            auto* inner = convert((*_data)[i]);
            if (inner) result->addAll(inner);
        }
        return GC::allocateLocal(result);
    }

    // ── 变换 ──

    StaticList<T>* sublist(int start, int end = -1) const {
        int actualEnd = (end == -1) ? _data->length() : end;
        auto* result = new StaticList<T>();
        for (int i = start; i < actualEnd; i++) result->add((*_data)[i]);
        return GC::allocateLocal(result);
    }

    StaticList<T>* reversed() const {
        auto* result = new StaticList<T>();
        for (int i = _data->length() - 1; i >= 0; i--) result->add((*_data)[i]);
        return GC::allocateLocal(result);
    }

    StaticList<T>* operator+(StaticList<T>* other) const {
        auto* result = new StaticList<T>();
        for (int i = 0; i < _data->length(); i++) result->add((*_data)[i]);
        if (other) result->addAll(other);
        return GC::allocateLocal(result);
    }

    StaticList<T>* followedBy(StaticList<T>* other) const {
        return operator+(other);
    }

    StaticMap<int, T>* asMap() const;  // 定义在 StaticMap 之后

    StaticSet<T>* toStaticSet() const;  // 定义在 StaticSet 之后

    template<typename R>
    StaticList<R>* cast() const {
        auto* result = new StaticList<R>();
        for (int i = 0; i < _data->length(); i++) {
            if constexpr (std::is_same_v<R, int64_t>) {
                result->add(static_cast<int64_t>((*_data)[i]));
            } else if constexpr (std::is_same_v<R, double>) {
                result->add(static_cast<double>((*_data)[i]));
            } else if constexpr (std::is_same_v<R, std::string>) {
                result->add(dart_str((*_data)[i]));
            } else {
                result->add(static_cast<R>((*_data)[i]));
            }
        }
        return GC::allocateLocal(result);
    }

    // ── 字符串 ──

    std::string join(const std::string& separator = "") const {
        std::string result;
        for (int i = 0; i < _data->length(); i++) {
            if (i > 0) result += separator;
            result += dart_str((*_data)[i]);
        }
        return result;
    }

    std::string toString() const override {
        return "[" + join(", ") + "]";
    }

    // vptrMap support
    static AnyGC* _vptr_runtimeType(AnyGC*) {
        return _box(std::string("List"));
    }
    static AnyGC* _vptr_length(AnyGC* self) {
        return _box(static_cast<int64_t>(static_cast<StaticList*>(self)->length()));
    }
    static AnyGC* _vptr_toString(AnyGC* self) {
        return _box(static_cast<StaticList*>(self)->toString());
    }
    static AnyGC* _vptr_index(AnyGC* self, AnyGC* idx) {
        auto* list = static_cast<StaticList*>(self);
        int64_t i = dynAs<int64_t>(idx);
        return _box((*list)[static_cast<int>(i)]);
    }
    static AnyGC* _vptr_setIndex(AnyGC* self, AnyGC* idx, AnyGC* val) {
        auto* list = static_cast<StaticList*>(self);
        int64_t i = dynAs<int64_t>(idx);
        if constexpr (std::is_same_v<T, int64_t>) {
            (*list)[static_cast<int>(i)] = dynAs<int64_t>(val);
        } else if constexpr (std::is_same_v<T, double>) {
            (*list)[static_cast<int>(i)] = dynAs<double>(val);
        } else if constexpr (std::is_same_v<T, bool>) {
            (*list)[static_cast<int>(i)] = dynAs<bool>(val);
        } else if constexpr (std::is_same_v<T, std::string>) {
            (*list)[static_cast<int>(i)] = dynAs<std::string>(val);
        } else if constexpr (std::is_pointer_v<T>) {
            (*list)[static_cast<int>(i)] = static_cast<T>(val);
        } else {
            (*list)[static_cast<int>(i)] = *reinterpret_cast<T*>(dynamic_cast<VPtr*>(val));
        }
        return nullptr;
    }
    std::unordered_map<std::string, void*>& getVptrMap() override {
        static std::unordered_map<std::string, void*> map;
        if (map.empty()) {
            map["get_runtimeType"] = reinterpret_cast<void*>(&_vptr_runtimeType);
            map["get_length"] = reinterpret_cast<void*>(&_vptr_length);
            map["toString"] = reinterpret_cast<void*>(&_vptr_toString);
            map["[]"] = reinterpret_cast<void*>(&_vptr_index);
            map["[]="] = reinterpret_cast<void*>(&_vptr_setIndex);
        }
        return map;
    }

    // ── GC ──

    void gcMark(int flag) override {
        if (gcFlag == flag) return;
        AnyGC::gcMark(flag);
        if (_data) _data->gcMark(flag);
    }
};

// ── Array<T>::Array(StaticList<T>*) 实现（需要 StaticList 完整定义） ──

template<typename T>
Array<T>::Array(StaticList<T>* list) {
    if (list) {
        _storage.reserve(list->length());
        for (int i = 0; i < list->length(); i++) {
            _storage.push_back((*list)[i]);
        }
    }
}

// ── StaticMapEntry<K,V> ──

template<typename K, typename V>
struct StaticMapEntry {
    K key;
    V value;

    StaticMapEntry() : key(), value() {}
    StaticMapEntry(K k, V v) : key(std::move(k)), value(std::move(v)) {}
};

// ── MapEntryValue<K,V> ──
// Dart's MapEntry<K, V> class lowered to C++

template<typename K, typename V>
struct MapEntryValue : AnyGC {
    K key;
    V value;
    MapEntryValue() : key(), value() {}
    MapEntryValue(K k, V v) : key(std::move(k)), value(std::move(v)) {}
};

// ── StaticMap<K,V> ──
// 对齐 Dart _collections.dart StaticMap<K,V>

template<typename K, typename V>
struct StaticMap : VPtr {
    Array<K>* _keys;
    Array<V>* _values;

    StaticMap()
        : VPtr(),
          _keys(GC::allocateLocal(new Array<K>())),
          _values(GC::allocateLocal(new Array<V>())) { _typeName = "Map"; }

    static StaticMap* empty() {
        return GC::allocateLocal(new StaticMap());
    }

    /// 对齐 Dart: StaticMap.of(source) — 从已有 map 复制
    static StaticMap* of(StaticMap<K, V>* source) {
        auto* result = GC::allocateLocal(new StaticMap());
        if (source) {
            for (int i = 0; i < source->_keys->length(); i++) {
                result->set((*source->_keys)[i], (*source->_values)[i]);
            }
        }
        return result;
    }

    /// 对齐 Dart: StaticMap.from(source) — 从已有 map 复制（允许类型转换）
    static StaticMap* from(StaticMap<K, V>* source) {
        return of(source);
    }

    /// StaticMap.from with different source value type (e.g., AnyGC* → int64_t)
    template<typename SK, typename SV>
    static StaticMap* from(StaticMap<SK, SV>* source) {
        auto* result = GC::allocateLocal(new StaticMap());
        if (source) {
            for (int i = 0; i < source->_keys->length(); i++) {
                auto& k = (*source->_keys)[i];
                auto& v = (*source->_values)[i];
                // Convert key
                K ck;
                if constexpr (std::is_same_v<K, SK>) { ck = k; }
                else if constexpr (std::is_pointer_v<K> && std::is_pointer_v<SK>) { ck = static_cast<K>(k); }
                else if constexpr (std::is_same_v<K, std::string> && std::is_pointer_v<SK>) { ck = dynAs<std::string>(k); }
                else { ck = static_cast<K>(k); }
                // Convert value
                V cv;
                if constexpr (std::is_same_v<V, SV>) { cv = v; }
                else if constexpr (std::is_pointer_v<V> && std::is_pointer_v<SV>) { cv = static_cast<V>(v); }
                else if constexpr (std::is_same_v<V, int64_t> && std::is_pointer_v<SV>) { cv = dynAs<int64_t>(v); }
                else if constexpr (std::is_same_v<V, double> && std::is_pointer_v<SV>) { cv = dynAs<double>(v); }
                else if constexpr (std::is_same_v<V, bool> && std::is_pointer_v<SV>) { cv = dynAs<bool>(v); }
                else if constexpr (std::is_same_v<V, std::string> && std::is_pointer_v<SV>) { cv = dynAs<std::string>(v); }
                else if constexpr (std::is_pointer_v<V> && std::is_same_v<SV, int64_t>) { cv = static_cast<V>(GC::allocateLocal(new IntBox(v))); }
                else { cv = static_cast<V>(v); }
                result->set(ck, cv);
            }
        }
        return result;
    }

    /// 对齐 Dart: StaticMap.fromEntries(entries)
    static StaticMap* fromEntries(StaticList<StaticMapEntry<K, V>>* entries) {
        auto* result = GC::allocateLocal(new StaticMap());
        if (entries) {
            for (int i = 0; i < entries->length(); i++) {
                auto& e = (*entries)[i];
                result->set(e.key, e.value);
            }
        }
        return result;
    }

    /// 对齐 Dart: StaticMap.unmodifiable(source) — 语义上等同 of（C++ 不强制不可变）
    static StaticMap* unmodifiable(StaticMap<K, V>* source) {
        return of(source);
    }

    /// 对齐 Dart: StaticMap.fromIterables(keys, values)
    static StaticMap* fromIterables(StaticList<K>* keys, StaticList<V>* values) {
        auto* result = GC::allocateLocal(new StaticMap());
        if (keys && values) {
            int len = std::min(keys->length(), values->length());
            for (int i = 0; i < len; i++) {
                result->set((*keys)[i], (*values)[i]);
            }
        }
        return result;
    }

    // ── 核心属性 ──

    int length() const { return _keys->length(); }
    bool isEmpty() const { return _keys->length() == 0; }
    bool isNotEmpty() const { return _keys->length() > 0; }

    // ── 访问 ──

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

    bool containsKey(const K& key) const {
        return _keys->indexOf(key) != -1;
    }

    bool containsValue(const V& value) const {
        return _values->indexOf(value) != -1;
    }

    // ── 集合视图 ──

    StaticList<K>* keys() const {
        auto* result = GC::allocateLocal(new StaticList<K>());
        for (int i = 0; i < _keys->length(); i++) {
            result->add((*_keys)[i]);
        }
        return result;
    }

    StaticList<V>* values() const {
        auto* result = GC::allocateLocal(new StaticList<V>());
        for (int i = 0; i < _values->length(); i++) {
            result->add((*_values)[i]);
        }
        return result;
    }

    StaticList<StaticMapEntry<K, V>>* entries() const;  // 定义在 StaticMapEntry 之后

    // ── 修改 ──

    V remove(const K& key) {
        int idx = _keys->indexOf(key);
        if (idx == -1) return V();
        _keys->removeAt(idx);
        return _values->removeAt(idx);
    }

    void removeWhere(std::function<bool(K, V)> test) {
        for (int i = _keys->length() - 1; i >= 0; i--) {
            if (test((*_keys)[i], (*_values)[i])) {
                _keys->removeAt(i);
                _values->removeAt(i);
            }
        }
    }
    void removeWhere(TypeFunction2<bool, K, V>* test) {
        for (int i = _keys->length() - 1; i >= 0; i--) {
            if (test->call((*_keys)[i], (*_values)[i])) {
                _keys->removeAt(i);
                _values->removeAt(i);
            }
        }
    }

    void clear() {
        _keys->clear();
        _values->clear();
    }

    V putIfAbsent(const K& key, std::function<V()> ifAbsent) {
        int idx = _keys->indexOf(key);
        if (idx != -1) return (*_values)[idx];
        V value = ifAbsent();
        _keys->add(key);
        _values->add(value);
        return value;
    }
    V putIfAbsent(const K& key, TypeFunction0<V>* ifAbsent) {
        int idx = _keys->indexOf(key);
        if (idx != -1) return (*_values)[idx];
        V value = ifAbsent->call();
        _keys->add(key);
        _values->add(value);
        return value;
    }

    V update(const K& key, std::function<V(V)> updateFn, std::function<V()> ifAbsent = nullptr) {
        int idx = _keys->indexOf(key);
        if (idx != -1) {
            V newVal = updateFn((*_values)[idx]);
            (*_values)[idx] = newVal;
            return newVal;
        }
        if (ifAbsent) {
            V newVal = ifAbsent();
            _keys->add(key);
            _values->add(newVal);
            return newVal;
        }
        throw DartArgumentError("Key not found");
    }
    V update(const K& key, TypeFunction1<V, V>* updateFn, TypeFunction0<V>* ifAbsent = nullptr) {
        int idx = _keys->indexOf(key);
        if (idx != -1) {
            V newVal = updateFn->call((*_values)[idx]);
            (*_values)[idx] = newVal;
            return newVal;
        }
        if (ifAbsent) {
            V newVal = ifAbsent->call();
            _keys->add(key);
            _values->add(newVal);
            return newVal;
        }
        throw DartArgumentError("Key not found");
    }

    void updateAll(std::function<V(K, V)> updateFn) {
        for (int i = 0; i < _keys->length(); i++) {
            (*_values)[i] = updateFn((*_keys)[i], (*_values)[i]);
        }
    }
    void updateAll(TypeFunction2<V, K, V>* updateFn) {
        for (int i = 0; i < _keys->length(); i++) {
            (*_values)[i] = updateFn->call((*_keys)[i], (*_values)[i]);
        }
    }

    void addAll(StaticMap<K, V>* other) {
        if (!other) return;
        for (int i = 0; i < other->_keys->length(); i++) {
            set((*other->_keys)[i], (*other->_values)[i]);
        }
    }

    void addEntries(StaticList<StaticMapEntry<K, V>>* newEntries) {
        if (!newEntries) return;
        for (int i = 0; i < newEntries->length(); i++) {
            set((*newEntries)[i].key, (*newEntries)[i].value);
        }
    }

    // ── 函数式 ──

    void forEach(std::function<void(K, V)> action) const {
        for (int i = 0; i < _keys->length(); i++) {
            action((*_keys)[i], (*_values)[i]);
        }
    }
    void forEach(TypeFunction2<void, K, V>* action) const {
        for (int i = 0; i < _keys->length(); i++) {
            action->call((*_keys)[i], (*_values)[i]);
        }
    }

    template<typename K2, typename V2>
    StaticMap<K2, V2>* map(std::function<StaticMapEntry<K2, V2>(const K&, const V&)> convert) const {
        auto* result = new StaticMap<K2, V2>();
        for (int i = 0; i < _keys->length(); i++) {
            auto entry = convert((*_keys)[i], (*_values)[i]);
            result->set(entry.key, entry.value);
        }
        return GC::allocateLocal(result);
    }
    template<typename K2, typename V2>
    StaticMap<K2, V2>* map(TypeFunction2<StaticMapEntry<K2, V2>, K, V>* convert) const {
        auto* result = new StaticMap<K2, V2>();
        for (int i = 0; i < _keys->length(); i++) {
            auto entry = convert->call((*_keys)[i], (*_values)[i]);
            result->set(entry.key, entry.value);
        }
        return GC::allocateLocal(result);
    }

    template<typename RK, typename RV>
    StaticMap<RK, RV>* cast() const {
        auto* result = new StaticMap<RK, RV>();
        for (int i = 0; i < _keys->length(); i++) {
            result->set(static_cast<RK>((*_keys)[i]), static_cast<RV>((*_values)[i]));
        }
        return GC::allocateLocal(result);
    }

    // ── 字符串 ──

    std::string toString() const override {
        if (isEmpty()) return "{}";
        std::string result = "{";
        for (int i = 0; i < _keys->length(); i++) {
            if (i > 0) result += ", ";
            result += dart_str((*_keys)[i]) + ": " + dart_str((*_values)[i]);
        }
        result += "}";
        return result;
    }

    // ── vptrMap support ──
    static AnyGC* _vptr_runtimeType(AnyGC*) {
        return _box(std::string("Map"));
    }
    static AnyGC* _vptr_length(AnyGC* self) {
        return _box(static_cast<int64_t>(static_cast<StaticMap*>(self)->length()));
    }
    static AnyGC* _vptr_toString(AnyGC* self) {
        return _box(static_cast<StaticMap*>(self)->toString());
    }
    static AnyGC* _vptr_index(AnyGC* self, AnyGC* key) {
        auto* map = static_cast<StaticMap*>(self);
        K k;
        if constexpr (std::is_same_v<K, std::string>) k = dynAs<std::string>(key);
        else if constexpr (std::is_same_v<K, int64_t>) k = dynAs<int64_t>(key);
        else if constexpr (std::is_same_v<K, double>) k = dynAs<double>(key);
        else if constexpr (std::is_same_v<K, bool>) k = dynAs<bool>(key);
        else if constexpr (std::is_pointer_v<K>) k = static_cast<K>(key);
        else k = *reinterpret_cast<K*>(dynamic_cast<VPtr*>(key));
        V* val = (*map)[k];
        if (!val) return nullptr;
        return _box(*val);
    }
    static AnyGC* _vptr_containsKey(AnyGC* self, AnyGC* key) {
        auto* map = static_cast<StaticMap*>(self);
        K k;
        if constexpr (std::is_same_v<K, std::string>) k = dynAs<std::string>(key);
        else if constexpr (std::is_same_v<K, int64_t>) k = dynAs<int64_t>(key);
        else if constexpr (std::is_same_v<K, double>) k = dynAs<double>(key);
        else if constexpr (std::is_same_v<K, bool>) k = dynAs<bool>(key);
        else if constexpr (std::is_pointer_v<K>) k = static_cast<K>(key);
        else k = *reinterpret_cast<K*>(dynamic_cast<VPtr*>(key));
        return _box(map->containsKey(k));
    }
    std::unordered_map<std::string, void*>& getVptrMap() override {
        static std::unordered_map<std::string, void*> map;
        if (map.empty()) {
            map["get_runtimeType"] = reinterpret_cast<void*>(&_vptr_runtimeType);
            map["get_length"] = reinterpret_cast<void*>(&_vptr_length);
            map["toString"] = reinterpret_cast<void*>(&_vptr_toString);
            map["[]"] = reinterpret_cast<void*>(&_vptr_index);
            map["containsKey"] = reinterpret_cast<void*>(&_vptr_containsKey);
        }
        return map;
    }

    // ── GC ──

    void gcMark(int flag) override {
        if (gcFlag == flag) return;
        VPtr::gcMark(flag);
        if (_keys) _keys->gcMark(flag);
        if (_values) _values->gcMark(flag);
    }
};

// ── StaticSet<T> ──
// 对齐 Dart _collections.dart StaticSet<T>

template<typename T>
struct StaticSet : AnyGC {
    Array<T>* _data;

    StaticSet() : _data(GC::allocateLocal(new Array<T>())) {}

    StaticSet(std::initializer_list<T> init)
        : _data(GC::allocateLocal(new Array<T>())) {
        for (const auto& e : init) add(e);
    }

    static StaticSet* of(std::initializer_list<T> elements) {
        return GC::allocateLocal(new StaticSet(elements));
    }

    static StaticSet* empty() {
        return GC::allocateLocal(new StaticSet());
    }

    /// 对齐 Dart: StaticSet.from(iterable)
    static StaticSet* from(StaticList<T>* source) {
        auto* result = GC::allocateLocal(new StaticSet());
        if (source) {
            for (int i = 0; i < source->length(); i++) result->add((*source)[i]);
        }
        return result;
    }

    /// 对齐 Dart: StaticSet.unmodifiable(source) — 语义等同 from
    static StaticSet* unmodifiable(StaticSet<T>* source) {
        auto* result = GC::allocateLocal(new StaticSet());
        if (source) {
            for (int i = 0; i < source->length(); i++) result->add(source->elementAt(i));
        }
        return result;
    }

    // ── 核心属性 ──

    int length() const { return _data->length(); }
    bool isEmpty() const { return _data->length() == 0; }
    bool isNotEmpty() const { return _data->length() > 0; }

    T first() const {
        if (isEmpty()) throw DartStateError("No element");
        return (*_data)[0];
    }

    T last() const {
        if (isEmpty()) throw DartStateError("No element");
        return (*_data)[_data->length() - 1];
    }

    T single() const {
        if (_data->length() != 1) throw DartStateError("Not single element");
        return (*_data)[0];
    }

    // ── 修改 ──

    bool add(const T& element) {
        if (_data->contains(element)) return false;
        _data->add(element);
        return true;
    }

    void addAll(StaticSet<T>* other) {
        if (!other) return;
        for (int i = 0; i < other->length(); i++) add((*other->_data)[i]);
    }

    bool remove(const T& element) {
        return _data->remove(element);
    }

    void removeWhere(std::function<bool(T)> test) {
        for (int i = _data->length() - 1; i >= 0; i--) {
            if (test((*_data)[i])) _data->removeAt(i);
        }
    }
    void removeWhere(TypeFunction1<bool, T>* test) {
        for (int i = _data->length() - 1; i >= 0; i--) {
            if (test->call((*_data)[i])) _data->removeAt(i);
        }
    }

    void retainWhere(std::function<bool(T)> test) {
        for (int i = _data->length() - 1; i >= 0; i--) {
            if (!test((*_data)[i])) _data->removeAt(i);
        }
    }
    void retainWhere(TypeFunction1<bool, T>* test) {
        for (int i = _data->length() - 1; i >= 0; i--) {
            if (!test->call((*_data)[i])) _data->removeAt(i);
        }
    }

    void clear() { _data->clear(); }

    // ── 查询 ──

    bool contains(const T& element) const {
        return _data->contains(element);
    }

    T* lookup(const T& element) {
        int idx = _data->indexOf(element);
        if (idx == -1) return nullptr;
        return &(*_data)[idx];
    }

    T elementAt(int index) const { return (*_data)[index]; }

    // ── 迭代器 ──

    StaticIterator<T>* iterator() {
        return GC::allocateLocal(new StaticIterator<T>(_data));
    }

    typename std::vector<T>::iterator begin() { return _data->begin(); }
    typename std::vector<T>::iterator end() { return _data->end(); }
    typename std::vector<T>::const_iterator begin() const { return _data->begin(); }
    typename std::vector<T>::const_iterator end() const { return _data->end(); }

    // ── 高阶方法 ──

    void forEach(std::function<void(T)> action) const {
        for (int i = 0; i < _data->length(); i++) action((*_data)[i]);
    }
    void forEach(TypeFunction1<void, T>* action) const {
        for (int i = 0; i < _data->length(); i++) action->call((*_data)[i]);
    }

    template<typename R>
    StaticList<R>* map(std::function<R(T)> convert) const {
        auto* result = new StaticList<R>();
        for (int i = 0; i < _data->length(); i++) result->add(convert((*_data)[i]));
        return GC::allocateLocal(result);
    }
    template<typename R>
    StaticList<R>* map(TypeFunction1<R, T>* convert) const {
        auto* result = new StaticList<R>();
        for (int i = 0; i < _data->length(); i++) result->add(convert->call((*_data)[i]));
        return GC::allocateLocal(result);
    }

    StaticSet<T>* where(std::function<bool(T)> test) const {
        auto* result = new StaticSet<T>();
        for (int i = 0; i < _data->length(); i++) {
            if (test((*_data)[i])) result->add((*_data)[i]);
        }
        return GC::allocateLocal(result);
    }
    StaticSet<T>* where(TypeFunction1<bool, T>* test) const {
        auto* result = new StaticSet<T>();
        for (int i = 0; i < _data->length(); i++) {
            if (test->call((*_data)[i])) result->add((*_data)[i]);
        }
        return GC::allocateLocal(result);
    }

    bool any(std::function<bool(T)> test) const {
        for (int i = 0; i < _data->length(); i++) {
            if (test((*_data)[i])) return true;
        }
        return false;
    }
    bool any(TypeFunction1<bool, T>* test) const {
        for (int i = 0; i < _data->length(); i++) {
            if (test->call((*_data)[i])) return true;
        }
        return false;
    }

    bool every(std::function<bool(T)> test) const {
        for (int i = 0; i < _data->length(); i++) {
            if (!test((*_data)[i])) return false;
        }
        return true;
    }

    bool every(TypeFunction1<bool, T>* test) const {
        for (int i = 0; i < _data->length(); i++) {
            if (!test->call((*_data)[i])) return false;
        }
        return true;
    }

    T reduce(std::function<T(T, T)> combine) const {
        if (isEmpty()) throw DartStateError("No element");
        T value = (*_data)[0];
        for (int i = 1; i < _data->length(); i++) value = combine(value, (*_data)[i]);
        return value;
    }
    T reduce(TypeFunction2<T, T, T>* combine) const {
        if (isEmpty()) throw DartStateError("No element");
        T value = (*_data)[0];
        for (int i = 1; i < _data->length(); i++) value = combine->call(value, (*_data)[i]);
        return value;
    }

    template<typename R>
    R fold(R initialValue, std::function<R(R, T)> combine) const {
        R value = initialValue;
        for (int i = 0; i < _data->length(); i++) value = combine(value, (*_data)[i]);
        return value;
    }
    template<typename R>
    R fold(R initialValue, TypeFunction2<R, R, T>* combine) const {
        R value = initialValue;
        for (int i = 0; i < _data->length(); i++) value = combine->call(value, (*_data)[i]);
        return value;
    }

    T firstWhere(std::function<bool(T)> test, std::function<T()> orElse = nullptr) const {
        for (int i = 0; i < _data->length(); i++) {
            if (test((*_data)[i])) return (*_data)[i];
        }
        if (orElse) return orElse();
        throw DartStateError("No element");
    }
    T firstWhere(TypeFunction1<bool, T>* test, TypeFunction0<T>* orElse = nullptr) const {
        for (int i = 0; i < _data->length(); i++) {
            if (test->call((*_data)[i])) return (*_data)[i];
        }
        if (orElse) return orElse->call();
        throw DartStateError("No element");
    }

    T lastWhere(std::function<bool(T)> test, std::function<T()> orElse = nullptr) const {
        for (int i = _data->length() - 1; i >= 0; i--) {
            if (test((*_data)[i])) return (*_data)[i];
        }
        if (orElse) return orElse();
        throw DartStateError("No element");
    }
    T lastWhere(TypeFunction1<bool, T>* test, TypeFunction0<T>* orElse = nullptr) const {
        for (int i = _data->length() - 1; i >= 0; i--) {
            if (test->call((*_data)[i])) return (*_data)[i];
        }
        if (orElse) return orElse->call();
        throw DartStateError("No element");
    }

    T singleWhere(std::function<bool(T)> test, std::function<T()> orElse = nullptr) const {
        bool foundMultiple = false;
        T found{};
        bool hasFound = false;
        for (int i = 0; i < _data->length(); i++) {
            if (test((*_data)[i])) {
                if (hasFound) { foundMultiple = true; break; }
                found = (*_data)[i];
                hasFound = true;
            }
        }
        if (foundMultiple) throw DartStateError("Too many elements");
        if (hasFound) return found;
        if (orElse) return orElse();
        throw DartStateError("No element");
    }
    T singleWhere(TypeFunction1<bool, T>* test, TypeFunction0<T>* orElse = nullptr) const {
        bool foundMultiple = false;
        T found{};
        bool hasFound = false;
        for (int i = 0; i < _data->length(); i++) {
            if (test->call((*_data)[i])) {
                if (hasFound) { foundMultiple = true; break; }
                found = (*_data)[i];
                hasFound = true;
            }
        }
        if (foundMultiple) throw DartStateError("Too many elements");
        if (hasFound) return found;
        if (orElse) return orElse->call();
        throw DartStateError("No element");
    }

    template<typename R>
    StaticList<R>* expand(std::function<StaticList<R>*(T)> convert) const {
        auto* result = new StaticList<R>();
        for (int i = 0; i < _data->length(); i++) {
            auto* inner = convert((*_data)[i]);
            if (inner) result->addAll(inner);
        }
        return GC::allocateLocal(result);
    }

    // ── 集合运算 ──

    StaticSet<T>* unionSet(StaticSet<T>* other) const {
        auto* result = new StaticSet<T>();
        for (int i = 0; i < _data->length(); i++) result->add((*_data)[i]);
        if (other) {
            for (int i = 0; i < other->length(); i++) result->add((*other->_data)[i]);
        }
        return GC::allocateLocal(result);
    }

    StaticSet<T>* intersection(StaticSet<T>* other) const {
        auto* result = new StaticSet<T>();
        if (!other) return GC::allocateLocal(result);
        for (int i = 0; i < _data->length(); i++) {
            if (other->contains((*_data)[i])) result->add((*_data)[i]);
        }
        return GC::allocateLocal(result);
    }

    StaticSet<T>* difference(StaticSet<T>* other) const {
        auto* result = new StaticSet<T>();
        for (int i = 0; i < _data->length(); i++) {
            if (!other || !other->contains((*_data)[i])) result->add((*_data)[i]);
        }
        return GC::allocateLocal(result);
    }

    // ── 变换 ──

    StaticList<T>* toStaticList() const {
        auto* result = new StaticList<T>();
        for (int i = 0; i < _data->length(); i++) result->add((*_data)[i]);
        return GC::allocateLocal(result);
    }

    StaticSet<T>* toStaticSet() const {
        auto* result = new StaticSet<T>();
        for (int i = 0; i < _data->length(); i++) result->add((*_data)[i]);
        return GC::allocateLocal(result);
    }

    template<typename R>
    StaticSet<R>* cast() const {
        auto* result = new StaticSet<R>();
        for (int i = 0; i < _data->length(); i++) {
            result->add(static_cast<R>((*_data)[i]));
        }
        return GC::allocateLocal(result);
    }

    StaticSet<T>* followedBy(StaticSet<T>* other) const {
        return unionSet(other);
    }

    StaticSet<T>* take(int count) const {
        auto* result = new StaticSet<T>();
        int end = count < _data->length() ? count : _data->length();
        for (int i = 0; i < end; i++) result->add((*_data)[i]);
        return GC::allocateLocal(result);
    }

    StaticSet<T>* skip(int count) const {
        auto* result = new StaticSet<T>();
        for (int i = count; i < _data->length(); i++) result->add((*_data)[i]);
        return GC::allocateLocal(result);
    }

    StaticSet<T>* takeWhile(std::function<bool(T)> test) const {
        auto* result = new StaticSet<T>();
        for (int i = 0; i < _data->length(); i++) {
            if (!test((*_data)[i])) break;
            result->add((*_data)[i]);
        }
        return GC::allocateLocal(result);
    }
    StaticSet<T>* takeWhile(TypeFunction1<bool, T>* test) const {
        auto* result = new StaticSet<T>();
        for (int i = 0; i < _data->length(); i++) {
            if (!test->call((*_data)[i])) break;
            result->add((*_data)[i]);
        }
        return GC::allocateLocal(result);
    }

    StaticSet<T>* skipWhile(std::function<bool(T)> test) const {
        auto* result = new StaticSet<T>();
        bool skipping = true;
        for (int i = 0; i < _data->length(); i++) {
            if (skipping && test((*_data)[i])) continue;
            skipping = false;
            result->add((*_data)[i]);
        }
        return GC::allocateLocal(result);
    }
    StaticSet<T>* skipWhile(TypeFunction1<bool, T>* test) const {
        auto* result = new StaticSet<T>();
        bool skipping = true;
        for (int i = 0; i < _data->length(); i++) {
            if (skipping && test->call((*_data)[i])) continue;
            skipping = false;
            result->add((*_data)[i]);
        }
        return GC::allocateLocal(result);
    }

    // ── 字符串 ──

    std::string join(const std::string& separator = "") const {
        std::string result;
        for (int i = 0; i < _data->length(); i++) {
            if (i > 0) result += separator;
            result += dart_str((*_data)[i]);
        }
        return result;
    }

    std::string toString() const override {
        return "{" + join(", ") + "}";
    }

    // ── GC ──

    void gcMark(int flag) override {
        if (gcFlag == flag) return;
        AnyGC::gcMark(flag);
        if (_data) _data->gcMark(flag);
    }
};

// ── StaticList 延迟实现（依赖 StaticMap / StaticSet 完整类型） ──

template<typename T>
StaticMap<int, T>* StaticList<T>::asMap() const {
    auto* result = new StaticMap<int, T>();
    for (int i = 0; i < _data->length(); i++) {
        result->set(i, (*_data)[i]);
    }
    return GC::allocateLocal(result);
}

template<typename T>
StaticSet<T>* StaticList<T>::toStaticSet() const {
    auto* result = new StaticSet<T>();
    for (int i = 0; i < _data->length(); i++) result->add((*_data)[i]);
    return GC::allocateLocal(result);
}

template<typename K, typename V>
StaticList<StaticMapEntry<K, V>>* StaticMap<K, V>::entries() const {
    auto* result = new StaticList<StaticMapEntry<K, V>>();
    for (int i = 0; i < _keys->length(); i++) {
        result->add(StaticMapEntry<K, V>((*_keys)[i], (*_values)[i]));
    }
    return GC::allocateLocal(result);
}

// ============================================================================
// 9. Promise / GlobalScheduler / smAwait — 协作式异步
// ============================================================================

// ── PromiseBase ──
// 对齐 Dart _async.dart Promise / GlobalScheduler / smAwait

// 前向声明
class GlobalScheduler;

struct PromiseBase : AnyGC {
    enum State { READY, PENDING, COMPLETED, ERROR };

    State state = PENDING;
    AnyGC* result = nullptr;
    AnyGC* error = nullptr;
    std::function<void()> startCallback;
    std::function<bool()> onTick;

    // setStartCallback / setTickCallback 延迟实现（在 GlobalScheduler 之后）
    void setStartCallback(std::function<void()> cb);
    void setTickCallback(std::function<bool()> cb);

    void complete(AnyGC* value) {
        if (state == COMPLETED || state == ERROR) {
            throw DartStateError("Promise already resolved");
        }
        result = value;
        state = COMPLETED;
    }

    void completeError(AnyGC* err) {
        if (state == COMPLETED || state == ERROR) {
            throw DartStateError("Promise already resolved");
        }
        error = err;
        state = ERROR;
    }

    bool isCompleted() const { return state == COMPLETED; }
    bool isError() const { return state == ERROR; }
    bool isReady() const { return state == READY; }
    bool isPending() const { return state == PENDING; }

    void gcMark(int flag) override {
        if (gcFlag == flag) return;
        AnyGC::gcMark(flag);
        if (result) result->gcMark(flag);
        if (error) error->gcMark(flag);
    }
};

// ── Promise<T> ──

template<typename T>
struct Promise : PromiseBase {
    T typedResult() const { return dynAs<T>(result); }

    void completeTyped(T value) {
        complete(_box(std::move(value)));
    }

    // ── 静态工厂 ──

    static Promise<T>* resolved(T value) {
        auto* promise = GC::allocateLocal(new Promise<T>());
        promise->complete(_box(std::move(value)));
        return promise;
    }

    static Promise<T>* value(T value) {
        return resolved(std::move(value));
    }

    static Promise<T>* rejected(AnyGC* err) {
        auto* promise = GC::allocateLocal(new Promise<T>());
        promise->completeError(err);
        return promise;
    }

    // delayed / then / catchError / whenComplete — 声明在类内，定义在 GlobalScheduler 之后
    static Promise<T>* delayed(int ticks, std::function<T()> computation);

    template<typename R = AnyGC*>
    Promise<R>* then(std::function<AnyGC*(T)> onValue);

    Promise<T>* catchError(std::function<T(AnyGC*)> onError);

    Promise<T>* whenComplete(std::function<void()> action);

    // ── 静态组合方法 — 对标 Future.wait / Future.any / Future.forEach ──
    // 声明在类内，定义在 GlobalScheduler 之后

    /// Promise<T>::waitAll — 等待所有 Promise 完成，返回结果列表
    static Promise<StaticList<T>*>* waitAll(std::vector<Promise<T>*> promises);

    /// Promise<T>::any — 返回第一个完成的 Promise 的结果（竞赛语义）
    static Promise<T>* any(std::vector<Promise<T>*> promises);
};

// ── Promise<void> 特化 — 避免 void 参数类型问题 ──
template<>
struct Promise<void> : PromiseBase {
    void completeTyped() {
        complete(nullptr);
    }

    static Promise<void>* resolved() {
        auto* promise = GC::allocateLocal(new Promise<void>());
        promise->complete(nullptr);
        return promise;
    }

    static Promise<void>* value() {
        return resolved();
    }

    static Promise<void>* rejected(AnyGC* err) {
        auto* promise = GC::allocateLocal(new Promise<void>());
        promise->completeError(err);
        return promise;
    }

    static Promise<void>* delayed(int ticks, std::function<void()> computation);
};

// ── GlobalScheduler ──

// _DelayedTask — 延迟任务记录（对齐 Dart _async.dart _DelayedTask）
struct _DelayedTask {
    int targetTick;
    std::function<void()> callback;
    PromiseBase* targetPromise;  // 用于 GC 标记

    _DelayedTask(int tick, std::function<void()> cb, PromiseBase* promise = nullptr)
        : targetTick(tick), callback(std::move(cb)), targetPromise(promise) {}
};

class GlobalScheduler : public AnyGC {
    std::vector<PromiseBase*> _activePromises;
    std::vector<_DelayedTask> _delayedTasks;
    std::vector<PromiseBase*> _readyPromises;

    GlobalScheduler() {
        _gcStatic = true;  // 静态 singleton，GC 不管理其生命周期
        GC::allocateGlobal(this);
    }

public:
    int64_t _currentTick = 0;

    static GlobalScheduler& instance() {
        static GlobalScheduler inst;
        return inst;
    }

    void gcMark(int flag) override {
        if (gcFlag == flag) return;
        AnyGC::gcMark(flag);
        for (auto* p : _activePromises) {
            if (p) p->gcMark(flag);
        }
        for (auto* p : _readyPromises) {
            if (p) p->gcMark(flag);
        }
        // 标记延迟任务关联的 Promise
        for (auto& task : _delayedTasks) {
            if (task.targetPromise) task.targetPromise->gcMark(flag);
        }
    }

    void registerActivePromise(PromiseBase* p) {
        _activePromises.push_back(p);
    }

    void registerDelayedTask(int ticks, std::function<void()> cb,
                             PromiseBase* targetPromise = nullptr) {
        _delayedTasks.emplace_back(_currentTick + ticks, std::move(cb), targetPromise);
    }

    void registerReadyPromise(PromiseBase* p) {
        _readyPromises.push_back(p);
    }

    void tick() {
        _currentTick++;

        // 第一阶段：触发所有 ready 状态的 Promise 的启动回调
        auto readyCopy = _readyPromises;
        _readyPromises.clear();
        for (auto* p : readyCopy) {
            if (p->isReady() && p->startCallback) {
                p->state = PromiseBase::PENDING;
                p->startCallback();
                p->startCallback = nullptr;
            }
        }

        // 第二阶段：触发到期的延迟任务
        for (auto it = _delayedTasks.begin(); it != _delayedTasks.end(); ) {
            if (it->targetTick <= _currentTick) {
                it->callback();
                it = _delayedTasks.erase(it);
            } else {
                ++it;
            }
        }

        // 第三阶段：驱动所有活跃 Promise
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

    int tickCount() const { return static_cast<int>(_currentTick); }

    void reset() {
        _activePromises.clear();
        _delayedTasks.clear();
        _readyPromises.clear();
        _currentTick = 0;
        gcFlag = 0;
        GC::allocateGlobal(this);
    }
};

// ── PromiseBase 延迟实现（依赖 GlobalScheduler 完整类型） ──

inline void PromiseBase::setStartCallback(std::function<void()> cb) {
    startCallback = std::move(cb);
    GC::allocateLocal(this);
    state = READY;
    GlobalScheduler::instance().registerReadyPromise(this);
}

inline void PromiseBase::setTickCallback(std::function<bool()> cb) {
    onTick = std::move(cb);
    GC::allocateLocal(this);
    GlobalScheduler::instance().registerActivePromise(this);
}

// ── Promise<T> 延迟实现（依赖 GlobalScheduler 完整类型） ──

template<typename T>
Promise<T>* Promise<T>::delayed(int ticks, std::function<T()> computation) {
    auto* promise = GC::allocateLocal(new Promise<T>());
    GlobalScheduler::instance().registerDelayedTask(ticks, [promise, computation]() {
        try {
            promise->complete(_box(computation()));
        } catch (const std::exception& e) {
            promise->completeError(_box(std::string(e.what())));
        } catch (...) {
            promise->completeError(nullptr);
        }
    }, promise);
    return promise;
}

template<typename T>
template<typename R>
Promise<R>* Promise<T>::then(std::function<AnyGC*(T)> onValue) {
    // 延迟分配优化：如果已完成，直接执行回调并返回结果
    if (isCompleted()) {
        try {
            AnyGC* callbackResult = onValue(dynAs<T>(result));
            AnyGC* gcResult = callbackResult;
            PromiseBase* innerPromise = gcResult ? dynamic_cast<PromiseBase*>(gcResult) : nullptr;
            if (innerPromise) {
                // flatMap 场景：返回内部 Promise
                auto* nextPromise = GC::allocateLocal(new Promise<R>());
                auto* capturedInner = innerPromise;
                nextPromise->onTick = [capturedInner, nextPromise]() -> bool {
                    if (capturedInner->isCompleted()) {
                        nextPromise->complete(capturedInner->result);
                        return true;
                    }
                    if (capturedInner->isError()) {
                        nextPromise->completeError(capturedInner->error);
                        return true;
                    }
                    return false;
                };
                GlobalScheduler::instance().registerActivePromise(nextPromise);
                return nextPromise;
            }
            // 直接结果：创建已完成的 Promise
            auto* nextPromise = GC::allocateLocal(new Promise<R>());
            nextPromise->complete(callbackResult);
            return nextPromise;
        } catch (const std::exception& e) {
            auto* nextPromise = GC::allocateLocal(new Promise<R>());
            nextPromise->completeError(_box(std::string(e.what())));
            return nextPromise;
        }
    }

    // 如果已错误，直接传递错误
    if (isError()) {
        auto* nextPromise = GC::allocateLocal(new Promise<R>());
        nextPromise->completeError(error);
        return nextPromise;
    }

    // 正常场景：延迟执行
    auto* nextPromise = GC::allocateLocal(new Promise<R>());
    auto* self = this;
    nextPromise->onTick = [self, onValue, nextPromise]() -> bool {
        if (self->isCompleted()) {
            try {
                AnyGC* callbackResult = onValue(dynAs<T>(self->result));
                AnyGC* gcResult = callbackResult;
                PromiseBase* innerPromise = gcResult ? dynamic_cast<PromiseBase*>(gcResult) : nullptr;
                if (innerPromise) {
                    nextPromise->onTick = [innerPromise, nextPromise]() -> bool {
                        if (innerPromise->isCompleted()) {
                            nextPromise->complete(innerPromise->result);
                            return true;
                        }
                        if (innerPromise->isError()) {
                            nextPromise->completeError(innerPromise->error);
                            return true;
                        }
                        return false;
                    };
                    return false;
                }
                nextPromise->complete(callbackResult);
            } catch (const std::exception& e) {
                nextPromise->completeError(_box(std::string(e.what())));
            }
            return true;
        }
        if (self->isError()) {
            nextPromise->completeError(self->error);
            return true;
        }
        return false;
    };
    GlobalScheduler::instance().registerActivePromise(nextPromise);
    return nextPromise;
}

template<typename T>
Promise<T>* Promise<T>::catchError(std::function<T(AnyGC*)> onError) {
    // 延迟分配优化：如果已完成，直接传递结果
    if (isCompleted()) {
        auto* nextPromise = GC::allocateLocal(new Promise<T>());
        nextPromise->complete(result);
        return nextPromise;
    }

    // 如果已错误，执行错误处理
    if (isError()) {
        auto* nextPromise = GC::allocateLocal(new Promise<T>());
        try {
            nextPromise->complete(_box(onError(error)));
        } catch (const std::exception& e) {
            nextPromise->completeError(_box(std::string(e.what())));
        }
        return nextPromise;
    }

    // 正常场景：延迟执行
    auto* nextPromise = GC::allocateLocal(new Promise<T>());
    auto* self = this;
    nextPromise->onTick = [self, onError, nextPromise]() -> bool {
        if (self->isCompleted()) {
            nextPromise->complete(self->result);
            return true;
        }
        if (self->isError()) {
            try {
                nextPromise->complete(_box(onError(self->error)));
            } catch (const std::exception& e) {
                nextPromise->completeError(_box(std::string(e.what())));
            }
            return true;
        }
        return false;
    };
    GlobalScheduler::instance().registerActivePromise(nextPromise);
    return nextPromise;
}

template<typename T>
Promise<T>* Promise<T>::whenComplete(std::function<void()> action) {
    // 延迟分配优化：如果已完成，执行 action 并传递结果
    if (isCompleted()) {
        auto* nextPromise = GC::allocateLocal(new Promise<T>());
        try {
            action();
            nextPromise->complete(result);
        } catch (const std::exception& e) {
            nextPromise->completeError(_box(std::string(e.what())));
        }
        return nextPromise;
    }

    // 如果已错误，执行 action 并传递错误
    if (isError()) {
        auto* nextPromise = GC::allocateLocal(new Promise<T>());
        try { action(); } catch (...) {}
        nextPromise->completeError(error);
        return nextPromise;
    }

    // 正常场景：延迟执行
    auto* nextPromise = GC::allocateLocal(new Promise<T>());
    auto* self = this;
    nextPromise->onTick = [self, action, nextPromise]() -> bool {
        if (self->isCompleted()) {
            try {
                action();
                nextPromise->complete(self->result);
            } catch (const std::exception& e) {
                nextPromise->completeError(_box(std::string(e.what())));
            }
            return true;
        }
        if (self->isError()) {
            try { action(); } catch (...) {}
            nextPromise->completeError(self->error);
            return true;
        }
        return false;
    };
    GlobalScheduler::instance().registerActivePromise(nextPromise);
    return nextPromise;
}

// ── Promise<T>::waitAll — 等待所有 Promise 完成，返回结果列表 ──

template<typename T>
Promise<StaticList<T>*>* Promise<T>::waitAll(std::vector<Promise<T>*> promises) {
    auto* resultPromise = GC::allocateLocal(new Promise<StaticList<T>*>());
    if (promises.empty()) {
        resultPromise->complete(_box(
            GC::allocateLocal(new StaticList<T>())));
        return resultPromise;
    }

    auto* results = new std::vector<AnyGC*>(promises.size(), nullptr);
    auto* completedCount = new int(0);
    auto total = promises.size();

    resultPromise->onTick = [promises, resultPromise, results, completedCount, total]() -> bool {
        for (size_t i = 0; i < promises.size(); i++) {
            auto* p = promises[i];
            if (p->state == ERROR) {
                resultPromise->completeError(p->error);
                delete results; delete completedCount;
                return true;
            }
            if (p->state == COMPLETED && (*results)[i] == nullptr) {
                (*results)[i] = p->result;
                (*completedCount)++;
            }
        }
        if (*completedCount == static_cast<int>(total)) {
            auto* list = GC::allocateLocal(new StaticList<T>());
            for (const auto& r : *results) {
                list->add(dynAs<T>(r));
            }
            resultPromise->complete(_box(list));
            delete results; delete completedCount;
            return true;
        }
        return false;
    };
    GlobalScheduler::instance().registerActivePromise(resultPromise);
    return resultPromise;
}

// ── Promise<T>::any — 返回第一个完成的 Promise 的结果（竞赛语义） ──

template<typename T>
Promise<T>* Promise<T>::any(std::vector<Promise<T>*> promises) {
    auto* resultPromise = GC::allocateLocal(new Promise<T>());
    if (promises.empty()) {
        return resultPromise; // 永远 pending
    }

    resultPromise->onTick = [promises, resultPromise]() -> bool {
        for (auto* p : promises) {
            if (p->state == COMPLETED) {
                resultPromise->complete(p->result);
                return true;
            }
            if (p->state == ERROR) {
                resultPromise->completeError(p->error);
                return true;
            }
        }
        return false;
    };
    GlobalScheduler::instance().registerActivePromise(resultPromise);
    return resultPromise;
}

// ── delayed() free function — mirrors Promise.delayed in Dart ──
template<typename T>
Promise<T>* delayed(int ticks, TypeFunction0<T>* computation) {
    return Promise<T>::delayed(ticks, [computation]() -> T {
        return computation->call();
    });
}

// ── Promise_value / Promise_delayed / Promise_then — lowered 函数包装器 ──
// 这些函数对应 lowered Dart 代码中的 Promise_value, Promise_delayed, Promise_then

template<typename T>
Promise<T>* Promise_value(T val) {
    return Promise<T>::resolved(val);
}

template<typename T>
Promise<T>* Promise_delayed(int64_t delayTicks, TypeFunction0<T>* computation) {
    return Promise<T>::delayed(static_cast<int>(delayTicks), [computation]() -> T {
        return computation->call();
    });
}

template<typename T, typename R>
Promise<R>* Promise_then(Promise<T>* this__, TypeFunction1<R, T>* onValue) {
    auto* resultPromise = GC::allocateLocal(new Promise<R>());
    this__->then([onValue, resultPromise](T val) -> AnyGC* {
        if constexpr (std::is_void_v<R>) {
            onValue->call(val);
        } else {
            R result = onValue->call(val);
            resultPromise->completeTyped(std::move(result));
        }
        return nullptr;
    });
    return resultPromise;
}

// Overload: callback uses AnyGC* parameter (common for tear-offs)
// while Promise value type is a primitive (int64_t, double, bool, std::string)
template<typename T, typename R>
Promise<R>* Promise_then(Promise<T>* this__, TypeFunction1<R, AnyGC*>* onValue) {
    auto* resultPromise = GC::allocateLocal(new Promise<R>());
    this__->then([onValue, resultPromise](T val) -> AnyGC* {
        AnyGC* boxed = _box(val);
        if constexpr (std::is_void_v<R>) {
            onValue->call(boxed);
        } else {
            R result = onValue->call(boxed);
            resultPromise->completeTyped(std::move(result));
        }
        return nullptr;
    });
    return resultPromise;
}

// ── smAwait<T> — 阻塞式 await（对齐 Dart smAwait，含递归深度计数） ──

static int _smAwaitDepth = 0;
static const int _smAwaitMaxDepth = 500;

// RAII guard for smAwait depth tracking
struct SmAwaitDepthGuard {
    SmAwaitDepthGuard() {
        _smAwaitDepth++;
        if (_smAwaitDepth > _smAwaitMaxDepth) {
            _smAwaitDepth--;
            throw DartStateError("smAwait recursion depth exceeded " +
                std::to_string(_smAwaitMaxDepth));
        }
    }
    ~SmAwaitDepthGuard() {
        _smAwaitDepth--;
    }
    // 禁用拷贝和移动
    SmAwaitDepthGuard(const SmAwaitDepthGuard&) = delete;
    SmAwaitDepthGuard& operator=(const SmAwaitDepthGuard&) = delete;
};

template<typename T>
T smAwait(PromiseBase* promise) {
    if (!promise) {
        throw DartStateError("smAwait: null promise");
    }

    // RAII guard ensures depth is always decremented, even on exceptions
    SmAwaitDepthGuard depthGuard;

    // 如果已完成，直接返回
    if (promise->isCompleted()) return dynAs<T>(promise->result);
    if (promise->isError()) {
        throw DartException("Promise completed with error: " +
            _anyToString(promise->error));
    }

    // 如果是 READY，启动回调
    if (promise->isReady() && promise->startCallback) {
        promise->state = PromiseBase::PENDING;
        promise->startCallback();
        promise->startCallback = nullptr;
        if (promise->isCompleted()) return dynAs<T>(promise->result);
        if (promise->isError()) {
            throw DartException("Promise completed with error");
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
        throw DartStateError("smAwait: deadlock detected after " +
            std::to_string(maxRounds) + " ticks");
    }

    if (promise->isError()) {
        throw DartException("Promise completed with error: " +
            _anyToString(promise->error));
    }

    if constexpr (std::is_same_v<T, AnyGC*>) {
        return promise->result;
    } else {
        return dynAs<T>(promise->result);
    }
}

// ── smAwait<void> specialization ──
template<>
inline void smAwait<void>(PromiseBase* promise) {
    if (!promise) {
        throw DartStateError("smAwait: null promise");
    }
    SmAwaitDepthGuard depthGuard;
    if (promise->isCompleted()) return;
    if (promise->isError()) {
        throw DartException("Promise completed with error: " +
            _anyToString(promise->error));
    }
    if (promise->isReady() && promise->startCallback) {
        promise->state = PromiseBase::PENDING;
        promise->startCallback();
        promise->startCallback = nullptr;
        if (promise->isCompleted()) return;
        if (promise->isError()) {
            throw DartException("Promise completed with error");
        }
    }
    int maxRounds = 100000;
    int rounds = 0;
    while (!promise->isCompleted() && !promise->isError() && rounds < maxRounds) {
        GlobalScheduler::instance().tick();
        rounds++;
    }
    if (rounds >= maxRounds) {
        throw DartStateError("smAwait: deadlock detected");
    }
    if (promise->isError()) {
        throw DartException("Promise completed with error: " +
            _anyToString(promise->error));
    }
}

// ── smAwait passthrough for non-Promise values ──
template<typename T>
inline T smAwait(T value) {
    return value;
}

// ── smAwait(AnyGC*) overloads — 从 AnyGC* 中提取 PromiseBase* ──
template<typename T>
inline T smAwait(AnyGC* promiseValue) {
    // 检查是否真的是 Promise
    PromiseBase* promise = promiseValue ? dynamic_cast<PromiseBase*>(promiseValue) : nullptr;
    if (!promise) {
        // 不是 Promise，直接透传（await non-Future）
        if constexpr (std::is_same_v<T, AnyGC*>) {
            return promiseValue;
        } else {
            return dynAs<T>(promiseValue);
        }
    }
    return smAwait<T>(promise);
}

template<>
inline void smAwait<void>(AnyGC* promiseValue) {
    PromiseBase* promise = promiseValue ? dynamic_cast<PromiseBase*>(promiseValue) : nullptr;
    if (!promise) return;
    smAwait<void>(promise);
}

// Overload for AnyGC* passthrough
inline AnyGC* smAwait(AnyGC* value) {
    return value;
}

// ── promiseDelayed（对齐 Dart promiseDelayed） ──

inline PromiseBase* promiseDelayed(int ticks, std::function<AnyGC*()> computation) {
    auto* promise = GC::allocateLocal(new PromiseBase());
    GlobalScheduler::instance().registerDelayedTask(ticks, [promise, computation]() {
        try {
            AnyGC* result = computation();
            promise->complete(result);
        } catch (const std::exception& e) {
            promise->completeError(_box(std::string(e.what())));
        }
    }, promise);
    return promise;
}

// ── AsyncStateMachine<T> ──

template<typename T>
struct AsyncStateMachine : AnyGC {
    int smState = 0;
    Promise<T>* promise;

    AsyncStateMachine() {
        promise = GC::allocateLocal(new Promise<T>());
    }

    virtual bool step() = 0;

    void completeWith(T value) { promise->completeTyped(std::move(value)); }
    void completeWithError(AnyGC* error) { promise->completeError(error); }

    Promise<T>* start() {
        auto* self = this;
        promise->onTick = [self]() -> bool {
            return self->step();
        };
        GlobalScheduler::instance().registerActivePromise(promise);
        return promise;
    }

    void gcMark(int flag) override {
        if (gcFlag == flag) return;
        AnyGC::gcMark(flag);
        if (promise) promise->gcMark(flag);
    }
};

// ── AsyncStateMachine lowered 函数包装器 ──
template<typename T> void AsyncStateMachine_completeWith(AsyncStateMachine<T>* this__, T value) {
    this__->completeWith(std::move(value));
}
template<typename T> void AsyncStateMachine_completeWithError(AsyncStateMachine<T>* this__, AnyGC* error) {
    this__->completeWithError(error);
}
template<typename T> Promise<T>* AsyncStateMachine_start(AsyncStateMachine<T>* this__) {
    return this__->start();
}
template<typename T> bool AsyncStateMachine_step(AsyncStateMachine<T>* this__) {
    return this__->step();
}
template<typename T> AsyncStateMachine<T>* AsyncStateMachine_new(AsyncStateMachine<T>* this__) {
    this__->smState = 0;
    this__->promise = GC::allocateLocal(new Promise<T>());
    return this__;
}

// ============================================================================
// 10. 语义包装 — staticPrint / StaticStringBuffer
// ============================================================================

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

/// staticPrint 重载 — VPtr* 类型（通过 toString 派发）
inline void staticPrint(VPtr* value) {
    std::cout << (value ? value->toString() : "null") << std::endl;
}

/// staticPrint 重载 — 任意 GC 管理的对象指针（StaticList*, StaticMap* 等）
template<typename T>
inline typename std::enable_if<std::is_base_of<AnyGC, T>::value &&
    !std::is_same<T, VPtr>::value &&
    !std::is_same<T, AnyGC>::value && !std::is_same<T, std::string>::value, void>::type
staticPrint(T* value) {
    if (!value) {
        std::cout << "null" << std::endl;
    } else {
        std::cout << dart_str(value) << std::endl;
    }
}

/// staticPrint 重载 — AnyGC* 基类指针
inline void staticPrint(AnyGC* value) {
    if (!value) {
        std::cout << "null" << std::endl;
    } else {
        // 尝试通过 VPtr 派发 toString，否则打印地址
        auto* vp = dynamic_cast<VPtr*>(value);
        if (vp) {
            std::cout << vp->toString() << std::endl;
        } else {
            std::cout << "Instance@" << reinterpret_cast<uintptr_t>(value) << std::endl;
        }
    }
}

/// staticPrint 重载 — 异常类型
inline void staticPrint(const std::exception& e) {
    std::cout << e.what() << std::endl;
}

/// staticPrint 重载 — nullptr
inline void staticPrint(std::nullptr_t) {
    std::cout << "null" << std::endl;
}

/// StaticStringBuffer — 替代 Dart 的 StringBuffer
struct StaticStringBuffer : AnyGC {
    std::ostringstream _buf;

    void write(AnyGC* value) {
        _buf << _anyToString(value);
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

    void writeln() {
        _buf << "\n";
    }

    void writeln(const std::string& value) {
        _buf << value << "\n";
    }

    void writeln(AnyGC* value) {
        _buf << _anyToString(value) << "\n";
    }

    std::string toString() const {
        return _buf.str();
    }

    int length() const {
        return static_cast<int>(_buf.str().length());
    }

    bool isEmpty() const {
        return _buf.str().empty();
    }

    bool isNotEmpty() const {
        return !_buf.str().empty();
    }

    void clear() {
        _buf.str("");
        _buf.clear();
    }
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

/// dart_is<T> — AnyGC* 版本
template<typename T>
bool dart_is(AnyGC* obj) {
    if (!obj) return false;
    auto* vp = dynamic_cast<VPtr*>(obj);
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

/// dart_cast<T> — AnyGC* 版本
template<typename T>
T* dart_cast(AnyGC* obj) {
    auto* vp = dynamic_cast<VPtr*>(obj);
    if (!vp) {
        throw DartException("Type cast failed: null or non-VPtr");
    }
    return dart_cast<T>(vp);
}

// dart_isNull — 类型安全的 null 检查（适用于指针和值类型）
template<typename T>
inline bool dart_isNull(const T& v) {
    if constexpr (std::is_pointer_v<T>) return v == nullptr;
    else return false;
}
template<typename T>
inline bool dart_isNull(T* v) { return v == nullptr; }
inline bool dart_isNull(std::nullptr_t) { return true; }

// _toStr 重载集（必须在 dart_str 模板之前声明）
inline std::string _toStr(int64_t v) { return std::to_string(v); }
inline std::string _toStr(int v) { return std::to_string(v); }
inline std::string _toStr(double v) {
    std::ostringstream oss;
    oss << v;
    std::string s = oss.str();
    if (s.find('.') == std::string::npos && s.find('e') == std::string::npos &&
        s.find('i') == std::string::npos && s.find('n') == std::string::npos) {
        s += ".0";
    }
    return s;
}
inline std::string _toStr(bool v) { return v ? "true" : "false"; }
inline std::string _toStr(const std::string& v) { return v; }
inline std::string _toStr(const char* v) { return v ? v : "null"; }
inline std::string _toStr(VPtr* v) { return v ? v->toString() : "null"; }
inline std::string _toStr(const VPtr* v) { return v ? const_cast<VPtr*>(v)->toString() : "null"; }
inline std::string _toStr(AnyGC* v) { return v ? v->toString() : "null"; }
inline std::string _toStr(TypeFunction* v) { return v ? "[TypeFunction]" : "null"; }
inline std::string _toStr(const std::exception& e) { return e.what(); }
inline std::string _toStr(const DartException& e) { return e.toString(); }
inline std::string _toStr(std::nullptr_t) { return "null"; }
inline std::string _toStr(const ReachabilityError& v) { return v.toStringValue(); }
// 指针类型 _toStr — 处理任意指针（StaticList*, StaticMap* 等）
template<typename T>
inline typename std::enable_if<std::is_base_of<AnyGC, T>::value, std::string>::type
_toStr(T* v) {
    if (!v) return "null";
    // 如果 T 继承 VPtr，调用 toString()
    if constexpr (std::is_base_of<VPtr, T>::value) {
        return v->toString();
    } else {
        // StaticList, StaticMap, StaticSet 等 AnyGC 子类也有 toString()
        return v->toString();
    }
}

// _toStr for StaticMapEntry (value type, not pointer)
template<typename K, typename V>
inline std::string _toStr(const StaticMapEntry<K, V>& entry) {
    return "MapEntry(" + _toStr(entry.key) + ": " + _toStr(entry.value) + ")";
}

/// dart_str — 字符串插值辅助（可变参数拼接）
template<typename... Args>
std::string dart_str(Args&&... args) {
    std::ostringstream oss;
    (void)(int[]){0, ((oss << _toStr(std::forward<Args>(args))), 0)...};
    return oss.str();
}

// ============================================================================
// 12. String 方法辅助
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
// 13. Math 辅助
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
// 14. Duration / DateTime / RegExp 包装
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
    StaticDateTime& operator=(AnyGC* v) { _epochMs = v ? dynAs<int64_t>(v) : 0; return *this; }

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

// ============================================================================
// Utility functions for collection operations
// ============================================================================

// List.unmodifiable - creates an unmodifiable copy of a list
template<typename T>
StaticList<T>* unmodifiable(StaticList<T>* source) {
    if (!source) return GC::allocateLocal(new StaticList<T>());
    return StaticList<T>::from(source);
}

// safeLength - safely get length of potentially null string
inline int64_t safeLength(AnyGC* str) {
    if (!str) return 0;
    auto* strBox = dynamic_cast<StringBox*>(str);
    if (strBox) return static_cast<int64_t>(strBox->value.length());
    return 0;
}

// of - factory function for collections (used in some contexts)
template<typename T>
StaticList<T>* of(StaticList<T>* source) {
    if (!source) return GC::allocateLocal(new StaticList<T>());
    return StaticList<T>::from(source);
}

template<typename K, typename V>
StaticMap<K, V>* of(StaticMap<K, V>* source) {
    if (!source) return GC::allocateLocal(new StaticMap<K, V>());
    auto* result = GC::allocateLocal(new StaticMap<K, V>());
    for (int i = 0; i < source->length(); i++) {
        auto* keys = source->keys();
        auto* values = source->values();
        result->set((*keys)[i], (*values)[i]);
    }
    return result;
}

template<typename T>
StaticSet<T>* of(StaticSet<T>* source) {
    if (!source) return GC::allocateLocal(new StaticSet<T>());
    return StaticSet<T>::from(source->toStaticList());
}

// get - safe map get with default value
template<typename K, typename V>
V get(StaticMap<K, V>* map, const K& key, V defaultValue = V{}) {
    if (!map) return defaultValue;
    return map->getOrDefault(key, defaultValue);
}

// fromEntries - create a StaticMap from a list of entries
template<typename K, typename V>
StaticMap<K, V>* fromEntries(StaticList<StaticMapEntry<K, V>>* entries) {
    if (!entries) return StaticMap<K, V>::empty();
    return StaticMap<K, V>::fromEntries(entries);
}

// _SetValue - wrapper struct for Set constructor
template<typename T>
struct _SetValue : AnyGC {};

// _Set_new - factory function for StaticSet
template<typename T>
StaticSet<T>* _Set_new(_SetValue<T>* /*unused*/) {
    return StaticSet<T>::empty();
}

// generate - create a list by calling a generator function
template<typename T>
StaticList<T>* generate(int count, TypeFunction1<T, int64_t>* generator) {
    auto* result = GC::allocateLocal(new StaticList<T>());
    for (int i = 0; i < count; i++) {
        result->add(generator->call(i));
    }
    return result;
}

template<typename T>
StaticList<T>* generate(int count, std::function<T(int)> generator) {
    auto* result = GC::allocateLocal(new StaticList<T>());
    for (int i = 0; i < count; i++) {
        result->add(generator(i));
    }
    return result;
}

// StreamValue - wrapper struct for Stream (simplified as StaticList)
template<typename T>
struct StreamValue : AnyGC {
    StaticList<T>* data;
    static std::unordered_map<std::string, void*> _vptrMap;

    StreamValue() : data(GC::allocateLocal(new StaticList<T>())) {}
    StreamValue(StaticList<T>* d) : data(d) {}

    StaticList<T>* toList() const { return data; }

    static std::unordered_map<std::string, void*>& getVptrMap() {
        if (_vptrMap.empty()) {
            // toList returns Promise<StaticList<T>*>* which is a Promise
            // We'll handle this specially in the emitter
            _vptrMap["toList"] = nullptr; // Placeholder, actual call handled by emitter
        }
        return _vptrMap;
    }

    template<typename R>
    StreamValue<R>* map(std::function<R(T)> convert) {
        auto* mapped = data->template map<R>(convert);
        return GC::allocateLocal(new StreamValue<R>(mapped));
    }

    StreamValue<T>* where(std::function<bool(T)> test) {
        auto* filtered = data->where(test);
        return GC::allocateLocal(new StreamValue<T>(filtered));
    }

    template<typename R>
    R fold(R initialValue, std::function<R(R, T)> combine) {
        return data->fold(initialValue, combine);
    }
};

// Static member definition
template<typename T>
std::unordered_map<std::string, void*> StreamValue<T>::_vptrMap;

// Stream_new - factory function for StreamValue
template<typename T>
StreamValue<T>* Stream_new() {
    return GC::allocateLocal(new StreamValue<T>());
}

template<typename T>
StreamValue<T>* Stream_fromIterable(StaticList<T>* source) {
    return GC::allocateLocal(new StreamValue<T>(source));
}

#endif // DART2CPP_LOWERED_H
