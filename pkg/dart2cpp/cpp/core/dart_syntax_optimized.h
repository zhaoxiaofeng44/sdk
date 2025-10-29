#ifndef _DART_SYNTAX_OPTIMIZED_H_
#define _DART_SYNTAX_OPTIMIZED_H_

#include "object.h"
#include "object_extensions_simple.h"

// ============================================================================
// 优化的 Dart 语法糖 - 基于用户反馈改进
// ============================================================================

// ============================================================================
// 1. 优化Bool条件判断 - 利用隐式转换
// ============================================================================

// Bool类已有隐式转换操作符，可直接用于条件判断
// 不需要显式调用 .toBool()

// 示例：
// Bool condition = dart_bool(true);
// if (condition) {  // 直接使用，无需 condition.toBool()
//     // 代码块
// }

// ============================================================================
// 2. 优化运算符使用 - 优先使用重载
// ============================================================================

// 对于已实现运算符重载的情况，直接使用运算符语法：

/*
算术运算符（直接使用重载）：
    Int a(5), b(3);
    Int result = a + b;     // 而不是 a.operator_plus(b)
    result = a - b;         // 而不是 a.operator_minus(b)  
    result = a * b;         // 而不是 a.operator_multiply(b)
    result = a / b;         // 而不是 a.operator_divide(b)
    result = a % b;         // 而不是 a.operator_modulo(b)

比较运算符（直接使用重载）：
    Bool cmp1 = a == b;     // 而不是 a.operator==(b)
    Bool cmp2 = a != b;     // 而不是 a.operator!=(b)
    Bool cmp3 = a < b;      // 而不是 a.operator<(b)
    Bool cmp4 = a <= b;     // 而不是 a.operator<=(b)
    Bool cmp5 = a > b;      // 而不是 a.operator>(b)
    Bool cmp6 = a >= b;     // 而不是 a.operator>=(b)

逻辑运算符（直接使用重载）：
    Bool logic1 = cmp1 && cmp2;    // 而不是 cmp1.operator&&(cmp2)
    Bool logic2 = cmp1 || cmp2;    // 而不是 cmp1.operator||(cmp2)
    Bool logic3 = !cmp1;           // 而不是 cmp1.operator!()

自增自减运算符（直接使用重载）：
    ++a;        // 前置自增
    a++;        // 后置自增
    --a;        // 前置自减
    a--;        // 后置自减

复合赋值运算符（直接使用重载）：
    a += b;     // 而不是手动调用函数
    a -= b;
    a *= b;
    a /= b;
    a %= b;

字符串操作（直接使用重载）：
    String str1("hello");
    String str2("world");
    String result = str1 + str2;   // 而不是 str1.operator_concat(str2)
*/

// ============================================================================
// 3. 特殊情况的函数实现
// ============================================================================

// 对于无法直接重载或需要特殊处理的操作，保留函数实现：

// 无符号右移（C++没有对应的重载运算符）
#define UNSIGNED_RIGHT_SHIFT(a, b) dart_unsigned_shift_right(a, b)

// 整除操作（Dart特有的 ~/ 运算符）
#define INTEGER_DIVISION(a, b) (a).integerDivision(b)

// 位运算（返回Int类型，但名称特殊）
#define BITWISE_AND(a, b) (a).operator_bitwise_and(b)
#define BITWISE_OR(a, b) (a).operator_bitwise_or(b)
#define BITWISE_XOR(a, b) (a).operator_bitwise_xor(b)
#define BITWISE_NOT(a) (a).operator_bitwise_not()
#define SHIFT_LEFT(a, b) (a).operator_shift_left(b)
#define SHIFT_RIGHT(a, b) (a).operator_shift_right(b)

// ============================================================================
// 4. 优化的控制流宏
// ============================================================================

// 利用Bool的隐式转换，简化条件判断
#define dart_if_optimized(condition) if (condition)
#define dart_while_optimized(condition) while (condition)

// for-in循环保持原有宏（无法用重载简化）
#define dart_for_each_optimized(item_type, item_name, container) \
    for (Int _i(0); _i < (container)->size(); ++_i) { \
        item_type item_name = (container)->get(_i);

#define dart_end_for_optimized }

// ============================================================================
// 5. 推荐的最佳实践示例
// ============================================================================

/*
// ✅ 推荐写法 - 充分利用运算符重载
void example_optimized_syntax() {
    // 基本类型操作
    Int x(5);
    Int y(3);
    
    // 直接使用运算符（推荐）
    Int sum = x + y;        // 而不是 x.operator_plus(y)
    Int diff = x - y;       // 而不是 x.operator_minus(y)
    Bool isEqual = x == y;  // 而不是 x.operator==(y)
    
    // 条件判断利用隐式转换
    if (isEqual) {          // 而不是 if (isEqual.toBool())
        // 代码块
    }
    
    // 循环条件也可直接使用Bool
    Bool condition = dart_bool(true);
    while (condition) {     // 而不是 while (condition.toBool())
        --x;                // 直接使用自减
        condition = x > dart_int(0);  // 直接比较
    }
    
    // 字符串操作
    String greeting = dart_string("Hello, ");
    String name = dart_string("Dart");
    String message = greeting + name;  // 直接拼接
    
    // 集合操作
    ObjectPtr<List<Int> > numbers = dart_list_int();
    numbers->add(x);
    numbers->add(y);
    
    // 遍历集合
    dart_for_each_optimized(Int, num, numbers)
        dart_print(num.toString());
    dart_end_for_optimized
}

// ❌ 不推荐写法 - 手动调用方法
void example_verbose_syntax() {
    Int x(5);
    Int y(3);
    
    // 冗余的方法调用（不推荐）
    Int sum = x.operator_plus(y);           // 应该用 x + y
    Bool isEqual = x.operator==(y);         // 应该用 x == y
    
    // 不必要的显式转换（不推荐）
    if (isEqual.toBool()) {                 // 应该用 if (isEqual)
        // 代码块
    }
}
*/

// ============================================================================
// 6. 类型转换和工具宏（保持不变）
// ============================================================================

#define dart_int(value) Int(value)
#define dart_double(value) Double(value)
#define dart_bool(value) Bool(value)
#define dart_string(value) String(value)

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
// 7. 空值处理优化
// ============================================================================

// 空值检查（保持函数形式，因为需要模板）
#define is_null(ptr) dart_is_null(ptr)
#define is_not_null(ptr) dart_is_not_null(ptr)

// 空值合并（保持函数形式）
#define null_coalesce(left, right) dart_null_coalesce(left, right)

// ============================================================================
// 8. 集合创建优化宏
// ============================================================================

// 提供更简洁的集合创建方式
#define new_list_int() List<Int>::create()
#define new_list_string() List<String>::create()
#define new_list_double() List<Double>::create()

#define new_set_int() Set<Int>::create()
#define new_set_string() Set<String>::create()
#define new_set_double() Set<Double>::create()

#define new_map_string_int() Map<String, Int>::create()
#define new_map_int_string() Map<Int, String>::create()

#endif // _DART_SYNTAX_OPTIMIZED_H_
