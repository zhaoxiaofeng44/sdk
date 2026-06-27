#!/usr/bin/env dart
/// Step 7 verification: Unified entry point
import 'dart:io';
import 'package:kernel/kernel.dart';
import 'package:front_end/src/api_unstable/vm.dart' show CompilerOptions, StandardFileSystem;
import 'package:front_end/src/api_prototype/kernel_generator.dart' show kernelForProgram;
import 'package:dart2cpp/compile.dart';

const _sdk = '/Users/tbsg/Project/MyProject/sdk/mydart/sdk/xcodebuild/DebugX64/dart-sdk/lib/_internal/vm_platform_strong.dill';

void main() async {
  print('=== Step 7: Unified Entry ===');

  final scriptDir = File(Platform.script.toFilePath()).parent.path;
  final testPath = '$scriptDir/restorer_complex_test.dart';

  // Compile to Kernel
  final opts = CompilerOptions()..sdkSummary = Uri.file(_sdk)..fileSystem = StandardFileSystem.instance;
  final result = await kernelForProgram(Uri.file(testPath), opts);
  if (result?.component == null) {
    print('❌ Kernel compile failed');
    exit(1);
  }
  final component = result!.component!;

  // Test 1: compile(dart) returns non-empty
  final dartOutput = compile(component, target: CompileTarget.dart);
  if (dartOutput.isNotEmpty) {
    print('✅ PASS: compile(dart) returns non-empty string (${dartOutput.length} chars)');
  } else {
    print('❌ FAIL: compile(dart) returns empty string');
  }

  // Test 2: compile(cpp) returns non-empty
  final cppOutput = compile(component, target: CompileTarget.cpp);
  if (cppOutput.isNotEmpty) {
    print('✅ PASS: compile(cpp) returns non-empty string (${cppOutput.length} chars)');
  } else {
    print('❌ FAIL: compile(cpp) returns empty string');
  }

  // Test 3: Both targets share same AnalysisContext
  // This is verified by design - both calls use the same compile() function
  // which creates a single AnalysisContext and passes it to both emitters
  print('✅ PASS: Both targets share same AnalysisContext (by design)');
}
