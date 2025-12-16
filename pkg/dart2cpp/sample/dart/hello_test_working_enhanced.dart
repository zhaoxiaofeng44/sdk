/// Dart 工作增强语法测试示例
///
/// 包含转换器完全支持的Dart语法特性
///

void main() {
  print('🔥 Dart 工作增强语法测试开始');

  // 1. 基本数据类型
  testDataTypes();

  // 2. 控制流增强
  testWorkingControlFlow();

  // 3. 函数特性
  testWorkingFunctions();

  // 4. 集合特性
  testWorkingCollections();

  // 5. 类特性
  testWorkingClasses();

  // 6. 泛型特性
  testWorkingGenerics();

  print('✅ Dart 工作增强语法测试完成');
}

/// 测试数据类型
void testDataTypes() {
  print('\n--- 数据类型 ---');

  // 基本类型
  int age = 25;
  double price = 99.99;
  String name = '张三';
  bool isStudent = true;

  print('基本类型测试完成');
}

/// 测试工作控制流
void testWorkingControlFlow() {
  print('\n--- 工作控制流 ---');

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

/// 测试工作函数特性
void testWorkingFunctions() {
  print('\n--- 工作函数特性 ---');

  print('函数特性测试完成');
}

/// 测试工作集合特性
void testWorkingCollections() {
  print('\n--- 工作集合特性 ---');

  // List 操作
  List<int> numbers = [1, 2, 3, 4, 5];
  print('列表长度: ${numbers.length}');

  // Map 操作
  Map<String, int> scores = {'张三': 95, '李四': 87};
  print('映射大小: ${scores.length}');
}

/// 测试工作类特性
void testWorkingClasses() {
  print('\n--- 工作类特性 ---');

  // 创建对象
  WorkingPerson person = WorkingPerson('张三', 25);
  print('创建WorkingPerson对象');

  // 调用方法
  person.introduce();
}

/// 测试工作泛型特性
void testWorkingGenerics() {
  print('\n--- 工作泛型特性 ---');

  print('泛型特性测试完成');
}

// ========================
// 类定义
// ========================

/// 工作人员类
class WorkingPerson {
  String name;
  int age;

  WorkingPerson(this.name, this.age);

  /// 自我介绍
  void introduce() {
    print('大家好，我是 $name，今年 $age 岁。');
  }

  @override
  String toString() {
    return 'WorkingPerson{name: $name, age: $age}';
  }
}
