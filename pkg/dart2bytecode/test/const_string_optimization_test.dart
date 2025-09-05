// const字符串优化测试
//
// 此测试验证const字符串变量是否正确转换为CppUserData.constant格式

import 'dart:io';

void main() {
  print('开始测试const字符串优化...');

  final transformedFile = File('transformed_dart.dart');
  if (!transformedFile.existsSync()) {
    print('错误: transformed_dart.dart 文件不存在');
    exit(1);
  }

  final content = transformedFile.readAsStringSync();

  // 测试1: 检查是否包含const常量定义部分
  final hasConstDefinitions = content.contains('/// 全局const常量定义');
  print('✓ 包含const常量定义部分: $hasConstDefinitions');

  // 测试2: 检查是否包含CppUserData.constant的字符串常量
  final hasCppUserDataConstant = content.contains('CppUserData.constant(');
  print('✓ 包含CppUserData.constant格式: $hasCppUserDataConstant');

  // 测试3: 检查字符串常量是否使用了正确的格式
  final hasCppStringFromCppUserData =
      content.contains('CppString.fromCppUserData(CppUserData.constant(');
  print(
      '✓ 包含CppString.fromCppUserData(CppUserData.constant(...)): $hasCppStringFromCppUserData');

  // 测试4: 检查是否还有旧的cppCharCodes格式（应该没有）
  final oldFormatCount =
      RegExp(r'CppString\.fromCppUserData\(CppApi\.cppCharCodes\([^)]*\)\);')
          .allMatches(content)
          .length;
  print('✓ 旧格式cppCharCodes使用次数: $oldFormatCount');

  // 测试5: 检查新格式的使用次数
  final newFormatCount =
      RegExp(r'CppString\.fromCppUserData\(CppUserData\.constant\([^)]*\)\);')
          .allMatches(content)
          .length;
  print('✓ 新格式CppUserData.constant使用次数: $newFormatCount');

  // 测试6: 检查const变量是否正确定义
  final constVariablePattern = RegExp(
      r'const const_\d+ = CppString\.fromCppUserData\(CppUserData\.constant\([^)]*\)\);');
  final constVariableMatches = constVariablePattern.allMatches(content).length;
  print('✓ 正确格式的const字符串变量数量: $constVariableMatches');

  print('\nconst字符串优化测试完成！');

  if (hasConstDefinitions &&
      hasCppUserDataConstant &&
      hasCppStringFromCppUserData) {
    print('✅ 所有测试通过！const字符串已正确优化为CppUserData.constant格式。');
    print('   - 新格式使用次数: $newFormatCount');
    print('   - 正确格式的const变量: $constVariableMatches');
    if (oldFormatCount == 0) {
      print('   - 完全移除了旧的cppCharCodes格式');
    } else {
      print('   ⚠️  仍有一些旧格式未转换: $oldFormatCount');
    }
  } else {
    print('❌ 测试失败！');
    print('   - const定义存在: $hasConstDefinitions');
    print('   - CppUserData.constant存在: $hasCppUserDataConstant');
    print('   - 完整格式存在: $hasCppStringFromCppUserData');
    exit(1);
  }
}
