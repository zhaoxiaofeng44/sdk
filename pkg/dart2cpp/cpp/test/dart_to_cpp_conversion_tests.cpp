#include "../pkg/dart2bytecode/base/object.h"
#include "../pkg/dart2bytecode/base/object.cpp"
#include "../pkg/dart2bytecode/base/object_extensions_simple.h"
#include "../pkg/dart2bytecode/base/dart_async_simple.h"
#include "../pkg/dart2bytecode/base/dart_syntax_simple.h"
#include <iostream>
#include <cassert>

// ============================================================================
// Dart to C++ Conversion Test Suite
// ============================================================================

int test_count = 0;
int test_passed = 0;

#define TEST_START(name) \
    std::cout << "\n[TEST] " << name << std::endl; \
    test_count++;

#define TEST_ASSERT(condition, message) \
    if (condition) { \
        std::cout << "  ✓ " << message << std::endl; \
        test_passed++; \
    } else { \
        std::cout << "  ✗ " << message << " FAILED" << std::endl; \
    }

// ============================================================================
// Test 1: 基本类型转换
// ============================================================================

void test_basic_types() {
    TEST_START("Basic Type Conversion");
    
    // Dart: var x = 5;
    auto x = Int(5);
    TEST_ASSERT(x.toInt() == 5, "Int construction");
    
    // Dart: double y = 3.14;
    Double y = Double(3.14);
    TEST_ASSERT(y.toDouble() > 3.13 && y.toDouble() < 3.15, "Double construction");
    
    // Dart: bool flag = true;
    Bool flag = Bool(true);
    TEST_ASSERT(flag.toBool() == true, "Bool construction");
    
    // Dart: String name = "Dart";
    String name = String("Dart");
    TEST_ASSERT(name == "Dart", "String construction");
}

// ============================================================================
// Test 2: 算术运算符转换
// ============================================================================

void test_arithmetic_operators() {
    TEST_START("Arithmetic Operators");
    
    Int a(10);
    Int b(3);
    
    // Dart: a + b
    TEST_ASSERT((a + b).toInt() == 13, "Addition");
    
    // Dart: a - b
    TEST_ASSERT((a - b).toInt() == 7, "Subtraction");
    
    // Dart: a * b
    TEST_ASSERT((a * b).toInt() == 30, "Multiplication");
    
    // Dart: a / b (integer division in Dart context)
    TEST_ASSERT((a / b).toInt() == 3, "Division");
    
    // Dart: a % b
    TEST_ASSERT((a % b).toInt() == 1, "Modulo");
    
    // Dart: a ~/ b
    TEST_ASSERT(a.integerDivision(b).toInt() == 3, "Integer division");
    
    // Dart: -a
    TEST_ASSERT((a.operator_unary_minus()).toInt() == -10, "Unary minus");
}

// ============================================================================
// Test 3: 比较运算符转换
// ============================================================================

void test_comparison_operators() {
    TEST_START("Comparison Operators");
    
    Int a(10);
    Int b(20);
    Int c(10);
    
    // Dart: a == c
    TEST_ASSERT((a == c).toBool() == true, "Equality");
    
    // Dart: a != b
    TEST_ASSERT((a != b).toBool() == true, "Inequality");
    
    // Dart: a < b
    TEST_ASSERT((a < b).toBool() == true, "Less than");
    
    // Dart: b > a
    TEST_ASSERT((b > a).toBool() == true, "Greater than");
    
    // Dart: a <= c
    TEST_ASSERT((a <= c).toBool() == true, "Less than or equal");
    
    // Dart: b >= a
    TEST_ASSERT((b >= a).toBool() == true, "Greater than or equal");
}

// ============================================================================
// Test 4: 逻辑运算符转换
// ============================================================================

void test_logical_operators() {
    TEST_START("Logical Operators");
    
    Bool t = Bool(true);
    Bool f = Bool(false);
    
    // Dart: t && f
    TEST_ASSERT((t && f).toBool() == false, "Logical AND");
    
    // Dart: t || f
    TEST_ASSERT((t || f).toBool() == true, "Logical OR");
    
    // Dart: !t
    TEST_ASSERT((!t).toBool() == false, "Logical NOT");
    
    // Dart: t && t
    TEST_ASSERT((t && t).toBool() == true, "AND both true");
}

// ============================================================================
// Test 5: 自增自减运算符转换
// ============================================================================

void test_increment_decrement() {
    TEST_START("Increment/Decrement Operators");
    
    Int x(5);
    
    // Dart: ++x
    ++x;
    TEST_ASSERT(x.toInt() == 6, "Pre-increment");
    
    // Dart: x++
    x++;
    TEST_ASSERT(x.toInt() == 7, "Post-increment");
    
    // Dart: --x
    --x;
    TEST_ASSERT(x.toInt() == 6, "Pre-decrement");
    
    // Dart: x--
    x--;
    TEST_ASSERT(x.toInt() == 5, "Post-decrement");
}

// ============================================================================
// Test 6: 复合赋值运算符转换
// ============================================================================

void test_compound_assignment() {
    TEST_START("Compound Assignment Operators");
    
    Int x(10);
    
    // Dart: x += 5
    x += Int(5);
    TEST_ASSERT(x.toInt() == 15, "Add assignment");
    
    // Dart: x -= 3
    x -= Int(3);
    TEST_ASSERT(x.toInt() == 12, "Subtract assignment");
    
    // Dart: x *= 2
    x *= Int(2);
    TEST_ASSERT(x.toInt() == 24, "Multiply assignment");
    
    // Dart: x /= 4
    x /= Int(4);
    TEST_ASSERT(x.toInt() == 6, "Divide assignment");
    
    // Dart: x %= 4
    x %= Int(4);
    TEST_ASSERT(x.toInt() == 2, "Modulo assignment");
}

// ============================================================================
// Test 7: 位运算符转换
// ============================================================================

void test_bitwise_operators() {
    TEST_START("Bitwise Operators");
    
    Int a(12);  // 1100 in binary
    Int b(10);  // 1010 in binary
    
    // Dart: a & b
    TEST_ASSERT(a.operator_bitwise_and(b).toInt() == 8, "Bitwise AND");
    
    // Dart: a | b
    TEST_ASSERT(a.operator_bitwise_or(b).toInt() == 14, "Bitwise OR");
    
    // Dart: a ^ b
    TEST_ASSERT(a.operator_bitwise_xor(b).toInt() == 6, "Bitwise XOR");
    
    // Dart: ~a
    TEST_ASSERT(a.operator_bitwise_not().toInt() == ~12, "Bitwise NOT");
    
    // Dart: a << 1
    TEST_ASSERT(a.operator_shift_left(Int(1)).toInt() == 24, "Left shift");
    
    // Dart: a >> 1
    TEST_ASSERT(a.operator_shift_right(Int(1)).toInt() == 6, "Right shift");
    
    // Dart: a >>> 1
    TEST_ASSERT(dart_unsigned_shift_right(a, Int(1)).toInt() == 6, "Unsigned right shift");
}

// ============================================================================
// Test 8: 字符串操作转换
// ============================================================================

void test_string_operations() {
    TEST_START("String Operations");
    
    String s1("Hello");
    String s2("World");
    
    // Dart: s1 + " " + s2
    String result = s1 + String(" ") + s2;
    TEST_ASSERT(result == "Hello World", "String concatenation");
    
    // Dart: s1.length
    TEST_ASSERT(s1.get_length().toInt() == 5, "String length");
    
    // Dart: s1.isEmpty
    TEST_ASSERT(s1.get_isEmpty().toBool() == false, "String isEmpty");
    
    // Dart: "".isEmpty
    TEST_ASSERT(String("").get_isEmpty().toBool() == true, "Empty string");
    
    // Dart: s1.contains("ell")
    TEST_ASSERT(s1.contains(String("ell")).toBool() == true, "String contains");
    
    // Dart: s1.substring(1, 4)
    TEST_ASSERT(s1.substring(Int(1), Int(4)) == "ell", "Substring");
    
    // Dart: s1.toUpperCase()
    TEST_ASSERT(s1.toUpperCase() == "HELLO", "toUpperCase");
    
    // Dart: s1.toLowerCase()
    TEST_ASSERT(s1.toLowerCase() == "hello", "toLowerCase");
}

// ============================================================================
// Test 9: List集合转换
// ============================================================================

void test_list_collection() {
    TEST_START("List Collection");
    
    // Dart: List<int> list = [];
    ObjectPtr<List<Int>> list = List<Int>::create();
    
    // Dart: list.add(1); list.add(2); list.add(3);
    list->add(Int(1));
    list->add(Int(2));
    list->add(Int(3));
    
    // Dart: list.length
    TEST_ASSERT(list->size().toInt() == 3, "List size");
    
    // Dart: list[0]
    TEST_ASSERT(list->get(Int(0)).toInt() == 1, "List access");
    
    // Dart: list.contains(2)
    TEST_ASSERT(list->contains(Int(2)).toBool() == true, "List contains");
    
    // Dart: list.indexOf(3)
    TEST_ASSERT(list->indexOf(Int(3)).toInt() == 2, "List indexOf");
    
    // Dart: list.isEmpty
    TEST_ASSERT(list->isEmpty().toBool() == false, "List isEmpty");
    
    // Dart: list.remove(1)
    list->remove(Int(1));
    TEST_ASSERT(list->size().toInt() == 2, "List remove");
}

// ============================================================================
// Test 10: Set集合转换
// ============================================================================

void test_set_collection() {
    TEST_START("Set Collection");
    
    // Dart: Set<int> set = {};
    ObjectPtr<Set<Int>> set = Set<Int>::create();
    
    // Dart: set.add(1); set.add(2); set.add(2);
    set->add(Int(1));
    set->add(Int(2));
    set->add(Int(2)); // Duplicate
    
    // Dart: set.length (should be 2, not 3)
    TEST_ASSERT(set->size().toInt() == 2, "Set size (no duplicates)");
    
    // Dart: set.contains(1)
    TEST_ASSERT(set->contains(Int(1)).toBool() == true, "Set contains");
    
    // Dart: set.contains(3)
    TEST_ASSERT(set->contains(Int(3)).toBool() == false, "Set not contains");
    
    // Dart: set.remove(1)
    set->remove(Int(1));
    TEST_ASSERT(set->size().toInt() == 1, "Set remove");
}

// ============================================================================
// Test 11: Map集合转换
// ============================================================================

void test_map_collection() {
    TEST_START("Map Collection");
    
    // Dart: Map<String, int> map = {};
    ObjectPtr<Map<String, Int>> map = Map<String, Int>::create();
    
    // Dart: map["one"] = 1; map["two"] = 2;
    map->put(String("one"), Int(1));
    map->put(String("two"), Int(2));
    
    // Dart: map.length
    TEST_ASSERT(map->size().toInt() == 2, "Map size");
    
    // Dart: map["one"]
    TEST_ASSERT(map->get(String("one")).toInt() == 1, "Map get");
    
    // Dart: map.containsKey("two")
    TEST_ASSERT(map->containsKey(String("two")).toBool() == true, "Map containsKey");
    
    // Dart: map.containsKey("three")
    TEST_ASSERT(map->containsKey(String("three")).toBool() == false, "Map not containsKey");
    
    // Dart: map.remove("one")
    map->remove(String("one"));
    TEST_ASSERT(map->size().toInt() == 1, "Map remove");
}

// ============================================================================
// Test 12: 控制流转换 - if语句
// ============================================================================

void test_control_flow_if() {
    TEST_START("Control Flow - if statement");
    
    Bool condition = Bool(true);
    Int result(0);
    
    // Dart: if (condition) { result = 1; }
    if (condition) {
        result = Int(1);
    }
    TEST_ASSERT(result.toInt() == 1, "if statement");
    
    // Dart: if (!condition) { result = 2; } else { result = 3; }
    if (!condition) {
        result = Int(2);
    } else {
        result = Int(3);
    }
    TEST_ASSERT(result.toInt() == 3, "if-else statement");
    
    // Dart: var x = condition ? 10 : 20;
    auto x = condition ? Int(10) : Int(20);
    TEST_ASSERT(x.toInt() == 10, "Ternary operator");
}

// ============================================================================
// Test 13: 控制流转换 - 循环
// ============================================================================

void test_control_flow_loops() {
    TEST_START("Control Flow - loops");
    
    // Dart: for (int i = 0; i < 5; i++)
    Int sum(0);
    for (Int i(0); i < Int(5); ++i) {
        sum += i;
    }
    TEST_ASSERT(sum.toInt() == 10, "for loop");
    
    // Dart: while (condition)
    Int count(0);
    Bool condition = Bool(true);
    while (condition) {
        ++count;
        if (count >= Int(3)) {
            condition = Bool(false);
        }
    }
    TEST_ASSERT(count.toInt() == 3, "while loop");
    
    // Dart: for (var item in list)
    ObjectPtr<List<Int>> list = List<Int>::create();
    list->add(Int(1));
    list->add(Int(2));
    list->add(Int(3));
    
    Int total(0);
    dart_for_each(Int, item, list)
        total += item;
    dart_end_for
    TEST_ASSERT(total.toInt() == 6, "for-in loop (dart_for_each)");
}

// ============================================================================
// Test 14: 类型转换
// ============================================================================

void test_type_conversions() {
    TEST_START("Type Conversions");
    
    // Dart: int.toString()
    Int x(42);
    TEST_ASSERT(x.toString() == "42", "Int to String");
    
    // Dart: double.toString()
    Double y(3.14);
    String y_str = y.toString();
    TEST_ASSERT(y_str.contains(String("3.14")).toBool(), "Double to String");
    
    // Dart: int.parse("123")
    String s = String("123");
    Int parsed = dart_parse_int(s);
    TEST_ASSERT(parsed.toInt() == 123, "String to Int");
    
    // Dart: double.parse("3.14")
    String ds = String("3.14");
    Double dparsed = dart_parse_double(ds);
    TEST_ASSERT(dparsed.toDouble() > 3.13 && dparsed.toDouble() < 3.15, "String to Double");
    
    // Dart: int.toDouble()
    Int i(5);
    Double d = i.toDouble();
    TEST_ASSERT(d.toDouble() == 5.0, "Int to Double");
}

// ============================================================================
// Test 15: 空值处理
// ============================================================================

void test_null_handling() {
    TEST_START("Null Handling");
    
    // Dart: int? nullable = null;
    ObjectPtr<Int> nullable;
    TEST_ASSERT(nullable.isNull(), "Null check");
    
    // Dart: nullable = 5;
    nullable = ObjectPtr<Int>(new Int(5));
    TEST_ASSERT(nullable.isNotNull(), "Non-null check");
    
    // Dart: nullable ?? 10
    ObjectPtr<Int> null_value;
    Int result = dart_null_coalesce(null_value, Int(10));
    TEST_ASSERT(result.toInt() == 10, "Null coalescing with null");
    
    ObjectPtr<Int> non_null_value(new Int(5));
    Int result2 = dart_null_coalesce(non_null_value, Int(10));
    TEST_ASSERT(result2.toInt() == 5, "Null coalescing with value");
}

// ============================================================================
// Test 16: Future异步转换（简化版）
// ============================================================================

void test_future_async() {
    TEST_START("Future Async (Simplified)");
    
    // Dart: Future<int> f = Future.value(42);
    Future<Int> f = Future<Int>::value(Int(42));
    
    // Dart: await f;
    Int result = f.wait();
    TEST_ASSERT(result.toInt() == 42, "Future.value and wait");
    
    // Dart: Future<void> fv = Future.value();
    Future<void> fv = Future<void>::value();
    fv.wait();
    TEST_ASSERT(true, "Future<void> completion");
}

// ============================================================================
// Test 17: 字符串分割
// ============================================================================

void test_string_split() {
    TEST_START("String Split");
    
    // Dart: "a,b,c".split(",")
    String s = String("a,b,c");
    ObjectPtr<List<String>> parts = dart_split(s, String(","));
    
    TEST_ASSERT(parts->size().toInt() == 3, "Split result size");
    TEST_ASSERT(parts->get(Int(0)) == "a", "Split part 0");
    TEST_ASSERT(parts->get(Int(1)) == "b", "Split part 1");
    TEST_ASSERT(parts->get(Int(2)) == "c", "Split part 2");
}

// ============================================================================
// Test 18: List迭代器
// ============================================================================

void test_list_iterator() {
    TEST_START("List Iterator");
    
    ObjectPtr<List<Int>> list = List<Int>::create();
    list->add(Int(10));
    list->add(Int(20));
    list->add(Int(30));
    
    // Dart: for (var item in list)
    ListIterator<Int> it = list->iterator();
    Int sum(0);
    while (it.hasNext()) {
        sum += it.next();
    }
    TEST_ASSERT(sum.toInt() == 60, "Iterator traversal");
}

// ============================================================================
// Test 19: 复杂表达式
// ============================================================================

void test_complex_expressions() {
    TEST_START("Complex Expressions");
    
    // Dart: (5 + 3) * 2 - 10 / 2
    Int result = (Int(5) + Int(3)) * Int(2) - Int(10) / Int(2);
    TEST_ASSERT(result.toInt() == 11, "Complex arithmetic");
    
    // Dart: (a > 5 && b < 10) || c == 0
    Int a(6), b(8), c(0);
    Bool complex_condition = (a > Int(5) && b < Int(10)) || c == Int(0);
    TEST_ASSERT(complex_condition.toBool() == true, "Complex logical expression");
}

// ============================================================================
// Test 20: 字符串模板（手动拼接）
// ============================================================================

void test_string_templates() {
    TEST_START("String Templates (Manual)");
    
    // Dart: "Value is ${x}"
    Int x(42);
    String message = String("Value is ") + x.toString();
    TEST_ASSERT(message == "Value is 42", "String interpolation (manual)");
    
    // Dart: "Sum of ${a} and ${b} is ${a+b}"
    Int a(5), b(3);
    String result = String("Sum of ") + a.toString() + String(" and ") + 
                    b.toString() + String(" is ") + (a + b).toString();
    TEST_ASSERT(result == "Sum of 5 and 3 is 8", "Complex string interpolation");
}

// ============================================================================
// Test 21: Bool隐式转换
// ============================================================================

void test_bool_implicit_conversion() {
    TEST_START("Bool Implicit Conversion");
    
    Bool b = Bool(true);
    
    // 直接在if中使用（隐式转换）
    bool worked = false;
    if (b) {
        worked = true;
    }
    TEST_ASSERT(worked, "Bool implicit conversion in if");
    
    // 在while中使用
    Int count(0);
    Bool condition = Bool(true);
    while (condition) {
        ++count;
        if (count >= Int(2)) {
            condition = Bool(false);
        }
    }
    TEST_ASSERT(count.toInt() == 2, "Bool implicit conversion in while");
}

// ============================================================================
// Test 22: 对象引用计数
// ============================================================================

void test_object_refcount() {
    TEST_START("Object Reference Counting");
    
    ObjectPtr<List<Int>> list1 = List<Int>::create();
    int initial_count = list1.get()->getRefCount();
    TEST_ASSERT(initial_count >= 1, "Initial ref count");
    
    // Copy constructor
    ObjectPtr<List<Int>> list2 = list1;
    int after_copy = list1.get()->getRefCount();
    TEST_ASSERT(after_copy == initial_count + 1, "Ref count after copy");
    
    // Assignment
    ObjectPtr<List<Int>> list3;
    list3 = list1;
    int after_assign = list1.get()->getRefCount();
    TEST_ASSERT(after_assign == initial_count + 2, "Ref count after assignment");
}

// ============================================================================
// Test 23: 数学运算
// ============================================================================

void test_math_operations() {
    TEST_START("Math Operations");
    
    // abs
    Int negative(-5);
    TEST_ASSERT(negative.abs().toInt() == 5, "Int abs");
    
    Double d_negative(-3.5);
    TEST_ASSERT(d_negative.abs().toDouble() > 3.4 && d_negative.abs().toDouble() < 3.6, "Double abs");
    
    // min/max
    TEST_ASSERT(DartMath::min(Int(5), Int(10)).toInt() == 5, "Int min");
    TEST_ASSERT(DartMath::max(Int(5), Int(10)).toInt() == 10, "Int max");
}

// ============================================================================
// Test 24: 字符串其他操作
// ============================================================================

void test_string_advanced() {
    TEST_START("String Advanced Operations");
    
    String s = String("  hello  ");
    
    // trim
    TEST_ASSERT(s.trim() == "hello", "String trim");
    
    // startsWith / endsWith
    String url = String("https://example.com");
    TEST_ASSERT(url.startsWith(String("https")).toBool(), "String startsWith");
    TEST_ASSERT(url.endsWith(String(".com")).toBool(), "String endsWith");
    
    // replaceAll
    String text = String("hello world hello");
    String replaced = text.replaceAll(String("hello"), String("hi"));
    TEST_ASSERT(replaced == "hi world hi", "String replaceAll");
}

// ============================================================================
// Test 25: 集合高级操作
// ============================================================================

void test_collection_advanced() {
    TEST_START("Collection Advanced Operations");
    
    // List sort
    ObjectPtr<List<Int>> list = List<Int>::create();
    list->add(Int(3));
    list->add(Int(1));
    list->add(Int(2));
    list->sort();
    TEST_ASSERT(list->get(Int(0)).toInt() == 1, "List sort");
    
    // List reverse
    list->reverse();
    TEST_ASSERT(list->get(Int(0)).toInt() == 3, "List reverse");
    
    // Set union
    ObjectPtr<Set<Int>> set1 = Set<Int>::create();
    set1->add(Int(1));
    set1->add(Int(2));
    
    ObjectPtr<Set<Int>> set2 = Set<Int>::create();
    set2->add(Int(2));
    set2->add(Int(3));
    
    ObjectPtr<Set<Int>> union_set = set1->unionWith(set2);
    TEST_ASSERT(union_set->size().toInt() == 3, "Set union");
}

// ============================================================================
// Main测试入口
// ============================================================================

int main() {
    std::cout << "========================================" << std::endl;
    std::cout << "Dart to C++ Conversion Test Suite" << std::endl;
    std::cout << "========================================" << std::endl;
    
    test_basic_types();
    test_arithmetic_operators();
    test_comparison_operators();
    test_logical_operators();
    test_increment_decrement();
    test_compound_assignment();
    test_bitwise_operators();
    test_string_operations();
    test_list_collection();
    test_set_collection();
    test_map_collection();
    test_control_flow_if();
    test_control_flow_loops();
    test_type_conversions();
    test_null_handling();
    test_future_async();
    test_string_split();
    test_list_iterator();
    test_complex_expressions();
    test_string_templates();
    test_bool_implicit_conversion();
    test_object_refcount();
    test_math_operations();
    test_string_advanced();
    test_collection_advanced();
    
    std::cout << "\n========================================" << std::endl;
    std::cout << "Test Results: " << test_passed << "/" << test_count << " passed" << std::endl;
    std::cout << "========================================" << std::endl;
    
    return (test_passed == test_count) ? 0 : 1;
}

