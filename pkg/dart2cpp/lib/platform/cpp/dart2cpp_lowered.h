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
//   4. AnyPtr — 标签联合（替代 Dart 的 dynamic）
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
// 优化：避免 AnyPtr 拷贝时频繁分配 std::string
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

// ============================================================================
// 4. AnyPtr — 标签联合（替代 Dart 的 dynamic）
// ============================================================================

// Forward declaration for DartException (defined later)
struct DartException;

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
        DartString* stringPtr;   // 使用 DartString（引用计数 + 字符串池）
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

    // 隐式转换构造函数 - 允许基本类型隐式转换为 AnyPtr
    AnyPtr(int64_t val) : tag(INT_TAG) {
        data.intVal = val;
    }
    AnyPtr(int val) : tag(INT_TAG) {
        data.intVal = static_cast<int64_t>(val);
    }
    AnyPtr(double val) : tag(DOUBLE_TAG) {
        data.doubleVal = val;
    }
    AnyPtr(bool val) : tag(BOOL_TAG) {
        data.boolVal = val;
    }
    AnyPtr(const char* val) : tag(STRING_TAG) {
        data.stringPtr = new DartString(val);
    }
    AnyPtr(const std::string& val) : tag(STRING_TAG) {
        data.stringPtr = new DartString(val);
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
        p.data.stringPtr = new DartString(v);
        return p;
    }

    static AnyPtr fromString(std::string&& v) {
        AnyPtr p;
        p.tag = STRING_TAG;
        p.data.stringPtr = new DartString(std::move(v));
        return p;
    }

    static AnyPtr fromString(const char* v) {
        AnyPtr p;
        p.tag = STRING_TAG;
        p.data.stringPtr = new DartString(v);
        return p;
    }

    static AnyPtr fromString(const DartString& v) {
        AnyPtr p;
        p.tag = STRING_TAG;
        p.data.stringPtr = new DartString(v);
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

    static AnyPtr fromException(const DartException& v);

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

    // 泛型 fromAuto — 处理 std::tuple 等未知类型，装箱为 VPtr
    template<typename T>
    static AnyPtr fromAuto(T v) {
        // 将任意类型装箱到堆上并通过 VPtr 包装
        auto* boxed = new T(std::move(v));
        return fromVPtr(reinterpret_cast<VPtr*>(boxed));
    }

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

    explicit operator bool() const { return toBool(); }

    std::string toStringValue() const;  // 声明，实现在 VPtr 之后
    const DartString* toDartString() const;  // 获取 DartString 指针

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

    // 与基本类型的比较
    bool operator==(int64_t other) const {
        return tag == INT_TAG && data.intVal == other;
    }
    bool operator==(int other) const {
        return tag == INT_TAG && data.intVal == static_cast<int64_t>(other);
    }
    bool operator==(double other) const {
        return tag == DOUBLE_TAG && data.doubleVal == other;
    }
    bool operator==(bool other) const {
        return tag == BOOL_TAG && data.boolVal == other;
    }
    bool operator==(const std::string& other) const {
        return tag == STRING_TAG && data.stringPtr && *data.stringPtr == other;
    }
    bool operator==(const char* other) const {
        return tag == STRING_TAG && data.stringPtr && *data.stringPtr == other;
    }

    bool operator!=(const AnyPtr& other) const { return !(*this == other); }
    bool operator!=(int64_t other) const { return !(*this == other); }
    bool operator!=(int other) const { return !(*this == other); }
    bool operator!=(double other) const { return !(*this == other); }
    bool operator!=(bool other) const { return !(*this == other); }
    bool operator!=(const std::string& other) const { return !(*this == other); }
    bool operator!=(const char* other) const { return !(*this == other); }

    // ── 有序比较（用于 std::less / std::map 等排序容器） ──
    bool operator<(const AnyPtr& other) const {
        if (tag != other.tag) return tag < other.tag;
        switch (tag) {
            case NULL_TAG: return false;
            case INT_TAG: return data.intVal < other.data.intVal;
            case DOUBLE_TAG: return data.doubleVal < other.data.doubleVal;
            case BOOL_TAG: return data.boolVal < other.data.boolVal;
            case STRING_TAG: return *data.stringPtr < *other.data.stringPtr;
            case VPTR_TAG: return data.vptrPtr < other.data.vptrPtr;
            case TYPE_FUNC_TAG: return data.typeFnPtr < other.data.typeFnPtr;
            case GC_TAG: return data.gcPtr < other.data.gcPtr;
            default: return false;
        }
    }
    bool operator>(const AnyPtr& other) const { return other < *this; }
    bool operator<=(const AnyPtr& other) const { return !(other < *this); }
    bool operator>=(const AnyPtr& other) const { return !(*this < other); }

private:
    void _cleanup() {
        if (tag == STRING_TAG && data.stringPtr) {
            delete data.stringPtr;
            data.stringPtr = nullptr;
        }
    }

    void _copyFrom(const AnyPtr& other) {
        if (other.tag == STRING_TAG && other.data.stringPtr) {
            // DartString 使用引用计数，拷贝只是增加引用计数
            data.stringPtr = new DartString(*other.data.stringPtr);
        } else {
            data = other.data;
        }
    }
};

// ============================================================================
// 4. 异常层级 — DartException / DartStateError / ...
// ============================================================================

struct DartException : std::exception {
    std::string message;
    DartException(const std::string& msg) : message(msg) {}
    const char* what() const noexcept override { return message.c_str(); }
    virtual std::string toString() const { return "Exception: " + message; }

    // Implicit conversion to AnyPtr for use as function arguments
    operator AnyPtr() const { return AnyPtr::fromString(message); }
};

// AnyPtr::fromException implementation (defined here after DartException is complete)
inline AnyPtr AnyPtr::fromException(const DartException& v) {
    return AnyPtr::fromString(v.message);
}

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

/// ReachabilityErrorValue — 用于模式匹配穷尽性检查的占位类型
struct ReachabilityErrorValue : AnyGC {};

struct ReachabilityError {
    std::string _msg;
    std::string toStringValue() const { return _msg; }
};

inline ReachabilityError ReachabilityError_new(ReachabilityErrorValue* /*this_*/, const std::string& msg) {
    return ReachabilityError{msg};
}

// ============================================================================
// 5. VPtr — 虚表基类
// ============================================================================

struct VPtr : AnyGC {
    std::string _typeName;
    std::unordered_map<std::string, void*> vptr;

    VPtr() : _typeName("VPtr") {
        vptr["toString"] = nullptr;
        vptr["operatorEq"] = nullptr;
        vptr["get_hashCode"] = nullptr;
    }

    std::unordered_map<std::string, void*>& getVptrMap() { return vptr; }

    virtual std::string toString() {
        auto it = vptr.find("toString");
        if (it != vptr.end() && it->second != nullptr) {
            using Fn = std::string(*)(AnyGC*);
            auto fn = reinterpret_cast<Fn>(it->second);
            return fn(static_cast<AnyGC*>(this));
        }
        return _typeName;
    }

    bool equals(const VPtr& other) const {
        auto it = vptr.find("operatorEq");
        if (it != vptr.end() && it->second != nullptr) {
            using Fn = bool(*)(AnyGC*, AnyGC*);
            auto fn = reinterpret_cast<Fn>(it->second);
            return fn(static_cast<AnyGC*>(const_cast<VPtr*>(this)),
                      static_cast<AnyGC*>(const_cast<VPtr*>(&other)));
        }
        return this == &other;
    }

    int64_t getHashCode() const {
        auto it = vptr.find("get_hashCode");
        if (it != vptr.end() && it->second != nullptr) {
            using Fn = int64_t(*)(AnyGC*);
            auto fn = reinterpret_cast<Fn>(it->second);
            return fn(static_cast<AnyGC*>(const_cast<VPtr*>(this)));
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
        case STRING_TAG: return data.stringPtr ? data.stringPtr->str() : "null";
        case VPTR_TAG:
            if (data.vptrPtr) return data.vptrPtr->toString();
            return "null";
        case TYPE_FUNC_TAG: return "Closure";
        case GC_TAG: return "Instance";
        default: return "unknown";
    }
}

inline const DartString* AnyPtr::toDartString() const {
    if (tag == STRING_TAG) return data.stringPtr;
    return nullptr;
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
    if (tag == STRING_TAG && data.stringPtr) return data.stringPtr->str();
    return toStringValue();
}
template<> inline AnyPtr AnyPtr::castTo<AnyPtr>() const { return *this; }

// 通用指针类型 castTo：将 AnyPtr 转换为具体指针类型
template<typename T>
inline T AnyPtr::castTo() const {
    if constexpr (std::is_pointer_v<T>) {
        // 指针类型：通过 toGC() 获取 AnyGC*，再 static_cast 到目标类型
        return static_cast<T>(toGC());
    } else {
        // 非指针类型：默认返回默认构造值（应由特化覆盖）
        static_assert(sizeof(T) == 0, "castTo: unsupported type, add a specialization");
        return T{};
    }
}

// ============================================================================
// 6. Box 类型 — 闭包捕获引用语义
// ============================================================================

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

struct ObjectBox : AnyGC {
    AnyPtr value;
    ObjectBox(AnyPtr v) : value(std::move(v)) { GC::allocateLocal(this); }

    void gcMark(int flag) override {
        if (gcFlag == flag) return;
        AnyGC::gcMark(flag);
        AnyGC* held = value.toGC();
        if (held) held->gcMark(flag);
    }
};

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
    // int64_t: 尝试从 IntBox 拆箱
    if constexpr (std::is_same_v<T, int64_t>) {
        if (auto* box = dynamic_cast<IntBox*>(obj)) return box->value;
        if (auto* ob = dynamic_cast<ObjectBox*>(obj)) return ob->value.toInt();
        return 0;
    }
    else if constexpr (std::is_same_v<T, double>) {
        if (auto* box = dynamic_cast<DoubleBox*>(obj)) return box->value;
        if (auto* ob = dynamic_cast<ObjectBox*>(obj)) return ob->value.toDouble();
        return 0.0;
    }
    else if constexpr (std::is_same_v<T, bool>) {
        if (auto* box = dynamic_cast<BoolBox*>(obj)) return box->value;
        if (auto* ob = dynamic_cast<ObjectBox*>(obj)) return ob->value.toBool();
        return false;
    }
    else if constexpr (std::is_same_v<T, std::string>) {
        if (auto* box = dynamic_cast<StringBox*>(obj)) return box->value;
        if (auto* ob = dynamic_cast<ObjectBox*>(obj)) return ob->value.toStringValue();
        return "";
    }
    // 指针类型：直接 static_cast（向下转型）
    else if constexpr (std::is_pointer_v<T>) {
        return static_cast<T>(obj);
    }
    else {
        // 兜底：默认构造
        return T{};
    }
}

/// AnyPtr 重载：将 AnyPtr 转为 AnyGC* 后调用 dynAs<T>(AnyGC*)
template<typename T>
T dynAs(AnyPtr obj) {
    return dynAs<T>(obj.toGC());
}

// ============================================================================
// 8. TypeFunction 层级 — 可调用闭包基类（可变参数模板）
// ============================================================================

struct TypeFunction : AnyGC {
    void* closureCall = nullptr;

    // 动态调用（无参数）— 当具体类型未知时使用
    AnyPtr dynCall() {
        using Fn = AnyPtr(*)(AnyPtr);
        auto fn = reinterpret_cast<Fn>(closureCall);
        return fn(AnyPtr::fromTypeFunction(this));
    }

    // 动态调用（一个参数）
    AnyPtr dynCall(AnyPtr arg1) {
        using Fn = AnyPtr(*)(AnyPtr, AnyPtr);
        auto fn = reinterpret_cast<Fn>(closureCall);
        return fn(AnyPtr::fromTypeFunction(this), arg1);
    }

    // 动态调用（两个参数）
    AnyPtr dynCall(AnyPtr arg1, AnyPtr arg2) {
        using Fn = AnyPtr(*)(AnyPtr, AnyPtr, AnyPtr);
        auto fn = reinterpret_cast<Fn>(closureCall);
        return fn(AnyPtr::fromTypeFunction(this), arg1, arg2);
    }

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

// TypeFunctionN<R, Args...> — 可变参数模板版本
// 替代原来的 TypeFunction0-16，消除重复代码
template<typename R, typename... Args>
struct TypeFunctionN : TypeFunction {
    R call(Args... args) {
        using Fn = R(*)(AnyPtr, Args...);
        auto fn = reinterpret_cast<Fn>(closureCall);
        return fn(AnyPtr::fromTypeFunction(this), args...);
    }
};

// 向后兼容的类型别名（保持 TypeFunction0-16 的命名）
template<typename R>
using TypeFunction0 = TypeFunctionN<R>;

template<typename R, typename T1>
using TypeFunction1 = TypeFunctionN<R, T1>;

template<typename R, typename T1, typename T2>
using TypeFunction2 = TypeFunctionN<R, T1, T2>;

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

    void sort(std::function<bool(T, T)> compare = nullptr) {
        if (compare) {
            std::sort(_data->_storage.begin(), _data->_storage.end(), compare);
        } else {
            std::sort(_data->_storage.begin(), _data->_storage.end());
        }
    }
    void sort(TypeFunction2<bool, T, T>* compare) {
        if (compare) {
            std::sort(_data->_storage.begin(), _data->_storage.end(),
                [compare](const T& a, const T& b) { return compare->call(a, b); });
        } else {
            std::sort(_data->_storage.begin(), _data->_storage.end());
        }
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

    std::string toString() const {
        return "[" + join(", ") + "]";
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
struct StaticMap : AnyGC {
    Array<K>* _keys;
    Array<V>* _values;

    StaticMap()
        : _keys(GC::allocateLocal(new Array<K>())),
          _values(GC::allocateLocal(new Array<V>())) {}

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

    Array<K>* keys() const { return _keys; }
    Array<V>* values() const { return _values; }

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

    std::string toString() const {
        if (isEmpty()) return "{}";
        std::string result = "{";
        for (int i = 0; i < _keys->length(); i++) {
            if (i > 0) result += ", ";
            result += dart_str((*_keys)[i]) + ": " + dart_str((*_values)[i]);
        }
        result += "}";
        return result;
    }

    // ── GC ──

    void gcMark(int flag) override {
        if (gcFlag == flag) return;
        AnyGC::gcMark(flag);
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
        : _data(GC::allocateLocal(new Array<T>(init))) {}

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

    std::string toString() const {
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
    AnyPtr result;
    AnyPtr error;
    std::function<void()> startCallback;
    std::function<bool()> onTick;

    // setStartCallback / setTickCallback 延迟实现（在 GlobalScheduler 之后）
    void setStartCallback(std::function<void()> cb);
    void setTickCallback(std::function<bool()> cb);

    void complete(AnyPtr value) {
        if (state == COMPLETED || state == ERROR) {
            throw DartStateError("Promise already resolved");
        }
        result = std::move(value);
        state = COMPLETED;
    }

    void completeError(AnyPtr err) {
        if (state == COMPLETED || state == ERROR) {
            throw DartStateError("Promise already resolved");
        }
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

    // ── 静态工厂 ──

    static Promise<T>* resolved(T value) {
        auto* promise = GC::allocateLocal(new Promise<T>());
        promise->complete(AnyPtr::fromAuto(std::move(value)));
        return promise;
    }

    static Promise<T>* value(T value) {
        return resolved(std::move(value));
    }

    static Promise<T>* rejected(AnyPtr err) {
        auto* promise = GC::allocateLocal(new Promise<T>());
        promise->completeError(std::move(err));
        return promise;
    }

    // delayed / then / catchError / whenComplete — 声明在类内，定义在 GlobalScheduler 之后
    static Promise<T>* delayed(int ticks, std::function<T()> computation);

    template<typename R = AnyPtr>
    Promise<R>* then(std::function<AnyPtr(T)> onValue);

    Promise<T>* catchError(std::function<T(AnyPtr)> onError);

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
        complete(AnyPtr::null());
    }

    static Promise<void>* resolved() {
        auto* promise = GC::allocateLocal(new Promise<void>());
        promise->complete(AnyPtr::null());
        return promise;
    }

    static Promise<void>* value() {
        return resolved();
    }

    static Promise<void>* rejected(AnyPtr err) {
        auto* promise = GC::allocateLocal(new Promise<void>());
        promise->completeError(std::move(err));
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
            promise->complete(AnyPtr::fromAuto(computation()));
        } catch (const std::exception& e) {
            promise->completeError(AnyPtr::fromString(e.what()));
        }
    }, promise);
    return promise;
}

template<typename T>
template<typename R>
Promise<R>* Promise<T>::then(std::function<AnyPtr(T)> onValue) {
    // 延迟分配优化：如果已完成，直接执行回调并返回结果
    if (isCompleted()) {
        try {
            AnyPtr callbackResult = onValue(result.template castTo<T>());
            AnyGC* gcResult = callbackResult.toGC();
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
            nextPromise->completeError(AnyPtr::fromString(e.what()));
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
                AnyPtr callbackResult = onValue(self->result.template castTo<T>());
                AnyGC* gcResult = callbackResult.toGC();
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
                nextPromise->completeError(AnyPtr::fromString(e.what()));
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
Promise<T>* Promise<T>::catchError(std::function<T(AnyPtr)> onError) {
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
            nextPromise->complete(AnyPtr::fromAuto(onError(error)));
        } catch (const std::exception& e) {
            nextPromise->completeError(AnyPtr::fromString(e.what()));
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
                nextPromise->complete(AnyPtr::fromAuto(onError(self->error)));
            } catch (const std::exception& e) {
                nextPromise->completeError(AnyPtr::fromString(e.what()));
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
            nextPromise->completeError(AnyPtr::fromString(e.what()));
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
                nextPromise->completeError(AnyPtr::fromString(e.what()));
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
        resultPromise->complete(AnyPtr::fromAuto(
            GC::allocateLocal(new StaticList<T>())));
        return resultPromise;
    }

    auto* results = new std::vector<AnyPtr>(promises.size(), AnyPtr::null());
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
            if (p->state == COMPLETED && (*results)[i].isNull()) {
                (*results)[i] = p->result;
                (*completedCount)++;
            }
        }
        if (*completedCount == static_cast<int>(total)) {
            auto* list = GC::allocateLocal(new StaticList<T>());
            for (const auto& r : *results) {
                list->add(r.castTo<T>());
            }
            resultPromise->complete(AnyPtr::fromAuto(list));
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
    // Create a new promise for the result
    auto* resultPromise = GC::allocateLocal(new Promise<R>());
    this__->then([onValue, resultPromise](AnyPtr val) -> AnyPtr {
        T typed = val.castTo<T>();
        R result = onValue->call(typed);
        resultPromise->completeTyped(std::move(result));
        return AnyPtr::null();
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
    if (promise->isCompleted()) return promise->result.castTo<T>();
    if (promise->isError()) {
        throw DartException("Promise completed with error: " +
            promise->error.toStringValue());
    }

    // 如果是 READY，启动回调
    if (promise->isReady() && promise->startCallback) {
        promise->state = PromiseBase::PENDING;
        promise->startCallback();
        promise->startCallback = nullptr;
        if (promise->isCompleted()) return promise->result.castTo<T>();
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
            promise->error.toStringValue());
    }

    return promise->result.castTo<T>();
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
            promise->error.toStringValue());
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
            promise->error.toStringValue());
    }
}

// ── smAwait passthrough for non-Promise values ──
template<typename T>
inline T smAwait(T value) {
    return value;
}

// ── smAwait(AnyPtr) overloads — 从 AnyPtr 中提取 PromiseBase* ──
template<typename T>
inline T smAwait(AnyPtr promiseValue) {
    PromiseBase* promise = static_cast<PromiseBase*>(promiseValue.toGC());
    return smAwait<T>(promise);
}

template<>
inline void smAwait<void>(AnyPtr promiseValue) {
    PromiseBase* promise = static_cast<PromiseBase*>(promiseValue.toGC());
    smAwait<void>(promise);
}

// Overload for AnyPtr passthrough
inline AnyPtr smAwait(AnyPtr value) {
    return value;
}

// ── promiseDelayed（对齐 Dart promiseDelayed） ──

inline PromiseBase* promiseDelayed(int ticks, std::function<AnyPtr()> computation) {
    auto* promise = GC::allocateLocal(new PromiseBase());
    GlobalScheduler::instance().registerDelayedTask(ticks, [promise, computation]() {
        try {
            AnyPtr result = computation();
            promise->complete(std::move(result));
        } catch (const std::exception& e) {
            promise->completeError(AnyPtr::fromString(e.what()));
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
    void completeWithError(AnyPtr error) { promise->completeError(std::move(error)); }

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
    this__->completeWithError(AnyPtr::fromGC(error));
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

/// staticPrint 重载 — VPtr* 类型（通过 toString 派发）
inline void staticPrint(VPtr* value) {
    std::cout << (value ? value->toString() : "null") << std::endl;
}

/// staticPrint 重载 — 任意 GC 管理的对象指针（StaticList*, StaticMap* 等）
template<typename T>
inline typename std::enable_if<std::is_base_of<AnyGC, T>::value &&
    !std::is_same<T, AnyPtr>::value && !std::is_same<T, VPtr>::value &&
    !std::is_same<T, std::string>::value, void>::type
staticPrint(T* value) {
    if (!value) {
        std::cout << "null" << std::endl;
    } else {
        std::cout << value->toString() << std::endl;
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

    void writeln() {
        _buf << "\n";
    }

    void writeln(const std::string& value) {
        _buf << value << "\n";
    }

    void writeln(const AnyPtr& value) {
        _buf << value.toStringValue() << "\n";
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
inline std::string _toStr(const VPtr* v) { return v ? const_cast<VPtr*>(v)->toString() : "null"; }
inline std::string _toStr(AnyGC* v) { return v ? "[AnyGC]" : "null"; }
inline std::string _toStr(TypeFunction* v) { return v ? "[TypeFunction]" : "null"; }
inline std::string _toStr(const std::exception& e) { return e.what(); }
inline std::string _toStr(const DartException& e) { return e.toString(); }
inline std::string _toStr(std::nullptr_t) { return "null"; }
inline std::string _toStr(const ReachabilityError& v) { return v.toStringValue(); }
// 指针类型 _toStr — 处理任意指针（StaticList*, StaticMap* 等）
template<typename T>
inline typename std::enable_if<std::is_base_of<AnyGC, T>::value && !std::is_same<T, AnyPtr>::value, std::string>::type
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
