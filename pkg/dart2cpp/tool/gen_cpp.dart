import 'dart:io';
import 'package:kernel/kernel.dart';
import 'package:dart2cpp/dart_to_cpp.dart';

void main(List<String> args) async {
  final testName = args.isNotEmpty ? args[0] : 'restorer_complex_test';
  final dillPath = '/tmp/${testName}_gen.dill';

  final result = await Process.run('dart', [
    'compile', 'kernel',
    '--packages=.dart_tool/package_config.json',
    '-o', dillPath,
    'test/${testName}.dart'
  ]);
  if (result.exitCode != 0) {
    print('Dart compile failed: ${result.stderr}');
    return;
  }
  final component = loadComponentFromBinary(dillPath);
  final cpp = emitCppFromComponent(component);
  File('/tmp/${testName}_verify.cpp').writeAsStringSync(cpp);
  print('Written ${cpp.length} chars to /tmp/${testName}_verify.cpp');
}
