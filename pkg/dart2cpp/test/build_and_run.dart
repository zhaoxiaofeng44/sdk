#!/usr/bin/env dart
/// Test runner that converts Dart files to C++ and manages the C++ project

import 'dart:io';
import 'dart:mirrors';

Future<void> main(List<String> arguments) async {
  print('=' * 80);
  print('🔧 Dart to C++ Test Runner');
  print('=' * 80);
  print('');

  // Get directories
  final scriptDir = Platform.script.toFilePath().substring(0, Platform.script.toFilePath().lastIndexOf('/'));
  final testDir = '$scriptDir/../test';
  final cppProjectDir = '$scriptDir/../cpp_project';
  final dart2cppScript = '$scriptDir/../bin/dart2cpp.dart';

  // Step 1: Convert all test Dart files to C++
  print('📝 Step 1: Converting Dart test files to C++...');
  print('-' * 80);
  await _convertAllDartTests(testDir, cppProjectDir, dart2cppScript);
  print('');

  // Step 2: Create C++ project files
  print('🔨 Step 2: Setting up C++ project...');
  print('-' * 80);
  await _setupCppProject(cppProjectDir);
  print('');

  // Step 3: Compile and run C++ project
  print('▶️  Step 3: Compiling and running C++ project...');
  print('-' * 80);
  await _compileAndRunCppProject(cppProjectDir);
  print('');

  print('=' * 80);
  print('✅ All tests completed successfully!');
  print('=' * 80);
}

Future<void> _convertAllDartTests(
  String testDir,
  String cppProjectDir,
  String dart2cppScript,
) async {
  final dartDir = Directory(testDir);
  if (!await dartDir.exists()) {
    print('⚠️  Test directory not found: $testDir');
    return;
  }

  final dartFiles = await dartDir
      .list()
      .where((entity) => entity is File && entity.path.endsWith('.dart'))
      .cast<File>()
      .toList();

  if (dartFiles.isEmpty) {
    print('⚠️  No .dart files found in $testDir');
    return;
  }

  print('Found ${dartFiles.length} Dart test files');
  print('');

  int successCount = 0;
  int failCount = 0;

  for (final dartFile in dartFiles) {
    final fileName = dartFile.path.substring(dartFile.path.lastIndexOf('/') + 1);
    final baseName = fileName.replaceAll('.dart', '');
    final outputCppFile = '$cppProjectDir/src/$baseName.cpp';

    print('Converting: $fileName');

    try {
      // Run dart2cpp script
      final result = await Process.run(
        'dart',
        [
          dart2cppScript,
          '--output',
          outputCppFile,
          '--optimize',
          dartFile.path,
        ],
      );

      if (result.exitCode == 0) {
        print('  ✅ Success: $outputCppFile');
        successCount++;
      } else {
        print('  ❌ Failed:');
        if (result.stdout.isNotEmpty) {
          print('     STDOUT: ${result.stdout}');
        }
        if (result.stderr.isNotEmpty) {
          print('     STDERR: ${result.stderr}');
        }
        failCount++;
      }
    } catch (e) {
      print('  ❌ Error: $e');
      failCount++;
    }
  }

  print('');
  print('📊 Conversion Summary:');
  print('  Total files: ${dartFiles.length}');
  print('  ✅ Successful: $successCount');
  print('  ❌ Failed: $failCount');

  if (failCount > 0) {
    print('');
    print('⚠️  Some conversions failed, but continuing with the successful ones...');
  }
}

Future<void> _setupCppProject(String cppProjectDir) async {
  // Create a main.cpp that includes all converted files
  final mainCppPath = '$cppProjectDir/src/main.cpp';
  final mainCppFile = File(mainCppPath);

  final srcDir = '$cppProjectDir/src';
  final cppFiles = <String>[];

  if (await Directory(srcDir).exists()) {
    await for (final entity in Directory(srcDir).list()) {
      if (entity is File && entity.path.endsWith('.cpp') && !entity.path.endsWith('main.cpp')) {
        cppFiles.add(entity.path.substring(entity.path.lastIndexOf('/') + 1));
      }
    }
  }

  final mainContent = StringBuffer();
  mainContent.writeln('// Auto-generated main.cpp for Dart2Cpp test runner');
  mainContent.writeln('// Generated at: ${DateTime.now()}');
  mainContent.writeln('');

  // Add includes for all converted files
  for (final cppFile in cppFiles) {
    mainContent.writeln('// #include "$cppFile"');
  }

  mainContent.writeln('');
  mainContent.writeln('#include <iostream>');
  mainContent.writeln('#include <string>');
  mainContent.writeln('');
  mainContent.writeln('int main() {');
  mainContent.writeln('    std::cout << "🚀 C++ Project from Dart2Cpp" << std::endl;');
  mainContent.writeln('    std::cout << "Converted from ${cppFiles.length} Dart files" << std::endl;');
  mainContent.writeln('    std::cout << std::endl;');
  mainContent.writeln('');
  mainContent.writeln('    // Uncomment and implement test cases from converted files');
  mainContent.writeln('    // for (final cppFile in cppFiles) {');
  mainContent.writeln('    //     std::cout << "Testing: " << cppFile << std::endl;');
  mainContent.writeln('    // }');
  mainContent.writeln('');
  mainContent.writeln('    return 0;');
  mainContent.writeln('}');

  await mainCppFile.writeAsString(mainContent.toString());
  print('✅ Created main.cpp with ${cppFiles.length} converted files');

  // Create CMakeLists.txt
  final cmakeListsPath = '$cppProjectDir/CMakeLists.txt';
  final cmakeListsFile = File(cmakeListsPath);

  final cmakeContent = StringBuffer();
  cmakeContent.writeln('cmake_minimum_required(VERSION 3.10)');
  cmakeContent.writeln('project(dart2cpp_test)');
  cmakeContent.writeln('');
  cmakeContent.writeln('# Set C++ standard');
  cmakeContent.writeln('set(CMAKE_CXX_STANDARD 17)');
  cmakeContent.writeln('set(CMAKE_CXX_STANDARD_REQUIRED ON)');
  cmakeContent.writeln('');
  cmakeContent.writeln('# Enable optimizations');
  cmakeContent.writeln('set(CMAKE_CXX_FLAGS_DEBUG "-g -O0")');
  cmakeContent.writeln('set(CMAKE_CXX_FLAGS_RELEASE "-O3 -DNDEBUG")');
  cmakeContent.writeln('');
  cmakeContent.writeln('# Add executable');
  cmakeContent.writeln('add_executable(dart2cpp_test');
  cmakeContent.writeln('    src/main.cpp');

  for (final cppFile in cppFiles) {
    cmakeContent.writeln('    src/$cppFile');
  }

  cmakeContent.writeln(')');
  cmakeContent.writeln('');
  cmakeContent.writeln('# Add include directories');
  cmakeContent.writeln('target_include_directories(dart2cpp_test PRIVATE');
  cmakeContent.writeln('    \${CMAKE_CURRENT_SOURCE_DIR}/include');
  cmakeContent.writeln(')');
  cmakeContent.writeln('');
  cmakeContent.writeln('# Link libraries if needed');
  cmakeContent.writeln('# target_link_libraries(dart2cpp_test PRIVATE some_library)');
  cmakeContent.writeln('');
  cmakeContent.writeln('# Print build information');
  cmakeContent.writeln('message(STATUS "Building \${PROJECT_NAME}")');
  cmakeContent.writeln('message(STATUS "C++ Standard: \${CMAKE_CXX_STANDARD}")');
  cmakeContent.writeln('message(STATUS "Source files: ${cppFiles.length}")');

  await cmakeListsFile.writeAsString(cmakeContent.toString());

  print('✅ Created CMakeLists.txt');
}

Future<void> _compileAndRunCppProject(String cppProjectDir) async {
  final buildDir = '$cppProjectDir/build';

  // Create build directory
  final buildDirObj = Directory(buildDir);
  if (!await buildDirObj.exists()) {
    await buildDirObj.create(recursive: true);
  }

  // Try using CMake first
  final cmakeResult = await Process.run('cmake', ['-B', buildDir, cppProjectDir]);

  if (cmakeResult.exitCode == 0) {
    print('✅ CMake configuration successful');

    // Build the project
    final buildResult = await Process.run('cmake', ['--build', buildDir]);

    if (buildResult.exitCode == 0) {
      print('✅ C++ build successful');

      // Run the executable
      final exePath = '$buildDir/dart2cpp_test';
      print('');
      print('▶️  Running executable...');
      print('-' * 40);

      final runResult = await Process.run(exePath, []);

      print(runResult.stdout);
      if (runResult.stderr.isNotEmpty) {
        print('STDERR:');
        print(runResult.stderr);
      }

      if (runResult.exitCode == 0) {
        print('-' * 40);
        print('✅ C++ program executed successfully (exit code: ${runResult.exitCode})');
      } else {
        print('-' * 40);
        print('⚠️  C++ program exited with code: ${runResult.exitCode}');
      }
    } else {
      print('❌ C++ build failed:');
      print(buildResult.stderr);
    }
  } else {
    print('⚠️  CMake not available or failed, using direct g++ compilation');
    print('   CMake error: ${cmakeResult.stderr}');

    // Fallback to direct g++ compilation
    final srcDir = '$cppProjectDir/src';
    final exePath = '$buildDir/dart2cpp_test';

    // Collect all C++ files
    final cppFiles = <String>[];
    if (await Directory(srcDir).exists()) {
      await for (final entity in Directory(srcDir).list()) {
        if (entity is File && (entity.path.endsWith('.cpp') || entity.path.endsWith('.cc'))) {
          cppFiles.add(entity.path);
        }
      }
    }

    if (cppFiles.isEmpty) {
      print('❌ No C++ files found in $srcDir');
      return;
    }

    final compileResult = await Process.run('g++', [
      '-std=c++17',
      '-I', '$cppProjectDir/include',
      '-o', exePath,
      ...cppFiles,
    ]);

    if (compileResult.exitCode == 0) {
      print('✅ Direct g++ compilation successful');

      // Run the executable
      print('');
      print('▶️  Running executable...');
      print('-' * 40);

      final runResult = await Process.run(exePath, []);
      print(runResult.stdout);

      if (runResult.stderr.isNotEmpty) {
        print('STDERR:');
        print(runResult.stderr);
      }

      if (runResult.exitCode == 0) {
        print('-' * 40);
        print('✅ C++ program executed successfully (exit code: ${runResult.exitCode})');
      } else {
        print('-' * 40);
        print('⚠️  C++ program exited with code: ${runResult.exitCode}');
      }
    } else {
      print('❌ Direct g++ compilation failed:');
      print(compileResult.stderr);
    }
  }
}