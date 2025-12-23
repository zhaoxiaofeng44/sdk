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
auto x = dart_int(10);
auto addX = makeFunction([&](Int y) { return x->operator_add(y); }, std::vector<Any>{Any(x)});
dart_print(addX->call(dart_int(5)));
return Void;
}

Nullable testMultipleCapture() {
  dart_print(dart_string("Test 2: Multiple Variable Capture"));
auto a = dart_int(5);
auto b = dart_int(10);
auto prefix = dart_string("Result: ");
auto compute = makeFunction([&]() { auto sum = a->operator_add(b);
return prefix->operator_add(sum->toString()); }, std::vector<Any>{Any(a), Any(b), Any(prefix)});
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
auto functions = _GrowableList::create(dart_int(0));
for (auto i = dart_int(0); i->operator_less(dart_int(3)); i = i->operator_add(dart_int(1))) {
functions->add(makeFunction([&]() { return i; }, std::vector<Any>{Any(i)}));
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
auto outer = dart_int(1);
auto outerFunc = makeFunction([&]() { auto middle = dart_int(10);
auto innerFunc = makeFunction([&]() { return outer->operator_add(middle); }, std::vector<Any>{Any(outer), Any(middle)});
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
