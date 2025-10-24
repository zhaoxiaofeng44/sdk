# 自定义类与ObjectPtr使用指南

## 概述

本指南说明如何创建自定义类，并通过ObjectPtr包装使用，确保自定义类不能单独实例化，必须通过ObjectPtr管理。

## 基本原则

1. **自定义类必须继承自Object**
2. **构造函数设为private或protected**
3. **提供静态工厂方法返回ObjectPtr**
4. **不能直接实例化，只能通过ObjectPtr使用**

## 基本模式

### 简单自定义类

```cpp
class Counter : public Object {
private:
    Int value_;
    
    // 私有构造函数 - 防止直接实例化
    Counter(const Int& initial) : value_(initial) {
        std::cout << "Counter构造" << std::endl;
    }
    
public:
    // 静态工厂方法 - 返回ObjectPtr
    static ObjectPtr<Counter> create(const Int& initial) {
        return ObjectPtr<Counter>(new Counter(initial));
    }
    
    virtual ~Counter() {
        std::cout << "Counter析构" << std::endl;
    }
    
    // 公共方法
    void increment() {
        value_ = value_ + Int(1);
    }
    
    Int getValue() const { return value_; }
    
    virtual String toString() const override {
        return String("Counter(") + value_.toString() + String(")");
    }
};
```

### 使用方式

```cpp
// 正确：通过工厂方法创建
ObjectPtr<Counter> counter = Counter::create(Int(0));
counter->increment();
std::cout << counter->getValue().toInt() << std::endl;

// 错误：不能直接实例化
// Counter c(Int(0));  // 编译错误：构造函数是私有的
```

## 继承和多态

### 基类设计

```cpp
class Animal : public Object {
private:
    String name_;
    
protected:
    // 受保护的构造函数 - 允许派生类访问
    Animal(const String& name) : name_(name) {}
    
public:
    static ObjectPtr<Animal> create(const String& name) {
        return ObjectPtr<Animal>(new Animal(name));
    }
    
    virtual ~Animal() {}
    
    String getName() const { return name_; }
    
    // 虚方法 - 支持多态
    virtual String makeSound() const {
        return String("Some sound");
    }
    
    virtual String toString() const {
        return String("Animal(") + name_ + String(")");
    }
};
```

### 派生类设计

```cpp
class Dog : public Animal {
private:
    String breed_;
    
    Dog(const String& name, const String& breed)
        : Animal(name), breed_(breed) {}
    
public:
    // 返回Dog类型
    static ObjectPtr<Dog> createDog(const String& name, const String& breed) {
        return ObjectPtr<Dog>(new Dog(name, breed));
    }
    
    // 返回Animal类型（用于多态）
    static ObjectPtr<Animal> create(const String& name, const String& breed) {
        return ObjectPtr<Animal>(new Dog(name, breed));
    }
    
    virtual String makeSound() const override {
        return String("Woof!");
    }
};
```

### 多态使用

```cpp
// 创建不同类型的动物
ObjectPtr<Animal> animal1 = Animal::create(String("Generic"));
ObjectPtr<Animal> animal2 = Dog::create(String("Buddy"), String("Labrador"));

// 多态调用
std::cout << animal1->makeSound().getValue() << std::endl;  // "Some sound"
std::cout << animal2->makeSound().getValue() << std::endl;  // "Woof!"
```

## 对象组合

```cpp
class Person : public Object {
private:
    String name_;
    ObjectPtr<Animal> pet_;  // 组合其他ObjectPtr
    
    Person(const String& name) : name_(name) {}
    
public:
    static ObjectPtr<Person> create(const String& name) {
        return ObjectPtr<Person>(new Person(name));
    }
    
    void setPet(ObjectPtr<Animal> pet) {
        pet_ = pet;
    }
    
    ObjectPtr<Animal> getPet() const {
        return pet_;
    }
};

// 使用
ObjectPtr<Person> person = Person::create(String("Alice"));
ObjectPtr<Animal> dog = Dog::create(String("Max"), String("Beagle"));
person->setPet(dog);
```

## 引用计数

ObjectPtr自动管理引用计数：

```cpp
ObjectPtr<Counter> counter1 = Counter::create(Int(0));
// counter1引用计数 = 1

{
    ObjectPtr<Counter> counter2 = counter1;  // 共享引用
    // counter1和counter2引用计数 = 2
    
    std::cout << counter2->getValue().toInt() << std::endl;
}  // counter2离开作用域，引用计数 - 1

// counter1仍然有效，引用计数 = 1
std::cout << counter1->getValue().toInt() << std::endl;

// main函数结束时，counter1销毁，对象被删除
```

## 与泛型容器结合

### 使用基础类型容器

```cpp
// List<Int> - 已实例化
List<Int> numbers;
numbers.add(Int(1));
numbers.add(Int(2));
numbers.add(Int(3));

numbers.forEach([](const Int& value) {
    std::cout << value.toInt() << std::endl;
});
```

### 使用Map

```cpp
// Map<String, Int> - 已实例化
Map<String, Int> scores;
scores.put(String("Alice"), Int(95));
scores.put(String("Bob"), Int(87));

scores.forEach([](const String& name, const Int& score) {
    std::cout << name.getValue() << ": " << score.toInt() << std::endl;
});
```

## 最佳实践

### 1. 命名约定

```cpp
class MyClass : public Object {
    // 使用create作为工厂方法名
    static ObjectPtr<MyClass> create(...);
};
```

### 2. 构造函数可见性

```cpp
// 简单类 - 使用private
class SimpleClass : public Object {
private:
    SimpleClass() {}
};

// 可继承类 - 使用protected
class BaseClass : public Object {
protected:
    BaseClass() {}
};
```

### 3. 虚析构函数

```cpp
class MyClass : public Object {
public:
    virtual ~MyClass() {  // 总是使用virtual
        // 清理代码
    }
};
```

### 4. toString实现

```cpp
class MyClass : public Object {
public:
    virtual String toString() const override {
        return String("MyClass(...)");
    }
};
```

### 5. 对象比较

```cpp
class MyClass : public Object {
public:
    bool operator==(const MyClass& other) const {
        // 比较逻辑
        return true;
    }
};
```

## 常见模式

### 单例模式

```cpp
class Singleton : public Object {
private:
    static ObjectPtr<Singleton> instance_;
    
    Singleton() {}
    
public:
    static ObjectPtr<Singleton> getInstance() {
        if (instance_.isNull().value) {
            instance_ = ObjectPtr<Singleton>(new Singleton());
        }
        return instance_;
    }
};

ObjectPtr<Singleton> Singleton::instance_;
```

### 工厂模式

```cpp
class ShapeFactory : public Object {
public:
    static ObjectPtr<Shape> createCircle(const Double& radius) {
        return Circle::create(radius);
    }
    
    static ObjectPtr<Shape> createRectangle(const Double& width, const Double& height) {
        return Rectangle::create(width, height);
    }
};
```

### 构建器模式

```cpp
class PersonBuilder : public Object {
private:
    String name_;
    Int age_;
    
    PersonBuilder() : age_(0) {}
    
public:
    static ObjectPtr<PersonBuilder> create() {
        return ObjectPtr<PersonBuilder>(new PersonBuilder());
    }
    
    ObjectPtr<PersonBuilder> setName(const String& name) {
        name_ = name;
        return ObjectPtr<PersonBuilder>(this);  // 返回this用于链式调用
    }
    
    ObjectPtr<PersonBuilder> setAge(const Int& age) {
        age_ = age;
        return ObjectPtr<PersonBuilder>(this);
    }
    
    ObjectPtr<Person> build() {
        return Person::create(name_, age_);
    }
};
```

## 注意事项

### 1. 避免循环引用

```cpp
// 不推荐
class A : public Object {
    ObjectPtr<B> b_;  // A引用B
};

class B : public Object {
    ObjectPtr<A> a_;  // B引用A - 可能导致内存泄漏
};

// 解决方案：使用弱引用或打破循环
```

### 2. 空指针检查

```cpp
ObjectPtr<MyClass> obj;

// 检查是否为空
if (obj.isNull().value) {
    std::cout << "对象为空" << std::endl;
}

// 或
if (obj.isNotNull().value) {
    obj->doSomething();
}
```

### 3. 异常安全

```cpp
try {
    ObjectPtr<MyClass> obj = MyClass::create(...);
    obj->doSomething();
} catch (const std::exception& e) {
    std::cout << "错误: " << e.what() << std::endl;
}
```

## 完整示例

```cpp
#include "object.h"
#include <iostream>

class Counter : public Object {
private:
    Int value_;
    
    Counter(const Int& initial) : value_(initial) {}
    
public:
    static ObjectPtr<Counter> create(const Int& initial) {
        return ObjectPtr<Counter>(new Counter(initial));
    }
    
    virtual ~Counter() {}
    
    void increment() {
        value_ = value_ + Int(1);
    }
    
    Int getValue() const { return value_; }
    
    virtual String toString() const override {
        return String("Counter(") + value_.toString() + String(")");
    }
};

int main() {
    // 创建对象
    ObjectPtr<Counter> counter = Counter::create(Int(0));
    
    // 使用对象
    counter->increment();
    std::cout << counter->getValue().toInt() << std::endl;
    
    // 共享引用
    ObjectPtr<Counter> counter2 = counter;
    counter2->increment();
    
    // 两个引用指向同一对象
    std::cout << counter->getValue().toInt() << std::endl;   // 2
    std::cout << counter2->getValue().toInt() << std::endl;  // 2
    
    return 0;
}
```

## 总结

- ✅ 自定义类必须通过ObjectPtr使用
- ✅ 构造函数私有化防止直接实例化
- ✅ 使用静态工厂方法创建对象
- ✅ 自动引用计数管理内存
- ✅ 支持继承和多态
- ✅ 支持对象组合
- ✅ 与泛型容器良好集成

这种设计确保了内存安全、类型安全和正确的对象生命周期管理。
