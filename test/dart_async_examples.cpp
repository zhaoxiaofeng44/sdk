#include "../pkg/dart2bytecode/base/object.h"
#include "../pkg/dart2bytecode/base/dart_async.h"
#include <iostream>
#include <chrono>

// ============================================================================
// Dart 异步编程完整示例 - Future、async/await、Stream
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
// 示例 1: 基础 Future 使用
// ============================================================================

void demo_basic_future() {
    dart_print(dart_string("=== 基础 Future 示例 ==="));
    
    // 创建已完成的 Future
    auto completedFuture = dart_future_value(dart_string("Hello, Future!"));
    dart_print(dart_string("已完成的 Future: ") + completedFuture.get());
    
    // 创建错误 Future
    auto errorFuture = dart_future_error<String>(dart_string("Something went wrong"));
    try {
        errorFuture.get();
    } catch (const std::exception& e) {
        dart_print(dart_string("捕获错误: ") + dart_string(e.what()));
    }
    
    // 使用 Completer 手动控制 Future
    Completer<Int> completer;
    auto future = completer.getFuture();
    
    // 异步完成 Future
    DART_RUN_ASYNC({
        DART_DELAY(dart_double(1.0));  // 延迟1秒
        completer.complete(dart_int(42));
        dart_print(dart_string("Completer 已完成"));
    });
    
    dart_print(dart_string("等待 Completer 结果..."));
    Int result = future.get();
    dart_print(dart_string("Completer 结果: ") + result.toString());
}

// ============================================================================
// 示例 2: 延迟 Future 和链式调用
// ============================================================================

void demo_delayed_and_chaining() {
    dart_print(dart_string("=== 延迟 Future 和链式调用 ==="));
    
    // 创建延迟 Future
    auto delayedFuture = dart_future_delayed<String>(dart_double(0.5), []() -> String {
        return dart_string("延迟执行的结果");
    });
    
    // 链式调用 - then
    auto chainedFuture = delayedFuture.then<String>([](const String& value) -> String {
        return value + dart_string(" -> 经过处理");
    }).then<String>([](const String& value) -> String {
        return value + dart_string(" -> 再次处理");
    });
    
    dart_print(dart_string("链式调用结果: ") + chainedFuture.get());
    
    // 数值计算链
    auto numberFuture = dart_future_value(dart_int(10))
        .then<Int>([](const Int& x) -> Int {
            return x * dart_int(2);
        })
        .then<Int>([](const Int& x) -> Int {
            return x + dart_int(5);
        });
    
    dart_print(dart_string("数值计算结果: ") + numberFuture.get().toString());
}

// ============================================================================
// 示例 3: 错误处理和完成回调
// ============================================================================

void demo_error_handling() {
    dart_print(dart_string("=== 错误处理示例 ==="));
    
    // 可能出错的异步操作
    auto riskyFuture = dart_future_delayed<Int>(dart_double(0.3), []() -> Int {
        // 模拟随机错误
        static bool should_fail = true;
        if (should_fail) {
            should_fail = false;
            throw std::runtime_error("模拟的错误");
        }
        return dart_int(100);
    });
    
    // 使用 catchError 处理错误
    auto safeFuture = riskyFuture.catchError<Int>([](const String& error) -> Int {
        dart_print(dart_string("错误已处理: ") + error);
        return dart_int(-1);  // 默认值
    });
    
    // 使用 whenComplete 添加完成回调
    auto finalFuture = safeFuture.whenComplete<Int>([]() {
        dart_print(dart_string("异步操作已完成（无论成功或失败）"));
    });
    
    Int result = finalFuture.get();
    dart_print(dart_string("最终结果: ") + result.toString());
}

// ============================================================================
// 示例 4: async/await 语法糖
// ============================================================================

// 异步函数：获取用户信息
DART_ASYNC_FUNCTION(String, fetchUserInfo, (Int userId)) {
    DART_ASYNC_BEGIN
        // 模拟网络请求延迟
        DART_DELAY(dart_double(1.0));
        
        String userInfo = dart_string("User") + userId.toString() + dart_string(": John Doe");
        return userInfo;
    DART_ASYNC_END
}

// 异步函数：获取用户权限
DART_ASYNC_FUNCTION(Bool, fetchUserPermissions, (Int userId)) {
    DART_ASYNC_BEGIN
        DART_DELAY(dart_double(0.5));
        return Bool(userId.toInt() > 0);  // 简单的权限检查
    DART_ASYNC_END
}

// 复合异步函数：获取完整用户数据
DART_ASYNC_FUNCTION(String, fetchCompleteUserData, (Int userId)) {
    DART_ASYNC_BEGIN
        // 在实际的 async/await 中，这些会是 await 调用
        String userInfo = DART_AWAIT(fetchUserInfo(userId));
        Bool hasPermissions = DART_AWAIT(fetchUserPermissions(userId));
        
        String result = userInfo;
        if (hasPermissions.toBool()) {
            result = result + dart_string(" (有权限)");
        } else {
            result = result + dart_string(" (无权限)");
        }
        
        return result;
    DART_ASYNC_END
}

void demo_async_await() {
    dart_print(dart_string("=== async/await 语法示例 ==="));
    
    // 使用异步函数
    auto userFuture = fetchCompleteUserData(dart_int(123));
    
    dart_print(dart_string("正在获取用户数据..."));
    String userData = userFuture.get();
    dart_print(dart_string("用户数据: ") + userData);
    
    // 并行执行多个异步操作
    auto user1Future = fetchUserInfo(dart_int(1));
    auto user2Future = fetchUserInfo(dart_int(2));
    auto user3Future = fetchUserInfo(dart_int(3));
    
    dart_print(dart_string("并行获取多个用户信息..."));
    
    // 等待所有结果
    String user1 = user1Future.get();
    String user2 = user2Future.get();
    String user3 = user3Future.get();
    
    dart_print(dart_string("用户1: ") + user1);
    dart_print(dart_string("用户2: ") + user2);
    dart_print(dart_string("用户3: ") + user3);
}

// ============================================================================
// 示例 5: Stream 流处理
// ============================================================================

void demo_streams() {
    dart_print(dart_string("=== Stream 流处理示例 ==="));
    
    // 创建数字流
    std::vector<Int> numbers = {dart_int(1), dart_int(2), dart_int(3), dart_int(4), dart_int(5)};
    auto numberStream = StreamInt::fromIterable(numbers);
    
    // 监听流数据
    numberStream.listen([](const Int& value) {
        dart_print(dart_string("接收到数据: ") + value.toString());
    });
    
    // 手动创建流
    StreamString messageStream;
    
    // 监听消息流
    messageStream.listen([](const String& message) {
        dart_print(dart_string("消息: ") + message);
    });
    
    // 异步发送消息
    DART_RUN_ASYNC({
        DART_DELAY(dart_double(0.5));
        messageStream.add(dart_string("第一条消息"));
        
        DART_DELAY(dart_double(0.5));
        messageStream.add(dart_string("第二条消息"));
        
        DART_DELAY(dart_double(0.5));
        messageStream.add(dart_string("第三条消息"));
        
        messageStream.close();
    });
    
    // 等待流处理完成
    std::this_thread::sleep_for(std::chrono::milliseconds(2000));
    dart_print(dart_string("Stream 示例完成"));
}

// ============================================================================
// 示例 6: 定时器和周期性任务
// ============================================================================

void demo_timers() {
    dart_print(dart_string("=== 定时器示例 ==="));
    
    // 单次定时器
    dart_print(dart_string("设置2秒后的定时器..."));
    Timer timer(dart_double(2.0), []() {
        dart_print(dart_string("定时器触发！"));
    });
    
    // 周期性任务
    dart_print(dart_string("启动周期性任务（每0.5秒，共3次）..."));
    dart_periodic_timer(dart_double(0.5), []() {
        static int count = 0;
        count++;
        dart_print(dart_string("周期任务执行 #") + dart_int(count).toString());
    }, dart_int(3));
    
    // 等待所有定时器完成
    std::this_thread::sleep_for(std::chrono::milliseconds(3000));
    dart_print(dart_string("定时器示例完成"));
}

// ============================================================================
// 示例 7: 复杂异步场景 - 模拟 HTTP 请求
// ============================================================================

// 模拟 HTTP 响应
struct HttpResponse {
    Int statusCode;
    String body;
    
    HttpResponse(Int code, const String& content) 
        : statusCode(code), body(content) {}
};

// 异步 HTTP GET 请求
DART_ASYNC_FUNCTION(HttpResponse, httpGet, (const String& url)) {
    DART_ASYNC_BEGIN
        dart_print(dart_string("发送 GET 请求到: ") + url);
        
        // 模拟网络延迟
        DART_DELAY(dart_double(1.0 + (rand() % 1000) / 1000.0));
        
        // 模拟响应
        if (url.getValue().find("error") != std::string::npos) {
            return HttpResponse(dart_int(404), dart_string("Not Found"));
        } else {
            return HttpResponse(dart_int(200), dart_string("Success: ") + url);
        }
    DART_ASYNC_END
}

void demo_http_simulation() {
    dart_print(dart_string("=== HTTP 请求模拟 ==="));
    
    // 多个并发请求
    std::vector<String> urls = {
        dart_string("https://api.example.com/users"),
        dart_string("https://api.example.com/posts"),
        dart_string("https://api.example.com/error"),  // 这个会失败
        dart_string("https://api.example.com/comments")
    };
    
    dart_print(dart_string("发送并发 HTTP 请求..."));
    
    // 创建所有请求的 Future
    std::vector<Future<HttpResponse>> futures;
    for (const auto& url : urls) {
        futures.push_back(httpGet(url));
    }
    
    // 等待所有请求完成并处理结果
    for (size_t i = 0; i < futures.size(); ++i) {
        try {
            HttpResponse response = futures[i].get();
            
            dart_print(dart_string("请求 ") + dart_int(static_cast<int>(i + 1)).toString() + 
                      dart_string(" - 状态码: ") + response.statusCode.toString() +
                      dart_string(", 响应: ") + response.body);
        } catch (const std::exception& e) {
            dart_print(dart_string("请求 ") + dart_int(static_cast<int>(i + 1)).toString() + 
                      dart_string(" 失败: ") + dart_string(e.what()));
        }
    }
}

// ============================================================================
// 示例 8: 异步数据处理管道
// ============================================================================

// 异步数据处理链
DART_ASYNC_FUNCTION(String, processData, (const String& input)) {
    DART_ASYNC_BEGIN
        dart_print(dart_string("处理数据: ") + input);
        DART_DELAY(dart_double(0.3));
        return dart_string("已处理-") + input;
    DART_ASYNC_END
}

DART_ASYNC_FUNCTION(String, validateData, (const String& data)) {
    DART_ASYNC_BEGIN
        dart_print(dart_string("验证数据: ") + data);
        DART_DELAY(dart_double(0.2));
        
        if (data.getValue().find("error") != std::string::npos) {
            throw std::runtime_error("验证失败");
        }
        
        return dart_string("已验证-") + data;
    DART_ASYNC_END
}

DART_ASYNC_FUNCTION(String, saveData, (const String& validatedData)) {
    DART_ASYNC_BEGIN
        dart_print(dart_string("保存数据: ") + validatedData);
        DART_DELAY(dart_double(0.4));
        return dart_string("已保存-") + validatedData;
    DART_ASYNC_END
}

void demo_async_pipeline() {
    dart_print(dart_string("=== 异步数据处理管道 ==="));
    
    std::vector<String> inputData = {
        dart_string("数据1"),
        dart_string("数据2"),  
        dart_string("error-数据3"),  // 这个会在验证时失败
        dart_string("数据4")
    };
    
    for (size_t i = 0; i < inputData.size(); ++i) {
        const String& input = inputData[i];
        
        dart_print(dart_string("开始处理数据 ") + dart_int(static_cast<int>(i + 1)).toString());
        
        // 构建异步处理管道
        auto pipeline = processData(input)
            .then<String>([](const String& processed) -> String {
                return DART_AWAIT(validateData(processed));
            })
            .then<String>([](const String& validated) -> String {
                return DART_AWAIT(saveData(validated));
            })
            .catchError<String>([i](const String& error) -> String {
                dart_print(dart_string("数据 ") + dart_int(static_cast<int>(i + 1)).toString() + 
                          dart_string(" 处理失败: ") + error);
                return dart_string("处理失败");
            })
            .whenComplete<String>([]() {
                dart_print(dart_string("数据处理管道完成"));
            });
        
        // 获取最终结果
        String result = pipeline.get();
        dart_print(dart_string("最终结果: ") + result);
        dart_print(dart_string(""));
    }
}

// ============================================================================
// 主函数
// ============================================================================

int main() {
    try {
        dart_print(dart_string("Dart 异步编程完整示例"));
        dart_print(dart_string("========================"));
        std::cout << std::endl;
        
        demo_basic_future();
        std::cout << std::endl;
        
        demo_delayed_and_chaining();
        std::cout << std::endl;
        
        demo_error_handling();
        std::cout << std::endl;
        
        demo_async_await();
        std::cout << std::endl;
        
        demo_streams();
        std::cout << std::endl;
        
        demo_timers();
        std::cout << std::endl;
        
        demo_http_simulation();
        std::cout << std::endl;
        
        demo_async_pipeline();
        std::cout << std::endl;
        
        dart_print(dart_string("✅ 所有异步编程示例运行完成！"));
        dart_print(dart_string("特性总结："));
        dart_print(dart_string("  1. Future<T> 完整实现"));
        dart_print(dart_string("  2. async/await 语法糖"));
        dart_print(dart_string("  3. then/catchError/whenComplete 链式调用"));
        dart_print(dart_string("  4. Stream<T> 流处理"));
        dart_print(dart_string("  5. 定时器和周期性任务"));
        dart_print(dart_string("  6. 并发和异步管道"));
        dart_print(dart_string("  7. 错误处理和异常安全"));
        dart_print(dart_string("  8. 线程池调度器"));
        
        // 给异步任务时间完成
        std::this_thread::sleep_for(std::chrono::milliseconds(500));
        
    } catch (const std::exception& e) {
        std::cerr << "❌ 程序执行出现错误: " << e.what() << std::endl;
        return 1;
    } catch (...) {
        std::cerr << "❌ 程序执行出现未知错误" << std::endl;
        return 1;
    }
    
    return 0;
}
