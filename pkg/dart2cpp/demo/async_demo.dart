/// 异步编程演示
/// 
/// 测试 Future, async/await, Stream 等异步编程特性

import 'dart:async';

void main() async {
  print('🔥 异步编程演示开始');
  
  // 1. Future 基础
  await testFutureBasics();
  
  // 2. async/await
  await testAsyncAwait();
  
  // 3. Future 组合
  await testFutureCombination();
  
  // 4. 错误处理
  await testErrorHandling();
  
  // 5. Stream 基础
  await testStreamBasics();
  
  // 6. Stream 转换
  await testStreamTransformation();
  
  // 7. 定时器
  await testTimers();
  
  print('✅ 异步编程演示完成');
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
}

/// 测试 async/await
Future<void> testAsyncAwait() async {
  print('\n📌 测试 async/await');
  
  // 基本 async 函数
  String greeting = await getGreeting('Alice');
  print('  问候: $greeting');
  
  // 多个异步操作
  print('  开始多个异步操作...');
  String result1 = await fetchData('数据1', 100);
  String result2 = await fetchData('数据2', 150);
  String result3 = await fetchData('数据3', 80);
  
  print('  结果1: $result1');
  print('  结果2: $result2');
  print('  结果3: $result3');
  
  // 并行执行
  print('  开始并行异步操作...');
  List<Future<String>> futures = [
    fetchData('并行数据1', 100),
    fetchData('并行数据2', 150),
    fetchData('并行数据3', 80),
  ];
  
  List<String> results = await Future.wait(futures);
  print('  并行结果: $results');
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
  
  // Future.forEach
  List<String> items = ['A', 'B', 'C'];
  await Future.forEach(items, (String item) async {
    await Future.delayed(Duration(milliseconds: 50));
    print('  处理项目: $item');
  });
}

/// 测试错误处理
Future<void> testErrorHandling() async {
  print('\n📌 测试错误处理');
  
  // try-catch 处理异步错误
  try {
    await riskyOperation(true);
  } catch (e) {
    print('  捕获异常: $e');
  }
  
  // Future.catchError
  await riskyOperation(true)
      .catchError((error) {
        print('  Future.catchError: $error');
        return '错误恢复值';
      })
      .then((value) => print('  恢复后的值: $value'));
  
  // 超时处理
  try {
    String result = await slowOperation().timeout(Duration(milliseconds: 100));
    print('  操作结果: $result');
  } on TimeoutException {
    print('  操作超时');
  }
  
  // Future.onError
  await Future.error('测试错误')
      .onError<String>((error, stackTrace) {
        print('  onError处理: $error');
        return '默认值';
      })
      .then((value) => print('  最终值: $value'));
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
  
  // distinct 去重
  Stream<int> distinctStream = Stream.fromIterable([1, 2, 2, 3, 3, 3, 4])
      .distinct();
  print('  distinct去重:');
  await for (int distinct in distinctStream) {
    print('    $distinct');
  }
  
  // skip 和 take
  Stream<int> skipTakeStream = Stream.fromIterable([1, 2, 3, 4, 5, 6, 7, 8, 9, 10])
      .skip(3)
      .take(4);
  print('  skip(3).take(4):');
  await for (int item in skipTakeStream) {
    print('    $item');
  }
  
  // reduce 和 fold
  int sum = await Stream.fromIterable([1, 2, 3, 4, 5])
      .reduce((a, b) => a + b);
  print('  reduce求和: $sum');
  
  String concatenated = await Stream.fromIterable(['A', 'B', 'C'])
      .fold('', (prev, element) => prev + element);
  print('  fold连接: $concatenated');
}

/// 测试定时器
Future<void> testTimers() async {
  print('\n📌 测试定时器');
  
  // 一次性定时器
  print('  设置一次性定时器 (100ms)');
  Completer<void> timerCompleter = Completer<void>();
  
  Timer(Duration(milliseconds: 100), () {
    print('  一次性定时器触发');
    timerCompleter.complete();
  });
  
  await timerCompleter.future;
  
  // 周期性定时器
  print('  设置周期性定时器 (50ms, 3次)');
  int periodicCount = 0;
  Completer<void> periodicCompleter = Completer<void>();
  
  Timer.periodic(Duration(milliseconds: 50), (timer) {
    periodicCount++;
    print('  周期性定时器触发: $periodicCount');
    
    if (periodicCount >= 3) {
      timer.cancel();
      periodicCompleter.complete();
    }
  });
  
  await periodicCompleter.future;
  
  // 微任务
  print('  添加微任务');
  scheduleMicrotask(() {
    print('  微任务执行');
  });
  
  // 等待微任务完成
  await Future.delayed(Duration.zero);
}

// ============================================================================
// 辅助函数
// ============================================================================

/// 获取问候语
Future<String> getGreeting(String name) async {
  await Future.delayed(Duration(milliseconds: 50));
  return 'Hello, $name!';
}

/// 模拟获取数据
Future<String> fetchData(String dataName, int delayMs) async {
  await Future.delayed(Duration(milliseconds: delayMs));
  return '$dataName (延迟${delayMs}ms)';
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

/// 生成消息的 Stream
Stream<String> generateMessages() async* {
  for (int i = 1; i <= 3; i++) {
    await Future.delayed(Duration(milliseconds: 50));
    yield 'Message $i';
  }
}

/// Stream 控制器示例
class MessageService {
  final StreamController<String> _controller = StreamController<String>();
  
  Stream<String> get messages => _controller.stream;
  
  void sendMessage(String message) {
    _controller.add(message);
  }
  
  void sendError(String error) {
    _controller.addError(error);
  }
  
  void close() {
    _controller.close();
  }
}