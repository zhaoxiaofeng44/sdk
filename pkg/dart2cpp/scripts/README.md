# Dart2Cpp 脚本使用说明

本目录包含用于将 Dart 代码转换为 C++ 并运行的脚本工具。

## 脚本列表

### 1. dart_to_cpp_run.sh - 基础脚本
快速将单个 Dart 文件转换为 C++ 并运行。

**用法：**
```bash
./scripts/dart_to_cpp_run.sh <input.dart> [output_name]
```

**示例：**
```bash
# 基本用法
./scripts/dart_to_cpp_run.sh hello.dart

# 指定输出名称
./scripts/dart_to_cpp_run.sh hello.dart my_hello
```

### 2. dart_to_cpp_run_advanced.sh - 高级脚本
提供更多选项的脚本，可以保存生成的文件。

**用法：**
```bash
./scripts/dart_to_cpp_run_advanced.sh <input.dart> [选项]
```

**选项：**
- `-h, --help` - 显示帮助信息
- `-s, --save-cpp` - 保存生成的 C++ 代码
- `-e, --save-executable` - 保存生成的可执行文件
- `-o, --output-dir DIR` - 指定输出目录（默认：当前目录）
- `-n, --name NAME` - 指定输出文件名（默认：输入文件名）

**示例：**
```bash
# 基本用法
./scripts/dart_to_cpp_run_advanced.sh hello.dart

# 保存生成的 C++ 代码和可执行文件
./scripts/dart_to_cpp_run_advanced.sh hello.dart -s -e

# 指定输出目录和文件名
./scripts/dart_to_cpp_run_advanced.sh hello.dart -s -e -o ./output -n my_program
```

## 工作流程

脚本执行以下步骤：

1. **转换阶段** - 使用 Dart2Cpp 编译器将 Dart 代码转换为 C++
2. **编译阶段** - 编译核心库并生成可执行文件
3. **运行阶段** - 执行生成的程序
4. **清理阶段** - 清理临时文件

## 注意事项

1. 确保已安装 Dart SDK 和 C++ 编译器（g++ 或 clang）
2. 脚本会自动处理依赖关系和编译过程
3. 生成的文件默认保存在临时目录中，除非使用 `-s` 或 `-e` 选项
4. 如遇到编译错误，请检查 Dart 代码是否符合转换器支持的语法

## 故障排除

如果遇到问题，请检查：

1. Dart 环境是否正确设置
2. 项目依赖是否完整（运行 `pub get`）
3. C++ 编译器是否可用
4. 输入的 Dart 文件是否存在语法错误