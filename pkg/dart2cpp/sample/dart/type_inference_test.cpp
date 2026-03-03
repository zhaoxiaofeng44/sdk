#include "dart2cpp.h"

// 工具宏定义

// ============================================================================
// 主函数
// ============================================================================

int main() {
  try {
    dart_print(dart_string("=== 类型推断测试 ==="));
auto intVal = dart_int(10);
auto doubleVal = dart_double(3.14);
dart_print(dart_string("int variable + double variable: not supported"));
auto result2 = dart_double(5.0)->operator_add(doubleVal);
dart_print(dart_string("literal int + double variable = ") + (result2).toString());
auto result3 = doubleVal->operator_add(dart_double(10.0));
dart_print(dart_string("double variable + literal int = ") + (result3).toString());
auto result4 = intVal->operator_add(dart_int(20));
dart_print(dart_string("int variable + int literal = ") + (result4).toString());
auto result5 = dart_int(15)->operator_add(dart_int(25));
dart_print(dart_string("int literal + int literal = ") + (result5).toString());
auto name = dart_string("World");
auto greeting = dart_string("Hello ")->operator_add(name);
dart_print(dart_string("String concat: ") + (greeting).toString());
    return 0;
  } catch (const std::exception& e) {
    std::cerr << "Error: " << e.what() << std::endl;
    return 1;
  }
}
