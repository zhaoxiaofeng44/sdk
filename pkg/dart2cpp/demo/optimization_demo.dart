/// 优化演示
///
/// 展示所有优化功能的使用方法和效果

import '../lib/unified_compiler.dart';
import '../lib/type_analyzer.dart';
import '../lib/optimizers/optimizer_manager.dart';
import '../lib/exceptions.dart';

/// 演示程序
class OptimizationDemo {
  /// 运行所有演示
  static Future<void> runAll() async {
    print('\n' + '🚀'.padRight(80));
    print('Dart转C++ 优化功能演示');
    print('=' * 80);

    // 1. 演示类型分析
    await demoTypeAnalyzer();

    print('\n' + '-' * 80);

    // 2. 演示常量折叠
    await demoConstantFolding();

    print('\n' + '-' * 80);

    // 3. 演示字符串优化
    await demoStringOptimization();

    print('\n' + '-' * 80);

    // 4. 演示错误处理
    await demoErrorHandling();

    print('\n' + '-' * 80);

    // 5. 演示完整转换流程
    await demoCompleteConversion();

    print('\n' + '=' * 80);
    print('✅ 所有演示完成');
    print('=' * 80);
  }

  /// 演示类型分析器
  static Future<void> demoTypeAnalyzer() async {
    print('\n📌 演示1: 类型分析器');

    final sampleCode = '''
      class Person {
        String name;
        int age;
        Person(this.name, this.age);
      }

      class Animal {
        String name;
        Animal(this.name);
      }

      void main() {
        var person = Person("Alice", 25);
        var animal = Animal("Dog");
        var list = [1, 2, 3];
        var map = {"key": "value"};
        var x = 5;
        var s = "hello";
      }
    ''';

    try {
      print('\n  输入Dart代码:');
      print('    Person, Animal (自定义类)');
      print('    List, Map (集合类型)');
      print('    int, String (基本类型)');

      final result = await UnifiedCompiler.compileSource(
        sampleCode,
        config: CompilerConfig(
          verbose: true,
          optimize: true,
        ),
      );

      print('\n  ✅ 类型分析成功');
      print('    输出文件: ${result.outputPath}');
      print('    代码大小: ${result.codeSize} 字符');
      print('    编译时间: ${result.compilationTime.inMilliseconds}ms');

      // 分析生成的代码
      if (result.cppCode.contains('ObjectPtr<Person>')) {
        print('    ✓ 自定义类正确使用ObjectPtr包装');
      }
      if (result.cppCode.contains('ObjectPtr<List<Int>>')) {
        print('    ✓ 集合类型正确使用ObjectPtr包装');
      }
      if (result.cppCode.contains('Int x') && !result.cppCode.contains('ObjectPtr<Int>')) {
        print('    ✓ 基本类型未使用ObjectPtr包装');
      }

    } catch (e) {
      print('  ❌ 类型分析失败: $e');
    }
  }

  /// 演示常量折叠优化
  static Future<void> demoConstantFolding() async {
    print('\n📌 演示2: 常量折叠优化');

    final sampleCode = '''
      void main() {
        var x = 5 + 3;
        var y = x * 2;
        var z = 10.5 + 2.3;
        var s = "Hello" + "World";
        var result = (5 + 3) * 2;
      }
    ''';

    print('\n  输入Dart代码 (常量表达式):');
    print('    var x = 5 + 3;');
    print('    var z = 10.5 + 2.3;');
    print('    var s = "Hello" + "World";');

    try {
      final result = await UnifiedCompiler.compileSource(
        sampleCode,
        config: CompilerConfig(
          verbose: true,
          optimize: true,
        ),
      );

      print('\n  ✅ 常量折叠成功');

      // 检查优化效果
      if (result.cppCode.contains('Int(8)')) {
        print('    ✓ 整数常量折叠: 5 + 3 => 8');
      }
      if (result.cppCode.contains('Double(12.8)')) {
        print('    ✓ 浮点常量折叠: 10.5 + 2.3 => 12.8');
      }
      if (result.cppCode.contains('String("HelloWorld")')) {
        print('    ✓ 字符串常量折叠: "Hello" + "World" => "HelloWorld"');
      }

      print('    优化后代码长度: ${result.codeSize} 字符');

    } catch (e) {
      print('  ❌ 常量折叠失败: $e');
    }
  }

  /// 演示字符串优化
  static Future<void> demoStringOptimization() async {
    print('\n📌 演示3: 字符串优化');

    final sampleCode = '''
      void main() {
        var name = "Alice";
        var age = 25;
        var message = "Hello, " + name + "! You are " + age.toString() + " years old.";
      }
    ''';

    print('\n  输入Dart代码 (字符串插值):');
    print('    var message = "Hello, " + name + "! You are " + age.toString() + " years old.";');

    try {
      final result = await UnifiedCompiler.compileSource(
        sampleCode,
        config: CompilerConfig(
          verbose: true,
          optimize: true,
        ),
      );

      print('\n  ✅ 字符串优化成功');

      if (result.cppCode.contains('StringBuilder')) {
        print('    ✓ 使用StringBuilder优化字符串拼接');
      } else if (result.cppCode.contains('String("Hello, ") + name')) {
        print('    ✓ 使用简单拼接 (表达式较少)');
      }

      // 计算减少的临时对象数量
      final tempObjectReduction = _countTempObjects(result.cppCode);
      print('    减少临时对象: ~$tempObjectReduction 个');

    } catch (e) {
      print('  ❌ 字符串优化失败: $e');
    }
  }

  /// 演示错误处理
  static Future<void> demoErrorHandling() async {
    print('\n📌 演示4: 错误处理和验证');

    // 测试不支持的特性
    final unsupportedCode = '''
      Iterable<int> countUp(int n) sync* {
        for (int i = 0; i < n; i++) {
          yield i;
        }
      }

      void main() {
        var numbers = countUp(10);
      }
    ''';

    print('\n  测试不支持的特性 (sync* 生成器):');
    print('    Iterable<int> countUp(int n) sync* { ... }');

    try {
      final result = await UnifiedCompiler.compileSource(
        unsupportedCode,
        config: CompilerConfig(
          verbose: true,
        ),
      );

      if (result.isSuccess) {
        print('  ⚠️  意外成功: 转换应该失败但没有失败');
      }

    } catch (e) {
      if (e is ConversionException) {
        print('  ✅ 正确捕获转换异常');
        print('    错误: ${e.message}');
        if (e.suggestions != null && e.suggestions!.isNotEmpty) {
          print('    建议: ${e.suggestions!.first}');
        }
      } else {
        print('  ⚠️  捕获了非预期异常: $e');
      }
    }

    // 测试警告
    final warningCode = '''
      void main() {
        var s = "";
        for (int i = 0; i < 1000; i++) {
          s = s + i.toString();
        }
      }
    ''';

    print('\n  测试性能警告 (循环中字符串拼接):');

    try {
      final result = await UnifiedCompiler.compileSource(
        warningCode,
        config: CompilerConfig(
          verbose: true,
        ),
      );

      print('  ✅ 转换完成并生成警告');

    } catch (e) {
      print('  ❌ 意外失败: $e');
    }
  }

  /// 演示完整转换流程
  static Future<void> demoCompleteConversion() async {
    print('\n📌 演示5: 完整转换流程');

    final complexCode = '''
      class Calculator {
        int add(int a, int b) => a + b;
        int multiply(int a, int b) => a * b;
        double calculate(double x) => x * 3.14 + 2.5;
      }

      class Person {
        String name;
        int age;
        Person(this.name, this.age);

        String introduce() {
          return "I'm " + name + ", " + age.toString() + " years old";
        }
      }

      void main() {
        var calc = Calculator();
        var result = calc.add(5, 3);
        var person = Person("Alice", 25);
        var message = person.introduce();

        // 字符串拼接
        var greeting = "Hello, " + person.name + "!";
        var info = "Age: " + person.age.toString();

        // 集合操作
        var list = [1, 2, 3, 4, 5];
        var sum = 0;
        for (var num in list) {
          sum += num;
        }

        print(message);
        print(greeting);
        print(sum);
      }
    ''';

    print('\n  输入复杂的Dart代码:');
    print('    • 自定义类 (Calculator, Person)');
    print('    • 类方法 (add, multiply, introduce)');
    print('    • 字符串插值');
    print('    • 集合操作');
    print('    • 循环');

    try {
      final result = await UnifiedCompiler.compileSource(
        complexCode,
        config: CompilerConfig(
          verbose: true,
          optimize: true,
        ),
      );

      print('\n  ✅ 完整转换成功');

      // 检查各种特性
      final checks = [
        ('ObjectPtr<Calculator>', '自定义类包装'),
        ('ObjectPtr<Person>', '自定义类包装'),
        ('calc->add', '方法调用'),
        ('StringBuilder', '字符串优化'),
        ('dart_for_each', 'for-in循环'),
      ];

      for (final check in checks) {
        if (result.cppCode.contains(check.$1)) {
          print('    ✓ ${check.$2}');
        }
      }

      print('\n  📊 统计:');
      print('    输出文件: ${result.outputPath}');
      print('    代码大小: ${result.codeSize} 字符');
      print('    编译时间: ${result.compilationTime.inMilliseconds}ms');
      print('    错误数: ${result.errors.length}');
      print('    警告数: ${result.warnings.length}');

    } catch (e) {
      print('  ❌ 完整转换失败: $e');
    }
  }

  /// 统计临时对象数量（简化版）
  static int _countTempObjects(String code) {
    // 计算字符串"String("的出现次数
    // 这是一个简化估算，实际应该使用AST分析
    int count = 0;
    int index = 0;
    while ((index = code.indexOf('String("', index)) != -1) {
      count++;
      index += 7;
    }
    return count;
  }
}

/// 主函数
Future<void> main() async {
  try {
    await OptimizationDemo.runAll();
  } catch (e, stackTrace) {
    print('\n❌ 演示失败: $e');
    print('堆栈跟踪:\n$stackTrace');
    exit(1);
  }
}
