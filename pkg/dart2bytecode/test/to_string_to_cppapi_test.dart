// toString 到 CppString.convertString 转换测试
//
// 此测试验证所有toString()方法调用是否被正确转换为CppString.convertString(x)调用

import 'dart:io';

void main() {
  print('开始测试toString到CppString.convertString转换...');

  final transformedFile = File('transformed_dart.dart');
  if (!transformedFile.existsSync()) {
    print('错误: transformed_dart.dart 文件不存在');
    exit(1);
  }

  final content = transformedFile.readAsStringSync();

  // 测试1: 检查CppString.convertString调用数量
  final cppStringConvertStringCalls =
      RegExp(r'CppString\.convertString\([^)]+\)').allMatches(content).length;
  print('✓ 发现 CppString.convertString 调用: $cppStringConvertStringCalls 个');

  // 测试2: 检查是否还有CppApi.toString调用（应该没有）
  final cppApiToStringCalls =
      RegExp(r'CppApi\.toString\([^)]+\)').allMatches(content).length;
  print('✓ 发现 CppApi.toString 调用: $cppApiToStringCalls 个');

  // 测试3: 检查是否还有直接的toString()调用（应该没有）
  final directToStringCalls =
      RegExp(r'\w+\.toString\(\)').allMatches(content).length;
  print('✓ 发现直接的 .toString() 调用: $directToStringCalls 个');

  // 测试4: 检查toCppString方法定义数量（应该保持不变）
  final toCppStringDefinitions =
      RegExp(r'CppString toCppString\(\)').allMatches(content).length;
  print('✓ 发现 toCppString 方法定义: $toCppStringDefinitions 个');

  // 测试5: 检查toCppString调用数量（返回值调用，应该保持不变）
  final toCppStringCalls =
      RegExp(r'\w+\.toCppString\(\)').allMatches(content).length;
  print('✓ 发现 .toCppString() 调用: $toCppStringCalls 个');

  // 测试6: 检查具体的转换示例
  final hasCorrectConversion =
      content.contains('CppString.convertString(it.current)');
  print('✓ 包含正确的转换示例: $hasCorrectConversion');

  print('\ntoString到CppString.convertString转换测试结果:');

  bool condition1 = cppStringConvertStringCalls > 0;
  bool condition2 = cppApiToStringCalls == 0;
  bool condition3 = directToStringCalls == 0;
  bool condition4 = hasCorrectConversion;

  print('调试条件:');
  print('  condition1 (cppStringConvertStringCalls > 0): $condition1');
  print('  condition2 (cppApiToStringCalls == 0): $condition2');
  print('  condition3 (directToStringCalls == 0): $condition3');
  print('  condition4 (hasCorrectConversion): $condition4');

  if (condition1 && condition2 && condition3 && condition4) {
    print('✅ 所有测试通过！toString调用已正确转换为CppString.convertString。');
    print('   - CppString.convertString 调用: $cppStringConvertStringCalls 个');
    print('   - CppApi.toString 调用: $cppApiToStringCalls 个');
    print('   - toCppString 方法定义: $toCppStringDefinitions 个');
    print(
        '   - 返回值 toCppString 调用: ${toCppStringCalls - toCppStringDefinitions} 个');
    print('   - 直接 .toString() 调用: $directToStringCalls 个');
  } else {
    print('❌ 测试失败！');
    print('   - CppString.convertString 调用: $cppStringConvertStringCalls');
    print('   - CppApi.toString 调用: $cppApiToStringCalls');
    print('   - 直接 .toString() 调用: $directToStringCalls');
    print('   - toCppString 调用: $toCppStringCalls');
    print('   - 正确转换示例: $hasCorrectConversion');
    exit(1);
  }
}
