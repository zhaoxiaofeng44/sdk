#!/usr/bin/env dart
/// C++ 生成器：将 Dart 源码编译为 C++
///
/// 用法: dart tool/convert_dual.dart <source.dart> <output_dir> [--single]
/// 示例: dart tool/convert_dual.dart sample/src/hello.dart sample/output
///
/// 默认多文件模式：入口文件 import 的每个本地文件 / package: 库各生成一个
/// .cpp，外加共享声明头文件 <program>.h 与构建脚本 build.sh。
/// --single：退化为旧版单 .cpp 输出（<output_dir>/<basename>.cpp）。

import 'dart:io';
import 'package:kernel/kernel.dart' as k;
import '../lib/dart_to_cpp.dart';

void main(List<String> args) {
  final singleFile = args.contains('--single');
  // --packages=<file>：透传给 kernel 编译，用于解析 package: 导入
  String? packagesFile;
  for (final a in args) {
    if (a.startsWith('--packages=')) packagesFile = a.substring('--packages='.length);
  }
  final positional = args
      .where((a) => !a.startsWith('--'))
      .toList();

  if (positional.length != 2) {
    stderr.writeln(
        '用法: dart tool/convert_dual.dart <source.dart> <output_dir> [--single] [--packages=<package_config.json>]');
    exit(1);
  }

  final srcPath = positional[0];
  final outDir = positional[1];

  if (!File(srcPath).existsSync()) {
    stderr.writeln('源文件不存在: $srcPath');
    exit(1);
  }

  // 创建输出目录
  final dir = Directory(outDir);
  if (!dir.existsSync()) {
    dir.createSync(recursive: true);
  }

  final basename = srcPath.split('/').last.replaceAll('.dart', '');

  print('🔧 编译 $srcPath 到 Kernel...');
  final dillPath = '/tmp/${basename}_dual.dill';
  final dartExe = Platform.resolvedExecutable;

  final kernelArgs = ['compile', 'kernel'];
  if (packagesFile != null) kernelArgs.add('--packages=$packagesFile');
  kernelArgs.addAll([srcPath, '-o', dillPath]);
  final compileResult = Process.runSync(dartExe, kernelArgs);

  if (compileResult.exitCode != 0) {
    stderr.writeln('编译失败:');
    stderr.writeln(compileResult.stderr);
    exit(1);
  }
  print('✅ 编译成功');

  print('📦 加载 Kernel...');
  final component = k.loadComponentFromBinary(dillPath);
  print('✅ 加载成功');

  // 运行时头文件目录（相对本工具所在 pkg 根）
  final pkgRoot = File(Platform.script.toFilePath()).parent.parent.path;
  final runtimeDir = '$pkgRoot/lib/platform/cpp';

  if (singleFile) {
    print('⚙️  生成 C++（单文件模式）...');
    final cppSource = emitCppFromComponent(component);
    final cppOutputPath = '$outDir/${basename}.cpp';
    File(cppOutputPath).writeAsStringSync(cppSource);
    print('✅ C++: $cppOutputPath '
        '(${cppSource.length} 字符, ${cppSource.split('\n').length} 行)');
    return;
  }

  print('⚙️  生成 C++（多文件模式）...');
  final result = emitCppFilesFromComponent(
    component,
    outDir,
    runtimeIncludeDir: runtimeDir,
  );
  print('✅ 头文件: ${result.headerPath}');
  for (final cpp in result.cppPaths) {
    final lines = File(cpp).readAsLinesSync().length;
    final marker = cpp == result.entryCppPath ? '  (入口, 含 main)' : '';
    print('✅ C++: $cpp ($lines 行)$marker');
  }
  if (result.buildScriptPath != null) {
    print('✅ 构建脚本: ${result.buildScriptPath}');
    print('');
    print('编译运行: bash ${result.buildScriptPath} && '
        '${outDir}/${File(result.entryCppPath).uri.pathSegments.last.replaceAll('.cpp', '')}');
  }
}
