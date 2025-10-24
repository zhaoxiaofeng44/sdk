# CppUserData 引用计数包装类使用指南

## 概述

`CppUserData` 类现在使用一个专门的引用计数包装类 `RefCountedData` 来管理外部数据指针，提供了更加安全和自动的内存管理机制。

## 架构设计

### RefCountedData 类

`RefCountedData` 是内部包装类，负责：
- 持有实际的数据指针
- 维护引用计数
- 在引用计数为0时自动释放内存

```cpp
class RefCountedData {
private:
  void* data;
  int ref_count;

public:
  RefCountedData(void* external_data);  // 包装外部数据
  RefCountedData(int length);          // 分配新内存
  ~RefCountedData();                   // 释放内存

  void* getData() const;
  int getRefCount() const;
  void increment();                    // 增加引用计数
  void decrement();                    // 减少引用计数，必要时释放
};
```

### CppUserData 类

`CppUserData` 类现在持有一个 `RefCountedData*` 指针，提供了简洁的接口：

```cpp
class CppUserData {
private:
  RefCountedData* ref_data;

public:
  // 构造函数
  CppUserData();                       // 空对象
  CppUserData(void* external_data);    // 持有外部数据
  CppUserData(int length);             // 分配新内存
  CppUserData(const CppUserData& other); // 拷贝构造，共享引用

  // 数据访问
  void* getData() const;
  int getRefCount() const;

  // 不允许赋值操作（避免复杂性）
};
```

## 工作原理

### 引用计数机制

1. **创建对象**：当 `CppUserData` 对象创建时，如果传入外部数据，会创建一个新的 `RefCountedData` 对象，引用计数初始化为1

2. **拷贝构造**：当通过拷贝构造创建新对象时，新对象共享同一个 `RefCountedData` 对象，引用计数+1

3. **析构销毁**：当 `CppUserData` 对象销毁时，调用 `RefCountedData::decrement()`，引用计数-1

4. **自动释放**：当引用计数变为0时，`RefCountedData` 对象自动销毁并释放内存

### 内存管理流程

```
外部数据 ──→ RefCountedData(引用计数=1) ──→ CppUserData 对象1
                      │
                      └───→ CppUserData 对象2（拷贝构造，引用计数=2）
                      │
                      └───→ CppUserData 对象3（拷贝构造，引用计数=3）

当对象1销毁：引用计数=2
当对象2销毁：引用计数=1
当对象3销毁：引用计数=0 → 释放内存
```

## 使用示例

### 基本用法

```cpp
// 1. 持有外部数据
void* external_data = malloc(100);
CppUserData obj1(external_data);  // 引用计数=1
assert(obj1.getRefCount() == 1);

// 2. 拷贝构造，共享数据
CppUserData obj2(obj1);  // 引用计数=2
assert(obj1.getRefCount() == 2);
assert(obj2.getRefCount() == 2);
assert(obj1.getData() == obj2.getData());  // 相同数据

// 3. 自动内存管理
}  // obj2 出作用域，引用计数=1
}  // obj1 出作用域，引用计数=0，自动释放内存
```

### 分配新内存

```cpp
// 分配新内存
CppUserData buffer(1024);  // 分配1024字节
void* data = buffer.getData();

// 使用数据
memset(data, 0, 1024);

// 创建共享副本
CppUserData buffer2(buffer);  // 共享同一内存块

// 内存会在所有持有者销毁时自动释放
```

### 空对象

```cpp
CppUserData empty;  // 创建空对象
assert(empty.getData() == nullptr);
assert(empty.getRefCount() == 0);
```

## 设计优势

### 1. 自动内存管理
- 无需手动调用 `dispose()` 或 `release()`
- 内存泄露防护：只要有对象持有数据，内存就不会被释放
- 悬空指针防护：当最后一个对象销毁时，内存才会被释放

### 2. 零拷贝共享
- 多个 `CppUserData` 对象可以高效共享同一数据
- 引用计数机制确保内存安全
- 拷贝操作只是增加引用计数，性能优异

### 3. 简洁接口
- 删除了复杂的赋值运算符
- 移除了手动内存管理方法
- 只保留必要的数据访问接口

### 4. RAII 兼容
- 完全符合资源获取即初始化（RAII）原则
- 对象生命周期与资源生命周期绑定
- 异常安全：即使发生异常也能正确释放资源

## 限制和注意事项

### 1. 不允许赋值操作
```cpp
CppUserData obj1(data1);
CppUserData obj2(data2);
obj1 = obj2;  // 编译错误！
```

**原因**：赋值操作会引入复杂的引用计数转移逻辑，可能导致意外的内存释放。

**替代方案**：
```cpp
// 使用拷贝构造
CppUserData obj3(obj2);  // 正确方式

// 或者重新构造
obj1 = CppUserData(data2);  // 正确方式
```

### 2. 禁止直接内存操作
`CppUserData` 只在构造时接受外部数据指针，此后不能修改：

```cpp
CppUserData obj(data);
// obj.setData(new_data);  // 编译错误！
```

**原因**：保持引用计数的一致性和简单性。

### 3. 循环引用问题
虽然不考虑循环依赖，但需要注意：

```cpp
// 避免循环引用
struct Node {
    CppUserData data;
    Node* next;  // 不要让 Node 持有 CppUserData
};
```

## 最佳实践

### 1. 使用作用域管理生命周期

```cpp
void processData() {
    void* data = get_external_data();
    {
        CppUserData processor(data);
        // 使用 processor
    }  // 自动释放
}
```

### 2. 利用拷贝构造进行数据传递

```cpp
CppUserData createBuffer() {
    return CppUserData(1024);  // 返回新分配的缓冲区
}

void useBuffer() {
    CppUserData buffer = createBuffer();  // 引用计数=1
    CppUserData backup(buffer);  // 引用计数=2，共享数据
}
```

### 3. 避免不必要的拷贝

```cpp
// 不好的做法
void func(CppUserData data) { /* 使用data */ }
CppUserData large_data = create_large_data();
func(large_data);  // 拷贝构造，开销大

// 好的做法
void func(const CppUserData& data) { /* 使用data.getData() */ }
func(large_data);  // 只传递引用，无拷贝开销
```

### 4. 利用 const 正确性

```cpp
class DataProcessor {
    const CppUserData& data_ref;  // 持有引用，避免拷贝
public:
    DataProcessor(const CppUserData& data) : data_ref(data) {}
    void* getData() const { return data_ref.getData(); }
};
```

## 与旧版本对比

| 特性 | 旧版本 | 新版本 |
|------|--------|--------|
| 内存管理 | 手动（dispose） | 自动（RAII） |
| 赋值操作 | 支持 | 不支持 |
| setData | 支持 | 不支持 |
| 引用计数 | 外部可见 | 内部管理 |
| 异常安全 | 部分 | 完全 |
| 接口复杂度 | 高 | 低 |

## 性能特性

- **内存分配**：只有在创建 `RefCountedData` 时发生
- **拷贝开销**：仅增加引用计数，无内存拷贝
- **销毁开销**：减少引用计数，必要时释放内存
- **线程安全**：引用计数操作非原子，多线程需外部同步

这个新设计提供了更安全、更简单、更高效的外部数据管理方案，完全符合现代C++的资源管理最佳实践。
