#include "dart2cpp.h"

// 工具宏定义

ObjectPtr<Future<Nullable>> testFutureBasics();
ObjectPtr<Future<Nullable>> testAsyncAwait();
ObjectPtr<Future<Nullable>> testFutureCombination();
ObjectPtr<Future<Nullable>> testAsyncErrorHandling();
ObjectPtr<Future<Nullable>> testStreamBasics();
ObjectPtr<Future<Nullable>> testStreamTransformation();
ObjectPtr<Future<Nullable>> testTimers();
ObjectPtr<Future<String>> getGreeting(String name);
ObjectPtr<Future<String>> fetchData(String name, Int delayMs);
ObjectPtr<Future<String>> processNestedAsync();
ObjectPtr<Future<String>> riskyOperation(Bool shouldFail);
ObjectPtr<Future<String>> slowOperation();
ObjectPtr<Future<Nullable>> cascadingAsyncError();
ObjectPtr<Stream<String>> generateMessages();
ObjectPtr<Stream<Int>> generateNumbers(Int count);
DART_ASYNC_FUNCTION(ObjectPtr<Future<Nullable>>, testFutureBasics, ()) {
    DART_ASYNC_BEGIN
  dart_print(dart_string("\n📌 测试 Future 基础"));
auto immediateFuture = Future::value(dart_string("立即完成"));
auto result1 = DART_AWAIT(immediateFuture);
dart_print(dart_string("  立即Future: ") + (result1).toString());
auto delayedFuture = Future::delayed(ObjectPtr<Duration>(new Duration(Int(Null), Int(Null), Int(Null), Int(Null), dart_int(100), Int(Null))), makeFunction([&]() { return dart_string("延迟完成"); }));
auto result2 = DART_AWAIT(delayedFuture);
dart_print(dart_string("  延迟Future: ") + (result2).toString());
DART_AWAIT(Future::delayed(ObjectPtr<Duration>(new Duration(Int(Null), Int(Null), Int(Null), Int(Null), dart_int(50), Int(Null))), std::function<Any()>(Null))->then(makeFunction([&](Any _) { return dart_print(dart_string("  then: 延迟操作完成")); }))->catchError(makeFunction([&](Any error) { return dart_print(dart_string("  catchError: ") + (error).toString()); })));
auto syncFuture = Future::sync(makeFunction([&]() { return dart_int(42); }));
auto result3 = DART_AWAIT(syncFuture);
dart_print(dart_string("  同步Future: ") + (result3).toString());
auto completer = Completer::();
Timer::(ObjectPtr<Duration>(new Duration(Int(Null), Int(Null), Int(Null), Int(Null), dart_int(50), Int(Null))), makeFunction([&]() { completer->complete(dart_string("Completer完成")); }));
auto result4 = DART_AWAIT(completer->future());
dart_print(dart_string("  Completer: ") + (result4).toString());
auto pendingFuture = Future::delayed(ObjectPtr<Duration>(new Duration(Int(Null), Int(Null), Int(Null), Int(Null), dart_int(100), Int(Null))), makeFunction([&]() { return dart_int(123); }));
dart_print(dart_string("  Future创建后立即检查完成状态"));
auto pendingResult = DART_AWAIT(pendingFuture);
dart_print(dart_string("  等待后的结果: ") + (pendingResult).toString());
    DART_ASYNC_END
}

DART_ASYNC_FUNCTION(ObjectPtr<Future<Nullable>>, testAsyncAwait, ()) {
    DART_ASYNC_BEGIN
  dart_print(dart_string("\n📌 测试 async/await"));
auto greeting = DART_AWAIT(getGreeting(dart_string("Alice")));
dart_print(dart_string("  问候: ") + (greeting).toString());
dart_print(dart_string("  开始串行异步操作..."));
auto result1 = DART_AWAIT(fetchData(dart_string("数据1"), dart_int(100)));
auto result2 = DART_AWAIT(fetchData(dart_string("数据2"), dart_int(150)));
auto result3 = DART_AWAIT(fetchData(dart_string("数据3"), dart_int(80)));
dart_print(dart_string("  串行结果1: ") + (result1).toString());
dart_print(dart_string("  串行结果2: ") + (result2).toString());
dart_print(dart_string("  串行结果3: ") + (result3).toString());
dart_print(dart_string("  开始并行异步操作..."));
auto futures = dart_literal(fetchData(dart_string("并行数据1"), dart_int(100)), fetchData(dart_string("并行数据2"), dart_int(150)), fetchData(dart_string("并行数据3"), dart_int(80)));
auto results = DART_AWAIT(Future::wait(futures, Bool(Null), std::function<Nullable(T)>(Null)));
dart_print(dart_string("  并行结果: ") + (results).toString());
auto nestedResult = DART_AWAIT(processNestedAsync());
dart_print(dart_string("  嵌套异步结果: ") + (nestedResult).toString());
    DART_ASYNC_END
}

DART_ASYNC_FUNCTION(ObjectPtr<Future<Nullable>>, testFutureCombination, ()) {
    DART_ASYNC_BEGIN
  dart_print(dart_string("\n📌 测试 Future 组合"));
auto numberFutures = dart_literal(Future::delayed(ObjectPtr<Duration>(new Duration(Int(Null), Int(Null), Int(Null), Int(Null), dart_int(100), Int(Null))), makeFunction([&]() { return dart_int(1); })), Future::delayed(ObjectPtr<Duration>(new Duration(Int(Null), Int(Null), Int(Null), Int(Null), dart_int(150), Int(Null))), makeFunction([&]() { return dart_int(2); })), Future::delayed(ObjectPtr<Duration>(new Duration(Int(Null), Int(Null), Int(Null), Int(Null), dart_int(80), Int(Null))), makeFunction([&]() { return dart_int(3); })));
auto numbers = DART_AWAIT(Future::wait(numberFutures, Bool(Null), std::function<Nullable(T)>(Null)));
dart_print(dart_string("  Future.wait: ") + (numbers).toString());
auto anyResult = Future::any(dart_literal(Future::delayed(ObjectPtr<Duration>(new Duration(Int(Null), Int(Null), Int(Null), Int(Null), dart_int(200), Int(Null))), makeFunction([&]() { return dart_string("慢的"); })), Future::delayed(ObjectPtr<Duration>(new Duration(Int(Null), Int(Null), Int(Null), Int(Null), dart_int(100), Int(Null))), makeFunction([&]() { return dart_string("快的"); })), Future::delayed(ObjectPtr<Duration>(new Duration(Int(Null), Int(Null), Int(Null), Int(Null), dart_int(300), Int(Null))), makeFunction([&]() { return dart_string("最慢的"); }))));
auto firstResult = DART_AWAIT(anyResult);
dart_print(dart_string("  Future.any: ") + (firstResult).toString());
auto chainResult = DART_AWAIT(Future::value(dart_int(5))->then(makeFunction([&](Int value) { return (value * dart_int(2)); }))->then(makeFunction([&](Int value) { return dart_string("Result: ") + (value).toString(); }))->then(makeFunction([&](String text) { return text->toUpperCase(); })));
dart_print(dart_string("  链式调用: ") + (chainResult).toString());
auto items = dart_literal(dart_string("A"), dart_string("B"), dart_string("C"));
dart_print(dart_string("  Future.forEach 处理:"));
DART_AWAIT(Future::forEach(items, makeFunction([&](String item) { DART_AWAIT(Future::delayed(ObjectPtr<Duration>(new Duration(Int(Null), Int(Null), Int(Null), Int(Null), dart_int(50), Int(Null))), std::function<Any()>(Null)));
dart_print(dart_string("    处理项目: ") + (item).toString()); })));
auto condition = dart_bool(true);
auto conditionalResult = DART_AWAIT(condition ? Future::value(dart_string("条件为真")) : Future::value(dart_string("条件为假")));
dart_print(dart_string("  条件Future: ") + (conditionalResult).toString());
    DART_ASYNC_END
}

DART_ASYNC_FUNCTION(ObjectPtr<Future<Nullable>>, testAsyncErrorHandling, ()) {
    DART_ASYNC_BEGIN
  dart_print(dart_string("\n📌 测试异步错误处理"));
try DART_AWAIT(riskyOperation(dart_bool(true))); catch (const std::exception& e) { /* catch block */ }
// Finally block should be implemented using RAII pattern
auto recoveredValue = DART_AWAIT(riskyOperation(dart_bool(true))->catchError(makeFunction([&](Any error) { dart_print(dart_string("  Future.catchError: ") + (error).toString());
return dart_string("错误恢复值"); })));
dart_print(dart_string("  恢复后的值: ") + (recoveredValue).toString());
try auto result = DART_AWAIT(slowOperation()->timeout(ObjectPtr<Duration>(new Duration(Int(Null), Int(Null), Int(Null), Int(Null), dart_int(100), Int(Null)))));
dart_print(dart_string("  操作结果: ") + (result).toString()); catch (const std::exception& e) { /* catch block */ } catch (const std::exception& e) { /* catch block */ }
// Finally block should be implemented using RAII pattern
auto errorHandledValue = dart_cast<String>(DART_AWAIT(FutureExtensions|onError(Future::error(dart_string("测试错误"), nullptr), makeFunction([&](String error, ObjectPtr<StackTrace> stackTrace) { dart_print(dart_string("  onError处理: ") + (error).toString());
return dart_string("默认值"); }), std::function<Bool(E)>(Null))));
dart_print(dart_string("  最终值: ") + (errorHandledValue).toString());
try DART_AWAIT(cascadingAsyncError()); catch (const std::exception& e) { /* catch block */ }
// Finally block should be implemented using RAII pattern
    DART_ASYNC_END
}

DART_ASYNC_FUNCTION(ObjectPtr<Future<Nullable>>, testStreamBasics, ()) {
    DART_ASYNC_BEGIN
  dart_print(dart_string("\n📌 测试 Stream 基础"));
auto numberStream = Stream::fromIterable(dart_literal(dart_int(1), dart_int(2), dart_int(3), dart_int(4), dart_int(5)));
dart_print(dart_string("  从列表创建的Stream:"));
auto stream = numberStream;
auto for_iterator = ObjectPtr<_StreamIterator>(new _StreamIterator(stream));
try { /* try block */ } catch (const std::exception& e) { /* catch block */ }
dart_print(dart_string("  周期性Stream (3次):"));
auto periodicStream = Stream::periodic(ObjectPtr<Duration>(new Duration(Int(Null), Int(Null), Int(Null), Int(Null), dart_int(100), Int(Null))), makeFunction([&](Int count) { return count; }))->take(dart_int(3));
auto stream = periodicStream;
auto for_iterator = ObjectPtr<_StreamIterator>(new _StreamIterator(stream));
try { /* try block */ } catch (const std::exception& e) { /* catch block */ }
dart_print(dart_string("  自定义Stream:"));
auto customStream = generateMessages();
auto stream = customStream;
auto for_iterator = ObjectPtr<_StreamIterator>(new _StreamIterator(stream));
try { /* try block */ } catch (const std::exception& e) { /* catch block */ }
dart_print(dart_string("  Stream监听:"));
auto listenStream = Stream::fromIterable(dart_literal(dart_int(10), dart_int(20), dart_int(30)));
auto subscription = listenStream->listen(makeFunction([&](Int data) { return dart_print(dart_string("    监听到数据: ") + (data).toString()); }));
DART_AWAIT(subscription->asFuture());
dart_print(dart_string("  StreamController:"));
auto controller = StreamController::(std::function<Nullable()>(Null), std::function<Nullable()>(Null), std::function<Nullable()>(Null), std::function<Any()>(Null), Bool(Null));
auto controllerSub = controller->stream()->listen(makeFunction([&](String data) { return dart_print(dart_string("    Controller数据: ") + (data).toString()); }));
controller->add(dart_string("消息1"));
controller->add(dart_string("消息2"));
controller->add(dart_string("消息3"));
DART_AWAIT(Future::delayed(ObjectPtr<Duration>(new Duration(Int(Null), Int(Null), Int(Null), Int(Null), dart_int(50), Int(Null))), std::function<Any()>(Null)));
DART_AWAIT(controller->close());
DART_AWAIT(controllerSub->cancel());
    DART_ASYNC_END
}

DART_ASYNC_FUNCTION(ObjectPtr<Future<Nullable>>, testStreamTransformation, ()) {
    DART_ASYNC_BEGIN
  dart_print(dart_string("\n📌 测试 Stream 转换"));
auto sourceStream = Stream::fromIterable(List<Int>::createFromValues({dart_int(1), dart_int(2), dart_int(3), dart_int(4), dart_int(5), dart_int(6), dart_int(7), dart_int(8), dart_int(9), dart_int(10)}));
auto mappedStream = sourceStream->map(makeFunction([&](Int n) { return dart_string("Number: ") + (n).toString(); }));
dart_print(dart_string("  map转换:"));
auto stream = mappedStream->take(dart_int(3));
auto for_iterator = ObjectPtr<_StreamIterator>(new _StreamIterator(stream));
try { /* try block */ } catch (const std::exception& e) { /* catch block */ }
auto evenStream = Stream::fromIterable(List<Int>::createFromValues({dart_int(1), dart_int(2), dart_int(3), dart_int(4), dart_int(5), dart_int(6), dart_int(7), dart_int(8), dart_int(9), dart_int(10)}))->where(makeFunction([&](Int n) { return ((n % dart_int(2)) == dart_int(0)); }));
dart_print(dart_string("  where过滤 (偶数):"));
auto stream = evenStream;
auto for_iterator = ObjectPtr<_StreamIterator>(new _StreamIterator(stream));
try { /* try block */ } catch (const std::exception& e) { /* catch block */ }
auto expandedStream = Stream::fromIterable(dart_literal(dart_int(1), dart_int(2), dart_int(3)))->expand(makeFunction([&](Int n) { return dart_literal(n, (n * dart_int(10))); }));
dart_print(dart_string("  expand展开:"));
auto stream = expandedStream;
auto for_iterator = ObjectPtr<_StreamIterator>(new _StreamIterator(stream));
try { /* try block */ } catch (const std::exception& e) { /* catch block */ }
auto numberStream = Stream::fromIterable(List<Int>::createFromValues({dart_int(1), dart_int(2), dart_int(3), dart_int(4), dart_int(5), dart_int(6), dart_int(7), dart_int(8), dart_int(9), dart_int(10)}));
dart_print(dart_string("  take前3个:"));
auto stream = numberStream->take(dart_int(3));
auto for_iterator = ObjectPtr<_StreamIterator>(new _StreamIterator(stream));
try { /* try block */ } catch (const std::exception& e) { /* catch block */ }
dart_print(dart_string("  skip前3个:"));
auto skippedStream = Stream::fromIterable(List<Int>::createFromValues({dart_int(1), dart_int(2), dart_int(3), dart_int(4), dart_int(5), dart_int(6), dart_int(7), dart_int(8), dart_int(9), dart_int(10)}));
auto stream = skippedStream->skip(dart_int(3))->take(dart_int(3));
auto for_iterator = ObjectPtr<_StreamIterator>(new _StreamIterator(stream));
try { /* try block */ } catch (const std::exception& e) { /* catch block */ }
auto duplicateStream = Stream::fromIterable(List<Int>::createFromValues({dart_int(1), dart_int(2), dart_int(2), dart_int(3), dart_int(3), dart_int(3), dart_int(4), dart_int(4), dart_int(5)}));
dart_print(dart_string("  distinct去重:"));
auto stream = duplicateStream->distinct();
auto for_iterator = ObjectPtr<_StreamIterator>(new _StreamIterator(stream));
try { /* try block */ } catch (const std::exception& e) { /* catch block */ }
    DART_ASYNC_END
}

DART_ASYNC_FUNCTION(ObjectPtr<Future<Nullable>>, testTimers, ()) {
    DART_ASYNC_BEGIN
  dart_print(dart_string("\n📌 测试定时器"));
dart_print(dart_string("  一次性定时器 (100ms后执行):"));
auto timerCompleter = Completer::();
Timer::(ObjectPtr<Duration>(new Duration(Int(Null), Int(Null), Int(Null), Int(Null), dart_int(100), Int(Null))), makeFunction([&]() { dart_print(dart_string("    定时器触发！"));
timerCompleter->complete(); }));
DART_AWAIT(timerCompleter->future());
dart_print(dart_string("  周期性定时器 (每50ms执行，共3次):"));
auto count = dart_int(0);
auto periodicCompleter = Completer::();
Timer::periodic(ObjectPtr<Duration>(new Duration(Int(Null), Int(Null), Int(Null), Int(Null), dart_int(50), Int(Null))), makeFunction([&](ObjectPtr<Timer> timer) { count = (count + dart_int(1));
dart_print(dart_concat(dart_string("    周期执行第"), (count).toString(), dart_string("次")));
if ((count >= dart_int(3))) {
timer->cancel();
periodicCompleter->complete();
} }));
DART_AWAIT(periodicCompleter->future());
dart_print(dart_string("  延迟执行:"));
DART_AWAIT(Future::delayed(ObjectPtr<Duration>(new Duration(Int(Null), Int(Null), Int(Null), Int(Null), dart_int(100), Int(Null))), makeFunction([&]() { dart_print(dart_string("    延迟100ms后执行")); })));
dart_print(dart_string("  微任务调度:"));
scheduleMicrotask(makeFunction([&]() { dart_print(dart_string("    微任务执行")); }));
DART_AWAIT(Future::delayed(ObjectPtr<Duration>(new Duration(Int(Null), Int(Null), Int(Null), Int(Null), dart_int(10), Int(Null))), std::function<Any()>(Null)));
    DART_ASYNC_END
}

DART_ASYNC_FUNCTION(ObjectPtr<Future<String>>, getGreeting, (String name)) {
    DART_ASYNC_BEGIN
  DART_AWAIT(Future::delayed(ObjectPtr<Duration>(new Duration(Int(Null), Int(Null), Int(Null), Int(Null), dart_int(50), Int(Null))), std::function<Any()>(Null)));
return dart_concat(dart_string("Hello, "), (name).toString(), dart_string("!"));
    DART_ASYNC_END
}

DART_ASYNC_FUNCTION(ObjectPtr<Future<String>>, fetchData, (String name, Int delayMs)) {
    DART_ASYNC_BEGIN
  DART_AWAIT(Future::delayed(ObjectPtr<Duration>(new Duration(Int(Null), Int(Null), Int(Null), Int(Null), delayMs, Int(Null))), std::function<Any()>(Null)));
return dart_concat((name).toString(), dart_string(" (延迟"), (delayMs).toString(), dart_string("ms)"));
    DART_ASYNC_END
}

DART_ASYNC_FUNCTION(ObjectPtr<Future<String>>, processNestedAsync, ()) {
    DART_ASYNC_BEGIN
  auto step1 = DART_AWAIT(Future::delayed(ObjectPtr<Duration>(new Duration(Int(Null), Int(Null), Int(Null), Int(Null), dart_int(50), Int(Null))), makeFunction([&]() { return dart_string("Step1"); })));
auto step2 = DART_AWAIT(Future::delayed(ObjectPtr<Duration>(new Duration(Int(Null), Int(Null), Int(Null), Int(Null), dart_int(50), Int(Null))), makeFunction([&]() { return dart_string("Step2"); })));
auto step3 = DART_AWAIT(Future::delayed(ObjectPtr<Duration>(new Duration(Int(Null), Int(Null), Int(Null), Int(Null), dart_int(50), Int(Null))), makeFunction([&]() { return dart_string("Step3"); })));
return dart_concat((step1).toString(), dart_string(" -> "), (step2).toString(), dart_string(" -> "), (step3).toString());
    DART_ASYNC_END
}

DART_ASYNC_FUNCTION(ObjectPtr<Future<String>>, riskyOperation, (Bool shouldFail)) {
    DART_ASYNC_BEGIN
  DART_AWAIT(Future::delayed(ObjectPtr<Duration>(new Duration(Int(Null), Int(Null), Int(Null), Int(Null), dart_int(50), Int(Null))), std::function<Any()>(Null)));
if (shouldFail) {
throw DartException(Exception::(dart_string("操作失败")));
}
return dart_string("操作成功");
    DART_ASYNC_END
}

DART_ASYNC_FUNCTION(ObjectPtr<Future<String>>, slowOperation, ()) {
    DART_ASYNC_BEGIN
  DART_AWAIT(Future::delayed(ObjectPtr<Duration>(new Duration(Int(Null), Int(Null), Int(Null), Int(Null), dart_int(200), Int(Null))), std::function<Any()>(Null)));
return dart_string("慢操作完成");
    DART_ASYNC_END
}

DART_ASYNC_FUNCTION(ObjectPtr<Future<Nullable>>, cascadingAsyncError, ()) {
    DART_ASYNC_BEGIN
  DART_AWAIT(Future::delayed(ObjectPtr<Duration>(new Duration(Int(Null), Int(Null), Int(Null), Int(Null), dart_int(50), Int(Null))), std::function<Any()>(Null)));
DART_AWAIT(riskyOperation(dart_bool(true)));
    DART_ASYNC_END
}

DART_ASYNC_FUNCTION(ObjectPtr<Stream<String>>, generateMessages, ()) {
    DART_ASYNC_BEGIN
  for (auto i = dart_int(1); (i <= dart_int(3)); ++i) {
DART_AWAIT(Future::delayed(ObjectPtr<Duration>(new Duration(Int(Null), Int(Null), Int(Null), Int(Null), dart_int(100), Int(Null))), std::function<Any()>(Null)));
co_yield dart_string("Message ") + (i).toString();  // C++20 coroutine
}
    DART_ASYNC_END
}

DART_ASYNC_FUNCTION(ObjectPtr<Stream<Int>>, generateNumbers, (Int count)) {
    DART_ASYNC_BEGIN
  for (auto i = dart_int(0); (i < count); ++i) {
DART_AWAIT(Future::delayed(ObjectPtr<Duration>(new Duration(Int(Null), Int(Null), Int(Null), Int(Null), dart_int(100), Int(Null))), std::function<Any()>(Null)));
co_yield i;  // C++20 coroutine
}
    DART_ASYNC_END
}

// ============================================================================
// 主函数
// ============================================================================

int main() {
  try {
    dart_print(dart_string("🔥 异步编程测试开始"));
DART_AWAIT(testFutureBasics());
DART_AWAIT(testAsyncAwait());
DART_AWAIT(testFutureCombination());
DART_AWAIT(testAsyncErrorHandling());
DART_AWAIT(testStreamBasics());
DART_AWAIT(testStreamTransformation());
DART_AWAIT(testTimers());
dart_print(dart_string("✅ 异步编程测试完成"));
    return 0;
  } catch (const std::exception& e) {
    std::cerr << "Error: " << e.what() << std::endl;
    return 1;
  }
}
