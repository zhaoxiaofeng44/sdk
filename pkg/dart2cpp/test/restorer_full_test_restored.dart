typedef Predicate<T> = bool Function(T);

typedef Transformer<A, B> = B Function(A);

typedef VoidCallback = void Function();

mixin Printable {
  String get displayName;

  void printInfo() {
    print('[${this.displayName}]');
  }

}

mixin Orderable<T> {
  int compareTo(T other);

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

class Dog extends Animal with Printable, Orderable<Dog> {
  final String breed;
  Dog(String name, int age, String breed) : breed = breed, super(name, age);

  String get displayName {
    return 'Dog:${this.name}';
  }

  String speak() {
    return 'Woof!';
  }

  int compareTo(Dog other) {
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

class Shape {
  final String color;
  final double opacity;
  Shape(String color, {double opacity = 1.0}) : color = color, opacity = opacity, super();

  Shape.transparent(String color) : this(color, opacity: 0.5);

  String describe() {
    return 'Shape(color=${this.color}, opacity=${this.opacity})';
  }

}

class Polygon extends Shape {
  final int sides;
  Polygon(String color, int sides, {double opacity = 1.0}) : sides = sides, super(color, opacity: opacity);

  String describe() {
    return 'Polygon(sides=${this.sides}, ${super.describe()})';
  }

  double perimeter(double sideLength) {
    return (this.sides * sideLength);
  }

}

class RegularPolygon extends Polygon {
  final double sideLength;
  RegularPolygon(String color, int sides, double sideLength, {double opacity = 1.0}) : sideLength = sideLength, super(color, sides, opacity: opacity);

  String describe() {
    return 'RegularPolygon(sideLen=${this.sideLength}, ${super.describe()})';
  }

  double perimeter([double? overrideSideLength = null]) {
    return (this.sides * (() { final _let2 = overrideSideLength; return ((_let2 == null) ? this.sideLength : _let2); })());
  }

  double area() {
    return (((this.sides * this.sideLength) * this.sideLength) / 4.0);
  }

}

class Square extends RegularPolygon {
  Square(String color, double size, {double opacity = 1.0}) : super(color, 4, size, opacity: opacity);

  String describe() {
    return 'Square(size=${this.sideLength}, color=${this.color})';
  }

}

abstract class Serializable {
  Serializable() : super();

  String serialize();

}

abstract class Cloneable<T> {
  Cloneable() : super();

  T clone();

}

abstract class Comparable2<T> {
  Comparable2() : super();

  int compareTo2(T other);

}

class DataPoint implements Serializable, Cloneable<DataPoint>, Comparable2<DataPoint> {
  final double x;
  final double y;
  final String label;
  DataPoint(double x, double y, String label) : x = x, y = y, label = label, super();

  String serialize() {
    return '{"x":${this.x},"y":${this.y},"label":"${this.label}"}';
  }

  DataPoint clone() {
    return DataPoint(this.x, this.y, this.label);
  }

  int compareTo2(DataPoint other) {
    final double dx = (this.x - other.x);
    if (!((dx == 0)))     return ((dx > 0) ? 1 : (-1));
    final double dy = (this.y - other.y);
    if (!((dy == 0)))     return ((dy > 0) ? 1 : (-1));
    return 0;
  }

  String toString() {
    return 'DataPoint(${this.x}, ${this.y}, "${this.label}")';
  }

}

mixin Loggable {
  String get logTag;

  void log(String message) {
    print('[${this.logTag}] ${message}');
  }

}

mixin Validatable on Serializable {
  bool validate() {
    return this.serialize().isNotEmpty;
  }

}

class LoggedDataPoint extends DataPoint with Loggable, Validatable {
  LoggedDataPoint(double x, double y, String label) : super(x, y, label);

  String get logTag {
    return 'DataPoint';
  }

}

enum Priority {
  low(1, 'Low'),
  medium(5, 'Medium'),
  high(10, 'High'),
  critical(100, 'Critical');

  final int level;
  final String displayName;

  const Priority(this.level, this.displayName);

  bool isHigherThan(Priority other) {
    return (this.level > other.level);
  }

  String toString() {
    return '${this.displayName}(level=${this.level})';
  }

}

enum HttpMethod {
  get('GET'),
  post('POST'),
  put('PUT'),
  delete('DELETE');

  final String value;

  const HttpMethod(this.value);

  bool get isReadOnly {
    return (this == HttpMethod.get);
  }

}

class Config {
  final String host;
  final int port;
  final bool secure;
  final String baseUrl;
  Config(String host, int port, {bool secure = false}) : host = host, port = port, secure = secure, baseUrl = '${(secure ? 'https' : 'http')}://${host}:${port}', super();

  Config.localhost({int port = 8080}) : this('localhost', port);

  Config.production(String host) : this(host, 443, secure: true);

  String toString() {
    return 'Config(${this.baseUrl})';
  }

}

class SortedList<T extends Comparable<dynamic>> {
  final List<T> _items = <T>[];
  SortedList() : super();

  void add(T item) {
    this._items.add(item);
    this._items.sort();
  }

  T get first {
    return this._items.first;
  }

  T get last {
    return this._items.last;
  }

  int get length {
    return this._items.length;
  }

  List<T> toList() {
    return List.unmodifiable(this._items);
  }

  String toString() {
    return 'SortedList(${this._items})';
  }

}

class NullSafetyDemo {
  String? nullableField;
  final String nonNullField;
  NullSafetyDemo(String nonNullField, [String? nullableField = null]) : nonNullField = nonNullField, nullableField = nullableField, super();

  String demonstrate() {
    final int? len = (() { final _let3 = this.nullableField; return ((_let3 == null) ? null : _let3.length); })();
    final int safeLen = (() { final _let4 = len; return ((_let4 == null) ? (-1) : _let4); })();
    ((this.nullableField == null) ? this.nullableField = 'default' : null);
    final String forced = this.nullableField!.toUpperCase();
    return 'len=${safeLen}, forced=${forced}';
  }

}

abstract class Renderer {
  Renderer() : super();

  void render(covariant Object shape);

  String get name;

}

class CircleRenderer extends Renderer {
  CircleRenderer() : super();

  void render(covariant String shape) {
    print('  CircleRenderer: drawing ${shape}');
  }

  String get name {
    return 'CircleRenderer';
  }

}

class Pipeline<TInput, TOutput> {
  final TOutput Function(TInput) _transform;
  Pipeline(TOutput Function(TInput) _transform) : _transform = _transform, super();

  TOutput execute(TInput input) {
    return (() { final _let5 = input; return this._transform(_let5); })();
  }

  Pipeline<TInput, TNewOutput> then<TNewOutput>(TNewOutput Function(TOutput) next) {
    return Pipeline((TInput input) => next((() { final _let6 = input; return this._transform(_let6); })()));
  }

}

class BitFlags {
  static const int read = 1;
  static const int write = 2;
  static const int execute = 4;
  int _flags;
  BitFlags([int _flags = 0]) : _flags = _flags, super();

  void set(int flag) {
    this._flags = (this._flags | flag);
  }

  void clear(int flag) {
    this._flags = (this._flags & (~flag));
  }

  bool has(int flag) {
    return !(((this._flags & flag) == 0));
  }

  String toString() {
    final List<String> parts = <String>[];
    if (this.has(1))     parts.add('r');
    if (this.has(2))     parts.add('w');
    if (this.has(4))     parts.add('x');
    return (parts.isEmpty ? '-' : parts.join(''));
  }

}

mixin Timestamped {
  int get timestamp {
    return 1234567890;
  }

  String get timeStr {
    return 'T:${this.timestamp}';
  }

}

mixin Tagged {
  final List<String> _tags = <String>[];
  void addTag(String tag) {
    this._tags.add(tag);
  }

  List<String> get tags {
    return List.unmodifiable(this._tags);
  }

}

class Event with Timestamped, Tagged {
  final String name;
  Event(String name) : name = name, super();

  String toString() {
    return 'Event(${this.name}, ${this.timeStr}, tags=${this.tags})';
  }

}

class ImportantEvent extends Event with Loggable {
  final Priority priority;
  ImportantEvent(String name, Priority priority) : priority = priority, super(name);

  String get logTag {
    return 'ImportantEvent';
  }

  String toString() {
    return 'ImportantEvent(${this.name}, ${this.priority}, ${this.timeStr})';
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
  final String query = (() { final _let7 = (() { final _let8 = params; return ((_let8 == null) ? null : _let8.entries.map((MapEntry<String, String> e) => '${e.key}=${e.value}').join('&')); })(); return ((_let7 == null) ? '' : _let7); })();
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
    await Future.delayed(Duration(milliseconds: 1));
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
  return (() {   late String _v9;
  final Object? _v10 = value;
  do {
{
{
        if ((_v10 == null)) {
          _v9 = 'null';
          break;
        }
      }
{
        late int n;
        if ((((_v10 is int) && (() { final _let11 = n = _v10; return true; })()) && (n < 0))) {
          _v9 = 'negative int: ${n}';
          break;
        }
      }
{
        late int n;
        if ((_v10 is int)) {
          n = _v10;
          _v9 = 'positive int: ${n}';
          break;
        }
      }
{
        late String s;
        if ((((_v10 is String) && (() { final _let12 = s = _v10; return true; })()) && s.isEmpty)) {
          _v9 = 'empty string';
          break;
        }
      }
{
        late String s;
        if ((_v10 is String)) {
          s = _v10;
          _v9 = 'string: "${s}"';
          break;
        }
      }
{
        late List<dynamic> list;
        if ((((_v10 is List<dynamic>) && (() { final _let13 = list = _v10; return true; })()) && list.isEmpty)) {
          _v9 = 'empty list';
          break;
        }
      }
{
        late List<dynamic> list;
        if ((_v10 is List<dynamic>)) {
          list = _v10;
          _v9 = 'list of ${list.length}';
          break;
        }
      }
{
        if (true) {
          _v9 = 'unknown: ${value.runtimeType}';
          break;
        }
      }
    }
  } while (false);
 return _v9; })();
}

List<int> buildList() {
  return (() { final _let14 = <int>[]; return (() {   _let14.add(1);
  _let14.add(2);
  _let14.addAll(<int>[3, 4, 5]);
  _let14.sort();
 return _let14; })(); })();
}

StringBuffer buildBuffer() {
  return (() { final _let15 = StringBuffer(); return (() {   _let15.write('Hello');
  _let15.write(', ');
  _let15.write('World');
  _let15.writeln('!');
 return _let15; })(); })();
}

List<int> mergeAndFilter(List<int> a, List<int> b, bool includeNegative) {
  return (() {   final List<int> _v16 = List.of(a);
  _v16.addAll(b);
  if (includeNegative)   _v16.add((-1));
  for (var i = 10; (i <= 12); i = (i + 1))   _v16.add(i);
 return _v16; })();
}

Map<String, int> buildScoreMap(List<String> names, bool addBonus) {
  return (() {   final Map<String, int> _v17 = <String, int>{};
  for (var i = 0; (i < names.length); i = (i + 1))   _v17[names[i]] = ((i + 1) * 10);
  if (addBonus)   _v17['bonus'] = 999;
 return _v17; })();
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

T findMax<T extends Comparable<dynamic>>(List<T> items) {
  T maxItem = items.first;
{
    Iterator<T> sync_for_iterator = items.iterator;
    for (; sync_for_iterator.moveNext(); ) {
      final T item = sync_for_iterator.current;
{
        if ((item.compareTo(maxItem) > 0)) {
          maxItem = item;
        }
      }
    }
  }
  return maxItem;
}

R applyTwice<T, R>(T value, R Function(T) fn1, R Function(R) fn2) {
  return fn2(fn1(value));
}

String? findFirst(List<String> items, bool Function(String) test) {
{
    Iterator<String> sync_for_iterator = items.iterator;
    for (; sync_for_iterator.moveNext(); ) {
      final String item = sync_for_iterator.current;
{
        if (test(item))         return item;
      }
    }
  }
  return null;
}

List<int> filterWithForIn(List<int> items) {
  final List<int> result = <int>[];
{
    Iterator<int> sync_for_iterator = items.iterator;
    for (; sync_for_iterator.moveNext(); ) {
      final int item = sync_for_iterator.current;
{
        if (((item >= 0) && (item <= 100))) {
          result.add(item);
        }
      }
    }
  }
  return result;
}

int collatzSteps(int n) {
  int steps = 0;
  do {
    do {
      if ((n == 1))       break;
      if (((n % 2) == 0)) {
        n = (n ~/ 2);
      }
 else {
        n = ((3 * n) + 1);
      }
      steps = (steps + 1);
    }
 while (!((n == 1)));
  } while (false);
  return steps;
}

String typeTest(Object value) {
  if ((value is int)) {
    return 'int: ${(value * 2)}';
  }
 else   if ((value is String)) {
    return 'string: ${value.toUpperCase()}';
  }
 else   if ((value is List<int>)) {
    return 'list<int>: ${value.length} items';
  }
 else   if ((value is bool)) {
    return 'bool: ${value}';
  }
  return 'other: ${value.runtimeType}';
}

double safeCast(Object value) {
  try {
    return (value as double);
  }
 catch (e) {
    return 0.0;
  }
}

String tryCatchFinally(int code) {
  final StringBuffer log = StringBuffer();
  try {
    log.write('try ');
    if ((code == 1))     throw FormatException('bad format');
    if ((code == 2))     throw ArgumentError('bad arg');
    log.write('ok ');
  }
 on FormatException catch (e) {
    log.write('format:${e.message} ');
  }
 on ArgumentError catch (e) {
    log.write('arg:${e.message} ');
  }
 catch (e) {
    log.write('other:${e} ');
  }
 finally {
    log.write('finally');
  }
  return log.toString();
}

String dayType(int day) {
  do {
    switch (day) {
      case 1:
      case 7:
{
          return 'weekend';
        }
      case 2:
      case 3:
      case 4:
      case 5:
      case 6:
{
          return 'weekday';
        }
      default:
{
          return 'invalid';
        }
    }
  } while (false);
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
    final (int, int) _v10 = divmod(17, 5);
    q = _v10.$1;
    r2 = _v10.$2;
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
  print('\n--- 19. 多层继承链 ---');
  final Shape shape = Shape('red');
  print(shape.describe());
  final Shape transparentShape = Shape.transparent('blue');
  print(transparentShape.describe());
  final Polygon polygon = Polygon('green', 6, opacity: 0.8);
  print(polygon.describe());
  print('perimeter: ${polygon.perimeter(3.0)}');
  final RegularPolygon hexagon = RegularPolygon('yellow', 6, 5.0);
  print(hexagon.describe());
  print('perimeter: ${hexagon.perimeter()}');
  print('area: ${hexagon.area()}');
  final Square square = Square('white', 10.0, opacity: 0.9);
  print(square.describe());
  print('square perimeter: ${square.perimeter()}');
  print('\n--- 20. implements 多接口 ---');
  final DataPoint dp1 = DataPoint(1.0, 2.0, 'A');
  final DataPoint dp2 = DataPoint(3.0, 1.0, 'B');
  print('dp1: ${dp1}');
  print('dp1.serialize: ${dp1.serialize()}');
  final DataPoint dp1Clone = dp1.clone();
  print('dp1.clone: ${dp1Clone}');
  print('dp1.compareTo2(dp2): ${dp1.compareTo2(dp2)}');
  print('\n--- 21. mixin on 约束 ---');
  final LoggedDataPoint ldp = LoggedDataPoint(5.0, 6.0, 'logged');
  ldp.log('created');
  print('validate: ${ldp.validate()}');
  print('serialize: ${ldp.serialize()}');
  print('\n--- 22. 增强枚举 ---');
  print('Priority.high: ${Priority}.high');
  print('high > medium: ${Priority.high.isHigherThan(Priority.medium)}');
  print('low > high: ${Priority.low.isHigherThan(Priority.high)}');
{
    Iterator<Priority> sync_for_iterator = const [Priority.low, Priority.medium, Priority.high, Priority.critical].iterator;
    for (; sync_for_iterator.moveNext(); ) {
      final Priority p = sync_for_iterator.current;
{
        print('  ${p}');
      }
    }
  }
  print('GET isReadOnly: ${HttpMethod.get.isReadOnly}');
  print('POST isReadOnly: ${HttpMethod.post.isReadOnly}');
  print('\n--- 23. 重定向构造函数 ---');
  final Config cfg1 = Config('example.com', 8080);
  final Config cfg2 = Config.localhost();
  final Config cfg3 = Config.production('api.example.com');
  print('cfg1: ${cfg1}');
  print('cfg2: ${cfg2}');
  print('cfg3: ${cfg3}');
  print('\n--- 24. 泛型约束 ---');
  final SortedList<int> sortedList = SortedList();
  sortedList.add(5);
  sortedList.add(1);
  sortedList.add(3);
  sortedList.add(2);
  print('sorted: ${sortedList}');
  print('first: ${sortedList.first}, last: ${sortedList.last}');
  final int maxVal = findMax(<int>[3, 7, 1, 9, 4]);
  print('findMax: ${maxVal}');
  final String result = applyTwice(5, (int x) => 'n=${x}', (String s) => '${s}!');
  print('applyTwice: ${result}');
  print('\n--- 25. null safety ---');
  final NullSafetyDemo ns1 = NullSafetyDemo('hello', 'world');
  print('ns1: ${ns1.demonstrate()}');
  final NullSafetyDemo ns2 = NullSafetyDemo('hello');
  print('ns2: ${ns2.demonstrate()}');
  final String? found = findFirst(<String>['apple', 'banana', 'cherry'], (String s) => s.startsWith('b'));
  print('findFirst(b): ${found}');
  final String? notFound = findFirst(<String>['apple', 'banana'], (String s) => s.startsWith('z'));
  print('findFirst(z): ${notFound}');
  print('\n--- 26. for-in + do-while ---');
  final List<int> filtered = filterWithForIn(<int>[5, (-3), 10, 200, 50, (-1), 80]);
  print('filterWithForIn: ${filtered}');
  print('collatz(6): ${collatzSteps(6)}');
  print('collatz(27): ${collatzSteps(27)}');
  print('\n--- 27. 类型测试 ---');
  print(typeTest(42));
  print(typeTest('hello'));
  print(typeTest(true));
  print(typeTest(<int>[1, 2, 3]));
  print('safeCast(3.14): ${safeCast(3.14)}');
  print('safeCast("x"): ${safeCast('x')}');
  print('\n--- 28. try-catch-finally ---');
  print('code=0: ${tryCatchFinally(0)}');
  print('code=1: ${tryCatchFinally(1)}');
  print('code=2: ${tryCatchFinally(2)}');
  print('\n--- 29. covariant ---');
  final CircleRenderer renderer = CircleRenderer();
  print('renderer: ${renderer.name}');
  renderer.render('circle');
  print('\n--- 30. Pipeline 泛型链 ---');
  final Pipeline<int, String> pipeline = Pipeline((int n) => 'val=${n}').then((String s) => s.length).then((int len) => 'len=${len}');
  print('pipeline(42): ${pipeline.execute(42)}');
  print('pipeline(12345): ${pipeline.execute(12345)}');
  print('\n--- 31. switch-case ---');
  print('day 1: ${dayType(1)}');
  print('day 3: ${dayType(3)}');
  print('day 7: ${dayType(7)}');
  print('day 9: ${dayType(9)}');
  print('\n--- 32. 位运算 ---');
  final BitFlags flags = BitFlags();
  flags.set(1);
  flags.set(4);
  print('flags: ${flags}');
  print('has read: ${flags.has(1)}');
  print('has write: ${flags.has(2)}');
  flags.set(2);
  print('after set write: ${flags}');
  flags.clear(4);
  print('after clear execute: ${flags}');
  print('\n--- 33. 多层 mixin ---');
  final Event event = Event('meeting');
  event.addTag('work');
  event.addTag('important');
  print(event);
  final ImportantEvent impEvent = ImportantEvent('deadline', Priority.critical);
  impEvent.addTag('urgent');
  impEvent.log('created');
  print(impEvent);
  print('\n=== 所有测试通过 ✅ ===');
}

