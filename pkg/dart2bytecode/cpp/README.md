# C++ 核心类库

这是一个C++实现的核心类库，提供了类似于Dart语言中的基础类型和功能。

## 项目结构

- `core/` - 核心类库源代码
  - `object.h/cpp` - Object基类定义和实现
  - `string.h/cpp` - String类定义和实现
  - `num.h/cpp` - 数值类型定义和实现（Num, Int, Double, Bool）
  - `array.h/cpp` - 数组类定义和实现
  - `func.h/cpp` - 函数类型定义和实现
- `test/` - 测试代码
  - `core_test.cpp` - 核心类库测试程序

## 主要类

1. **Object** - 所有类的基类
2. **String** - 字符串类，提供丰富的字符串操作方法
3. **Num** - 数值类型基类
   - **Int** - 整数类型
   - **Double** - 浮点数类型
4. **Bool** - 布尔类型
5. **CppArray** - 数组类型
6. **Function** - 函数类型基类

## 构建和测试

### 构建项目

```bash
make
```

### 运行测试

```bash
make test
```

### 清理构建文件

```bash
make clean
```

## 使用示例

```cpp
#include "core/string.h"
#include "core/num.h"
#include "core/array.h"

// 创建字符串
String str("Hello, World!");
String* upper = str.toUpperCase();
String* sub = str.substring(new Int(0), new Int(5));

// 使用数值类型
Int i(42);
Double d(3.14);
Num* sum = i.cpp_add(&d);

// 使用数组
CppArray arr(5);
arr.set(0, new Int(10));
arr.set(1, new String("Hello"));
```

## 特性

- 所有类都继承自Object基类
- 自动内存管理（通过引用计数）
- 丰富的字符串操作方法
- 数值类型支持各种运算
- 类型安全的数组实现

## 注意事项

- 使用noexcept关键字标记不抛出异常的函数
- 所有方法返回新对象，调用者负责释放内存
- 字符串使用StringPool进行内部优化 