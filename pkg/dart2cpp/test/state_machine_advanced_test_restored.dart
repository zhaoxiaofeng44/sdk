import 'package:dart2cpp/restorer/runtime_classes.dart';

class FibStateMachineValue extends AsyncStateMachine<int> {
  late int n;
  late int _a = 0;
  late Promise<int>? _pending = null;
  late Map<String, dynamic> vptr = <String, dynamic>{};
  @override
  bool step() {
    return (vptr['step'] as bool Function(dynamic))(this);
  }
  FibStateMachineValue() {
    vptr['step'] = FibStateMachine_step;
  }
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
    if (_pending is AnyGC) (_pending as AnyGC).gcMark(flag);
  }
}

FibStateMachineValue FibStateMachine_new(dynamic this__, int n) {
  final this_ = this__ as FibStateMachineValue;
  this_.n = n;
  return this_;
}

bool FibStateMachine_step(dynamic this__) {
  final this_ = this__ as FibStateMachineValue;
  do {
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


class Level3SMValue extends AsyncStateMachine<int> {
  late Map<String, dynamic> vptr = <String, dynamic>{};
  @override
  bool step() {
    return (vptr['step'] as bool Function(dynamic))(this);
  }
  Level3SMValue() {
    vptr['step'] = Level3SM_step;
  }
}

Level3SMValue Level3SM_new(dynamic this__) {
  final this_ = this__ as Level3SMValue;
  return this_;
}

bool Level3SM_step(dynamic this__) {
  final this_ = this__ as Level3SMValue;
  this_.completeWithError(Exception('deep error'));
  return true;
}


class Level2SMValue extends AsyncStateMachine<int> {
  late Promise<int>? _pending = null;
  late Map<String, dynamic> vptr = <String, dynamic>{};
  @override
  bool step() {
    return (vptr['step'] as bool Function(dynamic))(this);
  }
  Level2SMValue() {
    vptr['step'] = Level2SM_step;
  }
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
    if (_pending is AnyGC) (_pending as AnyGC).gcMark(flag);
  }
}

Level2SMValue Level2SM_new(dynamic this__) {
  final this_ = this__ as Level2SMValue;
  return this_;
}

bool Level2SM_step(dynamic this__) {
  final this_ = this__ as Level2SMValue;
  do {
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


class Level1SMValue extends AsyncStateMachine<String> {
  late Promise<int>? _pending = null;
  late Map<String, dynamic> vptr = <String, dynamic>{};
  @override
  bool step() {
    return (vptr['step'] as bool Function(dynamic))(this);
  }
  Level1SMValue() {
    vptr['step'] = Level1SM_step;
  }
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
    if (_pending is AnyGC) (_pending as AnyGC).gcMark(flag);
  }
}

Level1SMValue Level1SM_new(dynamic this__) {
  final this_ = this__ as Level1SMValue;
  return this_;
}

bool Level1SM_step(dynamic this__) {
  final this_ = this__ as Level1SMValue;
  do {
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


class ConditionalAwaitSMValue extends AsyncStateMachine<String> {
  late bool flag;
  late Promise<String>? _pending = null;
  late Map<String, dynamic> vptr = <String, dynamic>{};
  @override
  bool step() {
    return (vptr['step'] as bool Function(dynamic))(this);
  }
  ConditionalAwaitSMValue() {
    vptr['step'] = ConditionalAwaitSM_step;
  }
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
    if (_pending is AnyGC) (_pending as AnyGC).gcMark(flag);
  }
}

ConditionalAwaitSMValue ConditionalAwaitSM_new(dynamic this__, bool flag) {
  final this_ = this__ as ConditionalAwaitSMValue;
  this_.flag = flag;
  return this_;
}

bool ConditionalAwaitSM_step(dynamic this__) {
  final this_ = this__ as ConditionalAwaitSMValue;
  do {
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


class FindFirstSMValue extends AsyncStateMachine<int> {
  late StaticList<int> items;
  late int _index = 0;
  late Promise<int>? _pending = null;
  late Map<String, dynamic> vptr = <String, dynamic>{};
  @override
  bool step() {
    return (vptr['step'] as bool Function(dynamic))(this);
  }
  FindFirstSMValue() {
    vptr['step'] = FindFirstSM_step;
  }
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
    if (items is AnyGC) (items as AnyGC).gcMark(flag);
    if (_pending is AnyGC) (_pending as AnyGC).gcMark(flag);
  }
}

FindFirstSMValue FindFirstSM_new(dynamic this__, StaticList<int> items) {
  final this_ = this__ as FindFirstSMValue;
  this_.items = items;
  return this_;
}

bool FindFirstSM_step(dynamic this__) {
  final this_ = this__ as FindFirstSMValue;
  do {
    switch (this_.smState) {
      case 0:
{
          if ((this_._index >= this_.items.length)) {
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


class TryCatchSMValue extends AsyncStateMachine<String> {
  late String _log = '';
  late Promise<dynamic>? _pending = null;
  late Map<String, dynamic> vptr = <String, dynamic>{};
  @override
  bool step() {
    return (vptr['step'] as bool Function(dynamic))(this);
  }
  TryCatchSMValue() {
    vptr['step'] = TryCatchSM_step;
  }
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
    if (_pending is AnyGC) (_pending as AnyGC).gcMark(flag);
  }
}

TryCatchSMValue TryCatchSM_new(dynamic this__) {
  final this_ = this__ as TryCatchSMValue;
  return this_;
}

bool TryCatchSM_step(dynamic this__) {
  final this_ = this__ as TryCatchSMValue;
  do {
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


class FutureAnySMValue extends AsyncStateMachine<String> {
  late StaticList<Promise<String>> _futures;
  late Map<String, dynamic> vptr = <String, dynamic>{};
  @override
  bool step() {
    return (vptr['step'] as bool Function(dynamic))(this);
  }
  FutureAnySMValue() {
    vptr['step'] = FutureAnySM_step;
  }
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
    if (_futures is AnyGC) (_futures as AnyGC).gcMark(flag);
  }
}

FutureAnySMValue FutureAnySM_new(dynamic this__) {
  final this_ = this__ as FutureAnySMValue;
  return this_;
}

bool FutureAnySM_step(dynamic this__) {
  final this_ = this__ as FutureAnySMValue;
  do {
    switch (this_.smState) {
      case 0:
{
          this_._futures = StaticList<Promise<String>>.of([Promise.delayed(5, ClosureEnv_anon_5_new(GC.allocateLocal(ClosureEnv_anon_5()))), Promise.delayed(2, ClosureEnv_anon_6_new(GC.allocateLocal(ClosureEnv_anon_6()))), Promise.delayed(8, ClosureEnv_anon_7_new(GC.allocateLocal(ClosureEnv_anon_7())))]);
          this_.smState = 1;
          return false;
        }
      case 1:
{
          for (final f in this_._futures) {
            if (f.isCompleted) {
              this_.completeWith(f.result);
              return true;
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


class TimeoutSMValue extends AsyncStateMachine<String> {
  late int taskDelay;
  late int timeoutDelay;
  late Promise<String> _taskFuture;
  late Promise<String> _timeoutFuture;
  late Map<String, dynamic> vptr = <String, dynamic>{};
  @override
  bool step() {
    return (vptr['step'] as bool Function(dynamic))(this);
  }
  TimeoutSMValue() {
    vptr['step'] = TimeoutSM_step;
  }
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
    if (_taskFuture is AnyGC) (_taskFuture as AnyGC).gcMark(flag);
    if (_timeoutFuture is AnyGC) (_timeoutFuture as AnyGC).gcMark(flag);
  }
}

TimeoutSMValue TimeoutSM_new(dynamic this__, {required int taskDelay, required int timeoutDelay}) {
  final this_ = this__ as TimeoutSMValue;
  this_.taskDelay = taskDelay;
  this_.timeoutDelay = timeoutDelay;
  return this_;
}

bool TimeoutSM_step(dynamic this__) {
  final this_ = this__ as TimeoutSMValue;
  do {
    switch (this_.smState) {
      case 0:
{
          this_._taskFuture = Promise.delayed(this_.taskDelay, ClosureEnv_anon_8_new(GC.allocateLocal(ClosureEnv_anon_8())));
          this_._timeoutFuture = Promise.delayed(this_.timeoutDelay, ClosureEnv_anon_9_new(GC.allocateLocal(ClosureEnv_anon_9())));
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


class AsyncMapSMValue extends AsyncStateMachine<StaticList<String>> {
  late StaticList<int> items;
  late StaticList<String> _results = StaticList<String>.of([]);
  late int _index = 0;
  late Promise<String>? _pending = null;
  late Map<String, dynamic> vptr = <String, dynamic>{};
  @override
  bool step() {
    return (vptr['step'] as bool Function(dynamic))(this);
  }
  AsyncMapSMValue() {
    vptr['step'] = AsyncMapSM_step;
  }
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
    if (items is AnyGC) (items as AnyGC).gcMark(flag);
    if (_results is AnyGC) (_results as AnyGC).gcMark(flag);
    if (_pending is AnyGC) (_pending as AnyGC).gcMark(flag);
  }
}

AsyncMapSMValue AsyncMapSM_new(dynamic this__, StaticList<int> items) {
  final this_ = this__ as AsyncMapSMValue;
  this_.items = items;
  return this_;
}

bool AsyncMapSM_step(dynamic this__) {
  final this_ = this__ as AsyncMapSMValue;
  do {
    switch (this_.smState) {
      case 0:
{
          if ((this_._index >= this_.items.length)) {
            this_.completeWith(this_._results);
            return true;
          }
          IntBox item = IntBox(this_.items[this_._index]);
          this_._pending = Promise.delayed(1, ClosureEnv_anon_10_new(GC.allocateLocal(ClosureEnv_anon_10()), item));
          this_.smState = 1;
          return false;
        }
      case 1:
{
          if (this_._pending!.isPending)           return false;
          this_._results.add(this_._pending!.result);
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


class AsyncReduceSMValue extends AsyncStateMachine<String> {
  late Promise<StaticList<String>> _mapFuture;
  late Promise<String>? _reducePending = null;
  late StaticList<String> _items = StaticList<String>.of([]);
  late int _index = 0;
  late String _acc = '';
  late Map<String, dynamic> vptr = <String, dynamic>{};
  @override
  bool step() {
    return (vptr['step'] as bool Function(dynamic))(this);
  }
  AsyncReduceSMValue() {
    vptr['step'] = AsyncReduceSM_step;
  }
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
    if (_mapFuture is AnyGC) (_mapFuture as AnyGC).gcMark(flag);
    if (_reducePending is AnyGC) (_reducePending as AnyGC).gcMark(flag);
    if (_items is AnyGC) (_items as AnyGC).gcMark(flag);
  }
}

AsyncReduceSMValue AsyncReduceSM_new(dynamic this__) {
  final this_ = this__ as AsyncReduceSMValue;
  return this_;
}

bool AsyncReduceSM_step(dynamic this__) {
  final this_ = this__ as AsyncReduceSMValue;
  do {
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
          if ((this_._index >= this_._items.length)) {
            this_.completeWith(this_._acc);
            return true;
          }
          this_._reducePending = Promise.delayed(1, ClosureEnv_anon_11_new(GC.allocateLocal(ClosureEnv_anon_11()), this_));
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


class ClosureEnv_process_0Value extends VPtr {
  late int factor;
  ClosureEnv_process_0Value() {
    vptr['call'] = ClosureEnv_process_0_call;
  }
}

ClosureEnv_process_0Value ClosureEnv_process_0_new(dynamic this__, int factor) {
  final this_ = this__ as ClosureEnv_process_0Value;
  this_.factor = factor;
  return this_;
}

int ClosureEnv_process_0_call(dynamic this__, int x) {
  final this_ = this__ as ClosureEnv_process_0Value;
  return (x * this_.factor);
}


class ProcessWithClosureSMValue extends AsyncStateMachine<StaticList<int>> {
  late ClosureEnv_process_0Value _env;
  late StaticList<int> items;
  late StaticList<int> _results = StaticList<int>.of([]);
  late int _index = 0;
  late Promise<int>? _pending = null;
  late Map<String, dynamic> vptr = <String, dynamic>{};
  @override
  bool step() {
    return (vptr['step'] as bool Function(dynamic))(this);
  }
  ProcessWithClosureSMValue() {
    vptr['step'] = ProcessWithClosureSM_step;
  }
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
    if (_env is AnyGC) (_env as AnyGC).gcMark(flag);
    if (items is AnyGC) (items as AnyGC).gcMark(flag);
    if (_results is AnyGC) (_results as AnyGC).gcMark(flag);
    if (_pending is AnyGC) (_pending as AnyGC).gcMark(flag);
  }
}

ProcessWithClosureSMValue ProcessWithClosureSM_new(dynamic this__, StaticList<int> items) {
  final this_ = this__ as ProcessWithClosureSMValue;
  this_.items = items;
  return this_;
}

bool ProcessWithClosureSM_step(dynamic this__) {
  final this_ = this__ as ProcessWithClosureSMValue;
  do {
    switch (this_.smState) {
      case 0:
{
          this_._env = ClosureEnv_process_0_new(GC.allocateLocal(ClosureEnv_process_0Value()), 3);
          this_.smState = 1;
          return false;
        }
      case 1:
{
          if ((this_._index >= this_.items.length)) {
            this_.smState = 3;
            return false;
          }
          IntBox item = IntBox(this_.items[this_._index]);
          this_._pending = Promise.delayed(1, ClosureEnv_anon_12_new(GC.allocateLocal(ClosureEnv_anon_12()), this_, item));
          this_.smState = 2;
          return false;
        }
      case 2:
{
          if (this_._pending!.isPending)           return false;
          this_._results.add(this_._pending!.result);
          this_._index = (this_._index + 1);
          this_.smState = 1;
          return false;
        }
      case 3:
{
          this_._env.factor = 5;
          this_._results.add((this_._env.vptr['call'] as int Function(dynamic, int))(this_._env, 100));
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


class AsyncGeneratorSMValue extends AsyncStateMachine<StaticList<int>> {
  late int max;
  late int _i = 0;
  late StaticList<int> _yielded = StaticList<int>.of([]);
  late Promise<int>? _pending = null;
  late Map<String, dynamic> vptr = <String, dynamic>{};
  @override
  bool step() {
    return (vptr['step'] as bool Function(dynamic))(this);
  }
  AsyncGeneratorSMValue() {
    vptr['step'] = AsyncGeneratorSM_step;
  }
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
    if (_yielded is AnyGC) (_yielded as AnyGC).gcMark(flag);
    if (_pending is AnyGC) (_pending as AnyGC).gcMark(flag);
  }
}

AsyncGeneratorSMValue AsyncGeneratorSM_new(dynamic this__, int max) {
  final this_ = this__ as AsyncGeneratorSMValue;
  this_.max = max;
  return this_;
}

bool AsyncGeneratorSM_step(dynamic this__) {
  final this_ = this__ as AsyncGeneratorSMValue;
  do {
    switch (this_.smState) {
      case 0:
{
          if ((this_._i >= this_.max)) {
            this_.completeWith(this_._yielded);
            return true;
          }
          this_._pending = Promise.delayed(1, ClosureEnv_anon_13_new(GC.allocateLocal(ClosureEnv_anon_13()), this_));
          this_.smState = 1;
          return false;
        }
      case 1:
{
          if (this_._pending!.isPending)           return false;
          this_._yielded.add(this_._pending!.result);
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


class ComplexBusinessSMValue extends AsyncStateMachine<StaticMap<String, dynamic>> {
  late int depth;
  late Promise<StaticMap<String, dynamic>>? _pending = null;
  late Map<String, dynamic> vptr = <String, dynamic>{};
  @override
  bool step() {
    return (vptr['step'] as bool Function(dynamic))(this);
  }
  ComplexBusinessSMValue() {
    vptr['step'] = ComplexBusinessSM_step;
  }
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
    if (_pending is AnyGC) (_pending as AnyGC).gcMark(flag);
  }
}

ComplexBusinessSMValue ComplexBusinessSM_new(dynamic this__, int depth) {
  final this_ = this__ as ComplexBusinessSMValue;
  this_.depth = depth;
  return this_;
}

bool ComplexBusinessSM_step(dynamic this__) {
  final this_ = this__ as ComplexBusinessSMValue;
  do {
    switch (this_.smState) {
      case 0:
{
          if ((this_.depth <= 0)) {
            this_.completeWithError(Exception('max depth'));
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
  final dynamic r = smAwait<dynamic>(Level1SM_new(GC.allocateLocal(Level1SMValue())).start());
  assert((r.contains('deep error') as bool), 'Expected deep error, got: ${r}');
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
  final dynamic r = smAwait<dynamic>(ProcessWithClosureSM_new(GC.allocateLocal(ProcessWithClosureSMValue()), StaticList<int>.of([1, 2, 3])).start());
  assert((r.length == 4), 'Expected 4 results');
  assert(((((r[0] == 3) && (r[1] == 6)) && (r[2] == 9)) && (r[3] == 500)), 'Unexpected: ${r}');
  staticPrint('  ✓ processWithClosure([1,2,3]) = ${r}');
  staticPrint('    (factor=3→[3,6,9], mutate factor=5→100*5=500)');
}

void testAsyncGenerator() {
  staticPrint('\n--- 10. async* 生成器模拟 ---');
  GlobalScheduler.instance.reset();
  final dynamic r = smAwait<dynamic>(AsyncGeneratorSM_new(GC.allocateLocal(AsyncGeneratorSMValue()), 5).start());
  assert((r.length == 5), 'Expected 5 items');
  assert((((((r[0] == 0) && (r[1] == 1)) && (r[2] == 4)) && (r[3] == 9)) && (r[4] == 16)), 'Unexpected: ${r}');
  staticPrint('  ✓ countUp(5) yields ${r}');
}

void testComplexBusiness() {
  staticPrint('\n--- 11. 复合场景：递归+异常+条件 ---');
  GlobalScheduler.instance.reset();
  final dynamic r = smAwait<dynamic>(ComplexBusinessSM_new(GC.allocateLocal(ComplexBusinessSMValue()), 3).start());
  assert((r['depth'] == 3), 'Top level depth should be 3');
  final StaticMap<String, dynamic> child2 = StaticMap<String, dynamic>.of((r['child'] as StaticMap<String, dynamic>));
  assert((child2['depth'] == 2), 'Child depth should be 2');
  final StaticMap<String, dynamic> child1 = StaticMap<String, dynamic>.of((child2['child'] as StaticMap<String, dynamic>));
  assert((child1['depth'] == 1), 'Deepest depth should be 1');
  assert((child1['error'] as String).contains('max depth'), 'Should contain error');
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
}

class ClosureEnv_anon_0 extends TypeFunction0<String> {
  ClosureEnv_anon_0();
  @override
  String call() => closureCall(this);
}
ClosureEnv_anon_0 ClosureEnv_anon_0_new(ClosureEnv_anon_0 env_) {
  env_.closureCall = ClosureEnv_anon_0_call;
  return env_;
}
String ClosureEnv_anon_0_call(dynamic env__) {
  final env = env__ as ClosureEnv_anon_0;

  return 'branch_true';
}

class ClosureEnv_anon_1 extends TypeFunction0<String> {
  ClosureEnv_anon_1();
  @override
  String call() => closureCall(this);
}
ClosureEnv_anon_1 ClosureEnv_anon_1_new(ClosureEnv_anon_1 env_) {
  env_.closureCall = ClosureEnv_anon_1_call;
  return env_;
}
String ClosureEnv_anon_1_call(dynamic env__) {
  final env = env__ as ClosureEnv_anon_1;

  return 'branch_false';
}

class ClosureEnv_anon_2 extends TypeFunction0<int> {
  late FindFirstSMValue this_;
  ClosureEnv_anon_2();
  @override
  int call() => closureCall(this);
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
    if (this_ is AnyGC) (this_ as AnyGC).gcMark(flag);
  }
}
ClosureEnv_anon_2 ClosureEnv_anon_2_new(ClosureEnv_anon_2 env_, FindFirstSMValue this_) {
  env_.closureCall = ClosureEnv_anon_2_call;
  env_.this_ = this_;
  return env_;
}
int ClosureEnv_anon_2_call(dynamic env__) {
  final env = env__ as ClosureEnv_anon_2;

  return (env.this_.items[env.this_._index] * 3);
}

class ClosureEnv_anon_3 extends TypeFunction0<Never> {
  ClosureEnv_anon_3();
  @override
  Never call() => closureCall(this);
}
ClosureEnv_anon_3 ClosureEnv_anon_3_new(ClosureEnv_anon_3 env_) {
  env_.closureCall = ClosureEnv_anon_3_call;
  return env_;
}
Never ClosureEnv_anon_3_call(dynamic env__) {
  final env = env__ as ClosureEnv_anon_3;

  return throw 'boom';
}

class ClosureEnv_anon_4 extends TypeFunction0<String> {
  ClosureEnv_anon_4();
  @override
  String call() => closureCall(this);
}
ClosureEnv_anon_4 ClosureEnv_anon_4_new(ClosureEnv_anon_4 env_) {
  env_.closureCall = ClosureEnv_anon_4_call;
  return env_;
}
String ClosureEnv_anon_4_call(dynamic env__) {
  final env = env__ as ClosureEnv_anon_4;

  return 'recovered';
}

class ClosureEnv_anon_5 extends TypeFunction0<String> {
  ClosureEnv_anon_5();
  @override
  String call() => closureCall(this);
}
ClosureEnv_anon_5 ClosureEnv_anon_5_new(ClosureEnv_anon_5 env_) {
  env_.closureCall = ClosureEnv_anon_5_call;
  return env_;
}
String ClosureEnv_anon_5_call(dynamic env__) {
  final env = env__ as ClosureEnv_anon_5;

  return 'slow';
}

class ClosureEnv_anon_6 extends TypeFunction0<String> {
  ClosureEnv_anon_6();
  @override
  String call() => closureCall(this);
}
ClosureEnv_anon_6 ClosureEnv_anon_6_new(ClosureEnv_anon_6 env_) {
  env_.closureCall = ClosureEnv_anon_6_call;
  return env_;
}
String ClosureEnv_anon_6_call(dynamic env__) {
  final env = env__ as ClosureEnv_anon_6;

  return 'fast';
}

class ClosureEnv_anon_7 extends TypeFunction0<String> {
  ClosureEnv_anon_7();
  @override
  String call() => closureCall(this);
}
ClosureEnv_anon_7 ClosureEnv_anon_7_new(ClosureEnv_anon_7 env_) {
  env_.closureCall = ClosureEnv_anon_7_call;
  return env_;
}
String ClosureEnv_anon_7_call(dynamic env__) {
  final env = env__ as ClosureEnv_anon_7;

  return 'slowest';
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

  return 'done';
}

class ClosureEnv_anon_9 extends TypeFunction0<String> {
  ClosureEnv_anon_9();
  @override
  String call() => closureCall(this);
}
ClosureEnv_anon_9 ClosureEnv_anon_9_new(ClosureEnv_anon_9 env_) {
  env_.closureCall = ClosureEnv_anon_9_call;
  return env_;
}
String ClosureEnv_anon_9_call(dynamic env__) {
  final env = env__ as ClosureEnv_anon_9;

  return 'TIMEOUT';
}

class ClosureEnv_anon_10 extends TypeFunction0<String> {
  late IntBox item;
  ClosureEnv_anon_10();
  @override
  String call() => closureCall(this);
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
    if (item is AnyGC) (item as AnyGC).gcMark(flag);
  }
}
ClosureEnv_anon_10 ClosureEnv_anon_10_new(ClosureEnv_anon_10 env_, IntBox item) {
  env_.closureCall = ClosureEnv_anon_10_call;
  env_.item = item;
  return env_;
}
String ClosureEnv_anon_10_call(dynamic env__) {
  final env = env__ as ClosureEnv_anon_10;

  return 'item_${(env.item.value * 2)}';
}

class ClosureEnv_anon_11 extends TypeFunction0<String> {
  late AsyncReduceSMValue this_;
  ClosureEnv_anon_11();
  @override
  String call() => closureCall(this);
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
    if (this_ is AnyGC) (this_ as AnyGC).gcMark(flag);
  }
}
ClosureEnv_anon_11 ClosureEnv_anon_11_new(ClosureEnv_anon_11 env_, AsyncReduceSMValue this_) {
  env_.closureCall = ClosureEnv_anon_11_call;
  env_.this_ = this_;
  return env_;
}
String ClosureEnv_anon_11_call(dynamic env__) {
  final env = env__ as ClosureEnv_anon_11;

            final String sep = (env.this_._acc.isEmpty ? '' : '+');
            return '${env.this_._acc}${sep}${env.this_._items[env.this_._index]}';
          }

class ClosureEnv_anon_12 extends TypeFunction0<int> {
  late ProcessWithClosureSMValue this_;
  late IntBox item;
  ClosureEnv_anon_12();
  @override
  int call() => closureCall(this);
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
    if (this_ is AnyGC) (this_ as AnyGC).gcMark(flag);
    if (item is AnyGC) (item as AnyGC).gcMark(flag);
  }
}
ClosureEnv_anon_12 ClosureEnv_anon_12_new(ClosureEnv_anon_12 env_, ProcessWithClosureSMValue this_, IntBox item) {
  env_.closureCall = ClosureEnv_anon_12_call;
  env_.this_ = this_;
  env_.item = item;
  return env_;
}
int ClosureEnv_anon_12_call(dynamic env__) {
  final env = env__ as ClosureEnv_anon_12;

  return (env.this_._env.vptr['call'] as int Function(dynamic, int))(env.this_._env, env.item.value);
}

class ClosureEnv_anon_13 extends TypeFunction0<int> {
  late AsyncGeneratorSMValue this_;
  ClosureEnv_anon_13();
  @override
  int call() => closureCall(this);
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
    if (this_ is AnyGC) (this_ as AnyGC).gcMark(flag);
  }
}
ClosureEnv_anon_13 ClosureEnv_anon_13_new(ClosureEnv_anon_13 env_, AsyncGeneratorSMValue this_) {
  env_.closureCall = ClosureEnv_anon_13_call;
  env_.this_ = this_;
  return env_;
}
int ClosureEnv_anon_13_call(dynamic env__) {
  final env = env__ as ClosureEnv_anon_13;

  return (env.this_._i * env.this_._i);
}

