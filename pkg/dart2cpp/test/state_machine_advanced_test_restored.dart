import 'package:dart2cpp/platform/dart/runtime_classes.dart';

class FibStateMachineClassInfo extends ClassInfo {
  bool Function(AnyGC)? step;
  FibStateMachineClassInfo() {
    step = FibStateMachine_step;
  }
}

class FibStateMachineValue extends AsyncStateMachine<int> {
  late int n;
  late int _a = 0;
  late Promise<int>? _pending = null;
  @override
  bool step() {
    return ((classInfo as FibStateMachineClassInfo).step as bool Function(AnyGC))(this);
  }
  @override
  ClassInfo get classInfo => ClassInfoRegistry.get<FibStateMachineClassInfo>(runtimeType, FibStateMachineClassInfo.new);
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
    if (_pending is AnyGC) (_pending as AnyGC).gcMark(flag);
  }
  @override
  String toString() {
    final fn = (classInfo as FibStateMachineClassInfo).toString_;
    if (fn != null) return fn!(this);
    return super.toString();
  }
  @override
  bool operator ==(Object other) {
    final fn = (classInfo as FibStateMachineClassInfo).operatorEq;
    if (fn != null) return fn!(this, other);
    return identical(this, other);
  }
  @override
  int get hashCode {
    final fn = (classInfo as FibStateMachineClassInfo).get_hashCode;
    if (fn != null) return fn!(this);
    return super.hashCode;
  }
}

FibStateMachineValue FibStateMachine_new(AnyGC this__, int n) {
  final this_ = this__ as FibStateMachineValue;
  this_.n = n;
  return this_;
}

bool FibStateMachine_step(AnyGC this__) {
  final this_ = this__ as FibStateMachineValue;
  _L0: do {
    switch (this_.smState) {
      case 0:
{
          if ((this_.n <= 1)) {
            this_.completeWith(this_.n);
            return true;
          }
          this_._pending = FibStateMachine_new(GC.allocateLocal(FibStateMachineValue()), (this_.n - 1)).start();
          this_.smState = 1;
          return false;
        }
      case 1:
{
          if (this_._pending!.isPending)           return false;
          this_._a = this_._pending!.result;
          this_._pending = FibStateMachine_new(GC.allocateLocal(FibStateMachineValue()), (this_.n - 2)).start();
          this_.smState = 2;
          return false;
        }
      case 2:
{
          if (this_._pending!.isPending)           return false;
          this_.completeWith((this_._a + this_._pending!.result));
          return true;
        }
      default:
{
          return true;
        }
    }
  } while (false);
}


class Level3SMClassInfo extends ClassInfo {
  bool Function(AnyGC)? step;
  Level3SMClassInfo() {
    step = Level3SM_step;
  }
}

class Level3SMValue extends AsyncStateMachine<int> {
  @override
  bool step() {
    return ((classInfo as Level3SMClassInfo).step as bool Function(AnyGC))(this);
  }
  @override
  ClassInfo get classInfo => ClassInfoRegistry.get<Level3SMClassInfo>(runtimeType, Level3SMClassInfo.new);
  @override
  String toString() {
    final fn = (classInfo as Level3SMClassInfo).toString_;
    if (fn != null) return fn!(this);
    return super.toString();
  }
  @override
  bool operator ==(Object other) {
    final fn = (classInfo as Level3SMClassInfo).operatorEq;
    if (fn != null) return fn!(this, other);
    return identical(this, other);
  }
  @override
  int get hashCode {
    final fn = (classInfo as Level3SMClassInfo).get_hashCode;
    if (fn != null) return fn!(this);
    return super.hashCode;
  }
}

Level3SMValue Level3SM_new(AnyGC this__) {
  final this_ = this__ as Level3SMValue;
  return this_;
}

bool Level3SM_step(AnyGC this__) {
  final this_ = this__ as Level3SMValue;
  this_.completeWithError(Exception(StringBox('deep error')));
  return true;
}


class Level2SMClassInfo extends ClassInfo {
  bool Function(AnyGC)? step;
  Level2SMClassInfo() {
    step = Level2SM_step;
  }
}

class Level2SMValue extends AsyncStateMachine<int> {
  late Promise<int>? _pending = null;
  @override
  bool step() {
    return ((classInfo as Level2SMClassInfo).step as bool Function(AnyGC))(this);
  }
  @override
  ClassInfo get classInfo => ClassInfoRegistry.get<Level2SMClassInfo>(runtimeType, Level2SMClassInfo.new);
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
    if (_pending is AnyGC) (_pending as AnyGC).gcMark(flag);
  }
  @override
  String toString() {
    final fn = (classInfo as Level2SMClassInfo).toString_;
    if (fn != null) return fn!(this);
    return super.toString();
  }
  @override
  bool operator ==(Object other) {
    final fn = (classInfo as Level2SMClassInfo).operatorEq;
    if (fn != null) return fn!(this, other);
    return identical(this, other);
  }
  @override
  int get hashCode {
    final fn = (classInfo as Level2SMClassInfo).get_hashCode;
    if (fn != null) return fn!(this);
    return super.hashCode;
  }
}

Level2SMValue Level2SM_new(AnyGC this__) {
  final this_ = this__ as Level2SMValue;
  return this_;
}

bool Level2SM_step(AnyGC this__) {
  final this_ = this__ as Level2SMValue;
  _L1: do {
    switch (this_.smState) {
      case 0:
{
          this_._pending = Level3SM_new(GC.allocateLocal(Level3SMValue())).start();
          this_.smState = 1;
          return false;
        }
      case 1:
{
          if (this_._pending!.isPending)           return false;
          if (this_._pending!.isError) {
            this_.completeWithError(this_._pending!.error!);
            return true;
          }
          this_.completeWith(this_._pending!.result);
          return true;
        }
      default:
{
          return true;
        }
    }
  } while (false);
}


class Level1SMClassInfo extends ClassInfo {
  bool Function(AnyGC)? step;
  Level1SMClassInfo() {
    step = Level1SM_step;
  }
}

class Level1SMValue extends AsyncStateMachine<String> {
  late Promise<int>? _pending = null;
  @override
  bool step() {
    return ((classInfo as Level1SMClassInfo).step as bool Function(AnyGC))(this);
  }
  @override
  ClassInfo get classInfo => ClassInfoRegistry.get<Level1SMClassInfo>(runtimeType, Level1SMClassInfo.new);
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
    if (_pending is AnyGC) (_pending as AnyGC).gcMark(flag);
  }
  @override
  String toString() {
    final fn = (classInfo as Level1SMClassInfo).toString_;
    if (fn != null) return fn!(this);
    return super.toString();
  }
  @override
  bool operator ==(Object other) {
    final fn = (classInfo as Level1SMClassInfo).operatorEq;
    if (fn != null) return fn!(this, other);
    return identical(this, other);
  }
  @override
  int get hashCode {
    final fn = (classInfo as Level1SMClassInfo).get_hashCode;
    if (fn != null) return fn!(this);
    return super.hashCode;
  }
}

Level1SMValue Level1SM_new(AnyGC this__) {
  final this_ = this__ as Level1SMValue;
  return this_;
}

bool Level1SM_step(AnyGC this__) {
  final this_ = this__ as Level1SMValue;
  _L2: do {
    switch (this_.smState) {
      case 0:
{
          this_._pending = Level2SM_new(GC.allocateLocal(Level2SMValue())).start();
          this_.smState = 1;
          return false;
        }
      case 1:
{
          if (this_._pending!.isPending)           return false;
          if (this_._pending!.isError) {
            this_.completeWith('caught: ${this_._pending!.error}');
            return true;
          }
          this_.completeWith('ok');
          return true;
        }
      default:
{
          return true;
        }
    }
  } while (false);
}


class ConditionalAwaitSMClassInfo extends ClassInfo {
  bool Function(AnyGC)? step;
  ConditionalAwaitSMClassInfo() {
    step = ConditionalAwaitSM_step;
  }
}

class ConditionalAwaitSMValue extends AsyncStateMachine<String> {
  late bool flag;
  late Promise<String>? _pending = null;
  @override
  bool step() {
    return ((classInfo as ConditionalAwaitSMClassInfo).step as bool Function(AnyGC))(this);
  }
  @override
  ClassInfo get classInfo => ClassInfoRegistry.get<ConditionalAwaitSMClassInfo>(runtimeType, ConditionalAwaitSMClassInfo.new);
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
    if (_pending is AnyGC) (_pending as AnyGC).gcMark(flag);
  }
  @override
  String toString() {
    final fn = (classInfo as ConditionalAwaitSMClassInfo).toString_;
    if (fn != null) return fn!(this);
    return super.toString();
  }
  @override
  bool operator ==(Object other) {
    final fn = (classInfo as ConditionalAwaitSMClassInfo).operatorEq;
    if (fn != null) return fn!(this, other);
    return identical(this, other);
  }
  @override
  int get hashCode {
    final fn = (classInfo as ConditionalAwaitSMClassInfo).get_hashCode;
    if (fn != null) return fn!(this);
    return super.hashCode;
  }
}

ConditionalAwaitSMValue ConditionalAwaitSM_new(AnyGC this__, bool flag) {
  final this_ = this__ as ConditionalAwaitSMValue;
  this_.flag = flag;
  return this_;
}

bool ConditionalAwaitSM_step(AnyGC this__) {
  final this_ = this__ as ConditionalAwaitSMValue;
  _L3: do {
    switch (this_.smState) {
      case 0:
{
          if (this_.flag) {
            this_._pending = Promise.delayed(2, ClosureEnv_anon_0_new(GC.allocateLocal(ClosureEnv_anon_0())));
            this_.smState = 1;
          }
 else {
            this_._pending = Promise.delayed(1, ClosureEnv_anon_1_new(GC.allocateLocal(ClosureEnv_anon_1())));
            this_.smState = 2;
          }
          return false;
        }
      case 1:
{
          if (this_._pending!.isPending)           return false;
          this_.completeWith(this_._pending!.result);
          return true;
        }
      case 2:
{
          if (this_._pending!.isPending)           return false;
          this_.completeWith(this_._pending!.result);
          return true;
        }
      default:
{
          return true;
        }
    }
  } while (false);
}


class FindFirstSMClassInfo extends ClassInfo {
  bool Function(AnyGC)? step;
  FindFirstSMClassInfo() {
    step = FindFirstSM_step;
  }
}

class FindFirstSMValue extends AsyncStateMachine<int> {
  late StaticList<int> items;
  late int _index = 0;
  late Promise<int>? _pending = null;
  @override
  bool step() {
    return ((classInfo as FindFirstSMClassInfo).step as bool Function(AnyGC))(this);
  }
  @override
  ClassInfo get classInfo => ClassInfoRegistry.get<FindFirstSMClassInfo>(runtimeType, FindFirstSMClassInfo.new);
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
    if (items is AnyGC) (items as AnyGC).gcMark(flag);
    if (_pending is AnyGC) (_pending as AnyGC).gcMark(flag);
  }
  @override
  String toString() {
    final fn = (classInfo as FindFirstSMClassInfo).toString_;
    if (fn != null) return fn!(this);
    return super.toString();
  }
  @override
  bool operator ==(Object other) {
    final fn = (classInfo as FindFirstSMClassInfo).operatorEq;
    if (fn != null) return fn!(this, other);
    return identical(this, other);
  }
  @override
  int get hashCode {
    final fn = (classInfo as FindFirstSMClassInfo).get_hashCode;
    if (fn != null) return fn!(this);
    return super.hashCode;
  }
}

FindFirstSMValue FindFirstSM_new(AnyGC this__, StaticList<int> items) {
  final this_ = this__ as FindFirstSMValue;
  this_.items = items;
  return this_;
}

bool FindFirstSM_step(AnyGC this__) {
  final this_ = this__ as FindFirstSMValue;
  _L4: do {
    switch (this_.smState) {
      case 0:
{
          if ((this_._index >= (this_.items.classInfo as StaticListClassInfo).get_length!(this_.items))) {
            this_.completeWith((-1));
            return true;
          }
          this_._pending = Promise.delayed(1, ClosureEnv_anon_2_new(GC.allocateLocal(ClosureEnv_anon_2()), this_));
          this_.smState = 1;
          return false;
        }
      case 1:
{
          if (this_._pending!.isPending)           return false;
          final int result = this_._pending!.result;
          if ((result > 10)) {
            this_.completeWith(result);
            return true;
          }
          this_._index = (this_._index + 1);
          this_.smState = 0;
          return false;
        }
      default:
{
          return true;
        }
    }
  } while (false);
}


class TryCatchSMClassInfo extends ClassInfo {
  bool Function(AnyGC)? step;
  TryCatchSMClassInfo() {
    step = TryCatchSM_step;
  }
}

class TryCatchSMValue extends AsyncStateMachine<String> {
  late String _log = '';
  late Promise<dynamic>? _pending = null;
  @override
  bool step() {
    return ((classInfo as TryCatchSMClassInfo).step as bool Function(AnyGC))(this);
  }
  @override
  ClassInfo get classInfo => ClassInfoRegistry.get<TryCatchSMClassInfo>(runtimeType, TryCatchSMClassInfo.new);
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
    if (_pending is AnyGC) (_pending as AnyGC).gcMark(flag);
  }
  @override
  String toString() {
    final fn = (classInfo as TryCatchSMClassInfo).toString_;
    if (fn != null) return fn!(this);
    return super.toString();
  }
  @override
  bool operator ==(Object other) {
    final fn = (classInfo as TryCatchSMClassInfo).operatorEq;
    if (fn != null) return fn!(this, other);
    return identical(this, other);
  }
  @override
  int get hashCode {
    final fn = (classInfo as TryCatchSMClassInfo).get_hashCode;
    if (fn != null) return fn!(this);
    return super.hashCode;
  }
}

TryCatchSMValue TryCatchSM_new(AnyGC this__) {
  final this_ = this__ as TryCatchSMValue;
  return this_;
}

bool TryCatchSM_step(AnyGC this__) {
  final this_ = this__ as TryCatchSMValue;
  _L5: do {
    switch (this_.smState) {
      case 0:
{
          this_._log = (this_._log + 'try;');
          this_._pending = Promise.delayed(1, ClosureEnv_anon_3_new(GC.allocateLocal(ClosureEnv_anon_3())));
          this_.smState = 1;
          return false;
        }
      case 1:
{
          if (this_._pending!.isPending)           return false;
          if (this_._pending!.isError) {
            this_._log = (this_._log + 'catch:${this_._pending!.error};');
            this_._pending = Promise.delayed(1, ClosureEnv_anon_4_new(GC.allocateLocal(ClosureEnv_anon_4())));
            this_.smState = 2;
            return false;
          }
          this_.completeWith(this_._log);
          return true;
        }
      case 2:
{
          if (this_._pending!.isPending)           return false;
          this_._log = (this_._log + (this_._pending!.result as String));
          this_.completeWith(this_._log);
          return true;
        }
      default:
{
          return true;
        }
    }
  } while (false);
}


class FutureAnySMClassInfo extends ClassInfo {
  bool Function(AnyGC)? step;
  FutureAnySMClassInfo() {
    step = FutureAnySM_step;
  }
}

class FutureAnySMValue extends AsyncStateMachine<String> {
  late StaticList<Promise<String>> _futures;
  @override
  bool step() {
    return ((classInfo as FutureAnySMClassInfo).step as bool Function(AnyGC))(this);
  }
  @override
  ClassInfo get classInfo => ClassInfoRegistry.get<FutureAnySMClassInfo>(runtimeType, FutureAnySMClassInfo.new);
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
    if (_futures is AnyGC) (_futures as AnyGC).gcMark(flag);
  }
  @override
  String toString() {
    final fn = (classInfo as FutureAnySMClassInfo).toString_;
    if (fn != null) return fn!(this);
    return super.toString();
  }
  @override
  bool operator ==(Object other) {
    final fn = (classInfo as FutureAnySMClassInfo).operatorEq;
    if (fn != null) return fn!(this, other);
    return identical(this, other);
  }
  @override
  int get hashCode {
    final fn = (classInfo as FutureAnySMClassInfo).get_hashCode;
    if (fn != null) return fn!(this);
    return super.hashCode;
  }
}

FutureAnySMValue FutureAnySM_new(AnyGC this__) {
  final this_ = this__ as FutureAnySMValue;
  return this_;
}

bool FutureAnySM_step(AnyGC this__) {
  final this_ = this__ as FutureAnySMValue;
  _L6: do {
    switch (this_.smState) {
      case 0:
{
          this_._futures = StaticList<Promise<String>>.of([Promise.delayed(5, ClosureEnv_anon_8_new(GC.allocateLocal(ClosureEnv_anon_8()))), Promise.delayed(2, ClosureEnv_anon_9_new(GC.allocateLocal(ClosureEnv_anon_9()))), Promise.delayed(8, ClosureEnv_anon_10_new(GC.allocateLocal(ClosureEnv_anon_10())))]);
          this_.smState = 1;
          return false;
        }
      case 1:
{
{
            var sync_for_iterator = (this_._futures.classInfo as StaticListClassInfo).get_iterator!(this_._futures);
            for (; sync_for_iterator.moveNext(); ) {
              final Promise<String> f = sync_for_iterator.current;
{
                if (f.isCompleted) {
                  this_.completeWith(f.result);
                  return true;
                }
              }
            }
          }
          return false;
        }
      default:
{
          return true;
        }
    }
  } while (false);
}


class TimeoutSMClassInfo extends ClassInfo {
  bool Function(AnyGC)? step;
  TimeoutSMClassInfo() {
    step = TimeoutSM_step;
  }
}

class TimeoutSMValue extends AsyncStateMachine<String> {
  late int taskDelay;
  late int timeoutDelay;
  late Promise<String> _taskFuture;
  late Promise<String> _timeoutFuture;
  @override
  bool step() {
    return ((classInfo as TimeoutSMClassInfo).step as bool Function(AnyGC))(this);
  }
  @override
  ClassInfo get classInfo => ClassInfoRegistry.get<TimeoutSMClassInfo>(runtimeType, TimeoutSMClassInfo.new);
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
    if (_taskFuture is AnyGC) (_taskFuture as AnyGC).gcMark(flag);
    if (_timeoutFuture is AnyGC) (_timeoutFuture as AnyGC).gcMark(flag);
  }
  @override
  String toString() {
    final fn = (classInfo as TimeoutSMClassInfo).toString_;
    if (fn != null) return fn!(this);
    return super.toString();
  }
  @override
  bool operator ==(Object other) {
    final fn = (classInfo as TimeoutSMClassInfo).operatorEq;
    if (fn != null) return fn!(this, other);
    return identical(this, other);
  }
  @override
  int get hashCode {
    final fn = (classInfo as TimeoutSMClassInfo).get_hashCode;
    if (fn != null) return fn!(this);
    return super.hashCode;
  }
}

TimeoutSMValue TimeoutSM_new(AnyGC this__, {required int taskDelay, required int timeoutDelay}) {
  final this_ = this__ as TimeoutSMValue;
  this_.taskDelay = taskDelay;
  this_.timeoutDelay = timeoutDelay;
  return this_;
}

bool TimeoutSM_step(AnyGC this__) {
  final this_ = this__ as TimeoutSMValue;
  _L7: do {
    switch (this_.smState) {
      case 0:
{
          this_._taskFuture = Promise.delayed(this_.taskDelay, ClosureEnv_anon_11_new(GC.allocateLocal(ClosureEnv_anon_11())));
          this_._timeoutFuture = Promise.delayed(this_.timeoutDelay, ClosureEnv_anon_12_new(GC.allocateLocal(ClosureEnv_anon_12())));
          this_.smState = 1;
          return false;
        }
      case 1:
{
          if (this_._taskFuture.isCompleted) {
            this_.completeWith(this_._taskFuture.result);
            return true;
          }
          if (this_._timeoutFuture.isCompleted) {
            this_.completeWith(this_._timeoutFuture.result);
            return true;
          }
          return false;
        }
      default:
{
          return true;
        }
    }
  } while (false);
}


class AsyncMapSMClassInfo extends ClassInfo {
  bool Function(AnyGC)? step;
  AsyncMapSMClassInfo() {
    step = AsyncMapSM_step;
  }
}

class AsyncMapSMValue extends AsyncStateMachine<StaticList<String>> {
  late StaticList<int> items;
  late StaticList<String> _results = StaticList<String>();
  late int _index = 0;
  late Promise<String>? _pending = null;
  @override
  bool step() {
    return ((classInfo as AsyncMapSMClassInfo).step as bool Function(AnyGC))(this);
  }
  @override
  ClassInfo get classInfo => ClassInfoRegistry.get<AsyncMapSMClassInfo>(runtimeType, AsyncMapSMClassInfo.new);
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
    if (items is AnyGC) (items as AnyGC).gcMark(flag);
    if (_results is AnyGC) (_results as AnyGC).gcMark(flag);
    if (_pending is AnyGC) (_pending as AnyGC).gcMark(flag);
  }
  @override
  String toString() {
    final fn = (classInfo as AsyncMapSMClassInfo).toString_;
    if (fn != null) return fn!(this);
    return super.toString();
  }
  @override
  bool operator ==(Object other) {
    final fn = (classInfo as AsyncMapSMClassInfo).operatorEq;
    if (fn != null) return fn!(this, other);
    return identical(this, other);
  }
  @override
  int get hashCode {
    final fn = (classInfo as AsyncMapSMClassInfo).get_hashCode;
    if (fn != null) return fn!(this);
    return super.hashCode;
  }
}

AsyncMapSMValue AsyncMapSM_new(AnyGC this__, StaticList<int> items) {
  final this_ = this__ as AsyncMapSMValue;
  this_.items = items;
  return this_;
}

bool AsyncMapSM_step(AnyGC this__) {
  final this_ = this__ as AsyncMapSMValue;
  _L8: do {
    switch (this_.smState) {
      case 0:
{
          if ((this_._index >= (this_.items.classInfo as StaticListClassInfo).get_length!(this_.items))) {
            this_.completeWith(this_._results);
            return true;
          }
          IntBox item = IntBox((this_.items.classInfo as StaticListClassInfo).operatorIndex!(this_.items, this_._index));
          this_._pending = Promise.delayed(1, ClosureEnv_anon_13_new(GC.allocateLocal(ClosureEnv_anon_13()), item));
          this_.smState = 1;
          return false;
        }
      case 1:
{
          if (this_._pending!.isPending)           return false;
          (this_._results.classInfo as StaticListClassInfo).add!(this_._results, this_._pending!.result);
          this_._index = (this_._index + 1);
          this_.smState = 0;
          return false;
        }
      default:
{
          return true;
        }
    }
  } while (false);
}


class AsyncReduceSMClassInfo extends ClassInfo {
  bool Function(AnyGC)? step;
  AsyncReduceSMClassInfo() {
    step = AsyncReduceSM_step;
  }
}

class AsyncReduceSMValue extends AsyncStateMachine<String> {
  late Promise<StaticList<String>> _mapFuture;
  late Promise<String>? _reducePending = null;
  late StaticList<String> _items = StaticList<String>();
  late int _index = 0;
  late String _acc = '';
  @override
  bool step() {
    return ((classInfo as AsyncReduceSMClassInfo).step as bool Function(AnyGC))(this);
  }
  @override
  ClassInfo get classInfo => ClassInfoRegistry.get<AsyncReduceSMClassInfo>(runtimeType, AsyncReduceSMClassInfo.new);
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
    if (_mapFuture is AnyGC) (_mapFuture as AnyGC).gcMark(flag);
    if (_reducePending is AnyGC) (_reducePending as AnyGC).gcMark(flag);
    if (_items is AnyGC) (_items as AnyGC).gcMark(flag);
  }
  @override
  String toString() {
    final fn = (classInfo as AsyncReduceSMClassInfo).toString_;
    if (fn != null) return fn!(this);
    return super.toString();
  }
  @override
  bool operator ==(Object other) {
    final fn = (classInfo as AsyncReduceSMClassInfo).operatorEq;
    if (fn != null) return fn!(this, other);
    return identical(this, other);
  }
  @override
  int get hashCode {
    final fn = (classInfo as AsyncReduceSMClassInfo).get_hashCode;
    if (fn != null) return fn!(this);
    return super.hashCode;
  }
}

AsyncReduceSMValue AsyncReduceSM_new(AnyGC this__) {
  final this_ = this__ as AsyncReduceSMValue;
  return this_;
}

bool AsyncReduceSM_step(AnyGC this__) {
  final this_ = this__ as AsyncReduceSMValue;
  _L9: do {
    switch (this_.smState) {
      case 0:
{
          this_._mapFuture = AsyncMapSM_new(GC.allocateLocal(AsyncMapSMValue()), StaticList<int>.of([1, 2, 3, 4])).start();
          this_.smState = 1;
          return false;
        }
      case 1:
{
          if (this_._mapFuture.isPending)           return false;
          this_._items = this_._mapFuture.result;
          this_.smState = 2;
          return false;
        }
      case 2:
{
          if ((this_._index >= (this_._items.classInfo as StaticListClassInfo).get_length!(this_._items))) {
            this_.completeWith(this_._acc);
            return true;
          }
          this_._reducePending = Promise.delayed(1, ClosureEnv_anon_14_new(GC.allocateLocal(ClosureEnv_anon_14()), this_));
          this_.smState = 3;
          return false;
        }
      case 3:
{
          if (this_._reducePending!.isPending)           return false;
          this_._acc = this_._reducePending!.result;
          this_._index = (this_._index + 1);
          this_.smState = 2;
          return false;
        }
      default:
{
          return true;
        }
    }
  } while (false);
}


class ClosureEnv_process_0ClassInfo extends ClassInfo {
  int Function(AnyGC, int)? call;
  ClosureEnv_process_0ClassInfo() {
    call = ClosureEnv_process_0_call;
  }
}

class ClosureEnv_process_0Value extends AnyGC {
  late int factor;
  @override
  ClassInfo get classInfo => ClassInfoRegistry.get<ClosureEnv_process_0ClassInfo>(runtimeType, ClosureEnv_process_0ClassInfo.new);
  @override
  String toString() {
    final fn = (classInfo as ClosureEnv_process_0ClassInfo).toString_;
    if (fn != null) return fn!(this);
    return super.toString();
  }
  @override
  bool operator ==(Object other) {
    final fn = (classInfo as ClosureEnv_process_0ClassInfo).operatorEq;
    if (fn != null) return fn!(this, other);
    return identical(this, other);
  }
  @override
  int get hashCode {
    final fn = (classInfo as ClosureEnv_process_0ClassInfo).get_hashCode;
    if (fn != null) return fn!(this);
    return super.hashCode;
  }
}

ClosureEnv_process_0Value ClosureEnv_process_0_new(AnyGC this__, int factor) {
  final this_ = this__ as ClosureEnv_process_0Value;
  this_.factor = factor;
  return this_;
}

int ClosureEnv_process_0_call(AnyGC this__, int x) {
  final this_ = this__ as ClosureEnv_process_0Value;
  return (x * this_.factor);
}


class ProcessWithClosureSMClassInfo extends ClassInfo {
  bool Function(AnyGC)? step;
  ProcessWithClosureSMClassInfo() {
    step = ProcessWithClosureSM_step;
  }
}

class ProcessWithClosureSMValue extends AsyncStateMachine<StaticList<int>> {
  late ClosureEnv_process_0Value _env;
  late StaticList<int> items;
  late StaticList<int> _results = StaticList<int>();
  late int _index = 0;
  late Promise<int>? _pending = null;
  @override
  bool step() {
    return ((classInfo as ProcessWithClosureSMClassInfo).step as bool Function(AnyGC))(this);
  }
  @override
  ClassInfo get classInfo => ClassInfoRegistry.get<ProcessWithClosureSMClassInfo>(runtimeType, ProcessWithClosureSMClassInfo.new);
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
    if (_env is AnyGC) (_env as AnyGC).gcMark(flag);
    if (items is AnyGC) (items as AnyGC).gcMark(flag);
    if (_results is AnyGC) (_results as AnyGC).gcMark(flag);
    if (_pending is AnyGC) (_pending as AnyGC).gcMark(flag);
  }
  @override
  String toString() {
    final fn = (classInfo as ProcessWithClosureSMClassInfo).toString_;
    if (fn != null) return fn!(this);
    return super.toString();
  }
  @override
  bool operator ==(Object other) {
    final fn = (classInfo as ProcessWithClosureSMClassInfo).operatorEq;
    if (fn != null) return fn!(this, other);
    return identical(this, other);
  }
  @override
  int get hashCode {
    final fn = (classInfo as ProcessWithClosureSMClassInfo).get_hashCode;
    if (fn != null) return fn!(this);
    return super.hashCode;
  }
}

ProcessWithClosureSMValue ProcessWithClosureSM_new(AnyGC this__, StaticList<int> items) {
  final this_ = this__ as ProcessWithClosureSMValue;
  this_.items = items;
  return this_;
}

bool ProcessWithClosureSM_step(AnyGC this__) {
  final this_ = this__ as ProcessWithClosureSMValue;
  _L10: do {
    switch (this_.smState) {
      case 0:
{
          this_._env = ClosureEnv_process_0_new(GC.allocateLocal(ClosureEnv_process_0Value()), 3);
          this_.smState = 1;
          return false;
        }
      case 1:
{
          if ((this_._index >= (this_.items.classInfo as StaticListClassInfo).get_length!(this_.items))) {
            this_.smState = 3;
            return false;
          }
          IntBox item = IntBox((this_.items.classInfo as StaticListClassInfo).operatorIndex!(this_.items, this_._index));
          this_._pending = Promise.delayed(1, ClosureEnv_anon_15_new(GC.allocateLocal(ClosureEnv_anon_15()), this_, item));
          this_.smState = 2;
          return false;
        }
      case 2:
{
          if (this_._pending!.isPending)           return false;
          (this_._results.classInfo as StaticListClassInfo).add!(this_._results, this_._pending!.result);
          this_._index = (this_._index + 1);
          this_.smState = 1;
          return false;
        }
      case 3:
{
          this_._env.factor = 5;
          (this_._results.classInfo as StaticListClassInfo).add!(this_._results, (this_._env.classInfo as ClosureEnv_process_0ClassInfo).call!(this_._env, 100));
          this_.completeWith(this_._results);
          return true;
        }
      default:
{
          return true;
        }
    }
  } while (false);
}


class AsyncGeneratorSMClassInfo extends ClassInfo {
  bool Function(AnyGC)? step;
  AsyncGeneratorSMClassInfo() {
    step = AsyncGeneratorSM_step;
  }
}

class AsyncGeneratorSMValue extends AsyncStateMachine<StaticList<int>> {
  late int max;
  late int _i = 0;
  late StaticList<int> _yielded = StaticList<int>();
  late Promise<int>? _pending = null;
  @override
  bool step() {
    return ((classInfo as AsyncGeneratorSMClassInfo).step as bool Function(AnyGC))(this);
  }
  @override
  ClassInfo get classInfo => ClassInfoRegistry.get<AsyncGeneratorSMClassInfo>(runtimeType, AsyncGeneratorSMClassInfo.new);
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
    if (_yielded is AnyGC) (_yielded as AnyGC).gcMark(flag);
    if (_pending is AnyGC) (_pending as AnyGC).gcMark(flag);
  }
  @override
  String toString() {
    final fn = (classInfo as AsyncGeneratorSMClassInfo).toString_;
    if (fn != null) return fn!(this);
    return super.toString();
  }
  @override
  bool operator ==(Object other) {
    final fn = (classInfo as AsyncGeneratorSMClassInfo).operatorEq;
    if (fn != null) return fn!(this, other);
    return identical(this, other);
  }
  @override
  int get hashCode {
    final fn = (classInfo as AsyncGeneratorSMClassInfo).get_hashCode;
    if (fn != null) return fn!(this);
    return super.hashCode;
  }
}

AsyncGeneratorSMValue AsyncGeneratorSM_new(AnyGC this__, int max) {
  final this_ = this__ as AsyncGeneratorSMValue;
  this_.max = max;
  return this_;
}

bool AsyncGeneratorSM_step(AnyGC this__) {
  final this_ = this__ as AsyncGeneratorSMValue;
  _L11: do {
    switch (this_.smState) {
      case 0:
{
          if ((this_._i >= this_.max)) {
            this_.completeWith(this_._yielded);
            return true;
          }
          this_._pending = Promise.delayed(1, ClosureEnv_anon_16_new(GC.allocateLocal(ClosureEnv_anon_16()), this_));
          this_.smState = 1;
          return false;
        }
      case 1:
{
          if (this_._pending!.isPending)           return false;
          (this_._yielded.classInfo as StaticListClassInfo).add!(this_._yielded, this_._pending!.result);
          this_._i = (this_._i + 1);
          this_.smState = 0;
          return false;
        }
      default:
{
          return true;
        }
    }
  } while (false);
}


class ComplexBusinessSMClassInfo extends ClassInfo {
  bool Function(AnyGC)? step;
  ComplexBusinessSMClassInfo() {
    step = ComplexBusinessSM_step;
  }
}

class ComplexBusinessSMValue extends AsyncStateMachine<StaticMap<String, dynamic>> {
  late int depth;
  late Promise<StaticMap<String, dynamic>>? _pending = null;
  @override
  bool step() {
    return ((classInfo as ComplexBusinessSMClassInfo).step as bool Function(AnyGC))(this);
  }
  @override
  ClassInfo get classInfo => ClassInfoRegistry.get<ComplexBusinessSMClassInfo>(runtimeType, ComplexBusinessSMClassInfo.new);
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
    if (_pending is AnyGC) (_pending as AnyGC).gcMark(flag);
  }
  @override
  String toString() {
    final fn = (classInfo as ComplexBusinessSMClassInfo).toString_;
    if (fn != null) return fn!(this);
    return super.toString();
  }
  @override
  bool operator ==(Object other) {
    final fn = (classInfo as ComplexBusinessSMClassInfo).operatorEq;
    if (fn != null) return fn!(this, other);
    return identical(this, other);
  }
  @override
  int get hashCode {
    final fn = (classInfo as ComplexBusinessSMClassInfo).get_hashCode;
    if (fn != null) return fn!(this);
    return super.hashCode;
  }
}

ComplexBusinessSMValue ComplexBusinessSM_new(AnyGC this__, int depth) {
  final this_ = this__ as ComplexBusinessSMValue;
  this_.depth = depth;
  return this_;
}

bool ComplexBusinessSM_step(AnyGC this__) {
  final this_ = this__ as ComplexBusinessSMValue;
  _L12: do {
    switch (this_.smState) {
      case 0:
{
          if ((this_.depth <= 0)) {
            this_.completeWithError(Exception(StringBox('max depth')));
            return true;
          }
          this_._pending = ComplexBusinessSM_new(GC.allocateLocal(ComplexBusinessSMValue()), (this_.depth - 1)).start();
          this_.smState = 1;
          return false;
        }
      case 1:
{
          if (this_._pending!.isPending)           return false;
          if (this_._pending!.isError) {
            this_.completeWith(StaticMap<String, dynamic>.of({'depth': this_.depth, 'error': '${this_._pending!.error}'}));
            return true;
          }
          this_.completeWith(StaticMap<String, dynamic>.of({'depth': this_.depth, 'child': this_._pending!.result}));
          return true;
        }
      default:
{
          return true;
        }
    }
  } while (false);
}


void testRecursiveAsync() {
  staticPrint('\n--- 1. 递归异步 fibonacci ---');
  GlobalScheduler.instance.reset();
  final dynamic r = smAwait<dynamic>(FibStateMachine_new(GC.allocateLocal(FibStateMachineValue()), 7).start());
  assert((r == 13), 'fib(7) should be 13, got ${r}');
  staticPrint('  ✓ asyncFib(7) = ${r}');
}

void testExceptionPropagation() {
  staticPrint('\n--- 2. 异常传播链 (3层) ---');
  GlobalScheduler.instance.reset();
  final String r = smAwait<String>(Level1SM_new(GC.allocateLocal(Level1SMValue())).start());
  assert(r.contains('deep error'), 'Expected deep error, got: ${r}');
  staticPrint('  ✓ level1() caught 3-level exception: "${r}"');
}

void testConditionalAwait() {
  staticPrint('\n--- 3. 条件分支中的 await ---');
  GlobalScheduler.instance.reset();
  final dynamic r1 = smAwait<dynamic>(ConditionalAwaitSM_new(GC.allocateLocal(ConditionalAwaitSMValue()), true).start());
  assert((r1 == 'branch_true'), 'Expected branch_true, got ${r1}');
  GlobalScheduler.instance.reset();
  final dynamic r2 = smAwait<dynamic>(ConditionalAwaitSM_new(GC.allocateLocal(ConditionalAwaitSMValue()), false).start());
  assert((r2 == 'branch_false'), 'Expected branch_false, got ${r2}');
  staticPrint('  ✓ conditionalAwait(true) = "${r1}"');
  staticPrint('  ✓ conditionalAwait(false) = "${r2}"');
}

void testLoopBreakAwait() {
  staticPrint('\n--- 4. 循环 + 提前 break 中的 await ---');
  GlobalScheduler.instance.reset();
  final dynamic r = smAwait<dynamic>(FindFirstSM_new(GC.allocateLocal(FindFirstSMValue()), StaticList<int>.of([1, 2, 3, 4, 5])).start());
  assert((r == 12), 'Expected 12, got ${r}');
  staticPrint('  ✓ findFirst([1,2,3,4,5]) = ${r} (4*3=12 > 10)');
}

void testTryCatchAwait() {
  staticPrint('\n--- 5. try-catch 中的 await ---');
  GlobalScheduler.instance.reset();
  final dynamic r = smAwait<dynamic>(TryCatchSM_new(GC.allocateLocal(TryCatchSMValue())).start());
  assert((r == 'try;catch:boom;recovered'), 'Unexpected: ${r}');
  staticPrint('  ✓ tryCatchAwait() = "${r}"');
}

void testFutureAny() {
  staticPrint('\n--- 6. Future.any 模拟（竞争取最先完成） ---');
  GlobalScheduler.instance.reset();
  final dynamic r = smAwait<dynamic>(FutureAnySM_new(GC.allocateLocal(FutureAnySMValue())).start());
  assert((r == 'fast'), 'Expected fast, got ${r}');
  staticPrint('  ✓ Future.any([slow(5), fast(2), slowest(8)]) = "${r}"');
}

void testTimeout() {
  staticPrint('\n--- 7. 超时控制模拟 ---');
  GlobalScheduler.instance.reset();
  final dynamic r1 = smAwait<dynamic>(TimeoutSM_new(GC.allocateLocal(TimeoutSMValue()), taskDelay: 2, timeoutDelay: 5).start());
  assert((r1 == 'done'), 'Expected done, got ${r1}');
  staticPrint('  ✓ task(2) timeout(5) = "${r1}" (task wins)');
  GlobalScheduler.instance.reset();
  final dynamic r2 = smAwait<dynamic>(TimeoutSM_new(GC.allocateLocal(TimeoutSMValue()), taskDelay: 10, timeoutDelay: 3).start());
  assert((r2 == 'TIMEOUT'), 'Expected TIMEOUT, got ${r2}');
  staticPrint('  ✓ task(10) timeout(3) = "${r2}" (timeout wins)');
}

void testAsyncPipeline() {
  staticPrint('\n--- 8. 链式异步变换管道 (map → reduce) ---');
  GlobalScheduler.instance.reset();
  final dynamic r = smAwait<dynamic>(AsyncReduceSM_new(GC.allocateLocal(AsyncReduceSMValue())).start());
  assert((r == 'item_2+item_4+item_6+item_8'), 'Unexpected: ${r}');
  staticPrint('  ✓ asyncMap([1,2,3,4]).reduce(+) = "${r}"');
}

void testClosureCaptureAwait() {
  staticPrint('\n--- 9. 闭包捕获 + await (ClosureEnv 模式) ---');
  GlobalScheduler.instance.reset();
  final StaticList<int> r = StaticList<int>.of(smAwait<StaticList<int>>(ProcessWithClosureSM_new(GC.allocateLocal(ProcessWithClosureSMValue()), StaticList<int>.of([1, 2, 3])).start()));
  assert(((r.classInfo as StaticListClassInfo).get_length!(r) == 4), 'Expected 4 results');
  assert((((((r.classInfo as StaticListClassInfo).operatorIndex!(r, 0) == 3) && ((r.classInfo as StaticListClassInfo).operatorIndex!(r, 1) == 6)) && ((r.classInfo as StaticListClassInfo).operatorIndex!(r, 2) == 9)) && ((r.classInfo as StaticListClassInfo).operatorIndex!(r, 3) == 500)), 'Unexpected: ${(r.classInfo as StaticListClassInfo).toString_!(r)}');
  staticPrint('  ✓ processWithClosure([1,2,3]) = ${(r.classInfo as StaticListClassInfo).toString_!(r)}');
  staticPrint('    (factor=3→[3,6,9], mutate factor=5→100*5=500)');
}

void testAsyncGenerator() {
  staticPrint('\n--- 10. async* 生成器模拟 ---');
  GlobalScheduler.instance.reset();
  final StaticList<int> r = StaticList<int>.of(smAwait<StaticList<int>>(AsyncGeneratorSM_new(GC.allocateLocal(AsyncGeneratorSMValue()), 5).start()));
  assert(((r.classInfo as StaticListClassInfo).get_length!(r) == 5), 'Expected 5 items');
  assert(((((((r.classInfo as StaticListClassInfo).operatorIndex!(r, 0) == 0) && ((r.classInfo as StaticListClassInfo).operatorIndex!(r, 1) == 1)) && ((r.classInfo as StaticListClassInfo).operatorIndex!(r, 2) == 4)) && ((r.classInfo as StaticListClassInfo).operatorIndex!(r, 3) == 9)) && ((r.classInfo as StaticListClassInfo).operatorIndex!(r, 4) == 16)), 'Unexpected: ${(r.classInfo as StaticListClassInfo).toString_!(r)}');
  staticPrint('  ✓ countUp(5) yields ${(r.classInfo as StaticListClassInfo).toString_!(r)}');
}

void testComplexBusiness() {
  staticPrint('\n--- 11. 复合场景：递归+异常+条件 ---');
  GlobalScheduler.instance.reset();
  final StaticMap<String, dynamic> r = StaticMap<String, dynamic>.of(smAwait<StaticMap<String, dynamic>>(ComplexBusinessSM_new(GC.allocateLocal(ComplexBusinessSMValue()), 3).start()));
  assert(((r.classInfo as StaticMapClassInfo).operatorIndex!(r, 'depth') == 3), 'Top level depth should be 3');
  final StaticMap<String, dynamic> child2 = StaticMap<String, dynamic>.of(((r.classInfo as StaticMapClassInfo).operatorIndex!(r, 'child') as StaticMap<String, dynamic>));
  assert(((child2.classInfo as StaticMapClassInfo).operatorIndex!(child2, 'depth') == 2), 'Child depth should be 2');
  final StaticMap<String, dynamic> child1 = StaticMap<String, dynamic>.of(((child2.classInfo as StaticMapClassInfo).operatorIndex!(child2, 'child') as StaticMap<String, dynamic>));
  assert(((child1.classInfo as StaticMapClassInfo).operatorIndex!(child1, 'depth') == 1), 'Deepest depth should be 1');
  assert(((child1.classInfo as StaticMapClassInfo).operatorIndex!(child1, 'error') as String).contains('max depth'), 'Should contain error');
  staticPrint('  ✓ complexBusiness(3) = nested map with error at bottom');
  staticPrint('    depth=3 → child(depth=2) → child(depth=1, error:"max depth")');
}

void main() {
  staticPrint('═══════════════════════════════════════════');
  staticPrint(' 复杂协程场景验证测试');
  staticPrint('═══════════════════════════════════════════');
  testRecursiveAsync();
  testExceptionPropagation();
  testConditionalAwait();
  testLoopBreakAwait();
  testTryCatchAwait();
  testFutureAny();
  testTimeout();
  testAsyncPipeline();
  testClosureCaptureAwait();
  testAsyncGenerator();
  testComplexBusiness();
  staticPrint('\n═══════════════════════════════════════════');
  staticPrint(' ✅ 全部 11 个复杂场景测试通过！');
  staticPrint('═══════════════════════════════════════════');
  drainScheduler();
}

class ClosureEnv_anon_0 extends TypeFunction0<String> {
  ClosureEnv_anon_0();
  @override
  String call() => fnPtr(this);
}
ClosureEnv_anon_0 ClosureEnv_anon_0_new(ClosureEnv_anon_0 env_) {
  env_.fnPtr = ClosureEnv_anon_0_call;
  return env_;
}
String ClosureEnv_anon_0_call(AnyGC env__) {
  final env = env__ as ClosureEnv_anon_0;

  return 'branch_true';
}

class ClosureEnv_anon_1 extends TypeFunction0<String> {
  ClosureEnv_anon_1();
  @override
  String call() => fnPtr(this);
}
ClosureEnv_anon_1 ClosureEnv_anon_1_new(ClosureEnv_anon_1 env_) {
  env_.fnPtr = ClosureEnv_anon_1_call;
  return env_;
}
String ClosureEnv_anon_1_call(AnyGC env__) {
  final env = env__ as ClosureEnv_anon_1;

  return 'branch_false';
}

class ClosureEnv_anon_2 extends TypeFunction0<int> {
  late FindFirstSMValue this_;
  ClosureEnv_anon_2();
  @override
  int call() => fnPtr(this);
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
    if (this_ is AnyGC) (this_ as AnyGC).gcMark(flag);
  }
}
ClosureEnv_anon_2 ClosureEnv_anon_2_new(ClosureEnv_anon_2 env_, FindFirstSMValue this_) {
  env_.fnPtr = ClosureEnv_anon_2_call;
  env_.this_ = this_;
  return env_;
}
int ClosureEnv_anon_2_call(AnyGC env__) {
  final env = env__ as ClosureEnv_anon_2;

  return ((env.this_.items.classInfo as StaticListClassInfo).operatorIndex!(env.this_.items, env.this_._index) * 3);
}

class ClosureEnv_anon_3 extends TypeFunction0<Never> {
  ClosureEnv_anon_3();
  @override
  Never call() => fnPtr(this);
}
ClosureEnv_anon_3 ClosureEnv_anon_3_new(ClosureEnv_anon_3 env_) {
  env_.fnPtr = ClosureEnv_anon_3_call;
  return env_;
}
Never ClosureEnv_anon_3_call(AnyGC env__) {
  final env = env__ as ClosureEnv_anon_3;

  return throw 'boom';
}

class ClosureEnv_anon_4 extends TypeFunction0<String> {
  ClosureEnv_anon_4();
  @override
  String call() => fnPtr(this);
}
ClosureEnv_anon_4 ClosureEnv_anon_4_new(ClosureEnv_anon_4 env_) {
  env_.fnPtr = ClosureEnv_anon_4_call;
  return env_;
}
String ClosureEnv_anon_4_call(AnyGC env__) {
  final env = env__ as ClosureEnv_anon_4;

  return 'recovered';
}

class ClosureEnv_anon_5 extends TypeFunction0<String> {
  ClosureEnv_anon_5();
  @override
  String call() => fnPtr(this);
}
ClosureEnv_anon_5 ClosureEnv_anon_5_new(ClosureEnv_anon_5 env_) {
  env_.fnPtr = ClosureEnv_anon_5_call;
  return env_;
}
String ClosureEnv_anon_5_call(AnyGC env__) {
  final env = env__ as ClosureEnv_anon_5;

  return 'slow';
}

class ClosureEnv_anon_6 extends TypeFunction0<String> {
  ClosureEnv_anon_6();
  @override
  String call() => fnPtr(this);
}
ClosureEnv_anon_6 ClosureEnv_anon_6_new(ClosureEnv_anon_6 env_) {
  env_.fnPtr = ClosureEnv_anon_6_call;
  return env_;
}
String ClosureEnv_anon_6_call(AnyGC env__) {
  final env = env__ as ClosureEnv_anon_6;

  return 'fast';
}

class ClosureEnv_anon_7 extends TypeFunction0<String> {
  ClosureEnv_anon_7();
  @override
  String call() => fnPtr(this);
}
ClosureEnv_anon_7 ClosureEnv_anon_7_new(ClosureEnv_anon_7 env_) {
  env_.fnPtr = ClosureEnv_anon_7_call;
  return env_;
}
String ClosureEnv_anon_7_call(AnyGC env__) {
  final env = env__ as ClosureEnv_anon_7;

  return 'slowest';
}

class ClosureEnv_anon_8 extends TypeFunction0<String> {
  ClosureEnv_anon_8();
  @override
  String call() => fnPtr(this);
}
ClosureEnv_anon_8 ClosureEnv_anon_8_new(ClosureEnv_anon_8 env_) {
  env_.fnPtr = ClosureEnv_anon_8_call;
  return env_;
}
String ClosureEnv_anon_8_call(AnyGC env__) {
  final env = env__ as ClosureEnv_anon_8;

  return 'slow';
}

class ClosureEnv_anon_9 extends TypeFunction0<String> {
  ClosureEnv_anon_9();
  @override
  String call() => fnPtr(this);
}
ClosureEnv_anon_9 ClosureEnv_anon_9_new(ClosureEnv_anon_9 env_) {
  env_.fnPtr = ClosureEnv_anon_9_call;
  return env_;
}
String ClosureEnv_anon_9_call(AnyGC env__) {
  final env = env__ as ClosureEnv_anon_9;

  return 'fast';
}

class ClosureEnv_anon_10 extends TypeFunction0<String> {
  ClosureEnv_anon_10();
  @override
  String call() => fnPtr(this);
}
ClosureEnv_anon_10 ClosureEnv_anon_10_new(ClosureEnv_anon_10 env_) {
  env_.fnPtr = ClosureEnv_anon_10_call;
  return env_;
}
String ClosureEnv_anon_10_call(AnyGC env__) {
  final env = env__ as ClosureEnv_anon_10;

  return 'slowest';
}

class ClosureEnv_anon_11 extends TypeFunction0<String> {
  ClosureEnv_anon_11();
  @override
  String call() => fnPtr(this);
}
ClosureEnv_anon_11 ClosureEnv_anon_11_new(ClosureEnv_anon_11 env_) {
  env_.fnPtr = ClosureEnv_anon_11_call;
  return env_;
}
String ClosureEnv_anon_11_call(AnyGC env__) {
  final env = env__ as ClosureEnv_anon_11;

  return 'done';
}

class ClosureEnv_anon_12 extends TypeFunction0<String> {
  ClosureEnv_anon_12();
  @override
  String call() => fnPtr(this);
}
ClosureEnv_anon_12 ClosureEnv_anon_12_new(ClosureEnv_anon_12 env_) {
  env_.fnPtr = ClosureEnv_anon_12_call;
  return env_;
}
String ClosureEnv_anon_12_call(AnyGC env__) {
  final env = env__ as ClosureEnv_anon_12;

  return 'TIMEOUT';
}

class ClosureEnv_anon_13 extends TypeFunction0<String> {
  late IntBox item;
  ClosureEnv_anon_13();
  @override
  String call() => fnPtr(this);
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
    if (item is AnyGC) (item as AnyGC).gcMark(flag);
  }
}
ClosureEnv_anon_13 ClosureEnv_anon_13_new(ClosureEnv_anon_13 env_, IntBox item) {
  env_.fnPtr = ClosureEnv_anon_13_call;
  env_.item = item;
  return env_;
}
String ClosureEnv_anon_13_call(AnyGC env__) {
  final env = env__ as ClosureEnv_anon_13;

  return 'item_${(env.item.value * 2)}';
}

class ClosureEnv_anon_14 extends TypeFunction0<String> {
  late AsyncReduceSMValue this_;
  ClosureEnv_anon_14();
  @override
  String call() => fnPtr(this);
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
    if (this_ is AnyGC) (this_ as AnyGC).gcMark(flag);
  }
}
ClosureEnv_anon_14 ClosureEnv_anon_14_new(ClosureEnv_anon_14 env_, AsyncReduceSMValue this_) {
  env_.fnPtr = ClosureEnv_anon_14_call;
  env_.this_ = this_;
  return env_;
}
String ClosureEnv_anon_14_call(AnyGC env__) {
  final env = env__ as ClosureEnv_anon_14;

            final String sep = (env.this_._acc.isEmpty ? '' : '+');
            return '${env.this_._acc}${sep}${(env.this_._items.classInfo as StaticListClassInfo).operatorIndex!(env.this_._items, env.this_._index)}';
          }

class ClosureEnv_anon_15 extends TypeFunction0<int> {
  late ProcessWithClosureSMValue this_;
  late IntBox item;
  ClosureEnv_anon_15();
  @override
  int call() => fnPtr(this);
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
    if (this_ is AnyGC) (this_ as AnyGC).gcMark(flag);
    if (item is AnyGC) (item as AnyGC).gcMark(flag);
  }
}
ClosureEnv_anon_15 ClosureEnv_anon_15_new(ClosureEnv_anon_15 env_, ProcessWithClosureSMValue this_, IntBox item) {
  env_.fnPtr = ClosureEnv_anon_15_call;
  env_.this_ = this_;
  env_.item = item;
  return env_;
}
int ClosureEnv_anon_15_call(AnyGC env__) {
  final env = env__ as ClosureEnv_anon_15;

  return (env.this_._env.classInfo as ClosureEnv_process_0ClassInfo).call!(env.this_._env, env.item.value);
}

class ClosureEnv_anon_16 extends TypeFunction0<int> {
  late AsyncGeneratorSMValue this_;
  ClosureEnv_anon_16();
  @override
  int call() => fnPtr(this);
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
    if (this_ is AnyGC) (this_ as AnyGC).gcMark(flag);
  }
}
ClosureEnv_anon_16 ClosureEnv_anon_16_new(ClosureEnv_anon_16 env_, AsyncGeneratorSMValue this_) {
  env_.fnPtr = ClosureEnv_anon_16_call;
  env_.this_ = this_;
  return env_;
}
int ClosureEnv_anon_16_call(AnyGC env__) {
  final env = env__ as ClosureEnv_anon_16;

  return (env.this_._i * env.this_._i);
}

