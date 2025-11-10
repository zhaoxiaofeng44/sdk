#include "../../cpp/core/object.h"
#include <iostream>

// 工具宏定义
#define dart_print(value) \
    do { \
        std::cout << (value).toString().getValue() << std::endl; \
    } while(0)

#define dart_int(value) Int(value)
#define dart_double(value) Double(value)
#define dart_bool(value) Bool(value)
#define dart_string(value) String(value)

// ============================================================================
// 类: Person
// ============================================================================

class Person {
public:
  String name;
  Int age;
  Int totalCount = dart_int(0);
  Person(String name, Int age) : name(name), age(age) {
    {
      Person::totalCount = (Person::totalCount + dart_int(1));
}
  }
  
  void introduce() {
    {
      dart_print(dart_string("    你好，我是") + this->name.toString() + dart_string("，今年") + this->age.toString() + dart_string("岁"));
}
  }
  
  void celebrateBirthday() {
    {
      this->age = (this->age + dart_int(1));
      dart_print(dart_string("    🎉 生日快乐！"));
}
  }
  
  void showStatistics() {
    {
      dart_print(dart_string("    总共创建了 ") + Person::totalCount.toString() + dart_string(" 个人"));
}
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
  
  void deposit(Double amount) {
    {
      this->_balance = (this->_balance + amount);
      dart_print(dart_string("    存款 $") + amount.toString() + dart_string("，余额: $") + this->_balance.toString());
}
  }
  
  Bool withdraw(Double amount) {
    {
      if ((this->_balance >= amount)) {
      this->_balance = (this->_balance - amount);
      dart_print(dart_string("    取款 $") + amount.toString() + dart_string("，余额: $") + this->_balance.toString());
      return dart_bool(true);
} else {
      dart_print(dart_string("    余额不足，无法取款 $") + amount.toString());
      return dart_bool(false);
}
}
  }
  
  Double getBalance() {
    return this->_balance;
  }
  
};

// ============================================================================
// 类: Student
// ============================================================================

class Student : public Person {
public:
  String studentId;
  String grade;
  Bool isGraduate;
  Student(String name, Int age, String studentId) : studentId(studentId), grade(dart_string("N/A")), isGraduate(dart_bool(false)), Person(name, age) {
  }
  
  Student(String name, Int age, String studentId, String grade) : studentId(studentId), grade(grade), isGraduate(dart_bool(false)), Person(name, age) {
  }
  
  Student(String name, Int age) : studentId(dart_string("GRAD")), grade(dart_string("A")), isGraduate(dart_bool(true)), Person(name, age) {
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
  
  void makeSound() {
    {
      dart_print(dart_string("    ") + this->name.toString() + dart_string(" 发出声音"));
}
  }
  
  void move() {
    {
      dart_print(dart_string("    ") + this->name.toString() + dart_string(" 在移动"));
}
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
  
  void makeSound() {
    {
      dart_print(dart_string("    ") + this->name.toString() + dart_string(" 汪汪叫"));
}
  }
  
  void move() {
    {
      dart_print(dart_string("    ") + this->name.toString() + dart_string(" 在跑步"));
}
  }
  
  void fetch() {
    {
      dart_print(dart_string("    ") + this->name.toString() + dart_string(" 去捡球"));
}
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
  
  void makeSound() {
    {
      dart_print(dart_string("    ") + this->name.toString() + dart_string(" 喵喵叫"));
}
  }
  
  void move() {
    {
      dart_print(dart_string("    ") + this->name.toString() + dart_string(" 在悄悄走路"));
}
  }
  
  void climb() {
    {
      dart_print(dart_string("    ") + this->name.toString() + dart_string(" 爬树"));
}
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
  
  void introduce() {
    {
      super::introduce();
      dart_print(dart_string("    我的员工ID是") + this->employeeId.toString() + dart_string("，薪水是$") + this->salary.toString());
}
  }
  
  void work() {
    {
      dart_print(dart_string("    ") + this->name.toString() + dart_string(" 正在工作"));
}
  }
  
};

// ============================================================================
// 类: Drivable
// ============================================================================

DART_INTERFACE(Drivable)
  DART_ABSTRACT_METHOD(void, start, ())
  DART_ABSTRACT_METHOD(void, stop, ())
  DART_ABSTRACT_METHOD(Int, maxSpeed, ())
DART_INTERFACE_END

// ============================================================================
// 类: Communicable
// ============================================================================

DART_INTERFACE(Communicable)
  DART_ABSTRACT_METHOD(void, call, (String number))
  DART_ABSTRACT_METHOD(void, sendMessage, (String message))
DART_INTERFACE_END

// ============================================================================
// 类: Car
// ============================================================================

class Car : DART_IMPLEMENTS(Drivable) {
public:
  Car() {
  }
  
  void start() {
    {
      dart_print(dart_string("    汽车启动引擎"));
}
  }
  
  void stop() {
    {
      dart_print(dart_string("    汽车停止引擎"));
}
  }
  
  Int maxSpeed() {
    return dart_int(200);
  }
  
};

// ============================================================================
// 类: Bicycle
// ============================================================================

class Bicycle : DART_IMPLEMENTS(Drivable) {
public:
  Bicycle() {
  }
  
  void start() {
    {
      dart_print(dart_string("    开始骑自行车"));
}
  }
  
  void stop() {
    {
      dart_print(dart_string("    停止骑自行车"));
}
  }
  
  Int maxSpeed() {
    return dart_int(30);
  }
  
};

// ============================================================================
// 类: Smartphone
// ============================================================================

class Smartphone : DART_IMPLEMENTS(Drivable), DART_IMPLEMENTS(Communicable) {
public:
  Smartphone() {
  }
  
  void start() {
    {
      dart_print(dart_string("    智能手机开机"));
}
  }
  
  void stop() {
    {
      dart_print(dart_string("    智能手机关机"));
}
  }
  
  Int maxSpeed() {
    return dart_int(0);
  }
  
  void call(String number) {
    {
      dart_print(dart_string("    拨打电话: ") + number.toString());
}
  }
  
  void sendMessage(String message) {
    {
      dart_print(dart_string("    发送短信: ") + message.toString());
}
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
  
  void perform() {
    {
      dart_print(dart_string("    ") + this->name.toString() + dart_string(" 开始表演"));
}
  }
  
};

// ============================================================================
// 类: Singing
// ============================================================================

DART_INTERFACE(Singing)
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
// 类: Musician
// ============================================================================

class Musician : public _Musician&Performer&Singing {
public:
  Musician(String name) : _Musician&Performer&Singing(name) {
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

class Artist : public _Artist&Performer&Singing&Dancing&Painting {
public:
  Artist(String name) : _Artist&Performer&Singing&Dancing&Painting(name) {
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
// 类: Rectangle
// ============================================================================

class Rectangle : public Shape {
public:
  Double width;
  Double height;
  Rectangle(Double width, Double height) : width(width), height(height) {
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
  Weekday(Int #index, String #name) : _Enum(#index, #name) {
  }
  
  String _enumToString() {
    return dart_string("Weekday.") + this->_name.toString();
  }
  
  Bool isWeekday() {
    return (this->index < dart_int(5));
  }
  
  Bool isWeekend() {
    return (this->index >= dart_int(5));
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
  Color(Int #index, String #name, Int rgb) : rgb(rgb), _Enum(#index, #name) {
  }
  
  String _enumToString() {
    return dart_string("Color.") + this->_name.toString();
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
  OrderStatus(Int #index, String #name) : _Enum(#index, #name) {
  }
  
  String _enumToString() {
    return dart_string("OrderStatus.") + this->_name.toString();
  }
  
};

// ============================================================================
// 类: _Musician&Performer&Singing
// ============================================================================

DART_INTERFACE(_Musician&Performer&Singing)
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
// 类: _Artist&Performer&Singing&Dancing
// ============================================================================

DART_INTERFACE(_Artist&Performer&Singing&Dancing)
DART_INTERFACE_END

// ============================================================================
// 类: _Artist&Performer&Singing&Dancing&Painting
// ============================================================================

DART_INTERFACE(_Artist&Performer&Singing&Dancing&Painting)
DART_INTERFACE_END

void main() {
  {
    dart_print(dart_string("🔥 面向对象编程演示开始"));
    testBasicClasses();
    testInheritance();
    testInterfaces();
    testMixins();
    testAbstractClasses();
    testEnums();
    dart_print(dart_string("✅ 面向对象编程演示完成"));
}
}

void testBasicClasses() {
  {
    dart_print(dart_string("
📌 测试基本类操作"));
    auto person = ObjectPtr<Person>(new Person(dart_string("Alice"), dart_int(25)));
    dart_print(dart_string("  创建对象: ") + person->name.toString() + dart_string(", ") + person->age.toString() + dart_string("岁"));
    person->introduce();
    person->celebrateBirthday();
    dart_print(dart_string("  生日后: ") + person->age.toString() + dart_string("岁"));
    person->name = dart_string("Alice Smith");
    dart_print(dart_string("  修改姓名: ") + person->name.toString());
    auto account = ObjectPtr<BankAccount>(new BankAccount(dart_string("12345"), dart_double(1000.0)));
    account->deposit(dart_double(500.0));
    account->withdraw(dart_double(200.0));
    dart_print(dart_string("  账户余额: $") + account->getBalance().toString());
    dart_print(dart_string("  创建的人数: ") + Person::totalCount.toString());
    Person::showStatistics();
    auto student1 = ObjectPtr<Student>(new Student(dart_string("Bob"), dart_int(20), dart_string("S001")));
    auto student2 = ObjectPtr<Student>(new Student(dart_string("Charlie"), dart_int(19), dart_string("S002"), dart_string("A")));
    auto student3 = ObjectPtr<Student>(new Student(dart_string("David"), dart_int(22)));
    dart_print(dart_string("  学生1: ") + student1->name.toString() + dart_string(", ID: ") + student1->studentId.toString());
    dart_print(dart_string("  学生2: ") + student2->name.toString() + dart_string(", 成绩: ") + student2->grade.toString());
    dart_print(dart_string("  学生3: ") + student3->name.toString() + dart_string(", 毕业生: ") + student3->isGraduate.toString());
}
}

void testInheritance() {
  {
    dart_print(dart_string("
📌 测试继承"));
    auto animal = ObjectPtr<Animal>(new Animal(dart_string("Generic Animal")));
    auto dog = ObjectPtr<Dog>(new Dog(dart_string("Buddy"), dart_string("Golden Retriever")));
    auto cat = ObjectPtr<Cat>(new Cat(dart_string("Whiskers"), dart_string("Persian")));
    auto animals = _GrowableList::_literal3(animal, dog, cat);
    {
    auto :sync-for-iterator = animals->iterator;
    for (; :sync-for-iterator->moveNext(); ) {
    auto animal = :sync-for-iterator->current;
    {
    animal->makeSound();
    animal->move();
    if (dart_is<Dog>(animal)) {
    animal->fetch();
} else if (dart_is<Cat>(animal)) {
    animal->climb();
}
}
}
}
    auto employee = ObjectPtr<Employee>(new Employee(dart_string("John"), dart_int(30), dart_string("E001"), dart_double(50000.0)));
    employee->introduce();
    employee->work();
}
}

void testInterfaces() {
  {
    dart_print(dart_string("
📌 测试接口"));
    auto car = ObjectPtr<Car>(new Car());
    auto bicycle = ObjectPtr<Bicycle>(new Bicycle());
    auto vehicles = _GrowableList::_literal2(car, bicycle);
    {
    auto :sync-for-iterator = vehicles->iterator;
    for (; :sync-for-iterator->moveNext(); ) {
    auto vehicle = :sync-for-iterator->current;
    {
    vehicle->start();
    vehicle->stop();
    dart_print(dart_string("  最高速度: ") + vehicle->maxSpeed.toString() + dart_string(" km/h"));
}
}
}
    auto smartphone = ObjectPtr<Smartphone>(new Smartphone());
    smartphone->start();
    smartphone->stop();
    smartphone->call(dart_string("123-456-7890"));
    smartphone->sendMessage(dart_string("Hello!"));
}
}

void testMixins() {
  {
    dart_print(dart_string("
📌 测试混入 (Mixins)"));
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
}
}

void testAbstractClasses() {
  {
    dart_print(dart_string("
📌 测试抽象类"));
    auto circle = ObjectPtr<Circle>(new Circle(dart_double(5.0)));
    auto rectangle = ObjectPtr<Rectangle>(new Rectangle(dart_double(4.0), dart_double(6.0)));
    auto shapes = _GrowableList::_literal2(circle, rectangle);
    {
    auto :sync-for-iterator = shapes->iterator;
    for (; :sync-for-iterator->moveNext(); ) {
    auto shape = :sync-for-iterator->current;
    {
    dart_print(dart_string("  ") + shape->name.toString() + dart_string(": 面积 = ") + shape->area().toString() + dart_string(", 周长 = ") + shape->perimeter().toString());
    shape->draw();
}
}
}
}
}

void testEnums() {
  {
    dart_print(dart_string("
📌 测试枚举"));
    auto today = ObjectPtr<Weekday>::createConst();
    dart_print(dart_string("  今天是: ") + EnumName|get#name(today).toString());
    dart_print(dart_string("  是工作日吗: ") + today->isWeekday.toString());
    dart_print(dart_string("  是周末吗: ") + today->isWeekend.toString());
    dart_print(dart_string("  所有星期:"));
    {
    auto :sync-for-iterator = List<Weekday>::createConst({ObjectPtr<Weekday>::createConst(), ObjectPtr<Weekday>::createConst(), ObjectPtr<Weekday>::createConst(), ObjectPtr<Weekday>::createConst(), ObjectPtr<Weekday>::createConst(), ObjectPtr<Weekday>::createConst(), ObjectPtr<Weekday>::createConst()})->iterator;
    for (; :sync-for-iterator->moveNext(); ) {
    auto day = :sync-for-iterator->current;
    {
    dart_print(dart_string("    ") + EnumName|get#name(day).toString() + dart_string(" (索引: ") + day->index.toString() + dart_string(")"));
}
}
}
    auto red = ObjectPtr<Color>::createConst();
    auto green = ObjectPtr<Color>::createConst();
    auto blue = ObjectPtr<Color>::createConst();
    dart_print(dart_string("  颜色: ") + EnumName|get#name(red).toString() + dart_string(", RGB: ") + red->rgb.toString());
    dart_print(dart_string("  颜色: ") + EnumName|get#name(green).toString() + dart_string(", RGB: ") + green->rgb.toString());
    dart_print(dart_string("  颜色: ") + EnumName|get#name(blue).toString() + dart_string(", RGB: ") + blue->rgb.toString());
    auto status = ObjectPtr<OrderStatus>::createConst();
    label_40448: switch (status) {
  case ObjectPtr<OrderStatus>::createConst():
    {
    dart_print(dart_string("  订单状态: 待处理"));
    break;
}
  case ObjectPtr<OrderStatus>::createConst():
    {
    dart_print(dart_string("  订单状态: 处理中"));
    break;
}
  case ObjectPtr<OrderStatus>::createConst():
    {
    dart_print(dart_string("  订单状态: 已发货"));
    break;
}
  case ObjectPtr<OrderStatus>::createConst():
    {
    dart_print(dart_string("  订单状态: 已送达"));
    break;
}
}
}
}

// ============================================================================
// 主函数
// ============================================================================

int main() {
  try {
    {
      dart_print(dart_string("🔥 面向对象编程演示开始"));
      testBasicClasses();
      testInheritance();
      testInterfaces();
      testMixins();
      testAbstractClasses();
      testEnums();
      dart_print(dart_string("✅ 面向对象编程演示完成"));
}
    {
      VMServiceEmbedderHooks::cleanup = /* Constant: StaticTearOffConstant */;
      VMServiceEmbedderHooks::createTempDir = /* Constant: StaticTearOffConstant */;
      VMServiceEmbedderHooks::ddsConnected = /* Constant: StaticTearOffConstant */;
      VMServiceEmbedderHooks::ddsDisconnected = /* Constant: StaticTearOffConstant */;
      VMServiceEmbedderHooks::deleteDir = /* Constant: StaticTearOffConstant */;
      VMServiceEmbedderHooks::writeFile = /* Constant: StaticTearOffConstant */;
      VMServiceEmbedderHooks::writeStreamFile = /* Constant: StaticTearOffConstant */;
      VMServiceEmbedderHooks::readFile = /* Constant: StaticTearOffConstant */;
      VMServiceEmbedderHooks::listFiles = /* Constant: StaticTearOffConstant */;
      VMServiceEmbedderHooks::serverInformation = /* Constant: StaticTearOffConstant */;
      VMServiceEmbedderHooks::webServerControl = /* Constant: StaticTearOffConstant */;
      VMServiceEmbedderHooks::acceptNewWebSocketConnections = /* Constant: StaticTearOffConstant */;
      VMServiceEmbedderHooks::serveObservatory = /* Constant: StaticTearOffConstant */;
      VMServiceEmbedderHooks::getResidentCompilerInfoFile = /* Constant: StaticTearOffConstant */;
      server = ObjectPtr<Server>(new Server(VMService::(), _ip, _port, _originCheckDisabled, _authCodesDisabled, _serviceInfoFilename, _enableServicePortFallback));
      if (_autoStart) {
      _toggleWebServer();
}
      _registerSignalHandler();
}
    return 0;
  } catch (const std::exception& e) {
    std::cerr << "Error: " << e.what() << std::endl;
    return 1;
  }
}
