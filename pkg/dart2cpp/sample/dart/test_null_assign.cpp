#include "dart2cpp.h"

// 工具宏定义

// ============================================================================
// 主函数
// ============================================================================

int main() {
  try {
    Int nullableInt(Null);
if (dart_is_null(nullableInt)) nullableInt = dart_int(42);
dart_print(nullableInt);
    return 0;
  } catch (const std::exception& e) {
    std::cerr << "Error: " << e.what() << std::endl;
    return 1;
  }
}
