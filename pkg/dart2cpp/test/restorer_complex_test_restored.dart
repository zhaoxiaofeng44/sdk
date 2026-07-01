import 'package:dart2cpp/platform/dart/runtime_classes.dart';

class ShapeValue extends VPtr {
  static Map<String, dynamic>? vptrMap;
  @override
  Map<String, dynamic> get vptr => getVptrMap();
  static Map<String, dynamic> getVptrMap() {
    if (vptrMap == null) {
      vptrMap = <String, dynamic>{'toString': null, 'operatorEq': null, 'get_hashCode': null};
      vptrMap!['get_name'] = Shape_get_name;
      vptrMap!['area'] = Shape_area;
      vptrMap!['perimeter'] = Shape_perimeter;
      vptrMap!['toString'] = Shape_toString;
    }
    return vptrMap!;
  }
}

ShapeValue Shape_new(dynamic this__) {
  final this_ = this__ as ShapeValue;
  return this_;
}

String Shape_get_name(dynamic this_) {
  throw UnimplementedError('Shape.name is abstract');
}

double Shape_area(dynamic this_) {
  throw UnimplementedError('Shape.area is abstract');
}

double Shape_perimeter(dynamic this_) {
  throw UnimplementedError('Shape.perimeter is abstract');
}

String Shape_toString(dynamic this__) {
  final this_ = this__ as ShapeValue;
  return '${(this_.vptr['get_name'] as String Function(dynamic))(this_)}(area=${(this_.vptr['area'] as double Function(dynamic))(this_).toStringAsFixed(2)})';
}


class PairValue<A, B> extends VPtr {
  late A first;
  late B second;
  static final Map<Type, Map<String, dynamic>> vptrCache = {};
  Map<String, dynamic>? instanceVptr;
  @override
  Map<String, dynamic> get vptr {
    if (instanceVptr == null) {
      final _typeKey = PairValue<A, B>;
      instanceVptr = vptrCache[_typeKey];
      if (instanceVptr == null) {
        instanceVptr = <String, dynamic>{'toString': null, 'operatorEq': null, 'get_hashCode': null};
        initVptr(instanceVptr!);
        vptrCache[_typeKey] = instanceVptr!;
      }
    }
    return instanceVptr!;
  }
  void initVptr(Map<String, dynamic> target) {
    target['swap'] = Pair_swap<A, B>;
    target['toString'] = Pair_toString<A, B>;
  }
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
    if (first is AnyGC) (first as AnyGC).gcMark(flag);
    if (second is AnyGC) (second as AnyGC).gcMark(flag);
  }
}

PairValue<A, B> Pair_new<A, B>(dynamic this__, A first, B second) {
  final this_ = this__ as PairValue<A, B>;
  this_.first = first;
  this_.second = second;
  return this_;
}

PairValue<B, A> Pair_swap<A, B>(dynamic this__) {
  final this_ = this__ as PairValue<A, B>;
  return Pair_new<B, A>(GC.allocateLocal(PairValue<B, A>()), this_.second, this_.first);
}

String Pair_toString<A, B>(dynamic this__) {
  final this_ = this__ as PairValue<A, B>;
  return '(${this_.first}, ${this_.second})';
}


class CircleValue extends ShapeValue {
  late double _radius;
  static Map<String, dynamic>? vptrMap;
  @override
  Map<String, dynamic> get vptr => getVptrMap();
  static Map<String, dynamic> getVptrMap() {
    if (vptrMap == null) {
      vptrMap = Map<String, dynamic>.from(ShapeValue.getVptrMap());
      vptrMap!['get_name'] = Circle_get_name;
      vptrMap!['area'] = Circle_area;
      vptrMap!['perimeter'] = Circle_perimeter;
      vptrMap!['toString'] = Circle_toString;
      vptrMap!['get_radius'] = Circle_get_radius;
      vptrMap!['set_radius'] = Circle_set_radius;
    }
    return vptrMap!;
  }
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
  }
}

CircleValue Circle_new(dynamic this__, double _radius) {
  final this_ = this__ as CircleValue;
  Shape_new(this_);
  this_._radius = _radius;
  return this_;
}

CircleValue Circle_new_unit(dynamic this__) {
  final this_ = this__ as CircleValue;
  Shape_new(this_);
  this_._radius = 1.0;
  return this_;
}

double Circle_get_radius(dynamic this__) {
  final this_ = this__ as CircleValue;
  return this_._radius;
}

void Circle_set_radius(dynamic this__, double value) {
  final this_ = this__ as CircleValue;
  if ((value < 0))   throw DartArgumentError('Radius must be non-negative');
  this_._radius = value;
}

String Circle_get_name(dynamic this__) {
  final this_ = this__ as CircleValue;
  return 'Circle';
}

double Circle_area(dynamic this__) {
  final this_ = this__ as CircleValue;
  return ((3.14159265 * this_._radius) * this_._radius);
}

double Circle_perimeter(dynamic this__) {
  final this_ = this__ as CircleValue;
  return ((2 * 3.14159265) * this_._radius);
}

String Circle_toString(dynamic this__) {
  final this_ = this__ as CircleValue;
  return Shape_toString(this_);
}


class RectangleValue extends ShapeValue {
  late double width;
  late double height;
  static Map<String, dynamic>? vptrMap;
  @override
  Map<String, dynamic> get vptr => getVptrMap();
  static Map<String, dynamic> getVptrMap() {
    if (vptrMap == null) {
      vptrMap = Map<String, dynamic>.from(ShapeValue.getVptrMap());
      vptrMap!['get_name'] = Rectangle_get_name;
      vptrMap!['area'] = Rectangle_area;
      vptrMap!['perimeter'] = Rectangle_perimeter;
      vptrMap!['toString'] = Rectangle_toString;
    }
    return vptrMap!;
  }
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
  }
}

RectangleValue Rectangle_new(dynamic this__, double width, double height) {
  final this_ = this__ as RectangleValue;
  Shape_new(this_);
  this_.width = width;
  this_.height = height;
  return this_;
}

String Rectangle_get_name(dynamic this__) {
  final this_ = this__ as RectangleValue;
  return 'Rectangle';
}

double Rectangle_area(dynamic this__) {
  final this_ = this__ as RectangleValue;
  return (this_.width * this_.height);
}

double Rectangle_perimeter(dynamic this__) {
  final this_ = this__ as RectangleValue;
  return (2 * (this_.width + this_.height));
}

String Rectangle_toString(dynamic this__) {
  final this_ = this__ as RectangleValue;
  return Shape_toString(this_);
}


enum Direction {
  north,
  south,
  east,
  west;
}

String StringExtensions_capitalize(final String this_) {
  if (this_.isEmpty)   return this_;
  return '${this_[0].toUpperCase()}${this_.substring(1)}';
}

TypeFunction0<String> StringExtensions_get_capitalize(final String this_) {
  return ClosureEnv_StringExtensions_get_capitalize_0_new(GC.allocateLocal(ClosureEnv_StringExtensions_get_capitalize_0()), this_);
}

bool StringExtensions_get_isPalindrome(final String this_) {
  final String reversed = this_.split('').reversed.join();
  return (this_ == reversed);
}

StaticList<T> ListExtensions_filterWhere<T>(final StaticList<T> this_, TypeFunction1<bool, T> predicate) {
  return StaticList.of(this_.where(predicate).toList());
}

TypeFunction1<StaticList<T>, TypeFunction1<bool, T>> ListExtensions_get_filterWhere<T>(final StaticList<T> this_) {
  return ClosureEnv_ListExtensions_get_filterWhere_1_new<T>(GC.allocateLocal(ClosureEnv_ListExtensions_get_filterWhere_1<T>()), this_);
}

T identity<T>(T value) {
  return value;
}

StaticList<T> repeat<T>(T item_raw, int count) {
  ObjectBox<T> item = ObjectBox<T>(item_raw);
  return StaticList<T>.generate(count, ClosureEnv_repeat_2_new<T>(GC.allocateLocal(ClosureEnv_repeat_2<T>()), item));
}

dynamic makeAdder(int base_raw) {
  IntBox base = IntBox(base_raw);
  return ClosureEnv_makeAdder_3_new(GC.allocateLocal(ClosureEnv_makeAdder_3()), base);
}

StaticList<int> mapList(StaticList<int> items, TypeFunction1<int, int> transform) {
  return StaticList.of(items.map(transform).toList());
}

Promise<String> fetchData(String url) {
  final env = ClosureEnv_fetchData_4(url);
  env._promise.setStartCallback(env.call);
  return env._promise;
}

Promise<StaticList<String>> fetchAll(StaticList<String> urls) {
  final env = ClosureEnv_fetchAll_5(urls);
  env._promise.setStartCallback(env.call);
  return env._promise;
}

String? findFirst(StaticList<String> items, TypeFunction1<bool, String> predicate) {
  for (final item in items) {
    if (predicate.closureCall(predicate, item))     return item;
  }
  return null;
}

int safeLength(String? text) {
  return (text?.length ?? 0);
}

void main() {
  staticPrint('=== 复杂语法节点还原测试 ===\n');
  staticPrint('--- 1. 泛型类 Pair ---');
  final PairValue<String, int> pair = Pair_new<String, int>(GC.allocateLocal(PairValue<String, int>()), 'hello', 42);
  final PairValue<int, String> swapped = (pair.vptr['swap'] as PairValue<int, String> Function(dynamic))(pair);
  staticPrint('pair: ${pair}');
  staticPrint('swapped: ${swapped}');
  assert((pair.first == 'hello'));
  assert((swapped.first == 42));
  staticPrint('\n--- 2. 继承 + 多态 ---');
  final StaticList<ShapeValue> shapes = StaticList<ShapeValue>.of([Circle_new(GC.allocateLocal(CircleValue()), 5.0), Rectangle_new(GC.allocateLocal(RectangleValue()), 3.0, 4.0), Circle_new_unit(GC.allocateLocal(CircleValue()))]);
  for (final shape in shapes) {
    staticPrint('  ${shape}, perimeter=${(shape.vptr['perimeter'] as double Function(dynamic))(shape).toStringAsFixed(2)}');
  }
  staticPrint('\n--- 3. getter/setter + 异常 ---');
  final CircleValue circle = Circle_new(GC.allocateLocal(CircleValue()), 3.0);
  (circle.vptr['set_radius'] as void Function(dynamic, double))(circle, 5.0);
  staticPrint('radius after set: ${(circle.vptr['get_radius'] as double Function(dynamic))(circle)}');
  try {
    (circle.vptr['set_radius'] as void Function(dynamic, double))(circle, (-1.0));
    staticPrint('ERROR: should have thrown');
  }
 on ArgumentError catch (e) {
    staticPrint('Caught expected error: ${e}');
  }
  staticPrint('\n--- 4. 枚举 + switch ---');
  final StaticList<Direction> directions = StaticList<Direction>.of([Direction.north, Direction.east, Direction.south]);
  for (final dir in directions) {
    final String label = (() {     late String _v2;
    _L3: do {
      switch (dir) {
        case Direction.north:
{
            _v2 = 'N';
            break _L3;
          }
        case Direction.south:
{
            _v2 = 'S';
            break _L3;
          }
        case Direction.east:
{
            _v2 = 'E';
            break _L3;
          }
        case Direction.west:
{
            _v2 = 'W';
            break _L3;
          }
      }
    } while (false);
 return _v2; })();
    staticPrint('  ${dir} -> ${label}');
  }
  staticPrint('\n--- 5. 扩展方法 ---');
  final String word = 'hello';
  staticPrint('capitalize: ${StringExtensions_capitalize(word)}');
  staticPrint('isPalindrome("racecar"): ${StringExtensions_get_isPalindrome('racecar')}');
  staticPrint('isPalindrome("hello"): ${StringExtensions_get_isPalindrome('hello')}');
  final StaticList<int> numbers = StaticList<int>.of([1, 2, 3, 4, 5, 6]);
  final StaticList<int> evens = StaticList<int>.of(ListExtensions_filterWhere(numbers, ClosureEnv_main_6_new(GC.allocateLocal(ClosureEnv_main_6()))));
  staticPrint('evens: ${evens}');
  staticPrint('\n--- 6. 泛型函数 ---');
  staticPrint('identity<int>(99): ${identity<int>(99)}');
  staticPrint('repeat("x", 3): ${repeat<String>('x', 3)}');
  staticPrint('\n--- 7. 高阶函数 + 闭包 ---');
  final dynamic add10 = makeAdder(10);
  staticPrint('add10(5): ${add10.closureCall(add10, 5)}');
  final StaticList<int> doubled = StaticList<int>.of(mapList(StaticList<int>.of([1, 2, 3, 4]), ClosureEnv_main_7_new(GC.allocateLocal(ClosureEnv_main_7()))));
  staticPrint('doubled: ${doubled}');
  IntBox counter = IntBox(0);
  final TypeFunction0<int> increment = ClosureEnv_main_8_new(GC.allocateLocal(ClosureEnv_main_8()), counter);
  staticPrint('counter: ${increment.closureCall(increment)}, ${increment.closureCall(increment)}, ${increment.closureCall(increment)}');
  staticPrint('\n--- 8. 可空类型 ---');
  final StaticList<String> items = StaticList<String>.of(['apple', 'banana', 'cherry']);
  final String? found = findFirst(items, ClosureEnv_main_9_new(GC.allocateLocal(ClosureEnv_main_9())));
  staticPrint('found: ${found}');
  final String? notFound = findFirst(items, ClosureEnv_main_10_new(GC.allocateLocal(ClosureEnv_main_10())));
  staticPrint('notFound: ${notFound}');
  staticPrint('safeLength(null): ${safeLength(null)}');
  staticPrint('safeLength("dart"): ${safeLength('dart')}');
  staticPrint('\n--- 9. 集合操作 ---');
  final StaticMap<String, int> map = StaticMap<String, int>.of({'a': 1, 'b': 2, 'c': 3});
  final StaticMap<String, int> filtered = StaticMap<String, int>.fromEntries(map.entries.where(ClosureEnv_main_11_new(GC.allocateLocal(ClosureEnv_main_11()))));
  staticPrint('filtered map: ${filtered}');
  final StaticSet<int> set1 = StaticSet<int>.of([1, 2, 3, 4]);
  final StaticSet<int> set2 = StaticSet<int>.of([3, 4, 5, 6]);
  final StaticSet<int> intersection = StaticSet<int>.of(set1.intersection(set2));
  staticPrint('intersection: ${intersection}');
  staticPrint('\n--- 10. 字符串插值 ---');
  final String name = 'Dart';
  final int version = 3;
  final String greeting = 'Hello, ${name} ${version}!';
  final String multiExpr = 'Sum: ${((1 + 2) + 3)}, Upper: ${name.toUpperCase()}';
  staticPrint(greeting);
  staticPrint(multiExpr);
  staticPrint('\n--- 11. 条件表达式 + 类型检查 ---');
  final dynamic value = 42;
  final String typeLabel = ((value is int) ? 'integer' : ((value is String) ? 'string' : 'other'));
  staticPrint('typeLabel: ${typeLabel}');
  staticPrint('\n--- 12. 循环语句 ---');
  int sum = 0;
  for (var i = 1; (i <= 5); i = (i + 1)) {
    sum = (sum + i);
  }
  staticPrint('sum 1..5: ${sum}');
  int product = 1;
  int n = 5;
  while ((n > 0)) {
    product = (product * n);
    n = (n - 1);
  }
  staticPrint('5! = ${product}');
  int doCount = 0;
  do {
    doCount = (doCount + 1);
  }
 while ((doCount < 3));
  staticPrint('doCount: ${doCount}');
  staticPrint('\n--- 13. try/catch/finally ---');
  String result = '';
  try {
    result = 'try';
    throw DartStateError('test error');
  }
 on StateError catch (e) {
    result = (result + '+catch(${e.message})');
  }
 finally {
    result = (result + '+finally');
  }
  staticPrint('result: ${result}');
  staticPrint('\n--- 14. 集合字面量 ---');
  final StaticList<int> constList = StaticList<int>.of(const [1, 2, 3]);
  final StaticMap<String, String> constMap = StaticMap<String, String>.of(const {'key': 'value'});
  final StaticSet<int> constSet = StaticSet<int>.of(const {10, 20, 30});
  staticPrint('constList: ${const [1, 2, 3]}');
  staticPrint('constMap: ${const {'key': 'value'}}');
  staticPrint('constSet: ${const {10, 20, 30}}');
  staticPrint('\n=== 所有测试通过 ✅ ===');
  drainScheduler();
}

class ClosureEnv_StringExtensions_get_capitalize_0 extends TypeFunction0<String> {
  late String this_;
  ClosureEnv_StringExtensions_get_capitalize_0();
  @override
  String call() => closureCall(this);
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
    if (this_ is AnyGC) (this_ as AnyGC).gcMark(flag);
  }
}
ClosureEnv_StringExtensions_get_capitalize_0 ClosureEnv_StringExtensions_get_capitalize_0_new(ClosureEnv_StringExtensions_get_capitalize_0 env_, String this_) {
  env_.closureCall = ClosureEnv_StringExtensions_get_capitalize_0_call;
  env_.this_ = this_;
  return env_;
}
String ClosureEnv_StringExtensions_get_capitalize_0_call(dynamic env__) {
  final env = env__ as ClosureEnv_StringExtensions_get_capitalize_0;

  return StringExtensions_capitalize(env.this_);
}

class ClosureEnv_ListExtensions_get_filterWhere_1<T> extends TypeFunction1<StaticList<T>, TypeFunction1<bool, T>> {
  late StaticList<T> this_;
  ClosureEnv_ListExtensions_get_filterWhere_1();
  @override
  StaticList<T> call(TypeFunction1<bool, T> predicate) => closureCall(this, predicate);
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
    if (this_ is AnyGC) (this_ as AnyGC).gcMark(flag);
  }
}
ClosureEnv_ListExtensions_get_filterWhere_1<T> ClosureEnv_ListExtensions_get_filterWhere_1_new<T>(ClosureEnv_ListExtensions_get_filterWhere_1<T> env_, StaticList<T> this_) {
  env_.closureCall = ClosureEnv_ListExtensions_get_filterWhere_1_call<T>;
  env_.this_ = this_;
  return env_;
}
StaticList<T> ClosureEnv_ListExtensions_get_filterWhere_1_call<T>(dynamic env__, TypeFunction1<bool, T> predicate) {
  final env = env__ as ClosureEnv_ListExtensions_get_filterWhere_1<T>;

  return ListExtensions_filterWhere(env.this_, predicate);
}

class ClosureEnv_repeat_2<T> extends TypeFunction1<T, int> {
  late ObjectBox<T> item;
  ClosureEnv_repeat_2();
  @override
  T call(int _) => closureCall(this, _);
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
    if (item is AnyGC) (item as AnyGC).gcMark(flag);
  }
}
ClosureEnv_repeat_2<T> ClosureEnv_repeat_2_new<T>(ClosureEnv_repeat_2<T> env_, ObjectBox<T> item) {
  env_.closureCall = ClosureEnv_repeat_2_call<T>;
  env_.item = item;
  return env_;
}
T ClosureEnv_repeat_2_call<T>(dynamic env__, int _) {
  final env = env__ as ClosureEnv_repeat_2<T>;

  return env.item.value;
}

class ClosureEnv_makeAdder_3 extends TypeFunction1<int, int> {
  late IntBox base;
  ClosureEnv_makeAdder_3();
  @override
  int call(int x) => closureCall(this, x);
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
    if (base is AnyGC) (base as AnyGC).gcMark(flag);
  }
}
ClosureEnv_makeAdder_3 ClosureEnv_makeAdder_3_new(ClosureEnv_makeAdder_3 env_, IntBox base) {
  env_.closureCall = ClosureEnv_makeAdder_3_call;
  env_.base = base;
  return env_;
}
int ClosureEnv_makeAdder_3_call(dynamic env__, int x) {
  final env = env__ as ClosureEnv_makeAdder_3;

  return (env.base.value + x);
}

class ClosureEnv_fetchData_4 {
  StringBox url;
  Promise<String> _promise;
  ClosureEnv_fetchData_4(String url) : _promise = Promise<String>(), url = StringBox(url);
  void call() => ClosureEnv_fetchData_4_call(this);
}
void ClosureEnv_fetchData_4_call(ClosureEnv_fetchData_4 env) {
  smAwait(promiseDelayed<dynamic>(StaticDuration(milliseconds: 10)));
{
    env._promise.complete('data from ${env.url.value}');
    return;
  }
  env._promise.complete('');
  return;
}
class ClosureEnv_fetchAll_5 {
  StaticList<String> urls;
  Promise<StaticList<String>> _promise;
  ClosureEnv_fetchAll_5(this.urls) : _promise = Promise<StaticList<String>>();
  void call() => ClosureEnv_fetchAll_5_call(this);
}
void ClosureEnv_fetchAll_5_call(ClosureEnv_fetchAll_5 env) {
  final StaticList<String> results = StaticList<String>.of([]);
  for (final url in env.urls) {
    final String data = smAwait(fetchData(url));
    results.add(data);
  }
{
    env._promise.complete(results);
    return;
  }
  env._promise.complete(null as dynamic);
  return;
}
class ClosureEnv_main_6 extends TypeFunction1<bool, int> {
  ClosureEnv_main_6();
  @override
  bool call(int n) => closureCall(this, n);
}
ClosureEnv_main_6 ClosureEnv_main_6_new(ClosureEnv_main_6 env_) {
  env_.closureCall = ClosureEnv_main_6_call;
  return env_;
}
bool ClosureEnv_main_6_call(dynamic env__, int n) {
  final env = env__ as ClosureEnv_main_6;

  return ((n % 2) == 0);
}

class ClosureEnv_main_7 extends TypeFunction1<int, int> {
  ClosureEnv_main_7();
  @override
  int call(int x) => closureCall(this, x);
}
ClosureEnv_main_7 ClosureEnv_main_7_new(ClosureEnv_main_7 env_) {
  env_.closureCall = ClosureEnv_main_7_call;
  return env_;
}
int ClosureEnv_main_7_call(dynamic env__, int x) {
  final env = env__ as ClosureEnv_main_7;

  return (x * 2);
}

class ClosureEnv_main_8 extends TypeFunction0<int> {
  late IntBox counter;
  ClosureEnv_main_8();
  @override
  int call() => closureCall(this);
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
    if (counter is AnyGC) (counter as AnyGC).gcMark(flag);
  }
}
ClosureEnv_main_8 ClosureEnv_main_8_new(ClosureEnv_main_8 env_, IntBox counter) {
  env_.closureCall = ClosureEnv_main_8_call;
  env_.counter = counter;
  return env_;
}
int ClosureEnv_main_8_call(dynamic env__) {
  final env = env__ as ClosureEnv_main_8;

    env.counter.value = (env.counter.value + 1);
    return env.counter.value;
  }

class ClosureEnv_main_9 extends TypeFunction1<bool, String> {
  ClosureEnv_main_9();
  @override
  bool call(String s) => closureCall(this, s);
}
ClosureEnv_main_9 ClosureEnv_main_9_new(ClosureEnv_main_9 env_) {
  env_.closureCall = ClosureEnv_main_9_call;
  return env_;
}
bool ClosureEnv_main_9_call(dynamic env__, String s) {
  final env = env__ as ClosureEnv_main_9;

  return s.startsWith('b');
}

class ClosureEnv_main_10 extends TypeFunction1<bool, String> {
  ClosureEnv_main_10();
  @override
  bool call(String s) => closureCall(this, s);
}
ClosureEnv_main_10 ClosureEnv_main_10_new(ClosureEnv_main_10 env_) {
  env_.closureCall = ClosureEnv_main_10_call;
  return env_;
}
bool ClosureEnv_main_10_call(dynamic env__, String s) {
  final env = env__ as ClosureEnv_main_10;

  return s.startsWith('z');
}

class ClosureEnv_main_11 extends TypeFunction1<bool, StaticMapEntry<String, int>> {
  ClosureEnv_main_11();
  @override
  bool call(StaticMapEntry<String, int> e) => closureCall(this, e);
}
ClosureEnv_main_11 ClosureEnv_main_11_new(ClosureEnv_main_11 env_) {
  env_.closureCall = ClosureEnv_main_11_call;
  return env_;
}
bool ClosureEnv_main_11_call(dynamic env__, StaticMapEntry<String, int> e) {
  final env = env__ as ClosureEnv_main_11;

  return (e.value > 1);
}

