#!/usr/bin/env dart

/// Comprehensive Test Runner
///
/// This script runs all comprehensive tests for the dart2cpp transpiler.
/// It converts Dart test files to C++, compiles them, and runs them.

import 'dart:io';

void main() async {
  print('╔════════════════════════════════════════════════════════════╗');
  print('║     Dart2CPP Comprehensive Test Suite Runner              ║');
  print('╚════════════════════════════════════════════════════════════╝\n');

  final testFiles = [
    'comprehensive_syntax_test.dart',
    'advanced_features_test.dart',
  ];

  int totalTests = 0;
  int passedTests = 0;
  int failedTests = 0;

  final results = <String, TestResult>{};

  for (final testFile in testFiles) {
    print('═' * 60);
    print('Running: $testFile');
    print('═' * 60);

    final result = await runTest(testFile);
    results[testFile] = result;

    if (result.success) {
      passedTests++;
      print('✅ PASSED\n');
    } else {
      failedTests++;
      print('❌ FAILED\n');
      if (result.error != null) {
        print('Error: ${result.error}\n');
      }
    }

    totalTests++;
  }

  // Print summary
  print('\n');
  print('╔════════════════════════════════════════════════════════════╗');
  print('║                    TEST SUMMARY                            ║');
  print('╚════════════════════════════════════════════════════════════╝');
  print('');
  print('Total Tests:  $totalTests');
  print('Passed:       $passedTests ✅');
  print('Failed:       $failedTests ❌');
  print('Success Rate: ${(passedTests / totalTests * 100).toStringAsFixed(1)}%');
  print('');

  // Detailed results
  print('╔════════════════════════════════════════════════════════════╗');
  print('║                  DETAILED RESULTS                          ║');
  print('╚════════════════════════════════════════════════════════════╝');
  print('');

  for (final entry in results.entries) {
    final status = entry.value.success ? '✅ PASS' : '❌ FAIL';
    print('$status - ${entry.key}');

    if (entry.value.dartSuccess) {
      print('  ├─ Dart execution: ✅');
    } else {
      print('  ├─ Dart execution: ❌');
    }

    if (entry.value.cppCompileSuccess) {
      print('  ├─ C++ compilation: ✅');
    } else {
      print('  ├─ C++ compilation: ❌');
    }

    if (entry.value.cppRunSuccess) {
      print('  └─ C++ execution: ✅');
    } else {
      print('  └─ C++ execution: ❌');
    }

    if (entry.value.error != null) {
      print('     Error: ${entry.value.error}');
    }
    print('');
  }

  // Exit with appropriate code
  exit(failedTests == 0 ? 0 : 1);
}

Future<TestResult> runTest(String testFile) async {
  final result = TestResult();

  try {
    // Step 1: Run Dart version
    print('Step 1: Running Dart version...');
    final dartResult = await runDartTest(testFile);
    result.dartSuccess = dartResult;

    if (!dartResult) {
      result.success = false;
      result.error = 'Dart execution failed';
      return result;
    }

    // Step 2: Convert to C++
    print('Step 2: Converting to C++...');
    final cppFile = await convertToCpp(testFile);

    if (cppFile == null) {
      result.success = false;
      result.error = 'Conversion to C++ failed';
      return result;
    }

    // Step 3: Compile C++
    print('Step 3: Compiling C++...');
    final executable = await compileCpp(cppFile);
    result.cppCompileSuccess = executable != null;

    if (executable == null) {
      result.success = false;
      result.error = 'C++ compilation failed';
      return result;
    }

    // Step 4: Run C++ version
    print('Step 4: Running C++ version...');
    final cppRunResult = await runCppExecutable(executable);
    result.cppRunSuccess = cppRunResult;

    if (!cppRunResult) {
      result.success = false;
      result.error = 'C++ execution failed';
      return result;
    }

    result.success = true;
  } catch (e) {
    result.success = false;
    result.error = e.toString();
  }

  return result;
}

Future<bool> runDartTest(String testFile) async {
  try {
    final testPath = 'test/$testFile';

    if (!File(testPath).existsSync()) {
      print('  ⚠️  Test file not found: $testPath');
      return false;
    }

    final result = await Process.run('dart', [testPath]);

    if (result.exitCode == 0) {
      print('  ✅ Dart execution successful');
      return true;
    } else {
      print('  ❌ Dart execution failed');
      print('  Output: ${result.stdout}');
      print('  Error: ${result.stderr}');
      return false;
    }
  } catch (e) {
    print('  ❌ Error running Dart test: $e');
    return false;
  }
}

Future<String?> convertToCpp(String testFile) async {
  try {
    final testPath = 'test/$testFile';
    final cppFile = testPath.replaceAll('.dart', '.cpp');

    final result = await Process.run('dart', [
      'bin/dart2cpp.dart',
      testPath,
      '-o',
      cppFile,
    ]);

    if (result.exitCode == 0) {
      print('  ✅ Conversion successful: $cppFile');
      return cppFile;
    } else {
      print('  ❌ Conversion failed');
      print('  Output: ${result.stdout}');
      print('  Error: ${result.stderr}');
      return null;
    }
  } catch (e) {
    print('  ❌ Error converting to C++: $e');
    return null;
  }
}

Future<String?> compileCpp(String cppFile) async {
  try {
    final executable = cppFile.replaceAll('.cpp', '.out');

    final result = await Process.run('g++', [
      '-std=c++17',
      '-I./cpp/core',
      cppFile,
      'cpp/core/object.cpp',
      '-o',
      executable,
    ]);

    if (result.exitCode == 0) {
      print('  ✅ Compilation successful: $executable');
      return executable;
    } else {
      print('  ❌ Compilation failed');
      print('  Output: ${result.stdout}');
      print('  Error: ${result.stderr}');
      return null;
    }
  } catch (e) {
    print('  ❌ Error compiling C++: $e');
    return null;
  }
}

Future<bool> runCppExecutable(String executable) async {
  try {
    final result = await Process.run('./$executable', []);

    if (result.exitCode == 0) {
      print('  ✅ C++ execution successful');
      return true;
    } else {
      print('  ❌ C++ execution failed');
      print('  Output: ${result.stdout}');
      print('  Error: ${result.stderr}');
      return false;
    }
  } catch (e) {
    print('  ❌ Error running C++ executable: $e');
    return false;
  }
}

class TestResult {
  bool success = false;
  bool dartSuccess = false;
  bool cppCompileSuccess = false;
  bool cppRunSuccess = false;
  String? error;
}
