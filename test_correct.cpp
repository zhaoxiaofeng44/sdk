#include "pkg/dart2bytecode/base/object.h"
#include "pkg/dart2bytecode/base/object_extended.h"
#include <iostream>

int main() {
    std::cout << "===========================================" << std::endl;
    std::cout << "    正确的 ObjectPtr 使用演示" << std::endl;
    std::cout << "===========================================" << std::endl;
    
    try {
        // 1. 基础类型使用（直接使用）
        std::cout << "\n1. 基础类型使用" << std::endl;
        Int a(42);
        std::cout << "  Int: " << a.toString() << std::endl;
        
        // 2. List 使用（通过 ObjectPtr<Any>）
        std::cout << "\n2. List 使用" << std::endl;
        List list;
        
        // 添加基础类型（包装在 ObjectPtr 中）
        // 注意：这里我们需要显式转换，因为 List 期望 ObjectPtr<Any>
        ObjectPtr<Int> intPtr(new Int(42));
        ObjectPtr<String> strPtr(new String("Hello"));
        
        // 正确的方式：将 ObjectPtr<Int> 传递给期望 ObjectPtr<Any> 的地方
        // 但由于 ObjectPtr 不支持隐式向上转换，我们需要显式处理
        list.add(ObjectPtr<Any>(static_cast<Any*>(intPtr.get())));
        list.add(ObjectPtr<Any>(static_cast<Any*>(strPtr.get())));
        
        std::cout << "  List 长度: " << list.get_length() << std::endl;
        std::cout << "  List 内容: " << list.toString() << std::endl;
        
        // 获取元素
        ObjectPtr<Any> first = list.get(0);
        ObjectPtr<Any> second = list.get(1);
        
        std::cout << "  第一个元素类型: " << first->type_id << std::endl;
        std::cout << "  第二个元素类型: " << second->type_id << std::endl;
        
        // 3. 更简单的演示：直接使用基础类型
        std::cout << "\n3. 基础类型运算" << std::endl;
        Int x(10), y(20);
        Int sum = x + y;
        std::cout << "  " << x.toString() << " + " << y.toString() << " = " << sum.toString() << std::endl;
        
        String s1("Hello"), s2("World");
        String s3 = s1 + String(" ");
        std::cout << "  String: " << s3.toString() << std::endl;
        
        std::cout << "\n✅ 演示完成！" << std::endl;
        std::cout << "\n关键点：" << std::endl;
        std::cout << "• 基础类型（Int, String, Bool, Double）直接使用" << std::endl;
        std::cout << "• 所有自定义类（List, Map, Animal等）通过 ObjectPtr<T> 使用" << std::endl;
        std::cout << "• ObjectPtr 统一管理对象生命周期" << std::endl;
        std::cout << "• 只有这几种基础类型直接表达逻辑" << std::endl;
        
        return 0;
        
    } catch (const std::exception& e) {
        std::cerr << "\n❌ 测试失败: " << e.what() << std::endl;
        return 1;
    }
}
