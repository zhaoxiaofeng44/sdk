#include "dart2cpp.h"

// 工具宏定义

// ============================================================================
// 类: Calculator
// ============================================================================

class Calculator {
public:
  Int base;
  Calculator(Int base) : base(base) {
  }
  
  ObjectPtr<Function> makeAdder() {
    return makeFunction([&](Int x) { return this->base->operator_add(x); });
  }
  
};

Nullable testBasicClosure();
Nullable testMultipleCapture();
Nullable testMemberFunctionCapture();
Nullable testClosureInLoop();
Nullable testNestedClosure();
Nullable testBasicClosure() {
  dart_print(dart_string("Test 1: Basic Closure"));
ObjectPtr<_ValueBox<Int>> x(new _ValueBox<Int>(dart_int(10)));
auto addX = makeFunction([&, x](Int y) mutable { return (*x)->operator_add(y); });
dart_print(addX->call(dart_int(5)));
return Void;
}

Nullable testMultipleCapture() {
  dart_print(dart_string("Test 2: Multiple Variable Capture"));
ObjectPtr<_ValueBox<Int>> a(new _ValueBox<Int>(dart_int(5)));
ObjectPtr<_ValueBox<Int>> b(new _ValueBox<Int>(dart_int(10)));
ObjectPtr<_ValueBox<String>> prefix(new _ValueBox<String>(dart_string("Result: ")));
auto compute = makeFunction([&, prefix]() mutable { auto sum = (*a)->operator_add((*b));
return (*prefix)->operator_add(sum->toString()); }, std::vector<Any>{Any(a), Any(b)});
dart_print(compute->call());
return Void;
}

Nullable testMemberFunctionCapture() {
  dart_print(dart_string("Test 3: Member Function Capture"));
auto calc = ObjectPtr<Calculator>(new Calculator(dart_int(100)));
auto adder = calc->makeAdder();
dart_print(adder->call(dart_int(23)));
return Void;
}

Nullable testClosureInLoop() {
  dart_print(dart_string("Test 4: Closure in Loop"));
auto functions = dart_literal<ObjectPtr<Function>>();
for (auto i = dart_int(0); (*i)->operator_less(dart_int(3)); (*i) = (*i)->operator_add(dart_int(1))) {
functions->add(makeFunction([&, i]() mutable { return (*i); }));
}
auto sync_for_iterator = functions->iterator();
for (; sync_for_iterator->hasNext(); ) {
auto f = sync_for_iterator->next();
dart_print(f->call());
};
return Void;
}

Nullable testNestedClosure() {
  dart_print(dart_string("Test 5: Nested Closure"));
ObjectPtr<_ValueBox<Int>> outer(new _ValueBox<Int>(dart_int(1)));
auto outerFunc = makeFunction([&]() { ObjectPtr<_ValueBox<Int>> middle(new _ValueBox<Int>(dart_int(10)));
auto innerFunc = makeFunction([&, outer, middle]() mutable { return (*outer)->operator_add((*middle)); });
return innerFunc->call(); });
dart_print(outerFunc->call());
return Void;
}

// ============================================================================
// 主函数
// ============================================================================

int main() {
  try {
    testBasicClosure();
testMultipleCapture();
testMemberFunctionCapture();
testClosureInLoop();
testNestedClosure();
    return 0;
  } catch (const std::exception& e) {
    std::cerr << "Error: " << e.what() << std::endl;
    return 1;
  }
}
