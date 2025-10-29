// Auto-generated C++ code from Dart
// Generated: 2025-10-28 11:43:42.557422

#include "pkg/dart2bytecode/base/object.h"
#include "pkg/dart2bytecode/base/object.cpp"
#include "pkg/dart2bytecode/base/object_extensions_simple.h"
#include "pkg/dart2bytecode/base/dart_async_simple.h"
#include "pkg/dart2bytecode/base/dart_oop_extensions.h"
#include "pkg/dart2bytecode/base/dart_syntax_simple.h"
#include <iostream>
#include <memory>

// Enhanced Conversion Test Input
// 测试所有支持的特性
// ============================================================================
// 1. 简单类定义
// ============================================================================
class Person : public Object {
  String name;
  int age;
  Person(this.name, this.age);
  String introduce() {
    return String("I'm ${name}, ${age} years old");
  }
}
// ============================================================================
// 2. 继承
// ============================================================================
class Animal : public Object {
  String name;
  Animal(this.name);
  String makeSound() => "Some sound";
}
class Dog : public Animal {
  Dog(String name) : super(name);
  String makeSound() => "Woof!";
}
// ============================================================================
// 3. 基本类型和变量
// ============================================================================
void testBasicTypes() {
  auto x = Int(5);
  Int y = Int(10);
  Double pi = Double(3.14);
  Bool flag = Bool(true);
  String name = String("Dart");
  auto sum = x + y;
  auto product = x * 2;
  auto isPositive = x > 0;
}
// ============================================================================
// 4. 集合操作
// ============================================================================
void testCollections() {
  ObjectPtr<List<Int>> numbers = List<Int>::create();
  numbers->add(Int(1));
  numbers->add(Int(2));
  numbers->add(Int(3));
  numbers->add(4);
  ObjectPtr<Set<String>> names = Set<String>::create();
  names->add("Alice");
  names->add("Bob");
  ObjectPtr<Map<String, Int>> ages = Map<String, Int>::create();
  ages["Alice"] = 25;
  dart_for_each(auto, num, numbers)
    dart_print(num);
  }
}
// ============================================================================
// 5. 控制流
// ============================================================================
void testControlFlow() {
  auto x = Int(5);
  if (x > 0) {
    dart_print("Positive");
  } else {
    dart_print("Non-positive");
  }
  for (Int i(0); i < Int(10); ++i)
    dart_print(i);
  }
  while (x > 0) {
    x = x - 1;
  }
}
// ============================================================================
// 6. 字符串插值
// ============================================================================
void testStringInterpolation() {
  auto name = String("Alice");
  auto age = Int(25);
  auto message = String("Hello, ${name}!");
  auto info = String("Name: ${name}, Age: ${age}");
  auto calculation = String("Sum: ${5 + 3}");
}
// ============================================================================
// 7. 类型转换
// ============================================================================
void testTypeConversions() {
  Int x = Int(42);
  String s = x.toString();
  String numStr = String("123");
  Int parsed = int.parse(numStr);
  Double d = x.toDouble();
}
// ============================================================================
// 8. 对象创建（自定义类）
// ============================================================================
void testObjectCreation() {
  auto person = ObjectPtr<Person>(new Person(String("Alice"), Int(25)));
  dart_print(person.introduce());
  auto dog = ObjectPtr<Dog>(new Dog(String("Buddy")));
  dart_print(dog.makeSound());
}
// ============================================================================
// 9. 数学运算
// ============================================================================
void testMathOperations() {
  auto a = Int(10);
  auto b = Int(3);
  auto division = a ~/ b;
  auto modulo = a % b;
  auto sum = a + b;
  auto product = a * b;
}
// ============================================================================
// 主函数
// ============================================================================
void main() {
  testBasicTypes();
  testCollections();
  testControlFlow();
  testStringInterpolation();
  testTypeConversions();
  testObjectCreation();
  testMathOperations();
  dart_print("All tests completed!");
}
