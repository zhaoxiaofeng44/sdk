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
| `int value = 42;` | `Int value = dart_int(42);` | 整数类型 |
| `double pi = 3.14;` | `Double pi = dart_double(3.14);` | 浮点数类型 |
| `bool flag = true;` | `Bool flag = dart_bool(true);` | 布尔类型 |
| `String text = "Hello";` | `String text = dart_string("Hello");` | 字符串类型 |
| `var auto = 100;` | `auto auto_var = dart_int(100);` | 自动类型推断 |
| `final int x = 10;` | `const Int x = dart_int(10);` | 不可变变量 |
| `const double PI = 3.14;` | `const Double PI = dart_double(3.14);` | 编译时常量 |

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
| `'Hello $name'` | `dart_string("Hello ") + name` | 字符串插值 |
| `'Result: ${a + b}'` | `dart_string("Result: ") + (a + b).toString()` | 表达式插值 |
| `'''多行字符串'''` | `dart_string("多行\n字符串")` | 多行字符串 |
| `text.length` | `text.get_length()` | 字符串长度 |
| `text.contains("sub")` | `text.contains(dart_string("sub"))` | 包含检查 |
| `text.toUpperCase()` | `text.toUpperCase()` | 转大写 |

## 4. 运算符

| Dart 语法 | C++ 转换 | 说明 |
|-----------|----------|------|
| `a + b` | `a + b` | 算术运算 |
| `a - b` | `a - b` | 减法 |
| `a * b` | `a * b` | 乘法 |
| `a / b` | `a / b` | 除法 |
| `a % b` | `a % b` | 取模 |
| `a ~/ b` | `a.integerDivision(b)` | 整除 |
| `a == b` | `a == b` | 相等比较 |
| `a != b` | `a != b` | 不相等 |
| `a < b` | `a < b` | 小于 |
| `a <= b` | `a <= b` | 小于等于 |
| `a > b` | `a > b` | 大于 |
| `a >= b` | `a >= b` | 大于等于 |
| `a && b` | `a && b` | 逻辑与 |
| `a \|\| b` | `a \|\| b` | 逻辑或 |
| `!a` | `!a` | 逻辑非 |
| `a += b` | `a += b` | 复合赋值 |
| `a -= b` | `a -= b` | 复合减法 |
| `a *= b` | `a *= b` | 复合乘法 |
| `a /= b` | `a /= b` | 复合除法 |
| `a %= b` | `a %= b` | 复合取模 |
| `a++` | `a++` | 后置自增 |
| `++a` | `++a` | 前置自增 |
| `a--` | `a--` | 后置自减 |
| `--a` | `--a` | 前置自减 |
| `condition ? a : b` | `condition ? a : b` | 三元运算符（Bool类型自动转换） |
| `a & b` | `a.operator_bitwise_and(b)` | 位与 |
| `a \| b` | `a.operator_bitwise_or(b)` | 位或 |
| `a ^ b` | `a.operator_bitwise_xor(b)` | 位异或 |
| `a << b` | `a.operator_shift_left(b)` | 左移 |
| `a >> b` | `a.operator_shift_right(b)` | 右移 |
| `~a` | `a.operator_bitwise_not()` | 位取反 |

## 5. 控制流语句

### if-else 语句

| Dart 语法 | C++ 转换 |
|-----------|---------|
| ```dart<br>if (score >= 90) {<br>  print('优秀');<br>} else if (score >= 80) {<br>  print('良好');<br>} else {<br>  print('一般');<br>}<br>``` | ```cpp<br>if (score >= dart_int(90)) {<br>  dart_print(dart_string("优秀"));<br>} else if (score >= dart_int(80)) {<br>  dart_print(dart_string("良好"));<br>} else {<br>  dart_print(dart_string("一般"));<br>}<br>``` |

### switch-case 语句

| Dart 语法 | C++ 转换 |
|-----------|---------|
| ```dart<br>switch (grade) {<br>  case 'A':<br>    print('优秀');<br>    break;<br>  case 'B':<br>    print('良好');<br>    break;<br>  default:<br>    print('未知');<br>}<br>``` | ```cpp<br>if (grade == dart_string("A")) {<br>  dart_print(dart_string("优秀"));<br>} else if (grade == dart_string("B")) {<br>  dart_print(dart_string("良好"));<br>} else {<br>  dart_print(dart_string("未知"));<br>}<br>``` |

## 6. 循环语句

### for 循环

| Dart 语法 | C++ 转换 |
|-----------|----------|
| ```dart<br>for (int i = 0; i < 5; i++) {<br>  print(i);<br>}<br>``` | ```cpp<br>for (Int i = dart_int(0); i < dart_int(5); i++) {<br>  dart_print(i.toString());<br>}<br>``` |

### for-in 循环

| Dart 语法 | C++ 转换 |
|-----------|----------|
| ```dart<br>for (String item in list) {<br>  print(item);<br>}<br>``` | ```cpp<br>for (Int i = dart_int(0); i < list->size(); i++) {<br>  String item = list->get(i);<br>  dart_print(item);<br>}<br>``` |

### while 循环

| Dart 语法 | C++ 转换 |
|-----------|---------|
| ```dart<br>while (count < 10) {<br>  count++;<br>}<br>``` | ```cpp<br>while (count < dart_int(10)) {<br>  count++;  // 直接使用自增运算符<br>}<br>``` |

### do-while 循环

| Dart 语法 | C++ 转换 |
|-----------|---------|
| ```dart<br>do {<br>  count++;<br>} while (count < 10);<br>``` | ```cpp<br>do {<br>  count++;  // 直接使用自增运算符<br>} while (count < dart_int(10));<br>``` |

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
| ```dart<br>void createUser({required String name, int age = 0}) {<br>  // 实现<br>}<br>``` | ```cpp<br>struct CreateUserParams {<br>  String name;<br>  Int age = dart_int(0);<br>};<br>void createUser(const CreateUserParams& params) {<br>  // 实现<br>}<br>``` |

### 匿名函数/Lambda

| Dart 语法 | C++ 转换 |
|-----------|----------|
| ```dart<br>var multiply = (int a, int b) => a * b;<br>``` | ```cpp<br>auto multiply = [](const Int& a, const Int& b) -> Int {<br>  return a * b;<br>};<br>``` |

## 8. 类和对象

### 基本类定义

| Dart 语法 | C++ 转换 |
|-----------|---------|
| ```dart<br>class Person {<br>  String name;<br>  int age;<br>  <br>  Person(this.name, this.age);<br>  <br>  void introduce() {<br>    print('I am $name');<br>  }<br>}<br>``` | ```cpp<br>class Person : public Object {<br>public:<br>  String name;<br>  Int age;<br>  <br>  Person(const String& n, const Int& a) : name(n), age(a) {}<br>  <br>  void introduce() {<br>    dart_print(dart_string("I am ") + name);<br>  }<br>};<br>``` |

### 对象创建和使用（重要！）

| Dart 语法 | C++ 转换 | 说明 |
|-----------|----------|------|
| ```dart<br>Person person = Person('Alice', 25);<br>person.introduce();<br>print(person.name);<br>``` | ```cpp<br>// 使用 ObjectPtr 智能指针包裹自定义类对象<br>ObjectPtr<Person> person = ObjectPtr<Person>(<br>  new Person(dart_string("Alice"), dart_int(25))<br>);<br>person->introduce();<br>dart_print(person->name);<br>``` | **所有自定义类对象必须使用 ObjectPtr 包裹**<br>- 值类型（Int、Double、Bool、String）不需要<br>- 自定义类、容器类型必须使用<br>- 成员访问使用 `->` 而非 `.` |

### ObjectPtr 智能指针规范

| 场景 | Dart 语法 | C++ 转换 |
|------|-----------|----------|
| 创建对象 | `var obj = MyClass(args);` | `ObjectPtr<MyClass> obj = ObjectPtr<MyClass>(new MyClass(args));` |
| 访问成员 | `obj.field`<br>`obj.method()` | `obj->field`<br>`obj->method()` |
| 函数参数 | `void func(MyClass obj)` | `void func(const ObjectPtr<MyClass>& obj)` |
| 函数返回值 | `MyClass createObj()` | `ObjectPtr<MyClass> createObj()` |
| 多态容器 | `List<Animal> animals` | `std::vector<ObjectPtr<Animal>> animals` |
| 获取裸指针 | N/A | `obj.get()` // 用于 dynamic_cast 等场景 |

### 构造函数

| Dart 语法 | C++ 转换 |
|-----------|----------|
| ```dart<br>class Point {<br>  double x, y;<br>  <br>  Point(this.x, this.y);<br>  Point.origin() : x = 0, y = 0;<br>  Point.fromPolar(double r, double theta) <br>    : x = r * cos(theta), y = r * sin(theta);<br>}<br>``` | ```cpp<br>class Point : public Object {<br>public:<br>  Double x, y;<br>  <br>  Point(const Double& x_val, const Double& y_val) : x(x_val), y(y_val) {}<br>  <br>  static Point origin() {<br>    return Point(dart_double(0), dart_double(0));<br>  }<br>  <br>  static Point fromPolar(const Double& r, const Double& theta) {<br>    // 使用运算符重载，不需要 getValue<br>    return Point(r * dart_double(std::cos(theta)), r * dart_double(std::sin(theta)));<br>  }<br>};<br>``` |

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
| ```dart<br>abstract class Shape {<br>  double area();<br>  double perimeter();<br>}<br><br>class Circle extends Shape {<br>  double radius;<br>  <br>  Circle(this.radius);<br>  <br>  @override<br>  double area() => 3.14159 * radius * radius;<br>}<br>``` | ```cpp<br>class Shape : public Object {<br>public:<br>  virtual Double area() = 0;<br>  virtual Double perimeter() = 0;<br>  virtual ~Shape() = default;<br>};<br><br>class Circle : public Shape {<br>public:<br>  Double radius;<br>  <br>  Circle(const Double& r) : radius(r) {}<br>  <br>  Double area() override {<br>    return dart_double(3.14159) * radius * radius;<br>  }<br>};<br>``` |

## 10. 接口实现

| Dart 语法 | C++ 转换 |
|-----------|----------|
| ```dart<br>abstract class Drawable {<br>  void draw();<br>}<br><br>class Circle implements Drawable {<br>  @override<br>  void draw() {<br>    print('Drawing circle');<br>  }<br>}<br>``` | ```cpp<br>class Drawable {<br>public:<br>  virtual void draw() = 0;<br>  virtual ~Drawable() = default;<br>};<br><br>class Circle : public Object, public Drawable {<br>public:<br>  void draw() override {<br>    dart_print(dart_string("Drawing circle"));<br>  }<br>};<br>``` |

### 多重接口实现

| Dart 语法 | C++ 转换 |
|-----------|----------|
| ```dart<br>abstract class Drawable {<br>  void draw();<br>}<br><br>abstract class Movable {<br>  void move(double dx, double dy);<br>}<br><br>class Shape implements Drawable, Movable {<br>  @override<br>  void draw() { /* 实现 */ }<br>  <br>  @override<br>  void move(double dx, double dy) { /* 实现 */ }<br>}<br>``` | ```cpp<br>class Drawable {<br>public:<br>  virtual void draw() = 0;<br>  virtual ~Drawable() = default;<br>};<br><br>class Movable {<br>public:<br>  virtual void move(const Double& dx, const Double& dy) = 0;<br>  virtual ~Movable() = default;<br>};<br><br>class Shape : public Object, public Drawable, public Movable {<br>public:<br>  void draw() override { /* 实现 */ }<br>  void move(const Double& dx, const Double& dy) override { /* 实现 */ }<br>};<br>``` |

## 10.1 Mixin 模式

### 基本 Mixin

| Dart 语法 | C++ 转换 |
|-----------|----------|
| ```dart<br>mixin TimestampMixin {<br>  DateTime? _createdAt;<br>  DateTime? _updatedAt;<br>  <br>  void onCreate() {<br>    _createdAt = DateTime.now();<br>    _updatedAt = _createdAt;<br>  }<br>  <br>  void touch() {<br>    _updatedAt = DateTime.now();<br>  }<br>}<br><br>class Document with TimestampMixin {<br>  String title;<br>  <br>  Document(this.title) {<br>    onCreate();<br>  }<br>}<br>``` | ```cpp<br>// 在 dart_oop_extensions.h 中定义<br>class TimestampMixin {<br>protected:<br>  Double createdAt;<br>  Double updatedAt;<br>  <br>public:<br>  void onCreate() {<br>    createdAt = getCurrentTimestamp();<br>    updatedAt = createdAt;<br>  }<br>  <br>  void touch() {<br>    updatedAt = getCurrentTimestamp();<br>  }<br>  <br>  Double getCreatedAt() const { return createdAt; }<br>  Double getUpdatedAt() const { return updatedAt; }<br>};<br><br>class Document : public TimestampMixin {<br>private:<br>  String title;<br>public:<br>  Document(const String& t) : title(t) {<br>    onCreate();<br>  }<br>};<br>``` |

### 多个 Mixin 组合

| Dart 语法 | C++ 转换 |
|-----------|----------|
| ```dart<br>mixin IdentifiableMixin {<br>  int? _id;<br>  void setId(int id) => _id = id;<br>  int? getId() => _id;<br>}<br><br>mixin NameableMixin {<br>  String? _name;<br>  void setName(String name) => _name = name;<br>  String? getName() => _name;<br>}<br><br>class User with IdentifiableMixin, NameableMixin, TimestampMixin {<br>  String email;<br>  <br>  User(int id, String name, this.email) {<br>    setId(id);<br>    setName(name);<br>    onCreate();<br>  }<br>}<br>``` | ```cpp<br>class IdentifiableMixin {<br>protected:<br>  Int id;<br>public:<br>  void setId(const Int& i) { id = i; }<br>  Int getId() const { return id; }<br>  String getIdString() const {<br>    return String("ID:") + id.toString();<br>  }<br>};<br><br>class NameableMixin {<br>protected:<br>  String name;<br>public:<br>  void setName(const String& n) { name = n; }<br>  String getName() const { return name; }<br>  String getDisplayName() const {<br>    return String("[") + name + String("]");<br>  }<br>};<br><br>class User : public IdentifiableMixin, <br>             public NameableMixin, <br>             public TimestampMixin {<br>private:<br>  String email;<br>public:<br>  User(const Int& id, const String& name, const String& e) <br>    : email(e) {<br>    setId(id);<br>    setName(name);<br>    onCreate();<br>  }<br>  <br>  String getEmail() const { return email; }<br>};<br>``` |

## 10.2 复杂多重继承（Mixin + 接口 + 继承）

| Dart 语法 | C++ 转换 |
|-----------|----------|
| ```dart<br>abstract class Serializable {<br>  String serialize();<br>  bool deserialize(String data);<br>}<br><br>class Product with IdentifiableMixin, NameableMixin, TimestampMixin <br>    implements Serializable {<br>  double price;<br>  int quantity;<br>  <br>  Product(int id, String name, this.price, this.quantity) {<br>    setId(id);<br>    setName(name);<br>    onCreate();<br>  }<br>  <br>  @override<br>  String serialize() {<br>    return '{"id":$id,"name":"$name","price":$price}';<br>  }<br>  <br>  @override<br>  bool deserialize(String data) {<br>    // 实现反序列化<br>    return true;<br>  }<br>}<br>``` | ```cpp<br>class Serializable {<br>public:<br>  virtual String serialize() = 0;<br>  virtual Bool deserialize(const String& data) = 0;<br>  virtual ~Serializable() = default;<br>};<br><br>class Product : public IdentifiableMixin, <br>                public NameableMixin, <br>                public TimestampMixin, <br>                public Serializable {<br>private:<br>  Double price;<br>  Int quantity;<br>  <br>public:<br>  Product(const Int& id, const String& name, <br>          const Double& p, const Int& q) <br>    : price(p), quantity(q) {<br>    setId(id);<br>    setName(name);<br>    onCreate();<br>  }<br>  <br>  String serialize() override {<br>    return String("{\"id\":") + getId().toString() + <br>           String(",\"name\":\"") + getName() + <br>           String("\",\"price\":") + price.toString() + <br>           String("}");<br>  }<br>  <br>  Bool deserialize(const String& data) override {<br>    // 实现反序列化<br>    return Bool(true);<br>  }<br>  <br>  Double getPrice() const { return price; }<br>  Int getQuantity() const { return quantity; }<br>};<br>``` |

### 多态访问多重继承对象

| Dart 语法 | C++ 转换 |
|-----------|----------|
| ```dart<br>Product product = Product(1, 'Laptop', 999.99, 5);<br><br>// 通过不同接口访问<br>print(product.getId());        // IdentifiableMixin<br>print(product.getName());      // NameableMixin<br>print(product.getCreatedAt()); // TimestampMixin<br>String json = product.serialize(); // Serializable<br>``` | ```cpp<br>ObjectPtr<Product> product = ObjectPtr<Product>(<br>  new Product(dart_int(1), dart_string("Laptop"), <br>              dart_double(999.99), dart_int(5))<br>);<br><br>// 通过不同接口指针访问同一对象<br>IdentifiableMixin* identifiable = product.get();<br>NameableMixin* nameable = product.get();<br>TimestampMixin* timestamped = product.get();<br>Serializable* serializable = product.get();<br><br>dart_print(identifiable->getId().toString());<br>dart_print(nameable->getName());<br>dart_print(timestamped->getCreatedAt().toString());<br>String json = serializable->serialize();<br>``` |

## 11. 泛型

### 泛型类

| Dart 语法 | C++ 转换 |
|-----------|----------|
| ```dart<br>class Box<T> {<br>  T value;<br>  Box(this.value);<br>  T getValue() => value;<br>}<br>``` | ```cpp<br>template<typename T><br>class Box : public Object {<br>public:<br>  T value;<br>  <br>  Box(const T& v) : value(v) {}<br>  <br>  T getValue() const {<br>    return value;<br>  }<br>};<br>``` |

### 泛型方法

| Dart 语法 | C++ 转换 |
|-----------|----------|
| ```dart<br>void swap<T>(List<T> list, int i, int j) {<br>  T temp = list[i];<br>  list[i] = list[j];<br>  list[j] = temp;<br>}<br>``` | ```cpp<br>template<typename T><br>void swap(ObjectPtr<List<T>> list, const Int& i, const Int& j) {<br>  T temp = list->get(i);<br>  list->operator[](i) = list->get(j);<br>  list->operator[](j) = temp;<br>}<br>``` |

## 11.1 设计模式

### 单例模式

| Dart 语法 | C++ 转换 |
|-----------|----------|
| ```dart<br>class Logger {<br>  static Logger? _instance;<br>  <br>  Logger._internal();<br>  <br>  factory Logger() {<br>    _instance ??= Logger._internal();<br>    return _instance!;<br>  }<br>  <br>  void log(String message) {<br>    print('[LOG] $message');<br>  }<br>}<br><br>// 使用<br>Logger logger1 = Logger();<br>Logger logger2 = Logger();<br>// logger1 和 logger2 是同一个实例<br>``` | ```cpp<br>class Logger {<br>private:<br>  static Logger* instance;<br>  std::vector<String> logs;<br>  <br>  // 私有构造函数<br>  Logger() = default;<br>  <br>public:<br>  // 禁止拷贝和赋值<br>  Logger(const Logger&) = delete;<br>  Logger& operator=(const Logger&) = delete;<br>  <br>  static Logger* getInstance() {<br>    if (instance == nullptr) {<br>      instance = new Logger();<br>    }<br>    return instance;<br>  }<br>  <br>  void log(const String& message) {<br>    logs.push_back(message);<br>    dart_print(dart_string("[LOG] ") + message);<br>  }<br>  <br>  Int getLogCount() const {<br>    return dart_int(static_cast<int>(logs.size()));<br>  }<br>};<br><br>Logger* Logger::instance = nullptr;<br><br>// 使用<br>Logger* logger1 = Logger::getInstance();<br>Logger* logger2 = Logger::getInstance();<br>// logger1 和 logger2 指向同一个实例<br>ASSERT_TRUE(logger1 == logger2);<br>``` |

### 工厂模式

| Dart 语法 | C++ 转换 |
|-----------|----------|
| ```dart<br>abstract class Shape {<br>  double area();<br>}<br><br>class Circle extends Shape {<br>  double radius;<br>  Circle(this.radius);<br>  double area() => 3.14159 * radius * radius;<br>}<br><br>class Rectangle extends Shape {<br>  double width, height;<br>  Rectangle(this.width, this.height);<br>  double area() => width * height;<br>}<br><br>class ShapeFactory {<br>  static Shape? createShape(String type) {<br>    switch (type) {<br>      case 'circle':<br>        return Circle(1.0);<br>      case 'rectangle':<br>        return Rectangle(1.0, 1.0);<br>      default:<br>        return null;<br>    }<br>  }<br>}<br><br>// 使用<br>Shape? shape = ShapeFactory.createShape('circle');<br>``` | ```cpp<br>class Shape : public Object {<br>public:<br>  virtual Double area() = 0;<br>  virtual ~Shape() = default;<br>};<br><br>class Circle : public Shape {<br>private:<br>  Double radius;<br>public:<br>  Circle(const Double& r) : radius(r) {}<br>  Double area() override {<br>    return dart_double(3.14159) * radius * radius;<br>  }<br>};<br><br>class Rectangle : public Shape {<br>private:<br>  Double width, height;<br>public:<br>  Rectangle(const Double& w, const Double& h) <br>    : width(w), height(h) {}<br>  Double area() override {<br>    return width * height;<br>  }<br>};<br><br>class ShapeFactory {<br>public:<br>  static ObjectPtr<Shape> createShape(const String& type) {<br>    // 使用运算符重载比较，不需要 getValue<br>    if (type == dart_string("circle")) {<br>      return ObjectPtr<Shape>(new Circle(dart_double(1.0)));<br>    } else if (type == dart_string("rectangle")) {<br>      return ObjectPtr<Shape>(new Rectangle(dart_double(1.0), dart_double(1.0)));<br>    }<br>    return ObjectPtr<Shape>(); // 返回空指针<br>  }<br>};<br><br>// 使用<br>ObjectPtr<Shape> shape = ShapeFactory::createShape(dart_string("circle"));<br>if (shape.get() != nullptr) {<br>  Double area = shape->area();<br>}<br>``` |

## 12. 集合操作

### List 操作

| Dart 语法 | C++ 转换 |
|-----------|---------|
| ```dart<br>List<int> numbers = [1, 2, 3];<br>numbers.add(4);<br>numbers.insert(0, 0);<br>int first = numbers.first;<br>int length = numbers.length;<br>``` | ```cpp<br>ObjectPtr<List<Int>> numbers = List<Int>::create({dart_int(1), dart_int(2), dart_int(3)});<br>numbers->add(dart_int(4));<br>numbers->insert(dart_int(0), dart_int(0));<br>Int first = numbers->getFirst();<br>Int length = numbers->size();<br>``` |

### Map 操作

| Dart 语法 | C++ 转换 |
|-----------|---------|
| ```dart<br>Map<String, int> scores = {'Alice': 95, 'Bob': 87};<br>scores['Charlie'] = 92;<br>int? aliceScore = scores['Alice'];<br>bool hasKey = scores.containsKey('Alice');<br>``` | ```cpp<br>ObjectPtr<Map<String, Int>> scores = Map<String, Int>::create({<br>  {dart_string("Alice"), dart_int(95)}, <br>  {dart_string("Bob"), dart_int(87)}<br>});<br>scores->put(dart_string("Charlie"), dart_int(92));<br>Int aliceScore = scores->get(dart_string("Alice"));<br>Bool hasKey = scores->containsKey(dart_string("Alice"));<br>``` |

### Set 操作

| Dart 语法 | C++ 转换 |
|-----------|---------|
| ```dart<br>Set<String> fruits = {'apple', 'banana'};<br>fruits.add('orange');<br>bool contains = fruits.contains('apple');<br>Set<String> union = fruits.union(other);<br>``` | ```cpp<br>ObjectPtr<Set<String>> fruits = Set<String>::create({dart_string("apple"), dart_string("banana")});<br>fruits->add(dart_string("orange"));<br>Bool contains = fruits->contains(dart_string("apple"));<br>ObjectPtr<Set<String>> union_set = fruits->unionWith(other);<br>``` |

## 13. 异常处理

| Dart 语法 | C++ 转换 |
|-----------|----------|
| ```dart<br>try {<br>  int result = divide(10, 0);<br>} catch (e) {<br>  print('Error: $e');<br>} finally {<br>  print('Cleanup');<br>}<br>``` | ```cpp<br>try {<br>  Int result = divide(dart_int(10), dart_int(0));<br>} catch (const std::exception& e) {<br>  dart_print(dart_string("Error: ") + dart_string(e.what()));<br>}<br>// C++ 没有 finally，使用 RAII 或手动清理<br>dart_print(dart_string("Cleanup"));<br>``` |

### 自定义异常

| Dart 语法 | C++ 转换 |
|-----------|----------|
| ```dart<br>class CustomException implements Exception {<br>  final String message;<br>  CustomException(this.message);<br>}<br><br>throw CustomException('Something went wrong');<br>``` | ```cpp<br>class CustomException : public std::exception {<br>private:<br>  std::string message;<br>public:<br>  CustomException(const String& msg) : message(msg.getValue()) {}<br>  const char* what() const noexcept override {<br>    return message.c_str();<br>  }<br>};<br><br>throw CustomException(dart_string("Something went wrong"));<br>``` |

## 14. 异步编程

### Duration（时间间隔）

| Dart 语法 | C++ 转换 | 说明 |
|-----------|----------|------|
| ```dart<br>Duration d1 = Duration(seconds: 5);<br>Duration d2 = Duration(milliseconds: 500);<br>Duration d3 = Duration(minutes: 2, seconds: 30);<br><br>int ms = d1.inMilliseconds;<br>int sec = d1.inSeconds;<br>``` | ```cpp<br>ObjectPtr<Duration> d1 = Duration::seconds(5);<br>ObjectPtr<Duration> d2 = Duration::milliseconds(500);<br>ObjectPtr<Duration> d3 = Duration::minutes(2);<br>// 加法组合时间<br>Duration d3_combined = *d3 + *Duration::seconds(30);<br><br>Int ms = d1->inMilliseconds();<br>Int sec = d1->inSeconds();<br>``` | Duration 工厂方法返回 ObjectPtr<br>支持运算符重载 (+, -, *, 比较) |

### Duration 运算符

| Dart 语法 | C++ 转换 |
|-----------|---------|
| ```dart<br>Duration d1 = Duration(seconds: 3);<br>Duration d2 = Duration(milliseconds: 500);<br><br>// 加法<br>Duration sum = d1 + d2;<br><br>// 减法<br>Duration diff = d1 - d2;<br><br>// 乘法<br>Duration doubled = d1 * 2;<br><br>// 比较<br>bool greater = d1 > d2;<br>bool equal = d1 == Duration(seconds: 3);<br>``` | ```cpp<br>ObjectPtr<Duration> d1 = Duration::seconds(3);<br>ObjectPtr<Duration> d2 = Duration::milliseconds(500);<br><br>// 加法（解引用后运算）<br>Duration sum = *d1 + *d2;<br><br>// 减法<br>Duration diff = *d1 - *d2;<br><br>// 乘法<br>Duration doubled = *d1 * dart_int(2);<br><br>// 比较<br>Bool greater = (*d1 > *d2);<br>Bool equal = (*d1 == *Duration::seconds(3));<br>``` |

### Future（基础操作）

| Dart 语法 | C++ 转换 | 说明 |
|-----------|----------|------|
| ```dart<br>// 创建已完成的 Future<br>Future<int> future1 = Future.value(42);<br><br>// 创建延迟 Future<br>Future<String> future2 = Future.delayed(<br>  Duration(seconds: 1),<br>  () => 'Done'<br>);<br><br>// 等待 Future 完成<br>int result = await future1;<br>``` | ```cpp<br>// 创建已完成的 Future<br>ObjectPtr<Future<Int>> future1 = Future<Int>::value(dart_int(42));<br><br>// 创建延迟 Future<br>ObjectPtr<Future<String>> future2 = Future<String>::delayed(<br>  Duration::seconds(1),<br>  []() -> String { return dart_string("Done"); }<br>);<br><br>// 等待 Future 完成<br>Int result = future1->wait();<br>``` | Future 使用 ObjectPtr 包裹<br>延迟需要 ObjectPtr<Duration><br>常量使用 dart_* 函数 |

### Future 链式调用

| Dart 语法 | C++ 转换 |
|-----------|---------|
| ```dart<br>Future<int> calculate() async {<br>  await Future.delayed(Duration(milliseconds: 100));<br>  return 42;<br>}<br><br>calculate()<br>  .then((value) => value * 2)<br>  .then((doubled) {<br>    print('Doubled: $doubled');<br>    return doubled + 10;<br>  })<br>  .then((result) {<br>    print('Final: $result');<br>  });<br>``` | ```cpp<br>ObjectPtr<Future<Int>> calculate() {<br>  return Future<Int>::delayed(<br>    Duration::milliseconds(100),<br>    []() -> Int { return dart_int(42); }<br>  );<br>}<br><br>ObjectPtr<Future<Int>> doubled = calculate()->then<Int>([](Int value) {<br>  return value * dart_int(2);<br>});<br><br>ObjectPtr<Future<Int>> final_result = doubled->then<Int>([](Int doubled) {<br>  dart_print(dart_string("Doubled: ") + doubled.toString());<br>  return doubled + dart_int(10);<br>});<br><br>Int result = final_result->wait();<br>dart_print(dart_string("Final: ") + result.toString());<br>``` |

### Future 错误处理

| Dart 语法 | C++ 转换 |
|-----------|---------|
| ```dart<br>Future<int> errorFuture = Future.delayed(<br>  Duration(milliseconds: 10),<br>  () => throw Exception('Test error')<br>);<br><br>errorFuture.catchError((e) {<br>  print('Caught: $e');<br>  return -1;  // 恢复值<br>});<br>``` | ```cpp<br>ObjectPtr<Future<Int>> errorFuture = Future<Int>::delayed(<br>  Duration::milliseconds(10),<br>  []() -> Int {<br>    throw std::runtime_error("Test error");<br>    return dart_int(0);<br>  }<br>);<br><br>ObjectPtr<Future<Int>> recovered = errorFuture->catchError(<br>  [](const std::exception& e) {<br>    dart_print(dart_string("Caught: ") + dart_string(e.what()));<br>    return dart_int(-1);  // 恢复值<br>  }<br>);<br>``` |

### Completer（手动控制 Future）

| Dart 语法 | C++ 转换 |
|-----------|---------|
| ```dart<br>Completer<String> completer = Completer<String>();<br><br>// 获取 Future<br>Future<String> future = completer.future;<br><br>// 完成 Future<br>completer.complete('Success');<br><br>// 或者以错误完成<br>completer.completeError(Exception('Failed'));<br><br>// 检查状态<br>bool isDone = completer.isCompleted;<br>``` | ```cpp<br>ObjectPtr<Completer<String>> completer = Completer<String>::create();<br><br>// 获取 Future<br>ObjectPtr<Future<String>> future = completer->getFuture();<br><br>// 完成 Future<br>completer->complete(dart_string("Success"));<br><br>// 或者以错误完成<br>completer->completeError(std::runtime_error("Failed"));<br><br>// 检查状态<br>Bool isDone = completer->isCompleted();<br>``` |

### Future.wait（并发等待多个）

| Dart 语法 | C++ 转换 |
|-----------|---------|
| ```dart<br>List<Future<int>> futures = [<br>  Future.delayed(Duration(seconds: 1), () => 1),<br>  Future.delayed(Duration(seconds: 2), () => 2),<br>  Future.delayed(Duration(seconds: 1), () => 3),<br>];<br><br>List<int> results = await Future.wait(futures);<br>print('Results: $results');<br>``` | ```cpp<br>ObjectPtr<List<ObjectPtr<Future<Int>>>> futures = List<ObjectPtr<Future<Int>>>::create();<br><br>futures->add(Future<Int>::delayed(<br>  Duration::seconds(1),<br>  []() { return dart_int(1); }<br>));<br>futures->add(Future<Int>::delayed(<br>  Duration::seconds(2),<br>  []() { return dart_int(2); }<br>));<br>futures->add(Future<Int>::delayed(<br>  Duration::seconds(1),<br>  []() { return dart_int(3); }<br>));<br><br>ObjectPtr<List<Int>> results = Future<Int>::wait(futures);<br>dart_print(dart_string("Results: ") + results->size().toString());<br>``` |

### Future.any（等待任意一个完成）

| Dart 语法 | C++ 转换 |
|-----------|---------|
| ```dart<br>List<Future<String>> futures = [<br>  Future.delayed(Duration(milliseconds: 100), () => 'First'),<br>  Future.delayed(Duration(milliseconds: 50), () => 'Second'),<br>  Future.delayed(Duration(milliseconds: 150), () => 'Third'),<br>];<br><br>String first = await Future.any(futures);<br>print('First completed: $first');  // 'Second'<br>``` | ```cpp<br>ObjectPtr<List<ObjectPtr<Future<String>>>> futures = <br>  List<ObjectPtr<Future<String>>>::create();<br><br>futures->add(Future<String>::delayed(<br>  Duration::milliseconds(100),<br>  []() { return dart_string("First"); }<br>));<br>futures->add(Future<String>::delayed(<br>  Duration::milliseconds(50),<br>  []() { return dart_string("Second"); }<br>));<br>futures->add(Future<String>::delayed(<br>  Duration::milliseconds(150),<br>  []() { return dart_string("Third"); }<br>));<br><br>String first = Future<String>::any(futures);<br>dart_print(dart_string("First completed: ") + first);<br>``` |

### Future 超时等待

| Dart 语法 | C++ 转换 |
|-----------|---------|
| ```dart<br>Future<String> slowFuture = Future.delayed(<br>  Duration(milliseconds: 200),<br>  () => 'Slow result'<br>);<br><br>try {<br>  String result = await slowFuture.timeout(<br>    Duration(milliseconds: 100)<br>  );<br>} catch (e) {<br>  print('Timeout!');<br>}<br>``` | ```cpp<br>ObjectPtr<Future<String>> slowFuture = Future<String>::delayed(<br>  Duration::milliseconds(200),<br>  []() { return dart_string("Slow result"); }<br>);<br><br>// 使用 waitFor 检查超时<br>Bool completed = slowFuture->waitFor(Duration::milliseconds(100));<br>if (!(completed == dart_bool(true))) {<br>  dart_print(dart_string("Timeout!"));<br>} else {<br>  String result = slowFuture->wait();<br>}<br>``` |

### 异步函数模拟

| Dart 语法 | C++ 转换 |
|-----------|---------|
| ```dart<br>Future<String> fetchUserData(int userId) async {<br>  // 模拟网络请求<br>  await Future.delayed(Duration(milliseconds: 500));<br>  return 'User data for $userId';<br>}<br><br>Future<void> processUser(int userId) async {<br>  print('Fetching user $userId...');<br>  String data = await fetchUserData(userId);<br>  print('Got: $data');<br>}<br>``` | ```cpp<br>ObjectPtr<Future<String>> fetchUserData(const Int& userId) {<br>  return Future<String>::delayed(<br>    Duration::milliseconds(500),<br>    [userId]() -> String {<br>      return dart_string("User data for ") + userId.toString();<br>    }<br>  );<br>}<br><br>void processUser(const Int& userId) {<br>  dart_print(dart_string("Fetching user ") + userId.toString() + dart_string("..."));<br>  <br>  fetchUserData(userId)->then<void>([](const String& data) {<br>    dart_print(dart_string("Got: ") + data);<br>  });<br>}<br>``` |

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

### 核心概念

1. **类型系统**：
   - 值类型：Int、Double、Bool、String（不需要 ObjectPtr）
   - 引用类型：所有自定义类、集合类型、Future、Completer、Duration（必须使用 ObjectPtr）

2. **常量包装函数**（非常重要！）：
   - **外部代码一律使用** `dart_int()`, `dart_double()`, `dart_bool()`, `dart_string()` 包装常量
   - **不使用** `Int()`, `Double()`, `Bool()`, `String()` 直接构造（仅core内部使用）
   - **不使用** `.getValue()`, `.value` 直接访问原值（仅core内部使用）
   - **所有运算** 均在封装类型中完成，通过运算符重载实现
   - 示例：
     ```cpp
     Int a = dart_int(10);
     Int b = dart_int(20);
     Int sum = a + b;  // 正确：运算符重载
     // int sum = a.getValue() + b.getValue();  // 错误：不使用getValue
     ```

3. **ObjectPtr 智能指针**（最重要！）：
   - 所有自定义类对象必须使用 `ObjectPtr<T>` 包裹
   - 创建对象：`ObjectPtr<MyClass>(new MyClass(args))`
   - 成员访问：使用 `->` 而非 `.`
   - 函数参数：`const ObjectPtr<T>&`
   - 函数返回值：`ObjectPtr<T>`
   - 多态容器：`ObjectPtr<List<ObjectPtr<BaseClass>>>`

4. **面向对象特性**：
   - 继承：标准 C++ 继承机制
   - 多态：虚函数和抽象类
   - 接口：纯虚类 + 多重继承
   - Mixin：通过多重继承实现
   - 复杂组合：Mixin + 接口 + 继承可以同时使用

4. **设计模式**：
   - 单例模式：静态实例 + 私有构造函数
   - 工厂模式：静态工厂方法返回 ObjectPtr

5. **异步编程**（完全实现）：
   - **Duration**：时间间隔类型，使用 ObjectPtr 包裹
     - 静态工厂：`Duration::milliseconds()`, `seconds()`, `minutes()`, `hours()`
     - 运算符：`+`, `-`, `*`, 比较运算符
     - 方法：`inMilliseconds()`, `inSeconds()`, `inMinutes()`, `inHours()`
   - **Future<T>**：异步操作结果，使用 ObjectPtr 包裹
     - 创建：`Future<T>::value()`, `Future<T>::delayed()`
     - 等待：`wait()`, `waitFor(Duration)`
     - 链式：`then<R>(callback)`, `catchError(handler)`
     - 静态：`Future<T>::wait(futures)`, `Future<T>::any(futures)`
   - **Completer<T>**：手动控制 Future 完成
     - 创建：`Completer<T>::create()`
     - 方法：`complete()`, `completeError()`, `getFuture()`, `isCompleted()`

6. **运算符重载**（全面支持）：
   - 算术运算符：`+`, `-`, `*`, `/`, `%`, `~/`
   - 比较运算符：`==`, `!=`, `<`, `<=`, `>`, `>=`
   - 逻辑运算符：`&&`, `||`, `!`
   - 复合赋值：`+=`, `-=`, `*=`, `/=`, `%=`
   - 自增自减：`++`, `--`（前置和后置）
   - 位运算符：`&`, `|`, `^`, `<<`, `>>`, `~`

7. **集合类型**：
   - List、Map、Set 使用 ObjectPtr 包裹
   - 泛型支持：`ObjectPtr<List<Int>>`
   - 创建：`List<T>::create()`, `Map<K,V>::create()`, `Set<T>::create()`

8. **内存管理**：
   - 通过 ObjectPtr 引用计数自动管理内存
   - 避免手动 delete
   - RAII 原则

### 关键转换规则

| 场景 | Dart | C++ |
|------|------|-----|
| 值类型变量 | `int x = 5;` | `Int x = dart_int(5);` |
| 浮点数 | `double y = 3.14;` | `Double y = dart_double(3.14);` |
| 布尔值 | `bool flag = true;` | `Bool flag = dart_bool(true);` |
| 字符串 | `String s = "text";` | `String s = dart_string("text");` |
| 自定义类对象 | `Person p = Person('Alice', 25);` | `ObjectPtr<Person> p = ObjectPtr<Person>(new Person(dart_string("Alice"), dart_int(25)));` |
| 成员访问 | `obj.field` | `obj->field` |
| 方法调用 | `obj.method()` | `obj->method()` |
| 空值检查 | `if (obj != null)` | `if (obj.get() != nullptr)` |
| 类型转换 | `obj as Type` | `dynamic_cast<Type*>(obj.get())` |
| 多态容器 | `List<Animal>` | `ObjectPtr<List<ObjectPtr<Animal>>>` |
| Future对象 | `Future<int> f = Future.value(42);` | `ObjectPtr<Future<Int>> f = Future<Int>::value(dart_int(42));` |
| Duration对象 | `Duration d = Duration(seconds: 1);` | `ObjectPtr<Duration> d = Duration::seconds(1);` |

### 最佳实践

1. **始终使用 `dart_int()`, `dart_double()`, `dart_bool()`, `dart_string()` 包装常量**
2. **不使用 `.getValue()` 或 `.value` 直接访问原值，所有运算通过运算符重载完成**
3. **始终使用 ObjectPtr 包裹自定义类对象、Future、Completer、Duration**
4. **值类型（Int、Double、Bool、String）不需要 ObjectPtr**
5. **函数参数传递 ObjectPtr 时使用 const 引用**
6. **使用 -> 访问 ObjectPtr 包裹对象的成员**
7. **多重继承时注意继承顺序和虚函数覆盖**
8. **异步操作使用 Future 和 Completer**
9. **遵循 RAII 原则，避免手动内存管理**
10. **Duration 运算需要解引用：`*d1 + *d2`**
11. **Future 链式调用需要指定返回类型：`then<Int>(...)`**
12. **使用 `dart_print()` 输出，不使用 `std::cout`（除非调试）**

通过这个对照表，开发者可以了解如何将 Dart 代码转换为对应的 C++ 代码，实现跨语言的代码转换和互操作。