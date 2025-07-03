# CppList List接口实现文档

## 概述

本文档描述了 `CppList<E>` 类的实现，该类直接实现了 Dart 的 `List<E>` 接口，提供了完整的列表功能。

## 类定义

```dart
@pragma("wasm:entry-point")
class CppList<E> implements List<E>
```

## 核心特性

### 1. 直接实现List接口
- 不再继承 `ListBase<E>`，而是直接实现 `List<E>` 接口
- 实现了所有必需的List接口方法
- 提供了完整的类型安全

### 2. 内部实现
- 使用 `CppArray<E>` 作为底层存储
- 维护 `_length` 字段跟踪实际元素数量
- 支持动态扩容

## 工厂方法

### 标准List工厂方法
- `CppList.empty({bool growable = false})` - 创建空列表
- `CppList.filled(int length, E fill, {bool growable = false})` - 创建填充列表
- `CppList.from(Iterable elements, {bool growable = true})` - 从可迭代对象创建
- `CppList.of(Iterable<E> elements, {bool growable = true})` - 从类型化可迭代对象创建
- `CppList.generate(int length, E Function(int index) generator, {bool growable = true})` - 生成列表
- `CppList.unmodifiable(Iterable elements)` - 创建不可修改列表

### 自定义工厂方法
- `CppList.fromCppArray(CppArray<E> array)` - 从CppArray创建
- `CppList(int length, int capacity)` - 构造函数

## 实现的方法

### 基本属性
- `int get length` - 获取列表长度
- `set length(int newLen)` - 设置列表长度
- `bool get isEmpty` - 检查是否为空
- `bool get isNotEmpty` - 检查是否非空
- `E get first` - 获取第一个元素
- `set first(E value)` - 设置第一个元素
- `E get last` - 获取最后一个元素
- `set last(E value)` - 设置最后一个元素
- `E get single` - 获取唯一元素

### 索引操作
- `E operator [](int index)` - 索引访问
- `void operator []=(int index, E value)` - 索引赋值
- `E elementAt(int index)` - 获取指定位置的元素

### 添加操作
- `void add(E value)` - 添加单个元素
- `void addAll(Iterable<E> iterable)` - 添加多个元素
- `void insert(int index, E element)` - 在指定位置插入
- `void insertAll(int index, Iterable<E> iterable)` - 在指定位置插入多个元素

### 删除操作
- `bool remove(Object? value)` - 删除指定值
- `E removeAt(int index)` - 删除指定位置的元素
- `E removeLast()` - 删除最后一个元素
- `void removeRange(int start, int end)` - 删除范围
- `void removeWhere(bool Function(E element) test)` - 条件删除
- `void retainWhere(bool Function(E element) test)` - 条件保留
- `void clear()` - 清空列表

### 查找操作
- `bool contains(Object? element)` - 检查是否包含元素
- `int indexOf(E element, [int start = 0])` - 查找元素索引
- `int lastIndexOf(E element, [int? start])` - 查找最后出现的索引
- `int indexWhere(bool Function(E element) test, [int start = 0])` - 条件查找索引
- `int lastIndexWhere(bool Function(E element) test, [int? start])` - 条件查找最后索引

### 查找元素
- `E firstWhere(bool Function(E element) test, {E Function()? orElse})` - 查找第一个满足条件的元素
- `E lastWhere(bool Function(E element) test, {E Function()? orElse})` - 查找最后一个满足条件的元素
- `E singleWhere(bool Function(E element) test, {E Function()? orElse})` - 查找唯一满足条件的元素

### 迭代操作
- `Iterator<E> get iterator` - 获取迭代器
- `void forEach(void Function(E element) action)` - 遍历操作
- `bool any(bool Function(E element) test)` - 检查是否有元素满足条件
- `bool every(bool Function(E element) test)` - 检查是否所有元素都满足条件

### 转换操作
- `Iterable<T> map<T>(T Function(E e) toElement)` - 映射转换
- `Iterable<E> where(bool Function(E element) test)` - 过滤
- `Iterable<T> whereType<T>()` - 类型过滤
- `Iterable<T> expand<T>(Iterable<T> Function(E element) toElements)` - 展开
- `T fold<T>(T initialValue, T Function(T previousValue, E element) combine)` - 折叠
- `E reduce(E Function(E value, E element) combine)` - 归约

### 切片操作
- `Iterable<E> getRange(int start, int end)` - 获取范围
- `List<E> sublist(int start, [int? end])` - 子列表
- `Iterable<E> take(int count)` - 取前N个
- `Iterable<E> takeWhile(bool Function(E value) test)` - 条件取前N个
- `Iterable<E> skip(int count)` - 跳过前N个
- `Iterable<E> skipWhile(bool Function(E value) test)` - 条件跳过

### 范围操作
- `void fillRange(int start, int end, [E? fillValue])` - 填充范围
- `void replaceRange(int start, int end, Iterable<E> replacements)` - 替换范围
- `void setRange(int start, int end, Iterable<E> iterable, [int skipCount = 0])` - 设置范围
- `void setAll(int index, Iterable<E> iterable)` - 设置所有

### 排序和随机化
- `void sort([int Function(E a, E b)? compare])` - 排序
- `void shuffle([Random? random])` - 随机化

### 转换方法
- `List<E> toList({bool growable = true})` - 转换为List
- `Set<E> toSet()` - 转换为Set
- `Map<int, E> asMap()` - 转换为Map
- `List<R> cast<R>()` - 类型转换
- `String join([String separator = ""])` - 连接为字符串
- `String toString()` - 字符串表示

### 其他操作
- `Iterable<E> followedBy(Iterable<E> other)` - 连接迭代器
- `Iterable<E> get reversed` - 反转迭代器
- `List<E> operator +(List<E> other)` - 列表连接

## 性能特性

### 内存管理
- 使用 `_getSuggestCapacity()` 函数进行智能扩容
- 支持固定容量和可增长模式
- 最小化内存分配

### 时间复杂度
- 索引访问: O(1)
- 添加元素: 平均 O(1)，最坏 O(n)
- 删除元素: O(n)
- 查找元素: O(n)

## 测试覆盖

所有方法都通过了完整的测试验证，包括：
- 工厂方法测试
- 基本操作测试
- 迭代器操作测试
- 查找操作测试
- 修改操作测试
- 转换操作测试

## 使用示例

```dart
// 创建列表
var list = CppList<int>(0, 10);

// 添加元素
list.add(1);
list.add(2);
list.add(3);

// 索引操作
print(list[0]); // 1
list[1] = 5;

// 迭代
for (var element in list) {
  print(element);
}

// 转换操作
var doubled = list.map((e) => e * 2);
var evens = list.where((e) => e % 2 == 0);

// 工厂方法
var filled = CppList.filled(3, 'test');
var generated = CppList.generate(5, (i) => i * i);
```

## 注意事项

1. 该实现完全兼容标准的Dart List接口
2. 支持所有List的标准操作和工厂方法
3. 提供了完整的类型安全
4. 适用于需要C++互操作的场景
5. 性能优化针对常见用例进行了调整 