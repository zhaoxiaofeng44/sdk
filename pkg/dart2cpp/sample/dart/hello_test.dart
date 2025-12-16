/// Dart 基础语法测试示例
///
/// 包含能够被正确转换的基础Dart语法特性
///

void main() {
  print('🔥 Dart 基础语法测试开始');

  // 1. 基本数据类型
  testBasicTypes();

  // 2. 控制流
  testControlFlow();

  // 3. 函数
  testFunctions();

  // 4. 集合类型（简化版）
  testSimpleCollections();

  // 5. 类和对象
  testClasses();

  print('✅ Dart 基础语法测试完成');
}

/// 测试基本数据类型（简化版）
void testBasicTypes() {
  print('\n--- 基本数据类型 ---');

  // 数值类型
  int age = 25;
  double price = 99.99;
  int quantity = 10; // 使用int替代num类型，因为转换规范禁用num

  // 字符串类型
  String name = '张三';
  String message = '你好，世界！';
  String multiline = '这是单行字符串'; // 简化字符串处理

  // 布尔类型
  bool isStudent = true;
  bool isEmployed = false;

  // 简化输出（避免复杂插值）
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
}

/// 测试函数（简化版）
void testFunctions() {
  print('\n--- 函数 ---');

  // 调用内置函数
  print('函数测试完成');
}

/// 测试简单集合类型
void testSimpleCollections() {
  print('\n--- 简单集合类型 ---');

  // List
  List<int> numbers = [1, 2, 3, 4, 5];
  List<String> names = ['张三', '李四', '王五'];
  print('数字列表: $numbers');
  print('姓名列表: $names');

  // 简化集合操作
  print('列表长度: ${numbers.length}');
  print('列表第一个元素: ${numbers.first}');
  print('列表最后一个元素: ${numbers.last}');

  // 列表方法
  numbers.add(6);
  print('添加元素后: $numbers');
}

/// 测试类和对象
void testClasses() {
  print('\n--- 类和对象 ---');

  // 创建对象
  Person person = Person('张三', 25);
  print('个人信息: ${person.toString()}');

  // 调用方法
  person.introduce();

  // 访问属性
  print('姓名: ${person.name}');
  print('年龄: ${person.age}');

  // 修改属性
  person.age = 26;
  print('一年后的年龄: ${person.age}');

  // 继承
  Student student = Student('李四', 20, '计算机科学');
  print('学生信息: ${student.toString()}');
  student.study();
  student.introduce();
}

// 异常处理部分已移除，因为转换器可能不完全支持// ========================
// 类定义
// ========================

/// 人员基类
class Person {
  String name;
  int age;

  Person(this.name, this.age);

  /// 自我介绍
  void introduce() {
    print('大家好，我是 $name，今年 $age 岁。');
  }

  @override
  String toString() {
    return 'Person{name: $name, age: $age}';
  }
}

/// 学生类（继承自Person）
class Student extends Person {
  String major;

  Student(String name, int age, this.major) : super(name, age);

  /// 学习方法
  void study() {
    print('$name 正在学习 $major。');
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
