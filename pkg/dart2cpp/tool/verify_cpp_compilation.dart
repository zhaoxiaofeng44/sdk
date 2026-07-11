#!/usr/bin/env dart
/// C++ 编译验证脚本
/// 验证生成的 C++ 代码能够成功编译
/// 用法: dart tool/verify_cpp_compilation.dart [test_name]
/// 示例: dart tool/verify_cpp_compilation.dart restorer_complex_test

import 'dart:io';

void main(List<String> args) async {
  final testName = args.isNotEmpty ? args[0] : 'restorer_complex_test';
  final cppFile = 'generated/${testName}_restored.cpp';

  if (!File(cppFile).existsSync()) {
    print('❌ C++ 文件不存在: $cppFile');
    print('请先运行: dart tool/convert_all_dual.dart generated');
    exit(1);
  }

  print('🔧 验证 C++ 编译: $testName');
  print('═' * 60);

  // 检查 C++ 编译器
  final gppCheck = await Process.run('which', ['g++']);
  if (gppCheck.exitCode != 0) {
    print('⚠️  未找到 g++ 编译器，跳过编译验证');
    print('请安装 g++: brew install gcc (macOS) 或 apt-get install g++ (Linux)');
    exit(0);
  }

  final gppPath = (gppCheck.stdout as String).trim();
  print('✅ 找到 C++ 编译器: $gppPath');

  // 尝试编译（只编译，不链接）
  print('\n📦 编译 C++ 代码...');
  final outputFile = '/tmp/${testName}_verify.o';

  final compileResult = await Process.run(
    'g++',
    [
      '-std=c++17',
      '-c',  // 只编译，不链接
      '-I', 'lib/platform/cpp',  // 包含头文件路径
      '-Wall',
      '-Wextra',
      '-Wno-unused-parameter',
      '-Wno-unused-variable',
      '-o', outputFile,
      cppFile,
    ],
  );

  if (compileResult.exitCode != 0) {
    print('❌ 编译失败');
    print('\n错误信息:');
    print(compileResult.stderr);
    exit(1);
  }

  print('✅ 编译成功！');

  // 清理临时文件
  if (File(outputFile).existsSync()) {
    File(outputFile).deleteSync();
  }

  print('\n${'═' * 60}');
  print('✅ C++ 代码验证通过！');
  print('生成的 C++ 代码符合 C++17 标准，可以成功编译。');
}
