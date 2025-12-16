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
    Person::totalCount = Person::totalCount->operator_add(dart_int(1));
  }
  
  Nullable introduce() {
    dart_print(dart_concat(dart_string("    你好，我是"), (this->name).toString(), dart_string("，今年"), (this->age).toString(), dart_string("岁")));
return Void;
  }
  
  Nullable celebrateBirthday() {
    this->age = this->age->operator_add(dart_int(1));
dart_print(dart_string("    🎉 生日快乐！"));
return Void;
  }
  
  Nullable showStatistics() {
    dart_print(dart_concat(dart_string("    总共创建了 "), (Person::totalCount).toString(), dart_string(" 个人")));
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
    this->_balance = this->_balance->operator_add(amount);
dart_print(dart_concat(dart_string("    存款 \$"), (amount).toString(), dart_string("，余额: \$"), (this->_balance).toString()));
return Void;
  }
  
  Bool withdraw(Double amount) {
    if (this->_balance->operator_greater_equals(amount)) {
this->_balance = this->_balance->operator_sub(amount);
dart_print(dart_concat(dart_string("    取款 \$"), (amount).toString(), dart_string("，余额: \$"), (this->_balance).toString()));
return dart_bool(true);
} else {
dart_print(dart_string("    余额不足，无法取款 \$") + (amount).toString());
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
    if (value->operator_greater(dart_int(0))) {
this->_width = value;
};
return Void;
  }
  
  Double height() {
    return this->_height;
  }
  
  Nullable height(Double value) {
    if (value->operator_greater(dart_int(0))) {
this->_height = value;
};
return Void;
  }
  
  Double area() {
    return this->_width->operator_mul(this->_height);
  }
  
  Double perimeter() {
    return dart_double(2.0)->operator_mul(this->_width->operator_add(this->_height));
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
    dart_print(dart_concat(dart_string("    "), (this->name).toString(), dart_string(" 发出声音")));
return Void;
  }
  
  Nullable move() {
    dart_print(dart_concat(dart_string("    "), (this->name).toString(), dart_string(" 在移动")));
return Void;
  }
  
  Nullable describe() {
    dart_print(dart_string("    这是一个动物: ") + (this->name).toString());
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
    dart_print(dart_concat(dart_string("    "), (this->name).toString(), dart_string(" 汪汪叫")));
return Void;
  }
  
  Nullable move() {
    dart_print(dart_concat(dart_string("    "), (this->name).toString(), dart_string(" 跑来跑去")));
return Void;
  }
  
  Nullable describe() {
    dart_print(dart_concat(dart_string("    这是一只狗: "), (this->name).toString(), dart_string("，品种: "), (this->breed).toString()));
return Void;
  }
  
  Nullable fetch() {
    dart_print(dart_concat(dart_string("    "), (this->name).toString(), dart_string(" 去捡球")));
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
    dart_print(dart_concat(dart_string("    "), (this->name).toString(), dart_string(" 喵喵叫")));
return Void;
  }
  
  Nullable move() {
    dart_print(dart_concat(dart_string("    "), (this->name).toString(), dart_string(" 优雅地走动")));
return Void;
  }
  
  Nullable describe() {
    dart_print(dart_concat(dart_string("    这是一只猫: "), (this->name).toString(), dart_string("，品种: "), (this->breed).toString()));
return Void;
  }
  
  Nullable climb() {
    dart_print(dart_concat(dart_string("    "), (this->name).toString(), dart_string(" 爬树")));
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
    this->introduce();
dart_print(dart_concat(dart_string("    我的员工ID是"), (this->employeeId).toString(), dart_string("，薪水是\$"), (this->salary).toString()));
return Void;
  }
  
  Nullable work() {
    dart_print(dart_concat(dart_string("    "), (this->name).toString(), dart_string(" 正在工作")));
return Void;
  }
  
};

// ============================================================================
// 类: Drivable
// ============================================================================

class Drivable {
public:
  virtual ~Drivable() = default;
  
  virtual Nullable start() = 0;
  virtual Nullable stop() = 0;
  virtual Int maxSpeed() = 0;
};

// ============================================================================
// 类: Car
// ============================================================================

class Car : virtual public Drivable {
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

class Bicycle : virtual public Drivable {
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

class Callable {
public:
  virtual ~Callable() = default;
  
  virtual Nullable call(String number) = 0;
};

// ============================================================================
// 类: Messageable
// ============================================================================

class Messageable {
public:
  virtual ~Messageable() = default;
  
  virtual Nullable sendMessage(String message) = 0;
};

// ============================================================================
// 类: Smartphone
// ============================================================================

class Smartphone : virtual public Drivable, virtual public Callable, virtual public Messageable {
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
    dart_print(dart_string("    拨打电话: ") + (number).toString());
return Void;
  }
  
  Nullable sendMessage(String message) {
    dart_print(dart_string("    发送消息: ") + (message).toString());
return Void;
  }
  
};

// ============================================================================
// 类: Singing
// ============================================================================

class Singing {
public:
  virtual ~Singing() = default;
  
  Nullable sing() {
    dart_print(dart_string("    正在唱歌 🎵"));
return Void;
  }
  
};

// ============================================================================
// 类: Playing
// ============================================================================

class Playing {
public:
  virtual ~Playing() = default;
  
  Nullable playInstrument() {
    dart_print(dart_string("    正在演奏乐器 🎹"));
return Void;
  }
  
};

// ============================================================================
// 类: Dancing
// ============================================================================

class Dancing {
public:
  virtual ~Dancing() = default;
  
  Nullable dance() {
    dart_print(dart_string("    正在跳舞 💃"));
return Void;
  }
  
};

// ============================================================================
// 类: Painting
// ============================================================================

class Painting {
public:
  virtual ~Painting() = default;
  
  Nullable paint() {
    dart_print(dart_string("    正在绘画 🎨"));
return Void;
  }
  
};

// ============================================================================
// 类: Performer
// ============================================================================

class Performer {
public:
  String name;
  Performer(String name) : name(name) {
  }
  
  Nullable perform() {
    dart_print(dart_concat(dart_string("    "), (this->name).toString(), dart_string(" 开始表演")));
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

class Shape {
public:
  virtual ~Shape() = default;
  
  virtual String name() = 0;
  virtual Double area() = 0;
  virtual Double perimeter() = 0;
  Nullable draw() {
    dart_print(dart_string("    绘制 ") + (this->name()).toString());
return Void;
  }
  
};

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
    return dart_double(3.14159)->operator_mul(this->radius)->operator_mul(this->radius);
  }
  
  Double perimeter() {
    return dart_double(2.0)->operator_mul(dart_double(3.14159))->operator_mul(this->radius);
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
    return this->width->operator_mul(this->height);
  }
  
  Double perimeter() {
    return dart_double(2.0)->operator_mul(this->width->operator_add(this->height));
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
    auto s = this->a->operator_add(this->b)->operator_add(this->c)->operator_div(dart_double(2.0));
return MathExtension::sqrt(s->operator_mul(s->operator_sub(this->a))->operator_mul(s->operator_sub(this->b))->operator_mul(s->operator_sub(this->c))->abs());
  }
  
  Double perimeter() {
    return this->a->operator_add(this->b)->operator_add(this->c);
  }
  
};

// ============================================================================
// 类: Weekday
// ============================================================================

class Weekday : public _Enum {
public:
  ObjectPtr<Weekday> monday = ObjectPtr<Weekday>::createConst();
  ObjectPtr<Weekday> tuesday = ObjectPtr<Weekday>::createConst();
  ObjectPtr<Weekday> wednesday = ObjectPtr<Weekday>::createConst();
  ObjectPtr<Weekday> thursday = ObjectPtr<Weekday>::createConst();
  ObjectPtr<Weekday> friday = ObjectPtr<Weekday>::createConst();
  ObjectPtr<Weekday> saturday = ObjectPtr<Weekday>::createConst();
  ObjectPtr<Weekday> sunday = ObjectPtr<Weekday>::createConst();
  ObjectPtr<List<ObjectPtr<Weekday>>> values = List<ObjectPtr<Weekday>>::createConst({ObjectPtr<Weekday>::createConst(), ObjectPtr<Weekday>::createConst(), ObjectPtr<Weekday>::createConst(), ObjectPtr<Weekday>::createConst(), ObjectPtr<Weekday>::createConst(), ObjectPtr<Weekday>::createConst(), ObjectPtr<Weekday>::createConst()});
  Weekday(Int _index, String _name) : _Enum(index, name) {
  }
  
  String _enumToString() {
    return dart_string("Weekday.") + (this->_name).toString();
  }
  
  Bool isWeekday() {
    return this->index->operator_less(dart_int(5));
  }
  
  Bool isWeekend() {
    return !(this->isWeekday());
  }
  
};

// ============================================================================
// 类: Color
// ============================================================================

class Color : public _Enum {
public:
  ObjectPtr<Color> red = ObjectPtr<Color>::createConst();
  ObjectPtr<Color> green = ObjectPtr<Color>::createConst();
  ObjectPtr<Color> blue = ObjectPtr<Color>::createConst();
  Int rgb;
  ObjectPtr<List<ObjectPtr<Color>>> values = List<ObjectPtr<Color>>::createConst({ObjectPtr<Color>::createConst(), ObjectPtr<Color>::createConst(), ObjectPtr<Color>::createConst()});
  Color(Int _index, String _name, Int rgb) : rgb(rgb), _Enum(index, name) {
  }
  
  String _enumToString() {
    return dart_string("Color.") + (this->_name).toString();
  }
  
};

// ============================================================================
// 类: OrderStatus
// ============================================================================

class OrderStatus : public _Enum {
public:
  ObjectPtr<OrderStatus> pending = ObjectPtr<OrderStatus>::createConst();
  ObjectPtr<OrderStatus> processing = ObjectPtr<OrderStatus>::createConst();
  ObjectPtr<OrderStatus> shipped = ObjectPtr<OrderStatus>::createConst();
  ObjectPtr<OrderStatus> delivered = ObjectPtr<OrderStatus>::createConst();
  ObjectPtr<List<ObjectPtr<OrderStatus>>> values = List<ObjectPtr<OrderStatus>>::createConst({ObjectPtr<OrderStatus>::createConst(), ObjectPtr<OrderStatus>::createConst(), ObjectPtr<OrderStatus>::createConst(), ObjectPtr<OrderStatus>::createConst()});
  OrderStatus(Int _index, String _name) : _Enum(index, name) {
  }
  
  String _enumToString() {
    return dart_string("OrderStatus.") + (this->_name).toString();
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
  ObjectPtr<Map<String, ObjectPtr<Logger>>> _cache = Map<String, ObjectPtr<Logger>>::create();
  Logger(String name) : name(name) {
  }
  
  static ObjectPtr<Logger> create(String name) {
    return Logger::_cache->putIfAbsent(name, makeFunction([&]() { return ObjectPtr<Logger>(new Logger(name)); }));
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
  
  Point(ObjectPtr<List<Double>> coords) {
  }
  
};

// ============================================================================
// 类: _Musician&Performer&Singing
// ============================================================================

class _Musician&Performer&Singing : public Performer, virtual public Singing {
public:
  virtual ~_Musician&Performer&Singing() = default;
  
  Nullable sing() {
    dart_print(dart_string("    正在唱歌 🎵"));
return Void;
  }
  
};

// ============================================================================
// 类: _Musician&Performer&Singing&Playing
// ============================================================================

class _Musician&Performer&Singing&Playing : public _Musician&Performer&Singing, virtual public Playing {
public:
  virtual ~_Musician&Performer&Singing&Playing() = default;
  
  Nullable playInstrument() {
    dart_print(dart_string("    正在演奏乐器 🎹"));
return Void;
  }
  
};

// ============================================================================
// 类: _Dancer&Performer&Dancing
// ============================================================================

class _Dancer&Performer&Dancing : public Performer, virtual public Dancing {
public:
  virtual ~_Dancer&Performer&Dancing() = default;
  
  Nullable dance() {
    dart_print(dart_string("    正在跳舞 💃"));
return Void;
  }
  
};

// ============================================================================
// 类: _Artist&Performer&Singing
// ============================================================================

class _Artist&Performer&Singing : public Performer, virtual public Singing {
public:
  virtual ~_Artist&Performer&Singing() = default;
  
  Nullable sing() {
    dart_print(dart_string("    正在唱歌 🎵"));
return Void;
  }
  
};

// ============================================================================
// 类: _Artist&Performer&Singing&Playing
// ============================================================================

class _Artist&Performer&Singing&Playing : public _Artist&Performer&Singing, virtual public Playing {
public:
  virtual ~_Artist&Performer&Singing&Playing() = default;
  
  Nullable playInstrument() {
    dart_print(dart_string("    正在演奏乐器 🎹"));
return Void;
  }
  
};

// ============================================================================
// 类: _Artist&Performer&Singing&Playing&Dancing
// ============================================================================

class _Artist&Performer&Singing&Playing&Dancing : public _Artist&Performer&Singing&Playing, virtual public Dancing {
public:
  virtual ~_Artist&Performer&Singing&Playing&Dancing() = default;
  
  Nullable dance() {
    dart_print(dart_string("    正在跳舞 💃"));
return Void;
  }
  
};

// ============================================================================
// 类: _Artist&Performer&Singing&Playing&Dancing&Painting
// ============================================================================

class _Artist&Performer&Singing&Playing&Dancing&Painting : public _Artist&Performer&Singing&Playing&Dancing, virtual public Painting {
public:
  virtual ~_Artist&Performer&Singing&Playing&Dancing&Painting() = default;
  
  Nullable paint() {
    dart_print(dart_string("    正在绘画 🎨"));
return Void;
  }
  
};

// ============================================================================
// Extension: MathExtension
// ============================================================================

namespace MathExtension {
  inline Double MathExtension::sqrt(const Double& self, Double _this) {
    if (self.operator_less(dart_int(0))) {
return dart_double(0.0);
}
auto x = this;
auto prev = dart_double(0.0);
while (x->operator_sub(prev)->abs()->operator_greater(dart_double(0.0001))) {
prev = x;
x = x->operator_add(self.operator_div(x))->operator_div(dart_double(2.0));
}
return x;
  }
  
} // namespace MathExtension

Nullable testBasicClasses();
Nullable testInheritance();
Nullable testInterfaces();
Nullable testMixins();
Nullable testAbstractClasses();
Nullable testEnums();
Nullable testConstructors();
Double MathExtension::sqrt(Double _this);
ObjectPtr<TypedFunction<std::function<Double()>, Double>> MathExtension::get_sqrt(Double _this);
Nullable testBasicClasses() {
  dart_print(dart_string("\n📌 测试基本类和对象"));
auto person = ObjectPtr<Person>(new Person(dart_string("Alice"), dart_int(25)));
dart_print(dart_concat(dart_string("  创建对象: "), (person->name).toString(), dart_string(", "), (person->age).toString(), dart_string("岁")));
person->introduce();
person->celebrateBirthday();
dart_print(dart_concat(dart_string("  生日后: "), (person->age).toString(), dart_string("岁")));
person->name = dart_string("Alice Smith");
dart_print(dart_string("  修改姓名: ") + (person->name).toString());
auto account = ObjectPtr<BankAccount>(new BankAccount(dart_string("12345"), dart_double(1000.0)));
account->deposit(dart_double(500.0));
account->withdraw(dart_double(200.0));
dart_print(dart_string("  账户余额: \$") + (account->getBalance()).toString());
dart_print(dart_string("  创建的人数: ") + (Person::totalCount).toString());
Person::showStatistics();
auto rectangle = ObjectPtr<Rectangle>(new Rectangle(dart_double(4.0), dart_double(6.0)));
dart_print(dart_string("  矩形面积: ") + (rectangle->area()).toString());
dart_print(dart_string("  矩形周长: ") + (rectangle->perimeter()).toString());
rectangle->set_width(dart_double(5.0));
dart_print(dart_string("  修改宽度后面积: ") + (rectangle->area()).toString());
return Void;
}

Nullable testInheritance() {
  dart_print(dart_string("\n📌 测试继承"));
auto animal = ObjectPtr<Animal>(new Animal(dart_string("Generic Animal")));
auto dog = ObjectPtr<Dog>(new Dog(dart_string("Buddy"), dart_string("Golden Retriever")));
auto cat = ObjectPtr<Cat>(new Cat(dart_string("Whiskers"), dart_string("Persian")));
auto animals = _GrowableList::_literal3(animal, dog, cat);
dart_print(dart_string("  多态测试:"));
auto sync_for_iterator = animals->iterator();
for (; sync_for_iterator->hasNext(); ) {
auto animal = sync_for_iterator->next();
animal->makeSound();
animal->move();
if (dart_is<ObjectPtr<Dog>>(animal)) {
animal->fetch();
} else {
if (dart_is<ObjectPtr<Cat>>(animal)) {
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
auto vehicles = _GrowableList::_literal2(car, bicycle);
dart_print(dart_string("  接口实现测试:"));
auto sync_for_iterator = vehicles->iterator();
for (; sync_for_iterator->hasNext(); ) {
auto vehicle = sync_for_iterator->next();
vehicle->start();
vehicle->stop();
dart_print(dart_concat(dart_string("    最高速度: "), (vehicle->maxSpeed()).toString(), dart_string(" km/h")));
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
auto shapes = _GrowableList::_literal3(circle, rectangle, triangle);
dart_print(dart_string("  抽象类实现测试:"));
auto sync_for_iterator = shapes->iterator();
for (; sync_for_iterator->hasNext(); ) {
auto shape = sync_for_iterator->next();
dart_print(dart_concat(dart_string("    "), (shape->name()).toString(), dart_string(": 面积 = "), (shape->area()).toString(), dart_string(", 周长 = "), (shape->perimeter()).toString()));
shape->draw();
};
return Void;
}

Nullable testEnums() {
  dart_print(dart_string("\n📌 测试枚举"));
auto today = ObjectPtr<Weekday>::createConst();
dart_print(dart_string("  今天是: ") + (EnumName|get_name(today)).toString());
dart_print(dart_string("  是工作日吗: ") + (today->isWeekday()).toString());
dart_print(dart_string("  是周末吗: ") + (today->isWeekend()).toString());
dart_print(dart_string("  所有星期:"));
auto sync_for_iterator = List<ObjectPtr<Weekday>>::createConst({ObjectPtr<Weekday>::createConst(), ObjectPtr<Weekday>::createConst(), ObjectPtr<Weekday>::createConst(), ObjectPtr<Weekday>::createConst(), ObjectPtr<Weekday>::createConst(), ObjectPtr<Weekday>::createConst(), ObjectPtr<Weekday>::createConst()})->iterator();
for (; sync_for_iterator->hasNext(); ) {
auto day = sync_for_iterator->next();
dart_print(dart_concat(dart_string("    "), (EnumName|get_name(day)).toString(), dart_string(" (索引: "), (day->index).toString(), dart_string(")")));
}
auto red = ObjectPtr<Color>::createConst();
auto green = ObjectPtr<Color>::createConst();
auto blue = ObjectPtr<Color>::createConst();
dart_print(dart_string("  颜色测试:"));
dart_print(dart_concat(dart_string("    "), (EnumName|get_name(red)).toString(), dart_string(": RGB = "), (red->rgb).toString()));
dart_print(dart_concat(dart_string("    "), (EnumName|get_name(green)).toString(), dart_string(": RGB = "), (green->rgb).toString()));
dart_print(dart_concat(dart_string("    "), (EnumName|get_name(blue)).toString(), dart_string(": RGB = "), (blue->rgb).toString()));
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
dart_print(dart_concat(dart_string("  默认构造函数: "), (student1->name).toString(), dart_string(", ID: "), (student1->studentId).toString()));
auto student2 = ObjectPtr<Student>(new Student(dart_string("Charlie"), dart_int(19), dart_string("S002"), dart_string("A")));
dart_print(dart_concat(dart_string("  命名构造函数: "), (student2->name).toString(), dart_string(", 成绩: "), (student2->grade).toString()));
auto student3 = ObjectPtr<Student>(new Student(dart_string("David"), dart_int(22)));
dart_print(dart_concat(dart_string("  毕业生构造函数: "), (student3->name).toString(), dart_string(", 毕业生: "), (student3->isGraduate).toString()));
auto logger1 = Logger::create(dart_string("App"));
auto logger2 = Logger::create(dart_string("App"));
dart_print(dart_string("  工厂构造函数: 同一实例? ") + (identical(logger1, logger2)).toString());
auto point1 = ObjectPtr<Point>(new Point(dart_double(3.0), dart_double(4.0)));
auto point2 = ObjectPtr<Point>(new Point());
auto point3 = ObjectPtr<Point>(new Point(_GrowableList::_literal2(dart_double(1.0), dart_double(2.0))));
dart_print(dart_concat(dart_string("  点坐标: ("), (point1->x).toString(), dart_string(", "), (point1->y).toString(), dart_string(")")));
dart_print(dart_concat(dart_string("  原点: ("), (point2->x).toString(), dart_string(", "), (point2->y).toString(), dart_string(")")));
dart_print(dart_concat(dart_string("  从列表: ("), (point3->x).toString(), dart_string(", "), (point3->y).toString(), dart_string(")")));
return Void;
}

Double MathExtension_sqrt(Double this) {
  if (this->operator_less(dart_int(0))) {
return dart_double(0.0);
}
auto x = this;
auto prev = dart_double(0.0);
while (x->operator_sub(prev)->abs()->operator_greater(dart_double(0.0001))) {
prev = x;
x = x->operator_add(this->operator_div(x))->operator_div(dart_double(2.0));
}
return x;
}

ObjectPtr<TypedFunction<std::function<Double()>, Double>> MathExtension_get_sqrt(Double this) {
  return makeFunction([&]() { return MathExtension::sqrt(this); });
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
