import 'dart:io';

void main() async {
  print('正在编译所有sample测试用例并分析错误...\n');

  final dartFiles = Directory('sample/dart')
      .listSync()
      .where((f) => f.path.endsWith('.dart'))
      .toList();

  int total = 0;
  int success = 0;
  int failed = 0;

  final errorMap = <String, List<String>>{};

  for (final dartFile in dartFiles) {
    final filename = dartFile.path.split('/').last.replaceAll('.dart', '');
    final cppFile = 'sample/cpp_generated/$filename.cpp';

    total++;
    stdout.write('[$total/${dartFiles.length}] 编译 $filename... ');

    // 转换为C++
    final dartResult = await Process.run('dart', [
      'bin/dart2cpp.dart',
      dartFile.path,
      cppFile,
    ]);

    if (!dartResult.stdout.toString().contains('Successfully compiled')) {
      print('✗ Dart转C++失败');
      failed++;
      errorMap[filename] = ['Dart转C++失败: ${dartResult.stderr}'];
      continue;
    }

    // C++语法检查
    final clangResult = await Process.run('clang++', [
      '-std=c++17',
      '-I',
      'cpp/core',
      '-fsyntax-only',
      cppFile,
    ]);

    if (clangResult.exitCode != 0) {
      print('✗ C++编译失败');
      failed++;
      errorMap[filename] = clangResult.stderr
          .toString()
          .split('\n')
          .where((line) => line.contains('error:'))
          .take(5)
          .toList();
    } else {
      print('✓ 编译成功');
      success++;
    }
  }

  print('\n${'=' * 60}');
  print('编译统计:');
  print('  总计: $total');
  print('  成功: $success');
  print('  失败: $failed');
  print('${'=' * 60}\n');

  if (errorMap.isNotEmpty) {
    print('错误详情:\n');
    errorMap.forEach((filename, errors) {
      print('【$filename】');
      for (final error in errors) {
        print('  $error');
      }
      print('');
    });
  }

  // 生成Markdown报告
  generateMarkdownReport(total, success, failed, errorMap);
}

void generateMarkdownReport(
  int total,
  int success,
  int failed,
  Map<String, List<String>> errorMap,
) {
  final reportFile = File('SAMPLE_TESTS_ERROR_ANALYSIS_NEW.md');
  final buffer = StringBuffer();

  buffer.writeln('# Sample Tests 错误分析报告');
  buffer.writeln('');
  buffer.writeln('**生成时间**: ${DateTime.now().toString().split('.').first}');
  buffer.writeln('**测试结果**: $success/$total 通过');
  buffer.writeln('');
  buffer.writeln('---');
  buffer.writeln('');
  buffer.writeln('## 测试统计');
  buffer.writeln('');
  buffer.writeln('| 指标 | 数量 |');
  buffer.writeln('|------|------|');
  buffer.writeln('| 总计 | $total |');
  buffer.writeln('| 成功 | $success |');
  buffer.writeln('| 失败 | $failed |');
  buffer.writeln('| 通过率 | ${((success / total) * 100).toStringAsFixed(1)}% |');
  buffer.writeln('');
  buffer.writeln('---');
  buffer.writeln('');

  if (errorMap.isNotEmpty) {
    buffer.writeln('## 失败的测试用例');
    buffer.writeln('');

    int index = 1;
    errorMap.forEach((filename, errors) {
      buffer.writeln('### $index. $filename');
      buffer.writeln('');
      buffer.writeln('**错误信息**:');
      buffer.writeln('```');
      for (final error in errors) {
        buffer.writeln(error);
      }
      buffer.writeln('```');
      buffer.writeln('');
      buffer.writeln('**修复建议**:');
      buffer.writeln('');
      buffer.writeln('- [ ] 分析错误原因');
      buffer.writeln('- [ ] 修改编译器或core代码');
      buffer.writeln('- [ ] 验证修复效果');
      buffer.writeln('');
      buffer.writeln('---');
      buffer.writeln('');
      index++;
    });
  } else {
    buffer.writeln('## ✅ 所有测试通过！');
    buffer.writeln('');
  }

  reportFile.writeAsStringSync(buffer.toString());
  print('报告已生成: ${reportFile.path}');
}
