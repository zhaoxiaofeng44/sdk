import 'package:dart2cpp/restorer/runtime_classes.dart';

void main() {
  testArray();
  testStaticList();
  testStaticMap();
  testStaticSet();
  print('\n✅ All static collection tests passed!');
}

void testArray() {
  print('--- Array Tests ---');

  // 固定大小
  final fixedArray = Array<int>(5, fill: 0);
  assert(fixedArray.length == 5);
  assert(fixedArray[0] == 0);
  fixedArray[2] = 42;
  assert(fixedArray[2] == 42);
  print('  ✓ Fixed size Array');

  // 从列表创建
  final fromArray = Array<String>.from(['a', 'b', 'c']);
  assert(fromArray.length == 3);
  assert(fromArray[1] == 'b');
  print('  ✓ Array.from');

  // 动态操作
  final dynamicArray = Array<int>.empty();
  dynamicArray.add(10);
  dynamicArray.add(20);
  dynamicArray.add(30);
  assert(dynamicArray.length == 3);
  assert(dynamicArray[1] == 20);
  dynamicArray.removeAt(1);
  assert(dynamicArray.length == 2);
  assert(dynamicArray[1] == 30);
  print('  ✓ Dynamic Array add/removeAt');

  // indexOf / contains
  assert(dynamicArray.indexOf(30) == 1);
  assert(dynamicArray.contains(10));
  assert(!dynamicArray.contains(99));
  print('  ✓ Array indexOf/contains');
}

void testStaticList() {
  print('\n--- StaticList Tests ---');

  // 空列表
  final emptyList = StaticList<int>();
  assert(emptyList.isEmpty);
  assert(emptyList.length == 0);
  print('  ✓ Empty StaticList');

  // of 构造
  final list = StaticList<int>.of([1, 2, 3, 4, 5]);
  assert(list.length == 5);
  assert(list[0] == 1);
  assert(list[4] == 5);
  print('  ✓ StaticList.of');

  // 基本操作
  list.add(6);
  assert(list.length == 6);
  assert(list[5] == 6);
  list[2] = 99;
  assert(list[2] == 99);
  print('  ✓ StaticList add/operator[]=');

  // remove
  list.remove(99);
  assert(list.length == 5);
  assert(!list.contains(99));
  print('  ✓ StaticList remove');

  // map / where (via ListMixin)
  final doubled = list.map((x) => x * 2).toList();
  assert(doubled.length == list.length);
  assert(doubled[0] == list[0] * 2);
  print('  ✓ StaticList map');

  final filtered = list.where((x) => x > 3).toList();
  assert(filtered.length > 0);
  for (int i = 0; i < filtered.length; i++) {
    assert(filtered[i] > 3);
  }
  print('  ✓ StaticList where');

  // reduce
  final sum = StaticList<int>.of([1, 2, 3, 4]).reduce((a, b) => a + b);
  assert(sum == 10);
  print('  ✓ StaticList reduce');

  // first / last
  final fl = StaticList<String>.of(['hello', 'world']);
  assert(fl.first == 'hello');
  assert(fl.last == 'world');
  print('  ✓ StaticList first/last');

  // toString
  assert(StaticList<int>.of([1, 2, 3]).toString() == '[1, 2, 3]');
  print('  ✓ StaticList toString');
}

void testStaticMap() {
  print('\n--- StaticMap Tests ---');

  // 空 map
  final emptyMap = StaticMap<String, int>();
  assert(emptyMap.isEmpty);
  print('  ✓ Empty StaticMap');

  // of 构造
  final map = StaticMap<String, int>.of({'a': 1, 'b': 2, 'c': 3});
  assert(map.length == 3);
  assert(map['a'] == 1);
  assert(map['b'] == 2);
  assert(map['c'] == 3);
  print('  ✓ StaticMap.of');

  // operator[]=
  map['d'] = 4;
  assert(map.length == 4);
  assert(map['d'] == 4);
  map['a'] = 10;
  assert(map['a'] == 10);
  assert(map.length == 4); // 覆盖不增加长度
  print('  ✓ StaticMap operator[]=');

  // containsKey / containsValue
  assert(map.containsKey('b'));
  assert(!map.containsKey('z'));
  assert(map.containsValue(2));
  assert(!map.containsValue(99));
  print('  ✓ StaticMap containsKey/containsValue');

  // remove
  final removed = map.remove('b');
  assert(removed == 2);
  assert(map.length == 3);
  assert(!map.containsKey('b'));
  print('  ✓ StaticMap remove');

  // keys / values
  assert(map.keys.length == 3);
  assert(map.values.length == 3);
  print('  ✓ StaticMap keys/values');

  // 不存在的 key 返回 null
  assert(map['nonexistent'] == null);
  print('  ✓ StaticMap null for missing key');

  // toString
  final simpleMap = StaticMap<String, int>.of({'x': 1});
  assert(simpleMap.toString() == '{x: 1}');
  print('  ✓ StaticMap toString');
}

void testStaticSet() {
  print('\n--- StaticSet Tests ---');

  // 空 set
  final emptySet = StaticSet<int>();
  assert(emptySet.isEmpty);
  print('  ✓ Empty StaticSet');

  // of 构造（去重）
  final set = StaticSet<int>.of([1, 2, 3, 2, 1]);
  assert(set.length == 3);
  assert(set.contains(1));
  assert(set.contains(2));
  assert(set.contains(3));
  print('  ✓ StaticSet.of with deduplication');

  // add（唯一性）
  final added = set.add(4);
  assert(added == true);
  assert(set.length == 4);
  final notAdded = set.add(2);
  assert(notAdded == false);
  assert(set.length == 4);
  print('  ✓ StaticSet add uniqueness');

  // remove
  set.remove(3);
  assert(set.length == 3);
  assert(!set.contains(3));
  print('  ✓ StaticSet remove');

  // union
  final setA = StaticSet<int>.of([1, 2, 3]);
  final setB = StaticSet<int>.of([3, 4, 5]);
  final unionSet = setA.union(setB);
  assert(unionSet.length == 5);
  print('  ✓ StaticSet union');

  // intersection
  final interSet = setA.intersection(setB);
  assert(interSet.length == 1);
  assert(interSet.contains(3));
  print('  ✓ StaticSet intersection');

  // difference
  final diffSet = setA.difference(setB);
  assert(diffSet.length == 2);
  assert(diffSet.contains(1));
  assert(diffSet.contains(2));
  assert(!diffSet.contains(3));
  print('  ✓ StaticSet difference');

  // toString
  final strSet = StaticSet<String>.of(['a', 'b']);
  assert(strSet.toString() == '{a, b}');
  print('  ✓ StaticSet toString');
}
