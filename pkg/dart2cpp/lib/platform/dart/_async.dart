/// 状态机协程基础类 — 替代 async/await
///
/// 包含：PromiseState, Promise, GlobalScheduler, _DelayedTask,
///       promiseDelayed, smAwait, AsyncStateMachine

import '_gc.dart';
import '_exceptions.dart';
import '_wrappers.dart' show StaticDuration;

// ============================================================================
// PromiseState
// ============================================================================

enum PromiseState { ready, pending, completed, error }

// ============================================================================
// Promise<T> — 统一的异步结果容器
// ============================================================================

/// Promise — 统一的异步结果容器，同时也是调度的基本单元
///
/// 职责：
/// - 持有状态（ready/pending/completed/error）和结果
/// - 持有 _onTick 回调，由 GlobalScheduler 每 tick 驱动推进
/// - 提供 complete/completeError 操作
/// - 提供工厂方法（value/delayed）和链式调用（then）
class Promise<T> extends AnyGC {
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

  /// gcMark — 递归标记所有 GC 子对象
  /// 标记 _result、error，以及 _onTick/_startCallback（restorer 生成的闭包
  /// 是 TypeFunctionN 子类，继承 AnyGC）。
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
    if (_result is AnyGC) (_result as AnyGC).gcMark(flag);
    if (error is AnyGC) (error as AnyGC).gcMark(flag);
    // 闭包字段：restorer 生成的闭包是 TypeFunctionN（extends AnyGC），
    // 原生 Dart 函数（void Function()）不是 AnyGC，is 检查自动跳过。
    if (_onTick is AnyGC) (_onTick as AnyGC).gcMark(flag);
    if (_startCallback is AnyGC) (_startCallback as AnyGC).gcMark(flag);
  }

  T get result {
    if (state == PromiseState.error) throw error!;
    if (state != PromiseState.completed) {
      throw DartStateError('Promise not yet completed');
    }
    return _result as T;
  }

  /// 设置 tick 回调并注册到 Scheduler 活跃列表。
  /// 每 tick 被 GlobalScheduler 调用，返回 true 表示已完成。
  /// 供 AsyncStateMachine 和外部测试使用。
  void setTickCallback(bool Function() onTick) {
    _onTick = onTick;
    GC.allocateLocal(this);
    GlobalScheduler.instance.registerActivePromise(this);
  }

  /// 设置启动回调并将状态切换为 ready。
  /// GlobalScheduler 在下一轮 tick 时会统一触发所有 ready 状态的 Promise，
  /// 调用其 _startCallback 并将状态改为 pending。
  void setStartCallback(void Function() callback) {
    _startCallback = callback;
    GC.allocateLocal(this);
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
      throw DartStateError('Promise already resolved');
    }
    _result = value;
    state = PromiseState.completed;
  }

  void completeError(Object err) {
    if (state == PromiseState.completed || state == PromiseState.error) {
      throw DartStateError('Promise already resolved');
    }
    error = err;
    state = PromiseState.error;
  }

  static Promise<T> value<T>(T val) {
    final promise = Promise<T>();
    promise.complete(val);
    return promise;
  }

  static Promise<T> rejected<T>(Object err) {
    final promise = Promise<T>();
    promise.completeError(err);
    return promise;
  }

  static Promise<T> delayed<T>(int delayTicks, T Function() computation) {
    final promise = GC.allocateLocal(Promise<T>());
    GlobalScheduler.instance.registerDelayedTask(delayTicks, () {
      try {
        promise.complete(computation());
      } catch (e) {
        promise.completeError(e);
      }
    }, promise);
    return promise;
  }

  /// 链式调用：当本 Promise 完成时，执行 onValue 并将结果传递给新 Promise。
  /// 支持 flatMap 语义：若 onValue 返回 Promise<R>，自动展平为 Promise<R>。
  Promise<R> then<R>(dynamic Function(T) onValue) {
    final nextPromise = GC.allocateLocal(Promise<R>());
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
    final nextPromise = GC.allocateLocal(Promise<T>());
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
    final nextPromise = GC.allocateLocal(Promise<T>());
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

// ============================================================================
// GlobalScheduler — 全局调度器
// ============================================================================

/// 全局调度器 — 统一通过 Promise 驱动所有异步任务
///
/// 继承 AnyGC 并注册为 GC root，确保 Scheduler 持有的所有 Promise
/// 和延迟任务闭包在标记阶段可达。在 C++ 环境中这是防止悬挂指针的关键。
class GlobalScheduler extends AnyGC {
  static final GlobalScheduler instance = GlobalScheduler._();

  GlobalScheduler._() {
    // 将 Scheduler 自身注册为 GC root，确保标记阶段可达所有异步对象
    GC.allocateGlobal(this);
  }

  final List<Promise> _activePromises = [];
  final List<_DelayedTask> _delayedTasks = [];
  final List<Promise> _readyPromises = [];
  int _currentTick = 0;

  int get currentTick => _currentTick;

  /// gcMark — 从 Scheduler root 出发，递归标记所有持有的 Promise
  /// 和延迟任务闭包。这是 C++ 环境防止悬挂指针的关键。
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
    for (final p in _activePromises) {
      p.gcMark(flag);
    }
    for (final p in _readyPromises) {
      p.gcMark(flag);
    }
    for (final t in _delayedTasks) {
      // 标记延迟任务关联的 Promise（通过 targetPromise 字段）
      if (t.targetPromise != null) t.targetPromise!.gcMark(flag);
      // 回调闭包：restorer 生成的闭包是 TypeFunctionN（extends AnyGC）
      if (t.callback is AnyGC) (t.callback as AnyGC).gcMark(flag);
    }
  }

  /// 注册一个有 _onTick 的活跃 Promise，每 tick 被驱动
  void registerActivePromise(Promise promise) {
    _activePromises.add(promise);
  }

  void registerDelayedTask(int delayTicks, void Function() callback,
      [Promise? targetPromise]) {
    _delayedTasks.add(_DelayedTask(_currentTick + delayTicks, callback, targetPromise));
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
    // 重置 gcFlag，防止与下一轮 GC flag 值冲突
    gcFlag = 0;
    // 重新注册为 GC root（GC.reset() 会清除所有 root）
    GC.allocateGlobal(this);
  }
}

class _DelayedTask {
  final int targetTick;
  final void Function() callback;
  /// 延迟任务关联的 Promise（用于 GC 标记，可为 null）
  final Promise? targetPromise;
  _DelayedTask(this.targetTick, this.callback, [this.targetPromise]);
}

// ============================================================================
// promiseDelayed — 兼容 Future.delayed 的异步延迟函数
// ============================================================================

/// promiseDelayed — 兼容 Future.delayed(Duration, [computation]) 的异步延迟函数
/// StaticDuration 按 10ms = 1 tick 映射，最小 1 tick。
Promise<T> promiseDelayed<T>(StaticDuration duration, [T Function()? computation]) {
  final ticks = (duration.inMilliseconds / 10).ceil().clamp(1, 100000);
  final promise = GC.allocateLocal(Promise<T>());
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
  }, promise);
  return promise;
}

// ============================================================================
// smAwait — 状态机版 await
// ============================================================================

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
    throw DartStateError(
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
        throw DartStateError('smAwait exceeded max rounds — possible deadlock');
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
        throw DartStateError('smAwait(Future) exceeded max rounds — possible deadlock');
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
        throw DartStateError('smAwait exceeded max rounds — possible deadlock');
      }
    }
    if (promiseOrFuture.isError) throw promiseOrFuture.error!;
    return promiseOrFuture.result as T;
  }
  // Dart 语义：await 非 Future/Promise 值 → 自动包装为已完成的 Future 并返回
  // 例如: await 42 等价于 await Future.value(42)
  return promiseOrFuture as T;
}

// ============================================================================
// AsyncStateMachine<T> — 异步函数转状态机的基类
// ============================================================================

/// AsyncStateMachine — 异步函数转状态机的基类
///
/// 通过 Promise._onTick 驱动，不再依赖独立的 _stateMachines 列表。
abstract class AsyncStateMachine<T> extends AnyGC {
  int smState = 0;
  final Promise<T> promise = Promise<T>();

  /// 子类实现：推进状态机一步。返回 true 表示已完成。
  bool step();

  void completeWith(T value) { promise.complete(value); }
  void completeWithError(Object error) { promise.completeError(error); }

  /// gcMark — 标记内部 promise，确保从 ASM root 可达
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
    promise.gcMark(flag);
  }

  Promise<T> start() {
    promise._onTick = step;
    GlobalScheduler.instance.registerActivePromise(promise);
    return promise;
  }
}
