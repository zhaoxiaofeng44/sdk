#!/usr/bin/env dart
// Convert a Dart source file to lowered Dart
// Usage: dart tool/convert_sample.dart <source.dart> <output.dart>

import 'dart:io';
import 'package:kernel/kernel.dart' as k;
import '../lib/dart_to_dart_restorer.dart';

void main(List<String> args) {
  if (args.length != 2) {
    stderr.writeln('Usage: dart tool/convert_sample.dart <source.dart> <output.dart>');
    exit(1);
  }

  final srcPath = args[0];
  final outPath = args[1];

  if (!File(srcPath).existsSync()) {
    stderr.writeln('Source file not found: $srcPath');
    exit(1);
  }

  // Use in-repo dart SDK if available
  const inRepoDart = '/Users/tbsg/Project/MyProject/sdk/mydart/sdk/xcodebuild/DebugX64/dart-sdk/bin/dart';
  final dartExe = File(inRepoDart).existsSync() ? inRepoDart : Platform.resolvedExecutable;

  // Compile to kernel
  final dillPath = '/tmp/${basename(srcPath)}_convert.dill';
  stdout.writeln('Compiling $srcPath -> $dillPath');

  final compileResult = Process.runSync(
    dartExe,
    ['compile', 'kernel', srcPath, '-o', dillPath],
  );

  if (compileResult.exitCode != 0) {
    stderr.writeln('Compilation failed:');
    stderr.writeln(compileResult.stderr);
    exit(compileResult.exitCode);
  }

  // Convert to lowered Dart
  stdout.writeln('Converting to lowered Dart...');
  try {
    final component = k.loadComponentFromBinary(dillPath);
    final restored = restoreDartFromComponent(component);
    File(outPath).writeAsStringSync(restored);
    stdout.writeln('✓ Converted: $outPath (${restored.length} chars)');
  } catch (e, st) {
    stderr.writeln('Conversion failed: $e');
    stderr.writeln(st);
    exit(1);
  }
}

String basename(String path) {
  final parts = path.split(Platform.pathSeparator);
  final filename = parts.last;
  return filename.replaceAll('.dart', '');
}
