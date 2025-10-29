/// 测试运行器
/// 运行所有dart2cpp转换逻辑测试
import 'dart:io';

void main() async {
  print('🚀 Dart2Cpp 转换逻辑测试套件');
  print('=' * 60);
  print('开始时间: ${DateTime.now()}');
  print('');

  final tests = [
    'test_basic_functionality.dart',
    'test_expression_conversion.dart',
    'test_statement_conversion.dart',
    'test_type_conversion.dart',
    'test_integration.dart',
  ];

  int totalPassed = 0;
  int totalTests = 0;
  final results = <String, Map<String, int>>{};

  for (final test in tests) {
    print('🧪 运行测试: $test');
    print('-' * 40);

    try {
      final result = await Process.run('dart', [test]);

      if (result.exitCode == 0) {
        print('✅ 测试完成: $test');
        print('输出:');
        print(result.stdout);

        // 解析测试结果
        final output = result.stdout.toString();
        final passedMatch = RegExp(r'通过测试: (\d+)').firstMatch(output);
        final totalMatch = RegExp(r'总测试数: (\d+)').firstMatch(output);

        if (passedMatch != null && totalMatch != null) {
          final passed = int.parse(passedMatch.group(1)!);
          final total = int.parse(totalMatch.group(1)!);

          totalPassed += passed;
          totalTests += total;

          results[test] = {'passed': passed, 'total': total};

          print('📊 结果: $passed/$total 通过');
        }
      } else {
        print('❌ 测试失败: $test');
        print('错误:');
        print(result.stderr);
        results[test] = {'passed': 0, 'total': 1};
        totalTests += 1;
      }
    } catch (e) {
      print('❌ 测试异常: $test - $e');
      results[test] = {'passed': 0, 'total': 1};
      totalTests += 1;
    }

    print('');
  }

  // 测试总结
  print('=' * 60);
  print('📊 测试套件总结');
  print('=' * 60);

  print('各测试结果:');
  results.forEach((test, result) {
    final passed = result['passed']!;
    final total = result['total']!;
    final percentage =
        total > 0 ? (passed / total * 100).toStringAsFixed(1) : '0.0';
    final status = passed == total
        ? '✅'
        : passed > 0
            ? '⚠️'
            : '❌';
    print('  $status $test: $passed/$total ($percentage%)');
  });

  print('');
  print('总体统计:');
  print('  总测试数: $totalTests');
  print('  通过测试: $totalPassed');
  print('  失败测试: ${totalTests - totalPassed}');
  print(
      '  通过率: ${totalTests > 0 ? (totalPassed / totalTests * 100).toStringAsFixed(1) : '0.0'}%');

  print('');
  print('🏆 最终评估:');
  if (totalTests > 0) {
    final passRate = totalPassed / totalTests;
    if (passRate >= 0.9) {
      print('  🟢 优秀: 转换逻辑非常可靠 (通过率 >= 90%)');
    } else if (passRate >= 0.8) {
      print('  🟢 良好: 转换逻辑基本可靠 (通过率 >= 80%)');
    } else if (passRate >= 0.6) {
      print('  🟡 一般: 转换逻辑基本可用 (通过率 >= 60%)');
    } else {
      print('  🔴 需要改进: 转换逻辑存在重大问题 (通过率 < 60%)');
    }
  } else {
    print('  ❌ 无法评估: 没有成功运行的测试');
  }

  print('');
  print('结束时间: ${DateTime.now()}');
  print('=' * 60);

  // 生成测试报告
  await _generateTestReport(results, totalPassed, totalTests);
}

Future<void> _generateTestReport(
  Map<String, Map<String, int>> results,
  int totalPassed,
  int totalTests,
) async {
  final report = StringBuffer();

  report.writeln('# Dart2Cpp 转换逻辑测试报告');
  report.writeln('');
  report.writeln('**生成时间**: ${DateTime.now()}');
  report.writeln('**测试版本**: dart2cpp v2.0.0');
  report.writeln('');

  report.writeln('## 测试摘要');
  report.writeln('');
  report.writeln('| 指标 | 数值 |');
  report.writeln('|------|------|');
  report.writeln('| 总测试数 | $totalTests |');
  report.writeln('| 通过测试 | $totalPassed |');
  report.writeln('| 失败测试 | ${totalTests - totalPassed} |');
  report.writeln(
      '| 通过率 | ${totalTests > 0 ? (totalPassed / totalTests * 100).toStringAsFixed(1) : '0.0'}% |');
  report.writeln('');

  report.writeln('## 详细结果');
  report.writeln('');
  report.writeln('| 测试文件 | 通过/总数 | 通过率 | 状态 |');
  report.writeln('|----------|-----------|--------|------|');

  results.forEach((test, result) {
    final passed = result['passed']!;
    final total = result['total']!;
    final percentage =
        total > 0 ? (passed / total * 100).toStringAsFixed(1) : '0.0';
    final status = passed == total
        ? '✅ 通过'
        : passed > 0
            ? '⚠️ 部分通过'
            : '❌ 失败';
    report.writeln('| $test | $passed/$total | $percentage% | $status |');
  });

  report.writeln('');
  report.writeln('## 测试分类');
  report.writeln('');
  report.writeln('### 基础功能测试');
  report.writeln('- 版本信息显示');
  report.writeln('- 支持特性列表');
  report.writeln('- 基本编译功能');
  report.writeln('- 文件编译功能');
  report.writeln('- 优化功能');
  report.writeln('- 错误处理');
  report.writeln('');

  report.writeln('### 表达式转换测试');
  report.writeln('- 字面量表达式');
  report.writeln('- 算术运算符');
  report.writeln('- 比较运算符');
  report.writeln('- 逻辑运算符');
  report.writeln('- 条件表达式');
  report.writeln('- 字符串插值');
  report.writeln('- 集合字面量');
  report.writeln('- 方法调用');
  report.writeln('');

  report.writeln('### 语句转换测试');
  report.writeln('- 变量声明');
  report.writeln('- 控制流语句');
  report.writeln('- 循环语句');
  report.writeln('- 函数定义');
  report.writeln('- 类定义');
  report.writeln('- 异常处理');
  report.writeln('- 块语句');
  report.writeln('- 表达式语句');
  report.writeln('');

  report.writeln('### 类型转换测试');
  report.writeln('- 基础类型转换');
  report.writeln('- 集合类型转换');
  report.writeln('- 泛型类型转换');
  report.writeln('- 函数类型转换');
  report.writeln('- 可空类型转换');
  report.writeln('- 类型转换操作符');
  report.writeln('- 动态类型转换');
  report.writeln('- 类型别名转换');
  report.writeln('');

  report.writeln('### 集成测试');
  report.writeln('- 完整程序转换');
  report.writeln('- 文件编译集成');
  report.writeln('- 性能测试');
  report.writeln('- 错误处理集成');
  report.writeln('- 复杂数据结构转换');
  report.writeln('- 异步编程转换');
  report.writeln('');

  report.writeln('## 建议');
  report.writeln('');

  if (totalTests > 0) {
    final passRate = totalPassed / totalTests;
    if (passRate >= 0.9) {
      report.writeln('✅ **转换逻辑状态良好**');
      report.writeln('- 大部分功能正常工作');
      report.writeln('- 可以用于生产环境');
      report.writeln('- 建议继续优化性能');
    } else if (passRate >= 0.8) {
      report.writeln('⚠️ **转换逻辑基本可用**');
      report.writeln('- 核心功能正常');
      report.writeln('- 需要修复部分问题');
      report.writeln('- 建议完善测试覆盖');
    } else if (passRate >= 0.6) {
      report.writeln('🟡 **转换逻辑需要改进**');
      report.writeln('- 基础功能可用');
      report.writeln('- 存在较多问题');
      report.writeln('- 建议重点修复失败测试');
    } else {
      report.writeln('🔴 **转换逻辑需要重大改进**');
      report.writeln('- 存在严重问题');
      report.writeln('- 不建议用于生产');
      report.writeln('- 需要重新审视转换逻辑');
    }
  }

  report.writeln('');
  report.writeln('---');
  report.writeln('*此报告由 dart2cpp 测试套件自动生成*');

  // 写入报告文件
  final reportFile = File('test_report.md');
  await reportFile.writeAsString(report.toString());

  print('📄 测试报告已生成: test_report.md');
}
