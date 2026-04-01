// ============================================================================
// 全面测试用例：覆盖 Dart 所有基础语法节点
// 用于验证 dart_to_dart_restorer.dart 的还原正确性
// ============================================================================

// ---- 1. typedef / 函数类型别名 ----
typedef Predicate<T> = bool Function(T value);
typedef Transformer<A, B> = B Function(A input);
typedef VoidCallback = void Function();

// ---- 2. mixin ----
mixin Printable {
  String get displayName;
  void printInfo() => print('[$displayName]');
}

mixin Orderable<T> {
  int compareTo(T other);
  bool isLessThan(T other) => compareTo(other) < 0;
  bool isGreaterThan(T other) => compareTo(other) > 0;
}

// ---- 3. abstract class + implements + with ----
abstract class Animal {
  final String name;
  final int age;

  const Animal(this.name, this.age);

  String speak();

  @override
  String toString() => '$name(age=$age)';
}

class Dog extends Animal with Printable, Orderable<Dog> {
  final String breed;

  Dog(super.name, super.age, this.breed);

  @override
  String get displayName => 'Dog:$name';

  @override
  String speak() => 'Woof!';

  @override
  int compareTo(Dog other) => age.compareTo(other.age);
}

class Cat extends Animal with Printable {
  late String _mood;

  Cat(super.name, super.age) {
    _mood = 'happy';
  }

  @override
  String get displayName => 'Cat:$name';

  @override
  String speak() => 'Meow!';

  String get mood => _mood;
  set mood(String value) => _mood = value;
}

// ---- 4. operator 重载 ----
class Vector2D {
  final double x;
  final double y;

  const Vector2D(this.x, this.y);

  Vector2D operator +(Vector2D other) => Vector2D(x + other.x, y + other.y);
  Vector2D operator -(Vector2D other) => Vector2D(x - other.x, y - other.y);
  Vector2D operator *(double scalar) => Vector2D(x * scalar, y * scalar);
  bool operator ==(Object other) =>
      other is Vector2D && x == other.x && y == other.y;

  double get length => (x * x + y * y) < 0 ? 0 : _sqrt(x * x + y * y);

  static double _sqrt(double v) {
    // 牛顿迭代法求平方根
    if (v <= 0) return 0;
    double guess = v / 2;
    for (int i = 0; i < 20; i++) {
      guess = (guess + v / guess) / 2;
    }
    return guess;
  }

  @override
  String toString() => 'Vector2D($x, $y)';
}

// ---- 5. static 成员 + 工厂构造函数 ----
class Counter {
  static int _instanceCount = 0;
  static const int maxValue = 100;

  int _value;
  final String label;

  Counter._(this.label, this._value) {
    _instanceCount++;
  }

  factory Counter(String label, {int initialValue = 0}) {
    return Counter._(label, initialValue);
  }

  factory Counter.fromString(String spec) {
    final parts = spec.split(':');
    return Counter._(parts[0], int.parse(parts[1]));
  }

  static int get instanceCount => _instanceCount;

  void increment([int step = 1]) {
    _value = (_value + step).clamp(0, maxValue);
  }

  void decrement([int step = 1]) {
    _value = (_value - step).clamp(0, maxValue);
  }

  int get value => _value;

  @override
  String toString() => '$label: $_value';
}

// ---- 6. 泛型类 + const 构造函数 + 命名参数 ----
class Result<T> {
  final T? data;
  final String? error;
  final bool isSuccess;

  const Result.success(T value)
      : data = value,
        error = null,
        isSuccess = true;

  const Result.failure(String message)
      : data = null,
        error = message,
        isSuccess = false;

  R fold<R>({
    required R Function(T data) onSuccess,
    required R Function(String error) onFailure,
  }) {
    if (isSuccess && data != null) {
      return onSuccess(data as T);
    }
    return onFailure(error ?? 'Unknown error');
  }

  @override
  String toString() =>
      isSuccess ? 'Result.success($data)' : 'Result.failure($error)';
}

// ---- 7. 可选位置参数 + 命名参数 + required ----
String formatMessage(
  String template, [
  String? subject,
  int? count,
]) {
  var result = template;
  if (subject != null) result = result.replaceAll('{subject}', subject);
  if (count != null) result = result.replaceAll('{count}', count.toString());
  return result;
}

String buildQuery({
  required String endpoint,
  Map<String, String>? params,
  int maxWait = 30,
  bool secure = true,
}) {
  final scheme = secure ? 'https' : 'http';
  final query = params?.entries.map((e) => '${e.key}=${e.value}').join('&') ?? '';
  final suffix = query.isEmpty ? '' : '?$query';
  return '$scheme://$endpoint$suffix (timeout=${maxWait}s)';
}

// ---- 8. 生成器函数 sync* / async* ----
Iterable<int> range(int start, int end, [int step = 1]) sync* {
  for (int i = start; i < end; i += step) {
    yield i;
  }
}

Iterable<int> fibonacci(int count) sync* {
  int a = 0, b = 1;
  for (int i = 0; i < count; i++) {
    yield a;
    final next = a + b;
    a = b;
    b = next;
  }
}

Stream<String> countDown(int from) async* {
  for (int i = from; i >= 0; i--) {
    await Future.delayed(Duration(milliseconds: 1));
    yield i == 0 ? 'Go!' : '$i...';
  }
}

// ---- 9. record 类型（Dart 3.0）----
(String name, int age) getPersonRecord() => ('Alice', 30);

(String, double, double) getLocation() =>
    ('Beijing', 39.9, 116.4);

(int, int) divmod(int a, int b) => (a ~/ b, a % b);

// ---- 10. Pattern matching + 解构 ----
String describeValue(Object? value) {
  return switch (value) {
    null => 'null',
    int n when n < 0 => 'negative int: $n',
    int n => 'positive int: $n',
    String s when s.isEmpty => 'empty string',
    String s => 'string: "$s"',
    List<dynamic> list when list.isEmpty => 'empty list',
    List<dynamic> list => 'list of ${list.length}',
    _ => 'unknown: ${value.runtimeType}',
  };
}

// ---- 11. 级联操作符 .. ----
List<int> buildList() {
  return <int>[]
    ..add(1)
    ..add(2)
    ..addAll([3, 4, 5])
    ..sort();
}

StringBuffer buildBuffer() {
  return StringBuffer()
    ..write('Hello')
    ..write(', ')
    ..write('World')
    ..writeln('!');
}

// ---- 12. 展开操作符 ... + 集合 if/for ----
List<int> mergeAndFilter(List<int> a, List<int> b, bool includeNegative) {
  return [
    ...a,
    ...b,
    if (includeNegative) -1,
    for (int i = 10; i <= 12; i++) i,
  ];
}

Map<String, int> buildScoreMap(List<String> names, bool addBonus) {
  return {
    for (int i = 0; i < names.length; i++) names[i]: (i + 1) * 10,
    if (addBonus) 'bonus': 999,
  };
}

// ---- 13. late 变量 ----
class LazyLoader {
  late final String _data;
  late int _computedValue;
  bool _initialized = false;

  void initialize(String data) {
    _data = data;
    _computedValue = data.length * 2;
    _initialized = true;
  }

  String get data => _initialized ? _data : 'not initialized';
  int get computedValue => _initialized ? _computedValue : -1;
}

// ---- 14. rethrow + 多层异常 ----
int parseAndDivide(String a, String b) {
  try {
    final x = int.parse(a);
    final y = int.parse(b);
    if (y == 0) throw ArgumentError('Division by zero');
    return x ~/ y;
  } on FormatException {
    rethrow;
  } on ArgumentError catch (e) {
    throw StateError('Math error: ${e.message}');
  }
}

// ---- 15. assert ----
class BoundedValue {
  final double min;
  final double max;
  double _current;

  BoundedValue(this.min, this.max, double initial)
      : _current = initial {
    assert(min <= max, 'min must be <= max');
    assert(initial >= min && initial <= max, 'initial must be in [min, max]');
  }

  void set(double value) {
    assert(value >= min && value <= max, 'value $value out of bounds [$min, $max]');
    _current = value;
  }

  double get current => _current;
}

// ---- 16. 字符串：多行 / raw string / 插值嵌套 ----
String multiLineExample() {
  final raw = r'raw\nstring\ttabs';
  final multiLine = '''
line1
line2
line3''';
  final nested = 'lines: ${multiLine.split('\n').length}, raw: $raw';
  return nested;
}

// ---- 17. 复杂闭包 + 函数式组合 ----
Transformer<A, C> compose<A, B, C>(
  Transformer<A, B> f,
  Transformer<B, C> g,
) {
  return (A input) => g(f(input));
}

Predicate<T> and<T>(Predicate<T> p1, Predicate<T> p2) {
  return (T value) => p1(value) && p2(value);
}

List<B> flatMap<A, B>(List<A> list, List<B> Function(A) f) {
  return list.expand(f).toList();
}

// ---- 18. 主函数：综合测试 ----
void main() async {
  print('=== 全面语法节点还原测试 ===\n');

  // ---- 测试 1: mixin + implements ----
  print('--- 1. mixin + implements ---');
  final dog1 = Dog('Rex', 3, 'Labrador');
  final dog2 = Dog('Max', 5, 'Poodle');
  dog1.printInfo();
  print('${dog1.speak()} (${dog1.breed})');
  print('dog1 < dog2: ${dog1.isLessThan(dog2)}');
  print('dog1 > dog2: ${dog1.isGreaterThan(dog2)}');

  final cat = Cat('Whiskers', 2);
  cat.printInfo();
  print('${cat.speak()}, mood: ${cat.mood}');
  cat.mood = 'sleepy';
  print('mood after set: ${cat.mood}');

  // ---- 测试 2: operator 重载 ----
  print('\n--- 2. operator 重载 ---');
  const v1 = Vector2D(3.0, 4.0);
  const v2 = Vector2D(1.0, 2.0);
  final sum = v1 + v2;
  final diff = v1 - v2;
  final scaled = v1 * 2.0;
  print('v1 + v2 = $sum');
  print('v1 - v2 = $diff');
  print('v1 * 2 = $scaled');
  print('v1.length = ${v1.length.toStringAsFixed(2)}');
  print('v1 == Vector2D(3,4): ${v1 == const Vector2D(3.0, 4.0)}');

  // ---- 测试 3: static + factory 构造函数 ----
  print('\n--- 3. static + factory ---');
  final c1 = Counter('alpha');
  final c2 = Counter('beta', initialValue: 50);
  final c3 = Counter.fromString('gamma:25');
  c1.increment(10);
  c2.decrement(5);
  c3.increment();
  print('$c1, $c2, $c3');
  print('instances: ${Counter.instanceCount}');
  print('maxValue: ${Counter.maxValue}');

  // ---- 测试 4: 泛型 Result + 命名参数 required ----
  print('\n--- 4. Result<T> + named params ---');
  const ok = Result<int>.success(42);
  const err = Result<int>.failure('not found');
  print('ok: $ok');
  print('err: $err');
  final okMsg = ok.fold(
    onSuccess: (d) => 'got $d',
    onFailure: (e) => 'error: $e',
  );
  final errMsg = err.fold(
    onSuccess: (d) => 'got $d',
    onFailure: (e) => 'error: $e',
  );
  print('okMsg: $okMsg');
  print('errMsg: $errMsg');

  // ---- 测试 5: 可选位置参数 + 命名参数 ----
  print('\n--- 5. 可选参数 ---');
  print(formatMessage('Hello {subject}!', 'Dart'));
  print(formatMessage('Count: {count}', null, 99));
  print(formatMessage('No params'));
  print(buildQuery(endpoint: 'api.example.com/users'));
  print(buildQuery(
    endpoint: 'api.example.com/search',
    params: {'q': 'dart', 'page': '1'},
    maxWait: 10,
    secure: false,
  ));

  // ---- 测试 6: sync* 生成器 ----
  print('\n--- 6. sync* 生成器 ---');
  final r = range(0, 10, 2).toList();
  print('range(0,10,2): $r');
  final fib = fibonacci(8).toList();
  print('fibonacci(8): $fib');

  // ---- 测试 7: async* 生成器 ----
  print('\n--- 7. async* 生成器 ---');
  final countdown = await countDown(3).toList();
  print('countdown: $countdown');

  // ---- 测试 8: record 类型 ----
  print('\n--- 8. record 类型 ---');
  final person = getPersonRecord();
  print('person: ${person.$1}, age=${person.$2}');
  final loc = getLocation();
  print('location: ${loc.$1} (${loc.$2}, ${loc.$3})');
  final (q, r2) = divmod(17, 5);
  print('divmod(17,5): quotient=$q, remainder=$r2');

  // ---- 测试 9: pattern matching ----
  print('\n--- 9. pattern matching ---');
  final values = <Object?>[null, -5, 42, '', 'hello', <int>[], [1, 2, 3]];
  for (final v in values) {
    print('  ${describeValue(v)}');
  }

  // ---- 测试 10: 级联操作符 ----
  print('\n--- 10. 级联操作符 ---');
  final list = buildList();
  print('buildList: $list');
  final buf = buildBuffer();
  print('buildBuffer: ${buf.toString().trim()}');

  // ---- 测试 11: 展开 + 集合 if/for ----
  print('\n--- 11. 展开 + 集合 if/for ---');
  final merged = mergeAndFilter([1, 2], [3, 4], true);
  print('merged(includeNeg=true): $merged');
  final mergedNoNeg = mergeAndFilter([1, 2], [3, 4], false);
  print('merged(includeNeg=false): $mergedNoNeg');
  final scores = buildScoreMap(['Alice', 'Bob', 'Carol'], true);
  print('scores: $scores');

  // ---- 测试 12: late 变量 ----
  print('\n--- 12. late 变量 ---');
  final loader = LazyLoader();
  print('before init: ${loader.data}, ${loader.computedValue}');
  loader.initialize('hello');
  print('after init: ${loader.data}, ${loader.computedValue}');

  // ---- 测试 13: rethrow ----
  print('\n--- 13. rethrow ---');
  try {
    parseAndDivide('10', '2');
    print('10/2 = ${parseAndDivide("10", "2")}');
  } catch (e) {
    print('unexpected: $e');
  }
  try {
    parseAndDivide('10', '0');
  } on StateError catch (e) {
    print('StateError: ${e.message}');
  }
  try {
    parseAndDivide('abc', '2');
  } on FormatException catch (e) {
    print('FormatException: ${e.message}');
  }

  // ---- 测试 14: assert ----
  print('\n--- 14. assert ---');
  final bv = BoundedValue(0.0, 10.0, 5.0);
  bv.set(7.5);
  print('BoundedValue: ${bv.current}');

  // ---- 测试 15: 多行字符串 + raw string ----
  print('\n--- 15. 字符串 ---');
  print(multiLineExample());

  // ---- 测试 16: typedef + 函数式组合 ----
  print('\n--- 16. typedef + 函数式组合 ---');
  final doubleIt = compose<int, int, String>(
    (int x) => x * 2,
    (int x) => 'result=$x',
  );
  print('compose(5): ${doubleIt(5)}');

  final isPositive = (int n) => n > 0;
  final isEven = (int n) => n % 2 == 0;
  final isPositiveEven = and<int>(isPositive, isEven);
  final nums = [-2, -1, 0, 1, 2, 3, 4];
  print('positiveEvens: ${nums.where(isPositiveEven).toList()}');

  final nested = flatMap<int, int>([1, 2, 3], (x) => [x, x * x]);
  print('flatMap: $nested');

  print('\n=== 所有测试通过 ✅ ===');
}
