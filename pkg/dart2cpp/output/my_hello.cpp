#include "dart2cpp.h"

// 工具宏定义

// ============================================================================
// 主函数
// ============================================================================

int main() {
  try {
    dart_print(dart_string("Hello, Dart to C++ World!"));
auto number = dart_int(42);
auto pi = dart_double(3.14159);
auto message = dart_string("Hello from Dart");
auto isWorking = dart_bool(true);
dart_print(dart_string("Number: ") + (number).toString());
dart_print(dart_string("Pi: ") + (pi).toString());
dart_print(dart_string("Message: ") + (message).toString());
dart_print(dart_string("Is working: ") + (isWorking).toString());
auto numbers = dart_literal(dart_int(1), dart_int(2), dart_int(3), dart_int(4), dart_int(5));
dart_print(dart_string("Numbers: ") + (numbers).toString());
for (auto i = dart_int(0); i->operator_less(dart_int(3)); i = i->operator_add(dart_int(1))) {
dart_print(dart_string("Loop iteration: ") + (i).toString());
}
if (isWorking) {
dart_print(dart_string("✅ Script is working correctly!"));
} else {
dart_print(dart_string("❌ Something went wrong"));
}
dart_print(dart_string("Program completed successfully!"));
    return 0;
  } catch (const std::exception& e) {
    std::cerr << "Error: " << e.what() << std::endl;
    return 1;
  }
}
