#include "dart2cpp.h"

// 工具宏定义

// ============================================================================
// 主函数
// ============================================================================

int main() {
  try {
    dart_print(dart_string("Testing dynamic variable assignment"));
Any testVar = dart_string("Hello");
dart_print(dart_string("String value: ") + (testVar).toString());
testVar = dart_int(42);
dart_print(dart_string("Int value: ") + (testVar).toString());
dart_print(dart_string("Test completed successfully"));
    return 0;
  } catch (const std::exception& e) {
    std::cerr << "Error: " << e.what() << std::endl;
    return 1;
  }
}
