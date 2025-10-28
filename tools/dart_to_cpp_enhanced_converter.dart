#!/usr/bin/env dart
// ============================================================================
// Enhanced Dart to C++ Converter
// 基于完整语法映射表的增强版转换器
// 支持：基础语法、OOP特性、ObjectPtr包装、更多Dart特性
// ============================================================================

import 'dart:io';

class ConversionContext {
  // 追踪已声明的类
  Set<String> declaredClasses = {};
  // 追踪需要ObjectPtr包装的类型
  Set<String> customClasses = {};
  // 当前类名（用于判断this）
  String? currentClassName;
  // 缩进级别
  int indentLevel = 0;

  bool isCustomClass(String typeName) {
    return customClasses.contains(typeName) ||
        (!_isBuiltInType(typeName) && declaredClasses.contains(typeName));
  }

  bool _isBuiltInType(String type) {
    return [
      'int',
      'double',
      'bool',
      'String',
      'num',
      'dynamic',
      'void',
      'Int',
      'Double',
      'Bool',
      'List',
      'Set',
      'Map',
      'Future'
    ].contains(type);
  }
}

class DartToCppEnhancedConverter {
  final ConversionContext context = ConversionContext();

  // ============================================================================
  // 类型映射
  // ============================================================================

  static const Map<String, String> typeMapping = {
    'int': 'Int',
    'double': 'Double',
    'bool': 'Bool',
    'String': 'String',
    'num': 'Double',
    'dynamic': 'Any',
    'void': 'void',
    'var': 'auto',
    'final': 'const auto',
    'const': 'const auto',
  };

  static const Map<String, String> collectionCreators = {
    'List': 'List',
    'Set': 'Set',
    'Map': 'Map',
  };

  // ============================================================================
  // 主转换函数
  // ============================================================================

  String convert(String dartCode) {
    StringBuffer result = StringBuffer();

    // 预处理：收集类定义
    _collectClassDefinitions(dartCode);

    // 添加头文件
    result.writeln(_generateHeaders());
    result.writeln();

    // 转换代码主体
    List<String> lines = dartCode.split('\n');

    for (int i = 0; i < lines.length; i++) {
      String line = lines[i];
      String converted = _convertLine(line, lines, i);
      if (converted.isNotEmpty) {
        result.write(converted);
        if (!converted.endsWith('\n')) {
          result.writeln();
        }
      }
    }

    return result.toString();
  }

  // ============================================================================
  // 预处理：收集类定义
  // ============================================================================

  void _collectClassDefinitions(String dartCode) {
    RegExp classPattern = RegExp(r'\bclass\s+(\w+)');
    for (Match match in classPattern.allMatches(dartCode)) {
      String className = match.group(1)!;
      context.declaredClasses.add(className);
      context.customClasses.add(className);
    }
  }

  // ============================================================================
  // 生成头文件
  // ============================================================================

  String _generateHeaders() {
    return '''
// Auto-generated C++ code from Dart
// Generated: ${DateTime.now()}

#include "pkg/dart2bytecode/base/object.h"
#include "pkg/dart2bytecode/base/object.cpp"
#include "pkg/dart2bytecode/base/object_extensions_simple.h"
#include "pkg/dart2bytecode/base/dart_async_simple.h"
#include "pkg/dart2bytecode/base/dart_oop_extensions.h"
#include "pkg/dart2bytecode/base/dart_syntax_simple.h"
#include <iostream>
#include <memory>''';
  }

  // ============================================================================
  // 行转换分发
  // ============================================================================

  String _convertLine(String line, List<String> allLines, int lineIndex) {
    String trimmed = line.trim();
    String leadingSpaces =
        line.substring(0, line.length - line.trimLeft().length);

    // 空行和注释
    if (trimmed.isEmpty) return '';
    if (trimmed.startsWith('//')) return line;
    if (trimmed.startsWith('/*') || trimmed.startsWith('*')) return line;

    // 类定义
    if (trimmed.startsWith('class ')) {
      return _convertClassDeclaration(trimmed, leadingSpaces);
    }

    // 抽象类/接口
    if (trimmed.startsWith('abstract class ')) {
      return _convertAbstractClass(trimmed, leadingSpaces);
    }

    // Mixin定义
    if (trimmed.startsWith('mixin ')) {
      return _convertMixinDeclaration(trimmed, leadingSpaces);
    }

    // 变量声明
    if (_isVariableDeclaration(trimmed)) {
      return _convertVariableDeclaration(trimmed, leadingSpaces);
    }

    // 函数定义
    if (_isFunctionDeclaration(trimmed)) {
      return _convertFunctionDeclaration(trimmed, leadingSpaces);
    }

    // 控制流
    if (trimmed.startsWith('if ')) {
      return _convertIfStatement(trimmed, leadingSpaces);
    }
    if (trimmed.startsWith('for ')) {
      return _convertForStatement(trimmed, leadingSpaces);
    }
    if (trimmed.startsWith('while ')) {
      return _convertWhileStatement(trimmed, leadingSpaces);
    }

    // return语句
    if (trimmed.startsWith('return ')) {
      return _convertReturnStatement(trimmed, leadingSpaces);
    }

    // print语句
    if (trimmed.contains('print(')) {
      return _convertPrintStatement(trimmed, leadingSpaces);
    }

    // 普通表达式
    return _convertExpression(trimmed, leadingSpaces);
  }

  // ============================================================================
  // 类定义转换
  // ============================================================================

  String _convertClassDeclaration(String line, String indent) {
    // class MyClass extends Parent with Mixin implements Interface {
    RegExp pattern = RegExp(
        r'class\s+(\w+)(?:\s+extends\s+(\w+))?(?:\s+with\s+([^{]+))?(?:\s+implements\s+([^{]+))?\s*\{');

    Match? match = pattern.firstMatch(line);
    if (match != null) {
      String className = match.group(1)!;
      String? parent = match.group(2);
      String? mixins = match.group(3);
      String? interfaces = match.group(4);

      context.currentClassName = className;

      List<String> inheritance = [];

      // 父类
      if (parent != null && parent != 'Object') {
        inheritance.add('public $parent');
      } else {
        inheritance.add('public Object');
      }

      // Mixins
      if (mixins != null) {
        for (String mixin in mixins.split(',')) {
          inheritance.add('public virtual ${mixin.trim()}');
        }
      }

      // Interfaces
      if (interfaces != null) {
        for (String interface in interfaces.split(',')) {
          inheritance.add('public virtual ${interface.trim()}');
        }
      }

      return '${indent}class $className : ${inheritance.join(', ')} {';
    }

    return '$indent$line';
  }

  // ============================================================================
  // 抽象类转换
  // ============================================================================

  String _convertAbstractClass(String line, String indent) {
    // abstract class Shape {
    RegExp pattern = RegExp(r'abstract\s+class\s+(\w+)\s*\{');
    Match? match = pattern.firstMatch(line);

    if (match != null) {
      String className = match.group(1)!;
      context.currentClassName = className;
      return '${indent}DART_INTERFACE($className)';
    }

    return '$indent$line';
  }

  // ============================================================================
  // Mixin转换
  // ============================================================================

  String _convertMixinDeclaration(String line, String indent) {
    // mixin Flyable {
    RegExp pattern = RegExp(r'mixin\s+(\w+)\s*\{');
    Match? match = pattern.firstMatch(line);

    if (match != null) {
      String mixinName = match.group(1)!;
      return '${indent}DART_MIXIN($mixinName)';
    }

    return '$indent$line';
  }

  // ============================================================================
  // 变量声明转换
  // ============================================================================

  bool _isVariableDeclaration(String line) {
    return line.startsWith('var ') ||
        line.startsWith('final ') ||
        line.startsWith('const ') ||
        line.startsWith('int ') ||
        line.startsWith('double ') ||
        line.startsWith('bool ') ||
        line.startsWith('String ') ||
        line.startsWith('List<') ||
        line.startsWith('Set<') ||
        line.startsWith('Map<');
  }

  String _convertVariableDeclaration(String line, String indent) {
    // var x = 5;
    RegExp varPattern = RegExp(r'(var|final|const)\s+(\w+)\s*=\s*(.+?);');
    Match? varMatch = varPattern.firstMatch(line);

    if (varMatch != null) {
      String keyword = varMatch.group(1)!;
      String varName = varMatch.group(2)!;
      String value = varMatch.group(3)!;

      String convertedValue = _convertValue(value);
      String declKeyword = keyword == 'var' ? 'auto' : 'const auto';

      return '$indent$declKeyword $varName = $convertedValue;';
    }

    // int x = 5;
    RegExp typedPattern =
        RegExp(r'(int|double|bool|String)\s+(\w+)\s*=\s*(.+?);');
    Match? typedMatch = typedPattern.firstMatch(line);

    if (typedMatch != null) {
      String dartType = typedMatch.group(1)!;
      String varName = typedMatch.group(2)!;
      String value = typedMatch.group(3)!;

      String cppType = typeMapping[dartType] ?? dartType;
      String convertedValue = _convertValue(value);

      return '$indent$cppType $varName = $convertedValue;';
    }

    // List<int> list = [];
    if (line.contains('List<') ||
        line.contains('Set<') ||
        line.contains('Map<')) {
      return _convertCollectionDeclaration(line, indent);
    }

    // 自定义类型声明：Person person = Person(...);
    RegExp customTypePattern = RegExp(r'(\w+)\s+(\w+)\s*=\s*(.+?);');
    Match? customMatch = customTypePattern.firstMatch(line);

    if (customMatch != null) {
      String typeName = customMatch.group(1)!;
      String varName = customMatch.group(2)!;
      String value = customMatch.group(3)!;

      if (context.isCustomClass(typeName)) {
        // 使用ObjectPtr包装
        String convertedValue = _convertValue(value);
        return '${indent}ObjectPtr<$typeName> $varName = $convertedValue;';
      }
    }

    return '$indent$line';
  }

  // ============================================================================
  // 集合声明转换
  // ============================================================================

  String _convertCollectionDeclaration(String line, String indent) {
    // List<int> numbers = [1, 2, 3];
    RegExp listPattern = RegExp(r'List<(\w+)>\s+(\w+)\s*=\s*\[(.*?)\];');
    Match? listMatch = listPattern.firstMatch(line);

    if (listMatch != null) {
      String elementType = listMatch.group(1)!;
      String varName = listMatch.group(2)!;
      String elements = listMatch.group(3)!;

      String cppType = typeMapping[elementType] ?? elementType;
      StringBuffer result = StringBuffer();

      // 判断元素类型是否是自定义类
      bool isCustom = context.isCustomClass(elementType);
      String fullType = isCustom ? 'ObjectPtr<$cppType>' : cppType;

      result.write(
          '${indent}ObjectPtr<List<$fullType>> $varName = List<$fullType>::create();');

      // 添加初始元素
      if (elements.isNotEmpty) {
        List<String> items = elements
            .split(',')
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty)
            .toList();
        for (String item in items) {
          String convertedItem = _convertValue(item);
          // 如果是自定义类，需要用ObjectPtr包装
          if (isCustom && !convertedItem.contains('ObjectPtr')) {
            convertedItem = 'ObjectPtr<$cppType>($convertedItem)';
          }
          result.write('\n$indent$varName->add($convertedItem);');
        }
      }

      return result.toString();
    }

    // Set<String> names = {};
    RegExp setPattern = RegExp(r'Set<(\w+)>\s+(\w+)\s*=\s*\{(.*?)\};');
    Match? setMatch = setPattern.firstMatch(line);

    if (setMatch != null) {
      String elementType = setMatch.group(1)!;
      String varName = setMatch.group(2)!;
      String elements = setMatch.group(3)!;

      String cppType = typeMapping[elementType] ?? elementType;
      StringBuffer result = StringBuffer();

      bool isCustom = context.isCustomClass(elementType);
      String fullType = isCustom ? 'ObjectPtr<$cppType>' : cppType;

      result.write(
          '${indent}ObjectPtr<Set<$fullType>> $varName = Set<$fullType>::create();');

      if (elements.isNotEmpty) {
        List<String> items = elements
            .split(',')
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty)
            .toList();
        for (String item in items) {
          String convertedItem = _convertValue(item);
          if (isCustom && !convertedItem.contains('ObjectPtr')) {
            convertedItem = 'ObjectPtr<$cppType>($convertedItem)';
          }
          result.write('\n$indent$varName->add($convertedItem);');
        }
      }

      return result.toString();
    }

    // Map<K, V> map = {};
    RegExp mapPattern = RegExp(r'Map<(\w+),\s*(\w+)>\s+(\w+)\s*=\s*\{.*?\};');
    Match? mapMatch = mapPattern.firstMatch(line);

    if (mapMatch != null) {
      String keyType = mapMatch.group(1)!;
      String valueType = mapMatch.group(2)!;
      String varName = mapMatch.group(3)!;

      String cppKeyType = typeMapping[keyType] ?? keyType;
      String cppValueType = typeMapping[valueType] ?? valueType;

      return '${indent}ObjectPtr<Map<$cppKeyType, $cppValueType>> $varName = Map<$cppKeyType, $cppValueType>::create();';
    }

    return '$indent$line';
  }

  // ============================================================================
  // 函数定义转换
  // ============================================================================

  bool _isFunctionDeclaration(String line) {
    // 检测函数定义模式
    return RegExp(r'^\w+\s+\w+\s*\([^)]*\)\s*(\{|=>)').hasMatch(line) ||
        line.startsWith('void ') ||
        line.startsWith('int ') && line.contains('(') ||
        line.startsWith('String ') && line.contains('(');
  }

  String _convertFunctionDeclaration(String line, String indent) {
    // int add(int a, int b) {
    RegExp pattern = RegExp(r'(\w+)\s+(\w+)\s*\(([^)]*)\)\s*\{');
    Match? match = pattern.firstMatch(line);

    if (match != null) {
      String returnType = match.group(1)!;
      String funcName = match.group(2)!;
      String params = match.group(3)!;

      String cppReturnType = typeMapping[returnType] ?? returnType;
      String convertedParams = _convertParameters(params);

      return '$indent$cppReturnType $funcName($convertedParams) {';
    }

    // 箭头函数: int add(int a, int b) => a + b;
    RegExp arrowPattern = RegExp(r'(\w+)\s+(\w+)\s*\(([^)]*)\)\s*=>\s*(.+?);');
    Match? arrowMatch = arrowPattern.firstMatch(line);

    if (arrowMatch != null) {
      String returnType = arrowMatch.group(1)!;
      String funcName = arrowMatch.group(2)!;
      String params = arrowMatch.group(3)!;
      String body = arrowMatch.group(4)!;

      String cppReturnType = typeMapping[returnType] ?? returnType;
      String convertedParams = _convertParameters(params);
      String convertedBody = _convertValue(body);

      return '$indent$cppReturnType $funcName($convertedParams) {\n$indent  return $convertedBody;\n$indent}';
    }

    return '$indent$line';
  }

  String _convertParameters(String params) {
    if (params.trim().isEmpty) return '';

    List<String> paramList = params.split(',');
    List<String> converted = [];

    for (String param in paramList) {
      param = param.trim();
      if (param.isEmpty) continue;

      // int x, double y
      RegExp paramPattern = RegExp(r'(\w+)\s+(\w+)');
      Match? match = paramPattern.firstMatch(param);

      if (match != null) {
        String dartType = match.group(1)!;
        String paramName = match.group(2)!;
        String cppType = typeMapping[dartType] ?? dartType;

        // 如果是自定义类，使用ObjectPtr
        if (context.isCustomClass(dartType)) {
          converted.add('const ObjectPtr<$cppType>& $paramName');
        } else {
          converted.add('const $cppType& $paramName');
        }
      } else {
        converted.add(param);
      }
    }

    return converted.join(', ');
  }

  // ============================================================================
  // 控制流转换
  // ============================================================================

  String _convertIfStatement(String line, String indent) {
    // if (condition) {
    // Bool支持隐式转换，保持不变
    return '$indent$line';
  }

  String _convertForStatement(String line, String indent) {
    // for (var item in list)
    RegExp forInPattern = RegExp(r'for\s*\(\s*var\s+(\w+)\s+in\s+(\w+)\s*\)');
    Match? forInMatch = forInPattern.firstMatch(line);

    if (forInMatch != null) {
      String itemName = forInMatch.group(1)!;
      String collection = forInMatch.group(2)!;
      return '${indent}dart_for_each(auto, $itemName, $collection)';
    }

    // for (int i = 0; i < 10; i++)
    RegExp standardPattern = RegExp(
        r'for\s*\(\s*int\s+(\w+)\s*=\s*(\d+);\s*(\w+)\s*<\s*([^;]+);\s*(\w+)\+\+\s*\)');
    Match? standardMatch = standardPattern.firstMatch(line);

    if (standardMatch != null) {
      String varName = standardMatch.group(1)!;
      String initValue = standardMatch.group(2)!;
      String condVar = standardMatch.group(3)!;
      String limit = standardMatch.group(4)!;

      String convertedLimit = _convertValue(limit);
      return '${indent}for (Int $varName($initValue); $condVar < $convertedLimit; ++$varName)';
    }

    return '$indent$line';
  }

  String _convertWhileStatement(String line, String indent) {
    return '$indent$line';
  }

  // ============================================================================
  // 语句转换
  // ============================================================================

  String _convertReturnStatement(String line, String indent) {
    // return value;
    RegExp pattern = RegExp(r'return\s+(.+?);');
    Match? match = pattern.firstMatch(line);

    if (match != null) {
      String value = match.group(1)!;
      String convertedValue = _convertValue(value);
      return '${indent}return $convertedValue;';
    }

    return '$indent$line';
  }

  String _convertPrintStatement(String line, String indent) {
    // print(x) => dart_print(x)
    String converted = line.replaceAllMapped(RegExp(r'print\(([^)]+)\)'),
        (match) => 'dart_print(${match.group(1)})');
    return '$indent$converted';
  }

  // ============================================================================
  // 表达式转换
  // ============================================================================

  String _convertExpression(String line, String indent) {
    String converted = line;

    // 整除运算符: ~/ => .integerDivision()
    converted = converted.replaceAllMapped(RegExp(r'(\w+)\s*~/\s*(\w+)'),
        (match) => '${match.group(1)}.integerDivision(${match.group(2)})');

    // 无符号右移: >>> => dart_unsigned_shift_right()
    converted = converted.replaceAllMapped(
        RegExp(r'(\w+)\s*>>>\s*(\w+)'),
        (match) =>
            'dart_unsigned_shift_right(${match.group(1)}, ${match.group(2)})');

    // 空值合并: ?? => dart_null_coalesce()
    converted = converted.replaceAllMapped(RegExp(r'(\w+)\s*\?\?\s*(.+)'),
        (match) => 'dart_null_coalesce(${match.group(1)}, ${match.group(2)})');

    // 集合方法调用：.length => ->size()
    converted = converted.replaceAll('.length', '->size()');
    converted = converted.replaceAll('.isEmpty', '->isEmpty()');
    converted = converted.replaceAll('.isNotEmpty', '->isNotEmpty()');

    // 集合方法：需要加->
    converted =
        converted.replaceAllMapped(RegExp(r'\.add\('), (match) => '->add(');
    converted =
        converted.replaceAllMapped(RegExp(r'\.get\('), (match) => '->get(');
    converted = converted.replaceAllMapped(
        RegExp(r'\.contains\('), (match) => '->contains(');
    converted =
        converted.replaceAllMapped(RegExp(r'\.put\('), (match) => '->put(');

    // 字符串方法保持.调用（值类型）
    // .toString(), .toLowerCase(), .toUpperCase() 等保持不变

    return '$indent$converted';
  }

  // ============================================================================
  // 值转换
  // ============================================================================

  String _convertValue(String value) {
    value = value.trim();

    // null
    if (value == 'null') {
      return 'ObjectPtr<Any>()';
    }

    // 整数字面量
    if (RegExp(r'^\d+$').hasMatch(value)) {
      return 'Int($value)';
    }

    // 浮点数字面量
    if (RegExp(r'^\d+\.\d+$').hasMatch(value)) {
      return 'Double($value)';
    }

    // 布尔字面量
    if (value == 'true' || value == 'false') {
      return 'Bool($value)';
    }

    // 字符串字面量
    if ((value.startsWith('"') && value.endsWith('"')) ||
        (value.startsWith("'") && value.endsWith("'"))) {
      String inner = value.substring(1, value.length - 1);
      return 'String("$inner")';
    }

    // 列表字面量 []
    if (value == '[]') {
      return '/* empty list - type unknown */';
    }

    // new关键字：new Person() => ObjectPtr<Person>(new Person())
    if (value.startsWith('new ')) {
      String className = value.substring(4).split('(')[0].trim();
      if (context.isCustomClass(className)) {
        return 'ObjectPtr<$className>($value)';
      }
      return value;
    }

    // 构造函数调用：Person("Alice", 25) => ObjectPtr<Person>(new Person(...))
    RegExp constructorPattern = RegExp(r'^([A-Z]\w+)\s*\(([^)]*)\)$');
    Match? constructorMatch = constructorPattern.firstMatch(value);

    if (constructorMatch != null) {
      String className = constructorMatch.group(1)!;
      String args = constructorMatch.group(2)!;

      // 转换参数
      List<String> convertedArgs = [];
      if (args.isNotEmpty) {
        for (String arg in args.split(',')) {
          convertedArgs.add(_convertValue(arg.trim()));
        }
      }

      String convertedArgStr = convertedArgs.join(', ');

      if (context.isCustomClass(className)) {
        return 'ObjectPtr<$className>(new $className($convertedArgStr))';
      } else {
        return '$className($convertedArgStr)';
      }
    }

    // 字符串插值：简化处理
    if (value.contains('\${')) {
      return _convertStringInterpolation(value);
    }

    // 默认保持不变
    return value;
  }

  // ============================================================================
  // 字符串插值转换
  // ============================================================================

  String _convertStringInterpolation(String value) {
    // "Hello ${name}" => String("Hello ") + name.toString()

    // 移除外层引号
    String inner = value;
    if (value.startsWith('"') && value.endsWith('"')) {
      inner = value.substring(1, value.length - 1);
    }

    StringBuffer result = StringBuffer();
    int lastEnd = 0;

    RegExp interpolation = RegExp(r'\$\{([^}]+)\}|\$(\w+)');
    for (Match match in interpolation.allMatches(inner)) {
      // 添加前面的字符串部分
      if (match.start > lastEnd) {
        String prefix = inner.substring(lastEnd, match.start);
        if (result.isNotEmpty) {
          result.write(' + ');
        }
        result.write('String("$prefix")');
      }

      // 添加变量部分
      String varExpr = match.group(1) ?? match.group(2)!;
      if (result.isNotEmpty) {
        result.write(' + ');
      }

      // 如果是复杂表达式，需要toString
      if (varExpr.contains('+') ||
          varExpr.contains('-') ||
          varExpr.contains('*')) {
        result.write('($varExpr).toString()');
      } else {
        result.write('$varExpr.toString()');
      }

      lastEnd = match.end;
    }

    // 添加剩余部分
    if (lastEnd < inner.length) {
      String suffix = inner.substring(lastEnd);
      if (result.isNotEmpty) {
        result.write(' + ');
      }
      result.write('String("$suffix")');
    }

    return result.toString();
  }

  // ============================================================================
  // 工具方法
  // ============================================================================

  String _indent() => '  ' * context.indentLevel;
}

// ============================================================================
// 命令行主入口
// ============================================================================

void main(List<String> arguments) {
  if (arguments.isEmpty) {
    _printUsage();
    exit(1);
  }

  String inputFile = arguments[0];
  String outputFile = arguments.length > 1
      ? arguments[1]
      : inputFile.replaceAll('.dart', '.cpp');

  // 读取输入文件
  File input = File(inputFile);
  if (!input.existsSync()) {
    print('❌ Error: Input file not found: $inputFile');
    exit(1);
  }

  String dartCode = input.readAsStringSync();

  // 转换
  print('🔄 Converting Dart to C++...');
  print('   Input:  $inputFile');
  print('   Output: $outputFile');
  print('');

  DartToCppEnhancedConverter converter = DartToCppEnhancedConverter();
  String cppCode = converter.convert(dartCode);

  // 写入输出文件
  File output = File(outputFile);
  output.writeAsStringSync(cppCode);

  // 统计信息
  int dartLines = dartCode.split('\n').length;
  int cppLines = cppCode.split('\n').length;
  int classCount = converter.context.declaredClasses.length;

  print('✅ Conversion complete!');
  print('');
  print('Statistics:');
  print('  Dart lines:    $dartLines');
  print('  C++ lines:     $cppLines');
  print('  Ratio:         ${(cppLines / dartLines).toStringAsFixed(2)}x');
  print('  Classes found: $classCount');
  print('  Custom types:  ${converter.context.customClasses.length}');
  print('');
  print('Features supported:');
  print('  ✓ Basic types (int, double, bool, String)');
  print('  ✓ Collections (List, Set, Map)');
  print('  ✓ Control flow (if, for, while, for-in)');
  print('  ✓ Operators (arithmetic, comparison, logical, bitwise)');
  print('  ✓ Classes and inheritance');
  print('  ✓ Custom types with ObjectPtr wrapping');
  print('  ✓ String interpolation');
  print('  ✓ Type conversions');
  print('');
  print('📄 Generated file: $outputFile');
}

void _printUsage() {
  print('Dart to C++ Enhanced Converter');
  print('');
  print('Usage:');
  print('  dart dart_to_cpp_enhanced_converter.dart <input.dart> [output.cpp]');
  print('');
  print('Examples:');
  print('  dart dart_to_cpp_enhanced_converter.dart example.dart');
  print('  dart dart_to_cpp_enhanced_converter.dart example.dart output.cpp');
  print('');
  print('Features:');
  print('  • Automatic ObjectPtr wrapping for custom classes');
  print('  • Support for classes, inheritance, interfaces, mixins');
  print('  • String interpolation conversion');
  print('  • Collection initialization');
  print('  • Control flow statements');
  print('  • Type conversions');
}
