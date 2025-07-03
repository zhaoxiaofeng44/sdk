import '../lib/compile_to_cpp333.dart';

/// 测试输出分离功能
void main() {
  print("=== 测试修改后的文件输出逻辑 ===");

  print('''
修改后的输出逻辑特点：

1. 直接文件输出：
   - ./output.h：包含类声明和全局方法声明
   - ./output.cpp：包含全局方法实现

2. 头文件内容 (output.h)：
   - 头文件保护宏 (#ifndef OUTPUT_H)
   - 必要的 #include 语句
   - 类前置声明（class Calculator;）
   - 全局方法声明
   - 构造函数声明（如 ClassName_cppNew()）

3. 源文件内容 (output.cpp)：
   - #include "output.h"
   - 类的完整定义（包含字段）
   - 全局方法实现
   - 构造函数实现

示例输出格式：

=== output.h ===
#ifndef OUTPUT_H
#define OUTPUT_H

#include <cstdio>
#include <cstdlib>
// ... 其他头文件

class Calculator;

Int* Calculator_add(Calculator* cppThis, Int* other);
Calculator* Calculator_cppNew();

#endif // OUTPUT_H

=== output.cpp ===
#include "output.h"

class Calculator : public Object {
public:
    Int* value;
};

Int* Calculator_add(Calculator* cppThis, Int* other) {
    // 方法实现
}

Calculator* Calculator_cppNew() {
    auto ptr = (Calculator*)malloc(sizeof(Calculator));
    return ptr;
}

4. 文件输出特性：
   - 自动在当前目录创建 output.h 和 output.cpp
   - 如果文件已存在会被覆盖
   - 文件写入失败时会回退到控制台输出
   - 显示生成文件的绝对路径

5. 使用方式：
   运行转换器后，直接在当前目录下找到生成的文件：
   
   ls -la
   -rw-r--r-- output.h    // 头文件
   -rw-r--r-- output.cpp  // 源文件
   
   然后可以直接编译：
   g++ -c output.cpp -o output.o
   g++ main.cpp output.o -o program

这种直接文件输出使得：
- 无需手动复制粘贴代码
- 可以直接进行编译和测试
- 便于版本控制和项目管理
- 符合标准 C++ 项目结构
''');
}
