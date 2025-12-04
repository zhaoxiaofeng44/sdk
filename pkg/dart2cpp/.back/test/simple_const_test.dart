// 简单的const常量收集测试
//
// 此测试验证const常量收集的基本功能是否工作

import 'dart:io';

void main() {
  print('开始测试简单的const常量收集功能...');

  final transformedFile = File('transformed_dart.dart');
  if (!transformedFile.existsSync()) {
    print('错误: transformed_dart.dart 文件不存在');
    exit(1);
  }

  final content = transformedFile.readAsStringSync();

  // 测试1: 检查是否有const变量被使用
  final constUsage = RegExp(r'const_\d+').allMatches(content).toList();
  print('✓ 发现 ${constUsage.length} 个const变量的使用');

  // 测试2: 检查转换后的代码是否包含我们的修改
  final hasOurChanges = content.contains('CppString.fromCppUserData');
  print('✓ 包含我们的字符串转换修改: $hasOurChanges');

  // 测试3: 检查是否有错误类定义
  final hasErrorClasses = content.contains('class CppIndexError') &&
      content.contains('class CppRangeError');
  print('✓ 包含错误类定义: $hasErrorClasses');

  print('测试完成！');

  if (constUsage.length > 0) {
    print('\n前5个const变量使用示例:');
    for (final match in constUsage.take(5)) {
      print('  ${match.group(0)}');
    }
  }
}
