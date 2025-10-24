# 高级语言特性扩展文档

## 概述

本文档描述了对基础类型系统的扩展，使其支持完整的面向对象编程语言特性，包括：

- 泛型（Generics）
- 继承（Inheritance）
- 多态（Polymorphism）
- 抽象类和接口（Abstract Classes and Interfaces）
- 集合类型（Collections）
- 异常处理（Exception Handling）
- 函数对象（Function Objects）

## 1. 基础类型

保持原有的基础类型不变：

- `Int` - 整数类型
- `Double` - 浮点数类型  
- `Bool` - 布尔类型
- `String` - 字符串类型（使用字符串池优化）
- `ObjectPtr<T>` - 对象指针（智能指针）

## 2. 泛型容器

### 2.1 List<T>

泛型列表，支持任意类型元素：

```cpp
List<Int> numbers;
numbers.add(Int(1));
numbers.add(Int(2));
numbers.add(Int(3));

Int first = numbers.get(0);        // 获取元素
int length = numbers.get_length();  // 获取长度
bool isEmpty = numbers.get_isEmpty(); // 判断是否为空
numbers.removeAt(1);                // 删除元素
```

**主要方法：**
- `add(item)` - 添加元素
- `get(index)` - 获取元素
- `set(index, value)` - 设置元素
- `removeAt(index)` - 删除元素
- `contains(item)` - 包含检查
- `indexOf(item)` - 查找索引
- `clear()` - 清空列表

### 2.2 Map<K, V>

泛型键值对容器：

```cpp
Map<String, Int> ages;
ages.set(String("Alice"), Int(30));
ages.set(String("Bob"), Int(25));

Int age = ages.get(String("Alice"));
bool hasKey = ages.containsKey(String("Alice"));
```

**主要方法：**
- `set(key, value)` - 设置键值对
- `get(key)` - 获取值
- `containsKey(key)` - 检查键是否存在
- `remove(key)` - 删除键
- `clear()` - 清空

## 3. 继承和多态

### 3.1 基础继承示例

```cpp
// 基类
class Animal : public Object {
protected:
    String name_;
    Int age_;
    
public:
    Animal(const String& name, int age);
    virtual String makeSound() const;  // 虚函数
    virtual String getType() const;
    String introduce() const;          // 普通方法
};

// 派生类
class Dog : public Animal {
private:
    String breed_;
    
public:
    Dog(const String& name, int age, const String& breed);
    String makeSound() const override;  // 重写虚函数
    String getType() const override;
    String fetch(const String& item) const;  // 特有方法
};

class Cat : public Animal {
private:
    Bool isIndoor_;
    
public:
    Cat(const String& name, int age, bool isIndoor);
    String makeSound() const override;
    String getType() const override;
    String climb() const;  // 特有方法
};
```

### 3.2 多态使用

```cpp
// 通过基类指针实现多态
Animal* animals[3];
animals[0] = new Animal(String("Unknown"), 1);
animals[1] = new Dog(String("Max"), 4, String("Labrador"));
animals[2] = new Cat(String("Mittens"), 3, false);

for (int i = 0; i < 3; i++) {
    // 根据实际类型调用相应的重写方法
    std::cout << animals[i]->makeSound().toString() << std::endl;
}
```

## 4. 抽象类和接口

### 4.1 抽象类 Shape

```cpp
class Shape : public Object {
protected:
    String color_;
    
public:
    Shape(const String& color);
    virtual ~Shape();
    
    // 纯虚函数 - 必须在派生类中实现
    virtual Double area() const = 0;
    virtual Double perimeter() const = 0;
    virtual String getShapeType() const = 0;
    
    // 普通方法
    String describe() const;
};
```

### 4.2 具体实现

```cpp
// 圆形
class Circle : public Shape {
private:
    Double radius_;
    
public:
    Circle(const String& color, double radius);
    
    Double area() const override {
        return Double(3.14159 * radius_.value * radius_.value);
    }
    
    Double perimeter() const override {
        return Double(2 * 3.14159 * radius_.value);
    }
    
    String getShapeType() const override {
        return String("Circle");
    }
};

// 矩形
class Rectangle : public Shape {
private:
    Double width_;
    Double height_;
    
public:
    Rectangle(const String& color, double width, double height);
    
    Double area() const override {
        return width_ * height_;
    }
    
    Double perimeter() const override {
        return Double(2.0) * (width_ + height_);
    }
    
    String getShapeType() const override {
        return String("Rectangle");
    }
};
```

## 5. 泛型类

### 5.1 Pair<T1, T2>

键值对泛型类：

```cpp
Pair<Int, String> p1(Int(42), String("Answer"));
Int first = p1.get_first();
String second = p1.get_second();

// 嵌套泛型
Pair<String, Pair<Int, Double>> nested(
    String("data"),
    Pair<Int, Double>(Int(10), Double(3.14))
);
```

### 5.2 Optional<T>

可选值容器（类似 Nullable）：

```cpp
Optional<Int> opt1(Int(42));        // 有值
Optional<Int> opt2;                 // 无值

if (opt1.hasValue()) {
    Int value = opt1.get();
}

Int result = opt2.getOrDefault(Int(100));  // 使用默认值
```

## 6. 嵌套泛型

支持复杂的嵌套泛型组合：

```cpp
// List 中的 Pair
List<Pair<String, Int>> scores;
scores.add(Pair<String, Int>(String("Alice"), Int(95)));
scores.add(Pair<String, Int>(String("Bob"), Int(87)));

// Map 中的 ObjectPtr
Map<String, ObjectPtr<Dog>> dogs;
dogs.set(String("dog1"), ObjectPtr<Dog>(new Dog(...)));

// List 中的 ObjectPtr
List<ObjectPtr<Animal>> animals;
animals.add(ObjectPtr<Animal>(new Dog(...)));
animals.add(ObjectPtr<Animal>(new Cat(...)));
```

## 7. 异常处理

### 7.1 异常类层次

```cpp
class Exception : public Object {
protected:
    String message_;
public:
    Exception(const String& message);
    String get_message() const;
};

class ArgumentException : public Exception {
    // 参数异常
};

class StateException : public Exception {
    // 状态异常
};
```

### 7.2 使用示例

```cpp
try {
    throw ArgumentException(String("Invalid argument"));
} catch (const ArgumentException& e) {
    std::cout << e.toString() << std::endl;
}

try {
    throw StateException(String("Invalid state"));
} catch (const Exception& e) {
    // 通过基类捕获
    std::cout << e.get_message().toString() << std::endl;
}
```

## 8. 函数对象

### 8.1 Function<R, Args...>

支持函数对象和 Lambda：

```cpp
// 简单函数
Function<Int, Int, Int> add([](Int a, Int b) {
    return a + b;
});

Int result = add.call(Int(10), Int(20));
Int result2 = add(Int(5), Int(15));  // 使用运算符

// 闭包
Int multiplier(3);
Function<Int, Int> multiply([multiplier](Int x) {
    return x * multiplier;
});

Int result3 = multiply(Int(7));  // 返回 21
```

## 9. 工具类

### 9.1 Math 类

提供数学运算：

```cpp
// 最大值和最小值
Int maxInt = Math::max(Int(10), Int(20));
Double maxDouble = Math::max(Double(3.14), Double(2.71));
Int minInt = Math::min(Int(10), Int(20));

// 数学函数
Double sqrt = Math::sqrt(Double(16.0));        // 4.0
Double pow = Math::pow(Double(2.0), Double(3.0));  // 8.0

// 数学常量
Double pi = Math::PI;  // 3.14159...
Double e = Math::E;    // 2.71828...
```

## 10. 完整使用示例

### 10.1 宠物店管理系统

```cpp
// 创建宠物列表（多态）
List<ObjectPtr<Animal>> pets;
pets.add(ObjectPtr<Animal>(new Dog(String("Max"), 5, String("Husky"))));
pets.add(ObjectPtr<Animal>(new Cat(String("Luna"), 3, true)));
pets.add(ObjectPtr<Animal>(new Dog(String("Bella"), 2, String("Beagle"))));

// 遍历并调用多态方法
for (int i = 0; i < pets.get_length(); i++) {
    ObjectPtr<Animal> pet = pets.get(i);
    std::cout << pet->getType().toString() << " - "
              << pet->get_name().toString() << " says: "
              << pet->makeSound().toString() << std::endl;
}

// 使用 Map 存储信息
Map<String, Pair<Int, Double>> petInfo;
petInfo.set(String("Max"), Pair<Int, Double>(Int(5), Double(25.5)));
petInfo.set(String("Luna"), Pair<Int, Double>(Int(3), Double(4.2)));

// 使用 Optional 处理可选值
Optional<String> ownerName(String("John"));
if (ownerName.hasValue()) {
    std::cout << "Owner: " << ownerName.get().toString() << std::endl;
}
```

### 10.2 图形绘制系统

```cpp
// 使用抽象类和接口
Shape* shapes[3];
shapes[0] = new Circle(String("red"), 5.0);
shapes[1] = new Rectangle(String("blue"), 4.0, 6.0);
shapes[2] = new Circle(String("green"), 3.0);

// 多态调用
for (int i = 0; i < 3; i++) {
    std::cout << shapes[i]->describe().toString() << std::endl;
    std::cout << "Area: " << shapes[i]->area().toString() << std::endl;
    std::cout << "Perimeter: " << shapes[i]->perimeter().toString() << std::endl;
}
```

## 11. 语言特性总结

### 支持的特性：

1. **基础类型** - Int, Double, Bool, String
2. **泛型** - List<T>, Map<K,V>, Pair<T1,T2>, Optional<T>
3. **继承** - 单继承，virtual 方法
4. **多态** - 虚函数，override
5. **抽象类** - 纯虚函数（=0）
6. **接口** - 通过抽象类实现
7. **异常** - Exception 类层次
8. **函数对象** - Function<R, Args...>, Lambda
9. **嵌套泛型** - 支持任意嵌套
10. **智能指针** - ObjectPtr<T>

### 类型系统特点：

- 所有类型都继承自 `Any` 或 `Object`
- 使用 `type_id` 进行运行时类型识别
- String 使用字符串池优化内存
- ObjectPtr 实现自动内存管理
- 支持操作符重载
- 支持类型转换

## 12. 编译和测试

### 编译命令：

```bash
cd pkg/dart2bytecode/base
g++ -std=c++11 -c object.cpp object_extended.cpp
g++ -std=c++11 object.o object_extended.o ../../../test/advanced_test.cpp -o advanced_test
./advanced_test
```

### 预期输出：

测试程序将展示所有语言特性的使用示例，包括：
- 基础类型运算
- 泛型容器操作
- 继承和多态
- 抽象类实现
- 异常处理
- 复杂场景应用

所有基础语法和高级特性都通过这些类型和机制实现，构建了一个完整的类型系统框架。

