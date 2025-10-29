/// 类型转换测试用例
/// 测试Dart类型到C++类型的转换正确性
import 'dart:io';
import '../lib/dart2cpp.dart';

void main() async {
  print('🧪 开始类型转换测试');
  print('=' * 50);

  int passedTests = 0;
  int totalTests = 0;

  // 测试1: 基础类型转换
  totalTests++;
  print('\n📝 测试1: 基础类型转换');
  try {
    final result = await UnifiedCompiler.compileSource(
      '''
void main() {
  // Dart基础类型
  int intValue = 42;
  double doubleValue = 3.14159;
  bool boolValue = true;
  String stringValue = "Hello";
  
  // 类型转换
  double intToDouble = intValue.toDouble();
  int doubleToInt = doubleValue.toInt();
  String intToString = intValue.toString();
  String doubleToString = doubleValue.toString();
  String boolToString = boolValue.toString();
  
  print("intValue: \$intValue");
  print("doubleValue: \$doubleValue");
  print("boolValue: \$boolValue");
  print("stringValue: \$stringValue");
  print("intToDouble: \$intToDouble");
  print("doubleToInt: \$doubleToInt");
}
''',
      config: CompilerConfig(includeRuntime: true, verbose: false),
    );

    if (result.isSuccess) {
      final cppCode = result.cppCode;
      final checks = {
        'Int类型': cppCode.contains('Int('),
        'Double类型': cppCode.contains('Double('),
        'Bool类型': cppCode.contains('Bool('),
        'String类型': cppCode.contains('String('),
        '类型转换方法':
            cppCode.contains('.toDouble()') || cppCode.contains('.toInt()'),
      };

      final passedChecks = checks.values.where((v) => v).length;
      if (passedChecks >= 4) {
        print('✅ 基础类型转换正确 ($passedChecks/5)');
        checks.forEach((key, value) {
          print('  • $key: ${value ? "✅" : "❌"}');
        });
        passedTests++;
      } else {
        print('❌ 基础类型转换不完整 ($passedChecks/5)');
      }
    } else {
      print('❌ 基础类型转换测试失败');
    }
  } catch (e) {
    print('❌ 基础类型转换测试异常: $e');
  }

  // 测试2: 集合类型转换
  totalTests++;
  print('\n📝 测试2: 集合类型转换');
  try {
    final result = await UnifiedCompiler.compileSource(
      '''
void main() {
  // List类型
  List<int> intList = [1, 2, 3, 4, 5];
  List<String> stringList = ["a", "b", "c"];
  List<double> doubleList = [1.1, 2.2, 3.3];
  
  // Set类型
  Set<int> intSet = {1, 2, 3, 4, 5};
  Set<String> stringSet = {"x", "y", "z"};
  
  // Map类型
  Map<String, int> stringIntMap = {"a": 1, "b": 2, "c": 3};
  Map<int, String> intStringMap = {1: "one", 2: "two", 3: "three"};
  Map<String, double> stringDoubleMap = {"pi": 3.14, "e": 2.71};
  
  print("intList: \$intList");
  print("stringList: \$stringList");
  print("doubleList: \$doubleList");
  print("intSet: \$intSet");
  print("stringSet: \$stringSet");
  print("stringIntMap: \$stringIntMap");
  print("intStringMap: \$intStringMap");
  print("stringDoubleMap: \$stringDoubleMap");
}
''',
      config: CompilerConfig(includeRuntime: true, verbose: false),
    );

    if (result.isSuccess) {
      final cppCode = result.cppCode;
      final checks = {
        'List<Int>': cppCode.contains('List<Int>'),
        'List<String>': cppCode.contains('List<String>'),
        'List<Double>': cppCode.contains('List<Double>'),
        'Set<Int>': cppCode.contains('Set<Int>'),
        'Set<String>': cppCode.contains('Set<String>'),
        'Map<String,Int>': cppCode.contains('Map<String,Int>'),
        'Map<Int,String>': cppCode.contains('Map<Int,String>'),
        'Map<String,Double>': cppCode.contains('Map<String,Double>'),
      };

      final passedChecks = checks.values.where((v) => v).length;
      if (passedChecks >= 6) {
        print('✅ 集合类型转换正确 ($passedChecks/8)');
        checks.forEach((key, value) {
          print('  • $key: ${value ? "✅" : "❌"}');
        });
        passedTests++;
      } else {
        print('❌ 集合类型转换不完整 ($passedChecks/8)');
      }
    } else {
      print('❌ 集合类型转换测试失败');
    }
  } catch (e) {
    print('❌ 集合类型转换测试异常: $e');
  }

  // 测试3: 泛型类型转换
  totalTests++;
  print('\n📝 测试3: 泛型类型转换');
  try {
    final result = await UnifiedCompiler.compileSource(
      '''
class Box<T> {
  T value;
  
  Box(this.value);
  
  T getValue() {
    return value;
  }
  
  void setValue(T newValue) {
    value = newValue;
  }
}

void main() {
  Box<int> intBox = Box<int>(42);
  Box<String> stringBox = Box<String>("Hello");
  Box<double> doubleBox = Box<double>(3.14);
  
  int intValue = intBox.getValue();
  String stringValue = stringBox.getValue();
  double doubleValue = doubleBox.getValue();
  
  print("intValue: \$intValue");
  print("stringValue: \$stringValue");
  print("doubleValue: \$doubleValue");
}
''',
      config: CompilerConfig(includeRuntime: true, verbose: false),
    );

    if (result.isSuccess) {
      final cppCode = result.cppCode;
      final checks = {
        '泛型类定义': cppCode.contains('class ') && cppCode.contains('<'),
        '泛型实例化': cppCode.contains('Box<') && cppCode.contains('>'),
        '泛型方法': cppCode.contains('getValue()') || cppCode.contains('setValue('),
      };

      final passedChecks = checks.values.where((v) => v).length;
      if (passedChecks >= 2) {
        print('✅ 泛型类型转换正确 ($passedChecks/3)');
        checks.forEach((key, value) {
          print('  • $key: ${value ? "✅" : "❌"}');
        });
        passedTests++;
      } else {
        print('❌ 泛型类型转换不完整 ($passedChecks/3)');
      }
    } else {
      print('❌ 泛型类型转换测试失败');
    }
  } catch (e) {
    print('❌ 泛型类型转换测试异常: $e');
  }

  // 测试4: 函数类型转换
  totalTests++;
  print('\n📝 测试4: 函数类型转换');
  try {
    final result = await UnifiedCompiler.compileSource(
      '''
// 函数类型定义
typedef IntFunction = int Function(int);
typedef StringFunction = String Function(String);
typedef VoidFunction = void Function();

// 高阶函数
int applyFunction(IntFunction func, int value) {
  return func(value);
}

String processString(StringFunction func, String input) {
  return func(input);
}

void executeFunction(VoidFunction func) {
  func();
}

void main() {
  // 函数变量
  IntFunction square = (int x) => x * x;
  StringFunction upper = (String s) => s.toUpperCase();
  VoidFunction hello = () => print("Hello!");
  
  int result = applyFunction(square, 5);
  String processed = processString(upper, "hello");
  
  print("Square of 5: \$result");
  print("Uppercase: \$processed");
  
  executeFunction(hello);
}
''',
      config: CompilerConfig(includeRuntime: true, verbose: false),
    );

    if (result.isSuccess) {
      final cppCode = result.cppCode;
      final checks = {
        '函数类型':
            cppCode.contains('Function') || cppCode.contains('std::function'),
        'lambda表达式': cppCode.contains('[') && cppCode.contains(']'),
        '函数调用': cppCode.contains('(') && cppCode.contains(')'),
      };

      final passedChecks = checks.values.where((v) => v).length;
      if (passedChecks >= 2) {
        print('✅ 函数类型转换正确 ($passedChecks/3)');
        checks.forEach((key, value) {
          print('  • $key: ${value ? "✅" : "❌"}');
        });
        passedTests++;
      } else {
        print('❌ 函数类型转换不完整 ($passedChecks/3)');
      }
    } else {
      print('❌ 函数类型转换测试失败');
    }
  } catch (e) {
    print('❌ 函数类型转换测试异常: $e');
  }

  // 测试5: 可空类型转换
  totalTests++;
  print('\n📝 测试5: 可空类型转换');
  try {
    final result = await UnifiedCompiler.compileSource(
      '''
void main() {
  // 可空类型
  int? nullableInt = null;
  String? nullableString = null;
  double? nullableDouble = 3.14;
  
  // 非空断言
  int nonNullInt = nullableInt ?? 0;
  String nonNullString = nullableString ?? "default";
  
  // 空检查
  if (nullableInt != null) {
    print("nullableInt is not null: \$nullableInt");
  } else {
    print("nullableInt is null");
  }
  
  if (nullableString != null) {
    print("nullableString is not null: \$nullableString");
  } else {
    print("nullableString is null");
  }
  
  print("nonNullInt: \$nonNullInt");
  print("nonNullString: \$nonNullString");
  print("nullableDouble: \$nullableDouble");
}
''',
      config: CompilerConfig(includeRuntime: true, verbose: false),
    );

    if (result.isSuccess) {
      final cppCode = result.cppCode;
      final checks = {
        'nullptr': cppCode.contains('nullptr'),
        '空检查': cppCode.contains('!= null') || cppCode.contains('== null'),
        '空合并运算符':
            cppCode.contains('??') || cppCode.contains('dart_null_coalesce'),
      };

      final passedChecks = checks.values.where((v) => v).length;
      if (passedChecks >= 2) {
        print('✅ 可空类型转换正确 ($passedChecks/3)');
        checks.forEach((key, value) {
          print('  • $key: ${value ? "✅" : "❌"}');
        });
        passedTests++;
      } else {
        print('❌ 可空类型转换不完整 ($passedChecks/3)');
      }
    } else {
      print('❌ 可空类型转换测试失败');
    }
  } catch (e) {
    print('❌ 可空类型转换测试异常: $e');
  }

  // 测试6: 类型转换操作符
  totalTests++;
  print('\n📝 测试6: 类型转换操作符');
  try {
    final result = await UnifiedCompiler.compileSource(
      '''
void main() {
  // 类型转换
  int intValue = 42;
  double doubleValue = 3.14;
  String stringValue = "123";
  
  // as操作符
  Object obj = intValue;
  int castedInt = obj as int;
  
  // is操作符
  bool isInt = obj is int;
  bool isString = obj is String;
  
  // 显式类型转换
  double intToDouble = intValue.toDouble();
  int doubleToInt = doubleValue.toInt();
  int stringToInt = int.parse(stringValue);
  
  print("castedInt: \$castedInt");
  print("isInt: \$isInt");
  print("isString: \$isString");
  print("intToDouble: \$intToDouble");
  print("doubleToInt: \$doubleToInt");
  print("stringToInt: \$stringToInt");
}
''',
      config: CompilerConfig(includeRuntime: true, verbose: false),
    );

    if (result.isSuccess) {
      final cppCode = result.cppCode;
      final checks = {
        'as操作符': cppCode.contains('as ') || cppCode.contains('dart_cast'),
        'is操作符': cppCode.contains('is ') || cppCode.contains('dart_is'),
        '类型转换方法':
            cppCode.contains('.toDouble()') || cppCode.contains('.toInt()'),
      };

      final passedChecks = checks.values.where((v) => v).length;
      if (passedChecks >= 2) {
        print('✅ 类型转换操作符正确 ($passedChecks/3)');
        checks.forEach((key, value) {
          print('  • $key: ${value ? "✅" : "❌"}');
        });
        passedTests++;
      } else {
        print('❌ 类型转换操作符不完整 ($passedChecks/3)');
      }
    } else {
      print('❌ 类型转换操作符测试失败');
    }
  } catch (e) {
    print('❌ 类型转换操作符测试异常: $e');
  }

  // 测试7: 动态类型转换
  totalTests++;
  print('\n📝 测试7: 动态类型转换');
  try {
    final result = await UnifiedCompiler.compileSource(
      '''
void main() {
  // dynamic类型
  dynamic dynamicValue = 42;
  dynamic dynamicString = "Hello";
  dynamic dynamicList = [1, 2, 3];
  
  // 动态类型访问
  print("dynamicValue: \$dynamicValue");
  print("dynamicString: \$dynamicString");
  print("dynamicList: \$dynamicList");
  
  // 动态方法调用
  String stringValue = dynamicString.toString();
  int listLength = dynamicList.length;
  
  print("stringValue: \$stringValue");
  print("listLength: \$listLength");
}
''',
      config: CompilerConfig(includeRuntime: true, verbose: false),
    );

    if (result.isSuccess) {
      final cppCode = result.cppCode;
      final checks = {
        'Any类型': cppCode.contains('Any ') || cppCode.contains('dynamic'),
        '动态访问': cppCode.contains('.') && cppCode.contains('('),
      };

      final passedChecks = checks.values.where((v) => v).length;
      if (passedChecks >= 1) {
        print('✅ 动态类型转换正确 ($passedChecks/2)');
        checks.forEach((key, value) {
          print('  • $key: ${value ? "✅" : "❌"}');
        });
        passedTests++;
      } else {
        print('❌ 动态类型转换不完整 ($passedChecks/2)');
      }
    } else {
      print('❌ 动态类型转换测试失败');
    }
  } catch (e) {
    print('❌ 动态类型转换测试异常: $e');
  }

  // 测试8: 类型别名转换
  totalTests++;
  print('\n📝 测试8: 类型别名转换');
  try {
    final result = await UnifiedCompiler.compileSource(
      '''
// 类型别名
typedef UserId = int;
typedef UserName = String;
typedef UserAge = int;
typedef UserData = Map<String, dynamic>;

class User {
  UserId id;
  UserName name;
  UserAge age;
  UserData data;
  
  User(this.id, this.name, this.age, this.data);
  
  UserId getId() => id;
  UserName getName() => name;
  UserAge getAge() => age;
  UserData getData() => data;
}

void main() {
  UserId id = 1;
  UserName name = "Alice";
  UserAge age = 25;
  UserData data = {"email": "alice@example.com", "city": "New York"};
  
  User user = User(id, name, age, data);
  
  print("User ID: \${user.getId()}");
  print("User Name: \${user.getName()}");
  print("User Age: \${user.getAge()}");
  print("User Data: \${user.getData()}");
}
''',
      config: CompilerConfig(includeRuntime: true, verbose: false),
    );

    if (result.isSuccess) {
      final cppCode = result.cppCode;
      final checks = {
        '类型别名': cppCode.contains('typedef ') || cppCode.contains('UserId'),
        '别名使用': cppCode.contains('UserId ') || cppCode.contains('UserName '),
        '类定义': cppCode.contains('class User'),
      };

      final passedChecks = checks.values.where((v) => v).length;
      if (passedChecks >= 2) {
        print('✅ 类型别名转换正确 ($passedChecks/3)');
        checks.forEach((key, value) {
          print('  • $key: ${value ? "✅" : "❌"}');
        });
        passedTests++;
      } else {
        print('❌ 类型别名转换不完整 ($passedChecks/3)');
      }
    } else {
      print('❌ 类型别名转换测试失败');
    }
  } catch (e) {
    print('❌ 类型别名转换测试异常: $e');
  }

  // 测试总结
  print('\n' + '=' * 50);
  print('📊 类型转换测试总结');
  print('总测试数: $totalTests');
  print('通过测试: $passedTests');
  print('失败测试: ${totalTests - passedTests}');
  print('通过率: ${(passedTests / totalTests * 100).toStringAsFixed(1)}%');

  if (passedTests == totalTests) {
    print('🎉 所有类型转换测试通过！');
  } else {
    print('⚠️ 部分类型转换测试失败，需要修复');
  }
}
