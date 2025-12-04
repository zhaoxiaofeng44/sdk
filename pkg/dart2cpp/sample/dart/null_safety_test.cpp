#include "dart2cpp.h"

// 工具宏定义

// ============================================================================
// 类: Person
// ============================================================================

class Person {
public:
  Address address = Null;
  Person() {
    return Void;
  }
  
};

// ============================================================================
// 类: Address
// ============================================================================

class Address {
public:
  String city = Null;
  Address() {
    return Void;
  }
  
};

// ============================================================================
// 主函数
// ============================================================================

int main() {
  try {
    Int nullableInt;
if (dart_is_null(nullableInt)) dart_print(dart_string("nullableInt is null"));
String nullableString;
auto result = ([&]() { String let_var = nullableString; return dart_is_null(let_var) ? dart_string("default value") : let_var; })();
dart_print(result);
auto maybeString = dart_string("hello");
auto length = ([&]() { String let_var = maybeString; return dart_is_null(let_var) ? Null : let_var.length(); })();
dart_print(length);
Person person;
auto cityName = ([&]() { Person let_var = person; return dart_is_null(let_var) ? Null : ([&]() { Address let_var = let_var->address; return dart_is_null(let_var) ? Null : let_var->city; })(); })();
dart_print(([&]() { String let_var = cityName; return dart_is_null(let_var) ? dart_string("unknown city") : let_var; })());
    return 0;
  } catch (const std::exception& e) {
    std::cerr << "Error: " << e.what() << std::endl;
    return 1;
  }
}
