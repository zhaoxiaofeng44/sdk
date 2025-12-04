/// 面向对象编程测试用例
/// 
/// 测试Dart面向对象特性，包括：
/// - 类和对象
/// - 继承和多态
/// - 接口和抽象类
/// - 混入(Mixins)
/// - 枚举
/// - 构造函数

void main() {
  print('🔥 面向对象编程测试开始');
  
  // 1. 基本类和对象测试
  testBasicClasses();
  
  // 2. 继承测试
  testInheritance();
  
  // 3. 接口测试
  testInterfaces();
  
  // 4. 混入测试
  testMixins();
  
  // 5. 抽象类测试
  testAbstractClasses();
  
  // 6. 枚举测试
  testEnums();
  
  // 7. 构造函数测试
  testConstructors();
  
  print('✅ 面向对象编程测试完成');
}

/// 测试基本类和对象
void testBasicClasses() {
  print('\n📌 测试基本类和对象');
  
  // 创建对象
  var person = Person('Alice', 25);
  print('  创建对象: ${person.name}, ${person.age}岁');
  
  // 调用方法
  person.introduce();
  person.celebrateBirthday();
  print('  生日后: ${person.age}岁');
  
  // 访问和修改属性
  person.name = 'Alice Smith';
  print('  修改姓名: ${person.name}');
  
  // 私有成员测试
  var account = BankAccount('12345', 1000.0);
  account.deposit(500.0);
  account.withdraw(200.0);
  print('  账户余额: \$${account.getBalance()}');
  
  // 静态成员测试
  print('  创建的人数: ${Person.totalCount}');
  Person.showStatistics();
  
  // Getter 和 Setter
  var rectangle = Rectangle(4.0, 6.0);
  print('  矩形面积: ${rectangle.area}');
  print('  矩形周长: ${rectangle.perimeter}');
  
  rectangle.width = 5.0;
  print('  修改宽度后面积: ${rectangle.area}');
}

/// 测试继承
void testInheritance() {
  print('\n📌 测试继承');
  
  // 基类和派生类
  var animal = Animal('Generic Animal');
  var dog = Dog('Buddy', 'Golden Retriever');
  var cat = Cat('Whiskers', 'Persian');
  
  // 多态调用
  List<Animal> animals = [animal, dog, cat];
  
  print('  多态测试:');
  for (var animal in animals) {
    animal.makeSound();
    animal.move();
    
    // 类型检查和转换
    if (animal is Dog) {
      animal.fetch();
    } else if (animal is Cat) {
      animal.climb();
    }
  }
  
  // super 关键字测试
  var employee = Employee('John', 30, 'E001', 50000);
  employee.introduce();
  employee.work();
  
  // 方法重写测试
  print('  方法重写测试:');
  animal.describe();
  dog.describe();
  cat.describe();
}

/// 测试接口
void testInterfaces() {
  print('\n📌 测试接口');
  
  // 实现接口
  var car = Car();
  var bicycle = Bicycle();
  
  List<Drivable> vehicles = [car, bicycle];
  
  print('  接口实现测试:');
  for (var vehicle in vehicles) {
    vehicle.start();
    vehicle.stop();
    print('    最高速度: ${vehicle.maxSpeed} km/h');
  }
  
  // 多接口实现
  var smartphone = Smartphone();
  smartphone.start();
  smartphone.stop();
  smartphone.call('123-456-7890');
  smartphone.sendMessage('Hello!');
}

/// 测试混入
void testMixins() {
  print('\n📌 测试混入 (Mixins)');
  
  var musician = Musician('Alice');
  musician.perform();
  musician.sing();
  musician.playInstrument();
  
  var dancer = Dancer('Bob');
  dancer.perform();
  dancer.dance();
  
  var artist = Artist('Charlie');
  artist.perform();
  artist.sing();
  artist.playInstrument();
  artist.dance();
  artist.paint();
}

/// 测试抽象类
void testAbstractClasses() {
  print('\n📌 测试抽象类');
  
  var circle = Circle(5.0);
  var rectangle = RectangleShape(4.0, 6.0);
  var triangle = Triangle(3.0, 4.0, 5.0);
  
  List<Shape> shapes = [circle, rectangle, triangle];
  
  print('  抽象类实现测试:');
  for (var shape in shapes) {
    print('    ${shape.name}: 面积 = ${shape.area()}, 周长 = ${shape.perimeter()}');
    shape.draw();
  }
}

/// 测试枚举
void testEnums() {
  print('\n📌 测试枚举');
  
  // 基本枚举
  var today = Weekday.monday;
  print('  今天是: ${today.name}');
  
  // 枚举方法
  print('  是工作日吗: ${today.isWeekday}');
  print('  是周末吗: ${today.isWeekend}');
  
  // 枚举遍历
  print('  所有星期:');
  for (var day in Weekday.values) {
    print('    ${day.name} (索引: ${day.index})');
  }
  
  // 增强枚举
  var red = Color.red;
  var green = Color.green;
  var blue = Color.blue;
  
  print('  颜色测试:');
  print('    ${red.name}: RGB = ${red.rgb}');
  print('    ${green.name}: RGB = ${green.rgb}');
  print('    ${blue.name}: RGB = ${blue.rgb}');
  
  // 枚举 switch
  var status = OrderStatus.processing;
  print('  订单状态测试:');
  switch (status) {
    case OrderStatus.pending:
      print('    订单状态: 待处理');
      break;
    case OrderStatus.processing:
      print('    订单状态: 处理中');
      break;
    case OrderStatus.shipped:
      print('    订单状态: 已发货');
      break;
    case OrderStatus.delivered:
      print('    订单状态: 已送达');
      break;
  }
}

/// 测试构造函数
void testConstructors() {
  print('\n📌 测试构造函数');
  
  // 默认构造函数
  var student1 = Student('Bob', 20, 'S001');
  print('  默认构造函数: ${student1.name}, ID: ${student1.studentId}');
  
  // 命名构造函数
  var student2 = Student.withGrade('Charlie', 19, 'S002', 'A');
  print('  命名构造函数: ${student2.name}, 成绩: ${student2.grade}');
  
  var student3 = Student.graduate('David', 22);
  print('  毕业生构造函数: ${student3.name}, 毕业生: ${student3.isGraduate}');
  
  // 工厂构造函数
  var logger1 = Logger('App');
  var logger2 = Logger('App'); // 应该返回同一个实例
  print('  工厂构造函数: 同一实例? ${identical(logger1, logger2)}');
  
  // 重定向构造函数
  var point1 = Point(3, 4);
  var point2 = Point.origin();
  var point3 = Point.fromList([1, 2]);
  
  print('  点坐标: (${point1.x}, ${point1.y})');
  print('  原点: (${point2.x}, ${point2.y})');
  print('  从列表: (${point3.x}, ${point3.y})');
}

// ============================================================================
// 类定义
// ============================================================================

/// 基本人员类
class Person {
  String name;
  int age;
  static int totalCount = 0;
  
  Person(this.name, this.age) {
    totalCount++;
  }
  
  void introduce() {
    print('    你好，我是$name，今年$age岁');
  }
  
  void celebrateBirthday() {
    age++;
    print('    🎉 生日快乐！');
  }
  
  static void showStatistics() {
    print('    总共创建了 $totalCount 个人');
  }
}

/// 银行账户类（演示私有成员）
class BankAccount {
  String accountNumber;
  double _balance; // 私有成员
  
  BankAccount(this.accountNumber, this._balance);
  
  void deposit(double amount) {
    _balance += amount;
    print('    存款 \$${amount}，余额: \$${_balance}');
  }
  
  bool withdraw(double amount) {
    if (_balance >= amount) {
      _balance -= amount;
      print('    取款 \$${amount}，余额: \$${_balance}');
      return true;
    } else {
      print('    余额不足，无法取款 \$${amount}');
      return false;
    }
  }
  
  double getBalance() => _balance;
}

/// 矩形类（演示 Getter 和 Setter）
class Rectangle {
  double _width;
  double _height;
  
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
  double get perimeter => 2 * (_width + _height);
}

/// 动物基类
class Animal {
  String name;
  
  Animal(this.name);
  
  void makeSound() {
    print('    $name 发出声音');
  }
  
  void move() {
    print('    $name 在移动');
  }
  
  void describe() {
    print('    这是一个动物: $name');
  }
}

/// 狗类（继承自动物）
class Dog extends Animal {
  String breed;
  
  Dog(String name, this.breed) : super(name);
  
  @override
  void makeSound() {
    print('    $name 汪汪叫');
  }
  
  @override
  void move() {
    print('    $name 跑来跑去');
  }
  
  @override
  void describe() {
    print('    这是一只狗: $name，品种: $breed');
  }
  
  void fetch() {
    print('    $name 去捡球');
  }
}

/// 猫类（继承自动物）
class Cat extends Animal {
  String breed;
  
  Cat(String name, this.breed) : super(name);
  
  @override
  void makeSound() {
    print('    $name 喵喵叫');
  }
  
  @override
  void move() {
    print('    $name 优雅地走动');
  }
  
  @override
  void describe() {
    print('    这是一只猫: $name，品种: $breed');
  }
  
  void climb() {
    print('    $name 爬树');
  }
}

/// 员工类（继承自人员）
class Employee extends Person {
  String employeeId;
  double salary;
  
  Employee(String name, int age, this.employeeId, this.salary) : super(name, age);
  
  @override
  void introduce() {
    super.introduce();
    print('    我的员工ID是$employeeId，薪水是\$${salary}');
  }
  
  void work() {
    print('    $name 正在工作');
  }
}

/// 可驾驶接口
abstract class Drivable {
  void start();
  void stop();
  int get maxSpeed;
}

/// 汽车类（实现接口）
class Car implements Drivable {
  bool _isRunning = false;
  
  @override
  void start() {
    _isRunning = true;
    print('    汽车启动');
  }
  
  @override
  void stop() {
    _isRunning = false;
    print('    汽车停止');
  }
  
  @override
  int get maxSpeed => 200;
}

/// 自行车类（实现接口）
class Bicycle implements Drivable {
  bool _isMoving = false;
  
  @override
  void start() {
    _isMoving = true;
    print('    自行车开始骑行');
  }
  
  @override
  void stop() {
    _isMoving = false;
    print('    自行车停止');
  }
  
  @override
  int get maxSpeed => 30;
}

/// 可通话接口
abstract class Callable {
  void call(String number);
}

/// 可发消息接口
abstract class Messageable {
  void sendMessage(String message);
}

/// 智能手机类（多接口实现）
class Smartphone implements Drivable, Callable, Messageable {
  bool _isOn = false;
  
  @override
  void start() {
    _isOn = true;
    print('    智能手机开机');
  }
  
  @override
  void stop() {
    _isOn = false;
    print('    智能手机关机');
  }
  
  @override
  int get maxSpeed => 0; // 手机不移动
  
  @override
  void call(String number) {
    print('    拨打电话: $number');
  }
  
  @override
  void sendMessage(String message) {
    print('    发送消息: $message');
  }
}

/// 歌唱混入
mixin Singing {
  void sing() {
    print('    正在唱歌 🎵');
  }
}

/// 演奏混入
mixin Playing {
  void playInstrument() {
    print('    正在演奏乐器 🎹');
  }
}

/// 舞蹈混入
mixin Dancing {
  void dance() {
    print('    正在跳舞 💃');
  }
}

/// 绘画混入
mixin Painting {
  void paint() {
    print('    正在绘画 🎨');
  }
}

/// 表演者基类
class Performer {
  String name;
  
  Performer(this.name);
  
  void perform() {
    print('    $name 开始表演');
  }
}

/// 音乐家类（使用混入）
class Musician extends Performer with Singing, Playing {
  Musician(String name) : super(name);
}

/// 舞者类（使用混入）
class Dancer extends Performer with Dancing {
  Dancer(String name) : super(name);
}

/// 艺术家类（使用多个混入）
class Artist extends Performer with Singing, Playing, Dancing, Painting {
  Artist(String name) : super(name);
}

/// 抽象形状类
abstract class Shape {
  String get name;
  double area();
  double perimeter();
  
  void draw() {
    print('    绘制 $name');
  }
}

/// 圆形类
class Circle extends Shape {
  double radius;
  
  Circle(this.radius);
  
  @override
  String get name => '圆形';
  
  @override
  double area() => 3.14159 * radius * radius;
  
  @override
  double perimeter() => 2 * 3.14159 * radius;
}

/// 矩形形状类
class RectangleShape extends Shape {
  double width;
  double height;
  
  RectangleShape(this.width, this.height);
  
  @override
  String get name => '矩形';
  
  @override
  double area() => width * height;
  
  @override
  double perimeter() => 2 * (width + height);
}

/// 三角形类
class Triangle extends Shape {
  double a, b, c;
  
  Triangle(this.a, this.b, this.c);
  
  @override
  String get name => '三角形';
  
  @override
  double area() {
    double s = (a + b + c) / 2;
    return (s * (s - a) * (s - b) * (s - c)).abs().sqrt();
  }
  
  @override
  double perimeter() => a + b + c;
}

/// 星期枚举
enum Weekday {
  monday,
  tuesday,
  wednesday,
  thursday,
  friday,
  saturday,
  sunday;
  
  bool get isWeekday => index < 5;
  bool get isWeekend => !isWeekday;
}

/// 颜色增强枚举
enum Color {
  red(0xFF0000),
  green(0x00FF00),
  blue(0x0000FF);
  
  const Color(this.rgb);
  final int rgb;
}

/// 订单状态枚举
enum OrderStatus {
  pending,
  processing,
  shipped,
  delivered
}

/// 学生类（演示构造函数）
class Student {
  String name;
  int age;
  String studentId;
  String? grade;
  bool isGraduate;
  
  // 默认构造函数
  Student(this.name, this.age, this.studentId) : 
    grade = null, isGraduate = false;
  
  // 命名构造函数
  Student.withGrade(this.name, this.age, this.studentId, this.grade) : 
    isGraduate = false;
  
  // 命名构造函数
  Student.graduate(this.name, this.age) : 
    studentId = 'GRAD', grade = null, isGraduate = true;
}

/// 日志类（演示工厂构造函数）
class Logger {
  String name;
  static final Map<String, Logger> _cache = {};
  
  Logger._internal(this.name);
  
  factory Logger(String name) {
    return _cache.putIfAbsent(name, () => Logger._internal(name));
  }
}

/// 点类（演示重定向构造函数）
class Point {
  double x;
  double y;
  
  Point(this.x, this.y);
  
  // 重定向到主构造函数
  Point.origin() : this(0, 0);
  
  // 重定向到主构造函数
  Point.fromList(List<double> coords) : this(coords[0], coords[1]);
}

/// 数学扩展（为了 sqrt 方法）
extension MathExtension on double {
  double sqrt() {
    if (this < 0) return 0;
    double x = this;
    double prev = 0;
    while ((x - prev).abs() > 0.0001) {
      prev = x;
      x = (x + this / x) / 2;
    }
    return x;
  }
}
