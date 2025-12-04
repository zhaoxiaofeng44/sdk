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
  City city;
  Address(String street, City city) : street(street), city(city) {
  }
  
};

// ============================================================================
// 类: Person
// ============================================================================

class Person {
public:
  String name;
  Address address;
  Person(String name, Address address) : name(name), address(address) {
  }
  
};

Nullable testNumericEdgeCases() {
  dart_print(dart_string("\n📌 测试数值边界情况"));
dart_print(dart_string("  整数边界:"));
auto maxInt = dart_int(9223372036854775807);
auto minInt = dart_int(-9223372036854775808);
auto zero = dart_int(0);
auto one = dart_int(1);
auto minusOne = dart_int(-1);
dart_print(dart_concat(dart_string("    最大整数: "), maxInt));
dart_print(dart_concat(dart_string("    最小整数: "), minInt));
dart_print(dart_concat(dart_string("    零: "), zero));
dart_print(dart_concat(dart_string("    一: "), one));
dart_print(dart_concat(dart_string("    负一: "), minusOne));
dart_print(dart_string("  浮点数边界:"));
auto positiveZero = dart_double(0.0);
auto negativeZero = dart_double(-0.0);
auto verySmall = dart_double(1e-7);
auto veryLarge = dart_double(1000000000.0);
auto infinity = dart_double(Infinity);
auto negativeInfinity = dart_double(-Infinity);
auto nan = dart_double(NaN);
dart_print(dart_concat(dart_string("    正零: "), positiveZero));
dart_print(dart_concat(dart_string("    负零: "), negativeZero));
dart_print(dart_concat(dart_string("    很小的数: "), verySmall));
dart_print(dart_concat(dart_string("    很大的数: "), veryLarge));
dart_print(dart_concat(dart_string("    正无穷: "), infinity));
dart_print(dart_concat(dart_string("    负无穷: "), negativeInfinity));
dart_print(dart_concat(dart_string("    NaN: "), nan));
dart_print(dart_string("  特殊值检查:"));
dart_print(dart_concat(dart_string("    infinity是无穷: "), infinity->isInfinite));
dart_print(dart_concat(dart_string("    nan是NaN: "), nan->isNaN));
dart_print(dart_concat(dart_string("    infinity是有限: "), infinity->isFinite));
dart_print(dart_concat(dart_string("    veryLarge是有限: "), veryLarge.isFinite));
dart_print(dart_string("  零值运算:"));
dart_print(dart_concat(dart_string("    5 + 0 = "), (dart_int(5) + dart_int(0))));
dart_print(dart_concat(dart_string("    5 * 0 = "), (dart_int(5) * dart_int(0))));
dart_print(dart_concat(dart_string("    5 - 0 = "), (dart_int(5) - dart_int(0))));
dart_print(dart_concat(dart_string("    0 - 5 = "), (dart_int(0) - dart_int(5))));
dart_print(dart_string("  负数运算:"));
dart_print(dart_concat(dart_string("    -5 + (-3) = "), (dart_int(-5) + dart_int(-3))));
dart_print(dart_concat(dart_string("    -5 * -3 = "), (dart_int(-5) * dart_int(-3))));
dart_print(dart_concat(dart_string("    -5 - (-3) = "), (dart_int(-5) - dart_int(-3))));
dart_print(dart_concat(dart_string("    -(-5) = "), dart_int(-5)->operator_negate()));
dart_print(dart_string("  边界运算:"));
dart_print(dart_string("    maxInt + 1 会溢出"));
dart_print(dart_string("    minInt - 1 会溢出"));
return Void;
}

Nullable testStringEdgeCases() {
  dart_print(dart_string("\n📌 测试字符串边界情况"));
auto empty = dart_string("");
dart_print(dart_string("  空字符串:"));
dart_print(dart_concat(dart_string("    长度: "), empty.get_length()));
dart_print(dart_concat(dart_string("    是否为空: "), empty.isEmpty));
dart_print(dart_concat(dart_string("    是否不为空: "), empty.isNotEmpty));
auto single = dart_string("a");
dart_print(dart_string("  单字符:"));
dart_print(dart_concat(dart_string("    内容: \""), single, dart_string("\"")));
dart_print(dart_concat(dart_string("    长度: "), single.get_length()));
auto spaces = dart_string("   ");
auto tabs = dart_string("\t\t\t");
auto newlines = dart_string("\n\n\n");
dart_print(dart_string("  空白字符串:"));
dart_print(dart_concat(dart_string("    空格长度: "), spaces.get_length()));
dart_print(dart_concat(dart_string("    制表符长度: "), tabs.get_length()));
dart_print(dart_concat(dart_string("    换行符长度: "), newlines.get_length()));
dart_print(dart_concat(dart_string("    空格trim后: \""), spaces.trim(), dart_string("\"")));
auto special = dart_string("Hello\nWorld\t!");
auto unicode = dart_string("你好世界🌍");
auto escaped = dart_string("Quote: \"Hello\" and 'World'");
dart_print(dart_string("  特殊字符:"));
dart_print(dart_concat(dart_string("    换行制表: \""), special, dart_string("\"")));
dart_print(dart_concat(dart_string("    Unicode: "), unicode, dart_string(" (长度: "), unicode.get_length(), dart_string(")")));
dart_print(dart_concat(dart_string("    转义字符: "), escaped));
auto longString = (dart_string("a") * dart_int(1000));
dart_print(dart_string("  长字符串:"));
dart_print(dart_concat(dart_string("    长度: "), longString.get_length()));
dart_print(dart_concat(dart_string("    前10个字符: "), longString.substring(dart_int(0), dart_int(10))));
auto concat1 = (dart_string("") + dart_string("hello"));
auto concat2 = (dart_string("hello") + dart_string(""));
auto concat3 = (dart_string("") + dart_string(""));
dart_print(dart_string("  连接边界:"));
dart_print(dart_concat(dart_string("    空+hello: \""), concat1, dart_string("\"")));
dart_print(dart_concat(dart_string("    hello+空: \""), concat2, dart_string("\"")));
dart_print(dart_concat(dart_string("    空+空: \""), concat3, dart_string("\"")));
auto str = dart_string("Hello");
dart_print(dart_string("  子字符串边界:"));
try auto sub1 = str.substring(dart_int(0), dart_int(0));
dart_print(dart_concat(dart_string("    substring(0,0): \""), sub1, dart_string("\""))); catch (const std::exception& e) { /* catch block */ }
// Finally block should be implemented using RAII pattern
try auto sub2 = str.substring(dart_int(0), str.get_length());
dart_print(dart_concat(dart_string("    substring(0,len): \""), sub2, dart_string("\""))); catch (const std::exception& e) { /* catch block */ }
// Finally block should be implemented using RAII pattern
try auto sub3 = str.substring(str.get_length(), str.get_length());
dart_print(dart_concat(dart_string("    substring(len,len): \""), sub3, dart_string("\""))); catch (const std::exception& e) { /* catch block */ }
// Finally block should be implemented using RAII pattern
dart_print(dart_string("  索引边界:"));
dart_print(dart_concat(dart_string("    indexOf存在字符: "), str.indexOf(dart_string("H"))));
dart_print(dart_concat(dart_string("    indexOf不存在字符: "), str.indexOf(dart_string("z"))));
dart_print(dart_concat(dart_string("    lastIndexOf: "), str.lastIndexOf(dart_string("l"))));
return Void;
}

Nullable testCollectionEdgeCases() {
  dart_print(dart_string("\n📌 测试集合边界情况"));
auto emptyList = _GrowableList::(dart_int(0));
dart_print(dart_string("  空列表:"));
dart_print(dart_concat(dart_string("    长度: "), emptyList->size()));
dart_print(dart_concat(dart_string("    是否为空: "), emptyList->isEmpty));
try dart_print(dart_concat(dart_string("    first: "), emptyList->first)); catch (const std::exception& e) { /* catch block */ }
// Finally block should be implemented using RAII pattern
try dart_print(dart_concat(dart_string("    last: "), emptyList->last)); catch (const std::exception& e) { /* catch block */ }
// Finally block should be implemented using RAII pattern
auto singleList = dart_literal(dart_int(42));
dart_print(dart_string("  单元素列表:"));
dart_print(dart_concat(dart_string("    内容: "), singleList));
dart_print(dart_concat(dart_string("    first: "), singleList->first));
dart_print(dart_concat(dart_string("    last: "), singleList->last));
dart_print(dart_concat(dart_string("    first == last: "), (singleList->first == singleList->last)));
auto duplicates = dart_literal(dart_int(1), dart_int(1), dart_int(2), dart_int(2), dart_int(3), dart_int(3));
dart_print(dart_string("  重复元素列表:"));
dart_print(dart_concat(dart_string("    内容: "), duplicates));
dart_print(dart_concat(dart_string("    去重: "), duplicates->toSet()->toList()));
auto testList = dart_literal(dart_int(1), dart_int(2), dart_int(3));
dart_print(dart_string("  列表边界访问:"));
try dart_print(dart_concat(dart_string("    索引0: "), testList->[](dart_int(0))));
dart_print(dart_concat(dart_string("    索引-1: "), testList->[](dart_int(-1)))); catch (const std::exception& e) { /* catch block */ }
// Finally block should be implemented using RAII pattern
try dart_print(dart_concat(dart_string("    索引3: "), testList->[](dart_int(3)))); catch (const std::exception& e) { /* catch block */ }
// Finally block should be implemented using RAII pattern
auto emptyMap = Map<String, Int>::create();
dart_print(dart_string("  空Map:"));
dart_print(dart_concat(dart_string("    长度: "), emptyMap->size()));
dart_print(dart_concat(dart_string("    是否为空: "), emptyMap->isEmpty));
dart_print(dart_concat(dart_string("    访问不存在键: "), emptyMap->[](dart_string("nonexistent"))));
auto singleMap = Map<String, Int>::createFromEntries({{dart_string("key"), dart_int(42)}});
dart_print(dart_string("  单键值对Map:"));
dart_print(dart_concat(dart_string("    内容: "), singleMap));
dart_print(dart_concat(dart_string("    键集合: "), singleMap->keys));
dart_print(dart_concat(dart_string("    值集合: "), singleMap->values));
auto emptySet = ([&]() { const auto unnamed_var = ObjectPtr<_Set>(new _Set()); return unnamed_var; })();
dart_print(dart_string("  空Set:"));
dart_print(dart_concat(dart_string("    长度: "), emptySet->size()));
dart_print(dart_concat(dart_string("    是否为空: "), emptySet->isEmpty));
auto testSet = ([&]() { const auto unnamed_var = ObjectPtr<_Set>(new _Set()); unnamed_var->add(dart_int(1)); unnamed_var->add(dart_int(2)); unnamed_var->add(dart_int(3)); return unnamed_var; })();
testSet->add(dart_int(2));
dart_print(dart_string("  Set重复添加:"));
dart_print(dart_concat(dart_string("    添加重复元素后: "), testSet));
auto set1 = ([&]() { const auto unnamed_var = ObjectPtr<_Set>(new _Set()); unnamed_var->add(dart_int(1)); unnamed_var->add(dart_int(2)); unnamed_var->add(dart_int(3)); return unnamed_var; })();
auto set2 = ([&]() { const auto unnamed_var = ObjectPtr<_Set>(new _Set()); return unnamed_var; })();
dart_print(dart_string("  集合运算边界:"));
dart_print(dart_concat(dart_string("    非空与空的并集: "), set1->union(set2)));
dart_print(dart_concat(dart_string("    非空与空的交集: "), set1->intersection(set2)));
dart_print(dart_concat(dart_string("    非空与空的差集: "), set1->difference(set2)));
}

Nullable testNullEdgeCases() {
  dart_print(dart_string("\n📌 测试空值边界情况"));
Int nullInt;
String nullString;
List<Int> nullList;
Map<String, Int> nullMap;
dart_print(dart_string("  空值变量:"));
dart_print(dart_concat(dart_string("    nullInt: "), nullInt));
dart_print(dart_concat(dart_string("    nullString: "), nullString));
dart_print(dart_concat(dart_string("    nullList: "), nullList));
dart_print(dart_concat(dart_string("    nullMap: "), nullMap));
auto value1 = dart_is_null(nullInt) ? dart_int(0) : nullInt;
auto value2 = dart_is_null(nullString) ? dart_string("default") : nullString;
auto value3 = dart_is_null(nullList) ? _GrowableList::(dart_int(0)) : nullList;
dart_print(dart_string("  空值合并:"));
dart_print(dart_concat(dart_string("    nullInt ?? 0: "), value1));
dart_print(dart_concat(dart_string("    nullString ?? default: "), value2));
dart_print(dart_concat(dart_string("    nullList ?? []: "), value3));
Int testInt;
dart_is_null(testInt) ? testInt = dart_int(42) : Null;
dart_print(dart_concat(dart_string("    testInt ??= 42: "), testInt));
dart_is_null(testInt) ? testInt = dart_int(100) : Null;
dart_print(dart_concat(dart_string("    testInt ??= 100: "), testInt));
auto name = dart_string("Alice");
auto length1 = dart_is_null(name) ? Null : name;
dart_print(dart_string("  空值安全访问:"));
dart_print(dart_concat(dart_string("    非空字符串长度: "), length1));
name = Null;
auto length2 = dart_is_null(name) ? Null : name;
dart_print(dart_concat(dart_string("    空字符串长度: "), length2));
auto person = ObjectPtr<Person>(new Person(dart_string("Bob"), ObjectPtr<Address>(new Address(dart_string("Main St"), ObjectPtr<City>(new City(dart_string("New York")))))));
auto cityName1 = dart_is_null(person) ? Null : dart_is_null(let_var->address) ? Null : dart_is_null(let_var->city) ? Null : person;
dart_print(dart_concat(dart_string("    链式访问城市名: "), cityName1));
person = Null;
auto cityName2 = dart_is_null(person) ? Null : dart_is_null(let_var->address) ? Null : dart_is_null(let_var->city) ? Null : person;
dart_print(dart_concat(dart_string("    空对象链式访问: "), cityName2));
auto maybeString = dart_string("Hello");
auto definitelyString = maybeString;
dart_print(dart_concat(dart_string("    空值断言: "), definitelyString));
try auto nullString = Null;
auto crashString = nullString;
dart_print(dart_concat(dart_string("    不会执行到这里: "), crashString)); catch (const std::exception& e) { /* catch block */ }
// Finally block should be implemented using RAII pattern;
return Void;
}

Nullable testDivisionAndOverflow() {
  dart_print(dart_string("\n📌 测试除零和溢出"));
dart_print(dart_string("  整数除零:"));
try auto result = dart_int(10).truncatingDivision(dart_int(0));
dart_print(dart_concat(dart_string("    10 ~/ 0 = "), result)); catch (const std::exception& e) { /* catch block */ }
// Finally block should be implemented using RAII pattern
dart_print(dart_string("  浮点数除零:"));
auto result1 = (dart_double(10.0) / dart_double(0.0));
auto result2 = (dart_double(-10.0) / dart_double(0.0));
auto result3 = (dart_double(0.0) / dart_double(0.0));
dart_print(dart_concat(dart_string("    10.0 / 0.0 = "), result1));
dart_print(dart_concat(dart_string("    -10.0 / 0.0 = "), result2));
dart_print(dart_concat(dart_string("    0.0 / 0.0 = "), result3));
dart_print(dart_string("  模运算边界:"));
try auto mod1 = (dart_int(10) % dart_int(0));
dart_print(dart_concat(dart_string("    10 % 0 = "), mod1)); catch (const std::exception& e) { /* catch block */ }
// Finally block should be implemented using RAII pattern
dart_print(dart_concat(dart_string("    10 % 3 = "), (dart_int(10) % dart_int(3))));
dart_print(dart_concat(dart_string("    10 % -3 = "), (dart_int(10) % dart_int(-3))));
dart_print(dart_concat(dart_string("    -10 % 3 = "), (dart_int(-10) % dart_int(3))));
dart_print(dart_concat(dart_string("    -10 % -3 = "), (dart_int(-10) % dart_int(-3))));
dart_print(dart_string("  大数运算:"));
auto bigInt1 = dart_int(9223372036854775807);
auto bigInt2 = dart_int(1);
dart_print(dart_concat(dart_string("    大整数: "), bigInt1));
auto sum = (bigInt1 + bigInt2);
dart_print(dart_concat(dart_string("    大整数 + 1: "), sum, dart_string(" (类型: "), sum.runtimeType, dart_string(")")));
dart_print(dart_string("  浮点数精度:"));
auto precise1 = (dart_double(0.1) + dart_double(0.2));
dart_print(dart_concat(dart_string("    0.1 + 0.2 = "), precise1));
dart_print(dart_concat(dart_string("    是否等于0.3: "), (precise1 == dart_double(0.3))));
auto verySmall = dart_double(1e-100);
auto veryLarge = dart_double(1e+100);
dart_print(dart_concat(dart_string("    很小的数: "), verySmall));
dart_print(dart_concat(dart_string("    很大的数: "), veryLarge));
dart_print(dart_string("  无穷大运算:"));
auto inf = dart_double(Infinity);
dart_print(dart_concat(dart_string("    infinity + 1: "), (inf + dart_int(1))));
dart_print(dart_concat(dart_string("    infinity - infinity: "), (inf - inf)));
dart_print(dart_concat(dart_string("    infinity / infinity: "), (inf / inf)));
dart_print(dart_concat(dart_string("    infinity * 0: "), (inf * dart_int(0))));
return Void;
}

Nullable testTypeConversionEdges() {
  dart_print(dart_string("\n📌 测试类型转换边界"));
dart_print(dart_string("  字符串转数字:"));
try auto parsed1 = int::parse(dart_string("123"));
dart_print(dart_concat(dart_string("    parse \"123\": "), parsed1)); catch (const std::exception& e) { /* catch block */ }
// Finally block should be implemented using RAII pattern
try auto parsed2 = int::parse(dart_string(""));
dart_print(dart_concat(dart_string("    parse 空字符串: "), parsed2)); catch (const std::exception& e) { /* catch block */ }
// Finally block should be implemented using RAII pattern
try auto parsed3 = int::parse(dart_string("abc"));
dart_print(dart_concat(dart_string("    parse \"abc\": "), parsed3)); catch (const std::exception& e) { /* catch block */ }
// Finally block should be implemented using RAII pattern
dart_print(dart_string("  tryParse 安全转换:"));
auto safe1 = int::tryParse(dart_string("123"));
auto safe2 = int::tryParse(dart_string("abc"));
auto safe3 = int::tryParse(dart_string(""));
dart_print(dart_concat(dart_string("    tryParse \"123\": "), safe1));
dart_print(dart_concat(dart_string("    tryParse \"abc\": "), safe2));
dart_print(dart_concat(dart_string("    tryParse 空字符串: "), safe3));
dart_print(dart_string("  浮点数转换:"));
auto float1 = double::tryParse(dart_string("3.14"));
auto float2 = double::tryParse(dart_string("abc"));
auto float3 = double::tryParse(dart_string("infinity"));
auto float4 = double::tryParse(dart_string("nan"));
dart_print(dart_concat(dart_string("    tryParse \"3.14\": "), float1));
dart_print(dart_concat(dart_string("    tryParse \"abc\": "), float2));
dart_print(dart_concat(dart_string("    tryParse \"infinity\": "), float3));
dart_print(dart_concat(dart_string("    tryParse \"nan\": "), float4));
dart_print(dart_string("  类型转换 as:"));
auto value1 = dart_int(42);
auto value2 = dart_string("hello");
try auto intValue = dart_cast<Int>(value1);
dart_print(dart_concat(dart_string("    42 as int: "), intValue)); catch (const std::exception& e) { /* catch block */ }
// Finally block should be implemented using RAII pattern
try auto intValue = dart_cast<Int>(value2);
dart_print(dart_concat(dart_string("    \"hello\" as int: "), intValue)); catch (const std::exception& e) { /* catch block */ }
// Finally block should be implemented using RAII pattern
dart_print(dart_string("  类型检查 is:"));
dart_print(dart_concat(dart_string("    42 is int: "), dart_is<Int>(value1)));
dart_print(dart_concat(dart_string("    42 is String: "), dart_is<String>(value1)));
dart_print(dart_concat(dart_string("    \"hello\" is String: "), dart_is<String>(value2)));
dart_print(dart_concat(dart_string("    \"hello\" is int: "), dart_is<Int>(value2)));
dart_print(dart_string("  数值转换边界:"));
auto bigDouble = dart_double(100000000000000000000.0);
auto convertedInt = bigDouble.toInt();
dart_print(dart_concat(dart_string("    大浮点数转整数: "), bigDouble, dart_string(" -> "), convertedInt));
auto smallDouble = dart_double(0.9);
auto truncatedInt = smallDouble.toInt();
dart_print(dart_concat(dart_string("    小数转整数: "), smallDouble, dart_string(" -> "), truncatedInt));
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
