/// Dart 最小化增强语法测试示例
///
/// 包含转换器支持的增强Dart语法特性
///

void main() {
  print('🔥 Dart 最小化增强语法测试开始');

  // 1. 基本数据类型和操作
  testDataTypes();

  // 2. 控制流增强
  testEnhancedControlFlow();

  // 3. 函数增强
  testEnhancedFunctions();

  // 4. 集合增强
  testEnhancedCollections();

  // 5. 类增强
  testEnhancedClasses();

  // 6. 泛型
  testGenerics();

  print('✅ Dart 最小化增强语法测试完成');
}

/// 测试数据类型和操作
void testDataTypes() {
  print('\n--- 数据类型和操作 ---');

  // 基本类型
  int age = 25;
  double price = 99.99;
  String name = '张三';
  bool isStudent = true;

  // 类型转换
  String ageString = age.toString();
  int priceInt = price.toInt();

  print('数据类型操作完成');
}

/// 测试增强控制流
void testEnhancedControlFlow() {
  print('\n--- 增强控制流 ---');

  // switch 语句
  String grade = 'B';
  switch (grade) {
    case 'A':
      print('优秀');
      break;
    case 'B':
      print('良好');
      break;
    default:
      print('其他等级');
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

/// 测试增强函数
void testEnhancedFunctions() {
  print('\n--- 增强函数 ---');

  // 函数调用
  print('函数特性测试完成');
}

/// 测试增强集合
void testEnhancedCollections() {
  print('\n--- 增强集合 ---');

  // List 操作
  List<int> numbers = [1, 2, 3, 4, 5];
  print('列表长度: ${numbers.length}');

  // Map 操作
  Map<String, int> scores = {'张三': 95, '李四': 87};
  print('映射大小: ${scores.length}');

  // 集合方法
  numbers.add(6);
  print('添加元素后长度: ${numbers.length}');
}

/// 测试增强类
void testEnhancedClasses() {
  print('\n--- 增强类 ---');

  // 创建对象
  EnhancedPerson person = EnhancedPerson('张三', 25);
  print('创建EnhancedPerson对象');

  // 调用方法
  person.introduce();
}

/// 测试泛型
void testGenerics() {
  print('\n--- 泛型 ---');

  // 泛型类实例化
  print('泛型特性测试完成');
}

// ========================
// 类定义
// ========================

/// 增强人员类
class EnhancedPerson {
  String name;
  int age;

  EnhancedPerson(this.name, this.age);

  /// 自我介绍
  void introduce() {
    print('大家好，我是 $name，今年 $age 岁。');
  }

  @override
  String toString() {
    return 'EnhancedPerson{name: $name, age: $age}';
  }
}

/// 泛型盒子类
class GenericBox<T> {
  T value;

  GenericBox(this.value);
}
