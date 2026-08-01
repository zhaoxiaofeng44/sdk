// ============================================================================
// dart2cpp_lowered.h — OOP-lowered Dart → C++ 运行时库
// ============================================================================
// 本头文件为 dart2cpp 新编译器模块（lib/cpp_compiler/）生成的 C++ 代码
// 提供完整的运行时支持。设计镜像 lib/platform/dart/ 下的分层运行时文件。
//
// 组件清单：
//   1. AnyGC — GC 管理基类
//   2. GC — 标记-清除垃圾回收器
//   3. 异常层级 — DartException / DartStateError / ...
//   4. Box 类型 — 闭包捕获引用语义
//   5. TypeFunction 层级 — 可调用闭包基类（可变参数模板）
//   6. 静态集合 — StaticMapEntry / Array / StaticList / StaticMap / StaticSet
//   7. Promise / GlobalScheduler / smAwait — 协作式异步
//   8. 语义包装 — staticPrint / StaticStringBuffer
//   9. 辅助函数 — dart_is / dart_str
//  10. String 方法辅助
//  11. Duration / DateTime / RegExp 包装
// ============================================================================

#ifndef DART2CPP_LOWERED_H
#define DART2CPP_LOWERED_H

#include <algorithm>
#include <any>
#include <cassert>
#include <chrono>
#include <cmath>
#include <cstdint>
#include <cstdio>
#include <ctime>
#include <functional>
#include <iomanip>
#include <iostream>
#include <memory>
#include <regex>
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

// Forward declarations needed by AnyGC (defined later)
struct AnyGC;
struct ClassInfo;
class GlobalScheduler;
template<typename T> T dynAs(AnyGC* obj);

// ============================================================================
// 1. AnyGC — GC 管理基类
// ============================================================================

struct AnyGC {
    int gcFlag = 0;
    ClassInfo* _classInfo = nullptr;

    virtual ~AnyGC() = default;
    virtual std::string toString() const;
};

// ============================================================================
// 2. GC — 标记-清除垃圾回收器
// ============================================================================

class GC {
    static int _currentFlag;
    static std::vector<AnyGC*> _objects;
    static std::vector<AnyGC*> _roots;
    static std::unordered_set<AnyGC*> _registered;
    static GlobalScheduler _scheduler;

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
        bool found = false;
        for (auto* r : _roots) {
            if (r == base) { found = true; break; }
        }
        if (!found) {
            _roots.push_back(base);
        }
        return obj;
    }

    /// 执行一轮标记-清除 GC，返回被回收的对象数量（定义在 GlobalScheduler 之后）
    static int collect();

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

struct ReachabilityError {
    std::string _msg;
    std::string toStringValue() const { return _msg; }
};

// ============================================================================
// 4. ClassInfo — 结构化虚表（替代 map-based vptr）
// ============================================================================

struct ClassInfo {
    std::string typeName;
    void(*gcMark)(AnyGC*, int) = nullptr;
    const ClassInfo* _parent = nullptr;
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
};

// _isInstanceOf — check if obj is an instance of target ClassInfo (walks _parent chain)
inline bool _isInstanceOf(AnyGC* obj, const ClassInfo* target) {
    if (!obj || !obj->_classInfo) return false;
    for (const ClassInfo* ci = obj->_classInfo; ci; ci = ci->_parent) {
        if (ci == target) return true;
    }
    return false;
}

// AnyGC method definitions (require ClassInfo to be complete)
inline std::string AnyGC::toString() const {
    if (_classInfo && !_classInfo->typeName.empty()) return _classInfo->typeName;
    return "Instance";
}

/// _gcMark — cycle-safe GC mark through ClassInfo dispatch
inline void _gcMark(AnyGC* obj, int flag) {
    if (!obj) return;
    if (obj->gcFlag == flag) return;
    obj->gcFlag = flag;
    if (obj->_classInfo && obj->_classInfo->gcMark) obj->_classInfo->gcMark(obj, flag);
}

// ============================================================================
// 5. Box 类型 — 闭包捕获引用语义
// ============================================================================

// Forward declarations for string helpers used in StringBox ClassInfo dispatch
inline std::string dart_str_toUpper(const std::string& s);
inline std::string dart_str_toLower(const std::string& s);
inline std::string dart_str_trim(const std::string& s);
inline std::string dart_str_trimLeft(const std::string& s);
inline std::string dart_str_trimRight(const std::string& s);
inline std::string dart_str_replaceFirst(const std::string& s, const std::string& from, const std::string& to, int64_t start);
inline std::string dart_str_replaceRange(const std::string& s, int64_t start, int64_t end, const std::string& replacement);
inline std::string dart_str_padLeft(const std::string& s, int64_t width, const std::string& padding);
inline std::string dart_str_padRight(const std::string& s, int64_t width, const std::string& padding);
inline int64_t dart_str_lastIndexOf(const std::string& s, const std::string& pattern, int64_t start);
inline int64_t dart_str_codeUnitAt(const std::string& s, int64_t index);
inline std::string dart_str_fromCharCode(int64_t code);
inline std::string dart_str_fromCharCodes(AnyGC* list);
inline std::string dart_double_toStringAsExponential(double value, int64_t fracDigits);

// ClassInfo subclasses — constructor bodies defined after the structs
struct IntBoxClassInfo : ClassInfo { IntBoxClassInfo(); };
struct DoubleBoxClassInfo : ClassInfo { DoubleBoxClassInfo(); };
struct BoolBoxClassInfo : ClassInfo { BoolBoxClassInfo(); };
struct StringBoxClassInfo : ClassInfo { StringBoxClassInfo(); };

struct IntBox : AnyGC {
    int64_t value;
    static IntBoxClassInfo _classInfo;
    IntBox(int64_t v) : value(v) { AnyGC::_classInfo = &IntBox::_classInfo; GC::allocateLocal(this); }

    static AnyGC* _vptr_toString(AnyGC* self);
    static AnyGC* _vptr_runtimeType(AnyGC*);
    static int64_t _vptr_compareTo(AnyGC* self, AnyGC* other);
    static bool _vptr_eq(AnyGC* self, AnyGC* other);
    static int64_t _vptr_hashCode(AnyGC* self);
};

struct DoubleBox : AnyGC {
    double value;
    static DoubleBoxClassInfo _classInfo;
    DoubleBox(double v) : value(v) { AnyGC::_classInfo = &DoubleBox::_classInfo; GC::allocateLocal(this); }

    static AnyGC* _vptr_toString(AnyGC* self);
    static AnyGC* _vptr_runtimeType(AnyGC*);
    static int64_t _vptr_compareTo(AnyGC* self, AnyGC* other);
    static bool _vptr_eq(AnyGC* self, AnyGC* other);
    static int64_t _vptr_hashCode(AnyGC* self);
};

struct BoolBox : AnyGC {
    bool value;
    static BoolBoxClassInfo _classInfo;
    BoolBox(bool v) : value(v) { AnyGC::_classInfo = &BoolBox::_classInfo; GC::allocateLocal(this); }

    static AnyGC* _vptr_toString(AnyGC* self);
    static AnyGC* _vptr_runtimeType(AnyGC*);
    static int64_t _vptr_compareTo(AnyGC* self, AnyGC* other);
    static bool _vptr_eq(AnyGC* self, AnyGC* other);
    static int64_t _vptr_hashCode(AnyGC* self);
};

struct StringBox : AnyGC {
    std::string value;
    static StringBoxClassInfo _classInfo;
    StringBox(const std::string& v) : value(v) { AnyGC::_classInfo = &StringBox::_classInfo; GC::allocateLocal(this); }

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
};

// TupleBox — wraps std::tuple* as an AnyGC for record types (Dart records)
struct TupleBoxClassInfo : ClassInfo {
    TupleBoxClassInfo();
};
struct TupleBox : AnyGC {
    static TupleBoxClassInfo _classInfo;
    void* data;
    std::string str;
    TupleBox(void* d, std::string s) : data(d), str(std::move(s)) {
        AnyGC::_classInfo = &_classInfo;
        GC::allocateLocal(this);
    }

    // ── ClassInfo dispatch (defined after _box is available) ──
    static AnyGC* _vptr_toString(AnyGC* self);
    static AnyGC* _vptr_runtimeType(AnyGC* self);
    static void _gcMark_impl(AnyGC* self, int flag) {}
};

inline TupleBoxClassInfo::TupleBoxClassInfo() {
    typeName = "Record";
    gcMark = &TupleBox::_gcMark_impl;
    toString = &TupleBox::_vptr_toString;
    get_runtimeType = &TupleBox::_vptr_runtimeType;
}
inline TupleBoxClassInfo TupleBox::_classInfo = TupleBoxClassInfo();

// ValueBox<T> — wraps any value type as an AnyGC for dynamic dispatch
template<typename T> struct ValueBoxClassInfo;

template<typename T>
struct ValueBox : AnyGC {
    T value;
    static ValueBoxClassInfo<T> _classInfo;
    ValueBox(const T& v) : value(v) { AnyGC::_classInfo = &_classInfo; GC::allocateLocal(this); }
    ValueBox(T&& v) : value(std::move(v)) { AnyGC::_classInfo = &_classInfo; GC::allocateLocal(this); }

    // ── ClassInfo dispatch (defined after _box/_boxElem available) ──
    static AnyGC* _vptr_toString(AnyGC* self);
    static AnyGC* _vptr_runtimeType(AnyGC* self);
    static bool _vptr_eq(AnyGC* self, AnyGC* other);
    static int64_t _vptr_hashCode(AnyGC* self);
    static void _gcMark_impl(AnyGC* self, int flag);
};

template<typename T>
struct ValueBoxClassInfo : ClassInfo {
    ValueBoxClassInfo();
};

template<typename T>
ValueBoxClassInfo<T>::ValueBoxClassInfo() {
    typeName = "ValueBox";
    gcMark = &ValueBox<T>::_gcMark_impl;
    toString = &ValueBox<T>::_vptr_toString;
    get_runtimeType = &ValueBox<T>::_vptr_runtimeType;
    eq = &ValueBox<T>::_vptr_eq;
    get_hashCode = &ValueBox<T>::_vptr_hashCode;
}

template<typename T>
ValueBoxClassInfo<T> ValueBox<T>::_classInfo = ValueBoxClassInfo<T>();

// ============================================================================
// _box — universal boxing helper (replaces AnyPtr::fromAuto)
// ============================================================================

inline AnyGC* _box(AnyGC* v) { return v; }
inline AnyGC* _box(std::nullptr_t) { return nullptr; }
inline AnyGC* _box(int64_t v) { return GC::allocateLocal(new IntBox(v)); }
inline AnyGC* _box(int v) { return GC::allocateLocal(new IntBox(static_cast<int64_t>(v))); }
inline AnyGC* _box(double v) { return GC::allocateLocal(new DoubleBox(v)); }
inline AnyGC* _box(bool v) { return GC::allocateLocal(new BoolBox(v)); }
inline AnyGC* _box(const std::string& v) { return GC::allocateLocal(new StringBox(v)); }
inline AnyGC* _box(const char* v) { return GC::allocateLocal(new StringBox(std::string(v))); }

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
inline std::string _anyToString(AnyGC* val) {
    if (!val) return "null";
    if (val->_classInfo && val->_classInfo->toString) {
        return dynAs<std::string>(val->_classInfo->toString(val));
    }
    if (val->_classInfo && !val->_classInfo->typeName.empty()) return val->_classInfo->typeName;
    return "Instance";
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

// ── Box type ClassInfo method definitions (after _box is available) ──

inline AnyGC* IntBox::_vptr_toString(AnyGC* self) {
    return _box(std::to_string(static_cast<IntBox*>(self)->value));
}
inline AnyGC* IntBox::_vptr_runtimeType(AnyGC*) {
    return _box(std::string("int"));
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
    return _box(std::string("double"));
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
    return _box(std::string("bool"));
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
    return _box(std::string("String"));
}
inline AnyGC* StringBox::_vptr_toUpperCase(AnyGC* self) {
    return _box(dart_str_toUpper(static_cast<StringBox*>(self)->value));
}
inline AnyGC* StringBox::_vptr_toLowerCase(AnyGC* self) {
    return _box(dart_str_toLower(static_cast<StringBox*>(self)->value));
}
inline bool StringBox::_vptr_contains(AnyGC* self, AnyGC* other) {
    return static_cast<StringBox*>(self)->value.find(dynAs<std::string>(other)) != std::string::npos;
}
inline int64_t StringBox::_vptr_length(AnyGC* self) {
    return static_cast<int64_t>(static_cast<StringBox*>(self)->value.size());
}
inline AnyGC* StringBox::_vptr_trim(AnyGC* self) {
    return _box(dart_str_trim(static_cast<StringBox*>(self)->value));
}
inline AnyGC* StringBox::_vptr_trimLeft(AnyGC* self) {
    return _box(dart_str_trimLeft(static_cast<StringBox*>(self)->value));
}
inline AnyGC* StringBox::_vptr_trimRight(AnyGC* self) {
    return _box(dart_str_trimRight(static_cast<StringBox*>(self)->value));
}
inline AnyGC* StringBox::_vptr_replaceFirst(AnyGC* self, AnyGC* from, AnyGC* to, AnyGC* start) {
    const auto& s = static_cast<StringBox*>(self)->value;
    int64_t st = start ? dynAs<int64_t>(start) : 0;
    return _box(dart_str_replaceFirst(s, dynAs<std::string>(from), dynAs<std::string>(to), st));
}
inline AnyGC* StringBox::_vptr_replaceRange(AnyGC* self, AnyGC* start, AnyGC* end, AnyGC* replacement) {
    const auto& s = static_cast<StringBox*>(self)->value;
    return _box(dart_str_replaceRange(s, dynAs<int64_t>(start), dynAs<int64_t>(end), dynAs<std::string>(replacement)));
}
inline AnyGC* StringBox::_vptr_padLeft(AnyGC* self, AnyGC* width, AnyGC* padding) {
    const auto& s = static_cast<StringBox*>(self)->value;
    std::string pad = padding ? dynAs<std::string>(padding) : std::string(" ");
    return _box(dart_str_padLeft(s, dynAs<int64_t>(width), pad));
}
inline AnyGC* StringBox::_vptr_padRight(AnyGC* self, AnyGC* width, AnyGC* padding) {
    const auto& s = static_cast<StringBox*>(self)->value;
    std::string pad = padding ? dynAs<std::string>(padding) : std::string(" ");
    return _box(dart_str_padRight(s, dynAs<int64_t>(width), pad));
}
inline int64_t StringBox::_vptr_lastIndexOf(AnyGC* self, AnyGC* pattern, AnyGC* start) {
    const auto& s = static_cast<StringBox*>(self)->value;
    int64_t st = start ? dynAs<int64_t>(start) : static_cast<int64_t>(s.size()) - 1;
    return dart_str_lastIndexOf(s, dynAs<std::string>(pattern), st);
}
inline int64_t StringBox::_vptr_codeUnitAt(AnyGC* self, AnyGC* index) {
    const auto& s = static_cast<StringBox*>(self)->value;
    return dart_str_codeUnitAt(s, dynAs<int64_t>(index));
}
inline int64_t StringBox::_vptr_compareTo(AnyGC* self, AnyGC* other) {
    const auto& a = static_cast<StringBox*>(self)->value;
    std::string b = dynAs<std::string>(other);
    return static_cast<int64_t>(a.compare(b));
}
inline bool StringBox::_vptr_eq(AnyGC* self, AnyGC* other) {
    return static_cast<StringBox*>(self)->value == dynAs<std::string>(other);
}
inline int64_t StringBox::_vptr_hashCode(AnyGC* self) {
    return static_cast<int64_t>(std::hash<std::string>{}(static_cast<StringBox*>(self)->value));
}

// Box ClassInfo subclass constructor definitions — assign function pointers

inline IntBoxClassInfo::IntBoxClassInfo() {
    typeName = "int";
    toString = &IntBox::_vptr_toString;
    get_runtimeType = &IntBox::_vptr_runtimeType;
    compareTo = &IntBox::_vptr_compareTo;
    eq = &IntBox::_vptr_eq;
    get_hashCode = &IntBox::_vptr_hashCode;
}

inline DoubleBoxClassInfo::DoubleBoxClassInfo() {
    typeName = "double";
    toString = &DoubleBox::_vptr_toString;
    get_runtimeType = &DoubleBox::_vptr_runtimeType;
    compareTo = &DoubleBox::_vptr_compareTo;
    eq = &DoubleBox::_vptr_eq;
    get_hashCode = &DoubleBox::_vptr_hashCode;
}

inline BoolBoxClassInfo::BoolBoxClassInfo() {
    typeName = "bool";
    toString = &BoolBox::_vptr_toString;
    get_runtimeType = &BoolBox::_vptr_runtimeType;
    compareTo = &BoolBox::_vptr_compareTo;
    eq = &BoolBox::_vptr_eq;
    get_hashCode = &BoolBox::_vptr_hashCode;
}

inline StringBoxClassInfo::StringBoxClassInfo() {
    typeName = "String";
    toString = &StringBox::_vptr_toString;
    get_runtimeType = &StringBox::_vptr_runtimeType;
    toUpperCase = &StringBox::_vptr_toUpperCase;
    toLowerCase = &StringBox::_vptr_toLowerCase;
    contains = &StringBox::_vptr_contains;
    get_length = &StringBox::_vptr_length;
    trim = &StringBox::_vptr_trim;
    trimLeft = &StringBox::_vptr_trimLeft;
    trimRight = &StringBox::_vptr_trimRight;
    replaceFirst = &StringBox::_vptr_replaceFirst;
    replaceRange = &StringBox::_vptr_replaceRange;
    padLeft = &StringBox::_vptr_padLeft;
    padRight = &StringBox::_vptr_padRight;
    lastIndexOf = &StringBox::_vptr_lastIndexOf;
    codeUnitAt = &StringBox::_vptr_codeUnitAt;
    compareTo = &StringBox::_vptr_compareTo;
    eq = &StringBox::_vptr_eq;
    get_hashCode = &StringBox::_vptr_hashCode;
}

// Box ClassInfo static instances
inline IntBoxClassInfo IntBox::_classInfo = IntBoxClassInfo();
inline DoubleBoxClassInfo DoubleBox::_classInfo = DoubleBoxClassInfo();
inline BoolBoxClassInfo BoolBox::_classInfo = BoolBoxClassInfo();
inline StringBoxClassInfo StringBox::_classInfo = StringBoxClassInfo();

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
        ClassInfo* ci = obj->_classInfo;
        if (ci == &IntBox::_classInfo) return static_cast<IntBox*>(obj)->value;
        if (ci == &DoubleBox::_classInfo) return static_cast<int64_t>(static_cast<DoubleBox*>(obj)->value);
        return 0;
    }
    else if constexpr (std::is_same_v<T, double>) {
        ClassInfo* ci = obj->_classInfo;
        if (ci == &DoubleBox::_classInfo) return static_cast<DoubleBox*>(obj)->value;
        if (ci == &IntBox::_classInfo) return static_cast<double>(static_cast<IntBox*>(obj)->value);
        return 0.0;
    }
    else if constexpr (std::is_same_v<T, bool>) {
        ClassInfo* ci = obj->_classInfo;
        if (ci == &BoolBox::_classInfo) return static_cast<BoolBox*>(obj)->value;
        return false;
    }
    else if constexpr (std::is_same_v<T, std::string>) {
        if (obj->_classInfo == &StringBox::_classInfo) return static_cast<StringBox*>(obj)->value;
        if (obj->_classInfo && obj->_classInfo->toString) {
            return dynAs<std::string>(obj->_classInfo->toString(obj));
        }
        if (obj->_classInfo && !obj->_classInfo->typeName.empty()) return obj->_classInfo->typeName;
        return "Instance";
    }
    else if constexpr (std::is_pointer_v<T>) {
        return static_cast<T>(obj);
    }
    else {
        if (obj->_classInfo == &ValueBox<T>::_classInfo) return static_cast<ValueBox<T>*>(obj)->value;
        return T{};
    }
}

// ============================================================================
// 6. TypeFunction 层级 — 可调用闭包基类（可变参数模板）
// ============================================================================

// TypeFunction — 可调用闭包基类。
// 子类 TypeFunctionN 持有两个函数指针：
//   fnPtr: AnyGC*(*)(AnyGC*, Args...) — boxed 版本，返回 AnyGC*（trampoline 内部已 box）。
//          用于 boxed AnyGC* 返回路径，调用方按需 dynAs<R>(...) 拆箱。
//   typedFnPtr: R(*)(AnyGC*, Args...) — typed 版本，直接返回 R。
//          供 _vptr_ 方法使用，无需 dynAs 拆箱。
struct TypeFunction : AnyGC {};

// _box overload for TypeFunction* — must appear after TypeFunction definition
// so static_cast (not reinterpret_cast) can be used.
inline AnyGC* _box(TypeFunction* v) { return static_cast<AnyGC*>(v); }

// TypeFunctionN<R, Args...> — typed function wrapper.
// fnPtr 始终返回 AnyGC*（boxed），用于 boxed AnyGC* 返回路径。
// typedFnPtr 返回 R（typed），供 _vptr_ 方法直接使用，无需 dynAs。

// General template (3+ args)
template<typename R, typename... Args>
struct TypeFunctionN : TypeFunction {
    using ArgsTuple = std::tuple<Args...>;
    using FnPtr = AnyGC*(*)(AnyGC*, Args...);
    FnPtr fnPtr = nullptr;
    using TypedFnPtr = R(*)(AnyGC*, Args...);
    TypedFnPtr typedFnPtr = nullptr;
};

// 0-arg specialization
template<typename R>
struct TypeFunctionN<R> : TypeFunction {
    using ArgsTuple = std::tuple<>;
    using FnPtr = AnyGC*(*)(AnyGC*);
    FnPtr fnPtr = nullptr;
    using TypedFnPtr = R(*)(AnyGC*);
    TypedFnPtr typedFnPtr = nullptr;
};

// 1-arg specialization
template<typename R, typename A>
struct TypeFunctionN<R, A> : TypeFunction {
    using ArgsTuple = std::tuple<A>;
    using FnPtr = AnyGC*(*)(AnyGC*, A);
    FnPtr fnPtr = nullptr;
    using TypedFnPtr = R(*)(AnyGC*, A);
    TypedFnPtr typedFnPtr = nullptr;
};

// 2-arg specialization
template<typename R, typename A1, typename A2>
struct TypeFunctionN<R, A1, A2> : TypeFunction {
    using ArgsTuple = std::tuple<A1, A2>;
    using FnPtr = AnyGC*(*)(AnyGC*, A1, A2);
    FnPtr fnPtr = nullptr;
    using TypedFnPtr = R(*)(AnyGC*, A1, A2);
    TypedFnPtr typedFnPtr = nullptr;
};

// 向后兼容的类型别名（保持 TypeFunction0-16 的命名）
template<typename R>
using TypeFunction0 = TypeFunctionN<R>;

template<typename R, typename T1>
using TypeFunction1 = TypeFunctionN<R, T1>;

template<typename R, typename T1, typename T2>
using TypeFunction2 = TypeFunctionN<R, T1, T2>;

// ── _boxElem / _unboxElem — element boxing/unboxing for collection _vptr_* methods ──

/// Trait: true if T supports operator==
template<typename, typename = void>
struct _isEqualityComparable : std::false_type {};
template<typename U>
struct _isEqualityComparable<U, std::void_t<decltype(std::declval<U>() == std::declval<U>())>> : std::true_type {};

/// Trait: true if T supports operator<
template<typename, typename = void>
struct _isLessThanComparable : std::false_type {};
template<typename U>
struct _isLessThanComparable<U, std::void_t<decltype(std::declval<U>() < std::declval<U>())>> : std::true_type {};

/// Box an element value to AnyGC*. For pointer types, the pointer IS an AnyGC*
/// (static_cast, no ValueBox wrapping). For value types, delegates to _box.
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
    else if constexpr (std::is_same_v<U, std::string>) return dynAs<std::string>(ptr);
    else if constexpr (std::is_pointer_v<U>) return static_cast<U>(ptr);
    else return *reinterpret_cast<U*>(ptr);
}

// ── TupleBox _vptr_* definitions (deferred until _box available) ──
inline AnyGC* TupleBox::_vptr_toString(AnyGC* self) {
    return _box(static_cast<TupleBox*>(self)->str);
}
inline AnyGC* TupleBox::_vptr_runtimeType(AnyGC* self) {
    return _box(std::string("Record"));
}

// ── ValueBox _vptr_* definitions (deferred until _box/_boxElem available) ──
template<typename T>
AnyGC* ValueBox<T>::_vptr_toString(AnyGC* self) {
    return _box(_anyToString(_boxElem<T>(static_cast<ValueBox*>(self)->value)));
}
template<typename T>
AnyGC* ValueBox<T>::_vptr_runtimeType(AnyGC* self) {
    return _box(std::string("ValueBox"));
}
template<typename T>
bool ValueBox<T>::_vptr_eq(AnyGC* self, AnyGC* other) {
    if constexpr (_isEqualityComparable<T>::value) {
        return static_cast<ValueBox*>(self)->value == static_cast<ValueBox*>(other)->value;
    }
    return false;
}
template<typename T>
int64_t ValueBox<T>::_vptr_hashCode(AnyGC* self) {
    if constexpr (std::is_same_v<T, int64_t>)
        return static_cast<int64_t>(std::hash<int64_t>{}(static_cast<ValueBox*>(self)->value));
    else if constexpr (std::is_same_v<T, double>)
        return static_cast<int64_t>(std::hash<double>{}(static_cast<ValueBox*>(self)->value));
    else if constexpr (std::is_same_v<T, bool>)
        return static_cast<int64_t>(static_cast<ValueBox*>(self)->value ? 1 : 0);
    else if constexpr (std::is_same_v<T, std::string>)
        return static_cast<int64_t>(std::hash<std::string>{}(static_cast<ValueBox*>(self)->value));
    else
        return static_cast<int64_t>(0);
}
template<typename T>
void ValueBox<T>::_gcMark_impl(AnyGC* self, int flag) {
    if constexpr (std::is_pointer_v<T>) {
        using Pointee = std::remove_pointer_t<T>;
        if constexpr (std::is_base_of_v<AnyGC, Pointee>) {
            auto* vb = static_cast<ValueBox*>(self);
            if (vb->value) _gcMark(vb->value, flag);
        }
    }
}

// ============================================================================
// 7. 静态集合 — StaticMapEntry / Array / StaticList / StaticMap / StaticSet
// ============================================================================

// ── StaticMapEntry<K,V> ──

// 前向声明
template<typename T> struct StaticList;
template<typename T> struct StaticSet;
template<typename K, typename V> struct StaticMap;
template<typename K, typename V> struct StaticMapEntry;

template<typename T>
struct _isStaticMapEntry : std::false_type {};
template<typename K, typename V>
struct _isStaticMapEntry<StaticMapEntry<K, V>> : std::true_type {};

// ClassInfo subclass forward declarations (constructor bodies defined after structs)
template<typename T> struct ArrayClassInfo : ClassInfo {
    ArrayClassInfo();
    void(*add)(AnyGC*, AnyGC*) = nullptr;
    void(*insert)(AnyGC*, AnyGC*, AnyGC*) = nullptr;
    AnyGC*(*removeAt)(AnyGC*, AnyGC*) = nullptr;
    bool(*remove)(AnyGC*, AnyGC*) = nullptr;
    int64_t(*indexOf)(AnyGC*, AnyGC*) = nullptr;
    void(*clear)(AnyGC*) = nullptr;
};
template<typename T> struct StaticIteratorClassInfo : ClassInfo {
    StaticIteratorClassInfo();
    bool(*moveNext)(AnyGC*) = nullptr;
    AnyGC*(*current)(AnyGC*) = nullptr;
    void(*reset)(AnyGC*) = nullptr;
};
template<typename T> struct StaticListClassInfo : ClassInfo {
    StaticListClassInfo();
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
template<typename T> struct StaticSetClassInfo : ClassInfo {
    StaticSetClassInfo();
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
template<typename K, typename V> struct StaticMapClassInfo : ClassInfo {
    StaticMapClassInfo();
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

// ── Array<T> ──

template<typename T>
struct Array : AnyGC {
    static ArrayClassInfo<T> _classInfo;
    std::vector<T> _storage;

    Array() { AnyGC::_classInfo = &_classInfo; }
    Array(int size, T fill = T()) : _storage(size, fill) { AnyGC::_classInfo = &_classInfo; }
    Array(std::initializer_list<T> init) : _storage(init) { AnyGC::_classInfo = &_classInfo; }

    template<typename Iter>
    Array(Iter begin, Iter end) : _storage(begin, end) { AnyGC::_classInfo = &_classInfo; }

    // 从 StaticList 构造（前向声明，实现在 StaticList 定义之后）
    Array(StaticList<T>* list);

    T& operator[](int64_t i) {
        if (i < 0 || static_cast<size_t>(i) >= _storage.size()) {
            throw DartRangeError("Index " + std::to_string(i) + " out of range [0.." + std::to_string(_storage.size()) + ")");
        }
        return _storage[static_cast<size_t>(i)];
    }
    const T& operator[](int64_t i) const {
        if (i < 0 || static_cast<size_t>(i) >= _storage.size()) {
            throw DartRangeError("Index " + std::to_string(i) + " out of range [0.." + std::to_string(_storage.size()) + ")");
        }
        return _storage[static_cast<size_t>(i)];
    }

    static void _gcMark_impl(AnyGC* self, int flag) {
        if constexpr (std::is_pointer_v<T>) {
            using Pointee = std::remove_pointer_t<T>;
            if constexpr (std::is_base_of_v<AnyGC, Pointee>) {
                auto* arr = static_cast<Array*>(self);
                for (auto& elem : arr->_storage) {
                    if (elem) _gcMark(elem, flag);
                }
            }
        }
    }

    // ── ClassInfo dispatch ──
    static AnyGC* _vptr_toString(AnyGC* self) {
        auto* arr = static_cast<Array*>(self);
        std::string result = "[";
        for (size_t i = 0; i < arr->_storage.size(); i++) {
            if (i > 0) result += ", ";
            result += _anyToString(_boxElem<T>(arr->_storage[i]));
        }
        result += "]";
        return _box(result);
    }
    static AnyGC* _vptr_runtimeType(AnyGC* self) {
        return _box(std::string("List"));
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

// Free function templates for range-based for loops on Array
template<typename T>
auto begin(Array<T>* a) { return a->_storage.begin(); }
template<typename T>
auto end(Array<T>* a) { return a->_storage.end(); }

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
ArrayClassInfo<T>::ArrayClassInfo() {
    typeName = "Array";
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
ArrayClassInfo<T> Array<T>::_classInfo = ArrayClassInfo<T>();

// ── StaticIterator<T> ──

template<typename T>
struct StaticIterator : AnyGC {
    static StaticIteratorClassInfo<T> _classInfo;
    Array<T>* _data;
    int _index;

    StaticIterator(Array<T>* data) : _data(data), _index(0) { AnyGC::_classInfo = &_classInfo; }

    static void _gcMark_impl(AnyGC* self, int flag) {
        auto* it = static_cast<StaticIterator*>(self);
        if (it->_data) _gcMark(it->_data, flag);
    }

    // ── ClassInfo dispatch ──
    static AnyGC* _vptr_toString(AnyGC* self) {
        return _box(std::string("Iterator"));
    }
    static AnyGC* _vptr_runtimeType(AnyGC* self) {
        return _box(std::string("Iterator"));
    }
    static bool _vptr_moveNext(AnyGC* self) {
        auto* it = static_cast<StaticIterator*>(self);
        it->_index++;
        return it->_index <= static_cast<int>(it->_data->_storage.size());
    }
    static AnyGC* _vptr_current(AnyGC* self) {
        auto* it = static_cast<StaticIterator*>(self);
        return _boxElem<T>(it->_data->_storage[it->_index - 1]);
    }
    static void _vptr_reset(AnyGC* self) {
        static_cast<StaticIterator*>(self)->_index = 0;
    }
};

template<typename T>
StaticIteratorClassInfo<T>::StaticIteratorClassInfo() {
    typeName = "Iterator";
    gcMark = &StaticIterator<T>::_gcMark_impl;
    toString = &StaticIterator<T>::_vptr_toString;
    get_runtimeType = &StaticIterator<T>::_vptr_runtimeType;
    moveNext = &StaticIterator<T>::_vptr_moveNext;
    current = &StaticIterator<T>::_vptr_current;
    reset = &StaticIterator<T>::_vptr_reset;
}

template<typename T>
StaticIteratorClassInfo<T> StaticIterator<T>::_classInfo = StaticIteratorClassInfo<T>();

// Free function wrappers for StaticIterator — dispatch through ClassInfo
inline bool iterator_moveNext(AnyGC* self) {
    auto* ci = static_cast<StaticIteratorClassInfo<AnyGC*>*>(self->_classInfo);
    return ci->moveNext ? ci->moveNext(self) : false;
}
inline AnyGC* iterator_current(AnyGC* self) {
    auto* ci = static_cast<StaticIteratorClassInfo<AnyGC*>*>(self->_classInfo);
    return ci->current ? ci->current(self) : nullptr;
}
inline void iterator_reset(AnyGC* self) {
    auto* ci = static_cast<StaticIteratorClassInfo<AnyGC*>*>(self->_classInfo);
    if (ci->reset) ci->reset(self);
}
inline AnyGC* iterator_get(AnyGC* collection) {
    auto* ci = static_cast<ClassInfo*>(collection->_classInfo);
    return ci && ci->get_iterator ? ci->get_iterator(collection) : nullptr;
}

// ── StaticList<T> ──
// 对齐 Dart _collections.dart StaticList<T>

template<typename T>
struct StaticList : AnyGC {
    Array<T>* _data;
    static StaticListClassInfo<T> _classInfo;

    StaticList() : _data(GC::allocateLocal(new Array<T>())) { AnyGC::_classInfo = &StaticList::_classInfo; }

    StaticList(std::initializer_list<T> init)
        : _data(GC::allocateLocal(new Array<T>(init))) { AnyGC::_classInfo = &StaticList::_classInfo; }

    static StaticList* of(std::initializer_list<T> elements) {
        return GC::allocateLocal(new StaticList(elements));
    }

    static StaticList* empty() {
        return GC::allocateLocal(new StaticList());
    }

    /// 对齐 Dart: StaticList.filled(length, fill)
    static StaticList* filled(int length, T fill) {
        auto* result = GC::allocateLocal(new StaticList());
        for (int i = 0; i < length; i++) result->_data->_storage.push_back(fill);
        return result;
    }

    /// 对齐 Dart: StaticList.generate(length, generator)
    static StaticList* generate(int length, std::function<T(int)> generator) {
        auto* result = GC::allocateLocal(new StaticList());
        for (int i = 0; i < length; i++) result->_data->_storage.push_back(generator(i));
        return result;
    }

    /// 对齐 Dart: StaticList.generate(length, generator) — TypeFunction 版本
    static StaticList* generate(int length, TypeFunction1<T, int64_t>* generator) {
        auto* result = GC::allocateLocal(new StaticList());
        if (generator) {
            for (int i = 0; i < length; i++) result->_data->_storage.push_back(generator->typedFnPtr(generator, static_cast<int64_t>(i)));
        }
        return result;
    }

    /// 对齐 Dart: StaticList.from(elements)
    static StaticList* from(StaticList<T>* source) {
        auto* result = GC::allocateLocal(new StaticList());
        if (source) {
            for (int i = 0; i < source->_data->_storage.size(); i++) result->_data->_storage.push_back(source->_data->_storage[i]);
        }
        return result;
    }

    // ── ClassInfo vptr support ──
    static AnyGC* _vptr_runtimeType(AnyGC*) {
        return _box(std::string("List"));
    }
    static int64_t _vptr_length(AnyGC* self) {
        return static_cast<int64_t>(static_cast<StaticList*>(self)->_data->_storage.size());
    }
    static AnyGC* _vptr_toString(AnyGC* self) {
        auto* list = static_cast<StaticList*>(self);
        std::string result = "[";
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
            return array_contains(static_cast<StaticList*>(self)->_data, _unboxElem<T>(element));
        } else {
            return false;
        }
    }
    static AnyGC* _vptr_index(AnyGC* self, AnyGC* idx) {
        auto* list = static_cast<StaticList*>(self);
        int64_t i = dynAs<int64_t>(idx);
        return _boxElem<T>(list->_data->_storage[static_cast<int>(i)]);
    }
    static void _vptr_setIndex(AnyGC* self, AnyGC* idx, AnyGC* val) {
        auto* list = static_cast<StaticList*>(self);
        int64_t i = dynAs<int64_t>(idx);
        list->_data->_storage[static_cast<int>(i)] = _unboxElem<T>(val);
    }
    // List-specific getters
    static bool _vptr_isEmpty(AnyGC* self) {
        return static_cast<StaticList*>(self)->_data->_storage.size() == 0;
    }
    static bool _vptr_isNotEmpty(AnyGC* self) {
        return static_cast<StaticList*>(self)->_data->_storage.size() > 0;
    }
    static AnyGC* _vptr_first(AnyGC* self) {
        auto* list = static_cast<StaticList*>(self);
        if (list->_data->_storage.size() == 0) throw DartStateError("No element");
        return _boxElem<T>(list->_data->_storage[0]);
    }
    static AnyGC* _vptr_last(AnyGC* self) {
        auto* list = static_cast<StaticList*>(self);
        if (list->_data->_storage.size() == 0) throw DartStateError("No element");
        return _boxElem<T>(list->_data->_storage[list->_data->_storage.size() - 1]);
    }
    static AnyGC* _vptr_single(AnyGC* self) {
        auto* list = static_cast<StaticList*>(self);
        if (list->_data->_storage.size() != 1) throw DartStateError("Not single element");
        return _boxElem<T>(list->_data->_storage[0]);
    }
    static AnyGC* _vptr_reversed(AnyGC* self) {
        auto* list = static_cast<StaticList*>(self);
        auto* result = new StaticList<T>();
        for (int i = list->_data->_storage.size() - 1; i >= 0; i--) result->_data->_storage.push_back(list->_data->_storage[i]);
        return static_cast<AnyGC*>(GC::allocateLocal(result));
    }
    static AnyGC* _vptr_iterator(AnyGC* self) {
        auto* list = static_cast<StaticList*>(self);
        return static_cast<AnyGC*>(GC::allocateLocal(new StaticIterator<T>(list->_data)));
    }
    // List-specific methods
    static void _vptr_add(AnyGC* self, AnyGC* arg) {
        static_cast<StaticList*>(self)->_data->_storage.push_back(_unboxElem<T>(arg));
    }
    static void _vptr_addAll(AnyGC* self, AnyGC* arg) {
        auto* list = static_cast<StaticList*>(self);
        auto* other = static_cast<StaticList*>(arg);
        if (!other) return;
        for (int i = 0; i < other->_data->_storage.size(); i++) list->_data->_storage.push_back(other->_data->_storage[i]);
    }
    static void _vptr_insert(AnyGC* self, AnyGC* idx, AnyGC* val) {
        array_insert(static_cast<StaticList*>(self)->_data, static_cast<int>(dynAs<int64_t>(idx)), _unboxElem<T>(val));
    }
    static void _vptr_insertAll(AnyGC* self, AnyGC* idx, AnyGC* other) {
        auto* list = static_cast<StaticList*>(self);
        auto* o = static_cast<StaticList*>(other);
        if (!o) return;
        int i = static_cast<int>(dynAs<int64_t>(idx));
        for (int j = 0; j < o->_data->_storage.size(); j++) {
            array_insert(list->_data, i, o->_data->_storage[j]);
            i++;
        }
    }
    static AnyGC* _vptr_removeAt(AnyGC* self, AnyGC* idx) {
        return _boxElem<T>(array_removeAt(static_cast<StaticList*>(self)->_data, static_cast<int>(dynAs<int64_t>(idx))));
    }
    static bool _vptr_remove(AnyGC* self, AnyGC* element) {
        if constexpr (_isEqualityComparable<T>::value) {
            auto* list = static_cast<StaticList*>(self);
            int idx = array_indexOf(list->_data, _unboxElem<T>(element));
            if (idx == -1) return false;
            array_removeAt(list->_data, idx);
            return true;
        } else {
            return false;
        }
    }
    static AnyGC* _vptr_removeLast(AnyGC* self) {
        auto* list = static_cast<StaticList*>(self);
        int len = list->_data->_storage.size();
        if (len == 0) throw DartRangeError("Cannot removeLast on empty list");
        return _boxElem<T>(array_removeAt(list->_data, len - 1));
    }
    static void _vptr_removeWhere(AnyGC* self, AnyGC* test) {
        auto* list = static_cast<StaticList*>(self);
        auto* tf = static_cast<TypeFunction1<bool, T>*>(test);
        for (int i = list->_data->_storage.size() - 1; i >= 0; i--) {
            if (tf->typedFnPtr(tf, list->_data->_storage[i])) array_removeAt(list->_data, i);
        }
    }
    static void _vptr_retainWhere(AnyGC* self, AnyGC* test) {
        auto* list = static_cast<StaticList*>(self);
        auto* tf = static_cast<TypeFunction1<bool, T>*>(test);
        for (int i = list->_data->_storage.size() - 1; i >= 0; i--) {
            if (!tf->typedFnPtr(tf, list->_data->_storage[i])) array_removeAt(list->_data, i);
        }
    }
    static void _vptr_removeRange(AnyGC* self, AnyGC* start, AnyGC* end) {
        auto* list = static_cast<StaticList*>(self);
        int s = static_cast<int>(dynAs<int64_t>(start));
        int e = static_cast<int>(dynAs<int64_t>(end));
        int len = static_cast<int>(list->_data->_storage.size());
        if (s < 0 || e > len || s > e) throw DartRangeError("Invalid range in removeRange");
        list->_data->_storage.erase(list->_data->_storage.begin() + s, list->_data->_storage.begin() + e);
    }
    static void _vptr_fillRange(AnyGC* self, AnyGC* start, AnyGC* end, AnyGC* fill) {
        auto* list = static_cast<StaticList*>(self);
        int s = static_cast<int>(dynAs<int64_t>(start));
        int e = static_cast<int>(dynAs<int64_t>(end));
        int len = static_cast<int>(list->_data->_storage.size());
        if (s < 0 || e > len || s > e) throw DartRangeError("Invalid range in fillRange");
        T value = fill ? _unboxElem<T>(fill) : T{};
        std::fill(list->_data->_storage.begin() + s, list->_data->_storage.begin() + e, value);
    }
    static void _vptr_clear(AnyGC* self) {
        static_cast<StaticList*>(self)->_data->_storage.clear();
    }
    static void _vptr_sort(AnyGC* self, AnyGC* compare) {
        auto* list = static_cast<StaticList*>(self);
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
                return cmp->typedFnPtr(cmp, a, b) < 0;
            });
    }
    static int64_t _vptr_indexOf(AnyGC* self, AnyGC* element, AnyGC* start) {
        if constexpr (_isEqualityComparable<T>::value) {
            auto* list = static_cast<StaticList*>(self);
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
            auto* list = static_cast<StaticList*>(self);
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
        auto* list = static_cast<StaticList*>(self);
        auto* tf = static_cast<TypeFunction1<bool, T>*>(test);
        int64_t s = start ? dynAs<int64_t>(start) : 0;
        for (int i = static_cast<int>(s); i < list->_data->_storage.size(); i++) {
            if (tf->typedFnPtr(tf, list->_data->_storage[i])) return static_cast<int64_t>(i);
        }
        return static_cast<int64_t>(-1);
    }
    static int64_t _vptr_lastIndexWhere(AnyGC* self, AnyGC* test, AnyGC* start) {
        auto* list = static_cast<StaticList*>(self);
        auto* tf = static_cast<TypeFunction1<bool, T>*>(test);
        int startIdx = start ? static_cast<int>(dynAs<int64_t>(start)) : static_cast<int>(list->_data->_storage.size()) - 1;
        if (startIdx >= static_cast<int>(list->_data->_storage.size())) startIdx = static_cast<int>(list->_data->_storage.size()) - 1;
        for (int i = startIdx; i >= 0; i--) {
            if (tf->typedFnPtr(tf, list->_data->_storage[i])) return static_cast<int64_t>(i);
        }
        return static_cast<int64_t>(-1);
    }
    static void _vptr_forEach(AnyGC* self, AnyGC* func) {
        auto* list = static_cast<StaticList*>(self);
        auto* tf = static_cast<TypeFunction1<void, T>*>(func);
        for (int i = 0; i < list->_data->_storage.size(); i++) tf->typedFnPtr(tf, list->_data->_storage[i]);
    }
    static AnyGC* _vptr_where(AnyGC* self, AnyGC* test) {
        auto* list = static_cast<StaticList*>(self);
        auto* tf = static_cast<TypeFunction1<bool, T>*>(test);
        auto* result = new StaticList<T>();
        for (int i = 0; i < list->_data->_storage.size(); i++) {
            if (tf->typedFnPtr(tf, list->_data->_storage[i])) result->_data->_storage.push_back(list->_data->_storage[i]);
        }
        return static_cast<AnyGC*>(GC::allocateLocal(result));
    }
    static bool _vptr_any_(AnyGC* self, AnyGC* test) {
        auto* list = static_cast<StaticList*>(self);
        auto* tf = static_cast<TypeFunction1<bool, T>*>(test);
        for (int i = 0; i < list->_data->_storage.size(); i++) {
            if (tf->typedFnPtr(tf, list->_data->_storage[i])) return true;
        }
        return false;
    }
    static bool _vptr_every_(AnyGC* self, AnyGC* test) {
        auto* list = static_cast<StaticList*>(self);
        auto* tf = static_cast<TypeFunction1<bool, T>*>(test);
        for (int i = 0; i < list->_data->_storage.size(); i++) {
            if (!tf->typedFnPtr(tf, list->_data->_storage[i])) return false;
        }
        return true;
    }
    static AnyGC* _vptr_firstWhere(AnyGC* self, AnyGC* test, AnyGC* orElse) {
        auto* list = static_cast<StaticList*>(self);
        auto* tf = static_cast<TypeFunction1<bool, T>*>(test);
        for (int i = 0; i < list->_data->_storage.size(); i++) {
            if (tf->typedFnPtr(tf, list->_data->_storage[i])) return _boxElem<T>(list->_data->_storage[i]);
        }
        if (orElse) {
            auto* of = static_cast<TypeFunction0<T>*>(orElse);
            return _boxElem<T>(of->typedFnPtr(of));
        }
        throw DartStateError("No element");
    }
    static AnyGC* _vptr_lastWhere(AnyGC* self, AnyGC* test, AnyGC* orElse) {
        auto* list = static_cast<StaticList*>(self);
        auto* tf = static_cast<TypeFunction1<bool, T>*>(test);
        for (int i = list->_data->_storage.size() - 1; i >= 0; i--) {
            if (tf->typedFnPtr(tf, list->_data->_storage[i])) return _boxElem<T>(list->_data->_storage[i]);
        }
        if (orElse) {
            auto* of = static_cast<TypeFunction0<T>*>(orElse);
            return _boxElem<T>(of->typedFnPtr(of));
        }
        throw DartStateError("No element");
    }
    static AnyGC* _vptr_singleWhere(AnyGC* self, AnyGC* test, AnyGC* orElse) {
        auto* list = static_cast<StaticList*>(self);
        auto* tf = static_cast<TypeFunction1<bool, T>*>(test);
        bool foundMultiple = false;
        T found{};
        bool hasFound = false;
        for (int i = 0; i < list->_data->_storage.size(); i++) {
            if (tf->typedFnPtr(tf, list->_data->_storage[i])) {
                if (hasFound) { foundMultiple = true; break; }
                found = list->_data->_storage[i];
                hasFound = true;
            }
        }
        if (foundMultiple) throw DartStateError("Too many elements");
        if (hasFound) return _boxElem<T>(found);
        if (orElse) {
            auto* of = static_cast<TypeFunction0<T>*>(orElse);
            return _boxElem<T>(of->typedFnPtr(of));
        }
        throw DartStateError("No element");
    }
    static AnyGC* _vptr_reduce(AnyGC* self, AnyGC* combine) {
        auto* list = static_cast<StaticList*>(self);
        if (list->_data->_storage.size() == 0) throw DartStateError("No element");
        auto* cmp = static_cast<TypeFunction2<T, T, T>*>(combine);
        T value = list->_data->_storage[0];
        for (int i = 1; i < list->_data->_storage.size(); i++) value = cmp->typedFnPtr(cmp, value, list->_data->_storage[i]);
        return _boxElem<T>(value);
    }
    static AnyGC* _vptr_take(AnyGC* self, AnyGC* count) {
        auto* list = static_cast<StaticList*>(self);
        int c = static_cast<int>(dynAs<int64_t>(count));
        auto* result = new StaticList<T>();
        int end = c < list->_data->_storage.size() ? c : list->_data->_storage.size();
        for (int i = 0; i < end; i++) result->_data->_storage.push_back(list->_data->_storage[i]);
        return static_cast<AnyGC*>(GC::allocateLocal(result));
    }
    static AnyGC* _vptr_skip(AnyGC* self, AnyGC* count) {
        auto* list = static_cast<StaticList*>(self);
        int c = static_cast<int>(dynAs<int64_t>(count));
        auto* result = new StaticList<T>();
        for (int i = c; i < list->_data->_storage.size(); i++) result->_data->_storage.push_back(list->_data->_storage[i]);
        return static_cast<AnyGC*>(GC::allocateLocal(result));
    }
    static AnyGC* _vptr_takeWhile(AnyGC* self, AnyGC* test) {
        auto* list = static_cast<StaticList*>(self);
        auto* tf = static_cast<TypeFunction1<bool, T>*>(test);
        auto* result = new StaticList<T>();
        for (int i = 0; i < list->_data->_storage.size(); i++) {
            if (!tf->typedFnPtr(tf, list->_data->_storage[i])) break;
            result->_data->_storage.push_back(list->_data->_storage[i]);
        }
        return static_cast<AnyGC*>(GC::allocateLocal(result));
    }
    static AnyGC* _vptr_skipWhile(AnyGC* self, AnyGC* test) {
        auto* list = static_cast<StaticList*>(self);
        auto* tf = static_cast<TypeFunction1<bool, T>*>(test);
        auto* result = new StaticList<T>();
        bool skipping = true;
        for (int i = 0; i < list->_data->_storage.size(); i++) {
            if (skipping && tf->typedFnPtr(tf, list->_data->_storage[i])) continue;
            skipping = false;
            result->_data->_storage.push_back(list->_data->_storage[i]);
        }
        return static_cast<AnyGC*>(GC::allocateLocal(result));
    }
    static AnyGC* _vptr_sublist(AnyGC* self, AnyGC* start, AnyGC* end) {
        auto* list = static_cast<StaticList*>(self);
        int64_t s = dynAs<int64_t>(start);
        int actualEnd = end ? static_cast<int>(dynAs<int64_t>(end)) : list->_data->_storage.size();
        auto* result = new StaticList<T>();
        for (int i = static_cast<int>(s); i < actualEnd; i++) result->_data->_storage.push_back(list->_data->_storage[i]);
        return static_cast<AnyGC*>(GC::allocateLocal(result));
    }
    static AnyGC* _vptr_getRange(AnyGC* self, AnyGC* start, AnyGC* end) {
        auto* list = static_cast<StaticList*>(self);
        int64_t s = dynAs<int64_t>(start);
        int actualEnd = end ? static_cast<int>(dynAs<int64_t>(end)) : list->_data->_storage.size();
        auto* result = new StaticList<T>();
        for (int i = static_cast<int>(s); i < actualEnd; i++) result->_data->_storage.push_back(list->_data->_storage[i]);
        return static_cast<AnyGC*>(GC::allocateLocal(result));
    }
    static AnyGC* _vptr_join(AnyGC* self, AnyGC* separator) {
        auto* list = static_cast<StaticList*>(self);
        std::string result;
        std::string sep = separator ? dynAs<std::string>(separator) : "";
        for (int i = 0; i < list->_data->_storage.size(); i++) {
            if (i > 0) result += sep;
            result += dart_str(list->_data->_storage[i]);
        }
        return _box(result);
    }
    static AnyGC* _vptr_toList(AnyGC* self) {
        auto* list = static_cast<StaticList*>(self);
        auto* result = GC::allocateLocal(new StaticList<T>());
        for (int i = 0; i < list->_data->_storage.size(); i++) result->_data->_storage.push_back(list->_data->_storage[i]);
        return static_cast<AnyGC*>(result);
    }
    static AnyGC* _vptr_toSet(AnyGC* self);   // 定义在 StaticSet 之后
    static AnyGC* _vptr_followedBy(AnyGC* self, AnyGC* other) {
        auto* list = static_cast<StaticList*>(self);
        auto* o = static_cast<StaticList*>(other);
        auto* result = new StaticList<T>();
        for (int i = 0; i < list->_data->_storage.size(); i++) result->_data->_storage.push_back(list->_data->_storage[i]);
        if (o) {
            for (int i = 0; i < o->_data->_storage.size(); i++) result->_data->_storage.push_back(o->_data->_storage[i]);
        }
        return static_cast<AnyGC*>(GC::allocateLocal(result));
    }
    static AnyGC* _vptr_asMap(AnyGC* self);   // 定义在 StaticMap 之后
    static AnyGC* _vptr_plus(AnyGC* self, AnyGC* other) {
        auto* list = static_cast<StaticList*>(self);
        auto* o = static_cast<StaticList*>(other);
        auto* result = new StaticList<T>();
        for (int i = 0; i < list->_data->_storage.size(); i++) result->_data->_storage.push_back(list->_data->_storage[i]);
        if (o) {
            for (int i = 0; i < o->_data->_storage.size(); i++) result->_data->_storage.push_back(o->_data->_storage[i]);
        }
        return static_cast<AnyGC*>(GC::allocateLocal(result));
    }
    static AnyGC* _vptr_elementAt(AnyGC* self, AnyGC* index) {
        auto* list = static_cast<StaticList*>(self);
        return _boxElem<T>(list->_data->_storage[static_cast<int>(dynAs<int64_t>(index))]);
    }
    // Template method dispatch (result emitted as AnyGC*)
    static AnyGC* _vptr_map(AnyGC* self, AnyGC* func) {
        auto* list = static_cast<StaticList*>(self);
        auto* tf = static_cast<TypeFunction1<AnyGC*, T>*>(func);
        auto* result = new StaticList<AnyGC*>();
        for (int i = 0; i < list->_data->_storage.size(); i++) {
            result->_data->_storage.push_back(dynAs<AnyGC*>(tf->fnPtr(tf, list->_data->_storage[i])));
        }
        return static_cast<AnyGC*>(GC::allocateLocal(result));
    }
    static AnyGC* _vptr_expand(AnyGC* self, AnyGC* func) {
        auto* list = static_cast<StaticList*>(self);
        auto* tf = static_cast<TypeFunction1<AnyGC*, T>*>(func);
        auto* result = new StaticList<AnyGC*>();
        for (int i = 0; i < list->_data->_storage.size(); i++) {
            AnyGC* inner = tf->fnPtr(tf, list->_data->_storage[i]);
            if (!inner) continue;
            AnyGC* it = iterator_get(inner);
            while (it && iterator_moveNext(it)) {
                result->_data->_storage.push_back(iterator_current(it));
            }
        }
        return static_cast<AnyGC*>(GC::allocateLocal(result));
    }
    static AnyGC* _vptr_cast_(AnyGC* self) {
        auto* list = static_cast<StaticList*>(self);
        auto* result = new StaticList<AnyGC*>();
        for (int i = 0; i < list->_data->_storage.size(); i++) {
            result->_data->_storage.push_back(_boxElem<T>(list->_data->_storage[i]));
        }
        return static_cast<AnyGC*>(GC::allocateLocal(result));
    }
    static AnyGC* _vptr_fold(AnyGC* self, AnyGC* initial, AnyGC* combine) {
        auto* list = static_cast<StaticList*>(self);
        auto* cmp = static_cast<TypeFunction2<AnyGC*, AnyGC*, T>*>(combine);
        AnyGC* value = initial;
        for (int i = 0; i < list->_data->_storage.size(); i++) {
            value = dynAs<AnyGC*>(cmp->fnPtr(cmp, value, list->_data->_storage[i]));
        }
        return value;
    }
    static AnyGC* _vptr_whereType(AnyGC* self) {
        auto* list = static_cast<StaticList*>(self);
        auto* result = new StaticList<AnyGC*>();
        for (int i = 0; i < list->_data->_storage.size(); i++) {
            if constexpr (std::is_pointer_v<T>) {
                result->_data->_storage.push_back(static_cast<AnyGC*>(list->_data->_storage[i]));
            }
        }
        return static_cast<AnyGC*>(GC::allocateLocal(result));
    }

    // ── GC ──

    static void _gcMark_impl(AnyGC* self, int flag) {
        auto* list = static_cast<StaticList*>(self);
        if (list->_data) _gcMark(list->_data, flag);
    }
};

// Free function templates for range-based for loops on StaticList
template<typename T>
auto begin(StaticList<T>* l) { return l->_data->_storage.begin(); }
template<typename T>
auto end(StaticList<T>* l) { return l->_data->_storage.end(); }

template<typename T>
StaticListClassInfo<T>::StaticListClassInfo() {
    typeName = "List";
    // Base ClassInfo fields
    toString = &StaticList<T>::_vptr_toString;
    get_runtimeType = &StaticList<T>::_vptr_runtimeType;
    get_length = &StaticList<T>::_vptr_length;
    eq = &StaticList<T>::_vptr_eq;
    get_hashCode = &StaticList<T>::_vptr_hashCode;
    contains = &StaticList<T>::_vptr_contains;
    index = &StaticList<T>::_vptr_index;
    setIndex = &StaticList<T>::_vptr_setIndex;
    gcMark = &StaticList<T>::_gcMark_impl;
    // List-specific getters
    get_isEmpty = &StaticList<T>::_vptr_isEmpty;
    get_isNotEmpty = &StaticList<T>::_vptr_isNotEmpty;
    get_first = &StaticList<T>::_vptr_first;
    get_last = &StaticList<T>::_vptr_last;
    get_single = &StaticList<T>::_vptr_single;
    get_reversed = &StaticList<T>::_vptr_reversed;
    get_iterator = &StaticList<T>::_vptr_iterator;
    // List-specific methods
    add = &StaticList<T>::_vptr_add;
    addAll = &StaticList<T>::_vptr_addAll;
    insert = &StaticList<T>::_vptr_insert;
    insertAll = &StaticList<T>::_vptr_insertAll;
    removeAt = &StaticList<T>::_vptr_removeAt;
    remove = &StaticList<T>::_vptr_remove;
    removeLast = &StaticList<T>::_vptr_removeLast;
    removeWhere = &StaticList<T>::_vptr_removeWhere;
    retainWhere = &StaticList<T>::_vptr_retainWhere;
    removeRange = &StaticList<T>::_vptr_removeRange;
    fillRange = &StaticList<T>::_vptr_fillRange;
    clear = &StaticList<T>::_vptr_clear;
    sort = &StaticList<T>::_vptr_sort;
    indexOf = &StaticList<T>::_vptr_indexOf;
    lastIndexOf = &StaticList<T>::_vptr_lastIndexOf;
    indexWhere = &StaticList<T>::_vptr_indexWhere;
    lastIndexWhere = &StaticList<T>::_vptr_lastIndexWhere;
    forEach = &StaticList<T>::_vptr_forEach;
    where = &StaticList<T>::_vptr_where;
    any_ = &StaticList<T>::_vptr_any_;
    every_ = &StaticList<T>::_vptr_every_;
    firstWhere = &StaticList<T>::_vptr_firstWhere;
    lastWhere = &StaticList<T>::_vptr_lastWhere;
    singleWhere = &StaticList<T>::_vptr_singleWhere;
    reduce = &StaticList<T>::_vptr_reduce;
    take = &StaticList<T>::_vptr_take;
    skip = &StaticList<T>::_vptr_skip;
    takeWhile = &StaticList<T>::_vptr_takeWhile;
    skipWhile = &StaticList<T>::_vptr_skipWhile;
    sublist = &StaticList<T>::_vptr_sublist;
    getRange = &StaticList<T>::_vptr_getRange;
    join = &StaticList<T>::_vptr_join;
    toList = &StaticList<T>::_vptr_toList;
    toSet = &StaticList<T>::_vptr_toSet;
    followedBy = &StaticList<T>::_vptr_followedBy;
    asMap = &StaticList<T>::_vptr_asMap;
    plus = &StaticList<T>::_vptr_plus;
    elementAt = &StaticList<T>::_vptr_elementAt;
    map = &StaticList<T>::_vptr_map;
    expand = &StaticList<T>::_vptr_expand;
    cast_ = &StaticList<T>::_vptr_cast_;
    fold = &StaticList<T>::_vptr_fold;
    whereType = &StaticList<T>::_vptr_whereType;
}

template<typename T>
StaticListClassInfo<T> StaticList<T>::_classInfo = StaticListClassInfo<T>();

// ── Array<T>::Array(StaticList<T>*) 实现（需要 StaticList 完整定义） ──

template<typename T>
Array<T>::Array(StaticList<T>* list) {
    AnyGC::_classInfo = &_classInfo;
    if (list) {
        _storage.reserve(list->_data->_storage.size());
        for (int i = 0; i < list->_data->_storage.size(); i++) {
            _storage.push_back(list->_data->_storage[i]);
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

// ── StaticMap<K,V> ──
// 对齐 Dart _collections.dart StaticMap<K,V>

template<typename K, typename V>
struct StaticMap : AnyGC {
    Array<K>* _keys;
    Array<V>* _values;
    static StaticMapClassInfo<K, V> _classInfo;

    StaticMap()
        : _keys(GC::allocateLocal(new Array<K>())),
          _values(GC::allocateLocal(new Array<V>())) { AnyGC::_classInfo = &StaticMap::_classInfo; }

    static StaticMap* empty() {
        return GC::allocateLocal(new StaticMap());
    }

    /// 对齐 Dart: StaticMap.of(source) — 从已有 map 复制
    static StaticMap* of(StaticMap<K, V>* source) {
        auto* result = GC::allocateLocal(new StaticMap());
        if (source) {
            for (int i = 0; i < source->_keys->_storage.size(); i++) {
                result->_keys->_storage.push_back(source->_keys->_storage[i]);
                result->_values->_storage.push_back(source->_values->_storage[i]);
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
            for (int i = 0; i < source->_keys->_storage.size(); i++) {
                auto& k = source->_keys->_storage[i];
                auto& v = source->_values->_storage[i];
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
                result->_keys->_storage.push_back(ck);
                result->_values->_storage.push_back(cv);
            }
        }
        return result;
    }

    /// 对齐 Dart: StaticMap.fromEntries(entries)
    static StaticMap* fromEntries(StaticList<StaticMapEntry<K, V>>* entries) {
        auto* result = GC::allocateLocal(new StaticMap());
        if (entries) {
            for (int i = 0; i < entries->_data->_storage.size(); i++) {
                auto& e = entries->_data->_storage[i];
                result->_keys->_storage.push_back(e.key);
                result->_values->_storage.push_back(e.value);
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
            int len = std::min(keys->_data->_storage.size(), values->_data->_storage.size());
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
        return _box(std::string("Map"));
    }
    static int64_t _vptr_length(AnyGC* self) {
        return static_cast<int64_t>(static_cast<StaticMap*>(self)->_keys->_storage.size());
    }
    static AnyGC* _vptr_toString(AnyGC* self) {
        auto* map = static_cast<StaticMap*>(self);
        if (map->_keys->_storage.size() == 0) return _box(std::string("{}"));
        std::string result = "{";
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
        auto* map = static_cast<StaticMap*>(self);
        K k = _unboxElem<K>(key);
        int idx = array_indexOf(map->_keys, k);
        if (idx == -1) return nullptr;
        return _boxElem<V>(map->_values->_storage[idx]);
    }
    static void _vptr_setIndex(AnyGC* self, AnyGC* key, AnyGC* val) {
        auto* map = static_cast<StaticMap*>(self);
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
        return array_indexOf(static_cast<StaticMap*>(self)->_keys, _unboxElem<K>(key)) != -1;
    }
    // Map-specific getters
    static bool _vptr_isEmpty(AnyGC* self) {
        return static_cast<StaticMap*>(self)->_keys->_storage.size() == 0;
    }
    static bool _vptr_isNotEmpty(AnyGC* self) {
        return static_cast<StaticMap*>(self)->_keys->_storage.size() > 0;
    }
    static AnyGC* _vptr_keys(AnyGC* self) {
        auto* map = static_cast<StaticMap*>(self);
        auto* result = GC::allocateLocal(new StaticList<K>());
        for (int i = 0; i < map->_keys->_storage.size(); i++) result->_data->_storage.push_back(map->_keys->_storage[i]);
        return static_cast<AnyGC*>(result);
    }
    static AnyGC* _vptr_values(AnyGC* self) {
        auto* map = static_cast<StaticMap*>(self);
        auto* result = GC::allocateLocal(new StaticList<V>());
        for (int i = 0; i < map->_values->_storage.size(); i++) result->_data->_storage.push_back(map->_values->_storage[i]);
        return static_cast<AnyGC*>(result);
    }
    static AnyGC* _vptr_entries(AnyGC* self) {
        auto* map = static_cast<StaticMap*>(self);
        auto* result = new StaticList<StaticMapEntry<K, V>>();
        for (int i = 0; i < map->_keys->_storage.size(); i++) {
            result->_data->_storage.push_back(StaticMapEntry<K, V>(map->_keys->_storage[i], map->_values->_storage[i]));
        }
        return static_cast<AnyGC*>(GC::allocateLocal(result));
    }
    // Map-specific methods
    static AnyGC* _vptr_remove(AnyGC* self, AnyGC* key) {
        auto* map = static_cast<StaticMap*>(self);
        K k = _unboxElem<K>(key);
        int idx = array_indexOf(map->_keys, k);
        if (idx == -1) return _boxElem<V>(V());
        array_removeAt(map->_keys, idx);
        return _boxElem<V>(array_removeAt(map->_values, idx));
    }
    static bool _vptr_containsValue(AnyGC* self, AnyGC* val) {
        if constexpr (_isEqualityComparable<V>::value) {
            return array_indexOf(static_cast<StaticMap*>(self)->_values, _unboxElem<V>(val)) != -1;
        } else {
            return false;
        }
    }
    static void _vptr_forEach(AnyGC* self, AnyGC* action) {
        auto* map = static_cast<StaticMap*>(self);
        auto* tf = static_cast<TypeFunction2<void, K, V>*>(action);
        for (int i = 0; i < map->_keys->_storage.size(); i++) tf->typedFnPtr(tf, map->_keys->_storage[i], map->_values->_storage[i]);
    }
    static void _vptr_clear(AnyGC* self) {
        auto* map = static_cast<StaticMap*>(self);
        map->_keys->_storage.clear();
        map->_values->_storage.clear();
    }
    static AnyGC* _vptr_putIfAbsent(AnyGC* self, AnyGC* key, AnyGC* ifAbsent) {
        auto* map = static_cast<StaticMap*>(self);
        K k = _unboxElem<K>(key);
        int idx = array_indexOf(map->_keys, k);
        if (idx != -1) return _boxElem<V>(map->_values->_storage[idx]);
        V value = static_cast<TypeFunction0<V>*>(ifAbsent)->typedFnPtr(ifAbsent);
        map->_keys->_storage.push_back(k);
        map->_values->_storage.push_back(value);
        return _boxElem<V>(value);
    }
    static AnyGC* _vptr_update(AnyGC* self, AnyGC* key, AnyGC* updateFn, AnyGC* ifAbsent) {
        auto* map = static_cast<StaticMap*>(self);
        K k = _unboxElem<K>(key);
        int idx = array_indexOf(map->_keys, k);
        if (idx != -1) {
            V newVal = static_cast<TypeFunction1<V, V>*>(updateFn)->typedFnPtr(updateFn, map->_values->_storage[idx]);
            map->_values->_storage[idx] = newVal;
            return _boxElem<V>(newVal);
        }
        if (ifAbsent) {
            V newVal = static_cast<TypeFunction0<V>*>(ifAbsent)->typedFnPtr(ifAbsent);
            map->_keys->_storage.push_back(k);
            map->_values->_storage.push_back(newVal);
            return _boxElem<V>(newVal);
        }
        throw DartArgumentError("Key not found");
    }
    static void _vptr_updateAll(AnyGC* self, AnyGC* updateFn) {
        auto* map = static_cast<StaticMap*>(self);
        auto* tf = static_cast<TypeFunction2<V, K, V>*>(updateFn);
        for (int i = 0; i < map->_keys->_storage.size(); i++) {
            map->_values->_storage[i] = tf->typedFnPtr(tf, map->_keys->_storage[i], map->_values->_storage[i]);
        }
    }
    static void _vptr_addAll(AnyGC* self, AnyGC* other) {
        auto* map = static_cast<StaticMap*>(self);
        auto* o = static_cast<StaticMap*>(other);
        if (!o) return;
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
        auto* map = static_cast<StaticMap*>(self);
        auto* entries = static_cast<StaticList<StaticMapEntry<K, V>>*>(newEntries);
        if (!entries) return;
        for (int i = 0; i < entries->_data->_storage.size(); i++) {
            auto& e = entries->_data->_storage[i];
            int idx = array_indexOf(map->_keys, e.key);
            if (idx != -1) {
                map->_values->_storage[idx] = e.value;
            } else {
                map->_keys->_storage.push_back(e.key);
                map->_values->_storage.push_back(e.value);
            }
        }
    }
    static void _vptr_removeWhere(AnyGC* self, AnyGC* test) {
        auto* map = static_cast<StaticMap*>(self);
        auto* tf = static_cast<TypeFunction2<bool, K, V>*>(test);
        for (int i = map->_keys->_storage.size() - 1; i >= 0; i--) {
            if (tf->typedFnPtr(tf, map->_keys->_storage[i], map->_values->_storage[i])) {
                array_removeAt(map->_keys, i);
                array_removeAt(map->_values, i);
            }
        }
    }
    static AnyGC* _vptr_map(AnyGC* self, AnyGC* func) {
        auto* map = static_cast<StaticMap*>(self);
        auto* tf = static_cast<TypeFunction2<AnyGC*, K, V>*>(func);
        auto* result = new StaticMap<AnyGC*, AnyGC*>();
        for (int i = 0; i < map->_keys->_storage.size(); i++) {
            auto entry = dynAs<StaticMapEntry<AnyGC*, AnyGC*>>(tf->fnPtr(tf, map->_keys->_storage[i], map->_values->_storage[i]));
            int idx = array_indexOf(result->_keys, entry.key);
            if (idx != -1) {
                result->_values->_storage[idx] = entry.value;
            } else {
                result->_keys->_storage.push_back(entry.key);
                result->_values->_storage.push_back(entry.value);
            }
        }
        return static_cast<AnyGC*>(GC::allocateLocal(result));
    }
    static AnyGC* _vptr_cast_(AnyGC* self) {
        auto* map = static_cast<StaticMap*>(self);
        auto* result = new StaticMap<AnyGC*, AnyGC*>();
        for (int i = 0; i < map->_keys->_storage.size(); i++) {
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
        auto* map = static_cast<StaticMap*>(self);
        if (map->_keys) _gcMark(map->_keys, flag);
        if (map->_values) _gcMark(map->_values, flag);
    }
};

template<typename K, typename V>
StaticMapClassInfo<K, V>::StaticMapClassInfo() {
    typeName = "Map";
    // Base ClassInfo fields
    toString = &StaticMap<K, V>::_vptr_toString;
    get_runtimeType = &StaticMap<K, V>::_vptr_runtimeType;
    get_length = &StaticMap<K, V>::_vptr_length;
    eq = &StaticMap<K, V>::_vptr_eq;
    get_hashCode = &StaticMap<K, V>::_vptr_hashCode;
    index = &StaticMap<K, V>::_vptr_index;
    setIndex = &StaticMap<K, V>::_vptr_setIndex;
    containsKey = &StaticMap<K, V>::_vptr_containsKey;
    gcMark = &StaticMap<K, V>::_gcMark_impl;
    // Map-specific fields
    get_isEmpty = &StaticMap<K, V>::_vptr_isEmpty;
    get_isNotEmpty = &StaticMap<K, V>::_vptr_isNotEmpty;
    get_keys = &StaticMap<K, V>::_vptr_keys;
    get_values = &StaticMap<K, V>::_vptr_values;
    get_entries = &StaticMap<K, V>::_vptr_entries;
    put = &StaticMap<K, V>::_vptr_setIndex;
    remove = &StaticMap<K, V>::_vptr_remove;
    containsValue = &StaticMap<K, V>::_vptr_containsValue;
    forEach = &StaticMap<K, V>::_vptr_forEach;
    clear = &StaticMap<K, V>::_vptr_clear;
    putIfAbsent = &StaticMap<K, V>::_vptr_putIfAbsent;
    update = &StaticMap<K, V>::_vptr_update;
    updateAll = &StaticMap<K, V>::_vptr_updateAll;
    addAll = &StaticMap<K, V>::_vptr_addAll;
    addEntries = &StaticMap<K, V>::_vptr_addEntries;
    removeWhere = &StaticMap<K, V>::_vptr_removeWhere;
    map = &StaticMap<K, V>::_vptr_map;
    cast_ = &StaticMap<K, V>::_vptr_cast_;
}

template<typename K, typename V>
StaticMapClassInfo<K, V> StaticMap<K, V>::_classInfo = StaticMapClassInfo<K, V>();

// ── StaticSet<T> ──
// 对齐 Dart _collections.dart StaticSet<T>

template<typename T>
struct StaticSet : AnyGC {
    static StaticSetClassInfo<T> _classInfo;
    Array<T>* _data;

    StaticSet() : _data(GC::allocateLocal(new Array<T>())) { AnyGC::_classInfo = &_classInfo; }

    StaticSet(std::initializer_list<T> init)
        : _data(GC::allocateLocal(new Array<T>())) {
        AnyGC::_classInfo = &_classInfo;
        for (const auto& e : init) {
            if (!array_contains(_data, e)) _data->_storage.push_back(e);
        }
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
            for (int i = 0; i < source->_data->_storage.size(); i++) {
                auto& elem = source->_data->_storage[i];
                if (!array_contains(result->_data, elem)) result->_data->_storage.push_back(elem);
            }
        }
        return result;
    }

    /// 对齐 Dart: StaticSet.unmodifiable(source) — 语义等同 from
    static StaticSet* unmodifiable(StaticSet<T>* source) {
        auto* result = GC::allocateLocal(new StaticSet());
        if (source) {
            for (int i = 0; i < source->_data->_storage.size(); i++) {
                auto& elem = source->_data->_storage[i];
                if (!array_contains(result->_data, elem)) result->_data->_storage.push_back(elem);
            }
        }
        return result;
    }

    // ── vptrSet support ──
    static AnyGC* _vptr_runtimeType(AnyGC*) {
        return _box(std::string("Set"));
    }
    static int64_t _vptr_length(AnyGC* self) {
        return static_cast<int64_t>(static_cast<StaticSet*>(self)->_data->_storage.size());
    }
    static AnyGC* _vptr_toString(AnyGC* self) {
        auto* set = static_cast<StaticSet*>(self);
        std::string result = "{";
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
            return array_contains(static_cast<StaticSet*>(self)->_data, _unboxElem<T>(element));
        } else {
            return false;
        }
    }
    // Set-specific getters
    static bool _vptr_isEmpty(AnyGC* self) {
        return static_cast<StaticSet*>(self)->_data->_storage.size() == 0;
    }
    static bool _vptr_isNotEmpty(AnyGC* self) {
        return static_cast<StaticSet*>(self)->_data->_storage.size() > 0;
    }
    static AnyGC* _vptr_first(AnyGC* self) {
        auto* set = static_cast<StaticSet*>(self);
        if (set->_data->_storage.size() == 0) throw DartStateError("No element");
        return _boxElem<T>(set->_data->_storage[0]);
    }
    static AnyGC* _vptr_last(AnyGC* self) {
        auto* set = static_cast<StaticSet*>(self);
        if (set->_data->_storage.size() == 0) throw DartStateError("No element");
        return _boxElem<T>(set->_data->_storage[set->_data->_storage.size() - 1]);
    }
    static AnyGC* _vptr_single(AnyGC* self) {
        auto* set = static_cast<StaticSet*>(self);
        if (set->_data->_storage.size() != 1) throw DartStateError("Not single element");
        return _boxElem<T>(set->_data->_storage[0]);
    }
    static AnyGC* _vptr_iterator(AnyGC* self) {
        return static_cast<AnyGC*>(GC::allocateLocal(new StaticIterator<T>(static_cast<StaticSet*>(self)->_data)));
    }
    // Set-specific methods
    static bool _vptr_add(AnyGC* self, AnyGC* element) {
        if constexpr (_isEqualityComparable<T>::value) {
            auto* set = static_cast<StaticSet*>(self);
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
            auto* set = static_cast<StaticSet*>(self);
            auto* o = static_cast<StaticSet*>(other);
            if (!o) return;
            for (int i = 0; i < o->_data->_storage.size(); i++) {
                auto& elem = o->_data->_storage[i];
                if (!array_contains(set->_data, elem)) set->_data->_storage.push_back(elem);
            }
        }
    }
    static bool _vptr_remove(AnyGC* self, AnyGC* element) {
        if constexpr (_isEqualityComparable<T>::value) {
            auto* set = static_cast<StaticSet*>(self);
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
            auto* set = static_cast<StaticSet*>(self);
            auto* o = static_cast<StaticList<T>*>(other);
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
        auto* set = static_cast<StaticSet*>(self);
        auto* tf = static_cast<TypeFunction1<bool, T>*>(test);
        for (int i = set->_data->_storage.size() - 1; i >= 0; i--) {
            if (tf->typedFnPtr(tf, set->_data->_storage[i])) array_removeAt(set->_data, i);
        }
    }
    static void _vptr_retainWhere(AnyGC* self, AnyGC* test) {
        auto* set = static_cast<StaticSet*>(self);
        auto* tf = static_cast<TypeFunction1<bool, T>*>(test);
        for (int i = set->_data->_storage.size() - 1; i >= 0; i--) {
            if (!tf->typedFnPtr(tf, set->_data->_storage[i])) array_removeAt(set->_data, i);
        }
    }
    static void _vptr_clear(AnyGC* self) {
        static_cast<StaticSet*>(self)->_data->_storage.clear();
    }
    static AnyGC* _vptr_lookup(AnyGC* self, AnyGC* element) {
        if constexpr (_isEqualityComparable<T>::value) {
            auto* set = static_cast<StaticSet*>(self);
            int idx = array_indexOf(set->_data, _unboxElem<T>(element));
            if (idx == -1) return nullptr;
            return _boxElem<T>(set->_data->_storage[idx]);
        } else {
            return nullptr;
        }
    }
    static void _vptr_forEach(AnyGC* self, AnyGC* action) {
        auto* set = static_cast<StaticSet*>(self);
        auto* tf = static_cast<TypeFunction1<void, T>*>(action);
        for (int i = 0; i < set->_data->_storage.size(); i++) tf->typedFnPtr(tf, set->_data->_storage[i]);
    }
    static AnyGC* _vptr_where(AnyGC* self, AnyGC* test) {
        if constexpr (_isEqualityComparable<T>::value) {
            auto* set = static_cast<StaticSet*>(self);
            auto* tf = static_cast<TypeFunction1<bool, T>*>(test);
            auto* result = new StaticSet<T>();
            for (int i = 0; i < set->_data->_storage.size(); i++) {
                if (tf->typedFnPtr(tf, set->_data->_storage[i])) {
                    auto& elem = set->_data->_storage[i];
                    if (!array_contains(result->_data, elem)) result->_data->_storage.push_back(elem);
                }
            }
            return static_cast<AnyGC*>(GC::allocateLocal(result));
        } else {
            return static_cast<AnyGC*>(GC::allocateLocal(new StaticSet()));
        }
    }
    static bool _vptr_any_(AnyGC* self, AnyGC* test) {
        auto* set = static_cast<StaticSet*>(self);
        auto* tf = static_cast<TypeFunction1<bool, T>*>(test);
        for (int i = 0; i < set->_data->_storage.size(); i++) {
            if (tf->typedFnPtr(tf, set->_data->_storage[i])) return true;
        }
        return false;
    }
    static bool _vptr_every_(AnyGC* self, AnyGC* test) {
        auto* set = static_cast<StaticSet*>(self);
        auto* tf = static_cast<TypeFunction1<bool, T>*>(test);
        for (int i = 0; i < set->_data->_storage.size(); i++) {
            if (!tf->typedFnPtr(tf, set->_data->_storage[i])) return false;
        }
        return true;
    }
    static AnyGC* _vptr_firstWhere(AnyGC* self, AnyGC* test, AnyGC* orElse) {
        auto* set = static_cast<StaticSet*>(self);
        auto* tf = static_cast<TypeFunction1<bool, T>*>(test);
        for (int i = 0; i < set->_data->_storage.size(); i++) {
            if (tf->typedFnPtr(tf, set->_data->_storage[i])) return _boxElem<T>(set->_data->_storage[i]);
        }
        if (orElse) {
            auto* of = static_cast<TypeFunction0<T>*>(orElse);
            return _boxElem<T>(of->typedFnPtr(of));
        }
        throw DartStateError("No element");
    }
    static AnyGC* _vptr_lastWhere(AnyGC* self, AnyGC* test, AnyGC* orElse) {
        auto* set = static_cast<StaticSet*>(self);
        auto* tf = static_cast<TypeFunction1<bool, T>*>(test);
        for (int i = set->_data->_storage.size() - 1; i >= 0; i--) {
            if (tf->typedFnPtr(tf, set->_data->_storage[i])) return _boxElem<T>(set->_data->_storage[i]);
        }
        if (orElse) {
            auto* of = static_cast<TypeFunction0<T>*>(orElse);
            return _boxElem<T>(of->typedFnPtr(of));
        }
        throw DartStateError("No element");
    }
    static AnyGC* _vptr_singleWhere(AnyGC* self, AnyGC* test, AnyGC* orElse) {
        auto* set = static_cast<StaticSet*>(self);
        auto* tf = static_cast<TypeFunction1<bool, T>*>(test);
        bool foundMultiple = false;
        T found{};
        bool hasFound = false;
        for (int i = 0; i < set->_data->_storage.size(); i++) {
            if (tf->typedFnPtr(tf, set->_data->_storage[i])) {
                if (hasFound) { foundMultiple = true; break; }
                found = set->_data->_storage[i];
                hasFound = true;
            }
        }
        if (foundMultiple) throw DartStateError("Too many elements");
        if (hasFound) return _boxElem<T>(found);
        if (orElse) {
            auto* of = static_cast<TypeFunction0<T>*>(orElse);
            return _boxElem<T>(of->typedFnPtr(of));
        }
        throw DartStateError("No element");
    }
    static AnyGC* _vptr_reduce(AnyGC* self, AnyGC* combine) {
        auto* set = static_cast<StaticSet*>(self);
        if (set->_data->_storage.size() == 0) throw DartStateError("No element");
        auto* cmp = static_cast<TypeFunction2<T, T, T>*>(combine);
        T value = set->_data->_storage[0];
        for (int i = 1; i < set->_data->_storage.size(); i++) value = cmp->typedFnPtr(cmp, value, set->_data->_storage[i]);
        return _boxElem<T>(value);
    }
    static AnyGC* _vptr_unionSet(AnyGC* self, AnyGC* other) {
        if constexpr (_isEqualityComparable<T>::value) {
            auto* set = static_cast<StaticSet*>(self);
            auto* result = new StaticSet<T>();
            for (int i = 0; i < set->_data->_storage.size(); i++) {
                auto& elem = set->_data->_storage[i];
                if (!array_contains(result->_data, elem)) result->_data->_storage.push_back(elem);
            }
            auto* o = static_cast<StaticSet*>(other);
            if (o) {
                for (int i = 0; i < o->_data->_storage.size(); i++) {
                    auto& elem = o->_data->_storage[i];
                    if (!array_contains(result->_data, elem)) result->_data->_storage.push_back(elem);
                }
            }
            return static_cast<AnyGC*>(GC::allocateLocal(result));
        } else {
            return static_cast<AnyGC*>(static_cast<StaticSet*>(self));
        }
    }
    static AnyGC* _vptr_intersection(AnyGC* self, AnyGC* other) {
        if constexpr (_isEqualityComparable<T>::value) {
            auto* set = static_cast<StaticSet*>(self);
            auto* result = new StaticSet<T>();
            auto* o = static_cast<StaticSet*>(other);
            if (!o) return static_cast<AnyGC*>(GC::allocateLocal(result));
            for (int i = 0; i < set->_data->_storage.size(); i++) {
                if (array_contains(o->_data, set->_data->_storage[i])) {
                    auto& elem = set->_data->_storage[i];
                    if (!array_contains(result->_data, elem)) result->_data->_storage.push_back(elem);
                }
            }
            return static_cast<AnyGC*>(GC::allocateLocal(result));
        } else {
            return static_cast<AnyGC*>(GC::allocateLocal(new StaticSet()));
        }
    }
    static AnyGC* _vptr_difference(AnyGC* self, AnyGC* other) {
        if constexpr (_isEqualityComparable<T>::value) {
            auto* set = static_cast<StaticSet*>(self);
            auto* result = new StaticSet<T>();
            auto* o = static_cast<StaticSet*>(other);
            for (int i = 0; i < set->_data->_storage.size(); i++) {
                if (!o || !array_contains(o->_data, set->_data->_storage[i])) {
                    auto& elem = set->_data->_storage[i];
                    if (!array_contains(result->_data, elem)) result->_data->_storage.push_back(elem);
                }
            }
            return static_cast<AnyGC*>(GC::allocateLocal(result));
        } else {
            return static_cast<AnyGC*>(GC::allocateLocal(new StaticSet()));
        }
    }
    static AnyGC* _vptr_toList(AnyGC* self) {
        auto* set = static_cast<StaticSet*>(self);
        auto* result = new StaticList<T>();
        for (int i = 0; i < set->_data->_storage.size(); i++) result->_data->_storage.push_back(set->_data->_storage[i]);
        return static_cast<AnyGC*>(GC::allocateLocal(result));
    }
    static AnyGC* _vptr_toSet(AnyGC* self) {
        if constexpr (_isEqualityComparable<T>::value) {
            auto* set = static_cast<StaticSet*>(self);
            auto* result = new StaticSet<T>();
            for (int i = 0; i < set->_data->_storage.size(); i++) {
                auto& elem = set->_data->_storage[i];
                if (!array_contains(result->_data, elem)) result->_data->_storage.push_back(elem);
            }
            return static_cast<AnyGC*>(GC::allocateLocal(result));
        } else {
            return static_cast<AnyGC*>(GC::allocateLocal(new StaticSet()));
        }
    }
    static AnyGC* _vptr_followedBy(AnyGC* self, AnyGC* other) {
        if constexpr (_isEqualityComparable<T>::value) {
            return _vptr_unionSet(self, other);
        } else {
            return static_cast<AnyGC*>(static_cast<StaticSet*>(self));
        }
    }
    static AnyGC* _vptr_take(AnyGC* self, AnyGC* count) {
        if constexpr (_isEqualityComparable<T>::value) {
            auto* set = static_cast<StaticSet*>(self);
            int64_t n = dynAs<int64_t>(count);
            auto* result = new StaticSet<T>();
            int end = static_cast<int>(n) < set->_data->_storage.size() ? static_cast<int>(n) : set->_data->_storage.size();
            for (int i = 0; i < end; i++) {
                auto& elem = set->_data->_storage[i];
                if (!array_contains(result->_data, elem)) result->_data->_storage.push_back(elem);
            }
            return static_cast<AnyGC*>(GC::allocateLocal(result));
        } else {
            return static_cast<AnyGC*>(GC::allocateLocal(new StaticSet()));
        }
    }
    static AnyGC* _vptr_skip(AnyGC* self, AnyGC* count) {
        if constexpr (_isEqualityComparable<T>::value) {
            auto* set = static_cast<StaticSet*>(self);
            int64_t n = dynAs<int64_t>(count);
            auto* result = new StaticSet<T>();
            for (int i = static_cast<int>(n); i < set->_data->_storage.size(); i++) {
                auto& elem = set->_data->_storage[i];
                if (!array_contains(result->_data, elem)) result->_data->_storage.push_back(elem);
            }
            return static_cast<AnyGC*>(GC::allocateLocal(result));
        } else {
            return static_cast<AnyGC*>(GC::allocateLocal(new StaticSet()));
        }
    }
    static AnyGC* _vptr_takeWhile(AnyGC* self, AnyGC* test) {
        if constexpr (_isEqualityComparable<T>::value) {
            auto* set = static_cast<StaticSet*>(self);
            auto* tf = static_cast<TypeFunction1<bool, T>*>(test);
            auto* result = new StaticSet<T>();
            for (int i = 0; i < set->_data->_storage.size(); i++) {
                if (!tf->typedFnPtr(tf, set->_data->_storage[i])) break;
                auto& elem = set->_data->_storage[i];
                if (!array_contains(result->_data, elem)) result->_data->_storage.push_back(elem);
            }
            return static_cast<AnyGC*>(GC::allocateLocal(result));
        } else {
            return static_cast<AnyGC*>(GC::allocateLocal(new StaticSet()));
        }
    }
    static AnyGC* _vptr_skipWhile(AnyGC* self, AnyGC* test) {
        if constexpr (_isEqualityComparable<T>::value) {
            auto* set = static_cast<StaticSet*>(self);
            auto* tf = static_cast<TypeFunction1<bool, T>*>(test);
            auto* result = new StaticSet<T>();
            bool skipping = true;
            for (int i = 0; i < set->_data->_storage.size(); i++) {
                if (skipping && tf->typedFnPtr(tf, set->_data->_storage[i])) continue;
                skipping = false;
                auto& elem = set->_data->_storage[i];
                if (!array_contains(result->_data, elem)) result->_data->_storage.push_back(elem);
            }
            return static_cast<AnyGC*>(GC::allocateLocal(result));
        } else {
            return static_cast<AnyGC*>(GC::allocateLocal(new StaticSet()));
        }
    }
    static AnyGC* _vptr_join(AnyGC* self, AnyGC* separator) {
        auto* set = static_cast<StaticSet*>(self);
        std::string result;
        std::string sep = separator ? dynAs<std::string>(separator) : std::string();
        for (int i = 0; i < set->_data->_storage.size(); i++) {
            if (i > 0) result += sep;
            result += dart_str(set->_data->_storage[i]);
        }
        return _box(result);
    }
    static AnyGC* _vptr_elementAt(AnyGC* self, AnyGC* index) {
        auto* set = static_cast<StaticSet*>(self);
        return _boxElem<T>(set->_data->_storage[static_cast<int>(dynAs<int64_t>(index))]);
    }
    static AnyGC* _vptr_map(AnyGC* self, AnyGC* func) {
        auto* set = static_cast<StaticSet*>(self);
        auto* tf = static_cast<TypeFunction1<AnyGC*, T>*>(func);
        auto* result = new StaticList<AnyGC*>();
        for (int i = 0; i < set->_data->_storage.size(); i++) {
            result->_data->_storage.push_back(dynAs<AnyGC*>(tf->fnPtr(tf, set->_data->_storage[i])));
        }
        return static_cast<AnyGC*>(GC::allocateLocal(result));
    }
    static AnyGC* _vptr_expand(AnyGC* self, AnyGC* func) {
        auto* set = static_cast<StaticSet*>(self);
        auto* tf = static_cast<TypeFunction1<AnyGC*, T>*>(func);
        auto* result = new StaticList<AnyGC*>();
        for (int i = 0; i < set->_data->_storage.size(); i++) {
            AnyGC* inner = tf->fnPtr(tf, set->_data->_storage[i]);
            if (!inner) continue;
            AnyGC* it = iterator_get(inner);
            while (it && iterator_moveNext(it)) {
                result->_data->_storage.push_back(iterator_current(it));
            }
        }
        return static_cast<AnyGC*>(GC::allocateLocal(result));
    }
    static AnyGC* _vptr_cast_(AnyGC* self) {
        auto* set = static_cast<StaticSet*>(self);
        auto* result = new StaticSet<AnyGC*>();
        for (int i = 0; i < set->_data->_storage.size(); i++) {
            auto* elem = _boxElem<T>(set->_data->_storage[i]);
            if (!array_contains(result->_data, elem)) result->_data->_storage.push_back(elem);
        }
        return GC::allocateLocal(result);
    }
    static AnyGC* _vptr_fold(AnyGC* self, AnyGC* initial, AnyGC* combine) {
        auto* set = static_cast<StaticSet*>(self);
        auto* cmp = static_cast<TypeFunction2<AnyGC*, AnyGC*, T>*>(combine);
        AnyGC* value = initial;
        for (int i = 0; i < set->_data->_storage.size(); i++) {
            value = dynAs<AnyGC*>(cmp->fnPtr(cmp, value, set->_data->_storage[i]));
        }
        return value;
    }
    static AnyGC* _vptr_whereType(AnyGC* self) {
        auto* set = static_cast<StaticSet*>(self);
        auto* result = new StaticSet<AnyGC*>();
        for (int i = 0; i < set->_data->_storage.size(); i++) {
            if constexpr (std::is_pointer_v<T>) {
                auto* elem = static_cast<AnyGC*>(set->_data->_storage[i]);
                if (!array_contains(result->_data, elem)) result->_data->_storage.push_back(elem);
            }
        }
        return GC::allocateLocal(result);
    }

    // ── GC ──

    static void _gcMark_impl(AnyGC* self, int flag) {
        auto* set = static_cast<StaticSet*>(self);
        if (set->_data) _gcMark(set->_data, flag);
    }
};

// Free function templates for range-based for loops on StaticSet
template<typename T>
auto begin(StaticSet<T>* s) { return s->_data->_storage.begin(); }
template<typename T>
auto end(StaticSet<T>* s) { return s->_data->_storage.end(); }

template<typename T>
StaticSetClassInfo<T>::StaticSetClassInfo() {
    typeName = "Set";
    // Base ClassInfo fields
    toString = &StaticSet<T>::_vptr_toString;
    get_runtimeType = &StaticSet<T>::_vptr_runtimeType;
    get_length = &StaticSet<T>::_vptr_length;
    eq = &StaticSet<T>::_vptr_eq;
    get_hashCode = &StaticSet<T>::_vptr_hashCode;
    contains = &StaticSet<T>::_vptr_contains;
    gcMark = &StaticSet<T>::_gcMark_impl;
    // Set-specific fields
    get_isEmpty = &StaticSet<T>::_vptr_isEmpty;
    get_isNotEmpty = &StaticSet<T>::_vptr_isNotEmpty;
    get_first = &StaticSet<T>::_vptr_first;
    get_last = &StaticSet<T>::_vptr_last;
    get_single = &StaticSet<T>::_vptr_single;
    get_iterator = &StaticSet<T>::_vptr_iterator;
    add = &StaticSet<T>::_vptr_add;
    addAll = &StaticSet<T>::_vptr_addAll;
    remove = &StaticSet<T>::_vptr_remove;
    containsAll = &StaticSet<T>::_vptr_containsAll;
    removeWhere = &StaticSet<T>::_vptr_removeWhere;
    retainWhere = &StaticSet<T>::_vptr_retainWhere;
    clear = &StaticSet<T>::_vptr_clear;
    lookup = &StaticSet<T>::_vptr_lookup;
    forEach = &StaticSet<T>::_vptr_forEach;
    where = &StaticSet<T>::_vptr_where;
    any_ = &StaticSet<T>::_vptr_any_;
    every_ = &StaticSet<T>::_vptr_every_;
    firstWhere = &StaticSet<T>::_vptr_firstWhere;
    lastWhere = &StaticSet<T>::_vptr_lastWhere;
    singleWhere = &StaticSet<T>::_vptr_singleWhere;
    reduce = &StaticSet<T>::_vptr_reduce;
    unionSet = &StaticSet<T>::_vptr_unionSet;
    intersection = &StaticSet<T>::_vptr_intersection;
    difference = &StaticSet<T>::_vptr_difference;
    toList = &StaticSet<T>::_vptr_toList;
    toSet = &StaticSet<T>::_vptr_toSet;
    followedBy = &StaticSet<T>::_vptr_followedBy;
    take = &StaticSet<T>::_vptr_take;
    skip = &StaticSet<T>::_vptr_skip;
    takeWhile = &StaticSet<T>::_vptr_takeWhile;
    skipWhile = &StaticSet<T>::_vptr_skipWhile;
    join = &StaticSet<T>::_vptr_join;
    elementAt = &StaticSet<T>::_vptr_elementAt;
    map = &StaticSet<T>::_vptr_map;
    expand = &StaticSet<T>::_vptr_expand;
    cast_ = &StaticSet<T>::_vptr_cast_;
    fold = &StaticSet<T>::_vptr_fold;
    whereType = &StaticSet<T>::_vptr_whereType;
}

template<typename T>
StaticSetClassInfo<T> StaticSet<T>::_classInfo = StaticSetClassInfo<T>();

// ── Type-erased collection → typed collection conversion helpers ──
// map/expand/cast/whereType dispatch returns AnyGC* pointing to a collection
// whose element type is erased. These helpers copy the elements into a properly
// typed collection using dynAs<T> for unboxing/conversion.

template<typename T>
StaticList<T>* _typedListFromAnyGC(AnyGC* obj) {
    if (!obj) return nullptr;
    auto* src = static_cast<StaticList<AnyGC*>*>(obj);
    auto* dst = new StaticList<T>();
    for (int i = 0; i < src->_data->_storage.size(); i++) {
        dst->_data->_storage.push_back(dynAs<T>(src->_data->_storage[i]));
    }
    return GC::allocateLocal(dst);
}

template<typename T>
StaticSet<T>* _typedSetFromAnyGC(AnyGC* obj) {
    if (!obj) return nullptr;
    auto* src = static_cast<StaticSet<AnyGC*>*>(obj);
    auto* dst = new StaticSet<T>();
    for (int i = 0; i < src->_data->_storage.size(); i++) {
        dst->_data->_storage.push_back(dynAs<T>(src->_data->_storage[i]));
    }
    return GC::allocateLocal(dst);
}

template<typename K, typename V>
StaticMap<K, V>* _typedMapFromAnyGC(AnyGC* obj) {
    if (!obj) return nullptr;
    auto* src = static_cast<StaticMap<AnyGC*, AnyGC*>*>(obj);
    auto* dst = new StaticMap<K, V>();
    for (int i = 0; i < src->_keys->_storage.size(); i++) {
        dst->_keys->_storage.push_back(dynAs<K>(src->_keys->_storage[i]));
        dst->_values->_storage.push_back(dynAs<V>(src->_values->_storage[i]));
    }
    return GC::allocateLocal(dst);
}

// ── StaticList 延迟实现（依赖 StaticMap / StaticSet 完整类型） ──

template<typename T>
AnyGC* StaticList<T>::_vptr_asMap(AnyGC* self) {
    if constexpr (_isStaticMapEntry<T>::value) {
        return nullptr;
    } else {
        auto* list = static_cast<StaticList*>(self);
        auto* result = new StaticMap<int, T>();
        for (int i = 0; i < list->_data->_storage.size(); i++) {
            result->_keys->_storage.push_back(i);
            result->_values->_storage.push_back(list->_data->_storage[i]);
        }
        return static_cast<AnyGC*>(GC::allocateLocal(result));
    }
}

template<typename T>
AnyGC* StaticList<T>::_vptr_toSet(AnyGC* self) {
    if constexpr (_isEqualityComparable<T>::value) {
        auto* list = static_cast<StaticList*>(self);
        auto* result = new StaticSet<T>();
        for (int i = 0; i < list->_data->_storage.size(); i++) {
            auto& elem = list->_data->_storage[i];
            if (!array_contains(result->_data, elem)) result->_data->_storage.push_back(elem);
        }
        return static_cast<AnyGC*>(GC::allocateLocal(result));
    } else {
        return static_cast<AnyGC*>(StaticSet<T>::empty());
    }
}


// ============================================================================
// 8. Promise / GlobalScheduler / smAwait — 协作式异步
// ============================================================================

// ── PromiseBase ──
// 对齐 Dart _async.dart Promise / GlobalScheduler / smAwait

// ClassInfo subclass declarations (constructor bodies defined after structs)
struct PromiseBaseClassInfo : ClassInfo {
    PromiseBaseClassInfo();
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
    static PromiseBaseClassInfo _classInfo;
    enum State { READY, PENDING, COMPLETED, ERROR };

    State state = PENDING;
    AnyGC* result = nullptr;
    AnyGC* error = nullptr;
    std::function<void()> startCallback;
    std::function<bool()> onTick;
    std::vector<AnyGC*> keepAlive;

    PromiseBase() { AnyGC::_classInfo = &_classInfo; }

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
        std::string s = "Promise(";
        s += (p->state == COMPLETED ? "completed" : p->state == ERROR ? "error" :
              p->state == PENDING ? "pending" : "ready");
        s += ")";
        return _box(s);
    }
    static AnyGC* _vptr_runtimeType(AnyGC* self) {
        return _box(std::string("Promise"));
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

inline PromiseBaseClassInfo::PromiseBaseClassInfo() {
    typeName = "Promise";
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

inline PromiseBaseClassInfo PromiseBase::_classInfo = PromiseBaseClassInfo();

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
    static Promise<StaticList<T>*>* waitAll(std::vector<Promise<T>*> promises);
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

    GlobalScheduler() = default;

public:
    int64_t _currentTick = 0;

    static GlobalScheduler& instance() {
        return GC::scheduler();
    }

    /// GC 标记：标记所有持有的 Promise
    void gcMark(int flag) {
        for (auto* p : _activePromises) {
            if (p) _gcMark(p, flag);
        }
        for (auto* p : _readyPromises) {
            if (p) _gcMark(p, flag);
        }
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

    void tick() {
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

inline int GC::collect() {
    _currentFlag++;
    int flag = _currentFlag;

    // 标记阶段：GlobalScheduler 持有的 Promise 作为 root
    _scheduler.gcMark(flag);

    // 标记阶段：从每个 root 出发递归标记
    for (auto* root : _roots) {
        _gcMark(root, flag);
    }

    // 清除阶段：收集未被标记的对象
    int beforeCount = static_cast<int>(_objects.size());
    std::vector<AnyGC*> toDelete;
    for (auto* obj : _objects) {
        if (obj->gcFlag != flag) {
            toDelete.push_back(obj);
        }
    }

    // 从 _objects 中移除
    _objects.erase(
        std::remove_if(_objects.begin(), _objects.end(),
            [flag](AnyGC* obj) { return obj->gcFlag != flag; }),
        _objects.end()
    );

    // 重建 _registered
    _registered.clear();
    for (auto* obj : _objects) {
        _registered.insert(obj);
    }

    // 防御性清理 roots（理论上 root 总是被标记的）
    _roots.erase(
        std::remove_if(_roots.begin(), _roots.end(),
            [flag](AnyGC* obj) { return obj->gcFlag != flag; }),
        _roots.end()
    );

    // 释放未被标记的对象内存
    for (auto* obj : toDelete) {
        delete obj;
    }

    return beforeCount - static_cast<int>(_objects.size());
}

// ── PromiseBase 延迟实现（依赖 GlobalScheduler 完整类型） ──

void PromiseBase::_vptr_setStartCallback(AnyGC* self, std::function<void()> cb) {
    auto* p = static_cast<PromiseBase*>(self);
    p->startCallback = std::move(cb);
    GC::allocateLocal(p);
    p->state = READY;
    GlobalScheduler::instance().registerReadyPromise(p);
}

void PromiseBase::_vptr_setTickCallback(AnyGC* self, std::function<bool()> cb) {
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
            promise_completeError(promise, _box(std::string(e.what())));
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
            promise_complete(promise, _box(computation ? computation->typedFnPtr(computation) : T{}));
        } catch (const std::exception& e) {
            promise_completeError(promise, _box(std::string(e.what())));
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
            promise_completeError(nextPromise, _box(std::string(e.what())));
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
    nextPromise->onTick = [self, onValue, nextPromise]() -> bool {
        if (self->state == PromiseBase::COMPLETED) {
            try {
                AnyGC* callbackResult = onValue(dynAs<T>(self->result));
                AnyGC* gcResult = callbackResult;
                PromiseBase* innerPromise = gcResult ? (_isInstanceOf(gcResult, &PromiseBase::_classInfo) ? static_cast<PromiseBase*>(gcResult) : nullptr) : nullptr;
                if (innerPromise) {
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
                promise_completeError(nextPromise, _box(std::string(e.what())));
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
            promise_completeError(nextPromise, _box(std::string(e.what())));
        }
        return nextPromise;
    }

    // 正常场景：延迟执行
    auto* nextPromise = GC::allocateLocal(new Promise<T>());
    nextPromise->onTick = [self, onError, nextPromise]() -> bool {
        if (self->state == PromiseBase::COMPLETED) {
            promise_complete(nextPromise, self->result);
            return true;
        }
        if (self->state == PromiseBase::ERROR) {
            try {
                promise_complete(nextPromise, _box(onError(self->error)));
            } catch (const std::exception& e) {
                promise_completeError(nextPromise, _box(std::string(e.what())));
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
            promise_completeError(nextPromise, _box(std::string(e.what())));
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
    nextPromise->onTick = [self, action, nextPromise]() -> bool {
        if (self->state == PromiseBase::COMPLETED) {
            try {
                action();
                promise_complete(nextPromise, self->result);
            } catch (const std::exception& e) {
                promise_completeError(nextPromise, _box(std::string(e.what())));
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
Promise<StaticList<T>*>* Promise<T>::waitAll(std::vector<Promise<T>*> promises) {
    auto* resultPromise = GC::allocateLocal(new Promise<StaticList<T>*>());
    if (promises.empty()) {
        promise_complete(resultPromise, _box(
            GC::allocateLocal(new StaticList<T>())));
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
            auto* list = GC::allocateLocal(new StaticList<T>());
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

// ── delayed() free function — mirrors Promise.delayed in Dart ──
template<typename T>
Promise<T>* delayed(int ticks, TypeFunction0<T>* computation) {
    return Promise<T>::delayed(ticks, [computation]() -> T {
        return computation->typedFnPtr(computation);
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
    return Promise<T>::delayed(static_cast<int>(delayTicks), computation);
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
            using Arg0 = std::tuple_element_t<0, typename Closure::ArgsTuple>;
            AnyGC* result;
            if constexpr (std::is_same_v<Arg0, AnyGC*>) {
                AnyGC* boxedVal;
                if constexpr (std::is_pointer_v<T>) {
                    boxedVal = static_cast<AnyGC*>(val);
                } else {
                    boxedVal = _box(val);
                }
                result = onValue->fnPtr(onValue, boxedVal);
            } else {
                result = onValue->fnPtr(onValue, val);
            }
            if constexpr (!std::is_void_v<R>) {
                promise_completeTyped(resultPromise, dynAs<R>(result));
            }
            return nullptr;
        }));
        return resultPromise;
    }
};

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
        throw DartStateError("smAwait: deadlock detected after " +
            std::to_string(maxRounds) + " ticks");
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

// ── smAwait passthrough for non-Promise values ──
template<typename T>
inline T smAwait(T value) {
    return value;
}

// ── smAwait(AnyGC*) overloads — 从 AnyGC* 中提取 PromiseBase* ──
template<typename T>
inline T smAwait(AnyGC* promiseValue) {
    PromiseBase* promise = promiseValue ? (_isInstanceOf(promiseValue, &PromiseBase::_classInfo) ? static_cast<PromiseBase*>(promiseValue) : nullptr) : nullptr;
    if (!promise) {
        if constexpr (std::is_same_v<T, AnyGC*>) {
            return promiseValue;
        } else {
            return dynAs<T>(promiseValue);
        }
    }
    return smAwait<T>(promise);
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
            promise_complete(promise, result);
        } catch (const std::exception& e) {
            promise_completeError(promise, _box(std::string(e.what())));
        }
    }, promise);
    return promise;
}

/// drainScheduler — 运行调度器直到所有 Promise 完成
/// 对齐 Dart drainScheduler()，C++ 无原生 Future，直接 tick 直到无活跃工作
inline void drainScheduler() {
    int roundCount = 0;
    while (GlobalScheduler::instance().hasActiveWork()) {
        GlobalScheduler::instance().tick();
        roundCount++;
        if (roundCount > 1000000) {
            throw DartStateError("drainScheduler exceeded max rounds — possible deadlock");
        }
    }
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
    static AsyncStateMachineClassInfo<T> _baseClassInfo;
    int smState = 0;
    Promise<T>* promise;
    AsyncStateMachineClassInfo<T>* _classInfo = nullptr;

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
        return _box(std::string("AsyncStateMachine"));
    }
    static AnyGC* _vptr_runtimeType(AnyGC* self) {
        return _box(std::string("AsyncStateMachine"));
    }
    static bool _vptr_step(AnyGC* self) {
        auto* sm = static_cast<AsyncStateMachine*>(self);
        auto* ci = static_cast<AsyncStateMachineClassInfo<T>*>(sm->AnyGC::_classInfo);
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
AsyncStateMachineClassInfo<T> AsyncStateMachine<T>::_baseClassInfo = []{
    AsyncStateMachineClassInfo<T> ci;
    ci.typeName = "AsyncStateMachine";
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
// 9. 语义包装 — staticPrint / StaticStringBuffer
// ============================================================================

/// 替代 Dart 的 print()，支持各种类型
inline void staticPrint(int64_t value) {
    std::cout << value << std::endl;
}

inline void staticPrint(double value) {
    std::ostringstream oss;
    oss << value;
    std::string s = oss.str();
    if (s.find('.') == std::string::npos && s.find('e') == std::string::npos &&
        s.find('i') == std::string::npos && s.find('n') == std::string::npos) {
        s += ".0";
    }
    std::cout << s << std::endl;
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

/// staticPrint 重载 — 任意 GC 管理的对象指针（StaticList*, StaticMap* 等）
template<typename T>
inline typename std::enable_if<std::is_base_of<AnyGC, T>::value &&
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
        std::cout << _anyToString(value) << std::endl;
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

struct StaticStringBufferClassInfo : ClassInfo {
    StaticStringBufferClassInfo();
    void(*write)(AnyGC*, AnyGC*) = nullptr;
    void(*writeln)(AnyGC*, AnyGC*) = nullptr;
    void(*writeAll)(AnyGC*, AnyGC*, AnyGC*) = nullptr;
    void(*writeCharCode)(AnyGC*, AnyGC*) = nullptr;
    void(*clear)(AnyGC*) = nullptr;
};

/// StaticStringBuffer — 替代 Dart 的 StringBuffer
struct StaticStringBuffer : AnyGC {
    static StaticStringBufferClassInfo _classInfo;
    std::ostringstream _buf;

    StaticStringBuffer() {
        AnyGC::_classInfo = &_classInfo;
        GC::allocateLocal(this);
    }

    // ── ClassInfo dispatch ──
    static AnyGC* _vptr_toString(AnyGC* self) {
        return _box(static_cast<StaticStringBuffer*>(self)->_buf.str());
    }
    static AnyGC* _vptr_runtimeType(AnyGC* self) {
        return _box(std::string("StringBuffer"));
    }
    static int64_t _vptr_length(AnyGC* self) {
        return static_cast<int64_t>(static_cast<StaticStringBuffer*>(self)->_buf.str().length());
    }
    static bool _vptr_isEmpty(AnyGC* self) {
        return static_cast<StaticStringBuffer*>(self)->_buf.str().empty();
    }
    static bool _vptr_isNotEmpty(AnyGC* self) {
        return !static_cast<StaticStringBuffer*>(self)->_buf.str().empty();
    }
    static void _vptr_write(AnyGC* self, AnyGC* value) {
        static_cast<StaticStringBuffer*>(self)->_buf << _anyToString(value);
    }
    static void _vptr_writeln(AnyGC* self, AnyGC* value) {
        auto* sb = static_cast<StaticStringBuffer*>(self);
        if (value) sb->_buf << _anyToString(value);
        sb->_buf << "\n";
    }
    static void _vptr_writeAll(AnyGC* self, AnyGC* objects, AnyGC* separator) {
        auto* sb = static_cast<StaticStringBuffer*>(self);
        auto* objs = static_cast<StaticList<AnyGC*>*>(objects);
        std::string sep = separator ? dynAs<std::string>(separator) : "";
        if (!objs) return;
        for (int i = 0; i < objs->_data->_storage.size(); i++) {
            if (i > 0) sb->_buf << sep;
            sb->_buf << _anyToString(objs->_data->_storage[i]);
        }
    }
    static void _vptr_writeCharCode(AnyGC* self, AnyGC* charCode) {
        static_cast<StaticStringBuffer*>(self)->_buf << static_cast<char>(dynAs<int64_t>(charCode));
    }
    static void _vptr_clear(AnyGC* self) {
        auto* sb = static_cast<StaticStringBuffer*>(self);
        sb->_buf.str("");
        sb->_buf.clear();
    }
    static void _gcMark_impl(AnyGC* self, int flag) {}
};

// Free functions for C++-specific write overloads
inline void sbuf_write(StaticStringBuffer* sb, const std::string& value) {
    sb->_buf << value;
}
inline void sbuf_write(StaticStringBuffer* sb, int64_t value) {
    sb->_buf << value;
}
inline void sbuf_write(StaticStringBuffer* sb, double value) {
    sb->_buf << value;
}
inline void sbuf_write(StaticStringBuffer* sb, bool value) {
    sb->_buf << (value ? "true" : "false");
}
inline void sbuf_writeln(StaticStringBuffer* sb) {
    sb->_buf << "\n";
}
inline void sbuf_writeln(StaticStringBuffer* sb, const std::string& value) {
    sb->_buf << value << "\n";
}
inline void sbuf_write(StaticStringBuffer* sb, AnyGC* value) {
    if (value) sb->_buf << _anyToString(value);
}
inline void sbuf_writeln(StaticStringBuffer* sb, AnyGC* value) {
    if (value) sb->_buf << _anyToString(value);
    sb->_buf << "\n";
}
inline void sbuf_clear(StaticStringBuffer* sb) {
    sb->_buf.str("");
    sb->_buf.clear();
}
inline void sbuf_writeAll(StaticStringBuffer* sb, StaticList<std::string>* objects, const std::string& separator = "") {
    if (!objects) return;
    for (int i = 0; i < objects->_data->_storage.size(); i++) {
        if (i > 0) sb->_buf << separator;
        sb->_buf << objects->_data->_storage[i];
    }
}

inline StaticStringBufferClassInfo::StaticStringBufferClassInfo() {
    typeName = "StringBuffer";
    gcMark = &StaticStringBuffer::_gcMark_impl;
    toString = &StaticStringBuffer::_vptr_toString;
    get_runtimeType = &StaticStringBuffer::_vptr_runtimeType;
    get_length = &StaticStringBuffer::_vptr_length;
    get_isEmpty = &StaticStringBuffer::_vptr_isEmpty;
    get_isNotEmpty = &StaticStringBuffer::_vptr_isNotEmpty;
    write = &StaticStringBuffer::_vptr_write;
    writeln = &StaticStringBuffer::_vptr_writeln;
    writeAll = &StaticStringBuffer::_vptr_writeAll;
    writeCharCode = &StaticStringBuffer::_vptr_writeCharCode;
    clear = &StaticStringBuffer::_vptr_clear;
}

inline StaticStringBufferClassInfo StaticStringBuffer::_classInfo = StaticStringBufferClassInfo();

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
inline std::string _toStr(AnyGC* v) {
    if (!v) return "null";
    if (v->_classInfo && v->_classInfo->toString) {
        return dynAs<std::string>(v->_classInfo->toString(v));
    }
    if (v->_classInfo && !v->_classInfo->typeName.empty()) return v->_classInfo->typeName;
    return "Instance";
}
inline std::string _toStr(TypeFunction* v) { return v ? "[TypeFunction]" : "null"; }
inline std::string _toStr(const DartException& e) { return e.toString(); }
inline std::string _toStr(std::nullptr_t) { return "null"; }
inline std::string _toStr(const ReachabilityError& v) { return v.toStringValue(); }
// 指针类型 _toStr — 处理任意指针（StaticList*, StaticMap* 等）
template<typename T>
inline typename std::enable_if<std::is_base_of<AnyGC, T>::value, std::string>::type
_toStr(T* v) {
    if (!v) return "null";
    const ClassInfo* ci = v->AnyGC::_classInfo;
    if (ci && ci->toString) {
        return dynAs<std::string>(ci->toString(v));
    }
    if (ci && !ci->typeName.empty()) return ci->typeName;
    return "Instance";
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
// 11. String 方法辅助
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

/// dart_str_split — 分割字符串
inline StaticList<std::string>* dart_str_split(const std::string& s, const std::string& delimiter) {
    auto* result = new StaticList<std::string>();
    if (delimiter.empty()) {
        // Split into individual characters
        for (char c : s) {
            result->_data->_storage.push_back(std::string(1, c));
        }
    } else {
        size_t start = 0;
        size_t end = s.find(delimiter);
        while (end != std::string::npos) {
            result->_data->_storage.push_back(s.substr(start, end - start));
            start = end + delimiter.length();
            end = s.find(delimiter, start);
        }
        result->_data->_storage.push_back(s.substr(start));
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

/// dart_str_replaceFirst — 替换首个匹配（可选起始位置）
inline std::string dart_str_replaceFirst(const std::string& s, const std::string& from, const std::string& to, int64_t start) {
    if (from.empty()) return s;
    if (start < 0) start = 0;
    size_t pos = s.find(from, static_cast<size_t>(start));
    if (pos == std::string::npos) return s;
    std::string result = s;
    result.replace(pos, from.length(), to);
    return result;
}

/// dart_str_replaceRange — 替换 [start, end) 区间
inline std::string dart_str_replaceRange(const std::string& s, int64_t start, int64_t end, const std::string& replacement) {
    int64_t len = static_cast<int64_t>(s.size());
    if (start < 0) start = 0;
    if (end < start) end = start;
    if (end > len) end = len;
    std::string result = s;
    result.replace(static_cast<size_t>(start), static_cast<size_t>(end - start), replacement);
    return result;
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

/// dart_str_padLeft — 左侧填充至指定宽度
inline std::string dart_str_padLeft(const std::string& s, int64_t width, const std::string& padding) {
    if (width <= static_cast<int64_t>(s.size())) return s;
    std::string pad = padding.empty() ? std::string(" ") : padding;
    int64_t missing = width - static_cast<int64_t>(s.size());
    std::string prefix;
    if (pad.size() == 1) {
        prefix = std::string(static_cast<size_t>(missing), pad[0]);
    } else {
        int64_t reps = missing / static_cast<int64_t>(pad.size());
        int64_t remainder = missing % static_cast<int64_t>(pad.size());
        for (int64_t i = 0; i < reps; ++i) prefix += pad;
        prefix += pad.substr(0, static_cast<size_t>(remainder));
    }
    return prefix + s;
}

/// dart_str_padRight — 右侧填充至指定宽度
inline std::string dart_str_padRight(const std::string& s, int64_t width, const std::string& padding) {
    if (width <= static_cast<int64_t>(s.size())) return s;
    std::string pad = padding.empty() ? std::string(" ") : padding;
    int64_t missing = width - static_cast<int64_t>(s.size());
    std::string suffix;
    if (pad.size() == 1) {
        suffix = std::string(static_cast<size_t>(missing), pad[0]);
    } else {
        int64_t reps = missing / static_cast<int64_t>(pad.size());
        int64_t remainder = missing % static_cast<int64_t>(pad.size());
        for (int64_t i = 0; i < reps; ++i) suffix += pad;
        suffix += pad.substr(0, static_cast<size_t>(remainder));
    }
    return s + suffix;
}

/// dart_str_lastIndexOf — 从右侧查找子串（可选起始位置）
inline int64_t dart_str_lastIndexOf(const std::string& s, const std::string& pattern, int64_t start) {
    if (pattern.empty()) return static_cast<int64_t>(s.size());
    if (start < 0) return -1;
    size_t searchEnd = static_cast<size_t>(std::min<int64_t>(start + static_cast<int64_t>(pattern.size()) - 1, static_cast<int64_t>(s.size()) - 1));
    if (searchEnd >= s.size() && !s.empty()) searchEnd = s.size() - 1;
    size_t pos = s.rfind(pattern, searchEnd);
    if (pos == std::string::npos) return -1;
    return static_cast<int64_t>(pos);
}

/// dart_str_codeUnitAt — 返回指定位置字符的码元
inline int64_t dart_str_codeUnitAt(const std::string& s, int64_t index) {
    if (index < 0 || static_cast<size_t>(index) >= s.size()) {
        throw DartRangeError("Index out of range");
    }
    return static_cast<int64_t>(static_cast<uint8_t>(s[static_cast<size_t>(index)]));
}

/// dart_str_fromCharCode — 将单个码元转为单字符字符串
inline std::string dart_str_fromCharCode(int64_t code) {
    return std::string(1, static_cast<char>(code));
}

/// dart_str_fromCharCodes — 将码元列表（StaticList<int64_t>）转为字符串
inline std::string dart_str_fromCharCodes(AnyGC* list) {
    auto* l = static_cast<StaticList<int64_t>*>(list);
    std::string s;
    s.reserve(l->_data->_storage.size());
    for (int64_t c : l->_data->_storage) s.push_back(static_cast<char>(c));
    return s;
}

/// dart_int_toRadixString — 将整数按指定进制转换为字符串（radix 2-36）
inline std::string dart_int_toRadixString(int64_t value, int64_t radix) {
    if (radix < 2 || radix > 36) {
        throw DartUnsupportedError("Radix out of range");
    }
    if (value == 0) return "0";
    const char* digits = "0123456789abcdefghijklmnopqrstuvwxyz";
    bool negative = value < 0;
    uint64_t u = negative ? static_cast<uint64_t>(-(value + 1)) + 1 : static_cast<uint64_t>(value);
    std::string result;
    while (u > 0) {
        result.push_back(digits[u % static_cast<uint64_t>(radix)]);
        u /= static_cast<uint64_t>(radix);
    }
    if (negative) result.push_back('-');
    std::reverse(result.begin(), result.end());
    return result;
}

/// dart_double_toStringAsExponential — 双精度浮点数科学计数法字符串
inline std::string dart_double_toStringAsExponential(double value, int64_t fracDigits) {
    if (fracDigits < 0) fracDigits = 0;
    std::ostringstream oss;
    oss << std::scientific << std::setprecision(static_cast<int>(fracDigits)) << value;
    return oss.str();
}

// ============================================================================
// 12. Duration / DateTime / RegExp 包装
// ============================================================================

struct StaticDurationClassInfo : ClassInfo {
    StaticDurationClassInfo();
    int64_t(*get_inDays)(AnyGC*) = nullptr;
    int64_t(*get_inHours)(AnyGC*) = nullptr;
    int64_t(*get_inMinutes)(AnyGC*) = nullptr;
    int64_t(*get_inSeconds)(AnyGC*) = nullptr;
    int64_t(*get_inMilliseconds)(AnyGC*) = nullptr;
    int64_t(*get_inMicroseconds)(AnyGC*) = nullptr;
};

struct StaticDuration : AnyGC {
    static StaticDurationClassInfo _classInfo;
    int64_t inMicroseconds;

    StaticDuration(int64_t us = 0) : inMicroseconds(us) {
        AnyGC::_classInfo = &_classInfo;
    }

    StaticDuration(int64_t days, int64_t hours, int64_t minutes, int64_t seconds,
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

    static StaticDuration milliseconds(int64_t ms) { return StaticDuration(ms * 1000); }
    static StaticDuration seconds(int64_t s) { return StaticDuration(s * 1000000); }
    static StaticDuration minutes(int64_t m) { return StaticDuration(m * 60000000LL); }
    static StaticDuration hours(int64_t h) { return StaticDuration(h * 3600000000LL); }
    static StaticDuration days(int64_t d) { return StaticDuration(d * 86400000000LL); }

    int64_t inMilliseconds() const { return inMicroseconds / 1000; }
    int64_t inSeconds() const { return inMicroseconds / 1000000; }
    int64_t inMinutes() const { return inMicroseconds / 60000000LL; }
    int64_t inHours() const { return inMicroseconds / 3600000000LL; }
    int64_t inDays() const { return inMicroseconds / 86400000000LL; }

    // ── ClassInfo dispatch ──
    static AnyGC* _vptr_toString(AnyGC* self) {
        auto* dur = static_cast<StaticDuration*>(self);
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
        return _box(std::string("Duration"));
    }
    static bool _vptr_eq(AnyGC* self, AnyGC* other) {
        return static_cast<StaticDuration*>(self)->inMicroseconds == static_cast<StaticDuration*>(other)->inMicroseconds;
    }
    static int64_t _vptr_hashCode(AnyGC* self) {
        return static_cast<StaticDuration*>(self)->inMicroseconds;
    }
    static int64_t _vptr_inDays(AnyGC* self) {
        return static_cast<StaticDuration*>(self)->inMicroseconds / 86400000000LL;
    }
    static int64_t _vptr_inHours(AnyGC* self) {
        return static_cast<StaticDuration*>(self)->inMicroseconds / 3600000000LL;
    }
    static int64_t _vptr_inMinutes(AnyGC* self) {
        return static_cast<StaticDuration*>(self)->inMicroseconds / 60000000LL;
    }
    static int64_t _vptr_inSeconds(AnyGC* self) {
        return static_cast<StaticDuration*>(self)->inMicroseconds / 1000000;
    }
    static int64_t _vptr_inMilliseconds(AnyGC* self) {
        return static_cast<StaticDuration*>(self)->inMicroseconds / 1000;
    }
    static int64_t _vptr_inMicroseconds(AnyGC* self) {
        return static_cast<StaticDuration*>(self)->inMicroseconds;
    }
    static void _gcMark_impl(AnyGC* self, int flag) {}
};

inline StaticDurationClassInfo::StaticDurationClassInfo() {
    typeName = "Duration";
    gcMark = &StaticDuration::_gcMark_impl;
    toString = &StaticDuration::_vptr_toString;
    get_runtimeType = &StaticDuration::_vptr_runtimeType;
    eq = &StaticDuration::_vptr_eq;
    get_hashCode = &StaticDuration::_vptr_hashCode;
    get_inDays = &StaticDuration::_vptr_inDays;
    get_inHours = &StaticDuration::_vptr_inHours;
    get_inMinutes = &StaticDuration::_vptr_inMinutes;
    get_inSeconds = &StaticDuration::_vptr_inSeconds;
    get_inMilliseconds = &StaticDuration::_vptr_inMilliseconds;
    get_inMicroseconds = &StaticDuration::_vptr_inMicroseconds;
}
inline StaticDurationClassInfo StaticDuration::_classInfo = StaticDurationClassInfo();

struct StaticDateTimeClassInfo : ClassInfo {
    StaticDateTimeClassInfo();
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

struct StaticDateTime : AnyGC {
    static StaticDateTimeClassInfo _classInfo;
    int64_t _epochUs;
    bool _isUtc = false;

    // tag type to disambiguate the internal microseconds constructor from the public milliseconds one
    struct _MicrosecondsTag {};

    StaticDateTime() : _epochUs(0), _isUtc(false) {
        AnyGC::_classInfo = &_classInfo;
    }
    StaticDateTime(int64_t epochMs, bool utc = false) : _epochUs(epochMs * 1000), _isUtc(utc) {
        AnyGC::_classInfo = &_classInfo;
    }
    StaticDateTime(int64_t epochUs, bool utc, _MicrosecondsTag) : _epochUs(epochUs), _isUtc(utc) {
        AnyGC::_classInfo = &_classInfo;
    }

    StaticDateTime(int64_t year, int64_t month, int64_t day,
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

    // ── 静态工厂 ──

    static StaticDateTime now() {
        auto now = std::chrono::system_clock::now();
        auto us = std::chrono::duration_cast<std::chrono::microseconds>(
            now.time_since_epoch()).count();
        return StaticDateTime(static_cast<int64_t>(us), false, _MicrosecondsTag{});
    }

    static StaticDateTime utc(int64_t year, int64_t month = 1, int64_t day = 1,
                              int64_t hour = 0, int64_t minute = 0, int64_t second = 0,
                              int64_t millisecond = 0, int64_t microsecond = 0) {
        return StaticDateTime(year, month, day, hour, minute, second, millisecond, microsecond, true);
    }

    static StaticDateTime parse(const std::string& formattedString) {
        struct tm t = {};
        int ms = 0;
        if (sscanf(formattedString.c_str(), "%d-%d-%dT%d:%d:%d.%d",
                   &t.tm_year, &t.tm_mon, &t.tm_mday, &t.tm_hour, &t.tm_min, &t.tm_sec, &ms) >= 3) {
            t.tm_year -= 1900; t.tm_mon -= 1;
            return StaticDateTime(static_cast<int64_t>(timegm(&t)) * 1000000 + ms * 1000, true, _MicrosecondsTag{});
        }
        if (sscanf(formattedString.c_str(), "%d-%d-%d %d:%d:%d.%d",
                   &t.tm_year, &t.tm_mon, &t.tm_mday, &t.tm_hour, &t.tm_min, &t.tm_sec, &ms) >= 3) {
            t.tm_year -= 1900; t.tm_mon -= 1;
            return StaticDateTime(static_cast<int64_t>(mktime(&t)) * 1000000 + ms * 1000, false, _MicrosecondsTag{});
        }
        if (sscanf(formattedString.c_str(), "%d-%d-%d",
                   &t.tm_year, &t.tm_mon, &t.tm_mday) >= 3) {
            t.tm_year -= 1900; t.tm_mon -= 1;
            return StaticDateTime(static_cast<int64_t>(mktime(&t)) * 1000000, false, _MicrosecondsTag{});
        }
        throw DartFormatException("Invalid date format: " + formattedString);
    }

    static StaticDateTime tryParse(const std::string& formattedString) {
        try { return parse(formattedString); }
        catch (...) { throw DartFormatException("Invalid date format: " + formattedString); }
    }

    static StaticDateTime fromMillisecondsSinceEpoch(int64_t milliseconds, bool isUtc = false) {
        return StaticDateTime(milliseconds, isUtc);
    }

    static StaticDateTime fromMicrosecondsSinceEpoch(int64_t microseconds, bool isUtc = false) {
        return StaticDateTime(microseconds, isUtc, _MicrosecondsTag{});
    }

    // ── ClassInfo dispatch ──
    static AnyGC* _vptr_toString(AnyGC* self) {
        auto* dt = static_cast<StaticDateTime*>(self);
        time_t time = static_cast<time_t>(dt->_epochUs / 1000000);
        struct tm* t = dt->_isUtc ? std::gmtime(&time) : std::localtime(&time);
        if (!t) return _box(std::string("Invalid Date"));
        char buf[40];
        snprintf(buf, sizeof(buf), "%04d-%02d-%02d %02d:%02d:%02d.%03lld",
                 t->tm_year + 1900, t->tm_mon + 1, t->tm_mday,
                 t->tm_hour, t->tm_min, t->tm_sec,
                 static_cast<long long>((dt->_epochUs / 1000) % 1000));
        return _box(std::string(buf));
    }
    static AnyGC* _vptr_runtimeType(AnyGC* self) {
        return _box(std::string("DateTime"));
    }
    static bool _vptr_eq(AnyGC* self, AnyGC* other) {
        auto* a = static_cast<StaticDateTime*>(self);
        auto* b = static_cast<StaticDateTime*>(other);
        return a->_epochUs == b->_epochUs && a->_isUtc == b->_isUtc;
    }
    static int64_t _vptr_hashCode(AnyGC* self) {
        return static_cast<StaticDateTime*>(self)->_epochUs;
    }
    static int64_t _vptr_year(AnyGC* self) {
        auto* dt = static_cast<StaticDateTime*>(self);
        time_t time = static_cast<time_t>(dt->_epochUs / 1000000);
        struct tm* t = dt->_isUtc ? std::gmtime(&time) : std::localtime(&time);
        return t ? t->tm_year + 1900 : 0;
    }
    static int64_t _vptr_month(AnyGC* self) {
        auto* dt = static_cast<StaticDateTime*>(self);
        time_t time = static_cast<time_t>(dt->_epochUs / 1000000);
        struct tm* t = dt->_isUtc ? std::gmtime(&time) : std::localtime(&time);
        return t ? t->tm_mon + 1 : 0;
    }
    static int64_t _vptr_day(AnyGC* self) {
        auto* dt = static_cast<StaticDateTime*>(self);
        time_t time = static_cast<time_t>(dt->_epochUs / 1000000);
        struct tm* t = dt->_isUtc ? std::gmtime(&time) : std::localtime(&time);
        return t ? t->tm_mday : 0;
    }
    static int64_t _vptr_hour(AnyGC* self) {
        auto* dt = static_cast<StaticDateTime*>(self);
        time_t time = static_cast<time_t>(dt->_epochUs / 1000000);
        struct tm* t = dt->_isUtc ? std::gmtime(&time) : std::localtime(&time);
        return t ? t->tm_hour : 0;
    }
    static int64_t _vptr_minute(AnyGC* self) {
        auto* dt = static_cast<StaticDateTime*>(self);
        time_t time = static_cast<time_t>(dt->_epochUs / 1000000);
        struct tm* t = dt->_isUtc ? std::gmtime(&time) : std::localtime(&time);
        return t ? t->tm_min : 0;
    }
    static int64_t _vptr_second(AnyGC* self) {
        auto* dt = static_cast<StaticDateTime*>(self);
        time_t time = static_cast<time_t>(dt->_epochUs / 1000000);
        struct tm* t = dt->_isUtc ? std::gmtime(&time) : std::localtime(&time);
        return t ? t->tm_sec : 0;
    }
    static int64_t _vptr_millisecond(AnyGC* self) {
        auto* dt = static_cast<StaticDateTime*>(self);
        return (dt->_epochUs / 1000) % 1000;
    }
    static int64_t _vptr_weekday(AnyGC* self) {
        auto* dt = static_cast<StaticDateTime*>(self);
        time_t time = static_cast<time_t>(dt->_epochUs / 1000000);
        struct tm* t = dt->_isUtc ? std::gmtime(&time) : std::localtime(&time);
        if (!t) return 0;
        return t->tm_wday == 0 ? 7 : t->tm_wday;
    }
    static int64_t _vptr_millisecondsSinceEpoch(AnyGC* self) {
        return static_cast<StaticDateTime*>(self)->_epochUs / 1000;
    }
    static int64_t _vptr_microsecondsSinceEpoch(AnyGC* self) {
        return static_cast<StaticDateTime*>(self)->_epochUs;
    }
    static bool _vptr_isUtc(AnyGC* self) {
        return static_cast<StaticDateTime*>(self)->_isUtc;
    }
    static AnyGC* _vptr_toIso8601String(AnyGC* self) {
        auto* dt = static_cast<StaticDateTime*>(self);
        time_t time = static_cast<time_t>(dt->_epochUs / 1000000);
        struct tm* t = dt->_isUtc ? std::gmtime(&time) : std::localtime(&time);
        if (!t) return _box(std::string("Invalid Date"));
        char buf[40];
        snprintf(buf, sizeof(buf), "%04d-%02d-%02dT%02d:%02d:%02d.%03lld%s",
                 t->tm_year + 1900, t->tm_mon + 1, t->tm_mday,
                 t->tm_hour, t->tm_min, t->tm_sec,
                 static_cast<long long>((dt->_epochUs / 1000) % 1000),
                 dt->_isUtc ? "Z" : "");
        return _box(std::string(buf));
    }
    static int64_t _vptr_microsecond(AnyGC* self) {
        return static_cast<StaticDateTime*>(self)->_epochUs % 1000;
    }
    static AnyGC* _vptr_add(AnyGC* self, AnyGC* duration) {
        auto* dt = static_cast<StaticDateTime*>(self);
        auto* dur = static_cast<StaticDuration*>(duration);
        return GC::allocateLocal(new StaticDateTime(dt->_epochUs + dur->inMicroseconds, dt->_isUtc, _MicrosecondsTag{}));
    }
    static AnyGC* _vptr_subtract(AnyGC* self, AnyGC* duration) {
        auto* dt = static_cast<StaticDateTime*>(self);
        auto* dur = static_cast<StaticDuration*>(duration);
        return GC::allocateLocal(new StaticDateTime(dt->_epochUs - dur->inMicroseconds, dt->_isUtc, _MicrosecondsTag{}));
    }
    static AnyGC* _vptr_difference(AnyGC* self, AnyGC* other) {
        auto* dt = static_cast<StaticDateTime*>(self);
        auto* odt = static_cast<StaticDateTime*>(other);
        return GC::allocateLocal(new StaticDuration(dt->_epochUs - odt->_epochUs));
    }
    static bool _vptr_isBefore(AnyGC* self, AnyGC* other) {
        return static_cast<StaticDateTime*>(self)->_epochUs < static_cast<StaticDateTime*>(other)->_epochUs;
    }
    static bool _vptr_isAfter(AnyGC* self, AnyGC* other) {
        return static_cast<StaticDateTime*>(self)->_epochUs > static_cast<StaticDateTime*>(other)->_epochUs;
    }
    static bool _vptr_isAtSameMomentAs(AnyGC* self, AnyGC* other) {
        return static_cast<StaticDateTime*>(self)->_epochUs == static_cast<StaticDateTime*>(other)->_epochUs;
    }
    static AnyGC* _vptr_toUtc(AnyGC* self) {
        auto* dt = static_cast<StaticDateTime*>(self);
        return GC::allocateLocal(new StaticDateTime(dt->_epochUs, true, _MicrosecondsTag{}));
    }
    static AnyGC* _vptr_toLocal(AnyGC* self) {
        auto* dt = static_cast<StaticDateTime*>(self);
        return GC::allocateLocal(new StaticDateTime(dt->_epochUs, false, _MicrosecondsTag{}));
    }
    static void _gcMark_impl(AnyGC* self, int flag) {}
};

inline StaticDateTimeClassInfo::StaticDateTimeClassInfo() {
    typeName = "DateTime";
    gcMark = &StaticDateTime::_gcMark_impl;
    toString = &StaticDateTime::_vptr_toString;
    get_runtimeType = &StaticDateTime::_vptr_runtimeType;
    eq = &StaticDateTime::_vptr_eq;
    get_hashCode = &StaticDateTime::_vptr_hashCode;
    get_year = &StaticDateTime::_vptr_year;
    get_month = &StaticDateTime::_vptr_month;
    get_day = &StaticDateTime::_vptr_day;
    get_hour = &StaticDateTime::_vptr_hour;
    get_minute = &StaticDateTime::_vptr_minute;
    get_second = &StaticDateTime::_vptr_second;
    get_millisecond = &StaticDateTime::_vptr_millisecond;
    get_weekday = &StaticDateTime::_vptr_weekday;
    get_millisecondsSinceEpoch = &StaticDateTime::_vptr_millisecondsSinceEpoch;
    get_microsecondsSinceEpoch = &StaticDateTime::_vptr_microsecondsSinceEpoch;
    get_isUtc = &StaticDateTime::_vptr_isUtc;
    toIso8601String = &StaticDateTime::_vptr_toIso8601String;
    get_microsecond = &StaticDateTime::_vptr_microsecond;
    add = &StaticDateTime::_vptr_add;
    subtract = &StaticDateTime::_vptr_subtract;
    difference = &StaticDateTime::_vptr_difference;
    isBefore = &StaticDateTime::_vptr_isBefore;
    isAfter = &StaticDateTime::_vptr_isAfter;
    isAtSameMomentAs = &StaticDateTime::_vptr_isAtSameMomentAs;
    toUtc = &StaticDateTime::_vptr_toUtc;
    toLocal = &StaticDateTime::_vptr_toLocal;
}
inline StaticDateTimeClassInfo StaticDateTime::_classInfo = StaticDateTimeClassInfo();

struct StaticRegExpMatch : AnyGC {
    std::string fullMatch;
    std::vector<std::string> groups;
    int startPos = 0;
    int endPos = 0;

    StaticRegExpMatch() { AnyGC::_classInfo = &_classInfo; }

    std::string group(int index) const {
        if (index == 0) return fullMatch;
        if (index > 0 && index <= static_cast<int>(groups.size())) return groups[index - 1];
        return "";
    }
    int groupCount() const { return static_cast<int>(groups.size()); }
    int start() const { return startPos; }
    int end() const { return endPos; }
    std::string toString() const override { return fullMatch; }

    static ClassInfo _classInfo;
    static AnyGC* _vptr_toString(AnyGC* self);
    static AnyGC* _vptr_runtimeType(AnyGC*);
    static void _gcMark_impl(AnyGC* self, int flag) {}
};

inline ClassInfo StaticRegExpMatch::_classInfo = []{
    ClassInfo ci;
    ci.typeName = "RegExpMatch";
    ci.gcMark = &StaticRegExpMatch::_gcMark_impl;
    ci.toString = &StaticRegExpMatch::_vptr_toString;
    ci.get_runtimeType = &StaticRegExpMatch::_vptr_runtimeType;
    return ci;
}();

inline AnyGC* StaticRegExpMatch::_vptr_toString(AnyGC* self) {
    return _box(static_cast<StaticRegExpMatch*>(self)->fullMatch);
}
inline AnyGC* StaticRegExpMatch::_vptr_runtimeType(AnyGC*) {
    return _box(std::string("RegExpMatch"));
}

inline std::string _toStr(const StaticRegExpMatch& v) {
    return v.toString();
}

struct StaticRegExp {
    std::string pattern;
    std::regex _regex;
    bool _isMultiLine = false;
    bool _isCaseSensitive = true;
    bool _isUnicode = false;
    bool _isDotAll = false;

    StaticRegExp(const std::string& source,
                 bool multiLine = false, bool caseSensitive = true,
                 bool unicode = false, bool dotAll = false)
        : pattern(source), _isMultiLine(multiLine),
          _isCaseSensitive(caseSensitive), _isUnicode(unicode), _isDotAll(dotAll) {
        if (unicode) {
            throw DartUnsupportedError("RegExp unicode flag is not supported in C++ runtime");
        }
        if (dotAll) {
            throw DartUnsupportedError("RegExp dotAll flag is not supported in C++ runtime");
        }
        auto flags = std::regex::ECMAScript;
        if (multiLine) flags |= std::regex::multiline;
        if (!caseSensitive) flags |= std::regex::icase;
        _regex = std::regex(source, flags);
    }

    bool hasMatch(const std::string& input) const {
        try { return std::regex_search(input, _regex); }
        catch (...) { return false; }
    }

    StaticRegExpMatch* firstMatch(const std::string& input) const {
        std::smatch m;
        if (std::regex_search(input, m, _regex)) {
            auto* result = GC::allocateLocal(new StaticRegExpMatch());
            result->fullMatch = m[0].str();
            result->startPos = static_cast<int>(m.position(0));
            result->endPos = result->startPos + static_cast<int>(m.length(0));
            for (size_t i = 1; i < m.size(); i++) {
                result->groups.push_back(m[i].matched ? m[i].str() : "");
            }
            return result;
        }
        return nullptr;
    }

    StaticList<StaticRegExpMatch>* allMatches(const std::string& str, int start = 0) const {
        auto* result = new StaticList<StaticRegExpMatch>();
        if (start < 0) start = 0;
        if (start >= static_cast<int>(str.length())) return GC::allocateLocal(result);
        std::string s = str.substr(start);
        std::smatch m;
        std::string::const_iterator searchStart = s.cbegin();
        int offset = start;
        while (searchStart != s.cend() && std::regex_search(searchStart, s.cend(), m, _regex)) {
            StaticRegExpMatch match;
            match.fullMatch = m[0].str();
            match.startPos = static_cast<int>(m[0].first - s.cbegin()) + offset;
            match.endPos = match.startPos + static_cast<int>(m.length(0));
            for (size_t i = 1; i < m.size(); i++) {
                match.groups.push_back(m[i].matched ? m[i].str() : "");
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

    StaticRegExpMatch* matchAsPrefix(const std::string& str, int startPos = 0) const {
        if (startPos < 0 || startPos >= static_cast<int>(str.length())) return nullptr;
        std::smatch m;
        auto begin = str.cbegin() + startPos;
        auto end = str.cend();
        if (std::regex_search(begin, end, m, _regex, std::regex_constants::match_continuous)) {
            auto* result = GC::allocateLocal(new StaticRegExpMatch());
            result->fullMatch = m[0].str();
            result->startPos = startPos;
            result->endPos = startPos + static_cast<int>(m.length(0));
            for (size_t i = 1; i < m.size(); i++) {
                result->groups.push_back(m[i].matched ? m[i].str() : "");
            }
            return result;
        }
        return nullptr;
    }

    std::string getPattern() const { return pattern; }
    bool getIsMultiLine() const { return _isMultiLine; }
    bool getIsCaseSensitive() const { return _isCaseSensitive; }
    bool getIsUnicode() const { return _isUnicode; }
    bool getIsDotAll() const { return _isDotAll; }

    static std::string escape(const std::string& text) {
        std::string result;
        for (char c : text) {
            if (std::string("\\.^$|?*+()[]{}").find(c) != std::string::npos) {
                result += '\\';
            }
            result += c;
        }
        return result;
    }

    std::string toString() const { return "RegExp(" + pattern + ")"; }
};

// ============================================================================
// Utility functions for collection operations
// ============================================================================

template<typename T>
StaticList<T>* unmodifiable(StaticList<T>* source) {
    return of(source);
}

template<typename T>
StaticList<T>* of(StaticList<T>* source) {
    if (!source) return GC::allocateLocal(new StaticList<T>());
    return StaticList<T>::from(source);
}

template<typename K, typename V>
StaticMap<K, V>* of(StaticMap<K, V>* source) {
    if (!source) return GC::allocateLocal(new StaticMap<K, V>());
    auto* result = GC::allocateLocal(new StaticMap<K, V>());
    for (int i = 0; i < source->_keys->_storage.size(); i++) {
        result->_keys->_storage.push_back(source->_keys->_storage[i]);
        result->_values->_storage.push_back(source->_values->_storage[i]);
    }
    return result;
}

template<typename T>
StaticSet<T>* of(StaticSet<T>* source) {
    if (!source) return GC::allocateLocal(new StaticSet<T>());
    auto* result = GC::allocateLocal(new StaticSet<T>());
    for (int i = 0; i < source->_data->_storage.size(); i++) {
        result->_data->_storage.push_back(source->_data->_storage[i]);
    }
    return result;
}

template<typename K, typename V>
StaticMap<K, V>* fromEntries(StaticList<StaticMapEntry<K, V>>* entries) {
    if (!entries) return StaticMap<K, V>::empty();
    return StaticMap<K, V>::fromEntries(entries);
}


// StreamValue - wrapper struct for Stream (simplified as StaticList)
template<typename T>
struct StreamValueClassInfo : ClassInfo {
    AnyGC*(*toList)(AnyGC*) = nullptr;
    AnyGC*(*map)(AnyGC*, AnyGC*) = nullptr;
    AnyGC*(*where)(AnyGC*, AnyGC*) = nullptr;
    AnyGC*(*fold)(AnyGC*, AnyGC*, AnyGC*) = nullptr;
    StreamValueClassInfo();
};

template<typename T>
struct StreamValue : AnyGC {
    StaticList<T>* data;
    static StreamValueClassInfo<T> _classInfo;

    StreamValue() : data(GC::allocateLocal(new StaticList<T>())) { AnyGC::_classInfo = &StreamValue::_classInfo; }
    StreamValue(StaticList<T>* d) : data(d) { AnyGC::_classInfo = &StreamValue::_classInfo; }

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
        auto* mapped = GC::allocateLocal(new StaticList<AnyGC*>());
        for (int i = 0; i < s->data->_data->_storage.size(); i++) {
            mapped->_data->_storage.push_back(dynAs<AnyGC*>(tf->fnPtr(tf, s->data->_data->_storage[i])));
        }
        return static_cast<AnyGC*>(GC::allocateLocal(new StreamValue<AnyGC*>(mapped)));
    }
    static AnyGC* _vptr_where(AnyGC* self, AnyGC* test) {
        auto* s = static_cast<StreamValue*>(self);
        auto* tf = static_cast<TypeFunction1<bool, T>*>(test);
        auto* filtered = GC::allocateLocal(new StaticList<T>());
        for (int i = 0; i < s->data->_data->_storage.size(); i++) {
            if (tf->typedFnPtr(tf, s->data->_data->_storage[i])) {
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
            value = dynAs<AnyGC*>(cmp->fnPtr(cmp, value, s->data->_data->_storage[i]));
        }
        return value;
    }
};

// Static member definition
template<typename T>
StreamValueClassInfo<T>::StreamValueClassInfo() {
    typeName = "Stream";
    gcMark = &StreamValue<T>::_gcMark_impl;
    toList = &StreamValue<T>::_vptr_toList;
    map = &StreamValue<T>::_vptr_map;
    where = &StreamValue<T>::_vptr_where;
    fold = &StreamValue<T>::_vptr_fold;
}

template<typename T>
StreamValueClassInfo<T> StreamValue<T>::_classInfo = StreamValueClassInfo<T>();

// Free function wrappers for StreamValue — dispatch through ClassInfo
inline AnyGC* streamValue_toList(AnyGC* self) {
    auto* ci = static_cast<StreamValueClassInfo<AnyGC*>*>(self->_classInfo);
    return ci->toList ? ci->toList(self) : nullptr;
}
inline AnyGC* streamValue_map(AnyGC* self, AnyGC* func) {
    auto* ci = static_cast<StreamValueClassInfo<AnyGC*>*>(self->_classInfo);
    return ci->map ? ci->map(self, func) : nullptr;
}
inline AnyGC* streamValue_where(AnyGC* self, AnyGC* test) {
    auto* ci = static_cast<StreamValueClassInfo<AnyGC*>*>(self->_classInfo);
    return ci->where ? ci->where(self, test) : nullptr;
}
inline AnyGC* streamValue_fold(AnyGC* self, AnyGC* initial, AnyGC* combine) {
    auto* ci = static_cast<StreamValueClassInfo<AnyGC*>*>(self->_classInfo);
    return ci->fold ? ci->fold(self, initial, combine) : nullptr;
}

#endif // DART2CPP_LOWERED_H
