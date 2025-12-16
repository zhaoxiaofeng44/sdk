/// Dart 简化增强语法测试示例
///
/// 包含适配转换器的更多Dart语法特性
///

void main() {
  print('🔥 Dart 简化增强语法测试开始');

  // 1. 基本数据类型
  testBasicTypes();

  // 2. 控制流
  testControlFlow();

  // 3. 函数（简化版）
  testSimpleFunctions();

  // 4. 集合类型（简化版）
  testSimpleCollections();

  // 5. 类和对象（简化版）
  testSimpleClasses();

  // 6. 泛型（简化版）
  testSimpleGenerics();

  // 7. 异常处理（简化版）
  testSimpleExceptions();

  print('✅ Dart 简化增强语法测试完成');
}

/// 测试基本数据类型
void testBasicTypes() {
  print('\n--- 基本数据类型 ---');

  // 数值类型
  int age = 25;
  double price = 99.99;
  int quantity = 10;

  // 字符串类型
  String name = '张三';
  String message = '你好，世界！';

  // 布尔类型
  bool isStudent = true;
  bool isEmployed = false;

  print('基本类型测试完成');
}

/// 测试控制流
void testControlFlow() {
  print('\n--- 控制流 ---');

  // if-else 语句
  int score = 85;
  if (score >= 90) {
    print('优秀');
  } else if (score >= 80) {
    print('良好');
  } else if (score >= 60) {
    print('及格');
  } else {
    print('不及格');
  }

  // switch 语句
  String grade = 'B';
  switch (grade) {
    case 'A':
      print('优秀');
      break;
    case 'B':
      print('良好');
      break;
    case 'C':
      print('及格');
      break;
    default:
      print('未知等级');
  }

  // for 循环
  print('For 循环:');
  for (int i = 0; i < 5; i++) {
    print('数字: $i');
  }

  // for-in 循环
  List<String> fruits = ['苹果', '香蕉', '橙子'];
  print('For-in 循环:');
  for (String fruit in fruits) {
    print('水果: $fruit');
  }

  // while 循环
  print('While 循环:');
  int count = 3;
  while (count > 0) {
    print('倒计时: $count');
    count--;
  }

  // do-while 循环
  print('Do-while 循环:');
  int number = 1;
  do {
    print('数字: $number');
    number *= 2;
  } while (number <= 10);

  // 条件表达式
  int testAge = 25;
  bool isAdult = testAge >= 18 ? true : false;
  print('成年人: $isAdult');
}

/// 测试简化函数
void testSimpleFunctions() {
  print('\n--- 简化函数 ---');

  // 简单函数
  String greet(String name) {
    return '你好, $name!';
  }

  // 带参数的函数
  int add(int a, int b) {
    return a + b;
  }

  // 调用函数
  print(greet('李四'));
  print('加法结果: ${add(5, 3)}');
}

/// 测试简化集合
void testSimpleCollections() {
  print('\n--- 简化集合 ---');

  // List 操作
  List<int> numbers = [1, 2, 3, 4, 5];
  List<String> names = ['张三', '李四', '王五'];

  // Map 操作
  Map<String, int> scores = {'张三': 95, '李四': 87, '王五': 92};

  // 集合方法
  print('数字列表长度: ${numbers.length}');
  print('第一个数字: ${numbers.first}');
  print('最后一个数字: ${numbers.last}');

  // 列表操作
  numbers.add(6);
  print('添加元素后列表长度: ${numbers.length}');

  // Map 操作
  print('张三的分数: ${scores['张三']}');
  scores['赵六'] = 88;
  print('更新后的分数数量: ${scores.length}');
}

/// 测试简化类
void testSimpleClasses() {
  print('\n--- 简化类 ---');

  // 创建对象
  SimplePerson person = SimplePerson('张三', 25);
  print('创建Person对象');

  // 调用方法
  person.introduce();

  // 访问属性
  print('姓名: ${person.getName()}');
  person.setName('李四');
  print('更新后姓名: ${person.getName()}');
}

/// 测试简化泛型
void testSimpleGenerics() {
  print('\n--- 简化泛型 ---');

  // 泛型类
  SimpleBox<String> stringBox = SimpleBox<String>('Hello');
  SimpleBox<int> intBox = SimpleBox<int>(42);

  print('字符串盒子内容: ${stringBox.getValue()}');
  print('整数盒子内容: ${intBox.getValue()}');
}

/// 测试简化异常处理
void testSimpleExceptions() {
  print('\n--- 简化异常处理 ---');

  try {
    int result = 10 ~/ 2; // 整数除法
    print('结果: $result');
  } catch (e) {
    print('捕获到异常');
  }

  print('异常处理测试完成');
}

// ========================
// 简化类定义
// ========================

/// 简化人员类
class SimplePerson {
  String _name;
  int _age;

  SimplePerson(this._name, this._age);

  // Getter 和 Setter
  String getName() => _name;
  void setName(String value) => _name = value;

  int getAge() => _age;
  void setAge(int value) => _age = value;

  /// 自我介绍
  void introduce() {
    print('大家好，我是 $_name，今年 $_age 岁。');
  }

  @override
  String toString() {
    return 'SimplePerson{name: $_name, age: $_age}';
  }
}

/// 简化泛型盒子类
class SimpleBox<T> {
  T _value;

  SimpleBox(this._value);

  T getValue() => _value;
  void setValue(T value) => _value = value;
}
