#ifndef _OBJECT_EXTENSIONS_H_
#define _OBJECT_EXTENSIONS_H_

#include "dart_object.h"
#include "dart_string.h"
#include <sstream>
#include <regex>
#include "dart_macros.h"
// ============================================================================
// 扩展现有类型的功能（不修改原有代码）
// ============================================================================

// ============================================================================
// Int 类型扩展
// ============================================================================

// 注意：复合赋值运算符（+=, -=, *=, /=, %=）已在 dart_object.h 中定义为成员函数
// 这里不再重复定义，避免编译器歧义

// ============================================================================
// Double 类型扩展
// ============================================================================

// 注意：复合赋值运算符（+=, -=, *=, /=）已在 dart_object.h 中定义为成员函数
// 这里不再重复定义，避免编译器歧义




// ============================================================================
// 4. 空值处理宏
// ============================================================================

// 类型特征：检测是否为 ObjectPtr 类型
template<typename T>
struct is_object_ptr : std::false_type {};

template<typename T>
struct is_object_ptr<ObjectPtr<T>> : std::true_type {};

// 模板函数版本的 dart_is_null - 支持 ObjectPtr 类型和值类型
template<typename T>
constexpr bool dart_is_null(const T& obj) {
    if constexpr (is_object_ptr<T>::value) {
        // ObjectPtr 类型：使用 -> 调用 isNull()
        return obj->isNull();
    } else if constexpr (std::is_same_v<T, Nullable>) {
        // Nullable 类型：使用 . 调用 isNull()
        return obj.isNull();
    } else {
        // 其他值类型（Int、Double、String等）：检查 type_id
        // type_id == 0 表示 null
        return obj.type_id == 0;
    }
}

#define dart_is_not_null(ptr) (!dart_is_null(ptr))

// 空安全操作符 ?. 的宏实现
// 用法: aa?.bb?.cc 转换为 dart_null_check(aa, dart_null_check(aa.bb, aa.bb.cc))
// 如果 left 为 null，返回 Null；否则返回 right
#define dart_null_check(left, right)  (dart_is_null(left) ? Null : (right))

// 空合并操作符 ?? 的宏实现
// 用法: aa ?? bb 转换为 dart_null_coalesce(aa, bb)

// Any类型成员访问宏 - 用于dynamic类型变量的成员访问
#define DART_ANY_CALL(any_var, method) \
    (any_var.callMethod(#method))

#define DART_ANY_ACCESS(any_var, property) \
    (any_var.getProperty(#property))
// 如果 left 为 null，返回 right；否则返回 left
// 使用decltype(right)来推导返回类型
#define dart_null_coalesce(left, right)  (dart_is_null(left) ? (right) : decltype(right)(left))

// ============================================================================
// 5. 调试和工具宏
// ============================================================================

#define dart_print(value)                                                      \
  do {                                                                         \
    std::cout << (value).toString().getValue() << std::endl;                   \
  } while (0)

#define dart_assert(condition, message)                                        \
  do {                                                                         \
    if (!(condition)) {                                                        \
      std::cerr << "Assertion failed: " << message << std::endl;               \
      std::abort();                                                            \
    }                                                                          \
  } while (0)

// ============================================================================
// 6. 特殊运算符宏 (C++ 无法直接重载的)
// ============================================================================

// 整数除法（与 / 操作符相同，但语义更明确）
#define INTEGER_DIVISION(left, right) ((left) / (right))

// 无符号右移操作符（调用 object_extensions.h 中的函数）
#define UNSIGNED_SHIFT_RIGHT(left, right) dart_unsigned_shift_right(left, right)


// dart_cast 函数 - 类型转换
template <typename T, typename U>
T dart_cast(U value) {
  return dynamic_cast<T>(value);
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
        while (it->hasNext()) {
            String key = it->currentKey();
            String value = it->currentValue();
            
            std::string placeholder = "${" + key.getValue() + "}";
            size_t pos = result.find(placeholder);
            while (pos != std::string::npos) {
                result.replace(pos, placeholder.length(), value.getValue());
                pos = result.find(placeholder, pos + value.getValue().length());
            }
            it->next();
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

// 修复#19: 展开操作符的不定参数方法实现
// ============================================================================
// List 扩展功能
// ============================================================================

// 为 List 添加扩展操作符 ... (展开操作符的模拟) - 两个参数版本
template<typename T>
ObjectPtr<List<T>> dart_spread(const ObjectPtr<List<T>>& list1, const ObjectPtr<List<T>>& list2) {
    ObjectPtr<List<T>> result = List<T>::create(*list1);
    for (Int i(0); i.toInt() < list2->size().toInt(); ++i) {
        result->add(list2->get(i));
    }
    return result;
}

// dart_spread 可变参数版本 - 支持多个 List 展开
template<typename T>
void _spread_helper(ObjectPtr<List<T>>& /* result */) {
    // 递归终止条件
}

template<typename T, typename... Lists>
void _spread_helper(ObjectPtr<List<T>>& result, const ObjectPtr<List<T>>& first, const Lists&... rest) {
    if (first) {
        for (Int i(0); i.toInt() < first->size().toInt(); ++i) {
            result->add(first->get(i));
        }
    }
    _spread_helper(result, rest...);
}

template<typename T, typename... Lists>
ObjectPtr<List<T>> dart_spread(const ObjectPtr<List<T>>& first, const ObjectPtr<List<T>>& second, const Lists&... rest) {
    ObjectPtr<List<T>> result = List<T>::create();
    _spread_helper(result, first, second, rest...);
    return result;
}

// dart_spread_set - Set 展开操作符
template<typename T>
void _spread_set_helper(ObjectPtr<Set<T>>& /* result */) {
    // 递归终止条件
}

template<typename T, typename... Sets>
void _spread_set_helper(ObjectPtr<Set<T>>& result, const ObjectPtr<Set<T>>& first, const Sets&... rest) {
    if (first) {
        result->addAll(first);
    }
    _spread_set_helper(result, rest...);
}

template<typename T>
ObjectPtr<Set<T>> dart_spread_set(const ObjectPtr<Set<T>>& first) {
    ObjectPtr<Set<T>> result = Set<T>::create();
    if (first) {
        result->addAll(first);
    }
    return result;
}

template<typename T, typename... Sets>
ObjectPtr<Set<T>> dart_spread_set(const ObjectPtr<Set<T>>& first, const Sets&... rest) {
    ObjectPtr<Set<T>> result = Set<T>::create();
    _spread_set_helper(result, first, rest...);
    return result;
}

// dart_spread_map - Map 展开操作符
template<typename K, typename V>
void _spread_map_helper(ObjectPtr<Map<K, V>>& /* result */) {
    // 递归终止条件
}

template<typename K, typename V, typename... Maps>
void _spread_map_helper(ObjectPtr<Map<K, V>>& result, const ObjectPtr<Map<K, V>>& first, const Maps&... rest) {
    if (first) {
        result->addAll(first);
    }
    _spread_map_helper(result, rest...);
}

template<typename K, typename V>
ObjectPtr<Map<K, V>> dart_spread_map(const ObjectPtr<Map<K, V>>& first) {
    ObjectPtr<Map<K, V>> result = Map<K, V>::create();
    if (first) {
        result->addAll(first);
    }
    return result;
}

template<typename K, typename V, typename... Maps>
ObjectPtr<Map<K, V>> dart_spread_map(const ObjectPtr<Map<K, V>>& first, const Maps&... rest) {
    ObjectPtr<Map<K, V>> result = Map<K, V>::create();
    _spread_map_helper(result, first, rest...);
    return result;
}

// dart_spread_with_elements - 展开并添加单个元素
template<typename T>
void _spread_or_add_helper(ObjectPtr<List<T>>& /* result */) {
    // 递归终止条件
}

template<typename T>
void _spread_or_add_helper(ObjectPtr<List<T>>& result, const ObjectPtr<List<T>>& list) {
    if (list) {
        for (Int i(0); i.toInt() < list->size().toInt(); ++i) {
            result->add(list->get(i));
        }
    }
}

template<typename T>
void _spread_or_add_helper(ObjectPtr<List<T>>& result, const T& element) {
    result->add(element);
}

template<typename T, typename First, typename... Rest>
void _spread_or_add_helper(ObjectPtr<List<T>>& result, const First& first, const Rest&... rest) {
    _spread_or_add_helper(result, first);
    _spread_or_add_helper(result, rest...);
}

// dart_list_with_spread - 创建列表并展开/添加元素
template<typename T, typename... Args>
ObjectPtr<List<T>> dart_list_with_spread(const Args&... args) {
    ObjectPtr<List<T>> result = List<T>::create();
    _spread_or_add_helper(result, args...);
    return result;
}

// List 的 where 方法（过滤）
template<typename T, typename PredicateFunc>
ObjectPtr<List<T>> dart_where(const ObjectPtr<List<T>>& list, const ObjectPtr<TypedFunction<PredicateFunc, Bool, T>>& predicate) {
    ObjectPtr<List<T>> result = List<T>::create();
    
    for (int i = 0; i < list->size().toInt(); ++i) {
        T item = list->get(Int(i));
        Any result_any = (*predicate)(item);
        Bool* bool_result = dynamic_cast<Bool*>(&result_any);
        if (bool_result && bool_result->toBool()) {
            result->add(item);
        }
    }
    
    return result;
}

// List 的 map 方法
template<typename T, typename R, typename MapperFunc>
ObjectPtr<List<R>> dart_map(const ObjectPtr<List<T>>& list, const ObjectPtr<TypedFunction<MapperFunc, R, T>>& mapper) {
    ObjectPtr<List<R>> result = List<R>::create();
    auto it = list->iterator();
    while (it->hasNext()) {
        T item = it->next();
        Any result_any = (*mapper)(item);
        result->add(static_cast<R>(result_any));
        
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
        return dart_string("Range(" + start_.toString().getValue() + 
                     ".." + end_.toString().getValue() + 
                     ", step: " + step_.toString().getValue() + ")");
    }
};

// 创建范围的工厂函数
inline ObjectPtr<Range> dart_range(Int start, Int end, Int step = Int(1)) {
    return ObjectPtr<Range>(new Range(start, end, step));
}



// ============================================================================
// 7. 字符串拼接辅助函数
// ============================================================================

// 辅助类型特征：判断是否为字符串类型
template <typename T>
struct is_string_type {
  static constexpr bool value = std::is_same_v<std::decay_t<T>, String> ||
                                std::is_same_v<std::decay_t<T>, const char*> ||
                                std::is_same_v<std::decay_t<T>, char*> ||
                                std::is_array_v<std::remove_reference_t<T>>;
};

// 递归终止函数 - 基础情况
inline String dart_concat() {
  return dart_string("");
}

// 单参数版本 - 专门处理 Any 类型
inline String dart_concat(const Any& arg) {
  return arg.toString();
}

// 可变参数模板版本 - 递归拼接所有 Any 参数
template<typename... Args>
inline String dart_concat(const Any& first, const Args&... rest) {
  return first.toString() + dart_concat(rest...);
}

// ============================================================================
// dart_literal 函数 - 简化的列表创建函数
// ============================================================================
// dart_literal 重载 - 创建空列表
// 辅助函数：递归展开参数包（C++11 兼容）
template <typename T>
void _add_items_helper(ObjectPtr<List<T>>& /* list */) {
  // 递归终止条件 - 参数被注释以避免编译警告
}

template <typename T, typename Arg, typename... Args>
void _add_items_helper(ObjectPtr<List<T>>& list, const Arg& arg, const Args&... args) {
  list->add(static_cast<T>(arg));
  _add_items_helper(list, args...);
}

template <typename T>
ObjectPtr<List<T>> dart_literal() {
  return List<T>::create();
}

// dart_literal 函数 - 创建包含任意数量元素的列表
template <typename T, typename... Args>
ObjectPtr<List<T>> dart_literal(const T& first, const Args&... args) {
  ObjectPtr<List<T>> list = List<T>::create();
  list->add(first);
  // C++11 兼容的递归展开参数包
  _add_items_helper(list, args...);
  return list;
}



#endif // _OBJECT_EXTENSIONS_H_
