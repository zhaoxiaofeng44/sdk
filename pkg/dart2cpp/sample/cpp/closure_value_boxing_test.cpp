#include "dart2cpp.h"

// 工具宏定义

Nullable testBasicValueBoxing();
Nullable testParameterBoxing();
Nullable testLocalVarBoxing();
Nullable testMixedBoxing();
Nullable testBasicValueBoxing() {
  dart_print(dart_string("Test 1: Basic Value Type Boxing"));
ObjectPtr<_ValueBox<Int>> x(new _ValueBox<Int>(dart_int(10)));
auto increment = makeFunction([&]() { (*x) = (*x)->operator_add(dart_int(1)); });
dart_print(dart_string("Before: ") + (x).toString());
increment->call();
dart_print(dart_string("After: ") + (x).toString());
return Void;
}

Nullable testParameterBoxing() {
  dart_print(dart_string("Test 2: Parameter Boxing"));
auto makeCounter = [&](Int _start) { ObjectPtr<_ValueBox<Int>> start(new _ValueBox<Int>(_start));
return makeFunction([&, start]() mutable { (*start) = (*start)->operator_add(dart_int(1));
return (*start); }); };
auto counter = makeCounter(dart_int(0));
dart_print(counter->call());
dart_print(counter->call());
dart_print(counter->call());
return Void;
}

Nullable testLocalVarBoxing() {
  dart_print(dart_string("Test 3: Local Variable Boxing"));
ObjectPtr<_ValueBox<Int>> count(new _ValueBox<Int>(dart_int(0)));
ObjectPtr<_ValueBox<String>> prefix(new _ValueBox<String>(dart_string("Count: ")));
auto incrementAndPrint = makeFunction([&]() { (*count) = (*count)->operator_add(dart_int(1));
dart_print((*prefix)->operator_add((*count)->toString())); }, std::vector<Any>{Any(prefix), Any(count)});
incrementAndPrint->call();
incrementAndPrint->call();
incrementAndPrint->call();
return Void;
}

Nullable testMixedBoxing() {
  dart_print(dart_string("Test 4: Mixed Boxing"));
auto makeAccumulator = [&](Int _initial) { ObjectPtr<_ValueBox<Int>> initial(new _ValueBox<Int>(_initial));
ObjectPtr<_ValueBox<Double>> multiplier(new _ValueBox<Double>(dart_double(2.0)));
return makeFunction([&, initial, multiplier](Int value) mutable { (*initial) = (*initial)->operator_add(value);
return (*initial)->operator_mul((*multiplier)); }); };
auto acc = makeAccumulator(dart_int(10));
dart_print(acc->call(dart_int(5)));
dart_print(acc->call(dart_int(3)));
return Void;
}

// ============================================================================
// 主函数
// ============================================================================

int main() {
  try {
    testBasicValueBoxing();
testParameterBoxing();
testLocalVarBoxing();
testMixedBoxing();
    return 0;
  } catch (const std::exception& e) {
    std::cerr << "Error: " << e.what() << std::endl;
    return 1;
  }
}
