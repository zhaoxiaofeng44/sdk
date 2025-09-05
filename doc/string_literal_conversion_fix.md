# 字符串字面量转换修复文档

## 问题描述

在转换完成的代码中仍然有直接使用字符串的情况，如：
```dart
if (this._list.isEmpty) return CppString.fromString("{}");
```

这些字符串字面量应该被转换成统一的格式：
```dart
CppString.fromCppUserData(CppApi.cppCharCodes("$escaped"))
```

## 问题分析

问题出现在两个地方：

1. **StringLiteral 处理**：在 `compile_to_dart.dart` 中，`StringLiteral` 的处理只是简单地返回转义后的字符串字面量，而不是转换为 `CppString.fromCppUserData` 格式。

2. **StaticInvocation 处理**：`CppString.fromString("...")` 调用没有被特殊处理，导致出现嵌套的调用格式：
   ```dart
   CppString.fromString(CppString.fromCppUserData(CppApi.cppCharCodes("...")))
   ```

## 修复方案

### 修复1：StringLiteral 处理

**文件**：`pkg/dart2bytecode/lib/compile_to_dart.dart`
**位置**：第3772-3780行

**修复前**：
```dart
} else if (expression is StringLiteral) {
  // 使用正确的字符串转义，不使用字符串替换
  final value = expression.value;
  final escaped = value
      .replaceAll('\\', '\\\\')
      .replaceAll('"', '\\"')
      .replaceAll('\n', '\\n')
      .replaceAll('\r', '\\r')
      .replaceAll('\t', '\\t');
  return '"$escaped"';
```

**修复后**：
```dart
} else if (expression is StringLiteral) {
  // 将字符串字面量转换为 CppString.fromCppUserData 格式
  final value = expression.value;
  final escaped = value
      .replaceAll('\\', '\\\\')
      .replaceAll('"', '\\"')
      .replaceAll('\n', '\\n')
      .replaceAll('\r', '\\r')
      .replaceAll('\t', '\\t');
  return 'CppString.fromCppUserData(CppApi.cppCharCodes("$escaped"))';
```

### 修复2：CppString.fromString 静态调用处理

**文件**：`pkg/dart2bytecode/lib/compile_to_dart.dart`
**位置**：第3706行之后

**新增代码**：
```dart
// 特殊处理 CppString.fromString 静态方法调用
if (originalClassName == 'CppString' && methodName == 'fromString') {
  // 如果参数是字符串字面量，直接转换为 fromCppUserData 格式
  if (expression.arguments.positional.isNotEmpty) {
    final firstArg = expression.arguments.positional.first;
    if (firstArg is StringLiteral) {
      final value = firstArg.value;
      final escaped = value
          .replaceAll('\\', '\\\\')
          .replaceAll('"', '\\"')
          .replaceAll('\n', '\\n')
          .replaceAll('\r', '\\r')
          .replaceAll('\t', '\\t');
      return 'CppString.fromCppUserData(CppApi.cppCharCodes("$escaped"))';
    } else {
      // 如果参数不是字符串字面量，保持原有逻辑
      final args = expression.arguments.positional
          .map((e) => _generateExpressionCode(e,
              replaceThis: replaceThis, asStatement: false))
          .join(', ');
      return 'CppString.fromString($args)';
    }
  }
}
```

## 修复效果

### 修复前

```dart
// 嵌套调用问题
if (this._length == 0) return CppString.fromString(CppString.fromCppUserData(CppApi.cppCharCodes("[]")));

// 字符串字面量问题
CppStringBuffer buffer = CppStringBuffer("[");
```

### 修复后

```dart
// 直接转换，无嵌套
if (this._length == 0) return CppString.fromCppUserData(CppApi.cppCharCodes("[]"));

// 统一格式
CppStringBuffer buffer = CppStringBuffer(CppString.fromCppUserData(CppApi.cppCharCodes("[")));
```

## 影响范围

修复影响以下字符串字面量：
- `"[]"` - 空数组的字符串表示
- `"{}"` - 空对象/集合的字符串表示
- `"["`, `"]"` - 数组的开始和结束标记
- `"{"`, `"}"` - 对象/集合的开始和结束标记
- `", "` - 分隔符
- `": "` - 键值对分隔符

## 测试验证

创建了 `test/string_literal_conversion_test.dart` 测试文件，验证：

1. ✅ 没有嵌套的 `CppString.fromString(CppString.fromCppUserData(...))` 调用
2. ✅ 所有预期的字符串字面量都被正确转换
3. ✅ 保留了合理的 `CppString.fromString` 调用（参数不是字符串字面量）

## 总结

此修复确保了：
1. **一致性**：所有字符串字面量都使用统一的 `CppString.fromCppUserData(CppApi.cppCharCodes("..."))` 格式
2. **正确性**：移除了不正确的嵌套调用
3. **兼容性**：保留了合理的 `CppString.fromString` 调用（如参数为 `CppApi.getCurrentStackTrace()`）

修复后的代码更加一致和正确，符合 C++ 字符串处理的预期格式。
