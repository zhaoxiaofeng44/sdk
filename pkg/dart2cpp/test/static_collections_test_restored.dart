import 'package:dart2cpp/platform/dart/runtime_classes.dart';

void main() {
  testList();
  testMap();
  testSet();
  staticPrint('\nAll static collection tests passed!');
  drainScheduler();
}

void testList() {
  staticPrint('--- List Tests ---');
  final StaticList<int> fixedList = StaticList<int>.filled(5, 0);
  assert(((fixedList.classInfo as StaticListClassInfo).get_length!(fixedList) == 5));
  assert(((fixedList.classInfo as StaticListClassInfo).operatorIndex!(fixedList, 0) == 0));
  (fixedList.classInfo as StaticListClassInfo).operatorIndexSet!(fixedList, 2, 42);
  assert(((fixedList.classInfo as StaticListClassInfo).operatorIndex!(fixedList, 2) == 42));
  staticPrint('  OK Fixed size List');
  final StaticList<String> fromList = StaticList<String>.of(StaticList<dynamic>.of(['a', 'b', 'c']));
  assert(((fromList.classInfo as StaticListClassInfo).get_length!(fromList) == 3));
  assert(((fromList.classInfo as StaticListClassInfo).operatorIndex!(fromList, 1) == 'b'));
  staticPrint('  OK List.from');
  final StaticList<int> dynamicList = StaticList<int>();
  (dynamicList.classInfo as StaticListClassInfo).add!(dynamicList, 10);
  (dynamicList.classInfo as StaticListClassInfo).add!(dynamicList, 20);
  (dynamicList.classInfo as StaticListClassInfo).add!(dynamicList, 30);
  assert(((dynamicList.classInfo as StaticListClassInfo).get_length!(dynamicList) == 3));
  assert(((dynamicList.classInfo as StaticListClassInfo).operatorIndex!(dynamicList, 1) == 20));
  (dynamicList.classInfo as StaticListClassInfo).removeAt!(dynamicList, 1);
  assert(((dynamicList.classInfo as StaticListClassInfo).get_length!(dynamicList) == 2));
  assert(((dynamicList.classInfo as StaticListClassInfo).operatorIndex!(dynamicList, 1) == 30));
  staticPrint('  OK List add/removeAt');
  assert(((dynamicList.classInfo as StaticListClassInfo).indexOf!(dynamicList, 30) == 1));
  assert((dynamicList.classInfo as StaticListClassInfo).contains!(dynamicList, 10));
  assert(!((dynamicList.classInfo as StaticListClassInfo).contains!(dynamicList, 99)));
  staticPrint('  OK List indexOf/contains');
  final StaticList<int> emptyList = StaticList<int>();
  assert((emptyList.classInfo as StaticListClassInfo).get_isEmpty!(emptyList));
  assert(((emptyList.classInfo as StaticListClassInfo).get_length!(emptyList) == 0));
  staticPrint('  OK Empty List');
  final StaticList<int> list = StaticList<int>.of([1, 2, 3, 4, 5]);
  final StaticList<int> doubled = StaticList<int>.of((() { final _r0 = StaticList<int>.of((list.classInfo as StaticListClassInfo).map!(list, ClosureEnv_testList_0_new(GC.allocateLocal(ClosureEnv_testList_0())))); return (_r0.classInfo as StaticListClassInfo).toList!(_r0); })());
  assert(((doubled.classInfo as StaticListClassInfo).get_length!(doubled) == (list.classInfo as StaticListClassInfo).get_length!(list)));
  assert(((doubled.classInfo as StaticListClassInfo).operatorIndex!(doubled, 0) == ((list.classInfo as StaticListClassInfo).operatorIndex!(list, 0) * 2)));
  staticPrint('  OK List map');
  final StaticList<int> filtered = StaticList<int>.of((() { final _r1 = StaticList<int>.of((list.classInfo as StaticListClassInfo).where!(list, ClosureEnv_testList_1_new(GC.allocateLocal(ClosureEnv_testList_1())))); return (_r1.classInfo as StaticListClassInfo).toList!(_r1); })());
  assert(((filtered.classInfo as StaticListClassInfo).get_length!(filtered) > 0));
  for (var i = 0; (i < (filtered.classInfo as StaticListClassInfo).get_length!(filtered)); i = (i + 1)) {
    assert(((filtered.classInfo as StaticListClassInfo).operatorIndex!(filtered, i) > 3));
  }
  staticPrint('  OK List where');
  final int sum = (() { final _r2 = StaticList<int>.of([1, 2, 3, 4]); return (_r2.classInfo as StaticListClassInfo).reduce!(_r2, ClosureEnv_testList_2_new(GC.allocateLocal(ClosureEnv_testList_2()))); })();
  assert((sum == 10));
  staticPrint('  OK List reduce');
  final StaticList<String> fl = StaticList<String>.of(['hello', 'world']);
  assert(((fl.classInfo as StaticListClassInfo).get_first!(fl) == 'hello'));
  assert(((fl.classInfo as StaticListClassInfo).get_last!(fl) == 'world'));
  staticPrint('  OK List first/last');
  assert(((() { final _r3 = StaticList<int>.of([1, 2, 3]); return (_r3.classInfo as StaticListClassInfo).toString_!(_r3); })() == '[1, 2, 3]'));
  staticPrint('  OK List toString');
}

void testMap() {
  staticPrint('\n--- Map Tests ---');
  final StaticMap<String, int> emptyMap = StaticMap<String, int>.of({});
  assert((emptyMap.classInfo as StaticMapClassInfo).get_isEmpty!(emptyMap));
  staticPrint('  OK Empty Map');
  final StaticMap<String, int> map = StaticMap<String, int>.of({'a': 1, 'b': 2, 'c': 3});
  assert(((map.classInfo as StaticMapClassInfo).get_length!(map) == 3));
  assert(((map.classInfo as StaticMapClassInfo).operatorIndex!(map, 'a') == 1));
  assert(((map.classInfo as StaticMapClassInfo).operatorIndex!(map, 'b') == 2));
  assert(((map.classInfo as StaticMapClassInfo).operatorIndex!(map, 'c') == 3));
  staticPrint('  OK Map literal');
  (map.classInfo as StaticMapClassInfo).operatorIndexSet!(map, 'd', 4);
  assert(((map.classInfo as StaticMapClassInfo).get_length!(map) == 4));
  assert(((map.classInfo as StaticMapClassInfo).operatorIndex!(map, 'd') == 4));
  (map.classInfo as StaticMapClassInfo).operatorIndexSet!(map, 'a', 10);
  assert(((map.classInfo as StaticMapClassInfo).operatorIndex!(map, 'a') == 10));
  assert(((map.classInfo as StaticMapClassInfo).get_length!(map) == 4));
  staticPrint('  OK Map operator[]=');
  assert((map.classInfo as StaticMapClassInfo).containsKey!(map, 'b'));
  assert(!((map.classInfo as StaticMapClassInfo).containsKey!(map, 'z')));
  assert((map.classInfo as StaticMapClassInfo).containsValue!(map, 2));
  assert(!((map.classInfo as StaticMapClassInfo).containsValue!(map, 99)));
  staticPrint('  OK Map containsKey/containsValue');
  final int? removed = (map.classInfo as StaticMapClassInfo).remove!(map, 'b');
  assert((removed == 2));
  assert(((map.classInfo as StaticMapClassInfo).get_length!(map) == 3));
  assert(!((map.classInfo as StaticMapClassInfo).containsKey!(map, 'b')));
  staticPrint('  OK Map remove');
  assert(((StaticList<String>.of((map.classInfo as StaticMapClassInfo).get_keys!(map)).classInfo as StaticListClassInfo).get_length!(StaticList<String>.of((map.classInfo as StaticMapClassInfo).get_keys!(map))) == 3));
  assert(((StaticList<int>.of((map.classInfo as StaticMapClassInfo).get_values!(map)).classInfo as StaticListClassInfo).get_length!(StaticList<int>.of((map.classInfo as StaticMapClassInfo).get_values!(map))) == 3));
  staticPrint('  OK Map keys/values');
  assert(((map.classInfo as StaticMapClassInfo).operatorIndex!(map, 'nonexistent') == null));
  staticPrint('  OK Map null for missing key');
  IntBox total = IntBox(0);
  (map.classInfo as StaticMapClassInfo).forEach!(map, ClosureEnv_testMap_3_new(GC.allocateLocal(ClosureEnv_testMap_3()), total));
  assert((total.value > 0));
  staticPrint('  OK Map forEach');
}

void testSet() {
  staticPrint('\n--- Set Tests ---');
  final StaticSet<int> emptySet = StaticSet<int>.of((() {   final StaticSet<int> _v4 = StaticSet<int>();
 return _v4; })());
  assert((emptySet.classInfo as StaticSetClassInfo).get_isEmpty!(emptySet));
  staticPrint('  OK Empty Set');
  final StaticSet<int> set_ = StaticSet<int>.of((() {   final StaticSet<int> _v5 = StaticSet<int>();
  (_v5.classInfo as StaticSetClassInfo).add!(_v5, 1);
  (_v5.classInfo as StaticSetClassInfo).add!(_v5, 2);
  (_v5.classInfo as StaticSetClassInfo).add!(_v5, 3);
  (_v5.classInfo as StaticSetClassInfo).add!(_v5, 2);
  (_v5.classInfo as StaticSetClassInfo).add!(_v5, 1);
 return _v5; })());
  assert(((set_.classInfo as StaticSetClassInfo).get_length!(set_) == 3));
  assert((set_.classInfo as StaticSetClassInfo).contains!(set_, 1));
  assert((set_.classInfo as StaticSetClassInfo).contains!(set_, 2));
  assert((set_.classInfo as StaticSetClassInfo).contains!(set_, 3));
  staticPrint('  OK Set with deduplication');
  final bool added = (set_.classInfo as StaticSetClassInfo).add!(set_, 4);
  assert((added == true));
  assert(((set_.classInfo as StaticSetClassInfo).get_length!(set_) == 4));
  final bool notAdded = (set_.classInfo as StaticSetClassInfo).add!(set_, 2);
  assert((notAdded == false));
  assert(((set_.classInfo as StaticSetClassInfo).get_length!(set_) == 4));
  staticPrint('  OK Set add uniqueness');
  (set_.classInfo as StaticSetClassInfo).remove!(set_, 3);
  assert(((set_.classInfo as StaticSetClassInfo).get_length!(set_) == 3));
  assert(!((set_.classInfo as StaticSetClassInfo).contains!(set_, 3)));
  staticPrint('  OK Set remove');
  final StaticSet<int> setA = StaticSet<int>.of((() {   final StaticSet<int> _v6 = StaticSet<int>();
  (_v6.classInfo as StaticSetClassInfo).add!(_v6, 1);
  (_v6.classInfo as StaticSetClassInfo).add!(_v6, 2);
  (_v6.classInfo as StaticSetClassInfo).add!(_v6, 3);
 return _v6; })());
  final StaticSet<int> setB = StaticSet<int>.of((() {   final StaticSet<int> _v7 = StaticSet<int>();
  (_v7.classInfo as StaticSetClassInfo).add!(_v7, 3);
  (_v7.classInfo as StaticSetClassInfo).add!(_v7, 4);
  (_v7.classInfo as StaticSetClassInfo).add!(_v7, 5);
 return _v7; })());
  final StaticSet<int> unionSet = StaticSet<int>.of((setA.classInfo as StaticSetClassInfo).union!(setA, setB));
  assert(((unionSet.classInfo as StaticSetClassInfo).get_length!(unionSet) == 5));
  staticPrint('  OK Set union');
  final StaticSet<int> interSet = StaticSet<int>.of((setA.classInfo as StaticSetClassInfo).intersection!(setA, setB));
  assert(((interSet.classInfo as StaticSetClassInfo).get_length!(interSet) == 1));
  assert((interSet.classInfo as StaticSetClassInfo).contains!(interSet, 3));
  staticPrint('  OK Set intersection');
  final StaticSet<int> diffSet = StaticSet<int>.of((setA.classInfo as StaticSetClassInfo).difference!(setA, setB));
  assert(((diffSet.classInfo as StaticSetClassInfo).get_length!(diffSet) == 2));
  assert((diffSet.classInfo as StaticSetClassInfo).contains!(diffSet, 1));
  assert((diffSet.classInfo as StaticSetClassInfo).contains!(diffSet, 2));
  assert(!((diffSet.classInfo as StaticSetClassInfo).contains!(diffSet, 3)));
  staticPrint('  OK Set difference');
  IntBox total = IntBox(0);
  (setA.classInfo as StaticSetClassInfo).forEach!(setA, ClosureEnv_testSet_4_new(GC.allocateLocal(ClosureEnv_testSet_4()), total));
  assert((total.value == 6));
  staticPrint('  OK Set forEach');
}

class ClosureEnv_testList_0 extends TypeFunction1<int, int> {
  ClosureEnv_testList_0();
  @override
  int call(int x) => fnPtr(this, x);
}
ClosureEnv_testList_0 ClosureEnv_testList_0_new(ClosureEnv_testList_0 env_) {
  env_.fnPtr = ClosureEnv_testList_0_call;
  return env_;
}
int ClosureEnv_testList_0_call(AnyGC env__, int x) {
  final env = env__ as ClosureEnv_testList_0;

  return (x * 2);
}

class ClosureEnv_testList_1 extends TypeFunction1<bool, int> {
  ClosureEnv_testList_1();
  @override
  bool call(int x) => fnPtr(this, x);
}
ClosureEnv_testList_1 ClosureEnv_testList_1_new(ClosureEnv_testList_1 env_) {
  env_.fnPtr = ClosureEnv_testList_1_call;
  return env_;
}
bool ClosureEnv_testList_1_call(AnyGC env__, int x) {
  final env = env__ as ClosureEnv_testList_1;

  return (x > 3);
}

class ClosureEnv_testList_2 extends TypeFunction2<int, int, int> {
  ClosureEnv_testList_2();
  @override
  int call(int a, int b) => fnPtr(this, a, b);
}
ClosureEnv_testList_2 ClosureEnv_testList_2_new(ClosureEnv_testList_2 env_) {
  env_.fnPtr = ClosureEnv_testList_2_call;
  return env_;
}
int ClosureEnv_testList_2_call(AnyGC env__, int a, int b) {
  final env = env__ as ClosureEnv_testList_2;

  return (a + b);
}

class ClosureEnv_testMap_3 extends TypeFunction2<void, String, int> {
  late IntBox total;
  ClosureEnv_testMap_3();
  @override
  void call(String k, int v) => fnPtr(this, k, v);
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
    if (total is AnyGC) (total as AnyGC).gcMark(flag);
  }
}
ClosureEnv_testMap_3 ClosureEnv_testMap_3_new(ClosureEnv_testMap_3 env_, IntBox total) {
  env_.fnPtr = ClosureEnv_testMap_3_call;
  env_.total = total;
  return env_;
}
void ClosureEnv_testMap_3_call(AnyGC env__, String k, int v) {
  final env = env__ as ClosureEnv_testMap_3;

    env.total.value = (env.total.value + v);
  }

class ClosureEnv_testSet_4 extends TypeFunction1<void, int> {
  late IntBox total;
  ClosureEnv_testSet_4();
  @override
  void call(int x) => fnPtr(this, x);
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
    if (total is AnyGC) (total as AnyGC).gcMark(flag);
  }
}
ClosureEnv_testSet_4 ClosureEnv_testSet_4_new(ClosureEnv_testSet_4 env_, IntBox total) {
  env_.fnPtr = ClosureEnv_testSet_4_call;
  env_.total = total;
  return env_;
}
void ClosureEnv_testSet_4_call(AnyGC env__, int x) {
  final env = env__ as ClosureEnv_testSet_4;

    env.total.value = (env.total.value + x);
  }

