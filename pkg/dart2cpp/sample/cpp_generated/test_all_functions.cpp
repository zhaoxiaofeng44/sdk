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
  return a->operator_add(b);
}

Int subtract(Int a, Int b) {
  return a->operator_sub(b);
}

Int calculate(Int a, Int b, ObjectPtr<Function> operation) {
  return dart_cast<Int>(operation->call(a, b));
}

ObjectPtr<Function> getAddFunction() {
  return makeFunction(&add);
}

ObjectPtr<Function> createMultiplier(Int _factor) {
  ObjectPtr<_ValueBox<Int>> factor(new _ValueBox<Int>(_factor));
  return makeFunction([&, factor](Int value) mutable { return value->operator_mul((*factor)); });
}

Nullable testAnonymousFunction() {
  auto result = calculate(dart_int(10), dart_int(5), makeFunction([&](Int a, Int b) { return a->operator_add(b); }));
dart_print(dart_string("匿名函数结果: ") + (result).toString());
return Void;
}

Nullable testFunctionAssignment() {
  operation = makeFunction(&add);
Any result = operation->call(dart_int(10), dart_int(5));
dart_print(dart_string("函数变量赋值结果: ") + (result).toString());
return Void;
}

Nullable testFunctionList() {
  Any result = operations->operator_index(dart_int(0))->call(dart_int(10), dart_int(5));
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
Any result3 = addFunc->call(dart_int(10), dart_int(5));
dart_print(dart_string("函数引用结果: ") + (result3).toString());
auto multiplier = createMultiplier(dart_int(3));
Any result4 = multiplier->call(dart_int(5));
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
