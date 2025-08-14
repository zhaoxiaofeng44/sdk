import '../lib/demo/string.dart';

void main() {
  print('=== 测试基于CppUserData的CppString ===');

  // 1. 基础构造和属性测试
  print('\n1. 基础构造和属性测试:');
  var str1 = CppString('Hello');
  print('str1: "${str1.toStandardString()}"');
  print('长度: ${str1.length}');
  print('是否为空: ${str1.isEmpty}');
  print('第一个字符: "${str1[0]}"');
  print('代码单元[0]: ${str1.codeUnitAt(0)}');

  // 2. 字符串连接测试
  print('\n2. 字符串连接测试:');
  var str2 = CppString(' World!');
  var combined = str1 + str2.toStandardString();
  print('str1 + str2: "${combined.toStandardString()}"');

  // 3. 字符串重复测试
  print('\n3. 字符串重复测试:');
  var str3 = CppString('Hi');
  var repeated = str3 * 3;
  print('str3 * 3: "${repeated.toStandardString()}"');

  // 4. 相等比较测试
  print('\n4. 相等比较测试:');
  var str4 = CppString('Hello');
  var str5 = CppString('Hello');
  print('str1 == str4: ${str1 == str4}');
  print('str1 == str5: ${str1 == str5}');
  print('str1.equalsString("Hello"): ${str1.equalsString("Hello")}');

  // 5. 子字符串测试
  print('\n5. 子字符串测试:');
  var substr = combined.substring(0, 5);
  print('combined.substring(0, 5): "${substr.toStandardString()}"');

  // 6. 查找测试
  print('\n6. 查找测试:');
  print('combined.indexOf("o"): ${combined.indexOf("o")}');
  print('combined.lastIndexOf("o"): ${combined.lastIndexOf("o")}');
  print('combined.contains("World"): ${combined.contains("World")}');
  print('combined.startsWith("Hello"): ${combined.startsWith("Hello")}');
  print('combined.endsWith("!"): ${combined.endsWith("!")}');

  // 7. 大小写转换测试
  print('\n7. 大小写转换测试:');
  print(
      'combined.toLowerCase(): "${combined.toLowerCase().toStandardString()}"');
  print(
      'combined.toUpperCase(): "${combined.toUpperCase().toStandardString()}"');

  // 8. 修剪测试
  print('\n8. 修剪测试:');
  var str6 = CppString('  Hello World  ');
  print('原字符串: "${str6.toStandardString()}"');
  print('trim(): "${str6.trim().toStandardString()}"');
  print('trimLeft(): "${str6.trimLeft().toStandardString()}"');
  print('trimRight(): "${str6.trimRight().toStandardString()}"');

  // 9. 分割测试
  print('\n9. 分割测试:');
  var str7 = CppString('a,b,c,d');
  var parts = str7.split(',');
  print(
      'str7.split(","): [${parts.map((p) => '"${p.toStandardString()}"').join(', ')}]');

  // 10. 替换测试
  print('\n10. 替换测试:');
  var str8 = CppString('Hello World Hello');
  print('原字符串: "${str8.toStandardString()}"');
  print(
      'replaceFirst("Hello", "Hi"): "${str8.replaceFirst("Hello", "Hi").toStandardString()}"');
  print(
      'replaceAll("Hello", "Hi"): "${str8.replaceAll("Hello", "Hi").toStandardString()}"');

  // 11. 工厂方法测试
  print('\n11. 工厂方法测试:');
  var str9 = CppString.fromCharCode(65); // 'A'
  print('fromCharCode(65): "${str9.toStandardString()}"');

  var str10 = CppString.fromCharCodes([72, 101, 108, 108, 111]); // 'Hello'
  print(
      'fromCharCodes([72, 101, 108, 108, 111]): "${str10.toStandardString()}"');

  var str11 = CppString.empty();
  print('empty(): "${str11.toStandardString()}" (长度: ${str11.length})');

  // 12. 连接多个CppString测试
  print('\n12. 连接多个CppString测试:');
  var strings = [CppString('A'), CppString('B'), CppString('C')];
  var joined = CppString.join(strings, '-');
  print('join([A, B, C], "-"): "${joined.toStandardString()}"');

  print('\n=== 所有测试完成 ===');
}
