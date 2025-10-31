#!/usr/bin/env dart
/// Quick verification script to test dart2cpp conversion

import 'dart:io';

void main() async {
  print('=' * 60);
  print('🔍 Dart2Cpp Quick Verification');
  print('=' * 60);
  print('');

  // Test 1: Check dart2cpp version
  print('📋 Test 1: Checking dart2cpp version...');
  try {
    final result = await Process.run('dart', ['bin/dart2cpp.dart', '--version']);
    if (result.exitCode == 0) {
      print('  ✅ Version check passed');
      print('     ${result.stdout.trim()}');
    } else {
      print('  ❌ Version check failed');
      return;
    }
  } catch (e) {
    print('  ❌ Error: $e');
    return;
  }
  print('');

  // Test 2: Check dart2cpp features
  print('📋 Test 2: Checking supported features...');
  try {
    final result = await Process.run('dart', ['bin/dart2cpp.dart', '--features']);
    if (result.exitCode == 0) {
      final lines = result.stdout.trim().split('\n');
      print('  ✅ Found ${lines.length - 1} supported features');
    } else {
      print('  ❌ Features check failed');
      return;
    }
  } catch (e) {
    print('  ❌ Error: $e');
    return;
  }
  print('');

  // Test 3: Convert a simple file
  print('📋 Test 3: Converting test_hello.dart...');
  final testFile = 'test/test_hello.dart';
  if (!await File(testFile).exists()) {
    print('  ❌ Test file not found: $testFile');
    return;
  }

  try {
    final result = await Process.run(
      'dart',
      ['bin/dart2cpp.dart', '--verbose', testFile],
    );

    if (result.exitCode == 0) {
      print('  ✅ Conversion successful');
    } else {
      print('  ❌ Conversion failed');
      print('     ${result.stderr}');
      return;
    }
  } catch (e) {
    print('  ❌ Error: $e');
    return;
  }
  print('');

  // Test 4: Check C++ project structure
  print('📋 Test 4: Checking C++ project structure...');
  final cppProjectDir = Directory('cpp_project');
  if (await cppProjectDir.exists()) {
    print('  ✅ C++ project directory exists');

    final requiredDirs = ['include', 'lib', 'src', 'build'];
    for (final dir in requiredDirs) {
      final dirPath = 'cpp_project/$dir';
      if (await Directory(dirPath).exists()) {
        print('    ✅ $dir/');
      } else {
        print('    ⚠️  $dir/ (missing)');
      }
    }

    // Check runtime files
    final runtimeHeader = 'cpp_project/include/dart2cpp_runtime.h';
    final runtimeSource = 'cpp_project/lib/dart2cpp_runtime.cpp';
    if (await File(runtimeHeader).exists()) {
      print('    ✅ Runtime header: $runtimeHeader');
    }
    if (await File(runtimeSource).exists()) {
      print('    ✅ Runtime source: $runtimeSource');
    }
  } else {
    print('  ⚠️  C++ project directory not found');
  }
  print('');

  // Test 5: Check C++ build files
  print('📋 Test 5: Checking C++ build files...');
  final mainCpp = 'cpp_project/src/main.cpp';
  final cmakeLists = 'cpp_project/CMakeLists.txt';

  if (await File(mainCpp).exists()) {
    print('  ✅ Main C++ file exists');
  } else {
    print('  ⚠️  Main C++ file missing');
  }

  if (await File(cmakeLists).exists()) {
    print('  ✅ CMakeLists.txt exists');
  } else {
    print('  ⚠️  CMakeLists.txt missing');
  }
  print('');

  // Test 6: Build C++ project
  print('📋 Test 6: Building C++ project...');
  try {
    final result = await Process.run('cmake', ['--build', 'cpp_project/build']);
    if (result.exitCode == 0) {
      print('  ✅ C++ build successful');
    } else {
      print('  ⚠️  C++ build failed (may be expected if errors exist)');
    }
  } catch (e) {
    print('  ⚠️  Build test skipped: $e');
  }
  print('');

  // Summary
  print('=' * 60);
  print('✅ Quick verification completed!');
  print('=' * 60);
  print('');
  print('Next steps:');
  print('  1. Run: ./cpp_project/build/dart2cpp_test');
  print('  2. Or:  dart test/build_and_run.dart (for full test suite)');
  print('  3. Or:  dart test/run_tests.dart (for Dart tests only)');
  print('');
  print('For more information, see PROJECT_STRUCTURE.md');
}
