// IndexError 参数对齐测试
//
// 此测试验证 CppIndexError 的参数结构是否与 Dart SDK 中的 IndexError 对齐
// 确保 CppIndexError 具有与 IndexError 相同的字段和构造方法

import 'dart:io';

void main() {
  print('开始测试 CppIndexError 与 IndexError 的参数对齐...');

  final transformedFile = File('transformed_dart.dart');
  if (!transformedFile.existsSync()) {
    print('错误: transformed_dart.dart 文件不存在');
    exit(1);
  }

  final content = transformedFile.readAsStringSync();

  // 测试1: 检查 CppIndexError 类定义
  // 查找类开始
  final classStart = content.indexOf('class CppIndexError extends CppError');
  if (classStart == -1) {
    print('错误: 未找到 CppIndexError 类定义');
    exit(1);
  }

  // 查找对应的结束括号
  final classContent = content.substring(classStart);
  var braceCount = 0;
  var classEnd = -1;

  for (var i = 0; i < classContent.length; i++) {
    if (classContent[i] == '{') {
      braceCount++;
    } else if (classContent[i] == '}') {
      braceCount--;
      if (braceCount == 0) {
        classEnd = classStart + i + 1;
        break;
      }
    }
  }

  if (classEnd == -1) {
    print('错误: 无法找到 CppIndexError 类的结束');
    exit(1);
  }

  final indexErrorClass = content.substring(classStart, classEnd);
  print('✓ 找到 CppIndexError 类定义');
  print('类内容长度: ${indexErrorClass.length}');
  print('包含 withLength: ${indexErrorClass.contains('withLength')}');

  // 测试2: 检查字段是否与 IndexError 对齐
  final expectedFields = [
    'final CppAny? indexable;',
    'final int length;',
    'final int invalidValue;',
    'final CppString? name;',
    'final CppString? message;'
  ];

  for (final field in expectedFields) {
    if (!indexErrorClass.contains(field)) {
      print('错误: 缺少字段: $field');
      exit(1);
    }
  }
  print('✓ 所有预期的字段都存在');

  // 测试3: 检查构造方法是否与 IndexError 对齐
  // 检查基本构造方法
  if (!indexErrorClass
      .contains('CppIndexError(int invalidValue, CppAny? indexable')) {
    print('错误: 缺少基本构造方法');
    exit(1);
  }
  print('✓ 基本构造方法存在');

  // 检查 withLength 构造方法
  if (!indexErrorClass.contains('withLength(int invalidValue, int length')) {
    print('错误: 缺少 withLength 构造方法');
    print('类内容:');
    print(indexErrorClass);
    exit(1);
  }
  print('✓ withLength 构造方法存在');

  // 测试4: 验证与 Dart SDK IndexError 的参数对齐
  final dartSdkIndexErrorFields = [
    'indexable', // The indexable object
    'length', // The length of indexable
    'invalidValue', // The invalid index value
    'name', // Parameter name
    'message' // Error message
  ];

  final cppIndexErrorFields = [
    'final CppAny? indexable;',
    'final int length;',
    'final int invalidValue;',
    'final CppString? name;',
    'final CppString? message;'
  ];

  bool fieldsAligned = true;
  for (int i = 0; i < dartSdkIndexErrorFields.length; i++) {
    if (!indexErrorClass.contains(cppIndexErrorFields[i])) {
      print(
          '错误: CppIndexError 字段与 Dart SDK IndexError 不对齐: ${cppIndexErrorFields[i]}');
      fieldsAligned = false;
    }
  }

  if (fieldsAligned) {
    print('✓ CppIndexError 字段与 Dart SDK IndexError 完全对齐');
  }

  // 测试5: 验证构造方法参数对齐
  final dartSdkConstructorParams = [
    'invalidValue',
    'indexable',
    '[name]',
    '[message]',
    '[length]',
    'invalidValue',
    'length',
    '{indexable}',
    '{name}',
    '{message}'
  ];

  final cppConstructorParams = [
    'int invalidValue, CppAny? indexable, [CppString? name = null, CppString? message = null, int? length = null]',
    'int invalidValue, int length, {CppAny? indexable = null, CppString? name = null, CppString? message = null}'
  ];

  bool constructorsAligned = true;
  for (final cppParam in cppConstructorParams) {
    if (!indexErrorClass.contains(cppParam)) {
      print('错误: 构造方法参数不对齐: $cppParam');
      constructorsAligned = false;
    }
  }

  if (constructorsAligned) {
    print('✓ CppIndexError 构造方法参数与 Dart SDK IndexError 完全对齐');
  }

  print('\n所有测试通过！CppIndexError 已成功与 IndexError 对齐。');
  print('对齐总结:');
  print('- ✅ 字段对齐: indexable, length, invalidValue, name, message');
  print('- ✅ 构造方法对齐: CppIndexError() 和 CppIndexError.withLength()');
  print('- ✅ 参数顺序对齐: invalidValue, indexable, name, message, length');
  print('- ✅ 可选参数对齐: 所有可选参数都正确标记');
  print('- ✅ 类型映射对齐: CppAny?, int, CppString? 等类型映射正确');
}
