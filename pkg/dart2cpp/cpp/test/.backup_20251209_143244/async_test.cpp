// ============================================================================
// C++ 异步编程测试用例
// 测试 Future、Duration、async/await、Completer 等异步编程特性
// 注意：使用联合体 ValueUnion 访问 .value.object_ptr 等
// Future 等异步类型都继承自 Object 类，应该使用 ObjectPtr 包装
// ============================================================================

#include "../core/dart2cpp.h"
#include <iostream>
#include <cassert>
#include <memory>
#include <thread>
#include <chrono>

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
// Duration 类型测试
// ============================================================================

TEST(duration_basic_operations) {
    // 创建不同时间单位的 Duration
    ObjectPtr<Duration> milliseconds = Duration::milliseconds(500);
    ObjectPtr<Duration> seconds = Duration::seconds(2);
    ObjectPtr<Duration> minutes = Duration::minutes(1);
    
    // 验证 Duration 对象的type_id
    ASSERT_EQ(13, milliseconds->type_id);  // Duration 类型ID为13
    
    // 转换为毫秒进行比较
    Int ms_in_ms = milliseconds->inMilliseconds();
    ASSERT_EQ(500, ms_in_ms.value.int_value);
    
    Int sec_in_ms = seconds->inMilliseconds();
    ASSERT_EQ(2000, sec_in_ms.value.int_value);
    
    Int min_in_ms = minutes->inMilliseconds();
    ASSERT_EQ(60000, min_in_ms.value.int_value);
    
    // 转换为秒
    Int sec_in_sec = seconds->inSeconds();
    ASSERT_EQ(2, sec_in_sec.value.int_value);
    
    Int min_in_sec = minutes->inSeconds();
    ASSERT_EQ(60, min_in_sec.value.int_value);
}

TEST(duration_arithmetic_operations) {
    ObjectPtr<Duration> d1 = Duration::seconds(3);
    ObjectPtr<Duration> d2 = Duration::milliseconds(500);
    
    // Duration 加法
    Duration sum = *d1 + *d2;
    Int sum_ms = sum.inMilliseconds();
    ASSERT_EQ(3500, sum_ms.value.int_value);
    
    // Duration 减法
    Duration diff = *d1 - *d2;
    Int diff_ms = diff.inMilliseconds();
    ASSERT_EQ(2500, diff_ms.value.int_value);
    
    // Duration 乘法
    Duration multiplied = *d1 * Int(2);
    Int mult_ms = multiplied.inMilliseconds();
    ASSERT_EQ(6000, mult_ms.value.int_value);
    
    // Duration 比较
    Bool is_greater = (*d1 > *d2);
    ASSERT_TRUE(is_greater.value.bool_value);
    
    Bool is_equal = (*d1 == *Duration::seconds(3));
    ASSERT_TRUE(is_equal.value.bool_value);
}

// ============================================================================
// Future 基础测试
// ============================================================================

TEST(future_value_creation) {
    // 测试立即完成的 Future
    ObjectPtr<Future<Int>> futureInt = Future<Int>::value(Int(42));
    
    // 验证 Future 对象不为null
    ASSERT_TRUE(futureInt.get() != nullptr);
    
    Int result = futureInt->wait();
    ASSERT_EQ(42, result.value.int_value);
    
    Bool is_completed = futureInt->isCompleted();
    ASSERT_TRUE(is_completed.value.bool_value);
}

TEST(future_delayed_int) {
    // 测试延迟 Future
    auto start = std::chrono::steady_clock::now();
    
    ObjectPtr<Future<Int>> future = Future<Int>::delayed(
        Duration::milliseconds(100),
        []() { return Int(100); }
    );
    
    Int result = future->wait();
    
    auto end = std::chrono::steady_clock::now();
    auto elapsed = std::chrono::duration_cast<std::chrono::milliseconds>(end - start).count();
    
    ASSERT_EQ(100, result.value.int_value);
    ASSERT_TRUE(elapsed >= 90); // 允许一些误差
}

TEST(future_delayed_string) {
    ObjectPtr<Future<String>> future = Future<String>::delayed(
        Duration::milliseconds(50),
        []() { return String("Hello Async"); }
    );
    
    String result = future->wait();
    ASSERT_EQ("Hello Async", result.getValue());
}

TEST(future_delayed_double) {
    ObjectPtr<Future<Double>> future = Future<Double>::delayed(
        Duration::milliseconds(50),
        []() { return Double(3.14); }
    );
    
    Double result = future->wait();
    ASSERT_NEAR(3.14, result.value.double_value, 0.001);
}

// ============================================================================
// Future 链式操作测试
// ============================================================================

// 模拟异步计算
ObjectPtr<Future<Int>> calculateSum(Int a, Int b) {
    return Future<Int>::delayed(
        Duration::milliseconds(50),
        [a, b]() {
            return Int(a.value.int_value + b.value.int_value);
        }
    );
}

// 模拟异步验证
ObjectPtr<Future<Bool>> validateData(String data) {
    return Future<Bool>::delayed(
        Duration::milliseconds(30),
        [data]() {
            return Bool(data.getValue().length() > 0);
        }
    );
}

// 模拟异步数据获取
ObjectPtr<Future<String>> fetchUserData(Int userId) {
    return Future<String>::delayed(
        Duration::milliseconds(80),
        [userId]() {
            return String("User_") + String(std::to_string(userId.value.int_value));
        }
    );
}

TEST(future_chained_operations) {
    // 测试链式异步操作
    ObjectPtr<Future<Int>> sumFuture = calculateSum(Int(10), Int(20));
    Int sum = sumFuture->wait();
    
    ASSERT_EQ(30, sum.value.int_value);
    
    // 使用结果进行下一步操作
    ObjectPtr<Future<Int>> doubleFuture = calculateSum(sum, sum);
    Int doubled = doubleFuture->wait();
    
    ASSERT_EQ(60, doubled.value.int_value);
}

TEST(future_then_operations) {
    // 测试 Future.then() 链式调用
    ObjectPtr<Future<Int>> initial = Future<Int>::value(Int(5));
    
    // 链式 then 操作
    ObjectPtr<Future<Int>> doubled = initial->then<Int>([](Int value) {
        return Int(value.value.int_value * 2);
    });
    
    ObjectPtr<Future<String>> stringified = doubled->then<String>([](Int value) {
        return String("Result: ") + String(std::to_string(value.value.int_value));
    });
    
    String final_result = stringified->wait();
    ASSERT_EQ("Result: 10", final_result.getValue());
}

TEST(future_catchError_operations) {
    // 测试错误处理
    ObjectPtr<Future<Int>> errorFuture = Future<Int>::delayed(
        Duration::milliseconds(10),
        []() -> Int {
            throw std::runtime_error("Test error");
            return Int(0);  // 不会执行到这里
        }
    );
    
    ObjectPtr<Future<Int>> recoveredFuture = errorFuture->catchError([](const std::exception& e) {
        return Int(-1);  // 错误恢复值
    });
    
    Int result = recoveredFuture->wait();
    ASSERT_EQ(-1, result.value.int_value);
}

// ============================================================================
// Completer 测试
// ============================================================================

TEST(completer_basic_operations) {
    ObjectPtr<Completer<String>> completer = Completer<String>::create();
    ObjectPtr<Future<String>> future = completer->getFuture();
    
    // 初始状态应该未完成
    Bool is_completed = future->isCompleted();
    ASSERT_FALSE(is_completed.value.bool_value);
    
    // 在另一个线程中完成 Completer
    std::thread([completer]() {
        std::this_thread::sleep_for(std::chrono::milliseconds(100));
        completer->complete(String("Completed!"));
    }).detach();
    
    // 等待结果
    String result = future->wait();
    ASSERT_EQ("Completed!", result.getValue());
    
    Bool is_completed_after = future->isCompleted();
    ASSERT_TRUE(is_completed_after.value.bool_value);
}

TEST(completer_error_handling) {
    ObjectPtr<Completer<Int>> completer = Completer<Int>::create();
    ObjectPtr<Future<Int>> future = completer->getFuture();
    
    // 在另一个线程中完成 Completer 并抛出错误
    std::thread([completer]() {
        std::this_thread::sleep_for(std::chrono::milliseconds(50));
        completer->completeError(std::runtime_error("Completer error"));
    }).detach();
    
    // 等待线程完成
    std::this_thread::sleep_for(std::chrono::milliseconds(100));
    
    // 测试错误处理
    bool caught_error = false;
    try {
        Int result = future->wait();
    } catch (const std::runtime_error& e) {
        caught_error = true;
        ASSERT_EQ("Completer error", std::string(e.what()));
    } catch (const std::exception& e) {
        caught_error = true;
        // 也可以捕获到其他类型的异常
    } catch (...) {
        caught_error = true;
    }
    
    ASSERT_TRUE(caught_error);
}

// ============================================================================
// 并发异步操作测试
// ============================================================================

TEST(multiple_futures_parallel) {
    // 创建多个并发的 Future
    auto start = std::chrono::steady_clock::now();
    
    ObjectPtr<Future<Int>> f1 = Future<Int>::delayed(Duration::milliseconds(100), []() { return Int(1); });
    ObjectPtr<Future<Int>> f2 = Future<Int>::delayed(Duration::milliseconds(100), []() { return Int(2); });
    ObjectPtr<Future<Int>> f3 = Future<Int>::delayed(Duration::milliseconds(100), []() { return Int(3); });
    
    // 等待所有结果
    Int r1 = f1->wait();
    Int r2 = f2->wait();
    Int r3 = f3->wait();
    
    auto end = std::chrono::steady_clock::now();
    auto elapsed = std::chrono::duration_cast<std::chrono::milliseconds>(end - start).count();
    
    ASSERT_EQ(1, r1.value.int_value);
    ASSERT_EQ(2, r2.value.int_value);
    ASSERT_EQ(3, r3.value.int_value);
    
    // 由于是并发执行，总时间应该接近单个任务时间
    std::cout << "  Parallel execution time: " << elapsed << "ms" << std::endl;
}

TEST(future_wait_with_timeout) {
    // 测试超时等待
    ObjectPtr<Future<String>> slowFuture = Future<String>::delayed(
        Duration::milliseconds(200),
        []() { return String("Slow result"); }
    );
    
    // 尝试短时间等待（应该超时）
    Bool timeout_result = slowFuture->waitFor(Duration::milliseconds(50));
    ASSERT_FALSE(timeout_result.value.bool_value);
    
    // 足够长时间等待（应该成功）
    Bool success_result = slowFuture->waitFor(Duration::milliseconds(300));
    ASSERT_TRUE(success_result.value.bool_value);
    
    String result = slowFuture->wait();
    ASSERT_EQ("Slow result", result.getValue());
}

// ============================================================================
// Future.wait() 静态方法测试
// ============================================================================

TEST(future_wait_multiple) {
    // 创建多个 Future
    ObjectPtr<List<ObjectPtr<Future<Int>>>> futures = List<ObjectPtr<Future<Int>>>::create();
    
    futures->add(Future<Int>::delayed(Duration::milliseconds(50), []() { return Int(10); }));
    futures->add(Future<Int>::delayed(Duration::milliseconds(80), []() { return Int(20); }));
    futures->add(Future<Int>::delayed(Duration::milliseconds(30), []() { return Int(30); }));
    
    // 等待所有 Future 完成
    ObjectPtr<List<Int>> results = Future<Int>::wait(futures);
    
    ASSERT_EQ(3, results->size().value.int_value);
    
    Int result1 = results->get(Int(0));
    Int result2 = results->get(Int(1));
    Int result3 = results->get(Int(2));
    
    ASSERT_EQ(10, result1.value.int_value);
    ASSERT_EQ(20, result2.value.int_value);
    ASSERT_EQ(30, result3.value.int_value);
}

TEST(future_any_completion) {
    // 测试任意一个 Future 完成
    ObjectPtr<List<ObjectPtr<Future<String>>>> futures = List<ObjectPtr<Future<String>>>::create();
    
    futures->add(Future<String>::delayed(Duration::milliseconds(100), []() { return String("First"); }));
    futures->add(Future<String>::delayed(Duration::milliseconds(50), []() { return String("Second"); }));
    futures->add(Future<String>::delayed(Duration::milliseconds(150), []() { return String("Third"); }));
    
    auto start = std::chrono::steady_clock::now();
    
    // 等待任意一个完成
    String first_result = Future<String>::any(futures);
    
    auto end = std::chrono::steady_clock::now();
    auto elapsed = std::chrono::duration_cast<std::chrono::milliseconds>(end - start).count();
    
    // 应该是最快的那个（50ms 的）
    ASSERT_EQ("Second", first_result.getValue());
    ASSERT_TRUE(elapsed >= 40 && elapsed <= 80);  // 允许一些误差
}

// ============================================================================
// 实际应用场景测试
// ============================================================================

TEST(database_query_simulation) {
    // 模拟数据库查询
    ObjectPtr<Future<ObjectPtr<List<String>>>> queryFuture = Future<ObjectPtr<List<String>>>::delayed(
        Duration::milliseconds(120),
        []() {
            ObjectPtr<List<String>> results = List<String>::create();
            results->add(String("User1"));
            results->add(String("User2"));
            results->add(String("User3"));
            return results;
        }
    );
    
    ObjectPtr<List<String>> users = queryFuture->wait();
    ASSERT_EQ(3, users->size().value.int_value);
    
    String first_user = users->get(Int(0));
    ASSERT_EQ("User1", first_user.getValue());
}

TEST(network_request_simulation) {
    // 模拟网络请求
    ObjectPtr<Future<String>> networkFuture = Future<String>::delayed(
        Duration::milliseconds(200),
        []() {
            return String("{\"status\":\"success\",\"data\":\"response\"}");
        }
    );
    
    // 处理响应
    ObjectPtr<Future<Bool>> processedFuture = networkFuture->then<Bool>([](String response) {
        return Bool(response.contains(String("success")).value.bool_value);
    });
    
    Bool success = processedFuture->wait();
    ASSERT_TRUE(success.value.bool_value);
}

TEST(file_operation_simulation) {
    // 模拟文件操作
    ObjectPtr<Future<String>> readFuture = Future<String>::delayed(
        Duration::milliseconds(80),
        []() {
            return String("File content line 1\nFile content line 2\n");
        }
    );
    
    ObjectPtr<Future<Int>> lineCountFuture = readFuture->then<Int>([](String content) {
        Int count(0);
        std::string str = content.getValue();
        for (char c : str) {
            if (c == '\n') {
                count = Int(count.value.int_value + 1);
            }
        }
        return count;
    });
    
    Int line_count = lineCountFuture->wait();
    ASSERT_EQ(2, line_count.value.int_value);
}

TEST(complex_async_workflow) {
    // 复杂的异步工作流
    ObjectPtr<Future<String>> userFuture = fetchUserData(Int(42));
    
    ObjectPtr<Future<Bool>> validationFuture = userFuture->then<Bool>([](String userData) {
        return validateData(userData)->wait();
    });
    
    ObjectPtr<Future<String>> resultFuture = validationFuture->then<String>([](Bool isValid) {
        if (isValid.value.bool_value) {
            return String("User data is valid");
        } else {
            return String("User data is invalid");
        }
    });
    
    String final_result = resultFuture->wait();
    ASSERT_EQ("User data is valid", final_result.getValue());
}

// ============================================================================
// 主函数
// ============================================================================

int main() {
    std::cout << "=== 异步编程测试开始 ===" << std::endl;
    std::cout << std::endl;
    
    std::cout << "--- Duration 测试 ---" << std::endl;
    RUN_TEST(duration_basic_operations);
    RUN_TEST(duration_arithmetic_operations);
    std::cout << std::endl;
    
    std::cout << "--- Future 基础测试 ---" << std::endl;
    RUN_TEST(future_value_creation);
    RUN_TEST(future_delayed_int);
    RUN_TEST(future_delayed_string);
    RUN_TEST(future_delayed_double);
    std::cout << std::endl;
    
    std::cout << "--- Future 链式操作测试 ---" << std::endl;
    RUN_TEST(future_chained_operations);
    RUN_TEST(future_then_operations);
    RUN_TEST(future_catchError_operations);
    std::cout << std::endl;
    
    std::cout << "--- Completer 测试 ---" << std::endl;
    RUN_TEST(completer_basic_operations);
    RUN_TEST(completer_error_handling);
    std::cout << std::endl;
    
    std::cout << "--- 并发异步操作测试 ---" << std::endl;
    RUN_TEST(multiple_futures_parallel);
    RUN_TEST(future_wait_with_timeout);
    std::cout << std::endl;
    
    std::cout << "--- Future 静态方法测试 ---" << std::endl;
    RUN_TEST(future_wait_multiple);
    RUN_TEST(future_any_completion);
    std::cout << std::endl;
    
    std::cout << "--- 实际应用场景测试 ---" << std::endl;
    RUN_TEST(database_query_simulation);
    RUN_TEST(network_request_simulation);
    RUN_TEST(file_operation_simulation);
    RUN_TEST(complex_async_workflow);
    std::cout << std::endl;
    
    std::cout << "=== 所有异步编程测试通过! ===" << std::endl;
    
    return 0;
}
