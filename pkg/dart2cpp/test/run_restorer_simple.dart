#!/usr/bin/env dart
/// 简化版还原器测试脚本
/// 使用 front_end kernelForProgram API 编译
import 'dart:io';
import 'package:kernel/kernel.dart';
import 'package:front_end/src/api_unstable/vm.dart' show CompilerOptions, StandardFileSystem;
import 'package:front_end/src/api_prototype/kernel_generator.dart' show kernelForProgram, CompilerResult;

import '../lib/dart_to_dart_restorer.dart';

const String _sdkPlatformDill =
    '/Users/tbsg/Project/MyProject/sdk/mydart/sdk/xcodebuild/DebugX64/dart-sdk/lib/_internal/vm_platform_strong.dill';

Future<void> main(List<String> args) async {
  final scriptDir = File(Platform.script.toFilePath()).parent.path;
  final testFileName = args.isNotEmpty ? args[0] : 'restorer_full_test';
  final baseName = testFileName.endsWith('.dart')
      ? testFileName.substring(0, testFileName.length - 5)
      : testFileName;
  final testSourcePath = '$scriptDir/$baseName.dart';
  final restoredOutputPath = '$scriptDir/${baseName}_restored.dart';

  if (!File(testSourcePath).existsSync()) {
    print('❌ 测试源文件不存在: $testSourcePath');
    exit(1);
  }

  // 步骤 1: 编译为 Kernel AST
  print('🔨 步骤 1: 编译 Dart 源码 → Kernel AST');
  final compilerOptions = CompilerOptions()
    ..sdkSummary = Uri.file(_sdkPlatformDill)
    ..fileSystem = StandardFileSystem.instance
    ..embedSourceText = false;

  final CompilerResult? result = await kernelForProgram(
    Uri.file(testSourcePath),
    compilerOptions,
  );

  if (result == null || result.component == null) {
    print('❌ Kernel 编译失败');
    exit(1);
  }
  print('✅ Kernel 编译成功');

  // 步骤 2: 用 DartRestorer 还原
  print('🔄 步骤 2: DartRestorer 还原');
  String restoredSource;
  try {
    restoredSource = restoreDartFromComponent(result.component!);
    print('✅ 还原成功 (${restoredSource.length} 字符, ${restoredSource.split('\n').length} 行)');
  } catch (e, stack) {
    print('❌ 还原失败: $e');
    print(stack);
    exit(1);
  }

  // 步骤 3: 写入还原后的文件
  File(restoredOutputPath).writeAsStringSync(restoredSource);
  print('💾 已写入: $restoredOutputPath');

  // 步骤 4: 运行还原后的代码
  print('🚀 步骤 4: 运行还原后的 Dart 代码');
  final dartExe = Platform.resolvedExecutable;
  final runResult = await Process.run(dartExe, ['run', restoredOutputPath]);
  if (runResult.exitCode == 0) {
    print('✅ 运行成功');
  } else {
    print('❌ 运行失败 (exit=${runResult.exitCode})');
    print('stderr:\n${runResult.stderr}');
  }
  if ((runResult.stdout as String).isNotEmpty) {
    print('stdout:\n${runResult.stdout}');
  }

  // 步骤 5: 运行原始代码对比
  print('\n📊 步骤 5: 运行原始代码对比');
  final origResult = await Process.run(dartExe, ['run', testSourcePath]);
  if (origResult.exitCode == 0) {
    print('✅ 原始代码运行成功');
  } else {
    print('❌ 原始代码运行失败');
  }

  // 步骤 6: 对比输出
  final origOut = (origResult.stdout as String).trim();
  final restOut = (runResult.stdout as String).trim();
  if (origOut == restOut) {
    print('\n🎉 输出完全一致！测试通过！');
  } else {
    print('\n⚠️ 输出不一致');
    final origLines = origOut.split('\n');
    final restLines = restOut.split('\n');
    int diffCount = 0;
    for (var i = 0; i < origLines.length || i < restLines.length; i++) {
      final o = i < origLines.length ? origLines[i] : '<缺失>';
      final r = i < restLines.length ? restLines[i] : '<缺失>';
      if (o != r && diffCount < 20) {
        print('  行 ${i + 1}:');
        print('    期望: $o');
        print('    实际: $r');
        diffCount++;
      }
    }
  }
}
