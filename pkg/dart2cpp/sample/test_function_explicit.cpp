#include "dart2cpp.h"
#include <functional>

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
        // 测试普通函数 - 显式指定模板参数
        auto result1 = calculate(dart_int(10), dart_int(5), 
            makeFunction<Int, Int, Int>(static_cast<Int(*)(Int, Int)>(&add)));
        dart_print(dart_concat(dart_string("10 + 5 = "), result1));
        
        auto result2 = calculate(dart_int(10), dart_int(5), 
            makeFunction<Int, Int, Int>(static_cast<Int(*)(Int, Int)>(&subtract)));
        dart_print(dart_concat(dart_string("10 - 5 = "), result2));
        
        // 测试 lambda - 显式指定模板参数
        auto multiply = makeFunction<Int, Int, Int>(std::function<Int(Int, Int)>([](Int a, Int b) -> Int {
            return a * b;
        }));
        auto result3 = calculate(dart_int(10), dart_int(5), multiply);
        dart_print(dart_concat(dart_string("10 * 5 = "), result3));
        
        return 0;
    } catch (const std::exception& e) {
        std::cerr << "Error: " << e.what() << std::endl;
        return 1;
    }
}