#ifndef _OBJECT_EXTENSIONS_H_
#define _OBJECT_EXTENSIONS_H_

#include "object.h"
#include <sstream>
#include <regex>

// ============================================================================
// 扩展现有类型的功能（不修改原有代码）
// ============================================================================

// ============================================================================
// Int 类型扩展
// ============================================================================

// 为 Int 添加自增自减操作符
inline Int& operator++(Int& val) {
    val.value++;
    return val;
}

inline Int operator++(Int& val, int) {
    Int temp = val;
    val.value++;
    return temp;
}

inline Int& operator--(Int& val) {
    val.value--;
    return val;
}

inline Int operator--(Int& val, int) {
    Int temp = val;
    val.value--;
    return temp;
}

// 为 Int 添加无符号右移操作符（作为全局函数）
inline Int dart_unsigned_shift_right(const Int& left, const Int& right) {
    return Int(static_cast<unsigned int>(left.value) >> right.value);
}

// 为 Int 添加复合赋值操作符
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
// Double 类型扩展
// ============================================================================

// 为 Double 添加自增自减操作符
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

// 为 Double 添加复合赋值操作符
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
// String 类型扩展
// ============================================================================

// 字符串分割功能
class StringExtensions {
public:
    // 字符串分割
    static ObjectPtr<List<String>> split(const String& str, const String& delimiter) {
        ObjectPtr<List<String>> result = List<String>::create();
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
    
    // 简化的字符串插值（使用占位符 ${} ）
    static String interpolate(const String& template_str, const ObjectPtr<Map<String, String>>& variables) {
        std::string result = template_str.getValue();
        
        // 简单的占位符替换：${变量名}
        auto it = variables->iterator();
        while (it.hasNext()) {
            String key = it.currentKey();
            String value = it.currentValue();
            
            std::string placeholder = "${" + key.getValue() + "}";
            size_t pos = result.find(placeholder);
            while (pos != std::string::npos) {
                result.replace(pos, placeholder.length(), value.getValue());
                pos = result.find(placeholder, pos + value.getValue().length());
            }
            it.next();
        }
        
        return String(result);
    }
    
    // 字符串格式化（类似 sprintf）
    template<typename... Args>
    static String format(const String& format, Args... args) {
        std::stringstream ss;
        format_helper(ss, format.getValue(), args...);
        return String(ss.str());
    }

private:
    template<typename T>
    static void format_helper(std::stringstream& ss, const std::string& format, T&& value) {
        size_t pos = format.find("{}");
        if (pos != std::string::npos) {
            ss << format.substr(0, pos) << value << format.substr(pos + 2);
        } else {
            ss << format;
        }
    }
    
    template<typename T, typename... Args>
    static void format_helper(std::stringstream& ss, const std::string& format, T&& value, Args&&... args) {
        size_t pos = format.find("{}");
        if (pos != std::string::npos) {
            ss << format.substr(0, pos) << value;
            format_helper(ss, format.substr(pos + 2), args...);
        } else {
            ss << format;
        }
    }
};

// 为 String 添加新方法（通过全局函数实现）
inline ObjectPtr<List<String>> dart_split(const String& str, const String& delimiter) {
    return StringExtensions::split(str, delimiter);
}

inline String dart_format(const String& format) {
    return format;
}

template<typename... Args>
inline String dart_format(const String& format, Args... args) {
    return StringExtensions::format(format, args...);
}

// ============================================================================
// 空值操作符支持
// ============================================================================

// 空值合并操作符 ?? 的实现
template<typename T>
inline T null_coalesce(const ObjectPtr<T>& left, const T& right) {
    if (left.isNull()) {
        return right;
    }
    return *left;
}

// 条件访问操作符 ?. 的实现
template<typename T, typename F>
inline auto safe_call(const ObjectPtr<T>& obj, F&& func) -> decltype(func(*obj)) {
    if (obj.isNull()) {
        return decltype(func(*obj)){};
    }
    return func(*obj);
}

// ============================================================================
// List 扩展功能
// ============================================================================

// 为 List 添加扩展操作符 ... (展开操作符的模拟)
template<typename T>
ObjectPtr<List<T>> dart_spread(const ObjectPtr<List<T>>& list1, const ObjectPtr<List<T>>& list2) {
    ObjectPtr<List<T>> result = List<T>::create(*list1);
    for (Int i(0); i.toInt() < list2->size().toInt(); ++i) {
        result->add(list2->get(i));
    }
    return result;
}

// List 的 where 方法（过滤）
template<typename T>
ObjectPtr<List<T>> dart_where(const ObjectPtr<List<T>>& list, std::function<Bool(const T&)> predicate) {
    ObjectPtr<List<T>> result = List<T>::create();
    auto it = list->iterator();
    while (it.hasNext()) {
        T item = it.next();
        if (predicate(item).toBool()) {
            result->add(item);
        }
    }
    return result;
}

// List 的 map 方法
template<typename T, typename R>
ObjectPtr<List<R>> dart_map(const ObjectPtr<List<T>>& list, std::function<R(const T&)> mapper) {
    ObjectPtr<List<R>> result = List<R>::create();
    auto it = list->iterator();
    while (it.hasNext()) {
        T item = it.next();
        result->add(mapper(item));
    }
    return result;
}

// ============================================================================
// 类型检查和转换
// ============================================================================

// 类型检查 is 操作符的实现
template<typename T, typename U>
inline Bool dart_is(const U& obj) {
    return Bool(dynamic_cast<const T*>(&obj) != nullptr);
}

// 类型转换 as 操作符的实现
template<typename T, typename U>
inline T& dart_as(U& obj) {
    T* result = dynamic_cast<T*>(&obj);
    if (result == nullptr) {
        throw std::runtime_error("Type cast failed");
    }
    return *result;
}

// ============================================================================
// 范围操作符支持
// ============================================================================

// Dart 风格的范围类
class Range : public Object {
private:
    Int start_;
    Int end_;
    Int step_;

public:
    Range(Int start, Int end, Int step = Int(1)) : start_(start), end_(end), step_(step) {
        type_id = 11;
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
    
    ObjectPtr<List<Int>> toList() const {
        ObjectPtr<List<Int>> result = List<Int>::create();
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
    
    String toString() const override {
        return String("Range(" + start_.toString().getValue() + 
                     ".." + end_.toString().getValue() + 
                     ", step: " + step_.toString().getValue() + ")");
    }
};

// 创建范围的工厂函数
inline ObjectPtr<Range> dart_range(Int start, Int end, Int step = Int(1)) {
    return ObjectPtr<Range>(new Range(start, end, step));
}

#endif // _OBJECT_EXTENSIONS_H_
