#include "pkg/dart2bytecode/base/object.h"
#include "pkg/dart2bytecode/base/object_extended.h"
#include <iostream>

int main() {
    std::cout << "===========================================" << std::endl;
    std::cout << "    toString() 返回 String 类型测试" << std::endl;
    std::cout << "===========================================" << std::endl;
    
    try {
        // 1. 基础类型 toString() 测试
        std::cout << "\n1. 基础类型 toString() 测试" << std::endl;
        
        Int a(42);
        String intStr = a.toString();
        std::cout << "  Int(42).toString() 类型: " << typeid(intStr).name() << std::endl;
        std::cout << "  Int(42).toString() 值: " << intStr.toString() << std::endl;
        
        Double pi(3.14159);
        String doubleStr = pi.toString();
        std::cout << "  Double(3.14159).toString() 值: " << doubleStr.toString() << std::endl;
        
        Bool flag(true);
        String boolStr = flag.toString();
        std::cout << "  Bool(true).toString() 值: " << boolStr.toString() << std::endl;
        
        String hello("Hello World");
        String stringStr = hello.toString();
        std::cout << "  String(\"Hello World\").toString() 值: " << stringStr.toString() << std::endl;
        
        // 2. 容器 toString() 测试
        std::cout << "\n2. 容器 toString() 测试" << std::endl;
        
        List list;
        list.add(ObjectPtr<Any>(new Int(42)));
        list.add(ObjectPtr<Any>(new String("Hello")));
        
        String listStr = list.toString();
        std::cout << "  List.toString() 值: " << listStr.toString() << std::endl;
        
        // 3. 继承类 toString() 测试
        std::cout << "\n3. 继承类 toString() 测试" << std::endl;
        
        ObjectPtr<String> name(new String("Buddy"));
        ObjectPtr<Int> age(new Int(3));
        ObjectPtr<String> breed(new String("Golden Retriever"));
        ObjectPtr<Dog> dog(new Dog(name, age, breed));
        
        String dogStr = dog->toString();
        std::cout << "  Dog.toString() 值: " << dogStr.toString() << std::endl;
        
        // 4. String 运算测试
        std::cout << "\n4. String 运算测试" << std::endl;
        
        String s1("Hello");
        String s2("World");
        String s3 = s1 + String(" ") + s2;
        std::cout << "  String 连接: " << s3.toString() << std::endl;
        
        // 5. 类型一致性验证
        std::cout << "\n5. 类型一致性验证" << std::endl;
        
        // 所有 toString() 都返回 String 类型
        String results[5];
        results[0] = a.toString();
        results[1] = pi.toString();
        results[2] = flag.toString();
        results[3] = hello.toString();
        results[4] = list.toString();
        
        std::cout << "  所有 toString() 结果都是 String 类型" << std::endl;
        for (int i = 0; i < 5; i++) {
            std::cout << "    结果 " << i << ": " << results[i].toString() << std::endl;
        }
        
        std::cout << "\n✅ 所有测试完成！" << std::endl;
        std::cout << "toString() 方法现在返回 String 类型，确保类型一致性" << std::endl;
        
        return 0;
        
    } catch (const std::exception& e) {
        std::cerr << "\n❌ 测试失败: " << e.what() << std::endl;
        return 1;
    }
}
