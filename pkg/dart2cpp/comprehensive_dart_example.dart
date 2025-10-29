/// 综合Dart示例 - 覆盖所有基本语法
///
/// 本文件包含Dart语言的完整语法演示，用于验证dart2cpp转换器的功能
///
/// 包含内容:
/// 1. 基础类型与变量
/// 2. 运算符
/// 3. 控制流
/// 4. 函数
/// 5. 面向对象编程
/// 6. 集合
/// 7. 异常处理
/// 8. 泛型
/// 9. 枚举
/// 10. 异步编程

// ==================== 1. 基础类型与变量 ====================

void testBasicTypes() {
  print('\n=== 测试基础类型 ===');

  // 整数类型
  int intVar = 42;
  int hexVar = 0xDEADBEEF;
  print('int: $intVar, hex: $hexVar');

  // 浮点类型
  double doubleVar = 3.14159;
  double expVar = 1.23e-5;
  print('double: $doubleVar, scientific: $expVar');

  // 布尔类型
  bool isTrue = true;
  bool isFalse = false;
  print('bool: $isTrue, $isFalse');

  // 字符串类型
  String singleQuote = 'single';
  String doubleQuote = "double";
  String multiline = '''
    This is
    multiline
    string
  ''';
  String interpolation = "Value: $intVar";
  print('String: $singleQuote, $doubleQuote');
  print('Multiline: $multiline');
  print('Interpolation: $interpolation');

  // 变量声明: var, final, const
  var autoVar = "auto"; // 类型推断
  final constFinal = "final"; // 只赋值一次
  const compileTimeConst = "const"; // 编译时常量
  print('var: $autoVar, final: $constFinal, const: $compileTimeConst');
}

// ==================== 2. 运算符 ====================

void testOperators() {
  print('\n=== 测试运算符 ===');

  int a = 10;
  int b = 3;

  // 算术运算符
  print('a = $a, b = $b');
  print('a + b = ${a + b}');
  print('a - b = ${a - b}');
  print('a * b = ${a * b}');
  print('a / b = ${a / b}');
  print('a ~/ b = ${a ~/ b}');
  print('a % b = ${a % b}');

  // 比较运算符
  print('a > b: ${a > b}');
  print('a == b: ${a == b}');
  print('a != b: ${a != b}');
  print('a <= b: ${a <= b}');

  // 逻辑运算符
  bool x = true;
  bool y = false;
  print('x && y: ${x && y}');
  print('x || y: ${x || y}');
  print('!x: ${!x}');

  // 位运算符
  print('a & b: ${a & b}');
  print('a | b: ${a | b}');
  print('a ^ b: ${a ^ b}');
  print('a << 2: ${a << 2}');
  print('a >> 1: ${a >> 1}');

  // 赋值运算符
  int c = 5;
  print('c = $c');
  c += 3; // c = c + 3
  print('c += 3: $c');
  c *= 2;
  print('c *= 2: $c');

  // 条件运算符 (三元运算符)
  int age = 20;
  String status = age >= 18 ? "Adult" : "Minor";
  print('Age: $age, Status: $status');

  // 空安全运算符
  String? nullable = null;
  String nonNull = nullable ?? "default";
  print('nullable: $nullable, nonNull: $nonNull');
}

// ==================== 3. 控制流 ====================

void testControlFlow() {
  print('\n=== 测试控制流 ===');

  // if-else
  int score = 85;
  if (score >= 90) {
    print('Grade: A');
  } else if (score >= 80) {
    print('Grade: B');
  } else if (score >= 70) {
    print('Grade: C');
  } else {
    print('Grade: F');
  }

  // switch语句
  String day = "Monday";
  switch (day) {
    case "Monday":
      print('Start of work week');
      break;
    case "Friday":
      print('End of work week');
      break;
    case "Saturday":
    case "Sunday":
      print('Weekend');
      break;
    default:
      print('Mid-week day');
  }

  // for循环
  print('for循环:');
  for (int i = 0; i < 5; i++) {
    print('i = $i');
  }

  // for-in循环
  List<String> fruits = ['apple', 'banana', 'orange'];
  print('for-in循环:');
  for (String fruit in fruits) {
    print(fruit);
  }

  // while循环
  print('while循环:');
  int count = 0;
  while (count < 3) {
    print('count = $count');
    count++;
  }

  // do-while循环
  print('do-while循环:');
  int num = 5;
  do {
    print('num = $num');
    num--;
  } while (num > 0);

  // break和continue
  print('break和continue:');
  for (int i = 0; i < 10; i++) {
    if (i == 3) continue; // 跳过本次循环
    if (i == 7) break; // 跳出循环
    print('i = $i');
  }
}

// ==================== 4. 函数 ====================

// 普通函数
int add(int a, int b) {
  return a + b;
}

// 箭头函数
int multiply(int a, int b) => a * b;

// 命名参数
void greet({String? name, int? age}) {
  print('Hello $name, age: $age');
}

// 默认值
void greetWithDefault({String name = "World", int age = 0}) {
  print('Hello $name, age: $age');
}

// 必需参数
void requiredGreet({required String name, required int age}) {
  print('Hello $name, age: $age');
}

// 可选位置参数
String fullName(String first, [String? last]) {
  return last != null ? '$first $last' : first;
}

// 高阶函数
void testHigherOrderFunctions() {
  print('\n=== 测试高阶函数 ===');

  // 函数作为参数
  int calculate(int a, int b, Function operation) {
    return operation(a, b);
  }

  int result = calculate(10, 5, (a, b) => a + b);
  print('calculate(10, 5, +) = $result');

  // 闭包
  Function makeAdder(int addBy) {
    return (int i) => i + addBy;
  }

  var add2 = makeAdder(2);
  var add5 = makeAdder(5);
  print('add2(3) = ${add2(3)}');
  print('add5(3) = ${add5(3)}');
}

void testFunctions() {
  print('\n=== 测试函数 ===');

  print('add(5, 3) = ${add(5, 3)}');
  print('multiply(4, 6) = ${multiply(4, 6)}');
  greet(name: "Alice", age: 25);
  greetWithDefault();
  greetWithDefault(name: "Bob");
  requiredGreet(name: "Charlie", age: 30);
  print('fullName("John", "Doe") = ${fullName("John", "Doe")}');
  print('fullName("Jane") = ${fullName("Jane")}');
  testHigherOrderFunctions();
}

// ==================== 5. 面向对象编程 ====================

// 基类
class Animal {
  String name;
  int age;

  Animal(this.name, this.age);

  void speak() {
    print('$name makes a sound');
  }

  String get info => '$name is $age years old';
}

// 继承
class Dog extends Animal {
  String breed;

  Dog(String name, int age, this.breed) : super(name, age);

  @override
  void speak() {
    print('$name barks');
  }

  void wagTail() {
    print('$name wags tail');
  }
}

// 接口
class Flyable {
  void fly() {
    print('Flying');
  }
}

// 实现多个接口
class Bird extends Animal implements Flyable {
  Bird(String name, int age) : super(name, age);

  @override
  void speak() {
    print('$name chirps');
  }

  @override
  void fly() {
    print('$name flies');
  }
}

// Getter和Setter
class Rectangle {
  double _width = 0;
  double _height = 0;

  Rectangle(this._width, this._height);

  double get width => _width;
  set width(double value) {
    if (value > 0) _width = value;
  }

  double get height => _height;
  set height(double value) {
    if (value > 0) _height = value;
  }

  double get area => _width * _height;

  @override
  String toString() => 'Rectangle($_width, $_height)';
}

// 工厂构造函数
class Logger {
  static final Map<String, Logger> _cache = {};
  final String name;

  factory Logger(String name) {
    return _cache.putIfAbsent(name, () => Logger._internal(name));
  }

  Logger._internal(this.name);

  void log(String message) {
    print('[$name] $message');
  }
}

// 静态方法
class MathHelper {
  static const pi = 3.14159;

  static int max(int a, int b) => a > b ? a : b;

  static int min(int a, int b) => a < b ? a : b;

  static int abs(int value) => value < 0 ? -value : value;
}

void testOOP() {
  print('\n=== 测试面向对象编程 ===');

  // 创建对象
  Animal animal = Animal("Generic", 5);
  animal.speak();
  print(animal.info);

  Dog dog = Dog("Buddy", 3, "Golden Retriever");
  dog.speak();
  dog.wagTail();
  print(dog.info);

  Bird bird = Bird("Tweety", 2);
  bird.speak();
  bird.fly();

  // Getter和Setter
  Rectangle rect = Rectangle(10, 5);
  print('Rectangle: $rect');
  print('Area: ${rect.area}');
  rect.width = 15;
  print('Updated width: ${rect.width}');
  print('New area: ${rect.area}');

  // 工厂构造函数
  Logger logger1 = Logger("Main");
  Logger logger2 = Logger("Main"); // 缓存中获取
  logger1.log("Starting application");
  logger2.log("Same instance");

  // 静态成员
  print('pi = ${MathHelper.pi}');
  print('max(10, 5) = ${MathHelper.max(10, 5)}');
  print('abs(-7) = ${MathHelper.abs(-7)}');
}

// ==================== 6. 集合 ====================

void testCollections() {
  print('\n=== 测试集合 ===');

  // List
  List<int> numbers = [1, 2, 3, 4, 5];
  print('List: $numbers');
  print('Length: ${numbers.length}');
  print('First: ${numbers.first}');
  print('Last: ${numbers.last}');
  print('Reversed: ${numbers.reversed.toList()}');

  numbers.add(6);
  print('After add: $numbers');

  numbers.removeAt(0);
  print('After remove: $numbers');

  // List方法
  var doubled = numbers.map((n) => n * 2).toList();
  print('Doubled: $doubled');

  var evens = numbers.where((n) => n % 2 == 0).toList();
  print('Evens: $evens');

  var sum = numbers.reduce((a, b) => a + b);
  print('Sum: $sum');

  // Set
  Set<String> fruits = {'apple', 'banana', 'orange'};
  print('Set: $fruits');
  fruits.add('grape');
  print('After add: $fruits');
  print('Contains apple: ${fruits.contains('apple')}');

  // Map
  Map<String, int> scores = {
    'Alice': 95,
    'Bob': 87,
    'Charlie': 92
  };
  print('Map: $scores');
  print('Alice score: ${scores['Alice']}');
  scores['David'] = 88;
  print('After add: $scores');
  scores.remove('Bob');
  print('After remove: $scores');

  // Map方法
  print('Keys: ${scores.keys.toList()}');
  print('Values: ${scores.values.toList()}');
  scores.forEach((name, score) => print('$name: $score'));
}

// ==================== 7. 异常处理 ====================

void testExceptions() {
  print('\n=== 测试异常处理 ===');

  try {
    int result = 10 ~/ 0; // 除零错误
    print('Result: $result');
  } catch (e) {
    print('Caught exception: $e');
  }

  try {
    List<int> list = [1, 2, 3];
    print(list[5]); // 索引越界
  } catch (e, stackTrace) {
    print('Caught with stack trace: $e');
    print('Stack trace: $stackTrace');
  }

  // 指定异常类型
  try {
    int.parse('not a number');
  } on FormatException catch (e) {
    print('Format exception: $e');
  } on Exception catch (e) {
    print('Unknown exception: $e');
  } finally {
    print('Finally block executed');
  }

  // 自定义异常
  try {
    checkAge(-5);
  } catch (e) {
    print('Custom exception: $e');
  }
}

void checkAge(int age) {
  if (age < 0) {
    throw InvalidAgeException('Age cannot be negative: $age');
  }
  print('Valid age: $age');
}

class InvalidAgeException implements Exception {
  final String message;
  InvalidAgeException(this.message);

  @override
  String toString() => 'InvalidAgeException: $message';
}

// ==================== 8. 泛型 ====================

class Box<T> {
  T _value;

  Box(this._value);

  T get value => _value;
  set value(T val) => _value = val;

  @override
  String toString() => 'Box($_value)';
}

class Pair<T, U> {
  T first;
  U second;

  Pair(this.first, this.second);

  @override
  String toString() => 'Pair($first, $second)';
}

void testGenerics() {
  print('\n=== 测试泛型 ===');

  Box<int> intBox = Box<int>(42);
  print('intBox: $intBox');
  print('value: ${intBox.value}');

  Box<String> strBox = Box<String>('Hello');
  print('strBox: $strBox');

  Pair<String, int> person = Pair<String, int>('Alice', 25);
  print('person: $person');

  // 泛型方法
  print('max: ${findMax<int>([3, 7, 2, 9, 1])}');
  print('max: ${findMax<String>(['apple', 'zebra', 'banana'])}');
}

T findMax<T extends Comparable>(List<T> items) {
  if (items.isEmpty) throw Exception('Empty list');

  T max = items.first;
  for (T item in items) {
    if (item.compareTo(max) > 0) {
      max = item;
    }
  }
  return max;
}

// ==================== 9. 枚举 ====================

enum Color { red, green, blue }

enum Status { pending, active, completed, failed }

void testEnums() {
  print('\n=== 测试枚举 ===');

  Color favorite = Color.red;
  print('Favorite color: $favorite');
  print('Color name: ${favorite.name}');
  print('Color index: ${favorite.index}');

  // 枚举遍历
  print('All colors:');
  for (Color color in Color.values) {
    print('  $color (index: ${color.index})');
  }

  // 枚举在switch中的应用
  Status status = Status.active;
  switch (status) {
    case Status.pending:
      print('Status: Pending');
      break;
    case Status.active:
      print('Status: Active');
      break;
    case Status.completed:
      print('Status: Completed');
      break;
    case Status.failed:
      print('Status: Failed');
      break;
  }
}

// ==================== 10. 异步编程 ====================

// 返回Future的函数
Future<String> fetchData() async {
  print('Fetching data...');
  await Future.delayed(Duration(seconds: 1)); // 模拟异步操作
  return 'Data loaded';
}

Future<void> testAsync() async {
  print('\n=== 测试异步编程 ===');

  print('Starting async operations...');

  // 等待Future完成
  String data = await fetchData();
  print('Result: $data');

  // 并行执行多个异步操作
  print('Parallel operations:');
  var future1 = Future.delayed(Duration(milliseconds: 500), () => 'Result 1');
  var future2 = Future.delayed(Duration(milliseconds: 700), () => 'Result 2');
  var future3 = Future.delayed(Duration(milliseconds: 300), () => 'Result 3');

  var results = await Future.wait([future1, future2, future3]);
  print('All results: $results');

  // 异常处理
  try {
    await Future.delayed(Duration(milliseconds: 200), () {
      throw Exception('Something went wrong');
    });
  } catch (e) {
    print('Caught async exception: $e');
  }

  print('Async operations completed');
}

// ==================== 主函数 ====================

void main() {
  print('=' * 80);
  print('🚀 综合Dart示例 - 完整语法演示');
  print('=' * 80);

  testBasicTypes();
  testOperators();
  testControlFlow();
  testFunctions();
  testOOP();
  testCollections();
  testExceptions();
  testGenerics();
  testEnums();
  testAsync();

  print('\n' + '=' * 80);
  print('✅ 所有测试完成');
  print('=' * 80);
}
