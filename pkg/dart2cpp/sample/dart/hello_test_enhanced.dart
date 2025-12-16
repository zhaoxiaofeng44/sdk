/// Dart 增强语法测试示例
///
/// 包含更多高级Dart语法特性，用于测试Dart到C++的转换
///

void main() {
  print('🔥 Dart 增强语法测试开始');

  // 1. 基本数据类型
  testBasicTypes();

  // 2. 控制流
  testControlFlow();

  // 3. 函数（增强版）
  testEnhancedFunctions();

  // 4. 集合类型（增强版）
  testEnhancedCollections();

  // 5. 类和对象（增强版）
  testEnhancedClasses();

  // 6. 泛型
  testGenerics();

  // 7. 异常处理
  testExceptions();

  // 8. 空安全特性
  testNullSafety();

  print('✅ Dart 增强语法测试完成');
}

/// 测试基本数据类型
void testBasicTypes() {
  print('\n--- 基本数据类型 ---');

  // 数值类型
  int age = 25;
  double price = 99.99;
  int quantity = 10;

  // 字符串类型
  String name = '张三';
  String message = '你好，世界！';

  // 布尔类型
  bool isStudent = true;
  bool isEmployed = false;

  // 字符串操作
  String upperMessage = message.toUpperCase();
  String lowerMessage = message.toLowerCase();
  int messageLength = message.length;

  print('基本类型操作完成');
}

/// 测试控制流
void testControlFlow() {
  print('\n--- 控制流 ---');

  // if-else 语句
  int score = 85;
  if (score >= 90) {
    print('优秀');
  } else if (score >= 80) {
    print('良好');
  } else if (score >= 60) {
    print('及格');
  } else {
    print('不及格');
  }

  // switch 语句
  String grade = 'B';
  switch (grade) {
    case 'A':
      print('优秀');
      break;
    case 'B':
      print('良好');
      break;
    case 'C':
      print('及格');
      break;
    default:
      print('未知等级');
  }

  // for 循环
  print('For 循环:');
  for (int i = 0; i < 5; i++) {
    print('数字: $i');
  }

  // for-in 循环
  List<String> fruits = ['苹果', '香蕉', '橙子'];
  print('For-in 循环:');
  for (String fruit in fruits) {
    print('水果: $fruit');
  }

  // while 循环
  print('While 循环:');
  int count = 3;
  while (count > 0) {
    print('倒计时: $count');
    count--;
  }

  // do-while 循环
  print('Do-while 循环:');
  int number = 1;
  do {
    print('数字: $number');
    number *= 2;
  } while (number <= 10);

  // 条件表达式
  int testAge = 25;
  bool isAdult = testAge >= 18 ? true : false;
  print('成年人: $isAdult');
}

/// 测试增强函数
void testEnhancedFunctions() {
  print('\n--- 增强函数 ---');

  // 带默认参数的函数
  String greet(String name, [String greeting = '你好']) {
    return '$greeting, $name!';
  }

  // 带命名参数的函数
  String createProfile({required String name, int? age, String? city}) {
    String profile = '姓名: $name';
    if (age != null) {
      profile += ', 年龄: $age';
    }
    if (city != null) {
      profile += ', 城市: $city';
    }
    return profile;
  }

  // 高阶函数
  int calculate(int a, int b, int Function(int, int) operation) {
    return operation(a, b);
  }

  // 箭头函数
  int add(int a, int b) => a + b;
  int multiply(int a, int b) => a * b;

  // 调用函数
  print(greet('李四'));
  print(greet('王五', '早上好'));
  print(createProfile(name: '赵六', age: 30, city: '北京'));

  int sum = calculate(5, 3, add);
  int product = calculate(5, 3, multiply);
  print('计算结果: 和=$sum, 积=$product');
}

/// 测试增强集合
void testEnhancedCollections() {
  print('\n--- 增强集合 ---');

  // List 操作
  List<int> numbers = [1, 2, 3, 4, 5];
  List<String> names = ['张三', '李四', '王五'];

  // Map 操作
  Map<String, int> scores = {'张三': 95, '李四': 87, '王五': 92};

  // Set 操作
  Set<String> uniqueNames = {'张三', '李四', '王五'};

  // 集合方法
  print('数字列表长度: ${numbers.length}');
  print('第一个数字: ${numbers.first}');
  print('最后一个数字: ${numbers.last}');

  // 列表变换
  List<int> doubled = numbers.map((n) => n * 2).toList();
  List<int> evens = numbers.where((n) => n % 2 == 0).toList();
  int total = numbers.reduce((a, b) => a + b);

  print('翻倍后的列表: $doubled');
  print('偶数列表: $evens');
  print('数字总和: $total');

  // Map 操作
  print('张三的分数: ${scores['张三']}');
  scores['赵六'] = 88;
  print('更新后的分数: $scores');
}

/// 测试增强类
void testEnhancedClasses() {
  print('\n--- 增强类 ---');

  // 创建对象
  Person person = Person('张三', 25);
  print('人员信息: ${person.toString()}');

  // 使用静态方法
  Person.logCreation();

  // 使用 getter 和 setter
  print('人员姓名: ${person.name}');
  person.name = '李四';
  print('更新后姓名: ${person.name}');

  // 使用抽象类
  Shape circle = Circle(5.0);
  Shape rectangle = Rectangle(4.0, 6.0);

  print('圆形面积: ${circle.area()}');
  print('矩形面积: ${rectangle.area()}');

  // 使用 mixin
  Bird bird = Bird('鹦鹉');
  bird.fly();
  bird.speak();
}

/// 测试泛型
void testGenerics() {
  print('\n--- 泛型 ---');

  // 泛型类
  Box<String> stringBox = Box<String>('Hello');
  Box<int> intBox = Box<int>(42);

  print('字符串盒子内容: ${stringBox.getValue()}');
  print('整数盒子内容: ${intBox.getValue()}');

  // 泛型函数
  List<int> numbers = [1, 2, 3, 4, 5];
  List<String> strings = ['a', 'b', 'c'];

  int firstNumber = getFirst<int>(numbers);
  String firstString = getFirst<String>(strings);

  print('第一个数字: $firstNumber');
  print('第一个字符串: $firstString');
}

/// 测试异常处理
void testExceptions() {
  print('\n--- 异常处理 ---');

  try {
    int result = 10 ~/ 2; // 整数除法
    print('结果: $result');
  } catch (e) {
    print('捕获到异常: $e');
  }

  try {
    validateAge(-5);
  } catch (e) {
    print('年龄验证失败: $e');
  }
}

/// 测试空安全特性
void testNullSafety() {
  print('\n--- 空安全特性 ---');

  // 可空类型
  String? nullableString = 'Hello';
  String? nullString = null;

  // 空值合并操作符
  String nonNull1 = nullableString ?? 'default';
  String nonNull2 = nullString ?? 'default';

  print('空值合并结果: $nonNull1, $nonNull2');

  // 空值安全访问
  List<String>? nullableList = ['a', 'b', 'c'];
  int? length1 = nullableList?.length;
  print('列表长度: $length1');

  // 空值断言
  String definitelyNotNull = nullableString!;
  print('断言非空值: $definitelyNotNull');
}

// ========================
// 增强类定义
// ========================

/// 人员类（增强版）
class Person {
  String _name;
  int _age;

  Person(this._name, this._age);

  // Getter 和 Setter
  String get name => _name;
  set name(String value) => _name = value;

  int get age => _age;
  set age(int value) => _age = value;

  /// 自我介绍
  void introduce() {
    print('大家好，我是 $_name，今年 $_age 岁。');
  }

  /// 静态方法
  static void logCreation() {
    print('创建了一个新的Person实例');
  }

  @override
  String toString() {
    return 'Person{name: $_name, age: $_age}';
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
    return 3.14159 * radius * radius;
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

/// 飞行能力 Mixin
mixin Flyable {
  void fly() {
    print('正在飞行');
  }
}

/// 说话能力 Mixin
mixin Speakable {
  void speak() {
    print('正在说话');
  }
}

/// 鸟类（使用 Mixin）
class Bird with Flyable, Speakable {
  String name;

  Bird(this.name);
}

// ========================
// 泛型定义
// ========================

/// 泛型盒子类
class Box<T> {
  T _value;

  Box(this._value);

  T getValue() => _value;
  void setValue(T value) => _value = value;
}

/// 泛型函数
T getFirst<T>(List<T> list) {
  if (list.isEmpty) {
    throw Exception('列表为空');
  }
  return list[0];
}

// ========================
// 工具函数
// ========================

/// 验证年龄的函数
void validateAge(int age) {
  if (age < 0) {
    throw Exception('年龄不能为负数');
  }
  print('有效年龄: $age');
}
