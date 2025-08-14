import '../lib/demo/string.dart';

void main() {
  print('=== 测试CppString字符串池功能 ===');

  // 清空池以确保测试的准确性
  CppStringPool.instance.clear();

  // 1. 基础池功能测试
  print('\n1. 基础池功能测试:');
  var str1 = CppString.fromCodeUnits('Hello'.codeUnits);
  var str2 =
      CppString.fromCodeUnits('Hello'.codeUnits); // 相同内容，应该使用同一个CppUserData
  var str3 = CppString.fromCodeUnits('World'.codeUnits); // 不同内容

  print('创建了3个CppString实例');
  var stats = CppStringPool.instance.getStats();
  print('池统计: $stats');

  // 验证相同内容的字符串是否共享CppUserData
  bool sameData = str1.sharesDataWith(str2);
  print('str1和str2是否共享CppUserData: $sameData');

  bool differentData = str1.sharesDataWith(str3);
  print('str1和str3是否共享CppUserData: $differentData');

  // 2. 内存节省测试
  print('\n2. 内存节省测试:');
  var strings = <CppString>[];
  for (int i = 0; i < 10; i++) {
    strings.add(CppString.fromCodeUnits('Repeated'.codeUnits));
    strings.add(CppString.fromCodeUnits('Another'.codeUnits));
  }

  stats = CppStringPool.instance.getStats();
  print('创建20个重复字符串后的池统计:');
  print('$stats');

  // 3. 字符串操作产生的新字符串
  print('\n3. 字符串操作的池效果:');
  var hello1 = CppString.fromCodeUnits('Hello'.codeUnits);
  var hello2 = CppString.fromCodeUnits('Hello'.codeUnits);
  var world = CppString.fromCodeUnits(' World'.codeUnits);

  var combined1 = hello1 + world;
  var combined2 = hello2 + world;

  bool combinedSame = combined1.sharesDataWith(combined2);
  print('两个相同的字符串连接结果是否共享数据: $combinedSame');

  stats = CppStringPool.instance.getStats();
  print('字符串操作后的池统计:');
  print('$stats');

  // 4. 大小写转换的池效果
  print('\n4. 大小写转换的池效果:');
  var text1 = CppString.fromCodeUnits('Hello World'.codeUnits);
  var text2 = CppString.fromCodeUnits('Hello World'.codeUnits);

  var upper1 = text1.toUpperCase();
  var upper2 = text2.toUpperCase();

  bool upperSame = upper1.sharesDataWith(upper2);
  print('两个相同字符串的大写转换是否共享数据: $upperSame');

  var lower1 = upper1.toLowerCase();
  var lower2 = upper2.toLowerCase();

  bool lowerSame = lower1.sharesDataWith(lower2);
  print('两个相同字符串的小写转换是否共享数据: $lowerSame');

  stats = CppStringPool.instance.getStats();
  print('大小写转换后的池统计:');
  print('$stats');

  // 5. 字符串重复操作
  print('\n5. 字符串重复操作:');
  var hi1 = CppString.fromCodeUnits('Hi'.codeUnits);
  var hi2 = CppString.fromCodeUnits('Hi'.codeUnits);

  var repeated1 = hi1 * 3;
  var repeated2 = hi2 * 3;

  bool repeatedSame = repeated1.sharesDataWith(repeated2);
  print('两个相同字符串的重复操作是否共享数据: $repeatedSame');

  stats = CppStringPool.instance.getStats();
  print('字符串重复后的池统计:');
  print('$stats');

  // 6. 最终池统计
  print('\n6. 最终池统计:');
  stats = CppStringPool.instance.getStats();
  print('池中不同字符串数量: ${stats.totalStrings}');
  print('总内存使用: ${stats.totalMemory} 字符');
  print(
      '平均字符串长度: ${stats.totalStrings > 0 ? (stats.totalMemory / stats.totalStrings).toStringAsFixed(1) : 0} 字符');

  // 8. 释放测试（演示dispose的使用）
  print('\n8. 释放引用测试:');
  print('释放前池统计:');
  stats = CppStringPool.instance.getStats();
  print('  不同字符串数: ${stats.totalStrings}');

  // 手动释放一些引用（现在只是演示API）
  str1.dispose();
  str2.dispose();
  hello1.dispose();
  hello2.dispose();

  print('释放部分引用后池统计（注意：当前实现中dispose是空操作）:');
  stats = CppStringPool.instance.getStats();
  print('  不同字符串数: ${stats.totalStrings}');

  print('\n=== 字符串池测试完成 ===');
}
