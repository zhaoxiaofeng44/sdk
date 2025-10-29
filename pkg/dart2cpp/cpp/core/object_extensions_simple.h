#ifndef _OBJECT_EXTENSIONS_SIMPLE_H_
#define _OBJECT_EXTENSIONS_SIMPLE_H_

#include "object.h"
#include <sstream>
#include <cstdlib>
#include <cstring>

// ============================================================================
// 简化版扩展功能（避免C++11特性）
// ============================================================================

// ============================================================================
// Int 类型扩展 - 自增自减操作符
// ============================================================================

// 前置自增
inline Int& operator++(Int& val) {
    val.value++;
    return val;
}

// 后置自增
inline Int operator++(Int& val, int) {
    Int temp = val;
    val.value++;
    return temp;
}

// 前置自减
inline Int& operator--(Int& val) {
    val.value--;
    return val;
}

// 后置自减
inline Int operator--(Int& val, int) {
    Int temp = val;
    val.value--;
    return temp;
}

// 无符号右移（作为全局函数）
inline Int dart_unsigned_shift_right(const Int& left, const Int& right) {
    return Int(static_cast<unsigned int>(left.value) >> right.value);
}

// 复合赋值操作符
inline Int& operator+=(Int& left, const Int& right) {
    left.value += right.value;
    return left;
}

inline Int& operator-=(Int& left, const Int& right) {
    left.value -= right.value;
    return left;
}

inline Int& operator*=(Int& left, const Int& right) {
    left.value *= right.value;
    return left;
}

inline Int& operator/=(Int& left, const Int& right) {
    if (right.value == 0) throw std::runtime_error("Division by zero");
    left.value /= right.value;
    return left;
}

inline Int& operator%=(Int& left, const Int& right) {
    if (right.value == 0) throw std::runtime_error("Division by zero");
    left.value %= right.value;
    return left;
}

// ============================================================================
// Double 类型扩展 - 自增自减操作符
// ============================================================================

inline Double& operator++(Double& val) {
    val.value++;
    return val;
}

inline Double operator++(Double& val, int) {
    Double temp = val;
    val.value++;
    return temp;
}

inline Double& operator--(Double& val) {
    val.value--;
    return val;
}

inline Double operator--(Double& val, int) {
    Double temp = val;
    val.value--;
    return temp;
}

// Double 复合赋值操作符
inline Double& operator+=(Double& left, const Double& right) {
    left.value += right.value;
    return left;
}

inline Double& operator-=(Double& left, const Double& right) {
    left.value -= right.value;
    return left;
}

inline Double& operator*=(Double& left, const Double& right) {
    left.value *= right.value;
    return left;
}

inline Double& operator/=(Double& left, const Double& right) {
    left.value /= right.value;
    return left;
}

// ============================================================================
// String 扩展功能 - 简化版
// ============================================================================

// 简单的字符串分割（按单个字符分割）
inline ObjectPtr<List<String> > dart_split_simple(const String& str, char delimiter) {
    ObjectPtr<List<String> > result = List<String>::create();
    std::string s = str.getValue();
    std::string current;
    
    for (size_t i = 0; i < s.length(); ++i) {
        if (s[i] == delimiter) {
            if (!current.empty()) {
                result->add(String(current));
                current.clear();
            }
        } else {
            current += s[i];
        }
    }
    
    if (!current.empty()) {
        result->add(String(current));
    }
    
    return result;
}

// 字符串分割（按字符串分割）
inline ObjectPtr<List<String> > dart_split(const String& str, const String& delimiter) {
    ObjectPtr<List<String> > result = List<String>::create();
    std::string s = str.getValue();
    std::string delim = delimiter.getValue();
    
    if (delim.empty()) {
        result->add(str);
        return result;
    }
    
    size_t start = 0;
    size_t found = s.find(delim);
    
    while (found != std::string::npos) {
        if (found != start) {
            result->add(String(s.substr(start, found - start)));
        }
        start = found + delim.length();
        found = s.find(delim, start);
    }
    
    if (start < s.length()) {
        result->add(String(s.substr(start)));
    }
    
    return result;
}

// 简单的字符串格式化
inline String dart_format_simple(const String& format, const String& arg1) {
    std::string result = format.getValue();
    size_t pos = result.find("{}");
    if (pos != std::string::npos) {
        result.replace(pos, 2, arg1.getValue());
    }
    return String(result);
}

inline String dart_format_simple(const String& format, const String& arg1, const String& arg2) {
    std::string result = format.getValue();
    
    size_t pos1 = result.find("{}");
    if (pos1 != std::string::npos) {
        result.replace(pos1, 2, arg1.getValue());
        
        size_t pos2 = result.find("{}");
        if (pos2 != std::string::npos) {
            result.replace(pos2, 2, arg2.getValue());
        }
    }
    return String(result);
}

// ============================================================================
// 简单的空值检查
// ============================================================================

template<typename T>
inline Bool dart_is_null(const ObjectPtr<T>& ptr) {
    return ptr.isNull();
}

template<typename T>
inline Bool dart_is_not_null(const ObjectPtr<T>& ptr) {
    return ptr.isNotNull();
}

// 空值合并的简化实现
template<typename T>
inline T dart_null_coalesce(const ObjectPtr<T>& left, const T& right) {
    if (left.isNull()) {
        return right;
    }
    return *left;
}

// ============================================================================
// 集合扩展功能
// ============================================================================

// List 扩展 - 查找元素
template<typename T>
inline ObjectPtr<List<T> > dart_where_simple(const ObjectPtr<List<T> >& list, Bool (*predicate)(const T&)) {
    ObjectPtr<List<T> > result = List<T>::create();
    
    for (Int i(0); i.toInt() < list->size().toInt(); ++i) {
        T item = list->get(i);
        if (predicate(item).toBool()) {
            result->add(item);
        }
    }
    
    return result;
}

// List 的简单映射
inline ObjectPtr<List<String> > dart_map_to_string(const ObjectPtr<List<Int> >& list) {
    ObjectPtr<List<String> > result = List<String>::create();
    
    for (Int i(0); i.toInt() < list->size().toInt(); ++i) {
        Int item = list->get(i);
        result->add(item.toString());
    }
    
    return result;
}

// ============================================================================
// 数学工具函数
// ============================================================================

namespace DartMath {
    inline Double abs(const Double& value) {
        return Double(value.toDouble() >= 0 ? value.toDouble() : -value.toDouble());
    }
    
    inline Int abs(const Int& value) {
        return Int(value.toInt() >= 0 ? value.toInt() : -value.toInt());
    }
    
    inline Double min(const Double& a, const Double& b) {
        return a.toDouble() < b.toDouble() ? a : b;
    }
    
    inline Double max(const Double& a, const Double& b) {
        return a.toDouble() > b.toDouble() ? a : b;
    }
    
    inline Int min(const Int& a, const Int& b) {
        return a.toInt() < b.toInt() ? a : b;
    }
    
    inline Int max(const Int& a, const Int& b) {
        return a.toInt() > b.toInt() ? a : b;
    }
}

// ============================================================================
// 类型转换辅助
// ============================================================================

inline Int dart_parse_int(const String& str) {
    int result = 0;
    std::string s = str.getValue();
    
    if (!s.empty()) {
        result = atoi(s.c_str());
    }
    
    return Int(result);
}

inline Double dart_parse_double(const String& str) {
    double result = 0.0;
    std::string s = str.getValue();
    
    if (!s.empty()) {
        result = atof(s.c_str());
    }
    
    return Double(result);
}

// ============================================================================
// 简单的范围类
// ============================================================================

class SimpleRange : public Object {
private:
    Int start_;
    Int end_;
    Int step_;

public:
    SimpleRange(Int start, Int end, Int step = Int(1)) 
        : start_(start), end_(end), step_(step) {
        type_id = 15;
    }
    
    Int get_start() const { return start_; }
    Int get_end() const { return end_; }
    Int get_step() const { return step_; }
    
    Bool contains(const Int& value) const {
        int val = value.toInt();
        int s = start_.toInt();
        int e = end_.toInt();
        int st = step_.toInt();
        
        if (st > 0) {
            return Bool(val >= s && val < e && (val - s) % st == 0);
        } else {
            return Bool(val <= s && val > e && (s - val) % (-st) == 0);
        }
    }
    
    ObjectPtr<List<Int> > toList() const {
        ObjectPtr<List<Int> > result = List<Int>::create();
        int s = start_.toInt();
        int e = end_.toInt();
        int st = step_.toInt();
        
        if (st > 0) {
            for (int i = s; i < e; i += st) {
                result->add(Int(i));
            }
        } else {
            for (int i = s; i > e; i += st) {
                result->add(Int(i));
            }
        }
        
        return result;
    }
    
    String toString() const {
        return String("SimpleRange(" + start_.toString().getValue() + 
                     ".." + end_.toString().getValue() + 
                     ", step: " + step_.toString().getValue() + ")");
    }
};

// 创建范围
inline ObjectPtr<SimpleRange> dart_range_create(Int start, Int end, Int step = Int(1)) {
    return ObjectPtr<SimpleRange>(new SimpleRange(start, end, step));
}

#endif // _OBJECT_EXTENSIONS_SIMPLE_H_
