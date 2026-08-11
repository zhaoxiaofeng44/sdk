/// 状态机协程验证测试
///
/// 用纯 Dart 模拟单线程状态机协程，验证将 async/await 替换为状态机的可行性。
/// 核心设计：
///   - Promise<T>: 统一的异步结果容器 + 调度单元（通过 _onTick 驱动）
///   - GlobalScheduler: 每轮 tick 驱动所有 activePromises 的 _onTick
///   - AsyncStateMachine: 通过 Promise._onTick = step 注册驱动
///   - sm_await(): 循环调 tick() 直到 promise 完成

/// 日志开关
bool enableLog = true;

void log(String msg) {
  if (enableLog) print('  [LOG] $msg');
}

// ============================================================================
// 1. 状态枚举
// ============================================================================

enum CompleterState { pending, completed, error }

// ============================================================================
// 2. Promise<T> — 统一的异步结果容器
// ============================================================================

class Promise<T> {
  CompleterState _state = CompleterState.pending;
  T? _result;
  Object? _error;

  CompleterState get state => _state;
  bool get isCompleted => _state == CompleterState.completed;
  bool get isError => _state == CompleterState.error;
  bool get isPending => _state == CompleterState.pending;

  Object? get error => _error;

  T get result {
    if (_state == CompleterState.error) throw _error!;
    if (_state != CompleterState.completed) {
      throw StateError('Promise not yet completed');
    }
    return _result as T;
  }

  void complete(T value) {
    if (_state != CompleterState.pending) {
      throw StateError('Promise already resolved');
    }
    _result = value;
    _state = CompleterState.completed;
  }

  void completeError(Object error) {
    if (_state != CompleterState.pending) {
      throw StateError('Promise already resolved');
    }
    _error = error;
    _state = CompleterState.error;
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

  /// 链式调用：当本 Promise 完成时，执行 onValue 并将结果传递给新 Promise
  Promise<R> then<R>(R Function(T) onValue) {
    final nextPromise = Promise<R>();
    nextPromise._onTick = () {
      if (isCompleted) {
        try {
          nextPromise.complete(onValue(result));
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

  /// 每 tick 被 GlobalScheduler 调用来推进此 Promise 的逻辑。
  /// 返回 true 表示已完成，应从活跃列表移除。
  bool Function()? _onTick;
}

// ============================================================================
// 4. GlobalScheduler — 全局调度器，统一通过 Promise 驱动
// ============================================================================

class GlobalScheduler {
  static final GlobalScheduler instance = GlobalScheduler._();
  GlobalScheduler._();

  final List<Promise> _activePromises = [];
  final List<_DelayedTask> _delayedTasks = [];
  int _currentTick = 0;

  /// 注册一个有 _onTick 的活跃 Promise，每 tick 被驱动
  void registerActivePromise(Promise promise) {
    log('registerActivePromise');
    _activePromises.add(promise);
  }

  void registerDelayedTask(int delayTicks, void Function() callback) {
    final target = _currentTick + delayTicks;
    log('registerDelayed: trigger@tick=$target (delay=$delayTicks)');
    _delayedTasks.add(_DelayedTask(target, callback));
  }

  /// 执行一轮 tick：
  /// 1. 触发到期的延迟任务
  /// 2. 驱动所有活跃 Promise
  void tick() {
    _currentTick++;
    log('--- tick #$_currentTick start (active=${_activePromises.length}, delayed=${_delayedTasks.length}) ---');

    // 1. 触发到期的延迟任务
    final expired = _delayedTasks.where((t) => t.targetTick <= _currentTick).toList();
    _delayedTasks.removeWhere((t) => t.targetTick <= _currentTick);
    for (final task in expired) {
      log('  delayed task triggered @tick=$_currentTick');
      task.callback();
    }

    // 2. 驱动所有活跃 Promise
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

    log('--- tick #$_currentTick end (remaining active=${_activePromises.length}) ---');
  }

  bool get hasActiveTasks =>
      _activePromises.isNotEmpty || _delayedTasks.isNotEmpty;

  void reset() {
    _activePromises.clear();
    _delayedTasks.clear();
    _currentTick = 0;
  }
}

class _DelayedTask {
  final int targetTick;
  final void Function() callback;
  _DelayedTask(this.targetTick, this.callback);
}

// ============================================================================
// 6. sm_await — 状态机版 await
// ============================================================================

/// sm_await 不打标，只循环调 tick() 直到 future 完成。
/// 打标的职责完全在 tick() 内部（防一轮内重复 step）。
T sm_await<T>(Promise<T> future) {
  int roundCount = 0;
  const maxRounds = 100000;

  log('sm_await: waiting for future (completed=${future.isCompleted})');

  while (!future.isCompleted && !future.isError) {
    GlobalScheduler.instance.tick();
    roundCount++;
    if (roundCount > maxRounds) {
      throw StateError('sm_await exceeded $maxRounds rounds — possible deadlock');
    }
  }

  if (future.isError) {
    log('sm_await: future resolved with ERROR after $roundCount ticks');
    throw future.error!;
  }
  log('sm_await: future resolved with value after $roundCount ticks');
  return future.result;
}

// ============================================================================
// 7. AsyncStateMachine<T> — 异步函数转状态机的基类
//    通过 Promise._onTick 驱动，不再依赖独立的 _stateMachines 列表
// ============================================================================

abstract class AsyncStateMachine<T> {
  int smState = 0;
  final Promise<T> promise = Promise<T>();

  /// 子类实现：推进状态机一步。返回 true 表示已完成。
  bool step();

  void completeWith(T value) {
    promise.complete(value);
  }

  void completeWithError(Object error) {
    promise.completeError(error);
  }

  Promise<T> start() {
    promise._onTick = step;
    GlobalScheduler.instance.registerActivePromise(promise);
    return promise;
  }
}

// ============================================================================
// ============================================================================
// DEMO 验证部分
// ============================================================================
// ============================================================================

// ---------------------------------------------------------------------------
// Demo 1: 基础 await — 等待一个立即完成的值
// ---------------------------------------------------------------------------
void testBasicAwait() {
  print('\n--- Demo 1: 基础 await (Promise.value) ---');
  GlobalScheduler.instance.reset();

  final future = Promise.value<int>(42);
  final result = sm_await(future);
  assert(result == 42, 'Expected 42, got $result');
  print('  ✓ sm_await(Promise.value(42)) = $result');
}

// ---------------------------------------------------------------------------
// Demo 2: 延迟 Future — 等待延迟完成
// ---------------------------------------------------------------------------
void testDelayedFuture() {
  print('\n--- Demo 2: 延迟 Future ---');
  GlobalScheduler.instance.reset();

  final future = Promise.delayed<String>(3, () => 'hello after delay');
  final result = sm_await(future);
  assert(result == 'hello after delay', 'Unexpected result: $result');
  print('  ✓ sm_await(delayed(3 ticks)) = "$result"');
}

// ---------------------------------------------------------------------------
// Demo 3: 多 await 串行
// ---------------------------------------------------------------------------
class AddAsyncStateMachine extends AsyncStateMachine<int> {
  final int a;
  final int b;
  int _x = 0;
  int _y = 0;
  Promise<int>? _pendingFuture;

  AddAsyncStateMachine(this.a, this.b);

  @override
  String get debugName => 'AddAsync($a,$b)';

  @override
  bool step() {
    switch (smState) {
      case 0:
        _pendingFuture = Promise.value<int>(a);
        smState = 1;
        log('  $debugName: state 0→1, created value future for $a');
        return false;
      case 1:
        if (_pendingFuture!.isPending) return false;
        _x = _pendingFuture!.result;
        _pendingFuture = Promise.delayed<int>(2, () => b);
        smState = 2;
        log('  $debugName: state 1→2, got x=$_x, created delayed future for $b');
        return false;
      case 2:
        if (_pendingFuture!.isPending) return false;
        _y = _pendingFuture!.result;
        log('  $debugName: state 2→done, got y=$_y, result=${_x + _y}');
        completeWith(_x + _y);
        return true;
      default:
        return true;
    }
  }
}

void testMultipleAwaitSerial() {
  print('\n--- Demo 3: 多 await 串行 (addAsync(10, 20)) ---');
  GlobalScheduler.instance.reset();

  final sm = AddAsyncStateMachine(10, 20);
  final future = sm.start();
  final result = sm_await(future);
  assert(result == 30, 'Expected 30, got $result');
  print('  ✓ addAsync(10, 20) = $result');
}

// ---------------------------------------------------------------------------
// Demo 4: 嵌套异步调用
// ---------------------------------------------------------------------------
class InnerAsyncStateMachine extends AsyncStateMachine<String> {
  Promise<String>? _pendingFuture;

  @override
  String get debugName => 'InnerAsync';

  @override
  bool step() {
    switch (smState) {
      case 0:
        _pendingFuture = Promise.delayed<String>(2, () => 'inner');
        smState = 1;
        log('  $debugName: state 0→1, created delayed future');
        return false;
      case 1:
        if (_pendingFuture!.isPending) return false;
        final val = _pendingFuture!.result;
        log('  $debugName: state 1→done, val=$val → ${val.toUpperCase()}');
        completeWith(val.toUpperCase());
        return true;
      default:
        return true;
    }
  }
}

class OuterAsyncStateMachine extends AsyncStateMachine<String> {
  String _prefix = '';
  Promise<String>? _pendingFuture;

  @override
  String get debugName => 'OuterAsync';

  @override
  bool step() {
    switch (smState) {
      case 0:
        _pendingFuture = Promise.value<String>('result:');
        smState = 1;
        log('  $debugName: state 0→1, created value future');
        return false;
      case 1:
        if (_pendingFuture!.isPending) return false;
        _prefix = _pendingFuture!.result;
        final innerSm = InnerAsyncStateMachine();
        _pendingFuture = innerSm.start();
        smState = 2;
        log('  $debugName: state 1→2, prefix=$_prefix, started InnerAsync');
        return false;
      case 2:
        if (_pendingFuture!.isPending) return false;
        final innerResult = _pendingFuture!.result;
        log('  $debugName: state 2→done, inner=$innerResult');
        completeWith('$_prefix $innerResult');
        return true;
      default:
        return true;
    }
  }
}

void testNestedAsync() {
  print('\n--- Demo 4: 嵌套异步调用 ---');
  GlobalScheduler.instance.reset();

  final sm = OuterAsyncStateMachine();
  final future = sm.start();
  final result = sm_await(future);
  assert(result == 'result: INNER', 'Expected "result: INNER", got "$result"');
  print('  ✓ outerAsync() = "$result"');
}

// ---------------------------------------------------------------------------
// Demo 5: then 链式调用
// ---------------------------------------------------------------------------
void testThenChain() {
  print('\n--- Demo 5: then 链式调用 ---');
  GlobalScheduler.instance.reset();

  final future = Promise.value<int>(5)
      .then<int>((v) => v * 2)
      .then<String>((v) => 'value=$v');

  final result = sm_await(future);
  assert(result == 'value=10', 'Expected "value=10", got "$result"');
  print('  ✓ Promise.value(5).then(*2).then(format) = "$result"');
}

// ---------------------------------------------------------------------------
// Demo 6: 异常处理
// ---------------------------------------------------------------------------
class ErrorStateMachine extends AsyncStateMachine<String> {
  Promise<int>? _pendingFuture;

  @override
  String get debugName => 'ErrorSM';

  @override
  bool step() {
    switch (smState) {
      case 0:
        _pendingFuture = Promise.delayed<int>(1, () {
          throw Exception('something went wrong');
        });
        smState = 1;
        log('  $debugName: state 0→1, created delayed future (will throw)');
        return false;
      case 1:
        if (_pendingFuture!.isPending) return false;
        if (_pendingFuture!.isError) {
          log('  $debugName: state 1→done, caught error');
          completeWith('caught: ${_pendingFuture!.error}');
          return true;
        }
        completeWith('unexpected success');
        return true;
      default:
        return true;
    }
  }
}

void testErrorHandling() {
  print('\n--- Demo 6: 异常处理 ---');
  GlobalScheduler.instance.reset();

  final sm = ErrorStateMachine();
  final future = sm.start();
  final result = sm_await(future);
  assert(result.contains('something went wrong'), 'Error not caught: $result');
  print('  ✓ error caught and recovered: "$result"');
}

// ---------------------------------------------------------------------------
// Demo 7: 并行 await（模拟 Future.wait）
// ---------------------------------------------------------------------------
class ParallelAwaitStateMachine extends AsyncStateMachine<List<int>> {
  late List<Promise<int>> _futures;

  @override
  String get debugName => 'ParallelSM';

  @override
  bool step() {
    switch (smState) {
      case 0:
        _futures = [
          Promise.delayed<int>(3, () => 10),
          Promise.delayed<int>(2, () => 20),
          Promise.delayed<int>(1, () => 30),
        ];
        smState = 1;
        log('  $debugName: state 0→1, created 3 delayed futures');
        return false;
      case 1:
        final allDone = _futures.every((f) => f.isCompleted || f.isError);
        if (!allDone) return false;
        final results = _futures.map((f) => f.result).toList();
        log('  $debugName: state 1→done, all futures completed: $results');
        completeWith(results);
        return true;
      default:
        return true;
    }
  }
}

void testParallelAwait() {
  print('\n--- Demo 7: 并行 await (Future.wait 模拟) ---');
  GlobalScheduler.instance.reset();

  final sm = ParallelAwaitStateMachine();
  final future = sm.start();
  final result = sm_await(future);
  assert(result.length == 3, 'Expected 3 results');
  assert(result[0] == 10 && result[1] == 20 && result[2] == 30,
      'Unexpected results: $result');
  print('  ✓ parallel([d3→10, d2→20, d1→30]) = $result');
}

// ---------------------------------------------------------------------------
// Demo 8: 多层嵌套管道
// ---------------------------------------------------------------------------
class ComputeStepStateMachine extends AsyncStateMachine<int> {
  final int input;
  Promise<int>? _pendingFuture;

  ComputeStepStateMachine(this.input);

  @override
  String get debugName => 'ComputeStep($input)';

  @override
  bool step() {
    switch (smState) {
      case 0:
        _pendingFuture = Promise.delayed<int>(1, () => input * 2);
        smState = 1;
        log('  $debugName: state 0→1');
        return false;
      case 1:
        if (_pendingFuture!.isPending) return false;
        final r = _pendingFuture!.result;
        log('  $debugName: state 1→done, result=$r');
        completeWith(r);
        return true;
      default:
        return true;
    }
  }
}

class PipelineStateMachine extends AsyncStateMachine<int> {
  int _a = 0, _b = 0, _c = 0;
  Promise<int>? _pendingFuture;

  @override
  String get debugName => 'PipelineSM';

  @override
  bool step() {
    switch (smState) {
      case 0:
        _pendingFuture = ComputeStepStateMachine(1).start();
        smState = 1;
        log('  $debugName: state 0→1, started ComputeStep(1)');
        return false;
      case 1:
        if (_pendingFuture!.isPending) return false;
        _a = _pendingFuture!.result;
        _pendingFuture = ComputeStepStateMachine(_a).start();
        smState = 2;
        log('  $debugName: state 1→2, a=$_a, started ComputeStep($_a)');
        return false;
      case 2:
        if (_pendingFuture!.isPending) return false;
        _b = _pendingFuture!.result;
        _pendingFuture = ComputeStepStateMachine(_b).start();
        smState = 3;
        log('  $debugName: state 2→3, b=$_b, started ComputeStep($_b)');
        return false;
      case 3:
        if (_pendingFuture!.isPending) return false;
        _c = _pendingFuture!.result;
        log('  $debugName: state 3→done, c=$_c, sum=${_a + _b + _c}');
        completeWith(_a + _b + _c);
        return true;
      default:
        return true;
    }
  }
}

void testPipeline() {
  print('\n--- Demo 8: 多层嵌套管道 pipeline ---');
  GlobalScheduler.instance.reset();

  final sm = PipelineStateMachine();
  final future = sm.start();
  final result = sm_await(future);
  assert(result == 14, 'Expected 14, got $result');
  print('  ✓ pipeline(1→2→4→8, sum=14) = $result');
}

// ---------------------------------------------------------------------------
// Demo 9: tick 计数验证
// ---------------------------------------------------------------------------
void testTickCounting() {
  print('\n--- Demo 9: tick 计数验证 ---');
  GlobalScheduler.instance.reset();

  final future = Promise.delayed<int>(5, () => 99);
  int ticksBefore = GlobalScheduler.instance._currentTick;
  final result = sm_await(future);
  int ticksAfter = GlobalScheduler.instance._currentTick;
  int ticksUsed = ticksAfter - ticksBefore;

  assert(result == 99, 'Expected 99');
  assert(ticksUsed >= 5, 'Should use at least 5 ticks, used $ticksUsed');
  print('  ✓ delayed(5 ticks) completed in $ticksUsed ticks, result=$result');
}

// ============================================================================
// main
// ============================================================================

void main() {
  print('═══════════════════════════════════════════');
  print(' 状态机协程验证测试');
  print('═══════════════════════════════════════════');

  testBasicAwait();
  testDelayedFuture();
  testMultipleAwaitSerial();
  testNestedAsync();
  testThenChain();
  testErrorHandling();
  testParallelAwait();
  testPipeline();
  testTickCounting();

  print('\n═══════════════════════════════════════════');
  print(' ✅ 全部 9 个测试通过！');
  print('═══════════════════════════════════════════');
}
