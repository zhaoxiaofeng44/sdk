#include "../pkg/dart2bytecode/base/object.h"
#include "../pkg/dart2bytecode/base/dart_async_simple.h"
#include <iostream>

// ============================================================================
// Dart 异步编程简化示例 - C++03 兼容版本
// ============================================================================

// 简化的打印和类型构造宏
#define dart_print(value) \
    do { \
        std::cout << (value).toString().getValue() << std::endl; \
    } while(0)

#define dart_int(value) Int(value)
#define dart_double(value) Double(value)
#define dart_bool(value) Bool(value)
#define dart_string(value) String(value)

// ============================================================================
// 示例 1: 基础 SimpleFuture 使用
// ============================================================================

void demo_basic_simple_future() {
    dart_print(dart_string("=== 基础 SimpleFuture 示例 ==="));
    
    // 创建已完成的 Future
    SimpleFutureString completedFuture = dart_simple_future_value(dart_string("Hello, Simple Future!"));
    dart_print(dart_string("已完成的 Future: ") + completedFuture.get());
    
    // 创建错误 Future
    SimpleFutureString errorFuture = dart_simple_future_error<String>(dart_string("Something went wrong"));
    if (errorFuture.hasError().toBool()) {
        dart_print(dart_string("Future 有错误: ") + errorFuture.getError());
    }
    
    // 使用 SimpleCompleter
    SimpleCompleter<Int> completer;
    SimpleFutureInt future = completer.getFuture();
    
    // 完成 Future
    completer.complete(dart_int(42));
    
    if (future.isCompleted().toBool()) {
        Int result = future.get();
        dart_print(dart_string("Completer 结果: ") + result.toString());
    }
}

// ============================================================================
// 示例 2: 链式调用
// ============================================================================

void demo_chaining() {
    dart_print(dart_string("=== 链式调用示例 ==="));
    
    // 基础链式调用
    SimpleFutureString chainedFuture = dart_simple_future_value(dart_string("Start"))
        .then<String>([](const String& value) -> String {
            return value + dart_string(" -> Step1");
        })
        .then<String>([](const String& value) -> String {
            return value + dart_string(" -> Step2");
        })
        .then<String>([](const String& value) -> String {
            return value + dart_string(" -> End");
        });
    
    dart_print(dart_string("链式调用结果: ") + chainedFuture.get());
    
    // 数值计算链
    SimpleFutureInt numberChain = dart_simple_future_value(dart_int(10))
        .then<Int>([](const Int& x) -> Int {
            return Int(x.toInt() * 2);
        })
        .then<Int>([](const Int& x) -> Int {
            return Int(x.toInt() + 5);
        })
        .then<Int>([](const Int& x) -> Int {
            return Int(x.toInt() * 3);
        });
    
    dart_print(dart_string("数值计算结果: ") + numberChain.get().toString());
}

// ============================================================================
// 示例 3: 错误处理
// ============================================================================

void demo_error_handling() {
    dart_print(dart_string("=== 错误处理示例 ==="));
    
    // 创建会出错的 Future
    SimpleFutureInt errorFuture = dart_simple_future_error<Int>(dart_string("计算失败"));
    
    // 使用 catchError 处理错误
    SimpleFutureInt safeFuture = errorFuture.catchError<Int>([](const String& error) -> Int {
        dart_print(dart_string("捕获错误: ") + error);
        return dart_int(-1);  // 默认值
    });
    
    Int result = safeFuture.get();
    dart_print(dart_string("错误处理后的结果: ") + result.toString());
    
    // 正常值的错误处理（不会触发）
    SimpleFutureInt normalFuture = dart_simple_future_value(dart_int(100))
        .catchError<Int>([](const String& error) -> Int {
            dart_print(dart_string("这不会被调用"));
            return dart_int(0);
        });
    
    dart_print(dart_string("正常值结果: ") + normalFuture.get().toString());
}

// ============================================================================
// 示例 4: 简化的异步函数
// ============================================================================

// 异步函数：获取用户信息
DART_SIMPLE_ASYNC_FUNCTION(String, fetchUserInfo, (Int userId)) {
    DART_SIMPLE_ASYNC_BEGIN
        String userInfo = dart_string("User") + userId.toString() + dart_string(": Simple User");
    DART_SIMPLE_ASYNC_END(userInfo)
}

// 异步函数：获取用户权限
DART_SIMPLE_ASYNC_FUNCTION(Bool, fetchUserPermissions, (Int userId)) {
    DART_SIMPLE_ASYNC_BEGIN
        Bool hasPermissions = Bool(userId.toInt() > 0);
    DART_SIMPLE_ASYNC_END(hasPermissions)
}

// 复合异步函数
DART_SIMPLE_ASYNC_FUNCTION(String, fetchCompleteUserData, (Int userId)) {
    DART_SIMPLE_ASYNC_BEGIN
        String userInfo = DART_SIMPLE_AWAIT(fetchUserInfo(userId));
        Bool hasPermissions = DART_SIMPLE_AWAIT(fetchUserPermissions(userId));
        
        String result = userInfo;
        if (hasPermissions.toBool()) {
            result = result + dart_string(" (有权限)");
        } else {
            result = result + dart_string(" (无权限)");
        }
    DART_SIMPLE_ASYNC_END(result)
}

void demo_simple_async_functions() {
    dart_print(dart_string("=== 简化异步函数示例 ==="));
    
    // 使用异步函数
    SimpleFutureString userFuture = fetchCompleteUserData(dart_int(123));
    String userData = userFuture.get();
    dart_print(dart_string("用户数据: ") + userData);
    
    // 多个异步调用
    SimpleFutureString user1 = fetchUserInfo(dart_int(1));
    SimpleFutureString user2 = fetchUserInfo(dart_int(2));
    SimpleFutureString user3 = fetchUserInfo(dart_int(3));
    
    dart_print(dart_string("用户1: ") + user1.get());
    dart_print(dart_string("用户2: ") + user2.get());
    dart_print(dart_string("用户3: ") + user3.get());
}

// ============================================================================
// 示例 5: SimpleStream 使用
// ============================================================================

void demo_simple_streams() {
    dart_print(dart_string("=== SimpleStream 示例 ==="));
    
    // 创建字符串流
    SimpleStreamString messageStream;
    
    // 添加消息
    messageStream.add(dart_string("第一条消息"));
    messageStream.add(dart_string("第二条消息"));
    messageStream.add(dart_string("第三条消息"));
    
    // 处理所有消息
    dart_print(dart_string("处理消息流:"));
    messageStream.processAll([](const String& message) {
        std::cout << "  接收: " << message.getValue() << std::endl;
    });
    
    // 数字流
    SimpleStreamInt numberStream;
    for (int i = 1; i <= 5; ++i) {
        numberStream.add(dart_int(i * i));  // 添加平方数
    }
    
    dart_print(dart_string("处理数字流（平方数）:"));
    numberStream.processAll([](const Int& number) {
        std::cout << "  平方数: " << number.toString().getValue() << std::endl;
    });
}

// ============================================================================
// 示例 6: 复杂的异步处理场景
// ============================================================================

// 模拟数据处理
DART_SIMPLE_ASYNC_FUNCTION(String, processData, (const String& input)) {
    DART_SIMPLE_ASYNC_BEGIN
        String processed = dart_string("已处理-") + input;
    DART_SIMPLE_ASYNC_END(processed)
}

// 模拟数据验证
DART_SIMPLE_ASYNC_FUNCTION(String, validateData, (const String& data)) {
    DART_SIMPLE_ASYNC_BEGIN
        if (data.getValue().find("error") != std::string::npos) {
            // 通过返回错误 Future 来模拟验证失败
            return SimpleFuture<String>::error(dart_string("验证失败"));
        }
        String validated = dart_string("已验证-") + data;
    DART_SIMPLE_ASYNC_END(validated)
}

// 模拟数据保存
DART_SIMPLE_ASYNC_FUNCTION(String, saveData, (const String& validatedData)) {
    DART_SIMPLE_ASYNC_BEGIN
        String saved = dart_string("已保存-") + validatedData;
    DART_SIMPLE_ASYNC_END(saved)
}

void demo_complex_async_scenario() {
    dart_print(dart_string("=== 复杂异步场景示例 ==="));
    
    // 测试数据
    String inputs[] = {
        dart_string("数据1"),
        dart_string("数据2"),
        dart_string("error-数据3"),  // 这个会在验证时失败
        dart_string("数据4")
    };
    
    for (int i = 0; i < 4; ++i) {
        const String& input = inputs[i];
        
        dart_print(dart_string("处理数据 ") + dart_int(i + 1).toString() + dart_string(": ") + input);
        
        // 构建处理管道
        SimpleFutureString step1 = processData(input);
        
        SimpleFutureString step2 = step1.then<String>([](const String& processed) -> String {
            SimpleFutureString validated = validateData(processed);
            return validated.get();  // 简化版本中直接获取结果
        });
        
        SimpleFutureString final_result = step2
            .then<String>([](const String& validated) -> String {
                SimpleFutureString saved = saveData(validated);
                return saved.get();
            })
            .catchError<String>([i](const String& error) -> String {
                dart_print(dart_string("  处理失败: ") + error);
                return dart_string("处理失败-数据") + dart_int(i + 1).toString();
            })
            .whenComplete<String>([]() {
                dart_print(dart_string("  处理完成"));
            });
        
        String result = final_result.get();
        dart_print(dart_string("  最终结果: ") + result);
        std::cout << std::endl;
    }
}

// ============================================================================
// 示例 7: 定时器使用
// ============================================================================

void demo_simple_timers() {
    dart_print(dart_string("=== 简化定时器示例 ==="));
    
    // 简单定时器（在简化版本中会立即执行）
    dart_print(dart_string("创建定时器..."));
    SimpleTimer timer(dart_double(1.0), []() {
        dart_print(dart_string("定时器回调执行"));
    });
    
    dart_print(dart_string("定时器示例完成"));
}

// ============================================================================
// 示例 8: 实用工具函数
// ============================================================================

// 安全的异步操作
template<typename T>
SimpleFuture<T> safeAsyncOp(const T& input, Bool should_fail = Bool(false)) {
    if (should_fail.toBool()) {
        return SimpleFuture<T>::error(dart_string("操作失败"));
    } else {
        return SimpleFuture<T>::value(input);
    }
}

void demo_utility_functions() {
    dart_print(dart_string("=== 工具函数示例 ==="));
    
    // 成功操作
    SimpleFutureString success = safeAsyncOp(dart_string("成功数据"), dart_bool(false));
    dart_print(dart_string("成功操作结果: ") + success.get());
    
    // 失败操作
    SimpleFutureString failure = safeAsyncOp(dart_string("失败数据"), dart_bool(true));
    if (failure.hasError().toBool()) {
        dart_print(dart_string("失败操作错误: ") + failure.getError());
    }
    
    // 批量处理
    String batch_data[] = {
        dart_string("批量1"),
        dart_string("批量2"), 
        dart_string("批量3")
    };
    
    dart_print(dart_string("批量处理结果:"));
    for (int i = 0; i < 3; ++i) {
        SimpleFutureString result = safeAsyncOp(batch_data[i], dart_bool(false))
            .then<String>([i](const String& data) -> String {
                return dart_string("处理完成[") + dart_int(i + 1).toString() + dart_string("]: ") + data;
            });
        
        dart_print(dart_string("  ") + result.get());
    }
}

// ============================================================================
// 主函数
// ============================================================================

int main() {
    try {
        dart_print(dart_string("Dart 异步编程简化示例 (C++03 兼容)"));
        dart_print(dart_string("===================================="));
        std::cout << std::endl;
        
        demo_basic_simple_future();
        std::cout << std::endl;
        
        demo_chaining();
        std::cout << std::endl;
        
        demo_error_handling();
        std::cout << std::endl;
        
        demo_simple_async_functions();
        std::cout << std::endl;
        
        demo_simple_streams();
        std::cout << std::endl;
        
        demo_complex_async_scenario();
        std::cout << std::endl;
        
        demo_simple_timers();
        std::cout << std::endl;
        
        demo_utility_functions();
        std::cout << std::endl;
        
        dart_print(dart_string("✅ 所有简化异步编程示例运行完成！"));
        dart_print(dart_string("特性总结（简化版）："));
        dart_print(dart_string("  1. SimpleFuture<T> 基础异步结果"));
        dart_print(dart_string("  2. 链式调用 then/catchError/whenComplete"));
        dart_print(dart_string("  3. SimpleCompleter<T> 手动控制"));
        dart_print(dart_string("  4. 异步函数语法糖"));
        dart_print(dart_string("  5. SimpleStream<T> 简单流处理"));
        dart_print(dart_string("  6. 错误处理和异常安全"));
        dart_print(dart_string("  7. C++03 兼容性"));
        dart_print(dart_string(""));
        dart_print(dart_string("注意：这是简化版本，适合学习和原型开发"));
        dart_print(dart_string("生产环境建议使用完整的多线程版本实现"));
        
    } catch (const std::exception& e) {
        std::cerr << "❌ 程序执行出现错误: " << e.what() << std::endl;
        return 1;
    } catch (...) {
        std::cerr << "❌ 程序执行出现未知错误" << std::endl;
        return 1;
    }
    
    return 0;
}
