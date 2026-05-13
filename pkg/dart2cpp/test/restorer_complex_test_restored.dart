class VPtr {
  late Map<String, dynamic> vptr;
  VPtr() {
    vptr = <String, dynamic>{
      'toString': null,
      'operatorEq': null,
      'get_hashCode': null,
    };
  }
  @override
  String toString() {
    final fn = vptr['toString'];
    if (fn != null) return (fn as Function)(this) as String;
    return super.toString();
  }
  @override
  bool operator ==(Object other) {
    final fn = vptr['operatorEq'];
    if (fn != null) return (fn as Function)(this, other) as bool;
    return identical(this, other);
  }
  @override
  int get hashCode {
    final fn = vptr['get_hashCode'];
    if (fn != null) return (fn as Function)(this) as int;
    return super.hashCode;
  }
}

class IntBox {
  int value;
  IntBox(this.value);
}

class DoubleBox {
  double value;
  DoubleBox(this.value);
}

class StringBox {
  String value;
  StringBox(this.value);
}

class BoolBox {
  bool value;
  BoolBox(this.value);
}

class ObjectBox<T> {
  T value;
  ObjectBox(this.value);
}

class ShapeValue extends VPtr {
}

ShapeValue Shape_new(dynamic this__) {
  final this_ = this__ as ShapeValue;
  this_.vptr['get_name'] = Shape_get_name;
  this_.vptr['area'] = Shape_area;
  this_.vptr['perimeter'] = Shape_perimeter;
  this_.vptr['toString'] = Shape_toString;
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
}

PairValue<A, B> Pair_new<A, B>(dynamic this__, A first, B second) {
  final this_ = this__ as PairValue<A, B>;
  this_.vptr['swap'] = Pair_swap<A, B>;
  this_.vptr['toString'] = Pair_toString<A, B>;
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
}

CircleValue Circle_new(dynamic this__, double _radius) {
  final this_ = this__ as CircleValue;
  Shape_new(this_);
  this_.vptr['get_name'] = Circle_get_name;
  this_.vptr['area'] = Circle_area;
  this_.vptr['perimeter'] = Circle_perimeter;
  this_.vptr['toString'] = Circle_toString;
  this_.vptr['get_radius'] = Circle_get_radius;
  this_.vptr['set_radius'] = Circle_set_radius;
  this_._radius = _radius;
  return this_;
}

CircleValue Circle_new_unit(dynamic this__) {
  final this_ = this__ as CircleValue;
  Shape_new(this_);
  this_.vptr['get_name'] = Circle_get_name;
  this_.vptr['area'] = Circle_area;
  this_.vptr['perimeter'] = Circle_perimeter;
  this_.vptr['toString'] = Circle_toString;
  this_.vptr['get_radius'] = Circle_get_radius;
  this_.vptr['set_radius'] = Circle_set_radius;
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
}

RectangleValue Rectangle_new(dynamic this__, double width, double height) {
  final this_ = this__ as RectangleValue;
  Shape_new(this_);
  this_.vptr['get_name'] = Rectangle_get_name;
  this_.vptr['area'] = Rectangle_area;
  this_.vptr['perimeter'] = Rectangle_perimeter;
  this_.vptr['toString'] = Rectangle_toString;
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

String Function() StringExtensions_get_capitalize(final String this_) {
  return ClosureEnv_StringExtensions_get_capitalize_0(this_).call;
}

bool StringExtensions_get_isPalindrome(final String this_) {
  final String reversed = this_.split('').reversed.join();
  return (this_ == reversed);
}

List<T> ListExtensions_filterWhere<T>(final List<T> this_, bool Function(T) predicate) {
  return this_.where(predicate).toList();
}

List<T> Function(bool Function(T)) ListExtensions_get_filterWhere<T>(final List<T> this_) {
  return ClosureEnv_ListExtensions_get_filterWhere_1(this_).call;
}

T identity<T>(T value) {
  return value;
}

List<T> repeat<T>(T item_raw, int count) {
  ObjectBox<T> item = ObjectBox<T>(item_raw);
  return List.generate(count, ClosureEnv_repeat_2(item).call);
}

Function makeAdder(int base_raw) {
  IntBox base = IntBox(base_raw);
  return ClosureEnv_makeAdder_3(base).call;
}

List<int> mapList(List<int> items, int Function(int) transform) {
  return items.map(transform).toList();
}

Future<String> fetchData(String url) async {
  await Future.delayed(Duration(milliseconds: 10));
  return 'data from ${url}';
}

Future<List<String>> fetchAll(List<String> urls) async {
  final List<String> results = <String>[];
  for (final url in urls) {
    final String data = await fetchData(url);
    results.add(data);
  }
  return results;
}

String? findFirst(List<String> items, bool Function(String) predicate) {
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
  final PairValue<int, String> swapped = (pair.vptr['swap'] as PairValue<int, String> Function(dynamic))(pair);
  print('pair: ${pair}');
  print('swapped: ${swapped}');
  assert((pair.first == 'hello'));
  assert((swapped.first == 42));
  print('\n--- 2. 继承 + 多态 ---');
  final List<ShapeValue> shapes = <ShapeValue>[Circle_new(CircleValue(), 5.0), Rectangle_new(RectangleValue(), 3.0, 4.0), Circle_new_unit(CircleValue())];
  for (final shape in shapes) {
    print('  ${shape}, perimeter=${(shape.vptr['perimeter'] as double Function(dynamic))(shape).toStringAsFixed(2)}');
  }
  print('\n--- 3. getter/setter + 异常 ---');
  final CircleValue circle = Circle_new(CircleValue(), 3.0);
  (circle.vptr['set_radius'] as void Function(dynamic, double))(circle, 5.0);
  print('radius after set: ${(circle.vptr['get_radius'] as double Function(dynamic))(circle)}');
  try {
    (circle.vptr['set_radius'] as void Function(dynamic, double))(circle, (-1.0));
    print('ERROR: should have thrown');
  }
 on ArgumentError catch (e) {
    print('Caught expected error: ${e}');
  }
  print('\n--- 4. 枚举 + switch ---');
  final List<Direction> directions = <Direction>[Direction.north, Direction.east, Direction.south];
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
  final List<int> numbers = <int>[1, 2, 3, 4, 5, 6];
  final List<int> evens = ListExtensions_filterWhere(numbers, (int n) => ((n % 2) == 0));
  print('evens: ${evens}');
  print('\n--- 6. 泛型函数 ---');
  print('identity<int>(99): ${identity<int>(99)}');
  print('repeat("x", 3): ${repeat<String>('x', 3)}');
  print('\n--- 7. 高阶函数 + 闭包 ---');
  final Function add10 = makeAdder(10);
  print('add10(5): ${add10(5)}');
  final List<int> doubled = mapList(<int>[1, 2, 3, 4], (int x) => (x * 2));
  print('doubled: ${doubled}');
  IntBox counter = IntBox(0);
  final int Function() increment = ClosureEnv_main_4(counter).call;
  print('counter: ${increment()}, ${increment()}, ${increment()}');
  print('\n--- 8. 可空类型 ---');
  final List<String> items = <String>['apple', 'banana', 'cherry'];
  final String? found = findFirst(items, (String s) => s.startsWith('b'));
  print('found: ${found}');
  final String? notFound = findFirst(items, (String s) => s.startsWith('z'));
  print('notFound: ${notFound}');
  print('safeLength(null): ${safeLength(null)}');
  print('safeLength("dart"): ${safeLength('dart')}');
  print('\n--- 9. 集合操作 ---');
  final Map<String, int> map = <String, int>{'a': 1, 'b': 2, 'c': 3};
  final Map<String, int> filtered = Map.fromEntries(map.entries.where((MapEntry<String, int> e) => (e.value > 1)));
  print('filtered map: ${filtered}');
  final Set<int> set1 = <int>{1, 2, 3, 4};
  final Set<int> set2 = <int>{3, 4, 5, 6};
  final Set<int> intersection = set1.intersection(set2);
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

class ClosureEnv_StringExtensions_get_capitalize_0 {
  String this_;
  ClosureEnv_StringExtensions_get_capitalize_0(this.this_);
  String call() => ClosureEnv_StringExtensions_get_capitalize_0_call(this);
}
String ClosureEnv_StringExtensions_get_capitalize_0_call(ClosureEnv_StringExtensions_get_capitalize_0 env) {
  return StringExtensions_capitalize(env.this_);
}

class ClosureEnv_ListExtensions_get_filterWhere_1<T> {
  List<T> this_;
  ClosureEnv_ListExtensions_get_filterWhere_1(this.this_);
  List<T> call(bool Function(T) predicate) => ClosureEnv_ListExtensions_get_filterWhere_1_call<T>(this, predicate);
}
List<T> ClosureEnv_ListExtensions_get_filterWhere_1_call<T>(ClosureEnv_ListExtensions_get_filterWhere_1<T> env, bool Function(T) predicate) {
  return ListExtensions_filterWhere(env.this_, predicate);
}

class ClosureEnv_repeat_2<T> {
  ObjectBox<T> item;
  ClosureEnv_repeat_2(this.item);
  T call(int _) => ClosureEnv_repeat_2_call<T>(this, _);
}
T ClosureEnv_repeat_2_call<T>(ClosureEnv_repeat_2<T> env, int _) {
  return env.item.value;
}

class ClosureEnv_makeAdder_3 {
  IntBox base;
  ClosureEnv_makeAdder_3(this.base);
  int call(int x) => ClosureEnv_makeAdder_3_call(this, x);
}
int ClosureEnv_makeAdder_3_call(ClosureEnv_makeAdder_3 env, int x) {
  return (env.base.value + x);
}

class ClosureEnv_main_4 {
  IntBox counter;
  ClosureEnv_main_4(this.counter);
  int call() => ClosureEnv_main_4_call(this);
}
int ClosureEnv_main_4_call(ClosureEnv_main_4 env) {
    env.counter.value = (env.counter.value + 1);
    return env.counter.value;
  }

