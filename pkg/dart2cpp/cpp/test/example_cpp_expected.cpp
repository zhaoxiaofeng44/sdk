// Expected C++ output from Dart conversion

#include "pkg/dart2bytecode/base/object.h"
#include "pkg/dart2bytecode/base/object_extensions_simple.h"
#include "pkg/dart2bytecode/base/dart_async_simple.h"
#include "pkg/dart2bytecode/base/dart_syntax_simple.h"
#include <iostream>

void main() {
  // 1. 基本类型
  auto x = Int(5);
  Int y = Int(10);
  Double pi = Double(3.14);
  Bool flag = Bool(true);
  String name = String("Dart");
  
  // 2. 运算符
  auto sum = x + y;
  auto product = x * Int(2);
  auto isPositive = x > Int(0);
  
  // 3. 字符串操作
  String greeting = String("Hello, ") + name;
  auto length = greeting.get_length();
  auto upper = greeting.toUpperCase();
  
  // 4. 集合
  ObjectPtr<List<Int>> numbers = List<Int>::create();
  numbers->add(Int(1));
  numbers->add(Int(2));
  numbers->add(Int(3));
  
  ObjectPtr<Set<String>> names = Set<String>::create();
  names->add(String("Alice"));
  names->add(String("Bob"));
  
  ObjectPtr<Map<String, Int>> ages = Map<String, Int>::create();
  (*ages)[String("Alice")] = Int(25);
  (*ages)[String("Bob")] = Int(30);
  
  // 5. 控制流
  if (flag) {
    dart_print(String("Flag is true"));
  }
  
  for (Int i(0); i < Int(5); ++i) {
    dart_print(i);
  }
  
  dart_for_each(Int, num, numbers)
    dart_print(num);
  dart_end_for
  
  // 6. 类型转换
  String numStr = x.toString();
  auto parsed = dart_parse_int(String("42"));
  
  // 7. 数学运算
  auto division = y.integerDivision(Int(3));
  auto modulo = y % Int(3);
}

