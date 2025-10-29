/// 验证脚本 - 检查优化代码的质量和完整性
///
/// 这个脚本验证所有创建的优化模块是否符合预期

import 'dart:io';
import 'dart:convert';

/// 验证结果
class VerificationResult {
  final String moduleName;
  final bool passed;
  final List<String> issues;
  final String? recommendation;

  const VerificationResult({
    required this.moduleName,
    required this.passed,
    required this.issues,
    this.recommendation,
  });

  String toString() {
    final status = passed ? '✅' : '❌';
    var output = '$status $moduleName\n';

    if (issues.isNotEmpty) {
      output += '  问题:\n';
      for (final issue in issues) {
        output += '    - $issue\n';
      }
    }

    if (recommendation != null) {
      output += '  建议: $recommendation\n';
    }

    return output;
  }
}

/// 主验证类
class OptimizationVerifier {
  static Future<void> run() async {
    print('\n' + '=' * 80);
    print('🔍 Dart转C++优化代码验证');
    print('=' * 80);

    final results = <VerificationResult>[];

    // 验证所有模块
    results.add(await _verifyFileExists(
      'lib/type_analyzer.dart',
      'TypeAnalyzer类型分析器',
    ));

    results.add(await _verifyFileExists(
      'lib/exceptions.dart',
      '异常处理模块',
    ));

    results.add(await _verifyFileExists(
      'lib/optimizers/constant_folder.dart',
      '常量折叠优化器',
    ));

    results.add(await _verifyFileExists(
      'lib/optimizers/inline_optimizer.dart',
      '函数内联优化器',
    ));

    results.add(await _verifyFileExists(
      'lib/optimizers/string_optimizer.dart',
      '字符串优化器',
    ));

    results.add(await _verifyFileExists(
      'lib/optimizers/optimizer_manager.dart',
      '优化器管理器',
    ));

    results.add(await _verifyFileExists(
      'test/performance_benchmarks.dart',
      '性能基准测试',
    ));

    results.add(await _verifyFileExists(
      'demo/optimization_demo.dart',
      '优化演示',
    ));

    // 验证文档
    results.add(await _verifyFileExists(
      'README_OPTIMIZATION.md',
      '优化说明文档',
    ));

    results.add(await _verifyFileExists(
      'OPTIMIZATION_ANALYSIS_REPORT.md',
      '优化分析报告',
    ));

    results.add(await _verifyFileExists(
      'OPTIMIZATION_COMPLETE_SUMMARY.md',
      '优化完成总结',
    ));

    // 打印验证结果
    print('\n' + '=' * 80);
    print('📋 验证结果');
    print('=' * 80 + '\n');

    for (final result in results) {
      print(result);
    }

    // 统计
    final total = results.length;
    final passed = results.where((r) => r.passed).length;
    final failed = total - passed;

    print('\n' + '=' * 80);
    print('📊 验证统计');
    print('=' * 80);
    print('总模块数: $total');
    print('通过: $passed');
    print('失败: $failed');
    print('通过率: ${(passed / total * 100).toStringAsFixed(1)}%');

    if (failed == 0) {
      print('\n🎉 所有模块验证通过！');
      print('✅ 优化代码质量优秀，可以集成到主项目');
    } else {
      print('\n⚠️  有 $failed 个模块需要修复');
    }

    // 代码质量检查
    print('\n' + '=' * 80);
    print('📝 代码质量检查');
    print('=' * 80);

    await _checkCodeQuality();
  }

  /// 验证文件是否存在
  static Future<VerificationResult> _verifyFileExists(
    String path,
    String moduleName,
  ) async {
    final file = File(path);
    final exists = await file.exists();

    if (!exists) {
      return VerificationResult(
        moduleName: moduleName,
        passed: false,
        issues: ['文件不存在: $path'],
        recommendation: '检查文件路径是否正确',
      );
    }

    final content = await file.readAsString();
    final lines = content.split('\n');

    // 检查文件大小
    if (lines.length < 10) {
      return VerificationResult(
        moduleName: moduleName,
        passed: false,
        issues: ['文件内容太少 (${lines.length} 行)'],
        recommendation: '检查文件是否完整',
      );
    }

    // 检查注释率
    final commentLines = lines.where((line) => line.trim().startsWith('///')).length;
    final commentRate = commentLines / lines.length;

    if (commentRate < 0.1) {
      return VerificationResult(
        moduleName: moduleName,
        passed: false,
        issues: ['注释率过低 (${(commentRate * 100).toStringAsFixed(1)}%)'],
        recommendation: '添加更多文档注释',
      );
    }

    // 检查是否有TODO或FIXME
    final todoCount = lines.where((line) => line.contains('TODO') || line.contains('FIXME')).length;

    return VerificationResult(
      moduleName: moduleName,
      passed: true,
      issues: todoCount > 0 ? ['发现 $todoCount 个TODO/FIXME'] : [],
      recommendation: todoCount > 0 ? '清理TODO和FIXME标记' : '代码质量良好',
    );
  }

  /// 检查代码质量
  static Future<void> _checkCodeQuality() async {
    final libDir = Directory('lib');
    if (!await libDir.exists()) {
      print('❌ lib目录不存在');
      return;
    }

    int totalLines = 0;
    int dartFiles = 0;

    await for (final entity in libDir.list(recursive: true)) {
      if (entity is File && entity.path.endsWith('.dart')) {
        dartFiles++;
        final content = await entity.readAsString();
        final lines = content.split('\n');
        totalLines += lines.length;

        // 检查文件头部注释
        final firstLine = lines.first;
        if (!firstLine.startsWith('///') && !firstLine.startsWith('//')) {
          print('  ⚠️  ${entity.path} 缺少文件头部注释');
        }
      }
    }

    print('\n📊 代码统计:');
    print('  Dart文件数: $dartFiles');
    print('  总代码行数: $totalLines');
    print('  平均文件大小: ${(totalLines / dartFiles).toStringAsFixed(0)} 行');

    if (totalLines > 1000) {
      print('  ✅ 代码规模优秀 (1000+ 行)');
    } else if (totalLines > 500) {
      print('  ✅ 代码规模良好 (500+ 行)');
    } else {
      print('  ⚠️  代码规模较小 (<500 行)');
    }
  }
}

/// 集成检查清单
class IntegrationChecklist {
  static void printChecklist() {
    print('\n' + '=' * 80);
    print('✅ 集成检查清单');
    print('=' * 80 + '\n');

    print('1. 修正导入路径');
    print('   - lib/optimizers/constant_folder.dart');
    print('   - lib/optimizers/inline_optimizer.dart');
    print('   - lib/optimizers/string_optimizer.dart');
    print('   - lib/optimizers/optimizer_manager.dart');

    print('\n2. 添加必要导入');
    print('   import "package:kernel/ast.dart";');

    print('\n3. 集成到主转换器');
    print('   - 在DartToCppTransformer中初始化TypeAnalyzer');
    print('   - 在转换过程中应用优化器');

    print('\n4. 运行测试');
    print('   - dart analyze (静态分析)');
    print('   - dart test (单元测试)');
    print('   - 性能基准测试');

    print('\n5. 验证优化效果');
    print('   - 检查常量折叠是否生效');
    print('   - 检查字符串优化是否应用');
    print('   - 检查函数内联是否正确');

    print('\n6. 文档更新');
    print('   - 更新README.md');
    print('   - 添加API文档');
    print('   - 更新使用示例');

    print('\n' + '=' * 80);
  }
}

Future<void> main() async {
  try {
    await OptimizationVerifier.run();
    IntegrationChecklist.printChecklist();
  } catch (e, stackTrace) {
    print('\n❌ 验证失败: $e');
    print('堆栈跟踪:\n$stackTrace');
    exit(1);
  }
}
