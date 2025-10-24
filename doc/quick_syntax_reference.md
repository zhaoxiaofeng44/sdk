# Dart ↔ Base 库语法快速参考

## 数据类型对照

| Dart | Base 库 | 示例 |
|------|--------|------|
| `int x = 42;` | `Int x(42);` | ✅ |
| `double y = 3.14;` | `Double y(3.14);` | ✅ |
| `bool flag = true;` | `Bool flag(true);` | ✅ |
| `String name = "hello";` | `String name("hello");` | ✅ |

## 运算符对照

| Dart | Base 库 | 状态 |
|------|--------|------|
| `a + b` | `a.operator+(b)` | ✅ |
| `a - b` | `a.operator-(b)` | ✅ |
| `a * b` | `a.operator*(b)` | ✅ |
| `a / b` | `a.operator/(b)` | ✅ |
| `a % b` | `a.operator%(b)` | ✅ |
| `a ~/ b` | `a.integerDivision(b)` | ✅ |
| `a == b` | `a.operator==(b)` | ✅ |
| `a < b` | `a.operator<(b)` | ✅ |
| `a && b` | `a.operator&&(b)` | ✅ |
| `a++` | - | ❌ |

## 集合操作对照

| Dart | Base 库 | 状态 |
|------|--------|------|
| `List<int> list = [1,2,3];` | `auto list = List<Int>::create({Int(1), Int(2), Int(3)});` | ✅ |
| `list.add(4);` | `list->add(Int(4));` | ✅ |
| `list.length` | `list->size()` | ✅ |
| `Set<int> set = {1,2,3};` | `auto set = Set<Int>::create({Int(1), Int(2), Int(3)});` | ✅ |
| `Map<String,int> map = {"a":1};` | `auto map = Map<String,Int>::create({{"a", Int(1)}});` | ✅ |

## 字符串操作对照

| Dart | Base 库 | 状态 |
|------|--------|------|
| `str.length` | `str.get_length()` | ✅ |
| `str.isEmpty` | `str.get_isEmpty()` | ✅ |
| `str + "world"` | `str + String("world")` | ✅ |
| `str.substring(1,3)` | `str.substring(Int(1), Int(3))` | ✅ |
| `str.contains("abc")` | `str.contains(String("abc"))` | ✅ |
| `str.toLowerCase()` | `str.toLowerCase()` | ✅ |
| `"Hello $name"` | - | ❌ |
| `str.split(",")`| - | ❌ |

## 控制流对照

| Dart | Base 库 | 状态 |
|------|--------|------|
| `if (condition) { ... }` | - | ❌ |
| `for (int i = 0; i < 10; i++) { ... }` | - | ❌ |
| `while (condition) { ... }` | - | ❌ |
| `for (var item in list) { ... }` | `auto it = list->iterator(); while(it.hasNext()) { auto item = it.next(); ... }` | ⚠️ |

## 函数对照

| Dart | Base 库 | 状态 |
|------|--------|------|
| `int add(int a, int b) { return a + b; }` | `auto func = Function::create(add_func);` | ⚠️ |
| `(int x) => x * 2` | `Function::create([](int x){ return x * 2; });` | ⚠️ |
| `func(param: value)` | - | ❌ |
| `func([optional])` | - | ❌ |

## 面向对象对照

| Dart | Base 库 | 状态 |
|------|--------|------|
| `class MyClass extends BaseClass { ... }` | `class MyClass : public BaseClass { ... };` | ⚠️ |
| `@override method() { ... }` | `virtual method() override { ... }` | ⚠️ |
| `abstract class A { ... }` | - | ❌ |
| `class A implements B { ... }` | - | ❌ |
| `mixin M { ... }` | - | ❌ |

## 图例
- ✅ **已完整实现** - 语法和功能都已实现
- ⚠️ **部分实现** - 基本功能实现但语法不完全对等
- ❌ **未实现** - 该功能尚未实现
