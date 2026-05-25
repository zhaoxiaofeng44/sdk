/// Dart2Cpp restorer 运行时基础类定义
///
/// 包含 VPtr 虚函数表基类和 Box 类型（闭包引用语义）。
/// 由 dart_restorer 生成的还原代码通过 import 引入本文件。

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
