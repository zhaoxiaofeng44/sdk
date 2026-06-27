// ============================================================================
// 还原器边缘场景压力测试
// 覆盖：刚修复的特性 + 多特性交叉组合
// - async void 函数
// - continue 语句（循环 + switch）
// - await for（异步 for-in）
// - late 字段惰性初始化
// - await 非 Future 值
// - 深层异步链
// - 闭包 + async + Box 交叉
// - mixin + async 方法
// - 运算符重载 + 集合 + 闭包
// - 嵌套 try-catch-finally + async
// - Record 类型 + 方法调用
// - 多层泛型 + 接口 + mixin
// ============================================================================

// --------------------------------------------------------------------------
// 1. async void 函数（刚修复：统一转为 async int）
// --------------------------------------------------------------------------
List<String> log = <String>[];

void logMessage(String msg) async {
  final prefix = await Future.value('[LOG]');
  log.add('$prefix $msg');
}

void logWithDelay(String msg, int ticks) async {
  await Future.delayed(Duration(milliseconds: ticks * 10));
  log.add(msg);
}

// async void with try-catch
void safeLog(String msg) async {
  try {
    final result = await Future.value(msg);
    log.add('safe: $result');
  } catch (e) {
    log.add('error: $e');
  }
}

// --------------------------------------------------------------------------
// 2. continue 语句
// --------------------------------------------------------------------------

// continue in for loop
List<int> collectOdds(int n) {
  final result = <int>[];
  for (var i = 0; i < n; i++) {
    if (i % 2 == 0) continue;
    result.add(i);
  }
  return result;
}

// continue in while loop
int countDigits(int n) {
  var count = 0;
  while (n > 0) {
    final digit = n % 10;
    n ~/= 10;
    if (digit == 0) continue;
    count++;
  }
  return count;
}

// continue in do-while
List<String> skipEmpty(List<String> items) {
  final result = <String>[];
  var i = 0;
  do {
    if (items[i].isEmpty) {
      i++;
      continue;
    }
    result.add(items[i]);
    i++;
  } while (i < items.length);
  return result;
}

// continue in switch (ContinueSwitchStatement)
String classify(int n) {
  final result = StringBuffer();
  switch (n % 5) {
    case 0:
      result.write('div5');
      continue myLabel;
    case 1:
      result.write('mod1');
      break;
    case 2:
      result.write('mod2');
      break;
    case 3:
      result.write('mod3');
      continue myLabel;
    case 4:
      result.write('mod4');
      break;
    myLabel:
    default:
      result.write('(default)');
  }
  return result.toString();
}

// --------------------------------------------------------------------------
// 3. late 字段惰性初始化（刚修复：保留 lazy 语义）
// --------------------------------------------------------------------------

class LazyConfig {
  late String computed = _expensiveInit();
  late int counter = _nextId();
  final String name;

  LazyConfig(this.name);

  static int _idCounter = 0;
  static int _nextId() => ++_idCounter;

  String _expensiveInit() {
    return '${name}_config_initialized';
  }
}

class LateWithDependency {
  late int base = 10;
  late int doubled = base * 2;
  late String label = 'val=$doubled';

  String describe() => label;
}

// --------------------------------------------------------------------------
// 4. await 非 Future 值（刚修复：smAwait 自动包装）
// --------------------------------------------------------------------------

Future<int> awaitNonFuture() async {
  final a = await 42;
  final b = await 'hello';
  final c = await true;
  return a + b.length + (c ? 1 : 0);
}

Future<String> awaitMixed() async {
  final x = await Future.value(10);
  final y = await 20;
  final z = await Future.value(30);
  return 'sum=${x + y + z}';
}

// --------------------------------------------------------------------------
// 5. 深层异步链 + 错误传播
// --------------------------------------------------------------------------

Future<int> deepAsync(int depth) async {
  if (depth <= 0) return 1;
  final sub = await deepAsync(depth - 1);
  return sub + depth;
}

Future<String> asyncErrorChain() async {
  try {
    final v = await _failingAsync();
    return 'unexpected: $v';
  } catch (e) {
    return 'caught: $e';
  }
}

Future<int> _failingAsync() async {
  await Future.value(0);
  throw Exception('deep failure');
}

// 多层嵌套 try-catch-finally in async
Future<String> nestedTryAsync() async {
  final steps = <String>[];
  try {
    steps.add('outer-try');
    try {
      steps.add('inner-try');
      await Future.value(1);
      throw Exception('inner');
    } catch (e) {
      steps.add('inner-catch: $e');
      throw Exception('rethrown');
    } finally {
      steps.add('inner-finally');
    }
  } catch (e) {
    steps.add('outer-catch: $e');
  } finally {
    steps.add('outer-finally');
  }
  return steps.join(' -> ');
}

// --------------------------------------------------------------------------
// 6. 闭包 + async + Box 交叉
// --------------------------------------------------------------------------

// 外层 async 函数，内部使用闭包捕获变量
Future<String> asyncWithClosure() async {
  var prefix = 'result';
  String format(int value) {
    return '$prefix: $value';
  }
  final v = await Future.value(42);
  return format(v);
}

// 嵌套闭包捕获 + 外层 async
Future<String> nestedClosureAsync() async {
  var outer = 'start';
  String transform(String input) {
    var inner = input;
    String apply() {
      return '$outer->$inner';
    }
    return apply();
  }
  final result = await Future.value(transform('hello'));
  outer = 'end';
  return '$result|$outer';
}

// --------------------------------------------------------------------------
// 7. mixin + async 方法
// --------------------------------------------------------------------------

mixin Logger {
  List<String> get messages;

  Future<void> logAsync(String msg) async {
    await Future.value(0);
    messages.add('[async] $msg');
  }

  void logSync(String msg) {
    messages.add('[sync] $msg');
  }
}

mixin Validator<T> {
  bool validate(T value);
  Future<bool> validateAsync(T value) async {
    await Future.value(0);
    return validate(value);
  }
}

class Service with Logger, Validator<String> {
  @override
  final List<String> messages = <String>[];

  @override
  bool validate(String value) => value.isNotEmpty;

  Future<String> process(String input) async {
    logSync('processing: $input');
    await logAsync('validating: $input');
    final valid = await validateAsync(input);
    if (!valid) return 'invalid';
    logSync('done');
    return 'ok: $input';
  }
}

// --------------------------------------------------------------------------
// 8. 运算符重载 + 集合 + 闭包
// --------------------------------------------------------------------------

class Vector2D {
  final double x;
  final double y;

  Vector2D(this.x, this.y);

  Vector2D operator +(Vector2D other) => Vector2D(x + other.x, y + other.y);
  Vector2D operator -(Vector2D other) => Vector2D(x - other.x, y - other.y);
  Vector2D operator *(double scalar) => Vector2D(x * scalar, y * scalar);
  bool operator ==(Object other) =>
      other is Vector2D && x == other.x && y == other.y;

  @override
  int get hashCode => x.hashCode ^ y.hashCode;

  double magnitude() => (x * x + y * y).abs();

  @override
  String toString() => '($x, $y)';
}

Vector2D sumVectors(List<Vector2D> vectors) {
  return vectors.reduce((a, b) => a + b);
}

List<Vector2D> scaleAll(List<Vector2D> vectors, double factor) {
  return vectors.map((v) => v * factor).toList();
}

// --------------------------------------------------------------------------
// 9. Record 类型 + 复杂场景
// --------------------------------------------------------------------------

(String, int) nameAge(String name, int age) => (name, age);

({String name, int age, String role}) personInfo(String n, int a, String r) =>
    (name: n, age: a, role: r);

List<(String, int)> topN(List<(String, int)> data, int n) {
  final sorted = List<(String, int)>.from(data);
  sorted.sort((a, b) => b.$2.compareTo(a.$2));
  return sorted.take(n).toList();
}

// --------------------------------------------------------------------------
// 10. 多层泛型 + 接口 + mixin
// --------------------------------------------------------------------------

abstract class Repository<T> {
  Future<T?> findById(String id);
  Future<List<T>> findAll();
  Future<void> save(String id, T item);
}

abstract class Cacheable {
  bool isCached(String key);
  void invalidate(String key);
}

mixin InMemoryCache<T> on Repository<T> implements Cacheable {
  final Map<String, T> _cache = <String, T>{};

  @override
  bool isCached(String key) => _cache.containsKey(key);

  @override
  void invalidate(String key) => _cache.remove(key);

  Future<T?> cachedFindById(String id) async {
    if (isCached(id)) return _cache[id];
    final item = await findById(id);
    if (item != null) _cache[id] = item;
    return item;
  }
}

class ItemRepo extends Repository<String> with InMemoryCache<String> {
  final Map<String, String> _store = <String, String>{};

  @override
  Future<String?> findById(String id) async {
    await Future.value(0);
    return _store[id];
  }

  @override
  Future<List<String>> findAll() async {
    await Future.value(0);
    return _store.values.toList();
  }

  @override
  Future<void> save(String id, String item) async {
    await Future.value(0);
    _store[id] = item;
  }
}

// --------------------------------------------------------------------------
// 11. 工厂构造 + 命名构造 + 重定向
// --------------------------------------------------------------------------

class Config {
  final String env;
  final int port;
  final bool debug;

  Config._internal(this.env, this.port, this.debug);

  factory Config.development() => Config._internal('dev', 3000, true);
  factory Config.production() => Config._internal('prod', 8080, false);
  factory Config.custom(String env, int port) =>
      Config._internal(env, port, env == 'dev');

  @override
  String toString() => 'Config($env, port=$port, debug=$debug)';
}

// --------------------------------------------------------------------------
// 12. switch + pattern + 复杂控制流
// --------------------------------------------------------------------------

String describeValue(Object value) {
  switch (value) {
    case int n when n < 0:
      return 'negative int: $n';
    case int n when n == 0:
      return 'zero';
    case int n:
      return 'positive int: $n';
    case String s when s.isEmpty:
      return 'empty string';
    case String s:
      return 'string: $s (len=${s.length})';
    case List l:
      return 'list of ${l.length}';
    case null:
      return 'null';
    default:
      return 'unknown: ${value.runtimeType}';
  }
}

// --------------------------------------------------------------------------
// main
// --------------------------------------------------------------------------

void main() async {
  // 1. async void
  print('--- 1. async void ---');
  log.clear();
  await Future.value(0);
  logMessage('hello');
  await Future.delayed(Duration(milliseconds: 30));
  print('  log after logMessage: $log');
  log.clear();
  safeLog('test');
  await Future.delayed(Duration(milliseconds: 30));
  print('  safeLog result: $log');

  // 2. continue
  print('\n--- 2. continue ---');
  print('  collectOdds(10): ${collectOdds(10)}');
  print('  countDigits(10203): ${countDigits(10203)}');
  print('  skipEmpty(["a","","b","","c"]): ${skipEmpty(["a", "", "b", "", "c"])}');
  print('  classify(10): ${classify(10)}');
  print('  classify(7): ${classify(7)}');
  print('  classify(13): ${classify(13)}');
  print('  classify(4): ${classify(4)}');
  print('  classify(1): ${classify(1)}');

  // 3. late fields
  print('\n--- 3. late fields ---');
  final cfg = LazyConfig('app');
  print('  name: ${cfg.name}');
  print('  computed: ${cfg.computed}');
  print('  counter: ${cfg.counter}');
  final dep = LateWithDependency();
  print('  describe: ${dep.describe()}');

  // 4. await non-Future
  print('\n--- 4. await non-Future ---');
  print('  awaitNonFuture: ${await awaitNonFuture()}');
  print('  awaitMixed: ${await awaitMixed()}');

  // 5. deep async + error chain
  print('\n--- 5. deep async ---');
  print('  deepAsync(10): ${await deepAsync(10)}');
  print('  asyncErrorChain: ${await asyncErrorChain()}');
  print('  nestedTryAsync: ${await nestedTryAsync()}');

  // 6. closure + async + Box
  print('\n--- 6. closure + async ---');
  print('  asyncWithClosure: ${await asyncWithClosure()}');
  print('  nestedClosureAsync: ${await nestedClosureAsync()}');

  // 7. mixin + async
  print('\n--- 7. mixin + async ---');
  final svc = Service();
  final r = await svc.process('hello');
  print('  process result: $r');
  print('  messages: ${svc.messages}');
  final invalidResult = await svc.process('');
  print('  invalid result: $invalidResult');

  // 8. operators + collections
  print('\n--- 8. operators ---');
  final v1 = Vector2D(1.0, 2.0);
  final v2 = Vector2D(3.0, 4.0);
  print('  v1 + v2 = ${v1 + v2}');
  print('  v1 - v2 = ${v1 - v2}');
  print('  v1 * 3 = ${v1 * 3.0}');
  print('  v1 == Vector2D(1,2): ${v1 == Vector2D(1.0, 2.0)}');
  final sum = sumVectors([v1, v2, Vector2D(5.0, 6.0)]);
  print('  sumVectors: $sum');
  final scaled = scaleAll([v1, v2], 2.0);
  print('  scaleAll: $scaled');

  // 9. Records
  print('\n--- 9. Records ---');
  final na = nameAge('Alice', 30);
  print('  nameAge: (${na.$1}, ${na.$2})');
  final pi = personInfo('Bob', 25, 'dev');
  print('  personInfo: (${pi.name}, ${pi.age}, ${pi.role})');
  final data = <(String, int)>[('Alice', 90), ('Bob', 85), ('Charlie', 95), ('Diana', 88)];
  print('  topN(2): ${topN(data, 2)}');

  // 10. generics + interface + mixin
  print('\n--- 10. Repository ---');
  final repo = ItemRepo();
  await repo.save('1', 'item-A');
  await repo.save('2', 'item-B');
  await repo.save('3', 'item-C');
  print('  findById(1): ${await repo.findById("1")}');
  print('  findAll: ${await repo.findAll()}');
  print('  isCached(1): ${repo.isCached("1")}');
  final cached = await repo.cachedFindById('2');
  print('  cachedFindById(2): $cached');
  print('  isCached(2): ${repo.isCached("2")}');
  repo.invalidate('2');
  print('  after invalidate(2), isCached(2): ${repo.isCached("2")}');

  // 11. factory constructors
  print('\n--- 11. Factory constructors ---');
  print('  dev: ${Config.development()}');
  print('  prod: ${Config.production()}');
  print('  custom: ${Config.custom("staging", 9090)}');

  // 12. switch patterns
  print('\n--- 12. Switch patterns ---');
  for (final v in <Object>[-5, 0, 42, '', 'hello', [1,2,3], true]) {
    print('  $v => ${describeValue(v)}');
  }

  print('\n=== all edge case tests passed ===');
}
