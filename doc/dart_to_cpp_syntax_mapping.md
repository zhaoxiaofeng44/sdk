# Dart to C++ Syntax Mapping Reference

## 1. 基本类型映射 (Basic Types)

| Dart | C++ (Base Implementation) | 说明 |
|------|---------------------------|------|
| `int` | `Int` | 包装类，支持运算符重载 |
| `double` | `Double` | 包装类，支持运算符重载 |
| `bool` | `Bool` | 包装类，支持隐式转换 |
| `String` | `String` | 使用字符串池优化 |
| `num` | `Int` 或 `Double` | 根据上下文选择 |
| `dynamic` | `Any` | 基类，所有类型的父类 |
| `void` | `void` 或 `Void` | 函数返回类型 |

## 2. 变量声明 (Variable Declaration)

| Dart | C++ (Base Implementation) | 示例 |
|------|---------------------------|------|
| `var x = 5;` | `auto x = Int(5);` | 类型推导 |
| `int x = 5;` | `Int x(5);` 或 `Int x = Int(5);` | 显式类型 |
| `final x = 5;` | `const auto x = Int(5);` | 运行时常量 |
| `const x = 5;` | `const auto x = Int(5);` | 编译时常量（简化） |
| `late int x;` | `Int x;` | 延迟初始化（简化） |

## 3. 运算符 (Operators)

### 3.1 算术运算符

| Dart | C++ | 说明 |
|------|-----|------|
| `a + b` | `a + b` | 直接使用重载 |
| `a - b` | `a - b` | 直接使用重载 |
| `a * b` | `a * b` | 直接使用重载 |
| `a / b` | `a / b` | 浮点除法 |
| `a ~/ b` | `a.integerDivision(b)` | 整除 |
| `a % b` | `a % b` | 取模 |
| `-a` | `-a` | 一元负号 |
| `++a` | `++a` | 前置自增 |
| `a++` | `a++` | 后置自增 |

### 3.2 比较运算符

| Dart | C++ | 说明 |
|------|-----|------|
| `a == b` | `a == b` | 相等比较 |
| `a != b` | `a != b` | 不等比较 |
| `a < b` | `a < b` | 小于 |
| `a <= b` | `a <= b` | 小于等于 |
| `a > b` | `a > b` | 大于 |
| `a >= b` | `a >= b` | 大于等于 |

### 3.3 逻辑运算符

| Dart | C++ | 说明 |
|------|-----|------|
| `a && b` | `a && b` | 逻辑与 |
| `a \|\| b` | `a \|\| b` | 逻辑或 |
| `!a` | `!a` | 逻辑非 |

### 3.4 位运算符

| Dart | C++ | 说明 |
|------|-----|------|
| `a & b` | `a.operator_bitwise_and(b)` | 按位与 |
| `a \| b` | `a.operator_bitwise_or(b)` | 按位或 |
| `a ^ b` | `a.operator_bitwise_xor(b)` | 按位异或 |
| `~a` | `a.operator_bitwise_not()` | 按位取反 |
| `a << b` | `a.operator_shift_left(b)` | 左移 |
| `a >> b` | `a.operator_shift_right(b)` | 右移 |
| `a >>> b` | `dart_unsigned_shift_right(a, b)` | 无符号右移 |

### 3.5 复合赋值运算符

| Dart | C++ | 说明 |
|------|-----|------|
| `a += b` | `a += b` | 加法赋值 |
| `a -= b` | `a -= b` | 减法赋值 |
| `a *= b` | `a *= b` | 乘法赋值 |
| `a /= b` | `a /= b` | 除法赋值 |
| `a %= b` | `a %= b` | 取模赋值 |

## 4. 控制流 (Control Flow)

### 4.1 条件语句

| Dart | C++ | 说明 |
|------|-----|------|
| `if (condition) { }` | `if (condition) { }` | Bool支持隐式转换 |
| `if (condition) { } else { }` | `if (condition) { } else { }` | 同上 |
| `condition ? a : b` | `condition ? a : b` | 三元运算符 |

### 4.2 循环语句

| Dart | C++ | 说明 |
|------|-----|------|
| `while (condition) { }` | `while (condition) { }` | Bool隐式转换 |
| `do { } while (condition);` | `do { } while (condition);` | 同上 |
| `for (int i = 0; i < n; i++) { }` | `for (Int i(0); i < n; ++i) { }` | 使用Int类型 |
| `for (var item in list) { }` | `dart_for_each(Type, item, list) ... dart_end_for` | 使用宏 |

### 4.3 跳转语句

| Dart | C++ | 说明 |
|------|-----|------|
| `break;` | `break;` | 直接使用 |
| `continue;` | `continue;` | 直接使用 |
| `return value;` | `return value;` | 直接使用 |

## 5. 集合类型 (Collections)

### 5.1 List

| Dart | C++ | 说明 |
|------|-----|------|
| `List<int> list = [];` | `ObjectPtr<List<Int>> list = List<Int>::create();` | 工厂方法 |
| `var list = [1, 2, 3];` | 需要逐个add | 暂无字面量支持 |
| `list.add(item)` | `list->add(item)` | 添加元素 |
| `list[i]` | `(*list)[Int(i)]` 或 `list->get(Int(i))` | 访问元素 |
| `list.length` | `list->size()` | 获取长度 |
| `list.isEmpty` | `list->isEmpty()` | 判空 |

### 5.2 Set

| Dart | C++ | 说明 |
|------|-----|------|
| `Set<int> set = {};` | `ObjectPtr<Set<Int>> set = Set<Int>::create();` | 工厂方法 |
| `set.add(item)` | `set->add(item)` | 添加元素 |
| `set.contains(item)` | `set->contains(item)` | 包含判断 |

### 5.3 Map

| Dart | C++ | 说明 |
|------|-----|------|
| `Map<K, V> map = {};` | `ObjectPtr<Map<K,V>> map = Map<K,V>::create();` | 工厂方法 |
| `map[key] = value` | `(*map)[key] = value` 或 `map->put(key, value)` | 设置值 |
| `map[key]` | `(*map)[key]` 或 `map->get(key)` | 获取值 |
| `map.containsKey(key)` | `map->containsKey(key)` | 包含键 |

## 6. 函数 (Functions)

### 6.1 函数定义

| Dart | C++ | 说明 |
|------|-----|------|
| `int add(int a, int b) { return a + b; }` | `Int add(Int a, Int b) { return a + b; }` | 普通函数 |
| `void print(String s) { }` | `void print(String s) { }` | void返回 |
| `String Function(int) f;` | `ObjectPtr<Function> f;` | 函数类型 |

### 6.2 Lambda表达式

| Dart | C++ | 说明 |
|------|-----|------|
| `(x) => x * 2` | `[](Int x) { return x * Int(2); }` | Lambda |
| `(x, y) => x + y` | `[](Int x, Int y) { return x + y; }` | 多参数 |

## 7. 类和对象 (Classes and Objects)

### 7.1 类定义

| Dart | C++ | 说明 |
|------|-----|------|
| `class MyClass { }` | `class MyClass : public Object { }` | 继承Object |
| `class Child extends Parent { }` | `class Child : public Parent { }` | 继承 |
| `class MyClass implements Interface { }` | `DART_CLASS_IMPLEMENTS(MyClass, Interface)` | 使用宏 |

### 7.2 构造函数

| Dart | C++ | 说明 |
|------|-----|------|
| `MyClass(this.field);` | `MyClass(Type field) : field(field) { }` | 初始化列表 |
| `MyClass.named();` | `static ObjectPtr<MyClass> named() { }` | 命名构造函数用静态方法 |

### 7.3 成员访问

| Dart | C++ | 说明 |
|------|-----|------|
| `object.field` | `object->field` 或 `(*object).field` | 使用指针 |
| `object.method()` | `object->method()` | 方法调用 |

## 8. 异步编程 (Async Programming)

### 8.1 Future (简化版)

| Dart | C++ | 说明 |
|------|-----|------|
| `Future<int> f;` | `Future<Int> f;` | Future类型 |
| `await f;` | `f.wait();` | 同步等待 |
| `Future.value(x)` | `Future<Int>::value(x)` | 立即完成 |
| `Future.delayed(duration, () => x)` | `Future<Int>::delayed(duration, x)` | 延迟（简化） |

### 8.2 Async/Await (简化)

| Dart | C++ | 说明 |
|------|-----|------|
| `async` | 无直接对应 | 简化为同步 |
| `await` | `.wait()` | 同步等待 |

## 9. 空安全 (Null Safety - 简化)

| Dart | C++ | 说明 |
|------|-----|------|
| `int?` | `ObjectPtr<Int>` | 可空类型用指针 |
| `int` | `Int` | 非空类型直接用值 |
| `x?.method()` | `if (x) x->method()` | 条件访问 |
| `x ?? y` | `dart_null_coalesce(x, y)` | 空值合并 |
| `x!` | `*x` | 非空断言 |

## 10. 字符串操作 (String Operations)

| Dart | C++ | 说明 |
|------|-----|------|
| `'hello' + 'world'` | `String("hello") + String("world")` | 字符串拼接 |
| `s.length` | `s.get_length()` | 获取长度 |
| `s.isEmpty` | `s.get_isEmpty()` | 判空 |
| `s.substring(start, end)` | `s.substring(Int(start), Int(end))` | 子串 |
| `s.contains(pattern)` | `s.contains(pattern)` | 包含判断 |
| `s.split(delimiter)` | `dart_split(s, delimiter)` | 分割 |
| `s.trim()` | `s.trim()` | 去空格 |
| `s.toLowerCase()` | `s.toLowerCase()` | 转小写 |

## 11. 类型转换 (Type Conversion)

| Dart | C++ | 说明 |
|------|-----|------|
| `x.toString()` | `x.toString()` | 转字符串 |
| `int.parse(s)` | `dart_parse_int(s)` | 字符串转int |
| `double.parse(s)` | `dart_parse_double(s)` | 字符串转double |
| `x as Type` | `dynamic_cast<Type*>(x)` | 类型转换 |
| `x is Type` | `dart_is<Type>(x)` | 类型判断 |

## 12. 辅助宏 (Helper Macros)

| 用途 | 宏名称 | 说明 |
|------|--------|------|
| 快速构造 | `dart_int(5)` | 等价于 `Int(5)` |
| 快速构造 | `dart_string("hello")` | 等价于 `String("hello")` |
| 打印输出 | `dart_print(x)` | 输出toString()结果 |
| 断言 | `dart_assert(cond, msg)` | 条件断言 |
| for-in循环 | `dart_for_each(Type, var, list)` | 遍历集合 |
| 集合创建 | `dart_list_int()` | 创建Int类型List |

## 13. 转换注意事项

### 13.1 必须转换的语法

1. **集合初始化**：Dart的字面量 `[1, 2, 3]` 需要转换为逐个add
2. **for-in循环**：必须使用 `dart_for_each` 宏
3. **整除运算符**：`~/` 必须转换为 `integerDivision()`
4. **无符号右移**：`>>>` 必须转换为 `dart_unsigned_shift_right()`
5. **可空类型**：`Type?` 转换为 `ObjectPtr<Type>`

### 13.2 可选的优化

1. **Bool条件**：可以直接用于if/while，无需 `.toBool()`
2. **运算符**：优先使用 `a + b` 而非 `a.operator_plus(b)`
3. **自增自减**：使用 `++i` 而非 `i = i + Int(1)`

### 13.3 不支持的特性

1. **异步生成器**：`async*` / `yield`
2. **同步生成器**：`sync*` / `yield`
3. **扩展方法**：`extension on Type`
4. **mixin with**：部分支持，需使用宏
5. **枚举方法**：简化的枚举定义

## 14. 示例对照

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
}
```

### C++代码
```cpp
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
}
```

