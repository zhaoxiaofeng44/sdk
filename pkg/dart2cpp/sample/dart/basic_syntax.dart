/// 基础语法测试用例
/// 
/// 测试Dart基础语法特性，包括：
/// - 变量声明和数据类型
/// - 运算符
/// - 控制流语句
/// - 字符串操作
/// - 基本函数

void main() {
  print('🔥 基础语法测试开始');
  
  // 1. 基本数据类型测试
  testBasicTypes();
  
  // 2. 变量声明测试
  testVariableDeclarations();
  
  // 3. 运算符测试
  testOperators();
  
  // 4. 控制流测试
  testControlFlow();
  
  // 5. 字符串操作测试
  testStringOperations();
  
  // 6. 函数测试
  testFunctions();
  
  print('✅ 基础语法测试完成');
}

/// 测试基本数据类型
void testBasicTypes() {
  print('\n📌 测试基本数据类型');
  
  // 整数类型
  int intValue = 42;
  int hexValue = 0xFF;
  int negativeInt = -10;
  int zero = 0;
  
  // 浮点数类型
  double doubleValue = 3.14159;
  double scientificValue = 1.42e5;
  double negativeDouble = -2.5;
  
  // 布尔类型
  bool trueValue = true;
  bool falseValue = false;
  
  // 字符串类型
  String singleQuote = 'Hello';
  String doubleQuote = "World";
  String emptyString = '';
  String multiLine = '''
    This is a
    multi-line string
  ''';
  
  // 字符串插值
  String interpolation = 'The answer is ${intValue}';
  String expression = 'Sum: ${intValue + doubleValue}';
  
  print('  整数: $intValue, 十六进制: $hexValue, 负数: $negativeInt, 零: $zero');
  print('  浮点数: $doubleValue, 科学计数法: $scientificValue, 负数: $negativeDouble');
  print('  布尔值: $trueValue, $falseValue');
  print('  字符串: $singleQuote $doubleQuote');
  print('  插值: $interpolation');
  print('  表达式: $expression');
  print('  多行字符串长度: ${multiLine.length}');
}

/// 测试变量声明
void testVariableDeclarations() {
  print('\n📌 测试变量声明');
  
  // var 声明（类型推断）
  var autoInt = 100;
  var autoString = 'auto';
  var autoDouble = 3.14;
  var autoBool = true;
  
  // final 声明（运行时常量）
  final finalValue = 'cannot change';
  final int typedFinal = 200;
  final DateTime now = DateTime.now();
  
  // const 声明（编译时常量）
  const constValue = 'compile time constant';
  const double pi = 3.14159;
  const int maxValue = 100;
  
  // 可空类型
  int? nullableInt;
  String? nullableString = null;
  double? nullableDouble;
  
  // 非空断言和空值合并
  String nonNull = nullableString ?? 'default';
  nullableInt ??= 42;
  
  print('  var: $autoInt, $autoString, $autoDouble, $autoBool');
  print('  final: $finalValue, $typedFinal');
  print('  const: $constValue, $pi, $maxValue');
  print('  nullable: $nullableInt, $nullableString, $nullableDouble');
  print('  non-null: $nonNull');
}

/// 测试运算符
void testOperators() {
  print('\n📌 测试运算符');
  
  int a = 10, b = 3;
  double x = 5.5, y = 2.2;
  
  // 算术运算符
  print('  算术运算:');
  print('    ${a} + ${b} = ${a + b}');
  print('    ${a} - ${b} = ${a - b}');
  print('    ${a} * ${b} = ${a * b}');
  print('    ${a} / ${b} = ${a / b}');
  print('    ${a} % ${b} = ${a % b}');
  print('    ${a} ~/ ${b} = ${a ~/ b}');
  print('    -${a} = ${-a}');
  
  // 比较运算符
  print('  比较运算:');
  print('    ${a} == ${b}: ${a == b}');
  print('    ${a} != ${b}: ${a != b}');
  print('    ${a} > ${b}: ${a > b}');
  print('    ${a} < ${b}: ${a < b}');
  print('    ${a} >= ${b}: ${a >= b}');
  print('    ${a} <= ${b}: ${a <= b}');
  
  // 逻辑运算符
  bool p = true, q = false;
  print('  逻辑运算:');
  print('    ${p} && ${q}: ${p && q}');
  print('    ${p} || ${q}: ${p || q}');
  print('    !${p}: ${!p}');
  print('    !${q}: ${!q}');
  
  // 位运算符
  int m = 12, n = 5; // 1100, 0101
  print('  位运算:');
  print('    ${m} & ${n}: ${m & n}');
  print('    ${m} | ${n}: ${m | n}');
  print('    ${m} ^ ${n}: ${m ^ n}');
  print('    ~${m}: ${~m}');
  print('    ${m} << 1: ${m << 1}');
  print('    ${m} >> 1: ${m >> 1}');
  
  // 赋值运算符
  int c = 5;
  c += 2;
  print('  赋值运算: c += 2 结果: $c');
  c -= 1;
  print('  赋值运算: c -= 1 结果: $c');
  c *= 3;
  print('  赋值运算: c *= 3 结果: $c');
  c ~/= 2;
  print('  赋值运算: c ~/= 2 结果: $c');
  
  // 条件运算符
  String result = a > b ? 'a is greater' : 'b is greater';
  print('  三元运算符: $result');
  
  // 空值合并运算符
  String? nullable;
  String safe = nullable ?? 'default value';
  print('  空值合并: $safe');
}

/// 测试控制流
void testControlFlow() {
  print('\n📌 测试控制流');
  
  // if-else 语句
  int score = 85;
  print('  if-else 测试:');
  if (score >= 90) {
    print('    成绩: 优秀');
  } else if (score >= 80) {
    print('    成绩: 良好');
  } else if (score >= 70) {
    print('    成绩: 中等');
  } else {
    print('    成绩: 需要努力');
  }
  
  // switch-case 语句
  String grade = 'B';
  print('  switch-case 测试:');
  switch (grade) {
    case 'A':
      print('    等级: 优秀');
      break;
    case 'B':
      print('    等级: 良好');
      break;
    case 'C':
      print('    等级: 中等');
      break;
    default:
      print('    等级: 未知');
  }
  
  // for 循环
  print('  for 循环测试:');
  for (int i = 0; i < 5; i++) {
    print('    索引: $i, 值: ${i * i}');
  }
  
  // for-in 循环
  List<String> fruits = ['apple', 'banana', 'orange'];
  print('  for-in 循环测试:');
  for (String fruit in fruits) {
    print('    水果: $fruit');
  }
  
  // while 循环
  print('  while 循环测试:');
  int count = 0;
  while (count < 3) {
    print('    计数: $count');
    count++;
  }
  
  // do-while 循环
  print('  do-while 循环测试:');
  int num = 0;
  do {
    print('    数字: $num');
    num++;
  } while (num < 3);
  
  // break 和 continue
  print('  break 和 continue 测试:');
  for (int i = 0; i < 10; i++) {
    if (i == 2) continue;
    if (i == 7) break;
    print('    处理: $i');
  }
}

/// 测试字符串操作
void testStringOperations() {
  print('\n📌 测试字符串操作');
  
  String str1 = 'Hello';
  String str2 = 'World';
  String str3 = '  Dart Programming  ';
  
  // 字符串连接
  String concat = str1 + ' ' + str2;
  print('  连接: $concat');
  
  // 字符串插值
  int value = 42;
  String interpolated = 'The answer is $value';
  String expression = 'Sum: ${10 + 20}';
  print('  插值: $interpolated');
  print('  表达式插值: $expression');
  
  // 字符串属性
  print('  字符串属性:');
  print('    长度: ${str1.length}');
  print('    是否为空: ${"".isEmpty}');
  print('    是否不为空: ${str1.isNotEmpty}');
  
  // 字符串方法
  print('  字符串方法:');
  print('    大写: ${str1.toUpperCase()}');
  print('    小写: ${str2.toLowerCase()}');
  print('    去空格: "${str3.trim()}"');
  print('    子字符串: ${str1.substring(0, 4)}');
  print('    包含: ${str1.contains("ell")}');
  print('    开始于: ${str1.startsWith("He")}');
  print('    结束于: ${str1.endsWith("lo")}');
  print('    索引: ${str1.indexOf("l")}');
  print('    替换: ${str1.replaceAll("l", "L")}');
  print('    分割: ${concat.split(" ")}');
  
  // 字符串比较
  print('  字符串比较:');
  print('    相等: ${str1 == "Hello"}');
  print('    比较: ${str1.compareTo(str2)}');
  
  // 多行字符串
  String multiLine = '''
    第一行
    第二行
    第三行
  ''';
  print('  多行字符串行数: ${multiLine.split('\n').length}');
}

/// 测试函数
void testFunctions() {
  print('\n📌 测试函数');
  
  // 普通函数调用
  int sum = add(5, 3);
  print('  加法函数: add(5, 3) = $sum');
  
  // 可选位置参数
  greet('Alice');
  greet('Bob', 'Mr.');
  
  // 命名参数
  createUser(name: 'Charlie', age: 25);
  createUser(name: 'David', age: 30, email: 'david@example.com');
  
  // 匿名函数
  var multiply = (int a, int b) => a * b;
  print('  匿名函数: multiply(4, 5) = ${multiply(4, 5)}');
  
  // 箭头函数
  var square = (int x) => x * x;
  print('  箭头函数: square(6) = ${square(6)}');
  
  // 高阶函数
  var numbers = [1, 2, 3, 4, 5];
  var doubled = numbers.map((n) => n * 2).toList();
  print('  高阶函数 map: $doubled');
  
  var evens = numbers.where((n) => n % 2 == 0).toList();
  print('  高阶函数 where: $evens');
  
  // 函数作为参数
  int result = calculate(10, 5, add);
  print('  函数作为参数: calculate(10, 5, add) = $result');
  
  result = calculate(10, 5, subtract);
  print('  函数作为参数: calculate(10, 5, subtract) = $result');
}

// ============================================================================
// 辅助函数定义
// ============================================================================

/// 加法函数
int add(int a, int b) {
  return a + b;
}

/// 减法函数
int subtract(int a, int b) {
  return a - b;
}

/// 问候函数（可选位置参数）
void greet(String name, [String? title]) {
  if (title != null) {
    print('  问候: Hello, $title $name!');
  } else {
    print('  问候: Hello, $name!');
  }
}

/// 创建用户函数（命名参数）
void createUser({required String name, required int age, String? email}) {
  print('  创建用户: $name, $age岁${email != null ? ', 邮箱: $email' : ''}');
}

/// 计算函数（函数作为参数）
int calculate(int a, int b, int Function(int, int) operation) {
  return operation(a, b);
}
