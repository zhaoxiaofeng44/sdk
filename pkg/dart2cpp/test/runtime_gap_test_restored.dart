import 'package:dart2cpp/platform/dart/runtime_classes.dart';

typedef IntPredicate = TypeFunction1<bool, int>;

class PersonValue extends VPtr {
  late String name = '';
  late int age = 0;
  static Map<String, dynamic>? vptrMap;
  @override
  Map<String, dynamic> get vptr => getVptrMap();
  static Map<String, dynamic> getVptrMap() {
    if (vptrMap == null) {
      vptrMap = <String, dynamic>{'toString': null, 'operatorEq': null, 'get_hashCode': null};
      vptrMap!['greet'] = Person_greet;
    }
    return vptrMap!;
  }
}

PersonValue Person_new(dynamic this__) {
  final this_ = this__ as PersonValue;
  return this_;
}

void Person_greet(dynamic this__) {
  final this_ = this__ as PersonValue;
  staticPrint('Hello, ${this_.name}');
}


class LateTestValue extends VPtr {
  late String value;
  static Map<String, dynamic>? vptrMap;
  @override
  Map<String, dynamic> get vptr => getVptrMap();
  static Map<String, dynamic> getVptrMap() {
    if (vptrMap == null) {
      vptrMap = <String, dynamic>{'toString': null, 'operatorEq': null, 'get_hashCode': null};
      vptrMap!['init'] = LateTest_init;
      vptrMap!['get'] = LateTest_get;
    }
    return vptrMap!;
  }
}

LateTestValue LateTest_new(dynamic this__) {
  final this_ = this__ as LateTestValue;
  return this_;
}

void LateTest_init(dynamic this__) {
  final this_ = this__ as LateTestValue;
  this_.value = 'initialized';
}

String LateTest_get(dynamic this__) {
  final this_ = this__ as LateTestValue;
  return this_.value;
}


enum Color {
  red,
  green,
  blue;
}

String Color_get_name(Color this_) {
  return 'Color.${this_.name}'.split('.').last;
}

int Color_get_value(Color this_) {
  return this_.index;
}

class ShapeValue extends VPtr {
  static Map<String, dynamic>? vptrMap;
  @override
  Map<String, dynamic> get vptr => getVptrMap();
  static Map<String, dynamic> getVptrMap() {
    if (vptrMap == null) {
      vptrMap = <String, dynamic>{'toString': null, 'operatorEq': null, 'get_hashCode': null};
      vptrMap!['area'] = Shape_area;
    }
    return vptrMap!;
  }
}

ShapeValue Shape_new(dynamic this__) {
  final this_ = this__ as ShapeValue;
  return this_;
}

double Shape_area(dynamic this_) {
  throw UnimplementedError('Shape.area is abstract');
}


class CircleValue extends ShapeValue {
  late double radius;
  static Map<String, dynamic>? vptrMap;
  @override
  Map<String, dynamic> get vptr => getVptrMap();
  static Map<String, dynamic> getVptrMap() {
    if (vptrMap == null) {
      vptrMap = Map<String, dynamic>.from(ShapeValue.getVptrMap());
      vptrMap!['area'] = Circle_area;
    }
    return vptrMap!;
  }
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
  }
}

CircleValue Circle_new(dynamic this__, double radius) {
  final this_ = this__ as CircleValue;
  Shape_new(this_);
  this_.radius = radius;
  return this_;
}

double Circle_area(dynamic this__) {
  final this_ = this__ as CircleValue;
  return ((3.14 * this_.radius) * this_.radius);
}


class SquareValue extends ShapeValue {
  late double side;
  static Map<String, dynamic>? vptrMap;
  @override
  Map<String, dynamic> get vptr => getVptrMap();
  static Map<String, dynamic> getVptrMap() {
    if (vptrMap == null) {
      vptrMap = Map<String, dynamic>.from(ShapeValue.getVptrMap());
      vptrMap!['area'] = Square_area;
    }
    return vptrMap!;
  }
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
  }
}

SquareValue Square_new(dynamic this__, double side) {
  final this_ = this__ as SquareValue;
  Shape_new(this_);
  this_.side = side;
  return this_;
}

double Square_area(dynamic this__) {
  final this_ = this__ as SquareValue;
  return (this_.side * this_.side);
}


class VectorValue extends VPtr {
  late double x;
  late double y;
  static Map<String, dynamic>? vptrMap;
  @override
  Map<String, dynamic> get vptr => getVptrMap();
  static Map<String, dynamic> getVptrMap() {
    if (vptrMap == null) {
      vptrMap = <String, dynamic>{'toString': null, 'operatorEq': null, 'get_hashCode': null};
      vptrMap!['operatorPlus'] = Vector_operatorPlus;
      vptrMap!['operatorStar'] = Vector_operatorStar;
      vptrMap!['toString'] = Vector_toString;
    }
    return vptrMap!;
  }
}

VectorValue Vector_new(dynamic this__, double x, double y) {
  final this_ = this__ as VectorValue;
  this_.x = x;
  this_.y = y;
  return this_;
}

VectorValue Vector_operatorPlus(dynamic this__, VectorValue other) {
  final this_ = this__ as VectorValue;
  return Vector_new(GC.allocateLocal(VectorValue()), (this_.x + other.x), (this_.y + other.y));
}

VectorValue Vector_operatorStar(dynamic this__, double scalar) {
  final this_ = this__ as VectorValue;
  return Vector_new(GC.allocateLocal(VectorValue()), (this_.x * scalar), (this_.y * scalar));
}

String Vector_toString(dynamic this__) {
  final this_ = this__ as VectorValue;
  return '(${this_.x}, ${this_.y})';
}


class CounterValue extends VPtr {
  static Map<String, dynamic>? vptrMap;
  @override
  Map<String, dynamic> get vptr => getVptrMap();
  static Map<String, dynamic> getVptrMap() {
    if (vptrMap == null) {
      vptrMap = <String, dynamic>{'toString': null, 'operatorEq': null, 'get_hashCode': null};
    }
    return vptrMap!;
  }
}

int Counter_count = 0;
CounterValue Counter_new(dynamic this__) {
  final this_ = this__ as CounterValue;
  return this_;
}

void Counter_increment() {
  Counter_count = (Counter_count + 1);
}

int Counter_value() {
  return Counter_count;
}


class AnimalValue extends VPtr {
  static Map<String, dynamic>? vptrMap;
  @override
  Map<String, dynamic> get vptr => getVptrMap();
  static Map<String, dynamic> getVptrMap() {
    if (vptrMap == null) {
      vptrMap = <String, dynamic>{'toString': null, 'operatorEq': null, 'get_hashCode': null};
      vptrMap!['speak'] = Animal_speak;
    }
    return vptrMap!;
  }
}

AnimalValue Animal_new(dynamic this__) {
  final this_ = this__ as AnimalValue;
  return this_;
}

void Animal_speak(dynamic this_) {
  throw UnimplementedError('Animal.speak is abstract');
}


class DogValue extends VPtr implements AnimalValue {
  static Map<String, dynamic>? vptrMap;
  @override
  Map<String, dynamic> get vptr => getVptrMap();
  static Map<String, dynamic> getVptrMap() {
    if (vptrMap == null) {
      vptrMap = <String, dynamic>{'toString': null, 'operatorEq': null, 'get_hashCode': null};
      vptrMap!['speak'] = Dog_speak;
    }
    return vptrMap!;
  }
}

DogValue Dog_new(dynamic this__) {
  final this_ = this__ as DogValue;
  return this_;
}

void Dog_speak(dynamic this__) {
  final this_ = this__ as DogValue;
  staticPrint('Woof!');
}


// mixin Flyable → static functions for delegation
void Flyable_fly(dynamic this__) {
  final this_ = this__;
  staticPrint('Flying!');
}


// mixin Swimmable → static functions for delegation
void Swimmable_swim(dynamic this__) {
  final this_ = this__;
  staticPrint('Swimming!');
}


class DuckValue extends Duck_Object_Flyable_SwimmableValue {
  static Map<String, dynamic>? vptrMap;
  @override
  Map<String, dynamic> get vptr => getVptrMap();
  static Map<String, dynamic> getVptrMap() {
    if (vptrMap == null) {
      vptrMap = Map<String, dynamic>.from(Duck_Object_Flyable_SwimmableValue.getVptrMap());
      vptrMap!['fly'] = Duck_fly;
      vptrMap!['swim'] = Duck_swim;
      vptrMap!['quack'] = Duck_quack;
    }
    return vptrMap!;
  }
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
  }
}

DuckValue Duck_new(dynamic this__) {
  final this_ = this__ as DuckValue;
  return this_;
}

void Duck_quack(dynamic this__) {
  final this_ = this__ as DuckValue;
  staticPrint('Quack!');
}

void Duck_fly(dynamic this__) {
  final this_ = this__ as DuckValue;
  Flyable_fly(this_);
}

void Duck_swim(dynamic this__) {
  final this_ = this__ as DuckValue;
  Swimmable_swim(this_);
}


class Duck_Object_FlyableValue extends VPtr {
  static Map<String, dynamic>? vptrMap;
  @override
  Map<String, dynamic> get vptr => getVptrMap();
  static Map<String, dynamic> getVptrMap() {
    if (vptrMap == null) {
      vptrMap = <String, dynamic>{'toString': null, 'operatorEq': null, 'get_hashCode': null};
    }
    return vptrMap!;
  }
}


class Duck_Object_Flyable_SwimmableValue extends Duck_Object_FlyableValue {
  static Map<String, dynamic>? vptrMap;
  @override
  Map<String, dynamic> get vptr => getVptrMap();
  static Map<String, dynamic> getVptrMap() {
    if (vptrMap == null) {
      vptrMap = Map<String, dynamic>.from(Duck_Object_FlyableValue.getVptrMap());
    }
    return vptrMap!;
  }
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
  }
}


void testSpread() {
  final StaticList<int> list1 = StaticList<int>.of([1, 2, 3]);
  final StaticList<int> list2 = StaticList<int>.of([4, 5, 6]);
  final StaticList<int> combined = StaticList<int>.of((() {   final StaticList<int> _v0 = StaticList<int>.of(list1);
  _v0.addAll(list2);
 return _v0; })());
  staticPrint(combined);
  final StaticMap<String, int> map1 = StaticMap<String, int>.of({'a': 1});
  final StaticMap<String, int> map2 = StaticMap<String, int>.of({'b': 2});
  final StaticMap<String, int> combinedMap = StaticMap<String, int>.of((() {   final StaticMap<String, int> _v1 = StaticMap<String, int>.of(map1);
  _v1.addAll(map2);
 return _v1; })());
  staticPrint(combinedMap);
}

void testCollectionIfFor() {
  final bool includeExtra = true;
  final StaticList<int> list = StaticList<int>.of((() {   final StaticList<int> _v2 = StaticList<int>.of([1]);
  if (includeExtra)   _v2.add(2);
  for (var i = 3; (i <= 5); i = (i + 1))   _v2.add(i);
 return _v2; })());
  staticPrint(list);
}

void testCascade() {
  final PersonValue p = (() { final _let3 = Person_new(GC.allocateLocal(PersonValue())); _let3.name = 'Alice'; _let3.age = 30; (_let3.vptr['greet'] as void Function(dynamic))(_let3); return _let3; })();
  staticPrint(p.name);
}

void testNullAware() {
  String? nullable;
  final String result = (nullable ?? 'default');
  staticPrint(result);
  final int length = (nullable?.length ?? 0);
  staticPrint(length);
  ((nullable == null) ? nullable = 'assigned' : null);
  staticPrint(nullable);
}

void testLate() {
  final LateTestValue t = LateTest_new(GC.allocateLocal(LateTestValue()));
  (t.vptr['init'] as void Function(dynamic))(t);
  staticPrint((t.vptr['get'] as String Function(dynamic))(t));
}

Promise<int> asyncInt() {
  final env = ClosureEnv_asyncInt_0();
  env._promise.setStartCallback(env.call);
  return env._promise;
}

Promise<String> asyncString() {
  final env = ClosureEnv_asyncString_1();
  env._promise.setStartCallback(env.call);
  return env._promise;
}

Promise<void> asyncVoid() {
  final env = ClosureEnv_asyncVoid_2();
  env._promise.setStartCallback(env.call);
  return env._promise;
}

void testAsync() {
  asyncInt().then(print);
  asyncString().then(print);
  asyncVoid();
}

Iterable<int> syncGen() sync* {
  yield 1;
  yield 2;
  yield 3;
}

Stream<int> asyncGen() async* {
  yield 1;
  yield 2;
  yield 3;
}

void testGenerators() {
  staticPrint(StaticList.of(syncGen().toList()));
  asyncGen().toList().then(print);
}

void testEnum() {
  staticPrint(Color.red.name);
  staticPrint(Color_get_value(Color.green));
}

String StringExtension_capitalize(final String this_) {
  if (this_.isEmpty)   return this_;
  return (this_[0].toUpperCase() + this_.substring(1));
}

TypeFunction0<String> StringExtension_get_capitalize(final String this_) {
  return ClosureEnv_StringExtension_get_capitalize_3_new(GC.allocateLocal(ClosureEnv_StringExtension_get_capitalize_3()), this_);
}

void testExtension() {
  staticPrint(StringExtension_capitalize('hello'));
}

(String, int) getRecord() {
  return ('hello', 42);
}

({int age, String name}) getNamedRecord() {
  return (() { final _let7 = 'Alice'; return (age: 30, name: _let7); })();
}

void testRecords() {
  final (String, int) r1 = getRecord();
  staticPrint('${r1.$1}, ${r1.$2}');
  final ({int age, String name}) r2 = getNamedRecord();
  staticPrint('${r2.name}, ${r2.age}');
}

void testPatternMatching() {
  final StaticList<int> obj = StaticList<int>.of([1, 2, 3]);
  do {
{
      final StaticList<int> _v8 = obj;
{
        if (((((_v8.length == 3) && (1 == _v8[0])) && (2 == _v8[1])) && (3 == _v8[2]))) {
{
            staticPrint('matched');
            break;
          }
        }
      }
{
{
{
            staticPrint('not matched');
          }
        }
      }
    }
  } while (false);
  final int a;
  final int b;
{
    final (int, int) _v9 = (1, 2);
    a = _v9.$1;
    b = _v9.$2;
  }
  staticPrint('${a}, ${b}');
}

void testSealed() {
  final StaticList<ShapeValue> shapes = StaticList<ShapeValue>.of([Circle_new(GC.allocateLocal(CircleValue()), 5.0), Square_new(GC.allocateLocal(SquareValue()), 4.0)]);
{
    StaticIterator<ShapeValue> sync_for_iterator = StaticIterator(shapes.iterator);
    for (; sync_for_iterator.moveNext(); ) {
      final ShapeValue shape = sync_for_iterator.current;
{
        staticPrint((shape.vptr['area'] as double Function(dynamic))(shape));
      }
    }
  }
}

void testOperators() {
  final VectorValue v1 = Vector_new(GC.allocateLocal(VectorValue()), 1.0, 2.0);
  final VectorValue v2 = Vector_new(GC.allocateLocal(VectorValue()), 3.0, 4.0);
  staticPrint((v1.vptr['operatorPlus'] as VectorValue Function(dynamic, VectorValue))(v1, v2));
  staticPrint((v1.vptr['operatorStar'] as VectorValue Function(dynamic, double))(v1, 2.0));
}

void testStatic() {
  Counter_increment();
  Counter_increment();
  staticPrint(Counter_value());
}

void testAbstract() {
  final AnimalValue a = Dog_new(GC.allocateLocal(DogValue()));
  (a.vptr['speak'] as void Function(dynamic))(a);
}

void testMixin() {
  final DuckValue d = Duck_new(GC.allocateLocal(DuckValue()));
  (d.vptr['fly'] as void Function(dynamic))(d);
  (d.vptr['swim'] as void Function(dynamic))(d);
  (d.vptr['quack'] as void Function(dynamic))(d);
}

T max<T extends Comparable<dynamic>>(T a, T b) {
  return ((a.compareTo(b) > 0) ? a : b);
}

void testGenericBounds() {
  staticPrint(max<Comparable<dynamic>>(3, 5));
  staticPrint(max<Comparable<dynamic>>('apple', 'banana'));
}

bool isEven(int n) {
  return ((n % 2) == 0);
}

void testTypedef() {
  TypeFunction1<bool, int> pred = ClosureEnv_testTypedef_4_new(GC.allocateLocal(ClosureEnv_testTypedef_4()));
  staticPrint(pred.closureCall(pred, 4));
}

void testAssert() {
  final int x = 5;
  assert((x > 0), 'x must be positive');
  staticPrint('assert passed');
}

void testLabels() {
  do {
    for (var i = 0; (i < 3); i = (i + 1)) {
      for (var j = 0; (j < 3); j = (j + 1)) {
        if (((i == 1) && (j == 1)))         break;
        staticPrint('${i}, ${j}');
      }
    }
  } while (false);
}

void main() {
  staticPrint('=== 1. Spread ===');
  testSpread();
  staticPrint('\n=== 2. Collection If/For ===');
  testCollectionIfFor();
  staticPrint('\n=== 3. Cascade ===');
  testCascade();
  staticPrint('\n=== 4. Null-aware ===');
  testNullAware();
  staticPrint('\n=== 5. Late ===');
  testLate();
  staticPrint('\n=== 6. Async ===');
  testAsync();
  staticPrint('\n=== 7. Generators ===');
  testGenerators();
  staticPrint('\n=== 8. Enum ===');
  testEnum();
  staticPrint('\n=== 9. Extension ===');
  testExtension();
  staticPrint('\n=== 10. Records ===');
  testRecords();
  staticPrint('\n=== 11. Pattern Matching ===');
  testPatternMatching();
  staticPrint('\n=== 12. Sealed Classes ===');
  testSealed();
  staticPrint('\n=== 13. Operators ===');
  testOperators();
  staticPrint('\n=== 14. Static ===');
  testStatic();
  staticPrint('\n=== 15. Abstract ===');
  testAbstract();
  staticPrint('\n=== 16. Mixin ===');
  testMixin();
  staticPrint('\n=== 17. Generic Bounds ===');
  testGenericBounds();
  staticPrint('\n=== 18. Typedef ===');
  testTypedef();
  staticPrint('\n=== 19. Assert ===');
  testAssert();
  staticPrint('\n=== 20. Labels ===');
  testLabels();
  staticPrint('\n=== All tests completed ===');
}

class ClosureEnv_asyncInt_0 {
  Promise<int> _promise;
  ClosureEnv_asyncInt_0() : _promise = Promise<int>();
  void call() => ClosureEnv_asyncInt_0_call(this);
}
void ClosureEnv_asyncInt_0_call(ClosureEnv_asyncInt_0 env) {
  smAwait(promiseDelayed<dynamic>(StaticDuration(milliseconds: 10)));
{
    env._promise.complete(42);
    return;
  }
  env._promise.complete(0);
  return;
}
class ClosureEnv_asyncString_1 {
  Promise<String> _promise;
  ClosureEnv_asyncString_1() : _promise = Promise<String>();
  void call() => ClosureEnv_asyncString_1_call(this);
}
void ClosureEnv_asyncString_1_call(ClosureEnv_asyncString_1 env) {
  smAwait(promiseDelayed<dynamic>(StaticDuration(milliseconds: 10)));
{
    env._promise.complete('hello');
    return;
  }
  env._promise.complete('');
  return;
}
class ClosureEnv_asyncVoid_2 {
  Promise<void> _promise;
  ClosureEnv_asyncVoid_2() : _promise = Promise<void>();
  void call() => ClosureEnv_asyncVoid_2_call(this);
}
void ClosureEnv_asyncVoid_2_call(ClosureEnv_asyncVoid_2 env) {
  smAwait(promiseDelayed<dynamic>(StaticDuration(milliseconds: 10)));
  staticPrint('done');
  env._promise.complete(null as dynamic);
  return;
}
class ClosureEnv_StringExtension_get_capitalize_3 extends TypeFunction0<String> {
  late String this_;
  ClosureEnv_StringExtension_get_capitalize_3();
  @override
  String call() => closureCall(this);
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
    if (this_ is AnyGC) (this_ as AnyGC).gcMark(flag);
  }
}
ClosureEnv_StringExtension_get_capitalize_3 ClosureEnv_StringExtension_get_capitalize_3_new(ClosureEnv_StringExtension_get_capitalize_3 env_, String this_) {
  env_.closureCall = ClosureEnv_StringExtension_get_capitalize_3_call;
  env_.this_ = this_;
  return env_;
}
String ClosureEnv_StringExtension_get_capitalize_3_call(dynamic env__) {
  final env = env__ as ClosureEnv_StringExtension_get_capitalize_3;

  return StringExtension_capitalize(env.this_);
}

class ClosureEnv_testTypedef_4 extends TypeFunction1<bool, int> {
  ClosureEnv_testTypedef_4();
  @override
  bool call(int a1) => closureCall(this, a1);
}
ClosureEnv_testTypedef_4 ClosureEnv_testTypedef_4_new(ClosureEnv_testTypedef_4 env_) {
  env_.closureCall = ClosureEnv_testTypedef_4_call;
  return env_;
}
bool ClosureEnv_testTypedef_4_call(dynamic env__, int a1) {
  return isEven(a1);
}
