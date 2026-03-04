#include "dart2cpp.h"

// 工具宏定义

// ============================================================================
// 主函数
// ============================================================================

int main() {
  try {
    dart_print(dart_string("Test nullable"));
String nullableString(Null);
auto result = dart_null_coalesce(nullableString, dart_string("default"));
dart_print(result);
    return 0;
  } catch (const std::exception& e) {
    std::cerr << "Error: " << e.what() << std::endl;
    return 1;
  }
}
