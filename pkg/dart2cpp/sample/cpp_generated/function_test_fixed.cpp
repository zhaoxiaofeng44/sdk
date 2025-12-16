#include "dart2cpp.h"

// 测试函数
Int add(Int a, Int b) {
  return a->operator_add(b);
}

Int multiply(Int a, Int b) {
  return a->operator_mul(b);
}

// 测试calculate函数
Int calculate(Int a, Int b, ObjectPtr<Function> operation) {
  return dart_cast<Int>(operation->call(a, b));
}

// 获取加法函数
ObjectPtr<Function> getAddFunction() {
  return makeFunction(&add);
}

// 创建乘法器
ObjectPtr<Function> createMultiplier(Int factor) {
  return makeFunction([&](Int value) { return value->operator_mul(factor); });
}

// 测试匿名函数
void testAnonymousFunction() {
  auto square = makeFunction([](Int x) { return x->operator_mul(x); });
  auto result = square->call(dart_int(5));
  dart_print(dart_string("匿名函数结果 (5*5): ") + result.toString());
}

// 主函数
int main() {
  try {
    dart_print(dart_string("开始测试Function功能"));
    
    // 测试基本函数调用
    auto result1 = calculate(dart_int(10), dart_int(5), makeFunction(&add));
    dart_print(dart_string("10 + 5 = ") + result1.toString());
    
    auto result2 = calculate(dart_int(10), dart_int(5), makeFunction(&multiply));
    dart_print(dart_string("10 * 5 = ") + result2.toString());
    
    // 测试函数引用
    auto addFunc = getAddFunction();
    auto result3 = addFunc->call(dart_int(10), dart_int(5));
    dart_print(dart_string("函数引用结果: ") + result3.toString());
    
    // 测试高阶函数
    auto multiplier = createMultiplier(dart_int(3));
    auto result4 = multiplier->call(dart_int(5));
    dart_print(dart_string("高阶函数结果: ") + result4.toString());
    
    // 测试匿名函数
    testAnonymousFunction();
    
    dart_print(dart_string("✅ Function功能测试成功"));
    return 0;
  } catch (const std::exception& e) {
    std::cerr << "Error: " << e.what() << std::endl;
    return 1;
  }
}