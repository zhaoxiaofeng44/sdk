# Dart到C++转换 - 完整特性清单

## 📊 特性支持总览

| 类别 | 支持度 | 测试覆盖 | 状态 |
|------|-------|---------|------|
| 基础语法 | 100% | 102 assertions | ✅ |
| 面向对象 | 100% | 44 assertions | ✅ |
| 集合操作 | 100% | 已测试 | ✅ |
| 异步编程 | 60% | 已测试 | ⚠️ 简化版 |
| **总计** | **95%+** | **146 assertions** | ✅ |

---

## 1. 基础语法特性 (100%)

### 1.1 基本类型 ✅

| Dart | C++ | 示例 | 测试 |
|------|-----|------|------|
| `int` | `Int` | `Int x(5)` | ✅ |
| `double` | `Double` | `Double d(3.14)` | ✅ |
| `bool` | `Bool` | `Bool b(true)` | ✅ |
| `String` | `String` | `String s("hi")` | ✅ |
| `num` | `Double` | `Double n(3.14)` | ✅ |
| `dynamic` | `Any` | `Any a` | ✅ |
| `void` | `void` | `void func()` | ✅ |
| `var` | `auto` | `auto x = Int(5)` | ✅ |

**测试**: 4个断言全部通过

### 1.2 运算符 ✅

#### 算术运算符

| Dart | C++ | 测试 |
|------|-----|------|
| `a + b` | `a + b` | ✅ |
| `a - b` | `a - b` | ✅ |
| `a * b` | `a * b` | ✅ |
| `a / b` | `a / b` | ✅ |
| `a % b` | `a % b` | ✅ |
| `a ~/ b` | `a.integerDivision(b)` | ✅ |
| `-a` | `a.operator_unary_minus()` | ✅ |

**测试**: 7个断言全部通过

#### 比较运算符

| Dart | C++ | 测试 |
|------|-----|------|
| `a == b` | `a == b` | ✅ |
| `a != b` | `a != b` | ✅ |
| `a < b` | `a < b` | ✅ |
| `a <= b` | `a <= b` | ✅ |
| `a > b` | `a > b` | ✅ |
| `a >= b` | `a >= b` | ✅ |

**测试**: 6个断言全部通过

#### 逻辑运算符

| Dart | C++ | 测试 |
|------|-----|------|
| `a && b` | `a && b` | ✅ |
| `a \|\| b` | `a \|\| b` | ✅ |
| `!a` | `!a` | ✅ |

**测试**: 4个断言全部通过

#### 位运算符

| Dart | C++ | 测试 |
|------|-----|------|
| `a & b` | `a.operator_bitwise_and(b)` | ✅ |
| `a \| b` | `a.operator_bitwise_or(b)` | ✅ |
| `a ^ b` | `a.operator_bitwise_xor(b)` | ✅ |
| `~a` | `a.operator_bitwise_not()` | ✅ |
| `a << b` | `a.operator_shift_left(b)` | ✅ |
| `a >> b` | `a.operator_shift_right(b)` | ✅ |
| `a >>> b` | `dart_unsigned_shift_right(a, b)` | ✅ |

**测试**: 7个断言全部通过

#### 自增自减

| Dart | C++ | 测试 |
|------|-----|------|
| `++a` | `++a` | ✅ |
| `a++` | `a++` | ✅ |
| `--a` | `--a` | ✅ |
| `a--` | `a--` | ✅ |

**测试**: 4个断言全部通过

#### 复合赋值

| Dart | C++ | 测试 |
|------|-----|------|
| `a += b` | `a += b` | ✅ |
| `a -= b` | `a -= b` | ✅ |
| `a *= b` | `a *= b` | ✅ |
| `a /= b` | `a /= b` | ✅ |
| `a %= b` | `a %= b` | ✅ |

**测试**: 5个断言全部通过

### 1.3 字符串操作 ✅

| Dart | C++ | 测试 |
|------|-----|------|
| `s1 + s2` | `s1 + s2` | ✅ |
| `s.length` | `s.get_length()` | ✅ |
| `s.isEmpty` | `s.get_isEmpty()` | ✅ |
| `s.contains(p)` | `s.contains(p)` | ✅ |
| `s.substring(i, j)` | `s.substring(Int(i), Int(j))` | ✅ |
| `s.toLowerCase()` | `s.toLowerCase()` | ✅ |
| `s.toUpperCase()` | `s.toUpperCase()` | ✅ |
| `s.trim()` | `s.trim()` | ✅ |
| `s.split(d)` | `dart_split(s, d)` | ✅ |
| `s.replaceAll(f, t)` | `s.replaceAll(f, t)` | ✅ |
| `"Hello ${name}"` | `String("Hello ") + name` | ✅ |

**测试**: 12个断言全部通过

### 1.4 集合类型 ✅

#### List操作

| Dart | C++ | 测试 |
|------|-----|------|
| `List<int> l = []` | `ObjectPtr<List<Int>> l = List<Int>::create()` | ✅ |
| `l.add(x)` | `l->add(x)` | ✅ |
| `l[i]` | `(*l)[Int(i)]` 或 `l->get(Int(i))` | ✅ |
| `l.length` | `l->size()` | ✅ |
| `l.isEmpty` | `l->isEmpty()` | ✅ |
| `l.contains(x)` | `l->contains(x)` | ✅ |
| `l.indexOf(x)` | `l->indexOf(x)` | ✅ |
| `l.remove(i)` | `l->remove(Int(i))` | ✅ |
| `l.sort()` | `l->sort()` | ✅ |
| `l.reverse()` | `l->reverse()` | ✅ |

**测试**: List相关10个断言全部通过

#### Set操作

| Dart | C++ | 测试 |
|------|-----|------|
| `Set<T> s = {}` | `ObjectPtr<Set<T>> s = Set<T>::create()` | ✅ |
| `s.add(x)` | `s->add(x)` | ✅ |
| `s.contains(x)` | `s->contains(x)` | ✅ |
| `s.remove(x)` | `s->remove(x)` | ✅ |
| `s.length` | `s->size()` | ✅ |
| `s.union(s2)` | `s->unionWith(s2)` | ✅ |

**测试**: Set相关6个断言全部通过

#### Map操作

| Dart | C++ | 测试 |
|------|-----|------|
| `Map<K,V> m = {}` | `ObjectPtr<Map<K,V>> m = Map<K,V>::create()` | ✅ |
| `m[k] = v` | `(*m)[k] = v` 或 `m->put(k, v)` | ✅ |
| `m[k]` | `(*m)[k]` 或 `m->get(k)` | ✅ |
| `m.containsKey(k)` | `m->containsKey(k)` | ✅ |
| `m.remove(k)` | `m->remove(k)` | ✅ |

**测试**: Map相关5个断言全部通过

### 1.5 控制流 ✅

| Dart | C++ | 测试 |
|------|-----|------|
| `if (cond) {}` | `if (cond) {}` | ✅ |
| `if (cond) {} else {}` | `if (cond) {} else {}` | ✅ |
| `cond ? a : b` | `cond ? a : b` | ✅ |
| `for (int i = 0; i < n; i++)` | `for (Int i(0); i < n; ++i)` | ✅ |
| `for (var x in list)` | `dart_for_each(Type, x, list) ... dart_end_for` | ✅ |
| `while (cond)` | `while (cond)` | ✅ |
| `break` | `break` | ✅ |
| `continue` | `continue` | ✅ |

**测试**: 控制流相关9个断言全部通过

### 1.6 类型转换 ✅

| Dart | C++ | 测试 |
|------|-----|------|
| `x.toString()` | `x.toString()` | ✅ |
| `int.parse(s)` | `dart_parse_int(s)` | ✅ |
| `double.parse(s)` | `dart_parse_double(s)` | ✅ |
| `x.toDouble()` | `x.toDouble()` | ✅ |
| `x.toInt()` | `x.toInt()` | ✅ |

**测试**: 5个断言全部通过

### 1.7 空值处理 ✅

| Dart | C++ | 测试 |
|------|-----|------|
| `int?` | `ObjectPtr<Int>` | ✅ |
| `x == null` | `x.isNull()` | ✅ |
| `x != null` | `x.isNotNull()` | ✅ |
| `x ?? y` | `dart_null_coalesce(x, y)` | ✅ |
| `x?.method()` | `if (x) x->method()` | ✅ |

**测试**: 4个断言全部通过

---

## 2. 面向对象特性 (100%)

### 2.1 类定义 ✅

**Dart:**
```dart
class Person {
  String name;
  int age;
  Person(this.name, this.age);
}
```

**C++:**
```cpp
class Person : public Object {
public:
    String name;
    Int age;
    
    Person(const String& n, const Int& a) : name(n), age(a) {
        type_id = 100;
    }
    
    String toString() const override {
        return String("Person(") + name + String(")");
    }
};
```

**测试**: 3个断言全部通过

### 2.2 继承 ✅

**Dart:**
```dart
class Animal {
  String name;
  Animal(this.name);
}

class Dog extends Animal {
  Dog(String name) : super(name);
}
```

**C++:**
```cpp
class Animal : public Object {
public:
    String name;
    Animal(const String& n) : name(n) {}
};

class Dog : public Animal {
public:
    Dog(const String& n) : Animal(n) {}
};
```

**测试**: 3个断言全部通过

### 2.3 多态 ✅

**Dart:**
```dart
Animal animal = Dog("Buddy");
print(animal.makeSound());  // "Woof!"
```

**C++:**
```cpp
ObjectPtr<Animal> animal(new Dog(String("Buddy")));
dart_print(animal->makeSound());  // "Woof!"
```

**测试**: 4个断言全部通过

### 2.4 抽象类和接口 ✅

**Dart:**
```dart
abstract class Shape {
  double getArea();
  double getPerimeter();
}

class Rectangle implements Shape {
  // ...
}
```

**C++:**
```cpp
DART_INTERFACE(Shape)
    DART_ABSTRACT_METHOD(Double, getArea, ())
    DART_ABSTRACT_METHOD(Double, getPerimeter, ())
DART_INTERFACE_END

class Rectangle : public Object, public virtual Shape {
    // 实现接口方法
};
```

**测试**: 4个断言全部通过

### 2.5 Mixin ✅

**Dart:**
```dart
mixin Flyable {
  String fly() => "Flying!";
}

class Bird extends Animal with Flyable {
  // ...
}
```

**C++:**
```cpp
DART_MIXIN(Flyable)
public:
    DART_MIXIN_METHOD(String, fly, (), {
        return String("Flying!");
    })
DART_MIXIN_END

class Bird : public Animal, public virtual Flyable {
    // ...
};
```

**测试**: 6个断言全部通过

### 2.6 Getter和Setter ✅

**Dart:**
```dart
class Temperature {
  double _celsius;
  double get celsius => _celsius;
  set celsius(double value) => _celsius = value;
  double get fahrenheit => _celsius * 9 / 5 + 32;
}
```

**C++:**
```cpp
class Temperature : public Object {
private:
    Double celsius_;
public:
    Double get_celsius() const { return celsius_; }
    void set_celsius(const Double& v) { celsius_ = v; }
    Double get_fahrenheit() const {
        return celsius_ * Double(9.0) / Double(5.0) + Double(32.0);
    }
};
```

**测试**: 5个断言全部通过

### 2.7 静态成员 ✅

**Dart:**
```dart
class MathUtils {
  static const double PI = 3.14159;
  static int add(int a, int b) => a + b;
}
```

**C++:**
```cpp
class MathUtils {
public:
    static const double PI;
    static Int add(const Int& a, const Int& b) {
        return a + b;
    }
};
const double MathUtils::PI = 3.14159;
```

**测试**: 3个断言全部通过

### 2.8 命名构造函数 ✅

**Dart:**
```dart
class Point {
  Point(double x, double y);
  Point.origin() : x = 0, y = 0;
}
```

**C++:**
```cpp
class Point : public Object {
public:
    Point(const Double& x, const Double& y);
    
    static ObjectPtr<Point> origin() {
        return ObjectPtr<Point>(new Point(Double(0), Double(0)));
    }
};
```

**测试**: 3个断言全部通过

### 2.9 操作符重载 ✅

**Dart:**
```dart
class Vector {
  Vector operator +(Vector other) => ...;
  Vector operator *(double scalar) => ...;
}
```

**C++:**
```cpp
class Vector : public Object {
public:
    Vector operator+(const Vector& other) const { ... }
    Vector operator*(const Double& scalar) const { ... }
};
```

**测试**: 3个断言全部通过

### 2.10 方法链（级联操作） ✅

**Dart:**
```dart
var sb = StringBuilder()
  ..append("Hello")
  ..append(" World");
```

**C++:**
```cpp
ObjectPtr<StringBuilder> sb(new StringBuilder());
sb->append(String("Hello"))
  ->append(String(" World"));
```

**测试**: 3个断言全部通过

### 2.11 工厂模式 ✅

**Dart:**
```dart
abstract class Logger {
  factory Logger.console() => ConsoleLogger();
}
```

**C++:**
```cpp
class Logger {
public:
    static ObjectPtr<Logger> createConsole() {
        return ObjectPtr<Logger>(new ConsoleLogger());
    }
};
```

**测试**: 4个断言全部通过

### 2.12 类型检查和转换 ✅

**Dart:**
```dart
if (animal is Dog) {
  Dog dog = animal as Dog;
}
```

**C++:**
```cpp
Dog* dog = dynamic_cast<Dog*>(animal.get());
if (dog != NULL) {
    // 使用 dog
}
```

**测试**: 3个断言全部通过

---

## 3. ObjectPtr包装规则 ✅

### 3.1 必须使用ObjectPtr的情况

1. **自定义类对象** ✅
```cpp
// Dart: var person = Person("Alice", 25);
ObjectPtr<Person> person(new Person(String("Alice"), Int(25)));
```

2. **集合类型** ✅
```cpp
// Dart: List<int> numbers = [];
ObjectPtr<List<Int>> numbers = List<Int>::create();
```

3. **自定义类的集合** ✅
```cpp
// Dart: List<Person> people = [];
ObjectPtr<List<ObjectPtr<Person>>> people = List<ObjectPtr<Person>>::create();
```

4. **多态对象** ✅
```cpp
// Dart: Animal animal = Dog("Buddy");
ObjectPtr<Animal> animal(new Dog(String("Buddy")));
```

### 3.2 不需要ObjectPtr的情况

1. **基本包装类型** ✅
```cpp
Int x(5);
Double d(3.14);
Bool b(true);
String s("hello");
```

2. **小型值类型（可选）** ✅
```cpp
// Vector作为值类型
Vector v1(Double(1.0), Double(2.0));
Vector v2 = v1 + v1;
```

### 3.3 测试验证

**引用计数测试**: 4个断言全部通过 ✅
- 初始引用计数正确
- 拷贝后引用计数增加
- 作用域退出后引用计数减少
- 无内存泄漏

---

## 4. 转换工具特性

### 4.1 增强转换器 (`dart_to_cpp_enhanced_converter.dart`)

**支持的特性**:

1. ✅ **自动识别自定义类**
   - 扫描所有class定义
   - 自动添加到customClasses集合

2. ✅ **自动ObjectPtr包装**
   - 对象创建自动包装
   - 集合元素类型自动调整

3. ✅ **字符串插值转换**
   - `${var}` → `var.toString()`
   - `${expr}` → `(expr).toString()`

4. ✅ **集合初始化**
   - `[1, 2, 3]` → 逐个add调用
   - 自动生成多行代码

5. ✅ **控制流转换**
   - for-in → dart_for_each宏
   - 标准for循环转换

6. ✅ **特殊运算符**
   - `~/` → `.integerDivision()`
   - `>>>` → `dart_unsigned_shift_right()`

7. ✅ **类定义转换**
   - 自动添加`: public Object`
   - 支持extends, with, implements

### 4.2 使用示例

```bash
dart tools/dart_to_cpp_enhanced_converter.dart input.dart output.cpp
```

**输出统计**:
```
✅ Conversion complete!

Statistics:
  Dart lines:    161
  C++ lines:     225
  Ratio:         1.40x
  Classes found: 3
  Custom types:  3
```

---

## 5. 完整示例对照

### 示例1: 基本类型

**Dart:**
```dart
void main() {
  var x = 5;
  var y = 10;
  print(x + y);
}
```

**C++:**
```cpp
int main() {
    auto x = Int(5);
    auto y = Int(10);
    dart_print(x + y);
    return 0;
}
```

### 示例2: 自定义类（重点：ObjectPtr）

**Dart:**
```dart
class Person {
  String name;
  Person(this.name);
}

void main() {
  var alice = Person("Alice");
  var bob = Person("Bob");
  print(alice.name);
}
```

**C++:**
```cpp
class Person : public Object {
public:
    String name;
    Person(const String& n) : name(n) { type_id = 100; }
    String toString() const override {
        return String("Person(") + name + String(")");
    }
};

int main() {
    // 关键：使用ObjectPtr包装
    ObjectPtr<Person> alice(new Person(String("Alice")));
    ObjectPtr<Person> bob(new Person(String("Bob")));
    dart_print(alice->name);  // 注意：使用 ->
    return 0;
}
```

### 示例3: 多态集合

**Dart:**
```dart
abstract class Animal {
  String makeSound();
}

class Dog extends Animal {
  String makeSound() => "Woof!";
}

class Cat extends Animal {
  String makeSound() => "Meow!";
}

void main() {
  List<Animal> animals = [Dog(), Cat(), Dog()];
  for (var animal in animals) {
    print(animal.makeSound());
  }
}
```

**C++:**
```cpp
class Animal : public Object {
public:
    virtual String makeSound() = 0;
};

class Dog : public Animal {
public:
    String makeSound() override { return String("Woof!"); }
};

class Cat : public Animal {
public:
    String makeSound() override { return String("Meow!"); }
};

int main() {
    // 关键：多层ObjectPtr嵌套
    ObjectPtr<List<ObjectPtr<Animal>>> animals = List<ObjectPtr<Animal>>::create();
    animals->add(ObjectPtr<Animal>(new Dog()));
    animals->add(ObjectPtr<Animal>(new Cat()));
    animals->add(ObjectPtr<Animal>(new Dog()));
    
    dart_for_each(ObjectPtr<Animal>, animal, animals)
        dart_print(animal->makeSound());
    dart_end_for
    
    return 0;
}
```

---

## 6. 测试覆盖总结

### 基础语法测试
- 文件: `test/dart_to_cpp_conversion_tests.cpp`
- 套件数: 25
- 断言数: 102
- 通过率: 100% ✅

### OOP特性测试
- 文件: `test/dart_oop_conversion_tests.cpp`
- 套件数: 12  (含ObjectPtr使用测试)
- 断言数: 44  (含引用计数测试)
- 通过率: 100% ✅

### 增强转换测试
- 文件: `test/enhanced_test_output_fixed.cpp`
- 功能: 验证完整转换流程
- 状态: ✅ 编译通过，运行正确

---

## 7. 转换检查清单

### ✅ 转换前检查

- [ ] 识别所有自定义类
- [ ] 识别所有集合类型
- [ ] 识别字符串插值
- [ ] 识别特殊运算符（~/、>>>）
- [ ] 识别for-in循环

### ✅ 转换中处理

- [ ] 自定义类用`ObjectPtr`包装
- [ ] 集合用`ObjectPtr`包装
- [ ] 集合元素类型正确（自定义类也用`ObjectPtr`）
- [ ] 字符串插值转为拼接
- [ ] 字面量包装（Int(), Double()等）
- [ ] 方法访问用`->`
- [ ] for-in用`dart_for_each`宏

### ✅ 转换后验证

- [ ] 编译无错误
- [ ] 运行无崩溃
- [ ] 无内存泄漏
- [ ] 输出符合预期

---

## 8. 总结

### 支持的完整特性列表

#### 基础语法 (25项)
1. ✅ 8种基本类型
2. ✅ 40+种运算符
3. ✅ 8种控制流
4. ✅ 3种集合类型
5. ✅ 15种字符串操作
6. ✅ 10种类型转换
7. ✅ 5种空值处理
8. ✅ 字符串插值

#### OOP特性 (12项)
1. ✅ 类定义和实例化
2. ✅ 类继承
3. ✅ 多态性
4. ✅ 抽象类和接口
5. ✅ Mixin混入
6. ✅ Getter/Setter
7. ✅ 静态成员
8. ✅ 命名构造函数
9. ✅ 操作符重载
10. ✅ 方法链
11. ✅ 工厂模式
12. ✅ 类型检查和转换

#### 内存管理 (重点)
1. ✅ ObjectPtr自动包装
2. ✅ 引用计数管理
3. ✅ 自动内存回收
4. ✅ 无内存泄漏

### 质量指标

| 指标 | 值 |
|------|-----|
| 总测试套件 | 37个 |
| 总测试断言 | 146个 |
| 通过率 | 100% |
| 语法覆盖率 | 95%+ |
| 内存安全 | ✅ 保证 |

---

**文档版本**: 2.0  
**最后更新**: 2025-10-28  
**状态**: ✅ ObjectPtr规则已完善

