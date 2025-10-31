# Dart2Cpp Quick Start Guide

## 项目结构

已成功整理dart2cpp项目结构如下：

```
/Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2cpp/
├── bin/                          # 可执行脚本
│   ├── dart2cpp.dart            # 主转换工具
│   ├── dart2bytecode.dart       # 字节码编译器
│   └── dump_bytecode.dart       # 字节码转储工具
│
├── lib/                          # 核心库
│   ├── dart2cpp.dart            # 核心转换逻辑
│   ├── dart_to_cpp_compiler.dart
│   ├── unified_compiler.dart    # 统一编译器API
│   ├── compile_to_dart.dart     # Dart编译
│   ├── expression_converter_complete.dart
│   └── optimizers/              # 优化模块
│
├── test/                         # 测试目录（已整理）
│   ├── *.dart                   # 所有测试文件
│   ├── build_and_run.dart       # 转换和构建脚本
│   ├── run_tests.dart           # 测试套件
│   └── quick_verify.dart        # 快速验证脚本
│
├── cpp_project/                  # C++项目输出目录
│   ├── include/                 # 头文件
│   │   └── dart2cpp_runtime.h
│   ├── lib/                     # 实现文件
│   │   └── dart2cpp_runtime.cpp
│   ├── src/                     # 源文件
│   │   └── main.cpp
│   ├── build/                   # 构建目录
│   ├── CMakeLists.txt           # 构建配置
│   └── README.md                # C++项目说明
│
└── PROJECT_STRUCTURE.md         # 完整项目文档
```

## 快速开始

### 1. 转换Dart文件到C++

```bash
cd /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2cpp

# 转换单个文件
dart bin/dart2cpp.dart test/test_hello.dart

# 或指定输出文件
dart bin/dart2cpp.dart -o output.cpp test/test_hello.dart

# 启用优化
dart bin/dart2cpp.dart --optimize test/test_hello.dart

# 详细输出
dart bin/dart2cpp.dart --verbose test/test_hello.dart
```

### 2. 验证转换工具

```bash
dart bin/dart2cpp.dart --version
dart bin/dart2cpp.dart --features
```

### 3. 构建和运行C++项目

#### 使用CMake（推荐）

```bash
cd cpp_project

# 配置项目
cmake -B build

# 构建项目
cmake --build build

# 运行可执行文件
./build/dart2cpp_test
```

#### 使用g++直接编译

```bash
cd cpp_project

g++ -std=c++17 -I include -o dart2cpp_test src/*.cpp lib/*.cpp
./dart2cpp_test
```

### 4. 运行完整测试套件

```bash
# 转换所有测试文件并构建C++项目
dart test/build_and_run.dart

# 仅运行Dart测试
dart test/run_tests.dart
```

## C++运行库

运行时库提供了以下Dart类型的C++实现：

- **Object**: 所有对象的基类
- **String**: 字符串类型，支持连接和比较
- **Int**: 整数类型，支持算术运算
- **Double**: 双精度浮点类型
- **Bool**: 布尔类型，支持逻辑运算
- **List<T>**: 泛型列表/数组类型
- **Map<K, V>**: 泛型映射/字典类型（需要完整比较器实现）
- **print()**: 打印函数

## 示例

### Dart输入

```dart
void main() {
  print('Hello, World!');
  var x = 42;
  var y = x + 1;
  print('x = $x, y = $y');

  int age = 25;
  double height = 1.75;
  bool isStudent = true;
  String name = 'Alice';

  print('Name: $name, Age: $age, Height: $height, Is Student: $isStudent');

  var numbers = [1, 2, 3, 4, 5];
  print('Numbers: $numbers');
}
```

### 转换后的C++输出

生成的C++代码包含：
- 适当的类型转换
- 运行时库支持
- 正确的内存管理
- 可编译的C++17代码

## 支持的特性

✅ 基础类型转换（int, double, String, bool）
✅ 算术运算符（+, -, *, /, %）
✅ 比较运算符（==, !=, <, <=, >, >=）
✅ 逻辑运算符（&&, ||, !）
✅ 变量声明
✅ 函数定义
✅ 类定义
✅ 控制流（if/else, for, while）
✅ 字符串操作
✅ 集合字面量（List, Map, Set）
✅ 方法调用
✅ 字段访问
✅ 基础继承
✅ try-catch块

## 版本信息

- Dart2Cpp版本：2.0.0
- C++标准：17
- CMake最低版本：3.10

---

**创建日期**: 2025-10-30
**最后更新**: 2025-10-30
