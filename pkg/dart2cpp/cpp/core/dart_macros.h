#ifndef _DART_MACROS_H_
#define _DART_MACROS_H_

#include <type_traits>
#include "dart_object.h"
#include "dart_string.h"

// ============================================================================
// Dart2CPP 简化宏定义文件
// ============================================================================
// 去除向前兼容性，只保留必要的宏定义
// ============================================================================

// ============================================================================
// 1. 基础类型快速构造宏
// ============================================================================

#define dart_int(value) Int(value)
#define dart_double(value) Double(value)
#define dart_bool(value) Bool(value)
#define dart_string(value) String(std::string(value))

// ============================================================================
// 2. 集合创建宏
// ============================================================================

// List 创建
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
// 3. 控制流宏
// ============================================================================

// for-in 循环 (C++ 无对应语法，必须使用宏)
#define dart_for_each(item_type, item_name, container)                         \
  for (Int _i(0); _i < (container)->size(); ++_i) {                            \
    item_type item_name = (container)->get(_i);

#define dart_end_for }

// ============================================================================
// 7. 字符串拼接辅助函数
// ============================================================================


// 定义管道操作符
// 链式调用宏辅助 - 智能选择操作符：ObjectPtr 使用 ->，其他使用 .
#define DART_CHAIN_EXPR_VALUE(obj, expr) obj.expr


#define DART_CHAIN_EXPR_OBJECT(obj, expr) obj->expr

// 链式调用宏的递归实现
// 基础情况：只有一个表达式
#define DART_CHAIN_1(obj, expr) \
    ([&](auto&& _obj) -> decltype(auto) { \
        if constexpr (is_object_ptr<std::decay_t<decltype(_obj)>>::value) { \
            _obj->expr; \
        } else { \
            _obj.expr; \
        } \
        return _obj; \
    }(obj))

// 递归情况：多个表达式
#define DART_CHAIN_2(obj, expr, ...) \
    DART_CHAIN_1(DART_CHAIN_1(obj, expr), __VA_ARGS__)

#define DART_CHAIN_3(obj, expr, ...) \
    DART_CHAIN_1(DART_CHAIN_2(obj, expr, __VA_ARGS__))

#define DART_CHAIN_4(obj, expr, ...) \
    DART_CHAIN_1(DART_CHAIN_3(obj, expr, __VA_ARGS__))

#define DART_CHAIN_5(obj, expr, ...) \
    DART_CHAIN_1(DART_CHAIN_4(obj, expr, __VA_ARGS__))

// 获取参数个数的宏
#define DART_CHAIN_GET_COUNT(_1, _2, _3, _4, _5, COUNT, ...) COUNT

// 主要的链式调用宏 - 根据参数个数选择对应的实现
// 用法: dart_chain(obj, expr1, expr2, expr3, ...)
// 示例: dart_chain(counter, add(5), multiply(2), subtract(3))
#define dart_chain(obj, ...) \
    DART_CHAIN_GET_COUNT(__VA_ARGS__, DART_CHAIN_5, DART_CHAIN_4, DART_CHAIN_3, DART_CHAIN_2, DART_CHAIN_1)(obj, __VA_ARGS__)



#endif  // _DART_MACROS_H_
