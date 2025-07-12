import '../lib/demo/Iterable.dart';

void main() {
  print("=== 开始测试 CppIterable 实现 ===");

  testCppList();
  testCppSet();
  testCppMap();
  testIterableOperations();
  testIterableTransformations();
  testIterableFiltering();
  testIterableAggregation();
  testIterableSlicing();

  print("\n=== 所有测试完成 ===");
}

void testCppList() {
  print("\n--- 测试 CppList ---");

  // 测试基本构造
  var list = CppList<int>();
  assert(list.isEmpty);
  assert(list.length == 0);

  // 测试添加元素
  list.add(1);
  list.add(2);
  list.add(3);
  assert(list.length == 3);
  assert(list[0] == 1);
  assert(list[1] == 2);
  assert(list[2] == 3);

  // 测试工厂构造方法
  var filledList = CppList<String>.filled(3, "test");
  assert(filledList.length == 3);
  assert(filledList[0] == "test");
  assert(filledList[1] == "test");
  assert(filledList[2] == "test");

  // 测试从其他CppIterable构造
  var fromList = CppList<int>.from(list);
  assert(fromList.length == 3);
  assert(fromList[0] == 1);
  assert(fromList[1] == 2);
  assert(fromList[2] == 3);

  // 测试generate构造方法
  var generatedList = CppList<int>.generate(3, (i) => i * 2);
  assert(generatedList.length == 3);
  assert(generatedList[0] == 0);
  assert(generatedList[1] == 2);
  assert(generatedList[2] == 4);

  // 测试插入和删除
  list.insert(1, 10);
  assert(list.length == 4);
  assert(list[1] == 10);

  var removed = list.removeAt(1);
  assert(removed == 10);
  assert(list.length == 3);

  // 测试查找
  assert(list.indexOf(2) == 1);
  assert(list.lastIndexOf(3) == 2);

  print("CppList 测试通过!");
}

void testCppSet() {
  print("\n--- 测试 CppSet ---");

  var set = CppSet<int>();
  assert(set.isEmpty);

  // 测试添加元素
  assert(set.add(1) == true);
  assert(set.add(2) == true);
  assert(set.add(1) == false); // 重复元素
  assert(set.length == 2);
  assert(set.contains(1));
  assert(set.contains(2));
  assert(!set.contains(3));

  // 测试集合操作
  var set2 = CppSet<int>();
  set2.add(2);
  set2.add(3);

  var union = set.union(set2);
  assert(union.length == 3);
  assert(union.contains(1));
  assert(union.contains(2));
  assert(union.contains(3));

  var intersection = set.intersection(set2);
  assert(intersection.length == 1);
  assert(intersection.contains(2));

  var difference = set.difference(set2);
  assert(difference.length == 1);
  assert(difference.contains(1));

  // 测试from构造
  var list = CppList<int>();
  list.add(4);
  list.add(5);
  list.add(4); // 重复
  var setFromList = CppSet<int>.from(list);
  assert(setFromList.length == 2);
  assert(setFromList.contains(4));
  assert(setFromList.contains(5));

  print("CppSet 测试通过!");
}

void testCppMap() {
  print("\n--- 测试 CppMap ---");

  var map = CppMap<String, int>();
  assert(map.isEmpty);

  // 测试添加和获取
  map["one"] = 1;
  map["two"] = 2;
  assert(map.length == 2);
  assert(map["one"] == 1);
  assert(map["two"] == 2);
  assert(map["three"] == null);

  // 测试键值存在性
  assert(map.containsKey("one"));
  assert(map.containsValue(1));
  assert(!map.containsKey("three"));
  assert(!map.containsValue(3));

  // 测试更新
  map["one"] = 10;
  assert(map["one"] == 10);

  // 测试删除
  var removed = map.remove("one");
  assert(removed == 10);
  assert(map.length == 1);
  assert(!map.containsKey("one"));

  // 测试putIfAbsent
  var value = map.putIfAbsent("three", () => 3);
  assert(value == 3);
  assert(map.length == 2);

  var existingValue = map.putIfAbsent("two", () => 20);
  assert(existingValue == 2);
  assert(map.length == 2);

  // 测试update
  map.update("two", (v) => v * 2);
  assert(map["two"] == 4);

  // 测试updateAll
  map.updateAll((k, v) => v + 1);
  assert(map["two"] == 5);
  assert(map["three"] == 4);

  // 测试keys和values
  var keys = map.keys.toList();
  var values = map.values.toList();
  assert(keys.length == 2);
  assert(values.length == 2);

  print("CppMap 测试通过!");
}

void testIterableOperations() {
  print("\n--- 测试 Iterable 基本操作 ---");

  var list = CppList<int>();
  list.add(1);
  list.add(2);
  list.add(3);
  list.add(4);
  list.add(5);

  // 测试基本属性
  assert(list.length == 5);
  assert(!list.isEmpty);
  assert(list.isNotEmpty);
  assert(list.first == 1);
  assert(list.last == 5);

  // 测试elementAt
  assert(list.elementAt(0) == 1);
  assert(list.elementAt(2) == 3);
  assert(list.elementAt(4) == 5);

  // 测试contains
  assert(list.contains(3));
  assert(!list.contains(6));

  // 测试forEach
  var sum = 0;
  list.forEach((x) => sum += x);
  assert(sum == 15);

  print("Iterable 基本操作测试通过!");
}

void testIterableTransformations() {
  print("\n--- 测试 Iterable 转换操作 ---");

  var list = CppList<int>();
  list.add(1);
  list.add(2);
  list.add(3);

  // 测试map
  var doubled = list.map((x) => x * 2);
  var doubledList = doubled.toList();
  assert(doubledList.length == 3);
  assert(doubledList[0] == 2);
  assert(doubledList[1] == 4);
  assert(doubledList[2] == 6);

  // 测试expand
  var expanded = list.expand((x) {
    var result = CppList<int>();
    result.add(x);
    result.add(x);
    return result;
  });
  var expandedList = expanded.toList();
  assert(expandedList.length == 6);
  assert(expandedList[0] == 1);
  assert(expandedList[1] == 1);
  assert(expandedList[2] == 2);
  assert(expandedList[3] == 2);

  // 测试cast
  var stringList = CppList<String>();
  stringList.add("1");
  stringList.add("2");
  var dynamicList = stringList.cast<dynamic>();
  assert(dynamicList.length == 2);

  print("Iterable 转换操作测试通过!");
}

void testIterableFiltering() {
  print("\n--- 测试 Iterable 过滤操作 ---");

  var list = CppList<int>();
  list.add(1);
  list.add(2);
  list.add(3);
  list.add(4);
  list.add(5);

  // 测试where
  var evens = list.where((x) => x % 2 == 0);
  var evensList = evens.toList();
  assert(evensList.length == 2);
  assert(evensList[0] == 2);
  assert(evensList[1] == 4);

  // 测试whereType
  var mixedList = CppList<dynamic>();
  mixedList.add(1);
  mixedList.add("hello");
  mixedList.add(2);
  mixedList.add("world");

  var strings = mixedList.whereType<String>();
  var stringsList = strings.toList();
  assert(stringsList.length == 2);
  assert(stringsList[0] == "hello");
  assert(stringsList[1] == "world");

  print("Iterable 过滤操作测试通过!");
}

void testIterableAggregation() {
  print("\n--- 测试 Iterable 聚合操作 ---");

  var list = CppList<int>();
  list.add(1);
  list.add(2);
  list.add(3);
  list.add(4);
  list.add(5);

  // 测试any
  assert(list.any((x) => x > 3));
  assert(!list.any((x) => x > 10));

  // 测试every
  assert(list.every((x) => x > 0));
  assert(!list.every((x) => x > 3));

  // 测试firstWhere
  var firstEven = list.firstWhere((x) => x % 2 == 0);
  assert(firstEven == 2);

  // 测试lastWhere
  var lastEven = list.lastWhere((x) => x % 2 == 0);
  assert(lastEven == 4);

  // 测试singleWhere
  var singleFive = list.singleWhere((x) => x == 5);
  assert(singleFive == 5);

  // 测试reduce
  var sum = list.reduce((a, b) => a + b);
  assert(sum == 15);

  // 测试fold
  var product = list.fold(1, (a, b) => a * b);
  assert(product == 120);

  // 测试join
  var joined = list.join(",");
  assert(joined == "1,2,3,4,5");

  var joinedWithoutSeparator = list.join();
  assert(joinedWithoutSeparator == "12345");

  print("Iterable 聚合操作测试通过!");
}

void testIterableSlicing() {
  print("\n--- 测试 Iterable 切片操作 ---");

  var list = CppList<int>();
  list.add(1);
  list.add(2);
  list.add(3);
  list.add(4);
  list.add(5);

  // 测试take
  var first3 = list.take(3);
  var first3List = first3.toList();
  assert(first3List.length == 3);
  assert(first3List[0] == 1);
  assert(first3List[1] == 2);
  assert(first3List[2] == 3);

  // 测试takeWhile
  var takeWhileSmall = list.takeWhile((x) => x < 4);
  var takeWhileList = takeWhileSmall.toList();
  assert(takeWhileList.length == 3);
  assert(takeWhileList[0] == 1);
  assert(takeWhileList[1] == 2);
  assert(takeWhileList[2] == 3);

  // 测试skip
  var skip2 = list.skip(2);
  var skip2List = skip2.toList();
  assert(skip2List.length == 3);
  assert(skip2List[0] == 3);
  assert(skip2List[1] == 4);
  assert(skip2List[2] == 5);

  // 测试skipWhile
  var skipWhileSmall = list.skipWhile((x) => x < 3);
  var skipWhileList = skipWhileSmall.toList();
  assert(skipWhileList.length == 3);
  assert(skipWhileList[0] == 3);
  assert(skipWhileList[1] == 4);
  assert(skipWhileList[2] == 5);

  // 测试reversed
  var reversed = list.reversed;
  var reversedList = reversed.toList();
  assert(reversedList.length == 5);
  assert(reversedList[0] == 5);
  assert(reversedList[1] == 4);
  assert(reversedList[2] == 3);
  assert(reversedList[3] == 2);
  assert(reversedList[4] == 1);

  // 测试followedBy
  var list2 = CppList<int>();
  list2.add(6);
  list2.add(7);

  var combined = list.followedBy(list2);
  var combinedList = combined.toList();
  assert(combinedList.length == 7);
  assert(combinedList[0] == 1);
  assert(combinedList[4] == 5);
  assert(combinedList[5] == 6);
  assert(combinedList[6] == 7);

  print("Iterable 切片操作测试通过!");
}

void testSingleElement() {
  print("\n--- 测试单个元素操作 ---");

  var list = CppList<int>();
  list.add(42);

  // 测试single
  assert(list.single == 42);

  // 测试single失败情况
  list.add(43);
  try {
    var _ = list.single;
    assert(false, "应该抛出异常");
  } catch (e) {
    assert(e is StateError);
  }

  print("单个元素操作测试通过!");
}

void testEmptyOperations() {
  print("\n--- 测试空集合操作 ---");

  var emptyList = CppList<int>();

  // 测试空集合的基本属性
  assert(emptyList.isEmpty);
  assert(!emptyList.isNotEmpty);
  assert(emptyList.length == 0);

  // 测试空集合的join
  assert(emptyList.join(",") == "");

  // 测试空集合的any/every
  assert(!emptyList.any((x) => true));
  assert(emptyList.every((x) => false));

  // 测试空集合的转换
  var emptySet = emptyList.toSet();
  assert(emptySet.isEmpty);

  print("空集合操作测试通过!");
}
