#include "dart2cpp.h"

// 工具宏定义

// ============================================================================
// 主函数
// ============================================================================

int main() {
  try {
    auto x = dart_int(10);
auto y = dart_int(20);
dart_print(dart_string("x + y = ") + (x->operator_add(y)).toString());
dart_print(dart_string("x.abs() = ") + (x->abs()).toString());
auto d1 = dart_double(3.14);
auto d2 = dart_double(2.71);
dart_print(dart_string("d1 + d2 = ") + (d1->operator_add(d2)).toString());
dart_print(dart_string("d1.abs() = ") + (d1->abs()).toString());
auto b1 = dart_bool(true);
auto b2 = dart_bool(false);
dart_print(dart_string("b1 && b2 = ") + (b1 && b2).toString());
dart_print(dart_string("b1.toString() = ") + (b1->toString()).toString());
    return 0;
  } catch (const std::exception& e) {
    std::cerr << "Error: " << e.what() << std::endl;
    return 1;
  }
}
