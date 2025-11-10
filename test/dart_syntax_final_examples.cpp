#include "./core/object.h"
#include <iostream>

// ============================================================================
// 最终简化的 Dart 语法示例 - 只使用基础类型，展示语法简化效果
// ============================================================================

// 简化的类型构造宏
#define dart_int(value) Int(value)
#define dart_double(value) Double(value)
#define dart_bool(value) Bool(value)
#define dart_string(value) String(value)

// 简化的打印宏
#define dart_print(value) \
    do { \
        std::cout << (value).toString().getValue() << std::endl; \
    } while(0)

// 简单枚举类
class Priority {
public:
    enum Value { LOW, MEDIUM, HIGH };
    
    Priority() : value_(LOW) {}
    Priority(Value v) : value_(v) {}
    
    Value getValue() const { return value_; }
    Bool operator==(const Priority& other) const {
        return Bool(value_ == other.value_);
    }
    Bool operator>(const Priority& other) const {
        return Bool(value_ > other.value_);
    }
    
private:
    Value value_;
};

// 示例1：简化的变量声明
void demo_simplified_variables() {
    dart_print(dart_string("=== 简化的变量声明 ==="));
    
    // ✅ 使用 auto 替代 var（无需 dart_var 宏）
    auto x = dart_int(42);              // 相当于 Dart: var x = 42;
    auto pi = dart_double(3.14159);     // 相当于 Dart: var pi = 3.14159;
    auto flag = dart_bool(true);        // 相当于 Dart: var flag = true;
    auto message = dart_string("Hello");// 相当于 Dart: var message = "Hello";
    
    dart_print(dart_string("x = ") + x.toString());
    dart_print(dart_string("pi = ") + pi.toString());
    dart_print(dart_string("flag = ") + flag.toString());
    dart_print(dart_string("message = ") + message);
    
    // ✅ 使用 const auto 替代 const（无需 dart_const 宏）
    const auto maxValue = dart_int(100);        // 相当于 Dart: const maxValue = 100;
    const auto appName = dart_string("MyApp");  // 相当于 Dart: const appName = "MyApp";
    
    dart_print(dart_string("maxValue = ") + maxValue.toString());
    dart_print(dart_string("appName = ") + appName);
}

// 示例2：简化的条件判断
void demo_simplified_conditions() {
    dart_print(dart_string("=== 简化的条件判断 ==="));
    
    auto a = dart_int(10);
    auto b = dart_int(5);
    
    // ✅ 直接使用运算符和隐式转换（无需 .toBool() 或 dart_if 宏）
    Bool isGreater = a > b;
    if (isGreater) {                    // 直接使用，Bool 自动转换为 bool
        dart_print(dart_string("a > b"));
    }
    
    // ✅ 组合条件判断
    Bool isPositive = a > dart_int(0);
    Bool isEven = (a % dart_int(2)) == dart_int(0);
    
    if (isPositive && isEven) {         // 直接使用逻辑运算符
        dart_print(dart_string("a is positive and even"));
    }
    
    // ✅ 直接在条件中使用表达式
    if ((a + b) > dart_int(10)) {       // 无需中间变量
        dart_print(dart_string("a + b > 10"));
    }
    
    // ✅ 否定条件
    if (!(a == b)) {                    // 直接使用 !，无需 dart_unless
        dart_print(dart_string("a != b"));
    }
}

// 示例3：简化的循环和控制流
void demo_simplified_control_flow() {
    dart_print(dart_string("=== 简化的控制流 ==="));
    
    auto counter = dart_int(5);
    
    // ✅ 直接使用 while 循环（无需 dart_while 宏）
    while (counter > dart_int(0)) {     // Bool 隐式转换
        dart_print(dart_string("Counter: ") + counter.toString());
        counter = counter - dart_int(1); // 直接使用减法运算符
    }
    
    // ✅ 直接使用 for 循环
    for (int i = 1; i <= 3; i++) {
        auto value = dart_int(i);
        
        // ✅ 直接使用 switch（需要转换为 int）
        switch (value.toInt()) {
            case 1:
                dart_print(dart_string("First"));
                break;
            case 2:
                dart_print(dart_string("Second"));
                break;
            case 3:
                dart_print(dart_string("Third"));
                break;
        }
    }
    
    // ✅ 直接使用三元操作符（无需 dart_ternary 宏）
    auto status = counter > dart_int(0) ? 
                  dart_string("有剩余") : 
                  dart_string("已完成");
    dart_print(dart_string("状态: ") + status);
}

// 示例4：简化的运算符使用
void demo_simplified_operators() {
    dart_print(dart_string("=== 简化的运算符使用 ==="));
    
    auto x = dart_int(15);
    auto y = dart_int(4);
    
    // ✅ 直接使用算术运算符
    auto sum = x + y;
    auto diff = x - y;
    auto product = x * y;
    auto quotient = x / y;
    auto remainder = x % y;
    
    dart_print(dart_string("15 + 4 = ") + sum.toString());
    dart_print(dart_string("15 - 4 = ") + diff.toString());
    dart_print(dart_string("15 * 4 = ") + product.toString());
    dart_print(dart_string("15 / 4 = ") + quotient.toString());
    dart_print(dart_string("15 % 4 = ") + remainder.toString());
    
    // ✅ 直接使用字符串运算符
    auto firstName = dart_string("张");
    auto lastName = dart_string("三");
    auto fullName = firstName + lastName;   // 直接拼接
    
    dart_print(dart_string("姓名: ") + fullName);
    
    // ✅ 比较运算符
    Bool isEqual = x == y;
    Bool isNotEqual = x != y;
    Bool isLess = x < y;
    Bool isGreater = x > y;
    
    dart_print(dart_string("x == y: ") + isEqual.toString());
    dart_print(dart_string("x != y: ") + isNotEqual.toString());
    dart_print(dart_string("x < y: ") + isLess.toString());
    dart_print(dart_string("x > y: ") + isGreater.toString());
}

// 示例5：复杂表达式和逻辑
void demo_complex_expressions() {
    dart_print(dart_string("=== 复杂表达式 ==="));
    
    auto score = dart_int(85);
    auto bonus = dart_int(5);
    auto penalty = dart_int(2);
    
    // ✅ 复杂的数学表达式
    auto finalScore = score + bonus - penalty;
    auto percentage = (finalScore * dart_int(100)) / dart_int(100);
    
    dart_print(dart_string("最终分数: ") + finalScore.toString());
    
    // ✅ 复杂的布尔表达式
    Bool isExcellent = finalScore >= dart_int(90);
    Bool isGood = finalScore >= dart_int(80) && finalScore < dart_int(90);
    Bool isPassing = finalScore >= dart_int(60);
    
    auto grade = isExcellent ? dart_string("优秀") :
                 isGood ? dart_string("良好") :
                 isPassing ? dart_string("及格") : dart_string("不及格");
    
    dart_print(dart_string("等级: ") + grade);
    
    // ✅ 组合条件判断
    if ((score > dart_int(80)) && (bonus > dart_int(0)) && !isExcellent) {
        dart_print(dart_string("接近优秀，继续努力！"));
    }
}

// 示例6：枚举和类型使用
void demo_enums_and_types() {
    dart_print(dart_string("=== 枚举和类型 ==="));
    
    auto currentPriority = Priority(Priority::MEDIUM);
    auto targetPriority = Priority(Priority::HIGH);
    
    // ✅ 直接使用枚举比较
    if (currentPriority == targetPriority) {
        dart_print(dart_string("优先级匹配"));
    } else {
        dart_print(dart_string("优先级不匹配"));
    }
    
    // ✅ 在 switch 中使用枚举
    switch (currentPriority.getValue()) {
        case Priority::LOW:
            dart_print(dart_string("低优先级"));
            break;
        case Priority::MEDIUM:
            dart_print(dart_string("中优先级"));
            break;
        case Priority::HIGH:
            dart_print(dart_string("高优先级"));
            break;
    }
    
    // ✅ 条件表达式中使用枚举
    auto priorityText = (currentPriority > Priority(Priority::LOW)) ? 
                       dart_string("重要任务") : dart_string("普通任务");
    dart_print(dart_string("任务级别: ") + priorityText);
}

// 示例7：字符串处理
void demo_string_operations() {
    dart_print(dart_string("=== 字符串操作 ==="));
    
    auto base = dart_string("Hello");
    auto world = dart_string("World");
    auto exclamation = dart_string("!");
    
    // ✅ 字符串连接
    auto greeting = base + dart_string(", ") + world + exclamation;
    dart_print(dart_string("问候语: ") + greeting);
    
    // ✅ 字符串比较
    Bool isEmpty = base == dart_string("");
    Bool isNotEmpty = base != dart_string("");
    
    if (isNotEmpty) {
        dart_print(dart_string("字符串不为空"));
    }
    
    // ✅ 字符串长度比较
    Bool isLong = base.length() > dart_int(3);
    if (isLong) {
        dart_print(dart_string("字符串较长: ") + base.length().toString() + dart_string(" 字符"));
    }
}

// 主函数
int main() {
    try {
        dart_print(dart_string("最终简化的 Dart 语法示例"));
        dart_print(dart_string("========================"));
        std::cout << std::endl;
        
        demo_simplified_variables();
        std::cout << std::endl;
        
        demo_simplified_conditions();
        std::cout << std::endl;
        
        demo_simplified_control_flow();
        std::cout << std::endl;
        
        demo_simplified_operators();
        std::cout << std::endl;
        
        demo_complex_expressions();
        std::cout << std::endl;
        
        demo_enums_and_types();
        std::cout << std::endl;
        
        demo_string_operations();
        std::cout << std::endl;
        
        dart_print(dart_string("✅ 所有简化示例运行完成！"));
        dart_print(dart_string("优势："));
        dart_print(dart_string("  1. 无需 dart_if/dart_ternary 宏"));
        dart_print(dart_string("  2. var 直接用 auto 替代"));
        dart_print(dart_string("  3. Bool 隐式转换到 bool"));
        dart_print(dart_string("  4. 运算符直接重载使用"));
        dart_print(dart_string("  5. 代码更简洁，更接近原生语法"));
        
    } catch (...) {
        std::cerr << "❌ 程序执行出现错误" << std::endl;
        return 1;
    }
    
    return 0;
}