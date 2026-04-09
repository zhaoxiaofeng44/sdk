class ShapeValue {
  late ShapeVTable vptr;
}

class ShapeVTable {
  late String Function(dynamic this_) get_name;
  late double Function(dynamic this_) area;
  late double Function(dynamic this_) perimeter;
  late String Function(dynamic this_) toString_;
}

ShapeValue Shape_new() {
  final obj = ShapeValue();
  obj.vptr = ShapeVTable()
    ..get_name = Shape_get_name
    ..area = Shape_area
    ..perimeter = Shape_perimeter
    ..toString_ = Shape_toString
  ;
  return obj;
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

String Shape_toString(dynamic this_) {
  return '${this_.vptr.get_name(this_)}(area=${this_.vptr.area(this_).toStringAsFixed(2)})';
}


class PairValue<A, B> {
  late PairVTable vptr;
  late A first;
  late B second;
}

class PairVTable<A, B> {
  late PairValue<B, A> Function(PairValue this_) swap;
  late String Function(dynamic this_) toString_;
}

PairValue<A, B> Pair_new<A, B>(A first, B second) {
  final obj = PairValue();
  obj.vptr = PairVTable()
    ..swap = Pair_swap
    ..toString_ = Pair_toString
  ;
  obj.first = first;
  obj.second = second;
  return obj;
}

PairValue<B, A> Pair_swap<A, B>(dynamic this_) {
  return Pair_new(this_.second, this_.first);
}

String Pair_toString<A, B>(dynamic this_) {
  return '(${this_.first}, ${this_.second})';
}


class CircleValue extends ShapeValue {
  late CircleVTable vptr;
  late double _radius;
}

class CircleVTable {
  late String Function(dynamic this_) get_name;
  late double Function(dynamic this_) area;
  late double Function(dynamic this_) perimeter;
  late String Function(dynamic this_) toString_;
  late double Function(dynamic this_) get_radius;
  late void Function(dynamic this_, double value) set_radius;
}

CircleValue Circle_new(double _radius) {
  final obj = CircleValue();
  obj.vptr = CircleVTable()
    ..get_name = Circle_get_name
    ..area = Circle_area
    ..perimeter = Circle_perimeter
    ..toString_ = Circle_toString
    ..get_radius = Circle_get_radius
    ..set_radius = Circle_set_radius
  ;
  obj._radius = _radius;
  return obj;
}

CircleValue Circle_new_unit() {
  final obj = CircleValue();
  obj.vptr = CircleVTable()
    ..get_name = Circle_get_name
    ..area = Circle_area
    ..perimeter = Circle_perimeter
    ..toString_ = Circle_toString
    ..get_radius = Circle_get_radius
    ..set_radius = Circle_set_radius
  ;
  obj._radius = 1.0;
  return obj;
}

double Circle_get_radius(dynamic this_) {
  return this_._radius;
}

void Circle_set_radius(dynamic this_, double value) {
  if ((value < 0))   throw ArgumentError('Radius must be non-negative');
  this_._radius = value;
}

String Circle_get_name(dynamic this_) {
  return 'Circle';
}

double Circle_area(dynamic this_) {
  return ((3.14159265 * this_._radius) * this_._radius);
}

double Circle_perimeter(dynamic this_) {
  return ((2 * 3.14159265) * this_._radius);
}

String Circle_toString(dynamic this_) {
  return this_.vptr.toString_(this_);
}


class RectangleValue extends ShapeValue {
  late RectangleVTable vptr;
  late double width;
  late double height;
}

class RectangleVTable {
  late String Function(dynamic this_) get_name;
  late double Function(dynamic this_) area;
  late double Function(dynamic this_) perimeter;
  late String Function(dynamic this_) toString_;
}

RectangleValue Rectangle_new(double width, double height) {
  final obj = RectangleValue();
  obj.vptr = RectangleVTable()
    ..get_name = Rectangle_get_name
    ..area = Rectangle_area
    ..perimeter = Rectangle_perimeter
    ..toString_ = Rectangle_toString
  ;
  obj.width = width;
  obj.height = height;
  return obj;
}

String Rectangle_get_name(dynamic this_) {
  return 'Rectangle';
}

double Rectangle_area(dynamic this_) {
  return (this_.width * this_.height);
}

double Rectangle_perimeter(dynamic this_) {
  return (2 * (this_.width + this_.height));
}

String Rectangle_toString(dynamic this_) {
  return this_.vptr.toString_(this_);
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
  return ClosureEnv_StringExtensions_get_capitalize_0(this_);
}

bool StringExtensions_get_isPalindrome(final String this_) {
  final String reversed = this_.split('').reversed.join();
  return (this_ == reversed);
}

List<T> ListExtensions_filterWhere<T>(final List<T> this_, bool Function(T) predicate) {
  return this_.where(predicate).toList();
}

List<T> Function(bool Function(T)) ListExtensions_get_filterWhere<T>(final List<T> this_) {
  return ClosureEnv_ListExtensions_get_filterWhere_1(this_);
}

T identity<T>(T value) {
  return value;
}

List<T> repeat<T>(T item, int count) {
  return <T>[];
}

Function makeAdder(int base) {
  return ClosureEnv_makeAdder_3(base);
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
{
    Iterator<String> sync_for_iterator = urls.iterator;
    for (; sync_for_iterator.moveNext(); ) {
      final String url = sync_for_iterator.current;
{
        final String data = await fetchData(url);
        results.add(data);
      }
    }
  }
  return results;
}

String? findFirst(List<String> items, bool Function(String) predicate) {
{
    Iterator<String> sync_for_iterator = items.iterator;
    for (; sync_for_iterator.moveNext(); ) {
      final String item = sync_for_iterator.current;
{
        if (predicate(item))         return item;
      }
    }
  }
  return null;
}

int safeLength(String? text) {
  return ((text == null ? null : _let1.length) ?? 0);
}

void main() {
  print('=== 复杂语法节点还原测试 ===\n');
  print('--- 1. 泛型类 Pair ---');
  final PairValue<String, int> pair = Pair_new('hello', 42);
  final PairValue<int, String> swapped = pair.vptr.swap(pair);
  print('pair: ${pair}');
  print('swapped: ${swapped}');
  assert((pair.first == 'hello'));
  assert((swapped.first == 42));
  print('\n--- 2. 继承 + 多态 ---');
  final List<ShapeValue> shapes = <ShapeValue>[Circle_new(5.0), Rectangle_new(3.0, 4.0), Circle_new_unit()];
{
    Iterator<ShapeValue> sync_for_iterator = shapes.iterator;
    for (; sync_for_iterator.moveNext(); ) {
      final ShapeValue shape = sync_for_iterator.current;
{
        print('  ${shape}, perimeter=${shape.vptr.perimeter(shape).toStringAsFixed(2)}');
      }
    }
  }
  print('\n--- 3. getter/setter + 异常 ---');
  final CircleValue circle = Circle_new(3.0);
  circle.vptr.set_radius(circle, 5.0);
  print('radius after set: ${circle.vptr.get_radius(circle)}');
  try {
    circle.vptr.set_radius(circle, (-1.0));
    print('ERROR: should have thrown');
  }
 on ArgumentError catch (e) {
    print('Caught expected error: ${e}');
  }
  print('\n--- 4. 枚举 + switch ---');
  final List<Direction> directions = <Direction>[Direction.north, Direction.east, Direction.south];
{
    Iterator<Direction> sync_for_iterator = directions.iterator;
    for (; sync_for_iterator.moveNext(); ) {
      final Direction dir = sync_for_iterator.current;
{
        final String label = (() {         late String _v2;
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
    }
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
  print('identity<int>(99): ${identity(99)}');
  print('repeat("x", 3): ${repeat('x', 3)}');
  print('\n--- 7. 高阶函数 + 闭包 ---');
  final Function add10 = makeAdder(10);
  print('add10(5): ${add10(5)}');
  final List<int> doubled = mapList(<int>[1, 2, 3, 4], (int x) => (x * 2));
  print('doubled: ${doubled}');
  int counter = 0;
  final int Function() increment = ClosureEnv_main_4(counter);
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
  final Set<int> set1 = (() {   final Set<int> _v3 = <dynamic>{};
  _v3.add(1);
  _v3.add(2);
  _v3.add(3);
  _v3.add(4);
 return _v3; })();
  final Set<int> set2 = (() {   final Set<int> _v4 = <dynamic>{};
  _v4.add(3);
  _v4.add(4);
  _v4.add(5);
  _v4.add(6);
 return _v4; })();
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

class ClosureEnv_ListExtensions_get_filterWhere_1 {
  List<T> this_;
  ClosureEnv_ListExtensions_get_filterWhere_1(this.this_);
  List<T> call(bool Function(T) predicate) => ClosureEnv_ListExtensions_get_filterWhere_1_call(this, predicate);
}
List<T> ClosureEnv_ListExtensions_get_filterWhere_1_call(ClosureEnv_ListExtensions_get_filterWhere_1 env, bool Function(T) predicate) {
  return ListExtensions_filterWhere(env.this_, predicate);
}

class ClosureEnv_repeat_2 {
  T item;
  ClosureEnv_repeat_2(this.item);
  T call(int _) => ClosureEnv_repeat_2_call(this, _);
}
T ClosureEnv_repeat_2_call(ClosureEnv_repeat_2 env, int _) {
  return env.item;
}

class ClosureEnv_makeAdder_3 {
  int base;
  ClosureEnv_makeAdder_3(this.base);
  int call(int x) => ClosureEnv_makeAdder_3_call(this, x);
}
int ClosureEnv_makeAdder_3_call(ClosureEnv_makeAdder_3 env, int x) {
  return (env.base + x);
}

class ClosureEnv_main_4 {
  int counter;
  ClosureEnv_main_4(this.counter);
  int call() => ClosureEnv_main_4_call(this);
}
int ClosureEnv_main_4_call(ClosureEnv_main_4 env) {
    env.counter = (env.counter + 1);
    return env.counter;
  }

