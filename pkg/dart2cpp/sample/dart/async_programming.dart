/// 异步编程测试用例
/// 
/// 测试Dart异步编程特性，包括：
/// - Future 基础操作
/// - async/await 语法
/// - Stream 流处理
/// - 异步异常处理
/// - 定时器和延迟

import 'dart:async';

void main() async {
  print('🔥 异步编程测试开始');
  
  // 1. Future 基础测试
  await testFutureBasics();
  
  // 2. async/await 测试
  await testAsyncAwait();
  
  // 3. Future 组合测试
  await testFutureCombination();
  
  // 4. 异步错误处理测试
  await testAsyncErrorHandling();
  
  // 5. Stream 测试
  await testStreamBasics();
  
  // 6. Stream 转换测试
  await testStreamTransformation();
  
  // 7. 定时器测试
  await testTimers();
  
  print('✅ 异步编程测试完成');
}

/// 测试 Future 基础
Future<void> testFutureBasics() async {
  print('\n📌 测试 Future 基础');
  
  // 创建立即完成的 Future
  Future<String> immediateFuture = Future.value('立即完成');
  String result1 = await immediateFuture;
  print('  立即Future: $result1');
  
  // 创建延迟的 Future
  Future<String> delayedFuture = Future.delayed(
    Duration(milliseconds: 100),
    () => '延迟完成'
  );
  String result2 = await delayedFuture;
  print('  延迟Future: $result2');
  
  // 使用 then 和 catchError
  await Future.delayed(Duration(milliseconds: 50))
      .then((_) => print('  then: 延迟操作完成'))
      .catchError((error) => print('  catchError: $error'));
  
  // Future.sync
  Future<int> syncFuture = Future.sync(() => 42);
  int result3 = await syncFuture;
  print('  同步Future: $result3');
  
  // Completer
  Completer<String> completer = Completer<String>();
  
  // 异步完成 completer
  Timer(Duration(milliseconds: 50), () {
    completer.complete('Completer完成');
  });
  
  String result4 = await completer.future;
  print('  Completer: $result4');
  
  // Future 状态检查
  Future<int> pendingFuture = Future.delayed(Duration(milliseconds: 100), () => 123);
  print('  Future创建后立即检查完成状态');
  
  int pendingResult = await pendingFuture;
  print('  等待后的结果: $pendingResult');
}

/// 测试 async/await
Future<void> testAsyncAwait() async {
  print('\n📌 测试 async/await');
  
  // 基本 async 函数
  String greeting = await getGreeting('Alice');
  print('  问候: $greeting');
  
  // 多个异步操作（串行）
  print('  开始串行异步操作...');
  String result1 = await fetchData('数据1', 100);
  String result2 = await fetchData('数据2', 150);
  String result3 = await fetchData('数据3', 80);
  
  print('  串行结果1: $result1');
  print('  串行结果2: $result2');
  print('  串行结果3: $result3');
  
  // 并行执行
  print('  开始并行异步操作...');
  List<Future<String>> futures = [
    fetchData('并行数据1', 100),
    fetchData('并行数据2', 150),
    fetchData('并行数据3', 80),
  ];
  
  List<String> results = await Future.wait(futures);
  print('  并行结果: $results');
  
  // 嵌套 async 调用
  String nestedResult = await processNestedAsync();
  print('  嵌套异步结果: $nestedResult');
}

/// 测试 Future 组合
Future<void> testFutureCombination() async {
  print('\n📌 测试 Future 组合');
  
  // Future.wait - 等待所有完成
  List<Future<int>> numberFutures = [
    Future.delayed(Duration(milliseconds: 100), () => 1),
    Future.delayed(Duration(milliseconds: 150), () => 2),
    Future.delayed(Duration(milliseconds: 80), () => 3),
  ];
  
  List<int> numbers = await Future.wait(numberFutures);
  print('  Future.wait: $numbers');
  
  // Future.any - 等待任意一个完成
  Future<String> anyResult = Future.any([
    Future.delayed(Duration(milliseconds: 200), () => '慢的'),
    Future.delayed(Duration(milliseconds: 100), () => '快的'),
    Future.delayed(Duration(milliseconds: 300), () => '最慢的'),
  ]);
  
  String firstResult = await anyResult;
  print('  Future.any: $firstResult');
  
  // 链式调用
  String chainResult = await Future.value(5)
      .then((value) => value * 2)
      .then((value) => 'Result: $value')
      .then((text) => text.toUpperCase());
  
  print('  链式调用: $chainResult');
  
  // Future.forEach - 串行处理
  List<String> items = ['A', 'B', 'C'];
  print('  Future.forEach 处理:');
  await Future.forEach(items, (String item) async {
    await Future.delayed(Duration(milliseconds: 50));
    print('    处理项目: $item');
  });
  
  // 条件 Future
  bool condition = true;
  String conditionalResult = await (condition 
      ? Future.value('条件为真') 
      : Future.value('条件为假'));
  print('  条件Future: $conditionalResult');
}

/// 测试异步错误处理
Future<void> testAsyncErrorHandling() async {
  print('\n📌 测试异步错误处理');
  
  // try-catch 处理异步错误
  try {
    await riskyOperation(true);
  } catch (e) {
    print('  捕获异常: $e');
  }
  
  // Future.catchError
  String recoveredValue = await riskyOperation(true)
      .catchError((error) {
        print('  Future.catchError: $error');
        return '错误恢复值';
      });
  print('  恢复后的值: $recoveredValue');
  
  // 超时处理
  try {
    String result = await slowOperation().timeout(Duration(milliseconds: 100));
    print('  操作结果: $result');
  } on TimeoutException {
    print('  操作超时');
  } catch (e) {
    print('  其他异常: $e');
  }
  
  // Future.onError
  String errorHandledValue = await Future.error('测试错误')
      .onError<String>((error, stackTrace) {
        print('  onError处理: $error');
        return '默认值';
      });
  print('  最终值: $errorHandledValue');
  
  // 异步异常传播
  try {
    await cascadingAsyncError();
  } catch (e) {
    print('  级联异常: $e');
  }
}

/// 测试 Stream 基础
Future<void> testStreamBasics() async {
  print('\n📌 测试 Stream 基础');
  
  // 从列表创建 Stream
  Stream<int> numberStream = Stream.fromIterable([1, 2, 3, 4, 5]);
  
  print('  从列表创建的Stream:');
  await for (int number in numberStream) {
    print('    数字: $number');
  }
  
  // 周期性 Stream
  print('  周期性Stream (3次):');
  Stream<int> periodicStream = Stream.periodic(
    Duration(milliseconds: 100),
    (count) => count
  ).take(3);
  
  await for (int count in periodicStream) {
    print('    计数: $count');
  }
  
  // 自定义 Stream
  print('  自定义Stream:');
  Stream<String> customStream = generateMessages();
  await for (String message in customStream) {
    print('    消息: $message');
  }
  
  // Stream 监听
  print('  Stream监听:');
  Stream<int> listenStream = Stream.fromIterable([10, 20, 30]);
  
  StreamSubscription<int> subscription = listenStream.listen(
    (data) => print('    监听到数据: $data'),
    onError: (error) => print('    监听到错误: $error'),
    onDone: () => print('    Stream完成'),
  );
  
  // 等待监听完成
  await subscription.asFuture();
  
  // Stream Controller
  print('  StreamController:');
  StreamController<String> controller = StreamController<String>();
  
  // 监听 controller 的 stream
  StreamSubscription<String> controllerSub = controller.stream.listen(
    (data) => print('    Controller数据: $data'),
  );
  
  // 添加数据
  controller.add('消息1');
  controller.add('消息2');
  controller.add('消息3');
  
  // 等待处理完成
  await Future.delayed(Duration(milliseconds: 50));
  
  // 关闭 controller
  await controller.close();
  await controllerSub.cancel();
}

/// 测试 Stream 转换
Future<void> testStreamTransformation() async {
  print('\n📌 测试 Stream 转换');
  
  Stream<int> sourceStream = Stream.fromIterable([1, 2, 3, 4, 5, 6, 7, 8, 9, 10]);
  
  // map 转换
  Stream<String> mappedStream = sourceStream.map((n) => 'Number: $n');
  print('  map转换:');
  await for (String item in mappedStream.take(3)) {
    print('    $item');
  }
  
  // where 过滤
  Stream<int> evenStream = Stream.fromIterable([1, 2, 3, 4, 5, 6, 7, 8, 9, 10])
      .where((n) => n % 2 == 0);
  print('  where过滤 (偶数):');
  await for (int even in evenStream) {
    print('    $even');
  }
  
  // expand 展开
  Stream<int> expandedStream = Stream.fromIterable([1, 2, 3])
      .expand((n) => [n, n * 10]);
  print('  expand展开:');
  await for (int expanded in expandedStream) {
    print('    $expanded');
  }
  
  // take 和 skip
  Stream<int> numberStream = Stream.fromIterable([1, 2, 3, 4, 5, 6, 7, 8, 9, 10]);
  
  print('  take前3个:');
  await for (int number in numberStream.take(3)) {
    print('    $number');
  }
  
  print('  skip前3个:');
  Stream<int> skippedStream = Stream.fromIterable([1, 2, 3, 4, 5, 6, 7, 8, 9, 10]);
  await for (int number in skippedStream.skip(3).take(3)) {
    print('    $number');
  }
  
  // distinct 去重
  Stream<int> duplicateStream = Stream.fromIterable([1, 2, 2, 3, 3, 3, 4, 4, 5]);
  print('  distinct去重:');
  await for (int unique in duplicateStream.distinct()) {
    print('    $unique');
  }
}

/// 测试定时器
Future<void> testTimers() async {
  print('\n📌 测试定时器');
  
  // 一次性定时器
  print('  一次性定时器 (100ms后执行):');
  Completer<void> timerCompleter = Completer<void>();
  
  Timer(Duration(milliseconds: 100), () {
    print('    定时器触发！');
    timerCompleter.complete();
  });
  
  await timerCompleter.future;
  
  // 周期性定时器
  print('  周期性定时器 (每50ms执行，共3次):');
  int count = 0;
  Completer<void> periodicCompleter = Completer<void>();
  
  Timer.periodic(Duration(milliseconds: 50), (timer) {
    count++;
    print('    周期执行第${count}次');
    
    if (count >= 3) {
      timer.cancel();
      periodicCompleter.complete();
    }
  });
  
  await periodicCompleter.future;
  
  // 延迟执行
  print('  延迟执行:');
  await Future.delayed(Duration(milliseconds: 100), () {
    print('    延迟100ms后执行');
  });
  
  // 微任务
  print('  微任务调度:');
  scheduleMicrotask(() {
    print('    微任务执行');
  });
  
  // 等待微任务完成
  await Future.delayed(Duration(milliseconds: 10));
}

// ============================================================================
// 辅助函数定义
// ============================================================================

/// 获取问候语
Future<String> getGreeting(String name) async {
  await Future.delayed(Duration(milliseconds: 50));
  return 'Hello, $name!';
}

/// 获取数据
Future<String> fetchData(String name, int delayMs) async {
  await Future.delayed(Duration(milliseconds: delayMs));
  return '$name (延迟${delayMs}ms)';
}

/// 嵌套异步处理
Future<String> processNestedAsync() async {
  String step1 = await Future.delayed(Duration(milliseconds: 50), () => 'Step1');
  String step2 = await Future.delayed(Duration(milliseconds: 50), () => 'Step2');
  String step3 = await Future.delayed(Duration(milliseconds: 50), () => 'Step3');
  
  return '$step1 -> $step2 -> $step3';
}

/// 有风险的操作
Future<String> riskyOperation(bool shouldFail) async {
  await Future.delayed(Duration(milliseconds: 50));
  
  if (shouldFail) {
    throw Exception('操作失败');
  }
  
  return '操作成功';
}

/// 慢操作
Future<String> slowOperation() async {
  await Future.delayed(Duration(milliseconds: 200));
  return '慢操作完成';
}

/// 级联异步错误
Future<void> cascadingAsyncError() async {
  await Future.delayed(Duration(milliseconds: 50));
  await riskyOperation(true); // 这会抛出异常
}

/// 生成消息流
Stream<String> generateMessages() async* {
  for (int i = 1; i <= 3; i++) {
    await Future.delayed(Duration(milliseconds: 100));
    yield 'Message $i';
  }
}

/// 生成数字流
Stream<int> generateNumbers(int count) async* {
  for (int i = 0; i < count; i++) {
    await Future.delayed(Duration(milliseconds: 100));
    yield i;
  }
}
