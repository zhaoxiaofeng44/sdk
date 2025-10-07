# Dart 到 C++ 转换器使用指南

## 概述

`compile_to_cpp.dart` 是一个基于 `compile_to_dart.dart` 开发的 Dart 到 C++ 代码转换器，能够将 Dart 源码转换为可编译运行的 C++ 代码。该转换器特别支持 `@pragma('cpp:native')` 注解，允许开发者指定某些类使用 C++ 原生实现。

## 🎯 主要功能

### 1. 完整的 Dart 到 C++ 转换
- **类转换**: 将 Dart 类转换为 C++ 类
- **方法转换**: 支持实例方法、静态方法、构造函数和析构函数
- **字段转换**: 将 Dart 字段转换为 C++ 成员变量
- **类型映射**: 自动映射 Dart 类型到对应的 C++ 类型

### 2. 原生类支持
- **@pragma('cpp:native') 注解**: 标记需要使用 C++ 原生实现的类
- **原生类声明**: 为原生类生成前向声明
- **混合编程**: 支持 Dart 类和 C++ 原生类的混合使用

### 3. 代码生成优化
- **头文件分离**: 自动生成 `.h` 头文件和 `.cpp` 实现文件
- **命名空间**: 使用 `dart_cpp` 命名空间避免命名冲突
- **包含管理**: 自动管理必要的 C++ 头文件包含

## 🏗️ 架构设计

### 核心组件

```dart
/// 主转换器类
class DartToCppTransformer {
  // 处理器实例
  CppExpressionProcessor _expressionProcessor;
  CppStatementProcessor _statementProcessor;
  CppCodeGenerator _codeGenerator;
  CppGlobalStateManager _globalState;
}
```

### 处理器架构

1. **CppExpressionProcessor**: 处理各种表达式转换
2. **CppStatementProcessor**: 处理语句转换
3. **CppCodeGenerator**: 负责代码格式化和输出
4. **CppGlobalStateManager**: 管理全局状态和映射

## 📋 类型映射表

| Dart 类型 | C++ 类型 | 说明 |
|-----------|----------|------|
| `int` | `int64_t` | 64位整数 |
| `double` | `double` | 双精度浮点数 |
| `bool` | `bool` | 布尔值 |
| `String` | `std::string` | 标准字符串 |
| `void` | `void` | 空类型 |
| `dynamic` | `std::any` | 任意类型 |
| `Object` | `DartObject*` | Dart 对象指针 |
| `List<T>` | `std::vector<T>` | 动态数组 |
| `Map<K,V>` | `std::unordered_map<K,V>` | 哈希映射 |
| `Set<T>` | `std::unordered_set<T>` | 哈希集合 |

## 🚀 使用方法

### 1. 基本使用

```dart
import 'package:dart2bytecode/compile_to_cpp.dart';

// 转换 Dart 组件为 C++ 代码
String cppCode = transformDartToCpp(component);

// 写入文件
await writeCppToFile(cppCode);
```

### 2. 原生类注解

```dart
// 标记为原生 C++ 类
@pragma('cpp:native', 'CppApiImpl')
class NativeApi {
  void nativeMethod();
  int nativeCalculation(int a, int b);
}

// 普通 Dart 类（会被转换为 C++）
class RegularClass {
  int value;
  
  RegularClass(this.value);
  
  int getValue() {
    return value;
  }
}
```

### 3. 生成的 C++ 代码结构

```cpp
// 生成的头文件部分
#include <iostream>
#include <string>
#include <vector>
// ... 其他标准头文件

namespace dart_cpp {

// 前向声明
class RegularClass;

// 装箱类
class BoxInt {
public:
    int64_t value;
    BoxInt(int64_t val = 0) : value(val) {}
};

// 原生类声明
// Native class: NativeApi
// C++ implementation should be provided externally
class CppApiImpl;

// 转换后的类
class RegularClass {
private:
    int64_t value;

public:
    RegularClass(int64_t value);
    virtual ~RegularClass();
    
    int64_t getValue();
};

} // namespace dart_cpp
```

```cpp
// 生成的实现文件部分
namespace dart_cpp {

// 构造函数实现
RegularClass::RegularClass(int64_t value) : value(value) {
}

// 析构函数实现
RegularClass::~RegularClass() {
    // Destructor
}

// 方法实现
int64_t RegularClass::getValue() {
    return value;
}

} // namespace dart_cpp
```

## 🔧 高级功能

### 1. 装箱类型支持

转换器自动为基本类型生成装箱类，支持闭包捕获：

```cpp
class BoxInt {
public:
    int64_t value;
    BoxInt(int64_t val = 0) : value(val) {}
};
```

### 2. 命名冲突处理

- 自动检测 C++ 关键字冲突
- 为冲突的标识符添加后缀 `_`
- 使用命名空间避免全局命名冲突

### 3. 内存管理

- 自动生成构造函数和析构函数
- 支持 RAII 资源管理模式
- 智能指针支持（计划中）

## 📝 示例项目

### Dart 源码 (`cpp_test.dart`)

```dart
@pragma('cpp:native', 'CppApi')
class NativeApi {
  void nativeMethod();
}

class Calculator {
  double add(double a, double b) {
    return a + b;
  }
  
  bool isPositive(double number) {
    return number > 0.0;
  }
}

void main() {
  Calculator calc = Calculator();
  double result = calc.add(10.5, 20.3);
}
```

### 生成的 C++ 代码

```cpp
#include <iostream>
#include <string>
#include <vector>
// ... 其他头文件

namespace dart_cpp {

// Native class: NativeApi
class CppApi;

class Calculator {
public:
    Calculator();
    virtual ~Calculator();
    
    double add(double a, double b);
    bool isPositive(double number);
};

// 实现
Calculator::Calculator() {
}

Calculator::~Calculator() {
}

double Calculator::add(double a, double b) {
    return a + b;
}

bool Calculator::isPositive(double number) {
    return number > 0.0;
}

} // namespace dart_cpp
```

## 🎯 使用场景

### 1. 性能关键应用
- 将 Dart 算法转换为 C++ 以获得更好的性能
- 保持 Dart 的开发便利性，获得 C++ 的执行效率

### 2. 混合编程
- 部分功能使用 C++ 原生实现（通过 `@pragma('cpp:native')`）
- 其他功能自动从 Dart 转换
- 无缝集成现有的 C++ 库

### 3. 跨平台部署
- 将 Dart 应用转换为可在任何支持 C++ 的平台运行
- 减少运行时依赖
- 更好的部署灵活性

## ⚠️ 注意事项

### 1. 当前限制
- 复杂的 Dart 特性（如泛型、异步）支持有限
- 某些 Dart 标准库功能需要手动实现
- 生成的代码可能需要手动优化

### 2. 原生类实现
- 标记为 `@pragma('cpp:native')` 的类需要提供 C++ 实现
- 原生类的接口必须与 Dart 声明匹配
- 需要处理 Dart 和 C++ 之间的数据类型转换

### 3. 编译要求
- 需要 C++17 或更高版本的编译器
- 需要链接适当的标准库
- 可能需要额外的构建配置

## 🔮 未来计划

### 1. 功能增强
- [ ] 完整的泛型支持
- [ ] 异步/Future 支持
- [ ] 更完善的标准库映射
- [ ] 智能指针和内存管理优化

### 2. 工具改进
- [ ] 集成构建系统支持
- [ ] 调试信息生成
- [ ] 性能分析工具
- [ ] 自动化测试框架

### 3. 生态系统
- [ ] 常用库的 C++ 实现
- [ ] 包管理器集成
- [ ] IDE 插件支持
- [ ] 文档和教程完善

## 📚 相关资源

- [Dart Language Specification](https://dart.dev/guides/language/spec)
- [C++ Reference](https://en.cppreference.com/)
- [Kernel AST Documentation](https://github.com/dart-lang/sdk/tree/main/pkg/kernel)

## 🤝 贡献指南

欢迎贡献代码、报告问题或提出改进建议：

1. Fork 项目仓库
2. 创建功能分支
3. 提交更改
4. 创建 Pull Request

## 📄 许可证

本项目遵循与 Dart SDK 相同的许可证。
