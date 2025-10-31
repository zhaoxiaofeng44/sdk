/// 集合类型演示
/// 
/// 测试 List, Set, Map 等集合类型的操作

void main() {
  print('🔥 集合类型演示开始');
  
  // 1. List 操作
  testLists();
  
  // 2. Set 操作
  testSets();
  
  // 3. Map 操作
  testMaps();
  
  // 4. 集合操作方法
  testCollectionMethods();
  
  // 5. 集合字面量
  testCollectionLiterals();
  
  print('✅ 集合类型演示完成');
}

/// 测试 List 操作
void testLists() {
  print('\n📌 测试 List 操作');
  
  // 创建 List
  List<int> numbers = [1, 2, 3, 4, 5];
  List<String> fruits = ['apple', 'banana', 'orange'];
  var mixed = [1, 'hello', true, 3.14];
  
  // 访问元素
  print('  第一个数字: ${numbers[0]}');
  print('  最后一个水果: ${fruits[fruits.length - 1]}');
  
  // 修改元素
  numbers[0] = 10;
  print('  修改后: $numbers');
  
  // 添加元素
  numbers.add(6);
  numbers.addAll([7, 8, 9]);
  print('  添加后: $numbers');
  
  // 插入元素
  numbers.insert(1, 15);
  print('  插入后: $numbers');
  
  // 删除元素
  numbers.remove(15);
  numbers.removeAt(0);
  print('  删除后: $numbers');
  
  // List 属性
  print('  长度: ${numbers.length}');
  print('  是否为空: ${numbers.isEmpty}');
  print('  是否不为空: ${numbers.isNotEmpty}');
  
  // 子列表
  var sublist = numbers.sublist(1, 4);
  print('  子列表: $sublist');
  
  // 反转
  var reversed = numbers.reversed.toList();
  print('  反转: $reversed');
}

/// 测试 Set 操作
void testSets() {
  print('\n📌 测试 Set 操作');
  
  // 创建 Set
  Set<int> numbers = {1, 2, 3, 4, 5};
  Set<String> colors = {'red', 'green', 'blue'};
  
  // 添加元素（重复元素会被忽略）
  numbers.add(3); // 重复
  numbers.add(6); // 新元素
  print('  添加后: $numbers');
  
  // 删除元素
  numbers.remove(1);
  print('  删除后: $numbers');
  
  // 检查包含
  print('  包含3: ${numbers.contains(3)}');
  print('  包含10: ${numbers.contains(10)}');
  
  // Set 运算
  Set<int> otherNumbers = {4, 5, 6, 7, 8};
  
  // 并集
  var union = numbers.union(otherNumbers);
  print('  并集: $union');
  
  // 交集
  var intersection = numbers.intersection(otherNumbers);
  print('  交集: $intersection');
  
  // 差集
  var difference = numbers.difference(otherNumbers);
  print('  差集: $difference');
  
  // 转换为 List
  var numberList = numbers.toList();
  print('  转为List: $numberList');
}

/// 测试 Map 操作
void testMaps() {
  print('\n📌 测试 Map 操作');
  
  // 创建 Map
  Map<String, int> scores = {
    'Alice': 95,
    'Bob': 87,
    'Charlie': 92
  };
  
  Map<String, dynamic> person = {
    'name': 'John',
    'age': 30,
    'isStudent': false
  };
  
  // 访问值
  print('  Alice的分数: ${scores['Alice']}');
  print('  姓名: ${person['name']}');
  
  // 修改值
  scores['Alice'] = 98;
  print('  修改后Alice的分数: ${scores['Alice']}');
  
  // 添加键值对
  scores['David'] = 89;
  person['email'] = 'john@example.com';
  print('  添加后的分数: $scores');
  print('  添加后的个人信息: $person');
  
  // 删除键值对
  scores.remove('Bob');
  print('  删除Bob后: $scores');
  
  // 检查键和值
  print('  包含Charlie: ${scores.containsKey('Charlie')}');
  print('  包含分数95: ${scores.containsValue(95)}');
  
  // Map 属性
  print('  键: ${scores.keys}');
  print('  值: ${scores.values}');
  print('  长度: ${scores.length}');
  print('  是否为空: ${scores.isEmpty}');
  
  // 遍历 Map
  print('  遍历分数:');
  scores.forEach((name, score) {
    print('    $name: $score');
  });
}

/// 测试集合操作方法
void testCollectionMethods() {
  print('\n📌 测试集合操作方法');
  
  List<int> numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
  
  // map - 转换每个元素
  var doubled = numbers.map((n) => n * 2).toList();
  print('  map (翻倍): $doubled');
  
  // where - 过滤元素
  var evens = numbers.where((n) => n % 2 == 0).toList();
  print('  where (偶数): $evens');
  
  // reduce - 归约操作
  var sum = numbers.reduce((a, b) => a + b);
  print('  reduce (求和): $sum');
  
  // fold - 折叠操作
  var product = numbers.fold(1, (prev, element) => prev * element);
  print('  fold (求积): $product');
  
  // any - 是否有元素满足条件
  var hasEven = numbers.any((n) => n % 2 == 0);
  print('  any (有偶数): $hasEven');
  
  // every - 是否所有元素都满足条件
  var allPositive = numbers.every((n) => n > 0);
  print('  every (都是正数): $allPositive');
  
  // firstWhere - 找到第一个满足条件的元素
  var firstEven = numbers.firstWhere((n) => n % 2 == 0);
  print('  firstWhere (第一个偶数): $firstEven');
  
  // take - 取前n个元素
  var firstThree = numbers.take(3).toList();
  print('  take (前3个): $firstThree');
  
  // skip - 跳过前n个元素
  var skipThree = numbers.skip(3).toList();
  print('  skip (跳过前3个): $skipThree');
  
  // sort - 排序
  List<int> unsorted = [5, 2, 8, 1, 9, 3];
  unsorted.sort();
  print('  sort (排序): $unsorted');
  
  // 自定义排序
  List<String> words = ['banana', 'apple', 'cherry', 'date'];
  words.sort((a, b) => a.length.compareTo(b.length));
  print('  sort (按长度): $words');
}

/// 测试集合字面量
void testCollectionLiterals() {
  print('\n📌 测试集合字面量');
  
  // List 字面量
  var emptyList = <int>[];
  var numberList = [1, 2, 3];
  var stringList = <String>['a', 'b', 'c'];
  
  print('  List字面量: $emptyList, $numberList, $stringList');
  
  // Set 字面量
  var emptySet = <int>{};
  var numberSet = {1, 2, 3, 2, 1}; // 重复元素会被去除
  var stringSet = <String>{'x', 'y', 'z'};
  
  print('  Set字面量: $emptySet, $numberSet, $stringSet');
  
  // Map 字面量
  var emptyMap = <String, int>{};
  var scoreMap = {'Alice': 95, 'Bob': 87};
  var mixedMap = <String, dynamic>{
    'name': 'John',
    'age': 30,
    'scores': [95, 87, 92]
  };
  
  print('  Map字面量: $emptyMap');
  print('  分数Map: $scoreMap');
  print('  混合Map: $mixedMap');
  
  // 展开操作符
  var list1 = [1, 2, 3];
  var list2 = [4, 5, 6];
  var combined = [...list1, ...list2];
  print('  展开操作符: $combined');
  
  // 条件元素
  bool includeZero = true;
  var conditionalList = [
    if (includeZero) 0,
    1, 2, 3
  ];
  print('  条件元素: $conditionalList');
  
  // 循环元素
  var repeatedList = [
    for (int i = 0; i < 3; i++) 'item_$i'
  ];
  print('  循环元素: $repeatedList');
}