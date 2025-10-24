# Dart 标准语法与 Base 库实现对照表

## 概述
此文档对比了 Dart 标准语法与当前 base 库的 C++ 实现，列出了已实现的功能、语法对照和未实现的功能。

## 1. 基础数据类型

| Dart 语法 | Base 库实现 | 对照示例 | 状态 |
|----------|------------|----------|------|
| `int` | `Int` | `int x = 5;` ↔ `Int x(5);` | ✅ 已实现 |
| `double` | `Double` | `double y = 3.14;` ↔ `Double y(3.14);` | ✅ 已实现 |
| `bool` | `Bool` | `bool flag = true;` ↔ `Bool flag(true);` | ✅ 已实现 |
| `String` | `String` | `String name = "hello";` ↔ `String name("hello");` | ✅ 已实现 |
| `Object` | `Any` | `Object obj;` ↔ `Any obj;` | ✅ 已实现 |
| `void` | `Void` | `void func() {}` ↔ `Void func() {}` | ✅ 已实现 |
| `num` | - | `num value = 42;` | ❌ 未实现 |
| `dynamic` | - | `dynamic x = anything;` | ❌ 未实现 |

## 2. 算术运算符

| Dart 语法 | Base 库实现 | 对照示例 | 状态 |
|----------|------------|----------|------|
| `+` (加法) | `operator+` / `operator_plus` | `a + b` ↔ `a.operator_plus(b)` | ✅ 已实现 |
| `-` (减法) | `operator-` / `operator_minus` | `a - b` ↔ `a.operator_minus(b)` | ✅ 已实现 |
| `*` (乘法) | `operator*` / `operator_multiply` | `a * b` ↔ `a.operator_multiply(b)` | ✅ 已实现 |
| `/` (除法) | `operator/` / `operator_divide` | `a / b` ↔ `a.operator_divide(b)` | ✅ 已实现 |
| `%` (取模) | `operator%` / `operator_modulo` | `a % b` ↔ `a.operator_modulo(b)` | ✅ 已实现 |
| `~/` (整除) | `integerDivision` | `a ~/ b` ↔ `a.integerDivision(b)` | ✅ 已实现 |
| `++` (自增) | - | `++a` 或 `a++` | ❌ 未实现 |
| `--` (自减) | - | `--a` 或 `a--` | ❌ 未实现 |

## 3. 比较运算符

| Dart 语法 | Base 库实现 | 对照示例 | 状态 |
|----------|------------|----------|------|
| `==` (等于) | `operator==` | `a == b` ↔ `a.operator==(b)` | ✅ 已实现 |
| `!=` (不等于) | `operator!=` | `a != b` ↔ `a.operator!=(b)` | ✅ 已实现 |
| `<` (小于) | `operator<` | `a < b` ↔ `a.operator<(b)` | ✅ 已实现 |
| `<=` (小于等于) | `operator<=` | `a <= b` ↔ `a.operator<=(b)` | ✅ 已实现 |
| `>` (大于) | `operator>` | `a > b` ↔ `a.operator>(b)` | ✅ 已实现 |
| `>=` (大于等于) | `operator>=` | `a >= b` ↔ `a.operator>=(b)` | ✅ 已实现 |

## 4. 逻辑运算符

| Dart 语法 | Base 库实现 | 对照示例 | 状态 |
|----------|------------|----------|------|
| `&&` (逻辑与) | `operator&&` | `a && b` ↔ `a.operator&&(b)` | ✅ 已实现 |
| `\|\|` (逻辑或) | `operator\|\|` | `a \|\| b` ↔ `a.operator\|\|(b)` | ✅ 已实现 |
| `!` (逻辑非) | `operator!` | `!a` ↔ `a.operator!()` | ✅ 已实现 |

## 5. 位运算符

| Dart 语法 | Base 库实现 | 对照示例 | 状态 |
|----------|------------|----------|------|
| `&` (按位与) | `operator_bitwise_and` | `a & b` ↔ `a.operator_bitwise_and(b)` | ✅ 已实现 |
| `\|` (按位或) | `operator_bitwise_or` | `a \| b` ↔ `a.operator_bitwise_or(b)` | ✅ 已实现 |
| `^` (按位异或) | `operator_bitwise_xor` | `a ^ b` ↔ `a.operator_bitwise_xor(b)` | ✅ 已实现 |
| `~` (按位取反) | `operator_bitwise_not` | `~a` ↔ `a.operator_bitwise_not()` | ✅ 已实现 |
| `<<` (左移) | `operator_shift_left` | `a << b` ↔ `a.operator_shift_left(b)` | ✅ 已实现 |
| `>>` (右移) | `operator_shift_right` | `a >> b` ↔ `a.operator_shift_right(b)` | ✅ 已实现 |
| `>>>` (无符号右移) | - | `a >>> b` | ❌ 未实现 |

## 6. 集合类型

| Dart 语法 | Base 库实现 | 对照示例 | 状态 |
|----------|------------|----------|------|
| `List<T>` | `List<T>` | `List<int> list = [1,2,3];` ↔ `auto list = List<Int>::create({Int(1), Int(2), Int(3)});` | ✅ 已实现 |
| `Set<T>` | `Set<T>` | `Set<int> set = {1,2,3};` ↔ `auto set = Set<Int>::create({Int(1), Int(2), Int(3)});` | ✅ 已实现 |
| `Map<K,V>` | `Map<K,V>` | `Map<String, int> map = {'a': 1};` ↔ `auto map = Map<String,Int>::create({{"a", Int(1)}});` | ✅ 已实现 |
| `Iterable<T>` | 迭代器类 | `for(var x in list)` ↔ `auto it = list->iterator(); while(it.hasNext()) { auto x = it.next(); }` | ✅ 已实现 |

## 7. 字符串操作

| Dart 语法 | Base 库实现 | 对照示例 | 状态 |
|----------|------------|----------|------|
| 字符串拼接 `+` | `operator+` | `"hello" + "world"` ↔ `String("hello") + String("world")` | ✅ 已实现 |
| 字符串插值 `${}` | - | `"Hello $name"` | ❌ 未实现 |
| `length` | `get_length()` | `str.length` ↔ `str.get_length()` | ✅ 已实现 |
| `isEmpty` | `get_isEmpty()` | `str.isEmpty` ↔ `str.get_isEmpty()` | ✅ 已实现 |
| `isNotEmpty` | `get_isNotEmpty()` | `str.isNotEmpty` ↔ `str.get_isNotEmpty()` | ✅ 已实现 |
| `substring()` | `substring()` | `str.substring(1, 3)` ↔ `str.substring(Int(1), Int(3))` | ✅ 已实现 |
| `indexOf()` | `indexOf()` | `str.indexOf("abc")` ↔ `str.indexOf(String("abc"), Int(0))` | ✅ 已实现 |
| `contains()` | `contains()` | `str.contains("abc")` ↔ `str.contains(String("abc"))` | ✅ 已实现 |
| `startsWith()` | `startsWith()` | `str.startsWith("abc")` ↔ `str.startsWith(String("abc"))` | ✅ 已实现 |
| `endsWith()` | `endsWith()` | `str.endsWith("abc")` ↔ `str.endsWith(String("abc"))` | ✅ 已实现 |
| `toLowerCase()` | `toLowerCase()` | `str.toLowerCase()` ↔ `str.toLowerCase()` | ✅ 已实现 |
| `toUpperCase()` | `toUpperCase()` | `str.toUpperCase()` ↔ `str.toUpperCase()` | ✅ 已实现 |
| `trim()` | `trim()` | `str.trim()` ↔ `str.trim()` | ✅ 已实现 |
| `split()` | - | `str.split(",")` | ❌ 未实现 |
| `replaceAll()` | `replaceAll()` | `str.replaceAll("a", "b")` ↔ `str.replaceAll(String("a"), String("b"))` | ✅ 已实现 |

## 8. 变量声明

| Dart 语法 | Base 库实现 | 对照示例 | 状态 |
|----------|------------|----------|------|
| `var` | - | `var x = 5;` | ❌ 未实现 |
| `final` | - | `final x = 5;` | ❌ 未实现 |
| `const` | - | `const x = 5;` | ❌ 未实现 |
| `late` | - | `late String name;` | ❌ 未实现 |
| 类型推断 | - | `String name = "hello";` （自动推断类型） | ❌ 未实现 |

## 9. 控制流语句

| Dart 语法 | Base 库实现 | 状态 |
|----------|------------|------|
| `if` / `else` | - | ❌ 未实现 |
| `for` 循环 | - | ❌ 未实现 |
| `while` 循环 | - | ❌ 未实现 |
| `do-while` 循环 | - | ❌ 未实现 |
| `switch` / `case` | - | ❌ 未实现 |
| `break` / `continue` | - | ❌ 未实现 |
| `for-in` 循环 | 可通过迭代器实现 | ⚠️ 部分实现 |

## 10. 函数和方法

| Dart 语法 | Base 库实现 | 对照示例 | 状态 |
|----------|------------|----------|------|
| 函数定义 | `Function` 类 | `int add(int a, int b) {}` ↔ `Function::create(add_func)` | ⚠️ 部分实现 |
| 匿名函数/Lambda | `Function` 类 | `(x) => x * 2` ↔ `Function::create(lambda)` | ⚠️ 部分实现 |
| 可选位置参数 | - | `func([int a])` | ❌ 未实现 |
| 可选命名参数 | - | `func({int a})` | ❌ 未实现 |
| 参数默认值 | - | `func(int a = 5)` | ❌ 未实现 |

## 11. 类和对象

| Dart 语法 | Base 库实现 | 状态 |
|----------|------------|------|
| 类定义 `class` | `Object` 基类 | ⚠️ 部分实现 |
| 构造函数 | 通过 C++ 构造函数 | ⚠️ 部分实现 |
| 命名构造函数 | - | ❌ 未实现 |
| 私有成员 `_` | - | ❌ 未实现 |
| Getter/Setter | `get_xxx()` 方法 | ⚠️ 部分实现 |
| 静态成员 `static` | - | ❌ 未实现 |
| 抽象类 `abstract` | - | ❌ 未实现 |

## 12. 继承和多态

| Dart 语法 | Base 库实现 | 状态 |
|----------|------------|------|
| 继承 `extends` | C++ 继承 | ⚠️ 部分实现 |
| 方法重写 `@override` | C++ 虚函数 | ⚠️ 部分实现 |
| `super` 关键字 | - | ❌ 未实现 |

## 13. 接口和抽象

| Dart 语法 | Base 库实现 | 状态 |
|----------|------------|------|
| 接口 `implements` | - | ❌ 未实现 |
| 混入 `mixin` | - | ❌ 未实现 |
| 抽象方法 | C++ 纯虚函数 | ⚠️ 部分实现 |

## 14. 泛型

| Dart 语法 | Base 库实现 | 状态 |
|----------|------------|------|
| 泛型类 `<T>` | C++ 模板类 | ✅ 已实现 |
| 泛型函数 | C++ 模板函数 | ✅ 已实现 |
| 泛型约束 `extends` | - | ❌ 未实现 |

## 15. 异常处理

| Dart 语法 | Base 库实现 | 状态 |
|----------|------------|------|
| `try` / `catch` | C++ 异常机制 | ⚠️ 部分实现 |
| `finally` | - | ❌ 未实现 |
| `throw` | C++ `throw` | ⚠️ 部分实现 |
| 自定义异常 | - | ❌ 未实现 |

## 16. 异步编程

| Dart 语法 | Base 库实现 | 状态 |
|----------|------------|------|
| `Future<T>` | - | ❌ 未实现 |
| `async` / `await` | - | ❌ 未实现 |
| `Stream<T>` | - | ❌ 未实现 |
| `yield` / `yield*` | - | ❌ 未实现 |

## 17. 库和模块

| Dart 语法 | Base 库实现 | 状态 |
|----------|------------|------|
| `import` | C++ `#include` | ⚠️ 部分实现 |
| `export` | - | ❌ 未实现 |
| `library` | - | ❌ 未实现 |
| `part` / `part of` | - | ❌ 未实现 |

## 18. 其他语言特性

| Dart 语法 | Base 库实现 | 状态 |
|----------|------------|------|
| `null` 安全性 | - | ❌ 未实现 |
| `?` / `!` 空值操作符 | - | ❌ 未实现 |
| `??` 空值合并操作符 | - | ❌ 未实现 |
| `?.` 条件访问操作符 | - | ❌ 未实现 |
| `...` 扩展操作符 | - | ❌ 未实现 |
| `is` / `is!` 类型检查 | - | ❌ 未实现 |
| `as` 类型转换 | - | ❌ 未实现 |
| `typedef` 类型别名 | - | ❌ 未实现 |
| 枚举 `enum` | - | ❌ 未实现 |
| 扩展方法 `extension` | - | ❌ 未实现 |

## 总结

### 已实现功能 (✅)
- 基础数据类型 (int, double, bool, String)
- 基本算术、比较、逻辑、位运算符
- 集合类型 (List, Set, Map) 及其基本操作
- 字符串操作方法
- 基础的面向对象特性（继承、多态）
- 泛型支持
- 迭代器模式
- 引用计数内存管理

### 部分实现功能 (⚠️)
- 函数包装和调用
- 基础的面向对象特性
- 异常处理机制

### 未实现功能 (❌)
- 控制流语句 (if/else, for, while, switch)
- 变量声明关键字 (var, final, const, late)
- 完整的函数系统（可选参数、默认值等）
- 异步编程 (Future, async/await, Stream)
- 空值安全性和相关操作符
- 高级面向对象特性（接口、混入、抽象类）
- 库和模块系统
- 枚举、扩展方法等现代语言特性

当前的 base 库主要实现了 Dart 的核心数据类型和基本操作，适合作为一个运行时库的基础，但还需要大量工作来支持完整的 Dart 语法特性。
