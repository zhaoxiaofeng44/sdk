#include "dart2cpp.h"

// 工具宏定义

Int add(Int a, Int b);
Int subtract(Int a, Int b);
Int calculate(Int a, Int b, std::function<Int(Int, Int)> operation);
Int add(Int a, Int b) {
  return (a + b);
}

Int subtract(Int a, Int b) {
  return (a - b);
}

Int calculate(Int a, Int b, std::function<Int(Int, Int)> operation) {
  return operation->apply(std::vector<Any>{a, b});
}

// ============================================================================
// 主函数
// ============================================================================

int main() {
  try {
    auto result1 = calculate(dart_int(10), dart_int(5), makeFunction(&add));
dart_print(dart_string("10 + 5 = ") + (result1).toString());
auto result2 = calculate(dart_int(10), dart_int(5), makeFunction(&subtract));
dart_print(dart_string("10 - 5 = ") + (result2).toString());
    return 0;
  } catch (const std::exception& e) {
    std::cerr << "Error: " << e.what() << std::endl;
    return 1;
  }
}
