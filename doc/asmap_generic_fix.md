# asMap方法泛型参数修复

## 问题描述

在Dart到C++的代码转换过程中，`asMap()`方法的泛型参数在转换后丢失了。

### 原始代码（collection.dart）
```dart
@override
Map<int, E> asMap() {
  var map = <int, E>{};
  for (int i = 0; i < _length; i++) {
    map[i] = CppApi.cppGetPointerArrayItem(_array, i) as E;
  }
  return map;
}
```

### 转换后的代码（transformed_dart.dart）
```dart
Map<int, E> asMap() {
  {
    Map map = {}; // ❌ 丢失了泛型参数 <int, E>
    for (int i = 0; (i < this._length); i = (i + 1)) {
      {
        map[i] = CppApi.cppGetPointerArrayItem(this._array, i) as E;
      }
    }
    return map;
  }
}
```

## 问题分析

1. **类型安全丢失**：转换后的代码中 `Map map = {}` 丢失了泛型参数 `<int, E>`
2. **编译错误**：这会导致类型检查失败，因为返回类型声明为 `Map<int, E>` 但实际返回的是原始 `Map` 类型
3. **运行时问题**：可能导致类型转换错误或意外的运行时行为

## 解决方案

将转换后的代码修复为：

```dart
Map<int, E> asMap() {
  {
    Map<int, E> map = <int, E>{}; // ✅ 正确添加泛型参数
    for (int i = 0; (i < this._length); i = (i + 1)) {
      {
        map[i] = CppApi.cppGetPointerArrayItem(this._array, i) as E;
      }
    }
    return map;
  }
}
```

## 修复内容

1. **变量声明**：`Map map = {}` → `Map<int, E> map = <int, E>{}`
2. **类型一致性**：确保变量类型与返回类型一致
3. **泛型参数保持**：保持原始代码的泛型参数 `<int, E>`

## 测试验证

创建了测试用例 `tests/collection_asmap_test.dart` 来验证：

1. 整数列表的 `asMap()` 方法返回 `Map<int, int>`
2. 字符串列表的 `asMap()` 方法返回 `Map<int, String>`
3. 空列表的 `asMap()` 方法返回正确的泛型类型
4. 混合类型列表的类型安全性

## 影响范围

这个修复确保了：
- 类型安全：编译时类型检查正确
- 功能正确性：运行时行为符合预期
- 代码一致性：转换后的代码与原始代码语义一致

## 预防措施

在代码转换过程中，需要特别注意：
1. 泛型参数的保持
2. 类型声明的完整性
3. 变量初始化的类型一致性
