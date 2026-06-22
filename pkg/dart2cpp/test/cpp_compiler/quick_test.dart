#!/usr/bin/env dart
// ============================================================================
// Dart→C++ 编译器快速验证脚本
// 直接调用编译器API，生成C++代码并尝试用g++编译
// ============================================================================

import 'dart:io';
import 'package:kernel/kernel.dart';
import 'package:front_end/src/api_unstable/vm.dart';
import 'package:vm/kernel_front_end.dart';

import '../../lib/cpp_compiler/cpp_compiler.dart';

const _reset = '\x1B[0m';
const _green = '\x1B[32m';
const _red = '\x1B[31m';
const _cyan = '\x1B[36m';

void printGreen(String msg) => print('$_green$msg$_reset');
void printRed(String msg) => print('$_red$msg$_reset');
void printCyan(String msg) => print('$_cyan$msg$_reset');

String get _sdkPlatformDill {
  final candidates = [
    '/Users/tbsg/Project/MyProject.sdk/mydart/sdk/xcodebuild/DebugX64/dart-sdk/lib/_internal/vm_platform_strong.dill',
    '/Users/tbsg/Project/MyProject.bundle/sdk/mydart/sdk/xcodebuild/DebugX64/dart-sdk/lib/_internal/vm_platform_strong.dill',
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
      printRed('❌ front_end compilation failed: component is null');
      return null;
    }

    return results.component;
  } catch (e, stack) {
    printRed('❌ front_end compilation error: $e');
    print(stack);
    return null;
  }
}

Future<void> main(List<String> args) async {
  final scriptDir = File(Platform.script.toFilePath()).parent.path;
  final testFileName = args.isNotEmpty ? args[0] : 'hello_world';
  final baseName = testFileName.endsWith('.dart')
      ? testFileName.substring(0, testFileName.length - 5)
      : testFileName;

  final testSourcePath = '$scriptDir/samples/$baseName.dart';
  final cppOutputPath = '$scriptDir/output/$baseName.cpp';
  final cppBinaryPath = '$scriptDir/output/$baseName';
  final cppCoreDir = '${scriptDir}/../../cpp/core';

  if (!File(testSourcePath).existsSync()) {
    printRed('❌ Test source not found: $testSourcePath');
    exit(1);
  }

  Directory('$scriptDir/output').createSync(recursive: true);

  // Step 1: Compile to Kernel AST
  printCyan('🔨 Step 1: Dart → Kernel AST');
  final component = await _compileToKernel(testSourcePath);
  if (component == null) {
    printRed('❌ Kernel compilation failed');
    exit(1);
  }
  printGreen('  ✅ Kernel compiled successfully');

  // Step 2: Generate C++ code
  printCyan('🔄 Step 2: Kernel AST → C++ source');
  String cppSource;
  try {
    cppSource = compileToCpp(component);
    printGreen('  ✅ C++ generated (${cppSource.length} chars, ${cppSource.split('\n').length} lines)');
  } catch (e, stack) {
    printRed('  ❌ C++ generation failed: $e');
    print(stack);
    exit(1);
  }

  // Step 3: Write C++ file
  printCyan('💾 Step 3: Write C++ source file');
  File(cppOutputPath).writeAsStringSync(cppSource);
  printGreen('  ✅ Written to $cppOutputPath');

  // Step 4: Print generated C++ code (first 50 lines)
  printCyan('\n📄 Generated C++ (first 50 lines):');
  final lines = cppSource.split('\n');
  for (var i = 0; i < lines.length && i < 50; i++) {
    print('  ${lines[i]}');
  }

  // Step 5: Try to compile with g++
  printCyan('\n🔧 Step 4: g++ compile');
  final compileResult = Process.runSync(
    'g++',
    ['-std=c++17', '-I$cppCoreDir', cppOutputPath, '-o', cppBinaryPath],
  );
  if (compileResult.exitCode == 0) {
    printGreen('  ✅ g++ compilation successful!');
  } else {
    printRed('  ❌ g++ compilation failed:');
    print(compileResult.stderr);
    File('$scriptDir/output/${baseName}_compile_errors.txt')
        .writeAsStringSync(compileResult.stderr);
  }

  // Step 6: Try to run (if compilation succeeded)
  if (compileResult.exitCode == 0) {
    printCyan('\n🏃 Step 5: Run binary');
    final runResult = Process.runSync(cppBinaryPath, []);
    print('  stdout: ${runResult.stdout}');
    if (runResult.stderr.isNotEmpty) {
      print('  stderr: ${runResult.stderr}');
    }
    if (runResult.exitCode == 0) {
      printGreen('  ✅ Program ran successfully!');
    } else {
      printRed('  ❌ Program exited with code ${runResult.exitCode}');
    }
  }
}
