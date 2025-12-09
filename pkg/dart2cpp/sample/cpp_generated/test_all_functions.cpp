#include "dart2cpp.h"

// 工具宏定义

Int add(Int a, Int b);
Int subtract(Int a, Int b);
Int calculate(Int a, Int b, ObjectPtr<Function> operation);
ObjectPtr<Function> getAddFunction();
ObjectPtr<Function> createMultiplier(Int factor);
Nullable testAnonymousFunction();
Nullable testFunctionAssignment();
Nullable testFunctionList();
Int add(Int a, Int b) {
  return (a + b);
}

Int subtract(Int a, Int b) {
  return (a - b);
}

Int calculate(Int a, Int b, ObjectPtr<Function> operation) {
  return dart_cast<Int>(operation->apply(std::vector<Any>{a, b}));
}

ObjectPtr<Function> getAddFunction() {
  return makeFunction(&add);
}

ObjectPtr<Function> createMultiplier(Int factor) {
  return makeFunction([&](Int value) { return (value * factor); });
}

Nullable testAnonymousFunction() {
  auto result = calculate(dart_int(10), dart_int(5), makeFunction([&](Int a, Int b) { return (a + b); }));
dart_print(dart_string("匿名函数结果: ") + (result).toString());
}

Nullable testFunctionAssignment() {
  operation = makeFunction(&add);
auto result = operation->apply(std::vector<Any>{dart_int(10), dart_int(5)});
dart_print(dart_string("函数变量赋值结果: ") + (result).toString());
return Void;
}

Nullable testFunctionList() {
  auto result = operations->get(dart_int(0))->apply(std::vector<Any>{dart_int(10), dart_int(5)});
dart_print(dart_string("函数数组结果: ") + (result).toString());
return Void;
}

// ============================================================================
// 主函数
// ============================================================================

int main() {
  try {
    auto result1 = calculate(dart_int(10), dart_int(5), makeFunction(&add));
dart_print(dart_string("10 + 5 = ") + (result1).toString());
auto result2 = calculate(dart_int(10), dart_int(5), multiply);
dart_print(dart_string("10 * 5 = ") + (result2).toString());
auto addFunc = getAddFunction();
auto result3 = addFunc->apply(std::vector<Any>{dart_int(10), dart_int(5)});
dart_print(dart_string("函数引用结果: ") + (result3).toString());
auto multiplier = createMultiplier(dart_int(3));
auto result4 = multiplier->apply(std::vector<Any>{dart_int(5)});
dart_print(dart_string("高阶函数结果: ") + (result4).toString());
testAnonymousFunction();
testFunctionAssignment();
testFunctionList();
    return 0;
  } catch (const std::exception& e) {
    std::cerr << "Error: " << e.what() << std::endl;
    return 1;
  }
}
