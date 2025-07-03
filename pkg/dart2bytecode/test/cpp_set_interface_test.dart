import 'list.dart';

void main() {
  print('开始测试 CppSet 的 Set 接口实现...\n');

  // 测试工厂方法
  testFactoryMethods();

  // 测试基本操作
  testBasicOperations();

  // 测试集合操作
  testSetOperations();

  // 测试迭代器操作
  testIteratorOperations();

  // 测试查找操作
  testSearchOperations();

  // 测试修改操作
  testModificationOperations();

  // 测试转换操作
  testTransformationOperations();

  print('所有测试完成！');
}

void testFactoryMethods() {
  print('=== 测试工厂方法 ===');

  // 测试 identity
  var identitySet = CppSet.identity();
  print('identity(): ${identitySet.length == 0 ? '✓' : '✗'}');

  // 测试 from
  var fromSet = CppSet.from([1, 2, 3, 2, 1]);
  print('from(): ${fromSet.length == 3 ? '✓' : '✗'}'); // 去重后应该是3个元素

  // 测试 of
  var ofSet = CppSet.of([4, 5, 6, 4]);
  print('of(): ${ofSet.length == 3 ? '✓' : '✗'}');

  // 测试 unmodifiable
  var unmodifiableSet = CppSet.unmodifiable([7, 8, 9, 7]);
  print('unmodifiable(): ${unmodifiableSet.length == 3 ? '✓' : '✗'}');

  print('');
}

void testBasicOperations() {
  print('=== 测试基本操作 ===');

  var set = CppSet<int>();

  // 测试 add
  set.add(1);
  set.add(2);
  set.add(3);
  set.add(1); // 重复元素
  print('add(): ${set.length == 3 ? '✓' : '✗'}');

  // 测试 contains
  print('contains(): ${set.contains(2) && !set.contains(4) ? '✓' : '✗'}');

  // 测试 containsAll
  print('containsAll(): ${set.containsAll([1, 2]) && !set.containsAll([
            1,
            4
          ]) ? '✓' : '✗'}');

  // 测试 lookup
  print('lookup(): ${set.lookup(2) == 2 && set.lookup(4) == null ? '✓' : '✗'}');

  // 测试 isEmpty/isNotEmpty
  print('isEmpty/isNotEmpty: ${!set.isEmpty && set.isNotEmpty ? '✓' : '✗'}');

  // 测试 first/last/single
  print('first: ${set.first == 1 ? '✓' : '✗'}');
  print('last: ${set.last == 3 ? '✓' : '✗'}');

  var singleSet = CppSet.from([42]);
  print('single: ${singleSet.single == 42 ? '✓' : '✗'}');

  print('');
}

void testSetOperations() {
  print('=== 测试集合操作 ===');

  var set1 = CppSet.from([1, 2, 3, 4]);
  var set2 = CppSet.from([3, 4, 5, 6]);

  // 测试 union
  var unionSet = set1.union(set2);
  print('union(): ${unionSet.length == 6 ? '✓' : '✗'}');

  // 测试 intersection
  var intersectionSet = set1.intersection(set2);
  print('intersection(): ${intersectionSet.length == 2 ? '✓' : '✗'}');

  // 测试 difference
  var differenceSet = set1.difference(set2);
  print('difference(): ${differenceSet.length == 2 ? '✓' : '✗'}');

  print('');
}

void testIteratorOperations() {
  print('=== 测试迭代器操作 ===');

  var set = CppSet.from([1, 2, 3, 4, 5]);

  // 测试 iterator
  int sum = 0;
  for (var element in set) {
    sum += element as int;
  }
  print('iterator: ${sum == 15 ? '✓' : '✗'}');

  // 测试 forEach
  int forEachSum = 0;
  set.forEach((element) => forEachSum += element as int);
  print('forEach: ${forEachSum == 15 ? '✓' : '✗'}');

  // 测试 any
  print('any: ${set.any((e) => e > 3) ? '✓' : '✗'}');

  // 测试 every
  print('every: ${set.every((e) => e > 0) ? '✓' : '✗'}');

  print('');
}

void testSearchOperations() {
  print('=== 测试查找操作 ===');

  var set = CppSet.from([1, 2, 3, 4, 5]);

  // 测试 firstWhere
  var first = set.firstWhere((e) => e > 3);
  print('firstWhere: ${first == 4 ? '✓' : '✗'}');

  // 测试 lastWhere
  var last = set.lastWhere((e) => e < 4);
  print('lastWhere: ${last == 3 ? '✓' : '✗'}');

  // 测试 singleWhere
  var single = set.singleWhere((e) => e == 3);
  print('singleWhere: ${single == 3 ? '✓' : '✗'}');

  // 测试 elementAt
  var element = set.elementAt(2);
  print('elementAt: ${element == 3 ? '✓' : '✗'}');

  print('');
}

void testModificationOperations() {
  print('=== 测试修改操作 ===');

  var set = CppSet.from([1, 2, 3]);

  // 测试 addAll
  set.addAll([4, 5, 3]); // 3是重复的
  print('addAll: ${set.length == 5 ? '✓' : '✗'}');

  // 测试 remove
  var removed = set.remove(2);
  print('remove: ${removed && set.length == 4 ? '✓' : '✗'}');

  // 测试 removeAll
  set.removeAll([1, 4]);
  print('removeAll: ${set.length == 2 ? '✓' : '✗'}');

  // 测试 removeWhere
  set.removeWhere((e) => e == 3);
  print('removeWhere: ${set.length == 1 ? '✓' : '✗'}');

  // 测试 retainAll
  set.addAll([6, 7, 8]);
  set.retainAll([5, 6]);
  print('retainAll: ${set.length == 2 ? '✓' : '✗'}');

  // 测试 retainWhere
  set.retainWhere((e) => e > 5);
  print('retainWhere: ${set.length == 1 ? '✓' : '✗'}');

  // 测试 clear
  set.clear();
  print('clear: ${set.length == 0 ? '✓' : '✗'}');

  print('');
}

void testTransformationOperations() {
  print('=== 测试转换操作 ===');

  var set = CppSet.from([1, 2, 3, 4, 5]);

  // 测试 map
  var doubled = set.map((e) => e * 2);
  print('map: ${doubled.first == 2 ? '✓' : '✗'}');

  // 测试 where
  var evens = set.where((e) => e % 2 == 0);
  print('where: ${evens.length == 2 ? '✓' : '✗'}');

  // 测试 take
  var taken = set.take(3);
  print('take: ${taken.length == 3 ? '✓' : '✗'}');

  // 测试 skip
  var skipped = set.skip(2);
  print('skip: ${skipped.first == 3 ? '✓' : '✗'}');

  // 测试 toList
  var list = set.toList();
  print('toList: ${list.length == set.length ? '✓' : '✗'}');

  // 测试 toSet
  var newSet = set.toSet();
  print('toSet: ${newSet.length == set.length ? '✓' : '✗'}');

  // 测试 join
  var joined = set.join(',');
  print('join: ${joined.contains('1,2') ? '✓' : '✗'}');

  // 测试 toString
  var str = set.toString();
  print('toString: ${str.startsWith('{') && str.endsWith('}') ? '✓' : '✗'}');

  // 测试 cast
  var castSet = set.cast<num>();
  print('cast: ${castSet.length == set.length ? '✓' : '✗'}');

  print('');
}
