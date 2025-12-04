// ============================================================================
// C++ 运算符测试用例 - 符合新规范
// 测试所有运算符重载功能
// 规范：使用 dart_int(), dart_double(), dart_bool(), dart_string() 包装常量
// 规范：不使用 .getValue() 直接访问原值，所有运算通过运算符重载完成
// ============================================================================

#include "../core/dart2cpp.h"
#include <iostream>
#include <cassert>
#include <cmath>

// 测试框架宏
#define TEST(name) void test_##name()

#define ASSERT_EQ(expected, actual) \
    do { \
        if ((expected) != (actual)) { \
            std::cerr << "FAILED: " << #expected << " != " << #actual \
                      << " at " << __FILE__ << ":" << __LINE__ << std::endl; \
            std::abort(); \
        } \
    } while(0)

#define ASSERT_TRUE(cond) \
    do { \
        if (!(cond)) { \
            std::cerr << "FAILED: " << #cond << " is false at " << __FILE__ << ":" << __LINE__ << std::endl; \
            std::abort(); \
        } \
    } while(0)

#define ASSERT_FALSE(cond) ASSERT_TRUE(!(cond))

#define ASSERT_NEAR(expected, actual, tolerance) \
    do { \
        if (std::abs((expected) - (actual)) > (tolerance)) { \
            std::cerr << "FAILED: |" << #expected << " - " << #actual << "| > " << tolerance \
                      << " at " << __FILE__ << ":" << __LINE__ << std::endl; \
            std::abort(); \
        } \
    } while(0)

#define RUN_TEST(name) \
    do { \
        std::cout << "Running test_" << #name << "..." << std::endl; \
        test_##name(); \
        std::cout << "✓ test_" << #name << " passed" << std::endl; \
    } while(0)

// ============================================================================
// 算术运算符测试
// ============================================================================

TEST(int_addition) {
    Int a = dart_int(10);
    Int b = dart_int(20);
    Int c = a + b;
    ASSERT_EQ(30, c.toInt());
    
    Int d = dart_int(-5);
    Int e = a + d;
    ASSERT_EQ(5, e.toInt());
}

TEST(int_subtraction) {
    Int a = dart_int(20);
    Int b = dart_int(8);
    Int c = a - b;
    ASSERT_EQ(12, c.toInt());
    
    Int d = dart_int(5);
    Int e = dart_int(10);
    Int f = d - e;
    ASSERT_EQ(-5, f.toInt());
}

TEST(int_multiplication) {
    Int a = dart_int(5);
    Int b = dart_int(6);
    Int c = a * b;
    ASSERT_EQ(30, c.toInt());
    
    Int d = dart_int(-3);
    Int e = a * d;
    ASSERT_EQ(-15, e.toInt());
}

TEST(int_division) {
    Int a = dart_int(20);
    Int b = dart_int(4);
    Int c = a / b;
    ASSERT_EQ(5, c.toInt());
    
    Int d = dart_int(17);
    Int e = dart_int(5);
    Int f = d / e;
    ASSERT_EQ(3, f.toInt());
}

TEST(int_modulo) {
    Int a = dart_int(17);
    Int b = dart_int(5);
    Int c = a % b;
    ASSERT_EQ(2, c.toInt());
    
    Int d = dart_int(20);
    Int e = dart_int(6);
    Int f = d % e;
    ASSERT_EQ(2, f.toInt());
}

TEST(int_integer_division) {
    Int a = dart_int(17);
    Int b = dart_int(5);
    Int c = a.integerDivision(b);
    ASSERT_EQ(3, c.toInt());
    
    Int d = dart_int(-17);
    Int e = dart_int(5);
    Int f = d.integerDivision(e);
    ASSERT_EQ(-3, f.toInt());
}

TEST(double_arithmetic) {
    Double a = dart_double(10.5);
    Double b = dart_double(2.5);
    
    // 加法
    Double sum = a + b;
    ASSERT_NEAR(13.0, sum.toDouble(), 0.001);
    
    // 减法
    Double diff = a - b;
    ASSERT_NEAR(8.0, diff.toDouble(), 0.001);
    
    // 乘法
    Double prod = a * b;
    ASSERT_NEAR(26.25, prod.toDouble(), 0.001);
    
    // 除法
    Double quot = a / b;
    ASSERT_NEAR(4.2, quot.toDouble(), 0.001);
}

TEST(mixed_int_double_arithmetic) {
    Int a = dart_int(10);
    Double b = dart_double(2.5);
    
    // Int + Double
    Double sum = a + b;
    ASSERT_NEAR(12.5, sum.toDouble(), 0.001);
    
    // Int * Double
    Double prod = a * b;
    ASSERT_NEAR(25.0, prod.toDouble(), 0.001);
}

// ============================================================================
// 复合赋值运算符测试
// ============================================================================

TEST(int_compound_add) {
    Int a = dart_int(10);
    Int b = dart_int(5);
    a += b;
    ASSERT_EQ(15, a.toInt());
}

TEST(int_compound_subtract) {
    Int a = dart_int(10);
    Int b = dart_int(3);
    a -= b;
    ASSERT_EQ(7, a.toInt());
}

TEST(int_compound_multiply) {
    Int a = dart_int(10);
    Int b = dart_int(3);
    a *= b;
    ASSERT_EQ(30, a.toInt());
}

TEST(int_compound_divide) {
    Int a = dart_int(20);
    Int b = dart_int(4);
    a /= b;
    ASSERT_EQ(5, a.toInt());
}

TEST(int_compound_modulo) {
    Int a = dart_int(17);
    Int b = dart_int(5);
    a %= b;
    ASSERT_EQ(2, a.toInt());
}

TEST(double_compound_assignment) {
    Double a = dart_double(10.0);
    Double b = dart_double(2.5);
    
    Double x = a;
    x += b;
    ASSERT_NEAR(12.5, x.toDouble(), 0.001);
    
    x = a;
    x -= b;
    ASSERT_NEAR(7.5, x.toDouble(), 0.001);
    
    x = a;
    x *= b;
    ASSERT_NEAR(25.0, x.toDouble(), 0.001);
    
    x = a;
    x /= b;
    ASSERT_NEAR(4.0, x.toDouble(), 0.001);
}

// ============================================================================
// 自增自减运算符测试
// ============================================================================

TEST(int_prefix_increment) {
    Int a = dart_int(5);
    Int b = ++a;
    ASSERT_EQ(6, a.toInt());
    ASSERT_EQ(6, b.toInt());
}

TEST(int_postfix_increment) {
    Int a = dart_int(5);
    Int b = a++;
    ASSERT_EQ(6, a.toInt());
    ASSERT_EQ(5, b.toInt());
}

TEST(int_prefix_decrement) {
    Int a = dart_int(5);
    Int b = --a;
    ASSERT_EQ(4, a.toInt());
    ASSERT_EQ(4, b.toInt());
}

TEST(int_postfix_decrement) {
    Int a = dart_int(5);
    Int b = a--;
    ASSERT_EQ(4, a.toInt());
    ASSERT_EQ(5, b.toInt());
}

TEST(double_increment_decrement) {
    Double a = dart_double(5.5);
    
    // 前置自增
    Double b = ++a;
    ASSERT_NEAR(6.5, a.toDouble(), 0.001);
    ASSERT_NEAR(6.5, b.toDouble(), 0.001);
    
    // 后置自增
    Double c = a++;
    ASSERT_NEAR(7.5, a.toDouble(), 0.001);
    ASSERT_NEAR(6.5, c.toDouble(), 0.001);
    
    // 前置自减
    Double d = --a;
    ASSERT_NEAR(6.5, a.toDouble(), 0.001);
    ASSERT_NEAR(6.5, d.toDouble(), 0.001);
    
    // 后置自减
    Double e = a--;
    ASSERT_NEAR(5.5, a.toDouble(), 0.001);
    ASSERT_NEAR(6.5, e.toDouble(), 0.001);
}

// ============================================================================
// 比较运算符测试
// ============================================================================

TEST(int_equality) {
    Int a = dart_int(10);
    Int b = dart_int(10);
    Int c = dart_int(20);
    
    ASSERT_TRUE(a == b);
    ASSERT_FALSE(a == c);
}

TEST(int_inequality) {
    Int a = dart_int(10);
    Int b = dart_int(20);
    Int c = dart_int(10);
    
    ASSERT_TRUE(a != b);
    ASSERT_FALSE(a != c);
}

TEST(int_less_than) {
    Int a = dart_int(10);
    Int b = dart_int(20);
    Int c = dart_int(10);
    
    ASSERT_TRUE(a < b);
    ASSERT_FALSE(b < a);
    ASSERT_FALSE(a < c);
}

TEST(int_less_equal) {
    Int a = dart_int(10);
    Int b = dart_int(20);
    Int c = dart_int(10);
    
    ASSERT_TRUE(a <= b);
    ASSERT_TRUE(a <= c);
    ASSERT_FALSE(b <= a);
}

TEST(int_greater_than) {
    Int a = dart_int(20);
    Int b = dart_int(10);
    Int c = dart_int(20);
    
    ASSERT_TRUE(a > b);
    ASSERT_FALSE(b > a);
    ASSERT_FALSE(a > c);
}

TEST(int_greater_equal) {
    Int a = dart_int(20);
    Int b = dart_int(10);
    Int c = dart_int(20);
    
    ASSERT_TRUE(a >= b);
    ASSERT_TRUE(a >= c);
    ASSERT_FALSE(b >= a);
}

TEST(double_comparison) {
    Double a = dart_double(3.14);
    Double b = dart_double(2.71);
    Double c = dart_double(3.14);
    
    ASSERT_TRUE(a == c);
    ASSERT_FALSE(a == b);
    ASSERT_TRUE(a != b);
    ASSERT_TRUE(b < a);
    ASSERT_TRUE(a > b);
    ASSERT_TRUE(a <= c);
    ASSERT_TRUE(a >= c);
}

TEST(string_comparison) {
    String s1 = dart_string("abc");
    String s2 = dart_string("def");
    String s3 = dart_string("abc");
    
    ASSERT_TRUE(s1 == s3);
    ASSERT_FALSE(s1 == s2);
    ASSERT_TRUE(s1 != s2);
    ASSERT_FALSE(s1 != s3);
}

// ============================================================================
// 逻辑运算符测试
// ============================================================================

TEST(bool_not) {
    Bool t = dart_bool(true);
    Bool f = dart_bool(false);
    
    Bool not_t = !t;
    Bool not_f = !f;
    
    ASSERT_FALSE(not_t);
    ASSERT_TRUE(not_f);
}

TEST(bool_and) {
    Bool t = dart_bool(true);
    Bool f = dart_bool(false);
    
    ASSERT_TRUE(t && t);
    ASSERT_FALSE(t && f);
    ASSERT_FALSE(f && t);
    ASSERT_FALSE(f && f);
}

TEST(bool_or) {
    Bool t = dart_bool(true);
    Bool f = dart_bool(false);
    
    ASSERT_TRUE(t || t);
    ASSERT_TRUE(t || f);
    ASSERT_TRUE(f || t);
    ASSERT_FALSE(f || f);
}

// ============================================================================
// 字符串运算符测试
// ============================================================================

TEST(string_concatenation) {
    String s1 = dart_string("Hello");
    String s2 = dart_string(" ");
    String s3 = dart_string("World");
    
    String result = s1 + s2 + s3;
    ASSERT_TRUE(result == dart_string("Hello World"));
}

TEST(string_concat_with_numbers) {
    String s = dart_string("Number: ");
    Int num = dart_int(42);
    
    String result = s + num.toString();
    ASSERT_TRUE(result == dart_string("Number: 42"));
}

// ============================================================================
// 三元运算符测试（通过Bool的隐式转换）
// ============================================================================

TEST(ternary_operator) {
    Bool cond_true = dart_bool(true);
    Bool cond_false = dart_bool(false);
    
    Int a = dart_int(10);
    Int b = dart_int(20);
    
    // Bool 自动转换为 bool
    Int result1 = cond_true ? a : b;
    ASSERT_EQ(10, result1.toInt());
    
    Int result2 = cond_false ? a : b;
    ASSERT_EQ(20, result2.toInt());
}

// ============================================================================
// 链式运算测试
// ============================================================================

TEST(chained_arithmetic) {
    Int a = dart_int(2);
    Int b = dart_int(3);
    Int c = dart_int(4);
    
    // 链式加法
    Int result1 = a + b + c;
    ASSERT_EQ(9, result1.toInt());
    
    // 链式乘法
    Int result2 = a * b * c;
    ASSERT_EQ(24, result2.toInt());
    
    // 混合运算
    Int result3 = (a + b) * c;
    ASSERT_EQ(20, result3.toInt());
}

TEST(chained_comparison) {
    Int a = dart_int(5);
    Int b = dart_int(10);
    Int c = dart_int(15);
    
    // 链式比较
    Bool result = (a < b) && (b < c);
    ASSERT_TRUE(result);
}

// ============================================================================
// 运算优先级测试
// ============================================================================

TEST(operator_precedence) {
    Int a = dart_int(2);
    Int b = dart_int(3);
    Int c = dart_int(4);
    
    // 乘法优先于加法
    Int result1 = a + b * c;
    ASSERT_EQ(14, result1.toInt());
    
    // 括号改变优先级
    Int result2 = (a + b) * c;
    ASSERT_EQ(20, result2.toInt());
    
    // 除法和取模
    Int d = dart_int(17);
    Int e = dart_int(5);
    Int result3 = d / e + d % e;
    ASSERT_EQ(5, result3.toInt()); // 3 + 2
}

// ============================================================================
// 主函数
// ============================================================================

int main() {
    std::cout << "====================================" << std::endl;
    std::cout << "  运算符测试 - 新规范版本" << std::endl;
    std::cout << "====================================" << std::endl;
    
    // 算术运算符
    RUN_TEST(int_addition);
    RUN_TEST(int_subtraction);
    RUN_TEST(int_multiplication);
    RUN_TEST(int_division);
    RUN_TEST(int_modulo);
    RUN_TEST(int_integer_division);
    RUN_TEST(double_arithmetic);
    RUN_TEST(mixed_int_double_arithmetic);
    
    // 复合赋值
    RUN_TEST(int_compound_add);
    RUN_TEST(int_compound_subtract);
    RUN_TEST(int_compound_multiply);
    RUN_TEST(int_compound_divide);
    RUN_TEST(int_compound_modulo);
    RUN_TEST(double_compound_assignment);
    
    // 自增自减
    RUN_TEST(int_prefix_increment);
    RUN_TEST(int_postfix_increment);
    RUN_TEST(int_prefix_decrement);
    RUN_TEST(int_postfix_decrement);
    RUN_TEST(double_increment_decrement);
    
    // 比较运算符
    RUN_TEST(int_equality);
    RUN_TEST(int_inequality);
    RUN_TEST(int_less_than);
    RUN_TEST(int_less_equal);
    RUN_TEST(int_greater_than);
    RUN_TEST(int_greater_equal);
    RUN_TEST(double_comparison);
    RUN_TEST(string_comparison);
    
    // 逻辑运算符
    RUN_TEST(bool_not);
    RUN_TEST(bool_and);
    RUN_TEST(bool_or);
    
    // 字符串运算符
    RUN_TEST(string_concatenation);
    RUN_TEST(string_concat_with_numbers);
    
    // 三元运算符
    RUN_TEST(ternary_operator);
    
    // 链式运算
    RUN_TEST(chained_arithmetic);
    RUN_TEST(chained_comparison);
    
    // 运算优先级
    RUN_TEST(operator_precedence);
    
    std::cout << "====================================" << std::endl;
    std::cout << "  所有运算符测试通过！✓" << std::endl;
    std::cout << "====================================" << std::endl;
    
    return 0;
}
