import 'package:dart2cpp/restorer/runtime_classes.dart';

class FibStateMachineValue extends AsyncStateMachine<int> {
  late int n;
  late int _a;
  late dynamic _pending;

  FibStateMachineValue() {
    vptr['step'] = FibStateMachine_step;
  }

  @override
  void gcMark(int flag) {
    super.gcMark(flag);
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
        if ((this_.n <= 1)) {
          this_.completeWith(this_.n);
          return true;
        }
        this_._pending = FibStateMachine_new(FibStateMachineValue(), (this_.n - 1)).start();
        this_.smState = 1;
        return false;
      case 1:
        if (this_._pending!.isPending) {
          return false;
        }
        this_._a = this_._pending!.result;
        this_._pending = FibStateMachine_new(FibStateMachineValue(), (this_.n - 2)).start();
        this_.smState = 2;
        return false;
      case 2:
        if (this_._pending!.isPending) {
          return false;
        }
        this_.completeWith((this_._a + this_._pending!.result));
        return true;
      default:
        return true;
    }
  } while (false);
}

class Level3SMValue extends AsyncStateMachine<int> {

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
  this_.completeWithError(('deep error'));
  return true;
}

class Level2SMValue extends AsyncStateMachine<int> {
  late dynamic _pending;

  Level2SMValue() {
    vptr['step'] = Level2SM_step;
  }

  @override
  void gcMark(int flag) {
    super.gcMark(flag);
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
        this_._pending = Level3SM_new(Level3SMValue()).start();
        this_.smState = 1;
        return false;
      case 1:
        if (this_._pending!.isPending) {
          return false;
        }
        if (this_._pending!.isError) {
          this_.completeWithError(this_._pending!.error!);
          return true;
        }
        this_.completeWith(this_._pending!.result);
        return true;
      default:
        return true;
    }
  } while (false);
}

class Level1SMValue extends AsyncStateMachine<String> {
  late dynamic _pending;

  Level1SMValue() {
    vptr['step'] = Level1SM_step;
  }

  @override
  void gcMark(int flag) {
    super.gcMark(flag);
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
        this_._pending = Level2SM_new(Level2SMValue()).start();
        this_.smState = 1;
        return false;
      case 1:
        if (this_._pending!.isPending) {
          return false;
        }
        if (this_._pending!.isError) {
          this_.completeWith('caught: ${this_._pending!.error}');
          return true;
        }
        this_.completeWith('ok');
        return true;
      default:
        return true;
    }
  } while (false);
}

class ConditionalAwaitSMValue extends AsyncStateMachine<String> {
  late bool flag;
  late dynamic _pending;

  ConditionalAwaitSMValue() {
    vptr['step'] = ConditionalAwaitSM_step;
  }

  @override
  void gcMark(int flag) {
    super.gcMark(flag);
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
        if (this_.flag) {
          this_._pending = delayed(2, ClosureEnv_global_0_new(GC.allocateLocal(ClosureEnv_global_0())));
          this_.smState = 1;
        } else {
          this_._pending = delayed(1, ClosureEnv_global_1_new(GC.allocateLocal(ClosureEnv_global_1())));
          this_.smState = 2;
        }
        return false;
      case 1:
        if (this_._pending!.isPending) {
          return false;
        }
        this_.completeWith(this_._pending!.result);
        return true;
      case 2:
        if (this_._pending!.isPending) {
          return false;
        }
        this_.completeWith(this_._pending!.result);
        return true;
      default:
        return true;
    }
  } while (false);
}

class FindFirstSMValue extends AsyncStateMachine<int> {
  late StaticList<int> items;
  late int _index;
  late dynamic _pending;

  FindFirstSMValue() {
    vptr['step'] = FindFirstSM_step;
  }

  @override
  void gcMark(int flag) {
    super.gcMark(flag);
    items?.gcMark(flag);
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
        if ((this_._index >= this_.items.length)) {
          this_.completeWith(-1);
          return true;
        }
        this_._pending = delayed(1, ClosureEnv_global_2_new(GC.allocateLocal(ClosureEnv_global_2()), this_));
        this_.smState = 1;
        return false;
      case 1:
        if (this_._pending!.isPending) {
          return false;
        }
        int result = this_._pending!.result;
        if ((result > 10)) {
          this_.completeWith(result);
          return true;
        }
        this_._index = (this_._index + 1);
        this_.smState = 0;
        return false;
      default:
        return true;
    }
  } while (false);
}

class TryCatchSMValue extends AsyncStateMachine<String> {
  late String _log;
  late dynamic _pending;

  TryCatchSMValue() {
    vptr['step'] = TryCatchSM_step;
  }

  @override
  void gcMark(int flag) {
    super.gcMark(flag);
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
        this_._log = (this_._log + 'try;');
        this_._pending = delayed(1, ClosureEnv_global_3_new(GC.allocateLocal(ClosureEnv_global_3())));
        this_.smState = 1;
        return false;
      case 1:
        if (this_._pending!.isPending) {
          return false;
        }
        if (this_._pending!.isError) {
          this_._log = (this_._log + 'catch:${this_._pending!.error};');
          this_._pending = delayed(1, ClosureEnv_global_4_new(GC.allocateLocal(ClosureEnv_global_4())));
          this_.smState = 2;
          return false;
        }
        this_.completeWith(this_._log);
        return true;
      case 2:
        if (this_._pending!.isPending) {
          return false;
        }
        this_._log = (this_._log + (this_._pending!.result as String));
        this_.completeWith(this_._log);
        return true;
      default:
        return true;
    }
  } while (false);
}

class FutureAnySMValue extends AsyncStateMachine<String> {
  late StaticList<dynamic> _futures;

  FutureAnySMValue() {
    vptr['step'] = FutureAnySM_step;
  }

  @override
  void gcMark(int flag) {
    super.gcMark(flag);
    _futures?.gcMark(flag);
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
        this_._futures = StaticList<dynamic>.of([delayed(5, ClosureEnv_global_5_new(GC.allocateLocal(ClosureEnv_global_5()))), delayed(2, ClosureEnv_global_6_new(GC.allocateLocal(ClosureEnv_global_6()))), delayed(8, ClosureEnv_global_7_new(GC.allocateLocal(ClosureEnv_global_7())))]);
        this_.smState = 1;
        return false;
      case 1:
        for (final f in this_._futures) {
          if (f.isCompleted) {
            this_.completeWith(f.result);
            return true;
          }
        }
        return false;
      default:
        return true;
    }
  } while (false);
}

class TimeoutSMValue extends AsyncStateMachine<String> {
  late int taskDelay;
  late int timeoutDelay;
  late dynamic _taskFuture;
  late dynamic _timeoutFuture;

  TimeoutSMValue() {
    vptr['step'] = TimeoutSM_step;
  }

  @override
  void gcMark(int flag) {
    super.gcMark(flag);
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
        this_._taskFuture = delayed(this_.taskDelay, ClosureEnv_global_8_new(GC.allocateLocal(ClosureEnv_global_8())));
        this_._timeoutFuture = delayed(this_.timeoutDelay, ClosureEnv_global_9_new(GC.allocateLocal(ClosureEnv_global_9())));
        this_.smState = 1;
        return false;
      case 1:
        if (this_._taskFuture.isCompleted) {
          this_.completeWith(this_._taskFuture.result);
          return true;
        }
        if (this_._timeoutFuture.isCompleted) {
          this_.completeWith(this_._timeoutFuture.result);
          return true;
        }
        return false;
      default:
        return true;
    }
  } while (false);
}

class AsyncMapSMValue extends AsyncStateMachine<StaticList<String>> {
  late StaticList<int> items;
  late StaticList<String> _results;
  late int _index;
  late dynamic _pending;

  AsyncMapSMValue() {
    vptr['step'] = AsyncMapSM_step;
  }

  @override
  void gcMark(int flag) {
    super.gcMark(flag);
    items?.gcMark(flag);
    _results?.gcMark(flag);
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
        if ((this_._index >= this_.items.length)) {
          this_.completeWith(this_._results);
          return true;
        }
        int item = this_.items[this_._index];
        this_._pending = delayed(1, ClosureEnv_global_10_new(GC.allocateLocal(ClosureEnv_global_10()), item));
        this_.smState = 1;
        return false;
      case 1:
        if (this_._pending!.isPending) {
          return false;
        }
        this_._results.add(this_._pending!.result);
        this_._index = (this_._index + 1);
        this_.smState = 0;
        return false;
      default:
        return true;
    }
  } while (false);
}

class AsyncReduceSMValue extends AsyncStateMachine<String> {
  late dynamic _mapFuture;
  late dynamic _reducePending;
  late StaticList<String> _items;
  late int _index;
  late String _acc;

  AsyncReduceSMValue() {
    vptr['step'] = AsyncReduceSM_step;
  }

  @override
  void gcMark(int flag) {
    super.gcMark(flag);
    _items?.gcMark(flag);
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
        this_._mapFuture = AsyncMapSM_new(AsyncMapSMValue(), StaticList<int>.of([1, 2, 3, 4])).start();
        this_.smState = 1;
        return false;
      case 1:
        if (this_._mapFuture.isPending) {
          return false;
        }
        this_._items = this_._mapFuture.result;
        this_.smState = 2;
        return false;
      case 2:
        if ((this_._index >= this_._items.length)) {
          this_.completeWith(this_._acc);
          return true;
        }
        this_._reducePending = delayed(1, ClosureEnv_global_11_new(GC.allocateLocal(ClosureEnv_global_11()), this_));
        this_.smState = 3;
        return false;
      case 3:
        if (this_._reducePending!.isPending) {
          return false;
        }
        this_._acc = this_._reducePending!.result;
        this_._index = (this_._index + 1);
        this_.smState = 2;
        return false;
      default:
        return true;
    }
  } while (false);
}

class ClosureEnv_process_0Value extends VPtr {
  late int factor;

  ClosureEnv_process_0Value() {
    vptr['call'] = ClosureEnv_process_0_call;
  }

  @override
  void gcMark(int flag) {
    super.gcMark(flag);
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
  late StaticList<int> _results;
  late int _index;
  late dynamic _pending;

  ProcessWithClosureSMValue() {
    vptr['step'] = ProcessWithClosureSM_step;
  }

  @override
  void gcMark(int flag) {
    super.gcMark(flag);
    _env?.gcMark(flag);
    items?.gcMark(flag);
    _results?.gcMark(flag);
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
        this_._env = ClosureEnv_process_0_new(ClosureEnv_process_0Value(), 3);
        this_.smState = 1;
        return false;
      case 1:
        if ((this_._index >= this_.items.length)) {
          this_.smState = 3;
          return false;
        }
        int item = this_.items[this_._index];
        this_._pending = delayed(1, ClosureEnv_global_12_new(GC.allocateLocal(ClosureEnv_global_12()), this_, item));
        this_.smState = 2;
        return false;
      case 2:
        if (this_._pending!.isPending) {
          return false;
        }
        this_._results.add(this_._pending!.result);
        this_._index = (this_._index + 1);
        this_.smState = 1;
        return false;
      case 3:
        this_._env.factor = 5;
        this_._results.add((this_._env.vptr['call'] as Function)(this_._env, 100));
        this_.completeWith(this_._results);
        return true;
      default:
        return true;
    }
  } while (false);
}

class AsyncGeneratorSMValue extends AsyncStateMachine<StaticList<int>> {
  late int max;
  late int _i;
  late StaticList<int> _yielded;
  late dynamic _pending;

  AsyncGeneratorSMValue() {
    vptr['step'] = AsyncGeneratorSM_step;
  }

  @override
  void gcMark(int flag) {
    super.gcMark(flag);
    _yielded?.gcMark(flag);
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
        if ((this_._i >= this_.max)) {
          this_.completeWith(this_._yielded);
          return true;
        }
        this_._pending = delayed(1, ClosureEnv_global_13_new(GC.allocateLocal(ClosureEnv_global_13()), this_));
        this_.smState = 1;
        return false;
      case 1:
        if (this_._pending!.isPending) {
          return false;
        }
        this_._yielded.add(this_._pending!.result);
        this_._i = (this_._i + 1);
        this_.smState = 0;
        return false;
      default:
        return true;
    }
  } while (false);
}

class ComplexBusinessSMValue extends AsyncStateMachine<StaticMap<String, dynamic>> {
  late int depth;
  late dynamic _pending;

  ComplexBusinessSMValue() {
    vptr['step'] = ComplexBusinessSM_step;
  }

  @override
  void gcMark(int flag) {
    super.gcMark(flag);
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
        if ((this_.depth <= 0)) {
          this_.completeWithError(('max depth'));
          return true;
        }
        this_._pending = ComplexBusinessSM_new(ComplexBusinessSMValue(), (this_.depth - 1)).start();
        this_.smState = 1;
        return false;
      case 1:
        if (this_._pending!.isPending) {
          return false;
        }
        if (this_._pending!.isError) {
          this_.completeWith(StaticMap<String, dynamic>.of({'depth': this_.depth, 'error': '${this_._pending!.error}'}));
          return true;
        }
        this_.completeWith(StaticMap<String, dynamic>.of({'depth': this_.depth, 'child': this_._pending!.result}));
        return true;
      default:
        return true;
    }
  } while (false);
}

void testRecursiveAsync() {
  staticPrint('\n--- 1. 递归异步 fibonacci ---');
  GlobalScheduler.instance.reset();
  dynamic r = smAwait(FibStateMachine_new(FibStateMachineValue(), 7).start());
  assert((r == 13), 'fib(7) should be 13, got ${r}');
  staticPrint('  ✓ asyncFib(7) = ${r}');
}

void testExceptionPropagation() {
  staticPrint('\n--- 2. 异常传播链 (3层) ---');
  GlobalScheduler.instance.reset();
  dynamic r = smAwait(Level1SM_new(Level1SMValue()).start());
  assert((r.contains('deep error') as bool), 'Expected deep error, got: ${r}');
  staticPrint('  ✓ level1() caught 3-level exception: "${r}"');
}

void testConditionalAwait() {
  staticPrint('\n--- 3. 条件分支中的 await ---');
  GlobalScheduler.instance.reset();
  dynamic r1 = smAwait(ConditionalAwaitSM_new(ConditionalAwaitSMValue(), true).start());
  assert((r1 == 'branch_true'), 'Expected branch_true, got ${r1}');
  GlobalScheduler.instance.reset();
  dynamic r2 = smAwait(ConditionalAwaitSM_new(ConditionalAwaitSMValue(), false).start());
  assert((r2 == 'branch_false'), 'Expected branch_false, got ${r2}');
  staticPrint('  ✓ conditionalAwait(true) = "${r1}"');
  staticPrint('  ✓ conditionalAwait(false) = "${r2}"');
}

void testLoopBreakAwait() {
  staticPrint('\n--- 4. 循环 + 提前 break 中的 await ---');
  GlobalScheduler.instance.reset();
  dynamic r = smAwait(FindFirstSM_new(FindFirstSMValue(), StaticList<int>.of([1, 2, 3, 4, 5])).start());
  assert((r == 12), 'Expected 12, got ${r}');
  staticPrint('  ✓ findFirst([1,2,3,4,5]) = ${r} (4*3=12 > 10)');
}

void testTryCatchAwait() {
  staticPrint('\n--- 5. try-catch 中的 await ---');
  GlobalScheduler.instance.reset();
  dynamic r = smAwait(TryCatchSM_new(TryCatchSMValue()).start());
  assert((r == 'try;catch:boom;recovered'), 'Unexpected: ${r}');
  staticPrint('  ✓ tryCatchAwait() = "${r}"');
}

void testFutureAny() {
  staticPrint('\n--- 6. Future.any 模拟（竞争取最先完成） ---');
  GlobalScheduler.instance.reset();
  dynamic r = smAwait(FutureAnySM_new(FutureAnySMValue()).start());
  assert((r == 'fast'), 'Expected fast, got ${r}');
  staticPrint('  ✓ Future.any([slow(5), fast(2), slowest(8)]) = "${r}"');
}

void testTimeout() {
  staticPrint('\n--- 7. 超时控制模拟 ---');
  GlobalScheduler.instance.reset();
  dynamic r1 = smAwait(TimeoutSM_new(TimeoutSMValue()).start());
  assert((r1 == 'done'), 'Expected done, got ${r1}');
  staticPrint('  ✓ task(2) timeout(5) = "${r1}" (task wins)');
  GlobalScheduler.instance.reset();
  dynamic r2 = smAwait(TimeoutSM_new(TimeoutSMValue()).start());
  assert((r2 == 'TIMEOUT'), 'Expected TIMEOUT, got ${r2}');
  staticPrint('  ✓ task(10) timeout(3) = "${r2}" (timeout wins)');
}

void testAsyncPipeline() {
  staticPrint('\n--- 8. 链式异步变换管道 (map → reduce) ---');
  GlobalScheduler.instance.reset();
  dynamic r = smAwait(AsyncReduceSM_new(AsyncReduceSMValue()).start());
  assert((r == 'item_2+item_4+item_6+item_8'), 'Unexpected: ${r}');
  staticPrint('  ✓ asyncMap([1,2,3,4]).reduce(+) = "${r}"');
}

void testClosureCaptureAwait() {
  staticPrint('\n--- 9. 闭包捕获 + await (ClosureEnv 模式) ---');
  GlobalScheduler.instance.reset();
  dynamic r = smAwait(ProcessWithClosureSM_new(ProcessWithClosureSMValue(), StaticList<int>.of([1, 2, 3])).start());
  assert((r.length == 4), 'Expected 4 results');
  assert((r.[](0) == 3) && (r.[](1) == 6) && (r.[](2) == 9) && (r.[](3) == 500), 'Unexpected: ${r}');
  staticPrint('  ✓ processWithClosure([1,2,3]) = ${r}');
  staticPrint('    (factor=3→[3,6,9], mutate factor=5→100*5=500)');
}

void testAsyncGenerator() {
  staticPrint('\n--- 10. async* 生成器模拟 ---');
  GlobalScheduler.instance.reset();
  dynamic r = smAwait(AsyncGeneratorSM_new(AsyncGeneratorSMValue(), 5).start());
  assert((r.length == 5), 'Expected 5 items');
  assert((r.[](0) == 0) && (r.[](1) == 1) && (r.[](2) == 4) && (r.[](3) == 9) && (r.[](4) == 16), 'Unexpected: ${r}');
  staticPrint('  ✓ countUp(5) yields ${r}');
}

void testComplexBusiness() {
  staticPrint('\n--- 11. 复合场景：递归+异常+条件 ---');
  GlobalScheduler.instance.reset();
  dynamic r = smAwait(ComplexBusinessSM_new(ComplexBusinessSMValue(), 3).start());
  assert((r.[]('depth') == 3), 'Top level depth should be 3');
  StaticMap<String, dynamic> child2 = (r.[]('child') as StaticMap<String, dynamic>);
  assert((child2['depth'] == 2), 'Child depth should be 2');
  StaticMap<String, dynamic> child1 = (child2['child'] as StaticMap<String, dynamic>);
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

class ClosureEnv_global_0 extends TypeFunction0<String> {

  ClosureEnv_global_0() {
  }
  String call() =>
      ClosureEnv_global_0_call(this);
}

String ClosureEnv_global_0_call(dynamic env__) {
  final env = env__ as ClosureEnv_global_0;
  return 'branch_true';
}

ClosureEnv_global_0 ClosureEnv_global_0_new(ClosureEnv_global_0 env_) {
  return env_;
}

class ClosureEnv_global_1 extends TypeFunction0<String> {

  ClosureEnv_global_1() {
  }
  String call() =>
      ClosureEnv_global_1_call(this);
}

String ClosureEnv_global_1_call(dynamic env__) {
  final env = env__ as ClosureEnv_global_1;
  return 'branch_false';
}

ClosureEnv_global_1 ClosureEnv_global_1_new(ClosureEnv_global_1 env_) {
  return env_;
}

class ClosureEnv_global_2 extends TypeFunction0<int> {
  late FindFirstSMValue this_;

  ClosureEnv_global_2() {
  }
  int call() =>
      ClosureEnv_global_2_call(this);

  @override
  void gcMark(int flag) {
    super.gcMark(flag);
    this_?.gcMark(flag);
  }
}

int ClosureEnv_global_2_call(dynamic env__) {
  final env = env__ as ClosureEnv_global_2;
  return (env.this_.items[env.this_._index] * 3);
}

ClosureEnv_global_2 ClosureEnv_global_2_new(ClosureEnv_global_2 env_, FindFirstSMValue this_) {
  env_.this_ = this_;
  return env_;
}

class ClosureEnv_global_3 extends TypeFunction0<void> {

  ClosureEnv_global_3() {
  }
  void call() =>
      ClosureEnv_global_3_call(this);
}

void ClosureEnv_global_3_call(dynamic env__) {
  final env = env__ as ClosureEnv_global_3;
  throw 'boom';
  return;
}

ClosureEnv_global_3 ClosureEnv_global_3_new(ClosureEnv_global_3 env_) {
  return env_;
}

class ClosureEnv_global_4 extends TypeFunction0<String> {

  ClosureEnv_global_4() {
  }
  String call() =>
      ClosureEnv_global_4_call(this);
}

String ClosureEnv_global_4_call(dynamic env__) {
  final env = env__ as ClosureEnv_global_4;
  return 'recovered';
}

ClosureEnv_global_4 ClosureEnv_global_4_new(ClosureEnv_global_4 env_) {
  return env_;
}

class ClosureEnv_global_5 extends TypeFunction0<String> {

  ClosureEnv_global_5() {
  }
  String call() =>
      ClosureEnv_global_5_call(this);
}

String ClosureEnv_global_5_call(dynamic env__) {
  final env = env__ as ClosureEnv_global_5;
  return 'slow';
}

ClosureEnv_global_5 ClosureEnv_global_5_new(ClosureEnv_global_5 env_) {
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
  return 'fast';
}

ClosureEnv_global_6 ClosureEnv_global_6_new(ClosureEnv_global_6 env_) {
  return env_;
}

class ClosureEnv_global_7 extends TypeFunction0<String> {

  ClosureEnv_global_7() {
  }
  String call() =>
      ClosureEnv_global_7_call(this);
}

String ClosureEnv_global_7_call(dynamic env__) {
  final env = env__ as ClosureEnv_global_7;
  return 'slowest';
}

ClosureEnv_global_7 ClosureEnv_global_7_new(ClosureEnv_global_7 env_) {
  return env_;
}

class ClosureEnv_global_8 extends TypeFunction0<String> {

  ClosureEnv_global_8() {
  }
  String call() =>
      ClosureEnv_global_8_call(this);
}

String ClosureEnv_global_8_call(dynamic env__) {
  final env = env__ as ClosureEnv_global_8;
  return 'done';
}

ClosureEnv_global_8 ClosureEnv_global_8_new(ClosureEnv_global_8 env_) {
  return env_;
}

class ClosureEnv_global_9 extends TypeFunction0<String> {

  ClosureEnv_global_9() {
  }
  String call() =>
      ClosureEnv_global_9_call(this);
}

String ClosureEnv_global_9_call(dynamic env__) {
  final env = env__ as ClosureEnv_global_9;
  return 'TIMEOUT';
}

ClosureEnv_global_9 ClosureEnv_global_9_new(ClosureEnv_global_9 env_) {
  return env_;
}

class ClosureEnv_global_10 extends TypeFunction0<String> {
  late int item;

  ClosureEnv_global_10() {
  }
  String call() =>
      ClosureEnv_global_10_call(this);

  @override
  void gcMark(int flag) {
    super.gcMark(flag);
  }
}

String ClosureEnv_global_10_call(dynamic env__) {
  final env = env__ as ClosureEnv_global_10;
  return 'item_${(env.item * 2)}';
}

ClosureEnv_global_10 ClosureEnv_global_10_new(ClosureEnv_global_10 env_, int item) {
  env_.item = item;
  return env_;
}

class ClosureEnv_global_11 extends TypeFunction0<String> {
  late AsyncReduceSMValue this_;

  ClosureEnv_global_11() {
  }
  String call() =>
      ClosureEnv_global_11_call(this);

  @override
  void gcMark(int flag) {
    super.gcMark(flag);
    this_?.gcMark(flag);
  }
}

String ClosureEnv_global_11_call(dynamic env__) {
  final env = env__ as ClosureEnv_global_11;
  String sep = (env.this_._acc.isEmpty ? '' : '+');
  return '${env.this_._acc}${sep}${env.this_._items[env.this_._index]}';
}

ClosureEnv_global_11 ClosureEnv_global_11_new(ClosureEnv_global_11 env_, AsyncReduceSMValue this_) {
  env_.this_ = this_;
  return env_;
}

class ClosureEnv_global_12 extends TypeFunction0<int> {
  late ProcessWithClosureSMValue this_;
  late int item;

  ClosureEnv_global_12() {
  }
  int call() =>
      ClosureEnv_global_12_call(this);

  @override
  void gcMark(int flag) {
    super.gcMark(flag);
    this_?.gcMark(flag);
  }
}

int ClosureEnv_global_12_call(dynamic env__) {
  final env = env__ as ClosureEnv_global_12;
  return (env.this_._env.vptr['call'] as Function)(env.this_._env, env.item);
}

ClosureEnv_global_12 ClosureEnv_global_12_new(ClosureEnv_global_12 env_, ProcessWithClosureSMValue this_, int item) {
  env_.this_ = this_;
  env_.item = item;
  return env_;
}

class ClosureEnv_global_13 extends TypeFunction0<int> {
  late AsyncGeneratorSMValue this_;

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
  return (env.this_._i * env.this_._i);
}

ClosureEnv_global_13 ClosureEnv_global_13_new(ClosureEnv_global_13 env_, AsyncGeneratorSMValue this_) {
  env_.this_ = this_;
  return env_;
}

