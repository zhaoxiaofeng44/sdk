import '../lib/demo/string.dart';

void main() {
  print('=== 测试完全独立的CppString（不依赖String） ===');

  // 1. 基础构造测试 - 仅使用代码单元
  print('\n1. 基础构造测试:');
  var hello = CppString.fromCodeUnits([72, 101, 108, 108, 111]); // "Hello"
  var world = CppString.fromCharCode(87); // "W"
  world = world + CppString.fromCodeUnits([111, 114, 108, 100]); // "orld"

  print('创建hello: ${hello.length}个字符');
  print('创建world: ${world.length}个字符');

  // 2. 字符串连接测试
  print('\n2. 字符串连接测试:');
  var space = CppString.fromCharCode(32); // 空格
  var helloWorld = hello + space + world;
  print('连接结果长度: ${helloWorld.length}');

  // 3. 字符访问测试
  print('\n3. 字符访问测试:');
  for (int i = 0; i < helloWorld.length; i++) {
    int codeUnit = helloWorld.codeUnitAt(i);
    print('  位置$i: 代码单元=$codeUnit');
  }

  // 4. 比较测试
  print('\n4. 比较测试:');
  var hello2 = CppString.fromCodeUnits([72, 101, 108, 108, 111]);
  print('hello == hello2: ${hello == hello2}');
  print('hello.compareTo(hello2): ${hello.compareTo(hello2)}');

  // 5. 查找测试
  print('\n5. 查找测试:');
  var ll = CppString.fromCodeUnits([108, 108]); // "ll"
  print('helloWorld.contains(ll): ${helloWorld.contains(ll)}');
  print('helloWorld.indexOf(ll): ${helloWorld.indexOf(ll)}');

  // 6. 子字符串测试
  print('\n6. 子字符串测试:');
  var sub = helloWorld.substring(0, 5);
  print('substring(0, 5)长度: ${sub.length}');
  print('与hello相等: ${sub == hello}');

  // 7. 字符串重复测试
  print('\n7. 字符串重复测试:');
  var hi = CppString.fromCodeUnits([72, 105]); // "Hi"
  var repeated = hi * 3;
  print('Hi重复3次长度: ${repeated.length}');

  // 8. 分割测试
  print('\n8. 分割测试:');
  var comma = CppString.fromCharCode(44); // ","
  var csv = CppString.fromCodeUnits([97, 44, 98, 44, 99]); // "a,b,c"
  var parts = csv.split(comma);
  print('分割结果数量: ${parts.length}');

  // 9. 替换测试
  print('\n9. 替换测试:');
  var a = CppString.fromCharCode(97); // "a"
  var x = CppString.fromCharCode(120); // "x"
  var replaced = csv.replaceAll(a, x);
  print('替换后长度: ${replaced.length}');

  // 10. 大小写转换测试
  print('\n10. 大小写转换测试:');
  var upper = hello.toUpperCase();
  var lower = upper.toLowerCase();
  print('大写转换后长度: ${upper.length}');
  print('转回小写等于原字符串: ${lower == hello}');

  // 11. 修剪测试
  print('\n11. 修剪测试:');
  var padded = space + hello + space + space;
  var trimmed = padded.trim();
  print('修剪前长度: ${padded.length}');
  print('修剪后长度: ${trimmed.length}');
  print('修剪结果等于hello: ${trimmed == hello}');

  // 12. 填充测试
  print('\n12. 填充测试:');
  var star = CppString.fromCharCode(42); // "*"
  var padded2 = hello.padRight(10, star);
  print('右填充到10位长度: ${padded2.length}');

  // 13. 连接多个字符串测试
  print('\n13. 连接多个字符串测试:');
  var strings = [hello, world, hello];
  var joined = CppString.join(strings, comma);
  print('连接结果长度: ${joined.length}');

  // 14. 字符串池效果测试
  print('\n14. 字符串池效果测试:');
  var hello3 = CppString.fromCodeUnits([72, 101, 108, 108, 111]);
  var hello4 = CppString.fromCodeUnits([72, 101, 108, 108, 111]);
  print('两个相同内容的字符串共享数据: ${hello3.sharesDataWith(hello4)}');

  // 15. 空字符串测试
  print('\n15. 空字符串测试:');
  var empty1 = CppString.empty();
  var empty2 = CppString.fromCodeUnits([]);
  print('两个空字符串相等: ${empty1 == empty2}');
  print('空字符串长度: ${empty1.length}');
  print('空字符串为空: ${empty1.isEmpty}');

  print('\n=== 所有测试完成，CppString完全独立运行！ ===');
}
