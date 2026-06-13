#!/usr/bin/env dart
/// 批量运行所有 restorer 测试用例
import 'dart:io';
import 'package:kernel/kernel.dart';
import 'package:front_end/src/api_unstable/vm.dart' show CompilerOptions, StandardFileSystem;
import 'package:front_end/src/api_prototype/kernel_generator.dart' show kernelForProgram, CompilerResult;

import '../lib/dart_to_dart_restorer.dart';

const String _sdkPlatformDill =
    '/Users/tbsg/Project/MyProject/sdk/mydart/sdk/xcodebuild/DebugX64/dart-sdk/lib/_internal/vm_platform_strong.dill';

/// 所有待测试的用例（不含 _restored 后缀）
const List<String> _testCases = [
  'restorer_complex_test',
  'restorer_full_test',
  'restorer_advanced_test',
  'restorer_async_test',
  'restorer_complex_oop_test',
  'restorer_stress_test',
  'state_machine_advanced_test',
  'state_machine_coroutine_test',
  'static_collections_test',
];

class _TestResult {
  final String name;
  final bool compileOk;
  final bool restoreOk;
  final bool runOk;
  final bool outputMatch;
  final String? errorDetail;

  _TestResult({
    required this.name,
    required this.compileOk,
    required this.restoreOk,
    required this.runOk,
    required this.outputMatch,
    this.errorDetail,
  });

  bool get passed => compileOk && restoreOk && runOk && outputMatch;
}

Future<_TestResult> runOneTest(String baseName, String scriptDir) async {
  final testSourcePath = '$scriptDir/$baseName.dart';
  final restoredOutputPath = '$scriptDir/${baseName}_restored.dart';
  final dartExe = Platform.resolvedExecutable;

  print('\n${'─' * 60}');
  print('📦 测试: $baseName');

  // 步骤 1: 编译
  final compilerOptions = CompilerOptions()
    ..sdkSummary = Uri.file(_sdkPlatformDill)
    ..fileSystem = StandardFileSystem.instance
    ..embedSourceText = false;

  final CompilerResult? result = await kernelForProgram(
    Uri.file(testSourcePath),
    compilerOptions,
  );

  if (result == null || result.component == null) {
    print('  ❌ Kernel 编译失败');
    return _TestResult(
      name: baseName,
      compileOk: false,
      restoreOk: false,
      runOk: false,
      outputMatch: false,
      errorDetail: 'Kernel 编译失败',
    );
  }
  print('  ✅ 编译成功');

  // 步骤 2: 还原
  String restoredSource;
  try {
    restoredSource = restoreDartFromComponent(result.component!);
    print('  ✅ 还原成功 (${restoredSource.length} 字符, ${restoredSource.split('\n').length} 行)');
  } catch (e) {
    print('  ❌ 还原失败: $e');
    return _TestResult(
      name: baseName,
      compileOk: true,
      restoreOk: false,
      runOk: false,
      outputMatch: false,
      errorDetail: '还原异常: $e',
    );
  }

  File(restoredOutputPath).writeAsStringSync(restoredSource);

  // 步骤 3: 运行还原后代码
  final runResult = await Process.run(dartExe, ['run', restoredOutputPath]);
  final runOk = runResult.exitCode == 0;
  if (runOk) {
    print('  ✅ 还原代码运行成功');
  } else {
    final firstError = (runResult.stderr as String).split('\n').take(3).join('\n');
    print('  ❌ 还原代码运行失败 (exit=${runResult.exitCode})');
    print('     $firstError');
    return _TestResult(
      name: baseName,
      compileOk: true,
      restoreOk: true,
      runOk: false,
      outputMatch: false,
      errorDetail: firstError,
    );
  }

  // 步骤 4: 与原始输出对比
  final origResult = await Process.run(dartExe, ['run', testSourcePath]);
  final origOut = (origResult.stdout as String).trim();
  final restOut = (runResult.stdout as String).trim();
  final outputMatch = origOut == restOut;
  if (outputMatch) {
    print('  ✅ 输出一致');
  } else {
    print('  ⚠️  输出不一致');
  }

  return _TestResult(
    name: baseName,
    compileOk: true,
    restoreOk: true,
    runOk: true,
    outputMatch: outputMatch,
  );
}

Future<void> main(List<String> args) async {
  final scriptDir = File(Platform.script.toFilePath()).parent.path;

  // 支持通过参数指定子集，默认全部运行
  final casesToRun = args.isNotEmpty ? args : _testCases;

  print('🚀 批量还原测试 — 共 ${casesToRun.length} 个用例');

  final results = <_TestResult>[];
  for (final name in casesToRun) {
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
  print('通过: ${passed.length} / ${results.length}    失败: ${failed.length}');

  if (failed.isNotEmpty) {
    exit(1);
  }
}

String _failStage(_TestResult r) {
  if (!r.compileOk) return '编译失败';
  if (!r.restoreOk) return '还原失败';
  if (!r.runOk) return '运行失败';
  if (!r.outputMatch) return '输出不一致';
  return '';
}
