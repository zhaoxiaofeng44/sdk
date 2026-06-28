import 'package:dart2cpp/platform/dart/runtime_classes.dart';

void main() {
  testArray();
  testStaticList();
  testStaticMap();
  testStaticSet();
  staticPrint('\n✅ All static collection tests passed!');
}

void testArray() {
  staticPrint('--- Array Tests ---');
  final Array<int> fixedArray = Array(5, fill: 0);
  assert((fixedArray.length == 5));
  assert((fixedArray[0] == 0));
  fixedArray[2] = 42;
  assert((fixedArray[2] == 42));
  staticPrint('  ✓ Fixed size Array');
  final Array<String> fromArray = Array.from(StaticList<String>.of(['a', 'b', 'c']));
  assert((fromArray.length == 3));
  assert((fromArray[1] == 'b'));
  staticPrint('  ✓ Array.from');
  final Array<int> dynamicArray = Array.empty();
  dynamicArray.add(10);
  dynamicArray.add(20);
  dynamicArray.add(30);
  assert((dynamicArray.length == 3));
  assert((dynamicArray[1] == 20));
  dynamicArray.removeAt(1);
  assert((dynamicArray.length == 2));
  assert((dynamicArray[1] == 30));
  staticPrint('  ✓ Dynamic Array add/removeAt');
  assert((dynamicArray.indexOf(30) == 1));
  assert(dynamicArray.contains(10));
  assert(!(dynamicArray.contains(99)));
  staticPrint('  ✓ Array indexOf/contains');
}

void testStaticList() {
  staticPrint('\n--- StaticList Tests ---');
  final StaticList<int> emptyList = StaticList();
  assert(emptyList.isEmpty);
  assert((emptyList.length == 0));
  staticPrint('  ✓ Empty StaticList');
  final StaticList<int> list = StaticList.of(StaticList<int>.of([1, 2, 3, 4, 5]));
  assert((list.length == 5));
  assert((list[0] == 1));
  assert((list[4] == 5));
  staticPrint('  ✓ StaticList.of');
  list.add(6);
  assert((list.length == 6));
  assert((list[5] == 6));
  list[2] = 99;
  assert((list[2] == 99));
  staticPrint('  ✓ StaticList add/operator[]=');
  list.remove(99);
  assert((list.length == 5));
  assert(!(list.contains(99)));
  staticPrint('  ✓ StaticList remove');
  final StaticList<int> doubled = StaticList<int>.of(list.map(ClosureEnv_testStaticList_0_new(GC.allocateLocal(ClosureEnv_testStaticList_0()))).toList());
  assert((doubled.length == list.length));
  assert((doubled[0] == (list[0] * 2)));
  staticPrint('  ✓ StaticList map');
  final StaticList<int> filtered = StaticList<int>.of(list.where(ClosureEnv_testStaticList_1_new(GC.allocateLocal(ClosureEnv_testStaticList_1()))).toList());
  assert((filtered.length > 0));
  for (var i = 0; (i < filtered.length); i = (i + 1)) {
    assert((filtered[i] > 3));
  }
  staticPrint('  ✓ StaticList where');
  final int sum = StaticList.of(StaticList<int>.of([1, 2, 3, 4])).reduce(ClosureEnv_testStaticList_2_new(GC.allocateLocal(ClosureEnv_testStaticList_2())));
  assert((sum == 10));
  staticPrint('  ✓ StaticList reduce');
  final StaticList<String> fl = StaticList.of(StaticList<String>.of(['hello', 'world']));
  assert((fl.first == 'hello'));
  assert((fl.last == 'world'));
  staticPrint('  ✓ StaticList first/last');
  assert((StaticList.of(StaticList<int>.of([1, 2, 3])).toString() == '[1, 2, 3]'));
  staticPrint('  ✓ StaticList toString');
}

void testStaticMap() {
  staticPrint('\n--- StaticMap Tests ---');
  final StaticMap<String, int> emptyMap = StaticMap();
  assert(emptyMap.isEmpty);
  staticPrint('  ✓ Empty StaticMap');
  final StaticMap<String, int> map = StaticMap.of(StaticMap<String, int>.of({'a': 1, 'b': 2, 'c': 3}));
  assert((map.length == 3));
  assert((map['a'] == 1));
  assert((map['b'] == 2));
  assert((map['c'] == 3));
  staticPrint('  ✓ StaticMap.of');
  map['d'] = 4;
  assert((map.length == 4));
  assert((map['d'] == 4));
  map['a'] = 10;
  assert((map['a'] == 10));
  assert((map.length == 4));
  staticPrint('  ✓ StaticMap operator[]=');
  assert(map.containsKey('b'));
  assert(!(map.containsKey('z')));
  assert(map.containsValue(2));
  assert(!(map.containsValue(99)));
  staticPrint('  ✓ StaticMap containsKey/containsValue');
  final int? removed = map.remove('b');
  assert((removed == 2));
  assert((map.length == 3));
  assert(!(map.containsKey('b')));
  staticPrint('  ✓ StaticMap remove');
  assert((map.keys.length == 3));
  assert((map.values.length == 3));
  staticPrint('  ✓ StaticMap keys/values');
  assert((map['nonexistent'] == null));
  staticPrint('  ✓ StaticMap null for missing key');
  final StaticMap<String, int> simpleMap = StaticMap.of(StaticMap<String, int>.of({'x': 1}));
  assert((simpleMap.toString() == '{x: 1}'));
  staticPrint('  ✓ StaticMap toString');
}

void testStaticSet() {
  staticPrint('\n--- StaticSet Tests ---');
  final StaticSet<int> emptySet = StaticSet();
  assert(emptySet.isEmpty);
  staticPrint('  ✓ Empty StaticSet');
  final StaticSet<int> set_ = StaticSet.of(StaticList<int>.of([1, 2, 3, 2, 1]));
  assert((set_.length == 3));
  assert(set_.contains(1));
  assert(set_.contains(2));
  assert(set_.contains(3));
  staticPrint('  ✓ StaticSet.of with deduplication');
  final bool added = set_.add(4);
  assert((added == true));
  assert((set_.length == 4));
  final bool notAdded = set_.add(2);
  assert((notAdded == false));
  assert((set_.length == 4));
  staticPrint('  ✓ StaticSet add uniqueness');
  set_.remove(3);
  assert((set_.length == 3));
  assert(!(set_.contains(3)));
  staticPrint('  ✓ StaticSet remove');
  final StaticSet<int> setA = StaticSet.of(StaticList<int>.of([1, 2, 3]));
  final StaticSet<int> setB = StaticSet.of(StaticList<int>.of([3, 4, 5]));
  final StaticSet<int> unionSet = setA.union(setB);
  assert((unionSet.length == 5));
  staticPrint('  ✓ StaticSet union');
  final StaticSet<int> interSet = setA.intersection(setB);
  assert((interSet.length == 1));
  assert(interSet.contains(3));
  staticPrint('  ✓ StaticSet intersection');
  final StaticSet<int> diffSet = setA.difference(setB);
  assert((diffSet.length == 2));
  assert(diffSet.contains(1));
  assert(diffSet.contains(2));
  assert(!(diffSet.contains(3)));
  staticPrint('  ✓ StaticSet difference');
  final StaticSet<String> strSet = StaticSet.of(StaticList<String>.of(['a', 'b']));
  assert((strSet.toString() == '{a, b}'));
  staticPrint('  ✓ StaticSet toString');
}

class ClosureEnv_testStaticList_0 extends TypeFunction1<int, int> {
  ClosureEnv_testStaticList_0();
  @override
  int call(int x) => closureCall(this, x);
}
ClosureEnv_testStaticList_0 ClosureEnv_testStaticList_0_new(ClosureEnv_testStaticList_0 env_) {
  env_.closureCall = ClosureEnv_testStaticList_0_call;
  return env_;
}
int ClosureEnv_testStaticList_0_call(dynamic env__, int x) {
  final env = env__ as ClosureEnv_testStaticList_0;

  return (x * 2);
}

class ClosureEnv_testStaticList_1 extends TypeFunction1<bool, int> {
  ClosureEnv_testStaticList_1();
  @override
  bool call(int x) => closureCall(this, x);
}
ClosureEnv_testStaticList_1 ClosureEnv_testStaticList_1_new(ClosureEnv_testStaticList_1 env_) {
  env_.closureCall = ClosureEnv_testStaticList_1_call;
  return env_;
}
bool ClosureEnv_testStaticList_1_call(dynamic env__, int x) {
  final env = env__ as ClosureEnv_testStaticList_1;

  return (x > 3);
}

class ClosureEnv_testStaticList_2 extends TypeFunction2<int, int, int> {
  ClosureEnv_testStaticList_2();
  @override
  int call(int a, int b) => closureCall(this, a, b);
}
ClosureEnv_testStaticList_2 ClosureEnv_testStaticList_2_new(ClosureEnv_testStaticList_2 env_) {
  env_.closureCall = ClosureEnv_testStaticList_2_call;
  return env_;
}
int ClosureEnv_testStaticList_2_call(dynamic env__, int a, int b) {
  final env = env__ as ClosureEnv_testStaticList_2;

  return (a + b);
}

