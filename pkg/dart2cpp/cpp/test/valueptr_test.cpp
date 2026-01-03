#include "../core/dart2cpp.h"
#include <iostream>
#include <cassert>

// 测试 ValuePtr 的自动装箱和解箱功能
void test_valueptr_boxing() {
    std::cout << "=== Testing ValuePtr Boxing ===" << std::endl;
    
    // 测试 1: 自动装箱构造
    ValuePtr<Int> intPtr(Int(42));
    std::cout << "Test 1 - Auto boxing: " << (*intPtr).toString().getValue() << std::endl;
    assert((*intPtr).getValue() == 42);
    
    // 测试 2: 使用箭头运算符访问值的方法
    std::cout << "Test 2 - Arrow operator: " << intPtr->toString().getValue() << std::endl;
    assert(intPtr->getValue() == 42);
    
    // 测试 3: 自动装箱赋值
    intPtr = Int(100);
    std::cout << "Test 3 - Auto boxing assignment: " << intPtr->getValue() << std::endl;
    assert(intPtr->getValue() == 100);
    
    // 测试 4: 使用解引用运算符
    Int& value = *intPtr;
    std::cout << "Test 4 - Dereference operator: " << value.getValue() << std::endl;
    assert(value.getValue() == 100);
    
    // 测试 5: 直接修改值
    intPtr = Int(200);
    std::cout << "Test 5 - Direct assignment: " << intPtr->getValue() << std::endl;
    assert(intPtr->getValue() == 200);
    
    std::cout << "All ValuePtr Int tests passed!" << std::endl << std::endl;
}

void test_valueptr_double() {
    std::cout << "=== Testing ValuePtr with Double ===" << std::endl;
    
    // 测试 Double 类型的装箱
    ValuePtr<Double> doublePtr(Double(3.14));
    std::cout << "Test 1 - Double boxing: " << doublePtr->getValue() << std::endl;
    assert(doublePtr->getValue() == 3.14);
    
    // 使用箭头运算符调用 Double 的方法
    std::cout << "Test 2 - Double toString: " << doublePtr->toString().getValue() << std::endl;
    
    // 修改值
    doublePtr = Double(2.718);
    std::cout << "Test 3 - Double reassignment: " << doublePtr->getValue() << std::endl;
    assert(doublePtr->getValue() == 2.718);
    
    std::cout << "All ValuePtr Double tests passed!" << std::endl << std::endl;
}

void test_valueptr_string() {
    std::cout << "=== Testing ValuePtr with String ===" << std::endl;
    
    // 测试 String 类型的装箱
    ValuePtr<String> strPtr(String("Hello, ValuePtr!"));
    std::cout << "Test 1 - String boxing: " << strPtr->getValue() << std::endl;
    
    // 使用箭头运算符访问 String 的方法
    std::cout << "Test 2 - String length: " << strPtr->length().getValue() << std::endl;
    assert(strPtr->length().getValue() == 16);
    
    // 测试字符串连接
    String concatenated = strPtr->operator_add(String(" How are you?"));
    std::cout << "Test 3 - String concatenation: " << concatenated.getValue() << std::endl;
    
    std::cout << "All ValuePtr String tests passed!" << std::endl << std::endl;
}

void test_valueptr_static_create() {
    std::cout << "=== Testing ValuePtr Static Create ===" << std::endl;
    
    // 使用静态创建方法
    auto intPtr = ValuePtr<Int>::create(Int(999));
    std::cout << "Test 1 - Static create: " << intPtr->getValue() << std::endl;
    assert(intPtr->getValue() == 999);
    
    auto doublePtr = ValuePtr<Double>::create(Double(9.99));
    std::cout << "Test 2 - Static create Double: " << doublePtr->getValue() << std::endl;
    assert(doublePtr->getValue() == 9.99);
    
    std::cout << "All ValuePtr static create tests passed!" << std::endl << std::endl;
}

void test_valueptr_auto_conversion() {
    std::cout << "=== Testing ValuePtr Auto Conversion ===" << std::endl;
    
    // 测试自动转换为 T 类型
    ValuePtr<Int> intPtr(Int(42));
    
    // 自动转换为 Int 类型
    Int value1 = intPtr;  // 隐式转换
    std::cout << "Test 1 - Auto conversion to Int: " << value1.getValue() << std::endl;
    assert(value1.getValue() == 42);
    
    // 作为函数参数自动转换
    auto testFunc = [](const Int& val) {
        return val.getValue();
    };
    int result = testFunc(intPtr);  // ValuePtr 自动转换为 Int
    std::cout << "Test 2 - Auto conversion in function call: " << result << std::endl;
    assert(result == 42);
    
    // Double 类型自动转换
    ValuePtr<Double> doublePtr(Double(3.14));
    Double value2 = doublePtr;
    std::cout << "Test 3 - Auto conversion to Double: " << value2.getValue() << std::endl;
    assert(value2.getValue() == 3.14);
    
    // String 类型自动转换
    ValuePtr<String> strPtr(String("Hello"));
    String value3 = strPtr;
    std::cout << "Test 4 - Auto conversion to String: " << value3.getValue() << std::endl;
    assert(value3.getValue() == "Hello");
    
    // 验证可以直接用于运算
    ValuePtr<Int> num1(Int(10));
    ValuePtr<Int> num2(Int(20));
    Int sum = Int(num1.operator->()->getValue() + num2.operator->()->getValue());
    std::cout << "Test 5 - Using in arithmetic: " << sum.getValue() << std::endl;
    assert(sum.getValue() == 30);
    
    std::cout << "All ValuePtr auto conversion tests passed!" << std::endl << std::endl;
}

void test_valueptr_implicit_conversion() {
    std::cout << "=== Testing ValuePtr Implicit Conversion in Operations ===" << std::endl;
    
    // 测试 1: 完全隐式转换，无需 static_cast
    ValuePtr<Int> vptr(Int(10));
    Int normalInt(20);
    
    // 直接赋值，ValuePtr 自动转换为 Int
    Int result1 = vptr;  // 隐式转换
    std::cout << "Test 1 - Implicit conversion: " << result1.getValue() << std::endl;
    assert(result1.getValue() == 10);
    
    // 测试 2: 函数参数中的隐式转换
    auto addFunc = [](const Int& a, const Int& b) -> Int {
        return a + b;
    };
    
    ValuePtr<Int> num1(Int(5));
    ValuePtr<Int> num2(Int(15));
    Int sum = addFunc(num1, num2);  // ValuePtr 自动转换为 Int&
    std::cout << "Test 2 - Function params implicit conversion: " << sum.getValue() << std::endl;
    assert(sum.getValue() == 20);
    
    // 测试 3: 返回值隐式转换
    auto getIntValue = []() -> ValuePtr<Int> {
        return ValuePtr<Int>(Int(100));
    };
    
    Int value = getIntValue();  // ValuePtr 返回值隐式转换为 Int
    std::cout << "Test 3 - Return value implicit conversion: " << value.getValue() << std::endl;
    assert(value.getValue() == 100);
    
    // 测试 4: 条件表达式中的隐式转换
    ValuePtr<Int> score(Int(85));
    Int passingScore(60);
    
    // 直接在表达式中使用
    if (Int temp = score; temp.getValue() >= passingScore.getValue()) {
        std::cout << "Test 4 - Passed!" << std::endl;
    }
    
    // 测试 5: 数组/容器中的隐式转换
    ValuePtr<Int> v1(Int(1));
    ValuePtr<Int> v2(Int(2));
    ValuePtr<Int> v3(Int(3));
    
    std::vector<Int> intVec;
    intVec.push_back(v1);  // 隐式转换
    intVec.push_back(v2);  // 隐式转换
    intVec.push_back(v3);  // 隐式转换
    
    std::cout << "Test 5 - Container implicit conversion: ";
    for (const auto& val : intVec) {
        std::cout << val.getValue() << " ";
    }
    std::cout << std::endl;
    
    // 测试 6: 构造函数中的隐式转换
    class Calculator {
    public:
        Int value_;
        Calculator(const Int& val) : value_(val) {}
    };
    
    ValuePtr<Int> initValue(Int(999));
    Calculator calc(initValue);  // 隐式转换
    std::cout << "Test 6 - Constructor implicit conversion: " << calc.value_.getValue() << std::endl;
    assert(calc.value_.getValue() == 999);
    
    std::cout << "All implicit conversion tests passed!" << std::endl << std::endl;
}

void test_valueptr_mixed_operations() {
    std::cout << "=== Testing ValuePtr Mixed Operations ===" << std::endl;
    
    // 测试 1: ValuePtr 与值类型混合运算（使用隐式转换）
    ValuePtr<Int> vptr1(Int(10));
    Int normalInt(20);
    
    // 混合运算：ValuePtr 自动转换为 Int
    Int result1 = static_cast<Int>(vptr1) + normalInt;
    std::cout << "Test 1 - ValuePtr + Int: " << result1.getValue() << std::endl;
    assert(result1.getValue() == 30);
    
    // 测试 2: 运算结果赋值给 ValuePtr（自动装箱）
    ValuePtr<Int> vptr2(Int(5));
    Int temp = static_cast<Int>(vptr2) * Int(2);
    vptr2 = temp;  // Int 自动装箱为 ValuePtr
    std::cout << "Test 2 - Assign back to ValuePtr: " << vptr2->getValue() << std::endl;
    assert(vptr2->getValue() == 10);
    
    // 测试 3: 复杂混合运算
    ValuePtr<Int> a(Int(100));
    ValuePtr<Int> b(Int(50));
    Int c(25);
    
    // a + b - c （使用隐式转换）
    Int result3 = static_cast<Int>(a) + static_cast<Int>(b) - c;
    std::cout << "Test 3 - Complex operation (a+b-c): " << result3.getValue() << std::endl;
    assert(result3.getValue() == 125);
    
    // 将结果赋值给 ValuePtr
    ValuePtr<Int> resultPtr(Int(0));
    resultPtr = result3;  // 自动装箱
    std::cout << "Test 3b - Result assigned to ValuePtr: " << resultPtr->getValue() << std::endl;
    assert(resultPtr->getValue() == 125);
    
    // 测试 4: Double 类型混合运算（使用隐式转换）
    ValuePtr<Double> dptr1(Double(3.14));
    Double d2(2.0);
    
    Double result4 = static_cast<Double>(dptr1) * d2;
    std::cout << "Test 4 - ValuePtr<Double> * Double: " << result4.getValue() << std::endl;
    assert(result4.getValue() == 6.28);
    
    // 赋值回 ValuePtr
    ValuePtr<Double> dresultPtr(Double(0.0));
    dresultPtr = result4;  // 自动装箱
    std::cout << "Test 4b - Result assigned to ValuePtr: " << dresultPtr->getValue() << std::endl;
    assert(dresultPtr->getValue() == 6.28);
    
    // 测试 5: String 类型混合运算（使用箭头运算符）
    ValuePtr<String> sptr1(String("Hello"));
    String s2(" World");
    
    String result5 = sptr1->operator_add(s2);
    std::cout << "Test 5 - ValuePtr<String> + String: " << result5.getValue() << std::endl;
    assert(result5.getValue() == "Hello World");
    
    // 赋值回 ValuePtr
    ValuePtr<String> sresultPtr(String(""));
    sresultPtr = result5;  // 自动装箱
    std::cout << "Test 5b - Result assigned to ValuePtr: " << sresultPtr->getValue() << std::endl;
    assert(sresultPtr->getValue() == "Hello World");
    
    // 测试 6: 链式运算并赋值（使用隐式转换）
    ValuePtr<Int> x(Int(2));
    Int y(3);
    Int z(4);
    
    // (x * y) + z
    Int result6 = static_cast<Int>(x) * y + z;
    
    ValuePtr<Int> finalResult(Int(0));
    finalResult = result6;  // 自动装箱
    std::cout << "Test 6 - Chain operation result: " << finalResult->getValue() << std::endl;
    assert(finalResult->getValue() == 10);
    
    // 测试 7: 自增自减与混合运算（使用隐式转换）
    ValuePtr<Int> counter(Int(10));
    Int increment(5);
    
    // counter + increment
    Int newValue = static_cast<Int>(counter) + increment;
    counter = newValue;  // 自动装箱
    std::cout << "Test 7 - Counter incremented: " << counter->getValue() << std::endl;
    assert(counter->getValue() == 15);
    
    // 测试 8: 比较运算（使用隐式转换）
    ValuePtr<Int> val1(Int(100));
    Int val2(50);
    
    Bool isGreater = static_cast<Int>(val1) > val2;
    std::cout << "Test 8 - Comparison (100 > 50): " << (isGreater.getValue() ? "true" : "false") << std::endl;
    assert(isGreater.getValue() == true);
    
    // 测试 9: 使用箭头运算符和隐式转换的混合运算
    ValuePtr<Int> num1(Int(8));
    ValuePtr<Int> num2(Int(4));
    Int num3(2);
    
    // (num1 / num2) * num3
    Int div_result = (*num1) / (*num2);  // 使用解引用运算符
    Int final_result = div_result * num3;
    
    ValuePtr<Int> mathResult(Int(0));
    mathResult = final_result;  // 自动装箱
    std::cout << "Test 9 - Math operation result: " << mathResult->getValue() << std::endl;
    assert(mathResult->getValue() == 4);
    
    // 测试 10: 连续赋值
    ValuePtr<Int> src(Int(999));
    Int intermediate = src;  // 自动解箱
    ValuePtr<Int> dest(Int(0));
    dest = intermediate;  // 自动装箱
    std::cout << "Test 10 - Continuous assignment: " << dest->getValue() << std::endl;
    assert(dest->getValue() == 999);
    
    std::cout << "All ValuePtr mixed operations tests passed!" << std::endl << std::endl;
}

void test_valueptr_copy() {
    std::cout << "=== Testing ValuePtr Copy ===" << std::endl;
    
    // 测试拷贝构造
    ValuePtr<Int> original(Int(42));
    ValuePtr<Int> copy(original);
    
    std::cout << "Test 1 - Copy constructor: " << copy->getValue() << std::endl;
    assert(copy->getValue() == 42);
    
    // 修改拷贝，原始值应该也改变（因为是引用计数）
    copy = Int(100);
    std::cout << "Test 2 - Original after copy modified: " << original->getValue() << std::endl;
    assert(original->getValue() == 100); // 共享同一个对象
    
    // 测试赋值操作
    ValuePtr<Int> another(Int(200));
    another = copy;
    std::cout << "Test 3 - Assignment operator: " << another->getValue() << std::endl;
    assert(another->getValue() == 100);
    
    std::cout << "All ValuePtr copy tests passed!" << std::endl << std::endl;
}

int main() {
    try {
        std::cout << "Starting ValuePtr Tests..." << std::endl << std::endl;
        
        test_valueptr_boxing();
        test_valueptr_double();
        test_valueptr_string();
        test_valueptr_static_create();
        test_valueptr_auto_conversion();
        test_valueptr_implicit_conversion();
        test_valueptr_mixed_operations();
        test_valueptr_copy();
        
        std::cout << "==================================" << std::endl;
        std::cout << "All ValuePtr tests passed successfully!" << std::endl;
        std::cout << "==================================" << std::endl;
        
        return 0;
    } catch (const std::exception& e) {
        std::cerr << "Test failed with exception: " << e.what() << std::endl;
        return 1;
    }
}
