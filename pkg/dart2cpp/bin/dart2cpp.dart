#!/usr/bin/env dart

import 'dart:io';
import 'package:args/args.dart';
import '../lib/unified_compiler.dart';
import '../lib/optimizers/exceptions.dart';

const String _version = '2.0.0';
const List<String> _supportedFeatures = [
  'Basic type conversion (int, double, String, bool)',
  'Arithmetic operators (+, -, *, /, %)',
  'Comparison operators (==, !=, <, <=, >, >=)',
  'Logical operators (&&, ||, !)',
  'Variable declarations',
  'Function definitions',
  'Class definitions',
  'Control flow (if/else, for, while)',
  'String operations',
  'Collection literals (List, Map, Set)',
  'Method calls',
  'Field access',
  'Basic inheritance',
  'try-catch blocks',
];

void main(List<String> arguments) async {
  final parser = ArgParser()
    ..addOption('output', abbr: 'o', help: 'Output C++ file path')
    ..addFlag('help', abbr: 'h', help: 'Show usage help', negatable: false)
    ..addFlag('verbose', abbr: 'v', help: 'Verbose output', negatable: false)
    ..addFlag('no-runtime',
        help: 'Do not include runtime library', negatable: false)
    ..addFlag('optimize', help: 'Enable optimizations', negatable: false)
    ..addFlag('version', help: 'Show version information', negatable: false)
    ..addFlag('features', help: 'Show supported features', negatable: false);

  try {
    final results = parser.parse(arguments);

    if (results['help'] as bool) {
      _printUsage(parser);
      exit(0);
    }

    if (results['version'] as bool) {
      print('dart2cpp v$_version');
      print('Dart to C++ Compiler');
      exit(0);
    }

    if (results['features'] as bool) {
      print('Supported Dart Features:');
      for (final feature in _supportedFeatures) {
        print('  • $feature');
      }
      exit(0);
    }

    if (results.rest.isEmpty) {
      print('Error: No input file specified');
      print('');
      _printUsage(parser);
      exit(1);
    }

    final inputPath = results.rest[0];
    final inputFile = File(inputPath);

    if (!inputFile.existsSync()) {
      print('Error: Input file not found: $inputPath');
      exit(1);
    }

    String outputPath;
    if (results['output'] != null) {
      outputPath = results['output'] as String;
    } else {
      outputPath = inputPath.replaceAll('.dart', '.cpp');
    }

    final verbose = results['verbose'] as bool;
    final includeRuntime = !(results['no-runtime'] as bool);
    final optimize = results['optimize'] as bool;

    if (verbose) {
      print('Dart to C++ Compiler v$_version');
      print('Input: $inputPath');
      print('Output: $outputPath');
      print('Include runtime: $includeRuntime');
      print('Optimize: $optimize');
      print('');
    }

    // 使用统一编译器API
    if (verbose) print('Compiling Dart to C++...');

    try {
      final result = await UnifiedCompiler.compileFile(
        inputPath,
        config: CompilerConfig(
          outputPath: outputPath,
          includeRuntime: includeRuntime,
          optimize: optimize,
          verbose: verbose,
          generateDartOutput: false,
        ),
      );

      if (verbose) {
        print('Compilation completed successfully!');
        result.printSummary(verbose: verbose);
      }

      if (result.isSuccess) {
        print('✅ Successfully compiled $inputPath to $outputPath');
      } else {
        print('❌ Compilation completed with errors:');
        for (final error in result.errors) {
          print('  • $error');
        }
        exit(1);
      }
    } catch (e) {
      if (e is Dart2CppException) {
        print('❌ Compilation error: ${e.message}');
      } else {
        print('❌ Unexpected error: $e');
      }
      exit(1);
    }
  } catch (e) {
    print('Error: $e');
    exit(1);
  }
}

void _printUsage(ArgParser parser) {
  print('Dart to C++ Compiler v$_version');
  print('');
  print('Usage: dart2cpp [options] <input.dart>');
  print('');
  print('Options:');
  print(parser.usage);
  print('');
  print('Examples:');
  print('  dart2cpp hello.dart');
  print('  dart2cpp -o output.cpp hello.dart');
  print('  dart2cpp --optimize --verbose hello.dart');
  print('  dart2cpp --no-runtime hello.dart');
  print('');
  print('For more information, visit: https://github.com/dart-lang/dart2cpp');
}
