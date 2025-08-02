# StaticInvocation 修复总结

## 问题描述

在 `compile_to_dart.dart` 文件中，`StaticInvocation` 表达式的转换存在问题。当 `expression.target.enclosingClass` 为 `null` 时，会生成类似 `.identical(entry, self._first)` 这样的代码，缺少了类名前缀。

## 问题原因

在 `_expressionToString` 和 `_expressionToStringForOperator` 方法中，`StaticInvocation` 的处理逻辑如下：

```dart
return '${expression.target.enclosingClass?.name ?? ''}.${expression.target.name.text}($args)';
```

当 `expression.target.enclosingClass?.name` 为 `null` 或空字符串时，会生成 `.methodName(args)` 这样的代码，缺少了类名。

## 修复方案

修改了两个方法中的 `StaticInvocation` 处理逻辑：

### 修复前
```dart
return '${expression.target.enclosingClass?.name ?? ''}.${expression.target.name.text}($args)';
```

### 修复后
```dart
final className = expression.target.enclosingClass?.name;
if (className != null && className.isNotEmpty) {
  return '$className.${expression.target.name.text}($args)';
} else {
  // 对于没有类名的静态调用，直接使用方法名
  return '${expression.target.name.text}($args)';
}
```

## 修复位置

1. `lib/compile_to_dart.dart` 第 951-957 行
2. `lib/compile_to_dart.dart` 第 1472-1478 行

## 验证结果

修复后，生成的代码中：
- ✅ 正确的调用：`identical(entry, self._first)`
- ❌ 错误的调用：`.identical(entry, self._first)` （已消除）

## 影响范围

这个修复解决了所有静态方法调用中缺少类名的问题，包括但不限于：
- `identical()` 调用
- 其他静态方法调用
- 全局函数调用

## 测试验证

通过运行转换器并检查生成的代码，确认：
1. 不再有 `.identical` 这样的错误调用
2. 所有 `identical` 调用都正确生成为 `identical(args)`
3. 其他静态方法调用也得到正确处理 