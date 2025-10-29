// cppUserDataEmpty 使用优化测试
//
// 此测试验证 cppUserDataEmpty 的定义和使用是否正确优化

import 'dart:io';

void main() {
  print('开始测试 cppUserDataEmpty 优化...');

  final transformedFile = File(
      '/Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/transformed_dart.dart');
  if (!transformedFile.existsSync()) {
    print('错误: transformed_dart.dart 文件不存在');
    exit(1);
  }

  final content = transformedFile.readAsStringSync();

  // 测试1: 检查 cppUserDataEmpty 的定义是否正确
  final cppUserDataEmptyDefinition = content.contains(
      'const CppUserData cppUserDataEmpty = CppUserData.constant([]);');
  print('✓ cppUserDataEmpty 定义正确: $cppUserDataEmptyDefinition');

  // 测试2: 检查 cppUserDataEmpty 是否被使用（而不是常量）
  final cppUserDataEmptyUsage =
      RegExp(r'\bcppUserDataEmpty\b').allMatches(content).length;
  print('✓ cppUserDataEmpty 使用次数: $cppUserDataEmptyUsage');

  // 测试3: 检查是否没有生成多余的const常量定义
  final constCppUserDataConstant =
      content.contains('const cppUserDataEmpty = CppUserData.constant([]);');
  print('✓ 没有生成多余的const定义: ${!constCppUserDataConstant}');

  // 测试4: 检查原始代码中的使用是否被正确转换
  final originalUsageConverted = content.contains(
      'CppList<CppUserData>.from(CppArrayList<CppUserData>.fromCppArray(CppApi.cppArrayConst(1, cppUserDataEmpty))');
  print('✓ 原始使用被正确转换: $originalUsageConverted');

  // 测试5: 检查const常量定义中是否包含cppUserDataEmpty
  final constDefinitions =
      content.split('/// 全局const常量定义')[1]?.split('/// 全局const常量定义')[0] ?? '';
  final hasCppUserDataEmptyInConst =
      constDefinitions.contains('cppUserDataEmpty');
  print('✓ const定义中不包含cppUserDataEmpty: ${!hasCppUserDataEmptyInConst}');

  print('\ncppUserDataEmpty 优化测试结果:');

  if (cppUserDataEmptyDefinition &&
      cppUserDataEmptyUsage > 1 &&
      !constCppUserDataConstant &&
      originalUsageConverted &&
      !hasCppUserDataEmptyInConst) {
    print('✅ 所有测试通过！cppUserDataEmpty 优化成功。');
    print('   - 定义正确 ✓');
    print('   - 使用次数: $cppUserDataEmptyUsage');
    print('   - 无多余const定义 ✓');
    print('   - 原始使用转换 ✓');
    print('   - 不包含在const定义中 ✓');
  } else {
    print('❌ 测试失败！');
    print('   - 定义正确: $cppUserDataEmptyDefinition');
    print('   - 使用次数: $cppUserDataEmptyUsage');
    print('   - 无多余const定义: ${!constCppUserDataConstant}');
    print('   - 原始使用转换: $originalUsageConverted');
    print('   - 不包含在const定义中: ${!hasCppUserDataEmptyInConst}');
    exit(1);
  }
}
