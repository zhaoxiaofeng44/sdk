import 'package:dart2cpp/platform/dart/runtime_classes.dart';

typedef IntPredicate = TypeFunction1<bool, int>;

class PersonClassInfo extends ClassInfo {
  Function? greet;
}

class PersonValue extends AnyGC {
  late String name = '';
  late int age = 0;
  static PersonClassInfo? _classInfo;
  @override
  ClassInfo get classInfo => _classInfo ??= _initClassInfo();
  static PersonClassInfo _initClassInfo() {
    final ci = PersonClassInfo();
    ci.greet = Person_greet;
    return ci;
  }
}

PersonValue Person_new(AnyGC this__) {
  final this_ = this__ as PersonValue;
  return this_;
}

void Person_greet(AnyGC this__) {
  final this_ = this__ as PersonValue;
  staticPrint('Hello, ${this_.name}');
}


class LateTestClassInfo extends ClassInfo {
  Function? init;
  Function? get;
}

class LateTestValue extends AnyGC {
  late String value;
  static LateTestClassInfo? _classInfo;
  @override
  ClassInfo get classInfo => _classInfo ??= _initClassInfo();
  static LateTestClassInfo _initClassInfo() {
    final ci = LateTestClassInfo();
    ci.init = LateTest_init;
    ci.get = LateTest_get;
    return ci;
  }
}

LateTestValue LateTest_new(AnyGC this__) {
  final this_ = this__ as LateTestValue;
  return this_;
}

void LateTest_init(AnyGC this__) {
  final this_ = this__ as LateTestValue;
  this_.value = 'initialized';
}

String LateTest_get(AnyGC this__) {
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

class ShapeClassInfo extends ClassInfo {
  Function? area;
}

class ShapeValue extends AnyGC {
  static ShapeClassInfo? _classInfo;
  @override
  ClassInfo get classInfo => _classInfo ??= _initClassInfo();
  static ShapeClassInfo _initClassInfo() {
    final ci = ShapeClassInfo();
    ci.area = Shape_area;
    return ci;
  }
}

ShapeValue Shape_new(AnyGC this__) {
  final this_ = this__ as ShapeValue;
  return this_;
}

double Shape_area(dynamic this_) {
  throw UnimplementedError('Shape.area is abstract');
}


class CircleClassInfo extends ShapeClassInfo {
}

class CircleValue extends ShapeValue {
  late double radius;
  static CircleClassInfo? _classInfo;
  @override
  ClassInfo get classInfo => _classInfo ??= _initClassInfo();
  static CircleClassInfo _initClassInfo() {
    final ci = CircleClassInfo();
    ci.area = Circle_area;
    return ci;
  }
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
  }
}

CircleValue Circle_new(AnyGC this__, double radius) {
  final this_ = this__ as CircleValue;
  Shape_new(this_);
  this_.radius = radius;
  return this_;
}

double Circle_area(AnyGC this__) {
  final this_ = this__ as CircleValue;
  return ((3.14 * this_.radius) * this_.radius);
}


class SquareClassInfo extends ShapeClassInfo {
}

class SquareValue extends ShapeValue {
  late double side;
  static SquareClassInfo? _classInfo;
  @override
  ClassInfo get classInfo => _classInfo ??= _initClassInfo();
  static SquareClassInfo _initClassInfo() {
    final ci = SquareClassInfo();
    ci.area = Square_area;
    return ci;
  }
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
  }
}

SquareValue Square_new(AnyGC this__, double side) {
  final this_ = this__ as SquareValue;
  Shape_new(this_);
  this_.side = side;
  return this_;
}

double Square_area(AnyGC this__) {
  final this_ = this__ as SquareValue;
  return (this_.side * this_.side);
}


class VectorClassInfo extends ClassInfo {
  Function? operatorPlus;
  Function? operatorStar;
}

class VectorValue extends AnyGC {
  late double x;
  late double y;
  static VectorClassInfo? _classInfo;
  @override
  ClassInfo get classInfo => _classInfo ??= _initClassInfo();
  static VectorClassInfo _initClassInfo() {
    final ci = VectorClassInfo();
    ci.operatorPlus = Vector_operatorPlus;
    ci.operatorStar = Vector_operatorStar;
    ci.toString_ = Vector_toString;
    return ci;
  }
}

VectorValue Vector_new(AnyGC this__, double x, double y) {
  final this_ = this__ as VectorValue;
  this_.x = x;
  this_.y = y;
  return this_;
}

VectorValue Vector_operatorPlus(AnyGC this__, VectorValue other) {
  final this_ = this__ as VectorValue;
  return Vector_new(GC.allocateLocal(VectorValue()), (this_.x + other.x), (this_.y + other.y));
}

VectorValue Vector_operatorStar(AnyGC this__, double scalar) {
  final this_ = this__ as VectorValue;
  return Vector_new(GC.allocateLocal(VectorValue()), (this_.x * scalar), (this_.y * scalar));
}

String Vector_toString(AnyGC this__) {
  final this_ = this__ as VectorValue;
  return '(${this_.x}, ${this_.y})';
}


class CounterClassInfo extends ClassInfo {
}

class CounterValue extends AnyGC {
  static CounterClassInfo? _classInfo;
  @override
  ClassInfo get classInfo => _classInfo ??= _initClassInfo();
  static CounterClassInfo _initClassInfo() {
    final ci = CounterClassInfo();
    return ci;
  }
}

int Counter_count = 0;
CounterValue Counter_new(AnyGC this__) {
  final this_ = this__ as CounterValue;
  return this_;
}

void Counter_increment() {
  Counter_count = (Counter_count + 1);
}

int Counter_value() {
  return Counter_count;
}


class AnimalClassInfo extends ClassInfo {
  Function? speak;
}

class AnimalValue extends AnyGC {
  static AnimalClassInfo? _classInfo;
  @override
  ClassInfo get classInfo => _classInfo ??= _initClassInfo();
  static AnimalClassInfo _initClassInfo() {
    final ci = AnimalClassInfo();
    ci.speak = Animal_speak;
    return ci;
  }
}

AnimalValue Animal_new(AnyGC this__) {
  final this_ = this__ as AnimalValue;
  return this_;
}

void Animal_speak(dynamic this_) {
  throw UnimplementedError('Animal.speak is abstract');
}


class DogClassInfo extends AnimalClassInfo {
}

class DogValue extends AnyGC implements AnimalValue {
  static DogClassInfo? _classInfo;
  @override
  ClassInfo get classInfo => _classInfo ??= _initClassInfo();
  static DogClassInfo _initClassInfo() {
    final ci = DogClassInfo();
    ci.speak = Dog_speak;
    return ci;
  }
}

DogValue Dog_new(AnyGC this__) {
  final this_ = this__ as DogValue;
  return this_;
}

void Dog_speak(AnyGC this__) {
  final this_ = this__ as DogValue;
  staticPrint('Woof!');
}


// mixin Flyable → static functions for delegation
void Flyable_fly(AnyGC this__) {
  final dynamic this_ = this__;
  staticPrint('Flying!');
}


// mixin Swimmable → static functions for delegation
void Swimmable_swim(AnyGC this__) {
  final dynamic this_ = this__;
  staticPrint('Swimming!');
}


class DuckClassInfo extends Duck_Object_Flyable_SwimmableClassInfo {
  Function? quack;
}

class DuckValue extends Duck_Object_Flyable_SwimmableValue {
  static DuckClassInfo? _classInfo;
  @override
  ClassInfo get classInfo => _classInfo ??= _initClassInfo();
  static DuckClassInfo _initClassInfo() {
    final ci = DuckClassInfo();
    ci.fly = Duck_fly;
    ci.swim = Duck_swim;
    ci.quack = Duck_quack;
    return ci;
  }
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
  }
}

DuckValue Duck_new(AnyGC this__) {
  final this_ = this__ as DuckValue;
  return this_;
}

void Duck_quack(AnyGC this__) {
  final this_ = this__ as DuckValue;
  staticPrint('Quack!');
}

void Duck_fly(AnyGC this__) {
  final this_ = this__ as DuckValue;
  Flyable_fly(this_);
}

void Duck_swim(AnyGC this__) {
  final this_ = this__ as DuckValue;
  Swimmable_swim(this_);
}


class Duck_Object_FlyableClassInfo extends ClassInfo {
  Function? fly;
}

class Duck_Object_FlyableValue extends AnyGC {
  static Duck_Object_FlyableClassInfo? _classInfo;
  @override
  ClassInfo get classInfo => _classInfo ??= _initClassInfo();
  static Duck_Object_FlyableClassInfo _initClassInfo() {
    final ci = Duck_Object_FlyableClassInfo();
    return ci;
  }
}


class Duck_Object_Flyable_SwimmableClassInfo extends Duck_Object_FlyableClassInfo {
  Function? swim;
}

class Duck_Object_Flyable_SwimmableValue extends Duck_Object_FlyableValue {
  static Duck_Object_Flyable_SwimmableClassInfo? _classInfo;
  @override
  ClassInfo get classInfo => _classInfo ??= _initClassInfo();
  static Duck_Object_Flyable_SwimmableClassInfo _initClassInfo() {
    final ci = Duck_Object_Flyable_SwimmableClassInfo();
    return ci;
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
  final PersonValue p = (() { final _let3 = Person_new(GC.allocateLocal(PersonValue())); _let3.name = 'Alice'; _let3.age = 30; (_let3.classInfo as PersonClassInfo).greet!(_let3); return _let3; })();
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
  (t.classInfo as LateTestClassInfo).init!(t);
  staticPrint((t.classInfo as LateTestClassInfo).get!(t));
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
  _L8: do {
{
      final StaticList<int> _v9 = obj;
      const int _v10 = 3;
      const int _v11 = 1;
      const int _v12 = 2;
{
        if (((((_v9.length == 3) && (1 == _v9[0])) && (2 == _v9[1])) && (3 == _v9[2]))) {
{
            staticPrint('matched');
            break _L8;
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
    final (int, int) _v13 = (1, 2);
    a = _v13.$1;
    b = _v13.$2;
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
        staticPrint((shape.classInfo as ShapeClassInfo).area!(shape));
      }
    }
  }
}

void testOperators() {
  final VectorValue v1 = Vector_new(GC.allocateLocal(VectorValue()), 1.0, 2.0);
  final VectorValue v2 = Vector_new(GC.allocateLocal(VectorValue()), 3.0, 4.0);
  staticPrint((v1.classInfo as VectorClassInfo).operatorPlus!(v1, v2));
  staticPrint((v1.classInfo as VectorClassInfo).operatorStar!(v1, 2.0));
}

void testStatic() {
  Counter_increment();
  Counter_increment();
  staticPrint(Counter_value());
}

void testAbstract() {
  final AnimalValue a = Dog_new(GC.allocateLocal(DogValue()));
  (a.classInfo as AnimalClassInfo).speak!(a);
}

void testMixin() {
  final DuckValue d = Duck_new(GC.allocateLocal(DuckValue()));
  (d.classInfo as DuckClassInfo).fly!(d);
  (d.classInfo as DuckClassInfo).swim!(d);
  (d.classInfo as DuckClassInfo).quack!(d);
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
  staticPrint(pred.call(4));
}

void testAssert() {
  final int x = 5;
  assert((x > 0), 'x must be positive');
  staticPrint('assert passed');
}

void testLabels() {
  _L14:
  for (var i = 0; (i < 3); i = (i + 1)) {
    for (var j = 0; (j < 3); j = (j + 1)) {
      if (((i == 1) && (j == 1)))       break _L14;
      staticPrint('${i}, ${j}');
    }
  }
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
  drainScheduler();
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
  env._promise.complete(0);
  return;
}
class ClosureEnv_StringExtension_get_capitalize_3 extends TypeFunction0<String> {
  late String this_;
  ClosureEnv_StringExtension_get_capitalize_3();
  @override
  String call() => fnPtr(this);
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
    if (this_ is AnyGC) (this_ as AnyGC).gcMark(flag);
  }
}
ClosureEnv_StringExtension_get_capitalize_3 ClosureEnv_StringExtension_get_capitalize_3_new(ClosureEnv_StringExtension_get_capitalize_3 env_, String this_) {
  env_.fnPtr = ClosureEnv_StringExtension_get_capitalize_3_call;
  env_.this_ = this_;
  return env_;
}
String ClosureEnv_StringExtension_get_capitalize_3_call(AnyGC env__) {
  final env = env__ as ClosureEnv_StringExtension_get_capitalize_3;

  return StringExtension_capitalize(env.this_);
}

class ClosureEnv_testTypedef_4 extends TypeFunction1<bool, int> {
  ClosureEnv_testTypedef_4();
  @override
  bool call(int a1) => fnPtr(this, a1);
}
ClosureEnv_testTypedef_4 ClosureEnv_testTypedef_4_new(ClosureEnv_testTypedef_4 env_) {
  env_.fnPtr = ClosureEnv_testTypedef_4_call;
  return env_;
}
bool ClosureEnv_testTypedef_4_call(dynamic env__, int a1) {
  return isEven(a1);
}
