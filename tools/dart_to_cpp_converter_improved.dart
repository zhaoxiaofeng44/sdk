// Improved Dart to C++ Converter
// 基于语法映射表实现完整的转换逻辑

import 'dart:io';

class DartToCppConverter {
  // 转换配置
  bool useSimplifiedHeaders = true;
  bool generateComments = true;
  int indentLevel = 0;

  // 类型映射表
  static const Map<String, String> typeMapping = {
    'int': 'Int',
    'double': 'Double',
    'bool': 'Bool',
    'String': 'String',
    'num': 'Double', // 默认映射到Double
    'dynamic': 'Any',
    'void': 'void',
    'var': 'auto',
  };

  // 内置类型集合映射
  static const Map<String, String> collectionMapping = {
    'List': 'List',
    'Set': 'Set',
    'Map': 'Map',
  };

  String indent() => '  ' * indentLevel;

  /// 转换Dart代码到C++
  String convert(String dartCode) {
    StringBuffer result = StringBuffer();

    // 添加头文件
    result.writeln(generateHeaders());
    result.writeln();

    // 转换代码主体
    List<String> lines = dartCode.split('\n');
    for (String line in lines) {
      String converted = convertLine(line);
      if (converted.isNotEmpty) {
        result.writeln(converted);
      }
    }

    return result.toString();
  }

  /// 生成头文件引用
  String generateHeaders() {
    if (useSimplifiedHeaders) {
      return '''
#include "pkg/dart2bytecode/base/object.h"
#include "pkg/dart2bytecode/base/object_extensions_simple.h"
#include "pkg/dart2bytecode/base/dart_async_simple.h"
#include "pkg/dart2bytecode/base/dart_syntax_simple.h"
#include <iostream>''';
    } else {
      return '''
#include "pkg/dart2bytecode/base/object.h"
#include "pkg/dart2bytecode/base/object_extensions.h"
#include "pkg/dart2bytecode/base/dart_async.h"
#include "pkg/dart2bytecode/base/dart_syntax_sugar.h"
#include <iostream>''';
    }
  }

  /// 转换单行代码
  String convertLine(String line) {
    String trimmed = line.trim();

    // 空行保留
    if (trimmed.isEmpty) return '';

    // 注释保留
    if (trimmed.startsWith('//')) {
      return '${indent()}$trimmed';
    }

    // 转换各种语句
    if (trimmed.startsWith('var ')) {
      return convertVarDeclaration(trimmed);
    } else if (trimmed.startsWith('final ')) {
      return convertFinalDeclaration(trimmed);
    } else if (trimmed.startsWith('int ') ||
        trimmed.startsWith('double ') ||
        trimmed.startsWith('bool ') ||
        trimmed.startsWith('String ')) {
      return convertTypedDeclaration(trimmed);
    } else if (trimmed.startsWith('List<')) {
      return convertListDeclaration(trimmed);
    } else if (trimmed.startsWith('Set<')) {
      return convertSetDeclaration(trimmed);
    } else if (trimmed.startsWith('Map<')) {
      return convertMapDeclaration(trimmed);
    } else if (trimmed.startsWith('if ')) {
      return convertIfStatement(trimmed);
    } else if (trimmed.startsWith('for ')) {
      return convertForLoop(trimmed);
    } else if (trimmed.startsWith('while ')) {
      return convertWhileLoop(trimmed);
    } else if (trimmed.startsWith('print(')) {
      return convertPrintStatement(trimmed);
    } else if (trimmed.startsWith('return ')) {
      return convertReturnStatement(trimmed);
    } else if (trimmed.contains('~/')) {
      return convertIntegerDivision(trimmed);
    } else if (trimmed.contains('>>>')) {
      return convertUnsignedShift(trimmed);
    } else {
      // 通用表达式转换
      return convertExpression(trimmed);
    }
  }

  /// 转换var声明
  String convertVarDeclaration(String line) {
    // var x = 5; => auto x = Int(5);
    RegExp pattern = RegExp(r'var\s+(\w+)\s*=\s*(.+?);');
    Match? match = pattern.firstMatch(line);

    if (match != null) {
      String varName = match.group(1)!;
      String value = match.group(2)!;
      String convertedValue = convertValue(value);
      return '${indent()}auto $varName = $convertedValue;';
    }

    return '${indent()}$line';
  }

  /// 转换final声明
  String convertFinalDeclaration(String line) {
    // final x = 5; => const auto x = Int(5);
    RegExp pattern = RegExp(r'final\s+(\w+)\s*=\s*(.+?);');
    Match? match = pattern.firstMatch(line);

    if (match != null) {
      String varName = match.group(1)!;
      String value = match.group(2)!;
      String convertedValue = convertValue(value);
      return '${indent()}const auto $varName = $convertedValue;';
    }

    return '${indent()}$line';
  }

  /// 转换类型化声明
  String convertTypedDeclaration(String line) {
    // int x = 5; => Int x = Int(5);
    RegExp pattern = RegExp(r'(\w+)\s+(\w+)\s*=\s*(.+?);');
    Match? match = pattern.firstMatch(line);

    if (match != null) {
      String dartType = match.group(1)!;
      String varName = match.group(2)!;
      String value = match.group(3)!;

      String cppType = typeMapping[dartType] ?? dartType;
      String convertedValue = convertValue(value);

      return '${indent()}$cppType $varName = $convertedValue;';
    }

    return '${indent()}$line';
  }

  /// 转换List声明
  String convertListDeclaration(String line) {
    // List<int> list = []; => ObjectPtr<List<Int>> list = List<Int>::create();
    RegExp pattern = RegExp(r'List<(\w+)>\s+(\w+)\s*=\s*\[(.*?)\];');
    Match? match = pattern.firstMatch(line);

    if (match != null) {
      String elementType = match.group(1)!;
      String varName = match.group(2)!;
      String elements = match.group(3)!;

      String cppType = typeMapping[elementType] ?? elementType;
      StringBuffer result = StringBuffer();

      result.write(
          '${indent()}ObjectPtr<List<$cppType>> $varName = List<$cppType>::create();');

      // 如果有初始元素
      if (elements.isNotEmpty) {
        List<String> items = elements.split(',').map((e) => e.trim()).toList();
        for (String item in items) {
          if (item.isNotEmpty) {
            String convertedItem = convertValue(item);
            result.write('\n${indent()}$varName->add($convertedItem);');
          }
        }
      }

      return result.toString();
    }

    return '${indent()}$line';
  }

  /// 转换Set声明
  String convertSetDeclaration(String line) {
    // Set<int> set = {}; => ObjectPtr<Set<Int>> set = Set<Int>::create();
    RegExp pattern = RegExp(r'Set<(\w+)>\s+(\w+)\s*=\s*\{(.*?)\};');
    Match? match = pattern.firstMatch(line);

    if (match != null) {
      String elementType = match.group(1)!;
      String varName = match.group(2)!;
      String elements = match.group(3)!;

      String cppType = typeMapping[elementType] ?? elementType;
      StringBuffer result = StringBuffer();

      result.write(
          '${indent()}ObjectPtr<Set<$cppType>> $varName = Set<$cppType>::create();');

      // 如果有初始元素
      if (elements.isNotEmpty) {
        List<String> items = elements.split(',').map((e) => e.trim()).toList();
        for (String item in items) {
          if (item.isNotEmpty) {
            String convertedItem = convertValue(item);
            result.write('\n${indent()}$varName->add($convertedItem);');
          }
        }
      }

      return result.toString();
    }

    return '${indent()}$line';
  }

  /// 转换Map声明
  String convertMapDeclaration(String line) {
    // Map<String, int> map = {}; => ObjectPtr<Map<String, Int>> map = Map<String, Int>::create();
    RegExp pattern = RegExp(r'Map<(\w+),\s*(\w+)>\s+(\w+)\s*=\s*\{.*?\};');
    Match? match = pattern.firstMatch(line);

    if (match != null) {
      String keyType = match.group(1)!;
      String valueType = match.group(2)!;
      String varName = match.group(3)!;

      String cppKeyType = typeMapping[keyType] ?? keyType;
      String cppValueType = typeMapping[valueType] ?? valueType;

      return '${indent()}ObjectPtr<Map<$cppKeyType, $cppValueType>> $varName = Map<$cppKeyType, $cppValueType>::create();';
    }

    return '${indent()}$line';
  }

  /// 转换if语句
  String convertIfStatement(String line) {
    // if (condition) { => if (condition) {
    // Bool类型支持隐式转换，无需修改
    return '${indent()}$line';
  }

  /// 转换for循环
  String convertForLoop(String line) {
    // for (int i = 0; i < 10; i++) => for (Int i(0); i < Int(10); ++i)

    // 检查是否是for-in循环
    RegExp forInPattern =
        RegExp(r'for\s*\(\s*var\s+(\w+)\s+in\s+(.+?)\s*\)\s*\{');
    Match? forInMatch = forInPattern.firstMatch(line);

    if (forInMatch != null) {
      String itemName = forInMatch.group(1)!;
      String collection = forInMatch.group(2)!;
      return '${indent()}dart_for_each(auto, $itemName, $collection)';
    }

    // 标准for循环
    RegExp pattern = RegExp(
        r'for\s*\(\s*int\s+(\w+)\s*=\s*(\d+);\s*(\w+)\s*<\s*(.+?);\s*(\w+)\+\+\s*\)');
    Match? match = pattern.firstMatch(line);

    if (match != null) {
      String varName = match.group(1)!;
      String initValue = match.group(2)!;
      String condition = match.group(4)!;

      return '${indent()}for (Int $varName($initValue); $varName < Int($condition); ++$varName) {';
    }

    return '${indent()}$line';
  }

  /// 转换while循环
  String convertWhileLoop(String line) {
    // while (condition) { => while (condition) {
    // Bool类型支持隐式转换，无需修改
    return '${indent()}$line';
  }

  /// 转换print语句
  String convertPrintStatement(String line) {
    // print(x); => dart_print(x);
    RegExp pattern = RegExp(r'print\((.*?)\);');
    Match? match = pattern.firstMatch(line);

    if (match != null) {
      String arg = match.group(1)!;
      return '${indent()}dart_print($arg);';
    }

    return '${indent()}$line';
  }

  /// 转换return语句
  String convertReturnStatement(String line) {
    // return value; => return convertedValue;
    RegExp pattern = RegExp(r'return\s+(.+?);');
    Match? match = pattern.firstMatch(line);

    if (match != null) {
      String value = match.group(1)!;
      String convertedValue = convertValue(value);
      return '${indent()}return $convertedValue;';
    }

    return '${indent()}$line';
  }

  /// 转换整除运算
  String convertIntegerDivision(String line) {
    // a ~/ b => a.integerDivision(b)
    String converted = line.replaceAllMapped(RegExp(r'(\w+)\s*~/\s*(\w+)'),
        (match) => '${match.group(1)}.integerDivision(${match.group(2)})');
    return '${indent()}$converted';
  }

  /// 转换无符号右移
  String convertUnsignedShift(String line) {
    // a >>> b => dart_unsigned_shift_right(a, b)
    String converted = line.replaceAllMapped(
        RegExp(r'(\w+)\s*>>>\s*(\w+)'),
        (match) =>
            'dart_unsigned_shift_right(${match.group(1)}, ${match.group(2)})');
    return '${indent()}$converted';
  }

  /// 转换通用表达式
  String convertExpression(String line) {
    String converted = line;

    // 转换集合方法调用
    converted = converted.replaceAll('.length', '->size()');
    converted = converted.replaceAll('.isEmpty', '->isEmpty()');
    converted = converted.replaceAll('.add(', '->add(');
    converted = converted.replaceAll('.get(', '->get(Int(');
    converted = converted.replaceAll('.contains(', '->contains(');

    // 转换字符串方法
    converted = converted.replaceAll('.toLowerCase()', '.toLowerCase()');
    converted = converted.replaceAll('.toUpperCase()', '.toUpperCase()');
    converted = converted.replaceAll('.trim()', '.trim()');

    return '${indent()}$converted';
  }

  /// 转换值
  String convertValue(String value) {
    value = value.trim();

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
    if (value.startsWith('"') && value.endsWith('"')) {
      return 'String($value)';
    }
    if (value.startsWith("'") && value.endsWith("'")) {
      // 转换单引号为双引号
      String inner = value.substring(1, value.length - 1);
      return 'String("$inner")';
    }

    // 列表字面量 [1, 2, 3] - 需要特殊处理
    if (value.startsWith('[') && value.endsWith(']')) {
      return '/* List literal needs manual conversion */';
    }

    // 其他情况保持不变
    return value;
  }
}

/// 命令行工具主入口
void main(List<String> arguments) {
  if (arguments.isEmpty) {
    print(
        'Usage: dart dart_to_cpp_converter_improved.dart <input.dart> [output.cpp]');
    print('');
    print('Example:');
    print(
        '  dart dart_to_cpp_converter_improved.dart example.dart example.cpp');
    exit(1);
  }

  String inputFile = arguments[0];
  String outputFile = arguments.length > 1
      ? arguments[1]
      : inputFile.replaceAll('.dart', '.cpp');

  // 读取输入文件
  File input = File(inputFile);
  if (!input.existsSync()) {
    print('Error: Input file not found: $inputFile');
    exit(1);
  }

  String dartCode = input.readAsStringSync();

  // 转换
  DartToCppConverter converter = DartToCppConverter();
  String cppCode = converter.convert(dartCode);

  // 写入输出文件
  File output = File(outputFile);
  output.writeAsStringSync(cppCode);

  print('✓ Conversion complete!');
  print('  Input:  $inputFile');
  print('  Output: $outputFile');
  print(
      '  Lines:  ${dartCode.split('\n').length} -> ${cppCode.split('\n').length}');
}
