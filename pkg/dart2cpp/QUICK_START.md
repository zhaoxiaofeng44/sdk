# Dart2CPP 快速开始指南

## 项目简介

dart2cpp 是一个完整的 Dart 到 C++ 转换编译器项目，包含：
- **Dart 转换器**：将 Dart 代码转换为 C++ 代码
- **C++ 运行时库**：支持转换后代码运行的完整运行时

## 项目结构

```
dart2cpp/
├── lib/          # Dart 转换器库
├── bin/          # 命令行工具
├── test/         # Dart 测试
└── cpp/          # C++ 子项目
    ├── core/     # C++ 运行时库
    ├── test/     # C++ 测试
    └── examples/ # C++ 示例
```

## 快速开始

### 1. 设置 Dart 环境

```bash
cd /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2cpp

# 安装依赖
dart pub get
```

### 2. 使用 Dart 转换器

```bash
# 查看帮助
dart bin/dart2cpp.dart --help

# 转换 Dart 文件
dart bin/dart2cpp.dart lib/demo/hello.dart -o output.cpp

# 详细输出
dart bin/dart2cpp.dart lib/demo/hello.dart -o output.cpp --verbose
```

### 3. 编译和运行 C++ 代码

```bash
cd cpp

# 编译核心库
make

# 编译示例
make examples

# 运行示例
./build/hello_example
```

输出：
```
Hello from Dart2CPP!
Count: 5
Numbers: 1 2 3 4 5
```

## 使用示例

### 示例 1: 转换 Dart 代码

创建 `example.dart`：
```dart
void main() {
  var message = 'Hello from Dart!';
  var count = 5;
  print(message);
  print('Count: $count');
}
```

转换：
```bash
dart bin/dart2cpp.dart example.dart -o example.cpp
```

### 示例 2: 手动编写 C++ 代码

创建 `my_program.cpp`：
```cpp
#include "dart2cpp.h"
#include <iostream>

int main() {
    // 使用 Dart 类型
    String message = String("Hello from C++!");
    Int count = Int(10);
    
    std::cout << message.getValue() << std::endl;
    std::cout << "Count: " << count.toString().getValue() << std::endl;
    
    // 使用 List
    ObjectPtr<List<Int>> numbers = List<Int>::create();
    for (Int i = Int(1); i.toInt() <= 5; ++i) {
        numbers->add(i);
    }
    
    std::cout << "Numbers: ";
    for (Int i = Int(0); i.toInt() < numbers->size().toInt(); ++i) {
        std::cout << numbers->get(i).toString().getValue() << " ";
    }
    std::cout << std::endl;
    
    return 0;
}
```

编译：
```bash
cd cpp
g++ -std=c++11 -I./core my_program.cpp core/object.cpp -o my_program
./my_program
```

## 项目命令速查

### Dart 部分

```bash
# 获取依赖
dart pub get

# 运行转换器
dart bin/dart2cpp.dart <input.dart>

# 运行测试
dart test

# 分析代码
dart analyze
```

### C++ 部分

```bash
cd cpp

# 编译核心库
make

# 编译测试
make test

# 编译示例
make examples

# 清理
make clean

# 重新编译
make rebuild
```

## 目录说明

### Dart 转换器 (项目根目录)

- `lib/` - Dart 库代码
  - `dart2cpp.dart` - 主库
  - `dart_to_cpp_compiler.dart` - 编译器核心
  - `demo/` - 示例 Dart 代码
- `bin/` - 命令行工具
  - `dart2cpp.dart` - 转换器入口
- `test/` - Dart 测试文件
- `pubspec.yaml` - Dart 包配置

### C++ 运行时库 (cpp/ 目录)

- `core/` - 核心运行时库
  - `object.h/.cpp` - 基础类型
  - `dart2cpp.h` - 主头文件
  - `dart_*` - 各种扩展
- `test/` - C++ 测试代码
- `examples/` - C++ 示例代码
- `Makefile` - 构建脚本

## 类型对照表

| Dart | C++ | 使用示例 |
|------|-----|----------|
| `int` | `Int` | `Int x = Int(42);` |
| `double` | `Double` | `Double y = Double(3.14);` |
| `bool` | `Bool` | `Bool b = Bool(true);` |
| `String` | `String` | `String s = String("hi");` |
| `List<int>` | `ObjectPtr<List<Int>>` | `List<Int>::create()` |
| `Map<String,int>` | `ObjectPtr<Map<String,Int>>` | `Map<String,Int>::create()` |

## 常见问题

### Q: 如何添加新的 Dart 示例？

在 `lib/demo/` 目录创建新的 `.dart` 文件，然后使用转换器转换。

### Q: 如何测试 C++ 运行时库？

```bash
cd cpp
make test
# 运行生成的测试程序
./build/test_name
```

### Q: 如何修改转换逻辑？

编辑 `lib/dart_to_cpp_compiler.dart` 中的转换函数。

### Q: C++ 编译失败怎么办？

确保：
1. 使用 C++11 标准：`-std=c++11`
2. 包含头文件路径：`-I./core`
3. 链接 object.cpp

## 下一步

1. 阅读 `README.md` 了解项目详情
2. 查看 `PROJECT_COMPLETE.md` 了解项目架构
3. 探索 `lib/demo/` 中的示例代码
4. 试试转换简单的 Dart 程序

## 获取帮助

- 项目文档: `README.md`
- 完成报告: `PROJECT_COMPLETE.md`
- C++ 文档: `cpp/README.md`

---

祝使用愉快！🎉

