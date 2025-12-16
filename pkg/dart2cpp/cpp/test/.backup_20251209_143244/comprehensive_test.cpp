// ============================================================================
// C++ 综合测试用例
// 测试所有支持的 Dart 语言特性的综合功能
// ============================================================================

#include "../core/dart2cpp.h"
#include <iostream>
#include <cassert>
#include <cmath>
#include <stdexcept>

// 简单的测试框架
#define TEST(name) \
    void test_##name(); \
    void test_##name()

#define ASSERT_EQ(expected, actual) \
    do { \
        if ((expected) != (actual)) { \
            std::cerr << "ASSERTION FAILED: " << #expected << " != " << #actual \
                      << " (expected: " << (expected) << ", actual: " << (actual) << ")" \
                      << " at " << __FILE__ << ":" << __LINE__ << std::endl; \
            std::abort(); \
        } \
    } while(0)

#define ASSERT_TRUE(condition) \
    do { \
        if (!(condition)) { \
            std::cerr << "ASSERTION FAILED: " << #condition << " is false" \
                      << " at " << __FILE__ << ":" << __LINE__ << std::endl; \
            std::abort(); \
        } \
    } while(0)

#define ASSERT_FALSE(condition) \
    do { \
        if (condition) { \
            std::cerr << "ASSERTION FAILED: " << #condition << " is true" \
                      << " at " << __FILE__ << ":" << __LINE__ << std::endl; \
            std::abort(); \
        } \
    } while(0)

#define ASSERT_NEAR(expected, actual, tolerance) \
    do { \
        if (std::abs((expected) - (actual)) > (tolerance)) { \
            std::cerr << "ASSERTION FAILED: " << #expected << " != " << #actual \
                      << " (expected: " << (expected) << ", actual: " << (actual) \
                      << ", tolerance: " << (tolerance) << ")" \
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
// 基础类型综合测试
// ============================================================================

TEST(basic_types_comprehensive) {
    // 测试 Int 类型的各种操作
    Int a(42);
    Int b(-17);
    Int zero(0);
    
    ASSERT_EQ(42, a.value.int_value);
    ASSERT_EQ(-17, b.value.int_value);
    ASSERT_EQ(0, zero.value.int_value);
    
    // 测试 Double 类型
    Double pi(3.14159);
    Double negative(-2.718);
    
    ASSERT_NEAR(3.14159, pi.value.double_value, 0.00001);
    ASSERT_NEAR(-2.718, negative.value.double_value, 0.001);
    
    // 测试 Bool 类型
    Bool t(true);
    Bool f(false);
    
    ASSERT_TRUE(t.value.bool_value);
    ASSERT_FALSE(f.value.bool_value);
    
    // 测试 String 类型
    String hello("Hello");
    String world("World");
    
    ASSERT_EQ(std::string("Hello"), hello.getValue());
    ASSERT_EQ(std::string("World"), world.getValue());
}

// ============================================================================
// 算术运算综合测试
// ============================================================================

TEST(arithmetic_comprehensive) {
    Int a(20);
    Int b(6);
    
    // 基本算术运算
    Int sum = a + b;
    Int diff = a - b;
    Int prod = a * b;
    Int quot = a / b;
    Int rem = a % b;
    
    ASSERT_EQ(26, sum.value.int_value);
    ASSERT_EQ(14, diff.value.int_value);
    ASSERT_EQ(120, prod.value.int_value);
    ASSERT_EQ(3, quot.value.int_value);
    ASSERT_EQ(2, rem.value.int_value);
    
    // Double 算术运算
    Double x(10.5);
    Double y(2.5);
    
    Double d_sum = x + y;
    Double d_diff = x - y;
    Double d_prod = x * y;
    Double d_quot = x / y;
    
    ASSERT_NEAR(13.0, d_sum.value.double_value, 0.001);
    ASSERT_NEAR(8.0, d_diff.value.double_value, 0.001);
    ASSERT_NEAR(26.25, d_prod.value.double_value, 0.001);
    ASSERT_NEAR(4.2, d_quot.value.double_value, 0.001);
}

// ============================================================================
// 比较运算综合测试
// ============================================================================

TEST(comparison_comprehensive) {
    Int a(10);
    Int b(20);
    Int c(10);
    
    // 相等性测试
    Bool eq1 = (a == c);
    Bool eq2 = (a == b);
    ASSERT_TRUE(eq1.value.bool_value);
    ASSERT_FALSE(eq2.value.bool_value);
    
    // 不等性测试
    Bool ne1 = (a != b);
    Bool ne2 = (a != c);
    ASSERT_TRUE(ne1.value.bool_value);
    ASSERT_FALSE(ne2.value.bool_value);
    
    // 大小比较
    Bool lt = (a < b);
    Bool gt = (b > a);
    Bool le = (a <= c);
    Bool ge = (b >= a);
    
    ASSERT_TRUE(lt.value.bool_value);
    ASSERT_TRUE(gt.value.bool_value);
    ASSERT_TRUE(le.value.bool_value);
    ASSERT_TRUE(ge.value.bool_value);
}

// ============================================================================
// 逻辑运算综合测试
// ============================================================================

TEST(logical_comprehensive) {
    Bool t(true);
    Bool f(false);
    
    // AND 运算
    Bool and1 = t && t;
    Bool and2 = t && f;
    Bool and3 = f && f;
    
    ASSERT_TRUE(and1.value.bool_value);
    ASSERT_FALSE(and2.value.bool_value);
    ASSERT_FALSE(and3.value.bool_value);
    
    // OR 运算
    Bool or1 = t || t;
    Bool or2 = t || f;
    Bool or3 = f || f;
    
    ASSERT_TRUE(or1.value.bool_value);
    ASSERT_TRUE(or2.value.bool_value);
    ASSERT_FALSE(or3.value.bool_value);
    
    // NOT 运算
    Bool not1 = !t;
    Bool not2 = !f;
    
    ASSERT_FALSE(not1.value.bool_value);
    ASSERT_TRUE(not2.value.bool_value);
}

// ============================================================================
// 字符串操作综合测试
// ============================================================================

TEST(string_comprehensive) {
    String s1("Hello");
    String s2("World");
    String space(" ");
    
    // 字符串连接
    String greeting = s1 + space + s2;
    ASSERT_EQ(std::string("Hello World"), greeting.getValue());
    
    // 字符串长度
    Int len = greeting.get_length();
    ASSERT_EQ(11, len.value.int_value);
    
    // 字符串转换
    String upper = s1.toUpperCase();
    String lower = upper.toLowerCase();
    
    ASSERT_EQ(std::string("HELLO"), upper.getValue());
    ASSERT_EQ(std::string("hello"), lower.getValue());
    
    // 字符串包含
    Bool contains = greeting.contains(s2);
    ASSERT_TRUE(contains.value.bool_value);
    
    // 字符串 trim
    String padded("  test  ");
    String trimmed = padded.trim();
    ASSERT_EQ(std::string("test"), trimmed.getValue());
}

// ============================================================================
// List 操作综合测试
// ============================================================================

TEST(list_comprehensive) {
    // 创建 List
    auto int_list = dart_list_int();
    
    // 添加元素
    int_list->add(dart_int(10));
    int_list->add(dart_int(20));
    int_list->add(dart_int(30));
    
    ASSERT_EQ(3, int_list->size().value.int_value);
    
    // 访问元素
    Int first = int_list->get(Int(0));
    Int second = int_list->get(Int(1));
    Int third = int_list->get(Int(2));
    
    ASSERT_EQ(10, first.value.int_value);
    ASSERT_EQ(20, second.value.int_value);
    ASSERT_EQ(30, third.value.int_value);
    
    // 查找元素
    Bool contains_20 = int_list->contains(dart_int(20));
    Bool contains_40 = int_list->contains(dart_int(40));
    
    ASSERT_TRUE(contains_20.value.bool_value);
    ASSERT_FALSE(contains_40.value.bool_value);
    
    // 查找索引（在移除之前）
    Int index = int_list->indexOf(dart_int(30));
    ASSERT_EQ(2, index.value.int_value);
    
    // 移除元素（按值移除）
    int_list->removeElement(dart_int(20));
    ASSERT_EQ(2, int_list->size().value.int_value);
    
    // 验证移除后的元素
    Int first_after_remove = int_list->get(Int(0));
    Int second_after_remove = int_list->get(Int(1));
    ASSERT_EQ(10, first_after_remove.value.int_value);
    ASSERT_EQ(30, second_after_remove.value.int_value);
    
    // 验证移除后的索引变化
    Int new_index = int_list->indexOf(dart_int(30));
    ASSERT_EQ(1, new_index.value.int_value); // 30现在在索引1位置
    
    // 清空列表
    int_list->clear();
    ASSERT_EQ(0, int_list->size().value.int_value);
}

// ============================================================================
// Set 操作综合测试
// ============================================================================

TEST(set_comprehensive) {
    // 创建 Set
    auto int_set = dart_set_int();
    
    // 添加元素（包括重复）
    int_set->add(dart_int(1));
    int_set->add(dart_int(2));
    int_set->add(dart_int(1)); // 重复元素
    int_set->add(dart_int(3));
    
    // Set 应该只包含唯一元素
    ASSERT_EQ(3, int_set->size().value.int_value);
    
    // 检查包含
    Bool contains_1 = int_set->contains(dart_int(1));
    Bool contains_4 = int_set->contains(dart_int(4));
    
    ASSERT_TRUE(contains_1.value.bool_value);
    ASSERT_FALSE(contains_4.value.bool_value);
    
    // 移除元素
    int_set->remove(dart_int(2));
    ASSERT_EQ(2, int_set->size().value.int_value);
    
    Bool still_contains_2 = int_set->contains(dart_int(2));
    ASSERT_FALSE(still_contains_2.value.bool_value);
}

// ============================================================================
// Map 操作综合测试
// ============================================================================

TEST(map_comprehensive) {
    // 创建 Map
    auto string_int_map = dart_map_string_int();
    
    // 添加键值对
    string_int_map->put(String("one"), dart_int(1));
    string_int_map->put(String("two"), dart_int(2));
    string_int_map->put(String("three"), dart_int(3));
    
    ASSERT_EQ(3, string_int_map->size().value.int_value);
    
    // 获取值
    Int val_one = string_int_map->get(String("one"));
    Int val_two = string_int_map->get(String("two"));
    
    ASSERT_EQ(1, val_one.value.int_value);
    ASSERT_EQ(2, val_two.value.int_value);
    
    // 检查键是否存在
    Bool has_one = string_int_map->containsKey(String("one"));
    Bool has_four = string_int_map->containsKey(String("four"));
    
    ASSERT_TRUE(has_one.value.bool_value);
    ASSERT_FALSE(has_four.value.bool_value);
    
    // 更新值
    string_int_map->put(String("one"), dart_int(10));
    Int updated_val = string_int_map->get(String("one"));
    ASSERT_EQ(10, updated_val.value.int_value);
    
    // 移除键值对
    string_int_map->remove(String("two"));
    ASSERT_EQ(2, string_int_map->size().value.int_value);
    
    Bool still_has_two = string_int_map->containsKey(String("two"));
    ASSERT_FALSE(still_has_two.value.bool_value);
}

// ============================================================================
// 扩展操作符综合测试
// ============================================================================

TEST(extended_operators_comprehensive) {
    // 复合赋值操作符
    Int a(10);
    Int b(3);
    
    Int c = a;
    c += b;
    ASSERT_EQ(13, c.value.int_value);
    
    c = a;
    c -= b;
    ASSERT_EQ(7, c.value.int_value);
    
    c = a;
    c *= b;
    ASSERT_EQ(30, c.value.int_value);
    
    c = a;
    c /= b;
    ASSERT_EQ(3, c.value.int_value);
    
    c = a;
    c %= b;
    ASSERT_EQ(1, c.value.int_value);
    
    // 自增自减操作符
    Int d(5);
    
    // 前置自增
    ++d;
    ASSERT_EQ(6, d.value.int_value);
    
    // 后置自增
    Int old_d = d++;
    ASSERT_EQ(6, old_d.value.int_value);
    ASSERT_EQ(7, d.value.int_value);
    
    // 前置自减
    --d;
    ASSERT_EQ(6, d.value.int_value);
    
    // 后置自减
    Int old_d2 = d--;
    ASSERT_EQ(6, old_d2.value.int_value);
    ASSERT_EQ(5, d.value.int_value);
}

// ============================================================================
// 类型转换综合测试
// ============================================================================

TEST(type_conversion_comprehensive) {
    // Int 到 Double
    Int int_val(42);
    Double double_from_int(int_val.value.int_value);
    ASSERT_NEAR(42.0, double_from_int.value.double_value, 0.001);
    
    // Double 到 Int
    Double double_val(3.14);
    Int int_from_double(static_cast<int>(double_val.value.double_value));
    ASSERT_EQ(3, int_from_double.value.int_value);
    
    // 数值到字符串
    String str_from_int = dart_string(std::to_string(int_val.value.int_value));
    ASSERT_EQ(std::string("42"), str_from_int.getValue());
    
    String str_from_double = dart_string(std::to_string(double_val.value.double_value));
    std::string result = str_from_double.getValue();
    ASSERT_TRUE(result.find("3.14") != std::string::npos);
}

// ============================================================================
// 错误处理综合测试
// ============================================================================

TEST(error_handling_comprehensive) {
    // 测试除零错误处理
    try {
        Int a(10);
        Int b(0);
        Int result = a / b;
        
        // 如果没有抛出异常，输出结果
        std::cout << "Division by zero result: " << result.value.int_value << std::endl;
    } catch (const std::exception& e) {
        std::cout << "Caught division by zero exception: " << e.what() << std::endl;
    }
    
    // 测试空指针访问（如果有相关机制）
    try {
        // 这里可以添加空指针测试
        ASSERT_TRUE(true); // 占位符
    } catch (const std::exception& e) {
        std::cout << "Caught null pointer exception: " << e.what() << std::endl;
    }
}

// ============================================================================
// 性能和内存管理综合测试
// ============================================================================

TEST(performance_memory_comprehensive) {
    // 大量对象创建和销毁测试
    {
        auto large_list = dart_list_int();
        
        // 添加大量元素
        for (int i = 0; i < 1000; i++) {
            large_list->add(dart_int(i));
        }
        
        ASSERT_EQ(1000, large_list->size().value.int_value);
        
        // 验证一些元素
        ASSERT_EQ(0, large_list->get(Int(0)).value.int_value);
        ASSERT_EQ(500, large_list->get(Int(500)).value.int_value);
        ASSERT_EQ(999, large_list->get(Int(999)).value.int_value);
        
        // 清空列表
        large_list->clear();
        ASSERT_EQ(0, large_list->size().value.int_value);
    }
    
    // 嵌套集合测试
    {
        auto map_of_lists = dart_map_string_int();
        
        // 创建一些数据
        map_of_lists->put(String("count1"), dart_int(10));
        map_of_lists->put(String("count2"), dart_int(20));
        map_of_lists->put(String("count3"), dart_int(30));
        
        ASSERT_EQ(3, map_of_lists->size().value.int_value);
        
        Int total(0);
        // 这里可以添加迭代器支持后的遍历测试
        total += map_of_lists->get(String("count1"));
        total += map_of_lists->get(String("count2"));
        total += map_of_lists->get(String("count3"));
        
        ASSERT_EQ(60, total.value.int_value);
    }
}

// ============================================================================
// 主函数
// ============================================================================

int main() {
    std::cout << "=== Dart2CPP 综合测试套件 ===" << std::endl;
    std::cout << std::endl;
    
    try {
        RUN_TEST(basic_types_comprehensive);
        RUN_TEST(arithmetic_comprehensive);
        RUN_TEST(comparison_comprehensive);
        RUN_TEST(logical_comprehensive);
        RUN_TEST(string_comprehensive);
        RUN_TEST(list_comprehensive);
        RUN_TEST(set_comprehensive);
        RUN_TEST(map_comprehensive);
        RUN_TEST(extended_operators_comprehensive);
        RUN_TEST(type_conversion_comprehensive);
        RUN_TEST(error_handling_comprehensive);
        RUN_TEST(performance_memory_comprehensive);
        
        std::cout << std::endl;
        std::cout << "=== 所有综合测试通过! ===" << std::endl;
        
    } catch (const std::exception& e) {
        std::cerr << "测试失败: " << e.what() << std::endl;
        return 1;
    } catch (...) {
        std::cerr << "测试失败: 未知异常" << std::endl;
        return 1;
    }
    
    return 0;
}
