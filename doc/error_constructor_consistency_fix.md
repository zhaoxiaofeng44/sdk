# 错误类构造方法一致性修复文档

## 问题描述

在 `pkg/dart2bytecode/lib/demo/error.dart` 文件中，`CppIndexError` 类的构造方法与 `CppRangeError` 类不一致：

**修复前：**
```dart
@pragma('cpp:patch', 'RangeError')
class CppRangeError extends CppError {
  CppString message;
  CppRangeError(this.message);
}

@pragma('cpp:patch', 'IndexError')
class CppIndexError extends CppError {}
```

`CppRangeError` 有完整的构造方法和 `message` 字段，而 `CppIndexError` 只有一个空的类定义，缺少构造方法和字段。

## 问题分析

这种不一致性会导致：
1. **代码结构不统一**：相似的错误类有不同的实现模式
2. **使用困难**：`CppIndexError` 无法携带错误信息
3. **维护问题**：开发者需要记住不同类的不同构造方式
4. **扩展性差**：未来如果需要为 `CppIndexError` 添加功能，需要重构

## 修复方案

为 `CppIndexError` 添加与 `CppRangeError` 完全一致的构造方法和字段。

**修复后：**
```dart
@pragma('cpp:patch', 'RangeError')
class CppRangeError extends CppError {
  CppString message;
  CppRangeError(this.message);
}

@pragma('cpp:patch', 'IndexError')
class CppIndexError extends CppError {
  CppString message;
  CppIndexError(this.message);
}
```

## 修复详情

### 文件位置
- **文件**：`pkg/dart2bytecode/lib/demo/error.dart`
- **修改行**：第35-37行

### 具体修改
```diff
@pragma('cpp:patch', 'IndexError')
- class CppIndexError extends CppError {}
+ class CppIndexError extends CppError {
+   CppString message;
+   CppIndexError(this.message);
+ }
```

## 修复效果

### 修复前
```dart
class CppIndexError extends CppError {}
```

### 修复后
```dart
class CppIndexError extends CppError {
  late CppString message;
  CppIndexError(CppString message) : message = message, super() {
    ;
  }
}
```

## 一致性验证

修复后，两个类的结构完全一致：

| 特性 | CppRangeError | CppIndexError |
|------|---------------|---------------|
| 继承关系 | extends CppError | extends CppError |
| 字段 | `late CppString message` | `late CppString message` |
| 构造方法 | `CppRangeError(CppString message)` | `CppIndexError(CppString message)` |
| 初始化 | `: message = message, super()` | `: message = message, super()` |

## 测试验证

创建了 `test/error_constructor_test.dart` 测试文件，验证：

1. ✅ `CppRangeError` 类定义完整且正确
2. ✅ `CppIndexError` 类定义完整且正确
3. ✅ 两个类的构造方法完全一致
4. ✅ 两个类的字段声明完全一致

## 影响范围

此修复影响：
- **CppIndexError 类**：从空类变为具有完整功能的错误类
- **相关使用代码**：现在可以创建带有错误信息的 `CppIndexError` 实例
- **代码一致性**：错误类的实现模式更加统一

## 使用示例

修复后，可以这样使用 `CppIndexError`：

```dart
// 创建带有错误信息的 IndexError
final indexError = CppIndexError(CppString.fromCppUserData(CppApi.cppCharCodes("Index out of range")));

// 访问错误信息
print(indexError.message.toCppString());
```

## 总结

此修复确保了：
1. **一致性**：`CppIndexError` 和 `CppRangeError` 具有完全相同的结构
2. **功能性**：`CppIndexError` 现在可以携带和显示错误信息
3. **可维护性**：代码结构更加统一，便于维护和扩展
4. **用户体验**：开发者可以使用相同的模式处理不同类型的错误

修复后的代码更加规范、一致，符合面向对象设计的最佳实践。
