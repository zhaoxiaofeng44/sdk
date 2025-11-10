#include "../../cpp/core/object.h"
#include <iostream>

// 工具宏定义
#define dart_print(value) \
    do { \
        std::cout << (value).toString().getValue() << std::endl; \
    } while(0)

// 简单的测试类
class SimpleTest : public Object {
public:
    String name;
    Int value;
    
    SimpleTest(const String& n, const Int& v) : name(n), value(v) {}
    
    void doSomething() const {
        dart_print(String("Hello from ") + name + String(", value: ") + value.toString());
    }
    
    String toString() const override {
        return String("SimpleTest(") + name + String(", ") + value.toString() + String(")");
    }
};

int main() {
    try {
        dart_print(String("🔥 简单测试开始"));
        
        // 创建测试对象
        SimpleTest test(String("TestObject"), Int(42));
        test.doSomething();
        
        // 测试基本类型
        String str = String("Hello World");
        Int num = Int(123);
        Bool flag = Bool(true);
        Double pi = Double(3.14159);
        
        dart_print(String("字符串: ") + str);
        dart_print(String("整数: ") + num.toString());
        dart_print(String("布尔: ") + flag.toString());
        dart_print(String("浮点: ") + pi.toString());
        
        // 测试列表
        ObjectPtr<List<String>> stringList = List<String>::create();
        stringList->add(String("First"));
        stringList->add(String("Second"));
        stringList->add(String("Third"));
        
        dart_print(String("列表大小: ") + stringList->size().toString());
        dart_print(String("第一个元素: ") + stringList->get(Int(0)));
        
        dart_print(String("✅ 简单测试完成"));
        
    } catch (const std::exception& e) {
        std::cerr << "错误: " << e.what() << std::endl;
        return 1;
    }
    
    return 0;
}