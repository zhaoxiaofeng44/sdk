#!/usr/bin/env dart
/// Check what method-level specializations are collected.
import 'dart:io';
import 'package:kernel/kernel.dart';
import 'package:front_end/src/api_unstable/vm.dart' show CompilerOptions, StandardFileSystem;
import 'package:front_end/src/api_prototype/kernel_generator.dart' show kernelForProgram;
import 'package:dart2cpp/shared/shared.dart';

const _sdk = '/Users/tbsg/Project/MyProject/sdk/mydart/sdk/xcodebuild/DebugX64/dart-sdk/lib/_internal/vm_platform_strong.dill';

Future<void> main() async {
  final opts = CompilerOptions()..sdkSummary = Uri.file(_sdk)..fileSystem = StandardFileSystem.instance;
  final scriptDir = File(Platform.script.toFilePath()).parent.path;
  final result = await kernelForProgram(Uri.file('$scriptDir/restorer_complex_test.dart'), opts);
  final component = result!.component!;
  final ctx = AnalysisContext();
  ClassInfoCollector(ctx).collect(component);
  VTableBuilder(ctx).build();
  GenericSpecializationScanner(ctx).scan(component);

  print('=== Method Type Specializations ===');
  for (final entry in ctx.methodTypeSpecializations.entries) {
    print('Class: ${entry.key}');
    for (final method in entry.value.entries) {
      print('  Method: ${method.key}');
      for (final spec in method.value) {
        print('    suffix=${spec.vptrSuffix}, typeArgs=${spec.typeArgStrs}');
      }
    }
  }

  print('\n=== Pair VTable ===');
  for (final e in ctx.classVTableEntries['Pair'] ?? []) {
    print('  ${e.name} (${e.kind}) → ${e.staticFuncName}');
  }
}
