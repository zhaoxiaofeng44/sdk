# Dart to C++ Conversion Best Practices

本文档提供了将Dart代码转换为C++代码时的最佳实践和常见模式。

## 目录

1. [基本原则](#基本原则)
2. [类型转换策略](#类型转换策略)
3. [常见模式](#常见模式)
4. [性能考虑](#性能考虑)
5. [错误处理](#错误处理)
6. [调试技巧](#调试技巧)

---

## 基本原则

### 1. 保持语义等价

转换后的C++代码应该与原Dart代码具有相同的行为和语义。

**Dart:**
```dart
var x = 5;
var y = x + 10;
print(y);
```

**C++:**
```cpp
auto x = Int(5);
auto y = x + Int(10);
dart_print(y);
```

### 2. 类型安全优先

始终使用正确的包装类型，避免隐式转换错误。

**❌ 错误:**
```cpp
Int x = 5;  // 错误：不会自动转换
```

**✓ 正确:**
```cpp
Int x = Int(5);  // 正确：显式构造
// 或
Int x(5);  // 正确：直接构造
```

### 3. 使用便利宏简化代码

利用提供的宏来简化常见操作。

**可以简化:**
```cpp
auto x = Int(5);
auto s = String("hello");
dart_print(x.toString());
```

**使用宏:**
```cpp
auto x = dart_int(5);
auto s = dart_string("hello");
dart_print(x.toString());
```

---

## 类型转换策略

### 基本类型转换规则

| Dart类型 | C++类型 | 构造方式 | 说明 |
|---------|--------|---------|------|
| `int` | `Int` | `Int(value)` | 32位整数 |
| `double` | `Double` | `Double(value)` | 浮点数 |
| `bool` | `Bool` | `Bool(value)` | 布尔值 |
| `String` | `String` | `String(value)` | 字符串 |

### 集合类型转换

#### List转换

**Dart:**
```dart
List<int> numbers = [1, 2, 3];
```

**C++:**
```cpp
ObjectPtr<List<Int>> numbers = List<Int>::create();
numbers->add(Int(1));
numbers->add(Int(2));
numbers->add(Int(3));
```

**关键点:**
- C++不支持集合字面量，需要逐个添加
- 使用`ObjectPtr`管理生命周期
- 方法调用使用`->`运算符

#### Set转换

**Dart:**
```dart
Set<String> names = {"Alice", "Bob"};
```

**C++:**
```cpp
ObjectPtr<Set<String>> names = Set<String>::create();
names->add(String("Alice"));
names->add(String("Bob"));
```

#### Map转换

**Dart:**
```dart
Map<String, int> ages = {"Alice": 25, "Bob": 30};
```

**C++:**
```cpp
ObjectPtr<Map<String, Int>> ages = Map<String, Int>::create();
ages->put(String("Alice"), Int(25));
ages->put(String("Bob"), Int(30));
// 或使用下标运算符
(*ages)[String("Alice")] = Int(25);
(*ages)[String("Bob")] = Int(30);
```

### 可空类型转换

**Dart:**
```dart
int? nullable = null;
nullable = 5;
int value = nullable ?? 10;
```

**C++:**
```cpp
ObjectPtr<Int> nullable;  // 默认为null
nullable = ObjectPtr<Int>(new Int(5));
Int value = dart_null_coalesce(nullable, Int(10));
```

---

## 常见模式

### 模式1: 变量声明和初始化

**Dart:**
```dart
var x = 5;
final y = 10;
int z = 15;
```

**C++:**
```cpp
auto x = Int(5);
const auto y = Int(10);
Int z = Int(15);
```

### 模式2: 字符串拼接

**Dart:**
```dart
String name = "World";
String greeting = "Hello, " + name + "!";
```

**C++:**
```cpp
String name = String("World");
String greeting = String("Hello, ") + name + String("!");
```

### 模式3: 列表遍历

**Dart:**
```dart
List<int> numbers = [1, 2, 3];
for (var num in numbers) {
  print(num * 2);
}
```

**C++:**
```cpp
ObjectPtr<List<Int>> numbers = List<Int>::create();
numbers->add(Int(1));
numbers->add(Int(2));
numbers->add(Int(3));

dart_for_each(Int, num, numbers)
  dart_print(num * Int(2));
dart_end_for
```

### 模式4: 条件表达式

**Dart:**
```dart
var result = condition ? value1 : value2;
```

**C++:**
```cpp
auto result = condition ? value1 : value2;
// Bool支持隐式转换到bool
```

### 模式5: 方法链式调用

**Dart:**
```dart
String result = text
    .toLowerCase()
    .trim()
    .replaceAll("old", "new");
```

**C++:**
```cpp
String result = text
    .toLowerCase()
    .trim()
    .replaceAll(String("old"), String("new"));
```

### 模式6: 类型转换

**Dart:**
```dart
int x = 5;
String s = x.toString();
double d = x.toDouble();
```

**C++:**
```cpp
Int x = Int(5);
String s = x.toString();
Double d = x.toDouble();
```

### 模式7: 集合操作

**Dart:**
```dart
List<int> filtered = numbers.where((n) => n > 5).toList();
```

**C++:**
```cpp
// 需要手动实现过滤逻辑
ObjectPtr<List<Int>> filtered = List<Int>::create();
auto it = numbers->iterator();
while (it.hasNext()) {
  Int n = it.next();
  if (n > Int(5)) {
    filtered->add(n);
  }
}
```

---

## 性能考虑

### 1. 避免不必要的对象创建

**❌ 低效:**
```cpp
for (Int i(0); i < Int(100); ++i) {
  Int temp = Int(5);  // 每次循环都创建新对象
  result += temp;
}
```

**✓ 高效:**
```cpp
Int temp(5);  // 在循环外创建
for (Int i(0); i < Int(100); ++i) {
  result += temp;
}
```

### 2. 使用引用避免拷贝

**❌ 低效:**
```cpp
void process(List<Int> list) {  // 拷贝整个列表
  // ...
}
```

**✓ 高效:**
```cpp
void process(const ObjectPtr<List<Int>>& list) {  // 引用传递
  // ...
}
```

### 3. 字符串操作优化

字符串使用字符串池，相同的字符串只存储一次。

```cpp
String s1 = String("hello");
String s2 = String("hello");
// s1和s2指向同一个字符串池条目
```

### 4. 集合预分配（暂不支持）

当前实现中集合没有预分配API，未来可以添加：

```cpp
// 未来可能的API
ObjectPtr<List<Int>> list = List<Int>::createWithCapacity(100);
```

---

## 错误处理

### 1. 除零错误

**Dart:**
```dart
var result = a / b;  // 如果b为0，返回Infinity
```

**C++:**
```cpp
Int result = a / b;  // 如果b为0，抛出异常
```

**处理方式:**
```cpp
try {
  Int result = a / b;
} catch (const std::runtime_error& e) {
  std::cerr << "Error: " << e.what() << std::endl;
}
```

### 2. 空指针访问

**Dart:**
```dart
List<int>? list = null;
list?.add(1);  // 安全访问，不会崩溃
```

**C++:**
```cpp
ObjectPtr<List<Int>> list;  // null
if (list.isNotNull()) {
  list->add(Int(1));  // 检查后访问
}
```

### 3. 索引越界

**Dart和C++都会抛出异常:**

```cpp
try {
  Int value = list->get(Int(100));  // 如果索引越界
} catch (const std::out_of_range& e) {
  std::cerr << "Index out of range" << std::endl;
}
```

---

## 调试技巧

### 1. 使用toString()查看值

```cpp
Int x = Int(42);
dart_print(x.toString());  // 输出: 42

String s = String("hello");
dart_print(s);  // 输出: hello
```

### 2. 检查引用计数

```cpp
ObjectPtr<List<Int>> list = List<Int>::create();
std::cout << "Ref count: " << list.get()->getRefCount() << std::endl;
```

### 3. 使用断言验证条件

```cpp
dart_assert(x > Int(0), "x must be positive");
```

### 4. 打印类型信息

```cpp
std::cout << "Type ID: " << x.type_id << std::endl;
```

---

## 常见陷阱

### 陷阱1: 忘记包装字面量

**❌ 错误:**
```cpp
Int x = Int(5);
Int y = x + 10;  // 错误：10不是Int类型
```

**✓ 正确:**
```cpp
Int x = Int(5);
Int y = x + Int(10);
```

### 陷阱2: 集合方法调用使用错误的运算符

**❌ 错误:**
```cpp
ObjectPtr<List<Int>> list = List<Int>::create();
list.add(Int(1));  // 错误：应该用 ->
```

**✓ 正确:**
```cpp
ObjectPtr<List<Int>> list = List<Int>::create();
list->add(Int(1));
```

### 陷阱3: 忘记dart_end_for

**❌ 错误:**
```cpp
dart_for_each(Int, num, numbers)
  dart_print(num);
// 缺少 dart_end_for
```

**✓ 正确:**
```cpp
dart_for_each(Int, num, numbers)
  dart_print(num);
dart_end_for
```

### 陷阱4: 字符串比较使用错误的运算符

**❌ 可能有问题:**
```cpp
if (s == "hello") {  // 可能工作，但不推荐
```

**✓ 正确:**
```cpp
if (s == String("hello")) {  // 明确类型
```

---

## 转换检查清单

转换Dart代码到C++时，请检查以下项目：

- [ ] 所有字面量都被包装到对应的类型（Int, Double, Bool, String）
- [ ] 集合类型使用ObjectPtr管理
- [ ] 集合初始化改为逐个add调用
- [ ] for-in循环转换为dart_for_each宏
- [ ] 整除运算符~/改为integerDivision方法
- [ ] 无符号右移>>>改为dart_unsigned_shift_right函数
- [ ] print语句改为dart_print宏
- [ ] 可空类型改为ObjectPtr
- [ ] 包含必要的头文件
- [ ] 所有dart_for_each都有对应的dart_end_for

---

## 总结

遵循这些最佳实践可以确保：

1. **正确性**: 转换后的代码行为与原Dart代码一致
2. **可维护性**: 代码清晰易读，易于维护
3. **性能**: 避免常见的性能陷阱
4. **安全性**: 正确处理内存管理和错误情况

记住：当有疑问时，参考测试套件中的示例代码！

