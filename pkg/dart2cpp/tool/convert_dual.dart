#!/usr/bin/env dart
/// 双输出生成器：同时生成静态 Dart 和 C++
/// 用法: dart tool/convert_dual.dart <source.dart> <output_dir>
/// 示例: dart tool/convert_dual.dart sample/src/hello.dart sample/output

import 'dart:io';
import 'package:kernel/kernel.dart' as k;
import '../lib/dart_to_dart_restorer.dart';
import '../lib/dart_to_cpp.dart';

void main(List<String> args) {
  if (args.length != 2) {
    stderr.writeln('用法: dart tool/convert_dual.dart <source.dart> <output_dir>');
    exit(1);
  }

  final srcPath = args[0];
  final outDir = args[1];

  if (!File(srcPath).existsSync()) {
    stderr.writeln('源文件不存在: $srcPath');
    exit(1);
  }

  // 创建输出目录
  final dir = Directory(outDir);
  if (!dir.existsSync()) {
    dir.createSync(recursive: true);
  }

  final basename = srcPath.split('/').last.replaceAll('.dart', '');

  print('🔧 编译 $srcPath 到 Kernel...');
  final dillPath = '/tmp/${basename}_dual.dill';
  final dartExe = Platform.resolvedExecutable;

  final compileResult = Process.runSync(
    dartExe,
    ['compile', 'kernel', srcPath, '-o', dillPath],
  );

  if (compileResult.exitCode != 0) {
    stderr.writeln('编译失败:');
    stderr.writeln(compileResult.stderr);
    exit(1);
  }
  print('✅ 编译成功');

  print('📦 加载 Kernel...');
  final component = k.loadComponentFromBinary(dillPath);
  print('✅ 加载成功');

  // 生成静态 Dart
  print('🔄 生成静态 Dart...');
  final dartSource = restoreDartFromComponent(component);
  final dartOutputPath = '$outDir/${basename}_restored.dart';
  File(dartOutputPath).writeAsStringSync(dartSource);
  print('✅ 静态 Dart: $dartOutputPath (${dartSource.length} 字符, ${dartSource.split('\n').length} 行)');

  // 生成 C++
  print('⚙️  生成 C++...');
  final cppSource = emitCppFromComponent(component);
  final cppOutputPath = '$outDir/${basename}_restored.cpp';
  File(cppOutputPath).writeAsStringSync(cppSource);
  print('✅ C++: $cppOutputPath (${cppSource.length} 字符, ${cppSource.split('\n').length} 行)');

  print('\n📊 双输出完成:');
  print('  📄 Dart: ${dartSource.split('\n').length} 行');
  print('  📄 C++:  ${cppSource.split('\n').length} 行');
}
