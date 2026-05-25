import 'package:dart2cpp/restorer/runtime_classes.dart';

class FibStateMachineValue extends AsyncStateMachine<int> {
  late int n;
  late int _a;
  late Promise<int>? _pending;
  late Map<String, dynamic> vptr = <String, dynamic>{};
  @override
  bool step() {
    return (vptr['step'] as bool Function(dynamic))(this);
  }
}

FibStateMachineValue FibStateMachine_new(dynamic this__, int n) {
  final this_ = this__ as FibStateMachineValue;
  this_.vptr['step'] = FibStateMachine_step;
  this_.n = n;
  this_._a = 0;
  this_._pending = null;
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
          this_._pending = FibStateMachine_new(FibStateMachineValue(), (this_.n - 1)).start();
          this_.smState = 1;
          return false;
        }
      case 1:
{
          if (this_._pending!.isPending)           return false;
          this_._a = this_._pending!.result;
          this_._pending = FibStateMachine_new(FibStateMachineValue(), (this_.n - 2)).start();
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
}

Level3SMValue Level3SM_new(dynamic this__) {
  final this_ = this__ as Level3SMValue;
  this_.vptr['step'] = Level3SM_step;
  return this_;
}

bool Level3SM_step(dynamic this__) {
  final this_ = this__ as Level3SMValue;
  this_.completeWithError(Exception('deep error'));
  return true;
}


class Level2SMValue extends AsyncStateMachine<int> {
  late Promise<int>? _pending;
  late Map<String, dynamic> vptr = <String, dynamic>{};
  @override
  bool step() {
    return (vptr['step'] as bool Function(dynamic))(this);
  }
}

Level2SMValue Level2SM_new(dynamic this__) {
  final this_ = this__ as Level2SMValue;
  this_.vptr['step'] = Level2SM_step;
  this_._pending = null;
  return this_;
}

bool Level2SM_step(dynamic this__) {
  final this_ = this__ as Level2SMValue;
  do {
    switch (this_.smState) {
      case 0:
{
          this_._pending = Level3SM_new(Level3SMValue()).start();
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
  late Promise<int>? _pending;
  late Map<String, dynamic> vptr = <String, dynamic>{};
  @override
  bool step() {
    return (vptr['step'] as bool Function(dynamic))(this);
  }
}

Level1SMValue Level1SM_new(dynamic this__) {
  final this_ = this__ as Level1SMValue;
  this_.vptr['step'] = Level1SM_step;
  this_._pending = null;
  return this_;
}

bool Level1SM_step(dynamic this__) {
  final this_ = this__ as Level1SMValue;
  do {
    switch (this_.smState) {
      case 0:
{
          this_._pending = Level2SM_new(Level2SMValue()).start();
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
  late Promise<String>? _pending;
  late Map<String, dynamic> vptr = <String, dynamic>{};
  @override
  bool step() {
    return (vptr['step'] as bool Function(dynamic))(this);
  }
}

ConditionalAwaitSMValue ConditionalAwaitSM_new(dynamic this__, bool flag) {
  final this_ = this__ as ConditionalAwaitSMValue;
  this_.vptr['step'] = ConditionalAwaitSM_step;
  this_.flag = flag;
  this_._pending = null;
  return this_;
}

bool ConditionalAwaitSM_step(dynamic this__) {
  final this_ = this__ as ConditionalAwaitSMValue;
  do {
    switch (this_.smState) {
      case 0:
{
          if (this_.flag) {
            this_._pending = Promise.delayed(2, () => 'branch_true');
            this_.smState = 1;
          }
 else {
            this_._pending = Promise.delayed(1, () => 'branch_false');
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
  late List<int> items;
  late int _index;
  late Promise<int>? _pending;
  late Map<String, dynamic> vptr = <String, dynamic>{};
  @override
  bool step() {
    return (vptr['step'] as bool Function(dynamic))(this);
  }
}

FindFirstSMValue FindFirstSM_new(dynamic this__, List<int> items) {
  final this_ = this__ as FindFirstSMValue;
  this_.vptr['step'] = FindFirstSM_step;
  this_.items = items;
  this_._index = 0;
  this_._pending = null;
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
          this_._pending = Promise.delayed(1, ClosureEnv_anon_0(this_).call);
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
  late String _log;
  late Promise<dynamic>? _pending;
  late Map<String, dynamic> vptr = <String, dynamic>{};
  @override
  bool step() {
    return (vptr['step'] as bool Function(dynamic))(this);
  }
}

TryCatchSMValue TryCatchSM_new(dynamic this__) {
  final this_ = this__ as TryCatchSMValue;
  this_.vptr['step'] = TryCatchSM_step;
  this_._log = '';
  this_._pending = null;
  return this_;
}

bool TryCatchSM_step(dynamic this__) {
  final this_ = this__ as TryCatchSMValue;
  do {
    switch (this_.smState) {
      case 0:
{
          this_._log = (this_._log + 'try;');
          this_._pending = Promise.delayed(1, () => throw 'boom');
          this_.smState = 1;
          return false;
        }
      case 1:
{
          if (this_._pending!.isPending)           return false;
          if (this_._pending!.isError) {
            this_._log = (this_._log + 'catch:${this_._pending!.error};');
            this_._pending = Promise.delayed(1, () => 'recovered');
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
  late List<Promise<String>> _futures;
  late Map<String, dynamic> vptr = <String, dynamic>{};
  @override
  bool step() {
    return (vptr['step'] as bool Function(dynamic))(this);
  }
}

FutureAnySMValue FutureAnySM_new(dynamic this__) {
  final this_ = this__ as FutureAnySMValue;
  this_.vptr['step'] = FutureAnySM_step;
  return this_;
}

bool FutureAnySM_step(dynamic this__) {
  final this_ = this__ as FutureAnySMValue;
  do {
    switch (this_.smState) {
      case 0:
{
          this_._futures = <Promise<String>>[Promise.delayed(5, () => 'slow'), Promise.delayed(2, () => 'fast'), Promise.delayed(8, () => 'slowest')];
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
}

TimeoutSMValue TimeoutSM_new(dynamic this__, {required int taskDelay, required int timeoutDelay}) {
  final this_ = this__ as TimeoutSMValue;
  this_.vptr['step'] = TimeoutSM_step;
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
          this_._taskFuture = Promise.delayed(this_.taskDelay, () => 'done');
          this_._timeoutFuture = Promise.delayed(this_.timeoutDelay, () => 'TIMEOUT');
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


class AsyncMapSMValue extends AsyncStateMachine<List<String>> {
  late List<int> items;
  late List<String> _results;
  late int _index;
  late Promise<String>? _pending;
  late Map<String, dynamic> vptr = <String, dynamic>{};
  @override
  bool step() {
    return (vptr['step'] as bool Function(dynamic))(this);
  }
}

AsyncMapSMValue AsyncMapSM_new(dynamic this__, List<int> items) {
  final this_ = this__ as AsyncMapSMValue;
  this_.vptr['step'] = AsyncMapSM_step;
  this_.items = items;
  this_._results = <String>[];
  this_._index = 0;
  this_._pending = null;
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
          this_._pending = Promise.delayed(1, ClosureEnv_anon_1(item).call);
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
  late Promise<List<String>> _mapFuture;
  late Promise<String>? _reducePending;
  late List<String> _items;
  late int _index;
  late String _acc;
  late Map<String, dynamic> vptr = <String, dynamic>{};
  @override
  bool step() {
    return (vptr['step'] as bool Function(dynamic))(this);
  }
}

AsyncReduceSMValue AsyncReduceSM_new(dynamic this__) {
  final this_ = this__ as AsyncReduceSMValue;
  this_.vptr['step'] = AsyncReduceSM_step;
  this_._reducePending = null;
  this_._items = <String>[];
  this_._index = 0;
  this_._acc = '';
  return this_;
}

bool AsyncReduceSM_step(dynamic this__) {
  final this_ = this__ as AsyncReduceSMValue;
  do {
    switch (this_.smState) {
      case 0:
{
          this_._mapFuture = AsyncMapSM_new(AsyncMapSMValue(), <int>[1, 2, 3, 4]).start();
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
          this_._reducePending = Promise.delayed(1, ClosureEnv_anon_2(this_).call);
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
}

ClosureEnv_process_0Value ClosureEnv_process_0_new(dynamic this__, int factor) {
  final this_ = this__ as ClosureEnv_process_0Value;
  this_.vptr['call'] = ClosureEnv_process_0_call;
  this_.factor = factor;
  return this_;
}

int ClosureEnv_process_0_call(dynamic this__, int x) {
  final this_ = this__ as ClosureEnv_process_0Value;
  return (x * this_.factor);
}


class ProcessWithClosureSMValue extends AsyncStateMachine<List<int>> {
  late ClosureEnv_process_0Value _env;
  late List<int> items;
  late List<int> _results;
  late int _index;
  late Promise<int>? _pending;
  late Map<String, dynamic> vptr = <String, dynamic>{};
  @override
  bool step() {
    return (vptr['step'] as bool Function(dynamic))(this);
  }
}

ProcessWithClosureSMValue ProcessWithClosureSM_new(dynamic this__, List<int> items) {
  final this_ = this__ as ProcessWithClosureSMValue;
  this_.vptr['step'] = ProcessWithClosureSM_step;
  this_.items = items;
  this_._results = <int>[];
  this_._index = 0;
  this_._pending = null;
  return this_;
}

bool ProcessWithClosureSM_step(dynamic this__) {
  final this_ = this__ as ProcessWithClosureSMValue;
  do {
    switch (this_.smState) {
      case 0:
{
          this_._env = ClosureEnv_process_0_new(ClosureEnv_process_0Value(), 3);
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
          this_._pending = Promise.delayed(1, ClosureEnv_anon_3(this_, item).call);
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


class AsyncGeneratorSMValue extends AsyncStateMachine<List<int>> {
  late int max;
  late int _i;
  late List<int> _yielded;
  late Promise<int>? _pending;
  late Map<String, dynamic> vptr = <String, dynamic>{};
  @override
  bool step() {
    return (vptr['step'] as bool Function(dynamic))(this);
  }
}

AsyncGeneratorSMValue AsyncGeneratorSM_new(dynamic this__, int max) {
  final this_ = this__ as AsyncGeneratorSMValue;
  this_.vptr['step'] = AsyncGeneratorSM_step;
  this_.max = max;
  this_._i = 0;
  this_._yielded = <int>[];
  this_._pending = null;
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
          this_._pending = Promise.delayed(1, ClosureEnv_anon_4(this_).call);
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


class ComplexBusinessSMValue extends AsyncStateMachine<Map<String, dynamic>> {
  late int depth;
  late Promise<Map<String, dynamic>>? _pending;
  late Map<String, dynamic> vptr = <String, dynamic>{};
  @override
  bool step() {
    return (vptr['step'] as bool Function(dynamic))(this);
  }
}

ComplexBusinessSMValue ComplexBusinessSM_new(dynamic this__, int depth) {
  final this_ = this__ as ComplexBusinessSMValue;
  this_.vptr['step'] = ComplexBusinessSM_step;
  this_.depth = depth;
  this_._pending = null;
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
          this_._pending = ComplexBusinessSM_new(ComplexBusinessSMValue(), (this_.depth - 1)).start();
          this_.smState = 1;
          return false;
        }
      case 1:
{
          if (this_._pending!.isPending)           return false;
          if (this_._pending!.isError) {
            this_.completeWith(<String, dynamic>{'depth': this_.depth, 'error': '${this_._pending!.error}'});
            return true;
          }
          this_.completeWith(<String, dynamic>{'depth': this_.depth, 'child': this_._pending!.result});
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
  print('\n--- 1. 递归异步 fibonacci ---');
  GlobalScheduler.instance.reset();
  final dynamic r = smAwait<dynamic>(FibStateMachine_new(FibStateMachineValue(), 7).start());
  assert((r == 13), 'fib(7) should be 13, got ${r}');
  print('  ✓ asyncFib(7) = ${r}');
}

void testExceptionPropagation() {
  print('\n--- 2. 异常传播链 (3层) ---');
  GlobalScheduler.instance.reset();
  final dynamic r = smAwait<dynamic>(Level1SM_new(Level1SMValue()).start());
  assert((r.contains('deep error') as bool), 'Expected deep error, got: ${r}');
  print('  ✓ level1() caught 3-level exception: "${r}"');
}

void testConditionalAwait() {
  print('\n--- 3. 条件分支中的 await ---');
  GlobalScheduler.instance.reset();
  final dynamic r1 = smAwait<dynamic>(ConditionalAwaitSM_new(ConditionalAwaitSMValue(), true).start());
  assert((r1 == 'branch_true'), 'Expected branch_true, got ${r1}');
  GlobalScheduler.instance.reset();
  final dynamic r2 = smAwait<dynamic>(ConditionalAwaitSM_new(ConditionalAwaitSMValue(), false).start());
  assert((r2 == 'branch_false'), 'Expected branch_false, got ${r2}');
  print('  ✓ conditionalAwait(true) = "${r1}"');
  print('  ✓ conditionalAwait(false) = "${r2}"');
}

void testLoopBreakAwait() {
  print('\n--- 4. 循环 + 提前 break 中的 await ---');
  GlobalScheduler.instance.reset();
  final dynamic r = smAwait<dynamic>(FindFirstSM_new(FindFirstSMValue(), <int>[1, 2, 3, 4, 5]).start());
  assert((r == 12), 'Expected 12, got ${r}');
  print('  ✓ findFirst([1,2,3,4,5]) = ${r} (4*3=12 > 10)');
}

void testTryCatchAwait() {
  print('\n--- 5. try-catch 中的 await ---');
  GlobalScheduler.instance.reset();
  final dynamic r = smAwait<dynamic>(TryCatchSM_new(TryCatchSMValue()).start());
  assert((r == 'try;catch:boom;recovered'), 'Unexpected: ${r}');
  print('  ✓ tryCatchAwait() = "${r}"');
}

void testFutureAny() {
  print('\n--- 6. Future.any 模拟（竞争取最先完成） ---');
  GlobalScheduler.instance.reset();
  final dynamic r = smAwait<dynamic>(FutureAnySM_new(FutureAnySMValue()).start());
  assert((r == 'fast'), 'Expected fast, got ${r}');
  print('  ✓ Future.any([slow(5), fast(2), slowest(8)]) = "${r}"');
}

void testTimeout() {
  print('\n--- 7. 超时控制模拟 ---');
  GlobalScheduler.instance.reset();
  final dynamic r1 = smAwait<dynamic>(TimeoutSM_new(TimeoutSMValue(), taskDelay: 2, timeoutDelay: 5).start());
  assert((r1 == 'done'), 'Expected done, got ${r1}');
  print('  ✓ task(2) timeout(5) = "${r1}" (task wins)');
  GlobalScheduler.instance.reset();
  final dynamic r2 = smAwait<dynamic>(TimeoutSM_new(TimeoutSMValue(), taskDelay: 10, timeoutDelay: 3).start());
  assert((r2 == 'TIMEOUT'), 'Expected TIMEOUT, got ${r2}');
  print('  ✓ task(10) timeout(3) = "${r2}" (timeout wins)');
}

void testAsyncPipeline() {
  print('\n--- 8. 链式异步变换管道 (map → reduce) ---');
  GlobalScheduler.instance.reset();
  final dynamic r = smAwait<dynamic>(AsyncReduceSM_new(AsyncReduceSMValue()).start());
  assert((r == 'item_2+item_4+item_6+item_8'), 'Unexpected: ${r}');
  print('  ✓ asyncMap([1,2,3,4]).reduce(+) = "${r}"');
}

void testClosureCaptureAwait() {
  print('\n--- 9. 闭包捕获 + await (ClosureEnv 模式) ---');
  GlobalScheduler.instance.reset();
  final dynamic r = smAwait<dynamic>(ProcessWithClosureSM_new(ProcessWithClosureSMValue(), <int>[1, 2, 3]).start());
  assert((r.length == 4), 'Expected 4 results');
  assert(((((r[0] == 3) && (r[1] == 6)) && (r[2] == 9)) && (r[3] == 500)), 'Unexpected: ${r}');
  print('  ✓ processWithClosure([1,2,3]) = ${r}');
  print('    (factor=3→[3,6,9], mutate factor=5→100*5=500)');
}

void testAsyncGenerator() {
  print('\n--- 10. async* 生成器模拟 ---');
  GlobalScheduler.instance.reset();
  final dynamic r = smAwait<dynamic>(AsyncGeneratorSM_new(AsyncGeneratorSMValue(), 5).start());
  assert((r.length == 5), 'Expected 5 items');
  assert((((((r[0] == 0) && (r[1] == 1)) && (r[2] == 4)) && (r[3] == 9)) && (r[4] == 16)), 'Unexpected: ${r}');
  print('  ✓ countUp(5) yields ${r}');
}

void testComplexBusiness() {
  print('\n--- 11. 复合场景：递归+异常+条件 ---');
  GlobalScheduler.instance.reset();
  final dynamic r = smAwait<dynamic>(ComplexBusinessSM_new(ComplexBusinessSMValue(), 3).start());
  assert((r['depth'] == 3), 'Top level depth should be 3');
  final Map<String, dynamic> child2 = (r['child'] as Map<String, dynamic>);
  assert((child2['depth'] == 2), 'Child depth should be 2');
  final Map<String, dynamic> child1 = (child2['child'] as Map<String, dynamic>);
  assert((child1['depth'] == 1), 'Deepest depth should be 1');
  assert((child1['error'] as String).contains('max depth'), 'Should contain error');
  print('  ✓ complexBusiness(3) = nested map with error at bottom');
  print('    depth=3 → child(depth=2) → child(depth=1, error:"max depth")');
}

void main() {
  print('═══════════════════════════════════════════');
  print(' 复杂协程场景验证测试');
  print('═══════════════════════════════════════════');
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
  print('\n═══════════════════════════════════════════');
  print(' ✅ 全部 11 个复杂场景测试通过！');
  print('═══════════════════════════════════════════');
}

class ClosureEnv_anon_0 {
  FindFirstSMValue this_;
  ClosureEnv_anon_0(this.this_);
  int call() => ClosureEnv_anon_0_call(this);
}
int ClosureEnv_anon_0_call(ClosureEnv_anon_0 env) {
  return (env.this_.items[env.this_._index] * 3);
}

class ClosureEnv_anon_1 {
  IntBox item;
  ClosureEnv_anon_1(this.item);
  String call() => ClosureEnv_anon_1_call(this);
}
String ClosureEnv_anon_1_call(ClosureEnv_anon_1 env) {
  return 'item_${(env.item.value * 2)}';
}

class ClosureEnv_anon_2 {
  AsyncReduceSMValue this_;
  ClosureEnv_anon_2(this.this_);
  String call() => ClosureEnv_anon_2_call(this);
}
String ClosureEnv_anon_2_call(ClosureEnv_anon_2 env) {
            final String sep = (env.this_._acc.isEmpty ? '' : '+');
            return '${env.this_._acc}${sep}${env.this_._items[env.this_._index]}';
          }

class ClosureEnv_anon_3 {
  ProcessWithClosureSMValue this_;
  IntBox item;
  ClosureEnv_anon_3(this.this_, this.item);
  int call() => ClosureEnv_anon_3_call(this);
}
int ClosureEnv_anon_3_call(ClosureEnv_anon_3 env) {
  return (env.this_._env.vptr['call'] as int Function(dynamic, int))(env.this_._env, env.item.value);
}

class ClosureEnv_anon_4 {
  AsyncGeneratorSMValue this_;
  ClosureEnv_anon_4(this.this_);
  int call() => ClosureEnv_anon_4_call(this);
}
int ClosureEnv_anon_4_call(ClosureEnv_anon_4 env) {
  return (env.this_._i * env.this_._i);
}

