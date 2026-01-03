#include "dart2cpp.h"

// 工具宏定义

// ============================================================================
// 类: Animal
// ============================================================================

class Animal {
public:
  String name;
  Animal(String name) : name(name) {
  }
  
};

// ============================================================================
// 类: Dog
// ============================================================================

class Dog : public Animal {
public:
  Dog(String name) : Animal(name) {
  }
  
};

// ============================================================================
// 类: Cat
// ============================================================================

class Cat : public Animal {
public:
  Cat(String name) : Animal(name) {
  }
  
};

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

// ============================================================================
// 类: NumberProcessor
// ============================================================================

template<typename T>
class NumberProcessor {
public:
  NumberProcessor() {
  }
  
  T process(T value) {
    return value;
  }
  
};

Nullable testAsExpressions();
Nullable testIsTypeChecks();
Nullable testTypeConversionMethods();
Nullable testNullSafetyConversions();
Nullable testDynamicTypeHandling();
Nullable testGenericTypeConversions();
template<typename T>
ObjectPtr<List<T>> createList(T first, T second);
Nullable testAsExpressions() {
  dart_print(dart_string("\n📌 测试 as 表达式"));
Any value1 = dart_int(42);
Any value2 = dart_string("hello");
Any value3 = dart_literal<Int>(dart_int(1), dart_int(2), dart_int(3));
Any value4 = Map<String, String>::createFromEntries({{dart_string("key"), dart_string("value")}});
dart_print(dart_string("  基本 as 转换:"));
try {
auto intValue = dart_cast<Int>(value1);
dart_print(dart_string("    42 as int: ") + (intValue).toString());
} catch (const std::exception& e) { /* catch block */ }
// Finally block should be implemented using RAII pattern
try {
auto stringValue = dart_cast<String>(value2);
dart_print(dart_string("    \"hello\" as String: ") + (stringValue).toString());
} catch (const std::exception& e) { /* catch block */ }
// Finally block should be implemented using RAII pattern
try {
auto listValue = dart_cast<ObjectPtr<List<Int>>>(value3);
dart_print(dart_string("    [1,2,3] as List<int>: ") + (listValue).toString());
} catch (const std::exception& e) { /* catch block */ }
// Finally block should be implemented using RAII pattern
dart_print(dart_string("  错误的 as 转换:"));
try {
auto wrongInt = dart_cast<Int>(value2);
dart_print(dart_string("    不应该执行到这里: ") + (wrongInt).toString());
} catch (const std::exception& e) { /* catch block */ }
// Finally block should be implemented using RAII pattern
try {
auto wrongString = dart_cast<String>(value1);
dart_print(dart_string("    不应该执行到这里: ") + (wrongString).toString());
} catch (const std::exception& e) { /* catch block */ }
// Finally block should be implemented using RAII pattern
dart_print(dart_string("  对象 as 转换:"));
auto animal = ObjectPtr<Dog>(new Dog(dart_string("Buddy")));
auto cat = ObjectPtr<Cat>(new Cat(dart_string("Whiskers")));
try {
auto dog = dart_cast<ObjectPtr<Dog>>(animal);
dart_print(dart_string("    Animal as Dog: ") + (dog->name).toString());
} catch (const std::exception& e) { /* catch block */ }
// Finally block should be implemented using RAII pattern
try {
auto wrongDog = dart_cast<ObjectPtr<Dog>>(cat);
dart_print(dart_string("    不应该执行到这里: ") + (wrongDog->name).toString());
} catch (const std::exception& e) { /* catch block */ }
// Finally block should be implemented using RAII pattern
dart_print(dart_string("  可空类型 as 转换:"));
Any nullValue = Null;
Any nonNullValue = dart_string("test");
try {
auto nullableString = dart_cast<String>(nullValue);
dart_print(dart_string("    null as String?: ") + (nullableString).toString());
} catch (const std::exception& e) { /* catch block */ }
// Finally block should be implemented using RAII pattern
try {
auto nonNullString = dart_cast<String>(nonNullValue);
dart_print(dart_string("    \"test\" as String: ") + (nonNullString).toString());
} catch (const std::exception& e) { /* catch block */ }
// Finally block should be implemented using RAII pattern;
return Void;
}

Nullable testIsTypeChecks() {
  dart_print(dart_string("\n📌 测试 is 类型检查"));
Any value1 = dart_int(42);
Any value2 = dart_string("hello");
Any value3 = dart_literal<Int>(dart_int(1), dart_int(2), dart_int(3));
Any value4 = Map<String, String>::createFromEntries({{dart_string("key"), dart_string("value")}});
Any value5 = Null;
dart_print(dart_string("  基本类型检查:"));
dart_print(dart_string("    42 is int: ") + (dart_is<Int>(value1)).toString());
dart_print(dart_string("    42 is String: ") + (dart_is<String>(value1)).toString());
dart_print(dart_string("    \"hello\" is String: ") + (dart_is<String>(value2)).toString());
dart_print(dart_string("    \"hello\" is int: ") + (dart_is<Int>(value2)).toString());
dart_print(dart_string("    [1,2,3] is List: ") + (dart_is<ObjectPtr<List<Any>>>(value3)).toString());
dart_print(dart_string("    [1,2,3] is List<int>: ") + (dart_is<ObjectPtr<List<Int>>>(value3)).toString());
dart_print(dart_string("    Map is Map: ") + (dart_is<ObjectPtr<Map<Any, Any>>>(value4)).toString());
dart_print(dart_string("    null is String: ") + (dart_is<String>(value5)).toString());
dart_print(dart_string("    null is String?: ") + (dart_is<String>(value5)).toString());
dart_print(dart_string("  对象类型检查:"));
auto animal = ObjectPtr<Dog>(new Dog(dart_string("Buddy")));
auto dog = ObjectPtr<Dog>(new Dog(dart_string("Max")));
auto cat = ObjectPtr<Cat>(new Cat(dart_string("Whiskers")));
dart_print(dart_string("    Dog is Animal: ") + (dart_is<ObjectPtr<Animal>>(dog)).toString());
dart_print(dart_string("    Dog is Dog: ") + (dart_is<ObjectPtr<Dog>>(dog)).toString());
dart_print(dart_string("    Dog is Cat: ") + (dart_is<ObjectPtr<Cat>>(dog)).toString());
dart_print(dart_string("    Cat is Animal: ") + (dart_is<ObjectPtr<Animal>>(cat)).toString());
dart_print(dart_string("    Cat is Dog: ") + (dart_is<ObjectPtr<Dog>>(cat)).toString());
dart_print(dart_string("    Animal(Dog) is Dog: ") + (dart_is<ObjectPtr<Dog>>(animal)).toString());
dart_print(dart_string("    Animal(Dog) is Cat: ") + (dart_is<ObjectPtr<Cat>>(animal)).toString());
dart_print(dart_string("  智能转换:"));
Any unknownValue = dart_string("Hello World");
if (dart_is<String>(unknownValue)) {
auto unknownValue_promoted = dart_cast<String>(unknownValue);
dart_print(dart_string("    智能转换为String: ") + (DART_ANY_CALL(unknownValue_promoted, toUpperCase)).toString());
dart_print(dart_string("    字符串长度: ") + (DART_ANY_CALL(unknownValue_promoted, length)).toString());
}
unknownValue = dart_literal<Int>(dart_int(1), dart_int(2), dart_int(3), dart_int(4), dart_int(5));
if (dart_is<ObjectPtr<List<Int>>>(unknownValue)) {
auto unknownValue_promoted = dart_cast<ObjectPtr<List<Int>>>(unknownValue);
dart_print(dart_string("    智能转换为List<int>: ") + (DART_ANY_CALL(unknownValue_promoted, first)).toString());
dart_print(dart_string("    列表长度: ") + (DART_ANY_CALL(unknownValue_promoted, length)).toString());
}
dart_print(dart_string("  否定类型检查:"));
Any testValue = dart_int(42);
if (!(dart_is<String>(testValue))) {
dart_print(dart_string("    42 不是 String"));
}
if (!(dart_is_null(testValue))) {
dart_print(dart_string("    42 不是 null"));
}
dart_print(dart_string("  复杂类型检查:"));
auto mixedList = dart_literal<Int>(dart_int(1), dart_string("hello"), dart_literal<Int>(dart_int(1), dart_int(2)), Map<String, String>::createFromEntries({{dart_string("key"), dart_string("value")}}));
auto sync_for_iterator = mixedList->iterator();
for (; sync_for_iterator->hasNext(); ) {
Any item = sync_for_iterator->next();
if (dart_is<Int>(item)) {
auto item_promoted = dart_cast<Int>(item);
dart_print(dart_string("    整数: ") + (item_promoted).toString());
} else {
if (dart_is<String>(item)) {
auto item_promoted = dart_cast<String>(item);
dart_print(dart_string("    字符串: ") + (item_promoted).toString());
} else {
if (dart_is<ObjectPtr<List<Any>>>(item)) {
auto item_promoted = dart_cast<ObjectPtr<List<Any>>>(item);
dart_print(dart_string("    列表: ") + (item_promoted).toString());
} else {
if (dart_is<ObjectPtr<Map<Any, Any>>>(item)) {
auto item_promoted = dart_cast<ObjectPtr<Map<Any, Any>>>(item);
dart_print(dart_string("    映射: ") + (item_promoted).toString());
} else {
dart_print(dart_string("    未知类型: ") + (item).toString());
}
}
}
}
};
return Void;
}

Nullable testTypeConversionMethods() {
  dart_print(dart_string("\n📌 测试类型转换方法"));
dart_print(dart_string("  数字类型转换:"));
auto intValue = dart_int(42);
auto doubleValue = dart_double(3.14159);
dart_print(dart_string("    int转double: ") + (intValue->toDouble()).toString());
dart_print(dart_string("    double转int: ") + (doubleValue->toInt()).toString());
dart_print(dart_string("    double转int(截断): ") + (doubleValue->truncate()).toString());
dart_print(dart_string("    double转int(向上取整): ") + (doubleValue->ceil()).toString());
dart_print(dart_string("    double转int(向下取整): ") + (doubleValue->floor()).toString());
dart_print(dart_string("    double转int(四舍五入): ") + (doubleValue->round()).toString());
dart_print(dart_string("  字符串转换:"));
dart_print(dart_string("    int转String: ") + (intValue->toString()).toString());
dart_print(dart_string("    double转String: ") + (doubleValue->toString()).toString());
dart_print(dart_string("    bool转String: ") + (dart_bool(true)->toString()).toString());
dart_print(dart_string("  字符串解析:"));
auto intString = dart_string("123");
auto doubleString = dart_string("3.14");
auto boolString = dart_string("true");
auto invalidString = dart_string("abc");
try {
auto parsedInt = Int::parse(intString, Null, Null);
dart_print(dart_string("    parse \"123\": ") + (parsedInt).toString());
} catch (const std::exception& e) { /* catch block */ }
// Finally block should be implemented using RAII pattern
try {
auto parsedDouble = Double::parse(doubleString);
dart_print(dart_string("    parse \"3.14\": ") + (parsedDouble).toString());
} catch (const std::exception& e) { /* catch block */ }
// Finally block should be implemented using RAII pattern
try {
auto invalidInt = Int::parse(invalidString, Null, Null);
dart_print(dart_string("    不应该执行到这里: ") + (invalidInt).toString());
} catch (const std::exception& e) { /* catch block */ }
// Finally block should be implemented using RAII pattern
dart_print(dart_string("  安全解析:"));
auto safeInt1 = Int::tryParse(intString, Null);
auto safeInt2 = Int::tryParse(invalidString, Null);
auto safeDouble1 = Double::tryParse(doubleString);
auto safeDouble2 = Double::tryParse(invalidString);
dart_print(dart_string("    tryParse \"123\": ") + (safeInt1).toString());
dart_print(dart_string("    tryParse \"abc\": ") + (safeInt2).toString());
dart_print(dart_string("    tryParse \"3.14\": ") + (safeDouble1).toString());
dart_print(dart_string("    tryParse \"abc\": ") + (safeDouble2).toString());
dart_print(dart_string("  进制转换:"));
auto decimal = dart_int(255);
dart_print(dart_string("    255转16进制: ") + (decimal->toRadixString(dart_int(16))).toString());
dart_print(dart_string("    255转8进制: ") + (decimal->toRadixString(dart_int(8))).toString());
dart_print(dart_string("    255转2进制: ") + (decimal->toRadixString(dart_int(2))).toString());
try {
auto fromHex = Int::parse(dart_string("FF"), dart_int(16), Null);
dart_print(dart_string("    16进制FF转10进制: ") + (fromHex).toString());
} catch (const std::exception& e) { /* catch block */ }
// Finally block should be implemented using RAII pattern
dart_print(dart_string("  集合转换:"));
auto list = dart_literal<Int>(dart_int(1), dart_int(2), dart_int(3), dart_int(4), dart_int(5));
auto set = ([&]() { const auto unnamed_var = ObjectPtr<Set<Int>>(new Set<Int>()); unnamed_var->add(dart_int(1)); unnamed_var->add(dart_int(2)); unnamed_var->add(dart_int(3)); unnamed_var->add(dart_int(4)); unnamed_var->add(dart_int(5)); return unnamed_var; })();
auto listToSet = list->toSet();
auto setToList = set->toList();
dart_print(dart_string("    List转Set: ") + (listToSet).toString());
dart_print(dart_string("    Set转List: ") + (setToList).toString());
auto text = dart_string("Hello");
auto charCodes = text->get_codeUnits();
auto fromCodes = String::fromCharCodes(charCodes, dart_int(0), Null);
dart_print(dart_string("    String转字符码: ") + (charCodes).toString());
dart_print(dart_string("    字符码转String: ") + (fromCodes).toString());
return Void;
}

Nullable testNullSafetyConversions() {
  dart_print(dart_string("\n📌 测试空安全转换"));
auto nullableString = dart_string("Hello");
auto nullString = Null;
dart_print(dart_string("  可空类型转换:"));
auto nonNull1 = dart_null_coalesce(nullableString, dart_string("default"));
auto nonNull2 = dart_null_coalesce(nullString, dart_string("default"));
dart_print(dart_string("    \"Hello\" ?? \"default\": ") + (nonNull1).toString());
dart_print(dart_string("    null ?? \"default\": ") + (nonNull2).toString());
String testString(Null);
if (dart_is_null(testString)) testString = dart_string("assigned");
dart_print(dart_string("    null ??= \"assigned\": ") + (testString).toString());
if (dart_is_null(testString)) testString = dart_string("not assigned");
dart_print(dart_string("    \"assigned\" ??= \"not assigned\": ") + (testString).toString());
auto maybeString = dart_string("Hello World");
auto length1 = dart_null_coalesce(maybeString, Null);
dart_print(dart_string("    \"Hello World\"?.length: ") + (length1).toString());
maybeString = Null;
auto length2 = dart_null_coalesce(maybeString, Null);
dart_print(dart_string("    null?.length: ") + (length2).toString());
auto person = ObjectPtr<Person>(new Person(dart_string("Alice"), ObjectPtr<Address>(new Address(dart_string("Main St"), ObjectPtr<City>(new City(dart_string("New York")))))));
auto cityName1 = ([&]() { auto let_var = person; return dart_is_null(let_var) ? Null : ([&]() { auto let_var = let_var->address; return dart_is_null(let_var) ? Null : dart_null_coalesce(let_var->city, Null); })(); })();
dart_print(dart_string("    链式访问城市名: ") + (cityName1).toString());
person = Null;
auto cityName2 = ([&]() { auto let_var = person; return dart_is_null(let_var) ? Null : ([&]() { auto let_var = let_var->address; return dart_is_null(let_var) ? Null : dart_null_coalesce(let_var->city, Null); })(); })();
dart_print(dart_string("    null对象链式访问: ") + (cityName2).toString());
dart_print(dart_string("  空值断言:"));
auto definitelyNotNull = dart_string("Definitely not null");
auto assertedString = definitelyNotNull;
dart_print(dart_string("    空值断言成功: ") + (assertedString).toString());
try {
auto definitelyNull = Null;
auto crashString = definitelyNull;
dart_print(dart_string("    不应该执行到这里: ") + (crashString).toString());
} catch (const std::exception& e) { /* catch block */ }
// Finally block should be implemented using RAII pattern
dart_print(dart_string("  类型提升:"));
auto promotableString = dart_string("Hello");
if (!(dart_is_null(promotableString))) {
dart_print(dart_string("    提升后的字符串: ") + (promotableString->toUpperCase()).toString());
dart_print(dart_string("    提升后的长度: ") + (promotableString->size()).toString());
}
dart_print(dart_string("  late 变量:"));
std::optional<String> lateString_storage; auto& lateString = [&]() -> String& { if (!lateString_storage.has_value()) throw std::runtime_error("Late variable 'lateString' not initialized"); return lateString_storage.value(); }();
lateString = dart_string("Late initialized");
dart_print(dart_string("    late变量: ") + (lateString).toString());
mutable std::optional<String> lateFinalString_storage; const auto& lateFinalString = [&]() -> const String& { if (!lateFinalString_storage.has_value()) throw std::runtime_error("Late variable 'lateFinalString' not initialized"); return lateFinalString_storage.value(); }();
lateFinalString = dart_string("Late final initialized");
dart_print(dart_string("    late final变量: ") + (lateFinalString).toString());
return Void;
}

Nullable testDynamicTypeHandling() {
  dart_print(dart_string("\n📌 测试动态类型处理"));
Any dynamicVar = dart_int(42);
dart_print(dart_string("  动态类型处理:"));
dart_print(dart_string("    初始值(int): ") + (dynamicVar).toString());
dynamicVar = dart_string("Hello");
dart_print(dart_string("    改为String: ") + (dynamicVar).toString());
dynamicVar = dart_literal<Int>(dart_int(1), dart_int(2), dart_int(3));
dart_print(dart_string("    改为List: ") + (dynamicVar).toString());
dynamicVar = Map<String, String>::createFromEntries({{dart_string("key"), dart_string("value")}});
dart_print(dart_string("    改为Map: ") + (dynamicVar).toString());
dart_print(dart_string("  动态方法调用:"));
Any stringDynamic = dart_string("hello world");
dart_print(dart_string("    动态String方法: ") + (stringDynamic.toUpperCase()).toString());
Any listDynamic = dart_literal<Int>(dart_int(1), dart_int(2), dart_int(3), dart_int(4), dart_int(5));
dart_print(dart_string("    动态List方法: ") + (listDynamic.length).toString());
dart_print(dart_string("  Object 类型:"));
auto objectVar = dart_int(42);
dart_print(dart_string("    Object(int): ") + (objectVar).toString());
dart_print(dart_string("    Object类型: ") + (objectVar->get_runtimeType()).toString());
objectVar = dart_string("Hello");
dart_print(dart_string("    Object(String): ") + (objectVar).toString());
dart_print(dart_string("    Object类型: ") + (objectVar->get_runtimeType()).toString());
dart_print(dart_string("  运行时类型:"));
auto runtimeVar = dart_int(42);
dart_print(dart_string("    变量类型: ") + (runtimeVar->get_runtimeType()).toString());
runtimeVar = dart_cast<Int>(dart_cast<Any>(dart_string("Hello")));
dart_print(dart_string("    变量类型: ") + (runtimeVar->get_runtimeType()).toString());
dart_print(dart_string("  类型安全的动态调用:"));
Any unknownObject = dart_string("Hello World");
if (dart_is<String>(unknownObject)) {
auto unknownObject_promoted = dart_cast<String>(unknownObject);
dart_print(dart_string("    作为String处理: ") + (DART_ANY_CALL(unknownObject_promoted, toLowerCase)).toString());
} else {
if (dart_is<Int>(unknownObject)) {
auto unknownObject_promoted = dart_cast<Int>(unknownObject);
dart_print(dart_string("    作为int处理: ") + (unknownObject_promoted->operator_add(dart_int(10))).toString());
} else {
if (dart_is<ObjectPtr<List<Any>>>(unknownObject)) {
auto unknownObject_promoted = dart_cast<ObjectPtr<List<Any>>>(unknownObject);
dart_print(dart_string("    作为List处理: 长度") + (DART_ANY_CALL(unknownObject_promoted, length)).toString());
}
}
}
dart_print(dart_string("  函数类型转换:"));
Any functionVar = makeFunction([&](Int x) { return x->operator_mul(dart_int(2)); });
if (dart_is<ObjectPtr<Function>>(functionVar)) {
auto functionVar_promoted = dart_cast<ObjectPtr<Function>>(functionVar);
dart_print(dart_string("    是函数类型"));
if (dart_is<ObjectPtr<TypedFunction<std::function<Int(Int)>, Int, Int>>>(functionVar_promoted)) {
auto functionVar_promoted = dart_cast<ObjectPtr<TypedFunction<std::function<Int(Int)>, Int, Int>>>(functionVar);
auto result = functionVar_promoted->call(dart_int(5));
dart_print(dart_string("    函数调用结果: ") + (result).toString());
}
};
return Void;
}

Nullable testGenericTypeConversions() {
  dart_print(dart_string("\n📌 测试泛型类型转换"));
dart_print(dart_string("  泛型集合转换:"));
auto dynamicList = dart_literal<Int>(dart_int(1), dart_int(2), dart_int(3), dart_int(4), dart_int(5));
if (dynamicList->every(makeFunction([&](Any item) { return dart_is<Int>(item); }))) {
auto intList = dynamicList->cast();
dart_print(dart_string("    dynamic List转int List: ") + (intList).toString());
}
auto numList = dart_literal<Int>(dart_int(1), dart_double(2.5), dart_int(3), dart_double(4.7), dart_int(5));
auto intList = numList->whereType()->toList();
auto doubleList = numList->whereType()->toList();
dart_print(dart_string("    num List中的int: ") + (intList).toString());
dart_print(dart_string("    num List中的double: ") + (doubleList).toString());
dart_print(dart_string("  泛型类型检查:"));
auto objectList = dart_literal<Any>(dart_int(1), dart_string("hello"), dart_double(3.14), dart_bool(true));
auto sync_for_iterator = objectList->iterator();
for (; sync_for_iterator->hasNext(); ) {
auto item = sync_for_iterator->next();
if (dart_is<Int>(item)) {
auto item_promoted = dart_cast<Int>(item);
dart_print(dart_string("    整数: ") + (item_promoted).toString());
} else {
if (dart_is<String>(item)) {
auto item_promoted = dart_cast<String>(item);
dart_print(dart_string("    字符串: ") + (item_promoted).toString());
} else {
if (dart_is<Double>(item)) {
auto item_promoted = dart_cast<Double>(item);
dart_print(dart_string("    浮点数: ") + (item_promoted).toString());
} else {
if (dart_is<Bool>(item)) {
auto item_promoted = dart_cast<Bool>(item);
dart_print(dart_string("    布尔值: ") + (item_promoted).toString());
}
}
}
}
}
dart_print(dart_string("  协变和逆变:"));
auto dogList = dart_literal<ObjectPtr<Dog>>(ObjectPtr<Dog>(new Dog(dart_string("Buddy"))), ObjectPtr<Dog>(new Dog(dart_string("Max"))));
auto animalList = dogList;
dart_print(dart_string("    Dog List作为Animal List: ") + (animalList->size()).toString());
dart_print(dart_string("  泛型方法类型推断:"));
auto inferredList = createList(dart_string("hello"), dart_string("world"));
dart_print(dart_string("    推断的列表类型: ") + (inferredList->get_runtimeType()).toString());
dart_print(dart_string("    推断的列表内容: ") + (inferredList).toString());
auto inferredIntList = createList(dart_int(1), dart_int(2));
dart_print(dart_string("    推断的int列表: ") + (inferredIntList->get_runtimeType()).toString());
dart_print(dart_string("    推断的int列表内容: ") + (inferredIntList).toString());
dart_print(dart_string("  类型参数约束:"));
auto numberProcessor = ObjectPtr<NumberProcessor<Int>>(new NumberProcessor<Int>());
dart_print(dart_string("    int处理器: ") + (numberProcessor->process(dart_int(42))).toString());
auto doubleProcessor = ObjectPtr<NumberProcessor<Double>>(new NumberProcessor<Double>());
dart_print(dart_string("    double处理器: ") + (doubleProcessor->process(dart_double(3.14))).toString());
return Void;
}

template<typename T>
ObjectPtr<List<T>> createList(T first, T second) {
  return dart_literal<Any>(first, second);
}

// ============================================================================
// 主函数
// ============================================================================

int main() {
  try {
    dart_print(dart_string("🔥 类型转换测试开始"));
testAsExpressions();
testIsTypeChecks();
testTypeConversionMethods();
testNullSafetyConversions();
testDynamicTypeHandling();
testGenericTypeConversions();
dart_print(dart_string("✅ 类型转换测试完成"));
    return 0;
  } catch (const std::exception& e) {
    std::cerr << "Error: " << e.what() << std::endl;
    return 1;
  }
}
