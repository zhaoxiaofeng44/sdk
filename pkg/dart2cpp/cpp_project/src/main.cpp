// Dart2Cpp Sample Main Program
// This file demonstrates the C++ runtime and can be used for testing

#include "../include/dart2cpp_runtime.h"
#include <iostream>

int main() {
    std::cout << "========================================" << std::endl;
    std::cout << "🚀 Dart2Cpp C++ Project" << std::endl;
    std::cout << "========================================" << std::endl;
    std::cout << std::endl;

    // Test String class
    std::cout << "📝 Testing String class:" << std::endl;
    dart2cpp::String hello("Hello");
    dart2cpp::String world("World");
    dart2cpp::String message = hello + dart2cpp::String(" ") + world;
    std::cout << "  " << message.toString() << std::endl;
    std::cout << "  Length: " << hello.length() << std::endl;
    std::cout << std::endl;

    // Test int class
    std::cout << "🔢 Testing int class:" << std::endl;
    dart2cpp::Int num1(42);
    dart2cpp::Int num2(8);
    std::cout << "  " << num1.toString() << " + " << num2.toString() << " = "
              << (num1 + num2).toString() << std::endl;
    std::cout << "  " << num1.toString() << " * " << num2.toString() << " = "
              << (num1 * num2).toString() << std::endl;
    std::cout << "  " << num1.toString() << " > " << num2.toString() << " = "
              << (num1 > num2 ? "true" : "false") << std::endl;
    std::cout << std::endl;

    // Test double class
    std::cout << "🎯 Testing double class:" << std::endl;
    dart2cpp::Double pi(3.14159);
    dart2cpp::Double e(2.71828);
    std::cout << "  PI: " << pi.toString() << std::endl;
    std::cout << "  E: " << e.toString() << std::endl;
    std::cout << "  PI + E = " << (pi + e).toString() << std::endl;
    std::cout << std::endl;

    // Test bool class
    std::cout << "✅ Testing bool class:" << std::endl;
    dart2cpp::Bool true_val(true);
    dart2cpp::Bool false_val(false);
    std::cout << "  true && false = " << (true_val && false_val).toString() << std::endl;
    std::cout << "  true || false = " << (true_val || false_val).toString() << std::endl;
    std::cout << "  !true = " << (!true_val).toString() << std::endl;
    std::cout << std::endl;

    // Test List class
    std::cout << "📋 Testing List<int> class:" << std::endl;
    dart2cpp::List<dart2cpp::Int> numbers;
    numbers.add(dart2cpp::Int(1));
    numbers.add(dart2cpp::Int(2));
    numbers.add(dart2cpp::Int(3));
    numbers.add(dart2cpp::Int(4));
    numbers.add(dart2cpp::Int(5));
    std::cout << "  List: " << numbers.toString() << std::endl;
    std::cout << "  Length: " << numbers.length() << std::endl;
    std::cout << "  First element: " << numbers[0].toString() << std::endl;
    std::cout << "  Last element: " << numbers[numbers.length() - 1].toString() << std::endl;
    std::cout << std::endl;

    // Note: Map and complex types require additional implementation
    std::cout << "📋 Map and complex types:" << std::endl;
    std::cout << "  (See runtime library for Map implementation)" << std::endl;
    std::cout << std::endl;

    // Test print function
    std::cout << "🖨️  Testing print functions:" << std::endl;
    dart2cpp::print(dart2cpp::String("This is a string"));
    dart2cpp::print(dart2cpp::Int(12345));
    dart2cpp::print(dart2cpp::Double(99.99));
    dart2cpp::print(dart2cpp::Bool(true));
    std::cout << std::endl;

    std::cout << "========================================" << std::endl;
    std::cout << "✅ All tests completed successfully!" << std::endl;
    std::cout << "========================================" << std::endl;

    return 0;
}