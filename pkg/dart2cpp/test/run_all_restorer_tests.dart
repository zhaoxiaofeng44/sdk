#!/usr/bin/env dart
/// 批量运行所有 restorer 测试用例（含 C++ 编译+运行验证）
import 'dart:io';
import 'package:kernel/kernel.dart';

import '../lib/dart_to_dart_restorer.dart';
import '../lib/dart_to_cpp.dart';

/// 所有待测试的用例（不含 _restored 后缀）
/// 注意: mixin_lowering_test 是自包含测试脚本，不适用批量运行器
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

class _TestResult {
  final String name;
  final bool compileOk;
  final bool restoreOk;
  final bool runOk;
  final bool outputMatch;
  final bool cppGenerateOk;
  final bool cppCompileOk;
  final bool cppRunOk;
  final bool cppOutputMatch;
  final String? errorDetail;

  _TestResult({
    required this.name,
    required this.compileOk,
    required this.restoreOk,
    required this.runOk,
    required this.outputMatch,
    this.cppGenerateOk = false,
    this.cppCompileOk = false,
    this.cppRunOk = false,
    this.cppOutputMatch = false,
    this.errorDetail,
  });

  bool get passed => compileOk && restoreOk && runOk && outputMatch;
  bool get cppPassed => cppGenerateOk && cppCompileOk && cppRunOk && cppOutputMatch;
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

Future<_TestResult> runOneTest(String baseName, String scriptDir, {bool enableCpp = false}) async {
  final testSourcePath = '$scriptDir/$baseName.dart';
  final restoredOutputPath = '$scriptDir/${baseName}_restored.dart';
  final dillPath = '/tmp/${baseName}_test.dill';
  final dartExe = Platform.resolvedExecutable;

  print('\n${'─' * 60}');
  print('📦 测试: $baseName');

  // 步骤 1: 使用 dart compile kernel CLI 编译
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
      compileOk: false,
      restoreOk: false,
      runOk: false,
      outputMatch: false,
      errorDetail: 'Kernel 编译失败: $error',
    );
  }
  print('  ✅ Dart Kernel 编译成功');

  // 步骤 2: 加载 kernel 并还原
  Component component;
  try {
    component = loadComponentFromBinary(dillPath);
  } catch (e) {
    print('  ❌ Kernel 加载失败: $e');
    return _TestResult(
      name: baseName,
      compileOk: true,
      restoreOk: false,
      runOk: false,
      outputMatch: false,
      errorDetail: 'Kernel 加载失败: $e',
    );
  }

  String restoredSource;
  try {
    restoredSource = restoreDartFromComponent(component);
    print('  ✅ Dart 还原成功 (${restoredSource.length} 字符, ${restoredSource.split('\n').length} 行)');
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
    print('  ✅ Dart 还原代码运行成功');
  } else {
    final firstError = (runResult.stderr as String).split('\n').take(3).join('\n');
    print('  ❌ Dart 还原代码运行失败 (exit=${runResult.exitCode})');
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
    print('  ✅ Dart 输出一致');
  } else {
    print('  ⚠️  Dart 输出不一致');
  }

  // 步骤 5: C++ 生成 + 编译 + 运行验证
  bool cppGenerateOk = false;
  bool cppCompileOk = false;
  bool cppRunOk = false;
  bool cppOutputMatch = false;
  if (enableCpp) {
    try {
      final cppSource = emitCppFromComponent(component);
      if (cppSource.isNotEmpty) {
        cppGenerateOk = true;
        print('  ✅ C++ 生成成功 (${cppSource.length} 字符)');

        // 写入临时文件
        final cppFile = '/tmp/${baseName}_verify.cpp';
        final exeFile = '/tmp/${baseName}_verify';
        File(cppFile).writeAsStringSync(cppSource);

        // 编译为可执行文件（不是 -c）
        final cppResult = await Process.run(
          'g++',
          ['-std=c++17', cppFile, '-o', exeFile, '-I', 'lib/platform/cpp', '-Wno-everything'],
        );

        if (cppResult.exitCode == 0) {
          cppCompileOk = true;
          print('  ✅ C++ 编译+链接成功');

          // 运行 C++ 可执行文件
          final cppRunResult = await Process.run(exeFile, []);
          cppRunOk = cppRunResult.exitCode == 0;
          if (cppRunOk) {
            print('  ✅ C++ 运行成功');
            // 对比输出
            final cppOut = (cppRunResult.stdout as String).trim();
            cppOutputMatch = origOut == cppOut;
            if (cppOutputMatch) {
              print('  ✅ C++ 输出与 Dart 一致');
            } else {
              print('  ⚠️  C++ 输出与 Dart 不一致');
            }
          } else {
            final cppErr = (cppRunResult.stderr as String).split('\n').take(3).join('\n     ');
            print('  ❌ C++ 运行失败 (exit=${cppRunResult.exitCode})');
            if (cppErr.isNotEmpty) print('     $cppErr');
          }

          // 清理可执行文件
          if (File(exeFile).existsSync()) File(exeFile).deleteSync();
        } else {
          final stderr = (cppResult.stderr as String).split('\n').take(5).join('\n     ');
          print('  ❌ C++ 编译失败');
          print('     $stderr');
        }

        // 清理 C++ 源文件
        if (File(cppFile).existsSync()) File(cppFile).deleteSync();
      } else {
        print('  ⚠️  C++ 生成为空');
      }
    } catch (e) {
      print('  ❌ C++ 生成异常: $e');
    }
  }

  return _TestResult(
    name: baseName,
    compileOk: true,
    restoreOk: true,
    runOk: true,
    outputMatch: outputMatch,
    cppGenerateOk: cppGenerateOk,
    cppCompileOk: cppCompileOk,
    cppRunOk: cppRunOk,
    cppOutputMatch: cppOutputMatch,
  );
}

Future<void> main(List<String> args) async {
  final scriptDir = File(Platform.script.toFilePath()).parent.path;

  // 检测 g++ 是否可用
  final hasGpp = _hasGpp();
  final enableCpp = hasGpp && !args.contains('--no-cpp');
  if (enableCpp) {
    print('🔧 C++ 验证已启用 (g++ 可用, 编译+运行+输出对比)');
  } else if (!hasGpp) {
    print('⚠️  未检测到 g++，跳过 C++ 验证');
  }

  // 支持通过参数指定子集，默认全部运行
  final casesToRun = args.where((a) => !a.startsWith('--')).toList();
  final effectiveCases = casesToRun.isNotEmpty ? casesToRun : _testCases;

  print('🚀 批量还原测试 — 共 ${effectiveCases.length} 个用例');

  final results = <_TestResult>[];
  for (final name in effectiveCases) {
    final r = await runOneTest(name, scriptDir, enableCpp: enableCpp);
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

    // C++ 状态
    String cppStatus = '';
    if (enableCpp) {
      if (r.cppPassed) {
        cppStatus = ' [C++✅]';
      } else if (r.cppGenerateOk && r.cppCompileOk && r.cppRunOk && !r.cppOutputMatch) {
        cppStatus = ' [C++⚠️输出不一致]';
      } else if (r.cppGenerateOk && r.cppCompileOk && !r.cppRunOk) {
        cppStatus = ' [C++❌运行]';
      } else if (r.cppGenerateOk && !r.cppCompileOk) {
        cppStatus = ' [C++❌编译]';
      } else if (!r.cppGenerateOk) {
        cppStatus = ' [C++❌生成]';
      }
    }

    print('  $icon ${r.name}$cppStatus$detail');
  }

  print('\n${'─' * 60}');
  print('Dart 通过: ${passed.length} / ${results.length}    失败: ${failed.length}');

  if (enableCpp) {
    final cppGenOk = results.where((r) => r.cppGenerateOk).length;
    final cppCompOk = results.where((r) => r.cppCompileOk).length;
    final cppRunOkCount = results.where((r) => r.cppRunOk).length;
    final cppOutOk = results.where((r) => r.cppOutputMatch).length;
    print('C++ 生成: $cppGenOk / ${results.length}');
    print('C++ 编译: $cppCompOk / ${results.length}');
    print('C++ 运行: $cppRunOkCount / ${results.length}');
    print('C++ 输出一致: $cppOutOk / ${results.length}');
  }

  if (failed.isNotEmpty) {
    exit(1);
  }
}

String _failStage(_TestResult r) {
  if (!r.compileOk) return 'Kernel编译失败';
  if (!r.restoreOk) return 'Dart还原失败';
  if (!r.runOk) return 'Dart运行失败';
  if (!r.outputMatch) return 'Dart输出不一致';
  return '';
}
