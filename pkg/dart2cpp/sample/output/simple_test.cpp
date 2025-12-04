#include <iostream>
#include "../../cpp/core/dart_object.h"
#include "../../cpp/core/dart_string.h"

int main() {
  std::cout << "Test 1: Basic types" << std::endl;
  
  Int i(42);
  std::cout << "Int created: " << i.getValue() << std::endl;
  
  std::cout << "Test 2: String creation" << std::endl;
  String s("Hello");
  std::cout << "String created" << std::endl;
  
  std::cout << "Test 3: getValue" << std::endl;
  std::cout << "String value: " << s.getValue() << std::endl;
  
  std::cout << "All tests passed!" << std::endl;
  return 0;
}
