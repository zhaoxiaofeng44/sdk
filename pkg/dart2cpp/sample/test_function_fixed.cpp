#include "dart2cpp.h"

// 测试函数
Int add(Int a, Int b) {
    return a + b;
}

Int subtract(Int a, Int b) {
    return a - b;
}

Int calculate(Int a, Int b, ObjectPtr<Function> operation) {
    return Int(operation->apply({a, b}));
}

int main() {
    try {
        // 测试普通函数
        auto result1 = calculate(dart_int(10), dart_int(5), makeFunction(&add));
        dart_print(dart_concat(dart_string("10 + 5 = "), result1));
        
        auto result2 = calculate(dart_int(10), dart_int(5), makeFunction(&subtract));
        dart_print(dart_concat(dart_string("10 - 5 = "), result2));
        
        // 测试 lambda
        auto multiply = makeFunction([](Int a, Int b) -> Int {
            return a * b;
        });
        auto result3 = calculate(dart_int(10), dart_int(5), multiply);
        dart_print(dart_concat(dart_string("10 * 5 = "), result3));
        
        return 0;
    } catch (const std::exception& e) {
        std::cerr << "Error: " << e.what() << std::endl;
        return 1;
    }
}