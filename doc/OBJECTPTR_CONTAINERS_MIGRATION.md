# List/Set/Map强制使用ObjectPtr包裹 - 迁移指南

## 变更概述

根据您的要求，List、Set、Map容器现在也强制使用ObjectPtr包裹，与自定义类保持一致。

### 变更前（旧方式）
```cpp
// 直接使用值语义
List<Int> numbers;
numbers.add(Int(1));

Set<String> names;
names.add(String("Alice"));

Map<String, Int> scores;
scores.put(String("key"), Int(100));
```

### 变更后（新方式）
```cpp
// 必须通过ObjectPtr使用
ObjectPtr<List<Int>> numbers = List<Int>::create();
numbers->add(Int(1));

ObjectPtr<Set<String>> names = Set<String>::create();
names->add(String("Alice"));

ObjectPtr<Map<String, Int>> scores = Map<String, Int>::create();
scores->put(String("key"), Int(100));
```

## 类型系统统一规范

### 现在所有类型的使用方式：

| 类型 | 使用方式 | 原因 |
|------|---------|------|
| **Int, Double, Bool, String** | 值语义（直接使用） | 基础类型，轻量高效 |
| **List, Set, Map** | ObjectPtr（强制） | ✅ **统一规范** |
| **自定义Class** | ObjectPtr（强制） | ✅ **统一规范** |

### 核心理念更新

> **基础类型值语义，对象类型强制ObjectPtr**

所有继承自Object的类型（包括List、Set、Map和自定义类）都必须通过ObjectPtr使用。

## API变更详情

### 1. List API

#### 构造函数变更

**旧方式（已移除）**：
```cpp
List<Int> list;  // ❌ 不再可用
List<Int> list2(list);  // ❌ 不再可用
List<Int> list3({Int(1), Int(2)});  // ❌ 不再可用
```

**新方式**：
```cpp
// 创建空List
ObjectPtr<List<Int>> list = List<Int>::create();

// 复制构造
ObjectPtr<List<Int>> list2 = List<Int>::create(*list);

// 初始化列表
ObjectPtr<List<Int>> list3 = List<Int>::create({Int(1), Int(2), Int(3)});
```

#### 方法返回值变更

**subList()方法**：
```cpp
// 旧：List<T> subList(Int start, Int end) const;
// 新：ObjectPtr<List<T>> subList(Int start, Int end) const;

ObjectPtr<List<Int>> numbers = List<Int>::create({Int(1), Int(2), Int(3), Int(4)});
ObjectPtr<List<Int>> sub = numbers->subList(Int(1), Int(3));  // 返回ObjectPtr
```

### 2. Set API

#### 构造函数变更

**新方式**：
```cpp
// 创建空Set
ObjectPtr<Set<String>> set = Set<String>::create();

// 复制构造
ObjectPtr<Set<String>> set2 = Set<String>::create(*set);

// 初始化列表
ObjectPtr<Set<String>> set3 = Set<String>::create({String("a"), String("b")});
```

#### 集合操作方法变更

**旧签名**：
```cpp
Set<T> unionWith(const Set& other) const;
Set<T> intersection(const Set& other) const;
Set<T> difference(const Set& other) const;
Bool isSubsetOf(const Set& other) const;
```

**新签名**：
```cpp
ObjectPtr<Set<T>> unionWith(const ObjectPtr<Set<T>>& other) const;
ObjectPtr<Set<T>> intersection(const ObjectPtr<Set<T>>& other) const;
ObjectPtr<Set<T>> difference(const ObjectPtr<Set<T>>& other) const;
Bool isSubsetOf(const ObjectPtr<Set<T>>& other) const;
```

**使用示例**：
```cpp
ObjectPtr<Set<Int>> set1 = Set<Int>::create({Int(1), Int(2), Int(3)});
ObjectPtr<Set<Int>> set2 = Set<Int>::create({Int(2), Int(3), Int(4)});

// 集合操作
ObjectPtr<Set<Int>> unionSet = set1->unionWith(set2);
ObjectPtr<Set<Int>> intersectionSet = set1->intersection(set2);
ObjectPtr<Set<Int>> differenceSet = set1->difference(set2);
Bool isSubset = set1->isSubsetOf(set2);
```

### 3. Map API

#### 构造函数变更

**新方式**：
```cpp
// 创建空Map
ObjectPtr<Map<String, Int>> map = Map<String, Int>::create();

// 复制构造
ObjectPtr<Map<String, Int>> map2 = Map<String, Int>::create(*map);

// 初始化列表
ObjectPtr<Map<String, Int>> map3 = Map<String, Int>::create({
    {String("key1"), Int(1)},
    {String("key2"), Int(2)}
});
```

#### 键值操作方法变更

**旧签名**：
```cpp
Set<K> keySet() const;
List<V> values() const;
```

**新签名**：
```cpp
ObjectPtr<Set<K>> keySet() const;
ObjectPtr<List<V>> values() const;
```

**使用示例**：
```cpp
ObjectPtr<Map<String, Int>> scores = Map<String, Int>::create();
scores->put(String("Alice"), Int(95));
scores->put(String("Bob"), Int(87));

// 获取所有键
ObjectPtr<Set<String>> keys = scores->keySet();
keys->forEach([](const String& key) {
    std::cout << key.getValue() << std::endl;
});

// 获取所有值
ObjectPtr<List<Int>> vals = scores->values();
vals->forEach([](const Int& value) {
    std::cout << value.toInt() << std::endl;
});
```

## 迁移步骤

### 步骤1：查找所有容器声明

搜索代码中的所有容器声明：
- `List<` 
- `Set<`
- `Map<`

### 步骤2：更新声明

将所有容器声明更改为使用ObjectPtr：

```cpp
// 前
List<Int> numbers;
Set<String> names;
Map<String, Int> scores;

// 后
ObjectPtr<List<Int>> numbers = List<Int>::create();
ObjectPtr<Set<String>> names = Set<String>::create();
ObjectPtr<Map<String, Int>> scores = Map<String, Int>::create();
```

### 步骤3：更新访问方式

将点操作符`.`改为箭头操作符`->`：

```cpp
// 前
numbers.add(Int(1));
Int first = numbers[Int(0)];

// 后
numbers->add(Int(1));
Int first = (*numbers)[Int(0)];
```

### 步骤4：更新集合操作

更新Set的集合操作参数和返回值：

```cpp
// 前
Set<Int> result = set1.unionWith(set2);

// 后
ObjectPtr<Set<Int>> result = set1->unionWith(set2);
```

### 步骤5：更新Map的键值操作

```cpp
// 前
Set<String> keys = map.keySet();
List<Int> vals = map.values();

// 后
ObjectPtr<Set<String>> keys = map->keySet();
ObjectPtr<List<Int>> vals = map->values();
```

## 优势与益处

### 1. 统一的类型系统

✅ **一致性**：所有Object子类（包括容器）都通过ObjectPtr使用
- 不再有"容器是值语义，自定义类是引用语义"的混乱
- 更清晰的类型系统层次

### 2. 引用共享

✅ **高效共享**：大容器可以高效共享，无需昂贵的拷贝

```cpp
ObjectPtr<List<Int>> list1 = List<Int>::create();
for (int i = 0; i < 10000; i++) {
    list1->add(Int(i));
}

// 共享，不拷贝！
ObjectPtr<List<Int>> list2 = list1;
```

### 3. 自动内存管理

✅ **引用计数**：自动管理生命周期

```cpp
void useContainer() {
    ObjectPtr<List<Int>> temp = List<Int>::create();
    temp->add(Int(1));
    // 自动释放
}
```

### 4. 多态支持

✅ **统一接口**：所有ObjectPtr可以统一处理

```cpp
void printObject(const ObjectPtr<Object>& obj) {
    std::cout << obj->toString().getValue() << std::endl;
}

ObjectPtr<List<Int>> list = List<Int>::create();
ObjectPtr<Set<String>> set = Set<String>::create();
// 统一处理
```

## 性能考虑

### 引用计数开销

```cpp
// 拷贝ObjectPtr会增加/减少引用计数（原子操作）
ObjectPtr<List<Int>> list2 = list1;  // 引用计数+1
```

**建议**：
- 函数参数使用`const ObjectPtr<T>&`避免计数变化
- 返回值直接返回ObjectPtr（移动语义）

```cpp
// ✅ 推荐：const引用
void process(const ObjectPtr<List<Int>>& list) { ... }

// ✅ 推荐：返回ObjectPtr
ObjectPtr<List<Int>> createList() {
    return List<Int>::create();
}
```

### 内存分配

```cpp
// 现在容器在堆上分配
ObjectPtr<List<Int>> list = List<Int>::create();  // new List<Int>()
```

**建议**：
- 避免频繁创建临时容器
- 重用已有容器

## 常见问题

### Q1: 为什么要强制使用ObjectPtr？

**A**: 为了统一类型系统，所有Object子类（包括容器和自定义类）都必须通过ObjectPtr使用，这样：
- ✅ 类型系统更一致
- ✅ 更容易理解和使用
- ✅ 支持引用共享和自动管理

### Q2: 如何访问容器元素？

**A**: 使用箭头操作符`->`：

```cpp
ObjectPtr<List<Int>> list = List<Int>::create();
list->add(Int(1));
Int value = (*list)[Int(0)];  // operator[]需要解引用
```

### Q3: 如何传递容器给函数？

**A**: 使用const引用避免引用计数变化：

```cpp
void process(const ObjectPtr<List<Int>>& list) {
    list->forEach([](const Int& n) { ... });
}
```

### Q4: 模板实例化限制还存在吗？

**A**: 是的，`List<ObjectPtr<CustomClass>>`仍然需要在object.cpp中显式实例化，或使用`std::vector<ObjectPtr<CustomClass>>`作为替代。

### Q5: 可以创建空的ObjectPtr吗？

**A**: 可以，但使用前必须检查：

```cpp
ObjectPtr<List<Int>> list;  // 默认为null

if (list.isNull().value) {
    list = List<Int>::create();
}
```

## 测试验证

完整的测试用例在 `test/objectptr_containers_test.cpp` 中，包括：

- ✅ List使用ObjectPtr
- ✅ Set使用ObjectPtr
- ✅ Map使用ObjectPtr
- ✅ Set集合操作
- ✅ 容器共享
- ✅ 初始化列表
- ✅ 迭代器
- ✅ 空指针检查
- ✅ 容器复制

运行测试：
```bash
cd test
make run_objectptr_containers
```

## 示例代码

### 完整示例1：List操作

```cpp
#include "pkg/dart2bytecode/base/object.h"

int main() {
    // 创建List
    ObjectPtr<List<Int>> numbers = List<Int>::create();
    
    // 添加元素
    numbers->add(Int(10));
    numbers->add(Int(20));
    numbers->add(Int(30));
    
    // 访问元素
    Int first = (*numbers)[Int(0)];
    std::cout << "First: " << first.toInt() << std::endl;
    
    // 遍历
    numbers->forEach([](const Int& n) {
        std::cout << n.toInt() << " ";
    });
    
    // 子列表
    ObjectPtr<List<Int>> sub = numbers->subList(Int(0), Int(2));
    
    return 0;
}
```

### 完整示例2：Set集合操作

```cpp
#include "pkg/dart2bytecode/base/object.h"

int main() {
    // 创建两个Set
    ObjectPtr<Set<Int>> set1 = Set<Int>::create({Int(1), Int(2), Int(3)});
    ObjectPtr<Set<Int>> set2 = Set<Int>::create({Int(2), Int(3), Int(4)});
    
    // 并集
    ObjectPtr<Set<Int>> unionSet = set1->unionWith(set2);
    std::cout << "Union size: " << unionSet->size().toInt() << std::endl;
    
    // 交集
    ObjectPtr<Set<Int>> interSet = set1->intersection(set2);
    std::cout << "Intersection size: " << interSet->size().toInt() << std::endl;
    
    // 差集
    ObjectPtr<Set<Int>> diffSet = set1->difference(set2);
    std::cout << "Difference size: " << diffSet->size().toInt() << std::endl;
    
    return 0;
}
```

### 完整示例3：Map操作

```cpp
#include "pkg/dart2bytecode/base/object.h"

int main() {
    // 创建Map
    ObjectPtr<Map<String, Int>> scores = Map<String, Int>::create();
    
    // 添加键值对
    scores->put(String("Alice"), Int(95));
    scores->put(String("Bob"), Int(87));
    scores->put(String("Charlie"), Int(92));
    
    // 访问
    Int aliceScore = (*scores)[String("Alice")];
    std::cout << "Alice: " << aliceScore.toInt() << std::endl;
    
    // 遍历
    scores->forEach([](const String& name, const Int& score) {
        std::cout << name.getValue() << ": " << score.toInt() << std::endl;
    });
    
    // 获取键和值
    ObjectPtr<Set<String>> keys = scores->keySet();
    ObjectPtr<List<Int>> values = scores->values();
    
    return 0;
}
```

## 总结

这次变更统一了类型系统，使得所有Object子类都通过ObjectPtr使用：

| 变更前 | 变更后 |
|--------|--------|
| 基础类型：值语义 | 基础类型：值语义 ✅ 不变 |
| 容器：值语义（可选ObjectPtr） | 容器：ObjectPtr（强制） ✅ 统一 |
| 自定义类：ObjectPtr（强制） | 自定义类：ObjectPtr（强制） ✅ 不变 |

**新的核心理念**：
> **基础类型值语义，对象类型强制ObjectPtr**

这使得类型系统更加清晰、一致和易于理解。

---

**文档版本**: 1.0  
**日期**: 2025-10-20  
**相关测试**: `test/objectptr_containers_test.cpp`  
**相关文档**: 
- `doc/FINAL_TYPE_SYSTEM_SUMMARY.md`
- `doc/PROJECT_STATUS_REPORT.md`
- `doc/DELIVERY_CHECKLIST.md`

