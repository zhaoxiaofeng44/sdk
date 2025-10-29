/// 集成测试用例
/// 测试完整的Dart到C++转换流程
import 'dart:io';
import '../lib/dart2cpp.dart';

void main() async {
  print('🧪 开始集成测试');
  print('=' * 50);

  int passedTests = 0;
  int totalTests = 0;

  // 测试1: 完整程序转换
  totalTests++;
  print('\n📝 测试1: 完整程序转换');
  try {
    final result = await UnifiedCompiler.compileSource(
      '''
// 完整的Dart程序示例
class Calculator {
  double _result = 0.0;
  
  Calculator(double initialValue) {
    _result = initialValue;
  }
  
  double add(double value) {
    _result += value;
    return _result;
  }
  
  double subtract(double value) {
    _result -= value;
    return _result;
  }
  
  double multiply(double value) {
    _result *= value;
    return _result;
  }
  
  double divide(double value) {
    if (value != 0) {
      _result /= value;
    } else {
      throw ArgumentError('Division by zero');
    }
    return _result;
  }
  
  double get result => _result;
  
  void reset() {
    _result = 0.0;
  }
}

class MathUtils {
  static double power(double base, double exponent) {
    double result = 1.0;
    for (int i = 0; i < exponent.toInt(); i++) {
      result *= base;
    }
    return result;
  }
  
  static double factorial(int n) {
    if (n < 0) {
      throw ArgumentError('Factorial of negative number');
    }
    if (n <= 1) {
      return 1.0;
    }
    return n * factorial(n - 1);
  }
}

void main() {
  print('Calculator Demo');
  
  Calculator calc = Calculator(10.0);
  
  print('Initial result: \${calc.result}');
  
  calc.add(5.0);
  print('After adding 5: \${calc.result}');
  
  calc.multiply(2.0);
  print('After multiplying by 2: \${calc.result}');
  
  calc.subtract(3.0);
  print('After subtracting 3: \${calc.result}');
  
  try {
    calc.divide(4.0);
    print('After dividing by 4: \${calc.result}');
  } catch (e) {
    print('Error: \$e');
  }
  
  // 测试静态方法
  double powerResult = MathUtils.power(2.0, 3.0);
  print('2^3 = \$powerResult');
  
  double factorialResult = MathUtils.factorial(5);
  print('5! = \$factorialResult');
  
  // 测试异常处理
  try {
    calc.divide(0.0);
  } catch (e) {
    print('Caught division by zero error: \$e');
  }
  
  print('Demo completed');
}
''',
      config: CompilerConfig(
        includeRuntime: true,
        optimize: false,
        verbose: false,
      ),
    );

    if (result.isSuccess) {
      final cppCode = result.cppCode;
      final checks = {
        '类定义': cppCode.contains('class Calculator') &&
            cppCode.contains('class MathUtils'),
        '构造函数': cppCode.contains('Calculator('),
        '方法定义': cppCode.contains('add(') && cppCode.contains('subtract('),
        '静态方法': cppCode.contains('static ') || cppCode.contains('MathUtils::'),
        '异常处理': cppCode.contains('try ') || cppCode.contains('catch '),
        '主函数': cppCode.contains('int main()'),
        '对象创建': cppCode.contains('new Calculator') ||
            cppCode.contains('Calculator('),
      };

      final passedChecks = checks.values.where((v) => v).length;
      if (passedChecks >= 5) {
        print('✅ 完整程序转换正确 ($passedChecks/7)');
        checks.forEach((key, value) {
          print('  • $key: ${value ? "✅" : "❌"}');
        });
        passedTests++;
      } else {
        print('❌ 完整程序转换不完整 ($passedChecks/7)');
      }
    } else {
      print('❌ 完整程序转换测试失败');
    }
  } catch (e) {
    print('❌ 完整程序转换测试异常: $e');
  }

  // 测试2: 文件编译集成
  totalTests++;
  print('\n📝 测试2: 文件编译集成');
  try {
    // 创建测试文件
    final testFile = File('integration_test.dart');
    await testFile.writeAsString('''
// 集成测试文件
class Person {
  String name;
  int age;
  List<String> hobbies;
  
  Person(this.name, this.age, this.hobbies);
  
  void introduce() {
    print("Hi, I'm \$name and I'm \$age years old");
    print("My hobbies are: \${hobbies.join(', ')}");
  }
  
  void addHobby(String hobby) {
    hobbies.add(hobby);
  }
  
  int getAgeInMonths() {
    return age * 12;
  }
}

void main() {
  List<String> hobbies = ["reading", "coding", "gaming"];
  Person person = Person("Alice", 25, hobbies);
  
  person.introduce();
  
  person.addHobby("swimming");
  print("Added swimming to hobbies");
  
  int ageInMonths = person.getAgeInMonths();
  print("Age in months: \$ageInMonths");
  
  // 测试集合操作
  List<int> numbers = [1, 2, 3, 4, 5];
  int sum = numbers.reduce((a, b) => a + b);
  print("Sum of numbers: \$sum");
  
  // 测试字符串操作
  String message = "Hello, World!";
  String reversed = message.split('').reversed.join('');
  print("Reversed message: \$reversed");
}
''');

    final result = await UnifiedCompiler.compileFile(
      'integration_test.dart',
      config: CompilerConfig(
        outputPath: 'integration_test.cpp',
        includeRuntime: true,
        optimize: true,
        verbose: false,
      ),
    );

    if (result.isSuccess && File('integration_test.cpp').existsSync()) {
      final cppFile = File('integration_test.cpp');
      final cppContent = await cppFile.readAsString();

      final checks = {
        '文件存在': File('integration_test.cpp').existsSync(),
        '类定义': cppContent.contains('class Person'),
        '方法定义': cppContent.contains('introduce()') &&
            cppContent.contains('addHobby('),
        '集合操作': cppContent.contains('List<') && cppContent.contains('reduce('),
        '字符串操作':
            cppContent.contains('String ') && cppContent.contains('split('),
        '主函数': cppContent.contains('int main()'),
      };

      final passedChecks = checks.values.where((v) => v).length;
      if (passedChecks >= 5) {
        print('✅ 文件编译集成正确 ($passedChecks/6)');
        checks.forEach((key, value) {
          print('  • $key: ${value ? "✅" : "❌"}');
        });
        passedTests++;
      } else {
        print('❌ 文件编译集成不完整 ($passedChecks/6)');
      }

      // 清理测试文件
      await testFile.delete();
      await cppFile.delete();
    } else {
      print('❌ 文件编译集成测试失败');
    }
  } catch (e) {
    print('❌ 文件编译集成测试异常: $e');
  }

  // 测试3: 性能测试
  totalTests++;
  print('\n📝 测试3: 性能测试');
  try {
    final stopwatch = Stopwatch()..start();

    final result = await UnifiedCompiler.compileSource(
      '''
void main() {
  // 性能测试代码
  List<int> numbers = List.generate(1000, (index) => index);
  
  int sum = 0;
  for (int number in numbers) {
    sum += number;
  }
  
  double average = sum / numbers.length;
  
  print("Sum: \$sum");
  print("Average: \$average");
  
  // 测试字符串操作
  String text = "Performance test";
  for (int i = 0; i < 100; i++) {
    text += " \$i";
  }
  
  print("Text length: \${text.length}");
}
''',
      config: CompilerConfig(
        includeRuntime: true,
        optimize: true,
        verbose: false,
      ),
    );

    stopwatch.stop();

    if (result.isSuccess) {
      final compilationTime = result.compilationTime.inMilliseconds;
      final totalTime = stopwatch.elapsedMilliseconds;

      print('✅ 性能测试通过');
      print('  • 编译时间: ${compilationTime}ms');
      print('  • 总时间: ${totalTime}ms');
      print('  • 代码大小: ${result.codeSize} 字符');

      if (compilationTime < 100) {
        print('  • 性能评级: 优秀 (< 100ms)');
        passedTests++;
      } else if (compilationTime < 500) {
        print('  • 性能评级: 良好 (< 500ms)');
        passedTests++;
      } else {
        print('  • 性能评级: 需要优化 (> 500ms)');
      }
    } else {
      print('❌ 性能测试失败');
    }
  } catch (e) {
    print('❌ 性能测试异常: $e');
  }

  // 测试4: 错误处理集成
  totalTests++;
  print('\n📝 测试4: 错误处理集成');
  try {
    final result = await UnifiedCompiler.compileSource(
      '''
void main() {
  // 故意包含多种错误
  int x = ; // 语法错误
  String y = "Hello";
  int z = y; // 类型错误
  
  // 未定义的变量
  print(undefinedVariable);
  
  // 未定义的方法
  y.undefinedMethod();
}
''',
      config: CompilerConfig(
        includeRuntime: true,
        optimize: false,
        verbose: false,
      ),
    );

    if (!result.isSuccess && result.errors.isNotEmpty) {
      print('✅ 错误处理集成正确');
      print('  • 检测到错误: ${result.errors.length} 个');
      for (final error in result.errors) {
        print('  • $error');
      }
      passedTests++;
    } else {
      print('❌ 错误处理集成异常: 应该检测到错误但没有');
    }
  } catch (e) {
    print('✅ 错误处理集成正确: 捕获到异常 $e');
    passedTests++;
  }

  // 测试5: 复杂数据结构转换
  totalTests++;
  print('\n📝 测试5: 复杂数据结构转换');
  try {
    final result = await UnifiedCompiler.compileSource(
      '''
class TreeNode {
  int value;
  TreeNode? left;
  TreeNode? right;
  
  TreeNode(this.value);
  
  void insert(int newValue) {
    if (newValue < value) {
      if (left == null) {
        left = TreeNode(newValue);
      } else {
        left!.insert(newValue);
      }
    } else {
      if (right == null) {
        right = TreeNode(newValue);
      } else {
        right!.insert(newValue);
      }
    }
  }
  
  List<int> inorderTraversal() {
    List<int> result = [];
    if (left != null) {
      result.addAll(left!.inorderTraversal());
    }
    result.add(value);
    if (right != null) {
      result.addAll(right!.inorderTraversal());
    }
    return result;
  }
}

void main() {
  TreeNode root = TreeNode(5);
  root.insert(3);
  root.insert(7);
  root.insert(1);
  root.insert(9);
  
  List<int> traversal = root.inorderTraversal();
  print("Inorder traversal: \$traversal");
}
''',
      config: CompilerConfig(
        includeRuntime: true,
        optimize: false,
        verbose: false,
      ),
    );

    if (result.isSuccess) {
      final cppCode = result.cppCode;
      final checks = {
        '递归结构': cppCode.contains('TreeNode') &&
            cppCode.contains('left') &&
            cppCode.contains('right'),
        '可空类型': cppCode.contains('TreeNode?') || cppCode.contains('nullptr'),
        '递归方法': cppCode.contains('inorderTraversal()'),
        '集合操作': cppCode.contains('List<') && cppCode.contains('addAll('),
      };

      final passedChecks = checks.values.where((v) => v).length;
      if (passedChecks >= 3) {
        print('✅ 复杂数据结构转换正确 ($passedChecks/4)');
        checks.forEach((key, value) {
          print('  • $key: ${value ? "✅" : "❌"}');
        });
        passedTests++;
      } else {
        print('❌ 复杂数据结构转换不完整 ($passedChecks/4)');
      }
    } else {
      print('❌ 复杂数据结构转换测试失败');
    }
  } catch (e) {
    print('❌ 复杂数据结构转换测试异常: $e');
  }

  // 测试6: 异步编程转换
  totalTests++;
  print('\n📝 测试6: 异步编程转换');
  try {
    final result = await UnifiedCompiler.compileSource(
      '''
import 'dart:async';

Future<String> fetchData() async {
  await Future.delayed(Duration(seconds: 1));
  return "Data fetched";
}

Future<int> calculateSum(List<int> numbers) async {
  int sum = 0;
  for (int number in numbers) {
    sum += number;
    await Future.delayed(Duration(milliseconds: 10));
  }
  return sum;
}

void main() async {
  print("Starting async operations");
  
  String data = await fetchData();
  print("Data: \$data");
  
  List<int> numbers = [1, 2, 3, 4, 5];
  int sum = await calculateSum(numbers);
  print("Sum: \$sum");
  
  print("Async operations completed");
}
''',
      config: CompilerConfig(
        includeRuntime: true,
        optimize: false,
        verbose: false,
      ),
    );

    if (result.isSuccess) {
      final cppCode = result.cppCode;
      final checks = {
        'Future类型':
            cppCode.contains('Future<') || cppCode.contains('DART_ASYNC'),
        'async函数': cppCode.contains('async') ||
            cppCode.contains('DART_ASYNC_FUNCTION'),
        'await操作': cppCode.contains('await') || cppCode.contains('DART_AWAIT'),
        'Duration': cppCode.contains('Duration') || cppCode.contains('seconds'),
      };

      final passedChecks = checks.values.where((v) => v).length;
      if (passedChecks >= 2) {
        print('✅ 异步编程转换正确 ($passedChecks/4)');
        checks.forEach((key, value) {
          print('  • $key: ${value ? "✅" : "❌"}');
        });
        passedTests++;
      } else {
        print('❌ 异步编程转换不完整 ($passedChecks/4)');
      }
    } else {
      print('❌ 异步编程转换测试失败');
    }
  } catch (e) {
    print('❌ 异步编程转换测试异常: $e');
  }

  // 测试总结
  print('\n' + '=' * 50);
  print('📊 集成测试总结');
  print('总测试数: $totalTests');
  print('通过测试: $passedTests');
  print('失败测试: ${totalTests - passedTests}');
  print('通过率: ${(passedTests / totalTests * 100).toStringAsFixed(1)}%');

  if (passedTests == totalTests) {
    print('🎉 所有集成测试通过！');
  } else {
    print('⚠️ 部分集成测试失败，需要修复');
  }

  // 总体评估
  print('\n📈 总体评估');
  if (passedTests >= totalTests * 0.8) {
    print('🟢 转换逻辑整体良好 (通过率 >= 80%)');
  } else if (passedTests >= totalTests * 0.6) {
    print('🟡 转换逻辑基本可用 (通过率 >= 60%)');
  } else {
    print('🔴 转换逻辑需要重大改进 (通过率 < 60%)');
  }
}
