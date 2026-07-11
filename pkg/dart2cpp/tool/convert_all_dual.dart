#!/usr/bin/env dart
/// 批量双输出生成器：同时生成静态 Dart 和 C++
/// 用法: dart tool/convert_all_dual.dart [output_dir]
/// 默认输出目录: generated/

import 'dart:io';
import 'package:kernel/kernel.dart' as k;
import '../lib/dart_to_dart_restorer.dart';
import '../lib/dart_to_cpp.dart';

const List<String> _testCases = [
  'restorer_complex_test',
  'restorer_full_test',
  'restorer_advanced_test',
  'restorer_async_test',
  'restorer_complex_oop_test',
  'restorer_stress_test',
  'restorer_edge_test',
  'state_machine_advanced_test',
  'state_machine_coroutine_test',
  'static_collections_test',
  'runtime_gap_test',
];

void main(List<String> args) {
  final outDir = args.isNotEmpty ? args[0] : 'generated';
  final dir = Directory(outDir);
  if (!dir.existsSync()) dir.createSync(recursive: true);

  final dartExe = Platform.resolvedExecutable;
  print('🚀 批量双输出生成 — 共 ${_testCases.length} 个用例\n');

  int dartOk = 0, cppOk = 0;

  for (final name in _testCases) {
    final testFile = 'test/$name.dart';
    if (!File(testFile).existsSync()) {
      print('⚠️  跳过 $name (文件不存在)');
      continue;
    }

    final dillPath = '/tmp/${name}_dual.dill';

    // 编译
    final compileResult = Process.runSync(
      dartExe,
      ['compile', 'kernel', testFile, '-o', dillPath],
    );
    if (compileResult.exitCode != 0) {
      print('❌ $name 编译失败');
      continue;
    }

    // 加载
    final component = k.loadComponentFromBinary(dillPath);

    // 生成 Dart
    try {
      final dartSource = restoreDartFromComponent(component);
      File('$outDir/${name}_restored.dart').writeAsStringSync(dartSource);
      dartOk++;
    } catch (e) {
      print('❌ $name Dart 生成失败: $e');
    }

    // 生成 C++
    try {
      final cppSource = emitCppFromComponent(component);
      File('$outDir/${name}_restored.cpp').writeAsStringSync(cppSource);
      cppOk++;
    } catch (e) {
      print('❌ $name C++ 生成失败: $e');
    }

    print('✅ $name');
  }

  print('\n${'═' * 60}');
  print('📊 批量双输出结果:');
  print('  Dart: $dartOk / ${_testCases.length} 成功');
  print('  C++:  $cppOk / ${_testCases.length} 成功');
  print('  输出目录: $outDir/');
}
