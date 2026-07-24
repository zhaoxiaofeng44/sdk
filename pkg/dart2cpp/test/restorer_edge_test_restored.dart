import 'package:dart2cpp/platform/dart/runtime_classes.dart';

class LazyConfigClassInfo extends ClassInfo {
}

class LazyConfigValue extends AnyGC {
  late String computed = LazyConfig__expensiveInit(this);
  late int counter = LazyConfig__nextId();
  late String name;
  static LazyConfigClassInfo? _classInfo;
  @override
  ClassInfo get classInfo => _classInfo ??= _initClassInfo();
  static LazyConfigClassInfo _initClassInfo() {
    final ci = LazyConfigClassInfo();
    return ci;
  }
}

int LazyConfig__idCounter = 0;
LazyConfigValue LazyConfig_new(AnyGC this__, String name) {
  final this_ = this__ as LazyConfigValue;
  this_.name = name;
  return this_;
}

int LazyConfig__nextId() {
  return LazyConfig__idCounter = (LazyConfig__idCounter + 1);
}

String LazyConfig__expensiveInit(AnyGC this__) {
  final this_ = this__ as LazyConfigValue;
  return '${this_.name}_config_initialized';
}


class LateWithDependencyClassInfo extends ClassInfo {
  Function? describe;
}

class LateWithDependencyValue extends AnyGC {
  late int base = 10;
  late int doubled = (this.base * 2);
  late String label = 'val=${this.doubled}';
  static LateWithDependencyClassInfo? _classInfo;
  @override
  ClassInfo get classInfo => _classInfo ??= _initClassInfo();
  static LateWithDependencyClassInfo _initClassInfo() {
    final ci = LateWithDependencyClassInfo();
    ci.describe = LateWithDependency_describe;
    return ci;
  }
}

LateWithDependencyValue LateWithDependency_new(AnyGC this__) {
  final this_ = this__ as LateWithDependencyValue;
  return this_;
}

String LateWithDependency_describe(AnyGC this__) {
  final this_ = this__ as LateWithDependencyValue;
  return this_.label;
}


// mixin Logger → static functions for delegation
Promise<void> Logger_logAsync(AnyGC this__, String msg) {
  final this_ = this__ as dynamic;
  final env = ClosureEnv_Logger_logAsync_0(this_, msg);
  env._promise.setStartCallback(env.call);
  return env._promise;
}

void Logger_logSync(AnyGC this__, String msg) {
  final dynamic this_ = this__;
  (this_.classInfo as dynamic).get_messages!(this_).add('[sync] ${msg}');
}


// mixin Validator → static functions for delegation
Promise<bool> Validator_validateAsync<T>(AnyGC this__, T value) {
  final this_ = this__ as dynamic;
  final env = ClosureEnv_Validator_validateAsync_1<T>(this_, value);
  env._promise.setStartCallback(env.call);
  return env._promise;
}


class ServiceClassInfo extends Service_Object_Logger_ValidatorClassInfo {
  Function? process;
}

class ServiceValue extends Service_Object_Logger_ValidatorValue {
  late StaticList<String> messages = StaticList<String>();
  static ServiceClassInfo? _classInfo;
  @override
  ClassInfo get classInfo => _classInfo ??= _initClassInfo();
  static ServiceClassInfo _initClassInfo() {
    final ci = ServiceClassInfo();
    ci.get_messages = Service_get_messages;
    ci.logAsync = Service_logAsync;
    ci.logSync = Service_logSync;
    ci.validate = Service_validate;
    ci.validateAsync = Service_validateAsync;
    ci.process = Service_process;
    return ci;
  }
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
    if (messages is AnyGC) (messages as AnyGC).gcMark(flag);
  }
}

ServiceValue Service_new(AnyGC this__) {
  final this_ = this__ as ServiceValue;
  return this_;
}

bool Service_validate(AnyGC this__, String value) {
  final this_ = this__ as ServiceValue;
  return value.isNotEmpty;
}

Promise<String> Service_process(AnyGC this__, String input) {
  final this_ = this__ as ServiceValue;
  final env = ClosureEnv_Service_process_2(this_, input);
  env._promise.setStartCallback(env.call);
  return env._promise;
}

StaticList<String> Service_get_messages(AnyGC this__) {
  final this_ = this__ as ServiceValue;
  return this_.messages;
}

Promise<void> Service_logAsync(AnyGC this__, String msg) {
  final this_ = this__ as ServiceValue;
  return Logger_logAsync(this_, msg);
}

void Service_logSync(AnyGC this__, String msg) {
  final this_ = this__ as ServiceValue;
  Logger_logSync(this_, msg);
}

Promise<bool> Service_validateAsync(AnyGC this__, String value) {
  final this_ = this__ as ServiceValue;
  return Validator_validateAsync<String>(this_, value);
}


class Vector2DClassInfo extends ClassInfo {
  Function? operatorPlus;
  Function? operatorMinus;
  Function? operatorStar;
  Function? magnitude;
}

class Vector2DValue extends AnyGC {
  late double x;
  late double y;
  static Vector2DClassInfo? _classInfo;
  @override
  ClassInfo get classInfo => _classInfo ??= _initClassInfo();
  static Vector2DClassInfo _initClassInfo() {
    final ci = Vector2DClassInfo();
    ci.operatorPlus = Vector2D_operatorPlus;
    ci.operatorMinus = Vector2D_operatorMinus;
    ci.operatorStar = Vector2D_operatorStar;
    ci.operatorEq = Vector2D_operatorEq;
    ci.get_hashCode = Vector2D_get_hashCode;
    ci.magnitude = Vector2D_magnitude;
    ci.toString_ = Vector2D_toString;
    return ci;
  }
}

Vector2DValue Vector2D_new(AnyGC this__, double x, double y) {
  final this_ = this__ as Vector2DValue;
  this_.x = x;
  this_.y = y;
  return this_;
}

Vector2DValue Vector2D_operatorPlus(AnyGC this__, Vector2DValue other) {
  final this_ = this__ as Vector2DValue;
  return Vector2D_new(GC.allocateLocal(Vector2DValue()), (this_.x + other.x), (this_.y + other.y));
}

Vector2DValue Vector2D_operatorMinus(AnyGC this__, Vector2DValue other) {
  final this_ = this__ as Vector2DValue;
  return Vector2D_new(GC.allocateLocal(Vector2DValue()), (this_.x - other.x), (this_.y - other.y));
}

Vector2DValue Vector2D_operatorStar(AnyGC this__, double scalar) {
  final this_ = this__ as Vector2DValue;
  return Vector2D_new(GC.allocateLocal(Vector2DValue()), (this_.x * scalar), (this_.y * scalar));
}

bool Vector2D_operatorEq(AnyGC this__, Object other) {
  final this_ = this__ as Vector2DValue;
  return (((other is Vector2DValue) && (this_.x == other.x)) && (this_.y == other.y));
}

int Vector2D_get_hashCode(AnyGC this__) {
  final this_ = this__ as Vector2DValue;
  return (this_.x.hashCode ^ this_.y.hashCode);
}

double Vector2D_magnitude(AnyGC this__) {
  final this_ = this__ as Vector2DValue;
  return ((this_.x * this_.x) + (this_.y * this_.y)).abs();
}

String Vector2D_toString(AnyGC this__) {
  final this_ = this__ as Vector2DValue;
  return '(${this_.x}, ${this_.y})';
}


class RepositoryClassInfo<T> extends ClassInfo {
  Function? findById;
  Function? findAll;
  Function? save;
}

class RepositoryValue<T> extends AnyGC {
  @override
  ClassInfo get classInfo => RepositoryClassInfo<T>();
}

RepositoryValue<T> Repository_new<T>(AnyGC this__) {
  final this_ = this__ as RepositoryValue<T>;
  return this_;
}

Promise<T?> Repository_findById<T>(dynamic this_, String id) {
  throw UnimplementedError('Repository.findById is abstract');
}

Promise<StaticList<T>> Repository_findAll<T>(dynamic this_) {
  throw UnimplementedError('Repository.findAll is abstract');
}

Promise<void> Repository_save<T>(dynamic this_, String id, T item) {
  throw UnimplementedError('Repository.save is abstract');
}


class CacheableClassInfo extends ClassInfo {
  Function? isCached;
  Function? invalidate;
}

class CacheableValue extends AnyGC {
  static CacheableClassInfo? _classInfo;
  @override
  ClassInfo get classInfo => _classInfo ??= _initClassInfo();
  static CacheableClassInfo _initClassInfo() {
    final ci = CacheableClassInfo();
    ci.isCached = Cacheable_isCached;
    ci.invalidate = Cacheable_invalidate;
    return ci;
  }
}

CacheableValue Cacheable_new(AnyGC this__) {
  final this_ = this__ as CacheableValue;
  return this_;
}

bool Cacheable_isCached(dynamic this_, String key) {
  throw UnimplementedError('Cacheable.isCached is abstract');
}

void Cacheable_invalidate(dynamic this_, String key) {
  throw UnimplementedError('Cacheable.invalidate is abstract');
}


// mixin InMemoryCache → static functions for delegation
bool InMemoryCache_isCached<T>(AnyGC this__, String key) {
  final dynamic this_ = this__;
  return this_._cache.containsKey(key);
}

void InMemoryCache_invalidate<T>(AnyGC this__, String key) {
  final dynamic this_ = this__;
  this_._cache.remove(key);
}

Promise<T?> InMemoryCache_cachedFindById<T>(AnyGC this__, String id) {
  final this_ = this__ as dynamic;
  final env = ClosureEnv_InMemoryCache_cachedFindById_3<T>(this_, id);
  env._promise.setStartCallback(env.call);
  return env._promise;
}


class ItemRepoClassInfo extends ItemRepo_Repository_InMemoryCacheClassInfo {
}

class ItemRepoValue extends ItemRepo_Repository_InMemoryCacheValue {
  late StaticMap<String, String> _store = StaticMap<String, String>.of({});
  static ItemRepoClassInfo? _classInfo;
  @override
  ClassInfo get classInfo => _classInfo ??= _initClassInfo();
  static ItemRepoClassInfo _initClassInfo() {
    final ci = ItemRepoClassInfo();
    ci.findById = ItemRepo_findById;
    ci.findAll = ItemRepo_findAll;
    ci.save = ItemRepo_save;
    ci.isCached = ItemRepo_isCached;
    ci.invalidate = ItemRepo_invalidate;
    ci.cachedFindById = ItemRepo_cachedFindById;
    return ci;
  }
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
    if (_store is AnyGC) (_store as AnyGC).gcMark(flag);
  }
}

ItemRepoValue ItemRepo_new(AnyGC this__) {
  final this_ = this__ as ItemRepoValue;
  Repository_new<String>(this_);
  return this_;
}

Promise<String?> ItemRepo_findById(AnyGC this__, String id) {
  final this_ = this__ as ItemRepoValue;
  final env = ClosureEnv_ItemRepo_findById_4(this_, id);
  env._promise.setStartCallback(env.call);
  return env._promise;
}

Promise<StaticList<String>> ItemRepo_findAll(AnyGC this__) {
  final this_ = this__ as ItemRepoValue;
  final env = ClosureEnv_ItemRepo_findAll_5(this_);
  env._promise.setStartCallback(env.call);
  return env._promise;
}

Promise<void> ItemRepo_save(AnyGC this__, String id, String item) {
  final this_ = this__ as ItemRepoValue;
  final env = ClosureEnv_ItemRepo_save_6(this_, id, item);
  env._promise.setStartCallback(env.call);
  return env._promise;
}

bool ItemRepo_isCached(AnyGC this__, String key) {
  final this_ = this__ as ItemRepoValue;
  return InMemoryCache_isCached<String>(this_, key);
}

void ItemRepo_invalidate(AnyGC this__, String key) {
  final this_ = this__ as ItemRepoValue;
  InMemoryCache_invalidate<String>(this_, key);
}

Promise<String?> ItemRepo_cachedFindById(AnyGC this__, String id) {
  final this_ = this__ as ItemRepoValue;
  return InMemoryCache_cachedFindById<String>(this_, id);
}


class ConfigClassInfo extends ClassInfo {
}

class ConfigValue extends AnyGC {
  late String env;
  late int port;
  late bool debug;
  static ConfigClassInfo? _classInfo;
  @override
  ClassInfo get classInfo => _classInfo ??= _initClassInfo();
  static ConfigClassInfo _initClassInfo() {
    final ci = ConfigClassInfo();
    ci.toString_ = Config_toString;
    return ci;
  }
}

ConfigValue Config_new__internal(AnyGC this__, String env, int port, bool debug) {
  final this_ = this__ as ConfigValue;
  this_.env = env;
  this_.port = port;
  this_.debug = debug;
  return this_;
}

ConfigValue Config_new_development() {
  return Config_new__internal(GC.allocateLocal(ConfigValue()), 'dev', 3000, true);
}

ConfigValue Config_new_production() {
  return Config_new__internal(GC.allocateLocal(ConfigValue()), 'prod', 8080, false);
}

ConfigValue Config_new_custom(String env, int port) {
  return Config_new__internal(GC.allocateLocal(ConfigValue()), env, port, (env == 'dev'));
}

String Config_toString(AnyGC this__) {
  final this_ = this__ as ConfigValue;
  return 'Config(${this_.env}, port=${this_.port}, debug=${this_.debug})';
}


class Service_Object_LoggerClassInfo extends ClassInfo {
  Function? get_messages;
  Function? logAsync;
  Function? logSync;
}

class Service_Object_LoggerValue extends AnyGC {
  static Service_Object_LoggerClassInfo? _classInfo;
  @override
  ClassInfo get classInfo => _classInfo ??= _initClassInfo();
  static Service_Object_LoggerClassInfo _initClassInfo() {
    final ci = Service_Object_LoggerClassInfo();
    return ci;
  }
}


class Service_Object_Logger_ValidatorClassInfo extends Service_Object_LoggerClassInfo {
  Function? validate;
  Function? validateAsync;
}

class Service_Object_Logger_ValidatorValue extends Service_Object_LoggerValue {
  static Service_Object_Logger_ValidatorClassInfo? _classInfo;
  @override
  ClassInfo get classInfo => _classInfo ??= _initClassInfo();
  static Service_Object_Logger_ValidatorClassInfo _initClassInfo() {
    final ci = Service_Object_Logger_ValidatorClassInfo();
    return ci;
  }
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
  }
}


class ItemRepo_Repository_InMemoryCacheClassInfo extends RepositoryClassInfo<String> {
  Function? isCached;
  Function? invalidate;
  Function? cachedFindById;
}

class ItemRepo_Repository_InMemoryCacheValue extends RepositoryValue<String> {
  late StaticMap<String, String> _cache = StaticMap<String, String>.of({});
  static ItemRepo_Repository_InMemoryCacheClassInfo? _classInfo;
  @override
  ClassInfo get classInfo => _classInfo ??= _initClassInfo();
  static ItemRepo_Repository_InMemoryCacheClassInfo _initClassInfo() {
    final ci = ItemRepo_Repository_InMemoryCacheClassInfo();
    return ci;
  }
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
    if (_cache is AnyGC) (_cache as AnyGC).gcMark(flag);
  }
}


Promise<int> logMessage(String msg) {
  final env = ClosureEnv_logMessage_7(msg);
  env._promise.setStartCallback(env.call);
  return env._promise;
}

Promise<int> logWithDelay(String msg, int ticks) {
  final env = ClosureEnv_logWithDelay_8(msg, ticks);
  env._promise.setStartCallback(env.call);
  return env._promise;
}

Promise<int> safeLog(String msg) {
  final env = ClosureEnv_safeLog_9(msg);
  env._promise.setStartCallback(env.call);
  return env._promise;
}

StaticList<int> collectOdds(int n) {
  final StaticList<int> result = StaticList<int>();
  for (var i = 0; (i < n); i = (i + 1))   _L0: do {
{
      if (((i % 2) == 0))       break _L0;
      result.add(i);
    }
  } while (false);
  return result;
}

int countDigits(int n) {
  int count = 0;
  while ((n > 0))   _L1: do {
{
      final int digit = (n % 10);
      n = (n ~/ 10);
      if ((digit == 0))       break _L1;
      count = (count + 1);
    }
  } while (false);
  return count;
}

StaticList<String> skipEmpty(StaticList<String> items) {
  final StaticList<String> result = StaticList<String>();
  int i = 0;
  do   _L2: do {
{
      if (items[i].isEmpty) {
        i = (i + 1);
        break _L2;
      }
      result.add(items[i]);
      i = (i + 1);
    }
  } while (false);
 while ((i < items.length));
  return result;
}

String classify(int n) {
  final StaticStringBuffer result = StaticStringBuffer();
  _L3: do {
    switch ((n % 5)) {
      case 0:
{
          result.write('div5');
          continue _case_0;
        }
      case 1:
{
          result.write('mod1');
          break _L3;
        }
      case 2:
{
          result.write('mod2');
          break _L3;
        }
      case 3:
{
          result.write('mod3');
          continue _case_0;
        }
      case 4:
{
          result.write('mod4');
          break _L3;
        }
      _case_0:
      default:
{
          result.write('(default)');
        }
    }
  } while (false);
  return result.toString();
}

Promise<int> awaitNonFuture() {
  final env = ClosureEnv_awaitNonFuture_10();
  env._promise.setStartCallback(env.call);
  return env._promise;
}

Promise<String> awaitMixed() {
  final env = ClosureEnv_awaitMixed_11();
  env._promise.setStartCallback(env.call);
  return env._promise;
}

Promise<int> deepAsync(int depth) {
  final env = ClosureEnv_deepAsync_12(depth);
  env._promise.setStartCallback(env.call);
  return env._promise;
}

Promise<String> asyncErrorChain() {
  final env = ClosureEnv_asyncErrorChain_13();
  env._promise.setStartCallback(env.call);
  return env._promise;
}

Promise<int> _failingAsync() {
  final env = ClosureEnv__failingAsync_14();
  env._promise.setStartCallback(env.call);
  return env._promise;
}

Promise<String> nestedTryAsync() {
  final env = ClosureEnv_nestedTryAsync_15();
  env._promise.setStartCallback(env.call);
  return env._promise;
}

Promise<String> asyncWithClosure() {
  final env = ClosureEnv_asyncWithClosure_16();
  env._promise.setStartCallback(env.call);
  return env._promise;
}

Promise<String> nestedClosureAsync() {
  final env = ClosureEnv_nestedClosureAsync_17();
  env._promise.setStartCallback(env.call);
  return env._promise;
}

Vector2DValue sumVectors(StaticList<Vector2DValue> vectors) {
  return vectors.reduce(ClosureEnv_sumVectors_18_new(GC.allocateLocal(ClosureEnv_sumVectors_18())));
}

StaticList<Vector2DValue> scaleAll(StaticList<Vector2DValue> vectors, double factor_raw) {
  DoubleBox factor = DoubleBox(factor_raw);
  return StaticList.of(vectors.map(ClosureEnv_scaleAll_19_new(GC.allocateLocal(ClosureEnv_scaleAll_19()), factor)).toList());
}

(String, int) nameAge(String name, int age) {
  return (name, age);
}

({int age, String name, String role}) personInfo(String n, int a, String r) {
  return (() { final _let4 = n; return (age: a, name: _let4, role: r); })();
}

StaticList<(String, int)> topN(StaticList<(String, int)> data, int n) {
  final StaticList<(String, int)> sorted = StaticList<(String, int)>.of(data);
  sorted.sort(ClosureEnv_topN_20_new(GC.allocateLocal(ClosureEnv_topN_20())));
  return StaticList.of(sorted.take(n).toList());
}

String describeValue(Object value) {
  _L5: do {
{
      final Object _v6 = value;
      const dynamic _v7 = null;
{
        late int n;
        if ((((_v6 is int) && (() { final _let8 = n = _v6; return true; })()) && (n < 0))) {
{
            return 'negative int: ${n}';
          }
        }
      }
{
        late int n;
        if ((((_v6 is int) && (() { final _let9 = n = _v6; return true; })()) && (n == 0))) {
{
            return 'zero';
          }
        }
      }
{
        late int n;
        if (((_v6 is int) && (() { final _let10 = n = _v6; return true; })())) {
{
            return 'positive int: ${n}';
          }
        }
      }
{
        late String s;
        if ((((_v6 is String) && (() { final _let11 = s = _v6; return true; })()) && s.isEmpty)) {
{
            return 'empty string';
          }
        }
      }
{
        late String s;
        if (((_v6 is String) && (() { final _let12 = s = _v6; return true; })())) {
{
            return 'string: ${s} (len=${s.length})';
          }
        }
      }
{
        late StaticList<dynamic> l;
        if (((_v6 is StaticList<dynamic>) && (() { final _let13 = l = _v6; return true; })())) {
{
            return 'list of ${l.length}';
          }
        }
      }
{
        if ((_v6 == null)) {
{
            return 'null';
          }
        }
      }
{
{
{
            return 'unknown: ${value.runtimeType}';
          }
        }
      }
    }
  } while (false);
}

void main() {
  staticPrint('--- 1. async void ---');
  log.clear();
  smAwait(Promise.value<int>(0));
  logMessage('hello');
  smAwait(promiseDelayed<dynamic>(StaticDuration(milliseconds: 30)));
  staticPrint('  log after logMessage: ${log}');
  log.clear();
  safeLog('test');
  smAwait(promiseDelayed<dynamic>(StaticDuration(milliseconds: 30)));
  staticPrint('  safeLog result: ${log}');
  staticPrint('\n--- 2. continue ---');
  staticPrint('  collectOdds(10): ${collectOdds(10)}');
  staticPrint('  countDigits(10203): ${countDigits(10203)}');
  staticPrint('  skipEmpty(["a","","b","","c"]): ${skipEmpty(StaticList<String>.of(['a', '', 'b', '', 'c']))}');
  staticPrint('  classify(10): ${classify(10)}');
  staticPrint('  classify(7): ${classify(7)}');
  staticPrint('  classify(13): ${classify(13)}');
  staticPrint('  classify(4): ${classify(4)}');
  staticPrint('  classify(1): ${classify(1)}');
  staticPrint('\n--- 3. late fields ---');
  final LazyConfigValue cfg = LazyConfig_new(GC.allocateLocal(LazyConfigValue()), 'app');
  staticPrint('  name: ${cfg.name}');
  staticPrint('  computed: ${cfg.computed}');
  staticPrint('  counter: ${cfg.counter}');
  final LateWithDependencyValue dep = LateWithDependency_new(GC.allocateLocal(LateWithDependencyValue()));
  staticPrint('  describe: ${(dep.classInfo as LateWithDependencyClassInfo).describe!(dep)}');
  staticPrint('\n--- 4. await non-Future ---');
  staticPrint('  awaitNonFuture: ${smAwait(awaitNonFuture())}');
  staticPrint('  awaitMixed: ${smAwait(awaitMixed())}');
  staticPrint('\n--- 5. deep async ---');
  staticPrint('  deepAsync(10): ${smAwait(deepAsync(10))}');
  staticPrint('  asyncErrorChain: ${smAwait(asyncErrorChain())}');
  staticPrint('  nestedTryAsync: ${smAwait(nestedTryAsync())}');
  staticPrint('\n--- 6. closure + async ---');
  staticPrint('  asyncWithClosure: ${smAwait(asyncWithClosure())}');
  staticPrint('  nestedClosureAsync: ${smAwait(nestedClosureAsync())}');
  staticPrint('\n--- 7. mixin + async ---');
  final ServiceValue svc = Service_new(GC.allocateLocal(ServiceValue()));
  final String r = smAwait((svc.classInfo as ServiceClassInfo).process!(svc, 'hello'));
  staticPrint('  process result: ${r}');
  staticPrint('  messages: ${svc.messages}');
  final String invalidResult = smAwait((svc.classInfo as ServiceClassInfo).process!(svc, ''));
  staticPrint('  invalid result: ${invalidResult}');
  staticPrint('\n--- 8. operators ---');
  final Vector2DValue v1 = Vector2D_new(GC.allocateLocal(Vector2DValue()), 1.0, 2.0);
  final Vector2DValue v2 = Vector2D_new(GC.allocateLocal(Vector2DValue()), 3.0, 4.0);
  staticPrint('  v1 + v2 = ${(v1.classInfo as Vector2DClassInfo).operatorPlus!(v1, v2)}');
  staticPrint('  v1 - v2 = ${(v1.classInfo as Vector2DClassInfo).operatorMinus!(v1, v2)}');
  staticPrint('  v1 * 3 = ${(v1.classInfo as Vector2DClassInfo).operatorStar!(v1, 3.0)}');
  staticPrint('  v1 == Vector2D(1,2): ${(v1 == Vector2D_new(GC.allocateLocal(Vector2DValue()), 1.0, 2.0))}');
  final Vector2DValue sum = sumVectors(StaticList<Vector2DValue>.of([v1, v2, Vector2D_new(GC.allocateLocal(Vector2DValue()), 5.0, 6.0)]));
  staticPrint('  sumVectors: ${sum}');
  final StaticList<Vector2DValue> scaled = StaticList<Vector2DValue>.of(scaleAll(StaticList<Vector2DValue>.of([v1, v2]), 2.0));
  staticPrint('  scaleAll: ${scaled}');
  staticPrint('\n--- 9. Records ---');
  final (String, int) na = nameAge('Alice', 30);
  staticPrint('  nameAge: (${na.$1}, ${na.$2})');
  final ({int age, String name, String role}) pi = personInfo('Bob', 25, 'dev');
  staticPrint('  personInfo: (${pi.name}, ${pi.age}, ${pi.role})');
  final StaticList<(String, int)> data = StaticList<(String, int)>.of([('Alice', 90), ('Bob', 85), ('Charlie', 95), ('Diana', 88)]);
  staticPrint('  topN(2): ${topN(data, 2)}');
  staticPrint('\n--- 10. Repository ---');
  final ItemRepoValue repo = ItemRepo_new(GC.allocateLocal(ItemRepoValue()));
  smAwait((repo.classInfo as ItemRepoClassInfo).save!(repo, '1', 'item-A'));
  smAwait((repo.classInfo as ItemRepoClassInfo).save!(repo, '2', 'item-B'));
  smAwait((repo.classInfo as ItemRepoClassInfo).save!(repo, '3', 'item-C'));
  staticPrint('  findById(1): ${smAwait((repo.classInfo as ItemRepoClassInfo).findById!(repo, '1'))}');
  staticPrint('  findAll: ${smAwait((repo.classInfo as ItemRepoClassInfo).findAll!(repo))}');
  staticPrint('  isCached(1): ${(repo.classInfo as ItemRepoClassInfo).isCached!(repo, '1')}');
  final String? cached = smAwait((repo.classInfo as ItemRepoClassInfo).cachedFindById!(repo, '2'));
  staticPrint('  cachedFindById(2): ${cached}');
  staticPrint('  isCached(2): ${(repo.classInfo as ItemRepoClassInfo).isCached!(repo, '2')}');
  (repo.classInfo as ItemRepoClassInfo).invalidate!(repo, '2');
  staticPrint('  after invalidate(2), isCached(2): ${(repo.classInfo as ItemRepoClassInfo).isCached!(repo, '2')}');
  staticPrint('\n--- 11. Factory constructors ---');
  staticPrint('  dev: ${Config_new_development()}');
  staticPrint('  prod: ${Config_new_production()}');
  staticPrint('  custom: ${Config_new_custom('staging', 9090)}');
  staticPrint('\n--- 12. Switch patterns ---');
{
    StaticIterator<Object> sync_for_iterator = StaticIterator(StaticList<Object>.of([(-5), 0, 42, '', 'hello', StaticList<int>.of([1, 2, 3]), true]).iterator);
    for (; sync_for_iterator.moveNext(); ) {
      final Object v = sync_for_iterator.current;
{
        staticPrint('  ${v} => ${describeValue(v)}');
      }
    }
  }
  staticPrint('\n=== all edge case tests passed ===');
  drainScheduler();
}

StaticList<String> log = StaticList<String>();
class ClosureEnv_Logger_logAsync_0 {
  dynamic this_;
  StringBox msg;
  Promise<void> _promise;
  ClosureEnv_Logger_logAsync_0(this.this_, String msg) : _promise = Promise<void>(), msg = StringBox(msg);
  void call() => ClosureEnv_Logger_logAsync_0_call(this);
}
void ClosureEnv_Logger_logAsync_0_call(ClosureEnv_Logger_logAsync_0 env) {
  smAwait(Promise.value<int>(0));
  (env.this_.classInfo as dynamic).get_messages!(env.this_).add('[async] ${env.msg.value}');
  env._promise.complete(0);
  return;
}
class ClosureEnv_Validator_validateAsync_1<T> {
  dynamic this_;
  ObjectBox<T> value;
  Promise<bool> _promise;
  ClosureEnv_Validator_validateAsync_1(this.this_, T value) : _promise = Promise<bool>(), value = ObjectBox<T>(value);
  void call() => ClosureEnv_Validator_validateAsync_1_call<T>(this);
}
void ClosureEnv_Validator_validateAsync_1_call<T>(ClosureEnv_Validator_validateAsync_1<T> env) {
  smAwait(Promise.value<int>(0));
{
    env._promise.complete((env.this_.classInfo as dynamic).validate!(env.this_, env.value.value));
    return;
  }
  env._promise.complete(false);
  return;
}
class ClosureEnv_Service_process_2 {
  ServiceValue this_;
  StringBox input;
  Promise<String> _promise;
  ClosureEnv_Service_process_2(this.this_, String input) : _promise = Promise<String>(), input = StringBox(input);
  void call() => ClosureEnv_Service_process_2_call(this);
}
void ClosureEnv_Service_process_2_call(ClosureEnv_Service_process_2 env) {
  (env.this_.classInfo as ServiceClassInfo).logSync!(env.this_, 'processing: ${env.input.value}');
  smAwait((env.this_.classInfo as ServiceClassInfo).logAsync!(env.this_, 'validating: ${env.input.value}'));
  final bool valid = smAwait((env.this_.classInfo as ServiceClassInfo).validateAsync!(env.this_, env.input.value));
  if (!(valid)) {
    env._promise.complete('invalid');
    return;
  }
  (env.this_.classInfo as ServiceClassInfo).logSync!(env.this_, 'done');
{
    env._promise.complete('ok: ${env.input.value}');
    return;
  }
  env._promise.complete('');
  return;
}
class ClosureEnv_InMemoryCache_cachedFindById_3<T> {
  dynamic this_;
  StringBox id;
  Promise<T?> _promise;
  ClosureEnv_InMemoryCache_cachedFindById_3(this.this_, String id) : _promise = Promise<T?>(), id = StringBox(id);
  void call() => ClosureEnv_InMemoryCache_cachedFindById_3_call<T>(this);
}
void ClosureEnv_InMemoryCache_cachedFindById_3_call<T>(ClosureEnv_InMemoryCache_cachedFindById_3<T> env) {
  if ((env.this_.classInfo as dynamic).isCached!(env.this_, env.id.value)) {
    env._promise.complete(env.this_._cache[env.id.value]);
    return;
  }
  final T? item = smAwait((env.this_.classInfo as dynamic).findById!(env.this_, env.id.value));
  if (!((item == null)))   env.this_._cache[env.id.value] = item;
{
    env._promise.complete(item);
    return;
  }
  env._promise.complete(null as T?);
  return;
}
class ClosureEnv_ItemRepo_findById_4 {
  ItemRepoValue this_;
  StringBox id;
  Promise<String?> _promise;
  ClosureEnv_ItemRepo_findById_4(this.this_, String id) : _promise = Promise<String?>(), id = StringBox(id);
  void call() => ClosureEnv_ItemRepo_findById_4_call(this);
}
void ClosureEnv_ItemRepo_findById_4_call(ClosureEnv_ItemRepo_findById_4 env) {
  smAwait(Promise.value<int>(0));
{
    env._promise.complete(env.this_._store[env.id.value]);
    return;
  }
  env._promise.complete(null as String?);
  return;
}
class ClosureEnv_ItemRepo_findAll_5 {
  ItemRepoValue this_;
  Promise<StaticList<String>> _promise;
  ClosureEnv_ItemRepo_findAll_5(this.this_) : _promise = Promise<StaticList<String>>();
  void call() => ClosureEnv_ItemRepo_findAll_5_call(this);
}
void ClosureEnv_ItemRepo_findAll_5_call(ClosureEnv_ItemRepo_findAll_5 env) {
  smAwait(Promise.value<int>(0));
{
    env._promise.complete(StaticList.of(env.this_._store.values.toList()));
    return;
  }
  env._promise.complete(null as StaticList<String>);
  return;
}
class ClosureEnv_ItemRepo_save_6 {
  ItemRepoValue this_;
  StringBox id;
  StringBox item;
  Promise<void> _promise;
  ClosureEnv_ItemRepo_save_6(this.this_, String id, String item) : _promise = Promise<void>(), id = StringBox(id), item = StringBox(item);
  void call() => ClosureEnv_ItemRepo_save_6_call(this);
}
void ClosureEnv_ItemRepo_save_6_call(ClosureEnv_ItemRepo_save_6 env) {
  smAwait(Promise.value<int>(0));
  env.this_._store[env.id.value] = env.item.value;
  env._promise.complete(0);
  return;
}
class ClosureEnv_logMessage_7 {
  StringBox msg;
  Promise<int> _promise;
  ClosureEnv_logMessage_7(String msg) : _promise = Promise<int>(), msg = StringBox(msg);
  void call() => ClosureEnv_logMessage_7_call(this);
}
void ClosureEnv_logMessage_7_call(ClosureEnv_logMessage_7 env) {
  final String prefix = smAwait(Promise.value<String>('[LOG]'));
  log.add('${prefix} ${env.msg.value}');
  env._promise.complete(0);
  return;
}
class ClosureEnv_logWithDelay_8 {
  StringBox msg;
  IntBox ticks;
  Promise<int> _promise;
  ClosureEnv_logWithDelay_8(String msg, int ticks) : _promise = Promise<int>(), msg = StringBox(msg), ticks = IntBox(ticks);
  void call() => ClosureEnv_logWithDelay_8_call(this);
}
void ClosureEnv_logWithDelay_8_call(ClosureEnv_logWithDelay_8 env) {
  smAwait(promiseDelayed<dynamic>(StaticDuration(milliseconds: (env.ticks.value * 10))));
  log.add(env.msg.value);
  env._promise.complete(0);
  return;
}
class ClosureEnv_safeLog_9 {
  StringBox msg;
  Promise<int> _promise;
  ClosureEnv_safeLog_9(String msg) : _promise = Promise<int>(), msg = StringBox(msg);
  void call() => ClosureEnv_safeLog_9_call(this);
}
void ClosureEnv_safeLog_9_call(ClosureEnv_safeLog_9 env) {
  try {
    final String result = smAwait(Promise.value<String>(env.msg.value));
    log.add('safe: ${result}');
  }
 catch (e) {
    log.add('error: ${e}');
  }
  env._promise.complete(0);
  return;
}
class ClosureEnv_awaitNonFuture_10 {
  Promise<int> _promise;
  ClosureEnv_awaitNonFuture_10() : _promise = Promise<int>();
  void call() => ClosureEnv_awaitNonFuture_10_call(this);
}
void ClosureEnv_awaitNonFuture_10_call(ClosureEnv_awaitNonFuture_10 env) {
  final int a = smAwait(42);
  final String b = smAwait('hello');
  final bool c = smAwait(true);
{
    env._promise.complete(((a + b.length) + (c ? 1 : 0)));
    return;
  }
  env._promise.complete(0);
  return;
}
class ClosureEnv_awaitMixed_11 {
  Promise<String> _promise;
  ClosureEnv_awaitMixed_11() : _promise = Promise<String>();
  void call() => ClosureEnv_awaitMixed_11_call(this);
}
void ClosureEnv_awaitMixed_11_call(ClosureEnv_awaitMixed_11 env) {
  final int x = smAwait(Promise.value<int>(10));
  final int y = smAwait(20);
  final int z = smAwait(Promise.value<int>(30));
{
    env._promise.complete('sum=${((x + y) + z)}');
    return;
  }
  env._promise.complete('');
  return;
}
class ClosureEnv_deepAsync_12 {
  IntBox depth;
  Promise<int> _promise;
  ClosureEnv_deepAsync_12(int depth) : _promise = Promise<int>(), depth = IntBox(depth);
  void call() => ClosureEnv_deepAsync_12_call(this);
}
void ClosureEnv_deepAsync_12_call(ClosureEnv_deepAsync_12 env) {
  if ((env.depth.value <= 0)) {
    env._promise.complete(1);
    return;
  }
  final int sub = smAwait(deepAsync((env.depth.value - 1)));
{
    env._promise.complete((sub + env.depth.value));
    return;
  }
  env._promise.complete(0);
  return;
}
class ClosureEnv_asyncErrorChain_13 {
  Promise<String> _promise;
  ClosureEnv_asyncErrorChain_13() : _promise = Promise<String>();
  void call() => ClosureEnv_asyncErrorChain_13_call(this);
}
void ClosureEnv_asyncErrorChain_13_call(ClosureEnv_asyncErrorChain_13 env) {
  try {
    final int v = smAwait(_failingAsync());
{
      env._promise.complete('unexpected: ${v}');
      return;
    }
  }
 catch (e) {
{
      env._promise.complete('caught: ${e}');
      return;
    }
  }
  env._promise.complete('');
  return;
}
class ClosureEnv__failingAsync_14 {
  Promise<int> _promise;
  ClosureEnv__failingAsync_14() : _promise = Promise<int>();
  void call() => ClosureEnv__failingAsync_14_call(this);
}
void ClosureEnv__failingAsync_14_call(ClosureEnv__failingAsync_14 env) {
  smAwait(Promise.value<int>(0));
  throw Exception(StringBox('deep failure'));
  env._promise.complete(0);
  return;
}
class ClosureEnv_nestedTryAsync_15 {
  Promise<String> _promise;
  ClosureEnv_nestedTryAsync_15() : _promise = Promise<String>();
  void call() => ClosureEnv_nestedTryAsync_15_call(this);
}
void ClosureEnv_nestedTryAsync_15_call(ClosureEnv_nestedTryAsync_15 env) {
  final StaticList<String> steps = StaticList<String>();
  try {
    steps.add('outer-try');
    try {
      steps.add('inner-try');
      smAwait(Promise.value<int>(1));
      throw Exception(StringBox('inner'));
    }
 catch (e) {
      steps.add('inner-catch: ${e}');
      throw Exception(StringBox('rethrown'));
    }
 finally {
      steps.add('inner-finally');
    }
  }
 catch (e) {
    steps.add('outer-catch: ${e}');
  }
 finally {
    steps.add('outer-finally');
  }
{
    env._promise.complete(steps.join(' -> '));
    return;
  }
  env._promise.complete('');
  return;
}
class ClosureEnv_asyncWithClosure_16 {
  Promise<String> _promise;
  ClosureEnv_asyncWithClosure_16() : _promise = Promise<String>();
  void call() => ClosureEnv_asyncWithClosure_16_call(this);
}
void ClosureEnv_asyncWithClosure_16_call(ClosureEnv_asyncWithClosure_16 env) {
  String prefix = 'result';
  String format(int value) {
    return '${prefix}: ${value}';
  }

  final int v = smAwait(Promise.value<int>(42));
{
    env._promise.complete(format(v));
    return;
  }
  env._promise.complete('');
  return;
}
class ClosureEnv_nestedClosureAsync_17 {
  Promise<String> _promise;
  ClosureEnv_nestedClosureAsync_17() : _promise = Promise<String>();
  void call() => ClosureEnv_nestedClosureAsync_17_call(this);
}
void ClosureEnv_nestedClosureAsync_17_call(ClosureEnv_nestedClosureAsync_17 env) {
  String outer = 'start';
  String transform(String input) {
    String inner = input;
    String apply() {
      return '${outer}->${inner}';
    }

    return apply();
  }

  final String result = smAwait(Promise.value<String>(transform('hello')));
  outer = 'end';
{
    env._promise.complete('${result}|${outer}');
    return;
  }
  env._promise.complete('');
  return;
}
class ClosureEnv_sumVectors_18 extends TypeFunction2<Vector2DValue, Vector2DValue, Vector2DValue> {
  ClosureEnv_sumVectors_18();
  @override
  Vector2DValue call(Vector2DValue a, Vector2DValue b) => fnPtr(this, a, b);
}
ClosureEnv_sumVectors_18 ClosureEnv_sumVectors_18_new(ClosureEnv_sumVectors_18 env_) {
  env_.fnPtr = ClosureEnv_sumVectors_18_call;
  return env_;
}
Vector2DValue ClosureEnv_sumVectors_18_call(AnyGC env__, Vector2DValue a, Vector2DValue b) {
  final env = env__ as ClosureEnv_sumVectors_18;

  return (a.classInfo as Vector2DClassInfo).operatorPlus!(a, b);
}

class ClosureEnv_scaleAll_19 extends TypeFunction1<Vector2DValue, Vector2DValue> {
  late DoubleBox factor;
  ClosureEnv_scaleAll_19();
  @override
  Vector2DValue call(Vector2DValue v) => fnPtr(this, v);
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
    if (factor is AnyGC) (factor as AnyGC).gcMark(flag);
  }
}
ClosureEnv_scaleAll_19 ClosureEnv_scaleAll_19_new(ClosureEnv_scaleAll_19 env_, DoubleBox factor) {
  env_.fnPtr = ClosureEnv_scaleAll_19_call;
  env_.factor = factor;
  return env_;
}
Vector2DValue ClosureEnv_scaleAll_19_call(AnyGC env__, Vector2DValue v) {
  final env = env__ as ClosureEnv_scaleAll_19;

  return (v.classInfo as Vector2DClassInfo).operatorStar!(v, env.factor.value);
}

class ClosureEnv_topN_20 extends TypeFunction2<int, (String, int), (String, int)> {
  ClosureEnv_topN_20();
  @override
  int call((String, int) a, (String, int) b) => fnPtr(this, a, b);
}
ClosureEnv_topN_20 ClosureEnv_topN_20_new(ClosureEnv_topN_20 env_) {
  env_.fnPtr = ClosureEnv_topN_20_call;
  return env_;
}
int ClosureEnv_topN_20_call(AnyGC env__, (String, int) a, (String, int) b) {
  final env = env__ as ClosureEnv_topN_20;

  return b.$2.compareTo(a.$2);
}

