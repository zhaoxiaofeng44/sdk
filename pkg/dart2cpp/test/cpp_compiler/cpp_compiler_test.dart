#!/usr/bin/env dart
// ============================================================================
// Dart→C++ 编译器端到端测试
// 完整链路：Dart 源码 → Kernel AST → compileToCpp → C++ 源码 → g++ 编译 → 运行验证
// ============================================================================

import 'dart:io';
import 'package:kernel/kernel.dart';
import 'package:front_end/src/api_unstable/vm.dart';
import 'package:vm/kernel_front_end.dart';

import '../../lib/cpp_compiler/cpp_compiler.dart';

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

// ---- SDK platform dill 路径 ----
String get _sdkPlatformDill {
  final candidates = [
    '/Users/tbsg/Project/MyProject.bundle/sdk/mydart/sdk/xcodebuild/DebugX64/dart-sdk/lib/_internal/vm_platform_strong.dill',
    '/Users/tbsg/Project/MyProject/sdk/mydart/sdk/xcodebuild/DebugX64/dart-sdk/lib/_internal/vm_platform_strong.dill',
  ];
  for (final path in candidates) {
    if (File(path).existsSync()) return path;
  }
  final dartExe = Platform.resolvedExecutable;
  final sdkDir = File(dartExe).parent.parent.path;
  final inferredPath = '$sdkDir/lib/_internal/vm_platform_strong.dill';
  if (File(inferredPath).existsSync()) return inferredPath;
  return candidates[0];
}

// ============================================================================
// 主入口
// ============================================================================

Future<void> main(List<String> args) async {
  printBold('\n$_cyan╔══════════════════════════════════════════════════════╗$_reset');
  printBold('$_cyan║      Dart→C++ 编译器端到端测试                        ║$_reset');
  printBold('$_cyan╚══════════════════════════════════════════════════════╝$_reset\n');

  final scriptDir = File(Platform.script.toFilePath()).parent.path;
  final testFileName = args.isNotEmpty ? args[0] : 'hello_world';
  final baseName = testFileName.endsWith('.dart')
      ? testFileName.substring(0, testFileName.length - 5)
      : testFileName;
  final testSourcePath = '$scriptDir/samples/$baseName.dart';
  final cppOutputPath = '$scriptDir/output/$baseName.cpp';
  final cppBinaryPath = '$scriptDir/output/$baseName';

  if (!File(testSourcePath).existsSync()) {
    printRed('❌ 测试源文件不存在: $testSourcePath');
    exit(1);
  }

  Directory('$scriptDir/output').createSync(recursive: true);

  // ---- 步骤 1: 读取原始源码 ----
  printBold('📄 步骤 1: 读取原始 Dart 源码');
  final originalSource = File(testSourcePath).readAsStringSync();
  printGreen('  ✅ 读取成功 (${originalSource.length} 字符, ${originalSource.split('\n').length} 行)');

  // ---- 步骤 2: 编译为 Kernel AST ----
  printBold('\n🔨 步骤 2: 编译 Dart 源码 → Kernel AST');
  final component = await _compileToKernel(testSourcePath);
  if (component == null) {
    printRed('❌ Kernel 编译失败，退出');
    exit(1);
  }
  printGreen('  ✅ Kernel 编译成功');
  _printComponentInfo(component);

  // ---- 步骤 3: 生成 C++ 源码 ----
  printBold('\n🔄 步骤 3: compileToCpp — 生成 C++ 源码');
  final stopwatch = Stopwatch()..start();
  String cppSource;
  try {
    cppSource = compileToCpp(component);
    stopwatch.stop();
    printGreen('  ✅ 生成成功 (${cppSource.length} 字符, ${cppSource.split('\n').length} 行, 耗时 ${stopwatch.elapsedMilliseconds}ms)');
  } catch (e, stack) {
    stopwatch.stop();
    printRed('  ❌ 生成失败: $e');
    print(stack);
    exit(1);
  }

  // ---- 步骤 4: 写入 C++ 文件 ----
  printBold('\n💾 步骤 4: 写入 C++ 源文件');
  File(cppOutputPath).writeAsStringSync(cppSource);
  printGreen('  ✅ 写入成功: $cppOutputPath');

  // ---- 步骤 5: g++ 编译 ----
  printBold('\n🔧 步骤 5: g++ 编译 C++ 源码');
  final projectRoot = '$scriptDir/../..';
  final compileResult = await Process.run('g++', [
    '-std=c++17',
    '-I', '$projectRoot/cpp/core/',
    '-o', cppBinaryPath,
    cppOutputPath,
  ]);
  if (compileResult.exitCode != 0) {
    printRed('  ❌ g++ 编译失败:');
    printRed(compileResult.stderr.toString());
    printYellow('  ⚠️ C++ 源码已保存到: $cppOutputPath');
    exit(1);
  }
  printGreen('  ✅ g++ 编译成功');

  // ---- 步骤 6: 运行 C++ 程序 ----
  printBold('\n▶️  步骤 6: 运行 C++ 程序');
  final cppRunResult = await Process.run(cppBinaryPath, []);
  final cppOutput = cppRunResult.stdout.toString().trim();
  printCyan('  C++ 输出:');
  for (final line in cppOutput.split('\n')) {
    printCyan('    $line');
  }

  // ---- 步骤 7: 运行原始 Dart 程序 ----
  printBold('\n▶️  步骤 7: 运行原始 Dart 程序');
  final dartRunResult = await Process.run('dart', ['run', testSourcePath]);
  final dartOutput = dartRunResult.stdout.toString().trim();
  printCyan('  Dart 输出:');
  for (final line in dartOutput.split('\n')) {
    printCyan('    $line');
  }

  // ---- 步骤 8: 对比输出 ----
  printBold('\n📊 步骤 8: 对比输出');
  if (cppOutput == dartOutput) {
    printGreen('  ✅ 输出完全匹配！');
  } else {
    printRed('  ❌ 输出不匹配');
    printRed('  期望 (Dart): $dartOutput');
    printRed('  实际 (C++):  $cppOutput');
    exit(1);
  }

  printBold('\n$_green╔══════════════════════════════════════════════════════╗$_reset');
  printBold('$_green║      ✅ 全部测试通过！                                 ║$_reset');
  printBold('$_green╚══════════════════════════════════════════════════════╝$_reset\n');
}

// ============================================================================
// Kernel 编译
// ============================================================================

Future<Component?> _compileToKernel(String sourcePath) async {
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

    return results.component;
  } catch (e, stack) {
    printRed('  ❌ front_end 编译异常: $e');
    print(stack);
    return null;
  }
}

void _printComponentInfo(Component component) {
  final userLibs = component.libraries.where((lib) {
    final uri = lib.importUri.toString();
    return !uri.startsWith('dart:') && !uri.startsWith('package:');
  }).toList();

  printCyan('  用户库: ${userLibs.length}');
  for (final lib in userLibs) {
    final clsCount = lib.classes.length;
    final procCount = lib.procedures.length;
    printCyan('    ${lib.importUri}: $clsCount 类, $procCount 函数');
  }
}
