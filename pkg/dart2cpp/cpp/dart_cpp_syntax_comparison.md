# Dart 与 C++ 语法写法对照表

本文档提供了 Dart 语言与 C++ 语言在 dart2cpp 项目中的语法转换对照表，涵盖了所有主要的 Dart 语法特性及其对应的 C++ 实现方式。

## 目录

1. [基本数据类型](#1-基本数据类型)
2. [空值安全](#2-空值安全)
3. [字符串操作](#3-字符串操作)
4. [运算符](#4-运算符)
5. [控制流语句](#5-控制流语句)
6. [循环语句](#6-循环语句)
7. [函数定义与调用](#7-函数定义与调用)
8. [类和对象](#8-类和对象)
9. [继承和多态](#9-继承和多态)
10. [接口实现](#10-接口实现)
11. [泛型](#11-泛型)
12. [集合操作](#12-集合操作)
13. [异常处理](#13-异常处理)
14. [异步编程](#14-异步编程)
15. [扩展方法](#15-扩展方法)
16. [枚举](#16-枚举)
17. [类型检查和转换](#17-类型检查和转换)
18. [级联操作符](#18-级联操作符)
19. [静态成员](#19-静态成员)
20. [输出和调试](#20-输出和调试)

---

## 1. 基本数据类型

| Dart 语法 | C++ 转换 | 说明 |
|-----------|----------|------|
| `int value = 42;` | `Int value = Int(42);` | 整数类型 |
| `double pi = 3.14;` | `Double pi = Double(3.14);` | 浮点数类型 |
| `bool flag = true;` | `Bool flag = Bool(true);` | 布尔类型 |
| `String text = "Hello";` | `String text = String("Hello");` | 字符串类型 |
| `var auto = 100;` | `auto auto_var = Int(100);` | 自动类型推断 |
| `final int x = 10;` | `const Int x = Int(10);` | 不可变变量 |
| `const double PI = 3.14;` | `const Double PI = Double(3.14);` | 编译时常量 |

## 2. 空值安全

| Dart 语法 | C++ 转换 | 说明 |
|-----------|----------|------|
| `int? nullable;` | `ObjectPtr<Int> nullable;` | 可空类型 |
| `String? text = null;` | `ObjectPtr<String> text = ObjectPtr<String>();` | 空值赋值 |
| `value ?? defaultValue` | `value.isNull() ? defaultValue : value` | 空值合并运算符 |
| `obj?.method()` | `obj.isNotNull() ? obj->method() : nullptr` | 安全调用运算符 |
| `obj!.method()` | `obj->method()` | 非空断言运算符 |

## 3. 字符串操作

| Dart 语法 | C++ 转换 | 说明 |
|-----------|----------|------|
| `'Hello $name'` | `String("Hello ") + name` | 字符串插值 |
| `'Result: ${a + b}'` | `String("Result: ") + (a + b).toString()` | 表达式插值 |
| `'''多行字符串'''` | `String("多行\n字符串")` | 多行字符串 |
| `text.length` | `text.get_length()` | 字符串长度 |
| `text.contains("sub")` | `text.contains(String("sub"))` | 包含检查 |
| `text.toUpperCase()` | `text.toUpperCase()` | 转大写 |

## 4. 运算符

| Dart 语法 | C++ 转换 | 说明 |
|-----------|----------|------|
| `a + b` | `a + b` | 算术运算 |
| `a == b` | `a == b` | 相等比较 |
| `a && b` | `a && b` | 逻辑与 |
| `a \|\| b` | `a \|\| b` | 逻辑或 |
| `!a` | `!a` | 逻辑非 |
| `a ~/ b` | `a.integerDivision(b)` | 整除 |
| `a % b` | `a % b` | 取模 |
| `condition ? a : b` | `condition.toBool() ? a : b` | 三元运算符 |

## 5. 控制流语句

### if-else 语句

| Dart 语法 | C++ 转换 |
|-----------|----------|
| ```dart<br>if (score >= 90) {<br>  print('优秀');<br>} else if (score >= 80) {<br>  print('良好');<br>} else {<br>  print('一般');<br>}<br>``` | ```cpp<br>if (score.value >= 90) {<br>  dart_print(String("优秀"));<br>} else if (score.value >= 80) {<br>  dart_print(String("良好"));<br>} else {<br>  dart_print(String("一般"));<br>}<br>``` |

### switch-case 语句

| Dart 语法 | C++ 转换 |
|-----------|----------|
| ```dart<br>switch (grade) {<br>  case 'A':<br>    print('优秀');<br>    break;<br>  case 'B':<br>    print('良好');<br>    break;<br>  default:<br>    print('未知');<br>}<br>``` | ```cpp<br>if (grade.getValue() == "A") {<br>  dart_print(String("优秀"));<br>} else if (grade.getValue() == "B") {<br>  dart_print(String("良好"));<br>} else {<br>  dart_print(String("未知"));<br>}<br>``` |

## 6. 循环语句

### for 循环

| Dart 语法 | C++ 转换 |
|-----------|----------|
| ```dart<br>for (int i = 0; i < 5; i++) {<br>  print(i);<br>}<br>``` | ```cpp<br>for (int i = 0; i < 5; i++) {<br>  dart_print(Int(i).toString());<br>}<br>``` |

### for-in 循环

| Dart 语法 | C++ 转换 |
|-----------|----------|
| ```dart<br>for (String item in list) {<br>  print(item);<br>}<br>``` | ```cpp<br>for (int i = 0; i < list->size().toInt(); i++) {<br>  String item = list->get(i);<br>  dart_print(item);<br>}<br>``` |

### while 循环

| Dart 语法 | C++ 转换 |
|-----------|----------|
| ```dart<br>while (count < 10) {<br>  count++;<br>}<br>``` | ```cpp<br>while (count.value < 10) {<br>  count = Int(count.value + 1);<br>}<br>``` |

### do-while 循环

| Dart 语法 | C++ 转换 |
|-----------|----------|
| ```dart<br>do {<br>  count++;<br>} while (count < 10);<br>``` | ```cpp<br>do {<br>  count = Int(count.value + 1);<br>} while (count.value < 10);<br>``` |

## 7. 函数定义与调用

### 基本函数

| Dart 语法 | C++ 转换 |
|-----------|----------|
| ```dart<br>int add(int a, int b) {<br>  return a + b;<br>}<br>``` | ```cpp<br>Int add(const Int& a, const Int& b) {<br>  return a + b;<br>}<br>``` |

### 可选参数

| Dart 语法 | C++ 转换 |
|-----------|----------|
| ```dart<br>void greet(String name, [String? title]) {<br>  // 实现<br>}<br>``` | ```cpp<br>void greet(const String& name, const ObjectPtr<String>& title = ObjectPtr<String>()) {<br>  // 实现<br>}<br>``` |

### 命名参数

| Dart 语法 | C++ 转换 |
|-----------|----------|
| ```dart<br>void createUser({required String name, int age = 0}) {<br>  // 实现<br>}<br>``` | ```cpp<br>struct CreateUserParams {<br>  String name;<br>  Int age = Int(0);<br>};<br>void createUser(const CreateUserParams& params) {<br>  // 实现<br>}<br>``` |

### 匿名函数/Lambda

| Dart 语法 | C++ 转换 |
|-----------|----------|
| ```dart<br>var multiply = (int a, int b) => a * b;<br>``` | ```cpp<br>auto multiply = [](const Int& a, const Int& b) -> Int {<br>  return a * b;<br>};<br>``` |

## 8. 类和对象

### 基本类定义

| Dart 语法 | C++ 转换 |
|-----------|----------|
| ```dart<br>class Person {<br>  String name;<br>  int age;<br>  <br>  Person(this.name, this.age);<br>  <br>  void introduce() {<br>    print('I am $name');<br>  }<br>}<br>``` | ```cpp<br>class Person : public Object {<br>public:<br>  String name;<br>  Int age;<br>  <br>  Person(const String& n, const Int& a) : name(n), age(a) {}<br>  <br>  void introduce() {<br>    dart_print(String("I am ") + name);<br>  }<br>};<br>``` |

### 构造函数

| Dart 语法 | C++ 转换 |
|-----------|----------|
| ```dart<br>class Point {<br>  double x, y;<br>  <br>  Point(this.x, this.y);<br>  Point.origin() : x = 0, y = 0;<br>  Point.fromPolar(double r, double theta) <br>    : x = r * cos(theta), y = r * sin(theta);<br>}<br>``` | ```cpp<br>class Point : public Object {<br>public:<br>  Double x, y;<br>  <br>  Point(const Double& x_val, const Double& y_val) : x(x_val), y(y_val) {}<br>  <br>  static Point origin() {<br>    return Point(Double(0), Double(0));<br>  }<br>  <br>  static Point fromPolar(const Double& r, const Double& theta) {<br>    return Point(r * Double(cos(theta.value)), r * Double(sin(theta.value)));<br>  }<br>};<br>``` |

### Getter 和 Setter

| Dart 语法 | C++ 转换 |
|-----------|----------|
| ```dart<br>class Rectangle {<br>  double _width, _height;<br>  <br>  double get area => _width * _height;<br>  set width(double value) => _width = value;<br>}<br>``` | ```cpp<br>class Rectangle : public Object {<br>private:<br>  Double _width, _height;<br>  <br>public:<br>  Double getArea() const {<br>    return _width * _height;<br>  }<br>  <br>  void setWidth(const Double& value) {<br>    _width = value;<br>  }<br>  <br>  Double getWidth() const {<br>    return _width;<br>  }<br>};<br>``` |

## 9. 继承和多态

### 继承

| Dart 语法 | C++ 转换 |
|-----------|----------|
| ```dart<br>class Student extends Person {<br>  String studentId;<br>  <br>  Student(String name, int age, this.studentId) <br>    : super(name, age);<br>  <br>  @override<br>  void introduce() {<br>    super.introduce();<br>    print('Student ID: $studentId');<br>  }<br>}<br>``` | ```cpp<br>class Student : public Person {<br>public:<br>  String studentId;<br>  <br>  Student(const String& name, const Int& age, const String& id) <br>    : Person(name, age), studentId(id) {}<br>  <br>  void introduce() override {<br>    Person::introduce();<br>    dart_print(String("Student ID: ") + studentId);<br>  }<br>};<br>``` |

### 抽象类

| Dart 语法 | C++ 转换 |
|-----------|----------|
| ```dart<br>abstract class Shape {<br>  double area();<br>  double perimeter();<br>}<br><br>class Circle extends Shape {<br>  double radius;<br>  <br>  Circle(this.radius);<br>  <br>  @override<br>  double area() => 3.14159 * radius * radius;<br>}<br>``` | ```cpp<br>class Shape : public Object {<br>public:<br>  virtual Double area() = 0;<br>  virtual Double perimeter() = 0;<br>  virtual ~Shape() = default;<br>};<br><br>class Circle : public Shape {<br>public:<br>  Double radius;<br>  <br>  Circle(const Double& r) : radius(r) {}<br>  <br>  Double area() override {<br>    return Double(3.14159) * radius * radius;<br>  }<br>};<br>``` |

## 10. 接口实现

| Dart 语法 | C++ 转换 |
|-----------|----------|
| ```dart<br>abstract class Drawable {<br>  void draw();<br>}<br><br>class Circle implements Drawable {<br>  @override<br>  void draw() {<br>    print('Drawing circle');<br>  }<br>}<br>``` | ```cpp<br>class Drawable {<br>public:<br>  virtual void draw() = 0;<br>  virtual ~Drawable() = default;<br>};<br><br>class Circle : public Object, public Drawable {<br>public:<br>  void draw() override {<br>    dart_print(String("Drawing circle"));<br>  }<br>};<br>``` |

## 11. 泛型

### 泛型类

| Dart 语法 | C++ 转换 |
|-----------|----------|
| ```dart<br>class Box<T> {<br>  T value;<br>  Box(this.value);<br>  T getValue() => value;<br>}<br>``` | ```cpp<br>template<typename T><br>class Box : public Object {<br>public:<br>  T value;<br>  <br>  Box(const T& v) : value(v) {}<br>  <br>  T getValue() const {<br>    return value;<br>  }<br>};<br>``` |

### 泛型方法

| Dart 语法 | C++ 转换 |
|-----------|----------|
| ```dart<br>void swap<T>(List<T> list, int i, int j) {<br>  T temp = list[i];<br>  list[i] = list[j];<br>  list[j] = temp;<br>}<br>``` | ```cpp<br>template<typename T><br>void swap(ObjectPtr<List<T>> list, const Int& i, const Int& j) {<br>  T temp = list->get(i);<br>  list->operator[](i) = list->get(j);<br>  list->operator[](j) = temp;<br>}<br>``` |

## 12. 集合操作

### List 操作

| Dart 语法 | C++ 转换 |
|-----------|----------|
| ```dart<br>List<int> numbers = [1, 2, 3];<br>numbers.add(4);<br>numbers.insert(0, 0);<br>int first = numbers.first;<br>int length = numbers.length;<br>``` | ```cpp<br>ObjectPtr<List<Int>> numbers = List<Int>::create({Int(1), Int(2), Int(3)});<br>numbers->add(Int(4));<br>numbers->insert(Int(0), Int(0));<br>Int first = numbers->getFirst();<br>Int length = numbers->size();<br>``` |

### Map 操作

| Dart 语法 | C++ 转换 |
|-----------|----------|
| ```dart<br>Map<String, int> scores = {'Alice': 95, 'Bob': 87};<br>scores['Charlie'] = 92;<br>int? aliceScore = scores['Alice'];<br>bool hasKey = scores.containsKey('Alice');<br>``` | ```cpp<br>ObjectPtr<Map<String, Int>> scores = Map<String, Int>::create({<br>  {String("Alice"), Int(95)}, <br>  {String("Bob"), Int(87)}<br>});<br>scores->put(String("Charlie"), Int(92));<br>Int aliceScore = scores->get(String("Alice"));<br>Bool hasKey = scores->containsKey(String("Alice"));<br>``` |

### Set 操作

| Dart 语法 | C++ 转换 |
|-----------|----------|
| ```dart<br>Set<String> fruits = {'apple', 'banana'};<br>fruits.add('orange');<br>bool contains = fruits.contains('apple');<br>Set<String> union = fruits.union(other);<br>``` | ```cpp<br>ObjectPtr<Set<String>> fruits = Set<String>::create({String("apple"), String("banana")});<br>fruits->add(String("orange"));<br>Bool contains = fruits->contains(String("apple"));<br>ObjectPtr<Set<String>> union_set = fruits->unionWith(other);<br>``` |

## 13. 异常处理

| Dart 语法 | C++ 转换 |
|-----------|----------|
| ```dart<br>try {<br>  int result = divide(10, 0);<br>} catch (e) {<br>  print('Error: $e');<br>} finally {<br>  print('Cleanup');<br>}<br>``` | ```cpp<br>try {<br>  Int result = divide(Int(10), Int(0));<br>} catch (const std::exception& e) {<br>  dart_print(String("Error: ") + String(e.what()));<br>}<br>// C++ 没有 finally，使用 RAII 或手动清理<br>dart_print(String("Cleanup"));<br>``` |

### 自定义异常

| Dart 语法 | C++ 转换 |
|-----------|----------|
| ```dart<br>class CustomException implements Exception {<br>  final String message;<br>  CustomException(this.message);<br>}<br><br>throw CustomException('Something went wrong');<br>``` | ```cpp<br>class CustomException : public std::exception {<br>private:<br>  String message;<br>public:<br>  CustomException(const String& msg) : message(msg) {}<br>  const char* what() const noexcept override {<br>    return message.getValue().c_str();<br>  }<br>};<br><br>throw CustomException(String("Something went wrong"));<br>``` |

## 14. 异步编程

### Future

| Dart 语法 | C++ 转换 |
|-----------|----------|
| ```dart<br>Future<String> fetchData() async {<br>  await Future.delayed(Duration(seconds: 1));<br>  return 'Data loaded';<br>}<br><br>fetchData().then((data) {<br>  print(data);<br>}).catchError((error) {<br>  print('Error: $error');<br>});<br>``` | ```cpp<br>// 使用 std::future 和 std::async 模拟<br>std::future<String> fetchData() {<br>  return std::async(std::launch::async, []() -> String {<br>    std::this_thread::sleep_for(std::chrono::seconds(1));<br>    return String("Data loaded");<br>  });<br>}<br><br>auto future = fetchData();<br>try {<br>  String data = future.get();<br>  dart_print(data);<br>} catch (const std::exception& error) {<br>  dart_print(String("Error: ") + String(error.what()));<br>}<br>``` |

### Stream

| Dart 语法 | C++ 转换 |
|-----------|----------|
| ```dart<br>Stream<int> generateNumbers() async* {<br>  for (int i = 0; i < 5; i++) {<br>    yield i;<br>    await Future.delayed(Duration(milliseconds: 100));<br>  }<br>}<br><br>generateNumbers().listen((number) {<br>  print('Number: $number');<br>});<br>``` | ```cpp<br>// 使用回调函数模拟 Stream<br>class NumberStream {<br>public:<br>  void listen(std::function<void(Int)> callback) {<br>    std::thread([callback]() {<br>      for (int i = 0; i < 5; i++) {<br>        callback(Int(i));<br>        std::this_thread::sleep_for(std::chrono::milliseconds(100));<br>      }<br>    }).detach();<br>  }<br>};<br><br>NumberStream stream;<br>stream.listen([](Int number) {<br>  dart_print(String("Number: ") + number.toString());<br>});<br>``` |

## 15. 扩展方法

| Dart 语法 | C++ 转换 |
|-----------|----------|
| ```dart<br>extension StringExtension on String {<br>  String capitalize() {<br>    return this[0].toUpperCase() + this.substring(1);<br>  }<br>  <br>  bool isPalindrome() {<br>    return this == this.split('').reversed.join('');<br>  }<br>}<br><br>String text = 'hello';<br>print(text.capitalize());<br>``` | ```cpp<br>// C++ 中通过继承或静态函数实现扩展功能<br>class StringExtension {<br>public:<br>  static String capitalize(const String& str) {<br>    if (str.get_length().value == 0) return str;<br>    String first = str.substring(Int(0), Int(1)).toUpperCase();<br>    String rest = str.substring(Int(1));<br>    return first + rest;<br>  }<br>  <br>  static Bool isPalindrome(const String& str) {<br>    String reversed = str.reverse();<br>    return str == reversed;<br>  }<br>};<br><br>String text = String("hello");<br>dart_print(StringExtension::capitalize(text));<br>``` |

## 16. 枚举

### 基本枚举

| Dart 语法 | C++ 转换 |
|-----------|----------|
| ```dart<br>enum Color { red, green, blue }<br><br>Color favorite = Color.red;<br>print(favorite.name);<br>``` | ```cpp<br>enum class Color {<br>  red,<br>  green,<br>  blue<br>};<br><br>class ColorHelper {<br>public:<br>  static String getName(Color color) {<br>    switch (color) {<br>      case Color::red: return String("red");<br>      case Color::green: return String("green");<br>      case Color::blue: return String("blue");<br>      default: return String("unknown");<br>    }<br>  }<br>};<br><br>Color favorite = Color::red;<br>dart_print(ColorHelper::getName(favorite));<br>``` |

### 增强枚举

| Dart 语法 | C++ 转换 |
|-----------|----------|
| ```dart<br>enum Planet {<br>  mercury(3.303e+23, 2.4397e6),<br>  venus(4.869e+24, 6.0518e6),<br>  earth(5.976e+24, 6.37814e6);<br>  <br>  const Planet(this.mass, this.radius);<br>  final double mass;<br>  final double radius;<br>}<br>``` | ```cpp<br>class Planet {<br>public:<br>  enum Type { mercury, venus, earth };<br>  <br>  Type type;<br>  Double mass;<br>  Double radius;<br>  <br>  Planet(Type t, const Double& m, const Double& r) <br>    : type(t), mass(m), radius(r) {}<br>  <br>  static Planet getMercury() {<br>    return Planet(mercury, Double(3.303e+23), Double(2.4397e6));<br>  }<br>  <br>  static Planet getVenus() {<br>    return Planet(venus, Double(4.869e+24), Double(6.0518e6));<br>  }<br>  <br>  static Planet getEarth() {<br>    return Planet(earth, Double(5.976e+24), Double(6.37814e6));<br>  }<br>};<br>``` |

## 17. 类型检查和转换

| Dart 语法 | C++ 转换 |
|-----------|----------|
| ```dart<br>if (obj is String) {<br>  print('It is a string: ${obj.length}');<br>}<br><br>String str = obj as String;<br>``` | ```cpp<br>if (auto str_ptr = dynamic_cast<String*>(&obj)) {<br>  dart_print(String("It is a string: ") + str_ptr->get_length().toString());<br>}<br><br>String& str = dynamic_cast<String&>(obj);<br>``` |

## 18. 级联操作符

| Dart 语法 | C++ 转换 |
|-----------|----------|
| ```dart<br>var person = Person('Alice', 25)<br>  ..introduce()<br>  ..age = 26<br>  ..introduce();<br>``` | ```cpp<br>Person person("Alice", 25);<br>person.introduce();<br>person.age = Int(26);<br>person.introduce();<br>// 或者使用链式调用模式<br>``` |

## 19. 静态成员

| Dart 语法 | C++ 转换 |
|-----------|----------|
| ```dart<br>class MathUtils {<br>  static const double PI = 3.14159;<br>  <br>  static int factorial(int n) {<br>    return n <= 1 ? 1 : n * factorial(n - 1);<br>  }<br>}<br><br>print(MathUtils.PI);<br>int result = MathUtils.factorial(5);<br>``` | ```cpp<br>class MathUtils : public Object {<br>public:<br>  static const Double PI;<br>  <br>  static Int factorial(const Int& n) {<br>    return n.value <= 1 ? Int(1) : n * factorial(Int(n.value - 1));<br>  }<br>};<br><br>const Double MathUtils::PI = Double(3.14159);<br><br>dart_print(MathUtils::PI.toString());<br>Int result = MathUtils::factorial(Int(5));<br>``` |

## 20. 输出和调试

| Dart 语法 | C++ 转换 |
|-----------|----------|
| ```dart<br>print('Hello World');<br>print('Value: $value');<br>debugPrint('Debug info');<br>``` | ```cpp<br>dart_print(String("Hello World"));<br>dart_print(String("Value: ") + value.toString());<br>std::cout << "Debug info" << std::endl;<br>``` |

---

## 总结

这个对照表涵盖了 Dart 语言的主要语法特性及其在 dart2cpp 项目中的 C++ 实现方式。主要特点包括：

1. **类型系统**：Dart 的基本类型被包装为 C++ 类（Int、Double、Bool、String）
2. **空值安全**：使用 ObjectPtr 智能指针实现可空类型
3. **集合类型**：List、Map、Set 使用模板和智能指针实现
4. **面向对象**：继承、多态、抽象类通过标准 C++ 机制实现
5. **异步编程**：使用 std::future、std::thread 等标准库功能模拟
6. **内存管理**：通过引用计数和智能指针自动管理内存

通过这个对照表，开发者可以了解如何将 Dart 代码转换为对应的 C++ 代码，实现跨语言的代码转换和互操作。