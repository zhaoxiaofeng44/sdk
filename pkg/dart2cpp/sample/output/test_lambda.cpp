#include "dart2cpp.h"

// 工具宏定义

// ============================================================================
// 主函数
// ============================================================================

int main() {
  try {
    auto multiply = [&](Int a, Int b) { return (a * b); };
auto result = multiply(dart_int(4), dart_int(5));
dart_print(dart_concat(dart_string("Result: "), result));
    return 0;
  } catch (const std::exception& e) {
    std::cerr << "Error: " << e.what() << std::endl;
    return 1;
  }
}
