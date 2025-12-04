/// 综合测试演示
///
/// 整合所有语法特性的综合测试用例

import 'dart:async';
import 'dart:math' as math;

void main() async {
  print('🚀 Dart2CPP 综合测试开始');
  print('=' * 60);

  // 运行所有测试模块
  await runAllTests();

  print('=' * 60);
  print('✅ 所有测试完成');
}

/// 运行所有测试
Future<void> runAllTests() async {
  final testSuite = TestSuite();

  // 1. 基础语法测试
  await testSuite.runTest('基础语法', () async {
    testBasicSyntax();
  });

  // 2. 面向对象测试
  await testSuite.runTest('面向对象', () async {
    testObjectOriented();
  });

  // 3. 集合操作测试
  await testSuite.runTest('集合操作', () async {
    testCollections();
  });

  // 4. 异步编程测试
  await testSuite.runTest('异步编程', () async {
    await testAsyncProgramming();
  });

  // 5. 泛型测试
  await testSuite.runTest('泛型', () async {
    testGenerics();
  });

  // 6. 异常处理测试
  await testSuite.runTest('异常处理', () async {
    await testExceptionHandling();
  });

  // 7. 高级特性测试
  await testSuite.runTest('高级特性', () async {
    testAdvancedFeatures();
  });

  // 8. 实际应用场景测试
  await testSuite.runTest('应用场景', () async {
    await testRealWorldScenarios();
  });

  // 输出测试结果
  testSuite.printSummary();
}

/// 测试基础语法
void testBasicSyntax() {
  print('  测试变量和类型...');

  // 基本类型
  int intValue = 42;
  double doubleValue = 3.14;
  bool boolValue = true;
  String stringValue = 'Hello, Dart2CPP!';

  assert(intValue == 42);
  assert(doubleValue > 3.0);
  assert(boolValue == true);
  assert(stringValue.contains('Dart2CPP'));

  // 运算符
  assert(intValue + 8 == 50);
  assert(doubleValue * 2 > 6.0);
  assert(!(!boolValue));
  assert(stringValue + ' Test' == 'Hello, Dart2CPP! Test');

  // 控制流
  int sum = 0;
  for (int i = 1; i <= 5; i++) {
    sum += i;
  }
  assert(sum == 15);

  // 条件语句
  String grade = intValue >= 90
      ? 'A'
      : intValue >= 80
          ? 'B'
          : 'C';
  assert(grade == 'C');

  print('    ✓ 基础语法测试通过');
}

/// 测试面向对象
void testObjectOriented() {
  print('  测试面向对象特性...');

  // 基本类
  var person = TestPerson('Alice', 25);
  assert(person.name == 'Alice');
  assert(person.age == 25);

  // 继承
  var student = TestStudent('Bob', 20, 'S001');
  assert(student.name == 'Bob');
  assert(student.studentId == 'S001');
  assert(student.getInfo().contains('Bob'));

  // 接口实现
  var car = TestCar();
  car.start();
  assert(car.isRunning);

  // 抽象类
  var circle = TestCircle(5.0);
  assert(circle.area() > 75.0);

  // 枚举
  var status = TestStatus.active;
  assert(status == TestStatus.active);
  assert(status.index == 1);

  print('    ✓ 面向对象测试通过');
}

/// 测试集合操作
void testCollections() {
  print('  测试集合操作...');

  // List 操作
  List<int> numbers = [1, 2, 3, 4, 5];
  assert(numbers.length == 5);
  assert(numbers.first == 1);
  assert(numbers.last == 5);

  var doubled = numbers.map((n) => n * 2).toList();
  assert(doubled[0] == 2);
  assert(doubled[4] == 10);

  var evens = numbers.where((n) => n % 2 == 0).toList();
  assert(evens.length == 2);

  // Set 操作
  Set<String> fruits = {'apple', 'banana', 'orange'};
  fruits.add('apple'); // 重复元素
  assert(fruits.length == 3);

  // Map 操作
  Map<String, int> scores = {'Alice': 95, 'Bob': 87};
  scores['Charlie'] = 92;
  assert(scores.length == 3);
  assert(scores['Alice'] == 95);

  print('    ✓ 集合操作测试通过');
}

/// 测试异步编程
Future<void> testAsyncProgramming() async {
  print('  测试异步编程...');

  // Future 基础
  String result =
      await Future.delayed(Duration(milliseconds: 10), () => 'Async Result');
  assert(result == 'Async Result');

  // Future 组合
  List<String> results = await Future.wait([
    Future.delayed(Duration(milliseconds: 5), () => 'A'),
    Future.delayed(Duration(milliseconds: 10), () => 'B'),
    Future.delayed(Duration(milliseconds: 15), () => 'C'),
  ]);
  assert(results.length == 3);
  assert(results[0] == 'A');

  // Stream 测试
  List<int> streamResults = [];
  await for (int value in generateNumbers(3)) {
    streamResults.add(value);
  }
  assert(streamResults.length == 3);

  print('    ✓ 异步编程测试通过');
}

/// 测试泛型
void testGenerics() {
  print('  测试泛型...');

  // 泛型类
  var intBox = TestBox<int>(42);
  var stringBox = TestBox<String>('Hello');

  assert(intBox.getValue() == 42);
  assert(stringBox.getValue() == 'Hello');

  // 泛型方法
  assert(identity<int>(100) == 100);
  assert(identity<String>('test') == 'test');

  // 类型约束
  var calculator = TestCalculator<int>();
  assert(calculator.add(5, 3) == 8);

  print('    ✓ 泛型测试通过');
}

/// 测试异常处理
Future<void> testExceptionHandling() async {
  print('  测试异常处理...');

  // 基本异常捕获
  bool caughtException = false;
  try {
    throw Exception('Test exception');
  } catch (e) {
    caughtException = true;
    assert(e.toString().contains('Test exception'));
  }
  assert(caughtException);

  // 自定义异常
  bool caughtCustomException = false;
  try {
    throw TestCustomException('Custom error', 404);
  } on TestCustomException catch (e) {
    caughtCustomException = true;
    assert(e.message == 'Custom error');
    assert(e.code == 404);
  }
  assert(caughtCustomException);

  // 异步异常
  bool caughtAsyncException = false;
  try {
    await throwAsyncException();
  } catch (e) {
    caughtAsyncException = true;
  }
  assert(caughtAsyncException);

  print('    ✓ 异常处理测试通过');
}

/// 测试高级特性
void testAdvancedFeatures() {
  print('  测试高级特性...');

  // 空安全
  String? nullable = null;
  String nonNull = nullable ?? 'default';
  assert(nonNull == 'default');

  nullable = 'value';
  assert(nullable != null);
  assert(nullable!.length == 5);

  // 扩展方法
  assert('hello'.capitalize() == 'Hello');
  assert(5.square() == 25);

  // 类型别名
  TestUserId userId = 12345;
  assert(userId == 12345);

  print('    ✓ 高级特性测试通过');
}

/// 测试实际应用场景
Future<void> testRealWorldScenarios() async {
  print('  测试实际应用场景...');

  // 数据处理管道
  var processor = DataProcessor();
  var result = await processor.processData([1, 2, 3, 4, 5]);
  assert(result.isNotEmpty);

  // 用户管理系统
  var userManager = UserManager();
  var user = userManager.createUser('Alice', 'alice@example.com');
  assert(user.name == 'Alice');
  assert(user.email == 'alice@example.com');

  // 配置管理
  var config = AppConfiguration();
  config.set('debug', true);
  config.set('maxUsers', 100);
  assert(config.get<bool>('debug') == true);
  assert(config.get<int>('maxUsers') == 100);

  // 事件系统
  var eventBus = EventBus();
  bool eventReceived = false;

  eventBus.subscribe<TestEvent>((event) {
    eventReceived = true;
    assert(event.message == 'Test message');
  });

  eventBus.publish(TestEvent('Test message'));
  assert(eventReceived);

  print('    ✓ 应用场景测试通过');
}

// ============================================================================
// 测试框架
// ============================================================================

/// 测试套件
class TestSuite {
  final List<TestResult> _results = [];

  Future<void> runTest(String name, Future<void> Function() test) async {
    print('\n🧪 运行测试: $name');

    final stopwatch = Stopwatch()..start();

    try {
      await test();
      stopwatch.stop();

      _results.add(TestResult(name, true, stopwatch.elapsed));
      print('  ✅ $name 测试通过 (${stopwatch.elapsedMilliseconds}ms)');
    } catch (e, stackTrace) {
      stopwatch.stop();

      _results.add(TestResult(name, false, stopwatch.elapsed, e.toString()));
      print('  ❌ $name 测试失败: $e');
      print('  堆栈跟踪: ${stackTrace.toString().split('\n').take(3).join('\n')}');
    }
  }

  void printSummary() {
    print('\n📊 测试摘要:');

    int passed = _results.where((r) => r.passed).length;
    int failed = _results.length - passed;
    int totalTime =
        _results.fold(0, (sum, r) => sum + r.duration.inMilliseconds);

    print('  总测试数: ${_results.length}');
    print('  通过: $passed');
    print('  失败: $failed');
    print('  总耗时: ${totalTime}ms');

    if (failed > 0) {
      print('\n❌ 失败的测试:');
      for (var result in _results.where((r) => !r.passed)) {
        print('  • ${result.name}: ${result.error}');
      }
    }

    print('\n${failed == 0 ? '🎉 所有测试通过!' : '⚠️ 有测试失败'}');
  }
}

/// 测试结果
class TestResult {
  final String name;
  final bool passed;
  final Duration duration;
  final String? error;

  TestResult(this.name, this.passed, this.duration, [this.error]);
}

// ============================================================================
// 测试用的类定义
// ============================================================================

/// 测试人员类
class TestPerson {
  String name;
  int age;

  TestPerson(this.name, this.age);

  String getInfo() => '$name ($age岁)';
}

/// 测试学生类
class TestStudent extends TestPerson {
  String studentId;

  TestStudent(String name, int age, this.studentId) : super(name, age);

  @override
  String getInfo() => '${super.getInfo()}, ID: $studentId';
}

/// 测试接口
abstract class TestDrivable {
  bool get isRunning;
  void start();
  void stop();
}

/// 测试汽车类
class TestCar implements TestDrivable {
  bool _isRunning = false;

  @override
  bool get isRunning => _isRunning;

  @override
  void start() {
    _isRunning = true;
  }

  @override
  void stop() {
    _isRunning = false;
  }
}

/// 测试抽象形状类
abstract class TestShape {
  double area();
}

/// 测试圆形类
class TestCircle extends TestShape {
  double radius;

  TestCircle(this.radius);

  @override
  double area() => math.pi * radius * radius;
}

/// 测试枚举
enum TestStatus { inactive, active, suspended }

/// 测试泛型盒子
class TestBox<T> {
  T _value;

  TestBox(this._value);

  T getValue() => _value;
  void setValue(T value) => _value = value;
}

/// 测试泛型计算器
class TestCalculator<T extends num> {
  T add(T a, T b) => a + b as T;
  T subtract(T a, T b) => a - b as T;
}

/// 测试自定义异常
class TestCustomException implements Exception {
  final String message;
  final int code;

  TestCustomException(this.message, this.code);

  @override
  String toString() => 'TestCustomException: $message (Code: $code)';
}

/// 测试用户类
class TestUser {
  final String name;
  final String email;
  final DateTime createdAt;

  TestUser(this.name, this.email) : createdAt = DateTime.now();
}

/// 测试事件类
class TestEvent {
  final String message;
  final DateTime timestamp;

  TestEvent(this.message) : timestamp = DateTime.now();
}

// ============================================================================
// 扩展方法
// ============================================================================

extension TestStringExtensions on String {
  String capitalize() {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1);
  }
}

extension TestIntExtensions on int {
  int square() => this * this;
}

// ============================================================================
// 类型别名
// ============================================================================

typedef TestEventHandler<T> = void Function(T event);

// ============================================================================
// 实际应用场景类
// ============================================================================

/// 数据处理器
class DataProcessor {
  Future<List<String>> processData(List<int> input) async {
    await Future.delayed(Duration(milliseconds: 10));

    return input.where((n) => n % 2 == 0).map((n) => 'Processed: $n').toList();
  }
}

/// 用户管理器
class UserManager {
  final List<TestUser> _users = [];

  TestUser createUser(String name, String email) {
    var user = TestUser(name, email);
    _users.add(user);
    return user;
  }

  List<TestUser> getAllUsers() => List.unmodifiable(_users);

  TestUser? findUserByEmail(String email) {
    try {
      return _users.firstWhere((user) => user.email == email);
    } catch (e) {
      return null;
    }
  }
}

/// 应用配置
class AppConfiguration {
  final Map<String, dynamic> _config = {};

  void set<T>(String key, T value) {
    _config[key] = value;
  }

  T? get<T>(String key) {
    var value = _config[key];
    return value is T ? value : null;
  }

  bool has(String key) => _config.containsKey(key);
}

/// 事件总线
class EventBus {
  final Map<Type, List<Function>> _listeners = {};

  void subscribe<T>(TestEventHandler<T> handler) {
    _listeners.putIfAbsent(T, () => []).add(handler);
  }

  void publish<T>(T event) {
    var handlers = _listeners[T];
    if (handlers != null) {
      for (var handler in handlers) {
        handler(event);
      }
    }
  }
}

// ============================================================================
// 辅助函数
// ============================================================================

/// 身份函数
T identity<T>(T value) => value;

/// 生成数字流
Stream<int> generateNumbers(int count) async* {
  for (int i = 0; i < count; i++) {
    await Future.delayed(Duration(milliseconds: 1));
    yield i;
  }
}

/// 抛出异步异常
Future<void> throwAsyncException() async {
  await Future.delayed(Duration(milliseconds: 1));
  throw Exception('Async exception');
}
