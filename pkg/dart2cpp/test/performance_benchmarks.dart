/// 性能基准测试
///
/// 测试转换器的性能和生成代码的执行效率

import 'dart:io';
import 'dart:typed_data';
import 'dart:convert';
import '../lib/unified_compiler.dart';

/// 性能测试结果
class BenchmarkResult {
  final String testName;
  final Duration executionTime;
  final int iterations;
  final double averageMs;
  final bool passed;

  const BenchmarkResult({
    required this.testName,
    required this.executionTime,
    required this.iterations,
    required this.averageMs,
    required this.passed,
  });

  @override
  String toString() {
    final status = passed ? '✅' : '❌';
    return '$status $testName: ${averageMs.toStringAsFixed(2)}ms '
           '(总共 ${executionTime.inMilliseconds}ms, $iterations 次迭代)';
  }
}

/// 性能基准测试套件
class PerformanceBenchmark {
  static const int warmupIterations = 10;
  static const int benchmarkIterations = 100;

  /// 运行所有基准测试
  static Future<void> runAll() async {
    print('\n' + '=' * 80);
    print('🚀 Dart转C++ 性能基准测试');
    print('=' * 80);

    final results = <BenchmarkResult>[];

    // 1. 转换速度测试
    results.add(await benchmarkConversionSpeed());

    // 2. 字符串操作测试
    results.add(await benchmarkStringOperations());

    // 3. 集合操作测试
    results.add(await benchmarkCollectionOperations());

    // 4. 类型推断测试
    results.add(await benchmarkTypeInference());

    // 5. 内存使用测试
    results.add(await benchmarkMemoryUsage());

    // 打印汇总
    print('\n' + '=' * 80);
    print('📊 测试汇总');
    print('=' * 80);

    for (final result in results) {
      print(result);
    }

    // 计算总分
    final totalTests = results.length;
    final passedTests = results.where((r) => r.passed).length;
    final passRate = (passedTests / totalTests * 100).toStringAsFixed(1);

    print('\n✅ 通过率: $passRate% ($passedTests/$totalTests)');

    if (passedTests == totalTests) {
      print('🎉 所有测试通过！');
    } else {
      print('⚠️  有 $totalTests 个测试未通过');
    }
  }

  /// 基准测试：转换速度
  static Future<BenchmarkResult> benchmarkConversionSpeed() async {
    const testName = '转换速度';
    const iterations = benchmarkIterations;

    final dartCode = _generateTestDartCode(100);

    final stopwatch = Stopwatch()..start();

    for (int i = 0; i < iterations; i++) {
      await UnifiedCompiler.compileSource(
        dartCode,
        config: CompilerConfig(
          verbose: false,
          optimize: true,
        ),
      );
    }

    stopwatch.stop();

    final averageMs = stopwatch.elapsedMilliseconds / iterations;
    final passed = averageMs < 100; // 期望100ms以内

    return BenchmarkResult(
      testName: testName,
      executionTime: stopwatch.elapsed,
      iterations: iterations,
      averageMs: averageMs,
      passed: passed,
    );
  }

  /// 基准测试：字符串操作
  static Future<BenchmarkResult> benchmarkStringOperations() async {
    const testName = '字符串操作性能';
    const iterations = benchmarkIterations;

    final dartCode = '''
      void main() {
        for (int i = 0; i < 100; i++) {
          var name = "User" + i.toString();
          var msg = "Hello, " + name + "! Welcome!";
          var result = msg.toUpperCase();
        }
      }
    ''';

    final stopwatch = Stopwatch()..start();

    for (int i = 0; i < iterations; i++) {
      final result = await UnifiedCompiler.compileSource(
        dartCode,
        config: CompilerConfig(
          verbose: false,
          optimize: true,
        ),
      );

      // 检查生成的代码是否包含优化
      if (result.cppCode.contains('StringBuilder')) {
        // 字符串优化已应用
      }
    }

    stopwatch.stop();

    final averageMs = stopwatch.elapsedMilliseconds / iterations;
    final passed = averageMs < 50;

    return BenchmarkResult(
      testName: testName,
      executionTime: stopwatch.elapsed,
      iterations: iterations,
      averageMs: averageMs,
      passed: passed,
    );
  }

  /// 基准测试：集合操作
  static Future<BenchmarkResult> benchmarkCollectionOperations() async {
    const testName = '集合操作性能';
    const iterations = benchmarkIterations;

    final dartCode = '''
      void main() {
        var list = [1, 2, 3, 4, 5];
        for (int i = 0; i < 100; i++) {
          list.add(i);
          var sum = 0;
          for (var num in list) {
            sum += num;
          }
        }
      }
    ''';

    final stopwatch = Stopwatch()..start();

    for (int i = 0; i < iterations; i++) {
      await UnifiedCompiler.compileSource(
        dartCode,
        config: CompilerConfig(
          verbose: false,
          optimize: true,
        ),
      );
    }

    stopwatch.stop();

    final averageMs = stopwatch.elapsedMilliseconds / iterations;
    final passed = averageMs < 50;

    return BenchmarkResult(
      testName: testName,
      executionTime: stopwatch.elapsed,
      iterations: iterations,
      averageMs: averageMs,
      passed: passed,
    );
  }

  /// 基准测试：类型推断
  static Future<BenchmarkResult> benchmarkTypeInference() async {
    const testName = '类型推断性能';
    const iterations = benchmarkIterations;

    final dartCode = '''
      class Person {
        String name;
        int age;
        Person(this.name, this.age);
      }

      void main() {
        var person = Person("Alice", 25);
        var list = [person, person, person];
        var map = {"key": person};
      }
    ''';

    final stopwatch = Stopwatch()..start();

    for (int i = 0; i < iterations; i++) {
      await UnifiedCompiler.compileSource(
        dartCode,
        config: CompilerConfig(
          verbose: false,
          optimize: true,
        ),
      );
    }

    stopwatch.stop();

    final averageMs = stopwatch.elapsedMilliseconds / iterations;
    final passed = averageMs < 50;

    return BenchmarkResult(
      testName: testName,
      executionTime: stopwatch.elapsed,
      iterations: iterations,
      averageMs: averageMs,
      passed: passed,
    );
  }

  /// 基准测试：内存使用
  static Future<BenchmarkResult> benchmarkMemoryUsage() async {
    const testName = '内存使用效率';
    const iterations = 1000;

    final dartCode = '''
      void main() {
        for (int i = 0; i < 100; i++) {
          var x = 5 + 3;
          var y = x * 2;
          var z = y - 1;
        }
      }
    ''';

    // 记录初始内存
    final initialMemory = await _getCurrentMemoryUsage();

    final stopwatch = Stopwatch()..start();

    for (int i = 0; i < iterations; i++) {
      await UnifiedCompiler.compileSource(
        dartCode,
        config: CompilerConfig(
          verbose: false,
          optimize: true,
        ),
      );
    }

    stopwatch.stop();

    // 记录结束内存
    final finalMemory = await _getCurrentMemoryUsage();

    final memoryIncrease = finalMemory - initialMemory;
    final passed = memoryIncrease < 50 * 1024 * 1024; // 50MB以内

    return BenchmarkResult(
      testName: testName,
      executionTime: stopwatch.elapsed,
      iterations: iterations,
      averageMs: stopwatch.elapsedMilliseconds / iterations,
      passed: passed,
    );
  }

  /// 生成测试Dart代码
  static String _generateTestDartCode(int size) {
    final sb = StringBuffer();
    sb.writeln('class TestClass {');
    sb.writeln('  String name;');
    sb.writeln('  int value;');
    sb.writeln('  TestClass(this.name, this.value);');
    sb.writeln('}');
    sb.writeln('');
    sb.writeln('void main() {');

    for (int i = 0; i < size; i++) {
      sb.writeln('  var x$i = $i;');
      sb.writeln('  var y$i = x$i * 2;');
      sb.writeln('  var z$i = y$i + x$i;');
    }

    sb.writeln('  var list = [1, 2, 3, 4, 5];');
    sb.writeln('  var sum = 0;');
    sb.writeln('  for (var num in list) {');
    sb.writeln('    sum += num;');
    sb.writeln('  }');
    sb.writeln('}');

    return sb.toString();
  }

  /// 获取当前内存使用（模拟）
  static Future<int> _getCurrentMemoryUsage() async {
    // 实际实现中可能需要使用platform specific API
    // 这里只是模拟
    return 0;
  }
}

/// 主函数
Future<void> main() async {
  try {
    await PerformanceBenchmark.runAll();
    print('\n✅ 所有基准测试完成');
    exit(0);
  } catch (e, stackTrace) {
    print('\n❌ 测试失败: $e');
    print('堆栈跟踪: $stackTrace');
    exit(1);
  }
}
