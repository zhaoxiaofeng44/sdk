#!/usr/bin/env dart
// ============================================================================
// 还原器测试驱动脚本
// 完整链路：Dart 源码 → Kernel AST → DartRestorer → 还原 Dart 代码 → 运行验证
// ============================================================================

import 'dart:io';
import 'package:kernel/kernel.dart';
import 'package:front_end/src/api_unstable/vm.dart';
import 'package:vm/kernel_front_end.dart';

import '../lib/dart_to_dart_restorer.dart';

// ---- 颜色输出辅助 ----
const _reset = '\x1B[0m';
const _green = '\x1B[32m';
const _red = '\x1B[31m';
const _yellow = '\x1B[33m';
const _cyan = '\x1B[36m';
const _bold = '\x1B[1m';

void printGreen(String msg) => print('$_green$msg$_reset');
void printRed(String msg) => print('$_red$msg$_reset');
void printYellow(String msg) => print('$_yellow$msg$_reset');
void printCyan(String msg) => print('$_cyan$msg$_reset');
void printBold(String msg) => print('$_bold$msg$_reset');

// ============================================================================
// 主入口
// ============================================================================

Future<void> main(List<String> args) async {
  printBold('\n$_cyan╔══════════════════════════════════════════════════════╗$_reset');
  printBold('$_cyan║      DartRestorer 完整链路测试                       ║$_reset');
  printBold('$_cyan╚══════════════════════════════════════════════════════╝$_reset\n');

  // 确定测试文件路径（支持命令行参数指定测试文件名，默认 restorer_complex_test）
  final scriptDir = File(Platform.script.toFilePath()).parent.path;
  final testFileName = args.isNotEmpty ? args[0] : 'restorer_complex_test';
  final baseName = testFileName.endsWith('.dart')
      ? testFileName.substring(0, testFileName.length - 5)
      : testFileName;
  final testSourcePath = '$scriptDir/$baseName.dart';
  final restoredOutputPath = '$scriptDir/${baseName}_restored.dart';
  final dillPath = '$scriptDir/$baseName.dill';

  if (!File(testSourcePath).existsSync()) {
    printRed('❌ 测试源文件不存在: $testSourcePath');
    exit(1);
  }

  // ---- 步骤 1: 读取原始源码 ----
  printBold('📄 步骤 1: 读取原始 Dart 源码');
  final originalSource = File(testSourcePath).readAsStringSync();
  printGreen('  ✅ 读取成功 (${originalSource.length} 字符, ${originalSource.split('\n').length} 行)');

  // ---- 步骤 2: 编译为 Kernel AST ----
  printBold('\n🔨 步骤 2: 编译 Dart 源码 → Kernel AST (.dill)');
  final component = await _compileToDill(testSourcePath, dillPath);
  if (component == null) {
    printRed('❌ Kernel 编译失败，退出');
    exit(1);
  }
  printGreen('  ✅ Kernel 编译成功');
  _printComponentInfo(component);

  // ---- 步骤 3: 用 DartRestorer 还原 ----
  printBold('\n🔄 步骤 3: DartRestorer 还原 Kernel AST → Dart 源码');
  final stopwatch = Stopwatch()..start();
  String restoredSource;
  try {
    restoredSource = restoreDartFromComponent(component);
    stopwatch.stop();
    printGreen('  ✅ 还原成功 (${restoredSource.length} 字符, ${restoredSource.split('\n').length} 行, 耗时 ${stopwatch.elapsedMilliseconds}ms)');
  } catch (e, stack) {
    stopwatch.stop();
    printRed('  ❌ 还原失败: $e');
    print(stack);
    exit(1);
  }

  // ---- 步骤 4: 写入还原后的文件 ----
  printBold('\n💾 步骤 4: 写入还原后的 Dart 文件');
  File(restoredOutputPath).writeAsStringSync(restoredSource);
  printGreen('  ✅ 已写入: $restoredOutputPath');

  // ---- 步骤 5: 分析还原结果 ----
  printBold('\n🔍 步骤 5: 分析还原结果');
  _analyzeRestoredSource(originalSource, restoredSource, baseName);

  // ---- 步骤 6: 运行还原后的代码 ----
  printBold('\n🚀 步骤 6: 运行还原后的 Dart 代码');
  final runResult = await _runDartFile(restoredOutputPath);
  _printRunResult(runResult);

  // ---- 步骤 7: 运行原始代码（对比基准）----
  printBold('\n📊 步骤 7: 运行原始 Dart 代码（对比基准）');
  final originalRunResult = await _runDartFile(testSourcePath);
  _printRunResult(originalRunResult);

  // ---- 步骤 8: 对比输出 ----
  printBold('\n🔎 步骤 8: 对比运行输出');
  _compareOutputs(originalRunResult.stdout, runResult.stdout);

  // ---- 步骤 9: 清理临时文件 ----
  printBold('\n🧹 步骤 9: 清理临时文件');
  _cleanup([dillPath]);

  // ---- 最终报告 ----
  _printFinalReport(runResult, originalRunResult);
}

// ============================================================================
// 编译 Dart → Kernel
// ============================================================================

/// SDK platform dill 路径（vm_platform_strong.dill）
const String _sdkPlatformDill =
    '/Users/tbsg/Project/MyProject.bundle/sdk/mydart/sdk/xcodebuild/DebugX64/dart-sdk/lib/_internal/vm_platform_strong.dill';

Future<Component?> _compileToDill(String sourcePath, String dillPath) async {
  // 使用 front_end API 编译 Dart → Kernel
  try {
    final compilerOptions = CompilerOptions()
      ..sdkSummary = Uri.file(_sdkPlatformDill)
      ..fileSystem = createFrontEndFileSystem(null, null)
      ..embedSourceText = false
      ..target = createFrontEndTarget('vm',
          trackWidgetCreation: false, supportMirrors: false);

    final results = await compileToKernel(KernelCompilationArguments(
      source: Uri.file(sourcePath),
      options: compilerOptions,
      requireMain: false,
      includePlatform: false,
      environmentDefines: {},
      enableAsserts: false,
    ));

    if (results.component == null) {
      printRed('  ❌ front_end 编译失败：component 为 null');
      return null;
    }

    // 写入 .dill 文件（供调试用）
    await writeComponentToBinary(results.component!, dillPath);
    return results.component;
  } catch (e, stack) {
    printRed('  ❌ front_end 编译异常: $e');
    print(stack);
    return null;
  }
}

// ============================================================================
// 打印 Component 信息
// ============================================================================

void _printComponentInfo(Component component) {
  final userLibraries = component.libraries
      .where((lib) => !lib.importUri.toString().startsWith('dart:') &&
                      !lib.importUri.toString().startsWith('package:'))
      .toList();

  printCyan('  📦 Component 信息:');
  printCyan('    • 总库数: ${component.libraries.length}');
  printCyan('    • 用户库数: ${userLibraries.length}');

  for (final lib in userLibraries) {
    final classCount = lib.classes.length;
    final procCount = lib.procedures.length;
    final extCount = lib.extensions.length;
    printCyan('    • ${lib.importUri}: $classCount 类, $procCount 函数, $extCount 扩展');
  }
}

// ============================================================================
// 分析还原结果
// ============================================================================

/// 根据测试文件名返回对应的语法检查项
Map<String, String> _getChecksForTest(String baseName) {
  if (baseName.contains('full')) {
    // restorer_full_test 的检查项
    return {
      'mixin':              'mixin ',
      'with':               ' with ',
      'abstract class':     'abstract class',
      'extends':            'extends',
      'operator +':         'operator +',
      'operator ==':        'operator ==',
      'static':             'static ',
      'factory':            'factory ',
      'const Result':       'const Result',
      'required':           'required ',
      'sync*':              'sync*',
      'async*':             'async*',
      'yield':              'yield ',
      'record access':      '.\$1',
      'switch pattern':     'switch (',
      'cascade ..':         '.add(',
      'spread ...':         '...',
      'late':               'late ',
      'rethrow':            'rethrow',
      'typedef':            'typedef ',
      'async':              'async',
      'await':              'await',
    };
  }
  // restorer_complex_test 的检查项（默认）
  return {
    'abstract class':     'abstract class',
    'extends':            'extends',
    'enum Direction':     'enum Direction',
    'extension':          'extension',
    'Future<':            'Future<',
    'async':              'async',
    'await':              'await',
    'switch':             'switch',
    'try {':              'try {',
    'catch':              'catch',
    'finally':            'finally',
    'String?':            'String?',
    '??':                 '??',
    'List<T>':            'List<T>',
    'const Pair':         'const Pair',
    'factory':            'factory',
    'get radius':         'get radius',
    'set radius':         'set radius',
    'for (final':         'for (final',
    'while (':            'while (',
    'do {':               'do {',
  };
}

void _analyzeRestoredSource(String original, String restored, String baseName) {
  // 根据测试文件选择检查项
  final checks = _getChecksForTest(baseName);

  int passed = 0;
  int failed = 0;

  for (final entry in checks.entries) {
    final label = entry.key;
    final pattern = entry.value;
    final found = restored.contains(pattern);
    if (found) {
      printGreen('  ✅ 包含 "$label"');
      passed++;
    } else {
      printRed('  ❌ 缺失 "$label"');
      failed++;
    }
  }

  print('');
  printBold('  检查结果: $passed/${passed + failed} 通过');
}

// ============================================================================
// 运行 Dart 文件
// ============================================================================

class RunResult {
  final int exitCode;
  final String stdout;
  final String stderr;
  final Duration elapsed;

  RunResult({
    required this.exitCode,
    required this.stdout,
    required this.stderr,
    required this.elapsed,
  });

  bool get isSuccess => exitCode == 0;
}

Future<RunResult> _runDartFile(String filePath) async {
  final dartExe = Platform.resolvedExecutable;
  final stopwatch = Stopwatch()..start();
  final result = await Process.run(dartExe, ['run', filePath]);
  stopwatch.stop();

  return RunResult(
    exitCode: result.exitCode,
    stdout: result.stdout as String,
    stderr: result.stderr as String,
    elapsed: stopwatch.elapsed,
  );
}

void _printRunResult(RunResult result) {
  if (result.isSuccess) {
    printGreen('  ✅ 运行成功 (exit=0, 耗时 ${result.elapsed.inMilliseconds}ms)');
  } else {
    printRed('  ❌ 运行失败 (exit=${result.exitCode}, 耗时 ${result.elapsed.inMilliseconds}ms)');
  }

  if (result.stderr.isNotEmpty) {
    printRed('  stderr:\n${_indent(result.stderr, '    ')}');
  }

  if (result.stdout.isNotEmpty) {
    printCyan('  stdout (前 30 行):');
    final lines = result.stdout.split('\n').take(30).join('\n');
    print(_indent(lines, '    '));
  }
}

// ============================================================================
// 对比输出
// ============================================================================

void _compareOutputs(String expected, String actual) {
  final expectedLines = expected.trim().split('\n');
  final actualLines = actual.trim().split('\n');

  if (expected.trim() == actual.trim()) {
    printGreen('  ✅ 输出完全一致！');
    return;
  }

  // 逐行对比
  final maxLines = expectedLines.length > actualLines.length
      ? expectedLines.length
      : actualLines.length;

  int matchCount = 0;
  final mismatches = <String>[];

  for (var i = 0; i < maxLines; i++) {
    final exp = i < expectedLines.length ? expectedLines[i] : '<缺失>';
    final act = i < actualLines.length ? actualLines[i] : '<缺失>';
    if (exp == act) {
      matchCount++;
    } else {
      if (mismatches.length < 10) {
        mismatches.add('  行 ${i + 1}:\n    期望: $exp\n    实际: $act');
      }
    }
  }

  final total = expectedLines.length;
  final pct = (matchCount / total * 100).toStringAsFixed(1);
  printYellow('  ⚠️  输出不完全一致: $matchCount/$total 行匹配 ($pct%)');

  if (mismatches.isNotEmpty) {
    printYellow('  前 ${mismatches.length} 处差异:');
    for (final m in mismatches) {
      printYellow(m);
    }
  }
}

// ============================================================================
// 清理临时文件
// ============================================================================

void _cleanup(List<String> paths) {
  for (final path in paths) {
    final file = File(path);
    if (file.existsSync()) {
      file.deleteSync();
      printGreen('  🗑️  已删除: $path');
    }
  }
}

// ============================================================================
// 最终报告
// ============================================================================

void _printFinalReport(RunResult restored, RunResult original) {
  printBold('\n$_cyan╔══════════════════════════════════════════════════════╗$_reset');
  printBold('$_cyan║                   最终测试报告                       ║$_reset');
  printBold('$_cyan╚══════════════════════════════════════════════════════╝$_reset');

  final restoredOk = restored.isSuccess;
  final originalOk = original.isSuccess;
  final outputMatch = restored.stdout.trim() == original.stdout.trim();

  print('');
  _reportItem('原始代码运行', originalOk);
  _reportItem('还原代码运行', restoredOk);
  _reportItem('输出一致性', outputMatch);

  print('');
  if (restoredOk && outputMatch) {
    printGreen('$_bold🎉 测试通过！还原器工作正常，输出与原始代码完全一致。$_reset');
  } else if (restoredOk && !outputMatch) {
    printYellow('$_bold⚠️  还原代码可运行，但输出与原始代码存在差异，请检查还原逻辑。$_reset');
  } else {
    printRed('$_bold❌ 测试失败！还原后的代码无法运行，请检查还原器。$_reset');
  }
  print('');
}

void _reportItem(String label, bool ok) {
  final icon = ok ? '✅' : '❌';
  final color = ok ? _green : _red;
  final status = ok ? 'PASS' : 'FAIL';
  print('  $icon $color$label: $status$_reset');
}

// ============================================================================
// 辅助方法
// ============================================================================

String _indent(String text, String prefix) {
  return text.split('\n').map((line) => '$prefix$line').join('\n');
}
