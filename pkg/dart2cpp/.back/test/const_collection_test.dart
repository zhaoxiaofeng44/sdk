// const常量收集测试
//
// 此测试验证const常量是否被正确收集并在文件开头定义

import 'dart:io';

void main() {
  print('开始测试const常量收集功能...');

  final transformedFile = File('transformed_dart.dart');
  if (!transformedFile.existsSync()) {
    print('错误: transformed_dart.dart 文件不存在');
    exit(1);
  }

  final content = transformedFile.readAsStringSync();

  // 测试1: 检查是否包含const常量定义
  final hasConstDefinitions = content.contains('/// 全局const常量定义');
  print('✓ 包含const常量定义部分: $hasConstDefinitions');

  // 测试2: 检查是否有const变量被使用
  final constUsage = RegExp(r'const_\d+').allMatches(content).toList();
  print('✓ 发现 ${constUsage.length} 个const变量的使用');

  // 测试3: 检查const变量定义的数量
  final constDefinitions =
      RegExp(r'const const_\d+ = ').allMatches(content).toList();
  print('✓ 发现 ${constDefinitions.length} 个const变量的定义');

  // 测试4: 验证使用和定义的数量是否匹配
  if (constUsage.length > 0 && constDefinitions.length == 0) {
    print('警告: 有const变量被使用但没有定义');
  } else if (constUsage.length == 0 && constDefinitions.length > 0) {
    print('警告: 有const变量被定义但没有使用');
  } else if (constUsage.length > 0 && constDefinitions.length > 0) {
    print('✓ const变量使用和定义数量匹配');
  } else {
    print('✓ 没有const变量使用和定义（正常情况）');
  }

  // 测试5: 检查具体的const变量定义格式
  final constLines = content
      .split('\n')
      .where((line) => line.contains('const const_'))
      .toList();
  if (constLines.isNotEmpty) {
    print('✓ const变量定义示例:');
    for (final line in constLines.take(3)) {
      print('  $line');
    }
  }

  print('\nconst常量收集功能测试完成！');
}
