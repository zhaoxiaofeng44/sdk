# ObjectPtr 引用计数包装类使用指南

## 概述

`ObjectPtr<T>` 模板类现在使用一个专门的引用计数包装类 `RefCountedPtr<T>` 来管理动态分配的对象指针，提供了更加安全和自动的内存管理机制。

## 架构设计

### RefCountedPtr<T> 类

`RefCountedPtr<T>` 是通用模板包装类，负责：
- 持有类型为 `T` 的对象指针
- 维护引用计数
- 在引用计数为0时自动释放内存

```cpp
template <typename T>
class RefCountedPtr {
private:
  T* ptr;
  int ref_count;

public:
  RefCountedPtr(T* p = nullptr);     // 构造，引用计数=1
  ~RefCountedPtr();                  // 析构，释放内存

  T* getPtr() const;                 // 获取指针
  int getRefCount() const;           // 获取引用计数

  void increment();                  // 增加引用计数
  void decrement();                  // 减少引用计数，必要时释放
};
```

### ObjectPtr<T> 类

`ObjectPtr<T>` 类持有一个 `RefCountedPtr<T>*` 指针，提供了智能指针接口：

```cpp
template <typename T>
class ObjectPtr {
private:
  RefCountedPtr<T>* ref_ptr;

public:
  // 构造函数
  ObjectPtr();                       // 空指针
  ObjectPtr(T* p);                   // 持有外部对象
  ObjectPtr(const ObjectPtr& other); // 拷贝构造，共享引用

  // 析构函数
  ~ObjectPtr();

  // 赋值运算符
  ObjectPtr& operator=(const ObjectPtr& other);

  // 访问运算符
  T* operator->();
  const T* operator->() const;
  T& operator*();
  const T& operator*() const;

  // 状态查询
  Bool isNull() const;
  Bool isNotNull() const;

  // 指针访问
  T* get();
  const T* get() const;

  // 指针设置
  void set(T* p);
};
```

## 工作原理

### 引用计数机制

1. **创建对象**：当 `ObjectPtr` 对象创建时，如果传入外部对象指针，会创建一个新的 `RefCountedPtr` 对象，引用计数初始化为1

2. **拷贝构造**：当通过拷贝构造创建新对象时，新对象共享同一个 `RefCountedPtr` 对象，引用计数+1

3. **赋值操作**：赋值操作会转移引用计数，原对象的引用计数-1，新对象的引用计数+1

4. **析构销毁**：当 `ObjectPtr` 对象销毁时，调用 `RefCountedPtr::decrement()`，引用计数-1

5. **自动释放**：当引用计数变为0时，`RefCountedPtr` 对象自动销毁并释放内存

### 内存管理流程

```
外部对象 ──→ RefCountedPtr(引用计数=1) ──→ ObjectPtr 对象1
                    │
                    └───→ ObjectPtr 对象2（拷贝构造，引用计数=2）
                    │
                    └───→ ObjectPtr 对象3（拷贝构造，引用计数=3）

当对象1销毁：引用计数=2
当对象2销毁：引用计数=1
当对象3销毁：引用计数=0 → 释放内存
```

## 使用示例

### 基本用法

```cpp
// 1. 创建空指针
ObjectPtr<MyClass> ptr1;
assert(ptr1.isNull().value == true);

// 2. 持有外部对象
MyClass* obj = new MyClass();
ObjectPtr<MyClass> ptr2(obj);
assert(ptr2.isNotNull().value == true);
assert(ptr2.get() == obj);

// 3. 使用智能指针
ptr2->doSomething();  // 通过 operator-> 访问
(*ptr2).doSomething(); // 通过 operator* 访问
```

### 拷贝和共享

```cpp
MyClass* obj = new MyClass();
ObjectPtr<MyClass> ptr1(obj);

// 拷贝构造，共享同一对象
ObjectPtr<MyClass> ptr2(ptr1);
assert(ptr1.get() == ptr2.get());  // 相同对象

// 修改一个，所有共享者可见
ptr1->setValue(42);
assert(ptr2->getValue() == 42);  // 共享状态
```

### 赋值操作

```cpp
MyClass* obj1 = new MyClass();
MyClass* obj2 = new MyClass();

ObjectPtr<MyClass> ptr1(obj1);
ObjectPtr<MyClass> ptr2(obj2);

// 赋值操作转移引用
ptr1 = ptr2;
assert(ptr1.get() == obj2);  // ptr1 现在指向 obj2
assert(ptr2.get() == obj2);  // ptr2 仍然指向 obj2
// obj1 已经被释放
```

### 指针重置

```cpp
ObjectPtr<MyClass> ptr(obj);

// 重置为新对象
MyClass* newObj = new MyClass();
ptr.set(newObj);

// 重置为空
ptr.set(nullptr);
assert(ptr.isNull().value == true);
```

## 设计优势

### 1. 自动内存管理
- 无需手动调用 `delete`
- 内存泄露防护：引用计数确保对象被正确释放
- 悬空指针防护：当最后一个引用销毁时，内存才释放

### 2. 零拷贝共享
- 多个 `ObjectPtr` 对象可以高效共享同一对象
- 引用计数机制确保内存安全
- 拷贝操作只是增加引用计数，性能优异

### 3. RAII 兼容
- 完全符合资源获取即初始化（RAII）原则
- 对象生命周期与资源生命周期绑定
- 异常安全：即使发生异常也能正确释放资源

### 4. 类型安全
- 模板参数确保类型安全
- 编译时类型检查
- 避免了 `void*` 的类型转换问题

## 模板类型要求

使用 `ObjectPtr<T>` 时，类型 `T` 需要满足以下要求：

1. **可拷贝构造**：`T` 必须支持拷贝构造函数
2. **可赋值**：`T` 必须支持赋值运算符（用于比较）
3. **可比较**：如果需要使用 `operator==`，`T` 需要定义 `operator==`

```cpp
class MyClass {
public:
  MyClass(const MyClass& other);     // 必需
  MyClass& operator=(const MyClass& other);  // 推荐
  bool operator==(const MyClass& other) const;  // 如果需要比较
};
```

## 与原始指针对比

| 特性 | 原始指针 | ObjectPtr |
|------|----------|-----------|
| 内存管理 | 手动 | 自动 |
| 引用计数 | 无 | 有 |
| 拷贝开销 | 无 | 引用计数操作 |
| 异常安全 | 否 | 是 |
| 悬空指针 | 可能 | 防护 |
| 接口 | 简单 | 丰富 |

## 最佳实践

### 1. 使用 RAII 模式

```cpp
void processData() {
    MyClass* data = getExpensiveData();
    ObjectPtr<MyClass> ptr(data);  // 自动管理生命周期

    // 使用 ptr，无需担心释放
    ptr->process();

}  // ptr 出作用域，自动释放 data
```

### 2. 利用引用语义

```cpp
ObjectPtr<MyClass> createObject() {
    return ObjectPtr<MyClass>(new MyClass());  // 返回智能指针
}

void useObject() {
    ObjectPtr<MyClass> obj = createObject();  // 引用计数=1
    ObjectPtr<MyClass> backup(obj);           // 引用计数=2，共享对象

    // 两个指针共享同一对象，无拷贝开销
}
```

### 3. 避免循环引用

```cpp
// 不好的做法 - 可能导致循环引用
struct Node {
    ObjectPtr<Node> next;  // 避免这种设计
    // ...
};

// 好的做法
struct Node {
    Node* next;  // 使用原始指针
    // ...
};
```

### 4. 利用 const 正确性

```cpp
class DataProcessor {
    const ObjectPtr<MyClass>& data_ref;  // 引用，避免拷贝
public:
    DataProcessor(const ObjectPtr<MyClass>& data) : data_ref(data) {}
    void process() const { data_ref->process(); }
};
```

## 性能特性

- **内存分配**：只有在创建 `RefCountedPtr` 时发生
- **拷贝开销**：仅引用计数操作，无对象拷贝
- **销毁开销**：减少引用计数，必要时释放内存
- **线程安全**：引用计数操作非原子，多线程需外部同步

## 调试支持

### toString 方法

```cpp
ObjectPtr<MyClass> ptr(obj);
String str = ptr.toString();
// 返回 "Object"（非空）或 "null"（空指针）
```

### 引用计数查询

```cpp
// 注意：这是一个实现细节，通常不需要直接使用
// 但在调试时可能有用
```

这个新设计为 `ObjectPtr` 提供了与现代C++智能指针类似的安全性和便利性，同时保持了原有接口的兼容性。
