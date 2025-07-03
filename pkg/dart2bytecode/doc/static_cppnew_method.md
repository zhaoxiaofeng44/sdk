# 静态 cppNew 方法功能

## 概述

静态 cppNew 方法功能是 Dart 到 C++ 转换器的重要改进，将原本的全局 `cppNew` 函数改为类的静态方法。这种设计更符合面向对象编程的原则，提供了更清晰的代码结构和更好的命名空间管理。

## 功能特点

### 1. 面向对象设计
- `cppNew` 作为类的静态方法，而不是全局函数
- 使用标准的 C++ 静态方法调用语法：`ClassName::cppNew()`
- 更好的命名空间隔离，避免全局函数污染

### 2. 清晰的代码结构
- 头文件只包含类前置声明，不再有全局函数声明
- 每个类都有自己的静态工厂方法
- 符合现代 C++ 设计模式

### 3. 类型安全
- 静态方法返回正确的类型指针
- 编译时类型检查
- 更好的 IDE 支持和代码提示

## 生成的代码结构

### 头文件 (output.h)
```cpp
#ifndef OUTPUT_H
#define OUTPUT_H

#include <cstdio>
#include <cstdlib>
#include <sstream>
#include "src/core/func.h"
#include "src/core/num.h"
#include "src/core/string.h"

// 只包含类前置声明
class Calculator;
class ComplexNumber;

#endif // OUTPUT_H
```

### 源文件 (output.cpp)
```cpp
#include "output.h"

// 完整的类定义
class Calculator : public Object {
public:
    Int* value;
    
    // 成员函数声明
    cppCtr_(Int* initialValue);
    Int* add(Int* x);
    Int* getValue();
    
    // 静态 cppNew 方法声明
    static Calculator* cppNew();
};

// 成员函数实现
Calculator::cppCtr_(Int* initialValue) {
    this->value = initialValue;
    return this;
}

Int* Calculator::add(Int* x) {
    this->value = this->value->cpp_add(x);
    return this->value;
}

Int* Calculator::getValue() {
    return this->value;
}

// 静态 cppNew 方法实现
Calculator* Calculator::cppNew() {
    auto ptr = (Calculator*)malloc(sizeof(Calculator));
    return ptr;
}
```

## 调用语法对比

### 之前的全局函数调用
```cpp
// 全局函数调用
Calculator* calc = Calculator_cppNew();
Int* value = Int_cppNew(42);
String* text = String_cppNew("Hello", sizeof("Hello"));
```

### 现在的静态方法调用
```cpp
// 静态方法调用
Calculator* calc = Calculator::cppNew();
Int* value = Int::cppNew(42);
String* text = String::cppNew("Hello", sizeof("Hello"));
```

## 技术实现

### 1. 类定义修改
在每个类的定义中添加静态方法声明：
```cpp
class ClassName : public Object {
public:
    // 成员变量和方法...
    
    // 静态 cppNew 方法声明
    static ClassName* cppNew();
};
```

### 2. 静态方法实现
生成标准的 C++ 静态方法实现：
```cpp
ClassName* ClassName::cppNew() {
    auto ptr = (ClassName*)malloc(sizeof(ClassName));
    return ptr;
}
```

### 3. 调用生成更新
- 构造函数调用：`ClassName::cppNew()` 而不是 `ClassName_cppNew()`
- 字面量创建：`Int::cppNew(42)` 而不是 `Int_cppNew(42)`
- 常量处理：使用静态方法调用语法

## 使用示例

### Dart 源代码
```dart
class Calculator {
  int value = 0;
  
  Calculator(int initialValue) {
    this.value = initialValue;
  }
  
  int add(int x) {
    this.value = this.value + x;
    return this.value;
  }
}

void main() {
  var calc = Calculator(10);
  calc.add(5);
  
  int number = 42;
  String text = "Hello";
  bool flag = true;
}
```

### 生成的 C++ 代码
```cpp
class Calculator : public Object {
public:
    Int* value;
    cppCtr_(Int* initialValue);
    Int* add(Int* x);
    static Calculator* cppNew();
};

Calculator::cppCtr_(Int* initialValue) {
    this->value = initialValue;
    return this;
}

Int* Calculator::add(Int* x) {
    this->value = this->value->cpp_add(x);
    return this->value;
}

Calculator* Calculator::cppNew() {
    auto ptr = (Calculator*)malloc(sizeof(Calculator));
    return ptr;
}

void main() {
    Calculator* calc = Calculator_cppCtr_(Calculator::cppNew(), Int::cppNew(10));
    calc->add(Int::cppNew(5));
    
    Int* number = Int::cppNew(42);
    String* text = String::cppNew("Hello", sizeof("Hello"));
    Bool* flag = Bool::cppNew(true);
}
```

## 优势分析

### 1. 更好的命名空间管理
- 避免全局函数名称冲突
- 每个类负责自己的对象创建
- 符合 C++ 封装原则

### 2. 类型安全
- 静态方法返回正确的类型
- 编译时类型检查
- 减少类型转换错误

### 3. IDE 支持
- 更好的代码补全
- 清晰的类型层次结构
- 更容易的代码导航

### 4. 维护性
- 代码结构更清晰
- 更容易理解和修改
- 符合现代 C++ 最佳实践

## 兼容性

### 保持的功能
- 所有成员函数保持不变
- 类继承关系保持不变
- 内存管理方式保持不变
- 构造函数调用逻辑保持不变

### 改变的部分
- 对象创建使用静态方法而不是全局函数
- 头文件不再包含全局函数声明
- 字面量创建使用静态方法语法

## 测试验证

使用 `test/static_cppnew_demo.dart` 测试文件验证功能：

```bash
dart bin/dart2bytecode.dart test/static_cppnew_demo.dart
```

生成的代码展示了完整的静态方法功能，包括：
- 类的静态 cppNew 方法声明和实现
- 字面量类型的静态方法调用
- 构造函数中的静态方法使用
- 复杂表达式中的静态方法调用

## 总结

静态 cppNew 方法功能将 Dart 到 C++ 转换器的代码生成质量提升到了新的高度。通过采用面向对象的设计模式，生成的代码更加清晰、类型安全且易于维护。这种改进不仅符合现代 C++ 的最佳实践，也为后续的功能扩展提供了更好的基础架构。 