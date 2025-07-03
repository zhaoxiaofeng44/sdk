# CppStringBuffer 实现文档

## 概述

`CppStringBuffer` 是一个自定义的字符串缓冲区实现，功能与 Dart 标准库中的 `StringBuffer` 完全一致。它使用 `CppList<String>` 来存储字符串片段，并通过 `list.join` 方法来实现 `toString` 功能。

## 类定义

```dart
class CppStringBuffer {
  final CppList<String> _parts;
  
  CppStringBuffer();
  CppStringBuffer.fromCppString(String str);
}
```

## 核心特性

### 1. 内部实现
- 使用 `CppList<String> _parts` 存储字符串片段
- 每个 `write` 操作都会将内容作为新的字符串片段添加到列表中
- `toString` 方法使用 `_parts.join('')` 将所有片段连接

### 2. 与标准StringBuffer兼容
- 实现了所有标准 `StringBuffer` 的方法
- 行为与标准 `StringBuffer` 完全一致
- 支持链式调用和复杂字符串构建

## 实现的方法

### 构造函数
- `CppStringBuffer()` - 创建空的字符串缓冲区
- `CppStringBuffer.fromCppString(String str)` - 从现有字符串创建缓冲区

### 写入方法
- `void write(Object? obj)` - 写入对象（转换为字符串）
- `void writeAll(Iterable objects, [String separator = ""])` - 写入多个对象，可选分隔符
- `void writeCharCode(int charCode)` - 写入字符代码
- `void writeln([Object? obj = ""])` - 写入对象并添加换行符

### 管理方法
- `void clear()` - 清空缓冲区
- `String toString()` - 将所有片段连接为字符串

### 属性
- `int get length` - 获取总字符串长度
- `bool get isEmpty` - 检查是否为空
- `bool get isNotEmpty` - 检查是否非空

## 使用示例

### 基本使用
```dart
var sb = CppStringBuffer();
sb.write("Hello");
sb.write(" ");
sb.write("World");
print(sb.toString()); // 输出: "Hello World"
```

### 使用writeAll
```dart
var sb = CppStringBuffer();
sb.writeAll(["Hello", "World", "Dart"], " ");
print(sb.toString()); // 输出: "Hello World Dart"
```

### 使用writeCharCode
```dart
var sb = CppStringBuffer();
sb.writeCharCode(72); // 'H'
sb.writeCharCode(101); // 'e'
sb.writeCharCode(108); // 'l'
sb.writeCharCode(108); // 'l'
sb.writeCharCode(111); // 'o'
print(sb.toString()); // 输出: "Hello"
```

### 使用writeln
```dart
var sb = CppStringBuffer();
sb.writeln("Hello");
sb.writeln("World");
print(sb.toString()); // 输出: "Hello\nWorld\n"
```

### 复杂场景
```dart
var sb = CppStringBuffer();
sb.write("开始");
sb.writeAll(["Hello", "World"], " ");
sb.writeCharCode(33); // '!'
sb.writeln();
sb.write("结束");
print(sb.toString()); // 输出: "开始Hello World !\n结束"
```

## 性能特性

### 内存管理
- 使用 `CppList` 进行动态内存管理
- 初始容量为16个字符串片段
- 支持自动扩容

### 时间复杂度
- `write` 操作: O(1) 平均，O(n) 最坏（扩容时）
- `toString` 操作: O(n)，其中 n 是总字符串长度
- `clear` 操作: O(1)

## 与标准StringBuffer的对比

| 特性 | CppStringBuffer | 标准StringBuffer |
|------|----------------|------------------|
| 内部存储 | CppList<String> | 内部字符串缓冲区 |
| toString实现 | list.join('') | 内部字符串连接 |
| 内存管理 | CppList管理 | 内部缓冲区管理 |
| 功能完整性 | 完全兼容 | 标准实现 |
| C++互操作 | 支持 | 不支持 |

## 测试覆盖

所有方法都通过了完整的测试验证，包括：
- 基本write操作测试
- writeAll操作测试（带分隔符和无分隔符）
- writeCharCode操作测试
- writeln操作测试
- clear操作测试
- length属性测试
- isEmpty/isNotEmpty测试
- fromCppString构造函数测试
- 复杂场景测试

## 注意事项

1. 该实现完全兼容标准的Dart StringBuffer接口
2. 支持所有StringBuffer的标准操作
3. 使用CppList作为底层存储，便于C++互操作
4. 性能特性与标准StringBuffer相似
5. 适用于需要C++互操作的字符串构建场景

## 扩展可能性

- 可以添加更多StringBuffer的扩展方法
- 可以优化特定场景下的性能
- 可以添加自定义的分隔符和格式化选项 