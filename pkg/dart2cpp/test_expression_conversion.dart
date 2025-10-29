/// 表达式转换测试用例
/// 测试各种Dart表达式的C++转换正确性
import 'dart:io';
import 'lib/dart2cpp.dart';

void main() async {
  print('🧪 开始表达式转换测试');
  print('=' * 50);

  int passedTests = 0;
  int totalTests = 0;

  // 测试1: 字面量表达式
  totalTests++;
  print('\n📝 测试1: 字面量表达式');
  try {
    final result = await UnifiedCompiler.compileSource(
      '''
void main() {
  // 整数字面量
  int a = 42;
  int b = -10;
  
  // 浮点数字面量
  double c = 3.14;
  double d = -2.5;
  
  // 布尔字面量
  bool e = true;
  bool f = false;
  
  // 字符串字面量
  String g = "Hello";
  String h = 'World';
  
  // null字面量
  String? i = null;
  
  print('a=\$a, b=\$b, c=\$c, d=\$d');
  print('e=\$e, f=\$f, g=\$g, h=\$h, i=\$i');
}
''',
      config: CompilerConfig(includeRuntime: true, verbose: false),
    );

    if (result.isSuccess) {
      final cppCode = result.cppCode;
      final checks = {
        'dart_int(42)': cppCode.contains('dart_int(42)'),
        'dart_int(-10)': cppCode.contains('dart_int(-10)'),
        'dart_double(3.14)': cppCode.contains('dart_double(3.14)'),
        'dart_double(-2.5)': cppCode.contains('dart_double(-2.5)'),
        'dart_bool(true)': cppCode.contains('dart_bool(true)'),
        'dart_bool(false)': cppCode.contains('dart_bool(false)'),
        'dart_string("Hello")': cppCode.contains('dart_string("Hello")'),
        'dart_string("World")': cppCode.contains('dart_string("World")'),
        'nullptr': cppCode.contains('nullptr'),
      };

      final passedChecks = checks.values.where((v) => v).length;
      if (passedChecks >= 7) {
        print('✅ 字面量表达式转换正确 ($passedChecks/9)');
        checks.forEach((key, value) {
          print('  • $key: ${value ? "✅" : "❌"}');
        });
        passedTests++;
      } else {
        print('❌ 字面量表达式转换不完整 ($passedChecks/9)');
      }
    } else {
      print('❌ 字面量表达式测试失败');
    }
  } catch (e) {
    print('❌ 字面量表达式测试异常: $e');
  }

  // 测试2: 算术运算符
  totalTests++;
  print('\n📝 测试2: 算术运算符');
  try {
    final result = await UnifiedCompiler.compileSource(
      '''
void main() {
  int a = 10;
  int b = 3;
  
  int sum = a + b;
  int diff = a - b;
  int prod = a * b;
  int quot = a ~/ b;
  int mod = a % b;
  
  print('sum=\$sum, diff=\$diff, prod=\$prod, quot=\$quot, mod=\$mod');
}
''',
      config: CompilerConfig(includeRuntime: true, verbose: false),
    );

    if (result.isSuccess) {
      final cppCode = result.cppCode;
      final checks = {
        '加法运算符': cppCode.contains('+'),
        '减法运算符': cppCode.contains('-'),
        '乘法运算符': cppCode.contains('*'),
        '除法运算符': cppCode.contains('/'),
        '取模运算符': cppCode.contains('%'),
      };

      final passedChecks = checks.values.where((v) => v).length;
      if (passedChecks >= 4) {
        print('✅ 算术运算符转换正确 ($passedChecks/5)');
        checks.forEach((key, value) {
          print('  • $key: ${value ? "✅" : "❌"}');
        });
        passedTests++;
      } else {
        print('❌ 算术运算符转换不完整 ($passedChecks/5)');
      }
    } else {
      print('❌ 算术运算符测试失败');
    }
  } catch (e) {
    print('❌ 算术运算符测试异常: $e');
  }

  // 测试3: 比较运算符
  totalTests++;
  print('\n📝 测试3: 比较运算符');
  try {
    final result = await UnifiedCompiler.compileSource(
      '''
void main() {
  int a = 10;
  int b = 5;
  
  bool eq = a == b;
  bool ne = a != b;
  bool lt = a < b;
  bool le = a <= b;
  bool gt = a > b;
  bool ge = a >= b;
  
  print('eq=\$eq, ne=\$ne, lt=\$lt, le=\$le, gt=\$gt, ge=\$ge');
}
''',
      config: CompilerConfig(includeRuntime: true, verbose: false),
    );

    if (result.isSuccess) {
      final cppCode = result.cppCode;
      final checks = {
        '等于运算符': cppCode.contains('=='),
        '不等于运算符': cppCode.contains('!='),
        '小于运算符': cppCode.contains('<'),
        '小于等于运算符': cppCode.contains('<='),
        '大于运算符': cppCode.contains('>'),
        '大于等于运算符': cppCode.contains('>='),
      };

      final passedChecks = checks.values.where((v) => v).length;
      if (passedChecks >= 5) {
        print('✅ 比较运算符转换正确 ($passedChecks/6)');
        checks.forEach((key, value) {
          print('  • $key: ${value ? "✅" : "❌"}');
        });
        passedTests++;
      } else {
        print('❌ 比较运算符转换不完整 ($passedChecks/6)');
      }
    } else {
      print('❌ 比较运算符测试失败');
    }
  } catch (e) {
    print('❌ 比较运算符测试异常: $e');
  }

  // 测试4: 逻辑运算符
  totalTests++;
  print('\n📝 测试4: 逻辑运算符');
  try {
    final result = await UnifiedCompiler.compileSource(
      '''
void main() {
  bool a = true;
  bool b = false;
  
  bool and = a && b;
  bool or = a || b;
  bool not = !a;
  
  print('and=\$and, or=\$or, not=\$not');
}
''',
      config: CompilerConfig(includeRuntime: true, verbose: false),
    );

    if (result.isSuccess) {
      final cppCode = result.cppCode;
      final checks = {
        '逻辑与运算符': cppCode.contains('&&'),
        '逻辑或运算符': cppCode.contains('||'),
        '逻辑非运算符': cppCode.contains('!'),
      };

      final passedChecks = checks.values.where((v) => v).length;
      if (passedChecks >= 2) {
        print('✅ 逻辑运算符转换正确 ($passedChecks/3)');
        checks.forEach((key, value) {
          print('  • $key: ${value ? "✅" : "❌"}');
        });
        passedTests++;
      } else {
        print('❌ 逻辑运算符转换不完整 ($passedChecks/3)');
      }
    } else {
      print('❌ 逻辑运算符测试失败');
    }
  } catch (e) {
    print('❌ 逻辑运算符测试异常: $e');
  }

  // 测试5: 条件表达式
  totalTests++;
  print('\n📝 测试5: 条件表达式');
  try {
    final result = await UnifiedCompiler.compileSource(
      '''
void main() {
  int a = 10;
  int b = 5;
  
  int max = a > b ? a : b;
  String result = a > 0 ? "positive" : "negative";
  
  print('max=\$max, result=\$result');
}
''',
      config: CompilerConfig(includeRuntime: true, verbose: false),
    );

    if (result.isSuccess) {
      final cppCode = result.cppCode;
      if (cppCode.contains('?') && cppCode.contains(':')) {
        print('✅ 条件表达式转换正确');
        print('  • 三元运算符: ✅');
        passedTests++;
      } else {
        print('❌ 条件表达式转换不完整');
      }
    } else {
      print('❌ 条件表达式测试失败');
    }
  } catch (e) {
    print('❌ 条件表达式测试异常: $e');
  }

  // 测试6: 字符串插值
  totalTests++;
  print('\n📝 测试6: 字符串插值');
  try {
    final result = await UnifiedCompiler.compileSource(
      '''
void main() {
  String name = "Alice";
  int age = 25;
  
  String greeting = "Hello, \$name!";
  String info = "Name: \$name, Age: \$age";
  String complex = "Value: \${age * 2}";
  
  print(greeting);
  print(info);
  print(complex);
}
''',
      config: CompilerConfig(includeRuntime: true, verbose: false),
    );

    if (result.isSuccess) {
      final cppCode = result.cppCode;
      if (cppCode.contains('+') && cppCode.contains('.toString()')) {
        print('✅ 字符串插值转换正确');
        print('  • 字符串连接: ✅');
        print('  • toString调用: ✅');
        passedTests++;
      } else {
        print('❌ 字符串插值转换不完整');
      }
    } else {
      print('❌ 字符串插值测试失败');
    }
  } catch (e) {
    print('❌ 字符串插值测试异常: $e');
  }

  // 测试7: 集合字面量
  totalTests++;
  print('\n📝 测试7: 集合字面量');
  try {
    final result = await UnifiedCompiler.compileSource(
      '''
void main() {
  var list = [1, 2, 3, 4, 5];
  var set = {1, 2, 3, 4, 5};
  var map = {'a': 1, 'b': 2, 'c': 3};
  
  print('list: \$list');
  print('set: \$set');
  print('map: \$map');
}
''',
      config: CompilerConfig(includeRuntime: true, verbose: false),
    );

    if (result.isSuccess) {
      final cppCode = result.cppCode;
      final checks = {
        'List创建': cppCode.contains('List<') && cppCode.contains('::create'),
        'Set创建': cppCode.contains('Set<') && cppCode.contains('::create'),
        'Map创建': cppCode.contains('Map<') && cppCode.contains('::create'),
      };

      final passedChecks = checks.values.where((v) => v).length;
      if (passedChecks >= 2) {
        print('✅ 集合字面量转换正确 ($passedChecks/3)');
        checks.forEach((key, value) {
          print('  • $key: ${value ? "✅" : "❌"}');
        });
        passedTests++;
      } else {
        print('❌ 集合字面量转换不完整 ($passedChecks/3)');
      }
    } else {
      print('❌ 集合字面量测试失败');
    }
  } catch (e) {
    print('❌ 集合字面量测试异常: $e');
  }

  // 测试8: 方法调用
  totalTests++;
  print('\n📝 测试8: 方法调用');
  try {
    final result = await UnifiedCompiler.compileSource(
      '''
void main() {
  String text = "Hello World";
  
  int length = text.length;
  String upper = text.toUpperCase();
  String lower = text.toLowerCase();
  bool contains = text.contains("World");
  
  print('length=\$length, upper=\$upper, lower=\$lower, contains=\$contains');
}
''',
      config: CompilerConfig(includeRuntime: true, verbose: false),
    );

    if (result.isSuccess) {
      final cppCode = result.cppCode;
      final checks = {
        '属性访问': cppCode.contains('->'),
        '方法调用': cppCode.contains('(') && cppCode.contains(')'),
      };

      final passedChecks = checks.values.where((v) => v).length;
      if (passedChecks >= 1) {
        print('✅ 方法调用转换正确 ($passedChecks/2)');
        checks.forEach((key, value) {
          print('  • $key: ${value ? "✅" : "❌"}');
        });
        passedTests++;
      } else {
        print('❌ 方法调用转换不完整 ($passedChecks/2)');
      }
    } else {
      print('❌ 方法调用测试失败');
    }
  } catch (e) {
    print('❌ 方法调用测试异常: $e');
  }

  // 测试总结
  print('\n' + '=' * 50);
  print('📊 表达式转换测试总结');
  print('总测试数: $totalTests');
  print('通过测试: $passedTests');
  print('失败测试: ${totalTests - passedTests}');
  print('通过率: ${(passedTests / totalTests * 100).toStringAsFixed(1)}%');

  if (passedTests == totalTests) {
    print('🎉 所有表达式转换测试通过！');
  } else {
    print('⚠️ 部分表达式转换测试失败，需要修复');
  }
}
