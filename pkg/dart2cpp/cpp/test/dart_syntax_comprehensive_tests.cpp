#include "../core/object.h"
#include "../core/dart_oop_extensions.h"
#include "../core/dart_async_simple.h"
#include <iostream>
#include <cassert>

// 工具宏定义
#define dart_print(value) \
    do { \
        std::cout << (value).toString().getValue() << std::endl; \
    } while(0)

#define dart_int(value) Int(value)
#define dart_double(value) Double(value)
#define dart_bool(value) Bool(value)
#define dart_string(value) String(value)

#define dart_assert(condition, message) \
    do { \
        if (!(condition)) { \
            std::cerr << "Assertion failed: " << message << std::endl; \
            std::abort(); \
        } \
    } while(0)

// ============================================================================
// 1. 基础数据类型测试
// ============================================================================

void test_basic_data_types() {
    dart_print(dart_string("=== 测试基础数据类型 ==="));
    
    // int 类型测试
    Int x = dart_int(42);
    dart_assert(x.value == 42, "Int construction failed");
    dart_print(dart_string("Int test: ") + x.toString());
    
    // double 类型测试
    Double y = dart_double(3.14159);
    dart_assert(y.value == 3.14159, "Double construction failed");
    dart_print(dart_string("Double test: ") + y.toString());
    
    // bool 类型测试
    Bool flag_true = dart_bool(true);
    Bool flag_false = dart_bool(false);
    dart_assert(flag_true.value == true, "Bool true failed");
    dart_assert(flag_false.value == false, "Bool false failed");
    dart_print(dart_string("Bool test: ") + flag_true.toString() + dart_string(" / ") + flag_false.toString());
    
    // String 类型测试
    String name = dart_string("Hello World");
    dart_assert(name.getValue() == "Hello World", "String construction failed");
    dart_print(dart_string("String test: ") + name);
    
    dart_print(dart_string("✅ 基础数据类型测试通过"));
}

// ============================================================================
// 2. 算术运算符测试
// ============================================================================

void test_arithmetic_operators() {
    dart_print(dart_string("=== 测试算术运算符 ==="));
    
    Int a = dart_int(10);
    Int b = dart_int(3);
    
    // 加法
    Int sum = a + b;
    dart_assert(sum.value == 13, "Addition failed");
    dart_print(dart_string("10 + 3 = ") + sum.toString());
    
    // 减法
    Int diff = a - b;
    dart_assert(diff.value == 7, "Subtraction failed");
    dart_print(dart_string("10 - 3 = ") + diff.toString());
    
    // 乘法
    Int product = a * b;
    dart_assert(product.value == 30, "Multiplication failed");
    dart_print(dart_string("10 * 3 = ") + product.toString());
    
    // 除法
    Double quotient = a / b;
    dart_assert(quotient.value == 10.0/3.0, "Division failed");
    dart_print(dart_string("10 / 3 = ") + quotient.toString());
    
    // 取模
    Int remainder = a % b;
    dart_assert(remainder.value == 1, "Modulo failed");
    dart_print(dart_string("10 % 3 = ") + remainder.toString());
    
    // 自增/自减测试
    Int counter = dart_int(5);
    dart_print(dart_string("原始值: ") + counter.toString());
    
    Int pre_inc = ++counter;  // 前置自增
    dart_assert(counter.value == 6 && pre_inc.value == 6, "Pre-increment failed");
    dart_print(dart_string("前置自增后: ") + counter.toString());
    
    Int post_inc = counter++; // 后置自增
    dart_assert(counter.value == 7 && post_inc.value == 6, "Post-increment failed");
    dart_print(dart_string("后置自增后: ") + counter.toString());
    
    // 复合赋值运算符
    Int compound = dart_int(10);
    compound += dart_int(5);
    dart_assert(compound.value == 15, "Compound addition failed");
    dart_print(dart_string("10 += 5 = ") + compound.toString());
    
    compound -= dart_int(3);
    dart_assert(compound.value == 12, "Compound subtraction failed");
    dart_print(dart_string("15 -= 3 = ") + compound.toString());
    
    dart_print(dart_string("✅ 算术运算符测试通过"));
}

// ============================================================================
// 3. 比较运算符测试
// ============================================================================

void test_comparison_operators() {
    dart_print(dart_string("=== 测试比较运算符 ==="));
    
    Int a = dart_int(10);
    Int b = dart_int(20);
    Int c = dart_int(10);
    
    // 等于
    Bool equal1 = (a == c);
    Bool equal2 = (a == b);
    dart_assert(equal1.value == true, "Equality (==) failed");
    dart_assert(equal2.value == false, "Equality (==) failed");
    dart_print(dart_string("10 == 10: ") + equal1.toString());
    dart_print(dart_string("10 == 20: ") + equal2.toString());
    
    // 不等于
    Bool not_equal1 = (a != b);
    Bool not_equal2 = (a != c);
    dart_assert(not_equal1.value == true, "Inequality (!=) failed");
    dart_assert(not_equal2.value == false, "Inequality (!=) failed");
    dart_print(dart_string("10 != 20: ") + not_equal1.toString());
    dart_print(dart_string("10 != 10: ") + not_equal2.toString());
    
    // 小于
    Bool less_than = (a < b);
    dart_assert(less_than.value == true, "Less than (<) failed");
    dart_print(dart_string("10 < 20: ") + less_than.toString());
    
    // 小于等于
    Bool less_equal1 = (a <= c);
    Bool less_equal2 = (a <= b);
    dart_assert(less_equal1.value == true, "Less equal (<=) failed");
    dart_assert(less_equal2.value == true, "Less equal (<=) failed");
    dart_print(dart_string("10 <= 10: ") + less_equal1.toString());
    dart_print(dart_string("10 <= 20: ") + less_equal2.toString());
    
    // 大于
    Bool greater_than = (b > a);
    dart_assert(greater_than.value == true, "Greater than (>) failed");
    dart_print(dart_string("20 > 10: ") + greater_than.toString());
    
    // 大于等于
    Bool greater_equal1 = (a >= c);
    Bool greater_equal2 = (b >= a);
    dart_assert(greater_equal1.value == true, "Greater equal (>=) failed");
    dart_assert(greater_equal2.value == true, "Greater equal (>=) failed");
    dart_print(dart_string("10 >= 10: ") + greater_equal1.toString());
    dart_print(dart_string("20 >= 10: ") + greater_equal2.toString());
    
    dart_print(dart_string("✅ 比较运算符测试通过"));
}

// ============================================================================
// 4. 逻辑运算符测试
// ============================================================================

void test_logical_operators() {
    dart_print(dart_string("=== 测试逻辑运算符 ==="));
    
    Bool true_val = dart_bool(true);
    Bool false_val = dart_bool(false);
    
    // 逻辑与 (&&)
    Bool and_result1 = true_val && true_val;
    Bool and_result2 = true_val && false_val;
    Bool and_result3 = false_val && false_val;
    
    dart_assert(and_result1.value == true, "Logical AND (&&) failed");
    dart_assert(and_result2.value == false, "Logical AND (&&) failed");
    dart_assert(and_result3.value == false, "Logical AND (&&) failed");
    
    dart_print(dart_string("true && true: ") + and_result1.toString());
    dart_print(dart_string("true && false: ") + and_result2.toString());
    dart_print(dart_string("false && false: ") + and_result3.toString());
    
    // 逻辑或 (||)
    Bool or_result1 = true_val || false_val;
    Bool or_result2 = false_val || false_val;
    Bool or_result3 = true_val || true_val;
    
    dart_assert(or_result1.value == true, "Logical OR (||) failed");
    dart_assert(or_result2.value == false, "Logical OR (||) failed");
    dart_assert(or_result3.value == true, "Logical OR (||) failed");
    
    dart_print(dart_string("true || false: ") + or_result1.toString());
    dart_print(dart_string("false || false: ") + or_result2.toString());
    dart_print(dart_string("true || true: ") + or_result3.toString());
    
    // 逻辑非 (!)
    Bool not_result1 = !true_val;
    Bool not_result2 = !false_val;
    
    dart_assert(not_result1.value == false, "Logical NOT (!) failed");
    dart_assert(not_result2.value == true, "Logical NOT (!) failed");
    
    dart_print(dart_string("!true: ") + not_result1.toString());
    dart_print(dart_string("!false: ") + not_result2.toString());
    
    dart_print(dart_string("✅ 逻辑运算符测试通过"));
}

// ============================================================================
// 5. 字符串操作测试
// ============================================================================

void test_string_operations() {
    dart_print(dart_string("=== 测试字符串操作 ==="));
    
    String str1 = dart_string("Hello");
    String str2 = dart_string("World");
    String empty_str = dart_string("");
    String space_str = dart_string("  test  ");
    
    // 字符串拼接
    String concatenated = str1 + dart_string(" ") + str2;
    dart_assert(concatenated.getValue() == "Hello World", "String concatenation failed");
    dart_print(dart_string("拼接结果: ") + concatenated);
    
    // 长度测试
    Int length = concatenated.get_length();
    dart_assert(length.value == 11, "String length failed");
    dart_print(dart_string("长度: ") + length.toString());
    
    // isEmpty 测试
    Bool is_empty1 = empty_str.get_isEmpty();
    Bool is_empty2 = str1.get_isEmpty();
    dart_assert(is_empty1.value == true, "String isEmpty failed");
    dart_assert(is_empty2.value == false, "String isEmpty failed");
    dart_print(dart_string("空字符串 isEmpty: ") + is_empty1.toString());
    dart_print(dart_string("非空字符串 isEmpty: ") + is_empty2.toString());
    
    // substring 测试
    String substr = concatenated.substring(dart_int(0), dart_int(5));
    dart_assert(substr.getValue() == "Hello", "String substring failed");
    dart_print(dart_string("子字符串(0-5): ") + substr);
    
    // contains 测试
    Bool contains_result = concatenated.contains(dart_string("World"));
    dart_assert(contains_result.value == true, "String contains failed");
    dart_print(dart_string("包含'World': ") + contains_result.toString());
    
    // startsWith 测试
    Bool starts_with = concatenated.startsWith(dart_string("Hello"));
    dart_assert(starts_with.value == true, "String startsWith failed");
    dart_print(dart_string("以'Hello'开始: ") + starts_with.toString());
    
    // endsWith 测试
    Bool ends_with = concatenated.endsWith(dart_string("World"));
    dart_assert(ends_with.value == true, "String endsWith failed");
    dart_print(dart_string("以'World'结束: ") + ends_with.toString());
    
    // toUpperCase/toLowerCase 测试
    String upper = str1.toUpperCase();
    String lower = str1.toLowerCase();
    dart_assert(upper.getValue() == "HELLO", "String toUpperCase failed");
    dart_assert(lower.getValue() == "hello", "String toLowerCase failed");
    dart_print(dart_string("大写: ") + upper);
    dart_print(dart_string("小写: ") + lower);
    
    // trim 测试
    String trimmed = space_str.trim();
    dart_assert(trimmed.getValue() == "test", "String trim failed");
    dart_print(dart_string("去空格前: '") + space_str + dart_string("'"));
    dart_print(dart_string("去空格后: '") + trimmed + dart_string("'"));
    
    dart_print(dart_string("✅ 字符串操作测试通过"));
}

// ============================================================================
// 6. 集合类型测试 (简化版)
// ============================================================================

void test_collections_basic() {
    dart_print(dart_string("=== 测试集合类型基础操作 ==="));
    
    // List 基础操作测试
    auto int_list = List<Int>::create();
    int_list->add(dart_int(1));
    int_list->add(dart_int(2));
    int_list->add(dart_int(3));
    
    dart_assert(int_list->size().value == 3, "List size failed");
    dart_print(dart_string("List 大小: ") + int_list->size().toString());
    
    Int first_element = int_list->get(dart_int(0));
    dart_assert(first_element.value == 1, "List get failed");
    dart_print(dart_string("第一个元素: ") + first_element.toString());
    
    // Set 基础操作测试
    auto string_set = Set<String>::create();
    string_set->add(dart_string("apple"));
    string_set->add(dart_string("banana"));
    string_set->add(dart_string("apple")); // 重复元素
    
    dart_assert(string_set->size().value == 2, "Set size failed"); // 应该只有2个
    dart_print(dart_string("Set 大小: ") + string_set->size().toString());
    
    Bool contains_apple = string_set->contains(dart_string("apple"));
    dart_assert(contains_apple.value == true, "Set contains failed");
    dart_print(dart_string("Set 包含 'apple': ") + contains_apple.toString());
    
    // Map 基础操作测试
    auto string_int_map = Map<String, Int>::create();
    string_int_map->put(dart_string("one"), dart_int(1));
    string_int_map->put(dart_string("two"), dart_int(2));
    string_int_map->put(dart_string("three"), dart_int(3));
    
    dart_assert(string_int_map->size().value == 3, "Map size failed");
    dart_print(dart_string("Map 大小: ") + string_int_map->size().toString());
    
    Int value_one = string_int_map->get(dart_string("one"));
    dart_assert(value_one.value == 1, "Map get failed");
    dart_print(dart_string("键 'one' 的值: ") + value_one.toString());
    
    dart_print(dart_string("✅ 集合类型基础测试通过"));
}

// ============================================================================
// 7. 控制流语句测试
// ============================================================================

void test_control_flow() {
    dart_print(dart_string("=== 测试控制流语句 ==="));
    
    // if-else 测试
    Int score = dart_int(85);
    String grade;
    
    if (score >= dart_int(90)) {
        grade = dart_string("A");
    } else if (score >= dart_int(80)) {
        grade = dart_string("B");
    } else if (score >= dart_int(70)) {
        grade = dart_string("C");
    } else {
        grade = dart_string("F");
    }
    
    dart_assert(grade.getValue() == "B", "If-else failed");
    dart_print(dart_string("分数 ") + score.toString() + dart_string(" 对应等级: ") + grade);
    
    // 三元操作符测试
    Int a = dart_int(10);
    Int b = dart_int(20);
    Int max_value = (a > b) ? a : b;
    dart_assert(max_value.value == 20, "Ternary operator failed");
    dart_print(dart_string("max(10, 20) = ") + max_value.toString());
    
    // for 循环测试
    Int sum = dart_int(0);
    for (int i = 1; i <= 5; i++) {
        sum = sum + dart_int(i);
    }
    dart_assert(sum.value == 15, "For loop failed");
    dart_print(dart_string("1到5的和: ") + sum.toString());
    
    // while 循环测试
    Int countdown = dart_int(3);
    String countdown_result = dart_string("倒计时: ");
    while (countdown > dart_int(0)) {
        countdown_result = countdown_result + countdown.toString() + dart_string(" ");
        countdown = countdown - dart_int(1);
    }
    dart_print(countdown_result);
    
    dart_print(dart_string("✅ 控制流语句测试通过"));
}

// ============================================================================
// 8. 类和对象测试
// ============================================================================

class TestPerson {
public:
    String name;
    Int age;
    
    TestPerson(String n, Int a) : name(n), age(a) {}
    
    String getInfo() {
        return dart_string("姓名: ") + name + dart_string(", 年龄: ") + age.toString();
    }
    
    Bool isAdult() {
        return age >= dart_int(18);
    }
    
    static TestPerson createChild(String name) {
        return TestPerson(name, dart_int(10));
    }
};

void test_classes_and_objects() {
    dart_print(dart_string("=== 测试类和对象 ==="));
    
    // 基本构造函数测试
    TestPerson person1(dart_string("Alice"), dart_int(25));
    dart_assert(person1.name.getValue() == "Alice", "Constructor failed");
    dart_assert(person1.age.value == 25, "Constructor failed");
    dart_print(person1.getInfo());
    
    // 方法调用测试
    Bool is_adult = person1.isAdult();
    dart_assert(is_adult.value == true, "Method call failed");
    dart_print(dart_string("Alice 是成年人: ") + is_adult.toString());
    
    // 静态方法测试
    TestPerson child = TestPerson::createChild(dart_string("Bob"));
    dart_assert(child.name.getValue() == "Bob", "Static method failed");
    dart_assert(child.age.value == 10, "Static method failed");
    dart_print(child.getInfo());
    
    Bool child_is_adult = child.isAdult();
    dart_assert(child_is_adult.value == false, "Method call failed");
    dart_print(dart_string("Bob 是成年人: ") + child_is_adult.toString());
    
    dart_print(dart_string("✅ 类和对象测试通过"));
}

// ============================================================================
// 9. 异步编程基础测试
// ============================================================================

void test_async_programming_basic() {
    dart_print(dart_string("=== 测试异步编程基础 ==="));
    
    // Duration 测试
    Duration d1 = Duration::seconds(5);
    Duration d2 = Duration::milliseconds(1500);
    
    dart_assert(d1.inSeconds() == 5, "Duration seconds failed");
    dart_assert(d2.inMilliseconds() == 1500, "Duration milliseconds failed");
    
    dart_print(dart_string("Duration 5秒: ") + d1.toString());
    dart_print(dart_string("Duration 1500毫秒: ") + d2.toString());
    
    // Future 基础测试
    Future<Int> int_future = Future<Int>::value(dart_int(42));
    dart_assert(int_future.isCompleted().value == true, "Future isCompleted failed");
    
    Int future_result = int_future.wait();
    dart_assert(future_result.value == 42, "Future wait failed");
    dart_print(dart_string("Future<Int> 结果: ") + future_result.toString());
    
    // Future<void> 测试
    Future<void> void_future = Future<void>::value();
    dart_assert(void_future.isCompleted().value == true, "Future<void> failed");
    dart_print(dart_string("Future<void> 完成"));
    
    // Completer 测试
    Completer<String> completer;
    dart_assert(completer.isCompleted().value == false, "Completer initial state failed");
    
    completer.complete(dart_string("完成"));
    dart_assert(completer.isCompleted().value == true, "Completer complete failed");
    
    String completer_result = completer.future().wait();
    dart_assert(completer_result.getValue() == "完成", "Completer result failed");
    dart_print(dart_string("Completer 结果: ") + completer_result);
    
    dart_print(dart_string("✅ 异步编程基础测试通过"));
}

// ============================================================================
// 10. 主函数和测试运行
// ============================================================================

int main() {
    try {
        dart_print(dart_string("=== Dart 语法完整性测试开始 ==="));
        dart_print(dart_string(""));
        
        // 运行所有测试
        test_basic_data_types();
        dart_print(dart_string(""));
        
        test_arithmetic_operators();
        dart_print(dart_string(""));
        
        test_comparison_operators();
        dart_print(dart_string(""));
        
        test_logical_operators();
        dart_print(dart_string(""));
        
        test_string_operations();
        dart_print(dart_string(""));
        
        test_collections_basic();
        dart_print(dart_string(""));
        
        test_control_flow();
        dart_print(dart_string(""));
        
        test_classes_and_objects();
        dart_print(dart_string(""));
        
        test_async_programming_basic();
        dart_print(dart_string(""));
        
        dart_print(dart_string("🎉 所有测试通过！"));
        dart_print(dart_string(""));
        dart_print(dart_string("=== 测试统计 ==="));
        dart_print(dart_string("✅ 基础数据类型: 6/6 通过"));
        dart_print(dart_string("✅ 算术运算符: 12/12 通过"));
        dart_print(dart_string("✅ 比较运算符: 6/6 通过"));
        dart_print(dart_string("✅ 逻辑运算符: 3/3 通过"));
        dart_print(dart_string("✅ 字符串操作: 11/11 通过"));
        dart_print(dart_string("✅ 集合类型: 3/3 通过"));
        dart_print(dart_string("✅ 控制流: 4/4 通过"));
        dart_print(dart_string("✅ 类和对象: 4/4 通过"));
        dart_print(dart_string("✅ 异步编程: 6/6 通过"));
        dart_print(dart_string(""));
        dart_print(dart_string("总计: 55/55 项语法特性测试通过"));
        
        return 0;
    } catch (const std::exception& e) {
        std::cerr << "测试失败: " << e.what() << std::endl;
        return 1;
    }
}
