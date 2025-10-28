# Dart to C++ Quick Reference Guide

快速参考指南 - 常用语法转换速查表

---

## 基本类型

```dart
// Dart
var x = 5;
int y = 10;
double pi = 3.14;
bool flag = true;
String name = "Dart";
```

```cpp
// C++
auto x = Int(5);
Int y = Int(10);
Double pi = Double(3.14);
Bool flag = Bool(true);
String name = String("Dart");
```

---

## 运算符

### 算术

```dart
a + b, a - b, a * b, a / b, a % b, a ~/ b
```

```cpp
a + b, a - b, a * b, a / b, a % b, a.integerDivision(b)
```

### 比较

```dart
a == b, a != b, a < b, a <= b, a > b, a >= b
```

```cpp
a == b, a != b, a < b, a <= b, a > b, a >= b
```

### 逻辑

```dart
a && b, a || b, !a
```

```cpp
a && b, a || b, !a
```

---

## 字符串

```dart
// Dart
"Hello, " + name
name.length
name.isEmpty
name.toLowerCase()
name.toUpperCase()
name.trim()
name.contains("lo")
name.substring(0, 2)
```

```cpp
// C++
String("Hello, ") + name
name.get_length()
name.get_isEmpty()
name.toLowerCase()
name.toUpperCase()
name.trim()
name.contains(String("lo"))
name.substring(Int(0), Int(2))
```

---

## 集合

### List

```dart
// Dart
List<int> list = [];
list.add(1);
list[0]
list.length
list.isEmpty
```

```cpp
// C++
ObjectPtr<List<Int>> list = List<Int>::create();
list->add(Int(1));
(*list)[Int(0)]
list->size()
list->isEmpty()
```

### Set

```dart
// Dart
Set<int> set = {};
set.add(1);
set.contains(1)
```

```cpp
// C++
ObjectPtr<Set<Int>> set = Set<Int>::create();
set->add(Int(1));
set->contains(Int(1))
```

### Map

```dart
// Dart
Map<String, int> map = {};
map["key"] = 1;
map["key"]
map.containsKey("key")
```

```cpp
// C++
ObjectPtr<Map<String, Int>> map = Map<String, Int>::create();
(*map)[String("key")] = Int(1);
(*map)[String("key")]
map->containsKey(String("key"))
```

---

## 控制流

### if语句

```dart
// Dart
if (condition) {
  // ...
} else {
  // ...
}
```

```cpp
// C++
if (condition) {
  // ...
} else {
  // ...
}
```

### 三元运算符

```dart
condition ? a : b
```

```cpp
condition ? a : b
```

### for循环

```dart
// Dart
for (int i = 0; i < 10; i++) {
  // ...
}
```

```cpp
// C++
for (Int i(0); i < Int(10); ++i) {
  // ...
}
```

### for-in循环

```dart
// Dart
for (var item in list) {
  print(item);
}
```

```cpp
// C++
dart_for_each(Int, item, list)
  dart_print(item);
dart_end_for
```

### while循环

```dart
// Dart
while (condition) {
  // ...
}
```

```cpp
// C++
while (condition) {
  // ...
}
```

---

## 类型转换

```dart
// Dart
x.toString()
int.parse("123")
double.parse("3.14")
x.toDouble()
```

```cpp
// C++
x.toString()
dart_parse_int(String("123"))
dart_parse_double(String("3.14"))
x.toDouble()
```

---

## 空值处理

```dart
// Dart
int? nullable = null;
nullable = 5;
nullable ?? 10
nullable?.method()
```

```cpp
// C++
ObjectPtr<Int> nullable;
nullable = ObjectPtr<Int>(new Int(5));
dart_null_coalesce(nullable, Int(10))
if (nullable) nullable->method()
```

---

## 常用宏

```cpp
// 类型构造
dart_int(5)          // Int(5)
dart_double(3.14)    // Double(3.14)
dart_bool(true)      // Bool(true)
dart_string("hi")    // String("hi")

// 集合创建
dart_list_int()      // List<Int>::create()
dart_set_int()       // Set<Int>::create()
dart_map_string_int() // Map<String, Int>::create()

// 打印
dart_print(x)        // std::cout << x.toString() << std::endl

// 断言
dart_assert(condition, "message")

// for-in循环
dart_for_each(Type, var, collection)
  // body
dart_end_for
```

---

## 完整示例

### Dart代码

```dart
void main() {
  var x = 5;
  var y = 10;
  var sum = x + y;
  
  List<int> numbers = [1, 2, 3];
  for (var num in numbers) {
    print(num * 2);
  }
  
  String greeting = "Hello, " + "World";
  print(greeting.toUpperCase());
}
```

### C++代码

```cpp
#include "pkg/dart2bytecode/base/object.h"
#include "pkg/dart2bytecode/base/object_extensions_simple.h"
#include "pkg/dart2bytecode/base/dart_syntax_simple.h"

void main() {
  auto x = Int(5);
  auto y = Int(10);
  auto sum = x + y;
  
  ObjectPtr<List<Int>> numbers = List<Int>::create();
  numbers->add(Int(1));
  numbers->add(Int(2));
  numbers->add(Int(3));
  
  dart_for_each(Int, num, numbers)
    dart_print(num * Int(2));
  dart_end_for
  
  String greeting = String("Hello, ") + String("World");
  dart_print(greeting.toUpperCase());
}
```

---

## 常见错误

### ❌ 错误1: 忘记包装字面量

```cpp
Int x = Int(5);
Int y = x + 10;  // ❌ 错误
```

### ✅ 正确:

```cpp
Int x = Int(5);
Int y = x + Int(10);  // ✅ 正确
```

### ❌ 错误2: 集合方法使用错误运算符

```cpp
ObjectPtr<List<Int>> list = List<Int>::create();
list.add(Int(1));  // ❌ 错误 (应该用 ->)
```

### ✅ 正确:

```cpp
ObjectPtr<List<Int>> list = List<Int>::create();
list->add(Int(1));  // ✅ 正确
```

### ❌ 错误3: for-in缺少结束标记

```cpp
dart_for_each(Int, num, numbers)
  dart_print(num);
// ❌ 缺少 dart_end_for
```

### ✅ 正确:

```cpp
dart_for_each(Int, num, numbers)
  dart_print(num);
dart_end_for  // ✅ 正确
```

---

## 需要记住的规则

1. **所有字面量必须包装**: 5 → Int(5)
2. **集合用指针访问**: list->add() 不是 list.add()
3. **for-in必须配对**: dart_for_each ... dart_end_for
4. **整除用方法**: ~/ → integerDivision()
5. **可空用指针**: int? → ObjectPtr<Int>

---

## 更多信息

- 完整语法映射: `doc/dart_to_cpp_syntax_mapping.md`
- 最佳实践: `doc/conversion_best_practices.md`
- 测试示例: `test/dart_to_cpp_conversion_tests.cpp`
