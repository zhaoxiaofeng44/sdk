// ============================================================================
// dart2cpp_lowered.h — OOP-lowered Dart → C++ 运行时库
// ============================================================================
// 本头文件为 dart2cpp 编译器（lib/restorer/）生成的 C++ 代码
// 提供完整的运行时支持。
//
// 组件清单：
//   1. AnyGC — GC 管理基类
//   2. GC — 标记-清除垃圾回收器
//   3. 异常层级 — DartException / DartStateError / ...
//   4. Box 类型 — 闭包捕获引用语义
//   5. TypeFunction 层级 — 可调用闭包基类（可变参数模板）
//   6. 集合 — MapEntry / Array / List / Map / Set
//   7. Promise / GlobalScheduler / sm_await — 协作式异步
//   8. 语义包装 — dart_print / StringBuffer
//   9. 辅助函数 — dart_is / dart_str（→ ::string）
//  10. String 方法辅助 — string_*
//  11. Duration / DateTime / RegExp 包装
// ============================================================================

#ifndef DART2CPP_LOWERED_H
#define DART2CPP_LOWERED_H

#include <algorithm>
#include <cassert>
#include <cctype>
#include <chrono>
#include <cstdint>
#include <cstdio>
#include <cstring>
#include <ctime>
#include <functional>
#include <iomanip>
#include <iostream>
#include <new>
#include <pthread.h>
#include <regex>
#include <sstream>
#include <stdexcept>
#include <string>
#include <string_view>
#include <type_traits>
#include <unordered_map>
#include <unordered_set>
#include <vector>

// ASan 下栈扫描需要跳过被毒化（redzone/未使用）的栈槽
#if defined(__SANITIZE_ADDRESS__) || \
    (defined(__has_feature) && __has_feature(address_sanitizer))
#include <sanitizer/asan_interface.h>
#define DART2CPP_ASAN 1
#endif

// ============================================================================
// 0. string / StringPool — 两层字符串体系
// ============================================================================
// 第一层 StringPool：全局字符串池，hashmap（hash → 桶）存储 char* 及
//   相关信息（长度、hash、引用计数），内容相同的字符串共享同一池条目。
// 第二层 string：值语义句柄，持有一个池条目指针；拷贝/移动/析构
//   管理条目的引用计数，当没有任何 string 持有某条目时（计数归零），
//   该条目从池中移除并释放内存。
// 变更操作（+= / push_back / replace 等）采用"生成新内容 → 重新入池"
//   策略，池内条目始终不可变，保证共享安全。

class string;

class StringPool {
public:
    struct Entry {
        char* data = nullptr;      // NUL 结尾的字符数组（池拥有）
        size_t length = 0;
        size_t hash = 0;
        int64_t refCount = 0;      // 持有该条目的 string 数量
    };

private:
    std::unordered_map<size_t, std::vector<Entry*>> _buckets;

    StringPool() = default;

    static size_t _hashContent(const char* data, size_t len) {
        // FNV-1a
        size_t h = static_cast<size_t>(1469598103934665603ULL);
        for (size_t i = 0; i < len; i++) {
            h ^= static_cast<unsigned char>(data[i]);
            h *= static_cast<size_t>(1099511628211ULL);
        }
        return h;
    }

public:
    StringPool(const StringPool&) = delete;
    StringPool& operator=(const StringPool&) = delete;

    ~StringPool() {
        // 清理仍被泄漏句柄持有的条目（如未回收的 GC 对象），避免退出时泄漏
        for (auto& kv : _buckets) {
            for (Entry* e : kv.second) {
                delete[] e->data;
                delete e;
            }
        }
        _buckets.clear();
    }

    static StringPool& instance() {
        static StringPool pool;
        return pool;
    }

    /// 从池中获取（或创建）内容为 [data, data+len) 的条目，引用计数 +1
    Entry* acquire(const char* data, size_t len) {
        size_t h = _hashContent(data, len);
        std::vector<Entry*>& bucket = _buckets[h];
        for (size_t i = 0; i < bucket.size(); i++) {
            Entry* e = bucket[i];
            if (e->length == len && (len == 0 || std::memcmp(e->data, data, len) == 0)) {
                e->refCount++;
                return e;
            }
        }
        Entry* e = new Entry();
        char* buf = new char[len + 1];
        if (len > 0) std::memcpy(buf, data, len);
        buf[len] = '\0';
        e->data = buf;
        e->length = len;
        e->hash = h;
        e->refCount = 1;
        bucket.push_back(e);
        return e;
    }


    /// 释放一个条目的引用；计数归零时从池中移除并释放内存
    void release(Entry* e) {
        if (!e) return;
        e->refCount--;
        if (e->refCount > 0) return;
        auto it = _buckets.find(e->hash);
        if (it != _buckets.end()) {
            std::vector<Entry*>& bucket = it->second;
            bucket.erase(std::remove(bucket.begin(), bucket.end(), e), bucket.end());
            if (bucket.empty()) _buckets.erase(it);
        }
        delete[] e->data;
        delete e;
    }
};

/// string — 引用计数式字符串句柄（内容存储于 StringPool）
class string {
public:
    static constexpr size_t npos = static_cast<size_t>(-1);
    using const_iterator = const char*;

private:
    StringPool::Entry* _entry;

    std::string_view _view() const {
        return _entry ? std::string_view(_entry->data, _entry->length) : std::string_view();
    }

    /// 释放当前条目并绑定到内容 [data, data+len) 的池条目
    void _reassign(const char* data, size_t len) {
        StringPool& pool = StringPool::instance();
        StringPool::Entry* next = pool.acquire(data, len);
        if (_entry) pool.release(_entry);
        _entry = next;
    }

public:
    string() : _entry(StringPool::instance().acquire("", 0)) {}
    string(const char* s)
        : _entry(StringPool::instance().acquire(s ? s : "", s ? std::strlen(s) : 0)) {}
    string(const char* s, size_t len)
        : _entry(StringPool::instance().acquire(s ? s : "", s ? len : 0)) {}
    string(std::string_view sv)
        : _entry(StringPool::instance().acquire(sv.data(), sv.size())) {}
    string(size_t count, char c) : _entry(nullptr) {
        char* buf = new char[count + 1];
        if (count > 0) std::memset(buf, static_cast<unsigned char>(c), count);
        buf[count] = '\0';
        _entry = StringPool::instance().acquire(buf, count);
        delete[] buf;
    }
    string(const string& other) : _entry(other._entry) {
        if (_entry) _entry->refCount++;
    }
    string(string&& other) noexcept : _entry(other._entry) {
        // 源句柄重置为空串条目，保持析构安全
        other._entry = StringPool::instance().acquire("", 0);
    }
    ~string() {
        if (_entry) StringPool::instance().release(_entry);
    }

    string& operator=(const string& other) {
        if (this != &other) {
            StringPool::Entry* next = other._entry;
            if (next) next->refCount++;
            if (_entry) StringPool::instance().release(_entry);
            _entry = next;
        }
        return *this;
    }
    string& operator=(string&& other) noexcept {
        if (this != &other) {
            if (_entry) StringPool::instance().release(_entry);
            _entry = other._entry;
            other._entry = StringPool::instance().acquire("", 0);
        }
        return *this;
    }
    string& operator=(const char* s) {
        _reassign(s ? s : "", s ? std::strlen(s) : 0);
        return *this;
    }

    // ── 访问 ──
    const char* c_str() const { return _entry ? _entry->data : ""; }
    const char* data() const { return c_str(); }
    size_t size() const { return _entry ? _entry->length : 0; }
    size_t length() const { return size(); }
    bool empty() const { return size() == 0; }
    char operator[](int64_t i) const { return c_str()[i]; }
    char at(size_t i) const {
        if (i >= size()) throw std::out_of_range("string::at");
        return c_str()[i];
    }
    const char* begin() const { return c_str(); }
    const char* end() const { return c_str() + size(); }
    const char* cbegin() const { return c_str(); }
    const char* cend() const { return c_str() + size(); }

    /// 池条目指针（相同内容共享同一条目，可用于快速相等判断）
    size_t hashValue() const { return _entry ? _entry->hash : 0; }

    // ── 比较 ──
    int compare(const string& other) const { return _view().compare(other._view()); }
    int compare(const char* other) const { return _view().compare(other ? other : ""); }
    bool operator==(const string& other) const {
        if (_entry == other._entry) return true;
        return size() == other.size() && std::memcmp(c_str(), other.c_str(), size()) == 0;
    }
    bool operator!=(const string& other) const { return !(*this == other); }
    bool operator==(const char* other) const {
        return _view() == std::string_view(other ? other : "");
    }
    bool operator!=(const char* other) const { return !(*this == other); }
    bool operator<(const string& other) const { return _view() < other._view(); }

    // ── 拼接（生成新内容并重新入池） ──
    string& operator+=(const string& other) {
        if (other.empty()) return *this;
        size_t newLen = size() + other.size();
        char* buf = new char[newLen + 1];
        std::memcpy(buf, c_str(), size());
        std::memcpy(buf + size(), other.c_str(), other.size());
        buf[newLen] = '\0';
        _reassign(buf, newLen);
        delete[] buf;
        return *this;
    }
    string& operator+=(const char* s) {
        if (!s || !*s) return *this;
        size_t slen = std::strlen(s);
        size_t newLen = size() + slen;
        char* buf = new char[newLen + 1];
        std::memcpy(buf, c_str(), size());
        std::memcpy(buf + size(), s, slen);
        buf[newLen] = '\0';
        _reassign(buf, newLen);
        delete[] buf;
        return *this;
    }
    string& operator+=(char c) {
        size_t newLen = size() + 1;
        char* buf = new char[newLen + 1];
        std::memcpy(buf, c_str(), size());
        buf[size()] = c;
        buf[newLen] = '\0';
        _reassign(buf, newLen);
        delete[] buf;
        return *this;
    }

    // ── 变更操作 ──
    void reserve(size_t) {}  // 池化存储无需预留容量（兼容接口）
    void push_back(char c) { *this += c; }
    string& replace(size_t pos, size_t count, const string& str) {
        size_t curLen = size();
        if (pos > curLen) pos = curLen;
        if (count > curLen - pos) count = curLen - pos;
        size_t newLen = curLen - count + str.size();
        char* buf = new char[newLen + 1];
        std::memcpy(buf, c_str(), pos);
        std::memcpy(buf + pos, str.c_str(), str.size());
        std::memcpy(buf + pos + str.size(), c_str() + pos + count, curLen - pos - count);
        buf[newLen] = '\0';
        _reassign(buf, newLen);
        delete[] buf;
        return *this;
    }

    // ── 子串与查找 ──
    string substr(size_t pos = 0, size_t count = npos) const {
        std::string_view v = _view();
        if (pos > v.size()) pos = v.size();
        return string(v.substr(pos, count));
    }
    size_t find(const string& sub, size_t pos = 0) const { return _view().find(sub._view(), pos); }
    size_t find(const char* s, size_t pos = 0) const { return _view().find(s ? s : "", pos); }
    size_t find(char c, size_t pos = 0) const { return _view().find(c, pos); }
    size_t rfind(const string& sub, size_t pos = npos) const { return _view().rfind(sub._view(), pos); }
    size_t rfind(char c, size_t pos = npos) const { return _view().rfind(c, pos); }
    size_t find_first_of(const char* s, size_t pos = 0) const { return _view().find_first_of(s ? s : "", pos); }
    size_t find_first_not_of(const char* s, size_t pos = 0) const { return _view().find_first_not_of(s ? s : "", pos); }
    size_t find_last_not_of(const char* s, size_t pos = npos) const { return _view().find_last_not_of(s ? s : "", pos); }
};

inline string operator+(string lhs, const string& rhs) { lhs += rhs; return lhs; }
inline string operator+(string lhs, const char* rhs) { lhs += rhs; return lhs; }
inline string operator+(string lhs, char rhs) { lhs += rhs; return lhs; }
inline string operator+(const char* lhs, const string& rhs) {
    string result(lhs);
    result += rhs;
    return result;
}
inline string operator+(char lhs, const string& rhs) {
    string result;
    result += lhs;
    result += rhs;
    return result;
}
inline bool operator==(const char* lhs, const string& rhs) { return rhs == lhs; }
inline bool operator!=(const char* lhs, const string& rhs) { return !(rhs == lhs); }

inline std::ostream& operator<<(std::ostream& os, const string& s) {
    if (s.size() > 0) os.write(s.data(), static_cast<std::streamsize>(s.size()));
    return os;
}

// ── std::hash 特化 — 使 ::string（Dart String）可作 unordered_map/set 的键 ──
namespace std {
template<>
struct hash<::string> {
    size_t operator()(const ::string& s) const { return s.hashValue(); }
};
}  // namespace std

// Forward declarations for template functions used in collection templates
template<typename... Args>
string dart_str(Args&&... args);

// Forward declarations needed by AnyGC (defined later)
struct AnyGC;
struct ClassInfo;
class GlobalScheduler;
template<typename T> T dynAs(AnyGC* obj);

// ============================================================================
// 1. AnyGC — GC 管理基类
// ============================================================================

// AnyGC 是 POD：没有任何 C++ 虚函数，因此对象头部不含编译器 vptr。
// 多态（含析构）一律经 _classInfo 的函数指针槽派发，布局可 1:1 映射到 C struct。
struct AnyGC {
    int gcFlag = 0;
    const ClassInfo* _classInfo = nullptr;
};

/// _gcDestroy<T> — ClassInfo::destroy 槽的通用实现：按具体类型析构并释放。
/// 取代 virtual ~AnyGC()：GC 清扫阶段经 _classInfo->destroy 调到正确的析构函数。
template<typename T>
inline void _gcDestroy(AnyGC* obj) {
    delete static_cast<T*>(obj);
}

// ============================================================================
// 2. GC — 标记-清除垃圾回收器
// ============================================================================

class GC {
    static int _currentFlag;
    static std::vector<AnyGC*> _objects;
    static std::vector<AnyGC*> _roots;
    static std::unordered_set<AnyGC*> _registered;
    static GlobalScheduler _scheduler;
    static int _allocSinceCollect;      // 距上次 collect 的分配数
    static int _autoCollectThreshold;   // 自动触发阈值（0 = 关闭）
    static bool _collecting;            // 重入保护

public:
    /// 分配局部对象（非 root），注册到 GC 并返回
    template<typename T>
    static T* allocateLocal(T* obj) {
        if (_registered.insert(static_cast<AnyGC*>(obj)).second) {
            _objects.push_back(static_cast<AnyGC*>(obj));
        }
        maybeAutoCollect();
        return obj;
    }

    /// 分配全局对象（root），注册到 GC 并标记为 root
    template<typename T>
    static T* allocateGlobal(T* obj) {
        auto* base = static_cast<AnyGC*>(obj);
        if (_registered.insert(base).second) {
            _objects.push_back(base);
        }
        bool found = false;
        for (size_t i = 0; i < _roots.size(); i++) {
            if (_roots[i] == base) { found = true; break; }
        }
        if (!found) {
            _roots.push_back(base);
        }
        maybeAutoCollect();
        return obj;
    }

    /// 执行一轮标记-清除 GC，返回被回收的对象数量（定义在 GlobalScheduler 之后）
    static int collect();

    /// 分配计数自动触发（定义在 GlobalScheduler 之后）：
    /// 分配量达到阈值且不在 collect/tick 重入路径时执行 collect
    static void maybeAutoCollect();

    /// 设置自动 GC 阈值（每 N 次分配触发一轮 collect）；0 = 关闭。
    /// 单元测试需要确定性计数时应设为 0。
    static void setAutoCollectThreshold(int n) { _autoCollectThreshold = n; }
    static int autoCollectThreshold() { return _autoCollectThreshold; }

    /// 从 root 集中移除对象（全局/静态字段被覆盖赋值时使用，避免旧值永久钉住）
    static void removeRoot(AnyGC* obj);

    /// 保守栈扫描：扫描 [lo, 栈基) 范围内指向已注册对象的字并标记。
    /// lo 取 collect() 自身帧地址：覆盖 collect 调用方（业务代码）及其
    /// 所有上层活跃帧的局部变量；其下方（collector 递归帧、已返回的被调
    /// 帧）全是陈旧值，不参与扫描 —— 否则上一轮 collect 遗留的指针槽会把
    /// 同一对象反复钉住（永久假保留）。定义在 _gcMark 之后。
    static void scanStack(int flag, void* lo);

    /// 泄漏分析：按类型名统计存活对象并输出到 stderr，返回存活总数
    static int reportAlive(const char* label);

    /// 获取当前管理的对象总数
    static int objectCount() { return static_cast<int>(_objects.size()); }

    /// 获取当前 root 数量
    static int rootCount() { return static_cast<int>(_roots.size()); }

    /// 重置 GC 状态（测试用）
    static void reset() {
        _objects.clear();
        _roots.clear();
        _registered.clear();
        _currentFlag = 0;
    }

    /// 获取 GlobalScheduler 引用（管理所有 promise 的异步调度器）
    static GlobalScheduler& scheduler();
};

// 静态成员定义（放在 .cpp 或 inline）
inline int GC::_currentFlag = 0;
inline std::vector<AnyGC*> GC::_objects;
inline std::vector<AnyGC*> GC::_roots;
inline std::unordered_set<AnyGC*> GC::_registered;
inline int GC::_allocSinceCollect = 0;
inline int GC::_autoCollectThreshold = 10000;
inline bool GC::_collecting = false;

// ============================================================================
// 前向声明
// ============================================================================

struct TypeFunction;

// Forward declaration for DartException (defined later)
struct DartException;

// ============================================================================
// 3. 异常层级 — DartException / DartStateError / ...
// ============================================================================

struct DartException : std::exception {
    string message;
    DartException(const string& msg) : message(msg) {}
    const char* what() const noexcept override { return message.c_str(); }
    virtual string toString() const { return "Exception: " + message; }
};

struct DartStateError : DartException {
    DartStateError(const string& msg) : DartException(msg) {}
    string toString() const override { return "StateError: " + message; }
};

struct DartArgumentError : DartException {
    DartArgumentError(const string& msg) : DartException(msg) {}
    string toString() const override { return "ArgumentError: " + message; }
};

struct DartRangeError : DartException {
    DartRangeError(const string& msg) : DartException(msg) {}
    string toString() const override { return "RangeError: " + message; }
};

struct DartFormatException : DartException {
    DartFormatException(const string& msg) : DartException(msg) {}
    string toString() const override { return "FormatException: " + message; }
};

inline int64_t string_toInt(const string& s) {
    long long v = 0;
    if (sscanf(s.c_str(), "%lld", &v) == 1) return static_cast<int64_t>(v);
    throw DartFormatException(s);
}

inline double string_toDouble(const string& s) {
    double v = 0;
    if (sscanf(s.c_str(), "%lf", &v) == 1) return v;
    throw DartFormatException(s);
}

struct DartUnsupportedError : DartException {
    DartUnsupportedError(const string& msg) : DartException(msg) {}
    string toString() const override { return "UnsupportedError: " + message; }
};

struct DartUnimplementedError : DartException {
    DartUnimplementedError(const string& msg) : DartException(msg) {}
    string toString() const override { return "UnimplementedError: " + message; }
};

struct ReachabilityError {
    string _msg;
    string toStringValue() const { return _msg; }
};

// ============================================================================
// 4. ClassInfo — 结构化虚表（替代 map-based vptr）
// ============================================================================

struct ClassInfo;

/// 类型链节点：自身 / 基类 / 接口适配 ClassInfo。
/// 子类链表 = [self, 直接接口...] → 父 ClassInfo::inherits，编译期复用父链。
struct InheritNode {
    const ClassInfo* info = nullptr;
    const InheritNode* next = nullptr;
};

struct ClassInfo {
    /// 类型名用 C 字符串，保证 ClassInfo 为字面量类型，可 constexpr 初始化。
    const char* typeName = nullptr;
    /// extends 父 ClassInfo（Value/布局链）；类型判定与接口派发走 inherits。
    const ClassInfo* _parent = nullptr;
    /// 按具体类型析构并释放对象（取代 virtual ~AnyGC）。每个可实例化的类都必须设置。
    void(*destroy)(AnyGC*) = nullptr;
    /// 类型链：当前类 + 直接引入的接口适配表在前，next 接到父 inherits 实现复用。
    /// 接口条目指「接口布局 + 本类函数指针」，其 _parent 为接口身份，供 is / 调用。
    const InheritNode* inherits = nullptr;
    void(*gcMark)(AnyGC*, int) = nullptr;
    AnyGC*(*toString)(AnyGC*) = nullptr;
    AnyGC*(*get_runtimeType)(AnyGC*) = nullptr;
    bool(*eq)(AnyGC*, AnyGC*) = nullptr;
    int64_t(*get_hashCode)(AnyGC*) = nullptr;
    int64_t(*compareTo)(AnyGC*, AnyGC*) = nullptr;
    int64_t(*get_length)(AnyGC*) = nullptr;
    bool(*get_isEmpty)(AnyGC*) = nullptr;
    bool(*get_isNotEmpty)(AnyGC*) = nullptr;
    AnyGC*(*get_iterator)(AnyGC*) = nullptr;
    AnyGC*(*toUpperCase)(AnyGC*) = nullptr;
    AnyGC*(*toLowerCase)(AnyGC*) = nullptr;
    bool(*contains)(AnyGC*, AnyGC*) = nullptr;
    AnyGC*(*trim)(AnyGC*) = nullptr;
    AnyGC*(*trimLeft)(AnyGC*) = nullptr;
    AnyGC*(*trimRight)(AnyGC*) = nullptr;
    AnyGC*(*replaceFirst)(AnyGC*, AnyGC*, AnyGC*, AnyGC*) = nullptr;
    AnyGC*(*replaceRange)(AnyGC*, AnyGC*, AnyGC*, AnyGC*) = nullptr;
    AnyGC*(*padLeft)(AnyGC*, AnyGC*, AnyGC*) = nullptr;
    AnyGC*(*padRight)(AnyGC*, AnyGC*, AnyGC*) = nullptr;
    int64_t(*lastIndexOf)(AnyGC*, AnyGC*, AnyGC*) = nullptr;
    int64_t(*codeUnitAt)(AnyGC*, AnyGC*) = nullptr;
    AnyGC*(*index)(AnyGC*, AnyGC*) = nullptr;
    void(*setIndex)(AnyGC*, AnyGC*, AnyGC*) = nullptr;
    bool(*containsKey)(AnyGC*, AnyGC*) = nullptr;
    // MapEntry 键/值访问（供 Map._vptr_map 等擦除路径派发，避免模板参数不匹配）
    AnyGC*(*get_key)(AnyGC*) = nullptr;
    AnyGC*(*get_value)(AnyGC*) = nullptr;
};

/// ClassInfo::typeName → C 字符串（空则 "<unknown>"）
inline const char* _ciTypeName(const ClassInfo* ci) {
    return (ci && ci->typeName && ci->typeName[0] != '\0') ? ci->typeName : "<unknown>";
}

/// 比较 ClassInfo::typeName 与字面量（const char*，不可用 ==）
inline bool _ciTypeNameIs(const ClassInfo* ci, const char* expected) {
    if (!ci || !ci->typeName || !expected) return false;
    return std::strcmp(ci->typeName, expected) == 0;
}

/// ClassInfo::typeName → string（供打印 / map key）
inline string _ciTypeNameStr(const ClassInfo* ci) {
    return string(_ciTypeName(ci));
}

/// inherits 条目是否匹配目标身份（自身指针，或适配表 _parent 指向身份）。
inline bool _inheritMatches(const ClassInfo* e, const ClassInfo* target) {
    return e == target || (e && e->_parent == target);
}

// _isInstanceOf — 只走 inherits 类型链（含 self / 基类 / 接口适配，父链复用）。
inline bool _isInstanceOf(AnyGC* obj, const ClassInfo* target) {
    if (!obj || !obj->_classInfo || !target) return false;
    if (obj->_classInfo == target) return true;
    for (const InheritNode* n = obj->_classInfo->inherits; n; n = n->next) {
        if (_inheritMatches(n->info, target)) return true;
    }
    return false;
}

/// 按接口身份取 inherits 中的接口 ClassInfo（已填实现函数指针；先匹配先得）。
inline const ClassInfo* _ifaceAdapter(const AnyGC* obj, const ClassInfo* ifaceId) {
    if (!obj || !obj->_classInfo || !ifaceId) return nullptr;
    if (obj->_classInfo == ifaceId) return obj->_classInfo;
    for (const InheritNode* n = obj->_classInfo->inherits; n; n = n->next) {
        if (_inheritMatches(n->info, ifaceId)) return n->info;
    }
    return nullptr;
}

/// _gcFree — 释放单个对象（取代 delete）。经 ClassInfo::destroy 派发到具体析构函数。
inline void _gcFree(AnyGC* obj) {
    if (!obj) return;
    if (obj->_classInfo && obj->_classInfo->destroy) {
        obj->_classInfo->destroy(obj);
        return;
    }
    // destroy 未设置说明该类漏了注册：此处只能释放内存，字段析构会被跳过。
#ifndef NDEBUG
    fprintf(stderr, "[GC] missing ClassInfo::destroy for %s\n",
            obj->_classInfo ? _ciTypeName(obj->_classInfo) : "<no classinfo>");
#endif
    ::operator delete(static_cast<void*>(obj));
}

/// _gcMark — cycle-safe GC mark through ClassInfo dispatch
inline void _gcMark(AnyGC* obj, int flag) {
    if (!obj) return;
    if (obj->gcFlag == flag) return;
    obj->gcFlag = flag;
    if (obj->_classInfo && obj->_classInfo->gcMark) obj->_classInfo->gcMark(obj, flag);
}

// ── GC::removeRoot / scanStack / reportAlive 实现 ──

inline void GC::removeRoot(AnyGC* obj) {
    _roots.erase(std::remove(_roots.begin(), _roots.end(), obj), _roots.end());
}

inline void GC::scanStack(int flag, void* loHint) {
    // 栈从高地址向低地址增长：lo = 调用方帧（高地址侧起点），hi = 栈基
    uintptr_t lo = reinterpret_cast<uintptr_t>(loHint);
    uintptr_t hi = 0;
#ifdef __APPLE__
    hi = reinterpret_cast<uintptr_t>(pthread_get_stackaddr_np(pthread_self()));
#elif defined(__linux__)
    pthread_attr_t attr;
    if (pthread_getattr_np(pthread_self(), &attr) == 0) {
        void* stackAddr = nullptr;
        size_t stackSize = 0;
        if (pthread_attr_getstack(&attr, &stackAddr, &stackSize) == 0) {
            hi = reinterpret_cast<uintptr_t>(static_cast<char*>(stackAddr) + stackSize);
        }
        pthread_attr_destroy(&attr);
    }
#endif
    if (!hi || hi <= lo) return;

    uintptr_t p = (lo + sizeof(void*) - 1) & ~(sizeof(void*) - 1);
    for (; p + sizeof(void*) <= hi; p += sizeof(void*)) {
#ifdef DART2CPP_ASAN
        // 被 ASan 毒化的槽（redzone/无效帧区域）不参与扫描；
        // 用 region 检查覆盖整个字（部分毒化的字不可能存放有效指针）
        if (__asan_region_is_poisoned(reinterpret_cast<void*>(p), sizeof(void*))) continue;
#endif
        AnyGC* candidate = *reinterpret_cast<AnyGC* const*>(p);
        if (_registered.find(candidate) != _registered.end()) {
#ifdef DART2CPP_GC_SCAN_DEBUG
            fprintf(stderr, "[scan] match %p at +%zu\n",
                    static_cast<void*>(candidate), static_cast<size_t>(p - lo));
#endif
            _gcMark(candidate, flag);
        }
    }
}

inline int GC::reportAlive(const char* label) {
    std::unordered_map<string, int> counts;
    for (auto* obj : _objects) {
        string name = _ciTypeNameStr(obj->_classInfo);
        counts[name]++;
    }
    std::vector<std::pair<int, string>> sorted;
    for (auto& kv : counts) sorted.emplace_back(kv.second, kv.first);
    std::sort(sorted.begin(), sorted.end(),
              [](const auto& a, const auto& b) { return a.first > b.first; });
    fprintf(stderr, "[GC:%s] alive=%zu roots=%zu", label, _objects.size(), _roots.size());
    for (auto& e : sorted) {
        fprintf(stderr, " %s=%d", e.second.c_str(), e.first);
    }
    fprintf(stderr, "\n");
    return static_cast<int>(_objects.size());
}

// ============================================================================
// 5. Box 类型 — 闭包捕获引用语义
// ============================================================================

// Forward declarations for string helpers used in StringBox ClassInfo dispatch
inline string string_toUpper(const string& s);
inline string string_toLower(const string& s);
inline string string_trim(const string& s);
inline string string_trimLeft(const string& s);
inline string string_trimRight(const string& s);
inline string string_replaceFirst(const string& s, const string& from, const string& to, int64_t start);
inline string string_replaceRange(const string& s, int64_t start, int64_t end, const string& replacement);
inline string string_padLeft(const string& s, int64_t width, const string& padding);
inline string string_padRight(const string& s, int64_t width, const string& padding);
inline int64_t string_lastIndexOf(const string& s, const string& pattern, int64_t start);
inline int64_t string_codeUnitAt(const string& s, int64_t index);
inline string string_fromCharCode(int64_t code);
inline string string_fromCharCodes(AnyGC* list);
inline string double_toStringAsExponential(double value, int64_t fracDigits);

// ClassInfo subclasses — 无运行期构造函数，静态实例用 constexpr 聚合赋值
struct IntBoxClassInfo : ClassInfo {};
struct DoubleBoxClassInfo : ClassInfo {};
struct BoolBoxClassInfo : ClassInfo {};
struct StringBoxClassInfo : ClassInfo {};

struct IntBox : AnyGC {
    int64_t value;
    static const IntBoxClassInfo _classInfo;
    IntBox(int64_t v) : value(v) { AnyGC::_classInfo = &IntBox::_classInfo; GC::allocateLocal(this); }
    static AnyGC* _vptr_toString(AnyGC* self);
    static AnyGC* _vptr_runtimeType(AnyGC*);
    static int64_t _vptr_compareTo(AnyGC* self, AnyGC* other);
    static bool _vptr_eq(AnyGC* self, AnyGC* other);
    static int64_t _vptr_hashCode(AnyGC* self);
    static void _gcMark_impl(AnyGC* self, int flag) {}
};

struct DoubleBox : AnyGC {
    double value;
    static const DoubleBoxClassInfo _classInfo;
    DoubleBox(double v) : value(v) { AnyGC::_classInfo = &DoubleBox::_classInfo; GC::allocateLocal(this); }
    static AnyGC* _vptr_toString(AnyGC* self);
    static AnyGC* _vptr_runtimeType(AnyGC*);
    static int64_t _vptr_compareTo(AnyGC* self, AnyGC* other);
    static bool _vptr_eq(AnyGC* self, AnyGC* other);
    static int64_t _vptr_hashCode(AnyGC* self);
    static void _gcMark_impl(AnyGC* self, int flag) {}
};

struct BoolBox : AnyGC {
    bool value;
    static const BoolBoxClassInfo _classInfo;
    BoolBox(bool v) : value(v) { AnyGC::_classInfo = &BoolBox::_classInfo; GC::allocateLocal(this); }
    static AnyGC* _vptr_toString(AnyGC* self);
    static AnyGC* _vptr_runtimeType(AnyGC*);
    static int64_t _vptr_compareTo(AnyGC* self, AnyGC* other);
    static bool _vptr_eq(AnyGC* self, AnyGC* other);
    static int64_t _vptr_hashCode(AnyGC* self);
    static void _gcMark_impl(AnyGC* self, int flag) {}
};

struct StringBox : AnyGC {
    string value;
    static const StringBoxClassInfo _classInfo;
    StringBox(const string& v) : value(v) { AnyGC::_classInfo = &StringBox::_classInfo; GC::allocateLocal(this); }
    static AnyGC* _vptr_toString(AnyGC* self);
    static AnyGC* _vptr_runtimeType(AnyGC*);
    static AnyGC* _vptr_toUpperCase(AnyGC* self);
    static AnyGC* _vptr_toLowerCase(AnyGC* self);
    static bool _vptr_contains(AnyGC* self, AnyGC* other);
    static int64_t _vptr_length(AnyGC* self);
    static AnyGC* _vptr_trim(AnyGC* self);
    static AnyGC* _vptr_trimLeft(AnyGC* self);
    static AnyGC* _vptr_trimRight(AnyGC* self);
    static AnyGC* _vptr_replaceFirst(AnyGC* self, AnyGC* from, AnyGC* to, AnyGC* start);
    static AnyGC* _vptr_replaceRange(AnyGC* self, AnyGC* start, AnyGC* end, AnyGC* replacement);
    static AnyGC* _vptr_padLeft(AnyGC* self, AnyGC* width, AnyGC* padding);
    static AnyGC* _vptr_padRight(AnyGC* self, AnyGC* width, AnyGC* padding);
    static int64_t _vptr_lastIndexOf(AnyGC* self, AnyGC* pattern, AnyGC* start);
    static int64_t _vptr_codeUnitAt(AnyGC* self, AnyGC* index);
    static int64_t _vptr_compareTo(AnyGC* self, AnyGC* other);
    static bool _vptr_eq(AnyGC* self, AnyGC* other);
    static int64_t _vptr_hashCode(AnyGC* self);
    static void _gcMark_impl(AnyGC* self, int flag) {}
};

// TupleBox — wraps std::tuple* as an AnyGC for record types (Dart records)
struct TupleBoxClassInfo : ClassInfo {};
struct TupleBox : AnyGC {
    static const TupleBoxClassInfo _classInfo;
    void* data;
    string str;
    TupleBox(void* d, string s) : data(d), str(std::move(s)) {
        AnyGC::_classInfo = &_classInfo;
        GC::allocateLocal(this);
    }

    // ── ClassInfo dispatch (defined after _box is available) ──
    static AnyGC* _vptr_toString(AnyGC* self);
    static AnyGC* _vptr_runtimeType(AnyGC* self);
    static void _gcMark_impl(AnyGC* self, int flag) {}
};

inline constexpr InheritNode _inh_TupleBox = { &TupleBox::_classInfo, nullptr };
inline constexpr TupleBoxClassInfo TupleBox::_classInfo = []() constexpr {
    TupleBoxClassInfo ci{};
    ci.typeName = "Record";
    ci.destroy = &_gcDestroy<TupleBox>;
    ci.gcMark = &TupleBox::_gcMark_impl;
    ci.toString = &TupleBox::_vptr_toString;
    ci.get_runtimeType = &TupleBox::_vptr_runtimeType;
    ci.inherits = &_inh_TupleBox;
    return ci;
}();

// ── Type traits used by collection _vptr methods ──
template<typename, typename = void>
struct _isEqualityComparable : std::false_type {};
template<typename U>
struct _isEqualityComparable<U, std::void_t<decltype(std::declval<U>() == std::declval<U>())>> : std::true_type {};
template<typename, typename = void>
struct _isLessThanComparable : std::false_type {};
template<typename U>
struct _isLessThanComparable<U, std::void_t<decltype(std::declval<U>() < std::declval<U>())>> : std::true_type {};

// ============================================================================
// _box — universal boxing helper (replaces AnyPtr::fromAuto)
// ============================================================================

inline AnyGC* _box(AnyGC* v) { return v; }
inline AnyGC* _box(std::nullptr_t) { return nullptr; }
inline AnyGC* _box(int64_t v) { return GC::allocateLocal(new IntBox(v)); }
inline AnyGC* _box(int v) { return GC::allocateLocal(new IntBox(static_cast<int64_t>(v))); }
inline AnyGC* _box(double v) { return GC::allocateLocal(new DoubleBox(v)); }
inline AnyGC* _box(bool v) { return GC::allocateLocal(new BoolBox(v)); }
inline AnyGC* _box(const string& v) { return GC::allocateLocal(new StringBox(v)); }
// std::string 边界值（std::to_string / oss.str() 等）直接装箱为 StringBox
inline AnyGC* _box(const std::string& v) { return GC::allocateLocal(new StringBox(string(v.data(), v.size()))); }
inline AnyGC* _box(const char* v) { return GC::allocateLocal(new StringBox(string(v))); }

// _vptrRet — vptr wrapper return helper: unboxes AnyGC* or returns raw value directly
template<typename R, typename T>
R _vptrRet(T v) {
    if constexpr (std::is_pointer_v<T>) {
        return dynAs<R>(v);
    } else {
        return v;
    }
}

// _box overload for DartException — converts to StringBox
inline AnyGC* _box(const DartException& v) {
    return GC::allocateLocal(new StringBox(v.message));
}

/// _anyToString — convert AnyGC* to string (null-safe)
inline string _anyToString(AnyGC* val) {
    if (!val) return "null";
    if (val->_classInfo && val->_classInfo->toString) {
        return dynAs<string>(val->_classInfo->toString(val));
    }
    if (val->_classInfo && val->_classInfo->typeName && val->_classInfo->typeName[0])
        return _ciTypeNameStr(val->_classInfo);
    return "Instance";
}

// ── Box type ClassInfo method definitions (after _box is available) ──

inline AnyGC* IntBox::_vptr_toString(AnyGC* self) {
    char buf[24];
    snprintf(buf, sizeof(buf), "%lld", static_cast<long long>(static_cast<IntBox*>(self)->value));
    return _box(string(buf));
}
inline AnyGC* IntBox::_vptr_runtimeType(AnyGC*) {
    return _box(string("int"));
}
inline int64_t IntBox::_vptr_compareTo(AnyGC* self, AnyGC* other) {
    int64_t a = static_cast<IntBox*>(self)->value;
    int64_t b = dynAs<int64_t>(other);
    return static_cast<int64_t>(a > b ? 1 : (a < b ? -1 : 0));
}
inline bool IntBox::_vptr_eq(AnyGC* self, AnyGC* other) {
    return static_cast<IntBox*>(self)->value == dynAs<int64_t>(other);
}
inline int64_t IntBox::_vptr_hashCode(AnyGC* self) {
    return static_cast<int64_t>(std::hash<int64_t>{}(static_cast<IntBox*>(self)->value));
}

inline AnyGC* DoubleBox::_vptr_toString(AnyGC* self) {
    std::ostringstream oss;
    oss << static_cast<DoubleBox*>(self)->value;
    return _box(oss.str());
}
inline AnyGC* DoubleBox::_vptr_runtimeType(AnyGC*) {
    return _box(string("double"));
}
inline int64_t DoubleBox::_vptr_compareTo(AnyGC* self, AnyGC* other) {
    double a = static_cast<DoubleBox*>(self)->value;
    double b = dynAs<double>(other);
    return static_cast<int64_t>(a > b ? 1 : (a < b ? -1 : 0));
}
inline bool DoubleBox::_vptr_eq(AnyGC* self, AnyGC* other) {
    return static_cast<DoubleBox*>(self)->value == dynAs<double>(other);
}
inline int64_t DoubleBox::_vptr_hashCode(AnyGC* self) {
    return static_cast<int64_t>(std::hash<double>{}(static_cast<DoubleBox*>(self)->value));
}

inline AnyGC* BoolBox::_vptr_toString(AnyGC* self) {
    return _box(static_cast<BoolBox*>(self)->value ? "true" : "false");
}
inline AnyGC* BoolBox::_vptr_runtimeType(AnyGC*) {
    return _box(string("bool"));
}
inline int64_t BoolBox::_vptr_compareTo(AnyGC* self, AnyGC* other) {
    bool a = static_cast<BoolBox*>(self)->value;
    bool b = dynAs<bool>(other);
    return static_cast<int64_t>(a == b ? 0 : (a ? 1 : -1));
}
inline bool BoolBox::_vptr_eq(AnyGC* self, AnyGC* other) {
    return static_cast<BoolBox*>(self)->value == dynAs<bool>(other);
}
inline int64_t BoolBox::_vptr_hashCode(AnyGC* self) {
    return static_cast<int64_t>(static_cast<BoolBox*>(self)->value ? 1 : 0);
}

inline AnyGC* StringBox::_vptr_toString(AnyGC* self) {
    return _box(static_cast<StringBox*>(self)->value);
}
inline AnyGC* StringBox::_vptr_runtimeType(AnyGC*) {
    return _box(string("String"));
}
inline AnyGC* StringBox::_vptr_toUpperCase(AnyGC* self) {
    return _box(string_toUpper(static_cast<StringBox*>(self)->value));
}
inline AnyGC* StringBox::_vptr_toLowerCase(AnyGC* self) {
    return _box(string_toLower(static_cast<StringBox*>(self)->value));
}
inline bool StringBox::_vptr_contains(AnyGC* self, AnyGC* other) {
    return static_cast<StringBox*>(self)->value.find(dynAs<string>(other)) != string::npos;
}
inline int64_t StringBox::_vptr_length(AnyGC* self) {
    return static_cast<int64_t>(static_cast<StringBox*>(self)->value.size());
}
inline AnyGC* StringBox::_vptr_trim(AnyGC* self) {
    return _box(string_trim(static_cast<StringBox*>(self)->value));
}
inline AnyGC* StringBox::_vptr_trimLeft(AnyGC* self) {
    return _box(string_trimLeft(static_cast<StringBox*>(self)->value));
}
inline AnyGC* StringBox::_vptr_trimRight(AnyGC* self) {
    return _box(string_trimRight(static_cast<StringBox*>(self)->value));
}
inline AnyGC* StringBox::_vptr_replaceFirst(AnyGC* self, AnyGC* from, AnyGC* to, AnyGC* start) {
    const auto& s = static_cast<StringBox*>(self)->value;
    int64_t st = start ? dynAs<int64_t>(start) : 0;
    return _box(string_replaceFirst(s, dynAs<string>(from), dynAs<string>(to), st));
}
inline AnyGC* StringBox::_vptr_replaceRange(AnyGC* self, AnyGC* start, AnyGC* end, AnyGC* replacement) {
    const auto& s = static_cast<StringBox*>(self)->value;
    return _box(string_replaceRange(s, dynAs<int64_t>(start), dynAs<int64_t>(end), dynAs<string>(replacement)));
}
inline AnyGC* StringBox::_vptr_padLeft(AnyGC* self, AnyGC* width, AnyGC* padding) {
    const auto& s = static_cast<StringBox*>(self)->value;
    string pad = padding ? dynAs<string>(padding) : string(" ");
    return _box(string_padLeft(s, dynAs<int64_t>(width), pad));
}
inline AnyGC* StringBox::_vptr_padRight(AnyGC* self, AnyGC* width, AnyGC* padding) {
    const auto& s = static_cast<StringBox*>(self)->value;
    string pad = padding ? dynAs<string>(padding) : string(" ");
    return _box(string_padRight(s, dynAs<int64_t>(width), pad));
}
inline int64_t StringBox::_vptr_lastIndexOf(AnyGC* self, AnyGC* pattern, AnyGC* start) {
    const auto& s = static_cast<StringBox*>(self)->value;
    int64_t st = start ? dynAs<int64_t>(start) : static_cast<int64_t>(s.size()) - 1;
    return string_lastIndexOf(s, dynAs<string>(pattern), st);
}
inline int64_t StringBox::_vptr_codeUnitAt(AnyGC* self, AnyGC* index) {
    const auto& s = static_cast<StringBox*>(self)->value;
    return string_codeUnitAt(s, dynAs<int64_t>(index));
}
inline int64_t StringBox::_vptr_compareTo(AnyGC* self, AnyGC* other) {
    const auto& a = static_cast<StringBox*>(self)->value;
    string b = dynAs<string>(other);
    return static_cast<int64_t>(a.compare(b));
}
inline bool StringBox::_vptr_eq(AnyGC* self, AnyGC* other) {
    return static_cast<StringBox*>(self)->value == dynAs<string>(other);
}
inline int64_t StringBox::_vptr_hashCode(AnyGC* self) {
    return static_cast<int64_t>(std::hash<string>{}(static_cast<StringBox*>(self)->value));
}

// ── Box ClassInfo 编译期初始化 — box 只持有 value，方法分发由调用点 inline 判定 ──

inline constexpr InheritNode _inh_IntBox = { &IntBox::_classInfo, nullptr };
inline constexpr InheritNode _inh_DoubleBox = { &DoubleBox::_classInfo, nullptr };
inline constexpr InheritNode _inh_BoolBox = { &BoolBox::_classInfo, nullptr };
inline constexpr InheritNode _inh_StringBox = { &StringBox::_classInfo, nullptr };

inline constexpr IntBoxClassInfo IntBox::_classInfo = []() constexpr {
    IntBoxClassInfo ci{};
    ci.typeName = "int";
    ci.destroy = &_gcDestroy<IntBox>;
    ci.gcMark = &IntBox::_gcMark_impl;
    ci.toString = &IntBox::_vptr_toString;
    ci.get_runtimeType = &IntBox::_vptr_runtimeType;
    ci.compareTo = &IntBox::_vptr_compareTo;
    ci.eq = &IntBox::_vptr_eq;
    ci.get_hashCode = &IntBox::_vptr_hashCode;
    ci.inherits = &_inh_IntBox;
    return ci;
}();

inline constexpr DoubleBoxClassInfo DoubleBox::_classInfo = []() constexpr {
    DoubleBoxClassInfo ci{};
    ci.typeName = "double";
    ci.destroy = &_gcDestroy<DoubleBox>;
    ci.gcMark = &DoubleBox::_gcMark_impl;
    ci.toString = &DoubleBox::_vptr_toString;
    ci.get_runtimeType = &DoubleBox::_vptr_runtimeType;
    ci.compareTo = &DoubleBox::_vptr_compareTo;
    ci.eq = &DoubleBox::_vptr_eq;
    ci.get_hashCode = &DoubleBox::_vptr_hashCode;
    ci.inherits = &_inh_DoubleBox;
    return ci;
}();

inline constexpr BoolBoxClassInfo BoolBox::_classInfo = []() constexpr {
    BoolBoxClassInfo ci{};
    ci.typeName = "bool";
    ci.destroy = &_gcDestroy<BoolBox>;
    ci.gcMark = &BoolBox::_gcMark_impl;
    ci.toString = &BoolBox::_vptr_toString;
    ci.get_runtimeType = &BoolBox::_vptr_runtimeType;
    ci.compareTo = &BoolBox::_vptr_compareTo;
    ci.eq = &BoolBox::_vptr_eq;
    ci.get_hashCode = &BoolBox::_vptr_hashCode;
    ci.inherits = &_inh_BoolBox;
    return ci;
}();

inline constexpr StringBoxClassInfo StringBox::_classInfo = []() constexpr {
    StringBoxClassInfo ci{};
    ci.typeName = "String";
    ci.destroy = &_gcDestroy<StringBox>;
    ci.gcMark = &StringBox::_gcMark_impl;
    ci.toString = &StringBox::_vptr_toString;
    ci.get_runtimeType = &StringBox::_vptr_runtimeType;
    ci.toUpperCase = &StringBox::_vptr_toUpperCase;
    ci.toLowerCase = &StringBox::_vptr_toLowerCase;
    ci.contains = &StringBox::_vptr_contains;
    ci.get_length = &StringBox::_vptr_length;
    ci.trim = &StringBox::_vptr_trim;
    ci.trimLeft = &StringBox::_vptr_trimLeft;
    ci.trimRight = &StringBox::_vptr_trimRight;
    ci.replaceFirst = &StringBox::_vptr_replaceFirst;
    ci.replaceRange = &StringBox::_vptr_replaceRange;
    ci.padLeft = &StringBox::_vptr_padLeft;
    ci.padRight = &StringBox::_vptr_padRight;
    ci.lastIndexOf = &StringBox::_vptr_lastIndexOf;
    ci.codeUnitAt = &StringBox::_vptr_codeUnitAt;
    ci.compareTo = &StringBox::_vptr_compareTo;
    ci.eq = &StringBox::_vptr_eq;
    ci.get_hashCode = &StringBox::_vptr_hashCode;
    ci.inherits = &_inh_StringBox;
    return ci;
}();

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
        const ClassInfo* ci = obj->_classInfo;
        if (ci == &IntBox::_classInfo) return static_cast<IntBox*>(obj)->value;
        if (ci == &DoubleBox::_classInfo) return static_cast<int64_t>(static_cast<DoubleBox*>(obj)->value);
        return 0;
    }
    else if constexpr (std::is_same_v<T, double>) {
        const ClassInfo* ci = obj->_classInfo;
        if (ci == &DoubleBox::_classInfo) return static_cast<DoubleBox*>(obj)->value;
        if (ci == &IntBox::_classInfo) return static_cast<double>(static_cast<IntBox*>(obj)->value);
        return 0.0;
    }
    else if constexpr (std::is_same_v<T, bool>) {
        const ClassInfo* ci = obj->_classInfo;
        if (ci == &BoolBox::_classInfo) return static_cast<BoolBox*>(obj)->value;
        return false;
    }
    else if constexpr (std::is_same_v<T, string>) {
        if (obj->_classInfo == &StringBox::_classInfo) return static_cast<StringBox*>(obj)->value;
        if (obj->_classInfo && obj->_classInfo->toString) {
            return dynAs<string>(obj->_classInfo->toString(obj));
        }
        if (obj->_classInfo && obj->_classInfo->typeName && obj->_classInfo->typeName[0])
            return _ciTypeNameStr(obj->_classInfo);
        return "Instance";
    }
    else if constexpr (std::is_pointer_v<T>) {
        return static_cast<T>(obj);
    }
    else if constexpr (std::is_integral_v<T>) {
        // int/int32_t 等整型（如 Map<int, V> 的键）经 IntBox 装箱，统一经 int64_t 拆箱
        return static_cast<T>(dynAs<int64_t>(obj));
    }
    else {
        // 值类型仅剩整型/浮点/bool/string（上面已覆盖）；
        // 其余类型一律 AnyGC 指针语义（ValueBox 已移除），正常不会走到这里
        return T{};
    }
}

// ============================================================================
// 6. TypeFunction 层级 — 可调用闭包基类（可变参数模板）
// ============================================================================

// TypeFunction — 可调用闭包基类。
// 子类 TypeFunctionN 持有唯一函数指针：
//   fnPtr: AnyGC*(*)(AnyGC*, AnyGC*...) — 全擦除约定：所有对象一律 AnyGC*
//          （值类型经 _box/_boxElem 装箱），返回 AnyGC*，调用方按需 dynAs/_unboxElem
//          拆箱。调度与直接调用统一走这一条路径，签名全局统一。
struct TypeFunction : AnyGC {};

// _box overload for TypeFunction* — must appear after TypeFunction definition
// so static_cast (not reinterpret_cast) can be used.
inline AnyGC* _box(TypeFunction* v) { return static_cast<AnyGC*>(v); }

// TypeFunctionN<R, Args...> — function wrapper.
// fnPtr 为全擦除签名（每个类型参数对应一个 AnyGC* 形参，返回 AnyGC*）。
// R/Args 仅保留用于类型标注，调用一律经 fnPtr。

// General template (3+ args)
template<typename R, typename... Args>
struct TypeFunctionN : TypeFunction {
    template<typename> using _Any = AnyGC*;
    using FnPtr = AnyGC*(*)(AnyGC*, _Any<Args>...);
    FnPtr fnPtr = nullptr;
};

// 0-arg specialization
template<typename R>
struct TypeFunctionN<R> : TypeFunction {
    using FnPtr = AnyGC*(*)(AnyGC*);
    FnPtr fnPtr = nullptr;
};

// 1-arg specialization
template<typename R, typename A>
struct TypeFunctionN<R, A> : TypeFunction {
    using FnPtr = AnyGC*(*)(AnyGC*, AnyGC*);
    FnPtr fnPtr = nullptr;
};

// 2-arg specialization
template<typename R, typename A1, typename A2>
struct TypeFunctionN<R, A1, A2> : TypeFunction {
    using FnPtr = AnyGC*(*)(AnyGC*, AnyGC*, AnyGC*);
    FnPtr fnPtr = nullptr;
};

// 向后兼容的类型别名（保持 TypeFunction0-16 的命名）
template<typename R>
using TypeFunction0 = TypeFunctionN<R>;

template<typename R, typename T1>
using TypeFunction1 = TypeFunctionN<R, T1>;

template<typename R, typename T1, typename T2>
using TypeFunction2 = TypeFunctionN<R, T1, T2>;

// ── _boxElem / _unboxElem — element boxing/unboxing for collection _vptr_* methods ──

/// Box an element value to AnyGC*. For pointer types, the pointer IS an AnyGC*
/// (static_cast, no wrapping). For value types, delegates to _box.
template<typename U>
AnyGC* _boxElem(U value) {
    if constexpr (std::is_pointer_v<U>) {
        return static_cast<AnyGC*>(value);
    } else {
        return _box(std::move(value));
    }
}

/// Unbox AnyGC* to element type U. Inverse of _boxElem.
template<typename U>
U _unboxElem(AnyGC* ptr) {
    if (!ptr) {
        if constexpr (std::is_pointer_v<U>) return nullptr;
        else return U{};
    }
    if constexpr (std::is_same_v<U, int64_t>) return dynAs<int64_t>(ptr);
    else if constexpr (std::is_same_v<U, double>) return dynAs<double>(ptr);
    else if constexpr (std::is_same_v<U, bool>) return dynAs<bool>(ptr);
    else if constexpr (std::is_same_v<U, string>) return dynAs<string>(ptr);
    else if constexpr (std::is_pointer_v<U>) return static_cast<U>(ptr);
    else if constexpr (std::is_integral_v<U>) return static_cast<U>(dynAs<int64_t>(ptr));
    else {
        // 非指针非基础值类型不应再出现（一律指针语义，ValueBox 已移除）
        static_assert(!sizeof(U), "_unboxElem: unsupported value type; use AnyGC pointer types");
        return U{};
    }
}

/// 谓词调用：装箱实参 → fnPtr → 拆箱为 bool（集合 where/any/every 等共用）
template<typename U>
inline bool _predApply(TypeFunction1<bool, U>* tf, const U& value) {
    return dynAs<bool>(tf->fnPtr(tf, _boxElem<U>(value)));
}

// ── TupleBox _vptr_* definitions (deferred until _box available) ──
inline AnyGC* TupleBox::_vptr_toString(AnyGC* self) {
    return _box(static_cast<TupleBox*>(self)->str);
}
inline AnyGC* TupleBox::_vptr_runtimeType(AnyGC* self) {
    return _box(string("Record"));
}

// ============================================================================
// 7. 静态集合 — MapEntry / Array / List / Map / Set
// ============================================================================

// ── MapEntry<K,V> ──

// 前向声明
template<typename T> struct List;
template<typename T> struct Set;
template<typename K, typename V> struct Map;
template<typename K, typename V> struct MapEntry;

template<typename T>
struct _isMapEntry : std::false_type {};
template<typename K, typename V>
struct _isMapEntry<MapEntry<K, V>> : std::true_type {};
template<typename K, typename V>
struct _isMapEntry<MapEntry<K, V>*> : std::true_type {};

// ClassInfo subclass forward declarations (constructor bodies defined after structs)
template<typename T> struct ArrayClassInfo : ClassInfo {
    constexpr ArrayClassInfo();
    void(*add)(AnyGC*, AnyGC*) = nullptr;
    void(*insert)(AnyGC*, AnyGC*, AnyGC*) = nullptr;
    AnyGC*(*removeAt)(AnyGC*, AnyGC*) = nullptr;
    bool(*remove)(AnyGC*, AnyGC*) = nullptr;
    int64_t(*indexOf)(AnyGC*, AnyGC*) = nullptr;
    void(*clear)(AnyGC*) = nullptr;
};
template<typename T> struct IteratorClassInfo : ClassInfo {
    constexpr IteratorClassInfo();
    bool(*moveNext)(AnyGC*) = nullptr;
    AnyGC*(*current)(AnyGC*) = nullptr;
    void(*reset)(AnyGC*) = nullptr;
};
template<typename T> struct ListClassInfo : ClassInfo {
    constexpr ListClassInfo();
    // List-specific getters
    AnyGC*(*get_first)(AnyGC*) = nullptr;
    AnyGC*(*get_last)(AnyGC*) = nullptr;
    AnyGC*(*get_single)(AnyGC*) = nullptr;
    AnyGC*(*get_reversed)(AnyGC*) = nullptr;
    // List-specific methods
    void(*add)(AnyGC*, AnyGC*) = nullptr;
    void(*addAll)(AnyGC*, AnyGC*) = nullptr;
    void(*insert)(AnyGC*, AnyGC*, AnyGC*) = nullptr;
    void(*insertAll)(AnyGC*, AnyGC*, AnyGC*) = nullptr;
    AnyGC*(*removeAt)(AnyGC*, AnyGC*) = nullptr;
    bool(*remove)(AnyGC*, AnyGC*) = nullptr;
    AnyGC*(*removeLast)(AnyGC*) = nullptr;
    void(*removeWhere)(AnyGC*, AnyGC*) = nullptr;
    void(*retainWhere)(AnyGC*, AnyGC*) = nullptr;
    void(*removeRange)(AnyGC*, AnyGC*, AnyGC*) = nullptr;
    void(*fillRange)(AnyGC*, AnyGC*, AnyGC*, AnyGC*) = nullptr;
    void(*clear)(AnyGC*) = nullptr;
    void(*sort)(AnyGC*, AnyGC*) = nullptr;
    int64_t(*indexOf)(AnyGC*, AnyGC*, AnyGC*) = nullptr;
    int64_t(*indexWhere)(AnyGC*, AnyGC*, AnyGC*) = nullptr;
    int64_t(*lastIndexWhere)(AnyGC*, AnyGC*, AnyGC*) = nullptr;
    void(*forEach)(AnyGC*, AnyGC*) = nullptr;
    AnyGC*(*where)(AnyGC*, AnyGC*) = nullptr;
    bool(*any_)(AnyGC*, AnyGC*) = nullptr;
    bool(*every_)(AnyGC*, AnyGC*) = nullptr;
    AnyGC*(*firstWhere)(AnyGC*, AnyGC*, AnyGC*) = nullptr;
    AnyGC*(*lastWhere)(AnyGC*, AnyGC*, AnyGC*) = nullptr;
    AnyGC*(*singleWhere)(AnyGC*, AnyGC*, AnyGC*) = nullptr;
    AnyGC*(*reduce)(AnyGC*, AnyGC*) = nullptr;
    AnyGC*(*take)(AnyGC*, AnyGC*) = nullptr;
    AnyGC*(*skip)(AnyGC*, AnyGC*) = nullptr;
    AnyGC*(*takeWhile)(AnyGC*, AnyGC*) = nullptr;
    AnyGC*(*skipWhile)(AnyGC*, AnyGC*) = nullptr;
    AnyGC*(*sublist)(AnyGC*, AnyGC*, AnyGC*) = nullptr;
    AnyGC*(*getRange)(AnyGC*, AnyGC*, AnyGC*) = nullptr;
    AnyGC*(*join)(AnyGC*, AnyGC*) = nullptr;
    AnyGC*(*toList)(AnyGC*) = nullptr;
    AnyGC*(*toSet)(AnyGC*) = nullptr;
    AnyGC*(*followedBy)(AnyGC*, AnyGC*) = nullptr;
    AnyGC*(*asMap)(AnyGC*) = nullptr;
    AnyGC*(*plus)(AnyGC*, AnyGC*) = nullptr;
    AnyGC*(*elementAt)(AnyGC*, AnyGC*) = nullptr;
    // Template method fields (dispatch with AnyGC* as R, emitter casts result)
    AnyGC*(*map)(AnyGC*, AnyGC*) = nullptr;
    AnyGC*(*expand)(AnyGC*, AnyGC*) = nullptr;
    AnyGC*(*cast_)(AnyGC*) = nullptr;
    AnyGC*(*fold)(AnyGC*, AnyGC*, AnyGC*) = nullptr;
    AnyGC*(*whereType)(AnyGC*) = nullptr;
};
template<typename T> struct SetClassInfo : ClassInfo {
    constexpr SetClassInfo();
    // Set-specific getters
    AnyGC*(*get_first)(AnyGC*) = nullptr;
    AnyGC*(*get_last)(AnyGC*) = nullptr;
    AnyGC*(*get_single)(AnyGC*) = nullptr;
    // Set-specific methods
    bool(*add)(AnyGC*, AnyGC*) = nullptr;
    void(*addAll)(AnyGC*, AnyGC*) = nullptr;
    bool(*remove)(AnyGC*, AnyGC*) = nullptr;
    bool(*containsAll)(AnyGC*, AnyGC*) = nullptr;
    void(*removeWhere)(AnyGC*, AnyGC*) = nullptr;
    void(*retainWhere)(AnyGC*, AnyGC*) = nullptr;
    void(*clear)(AnyGC*) = nullptr;
    AnyGC*(*lookup)(AnyGC*, AnyGC*) = nullptr;
    void(*forEach)(AnyGC*, AnyGC*) = nullptr;
    AnyGC*(*where)(AnyGC*, AnyGC*) = nullptr;
    bool(*any_)(AnyGC*, AnyGC*) = nullptr;
    bool(*every_)(AnyGC*, AnyGC*) = nullptr;
    AnyGC*(*firstWhere)(AnyGC*, AnyGC*, AnyGC*) = nullptr;
    AnyGC*(*lastWhere)(AnyGC*, AnyGC*, AnyGC*) = nullptr;
    AnyGC*(*singleWhere)(AnyGC*, AnyGC*, AnyGC*) = nullptr;
    AnyGC*(*reduce)(AnyGC*, AnyGC*) = nullptr;
    AnyGC*(*unionSet)(AnyGC*, AnyGC*) = nullptr;
    AnyGC*(*intersection)(AnyGC*, AnyGC*) = nullptr;
    AnyGC*(*difference)(AnyGC*, AnyGC*) = nullptr;
    AnyGC*(*toList)(AnyGC*) = nullptr;
    AnyGC*(*toSet)(AnyGC*) = nullptr;
    AnyGC*(*followedBy)(AnyGC*, AnyGC*) = nullptr;
    AnyGC*(*take)(AnyGC*, AnyGC*) = nullptr;
    AnyGC*(*skip)(AnyGC*, AnyGC*) = nullptr;
    AnyGC*(*takeWhile)(AnyGC*, AnyGC*) = nullptr;
    AnyGC*(*skipWhile)(AnyGC*, AnyGC*) = nullptr;
    AnyGC*(*join)(AnyGC*, AnyGC*) = nullptr;
    AnyGC*(*elementAt)(AnyGC*, AnyGC*) = nullptr;
    // Template method fields
    AnyGC*(*map)(AnyGC*, AnyGC*) = nullptr;
    AnyGC*(*expand)(AnyGC*, AnyGC*) = nullptr;
    AnyGC*(*cast_)(AnyGC*) = nullptr;
    AnyGC*(*fold)(AnyGC*, AnyGC*, AnyGC*) = nullptr;
    AnyGC*(*whereType)(AnyGC*) = nullptr;
};
template<typename K, typename V> struct MapClassInfo : ClassInfo {
    constexpr MapClassInfo();
    // Map-specific getters
    AnyGC*(*get_keys)(AnyGC*) = nullptr;
    AnyGC*(*get_values)(AnyGC*) = nullptr;
    AnyGC*(*get_entries)(AnyGC*) = nullptr;
    // Map-specific methods
    void(*put)(AnyGC*, AnyGC*, AnyGC*) = nullptr;
    AnyGC*(*remove)(AnyGC*, AnyGC*) = nullptr;
    bool(*containsValue)(AnyGC*, AnyGC*) = nullptr;
    void(*forEach)(AnyGC*, AnyGC*) = nullptr;
    void(*clear)(AnyGC*) = nullptr;
    AnyGC*(*putIfAbsent)(AnyGC*, AnyGC*, AnyGC*) = nullptr;
    AnyGC*(*update)(AnyGC*, AnyGC*, AnyGC*, AnyGC*) = nullptr;
    void(*updateAll)(AnyGC*, AnyGC*) = nullptr;
    void(*addAll)(AnyGC*, AnyGC*) = nullptr;
    void(*addEntries)(AnyGC*, AnyGC*) = nullptr;
    void(*removeWhere)(AnyGC*, AnyGC*) = nullptr;
    // Template method fields
    AnyGC*(*map)(AnyGC*, AnyGC*) = nullptr;
    AnyGC*(*cast_)(AnyGC*) = nullptr;
};

// ── DynArray<T> — self-managed dynamic array (replaces std::vector for Array storage) ──

template<typename T>
struct DynArray {
    T* _data = nullptr;
    int _size = 0;
    int _capacity = 0;

    DynArray() = default;

    DynArray(int count, const T& fill) {
        ensureCapacity(count);
        for (int i = 0; i < count; i++) push_back(fill);
    }

    DynArray(std::initializer_list<T> init) {
        ensureCapacity(static_cast<int>(init.size()));
        for (const auto& e : init) push_back(e);
    }

    template<typename Iter, typename = std::enable_if_t<!std::is_integral_v<Iter>>>
    DynArray(Iter b, Iter e) {
        for (auto it = b; it != e; ++it) push_back(*it);
    }

    // Elements are GC-managed; only free raw memory
    ~DynArray() {
        if (_data) ::operator delete(_data);
    }

    DynArray(const DynArray& other) {
        ensureCapacity(other._size);
        for (int i = 0; i < other._size; i++) push_back(other._data[i]);
    }

    DynArray& operator=(const DynArray& other) {
        if (this != &other) {
            _size = 0;
            ensureCapacity(other._size);
            for (int i = 0; i < other._size; i++) push_back(other._data[i]);
        }
        return *this;
    }

    DynArray(DynArray&& other) noexcept
        : _data(other._data), _size(other._size), _capacity(other._capacity) {
        other._data = nullptr;
        other._size = 0;
        other._capacity = 0;
    }

    DynArray& operator=(DynArray&& other) noexcept {
        if (this != &other) {
            if (_data) ::operator delete(_data);
            _data = other._data;
            _size = other._size;
            _capacity = other._capacity;
            other._data = nullptr;
            other._size = 0;
            other._capacity = 0;
        }
        return *this;
    }

    void ensureCapacity(int minCap) {
        if (minCap <= _capacity) return;
        int newCap = _capacity == 0 ? 4 : _capacity;
        while (newCap < minCap) newCap *= 2;
        T* newData = static_cast<T*>(::operator new(static_cast<size_t>(newCap) * sizeof(T)));
        for (int i = 0; i < _size; i++) {
            new (newData + i) T(std::move(_data[i]));
        }
        if (_data) ::operator delete(_data);
        _data = newData;
        _capacity = newCap;
    }

    void reserve(int n) { ensureCapacity(n); }

    void push_back(const T& v) {
        ensureCapacity(_size + 1);
        new (_data + _size) T(v);
        _size++;
    }

    void push_back(T&& v) {
        ensureCapacity(_size + 1);
        new (_data + _size) T(std::move(v));
        _size++;
    }

    void pop_back() {
        if (_size > 0) _size--;
    }

    T& operator[](size_t i) { return _data[i]; }
    const T& operator[](size_t i) const { return _data[i]; }

    T& front() { return _data[0]; }
    const T& front() const { return _data[0]; }
    T& back() { return _data[_size - 1]; }
    const T& back() const { return _data[_size - 1]; }

    T* data() { return _data; }
    const T* data() const { return _data; }

    T* begin() { return _data; }
    T* end() { return _data + _size; }
    const T* begin() const { return _data; }
    const T* end() const { return _data + _size; }

    int size() const { return _size; }
    bool empty() const { return _size == 0; }

    // Don't destroy elements — let GC reclaim AnyGC objects automatically
    void clear() { _size = 0; }

    T* insert(T* pos, const T& val) {
        int idx = static_cast<int>(pos - _data);
        ensureCapacity(_size + 1);
        if (_size > idx) {
            new (_data + _size) T(std::move(_data[_size - 1]));
            for (int i = _size - 1; i > idx; i--) {
                _data[i] = std::move(_data[i - 1]);
            }
            _data[idx] = val;
        } else {
            new (_data + idx) T(val);
        }
        _size++;
        return _data + idx;
    }

    T* erase(T* pos) {
        int idx = static_cast<int>(pos - _data);
        for (int i = idx; i < _size - 1; i++) {
            _data[i] = std::move(_data[i + 1]);
        }
        _size--;
        return _data + idx;
    }

    T* erase(T* first, T* last) {
        int start = static_cast<int>(first - _data);
        int count = static_cast<int>(last - first);
        for (int i = start; i + count < _size; i++) {
            _data[i] = std::move(_data[i + count]);
        }
        _size -= count;
        return _data + start;
    }

    // GC mark: trace AnyGC-derived pointer elements only
    void gcMark(int flag) {
        if constexpr (std::is_pointer_v<T>) {
            using Pointee = std::remove_pointer_t<T>;
            if constexpr (std::is_base_of_v<AnyGC, Pointee>) {
                for (int i = 0; i < _size; i++) {
                    if (_data[i]) _gcMark(_data[i], flag);
                }
            }
        }
    }
};

// ── Array<T> ──

template<typename T>
struct Array : AnyGC {
    static const ArrayClassInfo<T> _classInfo;
    DynArray<T> _storage;

    Array() { AnyGC::_classInfo = &_classInfo; }
    Array(int size, T fill = T()) : _storage(size, fill) { AnyGC::_classInfo = &_classInfo; }
    Array(std::initializer_list<T> init) : _storage(init) { AnyGC::_classInfo = &_classInfo; }

    template<typename Iter>
    Array(Iter begin, Iter end) : _storage(begin, end) { AnyGC::_classInfo = &_classInfo; }

    // 从 List 构造（前向声明，实现在 List 定义之后）
    Array(List<T>* list);

    T& operator[](int64_t i) {
        if (i < 0 || static_cast<size_t>(i) >= _storage.size()) {
            char buf[80];
            snprintf(buf, sizeof(buf), "Index %lld out of range [0..%lld)",
                     static_cast<long long>(i), static_cast<long long>(_storage.size()));
            throw DartRangeError(string(buf));
        }
        return _storage[static_cast<size_t>(i)];
    }
    const T& operator[](int64_t i) const {
        if (i < 0 || static_cast<size_t>(i) >= _storage.size()) {
            char buf[80];
            snprintf(buf, sizeof(buf), "Index %lld out of range [0..%lld)",
                     static_cast<long long>(i), static_cast<long long>(_storage.size()));
            throw DartRangeError(string(buf));
        }
        return _storage[static_cast<size_t>(i)];
    }

    static void _gcMark_impl(AnyGC* self, int flag) {
        static_cast<Array*>(self)->_storage.gcMark(flag);
    }

    // ── ClassInfo dispatch ──
    static AnyGC* _vptr_toString(AnyGC* self) {
        auto* arr = static_cast<Array*>(self);
        string result = "[";
        for (size_t i = 0; i < arr->_storage.size(); i++) {
            if (i > 0) result += ", ";
            result += _anyToString(_boxElem<T>(arr->_storage[i]));
        }
        result += "]";
        return _box(result);
    }
    static AnyGC* _vptr_runtimeType(AnyGC* self) {
        return _box(string("List"));
    }
    static int64_t _vptr_length(AnyGC* self) {
        return static_cast<int64_t>(static_cast<Array*>(self)->_storage.size());
    }
    static bool _vptr_isEmpty(AnyGC* self) {
        return static_cast<Array*>(self)->_storage.empty();
    }
    static bool _vptr_isNotEmpty(AnyGC* self) {
        return !static_cast<Array*>(self)->_storage.empty();
    }
    static AnyGC* _vptr_index(AnyGC* self, AnyGC* idx) {
        return _boxElem<T>(static_cast<Array*>(self)->_storage[static_cast<int>(dynAs<int64_t>(idx))]);
    }
    static void _vptr_setIndex(AnyGC* self, AnyGC* idx, AnyGC* val) {
        static_cast<Array*>(self)->_storage[static_cast<int>(dynAs<int64_t>(idx))] = _unboxElem<T>(val);
    }
    static bool _vptr_contains(AnyGC* self, AnyGC* element) {
        if constexpr (_isEqualityComparable<T>::value) {
            auto* arr = static_cast<Array*>(self);
            return std::find(arr->_storage.begin(), arr->_storage.end(), _unboxElem<T>(element)) != arr->_storage.end();
        } else {
            return false;
        }
    }
    static void _vptr_add(AnyGC* self, AnyGC* element) {
        static_cast<Array*>(self)->_storage.push_back(_unboxElem<T>(element));
    }
    static void _vptr_insert(AnyGC* self, AnyGC* idx, AnyGC* val) {
        auto* arr = static_cast<Array*>(self);
        arr->_storage.insert(arr->_storage.begin() + static_cast<int>(dynAs<int64_t>(idx)), _unboxElem<T>(val));
    }
    static AnyGC* _vptr_removeAt(AnyGC* self, AnyGC* idx) {
        auto* arr = static_cast<Array*>(self);
        int i = static_cast<int>(dynAs<int64_t>(idx));
        T val = std::move(arr->_storage[i]);
        arr->_storage.erase(arr->_storage.begin() + i);
        return _boxElem<T>(val);
    }
    static bool _vptr_remove(AnyGC* self, AnyGC* element) {
        if constexpr (_isEqualityComparable<T>::value) {
            auto* arr = static_cast<Array*>(self);
            auto it = std::find(arr->_storage.begin(), arr->_storage.end(), _unboxElem<T>(element));
            if (it == arr->_storage.end()) return false;
            arr->_storage.erase(it);
            return true;
        } else {
            return false;
        }
    }
    static int64_t _vptr_indexOf(AnyGC* self, AnyGC* element) {
        if constexpr (_isEqualityComparable<T>::value) {
            auto* arr = static_cast<Array*>(self);
            auto it = std::find(arr->_storage.begin(), arr->_storage.end(), _unboxElem<T>(element));
            if (it == arr->_storage.end()) return static_cast<int64_t>(-1);
            return static_cast<int64_t>(std::distance(arr->_storage.begin(), it));
        } else {
            return static_cast<int64_t>(-1);
        }
    }
    static void _vptr_clear(AnyGC* self) {
        static_cast<Array*>(self)->_storage.clear();
    }
};

// Free helper functions for Array operations (replacing instance methods)
template<typename T>
bool array_contains(Array<T>* arr, const T& val) {
    return std::find(arr->_storage.begin(), arr->_storage.end(), val) != arr->_storage.end();
}
template<typename T>
int array_indexOf(Array<T>* arr, const T& val) {
    auto it = std::find(arr->_storage.begin(), arr->_storage.end(), val);
    if (it == arr->_storage.end()) return -1;
    return static_cast<int>(std::distance(arr->_storage.begin(), it));
}
template<typename T>
T array_removeAt(Array<T>* arr, int index) {
    T val = std::move(arr->_storage[index]);
    arr->_storage.erase(arr->_storage.begin() + index);
    return val;
}
template<typename T>
void array_insert(Array<T>* arr, int index, const T& val) {
    arr->_storage.insert(arr->_storage.begin() + index, val);
}

template<typename T>
constexpr ArrayClassInfo<T>::ArrayClassInfo() {
    typeName = "Array";
    destroy = &_gcDestroy<Array<T>>;
    gcMark = &Array<T>::_gcMark_impl;
    toString = &Array<T>::_vptr_toString;
    get_runtimeType = &Array<T>::_vptr_runtimeType;
    get_length = &Array<T>::_vptr_length;
    index = &Array<T>::_vptr_index;
    setIndex = &Array<T>::_vptr_setIndex;
    contains = &Array<T>::_vptr_contains;
    get_isEmpty = &Array<T>::_vptr_isEmpty;
    get_isNotEmpty = &Array<T>::_vptr_isNotEmpty;
    add = &Array<T>::_vptr_add;
    insert = &Array<T>::_vptr_insert;
    removeAt = &Array<T>::_vptr_removeAt;
    remove = &Array<T>::_vptr_remove;
    indexOf = &Array<T>::_vptr_indexOf;
    clear = &Array<T>::_vptr_clear;
}

template<typename T>
inline constexpr ArrayClassInfo<T> Array<T>::_classInfo{};

// ── Iterator<T> ──

template<typename T>
struct Iterator : AnyGC {
    static const IteratorClassInfo<T> _classInfo;
    Array<T>* _data;
    int _index;

    Iterator(Array<T>* data) : _data(data), _index(0) { AnyGC::_classInfo = &_classInfo; }

    static void _gcMark_impl(AnyGC* self, int flag) {
        auto* it = static_cast<Iterator*>(self);
        if (it->_data) _gcMark(it->_data, flag);
    }

    // ── ClassInfo dispatch ──
    static AnyGC* _vptr_toString(AnyGC* self) {
        return _box(string("Iterator"));
    }
    static AnyGC* _vptr_runtimeType(AnyGC* self) {
        return _box(string("Iterator"));
    }
    static bool _vptr_moveNext(AnyGC* self) {
        auto* it = static_cast<Iterator*>(self);
        it->_index++;
        return it->_index <= static_cast<int>(it->_data->_storage.size());
    }
    static AnyGC* _vptr_current(AnyGC* self) {
        auto* it = static_cast<Iterator*>(self);
        return _boxElem<T>(it->_data->_storage[it->_index - 1]);
    }
    static void _vptr_reset(AnyGC* self) {
        static_cast<Iterator*>(self)->_index = 0;
    }
};

template<typename T>
constexpr IteratorClassInfo<T>::IteratorClassInfo() {
    typeName = "Iterator";
    destroy = &_gcDestroy<Iterator<T>>;
    gcMark = &Iterator<T>::_gcMark_impl;
    toString = &Iterator<T>::_vptr_toString;
    get_runtimeType = &Iterator<T>::_vptr_runtimeType;
    moveNext = &Iterator<T>::_vptr_moveNext;
    current = &Iterator<T>::_vptr_current;
    reset = &Iterator<T>::_vptr_reset;
}

template<typename T>
inline constexpr IteratorClassInfo<T> Iterator<T>::_classInfo{};

// Free function wrappers for Iterator — dispatch through ClassInfo
inline bool iterator_moveNext(AnyGC* self) {
    auto* ci = static_cast<const IteratorClassInfo<AnyGC*>*>(self->_classInfo);
    return ci->moveNext ? ci->moveNext(self) : false;
}
inline AnyGC* iterator_current(AnyGC* self) {
    auto* ci = static_cast<const IteratorClassInfo<AnyGC*>*>(self->_classInfo);
    return ci->current ? ci->current(self) : nullptr;
}
inline void iterator_reset(AnyGC* self) {
    auto* ci = static_cast<const IteratorClassInfo<AnyGC*>*>(self->_classInfo);
    if (ci->reset) ci->reset(self);
}
inline AnyGC* iterator_get(AnyGC* collection) {
    auto* ci = static_cast<const ClassInfo*>(collection->_classInfo);
    return ci && ci->get_iterator ? ci->get_iterator(collection) : nullptr;
}

// ── List<T> ──
// 对齐 Dart _collections.dart List<T>

template<typename T>
struct List : AnyGC {
    Array<T>* _data;
    static const ListClassInfo<T> _classInfo;

    List() : _data(GC::allocateLocal(new Array<T>())) { AnyGC::_classInfo = &List::_classInfo; }

    List(std::initializer_list<T> init)
        : _data(GC::allocateLocal(new Array<T>(init))) { AnyGC::_classInfo = &List::_classInfo; }

    static List* of(std::initializer_list<T> elements) {
        return GC::allocateLocal(new List(elements));
    }

    static List* empty() {
        return GC::allocateLocal(new List());
    }

    /// 对齐 Dart: List.filled(length, fill)
    static List* filled(int length, T fill) {
        auto* result = GC::allocateLocal(new List());
        for (int i = 0; i < length; i++) result->_data->_storage.push_back(fill);
        return result;
    }

    /// 对齐 Dart: List.generate(length, generator)
    static List* generate(int length, std::function<T(int)> generator) {
        auto* result = GC::allocateLocal(new List());
        for (int i = 0; i < length; i++) result->_data->_storage.push_back(generator(i));
        return result;
    }

    /// 对齐 Dart: List.generate(length, generator) — TypeFunction 版本
    static List* generate(int length, TypeFunction1<T, int64_t>* generator) {
        auto* result = GC::allocateLocal(new List());
        if (generator) {
            for (int i = 0; i < length; i++) result->_data->_storage.push_back(_unboxElem<T>(generator->fnPtr(generator, _box(static_cast<int64_t>(i)))));
        }
        return result;
    }

    /// 对齐 Dart: List.from(elements)
    static List* from(List<T>* source) {
        auto* result = GC::allocateLocal(new List());
        if (source) {
            for (int i = 0; i < source->_data->_storage.size(); i++) result->_data->_storage.push_back(source->_data->_storage[i]);
        }
        return result;
    }

    // ── ClassInfo vptr support ──
    static AnyGC* _vptr_runtimeType(AnyGC*) {
        return _box(string("List"));
    }
    static int64_t _vptr_length(AnyGC* self) {
        return static_cast<int64_t>(static_cast<List*>(self)->_data->_storage.size());
    }
    static AnyGC* _vptr_toString(AnyGC* self) {
        auto* list = static_cast<List*>(self);
        string result = "[";
        for (int i = 0; i < list->_data->_storage.size(); i++) {
            if (i > 0) result += ", ";
            result += dart_str(list->_data->_storage[i]);
        }
        result += "]";
        return _box(result);
    }
    static bool _vptr_eq(AnyGC* self, AnyGC* other) {
        return self == other;
    }
    static int64_t _vptr_hashCode(AnyGC* self) {
        return static_cast<int64_t>(reinterpret_cast<intptr_t>(self));
    }
    static bool _vptr_contains(AnyGC* self, AnyGC* element) {
        if constexpr (_isEqualityComparable<T>::value) {
            return array_contains(static_cast<List*>(self)->_data, _unboxElem<T>(element));
        } else {
            return false;
        }
    }
    static AnyGC* _vptr_index(AnyGC* self, AnyGC* idx) {
        auto* list = static_cast<List*>(self);
        int64_t i = dynAs<int64_t>(idx);
        return _boxElem<T>(list->_data->_storage[static_cast<int>(i)]);
    }
    static void _vptr_setIndex(AnyGC* self, AnyGC* idx, AnyGC* val) {
        auto* list = static_cast<List*>(self);
        int64_t i = dynAs<int64_t>(idx);
        list->_data->_storage[static_cast<int>(i)] = _unboxElem<T>(val);
    }
    // List-specific getters
    static bool _vptr_isEmpty(AnyGC* self) {
        return static_cast<List*>(self)->_data->_storage.size() == 0;
    }
    static bool _vptr_isNotEmpty(AnyGC* self) {
        return static_cast<List*>(self)->_data->_storage.size() > 0;
    }
    static AnyGC* _vptr_first(AnyGC* self) {
        auto* list = static_cast<List*>(self);
        if (list->_data->_storage.size() == 0) throw DartStateError("No element");
        return _boxElem<T>(list->_data->_storage[0]);
    }
    static AnyGC* _vptr_last(AnyGC* self) {
        auto* list = static_cast<List*>(self);
        if (list->_data->_storage.size() == 0) throw DartStateError("No element");
        return _boxElem<T>(list->_data->_storage[list->_data->_storage.size() - 1]);
    }
    static AnyGC* _vptr_single(AnyGC* self) {
        auto* list = static_cast<List*>(self);
        if (list->_data->_storage.size() != 1) throw DartStateError("Not single element");
        return _boxElem<T>(list->_data->_storage[0]);
    }
    static AnyGC* _vptr_reversed(AnyGC* self) {
        auto* list = static_cast<List*>(self);
        auto* result = new List<T>();
        result->_data->_storage.reserve(list->_data->_storage.size());
        for (int i = list->_data->_storage.size() - 1; i >= 0; i--) result->_data->_storage.push_back(list->_data->_storage[i]);
        return static_cast<AnyGC*>(GC::allocateLocal(result));
    }
    static AnyGC* _vptr_iterator(AnyGC* self) {
        auto* list = static_cast<List*>(self);
        return static_cast<AnyGC*>(GC::allocateLocal(new Iterator<T>(list->_data)));
    }
    // List-specific methods
    static void _vptr_add(AnyGC* self, AnyGC* arg) {
        static_cast<List*>(self)->_data->_storage.push_back(_unboxElem<T>(arg));
    }
    static void _vptr_addAll(AnyGC* self, AnyGC* arg) {
        auto* list = static_cast<List*>(self);
        auto* other = static_cast<List*>(arg);
        if (!other) return;
        for (int i = 0; i < other->_data->_storage.size(); i++) list->_data->_storage.push_back(other->_data->_storage[i]);
    }
    static void _vptr_insert(AnyGC* self, AnyGC* idx, AnyGC* val) {
        array_insert(static_cast<List*>(self)->_data, static_cast<int>(dynAs<int64_t>(idx)), _unboxElem<T>(val));
    }
    static void _vptr_insertAll(AnyGC* self, AnyGC* idx, AnyGC* other) {
        auto* list = static_cast<List*>(self);
        auto* o = static_cast<List*>(other);
        if (!o) return;
        int i = static_cast<int>(dynAs<int64_t>(idx));
        for (int j = 0; j < o->_data->_storage.size(); j++) {
            array_insert(list->_data, i, o->_data->_storage[j]);
            i++;
        }
    }
    static AnyGC* _vptr_removeAt(AnyGC* self, AnyGC* idx) {
        return _boxElem<T>(array_removeAt(static_cast<List*>(self)->_data, static_cast<int>(dynAs<int64_t>(idx))));
    }
    static bool _vptr_remove(AnyGC* self, AnyGC* element) {
        if constexpr (_isEqualityComparable<T>::value) {
            auto* list = static_cast<List*>(self);
            int idx = array_indexOf(list->_data, _unboxElem<T>(element));
            if (idx == -1) return false;
            array_removeAt(list->_data, idx);
            return true;
        } else {
            return false;
        }
    }
    static AnyGC* _vptr_removeLast(AnyGC* self) {
        auto* list = static_cast<List*>(self);
        int len = list->_data->_storage.size();
        if (len == 0) throw DartRangeError("Cannot removeLast on empty list");
        return _boxElem<T>(array_removeAt(list->_data, len - 1));
    }
    static void _vptr_removeWhere(AnyGC* self, AnyGC* test) {
        auto* list = static_cast<List*>(self);
        auto* tf = static_cast<TypeFunction1<bool, T>*>(test);
        for (int i = list->_data->_storage.size() - 1; i >= 0; i--) {
            if (_predApply(tf, list->_data->_storage[i])) array_removeAt(list->_data, i);
        }
    }
    static void _vptr_retainWhere(AnyGC* self, AnyGC* test) {
        auto* list = static_cast<List*>(self);
        auto* tf = static_cast<TypeFunction1<bool, T>*>(test);
        for (int i = list->_data->_storage.size() - 1; i >= 0; i--) {
            if (!_predApply(tf, list->_data->_storage[i])) array_removeAt(list->_data, i);
        }
    }
    static void _vptr_removeRange(AnyGC* self, AnyGC* start, AnyGC* end) {
        auto* list = static_cast<List*>(self);
        int s = static_cast<int>(dynAs<int64_t>(start));
        int e = static_cast<int>(dynAs<int64_t>(end));
        int len = static_cast<int>(list->_data->_storage.size());
        if (s < 0 || e > len || s > e) throw DartRangeError("Invalid range in removeRange");
        list->_data->_storage.erase(list->_data->_storage.begin() + s, list->_data->_storage.begin() + e);
    }
    static void _vptr_fillRange(AnyGC* self, AnyGC* start, AnyGC* end, AnyGC* fill) {
        auto* list = static_cast<List*>(self);
        int s = static_cast<int>(dynAs<int64_t>(start));
        int e = static_cast<int>(dynAs<int64_t>(end));
        int len = static_cast<int>(list->_data->_storage.size());
        if (s < 0 || e > len || s > e) throw DartRangeError("Invalid range in fillRange");
        T value = fill ? _unboxElem<T>(fill) : T{};
        std::fill(list->_data->_storage.begin() + s, list->_data->_storage.begin() + e, value);
    }
    static void _vptr_clear(AnyGC* self) {
        static_cast<List*>(self)->_data->_storage.clear();
    }
    static void _vptr_sort(AnyGC* self, AnyGC* compare) {
        auto* list = static_cast<List*>(self);
        if (!compare) {
            if constexpr (_isLessThanComparable<T>::value) {
                if (list->_data->_storage.size() <= 1) return;
                std::sort(list->_data->_storage.begin(), list->_data->_storage.end());
            }
            return;
        }
        auto* cmp = static_cast<TypeFunction2<int64_t, T, T>*>(compare);
        if (list->_data->_storage.size() <= 1) return;
        std::sort(list->_data->_storage.begin(), list->_data->_storage.end(),
            [cmp](const T& a, const T& b) {
                return dynAs<int64_t>(cmp->fnPtr(cmp, _boxElem<T>(a), _boxElem<T>(b))) < 0;
            });
    }
    static int64_t _vptr_indexOf(AnyGC* self, AnyGC* element, AnyGC* start) {
        if constexpr (_isEqualityComparable<T>::value) {
            auto* list = static_cast<List*>(self);
            int64_t s = start ? dynAs<int64_t>(start) : 0;
            for (int i = static_cast<int>(s); i < list->_data->_storage.size(); i++) {
                if (list->_data->_storage[i] == _unboxElem<T>(element)) return static_cast<int64_t>(i);
            }
            return static_cast<int64_t>(-1);
        } else {
            return static_cast<int64_t>(-1);
        }
    }
    static int64_t _vptr_lastIndexOf(AnyGC* self, AnyGC* element, AnyGC* end) {
        if constexpr (_isEqualityComparable<T>::value) {
            auto* list = static_cast<List*>(self);
            int64_t e = end ? dynAs<int64_t>(end) : -1;
            int endIdx = (e == -1) ? list->_data->_storage.size() - 1 : static_cast<int>(e);
            for (int i = endIdx; i >= 0; i--) {
                if (list->_data->_storage[i] == _unboxElem<T>(element)) return static_cast<int64_t>(i);
            }
            return static_cast<int64_t>(-1);
        } else {
            return static_cast<int64_t>(-1);
        }
    }
    static int64_t _vptr_indexWhere(AnyGC* self, AnyGC* test, AnyGC* start) {
        auto* list = static_cast<List*>(self);
        auto* tf = static_cast<TypeFunction1<bool, T>*>(test);
        int64_t s = start ? dynAs<int64_t>(start) : 0;
        for (int i = static_cast<int>(s); i < list->_data->_storage.size(); i++) {
            if (_predApply(tf, list->_data->_storage[i])) return static_cast<int64_t>(i);
        }
        return static_cast<int64_t>(-1);
    }
    static int64_t _vptr_lastIndexWhere(AnyGC* self, AnyGC* test, AnyGC* start) {
        auto* list = static_cast<List*>(self);
        auto* tf = static_cast<TypeFunction1<bool, T>*>(test);
        int startIdx = start ? static_cast<int>(dynAs<int64_t>(start)) : static_cast<int>(list->_data->_storage.size()) - 1;
        if (startIdx >= static_cast<int>(list->_data->_storage.size())) startIdx = static_cast<int>(list->_data->_storage.size()) - 1;
        for (int i = startIdx; i >= 0; i--) {
            if (_predApply(tf, list->_data->_storage[i])) return static_cast<int64_t>(i);
        }
        return static_cast<int64_t>(-1);
    }
    static void _vptr_forEach(AnyGC* self, AnyGC* func) {
        auto* list = static_cast<List*>(self);
        auto* tf = static_cast<TypeFunction1<void, T>*>(func);
        for (int i = 0; i < list->_data->_storage.size(); i++) tf->fnPtr(tf, _boxElem<T>(list->_data->_storage[i]));
    }
    static AnyGC* _vptr_where(AnyGC* self, AnyGC* test) {
        auto* list = static_cast<List*>(self);
        auto* tf = static_cast<TypeFunction1<bool, T>*>(test);
        auto* result = new List<T>();
        result->_data->_storage.reserve(list->_data->_storage.size());
        for (int i = 0; i < list->_data->_storage.size(); i++) {
            if (_predApply(tf, list->_data->_storage[i])) result->_data->_storage.push_back(list->_data->_storage[i]);
        }
        return static_cast<AnyGC*>(GC::allocateLocal(result));
    }
    static bool _vptr_any_(AnyGC* self, AnyGC* test) {
        auto* list = static_cast<List*>(self);
        auto* tf = static_cast<TypeFunction1<bool, T>*>(test);
        for (int i = 0; i < list->_data->_storage.size(); i++) {
            if (_predApply(tf, list->_data->_storage[i])) return true;
        }
        return false;
    }
    static bool _vptr_every_(AnyGC* self, AnyGC* test) {
        auto* list = static_cast<List*>(self);
        auto* tf = static_cast<TypeFunction1<bool, T>*>(test);
        for (int i = 0; i < list->_data->_storage.size(); i++) {
            if (!_predApply(tf, list->_data->_storage[i])) return false;
        }
        return true;
    }
    static AnyGC* _vptr_firstWhere(AnyGC* self, AnyGC* test, AnyGC* orElse) {
        auto* list = static_cast<List*>(self);
        auto* tf = static_cast<TypeFunction1<bool, T>*>(test);
        for (int i = 0; i < list->_data->_storage.size(); i++) {
            if (_predApply(tf, list->_data->_storage[i])) return _boxElem<T>(list->_data->_storage[i]);
        }
        if (orElse) {
            auto* of = static_cast<TypeFunction0<T>*>(orElse);
            return of->fnPtr(of);
        }
        throw DartStateError("No element");
    }
    static AnyGC* _vptr_lastWhere(AnyGC* self, AnyGC* test, AnyGC* orElse) {
        auto* list = static_cast<List*>(self);
        auto* tf = static_cast<TypeFunction1<bool, T>*>(test);
        for (int i = list->_data->_storage.size() - 1; i >= 0; i--) {
            if (_predApply(tf, list->_data->_storage[i])) return _boxElem<T>(list->_data->_storage[i]);
        }
        if (orElse) {
            auto* of = static_cast<TypeFunction0<T>*>(orElse);
            return of->fnPtr(of);
        }
        throw DartStateError("No element");
    }
    static AnyGC* _vptr_singleWhere(AnyGC* self, AnyGC* test, AnyGC* orElse) {
        auto* list = static_cast<List*>(self);
        auto* tf = static_cast<TypeFunction1<bool, T>*>(test);
        bool foundMultiple = false;
        T found{};
        bool hasFound = false;
        for (int i = 0; i < list->_data->_storage.size(); i++) {
            if (_predApply(tf, list->_data->_storage[i])) {
                if (hasFound) { foundMultiple = true; break; }
                found = list->_data->_storage[i];
                hasFound = true;
            }
        }
        if (foundMultiple) throw DartStateError("Too many elements");
        if (hasFound) return _boxElem<T>(found);
        if (orElse) {
            auto* of = static_cast<TypeFunction0<T>*>(orElse);
            return of->fnPtr(of);
        }
        throw DartStateError("No element");
    }
    static AnyGC* _vptr_reduce(AnyGC* self, AnyGC* combine) {
        auto* list = static_cast<List*>(self);
        if (list->_data->_storage.size() == 0) throw DartStateError("No element");
        auto* cmp = static_cast<TypeFunction2<T, T, T>*>(combine);
        T value = list->_data->_storage[0];
        for (int i = 1; i < list->_data->_storage.size(); i++) value = _unboxElem<T>(cmp->fnPtr(cmp, _boxElem<T>(value), _boxElem<T>(list->_data->_storage[i])));
        return _boxElem<T>(value);
    }
    static AnyGC* _vptr_take(AnyGC* self, AnyGC* count) {
        auto* list = static_cast<List*>(self);
        int c = static_cast<int>(dynAs<int64_t>(count));
        auto* result = new List<T>();
        int end = c < list->_data->_storage.size() ? c : list->_data->_storage.size();
        result->_data->_storage.reserve(end);
        for (int i = 0; i < end; i++) result->_data->_storage.push_back(list->_data->_storage[i]);
        return static_cast<AnyGC*>(GC::allocateLocal(result));
    }
    static AnyGC* _vptr_skip(AnyGC* self, AnyGC* count) {
        auto* list = static_cast<List*>(self);
        int c = static_cast<int>(dynAs<int64_t>(count));
        auto* result = new List<T>();
        result->_data->_storage.reserve(list->_data->_storage.size() - c);
        for (int i = c; i < list->_data->_storage.size(); i++) result->_data->_storage.push_back(list->_data->_storage[i]);
        return static_cast<AnyGC*>(GC::allocateLocal(result));
    }
    static AnyGC* _vptr_takeWhile(AnyGC* self, AnyGC* test) {
        auto* list = static_cast<List*>(self);
        auto* tf = static_cast<TypeFunction1<bool, T>*>(test);
        auto* result = new List<T>();
        for (int i = 0; i < list->_data->_storage.size(); i++) {
            if (!_predApply(tf, list->_data->_storage[i])) break;
            result->_data->_storage.push_back(list->_data->_storage[i]);
        }
        return static_cast<AnyGC*>(GC::allocateLocal(result));
    }
    static AnyGC* _vptr_skipWhile(AnyGC* self, AnyGC* test) {
        auto* list = static_cast<List*>(self);
        auto* tf = static_cast<TypeFunction1<bool, T>*>(test);
        auto* result = new List<T>();
        result->_data->_storage.reserve(list->_data->_storage.size());
        bool skipping = true;
        for (int i = 0; i < list->_data->_storage.size(); i++) {
            if (skipping && _predApply(tf, list->_data->_storage[i])) continue;
            skipping = false;
            result->_data->_storage.push_back(list->_data->_storage[i]);
        }
        return static_cast<AnyGC*>(GC::allocateLocal(result));
    }
    static AnyGC* _vptr_sublist(AnyGC* self, AnyGC* start, AnyGC* end) {
        auto* list = static_cast<List*>(self);
        int64_t s = dynAs<int64_t>(start);
        int actualEnd = end ? static_cast<int>(dynAs<int64_t>(end)) : list->_data->_storage.size();
        auto* result = new List<T>();
        result->_data->_storage.reserve(actualEnd - static_cast<int>(s));
        for (int i = static_cast<int>(s); i < actualEnd; i++) result->_data->_storage.push_back(list->_data->_storage[i]);
        return static_cast<AnyGC*>(GC::allocateLocal(result));
    }
    static AnyGC* _vptr_getRange(AnyGC* self, AnyGC* start, AnyGC* end) {
        return _vptr_sublist(self, start, end);
    }
    static AnyGC* _vptr_join(AnyGC* self, AnyGC* separator) {
        auto* list = static_cast<List*>(self);
        string result;
        string sep = separator ? dynAs<string>(separator) : "";
        for (int i = 0; i < list->_data->_storage.size(); i++) {
            if (i > 0) result += sep;
            result += dart_str(list->_data->_storage[i]);
        }
        return _box(result);
    }
    static AnyGC* _vptr_toList(AnyGC* self) {
        auto* list = static_cast<List*>(self);
        auto* result = GC::allocateLocal(new List<T>());
        result->_data->_storage.reserve(list->_data->_storage.size());
        for (int i = 0; i < list->_data->_storage.size(); i++) result->_data->_storage.push_back(list->_data->_storage[i]);
        return static_cast<AnyGC*>(result);
    }
    static AnyGC* _vptr_toSet(AnyGC* self);   // 定义在 Set 之后
    static AnyGC* _vptr_followedBy(AnyGC* self, AnyGC* other) {
        auto* list = static_cast<List*>(self);
        auto* o = static_cast<List*>(other);
        auto* result = new List<T>();
        int total = list->_data->_storage.size() + (o ? o->_data->_storage.size() : 0);
        result->_data->_storage.reserve(total);
        for (int i = 0; i < list->_data->_storage.size(); i++) result->_data->_storage.push_back(list->_data->_storage[i]);
        if (o) {
            for (int i = 0; i < o->_data->_storage.size(); i++) result->_data->_storage.push_back(o->_data->_storage[i]);
        }
        return static_cast<AnyGC*>(GC::allocateLocal(result));
    }
    static AnyGC* _vptr_asMap(AnyGC* self);   // 定义在 Map 之后
    static AnyGC* _vptr_plus(AnyGC* self, AnyGC* other) {
        return _vptr_followedBy(self, other);
    }
    static AnyGC* _vptr_elementAt(AnyGC* self, AnyGC* index) {
        auto* list = static_cast<List*>(self);
        return _boxElem<T>(list->_data->_storage[static_cast<int>(dynAs<int64_t>(index))]);
    }
    // Template method dispatch (result emitted as AnyGC*)
    static AnyGC* _vptr_map(AnyGC* self, AnyGC* func) {
        auto* list = static_cast<List*>(self);
        auto* tf = static_cast<TypeFunction1<AnyGC*, T>*>(func);
        auto* result = new List<AnyGC*>();
        result->_data->_storage.reserve(list->_data->_storage.size());
        for (int i = 0; i < list->_data->_storage.size(); i++) {
            result->_data->_storage.push_back(dynAs<AnyGC*>(tf->fnPtr(tf, _boxElem(list->_data->_storage[i]))));
        }
        return static_cast<AnyGC*>(GC::allocateLocal(result));
    }
    static AnyGC* _vptr_expand(AnyGC* self, AnyGC* func) {
        auto* list = static_cast<List*>(self);
        auto* tf = static_cast<TypeFunction1<AnyGC*, T>*>(func);
        auto* result = new List<AnyGC*>();
        result->_data->_storage.reserve(list->_data->_storage.size());
        for (int i = 0; i < list->_data->_storage.size(); i++) {
            AnyGC* inner = tf->fnPtr(tf, _boxElem(list->_data->_storage[i]));
            if (!inner) continue;
            AnyGC* it = iterator_get(inner);
            while (it && iterator_moveNext(it)) {
                result->_data->_storage.push_back(iterator_current(it));
            }
        }
        return static_cast<AnyGC*>(GC::allocateLocal(result));
    }
    static AnyGC* _vptr_cast_(AnyGC* self) {
        auto* list = static_cast<List*>(self);
        auto* result = new List<AnyGC*>();
        result->_data->_storage.reserve(list->_data->_storage.size());
        for (int i = 0; i < list->_data->_storage.size(); i++) {
            result->_data->_storage.push_back(_boxElem<T>(list->_data->_storage[i]));
        }
        return static_cast<AnyGC*>(GC::allocateLocal(result));
    }
    static AnyGC* _vptr_fold(AnyGC* self, AnyGC* initial, AnyGC* combine) {
        auto* list = static_cast<List*>(self);
        auto* cmp = static_cast<TypeFunction2<AnyGC*, AnyGC*, T>*>(combine);
        AnyGC* value = initial;
        for (int i = 0; i < list->_data->_storage.size(); i++) {
            value = cmp->fnPtr(cmp, value, _boxElem(list->_data->_storage[i]));
        }
        return value;
    }
    static AnyGC* _vptr_whereType(AnyGC* self) {
        auto* list = static_cast<List*>(self);
        auto* result = new List<AnyGC*>();
        result->_data->_storage.reserve(list->_data->_storage.size());
        for (int i = 0; i < list->_data->_storage.size(); i++) {
            if constexpr (std::is_pointer_v<T>) {
                result->_data->_storage.push_back(static_cast<AnyGC*>(list->_data->_storage[i]));
            }
        }
        return static_cast<AnyGC*>(GC::allocateLocal(result));
    }

    // ── GC ──

    static void _gcMark_impl(AnyGC* self, int flag) {
        auto* list = static_cast<List*>(self);
        if (list->_data) _gcMark(list->_data, flag);
    }
};

template<typename T>
constexpr ListClassInfo<T>::ListClassInfo() {
    typeName = "List";
    destroy = &_gcDestroy<List<T>>;
    // Base ClassInfo fields
    toString = &List<T>::_vptr_toString;
    get_runtimeType = &List<T>::_vptr_runtimeType;
    get_length = &List<T>::_vptr_length;
    eq = &List<T>::_vptr_eq;
    get_hashCode = &List<T>::_vptr_hashCode;
    contains = &List<T>::_vptr_contains;
    index = &List<T>::_vptr_index;
    setIndex = &List<T>::_vptr_setIndex;
    gcMark = &List<T>::_gcMark_impl;
    // List-specific getters
    get_isEmpty = &List<T>::_vptr_isEmpty;
    get_isNotEmpty = &List<T>::_vptr_isNotEmpty;
    get_first = &List<T>::_vptr_first;
    get_last = &List<T>::_vptr_last;
    get_single = &List<T>::_vptr_single;
    get_reversed = &List<T>::_vptr_reversed;
    get_iterator = &List<T>::_vptr_iterator;
    // List-specific methods
    add = &List<T>::_vptr_add;
    addAll = &List<T>::_vptr_addAll;
    insert = &List<T>::_vptr_insert;
    insertAll = &List<T>::_vptr_insertAll;
    removeAt = &List<T>::_vptr_removeAt;
    remove = &List<T>::_vptr_remove;
    removeLast = &List<T>::_vptr_removeLast;
    removeWhere = &List<T>::_vptr_removeWhere;
    retainWhere = &List<T>::_vptr_retainWhere;
    removeRange = &List<T>::_vptr_removeRange;
    fillRange = &List<T>::_vptr_fillRange;
    clear = &List<T>::_vptr_clear;
    sort = &List<T>::_vptr_sort;
    indexOf = &List<T>::_vptr_indexOf;
    lastIndexOf = &List<T>::_vptr_lastIndexOf;
    indexWhere = &List<T>::_vptr_indexWhere;
    lastIndexWhere = &List<T>::_vptr_lastIndexWhere;
    forEach = &List<T>::_vptr_forEach;
    where = &List<T>::_vptr_where;
    any_ = &List<T>::_vptr_any_;
    every_ = &List<T>::_vptr_every_;
    firstWhere = &List<T>::_vptr_firstWhere;
    lastWhere = &List<T>::_vptr_lastWhere;
    singleWhere = &List<T>::_vptr_singleWhere;
    reduce = &List<T>::_vptr_reduce;
    take = &List<T>::_vptr_take;
    skip = &List<T>::_vptr_skip;
    takeWhile = &List<T>::_vptr_takeWhile;
    skipWhile = &List<T>::_vptr_skipWhile;
    sublist = &List<T>::_vptr_sublist;
    getRange = &List<T>::_vptr_getRange;
    join = &List<T>::_vptr_join;
    toList = &List<T>::_vptr_toList;
    toSet = &List<T>::_vptr_toSet;
    followedBy = &List<T>::_vptr_followedBy;
    asMap = &List<T>::_vptr_asMap;
    plus = &List<T>::_vptr_plus;
    elementAt = &List<T>::_vptr_elementAt;
    map = &List<T>::_vptr_map;
    expand = &List<T>::_vptr_expand;
    cast_ = &List<T>::_vptr_cast_;
    fold = &List<T>::_vptr_fold;
    whereType = &List<T>::_vptr_whereType;
}

template<typename T>
inline constexpr ListClassInfo<T> List<T>::_classInfo{};

// ── Array<T>::Array(List<T>*) 实现（需要 List 完整定义） ──

template<typename T>
Array<T>::Array(List<T>* list) {
    AnyGC::_classInfo = &_classInfo;
    if (list) {
        _storage.reserve(list->_data->_storage.size());
        for (int i = 0; i < list->_data->_storage.size(); i++) {
            _storage.push_back(list->_data->_storage[i]);
        }
    }
}

// ── MapEntry<K,V> ──

// ── MapEntry<K,V> — AnyGC 子类（指针语义），方法抽象进 ClassInfo ──

template<typename K, typename V>
struct MapEntryClassInfo;

template<typename K, typename V>
struct MapEntry : AnyGC {
    K key;
    V value;
    static const MapEntryClassInfo<K, V> _classInfo;

    MapEntry() : key(), value() { AnyGC::_classInfo = &_classInfo; }
    MapEntry(K k, V v) : key(std::move(k)), value(std::move(v)) { AnyGC::_classInfo = &_classInfo; }

    // ── ClassInfo dispatch ──
    static AnyGC* _vptr_toString(AnyGC* self) {
        auto* e = static_cast<MapEntry*>(self);
        return _box(_anyToString(_boxElem<K>(e->key)) + string(": ") + _anyToString(_boxElem<V>(e->value)));
    }
    static AnyGC* _vptr_runtimeType(AnyGC*) { return _box(string("MapEntry")); }
    static bool _vptr_eq(AnyGC* self, AnyGC* other) {
        auto* a = static_cast<MapEntry*>(self);
        auto* b = static_cast<MapEntry*>(other);
        // 指针成员按身份比较（对齐 Dart Object.== 默认语义），值成员按值比较
        return a->key == b->key && a->value == b->value;
    }
    static int64_t _vptr_hashCode(AnyGC* self) {
        // 身份哈希（对齐 Dart 默认 hashCode）
        return static_cast<int64_t>(reinterpret_cast<uintptr_t>(self) >> 4);
    }
    static AnyGC* _vptr_get_key(AnyGC* self) { return _boxElem<K>(static_cast<MapEntry*>(self)->key); }
    static AnyGC* _vptr_get_value(AnyGC* self) { return _boxElem<V>(static_cast<MapEntry*>(self)->value); }
    static void _gcMark_impl(AnyGC* self, int flag) {
        auto* e = static_cast<MapEntry*>(self);
        if constexpr (std::is_pointer_v<K>) {
            if constexpr (std::is_base_of_v<AnyGC, std::remove_pointer_t<K>>) { if (e->key) _gcMark(e->key, flag); }
        }
        if constexpr (std::is_pointer_v<V>) {
            if constexpr (std::is_base_of_v<AnyGC, std::remove_pointer_t<V>>) { if (e->value) _gcMark(e->value, flag); }
        }
    }
};

template<typename K, typename V>
struct MapEntryClassInfo : ClassInfo {
    constexpr MapEntryClassInfo() {
        typeName = "MapEntry";
        destroy = &_gcDestroy<MapEntry<K, V>>;
        gcMark = &MapEntry<K, V>::_gcMark_impl;
        toString = &MapEntry<K, V>::_vptr_toString;
        get_runtimeType = &MapEntry<K, V>::_vptr_runtimeType;
        eq = &MapEntry<K, V>::_vptr_eq;
        get_hashCode = &MapEntry<K, V>::_vptr_hashCode;
        get_key = &MapEntry<K, V>::_vptr_get_key;
        get_value = &MapEntry<K, V>::_vptr_get_value;
    }
};

template<typename K, typename V>
inline constexpr MapEntryClassInfo<K, V> MapEntry<K, V>::_classInfo{};

// ── Map<K,V> ──
// 对齐 Dart _collections.dart Map<K,V>

template<typename K, typename V>
struct Map : AnyGC {
    Array<K>* _keys;
    Array<V>* _values;
    static const MapClassInfo<K, V> _classInfo;

    Map()
        : _keys(GC::allocateLocal(new Array<K>())),
          _values(GC::allocateLocal(new Array<V>())) { AnyGC::_classInfo = &Map::_classInfo; }

    static Map* empty() {
        return GC::allocateLocal(new Map());
    }

    /// 对齐 Dart: Map.of(source) — 从已有 map 复制
    static Map* of(Map<K, V>* source) {
        auto* result = GC::allocateLocal(new Map());
        if (source) {
            int n = source->_keys->_storage.size();
            result->_keys->_storage.reserve(n);
            result->_values->_storage.reserve(n);
            for (int i = 0; i < n; i++) {
                result->_keys->_storage.push_back(source->_keys->_storage[i]);
                result->_values->_storage.push_back(source->_values->_storage[i]);
            }
        }
        return result;
    }

    /// 对齐 Dart: Map.from(source) — 从已有 map 复制（允许类型转换）
    static Map* from(Map<K, V>* source) {
        return of(source);
    }

    /// Map.from with different source value type (e.g., AnyGC* → int64_t)
    template<typename SK, typename SV>
    static Map* from(Map<SK, SV>* source) {
        auto* result = GC::allocateLocal(new Map());
        if (source) {
            int n = source->_keys->_storage.size();
            result->_keys->_storage.reserve(n);
            result->_values->_storage.reserve(n);
            for (int i = 0; i < n; i++) {
                auto& k = source->_keys->_storage[i];
                auto& v = source->_values->_storage[i];
                // Convert key
                K ck;
                if constexpr (std::is_same_v<K, SK>) { ck = k; }
                else if constexpr (std::is_pointer_v<K> && std::is_pointer_v<SK>) { ck = static_cast<K>(k); }
                else if constexpr (std::is_same_v<K, string> && std::is_pointer_v<SK>) { ck = dynAs<string>(k); }
                else { ck = static_cast<K>(k); }
                // Convert value
                V cv;
                if constexpr (std::is_same_v<V, SV>) { cv = v; }
                else if constexpr (std::is_pointer_v<V> && std::is_pointer_v<SV>) { cv = static_cast<V>(v); }
                else if constexpr (std::is_same_v<V, int64_t> && std::is_pointer_v<SV>) { cv = dynAs<int64_t>(v); }
                else if constexpr (std::is_same_v<V, double> && std::is_pointer_v<SV>) { cv = dynAs<double>(v); }
                else if constexpr (std::is_same_v<V, bool> && std::is_pointer_v<SV>) { cv = dynAs<bool>(v); }
                else if constexpr (std::is_same_v<V, string> && std::is_pointer_v<SV>) { cv = dynAs<string>(v); }
                else if constexpr (std::is_pointer_v<V> && std::is_same_v<SV, int64_t>) { cv = static_cast<V>(GC::allocateLocal(new IntBox(v))); }
                else { cv = static_cast<V>(v); }
                result->_keys->_storage.push_back(ck);
                result->_values->_storage.push_back(cv);
            }
        }
        return result;
    }

    /// 对齐 Dart: Map.fromEntries(entries)
    static Map* fromEntries(List<MapEntry<K, V>*>* entries) {
        auto* result = GC::allocateLocal(new Map());
        if (entries) {
            int n = entries->_data->_storage.size();
            result->_keys->_storage.reserve(n);
            result->_values->_storage.reserve(n);
            for (int i = 0; i < n; i++) {
                auto* e = entries->_data->_storage[i];
                if (!e) continue;
                result->_keys->_storage.push_back(e->key);
                result->_values->_storage.push_back(e->value);
            }
        }
        return result;
    }

    /// 对齐 Dart: Map.unmodifiable(source) — 语义上等同 of（C++ 不强制不可变）
    static Map* unmodifiable(Map<K, V>* source) {
        return of(source);
    }

    /// 对齐 Dart: Map.fromIterables(keys, values)
    static Map* fromIterables(List<K>* keys, List<V>* values) {
        auto* result = GC::allocateLocal(new Map());
        if (keys && values) {
            int len = std::min(keys->_data->_storage.size(), values->_data->_storage.size());
            result->_keys->_storage.reserve(len);
            result->_values->_storage.reserve(len);
            for (int i = 0; i < len; i++) {
                result->_keys->_storage.push_back(keys->_data->_storage[i]);
                result->_values->_storage.push_back(values->_data->_storage[i]);
            }
        }
        return result;
    }

    // ── ClassInfo dispatch support ──
    void set(K key, V val) {
        int idx = array_indexOf(_keys, key);
        if (idx != -1) {
            _values->_storage[idx] = val;
        } else {
            _keys->_storage.push_back(key);
            _values->_storage.push_back(val);
        }
    }
    static AnyGC* _vptr_runtimeType(AnyGC*) {
        return _box(string("Map"));
    }
    static int64_t _vptr_length(AnyGC* self) {
        return static_cast<int64_t>(static_cast<Map*>(self)->_keys->_storage.size());
    }
    static AnyGC* _vptr_toString(AnyGC* self) {
        auto* map = static_cast<Map*>(self);
        if (map->_keys->_storage.size() == 0) return _box(string("{}"));
        string result = "{";
        for (int i = 0; i < map->_keys->_storage.size(); i++) {
            if (i > 0) result += ", ";
            result += dart_str(map->_keys->_storage[i]) + ": " + dart_str(map->_values->_storage[i]);
        }
        result += "}";
        return _box(result);
    }
    static bool _vptr_eq(AnyGC* self, AnyGC* other) {
        return self == other;
    }
    static int64_t _vptr_hashCode(AnyGC* self) {
        return static_cast<int64_t>(reinterpret_cast<intptr_t>(self));
    }
    static AnyGC* _vptr_index(AnyGC* self, AnyGC* key) {
        auto* map = static_cast<Map*>(self);
        K k = _unboxElem<K>(key);
        int idx = array_indexOf(map->_keys, k);
        if (idx == -1) return nullptr;
        return _boxElem<V>(map->_values->_storage[idx]);
    }
    static void _vptr_setIndex(AnyGC* self, AnyGC* key, AnyGC* val) {
        auto* map = static_cast<Map*>(self);
        K k = _unboxElem<K>(key);
        V v = _unboxElem<V>(val);
        int idx = array_indexOf(map->_keys, k);
        if (idx != -1) {
            map->_values->_storage[idx] = v;
        } else {
            map->_keys->_storage.push_back(k);
            map->_values->_storage.push_back(v);
        }
    }
    static bool _vptr_containsKey(AnyGC* self, AnyGC* key) {
        return array_indexOf(static_cast<Map*>(self)->_keys, _unboxElem<K>(key)) != -1;
    }
    // Map-specific getters
    static bool _vptr_isEmpty(AnyGC* self) {
        return static_cast<Map*>(self)->_keys->_storage.size() == 0;
    }
    static bool _vptr_isNotEmpty(AnyGC* self) {
        return static_cast<Map*>(self)->_keys->_storage.size() > 0;
    }
    static AnyGC* _vptr_keys(AnyGC* self) {
        auto* map = static_cast<Map*>(self);
        auto* result = GC::allocateLocal(new List<K>());
        result->_data->_storage.reserve(map->_keys->_storage.size());
        for (int i = 0; i < map->_keys->_storage.size(); i++) result->_data->_storage.push_back(map->_keys->_storage[i]);
        return static_cast<AnyGC*>(result);
    }
    static AnyGC* _vptr_values(AnyGC* self) {
        auto* map = static_cast<Map*>(self);
        auto* result = GC::allocateLocal(new List<V>());
        result->_data->_storage.reserve(map->_values->_storage.size());
        for (int i = 0; i < map->_values->_storage.size(); i++) result->_data->_storage.push_back(map->_values->_storage[i]);
        return static_cast<AnyGC*>(result);
    }
    static AnyGC* _vptr_entries(AnyGC* self) {
        auto* map = static_cast<Map*>(self);
        auto* result = new List<MapEntry<K, V>*>();
        result->_data->_storage.reserve(map->_keys->_storage.size());
        for (int i = 0; i < map->_keys->_storage.size(); i++) {
            result->_data->_storage.push_back(GC::allocateLocal(new MapEntry<K, V>(map->_keys->_storage[i], map->_values->_storage[i])));
        }
        return static_cast<AnyGC*>(GC::allocateLocal(result));
    }
    // Map-specific methods
    static AnyGC* _vptr_remove(AnyGC* self, AnyGC* key) {
        auto* map = static_cast<Map*>(self);
        K k = _unboxElem<K>(key);
        int idx = array_indexOf(map->_keys, k);
        if (idx == -1) return _boxElem<V>(V());
        array_removeAt(map->_keys, idx);
        return _boxElem<V>(array_removeAt(map->_values, idx));
    }
    static bool _vptr_containsValue(AnyGC* self, AnyGC* val) {
        if constexpr (_isEqualityComparable<V>::value) {
            return array_indexOf(static_cast<Map*>(self)->_values, _unboxElem<V>(val)) != -1;
        } else {
            return false;
        }
    }
    static void _vptr_forEach(AnyGC* self, AnyGC* action) {
        auto* map = static_cast<Map*>(self);
        auto* tf = static_cast<TypeFunction2<void, K, V>*>(action);
        for (int i = 0; i < map->_keys->_storage.size(); i++) tf->fnPtr(tf, _boxElem<K>(map->_keys->_storage[i]), _boxElem<V>(map->_values->_storage[i]));
    }
    static void _vptr_clear(AnyGC* self) {
        auto* map = static_cast<Map*>(self);
        map->_keys->_storage.clear();
        map->_values->_storage.clear();
    }
    static AnyGC* _vptr_putIfAbsent(AnyGC* self, AnyGC* key, AnyGC* ifAbsent) {
        auto* map = static_cast<Map*>(self);
        K k = _unboxElem<K>(key);
        int idx = array_indexOf(map->_keys, k);
        if (idx != -1) return _boxElem<V>(map->_values->_storage[idx]);
        AnyGC* boxed = static_cast<TypeFunction0<V>*>(ifAbsent)->fnPtr(ifAbsent);
        map->_keys->_storage.push_back(k);
        map->_values->_storage.push_back(_unboxElem<V>(boxed));
        return boxed;
    }
    static AnyGC* _vptr_update(AnyGC* self, AnyGC* key, AnyGC* updateFn, AnyGC* ifAbsent) {
        auto* map = static_cast<Map*>(self);
        K k = _unboxElem<K>(key);
        int idx = array_indexOf(map->_keys, k);
        if (idx != -1) {
            AnyGC* boxed = static_cast<TypeFunction1<V, V>*>(updateFn)->fnPtr(updateFn, _boxElem<V>(map->_values->_storage[idx]));
            map->_values->_storage[idx] = _unboxElem<V>(boxed);
            return boxed;
        }
        if (ifAbsent) {
            AnyGC* boxed = static_cast<TypeFunction0<V>*>(ifAbsent)->fnPtr(ifAbsent);
            map->_keys->_storage.push_back(k);
            map->_values->_storage.push_back(_unboxElem<V>(boxed));
            return boxed;
        }
        throw DartArgumentError("Key not found");
    }
    static void _vptr_updateAll(AnyGC* self, AnyGC* updateFn) {
        auto* map = static_cast<Map*>(self);
        auto* tf = static_cast<TypeFunction2<V, K, V>*>(updateFn);
        for (int i = 0; i < map->_keys->_storage.size(); i++) {
            map->_values->_storage[i] = _unboxElem<V>(tf->fnPtr(tf, _boxElem<K>(map->_keys->_storage[i]), _boxElem<V>(map->_values->_storage[i])));
        }
    }
    static void _vptr_addAll(AnyGC* self, AnyGC* other) {
        auto* map = static_cast<Map*>(self);
        auto* o = static_cast<Map*>(other);
        if (!o) return;
        map->_keys->_storage.reserve(map->_keys->_storage.size() + o->_keys->_storage.size());
        map->_values->_storage.reserve(map->_values->_storage.size() + o->_values->_storage.size());
        for (int i = 0; i < o->_keys->_storage.size(); i++) {
            K k = o->_keys->_storage[i];
            V v = o->_values->_storage[i];
            int idx = array_indexOf(map->_keys, k);
            if (idx != -1) {
                map->_values->_storage[idx] = v;
            } else {
                map->_keys->_storage.push_back(k);
                map->_values->_storage.push_back(v);
            }
        }
    }
    static void _vptr_addEntries(AnyGC* self, AnyGC* newEntries) {
        auto* map = static_cast<Map*>(self);
        auto* entries = static_cast<List<MapEntry<K, V>*>*>(newEntries);
        if (!entries) return;
        int n = entries->_data->_storage.size();
        map->_keys->_storage.reserve(map->_keys->_storage.size() + n);
        map->_values->_storage.reserve(map->_values->_storage.size() + n);
        for (int i = 0; i < n; i++) {
            auto* e = entries->_data->_storage[i];
            if (!e) continue;
            int idx = array_indexOf(map->_keys, e->key);
            if (idx != -1) {
                map->_values->_storage[idx] = e->value;
            } else {
                map->_keys->_storage.push_back(e->key);
                map->_values->_storage.push_back(e->value);
            }
        }
    }
    static void _vptr_removeWhere(AnyGC* self, AnyGC* test) {
        auto* map = static_cast<Map*>(self);
        auto* tf = static_cast<TypeFunction2<bool, K, V>*>(test);
        for (int i = map->_keys->_storage.size() - 1; i >= 0; i--) {
            if (dynAs<bool>(tf->fnPtr(tf, _boxElem<K>(map->_keys->_storage[i]), _boxElem<V>(map->_values->_storage[i])))) {
                array_removeAt(map->_keys, i);
                array_removeAt(map->_values, i);
            }
        }
    }
    static AnyGC* _vptr_map(AnyGC* self, AnyGC* func) {
        auto* map = static_cast<Map*>(self);
        auto* tf = static_cast<TypeFunction2<AnyGC*, K, V>*>(func);
        auto* result = new Map<AnyGC*, AnyGC*>();
        int n = map->_keys->_storage.size();
        result->_keys->_storage.reserve(n);
        result->_values->_storage.reserve(n);
        for (int i = 0; i < n; i++) {
            AnyGC* entryObj = tf->fnPtr(tf, _boxElem(map->_keys->_storage[i]), _boxElem(map->_values->_storage[i]));
            // 经 ClassInfo get_key/get_value 派发：闭包返回的 MapEntry<K2,V2> 模板参数
            // 与目标 map 的 AnyGC* 不同，不能直接 static_cast 模板实例
            if (!entryObj || !entryObj->_classInfo || !entryObj->_classInfo->get_key) continue;
            AnyGC* ek = entryObj->_classInfo->get_key(entryObj);
            AnyGC* ev = entryObj->_classInfo->get_value(entryObj);
            int idx = array_indexOf(result->_keys, ek);
            if (idx != -1) {
                result->_values->_storage[idx] = ev;
            } else {
                result->_keys->_storage.push_back(ek);
                result->_values->_storage.push_back(ev);
            }
        }
        return static_cast<AnyGC*>(GC::allocateLocal(result));
    }
    static AnyGC* _vptr_cast_(AnyGC* self) {
        auto* map = static_cast<Map*>(self);
        auto* result = new Map<AnyGC*, AnyGC*>();
        int n = map->_keys->_storage.size();
        result->_keys->_storage.reserve(n);
        result->_values->_storage.reserve(n);
        for (int i = 0; i < n; i++) {
            auto k = _boxElem<K>(map->_keys->_storage[i]);
            auto v = _boxElem<V>(map->_values->_storage[i]);
            int idx = array_indexOf(result->_keys, k);
            if (idx != -1) {
                result->_values->_storage[idx] = v;
            } else {
                result->_keys->_storage.push_back(k);
                result->_values->_storage.push_back(v);
            }
        }
        return GC::allocateLocal(result);
    }

    // ── GC ──

    static void _gcMark_impl(AnyGC* self, int flag) {
        auto* map = static_cast<Map*>(self);
        if (map->_keys) _gcMark(map->_keys, flag);
        if (map->_values) _gcMark(map->_values, flag);
    }
};

template<typename K, typename V>
constexpr MapClassInfo<K, V>::MapClassInfo() {
    typeName = "Map";
    destroy = &_gcDestroy<Map<K, V>>;
    // Base ClassInfo fields
    toString = &Map<K, V>::_vptr_toString;
    get_runtimeType = &Map<K, V>::_vptr_runtimeType;
    get_length = &Map<K, V>::_vptr_length;
    eq = &Map<K, V>::_vptr_eq;
    get_hashCode = &Map<K, V>::_vptr_hashCode;
    index = &Map<K, V>::_vptr_index;
    setIndex = &Map<K, V>::_vptr_setIndex;
    containsKey = &Map<K, V>::_vptr_containsKey;
    gcMark = &Map<K, V>::_gcMark_impl;
    // Map-specific fields
    get_isEmpty = &Map<K, V>::_vptr_isEmpty;
    get_isNotEmpty = &Map<K, V>::_vptr_isNotEmpty;
    get_keys = &Map<K, V>::_vptr_keys;
    get_values = &Map<K, V>::_vptr_values;
    get_entries = &Map<K, V>::_vptr_entries;
    put = &Map<K, V>::_vptr_setIndex;
    remove = &Map<K, V>::_vptr_remove;
    containsValue = &Map<K, V>::_vptr_containsValue;
    forEach = &Map<K, V>::_vptr_forEach;
    clear = &Map<K, V>::_vptr_clear;
    putIfAbsent = &Map<K, V>::_vptr_putIfAbsent;
    update = &Map<K, V>::_vptr_update;
    updateAll = &Map<K, V>::_vptr_updateAll;
    addAll = &Map<K, V>::_vptr_addAll;
    addEntries = &Map<K, V>::_vptr_addEntries;
    removeWhere = &Map<K, V>::_vptr_removeWhere;
    map = &Map<K, V>::_vptr_map;
    cast_ = &Map<K, V>::_vptr_cast_;
}

template<typename K, typename V>
inline constexpr MapClassInfo<K, V> Map<K, V>::_classInfo{};

// ── Set<T> ──
// 对齐 Dart _collections.dart Set<T>

template<typename T>
struct Set : AnyGC {
    static const SetClassInfo<T> _classInfo;
    Array<T>* _data;

    Set() : _data(GC::allocateLocal(new Array<T>())) { AnyGC::_classInfo = &_classInfo; }

    Set(std::initializer_list<T> init)
        : _data(GC::allocateLocal(new Array<T>())) {
        AnyGC::_classInfo = &_classInfo;
        _data->_storage.reserve(static_cast<int>(init.size()));
        for (const auto& e : init) {
            if (!array_contains(_data, e)) _data->_storage.push_back(e);
        }
    }

    static Set* of(std::initializer_list<T> elements) {
        return GC::allocateLocal(new Set(elements));
    }

    static Set* empty() {
        return GC::allocateLocal(new Set());
    }

    /// 对齐 Dart: Set.from(iterable)
    static Set* from(List<T>* source) {
        auto* result = GC::allocateLocal(new Set());
        if (source) {
            result->_data->_storage.reserve(source->_data->_storage.size());
            for (int i = 0; i < source->_data->_storage.size(); i++) {
                auto& elem = source->_data->_storage[i];
                if (!array_contains(result->_data, elem)) result->_data->_storage.push_back(elem);
            }
        }
        return result;
    }

    /// 对齐 Dart: Set.unmodifiable(source) — 语义等同 from
    static Set* unmodifiable(Set<T>* source) {
        auto* result = GC::allocateLocal(new Set());
        if (source) {
            result->_data->_storage.reserve(source->_data->_storage.size());
            for (int i = 0; i < source->_data->_storage.size(); i++) {
                result->_data->_storage.push_back(source->_data->_storage[i]);
            }
        }
        return result;
    }

    // ── vptrSet support ──
    static AnyGC* _vptr_runtimeType(AnyGC*) {
        return _box(string("Set"));
    }
    static int64_t _vptr_length(AnyGC* self) {
        return static_cast<int64_t>(static_cast<Set*>(self)->_data->_storage.size());
    }
    static AnyGC* _vptr_toString(AnyGC* self) {
        auto* set = static_cast<Set*>(self);
        string result = "{";
        for (int i = 0; i < set->_data->_storage.size(); i++) {
            if (i > 0) result += ", ";
            result += dart_str(set->_data->_storage[i]);
        }
        result += "}";
        return _box(result);
    }
    static bool _vptr_eq(AnyGC* self, AnyGC* other) {
        return self == other;
    }
    static int64_t _vptr_hashCode(AnyGC* self) {
        return static_cast<int64_t>(reinterpret_cast<intptr_t>(self));
    }
    static bool _vptr_contains(AnyGC* self, AnyGC* element) {
        if constexpr (_isEqualityComparable<T>::value) {
            return array_contains(static_cast<Set*>(self)->_data, _unboxElem<T>(element));
        } else {
            return false;
        }
    }
    // Set-specific getters
    static bool _vptr_isEmpty(AnyGC* self) {
        return static_cast<Set*>(self)->_data->_storage.size() == 0;
    }
    static bool _vptr_isNotEmpty(AnyGC* self) {
        return static_cast<Set*>(self)->_data->_storage.size() > 0;
    }
    static AnyGC* _vptr_first(AnyGC* self) {
        auto* set = static_cast<Set*>(self);
        if (set->_data->_storage.size() == 0) throw DartStateError("No element");
        return _boxElem<T>(set->_data->_storage[0]);
    }
    static AnyGC* _vptr_last(AnyGC* self) {
        auto* set = static_cast<Set*>(self);
        if (set->_data->_storage.size() == 0) throw DartStateError("No element");
        return _boxElem<T>(set->_data->_storage[set->_data->_storage.size() - 1]);
    }
    static AnyGC* _vptr_single(AnyGC* self) {
        auto* set = static_cast<Set*>(self);
        if (set->_data->_storage.size() != 1) throw DartStateError("Not single element");
        return _boxElem<T>(set->_data->_storage[0]);
    }
    static AnyGC* _vptr_iterator(AnyGC* self) {
        return static_cast<AnyGC*>(GC::allocateLocal(new Iterator<T>(static_cast<Set*>(self)->_data)));
    }
    // Set-specific methods
    static bool _vptr_add(AnyGC* self, AnyGC* element) {
        if constexpr (_isEqualityComparable<T>::value) {
            auto* set = static_cast<Set*>(self);
            T elem = _unboxElem<T>(element);
            if (array_contains(set->_data, elem)) return false;
            set->_data->_storage.push_back(elem);
            return true;
        } else {
            return false;
        }
    }
    static void _vptr_addAll(AnyGC* self, AnyGC* other) {
        if constexpr (_isEqualityComparable<T>::value) {
            auto* set = static_cast<Set*>(self);
            auto* o = static_cast<Set*>(other);
            if (!o) return;
            set->_data->_storage.reserve(set->_data->_storage.size() + o->_data->_storage.size());
            for (int i = 0; i < o->_data->_storage.size(); i++) {
                auto& elem = o->_data->_storage[i];
                if (!array_contains(set->_data, elem)) set->_data->_storage.push_back(elem);
            }
        }
    }
    static bool _vptr_remove(AnyGC* self, AnyGC* element) {
        if constexpr (_isEqualityComparable<T>::value) {
            auto* set = static_cast<Set*>(self);
            int idx = array_indexOf(set->_data, _unboxElem<T>(element));
            if (idx == -1) return false;
            array_removeAt(set->_data, idx);
            return true;
        } else {
            return false;
        }
    }
    static bool _vptr_containsAll(AnyGC* self, AnyGC* other) {
        if constexpr (_isEqualityComparable<T>::value) {
            auto* set = static_cast<Set*>(self);
            auto* o = static_cast<List<T>*>(other);
            if (!o) return false;
            for (const T& elem : o->_data->_storage) {
                if (!array_contains(set->_data, elem)) return false;
            }
            return true;
        } else {
            return false;
        }
    }
    static void _vptr_removeWhere(AnyGC* self, AnyGC* test) {
        auto* set = static_cast<Set*>(self);
        auto* tf = static_cast<TypeFunction1<bool, T>*>(test);
        for (int i = set->_data->_storage.size() - 1; i >= 0; i--) {
            if (_predApply(tf, set->_data->_storage[i])) array_removeAt(set->_data, i);
        }
    }
    static void _vptr_retainWhere(AnyGC* self, AnyGC* test) {
        auto* set = static_cast<Set*>(self);
        auto* tf = static_cast<TypeFunction1<bool, T>*>(test);
        for (int i = set->_data->_storage.size() - 1; i >= 0; i--) {
            if (!_predApply(tf, set->_data->_storage[i])) array_removeAt(set->_data, i);
        }
    }
    static void _vptr_clear(AnyGC* self) {
        static_cast<Set*>(self)->_data->_storage.clear();
    }
    static AnyGC* _vptr_lookup(AnyGC* self, AnyGC* element) {
        if constexpr (_isEqualityComparable<T>::value) {
            auto* set = static_cast<Set*>(self);
            int idx = array_indexOf(set->_data, _unboxElem<T>(element));
            if (idx == -1) return nullptr;
            return _boxElem<T>(set->_data->_storage[idx]);
        } else {
            return nullptr;
        }
    }
    static void _vptr_forEach(AnyGC* self, AnyGC* action) {
        auto* set = static_cast<Set*>(self);
        auto* tf = static_cast<TypeFunction1<void, T>*>(action);
        for (int i = 0; i < set->_data->_storage.size(); i++) tf->fnPtr(tf, _boxElem<T>(set->_data->_storage[i]));
    }
    static AnyGC* _vptr_where(AnyGC* self, AnyGC* test) {
        if constexpr (_isEqualityComparable<T>::value) {
            auto* set = static_cast<Set*>(self);
            auto* tf = static_cast<TypeFunction1<bool, T>*>(test);
            auto* result = new Set<T>();
            result->_data->_storage.reserve(set->_data->_storage.size());
            for (int i = 0; i < set->_data->_storage.size(); i++) {
                if (_predApply(tf, set->_data->_storage[i])) {
                    result->_data->_storage.push_back(set->_data->_storage[i]);
                }
            }
            return static_cast<AnyGC*>(GC::allocateLocal(result));
        } else {
            return static_cast<AnyGC*>(GC::allocateLocal(new Set()));
        }
    }
    static bool _vptr_any_(AnyGC* self, AnyGC* test) {
        auto* set = static_cast<Set*>(self);
        auto* tf = static_cast<TypeFunction1<bool, T>*>(test);
        for (int i = 0; i < set->_data->_storage.size(); i++) {
            if (_predApply(tf, set->_data->_storage[i])) return true;
        }
        return false;
    }
    static bool _vptr_every_(AnyGC* self, AnyGC* test) {
        auto* set = static_cast<Set*>(self);
        auto* tf = static_cast<TypeFunction1<bool, T>*>(test);
        for (int i = 0; i < set->_data->_storage.size(); i++) {
            if (!_predApply(tf, set->_data->_storage[i])) return false;
        }
        return true;
    }
    static AnyGC* _vptr_firstWhere(AnyGC* self, AnyGC* test, AnyGC* orElse) {
        auto* set = static_cast<Set*>(self);
        auto* tf = static_cast<TypeFunction1<bool, T>*>(test);
        for (int i = 0; i < set->_data->_storage.size(); i++) {
            if (_predApply(tf, set->_data->_storage[i])) return _boxElem<T>(set->_data->_storage[i]);
        }
        if (orElse) {
            auto* of = static_cast<TypeFunction0<T>*>(orElse);
            return of->fnPtr(of);
        }
        throw DartStateError("No element");
    }
    static AnyGC* _vptr_lastWhere(AnyGC* self, AnyGC* test, AnyGC* orElse) {
        auto* set = static_cast<Set*>(self);
        auto* tf = static_cast<TypeFunction1<bool, T>*>(test);
        for (int i = set->_data->_storage.size() - 1; i >= 0; i--) {
            if (_predApply(tf, set->_data->_storage[i])) return _boxElem<T>(set->_data->_storage[i]);
        }
        if (orElse) {
            auto* of = static_cast<TypeFunction0<T>*>(orElse);
            return of->fnPtr(of);
        }
        throw DartStateError("No element");
    }
    static AnyGC* _vptr_singleWhere(AnyGC* self, AnyGC* test, AnyGC* orElse) {
        auto* set = static_cast<Set*>(self);
        auto* tf = static_cast<TypeFunction1<bool, T>*>(test);
        bool foundMultiple = false;
        T found{};
        bool hasFound = false;
        for (int i = 0; i < set->_data->_storage.size(); i++) {
            if (_predApply(tf, set->_data->_storage[i])) {
                if (hasFound) { foundMultiple = true; break; }
                found = set->_data->_storage[i];
                hasFound = true;
            }
        }
        if (foundMultiple) throw DartStateError("Too many elements");
        if (hasFound) return _boxElem<T>(found);
        if (orElse) {
            auto* of = static_cast<TypeFunction0<T>*>(orElse);
            return of->fnPtr(of);
        }
        throw DartStateError("No element");
    }
    static AnyGC* _vptr_reduce(AnyGC* self, AnyGC* combine) {
        auto* set = static_cast<Set*>(self);
        if (set->_data->_storage.size() == 0) throw DartStateError("No element");
        auto* cmp = static_cast<TypeFunction2<T, T, T>*>(combine);
        T value = set->_data->_storage[0];
        for (int i = 1; i < set->_data->_storage.size(); i++) value = _unboxElem<T>(cmp->fnPtr(cmp, _boxElem<T>(value), _boxElem<T>(set->_data->_storage[i])));
        return _boxElem<T>(value);
    }
    static AnyGC* _vptr_unionSet(AnyGC* self, AnyGC* other) {
        if constexpr (_isEqualityComparable<T>::value) {
            auto* set = static_cast<Set*>(self);
            auto* o = static_cast<Set*>(other);
            auto* result = new Set<T>();
            int total = set->_data->_storage.size() + (o ? o->_data->_storage.size() : 0);
            result->_data->_storage.reserve(total);
            for (int i = 0; i < set->_data->_storage.size(); i++) {
                result->_data->_storage.push_back(set->_data->_storage[i]);
            }
            if (o) {
                for (int i = 0; i < o->_data->_storage.size(); i++) {
                    auto& elem = o->_data->_storage[i];
                    if (!array_contains(result->_data, elem)) result->_data->_storage.push_back(elem);
                }
            }
            return static_cast<AnyGC*>(GC::allocateLocal(result));
        } else {
            return static_cast<AnyGC*>(static_cast<Set*>(self));
        }
    }
    static AnyGC* _vptr_intersection(AnyGC* self, AnyGC* other) {
        if constexpr (_isEqualityComparable<T>::value) {
            auto* set = static_cast<Set*>(self);
            auto* result = new Set<T>();
            auto* o = static_cast<Set*>(other);
            if (!o) return static_cast<AnyGC*>(GC::allocateLocal(result));
            result->_data->_storage.reserve(set->_data->_storage.size());
            for (int i = 0; i < set->_data->_storage.size(); i++) {
                if (array_contains(o->_data, set->_data->_storage[i])) {
                    result->_data->_storage.push_back(set->_data->_storage[i]);
                }
            }
            return static_cast<AnyGC*>(GC::allocateLocal(result));
        } else {
            return static_cast<AnyGC*>(GC::allocateLocal(new Set()));
        }
    }
    static AnyGC* _vptr_difference(AnyGC* self, AnyGC* other) {
        if constexpr (_isEqualityComparable<T>::value) {
            auto* set = static_cast<Set*>(self);
            auto* result = new Set<T>();
            auto* o = static_cast<Set*>(other);
            result->_data->_storage.reserve(set->_data->_storage.size());
            for (int i = 0; i < set->_data->_storage.size(); i++) {
                if (!o || !array_contains(o->_data, set->_data->_storage[i])) {
                    result->_data->_storage.push_back(set->_data->_storage[i]);
                }
            }
            return static_cast<AnyGC*>(GC::allocateLocal(result));
        } else {
            return static_cast<AnyGC*>(GC::allocateLocal(new Set()));
        }
    }
    static AnyGC* _vptr_toList(AnyGC* self) {
        auto* set = static_cast<Set*>(self);
        auto* result = new List<T>();
        result->_data->_storage.reserve(set->_data->_storage.size());
        for (int i = 0; i < set->_data->_storage.size(); i++) result->_data->_storage.push_back(set->_data->_storage[i]);
        return static_cast<AnyGC*>(GC::allocateLocal(result));
    }
    static AnyGC* _vptr_toSet(AnyGC* self) {
        if constexpr (_isEqualityComparable<T>::value) {
            auto* set = static_cast<Set*>(self);
            auto* result = new Set<T>();
            result->_data->_storage.reserve(set->_data->_storage.size());
            for (int i = 0; i < set->_data->_storage.size(); i++) {
                result->_data->_storage.push_back(set->_data->_storage[i]);
            }
            return static_cast<AnyGC*>(GC::allocateLocal(result));
        } else {
            return static_cast<AnyGC*>(GC::allocateLocal(new Set()));
        }
    }
    static AnyGC* _vptr_followedBy(AnyGC* self, AnyGC* other) {
        if constexpr (_isEqualityComparable<T>::value) {
            return _vptr_unionSet(self, other);
        } else {
            return static_cast<AnyGC*>(static_cast<Set*>(self));
        }
    }
    static AnyGC* _vptr_take(AnyGC* self, AnyGC* count) {
        if constexpr (_isEqualityComparable<T>::value) {
            auto* set = static_cast<Set*>(self);
            int64_t n = dynAs<int64_t>(count);
            auto* result = new Set<T>();
            int end = static_cast<int>(n) < set->_data->_storage.size() ? static_cast<int>(n) : set->_data->_storage.size();
            result->_data->_storage.reserve(end);
            for (int i = 0; i < end; i++) {
                result->_data->_storage.push_back(set->_data->_storage[i]);
            }
            return static_cast<AnyGC*>(GC::allocateLocal(result));
        } else {
            return static_cast<AnyGC*>(GC::allocateLocal(new Set()));
        }
    }
    static AnyGC* _vptr_skip(AnyGC* self, AnyGC* count) {
        if constexpr (_isEqualityComparable<T>::value) {
            auto* set = static_cast<Set*>(self);
            int64_t n = dynAs<int64_t>(count);
            auto* result = new Set<T>();
            result->_data->_storage.reserve(set->_data->_storage.size() - static_cast<int>(n));
            for (int i = static_cast<int>(n); i < set->_data->_storage.size(); i++) {
                result->_data->_storage.push_back(set->_data->_storage[i]);
            }
            return static_cast<AnyGC*>(GC::allocateLocal(result));
        } else {
            return static_cast<AnyGC*>(GC::allocateLocal(new Set()));
        }
    }
    static AnyGC* _vptr_takeWhile(AnyGC* self, AnyGC* test) {
        if constexpr (_isEqualityComparable<T>::value) {
            auto* set = static_cast<Set*>(self);
            auto* tf = static_cast<TypeFunction1<bool, T>*>(test);
            auto* result = new Set<T>();
            result->_data->_storage.reserve(set->_data->_storage.size());
            for (int i = 0; i < set->_data->_storage.size(); i++) {
                if (!_predApply(tf, set->_data->_storage[i])) break;
                result->_data->_storage.push_back(set->_data->_storage[i]);
            }
            return static_cast<AnyGC*>(GC::allocateLocal(result));
        } else {
            return static_cast<AnyGC*>(GC::allocateLocal(new Set()));
        }
    }
    static AnyGC* _vptr_skipWhile(AnyGC* self, AnyGC* test) {
        if constexpr (_isEqualityComparable<T>::value) {
            auto* set = static_cast<Set*>(self);
            auto* tf = static_cast<TypeFunction1<bool, T>*>(test);
            auto* result = new Set<T>();
            result->_data->_storage.reserve(set->_data->_storage.size());
            bool skipping = true;
            for (int i = 0; i < set->_data->_storage.size(); i++) {
                if (skipping && _predApply(tf, set->_data->_storage[i])) continue;
                skipping = false;
                result->_data->_storage.push_back(set->_data->_storage[i]);
            }
            return static_cast<AnyGC*>(GC::allocateLocal(result));
        } else {
            return static_cast<AnyGC*>(GC::allocateLocal(new Set()));
        }
    }
    static AnyGC* _vptr_join(AnyGC* self, AnyGC* separator) {
        auto* set = static_cast<Set*>(self);
        string result;
        string sep = separator ? dynAs<string>(separator) : string();
        for (int i = 0; i < set->_data->_storage.size(); i++) {
            if (i > 0) result += sep;
            result += dart_str(set->_data->_storage[i]);
        }
        return _box(result);
    }
    static AnyGC* _vptr_elementAt(AnyGC* self, AnyGC* index) {
        auto* set = static_cast<Set*>(self);
        return _boxElem<T>(set->_data->_storage[static_cast<int>(dynAs<int64_t>(index))]);
    }
    static AnyGC* _vptr_map(AnyGC* self, AnyGC* func) {
        auto* set = static_cast<Set*>(self);
        auto* tf = static_cast<TypeFunction1<AnyGC*, T>*>(func);
        auto* result = new List<AnyGC*>();
        result->_data->_storage.reserve(set->_data->_storage.size());
        for (int i = 0; i < set->_data->_storage.size(); i++) {
            result->_data->_storage.push_back(dynAs<AnyGC*>(tf->fnPtr(tf, _boxElem(set->_data->_storage[i]))));
        }
        return static_cast<AnyGC*>(GC::allocateLocal(result));
    }
    static AnyGC* _vptr_expand(AnyGC* self, AnyGC* func) {
        auto* set = static_cast<Set*>(self);
        auto* tf = static_cast<TypeFunction1<AnyGC*, T>*>(func);
        auto* result = new List<AnyGC*>();
        result->_data->_storage.reserve(set->_data->_storage.size());
        for (int i = 0; i < set->_data->_storage.size(); i++) {
            AnyGC* inner = tf->fnPtr(tf, _boxElem(set->_data->_storage[i]));
            if (!inner) continue;
            AnyGC* it = iterator_get(inner);
            while (it && iterator_moveNext(it)) {
                result->_data->_storage.push_back(iterator_current(it));
            }
        }
        return static_cast<AnyGC*>(GC::allocateLocal(result));
    }
    static AnyGC* _vptr_cast_(AnyGC* self) {
        auto* set = static_cast<Set*>(self);
        auto* result = new Set<AnyGC*>();
        result->_data->_storage.reserve(set->_data->_storage.size());
        for (int i = 0; i < set->_data->_storage.size(); i++) {
            result->_data->_storage.push_back(_boxElem<T>(set->_data->_storage[i]));
        }
        return GC::allocateLocal(result);
    }
    static AnyGC* _vptr_fold(AnyGC* self, AnyGC* initial, AnyGC* combine) {
        auto* set = static_cast<Set*>(self);
        auto* cmp = static_cast<TypeFunction2<AnyGC*, AnyGC*, T>*>(combine);
        AnyGC* value = initial;
        for (int i = 0; i < set->_data->_storage.size(); i++) {
            value = cmp->fnPtr(cmp, value, _boxElem(set->_data->_storage[i]));
        }
        return value;
    }
    static AnyGC* _vptr_whereType(AnyGC* self) {
        auto* set = static_cast<Set*>(self);
        auto* result = new Set<AnyGC*>();
        result->_data->_storage.reserve(set->_data->_storage.size());
        for (int i = 0; i < set->_data->_storage.size(); i++) {
            if constexpr (std::is_pointer_v<T>) {
                result->_data->_storage.push_back(static_cast<AnyGC*>(set->_data->_storage[i]));
            }
        }
        return GC::allocateLocal(result);
    }

    // ── GC ──

    static void _gcMark_impl(AnyGC* self, int flag) {
        auto* set = static_cast<Set*>(self);
        if (set->_data) _gcMark(set->_data, flag);
    }
};

template<typename T>
constexpr SetClassInfo<T>::SetClassInfo() {
    typeName = "Set";
    destroy = &_gcDestroy<Set<T>>;
    // Base ClassInfo fields
    toString = &Set<T>::_vptr_toString;
    get_runtimeType = &Set<T>::_vptr_runtimeType;
    get_length = &Set<T>::_vptr_length;
    eq = &Set<T>::_vptr_eq;
    get_hashCode = &Set<T>::_vptr_hashCode;
    contains = &Set<T>::_vptr_contains;
    gcMark = &Set<T>::_gcMark_impl;
    // Set-specific fields
    get_isEmpty = &Set<T>::_vptr_isEmpty;
    get_isNotEmpty = &Set<T>::_vptr_isNotEmpty;
    get_first = &Set<T>::_vptr_first;
    get_last = &Set<T>::_vptr_last;
    get_single = &Set<T>::_vptr_single;
    get_iterator = &Set<T>::_vptr_iterator;
    add = &Set<T>::_vptr_add;
    addAll = &Set<T>::_vptr_addAll;
    remove = &Set<T>::_vptr_remove;
    containsAll = &Set<T>::_vptr_containsAll;
    removeWhere = &Set<T>::_vptr_removeWhere;
    retainWhere = &Set<T>::_vptr_retainWhere;
    clear = &Set<T>::_vptr_clear;
    lookup = &Set<T>::_vptr_lookup;
    forEach = &Set<T>::_vptr_forEach;
    where = &Set<T>::_vptr_where;
    any_ = &Set<T>::_vptr_any_;
    every_ = &Set<T>::_vptr_every_;
    firstWhere = &Set<T>::_vptr_firstWhere;
    lastWhere = &Set<T>::_vptr_lastWhere;
    singleWhere = &Set<T>::_vptr_singleWhere;
    reduce = &Set<T>::_vptr_reduce;
    unionSet = &Set<T>::_vptr_unionSet;
    intersection = &Set<T>::_vptr_intersection;
    difference = &Set<T>::_vptr_difference;
    toList = &Set<T>::_vptr_toList;
    toSet = &Set<T>::_vptr_toSet;
    followedBy = &Set<T>::_vptr_followedBy;
    take = &Set<T>::_vptr_take;
    skip = &Set<T>::_vptr_skip;
    takeWhile = &Set<T>::_vptr_takeWhile;
    skipWhile = &Set<T>::_vptr_skipWhile;
    join = &Set<T>::_vptr_join;
    elementAt = &Set<T>::_vptr_elementAt;
    map = &Set<T>::_vptr_map;
    expand = &Set<T>::_vptr_expand;
    cast_ = &Set<T>::_vptr_cast_;
    fold = &Set<T>::_vptr_fold;
    whereType = &Set<T>::_vptr_whereType;
}

template<typename T>
inline constexpr SetClassInfo<T> Set<T>::_classInfo{};

// ── Type-erased collection → typed collection conversion helpers ──
// map/expand/cast/whereType dispatch returns AnyGC* pointing to a collection
// whose element type is erased. These helpers copy the elements into a properly
// typed collection using dynAs<T> for unboxing/conversion.

template<typename T>
List<T>* _typedListFromAnyGC(AnyGC* obj) {
    if (!obj) return nullptr;
    auto* src = static_cast<List<AnyGC*>*>(obj);
    auto* dst = new List<T>();
    dst->_data->_storage.reserve(src->_data->_storage.size());
    for (int i = 0; i < src->_data->_storage.size(); i++) {
        dst->_data->_storage.push_back(dynAs<T>(src->_data->_storage[i]));
    }
    return GC::allocateLocal(dst);
}

template<typename T>
Set<T>* _typedSetFromAnyGC(AnyGC* obj) {
    if (!obj) return nullptr;
    auto* src = static_cast<Set<AnyGC*>*>(obj);
    auto* dst = new Set<T>();
    dst->_data->_storage.reserve(src->_data->_storage.size());
    for (int i = 0; i < src->_data->_storage.size(); i++) {
        dst->_data->_storage.push_back(dynAs<T>(src->_data->_storage[i]));
    }
    return GC::allocateLocal(dst);
}

template<typename K, typename V>
Map<K, V>* _typedMapFromAnyGC(AnyGC* obj) {
    if (!obj) return nullptr;
    auto* src = static_cast<Map<AnyGC*, AnyGC*>*>(obj);
    auto* dst = new Map<K, V>();
    int n = src->_keys->_storage.size();
    dst->_keys->_storage.reserve(n);
    dst->_values->_storage.reserve(n);
    for (int i = 0; i < n; i++) {
        dst->_keys->_storage.push_back(dynAs<K>(src->_keys->_storage[i]));
        dst->_values->_storage.push_back(dynAs<V>(src->_values->_storage[i]));
    }
    return GC::allocateLocal(dst);
}

// ── List 延迟实现（依赖 Map / Set 完整类型） ──

template<typename T>
AnyGC* List<T>::_vptr_asMap(AnyGC* self) {
    if constexpr (_isMapEntry<T>::value) {
        return nullptr;
    } else {
        auto* list = static_cast<List*>(self);
        auto* result = new Map<int, T>();
        int n = list->_data->_storage.size();
        result->_keys->_storage.reserve(n);
        result->_values->_storage.reserve(n);
        for (int i = 0; i < n; i++) {
            result->_keys->_storage.push_back(i);
            result->_values->_storage.push_back(list->_data->_storage[i]);
        }
        return static_cast<AnyGC*>(GC::allocateLocal(result));
    }
}

template<typename T>
AnyGC* List<T>::_vptr_toSet(AnyGC* self) {
    if constexpr (_isEqualityComparable<T>::value) {
        auto* list = static_cast<List*>(self);
        auto* result = new Set<T>();
        result->_data->_storage.reserve(list->_data->_storage.size());
        for (int i = 0; i < list->_data->_storage.size(); i++) {
            auto& elem = list->_data->_storage[i];
            if (!array_contains(result->_data, elem)) result->_data->_storage.push_back(elem);
        }
        return static_cast<AnyGC*>(GC::allocateLocal(result));
    } else {
        return static_cast<AnyGC*>(Set<T>::empty());
    }
}


// ============================================================================
// 8. Promise / GlobalScheduler / sm_await — 协作式异步
// ============================================================================

// ── PromiseBase ──
// 对齐 Dart _async.dart Promise / GlobalScheduler / sm_await

// ClassInfo subclass declarations (constructor bodies defined after structs)
struct PromiseBaseClassInfo : ClassInfo {
    constexpr PromiseBaseClassInfo();
    void(*complete)(AnyGC*, AnyGC*) = nullptr;
    void(*completeError)(AnyGC*, AnyGC*) = nullptr;
    void(*setStartCallback)(AnyGC*, std::function<void()>) = nullptr;
    void(*setTickCallback)(AnyGC*, std::function<bool()>) = nullptr;
    bool(*get_isCompleted)(AnyGC*) = nullptr;
    bool(*get_isError)(AnyGC*) = nullptr;
    bool(*get_isReady)(AnyGC*) = nullptr;
    bool(*get_isPending)(AnyGC*) = nullptr;
};

struct PromiseBase : AnyGC {
    static const PromiseBaseClassInfo _classInfo;
    enum State { READY, PENDING, COMPLETED, ERROR };

    State state = PENDING;
    AnyGC* result = nullptr;
    AnyGC* error = nullptr;
    std::function<void()> startCallback;
    std::function<bool()> onTick;
    std::vector<AnyGC*> keepAlive;

    PromiseBase() { AnyGC::_classInfo = &_classInfo; }

    /// 析构时从调度器自注销（定义在 GlobalScheduler 之后）——
    /// 使不可达的 pending Promise 被 GC 回收时自动解除调度器钉住（F2 修复）
    ~PromiseBase();

    void addKeepAlive(AnyGC* obj) {
        if (obj) keepAlive.push_back(obj);
    }

    static void _gcMark_impl(AnyGC* self, int flag) {
        auto* p = static_cast<PromiseBase*>(self);
        if (p->result) _gcMark(p->result, flag);
        if (p->error) _gcMark(p->error, flag);
        for (auto* obj : p->keepAlive) {
            if (obj) _gcMark(obj, flag);
        }
    }

    // _vptr_setStartCallback / _vptr_setTickCallback declared here, defined after GlobalScheduler
    static void _vptr_setStartCallback(AnyGC* self, std::function<void()> cb);
    static void _vptr_setTickCallback(AnyGC* self, std::function<bool()> cb);

    // ── ClassInfo dispatch ──
    static AnyGC* _vptr_toString(AnyGC* self) {
        auto* p = static_cast<PromiseBase*>(self);
        string s = "Promise(";
        s += (p->state == COMPLETED ? "completed" : p->state == ERROR ? "error" :
              p->state == PENDING ? "pending" : "ready");
        s += ")";
        return _box(s);
    }
    static AnyGC* _vptr_runtimeType(AnyGC* self) {
        return _box(string("Promise"));
    }
    static void _vptr_complete(AnyGC* self, AnyGC* value) {
        auto* p = static_cast<PromiseBase*>(self);
        if (p->state == COMPLETED || p->state == ERROR) {
            throw DartStateError("Promise already resolved");
        }
        p->result = value;
        p->state = COMPLETED;
    }
    static void _vptr_completeError(AnyGC* self, AnyGC* err) {
        auto* p = static_cast<PromiseBase*>(self);
        if (p->state == COMPLETED || p->state == ERROR) {
            throw DartStateError("Promise already resolved");
        }
        p->error = err;
        p->state = ERROR;
    }
    static bool _vptr_isCompleted(AnyGC* self) {
        return static_cast<PromiseBase*>(self)->state == COMPLETED;
    }
    static bool _vptr_isError(AnyGC* self) {
        return static_cast<PromiseBase*>(self)->state == ERROR;
    }
    static bool _vptr_isReady(AnyGC* self) {
        return static_cast<PromiseBase*>(self)->state == READY;
    }
    static bool _vptr_isPending(AnyGC* self) {
        return static_cast<PromiseBase*>(self)->state == PENDING;
    }
};

inline constexpr PromiseBaseClassInfo::PromiseBaseClassInfo() {
    typeName = "Promise";
    destroy = &_gcDestroy<PromiseBase>;
    gcMark = &PromiseBase::_gcMark_impl;
    toString = &PromiseBase::_vptr_toString;
    get_runtimeType = &PromiseBase::_vptr_runtimeType;
    complete = &PromiseBase::_vptr_complete;
    completeError = &PromiseBase::_vptr_completeError;
    setStartCallback = &PromiseBase::_vptr_setStartCallback;
    setTickCallback = &PromiseBase::_vptr_setTickCallback;
    get_isCompleted = &PromiseBase::_vptr_isCompleted;
    get_isError = &PromiseBase::_vptr_isError;
    get_isReady = &PromiseBase::_vptr_isReady;
    get_isPending = &PromiseBase::_vptr_isPending;
}

inline constexpr PromiseBaseClassInfo PromiseBase::_classInfo{};

// Free helper functions for PromiseBase operations (replacing instance methods)
inline void promise_complete(PromiseBase* p, AnyGC* value) {
    if (p->state == PromiseBase::COMPLETED || p->state == PromiseBase::ERROR) {
        throw DartStateError("Promise already resolved");
    }
    p->result = value;
    p->state = PromiseBase::COMPLETED;
}
inline void promise_completeError(PromiseBase* p, AnyGC* err) {
    if (p->state == PromiseBase::COMPLETED || p->state == PromiseBase::ERROR) {
        throw DartStateError("Promise already resolved");
    }
    p->error = err;
    p->state = PromiseBase::ERROR;
}
inline bool promise_isCompleted(PromiseBase* p) { return p->state == PromiseBase::COMPLETED; }
inline bool promise_isError(PromiseBase* p) { return p->state == PromiseBase::ERROR; }
inline bool promise_isReady(PromiseBase* p) { return p->state == PromiseBase::READY; }
inline bool promise_isPending(PromiseBase* p) { return p->state == PromiseBase::PENDING; }

// ── Promise<T> ──

template<typename T>
struct Promise : PromiseBase {

    // ── 静态工厂 ──

    static Promise<T>* resolved(T value) {
        auto* promise = GC::allocateLocal(new Promise<T>());
        promise_complete(promise, _box(std::move(value)));
        return promise;
    }

    static Promise<T>* value(T value) {
        return resolved(std::move(value));
    }

    static Promise<T>* rejected(AnyGC* err) {
        auto* promise = GC::allocateLocal(new Promise<T>());
        promise_completeError(promise, err);
        return promise;
    }

    // delayed / then / catchError / whenComplete — declared as free functions after GlobalScheduler
    static Promise<T>* delayed(int ticks, std::function<T()> computation);
    static Promise<T>* delayed(int ticks, TypeFunction0<T>* computation);
    static Promise<List<T>*>* waitAll(std::vector<Promise<T>*> promises);
    static Promise<T>* any(std::vector<Promise<T>*> promises);
};

template<typename T>
inline T promise_typedResult(Promise<T>* p) { return dynAs<T>(p->result); }

template<typename T>
inline void promise_completeTyped(Promise<T>* p, T value) {
    promise_complete(p, _box(std::move(value)));
}

// ── GlobalScheduler ──

// _DelayedTask — 延迟任务记录（对齐 Dart _async.dart _DelayedTask）
struct _DelayedTask {
    int targetTick;
    std::function<void()> callback;
    PromiseBase* targetPromise;  // 用于 GC 标记

    _DelayedTask(int tick, std::function<void()> cb, PromiseBase* promise = nullptr)
        : targetTick(tick), callback(std::move(cb)), targetPromise(promise) {}
};

class GlobalScheduler {
    friend class GC;
    std::vector<PromiseBase*> _activePromises;
    std::vector<_DelayedTask> _delayedTasks;
    std::vector<PromiseBase*> _readyPromises;
    bool _ticking = false;  // tick 执行中：抑制自动 GC（防止回调中 collect 悬空 activeCopy）

    GlobalScheduler() = default;

public:
    int64_t _currentTick = 0;

    static GlobalScheduler& instance() {
        return GC::scheduler();
    }

    /// tick 是否执行中（自动 GC 据此抑制触发）
    static bool ticking() { return instance()._ticking; }

    /// GC 标记：仅保护延迟任务的 targetPromise（其 lambda 持有裸指针）。
    /// active/ready Promise 不再作为 root：不可达的 pending Promise 应被
    /// 回收，回收时经 ~PromiseBase 自注销从调度器移除（F2 修复）
    void gcMark(int flag) {
        for (auto& task : _delayedTasks) {
            if (task.targetPromise) _gcMark(task.targetPromise, flag);
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

    /// 显式注销 Promise（遗弃场景）：从调度器移除，使其子图可被 GC 回收。
    /// 注意：注销后调度器不再驱动该 Promise，其延迟任务（如有）一并移除。
    void unregisterPromise(PromiseBase* p) {
        _activePromises.erase(
            std::remove(_activePromises.begin(), _activePromises.end(), p),
            _activePromises.end());
        _readyPromises.erase(
            std::remove(_readyPromises.begin(), _readyPromises.end(), p),
            _readyPromises.end());
        _delayedTasks.erase(
            std::remove_if(_delayedTasks.begin(), _delayedTasks.end(),
                [p](const _DelayedTask& t) { return t.targetPromise == p; }),
            _delayedTasks.end());
    }

    void tick() {
        // RAII 守卫：tick 期间抑制自动 GC —— 若回调中触发 collect，
        // activeCopy 中可能出现已回收的 Promise（悬空）
        struct TickGuard {
            bool& flag;
            explicit TickGuard(bool& f) : flag(f) { flag = true; }
            ~TickGuard() { flag = false; }
        } guard(_ticking);

        _currentTick++;

        // 第一阶段：触发所有 ready 状态的 Promise 的启动回调
        auto readyCopy = _readyPromises;
        _readyPromises.clear();
        for (auto* p : readyCopy) {
            if (p->state == PromiseBase::READY && p->startCallback) {
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
            if (p->state == PromiseBase::COMPLETED || p->state == PromiseBase::ERROR) continue;
            if (p->onTick) {
                p->onTick();
            }
            if (p->state != PromiseBase::COMPLETED && p->state != PromiseBase::ERROR) {
                _activePromises.push_back(p);
            }
        }
    }

    int tickCount() const { return static_cast<int>(_currentTick); }
    int64_t currentTick() const { return _currentTick; }

    /// 检查是否有活跃的异步工作（Promise、延迟任务等）
    bool hasActiveWork() {
        return !_activePromises.empty() ||
            !_delayedTasks.empty() ||
            !_readyPromises.empty();
    }

    /// 调度器队列计数（泄漏分析用）
    void schedulerCounts(int* active, int* ready, int* delayed) {
        if (active) *active = static_cast<int>(_activePromises.size());
        if (ready) *ready = static_cast<int>(_readyPromises.size());
        if (delayed) *delayed = static_cast<int>(_delayedTasks.size());
    }

    void reset() {
        _activePromises.clear();
        _delayedTasks.clear();
        _readyPromises.clear();
        _currentTick = 0;
    }
};

// ── GC 静态成员定义（依赖 GlobalScheduler 完整类型） ──

inline GlobalScheduler GC::_scheduler;
inline GlobalScheduler& GC::scheduler() { return _scheduler; }

// ── PromiseBase 析构：从调度器自注销（F2 修复） ──

inline PromiseBase::~PromiseBase() {
    GlobalScheduler::instance().unregisterPromise(this);
}

// ── GC::maybeAutoCollect — 分配阈值自动触发（F1 修复） ──

inline void GC::maybeAutoCollect() {
    if (_autoCollectThreshold <= 0 || _collecting) return;
    if (GlobalScheduler::ticking()) return;  // tick 回调中不触发（防悬空）
    if (++_allocSinceCollect >= _autoCollectThreshold) {
        _allocSinceCollect = 0;
        collect();
    }
}

inline int GC::collect() {
    // 重入保护：collect 期间（含对象析构路径）不再触发自动 GC
    struct CollectGuard {
        bool& flag;
        explicit CollectGuard(bool& f) : flag(f) { flag = true; }
        ~CollectGuard() { flag = false; }
    } guard(_collecting);
    _allocSinceCollect = 0;

    _currentFlag++;
    int flag = _currentFlag;

    // 标记阶段：保守栈扫描。lo 取 collect 自身帧指针（帧顶 = 调用方帧底）：
    // [lo, 栈基) 恰好覆盖调用方及所有上层活跃帧的全部局部变量；
    // lo 之下是 collector 递归帧与已返回的被调帧（含与 collect 同深度的
    // 陈旧指针槽），一律不参与扫描 —— 否则会反复钉住已死对象。
    // 依赖帧指针存在（-O0 或 -fno-omit-frame-pointer）。
    scanStack(flag, __builtin_frame_address(0));

    // 标记阶段：GlobalScheduler 持有的 Promise 作为 root
    _scheduler.gcMark(flag);

    // 标记阶段：从每个 root 出发递归标记。
    // 注意：以下所有循环均用索引遍历 —— 若用 `for (auto* obj : ...)`，
    // 遗留在本帧的指针槽会在下一轮 collect 的栈扫描中钉住对象（假保留）
    for (size_t i = 0; i < _roots.size(); i++) {
        _gcMark(_roots[i], flag);
    }

    // 清除阶段：收集未被标记的对象
    int beforeCount = static_cast<int>(_objects.size());
    std::vector<AnyGC*> toDelete;
    for (size_t i = 0; i < _objects.size(); i++) {
        if (_objects[i]->gcFlag != flag) {
            toDelete.push_back(_objects[i]);
        }
    }

    // 从 _objects 中移除
    _objects.erase(
        std::remove_if(_objects.begin(), _objects.end(),
            [flag](AnyGC* obj) { return obj->gcFlag != flag; }),
        _objects.end()
    );

    // 增量更新 _registered：仅移除被回收的对象
    for (size_t i = 0; i < toDelete.size(); i++) {
        _registered.erase(toDelete[i]);
    }

    // 防御性清理 roots（理论上 root 总是被标记的）
    _roots.erase(
        std::remove_if(_roots.begin(), _roots.end(),
            [flag](AnyGC* obj) { return obj->gcFlag != flag; }),
        _roots.end()
    );

    // 释放未被标记的对象内存（索引遍历；遗留槽中的指针指向已删除
    // 对象，不在 _registered 中，下轮扫描不会误钉）
    for (size_t i = 0; i < toDelete.size(); i++) {
        _gcFree(toDelete[i]);
    }

    return beforeCount - static_cast<int>(_objects.size());
}

// ── PromiseBase 延迟实现（依赖 GlobalScheduler 完整类型） ──

inline void PromiseBase::_vptr_setStartCallback(AnyGC* self, std::function<void()> cb) {
    auto* p = static_cast<PromiseBase*>(self);
    p->startCallback = std::move(cb);
    GC::allocateLocal(p);
    p->state = READY;
    GlobalScheduler::instance().registerReadyPromise(p);
}

inline void PromiseBase::_vptr_setTickCallback(AnyGC* self, std::function<bool()> cb) {
    auto* p = static_cast<PromiseBase*>(self);
    p->onTick = std::move(cb);
    GC::allocateLocal(p);
    GlobalScheduler::instance().registerActivePromise(p);
}

// ── Promise<T> 延迟实现（依赖 GlobalScheduler 完整类型） ──

template<typename T>
Promise<T>* Promise<T>::delayed(int ticks, std::function<T()> computation) {
    auto* promise = GC::allocateLocal(new Promise<T>());
    GlobalScheduler::instance().registerDelayedTask(ticks, [promise, computation]() {
        try {
            promise_complete(promise, _box(computation()));
        } catch (const std::exception& e) {
            promise_completeError(promise, _box(string(e.what())));
        } catch (...) {
            promise_completeError(promise, nullptr);
        }
    }, promise);
    return promise;
}

template<typename T>
Promise<T>* Promise<T>::delayed(int ticks, TypeFunction0<T>* computation) {
    auto* promise = GC::allocateLocal(new Promise<T>());
    promise->addKeepAlive(static_cast<AnyGC*>(computation));
    GlobalScheduler::instance().registerDelayedTask(ticks, [promise, computation]() {
        try {
            promise_complete(promise, computation ? computation->fnPtr(computation) : _box(T{}));
        } catch (const std::exception& e) {
            promise_completeError(promise, _box(string(e.what())));
        } catch (...) {
            promise_completeError(promise, nullptr);
        }
    }, promise);
    return promise;
}

template<typename R, typename T>
Promise<R>* promise_then(Promise<T>* self, std::function<AnyGC*(T)> onValue) {
    // 延迟分配优化：如果已完成，直接执行回调并返回结果
    if (self->state == PromiseBase::COMPLETED) {
        try {
            AnyGC* callbackResult = onValue(dynAs<T>(self->result));
            AnyGC* gcResult = callbackResult;
            PromiseBase* innerPromise = gcResult ? (_isInstanceOf(gcResult, &PromiseBase::_classInfo) ? static_cast<PromiseBase*>(gcResult) : nullptr) : nullptr;
            if (innerPromise) {
                // flatMap 场景：返回内部 Promise
                auto* nextPromise = GC::allocateLocal(new Promise<R>());
                auto* capturedInner = innerPromise;
                nextPromise->addKeepAlive(static_cast<AnyGC*>(capturedInner));  // F5：钉住内部 Promise
                nextPromise->onTick = [capturedInner, nextPromise]() -> bool {
                    if (capturedInner->state == PromiseBase::COMPLETED) {
                        promise_complete(nextPromise, capturedInner->result);
                        return true;
                    }
                    if (capturedInner->state == PromiseBase::ERROR) {
                        promise_completeError(nextPromise, capturedInner->error);
                        return true;
                    }
                    return false;
                };
                GlobalScheduler::instance().registerActivePromise(nextPromise);
                return nextPromise;
            }
            // 直接结果：创建已完成的 Promise
            auto* nextPromise = GC::allocateLocal(new Promise<R>());
            promise_complete(nextPromise, callbackResult);
            return nextPromise;
        } catch (const std::exception& e) {
            auto* nextPromise = GC::allocateLocal(new Promise<R>());
            promise_completeError(nextPromise, _box(string(e.what())));
            return nextPromise;
        }
    }

    // 如果已错误，直接传递错误
    if (self->state == PromiseBase::ERROR) {
        auto* nextPromise = GC::allocateLocal(new Promise<R>());
        promise_completeError(nextPromise, self->error);
        return nextPromise;
    }

    // 正常场景：延迟执行
    auto* nextPromise = GC::allocateLocal(new Promise<R>());
    // F5 修复：lambda 捕获对 GC 标记不可见，用 keepAlive 显式钉住上游 Promise，
    // 防止 self 在仅被 nextPromise->onTick 引用时被 collect 回收（UAF）
    nextPromise->addKeepAlive(static_cast<AnyGC*>(self));
    nextPromise->onTick = [self, onValue, nextPromise]() -> bool {
        if (self->state == PromiseBase::COMPLETED) {
            try {
                AnyGC* callbackResult = onValue(dynAs<T>(self->result));
                AnyGC* gcResult = callbackResult;
                PromiseBase* innerPromise = gcResult ? (_isInstanceOf(gcResult, &PromiseBase::_classInfo) ? static_cast<PromiseBase*>(gcResult) : nullptr) : nullptr;
                if (innerPromise) {
                    nextPromise->addKeepAlive(static_cast<AnyGC*>(innerPromise));  // F5：钉住内部 Promise
                    nextPromise->onTick = [innerPromise, nextPromise]() -> bool {
                        if (innerPromise->state == PromiseBase::COMPLETED) {
                            promise_complete(nextPromise, innerPromise->result);
                            return true;
                        }
                        if (innerPromise->state == PromiseBase::ERROR) {
                            promise_completeError(nextPromise, innerPromise->error);
                            return true;
                        }
                        return false;
                    };
                    return false;
                }
                promise_complete(nextPromise, callbackResult);
            } catch (const std::exception& e) {
                promise_completeError(nextPromise, _box(string(e.what())));
            }
            return true;
        }
        if (self->state == PromiseBase::ERROR) {
            promise_completeError(nextPromise, self->error);
            return true;
        }
        return false;
    };
    GlobalScheduler::instance().registerActivePromise(nextPromise);
    return nextPromise;
}

template<typename T>
Promise<T>* promise_catchError(Promise<T>* self, std::function<T(AnyGC*)> onError) {
    // 延迟分配优化：如果已完成，直接传递结果
    if (self->state == PromiseBase::COMPLETED) {
        auto* nextPromise = GC::allocateLocal(new Promise<T>());
        promise_complete(nextPromise, self->result);
        return nextPromise;
    }

    // 如果已错误，执行错误处理
    if (self->state == PromiseBase::ERROR) {
        auto* nextPromise = GC::allocateLocal(new Promise<T>());
        try {
            promise_complete(nextPromise, _box(onError(self->error)));
        } catch (const std::exception& e) {
            promise_completeError(nextPromise, _box(string(e.what())));
        }
        return nextPromise;
    }

    // 正常场景：延迟执行
    auto* nextPromise = GC::allocateLocal(new Promise<T>());
    nextPromise->addKeepAlive(static_cast<AnyGC*>(self));  // F5：钉住上游 Promise
    nextPromise->onTick = [self, onError, nextPromise]() -> bool {
        if (self->state == PromiseBase::COMPLETED) {
            promise_complete(nextPromise, self->result);
            return true;
        }
        if (self->state == PromiseBase::ERROR) {
            try {
                promise_complete(nextPromise, _box(onError(self->error)));
            } catch (const std::exception& e) {
                promise_completeError(nextPromise, _box(string(e.what())));
            }
            return true;
        }
        return false;
    };
    GlobalScheduler::instance().registerActivePromise(nextPromise);
    return nextPromise;
}

template<typename T>
Promise<T>* promise_whenComplete(Promise<T>* self, std::function<void()> action) {
    // 延迟分配优化：如果已完成，执行 action 并传递结果
    if (self->state == PromiseBase::COMPLETED) {
        auto* nextPromise = GC::allocateLocal(new Promise<T>());
        try {
            action();
            promise_complete(nextPromise, self->result);
        } catch (const std::exception& e) {
            promise_completeError(nextPromise, _box(string(e.what())));
        }
        return nextPromise;
    }

    // 如果已错误，执行 action 并传递错误
    if (self->state == PromiseBase::ERROR) {
        auto* nextPromise = GC::allocateLocal(new Promise<T>());
        try { action(); } catch (...) {}
        promise_completeError(nextPromise, self->error);
        return nextPromise;
    }

    // 正常场景：延迟执行
    auto* nextPromise = GC::allocateLocal(new Promise<T>());
    nextPromise->addKeepAlive(static_cast<AnyGC*>(self));  // F5：钉住上游 Promise
    nextPromise->onTick = [self, action, nextPromise]() -> bool {
        if (self->state == PromiseBase::COMPLETED) {
            try {
                action();
                promise_complete(nextPromise, self->result);
            } catch (const std::exception& e) {
                promise_completeError(nextPromise, _box(string(e.what())));
            }
            return true;
        }
        if (self->state == PromiseBase::ERROR) {
            try { action(); } catch (...) {}
            promise_completeError(nextPromise, self->error);
            return true;
        }
        return false;
    };
    GlobalScheduler::instance().registerActivePromise(nextPromise);
    return nextPromise;
}

// ── Promise<T>::waitAll — 等待所有 Promise 完成，返回结果列表 ──

template<typename T>
Promise<List<T>*>* Promise<T>::waitAll(std::vector<Promise<T>*> promises) {
    auto* resultPromise = GC::allocateLocal(new Promise<List<T>*>());
    if (promises.empty()) {
        promise_complete(resultPromise, _box(
            GC::allocateLocal(new List<T>())));
        return resultPromise;
    }

    std::vector<AnyGC*> results(promises.size(), nullptr);
    int completedCount = 0;
    auto total = promises.size();

    for (auto* p : promises) {
        resultPromise->addKeepAlive(static_cast<AnyGC*>(p));
    }

    resultPromise->onTick = [promises, resultPromise, results = std::move(results), completedCount, total]() mutable -> bool {
        for (size_t i = 0; i < promises.size(); i++) {
            auto* p = promises[i];
            if (p->state == ERROR) {
                promise_completeError(resultPromise, p->error);
                return true;
            }
            if (p->state == COMPLETED && results[i] == nullptr) {
                results[i] = p->result;
                completedCount++;
            }
        }
        if (completedCount == static_cast<int>(total)) {
            auto* list = GC::allocateLocal(new List<T>());
            for (const auto& r : results) {
                list->_data->_storage.push_back(dynAs<T>(r));
            }
            promise_complete(resultPromise, _box(list));
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

    for (auto* p : promises) {
        resultPromise->addKeepAlive(static_cast<AnyGC*>(p));
    }

    resultPromise->onTick = [promises, resultPromise]() -> bool {
        for (auto* p : promises) {
            if (p->state == COMPLETED) {
                promise_complete(resultPromise, p->result);
                return true;
            }
            if (p->state == ERROR) {
                promise_completeError(resultPromise, p->error);
                return true;
            }
        }
        return false;
    };
    GlobalScheduler::instance().registerActivePromise(resultPromise);
    return resultPromise;
}

// ── promise_value / promise_delayed / promise_then — lowered 函数包装器 ──
// 这些函数对应 lowered Dart 代码中的 promise_value, promise_delayed, then 链

template<typename T>
Promise<T>* promise_value(T val) {
    return Promise<T>::resolved(val);
}

template<typename T>
Promise<T>* promise_delayed(int64_t delayTicks, TypeFunction0<T>* computation) {
    return Promise<T>::delayed(static_cast<int>(delayTicks), computation);
}

/// duration_ticks — Duration 毫秒数 → 调度 tick（1 tick = 10ms，ceil + clamp(1, 100000)）
inline int64_t duration_ticks(int64_t ms) {
    int64_t t = (ms >= 0) ? (ms + 9) / 10 : ms / 10;
    return t < 1 ? 1 : (t > 100000 ? 100000 : t);
}

// _PromiseThen<R>::call(receiver, onValue) — only R is explicit, T is deduced
// Accepts the concrete TypeFunctionN subtype so the callback argument type is known.
template<typename R>
struct _PromiseThen {
    template<typename T, typename Closure>
    static Promise<R>* call(Promise<T>* this__, Closure* onValue) {
        auto* resultPromise = GC::allocateLocal(new Promise<R>());
        resultPromise->addKeepAlive(static_cast<AnyGC*>(this__));
        resultPromise->addKeepAlive(static_cast<AnyGC*>(onValue));
        promise_then<R>(this__, std::function<AnyGC*(T)>([onValue, resultPromise](T val) -> AnyGC* {
            // fnPtr 为统一擦除签名：实参经 _boxElem 装箱为 AnyGC*
            AnyGC* result = onValue->fnPtr(onValue, _boxElem(val));
            if constexpr (!std::is_void_v<R>) {
                promise_completeTyped(resultPromise, dynAs<R>(result));
            }
            return nullptr;
        }));
        return resultPromise;
    }
};

// ── sm_await<T> — 阻塞式 await（对齐 Dart sm_await，含递归深度计数） ──

// inline：多 TU 共享同一实体（原 static 内部链接会导致每个 TU 一份副本，
// 深度计数互相不可见）
inline int _sm_awaitDepth = 0;
inline const int _sm_awaitMaxDepth = 500;

// RAII guard for sm_await depth tracking
struct SmAwaitDepthGuard {
    SmAwaitDepthGuard() {
        _sm_awaitDepth++;
        if (_sm_awaitDepth > _sm_awaitMaxDepth) {
            _sm_awaitDepth--;
            char buf[80];
            snprintf(buf, sizeof(buf), "sm_await recursion depth exceeded %lld",
                     static_cast<long long>(_sm_awaitMaxDepth));
            throw DartStateError(string(buf));
        }
    }
    ~SmAwaitDepthGuard() {
        _sm_awaitDepth--;
    }
    // 禁用拷贝和移动
    SmAwaitDepthGuard(const SmAwaitDepthGuard&) = delete;
    SmAwaitDepthGuard& operator=(const SmAwaitDepthGuard&) = delete;
};

template<typename T>
T sm_await(PromiseBase* promise) {
    if (!promise) {
        throw DartStateError("sm_await: null promise");
    }

    // RAII guard ensures depth is always decremented, even on exceptions
    SmAwaitDepthGuard depthGuard;

    // 如果已完成，直接返回
    if (promise->state == PromiseBase::COMPLETED) return dynAs<T>(promise->result);
    if (promise->state == PromiseBase::ERROR) {
        throw DartException("Promise completed with error: " +
            _anyToString(promise->error));
    }

    // 如果是 READY，启动回调
    if (promise->state == PromiseBase::READY && promise->startCallback) {
        promise->state = PromiseBase::PENDING;
        promise->startCallback();
        promise->startCallback = nullptr;
        if (promise->state == PromiseBase::COMPLETED) return dynAs<T>(promise->result);
        if (promise->state == PromiseBase::ERROR) {
            throw DartException("Promise completed with error");
        }
    }

    // 循环 tick 直到完成
    int maxRounds = 100000;
    int rounds = 0;
    while (promise->state != PromiseBase::COMPLETED && promise->state != PromiseBase::ERROR && rounds < maxRounds) {
        GlobalScheduler::instance().tick();
        rounds++;
    }

    if (rounds >= maxRounds) {
        char buf[80];
        snprintf(buf, sizeof(buf), "sm_await: deadlock detected after %lld ticks",
                 static_cast<long long>(maxRounds));
        throw DartStateError(string(buf));
    }

    if (promise->state == PromiseBase::ERROR) {
        throw DartException("Promise completed with error: " +
            _anyToString(promise->error));
    }

    if constexpr (std::is_same_v<T, AnyGC*>) {
        return promise->result;
    } else {
        return dynAs<T>(promise->result);
    }
}

// ── sm_await passthrough for non-Promise values ──
template<typename T>
inline T sm_await(T value) {
    return value;
}

// ── sm_await(AnyGC*) overloads — 从 AnyGC* 中提取 PromiseBase* ──
template<typename T>
inline T sm_await(AnyGC* promiseValue) {
    PromiseBase* promise = promiseValue ? (_isInstanceOf(promiseValue, &PromiseBase::_classInfo) ? static_cast<PromiseBase*>(promiseValue) : nullptr) : nullptr;
    if (!promise) {
        if constexpr (std::is_same_v<T, AnyGC*>) {
            return promiseValue;
        } else {
            return dynAs<T>(promiseValue);
        }
    }
    return sm_await<T>(promise);
}

// Overload for AnyGC* passthrough
inline AnyGC* sm_await(AnyGC* value) {
    return value;
}

// ── AsyncStateMachine<T> ──

template<typename T>
struct AsyncStateMachineClassInfo : ClassInfo {
    bool(*step)(AnyGC*) = nullptr;
    AnyGC*(*start)(AnyGC*) = nullptr;
    void(*completeWith)(AnyGC*, AnyGC*) = nullptr;
    void(*completeWithError)(AnyGC*, AnyGC*) = nullptr;
};

template<typename T>
struct AsyncStateMachine : AnyGC {
    static const AsyncStateMachineClassInfo<T> _baseClassInfo;
    int smState = 0;
    Promise<T>* promise;
    const AsyncStateMachineClassInfo<T>* _classInfo = nullptr;

    AsyncStateMachine() {
        promise = GC::allocateLocal(new Promise<T>());
        AnyGC::_classInfo = &_baseClassInfo;
    }

    static void _gcMark_impl(AnyGC* self, int flag) {
        auto* sm = static_cast<AsyncStateMachine<T>*>(self);
        if (sm->promise) _gcMark(sm->promise, flag);
    }

    // ── ClassInfo dispatch ──
    static AnyGC* _vptr_toString(AnyGC* self) {
        return _box(string("AsyncStateMachine"));
    }
    static AnyGC* _vptr_runtimeType(AnyGC* self) {
        return _box(string("AsyncStateMachine"));
    }
    static bool _vptr_step(AnyGC* self) {
        auto* sm = static_cast<AsyncStateMachine*>(self);
        auto* ci = static_cast<const AsyncStateMachineClassInfo<T>*>(sm->AnyGC::_classInfo);
        if (ci && ci->step) {
            return ci->step(sm);
        }
        return true;
    }
    static AnyGC* _vptr_start(AnyGC* self) {
        auto* sm = static_cast<AsyncStateMachine*>(self);
        sm->promise->onTick = [sm]() -> bool {
            return AsyncStateMachine::_vptr_step(sm);
        };
        sm->promise->addKeepAlive(static_cast<AnyGC*>(sm));
        GlobalScheduler::instance().registerActivePromise(sm->promise);
        return static_cast<AnyGC*>(sm->promise);
    }
    static void _vptr_completeWith(AnyGC* self, AnyGC* value) {
        auto* sm = static_cast<AsyncStateMachine*>(self);
        promise_completeTyped(sm->promise, _unboxElem<T>(value));
    }
    static void _vptr_completeWithError(AnyGC* self, AnyGC* error) {
        auto* sm = static_cast<AsyncStateMachine*>(self);
        promise_completeError(sm->promise, error);
    }
};

template<typename T>
inline constexpr AsyncStateMachineClassInfo<T> AsyncStateMachine<T>::_baseClassInfo = []() constexpr {
    AsyncStateMachineClassInfo<T> ci;
    ci.typeName = "AsyncStateMachine";
    ci.destroy = &_gcDestroy<AsyncStateMachine<T>>;
    ci.gcMark = &AsyncStateMachine<T>::_gcMark_impl;
    ci.toString = &AsyncStateMachine<T>::_vptr_toString;
    ci.get_runtimeType = &AsyncStateMachine<T>::_vptr_runtimeType;
    ci.step = &AsyncStateMachine<T>::_vptr_step;
    ci.start = &AsyncStateMachine<T>::_vptr_start;
    ci.completeWith = &AsyncStateMachine<T>::_vptr_completeWith;
    ci.completeWithError = &AsyncStateMachine<T>::_vptr_completeWithError;
    return ci;
}();

// ── AsyncStateMachine lowered 函数包装器 ──
template<typename T> void AsyncStateMachine_completeWith(AsyncStateMachine<T>* this__, T value) {
    promise_completeTyped(this__->promise, std::move(value));
}
template<typename T> void AsyncStateMachine_completeWithError(AsyncStateMachine<T>* this__, AnyGC* error) {
    promise_completeError(this__->promise, error);
}
template<typename T> Promise<T>* AsyncStateMachine_start(AsyncStateMachine<T>* this__) {
    return static_cast<Promise<T>*>(AsyncStateMachine<T>::_vptr_start(this__));
}
template<typename T> bool AsyncStateMachine_step(AsyncStateMachine<T>* this__) {
    return AsyncStateMachine<T>::_vptr_step(this__);
}
template<typename T> AsyncStateMachine<T>* AsyncStateMachine_new(AsyncStateMachine<T>* this__) {
    this__->smState = 0;
    this__->promise = GC::allocateLocal(new Promise<T>());
    return this__;
}

// ============================================================================
// 9. 语义包装 — dart_print / StringBuffer
// ============================================================================

/// 替代 Dart 的 print()，支持各种类型
inline void dart_print(int64_t value) {
    std::cout << value << std::endl;
}

inline void dart_print(double value) {
    std::ostringstream oss;
    oss << value;
    auto tmp = oss.str();
    string s(tmp.data(), tmp.size());
    if (s.find('.') == string::npos && s.find('e') == string::npos &&
        s.find('i') == string::npos && s.find('n') == string::npos) {
        s += ".0";
    }
    std::cout << s << std::endl;
}

inline void dart_print(bool value) {
    std::cout << (value ? "true" : "false") << std::endl;
}

inline void dart_print(const string& value) {
    std::cout << value << std::endl;
}

inline void dart_print(const char* value) {
    std::cout << value << std::endl;
}

/// dart_print 重载 — 任意 GC 管理的对象指针（List*, Map* 等）
template<typename T>
inline typename std::enable_if<std::is_base_of<AnyGC, T>::value &&
    !std::is_same<T, AnyGC>::value && !std::is_same<T, string>::value, void>::type
dart_print(T* value) {
    if (!value) {
        std::cout << "null" << std::endl;
    } else {
        std::cout << dart_str(value) << std::endl;
    }
}

/// dart_print 重载 — AnyGC* 基类指针
inline void dart_print(AnyGC* value) {
    if (!value) {
        std::cout << "null" << std::endl;
    } else {
        std::cout << _anyToString(value) << std::endl;
    }
}

/// dart_print 重载 — 异常类型
inline void dart_print(const std::exception& e) {
    std::cout << e.what() << std::endl;
}

/// dart_print 重载 — nullptr
inline void dart_print(std::nullptr_t) {
    std::cout << "null" << std::endl;
}

struct StringBufferClassInfo : ClassInfo {
    constexpr StringBufferClassInfo();
    void(*write)(AnyGC*, AnyGC*) = nullptr;
    void(*writeln)(AnyGC*, AnyGC*) = nullptr;
    void(*writeAll)(AnyGC*, AnyGC*, AnyGC*) = nullptr;
    void(*writeCharCode)(AnyGC*, AnyGC*) = nullptr;
    void(*clear)(AnyGC*) = nullptr;
};

/// StringBuffer — 替代 Dart 的 StringBuffer
struct StringBuffer : AnyGC {
    static const StringBufferClassInfo _classInfo;
    std::ostringstream _buf;

    StringBuffer() {
        AnyGC::_classInfo = &_classInfo;
        GC::allocateLocal(this);
    }

    // ── ClassInfo dispatch ──
    static AnyGC* _vptr_toString(AnyGC* self) {
        return _box(static_cast<StringBuffer*>(self)->_buf.str());
    }
    static AnyGC* _vptr_runtimeType(AnyGC* self) {
        return _box(string("StringBuffer"));
    }
    static int64_t _vptr_length(AnyGC* self) {
        return static_cast<int64_t>(static_cast<StringBuffer*>(self)->_buf.tellp());
    }
    static bool _vptr_isEmpty(AnyGC* self) {
        return static_cast<StringBuffer*>(self)->_buf.tellp() <= 0;
    }
    static bool _vptr_isNotEmpty(AnyGC* self) {
        return static_cast<StringBuffer*>(self)->_buf.tellp() > 0;
    }
    static void _vptr_write(AnyGC* self, AnyGC* value) {
        static_cast<StringBuffer*>(self)->_buf << _anyToString(value);
    }
    static void _vptr_writeln(AnyGC* self, AnyGC* value) {
        auto* sb = static_cast<StringBuffer*>(self);
        if (value) sb->_buf << _anyToString(value);
        sb->_buf << "\n";
    }
    static void _vptr_writeAll(AnyGC* self, AnyGC* objects, AnyGC* separator) {
        auto* sb = static_cast<StringBuffer*>(self);
        auto* objs = static_cast<List<AnyGC*>*>(objects);
        string sep = separator ? dynAs<string>(separator) : "";
        if (!objs) return;
        for (int i = 0; i < objs->_data->_storage.size(); i++) {
            if (i > 0) sb->_buf << sep;
            sb->_buf << _anyToString(objs->_data->_storage[i]);
        }
    }
    static void _vptr_writeCharCode(AnyGC* self, AnyGC* charCode) {
        static_cast<StringBuffer*>(self)->_buf << static_cast<char>(dynAs<int64_t>(charCode));
    }
    static void _vptr_clear(AnyGC* self) {
        auto* sb = static_cast<StringBuffer*>(self);
        sb->_buf.str("");
        sb->_buf.clear();
    }
    static void _gcMark_impl(AnyGC* self, int flag) {}
};

// Free functions for C++-specific write overloads
inline void string_buffer_write(StringBuffer* sb, const string& value) {
    sb->_buf << value;
}
inline void string_buffer_write(StringBuffer* sb, int64_t value) {
    sb->_buf << value;
}
inline void string_buffer_write(StringBuffer* sb, double value) {
    sb->_buf << value;
}
inline void string_buffer_write(StringBuffer* sb, bool value) {
    sb->_buf << (value ? "true" : "false");
}
inline void string_buffer_writeln(StringBuffer* sb) {
    sb->_buf << "\n";
}
inline void string_buffer_writeln(StringBuffer* sb, const string& value) {
    sb->_buf << value << "\n";
}
inline void string_buffer_write(StringBuffer* sb, AnyGC* value) {
    if (value) sb->_buf << _anyToString(value);
}
inline void string_buffer_writeln(StringBuffer* sb, AnyGC* value) {
    if (value) sb->_buf << _anyToString(value);
    sb->_buf << "\n";
}
inline void string_buffer_clear(StringBuffer* sb) {
    sb->_buf.str("");
    sb->_buf.clear();
}

inline constexpr StringBufferClassInfo::StringBufferClassInfo() {
    typeName = "StringBuffer";
    destroy = &_gcDestroy<StringBuffer>;
    gcMark = &StringBuffer::_gcMark_impl;
    toString = &StringBuffer::_vptr_toString;
    get_runtimeType = &StringBuffer::_vptr_runtimeType;
    get_length = &StringBuffer::_vptr_length;
    get_isEmpty = &StringBuffer::_vptr_isEmpty;
    get_isNotEmpty = &StringBuffer::_vptr_isNotEmpty;
    write = &StringBuffer::_vptr_write;
    writeln = &StringBuffer::_vptr_writeln;
    writeAll = &StringBuffer::_vptr_writeAll;
    writeCharCode = &StringBuffer::_vptr_writeCharCode;
    clear = &StringBuffer::_vptr_clear;
}

inline constexpr StringBufferClassInfo StringBuffer::_classInfo{};

// ============================================================================
// 10. 辅助函数
// ============================================================================

/// dart_is<T> — 运行时类型检查（通过 _classInfo 父链遍历）
template<typename T>
bool dart_is(AnyGC* obj) {
    return _isInstanceOf(obj, &T::_classInfo);
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
inline string _toStr(int64_t v) {
    char buf[24];
    snprintf(buf, sizeof(buf), "%lld", static_cast<long long>(v));
    return string(buf);
}
inline string _toStr(int v) {
    char buf[24];
    snprintf(buf, sizeof(buf), "%d", v);
    return string(buf);
}
inline string _toStr(double v) {
    std::ostringstream oss;
    oss << v;
    auto tmp = oss.str();
    string s(tmp.data(), tmp.size());
    if (s.find('.') == string::npos && s.find('e') == string::npos &&
        s.find('i') == string::npos && s.find('n') == string::npos) {
        s += ".0";
    }
    return s;
}
inline string _toStr(bool v) { return v ? "true" : "false"; }
inline string _toStr(const string& v) { return v; }
inline string _toStr(const char* v) { return v ? v : "null"; }
inline string _toStr(const std::string& v) { return string(v.data(), v.size()); }
inline string _toStr(AnyGC* v) {
    if (!v) return "null";
    if (v->_classInfo && v->_classInfo->toString) {
        return dynAs<string>(v->_classInfo->toString(v));
    }
    if (v->_classInfo && v->_classInfo->typeName && v->_classInfo->typeName[0])
        return _ciTypeNameStr(v->_classInfo);
    return "Instance";
}
inline string _toStr(TypeFunction* v) { return v ? "[TypeFunction]" : "null"; }
inline string _toStr(const DartException& e) { return e.toString(); }
inline string _toStr(std::nullptr_t) { return "null"; }
inline string _toStr(const ReachabilityError& v) { return v.toStringValue(); }
// 指针类型 _toStr — 处理任意指针（List*, Map* 等）
template<typename T>
inline typename std::enable_if<std::is_base_of<AnyGC, T>::value, string>::type
_toStr(T* v) {
    if (!v) return "null";
    const ClassInfo* ci = v->AnyGC::_classInfo;
    if (ci && ci->toString) {
        return dynAs<string>(ci->toString(v));
    }
    if (ci && ci->typeName && ci->typeName[0]) return _ciTypeNameStr(ci);
    return "Instance";
}

// _toStr for MapEntry (value type, not pointer)
template<typename K, typename V>
inline string _toStr(const MapEntry<K, V>& entry) {
    return "MapEntry(" + _toStr(entry.key) + ": " + _toStr(entry.value) + ")";
}

/// dart_str — 字符串插值辅助（可变参数拼接）
template<typename... Args>
string dart_str(Args&&... args) {
    std::ostringstream oss;
    (void)(int[]){0, ((oss << _toStr(std::forward<Args>(args))), 0)...};
    auto tmp = oss.str();
    return string(tmp.data(), tmp.size());
}

// ============================================================================
// 11. String 方法辅助
// ============================================================================

/// string_toUpper — 转换为大写
inline string string_toUpper(const string& s) {
    size_t n = s.size();
    char* buf = new char[n + 1];
    for (size_t i = 0; i < n; i++)
        buf[i] = static_cast<char>(toupper(static_cast<unsigned char>(s[i])));
    buf[n] = '\0';
    string result(buf, n);
    delete[] buf;
    return result;
}

/// string_toLower — 转换为小写
inline string string_toLower(const string& s) {
    size_t n = s.size();
    char* buf = new char[n + 1];
    for (size_t i = 0; i < n; i++)
        buf[i] = static_cast<char>(tolower(static_cast<unsigned char>(s[i])));
    buf[n] = '\0';
    string result(buf, n);
    delete[] buf;
    return result;
}

/// string_trim — 去除首尾空白
inline string string_trim(const string& s) {
    size_t start = s.find_first_not_of(" \t\n\r\f\v");
    if (start == string::npos) return "";
    size_t end = s.find_last_not_of(" \t\n\r\f\v");
    return s.substr(start, end - start + 1);
}

/// string_split — 分割字符串
inline List<string>* string_split(const string& s, const string& delimiter) {
    auto* result = new List<string>();
    if (delimiter.empty()) {
        // Split into individual characters
        for (char c : s) {
            result->_data->_storage.push_back(string(1, c));
        }
    } else {
        size_t start = 0;
        size_t end = s.find(delimiter);
        while (end != string::npos) {
            result->_data->_storage.push_back(s.substr(start, end - start));
            start = end + delimiter.length();
            end = s.find(delimiter, start);
        }
        result->_data->_storage.push_back(s.substr(start));
    }
    return GC::allocateLocal(result);
}

/// string_replaceAll — 替换所有匹配
inline string string_replaceAll(const string& s, const string& from, const string& to) {
    if (from.empty()) return s;
    string result = s;
    size_t start_pos = 0;
    while ((start_pos = result.find(from, start_pos)) != string::npos) {
        result.replace(start_pos, from.length(), to);
        start_pos += to.length();
    }
    return result;
}

/// string_replaceFirst — 替换首个匹配（可选起始位置）
inline string string_replaceFirst(const string& s, const string& from, const string& to, int64_t start) {
    if (from.empty()) return s;
    if (start < 0) start = 0;
    size_t pos = s.find(from, static_cast<size_t>(start));
    if (pos == string::npos) return s;
    string result = s;
    result.replace(pos, from.length(), to);
    return result;
}

/// string_replaceRange — 替换 [start, end) 区间
inline string string_replaceRange(const string& s, int64_t start, int64_t end, const string& replacement) {
    int64_t len = static_cast<int64_t>(s.size());
    if (start < 0) start = 0;
    if (end < start) end = start;
    if (end > len) end = len;
    string result = s;
    result.replace(static_cast<size_t>(start), static_cast<size_t>(end - start), replacement);
    return result;
}

/// string_trimLeft — 去除左侧空白
inline string string_trimLeft(const string& s) {
    size_t start = s.find_first_not_of(" \t\n\r\f\v");
    if (start == string::npos) return "";
    return s.substr(start);
}

/// string_trimRight — 去除右侧空白
inline string string_trimRight(const string& s) {
    size_t end = s.find_last_not_of(" \t\n\r\f\v");
    if (end == string::npos) return "";
    return s.substr(0, end + 1);
}

/// string_padLeft — 左侧填充至指定宽度
inline string string_padLeft(const string& s, int64_t width, const string& padding) {
    if (width <= static_cast<int64_t>(s.size())) return s;
    string pad = padding.empty() ? string(" ") : padding;
    int64_t missing = width - static_cast<int64_t>(s.size());
    string prefix;
    if (pad.size() == 1) {
        prefix = string(static_cast<size_t>(missing), pad[0]);
    } else {
        int64_t reps = missing / static_cast<int64_t>(pad.size());
        int64_t remainder = missing % static_cast<int64_t>(pad.size());
        for (int64_t i = 0; i < reps; ++i) prefix += pad;
        prefix += pad.substr(0, static_cast<size_t>(remainder));
    }
    return prefix + s;
}

/// string_padRight — 右侧填充至指定宽度
inline string string_padRight(const string& s, int64_t width, const string& padding) {
    if (width <= static_cast<int64_t>(s.size())) return s;
    string pad = padding.empty() ? string(" ") : padding;
    int64_t missing = width - static_cast<int64_t>(s.size());
    string suffix;
    if (pad.size() == 1) {
        suffix = string(static_cast<size_t>(missing), pad[0]);
    } else {
        int64_t reps = missing / static_cast<int64_t>(pad.size());
        int64_t remainder = missing % static_cast<int64_t>(pad.size());
        for (int64_t i = 0; i < reps; ++i) suffix += pad;
        suffix += pad.substr(0, static_cast<size_t>(remainder));
    }
    return s + suffix;
}

/// string_lastIndexOf — 从右侧查找子串（可选起始位置）
inline int64_t string_lastIndexOf(const string& s, const string& pattern, int64_t start) {
    if (pattern.empty()) return static_cast<int64_t>(s.size());
    if (start < 0) return -1;
    size_t searchEnd = static_cast<size_t>(std::min<int64_t>(start + static_cast<int64_t>(pattern.size()) - 1, static_cast<int64_t>(s.size()) - 1));
    if (searchEnd >= s.size() && !s.empty()) searchEnd = s.size() - 1;
    size_t pos = s.rfind(pattern, searchEnd);
    if (pos == string::npos) return -1;
    return static_cast<int64_t>(pos);
}

/// string_codeUnitAt — 返回指定位置字符的码元
inline int64_t string_codeUnitAt(const string& s, int64_t index) {
    if (index < 0 || static_cast<size_t>(index) >= s.size()) {
        throw DartRangeError("Index out of range");
    }
    return static_cast<int64_t>(static_cast<uint8_t>(s[static_cast<size_t>(index)]));
}

/// string_fromCharCode — 将单个码元转为单字符字符串
inline string string_fromCharCode(int64_t code) {
    return string(1, static_cast<char>(code));
}

/// string_fromCharCodes — 将码元列表（List<int64_t>）转为字符串
inline string string_fromCharCodes(AnyGC* list) {
    auto* l = static_cast<List<int64_t>*>(list);
    string s;
    s.reserve(l->_data->_storage.size());
    for (int64_t c : l->_data->_storage) s.push_back(static_cast<char>(c));
    return s;
}

/// int_toRadixString — 将整数按指定进制转换为字符串（radix 2-36）
inline string int_toRadixString(int64_t value, int64_t radix) {
    if (radix < 2 || radix > 36) {
        throw DartUnsupportedError("Radix out of range");
    }
    if (value == 0) return "0";
    const char* digits = "0123456789abcdefghijklmnopqrstuvwxyz";
    bool negative = value < 0;
    uint64_t u = negative ? static_cast<uint64_t>(-(value + 1)) + 1 : static_cast<uint64_t>(value);
    char buf[65];
    int idx = 0;
    while (u > 0) {
        buf[idx++] = digits[u % static_cast<uint64_t>(radix)];
        u /= static_cast<uint64_t>(radix);
    }
    if (negative) buf[idx++] = '-';
    for (int i = 0; i < idx / 2; i++) {
        char tmp = buf[i];
        buf[i] = buf[idx - 1 - i];
        buf[idx - 1 - i] = tmp;
    }
    buf[idx] = '\0';
    return string(buf, static_cast<size_t>(idx));
}

/// double_toStringAsExponential — 双精度浮点数科学计数法字符串
inline string double_toStringAsExponential(double value, int64_t fracDigits) {
    if (fracDigits < 0) fracDigits = 0;
    std::ostringstream oss;
    oss << std::scientific << std::setprecision(static_cast<int>(fracDigits)) << value;
    auto tmp = oss.str();
    return string(tmp.data(), tmp.size());
}

/// double_toStringAsFixed — 定点小数（替代生成代码中的 ostringstream IIFE）
inline string double_toStringAsFixed(double value, int64_t fracDigits) {
    if (fracDigits < 0) fracDigits = 0;
    std::ostringstream oss;
    oss << std::fixed << std::setprecision(static_cast<int>(fracDigits)) << value;
    auto tmp = oss.str();
    return string(tmp.data(), tmp.size());
}

/// double_toStringAsPrecision — 指定有效位数
inline string double_toStringAsPrecision(double value, int64_t precision) {
    if (precision <= 0) precision = 1;
    std::ostringstream oss;
    oss << std::setprecision(static_cast<int>(precision)) << value;
    auto tmp = oss.str();
    return string(tmp.data(), tmp.size());
}

// ============================================================================
// 12. Duration / DateTime / RegExp 包装
// ============================================================================

struct DurationClassInfo : ClassInfo {
    constexpr DurationClassInfo();
    int64_t(*get_inDays)(AnyGC*) = nullptr;
    int64_t(*get_inHours)(AnyGC*) = nullptr;
    int64_t(*get_inMinutes)(AnyGC*) = nullptr;
    int64_t(*get_inSeconds)(AnyGC*) = nullptr;
    int64_t(*get_inMilliseconds)(AnyGC*) = nullptr;
    int64_t(*get_inMicroseconds)(AnyGC*) = nullptr;
};

struct Duration : AnyGC {
    static const DurationClassInfo _classInfo;
    int64_t inMicroseconds;

    Duration(int64_t us = 0) : inMicroseconds(us) {
        AnyGC::_classInfo = &_classInfo;
    }

    Duration(int64_t days, int64_t hours, int64_t minutes, int64_t seconds,
                   int64_t milliseconds = 0, int64_t microseconds = 0)
        : inMicroseconds(
              days * 86400000000LL +
              hours * 3600000000LL +
              minutes * 60000000LL +
              seconds * 1000000LL +
              milliseconds * 1000LL +
              microseconds) {
        AnyGC::_classInfo = &_classInfo;
    }

    static Duration* milliseconds(int64_t ms) { return GC::allocateLocal(new Duration(ms * 1000)); }
    static Duration* seconds(int64_t s) { return GC::allocateLocal(new Duration(s * 1000000)); }
    static Duration* minutes(int64_t m) { return GC::allocateLocal(new Duration(m * 60000000LL)); }
    static Duration* hours(int64_t h) { return GC::allocateLocal(new Duration(h * 3600000000LL)); }
    static Duration* days(int64_t d) { return GC::allocateLocal(new Duration(d * 86400000000LL)); }

    int64_t inMilliseconds() const { return inMicroseconds / 1000; }
    int64_t inSeconds() const { return inMicroseconds / 1000000; }
    int64_t inMinutes() const { return inMicroseconds / 60000000LL; }
    int64_t inHours() const { return inMicroseconds / 3600000000LL; }
    int64_t inDays() const { return inMicroseconds / 86400000000LL; }

    // ── ClassInfo dispatch ──
    static AnyGC* _vptr_toString(AnyGC* self) {
        auto* dur = static_cast<Duration*>(self);
        int64_t totalUs = dur->inMicroseconds;
        bool negative = totalUs < 0;
        if (negative) totalUs = -totalUs;
        int64_t h = totalUs / 3600000000LL;
        int64_t rem = totalUs % 3600000000LL;
        int64_t m = rem / 60000000LL;
        rem %= 60000000LL;
        int64_t s = rem / 1000000LL;
        int64_t us = rem % 1000000LL;
        std::ostringstream oss;
        if (negative) oss << "-";
        oss << h << ":"
            << std::setfill('0') << std::setw(2) << m << ":"
            << std::setfill('0') << std::setw(2) << s << "."
            << std::setfill('0') << std::setw(6) << us;
        return _box(oss.str());
    }
    static AnyGC* _vptr_runtimeType(AnyGC* self) {
        return _box(string("Duration"));
    }
    static bool _vptr_eq(AnyGC* self, AnyGC* other) {
        return static_cast<Duration*>(self)->inMicroseconds == static_cast<Duration*>(other)->inMicroseconds;
    }
    static int64_t _vptr_hashCode(AnyGC* self) {
        return static_cast<Duration*>(self)->inMicroseconds;
    }
    static int64_t _vptr_inDays(AnyGC* self) {
        return static_cast<Duration*>(self)->inMicroseconds / 86400000000LL;
    }
    static int64_t _vptr_inHours(AnyGC* self) {
        return static_cast<Duration*>(self)->inMicroseconds / 3600000000LL;
    }
    static int64_t _vptr_inMinutes(AnyGC* self) {
        return static_cast<Duration*>(self)->inMicroseconds / 60000000LL;
    }
    static int64_t _vptr_inSeconds(AnyGC* self) {
        return static_cast<Duration*>(self)->inMicroseconds / 1000000;
    }
    static int64_t _vptr_inMilliseconds(AnyGC* self) {
        return static_cast<Duration*>(self)->inMicroseconds / 1000;
    }
    static int64_t _vptr_inMicroseconds(AnyGC* self) {
        return static_cast<Duration*>(self)->inMicroseconds;
    }
    static void _gcMark_impl(AnyGC* self, int flag) {}
};

inline constexpr DurationClassInfo::DurationClassInfo() {
    typeName = "Duration";
    destroy = &_gcDestroy<Duration>;
    gcMark = &Duration::_gcMark_impl;
    toString = &Duration::_vptr_toString;
    get_runtimeType = &Duration::_vptr_runtimeType;
    eq = &Duration::_vptr_eq;
    get_hashCode = &Duration::_vptr_hashCode;
    get_inDays = &Duration::_vptr_inDays;
    get_inHours = &Duration::_vptr_inHours;
    get_inMinutes = &Duration::_vptr_inMinutes;
    get_inSeconds = &Duration::_vptr_inSeconds;
    get_inMilliseconds = &Duration::_vptr_inMilliseconds;
    get_inMicroseconds = &Duration::_vptr_inMicroseconds;
}
inline constexpr DurationClassInfo Duration::_classInfo{};

struct DateTimeClassInfo : ClassInfo {
    constexpr DateTimeClassInfo();
    int64_t(*get_year)(AnyGC*) = nullptr;
    int64_t(*get_month)(AnyGC*) = nullptr;
    int64_t(*get_day)(AnyGC*) = nullptr;
    int64_t(*get_hour)(AnyGC*) = nullptr;
    int64_t(*get_minute)(AnyGC*) = nullptr;
    int64_t(*get_second)(AnyGC*) = nullptr;
    int64_t(*get_millisecond)(AnyGC*) = nullptr;
    int64_t(*get_weekday)(AnyGC*) = nullptr;
    int64_t(*get_millisecondsSinceEpoch)(AnyGC*) = nullptr;
    int64_t(*get_microsecondsSinceEpoch)(AnyGC*) = nullptr;
    bool(*get_isUtc)(AnyGC*) = nullptr;
    AnyGC*(*toIso8601String)(AnyGC*) = nullptr;
    int64_t(*get_microsecond)(AnyGC*) = nullptr;
    AnyGC*(*add)(AnyGC*, AnyGC*) = nullptr;
    AnyGC*(*subtract)(AnyGC*, AnyGC*) = nullptr;
    AnyGC*(*difference)(AnyGC*, AnyGC*) = nullptr;
    bool(*isBefore)(AnyGC*, AnyGC*) = nullptr;
    bool(*isAfter)(AnyGC*, AnyGC*) = nullptr;
    bool(*isAtSameMomentAs)(AnyGC*, AnyGC*) = nullptr;
    AnyGC*(*toUtc)(AnyGC*) = nullptr;
    AnyGC*(*toLocal)(AnyGC*) = nullptr;
};

struct DateTime : AnyGC {
    static const DateTimeClassInfo _classInfo;
    int64_t _epochUs;
    bool _isUtc = false;

    // tag type to disambiguate the internal microseconds constructor from the public milliseconds one
    struct _MicrosecondsTag {};

    DateTime() : _epochUs(0), _isUtc(false) {
        AnyGC::_classInfo = &_classInfo;
    }
    DateTime(int64_t epochMs, bool utc = false) : _epochUs(epochMs * 1000), _isUtc(utc) {
        AnyGC::_classInfo = &_classInfo;
    }
    DateTime(int64_t epochUs, bool utc, _MicrosecondsTag) : _epochUs(epochUs), _isUtc(utc) {
        AnyGC::_classInfo = &_classInfo;
    }

    DateTime(int64_t year, int64_t month, int64_t day,
                   int64_t hour = 0, int64_t minute = 0, int64_t second = 0,
                   int64_t millisecond = 0, int64_t microsecond = 0, bool utc = false)
        : _isUtc(utc) {
        AnyGC::_classInfo = &_classInfo;
        struct tm t = {};
        t.tm_year = static_cast<int>(year - 1900);
        t.tm_mon = static_cast<int>(month - 1);
        t.tm_mday = static_cast<int>(day);
        t.tm_hour = static_cast<int>(hour);
        t.tm_min = static_cast<int>(minute);
        t.tm_sec = static_cast<int>(second);
        time_t time;
        if (utc) {
            time = timegm(&t);
        } else {
            time = mktime(&t);
        }
        _epochUs = static_cast<int64_t>(time) * 1000000 + millisecond * 1000 + microsecond;
    }

    // ── tm 缓存（_epochUs 不可变，缓存有效期为对象生命周期） ──
    mutable struct tm _cachedTm{};
    mutable bool _tmValid = false;
    const struct tm* getTm() const {
        if (!_tmValid) {
            time_t time = static_cast<time_t>(_epochUs / 1000000);
            struct tm* t = _isUtc ? std::gmtime(&time) : std::localtime(&time);
            if (t) { _cachedTm = *t; _tmValid = true; }
        }
        return _tmValid ? &_cachedTm : nullptr;
    }

    // ── 静态工厂（指针语义：GC 堆分配） ──

    static DateTime* now() {
        auto now = std::chrono::system_clock::now();
        auto us = std::chrono::duration_cast<std::chrono::microseconds>(
            now.time_since_epoch()).count();
        return GC::allocateLocal(new DateTime(static_cast<int64_t>(us), false, _MicrosecondsTag{}));
    }

    static DateTime* utc(int64_t year, int64_t month = 1, int64_t day = 1,
                              int64_t hour = 0, int64_t minute = 0, int64_t second = 0,
                              int64_t millisecond = 0, int64_t microsecond = 0) {
        return GC::allocateLocal(new DateTime(year, month, day, hour, minute, second, millisecond, microsecond, true));
    }

    static DateTime* parse(const string& formattedString) {
        struct tm t = {};
        int ms = 0;
        if (sscanf(formattedString.c_str(), "%d-%d-%dT%d:%d:%d.%d",
                   &t.tm_year, &t.tm_mon, &t.tm_mday, &t.tm_hour, &t.tm_min, &t.tm_sec, &ms) >= 3) {
            t.tm_year -= 1900; t.tm_mon -= 1;
            return GC::allocateLocal(new DateTime(static_cast<int64_t>(timegm(&t)) * 1000000 + ms * 1000, true, _MicrosecondsTag{}));
        }
        if (sscanf(formattedString.c_str(), "%d-%d-%d %d:%d:%d.%d",
                   &t.tm_year, &t.tm_mon, &t.tm_mday, &t.tm_hour, &t.tm_min, &t.tm_sec, &ms) >= 3) {
            t.tm_year -= 1900; t.tm_mon -= 1;
            return GC::allocateLocal(new DateTime(static_cast<int64_t>(mktime(&t)) * 1000000 + ms * 1000, false, _MicrosecondsTag{}));
        }
        if (sscanf(formattedString.c_str(), "%d-%d-%d",
                   &t.tm_year, &t.tm_mon, &t.tm_mday) >= 3) {
            t.tm_year -= 1900; t.tm_mon -= 1;
            return GC::allocateLocal(new DateTime(static_cast<int64_t>(mktime(&t)) * 1000000, false, _MicrosecondsTag{}));
        }
        throw DartFormatException("Invalid date format: " + formattedString);
    }

    static DateTime* tryParse(const string& formattedString) {
        try { return parse(formattedString); }
        catch (...) { throw DartFormatException("Invalid date format: " + formattedString); }
    }

    static DateTime* fromMillisecondsSinceEpoch(int64_t milliseconds, bool isUtc = false) {
        return GC::allocateLocal(new DateTime(milliseconds, isUtc));
    }

    static DateTime* fromMicrosecondsSinceEpoch(int64_t microseconds, bool isUtc = false) {
        return GC::allocateLocal(new DateTime(microseconds, isUtc, _MicrosecondsTag{}));
    }

    // ── ClassInfo dispatch ──
    static AnyGC* _vptr_toString(AnyGC* self) {
        auto* dt = static_cast<DateTime*>(self);
        const struct tm* t = dt->getTm();
        if (!t) return _box(string("Invalid Date"));
        char buf[40];
        snprintf(buf, sizeof(buf), "%04d-%02d-%02d %02d:%02d:%02d.%03lld",
                 t->tm_year + 1900, t->tm_mon + 1, t->tm_mday,
                 t->tm_hour, t->tm_min, t->tm_sec,
                 static_cast<long long>((dt->_epochUs / 1000) % 1000));
        return _box(string(buf));
    }
    static AnyGC* _vptr_runtimeType(AnyGC* self) {
        return _box(string("DateTime"));
    }
    static bool _vptr_eq(AnyGC* self, AnyGC* other) {
        auto* a = static_cast<DateTime*>(self);
        auto* b = static_cast<DateTime*>(other);
        return a->_epochUs == b->_epochUs && a->_isUtc == b->_isUtc;
    }
    static int64_t _vptr_hashCode(AnyGC* self) {
        return static_cast<DateTime*>(self)->_epochUs;
    }
    static int64_t _vptr_year(AnyGC* self) {
        auto* dt = static_cast<DateTime*>(self);
        const struct tm* t = dt->getTm();
        return t ? t->tm_year + 1900 : 0;
    }
    static int64_t _vptr_month(AnyGC* self) {
        auto* dt = static_cast<DateTime*>(self);
        const struct tm* t = dt->getTm();
        return t ? t->tm_mon + 1 : 0;
    }
    static int64_t _vptr_day(AnyGC* self) {
        auto* dt = static_cast<DateTime*>(self);
        const struct tm* t = dt->getTm();
        return t ? t->tm_mday : 0;
    }
    static int64_t _vptr_hour(AnyGC* self) {
        auto* dt = static_cast<DateTime*>(self);
        const struct tm* t = dt->getTm();
        return t ? t->tm_hour : 0;
    }
    static int64_t _vptr_minute(AnyGC* self) {
        auto* dt = static_cast<DateTime*>(self);
        const struct tm* t = dt->getTm();
        return t ? t->tm_min : 0;
    }
    static int64_t _vptr_second(AnyGC* self) {
        auto* dt = static_cast<DateTime*>(self);
        const struct tm* t = dt->getTm();
        return t ? t->tm_sec : 0;
    }
    static int64_t _vptr_millisecond(AnyGC* self) {
        auto* dt = static_cast<DateTime*>(self);
        return (dt->_epochUs / 1000) % 1000;
    }
    static int64_t _vptr_weekday(AnyGC* self) {
        auto* dt = static_cast<DateTime*>(self);
        const struct tm* t = dt->getTm();
        if (!t) return 0;
        return t->tm_wday == 0 ? 7 : t->tm_wday;
    }
    static int64_t _vptr_millisecondsSinceEpoch(AnyGC* self) {
        return static_cast<DateTime*>(self)->_epochUs / 1000;
    }
    static int64_t _vptr_microsecondsSinceEpoch(AnyGC* self) {
        return static_cast<DateTime*>(self)->_epochUs;
    }
    static bool _vptr_isUtc(AnyGC* self) {
        return static_cast<DateTime*>(self)->_isUtc;
    }
    static AnyGC* _vptr_toIso8601String(AnyGC* self) {
        auto* dt = static_cast<DateTime*>(self);
        const struct tm* t = dt->getTm();
        if (!t) return _box(string("Invalid Date"));
        char buf[40];
        snprintf(buf, sizeof(buf), "%04d-%02d-%02dT%02d:%02d:%02d.%03lld%s",
                 t->tm_year + 1900, t->tm_mon + 1, t->tm_mday,
                 t->tm_hour, t->tm_min, t->tm_sec,
                 static_cast<long long>((dt->_epochUs / 1000) % 1000),
                 dt->_isUtc ? "Z" : "");
        return _box(string(buf));
    }
    static int64_t _vptr_microsecond(AnyGC* self) {
        return static_cast<DateTime*>(self)->_epochUs % 1000;
    }
    static AnyGC* _vptr_add(AnyGC* self, AnyGC* duration) {
        auto* dt = static_cast<DateTime*>(self);
        auto* dur = static_cast<Duration*>(duration);
        return GC::allocateLocal(new DateTime(dt->_epochUs + dur->inMicroseconds, dt->_isUtc, _MicrosecondsTag{}));
    }
    static AnyGC* _vptr_subtract(AnyGC* self, AnyGC* duration) {
        auto* dt = static_cast<DateTime*>(self);
        auto* dur = static_cast<Duration*>(duration);
        return GC::allocateLocal(new DateTime(dt->_epochUs - dur->inMicroseconds, dt->_isUtc, _MicrosecondsTag{}));
    }
    static AnyGC* _vptr_difference(AnyGC* self, AnyGC* other) {
        auto* dt = static_cast<DateTime*>(self);
        auto* odt = static_cast<DateTime*>(other);
        return GC::allocateLocal(new Duration(dt->_epochUs - odt->_epochUs));
    }
    static bool _vptr_isBefore(AnyGC* self, AnyGC* other) {
        return static_cast<DateTime*>(self)->_epochUs < static_cast<DateTime*>(other)->_epochUs;
    }
    static bool _vptr_isAfter(AnyGC* self, AnyGC* other) {
        return static_cast<DateTime*>(self)->_epochUs > static_cast<DateTime*>(other)->_epochUs;
    }
    static bool _vptr_isAtSameMomentAs(AnyGC* self, AnyGC* other) {
        return static_cast<DateTime*>(self)->_epochUs == static_cast<DateTime*>(other)->_epochUs;
    }
    static AnyGC* _vptr_toUtc(AnyGC* self) {
        auto* dt = static_cast<DateTime*>(self);
        return GC::allocateLocal(new DateTime(dt->_epochUs, true, _MicrosecondsTag{}));
    }
    static AnyGC* _vptr_toLocal(AnyGC* self) {
        auto* dt = static_cast<DateTime*>(self);
        return GC::allocateLocal(new DateTime(dt->_epochUs, false, _MicrosecondsTag{}));
    }
    static void _gcMark_impl(AnyGC* self, int flag) {}
};

inline constexpr DateTimeClassInfo::DateTimeClassInfo() {
    typeName = "DateTime";
    destroy = &_gcDestroy<DateTime>;
    gcMark = &DateTime::_gcMark_impl;
    toString = &DateTime::_vptr_toString;
    get_runtimeType = &DateTime::_vptr_runtimeType;
    eq = &DateTime::_vptr_eq;
    get_hashCode = &DateTime::_vptr_hashCode;
    get_year = &DateTime::_vptr_year;
    get_month = &DateTime::_vptr_month;
    get_day = &DateTime::_vptr_day;
    get_hour = &DateTime::_vptr_hour;
    get_minute = &DateTime::_vptr_minute;
    get_second = &DateTime::_vptr_second;
    get_millisecond = &DateTime::_vptr_millisecond;
    get_weekday = &DateTime::_vptr_weekday;
    get_millisecondsSinceEpoch = &DateTime::_vptr_millisecondsSinceEpoch;
    get_microsecondsSinceEpoch = &DateTime::_vptr_microsecondsSinceEpoch;
    get_isUtc = &DateTime::_vptr_isUtc;
    toIso8601String = &DateTime::_vptr_toIso8601String;
    get_microsecond = &DateTime::_vptr_microsecond;
    add = &DateTime::_vptr_add;
    subtract = &DateTime::_vptr_subtract;
    difference = &DateTime::_vptr_difference;
    isBefore = &DateTime::_vptr_isBefore;
    isAfter = &DateTime::_vptr_isAfter;
    isAtSameMomentAs = &DateTime::_vptr_isAtSameMomentAs;
    toUtc = &DateTime::_vptr_toUtc;
    toLocal = &DateTime::_vptr_toLocal;
}
inline constexpr DateTimeClassInfo DateTime::_classInfo{};

struct RegExpMatch : AnyGC {
    string fullMatch;
    std::vector<string> groups;
    int startPos = 0;
    int endPos = 0;

    RegExpMatch() { AnyGC::_classInfo = &_classInfo; }

    string group(int index) const {
        if (index == 0) return fullMatch;
        if (index > 0 && index <= static_cast<int>(groups.size())) return groups[index - 1];
        return "";
    }
    int groupCount() const { return static_cast<int>(groups.size()); }
    int start() const { return startPos; }
    int end() const { return endPos; }
    string toString() const { return fullMatch; }

    static const ClassInfo _classInfo;
    static AnyGC* _vptr_toString(AnyGC* self);
    static AnyGC* _vptr_runtimeType(AnyGC*);
    static void _gcMark_impl(AnyGC* self, int flag) {}
};

inline constexpr ClassInfo RegExpMatch::_classInfo = []() constexpr {
    ClassInfo ci;
    ci.typeName = "RegExpMatch";
    ci.destroy = &_gcDestroy<RegExpMatch>;
    ci.gcMark = &RegExpMatch::_gcMark_impl;
    ci.toString = &RegExpMatch::_vptr_toString;
    ci.get_runtimeType = &RegExpMatch::_vptr_runtimeType;
    return ci;
}();

inline AnyGC* RegExpMatch::_vptr_toString(AnyGC* self) {
    return _box(static_cast<RegExpMatch*>(self)->fullMatch);
}
inline AnyGC* RegExpMatch::_vptr_runtimeType(AnyGC*) {
    return _box(string("RegExpMatch"));
}

inline string _toStr(const RegExpMatch& v) {
    return v.toString();
}

struct RegExpClassInfo : ClassInfo {
    AnyGC*(*get_pattern)(AnyGC*) = nullptr;
    bool(*hasMatch)(AnyGC*, AnyGC*) = nullptr;
    AnyGC*(*firstMatch)(AnyGC*, AnyGC*) = nullptr;
    AnyGC*(*allMatches)(AnyGC*, AnyGC*) = nullptr;
    AnyGC*(*matchAsPrefix)(AnyGC*, AnyGC*) = nullptr;
    constexpr RegExpClassInfo();
};

struct RegExp : AnyGC {
    static const RegExpClassInfo _classInfo;
    string pattern;
    std::regex _regex;
    bool _isMultiLine = false;
    bool _isCaseSensitive = true;
    bool _isUnicode = false;
    bool _isDotAll = false;

    RegExp(const string& source,
                 bool multiLine = false, bool caseSensitive = true,
                 bool unicode = false, bool dotAll = false)
        : pattern(source), _isMultiLine(multiLine),
          _isCaseSensitive(caseSensitive), _isUnicode(unicode), _isDotAll(dotAll) {
        AnyGC::_classInfo = &_classInfo;
        if (unicode) {
            throw DartUnsupportedError("RegExp unicode flag is not supported in C++ runtime");
        }
        if (dotAll) {
            throw DartUnsupportedError("RegExp dotAll flag is not supported in C++ runtime");
        }
        auto flags = std::regex::ECMAScript;
        if (multiLine) flags |= std::regex::multiline;
        if (!caseSensitive) flags |= std::regex::icase;
        _regex = std::regex(source.c_str(), flags);
    }

    bool hasMatch(const string& input) const {
        try { return std::regex_search(input.cbegin(), input.cend(), _regex); }
        catch (...) { return false; }
    }

    RegExpMatch* firstMatch(const string& input) const {
        std::cmatch m;
        if (std::regex_search(input.cbegin(), input.cend(), m, _regex)) {
            auto* result = GC::allocateLocal(new RegExpMatch());
            auto mf = m[0].str();
            result->fullMatch = string(mf.data(), mf.size());
            result->startPos = static_cast<int>(m.position(0));
            result->endPos = result->startPos + static_cast<int>(m.length(0));
            for (size_t i = 1; i < m.size(); i++) {
                if (m[i].matched) {
                    auto g = m[i].str();
                    result->groups.push_back(string(g.data(), g.size()));
                } else {
                    result->groups.push_back(string(""));
                }
            }
            return result;
        }
        return nullptr;
    }

    List<RegExpMatch*>* allMatches(const string& str, int start = 0) const {
        auto* result = new List<RegExpMatch*>();
        if (start < 0) start = 0;
        if (start >= static_cast<int>(str.length())) return GC::allocateLocal(result);
        string s = str.substr(start);
        std::cmatch m;
        string::const_iterator searchStart = s.cbegin();
        int offset = start;
        while (searchStart != s.cend() && std::regex_search(searchStart, s.cend(), m, _regex)) {
            auto* match = GC::allocateLocal(new RegExpMatch());
            { auto mf = m[0].str(); match->fullMatch = string(mf.data(), mf.size()); }
            match->startPos = static_cast<int>(m[0].first - s.cbegin()) + offset;
            match->endPos = match->startPos + static_cast<int>(m.length(0));
            for (size_t i = 1; i < m.size(); i++) {
                if (m[i].matched) { auto g = m[i].str(); match->groups.push_back(string(g.data(), g.size())); }
                else match->groups.push_back(string(""));
            }
            result->_data->_storage.push_back(match);
            if (m[0].second == searchStart) {
                ++searchStart;
                offset++;
            } else {
                searchStart = m[0].second;
                offset = start + static_cast<int>(searchStart - s.cbegin());
            }
        }
        return GC::allocateLocal(result);
    }

    RegExpMatch* matchAsPrefix(const string& str, int startPos = 0) const {
        if (startPos < 0 || startPos >= static_cast<int>(str.length())) return nullptr;
        std::cmatch m;
        auto begin = str.cbegin() + startPos;
        auto end = str.cend();
        if (std::regex_search(begin, end, m, _regex, std::regex_constants::match_continuous)) {
            auto* result = GC::allocateLocal(new RegExpMatch());
            { auto mf = m[0].str(); result->fullMatch = string(mf.data(), mf.size()); }
            result->startPos = startPos;
            result->endPos = startPos + static_cast<int>(m.length(0));
            for (size_t i = 1; i < m.size(); i++) {
                if (m[i].matched) { auto g = m[i].str(); result->groups.push_back(string(g.data(), g.size())); }
                else result->groups.push_back(string(""));
            }
            return result;
        }
        return nullptr;
    }

    string getPattern() const { return pattern; }
    bool getIsMultiLine() const { return _isMultiLine; }
    bool getIsCaseSensitive() const { return _isCaseSensitive; }
    bool getIsUnicode() const { return _isUnicode; }
    bool getIsDotAll() const { return _isDotAll; }

    static string escape(const string& text) {
        string result;
        for (char c : text) {
            if (string("\\.^$|?*+()[]{}").find(c) != string::npos) {
                result += '\\';
            }
            result += c;
        }
        return result;
    }

    string toString() const { return "RegExp(" + pattern + ")"; }

    // ── ClassInfo dispatch ──
    static AnyGC* _vptr_toString(AnyGC* self) {
        return _box(static_cast<RegExp*>(self)->toString());
    }
    static AnyGC* _vptr_runtimeType(AnyGC*) { return _box(string("RegExp")); }
    static bool _vptr_eq(AnyGC* self, AnyGC* other) {
        auto* a = static_cast<RegExp*>(self);
        auto* b = static_cast<RegExp*>(other);
        return a->pattern == b->pattern && a->_isMultiLine == b->_isMultiLine &&
               a->_isCaseSensitive == b->_isCaseSensitive;
    }
    static int64_t _vptr_hashCode(AnyGC* self) {
        return static_cast<int64_t>(std::hash<string>{}(static_cast<RegExp*>(self)->pattern));
    }
    static AnyGC* _vptr_get_pattern(AnyGC* self) {
        return _box(static_cast<RegExp*>(self)->pattern);
    }
    static bool _vptr_hasMatch(AnyGC* self, AnyGC* input) {
        return static_cast<RegExp*>(self)->hasMatch(dynAs<string>(input));
    }
    static AnyGC* _vptr_firstMatch(AnyGC* self, AnyGC* input) {
        return static_cast<AnyGC*>(static_cast<RegExp*>(self)->firstMatch(dynAs<string>(input)));
    }
    static AnyGC* _vptr_allMatches(AnyGC* self, AnyGC* input) {
        return static_cast<AnyGC*>(static_cast<RegExp*>(self)->allMatches(dynAs<string>(input)));
    }
    static AnyGC* _vptr_matchAsPrefix(AnyGC* self, AnyGC* input) {
        return static_cast<AnyGC*>(static_cast<RegExp*>(self)->matchAsPrefix(dynAs<string>(input)));
    }
    static void _gcMark_impl(AnyGC* self, int flag) {}
};

inline constexpr RegExpClassInfo::RegExpClassInfo() {
    typeName = "RegExp";
    destroy = &_gcDestroy<RegExp>;
    gcMark = &RegExp::_gcMark_impl;
    toString = &RegExp::_vptr_toString;
    get_runtimeType = &RegExp::_vptr_runtimeType;
    eq = &RegExp::_vptr_eq;
    get_hashCode = &RegExp::_vptr_hashCode;
    get_pattern = &RegExp::_vptr_get_pattern;
    hasMatch = &RegExp::_vptr_hasMatch;
    firstMatch = &RegExp::_vptr_firstMatch;
    allMatches = &RegExp::_vptr_allMatches;
    matchAsPrefix = &RegExp::_vptr_matchAsPrefix;
}
inline constexpr RegExpClassInfo RegExp::_classInfo{};

/// string_replaceAll — RegExp 重载（正则语义）
inline string string_replaceAll(const string& s, RegExp* re, const string& to) {
    if (!re) return s;
    try {
        std::string out = std::regex_replace(std::string(s.cbegin(), s.cend()), re->_regex,
                                             std::string(to.cbegin(), to.cend()));
        return string(out.data(), out.size());
    } catch (...) { return s; }
}

/// string_split — RegExp 重载（正则语义）
inline List<string>* string_split(const string& s, RegExp* re) {
    auto* result = new List<string>();
    if (!re) { result->_data->_storage.push_back(s); return GC::allocateLocal(result); }
    try {
        std::string str(s.cbegin(), s.cend());
        std::sregex_token_iterator it(str.begin(), str.end(), re->_regex, -1);
        std::sregex_token_iterator end;
        for (; it != end; ++it) {
            auto part = it->str();
            result->_data->_storage.push_back(string(part.data(), part.size()));
        }
    } catch (...) {
        result->_data->_storage.push_back(s);
    }
    return GC::allocateLocal(result);
}

// ============================================================================
// Utility functions for collection operations
// ============================================================================

template<typename T>
List<T>* unmodifiable(List<T>* source) {
    return of(source);
}

template<typename T>
List<T>* of(List<T>* source) {
    if (!source) return GC::allocateLocal(new List<T>());
    return List<T>::from(source);
}

template<typename K, typename V>
Map<K, V>* of(Map<K, V>* source) {
    if (!source) return GC::allocateLocal(new Map<K, V>());
    auto* result = GC::allocateLocal(new Map<K, V>());
    for (int i = 0; i < source->_keys->_storage.size(); i++) {
        result->_keys->_storage.push_back(source->_keys->_storage[i]);
        result->_values->_storage.push_back(source->_values->_storage[i]);
    }
    return result;
}

template<typename T>
Set<T>* of(Set<T>* source) {
    if (!source) return GC::allocateLocal(new Set<T>());
    auto* result = GC::allocateLocal(new Set<T>());
    for (int i = 0; i < source->_data->_storage.size(); i++) {
        result->_data->_storage.push_back(source->_data->_storage[i]);
    }
    return result;
}

template<typename K, typename V>
Map<K, V>* fromEntries(List<MapEntry<K, V>*>* entries) {
    if (!entries) return Map<K, V>::empty();
    return Map<K, V>::fromEntries(entries);
}


// StreamValue - wrapper struct for Stream (simplified as List)
template<typename T>
struct StreamValueClassInfo : ClassInfo {
    AnyGC*(*toList)(AnyGC*) = nullptr;
    AnyGC*(*map)(AnyGC*, AnyGC*) = nullptr;
    AnyGC*(*where)(AnyGC*, AnyGC*) = nullptr;
    AnyGC*(*fold)(AnyGC*, AnyGC*, AnyGC*) = nullptr;
    constexpr StreamValueClassInfo();
};

template<typename T>
struct StreamValue : AnyGC {
    List<T>* data;
    static const StreamValueClassInfo<T> _classInfo;

    StreamValue() : data(GC::allocateLocal(new List<T>())) { AnyGC::_classInfo = &StreamValue::_classInfo; }
    StreamValue(List<T>* d) : data(d) { AnyGC::_classInfo = &StreamValue::_classInfo; }

    static void _gcMark_impl(AnyGC* self, int flag) {
        auto* s = static_cast<StreamValue*>(self);
        if (s->data) _gcMark(s->data, flag);
    }

    // ── ClassInfo dispatch ──
    static AnyGC* _vptr_toList(AnyGC* self) {
        return static_cast<AnyGC*>(static_cast<StreamValue*>(self)->data);
    }
    static AnyGC* _vptr_map(AnyGC* self, AnyGC* func) {
        auto* s = static_cast<StreamValue*>(self);
        auto* tf = static_cast<TypeFunction1<AnyGC*, T>*>(func);
        auto* mapped = GC::allocateLocal(new List<AnyGC*>());
        for (int i = 0; i < s->data->_data->_storage.size(); i++) {
            mapped->_data->_storage.push_back(dynAs<AnyGC*>(tf->fnPtr(tf, _boxElem(s->data->_data->_storage[i]))));
        }
        return static_cast<AnyGC*>(GC::allocateLocal(new StreamValue<AnyGC*>(mapped)));
    }
    static AnyGC* _vptr_where(AnyGC* self, AnyGC* test) {
        auto* s = static_cast<StreamValue*>(self);
        auto* tf = static_cast<TypeFunction1<bool, T>*>(test);
        auto* filtered = GC::allocateLocal(new List<T>());
        for (int i = 0; i < s->data->_data->_storage.size(); i++) {
            if (_predApply(tf, s->data->_data->_storage[i])) {
                filtered->_data->_storage.push_back(s->data->_data->_storage[i]);
            }
        }
        return static_cast<AnyGC*>(GC::allocateLocal(new StreamValue<T>(filtered)));
    }
    static AnyGC* _vptr_fold(AnyGC* self, AnyGC* initial, AnyGC* combine) {
        auto* s = static_cast<StreamValue*>(self);
        auto* cmp = static_cast<TypeFunction2<AnyGC*, AnyGC*, T>*>(combine);
        AnyGC* value = initial;
        for (int i = 0; i < s->data->_data->_storage.size(); i++) {
            value = cmp->fnPtr(cmp, value, _boxElem(s->data->_data->_storage[i]));
        }
        return value;
    }
};

// Static member definition
template<typename T>
constexpr StreamValueClassInfo<T>::StreamValueClassInfo() {
    typeName = "Stream";
    destroy = &_gcDestroy<StreamValue<T>>;
    gcMark = &StreamValue<T>::_gcMark_impl;
    toList = &StreamValue<T>::_vptr_toList;
    map = &StreamValue<T>::_vptr_map;
    where = &StreamValue<T>::_vptr_where;
    fold = &StreamValue<T>::_vptr_fold;
}

template<typename T>
inline constexpr StreamValueClassInfo<T> StreamValue<T>::_classInfo{};

// Free function wrappers for StreamValue — dispatch through ClassInfo
inline AnyGC* stream_to_list(AnyGC* self) {
    auto* ci = static_cast<const StreamValueClassInfo<AnyGC*>*>(self->_classInfo);
    return ci->toList ? ci->toList(self) : nullptr;
}
inline AnyGC* stream_map(AnyGC* self, AnyGC* func) {
    auto* ci = static_cast<const StreamValueClassInfo<AnyGC*>*>(self->_classInfo);
    return ci->map ? ci->map(self, func) : nullptr;
}
inline AnyGC* stream_where(AnyGC* self, AnyGC* test) {
    auto* ci = static_cast<const StreamValueClassInfo<AnyGC*>*>(self->_classInfo);
    return ci->where ? ci->where(self, test) : nullptr;
}
inline AnyGC* stream_fold(AnyGC* self, AnyGC* initial, AnyGC* combine) {
    auto* ci = static_cast<const StreamValueClassInfo<AnyGC*>*>(self->_classInfo);
    return ci->fold ? ci->fold(self, initial, combine) : nullptr;
}

// ============================================================================
// 15. 表达式辅助 — 消除生成代码中的 IIFE lambda
// ============================================================================
// （double_toStringAsFixed / double_toStringAsPrecision 见第 11 节）

/// list_filled — Dart List.filled(count, value)
template<typename T>
inline List<T>* list_filled(int64_t count, T value) {
    auto* list = new List<T>();
    list->_data->_storage.reserve(static_cast<int>(count));
    for (int64_t i = 0; i < count; i++) list->_data->_storage.push_back(value);
    return GC::allocateLocal(list);
}

/// list_generated — Dart List.generate(count, generator)
template<typename T>
inline List<T>* list_generated(int64_t count, TypeFunction* gen) {
    return List<T>::generate(static_cast<int>(count), static_cast<TypeFunction1<T, int64_t>*>(gen));
}

/// mapOf — Map 字面量构造（花括号初始化列表保证从左到右求值）
template<typename K, typename V>
inline Map<K, V>* mapOf(std::initializer_list<MapEntry<K, V>*> entries) {
    auto* m = new Map<K, V>();
    for (auto* e : entries) { if (e) m->set(e->key, e->value); }
    return GC::allocateLocal(m);
}

/// dart_compareTo — compareTo 的指针/值类型统一分派
template<typename T, typename U>
inline int64_t dart_compareTo(const T& a, const U& b) {
    if constexpr (std::is_pointer_v<T>) {
        auto* gc = static_cast<AnyGC*>(a);
        if (gc && gc->_classInfo && gc->_classInfo->compareTo) {
            return gc->_classInfo->compareTo(gc, _boxElem(b));
        }
        return 0;
    } else {
        return (a > b ? 1LL : (a < b ? -1LL : 0LL));
    }
}

/// to_string_boxed — toString 的指针/值类型统一分派（返回装箱结果）
template<typename T>
inline AnyGC* to_string_boxed(const T& v) {
    if constexpr (std::is_pointer_v<T>) {
        auto* gc = static_cast<AnyGC*>(v);
        if (gc && gc->_classInfo && gc->_classInfo->toString) {
            return gc->_classInfo->toString(gc);
        }
        return gc;
    } else {
        return _box(dart_str(v));
    }
}

/// stream_to_list_promise — Stream.toList() → 已完成的 Promise<List<T>>
template<typename T>
inline Promise<List<T>*>* stream_to_list_promise(AnyGC* stream) {
    auto* promise = GC::allocateLocal(new Promise<List<T>*>());
    promise_complete(promise, _box(stream_to_list(stream)));
    return promise;
}

/// _tupleToStr — 从已构造的 tuple 生成 "(a, b, c)" 显示串
template<typename Tuple, size_t... I>
inline string _tupleToStr(const Tuple& t, std::index_sequence<I...>) {
    std::ostringstream oss;
    oss << "(";
    size_t i = 0;
    (void)(int[]){0, ((oss << (i++ ? ", " : "") << _toStr(std::get<I>(t))), 0)...};
    oss << ")";
    auto tmp = oss.str();
    return string(tmp.data(), tmp.size());
}

/// makeTupleBox — Dart Record 字面量装箱（替代生成代码中的 tuple IIFE）。
/// 先构造 tuple 再从 tuple 生成显示串，保证每个实参只求值一次。
template<typename... Ts>
inline TupleBox* makeTupleBox(Ts&&... elems) {
    auto* t = new std::tuple<std::decay_t<Ts>...>(std::forward<Ts>(elems)...);
    string str = _tupleToStr(*t, std::index_sequence_for<Ts...>{});
    return GC::allocateLocal(new TupleBox(t, str));
}

/// listCopiedFrom — 按元素拷贝列表（目标/源元素类型可不同，隐式转换）
template<typename Dst, typename Src>
inline List<Dst>* listCopiedFrom(List<Src>* src) {
    auto* dst = new List<Dst>();
    if (src) {
        dst->_data->_storage.reserve(src->_data->_storage.size());
        for (size_t i = 0; i < src->_data->_storage.size(); i++) {
            dst->_data->_storage.push_back(src->_data->_storage[i]);
        }
    }
    return GC::allocateLocal(dst);
}

/// setCopiedFrom — 按元素拷贝为集合（不去重，与原 IIFE 语义一致）
template<typename Dst, typename Src>
inline Set<Dst>* setCopiedFrom(List<Src>* src) {
    auto* dst = new Set<Dst>();
    if (src) {
        dst->_data->_storage.reserve(src->_data->_storage.size());
        for (size_t i = 0; i < src->_data->_storage.size(); i++) {
            dst->_data->_storage.push_back(src->_data->_storage[i]);
        }
    }
    return GC::allocateLocal(dst);
}

#endif // DART2CPP_LOWERED_H
