#!/usr/bin/env dart
/// 批量运行所有 C++ 生成+编译测试用例
import 'dart:io';
import 'package:kernel/kernel.dart';

import '../lib/dart_to_cpp.dart';

/// 所有待测试的用例
const List<String> _testCases = [
  'restorer_complex_test',
  'restorer_full_test',
  'restorer_advanced_test',
  'restorer_async_test',
  'restorer_complex_oop_test',
  'restorer_stress_test',
  'restorer_edge_test',
  'state_machine_coroutine_test',
  'static_collections_test',
  'runtime_gap_test',
];

class _TestResult {
  final String name;
  final bool kernelCompileOk;
  final bool cppGenerateOk;
  final bool cppCompileOk;
  final String? errorDetail;

  _TestResult({
    required this.name,
    required this.kernelCompileOk,
    this.cppGenerateOk = false,
    this.cppCompileOk = false,
    this.errorDetail,
  });

  bool get passed => kernelCompileOk && cppGenerateOk && cppCompileOk;
}

/// 检查系统是否有 g++ 可用
bool _hasGpp() {
  try {
    final result = Process.runSync('which', ['g++']);
    return result.exitCode == 0;
  } catch (_) {
    return false;
  }
}

Future<_TestResult> runOneTest(String baseName, String scriptDir) async {
  final testSourcePath = '$scriptDir/$baseName.dart';
  final dillPath = '/tmp/${baseName}_test.dill';
  final dartExe = Platform.resolvedExecutable;

  print('\n${'─' * 60}');
  print('📦 测试: $baseName');

  // 步骤 1: 编译到 Kernel
  final compileResult = await Process.run(
    dartExe,
    ['compile', 'kernel', testSourcePath, '-o', dillPath],
  );

  if (compileResult.exitCode != 0) {
    final error = (compileResult.stderr as String).split('\n').take(3).join('\n');
    print('  ❌ Kernel 编译失败');
    print('     $error');
    return _TestResult(
      name: baseName,
      kernelCompileOk: false,
      errorDetail: 'Kernel 编译失败: $error',
    );
  }
  print('  ✅ Dart Kernel 编译成功');

  // 步骤 2: 加载 kernel
  Component component;
  try {
    component = loadComponentFromBinary(dillPath);
  } catch (e) {
    print('  ❌ Kernel 加载失败: $e');
    return _TestResult(
      name: baseName,
      kernelCompileOk: true,
      errorDetail: 'Kernel 加载失败: $e',
    );
  }

  // 步骤 3: 生成 C++ + 编译验证
  bool cppGenerateOk = false;
  bool cppCompileOk = false;
  try {
    final cppSource = emitCppFromComponent(component);
    if (cppSource.isNotEmpty) {
      cppGenerateOk = true;
      print('  ✅ C++ 生成成功 (${cppSource.length} 字符)');

      final cppDir = 'cpp_output';
      Directory(cppDir).createSync(recursive: true);
      final cppFile = '$cppDir/${baseName}_verify.cpp';
      File(cppFile).writeAsStringSync(cppSource);
      print('  📄 C++ 产物: $cppFile');

      final cppResult = await Process.run(
        'g++',
        ['-std=c++17', '-c', cppFile, '-o', '/dev/null', '-I', 'lib/platform/cpp', '-Wno-everything'],
      );

      if (cppResult.exitCode == 0) {
        cppCompileOk = true;
        print('  ✅ C++ 编译成功');
      } else {
        final stderr = (cppResult.stderr as String).split('\n').take(5).join('\n     ');
        print('  ❌ C++ 编译失败');
        print('     $stderr');
      }
    } else {
      print('  ⚠️  C++ 生成为空');
    }
  } catch (e) {
    print('  ❌ C++ 生成异常: $e');
  }

  return _TestResult(
    name: baseName,
    kernelCompileOk: true,
    cppGenerateOk: cppGenerateOk,
    cppCompileOk: cppCompileOk,
  );
}

Future<void> main(List<String> args) async {
  final scriptDir = File(Platform.script.toFilePath()).parent.path;

  // 检测 g++ 是否可用
  final hasGpp = _hasGpp();
  if (!hasGpp) {
    print('⚠️  未检测到 g++，C++ 编译验证将跳过');
  }

  // 支持通过参数指定子集，默认全部运行
  final casesToRun = args.where((a) => !a.startsWith('--')).toList();
  final effectiveCases = casesToRun.isNotEmpty ? casesToRun : _testCases;

  print('🚀 批量 C++ 测试 — 共 ${effectiveCases.length} 个用例');

  final results = <_TestResult>[];
  for (final name in effectiveCases) {
    final r = await runOneTest(name, scriptDir);
    results.add(r);
  }

  // 汇总报告
  print('\n${'═' * 60}');
  print('📊 测试结果汇总');
  print('${'═' * 60}');

  final passed = results.where((r) => r.passed).toList();
  final failed = results.where((r) => !r.passed).toList();

  for (final r in results) {
    final icon = r.passed ? '✅' : '❌';
    final detail = r.passed
        ? ''
        : ' — ${_failStage(r)}'
            '${r.errorDetail != null ? ": ${r.errorDetail!.split('\n').first}" : ""}';
    print('  $icon ${r.name}$detail');
  }

  print('\n${'─' * 60}');
  print('C++ 通过: ${passed.length} / ${results.length}    失败: ${failed.length}');

  final cppGenOk = results.where((r) => r.cppGenerateOk).length;
  final cppCompOk = results.where((r) => r.cppCompileOk).length;
  print('C++ 生成: $cppGenOk / ${results.length}');
  print('C++ 编译: $cppCompOk / ${results.length}');

  if (failed.isNotEmpty) {
    exit(1);
  }
}

String _failStage(_TestResult r) {
  if (!r.kernelCompileOk) return 'Kernel编译失败';
  if (!r.cppGenerateOk) return 'C++生成失败';
  if (!r.cppCompileOk) return 'C++编译失败';
  return '';
}
