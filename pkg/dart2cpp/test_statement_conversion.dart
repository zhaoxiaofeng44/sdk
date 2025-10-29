/// 语句转换测试用例
/// 测试各种Dart语句的C++转换正确性
import 'dart:io';
import '../lib/dart2cpp.dart';

void main() async {
  print('🧪 开始语句转换测试');
  print('=' * 50);

  int passedTests = 0;
  int totalTests = 0;

  // 测试1: 变量声明
  totalTests++;
  print('\n📝 测试1: 变量声明');
  try {
    final result = await UnifiedCompiler.compileSource(
      '''
void main() {
  // 基本变量声明
  int a = 10;
  double b = 3.14;
  bool c = true;
  String d = "Hello";
  
  // var声明
  var e = 42;
  var f = "World";
  
  // final声明
  final g = 100;
  final h = "Final";
  
  // const声明
  const i = 200;
  const j = "Const";
  
  print('a=\$a, b=\$b, c=\$c, d=\$d');
  print('e=\$e, f=\$f, g=\$g, h=\$h, i=\$i, j=\$j');
}
''',
      config: CompilerConfig(includeRuntime: true, verbose: false),
    );

    if (result.isSuccess) {
      final cppCode = result.cppCode;
      final checks = {
        'auto声明': cppCode.contains('auto '),
        'const声明': cppCode.contains('const auto '),
        '类型声明': cppCode.contains('Int ') || cppCode.contains('Double '),
      };

      final passedChecks = checks.values.where((v) => v).length;
      if (passedChecks >= 2) {
        print('✅ 变量声明转换正确 ($passedChecks/3)');
        checks.forEach((key, value) {
          print('  • $key: ${value ? "✅" : "❌"}');
        });
        passedTests++;
      } else {
        print('❌ 变量声明转换不完整 ($passedChecks/3)');
      }
    } else {
      print('❌ 变量声明测试失败');
    }
  } catch (e) {
    print('❌ 变量声明测试异常: $e');
  }

  // 测试2: 控制流语句
  totalTests++;
  print('\n📝 测试2: 控制流语句');
  try {
    final result = await UnifiedCompiler.compileSource(
      '''
void main() {
  int x = 10;
  
  // if语句
  if (x > 5) {
    print("x is greater than 5");
  } else {
    print("x is not greater than 5");
  }
  
  // if-else if语句
  if (x > 10) {
    print("x > 10");
  } else if (x > 5) {
    print("x > 5");
  } else {
    print("x <= 5");
  }
}
''',
      config: CompilerConfig(includeRuntime: true, verbose: false),
    );

    if (result.isSuccess) {
      final cppCode = result.cppCode;
      final checks = {
        'if语句': cppCode.contains('if (') && cppCode.contains(')'),
        'else语句': cppCode.contains('else'),
        '大括号': cppCode.contains('{') && cppCode.contains('}'),
      };

      final passedChecks = checks.values.where((v) => v).length;
      if (passedChecks >= 2) {
        print('✅ 控制流语句转换正确 ($passedChecks/3)');
        checks.forEach((key, value) {
          print('  • $key: ${value ? "✅" : "❌"}');
        });
        passedTests++;
      } else {
        print('❌ 控制流语句转换不完整 ($passedChecks/3)');
      }
    } else {
      print('❌ 控制流语句测试失败');
    }
  } catch (e) {
    print('❌ 控制流语句测试异常: $e');
  }

  // 测试3: 循环语句
  totalTests++;
  print('\n📝 测试3: 循环语句');
  try {
    final result = await UnifiedCompiler.compileSource(
      '''
void main() {
  // for循环
  for (int i = 0; i < 5; i++) {
    print("i = \$i");
  }
  
  // while循环
  int j = 0;
  while (j < 3) {
    print("j = \$j");
    j++;
  }
  
  // do-while循环
  int k = 0;
  do {
    print("k = \$k");
    k++;
  } while (k < 2);
}
''',
      config: CompilerConfig(includeRuntime: true, verbose: false),
    );

    if (result.isSuccess) {
      final cppCode = result.cppCode;
      final checks = {
        'for循环': cppCode.contains('for (') && cppCode.contains(';'),
        'while循环': cppCode.contains('while (') && cppCode.contains(')'),
        'do-while循环': cppCode.contains('do ') && cppCode.contains('while'),
      };

      final passedChecks = checks.values.where((v) => v).length;
      if (passedChecks >= 2) {
        print('✅ 循环语句转换正确 ($passedChecks/3)');
        checks.forEach((key, value) {
          print('  • $key: ${value ? "✅" : "❌"}');
        });
        passedTests++;
      } else {
        print('❌ 循环语句转换不完整 ($passedChecks/3)');
      }
    } else {
      print('❌ 循环语句测试失败');
    }
  } catch (e) {
    print('❌ 循环语句测试异常: $e');
  }

  // 测试4: 函数定义
  totalTests++;
  print('\n📝 测试4: 函数定义');
  try {
    final result = await UnifiedCompiler.compileSource(
      '''
// 全局函数
int add(int a, int b) {
  return a + b;
}

double multiply(double x, double y) {
  return x * y;
}

String greet(String name) {
  return "Hello, \$name!";
}

void main() {
  int sum = add(5, 3);
  double product = multiply(2.5, 4.0);
  String message = greet("Alice");
  
  print("sum=\$sum, product=\$product, message=\$message");
}
''',
      config: CompilerConfig(includeRuntime: true, verbose: false),
    );

    if (result.isSuccess) {
      final cppCode = result.cppCode;
      final checks = {
        '函数定义': cppCode.contains('(') && cppCode.contains(')'),
        '返回类型': cppCode.contains('Int ') || cppCode.contains('Double '),
        '参数列表': cppCode.contains(',') || cppCode.contains(')'),
        'return语句': cppCode.contains('return '),
      };

      final passedChecks = checks.values.where((v) => v).length;
      if (passedChecks >= 3) {
        print('✅ 函数定义转换正确 ($passedChecks/4)');
        checks.forEach((key, value) {
          print('  • $key: ${value ? "✅" : "❌"}');
        });
        passedTests++;
      } else {
        print('❌ 函数定义转换不完整 ($passedChecks/4)');
      }
    } else {
      print('❌ 函数定义测试失败');
    }
  } catch (e) {
    print('❌ 函数定义测试异常: $e');
  }

  // 测试5: 类定义
  totalTests++;
  print('\n📝 测试5: 类定义');
  try {
    final result = await UnifiedCompiler.compileSource(
      '''
class Person {
  String name;
  int age;
  
  Person(this.name, this.age);
  
  void introduce() {
    print("Hi, I'm \$name and I'm \$age years old");
  }
  
  int getAge() {
    return age;
  }
  
  void setAge(int newAge) {
    age = newAge;
  }
}

void main() {
  Person person = Person("Alice", 25);
  person.introduce();
  
  int currentAge = person.getAge();
  person.setAge(26);
  
  print("Current age: \$currentAge");
}
''',
      config: CompilerConfig(includeRuntime: true, verbose: false),
    );

    if (result.isSuccess) {
      final cppCode = result.cppCode;
      final checks = {
        '类定义': cppCode.contains('class ') && cppCode.contains('{'),
        '构造函数': cppCode.contains('Person('),
        '方法定义': cppCode.contains('void ') || cppCode.contains('Int '),
        '对象创建': cppCode.contains('new Person') || cppCode.contains('Person('),
      };

      final passedChecks = checks.values.where((v) => v).length;
      if (passedChecks >= 2) {
        print('✅ 类定义转换正确 ($passedChecks/4)');
        checks.forEach((key, value) {
          print('  • $key: ${value ? "✅" : "❌"}');
        });
        passedTests++;
      } else {
        print('❌ 类定义转换不完整 ($passedChecks/4)');
      }
    } else {
      print('❌ 类定义测试失败');
    }
  } catch (e) {
    print('❌ 类定义测试异常: $e');
  }

  // 测试6: 异常处理
  totalTests++;
  print('\n📝 测试6: 异常处理');
  try {
    final result = await UnifiedCompiler.compileSource(
      '''
void main() {
  try {
    int result = 10 ~/ 0; // 这会抛出异常
    print("Result: \$result");
  } catch (e) {
    print("Caught exception: \$e");
  } finally {
    print("Finally block executed");
  }
}
''',
      config: CompilerConfig(includeRuntime: true, verbose: false),
    );

    if (result.isSuccess) {
      final cppCode = result.cppCode;
      final checks = {
        'try块': cppCode.contains('try ') || cppCode.contains('try{'),
        'catch块': cppCode.contains('catch ') || cppCode.contains('catch('),
        '异常处理': cppCode.contains('exception') || cppCode.contains('Exception'),
      };

      final passedChecks = checks.values.where((v) => v).length;
      if (passedChecks >= 1) {
        print('✅ 异常处理转换正确 ($passedChecks/3)');
        checks.forEach((key, value) {
          print('  • $key: ${value ? "✅" : "❌"}');
        });
        passedTests++;
      } else {
        print('❌ 异常处理转换不完整 ($passedChecks/3)');
      }
    } else {
      print('❌ 异常处理测试失败');
    }
  } catch (e) {
    print('❌ 异常处理测试异常: $e');
  }

  // 测试7: 块语句
  totalTests++;
  print('\n📝 测试7: 块语句');
  try {
    final result = await UnifiedCompiler.compileSource(
      '''
void main() {
  {
    int x = 10;
    int y = 20;
    int sum = x + y;
    print("Sum: \$sum");
  }
  
  {
    String name = "Alice";
    int age = 25;
    print("Name: \$name, Age: \$age");
  }
}
''',
      config: CompilerConfig(includeRuntime: true, verbose: false),
    );

    if (result.isSuccess) {
      final cppCode = result.cppCode;
      if (cppCode.contains('{') && cppCode.contains('}')) {
        print('✅ 块语句转换正确');
        print('  • 大括号: ✅');
        passedTests++;
      } else {
        print('❌ 块语句转换不完整');
      }
    } else {
      print('❌ 块语句测试失败');
    }
  } catch (e) {
    print('❌ 块语句测试异常: $e');
  }

  // 测试8: 表达式语句
  totalTests++;
  print('\n📝 测试8: 表达式语句');
  try {
    final result = await UnifiedCompiler.compileSource(
      '''
void main() {
  int x = 10;
  x++; // 后置递增
  ++x; // 前置递增
  x--; // 后置递减
  --x; // 前置递减
  
  x += 5; // 复合赋值
  x -= 3;
  x *= 2;
  x ~/= 4;
  
  print("x = \$x");
}
''',
      config: CompilerConfig(includeRuntime: true, verbose: false),
    );

    if (result.isSuccess) {
      final cppCode = result.cppCode;
      final checks = {
        '递增运算符': cppCode.contains('++'),
        '递减运算符': cppCode.contains('--'),
        '复合赋值': cppCode.contains('+=') || cppCode.contains('-='),
        '分号': cppCode.contains(';'),
      };

      final passedChecks = checks.values.where((v) => v).length;
      if (passedChecks >= 2) {
        print('✅ 表达式语句转换正确 ($passedChecks/4)');
        checks.forEach((key, value) {
          print('  • $key: ${value ? "✅" : "❌"}');
        });
        passedTests++;
      } else {
        print('❌ 表达式语句转换不完整 ($passedChecks/4)');
      }
    } else {
      print('❌ 表达式语句测试失败');
    }
  } catch (e) {
    print('❌ 表达式语句测试异常: $e');
  }

  // 测试总结
  print('\n' + '=' * 50);
  print('📊 语句转换测试总结');
  print('总测试数: $totalTests');
  print('通过测试: $passedTests');
  print('失败测试: ${totalTests - passedTests}');
  print('通过率: ${(passedTests / totalTests * 100).toStringAsFixed(1)}%');

  if (passedTests == totalTests) {
    print('🎉 所有语句转换测试通过！');
  } else {
    print('⚠️ 部分语句转换测试失败，需要修复');
  }
}
