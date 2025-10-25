#ifndef _DART_SYNTAX_FINAL_H_
#define _DART_SYNTAX_FINAL_H_

#include "object.h"
#include "object_extensions_simple.h"

// ============================================================================
// 最终简化的 Dart 语法糖 - 去除不必要的宏
// ============================================================================

// ============================================================================
// 1. 变量声明 - 直接使用 C++ 关键字
// ============================================================================

// var 就是 auto，无需额外宏定义
// var x = dart_int(5);     ->    auto x = dart_int(5);

// const 就是 C++ const，无需额外宏定义  
// const x = dart_int(5);   ->    const auto x = dart_int(5);

// final 在运行时环境中不需要，因为没有编译时优化需求
// late 在运行时环境中不需要，因为没有延迟初始化的特殊语义

// ============================================================================
// 2. 控制流 - 直接使用 C++ 原生语法
// ============================================================================

// Bool 类型有隐式转换，可以直接用于条件判断
// if (condition) {}        ->    if (condition) {}  (无需 .toBool())
// while (condition) {}     ->    while (condition) {} 

// 三元操作符直接使用 C++ 原生语法
// condition ? a : b        ->    condition ? a : b

// ============================================================================
// 3. 保留必要的宏和工具函数
// ============================================================================

// 类型快速构造宏（提升便利性）
#define dart_int(value) Int(value)
#define dart_double(value) Double(value)
#define dart_bool(value) Bool(value)
#define dart_string(value) String(value)

// for-in 循环宏（C++ 没有对应语法）
#define dart_for_each(item_type, item_name, container) \
    for (Int _i(0); _i < (container)->size(); ++_i) { \
        item_type item_name = (container)->get(_i);

#define dart_end_for }

// 集合创建宏（提升便利性）
#define dart_list_int() List<Int>::create()
#define dart_list_string() List<String>::create()
#define dart_list_double() List<Double>::create()

#define dart_set_int() Set<Int>::create()
#define dart_set_string() Set<String>::create() 
#define dart_set_double() Set<Double>::create()

#define dart_map_string_int() Map<String, Int>::create()
#define dart_map_int_string() Map<Int, String>::create()

// 空值处理函数（模板特性需要）
#define dart_is_null(ptr) dart_is_null(ptr)
#define dart_is_not_null(ptr) dart_is_not_null(ptr)
#define dart_null_coalesce(left, right) dart_null_coalesce(left, right)

// 调试和工具宏
#define dart_print(value) \
    do { \
        std::cout << (value).toString().getValue() << std::endl; \
    } while(0)

#define dart_assert(condition, message) \
    do { \
        if (!(condition)) { \
            std::cerr << "Assertion failed: " << message << std::endl; \
            std::abort(); \
        } \
    } while(0)

// ============================================================================
// 4. 最佳实践示例
// ============================================================================

/*
推荐的 Dart 风格 C++ 代码写法：

// 变量声明 - 直接使用 C++ 关键字
auto x = dart_int(5);                    // var x = 5;
const auto pi = dart_double(3.14159);    // const pi = 3.14159;

// 条件判断 - 利用隐式转换
Bool condition = x > dart_int(0);
if (condition) {                         // 直接使用，无需 .toBool()
    dart_print(dart_string("x is positive"));
}

// 三元操作符 - 直接使用
auto result = condition ? dart_string("positive") : dart_string("non-positive");

// 运算符 - 直接使用重载
auto sum = x + dart_int(10);             // 直接使用 +
auto isEqual = sum == dart_int(15);      // 直接使用 ==

// 循环 - 直接使用 C++ 语法
while (x > dart_int(0)) {                // 直接使用 while
    --x;                                 // 直接使用 --
}

// for-in 循环 - 使用宏（C++ 无对应语法）
auto numbers = dart_list_int();
numbers->add(dart_int(1));
numbers->add(dart_int(2));

dart_for_each(Int, num, numbers)
    dart_print(num.toString());
dart_end_for

// 字符串操作 - 直接使用运算符
auto greeting = dart_string("Hello, ");
auto name = dart_string("World");
auto message = greeting + name + dart_string("!");  // 直接拼接

// 复杂表达式 - 组合运算符
Bool complexCondition = (x > dart_int(0)) && (sum != dart_int(20)) || !isEqual;
*/

// ============================================================================
// 5. 删除的不必要宏说明
// ============================================================================

/*
以下宏已被删除，因为有更简洁的原生替代方案：

已删除的宏：
- dart_var         -> 直接使用 auto
- dart_final       -> 运行时不需要
- dart_const       -> 直接使用 const auto  
- dart_if          -> 直接使用 if (Bool 有隐式转换)
- dart_unless      -> 直接使用 if (!(condition))
- dart_ternary     -> 直接使用 C++ 的 condition ? a : b

删除原因：
1. Bool 类型有 operator bool() 隐式转换，可直接用于条件判断
2. C++ 原生语法更简洁，无需额外封装
3. 运行时环境不需要编译时常量语义
4. 减少学习成本，使用标准 C++ 语法
*/

#endif // _DART_SYNTAX_FINAL_H_
