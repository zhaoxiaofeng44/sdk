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

enum PromiseState { pending, completed, error }

/// Promise — 统一的异步结果容器
///
/// 合并了原 StateMachineCompleter 和 SMFuture 的职责：
/// - 持有状态（pending/completed/error）和结果
/// - 提供 complete/completeError 操作
/// - 提供工厂方法（value/delayed）和链式调用（then）
/// - 创建时自动注册到 GlobalScheduler，complete 后由调度器移除
class Promise<T> {
  PromiseState state = PromiseState.pending;
  T? _result;
  Object? error;

  bool get isCompleted => state == PromiseState.completed;
  bool get isError => state == PromiseState.error;
  bool get isPending => state == PromiseState.pending;

  T get result {
    if (state == PromiseState.error) throw error!;
    if (state != PromiseState.completed) {
      throw StateError('Promise not yet completed');
    }
    return _result as T;
  }

  void complete(T value) {
    if (state != PromiseState.pending) {
      throw StateError('Promise already resolved');
    }
    _result = value;
    state = PromiseState.completed;
  }

  void completeError(Object err) {
    if (state != PromiseState.pending) {
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

  Promise<R> then<R>(R Function(T) onValue) {
    final nextPromise = Promise<R>();
    GlobalScheduler.instance.registerStateMachine(
      _ThenStateMachine<T, R>(this, onValue, nextPromise),
    );
    return nextPromise;
  }
}

/// 状态机接口
abstract class IStateMachine {
  bool _checkedThisRound = false;
  bool step();
  void resetRoundFlag() { _checkedThisRound = false; }
  bool markChecked() {
    if (_checkedThisRound) return false;
    _checkedThisRound = true;
    return true;
  }
}

class _ThenStateMachine<T, R> extends IStateMachine {
  final Promise<T> _source;
  final R Function(T) _onValue;
  final Promise<R> _target;
  _ThenStateMachine(this._source, this._onValue, this._target);

  @override
  bool step() {
    if (_source.isCompleted) {
      try {
        _target.complete(_onValue(_source.result));
      } catch (e) {
        _target.completeError(e);
      }
      return true;
    }
    if (_source.isError) {
      _target.completeError(_source.error!);
      return true;
    }
    return false;
  }
}

/// 全局状态机调度器
class GlobalScheduler {
  static final GlobalScheduler instance = GlobalScheduler._();
  GlobalScheduler._();

  final List<IStateMachine> _stateMachines = [];
  final List<_DelayedTask> _delayedTasks = [];
  int _currentTick = 0;

  void registerStateMachine(IStateMachine sm) {
    _stateMachines.add(sm);
  }

  void registerDelayedTask(int delayTicks, void Function() callback) {
    _delayedTasks.add(_DelayedTask(_currentTick + delayTicks, callback));
  }

  void tick() {
    _currentTick++;
    for (final sm in _stateMachines) {
      sm.resetRoundFlag();
    }
    final expired = _delayedTasks.where((t) => t.targetTick <= _currentTick).toList();
    _delayedTasks.removeWhere((t) => t.targetTick <= _currentTick);
    for (final task in expired) {
      task.callback();
    }
    final snapshot = List.of(_stateMachines);
    final finished = <IStateMachine>{};
    for (final sm in snapshot) {
      if (!sm.markChecked()) continue;
      if (sm.step()) finished.add(sm);
    }
    _stateMachines.removeWhere((sm) => finished.contains(sm));
  }

  void reset() {
    _stateMachines.clear();
    _delayedTasks.clear();
    _currentTick = 0;
  }
}

class _DelayedTask {
  final int targetTick;
  final void Function() callback;
  _DelayedTask(this.targetTick, this.callback);
}

/// smAwait — 状态机版 await，循环调 tick() 直到 promise 完成
T smAwait<T>(Promise<T> promise) {
  int roundCount = 0;
  while (!promise.isCompleted && !promise.isError) {
    GlobalScheduler.instance.tick();
    roundCount++;
    if (roundCount > 100000) {
      throw StateError('smAwait exceeded max rounds — possible deadlock');
    }
  }
  if (promise.isError) throw promise.error!;
  return promise.result;
}

/// AsyncStateMachine — 异步函数转状态机的基类
abstract class AsyncStateMachine<T> extends IStateMachine {
  int smState = 0;
  final Promise<T> promise = Promise<T>();

  @override
  bool step();

  void completeWith(T value) { promise.complete(value); }
  void completeWithError(Object error) { promise.completeError(error); }

  Promise<T> start() {
    GlobalScheduler.instance.registerStateMachine(this);
    return promise;
  }
}
