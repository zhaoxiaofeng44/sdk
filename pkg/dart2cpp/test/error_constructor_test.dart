// 错误类构造方法测试
//
// 此测试验证 CppIndexError 和 CppRangeError 的构造方法是否与预期一致
// 确保它们都有相同的 message 参数和构造模式

import 'dart:io';

void main() {
  print('开始测试错误类构造方法...');

  final transformedFile = File('transformed_dart.dart');
  if (!transformedFile.existsSync()) {
    print('错误: transformed_dart.dart 文件不存在');
    exit(1);
  }

  final content = transformedFile.readAsStringSync();

  // 测试1: 检查 CppRangeError 类定义
  final rangeErrorPattern =
      RegExp(r'class CppRangeError extends CppError \{[^}]*\}', dotAll: true);
  final rangeErrorMatch = rangeErrorPattern.firstMatch(content);
  if (rangeErrorMatch == null) {
    print('错误: 未找到 CppRangeError 类定义');
    exit(1);
  }

  final rangeErrorClass = rangeErrorMatch.group(0)!;
  print('✓ 找到 CppRangeError 类定义');

  // 检查 CppRangeError 是否有 message 字段
  if (!rangeErrorClass.contains('late CppString message;')) {
    print('错误: CppRangeError 缺少 message 字段');
    exit(1);
  }
  print('✓ CppRangeError 包含 message 字段');

  // 检查 CppRangeError 是否有正确的构造方法
  if (!rangeErrorClass.contains(
      'CppRangeError(CppString message) : message = message, super()')) {
    print('错误: CppRangeError 构造方法不正确');
    exit(1);
  }
  print('✓ CppRangeError 构造方法正确');

  // 测试2: 检查 CppIndexError 类定义
  final indexErrorPattern =
      RegExp(r'class CppIndexError extends CppError \{[^}]*\}', dotAll: true);
  final indexErrorMatch = indexErrorPattern.firstMatch(content);
  if (indexErrorMatch == null) {
    print('错误: 未找到 CppIndexError 类定义');
    exit(1);
  }

  final indexErrorClass = indexErrorMatch.group(0)!;
  print('✓ 找到 CppIndexError 类定义');

  // 检查 CppIndexError 是否有 message 字段
  if (!indexErrorClass.contains('late CppString message;')) {
    print('错误: CppIndexError 缺少 message 字段');
    exit(1);
  }
  print('✓ CppIndexError 包含 message 字段');

  // 检查 CppIndexError 是否有正确的构造方法
  if (!indexErrorClass.contains(
      'CppIndexError(CppString message) : message = message, super()')) {
    print('错误: CppIndexError 构造方法不正确');
    exit(1);
  }
  print('✓ CppIndexError 构造方法正确');

  // 测试3: 验证两个类的构造方法完全一致
  final rangeErrorConstructor = RegExp(
      r'CppRangeError\(CppString message\) : message = message, super\(\)');
  final indexErrorConstructor = RegExp(
      r'CppIndexError\(CppString message\) : message = message, super\(\)');

  if (!rangeErrorConstructor.hasMatch(rangeErrorClass) ||
      !indexErrorConstructor.hasMatch(indexErrorClass)) {
    print('错误: 两个类的构造方法不一致');
    exit(1);
  }
  print('✓ 两个类的构造方法完全一致');

  // 测试4: 检查字段声明是否一致
  if (!rangeErrorClass.contains('late CppString message;') ||
      !indexErrorClass.contains('late CppString message;')) {
    print('错误: 两个类的字段声明不一致');
    exit(1);
  }
  print('✓ 两个类的字段声明完全一致');

  print('\n所有测试通过！错误类构造方法修复成功。');
  print('修复总结:');
  print('- CppIndexError 现在具有与 CppRangeError 完全一致的构造方法');
  print('- 两个类都有 message 字段和相同的构造参数');
  print('- 构造方法都正确初始化 message 字段并调用父类构造方法');
  print('- 代码结构更加一致和规范');
}
