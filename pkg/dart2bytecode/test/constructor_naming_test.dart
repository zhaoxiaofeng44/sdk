import 'dart:io';

void main() {
  print('=== 验证构造函数命名规则测试 ===');

  // 读取生成的头文件
  final outputFile = File('output.h');
  if (!outputFile.existsSync()) {
    print('❌ 错误：output.h 文件不存在');
    return;
  }

  final content = outputFile.readAsStringSync();

  // 检查构造函数命名规则
  print('\n=== 检查构造函数命名规则 ===');

  bool hasNamingIssues = false;

  // 不应该出现的旧格式构造函数名
  final unwantedConstructorNames = [
    'StringBuffer_cppCtr_',
    'Calculator_cppCtr_',
    'TestClass_cppCtr_',
    'Container_cppCtr_',
    'Animal_cppCtr_',
  ];

  // 应该使用的新格式构造函数名
  final expectedConstructorNames = [
    'cppCtr_', // 默认构造函数
    'cppCtr_withParams', // 带参数的构造函数
    'cppCtr_fromString', // 命名构造函数
  ];

  // 检查不应该出现的旧格式
  for (final name in unwantedConstructorNames) {
    if (content.contains(name)) {
      print('❌ 发现旧格式构造函数名: $name');
      hasNamingIssues = true;
    } else {
      print('✅ 已移除旧格式构造函数名: $name');
    }
  }

  print('\n=== 检查新格式构造函数名 ===');

  // 检查应该使用的新格式
  for (final name in expectedConstructorNames) {
    if (content.contains(name)) {
      print('✅ 正确使用新格式构造函数名: $name');
    } else {
      print('❌ 缺少新格式构造函数名: $name');
      hasNamingIssues = true;
    }
  }

  // 检查类定义中的构造函数声明
  print('\n=== 检查类定义中的构造函数声明 ===');

  final classDefinitions = [
    RegExp(r'class StringBuffer[^}]+}'),
    RegExp(r'class Calculator[^}]+}'),
    RegExp(r'class TestClass[^}]+}'),
  ];

  for (final classRegex in classDefinitions) {
    final match = classRegex.firstMatch(content);
    if (match != null) {
      final classContent = match.group(0)!;
      if (classContent.contains('_cppCtr_') &&
          !RegExp(r'[A-Za-z]+_cppCtr_').hasMatch(classContent)) {
        print('✅ 类定义中构造函数命名正确');
      } else if (RegExp(r'[A-Za-z]+_cppCtr_').hasMatch(classContent)) {
        print('❌ 类定义中仍包含带类名前缀的构造函数');
        hasNamingIssues = true;
      }
    }
  }

  if (!hasNamingIssues) {
    print('\n✅ 所有构造函数命名规则验证通过');
  } else {
    print('\n❌ 构造函数命名规则验证失败，需要修复');
  }

  print('\n=== 测试完成 ===');
}
