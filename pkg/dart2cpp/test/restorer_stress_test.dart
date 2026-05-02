// ============================================================================
// 还原器压力测试 - 复杂综合场景
// 覆盖：多层泛型继承/mixin、闭包Box化、运算符重载、工厂构造、枚举、
//       级联操作、多重implements、类型转换、集合操作、异常处理等
// ============================================================================

// --------------------------------------------------------------------------
// 1. typedef + Function 类型
// --------------------------------------------------------------------------
typedef Predicate<T> = bool Function(T);
typedef Transformer<A, B> = B Function(A);
typedef Reducer<T> = T Function(T, T);

T applyTransform<T>(T value, Transformer<T, T> transform) {
  return transform(value);
}

List<T> filterWith<T>(List<T> items, Predicate<T> predicate) {
  final result = <T>[];
  for (final item in items) {
    if (predicate(item)) result.add(item);
  }
  return result;
}

T reduceList<T>(List<T> items, Reducer<T> reducer) {
  T acc = items.first;
  for (var i = 1; i < items.length; i++) {
    acc = reducer(acc, items[i]);
  }
  return acc;
}

// --------------------------------------------------------------------------
// 2. 枚举类
// --------------------------------------------------------------------------
enum Priority { low, medium, high, critical }

enum Color {
  red,
  green,
  blue;

  String get hex {
    switch (this) {
      case Color.red:
        return '#FF0000';
      case Color.green:
        return '#00FF00';
      case Color.blue:
        return '#0000FF';
    }
  }

  bool get isWarm => this == Color.red;
}

// --------------------------------------------------------------------------
// 3. 抽象类 + 泛型约束
// --------------------------------------------------------------------------
abstract class Comparable2<T> {
  int compareTo(T other);
  bool operator <(T other) => compareTo(other) < 0;
  bool operator >(T other) => compareTo(other) > 0;
  bool operator <=(T other) => compareTo(other) <= 0;
  bool operator >=(T other) => compareTo(other) >= 0;
}

// --------------------------------------------------------------------------
// 4. mixin 带泛型 + on 约束
// --------------------------------------------------------------------------
mixin Printable {
  String get label;
  String toPrettyString() => '[$label]';
}

mixin Serializable<T> {
  T serialize();
  String toJson() => '{"data": "${serialize()}"}';
}

mixin Cacheable<K> {
  static final Map<String, dynamic> _cache = {};

  K get cacheKey;

  void cacheValue(dynamic value) {
    _cache['$cacheKey'] = value;
  }

  dynamic getCachedValue() {
    return _cache['$cacheKey'];
  }

  static void clearCache() {
    _cache.clear();
  }
}

mixin Validatable {
  List<String> validate();
  bool get isValid => validate().isEmpty;
}

// --------------------------------------------------------------------------
// 5. 多层泛型继承 + 多 mixin 组合
// --------------------------------------------------------------------------
class Entity<ID> with Printable, Cacheable<ID> {
  final ID id;
  final String name;

  Entity(this.id, this.name);

  @override
  String get label => '$name($id)';

  @override
  ID get cacheKey => id;

  @override
  String toString() => 'Entity($id, $name)';
}

class TimestampedEntity<ID> extends Entity<ID> {
  final int createdAt;
  final int updatedAt;

  TimestampedEntity(ID id, String name, this.createdAt, this.updatedAt)
      : super(id, name);

  Duration get age => Duration(milliseconds: updatedAt - createdAt);

  @override
  String get label => '$name($id, age=${age.inMilliseconds}ms)';
}

class VersionedEntity<ID> extends TimestampedEntity<ID>
    with Serializable<String>, Validatable {
  int _version;
  final List<String> _changelog;

  VersionedEntity(ID id, String name, int createdAt, int updatedAt)
      : _version = 1,
        _changelog = [],
        super(id, name, createdAt, updatedAt);

  int get version => _version;

  void bump(String change) {
    _version++;
    _changelog.add('v$_version: $change');
  }

  List<String> get changelog => List.unmodifiable(_changelog);

  @override
  String serialize() => '$id:$name:v$_version';

  @override
  List<String> validate() {
    final errors = <String>[];
    if (name.isEmpty) errors.add('name is empty');
    if (_version < 1) errors.add('invalid version');
    return errors;
  }

  @override
  String get label => '$name(v$_version)';
}

// --------------------------------------------------------------------------
// 6. 运算符重载 + Comparable
// --------------------------------------------------------------------------
class Money extends Comparable2<Money> with Printable {
  final int cents;
  final String currency;

  Money(this.cents, [this.currency = 'USD']);

  Money.fromDollars(double dollars, [String currency = 'USD'])
      : cents = (dollars * 100).round(),
        currency = currency;

  Money operator +(Money other) {
    if (currency != other.currency) throw ArgumentError('Currency mismatch');
    return Money(cents + other.cents, currency);
  }

  Money operator -(Money other) {
    if (currency != other.currency) throw ArgumentError('Currency mismatch');
    return Money(cents - other.cents, currency);
  }

  Money operator *(int factor) => Money(cents * factor, currency);

  Money operator -() => Money(-cents, currency);

  @override
  int compareTo(Money other) => cents - other.cents;

  @override
  String get label => '\$${(cents / 100).toStringAsFixed(2)} $currency';

  @override
  String toString() => label;
}

// --------------------------------------------------------------------------
// 7. 工厂构造函数 + 命名构造函数
// --------------------------------------------------------------------------
class Config {
  final Map<String, dynamic> _data;

  Config(this._data);

  Config.empty() : _data = {};

  Config.fromPairs(List<List<dynamic>> pairs)
      : _data = {for (final p in pairs) p[0] as String: p[1]};

  factory Config.withDefaults(Map<String, dynamic> overrides) {
    final defaults = <String, dynamic>{
      'debug': false,
      'maxRetries': 3,
      'timeout': 30,
      'name': 'default',
    };
    defaults.addAll(overrides);
    return Config(defaults);
  }

  dynamic operator [](String key) => _data[key];
  void operator []=(String key, dynamic value) => _data[key] = value;

  bool containsKey(String key) => _data.containsKey(key);

  int get length => _data.length;

  @override
  String toString() {
    final sorted = _data.keys.toList()..sort();
    final entries = sorted.map((k) => '$k=${_data[k]}');
    return 'Config{${entries.join(', ')}}';
  }
}

// --------------------------------------------------------------------------
// 8. 闭包捕获 + 嵌套闭包 + Box 化
// --------------------------------------------------------------------------
class EventBus {
  final List<void Function(String)> _listeners = [];

  void on(void Function(String) listener) {
    _listeners.add(listener);
  }

  void emit(String event) {
    for (final listener in _listeners) {
      listener(event);
    }
  }
}

List<String> testClosureBoxing() {
  final log = <String>[];

  // 场景1: 闭包捕获可变局部变量
  var counter = 0;
  final increment = () {
    counter++;
    return counter;
  };
  increment();
  increment();
  log.add('counter=$counter');

  // 场景2: 循环中闭包捕获
  final fns = <int Function()>[];
  for (var i = 0; i < 3; i++) {
    fns.add(() => i * 10);
  }
  log.add('fns=${fns.map((f) => f()).toList()}');

  // 场景3: 嵌套闭包
  var outer = 0;
  final makeAdder = (int base) {
    var inner = base;
    return (int x) {
      inner += x;
      outer += x;
      return inner;
    };
  };
  final adder = makeAdder(100);
  adder(5);
  adder(10);
  log.add('outer=$outer, adder(0)=${adder(0)}');

  // 场景4: 闭包捕获参数
  String captureParam(String prefix) {
    var count = 0;
    final fn = () {
      count++;
      return '$prefix-$count';
    };
    fn();
    fn();
    return fn();
  }
  log.add('captureParam=${captureParam("test")}');

  // 场景5: EventBus 闭包
  final bus = EventBus();
  var received = <String>[];
  bus.on((event) {
    received.add(event);
  });
  bus.emit('hello');
  bus.emit('world');
  log.add('received=$received');

  return log;
}

// --------------------------------------------------------------------------
// 9. 多重 implements
// --------------------------------------------------------------------------
abstract class Drawable {
  void draw();
}

abstract class Resizable {
  void resize(double factor);
}

abstract class Clickable {
  void onClick();
}

class Widget implements Drawable, Resizable, Clickable {
  String _state = 'idle';
  double _scale = 1.0;
  int _clickCount = 0;

  @override
  void draw() {
    _state = 'drawn';
  }

  @override
  void resize(double factor) {
    _scale *= factor;
  }

  @override
  void onClick() {
    _clickCount++;
    _state = 'clicked($_clickCount)';
  }

  String get info => 'Widget(state=$_state, scale=${_scale.toStringAsFixed(1)}, clicks=$_clickCount)';
}

// --------------------------------------------------------------------------
// 10. 泛型方法 + 泛型类交叉
// --------------------------------------------------------------------------
class Pair<A, B> {
  final A first;
  final B second;

  Pair(this.first, this.second);

  Pair<B, A> swap() => Pair(second, first);

  Pair<C, B> mapFirst<C>(C Function(A) transform) {
    return Pair(transform(first), second);
  }

  Pair<A, C> mapSecond<C>(C Function(B) transform) {
    return Pair(first, transform(second));
  }

  R fold<R>(R Function(A, B) combine) => combine(first, second);

  @override
  String toString() => 'Pair($first, $second)';
}

class Triple<A, B, C> extends Pair<A, B> {
  final C third;

  Triple(A first, B second, this.third) : super(first, second);

  @override
  String toString() => 'Triple($first, $second, $third)';
}

// --------------------------------------------------------------------------
// 11. 级联操作
// --------------------------------------------------------------------------
class StringBuilder {
  final StringBuffer _buf = StringBuffer();
  String _separator = '';

  StringBuilder withSeparator(String sep) {
    _separator = sep;
    return this;
  }

  StringBuilder add(String text) {
    if (_buf.isNotEmpty && _separator.isNotEmpty) {
      _buf.write(_separator);
    }
    _buf.write(text);
    return this;
  }

  StringBuilder addAll(List<String> texts) {
    for (final t in texts) {
      add(t);
    }
    return this;
  }

  int get length => _buf.length;

  @override
  String toString() => _buf.toString();
}

// --------------------------------------------------------------------------
// 12. 异常处理链
// --------------------------------------------------------------------------
class AppError implements Exception {
  final String message;
  final String code;
  final AppError? cause;

  AppError(this.message, this.code, [this.cause]);

  @override
  String toString() {
    final chain = <String>[];
    AppError? current = this;
    while (current != null) {
      chain.add('${current.code}:${current.message}');
      current = current.cause;
    }
    return chain.join(' -> ');
  }
}

String testExceptionChain() {
  try {
    try {
      throw AppError('not found', 'E404');
    } catch (e) {
      throw AppError('service failed', 'E500', e as AppError);
    }
  } catch (e) {
    try {
      throw AppError('gateway error', 'E502', e as AppError);
    } catch (e2) {
      return e2.toString();
    }
  }
}

// --------------------------------------------------------------------------
// 13. 复杂集合操作
// --------------------------------------------------------------------------
class DataPipeline<T> {
  final List<T> _data;

  DataPipeline(this._data);

  DataPipeline<T> where(bool Function(T) test) {
    return DataPipeline(_data.where(test).toList());
  }

  DataPipeline<R> map<R>(R Function(T) transform) {
    return DataPipeline(_data.map(transform).toList());
  }

  DataPipeline<T> sorted(int Function(T, T) compare) {
    final copy = List<T>.from(_data);
    copy.sort(compare);
    return DataPipeline(copy);
  }

  DataPipeline<T> take(int count) {
    return DataPipeline(_data.take(count).toList());
  }

  R fold<R>(R initial, R Function(R, T) combine) {
    return _data.fold(initial, combine);
  }

  List<T> toList() => List.unmodifiable(_data);

  @override
  String toString() => 'Pipeline($_data)';
}

// --------------------------------------------------------------------------
// 14. 可选参数 + 默认值
// --------------------------------------------------------------------------
String formatRecord({
  required String name,
  int age = 0,
  String? email,
  bool active = true,
  List<String> tags = const [],
}) {
  final parts = <String>[name];
  if (age > 0) parts.add('age=$age');
  if (email != null) parts.add('email=$email');
  parts.add('active=$active');
  if (tags.isNotEmpty) parts.add('tags=$tags');
  return 'Record(${parts.join(', ')})';
}

String greetAll(String greeting, [String name = 'World', String suffix = '!']) {
  return '$greeting, $name$suffix';
}

// --------------------------------------------------------------------------
// 15. getter/setter 覆盖 + 私有字段
// --------------------------------------------------------------------------
class BoundedValue {
  double _value;
  final double _min;
  final double _max;

  BoundedValue(this._value, this._min, this._max) {
    _clamp();
  }

  double get value => _value;
  set value(double v) {
    _value = v;
    _clamp();
  }

  void _clamp() {
    if (_value < _min) _value = _min;
    if (_value > _max) _value = _max;
  }

  BoundedValue operator +(double delta) => BoundedValue(_value + delta, _min, _max);

  @override
  String toString() => 'BoundedValue($_value, min=$_min, max=$_max)';
}

// --------------------------------------------------------------------------
// 16. 静态方法/字段
// --------------------------------------------------------------------------
class MathUtils {
  static const double pi = 3.14159265358979;
  static int _callCount = 0;

  static int get callCount => _callCount;

  static int factorial(int n) {
    _callCount++;
    if (n <= 1) return 1;
    return n * factorial(n - 1);
  }

  static List<int> fibonacci(int count) {
    _callCount++;
    if (count <= 0) return [];
    if (count == 1) return [0];
    final fibs = [0, 1];
    for (var i = 2; i < count; i++) {
      fibs.add(fibs[i - 1] + fibs[i - 2]);
    }
    return fibs;
  }

  static double lerp(double a, double b, double t) {
    _callCount++;
    return a + (b - a) * t;
  }
}

// --------------------------------------------------------------------------
// 17. 泛型 mixin 组合链
// --------------------------------------------------------------------------
mixin Loggable {
  final List<String> _logs = [];

  void log(String message) {
    _logs.add(message);
  }

  List<String> get logs => List.unmodifiable(_logs);
}

mixin Observable<T> {
  final List<void Function(T)> _observers = [];

  void observe(void Function(T) callback) {
    _observers.add(callback);
  }

  void notify(T value) {
    for (final cb in _observers) {
      cb(value);
    }
  }
}

class ReactiveStore<V> with Loggable, Observable<V> {
  final Map<String, V> _store = {};

  V? get(String key) {
    log('get: $key');
    return _store[key];
  }

  void set(String key, V value) {
    log('set: $key=$value');
    _store[key] = value;
    notify(value);
  }

  int get size => _store.length;

  @override
  String toString() => 'Store($_store)';
}

// --------------------------------------------------------------------------
// 18. 类型转换 + is 检查
// --------------------------------------------------------------------------
abstract class Shape {
  double area();
  String get shapeName;
}

class Circle implements Shape {
  final double radius;
  Circle(this.radius);

  @override
  double area() => 3.14159 * radius * radius;

  @override
  String get shapeName => 'Circle';

  @override
  String toString() => 'Circle(r=$radius)';
}

class Rectangle implements Shape {
  final double width;
  final double height;
  Rectangle(this.width, this.height);

  @override
  double area() => width * height;

  @override
  String get shapeName => 'Rectangle';

  @override
  String toString() => 'Rectangle(${width}x$height)';
}

String describeShape(Shape shape) {
  if (shape is Circle) {
    return '${shape.shapeName}: r=${shape.radius}, area=${shape.area().toStringAsFixed(2)}';
  } else if (shape is Rectangle) {
    return '${shape.shapeName}: ${shape.width}x${shape.height}, area=${shape.area().toStringAsFixed(2)}';
  }
  return 'Unknown shape: area=${shape.area()}';
}

// --------------------------------------------------------------------------
// 19. 复杂泛型继承链 + 类型参数传递
// --------------------------------------------------------------------------
class Node<T> {
  final T value;
  final List<Node<T>> children;

  Node(this.value, [List<Node<T>>? children]) : children = children ?? [];

  void addChild(Node<T> child) {
    children.add(child);
  }

  List<T> flatten() {
    final result = <T>[value];
    for (final child in children) {
      result.addAll(child.flatten());
    }
    return result;
  }

  Node<R> mapTree<R>(R Function(T) transform) {
    return Node(
      transform(value),
      children.map((c) => c.mapTree(transform)).toList(),
    );
  }

  @override
  String toString() {
    if (children.isEmpty) return '$value';
    return '$value(${children.join(', ')})';
  }
}

class LabeledNode<T> extends Node<T> with Printable {
  final String nodeLabel;

  LabeledNode(this.nodeLabel, T value, [List<Node<T>>? children])
      : super(value, children);

  @override
  String get label => '$nodeLabel:$value';

  @override
  String toString() => '[$nodeLabel]$value';
}

// --------------------------------------------------------------------------
// 20. switch-case + 条件表达式
// --------------------------------------------------------------------------
String evaluateGrade(int score) {
  final letter = score >= 90
      ? 'A'
      : score >= 80
          ? 'B'
          : score >= 70
              ? 'C'
              : score >= 60
                  ? 'D'
                  : 'F';

  String description;
  switch (letter) {
    case 'A':
      description = 'Excellent';
      break;
    case 'B':
      description = 'Good';
      break;
    case 'C':
      description = 'Average';
      break;
    case 'D':
      description = 'Below Average';
      break;
    default:
      description = 'Failing';
  }

  return '$score → $letter ($description)';
}

// ============================================================================
// main
// ============================================================================
void main() {
  // --- 1. typedef + Function 类型 ---
  print('--- 1. typedef + Function ---');
  final doubled = applyTransform(21, (x) => x * 2);
  print('applyTransform: $doubled');

  final evens = filterWith([1, 2, 3, 4, 5, 6], (x) => x % 2 == 0);
  print('filterWith: $evens');

  final sum = reduceList([1, 2, 3, 4, 5], (a, b) => a + b);
  print('reduceList: $sum');

  // --- 2. 枚举类 ---
  print('\n--- 2. 枚举类 ---');
  print('red hex: ${Color.red.hex}');
  print('green isWarm: ${Color.green.isWarm}');
  print('priorities: ${Priority.values.map((p) => '$p'.split('.').last).toList()}');

  // --- 3+6. 运算符重载 + Comparable + Printable ---
  print('\n--- 3. 运算符重载 ---');
  final price1 = Money(1099, 'USD');
  final price2 = Money.fromDollars(5.50);
  final total = price1 + price2;
  final negated = -price2;
  print('price1: ${price1.toPrettyString()}');
  print('price2: $price2');
  print('total: $total');
  print('negated: $negated');
  print('price1 > price2: ${price1 > price2}');
  print('price1 < price2: ${price1 < price2}');
  print('price1 * 3: ${price1 * 3}');

  // --- 4+5. 多层泛型继承 + 多 mixin ---
  print('\n--- 4. 多层泛型继承 ---');
  final entity = Entity<int>(1, 'alice');
  print('entity: $entity');
  print('entity label: ${entity.toPrettyString()}');
  entity.cacheValue('cached_data');
  print('cached: ${entity.getCachedValue()}');

  final tsEntity = TimestampedEntity<String>('u1', 'bob', 1000, 2000);
  print('tsEntity label: ${tsEntity.toPrettyString()}');

  final vEntity = VersionedEntity<int>(42, 'project', 1000, 5000);
  vEntity.bump('initial release');
  vEntity.bump('bug fix');
  print('vEntity label: ${vEntity.toPrettyString()}');
  print('vEntity version: ${vEntity.version}');
  print('vEntity changelog: ${vEntity.changelog}');
  print('vEntity serialize: ${vEntity.serialize()}');
  print('vEntity toJson: ${vEntity.toJson()}');
  print('vEntity isValid: ${vEntity.isValid}');
  print('vEntity validate: ${vEntity.validate()}');

  // --- 7. 工厂构造 + 命名构造 ---
  print('\n--- 5. 工厂构造 ---');
  final cfg1 = Config.empty();
  cfg1['host'] = 'localhost';
  print('cfg1: $cfg1');

  final cfg2 = Config.fromPairs([
    ['a', 1],
    ['b', 2]
  ]);
  print('cfg2: $cfg2');

  final cfg3 = Config.withDefaults({'debug': true, 'name': 'prod'});
  print('cfg3: $cfg3');
  print('cfg3[maxRetries]: ${cfg3['maxRetries']}');

  // --- 8. 闭包 + Box 化 ---
  print('\n--- 6. 闭包 Box 化 ---');
  final closureLog = testClosureBoxing();
  for (final line in closureLog) {
    print(line);
  }

  // --- 9. 多重 implements ---
  print('\n--- 7. 多重 implements ---');
  final widget = Widget();
  widget.draw();
  widget.resize(1.5);
  widget.onClick();
  widget.onClick();
  print('widget: ${widget.info}');

  // --- 10. 泛型方法 + 泛型类交叉 ---
  print('\n--- 8. 泛型 Pair ---');
  final pair = Pair<int, String>(42, 'hello');
  print('pair: $pair');
  print('swap: ${pair.swap()}');
  print('mapFirst: ${pair.mapFirst((x) => x * 2)}');
  print('mapSecond: ${pair.mapSecond((s) => s.toUpperCase())}');
  print('fold: ${pair.fold((a, b) => '$b=$a')}');

  final triple = Triple<int, String, bool>(1, 'yes', true);
  print('triple: $triple');

  // --- 11. 级联 ---
  print('\n--- 9. 级联操作 ---');
  final sb = StringBuilder()
    ..withSeparator(', ')
    ..add('alpha')
    ..add('beta')
    ..addAll(['gamma', 'delta']);
  print('builder: $sb');
  print('length: ${sb.length}');

  // --- 12. 异常处理链 ---
  print('\n--- 10. 异常处理链 ---');
  print('chain: ${testExceptionChain()}');

  // --- 13. 复杂集合操作 ---
  print('\n--- 11. 集合操作 ---');
  final pipeline = DataPipeline([5, 3, 8, 1, 9, 2, 7, 4, 6])
      .where((x) => x > 2)
      .sorted((a, b) => a - b)
      .take(5)
      .map((x) => x * 10);
  print('pipeline: ${pipeline.toList()}');

  final pipeSum = DataPipeline([1, 2, 3, 4, 5]).fold(0, (acc, x) => acc + x);
  print('pipeSum: $pipeSum');

  // --- 14. 可选参数 ---
  print('\n--- 12. 可选参数 ---');
  print(formatRecord(name: 'Alice', age: 30, email: 'alice@test.com'));
  print(formatRecord(name: 'Bob', tags: ['admin', 'vip']));
  print(greetAll('Hello'));
  print(greetAll('Hi', 'Dart', '!!'));

  // --- 15. getter/setter + BoundedValue ---
  print('\n--- 13. BoundedValue ---');
  final bv = BoundedValue(5.0, 0.0, 10.0);
  print('bv: $bv');
  bv.value = 15.0;
  print('after set 15: $bv');
  bv.value = -5.0;
  print('after set -5: $bv');
  final bv2 = bv + 7.0;
  print('bv + 7: $bv2');

  // --- 16. 静态方法 ---
  print('\n--- 14. 静态方法 ---');
  print('5! = ${MathUtils.factorial(5)}');
  print('fib(8): ${MathUtils.fibonacci(8)}');
  print('lerp(0,100,0.3): ${MathUtils.lerp(0, 100, 0.3)}');
  print('callCount: ${MathUtils.callCount}');

  // --- 17. ReactiveStore (泛型 mixin 链) ---
  print('\n--- 15. ReactiveStore ---');
  final store = ReactiveStore<int>();
  final observed = <int>[];
  store.observe((v) { observed.add(v); });
  store.set('x', 10);
  store.set('y', 20);
  print('store: $store');
  print('store.get(x): ${store.get('x')}');
  print('store.size: ${store.size}');
  print('observed: $observed');
  print('logs: ${store.logs}');

  // --- 18. 类型转换 + is ---
  print('\n--- 16. 类型转换 ---');
  final shapes = <Shape>[Circle(5.0), Rectangle(3.0, 4.0), Circle(1.0)];
  for (final s in shapes) {
    print(describeShape(s));
  }

  // --- 19. 树结构 + 泛型继承 ---
  print('\n--- 17. 树结构 ---');
  final tree = Node<int>(1, [
    Node(2, [Node(4), Node(5)]),
    Node(3, [Node(6)]),
  ]);
  print('tree: $tree');
  print('flatten: ${tree.flatten()}');

  final strTree = tree.mapTree((x) => 'N$x');
  print('mapped: $strTree');

  final labeled = LabeledNode<int>('root', 100);
  labeled.addChild(Node(200));
  labeled.addChild(Node(300));
  print('labeled: $labeled');
  print('labeled pretty: ${labeled.toPrettyString()}');
  print('labeled flatten: ${labeled.flatten()}');

  // --- 20. switch + 条件表达式 ---
  print('\n--- 18. 评分 ---');
  print(evaluateGrade(95));
  print(evaluateGrade(82));
  print(evaluateGrade(67));
  print(evaluateGrade(55));

  print('\n=== 所有压力测试通过 ✅ ===');
}
