#include "../../cpp/core/object.h"
#include <iostream>

// 工具宏定义
#define dart_print(value) \
    do { \
        std::cout << (value).toString().getValue() << std::endl; \
    } while(0)

#define dart_int(value) Int(value)
#define dart_double(value) Double(value)
#define dart_bool(value) Bool(value)
#define dart_string(value) String(value)

// ============================================================================
// 类: MessageService
// ============================================================================

class MessageService {
private:
  StreamController _controller = StreamController::();
public:
  MessageService() {
  }
  
  Stream<String> messages() {
    return this->_controller->stream;
  }
  
  void sendMessage(String message) {
    {
      this->_controller->add(message);
}
  }
  
  void sendError(String error) {
    {
      this->_controller->addError(error);
}
  }
  
  void close() {
    {
      this->_controller->close();
}
  }
  
};

DART_ASYNC_FUNCTION(void, main, ()) {
    DART_ASYNC_BEGIN
  {
    dart_print(dart_string("🔥 异步编程演示开始"));
    DART_AWAIT(testFutureBasics());
    DART_AWAIT(testAsyncAwait());
    DART_AWAIT(testFutureCombination());
    DART_AWAIT(testErrorHandling());
    DART_AWAIT(testStreamBasics());
    DART_AWAIT(testStreamTransformation());
    DART_AWAIT(testTimers());
    dart_print(dart_string("✅ 异步编程演示完成"));
}
    DART_ASYNC_END
}

DART_ASYNC_FUNCTION(Future<void>, testFutureBasics, ()) {
    DART_ASYNC_BEGIN
  {
    dart_print(dart_string("
📌 测试 Future 基础"));
    auto immediateFuture = Future::value(dart_string("立即完成"));
    auto result1 = DART_AWAIT(immediateFuture);
    dart_print(dart_string("  立即Future: ") + result1.toString());
    auto delayedFuture = Future::delayed(ObjectPtr<Duration>(new Duration(/*milliseconds:*/ dart_int(100))), [&]() { return dart_string("延迟完成"); });
    auto result2 = DART_AWAIT(delayedFuture);
    dart_print(dart_string("  延迟Future: ") + result2.toString());
    DART_AWAIT(Future::delayed(ObjectPtr<Duration>(new Duration(/*milliseconds:*/ dart_int(50))))->then([&](Any _) { return dart_print(dart_string("  then: 延迟操作完成")); })->catchError([&](Any error) { return dart_print(dart_string("  catchError: ") + error.toString()); }));
    auto syncFuture = Future::sync([&]() { return dart_int(42); });
    auto result3 = DART_AWAIT(syncFuture);
    dart_print(dart_string("  同步Future: ") + result3.toString());
    auto completer = Completer::();
    Timer::(ObjectPtr<Duration>(new Duration(/*milliseconds:*/ dart_int(50))), [&]() { {
    completer->complete(dart_string("Completer完成"));
} });
    auto result4 = DART_AWAIT(completer->future);
    dart_print(dart_string("  Completer: ") + result4.toString());
}
    DART_ASYNC_END
}

DART_ASYNC_FUNCTION(Future<void>, testAsyncAwait, ()) {
    DART_ASYNC_BEGIN
  {
    dart_print(dart_string("
📌 测试 async/await"));
    auto greeting = DART_AWAIT(getGreeting(dart_string("Alice")));
    dart_print(dart_string("  问候: ") + greeting.toString());
    dart_print(dart_string("  开始多个异步操作..."));
    auto result1 = DART_AWAIT(fetchData(dart_string("数据1"), dart_int(100)));
    auto result2 = DART_AWAIT(fetchData(dart_string("数据2"), dart_int(150)));
    auto result3 = DART_AWAIT(fetchData(dart_string("数据3"), dart_int(80)));
    dart_print(dart_string("  结果1: ") + result1.toString());
    dart_print(dart_string("  结果2: ") + result2.toString());
    dart_print(dart_string("  结果3: ") + result3.toString());
    dart_print(dart_string("  开始并行异步操作..."));
    auto futures = _GrowableList::_literal3(fetchData(dart_string("并行数据1"), dart_int(100)), fetchData(dart_string("并行数据2"), dart_int(150)), fetchData(dart_string("并行数据3"), dart_int(80)));
    auto results = DART_AWAIT(Future::wait(futures));
    dart_print(dart_string("  并行结果: ") + results.toString());
}
    DART_ASYNC_END
}

DART_ASYNC_FUNCTION(Future<void>, testFutureCombination, ()) {
    DART_ASYNC_BEGIN
  {
    dart_print(dart_string("
📌 测试 Future 组合"));
    auto numberFutures = _GrowableList::_literal3(Future::delayed(ObjectPtr<Duration>(new Duration(/*milliseconds:*/ dart_int(100))), [&]() { return dart_int(1); }), Future::delayed(ObjectPtr<Duration>(new Duration(/*milliseconds:*/ dart_int(150))), [&]() { return dart_int(2); }), Future::delayed(ObjectPtr<Duration>(new Duration(/*milliseconds:*/ dart_int(80))), [&]() { return dart_int(3); }));
    auto numbers = DART_AWAIT(Future::wait(numberFutures));
    dart_print(dart_string("  Future.wait: ") + numbers.toString());
    auto anyResult = Future::any(_GrowableList::_literal3(Future::delayed(ObjectPtr<Duration>(new Duration(/*milliseconds:*/ dart_int(200))), [&]() { return dart_string("慢的"); }), Future::delayed(ObjectPtr<Duration>(new Duration(/*milliseconds:*/ dart_int(100))), [&]() { return dart_string("快的"); }), Future::delayed(ObjectPtr<Duration>(new Duration(/*milliseconds:*/ dart_int(300))), [&]() { return dart_string("最慢的"); })));
    auto firstResult = DART_AWAIT(anyResult);
    dart_print(dart_string("  Future.any: ") + firstResult.toString());
    auto chainResult = DART_AWAIT(Future::value(dart_int(5))->then([&](Int value) { return (value * dart_int(2)); })->then([&](Int value) { return dart_string("Result: ") + value.toString(); })->then([&](String text) { return text->toUpperCase(); }));
    dart_print(dart_string("  链式调用: ") + chainResult.toString());
    auto items = _GrowableList::_literal3(dart_string("A"), dart_string("B"), dart_string("C"));
    DART_AWAIT(Future::forEach(items, [&](String item) { {
    DART_AWAIT(Future::delayed(ObjectPtr<Duration>(new Duration(/*milliseconds:*/ dart_int(50)))));
    dart_print(dart_string("  处理项目: ") + item.toString());
} }));
}
    DART_ASYNC_END
}

DART_ASYNC_FUNCTION(Future<void>, testErrorHandling, ()) {
    DART_ASYNC_BEGIN
  {
    dart_print(dart_string("
📌 测试错误处理"));
    try {
    DART_AWAIT(riskyOperation(dart_bool(true)));
} catch (const std::exception& e) { /* catch block */ }
// Finally block should be implemented using RAII pattern
    DART_AWAIT(riskyOperation(dart_bool(true))->catchError([&](Any error) { {
    dart_print(dart_string("  Future.catchError: ") + error.toString());
    return dart_string("错误恢复值");
} })->then([&](String value) { return dart_print(dart_string("  恢复后的值: ") + value.toString()); }));
    try {
    auto result = DART_AWAIT(slowOperation()->timeout(ObjectPtr<Duration>(new Duration(/*milliseconds:*/ dart_int(100)))));
    dart_print(dart_string("  操作结果: ") + result.toString());
} catch (const std::exception& e) { /* catch block */ }
// Finally block should be implemented using RAII pattern
    DART_AWAIT(FutureExtensions|onError(Future::error(dart_string("测试错误")), [&](String error, StackTrace stackTrace) { {
    dart_print(dart_string("  onError处理: ") + error.toString());
    return dart_string("默认值");
} })->then([&](Any value) { return dart_print(dart_string("  最终值: ") + value.toString()); }));
}
    DART_ASYNC_END
}

DART_ASYNC_FUNCTION(Future<void>, testStreamBasics, ()) {
    DART_ASYNC_BEGIN
  {
    dart_print(dart_string("
📌 测试 Stream 基础"));
    auto numberStream = Stream::fromIterable(_GrowableList::_literal5(dart_int(1), dart_int(2), dart_int(3), dart_int(4), dart_int(5)));
    dart_print(dart_string("  从列表创建的Stream:"));
    {
    auto :stream = numberStream;
    auto :for-iterator = ObjectPtr<_StreamIterator>(new _StreamIterator(:stream));
    try { /* try block */ } catch (const std::exception& e) { /* catch block */ }
}
    dart_print(dart_string("  周期性Stream (3次):"));
    auto periodicStream = Stream::periodic(ObjectPtr<Duration>(new Duration(/*milliseconds:*/ dart_int(100))), [&](Int count) { return count; })->take(dart_int(3));
    {
    auto :stream = periodicStream;
    auto :for-iterator = ObjectPtr<_StreamIterator>(new _StreamIterator(:stream));
    try { /* try block */ } catch (const std::exception& e) { /* catch block */ }
}
    dart_print(dart_string("  自定义Stream:"));
    auto customStream = generateMessages();
    {
    auto :stream = customStream;
    auto :for-iterator = ObjectPtr<_StreamIterator>(new _StreamIterator(:stream));
    try { /* try block */ } catch (const std::exception& e) { /* catch block */ }
}
    dart_print(dart_string("  Stream监听:"));
    auto listenStream = Stream::fromIterable(_GrowableList::_literal3(dart_int(10), dart_int(20), dart_int(30)));
    auto subscription = listenStream->listen([&](Int data) { return dart_print(dart_string("    监听到数据: ") + data.toString()); });
    DART_AWAIT(subscription->asFuture());
}
    DART_ASYNC_END
}

DART_ASYNC_FUNCTION(Future<void>, testStreamTransformation, ()) {
    DART_ASYNC_BEGIN
  {
    dart_print(dart_string("
📌 测试 Stream 转换"));
    auto sourceStream = Stream::fromIterable(List<Int>::createFromValues({dart_int(1), dart_int(2), dart_int(3), dart_int(4), dart_int(5), dart_int(6), dart_int(7), dart_int(8), dart_int(9), dart_int(10)}));
    auto mappedStream = sourceStream->map([&](Int n) { return dart_string("Number: ") + n.toString(); });
    dart_print(dart_string("  map转换:"));
    {
    auto :stream = mappedStream->take(dart_int(3));
    auto :for-iterator = ObjectPtr<_StreamIterator>(new _StreamIterator(:stream));
    try { /* try block */ } catch (const std::exception& e) { /* catch block */ }
}
    auto evenStream = Stream::fromIterable(List<Int>::createFromValues({dart_int(1), dart_int(2), dart_int(3), dart_int(4), dart_int(5), dart_int(6), dart_int(7), dart_int(8), dart_int(9), dart_int(10)}))->where([&](Int n) { return ((n % dart_int(2)) == dart_int(0)); });
    dart_print(dart_string("  where过滤 (偶数):"));
    {
    auto :stream = evenStream;
    auto :for-iterator = ObjectPtr<_StreamIterator>(new _StreamIterator(:stream));
    try { /* try block */ } catch (const std::exception& e) { /* catch block */ }
}
    auto expandedStream = Stream::fromIterable(_GrowableList::_literal3(dart_int(1), dart_int(2), dart_int(3)))->expand([&](Int n) { return _GrowableList::_literal2(n, (n * dart_int(10))); });
    dart_print(dart_string("  expand展开:"));
    {
    auto :stream = expandedStream;
    auto :for-iterator = ObjectPtr<_StreamIterator>(new _StreamIterator(:stream));
    try { /* try block */ } catch (const std::exception& e) { /* catch block */ }
}
    auto distinctStream = Stream::fromIterable(_GrowableList::_literal7(dart_int(1), dart_int(2), dart_int(2), dart_int(3), dart_int(3), dart_int(3), dart_int(4)))->distinct();
    dart_print(dart_string("  distinct去重:"));
    {
    auto :stream = distinctStream;
    auto :for-iterator = ObjectPtr<_StreamIterator>(new _StreamIterator(:stream));
    try { /* try block */ } catch (const std::exception& e) { /* catch block */ }
}
    auto skipTakeStream = Stream::fromIterable(List<Int>::createFromValues({dart_int(1), dart_int(2), dart_int(3), dart_int(4), dart_int(5), dart_int(6), dart_int(7), dart_int(8), dart_int(9), dart_int(10)}))->skip(dart_int(3))->take(dart_int(4));
    dart_print(dart_string("  skip(3).take(4):"));
    {
    auto :stream = skipTakeStream;
    auto :for-iterator = ObjectPtr<_StreamIterator>(new _StreamIterator(:stream));
    try { /* try block */ } catch (const std::exception& e) { /* catch block */ }
}
    auto sum = DART_AWAIT(Stream::fromIterable(_GrowableList::_literal5(dart_int(1), dart_int(2), dart_int(3), dart_int(4), dart_int(5)))->reduce([&](Int a, Int b) { return (a + b); }));
    dart_print(dart_string("  reduce求和: ") + sum.toString());
    auto concatenated = DART_AWAIT(Stream::fromIterable(_GrowableList::_literal3(dart_string("A"), dart_string("B"), dart_string("C")))->fold(dart_string(""), [&](String prev, String element) { return (prev + element); }));
    dart_print(dart_string("  fold连接: ") + concatenated.toString());
}
    DART_ASYNC_END
}

DART_ASYNC_FUNCTION(Future<void>, testTimers, ()) {
    DART_ASYNC_BEGIN
  {
    dart_print(dart_string("
📌 测试定时器"));
    dart_print(dart_string("  设置一次性定时器 (100ms)"));
    auto timerCompleter = Completer::();
    Timer::(ObjectPtr<Duration>(new Duration(/*milliseconds:*/ dart_int(100))), [&]() { {
    dart_print(dart_string("  一次性定时器触发"));
    timerCompleter->complete();
} });
    DART_AWAIT(timerCompleter->future);
    dart_print(dart_string("  设置周期性定时器 (50ms, 3次)"));
    auto periodicCount = dart_int(0);
    auto periodicCompleter = Completer::();
    Timer::periodic(ObjectPtr<Duration>(new Duration(/*milliseconds:*/ dart_int(50))), [&](Timer timer) { {
    periodicCount = (periodicCount + dart_int(1));
    dart_print(dart_string("  周期性定时器触发: ") + periodicCount.toString());
    if ((periodicCount >= dart_int(3))) {
    timer->cancel();
    periodicCompleter->complete();
}
} });
    DART_AWAIT(periodicCompleter->future);
    dart_print(dart_string("  添加微任务"));
    scheduleMicrotask([&]() { {
    dart_print(dart_string("  微任务执行"));
} });
    DART_AWAIT(Future::delayed(ObjectPtr<Duration>::createConst()));
}
    DART_ASYNC_END
}

DART_ASYNC_FUNCTION(Future<String>, getGreeting, (String name)) {
    DART_ASYNC_BEGIN
  {
    DART_AWAIT(Future::delayed(ObjectPtr<Duration>(new Duration(/*milliseconds:*/ dart_int(50)))));
    return dart_string("Hello, ") + name.toString() + dart_string("!");
}
    DART_ASYNC_END
}

DART_ASYNC_FUNCTION(Future<String>, fetchData, (String dataName, Int delayMs)) {
    DART_ASYNC_BEGIN
  {
    DART_AWAIT(Future::delayed(ObjectPtr<Duration>(new Duration(/*milliseconds:*/ delayMs))));
    return dataName.toString() + dart_string(" (延迟") + delayMs.toString() + dart_string("ms)");
}
    DART_ASYNC_END
}

DART_ASYNC_FUNCTION(Future<String>, riskyOperation, (Bool shouldFail)) {
    DART_ASYNC_BEGIN
  {
    DART_AWAIT(Future::delayed(ObjectPtr<Duration>(new Duration(/*milliseconds:*/ dart_int(50)))));
    if (shouldFail) {
    throw DartException(Exception::(dart_string("操作失败")));
}
    return dart_string("操作成功");
}
    DART_ASYNC_END
}

DART_ASYNC_FUNCTION(Future<String>, slowOperation, ()) {
    DART_ASYNC_BEGIN
  {
    DART_AWAIT(Future::delayed(ObjectPtr<Duration>(new Duration(/*milliseconds:*/ dart_int(200)))));
    return dart_string("慢操作完成");
}
    DART_ASYNC_END
}

DART_ASYNC_FUNCTION(Stream<String>, generateMessages, ()) {
    DART_ASYNC_BEGIN
  {
    for (auto i = dart_int(1);; (i <= dart_int(3)); i = (i + dart_int(1))) {
    DART_AWAIT(Future::delayed(ObjectPtr<Duration>(new Duration(/*milliseconds:*/ dart_int(50)))));
    co_yield dart_string("Message ") + i.toString();  // C++20 coroutine
}
}
    DART_ASYNC_END
}

// ============================================================================
// 主函数
// ============================================================================

int main() {
  try {
    {
      dart_print(dart_string("🔥 异步编程演示开始"));
      DART_AWAIT(testFutureBasics());
      DART_AWAIT(testAsyncAwait());
      DART_AWAIT(testFutureCombination());
      DART_AWAIT(testErrorHandling());
      DART_AWAIT(testStreamBasics());
      DART_AWAIT(testStreamTransformation());
      DART_AWAIT(testTimers());
      dart_print(dart_string("✅ 异步编程演示完成"));
}
    {
      VMServiceEmbedderHooks::cleanup = /* Constant: StaticTearOffConstant */;
      VMServiceEmbedderHooks::createTempDir = /* Constant: StaticTearOffConstant */;
      VMServiceEmbedderHooks::ddsConnected = /* Constant: StaticTearOffConstant */;
      VMServiceEmbedderHooks::ddsDisconnected = /* Constant: StaticTearOffConstant */;
      VMServiceEmbedderHooks::deleteDir = /* Constant: StaticTearOffConstant */;
      VMServiceEmbedderHooks::writeFile = /* Constant: StaticTearOffConstant */;
      VMServiceEmbedderHooks::writeStreamFile = /* Constant: StaticTearOffConstant */;
      VMServiceEmbedderHooks::readFile = /* Constant: StaticTearOffConstant */;
      VMServiceEmbedderHooks::listFiles = /* Constant: StaticTearOffConstant */;
      VMServiceEmbedderHooks::serverInformation = /* Constant: StaticTearOffConstant */;
      VMServiceEmbedderHooks::webServerControl = /* Constant: StaticTearOffConstant */;
      VMServiceEmbedderHooks::acceptNewWebSocketConnections = /* Constant: StaticTearOffConstant */;
      VMServiceEmbedderHooks::serveObservatory = /* Constant: StaticTearOffConstant */;
      VMServiceEmbedderHooks::getResidentCompilerInfoFile = /* Constant: StaticTearOffConstant */;
      server = ObjectPtr<Server>(new Server(VMService::(), _ip, _port, _originCheckDisabled, _authCodesDisabled, _serviceInfoFilename, _enableServicePortFallback));
      if (_autoStart) {
      _toggleWebServer();
}
      _registerSignalHandler();
}
    return 0;
  } catch (const std::exception& e) {
    std::cerr << "Error: " << e.what() << std::endl;
    return 1;
  }
}
