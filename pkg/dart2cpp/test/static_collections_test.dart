void main() {
  testList();
  testMap();
  testSet();
  print('\nAll static collection tests passed!');
}

void testList() {
  print('--- List Tests ---');

  // filled
  final fixedList = List<int>.filled(5, 0);
  assert(fixedList.length == 5);
  assert(fixedList[0] == 0);
  fixedList[2] = 42;
  assert(fixedList[2] == 42);
  print('  OK Fixed size List');

  // from
  final fromList = List<String>.from(['a', 'b', 'c']);
  assert(fromList.length == 3);
  assert(fromList[1] == 'b');
  print('  OK List.from');

  // dynamic add/remove
  final dynamicList = <int>[];
  dynamicList.add(10);
  dynamicList.add(20);
  dynamicList.add(30);
  assert(dynamicList.length == 3);
  assert(dynamicList[1] == 20);
  dynamicList.removeAt(1);
  assert(dynamicList.length == 2);
  assert(dynamicList[1] == 30);
  print('  OK List add/removeAt');

  // indexOf / contains
  assert(dynamicList.indexOf(30) == 1);
  assert(dynamicList.contains(10));
  assert(!dynamicList.contains(99));
  print('  OK List indexOf/contains');

  // empty list
  final emptyList = <int>[];
  assert(emptyList.isEmpty);
  assert(emptyList.length == 0);
  print('  OK Empty List');

  // map / where
  final list = [1, 2, 3, 4, 5];
  final doubled = list.map((x) => x * 2).toList();
  assert(doubled.length == list.length);
  assert(doubled[0] == list[0] * 2);
  print('  OK List map');

  final filtered = list.where((x) => x > 3).toList();
  assert(filtered.length > 0);
  for (int i = 0; i < filtered.length; i++) {
    assert(filtered[i] > 3);
  }
  print('  OK List where');

  // reduce
  final sum = [1, 2, 3, 4].reduce((a, b) => a + b);
  assert(sum == 10);
  print('  OK List reduce');

  // first / last
  final fl = ['hello', 'world'];
  assert(fl.first == 'hello');
  assert(fl.last == 'world');
  print('  OK List first/last');

  // toString
  assert([1, 2, 3].toString() == '[1, 2, 3]');
  print('  OK List toString');
}

void testMap() {
  print('\n--- Map Tests ---');

  // empty map
  final emptyMap = <String, int>{};
  assert(emptyMap.isEmpty);
  print('  OK Empty Map');

  // from literal
  final map = <String, int>{'a': 1, 'b': 2, 'c': 3};
  assert(map.length == 3);
  assert(map['a'] == 1);
  assert(map['b'] == 2);
  assert(map['c'] == 3);
  print('  OK Map literal');

  // operator[]=
  map['d'] = 4;
  assert(map.length == 4);
  assert(map['d'] == 4);
  map['a'] = 10;
  assert(map['a'] == 10);
  assert(map.length == 4);
  print('  OK Map operator[]=');

  // containsKey / containsValue
  assert(map.containsKey('b'));
  assert(!map.containsKey('z'));
  assert(map.containsValue(2));
  assert(!map.containsValue(99));
  print('  OK Map containsKey/containsValue');

  // remove
  final removed = map.remove('b');
  assert(removed == 2);
  assert(map.length == 3);
  assert(!map.containsKey('b'));
  print('  OK Map remove');

  // keys / values
  assert(map.keys.length == 3);
  assert(map.values.length == 3);
  print('  OK Map keys/values');

  // missing key returns null
  assert(map['nonexistent'] == null);
  print('  OK Map null for missing key');

  // forEach
  int total = 0;
  map.forEach((k, v) { total += v; });
  assert(total > 0);
  print('  OK Map forEach');
}

void testSet() {
  print('\n--- Set Tests ---');

  // empty set
  final emptySet = <int>{};
  assert(emptySet.isEmpty);
  print('  OK Empty Set');

  // from literal (dedup)
  final set = <int>{1, 2, 3, 2, 1};
  assert(set.length == 3);
  assert(set.contains(1));
  assert(set.contains(2));
  assert(set.contains(3));
  print('  OK Set with deduplication');

  // add (uniqueness)
  final added = set.add(4);
  assert(added == true);
  assert(set.length == 4);
  final notAdded = set.add(2);
  assert(notAdded == false);
  assert(set.length == 4);
  print('  OK Set add uniqueness');

  // remove
  set.remove(3);
  assert(set.length == 3);
  assert(!set.contains(3));
  print('  OK Set remove');

  // union
  final setA = <int>{1, 2, 3};
  final setB = <int>{3, 4, 5};
  final unionSet = setA.union(setB);
  assert(unionSet.length == 5);
  print('  OK Set union');

  // intersection
  final interSet = setA.intersection(setB);
  assert(interSet.length == 1);
  assert(interSet.contains(3));
  print('  OK Set intersection');

  // difference
  final diffSet = setA.difference(setB);
  assert(diffSet.length == 2);
  assert(diffSet.contains(1));
  assert(diffSet.contains(2));
  assert(!diffSet.contains(3));
  print('  OK Set difference');

  // forEach
  int total = 0;
  setA.forEach((x) { total += x; });
  assert(total == 6);
  print('  OK Set forEach');
}
