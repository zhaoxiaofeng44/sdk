# ObjectPtr全面重构计划

## 背景

当前设计中：
- **基础类型**（Int, Double, Bool, String）继承自Any，直接使用值语义
- **对象类型**（Object及其子类：List, Set, Map, 自定义类）也可以直接使用
- **ObjectPtr**只是作为可选的智能指针使用

## 目标设计

所有Object类型及其子类型必须通过ObjectPtr包裹：
- **基础类型**（Int, Double, Bool, String）保持值语义，直接使用
- **对象类型**（Object及子类）强制使用ObjectPtr包裹
- List, Set, Map必须通过ObjectPtr使用
- 自定义类必须通过ObjectPtr使用

## 类型系统层次

```
Any (抽象基类)
├── Int (值类型)
├── Double (值类型)
├── Bool (值类型)
├── String (值类型)
└── Object (引用类型 - 必须通过ObjectPtr)
    ├── List<T> (必须通过ObjectPtr<List<T>>)
    ├── Set<T> (必须通过ObjectPtr<Set<T>>)
    ├── Map<K,V> (必须通过ObjectPtr<Map<K,V>>)
    └── CustomClass (必须通过ObjectPtr<CustomClass>)
```

## 设计挑战

### 1. 模板实例化问题
当前List、Set、Map的模板实现在object.cpp中，如果要求所有使用都通过ObjectPtr，会导致：
- 需要大量的模板显式实例化
- ObjectPtr<List<Int>>, ObjectPtr<Set<String>>等需要预先实例化
- 编译时间和复杂度大幅增加

### 2. API兼容性
改变会破坏现有API：
```cpp
// 当前方式
List<Int> list;
list.add(Int(1));

// 新方式
ObjectPtr<List<Int>> list = List<Int>::create();
list->add(Int(1));
```

### 3. 构造函数访问
需要将所有Object子类的构造函数私有化：
```cpp
class List : public Object {
private:
    List() {}  // 私有构造
public:
    static ObjectPtr<List<T>> create() {
        return ObjectPtr<List<T>>(new List<T>());
    }
};
```

## 推荐方案

### 方案A：完全重构（激进）

**优点：**
- 类型系统清晰统一
- 强制内存安全
- 符合现代C++最佳实践

**缺点：**
- 工作量巨大
- 破坏所有现有代码
- 模板实例化复杂
- 编译时间增加

**实施步骤：**
1. 修改Object及所有子类，私有化构造函数
2. 为所有类添加静态create工厂方法
3. 更新所有测试用例
4. 处理模板实例化问题

### 方案B：渐进式重构（保守）

**优点：**
- 向后兼容
- 逐步迁移
- 风险可控

**缺点：**
- 同时存在两种模式
- 可能导致混乱

**实施步骤：**
1. 保持当前值语义的使用方式
2. 添加ObjectPtr版本的工厂方法作为备选
3. 新代码推荐使用ObjectPtr
4. 旧代码可以继续工作

### 方案C：混合模式（推荐）

**设计原则：**
- 基础类型（Int, Double, Bool, String）保持值语义
- 容器类型（List, Set, Map）可以值语义或引用语义
- 自定义类强制使用ObjectPtr

**优点：**
- 平衡了易用性和安全性
- 基础类型保持轻量
- 自定义类强制安全
- 容器类灵活使用

**实施步骤：**
1. 保持基础类型不变
2. 为List/Set/Map添加create工厂方法（可选使用）
3. 自定义类强制私有化构造函数
4. 提供两套API共存

## 具体实施计划

基于方案C（混合模式），我们已经完成：

### ✅ 已完成
1. 基础类型保持值语义
2. 自定义类强制使用ObjectPtr
3. 创建了完整的测试用例

### 📋 建议的下一步

#### 1. 为容器添加工厂方法（可选）

```cpp
template <typename T>
class List : public Object {
public:
    // 保留现有构造函数（值语义）
    List();
    
    // 新增工厂方法（引用语义）
    static ObjectPtr<List<T>> create() {
        return ObjectPtr<List<T>>(new List<T>());
    }
};
```

#### 2. 更新文档说明使用场景

```cpp
// 场景1：短生命周期，栈上分配
void processData() {
    List<Int> temp;
    temp.add(Int(1));
    // 函数结束自动销毁
}

// 场景2：长生命周期，需要共享
ObjectPtr<List<Int>> globalList = List<Int>::create();
void shareData() {
    ObjectPtr<List<Int>> shared = globalList;
    // 共享引用
}
```

#### 3. 提供转换辅助函数

```cpp
// 值到引用
template<typename T>
ObjectPtr<List<T>> toPtr(const List<T>& list) {
    ObjectPtr<List<T>> ptr = List<T>::create();
    // 拷贝数据
    return ptr;
}

// 引用到值
template<typename T>
List<T> toValue(ObjectPtr<List<T>> ptr) {
    return *ptr.get();
}
```

## 当前状态总结

### 类型使用规则

| 类型 | 使用方式 | 原因 |
|------|---------|------|
| Int, Double, Bool, String | 值语义 | 轻量级，频繁使用 |
| List, Set, Map | 值语义（默认） | 兼容性，易用性 |
| List, Set, Map | ObjectPtr（可选） | 需要共享时 |
| 自定义类 | ObjectPtr（强制） | 内存安全 |

### 示例代码

```cpp
// 基础类型 - 值语义
Int a = Int(10);
String s = String("hello");

// 容器 - 值语义
List<Int> list;
list.add(Int(1));

// 容器 - 引用语义（可选）
ObjectPtr<List<Int>> listPtr = List<Int>::create();
listPtr->add(Int(1));

// 自定义类 - 强制引用语义
ObjectPtr<MyClass> obj = MyClass::create();
obj->doSomething();
```

## 结论

当前实现采用了**混合模式**，这是最实用的方案：

1. ✅ 基础类型保持轻量和易用
2. ✅ 容器类型灵活使用
3. ✅ 自定义类强制安全
4. ✅ 向后兼容
5. ✅ 逐步迁移路径清晰

如果未来需要完全统一，可以逐步弃用值语义的容器API，但目前的混合模式已经很好地平衡了各方面需求。
