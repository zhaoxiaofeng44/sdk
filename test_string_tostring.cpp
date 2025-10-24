#include "pkg/dart2bytecode/base/object.h"
#include "pkg/dart2bytecode/base/object_extended.h"
#include <iostream>

int main() {
    std::cout << "===========================================" << std::endl;
    std::cout << "    String toString() 方法测试" << std::endl;
    std::cout << "===========================================" << std::endl;
    
    try {
        // 1. 基础类型 toString() 测试
        std::cout << "\n1. 基础类型 toString() 测试" << std::endl;
        
        Int a(42);
        String intStr = a.toString();
        std::cout << "  Int(42).toString() = " << intStr.toString() << std::endl;
        
        Double pi(3.14159);
        String doubleStr = pi.toString();
        std::cout << "  Double(3.14159).toString() = " << doubleStr.toString() << std::endl;
        
        Bool flag(true);
        String boolStr = flag.toString();
        std::cout << "  Bool(true).toString() = " << boolStr.toString() << std::endl;
        
        String hello("Hello World");
        String stringStr = hello.toString();
        std::cout << "  String(\"Hello World\").toString() = " << stringStr.toString() << std::endl;
        
        // 2. 容器 toString() 测试
        std::cout << "\n2. 容器 toString() 测试" << std::endl;
        
        List list;
        list.add(ObjectPtr<Any>(new Int(42)));
        list.add(ObjectPtr<Any>(new String("Hello")));
        
        String listStr = list.toString();
        std::cout << "  List.toString() = " << listStr.toString() << std::endl;
        
        // 3. 继承类 toString() 测试
        std::cout << "\n3. 继承类 toString() 测试" << std::endl;
        
        ObjectPtr<String> name(new String("Buddy"));
        ObjectPtr<Int> age(new Int(3));
        ObjectPtr<String> breed(new String("Golden Retriever"));
        ObjectPtr<Dog> dog(new Dog(name, age, breed));
        
        String dogStr = dog->toString();
        std::cout << "  Dog.toString() = " << dogStr.toString() << std::endl;
        
        // 4. 抽象类 toString() 测试
        std::cout << "\n4. 抽象类 toString() 测试" << std::endl;
        
        ObjectPtr<String> color(new String("red"));
        ObjectPtr<Double> radius(new Double(5.0));
        ObjectPtr<Circle> circle(new Circle(color, radius));
        
        String circleStr = circle->toString();
        std::cout << "  Circle.toString() = " << circleStr.toString() << std::endl;
        
        std::cout << "\n✅ 所有 toString() 方法测试完成！" << std::endl;
        std::cout << "现在所有 toString() 方法都返回 String 类型" << std::endl;
        
        return 0;
        
    } catch (const std::exception& e) {
        std::cerr << "\n❌ 测试失败: " << e.what() << std::endl;
        return 1;
    }
}
