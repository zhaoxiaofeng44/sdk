#include "pkg/dart2bytecode/base/object.h"
#include <iostream>

// 简单的工具宏
#define dart_print(value) \
    do { \
        std::cout << (value).toString().getValue() << std::endl; \
    } while(0)

#define dart_int(value) Int(value)
#define dart_double(value) Double(value)
#define dart_bool(value) Bool(value)
#define dart_string(value) String(value)

// 测试基本功能
int main() {
    try {
        dart_print(dart_string("=== 测试 transformed_dart.dart.cpp 的基础功能 ==="));
        
        // 测试基本类型
        Int x = dart_int(42);
        String name = dart_string("Hello");
        Bool flag = dart_bool(true);
        
        dart_print(dart_string("Int: ") + x.toString());
        dart_print(dart_string("String: ") + name);
        dart_print(dart_string("Bool: ") + flag.toString());
        
        // 测试运算
        Int sum = x + dart_int(8);
        dart_print(dart_string("42 + 8 = ") + sum.toString());
        
        // 测试条件
        if (flag) {
            dart_print(dart_string("条件测试通过"));
        }
        
        dart_print(dart_string("✅ 基础功能测试通过"));
        
        return 0;
    } catch (const std::exception& e) {
        std::cerr << "错误: " << e.what() << std::endl;
        return 1;
    }
}

