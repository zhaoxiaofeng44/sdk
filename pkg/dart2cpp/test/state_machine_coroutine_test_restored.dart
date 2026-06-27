import 'package:dart2cpp/restorer/runtime_classes.dart';

enum CompleterState {
  pending,
  completed,
  error;
}

class PromiseValue<T> extends VPtr {
  late CompleterState _state = CompleterState.pending;
  late T? _result = null;
  late Object? _error = null;
  late TypeFunction0<bool>? _onTick = null;
  PromiseValue() {
    vptr['get_state'] = Promise_get_state<T>;
    vptr['get_isCompleted'] = Promise_get_isCompleted<T>;
    vptr['get_isError'] = Promise_get_isError<T>;
    vptr['get_isPending'] = Promise_get_isPending<T>;
    vptr['get_error'] = Promise_get_error<T>;
    vptr['get_result'] = Promise_get_result<T>;
    vptr['complete'] = Promise_complete<T>;
    vptr['completeError'] = Promise_completeError<T>;
  }
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
    if (_state is AnyGC) (_state as AnyGC).gcMark(flag);
    if (_result is AnyGC) (_result as AnyGC).gcMark(flag);
    if (_error is AnyGC) (_error as AnyGC).gcMark(flag);
    if (_onTick is AnyGC) (_onTick as AnyGC).gcMark(flag);
  }
}

PromiseValue<T> Promise_new<T>(dynamic this__) {
  final this_ = this__ as PromiseValue<T>;
  this_.vptr['then_String'] = Promise_then<T, String>;
  this_.vptr['then_int'] = Promise_then<T, int>;
  return this_;
}

CompleterState Promise_get_state<T>(dynamic this__) {
  final this_ = this__ as PromiseValue<T>;
  return this_._state;
}

bool Promise_get_isCompleted<T>(dynamic this__) {
  final this_ = this__ as PromiseValue<T>;
  return (this_._state == CompleterState.completed);
}

bool Promise_get_isError<T>(dynamic this__) {
  final this_ = this__ as PromiseValue<T>;
  return (this_._state == CompleterState.error);
}

bool Promise_get_isPending<T>(dynamic this__) {
  final this_ = this__ as PromiseValue<T>;
  return (this_._state == CompleterState.pending);
}

Object? Promise_get_error<T>(dynamic this__) {
  final this_ = this__ as PromiseValue<T>;
  return this_._error;
}

T Promise_get_result<T>(dynamic this__) {
  final this_ = this__ as PromiseValue<T>;
  if ((this_._state == CompleterState.error))   throw this_._error!;
  if (!((this_._state == CompleterState.completed))) {
    throw DartStateError('Promise not yet completed');
  }
  return (this_._result as T);
}

void Promise_complete<T>(dynamic this__, T value) {
  final this_ = this__ as PromiseValue<T>;
  if (!((this_._state == CompleterState.pending))) {
    throw DartStateError('Promise already resolved');
  }
  this_._result = value;
  this_._state = CompleterState.completed;
}

void Promise_completeError<T>(dynamic this__, Object error) {
  final this_ = this__ as PromiseValue<T>;
  if (!((this_._state == CompleterState.pending))) {
    throw DartStateError('Promise already resolved');
  }
  this_._error = error;
  this_._state = CompleterState.error;
}

PromiseValue<T> Promise_value<T>(T val) {
  final PromiseValue<T> promise = Promise_new<T>(GC.allocateLocal(PromiseValue<T>()));
  (promise.vptr['complete'] as void Function(dynamic, T))(promise, val);
  return promise;
}

PromiseValue<T> Promise_delayed<T>(int delayTicks, TypeFunction0<T> computation) {
  final PromiseValue<T> promise = Promise_new<T>(GC.allocateLocal(PromiseValue<T>()));
  (GlobalScheduler_instance.vptr['registerDelayedTask'] as void Function(dynamic, int, TypeFunction0<void>))(GlobalScheduler_instance, delayTicks, ClosureEnv_anon_1_new<T>(GC.allocateLocal(ClosureEnv_anon_1<T>()), promise, computation));
  return promise;
}

PromiseValue<R> Promise_then<T, R>(dynamic this__, TypeFunction1<R, T> onValue) {
  final this_ = this__ as PromiseValue<T>;
  final PromiseValue<R> nextPromise = Promise_new<R>(GC.allocateLocal(PromiseValue<R>()));
  nextPromise._onTick = ClosureEnv_anon_2_new<R, T>(GC.allocateLocal(ClosureEnv_anon_2<R, T>()), this_, nextPromise, onValue);
  (GlobalScheduler_instance.vptr['registerActivePromise'] as void Function(dynamic, PromiseValue<dynamic>))(GlobalScheduler_instance, nextPromise);
  return nextPromise;
}


class GlobalSchedulerValue extends VPtr {
  late StaticList<PromiseValue<dynamic>> _activePromises = StaticList<PromiseValue<dynamic>>.of([]);
  late StaticList<_DelayedTaskValue> _delayedTasks = StaticList<_DelayedTaskValue>.of([]);
  late int _currentTick = 0;
  GlobalSchedulerValue() {
    vptr['registerActivePromise'] = GlobalScheduler_registerActivePromise;
    vptr['registerDelayedTask'] = GlobalScheduler_registerDelayedTask;
    vptr['tick'] = GlobalScheduler_tick;
    vptr['get_hasActiveTasks'] = GlobalScheduler_get_hasActiveTasks;
    vptr['reset'] = GlobalScheduler_reset;
  }
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
    if (_activePromises is AnyGC) (_activePromises as AnyGC).gcMark(flag);
    if (_delayedTasks is AnyGC) (_delayedTasks as AnyGC).gcMark(flag);
  }
}

final GlobalSchedulerValue GlobalScheduler_instance = GlobalScheduler_new__(GC.allocateGlobal(GlobalSchedulerValue()));
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
  final int target = (this_._currentTick + delayTicks);
  log('registerDelayed: trigger@tick=${target} (delay=${delayTicks})');
  this_._delayedTasks.add(_DelayedTask_new(GC.allocateLocal(_DelayedTaskValue()), target, callback));
}

void GlobalScheduler_tick(dynamic this__) {
  final this_ = this__ as GlobalSchedulerValue;
  this_._currentTick = (this_._currentTick + 1);
  log('--- tick #${this_._currentTick} start (active=${this_._activePromises.length}, delayed=${this_._delayedTasks.length}) ---');
  final StaticList<_DelayedTaskValue> expired = StaticList.of(this_._delayedTasks.where(ClosureEnv_anon_3_new(GC.allocateLocal(ClosureEnv_anon_3()), this_)).toList());
  this_._delayedTasks.removeWhere(ClosureEnv_anon_4_new(GC.allocateLocal(ClosureEnv_anon_4()), this_));
  for (final task in expired) {
    log('  delayed task triggered @tick=${this_._currentTick}');
    task.callback.closureCall(task.callback);
  }
  final StaticList<PromiseValue<dynamic>> snapshot = StaticList<PromiseValue<dynamic>>.of(this_._activePromises);
  final StaticSet<PromiseValue<dynamic>> finished = StaticSet<PromiseValue<dynamic>>.of([]);
  for (final promise in snapshot)   do {
{
      if (((promise.vptr['get_isCompleted'] as bool Function(dynamic))(promise) || (promise.vptr['get_isError'] as bool Function(dynamic))(promise))) {
        finished.add(promise);
        break;
      }
      final TypeFunction0<bool>? onTick = promise._onTick;
      if ((!((onTick == null)) && onTick.closureCall(onTick))) {
        finished.add(promise);
      }
    }
  } while (false);
  this_._activePromises.removeWhere(ClosureEnv_anon_5_new(GC.allocateLocal(ClosureEnv_anon_5()), finished));
  log('--- tick #${this_._currentTick} end (remaining active=${this_._activePromises.length}) ---');
}

bool GlobalScheduler_get_hasActiveTasks(dynamic this__) {
  final this_ = this__ as GlobalSchedulerValue;
  return (this_._activePromises.isNotEmpty || this_._delayedTasks.isNotEmpty);
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
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
    if (callback is AnyGC) (callback as AnyGC).gcMark(flag);
  }
}

_DelayedTaskValue _DelayedTask_new(dynamic this__, int targetTick, TypeFunction0<void> callback) {
  final this_ = this__ as _DelayedTaskValue;
  this_.targetTick = targetTick;
  this_.callback = callback;
  return this_;
}


class AsyncStateMachineValue<T> extends VPtr {
  late int smState = 0;
  late PromiseValue<T> promise = Promise_new<T>(GC.allocateLocal(PromiseValue<T>()));
  AsyncStateMachineValue() {
    vptr['step'] = AsyncStateMachine_step<T>;
    vptr['completeWith'] = AsyncStateMachine_completeWith<T>;
    vptr['completeWithError'] = AsyncStateMachine_completeWithError<T>;
    vptr['start'] = AsyncStateMachine_start<T>;
  }
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
    if (promise is AnyGC) (promise as AnyGC).gcMark(flag);
  }
}

AsyncStateMachineValue<T> AsyncStateMachine_new<T>(dynamic this__) {
  final this_ = this__ as AsyncStateMachineValue<T>;
  return this_;
}

bool AsyncStateMachine_step<T>(dynamic this_) {
  throw UnimplementedError('AsyncStateMachine.step is abstract');
}

void AsyncStateMachine_completeWith<T>(dynamic this__, T value) {
  final this_ = this__ as AsyncStateMachineValue<T>;
  (this_.promise.vptr['complete'] as void Function(dynamic, T))(this_.promise, value);
}

void AsyncStateMachine_completeWithError<T>(dynamic this__, Object error) {
  final this_ = this__ as AsyncStateMachineValue<T>;
  (this_.promise.vptr['completeError'] as void Function(dynamic, Object))(this_.promise, error);
}

PromiseValue<T> AsyncStateMachine_start<T>(dynamic this__) {
  final this_ = this__ as AsyncStateMachineValue<T>;
  this_.promise._onTick = ClosureEnv_anon_6_new(GC.allocateLocal(ClosureEnv_anon_6()), this_);
  (GlobalScheduler_instance.vptr['registerActivePromise'] as void Function(dynamic, PromiseValue<dynamic>))(GlobalScheduler_instance, this_.promise);
  return this_.promise;
}


class AddAsyncStateMachineValue extends AsyncStateMachineValue<int> {
  late int a;
  late int b;
  late int _x = 0;
  late int _y = 0;
  late PromiseValue<int>? _pendingFuture = null;
  AddAsyncStateMachineValue() {
    vptr['step'] = AddAsyncStateMachine_step;
    vptr['completeWith'] = AddAsyncStateMachine_completeWith;
    vptr['completeWithError'] = AddAsyncStateMachine_completeWithError;
    vptr['start'] = AddAsyncStateMachine_start;
    vptr['get_debugName'] = AddAsyncStateMachine_get_debugName;
  }
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
    if (_pendingFuture is AnyGC) (_pendingFuture as AnyGC).gcMark(flag);
  }
}

AddAsyncStateMachineValue AddAsyncStateMachine_new(dynamic this__, int a, int b) {
  final this_ = this__ as AddAsyncStateMachineValue;
  AsyncStateMachine_new<int>(this_);
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
{
          this_._pendingFuture = Promise_value<int>(this_.a);
          this_.smState = 1;
          log('  ${(this_.vptr['get_debugName'] as String Function(dynamic))(this_)}: state 0→1, created value future for ${this_.a}');
          return false;
        }
      case 1:
{
          if ((() { final _r0 = this_._pendingFuture!; return (_r0.vptr['get_isPending'] as bool Function(dynamic))(_r0); })())           return false;
          this_._x = (() { final _r1 = this_._pendingFuture!; return (_r1.vptr['get_result'] as int Function(dynamic))(_r1); })();
          this_._pendingFuture = Promise_delayed<int>(2, ClosureEnv_anon_7_new(GC.allocateLocal(ClosureEnv_anon_7()), this_));
          this_.smState = 2;
          log('  ${(this_.vptr['get_debugName'] as String Function(dynamic))(this_)}: state 1→2, got x=${this_._x}, created delayed future for ${this_.b}');
          return false;
        }
      case 2:
{
          if ((() { final _r2 = this_._pendingFuture!; return (_r2.vptr['get_isPending'] as bool Function(dynamic))(_r2); })())           return false;
          this_._y = (() { final _r3 = this_._pendingFuture!; return (_r3.vptr['get_result'] as int Function(dynamic))(_r3); })();
          log('  ${(this_.vptr['get_debugName'] as String Function(dynamic))(this_)}: state 2→done, got y=${this_._y}, result=${(this_._x + this_._y)}');
          (this_.vptr['completeWith'] as void Function(dynamic, int))(this_, (this_._x + this_._y));
          return true;
        }
      default:
{
          return true;
        }
    }
  } while (false);
}

void AddAsyncStateMachine_completeWith(dynamic this__, int value) {
  final this_ = this__ as AddAsyncStateMachineValue;
  AsyncStateMachine_completeWith<int>(this_, value);
}

void AddAsyncStateMachine_completeWithError(dynamic this__, Object error) {
  final this_ = this__ as AddAsyncStateMachineValue;
  AsyncStateMachine_completeWithError<int>(this_, error);
}

PromiseValue<int> AddAsyncStateMachine_start(dynamic this__) {
  final this_ = this__ as AddAsyncStateMachineValue;
  return AsyncStateMachine_start<int>(this_);
}


class InnerAsyncStateMachineValue extends AsyncStateMachineValue<String> {
  late PromiseValue<String>? _pendingFuture = null;
  InnerAsyncStateMachineValue() {
    vptr['step'] = InnerAsyncStateMachine_step;
    vptr['completeWith'] = InnerAsyncStateMachine_completeWith;
    vptr['completeWithError'] = InnerAsyncStateMachine_completeWithError;
    vptr['start'] = InnerAsyncStateMachine_start;
    vptr['get_debugName'] = InnerAsyncStateMachine_get_debugName;
  }
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
    if (_pendingFuture is AnyGC) (_pendingFuture as AnyGC).gcMark(flag);
  }
}

InnerAsyncStateMachineValue InnerAsyncStateMachine_new(dynamic this__) {
  final this_ = this__ as InnerAsyncStateMachineValue;
  AsyncStateMachine_new<String>(this_);
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
{
          this_._pendingFuture = Promise_delayed<String>(2, ClosureEnv_anon_8_new(GC.allocateLocal(ClosureEnv_anon_8())));
          this_.smState = 1;
          log('  ${(this_.vptr['get_debugName'] as String Function(dynamic))(this_)}: state 0→1, created delayed future');
          return false;
        }
      case 1:
{
          if ((() { final _r4 = this_._pendingFuture!; return (_r4.vptr['get_isPending'] as bool Function(dynamic))(_r4); })())           return false;
          final String val = (() { final _r5 = this_._pendingFuture!; return (_r5.vptr['get_result'] as String Function(dynamic))(_r5); })();
          log('  ${(this_.vptr['get_debugName'] as String Function(dynamic))(this_)}: state 1→done, val=${val} → ${val.toUpperCase()}');
          (this_.vptr['completeWith'] as void Function(dynamic, String))(this_, val.toUpperCase());
          return true;
        }
      default:
{
          return true;
        }
    }
  } while (false);
}

void InnerAsyncStateMachine_completeWith(dynamic this__, String value) {
  final this_ = this__ as InnerAsyncStateMachineValue;
  AsyncStateMachine_completeWith<String>(this_, value);
}

void InnerAsyncStateMachine_completeWithError(dynamic this__, Object error) {
  final this_ = this__ as InnerAsyncStateMachineValue;
  AsyncStateMachine_completeWithError<String>(this_, error);
}

PromiseValue<String> InnerAsyncStateMachine_start(dynamic this__) {
  final this_ = this__ as InnerAsyncStateMachineValue;
  return AsyncStateMachine_start<String>(this_);
}


class OuterAsyncStateMachineValue extends AsyncStateMachineValue<String> {
  late String _prefix = '';
  late PromiseValue<String>? _pendingFuture = null;
  OuterAsyncStateMachineValue() {
    vptr['step'] = OuterAsyncStateMachine_step;
    vptr['completeWith'] = OuterAsyncStateMachine_completeWith;
    vptr['completeWithError'] = OuterAsyncStateMachine_completeWithError;
    vptr['start'] = OuterAsyncStateMachine_start;
    vptr['get_debugName'] = OuterAsyncStateMachine_get_debugName;
  }
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
    if (_pendingFuture is AnyGC) (_pendingFuture as AnyGC).gcMark(flag);
  }
}

OuterAsyncStateMachineValue OuterAsyncStateMachine_new(dynamic this__) {
  final this_ = this__ as OuterAsyncStateMachineValue;
  AsyncStateMachine_new<String>(this_);
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
{
          this_._pendingFuture = Promise_value<String>('result:');
          this_.smState = 1;
          log('  ${(this_.vptr['get_debugName'] as String Function(dynamic))(this_)}: state 0→1, created value future');
          return false;
        }
      case 1:
{
          if ((() { final _r6 = this_._pendingFuture!; return (_r6.vptr['get_isPending'] as bool Function(dynamic))(_r6); })())           return false;
          this_._prefix = (() { final _r7 = this_._pendingFuture!; return (_r7.vptr['get_result'] as String Function(dynamic))(_r7); })();
          final InnerAsyncStateMachineValue innerSm = InnerAsyncStateMachine_new(GC.allocateLocal(InnerAsyncStateMachineValue()));
          this_._pendingFuture = (innerSm.vptr['start'] as PromiseValue<String> Function(dynamic))(innerSm);
          this_.smState = 2;
          log('  ${(this_.vptr['get_debugName'] as String Function(dynamic))(this_)}: state 1→2, prefix=${this_._prefix}, started InnerAsync');
          return false;
        }
      case 2:
{
          if ((() { final _r8 = this_._pendingFuture!; return (_r8.vptr['get_isPending'] as bool Function(dynamic))(_r8); })())           return false;
          final String innerResult = (() { final _r9 = this_._pendingFuture!; return (_r9.vptr['get_result'] as String Function(dynamic))(_r9); })();
          log('  ${(this_.vptr['get_debugName'] as String Function(dynamic))(this_)}: state 2→done, inner=${innerResult}');
          (this_.vptr['completeWith'] as void Function(dynamic, String))(this_, '${this_._prefix} ${innerResult}');
          return true;
        }
      default:
{
          return true;
        }
    }
  } while (false);
}

void OuterAsyncStateMachine_completeWith(dynamic this__, String value) {
  final this_ = this__ as OuterAsyncStateMachineValue;
  AsyncStateMachine_completeWith<String>(this_, value);
}

void OuterAsyncStateMachine_completeWithError(dynamic this__, Object error) {
  final this_ = this__ as OuterAsyncStateMachineValue;
  AsyncStateMachine_completeWithError<String>(this_, error);
}

PromiseValue<String> OuterAsyncStateMachine_start(dynamic this__) {
  final this_ = this__ as OuterAsyncStateMachineValue;
  return AsyncStateMachine_start<String>(this_);
}


class ErrorStateMachineValue extends AsyncStateMachineValue<String> {
  late PromiseValue<int>? _pendingFuture = null;
  ErrorStateMachineValue() {
    vptr['step'] = ErrorStateMachine_step;
    vptr['completeWith'] = ErrorStateMachine_completeWith;
    vptr['completeWithError'] = ErrorStateMachine_completeWithError;
    vptr['start'] = ErrorStateMachine_start;
    vptr['get_debugName'] = ErrorStateMachine_get_debugName;
  }
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
    if (_pendingFuture is AnyGC) (_pendingFuture as AnyGC).gcMark(flag);
  }
}

ErrorStateMachineValue ErrorStateMachine_new(dynamic this__) {
  final this_ = this__ as ErrorStateMachineValue;
  AsyncStateMachine_new<String>(this_);
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
{
          this_._pendingFuture = Promise_delayed<int>(1, ClosureEnv_anon_9_new(GC.allocateLocal(ClosureEnv_anon_9())));
          this_.smState = 1;
          log('  ${(this_.vptr['get_debugName'] as String Function(dynamic))(this_)}: state 0→1, created delayed future (will throw)');
          return false;
        }
      case 1:
{
          if ((() { final _r10 = this_._pendingFuture!; return (_r10.vptr['get_isPending'] as bool Function(dynamic))(_r10); })())           return false;
          if ((() { final _r11 = this_._pendingFuture!; return (_r11.vptr['get_isError'] as bool Function(dynamic))(_r11); })()) {
            log('  ${(this_.vptr['get_debugName'] as String Function(dynamic))(this_)}: state 1→done, caught error');
            (this_.vptr['completeWith'] as void Function(dynamic, String))(this_, 'caught: ${(() { final _r13 = this_._pendingFuture!; return (_r13.vptr['get_error'] as Object? Function(dynamic))(_r13); })()}');
            return true;
          }
          (this_.vptr['completeWith'] as void Function(dynamic, String))(this_, 'unexpected success');
          return true;
        }
      default:
{
          return true;
        }
    }
  } while (false);
}

void ErrorStateMachine_completeWith(dynamic this__, String value) {
  final this_ = this__ as ErrorStateMachineValue;
  AsyncStateMachine_completeWith<String>(this_, value);
}

void ErrorStateMachine_completeWithError(dynamic this__, Object error) {
  final this_ = this__ as ErrorStateMachineValue;
  AsyncStateMachine_completeWithError<String>(this_, error);
}

PromiseValue<String> ErrorStateMachine_start(dynamic this__) {
  final this_ = this__ as ErrorStateMachineValue;
  return AsyncStateMachine_start<String>(this_);
}


class ParallelAwaitStateMachineValue extends AsyncStateMachineValue<StaticList<int>> {
  late StaticList<PromiseValue<int>> _futures;
  ParallelAwaitStateMachineValue() {
    vptr['step'] = ParallelAwaitStateMachine_step;
    vptr['completeWith'] = ParallelAwaitStateMachine_completeWith;
    vptr['completeWithError'] = ParallelAwaitStateMachine_completeWithError;
    vptr['start'] = ParallelAwaitStateMachine_start;
    vptr['get_debugName'] = ParallelAwaitStateMachine_get_debugName;
  }
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
    if (_futures is AnyGC) (_futures as AnyGC).gcMark(flag);
  }
}

ParallelAwaitStateMachineValue ParallelAwaitStateMachine_new(dynamic this__) {
  final this_ = this__ as ParallelAwaitStateMachineValue;
  AsyncStateMachine_new<StaticList<int>>(this_);
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
{
          this_._futures = StaticList<PromiseValue<int>>.of([Promise_delayed<int>(3, ClosureEnv_anon_10_new(GC.allocateLocal(ClosureEnv_anon_10()))), Promise_delayed<int>(2, ClosureEnv_anon_11_new(GC.allocateLocal(ClosureEnv_anon_11()))), Promise_delayed<int>(1, ClosureEnv_anon_12_new(GC.allocateLocal(ClosureEnv_anon_12())))]);
          this_.smState = 1;
          log('  ${(this_.vptr['get_debugName'] as String Function(dynamic))(this_)}: state 0→1, created 3 delayed futures');
          return false;
        }
      case 1:
{
          final bool allDone = this_._futures.every(ClosureEnv_anon_13_new(GC.allocateLocal(ClosureEnv_anon_13())));
          if (!(allDone))           return false;
          final StaticList<int> results = StaticList.of(this_._futures.map(ClosureEnv_anon_14_new(GC.allocateLocal(ClosureEnv_anon_14()))).toList());
          log('  ${(this_.vptr['get_debugName'] as String Function(dynamic))(this_)}: state 1→done, all futures completed: ${results}');
          (this_.vptr['completeWith'] as void Function(dynamic, StaticList<int>))(this_, results);
          return true;
        }
      default:
{
          return true;
        }
    }
  } while (false);
}

void ParallelAwaitStateMachine_completeWith(dynamic this__, StaticList<int> value) {
  final this_ = this__ as ParallelAwaitStateMachineValue;
  AsyncStateMachine_completeWith<StaticList<int>>(this_, value);
}

void ParallelAwaitStateMachine_completeWithError(dynamic this__, Object error) {
  final this_ = this__ as ParallelAwaitStateMachineValue;
  AsyncStateMachine_completeWithError<StaticList<int>>(this_, error);
}

PromiseValue<StaticList<int>> ParallelAwaitStateMachine_start(dynamic this__) {
  final this_ = this__ as ParallelAwaitStateMachineValue;
  return AsyncStateMachine_start<StaticList<int>>(this_);
}


class ComputeStepStateMachineValue extends AsyncStateMachineValue<int> {
  late int input;
  late PromiseValue<int>? _pendingFuture = null;
  ComputeStepStateMachineValue() {
    vptr['step'] = ComputeStepStateMachine_step;
    vptr['completeWith'] = ComputeStepStateMachine_completeWith;
    vptr['completeWithError'] = ComputeStepStateMachine_completeWithError;
    vptr['start'] = ComputeStepStateMachine_start;
    vptr['get_debugName'] = ComputeStepStateMachine_get_debugName;
  }
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
    if (_pendingFuture is AnyGC) (_pendingFuture as AnyGC).gcMark(flag);
  }
}

ComputeStepStateMachineValue ComputeStepStateMachine_new(dynamic this__, int input) {
  final this_ = this__ as ComputeStepStateMachineValue;
  AsyncStateMachine_new<int>(this_);
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
{
          this_._pendingFuture = Promise_delayed<int>(1, ClosureEnv_anon_15_new(GC.allocateLocal(ClosureEnv_anon_15()), this_));
          this_.smState = 1;
          log('  ${(this_.vptr['get_debugName'] as String Function(dynamic))(this_)}: state 0→1');
          return false;
        }
      case 1:
{
          if ((() { final _r14 = this_._pendingFuture!; return (_r14.vptr['get_isPending'] as bool Function(dynamic))(_r14); })())           return false;
          final int r = (() { final _r15 = this_._pendingFuture!; return (_r15.vptr['get_result'] as int Function(dynamic))(_r15); })();
          log('  ${(this_.vptr['get_debugName'] as String Function(dynamic))(this_)}: state 1→done, result=${r}');
          (this_.vptr['completeWith'] as void Function(dynamic, int))(this_, r);
          return true;
        }
      default:
{
          return true;
        }
    }
  } while (false);
}

void ComputeStepStateMachine_completeWith(dynamic this__, int value) {
  final this_ = this__ as ComputeStepStateMachineValue;
  AsyncStateMachine_completeWith<int>(this_, value);
}

void ComputeStepStateMachine_completeWithError(dynamic this__, Object error) {
  final this_ = this__ as ComputeStepStateMachineValue;
  AsyncStateMachine_completeWithError<int>(this_, error);
}

PromiseValue<int> ComputeStepStateMachine_start(dynamic this__) {
  final this_ = this__ as ComputeStepStateMachineValue;
  return AsyncStateMachine_start<int>(this_);
}


class PipelineStateMachineValue extends AsyncStateMachineValue<int> {
  late int _a = 0;
  late int _b = 0;
  late int _c = 0;
  late PromiseValue<int>? _pendingFuture = null;
  PipelineStateMachineValue() {
    vptr['step'] = PipelineStateMachine_step;
    vptr['completeWith'] = PipelineStateMachine_completeWith;
    vptr['completeWithError'] = PipelineStateMachine_completeWithError;
    vptr['start'] = PipelineStateMachine_start;
    vptr['get_debugName'] = PipelineStateMachine_get_debugName;
  }
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
    if (_pendingFuture is AnyGC) (_pendingFuture as AnyGC).gcMark(flag);
  }
}

PipelineStateMachineValue PipelineStateMachine_new(dynamic this__) {
  final this_ = this__ as PipelineStateMachineValue;
  AsyncStateMachine_new<int>(this_);
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
{
          this_._pendingFuture = (() { final _r16 = ComputeStepStateMachine_new(GC.allocateLocal(ComputeStepStateMachineValue()), 1); return (_r16.vptr['start'] as PromiseValue<int> Function(dynamic))(_r16); })();
          this_.smState = 1;
          log('  ${(this_.vptr['get_debugName'] as String Function(dynamic))(this_)}: state 0→1, started ComputeStep(1)');
          return false;
        }
      case 1:
{
          if ((() { final _r17 = this_._pendingFuture!; return (_r17.vptr['get_isPending'] as bool Function(dynamic))(_r17); })())           return false;
          this_._a = (() { final _r18 = this_._pendingFuture!; return (_r18.vptr['get_result'] as int Function(dynamic))(_r18); })();
          this_._pendingFuture = (() { final _r19 = ComputeStepStateMachine_new(GC.allocateLocal(ComputeStepStateMachineValue()), this_._a); return (_r19.vptr['start'] as PromiseValue<int> Function(dynamic))(_r19); })();
          this_.smState = 2;
          log('  ${(this_.vptr['get_debugName'] as String Function(dynamic))(this_)}: state 1→2, a=${this_._a}, started ComputeStep(${this_._a})');
          return false;
        }
      case 2:
{
          if ((() { final _r20 = this_._pendingFuture!; return (_r20.vptr['get_isPending'] as bool Function(dynamic))(_r20); })())           return false;
          this_._b = (() { final _r21 = this_._pendingFuture!; return (_r21.vptr['get_result'] as int Function(dynamic))(_r21); })();
          this_._pendingFuture = (() { final _r22 = ComputeStepStateMachine_new(GC.allocateLocal(ComputeStepStateMachineValue()), this_._b); return (_r22.vptr['start'] as PromiseValue<int> Function(dynamic))(_r22); })();
          this_.smState = 3;
          log('  ${(this_.vptr['get_debugName'] as String Function(dynamic))(this_)}: state 2→3, b=${this_._b}, started ComputeStep(${this_._b})');
          return false;
        }
      case 3:
{
          if ((() { final _r23 = this_._pendingFuture!; return (_r23.vptr['get_isPending'] as bool Function(dynamic))(_r23); })())           return false;
          this_._c = (() { final _r24 = this_._pendingFuture!; return (_r24.vptr['get_result'] as int Function(dynamic))(_r24); })();
          log('  ${(this_.vptr['get_debugName'] as String Function(dynamic))(this_)}: state 3→done, c=${this_._c}, sum=${((this_._a + this_._b) + this_._c)}');
          (this_.vptr['completeWith'] as void Function(dynamic, int))(this_, ((this_._a + this_._b) + this_._c));
          return true;
        }
      default:
{
          return true;
        }
    }
  } while (false);
}

void PipelineStateMachine_completeWith(dynamic this__, int value) {
  final this_ = this__ as PipelineStateMachineValue;
  AsyncStateMachine_completeWith<int>(this_, value);
}

void PipelineStateMachine_completeWithError(dynamic this__, Object error) {
  final this_ = this__ as PipelineStateMachineValue;
  AsyncStateMachine_completeWithError<int>(this_, error);
}

PromiseValue<int> PipelineStateMachine_start(dynamic this__) {
  final this_ = this__ as PipelineStateMachineValue;
  return AsyncStateMachine_start<int>(this_);
}


void log(String msg) {
  if (enableLog)   staticPrint('  [LOG] ${msg}');
}

T smAwait<T>(PromiseValue<T> future) {
  int roundCount = 0;
  log('smAwait: waiting for future (completed=${(future.vptr['get_isCompleted'] as bool Function(dynamic))(future)})');
  while ((!((future.vptr['get_isCompleted'] as bool Function(dynamic))(future)) && !((future.vptr['get_isError'] as bool Function(dynamic))(future)))) {
    (GlobalScheduler_instance.vptr['tick'] as void Function(dynamic))(GlobalScheduler_instance);
    roundCount = (roundCount + 1);
    if ((roundCount > 100000)) {
      throw DartStateError('smAwait exceeded 100000 rounds — possible deadlock');
    }
  }
  if ((future.vptr['get_isError'] as bool Function(dynamic))(future)) {
    log('smAwait: future resolved with ERROR after ${roundCount} ticks');
    throw (future.vptr['get_error'] as Object? Function(dynamic))(future)!;
  }
  log('smAwait: future resolved with value after ${roundCount} ticks');
  return (future.vptr['get_result'] as dynamic Function(dynamic))(future);
}

void testBasicAwait() {
  staticPrint('\n--- Demo 1: 基础 await (Promise.value) ---');
  (GlobalScheduler_instance.vptr['reset'] as void Function(dynamic))(GlobalScheduler_instance);
  final PromiseValue<int> future = Promise_value<int>(42);
  final int result = smAwait<int>(future);
  assert((result == 42), 'Expected 42, got ${result}');
  staticPrint('  ✓ smAwait(Promise.value(42)) = ${result}');
}

void testDelayedFuture() {
  staticPrint('\n--- Demo 2: 延迟 Future ---');
  (GlobalScheduler_instance.vptr['reset'] as void Function(dynamic))(GlobalScheduler_instance);
  final PromiseValue<String> future = Promise_delayed<String>(3, ClosureEnv_testDelayedFuture_16_new(GC.allocateLocal(ClosureEnv_testDelayedFuture_16())));
  final String result = smAwait<String>(future);
  assert((result == 'hello after delay'), 'Unexpected result: ${result}');
  staticPrint('  ✓ smAwait(delayed(3 ticks)) = "${result}"');
}

void testMultipleAwaitSerial() {
  staticPrint('\n--- Demo 3: 多 await 串行 (addAsync(10, 20)) ---');
  (GlobalScheduler_instance.vptr['reset'] as void Function(dynamic))(GlobalScheduler_instance);
  final AddAsyncStateMachineValue sm = AddAsyncStateMachine_new(GC.allocateLocal(AddAsyncStateMachineValue()), 10, 20);
  final PromiseValue<int> future = (sm.vptr['start'] as PromiseValue<int> Function(dynamic))(sm);
  final int result = smAwait<int>(future);
  assert((result == 30), 'Expected 30, got ${result}');
  staticPrint('  ✓ addAsync(10, 20) = ${result}');
}

void testNestedAsync() {
  staticPrint('\n--- Demo 4: 嵌套异步调用 ---');
  (GlobalScheduler_instance.vptr['reset'] as void Function(dynamic))(GlobalScheduler_instance);
  final OuterAsyncStateMachineValue sm = OuterAsyncStateMachine_new(GC.allocateLocal(OuterAsyncStateMachineValue()));
  final PromiseValue<String> future = (sm.vptr['start'] as PromiseValue<String> Function(dynamic))(sm);
  final String result = smAwait<String>(future);
  assert((result == 'result: INNER'), 'Expected "result: INNER", got "${result}"');
  staticPrint('  ✓ outerAsync() = "${result}"');
}

void testThenChain() {
  staticPrint('\n--- Demo 5: then 链式调用 ---');
  (GlobalScheduler_instance.vptr['reset'] as void Function(dynamic))(GlobalScheduler_instance);
  final PromiseValue<String> future = (() { final _r26 = (() { final _r25 = Promise_value<int>(5); return (_r25.vptr['then_int'] as PromiseValue<int> Function(dynamic, TypeFunction1<int, int>))(_r25, ClosureEnv_testThenChain_18_new(GC.allocateLocal(ClosureEnv_testThenChain_18()))); })(); return (_r26.vptr['then_String'] as PromiseValue<String> Function(dynamic, TypeFunction1<String, int>))(_r26, ClosureEnv_testThenChain_20_new(GC.allocateLocal(ClosureEnv_testThenChain_20()))); })();
  final String result = smAwait<String>(future);
  assert((result == 'value=10'), 'Expected "value=10", got "${result}"');
  staticPrint('  ✓ Promise.value(5).then(*2).then(format) = "${result}"');
}

void testErrorHandling() {
  staticPrint('\n--- Demo 6: 异常处理 ---');
  (GlobalScheduler_instance.vptr['reset'] as void Function(dynamic))(GlobalScheduler_instance);
  final ErrorStateMachineValue sm = ErrorStateMachine_new(GC.allocateLocal(ErrorStateMachineValue()));
  final PromiseValue<String> future = (sm.vptr['start'] as PromiseValue<String> Function(dynamic))(sm);
  final String result = smAwait<String>(future);
  assert(result.contains('something went wrong'), 'Error not caught: ${result}');
  staticPrint('  ✓ error caught and recovered: "${result}"');
}

void testParallelAwait() {
  staticPrint('\n--- Demo 7: 并行 await (Future.wait 模拟) ---');
  (GlobalScheduler_instance.vptr['reset'] as void Function(dynamic))(GlobalScheduler_instance);
  final ParallelAwaitStateMachineValue sm = ParallelAwaitStateMachine_new(GC.allocateLocal(ParallelAwaitStateMachineValue()));
  final PromiseValue<StaticList<int>> future = (sm.vptr['start'] as PromiseValue<StaticList<int>> Function(dynamic))(sm);
  final StaticList<int> result = StaticList<int>.of(smAwait<StaticList<int>>(future));
  assert((result.length == 3), 'Expected 3 results');
  assert((((result[0] == 10) && (result[1] == 20)) && (result[2] == 30)), 'Unexpected results: ${result}');
  staticPrint('  ✓ parallel([d3→10, d2→20, d1→30]) = ${result}');
}

void testPipeline() {
  staticPrint('\n--- Demo 8: 多层嵌套管道 pipeline ---');
  (GlobalScheduler_instance.vptr['reset'] as void Function(dynamic))(GlobalScheduler_instance);
  final PipelineStateMachineValue sm = PipelineStateMachine_new(GC.allocateLocal(PipelineStateMachineValue()));
  final PromiseValue<int> future = (sm.vptr['start'] as PromiseValue<int> Function(dynamic))(sm);
  final int result = smAwait<int>(future);
  assert((result == 14), 'Expected 14, got ${result}');
  staticPrint('  ✓ pipeline(1→2→4→8, sum=14) = ${result}');
}

void testTickCounting() {
  staticPrint('\n--- Demo 9: tick 计数验证 ---');
  (GlobalScheduler_instance.vptr['reset'] as void Function(dynamic))(GlobalScheduler_instance);
  final PromiseValue<int> future = Promise_delayed<int>(5, ClosureEnv_testTickCounting_21_new(GC.allocateLocal(ClosureEnv_testTickCounting_21())));
  int ticksBefore = GlobalScheduler_instance._currentTick;
  final int result = smAwait<int>(future);
  int ticksAfter = GlobalScheduler_instance._currentTick;
  int ticksUsed = (ticksAfter - ticksBefore);
  assert((result == 99), 'Expected 99');
  assert((ticksUsed >= 5), 'Should use at least 5 ticks, used ${ticksUsed}');
  staticPrint('  ✓ delayed(5 ticks) completed in ${ticksUsed} ticks, result=${result}');
}

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

bool enableLog = true;
class ClosureEnv_anon_0<T> extends TypeFunction0<void> {
  late PromiseValue<T> promise;
  late TypeFunction0<T> computation;
  ClosureEnv_anon_0();
  @override
  void call() => closureCall(this);
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
    if (promise is AnyGC) (promise as AnyGC).gcMark(flag);
    if (computation is AnyGC) (computation as AnyGC).gcMark(flag);
  }
}
ClosureEnv_anon_0<T> ClosureEnv_anon_0_new<T>(ClosureEnv_anon_0<T> env_, PromiseValue<T> promise, TypeFunction0<T> computation) {
  env_.closureCall = ClosureEnv_anon_0_call<T>;
  env_.promise = promise;
  env_.computation = computation;
  return env_;
}
void ClosureEnv_anon_0_call<T>(dynamic env__) {
  final env = env__ as ClosureEnv_anon_0<T>;

    try {
      (env.promise.vptr['complete'] as void Function(dynamic, T))(env.promise, env.computation.closureCall(env.computation));
    }
 catch (e) {
      (env.promise.vptr['completeError'] as void Function(dynamic, Object))(env.promise, e);
    }
  }

class ClosureEnv_anon_1<T> extends TypeFunction0<void> {
  late PromiseValue<T> promise;
  late TypeFunction0<T> computation;
  ClosureEnv_anon_1();
  @override
  void call() => closureCall(this);
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
    if (promise is AnyGC) (promise as AnyGC).gcMark(flag);
    if (computation is AnyGC) (computation as AnyGC).gcMark(flag);
  }
}
ClosureEnv_anon_1<T> ClosureEnv_anon_1_new<T>(ClosureEnv_anon_1<T> env_, PromiseValue<T> promise, TypeFunction0<T> computation) {
  env_.closureCall = ClosureEnv_anon_1_call<T>;
  env_.promise = promise;
  env_.computation = computation;
  return env_;
}
void ClosureEnv_anon_1_call<T>(dynamic env__) {
  final env = env__ as ClosureEnv_anon_1<T>;

    try {
      (env.promise.vptr['complete'] as void Function(dynamic, T))(env.promise, env.computation.closureCall(env.computation));
    }
 catch (e) {
      (env.promise.vptr['completeError'] as void Function(dynamic, Object))(env.promise, e);
    }
  }

class ClosureEnv_anon_2<R, T> extends TypeFunction0<bool> {
  late PromiseValue<T> this_;
  late PromiseValue<R> nextPromise;
  late TypeFunction1<R, T> onValue;
  ClosureEnv_anon_2();
  @override
  bool call() => closureCall(this);
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
    if (this_ is AnyGC) (this_ as AnyGC).gcMark(flag);
    if (nextPromise is AnyGC) (nextPromise as AnyGC).gcMark(flag);
    if (onValue is AnyGC) (onValue as AnyGC).gcMark(flag);
  }
}
ClosureEnv_anon_2<R, T> ClosureEnv_anon_2_new<R, T>(ClosureEnv_anon_2<R, T> env_, PromiseValue<T> this_, PromiseValue<R> nextPromise, TypeFunction1<R, T> onValue) {
  env_.closureCall = ClosureEnv_anon_2_call<R, T>;
  env_.this_ = this_;
  env_.nextPromise = nextPromise;
  env_.onValue = onValue;
  return env_;
}
bool ClosureEnv_anon_2_call<R, T>(dynamic env__) {
  final env = env__ as ClosureEnv_anon_2<R, T>;

    if ((env.this_.vptr['get_isCompleted'] as bool Function(dynamic))(env.this_)) {
      try {
        (env.nextPromise.vptr['complete'] as void Function(dynamic, R))(env.nextPromise, env.onValue.closureCall(env.onValue, (env.this_.vptr['get_result'] as T Function(dynamic))(env.this_)));
      }
 catch (e) {
        (env.nextPromise.vptr['completeError'] as void Function(dynamic, Object))(env.nextPromise, e);
      }
      return true;
    }
    if ((env.this_.vptr['get_isError'] as bool Function(dynamic))(env.this_)) {
      (env.nextPromise.vptr['completeError'] as void Function(dynamic, Object))(env.nextPromise, (env.this_.vptr['get_error'] as Object? Function(dynamic))(env.this_)!);
      return true;
    }
    return false;
  }

class ClosureEnv_anon_3 extends TypeFunction1<bool, _DelayedTaskValue> {
  late GlobalSchedulerValue this_;
  ClosureEnv_anon_3();
  @override
  bool call(_DelayedTaskValue t) => closureCall(this, t);
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
    if (this_ is AnyGC) (this_ as AnyGC).gcMark(flag);
  }
}
ClosureEnv_anon_3 ClosureEnv_anon_3_new(ClosureEnv_anon_3 env_, GlobalSchedulerValue this_) {
  env_.closureCall = ClosureEnv_anon_3_call;
  env_.this_ = this_;
  return env_;
}
bool ClosureEnv_anon_3_call(dynamic env__, _DelayedTaskValue t) {
  final env = env__ as ClosureEnv_anon_3;

  return (t.targetTick <= env.this_._currentTick);
}

class ClosureEnv_anon_4 extends TypeFunction1<bool, _DelayedTaskValue> {
  late GlobalSchedulerValue this_;
  ClosureEnv_anon_4();
  @override
  bool call(_DelayedTaskValue t) => closureCall(this, t);
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
    if (this_ is AnyGC) (this_ as AnyGC).gcMark(flag);
  }
}
ClosureEnv_anon_4 ClosureEnv_anon_4_new(ClosureEnv_anon_4 env_, GlobalSchedulerValue this_) {
  env_.closureCall = ClosureEnv_anon_4_call;
  env_.this_ = this_;
  return env_;
}
bool ClosureEnv_anon_4_call(dynamic env__, _DelayedTaskValue t) {
  final env = env__ as ClosureEnv_anon_4;

  return (t.targetTick <= env.this_._currentTick);
}

class ClosureEnv_anon_5 extends TypeFunction1<bool, PromiseValue<dynamic>> {
  late StaticSet<PromiseValue<dynamic>> finished;
  ClosureEnv_anon_5();
  @override
  bool call(PromiseValue<dynamic> p) => closureCall(this, p);
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
    if (finished is AnyGC) (finished as AnyGC).gcMark(flag);
  }
}
ClosureEnv_anon_5 ClosureEnv_anon_5_new(ClosureEnv_anon_5 env_, StaticSet<PromiseValue<dynamic>> finished) {
  env_.closureCall = ClosureEnv_anon_5_call;
  env_.finished = finished;
  return env_;
}
bool ClosureEnv_anon_5_call(dynamic env__, PromiseValue<dynamic> p) {
  final env = env__ as ClosureEnv_anon_5;

  return env.finished.contains(p);
}

class ClosureEnv_anon_6 extends TypeFunction0<bool> {
  late dynamic _r;
  ClosureEnv_anon_6();
  @override
  bool call() => closureCall(this);
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
    if (_r is AnyGC) (_r as AnyGC).gcMark(flag);
  }
}
ClosureEnv_anon_6 ClosureEnv_anon_6_new(ClosureEnv_anon_6 env_, dynamic _r) {
  env_.closureCall = ClosureEnv_anon_6_call;
  env_._r = _r;
  return env_;
}
bool ClosureEnv_anon_6_call(dynamic env__) {
  final _r = (env__ as ClosureEnv_anon_6)._r;
  return (_r.vptr['step'] as bool Function(dynamic))(_r);
}
class ClosureEnv_anon_7 extends TypeFunction0<int> {
  late AddAsyncStateMachineValue this_;
  ClosureEnv_anon_7();
  @override
  int call() => closureCall(this);
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
    if (this_ is AnyGC) (this_ as AnyGC).gcMark(flag);
  }
}
ClosureEnv_anon_7 ClosureEnv_anon_7_new(ClosureEnv_anon_7 env_, AddAsyncStateMachineValue this_) {
  env_.closureCall = ClosureEnv_anon_7_call;
  env_.this_ = this_;
  return env_;
}
int ClosureEnv_anon_7_call(dynamic env__) {
  final env = env__ as ClosureEnv_anon_7;

  return env.this_.b;
}

class ClosureEnv_anon_8 extends TypeFunction0<String> {
  ClosureEnv_anon_8();
  @override
  String call() => closureCall(this);
}
ClosureEnv_anon_8 ClosureEnv_anon_8_new(ClosureEnv_anon_8 env_) {
  env_.closureCall = ClosureEnv_anon_8_call;
  return env_;
}
String ClosureEnv_anon_8_call(dynamic env__) {
  final env = env__ as ClosureEnv_anon_8;

  return 'inner';
}

class ClosureEnv_anon_9 extends TypeFunction0<Never> {
  ClosureEnv_anon_9();
  @override
  Never call() => closureCall(this);
}
ClosureEnv_anon_9 ClosureEnv_anon_9_new(ClosureEnv_anon_9 env_) {
  env_.closureCall = ClosureEnv_anon_9_call;
  return env_;
}
Never ClosureEnv_anon_9_call(dynamic env__) {
  final env = env__ as ClosureEnv_anon_9;

            throw Exception('something went wrong');
          }

class ClosureEnv_anon_10 extends TypeFunction0<int> {
  ClosureEnv_anon_10();
  @override
  int call() => closureCall(this);
}
ClosureEnv_anon_10 ClosureEnv_anon_10_new(ClosureEnv_anon_10 env_) {
  env_.closureCall = ClosureEnv_anon_10_call;
  return env_;
}
int ClosureEnv_anon_10_call(dynamic env__) {
  final env = env__ as ClosureEnv_anon_10;

  return 10;
}

class ClosureEnv_anon_11 extends TypeFunction0<int> {
  ClosureEnv_anon_11();
  @override
  int call() => closureCall(this);
}
ClosureEnv_anon_11 ClosureEnv_anon_11_new(ClosureEnv_anon_11 env_) {
  env_.closureCall = ClosureEnv_anon_11_call;
  return env_;
}
int ClosureEnv_anon_11_call(dynamic env__) {
  final env = env__ as ClosureEnv_anon_11;

  return 20;
}

class ClosureEnv_anon_12 extends TypeFunction0<int> {
  ClosureEnv_anon_12();
  @override
  int call() => closureCall(this);
}
ClosureEnv_anon_12 ClosureEnv_anon_12_new(ClosureEnv_anon_12 env_) {
  env_.closureCall = ClosureEnv_anon_12_call;
  return env_;
}
int ClosureEnv_anon_12_call(dynamic env__) {
  final env = env__ as ClosureEnv_anon_12;

  return 30;
}

class ClosureEnv_anon_13 extends TypeFunction1<bool, PromiseValue<int>> {
  ClosureEnv_anon_13();
  @override
  bool call(PromiseValue<int> f) => closureCall(this, f);
}
ClosureEnv_anon_13 ClosureEnv_anon_13_new(ClosureEnv_anon_13 env_) {
  env_.closureCall = ClosureEnv_anon_13_call;
  return env_;
}
bool ClosureEnv_anon_13_call(dynamic env__, PromiseValue<int> f) {
  final env = env__ as ClosureEnv_anon_13;

  return ((f.vptr['get_isCompleted'] as bool Function(dynamic))(f) || (f.vptr['get_isError'] as bool Function(dynamic))(f));
}

class ClosureEnv_anon_14 extends TypeFunction1<int, PromiseValue<int>> {
  ClosureEnv_anon_14();
  @override
  int call(PromiseValue<int> f) => closureCall(this, f);
}
ClosureEnv_anon_14 ClosureEnv_anon_14_new(ClosureEnv_anon_14 env_) {
  env_.closureCall = ClosureEnv_anon_14_call;
  return env_;
}
int ClosureEnv_anon_14_call(dynamic env__, PromiseValue<int> f) {
  final env = env__ as ClosureEnv_anon_14;

  return (f.vptr['get_result'] as int Function(dynamic))(f);
}

class ClosureEnv_anon_15 extends TypeFunction0<int> {
  late ComputeStepStateMachineValue this_;
  ClosureEnv_anon_15();
  @override
  int call() => closureCall(this);
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
    if (this_ is AnyGC) (this_ as AnyGC).gcMark(flag);
  }
}
ClosureEnv_anon_15 ClosureEnv_anon_15_new(ClosureEnv_anon_15 env_, ComputeStepStateMachineValue this_) {
  env_.closureCall = ClosureEnv_anon_15_call;
  env_.this_ = this_;
  return env_;
}
int ClosureEnv_anon_15_call(dynamic env__) {
  final env = env__ as ClosureEnv_anon_15;

  return (env.this_.input * 2);
}

class ClosureEnv_testDelayedFuture_16 extends TypeFunction0<String> {
  ClosureEnv_testDelayedFuture_16();
  @override
  String call() => closureCall(this);
}
ClosureEnv_testDelayedFuture_16 ClosureEnv_testDelayedFuture_16_new(ClosureEnv_testDelayedFuture_16 env_) {
  env_.closureCall = ClosureEnv_testDelayedFuture_16_call;
  return env_;
}
String ClosureEnv_testDelayedFuture_16_call(dynamic env__) {
  final env = env__ as ClosureEnv_testDelayedFuture_16;

  return 'hello after delay';
}

class ClosureEnv_testThenChain_17 extends TypeFunction1<int, int> {
  ClosureEnv_testThenChain_17();
  @override
  int call(int v) => closureCall(this, v);
}
ClosureEnv_testThenChain_17 ClosureEnv_testThenChain_17_new(ClosureEnv_testThenChain_17 env_) {
  env_.closureCall = ClosureEnv_testThenChain_17_call;
  return env_;
}
int ClosureEnv_testThenChain_17_call(dynamic env__, int v) {
  final env = env__ as ClosureEnv_testThenChain_17;

  return (v * 2);
}

class ClosureEnv_testThenChain_18 extends TypeFunction1<int, int> {
  ClosureEnv_testThenChain_18();
  @override
  int call(int v) => closureCall(this, v);
}
ClosureEnv_testThenChain_18 ClosureEnv_testThenChain_18_new(ClosureEnv_testThenChain_18 env_) {
  env_.closureCall = ClosureEnv_testThenChain_18_call;
  return env_;
}
int ClosureEnv_testThenChain_18_call(dynamic env__, int v) {
  final env = env__ as ClosureEnv_testThenChain_18;

  return (v * 2);
}

class ClosureEnv_testThenChain_19 extends TypeFunction1<String, int> {
  ClosureEnv_testThenChain_19();
  @override
  String call(int v) => closureCall(this, v);
}
ClosureEnv_testThenChain_19 ClosureEnv_testThenChain_19_new(ClosureEnv_testThenChain_19 env_) {
  env_.closureCall = ClosureEnv_testThenChain_19_call;
  return env_;
}
String ClosureEnv_testThenChain_19_call(dynamic env__, int v) {
  final env = env__ as ClosureEnv_testThenChain_19;

  return 'value=${v}';
}

class ClosureEnv_testThenChain_20 extends TypeFunction1<String, int> {
  ClosureEnv_testThenChain_20();
  @override
  String call(int v) => closureCall(this, v);
}
ClosureEnv_testThenChain_20 ClosureEnv_testThenChain_20_new(ClosureEnv_testThenChain_20 env_) {
  env_.closureCall = ClosureEnv_testThenChain_20_call;
  return env_;
}
String ClosureEnv_testThenChain_20_call(dynamic env__, int v) {
  final env = env__ as ClosureEnv_testThenChain_20;

  return 'value=${v}';
}

class ClosureEnv_testTickCounting_21 extends TypeFunction0<int> {
  ClosureEnv_testTickCounting_21();
  @override
  int call() => closureCall(this);
}
ClosureEnv_testTickCounting_21 ClosureEnv_testTickCounting_21_new(ClosureEnv_testTickCounting_21 env_) {
  env_.closureCall = ClosureEnv_testTickCounting_21_call;
  return env_;
}
int ClosureEnv_testTickCounting_21_call(dynamic env__) {
  final env = env__ as ClosureEnv_testTickCounting_21;

  return 99;
}

