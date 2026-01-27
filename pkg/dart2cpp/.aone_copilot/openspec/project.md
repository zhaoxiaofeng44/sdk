# 项目上下文

## Purpose
dart2cpp 是一个完整的 Dart 到 C++ 的转换编译器和运行时库项目。项目目标是：
- 将 Dart 代码转换为高性能的 C++ 代码
- 提供完整的 C++ 运行时库，支持 Dart 的核心类型和语法特性
- 实现 Dart 语言特性到 C++ 的映射，包括类型系统、异步编程、OOP 特性等
- 为 Dart 开发者提供一个可以生成原生 C++ 代码的工具链

## 技术栈
- **主语言**: Dart (SDK >=3.0.0 <4.0.0)
- **目标语言**: C++ (C++17/C++20)
- **构建工具**: 
  - Dart: pub
  - C++: CMake, Make
- **核心依赖**:
  - args: 命令行参数解析
  - path: 路径处理
  - meta: 元数据注解
  - front_end: Dart 前端编译器
  - kernel: Dart 内核表示
  - vm: Dart 虚拟机相关
- **测试框架**: Dart test

## 项目约定

### 代码风格
- **Dart 代码**:
  - 遵循 Dart 官方代码风格指南
  - 使用 analysis_options.yaml 进行静态分析
  - 命名约定：类名使用 PascalCase，变量和函数使用 camelCase
- **C++ 代码**:
  - 使用现代 C++ 特性 (C++17/C++20)
  - 智能指针管理内存 (ObjectPtr)
  - 命名约定：类名使用 PascalCase，函数使用 camelCase
  - 头文件使用 .h 扩展名，实现文件使用 .cpp

### 架构模式
- **分层架构**:
  - `lib/`: Dart 转换器核心库（编译器前端）
  - `bin/`: 命令行工具入口
  - `cpp/core/`: C++ 运行时库（目标代码运行环境）
  - `cpp/test/`: C++ 单元测试
  - `test/`: Dart 单元测试
- **核心组件**:
  - `dart_to_cpp_compiler.dart`: 主编译器逻辑
  - `expressions.dart`: 表达式转换
  - `declarations.dart`: 声明转换
  - `generics.dart`: 泛型处理
  - `cpp/core/object.h/cpp`: 基础类型系统
  - `cpp/core/dart_syntax_*.h`: Dart 语法糖支持

### 测试策略
- **Dart 测试**: 使用 `dart test` 运行单元测试
- **C++ 测试**: 
  - 使用 Make/CMake 构建测试
  - 测试文件位于 `cpp/test/`
  - 包括基础类型测试、集合测试、异步测试等
- **集成测试**: 
  - 使用自动化脚本 `scripts/dart_to_cpp_run.sh` 进行端到端测试
  - 测试完整的转换-编译-运行流程

### Git 工作流
- 主分支开发模式
- 提交信息应清晰描述变更内容
- 重大功能变更应包含相应的测试用例

## 领域上下文

### 编译器领域知识
- **AST (抽象语法树)**: Dart 代码首先被解析为 AST
- **类型推断**: 需要处理 Dart 的类型推断和 C++ 的静态类型
- **内存管理**: Dart 使用 GC，C++ 使用引用计数的智能指针
- **泛型擦除**: Dart 泛型在运行时保留，C++ 泛型在编译时实例化

### Dart 到 C++ 映射
- `int` → `Int` (32位整数)
- `double` → `Double` (64位浮点数)
- `bool` → `Bool` (布尔值)
- `String` → `String` (字符串，带字符串池优化)
- `List<T>` → `ObjectPtr<List<T>>` (列表)
- `Set<T>` → `ObjectPtr<Set<T>>` (集合)
- `Map<K,V>` → `ObjectPtr<Map<K,V>>` (映射)
- 自定义类 → `ObjectPtr<CustomClass>` (用户类)

## 重要约束
- **不支持的 Dart 特性**:
  - 反射 (Reflection)
  - 部分高级语法需要手动调整
  - 泛型支持有限
- **异步功能**: 为简化实现，异步支持是简化版本
- **性能考虑**: 
  - 使用字符串池优化字符串操作
  - 引用计数内存管理
  - 智能指针避免内存泄漏
- **兼容性**: 需要 C++17 或更高版本的编译器

## 外部依赖
- **Dart SDK**: 依赖 Dart SDK 的前端编译器组件
  - `_fe_analyzer_shared`: 前端分析器共享组件
  - `front_end`: Dart 前端编译器
  - `kernel`: Dart 内核表示
  - `vm`: Dart 虚拟机相关
- **C++ 编译器**: 需要支持 C++17/C++20 的编译器 (GCC, Clang, MSVC)
- **构建工具**: CMake 3.10+ 或 Make
