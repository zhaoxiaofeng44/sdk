# ObjectPtr 包装规则和最佳实践

## 概述

在Dart到C++的转换中，正确使用`ObjectPtr`包装自定义类是确保内存安全和自动管理的关键。

---

## 1. 核心规则

### 规则1: 所有自定义类必须使用ObjectPtr包装

**原因**: 自定义类继承自`Object`，使用引用计数管理内存

✅ **正确**:
```cpp
// Dart: var person = Person("Alice", 25);
ObjectPtr<Person> person(new Person(String("Alice"), Int(25)));
```

❌ **错误**:
```cpp
// 裸指针 - 需要手动delete，容易泄漏
Person* person = new Person(String("Alice"), Int(25));
// ... 忘记 delete person;
```

### 规则2: 基本包装类型不需要ObjectPtr

**原因**: `Int`, `Double`, `Bool`, `String`是值类型，可以直接使用

✅ **正确**:
```cpp
Int x = Int(5);
String name = String("Alice");
```

❌ **错误（过度包装）**:
```cpp
ObjectPtr<Int> x(new Int(5));  // 不需要
ObjectPtr<String> name(new String("Alice"));  // 不需要
```

### 规则3: 集合类型始终使用ObjectPtr

**原因**: `List`, `Set`, `Map`继承自`Object`，管理堆上的数据

✅ **正确**:
```cpp
ObjectPtr<List<Int>> numbers = List<Int>::create();
ObjectPtr<Set<String>> names = Set<String>::create();
ObjectPtr<Map<String, Int>> ages = Map<String, Int>::create();
```

### 规则4: 集合的元素类型根据情况包装

**基本类型元素 - 不需要包装**:
```cpp
// Dart: List<int> numbers = [];
ObjectPtr<List<Int>> numbers = List<Int>::create();
```

**自定义类型元素 - 需要包装**:
```cpp
// Dart: List<Person> people = [];
ObjectPtr<List<ObjectPtr<Person>>> people = List<ObjectPtr<Person>>::create();
people->add(ObjectPtr<Person>(new Person(String("Alice"), Int(25))));
```

---

## 2. 详细规则表

| Dart类型 | C++类型 | 是否需要ObjectPtr | 示例 |
|---------|--------|------------------|------|
| `int` | `Int` | ❌ 否 | `Int x(5);` |
| `double` | `Double` | ❌ 否 | `Double d(3.14);` |
| `bool` | `Bool` | ❌ 否 | `Bool b(true);` |
| `String` | `String` | ❌ 否 | `String s("hi");` |
| `List<T>` | `List<T>` | ✅ 是 | `ObjectPtr<List<Int>>` |
| `Set<T>` | `Set<T>` | ✅ 是 | `ObjectPtr<Set<String>>` |
| `Map<K,V>` | `Map<K,V>` | ✅ 是 | `ObjectPtr<Map<String,Int>>` |
| 自定义类 | 自定义类 | ✅ 是 | `ObjectPtr<Person>` |

---

## 3. 转换模式

### 模式1: 简单对象创建

**Dart:**
```dart
var person = Person("Alice", 25);
person.introduce();
```

**C++ (正确):**
```cpp
ObjectPtr<Person> person(new Person(String("Alice"), Int(25)));
person->introduce();
```

**注意**: 使用`->`访问成员

### 模式2: 多态对象

**Dart:**
```dart
Animal animal = Dog("Buddy");
print(animal.makeSound());
```

**C++ (正确):**
```cpp
ObjectPtr<Animal> animal(new Dog(String("Buddy")));
dart_print(animal->makeSound());
```

### 模式3: 对象集合

**Dart:**
```dart
List<Person> people = [];
people.add(Person("Alice", 25));
people.add(Person("Bob", 30));
```

**C++ (正确):**
```cpp
ObjectPtr<List<ObjectPtr<Person>>> people = List<ObjectPtr<Person>>::create();
people->add(ObjectPtr<Person>(new Person(String("Alice"), Int(25))));
people->add(ObjectPtr<Person>(new Person(String("Bob"), Int(30))));
```

### 模式4: 命名构造函数/工厂方法

**Dart:**
```dart
class Point {
  double x, y;
  Point(this.x, this.y);
  Point.origin() : x = 0, y = 0;
}

var p1 = Point(3.0, 4.0);
var p2 = Point.origin();
```

**C++ (正确):**
```cpp
class Point : public Object {
public:
    Double x, y;
    
    Point(const Double& x_val, const Double& y_val) : x(x_val), y(y_val) {}
    
    static ObjectPtr<Point> origin() {
        return ObjectPtr<Point>(new Point(Double(0.0), Double(0.0)));
    }
};

ObjectPtr<Point> p1(new Point(Double(3.0), Double(4.0)));
ObjectPtr<Point> p2 = Point::origin();
```

### 模式5: 值类型（不需要ObjectPtr）

对于某些小型数据类或纯计算类，可以作为值类型使用：

**Dart:**
```dart
class Vector {
  double x, y;
  Vector(this.x, this.y);
  Vector operator +(Vector other) => Vector(x + other.x, y + other.y);
}

var v1 = Vector(1.0, 2.0);
var v2 = Vector(3.0, 4.0);
var v3 = v1 + v2;
```

**C++ (值类型):**
```cpp
class Vector : public Object {
public:
    Double x, y;
    
    Vector(const Double& x_val, const Double& y_val) : x(x_val), y(y_val) {}
    
    Vector operator+(const Vector& other) const {
        return Vector(x + other.x, y + other.y);
    }
};

// 作为值类型使用（栈上分配）
Vector v1(Double(1.0), Double(2.0));
Vector v2(Double(3.0), Double(4.0));
Vector v3 = v1 + v2;
```

**何时使用值类型**:
- 小型数据结构
- 不需要多态
- 频繁创建和销毁
- 纯计算类

---

## 4. 引用计数示例

### 示例1: 自动内存管理

```cpp
void example() {
    ObjectPtr<Person> person1(new Person(String("Alice"), Int(25)));
    // person1的引用计数: 1
    
    ObjectPtr<Person> person2 = person1;
    // person1的引用计数: 2
    
    {
        ObjectPtr<Person> person3 = person1;
        // person1的引用计数: 3
    }
    // person3离开作用域，引用计数: 2
    
} // person1和person2离开作用域，引用计数归零，自动delete对象
```

### 示例2: 避免内存泄漏

❌ **错误（裸指针容易泄漏）**:
```cpp
void bad_example() {
    Person* person = new Person(String("Alice"), Int(25));
    // ... 使用 person ...
    // 忘记 delete person; ← 内存泄漏！
}
```

✅ **正确（ObjectPtr自动管理）**:
```cpp
void good_example() {
    ObjectPtr<Person> person(new Person(String("Alice"), Int(25)));
    // ... 使用 person ...
} // 作用域结束，自动delete，无泄漏
```

---

## 5. 类定义规范

### 规范1: 类必须继承Object

**Dart:**
```dart
class MyClass {
  // ...
}
```

**C++:**
```cpp
class MyClass : public Object {
public:
    MyClass() {
        type_id = 200;  // 可选的类型标识
    }
    
    String toString() const override {
        return String("MyClass()");
    }
};
```

### 规范2: 构造函数使用const引用

✅ **推荐**:
```cpp
class Person : public Object {
public:
    Person(const String& name, const Int& age) : name_(name), age_(age) {}
};
```

❌ **不推荐**:
```cpp
class Person : public Object {
public:
    Person(String name, Int age) : name_(name), age_(age) {}  // 会拷贝
};
```

### 规范3: 实现toString()方法

✅ **推荐**:
```cpp
class Person : public Object {
public:
    String toString() const override {
        return String("Person(") + name_ + String(", ") + age_.toString() + String(")");
    }
};
```

---

## 6. 常见错误和解决方案

### 错误1: 忘记使用ObjectPtr

❌ **错误**:
```cpp
Person* person = new Person(String("Alice"), Int(25));
people_list->add(person);  // 类型不匹配
delete person;
```

✅ **正确**:
```cpp
ObjectPtr<Person> person(new Person(String("Alice"), Int(25)));
people_list->add(person);  // OK
// 自动管理，无需delete
```

### 错误2: 使用`.`而非`->`访问成员

❌ **错误**:
```cpp
ObjectPtr<Person> person(new Person(String("Alice"), Int(25)));
person.introduce();  // 编译错误
```

✅ **正确**:
```cpp
ObjectPtr<Person> person(new Person(String("Alice"), Int(25)));
person->introduce();  // 正确
```

### 错误3: 集合元素类型不匹配

❌ **错误**:
```cpp
ObjectPtr<List<Person>> people = List<Person>::create();  // 错误
people->add(Person(String("Alice"), Int(25)));  // 不匹配
```

✅ **正确**:
```cpp
ObjectPtr<List<ObjectPtr<Person>>> people = List<ObjectPtr<Person>>::create();
people->add(ObjectPtr<Person>(new Person(String("Alice"), Int(25))));
```

---

## 7. 完整示例对照

### 示例: 综合使用

**Dart代码:**
```dart
class Student {
  String name;
  int age;
  List<int> scores;
  
  Student(this.name, this.age, this.scores);
  
  double getAverage() {
    if (scores.isEmpty) return 0.0;
    var sum = 0;
    for (var score in scores) {
      sum += score;
    }
    return sum / scores.length;
  }
}

void main() {
  var student = Student("Alice", 20, [85, 90, 88]);
  print("Average: ${student.getAverage()}");
  
  List<Student> students = [];
  students.add(Student("Bob", 21, [78, 82, 80]));
  
  for (var s in students) {
    print("${s.name}: ${s.getAverage()}");
  }
}
```

**C++代码（正确转换）:**
```cpp
class Student : public Object {
public:
    String name;
    Int age;
    ObjectPtr<List<Int>> scores;  // 集合成员用ObjectPtr
    
    Student(const String& n, const Int& a, const ObjectPtr<List<Int>>& s) 
        : name(n), age(a), scores(s) {
        type_id = 201;
    }
    
    Double getAverage() {
        if (scores->isEmpty()) {
            return Double(0.0);
        }
        
        Int sum(0);
        dart_for_each(Int, score, scores)
            sum += score;
        dart_end_for
        
        return sum.toDouble() / Double(scores->size().toInt());
    }
    
    String toString() const override {
        return String("Student(") + name + String(", ") + age.toString() + String(")");
    }
};

int main() {
    // 创建分数列表
    ObjectPtr<List<Int>> scores = List<Int>::create();
    scores->add(Int(85));
    scores->add(Int(90));
    scores->add(Int(88));
    
    // 创建学生对象（使用ObjectPtr）
    ObjectPtr<Student> student(new Student(String("Alice"), Int(20), scores));
    
    dart_print(String("Average: ") + student->getAverage().toString());
    
    // 学生列表（ObjectPtr套ObjectPtr）
    ObjectPtr<List<ObjectPtr<Student>>> students = List<ObjectPtr<Student>>::create();
    
    ObjectPtr<List<Int>> bobScores = List<Int>::create();
    bobScores->add(Int(78));
    bobScores->add(Int(82));
    bobScores->add(Int(80));
    
    students->add(ObjectPtr<Student>(new Student(String("Bob"), Int(21), bobScores)));
    
    // 遍历
    dart_for_each(ObjectPtr<Student>, s, students)
        dart_print(s->name + String(": ") + s->getAverage().toString());
    dart_end_for
    
    return 0;
}
```

---

## 8. 类型判断流程图

```
类型T
  │
  ├─ 是基本包装类型？(Int, Double, Bool, String)
  │    └─ 是 → 直接使用: T variable
  │
  ├─ 是集合类型？(List, Set, Map)
  │    └─ 是 → 使用ObjectPtr: ObjectPtr<T>
  │
  └─ 是自定义类？
       └─ 是 → 检查用途
            ├─ 作为对象使用 → ObjectPtr<T>
            └─ 作为值类型（小型数据结构）→ T variable
```

---

## 9. 快速检查清单

转换Dart代码时，检查以下项：

- [ ] 所有自定义类实例使用`ObjectPtr`包装
- [ ] 所有集合（List/Set/Map）使用`ObjectPtr`包装
- [ ] 基本类型（Int/Double/Bool/String）不使用`ObjectPtr`
- [ ] 集合元素类型正确（自定义类用`ObjectPtr<CustomClass>`）
- [ ] 访问ObjectPtr成员使用`->`而非`.`
- [ ] 类定义继承自`Object`
- [ ] 实现了`toString()`方法
- [ ] 设置了`type_id`（可选但推荐）

---

## 10. 性能考虑

### 值类型 vs ObjectPtr

**值类型（栈上分配）**:
- ✅ 更快的创建和销毁
- ✅ 无需堆分配
- ✅ 更好的内存局部性
- ❌ 不支持多态
- ❌ 拷贝开销可能较大

**ObjectPtr（堆上分配）**:
- ✅ 支持多态
- ✅ 自动内存管理
- ✅ 共享对象（引用计数）
- ❌ 堆分配开销
- ❌ 额外的引用计数开销

### 选择建议

**使用值类型**:
- 小型数据结构（Vector, Point等）
- 纯计算类
- 不需要多态
- 频繁创建销毁

**使用ObjectPtr**:
- 需要多态
- 大型对象
- 需要共享
- 作为函数参数传递
- 存储在集合中

---

## 11. 高级用法

### 用法1: 工厂方法返回ObjectPtr

✅ **推荐**:
```cpp
class Logger : public Object {
public:
    static ObjectPtr<Logger> createConsole() {
        return ObjectPtr<Logger>(new ConsoleLogger());
    }
    
    static ObjectPtr<Logger> createFile() {
        return ObjectPtr<Logger>(new FileLogger());
    }
};
```

### 用法2: 函数参数使用const引用

✅ **推荐**:
```cpp
void processPerson(const ObjectPtr<Person>& person) {
    dart_print(person->introduce());
}
```

❌ **不推荐**:
```cpp
void processPerson(ObjectPtr<Person> person) {  // 会增加引用计数
    dart_print(person->introduce());
}
```

### 用法3: 函数返回ObjectPtr

✅ **推荐**:
```cpp
ObjectPtr<Person> createPerson(const String& name, const Int& age) {
    return ObjectPtr<Person>(new Person(name, age));
}
```

---

## 12. 总结

### 核心要点

1. **自定义类 → ObjectPtr包装**
2. **基本类型 → 直接使用**
3. **集合类型 → ObjectPtr包装**
4. **集合元素 → 根据元素类型决定**

### 记忆口诀

> **Object派生用指针，基本类型是值型**  
> **集合必定要包装，元素跟随其类型**

### 检验方法

✅ 正确的代码特征：
- 没有裸的`new`和`delete`（除了ObjectPtr构造）
- 自定义类总是`ObjectPtr<CustomClass>`
- 基本类型总是`Int`, `Double`, `Bool`, `String`
- 集合总是`ObjectPtr<List<...>>`等

❌ 错误的代码特征：
- 出现`Person* p = new Person(...); delete p;`
- 出现`ObjectPtr<Int>(new Int(5))`（过度包装）
- 集合不用ObjectPtr: `List<Int> list`
- 忘记->: `person.introduce()`

---

**参考文档**: 查看`test/dart_oop_conversion_tests.cpp`了解完整的正确用法示例

