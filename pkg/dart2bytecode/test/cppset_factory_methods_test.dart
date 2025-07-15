import '../lib/demo/collection.dart';

void main() {
  print('=== 测试 CppSet 的 Factory 和静态方法 ===\n');

  // 测试工厂方法
  testFactoryMethods();

  // 测试静态方法
  testStaticMethods();

  // 测试类型转换
  testCastMethods();

  // 测试集合操作
  testSetOperations();

  print('所有测试完成！');
}

void testFactoryMethods() {
  print('--- 测试 Factory 方法 ---');

  // 测试 identity()
  var identitySet = CppSet<int>.identity();
  print('identity(): ${identitySet.length == 0 ? '✓' : '✗'}');

  // 测试 from()
  var fromSet = CppSet<int>.from([1, 2, 3, 2, 1]);
  print('from(): ${fromSet.length == 3 ? '✓' : '✗'}'); // 去重后应该是3个元素

  // 测试 of()
  var ofSet = CppSet<int>.of([4, 5, 6, 4]);
  print('of(): ${ofSet.length == 3 ? '✓' : '✗'}');

  // 测试 unmodifiable()
  var unmodifiableSet = CppSet<int>.unmodifiable([7, 8, 9, 7]);
  print('unmodifiable(): ${unmodifiableSet.length == 3 ? '✓' : '✗'}');

  print('');
}

void testStaticMethods() {
  print('--- 测试静态方法 ---');

  // 测试 castFrom()
  var sourceSet = CppSet<int>();
  sourceSet.add(1);
  sourceSet.add(2);
  sourceSet.add(3);

  var castSet = CppSet.castFrom<int, num>(sourceSet);
  print('castFrom(): ${castSet.length == 3 ? '✓' : '✗'}');

  // 测试 castFromWithFactory()
  var castWithFactorySet =
      CppSet.castFromWithFactory<int, num>(sourceSet, () => CppSet<num>());
  print('castFromWithFactory(): ${castWithFactorySet.length == 3 ? '✓' : '✗'}');

  print('');
}

void testCastMethods() {
  print('--- 测试类型转换方法 ---');

  var set = CppSet<int>();
  set.add(1);
  set.add(2);
  set.add(3);

  // 测试 cast() 实例方法
  var castSet = set.cast<num>();
  print('cast() 实例方法: ${castSet.length == 3 ? '✓' : '✗'}');

  // 测试 toSet()
  var toSetResult = set.toSet();
  print('toSet(): ${toSetResult.length == 3 ? '✓' : '✗'}');

  print('');
}

void testSetOperations() {
  print('--- 测试集合操作 ---');

  var set1 = CppSet<int>();
  set1.add(1);
  set1.add(2);
  set1.add(3);

  var set2 = CppSet<int>();
  set2.add(2);
  set2.add(3);
  set2.add(4);

  // 测试 union()
  var unionSet = set1.union(set2);
  print('union(): ${unionSet.length == 4 ? '✓' : '✗'}');

  // 测试 intersection()
  var intersectionSet = set1.intersection(set2);
  print('intersection(): ${intersectionSet.length == 2 ? '✓' : '✗'}');

  // 测试 difference()
  var differenceSet = set1.difference(set2);
  print('difference(): ${differenceSet.length == 1 ? '✓' : '✗'}');

  // 测试 retainAll()
  var retainSet = CppSet<int>();
  retainSet.add(2);
  retainSet.add(3);
  set1.retainAll(retainSet);
  print('retainAll(): ${set1.length == 2 ? '✓' : '✗'}');

  print('');
}
