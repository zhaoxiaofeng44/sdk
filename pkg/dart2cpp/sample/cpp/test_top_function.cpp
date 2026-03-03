#include "dart2cpp.h"

// 工具宏定义

Int add(Int a, Int b);
Int add(Int a, Int b) {
  return a->operator_add(b);
}

// ============================================================================
// 主函数
// ============================================================================

int main() {
  try {
    auto result = add(dart_int(5), dart_int(3));
dart_print(dart_string("Result: ") + (result).toString());
    return 0;
  } catch (const std::exception& e) {
    std::cerr << "Error: " << e.what() << std::endl;
    return 1;
  }
}
