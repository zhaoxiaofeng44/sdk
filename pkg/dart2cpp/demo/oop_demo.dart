/// 面向对象编程演示
/// 
/// 测试类、继承、接口、混入等面向对象特性

void main() {
  print('🔥 面向对象编程演示开始');
  
  // 1. 基本类操作
  testBasicClasses();
  
  // 2. 继承
  testInheritance();
  
  // 3. 接口
  testInterfaces();
  
  // 4. 混入 (Mixins)
  testMixins();
  
  // 5. 抽象类
  testAbstractClasses();
  
  // 6. 枚举
  testEnums();
  
  print('✅ 面向对象编程演示完成');
}

/// 测试基本类操作
void testBasicClasses() {
  print('\n📌 测试基本类操作');
  
  // 创建对象
  var person = Person('Alice', 25);
  print('  创建对象: ${person.name}, ${person.age}岁');
  
  // 调用方法
  person.introduce();
  person.celebrateBirthday();
  print('  生日后: ${person.age}岁');
  
  // 访问属性
  person.name = 'Alice Smith';
  print('  修改姓名: ${person.name}');
  
  // 私有成员
  var account = BankAccount('12345', 1000.0);
  account.deposit(500.0);
  account.withdraw(200.0);
  print('  账户余额: \$${account.getBalance()}');
  
  // 静态成员
  print('  创建的人数: ${Person.totalCount}');
  Person.showStatistics();
  
  // 构造函数
  var student1 = Student('Bob', 20, 'S001');
  var student2 = Student.withGrade('Charlie', 19, 'S002', 'A');
  var student3 = Student.graduate('David', 22);
  
  print('  学生1: ${student1.name}, ID: ${student1.studentId}');
  print('  学生2: ${student2.name}, 成绩: ${student2.grade}');
  print('  学生3: ${student3.name}, 毕业生: ${student3.isGraduate}');
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
  
  // super 关键字
  var employee = Employee('John', 30, 'E001', 50000);
  employee.introduce();
  employee.work();
}

/// 测试接口
void testInterfaces() {
  print('\n📌 测试接口');
  
  // 实现接口
  var car = Car();
  var bicycle = Bicycle();
  
  List<Drivable> vehicles = [car, bicycle];
  
  for (var vehicle in vehicles) {
    vehicle.start();
    vehicle.stop();
    print('  最高速度: ${vehicle.maxSpeed} km/h');
  }
  
  // 多接口实现
  var smartphone = Smartphone();
  smartphone.start();
  smartphone.stop();
  smartphone.call('123-456-7890');
  smartphone.sendMessage('Hello!');
}

/// 测试混入 (Mixins)
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
  var rectangle = Rectangle(4.0, 6.0);
  
  List<Shape> shapes = [circle, rectangle];
  
  for (var shape in shapes) {
    print('  ${shape.name}: 面积 = ${shape.area()}, 周长 = ${shape.perimeter()}');
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
  
  print('  颜色: ${red.name}, RGB: ${red.rgb}');
  print('  颜色: ${green.name}, RGB: ${green.rgb}');
  print('  颜色: ${blue.name}, RGB: ${blue.rgb}');
  
  // 枚举 switch
  var status = OrderStatus.processing;
  switch (status) {
    case OrderStatus.pending:
      print('  订单状态: 待处理');
      break;
    case OrderStatus.processing:
      print('  订单状态: 处理中');
      break;
    case OrderStatus.shipped:
      print('  订单状态: 已发货');
      break;
    case OrderStatus.delivered:
      print('  订单状态: 已送达');
      break;
  }
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

/// 学生类（演示多种构造函数）
class Student extends Person {
  String studentId;
  String grade;
  bool isGraduate;
  
  // 主构造函数
  Student(String name, int age, this.studentId) 
      : grade = 'N/A', isGraduate = false, super(name, age);
  
  // 命名构造函数
  Student.withGrade(String name, int age, this.studentId, this.grade)
      : isGraduate = false, super(name, age);
  
  Student.graduate(String name, int age)
      : studentId = 'GRAD', grade = 'A', isGraduate = true, super(name, age);
}

// ============================================================================
// 继承示例
// ============================================================================

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
}

/// 狗类
class Dog extends Animal {
  String breed;
  
  Dog(String name, this.breed) : super(name);
  
  @override
  void makeSound() {
    print('    $name 汪汪叫');
  }
  
  @override
  void move() {
    print('    $name 在跑步');
  }
  
  void fetch() {
    print('    $name 去捡球');
  }
}

/// 猫类
class Cat extends Animal {
  String breed;
  
  Cat(String name, this.breed) : super(name);
  
  @override
  void makeSound() {
    print('    $name 喵喵叫');
  }
  
  @override
  void move() {
    print('    $name 在悄悄走路');
  }
  
  void climb() {
    print('    $name 爬树');
  }
}

/// 员工类（演示 super 关键字）
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

// ============================================================================
// 接口示例
// ============================================================================

/// 可驾驶接口
abstract class Drivable {
  void start();
  void stop();
  int get maxSpeed;
}

/// 可通信接口
abstract class Communicable {
  void call(String number);
  void sendMessage(String message);
}

/// 汽车类
class Car implements Drivable {
  @override
  void start() {
    print('    汽车启动引擎');
  }
  
  @override
  void stop() {
    print('    汽车停止引擎');
  }
  
  @override
  int get maxSpeed => 200;
}

/// 自行车类
class Bicycle implements Drivable {
  @override
  void start() {
    print('    开始骑自行车');
  }
  
  @override
  void stop() {
    print('    停止骑自行车');
  }
  
  @override
  int get maxSpeed => 30;
}

/// 智能手机类（多接口实现）
class Smartphone implements Drivable, Communicable {
  @override
  void start() {
    print('    智能手机开机');
  }
  
  @override
  void stop() {
    print('    智能手机关机');
  }
  
  @override
  int get maxSpeed => 0; // 手机不能驾驶
  
  @override
  void call(String number) {
    print('    拨打电话: $number');
  }
  
  @override
  void sendMessage(String message) {
    print('    发送短信: $message');
  }
}

// ============================================================================
// 混入示例
// ============================================================================

/// 表演者基类
class Performer {
  String name;
  
  Performer(this.name);
  
  void perform() {
    print('    $name 开始表演');
  }
}

/// 歌唱混入
mixin Singing {
  void sing() {
    print('    🎵 唱歌');
  }
  
  void playInstrument() {
    print('    🎸 演奏乐器');
  }
}

/// 舞蹈混入
mixin Dancing {
  void dance() {
    print('    💃 跳舞');
  }
}

/// 绘画混入
mixin Painting {
  void paint() {
    print('    🎨 绘画');
  }
}

/// 音乐家类
class Musician extends Performer with Singing {
  Musician(String name) : super(name);
}

/// 舞者类
class Dancer extends Performer with Dancing {
  Dancer(String name) : super(name);
}

/// 艺术家类（多混入）
class Artist extends Performer with Singing, Dancing, Painting {
  Artist(String name) : super(name);
}

// ============================================================================
// 抽象类示例
// ============================================================================

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

/// 矩形类
class Rectangle extends Shape {
  double width;
  double height;
  
  Rectangle(this.width, this.height);
  
  @override
  String get name => '矩形';
  
  @override
  double area() => width * height;
  
  @override
  double perimeter() => 2 * (width + height);
}

// ============================================================================
// 枚举示例
// ============================================================================

/// 基本枚举
enum Weekday {
  monday,
  tuesday,
  wednesday,
  thursday,
  friday,
  saturday,
  sunday;
  
  bool get isWeekday => index < 5;
  bool get isWeekend => index >= 5;
}

/// 增强枚举
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