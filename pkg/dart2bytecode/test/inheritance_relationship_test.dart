import 'dart:io';

void main() {
  print('=== 验证继承关系修改测试 ===');

  // 读取生成的头文件
  final outputFile = File('output.h');
  if (!outputFile.existsSync()) {
    print('❌ 错误：output.h 文件不存在');
    return;
  }

  final content = outputFile.readAsStringSync();

  bool hasInheritanceIssues = false;

  // 检查实现类的继承关系
  print('\n=== 检查实现类的继承关系 ===');

  final implementationClasses = {
    'CppList': 'ListBase',
    'CppSet': 'Set',
    'CppMap': 'Map',
    'CppWasmMap': 'UnmodifiableMapView'
  };

  for (final entry in implementationClasses.entries) {
    final className = entry.key;
    final baseName = entry.value;

    final classPattern = RegExp(
        'class $className : virtual public Object, virtual public $baseName');
    if (content.contains(classPattern)) {
      print('✅ $className 正确继承自 Object 和 $baseName');
    } else {
      print('❌ $className 继承关系错误，应该继承自 Object 和 $baseName');
      hasInheritanceIssues = true;
    }
  }

  // 检查接口类的定义
  print('\n=== 检查接口类的定义 ===');

  final interfaceClasses = [
    'List',
    'Set',
    'Map',
    'UnmodifiableMapView',
    'Iterator',
    'Iterable',
    'ListBase'
  ];

  for (final interfaceName in interfaceClasses) {
    final structPattern = RegExp('struct $interfaceName \\{[^}]+\\}');
    if (structPattern.hasMatch(content)) {
      print('✅ $interfaceName 正确定义为接口（struct）');
    } else {
      print('❌ $interfaceName 接口定义有误');
      hasInheritanceIssues = true;
    }
  }

  // 检查抽象类的继承关系
  print('\n=== 检查抽象类的继承关系 ===');

  final abstractClasses = {
    'ListBase': ['Object', 'List'],
    'MapBase': ['Object', 'Map'],
    'SetBase': ['Object', 'Set']
  };

  for (final entry in abstractClasses.entries) {
    final className = entry.key;
    final baseClasses = entry.value;

    final classPattern = RegExp(
        'class ${className}Imp : virtual public ${baseClasses[0]}, virtual public ${baseClasses[1]}');
    if (content.contains(classPattern)) {
      print('✅ ${className}Imp 正确继承自 ${baseClasses.join(" 和 ")}');
    } else {
      print('❌ ${className}Imp 继承关系错误，应该继承自 ${baseClasses.join(" 和 ")}');
      hasInheritanceIssues = true;
    }
  }

  // 检查普通类的继承关系
  print('\n=== 检查普通类的继承关系 ===');

  final regularClasses = {
    'StringBuffer': 'Object',
    'Int': 'Object',
    'Double': 'Object',
    'Bool': 'Object',
    'String': 'Object'
  };

  for (final entry in regularClasses.entries) {
    final className = entry.key;
    final baseClass = entry.value;

    final classPattern = RegExp('class $className : virtual public $baseClass');
    if (content.contains(classPattern)) {
      print('✅ $className 正确继承自 $baseClass');
    } else {
      print('❌ $className 继承关系错误，应该继承自 $baseClass');
      hasInheritanceIssues = true;
    }
  }

  if (!hasInheritanceIssues) {
    print('\n✅ 所有继承关系验证通过');
  } else {
    print('\n❌ 继承关系验证失败，需要修复');
  }

  print('\n=== 测试完成 ===');
}
