# CppIterable 实现文档

## 概述

`CppIterable` 是一个完整的 Dart 可迭代对象实现，模仿了 Dart 标准库的 `Iterable` 接口。该实现不依赖于 Dart 标准库的内置集合类型，完全独立实现，适用于需要自定义集合行为的场景。

## 核心设计理念

### 1. 接口导向设计
- 所有类都实现接口而不是继承具体类
- 符合组合优于继承的原则
- 提供最大的灵活性和可扩展性

### 2. 惰性求值
- 大多数转换操作（如 `map`, `where`, `take` 等）都是惰性的
- 只有在需要时才会计算结果
- 提高性能，减少内存使用

### 3. 类型安全
- 完全支持 Dart 的泛型系统
- 提供类型安全的转换和操作
- 支持类型过滤和类型转换

## 类结构

### 抽象基类

#### `CppIterator<E>`
基础迭代器接口，定义了迭代器的基本行为：
- `E get current` - 获取当前元素
- `bool moveNext()` - 移动到下一个元素

#### `CppIterable<E>`
基础可迭代对象接口，提供了所有集合操作的默认实现：
- 基本属性：`length`, `isEmpty`, `isNotEmpty`, `first`, `last`, `single`
- 访问操作：`elementAt`, `contains`, `forEach`
- 转换操作：`map`, `cast`, `expand`
- 过滤操作：`where`, `whereType`
- 查找操作：`firstWhere`, `lastWhere`, `singleWhere`
- 条件判断：`any`, `every`
- 聚合操作：`reduce`, `fold`, `join`
- 切片操作：`take`, `takeWhile`, `skip`, `skipWhile`, `reversed`
- 组合操作：`followedBy`
- 转换操作：`toList`, `toSet`

### 具体实现类

#### `CppList<E>`
动态数组实现，支持：
- 动态扩容
- 随机访问
- 插入、删除操作
- 多种构造方法

#### `CppSet<E>`
集合实现，支持：
- 元素唯一性
- 集合运算（并集、交集、差集）
- 基于 `CppList` 的内部实现

#### `CppMap<K, V>`
映射实现，支持：
- 键值对存储
- 键唯一性
- 完整的 Map 接口
- 基于 `CppList<CppMapEntry<K, V>>` 的内部实现

### 惰性迭代器实现

#### 转换迭代器
- `CppMappedIterable<S, T>` - 映射转换
- `CppCastIterable<S, T>` - 类型转换
- `CppExpandIterable<S, T>` - 展开操作

#### 过滤迭代器
- `CppWhereIterable<E>` - 条件过滤
- `CppWhereTypeIterable<T>` - 类型过滤

#### 切片迭代器
- `CppTakeIterable<E>` - 取前 N 个元素
- `CppTakeWhileIterable<E>` - 取满足条件的前 N 个元素
- `CppSkipIterable<E>` - 跳过前 N 个元素
- `CppSkipWhileIterable<E>` - 跳过满足条件的前 N 个元素

#### 组合迭代器
- `CppReversedIterable<E>` - 反转迭代器
- `CppFollowedByIterable<E>` - 连接迭代器

## 使用示例

### 基本使用

```dart
// 创建列表
var list = CppList<int>();
list.add(1);
list.add(2);
list.add(3);

// 基本操作
print(list.length); // 3
print(list.first);  // 1
print(list.last);   // 3
print(list[1]);     // 2

// 迭代
list.forEach((x) => print(x));

// 转换
var doubled = list.map((x) => x * 2);
print(doubled.toList()); // [2, 4, 6]

// 过滤
var evens = list.where((x) => x % 2 == 0);
print(evens.toList()); // [2]
```

### 工厂构造方法

```dart
// 填充构造
var filled = CppList<String>.filled(3, "hello");
print(filled); // [hello, hello, hello]

// 从其他可迭代对象构造
var fromOther = CppList<int>.from(list);
print(fromOther); // [1, 2, 3]

// 生成器构造
var generated = CppList<int>.generate(5, (i) => i * i);
print(generated); // [0, 1, 4, 9, 16]

// 空列表
var empty = CppList<int>.empty();
print(empty.isEmpty); // true
```

### 集合操作

```dart
// 创建集合
var set1 = CppSet<int>();
set1.add(1);
set1.add(2);
set1.add(3);

var set2 = CppSet<int>();
set2.add(2);
set2.add(3);
set2.add(4);

// 集合运算
var union = set1.union(set2);
print(union); // {1, 2, 3, 4}

var intersection = set1.intersection(set2);
print(intersection); // {2, 3}

var difference = set1.difference(set2);
print(difference); // {1}
```

### 映射操作

```dart
// 创建映射
var map = CppMap<String, int>();
map["one"] = 1;
map["two"] = 2;
map["three"] = 3;

// 基本操作
print(map["one"]); // 1
print(map.containsKey("two")); // true
print(map.containsValue(3)); // true

// 遍历
map.forEachKeyValue((key, value) {
  print("$key: $value");
});

// 转换
var keys = map.keys.toList();
var values = map.values.toList();
print(keys); // [one, two, three]
print(values); // [1, 2, 3]
```

### 链式操作

```dart
var list = CppList<int>();
list.add(1);
list.add(2);
list.add(3);
list.add(4);
list.add(5);

// 链式操作
var result = list
  .where((x) => x > 2)        // 过滤大于2的元素
  .map((x) => x * 2)          // 每个元素乘以2
  .take(2)                    // 取前2个
  .toList();                  // 转换为列表

print(result); // [6, 8]
```

### 聚合操作

```dart
var numbers = CppList<int>();
numbers.add(1);
numbers.add(2);
numbers.add(3);
numbers.add(4);
numbers.add(5);

// 聚合操作
var sum = numbers.reduce((a, b) => a + b);
print(sum); // 15

var product = numbers.fold(1, (a, b) => a * b);
print(product); // 120

var joined = numbers.join(",");
print(joined); // "1,2,3,4,5"

// 条件判断
print(numbers.any((x) => x > 3)); // true
print(numbers.every((x) => x > 0)); // true
```

### 切片操作

```dart
var list = CppList<int>();
list.add(1);
list.add(2);
list.add(3);
list.add(4);
list.add(5);

// 切片操作
var first3 = list.take(3);
print(first3.toList()); // [1, 2, 3]

var last3 = list.skip(2);
print(last3.toList()); // [3, 4, 5]

var whileSmall = list.takeWhile((x) => x < 4);
print(whileSmall.toList()); // [1, 2, 3]

var reversed = list.reversed;
print(reversed.toList()); // [5, 4, 3, 2, 1]
```

## 性能特点

### 内存管理
- `CppList` 使用动态数组，支持自动扩容
- 扩容策略：当容量不足时，容量翻倍或增加到所需大小
- 内存使用相对紧凑

### 时间复杂度
- `CppList` 访问：O(1)
- `CppList` 插入/删除：O(n)
- `CppSet` 查找：O(n)（基于线性搜索）
- `CppMap` 查找：O(n)（基于线性搜索）

### 惰性求值
- 转换操作不会立即执行
- 只有在遍历时才会计算结果
- 可以进行高效的链式操作

## 与 Dart 标准库的对比

### 相同点
- 接口设计完全兼容
- 支持所有基本的集合操作
- 支持泛型和类型安全
- 支持惰性求值

### 不同点
- 不继承 Dart 的内置类型
- `CppSet` 和 `CppMap` 基于线性搜索，不使用哈希
- 没有实现 `Comparable` 接口
- 某些高级特性可能不完全兼容

## 扩展指南

### 添加新的迭代器

```dart
class CppCustomIterable<E> extends CppIterable<E> {
  final CppIterable<E> _source;
  final CustomFunction _function;
  
  CppCustomIterable(this._source, this._function);
  
  @override
  CppIterator<E> get iterator => CppCustomIterator<E>(_source.iterator, _function);
  
  @override
  int get length {
    // 根据需要实现
  }
}

class CppCustomIterator<E> extends CppIterator<E> {
  final CppIterator<E> _iterator;
  final CustomFunction _function;
  
  CppCustomIterator(this._iterator, this._function);
  
  @override
  E get current => _iterator.current;
  
  @override
  bool moveNext() {
    // 实现自定义的移动逻辑
  }
}
```

### 添加新的集合类型

```dart
class CppCustomCollection<E> extends CppIterable<E> {
  // 内部数据结构
  
  @override
  CppIterator<E> get iterator => CppCustomIterator<E>(this);
  
  @override
  int get length => // 实现长度计算
  
  // 实现其他必要的方法
}
```

## 测试覆盖

测试文件 `test/iterable_test.dart` 包含了完整的测试用例，覆盖：
- 基本的 CRUD 操作
- 所有转换和过滤操作
- 聚合和切片操作
- 边界条件和错误处理
- 性能测试

## 总结

`CppIterable` 提供了一个完整、独立的可迭代对象实现，具有以下优势：

1. **完整性**：实现了 Dart Iterable 接口的所有核心功能
2. **独立性**：不依赖 Dart 标准库的内置集合类型
3. **灵活性**：支持自定义和扩展
4. **性能**：采用惰性求值，支持高效的链式操作
5. **类型安全**：完全支持 Dart 的泛型系统

该实现适用于需要自定义集合行为、不依赖标准库或需要特殊性能特征的场景。 