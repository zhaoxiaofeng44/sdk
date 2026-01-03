/// 高级特性测试用例
///
/// 测试Dart高级语法特性，包括：
/// - 闭包和高阶函数
/// - 级联操作符
/// - 扩展方法
/// - 操作符重载
/// - 元数据注解

void main() {
  print('🔥 高级特性测试开始');

  // 1. 闭包和高阶函数测试
  testClosuresAndHigherOrder();

  // 2. 级联操作符测试
  testCascadeNotation();

  // 3. 扩展方法测试
  testExtensionMethods();

  // 4. 操作符重载测试
  testOperatorOverloading();

  // 5. 元数据注解测试
  testMetadataAnnotations();

  // 6. 函数式编程测试
  testFunctionalProgramming();

  print('✅ 高级特性测试完成');
}

/// 测试闭包和高阶函数
void testClosuresAndHigherOrder() {
  print('\n📌 测试闭包和高阶函数');

  // 简单闭包
  Function makeAdder(int addBy) {
    return (int i) => i + addBy;
  }

  var add2 = makeAdder(2);
  var add5 = makeAdder(5);

  print('  简单闭包:');
  print('    add2(10): ${add2(10)}');
  print('    add5(10): ${add5(10)}');

  // 计数器闭包
  Function makeCounter() {
    int count = 0;
    return () {
      count++;
      return count;
    };
  }

  var counter = makeCounter();
  print('  计数器闭包:');
  print('    计数: ${counter()}, ${counter()}, ${counter()}');

  // 闭包捕获多个变量
  Function makeMultiplier(int factor) {
    int callCount = 0;
    return (int value) {
      callCount++;
      print('    调用第${callCount}次');
      return value * factor;
    };
  }

  var triple = makeMultiplier(3);
  print('  多变量闭包:');
  print('    triple(5): ${triple(5)}');
  print('    triple(7): ${triple(7)}');

  // 闭包捕获循环变量
  List<Function> functions = [];
  for (int i = 0; i < 3; i++) {
    int captured = i; // 捕获当前值
    functions.add(() => captured);
  }

  print('  循环变量捕获:');
  print('    捕获的值: ${functions[0]()}, ${functions[1]()}, ${functions[2]()}');

  // 高阶函数
  List<int> numbers = [1, 2, 3, 4, 5];

  // 自定义高阶函数
  int result = applyTwice(5, (x) => x * 2);
  print('  高阶函数:');
  print('    applyTwice(5, x*2): $result');

  // 函数组合
  int Function(int) addOne = (x) => x + 1;
  int Function(int) multiplyByTwo = (x) => x * 2;
  int Function(int) composed = compose<int, int, int>(multiplyByTwo, addOne);

  print('    函数组合 (x+1)*2 应用于5: ${composed(5)}');

  // 柯里化
  var curriedAdd = curry((int a, int b) => a + b);
  int Function(int) add10 = curriedAdd(10);

  print('    柯里化加法: ${add10(5)}');
}

/// 测试级联操作符
void testCascadeNotation() {
  print('\n📌 测试级联操作符');

  // 基本级联
  var person = Person('Alice', 25)
    ..name = 'Alice Smith'
    ..age = 26
    ..introduce();

  print('  基本级联:');
  print('    人员信息: ${person.name}, ${person.age}岁');

  // 级联方法调用
  var builder = StringBuilder()
    ..append('Hello')
    ..append(' ')
    ..append('World')
    ..append('!');

  print('  级联方法调用:');
  print('    构建结果: ${builder.toString()}');

  // 嵌套级联
  List<int> numbers = []
    ..add(1)
    ..add(2)
    ..add(3)
    ..addAll([4, 5, 6]);

  print('  嵌套级联:');
  print('    列表内容: $numbers');

  // 条件级联
  var calculator = Calculator()
    ..add(10)
    ..multiply(2);

  if (calculator.value > 15) {
    calculator
      ..subtract(5)
      ..divide(3);
  }

  print('  条件级联:');
  print('    计算结果: ${calculator.value}');

  // 空值级联
  Person? nullablePerson = Person('Bob', 30);
  nullablePerson
    ?..name = 'Bob Johnson'
    ..age = 31
    ..introduce();

  nullablePerson = null;
  nullablePerson
    ?..name = 'Won\'t execute'
    ..introduce();

  print('    空值级联测试完成');
}

/// 测试扩展方法
void testExtensionMethods() {
  print('\n📌 测试扩展方法');

  // 字符串扩展
  String text = 'hello world';
  print('  字符串扩展:');
  print('    首字母大写: ${text.capitalize()}');
  print('    是否为回文: ${text.isPalindrome()}');
  print('    单词数量: ${text.wordCount()}');
  print('    反转: ${text.reverse()}');

  String palindrome = 'racecar';
  print('    "$palindrome" 是回文: ${palindrome.isPalindrome()}');

  // 数字扩展
  int number = 5;
  print('  数字扩展:');
  print('    阶乘: ${number.factorial()}');
  print('    是否为偶数: ${number.isEven}');
  print('    是否为质数: ${number.isPrime()}');
  print('    平方: ${number.squared()}');

  // 列表扩展
  List<int> numbers = [1, 2, 3, 4, 5];
  print('  列表扩展:');
  print('    第二个元素: ${numbers.secondOrNull()}');
  print('    倒数第二个: ${numbers.secondLastOrNull()}');
  print('    随机元素: ${numbers.random()}');

  List<int> empty = [];
  print('    空列表第二个: ${empty.secondOrNull()}');

  // 日期时间扩展
  DateTime now = DateTime.now();
  print('  日期时间扩展:');
  print('    是否为今天: ${now.isToday()}');
  print('    格式化: ${now.formatDate()}');
  print('    添加工作日: ${now.addBusinessDays(5).formatDate()}');

  // 泛型扩展
  var result1 = 42.let((value) => value * 2);
  var result2 = 'hello'.let((value) => value.toUpperCase());

  print('  泛型扩展:');
  print('    let应用于数字: $result1');
  print('    let应用于字符串: $result2');
}

/// 测试操作符重载
void testOperatorOverloading() {
  print('\n📌 测试操作符重载');

  // 向量操作符重载
  var v1 = Vector(3, 4);
  var v2 = Vector(1, 2);

  print('  向量操作符重载:');
  print('    v1: $v1');
  print('    v2: $v2');
  print('    v1 + v2: ${v1 + v2}');
  print('    v1 - v2: ${v1 - v2}');
  print('    v1 * 2: ${v1 * 2}');
  print('    v1 == v2: ${v1 == v2}');
  print('    v1长度: ${v1.length}');

  // 复数操作符重载
  var c1 = Complex(3, 4);
  var c2 = Complex(1, 2);

  print('  复数操作符重载:');
  print('    c1: $c1');
  print('    c2: $c2');
  print('    c1 + c2: ${c1 + c2}');
  print('    c1 - c2: ${c1 - c2}');
  print('    c1 * c2: ${c1 * c2}');
  print('    c1 / c2: ${c1 / c2}');

  // 矩阵操作符重载
  var m1 = Matrix([
    [1, 2],
    [3, 4]
  ]);
  var m2 = Matrix([
    [5, 6],
    [7, 8]
  ]);

  print('  矩阵操作符重载:');
  print('    m1: $m1');
  print('    m2: $m2');
  print('    m1 + m2: ${m1 + m2}');
  print('    m1[0][1]: ${m1[0][1]}');

  // 自定义比较
  var p1 = Point(1, 2);
  var p2 = Point(3, 4);
  var p3 = Point(1, 2);

  print('  点比较:');
  print('    p1 < p2: ${p1 < p2}');
  print('    p1 == p3: ${p1 == p3}');
  print('    p1.hashCode == p3.hashCode: ${p1.hashCode == p3.hashCode}');
}

/// 测试元数据注解
void testMetadataAnnotations() {
  print('\n📌 测试元数据注解');

  // 使用注解的类
  var service = UserService();
  service.getUser('123');
  service.createUser('Alice', 'alice@example.com');
  service.deleteUser('456');

  // 使用注解的方法
  var validator = DataValidator();
  validator.validateEmail('test@example.com');
  validator.validateAge(25);
  validator.validatePassword('secret123');

  print('  注解测试完成 (注解在编译时处理)');
}

/// 测试函数式编程
void testFunctionalProgramming() {
  print('\n📌 测试函数式编程');

  List<int> numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];

  // 链式操作
  var result = numbers
      .where((n) => n % 2 == 0) // 过滤偶数
      .map((n) => n * n) // 平方
      .where((n) => n > 10) // 大于10
      .toList();

  print('  函数式链式操作:');
  print('    偶数平方大于10: $result');

  // 函数组合
  var pipeline = pipe([
    (List<int> list) => list.where((n) => n > 5),
    (Iterable<int> iter) => iter.map((n) => n * 2),
    (Iterable<int> iter) => iter.toList(),
  ]);

  var pipeResult = pipeline(numbers);
  print('    管道处理结果: $pipeResult');

  // 部分应用
  var multiply = (int a, int b) => a * b;
  var double = partial(multiply, 2);

  print('  部分应用:');
  print('    double(5): ${double(5)}');

  // 记忆化
  var fibMemo = memoize(fibonacci);

  print('  记忆化斐波那契:');
  print('    fib(10): ${fibMemo(10)}');
  print('    fib(15): ${fibMemo(15)}');

  // 惰性求值
  var lazyNumbers = generateLazy(1000000);
  var firstFive = lazyNumbers.take(5).toList();

  print('  惰性求值:');
  print('    前5个数: $firstFive');
}

// ============================================================================
// 辅助类和函数定义
// ============================================================================

/// 人员类
class Person {
  String name;
  int age;

  Person(this.name, this.age);

  void introduce() {
    print('    我是$name，今年$age岁');
  }
}

/// 字符串构建器
class StringBuilder {
  final StringBuffer _buffer = StringBuffer();

  StringBuilder append(String text) {
    _buffer.write(text);
    return this;
  }

  @override
  String toString() => _buffer.toString();
}

/// 计算器
class Calculator {
  double value = 0;

  Calculator add(double n) {
    value += n;
    return this;
  }

  Calculator subtract(double n) {
    value -= n;
    return this;
  }

  Calculator multiply(double n) {
    value *= n;
    return this;
  }

  Calculator divide(double n) {
    value /= n;
    return this;
  }
}

/// 向量类（操作符重载）
class Vector {
  final double x, y;

  Vector(this.x, this.y);

  Vector operator +(Vector other) => Vector(x + other.x, y + other.y);
  Vector operator -(Vector other) => Vector(x - other.x, y - other.y);
  Vector operator *(double scalar) => Vector(x * scalar, y * scalar);

  @override
  bool operator ==(Object other) =>
      other is Vector && x == other.x && y == other.y;

  @override
  int get hashCode => Object.hash(x, y);

  double get length => (x * x + y * y).sqrt();

  @override
  String toString() => 'Vector($x, $y)';
}

/// 复数类（操作符重载）
class Complex {
  final double real, imaginary;

  Complex(this.real, this.imaginary);

  Complex operator +(Complex other) =>
      Complex(real + other.real, imaginary + other.imaginary);

  Complex operator -(Complex other) =>
      Complex(real - other.real, imaginary - other.imaginary);

  Complex operator *(Complex other) => Complex(
        real * other.real - imaginary * other.imaginary,
        real * other.imaginary + imaginary * other.real,
      );

  Complex operator /(Complex other) {
    double denominator =
        other.real * other.real + other.imaginary * other.imaginary;
    return Complex(
      (real * other.real + imaginary * other.imaginary) / denominator,
      (imaginary * other.real - real * other.imaginary) / denominator,
    );
  }

  @override
  String toString() => '${real} + ${imaginary}i';
}

/// 矩阵类（操作符重载）
class Matrix {
  final List<List<double>> data;

  Matrix(this.data);

  Matrix operator +(Matrix other) {
    var result = <List<double>>[];
    for (int i = 0; i < data.length; i++) {
      var row = <double>[];
      for (int j = 0; j < data[i].length; j++) {
        row.add(data[i][j] + other.data[i][j]);
      }
      result.add(row);
    }
    return Matrix(result);
  }

  List<double> operator [](int index) => data[index];

  @override
  String toString() => data.toString();
}

/// 点类（比较操作符）
class Point implements Comparable<Point> {
  final double x, y;

  Point(this.x, this.y);

  @override
  int compareTo(Point other) {
    double thisDistance = x * x + y * y;
    double otherDistance = other.x * other.x + other.y * other.y;
    return thisDistance.compareTo(otherDistance);
  }

  bool operator <(Point other) => compareTo(other) < 0;
  bool operator >(Point other) => compareTo(other) > 0;
  bool operator <=(Point other) => compareTo(other) <= 0;
  bool operator >=(Point other) => compareTo(other) >= 0;

  @override
  bool operator ==(Object other) =>
      other is Point && x == other.x && y == other.y;

  @override
  int get hashCode => Object.hash(x, y);
}

/// 用户服务类（注解示例）
class UserService {
  @deprecated
  void getUser(String id) {
    print('    获取用户: $id');
  }

  @override
  void createUser(String name, String email) {
    print('    创建用户: $name, $email');
  }

  @pragma('vm:prefer-inline')
  void deleteUser(String id) {
    print('    删除用户: $id');
  }
}

/// 数据验证器（注解示例）
class DataValidator {
  @requiredTag()
  void validateEmail(String email) {
    print('    验证邮箱: $email');
  }

  @timeout(5000)
  void validateAge(int age) {}

  @requiredTag()
  void validatePassword(String password) {
    print('    验证密码: ${password.replaceAll(RegExp(r'.'), '*')}');
  }
}

// ============================================================================
// 扩展方法定义
// ============================================================================

/// 字符串扩展
extension StringExtensions on String {
  String capitalize() {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1);
  }

  bool isPalindrome() {
    String cleaned = toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '');
    return cleaned == cleaned.split('').reversed.join('');
  }

  int wordCount() {
    return trim().split(RegExp(r'\s+')).where((word) => word.isNotEmpty).length;
  }

  String reverse() {
    return split('').reversed.join('');
  }
}

/// 数字扩展
extension IntExtensions on int {
  int factorial() {
    if (this <= 1) return 1;
    return this * (this - 1).factorial();
  }

  bool isPrime() {
    if (this <= 1) return false;
    if (this <= 3) return true;
    if (this % 2 == 0 || this % 3 == 0) return false;

    for (int i = 5; i * i <= this; i += 6) {
      if (this % i == 0 || this % (i + 2) == 0) return false;
    }
    return true;
  }

  int squared() => this * this;
}

/// 列表扩展
extension ListExtensions<T> on List<T> {
  T? secondOrNull() => length >= 2 ? this[1] : null;
  T? secondLastOrNull() => length >= 2 ? this[length - 2] : null;

  T random() {
    if (isEmpty) throw StateError('Empty list');
    return this[DateTime.now().millisecondsSinceEpoch % length];
  }
}

/// 日期时间扩展
extension DateTimeExtensions on DateTime {
  bool isToday() {
    DateTime now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  String formatDate() {
    return '$year-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}';
  }

  DateTime addBusinessDays(int days) {
    DateTime result = this;
    int addedDays = 0;

    while (addedDays < days) {
      result = result.add(Duration(days: 1));
      if (result.weekday < 6) {
        // 1-5 是工作日
        addedDays++;
      }
    }

    return result;
  }
}

/// 泛型扩展
extension LetExtension<T> on T {
  R let<R>(R Function(T) block) => block(this);
}

/// 数学扩展
extension MathExtension on double {
  double sqrt() {
    if (this < 0) return double.nan;
    double x = this;
    double prev = 0;
    while ((x - prev).abs() > 0.0001) {
      prev = x;
      x = (x + this / x) / 2;
    }
    return x;
  }
}

// ============================================================================
// 函数式编程辅助函数
// ============================================================================

/// 应用两次
R applyTwice<T, R>(T value, R Function(T) func) {
  return func(func(value) as T);
}

/// 函数组合
S Function(T) compose<T, R, S>(S Function(R) f, R Function(T) g) {
  return (T x) => f(g(x));
}

/// 柯里化
Function(T) curry<T, U, R>(R Function(T, U) func) {
  return (T first) => (U second) => func(first, second);
}

/// 管道处理
Function(T) pipe<T>(List<Function> functions) {
  return (T input) {
    dynamic result = input;
    for (var func in functions) {
      result = func(result);
    }
    return result;
  };
}

/// 部分应用
Function(U) partial<T, U, R>(R Function(T, U) func, T first) {
  return (U second) => func(first, second);
}

/// 记忆化
Function memoize(Function func) {
  Map<String, dynamic> cache = {};

  return (dynamic arg) {
    String key = arg.toString();
    if (cache.containsKey(key)) {
      return cache[key];
    }

    dynamic result = func(arg);
    cache[key] = result;
    return result;
  };
}

/// 斐波那契数列
int fibonacci(int n) {
  if (n <= 1) return n;
  return fibonacci(n - 1) + fibonacci(n - 2);
}

/// 惰性生成器
Iterable<int> generateLazy(int max) sync* {
  for (int i = 0; i < max; i++) {
    yield i;
  }
}

// ============================================================================
// 注解定义
// ============================================================================

class requiredTag {
  const requiredTag();
}

class timeout {
  final int milliseconds;
  const timeout(this.milliseconds);
}

class experimental {
  const experimental();
}
