/// 基础语法演示
///
/// 测试所有基本的 Dart 语法结构

void main() {
  print('🔥 基础语法演示开始');

  // 1. 基本数据类型
  testBasicTypes();

  // 2. 变量声明
  testVariableDeclarations();

  // 3. 运算符
  testOperators();

  // 4. 控制流
  testControlFlow();

  // 5. 函数
  testFunctions();

  // 6. 类和对象
  testClassesAndObjects();

  // 7. 继承和多态
  testInheritanceAndPolymorphism();

  // 8. 接口和抽象类
  testInterfacesAndAbstractClasses();

  // 9. 泛型
  testGenerics();

  // 10. 集合操作
  testCollections();

  // 11. 枚举
  testEnums();

  // 12. 异常处理
  testExceptionHandling();

  // 13. 异步编程
  testAsyncProgramming();

  // 14. 扩展方法
  testExtensionMethods();

  // 15. 高级语法特性
  testAdvancedFeatures();

  print('✅ 基础语法演示完成');
}

/// 测试基本数据类型
void testBasicTypes() {
  print('\n📌 测试基本数据类型');

  // 整数
  int intValue = 42;
  int hexValue = 0xFF;
  int binaryValue = 333;

  // 浮点数
  double doubleValue = 3.14159;
  double scientificValue = 1.42e5;

  // 布尔值
  bool trueValue = true;
  bool falseValue = false;

  // 字符串
  String singleQuote = 'Hello';
  String doubleQuote = "World";
  String multiLine = '''
    This is a
    multi-line string
  ''';

  // 字符串插值
  String interpolation = 'The answer is ${intValue}';
  String expression = 'Sum: ${intValue + doubleValue}';

  print('  整数: $intValue, 十六进制: $hexValue, 二进制: $binaryValue');
  print('  浮点数: $doubleValue, 科学计数法: $scientificValue');
  print('  布尔值: $trueValue, $falseValue');
  print('  字符串: $singleQuote $doubleQuote');
  print('  插值: $interpolation');
  print('  表达式: $expression');
}

/// 测试变量声明
void testVariableDeclarations() {
  print('\n📌 测试变量声明');

  // var 声明
  var autoInt = 100;
  var autoString = 'auto';

  // final 声明
  final finalValue = 'cannot change';
  final int typedFinal = 200;

  // const 声明
  const constValue = 'compile time constant';
  const double pi = 3.14159;

  // 可空类型
  int? nullableInt;
  String? nullableString = null;

  // 非空断言
  String nonNull = nullableString ?? 'default';

  print('  var: $autoInt, $autoString');
  print('  final: $finalValue, $typedFinal');
  print('  const: $constValue, $pi');
  print('  nullable: $nullableInt, $nullableString');
  print('  non-null: $nonNull');
}

/// 测试运算符
void testOperators() {
  print('\n📌 测试运算符');

  int a = 10, b = 3;

  // 算术运算符
  print('  算术: ${a + b}, ${a - b}, ${a * b}, ${a / b}, ${a % b}');
  print('  整除: ${a ~/ b}');

  // 比较运算符
  print('  比较: ${a == b}, ${a != b}, ${a > b}, ${a < b}, ${a >= b}, ${a <= b}');

  // 逻辑运算符
  bool x = true, y = false;
  print('  逻辑: ${x && y}, ${x || y}, ${!x}');

  // 位运算符
  print('  位运算: ${a & b}, ${a | b}, ${a ^ b}, ${~a}, ${a << 1}, ${a >> 1}');

  // 赋值运算符
  int c = 5;
  c += 2;
  print('  赋值后: $c');

  // 条件运算符
  String result = a > b ? 'a is greater' : 'b is greater';
  print('  三元: $result');

  // 空值合并
  String? nullable;
  String safe = nullable ?? 'default value';
  print('  空值合并: $safe');
}

/// 测试控制流
void testControlFlow() {
  print('\n📌 测试控制流');

  // if-else
  int score = 85;
  if (score >= 90) {
    print('  成绩: 优秀');
  } else if (score >= 80) {
    print('  成绩: 良好');
  } else if (score >= 70) {
    print('  成绩: 中等');
  } else {
    print('  成绩: 需要努力');
  }

  // switch-case
  String grade = 'B';
  switch (grade) {
    case 'A':
      print('  等级: 优秀');
      break;
    case 'B':
      print('  等级: 良好');
      break;
    case 'C':
      print('  等级: 中等');
      break;
    default:
      print('  等级: 未知');
  }

  // for 循环
  print('  for循环:');
  for (int i = 0; i < 3; i++) {
    print('    索引: $i');
  }

  // for-in 循环
  List<String> fruits = ['apple', 'banana', 'orange'];
  print('  for-in循环:');
  for (String fruit in fruits) {
    print('    水果: $fruit');
  }

  // while 循环
  print('  while循环:');
  int count = 0;
  while (count < 3) {
    print('    计数: $count');
    count++;
  }

  // do-while 循环
  print('  do-while循环:');
  int num = 0;
  do {
    print('    数字: $num');
    num++;
  } while (num < 2);

  // break 和 continue
  print('  break和continue:');
  for (int i = 0; i < 5; i++) {
    if (i == 2) continue;
    if (i == 4) break;
    print('    处理: $i');
  }
}

/// 测试函数
void testFunctions() {
  print('\n📌 测试函数');

  // 普通函数调用
  int sum = add(5, 3);
  print('  加法: $sum');

  // 可选参数
  greet('Alice');
  greet('Bob', 'Mr.');

  // 命名参数
  createUser(name: 'Charlie', age: 25);
  createUser(name: 'David', age: 30, email: 'david@example.com');

  // 匿名函数
  var multiply = (int a, int b) => a * b;
  print('  匿名函数: ${multiply(4, 5)}');

  // 高阶函数
  var numbers = [1, 2, 3, 4, 5];
  var doubled = numbers.map((n) => n * 2).toList();
  print('  高阶函数: $doubled');

  // 闭包
  var counter = createCounter();
  print('  闭包: ${counter()}, ${counter()}, ${counter()}');
}

/// 测试类和对象
void testClassesAndObjects() {
  print('\n📌 测试类和对象');

  // 基本类实例化
  var person = Person('Alice', 25);
  print('  基本对象: ${person.name}, ${person.age}');
  person.introduce();

  // 带私有成员的类
  var account = BankAccount('123456', 1000.0);
  account.deposit(500.0);
  account.withdraw(200.0);
  print('  账户余额: ${account.getBalance()}');

  // 构造函数重载
  var point1 = Point(3, 4);
  var point2 = Point.origin();
  var point3 = Point.fromPolar(5.0, 0.927);
  print(
      '  点坐标: (${point1.x}, ${point1.y}), (${point2.x}, ${point2.y}), (${point3.x}, ${point3.y})');

  // 静态成员
  print('  创建的点数量: ${Point.count}');

  // getter 和 setter
  var rectangle = Rectangle(10, 20);
  print('  矩形面积: ${rectangle.area}');
  rectangle.width = 15;
  print('  修改后面积: ${rectangle.area}');
}

/// 测试继承和多态
void testInheritanceAndPolymorphism() {
  print('\n📌 测试继承和多态');

  // 继承
  var student = Student('Bob', 20, 'S001');
  student.introduce();
  student.study();

  var teacher = Teacher('Dr. Smith', 45, 'Computer Science');
  teacher.introduce();
  teacher.teach();

  // 多态
  List<Person> people = [
    Person('Alice', 30),
    Student('Charlie', 19, 'S002'),
    Teacher('Prof. Johnson', 50, 'Mathematics')
  ];

  print('  多态演示:');
  for (var person in people) {
    person.introduce();
    if (person is Student) {
      person.study();
    } else if (person is Teacher) {
      person.teach();
    }
  }
}

/// 测试接口和抽象类
void testInterfacesAndAbstractClasses() {
  print('\n📌 测试接口和抽象类');

  // 实现接口
  var dog = Dog('Buddy');
  var cat = Cat('Whiskers');

  List<Animal> animals = [dog, cat];
  for (var animal in animals) {
    animal.makeSound();
    animal.move();
  }

  // 抽象类
  var circle = Circle(5.0);
  var square = Square(4.0);

  List<Shape> shapes = [circle, square];
  for (var shape in shapes) {
    print(
        '  ${shape.runtimeType} 面积: ${shape.area()}, 周长: ${shape.perimeter()}');
  }
}

/// 测试泛型
void testGenerics() {
  print('\n📌 测试泛型');

  // 泛型类
  var intBox = Box<int>(42);
  var stringBox = Box<String>('Hello');

  print('  泛型盒子: ${intBox.getValue()}, ${stringBox.getValue()}');

  // 泛型方法
  var intList = [1, 2, 3];
  var stringList = ['a', 'b', 'c'];

  print('  泛型交换前: $intList, $stringList');
  swap(intList, 0, 2);
  swap(stringList, 0, 2);
  print('  泛型交换后: $intList, $stringList');

  // 泛型约束
  var numberProcessor = NumberProcessor<double>();
  print('  泛型约束: ${numberProcessor.process([1.1, 2.2, 3.3])}');

  // 泛型集合
  var cache = Cache<String, int>();
  cache.put('one', 1);
  cache.put('two', 2);
  print('  泛型缓存: ${cache.get('one')}, ${cache.get('two')}');
}

/// 测试集合操作
void testCollections() {
  print('\n📌 测试集合操作');

  // List 操作
  var numbers = <int>[1, 2, 3, 4, 5];
  numbers.add(6);
  numbers.addAll([7, 8, 9]);
  numbers.insert(0, 0);
  print('  List操作: $numbers');

  var evenNumbers = numbers.where((n) => n % 2 == 0).toList();
  var doubled = numbers.map((n) => n * 2).toList();
  var sum = numbers.reduce((a, b) => a + b);
  print('  List筛选: 偶数=$evenNumbers, 翻倍=$doubled, 求和=$sum');

  // Set 操作
  var fruits = <String>{'apple', 'banana', 'orange'};
  fruits.add('grape');
  fruits.addAll(['kiwi', 'mango']);
  print('  Set操作: $fruits');

  var citrus = <String>{'orange', 'lemon', 'lime'};
  var intersection = fruits.intersection(citrus);
  var union = fruits.union(citrus);
  print('  Set运算: 交集=$intersection, 并集=$union');

  // Map 操作
  var scores = <String, int>{'Alice': 95, 'Bob': 87, 'Charlie': 92};
  scores['David'] = 89;
  scores.addAll({'Eve': 96, 'Frank': 84});
  print('  Map操作: $scores');

  var highScores =
      Map.fromEntries(scores.entries.where((entry) => entry.value >= 90));
  print('  Map筛选: 高分=$highScores');

  // 复杂集合操作
  var students = [
    {'name': 'Alice', 'grade': 95, 'subject': 'Math'},
    {'name': 'Bob', 'grade': 87, 'subject': 'Science'},
    {'name': 'Charlie', 'grade': 92, 'subject': 'Math'},
    {'name': 'David', 'grade': 89, 'subject': 'Science'},
  ];

  var mathStudents = students.where((s) => s['subject'] == 'Math').toList();
  var avgGrade =
      students.map((s) => s['grade'] as int).reduce((a, b) => a + b) /
          students.length;
  print('  复杂操作: 数学学生=$mathStudents, 平均分=$avgGrade');
}

/// 测试枚举
void testEnums() {
  print('\n📌 测试枚举');

  // 基本枚举
  var today = Weekday.monday;
  print('  今天是: ${today.name}');

  // 枚举方法
  print('  是工作日吗: ${WeekdayHelper.isWeekday(today)}');
  print('  是周末吗: ${WeekdayHelper.isWeekend(today)}');

  // 增强枚举
  var red = Color.red;
  var green = Color.green;
  var blue = Color.blue;

  print(
      '  颜色值: ${red.toString()}=${ColorHelper.getValue(red)}, ${green.toString()}=${ColorHelper.getValue(green)}, ${blue.toString()}=${ColorHelper.getValue(blue)}');
  print(
      '  颜色描述: ${ColorHelper.getDescription(red)}, ${ColorHelper.getDescription(green)}, ${ColorHelper.getDescription(blue)}');

  // 枚举遍历
  print('  所有颜色:');
  for (var color in Color.values) {
    print(
        '    ${color.toString()}: ${ColorHelper.getValue(color)} - ${ColorHelper.getDescription(color)}');
  }

  // 状态机示例
  var order = Order();
  print('  订单状态: ${order.status.name}');
  order.confirm();
  print('  确认后状态: ${order.status.name}');
  order.ship();
  print('  发货后状态: ${order.status.name}');
  order.deliver();
  print('  送达后状态: ${order.status.name}');
}

/// 测试异常处理
void testExceptionHandling() {
  print('\n📌 测试异常处理');

  // 基本异常处理
  try {
    int result = divide(10, 0);
    print('  除法结果: $result');
  } catch (e) {
    print('  捕获异常: $e');
  }

  // 特定异常类型
  try {
    validateAge(-5);
  } on InvalidAgeException catch (e) {
    print('  年龄异常: ${e.message}');
  } catch (e) {
    print('  其他异常: $e');
  }

  // finally 块
  try {
    riskyOperation();
  } catch (e) {
    print('  操作异常: $e');
  } finally {
    print('  清理资源');
  }

  // 自定义异常
  try {
    processData(null);
  } on DataProcessingException catch (e) {
    print('  数据处理异常: ${e.message}, 错误码: ${e.errorCode}');
  }

  // 重新抛出异常
  try {
    wrapperFunction();
  } catch (e) {
    print('  包装函数异常: $e');
  }
}

/// 测试异步编程
void testAsyncProgramming() {
  print('\n📌 测试异步编程');

  // 注意：在同步main中调用异步函数的简化示例
  // 实际应用中需要使用 await 或 .then()

  print('  开始异步操作...');

  // 模拟异步操作
  fetchUserData().then((data) {
    print('  获取用户数据: $data');
  }).catchError((dynamic error) {
    print('  异步错误: $error');
  });

  // Future 组合
  Future.wait<String>([
    fetchUserData(),
    fetchUserPreferences(),
  ]).then((results) {
    print('  组合结果: $results');
  });

  // Stream 示例
  var stream = generateNumbers();
  stream.listen(
    (number) => print('  流数据: $number'),
    onError: (dynamic error) => print('  流错误: $error'),
    onDone: () => print('  流结束'),
  );
}

/// 测试扩展方法
void testExtensionMethods() {
  print('\n📌 测试扩展方法');

  // 字符串扩展
  String text = 'hello world';
  print('  首字母大写: ${text.capitalize()}');
  print('  是否为回文: ${text.isPalindrome()}');
  print('  单词数量: ${text.wordCount()}');

  // 数字扩展
  int number = 5;
  print('  阶乘: ${number.factorial()}');
  print('  是否为偶数: ${number.isEven}');
  print('  是否为质数: ${number.isPrime()}');

  // List 扩展
  var numbers = [1, 2, 3, 4, 5];
  print('  第二个元素: ${numbers.secondOrNull}');
  print('  安全获取: ${numbers.safeGet(10)}');

  var chunks = numbers.chunk(2);
  print('  分块: $chunks');

  // DateTime 扩展
  var now = DateTime.now();
  print('  是否为今天: ${now.isToday()}');
  print('  格式化: ${now.format()}');
}

/// 测试高级语法特性
void testAdvancedFeatures() {
  print('\n📌 测试高级语法特性');

  // 级联操作符
  var person = Person('Alice', 25)
    ..introduce()
    ..age = 26
    ..introduce();

  // 条件成员访问
  Person? nullablePerson;
  print('  安全访问: ${nullablePerson?.name ?? 'null'}');

  // 类型检查和转换
  dynamic obj = 'Hello';
  if (obj is String) {
    print('  类型检查: 字符串长度=${obj.length}');
  }

  // as 转换
  var stringObj = obj as String;
  print('  类型转换: ${stringObj.toUpperCase()}');

  // 解构赋值（使用类模拟）
  var coordinates = getCoordinates();
  int x = coordinates.x;
  int y = coordinates.y;
  print('  解构赋值: x=$x, y=$y');

  // 模式匹配（使用传统switch）
  String result;
  switch (obj.runtimeType.toString()) {
    case 'String':
      result = '这是字符串';
      break;
    case 'int':
      result = '这是整数';
      break;
    default:
      result = '未知类型';
  }
  print('  模式匹配: $result');

  // 函数作为一等公民
  var operations = <String, Function>{
    'add': (int a, int b) => a + b,
    'multiply': (int a, int b) => a * b,
    'subtract': (int a, int b) => a - b,
  };

  print('  函数映射: ${operations['add']!(5, 3)}');

  // 记录类型模拟
  var userInfo = createUserRecord('Bob', 30, 'bob@example.com');
  print('  记录类型: $userInfo');
}

// ==================== 类定义 ====================

/// 基础 Person 类
class Person {
  String name;
  int age;

  Person(this.name, this.age);

  void introduce() {
    print('    我是 $name，今年 $age 岁');
  }
}

/// 银行账户类（私有成员示例）
class BankAccount {
  String _accountNumber;
  double _balance;

  BankAccount(this._accountNumber, this._balance);

  void deposit(double amount) {
    _balance += amount;
    print('    存入 $amount，余额: $_balance');
  }

  bool withdraw(double amount) {
    if (_balance >= amount) {
      _balance -= amount;
      print('    取出 $amount，余额: $_balance');
      return true;
    } else {
      print('    余额不足');
      return false;
    }
  }

  double getBalance() => _balance;
}

/// 点类（多构造函数示例）
class Point {
  double x, y;
  static int count = 0;

  Point(this.x, this.y) {
    count++;
  }

  Point.origin() : this(0, 0);

  Point.fromPolar(double radius, double angle)
      : this(radius * cos(angle), radius * sin(angle));
}

/// 矩形类（getter/setter 示例）
class Rectangle {
  double _width, _height;

  Rectangle(this._width, this._height);

  double get width => _width;
  set width(double value) => _width = value;

  double get height => _height;
  set height(double value) => _height = value;

  double get area => _width * _height;
}

/// 学生类（继承示例）
class Student extends Person {
  String studentId;

  Student(String name, int age, this.studentId) : super(name, age);

  @override
  void introduce() {
    super.introduce();
    print('    学号: $studentId');
  }

  void study() {
    print('    $name 正在学习');
  }
}

/// 教师类（继承示例）
class Teacher extends Person {
  String subject;

  Teacher(String name, int age, this.subject) : super(name, age);

  @override
  void introduce() {
    super.introduce();
    print('    教授科目: $subject');
  }

  void teach() {
    print('    $name 正在教授 $subject');
  }
}

/// 动物接口
abstract class Animal {
  String name;
  Animal(this.name);

  void makeSound();
  void move();
}

/// 狗类（实现接口）
class Dog extends Animal {
  Dog(String name) : super(name);

  @override
  void makeSound() {
    print('    $name 汪汪叫');
  }

  @override
  void move() {
    print('    $name 跑步');
  }
}

/// 猫类（实现接口）
class Cat extends Animal {
  Cat(String name) : super(name);

  @override
  void makeSound() {
    print('    $name 喵喵叫');
  }

  @override
  void move() {
    print('    $name 悄悄走');
  }
}

/// 抽象形状类
abstract class Shape {
  double area();
  double perimeter();
}

/// 圆形类
class Circle extends Shape {
  double radius;

  Circle(this.radius);

  @override
  double area() => 3.14159 * radius * radius;

  @override
  double perimeter() => 2 * 3.14159 * radius;
}

/// 正方形类
class Square extends Shape {
  double side;

  Square(this.side);

  @override
  double area() => side * side;

  @override
  double perimeter() => 4 * side;
}

/// 泛型盒子类
class Box<T> {
  T _value;

  Box(this._value);

  T getValue() => _value;
  void setValue(T value) => _value = value;
}

/// 泛型约束示例
class NumberProcessor<T extends num> {
  T process(List<T> numbers) {
    return numbers.reduce((a, b) => (a + b) as T);
  }
}

/// 泛型缓存类
class Cache<K, V> {
  final Map<K, V> _cache = {};

  void put(K key, V value) => _cache[key] = value;
  V? get(K key) => _cache[key];
  bool containsKey(K key) => _cache.containsKey(key);
  void clear() => _cache.clear();
}

// ==================== 枚举定义 ====================

/// 基本枚举
enum Weekday { monday, tuesday, wednesday, thursday, friday, saturday, sunday }

/// 工作日工具类
class WeekdayHelper {
  static bool isWeekday(Weekday day) {
    return day.index < 5;
  }

  static bool isWeekend(Weekday day) {
    return !isWeekday(day);
  }
}

/// 基本枚举（兼容旧版本）
enum Color { red, green, blue }

/// 颜色工具类
class ColorHelper {
  static const Map<Color, int> values = {
    Color.red: 0xFF0000,
    Color.green: 0x00FF00,
    Color.blue: 0x0000FF,
  };

  static const Map<Color, String> descriptions = {
    Color.red: '红色',
    Color.green: '绿色',
    Color.blue: '蓝色',
  };

  static int getValue(Color color) => values[color]!;
  static String getDescription(Color color) => descriptions[color]!;
}

/// 订单状态枚举
enum OrderStatus { pending, confirmed, shipped, delivered, cancelled }

/// 订单类（状态机示例）
class Order {
  OrderStatus status = OrderStatus.pending;

  void confirm() {
    if (status == OrderStatus.pending) {
      status = OrderStatus.confirmed;
    }
  }

  void ship() {
    if (status == OrderStatus.confirmed) {
      status = OrderStatus.shipped;
    }
  }

  void deliver() {
    if (status == OrderStatus.shipped) {
      status = OrderStatus.delivered;
    }
  }

  void cancel() {
    if (status != OrderStatus.delivered) {
      status = OrderStatus.cancelled;
    }
  }
}

// ==================== 异常类定义 ====================

/// 自定义异常
class InvalidAgeException implements Exception {
  final String message;
  InvalidAgeException(this.message);

  @override
  String toString() => 'InvalidAgeException: $message';
}

/// 数据处理异常
class DataProcessingException implements Exception {
  final String message;
  final int errorCode;

  DataProcessingException(this.message, this.errorCode);

  @override
  String toString() => 'DataProcessingException: $message (Code: $errorCode)';
}

// ==================== 扩展方法定义 ====================

/// 字符串扩展
extension StringExtensions on String {
  String capitalize() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  bool isPalindrome() {
    String cleaned = toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '');
    return cleaned == cleaned.split('').reversed.join('');
  }

  int wordCount() {
    return trim().split(RegExp(r'\s+')).length;
  }
}

/// 整数扩展
extension IntExtensions on int {
  int factorial() {
    if (this < 0) return 0;
    if (this <= 1) return 1;
    return this * (this - 1).factorial();
  }

  bool isPrime() {
    if (this < 2) return false;
    for (int i = 2; i * i <= this; i++) {
      if (this % i == 0) return false;
    }
    return true;
  }
}

/// List 扩展
extension ListExtensions<T> on List<T> {
  T? get secondOrNull => length > 1 ? this[1] : null;

  T? safeGet(int index) {
    return index >= 0 && index < length ? this[index] : null;
  }

  List<List<T>> chunk(int size) {
    List<List<T>> chunks = [];
    for (int i = 0; i < length; i += size) {
      chunks.add(sublist(i, (i + size > length) ? length : i + size));
    }
    return chunks;
  }
}

/// DateTime 扩展
extension DateTimeExtensions on DateTime {
  bool isToday() {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  String format() {
    return '${year}-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}';
  }
}

// ==================== 函数定义 ====================

/// 普通函数
int add(int a, int b) {
  return a + b;
}

/// 可选位置参数
void greet(String name, [String? title]) {
  if (title != null) {
    print('  问候: Hello, $title $name');
  } else {
    print('  问候: Hello, $name');
  }
}

/// 命名参数
void createUser({required String name, required int age, String? email}) {
  print('  用户: $name, 年龄: $age${email != null ? ', 邮箱: $email' : ''}');
}

/// 闭包示例
Function createCounter() {
  int count = 0;
  return () {
    count++;
    return count;
  };
}

/// 泛型函数
void swap<T>(List<T> list, int i, int j) {
  T temp = list[i];
  list[i] = list[j];
  list[j] = temp;
}

/// 异常处理相关函数
int divide(int a, int b) {
  if (b == 0) {
    throw ArgumentError('除数不能为零');
  }
  return a ~/ b;
}

void validateAge(int age) {
  if (age < 0) {
    throw InvalidAgeException('年龄不能为负数');
  }
  if (age > 150) {
    throw InvalidAgeException('年龄不能超过150岁');
  }
}

void riskyOperation() {
  throw Exception('模拟风险操作失败');
}

void processData(String? data) {
  if (data == null) {
    throw DataProcessingException('数据不能为空', 1001);
  }
}

void wrapperFunction() {
  try {
    riskyOperation();
  } catch (e) {
    print('    包装函数捕获异常，重新抛出');
    rethrow;
  }
}

/// 异步函数
Future<String> fetchUserData() async {
  // 模拟网络延迟
  await Future<void>.delayed(Duration(milliseconds: 100));
  return 'User: Alice, Age: 25';
}

Future<String> fetchUserPreferences() async {
  await Future<void>.delayed(Duration(milliseconds: 150));
  return 'Theme: Dark, Language: zh-CN';
}

/// Stream 生成器
Stream<int> generateNumbers() async* {
  for (int i = 1; i <= 5; i++) {
    await Future<void>.delayed(Duration(milliseconds: 50));
    yield i;
  }
}

/// 数学函数实现
double cos(double angle) {
  // 使用泰勒级数近似计算 cos(x)
  double result = 1.0;
  double term = 1.0;

  for (int i = 1; i <= 10; i++) {
    term *= -angle * angle / ((2 * i - 1) * (2 * i));
    result += term;
  }

  return result;
}

double sin(double angle) {
  // 使用泰勒级数近似计算 sin(x)
  double result = angle;
  double term = angle;

  for (int i = 1; i <= 10; i++) {
    term *= -angle * angle / ((2 * i) * (2 * i + 1));
    result += term;
  }

  return result;
}

/// 坐标类
class Coordinates {
  final int x;
  final int y;

  Coordinates(this.x, this.y);
}

Coordinates getCoordinates() => Coordinates(10, 20);

Map<String, dynamic> createUserRecord(String name, int age, String email) {
  return <String, dynamic>{'name': name, 'age': age, 'email': email};
}
