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
  Person(String name, Int age) : name(name), age(age) {
  }
  
  void introduce() {
    {
      dart_print(dart_string("    我是 ") + this->name.toString() + dart_string("，今年 ") + this->age.toString() + dart_string(" 岁"));
}
  }
  
};

// ============================================================================
// 类: BankAccount
// ============================================================================

class BankAccount {
private:
  String _accountNumber;
  Double _balance;
public:
  BankAccount(String _accountNumber, Double _balance) : _accountNumber(_accountNumber), _balance(_balance) {
  }
  
  void deposit(Double amount) {
    {
      this->_balance = (this->_balance + amount);
      dart_print(dart_string("    存入 ") + amount.toString() + dart_string("，余额: ") + this->_balance.toString());
}
  }
  
  Bool withdraw(Double amount) {
    {
      if ((this->_balance >= amount)) {
      this->_balance = (this->_balance - amount);
      dart_print(dart_string("    取出 ") + amount.toString() + dart_string("，余额: ") + this->_balance.toString());
      return dart_bool(true);
} else {
      dart_print(dart_string("    余额不足"));
      return dart_bool(false);
}
}
  }
  
  Double getBalance() {
    return this->_balance;
  }
  
};

// ============================================================================
// 类: Point
// ============================================================================

class Point {
public:
  Double x;
  Double y;
  Int count = dart_int(0);
  Point(Double x, Double y) : x(x), y(y) {
    {
      Point::count = (Point::count + dart_int(1));
}
  }
  
  Point() {
  }
  
  Point(Double radius, Double angle) {
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
  
  void width(Double value) {
    return this->_width = value;
  }
  
  Double height() {
    return this->_height;
  }
  
  void height(Double value) {
    return this->_height = value;
  }
  
  Double area() {
    return (this->_width * this->_height);
  }
  
};

// ============================================================================
// 类: Student
// ============================================================================

class Student : public Person {
public:
  String studentId;
  Student(String name, Int age, String studentId) : studentId(studentId), Person(name, age) {
  }
  
  void introduce() {
    {
      super::introduce();
      dart_print(dart_string("    学号: ") + this->studentId.toString());
}
  }
  
  void study() {
    {
      dart_print(dart_string("    ") + this->name.toString() + dart_string(" 正在学习"));
}
  }
  
};

// ============================================================================
// 类: Teacher
// ============================================================================

class Teacher : public Person {
public:
  String subject;
  Teacher(String name, Int age, String subject) : subject(subject), Person(name, age) {
  }
  
  void introduce() {
    {
      super::introduce();
      dart_print(dart_string("    教授科目: ") + this->subject.toString());
}
  }
  
  void teach() {
    {
      dart_print(dart_string("    ") + this->name.toString() + dart_string(" 正在教授 ") + this->subject.toString());
}
  }
  
};

// ============================================================================
// 类: Animal
// ============================================================================

DART_INTERFACE(Animal)
  DART_ABSTRACT_METHOD(void, makeSound, ())
  DART_ABSTRACT_METHOD(void, move, ())
DART_INTERFACE_END

// ============================================================================
// 类: Dog
// ============================================================================

class Dog : public Animal {
public:
  Dog(String name) : Animal(name) {
  }
  
  void makeSound() {
    {
      dart_print(dart_string("    ") + this->name.toString() + dart_string(" 汪汪叫"));
}
  }
  
  void move() {
    {
      dart_print(dart_string("    ") + this->name.toString() + dart_string(" 跑步"));
}
  }
  
};

// ============================================================================
// 类: Cat
// ============================================================================

class Cat : public Animal {
public:
  Cat(String name) : Animal(name) {
  }
  
  void makeSound() {
    {
      dart_print(dart_string("    ") + this->name.toString() + dart_string(" 喵喵叫"));
}
  }
  
  void move() {
    {
      dart_print(dart_string("    ") + this->name.toString() + dart_string(" 悄悄走"));
}
  }
  
};

// ============================================================================
// 类: Shape
// ============================================================================

DART_INTERFACE(Shape)
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
  
  Double area() {
    return ((dart_double(3.14159) * this->radius) * this->radius);
  }
  
  Double perimeter() {
    return ((dart_int(2) * dart_double(3.14159)) * this->radius);
  }
  
};

// ============================================================================
// 类: Square
// ============================================================================

class Square : public Shape {
public:
  Double side;
  Square(Double side) : side(side) {
  }
  
  Double area() {
    return (this->side * this->side);
  }
  
  Double perimeter() {
    return (dart_int(4) * this->side);
  }
  
};

// ============================================================================
// 类: Box
// ============================================================================

class Box {
private:
  Any _value;
public:
  Box(Any _value) : _value(_value) {
  }
  
  Any getValue() {
    return this->_value;
  }
  
  void setValue(Any value) {
    return this->_value = value;
  }
  
};

// ============================================================================
// 类: NumberProcessor
// ============================================================================

class NumberProcessor {
public:
  NumberProcessor() {
  }
  
  Any process(List<Any> numbers) {
    {
      return numbers->reduce([&](Any a, Any b) { return dart_cast<Any>((a + b)); });
}
  }
  
};

// ============================================================================
// 类: Cache
// ============================================================================

class Cache {
private:
  Map<Any, Any> _cache = Map<Any, Any>::create();
public:
  Cache() {
  }
  
  void put(Any key, Any value) {
    return ([&]() { Map<Any, Any> let_var = this->_cache; return ([&]() { Any let_var = key; return ([&]() { Any let_var = value; return ([&]() { void let_var = let_var->[]=(let_var, let_var); return let_var; })(); })(); })(); })();
  }
  
  Any get(Any key) {
    return this->_cache->[](key);
  }
  
  Bool containsKey(Any key) {
    return this->_cache->containsKey(key);
  }
  
  void clear() {
    return this->_cache->clear();
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
  
};

// ============================================================================
// 类: WeekdayHelper
// ============================================================================

class WeekdayHelper {
public:
  WeekdayHelper() {
  }
  
  Bool isWeekday(Weekday day) {
    {
      return (day->index < dart_int(5));
}
  }
  
  Bool isWeekend(Weekday day) {
    {
      return !(WeekdayHelper::isWeekday(day));
}
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
  List<Color> values = List<Color>::createConst({ObjectPtr<Color>::createConst(), ObjectPtr<Color>::createConst(), ObjectPtr<Color>::createConst()});
  Color(Int #index, String #name) : _Enum(#index, #name) {
  }
  
  String _enumToString() {
    return dart_string("Color.") + this->_name.toString();
  }
  
};

// ============================================================================
// 类: ColorHelper
// ============================================================================

class ColorHelper {
public:
  Map<Color, Int> values = Map<Color, Int>::createConst();
  Map<Color, String> descriptions = Map<Color, String>::createConst();
  ColorHelper() {
  }
  
  Int getValue(Color color) {
    return dart_null_check(Map<Color, Int>::createConst()->[](color));
  }
  
  String getDescription(Color color) {
    return dart_null_check(Map<Color, String>::createConst()->[](color));
  }
  
};

// ============================================================================
// 类: OrderStatus
// ============================================================================

class OrderStatus : public _Enum {
public:
  OrderStatus pending = ObjectPtr<OrderStatus>::createConst();
  OrderStatus confirmed = ObjectPtr<OrderStatus>::createConst();
  OrderStatus shipped = ObjectPtr<OrderStatus>::createConst();
  OrderStatus delivered = ObjectPtr<OrderStatus>::createConst();
  OrderStatus cancelled = ObjectPtr<OrderStatus>::createConst();
  List<OrderStatus> values = List<OrderStatus>::createConst({ObjectPtr<OrderStatus>::createConst(), ObjectPtr<OrderStatus>::createConst(), ObjectPtr<OrderStatus>::createConst(), ObjectPtr<OrderStatus>::createConst(), ObjectPtr<OrderStatus>::createConst()});
  OrderStatus(Int #index, String #name) : _Enum(#index, #name) {
  }
  
  String _enumToString() {
    return dart_string("OrderStatus.") + this->_name.toString();
  }
  
};

// ============================================================================
// 类: Order
// ============================================================================

class Order {
public:
  OrderStatus status = ObjectPtr<OrderStatus>::createConst();
  Order() {
  }
  
  void confirm() {
    {
      if ((this->status == ObjectPtr<OrderStatus>::createConst())) {
      this->status = ObjectPtr<OrderStatus>::createConst();
}
}
  }
  
  void ship() {
    {
      if ((this->status == ObjectPtr<OrderStatus>::createConst())) {
      this->status = ObjectPtr<OrderStatus>::createConst();
}
}
  }
  
  void deliver() {
    {
      if ((this->status == ObjectPtr<OrderStatus>::createConst())) {
      this->status = ObjectPtr<OrderStatus>::createConst();
}
}
  }
  
  void cancel() {
    {
      if (!((this->status == ObjectPtr<OrderStatus>::createConst()))) {
      this->status = ObjectPtr<OrderStatus>::createConst();
}
}
  }
  
};

// ============================================================================
// 类: InvalidAgeException
// ============================================================================

class InvalidAgeException : DART_IMPLEMENTS(Exception) {
public:
  String message;
  InvalidAgeException(String message) : message(message) {
  }
  
  String toString() {
    return dart_string("InvalidAgeException: ") + this->message.toString();
  }
  
};

// ============================================================================
// 类: DataProcessingException
// ============================================================================

class DataProcessingException : DART_IMPLEMENTS(Exception) {
public:
  String message;
  Int errorCode;
  DataProcessingException(String message, Int errorCode) : message(message), errorCode(errorCode) {
  }
  
  String toString() {
    return dart_string("DataProcessingException: ") + this->message.toString() + dart_string(" (Code: ") + this->errorCode.toString() + dart_string(")");
  }
  
};

// ============================================================================
// 类: Coordinates
// ============================================================================

class Coordinates {
public:
  Int x;
  Int y;
  Coordinates(Int x, Int y) : x(x), y(y) {
  }
  
};

void main() {
  {
    dart_print(dart_string("🔥 基础语法演示开始"));
    testBasicTypes();
    testVariableDeclarations();
    testOperators();
    testControlFlow();
    testFunctions();
    testClassesAndObjects();
    testInheritanceAndPolymorphism();
    testInterfacesAndAbstractClasses();
    testGenerics();
    testCollections();
    testEnums();
    testExceptionHandling();
    testAsyncProgramming();
    testExtensionMethods();
    testAdvancedFeatures();
    dart_print(dart_string("✅ 基础语法演示完成"));
}
}

void testBasicTypes() {
  {
    dart_print(dart_string("
📌 测试基本数据类型"));
    auto intValue = dart_int(42);
    auto hexValue = dart_int(255);
    auto binaryValue = dart_int(333);
    auto doubleValue = dart_double(3.14159);
    auto scientificValue = dart_double(142000.0);
    auto trueValue = dart_bool(true);
    auto falseValue = dart_bool(false);
    auto singleQuote = dart_string("Hello");
    auto doubleQuote = dart_string("World");
    auto multiLine = dart_string("    This is a
    multi-line string
  ");
    auto interpolation = dart_string("The answer is ") + intValue.toString();
    auto expression = dart_string("Sum: ") + (intValue + doubleValue).toString();
    dart_print(dart_string("  整数: ") + intValue.toString() + dart_string(", 十六进制: ") + hexValue.toString() + dart_string(", 二进制: ") + binaryValue.toString());
    dart_print(dart_string("  浮点数: ") + doubleValue.toString() + dart_string(", 科学计数法: ") + scientificValue.toString());
    dart_print(dart_string("  布尔值: ") + trueValue.toString() + dart_string(", ") + falseValue.toString());
    dart_print(dart_string("  字符串: ") + singleQuote.toString() + dart_string(" ") + doubleQuote.toString());
    dart_print(dart_string("  插值: ") + interpolation.toString());
    dart_print(dart_string("  表达式: ") + expression.toString());
}
}

void testVariableDeclarations() {
  {
    dart_print(dart_string("
📌 测试变量声明"));
    auto autoInt = dart_int(100);
    auto autoString = dart_string("auto");
    const auto finalValue = dart_string("cannot change");
    const auto typedFinal = dart_int(200);
    Int nullableInt;
    auto nullableString = nullptr;
    auto nonNull = ([&]() { String let_var = nullableString; return (let_var == nullptr) ? dart_string("default") : let_var; })();
    dart_print(dart_string("  var: ") + autoInt.toString() + dart_string(", ") + autoString.toString());
    dart_print(dart_string("  final: ") + finalValue.toString() + dart_string(", ") + typedFinal.toString());
    dart_print(dart_string("  const: compile time constant, 3.14159"));
    dart_print(dart_string("  nullable: ") + nullableInt.toString() + dart_string(", ") + nullableString.toString());
    dart_print(dart_string("  non-null: ") + nonNull.toString());
}
}

void testOperators() {
  {
    dart_print(dart_string("
📌 测试运算符"));
    auto a = dart_int(10);
    auto b = dart_int(3);
    dart_print(dart_string("  算术: ") + (a + b).toString() + dart_string(", ") + (a - b).toString() + dart_string(", ") + (a * b).toString() + dart_string(", ") + (a / b).toString() + dart_string(", ") + (a % b).toString());
    dart_print(dart_string("  整除: ") + a->~/(b).toString());
    dart_print(dart_string("  比较: ") + (a == b).toString() + dart_string(", ") + !((a == b)).toString() + dart_string(", ") + (a > b).toString() + dart_string(", ") + (a < b).toString() + dart_string(", ") + (a >= b).toString() + dart_string(", ") + (a <= b).toString());
    auto x = dart_bool(true);
    auto y = dart_bool(false);
    dart_print(dart_string("  逻辑: ") + x && y.toString() + dart_string(", ") + x || y.toString() + dart_string(", ") + !(x).toString());
    dart_print(dart_string("  位运算: ") + a->&(b).toString() + dart_string(", ") + a->|(b).toString() + dart_string(", ") + a->^(b).toString() + dart_string(", ") + (~a).toString() + dart_string(", ") + a-><<(dart_int(1)).toString() + dart_string(", ") + a->>>(dart_int(1)).toString());
    auto c = dart_int(5);
    c = (c + dart_int(2));
    dart_print(dart_string("  赋值后: ") + c.toString());
    auto result = (a > b) ? dart_string("a is greater") : dart_string("b is greater");
    dart_print(dart_string("  三元: ") + result.toString());
    String nullable;
    auto safe = ([&]() { String let_var = nullable; return (let_var == nullptr) ? dart_string("default value") : let_var; })();
    dart_print(dart_string("  空值合并: ") + safe.toString());
}
}

void testControlFlow() {
  {
    dart_print(dart_string("
📌 测试控制流"));
    auto score = dart_int(85);
    if ((score >= dart_int(90))) {
    dart_print(dart_string("  成绩: 优秀"));
} else if ((score >= dart_int(80))) {
    dart_print(dart_string("  成绩: 良好"));
} else if ((score >= dart_int(70))) {
    dart_print(dart_string("  成绩: 中等"));
} else {
    dart_print(dart_string("  成绩: 需要努力"));
}
    auto grade = dart_string("B");
    label_40571: switch (grade) {
  case dart_string("A"):
    {
    dart_print(dart_string("  等级: 优秀"));
    break;
}
  case dart_string("B"):
    {
    dart_print(dart_string("  等级: 良好"));
    break;
}
  case dart_string("C"):
    {
    dart_print(dart_string("  等级: 中等"));
    break;
}
  default:
    {
    dart_print(dart_string("  等级: 未知"));
}
    break;
}
    dart_print(dart_string("  for循环:"));
    for (auto i = dart_int(0);; (i < dart_int(3)); i = (i + dart_int(1))) {
    dart_print(dart_string("    索引: ") + i.toString());
}
    auto fruits = _GrowableList::_literal3(dart_string("apple"), dart_string("banana"), dart_string("orange"));
    dart_print(dart_string("  for-in循环:"));
    {
    auto :sync-for-iterator = fruits->iterator;
    for (; :sync-for-iterator->moveNext(); ) {
    auto fruit = :sync-for-iterator->current;
    {
    dart_print(dart_string("    水果: ") + fruit.toString());
}
}
}
    dart_print(dart_string("  while循环:"));
    auto count = dart_int(0);
    while ((count < dart_int(3))) {
    dart_print(dart_string("    计数: ") + count.toString());
    count = (count + dart_int(1));
}
    dart_print(dart_string("  do-while循环:"));
    auto num = dart_int(0);
    do {
    dart_print(dart_string("    数字: ") + num.toString());
    num = (num + dart_int(1));
} while (((num < dart_int(2))).toBool());
    dart_print(dart_string("  break和continue:"));
    label_40690: for (auto i = dart_int(0);; (i < dart_int(5)); i = (i + dart_int(1))) label_40688: {
    if ((i == dart_int(2))) break;
    if ((i == dart_int(4))) break;
    dart_print(dart_string("    处理: ") + i.toString());
}
}
}

void testFunctions() {
  {
    dart_print(dart_string("
📌 测试函数"));
    auto sum = add(dart_int(5), dart_int(3));
    dart_print(dart_string("  加法: ") + sum.toString());
    greet(dart_string("Alice"));
    greet(dart_string("Bob"), dart_string("Mr."));
    createUser();
    createUser();
    auto multiply = [&](Int a, Int b) { return (a * b); };
    dart_print(dart_string("  匿名函数: ") + multiply(dart_int(4), dart_int(5)).toString());
    auto numbers = _GrowableList::_literal5(dart_int(1), dart_int(2), dart_int(3), dart_int(4), dart_int(5));
    auto doubled = numbers->map([&](Int n) { return (n * dart_int(2)); })->toList();
    dart_print(dart_string("  高阶函数: ") + doubled.toString());
    auto counter = createCounter();
    dart_print(dart_string("  闭包: ") + counter().toString() + dart_string(", ") + counter().toString() + dart_string(", ") + counter().toString());
}
}

void testClassesAndObjects() {
  {
    dart_print(dart_string("
📌 测试类和对象"));
    auto person = ObjectPtr<Person>(new Person(dart_string("Alice"), dart_int(25)));
    dart_print(dart_string("  基本对象: ") + person->name.toString() + dart_string(", ") + person->age.toString());
    person->introduce();
    auto account = ObjectPtr<BankAccount>(new BankAccount(dart_string("123456"), dart_double(1000.0)));
    account->deposit(dart_double(500.0));
    account->withdraw(dart_double(200.0));
    dart_print(dart_string("  账户余额: ") + account->getBalance().toString());
    auto point1 = ObjectPtr<Point>(new Point(dart_double(3.0), dart_double(4.0)));
    auto point2 = ObjectPtr<Point>(new Point());
    auto point3 = ObjectPtr<Point>(new Point(dart_double(5.0), dart_double(0.927)));
    dart_print(dart_string("  点坐标: (") + point1->x.toString() + dart_string(", ") + point1->y.toString() + dart_string("), (") + point2->x.toString() + dart_string(", ") + point2->y.toString() + dart_string("), (") + point3->x.toString() + dart_string(", ") + point3->y.toString() + dart_string(")"));
    dart_print(dart_string("  创建的点数量: ") + Point::count.toString());
    auto rectangle = ObjectPtr<Rectangle>(new Rectangle(dart_double(10.0), dart_double(20.0)));
    dart_print(dart_string("  矩形面积: ") + rectangle->area.toString());
    rectangle->width = dart_double(15.0);
    dart_print(dart_string("  修改后面积: ") + rectangle->area.toString());
}
}

void testInheritanceAndPolymorphism() {
  {
    dart_print(dart_string("
📌 测试继承和多态"));
    auto student = ObjectPtr<Student>(new Student(dart_string("Bob"), dart_int(20), dart_string("S001")));
    student->introduce();
    student->study();
    auto teacher = ObjectPtr<Teacher>(new Teacher(dart_string("Dr. Smith"), dart_int(45), dart_string("Computer Science")));
    teacher->introduce();
    teacher->teach();
    auto people = _GrowableList::_literal3(ObjectPtr<Person>(new Person(dart_string("Alice"), dart_int(30))), ObjectPtr<Student>(new Student(dart_string("Charlie"), dart_int(19), dart_string("S002"))), ObjectPtr<Teacher>(new Teacher(dart_string("Prof. Johnson"), dart_int(50), dart_string("Mathematics"))));
    dart_print(dart_string("  多态演示:"));
    {
    auto :sync-for-iterator = people->iterator;
    for (; :sync-for-iterator->moveNext(); ) {
    auto person = :sync-for-iterator->current;
    {
    person->introduce();
    if (dart_is<Student>(person)) {
    person->study();
} else if (dart_is<Teacher>(person)) {
    person->teach();
}
}
}
}
}
}

void testInterfacesAndAbstractClasses() {
  {
    dart_print(dart_string("
📌 测试接口和抽象类"));
    auto dog = ObjectPtr<Dog>(new Dog(dart_string("Buddy")));
    auto cat = ObjectPtr<Cat>(new Cat(dart_string("Whiskers")));
    auto animals = _GrowableList::_literal2(dog, cat);
    {
    auto :sync-for-iterator = animals->iterator;
    for (; :sync-for-iterator->moveNext(); ) {
    auto animal = :sync-for-iterator->current;
    {
    animal->makeSound();
    animal->move();
}
}
}
    auto circle = ObjectPtr<Circle>(new Circle(dart_double(5.0)));
    auto square = ObjectPtr<Square>(new Square(dart_double(4.0)));
    auto shapes = _GrowableList::_literal2(circle, square);
    {
    auto :sync-for-iterator = shapes->iterator;
    for (; :sync-for-iterator->moveNext(); ) {
    auto shape = :sync-for-iterator->current;
    {
    dart_print(dart_string("  ") + shape->runtimeType.toString() + dart_string(" 面积: ") + shape->area().toString() + dart_string(", 周长: ") + shape->perimeter().toString());
}
}
}
}
}

void testGenerics() {
  {
    dart_print(dart_string("
📌 测试泛型"));
    auto intBox = ObjectPtr<Box>(new Box(dart_int(42)));
    auto stringBox = ObjectPtr<Box>(new Box(dart_string("Hello")));
    dart_print(dart_string("  泛型盒子: ") + intBox->getValue().toString() + dart_string(", ") + stringBox->getValue().toString());
    auto intList = _GrowableList::_literal3(dart_int(1), dart_int(2), dart_int(3));
    auto stringList = _GrowableList::_literal3(dart_string("a"), dart_string("b"), dart_string("c"));
    dart_print(dart_string("  泛型交换前: ") + intList.toString() + dart_string(", ") + stringList.toString());
    swap(intList, dart_int(0), dart_int(2));
    swap(stringList, dart_int(0), dart_int(2));
    dart_print(dart_string("  泛型交换后: ") + intList.toString() + dart_string(", ") + stringList.toString());
    auto numberProcessor = ObjectPtr<NumberProcessor>(new NumberProcessor());
    dart_print(dart_string("  泛型约束: ") + numberProcessor->process(_GrowableList::_literal3(dart_double(1.1), dart_double(2.2), dart_double(3.3))).toString());
    auto cache = ObjectPtr<Cache>(new Cache());
    cache->put(dart_string("one"), dart_int(1));
    cache->put(dart_string("two"), dart_int(2));
    dart_print(dart_string("  泛型缓存: ") + cache->get(dart_string("one")).toString() + dart_string(", ") + cache->get(dart_string("two")).toString());
}
}

void testCollections() {
  {
    dart_print(dart_string("
📌 测试集合操作"));
    auto numbers = _GrowableList::_literal5(dart_int(1), dart_int(2), dart_int(3), dart_int(4), dart_int(5));
    numbers->add(dart_int(6));
    numbers->addAll(_GrowableList::_literal3(dart_int(7), dart_int(8), dart_int(9)));
    numbers->insert(dart_int(0), dart_int(0));
    dart_print(dart_string("  List操作: ") + numbers.toString());
    auto evenNumbers = numbers->where([&](Int n) { return ((n % dart_int(2)) == dart_int(0)); })->toList();
    auto doubled = numbers->map([&](Int n) { return (n * dart_int(2)); })->toList();
    auto sum = numbers->reduce([&](Int a, Int b) { return (a + b); });
    dart_print(dart_string("  List筛选: 偶数=") + evenNumbers.toString() + dart_string(", 翻倍=") + doubled.toString() + dart_string(", 求和=") + sum.toString());
    auto fruits = ([&]() { const auto unnamed_var = ObjectPtr<_Set>(new _Set()); unnamed_var->add(dart_string("apple")); unnamed_var->add(dart_string("banana")); unnamed_var->add(dart_string("orange")); return unnamed_var; })();
    fruits->add(dart_string("grape"));
    fruits->addAll(_GrowableList::_literal2(dart_string("kiwi"), dart_string("mango")));
    dart_print(dart_string("  Set操作: ") + fruits.toString());
    auto citrus = ([&]() { const auto unnamed_var = ObjectPtr<_Set>(new _Set()); unnamed_var->add(dart_string("orange")); unnamed_var->add(dart_string("lemon")); unnamed_var->add(dart_string("lime")); return unnamed_var; })();
    auto intersection = fruits->intersection(citrus);
    auto union = fruits->union(citrus);
    dart_print(dart_string("  Set运算: 交集=") + intersection.toString() + dart_string(", 并集=") + union.toString());
    auto scores = Map<String, Int>::createFromEntries({{dart_string("Alice"), dart_int(95)}, {dart_string("Bob"), dart_int(87)}, {dart_string("Charlie"), dart_int(92)}});
    scores->[]=(dart_string("David"), dart_int(89));
    scores->addAll(Map<String, Int>::createFromEntries({{dart_string("Eve"), dart_int(96)}, {dart_string("Frank"), dart_int(84)}}));
    dart_print(dart_string("  Map操作: ") + scores.toString());
    auto highScores = Map::fromEntries(scores->entries->where([&](MapEntry entry) { return (entry->value >= dart_int(90)); }));
    dart_print(dart_string("  Map筛选: 高分=") + highScores.toString());
    auto students = _GrowableList::_literal4(Map<String, Object>::createFromEntries({{dart_string("name"), dart_string("Alice")}, {dart_string("grade"), dart_int(95)}, {dart_string("subject"), dart_string("Math")}}), Map<String, Object>::createFromEntries({{dart_string("name"), dart_string("Bob")}, {dart_string("grade"), dart_int(87)}, {dart_string("subject"), dart_string("Science")}}), Map<String, Object>::createFromEntries({{dart_string("name"), dart_string("Charlie")}, {dart_string("grade"), dart_int(92)}, {dart_string("subject"), dart_string("Math")}}), Map<String, Object>::createFromEntries({{dart_string("name"), dart_string("David")}, {dart_string("grade"), dart_int(89)}, {dart_string("subject"), dart_string("Science")}}));
    auto mathStudents = students->where([&](Map<String, Object> s) { return (s->[](dart_string("subject")) == dart_string("Math")); })->toList();
    auto avgGrade = (students->map([&](Map<String, Object> s) { return dart_cast<Int>(s->[](dart_string("grade"))); })->reduce([&](Int a, Int b) { return (a + b); }) / students->length);
    dart_print(dart_string("  复杂操作: 数学学生=") + mathStudents.toString() + dart_string(", 平均分=") + avgGrade.toString());
}
}

void testEnums() {
  {
    dart_print(dart_string("
📌 测试枚举"));
    auto today = ObjectPtr<Weekday>::createConst();
    dart_print(dart_string("  今天是: ") + EnumName|get#name(today).toString());
    dart_print(dart_string("  是工作日吗: ") + WeekdayHelper::isWeekday(today).toString());
    dart_print(dart_string("  是周末吗: ") + WeekdayHelper::isWeekend(today).toString());
    auto red = ObjectPtr<Color>::createConst();
    auto green = ObjectPtr<Color>::createConst();
    auto blue = ObjectPtr<Color>::createConst();
    dart_print(dart_string("  颜色值: ") + red->toString().toString() + dart_string("=") + ColorHelper::getValue(red).toString() + dart_string(", ") + green->toString().toString() + dart_string("=") + ColorHelper::getValue(green).toString() + dart_string(", ") + blue->toString().toString() + dart_string("=") + ColorHelper::getValue(blue).toString());
    dart_print(dart_string("  颜色描述: ") + ColorHelper::getDescription(red).toString() + dart_string(", ") + ColorHelper::getDescription(green).toString() + dart_string(", ") + ColorHelper::getDescription(blue).toString());
    dart_print(dart_string("  所有颜色:"));
    {
    auto :sync-for-iterator = List<Color>::createConst({ObjectPtr<Color>::createConst(), ObjectPtr<Color>::createConst(), ObjectPtr<Color>::createConst()})->iterator;
    for (; :sync-for-iterator->moveNext(); ) {
    auto color = :sync-for-iterator->current;
    {
    dart_print(dart_string("    ") + color->toString().toString() + dart_string(": ") + ColorHelper::getValue(color).toString() + dart_string(" - ") + ColorHelper::getDescription(color).toString());
}
}
}
    auto order = ObjectPtr<Order>(new Order());
    dart_print(dart_string("  订单状态: ") + EnumName|get#name(order->status).toString());
    order->confirm();
    dart_print(dart_string("  确认后状态: ") + EnumName|get#name(order->status).toString());
    order->ship();
    dart_print(dart_string("  发货后状态: ") + EnumName|get#name(order->status).toString());
    order->deliver();
    dart_print(dart_string("  送达后状态: ") + EnumName|get#name(order->status).toString());
}
}

void testExceptionHandling() {
  {
    dart_print(dart_string("
📌 测试异常处理"));
    try {
    auto result = divide(dart_int(10), dart_int(0));
    dart_print(dart_string("  除法结果: ") + result.toString());
} catch (const std::exception& e) { /* catch block */ }
// Finally block should be implemented using RAII pattern
    try {
    validateAge((-dart_int(5)));
} catch (const std::exception& e) { /* catch block */ } catch (const std::exception& e) { /* catch block */ }
// Finally block should be implemented using RAII pattern
    try { /* try block */ } catch (const std::exception& e) { /* catch block */ }
    try {
    processData(nullptr);
} catch (const std::exception& e) { /* catch block */ }
// Finally block should be implemented using RAII pattern
    try {
    wrapperFunction();
} catch (const std::exception& e) { /* catch block */ }
// Finally block should be implemented using RAII pattern
}
}

void testAsyncProgramming() {
  {
    dart_print(dart_string("
📌 测试异步编程"));
    dart_print(dart_string("  开始异步操作..."));
    fetchUserData()->then([&](String data) { {
    dart_print(dart_string("  获取用户数据: ") + data.toString());
} })->catchError([&](Any error) { {
    dart_print(dart_string("  异步错误: ") + error.toString());
} });
    Future::wait(_GrowableList::_literal2(fetchUserData(), fetchUserPreferences()))->then([&](List<String> results) { {
    dart_print(dart_string("  组合结果: ") + results.toString());
} });
    auto stream = generateNumbers();
    stream->listen([&](Int number) { return dart_print(dart_string("  流数据: ") + number.toString()); });
}
}

void testExtensionMethods() {
  {
    dart_print(dart_string("
📌 测试扩展方法"));
    auto text = dart_string("hello world");
    dart_print(dart_string("  首字母大写: ") + StringExtensions|capitalize(text).toString());
    dart_print(dart_string("  是否为回文: ") + StringExtensions|isPalindrome(text).toString());
    dart_print(dart_string("  单词数量: ") + StringExtensions|wordCount(text).toString());
    auto number = dart_int(5);
    dart_print(dart_string("  阶乘: ") + IntExtensions|factorial(number).toString());
    dart_print(dart_string("  是否为偶数: ") + number->isEven.toString());
    dart_print(dart_string("  是否为质数: ") + IntExtensions|isPrime(number).toString());
    auto numbers = _GrowableList::_literal5(dart_int(1), dart_int(2), dart_int(3), dart_int(4), dart_int(5));
    dart_print(dart_string("  第二个元素: ") + ListExtensions|get#secondOrNull(numbers).toString());
    dart_print(dart_string("  安全获取: ") + ListExtensions|safeGet(numbers, dart_int(10)).toString());
    auto chunks = ListExtensions|chunk(numbers, dart_int(2));
    dart_print(dart_string("  分块: ") + chunks.toString());
    auto now = ObjectPtr<DateTime>(new DateTime());
    dart_print(dart_string("  是否为今天: ") + DateTimeExtensions|isToday(now).toString());
    dart_print(dart_string("  格式化: ") + DateTimeExtensions|format(now).toString());
}
}

void testAdvancedFeatures() {
  {
    dart_print(dart_string("
📌 测试高级语法特性"));
    auto person = ([&]() { Person let_var = ObjectPtr<Person>(new Person(dart_string("Alice"), dart_int(25))); return ([&]() { let_var->introduce(); let_var->age = dart_int(26); let_var->introduce(); return let_var; })(); })();
    Person nullablePerson;
    dart_print(dart_string("  安全访问: ") + ([&]() { String let_var = ([&]() { Person let_var = nullablePerson; return (let_var == nullptr) ? nullptr : let_var->name; })(); return (let_var == nullptr) ? dart_string("null") : let_var; })().toString());
    auto obj = dart_string("Hello");
    if (dart_is<String>(obj)) {
    dart_print(dart_string("  类型检查: 字符串长度=") + obj->length.toString());
}
    auto stringObj = dart_cast<String>(obj);
    dart_print(dart_string("  类型转换: ") + stringObj->toUpperCase().toString());
    auto coordinates = getCoordinates();
    auto x = coordinates->x;
    auto y = coordinates->y;
    dart_print(dart_string("  解构赋值: x=") + x.toString() + dart_string(", y=") + y.toString());
    String result;
    label_42250: switch (obj->runtimeType->toString()) {
  case dart_string("String"):
    {
    result = dart_string("这是字符串");
    break;
}
  case dart_string("int"):
    {
    result = dart_string("这是整数");
    break;
}
  default:
    {
    result = dart_string("未知类型");
}
    break;
}
    dart_print(dart_string("  模式匹配: ") + result.toString());
    auto operations = Map<String, Function>::createFromEntries({{dart_string("add"), [&](Int a, Int b) { return (a + b); }}, {dart_string("multiply"), [&](Int a, Int b) { return (a * b); }}, {dart_string("subtract"), [&](Int a, Int b) { return (a - b); }}});
    dart_print(dart_string("  函数映射: ") + dart_null_check(operations->[](dart_string("add")))(dart_int(5), dart_int(3)).toString());
    auto userInfo = createUserRecord(dart_string("Bob"), dart_int(30), dart_string("bob@example.com"));
    dart_print(dart_string("  记录类型: ") + userInfo.toString());
}
}

std::function<String()> StringExtensions|get#capitalize(String #this) {
  return [&]() { return StringExtensions|capitalize(#this); };
}

String StringExtensions|capitalize(String #this) {
  {
    if (#this->isEmpty) return #this;
    return #this->[](dart_int(0))->toUpperCase().toString() + #this->substring(dart_int(1)).toString();
}
}

Bool StringExtensions|isPalindrome(String #this) {
  {
    auto cleaned = #this->toLowerCase()->replaceAll(RegExp::(dart_string("[^a-z0-9]")), dart_string(""));
    return (cleaned == cleaned->split(dart_string(""))->reversed->join(dart_string("")));
}
}

std::function<Bool()> StringExtensions|get#isPalindrome(String #this) {
  return [&]() { return StringExtensions|isPalindrome(#this); };
}

Int StringExtensions|wordCount(String #this) {
  {
    return #this->trim()->split(RegExp::(dart_string("\s+")))->length;
}
}

std::function<Int()> StringExtensions|get#wordCount(String #this) {
  return [&]() { return StringExtensions|wordCount(#this); };
}

Int IntExtensions|factorial(Int #this) {
  {
    if ((#this < dart_int(0))) return dart_int(0);
    if ((#this <= dart_int(1))) return dart_int(1);
    return (#this * IntExtensions|factorial((#this - dart_int(1))));
}
}

std::function<Int()> IntExtensions|get#factorial(Int #this) {
  return [&]() { return IntExtensions|factorial(#this); };
}

Bool IntExtensions|isPrime(Int #this) {
  {
    if ((#this < dart_int(2))) return dart_bool(false);
    for (auto i = dart_int(2);; ((i * i) <= #this); i = (i + dart_int(1))) {
    if (((#this % i) == dart_int(0))) return dart_bool(false);
}
    return dart_bool(true);
}
}

std::function<Bool()> IntExtensions|get#isPrime(Int #this) {
  return [&]() { return IntExtensions|isPrime(#this); };
}

Any ListExtensions|get#secondOrNull(List<Any> #this) {
  return (#this->length > dart_int(1)) ? #this->[](dart_int(1)) : nullptr;
}

Any ListExtensions|safeGet(List<Any> #this, Int index) {
  {
    return (index >= dart_int(0)) && (index < #this->length) ? #this->[](index) : nullptr;
}
}

std::function<Any()> ListExtensions|get#safeGet(List<Any> #this) {
  return [&](Int index) { return ListExtensions|safeGet(#this, index); };
}

List<List<Any>> ListExtensions|chunk(List<Any> #this, Int size) {
  {
    auto chunks = _GrowableList::(dart_int(0));
    for (auto i = dart_int(0);; (i < #this->length); i = (i + size)) {
    chunks->add(#this->sublist(i, ((i + size) > #this->length) ? #this->length : (i + size)));
}
    return chunks;
}
}

std::function<List<List<Any>>()> ListExtensions|get#chunk(List<Any> #this) {
  return [&](Int size) { return ListExtensions|chunk(#this, size); };
}

Bool DateTimeExtensions|isToday(DateTime #this) {
  {
    const auto now = ObjectPtr<DateTime>(new DateTime());
    return (#this->year == now->year) && (#this->month == now->month) && (#this->day == now->day);
}
}

std::function<Bool()> DateTimeExtensions|get#isToday(DateTime #this) {
  return [&]() { return DateTimeExtensions|isToday(#this); };
}

std::function<String()> DateTimeExtensions|get#format(DateTime #this) {
  return [&]() { return DateTimeExtensions|format(#this); };
}

String DateTimeExtensions|format(DateTime #this) {
  {
    return #this->year.toString() + dart_string("-") + #this->month->toString()->padLeft(dart_int(2), dart_string("0")).toString() + dart_string("-") + #this->day->toString()->padLeft(dart_int(2), dart_string("0")).toString();
}
}

Int add(Int a, Int b) {
  {
    return (a + b);
}
}

void greet(String name, String title) {
  {
    if (!((title == nullptr))) {
    dart_print(dart_string("  问候: Hello, ") + title.toString() + dart_string(" ") + name.toString());
} else {
    dart_print(dart_string("  问候: Hello, ") + name.toString());
}
}
}

void createUser(String name, Int age, String email) {
  {
    dart_print(dart_string("  用户: ") + name.toString() + dart_string(", 年龄: ") + age.toString() + !((email == nullptr)) ? dart_string(", 邮箱: ") + email.toString() : dart_string("").toString());
}
}

Function createCounter() {
  {
    auto count = dart_int(0);
    return [&]() { {
    count = (count + dart_int(1));
    return count;
} };
}
}

void swap(List<Any> list, Int i, Int j) {
  {
    auto temp = list->[](i);
    list->[]=(i, list->[](j));
    list->[]=(j, temp);
}
}

Int divide(Int a, Int b) {
  {
    if ((b == dart_int(0))) {
    throw DartException(ObjectPtr<ArgumentError>(new ArgumentError(dart_string("除数不能为零"))));
}
    return a->~/(b);
}
}

void validateAge(Int age) {
  {
    if ((age < dart_int(0))) {
    throw DartException(ObjectPtr<InvalidAgeException>(new InvalidAgeException(dart_string("年龄不能为负数"))));
}
    if ((age > dart_int(150))) {
    throw DartException(ObjectPtr<InvalidAgeException>(new InvalidAgeException(dart_string("年龄不能超过150岁"))));
}
}
}

void riskyOperation() {
  {
    throw DartException(Exception::(dart_string("模拟风险操作失败")));
}
}

void processData(String data) {
  {
    if ((data == nullptr)) {
    throw DartException(ObjectPtr<DataProcessingException>(new DataProcessingException(dart_string("数据不能为空"), dart_int(1001))));
}
}
}

void wrapperFunction() {
  {
    try {
    riskyOperation();
} catch (const std::exception& e) { /* catch block */ }
// Finally block should be implemented using RAII pattern
}
}

DART_ASYNC_FUNCTION(Future<String>, fetchUserData, ()) {
    DART_ASYNC_BEGIN
  {
    DART_AWAIT(Future::delayed(ObjectPtr<Duration>(new Duration(/*milliseconds:*/ dart_int(100)))));
    return dart_string("User: Alice, Age: 25");
}
    DART_ASYNC_END
}

DART_ASYNC_FUNCTION(Future<String>, fetchUserPreferences, ()) {
    DART_ASYNC_BEGIN
  {
    DART_AWAIT(Future::delayed(ObjectPtr<Duration>(new Duration(/*milliseconds:*/ dart_int(150)))));
    return dart_string("Theme: Dark, Language: zh-CN");
}
    DART_ASYNC_END
}

DART_ASYNC_FUNCTION(Stream<Int>, generateNumbers, ()) {
    DART_ASYNC_BEGIN
  {
    for (auto i = dart_int(1);; (i <= dart_int(5)); i = (i + dart_int(1))) {
    DART_AWAIT(Future::delayed(ObjectPtr<Duration>(new Duration(/*milliseconds:*/ dart_int(50)))));
    co_yield i;  // C++20 coroutine
}
}
    DART_ASYNC_END
}

Double cos(Double angle) {
  {
    auto result = dart_double(1.0);
    auto term = dart_double(1.0);
    for (auto i = dart_int(1);; (i <= dart_int(10)); i = (i + dart_int(1))) {
    term = (term * (((-angle) * angle) / (((dart_int(2) * i) - dart_int(1)) * (dart_int(2) * i))));
    result = (result + term);
}
    return result;
}
}

Double sin(Double angle) {
  {
    auto result = angle;
    auto term = angle;
    for (auto i = dart_int(1);; (i <= dart_int(10)); i = (i + dart_int(1))) {
    term = (term * (((-angle) * angle) / ((dart_int(2) * i) * ((dart_int(2) * i) + dart_int(1)))));
    result = (result + term);
}
    return result;
}
}

Coordinates getCoordinates() {
  return ObjectPtr<Coordinates>(new Coordinates(dart_int(10), dart_int(20)));
}

Map<String, Any> createUserRecord(String name, Int age, String email) {
  {
    return Map<String, Any>::createFromEntries({{dart_string("name"), name}, {dart_string("age"), age}, {dart_string("email"), email}});
}
}

// ============================================================================
// 主函数
// ============================================================================

int main() {
  try {
    {
      dart_print(dart_string("🔥 基础语法演示开始"));
      testBasicTypes();
      testVariableDeclarations();
      testOperators();
      testControlFlow();
      testFunctions();
      testClassesAndObjects();
      testInheritanceAndPolymorphism();
      testInterfacesAndAbstractClasses();
      testGenerics();
      testCollections();
      testEnums();
      testExceptionHandling();
      testAsyncProgramming();
      testExtensionMethods();
      testAdvancedFeatures();
      dart_print(dart_string("✅ 基础语法演示完成"));
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
