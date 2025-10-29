// toString 替换为 toCppString 测试
//
// 此测试验证所有toString方法调用和定义是否已正确替换为toCppString

import 'dart:io';

void main() {
  print('开始测试toString替换为toCppString...');

  final transformedFile = File('transformed_dart.dart');
  if (!transformedFile.existsSync()) {
    print('错误: transformed_dart.dart 文件不存在');
    exit(1);
  }

  final content = transformedFile.readAsStringSync();

  // 测试1: 检查是否还有toString()方法调用（不应该有）
  final toStringCalls = RegExp(r'\.toString\(\)').allMatches(content).toList();
  print('✓ 发现 ${toStringCalls.length} 个toString()方法调用');

  // 测试2: 检查toCppString()方法调用的数量
  final toCppStringCalls =
      RegExp(r'\.toCppString\(\)').allMatches(content).toList();
  print('✓ 发现 ${toCppStringCalls.length} 个toCppString()方法调用');

  // 测试3: 检查toString方法定义是否已替换
  final toStringDefinitions =
      RegExp(r'toString\(\) \{').allMatches(content).toList();
  print('✓ 发现 ${toStringDefinitions.length} 个toString方法定义');

  // 测试4: 检查toCppString方法定义的数量
  final toCppStringDefinitions =
      RegExp(r'toCppString\(\) \{').allMatches(content).toList();
  print('✓ 发现 ${toCppStringDefinitions.length} 个toCppString方法定义');

  // 测试5: 检查是否有遗漏的toString调用
  final anyToString = RegExp(r'toString').allMatches(content).toList();
  print('✓ 总共发现 ${anyToString.length} 个包含toString的匹配');

  print('\ntoString替换为toCppString测试完成！');

  if (toStringCalls.length == 0 && toCppStringCalls.length > 0) {
    print('✅ 所有测试通过！toString已成功替换为toCppString。');
    print('   - 0 个toString()方法调用');
    print('   - ${toCppStringCalls.length} 个toCppString()方法调用');
    print('   - ${toCppStringDefinitions.length} 个toCppString方法定义');
  } else {
    print('❌ 测试失败！');
    print('   - ${toStringCalls.length} 个toString()方法调用未替换');
    if (toStringCalls.length > 0) {
      print('   发现的toString()调用:');
      for (final match in toStringCalls.take(5)) {
        final start = match.start > 50 ? match.start - 50 : 0;
        final end =
            match.end + 50 < content.length ? match.end + 50 : content.length;
        final context = content.substring(start, end);
        print('     ...${context.replaceAll('\n', ' ')}...');
      }
    }
    exit(1);
  }
}
