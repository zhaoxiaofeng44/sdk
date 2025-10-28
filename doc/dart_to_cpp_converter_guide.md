# Dart 到 C++ 转换器使用指南

## 概述

本项目提供了一套完整的 Dart 到 C++ 转换系统，基于现有的 `base` 项目架构，实现了 Dart 语法到 C++ 的高度兼容转换。

## 转换器架构

### 1. 核心转换器 (`dart_to_cpp_compiler.dart`)

完整的基于 Kernel AST 的转换器，支持：
- 完整的语法分析和转换
- 类型系统转换
- 面向对象特性转换
- 异步编程转换
- 泛型支持

### 2. 简化转换器 (`simple_dart_to_cpp.dart`)

基于文本模式的快速转换器，适用于：
- 快速原型转换
- 简单代码转换
- 学习和实验

### 3. 命令行工具 (`dart_to_cpp_tool.dart`)

功能完整的命令行界面，提供：
- 多种转换模板
- 详细的分析输出
- 自动编译脚本生成

## 支持的 Dart 语法特性

### ✅ 已完全支持

1. **基础类型**
   - `int` → `Int`
   - `double` → `Double` 
   - `bool` → `Bool`
   - `String` → `String`

2. **变量声明**
   - `var` → `auto`
   - `final` → `const auto`
   - `const` → `const auto`

3. **运算符**
   - 算术运算符：`+`, `-`, `*`, `/`, `%`
   - 比较运算符：`==`, `!=`, `<`, `<=`, `>`, `>=`
   - 逻辑运算符：`&&`, `||`, `!`
   - 字符串连接：`+`

4. **控制流**
   - `if` / `else`
   - `for` 循环
   - `while` 循环
   - `switch` 语句
   - `break` / `continue`

5. **面向对象**
   - 类定义和实例化
   - 构造函数
   - 方法定义和调用
   - 继承 (`extends`)
   - 接口实现 (`implements`)
   - 混入 (`with`)
   - 抽象类和方法
   - 静态成员

6. **集合类型**
   - `List<T>`
   - `Set<T>`
   - `Map<K,V>`

7. **异步编程**
   - `Future<T>`
   - `async` / `await`
   - `Stream<T>`

8. **异常处理**
   - `try` / `catch` / `finally`
   - 自定义异常

### ⚠️ 部分支持

1. **泛型约束**：使用 C++ 模板约束
2. **命名构造函数**：转换为静态工厂方法
3. **扩展方法**：转换为全局函数
4. **操作符重载**：部分操作符支持

### ❌ 暂不支持

1. **反射和元编程**
2. **Isolate 并发**
3. **动态类型检查的完整支持**

## 使用方法

### 方法一：使用完整转换器

```bash
# 基本转换
dart tools/dart_to_cpp_tool.dart --input example.dart --output example.cpp

# 详细模式
dart tools/dart_to_cpp_tool.dart -i example.dart -o example.cpp --verbose

# 使用特定模板
dart tools/dart_to_cpp_tool.dart -i example.dart -o example.cpp --template oop

# 只分析不生成代码
dart tools/dart_to_cpp_tool.dart -i example.dart -o example.cpp --analyze
```

### 方法二：使用简化转换器

```bash
# 快速转换
dart tools/simple_dart_to_cpp.dart input.dart output.cpp
```

### 方法三：使用测试脚本

```bash
# 运行完整测试
cd test
chmod +x test_dart_to_cpp.sh
./test_dart_to_cpp.sh
```

## 转换模板说明

### Simple 模板
- 最基础的转换
- 只包含核心类型和基本语法
- 适用于简单程序

### OOP 模板  
- 包含面向对象特性
- 支持接口、混入、继承
- 适用于复杂的类结构

### Async 模板
- 包含异步编程支持
- 支持 Future、async/await
- 适用于异步应用

### Full 模板（默认）
- 包含所有支持的特性
- 完整的功能集合
- 推荐用于生产代码

## 生成的 C++ 代码结构

```cpp
#include "../pkg/dart2bytecode/base/object.h"
#include "../pkg/dart2bytecode/base/dart_oop_extensions.h"
#include "../pkg/dart2bytecode/base/dart_async.h"
#include <iostream>

// 工具宏定义
#define dart_print(value) /* ... */
#define dart_int(value) Int(value)
#define dart_double(value) Double(value)
#define dart_bool(value) Bool(value)
#define dart_string(value) String(value)

// 转换后的类定义
class MyClass : public Object {
public:
    // 字段和方法
};

// 转换后的函数
RetType myFunction(ParamType param) {
    // 函数体
}

// 主函数
int main() {
    try {
        // 转换后的主逻辑
        return 0;
    } catch (const std::exception& e) {
        std::cerr << "Error: " << e.what() << std::endl;
        return 1;
    }
}
```

## 编译生成的 C++ 代码

转换器会自动生成编译脚本：

```bash
# 使用生成的编译脚本
./output_compile.sh

# 或手动编译
g++ -std=c++17 -Wall -Wextra -O2 \
    output.cpp \
    ../pkg/dart2bytecode/base/object.cpp \
    -o output
```

## 示例转换

### Dart 源码

```dart
class Person {
  String name;
  int age;
  
  Person(this.name, this.age);
  
  String greet() {
    return "Hello, I'm $name and I'm $age years old.";
  }
  
  bool isAdult() {
    return age >= 18;
  }
}

void main() {
  var person = Person("Alice", 25);
  print(person.greet());
  print("Is adult: ${person.isAdult()}");
}
```

### 转换后的 C++ 代码

```cpp
class Person : public Object {
public:
    String name;
    Int age;
    
    Person(String n, Int a) : name(n), age(a) {}
    
    String greet() {
        return dart_string("Hello, I'm ") + name + 
               dart_string(" and I'm ") + age.toString() + 
               dart_string(" years old.");
    }
    
    Bool isAdult() {
        return age >= dart_int(18);
    }
};

int main() {
    try {
        auto person = Person(dart_string("Alice"), dart_int(25));
        dart_print(person.greet());
        dart_print(dart_string("Is adult: ") + person.isAdult().toString());
        return 0;
    } catch (const std::exception& e) {
        std::cerr << "Error: " << e.what() << std::endl;
        return 1;
    }
}
```

## 故障排除

### 编译错误

1. **缺少头文件**：确保 `base` 目录中的头文件存在
2. **C++17 支持**：确保编译器支持 C++17 标准
3. **链接错误**：确保链接了 `object.cpp`

### 转换错误

1. **复杂语法**：某些高级 Dart 语法可能需要手动调整
2. **类型转换**：检查自定义类型是否正确映射
3. **依赖关系**：确保所有依赖的类都已转换

## 扩展和定制

### 添加新的类型转换

在 `CppTypeConverter` 中添加新的映射：

```dart
static const Map<String, String> typeMapping = {
  // 现有映射...
  'MyCustomType': 'MyCppType',
};
```

### 添加新的语法转换

在相应的转换器类中添加新的转换规则：

```dart
String _convertCustomSyntax(String line) {
  // 自定义转换逻辑
  return convertedLine;
}
```

### 创建自定义模板

参考现有模板，创建适合特定需求的转换模板。

## 贡献指南

1. Fork 项目
2. 创建特性分支
3. 添加测试用例
4. 提交 Pull Request

## 许可证

本项目遵循与主项目相同的许可证。

