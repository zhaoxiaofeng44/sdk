// const常量定义完整性测试
//
// 此测试验证const常量定义是否完整且正确

import 'dart:io';

void main() {
  print('开始测试const常量定义完整性...');

  final transformedFile = File('transformed_dart.dart');
  if (!transformedFile.existsSync()) {
    print('错误: transformed_dart.dart 文件不存在');
    exit(1);
  }

  final content = transformedFile.readAsStringSync();

  // 测试1: 检查const常量定义是否存在
  final hasConstDefinitions = content.contains('/// 全局const常量定义');
  print('✓ 包含const常量定义部分: $hasConstDefinitions');

  // 测试2: 检查所有使用的const变量都有定义
  final constUsage = RegExp(r'const_\d+').allMatches(content).toList();
  final constDefinitions =
      RegExp(r'const const_\d+ =').allMatches(content).toList();

  print('✓ 发现 ${constUsage.length} 个const变量的使用');
  print('✓ 发现 ${constDefinitions.length} 个const变量的定义');

  // 提取使用的变量名
  final usedVars = constUsage.map((m) => m.group(0)!).toSet();

  // 提取定义的变量名
  final definedVars = constDefinitions
      .map((m) {
        final match = RegExp(r'const (const_\d+) =').firstMatch(m.group(0)!);
        return match?.group(1);
      })
      .where((v) => v != null)
      .toSet();

  // 检查是否有未定义的变量
  final undefinedVars = usedVars.difference(definedVars);
  final unusedVars = definedVars.difference(usedVars);

  if (undefinedVars.isEmpty) {
    print('✓ 所有使用的const变量都有定义');
  } else {
    print('❌ 发现未定义的const变量: $undefinedVars');
  }

  if (unusedVars.isNotEmpty) {
    print('⚠️  发现未使用的const变量: $unusedVars');
  }

  // 测试3: 验证const_1的定义
  final hasConst1Definition = content.contains('const const_1 = [];');
  print('✓ const_1 有正确的定义: $hasConst1Definition');

  // 测试4: 检查const常量定义的格式
  final constDefPattern = RegExp(r'const const_\d+ = .+;');
  final validDefinitions = constDefPattern.allMatches(content).length;
  print('✓ 发现 ${validDefinitions} 个格式正确的const常量定义');

  print('\nconst常量定义完整性测试完成！');

  if (undefinedVars.isEmpty && hasConst1Definition) {
    print('✅ 所有测试通过！const常量收集功能正常工作。');
  } else {
    print('❌ 测试失败！');
    exit(1);
  }
}
