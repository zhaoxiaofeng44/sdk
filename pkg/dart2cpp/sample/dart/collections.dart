/// 集合操作测试用例
/// 
/// 测试Dart集合类型，包括：
/// - List 操作
/// - Set 操作
/// - Map 操作
/// - 集合方法和迭代
/// - 集合字面量

void main() {
  print('🔥 集合操作测试开始');
  
  // 1. List 操作测试
  testLists();
  
  // 2. Set 操作测试
  testSets();
  
  // 3. Map 操作测试
  testMaps();
  
  // 4. 集合方法测试
  testCollectionMethods();
  
  // 5. 集合字面量测试
  testCollectionLiterals();
  
  // 6. 集合迭代测试
  testIterations();
  
  print('✅ 集合操作测试完成');
}

/// 测试 List 操作
void testLists() {
  print('\n📌 测试 List 操作');
  
  // 创建 List
  List<int> numbers = [1, 2, 3, 4, 5];
  List<String> fruits = ['apple', 'banana', 'orange'];
  var mixed = [1, 'hello', true, 3.14];
  List<int> emptyList = [];
  
  print('  List 创建:');
  print('    数字列表: $numbers');
  print('    水果列表: $fruits');
  print('    混合列表: $mixed');
  print('    空列表: $emptyList');
  
  // 访问元素
  print('  List 访问:');
  print('    第一个数字: ${numbers[0]}');
  print('    最后一个水果: ${fruits[fruits.length - 1]}');
  print('    使用 first: ${numbers.first}');
  print('    使用 last: ${numbers.last}');
  
  // 修改元素
  numbers[0] = 10;
  print('  修改后的数字列表: $numbers');
  
  // 添加元素
  numbers.add(6);
  numbers.addAll([7, 8, 9]);
  print('  添加元素后: $numbers');
  
  // 插入元素
  numbers.insert(1, 15);
  numbers.insertAll(2, [11, 12]);
  print('  插入元素后: $numbers');
  
  // 删除元素
  numbers.remove(15);
  numbers.removeAt(0);
  numbers.removeLast();
  print('  删除元素后: $numbers');
  
  // List 属性
  print('  List 属性:');
  print('    长度: ${numbers.length}');
  print('    是否为空: ${emptyList.isEmpty}');
  print('    是否不为空: ${numbers.isNotEmpty}');
  
  // 子列表和操作
  var sublist = numbers.sublist(1, 4);
  var reversed = numbers.reversed.toList();
  print('  子列表 (1,4): $sublist');
  print('  反转列表: $reversed');
  
  // List 查找
  print('  List 查找:');
  print('    包含3: ${numbers.contains(3)}');
  print('    索引3的位置: ${numbers.indexOf(3)}');
  print('    最后出现3的位置: ${numbers.lastIndexOf(3)}');
  
  // List 排序
  List<int> unsorted = [5, 2, 8, 1, 9, 3];
  unsorted.sort();
  print('  排序后: $unsorted');
  
  List<String> words = ['banana', 'apple', 'cherry', 'date'];
  words.sort((a, b) => a.length.compareTo(b.length));
  print('  按长度排序: $words');
}

/// 测试 Set 操作
void testSets() {
  print('\n📌 测试 Set 操作');
  
  // 创建 Set
  Set<int> numbers = {1, 2, 3, 4, 5};
  Set<String> colors = {'red', 'green', 'blue'};
  Set<int> emptySet = {};
  
  print('  Set 创建:');
  print('    数字集合: $numbers');
  print('    颜色集合: $colors');
  print('    空集合: $emptySet');
  
  // 添加元素（重复元素会被忽略）
  numbers.add(3); // 重复
  numbers.add(6); // 新元素
  numbers.addAll([7, 8, 3, 4]); // 包含重复
  print('  添加元素后: $numbers');
  
  // 删除元素
  numbers.remove(1);
  print('  删除元素1后: $numbers');
  
  // 检查包含
  print('  Set 检查:');
  print('    包含3: ${numbers.contains(3)}');
  print('    包含10: ${numbers.contains(10)}');
  print('    长度: ${numbers.length}');
  print('    是否为空: ${emptySet.isEmpty}');
  
  // Set 运算
  Set<int> otherNumbers = {4, 5, 6, 7, 8, 9, 10};
  
  print('  Set 运算:');
  print('    原集合: $numbers');
  print('    另一集合: $otherNumbers');
  
  // 并集
  var union = numbers.union(otherNumbers);
  print('    并集: $union');
  
  // 交集
  var intersection = numbers.intersection(otherNumbers);
  print('    交集: $intersection');
  
  // 差集
  var difference = numbers.difference(otherNumbers);
  print('    差集: $difference');
  
  // 转换
  var numberList = numbers.toList();
  print('    转为List: $numberList');
  
  // Set 字面量去重
  Set<int> duplicates = {1, 1, 2, 2, 3, 3, 4, 4};
  print('  去重效果: $duplicates');
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
    'isStudent': false,
    'hobbies': ['reading', 'swimming']
  };
  
  Map<int, String> indexMap = {
    1: 'first',
    2: 'second',
    3: 'third'
  };
  
  print('  Map 创建:');
  print('    分数映射: $scores');
  print('    个人信息: $person');
  print('    索引映射: $indexMap');
  
  // 访问值
  print('  Map 访问:');
  print('    Alice的分数: ${scores['Alice']}');
  print('    姓名: ${person['name']}');
  print('    年龄: ${person['age']}');
  
  // 修改值
  scores['Alice'] = 98;
  person['age'] = 31;
  print('  修改后Alice的分数: ${scores['Alice']}');
  print('  修改后年龄: ${person['age']}');
  
  // 添加键值对
  scores['David'] = 89;
  scores['Eve'] = 94;
  person['email'] = 'john@example.com';
  print('  添加后的分数: $scores');
  print('  添加邮箱后: ${person['email']}');
  
  // 删除键值对
  scores.remove('Bob');
  person.remove('isStudent');
  print('  删除Bob后: $scores');
  
  // 检查键和值
  print('  Map 检查:');
  print('    包含Charlie键: ${scores.containsKey('Charlie')}');
  print('    包含分数95: ${scores.containsValue(95)}');
  print('    包含Frank键: ${scores.containsKey('Frank')}');
  
  // Map 属性
  print('  Map 属性:');
  print('    键集合: ${scores.keys}');
  print('    值集合: ${scores.values}');
  print('    键值对: ${scores.entries}');
  print('    长度: ${scores.length}');
  print('    是否为空: ${scores.isEmpty}');
  
  // Map 操作
  Map<String, int> bonusScores = scores.map((key, value) => MapEntry(key, value + 5));
  print('  加分后的分数: $bonusScores');
  
  // 遍历 Map
  print('  遍历分数:');
  scores.forEach((name, score) {
    print('    $name: $score分');
  });
}

/// 测试集合操作方法
void testCollectionMethods() {
  print('\n📌 测试集合操作方法');
  
  List<int> numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
  
  // map - 转换每个元素
  var doubled = numbers.map((n) => n * 2).toList();
  var strings = numbers.map((n) => 'Number: $n').toList();
  print('  map 转换:');
  print('    翻倍: $doubled');
  print('    转字符串: ${strings.take(3).toList()}...');
  
  // where - 过滤元素
  var evens = numbers.where((n) => n % 2 == 0).toList();
  var greaterThan5 = numbers.where((n) => n > 5).toList();
  print('  where 过滤:');
  print('    偶数: $evens');
  print('    大于5: $greaterThan5');
  
  // reduce - 归约操作
  var sum = numbers.reduce((a, b) => a + b);
  var product = [1, 2, 3, 4].reduce((a, b) => a * b);
  print('  reduce 归约:');
  print('    求和: $sum');
  print('    求积: $product');
  
  // fold - 折叠操作
  var sumWithInitial = numbers.fold(0, (prev, element) => prev + element);
  var concatenated = ['a', 'b', 'c'].fold('', (prev, element) => prev + element);
  print('  fold 折叠:');
  print('    带初值求和: $sumWithInitial');
  print('    字符串连接: $concatenated');
  
  // any - 是否有元素满足条件
  var hasEven = numbers.any((n) => n % 2 == 0);
  var hasNegative = numbers.any((n) => n < 0);
  print('  any 检查:');
  print('    有偶数: $hasEven');
  print('    有负数: $hasNegative');
  
  // every - 是否所有元素都满足条件
  var allPositive = numbers.every((n) => n > 0);
  var allEven = numbers.every((n) => n % 2 == 0);
  print('  every 检查:');
  print('    都是正数: $allPositive');
  print('    都是偶数: $allEven');
  
  // firstWhere 和 lastWhere - 查找元素
  var firstEven = numbers.firstWhere((n) => n % 2 == 0);
  var lastOdd = numbers.lastWhere((n) => n % 2 == 1);
  print('  查找元素:');
  print('    第一个偶数: $firstEven');
  print('    最后一个奇数: $lastOdd');
  
  // take 和 skip - 取元素
  var firstThree = numbers.take(3).toList();
  var skipThree = numbers.skip(3).toList();
  var middleThree = numbers.skip(3).take(3).toList();
  print('  take/skip 操作:');
  print('    前3个: $firstThree');
  print('    跳过前3个: ${skipThree.take(5).toList()}...');
  print('    中间3个: $middleThree');
  
  // expand - 展开操作
  var expanded = [1, 2, 3].expand((n) => [n, n * 10]).toList();
  var words = ['hello', 'world'].expand((word) => word.split('')).toList();
  print('  expand 展开:');
  print('    数字展开: $expanded');
  print('    单词展开: $words');
}

/// 测试集合字面量
void testCollectionLiterals() {
  print('\n📌 测试集合字面量');
  
  // List 字面量
  var emptyList = <int>[];
  var numberList = [1, 2, 3];
  var stringList = <String>['a', 'b', 'c'];
  var mixedList = [1, 'hello', true];
  
  print('  List 字面量:');
  print('    空列表: $emptyList');
  print('    数字列表: $numberList');
  print('    字符串列表: $stringList');
  print('    混合列表: $mixedList');
  
  // Set 字面量
  var emptySet = <int>{};
  var numberSet = {1, 2, 3, 2, 1}; // 重复元素会被去除
  var stringSet = <String>{'x', 'y', 'z'};
  
  print('  Set 字面量:');
  print('    空集合: $emptySet');
  print('    数字集合: $numberSet');
  print('    字符串集合: $stringSet');
  
  // Map 字面量
  var emptyMap = <String, int>{};
  var scoreMap = {'Alice': 95, 'Bob': 87};
  var mixedMap = <String, dynamic>{
    'name': 'John',
    'age': 30,
    'scores': [95, 87, 92]
  };
  
  print('  Map 字面量:');
  print('    空映射: $emptyMap');
  print('    分数映射: $scoreMap');
  print('    混合映射: $mixedMap');
  
  // 展开操作符
  var list1 = [1, 2, 3];
  var list2 = [4, 5, 6];
  var combined = [...list1, ...list2];
  var withExtra = [0, ...list1, 99, ...list2, 100];
  
  print('  展开操作符:');
  print('    合并列表: $combined');
  print('    带额外元素: $withExtra');
  
  // 条件展开
  bool includeExtra = true;
  var conditionalList = [
    1, 2, 3,
    if (includeExtra) ...[4, 5, 6],
    7, 8, 9
  ];
  print('    条件展开: $conditionalList');
  
  // 循环展开
  var repeated = [
    for (int i = 0; i < 3; i++) i * 2
  ];
  print('    循环展开: $repeated');
  
  // Set 展开
  var set1 = {1, 2, 3};
  var set2 = {3, 4, 5};
  var combinedSet = {...set1, ...set2};
  print('    合并集合: $combinedSet');
  
  // Map 展开
  var map1 = {'a': 1, 'b': 2};
  var map2 = {'c': 3, 'd': 4};
  var combinedMap = {...map1, ...map2};
  print('    合并映射: $combinedMap');
}

/// 测试集合迭代
void testIterations() {
  print('\n📌 测试集合迭代');
  
  List<String> fruits = ['apple', 'banana', 'orange', 'grape'];
  Set<int> numbers = {1, 2, 3, 4, 5};
  Map<String, int> scores = {'Alice': 95, 'Bob': 87, 'Charlie': 92};
  
  // for-in 循环
  print('  for-in 循环:');
  print('    水果:');
  for (String fruit in fruits) {
    print('      $fruit');
  }
  
  print('    数字:');
  for (int number in numbers) {
    print('      $number');
  }
  
  // Map 迭代
  print('    分数 (键值对):');
  for (MapEntry<String, int> entry in scores.entries) {
    print('      ${entry.key}: ${entry.value}');
  }
  
  print('    分数 (键):');
  for (String name in scores.keys) {
    print('      $name: ${scores[name]}');
  }
  
  // forEach 方法
  print('  forEach 方法:');
  print('    水果处理:');
  fruits.forEach((fruit) => print('      处理: $fruit'));
  
  print('    数字处理:');
  numbers.forEach((number) => print('      数字: $number'));
  
  print('    分数处理:');
  scores.forEach((name, score) => print('      $name 得了 $score 分'));
  
  // 索引迭代
  print('  索引迭代:');
  for (int i = 0; i < fruits.length; i++) {
    print('    索引 $i: ${fruits[i]}');
  }
  
  // asMap() 方法获取索引
  print('  asMap 索引:');
  fruits.asMap().forEach((index, fruit) {
    print('    位置 $index: $fruit');
  });
  
  // 迭代器
  print('  迭代器:');
  Iterator<String> iterator = fruits.iterator;
  while (iterator.moveNext()) {
    print('    迭代器: ${iterator.current}');
  }
  
  // 链式操作
  print('  链式操作:');
  var result = numbers
      .where((n) => n % 2 == 0)
      .map((n) => n * n)
      .toList();
  print('    偶数平方: $result');
  
  var processed = fruits
      .where((fruit) => fruit.length > 5)
      .map((fruit) => fruit.toUpperCase())
      .toList();
  print('    长水果名大写: $processed');
}
