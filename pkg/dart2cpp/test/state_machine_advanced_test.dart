/// 复杂协程场景验证测试
///
/// 覆盖场景：
/// 1. 递归异步调用（fibonacci async）
/// 2. 异常传播链（多层 async 调用中抛异常）
/// 3. 条件分支中的 await
/// 4. 循环 + 提前 break 中的 await
/// 5. try-catch 中的 await
/// 6. 多个 Future 竞争（Future.any 模拟）
/// 7. 超时控制模拟
/// 8. 链式异步变换管道
/// 9. 闭包捕获 + await（模拟 restorer 闭包环境类）
/// 10. async 生成器模拟（yield 模拟）
import 'package:dart2cpp/restorer/runtime_classes.dart';

// ============================================================================
// 场景 1: 递归异步 — async fibonacci
// ============================================================================

/// 模拟:
/// Future<int> asyncFib(int n) async {
///   if (n <= 1) return n;
///   var a = await asyncFib(n - 1);
///   var b = await asyncFib(n - 2);
///   return a + b;
/// }
class FibStateMachine extends AsyncStateMachine<int> {
  final int n;
  int _a = 0;
  Promise<int>? _pending;

  FibStateMachine(this.n);

  @override
  bool step() {
    switch (smState) {
      case 0:
        if (n <= 1) { completeWith(n); return true; }
        _pending = FibStateMachine(n - 1).start();
        smState = 1;
        return false;
      case 1:
        if (_pending!.isPending) return false;
        _a = _pending!.result;
        _pending = FibStateMachine(n - 2).start();
        smState = 2;
        return false;
      case 2:
        if (_pending!.isPending) return false;
        completeWith(_a + _pending!.result);
        return true;
      default:
        return true;
    }
  }
}

void testRecursiveAsync() {
  print('\n--- 1. 递归异步 fibonacci ---');
  GlobalScheduler.instance.reset();
  final r = smAwait(FibStateMachine(7).start());
  assert(r == 13, 'fib(7) should be 13, got $r');
  print('  ✓ asyncFib(7) = $r');
}

// ============================================================================
// 场景 2: 异常传播链
// ============================================================================

/// 模拟:
/// Future<int> level3() async { throw Exception('deep error'); }
/// Future<int> level2() async { return await level3(); }
/// Future<String> level1() async {
///   try { await level2(); return 'ok'; }
///   catch (e) { return 'caught: $e'; }
/// }
class Level3SM extends AsyncStateMachine<int> {
  @override
  bool step() {
    completeWithError(Exception('deep error'));
    return true;
  }
}

class Level2SM extends AsyncStateMachine<int> {
  Promise<int>? _pending;
  @override
  bool step() {
    switch (smState) {
      case 0:
        _pending = Level3SM().start();
        smState = 1;
        return false;
      case 1:
        if (_pending!.isPending) return false;
        if (_pending!.isError) { completeWithError(_pending!.error!); return true; }
        completeWith(_pending!.result);
        return true;
      default:
        return true;
    }
  }
}

class Level1SM extends AsyncStateMachine<String> {
  Promise<int>? _pending;
  @override
  bool step() {
    switch (smState) {
      case 0:
        _pending = Level2SM().start();
        smState = 1;
        return false;
      case 1:
        if (_pending!.isPending) return false;
        if (_pending!.isError) {
          completeWith('caught: ${_pending!.error}');
          return true;
        }
        completeWith('ok');
        return true;
      default:
        return true;
    }
  }
}

void testExceptionPropagation() {
  print('\n--- 2. 异常传播链 (3层) ---');
  GlobalScheduler.instance.reset();
  final r = smAwait(Level1SM().start());
  assert(r.contains('deep error'), 'Expected deep error, got: $r');
  print('  ✓ level1() caught 3-level exception: "$r"');
}

// ============================================================================
// 场景 3: 条件分支中的 await
// ============================================================================

/// 模拟:
/// Future<String> conditionalAwait(bool flag) async {
///   if (flag) {
///     var x = await Future.delayed(2, () => 'branch_true');
///     return x;
///   } else {
///     var y = await Future.delayed(1, () => 'branch_false');
///     return y;
///   }
/// }
class ConditionalAwaitSM extends AsyncStateMachine<String> {
  final bool flag;
  Promise<String>? _pending;

  ConditionalAwaitSM(this.flag);

  @override
  bool step() {
    switch (smState) {
      case 0:
        if (flag) {
          _pending = Promise.delayed<String>(2, () => 'branch_true');
          smState = 1;
        } else {
          _pending = Promise.delayed<String>(1, () => 'branch_false');
          smState = 2;
        }
        return false;
      case 1:
        if (_pending!.isPending) return false;
        completeWith(_pending!.result);
        return true;
      case 2:
        if (_pending!.isPending) return false;
        completeWith(_pending!.result);
        return true;
      default:
        return true;
    }
  }
}

void testConditionalAwait() {
  print('\n--- 3. 条件分支中的 await ---');
  GlobalScheduler.instance.reset();
  final r1 = smAwait(ConditionalAwaitSM(true).start());
  assert(r1 == 'branch_true', 'Expected branch_true, got $r1');

  GlobalScheduler.instance.reset();
  final r2 = smAwait(ConditionalAwaitSM(false).start());
  assert(r2 == 'branch_false', 'Expected branch_false, got $r2');
  print('  ✓ conditionalAwait(true) = "$r1"');
  print('  ✓ conditionalAwait(false) = "$r2"');
}

// ============================================================================
// 场景 4: 循环 + 提前 break 中的 await
// ============================================================================

/// 模拟:
/// Future<int> findFirst(List<int> items) async {
///   for (var item in items) {
///     var result = await asyncCheck(item);
///     if (result > 10) return result; // 提前 return
///   }
///   return -1;
/// }
class FindFirstSM extends AsyncStateMachine<int> {
  final List<int> items;
  int _index = 0;
  Promise<int>? _pending;

  FindFirstSM(this.items);

  @override
  bool step() {
    switch (smState) {
      case 0:
        if (_index >= items.length) {
          completeWith(-1);
          return true;
        }
        _pending = Promise.delayed<int>(1, () => items[_index] * 3);
        smState = 1;
        return false;
      case 1:
        if (_pending!.isPending) return false;
        final result = _pending!.result;
        if (result > 10) {
          completeWith(result);
          return true;
        }
        _index++;
        smState = 0;
        return false;
      default:
        return true;
    }
  }
}

void testLoopBreakAwait() {
  print('\n--- 4. 循环 + 提前 break 中的 await ---');
  GlobalScheduler.instance.reset();
  final r = smAwait(FindFirstSM([1, 2, 3, 4, 5]).start());
  // 4*3=12 > 10, should return 12
  assert(r == 12, 'Expected 12, got $r');
  print('  ✓ findFirst([1,2,3,4,5]) = $r (4*3=12 > 10)');
}

// ============================================================================
// 场景 5: try-catch 中的 await + finally 语义
// ============================================================================

/// 模拟:
/// Future<String> tryCatchAwait() async {
///   String log = '';
///   try {
///     log += 'try;';
///     await Future.delayed(1, () => throw 'boom');
///   } catch (e) {
///     log += 'catch:$e;';
///     var recovery = await Future.delayed(1, () => 'recovered');
///     log += recovery;
///   }
///   return log;
/// }
class TryCatchSM extends AsyncStateMachine<String> {
  String _log = '';
  Promise<dynamic>? _pending;

  @override
  bool step() {
    switch (smState) {
      case 0:
        _log += 'try;';
        _pending = Promise.delayed<String>(1, () => throw 'boom');
        smState = 1;
        return false;
      case 1:
        if (_pending!.isPending) return false;
        if (_pending!.isError) {
          _log += 'catch:${_pending!.error};';
          _pending = Promise.delayed<String>(1, () => 'recovered');
          smState = 2;
          return false;
        }
        completeWith(_log);
        return true;
      case 2:
        if (_pending!.isPending) return false;
        _log += (_pending!.result as String);
        completeWith(_log);
        return true;
      default:
        return true;
    }
  }
}

void testTryCatchAwait() {
  print('\n--- 5. try-catch 中的 await ---');
  GlobalScheduler.instance.reset();
  final r = smAwait(TryCatchSM().start());
  assert(r == 'try;catch:boom;recovered', 'Unexpected: $r');
  print('  ✓ tryCatchAwait() = "$r"');
}

// ============================================================================
// 场景 6: Future.any 模拟（多个竞争，取最先完成的）
// ============================================================================

class FutureAnySM extends AsyncStateMachine<String> {
  late List<Promise<String>> _futures;

  @override
  bool step() {
    switch (smState) {
      case 0:
        _futures = [
          Promise.delayed<String>(5, () => 'slow'),
          Promise.delayed<String>(2, () => 'fast'),
          Promise.delayed<String>(8, () => 'slowest'),
        ];
        smState = 1;
        return false;
      case 1:
        // 找到第一个完成的
        for (final f in _futures) {
          if (f.isCompleted) {
            completeWith(f.result);
            return true;
          }
        }
        return false;
      default:
        return true;
    }
  }
}

void testFutureAny() {
  print('\n--- 6. Future.any 模拟（竞争取最先完成） ---');
  GlobalScheduler.instance.reset();
  final r = smAwait(FutureAnySM().start());
  assert(r == 'fast', 'Expected fast, got $r');
  print('  ✓ Future.any([slow(5), fast(2), slowest(8)]) = "$r"');
}

// ============================================================================
// 场景 7: 超时控制模拟
// ============================================================================

class TimeoutSM extends AsyncStateMachine<String> {
  final int taskDelay;
  final int timeoutDelay;
  late Promise<String> _taskFuture;
  late Promise<String> _timeoutFuture;

  TimeoutSM({required this.taskDelay, required this.timeoutDelay});

  @override
  bool step() {
    switch (smState) {
      case 0:
        _taskFuture = Promise.delayed<String>(taskDelay, () => 'done');
        _timeoutFuture = Promise.delayed<String>(timeoutDelay, () => 'TIMEOUT');
        smState = 1;
        return false;
      case 1:
        if (_taskFuture.isCompleted) {
          completeWith(_taskFuture.result);
          return true;
        }
        if (_timeoutFuture.isCompleted) {
          completeWith(_timeoutFuture.result);
          return true;
        }
        return false;
      default:
        return true;
    }
  }
}

void testTimeout() {
  print('\n--- 7. 超时控制模拟 ---');
  GlobalScheduler.instance.reset();
  final r1 = smAwait(TimeoutSM(taskDelay: 2, timeoutDelay: 5).start());
  assert(r1 == 'done', 'Expected done, got $r1');
  print('  ✓ task(2) timeout(5) = "$r1" (task wins)');

  GlobalScheduler.instance.reset();
  final r2 = smAwait(TimeoutSM(taskDelay: 10, timeoutDelay: 3).start());
  assert(r2 == 'TIMEOUT', 'Expected TIMEOUT, got $r2');
  print('  ✓ task(10) timeout(3) = "$r2" (timeout wins)');
}

// ============================================================================
// 场景 8: 链式异步变换管道 — map/filter/reduce 风格
// ============================================================================

/// 模拟异步 map: 对列表每个元素异步变换
class AsyncMapSM extends AsyncStateMachine<List<String>> {
  final List<int> items;
  final List<String> _results = [];
  int _index = 0;
  Promise<String>? _pending;

  AsyncMapSM(this.items);

  @override
  bool step() {
    switch (smState) {
      case 0:
        if (_index >= items.length) {
          completeWith(_results);
          return true;
        }
        final item = items[_index];
        _pending = Promise.delayed<String>(1, () => 'item_${item * 2}');
        smState = 1;
        return false;
      case 1:
        if (_pending!.isPending) return false;
        _results.add(_pending!.result);
        _index++;
        smState = 0;
        return false;
      default:
        return true;
    }
  }
}

/// 模拟异步 reduce
class AsyncReduceSM extends AsyncStateMachine<String> {
  late Promise<List<String>> _mapFuture;
  Promise<String>? _reducePending;
  List<String> _items = [];
  int _index = 0;
  String _acc = '';

  @override
  bool step() {
    switch (smState) {
      case 0:
        _mapFuture = AsyncMapSM([1, 2, 3, 4]).start();
        smState = 1;
        return false;
      case 1:
        if (_mapFuture.isPending) return false;
        _items = _mapFuture.result;
        smState = 2;
        return false;
      case 2:
        if (_index >= _items.length) {
          completeWith(_acc);
          return true;
        }
        _reducePending = Promise.delayed<String>(1, () {
          final sep = _acc.isEmpty ? '' : '+';
          return '$_acc$sep${_items[_index]}';
        });
        smState = 3;
        return false;
      case 3:
        if (_reducePending!.isPending) return false;
        _acc = _reducePending!.result;
        _index++;
        smState = 2;
        return false;
      default:
        return true;
    }
  }
}

void testAsyncPipeline() {
  print('\n--- 8. 链式异步变换管道 (map → reduce) ---');
  GlobalScheduler.instance.reset();
  final r = smAwait(AsyncReduceSM().start());
  assert(r == 'item_2+item_4+item_6+item_8', 'Unexpected: $r');
  print('  ✓ asyncMap([1,2,3,4]).reduce(+) = "$r"');
}

// ============================================================================
// 场景 9: 闭包捕获 + await（模拟 restorer ClosureEnv 模式）
// ============================================================================

/// 模拟 restorer 输出的闭包环境类模式：
/// class ClosureEnv_process_0 { int factor; ... }
/// Future<List<int>> processWithClosure(List<int> items) async {
///   int factor = 3;
///   var transformer = (int x) => x * factor;  // closure captures factor
///   var results = <int>[];
///   for (var item in items) {
///     var processed = await asyncApply(item, transformer);
///     results.add(processed);
///   }
///   factor = 5; // mutation after closure creation
///   results.add(transformer(100)); // should use current factor=5
///   return results;
/// }
class ClosureEnv_process_0 {
  int factor;
  ClosureEnv_process_0(this.factor);
  int call(int x) => x * factor;
}

class ProcessWithClosureSM extends AsyncStateMachine<List<int>> {
  late ClosureEnv_process_0 _env;
  final List<int> items;
  final List<int> _results = [];
  int _index = 0;
  Promise<int>? _pending;

  ProcessWithClosureSM(this.items);

  @override
  bool step() {
    switch (smState) {
      case 0:
        _env = ClosureEnv_process_0(3);
        smState = 1;
        return false;
      case 1:
        if (_index >= items.length) {
          smState = 3;
          return false;
        }
        final item = items[_index];
        // 模拟 asyncApply: await delayed(() => transformer(item))
        _pending = Promise.delayed<int>(1, () => _env.call(item));
        smState = 2;
        return false;
      case 2:
        if (_pending!.isPending) return false;
        _results.add(_pending!.result);
        _index++;
        smState = 1;
        return false;
      case 3:
        // factor mutation after closure
        _env.factor = 5;
        _results.add(_env.call(100)); // 100*5=500
        completeWith(_results);
        return true;
      default:
        return true;
    }
  }
}

void testClosureCaptureAwait() {
  print('\n--- 9. 闭包捕获 + await (ClosureEnv 模式) ---');
  GlobalScheduler.instance.reset();
  final r = smAwait(ProcessWithClosureSM([1, 2, 3]).start());
  // items * factor(3) = [3, 6, 9], then factor=5, 100*5=500
  assert(r.length == 4, 'Expected 4 results');
  assert(r[0] == 3 && r[1] == 6 && r[2] == 9 && r[3] == 500,
      'Unexpected: $r');
  print('  ✓ processWithClosure([1,2,3]) = $r');
  print('    (factor=3→[3,6,9], mutate factor=5→100*5=500)');
}

// ============================================================================
// 场景 10: async 生成器模拟（yield 模拟 via callback）
// ============================================================================

/// 模拟 async* generator:
/// Stream<int> countUp(int max) async* {
///   for (int i = 0; i < max; i++) {
///     await Future.delayed(1);
///     yield i * i;
///   }
/// }
/// 用回调收集 yield 的值
class AsyncGeneratorSM extends AsyncStateMachine<List<int>> {
  final int max;
  int _i = 0;
  final List<int> _yielded = [];
  Promise<int>? _pending;

  AsyncGeneratorSM(this.max);

  @override
  bool step() {
    switch (smState) {
      case 0:
        if (_i >= max) {
          completeWith(_yielded);
          return true;
        }
        _pending = Promise.delayed<int>(1, () => _i * _i);
        smState = 1;
        return false;
      case 1:
        if (_pending!.isPending) return false;
        _yielded.add(_pending!.result); // yield
        _i++;
        smState = 0;
        return false;
      default:
        return true;
    }
  }
}

void testAsyncGenerator() {
  print('\n--- 10. async* 生成器模拟 ---');
  GlobalScheduler.instance.reset();
  final r = smAwait(AsyncGeneratorSM(5).start());
  // 0,1,4,9,16
  assert(r.length == 5, 'Expected 5 items');
  assert(r[0] == 0 && r[1] == 1 && r[2] == 4 && r[3] == 9 && r[4] == 16,
      'Unexpected: $r');
  print('  ✓ countUp(5) yields $r');
}

// ============================================================================
// 场景 11: 复合——异步递归 + 异常 + 条件 + 闭包
// ============================================================================

/// 模拟复杂业务逻辑:
/// Future<Map<String, dynamic>> complexBusiness(int depth) async {
///   if (depth <= 0) throw Exception('max depth');
///   try {
///     var childResult = await complexBusiness(depth - 1);
///     return {'depth': depth, 'child': childResult};
///   } catch (e) {
///     return {'depth': depth, 'error': '$e'};
///   }
/// }
class ComplexBusinessSM extends AsyncStateMachine<Map<String, dynamic>> {
  final int depth;
  Promise<Map<String, dynamic>>? _pending;

  ComplexBusinessSM(this.depth);

  @override
  bool step() {
    switch (smState) {
      case 0:
        if (depth <= 0) {
          completeWithError(Exception('max depth'));
          return true;
        }
        _pending = ComplexBusinessSM(depth - 1).start();
        smState = 1;
        return false;
      case 1:
        if (_pending!.isPending) return false;
        if (_pending!.isError) {
          completeWith({'depth': depth, 'error': '${_pending!.error}'});
          return true;
        }
        completeWith({'depth': depth, 'child': _pending!.result});
        return true;
      default:
        return true;
    }
  }
}

void testComplexBusiness() {
  print('\n--- 11. 复合场景：递归+异常+条件 ---');
  GlobalScheduler.instance.reset();
  final r = smAwait(ComplexBusinessSM(3).start());
  // depth=3 → try depth=2 → try depth=1 → try depth=0 → throws
  // depth=1 catches → {depth:1, error:...}
  // depth=2 gets child → {depth:2, child:{depth:1, error:...}}
  // depth=3 gets child → {depth:3, child:{depth:2, child:{depth:1, error:...}}}
  assert(r['depth'] == 3, 'Top level depth should be 3');
  final child2 = r['child'] as Map<String, dynamic>;
  assert(child2['depth'] == 2, 'Child depth should be 2');
  final child1 = child2['child'] as Map<String, dynamic>;
  assert(child1['depth'] == 1, 'Deepest depth should be 1');
  assert((child1['error'] as String).contains('max depth'), 'Should contain error');
  print('  ✓ complexBusiness(3) = nested map with error at bottom');
  print('    depth=3 → child(depth=2) → child(depth=1, error:"max depth")');
}

// ============================================================================
// main
// ============================================================================

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
