#ifndef _DART_SYNTAX_SIMPLE_H_
#define _DART_SYNTAX_SIMPLE_H_

#include "object.h"
#include "object_extensions_simple.h"

// ============================================================================
// 简化的 Dart 语法糖宏定义（避免C++11特性）
// ============================================================================

// ============================================================================
// 基本类型快速构造宏
// ============================================================================

#define dart_int(value) Int(value)
#define dart_double(value) Double(value)
#define dart_bool(value) Bool(value)
#define dart_string(value) String(value)

// ============================================================================
// 变量声明宏
// ============================================================================

// 注意：由于不使用C++11的auto，这些宏主要是语义上的标记
#define dart_var 
#define dart_final const
#define dart_const const

// ============================================================================
// 运算符增强宏
// ============================================================================

// 无符号右移
#define UNSIGNED_SHIFT_RIGHT(left, right) dart_unsigned_shift_right(left, right)

// 自增自减的函数形式
#define dart_increment(var) (++(var))
#define dart_decrement(var) (--(var))

// ============================================================================
// 字符串操作宏
// ============================================================================

// 字符串分割
#define dart_split_by_char(str, delimiter) dart_split_simple(str, delimiter)
#define dart_split_by_string(str, delimiter) dart_split(str, delimiter)

// 简单的字符串格式化
#define dart_format1(format, arg1) dart_format_simple(format, arg1)
#define dart_format2(format, arg1, arg2) dart_format_simple(format, arg1, arg2)

// ============================================================================
// 空值检查宏
// ============================================================================

// 空值检查
#define dart_is_null(ptr) dart_is_null(ptr)
#define dart_is_not_null(ptr) dart_is_not_null(ptr)

// 空值合并操作符 ??
#define dart_null_coalesce(left, right) dart_null_coalesce(left, right)

// ============================================================================
// 集合操作宏
// ============================================================================

// List 创建（需要手动指定类型）
#define dart_list_int() List<Int>::create()
#define dart_list_string() List<String>::create()
#define dart_list_double() List<Double>::create()

// Set 创建
#define dart_set_int() Set<Int>::create()
#define dart_set_string() Set<String>::create()
#define dart_set_double() Set<Double>::create()

// Map 创建
#define dart_map_string_int() Map<String, Int>::create()
#define dart_map_int_string() Map<Int, String>::create()

// ============================================================================
// 控制流宏
// ============================================================================

// for-in 循环的模拟
#define dart_for_each(item_type, item_name, container) \
    for (Int _i(0); _i.toInt() < (container)->size().toInt(); ++_i) { \
        item_type item_name = (container)->get(_i);

#define dart_end_for }

// 条件执行
#define dart_if(condition) if ((condition).toBool())
#define dart_unless(condition) if (!(condition).toBool())

// ============================================================================
// 数学操作宏
// ============================================================================

#define dart_abs_int(value) DartMath::abs(value)
#define dart_abs_double(value) DartMath::abs(value)
#define dart_min(a, b) DartMath::min(a, b)
#define dart_max(a, b) DartMath::max(a, b)

// ============================================================================
// 类型转换宏
// ============================================================================

#define dart_parse_int(str) dart_parse_int(str)
#define dart_parse_double(str) dart_parse_double(str)

// ============================================================================
// 范围操作宏
// ============================================================================

// 创建范围
#define dart_range(start, end) dart_range_create(dart_int(start), dart_int(end))
#define dart_range_step(start, end, step) dart_range_create(dart_int(start), dart_int(end), dart_int(step))

// ============================================================================
// 调试和工具宏
// ============================================================================

// 打印
#define dart_print(value) \
    do { \
        std::cout << (value).toString().getValue() << std::endl; \
    } while(0)

// 断言
#define dart_assert(condition, message) \
    do { \
        if (!(condition).toBool()) { \
            std::cerr << "Assertion failed: " << message << std::endl; \
            std::abort(); \
        } \
    } while(0)

// ============================================================================
// 简化的枚举支持
// ============================================================================

// 创建简单的枚举类
#define DART_ENUM_START(name) \
    class name { \
    public: \
        enum Value {

#define DART_ENUM_END(name) \
        }; \
        \
        name() : value_(static_cast<Value>(0)) {} \
        name(Value v) : value_(v) {} \
        \
        Value getValue() const { return value_; } \
        Int toInt() const { return Int(static_cast<int>(value_)); } \
        \
        Bool operator==(const name& other) const { \
            return Bool(value_ == other.value_); \
        } \
        \
        Bool operator!=(const name& other) const { \
            return Bool(value_ != other.value_); \
        } \
        \
    private: \
        Value value_; \
    };

// ============================================================================
// 便利函数宏
// ============================================================================

// 快速创建对象
#define dart_new(type) ObjectPtr<type>(new type())

// 安全的对象方法调用
#define dart_safe_call(obj, method) \
    ((obj).isNotNull().toBool() ? (obj)->method : decltype((obj)->method)())

// 链式方法调用检查
#define dart_chain_call(obj, method) \
    ((obj).isNotNull().toBool() ? (obj)->method : (obj))

// ============================================================================
// 条件表达式宏
// ============================================================================

// 三元操作符的替代
#define dart_ternary(condition, true_value, false_value) \
    ((condition).toBool() ? (true_value) : (false_value))

// ============================================================================
// 字符串操作增强
// ============================================================================

// 检查字符串是否为空
#define dart_string_is_empty(str) (str).get_isEmpty()
#define dart_string_is_not_empty(str) (str).get_isNotEmpty()

// 字符串长度
#define dart_string_length(str) (str).get_length()

// ============================================================================
// List 操作增强
// ============================================================================

// List 基本操作
#define dart_list_add(list, item) (list)->add(item)
#define dart_list_get(list, index) (list)->get(dart_int(index))
#define dart_list_size(list) (list)->size()
#define dart_list_is_empty(list) (list)->isEmpty()
#define dart_list_contains(list, item) (list)->contains(item)

// ============================================================================
// Map 操作增强
// ============================================================================

// Map 基本操作
#define dart_map_put(map, key, value) (map)->put(key, value)
#define dart_map_get(map, key) (map)->get(key)
#define dart_map_contains_key(map, key) (map)->containsKey(key)
#define dart_map_size(map) (map)->size()
#define dart_map_is_empty(map) (map)->isEmpty()

// ============================================================================
// 简单的异常处理
// ============================================================================

#define dart_try try
#define dart_catch_all catch(...)
#define dart_catch(exception_type) catch(const exception_type&)
#define dart_throw(exception) throw exception
#define dart_rethrow throw

#endif // _DART_SYNTAX_SIMPLE_H_
