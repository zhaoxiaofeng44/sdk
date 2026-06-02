import 'package:dart2cpp/restorer/runtime_classes.dart';

class ShapeValue extends VPtr {
  ShapeValue() {
    vptr['get_name'] = const _TearOff_Shape_get_name();
    vptr['area'] = const _TearOff_Shape_area();
    vptr['perimeter'] = const _TearOff_Shape_perimeter();
    vptr['toString'] = const _TearOff_Shape_toString();
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
  return '${(this_.vptr['get_name'] as TypeFunction1<String, dynamic>)(this_)}(area=${(this_.vptr['area'] as TypeFunction1<double, dynamic>)(this_).toStringAsFixed(2)})';
}


class PairValue<A, B> extends VPtr {
  late A first;
  late B second;
  PairValue() {
    vptr['swap'] = _TearOff_Pair_swap<A, B>();
    vptr['toString'] = _TearOff_Pair_toString<A, B>();
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
  return Pair_new<B, A>(PairValue<B, A>(), this_.second, this_.first);
}

String Pair_toString<A, B>(dynamic this__) {
  final this_ = this__ as PairValue<A, B>;
  return '(${this_.first}, ${this_.second})';
}


class CircleValue extends ShapeValue {
  late double _radius;
  CircleValue() {
    vptr['get_name'] = const _TearOff_Circle_get_name();
    vptr['area'] = const _TearOff_Circle_area();
    vptr['perimeter'] = const _TearOff_Circle_perimeter();
    vptr['toString'] = const _TearOff_Circle_toString();
    vptr['get_radius'] = const _TearOff_Circle_get_radius();
    vptr['set_radius'] = const _TearOff_Circle_set_radius();
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
  if ((value < 0))   throw ArgumentError('Radius must be non-negative');
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
  RectangleValue() {
    vptr['get_name'] = const _TearOff_Rectangle_get_name();
    vptr['area'] = const _TearOff_Rectangle_area();
    vptr['perimeter'] = const _TearOff_Rectangle_perimeter();
    vptr['toString'] = const _TearOff_Rectangle_toString();
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
  return ClosureEnv_StringExtensions_get_capitalize_0(this_);
}

bool StringExtensions_get_isPalindrome(final String this_) {
  final String reversed = this_.split('').reversed.join();
  return (this_ == reversed);
}

StaticList<T> ListExtensions_filterWhere<T>(final StaticList<T> this_, TypeFunction1<bool, T> predicate) {
  return StaticList.of(this_.where(predicate).toList());
}

TypeFunction1<StaticList<T>, TypeFunction1<bool, T>> ListExtensions_get_filterWhere<T>(final StaticList<T> this_) {
  return ClosureEnv_ListExtensions_get_filterWhere_1<T>(this_);
}

T identity<T>(T value) {
  return value;
}

StaticList<T> repeat<T>(T item_raw, int count) {
  ObjectBox<T> item = ObjectBox<T>(item_raw);
  return StaticList<T>.generate(count, ClosureEnv_repeat_2<T>(item));
}

dynamic makeAdder(int base_raw) {
  IntBox base = IntBox(base_raw);
  return ClosureEnv_makeAdder_3(base);
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
    if (predicate(item))     return item;
  }
  return null;
}

int safeLength(String? text) {
  return (text?.length ?? 0);
}

void main() {
  print('=== 复杂语法节点还原测试 ===\n');
  print('--- 1. 泛型类 Pair ---');
  final PairValue<String, int> pair = Pair_new<String, int>(PairValue<String, int>(), 'hello', 42);
  final PairValue<int, String> swapped = (pair.vptr['swap'] as TypeFunction1<PairValue<int, String>, dynamic>)(pair);
  print('pair: ${pair}');
  print('swapped: ${swapped}');
  assert((pair.first == 'hello'));
  assert((swapped.first == 42));
  print('\n--- 2. 继承 + 多态 ---');
  final StaticList<ShapeValue> shapes = StaticList<ShapeValue>.of([Circle_new(CircleValue(), 5.0), Rectangle_new(RectangleValue(), 3.0, 4.0), Circle_new_unit(CircleValue())]);
  for (final shape in shapes) {
    print('  ${shape}, perimeter=${(shape.vptr['perimeter'] as TypeFunction1<double, dynamic>)(shape).toStringAsFixed(2)}');
  }
  print('\n--- 3. getter/setter + 异常 ---');
  final CircleValue circle = Circle_new(CircleValue(), 3.0);
  (circle.vptr['set_radius'] as TypeFunction2<void, dynamic, double>)(circle, 5.0);
  print('radius after set: ${(circle.vptr['get_radius'] as TypeFunction1<double, dynamic>)(circle)}');
  try {
    (circle.vptr['set_radius'] as TypeFunction2<void, dynamic, double>)(circle, (-1.0));
    print('ERROR: should have thrown');
  }
 on ArgumentError catch (e) {
    print('Caught expected error: ${e}');
  }
  print('\n--- 4. 枚举 + switch ---');
  final StaticList<Direction> directions = StaticList<Direction>.of([Direction.north, Direction.east, Direction.south]);
  for (final dir in directions) {
    final String label = (() {     late String _v2;
    do {
      switch (dir) {
        case Direction.north:
{
            _v2 = 'N';
            break;
          }
        case Direction.south:
{
            _v2 = 'S';
            break;
          }
        case Direction.east:
{
            _v2 = 'E';
            break;
          }
        case Direction.west:
{
            _v2 = 'W';
            break;
          }
      }
    } while (false);
 return _v2; })();
    print('  ${dir} -> ${label}');
  }
  print('\n--- 5. 扩展方法 ---');
  final String word = 'hello';
  print('capitalize: ${StringExtensions_capitalize(word)}');
  print('isPalindrome("racecar"): ${StringExtensions_get_isPalindrome('racecar')}');
  print('isPalindrome("hello"): ${StringExtensions_get_isPalindrome('hello')}');
  final StaticList<int> numbers = StaticList<int>.of([1, 2, 3, 4, 5, 6]);
  final StaticList<int> evens = ListExtensions_filterWhere(numbers, ClosureEnv_main_6());
  print('evens: ${evens}');
  print('\n--- 6. 泛型函数 ---');
  print('identity<int>(99): ${identity<int>(99)}');
  print('repeat("x", 3): ${repeat<String>('x', 3)}');
  print('\n--- 7. 高阶函数 + 闭包 ---');
  final dynamic add10 = makeAdder(10);
  print('add10(5): ${add10(5)}');
  final StaticList<int> doubled = mapList(StaticList<int>.of([1, 2, 3, 4]), ClosureEnv_main_7());
  print('doubled: ${doubled}');
  IntBox counter = IntBox(0);
  final TypeFunction0<int> increment = ClosureEnv_main_8(counter);
  print('counter: ${increment()}, ${increment()}, ${increment()}');
  print('\n--- 8. 可空类型 ---');
  final StaticList<String> items = StaticList<String>.of(['apple', 'banana', 'cherry']);
  final String? found = findFirst(items, ClosureEnv_main_9());
  print('found: ${found}');
  final String? notFound = findFirst(items, ClosureEnv_main_10());
  print('notFound: ${notFound}');
  print('safeLength(null): ${safeLength(null)}');
  print('safeLength("dart"): ${safeLength('dart')}');
  print('\n--- 9. 集合操作 ---');
  final StaticMap<String, int> map = StaticMap<String, int>.of({'a': 1, 'b': 2, 'c': 3});
  final StaticMap<String, int> filtered = StaticMap<String, int>.fromEntries(map.entries.where(ClosureEnv_main_11()));
  print('filtered map: ${filtered}');
  final StaticSet<int> set1 = StaticSet<int>.of([1, 2, 3, 4]);
  final StaticSet<int> set2 = StaticSet<int>.of([3, 4, 5, 6]);
  final StaticSet<int> intersection = set1.intersection(set2);
  print('intersection: ${intersection}');
  print('\n--- 10. 字符串插值 ---');
  final String name = 'Dart';
  final int version = 3;
  final String greeting = 'Hello, ${name} ${version}!';
  final String multiExpr = 'Sum: ${((1 + 2) + 3)}, Upper: ${name.toUpperCase()}';
  print(greeting);
  print(multiExpr);
  print('\n--- 11. 条件表达式 + 类型检查 ---');
  final dynamic value = 42;
  final String typeLabel = ((value is int) ? 'integer' : ((value is String) ? 'string' : 'other'));
  print('typeLabel: ${typeLabel}');
  print('\n--- 12. 循环语句 ---');
  int sum = 0;
  for (var i = 1; (i <= 5); i = (i + 1)) {
    sum = (sum + i);
  }
  print('sum 1..5: ${sum}');
  int product = 1;
  int n = 5;
  while ((n > 0)) {
    product = (product * n);
    n = (n - 1);
  }
  print('5! = ${product}');
  int doCount = 0;
  do {
    doCount = (doCount + 1);
  }
 while ((doCount < 3));
  print('doCount: ${doCount}');
  print('\n--- 13. try/catch/finally ---');
  String result = '';
  try {
    result = 'try';
    throw StateError('test error');
  }
 on StateError catch (e) {
    result = (result + '+catch(${e.message})');
  }
 finally {
    result = (result + '+finally');
  }
  print('result: ${result}');
  print('\n--- 14. 集合字面量 ---');
  print('constList: ${const [1, 2, 3]}');
  print('constMap: ${const {'key': 'value'}}');
  print('constSet: ${const {10, 20, 30}}');
  print('\n=== 所有测试通过 ✅ ===');
}

class _TearOff_Shape_get_name extends TypeFunction1<String, dynamic> {
  const _TearOff_Shape_get_name();
  @override
  String call(dynamic this_) => Shape_get_name(this_);
}
class _TearOff_Shape_area extends TypeFunction1<double, dynamic> {
  const _TearOff_Shape_area();
  @override
  double call(dynamic this_) => Shape_area(this_);
}
class _TearOff_Shape_perimeter extends TypeFunction1<double, dynamic> {
  const _TearOff_Shape_perimeter();
  @override
  double call(dynamic this_) => Shape_perimeter(this_);
}
class _TearOff_Shape_toString extends TypeFunction1<String, dynamic> {
  const _TearOff_Shape_toString();
  @override
  String call(dynamic this_) => Shape_toString(this_);
}
class _TearOff_Pair_swap<A, B> extends TypeFunction1<PairValue<B, A>, dynamic> {
  _TearOff_Pair_swap();
  @override
  PairValue<B, A> call(dynamic this_) => Pair_swap<A, B>(this_);
}
class _TearOff_Pair_toString<A, B> extends TypeFunction1<String, dynamic> {
  _TearOff_Pair_toString();
  @override
  String call(dynamic this_) => Pair_toString<A, B>(this_);
}
class _TearOff_Circle_get_name extends TypeFunction1<String, dynamic> {
  const _TearOff_Circle_get_name();
  @override
  String call(dynamic this_) => Circle_get_name(this_);
}
class _TearOff_Circle_area extends TypeFunction1<double, dynamic> {
  const _TearOff_Circle_area();
  @override
  double call(dynamic this_) => Circle_area(this_);
}
class _TearOff_Circle_perimeter extends TypeFunction1<double, dynamic> {
  const _TearOff_Circle_perimeter();
  @override
  double call(dynamic this_) => Circle_perimeter(this_);
}
class _TearOff_Circle_toString extends TypeFunction1<String, dynamic> {
  const _TearOff_Circle_toString();
  @override
  String call(dynamic this_) => Circle_toString(this_);
}
class _TearOff_Circle_get_radius extends TypeFunction1<double, dynamic> {
  const _TearOff_Circle_get_radius();
  @override
  double call(dynamic this_) => Circle_get_radius(this_);
}
class _TearOff_Circle_set_radius extends TypeFunction2<void, dynamic, double> {
  const _TearOff_Circle_set_radius();
  @override
  void call(dynamic this_, double value) => Circle_set_radius(this_, value);
}
class _TearOff_Rectangle_get_name extends TypeFunction1<String, dynamic> {
  const _TearOff_Rectangle_get_name();
  @override
  String call(dynamic this_) => Rectangle_get_name(this_);
}
class _TearOff_Rectangle_area extends TypeFunction1<double, dynamic> {
  const _TearOff_Rectangle_area();
  @override
  double call(dynamic this_) => Rectangle_area(this_);
}
class _TearOff_Rectangle_perimeter extends TypeFunction1<double, dynamic> {
  const _TearOff_Rectangle_perimeter();
  @override
  double call(dynamic this_) => Rectangle_perimeter(this_);
}
class _TearOff_Rectangle_toString extends TypeFunction1<String, dynamic> {
  const _TearOff_Rectangle_toString();
  @override
  String call(dynamic this_) => Rectangle_toString(this_);
}
class ClosureEnv_StringExtensions_get_capitalize_0 extends TypeFunction0<String> {
  String this_;
  ClosureEnv_StringExtensions_get_capitalize_0(this.this_);
  @override
  String call() => ClosureEnv_StringExtensions_get_capitalize_0_call(this);
}
String ClosureEnv_StringExtensions_get_capitalize_0_call(ClosureEnv_StringExtensions_get_capitalize_0 env) {
  return StringExtensions_capitalize(env.this_);
}

class ClosureEnv_ListExtensions_get_filterWhere_1<T> extends TypeFunction1<StaticList<T>, TypeFunction1<bool, T>> {
  StaticList<T> this_;
  ClosureEnv_ListExtensions_get_filterWhere_1(this.this_);
  @override
  StaticList<T> call(TypeFunction1<bool, T> predicate) => ClosureEnv_ListExtensions_get_filterWhere_1_call<T>(this, predicate);
}
StaticList<T> ClosureEnv_ListExtensions_get_filterWhere_1_call<T>(ClosureEnv_ListExtensions_get_filterWhere_1<T> env, TypeFunction1<bool, T> predicate) {
  return ListExtensions_filterWhere(env.this_, predicate);
}

class ClosureEnv_repeat_2<T> extends TypeFunction1<T, int> {
  ObjectBox<T> item;
  ClosureEnv_repeat_2(this.item);
  @override
  T call(int _) => ClosureEnv_repeat_2_call<T>(this, _);
}
T ClosureEnv_repeat_2_call<T>(ClosureEnv_repeat_2<T> env, int _) {
  return env.item.value;
}

class ClosureEnv_makeAdder_3 extends TypeFunction1<int, int> {
  IntBox base;
  ClosureEnv_makeAdder_3(this.base);
  @override
  int call(int x) => ClosureEnv_makeAdder_3_call(this, x);
}
int ClosureEnv_makeAdder_3_call(ClosureEnv_makeAdder_3 env, int x) {
  return (env.base.value + x);
}

class ClosureEnv_fetchData_4 {
  StringBox url;
  Promise<String> _promise;
  ClosureEnv_fetchData_4(String url) : _promise = Promise<String>(), url = StringBox(url);
  void call() => ClosureEnv_fetchData_4_call(this);
}
void ClosureEnv_fetchData_4_call(ClosureEnv_fetchData_4 env) {
  smAwait(promiseDelayed<dynamic>(Duration(milliseconds: 10)));
  env._promise.complete('data from ${env.url.value}');
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
  env._promise.complete(results);
  return;
}
class ClosureEnv_main_6 extends TypeFunction1<bool, int> {
  ClosureEnv_main_6();
  @override
  bool call(int n) => ClosureEnv_main_6_call(this, n);
}
bool ClosureEnv_main_6_call(ClosureEnv_main_6 env, int n) {
  return ((n % 2) == 0);
}

class ClosureEnv_main_7 extends TypeFunction1<int, int> {
  ClosureEnv_main_7();
  @override
  int call(int x) => ClosureEnv_main_7_call(this, x);
}
int ClosureEnv_main_7_call(ClosureEnv_main_7 env, int x) {
  return (x * 2);
}

class ClosureEnv_main_8 extends TypeFunction0<int> {
  IntBox counter;
  ClosureEnv_main_8(this.counter);
  @override
  int call() => ClosureEnv_main_8_call(this);
}
int ClosureEnv_main_8_call(ClosureEnv_main_8 env) {
    env.counter.value = (env.counter.value + 1);
    return env.counter.value;
  }

class ClosureEnv_main_9 extends TypeFunction1<bool, String> {
  ClosureEnv_main_9();
  @override
  bool call(String s) => ClosureEnv_main_9_call(this, s);
}
bool ClosureEnv_main_9_call(ClosureEnv_main_9 env, String s) {
  return s.startsWith('b');
}

class ClosureEnv_main_10 extends TypeFunction1<bool, String> {
  ClosureEnv_main_10();
  @override
  bool call(String s) => ClosureEnv_main_10_call(this, s);
}
bool ClosureEnv_main_10_call(ClosureEnv_main_10 env, String s) {
  return s.startsWith('z');
}

class ClosureEnv_main_11 extends TypeFunction1<bool, MapEntry<String, int>> {
  ClosureEnv_main_11();
  @override
  bool call(MapEntry<String, int> e) => ClosureEnv_main_11_call(this, e);
}
bool ClosureEnv_main_11_call(ClosureEnv_main_11 env, MapEntry<String, int> e) {
  return (e.value > 1);
}

