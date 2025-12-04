#include "dart2cpp.h"

// 工具宏定义

// ============================================================================
// 类: Person
// ============================================================================

class Person {
public:
  Address address = Null;
  Person() {
  }
  
};

// ============================================================================
// 类: Address
// ============================================================================

class Address {
public:
  String city = Null;
  Address() {
  }
  
};

// ============================================================================
// 主函数
// ============================================================================

int main() {
  try {
    Int nullableInt;
if (dart_is_null(nullableInt)) {
dart_print(dart_string("nullableInt is null"));
}
String nullableString;
auto result = dart_is_null(nullableString) ? dart_string("default value") : nullableString;
dart_print(result);
auto maybeString = dart_string("hello");
auto length = dart_is_null(maybeString) ? Null : maybeString;
dart_print(length);
Person person;
auto cityName = dart_is_null(person) ? Null : dart_is_null(let_var->address) ? Null : person;
dart_print(dart_is_null(cityName) ? dart_string("unknown city") : cityName);
    return 0;
  } catch (const std::exception& e) {
    std::cerr << "Error: " << e.what() << std::endl;
    return 1;
  }
}
