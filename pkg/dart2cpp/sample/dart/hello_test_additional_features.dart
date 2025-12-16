/// Dart 附加特性测试示例
///
/// 包含适配转换器的更多Dart语法特性
///

void main() {
  print('🔥 Dart 附加特性测试开始');

  // 1. 基本数据类型和操作
  testDataTypes();

  // 2. 控制流附加特性
  testAdditionalControlFlow();

  // 3. 函数附加特性
  testAdditionalFunctions();

  // 4. 集合附加特性
  testAdditionalCollections();

  // 5. 类附加特性
  testAdditionalClasses();

  // 6. 泛型附加特性
  testAdditionalGenerics();

  // 7. 异常处理
  testSimpleExceptionHandling();

  // 8. 空安全特性
  testSimpleNullSafety();

  print('✅ Dart 附加特性测试完成');
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
  String upper = name.toUpperCase();
  String lower = name.toLowerCase();
  int strLength = name.length;

  // 数值方法
  String ageStr = age.toString();
  int priceInt = price.toInt();

  print('数据类型操作完成');
}

/// 测试附加控制流特性
void testAdditionalControlFlow() {
  print('\n--- 附加控制流特性 ---');

  // switch 语句（更多case）
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
    case 80:
    case 79:
    case 78:
      print('良好');
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

/// 测试附加函数特性
void testAdditionalFunctions() {
  print('\n--- 附加函数特性 ---');

  // 带参数的函数
  String greet(String name) {
    return '你好, $name!';
  }

  // 多参数函数
  int addThreeNumbers(int a, int b, int c) {
    return a + b + c;
  }

  // 调用函数
  String greeting = greet('李四');
  int sum = addThreeNumbers(1, 2, 3);

  print('问候语: $greeting');
  print('三数之和: $sum');
}

/// 测试附加集合特性
void testAdditionalCollections() {
  print('\n--- 附加集合特性 ---');

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

  // Map 更新
  scores['赵六'] = 88;
  print('更新后映射大小: ${scores.length}');
}

/// 测试附加类特性
void testAdditionalClasses() {
  print('\n--- 附加类特性 ---');

  // 创建对象
  AdditionalPerson person = AdditionalPerson('张三', 25);
  print('创建AdditionalPerson对象: $person');

  // 调用方法
  person.introduce();

  // 访问属性
  print('姓名: ${person.getName()}');
  person.setName('李四');
  print('更新后姓名: ${person.getName()}');

  // 继承
  AdditionalStudent student = AdditionalStudent('王五', 20, '计算机科学');
  print('创建AdditionalStudent对象: $student');
  student.study();
  student.introduce();
}

/// 测试附加泛型特性
void testAdditionalGenerics() {
  print('\n--- 附加泛型特性 ---');

  // 泛型类实例化
  GenericHolder<String> stringHolder = GenericHolder<String>('Hello');
  GenericHolder<int> intHolder = GenericHolder<int>(42);

  print('字符串持有者值: ${stringHolder.getValue()}');
  print('整数持有者值: ${intHolder.getValue()}');

  // 泛型函数调用
  List<int> numbers = [1, 2, 3];
  List<String> strings = ['a', 'b', 'c'];

  int firstNumber = getFirst(numbers);
  String firstString = getFirst(strings);

  print('第一个数字: $firstNumber');
  print('第一个字符串: $firstString');
}

/// 测试简单异常处理
void testSimpleExceptionHandling() {
  print('\n--- 简单异常处理 ---');

  try {
    int result = 10 ~/ 3; // 整数除法
    print('整数除法结果: $result');
  } catch (e) {
    print('捕获到异常');
  }

  print('异常处理完成');
}

/// 测试简单空安全特性
void testSimpleNullSafety() {
  print('\n--- 简单空安全特性 ---');

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
}

// ========================
// 类定义
// ========================

/// 附加人物类
class AdditionalPerson {
  String _name;
  int _age;

  AdditionalPerson(this._name, this._age);

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
    return 'AdditionalPerson{name: $_name, age: $_age}';
  }
}

/// 附加学生类（继承）
class AdditionalStudent extends AdditionalPerson {
  String _major;

  AdditionalStudent(String name, int age, this._major) : super(name, age);

  // Getter 和 Setter
  String getMajor() => _major;
  void setMajor(String value) => _major = value;

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
    return 'AdditionalStudent{name: ${getName()}, age: ${getAge()}, major: $_major}';
  }
}

/// 泛型持有者类
class GenericHolder<T> {
  T _value;

  GenericHolder(this._value);

  T getValue() => _value;
  void setValue(T newValue) => _value = newValue;
}

// ========================
// 泛型函数
// ========================

/// 获取列表第一个元素的泛型函数
T getFirst<T>(List<T> list) {
  if (list.isEmpty) {
    throw Exception('列表为空');
  }
  return list[0];
}
