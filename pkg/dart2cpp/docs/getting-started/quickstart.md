# Dart2CPP 快速入门指南

## 🚀 5分钟快速上手

本指南将帮助您在5分钟内完成 Dart2CPP 的安装、配置和第一次代码转换。

## 📋 前置要求

### 系统要求
- **操作系统**: macOS, Linux, Windows
- **Dart SDK**: 2.17.0 或更高版本
- **C++ 编译器**: GCC 7+, Clang 6+, 或 MSVC 2019+
- **CMake**: 3.10 或更高版本 (可选)

### 检查环境
```bash
# 检查 Dart 版本
dart --version

# 检查 C++ 编译器
g++ --version
# 或
clang++ --version
```

## 🛠️ 安装步骤

### 1. 获取源码
```bash
# 克隆仓库 (如果是开源版本)
git clone https://github.com/dart-lang/dart2cpp.git
cd dart2cpp

# 或者直接进入项目目录 (如果已有源码)
cd /path/to/dart2cpp
```

### 2. 安装依赖
```bash
# 安装 Dart 依赖
dart pub get
```

### 3. 验证安装
```bash
# 运行帮助命令
dart bin/dart2cpp.dart --help

# 查看版本信息
dart bin/dart2cpp.dart --version

# 查看支持的特性
dart bin/dart2cpp.dart --features
```

## 🎯 第一个示例

### 1. 创建 Dart 文件

创建一个简单的 Dart 文件 `hello.dart`:

```dart
void main() {
  print('Hello, Dart2CPP!');
  
  // 基本变量
  int number = 42;
  String message = 'The answer is';
  bool isCorrect = true;
  
  // 字符串插值
  print('$message $number');
  
  // 条件判断
  if (isCorrect) {
    print('Everything works!');
  }
  
  // 循环
  for (int i = 1; i <= 3; i++) {
    print('Count: $i');
  }
  
  // 列表操作
  List<int> numbers = [1, 2, 3, 4, 5];
  for (int num in numbers) {
    print('Number: $num');
  }
}
```

### 2. 转换为 C++

```bash
# 基本转换
dart bin/dart2cpp.dart hello.dart

# 指定输出文件
dart bin/dart2cpp.dart hello.dart -o hello.cpp

# 详细输出
dart bin/dart2cpp.dart hello.dart -v
```

### 3. 查看生成的 C++ 代码

生成的 `hello.cpp` 文件内容：

```cpp
#include "dart2cpp.h"

Nullable main() {
  dart_print(dart_string("Hello, Dart2CPP!"));
  
  auto number = dart_int(42);
  auto message = dart_string("The answer is");
  auto isCorrect = dart_bool(true);
  
  dart_print(dart_concat(message, dart_string(" "), number));
  
  if (isCorrect) {
    dart_print(dart_string("Everything works!"));
  }
  
  for (auto i = dart_int(1); (i <= dart_int(3)); i = (i + dart_int(1))) {
    dart_print(dart_concat(dart_string("Count: "), i));
  }
  
  auto numbers = dart_literal(dart_int(1), dart_int(2), dart_int(3), dart_int(4), dart_int(5));
  auto :sync-for-iterator = numbers->iterator();
  for (; :sync-for-iterator->moveNext(); ) {
    auto num = :sync-for-iterator->current();
    dart_print(dart_concat(dart_string("Number: "), num));
  }
  
  return Void;
}
```

### 4. 编译并运行 C++ 代码

```bash
# 进入 cpp 目录
cd cpp

# 编译 (使用 Makefile)
make
cp ../hello.cpp examples/
cd examples
g++ -I../core -std=c++17 hello.cpp ../core/object.cpp -o hello

# 或使用 CMake
mkdir build && cd build
cmake ..
make
cp ../../hello.cpp .
g++ -I../core -std=c++17 hello.cpp ../core/object.cpp -o hello

# 运行
./hello
```

**预期输出**:
```
Hello, Dart2CPP!
The answer is 42
Everything works!
Count: 1
Count: 2
Count: 3
Number: 1
Number: 2
Number: 3
Number: 4
Number: 5
```

## 🔧 常用命令

### 基本转换命令

```bash
# 转换单个文件
dart bin/dart2cpp.dart input.dart

# 指定输出文件
dart bin/dart2cpp.dart input.dart -o output.cpp

# 启用优化
dart bin/dart2cpp.dart input.dart --optimize

# 不包含运行时库 (需要手动链接)
dart bin/dart2cpp.dart input.dart --no-runtime

# 详细输出
dart bin/dart2cpp.dart input.dart --verbose
```

### 批量转换

```bash
# 转换目录中的所有 .dart 文件
for file in *.dart; do
  dart bin/dart2cpp.dart "$file" -o "${file%.dart}.cpp"
done
```

### 使用便捷脚本

项目提供了便捷脚本：

```bash
# 转换示例文件
./sample/convert_simple.sh

# 转换所有示例
./sample/convert_all.sh
```

## 📝 配置选项

### 命令行选项详解

| 选项 | 简写 | 说明 | 默认值 |
|------|------|------|--------|
| `--output` | `-o` | 指定输出 C++ 文件路径 | `input.cpp` |
| `--verbose` | `-v` | 显示详细转换信息 | `false` |
| `--optimize` | | 启用代码优化 | `false` |
| `--no-runtime` | | 不包含运行时库头文件 | `false` |
| `--help` | `-h` | 显示帮助信息 | |
| `--version` | | 显示版本信息 | |
| `--features` | | 显示支持的特性列表 | |

### 环境变量

```bash
# 设置平台文件路径 (通常自动检测)
export DART_PLATFORM_DILL=/path/to/vm_platform_strong.dill

# 设置包配置文件路径
export DART_PACKAGES_CONFIG=/path/to/package_config.json
```

## 🎯 下一步

现在您已经成功运行了第一个 Dart2CPP 示例！接下来可以：

1. **学习更多特性**: 查看 [基础示例](basic-examples.md) 了解更多转换示例
2. **深入了解**: 阅读 [用户指南](../user-guide/cli-tool.md) 了解详细功能
3. **查看 API**: 浏览 [API 参考](../api-reference/cpp-runtime-api.md) 了解 C++ 运行时库
4. **探索示例**: 查看 `sample/dart/` 目录中的更多示例

## ❓ 常见问题

### Q: 转换失败怎么办？

**A**: 首先检查：
1. Dart 代码是否语法正确：`dart analyze input.dart`
2. 是否使用了不支持的特性：`dart bin/dart2cpp.dart --features`
3. 查看详细错误信息：`dart bin/dart2cpp.dart input.dart -v`

### Q: 生成的 C++ 代码编译失败？

**A**: 确保：
1. 包含了正确的头文件路径：`-I/path/to/cpp/core`
2. 链接了运行时库：`object.cpp`
3. 使用了 C++17 标准：`-std=c++17`

### Q: 运行时出现错误？

**A**: 检查：
1. 是否正确初始化了所有变量
2. 是否有空指针访问
3. 是否有数组越界访问

### Q: 性能不如预期？

**A**: 尝试：
1. 启用编译器优化：`-O2` 或 `-O3`
2. 使用 `--optimize` 选项
3. 检查是否有不必要的对象创建

## 🆘 获取帮助

如果遇到问题，可以：

1. **查看文档**: 浏览完整的 [项目文档](../README.md)
2. **查看示例**: 参考 `sample/dart/` 中的示例代码
3. **提交问题**: 在 GitHub 上创建 Issue
4. **社区讨论**: 参与 GitHub Discussions

---

🎉 **恭喜！** 您已经成功完成了 Dart2CPP 的快速入门。现在可以开始探索更多高级特性了！
