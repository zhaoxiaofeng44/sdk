
// 简单测试：验证基础类型不使用引用计数
#include "./core/object.h"
#include <iostream>

int main() {
    std::cout << "基础类型Int是否继承自Object: " << std::is_base_of<Object, Int>::value << std::endl;
    std::cout << "自定义类型Person是否继承自Object: " << std::is_base_of<Object, Person>::value << std::endl;
    
    // 测试基础类型ObjectPtr
    ObjectPtr<Int> intPtr(new Int(42));
    std::cout << "Int值: " << intPtr->value << std::endl;
    
    // 测试对象类型ObjectPtr
    ObjectPtr<Person> personPtr = Person::create(String("测试"), Int(25));
    std::cout << "Person引用计数: " << personPtr->getRefCount() << std::endl;
    
    return 0;
}

