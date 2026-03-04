#include "dart2cpp.h"

// 工具宏定义

// ============================================================================
// 主函数
// ============================================================================

int main() {
  try {
    auto emptyDoubles = dart_literal<Double>();
dart_print(dart_string("空的 List<double> 列表: ") + (emptyDoubles).toString());
auto doubles = dart_literal<Double>(dart_double(1.1), dart_double(2.2), dart_double(3.3));
dart_print(dart_string("Double 列表: ") + (doubles).toString());
auto ints = dart_literal<Int>(dart_int(1), dart_int(2), dart_int(3));
dart_print(dart_string("Int 列表: ") + (ints).toString());
auto strings = dart_literal<String>(dart_string("hello"), dart_string("world"));
dart_print(dart_string("String 列表: ") + (strings).toString());
auto matrix = dart_literal<ObjectPtr<List<Double>>>();
matrix->add(dart_literal<Double>(dart_double(1.0), dart_double(2.0)));
matrix->add(dart_literal<Double>(dart_double(3.0), dart_double(4.0)));
dart_print(dart_string("矩阵: ") + (matrix).toString());
auto result = dart_literal<ObjectPtr<List<Double>>>();
for (auto i = dart_int(0); i->operator_less(dart_int(3)); i = i->operator_add(dart_int(1))) {
result->add(dart_literal<Double>(i->toDouble(), i->operator_add(dart_int(1))->toDouble()));
}
dart_print(dart_string("结果矩阵: ") + (result).toString());
    return 0;
  } catch (const std::exception& e) {
    std::cerr << "Error: " << e.what() << std::endl;
    return 1;
  }
}
