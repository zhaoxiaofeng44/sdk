import 'package:dart2cpp/restorer/runtime_classes.dart';

enum CompleterState {
  pending,
  completed,
  error;
}

class PromiseValue<T extends dynamic> extends VPtr {
  late CompleterState _state;
  late T? _result;
  late dynamic _error;
  late TypeFunction0<bool>? _onTick;

  PromiseValue() {
    vptr['get_state'] = Promise_get_state;
    vptr['get_isCompleted'] = Promise_get_isCompleted;
    vptr['get_isError'] = Promise_get_isError;
    vptr['get_isPending'] = Promise_get_isPending;
    vptr['get_error'] = Promise_get_error;
    vptr['get_result'] = Promise_get_result<T>;
    vptr['complete'] = Promise_complete<T>;
    vptr['completeError'] = Promise_completeError;
    vptr['then'] = Promise_then<T, dynamic>;
  }

  @override
  void gcMark(int flag) {
    super.gcMark(flag);
  }
}

PromiseValue<T> Promise_new<T extends dynamic>(dynamic this__) {
  final this_ = this__ as PromiseValue<T>;
  return this_;
}

CompleterState Promise_get_state<T extends dynamic>(dynamic this__) {
  final this_ = this__ as PromiseValue<T>;
  return this_._state;
}

bool Promise_get_isCompleted<T extends dynamic>(dynamic this__) {
  final this_ = this__ as PromiseValue<T>;
  return (this_._state == CompleterState.completed);
}

bool Promise_get_isError<T extends dynamic>(dynamic this__) {
  final this_ = this__ as PromiseValue<T>;
  return (this_._state == CompleterState.error);
}

bool Promise_get_isPending<T extends dynamic>(dynamic this__) {
  final this_ = this__ as PromiseValue<T>;
  return (this_._state == CompleterState.pending);
}

dynamic Promise_get_error<T extends dynamic>(dynamic this__) {
  final this_ = this__ as PromiseValue<T>;
  return this_._error;
}

T Promise_get_result<T extends dynamic>(dynamic this__) {
  final this_ = this__ as PromiseValue<T>;
  if ((this_._state == CompleterState.error)) {
    throw this_._error!;
  }
  if (!(this_._state == CompleterState.completed)) {
    throw DartStateError('Promise not yet completed');
  }
  return (this_._result as T);
}

void Promise_complete<T extends dynamic>(dynamic this__, T value) {
  final this_ = this__ as PromiseValue<T>;
  if (!(this_._state == CompleterState.pending)) {
    throw DartStateError('Promise already resolved');
  }
  this_._result = value;
  this_._state = CompleterState.completed;
}

void Promise_completeError<T extends dynamic>(dynamic this__, dynamic error) {
  final this_ = this__ as PromiseValue<T>;
  if (!(this_._state == CompleterState.pending)) {
    throw DartStateError('Promise already resolved');
  }
  this_._error = error;
  this_._state = CompleterState.error;
}

PromiseValue<T> Promise_value<T extends dynamic>(T val) {
  PromiseValue<T> promise = Promise_new<T>(PromiseValue<T>());
  (promise.vptr['complete'] as Function)(promise, val);
  return promise;
}

PromiseValue<T> Promise_delayed<T extends dynamic>(int delayTicks, TypeFunction0<T> computation) {
  PromiseValue<T> promise = Promise_new<T>(PromiseValue<T>());
  (GlobalScheduler_instance.vptr['registerDelayedTask'] as Function)(GlobalScheduler_instance, delayTicks, ClosureEnv_global_0_new<T>(GC.allocateLocal(ClosureEnv_global_0<T>()), promise, computation, e));
  return promise;
}

PromiseValue<R> Promise_then<T extends dynamic, R extends dynamic>(dynamic this__, TypeFunction1<R, T> onValue) {
  final this_ = this__ as PromiseValue<T>;
  PromiseValue<R> nextPromise = Promise_new<R>(PromiseValue<R>());
  nextPromise._onTick = ClosureEnv_global_1_new<R, T>(GC.allocateLocal(ClosureEnv_global_1<R, T>()), this_, nextPromise, onValue, e);
  (GlobalScheduler_instance.vptr['registerActivePromise'] as Function)(GlobalScheduler_instance, nextPromise);
  return nextPromise;
}

class GlobalSchedulerValue extends VPtr {
  late StaticList<PromiseValue<dynamic>> _activePromises;
  late StaticList<_DelayedTaskValue> _delayedTasks;
  late int _currentTick;

  GlobalSchedulerValue() {
    vptr['registerActivePromise'] = GlobalScheduler_registerActivePromise;
    vptr['registerDelayedTask'] = GlobalScheduler_registerDelayedTask;
    vptr['tick'] = GlobalScheduler_tick;
    vptr['get_hasActiveTasks'] = GlobalScheduler_get_hasActiveTasks;
    vptr['reset'] = GlobalScheduler_reset;
  }

  @override
  void gcMark(int flag) {
    super.gcMark(flag);
    _activePromises?.gcMark(flag);
    _delayedTasks?.gcMark(flag);
  }
}

GlobalSchedulerValue GlobalScheduler_instance = GlobalScheduler_new__(GlobalSchedulerValue());

GlobalSchedulerValue GlobalScheduler_new__(dynamic this__) {
  final this_ = this__ as GlobalSchedulerValue;
  return this_;
}

void GlobalScheduler_registerActivePromise(dynamic this__, PromiseValue<dynamic> promise) {
  final this_ = this__ as GlobalSchedulerValue;
  log('registerActivePromise');
  this_._activePromises.add(promise);
}

void GlobalScheduler_registerDelayedTask(dynamic this__, int delayTicks, TypeFunction0<void> callback) {
  final this_ = this__ as GlobalSchedulerValue;
  int target = (this_._currentTick + delayTicks);
  log('registerDelayed: trigger@tick=${target} (delay=${delayTicks})');
  this_._delayedTasks.add(_DelayedTask_new(_DelayedTaskValue(), target, callback));
}

void GlobalScheduler_tick(dynamic this__) {
  final this_ = this__ as GlobalSchedulerValue;
  this_._currentTick = (this_._currentTick + 1);
  log('--- tick #${this_._currentTick} start (active=${this_._activePromises.length}, delayed=${this_._delayedTasks.length}) ---');
  StaticList<_DelayedTaskValue> expired = StaticList<_DelayedTaskValue>.of(StaticList<_DelayedTaskValue>.of(this_._delayedTasks.where(ClosureEnv_global_2_new(GC.allocateLocal(ClosureEnv_global_2()), this_))).toList());
  this_._delayedTasks.removeWhere(ClosureEnv_global_3_new(GC.allocateLocal(ClosureEnv_global_3()), this_));
  for (final task in expired) {
    log('  delayed task triggered @tick=${this_._currentTick}');
    task.callback();
  }
  StaticList<PromiseValue<dynamic>> snapshot = StaticList<PromiseValue<dynamic>>.of(this_._activePromises);
  StaticSet<PromiseValue<dynamic>> finished = StaticSet<PromiseValue<dynamic>>.of({});
  for (final promise in snapshot) {
    do {
      if ((promise.vptr['get_isCompleted'] as Function)(promise) || (promise.vptr['get_isError'] as Function)(promise)) {
        finished.add(promise);
        break;
      }
      TypeFunction0<bool>? onTick = promise._onTick;
      if (!(onTick == null) && onTick()) {
        finished.add(promise);
      }
    } while (false);
  }
  this_._activePromises.removeWhere(ClosureEnv_global_4_new(GC.allocateLocal(ClosureEnv_global_4()), finished));
  log('--- tick #${this_._currentTick} end (remaining active=${this_._activePromises.length}) ---');
}

bool GlobalScheduler_get_hasActiveTasks(dynamic this__) {
  final this_ = this__ as GlobalSchedulerValue;
  return this_._activePromises.isNotEmpty || this_._delayedTasks.isNotEmpty;
}

void GlobalScheduler_reset(dynamic this__) {
  final this_ = this__ as GlobalSchedulerValue;
  this_._activePromises.clear();
  this_._delayedTasks.clear();
  this_._currentTick = 0;
}

class _DelayedTaskValue extends VPtr {
  late int targetTick;
  late TypeFunction0<void> callback;

  _DelayedTaskValue() {
  }

  @override
  void gcMark(int flag) {
    super.gcMark(flag);
    callback?.gcMark(flag);
  }
}

_DelayedTaskValue _DelayedTask_new(dynamic this__, int targetTick, TypeFunction0<void> callback) {
  final this_ = this__ as _DelayedTaskValue;
  this_.targetTick = targetTick;
  this_.callback = callback;
  return this_;
}

class AsyncStateMachineValue<T extends dynamic> extends VPtr {
  late int smState;
  late PromiseValue<T> promise;

  AsyncStateMachineValue() {
    vptr['step'] = AsyncStateMachine_step;
    vptr['completeWith'] = AsyncStateMachine_completeWith<T>;
    vptr['completeWithError'] = AsyncStateMachine_completeWithError;
    vptr['start'] = AsyncStateMachine_start<T>;
  }

  @override
  void gcMark(int flag) {
    super.gcMark(flag);
    promise?.gcMark(flag);
  }
}

AsyncStateMachineValue<T> AsyncStateMachine_new<T extends dynamic>(dynamic this__) {
  final this_ = this__ as AsyncStateMachineValue<T>;
  return this_;
}

bool AsyncStateMachine_step<T extends dynamic>(dynamic this__) {
  throw UnimplementedError('AsyncStateMachine_step is abstract');
}

void AsyncStateMachine_completeWith<T extends dynamic>(dynamic this__, T value) {
  final this_ = this__ as AsyncStateMachineValue<T>;
  (this_.promise.vptr['complete'] as Function)(this_.promise, value);
}

void AsyncStateMachine_completeWithError<T extends dynamic>(dynamic this__, dynamic error) {
  final this_ = this__ as AsyncStateMachineValue<T>;
  (this_.promise.vptr['completeError'] as Function)(this_.promise, error);
}

PromiseValue<T> AsyncStateMachine_start<T extends dynamic>(dynamic this__) {
  final this_ = this__ as AsyncStateMachineValue<T>;
  this_.promise._onTick = AsyncStateMachine_step;
  (GlobalScheduler_instance.vptr['registerActivePromise'] as Function)(GlobalScheduler_instance, this_.promise);
  return this_.promise;
}

class AddAsyncStateMachineValue extends AsyncStateMachineValue<int> {
  late int a;
  late int b;
  late int _x;
  late int _y;
  late PromiseValue<int>? _pendingFuture;

  AddAsyncStateMachineValue() {
    vptr['step'] = AddAsyncStateMachine_step;
    vptr['get_debugName'] = AddAsyncStateMachine_get_debugName;
  }

  @override
  void gcMark(int flag) {
    super.gcMark(flag);
  }
}

AddAsyncStateMachineValue AddAsyncStateMachine_new(dynamic this__, int a, int b) {
  final this_ = this__ as AddAsyncStateMachineValue;
  AsyncStateMachine_new(this_);
  this_.a = a;
  this_.b = b;
  return this_;
}

String AddAsyncStateMachine_get_debugName(dynamic this__) {
  final this_ = this__ as AddAsyncStateMachineValue;
  return 'AddAsync(${this_.a},${this_.b})';
}

bool AddAsyncStateMachine_step(dynamic this__) {
  final this_ = this__ as AddAsyncStateMachineValue;
  do {
    switch (this_.smState) {
      case 0:
        this_._pendingFuture = Promise_value(this_.a);
        this_.smState = 1;
        log('  ${(this_.vptr['get_debugName'] as Function)(this_)}: state 0→1, created value future for ${this_.a}');
        return false;
      case 1:
        if ((this_._pendingFuture!.vptr['get_isPending'] as Function)(this_._pendingFuture!)) {
          return false;
        }
        this_._x = (this_._pendingFuture!.vptr['get_result'] as Function)(this_._pendingFuture!);
        this_._pendingFuture = Promise_delayed(2, ClosureEnv_global_5_new(GC.allocateLocal(ClosureEnv_global_5()), this_));
        this_.smState = 2;
        log('  ${(this_.vptr['get_debugName'] as Function)(this_)}: state 1→2, got x=${this_._x}, created delayed future for ${this_.b}');
        return false;
      case 2:
        if ((this_._pendingFuture!.vptr['get_isPending'] as Function)(this_._pendingFuture!)) {
          return false;
        }
        this_._y = (this_._pendingFuture!.vptr['get_result'] as Function)(this_._pendingFuture!);
        log('  ${(this_.vptr['get_debugName'] as Function)(this_)}: state 2→done, got y=${this_._y}, result=${(this_._x + this_._y)}');
        (this_.vptr['completeWith'] as Function)(this_, (this_._x + this_._y));
        return true;
      default:
        return true;
    }
  } while (false);
}

void AddAsyncStateMachine_completeWith(dynamic this__, int value) { AsyncStateMachine_completeWith<int>(this__, value); }

void AddAsyncStateMachine_completeWithError(dynamic this__, dynamic error) { AsyncStateMachine_completeWithError<int>(this__, error); }

PromiseValue<int> AddAsyncStateMachine_start(dynamic this__) => AsyncStateMachine_start<int>(this__);

class InnerAsyncStateMachineValue extends AsyncStateMachineValue<String> {
  late PromiseValue<String>? _pendingFuture;

  InnerAsyncStateMachineValue() {
    vptr['step'] = InnerAsyncStateMachine_step;
    vptr['get_debugName'] = InnerAsyncStateMachine_get_debugName;
  }

  @override
  void gcMark(int flag) {
    super.gcMark(flag);
  }
}

InnerAsyncStateMachineValue InnerAsyncStateMachine_new(dynamic this__) {
  final this_ = this__ as InnerAsyncStateMachineValue;
  AsyncStateMachine_new(this_);
  return this_;
}

String InnerAsyncStateMachine_get_debugName(dynamic this__) {
  final this_ = this__ as InnerAsyncStateMachineValue;
  return 'InnerAsync';
}

bool InnerAsyncStateMachine_step(dynamic this__) {
  final this_ = this__ as InnerAsyncStateMachineValue;
  do {
    switch (this_.smState) {
      case 0:
        this_._pendingFuture = Promise_delayed(2, ClosureEnv_global_6_new(GC.allocateLocal(ClosureEnv_global_6())));
        this_.smState = 1;
        log('  ${(this_.vptr['get_debugName'] as Function)(this_)}: state 0→1, created delayed future');
        return false;
      case 1:
        if ((this_._pendingFuture!.vptr['get_isPending'] as Function)(this_._pendingFuture!)) {
          return false;
        }
        String val = (this_._pendingFuture!.vptr['get_result'] as Function)(this_._pendingFuture!);
        log('  ${(this_.vptr['get_debugName'] as Function)(this_)}: state 1→done, val=${val} → ${val.toUpperCase()}');
        (this_.vptr['completeWith'] as Function)(this_, val.toUpperCase());
        return true;
      default:
        return true;
    }
  } while (false);
}

void InnerAsyncStateMachine_completeWith(dynamic this__, String value) { AsyncStateMachine_completeWith<String>(this__, value); }

void InnerAsyncStateMachine_completeWithError(dynamic this__, dynamic error) { AsyncStateMachine_completeWithError<String>(this__, error); }

PromiseValue<String> InnerAsyncStateMachine_start(dynamic this__) => AsyncStateMachine_start<String>(this__);

class OuterAsyncStateMachineValue extends AsyncStateMachineValue<String> {
  late String _prefix;
  late PromiseValue<String>? _pendingFuture;

  OuterAsyncStateMachineValue() {
    vptr['step'] = OuterAsyncStateMachine_step;
    vptr['get_debugName'] = OuterAsyncStateMachine_get_debugName;
  }

  @override
  void gcMark(int flag) {
    super.gcMark(flag);
  }
}

OuterAsyncStateMachineValue OuterAsyncStateMachine_new(dynamic this__) {
  final this_ = this__ as OuterAsyncStateMachineValue;
  AsyncStateMachine_new(this_);
  return this_;
}

String OuterAsyncStateMachine_get_debugName(dynamic this__) {
  final this_ = this__ as OuterAsyncStateMachineValue;
  return 'OuterAsync';
}

bool OuterAsyncStateMachine_step(dynamic this__) {
  final this_ = this__ as OuterAsyncStateMachineValue;
  do {
    switch (this_.smState) {
      case 0:
        this_._pendingFuture = Promise_value('result:');
        this_.smState = 1;
        log('  ${(this_.vptr['get_debugName'] as Function)(this_)}: state 0→1, created value future');
        return false;
      case 1:
        if ((this_._pendingFuture!.vptr['get_isPending'] as Function)(this_._pendingFuture!)) {
          return false;
        }
        this_._prefix = (this_._pendingFuture!.vptr['get_result'] as Function)(this_._pendingFuture!);
        InnerAsyncStateMachineValue innerSm = InnerAsyncStateMachine_new(InnerAsyncStateMachineValue());
        this_._pendingFuture = (innerSm.vptr['start'] as Function)(innerSm);
        this_.smState = 2;
        log('  ${(this_.vptr['get_debugName'] as Function)(this_)}: state 1→2, prefix=${this_._prefix}, started InnerAsync');
        return false;
      case 2:
        if ((this_._pendingFuture!.vptr['get_isPending'] as Function)(this_._pendingFuture!)) {
          return false;
        }
        String innerResult = (this_._pendingFuture!.vptr['get_result'] as Function)(this_._pendingFuture!);
        log('  ${(this_.vptr['get_debugName'] as Function)(this_)}: state 2→done, inner=${innerResult}');
        (this_.vptr['completeWith'] as Function)(this_, '${this_._prefix} ${innerResult}');
        return true;
      default:
        return true;
    }
  } while (false);
}

void OuterAsyncStateMachine_completeWith(dynamic this__, String value) { AsyncStateMachine_completeWith<String>(this__, value); }

void OuterAsyncStateMachine_completeWithError(dynamic this__, dynamic error) { AsyncStateMachine_completeWithError<String>(this__, error); }

PromiseValue<String> OuterAsyncStateMachine_start(dynamic this__) => AsyncStateMachine_start<String>(this__);

class ErrorStateMachineValue extends AsyncStateMachineValue<String> {
  late PromiseValue<int>? _pendingFuture;

  ErrorStateMachineValue() {
    vptr['step'] = ErrorStateMachine_step;
    vptr['get_debugName'] = ErrorStateMachine_get_debugName;
  }

  @override
  void gcMark(int flag) {
    super.gcMark(flag);
  }
}

ErrorStateMachineValue ErrorStateMachine_new(dynamic this__) {
  final this_ = this__ as ErrorStateMachineValue;
  AsyncStateMachine_new(this_);
  return this_;
}

String ErrorStateMachine_get_debugName(dynamic this__) {
  final this_ = this__ as ErrorStateMachineValue;
  return 'ErrorSM';
}

bool ErrorStateMachine_step(dynamic this__) {
  final this_ = this__ as ErrorStateMachineValue;
  do {
    switch (this_.smState) {
      case 0:
        this_._pendingFuture = Promise_delayed(1, ClosureEnv_global_7_new(GC.allocateLocal(ClosureEnv_global_7())));
        this_.smState = 1;
        log('  ${(this_.vptr['get_debugName'] as Function)(this_)}: state 0→1, created delayed future (will throw)');
        return false;
      case 1:
        if ((this_._pendingFuture!.vptr['get_isPending'] as Function)(this_._pendingFuture!)) {
          return false;
        }
        if ((this_._pendingFuture!.vptr['get_isError'] as Function)(this_._pendingFuture!)) {
          log('  ${(this_.vptr['get_debugName'] as Function)(this_)}: state 1→done, caught error');
          (this_.vptr['completeWith'] as Function)(this_, 'caught: ${(this_._pendingFuture!.vptr['get_error'] as Function)(this_._pendingFuture!)}');
          return true;
        }
        (this_.vptr['completeWith'] as Function)(this_, 'unexpected success');
        return true;
      default:
        return true;
    }
  } while (false);
}

void ErrorStateMachine_completeWith(dynamic this__, String value) { AsyncStateMachine_completeWith<String>(this__, value); }

void ErrorStateMachine_completeWithError(dynamic this__, dynamic error) { AsyncStateMachine_completeWithError<String>(this__, error); }

PromiseValue<String> ErrorStateMachine_start(dynamic this__) => AsyncStateMachine_start<String>(this__);

class ParallelAwaitStateMachineValue extends AsyncStateMachineValue<StaticList<int>> {
  late StaticList<PromiseValue<int>> _futures;

  ParallelAwaitStateMachineValue() {
    vptr['step'] = ParallelAwaitStateMachine_step;
    vptr['get_debugName'] = ParallelAwaitStateMachine_get_debugName;
  }

  @override
  void gcMark(int flag) {
    super.gcMark(flag);
    _futures?.gcMark(flag);
  }
}

ParallelAwaitStateMachineValue ParallelAwaitStateMachine_new(dynamic this__) {
  final this_ = this__ as ParallelAwaitStateMachineValue;
  AsyncStateMachine_new(this_);
  return this_;
}

String ParallelAwaitStateMachine_get_debugName(dynamic this__) {
  final this_ = this__ as ParallelAwaitStateMachineValue;
  return 'ParallelSM';
}

bool ParallelAwaitStateMachine_step(dynamic this__) {
  final this_ = this__ as ParallelAwaitStateMachineValue;
  do {
    switch (this_.smState) {
      case 0:
        this_._futures = StaticList<PromiseValue<int>>.of([Promise_delayed(3, ClosureEnv_global_8_new(GC.allocateLocal(ClosureEnv_global_8()))), Promise_delayed(2, ClosureEnv_global_9_new(GC.allocateLocal(ClosureEnv_global_9()))), Promise_delayed(1, ClosureEnv_global_10_new(GC.allocateLocal(ClosureEnv_global_10())))]);
        this_.smState = 1;
        log('  ${(this_.vptr['get_debugName'] as Function)(this_)}: state 0→1, created 3 delayed futures');
        return false;
      case 1:
        bool allDone = this_._futures.every(ClosureEnv_global_11_new(GC.allocateLocal(ClosureEnv_global_11())));
        if (!allDone) {
          return false;
        }
        StaticList<int> results = StaticList<int>.of(StaticList<int>.of(this_._futures.map(ClosureEnv_global_12_new(GC.allocateLocal(ClosureEnv_global_12())))).toList());
        log('  ${(this_.vptr['get_debugName'] as Function)(this_)}: state 1→done, all futures completed: ${results}');
        (this_.vptr['completeWith'] as Function)(this_, results);
        return true;
      default:
        return true;
    }
  } while (false);
}

void ParallelAwaitStateMachine_completeWith(dynamic this__, StaticList<int> value) { AsyncStateMachine_completeWith<StaticList<int>>(this__, value); }

void ParallelAwaitStateMachine_completeWithError(dynamic this__, dynamic error) { AsyncStateMachine_completeWithError<StaticList<int>>(this__, error); }

PromiseValue<StaticList<int>> ParallelAwaitStateMachine_start(dynamic this__) => AsyncStateMachine_start<StaticList<int>>(this__);

class ComputeStepStateMachineValue extends AsyncStateMachineValue<int> {
  late int input;
  late PromiseValue<int>? _pendingFuture;

  ComputeStepStateMachineValue() {
    vptr['step'] = ComputeStepStateMachine_step;
    vptr['get_debugName'] = ComputeStepStateMachine_get_debugName;
  }

  @override
  void gcMark(int flag) {
    super.gcMark(flag);
  }
}

ComputeStepStateMachineValue ComputeStepStateMachine_new(dynamic this__, int input) {
  final this_ = this__ as ComputeStepStateMachineValue;
  AsyncStateMachine_new(this_);
  this_.input = input;
  return this_;
}

String ComputeStepStateMachine_get_debugName(dynamic this__) {
  final this_ = this__ as ComputeStepStateMachineValue;
  return 'ComputeStep(${this_.input})';
}

bool ComputeStepStateMachine_step(dynamic this__) {
  final this_ = this__ as ComputeStepStateMachineValue;
  do {
    switch (this_.smState) {
      case 0:
        this_._pendingFuture = Promise_delayed(1, ClosureEnv_global_13_new(GC.allocateLocal(ClosureEnv_global_13()), this_));
        this_.smState = 1;
        log('  ${(this_.vptr['get_debugName'] as Function)(this_)}: state 0→1');
        return false;
      case 1:
        if ((this_._pendingFuture!.vptr['get_isPending'] as Function)(this_._pendingFuture!)) {
          return false;
        }
        int r = (this_._pendingFuture!.vptr['get_result'] as Function)(this_._pendingFuture!);
        log('  ${(this_.vptr['get_debugName'] as Function)(this_)}: state 1→done, result=${r}');
        (this_.vptr['completeWith'] as Function)(this_, r);
        return true;
      default:
        return true;
    }
  } while (false);
}

void ComputeStepStateMachine_completeWith(dynamic this__, int value) { AsyncStateMachine_completeWith<int>(this__, value); }

void ComputeStepStateMachine_completeWithError(dynamic this__, dynamic error) { AsyncStateMachine_completeWithError<int>(this__, error); }

PromiseValue<int> ComputeStepStateMachine_start(dynamic this__) => AsyncStateMachine_start<int>(this__);

class PipelineStateMachineValue extends AsyncStateMachineValue<int> {
  late int _a;
  late int _b;
  late int _c;
  late PromiseValue<int>? _pendingFuture;

  PipelineStateMachineValue() {
    vptr['step'] = PipelineStateMachine_step;
    vptr['get_debugName'] = PipelineStateMachine_get_debugName;
  }

  @override
  void gcMark(int flag) {
    super.gcMark(flag);
  }
}

PipelineStateMachineValue PipelineStateMachine_new(dynamic this__) {
  final this_ = this__ as PipelineStateMachineValue;
  AsyncStateMachine_new(this_);
  return this_;
}

String PipelineStateMachine_get_debugName(dynamic this__) {
  final this_ = this__ as PipelineStateMachineValue;
  return 'PipelineSM';
}

bool PipelineStateMachine_step(dynamic this__) {
  final this_ = this__ as PipelineStateMachineValue;
  do {
    switch (this_.smState) {
      case 0:
        this_._pendingFuture = (ComputeStepStateMachine_new(ComputeStepStateMachineValue(), 1).vptr['start'] as Function)(ComputeStepStateMachine_new(ComputeStepStateMachineValue(), 1));
        this_.smState = 1;
        log('  ${(this_.vptr['get_debugName'] as Function)(this_)}: state 0→1, started ComputeStep(1)');
        return false;
      case 1:
        if ((this_._pendingFuture!.vptr['get_isPending'] as Function)(this_._pendingFuture!)) {
          return false;
        }
        this_._a = (this_._pendingFuture!.vptr['get_result'] as Function)(this_._pendingFuture!);
        this_._pendingFuture = (ComputeStepStateMachine_new(ComputeStepStateMachineValue(), this_._a).vptr['start'] as Function)(ComputeStepStateMachine_new(ComputeStepStateMachineValue(), this_._a));
        this_.smState = 2;
        log('  ${(this_.vptr['get_debugName'] as Function)(this_)}: state 1→2, a=${this_._a}, started ComputeStep(${this_._a})');
        return false;
      case 2:
        if ((this_._pendingFuture!.vptr['get_isPending'] as Function)(this_._pendingFuture!)) {
          return false;
        }
        this_._b = (this_._pendingFuture!.vptr['get_result'] as Function)(this_._pendingFuture!);
        this_._pendingFuture = (ComputeStepStateMachine_new(ComputeStepStateMachineValue(), this_._b).vptr['start'] as Function)(ComputeStepStateMachine_new(ComputeStepStateMachineValue(), this_._b));
        this_.smState = 3;
        log('  ${(this_.vptr['get_debugName'] as Function)(this_)}: state 2→3, b=${this_._b}, started ComputeStep(${this_._b})');
        return false;
      case 3:
        if ((this_._pendingFuture!.vptr['get_isPending'] as Function)(this_._pendingFuture!)) {
          return false;
        }
        this_._c = (this_._pendingFuture!.vptr['get_result'] as Function)(this_._pendingFuture!);
        log('  ${(this_.vptr['get_debugName'] as Function)(this_)}: state 3→done, c=${this_._c}, sum=${((this_._a + this_._b) + this_._c)}');
        (this_.vptr['completeWith'] as Function)(this_, ((this_._a + this_._b) + this_._c));
        return true;
      default:
        return true;
    }
  } while (false);
}

void PipelineStateMachine_completeWith(dynamic this__, int value) { AsyncStateMachine_completeWith<int>(this__, value); }

void PipelineStateMachine_completeWithError(dynamic this__, dynamic error) { AsyncStateMachine_completeWithError<int>(this__, error); }

PromiseValue<int> PipelineStateMachine_start(dynamic this__) => AsyncStateMachine_start<int>(this__);

void log(String msg) {
  if (.enableLog) {
    staticPrint('  [LOG] ${msg}');
  }
}

T smAwait<T extends dynamic>(PromiseValue<T> future) {
  int roundCount = 0;
  log('smAwait: waiting for future (completed=${(future.vptr['get_isCompleted'] as Function)(future)})');
  while (!(future.vptr['get_isCompleted'] as Function)(future) && !(future.vptr['get_isError'] as Function)(future)) {
    (GlobalScheduler_instance.vptr['tick'] as Function)(GlobalScheduler_instance);
    roundCount = (roundCount + 1);
    if ((roundCount > 100000)) {
      throw DartStateError('smAwait exceeded 100000 rounds — possible deadlock');
    }
  }
  if ((future.vptr['get_isError'] as Function)(future)) {
    log('smAwait: future resolved with ERROR after ${roundCount} ticks');
    throw (future.vptr['get_error'] as Function)(future)!;
  }
  log('smAwait: future resolved with value after ${roundCount} ticks');
  return (future.vptr['get_result'] as Function)(future);
}

void testBasicAwait() {
  staticPrint('\n--- Demo 1: 基础 await (Promise.value) ---');
  (GlobalScheduler_instance.vptr['reset'] as Function)(GlobalScheduler_instance);
  PromiseValue<int> future = Promise_value(42);
  int result = smAwait(future);
  assert((result == 42), 'Expected 42, got ${result}');
  staticPrint('  ✓ smAwait(Promise.value(42)) = ${result}');
}

void testDelayedFuture() {
  staticPrint('\n--- Demo 2: 延迟 Future ---');
  (GlobalScheduler_instance.vptr['reset'] as Function)(GlobalScheduler_instance);
  PromiseValue<String> future = Promise_delayed(3, ClosureEnv_global_14_new(GC.allocateLocal(ClosureEnv_global_14())));
  String result = smAwait(future);
  assert((result == 'hello after delay'), 'Unexpected result: ${result}');
  staticPrint('  ✓ smAwait(delayed(3 ticks)) = "${result}"');
}

void testMultipleAwaitSerial() {
  staticPrint('\n--- Demo 3: 多 await 串行 (addAsync(10, 20)) ---');
  (GlobalScheduler_instance.vptr['reset'] as Function)(GlobalScheduler_instance);
  AddAsyncStateMachineValue sm = AddAsyncStateMachine_new(AddAsyncStateMachineValue(), 10, 20);
  PromiseValue<int> future = (sm.vptr['start'] as Function)(sm);
  int result = smAwait(future);
  assert((result == 30), 'Expected 30, got ${result}');
  staticPrint('  ✓ addAsync(10, 20) = ${result}');
}

void testNestedAsync() {
  staticPrint('\n--- Demo 4: 嵌套异步调用 ---');
  (GlobalScheduler_instance.vptr['reset'] as Function)(GlobalScheduler_instance);
  OuterAsyncStateMachineValue sm = OuterAsyncStateMachine_new(OuterAsyncStateMachineValue());
  PromiseValue<String> future = (sm.vptr['start'] as Function)(sm);
  String result = smAwait(future);
  assert((result == 'result: INNER'), 'Expected "result: INNER", got "${result}"');
  staticPrint('  ✓ outerAsync() = "${result}"');
}

void testThenChain() {
  staticPrint('\n--- Demo 5: then 链式调用 ---');
  (GlobalScheduler_instance.vptr['reset'] as Function)(GlobalScheduler_instance);
  PromiseValue<String> future = ((Promise_value(5).vptr['then_int'] as Function)(Promise_value(5), ClosureEnv_global_15_new(GC.allocateLocal(ClosureEnv_global_15()))).vptr['then_String'] as Function)((Promise_value(5).vptr['then_int'] as Function)(Promise_value(5), ClosureEnv_global_15_new(GC.allocateLocal(ClosureEnv_global_15()))), ClosureEnv_global_16_new(GC.allocateLocal(ClosureEnv_global_16())));
  String result = smAwait(future);
  assert((result == 'value=10'), 'Expected "value=10", got "${result}"');
  staticPrint('  ✓ Promise.value(5).then(*2).then(format) = "${result}"');
}

void testErrorHandling() {
  staticPrint('\n--- Demo 6: 异常处理 ---');
  (GlobalScheduler_instance.vptr['reset'] as Function)(GlobalScheduler_instance);
  ErrorStateMachineValue sm = ErrorStateMachine_new(ErrorStateMachineValue());
  PromiseValue<String> future = (sm.vptr['start'] as Function)(sm);
  String result = smAwait(future);
  assert(result.contains('something went wrong'), 'Error not caught: ${result}');
  staticPrint('  ✓ error caught and recovered: "${result}"');
}

void testParallelAwait() {
  staticPrint('\n--- Demo 7: 并行 await (Future.wait 模拟) ---');
  (GlobalScheduler_instance.vptr['reset'] as Function)(GlobalScheduler_instance);
  ParallelAwaitStateMachineValue sm = ParallelAwaitStateMachine_new(ParallelAwaitStateMachineValue());
  PromiseValue<StaticList<int>> future = (sm.vptr['start'] as Function)(sm);
  StaticList<int> result = smAwait(future);
  assert((result.length == 3), 'Expected 3 results');
  assert((result[0] == 10) && (result[1] == 20) && (result[2] == 30), 'Unexpected results: ${result}');
  staticPrint('  ✓ parallel([d3→10, d2→20, d1→30]) = ${result}');
}

void testPipeline() {
  staticPrint('\n--- Demo 8: 多层嵌套管道 pipeline ---');
  (GlobalScheduler_instance.vptr['reset'] as Function)(GlobalScheduler_instance);
  PipelineStateMachineValue sm = PipelineStateMachine_new(PipelineStateMachineValue());
  PromiseValue<int> future = (sm.vptr['start'] as Function)(sm);
  int result = smAwait(future);
  assert((result == 14), 'Expected 14, got ${result}');
  staticPrint('  ✓ pipeline(1→2→4→8, sum=14) = ${result}');
}

void testTickCounting() {
  staticPrint('\n--- Demo 9: tick 计数验证 ---');
  (GlobalScheduler_instance.vptr['reset'] as Function)(GlobalScheduler_instance);
  PromiseValue<int> future = Promise_delayed(5, ClosureEnv_global_17_new(GC.allocateLocal(ClosureEnv_global_17())));
  int ticksBefore = GlobalScheduler_instance._currentTick;
  int result = smAwait(future);
  int ticksAfter = GlobalScheduler_instance._currentTick;
  int ticksUsed = (ticksAfter - ticksBefore);
  assert((result == 99), 'Expected 99');
  assert((ticksUsed >= 5), 'Should use at least 5 ticks, used ${ticksUsed}');
  staticPrint('  ✓ delayed(5 ticks) completed in ${ticksUsed} ticks, result=${result}');
}

bool enableLog = true;

void main() {
  staticPrint('═══════════════════════════════════════════');
  staticPrint(' 状态机协程验证测试');
  staticPrint('═══════════════════════════════════════════');
  testBasicAwait();
  testDelayedFuture();
  testMultipleAwaitSerial();
  testNestedAsync();
  testThenChain();
  testErrorHandling();
  testParallelAwait();
  testPipeline();
  testTickCounting();
  staticPrint('\n═══════════════════════════════════════════');
  staticPrint(' ✅ 全部 9 个测试通过！');
  staticPrint('═══════════════════════════════════════════');
}

class ClosureEnv_global_0<T extends dynamic> extends TypeFunction0<void> {
  late PromiseValue<T> promise;
  late TypeFunction0<T> computation;
  late dynamic e;

  ClosureEnv_global_0() {
  }
  void call() =>
      ClosureEnv_global_0_call(this);

  @override
  void gcMark(int flag) {
    super.gcMark(flag);
    promise?.gcMark(flag);
    computation?.gcMark(flag);
  }
}

void ClosureEnv_global_0_call<T extends dynamic>(dynamic env__) {
  final env = env__ as ClosureEnv_global_0<T>;
  try {
    (env.promise.vptr['complete'] as Function)(env.promise, env.computation());
  } on dynamic catch ( e) {
    (env.promise.vptr['completeError'] as Function)(env.promise, env.e);
  }
}

ClosureEnv_global_0<T> ClosureEnv_global_0_new<T extends dynamic>(ClosureEnv_global_0<T> env_, PromiseValue<T> promise, TypeFunction0<T> computation, dynamic e) {
  env_.promise = promise;
  env_.computation = computation;
  env_.e = e;
  return env_;
}

class ClosureEnv_global_1<R extends dynamic, T extends dynamic> extends TypeFunction0<bool> {
  late PromiseValue this_;
  late PromiseValue<R> nextPromise;
  late TypeFunction1<R, T> onValue;
  late dynamic e;

  ClosureEnv_global_1() {
  }
  bool call() =>
      ClosureEnv_global_1_call(this);

  @override
  void gcMark(int flag) {
    super.gcMark(flag);
    this_?.gcMark(flag);
    nextPromise?.gcMark(flag);
    onValue?.gcMark(flag);
  }
}

bool ClosureEnv_global_1_call<R extends dynamic, T extends dynamic>(dynamic env__) {
  final env = env__ as ClosureEnv_global_1<R, T>;
  if ((env.this_.vptr['get_isCompleted'] as Function)(env.this_)) {
    try {
      (env.nextPromise.vptr['complete'] as Function)(env.nextPromise, env.onValue((env.this_.vptr['get_result'] as Function)(env.this_)));
    } on dynamic catch ( e) {
      (env.nextPromise.vptr['completeError'] as Function)(env.nextPromise, env.e);
    }
    return true;
  }
  if ((env.this_.vptr['get_isError'] as Function)(env.this_)) {
    (env.nextPromise.vptr['completeError'] as Function)(env.nextPromise, (env.this_.vptr['get_error'] as Function)(env.this_)!);
    return true;
  }
  return false;
}

ClosureEnv_global_1<R, T> ClosureEnv_global_1_new<R extends dynamic, T extends dynamic>(ClosureEnv_global_1<R, T> env_, PromiseValue this_, PromiseValue<R> nextPromise, TypeFunction1<R, T> onValue, dynamic e) {
  env_.this_ = this_;
  env_.nextPromise = nextPromise;
  env_.onValue = onValue;
  env_.e = e;
  return env_;
}

class ClosureEnv_global_2 extends TypeFunction1<bool, _DelayedTaskValue> {
  late GlobalSchedulerValue this_;

  ClosureEnv_global_2() {
  }
  bool call(_DelayedTaskValue t) =>
      ClosureEnv_global_2_call(this, t);

  @override
  void gcMark(int flag) {
    super.gcMark(flag);
    this_?.gcMark(flag);
  }
}

bool ClosureEnv_global_2_call(dynamic env__, _DelayedTaskValue t) {
  final env = env__ as ClosureEnv_global_2;
  return (t.targetTick <= env.this_._currentTick);
}

ClosureEnv_global_2 ClosureEnv_global_2_new(ClosureEnv_global_2 env_, GlobalSchedulerValue this_) {
  env_.this_ = this_;
  return env_;
}

class ClosureEnv_global_3 extends TypeFunction1<bool, _DelayedTaskValue> {
  late GlobalSchedulerValue this_;

  ClosureEnv_global_3() {
  }
  bool call(_DelayedTaskValue t) =>
      ClosureEnv_global_3_call(this, t);

  @override
  void gcMark(int flag) {
    super.gcMark(flag);
    this_?.gcMark(flag);
  }
}

bool ClosureEnv_global_3_call(dynamic env__, _DelayedTaskValue t) {
  final env = env__ as ClosureEnv_global_3;
  return (t.targetTick <= env.this_._currentTick);
}

ClosureEnv_global_3 ClosureEnv_global_3_new(ClosureEnv_global_3 env_, GlobalSchedulerValue this_) {
  env_.this_ = this_;
  return env_;
}

class ClosureEnv_global_4 extends TypeFunction1<bool, PromiseValue<dynamic>> {
  late StaticSet<PromiseValue<dynamic>> finished;

  ClosureEnv_global_4() {
  }
  bool call(PromiseValue<dynamic> p) =>
      ClosureEnv_global_4_call(this, p);

  @override
  void gcMark(int flag) {
    super.gcMark(flag);
    finished?.gcMark(flag);
  }
}

bool ClosureEnv_global_4_call(dynamic env__, PromiseValue<dynamic> p) {
  final env = env__ as ClosureEnv_global_4;
  return env.finished.contains(p);
}

ClosureEnv_global_4 ClosureEnv_global_4_new(ClosureEnv_global_4 env_, StaticSet<PromiseValue<dynamic>> finished) {
  env_.finished = finished;
  return env_;
}

class ClosureEnv_global_5 extends TypeFunction0<int> {
  late AddAsyncStateMachineValue this_;

  ClosureEnv_global_5() {
  }
  int call() =>
      ClosureEnv_global_5_call(this);

  @override
  void gcMark(int flag) {
    super.gcMark(flag);
    this_?.gcMark(flag);
  }
}

int ClosureEnv_global_5_call(dynamic env__) {
  final env = env__ as ClosureEnv_global_5;
  return env.this_.b;
}

ClosureEnv_global_5 ClosureEnv_global_5_new(ClosureEnv_global_5 env_, AddAsyncStateMachineValue this_) {
  env_.this_ = this_;
  return env_;
}

class ClosureEnv_global_6 extends TypeFunction0<String> {

  ClosureEnv_global_6() {
  }
  String call() =>
      ClosureEnv_global_6_call(this);
}

String ClosureEnv_global_6_call(dynamic env__) {
  final env = env__ as ClosureEnv_global_6;
  return 'inner';
}

ClosureEnv_global_6 ClosureEnv_global_6_new(ClosureEnv_global_6 env_) {
  return env_;
}

class ClosureEnv_global_7 extends TypeFunction0<void> {

  ClosureEnv_global_7() {
  }
  void call() =>
      ClosureEnv_global_7_call(this);
}

void ClosureEnv_global_7_call(dynamic env__) {
  final env = env__ as ClosureEnv_global_7;
  throw ('something went wrong');
}

ClosureEnv_global_7 ClosureEnv_global_7_new(ClosureEnv_global_7 env_) {
  return env_;
}

class ClosureEnv_global_8 extends TypeFunction0<int> {

  ClosureEnv_global_8() {
  }
  int call() =>
      ClosureEnv_global_8_call(this);
}

int ClosureEnv_global_8_call(dynamic env__) {
  final env = env__ as ClosureEnv_global_8;
  return 10;
}

ClosureEnv_global_8 ClosureEnv_global_8_new(ClosureEnv_global_8 env_) {
  return env_;
}

class ClosureEnv_global_9 extends TypeFunction0<int> {

  ClosureEnv_global_9() {
  }
  int call() =>
      ClosureEnv_global_9_call(this);
}

int ClosureEnv_global_9_call(dynamic env__) {
  final env = env__ as ClosureEnv_global_9;
  return 20;
}

ClosureEnv_global_9 ClosureEnv_global_9_new(ClosureEnv_global_9 env_) {
  return env_;
}

class ClosureEnv_global_10 extends TypeFunction0<int> {

  ClosureEnv_global_10() {
  }
  int call() =>
      ClosureEnv_global_10_call(this);
}

int ClosureEnv_global_10_call(dynamic env__) {
  final env = env__ as ClosureEnv_global_10;
  return 30;
}

ClosureEnv_global_10 ClosureEnv_global_10_new(ClosureEnv_global_10 env_) {
  return env_;
}

class ClosureEnv_global_11 extends TypeFunction1<bool, PromiseValue<int>> {

  ClosureEnv_global_11() {
  }
  bool call(PromiseValue<int> f) =>
      ClosureEnv_global_11_call(this, f);
}

bool ClosureEnv_global_11_call(dynamic env__, PromiseValue<int> f) {
  final env = env__ as ClosureEnv_global_11;
  return (f.vptr['get_isCompleted'] as Function)(f) || (f.vptr['get_isError'] as Function)(f);
}

ClosureEnv_global_11 ClosureEnv_global_11_new(ClosureEnv_global_11 env_) {
  return env_;
}

class ClosureEnv_global_12 extends TypeFunction1<int, PromiseValue<int>> {

  ClosureEnv_global_12() {
  }
  int call(PromiseValue<int> f) =>
      ClosureEnv_global_12_call(this, f);
}

int ClosureEnv_global_12_call(dynamic env__, PromiseValue<int> f) {
  final env = env__ as ClosureEnv_global_12;
  return (f.vptr['get_result'] as Function)(f);
}

ClosureEnv_global_12 ClosureEnv_global_12_new(ClosureEnv_global_12 env_) {
  return env_;
}

class ClosureEnv_global_13 extends TypeFunction0<int> {
  late ComputeStepStateMachineValue this_;

  ClosureEnv_global_13() {
  }
  int call() =>
      ClosureEnv_global_13_call(this);

  @override
  void gcMark(int flag) {
    super.gcMark(flag);
    this_?.gcMark(flag);
  }
}

int ClosureEnv_global_13_call(dynamic env__) {
  final env = env__ as ClosureEnv_global_13;
  return (env.this_.input * 2);
}

ClosureEnv_global_13 ClosureEnv_global_13_new(ClosureEnv_global_13 env_, ComputeStepStateMachineValue this_) {
  env_.this_ = this_;
  return env_;
}

class ClosureEnv_global_14 extends TypeFunction0<String> {

  ClosureEnv_global_14() {
  }
  String call() =>
      ClosureEnv_global_14_call(this);
}

String ClosureEnv_global_14_call(dynamic env__) {
  final env = env__ as ClosureEnv_global_14;
  return 'hello after delay';
}

ClosureEnv_global_14 ClosureEnv_global_14_new(ClosureEnv_global_14 env_) {
  return env_;
}

class ClosureEnv_global_15 extends TypeFunction1<int, int> {

  ClosureEnv_global_15() {
  }
  int call(int v) =>
      ClosureEnv_global_15_call(this, v);
}

int ClosureEnv_global_15_call(dynamic env__, int v) {
  final env = env__ as ClosureEnv_global_15;
  return (v * 2);
}

ClosureEnv_global_15 ClosureEnv_global_15_new(ClosureEnv_global_15 env_) {
  return env_;
}

class ClosureEnv_global_16 extends TypeFunction1<String, int> {

  ClosureEnv_global_16() {
  }
  String call(int v) =>
      ClosureEnv_global_16_call(this, v);
}

String ClosureEnv_global_16_call(dynamic env__, int v) {
  final env = env__ as ClosureEnv_global_16;
  return 'value=${v}';
}

ClosureEnv_global_16 ClosureEnv_global_16_new(ClosureEnv_global_16 env_) {
  return env_;
}

class ClosureEnv_global_17 extends TypeFunction0<int> {

  ClosureEnv_global_17() {
  }
  int call() =>
      ClosureEnv_global_17_call(this);
}

int ClosureEnv_global_17_call(dynamic env__) {
  final env = env__ as ClosureEnv_global_17;
  return 99;
}

ClosureEnv_global_17 ClosureEnv_global_17_new(ClosureEnv_global_17 env_) {
  return env_;
}

