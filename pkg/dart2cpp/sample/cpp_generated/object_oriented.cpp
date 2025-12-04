#include "dart2cpp.h"

// 工具宏定义

// ============================================================================
// 类: Person
// ============================================================================

class Person {
public:
  String name;
  Int age;
  Int totalCount = dart_int(0);
  Person(String name, Int age) : name(name), age(age) {
    Person::totalCount = (Person::totalCount + dart_int(1));
  }
  
  Nullable introduce() {
    dart_print(dart_concat(dart_string("    你好，我是"), this->name, dart_string("，今年"), this->age, dart_string("岁")));
return Void;
  }
  
  Nullable celebrateBirthday() {
    this->age = (this->age + dart_int(1));
dart_print(dart_string("    🎉 生日快乐！"));
return Void;
  }
  
  Nullable showStatistics() {
    dart_print(dart_concat(dart_string("    总共创建了 "), Person::totalCount, dart_string(" 个人")));
return Void;
  }
  
};

// ============================================================================
// 类: BankAccount
// ============================================================================

class BankAccount {
public:
  String accountNumber;
private:
  Double _balance;
  BankAccount(String accountNumber, Double _balance) : accountNumber(accountNumber), _balance(_balance) {
  }
  
  Nullable deposit(Double amount) {
    this->_balance = (this->_balance + amount);
dart_print(dart_concat(dart_string("    存款 \$"), amount, dart_string("，余额: \$"), this->_balance));
return Void;
  }
  
  Bool withdraw(Double amount) {
    if ((this->_balance >= amount)) {
this->_balance = (this->_balance - amount);
dart_print(dart_concat(dart_string("    取款 \$"), amount, dart_string("，余额: \$"), this->_balance));
return dart_bool(true);
} else {
dart_print(dart_concat(dart_string("    余额不足，无法取款 \$"), amount));
return dart_bool(false);
}
  }
  
  Double getBalance() {
    return this->_balance;
  }
  
};

// ============================================================================
// 类: Rectangle
// ============================================================================

class Rectangle {
private:
  Double _width;
  Double _height;
public:
  Rectangle(Double _width, Double _height) : _width(_width), _height(_height) {
  }
  
  Double width() {
    return this->_width;
  }
  
  Nullable width(Double value) {
    if ((value > dart_int(0))) {
this->_width = value;
};
return Void;
  }
  
  Double height() {
    return this->_height;
  }
  
  Nullable height(Double value) {
    if ((value > dart_int(0))) {
this->_height = value;
};
return Void;
  }
  
  Double area() {
    return (this->_width * this->_height);
  }
  
  Double perimeter() {
    return (dart_int(2) * (this->_width + this->_height));
  }
  
};

// ============================================================================
// 类: Animal
// ============================================================================

class Animal {
public:
  String name;
  Animal(String name) : name(name) {
  }
  
  Nullable makeSound() {
    dart_print(dart_concat(dart_string("    "), this->name, dart_string(" 发出声音")));
return Void;
  }
  
  Nullable move() {
    dart_print(dart_concat(dart_string("    "), this->name, dart_string(" 在移动")));
return Void;
  }
  
  Nullable describe() {
    dart_print(dart_concat(dart_string("    这是一个动物: "), this->name));
return Void;
  }
  
};

// ============================================================================
// 类: Dog
// ============================================================================

class Dog : public Animal {
public:
  String breed;
  Dog(String name, String breed) : breed(breed), Animal(name) {
  }
  
  Nullable makeSound() {
    dart_print(dart_concat(dart_string("    "), this->name, dart_string(" 汪汪叫")));
return Void;
  }
  
  Nullable move() {
    dart_print(dart_concat(dart_string("    "), this->name, dart_string(" 跑来跑去")));
return Void;
  }
  
  Nullable describe() {
    dart_print(dart_concat(dart_string("    这是一只狗: "), this->name, dart_string("，品种: "), this->breed));
return Void;
  }
  
  Nullable fetch() {
    dart_print(dart_concat(dart_string("    "), this->name, dart_string(" 去捡球")));
return Void;
  }
  
};

// ============================================================================
// 类: Cat
// ============================================================================

class Cat : public Animal {
public:
  String breed;
  Cat(String name, String breed) : breed(breed), Animal(name) {
  }
  
  Nullable makeSound() {
    dart_print(dart_concat(dart_string("    "), this->name, dart_string(" 喵喵叫")));
return Void;
  }
  
  Nullable move() {
    dart_print(dart_concat(dart_string("    "), this->name, dart_string(" 优雅地走动")));
return Void;
  }
  
  Nullable describe() {
    dart_print(dart_concat(dart_string("    这是一只猫: "), this->name, dart_string("，品种: "), this->breed));
return Void;
  }
  
  Nullable climb() {
    dart_print(dart_concat(dart_string("    "), this->name, dart_string(" 爬树")));
return Void;
  }
  
};

// ============================================================================
// 类: Employee
// ============================================================================

class Employee : public Person {
public:
  String employeeId;
  Double salary;
  Employee(String name, Int age, String employeeId, Double salary) : employeeId(employeeId), salary(salary), Person(name, age) {
  }
  
  Nullable introduce() {
    super::introduce();
dart_print(dart_concat(dart_string("    我的员工ID是"), this->employeeId, dart_string("，薪水是\$"), this->salary));
return Void;
  }
  
  Nullable work() {
    dart_print(dart_concat(dart_string("    "), this->name, dart_string(" 正在工作")));
return Void;
  }
  
};

// ============================================================================
// 类: Drivable
// ============================================================================

DART_INTERFACE(Drivable)
  DART_ABSTRACT_METHOD(Nullable, start, ())
  DART_ABSTRACT_METHOD(Nullable, stop, ())
  DART_ABSTRACT_METHOD(Int, maxSpeed, ())
DART_INTERFACE_END

// ============================================================================
// 类: Car
// ============================================================================

class Car : DART_IMPLEMENTS(Drivable) {
private:
  Bool _isRunning = dart_bool(false);
public:
  Car() {
  }
  
  Nullable start() {
    this->_isRunning = dart_bool(true);
dart_print(dart_string("    汽车启动"));
return Void;
  }
  
  Nullable stop() {
    this->_isRunning = dart_bool(false);
dart_print(dart_string("    汽车停止"));
return Void;
  }
  
  Int maxSpeed() {
    return dart_int(200);
  }
  
};

// ============================================================================
// 类: Bicycle
// ============================================================================

class Bicycle : DART_IMPLEMENTS(Drivable) {
private:
  Bool _isMoving = dart_bool(false);
public:
  Bicycle() {
  }
  
  Nullable start() {
    this->_isMoving = dart_bool(true);
dart_print(dart_string("    自行车开始骑行"));
return Void;
  }
  
  Nullable stop() {
    this->_isMoving = dart_bool(false);
dart_print(dart_string("    自行车停止"));
return Void;
  }
  
  Int maxSpeed() {
    return dart_int(30);
  }
  
};

// ============================================================================
// 类: Callable
// ============================================================================

DART_INTERFACE(Callable)
  DART_ABSTRACT_METHOD(Nullable, call, (String number))
DART_INTERFACE_END

// ============================================================================
// 类: Messageable
// ============================================================================

DART_INTERFACE(Messageable)
  DART_ABSTRACT_METHOD(Nullable, sendMessage, (String message))
DART_INTERFACE_END

// ============================================================================
// 类: Smartphone
// ============================================================================

class Smartphone : DART_IMPLEMENTS(Drivable), DART_IMPLEMENTS(Callable), DART_IMPLEMENTS(Messageable) {
private:
  Bool _isOn = dart_bool(false);
public:
  Smartphone() {
  }
  
  Nullable start() {
    this->_isOn = dart_bool(true);
dart_print(dart_string("    智能手机开机"));
return Void;
  }
  
  Nullable stop() {
    this->_isOn = dart_bool(false);
dart_print(dart_string("    智能手机关机"));
return Void;
  }
  
  Int maxSpeed() {
    return dart_int(0);
  }
  
  Nullable call(String number) {
    dart_print(dart_concat(dart_string("    拨打电话: "), number));
return Void;
  }
  
  Nullable sendMessage(String message) {
    dart_print(dart_concat(dart_string("    发送消息: "), message));
return Void;
  }
  
};

// ============================================================================
// 类: Singing
// ============================================================================

DART_INTERFACE(Singing)
DART_INTERFACE_END

// ============================================================================
// 类: Playing
// ============================================================================

DART_INTERFACE(Playing)
DART_INTERFACE_END

// ============================================================================
// 类: Dancing
// ============================================================================

DART_INTERFACE(Dancing)
DART_INTERFACE_END

// ============================================================================
// 类: Painting
// ============================================================================

DART_INTERFACE(Painting)
DART_INTERFACE_END

// ============================================================================
// 类: Performer
// ============================================================================

class Performer {
public:
  String name;
  Performer(String name) : name(name) {
  }
  
  Nullable perform() {
    dart_print(dart_concat(dart_string("    "), this->name, dart_string(" 开始表演")));
return Void;
  }
  
};

// ============================================================================
// 类: Musician
// ============================================================================

class Musician : public _Musician&Performer&Singing&Playing {
public:
  Musician(String name) : _Musician&Performer&Singing&Playing(name) {
  }
  
};

// ============================================================================
// 类: Dancer
// ============================================================================

class Dancer : public _Dancer&Performer&Dancing {
public:
  Dancer(String name) : _Dancer&Performer&Dancing(name) {
  }
  
};

// ============================================================================
// 类: Artist
// ============================================================================

class Artist : public _Artist&Performer&Singing&Playing&Dancing&Painting {
public:
  Artist(String name) : _Artist&Performer&Singing&Playing&Dancing&Painting(name) {
  }
  
};

// ============================================================================
// 类: Shape
// ============================================================================

DART_INTERFACE(Shape)
  DART_ABSTRACT_METHOD(String, name, ())
  DART_ABSTRACT_METHOD(Double, area, ())
  DART_ABSTRACT_METHOD(Double, perimeter, ())
DART_INTERFACE_END

// ============================================================================
// 类: Circle
// ============================================================================

class Circle : public Shape {
public:
  Double radius;
  Circle(Double radius) : radius(radius) {
  }
  
  String name() {
    return dart_string("圆形");
  }
  
  Double area() {
    return ((dart_double(3.14159) * this->radius) * this->radius);
  }
  
  Double perimeter() {
    return ((dart_int(2) * dart_double(3.14159)) * this->radius);
  }
  
};

// ============================================================================
// 类: RectangleShape
// ============================================================================

class RectangleShape : public Shape {
public:
  Double width;
  Double height;
  RectangleShape(Double width, Double height) : width(width), height(height) {
  }
  
  String name() {
    return dart_string("矩形");
  }
  
  Double area() {
    return (this->width * this->height);
  }
  
  Double perimeter() {
    return (dart_int(2) * (this->width + this->height));
  }
  
};

// ============================================================================
// 类: Triangle
// ============================================================================

class Triangle : public Shape {
public:
  Double a;
  Double b;
  Double c;
  Triangle(Double a, Double b, Double c) : a(a), b(b), c(c) {
  }
  
  String name() {
    return dart_string("三角形");
  }
  
  Double area() {
    auto s = (((this->a + this->b) + this->c) / dart_int(2));
return MathExtension|sqrt((((s * (s - this->a)) * (s - this->b)) * (s - this->c))->abs());
  }
  
  Double perimeter() {
    return ((this->a + this->b) + this->c);
  }
  
};

// ============================================================================
// 类: Weekday
// ============================================================================

class Weekday : public _Enum {
public:
  Weekday monday = ObjectPtr<Weekday>::createConst();
  Weekday tuesday = ObjectPtr<Weekday>::createConst();
  Weekday wednesday = ObjectPtr<Weekday>::createConst();
  Weekday thursday = ObjectPtr<Weekday>::createConst();
  Weekday friday = ObjectPtr<Weekday>::createConst();
  Weekday saturday = ObjectPtr<Weekday>::createConst();
  Weekday sunday = ObjectPtr<Weekday>::createConst();
  List<Weekday> values = List<Weekday>::createConst({ObjectPtr<Weekday>::createConst(), ObjectPtr<Weekday>::createConst(), ObjectPtr<Weekday>::createConst(), ObjectPtr<Weekday>::createConst(), ObjectPtr<Weekday>::createConst(), ObjectPtr<Weekday>::createConst(), ObjectPtr<Weekday>::createConst()});
  Weekday(Int #index, String #name) : _Enum(_index, _name) {
  }
  
  String _enumToString() {
    return dart_concat(dart_string("Weekday."), this->_name);
  }
  
  Bool isWeekday() {
    return (this->index < dart_int(5));
  }
  
  Bool isWeekend() {
    return !(this->isWeekday);
  }
  
};

// ============================================================================
// 类: Color
// ============================================================================

class Color : public _Enum {
public:
  Color red = ObjectPtr<Color>::createConst();
  Color green = ObjectPtr<Color>::createConst();
  Color blue = ObjectPtr<Color>::createConst();
  Int rgb;
  List<Color> values = List<Color>::createConst({ObjectPtr<Color>::createConst(), ObjectPtr<Color>::createConst(), ObjectPtr<Color>::createConst()});
  Color(Int #index, String #name, Int rgb) : rgb(rgb), _Enum(_index, _name) {
  }
  
  String _enumToString() {
    return dart_concat(dart_string("Color."), this->_name);
  }
  
};

// ============================================================================
// 类: OrderStatus
// ============================================================================

class OrderStatus : public _Enum {
public:
  OrderStatus pending = ObjectPtr<OrderStatus>::createConst();
  OrderStatus processing = ObjectPtr<OrderStatus>::createConst();
  OrderStatus shipped = ObjectPtr<OrderStatus>::createConst();
  OrderStatus delivered = ObjectPtr<OrderStatus>::createConst();
  List<OrderStatus> values = List<OrderStatus>::createConst({ObjectPtr<OrderStatus>::createConst(), ObjectPtr<OrderStatus>::createConst(), ObjectPtr<OrderStatus>::createConst(), ObjectPtr<OrderStatus>::createConst()});
  OrderStatus(Int #index, String #name) : _Enum(_index, _name) {
  }
  
  String _enumToString() {
    return dart_concat(dart_string("OrderStatus."), this->_name);
  }
  
};

// ============================================================================
// 类: Student
// ============================================================================

class Student {
public:
  String name;
  Int age;
  String studentId;
  String grade;
  Bool isGraduate;
  Student(String name, Int age, String studentId) : name(name), age(age), studentId(studentId), grade(Null), isGraduate(dart_bool(false)) {
  }
  
  Student(String name, Int age, String studentId, String grade) : name(name), age(age), studentId(studentId), grade(grade), isGraduate(dart_bool(false)) {
  }
  
  Student(String name, Int age) : name(name), age(age), studentId(dart_string("GRAD")), grade(Null), isGraduate(dart_bool(true)) {
  }
  
};

// ============================================================================
// 类: Logger
// ============================================================================

class Logger {
public:
  String name;
private:
  Map<String, Logger> _cache = Map<String, Logger>::create();
  Logger(String name) : name(name) {
  }
  
  Logger (String name) {
    return Logger::_cache->putIfAbsent(name, [&]() { return ObjectPtr<Logger>(new Logger(name)); });
  }
  
};

// ============================================================================
// 类: Point
// ============================================================================

class Point {
public:
  Double x;
  Double y;
  Point(Double x, Double y) : x(x), y(y) {
  }
  
  Point() {
  }
  
  Point(List<Double> coords) {
  }
  
};

// ============================================================================
// 类: _Musician&Performer&Singing
// ============================================================================

DART_INTERFACE(_Musician&Performer&Singing)
DART_INTERFACE_END

// ============================================================================
// 类: _Musician&Performer&Singing&Playing
// ============================================================================

DART_INTERFACE(_Musician&Performer&Singing&Playing)
DART_INTERFACE_END

// ============================================================================
// 类: _Dancer&Performer&Dancing
// ============================================================================

DART_INTERFACE(_Dancer&Performer&Dancing)
DART_INTERFACE_END

// ============================================================================
// 类: _Artist&Performer&Singing
// ============================================================================

DART_INTERFACE(_Artist&Performer&Singing)
DART_INTERFACE_END

// ============================================================================
// 类: _Artist&Performer&Singing&Playing
// ============================================================================

DART_INTERFACE(_Artist&Performer&Singing&Playing)
DART_INTERFACE_END

// ============================================================================
// 类: _Artist&Performer&Singing&Playing&Dancing
// ============================================================================

DART_INTERFACE(_Artist&Performer&Singing&Playing&Dancing)
DART_INTERFACE_END

// ============================================================================
// 类: _Artist&Performer&Singing&Playing&Dancing&Painting
// ============================================================================

DART_INTERFACE(_Artist&Performer&Singing&Playing&Dancing&Painting)
DART_INTERFACE_END

Nullable testBasicClasses() {
  dart_print(dart_string("\n📌 测试基本类和对象"));
auto person = ObjectPtr<Person>(new Person(dart_string("Alice"), dart_int(25)));
dart_print(dart_concat(dart_string("  创建对象: "), person->name, dart_string(", "), person->age, dart_string("岁")));
person->introduce();
person->celebrateBirthday();
dart_print(dart_concat(dart_string("  生日后: "), person->age, dart_string("岁")));
person->name = dart_string("Alice Smith");
dart_print(dart_concat(dart_string("  修改姓名: "), person->name));
auto account = ObjectPtr<BankAccount>(new BankAccount(dart_string("12345"), dart_double(1000.0)));
account->deposit(dart_double(500.0));
account->withdraw(dart_double(200.0));
dart_print(dart_concat(dart_string("  账户余额: \$"), account->getBalance()));
dart_print(dart_concat(dart_string("  创建的人数: "), Person::totalCount));
Person::showStatistics();
auto rectangle = ObjectPtr<Rectangle>(new Rectangle(dart_double(4.0), dart_double(6.0)));
dart_print(dart_concat(dart_string("  矩形面积: "), rectangle->area));
dart_print(dart_concat(dart_string("  矩形周长: "), rectangle->perimeter));
rectangle->width = dart_double(5.0);
dart_print(dart_concat(dart_string("  修改宽度后面积: "), rectangle->area));
return Void;
}

Nullable testInheritance() {
  dart_print(dart_string("\n📌 测试继承"));
auto animal = ObjectPtr<Animal>(new Animal(dart_string("Generic Animal")));
auto dog = ObjectPtr<Dog>(new Dog(dart_string("Buddy"), dart_string("Golden Retriever")));
auto cat = ObjectPtr<Cat>(new Cat(dart_string("Whiskers"), dart_string("Persian")));
auto animals = dart_literal(animal, dog, cat);
dart_print(dart_string("  多态测试:"));
auto sync_for_iterator = animals->iterator;
for (; sync_for_iterator->moveNext(); ) {
auto animal = sync_for_iterator->current;
animal->makeSound();
animal->move();
if (dart_is<Dog>(animal)) {
animal->fetch();
} else {
if (dart_is<Cat>(animal)) {
animal->climb();
}
}
}
auto employee = ObjectPtr<Employee>(new Employee(dart_string("John"), dart_int(30), dart_string("E001"), dart_double(50000.0)));
employee->introduce();
employee->work();
dart_print(dart_string("  方法重写测试:"));
animal->describe();
dog->describe();
cat->describe();
return Void;
}

Nullable testInterfaces() {
  dart_print(dart_string("\n📌 测试接口"));
auto car = ObjectPtr<Car>(new Car());
auto bicycle = ObjectPtr<Bicycle>(new Bicycle());
auto vehicles = dart_literal(car, bicycle);
dart_print(dart_string("  接口实现测试:"));
auto sync_for_iterator = vehicles->iterator;
for (; sync_for_iterator->moveNext(); ) {
auto vehicle = sync_for_iterator->current;
vehicle->start();
vehicle->stop();
dart_print(dart_concat(dart_string("    最高速度: "), vehicle->maxSpeed, dart_string(" km/h")));
}
auto smartphone = ObjectPtr<Smartphone>(new Smartphone());
smartphone->start();
smartphone->stop();
smartphone->call(dart_string("123-456-7890"));
smartphone->sendMessage(dart_string("Hello!"));
return Void;
}

Nullable testMixins() {
  dart_print(dart_string("\n📌 测试混入 (Mixins)"));
auto musician = ObjectPtr<Musician>(new Musician(dart_string("Alice")));
musician->perform();
musician->sing();
musician->playInstrument();
auto dancer = ObjectPtr<Dancer>(new Dancer(dart_string("Bob")));
dancer->perform();
dancer->dance();
auto artist = ObjectPtr<Artist>(new Artist(dart_string("Charlie")));
artist->perform();
artist->sing();
artist->playInstrument();
artist->dance();
artist->paint();
return Void;
}

Nullable testAbstractClasses() {
  dart_print(dart_string("\n📌 测试抽象类"));
auto circle = ObjectPtr<Circle>(new Circle(dart_double(5.0)));
auto rectangle = ObjectPtr<RectangleShape>(new RectangleShape(dart_double(4.0), dart_double(6.0)));
auto triangle = ObjectPtr<Triangle>(new Triangle(dart_double(3.0), dart_double(4.0), dart_double(5.0)));
auto shapes = dart_literal(circle, rectangle, triangle);
dart_print(dart_string("  抽象类实现测试:"));
auto sync_for_iterator = shapes->iterator;
for (; sync_for_iterator->moveNext(); ) {
auto shape = sync_for_iterator->current;
dart_print(dart_concat(dart_string("    "), shape->name, dart_string(": 面积 = "), shape->area(), dart_string(", 周长 = "), shape->perimeter()));
shape->draw();
};
return Void;
}

Nullable testEnums() {
  dart_print(dart_string("\n📌 测试枚举"));
auto today = ObjectPtr<Weekday>::createConst();
dart_print(dart_concat(dart_string("  今天是: "), EnumName|get#name(today)));
dart_print(dart_concat(dart_string("  是工作日吗: "), today->isWeekday));
dart_print(dart_concat(dart_string("  是周末吗: "), today->isWeekend));
dart_print(dart_string("  所有星期:"));
auto sync_for_iterator = List<Weekday>::createConst({ObjectPtr<Weekday>::createConst(), ObjectPtr<Weekday>::createConst(), ObjectPtr<Weekday>::createConst(), ObjectPtr<Weekday>::createConst(), ObjectPtr<Weekday>::createConst(), ObjectPtr<Weekday>::createConst(), ObjectPtr<Weekday>::createConst()})->iterator;
for (; sync_for_iterator->moveNext(); ) {
auto day = sync_for_iterator->current;
dart_print(dart_concat(dart_string("    "), EnumName|get#name(day), dart_string(" (索引: "), day->index, dart_string(")")));
}
auto red = ObjectPtr<Color>::createConst();
auto green = ObjectPtr<Color>::createConst();
auto blue = ObjectPtr<Color>::createConst();
dart_print(dart_string("  颜色测试:"));
dart_print(dart_concat(dart_string("    "), EnumName|get#name(red), dart_string(": RGB = "), red->rgb));
dart_print(dart_concat(dart_string("    "), EnumName|get#name(green), dart_string(": RGB = "), green->rgb));
dart_print(dart_concat(dart_string("    "), EnumName|get#name(blue), dart_string(": RGB = "), blue->rgb));
auto status = ObjectPtr<OrderStatus>::createConst();
dart_print(dart_string("  订单状态测试:"));
if (status == ObjectPtr<OrderStatus>::createConst()) {
  dart_print(dart_string("    订单状态: 待处理"));
} else if (status == ObjectPtr<OrderStatus>::createConst()) {
  dart_print(dart_string("    订单状态: 处理中"));
} else if (status == ObjectPtr<OrderStatus>::createConst()) {
  dart_print(dart_string("    订单状态: 已发货"));
} else if (status == ObjectPtr<OrderStatus>::createConst()) {
  dart_print(dart_string("    订单状态: 已送达"));
};
return Void;
}

Nullable testConstructors() {
  dart_print(dart_string("\n📌 测试构造函数"));
auto student1 = ObjectPtr<Student>(new Student(dart_string("Bob"), dart_int(20), dart_string("S001")));
dart_print(dart_concat(dart_string("  默认构造函数: "), student1->name, dart_string(", ID: "), student1->studentId));
auto student2 = ObjectPtr<Student>(new Student(dart_string("Charlie"), dart_int(19), dart_string("S002"), dart_string("A")));
dart_print(dart_concat(dart_string("  命名构造函数: "), student2->name, dart_string(", 成绩: "), student2->grade));
auto student3 = ObjectPtr<Student>(new Student(dart_string("David"), dart_int(22)));
dart_print(dart_concat(dart_string("  毕业生构造函数: "), student3->name, dart_string(", 毕业生: "), student3->isGraduate));
auto logger1 = Logger::(dart_string("App"));
auto logger2 = Logger::(dart_string("App"));
dart_print(dart_concat(dart_string("  工厂构造函数: 同一实例? "), identical(logger1, logger2)));
auto point1 = ObjectPtr<Point>(new Point(dart_double(3.0), dart_double(4.0)));
auto point2 = ObjectPtr<Point>(new Point());
auto point3 = ObjectPtr<Point>(new Point(dart_literal(dart_double(1.0), dart_double(2.0))));
dart_print(dart_concat(dart_string("  点坐标: ("), point1->x, dart_string(", "), point1->y, dart_string(")")));
dart_print(dart_concat(dart_string("  原点: ("), point2->x, dart_string(", "), point2->y, dart_string(")")));
dart_print(dart_concat(dart_string("  从列表: ("), point3->x, dart_string(", "), point3->y, dart_string(")")));
return Void;
}

Double MathExtension|sqrt(Double #this) {
  if ((_this < dart_int(0))) {
return dart_double(0.0);
}
auto x = _this;
auto prev = dart_double(0.0);
while (((x - prev)->abs() > dart_double(0.0001))) {
prev = x;
x = ((x + (_this / x)) / dart_int(2));
}
return x;
}

std::function<Double()> MathExtension|get#sqrt(Double #this) {
  return [&]() { return MathExtension|sqrt(_this); };
}

// ============================================================================
// 主函数
// ============================================================================

int main() {
  try {
    dart_print(dart_string("🔥 面向对象编程测试开始"));
testBasicClasses();
testInheritance();
testInterfaces();
testMixins();
testAbstractClasses();
testEnums();
testConstructors();
dart_print(dart_string("✅ 面向对象编程测试完成"));
    return 0;
  } catch (const std::exception& e) {
    std::cerr << "Error: " << e.what() << std::endl;
    return 1;
  }
}
