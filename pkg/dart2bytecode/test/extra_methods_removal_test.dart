import 'dart:io';

void main() {
  print('=== 验证额外方法删除测试 ===');

  // 读取生成的头文件
  final outputFile = File('output.h');
  if (!outputFile.existsSync()) {
    print('❌ 错误：output.h 文件不存在');
    return;
  }

  final content = outputFile.readAsStringSync();

  // 检查是否还包含额外的方法
  final extraMethods = [
    'toStringImpl',
    'hashCodeImpl',
    'equalsImpl',
    'runtimeTypeImpl'
  ];

  bool hasExtraMethods = false;

  for (final method in extraMethods) {
    if (content.contains(method)) {
      print('❌ 发现额外方法: $method');
      hasExtraMethods = true;
    }
  }

  if (!hasExtraMethods) {
    print('✅ 所有额外方法已成功删除');
  }

  // 检查类是否只包含自己的方法
  print('\n=== 检查类方法结构 ===');

  // 检查 CyBase 类
  final cyBaseMatch =
      RegExp(r'class CyBase : virtual public Object \{[^}]+\};', dotAll: true)
          .firstMatch(content);
  if (cyBaseMatch != null) {
    final cyBaseContent = cyBaseMatch.group(0)!;
    if (cyBaseContent.contains('CyBase_test') &&
        !cyBaseContent.contains('CyFather_') &&
        !cyBaseContent.contains('CyChild_')) {
      print('✅ CyBase 只包含自己的方法');
    } else {
      print('❌ CyBase 包含其他类的方法');
      print('CyBase内容: $cyBaseContent');
    }
  }

  // 检查 CyFather 类
  final cyFatherMatch =
      RegExp(r'class CyFather : virtual public CyBase \{[^}]+\};', dotAll: true)
          .firstMatch(content);
  if (cyFatherMatch != null) {
    final cyFatherContent = cyFatherMatch.group(0)!;
    if (cyFatherContent.contains('CyFather_myTest') &&
        !cyFatherContent.contains('CyBase_test') &&
        !cyFatherContent.contains('CyChild_')) {
      print('✅ CyFather 只包含自己的方法');
    } else {
      print('❌ CyFather 包含其他类的方法');
      print('CyFather内容: $cyFatherContent');
    }
  }

  // 检查 CyChild 类
  final cyChildMatch = RegExp(
          r'class CyChild : virtual public CyFather \{[^}]+\};',
          dotAll: true)
      .firstMatch(content);
  if (cyChildMatch != null) {
    final cyChildContent = cyChildMatch.group(0)!;
    if (cyChildContent.contains('CyChild_myTest') &&
        !cyChildContent.contains('CyBase_test') &&
        !cyChildContent.contains('CyFather_myTest')) {
      print('✅ CyChild 只包含自己的方法');
    } else {
      print('❌ CyChild 包含其他类的方法');
      print('CyChild内容: $cyChildContent');
    }
  }

  // 检查继承关系
  print('\n=== 检查继承关系 ===');
  if (content.contains('class CyBase : virtual public Object')) {
    print('✅ CyBase 正确继承自 Object');
  } else {
    print('❌ CyBase 继承关系错误');
  }

  if (content.contains('class CyFather : virtual public CyBase')) {
    print('✅ CyFather 正确继承自 CyBase');
  } else {
    print('❌ CyFather 继承关系错误');
  }

  if (content.contains('class CyChild : virtual public CyFather')) {
    print('✅ CyChild 正确继承自 CyFather');
  } else {
    print('❌ CyChild 继承关系错误');
  }

  print('\n=== 测试完成 ===');
}
