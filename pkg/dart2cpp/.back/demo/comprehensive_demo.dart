/// 综合测试演示 - 包含所有Dart语法特性
/// 
/// 这是一个完整的测试文件，包含了所有主要的Dart语法特性
/// 用于测试dart2cpp转换器的完整性和正确性

import 'dart:async';
import 'dart:math' as math;

void main() async {
  print('🚀 Dart2CPP 综合测试开始');
  print('=' * 60);

  // 1. 基础语法测试
  testBasicSyntax();
  
  // 2. 面向对象测试
  testObjectOriented();
  
  // 3. 集合操作测试
  testCollections();
  
  // 4. 异步编程测试
  await testAsyncProgramming();
  
  // 5. 泛型测试
  testGenerics();
  
  // 6. 异常处理测试
  testExceptionHandling();
  
  // 7. 高级特性测试
  testAdvancedFeatures();

  print('=' * 60);
  print('✅ 所有测试完成');
}

/// 1. 测试基础语法
void testBasicSyntax() {
  print('\n📌 测试基础语法');

  // 基本数据类型
  int intValue = 42;
  double doubleValue = 3.14159;
  bool boolValue = true;
  String stringValue = 'Hello, Dart2CPP!';
  
  print('  基本类型: $intValue, $doubleValue, $boolValue, $stringValue');

  // 运算符测试
  int a = 10, b = 3;
  print('  算术运算: ${a + b}, ${a - b}, ${a * b}, ${a / b}, ${a % b}, ${a ~/ b}');
  print('  比较运算: ${a == b}, ${a != b}, ${a > b}, ${a < b}');
  print('  逻辑运算: ${boolValue && false}, ${boolValue || false}, ${!boolValue}');

  // 控制流测试
  int sum = 0;
  for (int i = 1; i <= 5; i++) {
    sum += i;
  }
  print('  for循环求和: $sum');

  // 条件语句
  String grade = intValue >= 90 ? 'A' : intValue >= 80 ? 'B' : 'C';
  print('  条件运算: $grade');

  // switch语句
  switch (grade) {
    case 'A':
      print('  优秀');
      break;
    case 'B':
      print('  良好');
      break;
    default:
      print('  需要努力');
  }

  // 函数调用
  int result = addNumbers(5, 3);
  print('  函数调用结果: $result');

  // 可选参数
  greetPerson('Alice');
  greetPerson('Bob', 'Mr.');

  print('  ✓ 基础语法测试完成');
}

/// 2. 测试面向对象
void testObjectOriented() {
  print('\n📌 测试面向对象');

  // 基本类
  var person = Person('Alice', 25);
  person.introduce();
  person.celebrateBirthday();

  // 继承
  var student = Student('Bob', 20, 'S001');
  student.introduce();
  student.study();

  // 接口实现
  var car = Car();
  car.start();
  car.stop();

  // 抽象类
  var circle = Circle(5.0);
  print('  圆形面积: ${circle.area()}');

  var rectangle = Rectangle(4.0, 6.0);
  print('  矩形面积: ${rectangle.area()}');

  // 枚举
  var status = Status.active;
  print('  状态: ${status.name}, 索引: ${status.index}');

  // 混入
  var musician = Musician('Charlie');
  musician.perform();

  print('  ✓ 面向对象测试完成');
}

/// 3. 测试集合操作
void testCollections() {
  print('\n📌 测试集合操作');

  // List 操作
  List<int> numbers = [1, 2, 3, 4, 5];
  print('  原始列表: $numbers');
  
  numbers.add(6);
  print('  添加元素后: $numbers');
  
  var doubled = numbers.map((n) => n * 2).toList();
  print('  映射操作: $doubled');
  
  var evens = numbers.where((n) => n % 2 == 0).toList();
  print('  过滤偶数: $evens');

  // Set 操作
  Set<String> fruits = {'apple', 'banana', 'orange'};
  fruits.add('apple'); // 重复元素会被忽略
  print('  水果集合: $fruits');

  // Map 操作
  Map<String, int> scores = {'Alice': 95, 'Bob': 87, 'Charlie': 92};
  print('  分数映射: $scores');
  print('  Alice的分数: ${scores['Alice']}');

  // 集合方法
  int sum = numbers.reduce((a, b) => a + b);
  print('  列表求和: $sum');
  
  bool hasEven = numbers.any((n) => n % 2 == 0);
  print('  包含偶数: $hasEven');

  print('  ✓ 集合操作测试完成');
}

/// 4. 测试异步编程
Future<void> testAsyncProgramming() async {
  print('\n📌 测试异步编程');

  // Future 基础
  String result = await Future.delayed(
    Duration(milliseconds: 10), 
    () => 'Async Result'
  );
  print('  异步结果: $result');

  // Future 组合
  List<String> results = await Future.wait([
    Future.delayed(Duration(milliseconds: 5), () => 'A'),
    Future.delayed(Duration(milliseconds: 10), () => 'B'),
    Future.delayed(Duration(milliseconds: 15), () => 'C'),
  ]);
  print('  并行结果: $results');

  // Stream 测试
  print('  Stream测试:');
  await for (int value in generateNumbers(3)) {
    print('    生成数字: $value');
  }

  // 错误处理
  try {
    await riskyAsyncOperation();
  } catch (e) {
    print('  捕获异步异常: $e');
  }

  print('  ✓ 异步编程测试完成');
}

/// 5. 测试泛型
void testGenerics() {
  print('\n📌 测试泛型');

  // 泛型类
  var intBox = Box<int>(42);
  var stringBox = Box<String>('Hello');
  
  print('  整数盒子: ${intBox.getValue()}');
  print('  字符串盒子: ${stringBox.getValue()}');

  // 泛型方法
  print('  泛型方法: ${identity<int>(100)}');
  print('  泛型方法: ${identity<String>("test")}');

  // 多泛型参数
  var pair = Pair<String, int>('Alice', 25);
  print('  键值对: ${pair.first} -> ${pair.second}');

  // 类型约束
  var calculator = Calculator<int>();
  print('  泛型计算: ${calculator.add(5, 3)}');

  print('  ✓ 泛型测试完成');
}

/// 6. 测试异常处理
void testExceptionHandling() {
  print('\n📌 测试异常处理');

  // 基本异常捕获
  try {
    throw Exception('测试异常');
  } catch (e) {
    print('  捕获异常: $e');
  }

  // 特定异常类型
  try {
    validateAge(-5);
  } on ArgumentError catch (e) {
    print('  参数错误: ${e.message}');
  }

  // 自定义异常
  try {
    throw CustomException('自定义错误', 404);
  } on CustomException catch (e) {
    print('  自定义异常: ${e.message}, 代码: ${e.code}');
  }

  // finally 块
  try {
    performRiskyOperation();
  } catch (e) {
    print('  操作异常: $e');
  } finally {
    print('  清理资源');
  }

  print('  ✓ 异常处理测试完成');
}

/// 7. 测试高级特性
void testAdvancedFeatures() {
  print('\n📌 测试高级特性');

  // 闭包
  var counter = createCounter();
  print('  闭包计数: ${counter()}, ${counter()}, ${counter()}');

  // 高阶函数
  var numbers = [1, 2, 3, 4, 5];
  var processed = processNumbers(numbers, (n) => n * n);
  print('  高阶函数: $processed');

  // 扩展方法（如果支持）
  String text = 'hello world';
  print('  字符串处理: ${text.toUpperCase()}');

  // 空安全
  String? nullable = null;
  String safe = nullable ?? '默认值';
  print('  空安全: $safe');

  // 级联操作
  var list = <int>[]
    ..add(1)
    ..add(2)
    ..add(3);
  print('  级联操作: $list');

  print('  ✓ 高级特性测试完成');
}

// ============================================================================
// 辅助函数和类定义
// ============================================================================

/// 简单加法函数
int addNumbers(int a, int b) {
  return a + b;
}

/// 带可选参数的问候函数
void greetPerson(String name, [String? title]) {
  if (title != null) {
    print('  问候: Hello, $title $name');
  } else {
    print('  问候: Hello, $name');
  }
}

/// 基本人员类
class Person {
  String name;
  int age;
  
  Person(this.name, this.age);
  
  void introduce() {
    print('  我是$name，今年$age岁');
  }
  
  void celebrateBirthday() {
    age++;
    print('  🎉 生日快乐！现在$age岁了');
  }
}

/// 学生类（继承示例）
class Student extends Person {
  String studentId;
  
  Student(String name, int age, this.studentId) : super(name, age);
  
  void study() {
    print('  学生$name正在学习，学号：$studentId');
  }
}

/// 可驾驶接口
abstract class Drivable {
  void start();
  void stop();
}

/// 汽车类（接口实现）
class Car implements Drivable {
  bool isRunning = false;
  
  @override
  void start() {
    isRunning = true;
    print('  汽车启动');
  }
  
  @override
  void stop() {
    isRunning = false;
    print('  汽车停止');
  }
}

/// 抽象形状类
abstract class Shape {
  double area();
}

/// 圆形类
class Circle extends Shape {
  double radius;
  
  Circle(this.radius);
  
  @override
  double area() {
    return math.pi * radius * radius;
  }
}

/// 矩形类
class Rectangle extends Shape {
  double width;
  double height;
  
  Rectangle(this.width, this.height);
  
  @override
  double area() {
    return width * height;
  }
}

/// 状态枚举
enum Status {
  inactive,
  active,
  pending,
  completed
}

/// 表演者混入
mixin Performer {
  void perform() {
    print('  正在表演...');
  }
}

/// 音乐家类（使用混入）
class Musician with Performer {
  String name;
  
  Musician(this.name);
}

/// 泛型盒子类
class Box<T> {
  T _value;
  
  Box(this._value);
  
  T getValue() => _value;
  void setValue(T value) => _value = value;
}

/// 泛型键值对类
class Pair<T, U> {
  T first;
  U second;
  
  Pair(this.first, this.second);
}

/// 泛型身份函数
T identity<T>(T value) {
  return value;
}

/// 带类型约束的计算器
class Calculator<T extends num> {
  T add(T a, T b) {
    return (a + b) as T;
  }
}

/// 自定义异常类
class CustomException implements Exception {
  final String message;
  final int code;
  
  CustomException(this.message, this.code);
  
  @override
  String toString() => 'CustomException: $message (code: $code)';
}

/// 验证年龄函数
void validateAge(int age) {
  if (age < 0) {
    throw ArgumentError('年龄不能为负数');
  }
}

/// 执行风险操作
void performRiskyOperation() {
  throw Exception('风险操作失败');
}

/// 创建计数器闭包
Function createCounter() {
  int count = 0;
  return () {
    count++;
    return count;
  };
}

/// 处理数字的高阶函数
List<int> processNumbers(List<int> numbers, int Function(int) processor) {
  return numbers.map(processor).toList();
}

/// 生成数字的Stream
Stream<int> generateNumbers(int count) async* {
  for (int i = 1; i <= count; i++) {
    await Future.delayed(Duration(milliseconds: 10));
    yield i;
  }
}

/// 风险异步操作
Future<void> riskyAsyncOperation() async {
  await Future.delayed(Duration(milliseconds: 5));
  throw Exception('异步操作失败');
}