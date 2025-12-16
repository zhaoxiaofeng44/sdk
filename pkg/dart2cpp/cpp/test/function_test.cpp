// ============================================================================
// C++ Function 类型测试用例
// 测试 Function、TypedFunction、makeFunction 等函数相关功能
// ============================================================================

#include "../core/dart2cpp.h"
#include <iostream>
#include <cassert>
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

#define RUN_TEST(name) \
    do { \
        std::cout << "Running test_" << #name << "..." << std::endl; \
        test_##name(); \
        std::cout << "✓ test_" << #name << " passed" << std::endl; \
    } while(0)

// ============================================================================
// TypedFunction 基础测试
// ============================================================================

TEST(typed_function_basic_creation) {
    // 创建一个简单的加法函数
    auto add_func = [](Int a, Int b) -> Int {
        return a + b;
    };
    
    TypedFunction<Int, Int, Int> func(add_func);
    
    // 使用 apply 方法调用
    std::vector<Any> args;
    args.push_back(Any(dart_int(5)));
    args.push_back(Any(dart_int(3)));
    
    Any result = func.apply(args);
    Int result_int = Int(result);
    
    ASSERT_EQ(8, result_int.toInt());
}

TEST(typed_function_operator_call) {
    // 创建一个乘法函数
    auto multiply_func = [](Int a, Int b) -> Int {
        return a * b;
    };
    
    TypedFunction<Int, Int, Int> func(multiply_func);
    
    // 使用 operator() 直接调用
    Int result = func(dart_int(4), dart_int(7));
    
    ASSERT_EQ(28, result.toInt());
}

TEST(typed_function_single_parameter) {
    // 单参数函数：平方
    auto square_func = [](Int x) -> Int {
        return x * x;
    };
    
    TypedFunction<Int, Int> func(square_func);
    
    // 使用 apply
    std::vector<Any> args;
    args.push_back(Any(dart_int(5)));
    
    Any result = func.apply(args);
    Int result_int = Int(result);
    
    ASSERT_EQ(25, result_int.toInt());
    
    // 使用 operator()
    Int direct_result = func(dart_int(6));
    ASSERT_EQ(36, direct_result.toInt());
}

TEST(typed_function_three_parameters) {
    // 三参数函数：计算 a * b + c
    auto calc_func = [](Int a, Int b, Int c) -> Int {
        return a * b + c;
    };
    
    TypedFunction<Int, Int, Int, Int> func(calc_func);
    
    // 使用 apply
    std::vector<Any> args;
    args.push_back(Any(dart_int(3)));
    args.push_back(Any(dart_int(4)));
    args.push_back(Any(dart_int(5)));
    
    Any result = func.apply(args);
    Int result_int = Int(result);
    
    ASSERT_EQ(17, result_int.toInt());  // 3 * 4 + 5 = 17
    
    // 使用 operator()
    Int direct_result = func(dart_int(2), dart_int(5), dart_int(3));
    ASSERT_EQ(13, direct_result.toInt());  // 2 * 5 + 3 = 13
}

TEST(typed_function_no_parameters) {
    // 无参数函数：返回常量
    auto const_func = []() -> Int {
        return dart_int(42);
    };
    
    TypedFunction<Int> func(const_func);
    
    // 使用 apply
    std::vector<Any> args;  // 空参数列表
    
    Any result = func.apply(args);
    Int result_int = Int(result);
    
    ASSERT_EQ(42, result_int.toInt());
    
    // 使用 operator()
    Int direct_result = func();
    ASSERT_EQ(42, direct_result.toInt());
}

// ============================================================================
// makeFunction 测试
// ============================================================================

TEST(make_function_lambda_two_params) {
    // 使用 makeFunction 包装 lambda
    auto func = makeFunction([](Int a, Int b) -> Int {
        return a + b;
    });
    
    // 使用 apply 调用
    std::vector<Any> args;
    args.push_back(Any(dart_int(10)));
    args.push_back(Any(dart_int(20)));
    
    Any result = func->apply(args);
    Int result_int = Int(result);
    
    ASSERT_EQ(30, result_int.toInt());
}

TEST(make_function_lambda_single_param) {
    // 单参数 lambda
    auto func = makeFunction([](Int x) -> Int {
        return x * dart_int(2);
    });
    
    std::vector<Any> args;
    args.push_back(Any(dart_int(7)));
    
    Any result = func->apply(args);
    Int result_int = Int(result);
    
    ASSERT_EQ(14, result_int.toInt());
}

TEST(make_function_lambda_three_params) {
    // 三参数 lambda
    auto func = makeFunction([](Int a, Int b, Int c) -> Int {
        return (a + b) * c;
    });
    
    std::vector<Any> args;
    args.push_back(Any(dart_int(2)));
    args.push_back(Any(dart_int(3)));
    args.push_back(Any(dart_int(4)));
    
    Any result = func->apply(args);
    Int result_int = Int(result);
    
    ASSERT_EQ(20, result_int.toInt());  // (2 + 3) * 4 = 20
}

TEST(make_function_complex_calculation) {
    // 复杂计算：斐波那契数列的第 n 项（简化版）
    auto func = makeFunction([](Int n) -> Int {
        if (n <= dart_int(1)) {
            return n;
        }
        Int a = dart_int(0);
        Int b = dart_int(1);
        for (Int i = dart_int(2); i <= n; ++i) {
            Int temp = a + b;
            a = b;
            b = temp;
        }
        return b;
    });
    
    std::vector<Any> args;
    args.push_back(Any(dart_int(10)));
    
    Any result = func->apply(args);
    Int result_int = Int(result);
    
    ASSERT_EQ(55, result_int.toInt());  // 第10个斐波那契数
}

// ============================================================================
// Function 对象属性测试
// ============================================================================

TEST(function_is_not_null) {
    auto func = makeFunction([](Int x) -> Int {
        return x + dart_int(1);
    });
    
    // Function 对象不应该为 null
    ASSERT_FALSE(func->isNull());
}

TEST(function_to_string) {
    auto func = makeFunction([](Int x, Int y) -> Int {
        return x * y;
    });
    
    // toString 应该返回有意义的字符串
    String str = func->toString();
    
    // 只要不崩溃就算通过
    ASSERT_TRUE(str.get_length() > dart_int(0));
}

// ============================================================================
// 函数作为参数传递测试
// ============================================================================

TEST(function_as_parameter) {
    // 创建一个接受函数作为参数的高阶函数
    auto apply_twice = [](ObjectPtr<Function> f, Int x) -> Int {
        std::vector<Any> args1;
        args1.push_back(Any(x));
        Any result1 = f->apply(args1);
        Int intermediate = Int(result1);
        
        std::vector<Any> args2;
        args2.push_back(Any(intermediate));
        Any result2 = f->apply(args2);
        return Int(result2);
    };
    
    // 创建一个加1的函数
    auto increment = makeFunction([](Int x) -> Int {
        return x + dart_int(1);
    });
    
    // 应用两次：5 -> 6 -> 7
    Int result = apply_twice(increment, dart_int(5));
    ASSERT_EQ(7, result.toInt());
}

TEST(function_composition) {
    // 函数组合：f(g(x))
    auto double_func = makeFunction([](Int x) -> Int {
        return x * dart_int(2);
    });
    
    auto add_ten = makeFunction([](Int x) -> Int {
        return x + dart_int(10);
    });
    
    // 先加10，再乘2
    std::vector<Any> args1;
    args1.push_back(Any(dart_int(5)));
    Any intermediate = add_ten->apply(args1);
    
    std::vector<Any> args2;
    args2.push_back(intermediate);
    Any result = double_func->apply(args2);
    
    Int final_result = Int(result);
    ASSERT_EQ(30, final_result.toInt());  // (5 + 10) * 2 = 30
}

// ============================================================================
// 边界情况测试
// ============================================================================

TEST(function_with_zero_result) {
    auto func = makeFunction([](Int a, Int b) -> Int {
        return a - b;
    });
    
    std::vector<Any> args;
    args.push_back(Any(dart_int(5)));
    args.push_back(Any(dart_int(5)));
    
    Any result = func->apply(args);
    Int result_int = Int(result);
    
    ASSERT_EQ(0, result_int.toInt());
}

TEST(function_with_negative_result) {
    auto func = makeFunction([](Int a, Int b) -> Int {
        return a - b;
    });
    
    std::vector<Any> args;
    args.push_back(Any(dart_int(3)));
    args.push_back(Any(dart_int(10)));
    
    Any result = func->apply(args);
    Int result_int = Int(result);
    
    ASSERT_EQ(-7, result_int.toInt());
}

TEST(function_with_large_numbers) {
    auto func = makeFunction([](Int a, Int b) -> Int {
        return a * b;
    });
    
    std::vector<Any> args;
    args.push_back(Any(dart_int(1000)));
    args.push_back(Any(dart_int(2000)));
    
    Any result = func->apply(args);
    Int result_int = Int(result);
    
    ASSERT_EQ(2000000, result_int.toInt());
}

// ============================================================================
// 实际应用场景测试
// ============================================================================

TEST(function_map_operation) {
    // 模拟 map 操作：对列表中每个元素应用函数
    auto square = makeFunction([](Int x) -> Int {
        return x * x;
    });
    
    std::vector<Int> input = {dart_int(1), dart_int(2), dart_int(3), dart_int(4)};
    std::vector<Int> output;
    
    for (const auto& item : input) {
        std::vector<Any> args;
        args.push_back(Any(item));
        Any result = square->apply(args);
        output.push_back(Int(result));
    }
    
    ASSERT_EQ(1, output[0].toInt());
    ASSERT_EQ(4, output[1].toInt());
    ASSERT_EQ(9, output[2].toInt());
    ASSERT_EQ(16, output[3].toInt());
}

TEST(function_filter_operation) {
    // 模拟 filter 操作：判断是否为偶数
    auto is_even = makeFunction([](Int x) -> Int {
        Int remainder = x % dart_int(2);
        return (remainder == dart_int(0)) ? dart_int(1) : dart_int(0);
    });
    
    std::vector<Int> input = {dart_int(1), dart_int(2), dart_int(3), dart_int(4), dart_int(5)};
    std::vector<Int> output;
    
    for (const auto& item : input) {
        std::vector<Any> args;
        args.push_back(Any(item));
        Any result = is_even->apply(args);
        Int is_even_result = Int(result);
        
        if (is_even_result == dart_int(1)) {
            output.push_back(item);
        }
    }
    
    ASSERT_EQ(2, output.size());
    ASSERT_EQ(2, output[0].toInt());
    ASSERT_EQ(4, output[1].toInt());
}

TEST(function_reduce_operation) {
    // 模拟 reduce 操作：求和
    auto add = makeFunction([](Int a, Int b) -> Int {
        return a + b;
    });
    
    std::vector<Int> input = {dart_int(1), dart_int(2), dart_int(3), dart_int(4), dart_int(5)};
    Int accumulator = dart_int(0);
    
    for (const auto& item : input) {
        std::vector<Any> args;
        args.push_back(Any(accumulator));
        args.push_back(Any(item));
        Any result = add->apply(args);
        accumulator = Int(result);
    }
    
    ASSERT_EQ(15, accumulator.toInt());  // 1+2+3+4+5 = 15
}

// ============================================================================
// 主函数
// ============================================================================

int main() {
    std::cout << "========================================" << std::endl;
    std::cout << "Function Test Suite" << std::endl;
    std::cout << "========================================" << std::endl;
    
    // TypedFunction 基础测试
    std::cout << "\n--- TypedFunction Basic Tests ---" << std::endl;
    RUN_TEST(typed_function_basic_creation);
    RUN_TEST(typed_function_operator_call);
    RUN_TEST(typed_function_single_parameter);
    RUN_TEST(typed_function_three_parameters);
    RUN_TEST(typed_function_no_parameters);
    
    // makeFunction 测试
    std::cout << "\n--- makeFunction Tests ---" << std::endl;
    RUN_TEST(make_function_lambda_two_params);
    RUN_TEST(make_function_lambda_single_param);
    RUN_TEST(make_function_lambda_three_params);
    RUN_TEST(make_function_complex_calculation);
    
    // Function 对象属性测试
    std::cout << "\n--- Function Object Property Tests ---" << std::endl;
    RUN_TEST(function_is_not_null);
    RUN_TEST(function_to_string);
    
    // 函数作为参数传递测试
    std::cout << "\n--- Function as Parameter Tests ---" << std::endl;
    RUN_TEST(function_as_parameter);
    RUN_TEST(function_composition);
    
    // 边界情况测试
    std::cout << "\n--- Edge Case Tests ---" << std::endl;
    RUN_TEST(function_with_zero_result);
    RUN_TEST(function_with_negative_result);
    RUN_TEST(function_with_large_numbers);
    
    // 实际应用场景测试
    std::cout << "\n--- Practical Application Tests ---" << std::endl;
    RUN_TEST(function_map_operation);
    RUN_TEST(function_filter_operation);
    RUN_TEST(function_reduce_operation);
    
    std::cout << "\n========================================" << std::endl;
    std::cout << "All Function tests passed!" << std::endl;
    std::cout << "========================================" << std::endl;
    
    return 0;
}
