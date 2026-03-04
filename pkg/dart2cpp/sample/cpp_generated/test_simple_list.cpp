#include "dart2cpp.h"

// 工具宏定义

// ============================================================================
// 主函数
// ============================================================================

int main() {
  try {
    auto list1 = dart_literal<Double>();
auto list2 = dart_literal<Double>(dart_double(1.0), dart_double(2.0));
dart_print(list1);
dart_print(list2);
    return 0;
  } catch (const std::exception& e) {
    std::cerr << "Error: " << e.what() << std::endl;
    return 1;
  }
}
