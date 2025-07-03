import 'list.dart';

void main() {
  print('开始测试 CppList 的 List 接口实现...\n');

  // 测试工厂方法
  testFactoryMethods();

  // 测试基本操作
  testBasicOperations();

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

  // 测试 empty
  var emptyList = CppList.empty();
  print('empty(): ${emptyList.length == 0 ? '✓' : '✗'}');

  // 测试 filled
  var filledList = CppList.filled(3, 'test');
  print(
      'filled(): ${filledList.length == 3 && filledList.every((e) => e == 'test') ? '✓' : '✗'}');

  // 测试 from
  var fromList = CppList.from([1, 2, 3]);
  print('from(): ${fromList.length == 3 ? '✓' : '✗'}');

  // 测试 of
  var ofList = CppList.of([4, 5, 6]);
  print('of(): ${ofList.length == 3 ? '✓' : '✗'}');

  // 测试 generate
  var generateList = CppList.generate(3, (i) => i * 2);
  print(
      'generate(): ${generateList.length == 3 && generateList[1] == 2 ? '✓' : '✗'}');

  // 测试 unmodifiable
  var unmodifiableList = CppList.unmodifiable([7, 8, 9]);
  print('unmodifiable(): ${unmodifiableList.length == 3 ? '✓' : '✗'}');

  print('');
}

void testBasicOperations() {
  print('=== 测试基本操作 ===');

  var list = CppList<int>(0, 10);

  // 测试 add
  list.add(1);
  list.add(2);
  list.add(3);
  print('add(): ${list.length == 3 ? '✓' : '✗'}');

  // 测试索引访问
  print('operator[]: ${list[0] == 1 && list[1] == 2 ? '✓' : '✗'}');

  // 测试索引赋值
  list[1] = 5;
  print('operator[]=: ${list[1] == 5 ? '✓' : '✗'}');

  // 测试 length
  print('length: ${list.length == 3 ? '✓' : '✗'}');

  // 测试 isEmpty/isNotEmpty
  print('isEmpty/isNotEmpty: ${!list.isEmpty && list.isNotEmpty ? '✓' : '✗'}');

  // 测试 first/last/single
  print('first: ${list.first == 1 ? '✓' : '✗'}');
  print('last: ${list.last == 3 ? '✓' : '✗'}');

  var singleList = CppList.from([42]);
  print('single: ${singleList.single == 42 ? '✓' : '✗'}');

  print('');
}

void testIteratorOperations() {
  print('=== 测试迭代器操作 ===');

  var list = CppList.from([1, 2, 3, 4, 5]);

  // 测试 iterator
  int sum = 0;
  for (var element in list) {
    sum += element as int;
  }
  print('iterator: ${sum == 15 ? '✓' : '✗'}');

  // 测试 forEach
  int forEachSum = 0;
  list.forEach((element) => forEachSum += element as int);
  print('forEach: ${forEachSum == 15 ? '✓' : '✗'}');

  print('');
}

void testSearchOperations() {
  print('=== 测试查找操作 ===');

  var list = CppList.from([1, 2, 3, 4, 5, 2]);

  // 测试 contains
  print('contains: ${list.contains(3) && !list.contains(6) ? '✓' : '✗'}');

  // 测试 indexOf
  print('indexOf: ${list.indexOf(2) == 1 ? '✓' : '✗'}');

  // 测试 lastIndexOf
  print('lastIndexOf: ${list.lastIndexOf(2) == 5 ? '✓' : '✗'}');

  // 测试 indexWhere
  print('indexWhere: ${list.indexWhere((e) => e > 3) == 3 ? '✓' : '✗'}');

  // 测试 lastIndexWhere
  print(
      'lastIndexWhere: ${list.lastIndexWhere((e) => e < 4) == 5 ? '✓' : '✗'}');

  // 测试 elementAt
  print('elementAt: ${list.elementAt(2) == 3 ? '✓' : '✗'}');

  print('');
}

void testModificationOperations() {
  print('=== 测试修改操作 ===');

  var list = CppList.from([1, 2, 3]);

  // 测试 insert
  list.insert(1, 5);
  print('insert: ${list.length == 4 && list[1] == 5 ? '✓' : '✗'}');

  // 测试 insertAll
  list.insertAll(2, [6, 7]);
  print('insertAll: ${list.length == 6 && list[2] == 6 ? '✓' : '✗'}');

  // 测试 remove
  var removed = list.remove(5);
  print('remove: ${removed && list.length == 5 ? '✓' : '✗'}');

  // 测试 removeAt
  var removedElement = list.removeAt(1);
  print('removeAt: ${removedElement == 6 && list.length == 4 ? '✓' : '✗'}');

  // 测试 removeLast
  var lastElement = list.removeLast();
  print('removeLast: ${lastElement == 3 && list.length == 3 ? '✓' : '✗'}');

  // 测试 clear
  list.clear();
  print('clear: ${list.length == 0 ? '✓' : '✗'}');

  print('');
}

void testTransformationOperations() {
  print('=== 测试转换操作 ===');

  var list = CppList.from([1, 2, 3, 4, 5]);

  // 测试 map
  var doubled = list.map((e) => e * 2);
  print('map: ${doubled.first == 2 ? '✓' : '✗'}');

  // 测试 where
  var evens = list.where((e) => e % 2 == 0);
  print('where: ${evens.length == 2 ? '✓' : '✗'}');

  // 测试 take
  var taken = list.take(3);
  print('take: ${taken.length == 3 ? '✓' : '✗'}');

  // 测试 skip
  var skipped = list.skip(2);
  print('skip: ${skipped.first == 3 ? '✓' : '✗'}');

  // 测试 sublist
  var sub = list.sublist(1, 4);
  print('sublist: ${sub.length == 3 && sub.first == 2 ? '✓' : '✗'}');

  // 测试 toList
  var newList = list.toList();
  print('toList: ${newList.length == list.length ? '✓' : '✗'}');

  // 测试 toSet
  var set = list.toSet();
  print('toSet: ${set.length == list.length ? '✓' : '✗'}');

  // 测试 join
  var joined = list.join(',');
  print('join: ${joined == '1,2,3,4,5' ? '✓' : '✗'}');

  // 测试 toString
  var str = list.toString();
  print('toString: ${str == '[1, 2, 3, 4, 5]' ? '✓' : '✗'}');

  print('');
}
