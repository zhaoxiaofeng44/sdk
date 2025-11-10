#include "./core/object.h"
#include "./core/object_extensions_simple.h"
#include "./core/dart_syntax_optimized.h"
#include <iostream>

// ============================================================================
// 优化后的 Dart 语法示例 - 基于用户反馈改进
// ============================================================================

// 简单的枚举示例  
class Priority {
public:
    enum Value {
        LOW,
        MEDIUM,
        HIGH
    };
    
    Priority() : value_(LOW) {}
    Priority(Value v) : value_(v) {}
    
    Value getValue() const { return value_; }
    Bool operator==(const Priority& other) const {
        return Bool(value_ == other.value_);
    }
    
private:
    Value value_;
};

// 示例1：优化的基本运算符使用
void demo_optimized_operators() {
    dart_print(dart_string("=== 优化的运算符使用 ==="));
    
    Int a(10);
    Int b(3);
    
    // ✅ 推荐：直接使用重载运算符
    Int sum = a + b;        // 而不是 a.operator_plus(b)
    Int diff = a - b;       // 而不是 a.operator_minus(b) 
    Int product = a * b;    // 而不是 a.operator_multiply(b)
    Int quotient = a / b;   // 而不是 a.operator_divide(b)
    Int remainder = a % b;  // 而不是 a.operator_modulo(b)
    
    dart_print(dart_string("a + b = ") + sum.toString());
    dart_print(dart_string("a - b = ") + diff.toString());
    dart_print(dart_string("a * b = ") + product.toString());
    dart_print(dart_string("a / b = ") + quotient.toString());
    dart_print(dart_string("a % b = ") + remainder.toString());
    
    // ✅ 推荐：直接使用自增自减
    ++a;                    // 而不是 dart_increment(a)
    dart_print(dart_string("++a = ") + a.toString());
    
    b++;                    // 后置自增
    dart_print(dart_string("b++ = ") + b.toString());
    
    // ✅ 推荐：直接使用复合赋值
    a += b;                 // 而不是手动调用函数
    dart_print(dart_string("a += b = ") + a.toString());
    
    a *= dart_int(2);       // 复合赋值
    dart_print(dart_string("a *= 2 = ") + a.toString());
}

// 示例2：优化的条件判断
void demo_optimized_conditions() {
    dart_print(dart_string("=== 优化的条件判断 ==="));
    
    Int x(5);
    Int y(3);
    
    // ✅ 推荐：直接使用比较运算符
    Bool isGreater = x > y;     // 而不是 x.operator>(y)
    Bool isEqual = x == y;      // 而不是 x.operator==(y)
    Bool isLessOrEqual = x <= y;// 而不是 x.operator<=(y)
    
    // ✅ 推荐：利用Bool的隐式转换，直接用于条件判断
    if (isGreater) {            // 而不是 if (isGreater.toBool())
        dart_print(dart_string("x > y 为真"));
    }
    
    if (!isEqual) {             // 直接使用逻辑非
        dart_print(dart_string("x != y"));
    }
    
    // ✅ 组合条件判断
    Bool complexCondition = isGreater && !isEqual;  // 直接使用逻辑运算符
    if (complexCondition) {
        dart_print(dart_string("复合条件为真"));
    }
    
    // ✅ 在循环中使用Bool条件
    Bool shouldContinue = dart_bool(true);
    Int counter(0);
    
    while (shouldContinue) {    // 而不是 while (shouldContinue.toBool())
        ++counter;
        dart_print(dart_string("循环计数: ") + counter.toString());
        
        shouldContinue = counter < dart_int(3);  // 直接赋值比较结果
    }
}

// 示例3：优化的字符串操作
void demo_optimized_strings() {
    dart_print(dart_string("=== 优化的字符串操作 ==="));
    
    String greeting = dart_string("Hello");
    String comma = dart_string(", ");
    String name = dart_string("World");
    String exclamation = dart_string("!");
    
    // ✅ 推荐：直接使用 + 运算符进行字符串拼接
    String message = greeting + comma + name + exclamation;
    dart_print(dart_string("拼接结果: ") + message);
    
    // ✅ 字符串比较也直接使用运算符
    String test1 = dart_string("apple");
    String test2 = dart_string("banana");
    
    if (test1 < test2) {        // 直接使用 < 运算符
        dart_print(dart_string("apple < banana (按字典序)"));
    }
    
    if (test1 != test2) {       // 直接使用 != 运算符
        dart_print(dart_string("两个字符串不相等"));
    }
    
    // 字符串方法仍需调用（这些不能重载）
    Int length = message.get_length();
    dart_print(dart_string("消息长度: ") + length.toString());
    
    Bool isEmpty = message.get_isEmpty();
    if (!isEmpty) {             // 利用Bool隐式转换
        dart_print(dart_string("消息不为空"));
    }
}

// 示例4：优化的集合操作
void demo_optimized_collections() {
    dart_print(dart_string("=== 优化的集合操作 ==="));
    
    // ✅ 使用简化的集合创建宏
    ObjectPtr<List<Int> > numbers = new_list_int();
    
    // 添加一些数字
    for (int i = 1; i <= 5; i++) {
        Int value(i);
        numbers->add(value);
    }
    
    dart_print(dart_string("数字列表:"));
    
    // ✅ 使用优化的 for-each 宏
    dart_for_each_optimized(Int, num, numbers)
        // 在循环中可以直接使用运算符
        Int doubled = num * dart_int(2);
        Bool isEven = (num % dart_int(2)) == dart_int(0);  // 直接使用运算符组合
        
        String output = dart_string("  ") + num.toString() + 
                       dart_string(" -> ") + doubled.toString();
        
        if (isEven) {           // 利用隐式转换
            output = output + dart_string(" (偶数)");
        }
        
        dart_print(output);
    dart_end_for_optimized
    
    // 集合统计
    Int total(0);
    dart_for_each_optimized(Int, num, numbers)
        total += num;           // 直接使用复合赋值
    dart_end_for_optimized
    
    dart_print(dart_string("总和: ") + total.toString());
}

// 示例5：控制流优化
void demo_optimized_control_flow() {
    dart_print(dart_string("=== 优化的控制流 ==="));
    
    // ✅ 直接使用C++原生控制流，配合优化的条件判断
    for (int i = 1; i <= 5; i++) {
        Int value(i);
        
        // switch语句需要转换为int
        switch (value.toInt()) {
            case 1:
                dart_print(dart_string("第一个"));
                break;
            case 2:
            case 3:
                dart_print(dart_string("第二或第三个"));
                break;
            default:
                dart_print(dart_string("其他: ") + value.toString());
                break;
        }
    }
    
    // ✅ 优化的条件链
    Int score(85);
    String grade;
    
    if (score >= dart_int(90)) {        // 直接比较
        grade = dart_string("A");
    } else if (score >= dart_int(80)) { // 链式条件
        grade = dart_string("B");
    } else if (score >= dart_int(70)) {
        grade = dart_string("C");
    } else {
        grade = dart_string("D");
    }
    
    dart_print(dart_string("分数 ") + score.toString() + 
              dart_string(" 对应等级: ") + grade);
}

// 示例6：枚举和类型使用
void demo_enums_and_types() {
    dart_print(dart_string("=== 枚举和类型示例 ==="));
    
    Priority taskPriority(Priority::HIGH);
    Priority urgentPriority(Priority::HIGH);
    
    // ✅ 枚举比较直接使用运算符
    if (taskPriority == urgentPriority) {   // 而不是调用方法
        dart_print(dart_string("任务优先级匹配"));
    }
    
    // 枚举在switch中使用
    switch (taskPriority.getValue()) {
        case Priority::LOW:
            dart_print(dart_string("低优先级任务"));
            break;
        case Priority::MEDIUM:
            dart_print(dart_string("中优先级任务"));
            break;
        case Priority::HIGH:
            dart_print(dart_string("高优先级任务"));
            break;
    }
}

// 示例7：数学运算优化
void demo_optimized_math() {
    dart_print(dart_string("=== 优化的数学运算 ==="));
    
    Double x(3.5);
    Double y(2.0);
    
    // ✅ 直接使用运算符进行Double运算
    Double sum = x + y;         // 而不是 x.operator_plus(y)
    Double product = x * y;     // 而不是 x.operator_multiply(y)
    Double quotient = x / y;    // 而不是 x.operator_divide(y)
    
    dart_print(dart_string("x + y = ") + sum.toString());
    dart_print(dart_string("x * y = ") + product.toString());
    dart_print(dart_string("x / y = ") + quotient.toString());
    
    // ✅ 比较运算符也直接使用
    Bool isGreater = x > y;     // 直接比较
    if (isGreater) {
        dart_print(dart_string("x > y"));
    }
    
    // 复合表达式
    Bool complexMath = (x + y) > (x * dart_double(2.0));  // 直接组合运算符
    if (complexMath) {
        dart_print(dart_string("复合数学表达式为真"));
    }
}

// 主函数演示所有优化特性
int main() {
    try {
        dart_print(dart_string("Dart语法优化示例"));
        dart_print(dart_string("================="));
        std::cout << std::endl;
        
        demo_optimized_operators();
        std::cout << std::endl;
        
        demo_optimized_conditions();
        std::cout << std::endl;
        
        demo_optimized_strings();
        std::cout << std::endl;
        
        demo_optimized_collections();
        std::cout << std::endl;
        
        demo_optimized_control_flow();
        std::cout << std::endl;
        
        demo_enums_and_types();
        std::cout << std::endl;
        
        demo_optimized_math();
        std::cout << std::endl;
        
        dart_print(dart_string("✅ 所有优化示例运行完成！"));
        
    } catch (...) {
        std::cerr << "❌ 程序执行出现错误" << std::endl;
        return 1;
    }
    
    return 0;
}
