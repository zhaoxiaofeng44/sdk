/// 基础语法演示
/// 
/// 测试所有基本的 Dart 语法结构

void main() {
  print('🔥 基础语法演示开始');
  
  // 1. 基本数据类型
  testBasicTypes();
  
  // 2. 变量声明
  testVariableDeclarations();
  
  // 3. 运算符
  testOperators();
  
  // 4. 控制流
  testControlFlow();
  
  // 5. 函数
  testFunctions();
  
  print('✅ 基础语法演示完成');
}

/// 测试基本数据类型
void testBasicTypes() {
  print('\n📌 测试基本数据类型');
  
  // 整数
  int intValue = 42;
  int hexValue = 0xFF;
  int binaryValue = 0b1010;
  
  // 浮点数
  double doubleValue = 3.14159;
  double scientificValue = 1.42e5;
  
  // 布尔值
  bool trueValue = true;
  bool falseValue = false;
  
  // 字符串
  String singleQuote = 'Hello';
  String doubleQuote = "World";
  String multiLine = '''
    This is a
    multi-line string
  ''';
  
  // 字符串插值
  String interpolation = 'The answer is ${intValue}';
  String expression = 'Sum: ${intValue + doubleValue}';
  
  print('  整数: $intValue, 十六进制: $hexValue, 二进制: $binaryValue');
  print('  浮点数: $doubleValue, 科学计数法: $scientificValue');
  print('  布尔值: $trueValue, $falseValue');
  print('  字符串: $singleQuote $doubleQuote');
  print('  插值: $interpolation');
  print('  表达式: $expression');
}

/// 测试变量声明
void testVariableDeclarations() {
  print('\n📌 测试变量声明');
  
  // var 声明
  var autoInt = 100;
  var autoString = 'auto';
  
  // final 声明
  final finalValue = 'cannot change';
  final int typedFinal = 200;
  
  // const 声明
  const constValue = 'compile time constant';
  const double pi = 3.14159;
  
  // 可空类型
  int? nullableInt;
  String? nullableString = null;
  
  // 非空断言
  String nonNull = nullableString ?? 'default';
  
  print('  var: $autoInt, $autoString');
  print('  final: $finalValue, $typedFinal');
  print('  const: $constValue, $pi');
  print('  nullable: $nullableInt, $nullableString');
  print('  non-null: $nonNull');
}

/// 测试运算符
void testOperators() {
  print('\n📌 测试运算符');
  
  int a = 10, b = 3;
  
  // 算术运算符
  print('  算术: ${a + b}, ${a - b}, ${a * b}, ${a / b}, ${a % b}');
  print('  整除: ${a ~/ b}');
  
  // 比较运算符
  print('  比较: ${a == b}, ${a != b}, ${a > b}, ${a < b}, ${a >= b}, ${a <= b}');
  
  // 逻辑运算符
  bool x = true, y = false;
  print('  逻辑: ${x && y}, ${x || y}, ${!x}');
  
  // 位运算符
  print('  位运算: ${a & b}, ${a | b}, ${a ^ b}, ${~a}, ${a << 1}, ${a >> 1}');
  
  // 赋值运算符
  int c = 5;
  c += 2;
  print('  赋值后: $c');
  
  // 条件运算符
  String result = a > b ? 'a is greater' : 'b is greater';
  print('  三元: $result');
  
  // 空值合并
  String? nullable;
  String safe = nullable ?? 'default value';
  print('  空值合并: $safe');
}

/// 测试控制流
void testControlFlow() {
  print('\n📌 测试控制流');
  
  // if-else
  int score = 85;
  if (score >= 90) {
    print('  成绩: 优秀');
  } else if (score >= 80) {
    print('  成绩: 良好');
  } else if (score >= 70) {
    print('  成绩: 中等');
  } else {
    print('  成绩: 需要努力');
  }
  
  // switch-case
  String grade = 'B';
  switch (grade) {
    case 'A':
      print('  等级: 优秀');
      break;
    case 'B':
      print('  等级: 良好');
      break;
    case 'C':
      print('  等级: 中等');
      break;
    default:
      print('  等级: 未知');
  }
  
  // for 循环
  print('  for循环:');
  for (int i = 0; i < 3; i++) {
    print('    索引: $i');
  }
  
  // for-in 循环
  List<String> fruits = ['apple', 'banana', 'orange'];
  print('  for-in循环:');
  for (String fruit in fruits) {
    print('    水果: $fruit');
  }
  
  // while 循环
  print('  while循环:');
  int count = 0;
  while (count < 3) {
    print('    计数: $count');
    count++;
  }
  
  // do-while 循环
  print('  do-while循环:');
  int num = 0;
  do {
    print('    数字: $num');
    num++;
  } while (num < 2);
  
  // break 和 continue
  print('  break和continue:');
  for (int i = 0; i < 5; i++) {
    if (i == 2) continue;
    if (i == 4) break;
    print('    处理: $i');
  }
}

/// 测试函数
void testFunctions() {
  print('\n📌 测试函数');
  
  // 普通函数调用
  int sum = add(5, 3);
  print('  加法: $sum');
  
  // 可选参数
  greet('Alice');
  greet('Bob', 'Mr.');
  
  // 命名参数
  createUser(name: 'Charlie', age: 25);
  createUser(name: 'David', age: 30, email: 'david@example.com');
  
  // 匿名函数
  var multiply = (int a, int b) => a * b;
  print('  匿名函数: ${multiply(4, 5)}');
  
  // 高阶函数
  var numbers = [1, 2, 3, 4, 5];
  var doubled = numbers.map((n) => n * 2).toList();
  print('  高阶函数: $doubled');
  
  // 闭包
  var counter = createCounter();
  print('  闭包: ${counter()}, ${counter()}, ${counter()}');
}

/// 普通函数
int add(int a, int b) {
  return a + b;
}

/// 可选位置参数
void greet(String name, [String? title]) {
  if (title != null) {
    print('  问候: Hello, $title $name');
  } else {
    print('  问候: Hello, $name');
  }
}

/// 命名参数
void createUser({required String name, required int age, String? email}) {
  print('  用户: $name, 年龄: $age${email != null ? ', 邮箱: $email' : ''}');
}

/// 闭包示例
Function createCounter() {
  int count = 0;
  return () {
    count++;
    return count;
  };
}