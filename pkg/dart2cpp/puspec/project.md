# dart2cpp 项目技术规范

> **版本**: 1.0.0  
> **最后更新**: 2026-01-27  
> **项目**: dart2cpp - Dart 到 C++ 转换编译器和运行时库

---

## 1. 项目概述

### 1.1 项目定位
dart2cpp 是一个完整的 Dart 到 C++ 的转换编译器和运行时库项目，旨在将 Dart 代码转换为高性能的原生 C++ 代码。

### 1.2 核心目标
- 将 Dart 代码转换为高性能的 C++ 代码
- 提供完整的 C++ 运行时库，支持 Dart 的核心类型和语法特性
- 实现 Dart 语言特性到 C++ 的映射（类型系统、异步编程、OOP 特性）
- 为 Dart 开发者提供可生成原生 C++ 代码的工具链

### 1.3 业务价值
- **性能优化**：通过 C++ 编译获得原生性能
- **跨平台部署**：生成可在多平台运行的 C++ 代码
- **代码复用**：Dart 代码可转换为 C++ 在更多场景使用
- **工具链完整**：提供从转换到编译运行的完整工具链

---

## 2. 技术栈

### 2.1 主要技术

#### 2.1.1 源语言 - Dart
- **版本**: SDK >=3.0.0 <4.0.0
- **用途**: 编译器实现语言、源代码语言
- **核心依赖**:
  - `kernel`: Dart 内核表示（AST）
  - `front_end`: Dart 前端编译器
  - `_fe_analyzer_shared`: 前端分析器共享组件
  - `vm`: Dart 虚拟机相关组件

#### 2.1.2 目标语言 - C++
- **版本**: C++17/C++20
- **用途**: 目标代码生成、运行时库实现
- **编译器支持**: GCC, Clang, MSVC

#### 2.1.3 构建工具
- **Dart 侧**: 
  - `pub`: Dart 包管理和构建工具
  - `dart test`: 单元测试框架
- **C++ 侧**:
  - `CMake`: 跨平台构建系统（3.10+）
  - `Make`: Unix/Linux 构建工具

### 2.2 核心依赖库

| 依赖 | 版本 | 用途 |
|------|------|------|
| args | ^2.0.0 | 命令行参数解析 |
| path | ^1.8.0 | 路径处理 |
| meta | ^1.7.0 | 元数据注解 |
| kernel | (path) | Dart AST 表示 |
| front_end | (path) | Dart 编译前端 |
| vm | (path) | 虚拟机组件 |
| test | ^1.16.0 | 测试框架（dev） |

---

## 3. 架构设计

### 3.1 分层架构

```
dart2cpp/
├── lib/                         # Dart 转换器核心库（编译器前端）
│   ├── dart2cpp.dart           # 主库文件
│   ├── dart_to_cpp_compiler.dart  # 核心编译器
│   ├── compile_to_dart.dart    # 编译逻辑
│   ├── bytecode_generator.dart # 字节码生成
│   ├── declarations.dart       # 声明处理
│   ├── expressions.dart        # 表达式处理
│   ├── generics.dart          # 泛型处理
│   └── type_analyzer.dart     # 类型分析
├── bin/                        # 命令行工具入口
│   └── dart2cpp.dart          # CLI 主程序
├── cpp/                        # C++ 运行时库（目标代码运行环境）
│   ├── core/                   # 核心运行时库
│   │   ├── object.h/cpp       # 基础类型系统
│   │   ├── dart_syntax_*.h    # Dart 语法糖
│   │   └── dart_async*.h      # 异步支持
│   ├── test/                   # C++ 单元测试
│   └── examples/               # C++ 示例代码
├── test/                       # Dart 单元测试
└── scripts/                    # 自动化脚本
```

### 3.2 核心模块职责

#### 3.2.1 编译器模块 (lib/)
- **dart_to_cpp_compiler.dart**: 主编译器逻辑，协调整个转换流程
- **declarations.dart**: 处理类、函数、变量等声明的转换
- **expressions.dart**: 处理表达式、运算符、方法调用的转换
- **generics.dart**: 处理泛型类型的转换和实例化
- **type_analyzer.dart**: 类型推断和类型映射
- **bytecode_generator.dart**: 字节码生成（中间表示）

#### 3.2.2 运行时库模块 (cpp/core/)
- **object.h/cpp**: 基础类型系统（Int, Double, Bool, String, List, Set, Map）
- **dart_syntax_*.h**: Dart 语法糖支持（扩展方法、操作符重载）
- **dart_async*.h**: 异步编程支持（Future, async/await）
- **dart_helpers.h**: 辅助工具函数
- **dart_oop_extensions.h**: OOP 特性支持（接口、Mixin）

#### 3.2.3 命令行工具 (bin/)
- 提供 `dart2cpp` 命令行接口
- 参数解析和配置管理
- 文件输入输出处理

---

## 4. 编码规范

### 4.1 Dart 代码规范

#### 4.1.1 命名约定
- **类名**: PascalCase（如 `DartToCppCompiler`）
- **函数/方法**: camelCase（如 `convertExpression`）
- **变量**: camelCase（如 `variableName`）
- **常量**: lowerCamelCase（如 `typeMapping`）
- **私有成员**: 前缀 `_`（如 `_sanitizeIdentifier`）

#### 4.1.2 代码风格
- 遵循 Dart 官方代码风格指南
- 使用 `analysis_options.yaml` 进行静态分析
- 每个文件顶部包含版权声明
- 使用文档注释 `///` 为公共 API 添加说明

#### 4.1.3 类型使用
- 优先使用显式类型声明
- 合理使用类型推断（`var`, `final`）
- 避免使用 `dynamic`，除非必要

### 4.2 C++ 代码规范

#### 4.2.1 命名约定
- **类名**: PascalCase（如 `ObjectPtr`, `String`）
- **函数**: camelCase（如 `getValue`, `toString`）
- **宏**: UPPER_SNAKE_CASE（如 `DART_ASYNC_FUNCTION`）
- **常量**: UPPER_SNAKE_CASE 或 camelCase

#### 4.2.2 代码风格
- 使用现代 C++ 特性（C++17/C++20）
- 智能指针管理内存（`ObjectPtr<T>`）
- 头文件使用 `.h` 扩展名
- 实现文件使用 `.cpp` 扩展名
- 使用引用计数进行内存管理

#### 4.2.3 内存管理
- **智能指针**: 使用 `ObjectPtr<T>` 包装所有对象
- **引用计数**: 自动管理对象生命周期
- **字符串池**: 优化字符串存储和比较
- **避免裸指针**: 除非性能关键路径

### 4.3 类型映射规范

#### 4.3.1 基础类型映射

| Dart 类型 | C++ 类型 | 说明 |
|-----------|----------|------|
| `int` | `Int` | 32位整数 |
| `double` | `Double` | 64位浮点数 |
| `bool` | `Bool` | 布尔值 |
| `String` | `String` | 字符串（带字符串池） |
| `void` | `Nullable` | 空类型 |
| `dynamic` | `Any` | 动态类型 |
| `Object` | `Object` | 基础对象类型 |

#### 4.3.2 容器类型映射

| Dart 类型 | C++ 类型 | 说明 |
|-----------|----------|------|
| `List<T>` | `ObjectPtr<List<T>>` | 列表 |
| `Set<T>` | `ObjectPtr<Set<T>>` | 集合 |
| `Map<K,V>` | `ObjectPtr<Map<K,V>>` | 映射 |
| `LinkedHashSet<T>` | `ObjectPtr<Set<T>>` | 有序集合 |
| `LinkedHashMap<K,V>` | `ObjectPtr<Map<K,V>>` | 有序映射 |

#### 4.3.3 特殊类型映射

| Dart 类型 | C++ 类型 | 说明 |
|-----------|----------|------|
| `Future<T>` | `Future<T>` | 异步结果 |
| `Stream<T>` | `Stream<T>` | 异步流 |
| 自定义类 | `ObjectPtr<CustomClass>` | 用户定义类 |

### 4.4 标识符处理规范

#### 4.4.1 标识符清理
- 移除特殊前缀（`:`, `#`）
- 替换非法字符为下划线
- 确保不以数字开头
- 避免 C++ 关键字冲突（添加 `_` 后缀）

#### 4.4.2 C++ 关键字检测
使用 `_sanitizeIdentifier()` 函数处理所有标识符，确保：
- 不与 C++ 保留字冲突
- 符合 C++ 标识符规范
- 保持语义清晰

---

## 5. 异常处理规范

### 5.1 Dart 侧异常处理
- 使用 `try-catch` 捕获编译错误
- 提供清晰的错误消息
- 记录错误位置和上下文
- 优雅降级，避免崩溃

### 5.2 C++ 侧异常处理
- 使用 C++ 异常机制
- 提供异常类型层次结构
- 确保资源正确释放（RAII）
- 异常安全保证

### 5.3 错误类型
- **编译错误**: 语法错误、类型错误、不支持的特性
- **运行时错误**: 空指针、越界访问、类型转换失败
- **系统错误**: 文件 I/O 错误、内存分配失败

---

## 6. 测试规范

### 6.1 Dart 测试

#### 6.1.1 测试框架
- 使用 `package:test` 框架
- 测试文件位于 `test/` 目录
- 测试文件命名: `*_test.dart`

#### 6.1.2 测试类型
- **单元测试**: 测试单个函数/类
- **集成测试**: 测试完整转换流程
- **回归测试**: 确保修复不引入新问题

#### 6.1.3 运行测试
```bash
dart test
```

### 6.2 C++ 测试

#### 6.2.1 测试框架
- 自定义测试框架
- 测试文件位于 `cpp/test/`
- 测试文件命名: `*_test.cpp`

#### 6.2.2 测试类型
- **基础类型测试**: `basic_types_test.cpp`
- **容器测试**: `collection_test.cpp`
- **异步测试**: `async_test.cpp`
- **OOP 测试**: `oop_test.cpp`

#### 6.2.3 运行测试
```bash
cd cpp
make test
./build/run_tests
```

### 6.3 端到端测试

#### 6.3.1 自动化脚本
- `scripts/dart_to_cpp_run.sh`: 基础转换运行脚本
- `scripts/dart_to_cpp_run_advanced.sh`: 高级选项脚本
- `sample/test_all_samples.sh`: 批量测试脚本

#### 6.3.2 测试流程
1. Dart 代码转换为 C++
2. C++ 代码编译
3. 运行生成的可执行文件
4. 验证输出结果

### 6.4 覆盖率要求
- **核心模块**: ≥80% 代码覆盖率
- **运行时库**: ≥70% 代码覆盖率
- **关键路径**: 100% 覆盖

---

## 7. 构建和部署

### 7.1 Dart 侧构建

#### 7.1.1 依赖安装
```bash
dart pub get
```

#### 7.1.2 运行编译器
```bash
# 直接运行
dart bin/dart2cpp.dart input.dart -o output.cpp

# 使用 pub run
dart pub run dart2cpp input.dart -o output.cpp
```

### 7.2 C++ 侧构建

#### 7.2.1 使用 Make
```bash
cd cpp
make              # 编译运行时库
make test         # 编译测试
make examples     # 编译示例
make clean        # 清理
```

#### 7.2.2 使用 CMake
```bash
cd cpp
mkdir build && cd build
cmake ..
make
```

### 7.3 发布流程
1. 更新版本号（`pubspec.yaml`）
2. 运行完整测试套件
3. 生成文档
4. 打包发布

---

## 8. 项目约束

### 8.1 不支持的 Dart 特性
- **反射 (Reflection)**: 不支持运行时反射
- **部分高级语法**: 需要手动调整
- **完整泛型**: 泛型支持有限
- **Isolate**: 不支持多线程隔离

### 8.2 异步功能限制
- 异步支持为简化实现
- 不支持完整的 Zone 机制
- Stream 功能有限

### 8.3 性能考虑
- **字符串池优化**: 减少字符串复制
- **引用计数**: 自动内存管理
- **智能指针**: 避免内存泄漏
- **内联优化**: 关键路径性能优化

### 8.4 兼容性要求
- **C++ 编译器**: 需要 C++17 或更高版本
- **Dart SDK**: 需要 3.0.0 或更高版本
- **构建工具**: CMake 3.10+ 或 Make

---

## 9. 开发工具和环境

### 9.1 推荐 IDE
- **Dart 开发**: VS Code + Dart 插件、IntelliJ IDEA
- **C++ 开发**: CLion、VS Code + C++ 插件、Visual Studio

### 9.2 代码质量工具
- **Dart**: `dart analyze`、`dart format`
- **C++**: clang-format、clang-tidy、cppcheck

### 9.3 版本控制
- 使用 Git 进行版本控制
- 提交信息清晰描述变更
- 重大功能变更包含测试用例

---

## 10. 文档和资源

### 10.1 项目文档
- `README.md`: 项目概述和快速开始
- `QUICK_START.md`: 快速入门指南
- `cpp/README.md`: C++ 运行时库文档
- `scripts/README.md`: 脚本使用说明

### 10.2 技术文档
- `SUPPORTED_FEATURES.md`: 支持的特性列表
- `TYPE_PROMOTION_IMPLEMENTATION.md`: 类型提升实现
- `CLOSURE_VALUE_BOXING_DESIGN.md`: 闭包值装箱设计

### 10.3 测试文档
- `TEST_SUITE_DOCUMENTATION.md`: 测试套件文档
- `TEST_RESULTS_SUMMARY.md`: 测试结果总结

---

## 11. 附录

### 11.1 常用命令速查

```bash
# Dart 侧
dart pub get                    # 安装依赖
dart test                       # 运行测试
dart analyze                    # 静态分析
dart format .                   # 格式化代码

# C++ 侧
make                           # 编译
make test                      # 测试
make clean                     # 清理

# 端到端
./scripts/dart_to_cpp_run.sh input.dart
```

### 11.2 关键文件路径

```
lib/dart_to_cpp_compiler.dart   # 主编译器
cpp/core/object.h               # 基础类型定义
bin/dart2cpp.dart               # CLI 入口
pubspec.yaml                    # 项目配置
```

---

**文档版本**: v1.0.0  
**最后更新**: 2026-01-27  
**维护者**: dart2cpp 团队