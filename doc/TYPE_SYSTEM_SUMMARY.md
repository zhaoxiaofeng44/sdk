# 类型系统总结和使用指南

## 概述

本文档总结了当前类型系统的设计，并提供了使用指南。

## 类型层次结构

```
Any (抽象基类)
├── Int (值类型)
├── Double (值类型)  
├── Bool (值类型)
├── String (值类型)
├── Void (值类型)
└── Object (基类)
    ├── CppUserData (引用计数)
    ├── ObjectPtr<T> (智能指针)
    ├── List<T> (值语义)
    ├── Set<T> (值语义)
    ├── Map<K,V> (值语义)
    └── CustomClass (必须通过ObjectPtr)
```

## 设计原则

### 1. 基础类型 - 值语义（推荐直接使用）

**类型**: Int, Double, Bool, String

**特点**:
- 轻量级
- 栈上分配
- 值拷贝
- 无需内存管理

**使用方式**:
```cpp
Int a = Int(10);
Double d = Double(3.14);
Bool b = Bool(true);
String s = String("hello");

// 运算
Int sum = a + Int(20);
String greeting = s + String(" world");
```

**何时使用**: 
- ✅ 所有基础数据操作
- ✅ 函数参数和返回值
- ✅ 临时变量
- ✅ 结构体/类的成员变量

### 2. 容器类型 - 值语义（默认方式）

**类型**: List<T>, Set<T>, Map<K,V>

**特点**:
- 封装了C++标准容器
- 值拷贝
- 自动内存管理
- 适合局部使用

**使用方式**:
```cpp
// 创建和使用
List<Int> numbers;
numbers.add(Int(1));
numbers.add(Int(2));

Set<String> names;
names.add(String("Alice"));

Map<String, Int> scores;
scores.put(String("Bob"), Int(95));

// 遍历
numbers.forEach([](const Int& n) {
    std::cout << n.toInt() << std::endl;
});
```

**何时使用**:
- ✅ 局部数据结构
- ✅ 函数内临时集合
- ✅ 不需要共享的数据
- ✅ 短生命周期

**优点**:
- 简单直观
- 自动释放
- 无引用计数开销

**缺点**:
- 拷贝代价高（大容器）
- 不能共享

### 3. 容器类型 - 引用语义（可选方式）

**未来扩展**: 可以添加工厂方法支持

```cpp
// 未来可能的API
ObjectPtr<List<Int>> list = List<Int>::create();
list->add(Int(1));

ObjectPtr<Set<String>> set = Set<String>::create();
set->add(String("value"));

ObjectPtr<Map<String, Int>> map = Map<String, Int>::create();
map->put(String("key"), Int(42));
```

**何时使用**（未来）:
- 需要共享容器
- 长生命周期
- 避免大对象拷贝
- 多处引用同一数据

### 4. 自定义类 - 强制引用语义（ObjectPtr）

**特点**:
- 必须通过ObjectPtr使用
- 构造函数私有化
- 静态工厂方法创建
- 自动引用计数

**定义方式**:
```cpp
class MyClass : public Object {
private:
    String name_;
    Int value_;
    
    // 私有构造函数
    MyClass(const String& name, const Int& value) 
        : name_(name), value_(value) {}
    
public:
    // 静态工厂方法
    static ObjectPtr<MyClass> create(const String& name, const Int& value) {
        return ObjectPtr<MyClass>(new MyClass(name, value));
    }
    
    virtual ~MyClass() {}
    
    // 公共方法
    String getName() const { return name_; }
    Int getValue() const { return value_; }
    
    virtual String toString() const override {
        return String("MyClass(") + name_ + String(")");
    }
};
```

**使用方式**:
```cpp
// 创建
ObjectPtr<MyClass> obj = MyClass::create(String("test"), Int(42));

// 使用
std::cout << obj->getName().getValue() << std::endl;
std::cout << obj->getValue().toInt() << std::endl;

// 共享
ObjectPtr<MyClass> obj2 = obj;  // 引用计数增加
```

**何时使用**:
- ✅ 所有自定义类
- ✅ 复杂对象
- ✅ 需要共享的对象
- ✅ 多态对象

## 使用场景对比

### 场景1: 简单数据处理

```cpp
void processNumbers() {
    List<Int> numbers;
    for (int i = 0; i < 10; i++) {
        numbers.add(Int(i));
    }
    
    Int sum(0);
    numbers.forEach([&sum](const Int& n) {
        sum = sum + n;
    });
    
    std::cout << "Sum: " << sum.toInt() << std::endl;
}
// ✅ 使用值语义的List，简单直观
```

### 场景2: 共享数据结构（未来）

```cpp
class DataManager {
private:
    ObjectPtr<List<Int>> sharedData_;
    
public:
    void setData(ObjectPtr<List<Int>> data) {
        sharedData_ = data;  // 共享引用
    }
    
    ObjectPtr<List<Int>> getData() {
        return sharedData_;  // 返回共享引用
    }
};
// ✅ 使用ObjectPtr包装的List，支持共享
```

### 场景3: 自定义对象

```cpp
class Person : public Object {
private:
    String name_;
    Int age_;
    List<String> hobbies_;  // 成员可以是值类型容器
    
    Person(const String& name, const Int& age)
        : name_(name), age_(age) {}
        
public:
    static ObjectPtr<Person> create(const String& name, const Int& age) {
        return ObjectPtr<Person>(new Person(name, age));
    }
    
    void addHobby(const String& hobby) {
        hobbies_.add(hobby);
    }
};

// 使用
ObjectPtr<Person> person = Person::create(String("Alice"), Int(25));
person->addHobby(String("Reading"));
// ✅ 自定义类强制使用ObjectPtr
```

### 场景4: 对象组合

```cpp
class Company : public Object {
private:
    String name_;
    List<ObjectPtr<Person>> employees_;  // 容器内可以存ObjectPtr
    
    Company(const String& name) : name_(name) {}
    
public:
    static ObjectPtr<Company> create(const String& name) {
        return ObjectPtr<Company>(new Company(name));
    }
    
    void addEmployee(ObjectPtr<Person> person) {
        employees_.add(person);
    }
};
// ✅ 组合：值语义容器 + ObjectPtr元素
```

## API使用规则总结

### ✅ 推荐的用法

```cpp
// 1. 基础类型 - 直接使用
Int x = Int(10);
String s = String("hello");

// 2. 容器类型 - 局部值语义
List<Int> list;
list.add(Int(1));

// 3. 自定义类 - ObjectPtr
ObjectPtr<MyClass> obj = MyClass::create(...);
obj->doSomething();

// 4. 容器存储ObjectPtr
List<ObjectPtr<MyClass>> objects;
objects.add(MyClass::create(...));
```

### ❌ 避免的用法

```cpp
// 1. 不要直接实例化自定义类
// MyClass obj;  // 编译错误：构造函数是私有的

// 2. 不要对基础类型使用ObjectPtr
// ObjectPtr<Int> x = ...;  // 不推荐，过度使用

// 3. 不要混淆值语义和引用语义
// List<Int> list1;
// ObjectPtr<List<Int>> list2 = &list1;  // 错误！
```

## 性能考虑

### 值语义的优势
- 栈上分配，速度快
- 无引用计数开销
- 缓存友好
- 适合小对象和短生命周期

### ObjectPtr的优势
- 避免大对象拷贝
- 支持共享和多态
- 自动内存管理
- 适合复杂对象和长生命周期

### 选择建议

| 场景 | 推荐方式 | 原因 |
|------|---------|------|
| 基础数值计算 | 值语义 | 轻量，快速 |
| 临时容器 | 值语义 | 简单，自动清理 |
| 共享容器 | ObjectPtr | 避免拷贝 |
| 自定义类 | ObjectPtr | 安全，多态 |
| 函数参数（小） | 值传递/const引用 | 高效 |
| 函数参数（大） | const引用/ObjectPtr | 避免拷贝 |
| 函数返回值 | 看情况 | 小对象值，大对象ObjectPtr |

## 迁移指南

如果未来需要将容器改为强制使用ObjectPtr：

### 步骤1: 添加工厂方法

```cpp
template <typename T>
class List : public Object {
private:
    List() {}  // 私有化
    
public:
    static ObjectPtr<List<T>> create() {
        return ObjectPtr<List<T>>(new List<T>());
    }
};
```

### 步骤2: 更新使用代码

```cpp
// 旧代码
List<Int> list;
list.add(Int(1));

// 新代码
ObjectPtr<List<Int>> list = List<Int>::create();
list->add(Int(1));
```

### 步骤3: 处理模板实例化

需要显式实例化常用类型：
```cpp
// 在object.cpp中
template class List<Int>;
template class List<String>;
template class Set<String>;
template class Map<String, Int>;
```

## 当前状态

**已实现**:
- ✅ 基础类型值语义
- ✅ 容器类型值语义（默认）
- ✅ 自定义类ObjectPtr（强制）
- ✅ ObjectPtr引用计数
- ✅ 迭代器包装
- ✅ 完整测试用例

**未来可选**:
- ⏳ 容器类型ObjectPtr（可选）
- ⏳ 统一工厂方法
- ⏳ 更多便利API

## 结论

当前设计采用**混合模式**，平衡了易用性和安全性：

1. **基础类型** - 值语义，轻量高效
2. **容器类型** - 值语义（默认），灵活易用
3. **自定义类** - ObjectPtr（强制），内存安全

这种设计既保证了性能，又提供了安全性，是实用的最佳实践。

## 相关文档

- `doc/CUSTOM_CLASS_GUIDE.md` - 自定义类使用指南
- `doc/ITERATOR_GUIDE.md` - 迭代器使用指南
- `doc/OBJECTPTR_REFACTOR_PLAN.md` - 重构计划
- `test/simple_custom_class_test.cpp` - 简单示例
- `test/oop_comprehensive_test_base.cpp` - 完整OOP测试
