// Comprehensive Test for Dart2CPP Runtime Library
// This program tests all supported Dart language features

#include "dart2cpp.h"
#include <iostream>

// ============================================================================
// 测试计数器
// ============================================================================
int total_tests = 0;
int passed_tests = 0;
int failed_tests = 0;

void test_start(const char* name) {
    std::cout << "\n[TEST] " << name << "..." << std::endl;
    total_tests++;
}

void test_pass() {
    std::cout << "  ✓ PASSED" << std::endl;
    passed_tests++;
}

void test_fail(const char* reason) {
    std::cout << "  ✗ FAILED: " << reason << std::endl;
    failed_tests++;
}

// ============================================================================
// 1. 基础类型测试
// ============================================================================
void test_basic_types() {
    test_start("基础类型 - int");
    Int x = Int(42);
    if (x.toInt() == 42) test_pass(); else test_fail("int value mismatch");
    
    test_start("基础类型 - double");
    Double y = Double(3.14);
    if (y.toDouble() > 3.13 && y.toDouble() < 3.15) test_pass(); else test_fail("double value mismatch");
    
    test_start("基础类型 - bool");
    Bool b1 = Bool(true);
    Bool b2 = Bool(false);
    if (b1.toBool() && !b2.toBool()) test_pass(); else test_fail("bool value mismatch");
    
    test_start("基础类型 - String");
    String s = String("Hello");
    if (s.getValue() == "Hello") test_pass(); else test_fail("string value mismatch");
}

// ============================================================================
// 2. 算术运算测试
// ============================================================================
void test_arithmetic() {
    test_start("算术运算 - 加法");
    Int a = Int(10);
    Int b = Int(5);
    Int sum = a + b;
    if (sum.toInt() == 15) test_pass(); else test_fail("addition failed");
    
    test_start("算术运算 - 减法");
    Int diff = a - b;
    if (diff.toInt() == 5) test_pass(); else test_fail("subtraction failed");
    
    test_start("算术运算 - 乘法");
    Int prod = a * b;
    if (prod.toInt() == 50) test_pass(); else test_fail("multiplication failed");
    
    test_start("算术运算 - 除法");
    Int quot = a / b;
    if (quot.toInt() == 2) test_pass(); else test_fail("division failed");
    
    test_start("算术运算 - 取模");
    Int rem = a % b;
    if (rem.toInt() == 0) test_pass(); else test_fail("modulo failed");
}

// ============================================================================
// 3. 比较运算测试
// ============================================================================
void test_comparison() {
    Int x = Int(10);
    Int y = Int(5);
    
    test_start("比较运算 - 等于");
    if ((x == Int(10)).toBool()) test_pass(); else test_fail("equals failed");
    
    test_start("比较运算 - 不等于");
    if ((x != y).toBool()) test_pass(); else test_fail("not equals failed");
    
    test_start("比较运算 - 大于");
    if ((x > y).toBool()) test_pass(); else test_fail("greater than failed");
    
    test_start("比较运算 - 小于");
    if ((y < x).toBool()) test_pass(); else test_fail("less than failed");
    
    test_start("比较运算 - 大于等于");
    if ((x >= Int(10)).toBool()) test_pass(); else test_fail("greater or equal failed");
    
    test_start("比较运算 - 小于等于");
    if ((y <= Int(10)).toBool()) test_pass(); else test_fail("less or equal failed");
}

// ============================================================================
// 4. 逻辑运算测试
// ============================================================================
void test_logical() {
    Bool t = Bool(true);
    Bool f = Bool(false);
    
    test_start("逻辑运算 - AND");
    if ((t && t).toBool() && !(t && f).toBool()) test_pass(); else test_fail("AND failed");
    
    test_start("逻辑运算 - OR");
    if ((t || f).toBool() && !(f || f).toBool()) test_pass(); else test_fail("OR failed");
    
    test_start("逻辑运算 - NOT");
    if ((!f).toBool() && !(!t).toBool()) test_pass(); else test_fail("NOT failed");
}

// ============================================================================
// 5. 字符串操作测试
// ============================================================================
void test_string_operations() {
    test_start("字符串 - 连接");
    String s1 = String("Hello");
    String s2 = String("World");
    String s3 = s1 + String(" ") + s2;
    if (s3.getValue() == "Hello World") test_pass(); else test_fail("concat failed");
    
    test_start("字符串 - 长度");
    if (s3.get_length().toInt() == 11) test_pass(); else test_fail("length failed");
    
    test_start("字符串 - 大写");
    String upper = s1.toUpperCase();
    if (upper.getValue() == "HELLO") test_pass(); else test_fail("toUpperCase failed");
    
    test_start("字符串 - 小写");
    String lower = upper.toLowerCase();
    if (lower.getValue() == "hello") test_pass(); else test_fail("toLowerCase failed");
    
    test_start("字符串 - 包含");
    if (s3.contains(String("World")).toBool()) test_pass(); else test_fail("contains failed");
    
    test_start("字符串 - trim");
    String padded = String("  text  ");
    String trimmed = padded.trim();
    if (trimmed.getValue() == "text") test_pass(); else test_fail("trim failed");
}

// ============================================================================
// 6. List 操作测试
// ============================================================================
void test_list_operations() {
    test_start("List - 创建和添加");
    ObjectPtr<List<Int>> list = List<Int>::create();
    list->add(Int(1));
    list->add(Int(2));
    list->add(Int(3));
    if (list->size().toInt() == 3) test_pass(); else test_fail("list add failed");
    
    test_start("List - 访问元素");
    Int first = list->get(Int(0));
    if (first.toInt() == 1) test_pass(); else test_fail("list get failed");
    
    test_start("List - 包含");
    if (list->contains(Int(2)).toBool()) test_pass(); else test_fail("list contains failed");
    
    test_start("List - 索引查找");
    Int idx = list->indexOf(Int(3));
    if (idx.toInt() == 2) test_pass(); else test_fail("list indexOf failed");
    
    test_start("List - 移除元素");
    list->remove(Int(1));
    if (list->size().toInt() == 2) test_pass(); else test_fail("list remove failed");
}

// ============================================================================
// 7. Set 操作测试
// ============================================================================
void test_set_operations() {
    test_start("Set - 创建和添加");
    ObjectPtr<Set<Int>> set = Set<Int>::create();
    set->add(Int(1));
    set->add(Int(2));
    set->add(Int(1)); // 重复添加
    if (set->size().toInt() == 2) test_pass(); else test_fail("set add failed");
    
    test_start("Set - 包含");
    if (set->contains(Int(1)).toBool()) test_pass(); else test_fail("set contains failed");
    
    test_start("Set - 移除");
    set->remove(Int(1));
    if (!set->contains(Int(1)).toBool()) test_pass(); else test_fail("set remove failed");
}

// ============================================================================
// 8. Map 操作测试
// ============================================================================
void test_map_operations() {
    test_start("Map - 创建和添加");
    ObjectPtr<Map<String, Int>> map = Map<String, Int>::create();
    map->put(String("one"), Int(1));
    map->put(String("two"), Int(2));
    if (map->size().toInt() == 2) test_pass(); else test_fail("map put failed");
    
    test_start("Map - 获取值");
    Int val = map->get(String("one"));
    if (val.toInt() == 1) test_pass(); else test_fail("map get failed");
    
    test_start("Map - 包含键");
    if (map->containsKey(String("two")).toBool()) test_pass(); else test_fail("map containsKey failed");
    
    test_start("Map - 移除");
    map->remove(String("one"));
    if (!map->containsKey(String("one")).toBool()) test_pass(); else test_fail("map remove failed");
}

// ============================================================================
// 9. 自增自减测试
// ============================================================================
void test_increment_decrement() {
    test_start("自增自减 - 前置自增");
    Int x = Int(5);
    ++x;
    if (x.toInt() == 6) test_pass(); else test_fail("prefix increment failed");
    
    test_start("自增自减 - 后置自增");
    Int y = Int(5);
    y++;
    if (y.toInt() == 6) test_pass(); else test_fail("postfix increment failed");
    
    test_start("自增自减 - 前置自减");
    Int z = Int(5);
    --z;
    if (z.toInt() == 4) test_pass(); else test_fail("prefix decrement failed");
}

// ============================================================================
// 10. 复合赋值测试
// ============================================================================
void test_compound_assignment() {
    test_start("复合赋值 - +=");
    Int x = Int(10);
    x += Int(5);
    if (x.toInt() == 15) test_pass(); else test_fail("+= failed");
    
    test_start("复合赋值 - -=");
    Int y = Int(10);
    y -= Int(3);
    if (y.toInt() == 7) test_pass(); else test_fail("-= failed");
    
    test_start("复合赋值 - *=");
    Int z = Int(10);
    z *= Int(2);
    if (z.toInt() == 20) test_pass(); else test_fail("*= failed");
}

// ============================================================================
// 11. 自定义类测试
// ============================================================================
class TestPerson : public Object {
public:
    String name;
    Int age;
    
    TestPerson(const String& n, const Int& a) : name(n), age(a) {
        type_id = 1000;
    }
    
    String toString() const override {
        return String("TestPerson(") + name + String(", ") + age.toString() + String(")");
    }
    
    String greet() const {
        return String("Hello, I'm ") + name;
    }
};

void test_custom_class() {
    test_start("自定义类 - 创建和访问");
    ObjectPtr<TestPerson> person = ObjectPtr<TestPerson>(
        new TestPerson(String("Alice"), Int(25))
    );
    if (person->name.getValue() == "Alice") test_pass(); else test_fail("custom class field access failed");
    
    test_start("自定义类 - 方法调用");
    String greeting = person->greet();
    if (greeting.getValue() == "Hello, I'm Alice") test_pass(); else test_fail("custom class method failed");
    
    test_start("自定义类 - toString");
    String str = person->toString();
    if (str.contains(String("Alice")).toBool()) test_pass(); else test_fail("custom class toString failed");
}

// ============================================================================
// 12. ObjectPtr 智能指针测试
// ============================================================================
void test_smart_pointer() {
    test_start("智能指针 - 自动内存管理");
    {
        ObjectPtr<List<Int>> list = List<Int>::create();
        list->add(Int(42));
        // 离开作用域自动释放
    }
    test_pass(); // 如果没有崩溃就通过
    
    test_start("智能指针 - 空值检查");
    ObjectPtr<List<Int>> null_ptr;
    if (null_ptr.isNull()) test_pass(); else test_fail("null check failed");
}

// ============================================================================
// 13. 类型转换测试
// ============================================================================
void test_type_conversion() {
    test_start("类型转换 - Int to Double");
    Int i = Int(42);
    Double d = i.toDouble();
    if (d.toDouble() == 42.0) test_pass(); else test_fail("int to double failed");
    
    test_start("类型转换 - Double to Int");
    Double d2 = Double(3.14);
    Int i2 = d2.toInt();
    if (i2.toInt() == 3) test_pass(); else test_fail("double to int failed");
    
    test_start("类型转换 - toString");
    Int num = Int(123);
    String str = num.toString();
    if (str.getValue() == "123") test_pass(); else test_fail("toString failed");
}

// ============================================================================
// 14. 数学运算测试
// ============================================================================
void test_math_operations() {
    test_start("数学运算 - abs");
    Int negative = Int(-10);
    Int positive = negative.abs();
    if (positive.toInt() == 10) test_pass(); else test_fail("abs failed");
    
    test_start("数学运算 - max");
    Int a = Int(10);
    Int b = Int(20);
    Int max_val = DartMath::max(a, b);
    if (max_val.toInt() == 20) test_pass(); else test_fail("max failed");
    
    test_start("数学运算 - min");
    Int min_val = DartMath::min(a, b);
    if (min_val.toInt() == 10) test_pass(); else test_fail("min failed");
}

// ============================================================================
// 15. 条件判断测试
// ============================================================================
void test_conditionals() {
    test_start("条件判断 - if 语句");
    Int x = Int(10);
    bool condition_passed = false;
    if (x > Int(5)) {
        condition_passed = true;
    }
    if (condition_passed) test_pass(); else test_fail("if statement failed");
    
    test_start("条件判断 - 三元运算符");
    Int y = (x > Int(5)).toBool() ? Int(1) : Int(0);
    if (y.toInt() == 1) test_pass(); else test_fail("ternary operator failed");
}

// ============================================================================
// 主函数
// ============================================================================
int main() {
    std::cout << "=========================================" << std::endl;
    std::cout << "  Dart2CPP 全面测试" << std::endl;
    std::cout << "=========================================" << std::endl;
    
    // 运行所有测试
    test_basic_types();
    test_arithmetic();
    test_comparison();
    test_logical();
    test_string_operations();
    test_list_operations();
    test_set_operations();
    test_map_operations();
    test_increment_decrement();
    test_compound_assignment();
    test_custom_class();
    test_smart_pointer();
    test_type_conversion();
    test_math_operations();
    test_conditionals();
    
    // 显示测试结果
    std::cout << "\n=========================================" << std::endl;
    std::cout << "  测试结果" << std::endl;
    std::cout << "=========================================" << std::endl;
    std::cout << "总测试数: " << total_tests << std::endl;
    std::cout << "通过: " << passed_tests << " ✓" << std::endl;
    std::cout << "失败: " << failed_tests << " ✗" << std::endl;
    std::cout << "成功率: " << (passed_tests * 100 / total_tests) << "%" << std::endl;
    std::cout << "=========================================" << std::endl;
    
    return failed_tests > 0 ? 1 : 0;
}

