// Auto-generated C++ code from Dart - FIXED VERSION
// Generated: 2025-10-28
// 展示正确的Dart到C++转换，使用ObjectPtr包装自定义类

#include "pkg/dart2bytecode/base/object.h"
#include "pkg/dart2bytecode/base/object.cpp"
#include "pkg/dart2bytecode/base/object_extensions_simple.h"
#include "pkg/dart2bytecode/base/dart_async_simple.h"
#include "pkg/dart2bytecode/base/dart_oop_extensions.h"
#include "pkg/dart2bytecode/base/dart_syntax_simple.h"
#include <iostream>
#include <memory>

// ============================================================================
// 1. 简单类定义
// ============================================================================

class Person : public Object {
public:
    String name;
    Int age;
    
    Person(const String& n, const Int& a) : name(n), age(a) {
        type_id = 100;
    }
    
    String introduce() {
        // Dart: "I'm ${name}, ${age} years old"
        // C++: 字符串插值转换为拼接
        return String("I'm ") + name + String(", ") + age.toString() + String(" years old");
    }
    
    String toString() const override {
        return String("Person(") + name + String(", ") + age.toString() + String(")");
    }
};

// ============================================================================
// 2. 继承
// ============================================================================

class Animal : public Object {
public:
    String name;
    
    Animal(const String& n) : name(n) {
        type_id = 101;
    }
    
    virtual String makeSound() {
        return String("Some sound");
    }
    
    String toString() const override {
        return String("Animal(") + name + String(")");
    }
};

class Dog : public Animal {
public:
    Dog(const String& n) : Animal(n) {
        type_id = 102;
    }
    
    String makeSound() override {
        return String("Woof!");
    }
    
    String toString() const override {
        return String("Dog(") + name + String(")");
    }
};

// ============================================================================
// 3. 基本类型和变量
// ============================================================================

void testBasicTypes() {
    // Dart: var x = 5;
    auto x = Int(5);
    
    // Dart: int y = 10;
    Int y = Int(10);
    
    // Dart: double pi = 3.14;
    Double pi = Double(3.14);
    
    // Dart: bool flag = true;
    Bool flag = Bool(true);
    
    // Dart: String name = "Dart";
    String name = String("Dart");
    
    // Dart: var sum = x + y;
    auto sum = x + y;
    
    // Dart: var product = x * 2;
    auto product = x * Int(2);
    
    // Dart: var isPositive = x > 0;
    auto isPositive = x > Int(0);
}

// ============================================================================
// 4. 集合操作
// ============================================================================

void testCollections() {
    // Dart: List<int> numbers = [1, 2, 3];
    ObjectPtr<List<Int>> numbers = List<Int>::create();
    numbers->add(Int(1));
    numbers->add(Int(2));
    numbers->add(Int(3));
    
    // Dart: numbers.add(4);
    numbers->add(Int(4));
    
    // Dart: Set<String> names = {};
    ObjectPtr<Set<String>> names = Set<String>::create();
    
    // Dart: names.add("Alice");
    names->add(String("Alice"));
    names->add(String("Bob"));
    
    // Dart: Map<String, int> ages = {};
    ObjectPtr<Map<String, Int>> ages = Map<String, Int>::create();
    
    // Dart: ages["Alice"] = 25;
    (*ages)[String("Alice")] = Int(25);
    
    // Dart: for (var num in numbers)
    dart_for_each(Int, num, numbers)
        dart_print(num);
    dart_end_for
}

// ============================================================================
// 5. 控制流
// ============================================================================

void testControlFlow() {
    auto x = Int(5);
    
    // Dart: if (x > 0) { print("Positive"); } else { print("Non-positive"); }
    if (x > Int(0)) {
        dart_print(String("Positive"));
    } else {
        dart_print(String("Non-positive"));
    }
    
    // Dart: for (int i = 0; i < 10; i++)
    for (Int i(0); i < Int(10); ++i) {
        dart_print(i);
    }
    
    // Dart: while (x > 0)
    while (x > Int(0)) {
        x = x - Int(1);
    }
}

// ============================================================================
// 6. 字符串插值
// ============================================================================

void testStringInterpolation() {
    auto name = String("Alice");
    auto age = Int(25);
    
    // Dart: var message = "Hello, ${name}!";
    // C++: 字符串插值 => 字符串拼接
    auto message = String("Hello, ") + name + String("!");
    
    // Dart: var info = "Name: ${name}, Age: ${age}";
    auto info = String("Name: ") + name + String(", Age: ") + age.toString();
    
    // Dart: var calculation = "Sum: ${5 + 3}";
    auto calculation = String("Sum: ") + (Int(5) + Int(3)).toString();
}

// ============================================================================
// 7. 类型转换
// ============================================================================

void testTypeConversions() {
    // Dart: int x = 42;
    Int x = Int(42);
    
    // Dart: String s = x.toString();
    String s = x.toString();
    
    // Dart: String numStr = "123";
    String numStr = String("123");
    
    // Dart: int parsed = int.parse(numStr);
    Int parsed = dart_parse_int(numStr);
    
    // Dart: double d = x.toDouble();
    Double d = x.toDouble();
}

// ============================================================================
// 8. 对象创建（自定义类 - 关键：使用ObjectPtr包装）
// ============================================================================

void testObjectCreation() {
    // Dart: var person = Person("Alice", 25);
    // C++: 自定义类必须使用 ObjectPtr 包装
    ObjectPtr<Person> person(new Person(String("Alice"), Int(25)));
    dart_print(person->introduce());
    
    // Dart: var dog = Dog("Buddy");
    // C++: 同样使用 ObjectPtr
    ObjectPtr<Dog> dog(new Dog(String("Buddy")));
    dart_print(dog->makeSound());
    
    // 多态示例
    // Dart: Animal animal = Dog("Rex");
    ObjectPtr<Animal> animal(new Dog(String("Rex")));
    dart_print(animal->makeSound());  // 输出: "Woof!"（多态调用）
}

// ============================================================================
// 9. 数学运算
// ============================================================================

void testMathOperations() {
    auto a = Int(10);
    auto b = Int(3);
    
    // Dart: var division = a ~/ b;  (整除)
    // C++: 转换为 integerDivision 方法
    auto division = a.integerDivision(b);
    
    // Dart: var modulo = a % b;
    auto modulo = a % b;
    
    // Dart: var sum = a + b;
    auto sum = a + b;
    
    // Dart: var product = a * b;
    auto product = a * b;
}

// ============================================================================
// 主函数
// ============================================================================

int main() {
    try {
        testBasicTypes();
        testCollections();
        testControlFlow();
        testStringInterpolation();
        testTypeConversions();
        testObjectCreation();
        testMathOperations();
        
        dart_print(String("All tests completed!"));
        
        return 0;
    } catch (const std::exception& e) {
        std::cerr << "Error: " << e.what() << std::endl;
        return 1;
    }
}

