/// Dart2Cpp restorer 运行时基础类定义
///
/// 包含 VPtr 虚函数表基类和 Box 类型（闭包引用语义）。
/// 由 dart_restorer 生成的还原代码通过 import 引入本文件。

import 'dart:collection';

/// VPtr 基类 - 所有无基类（或继承自 Object）的 Value 类都继承自它。
/// 提供 vptr 字段和 toString/operator==/hashCode 的桥接覆写。
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

/// Box 类型定义（闭包引用语义）
/// 用于在闭包中捕获可变的值类型变量。

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

// ============================================================================
// 静态集合类 — 不继承原生 List/Map/Set，基于 Array 统一管理内部存储
// ============================================================================

/// Array<T> — 底层存储容器，所有静态集合类的基础。
/// 提供固定大小和动态增长两种模式的元素管理。
class Array<T> {
  final List<T> _storage;
  int _length;

  /// 创建固定大小的 Array，元素为 null（需要 T 为 nullable）或通过 fill 指定默认值
  Array(int size, {T? fill})
      : _storage = List<T>.filled(size, fill as T),
        _length = size;

  /// 从现有可迭代对象创建 Array
  Array.from(Iterable<T> elements)
      : _storage = List<T>.from(elements),
        _length = elements.length;

  /// 创建空的动态 Array
  Array.empty()
      : _storage = <T>[],
        _length = 0;

  int get length => _length;

  T operator [](int index) {
    if (index < 0 || index >= _length) {
      throw RangeError.index(index, this, 'index', null, _length);
    }
    return _storage[index];
  }

  void operator []=(int index, T value) {
    if (index < 0 || index >= _length) {
      throw RangeError.index(index, this, 'index', null, _length);
    }
    _storage[index] = value;
  }

  void add(T element) {
    _storage.add(element);
    _length++;
  }

  void insert(int index, T element) {
    _storage.insert(index, element);
    _length++;
  }

  T removeAt(int index) {
    if (index < 0 || index >= _length) {
      throw RangeError.index(index, this, 'index', null, _length);
    }
    final removed = _storage.removeAt(index);
    _length--;
    return removed;
  }

  bool remove(T element) {
    final idx = indexOf(element);
    if (idx == -1) return false;
    removeAt(idx);
    return true;
  }

  int indexOf(T element) {
    for (int i = 0; i < _length; i++) {
      if (_storage[i] == element) return i;
    }
    return -1;
  }

  bool contains(T element) => indexOf(element) != -1;

  void clear() {
    _storage.clear();
    _length = 0;
  }

  Iterable<T> get iterable => _storage.take(_length);

  List<T> toList() => List<T>.from(_storage.take(_length));

  @override
  String toString() => 'Array(${_storage.take(_length).join(', ')})';
}

/// StaticList<T> — 静态列表，implements List<T> 接口，内部基于 Array<T> 独立管理数据。
class StaticList<T> with ListMixin<T> {
  final Array<T> _data;

  StaticList._internal(this._data);

  StaticList() : _data = Array<T>.empty();

  StaticList.of(Iterable<T> elements) : _data = Array<T>.from(elements);

  StaticList.filled(int length, T fill) : _data = Array<T>(length, fill: fill);

  StaticList.unmodifiable(Iterable<T> elements) : _data = Array<T>.from(elements);

  StaticList.empty({bool growable = true}) : _data = Array<T>.empty();

  StaticList.generate(int length, T Function(int index) generator)
      : _data = Array<T>.empty() {
    for (int i = 0; i < length; i++) {
      _data.add(generator(i));
    }
  }

  StaticList.from(Iterable elements) : _data = Array<T>.from(elements.cast<T>());

  // -- List<T> 核心接口 --

  @override
  int get length => _data.length;

  @override
  set length(int newLength) {
    if (newLength < _data.length) {
      while (_data.length > newLength) {
        _data.removeAt(_data.length - 1);
      }
    } else {
      while (_data.length < newLength) {
        _data.add(null as T);
      }
    }
  }

  @override
  T operator [](int index) => _data[index];

  @override
  void operator []=(int index, T value) => _data[index] = value;

  @override
  void add(T element) => _data.add(element);

  @override
  void addAll(Iterable<T> elements) {
    for (final element in elements) {
      _data.add(element);
    }
  }

  @override
  StaticList<T> sublist(int start, [int? end]) {
    final actualEnd = end ?? length;
    return StaticList<T>.of(super.sublist(start, actualEnd));
  }

  @override
  StaticList<T> toList({bool growable = true}) {
    return StaticList<T>.of(this);
  }

  @override
  StaticList<R> cast<R>() {
    return StaticList<R>.of(super.cast<R>());
  }

  @override
  StaticList<T> operator +(List<T> other) {
    final result = StaticList<T>.of(this);
    result.addAll(other);
    return result;
  }

  @override
  String toString() => '[${join(', ')}]';
}

/// StaticMap<K, V> — implements Map<K,V>，内部基于 Array 独立管理键值对。
class StaticMap<K, V> with MapMixin<K, V> {
  final Array<K> _keys;
  final Array<V> _values;

  StaticMap()
      : _keys = Array<K>.empty(),
        _values = Array<V>.empty();

  StaticMap.of(Map<K, V> entries)
      : _keys = Array<K>.from(entries.keys),
        _values = Array<V>.from(entries.values);

  StaticMap.from(Map entries)
      : _keys = Array<K>.from(entries.keys.cast<K>()),
        _values = Array<V>.from(entries.values.cast<V>());

  StaticMap.fromEntries(Iterable<MapEntry<K, V>> entries)
      : _keys = Array<K>.empty(),
        _values = Array<V>.empty() {
    for (final entry in entries) {
      _keys.add(entry.key);
      _values.add(entry.value);
    }
  }

  StaticMap.fromIterables(Iterable<K> keys, Iterable<V> values)
      : _keys = Array<K>.from(keys),
        _values = Array<V>.from(values);

  // -- Map<K,V> 核心接口 --

  @override
  V? operator [](Object? key) {
    final idx = _keys.indexOf(key as K);
    if (idx == -1) return null;
    return _values[idx];
  }

  @override
  void operator []=(K key, V value) {
    final idx = _keys.indexOf(key);
    if (idx != -1) {
      _values[idx] = value;
    } else {
      _keys.add(key);
      _values.add(value);
    }
  }

  @override
  Iterable<K> get keys => StaticList<K>._internal(_keys);

  @override
  V? remove(Object? key) {
    final idx = _keys.indexOf(key as K);
    if (idx == -1) return null;
    _keys.removeAt(idx);
    return _values.removeAt(idx);
  }

  @override
  void clear() {
    _keys.clear();
    _values.clear();
  }

  @override
  StaticMap<K2, V2> map<K2, V2>(MapEntry<K2, V2> Function(K key, V value) convert) {
    final result = StaticMap<K2, V2>();
    for (int i = 0; i < _keys.length; i++) {
      final entry = convert(_keys[i], _values[i]);
      result[entry.key] = entry.value;
    }
    return result;
  }

  @override
  StaticMap<RK, RV> cast<RK, RV>() {
    return StaticMap<RK, RV>.of(super.cast<RK, RV>());
  }
}

/// StaticSet<T> — implements Set<T>，内部基于 Array<T> 管理元素（保证唯一性）。
class StaticSet<T> with SetMixin<T> {
  final Array<T> _data;

  StaticSet() : _data = Array<T>.empty();

  StaticSet.of(Iterable<T> elements) : _data = Array<T>.empty() {
    for (final element in elements) {
      add(element);
    }
  }

  StaticSet.from(Iterable elements) : _data = Array<T>.empty() {
    for (final element in elements) {
      add(element as T);
    }
  }

  // -- Set<T> 核心接口 --

  @override
  bool add(T element) {
    if (_data.contains(element)) return false;
    _data.add(element);
    return true;
  }

  @override
  bool contains(Object? element) {
    try {
      return _data.contains(element as T);
    } catch (_) {
      return false;
    }
  }

  @override
  T? lookup(Object? element) {
    try {
      final idx = _data.indexOf(element as T);
      if (idx == -1) return null;
      return _data[idx];
    } catch (_) {
      return null;
    }
  }

  @override
  bool remove(Object? element) {
    try {
      return _data.remove(element as T);
    } catch (_) {
      return false;
    }
  }

  @override
  Iterator<T> get iterator => _StaticSetIterator<T>(this);

  @override
  int get length => _data.length;

  @override
  StaticSet<T> toSet() => StaticSet<T>.of(this);

  @override
  StaticSet<T> union(Set<T> other) {
    final result = StaticSet<T>.of(this);
    for (final element in other) {
      result.add(element);
    }
    return result;
  }

  @override
  StaticSet<T> intersection(Set<Object?> other) {
    final result = StaticSet<T>();
    for (int i = 0; i < _data.length; i++) {
      if (other.contains(_data[i])) {
        result.add(_data[i]);
      }
    }
    return result;
  }

  @override
  StaticSet<T> difference(Set<Object?> other) {
    final result = StaticSet<T>();
    for (int i = 0; i < _data.length; i++) {
      if (!other.contains(_data[i])) {
        result.add(_data[i]);
      }
    }
    return result;
  }

  @override
  StaticSet<R> cast<R>() {
    return StaticSet<R>.of(super.cast<R>());
  }

  @override
  String toString() => '{${join(', ')}}';
}

/// StaticSet 的迭代器实现
class _StaticSetIterator<T> implements Iterator<T> {
  final StaticSet<T> _set;
  int _index = -1;

  _StaticSetIterator(this._set);

  @override
  T get current => _set._data[_index];

  @override
  bool moveNext() {
    _index++;
    return _index < _set._data.length;
  }
}

// ============================================================================
// 状态机协程基础类 — 替代 async/await
// ============================================================================

enum PromiseState { ready, pending, completed, error }

/// Promise — 统一的异步结果容器，同时也是调度的基本单元
///
/// 职责：
/// - 持有状态（ready/pending/completed/error）和结果
/// - 持有 _onTick 回调，由 GlobalScheduler 每 tick 驱动推进
/// - 提供 complete/completeError 操作
/// - 提供工厂方法（value/delayed）和链式调用（then）
class Promise<T> {
  PromiseState state = PromiseState.pending;
  T? _result;
  Object? error;
  void Function()? _startCallback;

  /// 每 tick 被 GlobalScheduler 调用来推进此 Promise 的逻辑。
  /// 返回 true 表示已完成，应从活跃列表移除。
  bool Function()? _onTick;

  bool get isCompleted => state == PromiseState.completed;
  bool get isError => state == PromiseState.error;
  bool get isPending => state == PromiseState.pending;
  bool get isReady => state == PromiseState.ready;

  T get result {
    if (state == PromiseState.error) throw error!;
    if (state != PromiseState.completed) {
      throw StateError('Promise not yet completed');
    }
    return _result as T;
  }

  /// 设置启动回调并将状态切换为 ready。
  /// GlobalScheduler 在下一轮 tick 时会统一触发所有 ready 状态的 Promise，
  /// 调用其 _startCallback 并将状态改为 pending。
  void setStartCallback(void Function() callback) {
    _startCallback = callback;
    state = PromiseState.ready;
    GlobalScheduler.instance.registerReadyPromise(this);
  }

  /// 由 GlobalScheduler 调用：触发启动回调，状态 ready → pending
  void _fireStartCallback() {
    if (state != PromiseState.ready || _startCallback == null) return;
    state = PromiseState.pending;
    _startCallback!();
    _startCallback = null;
  }

  void complete(T value) {
    if (state == PromiseState.completed || state == PromiseState.error) {
      throw StateError('Promise already resolved');
    }
    _result = value;
    state = PromiseState.completed;
  }

  void completeError(Object err) {
    if (state == PromiseState.completed || state == PromiseState.error) {
      throw StateError('Promise already resolved');
    }
    error = err;
    state = PromiseState.error;
  }

  static Promise<T> value<T>(T val) {
    final promise = Promise<T>();
    promise.complete(val);
    return promise;
  }

  static Promise<T> delayed<T>(int delayTicks, T Function() computation) {
    final promise = Promise<T>();
    GlobalScheduler.instance.registerDelayedTask(delayTicks, () {
      try {
        promise.complete(computation());
      } catch (e) {
        promise.completeError(e);
      }
    });
    return promise;
  }

  /// 链式调用：当本 Promise 完成时，执行 onValue 并将结果传递给新 Promise。
  /// 支持 flatMap 语义：若 onValue 返回 Promise<R>，自动展平为 Promise<R>。
  Promise<R> then<R>(dynamic Function(T) onValue) {
    final nextPromise = Promise<R>();
    nextPromise._onTick = () {
      if (isCompleted) {
        try {
          final dynamic callbackResult = onValue(result);
          if (callbackResult is Promise<R>) {
            // flatMap: 等待内层 Promise 完成后传递
            nextPromise._onTick = () {
              if (callbackResult.isCompleted) {
                nextPromise.complete(callbackResult.result);
                return true;
              }
              if (callbackResult.isError) {
                nextPromise.completeError(callbackResult.error!);
                return true;
              }
              return false;
            };
            return false; // 保持活跃，等内层完成
          }
          nextPromise.complete(callbackResult as R);
        } catch (e) {
          nextPromise.completeError(e);
        }
        return true;
      }
      if (isError) {
        nextPromise.completeError(error!);
        return true;
      }
      return false;
    };
    GlobalScheduler.instance.registerActivePromise(nextPromise);
    return nextPromise;
  }

  /// 错误处理链：当本 Promise 出错时，执行 onError 恢复
  Promise<T> catchError(T Function(Object) onError) {
    final nextPromise = Promise<T>();
    nextPromise._onTick = () {
      if (isCompleted) {
        nextPromise.complete(result);
        return true;
      }
      if (isError) {
        try {
          nextPromise.complete(onError(error!));
        } catch (e) {
          nextPromise.completeError(e);
        }
        return true;
      }
      return false;
    };
    GlobalScheduler.instance.registerActivePromise(nextPromise);
    return nextPromise;
  }

  /// 无论成功失败都执行 action，然后传递原始结果/错误
  Promise<T> whenComplete(void Function() action) {
    final nextPromise = Promise<T>();
    nextPromise._onTick = () {
      if (isCompleted) {
        try {
          action();
          nextPromise.complete(result);
        } catch (e) {
          nextPromise.completeError(e);
        }
        return true;
      }
      if (isError) {
        try {
          action();
        } catch (_) {}
        nextPromise.completeError(error!);
        return true;
      }
      return false;
    };
    GlobalScheduler.instance.registerActivePromise(nextPromise);
    return nextPromise;
  }
}

/// 全局调度器 — 统一通过 Promise 驱动所有异步任务
class GlobalScheduler {
  static final GlobalScheduler instance = GlobalScheduler._();
  GlobalScheduler._();

  final List<Promise> _activePromises = [];
  final List<_DelayedTask> _delayedTasks = [];
  final List<Promise> _readyPromises = [];
  int _currentTick = 0;

  int get currentTick => _currentTick;

  /// 注册一个有 _onTick 的活跃 Promise，每 tick 被驱动
  void registerActivePromise(Promise promise) {
    _activePromises.add(promise);
  }

  void registerDelayedTask(int delayTicks, void Function() callback) {
    _delayedTasks.add(_DelayedTask(_currentTick + delayTicks, callback));
  }

  /// 注册一个 ready 状态的 Promise，等待下一轮 tick 触发其启动回调
  void registerReadyPromise(Promise promise) {
    _readyPromises.add(promise);
  }

  void tick() {
    _currentTick++;

    // 第一阶段：触发所有 ready 状态的 Promise 的启动回调
    final readySnapshot = List.of(_readyPromises);
    _readyPromises.clear();
    for (final promise in readySnapshot) {
      if (promise.isReady) {
        promise._fireStartCallback();
      }
    }

    // 第二阶段：触发到期的延迟任务
    final expired = _delayedTasks.where((t) => t.targetTick <= _currentTick).toList();
    _delayedTasks.removeWhere((t) => t.targetTick <= _currentTick);
    for (final task in expired) {
      task.callback();
    }

    // 第三阶段：驱动所有活跃 Promise
    final snapshot = List.of(_activePromises);
    final finished = <Promise>{};
    for (final promise in snapshot) {
      if (promise.isCompleted || promise.isError) {
        finished.add(promise);
        continue;
      }
      final onTick = promise._onTick;
      if (onTick != null && onTick()) {
        finished.add(promise);
      }
    }
    _activePromises.removeWhere((p) => finished.contains(p));
  }

  void reset() {
    _activePromises.clear();
    _delayedTasks.clear();
    _readyPromises.clear();
    _currentTick = 0;
  }
}

class _DelayedTask {
  final int targetTick;
  final void Function() callback;
  _DelayedTask(this.targetTick, this.callback);
}

/// promiseDelayed — 兼容 Future.delayed(Duration, [computation]) 的异步延迟函数
/// Duration 按 10ms = 1 tick 映射，最小 1 tick。
Promise<T> promiseDelayed<T>(Duration duration, [T Function()? computation]) {
  final ticks = (duration.inMilliseconds / 10).ceil().clamp(1, 100000);
  final promise = Promise<T>();
  GlobalScheduler.instance.registerDelayedTask(ticks, () {
    try {
      if (computation != null) {
        promise.complete(computation());
      } else {
        promise.complete(null as T);
      }
    } catch (e) {
      promise.completeError(e);
    }
  });
  return promise;
}

/// smAwait 递归深度计数器（防止 ClosureEnv 模式下深层递归栈溢出）
int _smAwaitDepth = 0;
const int _smAwaitMaxDepth = 500;

/// smAwait — 状态机版 await，循环调 tick() 直到 promise 完成。
/// 也兼容原生 Future（如 async* Stream.toList() 返回的 Future），
/// 通过同步阻塞等待完成。
///
/// 注意：smAwait 内部递归调用 tick()，tick() 可能触发 _startCallback，
/// _startCallback 内部可能再次调用 smAwait，形成栈上递归。
/// 通过 _smAwaitDepth 限制递归深度，防止栈溢出。
T smAwait<T>(dynamic promiseOrFuture) {
  _smAwaitDepth++;
  if (_smAwaitDepth > _smAwaitMaxDepth) {
    _smAwaitDepth--;
    throw StateError(
      'smAwait recursion depth exceeded $_smAwaitMaxDepth — '
      'consider using AsyncStateMachine for deep async nesting');
  }
  try {
    return _smAwaitImpl<T>(promiseOrFuture);
  } finally {
    _smAwaitDepth--;
  }
}

T _smAwaitImpl<T>(dynamic promiseOrFuture) {
  if (promiseOrFuture is Promise<T>) {
    int roundCount = 0;
    while (!promiseOrFuture.isCompleted && !promiseOrFuture.isError) {
      GlobalScheduler.instance.tick();
      roundCount++;
      if (roundCount > 100000) {
        throw StateError('smAwait exceeded max rounds — possible deadlock');
      }
    }
    if (promiseOrFuture.isError) throw promiseOrFuture.error!;
    return promiseOrFuture.result;
  }
  // 兼容原生 Future（如 async* Stream.toList() 产生的 Future）
  if (promiseOrFuture is Future<T>) {
    T? result;
    Object? error;
    bool done = false;
    promiseOrFuture.then((v) {
      result = v;
      done = true;
    }, onError: (e) {
      error = e;
      done = true;
    });
    int roundCount = 0;
    while (!done) {
      GlobalScheduler.instance.tick();
      roundCount++;
      if (roundCount > 100000) {
        throw StateError('smAwait(Future) exceeded max rounds — possible deadlock');
      }
    }
    if (error != null) throw error!;
    return result as T;
  }
  // 如果是 Promise 但泛型不完全匹配（如 Promise<dynamic>）
  if (promiseOrFuture is Promise) {
    int roundCount = 0;
    while (!promiseOrFuture.isCompleted && !promiseOrFuture.isError) {
      GlobalScheduler.instance.tick();
      roundCount++;
      if (roundCount > 100000) {
        throw StateError('smAwait exceeded max rounds — possible deadlock');
      }
    }
    if (promiseOrFuture.isError) throw promiseOrFuture.error!;
    return promiseOrFuture.result as T;
  }
  throw StateError('smAwait: unsupported type ${promiseOrFuture.runtimeType}');
}

/// AsyncStateMachine — 异步函数转状态机的基类
///
/// 通过 Promise._onTick 驱动，不再依赖独立的 _stateMachines 列表。
abstract class AsyncStateMachine<T> {
  int smState = 0;
  final Promise<T> promise = Promise<T>();

  /// 子类实现：推进状态机一步。返回 true 表示已完成。
  bool step();

  void completeWith(T value) { promise.complete(value); }
  void completeWithError(Object error) { promise.completeError(error); }

  Promise<T> start() {
    promise._onTick = step;
    GlobalScheduler.instance.registerActivePromise(promise);
    return promise;
  }
}
