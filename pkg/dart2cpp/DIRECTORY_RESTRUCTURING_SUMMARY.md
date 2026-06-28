# 项目目录结构调整总结

## 调整概述

本次调整重新组织了项目目录结构，实现了清晰的职责分离：
- **转换器代码** - 保留在 `lib/` 目录
- **运行时平台代码** - 迁移到 `src/platform/` 目录
- **示例代码** - 新增 `sample/` 目录

## 目录结构变化

### 调整前
```
dart2cpp/
├── lib/
│   └── restorer/
│       ├── runtime_classes.dart      # Dart 运行时
│       └── ...
├── cpp/
│   └── core/                         # C++ 运行时
│       ├── dart2cpp_lowered.h
│       ├── dart_object.h/cpp
│       ├── dart_string.h/cpp
│       └── ...
└── test/                             # 测试代码
```

### 调整后
```
dart2cpp/
├── lib/                              # 转换器核心代码
│   ├── restorer/
│   │   ├── dart_restorer.dart
│   │   ├── declaration_restorer.dart
│   │   ├── expression_restorer.dart
│   │   ├── statement_restorer.dart
│   │   ├── type_utils.dart
│   │   └── constant_restorer.dart
│   ├── platform/
│   │   └── dart/
│   │       └── runtime_classes.dart  # Dart 运行时（复制）
│   └── dart_to_dart_restorer.dart
│
├── src/                              # 新增：平台运行时源代码
│   └── platform/
│       ├── cpp/                      # C++ 运行时（从 cpp/core/ 迁移）
│       │   ├── dart2cpp_lowered.h
│       │   ├── dart_object.h/cpp
│       │   ├── dart_string.h/cpp
│       │   └── ...
│       └── dart/                     # Dart 运行时（从 lib/restorer/ 迁移）
│           └── runtime_classes.dart
│
├── sample/                           # 新增：转换示例
│   ├── src/                          # 源 Dart 文件
│   │   └── hello.dart
│   ├── dart/                         # 转换后的 Dart 输出
│   │   └── hello_restored.dart
│   ├── cpp/                          # 转换后的 C++ 输出（待实现）
│   ├── convert.sh                    # 转换脚本
│   └── README.md                     # 使用说明
│
├── test/                             # 测试代码（保持不变）
│   ├── *.dart
│   └── *_restored.dart
│
├── tool/                             # 开发工具
│   ├── regen_restored.dart
│   ├── convert_sample.dart           # 新增：示例转换工具
│   └── inspect_kernel.dart
│
└── cpp/                              # 保留：C++ 示例和测试
    ├── examples/
    └── test/
```

## 迁移清单

### 1. Dart 运行时迁移
- **源位置**: `lib/restorer/runtime_classes.dart`
- **目标位置**: `src/platform/dart/runtime_classes.dart`
- **状态**: ✅ 已完成
- **操作**: 
  - 复制文件到 `src/platform/dart/`
  - 复制文件到 `lib/platform/dart/`（用于 package 导入）
  - 删除原始文件 `lib/restorer/runtime_classes.dart`

### 2. C++ 运行时迁移
- **源位置**: `cpp/core/*.h`, `cpp/core/*.cpp`
- **目标位置**: `src/platform/cpp/`
- **状态**: ✅ 已完成
- **迁移文件**:
  - `dart2cpp_lowered.h`
  - `dart2cpp.h`
  - `dart_object.h/cpp`
  - `dart_string.h/cpp`
  - `dart_async.h`
  - `dart_helpers.h`
  - `dart_macros.h`
  - `dart_extensions.h`
  - `dart_oop_extensions.h`
  - `object_extensions.h`

### 3. 示例目录创建
- **状态**: ✅ 已完成
- **创建内容**:
  - `sample/src/hello.dart` - 示例源文件
  - `sample/convert.sh` - 转换脚本
  - `sample/README.md` - 使用说明
  - `sample/dart/` - 输出目录
  - `sample/cpp/` - 输出目录（待实现）

### 4. 工具更新
- **新增**: `tool/convert_sample.dart` - 示例转换工具
- **更新**: `run_all_sample_tests.sh` - 更新 C++ 编译路径

## 导入路径更新

### 旧路径
```dart
import 'package:dart2cpp/restorer/runtime_classes.dart';
```

### 新路径
```dart
import 'package:dart2cpp/platform/dart/runtime_classes.dart';
```

### 已更新的文件
- ✅ `lib/restorer/dart_restorer.dart` - `_emitRuntimeImport()` 方法
- ✅ `test/gc_test.dart` - 测试文件
- ✅ `test/promise_enhanced_test.dart` - 测试文件
- ✅ `test/state_machine_advanced_test.dart` - 测试文件
- ✅ `test/static_collections_test.dart` - 测试文件
- ✅ `test/*_restored.dart` - 17 个生成的测试文件

## 配置更新

### C++ Makefile
- **文件**: `cpp/Makefile`
- **更新**: 
  - `CORE_DIR = ../src/platform/cpp`
  - `CXXFLAGS = -std=c++17 -Wall -Wextra -I../src/platform/cpp`

## 测试结果

### 转换测试
- ✅ `sample/convert.sh` - 成功转换并运行 `hello.dart`
- ✅ 输出: "Hello, World!", "Hello, Alice!", "Hello, Bob!", "Hello, Charlie!"

### 单元测试
- ✅ `test/gc_test.dart` - 33 个测试通过
- ✅ `test/static_collections_test.dart` - 全部通过
- ✅ `test/state_machine_advanced_test.dart` - 11 个测试通过

## 使用说明

### 转换示例代码
```bash
cd sample
./convert.sh
```

### 运行测试
```bash
# 运行单个测试
dart run test/gc_test.dart

# 运行所有测试（待实现）
# dart test
```

### 编译 C++ 代码
```bash
cd cpp
make clean
make
```

## 注意事项

1. **双重副本**: `runtime_classes.dart` 在两个位置存在：
   - `src/platform/dart/runtime_classes.dart` - 源代码
   - `lib/platform/dart/runtime_classes.dart` - 用于 package 导入

2. **导入路径**: 所有生成的代码和测试文件使用新路径：
   ```dart
   import 'package:dart2cpp/platform/dart/runtime_classes.dart';
   ```

3. **C++ 编译**: C++ 代码编译时需要指定新的 include 路径：
   ```bash
   g++ -std=c++17 -I src/platform/cpp ...
   ```

## 后续工作

1. **C++ 转换**: 实现 Dart 到 C++ 的完整转换流程
2. **自动化测试**: 创建完整的测试运行脚本
3. **文档更新**: 更新所有相关文档中的路径引用
4. **CI/CD**: 更新 CI/CD 配置以反映新的目录结构

## 相关文件

- [目录结构调整计划](.claude/plans/immutable-singing-kernighan.md)
- [运行时转换深度分析](RUNTIME_GAP_DEEP_ANALYSIS.md)
- [运行时优化总结](RUNTIME_OPTIMIZATION_SUMMARY.md)
- [示例使用说明](sample/README.md)
