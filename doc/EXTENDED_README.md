# 扩展类型系统 - 完整文档

## 项目概述

本项目在原有基础类型系统（Int, Double, Bool, String）的基础上，扩展了完整的面向对象编程语言特性，使其能够支持一个现代编程语言所需的全部基础语法。

## 文件结构

```
pkg/dart2bytecode/base/
├── object.h                 # 基础类型定义（原有）
├── object.cpp               # 基础类型实现（原有）
├── object_extended.h        # 扩展类型定义（新增）
├── object_extended.cpp      # 扩展类型实现（新增）
├── Makefile                 # 编译配置
└── README.md                # 基础说明

test/
└── advanced_test.cpp        # 完整测试用例

doc/
├── advanced_features.md     # 详细特性文档
└── EXTENDED_README.md       # 本文件
```

## 核心设计理念

### 1. 一切皆对象

所有类型都继承自 `Any` 或 `Object` 基类，统一类型系统：

```
Any (基类)
├── Void
├── Int
├── Double  
├── Bool
├── String
├── Object
│   ├── List<T>
│   ├── Map<K,V>
│   ├── Pair<T1,T2>
│   ├── Optional<T>
│   ├── Animal (继承示例)
│   │   ├── Dog
│   │   └── Cat
│   ├── Shape (抽象类示例)
│   │   ├── Circle
│   │   └── Rectangle
│   └── Exception (异常层次)
│       ├── ArgumentException
│       └── StateException
```

### 2. 类型标识

每个类型都有唯一的 `type_id`：
- 0: Void
- 1: Int
- 2: Double
- 3: Bool
- 4: String
- 5: CppUserData / ObjectPtr
- 100: List
- 101: Map
- 200-299: 自定义类（Animal 系列）
- 300-399: 泛型类（Pair, Optional）
- 400-499: 函数对象
- 500-599: 异常类
- 600-699: 形状类

## 支持的语言特性

### 1. 基础类型 ✓

```cpp
Int a(10);
Double b(3.14);
Bool c(true);
String d("Hello");
```

### 2. 运算符重载 ✓

```cpp
Int result = a + Int(20);
Double d = b * Double(2.0);
Bool e = c && Bool(false);
String s = d + String(" World");
```

### 3. 泛型（模板） ✓

```cpp
List<Int> numbers;
Map<String, Int> ages;
Pair<Int, String> keyValue;
Optional<Double> maybeValue;
```

### 4. 继承 ✓

```cpp
class Dog : public Animal {
    // 继承基类成员
    // 添加派生类特有成员
};
```

### 5. 多态 ✓

```cpp
Animal* animal = new Dog(...);
animal->makeSound();  // 调用 Dog 的实现
```

### 6. 虚函数和重写 ✓

```cpp
virtual String makeSound() const;     // 基类声明
String makeSound() const override;     // 派生类重写
```

### 7. 抽象类和纯虚函数 ✓

```cpp
class Shape {
    virtual Double area() const = 0;   // 纯虚函数
};
```

### 8. 接口（通过抽象类） ✓

```cpp
template <typename T>
class Comparable {
    virtual int compareTo(const T& other) const = 0;
};
```

### 9. 异常处理 ✓

```cpp
try {
    throw ArgumentException(String("Error"));
} catch (const Exception& e) {
    // 处理异常
}
```

### 10. 函数对象和 Lambda ✓

```cpp
Function<Int, Int, Int> add([](Int a, Int b) {
    return a + b;
});
```

### 11. 嵌套泛型 ✓

```cpp
List<Pair<String, Int>> scores;
Map<String, List<Int>> groupedData;
List<ObjectPtr<Animal>> polymorphicList;
```

### 12. 智能指针 ✓

```cpp
ObjectPtr<Dog> dog(new Dog(...));
// 自动内存管理，无需手动 delete
```

## 完整示例代码

### 示例 1：基础类型使用

```cpp
#include "object.h"

void basic_types_demo() {
    // 整数运算
    Int a(10), b(20);
    Int sum = a + b;
    Int product = a * b;
    
    // 浮点运算
    Double x(3.14), y(2.0);
    Double result = x * y;
    
    // 布尔运算
    Bool isValid = (a < b) && Bool(true);
    
    // 字符串操作
    String firstName("John");
    String lastName("Doe");
    String fullName = firstName + String(" ") + lastName;
    
    // 字符串方法
    String upper = fullName.toUpperCase();
    int length = fullName.get_length();
    bool contains = fullName.contains(String("John"));
}
```

### 示例 2：泛型容器

```cpp
#include "object_extended.h"

void collections_demo() {
    // List 使用
    List<String> names;
    names.add(String("Alice"));
    names.add(String("Bob"));
    names.add(String("Charlie"));
    
    for (int i = 0; i < names.get_length(); i++) {
        std::cout << names.get(i).toString() << std::endl;
    }
    
    // Map 使用
    Map<String, Int> scores;
    scores.set(String("Alice"), Int(95));
    scores.set(String("Bob"), Int(87));
    
    if (scores.containsKey(String("Alice"))) {
        Int score = scores.get(String("Alice"));
        std::cout << "Alice's score: " << score.toString() << std::endl;
    }
}
```

### 示例 3：继承和多态

```cpp
void polymorphism_demo() {
    // 创建不同类型的动物
    List<ObjectPtr<Animal>> zoo;
    
    zoo.add(ObjectPtr<Animal>(new Dog(String("Buddy"), 3, String("Golden"))));
    zoo.add(ObjectPtr<Animal>(new Cat(String("Whiskers"), 2, true)));
    zoo.add(ObjectPtr<Animal>(new Dog(String("Max"), 5, String("Labrador"))));
    
    // 多态调用
    std::cout << "=== Zoo Animals ===" << std::endl;
    for (int i = 0; i < zoo.get_length(); i++) {
        ObjectPtr<Animal> animal = zoo.get(i);
        std::cout << animal->get_name().toString() << " says: "
                  << animal->makeSound().toString() << std::endl;
    }
}
```

### 示例 4：抽象类

```cpp
void shapes_demo() {
    // 使用抽象类指针
    List<Shape*> shapes;
    
    shapes.add(new Circle(String("red"), 5.0));
    shapes.add(new Rectangle(String("blue"), 4.0, 6.0));
    shapes.add(new Circle(String("green"), 3.0));
    
    std::cout << "=== Shape Areas ===" << std::endl;
    for (int i = 0; i < shapes.get_length(); i++) {
        Shape* shape = shapes.get(i);
        std::cout << shape->getShapeType().toString()
                  << " (" << shape->get_color().toString() << "): "
                  << "Area = " << shape->area().toString()
                  << ", Perimeter = " << shape->perimeter().toString()
                  << std::endl;
    }
    
    // 清理
    for (int i = 0; i < shapes.get_length(); i++) {
        delete shapes.get(i);
    }
}
```

### 示例 5：复杂场景

```cpp
void complex_demo() {
    // 学生成绩管理系统
    
    // 1. 使用 Map 存储学生成绩
    Map<String, List<Int>> studentScores;
    
    List<Int> aliceScores;
    aliceScores.add(Int(95));
    aliceScores.add(Int(87));
    aliceScores.add(Int(92));
    studentScores.set(String("Alice"), aliceScores);
    
    List<Int> bobScores;
    bobScores.add(Int(88));
    bobScores.add(Int(90));
    bobScores.add(Int(85));
    studentScores.set(String("Bob"), bobScores);
    
    // 2. 计算平均分
    if (studentScores.containsKey(String("Alice"))) {
        List<Int> scores = studentScores.get(String("Alice"));
        Int sum(0);
        for (int i = 0; i < scores.get_length(); i++) {
            sum = sum + scores.get(i);
        }
        Double average(sum.toDouble() / scores.get_length());
        std::cout << "Alice's average: " << average.toString() << std::endl;
    }
    
    // 3. 使用 Pair 存储额外信息
    Map<String, Pair<Int, String>> studentInfo;
    studentInfo.set(String("Alice"), 
                    Pair<Int, String>(Int(20), String("Computer Science")));
    
    // 4. 使用 Optional 处理可选值
    Optional<String> bestStudent(String("Alice"));
    if (bestStudent.hasValue()) {
        std::cout << "Best student: " << bestStudent.get().toString() << std::endl;
    }
}
```

## 编译和运行

### 1. 编译基础库

```bash
cd pkg/dart2bytecode/base
g++ -std=c++11 -c object.cpp -o object.o
g++ -std=c++11 -c object_extended.cpp -o object_extended.o
```

### 2. 编译测试程序

```bash
g++ -std=c++11 object.o object_extended.o ../../../test/advanced_test.cpp -o advanced_test
```

### 3. 运行测试

```bash
./advanced_test
```

### 4. 使用 Makefile（推荐）

```bash
cd pkg/dart2bytecode/base
make clean
make all
make test
```

## 性能优化

### 1. 字符串池

String 类使用全局字符串池，相同内容的字符串只存储一次：

```cpp
String s1("Hello");
String s2("Hello");
// s1 和 s2 共享同一个字符串池索引
// 比较只需比较整数索引，O(1) 复杂度
```

### 2. 移动语义

集合类型支持高效的元素移动，避免不必要的拷贝。

### 3. 智能指针

ObjectPtr 实现自动内存管理，避免内存泄漏。

## 测试覆盖

测试程序涵盖以下场景：

1. ✓ 基础类型运算
2. ✓ 字符串操作
3. ✓ List 泛型
4. ✓ Map 泛型  
5. ✓ 继承基本功能
6. ✓ 多态调用
7. ✓ Pair 泛型
8. ✓ Optional 泛型
9. ✓ 嵌套泛型
10. ✓ 抽象类和接口
11. ✓ 异常处理
12. ✓ 函数对象
13. ✓ Math 工具类
14. ✓ 复杂综合场景

## 扩展建议

如需进一步扩展，可以考虑：

1. **迭代器** - 为 List 和 Map 添加迭代器支持
2. **Stream API** - 添加 Java/Dart 风格的 Stream 操作
3. **序列化** - 实现对象序列化/反序列化
4. **反射** - 运行时类型信息和反射
5. **并发** - 线程安全的集合类型
6. **更多容器** - Set, Queue, Stack 等
7. **智能算法** - 排序、搜索等泛型算法

## 总结

本扩展类型系统实现了一个完整的面向对象编程语言所需的核心特性：

- ✅ 基础类型（Int, Double, Bool, String）
- ✅ 泛型/模板（List, Map, Pair, Optional）
- ✅ 继承和多态
- ✅ 抽象类和接口
- ✅ 异常处理
- ✅ 函数对象和 Lambda
- ✅ 智能指针
- ✅ 嵌套泛型
- ✅ 运算符重载
- ✅ 虚函数重写

所有代码都使用这几种基础类型（Int, String, Bool, Double, ObjectPtr）来表达，构建了一个完整且类型安全的语言基础设施。

查看 `doc/advanced_features.md` 获取更详细的 API 文档和使用示例。

