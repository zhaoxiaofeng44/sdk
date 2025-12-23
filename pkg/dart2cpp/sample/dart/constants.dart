/// 常量处理测试用例
///
/// 测试Dart常量相关特性，包括：
/// - const 常量
/// - final 常量
/// - 静态常量
/// - 编译时常量
/// - 常量构造函数

void main() {
  print('🔥 常量处理测试开始');

  // 1. 基本常量测试
  testBasicConstants();

  // 2. 常量集合测试
  testConstantCollections();

  // 3. 常量构造函数测试
  testConstantConstructors();

  // 4. 静态常量测试
  testStaticConstants();

  // 5. 编译时常量表达式测试
  testCompileTimeExpressions();

  print('✅ 常量处理测试完成');
}

/// 测试基本常量
void testBasicConstants() {
  print('\n📌 测试基本常量');

  // const 常量（编译时常量）
  const int constInt = 42;
  const double constDouble = 3.14159;
  const bool constBool = true;
  const String constString = 'Hello, World!';

  print('  const 常量:');
  print('    constInt: $constInt');
  print('    constDouble: $constDouble');
  print('    constBool: $constBool');
  print('    constString: $constString');

  // final 常量（运行时常量）
  final int finalInt = 100;
  final double finalDouble = 2.71828;
  final bool finalBool = false;
  final String finalString = 'Final String';
  final DateTime finalTime = DateTime.now();

  print('  final 常量:');
  print('    finalInt: $finalInt');
  print('    finalDouble: $finalDouble');
  print('    finalBool: $finalBool');
  print('    finalString: $finalString');
  print('    finalTime: $finalTime');

  // const vs final 区别
  const String compileTime = 'Compile Time';
  final String runTime = 'Run Time: ${DateTime.now().millisecondsSinceEpoch}';

  print('  const vs final:');
  print('    编译时常量: $compileTime');
  print('    运行时常量: $runTime');

  // 常量表达式
  const int a = 10;
  const int b = 20;
  const int sum = a + b;
  const int product = a * b;
  const bool comparison = a < b;
  const String interpolation = 'Sum: $sum';

  print('  常量表达式:');
  print('    sum: $sum');
  print('    product: $product');
  print('    comparison: $comparison');
  print('    interpolation: $interpolation');
}

/// 测试常量集合
void testConstantCollections() {
  print('\n📌 测试常量集合');

  // const 列表
  const List<int> constList = [1, 2, 3, 4, 5];
  const List<String> constStringList = ['apple', 'banana', 'orange'];
  const List<bool> constBoolList = [true, false, true];

  print('  const 列表:');
  print('    constList: $constList');
  print('    constStringList: $constStringList');
  print('    constBoolList: $constBoolList');

  // const 集合
  const Set<int> constSet = {1, 2, 3, 4, 5};
  const Set<String> constStringSet = {'red', 'green', 'blue'};

  print('  const 集合:');
  print('    constSet: $constSet');
  print('    constStringSet: $constStringSet');

  // const 映射
  const Map<String, int> constMap = {
    'one': 1,
    'two': 2,
    'three': 3,
  };

  const Map<String, List<int>> constNestedMap = {
    'evens': [2, 4, 6, 8],
    'odds': [1, 3, 5, 7],
  };

  print('  const 映射:');
  print('    constMap: $constMap');
  print('    constNestedMap: $constNestedMap');

  // 嵌套常量集合
  const List<List<int>> constNestedList = [
    [1, 2, 3],
    [4, 5, 6],
    [7, 8, 9],
  ];

  const Map<String, Map<String, int>> constDeepMap = {
    'scores': {
      'math': 95,
      'english': 87,
    },
    'grades': {
      'A': 90,
      'B': 80,
    },
  };

  print('  嵌套常量集合:');
  print('    constNestedList: $constNestedList');
  print('    constDeepMap: $constDeepMap');

  // 常量集合操作

  const List<int> numbers = [1, 2, 3, 4, 5];
  int firstNumber = numbers[0];
  int listLength = numbers.length;

  print('  常量集合操作:');
  print('    firstNumber: $firstNumber');
  print('    listLength: $listLength');

  // 展开常量
  const List<int> list1 = [1, 2, 3];
  const List<int> list2 = [4, 5, 6];
  const List<int> combined = [...list1, ...list2];

  print('    combined: $combined');
}

/// 测试常量构造函数
void testConstantConstructors() {
  print('\n📌 测试常量构造函数');

  // 基本常量构造函数
  const Point p1 = Point(3, 4);
  const Point p2 = Point(3, 4);
  const Point p3 = Point(5, 6);

  print('  基本常量构造函数:');
  print('    p1: $p1');
  print('    p2: $p2');
  print('    p3: $p3');
  print('    p1 == p2: ${p1 == p2}');
  print('    identical(p1, p2): ${identical(p1, p2)}');

  // 常量对象的不可变性
  print('    p1.x: ${p1.x}, p1.y: ${p1.y}');
  print('    p1.distance: ${p1.distance}');

  // 命名常量构造函数
  const Point origin = Point.origin();
  const Point unitX = Point.unitX();
  const Point unitY = Point.unitY();

  print('  命名常量构造函数:');
  print('    origin: $origin');
  print('    unitX: $unitX');
  print('    unitY: $unitY');

  // 常量工厂构造函数
  Color red = Color.red();
  Color green = Color.green();
  Color blue = Color.blue();

  print('  常量工厂构造函数:');
  print('    red: $red');
  print('    green: $green');
  print('    blue: $blue');

  // 复杂常量对象
  const Rectangle rect = Rectangle(Point(0, 0), Point(10, 5));
  const Circle circle = Circle(Point(5, 5), 3);

  print('  复杂常量对象:');
  print('    rect: $rect');
  print('    circle: $circle');
  print('    rect.area: ${rect.area}');
  print('    circle.area: ${circle.area}');

  // 常量列表中的常量对象
  const List<Point> constPoints = [
    Point(0, 0),
    Point(1, 1),
    Point(2, 2),
  ];

  print('  常量对象列表:');
  print('    constPoints: $constPoints');
}

/// 测试静态常量
void testStaticConstants() {
  print('\n📌 测试静态常量');

  // 类静态常量
  print('  数学常量:');
  print('    PI: ${MathConstants.PI}');
  print('    E: ${MathConstants.E}');
  print('    GOLDEN_RATIO: ${MathConstants.GOLDEN_RATIO}');

  print('  物理常量:');
  print('    SPEED_OF_LIGHT: ${PhysicsConstants.SPEED_OF_LIGHT}');
  print('    GRAVITY: ${PhysicsConstants.GRAVITY}');
  print('    PLANCK_CONSTANT: ${PhysicsConstants.PLANCK_CONSTANT}');

  // 配置常量
  print('  应用配置:');
  print('    APP_NAME: ${AppConfig.APP_NAME}');
  print('    VERSION: ${AppConfig.VERSION}');
  print('    DEBUG_MODE: ${AppConfig.DEBUG_MODE}');
  print('    MAX_RETRY_COUNT: ${AppConfig.MAX_RETRY_COUNT}');

  // 枚举常量
  print('  HTTP状态码:');
  print('    OK: ${HttpStatus.OK}');
  print('    NOT_FOUND: ${HttpStatus.NOT_FOUND}');
  print('    SERVER_ERROR: ${HttpStatus.SERVER_ERROR}');

  // 静态常量集合
  print('  支持的文件类型: ${FileTypes.SUPPORTED_TYPES}');
  print('  默认设置: ${Settings.DEFAULT_SETTINGS}');
}

/// 测试编译时常量表达式
void testCompileTimeExpressions() {
  print('\n📌 测试编译时常量表达式');

  // 算术表达式
  const int base = 10;
  const int exponent = 3;
  const int power = base * base * base; // 手动计算幂
  const double average = (base + exponent) / 2;

  print('  算术表达式:');
  print('    power: $power');
  print('    average: $average');

  // 字符串表达式
  const String firstName = 'John';
  const String lastName = 'Doe';
  const String fullName = firstName + ' ' + lastName;
  const String greeting = 'Hello, $firstName!';
  const int nameLength = firstName.length + lastName.length;

  print('  字符串表达式:');
  print('    fullName: $fullName');
  print('    greeting: $greeting');
  print('    nameLength: $nameLength');

  // 布尔表达式
  const bool isAdult = true;
  const bool hasLicense = false;
  const bool canDrive = isAdult && hasLicense;
  const bool needsPermission = !isAdult || !hasLicense;

  print('  布尔表达式:');
  print('    canDrive: $canDrive');
  print('    needsPermission: $needsPermission');

  // 条件表达式
  const int score = 85;
  const String grade = score >= 90
      ? 'A'
      : score >= 80
          ? 'B'
          : 'C';
  const bool passed = score >= 60;

  print('  条件表达式:');
  print('    grade: $grade');
  print('    passed: $passed');

  // 集合表达式
  const List<int> baseList = [1, 2, 3];
  const List<int> extendedList = [...baseList, 4, 5];
  const Set<String> colors = {'red', 'green', 'blue'};
  const Map<String, int> colorCodes = {
    'red': 0xFF0000,
    'green': 0x00FF00,
    'blue': 0x0000FF,
  };

  print('  集合表达式:');
  print('    extendedList: $extendedList');
  print('    colors: $colors');
  print('    colorCodes: $colorCodes');

  // 复杂常量表达式
  const double radius = 5.0;
  const double pi = 3.14159;
  const double circumference = 2 * pi * radius;
  const double area = pi * radius * radius;

  print('  复杂表达式:');
  print('    circumference: $circumference');
  print('    area: $area');
}

// ============================================================================
// 常量类定义
// ============================================================================

/// 点类（常量构造函数）
class Point {
  final double x;
  final double y;

  const Point(this.x, this.y);

  const Point.origin()
      : x = 0,
        y = 0;
  const Point.unitX()
      : x = 1,
        y = 0;
  const Point.unitY()
      : x = 0,
        y = 1;

  double get distance => (x * x + y * y).sqrt();

  @override
  bool operator ==(Object other) =>
      other is Point && x == other.x && y == other.y;

  @override
  int get hashCode => Object.hash(x, y);

  @override
  String toString() => 'Point($x, $y)';
}

/// 颜色类（常量工厂构造函数）
class Color {
  final int value;

  const Color._(this.value);

  factory Color.red() => Color._(0xFF0000);
  factory Color.green() => Color._(0x00FF00);
  factory Color.blue() => Color._(0x0000FF);

  @override
  String toString() => 'Color(0x${value.toRadixString(16).padLeft(6, '0')})';
}

/// 矩形类
class Rectangle {
  final Point topLeft;
  final Point bottomRight;

  const Rectangle(this.topLeft, this.bottomRight);

  double get width => bottomRight.x - topLeft.x;
  double get height => bottomRight.y - topLeft.y;
  double get area => width * height;

  @override
  String toString() => 'Rectangle($topLeft, $bottomRight)';
}

/// 圆形类
class Circle {
  final Point center;
  final double radius;

  const Circle(this.center, this.radius);

  double get area => 3.14159 * radius * radius;
  double get circumference => 2 * 3.14159 * radius;

  @override
  String toString() => 'Circle($center, $radius)';
}

/// 数学常量
class MathConstants {
  static const double PI = 3.14159265359;
  static const double E = 2.71828182846;
  static const double GOLDEN_RATIO = 1.61803398875;
  static const double SQRT_2 = 1.41421356237;
  static const double SQRT_3 = 1.73205080757;
}

/// 物理常量
class PhysicsConstants {
  static const double SPEED_OF_LIGHT = 299792458; // m/s
  static const double GRAVITY = 9.80665; // m/s²
  static const double PLANCK_CONSTANT = 6.62607015e-34; // J⋅s
  static const double AVOGADRO_NUMBER = 6.02214076e23; // mol⁻¹
}

/// 应用配置
class AppConfig {
  static const String APP_NAME = 'Dart2CPP Test Suite';
  static const String VERSION = '1.0.0';
  static const bool DEBUG_MODE = true;
  static const int MAX_RETRY_COUNT = 3;
  static const Duration TIMEOUT = Duration(seconds: 30);
}

/// HTTP状态码
class HttpStatus {
  static const int OK = 200;
  static const int CREATED = 201;
  static const int BAD_REQUEST = 400;
  static const int UNAUTHORIZED = 401;
  static const int NOT_FOUND = 404;
  static const int SERVER_ERROR = 500;
}

/// 文件类型
class FileTypes {
  static const List<String> SUPPORTED_TYPES = [
    '.dart',
    '.cpp',
    '.h',
    '.txt',
    '.json',
  ];

  static const Map<String, String> MIME_TYPES = {
    '.dart': 'text/plain',
    '.cpp': 'text/x-c++src',
    '.h': 'text/x-chdr',
    '.txt': 'text/plain',
    '.json': 'application/json',
  };
}

/// 设置
class Settings {
  static const Map<String, dynamic> DEFAULT_SETTINGS = {
    'theme': 'light',
    'fontSize': 14,
    'autoSave': true,
    'showLineNumbers': true,
    'tabSize': 2,
  };

  static const List<String> AVAILABLE_THEMES = [
    'light',
    'dark',
    'high-contrast',
  ];
}

/// 数学扩展（为了 sqrt 方法）
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
