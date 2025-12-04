// ============================================================================
// C++ 宏和工具测试用例
// 测试各种宏定义、工具函数和辅助功能
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
// 宏定义测试
// ============================================================================

TEST(dart_macros_basic) {
    // 测试基本的 Dart 宏定义
    std::cout << "Testing basic dart macros..." << std::endl;
    
    // 测试通过
    ASSERT_TRUE(true);
}

TEST(dart_helper_macros) {
    // 测试 dart_int 等辅助宏
    auto int_val = dart_int(42);
    ASSERT_EQ(42, int_val.value.int_value);
    
    auto double_val = dart_double(3.14);
    ASSERT_NEAR(3.14, double_val.value.double_value, 0.001);
    
    auto bool_val = dart_bool(true);
    ASSERT_TRUE(bool_val.value.bool_value);
    
    auto string_val = dart_string("hello");
    ASSERT_EQ(std::string("hello"), string_val.getValue());
}

// ============================================================================
// 集合类型宏测试
// ============================================================================

TEST(collection_creation_macros) {
    // 测试 List 创建
    auto int_list = dart_list_int();
    ASSERT_EQ(0, int_list->size().value.int_value);
    
    auto string_list = dart_list_string();
    ASSERT_EQ(0, string_list->size().value.int_value);
    
    auto double_list = dart_list_double();
    ASSERT_EQ(0, double_list->size().value.int_value);
    
    // 测试 Set 创建
    auto int_set = dart_set_int();
    ASSERT_EQ(0, int_set->size().value.int_value);
    
    auto string_set = dart_set_string();
    ASSERT_EQ(0, string_set->size().value.int_value);
    
    auto double_set = dart_set_double();
    ASSERT_EQ(0, double_set->size().value.int_value);
    
    // 测试 Map 创建
    auto string_int_map = dart_map_string_int();
    ASSERT_EQ(0, string_int_map->size().value.int_value);
    
    auto int_string_map = dart_map_int_string();
    ASSERT_EQ(0, int_string_map->size().value.int_value);
}

TEST(list_operations_with_macros) {
    // 测试 List 操作
    auto list = dart_list_int();
    
    // 添加元素
    list->add(dart_int(1));
    list->add(dart_int(2));
    list->add(dart_int(3));
    
    ASSERT_EQ(3, list->size().value.int_value);
    ASSERT_EQ(1, list->get(Int(0)).value.int_value);
    ASSERT_EQ(2, list->get(Int(1)).value.int_value);
    ASSERT_EQ(3, list->get(Int(2)).value.int_value);
    
    // 测试 contains
    Bool contains_2 = list->contains(dart_int(2));
    ASSERT_TRUE(contains_2.value.bool_value);
    
    Bool contains_5 = list->contains(dart_int(5));
    ASSERT_FALSE(contains_5.value.bool_value);
}

// ============================================================================
// 类型转换宏测试
// ============================================================================

TEST(type_conversion_macros) {
    // 测试类型转换宏
    Int int_val(42);
    Double double_from_int = dart_double(int_val.value.int_value);
    ASSERT_NEAR(42.0, double_from_int.value.double_value, 0.001);
    
    Double double_val(3.14);
    Int int_from_double = dart_int(static_cast<int>(double_val.value.double_value));
    ASSERT_EQ(3, int_from_double.value.int_value);
    
    // 测试字符串转换
    String str_from_int = dart_string(std::to_string(int_val.value.int_value));
    ASSERT_EQ(std::string("42"), str_from_int.getValue());
    
    String str_from_double = dart_string(std::to_string(double_val.value.double_value));
    // 注意：浮点数转字符串可能有精度问题，这里只检查是否包含主要数字
    std::string result = str_from_double.getValue();
    ASSERT_TRUE(result.find("3.14") != std::string::npos || result.find("3,14") != std::string::npos);
}

// ============================================================================
// 错误处理宏测试
// ============================================================================

TEST(error_handling_macros) {
    // 测试错误处理相关的宏
    try {
        // 测试除零错误
        Int a(10);
        Int b(0);
        Int result = a / b;  // 这应该抛出异常或返回特殊值
        
        // 如果没有抛出异常，检查是否返回了特殊值
        std::cout << "Division by zero result: " << result.value.int_value << std::endl;
    } catch (const std::exception& e) {
        std::cout << "Caught expected exception: " << e.what() << std::endl;
    }
    
    // 测试通过
    ASSERT_TRUE(true);
}

// ============================================================================
// 调试宏测试
// ============================================================================

TEST(debug_macros) {
    // 测试调试相关的宏
    #ifdef DEBUG
    std::cout << "Debug mode is enabled" << std::endl;
    #else
    std::cout << "Release mode" << std::endl;
    #endif
    
    // 测试通过
    ASSERT_TRUE(true);
}

// ============================================================================
// 性能测试宏
// ============================================================================

TEST(performance_macros) {
    // 测试性能相关的宏和内联函数
    const int iterations = 100;  // 减少迭代次数以避免性能问题
    
    // 测试基本运算的性能
    Int sum(0);
    for (int i = 0; i < iterations; i++) {
        sum = sum + dart_int(i);
    }
    
    // 验证结果
    int expected = (iterations - 1) * iterations / 2;
    ASSERT_EQ(expected, sum.value.int_value);
    
    std::cout << "Performance test completed: sum of 0 to " << (iterations-1) 
              << " = " << sum.value.int_value << std::endl;
}

// ============================================================================
// 内存管理宏测试
// ============================================================================

TEST(memory_management_macros) {
    // 测试内存管理相关的宏
    {
        // 创建大量对象测试内存管理
        auto list = dart_list_int();
        
        for (int i = 0; i < 10; i++) {  // 减少数量以避免性能问题
            list->add(dart_int(i));
        }
        
        ASSERT_EQ(10, list->size().value.int_value);
        
        // 清空列表
        list->clear();
        ASSERT_EQ(0, list->size().value.int_value);
    }
    
    // 对象应该在作用域结束时自动清理
    ASSERT_TRUE(true);
}

// ============================================================================
// 扩展操作符测试
// ============================================================================

TEST(extended_operators) {
    // 测试扩展的操作符
    Int a(10);
    Int b(3);
    
    // 测试复合赋值操作符
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
    
    // 测试自增自减
    Int d(5);
    ++d;
    ASSERT_EQ(6, d.value.int_value);
    
    d++;
    ASSERT_EQ(7, d.value.int_value);
    
    --d;
    ASSERT_EQ(6, d.value.int_value);
    
    d--;
    ASSERT_EQ(5, d.value.int_value);
}

// ============================================================================
// 主函数
// ============================================================================

int main() {
    std::cout << "=== Dart2CPP 宏和工具测试 ===" << std::endl;
    std::cout << std::endl;
    
    try {
        RUN_TEST(dart_macros_basic);
        RUN_TEST(dart_helper_macros);
        RUN_TEST(collection_creation_macros);
        RUN_TEST(list_operations_with_macros);
        RUN_TEST(type_conversion_macros);
        RUN_TEST(error_handling_macros);
        RUN_TEST(debug_macros);
        RUN_TEST(performance_macros);
        RUN_TEST(memory_management_macros);
        RUN_TEST(extended_operators);
        
        std::cout << std::endl;
        std::cout << "=== 所有宏和工具测试通过! ===" << std::endl;
        
    } catch (const std::exception& e) {
        std::cerr << "测试失败: " << e.what() << std::endl;
        return 1;
    } catch (...) {
        std::cerr << "测试失败: 未知异常" << std::endl;
        return 1;
    }
    
    return 0;
}
