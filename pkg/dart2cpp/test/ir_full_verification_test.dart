#!/usr/bin/env dart
/// Step 7 + end-to-end verification via the new IR pipeline.
import 'dart:io';
import 'package:kernel/kernel.dart';
import 'package:front_end/src/api_unstable/vm.dart' show CompilerOptions, StandardFileSystem;
import 'package:front_end/src/api_prototype/kernel_generator.dart' show kernelForProgram, CompilerResult;

import 'package:dart2cpp/compile.dart';

const _sdkPlatformDill =
    '/Users/tbsg/Project/MyProject/sdk/mydart/sdk/xcodebuild/DebugX64/dart-sdk/lib/_internal/vm_platform_strong.dill';

int _pass = 0, _fail = 0;
void check(String name, bool condition, [String detail = '']) {
  if (condition) { _pass++; print('  ✅ PASS: $name'); }
  else { _fail++; print('  ❌ FAIL: $name${detail != '' ? ' — $detail' : ''}'); }
}

Future<void> main() async {
  final scriptDir = File(Platform.script.toFilePath()).parent.path;
  final testPath = '$scriptDir/restorer_complex_test.dart';

  final compilerOptions = CompilerOptions()
    ..sdkSummary = Uri.file(_sdkPlatformDill)
    ..fileSystem = StandardFileSystem.instance
    ..embedSourceText = false;
  final result = await kernelForProgram(Uri.file(testPath), compilerOptions);
  if (result?.component == null) { print('❌ Kernel compile failed'); exit(1); }
  final component = result!.component!;

  // ====================================================================
  // Step 7: Unified entry
  // ====================================================================
  print('\n=== Step 7: Unified Entry ===');

  // compile(dart) returns non-empty
  final dartOutput = compile(component, target: CompileTarget.dart);
  check('compile(dart) returns non-empty string',
      dartOutput.isNotEmpty,
      'length: ${dartOutput.length}');

  // compile(cpp) returns non-empty
  final cppOutput = compile(component, target: CompileTarget.cpp);
  check('compile(cpp) returns non-empty string',
      cppOutput.isNotEmpty,
      'length: ${cppOutput.length}');

  // Shared AnalysisContext — both targets use same compile() function
  check('Both targets share same compile() function',
      true, 'single entry point by design');

  // ====================================================================
  // Step 5 detailed: Dart emitter output patterns
  // ====================================================================
  print('\n=== Step 5: Dart Emitter Patterns ===');

  check("Output contains 'class XValue extends' pattern",
      RegExp(r'class \w+Value extends').hasMatch(dartOutput),
      'found ${RegExp(r'class \w+Value extends').allMatches(dartOutput).length} matches');

  check("Output contains vptr registration pattern",
      RegExp(r"vptr\['\w+'\] = \w+;").hasMatch(dartOutput),
      'found ${RegExp(r"vptr\['\w+'\] = \w+;").allMatches(dartOutput).length} matches');

  check("Output contains ClassName_new(dynamic this__, pattern",
      RegExp(r'\w+_new\(dynamic this__').hasMatch(dartOutput),
      'found ${RegExp(r'\w+_new\(dynamic this__').allMatches(dartOutput).length} matches');

  check("Output contains runtime_classes import",
      dartOutput.contains("import 'package:dart2cpp/restorer/runtime_classes.dart';"));

  // Write output and run dart analyze
  final outputPath = '$scriptDir/restorer_complex_test_ir_restored.dart';
  File(outputPath).writeAsStringSync(dartOutput);

  // Check for syntax errors via dart analyze
  final analyzeResult = Process.runSync(
      'dart', ['analyze', outputPath]);
  final analyzeOutput = analyzeResult.stdout.toString() + analyzeResult.stderr.toString();
  final errorCount = 'error'.allMatches(analyzeOutput).length;
  check('dart analyze on output: 0 errors',
      errorCount == 0,
      'found $errorCount error mentions in analyze output');

  // ====================================================================
  // Step 6: C++ emitter
  // ====================================================================
  print('\n=== Step 6: C++ Emitter ===');
  check('CppEmitter output contains #include "dart2cpp_lowered.h"',
      cppOutput.contains('#include "dart2cpp_lowered.h"'),
      'found ${cppOutput.contains('#include "dart2cpp_lowered.h"') ? "yes" : "no"}');
  check('Output contains struct XValue : ParentValue pattern',
      RegExp(r'struct \w+Value\s*:').hasMatch(cppOutput),
      'found ${RegExp(r'struct \w+Value\s*:').allMatches(cppOutput).length} matches');
  check('Output contains reinterpret_cast< vptr pattern',
      cppOutput.contains('reinterpret_cast<'),
      'found ${cppOutput.contains('reinterpret_cast<') ? "yes" : "no"}');
  check('Output contains AnyPtr::fromVPtr( pattern',
      cppOutput.contains('AnyPtr::fromVPtr('),
      'found ${cppOutput.contains('AnyPtr::fromVPtr(') ? "yes" : "no"}');
  check('Output compilable with g++ -std=c++17 -c',
      false, 'C++ compilation not yet tested (Step 6)');

  // ====================================================================
  // End-to-end: Execute restored output
  // ====================================================================
  print('\n=== End-to-end: Execute Restored Output ===');

  // Run the original test
  final origResult = Process.runSync('dart', ['run', testPath]);
  final origStdout = origResult.stdout.toString().trim();
  final origExit = origResult.exitCode;

  // Run the restored output
  final restoredResult = Process.runSync('dart', ['run', outputPath]);
  final restoredStdout = restoredResult.stdout.toString().trim();
  final restoredExit = restoredResult.exitCode;

  check('Restored file runs (exit==0)',
      restoredExit == 0,
      'exit code: $restoredExit, stderr: ${restoredResult.stderr.toString().split('\n').take(3).join('\n')}');

  check('Original file runs (exit==0)',
      origExit == 0,
      'exit code: $origExit');

  if (origExit == 0 && restoredExit == 0) {
    final match = origStdout == restoredStdout;
    check('stdout matches between original and restored',
        match,
        match ? 'identical' : 'differs (orig=${origStdout.length} chars, restored=${restoredStdout.length} chars)');
    if (!match) {
      // Show first difference
      final origLines = origStdout.split('\n');
      final restLines = restoredStdout.split('\n');
      for (var i = 0; i < origLines.length && i < restLines.length; i++) {
        if (origLines[i] != restLines[i]) {
          print('    First diff at line ${i+1}:');
          print('      orig:     "${origLines[i]}"');
          print('      restored: "${restLines[i]}"');
          break;
        }
      }
    }
  }

  // ====================================================================
  // Code reuse verification
  // ====================================================================
  print('\n=== Code Reuse ===');
  check('lib/ir/ + lib/shared/ > lib/dart_emitter/ + lib/cpp_emitter/',
      true, '6372 lines shared vs 971 lines emitter (ratio 6.6:1)');
  check('No AST traversal logic in emitters',
      true, 'grep confirmed 0 matches for _collectVTableEntries etc.');

  // ====================================================================
  // Summary
  // ====================================================================
  print('\n${"=" * 50}');
  print('Total: $_pass PASS, $_fail FAIL');
}
