# CppUserData 引用计数使用指南

## 概述

`CppUserData` 类现在使用引用计数来管理外部匿名指针 `data`，避免了内存泄露和悬空指针的问题。

## 主要特性

1. **自动引用计数管理**：构造函数、拷贝构造函数和赋值运算符会自动管理引用计数
2. **手动内存管理**：提供 `dispose()` 方法用于手动释放内存
3. **引用计数查询**：可以查询当前引用计数
4. **线程安全考虑**：引用计数操作不是原子的，在多线程环境下需要外部同步

## 基本用法

### 创建对象

```cpp
// 1. 默认构造函数 - 创建空对象
CppUserData obj1;

// 2. 使用外部指针构造
void* external_data = malloc(100);
CppUserData obj2(external_data);

// 3. 使用长度构造（向后兼容）
CppUserData obj3(100);  // 分配100字节内存
```

### 引用计数操作

```cpp
// 查询引用计数
int count = obj2.getRefCount();  // 返回1

// 手动增加引用计数
obj2.addRef();
assert(obj2.getRefCount() == 2);

// 手动减少引用计数
obj2.releaseRef();
assert(obj2.getRefCount() == 1);
```

### 拷贝和赋值

```cpp
CppUserData obj1(external_data);

// 拷贝构造 - 共享同一个数据和引用计数
CppUserData obj2(obj1);
assert(obj1.getRefCount() == 2);
assert(obj2.getRefCount() == 2);

// 赋值运算符 - 共享数据和引用计数
CppUserData obj3;
obj3 = obj1;
assert(obj1.getRefCount() == 3);
assert(obj3.getRefCount() == 3);
```

### 内存管理

```cpp
CppUserData obj(external_data);

// 当不再需要时，手动减少引用计数
obj.releaseRef();

// 当引用计数为0时，调用 dispose() 释放内存
if (obj.getRefCount() == 0) {
    obj.dispose();
}
```

### 数据访问

```cpp
// 获取数据指针
void* data = obj.getData();

// 设置新的数据指针（会替换旧的数据）
void* new_data = malloc(200);
obj.setData(new_data);
```

## 重要注意事项

1. **内存释放责任**：`dispose()` 方法假设外部数据是通过 `malloc` 分配的。如果使用了其他分配方式，需要重写释放逻辑。

2. **悬空指针检查**：在使用 `getData()` 返回的指针之前，应该检查引用计数是否大于0。

3. **多线程安全**：引用计数操作本身不是原子的。在多线程环境下，需要使用互斥锁保护引用计数操作。

4. **循环引用**：引用计数无法处理循环引用问题。如果存在循环引用，需要特殊处理。

## 最佳实践

1. **RAII 原则**：尽可能使用作用域来管理对象生命周期
2. **显式释放**：对于长期存在的对象，手动管理引用计数
3. **防御性编程**：在使用数据指针前检查引用计数
4. **资源清理**：确保在程序结束前释放所有资源

## 示例：资源管理类

```cpp
class ResourceManager {
private:
    CppUserData resource;

public:
    ResourceManager(void* data) : resource(data) {}

    ~ResourceManager() {
        if (resource.getRefCount() > 0) {
            resource.releaseRef();
            if (resource.getRefCount() == 0) {
                resource.dispose();
            }
        }
    }

    void* getResource() const {
        return resource.getData();
    }
};
```

这个实现提供了一个安全、灵活的方式来管理外部C++资源，同时保持了与现有代码的兼容性。
