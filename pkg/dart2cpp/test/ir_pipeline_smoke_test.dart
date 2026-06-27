#!/usr/bin/env dart
// ============================================================================
// 新 IR 管线冒烟测试
// 编译一个简单 Dart 文件，通过新 IR 管线，打印输出
// ============================================================================

import 'dart:io';
import 'package:kernel/kernel.dart';
import 'package:front_end/src/api_unstable/vm.dart' show CompilerOptions, StandardFileSystem;
import 'package:front_end/src/api_prototype/kernel_generator.dart' show kernelForProgram, CompilerResult;

import '../lib/compile.dart';

const String _sdkPlatformDill =
    '/Users/tbsg/Project/MyProject/sdk/mydart/sdk/xcodebuild/DebugX64/dart-sdk/lib/_internal/vm_platform_strong.dill';

Future<void> main(List<String> args) async {
  print('╔══════════════════════════════════════════════╗');
  print('║  新 IR 管线冒烟测试                           ║');
  print('╚══════════════════════════════════════════════╝\n');

  final scriptDir = File(Platform.script.toFilePath()).parent.path;
  final testFileName = args.isNotEmpty ? args[0] : 'restorer_complex_test';
  final target = args.length > 1 && args[1] == 'cpp' ? CompileTarget.cpp : CompileTarget.dart;
  final testSourcePath = '$scriptDir/$testFileName.dart';

  if (!File(testSourcePath).existsSync()) {
    print('❌ 测试文件不存在: $testSourcePath');
    exit(1);
  }

  // 编译为 Kernel
  print('📦 编译 $testFileName.dart → Kernel...');
  final component = await _compileToDill(testSourcePath);
  if (component == null) {
    print('❌ 编译失败');
    exit(1);
  }
  print('✅ Kernel 编译成功');

  // 通过新管线
  print('\n🔄 通过新 IR 管线 (target: ${target.name})...');
  final stopwatch = Stopwatch()..start();
  try {
    final result = compile(component, target: target);
    stopwatch.stop();
    print('✅ 管线执行成功 (${result.length} 字符, ${result.split('\n').length} 行, ${stopwatch.elapsedMilliseconds}ms)');
    print('\n--- 输出前 100 行 ---');
    final lines = result.split('\n').take(100);
    for (final line in lines) {
      print(line);
    }
    if (result.split('\n').length > 100) {
      print('... (省略 ${result.split('\n').length - 100} 行)');
    }
    print('--- 输出结束 ---\n');

    // 写入文件
    final ext = target == CompileTarget.cpp ? '.cpp' : '.dart';
    final outputPath = '$scriptDir/${testFileName}_ir_restored$ext';
    File(outputPath).writeAsStringSync(result);
    print('📝 输出已写入: $outputPath');

  } catch (e, stack) {
    stopwatch.stop();
    print('❌ 管线执行失败: $e');
    print(stack);
    exit(1);
  }
}

Future<Component?> _compileToDill(String sourcePath) async {
  try {
    final compilerOptions = CompilerOptions()
      ..sdkSummary = Uri.file(_sdkPlatformDill)
      ..fileSystem = StandardFileSystem.instance
      ..embedSourceText = false;

    final CompilerResult? result = await kernelForProgram(
      Uri.file(sourcePath),
      compilerOptions,
    );

    return result?.component;
  } catch (e, stack) {
    print('❌ front_end 编译异常: $e');
    print(stack);
    return null;
  }
}
