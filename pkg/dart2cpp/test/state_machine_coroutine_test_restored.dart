import 'package:dart2cpp/restorer/runtime_classes.dart';

enum CompleterState {
  pending,
  completed,
  error;
}

class PromiseValue<T> extends VPtr {
  late CompleterState _state;
  late T? _result;
  late Object? _error;
  PromiseValue() {
    vptr['get_state'] = Promise_get_state<T>;
    vptr['get_isCompleted'] = Promise_get_isCompleted<T>;
    vptr['get_isError'] = Promise_get_isError<T>;
    vptr['get_isPending'] = Promise_get_isPending<T>;
    vptr['get_error'] = Promise_get_error<T>;
    vptr['get_result'] = Promise_get_result<T>;
    vptr['complete'] = Promise_complete<T>;
    vptr['completeError'] = Promise_completeError<T>;
    vptr['then_String'] = Promise_then<T, String>;
    vptr['then_int'] = Promise_then<T, int>;
  }
}

PromiseValue<T> Promise_new<T>(dynamic this__) {
  final this_ = this__ as PromiseValue<T>;
  this_._state = CompleterState.pending;
  this_._result = null;
  this_._error = null;
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
    throw StateError('Promise not yet completed');
  }
  return (this_._result as T);
}

void Promise_complete<T>(dynamic this__, T value) {
  final this_ = this__ as PromiseValue<T>;
  if (!((this_._state == CompleterState.pending))) {
    throw StateError('Promise already resolved');
  }
  this_._result = value;
  this_._state = CompleterState.completed;
}

void Promise_completeError<T>(dynamic this__, Object error) {
  final this_ = this__ as PromiseValue<T>;
  if (!((this_._state == CompleterState.pending))) {
    throw StateError('Promise already resolved');
  }
  this_._error = error;
  this_._state = CompleterState.error;
}

PromiseValue<T> Promise_value<T>(T val) {
  final PromiseValue<T> promise = Promise_new<T>(PromiseValue<T>());
  (promise.vptr['complete'] as void Function(dynamic, T))(promise, val);
  return promise;
}

PromiseValue<T> Promise_delayed<T>(int delayTicks, T Function() computation) {
  final PromiseValue<T> promise = Promise_new<T>(PromiseValue<T>());
  (GlobalScheduler_instance.vptr['registerDelayedTask'] as void Function(dynamic, int, void Function()))(GlobalScheduler_instance, delayTicks, ClosureEnv_anon_1(promise, computation).call);
  return promise;
}

PromiseValue<R> Promise_then<T, R>(dynamic this__, R Function(T) onValue) {
  final this_ = this__ as PromiseValue<T>;
  final PromiseValue<R> nextPromise = Promise_new<R>(PromiseValue<R>());
  (GlobalScheduler_instance.vptr['registerStateMachine'] as void Function(dynamic, IStateMachineValue))(GlobalScheduler_instance, _ThenStateMachine_new<T, R>(_ThenStateMachineValue<T, R>(), this_, onValue, nextPromise));
  return nextPromise;
}


class IStateMachineValue extends VPtr {
  late bool _checkedThisRound;
  IStateMachineValue() {
    vptr['get_debugName'] = IStateMachine_get_debugName;
    vptr['step'] = IStateMachine_step;
    vptr['resetRoundFlag'] = IStateMachine_resetRoundFlag;
    vptr['markChecked'] = IStateMachine_markChecked;
  }
}

IStateMachineValue IStateMachine_new(dynamic this__) {
  final this_ = this__ as IStateMachineValue;
  this_._checkedThisRound = false;
  return this_;
}

String IStateMachine_get_debugName(dynamic this__) {
  final this_ = this__ as IStateMachineValue;
  return this_.runtimeType.toString();
}

bool IStateMachine_step(dynamic this_) {
  throw UnimplementedError('IStateMachine.step is abstract');
}

void IStateMachine_resetRoundFlag(dynamic this__) {
  final this_ = this__ as IStateMachineValue;
  this_._checkedThisRound = false;
}

bool IStateMachine_markChecked(dynamic this__) {
  final this_ = this__ as IStateMachineValue;
  if (this_._checkedThisRound)   return false;
  this_._checkedThisRound = true;
  return true;
}


class _ThenStateMachineValue<T, R> extends IStateMachineValue {
  late PromiseValue<T> _source;
  late R Function(T) _onValue;
  late PromiseValue<R> _target;
  _ThenStateMachineValue() {
    vptr['get_debugName'] = _ThenStateMachine_get_debugName<T, R>;
    vptr['step'] = _ThenStateMachine_step<T, R>;
    vptr['resetRoundFlag'] = _ThenStateMachine_resetRoundFlag<T, R>;
    vptr['markChecked'] = _ThenStateMachine_markChecked<T, R>;
  }
}

_ThenStateMachineValue<T, R> _ThenStateMachine_new<T, R>(dynamic this__, PromiseValue<T> _source, R Function(T) _onValue, PromiseValue<R> _target) {
  final this_ = this__ as _ThenStateMachineValue<T, R>;
  IStateMachine_new(this_);
  this_._source = _source;
  this_._onValue = _onValue;
  this_._target = _target;
  this_._checkedThisRound = false;
  return this_;
}

String _ThenStateMachine_get_debugName<T, R>(dynamic this__) {
  final this_ = this__ as _ThenStateMachineValue<T, R>;
  return '_ThenSM<${T}→${R}>';
}

bool _ThenStateMachine_step<T, R>(dynamic this__) {
  final this_ = this__ as _ThenStateMachineValue<T, R>;
  if ((this_._source.vptr['get_isCompleted'] as bool Function(dynamic))(this_._source)) {
    try {
      final R result = (() { final _let0 = (this_._source.vptr['get_result'] as T Function(dynamic))(this_._source); return this_._onValue(_let0); })();
      (this_._target.vptr['complete'] as void Function(dynamic, R))(this_._target, result);
    }
 catch (e) {
      (this_._target.vptr['completeError'] as void Function(dynamic, Object))(this_._target, e);
    }
    return true;
  }
  if ((this_._source.vptr['get_isError'] as bool Function(dynamic))(this_._source)) {
    (this_._target.vptr['completeError'] as void Function(dynamic, Object))(this_._target, (this_._source.vptr['get_error'] as Object? Function(dynamic))(this_._source)!);
    return true;
  }
  return false;
}

void _ThenStateMachine_resetRoundFlag<T, R>(dynamic this__) {
  final this_ = this__ as _ThenStateMachineValue<T, R>;
  IStateMachine_resetRoundFlag(this_);
}

bool _ThenStateMachine_markChecked<T, R>(dynamic this__) {
  final this_ = this__ as _ThenStateMachineValue<T, R>;
  return IStateMachine_markChecked(this_);
}


class GlobalSchedulerValue extends VPtr {
  late List<IStateMachineValue> smStateMachines;
  late List<_DelayedTaskValue> _delayedTasks;
  late int _currentTick;
  GlobalSchedulerValue() {
    vptr['registerStateMachine'] = GlobalScheduler_registerStateMachine;
    vptr['registerDelayedTask'] = GlobalScheduler_registerDelayedTask;
    vptr['tick'] = GlobalScheduler_tick;
    vptr['get_hasActiveTasks'] = GlobalScheduler_get_hasActiveTasks;
    vptr['reset'] = GlobalScheduler_reset;
  }
}

final GlobalSchedulerValue GlobalScheduler_instance = GlobalScheduler_new__(GlobalSchedulerValue());
GlobalSchedulerValue GlobalScheduler_new__(dynamic this__) {
  final this_ = this__ as GlobalSchedulerValue;
  this_.smStateMachines = <IStateMachineValue>[];
  this_._delayedTasks = <_DelayedTaskValue>[];
  this_._currentTick = 0;
  return this_;
}

void GlobalScheduler_registerStateMachine(dynamic this__, IStateMachineValue sm) {
  final this_ = this__ as GlobalSchedulerValue;
  log('registerSM: ${(sm.vptr['get_debugName'] as String Function(dynamic))(sm)}');
  this_.smStateMachines.add(sm);
}

void GlobalScheduler_registerDelayedTask(dynamic this__, int delayTicks, void Function() callback) {
  final this_ = this__ as GlobalSchedulerValue;
  final int target = (this_._currentTick + delayTicks);
  log('registerDelayed: trigger@tick=${target} (delay=${delayTicks})');
  this_._delayedTasks.add(_DelayedTask_new(_DelayedTaskValue(), target, callback));
}

void GlobalScheduler_tick(dynamic this__) {
  final this_ = this__ as GlobalSchedulerValue;
  this_._currentTick = (this_._currentTick + 1);
  log('--- tick #${this_._currentTick} start (SMs=${this_.smStateMachines.length}, delayed=${this_._delayedTasks.length}) ---');
  for (final sm in this_.smStateMachines) {
    (sm.vptr['resetRoundFlag'] as void Function(dynamic))(sm);
  }
  final List<_DelayedTaskValue> expired = this_._delayedTasks.where(ClosureEnv_anon_2(this_).call).toList();
  this_._delayedTasks.removeWhere(ClosureEnv_anon_3(this_).call);
  for (final task in expired) {
    log('  delayed task triggered @tick=${this_._currentTick}');
    task.callback();
  }
  final List<IStateMachineValue> snapshot = List.of(this_.smStateMachines);
  final Set<IStateMachineValue> finished = <IStateMachineValue>{};
  for (final sm in snapshot)   do {
{
      if (!((sm.vptr['markChecked'] as bool Function(dynamic))(sm))) {
        log('  skip ${(sm.vptr['get_debugName'] as String Function(dynamic))(sm)} (already checked this round)');
        break;
      }
      log('  step ${(sm.vptr['get_debugName'] as String Function(dynamic))(sm)}...');
      if ((sm.vptr['step'] as bool Function(dynamic))(sm)) {
        log('  → ${(sm.vptr['get_debugName'] as String Function(dynamic))(sm)} FINISHED');
        finished.add(sm);
      }
 else {
        log('  → ${(sm.vptr['get_debugName'] as String Function(dynamic))(sm)} still pending');
      }
    }
  } while (false);
  this_.smStateMachines.removeWhere(ClosureEnv_anon_4(finished).call);
  log('--- tick #${this_._currentTick} end (remaining SMs=${this_.smStateMachines.length}) ---');
}

bool GlobalScheduler_get_hasActiveTasks(dynamic this__) {
  final this_ = this__ as GlobalSchedulerValue;
  return (this_.smStateMachines.isNotEmpty || this_._delayedTasks.isNotEmpty);
}

void GlobalScheduler_reset(dynamic this__) {
  final this_ = this__ as GlobalSchedulerValue;
  this_.smStateMachines.clear();
  this_._delayedTasks.clear();
  this_._currentTick = 0;
}


class _DelayedTaskValue extends VPtr {
  late int targetTick;
  late void Function() callback;
}

_DelayedTaskValue _DelayedTask_new(dynamic this__, int targetTick, void Function() callback) {
  final this_ = this__ as _DelayedTaskValue;
  this_.targetTick = targetTick;
  this_.callback = callback;
  return this_;
}


class AsyncStateMachineValue<T> extends IStateMachineValue {
  late int smState;
  late PromiseValue<T> promise;
  AsyncStateMachineValue() {
    vptr['get_debugName'] = AsyncStateMachine_get_debugName<T>;
    vptr['step'] = AsyncStateMachine_step<T>;
    vptr['resetRoundFlag'] = AsyncStateMachine_resetRoundFlag<T>;
    vptr['markChecked'] = AsyncStateMachine_markChecked<T>;
    vptr['completeWith'] = AsyncStateMachine_completeWith<T>;
    vptr['completeWithError'] = AsyncStateMachine_completeWithError<T>;
    vptr['start'] = AsyncStateMachine_start<T>;
  }
}

AsyncStateMachineValue<T> AsyncStateMachine_new<T>(dynamic this__) {
  final this_ = this__ as AsyncStateMachineValue<T>;
  IStateMachine_new(this_);
  this_._checkedThisRound = false;
  this_.smState = 0;
  this_.promise = Promise_new<T>(PromiseValue<T>());
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
  (GlobalScheduler_instance.vptr['registerStateMachine'] as void Function(dynamic, IStateMachineValue))(GlobalScheduler_instance, this_);
  return this_.promise;
}

String AsyncStateMachine_get_debugName<T>(dynamic this__) {
  final this_ = this__ as AsyncStateMachineValue<T>;
  return IStateMachine_get_debugName(this_);
}

void AsyncStateMachine_resetRoundFlag<T>(dynamic this__) {
  final this_ = this__ as AsyncStateMachineValue<T>;
  IStateMachine_resetRoundFlag(this_);
}

bool AsyncStateMachine_markChecked<T>(dynamic this__) {
  final this_ = this__ as AsyncStateMachineValue<T>;
  return IStateMachine_markChecked(this_);
}


class AddAsyncStateMachineValue extends AsyncStateMachineValue<int> {
  late int a;
  late int b;
  late int _x;
  late int _y;
  late PromiseValue<int>? _pendingFuture;
  AddAsyncStateMachineValue() {
    vptr['get_debugName'] = AddAsyncStateMachine_get_debugName;
    vptr['step'] = AddAsyncStateMachine_step;
    vptr['resetRoundFlag'] = AddAsyncStateMachine_resetRoundFlag;
    vptr['markChecked'] = AddAsyncStateMachine_markChecked;
    vptr['completeWith'] = AddAsyncStateMachine_completeWith;
    vptr['completeWithError'] = AddAsyncStateMachine_completeWithError;
    vptr['start'] = AddAsyncStateMachine_start;
  }
}

AddAsyncStateMachineValue AddAsyncStateMachine_new(dynamic this__, int a, int b) {
  final this_ = this__ as AddAsyncStateMachineValue;
  AsyncStateMachine_new<int>(this_);
  this_.a = a;
  this_.b = b;
  this_._checkedThisRound = false;
  this_.smState = 0;
  this_.promise = Promise_new<int>(PromiseValue<int>());
  this_._x = 0;
  this_._y = 0;
  this_._pendingFuture = null;
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
          if ((this_._pendingFuture!.vptr['get_isPending'] as bool Function(dynamic))(this_._pendingFuture!))           return false;
          this_._x = (this_._pendingFuture!.vptr['get_result'] as int Function(dynamic))(this_._pendingFuture!);
          this_._pendingFuture = Promise_delayed<int>(2, ClosureEnv_anon_5(this_).call);
          this_.smState = 2;
          log('  ${(this_.vptr['get_debugName'] as String Function(dynamic))(this_)}: state 1→2, got x=${this_._x}, created delayed future for ${this_.b}');
          return false;
        }
      case 2:
{
          if ((this_._pendingFuture!.vptr['get_isPending'] as bool Function(dynamic))(this_._pendingFuture!))           return false;
          this_._y = (this_._pendingFuture!.vptr['get_result'] as int Function(dynamic))(this_._pendingFuture!);
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

void AddAsyncStateMachine_resetRoundFlag(dynamic this__) {
  final this_ = this__ as AddAsyncStateMachineValue;
  IStateMachine_resetRoundFlag(this_);
}

bool AddAsyncStateMachine_markChecked(dynamic this__) {
  final this_ = this__ as AddAsyncStateMachineValue;
  return IStateMachine_markChecked(this_);
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
  late PromiseValue<String>? _pendingFuture;
  InnerAsyncStateMachineValue() {
    vptr['get_debugName'] = InnerAsyncStateMachine_get_debugName;
    vptr['step'] = InnerAsyncStateMachine_step;
    vptr['resetRoundFlag'] = InnerAsyncStateMachine_resetRoundFlag;
    vptr['markChecked'] = InnerAsyncStateMachine_markChecked;
    vptr['completeWith'] = InnerAsyncStateMachine_completeWith;
    vptr['completeWithError'] = InnerAsyncStateMachine_completeWithError;
    vptr['start'] = InnerAsyncStateMachine_start;
  }
}

InnerAsyncStateMachineValue InnerAsyncStateMachine_new(dynamic this__) {
  final this_ = this__ as InnerAsyncStateMachineValue;
  AsyncStateMachine_new<String>(this_);
  this_._checkedThisRound = false;
  this_.smState = 0;
  this_.promise = Promise_new<String>(PromiseValue<String>());
  this_._pendingFuture = null;
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
          this_._pendingFuture = Promise_delayed<String>(2, () => 'inner');
          this_.smState = 1;
          log('  ${(this_.vptr['get_debugName'] as String Function(dynamic))(this_)}: state 0→1, created delayed future');
          return false;
        }
      case 1:
{
          if ((this_._pendingFuture!.vptr['get_isPending'] as bool Function(dynamic))(this_._pendingFuture!))           return false;
          final String val = (this_._pendingFuture!.vptr['get_result'] as String Function(dynamic))(this_._pendingFuture!);
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

void InnerAsyncStateMachine_resetRoundFlag(dynamic this__) {
  final this_ = this__ as InnerAsyncStateMachineValue;
  IStateMachine_resetRoundFlag(this_);
}

bool InnerAsyncStateMachine_markChecked(dynamic this__) {
  final this_ = this__ as InnerAsyncStateMachineValue;
  return IStateMachine_markChecked(this_);
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
  late String _prefix;
  late PromiseValue<String>? _pendingFuture;
  OuterAsyncStateMachineValue() {
    vptr['get_debugName'] = OuterAsyncStateMachine_get_debugName;
    vptr['step'] = OuterAsyncStateMachine_step;
    vptr['resetRoundFlag'] = OuterAsyncStateMachine_resetRoundFlag;
    vptr['markChecked'] = OuterAsyncStateMachine_markChecked;
    vptr['completeWith'] = OuterAsyncStateMachine_completeWith;
    vptr['completeWithError'] = OuterAsyncStateMachine_completeWithError;
    vptr['start'] = OuterAsyncStateMachine_start;
  }
}

OuterAsyncStateMachineValue OuterAsyncStateMachine_new(dynamic this__) {
  final this_ = this__ as OuterAsyncStateMachineValue;
  AsyncStateMachine_new<String>(this_);
  this_._checkedThisRound = false;
  this_.smState = 0;
  this_.promise = Promise_new<String>(PromiseValue<String>());
  this_._prefix = '';
  this_._pendingFuture = null;
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
          if ((this_._pendingFuture!.vptr['get_isPending'] as bool Function(dynamic))(this_._pendingFuture!))           return false;
          this_._prefix = (this_._pendingFuture!.vptr['get_result'] as String Function(dynamic))(this_._pendingFuture!);
          final InnerAsyncStateMachineValue innerSm = InnerAsyncStateMachine_new(InnerAsyncStateMachineValue());
          this_._pendingFuture = (innerSm.vptr['start'] as PromiseValue<String> Function(dynamic))(innerSm);
          this_.smState = 2;
          log('  ${(this_.vptr['get_debugName'] as String Function(dynamic))(this_)}: state 1→2, prefix=${this_._prefix}, started InnerAsync');
          return false;
        }
      case 2:
{
          if ((this_._pendingFuture!.vptr['get_isPending'] as bool Function(dynamic))(this_._pendingFuture!))           return false;
          final String innerResult = (this_._pendingFuture!.vptr['get_result'] as String Function(dynamic))(this_._pendingFuture!);
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

void OuterAsyncStateMachine_resetRoundFlag(dynamic this__) {
  final this_ = this__ as OuterAsyncStateMachineValue;
  IStateMachine_resetRoundFlag(this_);
}

bool OuterAsyncStateMachine_markChecked(dynamic this__) {
  final this_ = this__ as OuterAsyncStateMachineValue;
  return IStateMachine_markChecked(this_);
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
  late PromiseValue<int>? _pendingFuture;
  ErrorStateMachineValue() {
    vptr['get_debugName'] = ErrorStateMachine_get_debugName;
    vptr['step'] = ErrorStateMachine_step;
    vptr['resetRoundFlag'] = ErrorStateMachine_resetRoundFlag;
    vptr['markChecked'] = ErrorStateMachine_markChecked;
    vptr['completeWith'] = ErrorStateMachine_completeWith;
    vptr['completeWithError'] = ErrorStateMachine_completeWithError;
    vptr['start'] = ErrorStateMachine_start;
  }
}

ErrorStateMachineValue ErrorStateMachine_new(dynamic this__) {
  final this_ = this__ as ErrorStateMachineValue;
  AsyncStateMachine_new<String>(this_);
  this_._checkedThisRound = false;
  this_.smState = 0;
  this_.promise = Promise_new<String>(PromiseValue<String>());
  this_._pendingFuture = null;
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
          this_._pendingFuture = Promise_delayed<int>(1, () {
            throw Exception('something went wrong');
          }
);
          this_.smState = 1;
          log('  ${(this_.vptr['get_debugName'] as String Function(dynamic))(this_)}: state 0→1, created delayed future (will throw)');
          return false;
        }
      case 1:
{
          if ((this_._pendingFuture!.vptr['get_isPending'] as bool Function(dynamic))(this_._pendingFuture!))           return false;
          if ((this_._pendingFuture!.vptr['get_isError'] as bool Function(dynamic))(this_._pendingFuture!)) {
            log('  ${(this_.vptr['get_debugName'] as String Function(dynamic))(this_)}: state 1→done, caught error');
            (this_.vptr['completeWith'] as void Function(dynamic, String))(this_, 'caught: ${(this_._pendingFuture!.vptr['get_error'] as Object? Function(dynamic))(this_._pendingFuture!)}');
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

void ErrorStateMachine_resetRoundFlag(dynamic this__) {
  final this_ = this__ as ErrorStateMachineValue;
  IStateMachine_resetRoundFlag(this_);
}

bool ErrorStateMachine_markChecked(dynamic this__) {
  final this_ = this__ as ErrorStateMachineValue;
  return IStateMachine_markChecked(this_);
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


class ParallelAwaitStateMachineValue extends AsyncStateMachineValue<List<int>> {
  late List<PromiseValue<int>> _futures;
  ParallelAwaitStateMachineValue() {
    vptr['get_debugName'] = ParallelAwaitStateMachine_get_debugName;
    vptr['step'] = ParallelAwaitStateMachine_step;
    vptr['resetRoundFlag'] = ParallelAwaitStateMachine_resetRoundFlag;
    vptr['markChecked'] = ParallelAwaitStateMachine_markChecked;
    vptr['completeWith'] = ParallelAwaitStateMachine_completeWith;
    vptr['completeWithError'] = ParallelAwaitStateMachine_completeWithError;
    vptr['start'] = ParallelAwaitStateMachine_start;
  }
}

ParallelAwaitStateMachineValue ParallelAwaitStateMachine_new(dynamic this__) {
  final this_ = this__ as ParallelAwaitStateMachineValue;
  AsyncStateMachine_new<List<int>>(this_);
  this_._checkedThisRound = false;
  this_.smState = 0;
  this_.promise = Promise_new<List<int>>(PromiseValue<List<int>>());
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
          this_._futures = <PromiseValue<int>>[Promise_delayed<int>(3, () => 10), Promise_delayed<int>(2, () => 20), Promise_delayed<int>(1, () => 30)];
          this_.smState = 1;
          log('  ${(this_.vptr['get_debugName'] as String Function(dynamic))(this_)}: state 0→1, created 3 delayed futures');
          return false;
        }
      case 1:
{
          final bool allDone = this_._futures.every((PromiseValue<int> f) => ((f.vptr['get_isCompleted'] as bool Function(dynamic))(f) || (f.vptr['get_isError'] as bool Function(dynamic))(f)));
          if (!(allDone))           return false;
          final List<int> results = this_._futures.map((PromiseValue<int> f) => (f.vptr['get_result'] as int Function(dynamic))(f)).toList();
          log('  ${(this_.vptr['get_debugName'] as String Function(dynamic))(this_)}: state 1→done, all futures completed: ${results}');
          (this_.vptr['completeWith'] as void Function(dynamic, List<int>))(this_, results);
          return true;
        }
      default:
{
          return true;
        }
    }
  } while (false);
}

void ParallelAwaitStateMachine_resetRoundFlag(dynamic this__) {
  final this_ = this__ as ParallelAwaitStateMachineValue;
  IStateMachine_resetRoundFlag(this_);
}

bool ParallelAwaitStateMachine_markChecked(dynamic this__) {
  final this_ = this__ as ParallelAwaitStateMachineValue;
  return IStateMachine_markChecked(this_);
}

void ParallelAwaitStateMachine_completeWith(dynamic this__, List<int> value) {
  final this_ = this__ as ParallelAwaitStateMachineValue;
  AsyncStateMachine_completeWith<List<int>>(this_, value);
}

void ParallelAwaitStateMachine_completeWithError(dynamic this__, Object error) {
  final this_ = this__ as ParallelAwaitStateMachineValue;
  AsyncStateMachine_completeWithError<List<int>>(this_, error);
}

PromiseValue<List<int>> ParallelAwaitStateMachine_start(dynamic this__) {
  final this_ = this__ as ParallelAwaitStateMachineValue;
  return AsyncStateMachine_start<List<int>>(this_);
}


class ComputeStepStateMachineValue extends AsyncStateMachineValue<int> {
  late int input;
  late PromiseValue<int>? _pendingFuture;
  ComputeStepStateMachineValue() {
    vptr['get_debugName'] = ComputeStepStateMachine_get_debugName;
    vptr['step'] = ComputeStepStateMachine_step;
    vptr['resetRoundFlag'] = ComputeStepStateMachine_resetRoundFlag;
    vptr['markChecked'] = ComputeStepStateMachine_markChecked;
    vptr['completeWith'] = ComputeStepStateMachine_completeWith;
    vptr['completeWithError'] = ComputeStepStateMachine_completeWithError;
    vptr['start'] = ComputeStepStateMachine_start;
  }
}

ComputeStepStateMachineValue ComputeStepStateMachine_new(dynamic this__, int input) {
  final this_ = this__ as ComputeStepStateMachineValue;
  AsyncStateMachine_new<int>(this_);
  this_.input = input;
  this_._checkedThisRound = false;
  this_.smState = 0;
  this_.promise = Promise_new<int>(PromiseValue<int>());
  this_._pendingFuture = null;
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
          this_._pendingFuture = Promise_delayed<int>(1, ClosureEnv_anon_6(this_).call);
          this_.smState = 1;
          log('  ${(this_.vptr['get_debugName'] as String Function(dynamic))(this_)}: state 0→1');
          return false;
        }
      case 1:
{
          if ((this_._pendingFuture!.vptr['get_isPending'] as bool Function(dynamic))(this_._pendingFuture!))           return false;
          final int r = (this_._pendingFuture!.vptr['get_result'] as int Function(dynamic))(this_._pendingFuture!);
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

void ComputeStepStateMachine_resetRoundFlag(dynamic this__) {
  final this_ = this__ as ComputeStepStateMachineValue;
  IStateMachine_resetRoundFlag(this_);
}

bool ComputeStepStateMachine_markChecked(dynamic this__) {
  final this_ = this__ as ComputeStepStateMachineValue;
  return IStateMachine_markChecked(this_);
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
  late int _a;
  late int _b;
  late int _c;
  late PromiseValue<int>? _pendingFuture;
  PipelineStateMachineValue() {
    vptr['get_debugName'] = PipelineStateMachine_get_debugName;
    vptr['step'] = PipelineStateMachine_step;
    vptr['resetRoundFlag'] = PipelineStateMachine_resetRoundFlag;
    vptr['markChecked'] = PipelineStateMachine_markChecked;
    vptr['completeWith'] = PipelineStateMachine_completeWith;
    vptr['completeWithError'] = PipelineStateMachine_completeWithError;
    vptr['start'] = PipelineStateMachine_start;
  }
}

PipelineStateMachineValue PipelineStateMachine_new(dynamic this__) {
  final this_ = this__ as PipelineStateMachineValue;
  AsyncStateMachine_new<int>(this_);
  this_._checkedThisRound = false;
  this_.smState = 0;
  this_.promise = Promise_new<int>(PromiseValue<int>());
  this_._a = 0;
  this_._b = 0;
  this_._c = 0;
  this_._pendingFuture = null;
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
          this_._pendingFuture = (ComputeStepStateMachine_new(ComputeStepStateMachineValue(), 1).vptr['start'] as PromiseValue<int> Function(dynamic))(ComputeStepStateMachine_new(ComputeStepStateMachineValue(), 1));
          this_.smState = 1;
          log('  ${(this_.vptr['get_debugName'] as String Function(dynamic))(this_)}: state 0→1, started ComputeStep(1)');
          return false;
        }
      case 1:
{
          if ((this_._pendingFuture!.vptr['get_isPending'] as bool Function(dynamic))(this_._pendingFuture!))           return false;
          this_._a = (this_._pendingFuture!.vptr['get_result'] as int Function(dynamic))(this_._pendingFuture!);
          this_._pendingFuture = (ComputeStepStateMachine_new(ComputeStepStateMachineValue(), this_._a).vptr['start'] as PromiseValue<int> Function(dynamic))(ComputeStepStateMachine_new(ComputeStepStateMachineValue(), this_._a));
          this_.smState = 2;
          log('  ${(this_.vptr['get_debugName'] as String Function(dynamic))(this_)}: state 1→2, a=${this_._a}, started ComputeStep(${this_._a})');
          return false;
        }
      case 2:
{
          if ((this_._pendingFuture!.vptr['get_isPending'] as bool Function(dynamic))(this_._pendingFuture!))           return false;
          this_._b = (this_._pendingFuture!.vptr['get_result'] as int Function(dynamic))(this_._pendingFuture!);
          this_._pendingFuture = (ComputeStepStateMachine_new(ComputeStepStateMachineValue(), this_._b).vptr['start'] as PromiseValue<int> Function(dynamic))(ComputeStepStateMachine_new(ComputeStepStateMachineValue(), this_._b));
          this_.smState = 3;
          log('  ${(this_.vptr['get_debugName'] as String Function(dynamic))(this_)}: state 2→3, b=${this_._b}, started ComputeStep(${this_._b})');
          return false;
        }
      case 3:
{
          if ((this_._pendingFuture!.vptr['get_isPending'] as bool Function(dynamic))(this_._pendingFuture!))           return false;
          this_._c = (this_._pendingFuture!.vptr['get_result'] as int Function(dynamic))(this_._pendingFuture!);
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

void PipelineStateMachine_resetRoundFlag(dynamic this__) {
  final this_ = this__ as PipelineStateMachineValue;
  IStateMachine_resetRoundFlag(this_);
}

bool PipelineStateMachine_markChecked(dynamic this__) {
  final this_ = this__ as PipelineStateMachineValue;
  return IStateMachine_markChecked(this_);
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
  if (enableLog)   print('  [LOG] ${msg}');
}

T smAwait<T>(PromiseValue<T> future) {
  int roundCount = 0;
  log('smAwait: waiting for future (completed=${(future.vptr['get_isCompleted'] as bool Function(dynamic))(future)})');
  while ((!((future.vptr['get_isCompleted'] as bool Function(dynamic))(future)) && !((future.vptr['get_isError'] as bool Function(dynamic))(future)))) {
    (GlobalScheduler_instance.vptr['tick'] as void Function(dynamic))(GlobalScheduler_instance);
    roundCount = (roundCount + 1);
    if ((roundCount > 100000)) {
      throw StateError('smAwait exceeded 100000 rounds — possible deadlock');
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
  print('\n--- Demo 1: 基础 await (Promise.value) ---');
  (GlobalScheduler_instance.vptr['reset'] as void Function(dynamic))(GlobalScheduler_instance);
  final PromiseValue<int> future = Promise_value<int>(42);
  final int result = smAwait<int>(future);
  assert((result == 42), 'Expected 42, got ${result}');
  print('  ✓ smAwait(Promise.value(42)) = ${result}');
}

void testDelayedFuture() {
  print('\n--- Demo 2: 延迟 Future ---');
  (GlobalScheduler_instance.vptr['reset'] as void Function(dynamic))(GlobalScheduler_instance);
  final PromiseValue<String> future = Promise_delayed<String>(3, () => 'hello after delay');
  final String result = smAwait<String>(future);
  assert((result == 'hello after delay'), 'Unexpected result: ${result}');
  print('  ✓ smAwait(delayed(3 ticks)) = "${result}"');
}

void testMultipleAwaitSerial() {
  print('\n--- Demo 3: 多 await 串行 (addAsync(10, 20)) ---');
  (GlobalScheduler_instance.vptr['reset'] as void Function(dynamic))(GlobalScheduler_instance);
  final AddAsyncStateMachineValue sm = AddAsyncStateMachine_new(AddAsyncStateMachineValue(), 10, 20);
  final PromiseValue<int> future = (sm.vptr['start'] as PromiseValue<int> Function(dynamic))(sm);
  final int result = smAwait<int>(future);
  assert((result == 30), 'Expected 30, got ${result}');
  print('  ✓ addAsync(10, 20) = ${result}');
}

void testNestedAsync() {
  print('\n--- Demo 4: 嵌套异步调用 ---');
  (GlobalScheduler_instance.vptr['reset'] as void Function(dynamic))(GlobalScheduler_instance);
  final OuterAsyncStateMachineValue sm = OuterAsyncStateMachine_new(OuterAsyncStateMachineValue());
  final PromiseValue<String> future = (sm.vptr['start'] as PromiseValue<String> Function(dynamic))(sm);
  final String result = smAwait<String>(future);
  assert((result == 'result: INNER'), 'Expected "result: INNER", got "${result}"');
  print('  ✓ outerAsync() = "${result}"');
}

void testThenChain() {
  print('\n--- Demo 5: then 链式调用 ---');
  (GlobalScheduler_instance.vptr['reset'] as void Function(dynamic))(GlobalScheduler_instance);
  final PromiseValue<String> future = ((Promise_value<int>(5).vptr['then_int'] as PromiseValue<int> Function(dynamic, int Function(int)))(Promise_value<int>(5), (int v) => (v * 2)).vptr['then_String'] as PromiseValue<String> Function(dynamic, String Function(int)))((Promise_value<int>(5).vptr['then_int'] as PromiseValue<int> Function(dynamic, int Function(int)))(Promise_value<int>(5), (int v) => (v * 2)), (int v) => 'value=${v}');
  final String result = smAwait<String>(future);
  assert((result == 'value=10'), 'Expected "value=10", got "${result}"');
  print('  ✓ Promise.value(5).then(*2).then(format) = "${result}"');
}

void testErrorHandling() {
  print('\n--- Demo 6: 异常处理 ---');
  (GlobalScheduler_instance.vptr['reset'] as void Function(dynamic))(GlobalScheduler_instance);
  final ErrorStateMachineValue sm = ErrorStateMachine_new(ErrorStateMachineValue());
  final PromiseValue<String> future = (sm.vptr['start'] as PromiseValue<String> Function(dynamic))(sm);
  final String result = smAwait<String>(future);
  assert(result.contains('something went wrong'), 'Error not caught: ${result}');
  print('  ✓ error caught and recovered: "${result}"');
}

void testParallelAwait() {
  print('\n--- Demo 7: 并行 await (Future.wait 模拟) ---');
  (GlobalScheduler_instance.vptr['reset'] as void Function(dynamic))(GlobalScheduler_instance);
  final ParallelAwaitStateMachineValue sm = ParallelAwaitStateMachine_new(ParallelAwaitStateMachineValue());
  final PromiseValue<List<int>> future = (sm.vptr['start'] as PromiseValue<List<int>> Function(dynamic))(sm);
  final List<int> result = smAwait<List<int>>(future);
  assert((result.length == 3), 'Expected 3 results');
  assert((((result[0] == 10) && (result[1] == 20)) && (result[2] == 30)), 'Unexpected results: ${result}');
  print('  ✓ parallel([d3→10, d2→20, d1→30]) = ${result}');
}

void testPipeline() {
  print('\n--- Demo 8: 多层嵌套管道 pipeline ---');
  (GlobalScheduler_instance.vptr['reset'] as void Function(dynamic))(GlobalScheduler_instance);
  final PipelineStateMachineValue sm = PipelineStateMachine_new(PipelineStateMachineValue());
  final PromiseValue<int> future = (sm.vptr['start'] as PromiseValue<int> Function(dynamic))(sm);
  final int result = smAwait<int>(future);
  assert((result == 14), 'Expected 14, got ${result}');
  print('  ✓ pipeline(1→2→4→8, sum=14) = ${result}');
}

void testTickCounting() {
  print('\n--- Demo 9: tick 计数验证 ---');
  (GlobalScheduler_instance.vptr['reset'] as void Function(dynamic))(GlobalScheduler_instance);
  final PromiseValue<int> future = Promise_delayed<int>(5, () => 99);
  int ticksBefore = GlobalScheduler_instance._currentTick;
  final int result = smAwait<int>(future);
  int ticksAfter = GlobalScheduler_instance._currentTick;
  int ticksUsed = (ticksAfter - ticksBefore);
  assert((result == 99), 'Expected 99');
  assert((ticksUsed >= 5), 'Should use at least 5 ticks, used ${ticksUsed}');
  print('  ✓ delayed(5 ticks) completed in ${ticksUsed} ticks, result=${result}');
}

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

bool enableLog = true;
class ClosureEnv_anon_0<T> {
  PromiseValue<T> promise;
  T Function() computation;
  ClosureEnv_anon_0(this.promise, this.computation);
  void call() => ClosureEnv_anon_0_call<T>(this);
}
void ClosureEnv_anon_0_call<T>(ClosureEnv_anon_0<T> env) {
    try {
      (env.promise.vptr['complete'] as void Function(dynamic, T))(env.promise, env.computation());
    }
 catch (e) {
      (env.promise.vptr['completeError'] as void Function(dynamic, Object))(env.promise, e);
    }
  }

class ClosureEnv_anon_1<T> {
  PromiseValue<T> promise;
  T Function() computation;
  ClosureEnv_anon_1(this.promise, this.computation);
  void call() => ClosureEnv_anon_1_call<T>(this);
}
void ClosureEnv_anon_1_call<T>(ClosureEnv_anon_1<T> env) {
    try {
      (env.promise.vptr['complete'] as void Function(dynamic, T))(env.promise, env.computation());
    }
 catch (e) {
      (env.promise.vptr['completeError'] as void Function(dynamic, Object))(env.promise, e);
    }
  }

class ClosureEnv_anon_2 {
  GlobalSchedulerValue this_;
  ClosureEnv_anon_2(this.this_);
  bool call(_DelayedTaskValue t) => ClosureEnv_anon_2_call(this, t);
}
bool ClosureEnv_anon_2_call(ClosureEnv_anon_2 env, _DelayedTaskValue t) {
  return (t.targetTick <= env.this_._currentTick);
}

class ClosureEnv_anon_3 {
  GlobalSchedulerValue this_;
  ClosureEnv_anon_3(this.this_);
  bool call(_DelayedTaskValue t) => ClosureEnv_anon_3_call(this, t);
}
bool ClosureEnv_anon_3_call(ClosureEnv_anon_3 env, _DelayedTaskValue t) {
  return (t.targetTick <= env.this_._currentTick);
}

class ClosureEnv_anon_4 {
  Set<IStateMachineValue> finished;
  ClosureEnv_anon_4(this.finished);
  bool call(IStateMachineValue sm) => ClosureEnv_anon_4_call(this, sm);
}
bool ClosureEnv_anon_4_call(ClosureEnv_anon_4 env, IStateMachineValue sm) {
  return env.finished.contains(sm);
}

class ClosureEnv_anon_5 {
  AddAsyncStateMachineValue this_;
  ClosureEnv_anon_5(this.this_);
  int call() => ClosureEnv_anon_5_call(this);
}
int ClosureEnv_anon_5_call(ClosureEnv_anon_5 env) {
  return env.this_.b;
}

class ClosureEnv_anon_6 {
  ComputeStepStateMachineValue this_;
  ClosureEnv_anon_6(this.this_);
  int call() => ClosureEnv_anon_6_call(this);
}
int ClosureEnv_anon_6_call(ClosureEnv_anon_6 env) {
  return (env.this_.input * 2);
}

