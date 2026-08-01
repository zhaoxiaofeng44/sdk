# 项目上下文

## Purpose
dart2cpp 是一个完整的 Dart 到 C++ 的转换编译器和运行时库项目。项目目标是：
- 将 Dart 代码转换为高性能的 C++ 代码
- 提供完整的 C++ 运行时库，支持 Dart 的核心类型和语法特性
- 实现 Dart 语言特性到 C++ 的映射，包括类型系统、异步编程、OOP 特性等
- 为 Dart 开发者提供一个可以生成原生 C++ 代码的工具链

## 技术栈
- **主语言**: Dart (SDK >=3.0.0 <4.0.0)
- **目标语言**: C++ (C++20)
- **构建工具**: 
  - Dart: pub
  - C++: g++ (直接编译，无 CMake/Make)
- **核心依赖**:
  - kernel: Dart 内核表示 (via local path override)
  - front_end: Dart 前端编译器 (via local path override)
  - _fe_analyzer_shared: 前端分析器共享组件 (via local path override)
  - lints: 代码规范检查
  - test: 测试框架
- **测试框架**: 自定义脚本 (dart run test/run_all_restorer_tests.dart)

## 项目约定

### 代码风格
- **Dart 代码**:
  - 遵循 Dart 官方代码风格指南
  - 使用 analysis_options.yaml 进行静态分析
  - 命名约定：类名使用 PascalCase，变量和函数使用 camelCase
- **C++ 代码**:
  - 使用现代 C++ 特性 (C++20)
  - 使用标记-清除 GC 管理内存 (AnyGC 基类 + GC::collect)
  - 命名约定：类名使用 PascalCase，函数使用 camelCase
  - 头文件使用 .h 扩展名 (单一头文件: dart2cpp_lowered.h)

### 架构模式
- **分层架构**:
  - `lib/`: Dart 转换器核心库（编译器前端）
    - `lib/restorer/`: 核心转换器实现 (part-of 结构)
    - `lib/platform/dart/`: Dart 运行时 (runtime_classes.dart)
    - `lib/platform/cpp/`: C++ 运行时 (dart2cpp_lowered.h)
  - `test/`: 测试套件 (15 个测试用例)
  - `tool/`: 开发工具
  - `sample/`: 转换示例
- **核心组件**:
  - `dart_restorer.dart`: 主恢复器类 + 共享状态
  - `declaration_restorer.dart`: 声明恢复 (类、方法、字段、构造函数)
  - `expression_restorer.dart`: 表达式恢复
  - `statement_restorer.dart`: 语句恢复
  - `cpp_emitter.dart`: C++ 代码发射器
  - `type_utils.dart`: 类型映射工具

### 测试策略
- **Dart 测试**: 使用 `dart test/run_all_restorer_tests.dart` 运行
  - 11 个批量测试 + 4 个独立测试 (gc_test, gc_async_test, promise_enhanced_test, mixin_lowering_test)
  - 测试流程: 编译 → 恢复 → 运行 → 比较输出
- **C++ 测试**: 
  - 使用 `run_all_cpp_tests.sh` 编译运行 C++ 输出
  - 测试 C++ 代码生成和运行时正确性
- **集成测试**: 
  - 使用自动化脚本进行端到端测试
  - 测试完整的转换-编译-运行流程

### Git 工作流
- 主分支开发模式
- 提交信息应清晰描述变更内容
- 重大功能变更应包含相应的测试用例

## 领域上下文

### 编译器领域知识
- **AST (抽象语法树)**: Dart 代码首先被解析为 Kernel AST
- **类型推断**: 需要处理 Dart 的类型推断和 C++ 的静态类型
- **内存管理**: Dart 使用 GC，C++ 使用标记-清除 GC (AnyGC + GC::collect)
- **泛型擦除**: Dart 泛型在运行时保留，C++ 泛型在编译时实例化

### Dart 到 C++ 映射
- `int` → `int64_t` (64位整数)
- `double` → `double` (64位浮点数)
- `bool` → `bool` (布尔值)
- `String` → `StringBox` / `std::string` (字符串)
- `List<T>` → `StaticList<T>` (列表)
- `Set<T>` → `StaticSet<T>` (集合)
- `Map<K,V>` → `StaticMap<K,V>` (映射)
- `Future<T>` → `Promise<T>` (异步)
- 自定义类 → `AnyGC` 子类 + vptr 虚函数表

## 重要约束
- **不支持的 Dart 特性**:
  - 反射 (Reflection)
  - IntersectionType / ExtensionType (Dart 3.3+)
  - 函数类型 arity > 16 降级为基础类型
- **异步功能**: 通过 Promise + GlobalScheduler + AsyncStateMachine 实现
- **内存管理**: 标记-清除 GC，所有堆对象继承 AnyGC 并通过 GC::allocateLocal 注册
- **兼容性**: 需要 C++20 或更高版本的编译器 (GCC, Clang)

## 外部依赖
- **Dart SDK**: 依赖 Dart SDK 的前端编译器组件
  - `_fe_analyzer_shared`: 前端分析器共享组件
  - `front_end`: Dart 前端编译器
  - `kernel`: Dart 内核表示
- **C++ 编译器**: 需要支持 C++20 的编译器 (GCC, Clang)
