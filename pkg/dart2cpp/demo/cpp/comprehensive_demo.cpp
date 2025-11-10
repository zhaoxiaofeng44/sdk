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
      dart_print(dart_string("  我是") + this->name.toString() + dart_string("，今年") + this->age.toString() + dart_string("岁"));
}
  }
  
  void celebrateBirthday() {
    {
      this->age = (this->age + dart_int(1));
      dart_print(dart_string("  🎉 生日快乐！现在") + this->age.toString() + dart_string("岁了"));
}
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
  
  void study() {
    {
      dart_print(dart_string("  学生") + this->name.toString() + dart_string("正在学习，学号：") + this->studentId.toString());
}
  }
  
};

// ============================================================================
// 类: Drivable
// ============================================================================

DART_INTERFACE(Drivable)
  DART_ABSTRACT_METHOD(void, start, ())
  DART_ABSTRACT_METHOD(void, stop, ())
DART_INTERFACE_END

// ============================================================================
// 类: Car
// ============================================================================

class Car : DART_IMPLEMENTS(Drivable) {
public:
  Bool isRunning = dart_bool(false);
  Car() {
  }
  
  void start() {
    {
      this->isRunning = dart_bool(true);
      dart_print(dart_string("  汽车启动"));
}
  }
  
  void stop() {
    {
      this->isRunning = dart_bool(false);
      dart_print(dart_string("  汽车停止"));
}
  }
  
};

// ============================================================================
// 类: Shape
// ============================================================================

DART_INTERFACE(Shape)
  DART_ABSTRACT_METHOD(Double, area, ())
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
    {
      return ((dart_double(3.141592653589793) * this->radius) * this->radius);
}
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
  
  Double area() {
    {
      return (this->width * this->height);
}
  }
  
};

// ============================================================================
// 类: Status
// ============================================================================

class Status : public _Enum {
public:
  Status inactive = ObjectPtr<Status>::createConst();
  Status active = ObjectPtr<Status>::createConst();
  Status pending = ObjectPtr<Status>::createConst();
  Status completed = ObjectPtr<Status>::createConst();
  List<Status> values = List<Status>::createConst({ObjectPtr<Status>::createConst(), ObjectPtr<Status>::createConst(), ObjectPtr<Status>::createConst(), ObjectPtr<Status>::createConst()});
  Status(Int #index, String #name) : _Enum(#index, #name) {
  }
  
  String _enumToString() {
    return dart_string("Status.") + this->_name.toString();
  }
  
};

// ============================================================================
// 类: Performer
// ============================================================================

DART_INTERFACE(Performer)
DART_INTERFACE_END

// ============================================================================
// 类: Musician
// ============================================================================

class Musician : public _Musician&Object&Performer {
public:
  String name;
  Musician(String name) : name(name) {
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
// 类: Pair
// ============================================================================

class Pair {
public:
  Any first;
  Any second;
  Pair(Any first, Any second) : first(first), second(second) {
  }
  
};

// ============================================================================
// 类: Calculator
// ============================================================================

class Calculator {
public:
  Calculator() {
  }
  
  Any add(Any a, Any b) {
    {
      return dart_cast<Any>((a + b));
}
  }
  
};

// ============================================================================
// 类: CustomException
// ============================================================================

class CustomException : DART_IMPLEMENTS(Exception) {
public:
  String message;
  Int code;
  CustomException(String message, Int code) : message(message), code(code) {
  }
  
  String toString() {
    return dart_string("CustomException: ") + this->message.toString() + dart_string(" (code: ") + this->code.toString() + dart_string(")");
  }
  
};

// ============================================================================
// 类: _Musician&Object&Performer
// ============================================================================

DART_INTERFACE(_Musician&Object&Performer)
DART_INTERFACE_END

DART_ASYNC_FUNCTION(void, main, ()) {
    DART_ASYNC_BEGIN
  {
    dart_print(dart_string("🚀 Dart2CPP 综合测试开始"));
    dart_print((dart_string("=") * dart_int(60)));
    testBasicSyntax();
    testObjectOriented();
    testCollections();
    DART_AWAIT(testAsyncProgramming());
    testGenerics();
    testExceptionHandling();
    testAdvancedFeatures();
    dart_print((dart_string("=") * dart_int(60)));
    dart_print(dart_string("✅ 所有测试完成"));
}
    DART_ASYNC_END
}

void testBasicSyntax() {
  {
    dart_print(dart_string("
📌 测试基础语法"));
    auto intValue = dart_int(42);
    auto doubleValue = dart_double(3.14159);
    auto boolValue = dart_bool(true);
    auto stringValue = dart_string("Hello, Dart2CPP!");
    dart_print(dart_string("  基本类型: ") + intValue.toString() + dart_string(", ") + doubleValue.toString() + dart_string(", ") + boolValue.toString() + dart_string(", ") + stringValue.toString());
    auto a = dart_int(10);
    auto b = dart_int(3);
    dart_print(dart_string("  算术运算: ") + (a + b).toString() + dart_string(", ") + (a - b).toString() + dart_string(", ") + (a * b).toString() + dart_string(", ") + (a / b).toString() + dart_string(", ") + (a % b).toString() + dart_string(", ") + a->~/(b).toString());
    dart_print(dart_string("  比较运算: ") + (a == b).toString() + dart_string(", ") + !((a == b)).toString() + dart_string(", ") + (a > b).toString() + dart_string(", ") + (a < b).toString());
    dart_print(dart_string("  逻辑运算: ") + boolValue && dart_bool(false).toString() + dart_string(", ") + boolValue || dart_bool(false).toString() + dart_string(", ") + !(boolValue).toString());
    auto sum = dart_int(0);
    for (auto i = dart_int(1);; (i <= dart_int(5)); i = (i + dart_int(1))) {
    sum = (sum + i);
}
    dart_print(dart_string("  for循环求和: ") + sum.toString());
    auto grade = (intValue >= dart_int(90)) ? dart_string("A") : (intValue >= dart_int(80)) ? dart_string("B") : dart_string("C");
    dart_print(dart_string("  条件运算: ") + grade.toString());
    label_40103: switch (grade) {
  case dart_string("A"):
    {
    dart_print(dart_string("  优秀"));
    break;
}
  case dart_string("B"):
    {
    dart_print(dart_string("  良好"));
    break;
}
  default:
    {
    dart_print(dart_string("  需要努力"));
}
    break;
}
    auto result = addNumbers(dart_int(5), dart_int(3));
    dart_print(dart_string("  函数调用结果: ") + result.toString());
    greetPerson(dart_string("Alice"));
    greetPerson(dart_string("Bob"), dart_string("Mr."));
    dart_print(dart_string("  ✓ 基础语法测试完成"));
}
}

void testObjectOriented() {
  {
    dart_print(dart_string("
📌 测试面向对象"));
    auto person = ObjectPtr<Person>(new Person(dart_string("Alice"), dart_int(25)));
    person->introduce();
    person->celebrateBirthday();
    auto student = ObjectPtr<Student>(new Student(dart_string("Bob"), dart_int(20), dart_string("S001")));
    student->introduce();
    student->study();
    auto car = ObjectPtr<Car>(new Car());
    car->start();
    car->stop();
    auto circle = ObjectPtr<Circle>(new Circle(dart_double(5.0)));
    dart_print(dart_string("  圆形面积: ") + circle->area().toString());
    auto rectangle = ObjectPtr<Rectangle>(new Rectangle(dart_double(4.0), dart_double(6.0)));
    dart_print(dart_string("  矩形面积: ") + rectangle->area().toString());
    auto status = ObjectPtr<Status>::createConst();
    dart_print(dart_string("  状态: ") + EnumName|get#name(status).toString() + dart_string(", 索引: ") + status->index.toString());
    auto musician = ObjectPtr<Musician>(new Musician(dart_string("Charlie")));
    musician->perform();
    dart_print(dart_string("  ✓ 面向对象测试完成"));
}
}

void testCollections() {
  {
    dart_print(dart_string("
📌 测试集合操作"));
    auto numbers = _GrowableList::_literal5(dart_int(1), dart_int(2), dart_int(3), dart_int(4), dart_int(5));
    dart_print(dart_string("  原始列表: ") + numbers.toString());
    numbers->add(dart_int(6));
    dart_print(dart_string("  添加元素后: ") + numbers.toString());
    auto doubled = numbers->map([&](Int n) { return (n * dart_int(2)); })->toList();
    dart_print(dart_string("  映射操作: ") + doubled.toString());
    auto evens = numbers->where([&](Int n) { return ((n % dart_int(2)) == dart_int(0)); })->toList();
    dart_print(dart_string("  过滤偶数: ") + evens.toString());
    auto fruits = ([&]() { const auto unnamed_var = ObjectPtr<_Set>(new _Set()); unnamed_var->add(dart_string("apple")); unnamed_var->add(dart_string("banana")); unnamed_var->add(dart_string("orange")); return unnamed_var; })();
    fruits->add(dart_string("apple"));
    dart_print(dart_string("  水果集合: ") + fruits.toString());
    auto scores = Map<String, Int>::createFromEntries({{dart_string("Alice"), dart_int(95)}, {dart_string("Bob"), dart_int(87)}, {dart_string("Charlie"), dart_int(92)}});
    dart_print(dart_string("  分数映射: ") + scores.toString());
    dart_print(dart_string("  Alice的分数: ") + scores->[](dart_string("Alice")).toString());
    auto sum = numbers->reduce([&](Int a, Int b) { return (a + b); });
    dart_print(dart_string("  列表求和: ") + sum.toString());
    auto hasEven = numbers->any([&](Int n) { return ((n % dart_int(2)) == dart_int(0)); });
    dart_print(dart_string("  包含偶数: ") + hasEven.toString());
    dart_print(dart_string("  ✓ 集合操作测试完成"));
}
}

DART_ASYNC_FUNCTION(Future<void>, testAsyncProgramming, ()) {
    DART_ASYNC_BEGIN
  {
    dart_print(dart_string("
📌 测试异步编程"));
    auto result = DART_AWAIT(Future::delayed(ObjectPtr<Duration>(new Duration(/*milliseconds:*/ dart_int(10))), [&]() { return dart_string("Async Result"); }));
    dart_print(dart_string("  异步结果: ") + result.toString());
    auto results = DART_AWAIT(Future::wait(_GrowableList::_literal3(Future::delayed(ObjectPtr<Duration>(new Duration(/*milliseconds:*/ dart_int(5))), [&]() { return dart_string("A"); }), Future::delayed(ObjectPtr<Duration>(new Duration(/*milliseconds:*/ dart_int(10))), [&]() { return dart_string("B"); }), Future::delayed(ObjectPtr<Duration>(new Duration(/*milliseconds:*/ dart_int(15))), [&]() { return dart_string("C"); }))));
    dart_print(dart_string("  并行结果: ") + results.toString());
    dart_print(dart_string("  Stream测试:"));
    {
    auto :stream = generateNumbers(dart_int(3));
    auto :for-iterator = ObjectPtr<_StreamIterator>(new _StreamIterator(:stream));
    try { /* try block */ } catch (const std::exception& e) { /* catch block */ }
}
    try {
    DART_AWAIT(riskyAsyncOperation());
} catch (const std::exception& e) { /* catch block */ }
// Finally block should be implemented using RAII pattern
    dart_print(dart_string("  ✓ 异步编程测试完成"));
}
    DART_ASYNC_END
}

void testGenerics() {
  {
    dart_print(dart_string("
📌 测试泛型"));
    auto intBox = ObjectPtr<Box>(new Box(dart_int(42)));
    auto stringBox = ObjectPtr<Box>(new Box(dart_string("Hello")));
    dart_print(dart_string("  整数盒子: ") + intBox->getValue().toString());
    dart_print(dart_string("  字符串盒子: ") + stringBox->getValue().toString());
    dart_print(dart_string("  泛型方法: ") + identity(dart_int(100)).toString());
    dart_print(dart_string("  泛型方法: ") + identity(dart_string("test")).toString());
    auto pair = ObjectPtr<Pair>(new Pair(dart_string("Alice"), dart_int(25)));
    dart_print(dart_string("  键值对: ") + pair->first.toString() + dart_string(" -> ") + pair->second.toString());
    auto calculator = ObjectPtr<Calculator>(new Calculator());
    dart_print(dart_string("  泛型计算: ") + calculator->add(dart_int(5), dart_int(3)).toString());
    dart_print(dart_string("  ✓ 泛型测试完成"));
}
}

void testExceptionHandling() {
  {
    dart_print(dart_string("
📌 测试异常处理"));
    try {
    throw DartException(Exception::(dart_string("测试异常")));
} catch (const std::exception& e) { /* catch block */ }
// Finally block should be implemented using RAII pattern
    try {
    validateAge((-dart_int(5)));
} catch (const std::exception& e) { /* catch block */ }
// Finally block should be implemented using RAII pattern
    try {
    throw DartException(ObjectPtr<CustomException>(new CustomException(dart_string("自定义错误"), dart_int(404))));
} catch (const std::exception& e) { /* catch block */ }
// Finally block should be implemented using RAII pattern
    try { /* try block */ } catch (const std::exception& e) { /* catch block */ }
    dart_print(dart_string("  ✓ 异常处理测试完成"));
}
}

void testAdvancedFeatures() {
  {
    dart_print(dart_string("
📌 测试高级特性"));
    auto counter = createCounter();
    dart_print(dart_string("  闭包计数: ") + counter().toString() + dart_string(", ") + counter().toString() + dart_string(", ") + counter().toString());
    auto numbers = _GrowableList::_literal5(dart_int(1), dart_int(2), dart_int(3), dart_int(4), dart_int(5));
    auto processed = processNumbers(numbers, [&](Int n) { return (n * n); });
    dart_print(dart_string("  高阶函数: ") + processed.toString());
    auto text = dart_string("hello world");
    dart_print(dart_string("  字符串处理: ") + text->toUpperCase().toString());
    auto nullable = nullptr;
    auto safe = ([&]() { String let_var = nullable; return (let_var == nullptr) ? dart_string("默认值") : let_var; })();
    dart_print(dart_string("  空安全: ") + safe.toString());
    auto list = ([&]() { List<Int> let_var = _GrowableList::(dart_int(0)); return ([&]() { let_var->add(dart_int(1)); let_var->add(dart_int(2)); let_var->add(dart_int(3)); return let_var; })(); })();
    dart_print(dart_string("  级联操作: ") + list.toString());
    dart_print(dart_string("  ✓ 高级特性测试完成"));
}
}

Int addNumbers(Int a, Int b) {
  {
    return (a + b);
}
}

void greetPerson(String name, String title) {
  {
    if (!((title == nullptr))) {
    dart_print(dart_string("  问候: Hello, ") + title.toString() + dart_string(" ") + name.toString());
} else {
    dart_print(dart_string("  问候: Hello, ") + name.toString());
}
}
}

Any identity(Any value) {
  {
    return value;
}
}

void validateAge(Int age) {
  {
    if ((age < dart_int(0))) {
    throw DartException(ObjectPtr<ArgumentError>(new ArgumentError(dart_string("年龄不能为负数"))));
}
}
}

void performRiskyOperation() {
  {
    throw DartException(Exception::(dart_string("风险操作失败")));
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

List<Int> processNumbers(List<Int> numbers, std::function<Int()> processor) {
  {
    return numbers->map(processor)->toList();
}
}

DART_ASYNC_FUNCTION(Stream<Int>, generateNumbers, (Int count)) {
    DART_ASYNC_BEGIN
  {
    for (auto i = dart_int(1);; (i <= count); i = (i + dart_int(1))) {
    DART_AWAIT(Future::delayed(ObjectPtr<Duration>(new Duration(/*milliseconds:*/ dart_int(10)))));
    co_yield i;  // C++20 coroutine
}
}
    DART_ASYNC_END
}

DART_ASYNC_FUNCTION(Future<void>, riskyAsyncOperation, ()) {
    DART_ASYNC_BEGIN
  {
    DART_AWAIT(Future::delayed(ObjectPtr<Duration>(new Duration(/*milliseconds:*/ dart_int(5)))));
    throw DartException(Exception::(dart_string("异步操作失败")));
}
    DART_ASYNC_END
}

// ============================================================================
// 主函数
// ============================================================================

int main() {
  try {
    {
      dart_print(dart_string("🚀 Dart2CPP 综合测试开始"));
      dart_print((dart_string("=") * dart_int(60)));
      testBasicSyntax();
      testObjectOriented();
      testCollections();
      DART_AWAIT(testAsyncProgramming());
      testGenerics();
      testExceptionHandling();
      testAdvancedFeatures();
      dart_print((dart_string("=") * dart_int(60)));
      dart_print(dart_string("✅ 所有测试完成"));
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
