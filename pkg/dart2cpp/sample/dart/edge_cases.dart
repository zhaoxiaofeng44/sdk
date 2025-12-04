/// 边界测试用例
/// 
/// 测试Dart边界情况和极端情况，包括：
/// - 数值边界
/// - 字符串边界
/// - 集合边界
/// - 空值处理
/// - 除零和溢出

void main() {
  print('🔥 边界测试开始');
  
  // 1. 数值边界测试
  testNumericEdgeCases();
  
  // 2. 字符串边界测试
  testStringEdgeCases();
  
  // 3. 集合边界测试
  testCollectionEdgeCases();
  
  // 4. 空值边界测试
  testNullEdgeCases();
  
  // 5. 除零和溢出测试
  testDivisionAndOverflow();
  
  // 6. 类型转换边界测试
  testTypeConversionEdges();
  
  print('✅ 边界测试完成');
}

/// 测试数值边界情况
void testNumericEdgeCases() {
  print('\n📌 测试数值边界情况');
  
  // 整数边界
  print('  整数边界:');
  int maxInt = 9223372036854775807; // 64位最大值
  int minInt = -9223372036854775808; // 64位最小值
  int zero = 0;
  int one = 1;
  int minusOne = -1;
  
  print('    最大整数: $maxInt');
  print('    最小整数: $minInt');
  print('    零: $zero');
  print('    一: $one');
  print('    负一: $minusOne');
  
  // 浮点数边界
  print('  浮点数边界:');
  double positiveZero = 0.0;
  double negativeZero = -0.0;
  double verySmall = 0.0000001;
  double veryLarge = 1000000000.0;
  double infinity = double.infinity;
  double negativeInfinity = double.negativeInfinity;
  double nan = double.nan;
  
  print('    正零: $positiveZero');
  print('    负零: $negativeZero');
  print('    很小的数: $verySmall');
  print('    很大的数: $veryLarge');
  print('    正无穷: $infinity');
  print('    负无穷: $negativeInfinity');
  print('    NaN: $nan');
  
  // 特殊值检查
  print('  特殊值检查:');
  print('    infinity是无穷: ${infinity.isInfinite}');
  print('    nan是NaN: ${nan.isNaN}');
  print('    infinity是有限: ${infinity.isFinite}');
  print('    veryLarge是有限: ${veryLarge.isFinite}');
  
  // 零值运算
  print('  零值运算:');
  print('    5 + 0 = ${5 + 0}');
  print('    5 * 0 = ${5 * 0}');
  print('    5 - 0 = ${5 - 0}');
  print('    0 - 5 = ${0 - 5}');
  
  // 负数运算
  print('  负数运算:');
  print('    -5 + (-3) = ${-5 + (-3)}');
  print('    -5 * -3 = ${-5 * -3}');
  print('    -5 - (-3) = ${-5 - (-3)}');
  print('    -(-5) = ${-(-5)}');
  
  // 边界运算
  print('  边界运算:');
  print('    maxInt + 1 会溢出');
  print('    minInt - 1 会溢出');
}

/// 测试字符串边界情况
void testStringEdgeCases() {
  print('\n📌 测试字符串边界情况');
  
  // 空字符串
  String empty = '';
  print('  空字符串:');
  print('    长度: ${empty.length}');
  print('    是否为空: ${empty.isEmpty}');
  print('    是否不为空: ${empty.isNotEmpty}');
  
  // 单字符
  String single = 'a';
  print('  单字符:');
  print('    内容: "$single"');
  print('    长度: ${single.length}');
  
  // 空格字符串
  String spaces = '   ';
  String tabs = '\t\t\t';
  String newlines = '\n\n\n';
  
  print('  空白字符串:');
  print('    空格长度: ${spaces.length}');
  print('    制表符长度: ${tabs.length}');
  print('    换行符长度: ${newlines.length}');
  print('    空格trim后: "${spaces.trim()}"');
  
  // 特殊字符
  String special = 'Hello\nWorld\t!';
  String unicode = '你好世界🌍';
  String escaped = 'Quote: "Hello" and \'World\'';
  
  print('  特殊字符:');
  print('    换行制表: "$special"');
  print('    Unicode: $unicode (长度: ${unicode.length})');
  print('    转义字符: $escaped');
  
  // 很长的字符串
  String longString = 'a' * 1000;
  print('  长字符串:');
  print('    长度: ${longString.length}');
  print('    前10个字符: ${longString.substring(0, 10)}');
  
  // 字符串连接边界
  String concat1 = '' + 'hello';
  String concat2 = 'hello' + '';
  String concat3 = '' + '';
  
  print('  连接边界:');
  print('    空+hello: "$concat1"');
  print('    hello+空: "$concat2"');
  print('    空+空: "$concat3"');
  
  // 子字符串边界
  String str = 'Hello';
  print('  子字符串边界:');
  
  try {
    String sub1 = str.substring(0, 0);
    print('    substring(0,0): "$sub1"');
  } catch (e) {
    print('    substring(0,0) 错误: $e');
  }
  
  try {
    String sub2 = str.substring(0, str.length);
    print('    substring(0,len): "$sub2"');
  } catch (e) {
    print('    substring(0,len) 错误: $e');
  }
  
  try {
    String sub3 = str.substring(str.length, str.length);
    print('    substring(len,len): "$sub3"');
  } catch (e) {
    print('    substring(len,len) 错误: $e');
  }
  
  // 索引边界
  print('  索引边界:');
  print('    indexOf存在字符: ${str.indexOf('H')}');
  print('    indexOf不存在字符: ${str.indexOf('z')}');
  print('    lastIndexOf: ${str.lastIndexOf('l')}');
}

/// 测试集合边界情况
void testCollectionEdgeCases() {
  print('\n📌 测试集合边界情况');
  
  // 空列表
  List<int> emptyList = [];
  print('  空列表:');
  print('    长度: ${emptyList.length}');
  print('    是否为空: ${emptyList.isEmpty}');
  
  try {
    print('    first: ${emptyList.first}');
  } catch (e) {
    print('    访问first错误: ${e.runtimeType}');
  }
  
  try {
    print('    last: ${emptyList.last}');
  } catch (e) {
    print('    访问last错误: ${e.runtimeType}');
  }
  
  // 单元素列表
  List<int> singleList = [42];
  print('  单元素列表:');
  print('    内容: $singleList');
  print('    first: ${singleList.first}');
  print('    last: ${singleList.last}');
  print('    first == last: ${singleList.first == singleList.last}');
  
  // 重复元素列表
  List<int> duplicates = [1, 1, 2, 2, 3, 3];
  print('  重复元素列表:');
  print('    内容: $duplicates');
  print('    去重: ${duplicates.toSet().toList()}');
  
  // 列表边界访问
  List<int> testList = [1, 2, 3];
  print('  列表边界访问:');
  
  try {
    print('    索引0: ${testList[0]}');
    print('    索引-1: ${testList[-1]}');
  } catch (e) {
    print('    负索引错误: ${e.runtimeType}');
  }
  
  try {
    print('    索引3: ${testList[3]}');
  } catch (e) {
    print('    超界索引错误: ${e.runtimeType}');
  }
  
  // 空Map
  Map<String, int> emptyMap = {};
  print('  空Map:');
  print('    长度: ${emptyMap.length}');
  print('    是否为空: ${emptyMap.isEmpty}');
  print('    访问不存在键: ${emptyMap['nonexistent']}');
  
  // 单键值对Map
  Map<String, int> singleMap = {'key': 42};
  print('  单键值对Map:');
  print('    内容: $singleMap');
  print('    键集合: ${singleMap.keys}');
  print('    值集合: ${singleMap.values}');
  
  // 空Set
  Set<int> emptySet = {};
  print('  空Set:');
  print('    长度: ${emptySet.length}');
  print('    是否为空: ${emptySet.isEmpty}');
  
  // Set重复添加
  Set<int> testSet = {1, 2, 3};
  testSet.add(2); // 重复元素
  print('  Set重复添加:');
  print('    添加重复元素后: $testSet');
  
  // 集合操作边界
  Set<int> set1 = {1, 2, 3};
  Set<int> set2 = {};
  
  print('  集合运算边界:');
  print('    非空与空的并集: ${set1.union(set2)}');
  print('    非空与空的交集: ${set1.intersection(set2)}');
  print('    非空与空的差集: ${set1.difference(set2)}');
}

/// 测试空值边界情况
void testNullEdgeCases() {
  print('\n📌 测试空值边界情况');
  
  // 空值变量
  int? nullInt;
  String? nullString;
  List<int>? nullList;
  Map<String, int>? nullMap;
  
  print('  空值变量:');
  print('    nullInt: $nullInt');
  print('    nullString: $nullString');
  print('    nullList: $nullList');
  print('    nullMap: $nullMap');
  
  // 空值合并
  int value1 = nullInt ?? 0;
  String value2 = nullString ?? 'default';
  List<int> value3 = nullList ?? [];
  
  print('  空值合并:');
  print('    nullInt ?? 0: $value1');
  print('    nullString ?? default: $value2');
  print('    nullList ?? []: $value3');
  
  // 空值合并赋值
  int? testInt;
  testInt ??= 42;
  print('    testInt ??= 42: $testInt');
  
  testInt ??= 100; // 不会赋值，因为已经不是null
  print('    testInt ??= 100: $testInt');
  
  // 空值安全访问
  String? name = 'Alice';
  int? length1 = name?.length;
  print('  空值安全访问:');
  print('    非空字符串长度: $length1');
  
  name = null;
  int? length2 = name?.length;
  print('    空字符串长度: $length2');
  
  // 链式空值安全访问
  Person? person = Person('Bob', Address('Main St', City('New York')));
  String? cityName1 = person?.address?.city?.name;
  print('    链式访问城市名: $cityName1');
  
  person = null;
  String? cityName2 = person?.address?.city?.name;
  print('    空对象链式访问: $cityName2');
  
  // 空值断言
  String? maybeString = 'Hello';
  String definitelyString = maybeString!; // 断言非空
  print('    空值断言: $definitelyString');
  
  try {
    String? nullString = null;
    String crashString = nullString!; // 这会抛出异常
    print('    不会执行到这里: $crashString');
  } catch (e) {
    print('    空值断言异常: ${e.runtimeType}');
  }
}

/// 测试除零和溢出
void testDivisionAndOverflow() {
  print('\n📌 测试除零和溢出');
  
  // 整数除零
  print('  整数除零:');
  try {
    int result = 10 ~/ 0;
    print('    10 ~/ 0 = $result');
  } catch (e) {
    print('    整数除零异常: ${e.runtimeType}');
  }
  
  // 浮点数除零
  print('  浮点数除零:');
  double result1 = 10.0 / 0.0;
  double result2 = -10.0 / 0.0;
  double result3 = 0.0 / 0.0;
  
  print('    10.0 / 0.0 = $result1');
  print('    -10.0 / 0.0 = $result2');
  print('    0.0 / 0.0 = $result3');
  
  // 模运算边界
  print('  模运算边界:');
  try {
    int mod1 = 10 % 0;
    print('    10 % 0 = $mod1');
  } catch (e) {
    print('    模零异常: ${e.runtimeType}');
  }
  
  print('    10 % 3 = ${10 % 3}');
  print('    10 % -3 = ${10 % -3}');
  print('    -10 % 3 = ${-10 % 3}');
  print('    -10 % -3 = ${-10 % -3}');
  
  // 大数运算
  print('  大数运算:');
  int bigInt1 = 9223372036854775807; // 最大64位整数
  int bigInt2 = 1;
  
  print('    大整数: $bigInt1');
  
  // 注意：Dart中整数溢出会自动转换为大整数
  var sum = bigInt1 + bigInt2;
  print('    大整数 + 1: $sum (类型: ${sum.runtimeType})');
  
  // 浮点数精度
  print('  浮点数精度:');
  double precise1 = 0.1 + 0.2;
  print('    0.1 + 0.2 = $precise1');
  print('    是否等于0.3: ${precise1 == 0.3}');
  
  double verySmall = 1e-100;
  double veryLarge = 1e100;
  print('    很小的数: $verySmall');
  print('    很大的数: $veryLarge');
  
  // 无穷大运算
  print('  无穷大运算:');
  double inf = double.infinity;
  print('    infinity + 1: ${inf + 1}');
  print('    infinity - infinity: ${inf - inf}');
  print('    infinity / infinity: ${inf / inf}');
  print('    infinity * 0: ${inf * 0}');
}

/// 测试类型转换边界
void testTypeConversionEdges() {
  print('\n📌 测试类型转换边界');
  
  // 字符串转数字边界
  print('  字符串转数字:');
  
  try {
    int parsed1 = int.parse('123');
    print('    parse "123": $parsed1');
  } catch (e) {
    print('    parse "123" 错误: $e');
  }
  
  try {
    int parsed2 = int.parse('');
    print('    parse 空字符串: $parsed2');
  } catch (e) {
    print('    parse 空字符串错误: ${e.runtimeType}');
  }
  
  try {
    int parsed3 = int.parse('abc');
    print('    parse "abc": $parsed3');
  } catch (e) {
    print('    parse "abc" 错误: ${e.runtimeType}');
  }
  
  // tryParse 安全转换
  print('  tryParse 安全转换:');
  int? safe1 = int.tryParse('123');
  int? safe2 = int.tryParse('abc');
  int? safe3 = int.tryParse('');
  
  print('    tryParse "123": $safe1');
  print('    tryParse "abc": $safe2');
  print('    tryParse 空字符串: $safe3');
  
  // 浮点数转换
  print('  浮点数转换:');
  double? float1 = double.tryParse('3.14');
  double? float2 = double.tryParse('abc');
  double? float3 = double.tryParse('infinity');
  double? float4 = double.tryParse('nan');
  
  print('    tryParse "3.14": $float1');
  print('    tryParse "abc": $float2');
  print('    tryParse "infinity": $float3');
  print('    tryParse "nan": $float4');
  
  // 类型转换 as
  print('  类型转换 as:');
  dynamic value1 = 42;
  dynamic value2 = 'hello';
  
  try {
    int intValue = value1 as int;
    print('    42 as int: $intValue');
  } catch (e) {
    print('    42 as int 错误: $e');
  }
  
  try {
    int intValue = value2 as int;
    print('    "hello" as int: $intValue');
  } catch (e) {
    print('    "hello" as int 错误: ${e.runtimeType}');
  }
  
  // 类型检查 is
  print('  类型检查 is:');
  print('    42 is int: ${value1 is int}');
  print('    42 is String: ${value1 is String}');
  print('    "hello" is String: ${value2 is String}');
  print('    "hello" is int: ${value2 is int}');
  
  // 数值转换边界
  print('  数值转换边界:');
  double bigDouble = 1e20;
  int convertedInt = bigDouble.toInt();
  print('    大浮点数转整数: $bigDouble -> $convertedInt');
  
  double smallDouble = 0.9;
  int truncatedInt = smallDouble.toInt();
  print('    小数转整数: $smallDouble -> $truncatedInt');
}

// ============================================================================
// 辅助类定义
// ============================================================================

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
