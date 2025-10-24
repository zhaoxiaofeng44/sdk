# 迭代器包装类使用指南

## 概述

为了避免直接暴露C++原始迭代器方法，我们为 `List`、`Set` 和 `Map` 容器实现了迭代器包装类。这些包装类提供了更安全、更易用的迭代接口。

## 迭代器类型

### 1. ListIterator<T>

用于遍历 `List<T>` 容器。

#### 方法

- `Bool hasNext() const` - 检查是否还有下一个元素
- `T next()` - 获取下一个元素并移动迭代器
- `T current() const` - 获取当前元素（不移动迭代器）
- `void reset(iterator begin)` - 重置迭代器到指定位置

#### 示例

```cpp
List<Int> list;
list.add(Int(10));
list.add(Int(20));
list.add(Int(30));

// 使用迭代器遍历
ListIterator<Int> iter = list.iterator();
while (iter.hasNext().value) {
    Int value = iter.next();
    std::cout << value.toInt() << std::endl;
}
```

### 2. SetIterator<T>

用于遍历 `Set<T>` 容器。

#### 方法

- `Bool hasNext() const` - 检查是否还有下一个元素
- `T next()` - 获取下一个元素并移动迭代器
- `T current() const` - 获取当前元素（不移动迭代器）
- `void reset(iterator begin)` - 重置迭代器到指定位置

#### 示例

```cpp
Set<String> set;
set.add(String("apple"));
set.add(String("banana"));
set.add(String("cherry"));

// 使用迭代器遍历
SetIterator<String> iter = set.iterator();
while (iter.hasNext().value) {
    String value = iter.next();
    std::cout << value.getValue() << std::endl;
}
```

### 3. MapIterator<K, V>

用于遍历 `Map<K, V>` 容器。

#### 方法

- `Bool hasNext() const` - 检查是否还有下一个元素
- `void next()` - 移动到下一个元素
- `K currentKey() const` - 获取当前键
- `V currentValue() const` - 获取当前值
- `void reset(iterator begin)` - 重置迭代器到指定位置

#### 示例

```cpp
Map<String, Int> map;
map.put(String("one"), Int(1));
map.put(String("two"), Int(2));
map.put(String("three"), Int(3));

// 使用迭代器遍历
MapIterator<String, Int> iter = map.iterator();
while (iter.hasNext().value) {
    String key = iter.currentKey();
    Int value = iter.currentValue();
    std::cout << key.getValue() << ": " << value.toInt() << std::endl;
    iter.next();
}
```

## forEach 方法

除了迭代器，每个容器还提供了 `forEach` 方法，使用回调函数进行遍历。

### List.forEach

```cpp
List<Int> list;
list.add(Int(1));
list.add(Int(2));
list.add(Int(3));

list.forEach([](const Int& value) {
    std::cout << value.toInt() << std::endl;
});
```

### Set.forEach

```cpp
Set<String> set;
set.add(String("apple"));
set.add(String("banana"));

set.forEach([](const String& value) {
    std::cout << value.getValue() << std::endl;
});
```

### Map.forEach

```cpp
Map<String, Int> map;
map.put(String("one"), Int(1));
map.put(String("two"), Int(2));

map.forEach([](const String& key, const Int& value) {
    std::cout << key.getValue() << ": " << value.toInt() << std::endl;
});
```

## 使用场景

### 1. 基本遍历

```cpp
List<Int> numbers;
for (int i = 1; i <= 5; i++) {
    numbers.add(Int(i));
}

ListIterator<Int> iter = numbers.iterator();
while (iter.hasNext().value) {
    std::cout << iter.next().toInt() << " ";
}
// 输出: 1 2 3 4 5
```

### 2. 条件过滤

```cpp
List<Int> numbers;
for (int i = 1; i <= 10; i++) {
    numbers.add(Int(i));
}

// 只打印偶数
numbers.forEach([](const Int& value) {
    if (value.get_isEven().value) {
        std::cout << value.toInt() << std::endl;
    }
});
```

### 3. 累加计算

```cpp
List<Int> numbers;
for (int i = 1; i <= 10; i++) {
    numbers.add(Int(i));
}

Int sum(0);
numbers.forEach([&sum](const Int& value) {
    sum = sum + value;
});
std::cout << "总和: " << sum.toInt() << std::endl;
// 输出: 总和: 55
```

### 4. 数据转换

```cpp
List<Int> numbers;
numbers.add(Int(1));
numbers.add(Int(2));
numbers.add(Int(3));

List<Int> squares;
numbers.forEach([&squares](const Int& value) {
    squares.add(value * value);
});
```

### 5. Map遍历

```cpp
Map<String, Int> scores;
scores.put(String("Alice"), Int(95));
scores.put(String("Bob"), Int(87));
scores.put(String("Charlie"), Int(92));

std::cout << "成绩单:" << std::endl;
scores.forEach([](const String& name, const Int& score) {
    std::cout << name.getValue() << ": " << score.toInt() << std::endl;
});
```

## 异常处理

迭代器在到达末尾后继续调用 `next()` 会抛出异常：

```cpp
List<Int> list;
list.add(Int(1));

ListIterator<Int> iter = list.iterator();
iter.next();  // OK

try {
    iter.next();  // 抛出 std::out_of_range
} catch (const std::out_of_range& e) {
    std::cout << "错误: " << e.what() << std::endl;
}
```

## 最佳实践

### 1. 使用 hasNext() 检查

```cpp
ListIterator<Int> iter = list.iterator();
while (iter.hasNext().value) {
    Int value = iter.next();
    // 处理 value
}
```

### 2. 优先使用 forEach

对于简单的遍历操作，`forEach` 更简洁：

```cpp
// 推荐
list.forEach([](const Int& value) {
    std::cout << value.toInt() << std::endl;
});

// 而不是
ListIterator<Int> iter = list.iterator();
while (iter.hasNext().value) {
    std::cout << iter.next().toInt() << std::endl;
}
```

### 3. 使用迭代器进行复杂控制

当需要更精细的控制时使用迭代器：

```cpp
ListIterator<Int> iter = list.iterator();
while (iter.hasNext().value) {
    Int value = iter.next();
    if (value.toInt() > 10) {
        break;  // 提前退出
    }
    // 处理 value
}
```

### 4. Lambda捕获

使用Lambda表达式时注意捕获方式：

```cpp
Int sum(0);
// 按引用捕获以修改外部变量
list.forEach([&sum](const Int& value) {
    sum = sum + value;
});

// 按值捕获以只读访问
Int threshold(10);
list.forEach([threshold](const Int& value) {
    if (value > threshold) {
        // ...
    }
});
```

## 性能考虑

1. **迭代器创建**: 每次调用 `iterator()` 都会创建新的迭代器对象
2. **forEach性能**: `forEach` 通常比手动迭代器稍快，因为编译器可以更好地优化
3. **内存**: 迭代器对象很轻量，只包含两个指针

## 与C++标准迭代器的对比

| 特性 | 包装迭代器 | C++标准迭代器 |
|------|-----------|--------------|
| 类型安全 | ✅ 高 | ⚠️ 中 |
| 易用性 | ✅ 简单 | ⚠️ 复杂 |
| 异常安全 | ✅ 自动检查 | ❌ 需手动检查 |
| 性能 | ✅ 相当 | ✅ 相当 |
| 暴露实现 | ❌ 不暴露 | ✅ 暴露 |

## 完整示例

```cpp
#include "object.h"
#include <iostream>

int main() {
    // List示例
    List<Int> numbers;
    for (int i = 1; i <= 5; i++) {
        numbers.add(Int(i));
    }
    
    std::cout << "List遍历:" << std::endl;
    numbers.forEach([](const Int& n) {
        std::cout << n.toInt() << " ";
    });
    std::cout << std::endl;
    
    // Set示例
    Set<String> fruits;
    fruits.add(String("apple"));
    fruits.add(String("banana"));
    fruits.add(String("cherry"));
    
    std::cout << "Set遍历:" << std::endl;
    SetIterator<String> setIter = fruits.iterator();
    while (setIter.hasNext().value) {
        std::cout << setIter.next().getValue() << " ";
    }
    std::cout << std::endl;
    
    // Map示例
    Map<String, Int> ages;
    ages.put(String("Alice"), Int(25));
    ages.put(String("Bob"), Int(30));
    
    std::cout << "Map遍历:" << std::endl;
    ages.forEach([](const String& name, const Int& age) {
        std::cout << name.getValue() << ": " 
                  << age.toInt() << std::endl;
    });
    
    return 0;
}
```

## 总结

迭代器包装类提供了：
- ✅ 类型安全的迭代接口
- ✅ 自动的边界检查
- ✅ 不暴露C++实现细节
- ✅ 简洁的API设计
- ✅ 与Lambda表达式良好集成

推荐在新代码中使用这些包装类而不是直接使用C++标准迭代器。
