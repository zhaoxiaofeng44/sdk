# Dart C++ 运行库实现文档

## 概述

本文档描述了为 Dart 语言设计的 C++ 运行库实现，该实现在 `pkg/dart2bytecode/base/object.h` 文件中提供了与 Dart 基础类型完全对齐的 C++ 类定义。

## 设计理念

### 核心设计原则

1. **完全对齐**: 所有 C++ 类的方法和操作符与 Dart 对应类型完全一致
2. **类型安全**: 通过强类型系统确保操作的安全性
3. **内存管理**: 自动管理内存分配和释放，防止内存泄漏
4. **性能优化**: 尽可能使用 C++ 的高性能特性
5. **异常处理**: 适当的错误处理和异常抛出

### 类型层次结构

```
Any (基类)
├── Int (整数类型)
├── Double (双精度浮点数类型)
├── Bool (布尔类型)
├── String (字符串类型)
├── Null (空值类型)
├── Void (空类型)
└── Object<T> (模板类，用于包装其他类型)
```

## 类型实现详情

### 1. Any 基类

```cpp
class Any {
 public:
  int type_id;  // 类型标识符
};
```

- 所有类型的基类
- 包含类型标识符用于运行时类型检查

### 2. Int 类 (type_id = 1)

#### 主要特性
- 完整的算术运算符: `+`, `-`, `*`, `/`, `%`
- 位运算符: `&`, `|`, `^`, `<<`, `>>`, `~`
- 比较运算符: `==`, `!=`, `<`, `<=`, `>`, `>=`
- 特殊方法: `integerDivision()` (对应 Dart 的 `~/`)

#### Dart 对齐的方法
- `abs()`: 绝对值
- `toString()`: 转换为字符串
- `toDouble()`: 转换为双精度浮点数
- `compareTo()`: 比较两个整数
- `gcd()`: 最大公约数
- 属性方法: `get_sign()`, `get_isEven()`, `get_isOdd()`, `get_isNegative()` 等

#### 使用示例
```cpp
Int a(10);
Int b(5);
Int sum = a + b;        // 15
Int quotient = a / b;   // 2
Int gcd_result = a.gcd(b); // 5
bool is_even = a.get_isEven(); // true
```

### 3. Double 类 (type_id = 2)

#### 主要特性
- 算术运算符: `+`, `-`, `*`, `/`, `%`
- 比较运算符: `==`, `!=`, `<`, `<=`, `>`, `>=`
- 特殊值处理: 正确处理 `NaN`, `Infinity`, `-Infinity`

#### Dart 对齐的方法
- `abs()`: 绝对值
- `floor()`, `ceil()`, `round()`, `truncate()`: 数学舍入函数
- `toInt()`: 转换为整数
- `toString()`: 转换为字符串
- `compareTo()`: 比较两个双精度数
- 属性方法: `get_sign()`, `get_isFinite()`, `get_isNaN()`, `get_isInfinite()` 等

#### 使用示例
```cpp
Double pi(3.14159);
Double floor_val = pi.floor();     // 3.0
Double ceil_val = pi.ceil();       // 4.0
bool is_finite = pi.get_isFinite(); // true
```

### 4. Bool 类 (type_id = 3)

#### 主要特性
- 逻辑运算符: `&&`, `||`, `!`
- 比较运算符: `==`, `!=`

#### Dart 对齐的方法
- `toString()`: 转换为字符串 ("true" 或 "false")
- `compareTo()`: 比较两个布尔值 (true > false)

#### 使用示例
```cpp
Bool t(true);
Bool f(false);
Bool result = t && f;  // false
std::string str = t.toString(); // "true"
```

### 5. String 类 (type_id = 4)

#### 主要特性
- 字符串连接: `+` 运算符
- 索引访问: `[]` 运算符
- 比较运算符: `==`, `!=`, `<`, `<=`, `>`, `>=`

#### Dart 对齐的方法
- **长度和空值检查**:
  - `get_length()`: 获取字符串长度
  - `get_isEmpty()`, `get_isNotEmpty()`: 检查是否为空

- **搜索方法**:
  - `indexOf()`, `lastIndexOf()`: 查找子字符串位置
  - `contains()`: 检查是否包含子字符串
  - `startsWith()`, `endsWith()`: 检查前缀和后缀

- **转换方法**:
  - `toLowerCase()`, `toUpperCase()`: 大小写转换
  - `substring()`: 提取子字符串

- **修整方法**:
  - `trim()`: 去除首尾空白字符
  - `trimLeft()`, `trimRight()`: 去除单侧空白字符

- **替换方法**:
  - `replaceAll()`: 替换所有匹配项
  - `replaceFirst()`: 替换第一个匹配项

- **填充方法**:
  - `padLeft()`, `padRight()`: 字符串填充

#### 使用示例
```cpp
String str("Hello World");
String sub = str.substring(0, 5);  // "Hello"
int pos = str.indexOf(String("World")); // 6
String upper = str.toUpperCase();  // "HELLO WORLD"
String trimmed = String("  test  ").trim(); // "test"
```

### 6. Object<T> 模板类 (type_id = 5)

#### 主要特性
- 泛型指针包装器
- 自动内存管理
- 拷贝构造和赋值语义
- 空值检查

#### 核心方法
- `isNull()`, `isNotNull()`: 空值检查
- `get()`, `set()`: 获取和设置指针
- `dispose()`: 手动内存释放
- 重载运算符: `->`, `*`, `==`, `!=`

#### 使用示例
```cpp
Object<int> obj(new int(42));
if (obj.isNotNull()) {
    std::cout << *obj << std::endl;  // 42
}
obj.set(new int(100));
// 析构时自动释放内存
```

## 内存管理

### 自动内存管理
1. **RAII 原则**: 构造函数分配资源，析构函数释放资源
2. **拷贝语义**: 深拷贝确保独立的内存管理
3. **异常安全**: 在异常情况下也能正确释放内存

### Object<T> 的内存策略
- 构造时可接受已分配的指针
- 拷贝构造时创建新的对象副本
- 赋值时先释放原有内存再分配新内存
- 析构时自动调用 dispose() 释放内存

## 类型转换

### 隐式转换
```cpp
// Int 到基本类型
Int a(10);
int native_int = a;     // 隐式转换到 int
double native_double = a; // 隐式转换到 double
bool is_nonzero = a;    // 隐式转换到 bool (非零为 true)

// Double 到基本类型
Double b(3.14);
double native = b;      // 隐式转换到 double
int truncated = b;      // 隐式转换到 int (截断)

// String 到基本类型
String s("Hello");
std::string native_str = s;     // 隐式转换到 std::string
const char* cstr = s;           // 隐式转换到 C 字符串
```

### 显式转换
```cpp
Int a(10);
Double b = Double(a);   // Int 到 Double
String s = String(a.toString()); // Int 到 String
```

## 异常处理

### 异常类型
1. **std::runtime_error**: 除零错误
2. **std::out_of_range**: 索引越界、子字符串范围错误

### 异常使用示例
```cpp
try {
    Int a(10);
    Int b(0);
    Int result = a / b;  // 抛出 std::runtime_error
} catch (const std::runtime_error& e) {
    std::cerr << "Runtime error: " << e.what() << std::endl;
}

try {
    String s("Hello");
    char c = s[10];  // 抛出 std::out_of_range
} catch (const std::out_of_range& e) {
    std::cerr << "Out of range: " << e.what() << std::endl;
}
```

## 编译要求

### 必需的头文件
```cpp
#include <cstddef>   // NULL
#include <cstdlib>   // malloc
#include <cmath>     // 数学函数
#include <string>    // 字符串操作
#include <sstream>   // 字符串流
#include <iostream>  // 输入输出
#include <algorithm> // 算法函数
#include <climits>   // 限制常量
#include <stdexcept> // 异常处理
#include <cctype>    // 字符处理函数
#include <functional> // 函数对象
```

### 编译器要求
- C++11 或更高版本 (推荐 C++14)
- 支持模板特化
- 支持异常处理

## 性能考虑

### 优化策略
1. **内联函数**: 简单的获取器和设置器使用内联
2. **移动语义**: 在适当的地方使用移动构造和赋值
3. **常量正确性**: 大量使用 const 修饰符提高编译器优化
4. **引用传递**: 避免不必要的拷贝

### 内存效率
1. **小对象优化**: 基本类型直接存储值而不是指针
2. **延迟计算**: 字符串操作只在需要时计算结果
3. **预分配**: String 类使用 std::string 的预分配策略

## 使用指南

### 基本使用模式
```cpp
#include "pkg/dart2bytecode/base/object.h"

int main() {
    // 创建基本类型
    Int number(42);
    Double pi(3.14159);
    Bool flag(true);
    String message("Hello, Dart!");
    
    // 执行操作
    Int result = number + Int(8);  // 50
    String upper = message.toUpperCase(); // "HELLO, DART!"
    
    // 使用 Object 包装复杂类型
    Object<std::vector<int>> list(new std::vector<int>{1, 2, 3});
    
    return 0;
}
```

### 最佳实践

1. **异常处理**: 始终在可能抛出异常的代码周围使用 try-catch
2. **内存管理**: 对于 Object<T>，确保传递的指针是通过 new 分配的
3. **类型转换**: 优先使用显式类型转换以提高代码可读性
4. **常量使用**: 对不会修改的对象使用 const 修饰符

## 扩展性

### 添加新类型
要添加新的 Dart 类型支持:

1. 继承 Any 基类
2. 设置唯一的 type_id
3. 实现必要的运算符重载
4. 实现 Dart 对应的方法
5. 添加适当的类型转换

### 示例：添加 List 类型
```cpp
class List : public Any {
 public:
  std::vector<Any*> elements;
  
  List() { type_id = 6; }
  
  void add(Any* element) {
    elements.push_back(element);
  }
  
  Any* operator[](int index) {
    if (index < 0 || index >= elements.size()) {
      throw std::out_of_range("List index out of range");
    }
    return elements[index];
  }
  
  int get_length() const {
    return static_cast<int>(elements.size());
  }
};
```

## 总结

这个 Dart C++ 运行库实现提供了:

1. **完整的类型系统**: 涵盖 Dart 的主要基本类型
2. **方法对齐**: 与 Dart API 完全一致的方法签名
3. **内存安全**: 自动内存管理和异常安全
4. **高性能**: 利用 C++ 的性能优势
5. **易扩展**: 清晰的架构支持新类型添加

该实现为 Dart 到 C++ 的编译或互操作提供了坚实的基础，确保了类型安全性和性能优化的平衡。
