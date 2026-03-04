#include "dart2cpp.h"

// 工具宏定义

// ============================================================================
// 类: Person
// ============================================================================

class Person {
public:
  ObjectPtr<Address> address = Null;
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
    Int nullableInt(Null);
if (dart_is_null(nullableInt)) {
dart_print(dart_string("nullableInt is null"));
}
String nullableString(Null);
auto result = dart_null_coalesce(nullableString, dart_string("default value"));
dart_print(result);
auto maybeString = dart_string("hello");
auto length = dart_null_coalesce(maybeString, Null);
dart_print(length);
ObjectPtr<ObjectPtr<Person>> person(Null);
auto cityName = ([&]() { auto let_var = person; return dart_is_null(let_var) ? Null : dart_null_coalesce(let_var->address, Null); })();
dart_print(dart_null_coalesce(cityName, dart_string("unknown city")));
    return 0;
  } catch (const std::exception& e) {
    std::cerr << "Error: " << e.what() << std::endl;
    return 1;
  }
}
