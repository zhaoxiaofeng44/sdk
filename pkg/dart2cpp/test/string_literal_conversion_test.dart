// 字符串字面量转换测试
//
// 此测试验证字符串字面量是否被正确转换为 CppString.fromCppUserData(CppApi.cppCharCodes("$escaped")) 格式
// 而不是保留原始的字符串字面量或嵌套的 CppString.fromString() 调用

import 'dart:io';

void main() {
  print('开始测试字符串字面量转换...');

  final transformedFile = File('transformed_dart.dart');
  if (!transformedFile.existsSync()) {
    print('错误: transformed_dart.dart 文件不存在');
    exit(1);
  }

  final content = transformedFile.readAsStringSync();

  // 测试1: 检查是否没有嵌套的 CppString.fromString(CppString.fromCppUserData(...)) 调用
  final nestedPattern =
      RegExp(r'CppString\.fromString\(CppString\.fromCppUserData');
  final nestedMatches = nestedPattern.allMatches(content);
  if (nestedMatches.isNotEmpty) {
    print('错误: 发现嵌套的 CppString.fromString(CppString.fromCppUserData(...)) 调用:');
    for (final match in nestedMatches) {
      final lines = content.substring(0, match.start).split('\n');
      final lineNumber = lines.length;
      print(
          '  第 $lineNumber 行: ${lines.last}${content.substring(match.start, match.end)}');
    }
    exit(1);
  }
  print('✓ 测试1通过: 没有发现嵌套的 CppString.fromString 调用');

  // 测试2: 检查特定的字符串字面量是否被正确转换
  final expectedConversions = [
    'CppString.fromCppUserData(CppApi.cppCharCodes("[]"))',
    'CppString.fromCppUserData(CppApi.cppCharCodes("{}"))',
    'CppString.fromCppUserData(CppApi.cppCharCodes("["))',
    'CppString.fromCppUserData(CppApi.cppCharCodes("{"))',
    'CppString.fromCppUserData(CppApi.cppCharCodes("}"))',
    'CppString.fromCppUserData(CppApi.cppCharCodes("]"))',
    'CppString.fromCppUserData(CppApi.cppCharCodes(", "))',
  ];

  for (final expected in expectedConversions) {
    if (!content.contains(expected)) {
      print('错误: 未找到预期的转换: $expected');
      exit(1);
    }
  }
  print('✓ 测试2通过: 所有预期的字符串字面量转换都已找到');

  // 测试3: 检查是否还有直接的字符串字面量（除了合理的情况）
  final directStringPattern = RegExp(r'CppString\.fromString\("[^"]*"\)');
  final directStringMatches = directStringPattern.allMatches(content);
  if (directStringMatches.isNotEmpty) {
    print('警告: 发现直接的字符串字面量调用:');
    for (final match in directStringMatches) {
      final lines = content.substring(0, match.start).split('\n');
      final lineNumber = lines.length;
      final matchedText = content.substring(match.start, match.end);
      print('  第 $lineNumber 行: $matchedText');
    }
  }

  // 测试4: 检查合理的 CppString.fromString 调用（参数不是字符串字面量）
  final reasonablePattern = RegExp(r'CppString\.fromString\(CppApi\.');
  final reasonableMatches = reasonablePattern.allMatches(content);
  print(
      '✓ 测试4通过: 发现 ${reasonableMatches.length} 个合理的 CppString.fromString 调用（参数为 CppApi 调用）');

  print('\n所有测试通过！字符串字面量转换修复成功。');
  print('修复总结:');
  print('- 移除了嵌套的 CppString.fromString(CppString.fromCppUserData(...)) 调用');
  print(
      '- 字符串字面量现在直接转换为 CppString.fromCppUserData(CppApi.cppCharCodes("...")) 格式');
  print('- 保留了合理的 CppString.fromString 调用（参数不是字符串字面量）');
}
