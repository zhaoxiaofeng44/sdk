/// 类型转换测试用例
/// 
/// 测试Dart类型转换特性，包括：
/// - as 表达式
/// - is 类型检查
/// - 类型转换方法
/// - 空安全转换
/// - 动态类型处理

void main() {
  print('🔥 类型转换测试开始');
  
  // 1. as 表达式测试
  testAsExpressions();
  
  // 2. is 类型检查测试
  testIsTypeChecks();
  
  // 3. 类型转换方法测试
  testTypeConversionMethods();
  
  // 4. 空安全转换测试
  testNullSafetyConversions();
  
  // 5. 动态类型处理测试
  testDynamicTypeHandling();
  
  // 6. 泛型类型转换测试
  testGenericTypeConversions();
  
  print('✅ 类型转换测试完成');
}

/// 测试 as 表达式
void testAsExpressions() {
  print('\n📌 测试 as 表达式');
  
  // 基本类型转换
  dynamic value1 = 42;
  dynamic value2 = 'hello';
  dynamic value3 = [1, 2, 3];
  dynamic value4 = {'key': 'value'};
  
  print('  基本 as 转换:');
  
  try {
    int intValue = value1 as int;
    print('    42 as int: $intValue');
  } catch (e) {
    print('    42 as int 失败: ${e.runtimeType}');
  }
  
  try {
    String stringValue = value2 as String;
    print('    "hello" as String: $stringValue');
  } catch (e) {
    print('    "hello" as String 失败: ${e.runtimeType}');
  }
  
  try {
    List<int> listValue = value3 as List<int>;
    print('    [1,2,3] as List<int>: $listValue');
  } catch (e) {
    print('    [1,2,3] as List<int> 失败: ${e.runtimeType}');
  }
  
  // 错误的类型转换
  print('  错误的 as 转换:');
  
  try {
    int wrongInt = value2 as int; // String -> int
    print('    不应该执行到这里: $wrongInt');
  } catch (e) {
    print('    "hello" as int 异常: ${e.runtimeType}');
  }
  
  try {
    String wrongString = value1 as String; // int -> String
    print('    不应该执行到这里: $wrongString');
  } catch (e) {
    print('    42 as String 异常: ${e.runtimeType}');
  }
  
  // 对象类型转换
  print('  对象 as 转换:');
  
  Animal animal = Dog('Buddy');
  Cat cat = Cat('Whiskers');
  
  try {
    Dog dog = animal as Dog;
    print('    Animal as Dog: ${dog.name}');
  } catch (e) {
    print('    Animal as Dog 失败: ${e.runtimeType}');
  }
  
  try {
    Dog wrongDog = cat as Dog;
    print('    不应该执行到这里: ${wrongDog.name}');
  } catch (e) {
    print('    Cat as Dog 异常: ${e.runtimeType}');
  }
  
  // 可空类型转换
  print('  可空类型 as 转换:');
  
  dynamic nullValue = null;
  dynamic nonNullValue = 'test';
  
  try {
    String? nullableString = nullValue as String?;
    print('    null as String?: $nullableString');
  } catch (e) {
    print('    null as String? 失败: ${e.runtimeType}');
  }
  
  try {
    String nonNullString = nonNullValue as String;
    print('    "test" as String: $nonNullString');
  } catch (e) {
    print('    "test" as String 失败: ${e.runtimeType}');
  }
}

/// 测试 is 类型检查
void testIsTypeChecks() {
  print('\n📌 测试 is 类型检查');
  
  // 基本类型检查
  dynamic value1 = 42;
  dynamic value2 = 'hello';
  dynamic value3 = [1, 2, 3];
  dynamic value4 = {'key': 'value'};
  dynamic value5 = null;
  
  print('  基本类型检查:');
  print('    42 is int: ${value1 is int}');
  print('    42 is String: ${value1 is String}');
  print('    "hello" is String: ${value2 is String}');
  print('    "hello" is int: ${value2 is int}');
  print('    [1,2,3] is List: ${value3 is List}');
  print('    [1,2,3] is List<int>: ${value3 is List<int>}');
  print('    Map is Map: ${value4 is Map}');
  print('    null is String: ${value5 is String}');
  print('    null is String?: ${value5 is String?}');
  
  // 对象类型检查
  print('  对象类型检查:');
  
  Animal animal = Dog('Buddy');
  Dog dog = Dog('Max');
  Cat cat = Cat('Whiskers');
  
  print('    Dog is Animal: ${dog is Animal}');
  print('    Dog is Dog: ${dog is Dog}');
  print('    Dog is Cat: ${dog is Cat}');
  print('    Cat is Animal: ${cat is Animal}');
  print('    Cat is Dog: ${cat is Dog}');
  print('    Animal(Dog) is Dog: ${animal is Dog}');
  print('    Animal(Dog) is Cat: ${animal is Cat}');
  
  // 类型检查后的智能转换
  print('  智能转换:');
  
  dynamic unknownValue = 'Hello World';
  
  if (unknownValue is String) {
    // 在这个块中，unknownValue 被智能转换为 String
    print('    智能转换为String: ${unknownValue.toUpperCase()}');
    print('    字符串长度: ${unknownValue.length}');
  }
  
  unknownValue = [1, 2, 3, 4, 5];
  
  if (unknownValue is List<int>) {
    // 智能转换为 List<int>
    print('    智能转换为List<int>: ${unknownValue.first}');
    print('    列表长度: ${unknownValue.length}');
  }
  
  // 否定类型检查
  print('  否定类型检查:');
  
  dynamic testValue = 42;
  
  if (testValue is! String) {
    print('    42 不是 String');
  }
  
  if (testValue is! null) {
    print('    42 不是 null');
  }
  
  // 复杂类型检查
  print('  复杂类型检查:');
  
  List<dynamic> mixedList = [1, 'hello', [1, 2], {'key': 'value'}];
  
  for (var item in mixedList) {
    if (item is int) {
      print('    整数: $item');
    } else if (item is String) {
      print('    字符串: $item');
    } else if (item is List) {
      print('    列表: $item');
    } else if (item is Map) {
      print('    映射: $item');
    } else {
      print('    未知类型: $item');
    }
  }
}

/// 测试类型转换方法
void testTypeConversionMethods() {
  print('\n📌 测试类型转换方法');
  
  // 数字转换
  print('  数字类型转换:');
  
  int intValue = 42;
  double doubleValue = 3.14159;
  
  print('    int转double: ${intValue.toDouble()}');
  print('    double转int: ${doubleValue.toInt()}');
  print('    double转int(截断): ${doubleValue.truncate()}');
  print('    double转int(向上取整): ${doubleValue.ceil()}');
  print('    double转int(向下取整): ${doubleValue.floor()}');
  print('    double转int(四舍五入): ${doubleValue.round()}');
  
  // 字符串转换
  print('  字符串转换:');
  
  print('    int转String: ${intValue.toString()}');
  print('    double转String: ${doubleValue.toString()}');
  print('    bool转String: ${true.toString()}');
  
  // 字符串解析
  print('  字符串解析:');
  
  String intString = '123';
  String doubleString = '3.14';
  String boolString = 'true';
  String invalidString = 'abc';
  
  try {
    int parsedInt = int.parse(intString);
    print('    parse "123": $parsedInt');
  } catch (e) {
    print('    parse "123" 失败: $e');
  }
  
  try {
    double parsedDouble = double.parse(doubleString);
    print('    parse "3.14": $parsedDouble');
  } catch (e) {
    print('    parse "3.14" 失败: $e');
  }
  
  try {
    int invalidInt = int.parse(invalidString);
    print('    不应该执行到这里: $invalidInt');
  } catch (e) {
    print('    parse "abc" 异常: ${e.runtimeType}');
  }
  
  // 安全解析
  print('  安全解析:');
  
  int? safeInt1 = int.tryParse(intString);
  int? safeInt2 = int.tryParse(invalidString);
  double? safeDouble1 = double.tryParse(doubleString);
  double? safeDouble2 = double.tryParse(invalidString);
  
  print('    tryParse "123": $safeInt1');
  print('    tryParse "abc": $safeInt2');
  print('    tryParse "3.14": $safeDouble1');
  print('    tryParse "abc": $safeDouble2');
  
  // 进制转换
  print('  进制转换:');
  
  int decimal = 255;
  print('    255转16进制: ${decimal.toRadixString(16)}');
  print('    255转8进制: ${decimal.toRadixString(8)}');
  print('    255转2进制: ${decimal.toRadixString(2)}');
  
  try {
    int fromHex = int.parse('FF', radix: 16);
    print('    16进制FF转10进制: $fromHex');
  } catch (e) {
    print('    16进制转换失败: $e');
  }
  
  // 集合转换
  print('  集合转换:');
  
  List<int> list = [1, 2, 3, 4, 5];
  Set<int> set = {1, 2, 3, 4, 5};
  
  Set<int> listToSet = list.toSet();
  List<int> setToList = set.toList();
  
  print('    List转Set: $listToSet');
  print('    Set转List: $setToList');
  
  // 字符串和字符列表转换
  String text = 'Hello';
  List<int> charCodes = text.codeUnits;
  String fromCodes = String.fromCharCodes(charCodes);
  
  print('    String转字符码: $charCodes');
  print('    字符码转String: $fromCodes');
}

/// 测试空安全转换
void testNullSafetyConversions() {
  print('\n📌 测试空安全转换');
  
  // 可空类型转换
  String? nullableString = 'Hello';
  String? nullString = null;
  
  print('  可空类型转换:');
  
  // 空值合并
  String nonNull1 = nullableString ?? 'default';
  String nonNull2 = nullString ?? 'default';
  
  print('    "Hello" ?? "default": $nonNull1');
  print('    null ?? "default": $nonNull2');
  
  // 空值合并赋值
  String? testString;
  testString ??= 'assigned';
  print('    null ??= "assigned": $testString');
  
  testString ??= 'not assigned';
  print('    "assigned" ??= "not assigned": $testString');
  
  // 空值安全访问
  String? maybeString = 'Hello World';
  int? length1 = maybeString?.length;
  print('    "Hello World"?.length: $length1');
  
  maybeString = null;
  int? length2 = maybeString?.length;
  print('    null?.length: $length2');
  
  // 链式空值安全访问
  Person? person = Person('Alice', Address('Main St', City('New York')));
  String? cityName1 = person?.address?.city?.name;
  print('    链式访问城市名: $cityName1');
  
  person = null;
  String? cityName2 = person?.address?.city?.name;
  print('    null对象链式访问: $cityName2');
  
  // 空值断言
  print('  空值断言:');
  
  String? definitelyNotNull = 'Definitely not null';
  String assertedString = definitelyNotNull!;
  print('    空值断言成功: $assertedString');
  
  try {
    String? definitelyNull = null;
    String crashString = definitelyNull!;
    print('    不应该执行到这里: $crashString');
  } catch (e) {
    print('    空值断言异常: ${e.runtimeType}');
  }
  
  // 类型提升
  print('  类型提升:');
  
  String? promotableString = 'Hello';
  
  if (promotableString != null) {
    // 在这个块中，promotableString 被提升为非空类型
    print('    提升后的字符串: ${promotableString.toUpperCase()}');
    print('    提升后的长度: ${promotableString.length}');
  }
  
  // late 变量
  print('  late 变量:');
  
  late String lateString;
  lateString = 'Late initialized';
  print('    late变量: $lateString');
  
  // late final 变量
  late final String lateFinalString;
  lateFinalString = 'Late final initialized';
  print('    late final变量: $lateFinalString');
}

/// 测试动态类型处理
void testDynamicTypeHandling() {
  print('\n📌 测试动态类型处理');
  
  // 动态类型变量
  dynamic dynamicVar = 42;
  print('  动态类型处理:');
  print('    初始值(int): $dynamicVar');
  
  dynamicVar = 'Hello';
  print('    改为String: $dynamicVar');
  
  dynamicVar = [1, 2, 3];
  print('    改为List: $dynamicVar');
  
  dynamicVar = {'key': 'value'};
  print('    改为Map: $dynamicVar');
  
  // 动态类型方法调用
  print('  动态方法调用:');
  
  dynamic stringDynamic = 'hello world';
  print('    动态String方法: ${stringDynamic.toUpperCase()}');
  
  dynamic listDynamic = [1, 2, 3, 4, 5];
  print('    动态List方法: ${listDynamic.length}');
  
  // Object 类型
  print('  Object 类型:');
  
  Object objectVar = 42;
  print('    Object(int): $objectVar');
  print('    Object类型: ${objectVar.runtimeType}');
  
  objectVar = 'Hello';
  print('    Object(String): $objectVar');
  print('    Object类型: ${objectVar.runtimeType}');
  
  // 运行时类型检查
  print('  运行时类型:');
  
  var runtimeVar = 42;
  print('    变量类型: ${runtimeVar.runtimeType}');
  
  runtimeVar = 'Hello' as dynamic;
  print('    变量类型: ${runtimeVar.runtimeType}');
  
  // 类型安全的动态调用
  print('  类型安全的动态调用:');
  
  dynamic unknownObject = 'Hello World';
  
  if (unknownObject is String) {
    print('    作为String处理: ${unknownObject.toLowerCase()}');
  } else if (unknownObject is int) {
    print('    作为int处理: ${unknownObject + 10}');
  } else if (unknownObject is List) {
    print('    作为List处理: 长度${unknownObject.length}');
  }
  
  // 函数类型转换
  print('  函数类型转换:');
  
  dynamic functionVar = (int x) => x * 2;
  
  if (functionVar is Function) {
    print('    是函数类型');
    if (functionVar is int Function(int)) {
      int result = functionVar(5);
      print('    函数调用结果: $result');
    }
  }
}

/// 测试泛型类型转换
void testGenericTypeConversions() {
  print('\n📌 测试泛型类型转换');
  
  // 泛型集合转换
  print('  泛型集合转换:');
  
  List<dynamic> dynamicList = [1, 2, 3, 4, 5];
  
  if (dynamicList.every((item) => item is int)) {
    List<int> intList = dynamicList.cast<int>();
    print('    dynamic List转int List: $intList');
  }
  
  List<dynamic> numList = [1, 2.5, 3, 4.7, 5];
  List<int> intList = numList.whereType<int>().toList();
  List<double> doubleList = numList.whereType<double>().toList();
  
  print('    num List中的int: $intList');
  print('    num List中的double: $doubleList');
  
  // 泛型类型检查
  print('  泛型类型检查:');
  
  List<Object> objectList = [1, 'hello', 3.14, true];
  
  for (var item in objectList) {
    if (item is int) {
      print('    整数: $item');
    } else if (item is String) {
      print('    字符串: $item');
    } else if (item is double) {
      print('    浮点数: $item');
    } else if (item is bool) {
      print('    布尔值: $item');
    }
  }
  
  // 协变和逆变
  print('  协变和逆变:');
  
  List<Dog> dogList = [Dog('Buddy'), Dog('Max')];
  List<Animal> animalList = dogList; // 协变
  
  print('    Dog List作为Animal List: ${animalList.length}');
  
  // 泛型方法类型推断
  print('  泛型方法类型推断:');
  
  var inferredList = createList('hello', 'world');
  print('    推断的列表类型: ${inferredList.runtimeType}');
  print('    推断的列表内容: $inferredList');
  
  var inferredIntList = createList(1, 2);
  print('    推断的int列表: ${inferredIntList.runtimeType}');
  print('    推断的int列表内容: $inferredIntList');
  
  // 类型参数约束
  print('  类型参数约束:');
  
  var numberProcessor = NumberProcessor<int>();
  print('    int处理器: ${numberProcessor.process(42)}');
  
  var doubleProcessor = NumberProcessor<double>();
  print('    double处理器: ${doubleProcessor.process(3.14)}');
}

// ============================================================================
// 辅助类定义
// ============================================================================

/// 动物基类
class Animal {
  String name;
  Animal(this.name);
}

/// 狗类
class Dog extends Animal {
  Dog(String name) : super(name);
}

/// 猫类
class Cat extends Animal {
  Cat(String name) : super(name);
}

/// 城市类
class City {
  String name;
  City(this.name);
}

/// 地址类
class Address {
  String street;
  City city;
  Address(this.street, this.city);
}

/// 人员类
class Person {
  String name;
  Address address;
  Person(this.name, this.address);
}

/// 数字处理器（泛型约束）
class NumberProcessor<T> {
  T process(T value) {
    return value;
  }
}

// ============================================================================
// 辅助函数定义
// ============================================================================

/// 创建列表（泛型类型推断）
List<T> createList<T>(T first, T second) {
  return [first, second];
}
