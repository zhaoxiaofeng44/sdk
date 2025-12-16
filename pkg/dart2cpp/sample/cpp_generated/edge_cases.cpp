#include "dart2cpp.h"

// 工具宏定义

// ============================================================================
// 类: City
// ============================================================================

class City {
public:
  String name;
  City(String name) : name(name) {
  }
  
};

// ============================================================================
// 类: Address
// ============================================================================

class Address {
public:
  String street;
  ObjectPtr<City> city;
  Address(String street, ObjectPtr<City> city) : street(street), city(city) {
  }
  
};

// ============================================================================
// 类: Person
// ============================================================================

class Person {
public:
  String name;
  ObjectPtr<Address> address;
  Person(String name, ObjectPtr<Address> address) : name(name), address(address) {
  }
  
};

Nullable testNumericEdgeCases();
Nullable testStringEdgeCases();
Nullable testCollectionEdgeCases();
Nullable testNullEdgeCases();
Nullable testDivisionAndOverflow();
Nullable testTypeConversionEdges();
Nullable testNumericEdgeCases() {
  dart_print(dart_string("\n📌 测试数值边界情况"));
dart_print(dart_string("  整数边界:"));
auto maxInt = dart_int(9223372036854775807);
auto minInt = dart_int(-9223372036854775808);
auto zero = dart_int(0);
auto one = dart_int(1);
auto minusOne = dart_int(-1);
dart_print(dart_string("    最大整数: ") + (maxInt).toString());
dart_print(dart_string("    最小整数: ") + (minInt).toString());
dart_print(dart_string("    零: ") + (zero).toString());
dart_print(dart_string("    一: ") + (one).toString());
dart_print(dart_string("    负一: ") + (minusOne).toString());
dart_print(dart_string("  浮点数边界:"));
auto positiveZero = dart_double(0.0);
auto negativeZero = dart_double(-0.0);
auto verySmall = dart_double(1e-7);
auto veryLarge = dart_double(1000000000.0);
auto infinity = dart_double(Infinity);
auto negativeInfinity = dart_double(-Infinity);
auto nan = dart_double(NaN);
dart_print(dart_string("    正零: ") + (positiveZero).toString());
dart_print(dart_string("    负零: ") + (negativeZero).toString());
dart_print(dart_string("    很小的数: ") + (verySmall).toString());
dart_print(dart_string("    很大的数: ") + (veryLarge).toString());
dart_print(dart_string("    正无穷: ") + (infinity).toString());
dart_print(dart_string("    负无穷: ") + (negativeInfinity).toString());
dart_print(dart_string("    NaN: ") + (nan).toString());
dart_print(dart_string("  特殊值检查:"));
dart_print(dart_string("    infinity是无穷: ") + (infinity->isInfinite()).toString());
dart_print(dart_string("    nan是NaN: ") + (nan->isNaN()).toString());
dart_print(dart_string("    infinity是有限: ") + (infinity->isFinite()).toString());
dart_print(dart_string("    veryLarge是有限: ") + (veryLarge->isFinite()).toString());
dart_print(dart_string("  零值运算:"));
dart_print(dart_string("    5 + 0 = ") + (dart_int(5)->operator_add(dart_int(0))).toString());
dart_print(dart_string("    5 * 0 = ") + (dart_int(5)->operator_mul(dart_int(0))).toString());
dart_print(dart_string("    5 - 0 = ") + (dart_int(5)->operator_sub(dart_int(0))).toString());
dart_print(dart_string("    0 - 5 = ") + (dart_int(0)->operator_sub(dart_int(5))).toString());
dart_print(dart_string("  负数运算:"));
dart_print(dart_string("    -5 + (-3) = ") + (dart_int(-5)->operator_add(dart_int(-3))).toString());
dart_print(dart_string("    -5 * -3 = ") + (dart_int(-5)->operator_mul(dart_int(-3))).toString());
dart_print(dart_string("    -5 - (-3) = ") + (dart_int(-5)->operator_sub(dart_int(-3))).toString());
dart_print(dart_string("    -(-5) = ") + (dart_int(-5)->operator_negate()).toString());
dart_print(dart_string("  边界运算:"));
dart_print(dart_string("    maxInt + 1 会溢出"));
dart_print(dart_string("    minInt - 1 会溢出"));
return Void;
}

Nullable testStringEdgeCases() {
  dart_print(dart_string("\n📌 测试字符串边界情况"));
auto empty = dart_string("");
dart_print(dart_string("  空字符串:"));
dart_print(dart_string("    长度: ") + (empty->size()).toString());
dart_print(dart_string("    是否为空: ") + (empty->isEmpty()).toString());
dart_print(dart_string("    是否不为空: ") + (empty->isNotEmpty()).toString());
auto single = dart_string("a");
dart_print(dart_string("  单字符:"));
dart_print(dart_concat(dart_string("    内容: \""), (single).toString(), dart_string("\"")));
dart_print(dart_string("    长度: ") + (single->size()).toString());
auto spaces = dart_string("   ");
auto tabs = dart_string("\t\t\t");
auto newlines = dart_string("\n\n\n");
dart_print(dart_string("  空白字符串:"));
dart_print(dart_string("    空格长度: ") + (spaces->size()).toString());
dart_print(dart_string("    制表符长度: ") + (tabs->size()).toString());
dart_print(dart_string("    换行符长度: ") + (newlines->size()).toString());
dart_print(dart_concat(dart_string("    空格trim后: \""), (spaces->trim()).toString(), dart_string("\"")));
auto special = dart_string("Hello\nWorld\t!");
auto unicode = dart_string("你好世界🌍");
auto escaped = dart_string("Quote: \"Hello\" and 'World'");
dart_print(dart_string("  特殊字符:"));
dart_print(dart_concat(dart_string("    换行制表: \""), (special).toString(), dart_string("\"")));
dart_print(dart_concat(dart_string("    Unicode: "), (unicode).toString(), dart_string(" (长度: "), (unicode->size()).toString(), dart_string(")")));
dart_print(dart_string("    转义字符: ") + (escaped).toString());
auto longString = dart_string("a")->operator_mul(dart_int(1000));
dart_print(dart_string("  长字符串:"));
dart_print(dart_string("    长度: ") + (longString->size()).toString());
dart_print(dart_string("    前10个字符: ") + (longString->substring(dart_int(0), dart_int(10))).toString());
auto concat1 = dart_string("")->operator_add(dart_string("hello"));
auto concat2 = dart_string("hello")->operator_add(dart_string(""));
auto concat3 = dart_string("")->operator_add(dart_string(""));
dart_print(dart_string("  连接边界:"));
dart_print(dart_concat(dart_string("    空+hello: \""), (concat1).toString(), dart_string("\"")));
dart_print(dart_concat(dart_string("    hello+空: \""), (concat2).toString(), dart_string("\"")));
dart_print(dart_concat(dart_string("    空+空: \""), (concat3).toString(), dart_string("\"")));
auto str = dart_string("Hello");
dart_print(dart_string("  子字符串边界:"));
try {
auto sub1 = str->substring(dart_int(0), dart_int(0));
dart_print(dart_concat(dart_string("    substring(0,0): \""), (sub1).toString(), dart_string("\"")));
} catch (const std::exception& e) { /* catch block */ }
// Finally block should be implemented using RAII pattern
try {
auto sub2 = str->substring(dart_int(0), str->size());
dart_print(dart_concat(dart_string("    substring(0,len): \""), (sub2).toString(), dart_string("\"")));
} catch (const std::exception& e) { /* catch block */ }
// Finally block should be implemented using RAII pattern
try {
auto sub3 = str->substring(str->size(), str->size());
dart_print(dart_concat(dart_string("    substring(len,len): \""), (sub3).toString(), dart_string("\"")));
} catch (const std::exception& e) { /* catch block */ }
// Finally block should be implemented using RAII pattern
dart_print(dart_string("  索引边界:"));
dart_print(dart_string("    indexOf存在字符: ") + (str->indexOf(dart_string("H"))).toString());
dart_print(dart_string("    indexOf不存在字符: ") + (str->indexOf(dart_string("z"))).toString());
dart_print(dart_string("    lastIndexOf: ") + (str->lastIndexOf(dart_string("l"))).toString());
return Void;
}

Nullable testCollectionEdgeCases() {
  dart_print(dart_string("\n📌 测试集合边界情况"));
auto emptyList = dart_literal(dart_int(0));
dart_print(dart_string("  空列表:"));
dart_print(dart_string("    长度: ") + (emptyList->size()).toString());
dart_print(dart_string("    是否为空: ") + (emptyList->isEmpty()).toString());
try {
dart_print(dart_string("    first: ") + (emptyList->first()).toString());
} catch (const std::exception& e) { /* catch block */ }
// Finally block should be implemented using RAII pattern
try {
dart_print(dart_string("    last: ") + (emptyList->last()).toString());
} catch (const std::exception& e) { /* catch block */ }
// Finally block should be implemented using RAII pattern
auto singleList = dart_literal(dart_int(42));
dart_print(dart_string("  单元素列表:"));
dart_print(dart_string("    内容: ") + (singleList).toString());
dart_print(dart_string("    first: ") + (singleList->first()).toString());
dart_print(dart_string("    last: ") + (singleList->last()).toString());
dart_print(dart_string("    first == last: ") + ((singleList->first() == singleList->last())).toString());
auto duplicates = dart_literal(dart_int(1), dart_int(1), dart_int(2), dart_int(2), dart_int(3), dart_int(3));
dart_print(dart_string("  重复元素列表:"));
dart_print(dart_string("    内容: ") + (duplicates).toString());
dart_print(dart_string("    去重: ") + (duplicates->toSet()->toList()).toString());
auto testList = dart_literal(dart_int(1), dart_int(2), dart_int(3));
dart_print(dart_string("  列表边界访问:"));
try {
dart_print(dart_string("    索引0: ") + (testList->operator_index(dart_int(0))).toString());
dart_print(dart_string("    索引-1: ") + (testList->operator_index(dart_int(-1))).toString());
} catch (const std::exception& e) { /* catch block */ }
// Finally block should be implemented using RAII pattern
try {
dart_print(dart_string("    索引3: ") + (testList->operator_index(dart_int(3))).toString());
} catch (const std::exception& e) { /* catch block */ }
// Finally block should be implemented using RAII pattern
auto emptyMap = Map<String, Int>::create();
dart_print(dart_string("  空Map:"));
dart_print(dart_string("    长度: ") + (emptyMap->size()).toString());
dart_print(dart_string("    是否为空: ") + (emptyMap->isEmpty()).toString());
dart_print(dart_string("    访问不存在键: ") + (emptyMap->operator_index(dart_string("nonexistent"))).toString());
auto singleMap = Map<String, Int>::createFromEntries({{dart_string("key"), dart_int(42)}});
dart_print(dart_string("  单键值对Map:"));
dart_print(dart_string("    内容: ") + (singleMap).toString());
dart_print(dart_string("    键集合: ") + (singleMap->keys()).toString());
dart_print(dart_string("    值集合: ") + (singleMap->values()).toString());
auto emptySet = ([&]() { const auto unnamed_var = ObjectPtr<Set>(new Set()); return unnamed_var; })();
dart_print(dart_string("  空Set:"));
dart_print(dart_string("    长度: ") + (emptySet->size()).toString());
dart_print(dart_string("    是否为空: ") + (emptySet->isEmpty()).toString());
auto testSet = ([&]() { const auto unnamed_var = ObjectPtr<Set>(new Set()); unnamed_var->add(dart_int(1)); unnamed_var->add(dart_int(2)); unnamed_var->add(dart_int(3)); return unnamed_var; })();
testSet->add(dart_int(2));
dart_print(dart_string("  Set重复添加:"));
dart_print(dart_string("    添加重复元素后: ") + (testSet).toString());
auto set1 = ([&]() { const auto unnamed_var = ObjectPtr<Set>(new Set()); unnamed_var->add(dart_int(1)); unnamed_var->add(dart_int(2)); unnamed_var->add(dart_int(3)); return unnamed_var; })();
auto set2 = ([&]() { const auto unnamed_var = ObjectPtr<Set>(new Set()); return unnamed_var; })();
dart_print(dart_string("  集合运算边界:"));
dart_print(dart_string("    非空与空的并集: ") + (set1->union(set2)).toString());
dart_print(dart_string("    非空与空的交集: ") + (set1->intersection(set2)).toString());
dart_print(dart_string("    非空与空的差集: ") + (set1->difference(set2)).toString());
return Void;
}

Nullable testNullEdgeCases() {
  dart_print(dart_string("\n📌 测试空值边界情况"));
Int nullInt(Null);
String nullString(Null);
ObjectPtr<ObjectPtr<List<Int>>> nullList(nullptr);
ObjectPtr<ObjectPtr<Map<String, Int>>> nullMap(nullptr);
dart_print(dart_string("  空值变量:"));
dart_print(dart_string("    nullInt: ") + (nullInt).toString());
dart_print(dart_string("    nullString: ") + (nullString).toString());
dart_print(dart_string("    nullList: ") + (nullList).toString());
dart_print(dart_string("    nullMap: ") + (nullMap).toString());
auto value1 = dart_null_coalesce(nullInt, dart_int(0));
auto value2 = dart_null_coalesce(nullString, dart_string("default"));
auto value3 = dart_null_coalesce(nullList, dart_literal(dart_int(0)));
dart_print(dart_string("  空值合并:"));
dart_print(dart_string("    nullInt ?? 0: ") + (value1).toString());
dart_print(dart_string("    nullString ?? default: ") + (value2).toString());
dart_print(dart_string("    nullList ?? []: ") + (value3).toString());
Int testInt(Null);
if (dart_is_null(testInt)) testInt = dart_int(42);
dart_print(dart_string("    testInt ??= 42: ") + (testInt).toString());
if (dart_is_null(testInt)) testInt = dart_int(100);
dart_print(dart_string("    testInt ??= 100: ") + (testInt).toString());
auto name = dart_string("Alice");
auto length1 = dart_null_coalesce(name, Null);
dart_print(dart_string("  空值安全访问:"));
dart_print(dart_string("    非空字符串长度: ") + (length1).toString());
name = Null;
auto length2 = dart_null_coalesce(name, Null);
dart_print(dart_string("    空字符串长度: ") + (length2).toString());
auto person = ObjectPtr<Person>(new Person(dart_string("Bob"), ObjectPtr<Address>(new Address(dart_string("Main St"), ObjectPtr<City>(new City(dart_string("New York")))))));
auto cityName1 = ([&]() { auto let_var = person; return dart_is_null(let_var) ? Null : ([&]() { auto let_var = let_var->address; return dart_is_null(let_var) ? Null : dart_null_coalesce(let_var->city, Null); })(); })();
dart_print(dart_string("    链式访问城市名: ") + (cityName1).toString());
person = Null;
auto cityName2 = ([&]() { auto let_var = person; return dart_is_null(let_var) ? Null : ([&]() { auto let_var = let_var->address; return dart_is_null(let_var) ? Null : dart_null_coalesce(let_var->city, Null); })(); })();
dart_print(dart_string("    空对象链式访问: ") + (cityName2).toString());
auto maybeString = dart_string("Hello");
auto definitelyString = maybeString;
dart_print(dart_string("    空值断言: ") + (definitelyString).toString());
try {
auto nullString = Null;
auto crashString = nullString;
dart_print(dart_string("    不会执行到这里: ") + (crashString).toString());
} catch (const std::exception& e) { /* catch block */ }
// Finally block should be implemented using RAII pattern;
return Void;
}

Nullable testDivisionAndOverflow() {
  dart_print(dart_string("\n📌 测试除零和溢出"));
dart_print(dart_string("  整数除零:"));
try {
auto result = dart_int(10)->truncatingDivision(dart_int(0));
dart_print(dart_string("    10 ~/ 0 = ") + (result).toString());
} catch (const std::exception& e) { /* catch block */ }
// Finally block should be implemented using RAII pattern
dart_print(dart_string("  浮点数除零:"));
auto result1 = dart_double(10.0)->operator_div(dart_double(0.0));
auto result2 = dart_double(-10.0)->operator_div(dart_double(0.0));
auto result3 = dart_double(0.0)->operator_div(dart_double(0.0));
dart_print(dart_string("    10.0 / 0.0 = ") + (result1).toString());
dart_print(dart_string("    -10.0 / 0.0 = ") + (result2).toString());
dart_print(dart_string("    0.0 / 0.0 = ") + (result3).toString());
dart_print(dart_string("  模运算边界:"));
try {
auto mod1 = dart_int(10)->operator_mod(dart_int(0));
dart_print(dart_string("    10 % 0 = ") + (mod1).toString());
} catch (const std::exception& e) { /* catch block */ }
// Finally block should be implemented using RAII pattern
dart_print(dart_string("    10 % 3 = ") + (dart_int(10)->operator_mod(dart_int(3))).toString());
dart_print(dart_string("    10 % -3 = ") + (dart_int(10)->operator_mod(dart_int(-3))).toString());
dart_print(dart_string("    -10 % 3 = ") + (dart_int(-10)->operator_mod(dart_int(3))).toString());
dart_print(dart_string("    -10 % -3 = ") + (dart_int(-10)->operator_mod(dart_int(-3))).toString());
dart_print(dart_string("  大数运算:"));
auto bigInt1 = dart_int(9223372036854775807);
auto bigInt2 = dart_int(1);
dart_print(dart_string("    大整数: ") + (bigInt1).toString());
auto sum = bigInt1->operator_add(bigInt2);
dart_print(dart_concat(dart_string("    大整数 + 1: "), (sum).toString(), dart_string(" (类型: "), (sum->runtimeType()).toString(), dart_string(")")));
dart_print(dart_string("  浮点数精度:"));
auto precise1 = dart_double(0.1)->operator_add(dart_double(0.2));
dart_print(dart_string("    0.1 + 0.2 = ") + (precise1).toString());
dart_print(dart_string("    是否等于0.3: ") + ((precise1 == dart_double(0.3))).toString());
auto verySmall = dart_double(1e-100);
auto veryLarge = dart_double(1e+100);
dart_print(dart_string("    很小的数: ") + (verySmall).toString());
dart_print(dart_string("    很大的数: ") + (veryLarge).toString());
dart_print(dart_string("  无穷大运算:"));
auto inf = dart_double(Infinity);
dart_print(dart_string("    infinity + 1: ") + (inf->operator_add(dart_double(1.0))).toString());
dart_print(dart_string("    infinity - infinity: ") + (inf->operator_sub(inf)).toString());
dart_print(dart_string("    infinity / infinity: ") + (inf->operator_div(inf)).toString());
dart_print(dart_string("    infinity * 0: ") + (inf->operator_mul(dart_double(0.0))).toString());
return Void;
}

Nullable testTypeConversionEdges() {
  dart_print(dart_string("\n📌 测试类型转换边界"));
dart_print(dart_string("  字符串转数字:"));
try {
auto parsed1 = int::parse(dart_string("123"), Int(Null), nullptr);
dart_print(dart_string("    parse \"123\": ") + (parsed1).toString());
} catch (const std::exception& e) { /* catch block */ }
// Finally block should be implemented using RAII pattern
try {
auto parsed2 = int::parse(dart_string(""), Int(Null), nullptr);
dart_print(dart_string("    parse 空字符串: ") + (parsed2).toString());
} catch (const std::exception& e) { /* catch block */ }
// Finally block should be implemented using RAII pattern
try {
auto parsed3 = int::parse(dart_string("abc"), Int(Null), nullptr);
dart_print(dart_string("    parse \"abc\": ") + (parsed3).toString());
} catch (const std::exception& e) { /* catch block */ }
// Finally block should be implemented using RAII pattern
dart_print(dart_string("  tryParse 安全转换:"));
auto safe1 = int::tryParse(dart_string("123"), Int(Null));
auto safe2 = int::tryParse(dart_string("abc"), Int(Null));
auto safe3 = int::tryParse(dart_string(""), Int(Null));
dart_print(dart_string("    tryParse \"123\": ") + (safe1).toString());
dart_print(dart_string("    tryParse \"abc\": ") + (safe2).toString());
dart_print(dart_string("    tryParse 空字符串: ") + (safe3).toString());
dart_print(dart_string("  浮点数转换:"));
auto float1 = double::tryParse(dart_string("3.14"));
auto float2 = double::tryParse(dart_string("abc"));
auto float3 = double::tryParse(dart_string("infinity"));
auto float4 = double::tryParse(dart_string("nan"));
dart_print(dart_string("    tryParse \"3.14\": ") + (float1).toString());
dart_print(dart_string("    tryParse \"abc\": ") + (float2).toString());
dart_print(dart_string("    tryParse \"infinity\": ") + (float3).toString());
dart_print(dart_string("    tryParse \"nan\": ") + (float4).toString());
dart_print(dart_string("  类型转换 as:"));
Any value1 = dart_int(42);
Any value2 = dart_string("hello");
try {
auto intValue = dart_cast<Int>(value1);
dart_print(dart_string("    42 as int: ") + (intValue).toString());
} catch (const std::exception& e) { /* catch block */ }
// Finally block should be implemented using RAII pattern
try {
auto intValue = dart_cast<Int>(value2);
dart_print(dart_string("    \"hello\" as int: ") + (intValue).toString());
} catch (const std::exception& e) { /* catch block */ }
// Finally block should be implemented using RAII pattern
dart_print(dart_string("  类型检查 is:"));
dart_print(dart_string("    42 is int: ") + (dart_is<Int>(value1)).toString());
dart_print(dart_string("    42 is String: ") + (dart_is<String>(value1)).toString());
dart_print(dart_string("    \"hello\" is String: ") + (dart_is<String>(value2)).toString());
dart_print(dart_string("    \"hello\" is int: ") + (dart_is<Int>(value2)).toString());
dart_print(dart_string("  数值转换边界:"));
auto bigDouble = dart_double(100000000000000000000.0);
auto convertedInt = bigDouble->toInt();
dart_print(dart_concat(dart_string("    大浮点数转整数: "), (bigDouble).toString(), dart_string(" -> "), (convertedInt).toString()));
auto smallDouble = dart_double(0.9);
auto truncatedInt = smallDouble->toInt();
dart_print(dart_concat(dart_string("    小数转整数: "), (smallDouble).toString(), dart_string(" -> "), (truncatedInt).toString()));
return Void;
}

// ============================================================================
// 主函数
// ============================================================================

int main() {
  try {
    dart_print(dart_string("🔥 边界测试开始"));
testNumericEdgeCases();
testStringEdgeCases();
testCollectionEdgeCases();
testNullEdgeCases();
testDivisionAndOverflow();
testTypeConversionEdges();
dart_print(dart_string("✅ 边界测试完成"));
    return 0;
  } catch (const std::exception& e) {
    std::cerr << "Error: " << e.what() << std::endl;
    return 1;
  }
}
