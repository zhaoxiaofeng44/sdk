#include "dart2cpp.h"

// 工具宏定义

Int add(Int a, Int b);
Int subtract(Int a, Int b);
Int calculate(Int a, Int b, Function operation);
Function getAddFunction();
Function createMultiplier(Int factor);
Nullable testAnonymousFunction();
Nullable testFunctionAssignment();
Nullable testFunctionList();
Int add(Int a, Int b) {
  return (a + b);
}

Int subtract(Int a, Int b) {
  return (a - b);
}

Int calculate(Int a, Int b, Function operation) {
  return dart_cast<Int>(operation->apply({a, b}));
}

Function getAddFunction() {
  return makeFunction(&add);
}

Function createMultiplier(Int factor) {
  return makeFunction([&](Int value) { return (value * factor); });
}

Nullable testAnonymousFunction() {
  auto result = calculate(dart_int(10), dart_int(5), makeFunction([&](Int a, Int b) { return (a + b); }));
dart_print(dart_concat(dart_string("匿名函数结果: "), result));
}

Nullable testFunctionAssignment() {
  operation = makeFunction(&add);
auto result = operation->apply({dart_int(10), dart_int(5)});
dart_print(dart_concat(dart_string("函数变量赋值结果: "), result));
return Void;
}

Nullable testFunctionList() {
  auto result = operations->[](dart_int(0))->apply({dart_int(10), dart_int(5)});
dart_print(dart_concat(dart_string("函数数组结果: "), result));
return Void;
}

// ============================================================================
// 主函数
// ============================================================================

int main() {
  try {
    auto result1 = calculate(dart_int(10), dart_int(5), makeFunction(&add));
dart_print(dart_concat(dart_string("10 + 5 = "), result1));
auto result2 = calculate(dart_int(10), dart_int(5), multiply);
dart_print(dart_concat(dart_string("10 * 5 = "), result2));
auto addFunc = getAddFunction();
auto result3 = addFunc->apply({dart_int(10), dart_int(5)});
dart_print(dart_concat(dart_string("函数引用结果: "), result3));
auto multiplier = createMultiplier(dart_int(3));
auto result4 = multiplier->apply({dart_int(5)});
dart_print(dart_concat(dart_string("高阶函数结果: "), result4));
testAnonymousFunction();
testFunctionAssignment();
testFunctionList();
    return 0;
  } catch (const std::exception& e) {
    std::cerr << "Error: " << e.what() << std::endl;
    return 1;
  }
}
