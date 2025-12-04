# Dart2CPP 项目架构概述

## 🏗️ 整体架构

Dart2CPP 是一个完整的 Dart 到 C++ 代码转换器，采用模块化设计，主要包含以下核心组件：

```
dart2cpp/
├── lib/                    # Dart 转换器核心库
│   ├── dart2cpp.dart      # 主库文件和命令行入口
│   ├── dart_to_cpp_compiler.dart  # 核心转换器
│   ├── declarations.dart   # 声明处理模块
│   ├── expression_converter_complete.dart  # 表达式转换
│   ├── unified_compiler.dart  # 统一编译器API
│   └── optimizers/        # 优化器模块
├── bin/                   # 可执行脚本
│   └── dart2cpp.dart     # 命令行工具
├── cpp/                   # C++ 运行时库
│   ├── core/             # 核心运行时库
│   ├── test/             # C++ 测试
│   └── examples/         # C++ 示例
└── sample/               # 示例和测试用例
    └── dart/             # Dart 示例代码
```

## 🔧 核心组件

### 1. Dart 转换器 (lib/)

**主要职责**: 将 Dart 代码解析并转换为等价的 C++ 代码

#### 核心模块：

- **`dart2cpp.dart`**: 主入口点，处理命令行参数和编译流程
- **`dart_to_cpp_compiler.dart`**: 核心转换器，基于 Dart Kernel AST 进行转换
- **`declarations.dart`**: 处理类、函数、变量等声明的转换
- **`expression_converter_complete.dart`**: 处理各种表达式的转换
- **`unified_compiler.dart`**: 提供统一的编译器 API

#### 转换流程：

```
Dart 源码 → Kernel AST → C++ AST → C++ 代码
    ↓           ↓           ↓          ↓
  解析      类型分析    代码生成    优化输出
```

### 2. C++ 运行时库 (cpp/core/)

**主要职责**: 提供与 Dart 语义等价的 C++ 类型系统和运行时支持

#### 核心文件：

- **`dart2cpp.h`**: 主头文件，包含所有核心组件
- **`object.h/cpp`**: 基础类型定义和实现 (Int, Double, Bool, String, List, Set, Map)
- **`dart_macros.h`**: Dart 语法糖宏定义
- **`dart_helpers.h`**: 辅助工具函数
- **`dart_async.h`**: 异步编程支持
- **`dart_oop_extensions.h`**: OOP 特性支持

#### 类型系统：

```cpp
// 基础类型层次
Any (基类)
├── Nullable (空值类型)
├── Int (整数类型)
├── Double (浮点数类型)
├── Bool (布尔类型)
├── String (字符串类型)
└── ObjectPtr<T> (智能指针，用于复杂类型)
    ├── List<T> (列表类型)
    ├── Set<T> (集合类型)
    └── Map<K,V> (映射类型)
```

### 3. 命令行工具 (bin/)

**主要职责**: 提供用户友好的命令行界面

#### 功能特性：

- 文件转换：`dart2cpp input.dart -o output.cpp`
- 配置选项：优化、运行时库包含、详细输出等
- 错误处理和诊断信息
- 版本和特性查询

## 🔄 数据流

### 编译流程：

1. **输入处理**: 解析命令行参数，验证输入文件
2. **前端分析**: 使用 Dart 前端将源码编译为 Kernel AST
3. **类型分析**: 分析类型信息，构建符号表
4. **代码转换**: 遍历 AST，生成对应的 C++ 代码
5. **优化处理**: 应用各种优化策略
6. **代码生成**: 输出最终的 C++ 代码

### 转换映射：

| Dart 概念 | C++ 映射 | 说明 |
|----------|---------|------|
| `int` | `Int` | 32位整数，支持所有算术运算 |
| `double` | `Double` | 64位浮点数 |
| `bool` | `Bool` | 布尔值，支持隐式转换 |
| `String` | `String` | 字符串，带字符串池优化 |
| `List<T>` | `ObjectPtr<List<T>>` | 动态数组 |
| `Map<K,V>` | `ObjectPtr<Map<K,V>>` | 哈希映射 |
| `var x = 42` | `auto x = dart_int(42)` | 类型推断 |
| `x?.method()` | `dart_null_check(x, x.method())` | 空安全操作 |

## 🎯 设计原则

### 1. 语义保持
- 确保转换后的 C++ 代码与原 Dart 代码具有相同的运行时行为
- 保持 Dart 的类型安全和空安全特性

### 2. 性能优化
- 使用智能指针管理内存，避免内存泄漏
- 字符串池优化，减少字符串创建开销
- 支持编译时优化和运行时优化

### 3. 可读性
- 生成的 C++ 代码保持良好的可读性
- 使用宏简化常见操作
- 提供清晰的错误信息和调试支持

### 4. 扩展性
- 模块化设计，便于添加新特性
- 插件化的优化器架构
- 支持自定义类型映射

## 🔧 技术栈

### Dart 端：
- **Dart SDK**: 2.17.0+
- **kernel**: Dart 内核 AST 库
- **front_end**: Dart 前端编译器
- **args**: 命令行参数解析

### C++ 端：
- **C++17**: 使用现代 C++ 特性
- **STL**: 标准模板库
- **智能指针**: 自动内存管理
- **模板元编程**: 类型安全和性能优化

## 📊 性能特征

### 编译性能：
- 支持增量编译
- 并行化处理
- 内存高效的 AST 遍历

### 运行时性能：
- 零开销抽象
- 内联优化
- 引用计数内存管理

### 内存使用：
- 字符串池减少内存占用
- 智能指针自动管理生命周期
- 延迟初始化减少启动开销

## 🔮 未来扩展

### 计划中的特性：
- 更完整的泛型支持
- 异步编程完整实现
- 反射和元编程支持
- 更多标准库映射
- 调试信息生成
- 跨平台构建支持
