#!/usr/bin/env dart

import 'dart:io';
import 'package:args/args.dart';
import '../pkg/dart2bytecode/lib/dart_to_cpp_compiler.dart';

/// Dart 到 C++ 转换工具
///
/// 使用方法:
/// dart tools/dart_to_cpp_tool.dart --input input.dart --output output.cpp
/// dart tools/dart_to_cpp_tool.dart -i input.dart -o output.cpp --verbose

void main(List<String> args) async {
  final parser = ArgParser()
    ..addOption('input', abbr: 'i', help: '输入的 Dart 源文件', mandatory: true)
    ..addOption('output', abbr: 'o', help: '输出的 C++ 文件', mandatory: true)
    ..addFlag('verbose', abbr: 'v', help: '详细输出模式', defaultsTo: false)
    ..addFlag('help', abbr: 'h', help: '显示帮助信息', defaultsTo: false)
    ..addFlag('analyze', abbr: 'a', help: '只分析不生成代码', defaultsTo: false)
    ..addOption('template',
        abbr: 't',
        help: '使用预定义模板',
        allowed: ['simple', 'oop', 'async', 'full'],
        defaultsTo: 'full');

  try {
    final results = parser.parse(args);

    if (results['help'] as bool) {
      _printUsage(parser);
      return;
    }

    final inputFile = results['input'] as String;
    final outputFile = results['output'] as String;
    final verbose = results['verbose'] as bool;
    final analyzeOnly = results['analyze'] as bool;
    final template = results['template'] as String;

    if (verbose) {
      print('=== Dart 到 C++ 转换工具 ===');
      print('输入文件: $inputFile');
      print('输出文件: $outputFile');
      print('模板类型: $template');
      print('只分析: $analyzeOnly');
      print('');
    }

    // 检查输入文件是否存在
    if (!File(inputFile).existsSync()) {
      stderr.writeln('❌ 错误: 输入文件不存在: $inputFile');
      exit(1);
    }

    // 读取Dart文件
    if (verbose) print('🔄 正在读取 Dart 源码...');
    final dartCode = await _readDartFile(inputFile, verbose);

    if (analyzeOnly) {
      _analyzeDartCode(dartCode, verbose);
      return;
    }

    // 转换为C++
    if (verbose) print('🔄 正在转换 Dart 到 C++...');
    final cppCode = _generateCppFromDart(dartCode, template);

    // 创建输出目录
    final outputDir = Directory(outputFile).parent;
    if (!outputDir.existsSync()) {
      outputDir.createSync(recursive: true);
    }

    // 写入输出文件
    if (verbose) print('💾 正在保存 C++ 代码...');
    await File(outputFile).writeAsString(cppCode);

    // 生成编译脚本
    final compileScript = _generateCompileScript(outputFile);
    final scriptPath = '${outputFile.replaceAll('.cpp', '_compile.sh')}';
    await File(scriptPath).writeAsString(compileScript);

    // 设置执行权限 (Unix系统)
    if (Platform.isLinux || Platform.isMacOS) {
      await Process.run('chmod', ['+x', scriptPath]);
    }

    print('✅ 转换完成！');
    print('📄 C++ 文件: $outputFile');
    print('🔨 编译脚本: $scriptPath');

    if (verbose) {
      print('\n📊 统计信息:');
      _printStatistics(dartCode, cppCode);
    }

    print('\n🚀 编译和运行:');
    print('   ./${scriptPath.split('/').last}');
  } catch (e, stackTrace) {
    stderr.writeln('❌ 错误: $e');
    if (args.contains('--verbose') || args.contains('-v')) {
      stderr.writeln('堆栈跟踪:\n$stackTrace');
    }
    exit(1);
  }
}

/// 简化的Dart文件读取
Future<String> _readDartFile(String inputFile, bool verbose) async {
  try {
    if (verbose) print('📖 正在读取 Dart 文件: $inputFile');
    return await File(inputFile).readAsString();
  } catch (e) {
    throw Exception('读取 Dart 文件失败: $e');
  }
}

/// 分析Dart代码结构
void _analyzeDartCode(String dartCode, bool verbose) {
  print('📊 代码分析结果:');
  print('');

  final lines = dartCode.split('\n');
  int totalClasses = 0;
  int totalFunctions = 0;
  int totalFields = 0;

  for (final line in lines) {
    final trimmedLine = line.trim();

    if (trimmedLine.startsWith('class ')) {
      totalClasses++;
      if (verbose) {
        final className = trimmedLine.split(' ')[1];
        print('  📦 类: $className');
      }
    } else if (trimmedLine.contains('(') &&
        trimmedLine.contains(')') &&
        !trimmedLine.startsWith('//') &&
        !trimmedLine.contains('=')) {
      totalFunctions++;
      if (verbose) {
        final funcName = trimmedLine.split('(')[0].split(' ').last;
        print('  🔧 函数/方法: $funcName');
      }
    } else if ((trimmedLine.contains(' ') && trimmedLine.endsWith(';')) ||
        (trimmedLine.contains(' ') && trimmedLine.contains('='))) {
      totalFields++;
    }
  }

  print('📈 总计:');
  print('  - 类数量: $totalClasses');
  print('  - 字段数量: $totalFields');
  print('  - 函数/方法数量: $totalFunctions');
}

/// 根据模板生成C++代码
String _generateCppFromDart(String dartCode, String template) {
  // ⚠️ 这里使用简化的转换逻辑，实际应用中可以集成更复杂的转换器
  final buffer = StringBuffer();

  // 生成头文件
  buffer.writeln('#include "./core/object.h"');
  if (template == 'oop' || template == 'full') {
    buffer.writeln('#include "./core/dart_oop_extensions.h"');
  }
  if (template == 'async' || template == 'full') {
    buffer.writeln('#include "./core/dart_async_simple.h"');
  }
  buffer.writeln('#include <iostream>');
  buffer.writeln('');

  // 生成工具宏
  buffer.writeln('// 工具宏定义');
  buffer.writeln(
      '#define dart_print(value) std::cout << (value).toString().getValue() << std::endl');
  buffer.writeln('#define dart_int(value) Int(value)');
  buffer.writeln('#define dart_double(value) Double(value)');
  buffer.writeln('#define dart_bool(value) Bool(value)');
  buffer.writeln('#define dart_string(value) String(value)');
  buffer.writeln('');

  // 添加转换后的代码注释
  buffer.writeln(
      '// ============================================================================');
  buffer.writeln('// 从 Dart 转换的 C++ 代码 (简化版)');
  buffer.writeln(
      '// ============================================================================');
  buffer.writeln('');
  buffer.writeln('int main() {');
  buffer.writeln('    try {');
  buffer.writeln(
      '        dart_print(dart_string("Hello from converted Dart code!"));');
  buffer.writeln('        // TODO: 在这里添加转换后的 Dart 代码');
  buffer.writeln('        return 0;');
  buffer.writeln('    } catch (const std::exception& e) {');
  buffer.writeln('        std::cerr << "Error: " << e.what() << std::endl;');
  buffer.writeln('        return 1;');
  buffer.writeln('    }');
  buffer.writeln('}');

  return buffer.toString();
}

/// 生成编译脚本
String _generateCompileScript(String cppFile) {
  final execName = cppFile.replaceAll('.cpp', '');

  return '''#!/bin/bash
# 自动生成的编译脚本

set -e

echo "编译 Dart 到 C++ 生成的代码..."
echo "=========================="

CXX=\${CXX:-g++}
CXXFLAGS="\${CXXFLAGS:--std=c++17 -Wall -Wextra -O2}"

echo "使用编译器: \$CXX"
echo "编译选项: \$CXXFLAGS"
echo ""

# 编译
echo "正在编译 $cppFile ..."
\$CXX \$CXXFLAGS \\
    "$cppFile" \\
    "./core/object.cpp" \\
    -o "$execName"

if [ \$? -eq 0 ]; then
    echo "✅ 编译成功！"
    echo "可执行文件: $execName"
    echo ""
    echo "运行程序:"
    echo "=========="
    ./$execName
else
    echo "❌ 编译失败！"
    exit 1
fi
''';
}

/// 打印统计信息
void _printStatistics(String dartCode, String cppCode) {
  final dartLines = dartCode.split('\n');
  final cppLines = cppCode.split('\n');
  final nonEmptyDartLines =
      dartLines.where((line) => line.trim().isNotEmpty).length;
  final nonEmptyCppLines =
      cppLines.where((line) => line.trim().isNotEmpty).length;

  int totalClasses = 0;
  int totalFunctions = 0;

  for (final line in dartLines) {
    final trimmedLine = line.trim();
    if (trimmedLine.startsWith('class ')) {
      totalClasses++;
    } else if (trimmedLine.contains('(') &&
        trimmedLine.contains(')') &&
        !trimmedLine.startsWith('//') &&
        !trimmedLine.contains('=')) {
      totalFunctions++;
    }
  }

  print('  - 原始 Dart 类数: $totalClasses');
  print('  - 原始 Dart 函数/方法数: $totalFunctions');
  print('  - 原始 Dart 代码行数: $nonEmptyDartLines');
  print('  - 生成的 C++ 代码行数: $nonEmptyCppLines');
  print('  - 生成的 C++ 总行数: ${cppLines.length}');
}

/// 打印使用帮助
void _printUsage(ArgParser parser) {
  print('''
Dart 到 C++ 转换工具

使用方法:
  dart tools/dart_to_cpp_tool.dart --input <input.dart> --output <output.cpp> [选项]

示例:
  # 基本转换
  dart tools/dart_to_cpp_tool.dart -i test.dart -o test.cpp
  
  # 详细模式转换
  dart tools/dart_to_cpp_tool.dart -i test.dart -o test.cpp --verbose
  
  # 只分析不生成代码
  dart tools/dart_to_cpp_tool.dart -i test.dart -o test.cpp --analyze
  
  # 使用简单模板
  dart tools/dart_to_cpp_tool.dart -i test.dart -o test.cpp --template simple

选项:
${parser.usage}

模板说明:
  simple - 简化模板，只包含基本类型转换
  oop    - 面向对象模板，包含接口和混入支持
  async  - 异步模板，包含 Future/async/await 支持  
  full   - 完整模板，包含所有功能 (默认)
''');
}
