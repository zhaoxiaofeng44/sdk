#include "../core/dart2cpp.h"
#include <iostream>
#include <cassert>

// 演示 ValuePtr<Int> 和 Int 的完全隐式混合计算

int main() {
    std::cout << "=== ValuePtr 与 Int 隐式混合计算测试 ===" << std::endl << std::endl;
    
    // 测试 1: 简单赋值 - 完全隐式转换
    std::cout << "测试 1: 简单赋值" << std::endl;
    ValuePtr<Int> vptr(Int(42));
    Int value = vptr;  // ValuePtr<Int> 隐式转换为 Int
    std::cout << "  ValuePtr<Int>(42) -> Int: " << value.getValue() << std::endl;
    assert(value.getValue() == 42);
    
    // 测试 2: 函数参数 - 完全隐式转换
    std::cout << "\n测试 2: 函数参数隐式转换" << std::endl;
    auto add = [](const Int& a, const Int& b) -> Int {
        return a + b;
    };
    
    ValuePtr<Int> num1(Int(10));
    ValuePtr<Int> num2(Int(20));
    Int sum = add(num1, num2);  // 两个 ValuePtr 都隐式转换为 Int
    std::cout << "  add(ValuePtr(10), ValuePtr(20)) = " << sum.getValue() << std::endl;
    assert(sum.getValue() == 30);
    
    // 测试 3: 混合运算 - 使用解引用运算符
    std::cout << "\n测试 3: 解引用运算符混合计算" << std::endl;
    ValuePtr<Int> a(Int(100));
    Int b(50);
    
    Int result1 = (*a) + b;  // *a 解引用获取 Int&，然后与 b 运算
    std::cout << "  (*ValuePtr(100)) + Int(50) = " << result1.getValue() << std::endl;
    assert(result1.getValue() == 150);
    
    // 测试 4: 多个 ValuePtr 混合运算
    std::cout << "\n测试 4: 多个 ValuePtr 混合运算" << std::endl;
    ValuePtr<Int> x(Int(5));
    ValuePtr<Int> y(Int(3));
    ValuePtr<Int> z(Int(2));
    
    Int result2 = (*x) * (*y) + (*z);  // 全部使用解引用
    std::cout << "  (*x * *y) + *z = " << result2.getValue() << std::endl;
    assert(result2.getValue() == 17);
    
    // 测试 5: 比较运算
    std::cout << "\n测试 5: 比较运算" << std::endl;
    ValuePtr<Int> val1(Int(100));
    Int val2(50);
    
    Bool isGreater = (*val1) > val2;  // 解引用后比较
    std::cout << "  (*ValuePtr(100)) > Int(50) = " 
              << (isGreater.getValue() ? "true" : "false") << std::endl;
    assert(isGreater.getValue() == true);
    
    // 测试 6: 赋值给 ValuePtr（自动装箱）
    std::cout << "\n测试 6: 计算结果赋值给 ValuePtr" << std::endl;
    ValuePtr<Int> counter(Int(10));
    Int increment(5);
    
    Int newValue = (*counter) + increment;
    counter = newValue;  // Int 自动装箱为 ValuePtr
    std::cout << "  counter = (*counter) + increment: " << counter->getValue() << std::endl;
    assert(counter->getValue() == 15);
    
    // 测试 7: 链式运算
    std::cout << "\n测试 7: 链式运算" << std::endl;
    ValuePtr<Int> m(Int(8));
    ValuePtr<Int> n(Int(4));
    Int p(2);
    
    Int chainResult = ((*m) / (*n)) * p;
    std::cout << "  ((*m) / (*n)) * p = " << chainResult.getValue() << std::endl;
    assert(chainResult.getValue() == 4);
    
    // 测试 8: 容器中的隐式转换
    std::cout << "\n测试 8: 容器中的隐式转换" << std::endl;
    ValuePtr<Int> v1(Int(1)), v2(Int(2)), v3(Int(3));
    
    std::vector<Int> vec;
    vec.push_back(v1);  // 隐式转换
    vec.push_back(v2);
    vec.push_back(v3);
    
    std::cout << "  容器内容: ";
    for (const auto& v : vec) {
        std::cout << v.getValue() << " ";
    }
    std::cout << std::endl;
    
    // 测试 9: Double 类型的混合运算
    std::cout << "\n测试 9: Double 类型混合运算" << std::endl;
    ValuePtr<Double> dptr(Double(3.14));
    Double d2(2.0);
    
    Double dresult = (*dptr) * d2;
    std::cout << "  (*ValuePtr(3.14)) * Double(2.0) = " << dresult.getValue() << std::endl;
    assert(dresult.getValue() == 6.28);
    
    // 测试 10: 复杂表达式
    std::cout << "\n测试 10: 复杂表达式" << std::endl;
    ValuePtr<Int> base(Int(10));
    Int multiplier(3);
    Int offset(5);
    
    Int complexResult = (*base) * multiplier + offset;
    std::cout << "  (*base) * multiplier + offset = " << complexResult.getValue() << std::endl;
    assert(complexResult.getValue() == 35);
    
    std::cout << "\n===================================" << std::endl;
    std::cout << "所有隐式混合计算测试通过！✓" << std::endl;
    std::cout << "===================================" << std::endl;
    
    // 总结使用方式
    std::cout << "\n【使用建议】" << std::endl;
    std::cout << "1. 赋值/传参: Int value = valuePtr;  (完全隐式)" << std::endl;
    std::cout << "2. 运算: Int result = (*valuePtr) + normalInt;  (使用 * 解引用)" << std::endl;
    std::cout << "3. 访问成员: int raw = valuePtr->getValue();  (使用 -> 箭头)" << std::endl;
    std::cout << "4. 装箱: valuePtr = intValue;  (自动装箱)" << std::endl;
    
    return 0;
}
