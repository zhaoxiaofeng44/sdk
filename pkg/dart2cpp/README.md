# Dart to C++ Compiler (dart2cpp)

一个完整的 Dart 到 C++ 的转换编译器和运行时库项目。

## 项目结构

```
dart2cpp/
├── lib/                         # Dart 转换器核心库
│   ├── dart2cpp.dart           # 主库文件
│   ├── dart_to_cpp_compiler.dart  # Dart到C++编译器
│   ├── compile_to_dart.dart    # 编译逻辑
│   ├── bytecode_generator.dart # 字节码生成
│   ├── declarations.dart       # 声明处理
│   ├── expressions.dart        # 表达式处理
│   ├── generics.dart          # 泛型处理
│   └── demo/                   # 示例Dart代码
│       ├── hello.dart
│       ├── string.dart
│       ├── collection.dart
│       └── ...
├── bin/                        # 可执行脚本
│   └── dart2cpp.dart          # 命令行工具
├── test/                       # Dart 测试
│   └── *.dart
├── cpp/                        # C++ 运行时库和测试
│   ├── core/                   # C++ 核心运行时库
│   │   ├── object.h           # 基础类型定义
│   │   ├── object.cpp         # 基础类型实现
│   │   ├── object_extensions_simple.h
│   │   ├── dart_syntax_*.h    # Dart语法糖
│   │   ├── dart_async*.h      # 异步支持
│   │   ├── dart_helpers.h     # 辅助工具
│   │   └── dart_oop_extensions.h
│   ├── test/                   # C++ 测试文件
│   │   ├── basic_types_test.cpp
│   │   ├── collection_test.cpp
│   │   └── ...
│   ├── examples/               # C++ 示例
│   ├── CMakeLists.txt          # CMake 配置
│   └── Makefile                # Make 构建
├── doc/                        # 项目文档
└── docs/                       # 技术文档
```

## 功能特性

### Dart 转换器 (lib/)

- ✅ Dart 代码解析和分析
- ✅ Dart 到 C++ 的代码转换
- ✅ 类型系统映射
- ✅ 表达式转换
- ✅ 声明转换
- ✅ 泛型支持
- ✅ 异步转换

### C++ 运行时库 (cpp/core/)

- ✅ 完整的类型系统 (Int, Double, Bool, String)
- ✅ 容器类型 (List, Set, Map)
- ✅ 智能指针 (ObjectPtr)
- ✅ 字符串池优化
- ✅ 引用计数内存管理
- ✅ Dart 语法糖支持
- ✅ 异步编程支持
- ✅ OOP 特性 (接口、Mixin)

## 快速开始

### 1. 安装依赖

```bash
cd pkg/dart2cpp
dart pub get
```

### 2. 使用转换器

```bash
# 转换 Dart 文件到 C++
dart bin/dart2cpp.dart input.dart -o output.cpp

# 或使用 pub run
dart pub run dart2cpp input.dart -o output.cpp
```

### 3. 编译生成的 C++ 代码

```bash
cd cpp
make
# 或使用 CMake
mkdir build && cd build
cmake ..
make
```

### 4. 运行示例

```bash
# 编译C++示例
cd cpp
make examples

# 运行
./build/hello_example
```

## 使用示例

### 输入 Dart 代码

```dart
void main() {
  var message = 'Hello, Dart2CPP!';
  var numbers = [1, 2, 3, 4, 5];
  
  print(message);
  
  for (var num in numbers) {
    print(num);
  }
}
```

### 生成的 C++ 代码

```cpp
#include "object.h"
#include "object_extensions_simple.h"

int main() {
    String message = String("Hello, Dart2CPP!");
    ObjectPtr<List<Int>> numbers = List<Int>::create();
    numbers->add(Int(1));
    numbers->add(Int(2));
    numbers->add(Int(3));
    numbers->add(Int(4));
    numbers->add(Int(5));
    
    std::cout << message.getValue() << std::endl;
    
    for (Int i(0); i.toInt() < numbers->size().toInt(); ++i) {
        Int num = numbers->get(i);
        std::cout << num.toString().getValue() << std::endl;
    }
    
    return 0;
}
```

## 命令行选项

```bash
dart2cpp [options] <input.dart>

Options:
  -o, --output <file>      输出C++文件路径
  -h, --help              显示帮助信息
  -v, --verbose           显示详细信息
  --no-runtime            不包含运行时库
  --optimize              启用优化
```

## 开发指南

### 运行 Dart 测试

```bash
dart test
```

### 运行 C++ 测试

```bash
cd cpp
make test
./build/run_tests
```

### 添加新的转换规则

1. 在 `lib/dart_to_cpp_compiler.dart` 中添加转换逻辑
2. 在 `test/` 中添加测试用例
3. 运行测试验证

### 扩展 C++ 运行时库

1. 在 `cpp/core/` 中添加新的类型或功能
2. 在 `cpp/test/` 中添加测试
3. 更新文档

## 类型映射

| Dart 类型 | C++ 类型 | 说明 |
|----------|---------|------|
| `int` | `Int` | 32位整数 |
| `double` | `Double` | 64位浮点数 |
| `bool` | `Bool` | 布尔值 |
| `String` | `String` | 字符串 |
| `List<T>` | `ObjectPtr<List<T>>` | 列表 |
| `Set<T>` | `ObjectPtr<Set<T>>` | 集合 |
| `Map<K,V>` | `ObjectPtr<Map<K,V>>` | 映射 |
| 自定义类 | `ObjectPtr<CustomClass>` | 用户类 |

## 文档

- [快速入门](doc/quickstart.md)
- [转换指南](doc/conversion_guide.md)
- [API 文档](doc/api_documentation.md)
- [C++ 运行时库](cpp/README.md)
- [开发指南](doc/development.md)

## 限制和已知问题

- 不支持 Dart 的反射特性
- 异步功能为简化实现
- 部分高级语法需要手动调整
- 泛型支持有限

## 贡献

欢迎提交 Issue 和 Pull Request！

## 许可证

与 Dart SDK 相同的许可证

## 相关项目

- [dart2bytecode](../dart2bytecode) - Dart 字节码编译器
- [Dart SDK](https://github.com/dart-lang/sdk)

