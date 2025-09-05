// string.dart toString 转换修复测试
//
// 此测试验证 string.dart 文件中的所有 toString() 方法调用
// 是否被正确转换为 CppApi.cppToString() 调用

import 'dart:io';

void main() {
  print('开始测试 string.dart 中 toString 转换修复...');

  final transformedFile = File('transformed_dart.dart');
  if (!transformedFile.existsSync()) {
    print('错误: transformed_dart.dart 文件不存在');
    exit(1);
  }

  final content = transformedFile.readAsStringSync();

  // 测试1: 检查是否还有直接的 .toString() 调用（应该没有）
  final directToStringCalls =
      RegExp(r'\w+\.toString\(\)').allMatches(content).length;
  print('✓ 发现直接的 .toString() 调用: $directToStringCalls 个');

  // 测试2: 检查 CppString.convertString 调用数量（应该有多个）
  final cppStringConvertStringCalls =
      RegExp(r'CppString\.convertString\([^)]+\)').allMatches(content).length;
  print('✓ 发现 CppString.convertString 调用: $cppStringConvertStringCalls 个');

  // 测试3: 检查 toCppString 方法定义数量（应该保持不变）
  final toCppStringDefinitions =
      RegExp(r'CppString toCppString\(\)').allMatches(content).length;
  print('✓ 发现 toCppString 方法定义: $toCppStringDefinitions 个');

  // 测试4: 检查具体的修复位置
  final hasFixedStringBufferCall =
      content.contains('CppString.convertString(obj)');
  print('✓ 包含修复的 _convertStringToUserData 调用: $hasFixedStringBufferCall');

  final hasFixedPoolStatsCall1 =
      content.contains('CppString.convertString(this.totalStrings)');
  final hasFixedPoolStatsCall2 =
      content.contains('CppString.convertString(this.totalMemory)');
  print(
      '✓ 包含修复的 CppStringPoolStats 调用: ${hasFixedPoolStatsCall1 && hasFixedPoolStatsCall2}');

  final hasFixedMapCall1 =
      content.contains('CppString.convertString(iterator.current.key)');
  final hasFixedMapCall2 =
      content.contains('CppString.convertString(iterator.current.value)');
  print('✓ 包含修复的 Map toCppString 调用: ${hasFixedMapCall1 && hasFixedMapCall2}');

  print('\nstring.dart toString 转换修复测试结果:');

  if (directToStringCalls == 0 &&
      cppStringConvertStringCalls > 0 &&
      hasFixedStringBufferCall &&
      hasFixedPoolStatsCall1 &&
      hasFixedPoolStatsCall2 &&
      hasFixedMapCall1 &&
      hasFixedMapCall2) {
    print('✅ 所有测试通过！string.dart 中的 toString 调用已正确转换为 CppString.convertString。');
    print('   - 直接 .toString() 调用: $directToStringCalls 个（已全部转换）');
    print('   - CppString.convertString 调用: $cppStringConvertStringCalls 个');
    print(
        '   - 修复的调用位置: ✅ _convertStringToUserData ✅ CppStringPoolStats ✅ Map toCppString');
  } else {
    print('❌ 测试失败！');
    print('   - 直接 .toString() 调用: $directToStringCalls');
    print('   - CppString.convertString 调用: $cppStringConvertStringCalls');
    print('   - 修复状态:');
    print('     * _convertStringToUserData: $hasFixedStringBufferCall');
    print(
        '     * CppStringPoolStats: ${hasFixedPoolStatsCall1 && hasFixedPoolStatsCall2}');
    print('     * Map toCppString: ${hasFixedMapCall1 && hasFixedMapCall2}');
    exit(1);
  }
}
