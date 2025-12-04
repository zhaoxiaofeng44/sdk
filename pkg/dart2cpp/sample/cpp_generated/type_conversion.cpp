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

// ============================================================================
// 类: NumberProcessor
// ============================================================================

class NumberProcessor {
public:
  NumberProcessor() {
  }
  
  Any process(Any value) {
    return value;
  }
  
};

Nullable testAsExpressions() {
  dart_print(dart_string("\n📌 测试 as 表达式"));
auto value1 = dart_int(42);
auto value2 = dart_string("hello");
auto value3 = dart_literal(dart_int(1), dart_int(2), dart_int(3));
auto value4 = Map<String, String>::createFromEntries({{dart_string("key"), dart_string("value")}});
dart_print(dart_string("  基本 as 转换:"));
try auto intValue = dart_cast<Int>(value1);
dart_print(dart_concat(dart_string("    42 as int: "), intValue)); catch (const std::exception& e) { /* catch block */ }
// Finally block should be implemented using RAII pattern
try auto stringValue = dart_cast<String>(value2);
dart_print(dart_concat(dart_string("    \"hello\" as String: "), stringValue)); catch (const std::exception& e) { /* catch block */ }
// Finally block should be implemented using RAII pattern
try auto listValue = dart_cast<List<Int>>(value3);
dart_print(dart_concat(dart_string("    [1,2,3] as List<int>: "), listValue)); catch (const std::exception& e) { /* catch block */ }
// Finally block should be implemented using RAII pattern
dart_print(dart_string("  错误的 as 转换:"));
try auto wrongInt = dart_cast<Int>(value2);
dart_print(dart_concat(dart_string("    不应该执行到这里: "), wrongInt)); catch (const std::exception& e) { /* catch block */ }
// Finally block should be implemented using RAII pattern
try auto wrongString = dart_cast<String>(value1);
dart_print(dart_concat(dart_string("    不应该执行到这里: "), wrongString)); catch (const std::exception& e) { /* catch block */ }
// Finally block should be implemented using RAII pattern
dart_print(dart_string("  对象 as 转换:"));
auto animal = ObjectPtr<Dog>(new Dog(dart_string("Buddy")));
auto cat = ObjectPtr<Cat>(new Cat(dart_string("Whiskers")));
try auto dog = dart_cast<Dog>(animal);
dart_print(dart_concat(dart_string("    Animal as Dog: "), dog->name)); catch (const std::exception& e) { /* catch block */ }
// Finally block should be implemented using RAII pattern
try auto wrongDog = dart_cast<Dog>(cat);
dart_print(dart_concat(dart_string("    不应该执行到这里: "), wrongDog->name)); catch (const std::exception& e) { /* catch block */ }
// Finally block should be implemented using RAII pattern
dart_print(dart_string("  可空类型 as 转换:"));
auto nullValue = Null;
auto nonNullValue = dart_string("test");
try auto nullableString = dart_cast<String>(nullValue);
dart_print(dart_concat(dart_string("    null as String?: "), nullableString)); catch (const std::exception& e) { /* catch block */ }
// Finally block should be implemented using RAII pattern
try auto nonNullString = dart_cast<String>(nonNullValue);
dart_print(dart_concat(dart_string("    \"test\" as String: "), nonNullString)); catch (const std::exception& e) { /* catch block */ }
// Finally block should be implemented using RAII pattern;
return Void;
}

Nullable testIsTypeChecks() {
  dart_print(dart_string("\n📌 测试 is 类型检查"));
auto value1 = dart_int(42);
auto value2 = dart_string("hello");
auto value3 = dart_literal(dart_int(1), dart_int(2), dart_int(3));
auto value4 = Map<String, String>::createFromEntries({{dart_string("key"), dart_string("value")}});
auto value5 = Null;
dart_print(dart_string("  基本类型检查:"));
dart_print(dart_concat(dart_string("    42 is int: "), dart_is<Int>(value1)));
dart_print(dart_concat(dart_string("    42 is String: "), dart_is<String>(value1)));
dart_print(dart_concat(dart_string("    \"hello\" is String: "), dart_is<String>(value2)));
dart_print(dart_concat(dart_string("    \"hello\" is int: "), dart_is<Int>(value2)));
dart_print(dart_concat(dart_string("    [1,2,3] is List: "), dart_is<List<Any>>(value3)));
dart_print(dart_concat(dart_string("    [1,2,3] is List<int>: "), dart_is<List<Int>>(value3)));
dart_print(dart_concat(dart_string("    Map is Map: "), dart_is<Map<Any, Any>>(value4)));
dart_print(dart_concat(dart_string("    null is String: "), dart_is<String>(value5)));
dart_print(dart_concat(dart_string("    null is String?: "), dart_is<String>(value5)));
dart_print(dart_string("  对象类型检查:"));
auto animal = ObjectPtr<Dog>(new Dog(dart_string("Buddy")));
auto dog = ObjectPtr<Dog>(new Dog(dart_string("Max")));
auto cat = ObjectPtr<Cat>(new Cat(dart_string("Whiskers")));
dart_print(dart_concat(dart_string("    Dog is Animal: "), dart_is<Animal>(dog)));
dart_print(dart_concat(dart_string("    Dog is Dog: "), dart_is<Dog>(dog)));
dart_print(dart_concat(dart_string("    Dog is Cat: "), dart_is<Cat>(dog)));
dart_print(dart_concat(dart_string("    Cat is Animal: "), dart_is<Animal>(cat)));
dart_print(dart_concat(dart_string("    Cat is Dog: "), dart_is<Dog>(cat)));
dart_print(dart_concat(dart_string("    Animal(Dog) is Dog: "), dart_is<Dog>(animal)));
dart_print(dart_concat(dart_string("    Animal(Dog) is Cat: "), dart_is<Cat>(animal)));
dart_print(dart_string("  智能转换:"));
auto unknownValue = dart_string("Hello World");
if (dart_is<String>(unknownValue)) {
dart_print(dart_concat(dart_string("    智能转换为String: "), unknownValue.toUpperCase()));
dart_print(dart_concat(dart_string("    字符串长度: "), unknownValue.get_length()));
}
unknownValue = dart_literal(dart_int(1), dart_int(2), dart_int(3), dart_int(4), dart_int(5));
if (dart_is<List<Int>>(unknownValue)) {
dart_print(dart_concat(dart_string("    智能转换为List<int>: "), unknownValue.first));
dart_print(dart_concat(dart_string("    列表长度: "), unknownValue.get_length()));
}
dart_print(dart_string("  否定类型检查:"));
auto testValue = dart_int(42);
if (!(dart_is<String>(testValue))) {
dart_print(dart_string("    42 不是 String"));
}
if (!(dart_is<Any>(testValue))) {
dart_print(dart_string("    42 不是 null"));
}
dart_print(dart_string("  复杂类型检查:"));
auto mixedList = dart_literal(dart_int(1), dart_string("hello"), dart_literal(dart_int(1), dart_int(2)), Map<String, String>::createFromEntries({{dart_string("key"), dart_string("value")}}));
auto sync_for_iterator = mixedList->iterator;
for (; sync_for_iterator->moveNext(); ) {
auto item = sync_for_iterator->current;
if (dart_is<Int>(item)) {
dart_print(dart_concat(dart_string("    整数: "), item));
} else {
if (dart_is<String>(item)) {
dart_print(dart_concat(dart_string("    字符串: "), item));
} else {
if (dart_is<List<Any>>(item)) {
dart_print(dart_concat(dart_string("    列表: "), item));
} else {
if (dart_is<Map<Any, Any>>(item)) {
dart_print(dart_concat(dart_string("    映射: "), item));
} else {
dart_print(dart_concat(dart_string("    未知类型: "), item));
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
dart_print(dart_concat(dart_string("    int转double: "), intValue.toDouble()));
dart_print(dart_concat(dart_string("    double转int: "), doubleValue.toInt()));
dart_print(dart_concat(dart_string("    double转int(截断): "), doubleValue.truncate()));
dart_print(dart_concat(dart_string("    double转int(向上取整): "), doubleValue.ceil()));
dart_print(dart_concat(dart_string("    double转int(向下取整): "), doubleValue.floor()));
dart_print(dart_concat(dart_string("    double转int(四舍五入): "), doubleValue.round()));
dart_print(dart_string("  字符串转换:"));
dart_print(dart_concat(dart_string("    int转String: "), intValue.toString()));
dart_print(dart_concat(dart_string("    double转String: "), doubleValue.toString()));
dart_print(dart_concat(dart_string("    bool转String: "), dart_bool(true).toString()));
dart_print(dart_string("  字符串解析:"));
auto intString = dart_string("123");
auto doubleString = dart_string("3.14");
auto boolString = dart_string("true");
auto invalidString = dart_string("abc");
try auto parsedInt = int::parse(intString);
dart_print(dart_concat(dart_string("    parse \"123\": "), parsedInt)); catch (const std::exception& e) { /* catch block */ }
// Finally block should be implemented using RAII pattern
try auto parsedDouble = double::parse(doubleString);
dart_print(dart_concat(dart_string("    parse \"3.14\": "), parsedDouble)); catch (const std::exception& e) { /* catch block */ }
// Finally block should be implemented using RAII pattern
try auto invalidInt = int::parse(invalidString);
dart_print(dart_concat(dart_string("    不应该执行到这里: "), invalidInt)); catch (const std::exception& e) { /* catch block */ }
// Finally block should be implemented using RAII pattern
dart_print(dart_string("  安全解析:"));
auto safeInt1 = int::tryParse(intString);
auto safeInt2 = int::tryParse(invalidString);
auto safeDouble1 = double::tryParse(doubleString);
auto safeDouble2 = double::tryParse(invalidString);
dart_print(dart_concat(dart_string("    tryParse \"123\": "), safeInt1));
dart_print(dart_concat(dart_string("    tryParse \"abc\": "), safeInt2));
dart_print(dart_concat(dart_string("    tryParse \"3.14\": "), safeDouble1));
dart_print(dart_concat(dart_string("    tryParse \"abc\": "), safeDouble2));
dart_print(dart_string("  进制转换:"));
auto decimal = dart_int(255);
dart_print(dart_concat(dart_string("    255转16进制: "), decimal.toRadixString(dart_int(16))));
dart_print(dart_concat(dart_string("    255转8进制: "), decimal.toRadixString(dart_int(8))));
dart_print(dart_concat(dart_string("    255转2进制: "), decimal.toRadixString(dart_int(2))));
try auto fromHex = int::parse(dart_string("FF"));
dart_print(dart_concat(dart_string("    16进制FF转10进制: "), fromHex)); catch (const std::exception& e) { /* catch block */ }
// Finally block should be implemented using RAII pattern
dart_print(dart_string("  集合转换:"));
auto list = dart_literal(dart_int(1), dart_int(2), dart_int(3), dart_int(4), dart_int(5));
auto set = ([&]() { const auto unnamed_var = ObjectPtr<_Set>(new _Set()); unnamed_var->add(dart_int(1)); unnamed_var->add(dart_int(2)); unnamed_var->add(dart_int(3)); unnamed_var->add(dart_int(4)); unnamed_var->add(dart_int(5)); return unnamed_var; })();
auto listToSet = list->toSet();
auto setToList = set->toList();
dart_print(dart_concat(dart_string("    List转Set: "), listToSet));
dart_print(dart_concat(dart_string("    Set转List: "), setToList));
auto text = dart_string("Hello");
auto charCodes = text.codeUnits;
auto fromCodes = String::fromCharCodes(charCodes);
dart_print(dart_concat(dart_string("    String转字符码: "), charCodes));
dart_print(dart_concat(dart_string("    字符码转String: "), fromCodes));
}

Nullable testNullSafetyConversions() {
  dart_print(dart_string("\n📌 测试空安全转换"));
auto nullableString = dart_string("Hello");
auto nullString = Null;
dart_print(dart_string("  可空类型转换:"));
auto nonNull1 = dart_is_null(nullableString) ? dart_string("default") : nullableString;
auto nonNull2 = dart_is_null(nullString) ? dart_string("default") : nullString;
dart_print(dart_concat(dart_string("    \"Hello\" ?? \"default\": "), nonNull1));
dart_print(dart_concat(dart_string("    null ?? \"default\": "), nonNull2));
String testString;
dart_is_null(testString) ? testString = dart_string("assigned") : Null;
dart_print(dart_concat(dart_string("    null ??= \"assigned\": "), testString));
dart_is_null(testString) ? testString = dart_string("not assigned") : Null;
dart_print(dart_concat(dart_string("    \"assigned\" ??= \"not assigned\": "), testString));
auto maybeString = dart_string("Hello World");
auto length1 = dart_is_null(maybeString) ? Null : maybeString;
dart_print(dart_concat(dart_string("    \"Hello World\"?.length: "), length1));
maybeString = Null;
auto length2 = dart_is_null(maybeString) ? Null : maybeString;
dart_print(dart_concat(dart_string("    null?.length: "), length2));
auto person = ObjectPtr<Person>(new Person(dart_string("Alice"), ObjectPtr<Address>(new Address(dart_string("Main St"), ObjectPtr<City>(new City(dart_string("New York")))))));
auto cityName1 = dart_is_null(person) ? Null : dart_is_null(let_var->address) ? Null : dart_is_null(let_var->city) ? Null : person;
dart_print(dart_concat(dart_string("    链式访问城市名: "), cityName1));
person = Null;
auto cityName2 = dart_is_null(person) ? Null : dart_is_null(let_var->address) ? Null : dart_is_null(let_var->city) ? Null : person;
dart_print(dart_concat(dart_string("    null对象链式访问: "), cityName2));
dart_print(dart_string("  空值断言:"));
auto definitelyNotNull = dart_string("Definitely not null");
auto assertedString = definitelyNotNull;
dart_print(dart_concat(dart_string("    空值断言成功: "), assertedString));
try auto definitelyNull = Null;
auto crashString = definitelyNull;
dart_print(dart_concat(dart_string("    不应该执行到这里: "), crashString)); catch (const std::exception& e) { /* catch block */ }
// Finally block should be implemented using RAII pattern
dart_print(dart_string("  类型提升:"));
auto promotableString = dart_string("Hello");
if (!(dart_is_null(promotableString))) {
dart_print(dart_concat(dart_string("    提升后的字符串: "), promotableString.toUpperCase()));
dart_print(dart_concat(dart_string("    提升后的长度: "), promotableString.get_length()));
}
dart_print(dart_string("  late 变量:"));
String lateString;
lateString = dart_string("Late initialized");
dart_print(dart_concat(dart_string("    late变量: "), lateString));
String lateFinalString;
lateFinalString = dart_string("Late final initialized");
dart_print(dart_concat(dart_string("    late final变量: "), lateFinalString));
return Void;
}

Nullable testDynamicTypeHandling() {
  dart_print(dart_string("\n📌 测试动态类型处理"));
auto dynamicVar = dart_int(42);
dart_print(dart_string("  动态类型处理:"));
dart_print(dart_concat(dart_string("    初始值(int): "), dynamicVar));
dynamicVar = dart_string("Hello");
dart_print(dart_concat(dart_string("    改为String: "), dynamicVar));
dynamicVar = dart_literal(dart_int(1), dart_int(2), dart_int(3));
dart_print(dart_concat(dart_string("    改为List: "), dynamicVar));
dynamicVar = Map<String, String>::createFromEntries({{dart_string("key"), dart_string("value")}});
dart_print(dart_concat(dart_string("    改为Map: "), dynamicVar));
dart_print(dart_string("  动态方法调用:"));
auto stringDynamic = dart_string("hello world");
dart_print(dart_concat(dart_string("    动态String方法: "), stringDynamic.toUpperCase()));
auto listDynamic = dart_literal(dart_int(1), dart_int(2), dart_int(3), dart_int(4), dart_int(5));
dart_print(dart_concat(dart_string("    动态List方法: "), listDynamic.length));
dart_print(dart_string("  Object 类型:"));
auto objectVar = dart_int(42);
dart_print(dart_concat(dart_string("    Object(int): "), objectVar));
dart_print(dart_concat(dart_string("    Object类型: "), objectVar.runtimeType));
objectVar = dart_string("Hello");
dart_print(dart_concat(dart_string("    Object(String): "), objectVar));
dart_print(dart_concat(dart_string("    Object类型: "), objectVar.runtimeType));
dart_print(dart_string("  运行时类型:"));
auto runtimeVar = dart_int(42);
dart_print(dart_concat(dart_string("    变量类型: "), runtimeVar.runtimeType));
runtimeVar = dart_cast<Int>(dart_cast<Any>(dart_string("Hello")));
dart_print(dart_concat(dart_string("    变量类型: "), runtimeVar.runtimeType));
dart_print(dart_string("  类型安全的动态调用:"));
auto unknownObject = dart_string("Hello World");
if (dart_is<String>(unknownObject)) {
dart_print(dart_concat(dart_string("    作为String处理: "), unknownObject.toLowerCase()));
} else {
if (dart_is<Int>(unknownObject)) {
dart_print(dart_concat(dart_string("    作为int处理: "), (unknownObject + dart_int(10))));
} else {
if (dart_is<List<Any>>(unknownObject)) {
dart_print(dart_concat(dart_string("    作为List处理: 长度"), unknownObject.get_length()));
}
}
}
dart_print(dart_string("  函数类型转换:"));
auto functionVar = [&](Int x) { return (x * dart_int(2)); };
if (dart_is<Function>(functionVar)) {
dart_print(dart_string("    是函数类型"));
if (dart_is<std::function<Int()>>(functionVar)) {
auto result = functionVar(dart_int(5));
dart_print(dart_concat(dart_string("    函数调用结果: "), result));
}
}
}

Nullable testGenericTypeConversions() {
  dart_print(dart_string("\n📌 测试泛型类型转换"));
dart_print(dart_string("  泛型集合转换:"));
auto dynamicList = dart_literal(dart_int(1), dart_int(2), dart_int(3), dart_int(4), dart_int(5));
if (dynamicList->every([&](Any item) { return dart_is<Int>(item); })) {
auto intList = dynamicList->cast();
dart_print(dart_concat(dart_string("    dynamic List转int List: "), intList));
}
auto numList = dart_literal(dart_int(1), dart_double(2.5), dart_int(3), dart_double(4.7), dart_int(5));
auto intList = numList->whereType()->toList();
auto doubleList = numList->whereType()->toList();
dart_print(dart_concat(dart_string("    num List中的int: "), intList));
dart_print(dart_concat(dart_string("    num List中的double: "), doubleList));
dart_print(dart_string("  泛型类型检查:"));
auto objectList = dart_literal(dart_int(1), dart_string("hello"), dart_double(3.14), dart_bool(true));
auto sync_for_iterator = objectList->iterator;
for (; sync_for_iterator->moveNext(); ) {
auto item = sync_for_iterator->current;
if (dart_is<Int>(item)) {
dart_print(dart_concat(dart_string("    整数: "), item));
} else {
if (dart_is<String>(item)) {
dart_print(dart_concat(dart_string("    字符串: "), item));
} else {
if (dart_is<Double>(item)) {
dart_print(dart_concat(dart_string("    浮点数: "), item));
} else {
if (dart_is<Bool>(item)) {
dart_print(dart_concat(dart_string("    布尔值: "), item));
}
}
}
}
}
dart_print(dart_string("  协变和逆变:"));
auto dogList = dart_literal(ObjectPtr<Dog>(new Dog(dart_string("Buddy"))), ObjectPtr<Dog>(new Dog(dart_string("Max"))));
auto animalList = dogList;
dart_print(dart_concat(dart_string("    Dog List作为Animal List: "), animalList->size()));
dart_print(dart_string("  泛型方法类型推断:"));
auto inferredList = createList(dart_string("hello"), dart_string("world"));
dart_print(dart_concat(dart_string("    推断的列表类型: "), inferredList->runtimeType));
dart_print(dart_concat(dart_string("    推断的列表内容: "), inferredList));
auto inferredIntList = createList(dart_int(1), dart_int(2));
dart_print(dart_concat(dart_string("    推断的int列表: "), inferredIntList->runtimeType));
dart_print(dart_concat(dart_string("    推断的int列表内容: "), inferredIntList));
dart_print(dart_string("  类型参数约束:"));
auto numberProcessor = ObjectPtr<NumberProcessor>(new NumberProcessor());
dart_print(dart_concat(dart_string("    int处理器: "), numberProcessor->process(dart_int(42))));
auto doubleProcessor = ObjectPtr<NumberProcessor>(new NumberProcessor());
dart_print(dart_concat(dart_string("    double处理器: "), doubleProcessor->process(dart_double(3.14))));
}

List<Any> createList(Any first, Any second) {
  return dart_literal(first, second);
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
