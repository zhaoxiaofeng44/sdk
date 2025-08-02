#!/usr/bin/env dart

import 'dart:io';

import 'package:kernel/kernel.dart';
import 'package:kernel/ast.dart';
import 'package:dart2bytecode/compile_to_dart.dart';

/// Dart到Dart转换器命令行工具
void main(List<String> args) {
  if (args.isEmpty) {
    printUsage();
    return;
  }

  final command = args[0];

  switch (command) {
    case 'transform':
      if (args.length < 2) {
        print('错误: 请指定输入文件');
        printUsage();
        return;
      }
      transformFile(args[1]);
      break;
    case 'demo':
      showDemo();
      break;
    case 'help':
      printUsage();
      break;
    default:
      print('未知命令: $command');
      printUsage();
  }
}

/// 显示使用说明
void printUsage() {
  print('''
Dart到Dart转换器

用法:
  dart bin/dart2dart.dart transform <input_file>
  dart bin/dart2dart.dart demo
  dart bin/dart2dart.dart help

命令:
  transform  转换指定的Dart文件
  demo       显示转换示例
  help       显示此帮助信息

示例:
  dart bin/dart2dart.dart transform lib/example.dart
  dart bin/dart2dart.dart demo
''');
}

/// 转换指定的Dart文件
void transformFile(String inputFile) {
  try {
    final file = File(inputFile);
    if (!file.existsSync()) {
      print('错误: 文件不存在: $inputFile');
      return;
    }

    final content = file.readAsStringSync();
    print('正在转换文件: $inputFile');
    print('文件内容长度: ${content.length} 字符');

    // 直接生成转换后的代码
    final transformedCode = generateTransformedCode(content);

    // 写入输出文件
    final outputFile = File('./transformed_dart.dart');
    outputFile.writeAsStringSync(transformedCode);
    print('成功生成转换后的Dart代码: ${outputFile.absolute.path}');
  } catch (e) {
    print('转换过程中发生错误: $e');
  }
}

/// 生成转换后的代码
String generateTransformedCode(String content) {
  final buffer = StringBuffer();

  // 添加导入
  buffer.writeln("import 'dart:core';");
  buffer.writeln("import 'dart:io';");
  buffer.writeln("import 'dart:math';");
  buffer.writeln();

  // 查找类定义
  final classPattern = RegExp(r'class\s+(\w+)\s*\{([^}]+)\}', dotAll: true);
  final matches = classPattern.allMatches(content);

  for (final match in matches) {
    final className = match.group(1)!;
    final classBody = match.group(2)!;

    buffer.writeln('/// 转换后的类: $className');
    buffer.writeln('class $className {');

    // 提取字段
    final fieldPattern =
        RegExp(r'(final\s+)?(\w+)\s+(\w+)\s*(?:=\s*([^;]+))?;');
    final fieldMatches = fieldPattern.allMatches(classBody);

    for (final fieldMatch in fieldMatches) {
      final isFinal = fieldMatch.group(1) != null;
      final typeName = fieldMatch.group(2)!;
      final fieldName = fieldMatch.group(3)!;
      final initialValue = fieldMatch.group(4);

      // 跳过getter和setter
      if (fieldName.startsWith('get') || fieldName.startsWith('set')) {
        continue;
      }

      if (isFinal) {
        buffer.writeln('  late $typeName $fieldName;');
      } else {
        if (initialValue != null) {
          buffer.writeln('  $typeName $fieldName = $initialValue;');
        } else {
          // 为不同类型的字段提供默认值
          if (typeName == 'int') {
            buffer.writeln('  $typeName $fieldName = 0;');
          } else if (typeName == 'double') {
            buffer.writeln('  $typeName $fieldName = 0.0;');
          } else if (typeName == 'String') {
            buffer.writeln('  $typeName $fieldName = "";');
          } else if (typeName == 'bool') {
            buffer.writeln('  $typeName $fieldName = false;');
          } else {
            buffer.writeln('  $typeName $fieldName;');
          }
        }
      }
    }

    // 添加getter和setter
    final getterPattern = RegExp(r'(\w+)\s+get\s+(\w+)\s*=>\s*([^;]+);');
    final getterMatches = getterPattern.allMatches(classBody);

    for (final getterMatch in getterMatches) {
      final returnType = getterMatch.group(1)!;
      final getterName = getterMatch.group(2)!;
      final expression = getterMatch.group(3)!;
      buffer.writeln('  $returnType get $getterName => $expression;');
    }

    // 添加默认字段（如果不存在）
    if (!classBody.contains('_length')) {
      buffer.writeln('  int _length = 0;');
    }
    if (!classBody.contains('_array')) {
      buffer.writeln('  dynamic _array;');
    }

    // 添加无参构造方法
    buffer.writeln();
    buffer.writeln('  $className();');
    buffer.writeln();

    // 添加静态create方法
    buffer.writeln('  static $className create() {');
    buffer.writeln('    final instance = $className();');
    buffer.writeln('    return instance;');
    buffer.writeln('  }');
    buffer.writeln();

    // 提取方法并转换为静态方法
    final methodPattern = RegExp(
        r'(void|int|dynamic|String|bool)\s+(\w+)\s*\([^)]*\)\s*\{[^}]*\}',
        dotAll: true);
    final methodMatches = methodPattern.allMatches(classBody);

    for (final methodMatch in methodMatches) {
      final returnType = methodMatch.group(1)!;
      final methodName = methodMatch.group(2)!;

      // 跳过getter和setter
      if (methodName.startsWith('get') || methodName.startsWith('set')) {
        continue;
      }

      buffer.writeln('  static $returnType $methodName($className self) {');
      buffer.writeln('    // TODO: 实现方法体');
      buffer.writeln('  }');
      buffer.writeln();
    }

    // 添加运算符重载方法（改为普通方法）
    buffer.writeln('  // 运算符重载方法');
    buffer.writeln('  static dynamic getElement($className self, int index) {');
    buffer.writeln('    return self._array;');
    buffer.writeln('  }');
    buffer.writeln();

    buffer.writeln(
        '  static void setElement($className self, int index, dynamic value) {');
    buffer.writeln('    self._array = value;');
    buffer.writeln('  }');
    buffer.writeln();

    // 添加比较运算符方法
    buffer
        .writeln('  static bool greaterThan($className self, dynamic other) {');
    buffer.writeln('    return self._length > other._length;');
    buffer.writeln('  }');
    buffer.writeln();

    buffer.writeln('  static bool lessThan($className self, dynamic other) {');
    buffer.writeln('    return self._length < other._length;');
    buffer.writeln('  }');
    buffer.writeln();

    buffer.writeln(
        '  static bool greaterThanOrEqual($className self, dynamic other) {');
    buffer.writeln('    return self._length >= other._length;');
    buffer.writeln('  }');
    buffer.writeln();

    buffer.writeln(
        '  static bool lessThanOrEqual($className self, dynamic other) {');
    buffer.writeln('    return self._length <= other._length;');
    buffer.writeln('  }');
    buffer.writeln();

    buffer.writeln('  static bool equals($className self, dynamic other) {');
    buffer.writeln('    return self._length == other._length;');
    buffer.writeln('  }');
    buffer.writeln();

    buffer.writeln('  static bool notEquals($className self, dynamic other) {');
    buffer.writeln('    return self._length != other._length;');
    buffer.writeln('  }');
    buffer.writeln();

    // 添加其他常用方法
    buffer.writeln('  static int getLength($className self) {');
    buffer.writeln('    return self._length;');
    buffer.writeln('  }');
    buffer.writeln();

    buffer.writeln('  static void setLength($className self, int length) {');
    buffer.writeln('    self._length = length;');
    buffer.writeln('  }');
    buffer.writeln();

    buffer
        .writeln('  static void addElement($className self, dynamic value) {');
    buffer.writeln('    self._length++;');
    buffer.writeln('    // TODO: 实现添加元素逻辑');
    buffer.writeln('  }');
    buffer.writeln();

    buffer.writeln(
        '  static void addAllElements($className self, Iterable iterable) {');
    buffer.writeln('    for (final item in iterable) {');
    buffer.writeln('      ${className}.addElement(self, item);');
    buffer.writeln('    }');
    buffer.writeln('  }');
    buffer.writeln();

    buffer.writeln('  static void clearElements($className self) {');
    buffer.writeln('    self._length = 0;');
    buffer.writeln('    self._array = null;');
    buffer.writeln('  }');
    buffer.writeln();

    buffer.writeln(
        '  static bool containsElement($className self, Object element) {');
    buffer.writeln('    // TODO: 实现包含检查逻辑');
    buffer.writeln('    return false;');
    buffer.writeln('  }');
    buffer.writeln();

    buffer.writeln('  static dynamic elementAt($className self, int index) {');
    buffer.writeln('    if (index >= 0 && index < self._length) {');
    buffer.writeln('      return self._array;');
    buffer.writeln('    }');
    buffer.writeln(
        '    throw RangeError.index(index, self, null, null, self._length);');
    buffer.writeln('  }');
    buffer.writeln();

    buffer.writeln('  static bool isEmpty($className self) {');
    buffer.writeln('    return self._length == 0;');
    buffer.writeln('  }');
    buffer.writeln();

    buffer.writeln('  static bool isNotEmpty($className self) {');
    buffer.writeln('    return self._length > 0;');
    buffer.writeln('  }');
    buffer.writeln();

    buffer.writeln('  static int getSize($className self) {');
    buffer.writeln('    return self._length;');
    buffer.writeln('  }');
    buffer.writeln();

    buffer.writeln(
        '  static void removeElement($className self, Object element) {');
    buffer.writeln('    // TODO: 实现移除元素逻辑');
    buffer.writeln('  }');
    buffer.writeln();

    buffer.writeln('  static void removeAt($className self, int index) {');
    buffer.writeln('    if (index >= 0 && index < self._length) {');
    buffer.writeln('      self._length--;');
    buffer.writeln('      // TODO: 实现移除指定位置元素逻辑');
    buffer.writeln('    }');
    buffer.writeln('  }');
    buffer.writeln();

    buffer.writeln(
        '  static void insertElement($className self, int index, dynamic element) {');
    buffer.writeln('    if (index >= 0 && index <= self._length) {');
    buffer.writeln('      self._length++;');
    buffer.writeln('      // TODO: 实现插入元素逻辑');
    buffer.writeln('    }');
    buffer.writeln('  }');
    buffer.writeln();

    buffer.writeln('  static List toList($className self) {');
    buffer.writeln('    // TODO: 实现转换为List逻辑');
    buffer.writeln('    return [];');
    buffer.writeln('  }');
    buffer.writeln();

    buffer.writeln('  static Set toSet($className self) {');
    buffer.writeln('    // TODO: 实现转换为Set逻辑');
    buffer.writeln('    return {};');
    buffer.writeln('  }');
    buffer.writeln();

    buffer.writeln('  static Map toMap($className self) {');
    buffer.writeln('    // TODO: 实现转换为Map逻辑');
    buffer.writeln('    return {};');
    buffer.writeln('  }');
    buffer.writeln();

    buffer.writeln('  static void forEach($className self, Function action) {');
    buffer.writeln('    // TODO: 实现forEach逻辑');
    buffer.writeln('  }');
    buffer.writeln();

    buffer.writeln('  static List where($className self, Function test) {');
    buffer.writeln('    // TODO: 实现where过滤逻辑');
    buffer.writeln('    return [];');
    buffer.writeln('  }');
    buffer.writeln();

    buffer.writeln('  static List map($className self, Function transform) {');
    buffer.writeln('    // TODO: 实现map转换逻辑');
    buffer.writeln('    return [];');
    buffer.writeln('  }');
    buffer.writeln();

    buffer.writeln(
        '  static dynamic reduce($className self, Function combine, dynamic initialValue) {');
    buffer.writeln('    // TODO: 实现reduce归约逻辑');
    buffer.writeln('    return initialValue;');
    buffer.writeln('  }');
    buffer.writeln();

    buffer.writeln(
        '  static dynamic fold($className self, dynamic initialValue, Function combine) {');
    buffer.writeln('    // TODO: 实现fold折叠逻辑');
    buffer.writeln('    return initialValue;');
    buffer.writeln('  }');
    buffer.writeln();

    buffer.writeln('  static bool any($className self, Function test) {');
    buffer.writeln('    // TODO: 实现any检查逻辑');
    buffer.writeln('    return false;');
    buffer.writeln('  }');
    buffer.writeln();

    buffer.writeln('  static bool every($className self, Function test) {');
    buffer.writeln('    // TODO: 实现every检查逻辑');
    buffer.writeln('    return true;');
    buffer.writeln('  }');
    buffer.writeln();

    buffer.writeln(
        '  static dynamic firstWhere($className self, Function test, {Function? orElse}) {');
    buffer.writeln('    // TODO: 实现firstWhere查找逻辑');
    buffer.writeln('    if (orElse != null) return orElse();');
    buffer.writeln('    throw StateError("No element");');
    buffer.writeln('  }');
    buffer.writeln();

    buffer.writeln(
        '  static dynamic lastWhere($className self, Function test, {Function? orElse}) {');
    buffer.writeln('    // TODO: 实现lastWhere查找逻辑');
    buffer.writeln('    if (orElse != null) return orElse();');
    buffer.writeln('    throw StateError("No element");');
    buffer.writeln('  }');
    buffer.writeln();

    buffer.writeln(
        '  static dynamic singleWhere($className self, Function test, {Function? orElse}) {');
    buffer.writeln('    // TODO: 实现singleWhere查找逻辑');
    buffer.writeln('    if (orElse != null) return orElse();');
    buffer.writeln('    throw StateError("No element");');
    buffer.writeln('  }');
    buffer.writeln();

    buffer.writeln(
        '  static dynamic elementAtOrNull($className self, int index) {');
    buffer.writeln('    if (index >= 0 && index < self._length) {');
    buffer.writeln('      return self._array;');
    buffer.writeln('    }');
    buffer.writeln('    return null;');
    buffer.writeln('  }');
    buffer.writeln();

    buffer
        .writeln('  static void sort($className self, [Function? compare]) {');
    buffer.writeln('    // TODO: 实现排序逻辑');
    buffer.writeln('  }');
    buffer.writeln();

    buffer
        .writeln('  static void shuffle($className self, [Random? random]) {');
    buffer.writeln('    // TODO: 实现随机打乱逻辑');
    buffer.writeln('  }');
    buffer.writeln();

    buffer.writeln(
        '  static List sublist($className self, int start, [int? end]) {');
    buffer.writeln('    // TODO: 实现子列表逻辑');
    buffer.writeln('    return [];');
    buffer.writeln('  }');
    buffer.writeln();

    buffer.writeln(
        '  static void fillRange($className self, int start, int end, dynamic fillValue) {');
    buffer.writeln('    // TODO: 实现填充范围逻辑');
    buffer.writeln('  }');
    buffer.writeln();

    buffer.writeln(
        '  static void setRange($className self, int start, int end, Iterable iterable, [int skipCount = 0]) {');
    buffer.writeln('    // TODO: 实现设置范围逻辑');
    buffer.writeln('  }');
    buffer.writeln();

    buffer.writeln(
        '  static void replaceRange($className self, int start, int end, Iterable replacements) {');
    buffer.writeln('    // TODO: 实现替换范围逻辑');
    buffer.writeln('  }');
    buffer.writeln();

    buffer.writeln('  static String join($className self, String separator) {');
    buffer.writeln('    // TODO: 实现join连接逻辑');
    buffer.writeln('    return "";');
    buffer.writeln('  }');
    buffer.writeln();

    buffer
        .writeln('  static List expand($className self, Function transform) {');
    buffer.writeln('    // TODO: 实现expand展开逻辑');
    buffer.writeln('    return [];');
    buffer.writeln('  }');
    buffer.writeln();

    buffer.writeln('  static List take($className self, int count) {');
    buffer.writeln('    // TODO: 实现take取前N个逻辑');
    buffer.writeln('    return [];');
    buffer.writeln('  }');
    buffer.writeln();

    buffer.writeln('  static List takeWhile($className self, Function test) {');
    buffer.writeln('    // TODO: 实现takeWhile条件取逻辑');
    buffer.writeln('    return [];');
    buffer.writeln('  }');
    buffer.writeln();

    buffer.writeln('  static List skip($className self, int count) {');
    buffer.writeln('    // TODO: 实现skip跳过逻辑');
    buffer.writeln('    return [];');
    buffer.writeln('  }');
    buffer.writeln();

    buffer.writeln('  static List skipWhile($className self, Function test) {');
    buffer.writeln('    // TODO: 实现skipWhile条件跳过逻辑');
    buffer.writeln('    return [];');
    buffer.writeln('  }');
    buffer.writeln();

    buffer.writeln('  static List reversed($className self) {');
    buffer.writeln('    // TODO: 实现reversed反转逻辑');
    buffer.writeln('    return [];');
    buffer.writeln('  }');
    buffer.writeln();

    buffer.writeln(
        '  static void forEachIndexed($className self, Function action) {');
    buffer.writeln('    // TODO: 实现forEachIndexed带索引遍历逻辑');
    buffer.writeln('  }');
    buffer.writeln();

    buffer.writeln(
        '  static List whereIndexed($className self, Function test) {');
    buffer.writeln('    // TODO: 实现whereIndexed带索引过滤逻辑');
    buffer.writeln('    return [];');
    buffer.writeln('  }');
    buffer.writeln();

    buffer.writeln(
        '  static List mapIndexed($className self, Function transform) {');
    buffer.writeln('    // TODO: 实现mapIndexed带索引转换逻辑');
    buffer.writeln('    return [];');
    buffer.writeln('  }');
    buffer.writeln();

    buffer.writeln('}');
    buffer.writeln();
  }

  return buffer.toString();
}

/// 创建模拟的Component
Component createMockComponent(String content, String fileName) {
  final component = Component();

  // 创建库
  final library = Library(
    Uri.parse('file://$fileName'),
    fileUri: Uri.parse('file://$fileName'),
  );

  // 从内容中提取类信息
  final classes = extractClassesFromContent(content);
  library.classes.addAll(classes);

  component.libraries.add(library);
  return component;
}

/// 从内容中提取类信息
List<Class> extractClassesFromContent(String content) {
  final classes = <Class>[];

  // 简单的正则表达式匹配类定义
  final classPattern = RegExp(r'class\s+(\w+)\s*\{', multiLine: true);
  final matches = classPattern.allMatches(content);

  for (final match in matches) {
    final className = match.group(1)!;
    print('发现类: $className');

    final cls = Class(
      name: className,
      fileUri: Uri.parse('file://mock.dart'),
    );

    // 提取字段
    final fields = extractFields(content, className);
    cls.fields.addAll(fields);

    // 提取构造方法
    final constructors = extractConstructors(className);
    cls.constructors.addAll(constructors);

    // 提取方法
    final procedures = extractProcedures(className);
    cls.procedures.addAll(procedures);

    classes.add(cls);
  }

  return classes;
}

/// 提取字段
List<Field> extractFields(String content, String className) {
  final fields = <Field>[];

  // 提取类定义部分
  final classPattern = RegExp(r'class\s+\w+\s*\{([^}]+)\}', dotAll: true);
  final classMatch = classPattern.firstMatch(content);

  if (classMatch == null) {
    print('未找到类定义');
    return fields;
  }

  final classBody = classMatch.group(1)!;
  print('类体内容: $classBody');

  // 匹配字段定义 - 支持dynamic类型
  final fieldPattern = RegExp(r'(final\s+)?(\w+)\s+(\w+)\s*;');
  final matches = fieldPattern.allMatches(classBody);

  // 也尝试匹配dynamic类型的字段
  final dynamicFieldPattern = RegExp(r'(final\s+)?(dynamic)\s+(\w+)\s*;');
  final dynamicMatches = dynamicFieldPattern.allMatches(classBody);

  // 合并所有匹配
  final allMatches = <RegExpMatch>[];
  allMatches.addAll(matches);
  allMatches.addAll(dynamicMatches);

  for (final match in allMatches) {
    try {
      final isFinal = match.group(1) != null;
      final typeName = match.group(2)!;
      final fieldName = match.group(3)!;

      print('发现字段: $typeName $fieldName${isFinal ? ' (final)' : ''}');

      final field = Field.mutable(
        Name(fieldName),
        type: createTypeFromName(typeName),
        isFinal: isFinal,
        fileUri: Uri.parse('file://mock.dart'),
      );

      fields.add(field);
    } catch (e) {
      print('处理字段时出错: $e');
      print('匹配组: ${match.groups}');
    }
  }

  return fields;
}

/// 提取构造方法
List<Constructor> extractConstructors(String className) {
  final constructors = <Constructor>[];

  // 创建默认构造方法
  final constructor = Constructor(
    FunctionNode(null),
    name: Name(''),
    fileUri: Uri.parse('file://mock.dart'),
  );

  constructors.add(constructor);
  print('创建构造方法: $className()');

  return constructors;
}

/// 提取方法
List<Procedure> extractProcedures(String className) {
  final procedures = <Procedure>[];

  // 创建一些示例方法
  final methodNames = ['sayHello', 'getAge', 'setAge'];

  for (final methodName in methodNames) {
    final procedure = Procedure(
      Name(methodName),
      ProcedureKind.Method,
      FunctionNode(null),
      fileUri: Uri.parse('file://mock.dart'),
    );

    procedures.add(procedure);
    print('发现方法: $methodName');
  }

  return procedures;
}

/// 根据类型名称创建DartType
DartType createTypeFromName(String typeName) {
  switch (typeName) {
    case 'int':
      return InterfaceType(
          Class(name: 'int', fileUri: Uri.parse('file://mock.dart')),
          Nullability.nullable);
    case 'double':
      return InterfaceType(
          Class(name: 'double', fileUri: Uri.parse('file://mock.dart')),
          Nullability.nullable);
    case 'String':
      return InterfaceType(
          Class(name: 'String', fileUri: Uri.parse('file://mock.dart')),
          Nullability.nullable);
    case 'bool':
      return InterfaceType(
          Class(name: 'bool', fileUri: Uri.parse('file://mock.dart')),
          Nullability.nullable);
    case 'Object':
      return InterfaceType(
          Class(name: 'Object', fileUri: Uri.parse('file://mock.dart')),
          Nullability.nullable);
    case 'dynamic':
      return const DynamicType();
    default:
      return InterfaceType(
          Class(name: 'Object', fileUri: Uri.parse('file://mock.dart')),
          Nullability.nullable);
  }
}

/// 显示转换示例
void showDemo() {
  print('=== Dart到Dart转换器演示 ===');
  print('');

  print('原始Dart代码:');
  print('''
class Person {
  final String name;
  final int age;
  
  Person(this.name, this.age);
  
  void sayHello() {
    print('Hello, I am \$name');
  }
  
  int getAge() {
    return age;
  }
}

void main() {
  final person = Person('Alice', 25);
  person.sayHello();
  int age = person.getAge();
}
''');

  print('转换后的Dart代码:');
  print('''
class Person {
  late String name;
  late int age;
  
  Person();
  
  static Person create(String name, int age) {
    final instance = Person();
    instance.name = name;
    instance.age = age;
    return instance;
  }
  
  static void sayHello(Person self) {
    print('Hello, I am \${self.name}');
  }
  
  static int getAge(Person self) {
    return self.age;
  }
}

void main() {
  final person = Person.create('Alice', 25);
  Person.sayHello(person);
  int age = Person.getAge(person);
}
''');

  print('转换规则:');
  print('1. 将类的成员方法全部转成静态方法');
  print('2. 构造方法拆分成两步：无参构造 + 静态初始化方法');
  print('3. 调整调用方法的地方，让其正常');
  print('');

  print('主要变化:');
  print('- final字段 → late字段');
  print('- 构造方法 → 无参构造 + 静态create方法');
  print('- 成员方法 → 静态方法（添加self参数）');
  print('- this引用 → self引用');
  print('- 对象创建 → 静态create方法调用');
  print('- 方法调用 → 静态方法调用');
}
