/// Dart 最终增强语法测试示例
///
/// 包含转换器完全支持的更多Dart语法特性
///

void main() {
  print('🔥 Dart 最终增强语法测试开始');

  // 1. 基本数据类型和操作
  testDataTypes();

  // 2. 控制流增强
  testFinalControlFlow();

  // 3. 函数增强
  testFinalFunctions();

  // 4. 集合增强
  testFinalCollections();

  // 5. 类增强
  testFinalClasses();

  // 6. 泛型
  testFinalGenerics();

  print('✅ Dart 最终增强语法测试完成');
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

  // 字符串方法
  int strLength = name.length;

  // 数值方法
  String ageStr = age.toString();

  print('数据类型操作完成');
}

/// 测试最终控制流
void testFinalControlFlow() {
  print('\n--- 最终控制流 ---');

  // switch 语句
  int score = 85;
  switch (score) {
    case 100:
    case 90:
      print('优秀');
      break;
    case 80:
      print('良好');
      break;
    default:
      print('其他分数');
  }

  // for 循环
  print('正序循环:');
  for (int i = 1; i <= 3; i++) {
    print('数字: $i');
  }

  // for-in 循环
  List<String> fruits = ['苹果', '香蕉', '橙子'];
  print('水果列表:');
  for (String fruit in fruits) {
    print('  $fruit');
  }

  // 条件表达式
  int testAge = 20;
  String description = testAge >= 18 ? '成年人' : '未成年人';
  print('年龄描述: $description');
}

/// 测试最终函数特性
void testFinalFunctions() {
  print('\n--- 最终函数特性 ---');

  // 简单函数
  String greetName(String name) {
    return '你好, $name!';
  }

  // 多参数函数
  int addNumbers(int a, int b) {
    return a + b;
  }

  // 调用函数
  String greeting = greetName('李四');
  int sum = addNumbers(1, 2);

  print('问候语: $greeting');
  print('两数之和: $sum');
}

/// 测试最终集合特性
void testFinalCollections() {
  print('\n--- 最终集合特性 ---');

  // List 操作
  List<int> numbers = [1, 2, 3, 4, 5];
  print('列表长度: ${numbers.length}');

  // List 方法
  numbers.add(6);
  print('添加元素后长度: ${numbers.length}');

  // Map 操作
  Map<String, int> scores = {'张三': 95, '李四': 87};
  print('映射大小: ${scores.length}');
  print('张三的分数: ${scores['张三']}');
}

/// 测试最终类特性
void testFinalClasses() {
  print('\n--- 最终类特性 ---');

  // 创建对象
  FinalPerson person = FinalPerson('张三', 25);
  print('创建FinalPerson对象');

  // 调用方法
  person.introduce();

  // 访问属性
  print('姓名: ${person.getName()}');

  // 继承
  FinalStudent student = FinalStudent('王五', 20, '计算机科学');
  print('创建FinalStudent对象');
  student.study();
  student.introduce();
}

/// 测试最终泛型特性
void testFinalGenerics() {
  print('\n--- 最终泛型特性 ---');

  // 泛型类实例化
  FinalContainer<String> stringContainer = FinalContainer<String>('Hello');
  FinalContainer<int> intContainer = FinalContainer<int>(42);

  print('字符串容器值: ${stringContainer.getValue()}');
  print('整数容器值: ${intContainer.getValue()}');
}

// ========================
// 类定义
// ========================

/// 最终人物类
class FinalPerson {
  String _name;
  int _age;

  FinalPerson(this._name, this._age);

  // Getter
  String getName() => _name;
  int getAge() => _age;

  /// 自我介绍
  void introduce() {
    print('大家好，我是 $_name，今年 $_age 岁。');
  }

  @override
  String toString() {
    return 'FinalPerson{name: $_name, age: $_age}';
  }
}

/// 最终学生类（继承）
class FinalStudent extends FinalPerson {
  String _major;

  FinalStudent(String name, int age, this._major) : super(name, age);

  // Getter
  String getMajor() => _major;

  /// 学习方法
  void study() {
    print('${getName()} 正在学习 $_major');
  }

  @override
  void introduce() {
    print('大家好，我是 ${getName()}，今年 ${getAge()} 岁，专业是 $_major。');
  }

  @override
  String toString() {
    return 'FinalStudent{name: ${getName()}, age: ${getAge()}, major: $_major}';
  }
}

/// 最终容器类（泛型）
class FinalContainer<T> {
  T _value;

  FinalContainer(this._value);

  T getValue() => _value;
  void setValue(T newValue) => _value = newValue;
}
