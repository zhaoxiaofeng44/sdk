# Dart 到 C++ 类型映射表

## 📋 概述

本文档详细列出了 Dart2CPP 转换器中 Dart 类型到 C++ 类型的完整映射关系，包括基础类型、集合类型、函数类型和自定义类型。

## 🔢 基础类型映射

### 数值类型

| Dart 类型 | C++ 类型 | 构造宏 | 说明 |
|----------|---------|--------|------|
| `int` | `Int` | `dart_int(value)` | 32位有符号整数 |
| `double` | `Double` | `dart_double(value)` | 64位浮点数 |
| `num` | `Any` | - | 数值基类，运行时确定具体类型 |

**示例**:
```dart
// Dart
int age = 25;
double height = 175.5;
num weight = 70;
```

```cpp
// C++
auto age = dart_int(25);
auto height = dart_double(175.5);
Any weight = dart_int(70);  // 或 dart_double(70.0)
```

### 布尔类型

| Dart 类型 | C++ 类型 | 构造宏 | 说明 |
|----------|---------|--------|------|
| `bool` | `Bool` | `dart_bool(value)` | 布尔值，支持隐式转换 |

**示例**:
```dart
// Dart
bool isActive = true;
bool isComplete = false;
```

```cpp
// C++
auto isActive = dart_bool(true);
auto isComplete = dart_bool(false);
```

### 字符串类型

| Dart 类型 | C++ 类型 | 构造宏 | 说明 |
|----------|---------|--------|------|
| `String` | `String` | `dart_string(value)` | 不可变字符串，带字符串池优化 |

**示例**:
```dart
// Dart
String name = "Alice";
String empty = "";
String multiline = '''
  Hello
  World
''';
```

```cpp
// C++
auto name = dart_string("Alice");
auto empty = dart_string("");
auto multiline = dart_string("\n  Hello\n  World\n");
```

### 空值类型

| Dart 类型 | C++ 类型 | 构造宏 | 说明 |
|----------|---------|--------|------|
| `null` | `Null` | - | 空值常量 |
| `void` | `Nullable` | `Void` | 无返回值类型 |
| `dynamic` | `Any` | - | 动态类型，运行时确定 |
| `Object` | `Object` | - | 所有对象的基类 |

**示例**:
```dart
// Dart
void function() { }
dynamic value = 42;
Object obj = "hello";
```

```cpp
// C++
Nullable function() { return Void; }
Any value = dart_int(42);
Object obj = dart_string("hello");
```

## 📦 集合类型映射

### List 类型

| Dart 类型 | C++ 类型 | 创建方法 | 说明 |
|----------|---------|---------|------|
| `List<T>` | `ObjectPtr<List<T>>` | `List<T>::create()` | 动态数组 |
| `List<int>` | `ObjectPtr<List<Int>>` | `dart_list_int()` | 整数列表 |
| `List<String>` | `ObjectPtr<List<String>>` | `dart_list_string()` | 字符串列表 |
| `List<double>` | `ObjectPtr<List<Double>>` | `dart_list_double()` | 浮点数列表 |

**示例**:
```dart
// Dart
List<int> numbers = [1, 2, 3];
List<String> names = ["Alice", "Bob"];
List<dynamic> mixed = [1, "hello", true];
```

```cpp
// C++
auto numbers = dart_literal(dart_int(1), dart_int(2), dart_int(3));
auto names = dart_literal(dart_string("Alice"), dart_string("Bob"));
auto mixed = List<Any>::create();
mixed->add(dart_int(1));
mixed->add(dart_string("hello"));
mixed->add(dart_bool(true));
```

### Set 类型

| Dart 类型 | C++ 类型 | 创建方法 | 说明 |
|----------|---------|---------|------|
| `Set<T>` | `ObjectPtr<Set<T>>` | `Set<T>::create()` | 无序集合 |
| `Set<int>` | `ObjectPtr<Set<Int>>` | `dart_set_int()` | 整数集合 |
| `Set<String>` | `ObjectPtr<Set<String>>` | `dart_set_string()` | 字符串集合 |

**示例**:
```dart
// Dart
Set<int> uniqueNumbers = {1, 2, 3};
Set<String> tags = {"dart", "cpp", "compiler"};
```

```cpp
// C++
auto uniqueNumbers = dart_set_int();
uniqueNumbers->add(dart_int(1));
uniqueNumbers->add(dart_int(2));
uniqueNumbers->add(dart_int(3));

auto tags = dart_set_string();
tags->add(dart_string("dart"));
tags->add(dart_string("cpp"));
tags->add(dart_string("compiler"));
```

### Map 类型

| Dart 类型 | C++ 类型 | 创建方法 | 说明 |
|----------|---------|---------|------|
| `Map<K,V>` | `ObjectPtr<Map<K,V>>` | `Map<K,V>::create()` | 键值对映射 |
| `Map<String,int>` | `ObjectPtr<Map<String,Int>>` | `dart_map_string_int()` | 字符串到整数映射 |
| `Map<int,String>` | `ObjectPtr<Map<Int,String>>` | `dart_map_int_string()` | 整数到字符串映射 |

**示例**:
```dart
// Dart
Map<String, int> scores = {"Alice": 95, "Bob": 87};
Map<int, String> names = {1: "First", 2: "Second"};
```

```cpp
// C++
auto scores = dart_map_string_int();
scores->put(dart_string("Alice"), dart_int(95));
scores->put(dart_string("Bob"), dart_int(87));

auto names = dart_map_int_string();
names->put(dart_int(1), dart_string("First"));
names->put(dart_int(2), dart_string("Second"));
```

## 🔧 函数类型映射

### 基本函数

| Dart 类型 | C++ 类型 | 说明 |
|----------|---------|------|
| `void function()` | `Nullable function()` | 无返回值函数 |
| `int function()` | `Int function()` | 返回整数的函数 |
| `T function(T)` | `T function(T)` | 泛型函数 |

**示例**:
```dart
// Dart
void greet() {
  print("Hello!");
}

int add(int a, int b) {
  return a + b;
}
```

```cpp
// C++
Nullable greet() {
  dart_print(dart_string("Hello!"));
  return Void;
}

Int add(Int a, Int b) {
  return (a + b);
}
```

### 函数参数

| Dart 参数类型 | C++ 参数类型 | 说明 |
|--------------|-------------|------|
| `required T param` | `T param` | 必需参数 |
| `T? param` | `T param = Null` | 可选参数，默认为 null |
| `[T? param]` | `T param = Null` | 位置可选参数 |
| `{T? param}` | `T param = Null` | 命名可选参数 |
| `{required T param}` | `T param` | 必需命名参数 |

**示例**:
```dart
// Dart
void greet(String name, [String? title]) {
  // ...
}

void configure({required String host, int? port}) {
  // ...
}
```

```cpp
// C++
Nullable greet(String name, String title = Null) {
  // ...
  return Void;
}

Nullable configure(String host, Int port = Null) {
  // ...
  return Void;
}
```

### 高阶函数

| Dart 类型 | C++ 类型 | 说明 |
|----------|---------|------|
| `Function` | `std::function<Any()>` | 通用函数类型 |
| `T Function(U)` | `std::function<T(U)>` | 特定签名函数 |
| `void Function()` | `std::function<void()>` | 无返回值函数 |

**示例**:
```dart
// Dart
void forEach(List<int> list, void Function(int) action) {
  for (int item in list) {
    action(item);
  }
}
```

```cpp
// C++
Nullable forEach(ObjectPtr<List<Int>> list, std::function<void(Int)> action) {
  auto iterator = list->iterator();
  for (; iterator->moveNext(); ) {
    auto item = iterator->current();
    action(item);
  }
  return Void;
}
```

## 🏗️ 类和对象映射

### 基本类定义

| Dart 概念 | C++ 映射 | 说明 |
|----------|---------|------|
| `class ClassName` | `class ClassName : public Any` | 继承自 Any 基类 |
| `abstract class` | `class ClassName : public Any` | 抽象类，包含纯虚函数 |
| `mixin` | `class MixinName` | 使用多重继承实现 |
| `interface` | `class InterfaceName` | 纯虚函数接口 |

**示例**:
```dart
// Dart
class Person {
  String name;
  int age;
  
  Person(this.name, this.age);
  
  void introduce() {
    print('I am $name, $age years old.');
  }
}
```

```cpp
// C++
class Person : public Any {
public:
  String name;
  Int age;
  
  Person(String name, Int age) : name(name), age(age) {
    type_id = 6; // UserData
  }
  
  Nullable introduce() {
    dart_print(dart_concat(dart_string("I am "), name, 
                          dart_string(", "), age, dart_string(" years old.")));
    return Void;
  }
};
```

### 构造函数映射

| Dart 构造函数 | C++ 映射 | 说明 |
|--------------|---------|------|
| `ClassName()` | `ClassName()` | 默认构造函数 |
| `ClassName(params)` | `ClassName(params)` | 参数化构造函数 |
| `ClassName.named(params)` | `static ObjectPtr<ClassName> named(params)` | 命名构造函数转为静态工厂方法 |
| `const ClassName(params)` | `ClassName(params)` | 常量构造函数 |

**示例**:
```dart
// Dart
class Point {
  double x, y;
  
  Point(this.x, this.y);
  Point.origin() : x = 0, y = 0;
  Point.fromJson(Map<String, dynamic> json) 
    : x = json['x'], y = json['y'];
}
```

```cpp
// C++
class Point : public Any {
public:
  Double x, y;
  
  Point(Double x, Double y) : x(x), y(y) {
    type_id = 6;
  }
  
  static ObjectPtr<Point> origin() {
    return ObjectPtr<Point>(new Point(dart_double(0), dart_double(0)));
  }
  
  static ObjectPtr<Point> fromJson(ObjectPtr<Map<String, Any>> json) {
    return ObjectPtr<Point>(new Point(
      json->get(dart_string("x")).toDouble(),
      json->get(dart_string("y")).toDouble()
    ));
  }
};
```

### 继承和多态

| Dart 概念 | C++ 映射 | 说明 |
|----------|---------|------|
| `extends` | `: public BaseClass` | 单继承 |
| `implements` | `: public virtual Interface` | 接口实现 |
| `with` | `: public virtual Mixin` | Mixin 混入 |
| `@override` | `virtual ... override` | 虚函数重写 |

**示例**:
```dart
// Dart
abstract class Animal {
  void makeSound();
}

mixin Flyable {
  void fly() {
    print('Flying...');
  }
}

class Bird extends Animal with Flyable {
  @override
  void makeSound() {
    print('Chirp!');
  }
}
```

```cpp
// C++
class Animal : public Any {
public:
  virtual ~Animal() {}
  virtual Nullable makeSound() = 0;
};

class Flyable {
public:
  virtual ~Flyable() {}
  virtual Nullable fly() {
    dart_print(dart_string("Flying..."));
    return Void;
  }
};

class Bird : public virtual Animal, public virtual Flyable {
public:
  virtual Nullable makeSound() override {
    dart_print(dart_string("Chirp!"));
    return Void;
  }
};
```

## 🔄 泛型类型映射

### 泛型类

| Dart 泛型 | C++ 映射 | 说明 |
|----------|---------|------|
| `class Container<T>` | `template<typename T> class Container` | 模板类 |
| `T` | `T` | 类型参数 |
| `T extends BaseClass` | `typename T` (需要概念约束) | 类型约束 |

**示例**:
```dart
// Dart
class Container<T> {
  T value;
  
  Container(this.value);
  
  T getValue() => value;
  void setValue(T newValue) => value = newValue;
}
```

```cpp
// C++
template<typename T>
class Container : public Any {
public:
  T value;
  
  Container(T value) : value(value) {
    type_id = 6;
  }
  
  T getValue() {
    return value;
  }
  
  Nullable setValue(T newValue) {
    value = newValue;
    return Void;
  }
};
```

### 泛型函数

| Dart 泛型函数 | C++ 映射 | 说明 |
|--------------|---------|------|
| `T identity<T>(T value)` | `template<typename T> T identity(T value)` | 模板函数 |
| `List<T> create<T>()` | `template<typename T> ObjectPtr<List<T>> create()` | 泛型工厂函数 |

**示例**:
```dart
// Dart
T identity<T>(T value) {
  return value;
}

List<T> createList<T>() {
  return <T>[];
}
```

```cpp
// C++
template<typename T>
T identity(T value) {
  return value;
}

template<typename T>
ObjectPtr<List<T>> createList() {
  return List<T>::create();
}
```

## 🎯 特殊类型映射

### 可空类型

| Dart 可空类型 | C++ 映射 | 说明 |
|--------------|---------|------|
| `int?` | `Int` (默认为 null) | 可空整数 |
| `String?` | `String` (默认为 null) | 可空字符串 |
| `List<T>?` | `ObjectPtr<List<T>>` | 可空列表 |

**示例**:
```dart
// Dart
int? nullableInt;
String? nullableString = null;
List<int>? nullableList;
```

```cpp
// C++
Int nullableInt;  // 默认为 null
String nullableString = Null;
ObjectPtr<List<Int>> nullableList;  // 默认为 nullptr
```

### 联合类型 (Union Types)

Dart 不直接支持联合类型，但可以使用 `dynamic` 或继承层次：

| Dart 模式 | C++ 映射 | 说明 |
|----------|---------|------|
| `dynamic` | `Any` | 运行时类型检查 |
| `Object` | `Object` | 所有对象基类 |
| 继承层次 | 继承层次 | 使用多态 |

### 函数类型别名

| Dart 类型别名 | C++ 映射 | 说明 |
|--------------|---------|------|
| `typedef Callback = void Function()` | `using Callback = std::function<void()>` | 类型别名 |
| `typedef Predicate<T> = bool Function(T)` | `template<typename T> using Predicate = std::function<bool(T)>` | 泛型类型别名 |

**示例**:
```dart
// Dart
typedef IntCallback = void Function(int);
typedef Predicate<T> = bool Function(T);
```

```cpp
// C++
using IntCallback = std::function<void(Int)>;
template<typename T>
using Predicate = std::function<Bool(T)>;
```

## 📊 性能考虑

### 值类型 vs 引用类型

| 类型类别 | Dart | C++ | 内存分配 | 性能特征 |
|----------|------|-----|----------|----------|
| 基础类型 | 值类型 | 值类型 | 栈分配 | 高性能 |
| 字符串 | 引用类型 | 值类型(池化) | 池分配 | 优化的内存使用 |
| 集合类型 | 引用类型 | 智能指针 | 堆分配 | 自动内存管理 |
| 自定义类 | 引用类型 | 智能指针 | 堆分配 | 自动内存管理 |

### 类型转换开销

| 转换类型 | 开销 | 说明 |
|----------|------|------|
| 基础类型之间 | 低 | 直接转换 |
| 装箱/拆箱 | 中等 | 值类型与对象类型转换 |
| 动态类型检查 | 高 | 运行时类型识别 |
| 字符串创建 | 低 | 字符串池优化 |

## 🔍 调试和诊断

### 类型信息获取

```cpp
// 获取对象类型信息
template<typename T>
String getTypeName(const T& obj) {
  return dart_string(typeid(T).name());
}

// 检查类型ID
Bool isInt(const Any& obj) {
  return obj.type_id == 1;
}

Bool isString(const Any& obj) {
  return obj.type_id == 4;
}
```

### 运行时类型检查

```cpp
// 安全的类型转换
template<typename T>
ObjectPtr<T> safeCast(const Any& obj) {
  if (auto* ptr = dynamic_cast<const T*>(&obj)) {
    return ObjectPtr<T>(const_cast<T*>(ptr));
  }
  return ObjectPtr<T>();
}
```

## 📝 最佳实践

### 1. 类型选择
- 优先使用值类型（Int, Double, Bool, String）
- 集合类型使用智能指针
- 避免不必要的类型转换

### 2. 内存管理
- 使用 `ObjectPtr<T>` 管理复杂对象
- 避免循环引用
- 及时释放不需要的引用

### 3. 性能优化
- 使用字符串池减少内存分配
- 避免频繁的动态类型检查
- 合理使用模板特化

### 4. 错误处理
- 检查空指针访问
- 使用异常处理机制
- 提供清晰的错误信息

这个类型映射表为 Dart2CPP 的使用者提供了完整的类型转换参考，确保能够正确地在 Dart 和 C++ 之间进行类型映射和转换。
