#!/usr/bin/env dart
/// 多文件 / 多 package C++ 发射测试驱动。
///
/// 每个用例是一个目录，内含入口 entry.dart（可 import 本地文件或 package:）。
/// 流程：
///   1. `dart run` 入口，记录 Dart VM 期望输出；
///   2. `dart compile kernel` 生成 dill；
///   3. emitCppFilesFromComponent 逐库生成 .cpp + 共享头 + build.sh；
///   4. clang++ 编译并链接全部 .cpp；
///   5. 运行二进制，过滤运行时诊断行后与期望输出逐行比对。
import 'dart:io';
import 'package:kernel/kernel.dart';

import '../lib/dart_to_cpp.dart';

/// 运行时诊断行（退出时 GC 统计），比对前过滤
bool _isRuntimeDiag(String line) =>
    line.startsWith('[GC:exit]') || line.contains('MallocStackLogging');

/// 过滤诊断行并去掉尾部空行
List<String> _normalize(String out) {
  final lines = out.split('\n').where((l) => !_isRuntimeDiag(l)).toList();
  while (lines.isNotEmpty && lines.last.trim().isEmpty) {
    lines.removeLast();
  }
  return lines;
}

class _Case {
  final String name;
  final String dir; // 相对 pkg/dart2cpp 的用例目录
  final String entry; // 入口文件名
  final String? packagesFile; // 可选 package_config.json 路径（相对用例目录）
  _Case(this.name, this.dir, this.entry, {this.packagesFile});
}

final List<_Case> _cases = [
  _Case('multifile_basic', 'test/multifile/basic', 'entry.dart'),
  _Case('multifile_pkgcase', 'test/multifile/pkgcase', 'entry.dart',
      packagesFile: 'package_config.json'),
];

Future<bool> _runCase(_Case c, String pkgRoot, String dartExe) async {
  print('\n${'─' * 60}');
  print('📦 多文件用例: ${c.name}');

  final caseDir = '${pkgRoot}/${c.dir}';
  final entryPath = '$caseDir/${c.entry}';
  final dillPath = '/tmp/${c.name}.dill';
  final outDir = '/tmp/${c.name}_out';

  // 期望输出（Dart VM）
  final runArgs = <String>[];
  if (c.packagesFile != null) {
    runArgs.add('--packages=$caseDir/${c.packagesFile}');
  }
  final vmRun = await Process.run(dartExe, [...runArgs, entryPath]);
  if (vmRun.exitCode != 0) {
    print('  ❌ Dart VM 运行失败: ${vmRun.stderr}');
    return false;
  }
  final expected = _normalize(vmRun.stdout as String);

  // 1. Kernel 编译
  final kernelArgs = ['compile', 'kernel'];
  if (c.packagesFile != null) {
    kernelArgs.add('--packages=$caseDir/${c.packagesFile}');
  }
  kernelArgs.addAll([entryPath, '-o', dillPath]);
  final kc = await Process.run(dartExe, kernelArgs);
  if (kc.exitCode != 0) {
    print('  ❌ Kernel 编译失败: ${kc.stderr}');
    return false;
  }
  print('  ✅ Kernel 编译成功');

  // 2. 多文件 C++ 生成
  Component component;
  try {
    component = loadComponentFromBinary(dillPath);
  } catch (e) {
    print('  ❌ Kernel 加载失败: $e');
    return false;
  }
  CppEmissionResult emitted;
  try {
    emitted = emitCppFilesFromComponent(component, outDir,
        runtimeIncludeDir: '$pkgRoot/lib/platform/cpp');
  } catch (e, st) {
    print('  ❌ C++ 生成异常: $e\n$st');
    return false;
  }
  print('  ✅ 生成 ${emitted.cppPaths.length} 个 .cpp + 头文件');
  print('     header: ${emitted.headerPath}');
  for (final p in emitted.cppPaths) {
    print('     cpp:    $p');
  }

  // 3. 编译 + 链接
  final binPath = '$outDir/${c.name}_bin';
  final compileArgs = ['-std=c++17', '-Wno-c99-designator',
      '-I', '$pkgRoot/lib/platform/cpp', '-I', outDir,
      ...emitted.cppPaths, '-o', binPath];
  final cc = await Process.run('clang++', compileArgs);
  if (cc.exitCode != 0) {
    print('  ❌ C++ 编译/链接失败:\n${cc.stderr}');
    return false;
  }
  print('  ✅ C++ 编译链接成功');

  // 4. 运行
  await Process.run('chmod', ['+x', binPath]);
  await Process.run('xattr', ['-cr', binPath]);
  final run = await Process.run(binPath, [], workingDirectory: outDir);
  if (run.exitCode != 0) {
    print('  ❌ 运行失败 (exit ${run.exitCode}):\n${run.stdout}\n${run.stderr}');
    return false;
  }
  final actual = _normalize(run.stdout as String);

  // 5. 比对
  if (expected.length == actual.length &&
      List.generate(expected.length, (i) => expected[i] == actual[i])
          .every((e) => e)) {
    print('  ✅ 输出一致 (${actual.length} 行)');
    return true;
  }
  print('  ❌ 输出不一致');
  print('  --- 期望 (${expected.length} 行) ---');
  expected.forEach((l) => print('    $l'));
  print('  --- 实际 (${actual.length} 行) ---');
  actual.forEach((l) => print('    $l'));
  return false;
}

Future<void> main() async {
  // pkg/dart2cpp 根目录（本脚本位于 test/ 下），规范化路径
  final scriptDir = File(Platform.script.toFilePath()).parent.path;
  final pkgRoot = Directory('$scriptDir/..').resolveSymbolicLinksSync();
  final dartExe = Platform.resolvedExecutable;

  var pass = 0;
  final results = <String, bool>{};
  for (final c in _cases) {
    final ok = await _runCase(c, pkgRoot, dartExe);
    results[c.name] = ok;
    if (ok) pass++;
  }

  print('\n${'=' * 60}');
  print('多文件测试汇总: $pass / ${_cases.length} 通过');
  results.forEach((name, ok) {
    print('  ${ok ? '✅' : '❌'} $name');
  });
  if (pass != _cases.length) exitCode = 1;
}
