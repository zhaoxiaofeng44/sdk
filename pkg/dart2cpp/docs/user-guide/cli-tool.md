# Dart2CPP 命令行工具使用指南

## 🚀 概述

`dart2cpp` 是 Dart2CPP 项目的核心命令行工具，用于将 Dart 源代码转换为等价的 C++ 代码。本指南详细介绍了工具的使用方法、配置选项和高级功能。

## 📋 基本语法

```bash
dart2cpp [options] <input.dart>
```

### 快速示例

```bash
# 基本转换
dart2cpp hello.dart

# 指定输出文件
dart2cpp hello.dart -o hello.cpp

# 启用详细输出
dart2cpp hello.dart --verbose

# 启用优化
dart2cpp hello.dart --optimize
```

## ⚙️ 命令行选项

### 基本选项

| 选项 | 简写 | 类型 | 默认值 | 说明 |
|------|------|------|--------|------|
| `--output` | `-o` | String | `<input>.cpp` | 指定输出 C++ 文件路径 |
| `--help` | `-h` | Flag | - | 显示帮助信息 |
| `--version` | | Flag | - | 显示版本信息 |
| `--verbose` | `-v` | Flag | `false` | 显示详细转换信息 |

### 编译选项

| 选项 | 类型 | 默认值 | 说明 |
|------|------|--------|------|
| `--platform` | String | 自动检测 | 指定 Dart 平台文件路径 |
| `--packages` | String | 自动检测 | 指定包配置文件路径 |
| `--no-runtime` | Flag | `false` | 不包含运行时库头文件 |
| `--optimize` | Flag | `false` | 启用代码优化 |

### 调试选项

| 选项 | 类型 | 默认值 | 说明 |
|------|------|--------|------|
| `--features` | Flag | - | 显示支持的 Dart 特性列表 |
| `--verbosity` | String | `info` | 设置详细程度 (`error`, `warning`, `info`, `all`) |

## 📖 详细使用说明

### 1. 基本文件转换

**转换单个文件**:
```bash
# 最简单的用法
dart2cpp input.dart

# 等价于
dart2cpp input.dart -o input.cpp
```

**指定输出路径**:
```bash
# 指定输出文件名
dart2cpp src/main.dart -o build/main.cpp

# 指定输出目录
dart2cpp src/main.dart -o build/
```

### 2. 批量转换

**使用 shell 脚本批量转换**:
```bash
#!/bin/bash
# convert_all.sh

for file in src/*.dart; do
    output="build/$(basename "$file" .dart).cpp"
    dart2cpp "$file" -o "$output"
done
```

**使用 find 命令**:
```bash
# 转换目录中所有 .dart 文件
find src -name "*.dart" -exec dart2cpp {} -o {}.cpp \;
```

### 3. 配置平台和包

**手动指定平台文件**:
```bash
dart2cpp input.dart \
  --platform /path/to/vm_platform_strong.dill \
  --packages .dart_tool/package_config.json
```

**使用环境变量**:
```bash
export DART_PLATFORM_DILL=/path/to/vm_platform_strong.dill
export DART_PACKAGES_CONFIG=.dart_tool/package_config.json
dart2cpp input.dart
```

### 4. 优化和调试

**启用优化**:
```bash
# 启用所有优化
dart2cpp input.dart --optimize

# 详细输出优化信息
dart2cpp input.dart --optimize --verbose
```

**调试转换过程**:
```bash
# 显示详细转换信息
dart2cpp input.dart --verbose

# 显示所有诊断信息
dart2cpp input.dart --verbosity all

# 检查支持的特性
dart2cpp --features
```

## 🔧 高级用法

### 1. 自定义构建脚本

创建 `build.dart` 脚本：

```dart
#!/usr/bin/env dart

import 'dart:io';
import 'package:path/path.dart' as path;

void main(List<String> args) async {
  final sourceDir = Directory('src');
  final outputDir = Directory('build');
  
  // 确保输出目录存在
  if (!outputDir.existsSync()) {
    outputDir.createSync(recursive: true);
  }
  
  // 转换所有 .dart 文件
  await for (final entity in sourceDir.list(recursive: true)) {
    if (entity is File && entity.path.endsWith('.dart')) {
      final relativePath = path.relative(entity.path, from: sourceDir.path);
      final outputPath = path.join(
        outputDir.path, 
        path.setExtension(relativePath, '.cpp')
      );
      
      // 确保输出子目录存在
      final outputFile = File(outputPath);
      outputFile.parent.createSync(recursive: true);
      
      // 执行转换
      final result = await Process.run('dart', [
        'bin/dart2cpp.dart',
        entity.path,
        '-o', outputPath,
        '--optimize'
      ]);
      
      if (result.exitCode == 0) {
        print('✅ ${entity.path} -> $outputPath');
      } else {
        print('❌ Failed to convert ${entity.path}');
        print(result.stderr);
      }
    }
  }
}
```

运行构建脚本：
```bash
dart run build.dart
```

### 2. Makefile 集成

创建 `Makefile`：

```makefile
# Dart2CPP Makefile

DART_SOURCES := $(wildcard src/*.dart)
CPP_SOURCES := $(DART_SOURCES:src/%.dart=build/%.cpp)
DART2CPP := dart bin/dart2cpp.dart

.PHONY: all clean convert compile

all: convert compile

# 转换 Dart 到 C++
convert: $(CPP_SOURCES)

build/%.cpp: src/%.dart
	@mkdir -p $(dir $@)
	$(DART2CPP) $< -o $@ --optimize

# 编译 C++ 代码
compile: $(CPP_SOURCES)
	@mkdir -p bin
	g++ -std=c++17 -I cpp/core -O2 \
		$(CPP_SOURCES) cpp/core/object.cpp \
		-o bin/main

# 清理生成文件
clean:
	rm -rf build bin

# 运行转换后的程序
run: compile
	./bin/main

# 显示帮助
help:
	@echo "Available targets:"
	@echo "  all      - Convert and compile"
	@echo "  convert  - Convert Dart to C++"
	@echo "  compile  - Compile C++ code"
	@echo "  clean    - Clean generated files"
	@echo "  run      - Run compiled program"
	@echo "  help     - Show this help"
```

### 3. CMake 集成

创建 `CMakeLists.txt`：

```cmake
cmake_minimum_required(VERSION 3.10)
project(Dart2CppProject)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Dart2CPP 工具路径
set(DART2CPP_TOOL "dart bin/dart2cpp.dart")

# 源文件目录
set(DART_SOURCE_DIR "${CMAKE_SOURCE_DIR}/src")
set(CPP_OUTPUT_DIR "${CMAKE_BINARY_DIR}/generated")

# 查找所有 .dart 文件
file(GLOB_RECURSE DART_SOURCES "${DART_SOURCE_DIR}/*.dart")

# 生成 C++ 文件列表
set(CPP_SOURCES "")
foreach(DART_FILE ${DART_SOURCES})
    file(RELATIVE_PATH REL_PATH "${DART_SOURCE_DIR}" "${DART_FILE}")
    string(REGEX REPLACE "\\.dart$" ".cpp" CPP_REL_PATH "${REL_PATH}")
    set(CPP_FILE "${CPP_OUTPUT_DIR}/${CPP_REL_PATH}")
    list(APPEND CPP_SOURCES "${CPP_FILE}")
    
    # 添加自定义命令转换 Dart 到 C++
    add_custom_command(
        OUTPUT "${CPP_FILE}"
        COMMAND ${CMAKE_COMMAND} -E make_directory "${CPP_OUTPUT_DIR}"
        COMMAND ${DART2CPP_TOOL} "${DART_FILE}" -o "${CPP_FILE}" --optimize
        DEPENDS "${DART_FILE}"
        COMMENT "Converting ${DART_FILE} to C++"
    )
endforeach()

# 添加 C++ 运行时库
set(RUNTIME_SOURCES
    "${CMAKE_SOURCE_DIR}/cpp/core/object.cpp"
)

# 包含目录
include_directories("${CMAKE_SOURCE_DIR}/cpp/core")

# 创建可执行文件
add_executable(${PROJECT_NAME} ${CPP_SOURCES} ${RUNTIME_SOURCES})

# 添加自定义目标用于转换
add_custom_target(convert_dart DEPENDS ${CPP_SOURCES})
add_dependencies(${PROJECT_NAME} convert_dart)
```

使用 CMake：
```bash
mkdir build && cd build
cmake ..
make
./Dart2CppProject
```

## 🔍 错误处理和诊断

### 常见错误类型

**1. 语法错误**:
```bash
$ dart2cpp invalid.dart
Error: Expected ';' after expression
Context: line 5, column 10 in invalid.dart
```

**2. 类型错误**:
```bash
$ dart2cpp type_error.dart --verbose
Error: The argument type 'String' can't be assigned to parameter type 'int'
Context: main() function in type_error.dart
```

**3. 不支持的特性**:
```bash
$ dart2cpp advanced.dart
Warning: Reflection features are not supported
Error: Cannot convert dart:mirrors import
```

### 诊断选项

**详细错误信息**:
```bash
# 显示完整错误堆栈
dart2cpp problematic.dart --verbosity all

# 显示转换过程
dart2cpp input.dart --verbose
```

**检查支持的特性**:
```bash
# 查看所有支持的特性
dart2cpp --features

# 检查特定特性是否支持
dart2cpp --features | grep "async"
```

## 📊 性能优化

### 转换性能

**并行转换**:
```bash
# 使用 GNU parallel 并行转换多个文件
find src -name "*.dart" | parallel dart2cpp {} -o {.}.cpp
```

**增量转换**:
```bash
#!/bin/bash
# incremental_build.sh

for dart_file in src/*.dart; do
    cpp_file="build/$(basename "$dart_file" .dart).cpp"
    
    # 只转换修改过的文件
    if [[ "$dart_file" -nt "$cpp_file" ]]; then
        echo "Converting $dart_file..."
        dart2cpp "$dart_file" -o "$cpp_file"
    else
        echo "Skipping $dart_file (up to date)"
    fi
done
```

### 编译性能

**优化编译选项**:
```bash
# 启用所有优化
dart2cpp input.dart --optimize

# 生成优化的 C++ 代码
g++ -std=c++17 -O3 -DNDEBUG \
    -I cpp/core \
    output.cpp cpp/core/object.cpp \
    -o optimized_program
```

## 🔧 配置文件

### 创建配置文件

创建 `dart2cpp.yaml`：

```yaml
# Dart2CPP 配置文件
version: "2.0"

# 输入配置
input:
  source_dirs:
    - "src"
    - "lib"
  exclude_patterns:
    - "**/*_test.dart"
    - "**/.*"

# 输出配置
output:
  directory: "build"
  extension: ".cpp"
  preserve_structure: true

# 编译选项
compiler:
  platform: "auto"  # 或指定路径
  packages: "auto"   # 或指定路径
  optimize: true
  include_runtime: true

# 调试选项
debug:
  verbose: false
  verbosity: "info"  # error, warning, info, all
  show_timing: false
```

使用配置文件：
```bash
dart2cpp --config dart2cpp.yaml
```

### 环境变量配置

```bash
# 设置默认配置
export DART2CPP_PLATFORM="/path/to/vm_platform_strong.dill"
export DART2CPP_PACKAGES=".dart_tool/package_config.json"
export DART2CPP_OPTIMIZE="true"
export DART2CPP_VERBOSE="false"

# 使用环境变量
dart2cpp input.dart
```

## 🚀 集成开发环境

### VS Code 集成

创建 `.vscode/tasks.json`：

```json
{
    "version": "2.0.0",
    "tasks": [
        {
            "label": "Dart2CPP: Convert Current File",
            "type": "shell",
            "command": "dart",
            "args": [
                "bin/dart2cpp.dart",
                "${file}",
                "-o",
                "${fileDirname}/${fileBasenameNoExtension}.cpp"
            ],
            "group": "build",
            "presentation": {
                "echo": true,
                "reveal": "always",
                "focus": false,
                "panel": "shared"
            },
            "problemMatcher": []
        },
        {
            "label": "Dart2CPP: Convert All",
            "type": "shell",
            "command": "find",
            "args": [
                "src",
                "-name",
                "*.dart",
                "-exec",
                "dart",
                "bin/dart2cpp.dart",
                "{}",
                "-o",
                "{}.cpp",
                ";"
            ],
            "group": "build"
        }
    ]
}
```

### IntelliJ/Android Studio 集成

创建外部工具配置：

1. 打开 `File > Settings > Tools > External Tools`
2. 点击 `+` 添加新工具
3. 配置如下：
   - **Name**: Dart2CPP Convert
   - **Program**: `dart`
   - **Arguments**: `bin/dart2cpp.dart $FilePath$ -o $FileNameWithoutExtension$.cpp`
   - **Working directory**: `$ProjectFileDir$`

## 📝 最佳实践

### 1. 项目结构建议

```
my_project/
├── src/                    # Dart 源代码
│   ├── main.dart
│   ├── models/
│   └── utils/
├── build/                  # 生成的 C++ 代码
│   ├── main.cpp
│   ├── models/
│   └── utils/
├── cpp/                    # C++ 运行时库
│   └── core/
├── scripts/                # 构建脚本
│   ├── build.dart
│   └── clean.sh
├── dart2cpp.yaml          # 配置文件
└── Makefile               # 构建配置
```

### 2. 版本控制

`.gitignore` 配置：
```gitignore
# 生成的 C++ 文件
build/
*.cpp
*.o
*.exe

# 编译产物
bin/
obj/

# 临时文件
.dart_tool/
.packages
```

### 3. 持续集成

GitHub Actions 配置 (`.github/workflows/build.yml`)：

```yaml
name: Build and Test

on: [push, pull_request]

jobs:
  build:
    runs-on: ubuntu-latest
    
    steps:
    - uses: actions/checkout@v3
    
    - name: Setup Dart
      uses: dart-lang/setup-dart@v1
      with:
        sdk: stable
    
    - name: Install dependencies
      run: dart pub get
    
    - name: Convert Dart to C++
      run: |
        mkdir -p build
        find src -name "*.dart" -exec dart bin/dart2cpp.dart {} -o build/{}.cpp \;
    
    - name: Compile C++
      run: |
        sudo apt-get update
        sudo apt-get install -y g++
        g++ -std=c++17 -I cpp/core build/*.cpp cpp/core/object.cpp -o main
    
    - name: Run tests
      run: ./main
```

## 🆘 故障排除

### 常见问题解决

**问题 1: 找不到平台文件**
```bash
Error: Platform file not found
```
解决方案：
```bash
# 查找平台文件
find /usr -name "vm_platform_strong.dill" 2>/dev/null
# 或使用 Dart SDK 路径
dart2cpp input.dart --platform "$(dart --print-dart-sdk-path)/lib/_internal/vm_platform_strong.dill"
```

**问题 2: 包配置错误**
```bash
Error: Package config not found
```
解决方案：
```bash
# 重新生成包配置
dart pub get
dart2cpp input.dart --packages .dart_tool/package_config.json
```

**问题 3: 编译错误**
```bash
Error: 'dart_string' was not declared in this scope
```
解决方案：
```bash
# 确保包含运行时库
g++ -I cpp/core input.cpp cpp/core/object.cpp -o output
```

### 调试技巧

**1. 逐步调试**:
```bash
# 检查 Dart 代码语法
dart analyze input.dart

# 转换并查看生成的 C++ 代码
dart2cpp input.dart --verbose
cat input.cpp

# 编译并检查错误
g++ -std=c++17 -I cpp/core input.cpp cpp/core/object.cpp -o test
```

**2. 使用调试宏**:
```cpp
// 在生成的 C++ 代码中添加调试输出
#define DEBUG_PRINT(x) std::cout << "DEBUG: " << x << std::endl

int main() {
    DEBUG_PRINT("Starting program");
    // ... 生成的代码
    DEBUG_PRINT("Program finished");
    return 0;
}
```

这个命令行工具指南为用户提供了完整的使用参考，涵盖了从基本用法到高级集成的所有方面。
