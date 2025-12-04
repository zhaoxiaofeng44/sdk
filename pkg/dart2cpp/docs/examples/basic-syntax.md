# 基础语法转换示例

## 📋 概述

本文档通过具体的代码示例，展示 Dart2CPP 如何将 Dart 的基础语法转换为等价的 C++ 代码。每个示例都包含原始 Dart 代码、转换后的 C++ 代码，以及详细的转换说明。

## 🔢 基础数据类型

### 整数类型

**Dart 代码**:
```dart
void main() {
  int age = 25;
  int hexValue = 0xFF;
  int negativeNumber = -42;
  int zero = 0;
  
  print('Age: $age');
  print('Hex: $hexValue');
  print('Negative: $negativeNumber');
  print('Zero: $zero');
}
```

**转换后的 C++ 代码**:
```cpp
#include "dart2cpp.h"

Nullable main() {
  auto age = dart_int(25);
  auto hexValue = dart_int(255);  // 0xFF = 255
  auto negativeNumber = dart_int(-42);
  auto zero = dart_int(0);
  
  dart_print(dart_concat(dart_string("Age: "), age));
  dart_print(dart_concat(dart_string("Hex: "), hexValue));
  dart_print(dart_concat(dart_string("Negative: "), negativeNumber));
  dart_print(dart_concat(dart_string("Zero: "), zero));
  
  return Void;
}
```

**转换说明**:
- `int` → `Int` (使用 `dart_int()` 宏)
- 十六进制字面量自动转换为十进制
- 字符串插值转换为 `dart_concat()` 调用
- `print()` 转换为 `dart_print()`

### 浮点数类型

**Dart 代码**:
```dart
void main() {
  double pi = 3.14159;
  double scientific = 1.23e-4;
  double negative = -2.5;
  
  print('Pi: $pi');
  print('Scientific: $scientific');
  print('Negative: $negative');
}
```

**转换后的 C++ 代码**:
```cpp
#include "dart2cpp.h"

Nullable main() {
  auto pi = dart_double(3.14159);
  auto scientific = dart_double(0.000123);
  auto negative = dart_double(-2.5);
  
  dart_print(dart_concat(dart_string("Pi: "), pi));
  dart_print(dart_concat(dart_string("Scientific: "), scientific));
  dart_print(dart_concat(dart_string("Negative: "), negative));
  
  return Void;
}
```

### 布尔类型

**Dart 代码**:
```dart
void main() {
  bool isTrue = true;
  bool isFalse = false;
  bool computed = 5 > 3;
  
  print('True: $isTrue');
  print('False: $isFalse');
  print('Computed: $computed');
}
```

**转换后的 C++ 代码**:
```cpp
#include "dart2cpp.h"

Nullable main() {
  auto isTrue = dart_bool(true);
  auto isFalse = dart_bool(false);
  auto computed = (dart_int(5) > dart_int(3));
  
  dart_print(dart_concat(dart_string("True: "), isTrue));
  dart_print(dart_concat(dart_string("False: "), isFalse));
  dart_print(dart_concat(dart_string("Computed: "), computed));
  
  return Void;
}
```

### 字符串类型

**Dart 代码**:
```dart
void main() {
  String name = "Alice";
  String greeting = 'Hello';
  String empty = "";
  String multiline = '''
    This is a
    multi-line string
  ''';
  
  // 字符串操作
  String combined = greeting + ", " + name + "!";
  print(combined);
  print('Length: ${name.length}');
  print('Upper: ${name.toUpperCase()}');
}
```

**转换后的 C++ 代码**:
```cpp
#include "dart2cpp.h"

Nullable main() {
  auto name = dart_string("Alice");
  auto greeting = dart_string("Hello");
  auto empty = dart_string("");
  auto multiline = dart_string("\n    This is a\n    multi-line string\n  ");
  
  auto combined = ((greeting + dart_string(", ")) + name) + dart_string("!");
  dart_print(combined);
  dart_print(dart_concat(dart_string("Length: "), name.length()));
  dart_print(dart_concat(dart_string("Upper: "), name.toUpperCase()));
  
  return Void;
}
```

## 🔧 变量声明

### var、final、const 声明

**Dart 代码**:
```dart
void main() {
  // var 声明 (类型推断)
  var autoInt = 42;
  var autoString = "Hello";
  var autoDouble = 3.14;
  
  // final 声明 (运行时常量)
  final finalValue = "Cannot change";
  final int typedFinal = 100;
  
  // const 声明 (编译时常量)
  const constValue = "Compile time";
  const double pi = 3.14159;
  
  print('Auto int: $autoInt');
  print('Final: $finalValue');
  print('Const: $constValue');
}
```

**转换后的 C++ 代码**:
```cpp
#include "dart2cpp.h"

Nullable main() {
  // var 声明转换为 auto
  auto autoInt = dart_int(42);
  auto autoString = dart_string("Hello");
  auto autoDouble = dart_double(3.14);
  
  // final 声明转换为 const auto
  const auto finalValue = dart_string("Cannot change");
  const auto typedFinal = dart_int(100);
  
  // const 声明转换为 const auto
  const auto constValue = dart_string("Compile time");
  const auto pi = dart_double(3.14159);
  
  dart_print(dart_concat(dart_string("Auto int: "), autoInt));
  dart_print(dart_concat(dart_string("Final: "), finalValue));
  dart_print(dart_concat(dart_string("Const: "), constValue));
  
  return Void;
}
```

### 可空类型

**Dart 代码**:
```dart
void main() {
  int? nullableInt;
  String? nullableString = null;
  double? nullableDouble;
  
  // 空值合并操作符
  String name = nullableString ?? "Anonymous";
  
  // 空值检查
  if (nullableInt != null) {
    print('Value: $nullableInt');
  } else {
    print('Value is null');
  }
  
  print('Name: $name');
}
```

**转换后的 C++ 代码**:
```cpp
#include "dart2cpp.h"

Nullable main() {
  Int nullableInt;  // 默认为 null
  String nullableString = Null;
  Double nullableDouble;  // 默认为 null
  
  // 空值合并操作符
  auto name = dart_null_coalesce(nullableString, dart_string("Anonymous"));
  
  // 空值检查
  if (!dart_is_null(nullableInt)) {
    dart_print(dart_concat(dart_string("Value: "), nullableInt));
  } else {
    dart_print(dart_string("Value is null"));
  }
  
  dart_print(dart_concat(dart_string("Name: "), name));
  
  return Void;
}
```

## ➕ 运算符

### 算术运算符

**Dart 代码**:
```dart
void main() {
  int a = 10, b = 3;
  
  print('Addition: ${a + b}');
  print('Subtraction: ${a - b}');
  print('Multiplication: ${a * b}');
  print('Division: ${a / b}');
  print('Integer Division: ${a ~/ b}');
  print('Modulo: ${a % b}');
  print('Negation: ${-a}');
}
```

**转换后的 C++ 代码**:
```cpp
#include "dart2cpp.h"

Nullable main() {
  auto a = dart_int(10);
  auto b = dart_int(3);
  
  dart_print(dart_concat(dart_string("Addition: "), (a + b)));
  dart_print(dart_concat(dart_string("Subtraction: "), (a - b)));
  dart_print(dart_concat(dart_string("Multiplication: "), (a * b)));
  dart_print(dart_concat(dart_string("Division: "), (a / b)));
  dart_print(dart_concat(dart_string("Integer Division: "), a.truncatingDivision(b)));
  dart_print(dart_concat(dart_string("Modulo: "), (a % b)));
  dart_print(dart_concat(dart_string("Negation: "), a.operator_negate()));
  
  return Void;
}
```

### 比较运算符

**Dart 代码**:
```dart
void main() {
  int x = 5, y = 3;
  
  print('Equal: ${x == y}');
  print('Not equal: ${x != y}');
  print('Greater: ${x > y}');
  print('Less: ${x < y}');
  print('Greater or equal: ${x >= y}');
  print('Less or equal: ${x <= y}');
}
```

**转换后的 C++ 代码**:
```cpp
#include "dart2cpp.h"

Nullable main() {
  auto x = dart_int(5);
  auto y = dart_int(3);
  
  dart_print(dart_concat(dart_string("Equal: "), (x == y)));
  dart_print(dart_concat(dart_string("Not equal: "), !(x == y)));
  dart_print(dart_concat(dart_string("Greater: "), (x > y)));
  dart_print(dart_concat(dart_string("Less: "), (x < y)));
  dart_print(dart_concat(dart_string("Greater or equal: "), (x >= y)));
  dart_print(dart_concat(dart_string("Less or equal: "), (x <= y)));
  
  return Void;
}
```

### 逻辑运算符

**Dart 代码**:
```dart
void main() {
  bool a = true, b = false;
  
  print('AND: ${a && b}');
  print('OR: ${a || b}');
  print('NOT a: ${!a}');
  print('NOT b: ${!b}');
  
  // 短路求值
  bool result = a || (5 / 0 > 1);  // 不会执行除法
  print('Short circuit: $result');
}
```

**转换后的 C++ 代码**:
```cpp
#include "dart2cpp.h"

Nullable main() {
  auto a = dart_bool(true);
  auto b = dart_bool(false);
  
  dart_print(dart_concat(dart_string("AND: "), (a && b)));
  dart_print(dart_concat(dart_string("OR: "), (a || b)));
  dart_print(dart_concat(dart_string("NOT a: "), !(a)));
  dart_print(dart_concat(dart_string("NOT b: "), !(b)));
  
  // 短路求值保持相同语义
  auto result = a || ((dart_int(5) / dart_int(0)) > dart_int(1));
  dart_print(dart_concat(dart_string("Short circuit: "), result));
  
  return Void;
}
```

## 🔄 控制流

### if-else 语句

**Dart 代码**:
```dart
void main() {
  int score = 85;
  
  if (score >= 90) {
    print('Grade: A');
  } else if (score >= 80) {
    print('Grade: B');
  } else if (score >= 70) {
    print('Grade: C');
  } else {
    print('Grade: F');
  }
  
  // 三元运算符
  String result = score >= 60 ? 'Pass' : 'Fail';
  print('Result: $result');
}
```

**转换后的 C++ 代码**:
```cpp
#include "dart2cpp.h"

Nullable main() {
  auto score = dart_int(85);
  
  if ((score >= dart_int(90))) {
    dart_print(dart_string("Grade: A"));
  } else {
    if ((score >= dart_int(80))) {
      dart_print(dart_string("Grade: B"));
    } else {
      if ((score >= dart_int(70))) {
        dart_print(dart_string("Grade: C"));
      } else {
        dart_print(dart_string("Grade: F"));
      }
    }
  }
  
  // 三元运算符
  auto result = (score >= dart_int(60)) ? dart_string("Pass") : dart_string("Fail");
  dart_print(dart_concat(dart_string("Result: "), result));
  
  return Void;
}
```

### switch-case 语句

**Dart 代码**:
```dart
void main() {
  String grade = 'B';
  
  switch (grade) {
    case 'A':
      print('Excellent!');
      break;
    case 'B':
      print('Good!');
      break;
    case 'C':
      print('Average');
      break;
    default:
      print('Unknown grade');
  }
}
```

**转换后的 C++ 代码**:
```cpp
#include "dart2cpp.h"

Nullable main() {
  auto grade = dart_string("B");
  
  // switch 转换为 if-else if 链
  if (grade == dart_string("A")) {
    dart_print(dart_string("Excellent!"));
  } else if (grade == dart_string("B")) {
    dart_print(dart_string("Good!"));
  } else if (grade == dart_string("C")) {
    dart_print(dart_string("Average"));
  } else {
    dart_print(dart_string("Unknown grade"));
  }
  
  return Void;
}
```

### for 循环

**Dart 代码**:
```dart
void main() {
  // 传统 for 循环
  for (int i = 0; i < 5; i++) {
    print('Index: $i');
  }
  
  // for-in 循环
  List<String> fruits = ['apple', 'banana', 'orange'];
  for (String fruit in fruits) {
    print('Fruit: $fruit');
  }
  
  // 带 break 和 continue
  for (int i = 0; i < 10; i++) {
    if (i == 2) continue;
    if (i == 7) break;
    print('Number: $i');
  }
}
```

**转换后的 C++ 代码**:
```cpp
#include "dart2cpp.h"

Nullable main() {
  // 传统 for 循环
  for (auto i = dart_int(0); (i < dart_int(5)); i = (i + dart_int(1))) {
    dart_print(dart_concat(dart_string("Index: "), i));
  }
  
  // for-in 循环转换为迭代器
  auto fruits = dart_literal(dart_string("apple"), dart_string("banana"), dart_string("orange"));
  auto iterator = fruits->iterator();
  for (; iterator->moveNext(); ) {
    auto fruit = iterator->current();
    dart_print(dart_concat(dart_string("Fruit: "), fruit));
  }
  
  // 带 break 和 continue
  for (auto i = dart_int(0); (i < dart_int(10)); i = (i + dart_int(1))) {
    if ((i == dart_int(2))) continue;
    if ((i == dart_int(7))) break;
    dart_print(dart_concat(dart_string("Number: "), i));
  }
  
  return Void;
}
```

### while 和 do-while 循环

**Dart 代码**:
```dart
void main() {
  // while 循环
  int count = 0;
  while (count < 3) {
    print('Count: $count');
    count++;
  }
  
  // do-while 循环
  int num = 0;
  do {
    print('Number: $num');
    num++;
  } while (num < 3);
}
```

**转换后的 C++ 代码**:
```cpp
#include "dart2cpp.h"

Nullable main() {
  // while 循环
  auto count = dart_int(0);
  while ((count < dart_int(3))) {
    dart_print(dart_concat(dart_string("Count: "), count));
    count = (count + dart_int(1));
  }
  
  // do-while 循环
  auto num = dart_int(0);
  do {
    dart_print(dart_concat(dart_string("Number: "), num));
    num = (num + dart_int(1));
  } while ((num < dart_int(3)));
  
  return Void;
}
```

## 📝 函数定义

### 基本函数

**Dart 代码**:
```dart
// 无返回值函数
void greet(String name) {
  print('Hello, $name!');
}

// 有返回值函数
int add(int a, int b) {
  return a + b;
}

// 箭头函数
int multiply(int a, int b) => a * b;

void main() {
  greet('Alice');
  
  int sum = add(5, 3);
  print('Sum: $sum');
  
  int product = multiply(4, 6);
  print('Product: $product');
}
```

**转换后的 C++ 代码**:
```cpp
#include "dart2cpp.h"

// 无返回值函数
Nullable greet(String name) {
  dart_print(dart_concat(dart_string("Hello, "), name, dart_string("!")));
  return Void;
}

// 有返回值函数
Int add(Int a, Int b) {
  return (a + b);
}

// 箭头函数转换为普通函数
Int multiply(Int a, Int b) {
  return (a * b);
}

Nullable main() {
  greet(dart_string("Alice"));
  
  auto sum = add(dart_int(5), dart_int(3));
  dart_print(dart_concat(dart_string("Sum: "), sum));
  
  auto product = multiply(dart_int(4), dart_int(6));
  dart_print(dart_concat(dart_string("Product: "), product));
  
  return Void;
}
```

### 可选参数

**Dart 代码**:
```dart
// 位置可选参数
void greet(String name, [String? title]) {
  if (title != null) {
    print('Hello, $title $name!');
  } else {
    print('Hello, $name!');
  }
}

// 命名可选参数
void createUser({required String name, int? age, String? email}) {
  print('User: $name');
  if (age != null) print('Age: $age');
  if (email != null) print('Email: $email');
}

void main() {
  greet('Alice');
  greet('Bob', 'Mr.');
  
  createUser(name: 'Charlie');
  createUser(name: 'David', age: 30);
  createUser(name: 'Eve', age: 25, email: 'eve@example.com');
}
```

**转换后的 C++ 代码**:
```cpp
#include "dart2cpp.h"

// 位置可选参数转换为默认参数
Nullable greet(String name, String title = Null) {
  if (!dart_is_null(title)) {
    dart_print(dart_concat(dart_string("Hello, "), title, dart_string(" "), name, dart_string("!")));
  } else {
    dart_print(dart_concat(dart_string("Hello, "), name, dart_string("!")));
  }
  return Void;
}

// 命名可选参数转换为默认参数
Nullable createUser(String name, Int age = Null, String email = Null) {
  dart_print(dart_concat(dart_string("User: "), name));
  if (!dart_is_null(age)) {
    dart_print(dart_concat(dart_string("Age: "), age));
  }
  if (!dart_is_null(email)) {
    dart_print(dart_concat(dart_string("Email: "), email));
  }
  return Void;
}

Nullable main() {
  greet(dart_string("Alice"));
  greet(dart_string("Bob"), dart_string("Mr."));
  
  createUser(dart_string("Charlie"));
  createUser(dart_string("David"), dart_int(30));
  createUser(dart_string("Eve"), dart_int(25), dart_string("eve@example.com"));
  
  return Void;
}
```

## 📦 集合操作

### List 操作

**Dart 代码**:
```dart
void main() {
  // 创建和初始化
  List<int> numbers = [1, 2, 3, 4, 5];
  List<String> names = ['Alice', 'Bob', 'Charlie'];
  
  // 基本操作
  numbers.add(6);
  print('Numbers: $numbers');
  print('Length: ${numbers.length}');
  print('First: ${numbers.first}');
  print('Last: ${numbers.last}');
  
  // 高阶函数
  List<int> doubled = numbers.map((n) => n * 2).toList();
  List<int> evens = numbers.where((n) => n % 2 == 0).toList();
  
  print('Doubled: $doubled');
  print('Evens: $evens');
}
```

**转换后的 C++ 代码**:
```cpp
#include "dart2cpp.h"

Nullable main() {
  // 创建和初始化
  auto numbers = dart_literal(dart_int(1), dart_int(2), dart_int(3), dart_int(4), dart_int(5));
  auto names = dart_literal(dart_string("Alice"), dart_string("Bob"), dart_string("Charlie"));
  
  // 基本操作
  numbers->add(dart_int(6));
  dart_print(dart_concat(dart_string("Numbers: "), numbers));
  dart_print(dart_concat(dart_string("Length: "), numbers->length()));
  dart_print(dart_concat(dart_string("First: "), numbers->getFirst()));
  dart_print(dart_concat(dart_string("Last: "), numbers->getLast()));
  
  // 高阶函数
  auto doubled = numbers->map([](Int n) { return (n * dart_int(2)); })->toList();
  auto evens = numbers->where([](Int n) { return ((n % dart_int(2)) == dart_int(0)); })->toList();
  
  dart_print(dart_concat(dart_string("Doubled: "), doubled));
  dart_print(dart_concat(dart_string("Evens: "), evens));
  
  return Void;
}
```

### Map 操作

**Dart 代码**:
```dart
void main() {
  // 创建和初始化
  Map<String, int> scores = {
    'Alice': 95,
    'Bob': 87,
    'Charlie': 92
  };
  
  // 基本操作
  scores['David'] = 88;
  print('Scores: $scores');
  print('Alice score: ${scores['Alice']}');
  print('Keys: ${scores.keys}');
  print('Values: ${scores.values}');
  
  // 遍历
  scores.forEach((name, score) {
    print('$name: $score');
  });
}
```

**转换后的 C++ 代码**:
```cpp
#include "dart2cpp.h"

Nullable main() {
  // 创建和初始化
  auto scores = Map<String, Int>::create();
  scores->put(dart_string("Alice"), dart_int(95));
  scores->put(dart_string("Bob"), dart_int(87));
  scores->put(dart_string("Charlie"), dart_int(92));
  
  // 基本操作
  scores->put(dart_string("David"), dart_int(88));
  dart_print(dart_concat(dart_string("Scores: "), scores));
  dart_print(dart_concat(dart_string("Alice score: "), scores->get(dart_string("Alice"))));
  dart_print(dart_concat(dart_string("Keys: "), scores->keySet()));
  dart_print(dart_concat(dart_string("Values: "), scores->values()));
  
  // 遍历
  scores->forEach([](String name, Int score) {
    dart_print(dart_concat(name, dart_string(": "), score));
  });
  
  return Void;
}
```

## 🔧 字符串操作

### 字符串方法

**Dart 代码**:
```dart
void main() {
  String text = "  Hello, Dart2CPP!  ";
  
  print('Original: "$text"');
  print('Length: ${text.length}');
  print('Trimmed: "${text.trim()}"');
  print('Upper: ${text.toUpperCase()}');
  print('Lower: ${text.toLowerCase()}');
  print('Contains "Dart": ${text.contains("Dart")}');
  print('Starts with "  H": ${text.startsWith("  H")}');
  print('Ends with "!  ": ${text.endsWith("!  ")}');
  print('Index of "Dart": ${text.indexOf("Dart")}');
  print('Substring (2, 7): "${text.substring(2, 7)}"');
  print('Replace "Dart" with "C++": "${text.replaceAll("Dart", "C++")}"');
  
  // 分割字符串
  String csv = "apple,banana,orange";
  List<String> fruits = csv.split(",");
  print('Fruits: $fruits');
}
```

**转换后的 C++ 代码**:
```cpp
#include "dart2cpp.h"

Nullable main() {
  auto text = dart_string("  Hello, Dart2CPP!  ");
  
  dart_print(dart_concat(dart_string("Original: \""), text, dart_string("\"")));
  dart_print(dart_concat(dart_string("Length: "), text.length()));
  dart_print(dart_concat(dart_string("Trimmed: \""), text.trim(), dart_string("\"")));
  dart_print(dart_concat(dart_string("Upper: "), text.toUpperCase()));
  dart_print(dart_concat(dart_string("Lower: "), text.toLowerCase()));
  dart_print(dart_concat(dart_string("Contains \"Dart\": "), text.contains(dart_string("Dart"))));
  dart_print(dart_concat(dart_string("Starts with \"  H\": "), text.startsWith(dart_string("  H"))));
  dart_print(dart_concat(dart_string("Ends with \"!  \": "), text.endsWith(dart_string("!  "))));
  dart_print(dart_concat(dart_string("Index of \"Dart\": "), text.indexOf(dart_string("Dart"))));
  dart_print(dart_concat(dart_string("Substring (2, 7): \""), text.substring(dart_int(2), dart_int(7)), dart_string("\"")));
  dart_print(dart_concat(dart_string("Replace \"Dart\" with \"C++\": \""), text.replaceAll(dart_string("Dart"), dart_string("C++")), dart_string("\"")));
  
  // 分割字符串
  auto csv = dart_string("apple,banana,orange");
  auto fruits = csv.split(dart_string(","));
  dart_print(dart_concat(dart_string("Fruits: "), fruits));
  
  return Void;
}
```

## 📊 转换总结

### 转换规则总结

| Dart 特性 | C++ 映射 | 转换说明 |
|----------|---------|----------|
| `int` | `Int` | 使用 `dart_int()` 宏 |
| `double` | `Double` | 使用 `dart_double()` 宏 |
| `bool` | `Bool` | 使用 `dart_bool()` 宏 |
| `String` | `String` | 使用 `dart_string()` 宏 |
| `var` | `auto` | 类型推断 |
| `final` | `const auto` | 运行时常量 |
| `const` | `const auto` | 编译时常量 |
| `null` | `Null` | 空值常量 |
| `?.` | `dart_null_check()` | 空安全操作符 |
| `??` | `dart_null_coalesce()` | 空合并操作符 |
| `print()` | `dart_print()` | 输出函数 |
| `'$var'` | `dart_concat()` | 字符串插值 |
| `List<T>` | `ObjectPtr<List<T>>` | 动态数组 |
| `Map<K,V>` | `ObjectPtr<Map<K,V>>` | 键值映射 |
| `for-in` | 迭代器循环 | 使用 `iterator()` |
| `switch` | `if-else if` | 条件分支 |
| `=>` | 普通函数 | 箭头函数转换 |

### 性能考虑

1. **基础类型**: 使用值语义，性能接近原生 C++
2. **字符串**: 字符串池优化，减少内存分配
3. **集合**: 基于 STL 容器，性能优良
4. **智能指针**: 自动内存管理，避免内存泄漏
5. **内联优化**: 编译器可以内联简单操作

### 最佳实践

1. **类型选择**: 优先使用基础类型，避免不必要的装箱
2. **内存管理**: 使用智能指针管理复杂对象
3. **字符串操作**: 利用字符串池减少内存占用
4. **集合操作**: 使用高阶函数提高代码可读性
5. **空值处理**: 正确使用空安全操作符

这些示例展示了 Dart2CPP 如何将 Dart 的基础语法准确地转换为等价的 C++ 代码，保持了原有的语义和行为。
