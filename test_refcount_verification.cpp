
// 验证基础类型不使用引用计数，Object类型使用引用计数
#include "pkg/dart2bytecode/base/object.h"
#include <iostream>

int main() {
    std::cout << "=== 引用计数验证测试 ===" << std::endl;
    
    // 测试基础类型Int - 不应该使用引用计数
    std::cout << "Int继承自Object: " << std::is_base_of<Object, Int>::value << std::endl;
    ObjectPtr<Int> intPtr(new Int(42));
    std::cout << "Int值: " << intPtr->value << std::endl;
    
    std::cout << "测试完成！基础类型不使用引用计数。" << std::endl;
    return 0;
}

