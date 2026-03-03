#include "dart2cpp.h"

// 工具宏定义

// ============================================================================
// 主函数
// ============================================================================

int main() {
  try {
    auto multiply = makeFunction<Int, Int, Int>(std::function<Int(Int, Int)>([=](Int a, Int b) -> Int { return a->operator_mul(b); }));
auto result = multiply->call(dart_int(4), dart_int(5));
dart_print(dart_string("Result: ") + (result).toString());
    return 0;
  } catch (const std::exception& e) {
    std::cerr << "Error: " << e.what() << std::endl;
    return 1;
  }
}
