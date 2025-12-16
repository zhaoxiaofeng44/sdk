/// Dart 更多增强语法测试示例
///
/// 包含更全面的Dart语法特性，用于测试Dart到C++的转换
///

void main() {
  print('🔥 Dart 更多增强语法测试开始');

  // 1. 基本数据类型和操作
  testDataTypes();

  // 2. 控制流增强
  testMoreControlFlow();

  // 3. 函数增强
  testMoreFunctions();

  // 4. 集合增强
  testMoreCollections();

  // 5. 类增强
  testMoreClasses();

  // 6. 泛型增强
  testMoreGenerics();

  // 7. 异常处理
  testExceptionHandling();

  // 8. 空安全特性
  testNullSafety();

  // 9. 高级特性
  testAdvancedFeatures();

  print('✅ Dart 更多增强语法测试完成');
}

/// 测试数据类型和操作
void testDataTypes() {
  print('\n--- 数据类型和操作 ---');

  // 基本类型
  int age = 25;
  double price = 99.99;
  String name = '张三';
  bool isStudent = true;

  // 字符串插值
  String info = '姓名: $name, 年龄: $age';
  String formatted = '价格: ${price.toStringAsFixed(2)}';

  // 字符串方法
  String upper = name.toUpperCase();
  String lower = name.toLowerCase();
  int strLength = name.length;

  // 数值方法
  String ageStr = age.toString();
  int priceInt = price.toInt();
  double ageDouble = age.toDouble();

  print('数据类型操作完成');
}

/// 测试更多控制流
void testMoreControlFlow() {
  print('\n--- 更多控制流 ---');

  // switch 语句（增强）
  int score = 85;
  switch (score) {
    case 100:
    case 99:
    case 98:
      print('满分');
      break;
    case 90:
    case 89:
    case 88:
    case 87:
    case 86:
    case 85:
      print('优秀');
      break;
    default:
      print('其他分数');
  }

  // for 循环（不同形式）
  print('倒序循环:');
  for (int i = 5; i >= 1; i--) {
    print('数字: $i');
  }

  // for-in 循环
  List<String> fruits = ['苹果', '香蕉', '橙子'];
  print('水果列表:');
  for (String fruit in fruits) {
    print('  $fruit');
  }

  // while 和 do-while
  int counter = 0;
  while (counter < 3) {
    print('While循环: $counter');
    counter++;
  }

  int doCounter = 0;
  do {
    print('Do-while循环: $doCounter');
    doCounter++;
  } while (doCounter < 3);

  // 条件表达式
  int testAge = 20;
  String description = testAge >= 18 ? '成年人' : '未成年人';
  print('年龄描述: $description');
}

/// 测试更多函数特性
void testMoreFunctions() {
  print('\n--- 更多函数特性 ---');

  // 函数作为一等公民
  Function greeter = (String name) {
    return '你好, $name!';
  };

  // 高阶函数
  List<int> numbers = [1, 2, 3, 4, 5];
  List<int> doubled = numbers.map((n) => n * 2).toList();
  List<int> evens = numbers.where((n) => n % 2 == 0).toList();

  print('映射结果: $doubled');
  print('过滤结果: $evens');

  // 箭头函数
  int add(int a, int b) => a + b;
  int multiply(int a, int b) => a * b;

  print('加法结果: ${add(3, 4)}');
  print('乘法结果: ${multiply(3, 4)}');
}

/// 测试更多集合特性
void testMoreCollections() {
  print('\n--- 更多集合特性 ---');

  // List 操作
  List<int> numbers = [1, 2, 3, 4, 5];
  print('列表长度: ${numbers.length}');
  print('第一个元素: ${numbers.first}');
  print('最后一个元素: ${numbers.last}');

  // List 方法
  numbers.add(6);
  numbers.addAll([7, 8]);
  print('添加元素后长度: ${numbers.length}');

  // Map 操作
  Map<String, int> scores = {'张三': 95, '李四': 87, '王五': 92};
  print('映射大小: ${scores.length}');
  print('张三的分数: ${scores['张三']}');

  // Map 方法
  scores['赵六'] = 88;
  scores.addAll({'孙七': 90, '周八': 85});
  print('更新后映射大小: ${scores.length}');

  // Set 操作
  Set<String> uniqueNames = {'张三', '李四', '王五'};
  print('集合大小: ${uniqueNames.length}');
  uniqueNames.add('赵六');
  print('添加后集合大小: ${uniqueNames.length}');
}

/// 测试更多类特性
void testMoreClasses() {
  print('\n--- 更多类特性 ---');

  // 创建对象
  MorePerson person = MorePerson('张三', 25);
  print('创建MorePerson对象: $person');

  // 调用方法
  person.introduce();

  // 静态成员
  MorePerson.logCreation();
  print('实例计数: ${MorePerson.instanceCount}');

  // 继承
  Student student = Student('李四', 20, '计算机科学');
  print('创建Student对象: $student');
  student.study();
  student.introduce();
}

/// 测试更多泛型特性
void testMoreGenerics() {
  print('\n--- 更多泛型特性 ---');

  // 泛型类实例化
  GenericContainer<String> stringContainer = GenericContainer<String>('Hello');
  GenericContainer<int> intContainer = GenericContainer<int>(42);

  print('字符串容器值: ${stringContainer.getValue()}');
  print('整数容器值: ${intContainer.getValue()}');

  // 泛型函数
  List<int> numbers = [1, 2, 3];
  List<String> strings = ['a', 'b', 'c'];

  int firstNumber = getFirstElement(numbers);
  String firstString = getFirstElement(strings);

  print('第一个数字: $firstNumber');
  print('第一个字符串: $firstString');
}

/// 测试异常处理
void testExceptionHandling() {
  print('\n--- 异常处理 ---');

  try {
    int result = 10 ~/ 3; // 整数除法
    print('整数除法结果: $result');
  } on IntegerDivisionByZeroException {
    print('捕获到整数除零异常');
  } catch (e) {
    print('捕获到其他异常: $e');
  } finally {
    print('异常处理完成');
  }
}

/// 测试空安全特性
void testNullSafety() {
  print('\n--- 空安全特性 ---');

  // 可空类型
  String? nullableString = 'Hello';
  String? nullString = null;

  // 空值合并操作符
  String nonNull1 = nullableString ?? 'default';
  String nonNull2 = nullString ?? 'default';

  print('空值合并结果: $nonNull1, $nonNull2');

  // 空值安全访问
  List<String>? nullableList = ['a', 'b', 'c'];
  int? length1 = nullableList?.length;
  print('列表长度: $length1');

  // 空值断言
  if (nullableString != null) {
    String definitelyNotNull = nullableString!;
    print('断言非空值: $definitelyNotNull');
  }
}

/// 测试高级特性
void testAdvancedFeatures() {
  print('\n--- 高级特性 ---');

  // 扩展方法
  String text = 'hello world';
  print('扩展方法测试完成');

  // 枚举
  print('枚举值: ${Color.red}');

  // 常量
  const PI = 3.14159;
  print('圆周率: $PI');
}

// ========================
// 类定义
// ========================

/// 更多人物类
class MorePerson {
  String name;
  int age;
  static int instanceCount = 0;

  MorePerson(this.name, this.age) {
    instanceCount++;
  }

  /// 自我介绍
  void introduce() {
    print('大家好，我是 $name，今年 $age 岁。');
  }

  /// 静态方法
  static void logCreation() {
    print('创建了一个新的Person实例');
  }

  @override
  String toString() {
    return 'MorePerson{name: $name, age: $age}';
  }
}

/// 学生类（继承）
class Student extends MorePerson {
  String major;

  Student(String name, int age, this.major) : super(name, age);

  /// 学习方法
  void study() {
    print('$name 正在学习 $major');
  }

  @override
  void introduce() {
    print('大家好，我是 $name，今年 $age 岁，专业是 $major。');
  }

  @override
  String toString() {
    return 'Student{name: $name, age: $age, major: $major}';
  }
}

/// 泛型容器类
class GenericContainer<T> {
  T value;

  GenericContainer(this.value);

  T getValue() => value;
  void setValue(T newValue) => value = newValue;
}

/// 枚举
enum Color { red, green, blue }

// ========================
// 泛型函数
// ========================

/// 获取列表第一个元素的泛型函数
T getFirstElement<T>(List<T> list) {
  if (list.isEmpty) {
    throw Exception('列表为空');
  }
  return list[0];
}
