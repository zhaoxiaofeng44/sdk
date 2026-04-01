typedef Predicate<T> = bool Function(T);

typedef Transformer<A, B> = B Function(A);

typedef VoidCallback = void Function();

mixin Printable {
  String get displayName;

  void printInfo() {
    return print('[${this.displayName}]');
  }

}

mixin Orderable<T> {
  int compareTo(covariant T other);

  bool isLessThan(T other) {
    return (this.compareTo(other) < 0);
  }

  bool isGreaterThan(T other) {
    return (this.compareTo(other) > 0);
  }

}

abstract class Animal {
  final String name;
  final int age;
  const Animal(String name, int age) : name = name, age = age, super();

  String speak();

  String toString() {
    return '${this.name}(age=${this.age})';
  }

}

class Dog extends Animal with Printable, Orderable {
  final String breed;
  Dog(String name, int age, String breed) : breed = breed, super(name, age);

  String get displayName {
    return 'Dog:${this.name}';
  }

  String speak() {
    return 'Woof!';
  }

  int compareTo(covariant Dog other) {
    return this.age.compareTo(other.age);
  }

}

class Cat extends Animal with Printable {
  late String _mood;
  Cat(String name, int age) : super(name, age) {
    this._mood = 'happy';
  }

  String get displayName {
    return 'Cat:${this.name}';
  }

  String speak() {
    return 'Meow!';
  }

  String get mood {
    return this._mood;
  }

  set mood(String value) {
    this._mood = value;
  }

}

class Vector2D {
  final double x;
  final double y;
  const Vector2D(double x, double y) : x = x, y = y, super();

  Vector2D operator +(Vector2D other) {
    return Vector2D((this.x + other.x), (this.y + other.y));
  }

  Vector2D operator -(Vector2D other) {
    return Vector2D((this.x - other.x), (this.y - other.y));
  }

  Vector2D operator *(double scalar) {
    return Vector2D((this.x * scalar), (this.y * scalar));
  }

  bool operator ==(Object other) {
    return (((other is Vector2D) && (this.x == other.x)) && (this.y == other.y));
  }

  double get length {
    return ((((this.x * this.x) + (this.y * this.y)) < 0) ? 0.0 : Vector2D._sqrt(((this.x * this.x) + (this.y * this.y))));
  }

  static double _sqrt(double v) {
    if ((v <= 0))     return 0.0;
    double guess = (v / 2);
    for (var i = 0; (i < 20); i = (i + 1)) {
      guess = ((guess + (v / guess)) / 2);
    }
    return guess;
  }

  String toString() {
    return 'Vector2D(${this.x}, ${this.y})';
  }

}

class Counter {
  static int _instanceCount = 0;
  static const int maxValue = 100;
  int _value;
  final String label;
  Counter._(String label, int _value) : label = label, _value = _value, super() {
    Counter._instanceCount = (Counter._instanceCount + 1);
  }

  factory Counter(String label, {int initialValue = 0}) {
    return Counter._(label, initialValue);
  }

  factory Counter.fromString(String spec) {
    final List<String> parts = spec.split(':');
    return Counter._(parts[0], int.parse(parts[1]));
  }

  static int get instanceCount {
    return Counter._instanceCount;
  }

  void increment([int step = 1]) {
    this._value = (this._value + step).clamp(0, 100);
  }

  void decrement([int step = 1]) {
    this._value = (this._value - step).clamp(0, 100);
  }

  int get value {
    return this._value;
  }

  String toString() {
    return '${this.label}: ${this._value}';
  }

}

class Result<T> {
  final T? data;
  final String? error;
  final bool isSuccess;
  const Result.success(T value) : data = value, error = null, isSuccess = true, super();

  const Result.failure(String message) : data = null, error = message, isSuccess = false, super();

  R fold<R>({required R Function(T) onSuccess, required R Function(String) onFailure}) {
    if ((this.isSuccess && !((this.data == null)))) {
      return onSuccess((() { final _let0 = this.data; return ((_let0 == null) ? (_let0 as T) : _let0); })());
    }
    return onFailure((() { final _let1 = this.error; return ((_let1 == null) ? 'Unknown error' : _let1); })());
  }

  String toString() {
    return (this.isSuccess ? 'Result.success(${this.data})' : 'Result.failure(${this.error})');
  }

}

class LazyLoader {
  late final String _data;
  late int _computedValue;
  bool _initialized = false;
  LazyLoader() : super();

  void initialize(String data) {
    this._data = data;
    this._computedValue = (data.length * 2);
    this._initialized = true;
  }

  String get data {
    return (this._initialized ? this._data : 'not initialized');
  }

  int get computedValue {
    return (this._initialized ? this._computedValue : (-1));
  }

}

class BoundedValue {
  final double min;
  final double max;
  double _current;
  BoundedValue(double min, double max, double initial) : min = min, max = max, _current = initial, super() {
    assert((this.min <= this.max), 'min must be <= max');
    assert(((initial >= this.min) && (initial <= this.max)), 'initial must be in [min, max]');
  }

  void set(double value) {
    assert(((value >= this.min) && (value <= this.max)), 'value ${value} out of bounds [${this.min}, ${this.max}]');
    this._current = value;
  }

  double get current {
    return this._current;
  }

}

String formatMessage(String template, [String? subject = null, int? count = null]) {
  String result = template;
  if (!((subject == null)))   result = result.replaceAll('{subject}', subject);
  if (!((count == null)))   result = result.replaceAll('{count}', count.toString());
  return result;
}

String buildQuery({required String endpoint, Map<String, String>? params = null, int maxWait = 30, bool secure = true}) {
  final String scheme = (secure ? 'https' : 'http');
  final String query = (() { final _let2 = (() { final _let3 = params; return ((_let3 == null) ? null : _let3.entries.map((MapEntry<String, String> e) => '${e.key}=${e.value}').join('&')); })(); return ((_let2 == null) ? '' : _let2); })();
  final String suffix = (query.isEmpty ? '' : '?${query}');
  return '${scheme}://${endpoint}${suffix} (timeout=${maxWait}s)';
}

Iterable<int> range(int start, int end, [int step = 1]) sync* {
  for (var i = start; (i < end); i = (i + step)) {
    yield i;
  }
}

Iterable<int> fibonacci(int count) sync* {
  int a = 0;
  int b = 1;
  for (var i = 0; (i < count); i = (i + 1)) {
    yield a;
    final int next = (a + b);
    a = b;
    b = next;
  }
}

Stream<String> countDown(int from) async* {
  for (var i = from; (i >= 0); i = (i - 1)) {
    await Future.delayed(Duration());
    yield ((i == 0) ? 'Go!' : '${i}...');
  }
}

(String, int) getPersonRecord() {
  return ('Alice', 30);
}

(String, double, double) getLocation() {
  return ('Beijing', 39.9, 116.4);
}

(int, int) divmod(int a, int b) {
  return ((a ~/ b), (a % b));
}

String describeValue(Object? value) {
  return (() {   late String _v4;
  final Object? _v5 = value;
  do {
{
{
        if ((_v5 == null)) {
          _v4 = 'null';
          break;
        }
      }
{
        late int n;
        if ((((_v5 is int) && (() { final _let6 = n = _v5; return true; })()) && (n < 0))) {
          _v4 = 'negative int: ${n}';
          break;
        }
      }
{
        late int n;
        if ((_v5 is int)) {
          n = _v5;
          _v4 = 'positive int: ${n}';
          break;
        }
      }
{
        late String s;
        if ((((_v5 is String) && (() { final _let7 = s = _v5; return true; })()) && s.isEmpty)) {
          _v4 = 'empty string';
          break;
        }
      }
{
        late String s;
        if ((_v5 is String)) {
          s = _v5;
          _v4 = 'string: "${s}"';
          break;
        }
      }
{
        late List<dynamic> list;
        if ((((_v5 is List<dynamic>) && (() { final _let8 = list = _v5; return true; })()) && list.isEmpty)) {
          _v4 = 'empty list';
          break;
        }
      }
{
        late List<dynamic> list;
        if ((_v5 is List<dynamic>)) {
          list = _v5;
          _v4 = 'list of ${list.length}';
          break;
        }
      }
{
        if (true) {
          _v4 = 'unknown: ${value.runtimeType}';
          break;
        }
      }
    }
  } while (false);
 return _v4; })();
}

List<int> buildList() {
  return (() { final _let9 = <int>[]; return (() {   _let9.add(1);
  _let9.add(2);
  _let9.addAll(<int>[3, 4, 5]);
  _let9.sort();
 return _let9; })(); })();
}

StringBuffer buildBuffer() {
  return (() { final _let10 = StringBuffer(); return (() {   _let10.write('Hello');
  _let10.write(', ');
  _let10.write('World');
  _let10.writeln('!');
 return _let10; })(); })();
}

List<int> mergeAndFilter(List<int> a, List<int> b, bool includeNegative) {
  return (() {   final List<int> _v11 = List.of(a);
  _v11.addAll(b);
  if (includeNegative)   _v11.add((-1));
  for (var i = 10; (i <= 12); i = (i + 1))   _v11.add(i);
 return _v11; })();
}

Map<String, int> buildScoreMap(List<String> names, bool addBonus) {
  return (() {   final Map<String, int> _v12 = <String, int>{};
  for (var i = 0; (i < names.length); i = (i + 1))   _v12[names[i]] = ((i + 1) * 10);
  if (addBonus)   _v12['bonus'] = 999;
 return _v12; })();
}

int parseAndDivide(String a, String b) {
  try {
    final int x = int.parse(a);
    final int y = int.parse(b);
    if ((y == 0))     throw ArgumentError('Division by zero');
    return (x ~/ y);
  }
 on FormatException {
    rethrow;
  }
 on ArgumentError catch (e) {
    throw StateError('Math error: ${e.message}');
  }
}

String multiLineExample() {
  final String raw = 'raw\\nstring\\ttabs';
  final String multiLine = 'line1\nline2\nline3';
  final String nested = 'lines: ${multiLine.split('\n').length}, raw: ${raw}';
  return nested;
}

C Function(A) compose<A, B, C>(B Function(A) f, C Function(B) g) {
  return (A input) => g(f(input));
}

bool Function(T) and<T>(bool Function(T) p1, bool Function(T) p2) {
  return (T value) => (p1(value) && p2(value));
}

List<B> flatMap<A, B>(List<A> list, List<B> Function(A) f) {
  return list.expand(f).toList();
}

void main() async {
  print('=== 全面语法节点还原测试 ===\n');
  print('--- 1. mixin + implements ---');
  final Dog dog1 = Dog('Rex', 3, 'Labrador');
  final Dog dog2 = Dog('Max', 5, 'Poodle');
  dog1.printInfo();
  print('${dog1.speak()} (${dog1.breed})');
  print('dog1 < dog2: ${dog1.isLessThan(dog2)}');
  print('dog1 > dog2: ${dog1.isGreaterThan(dog2)}');
  final Cat cat = Cat('Whiskers', 2);
  cat.printInfo();
  print('${cat.speak()}, mood: ${cat.mood}');
  cat.mood = 'sleepy';
  print('mood after set: ${cat.mood}');
  print('\n--- 2. operator 重载 ---');
  final Vector2D sum = (const Vector2D(3.0, 4.0) + const Vector2D(1.0, 2.0));
  final Vector2D diff = (const Vector2D(3.0, 4.0) - const Vector2D(1.0, 2.0));
  final Vector2D scaled = (const Vector2D(3.0, 4.0) * 2.0);
  print('v1 + v2 = ${sum}');
  print('v1 - v2 = ${diff}');
  print('v1 * 2 = ${scaled}');
  print('v1.length = ${const Vector2D(3.0, 4.0).length.toStringAsFixed(2)}');
  print('v1 == Vector2D(3,4): ${(const Vector2D(3.0, 4.0) == const Vector2D(3.0, 4.0))}');
  print('\n--- 3. static + factory ---');
  final Counter c1 = Counter('alpha');
  final Counter c2 = Counter('beta', initialValue: 50);
  final Counter c3 = Counter.fromString('gamma:25');
  c1.increment(10);
  c2.decrement(5);
  c3.increment();
  print('${c1}, ${c2}, ${c3}');
  print('instances: ${Counter.instanceCount}');
  print('maxValue: 100');
  print('\n--- 4. Result<T> + named params ---');
  print('ok: ${const Result<int>.success(42)}');
  print('err: ${const Result<int>.failure('not found')}');
  final String okMsg = const Result<int>.success(42).fold(onSuccess: (int d) => 'got ${d}', onFailure: (String e) => 'error: ${e}');
  final String errMsg = const Result<int>.failure('not found').fold(onSuccess: (int d) => 'got ${d}', onFailure: (String e) => 'error: ${e}');
  print('okMsg: ${okMsg}');
  print('errMsg: ${errMsg}');
  print('\n--- 5. 可选参数 ---');
  print(formatMessage('Hello {subject}!', 'Dart'));
  print(formatMessage('Count: {count}', null, 99));
  print(formatMessage('No params'));
  print(buildQuery(endpoint: 'api.example.com/users'));
  print(buildQuery(endpoint: 'api.example.com/search', params: <String, String>{'q': 'dart', 'page': '1'}, maxWait: 10, secure: false));
  print('\n--- 6. sync* 生成器 ---');
  final List<int> r = range(0, 10, 2).toList();
  print('range(0,10,2): ${r}');
  final List<int> fib = fibonacci(8).toList();
  print('fibonacci(8): ${fib}');
  print('\n--- 7. async* 生成器 ---');
  final List<String> countdown = await countDown(3).toList();
  print('countdown: ${countdown}');
  print('\n--- 8. record 类型 ---');
  final (String, int) person = getPersonRecord();
  print('person: ${person.$1}, age=${person.$2}');
  final (String, double, double) loc = getLocation();
  print('location: ${loc.$1} (${loc.$2}, ${loc.$3})');
  final int q;
  final int r2;
{
    final (int, int) _v5 = divmod(17, 5);
    q = _v5.$1;
    r2 = _v5.$2;
  }
  print('divmod(17,5): quotient=${q}, remainder=${r2}');
  print('\n--- 9. pattern matching ---');
  final List<Object?> values = <Object?>[null, (-5), 42, '', 'hello', <int>[], <int>[1, 2, 3]];
{
    Iterator<Object?> sync_for_iterator = values.iterator;
    for (; sync_for_iterator.moveNext(); ) {
      final Object? v = sync_for_iterator.current;
{
        print('  ${describeValue(v)}');
      }
    }
  }
  print('\n--- 10. 级联操作符 ---');
  final List<int> list = buildList();
  print('buildList: ${list}');
  final StringBuffer buf = buildBuffer();
  print('buildBuffer: ${buf.toString().trim()}');
  print('\n--- 11. 展开 + 集合 if/for ---');
  final List<int> merged = mergeAndFilter(<int>[1, 2], <int>[3, 4], true);
  print('merged(includeNeg=true): ${merged}');
  final List<int> mergedNoNeg = mergeAndFilter(<int>[1, 2], <int>[3, 4], false);
  print('merged(includeNeg=false): ${mergedNoNeg}');
  final Map<String, int> scores = buildScoreMap(<String>['Alice', 'Bob', 'Carol'], true);
  print('scores: ${scores}');
  print('\n--- 12. late 变量 ---');
  final LazyLoader loader = LazyLoader();
  print('before init: ${loader.data}, ${loader.computedValue}');
  loader.initialize('hello');
  print('after init: ${loader.data}, ${loader.computedValue}');
  print('\n--- 13. rethrow ---');
  try {
    parseAndDivide('10', '2');
    print('10/2 = ${parseAndDivide('10', '2')}');
  }
 catch (e) {
    print('unexpected: ${e}');
  }
  try {
    parseAndDivide('10', '0');
  }
 on StateError catch (e) {
    print('StateError: ${e.message}');
  }
  try {
    parseAndDivide('abc', '2');
  }
 on FormatException catch (e) {
    print('FormatException: ${e.message}');
  }
  print('\n--- 14. assert ---');
  final BoundedValue bv = BoundedValue(0.0, 10.0, 5.0);
  bv.set(7.5);
  print('BoundedValue: ${bv.current}');
  print('\n--- 15. 字符串 ---');
  print(multiLineExample());
  print('\n--- 16. typedef + 函数式组合 ---');
  final String Function(int) doubleIt = compose((int x) => (x * 2), (int x) => 'result=${x}');
  print('compose(5): ${doubleIt(5)}');
  final bool Function(int) isPositive = (int n) => (n > 0);
  final bool Function(int) isEven = (int n) => ((n % 2) == 0);
  final bool Function(int) isPositiveEven = and(isPositive, isEven);
  final List<int> nums = <int>[(-2), (-1), 0, 1, 2, 3, 4];
  print('positiveEvens: ${nums.where(isPositiveEven).toList()}');
  final List<int> nested = flatMap(<int>[1, 2, 3], (int x) => <int>[x, (x * x)]);
  print('flatMap: ${nested}');
  print('\n=== 所有测试通过 ✅ ===');
}

