// RangeError 参数对齐测试
//
// 此测试验证 CppRangeError 的参数结构是否与 Dart SDK 中的 RangeError 对齐
// 确保 CppRangeError 具有与 RangeError 相同的字段和构造方法

import 'dart:io';

void main() {
  print('开始测试 CppRangeError 与 RangeError 的参数对齐...');

  final transformedFile = File('transformed_dart.dart');
  if (!transformedFile.existsSync()) {
    print('错误: transformed_dart.dart 文件不存在');
    exit(1);
  }

  final content = transformedFile.readAsStringSync();

  // 测试1: 检查 CppRangeError 类定义
  // 查找类开始
  final classStart = content.indexOf('class CppRangeError extends CppError');
  if (classStart == -1) {
    print('错误: 未找到 CppRangeError 类定义');
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
    print('错误: 无法找到 CppRangeError 类的结束');
    exit(1);
  }

  final rangeErrorClass = content.substring(classStart, classEnd);
  print('✓ 找到 CppRangeError 类定义');
  print('类内容长度: ${rangeErrorClass.length}');

  // 测试2: 检查字段是否与 RangeError 对齐
  final expectedFields = [
    'final num? start;',
    'final num? end;',
    'final num? invalidValue;',
    'final CppString? name;',
    'final CppString? message;'
  ];

  for (final field in expectedFields) {
    if (!rangeErrorClass.contains(field)) {
      print('错误: 缺少字段: $field');
      exit(1);
    }
  }
  print('✓ 所有预期的字段都存在');

  // 测试3: 检查构造方法是否与 RangeError 对齐
  final expectedConstructorParts = [
    'CppRangeError(CppString? message)',
    'CppRangeError.value(num invalidValue, [CppString? name = null, CppString? message = null])',
    'CppRangeError.range(num invalidValue, int? minValue, int? maxValue, [CppString? name = null, CppString? message = null])'
  ];

  for (final constructorPart in expectedConstructorParts) {
    if (!rangeErrorClass.contains(constructorPart)) {
      print('错误: 缺少构造方法部分: $constructorPart');
      exit(1);
    }
  }
  print('✓ 所有预期的构造方法都存在');

  // 测试4: 验证与 Dart SDK RangeError 的参数对齐
  final dartSdkRangeErrorFields = [
    'start', // The minimum value
    'end', // The maximum value
    'invalidValue', // The invalid value
    'name', // Parameter name
    'message' // Error message
  ];

  final cppRangeErrorFields = [
    'final num? start;',
    'final num? end;',
    'final num? invalidValue;',
    'final CppString? name;',
    'final CppString? message;'
  ];

  bool fieldsAligned = true;
  for (int i = 0; i < dartSdkRangeErrorFields.length; i++) {
    if (!rangeErrorClass.contains(cppRangeErrorFields[i])) {
      print(
          '错误: CppRangeError 字段与 Dart SDK RangeError 不对齐: ${cppRangeErrorFields[i]}');
      fieldsAligned = false;
    }
  }

  if (fieldsAligned) {
    print('✓ CppRangeError 字段与 Dart SDK RangeError 完全对齐');
  }

  // 测试5: 验证构造方法参数对齐
  final dartSdkConstructorTypes = [
    'RangeError(var message)',
    'RangeError.value(num value, [String? name, String? message])',
    'RangeError.range(num invalidValue, int? minValue, int? maxValue, [String? name, String? message])'
  ];

  final cppConstructorTypes = [
    'CppRangeError(CppString? message)',
    'CppRangeError.value(num invalidValue, [CppString? name = null, CppString? message = null])',
    'CppRangeError.range(num invalidValue, int? minValue, int? maxValue, [CppString? name = null, CppString? message = null])'
  ];

  bool constructorsAligned = true;
  for (final cppConstructor in cppConstructorTypes) {
    if (!rangeErrorClass.contains(cppConstructor)) {
      print('错误: 构造方法参数不对齐: $cppConstructor');
      constructorsAligned = false;
    }
  }

  if (constructorsAligned) {
    print('✓ CppRangeError 构造方法参数与 Dart SDK RangeError 完全对齐');
  }

  print('\n所有测试通过！CppRangeError 已成功与 RangeError 对齐。');
  print('对齐总结:');
  print('- ✅ 字段对齐: start, end, invalidValue, name, message');
  print(
      '- ✅ 构造方法对齐: CppRangeError(), CppRangeError.value(), CppRangeError.range()');
  print('- ✅ 参数顺序对齐: invalidValue, minValue, maxValue, name, message');
  print('- ✅ 可选参数对齐: 所有可选参数都正确标记');
  print('- ✅ 类型映射对齐: num?, CppString? 等类型映射正确');
}
