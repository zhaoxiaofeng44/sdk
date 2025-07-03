# Dart 到 C++ 转换器 - 文件输出功能

## 概述

这个修改版的 Dart 到 C++ 转换器现在可以直接将生成的代码输出到文件中，而不需要手动复制粘贴。

## 主要特性

### ✨ 自动文件生成

- **自动创建文件**：运行转换器后自动在当前目录生成 `output.h` 和 `output.cpp`
- **覆盖现有文件**：如果文件已存在，新的转换结果会覆盖原文件
- **错误恢复**：如果文件写入失败，会自动回退到控制台输出

### 📁 文件结构

```
./
├── output.h      # 头文件 - 包含类声明和方法声明
└── output.cpp    # 源文件 - 包含方法实现
```

### 🚀 使用流程

1. **运行转换器**
   ```bash
   dart run lib/compile_to_cpp.dart input.dart
   ```

2. **查看生成的文件**
   ```bash
   ls -la output.*
   -rw-r--r-- output.h
   -rw-r--r-- output.cpp
   ```

3. **编译 C++ 代码**
   ```bash
   # 方式1：分步编译
   g++ -c output.cpp -o output.o
   g++ main.cpp output.o -o program
   
   # 方式2：一步编译
   g++ main.cpp output.cpp -o program
   ```

### 💡 输出示例

转换器运行时的控制台输出：

```
成功生成头文件: /path/to/your/project/output.h
成功生成源文件: /path/to/your/project/output.cpp
```

如果出现错误：

```
写入文件时发生错误: Permission denied

=== output.h (文件写入失败，显示内容) ===
[头文件内容会在控制台显示]

=== output.cpp (文件写入失败，显示内容) ===
[源文件内容会在控制台显示]
```

### 🔧 生成的文件格式

#### output.h 结构
```cpp
#ifndef OUTPUT_H
#define OUTPUT_H

#include <cstdio>
#include <cstdlib>
// ... 其他必要头文件

// 类前置声明
class Calculator;

// 全局方法声明（不包含类实现）
Int* Calculator_add(Calculator* cppThis, Int* other);
Calculator* Calculator_cppNew();

#endif // OUTPUT_H
```

#### output.cpp 结构
```cpp
#include "output.h"

// 类实现（包含数据成员）
class Calculator : public Object {
public:
    Int* value;
};

// 方法实现
Int* Calculator_add(Calculator* cppThis, Int* other) {
    cppThis->value = Int_cpp_add(cppThis->value, other);
    return cppThis->value;
}

Calculator* Calculator_cppNew() {
    auto ptr = (Calculator*)malloc(sizeof(Calculator));
    return ptr;
}
```

### ⚙️ 技术细节

- **同步写入**：使用 `writeAsStringSync()` 确保文件完全写入
- **绝对路径显示**：成功时显示文件的完整路径
- **异常处理**：完整的错误处理和用户反馈
- **回退机制**：文件操作失败时的安全回退

### 🎯 优势

1. **即用性**：生成后可直接编译，无需手动操作
2. **标准结构**：符合 C++ 项目的标准文件组织
3. **工具友好**：与 IDE、构建系统、版本控制无缝集成
4. **错误恢复**：即使文件操作失败也能获得转换结果

### 📝 注意事项

- 确保当前目录有写入权限
- 现有的 `output.h` 和 `output.cpp` 文件会被覆盖
- 建议在专门的构建目录中运行转换器
- 如果需要保留多个版本，请在运行前备份或重命名现有文件

### 🔄 从控制台输出迁移

如果你之前使用的是控制台输出版本：

**旧方式：**
```bash
dart run converter.dart > output.txt
# 然后手动分离头文件和源文件
```

**新方式：**
```bash
dart run converter.dart
# 自动生成 output.h 和 output.cpp
```

这个改进大大简化了工作流程，提高了开发效率！ 