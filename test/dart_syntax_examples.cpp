#include "../pkg/dart2bytecode/base/object.h"
#include "../pkg/dart2bytecode/base/object_extensions_simple.h"
#include "../pkg/dart2bytecode/base/dart_syntax_simple.h"
#include <iostream>

// ============================================================================
// Dart 语法扩展使用示例
// ============================================================================

// 简单的枚举示例
DART_ENUM_START(Color)
    RED,
    GREEN,
    BLUE
DART_ENUM_END(Color)

// 示例函数：演示基本类型扩展
void test_basic_types() {
    dart_print(dart_string("=== 测试基本类型扩展 ==="));
    
    // 自增自减操作
    Int x = dart_int(5);
    dart_print(dart_string("原始值: ") + x.toString());
    
    ++x;  // 前置自增
    dart_print(dart_string("前置自增后: ") + x.toString());
    
    x++;  // 后置自增
    dart_print(dart_string("后置自增后: ") + x.toString());
    
    // 复合赋值操作
    x += dart_int(10);
    dart_print(dart_string("+=10后: ") + x.toString());
    
    x *= dart_int(2);
    dart_print(dart_string("*=2后: ") + x.toString());
}

// 示例函数：演示字符串扩展
void test_string_extensions() {
    dart_print(dart_string("=== 测试字符串扩展 ==="));
    
    String text = dart_string("apple,banana,orange");
    dart_print(dart_string("原始字符串: ") + text);
    
    // 字符串分割
    ObjectPtr<List<String> > fruits = dart_split_by_string(text, dart_string(","));
    
    dart_print(dart_string("分割后的水果列表:"));
    dart_for_each(String, fruit, fruits)
        dart_print(dart_string("  - ") + fruit);
    dart_end_for
    
    // 字符串格式化
    String formatted = dart_format2(
        dart_string("我有{}个{}"), 
        dart_string("3"), 
        dart_string("苹果")
    );
    dart_print(formatted);
}

// 示例函数：演示集合操作
void test_collections() {
    dart_print(dart_string("=== 测试集合操作 ==="));
    
    // 创建和操作 List
    ObjectPtr<List<Int> > numbers = dart_list_int();
    
    for (int i = 1; i <= 5; i++) {
        dart_list_add(numbers, dart_int(i));
    }
    
    dart_print(dart_string("数字列表:"));
    dart_for_each(Int, num, numbers)
        dart_print(dart_string("  ") + num.toString());
    dart_end_for
    
    // 转换为字符串列表
    ObjectPtr<List<String> > stringNumbers = dart_map_to_string(numbers);
    
    dart_print(dart_string("转换为字符串后:"));
    dart_for_each(String, str, stringNumbers)
        dart_print(dart_string("  '") + str + dart_string("'"));
    dart_end_for
    
    // Map 操作
    ObjectPtr<Map<String, Int> > scores = dart_map_string_int();
    dart_map_put(scores, dart_string("Alice"), dart_int(95));
    dart_map_put(scores, dart_string("Bob"), dart_int(87));
    dart_map_put(scores, dart_string("Charlie"), dart_int(92));
    
    dart_print(dart_string("分数表大小: ") + dart_map_size(scores).toString());
    
    if (dart_map_contains_key(scores, dart_string("Alice")).toBool()) {
        Int alice_score = dart_map_get(scores, dart_string("Alice"));
        dart_print(dart_string("Alice的分数: ") + alice_score.toString());
    }
}

// 示例函数：演示数学操作
void test_math_operations() {
    dart_print(dart_string("=== 测试数学操作 ==="));
    
    Int a = dart_int(-10);
    Int b = dart_int(20);
    
    dart_print(dart_string("a = ") + a.toString());
    dart_print(dart_string("b = ") + b.toString());
    dart_print(dart_string("abs(a) = ") + dart_abs_int(a).toString());
    dart_print(dart_string("min(a,b) = ") + dart_min(a, b).toString());
    dart_print(dart_string("max(a,b) = ") + dart_max(a, b).toString());
    
    // 测试三元操作符
    Int result = dart_ternary(a.operator>(b), a, b);
    dart_print(dart_string("a > b ? a : b = ") + result.toString());
}

// 示例函数：演示空值处理
void test_null_safety() {
    dart_print(dart_string("=== 测试空值处理 ==="));
    
    ObjectPtr<String> nullable_string;  // 空指针
    String default_value = dart_string("默认值");
    
    if (dart_is_null(nullable_string).toBool()) {
        dart_print(dart_string("nullable_string 是空的"));
    }
    
    // 空值合并
    String result = dart_null_coalesce(nullable_string, default_value);
    dart_print(dart_string("合并结果: ") + result);
}

// 示例函数：演示范围操作
void test_range_operations() {
    dart_print(dart_string("=== 测试范围操作 ==="));
    
    ObjectPtr<SimpleRange> range = dart_range(1, 6);
    dart_print(dart_string("范围: ") + range->toString());
    
    ObjectPtr<List<Int> > range_list = range->toList();
    dart_print(dart_string("范围转列表:"));
    dart_for_each(Int, num, range_list)
        dart_print(dart_string("  ") + num.toString());
    dart_end_for
    
    // 检查包含
    if (range->contains(dart_int(3)).toBool()) {
        dart_print(dart_string("范围包含 3"));
    }
}

// 示例函数：演示枚举
void test_enums() {
    dart_print(dart_string("=== 测试枚举 ==="));
    
    Color red = Color(Color::RED);
    Color green = Color(Color::GREEN);
    
    dart_print(dart_string("红色值: ") + red.toInt().toString());
    dart_print(dart_string("绿色值: ") + green.toInt().toString());
    
    if (red.operator==(Color(Color::RED)).toBool()) {
        dart_print(dart_string("颜色匹配成功"));
    }
}

// 示例函数：演示异常处理
void test_exception_handling() {
    dart_print(dart_string("=== 测试异常处理 ==="));
    
    dart_try {
        Int zero = dart_int(0);
        Int result = dart_int(10) / zero;  // 这会抛出异常
    }
    dart_catch(std::runtime_error) {
        dart_print(dart_string("捕获到除零异常"));
    }
    dart_catch_all {
        dart_print(dart_string("捕获到其他异常"));
    }
}

// 示例函数：演示类型转换
void test_type_conversions() {
    dart_print(dart_string("=== 测试类型转换 ==="));
    
    String number_str = dart_string("123");
    String float_str = dart_string("3.14");
    
    Int parsed_int = dart_parse_int(number_str);
    Double parsed_double = dart_parse_double(float_str);
    
    dart_print(dart_string("解析整数: ") + parsed_int.toString());
    dart_print(dart_string("解析浮点数: ") + parsed_double.toString());
}

// 控制流示例
void test_control_flow() {
    dart_print(dart_string("=== 测试控制流 ==="));
    
    // 条件执行
    Bool condition = dart_bool(true);
    
    if (condition.toBool()) {
        dart_print(dart_string("条件为真"));
    }
    
    if (!condition.toBool()) {
        dart_print(dart_string("条件为假"));
    }
    
    // 使用 C++ 原生控制流结构
    dart_print(dart_string("使用原生for循环:"));
    for (int i = 0; i < 3; i++) {
        dart_print(dart_string("  循环 ") + dart_int(i).toString());
    }
    
    // 使用 C++ while 循环
    int count = 0;
    dart_print(dart_string("使用原生while循环:"));
    while (count < 3) {
        dart_print(dart_string("  计数 ") + dart_int(count).toString());
        count++;
    }
}

// 主函数
int main() {
    dart_try {
        dart_print(dart_string("Dart 语法扩展示例"));
        dart_print(dart_string("=================="));
        
        test_basic_types();
        std::cout << std::endl;
        
        test_string_extensions();
        std::cout << std::endl;
        
        test_collections();
        std::cout << std::endl;
        
        test_math_operations();
        std::cout << std::endl;
        
        test_null_safety();
        std::cout << std::endl;
        
        test_range_operations();
        std::cout << std::endl;
        
        test_enums();
        std::cout << std::endl;
        
        test_exception_handling();
        std::cout << std::endl;
        
        test_type_conversions();
        std::cout << std::endl;
        
        test_control_flow();
        std::cout << std::endl;
        
        dart_print(dart_string("所有测试完成！"));
        
    }
    dart_catch_all {
        std::cerr << "程序执行出现错误" << std::endl;
        return 1;
    }
    
    return 0;
}
