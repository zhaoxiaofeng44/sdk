// Regenerate a `*_restored.dart` file from a kernel `.dill` produced by
// `dart compile kernel <test>.dart -o <test>.dill`.
//
// Usage: dart run tool/regen_restored.dart [--multi] <baseName>
//   where <baseName> matches `test/<baseName>.dart`; writes to
//   `test/<baseName>_restored.dart`.
//   --multi: 多文件模式，每个源文件生成独立的输出文件

import 'dart:io';
import 'package:kernel/kernel.dart' as k;
import '../lib/dart_to_dart_restorer.dart';

Future<void> main(List<String> args) async {
  if (args.isEmpty) {
    stderr.writeln('usage: dart run tool/regen_restored.dart [--multi] <baseName>');
    exit(2);
  }

  final isMulti = args.first == '--multi';
  final base = isMulti ? args[1] : args.first;
  final scriptDir = File(Platform.script.toFilePath()).parent.parent.path;
  final srcPath = '$scriptDir/test/$base.dart';
  final dillPath = '/tmp/${base}_regen.dill';
  final outPath = '$scriptDir/test/${base}_restored.dart';

  if (!File(srcPath).existsSync()) {
    stderr.writeln('source not found: $srcPath');
    exit(2);
  }

  // Allow overriding the dart executable via environment variable for in-repo
  // SDK builds; otherwise fall back to the system dart.
  final dartExe = Platform.environment['DART_SDK_BIN'] ??
      Platform.resolvedExecutable;
  stdout.writeln('compiling $srcPath -> $dillPath');
  stdout.writeln('  using: $dartExe');
  final compile = await Process.run(
    dartExe,
    ['compile', 'kernel', srcPath, '-o', dillPath],
  );
  if (compile.exitCode != 0) {
    stderr.writeln('dart compile kernel failed (exit=${compile.exitCode}):');
    stderr.writeln(compile.stderr);
    exit(compile.exitCode);
  }

  stdout.writeln('reading kernel and restoring');
  final component = k.loadComponentFromBinary(dillPath);

  if (isMulti) {
    stdout.writeln('multi-file mode enabled');
    final results = restoreMultiFileFromComponent(component);
    final outDir = '$scriptDir/test/';
    for (final entry in results.entries) {
      final filePath = '$outDir${entry.key}';
      File(filePath).writeAsStringSync(entry.value);
      stdout.writeln('wrote $filePath (${entry.value.length} chars)');
    }
    stdout.writeln('total: ${results.length} files generated');
  } else {
    final restored = restoreDartFromComponent(component);
    File(outPath).writeAsStringSync(restored);
    stdout.writeln('wrote $outPath (${restored.length} chars)');
  }
}
