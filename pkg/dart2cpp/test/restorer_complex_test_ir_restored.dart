import 'package:dart2cpp/restorer/runtime_classes.dart';

class ShapeValue extends VPtr {

  ShapeValue() {
    vptr['get_name'] = Shape_get_name;
    vptr['area'] = Shape_area;
    vptr['perimeter'] = Shape_perimeter;
    vptr['toString'] = Shape_toString;
  }
}

ShapeValue Shape_new(dynamic this__) {
  final this_ = this__ as ShapeValue;
  return this_;
}

String Shape_get_name(dynamic this__) {
  throw UnimplementedError('Shape_get_name is abstract');
}

double Shape_area(dynamic this__) {
  throw UnimplementedError('Shape_area is abstract');
}

double Shape_perimeter(dynamic this__) {
  throw UnimplementedError('Shape_perimeter is abstract');
}

String Shape_toString(dynamic this__) {
  final this_ = this__ as ShapeValue;
  return '${(this_.vptr['get_name'] as Function)(this_)}(area=${dart_str_toStringAsFixed((this_.vptr['area'] as Function)(this_), 2)})';
}

class PairValue<A extends dynamic, B extends dynamic> extends VPtr {
  late A first;
  late B second;

  PairValue() {
    vptr['swap'] = Pair_swap<A, B>;
    vptr['toString'] = Pair_toString<A, B>;
  }

  @override
  void gcMark(int flag) {
    super.gcMark(flag);
  }
}

PairValue<A, B> Pair_new<A extends dynamic, B extends dynamic>(dynamic this__, A first, B second) {
  final this_ = this__ as PairValue<A, B>;
  this_.first = first;
  this_.second = second;
  return this_;
}

PairValue<B, A> Pair_swap<A extends dynamic, B extends dynamic>(dynamic this__) {
  final this_ = this__ as PairValue<A, B>;
  return Pair_new<B, A>(PairValue<B, A>(), this_.second, this_.first);
}

String Pair_toString<A extends dynamic, B extends dynamic>(dynamic this__) {
  final this_ = this__ as PairValue<A, B>;
  return '(${this_.first}, ${this_.second})';
}

class CircleValue extends ShapeValue {
  late double _radius;

  CircleValue() {
    vptr['get_name'] = Circle_get_name;
    vptr['area'] = Circle_area;
    vptr['perimeter'] = Circle_perimeter;
    vptr['get_radius'] = Circle_get_radius;
    vptr['set_radius'] = Circle_set_radius;
  }

  @override
  void gcMark(int flag) {
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
  if ((value < 0)) {
    throw DartArgumentError('Radius must be non-negative');
  }
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

String Circle_toString(dynamic this__) => Shape_toString(this__);

class RectangleValue extends ShapeValue {
  late double width;
  late double height;

  RectangleValue() {
    vptr['get_name'] = Rectangle_get_name;
    vptr['area'] = Rectangle_area;
    vptr['perimeter'] = Rectangle_perimeter;
  }

  @override
  void gcMark(int flag) {
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

String Rectangle_toString(dynamic this__) => Shape_toString(this__);

enum Direction {
  north,
  south,
  east,
  west;
}

String StringExtensions_capitalize(String this_) {
  if (this_.isEmpty) {
    return this_;
  }
  return '${this_[0].toUpperCase()}${this_.substring(1)}';
}

TypeFunction0<String> StringExtensions_get_capitalize(String this_) {
  return ClosureEnv_global_0_new(GC.allocateLocal(ClosureEnv_global_0()), this_);
}

bool StringExtensions_get_isPalindrome(String this_) {
  String reversed = StaticList<String>.of(this_.split('')).reversed.join();
  return (this_ == reversed);
}

StaticList<T> ListExtensions_filterWhere<T extends dynamic>(StaticList<T> this_, TypeFunction1<bool, T> predicate) {
  return StaticList<T>.of(StaticList<T>.of(this_.where(predicate)).toList());
}

TypeFunction1<StaticList<T>, TypeFunction1<bool, T>> ListExtensions_get_filterWhere<T extends dynamic>(StaticList<T> this_) {
  return ClosureEnv_global_1_new<T>(GC.allocateLocal(ClosureEnv_global_1<T>()), this_);
}

T identity<T extends dynamic>(T value) {
  return value;
}

StaticList<T> repeat<T extends dynamic>(T item, int count) {
  return StaticList<T>.generate(count, ClosureEnv_global_2_new<T>(GC.allocateLocal(ClosureEnv_global_2<T>()), item));
}

dynamic makeAdder(int base) {
  return ClosureEnv_global_3_new(GC.allocateLocal(ClosureEnv_global_3()), base);
}

StaticList<int> mapList(StaticList<int> items, TypeFunction1<int, int> transform) {
  return StaticList<int>.of(StaticList<int>.of(items.map(transform)).toList());
}

Promise<String> fetchData(String url) {
  smAwait(promiseDelayed(StaticDuration(milliseconds: 10), () => null));
  return Promise.value<String>('data from ${url}');
}

Promise<StaticList<String>> fetchAll(StaticList<String> urls) {
  StaticList<String> results = StaticList<String>.of([]);
  for (final url in urls) {
    String data = smAwait(fetchData(url));
    results.add(data);
  }
  return Promise.value<StaticList<String>>(results);
}

String? findFirst(StaticList<String> items, TypeFunction1<bool, String> predicate) {
  for (final item in items) {
    if (predicate(item)) {
      return item;
    }
  }
  return null;
}

int safeLength(String? text) {
  return (() { final _unnamed = (() { final _unnamed = text; return ((_unnamed == null) ? null : _unnamed.length); })(); return ((_unnamed == null) ? 0 : _unnamed); })();
}

void main() {
  staticPrint('=== 复杂语法节点还原测试 ===\n');
  staticPrint('--- 1. 泛型类 Pair ---');
  PairValue<String, int> pair = Pair_new<String, int>(PairValue<String, int>(), 'hello', 42);
  PairValue<int, String> swapped = (pair.vptr['swap'] as Function)(pair);
  staticPrint('pair: ${pair}');
  staticPrint('swapped: ${swapped}');
  assert((pair.first == 'hello'));
  assert((swapped.first == 42));
  staticPrint('\n--- 2. 继承 + 多态 ---');
  StaticList<ShapeValue> shapes = StaticList<ShapeValue>.of([Circle_new(CircleValue(), 5.0), Rectangle_new(RectangleValue(), 3.0, 4.0), Circle_new_unit(CircleValue())]);
  for (final shape in shapes) {
    staticPrint('  ${shape}, perimeter=${dart_str_toStringAsFixed((shape.vptr['perimeter'] as Function)(shape), 2)}');
  }
  staticPrint('\n--- 3. getter/setter + 异常 ---');
  CircleValue circle = Circle_new(CircleValue(), 3.0);
  (circle.vptr['set_radius'] as Function)(circle, 5.0);
  staticPrint('radius after set: ${(circle.vptr['get_radius'] as Function)(circle)}');
  try {
    (circle.vptr['set_radius'] as Function)(circle, -1.0);
    staticPrint('ERROR: should have thrown');
  } on DartArgumentError catch ( e) {
    staticPrint('Caught expected error: ${e}');
  }
  staticPrint('\n--- 4. 枚举 + switch ---');
  StaticList<Direction> directions = StaticList<Direction>.of([Direction.north, Direction.east, Direction.south]);
  for (final dir in directions) {
    String label = (() { late String _unnamed;
do {
  switch (dir) {
    case Direction.north:
      _unnamed = 'N';
      break;
    case Direction.south:
      _unnamed = 'S';
      break;
    case Direction.east:
      _unnamed = 'E';
      break;
    case Direction.west:
      _unnamed = 'W';
      break;
  }
} while (false);
return _unnamed; })();
    staticPrint('  ${dir} -> ${label}');
  }
  staticPrint('\n--- 5. 扩展方法 ---');
  String word = 'hello';
  staticPrint('capitalize: ${StringExtensions_capitalize(word)}');
  staticPrint('isPalindrome("racecar"): ${StringExtensions_get_isPalindrome('racecar')}');
  staticPrint('isPalindrome("hello"): ${StringExtensions_get_isPalindrome('hello')}');
  StaticList<int> numbers = StaticList<int>.of([1, 2, 3, 4, 5, 6]);
  StaticList<int> evens = ListExtensions_filterWhere(numbers, ClosureEnv_global_4_new(GC.allocateLocal(ClosureEnv_global_4())));
  staticPrint('evens: ${evens}');
  staticPrint('\n--- 6. 泛型函数 ---');
  staticPrint('identity<int>(99): ${identity(99)}');
  staticPrint('repeat("x", 3): ${repeat('x', 3)}');
  staticPrint('\n--- 7. 高阶函数 + 闭包 ---');
  dynamic add10 = makeAdder(10);
  staticPrint('add10(5): ${add10(5)}');
  StaticList<int> doubled = mapList(StaticList<int>.of([1, 2, 3, 4]), ClosureEnv_global_5_new(GC.allocateLocal(ClosureEnv_global_5())));
  staticPrint('doubled: ${doubled}');
  int counter = 0;
  TypeFunction0<int> increment = ClosureEnv_global_6_new(GC.allocateLocal(ClosureEnv_global_6()), counter);
  staticPrint('counter: ${increment()}, ${increment()}, ${increment()}');
  staticPrint('\n--- 8. 可空类型 ---');
  StaticList<String> items = StaticList<String>.of(['apple', 'banana', 'cherry']);
  String? found = findFirst(items, ClosureEnv_global_7_new(GC.allocateLocal(ClosureEnv_global_7())));
  staticPrint('found: ${found}');
  String? notFound = findFirst(items, ClosureEnv_global_8_new(GC.allocateLocal(ClosureEnv_global_8())));
  staticPrint('notFound: ${notFound}');
  staticPrint('safeLength(null): ${safeLength(null)}');
  staticPrint('safeLength("dart"): ${safeLength('dart')}');
  staticPrint('\n--- 9. 集合操作 ---');
  StaticMap<String, int> map = StaticMap<String, int>.of({'a': 1, 'b': 2, 'c': 3});
  StaticMap<String, int> filtered = StaticMap.fromEntries(StaticList<StaticMapEntry<String, int>>.of(map.entries.where(ClosureEnv_global_9_new(GC.allocateLocal(ClosureEnv_global_9())))));
  staticPrint('filtered map: ${filtered}');
  StaticSet<int> set1 = StaticSet<int>.of({1, 2, 3, 4});
  StaticSet<int> set2 = StaticSet<int>.of({3, 4, 5, 6});
  StaticSet<int> intersection = set1.intersection(set2);
  staticPrint('intersection: ${intersection}');
  staticPrint('\n--- 10. 字符串插值 ---');
  String name = 'Dart';
  int version = 3;
  String greeting = 'Hello, ${name} ${version}!';
  String multiExpr = 'Sum: ${((1 + 2) + 3)}, Upper: ${name.toUpperCase()}';
  staticPrint(greeting);
  staticPrint(multiExpr);
  staticPrint('\n--- 11. 条件表达式 + 类型检查 ---');
  dynamic value = 42;
  String typeLabel = (value is int ? 'integer' : (value is String ? 'string' : 'other'));
  staticPrint('typeLabel: ${typeLabel}');
  staticPrint('\n--- 12. 循环语句 ---');
  int sum = 0;
  for (int i = 1; (i <= 5); i = (i + 1)) {
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
  } while ((doCount < 3));
  staticPrint('doCount: ${doCount}');
  staticPrint('\n--- 13. try/catch/finally ---');
  String result = '';
  try {
    result = 'try';
    throw DartStateError('test error');
  } on DartStateError catch ( e) {
    result = (result + '+catch(${e.message})');
  } finally {
    result = (result + '+finally');
  }
  staticPrint('result: ${result}');
  staticPrint('\n--- 14. 集合字面量 ---');
  staticPrint('constList: ${StaticList.of([1, 2, 3])}');
  staticPrint('constMap: ${StaticMap.of({'key': 'value'})}');
  staticPrint('constSet: ${StaticSet.of({10, 20, 30})}');
  staticPrint('\n=== 所有测试通过 ✅ ===');
}

class ClosureEnv_global_0 extends TypeFunction0<String> {
  late String this_;

  ClosureEnv_global_0() {
  }
  String call() =>
      ClosureEnv_global_0_call(this);

  @override
  void gcMark(int flag) {
    super.gcMark(flag);
  }
}

String ClosureEnv_global_0_call(dynamic env__) {
  final env = env__ as ClosureEnv_global_0;
  return StringExtensions_capitalize(env.this_);
}

ClosureEnv_global_0 ClosureEnv_global_0_new(ClosureEnv_global_0 env_, String this_) {
  env_.this_ = this_;
  return env_;
}

class ClosureEnv_global_1<T extends dynamic> extends TypeFunction1<StaticList<T>, TypeFunction1<bool, T>> {
  late StaticList<T> this_;

  ClosureEnv_global_1() {
  }
  StaticList<T> call(TypeFunction1<bool, T> predicate) =>
      ClosureEnv_global_1_call(this, predicate);

  @override
  void gcMark(int flag) {
    super.gcMark(flag);
    this_?.gcMark(flag);
  }
}

StaticList<T> ClosureEnv_global_1_call<T extends dynamic>(dynamic env__, TypeFunction1<bool, T> predicate) {
  final env = env__ as ClosureEnv_global_1<T>;
  return ListExtensions_filterWhere(env.this_, predicate);
}

ClosureEnv_global_1<T> ClosureEnv_global_1_new<T extends dynamic>(ClosureEnv_global_1<T> env_, StaticList<T> this_) {
  env_.this_ = this_;
  return env_;
}

class ClosureEnv_global_2<T extends dynamic> extends TypeFunction1<T, int> {
  late T item;

  ClosureEnv_global_2() {
  }
  T call(int _) =>
      ClosureEnv_global_2_call(this, _);

  @override
  void gcMark(int flag) {
    super.gcMark(flag);
  }
}

T ClosureEnv_global_2_call<T extends dynamic>(dynamic env__, int _) {
  final env = env__ as ClosureEnv_global_2<T>;
  return env.item;
}

ClosureEnv_global_2<T> ClosureEnv_global_2_new<T extends dynamic>(ClosureEnv_global_2<T> env_, T item) {
  env_.item = item;
  return env_;
}

class ClosureEnv_global_3 extends TypeFunction1<int, int> {
  late int base;

  ClosureEnv_global_3() {
  }
  int call(int x) =>
      ClosureEnv_global_3_call(this, x);

  @override
  void gcMark(int flag) {
    super.gcMark(flag);
  }
}

int ClosureEnv_global_3_call(dynamic env__, int x) {
  final env = env__ as ClosureEnv_global_3;
  return (env.base + x);
}

ClosureEnv_global_3 ClosureEnv_global_3_new(ClosureEnv_global_3 env_, int base) {
  env_.base = base;
  return env_;
}

class ClosureEnv_global_4 extends TypeFunction1<bool, int> {

  ClosureEnv_global_4() {
  }
  bool call(int n) =>
      ClosureEnv_global_4_call(this, n);
}

bool ClosureEnv_global_4_call(dynamic env__, int n) {
  final env = env__ as ClosureEnv_global_4;
  return ((n % 2) == 0);
}

ClosureEnv_global_4 ClosureEnv_global_4_new(ClosureEnv_global_4 env_) {
  return env_;
}

class ClosureEnv_global_5 extends TypeFunction1<int, int> {

  ClosureEnv_global_5() {
  }
  int call(int x) =>
      ClosureEnv_global_5_call(this, x);
}

int ClosureEnv_global_5_call(dynamic env__, int x) {
  final env = env__ as ClosureEnv_global_5;
  return (x * 2);
}

ClosureEnv_global_5 ClosureEnv_global_5_new(ClosureEnv_global_5 env_) {
  return env_;
}

class ClosureEnv_global_6 extends TypeFunction0<int> {
  late int counter;

  ClosureEnv_global_6() {
  }
  int call() =>
      ClosureEnv_global_6_call(this);

  @override
  void gcMark(int flag) {
    super.gcMark(flag);
  }
}

int ClosureEnv_global_6_call(dynamic env__) {
  final env = env__ as ClosureEnv_global_6;
  env.counter = (env.counter + 1);
  return env.counter;
}

ClosureEnv_global_6 ClosureEnv_global_6_new(ClosureEnv_global_6 env_, int counter) {
  env_.counter = counter;
  return env_;
}

class ClosureEnv_global_7 extends TypeFunction1<bool, String> {

  ClosureEnv_global_7() {
  }
  bool call(String s) =>
      ClosureEnv_global_7_call(this, s);
}

bool ClosureEnv_global_7_call(dynamic env__, String s) {
  final env = env__ as ClosureEnv_global_7;
  return s.startsWith('b');
}

ClosureEnv_global_7 ClosureEnv_global_7_new(ClosureEnv_global_7 env_) {
  return env_;
}

class ClosureEnv_global_8 extends TypeFunction1<bool, String> {

  ClosureEnv_global_8() {
  }
  bool call(String s) =>
      ClosureEnv_global_8_call(this, s);
}

bool ClosureEnv_global_8_call(dynamic env__, String s) {
  final env = env__ as ClosureEnv_global_8;
  return s.startsWith('z');
}

ClosureEnv_global_8 ClosureEnv_global_8_new(ClosureEnv_global_8 env_) {
  return env_;
}

class ClosureEnv_global_9 extends TypeFunction1<bool, StaticMapEntry<String, int>> {

  ClosureEnv_global_9() {
  }
  bool call(StaticMapEntry<String, int> e) =>
      ClosureEnv_global_9_call(this, e);
}

bool ClosureEnv_global_9_call(dynamic env__, StaticMapEntry<String, int> e) {
  final env = env__ as ClosureEnv_global_9;
  return (e.value > 1);
}

ClosureEnv_global_9 ClosureEnv_global_9_new(ClosureEnv_global_9 env_) {
  return env_;
}

