# Dart到静态Dart转换器总结

## 概述

本转换器将Dart代码转换为静态方法形式的Dart代码，主要功能包括：

1. **运算符重载转换为普通方法**：将 `operator []`、`operator []=`、`operator +` 等运算符重载转换为对应的静态方法
2. **成员方法转换为静态方法**：将所有成员方法转换为静态方法，添加 `self` 参数
3. **字段处理**：正确处理字段声明，包括初始值
4. **getter/setter处理**：保持getter和setter的功能

## 转换规则

### 运算符重载转换

| 原运算符 | 转换后方法 |
|---------|-----------|
| `operator []` | `getElement(self, index)` |
| `operator []=` | `setElement(self, index, value)` |
| `operator +` | `add(self, other)` |
| `operator -` | `subtract(self, other)` |
| `operator *` | `multiply(self, other)` |
| `operator /` | `divide(self, other)` |
| `operator ==` | `equals(self, other)` |
| `operator !=` | `notEquals(self, other)` |
| `operator <` | `lessThan(self, other)` |
| `operator >` | `greaterThan(self, other)` |
| `operator <=` | `lessThanOrEqual(self, other)` |
| `operator >=` | `greaterThanOrEqual(self, other)` |

### 方法转换

- 所有成员方法转换为静态方法
- 添加 `self` 参数作为第一个参数
- 保持原有的参数列表和返回类型

### 字段处理

- 保持字段声明
- 为未初始化的字段提供默认值
- 正确处理 `final` 字段

### getter/setter处理

- 保持getter和setter的语法
- 转换为静态方法形式

## 使用示例

### 输入代码
```dart
class CppList {
  int _length = 0;
  dynamic _array;

  CppList();

  int get length => _length;

  void add(dynamic value) {
    _length++;
  }

  dynamic operator [](int index) {
    return _array;
  }

  void operator []=(int index, dynamic value) {
    _array = value;
  }
}
```

### 输出代码
```dart
class CppList {
  int _length = 0;
  dynamic _array;
  int get length => _length;

  CppList();

  static CppList create() {
    final instance = CppList();
    return instance;
  }

  static void add(CppList self, dynamic value) {
    self._length++;
  }

  static dynamic getElement(CppList self, int index) {
    return self._array;
  }

  static void setElement(CppList self, int index, dynamic value) {
    self._array = value;
  }
}
```

## 转换器组件

### 主要文件

1. **`lib/compile_to_dart.dart`**：核心转换器
   - `DartToDartTransformer` 类：主要的转换逻辑
   - 处理Kernel AST节点
   - 表达式和语句转换

2. **`bin/dart2dart.dart`**：命令行工具
   - 文件读取和写入
   - 简化的转换逻辑
   - 正则表达式基础的转换

### 转换流程

1. **解析输入**：读取Dart源文件
2. **提取类信息**：使用正则表达式提取类、字段、方法
3. **转换方法**：将成员方法转换为静态方法
4. **转换运算符**：将运算符重载转换为普通方法
5. **生成输出**：生成转换后的Dart代码

## 当前状态

✅ **已完成功能**：
- 基本的类转换
- 运算符重载转换为方法
- 字段处理
- getter/setter处理
- 静态方法生成

⚠️ **已知问题**：
- getter提取正则表达式需要优化
- 复杂表达式的处理需要增强
- 某些AST节点的处理需要完善

🔧 **待改进**：
- 增强表达式转换能力
- 完善错误处理
- 优化代码生成质量
- 添加更多测试用例

## 使用方法

```bash
# 转换单个文件
dart bin/dart2dart.dart transform input.dart

# 查看帮助
dart bin/dart2dart.dart --help
```

## 测试

转换器已经通过基本测试，能够正确处理：
- 简单的类定义
- 运算符重载
- 字段声明
- getter/setter
- 静态方法生成

生成的代码符合Dart语法，可以通过 `dart analyze` 检查。 