# Dart2CPP C++ Runtime Library

这是 dart2cpp 项目的 C++ 运行时库部分。

## 目录结构

```
cpp/
├── core/           # 核心运行时库
│   ├── object.h   # 基础类型定义
│   ├── object.cpp # 基础类型实现
│   ├── dart2cpp.h # 主头文件
│   └── ...        # 其他头文件
├── test/          # C++ 测试用例
├── examples/      # C++ 示例程序
├── build/         # 构建输出（自动生成）
├── Makefile       # Make 构建脚本
└── CMakeLists.txt # CMake 配置
```

## 快速开始

### 编译核心库

```bash
make
```

### 编译测试

```bash
make test
```

### 编译示例

```bash
make examples
./build/hello_example
```

### 清理

```bash
make clean
```

## 在你的代码中使用

### 包含头文件

```cpp
#include "dart2cpp.h"
```

### 编译你的程序

```bash
g++ -std=c++11 -I./core your_program.cpp core/object.cpp -o your_program
```

## 核心类型

- `Int` - 整数
- `Double` - 浮点数
- `Bool` - 布尔值
- `String` - 字符串
- `List<T>` - 列表
- `Set<T>` - 集合
- `Map<K,V>` - 映射
- `ObjectPtr<T>` - 智能指针

## 示例代码

```cpp
#include "dart2cpp.h"

int main() {
    Int x = Int(42);
    String message = String("Hello, Dart2CPP!");
    
    ObjectPtr<List<Int>> numbers = List<Int>::create();
    numbers->add(Int(1));
    numbers->add(Int(2));
    
    std::cout << message.getValue() << std::endl;
    
    return 0;
}
```

## 文档

详见项目根目录的文档。

