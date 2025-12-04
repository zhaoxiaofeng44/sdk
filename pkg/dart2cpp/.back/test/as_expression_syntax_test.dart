// as 表达式语法修复测试
//
// 此测试验证所有as表达式的语法是否正确（括号使用）

import 'dart:io';

void main() {
  print('开始测试as表达式语法修复...');

  final transformedFile = File(
      '/Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/transformed_dart.dart');
  if (!transformedFile.existsSync()) {
    print('错误: transformed_dart.dart 文件不存在');
    exit(1);
  }

  final content = transformedFile.readAsStringSync();

  // 测试1: 检查是否有语法错误的as表达式（缺少括号）
  final badAsExpressions =
      RegExp(r'\w+\s+as\s+[A-Za-z_][A-Za-z0-9_]*\s*[=!<>+\-*/&|^]')
          .allMatches(content);
  print('✓ 发现潜在语法问题的as表达式: ${badAsExpressions.length} 个');

  // 测试2: 检查正确括号的as表达式数量
  final goodAsExpressions =
      RegExp(r'\(\w+\s+as\s+[A-Za-z_][A-Za-z0-9_]*\)').allMatches(content);
  print('✓ 发现正确括号的as表达式: ${goodAsExpressions.length} 个');

  // 测试3: 检查具体的语法错误模式
  final syntaxErrors = [];

  // 检查 as int == 模式（缺少括号）
  final missingParensPattern = RegExp(r'as\s+int\s*==');
  final missingParensMatches = missingParensPattern.allMatches(content);
  syntaxErrors.addAll(
      missingParensMatches.map((m) => 'as int == (line ~${m.start ~/ 100})'));

  // 检查 as int & 模式（缺少括号）
  final missingParensBitwise = RegExp(r'as\s+int\s*[&|]');
  final missingParensBitwiseMatches = missingParensBitwise.allMatches(content);
  syntaxErrors.addAll(missingParensBitwiseMatches
      .map((m) => 'as int &| (line ~${m.start ~/ 100})'));

  print('✓ 发现的语法错误: ${syntaxErrors.length} 个');
  if (syntaxErrors.isNotEmpty) {
    syntaxErrors.forEach((error) => print('  - $error'));
  }

  // 测试4: 检查修复后的正确模式
  final fixedAsExpressions =
      RegExp(r'\(CppApi\.cppGetPointerArrayItem\([^)]+\)\s+as\s+int\)')
          .allMatches(content);
  print('✓ 修复后的正确as表达式: ${fixedAsExpressions.length} 个');

  // 测试5: 检查是否有未修复的问题表达式
  final problematicExpressions = RegExp(
          r'CppApi\.cppGetPointerArrayItem\([^)]+\)\s+as\s+int\s*[=!<>+\-*/&|^]')
      .allMatches(content);
  print('✓ 剩余的潜在问题表达式: ${problematicExpressions.length} 个');

  if (problematicExpressions.isNotEmpty) {
    print('  发现的问题表达式:');
    for (final match in problematicExpressions.take(3)) {
      final start = match.start > 50 ? match.start - 50 : 0;
      final end =
          match.end + 50 < content.length ? match.end + 50 : content.length;
      final context = content.substring(start, end);
      print('    ...${context.replaceAll('\n', ' ')}...');
    }
  }

  print('\nas表达式语法修复测试结果:');

  if (syntaxErrors.isEmpty && problematicExpressions.isEmpty) {
    print('✅ 所有测试通过！as表达式语法问题已修复。');
    print('   - 语法错误: 0 个');
    print('   - 修复后的表达式: ${fixedAsExpressions.length} 个');
    print('   - 剩余问题: 0 个');
  } else {
    print('❌ 测试失败！');
    print('   - 语法错误: ${syntaxErrors.length} 个');
    print('   - 剩余问题表达式: ${problematicExpressions.length} 个');
    if (syntaxErrors.isNotEmpty) {
      print('   语法错误详情:');
      syntaxErrors.forEach((error) => print('     - $error'));
    }
    exit(1);
  }
}
