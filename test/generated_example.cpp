#include "./core/object.h"
#include <iostream>

// 工具宏定义
#define dart_print(value) \
    do { \
        std::cout << (value).toString().getValue() << std::endl; \
    } while(0)

#define dart_int(value) Int(value)
#define dart_double(value) Double(value)
#define dart_bool(value) Bool(value)
#define dart_string(value) String(value)

// ============================================================================
// 转换后的类定义 (简化版)
// ============================================================================

/// Person 类
class Person : public Object {
public:
    String name;
    Int age;
    Bool isStudent;

    Person(String n, Int a, Bool student) : name(n), age(a), isStudent(student) {}

    String getInfo() {
        return dart_string("Name: ") + name + dart_string(", Age: ") + age.toString() + 
               dart_string(", Student: ") + isStudent.toString();
    }

    Bool isAdult() {
        return age >= dart_int(18);
    }

    static Person createStudent(String name, Int age) {
        return Person(name, age, dart_bool(true));
    }
};

/// 工具函数
Int fibonacci(Int n) {
    if (n <= dart_int(1)) return n;
    return fibonacci(n - dart_int(1)) + fibonacci(n - dart_int(2));
}

String formatMessage(String name, Int count) {
    String message = dart_string("Hello, ") + name + dart_string("!");
    if (count > dart_int(1)) {
        message = message + dart_string(" You have ") + count.toString() + dart_string(" messages.");
    } else if (count == dart_int(1)) {
        message = message + dart_string(" You have 1 message.");
    } else {
        message = message + dart_string(" No messages.");
    }
    return message;
}

// ============================================================================
// 主函数
// ============================================================================

int main() {
    try {
        dart_print(dart_string("=== Dart 到 C++ 转换示例 ==="));
        
        // 1. 基本类使用
        dart_print(dart_string(""));
        dart_print(dart_string("1. 基本类使用:"));
        Person person1(dart_string("Alice"), dart_int(25), dart_bool(false));
        Person person2 = Person::createStudent(dart_string("Bob"), dart_int(20));
        
        dart_print(person1.getInfo());
        dart_print(person2.getInfo());
        dart_print(dart_string("Alice is adult: ") + person1.isAdult().toString());
        dart_print(dart_string("Bob is adult: ") + person2.isAdult().toString());
        
        // 2. 数学计算
        dart_print(dart_string(""));
        dart_print(dart_string("2. 数学计算:"));
        dart_print(dart_string("Fibonacci(8) = ") + fibonacci(dart_int(8)).toString());
        
        // 3. 字符串操作
        dart_print(dart_string(""));
        dart_print(dart_string("3. 字符串操作:"));
        dart_print(formatMessage(dart_string("Charlie"), dart_int(0)));
        dart_print(formatMessage(dart_string("David"), dart_int(1)));
        dart_print(formatMessage(dart_string("Eve"), dart_int(5)));
        
        // 4. 基本数据类型操作
        dart_print(dart_string(""));
        dart_print(dart_string("4. 基本数据类型操作:"));
        Int num1 = dart_int(42);
        Double num2 = dart_double(3.14);
        Bool flag = dart_bool(true);
        
        dart_print(dart_string("Integer: ") + num1.toString());
        dart_print(dart_string("Double: ") + num2.toString());
        dart_print(dart_string("Boolean: ") + flag.toString());
        
        // 5. 运算符测试
        dart_print(dart_string(""));
        dart_print(dart_string("5. 运算符测试:"));
        Int sum = num1 + dart_int(8);
        Bool comparison = num1 > dart_int(30);
        dart_print(dart_string("42 + 8 = ") + sum.toString());
        dart_print(dart_string("42 > 30: ") + comparison.toString());
        
        dart_print(dart_string(""));
        dart_print(dart_string("=== 示例完成 ==="));
        
        return 0;
    } catch (const std::exception& e) {
        std::cerr << "Error: " << e.what() << std::endl;
        return 1;
    }
}
