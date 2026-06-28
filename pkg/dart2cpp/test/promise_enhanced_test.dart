/// Promise 增强功能测试
/// 验证：catchError、whenComplete、then flatMap、promiseDelayed Duration 映射、smAwait 递归深度保护
import 'package:dart2cpp/platform/dart/runtime_classes.dart';

void main() {
  print('═══════════════════════════════════════════');
  print(' Promise 增强功能测试');
  print('═══════════════════════════════════════════');

  testCatchError();
  testCatchErrorPassthrough();
  testWhenCompleteSuccess();
  testWhenCompleteError();
  testThenFlatMap();
  testThenFlatMapChain();
  testPromiseDelayedDuration();
  testSmAwaitDepthProtection();
  testCombinedChain();

  print('\n═══════════════════════════════════════════');
  print(' ✅ 全部 9 个增强测试通过！');
  print('═══════════════════════════════════════════');
}

// ---------------------------------------------------------------------------
// 1. catchError — 错误恢复
// ---------------------------------------------------------------------------
void testCatchError() {
  print('\n--- 1. catchError 错误恢复 ---');
  GlobalScheduler.instance.reset();

  final promise = Promise.delayed<String>(1, () {
    throw Exception('boom');
  });
  final recovered = promise.catchError((e) => 'recovered: $e');
  final result = smAwait(recovered);
  assert(result == 'recovered: Exception: boom', 'Unexpected: $result');
  print('  ✓ catchError recovered: "$result"');
}

// ---------------------------------------------------------------------------
// 2. catchError — 成功时直接透传
// ---------------------------------------------------------------------------
void testCatchErrorPassthrough() {
  print('\n--- 2. catchError 成功透传 ---');
  GlobalScheduler.instance.reset();

  final promise = Promise.value<int>(42);
  final chained = promise.catchError((e) => -1);
  final result = smAwait(chained);
  assert(result == 42, 'Expected 42, got $result');
  print('  ✓ catchError passthrough: $result');
}

// ---------------------------------------------------------------------------
// 3. whenComplete — 成功时执行 action
// ---------------------------------------------------------------------------
void testWhenCompleteSuccess() {
  print('\n--- 3. whenComplete 成功 ---');
  GlobalScheduler.instance.reset();

  bool actionCalled = false;
  final promise = Promise.value<String>('hello');
  final chained = promise.whenComplete(() { actionCalled = true; });
  final result = smAwait(chained);
  assert(result == 'hello', 'Unexpected: $result');
  assert(actionCalled, 'action not called');
  print('  ✓ whenComplete(success): "$result", actionCalled=$actionCalled');
}

// ---------------------------------------------------------------------------
// 4. whenComplete — 错误时执行 action 并传递错误
// ---------------------------------------------------------------------------
void testWhenCompleteError() {
  print('\n--- 4. whenComplete 错误 ---');
  GlobalScheduler.instance.reset();

  bool actionCalled = false;
  final promise = Promise.delayed<String>(1, () { throw Exception('fail'); });
  final chained = promise.whenComplete(() { actionCalled = true; });

  String? caughtError;
  try {
    smAwait(chained);
  } catch (e) {
    caughtError = e.toString();
  }
  assert(actionCalled, 'action not called on error');
  assert(caughtError != null && caughtError!.contains('fail'), 'Error not propagated');
  print('  ✓ whenComplete(error): actionCalled=$actionCalled, error="$caughtError"');
}

// ---------------------------------------------------------------------------
// 5. then flatMap — onValue 返回 Promise 时自动展平
// ---------------------------------------------------------------------------
void testThenFlatMap() {
  print('\n--- 5. then flatMap ---');
  GlobalScheduler.instance.reset();

  final promise = Promise.value<int>(5);
  final chained = promise.then<String>((v) {
    // 返回一个 Promise<String>，应被 flatMap 展平
    return Promise.delayed<String>(2, () => 'value=${v * 2}');
  });
  final result = smAwait(chained);
  assert(result == 'value=10', 'Expected "value=10", got "$result"');
  print('  ✓ then flatMap: "$result"');
}

// ---------------------------------------------------------------------------
// 6. then flatMap 链式
// ---------------------------------------------------------------------------
void testThenFlatMapChain() {
  print('\n--- 6. then flatMap 链式 ---');
  GlobalScheduler.instance.reset();

  final result = smAwait(
    Promise.value<int>(1)
      .then<int>((v) => Promise.delayed<int>(1, () => v + 1))
      .then<int>((v) => Promise.delayed<int>(1, () => v * 3))
      .then<String>((v) => 'final=$v'),
  );
  assert(result == 'final=6', 'Expected "final=6", got "$result"');
  print('  ✓ then flatMap chain: "$result"');
}

// ---------------------------------------------------------------------------
// 7. promiseDelayed Duration 映射
// ---------------------------------------------------------------------------
void testPromiseDelayedDuration() {
  print('\n--- 7. promiseDelayed Duration 映射 ---');
  GlobalScheduler.instance.reset();

  // 50ms → ceil(50/10) = 5 ticks
  final promise = promiseDelayed<String>(Duration(milliseconds: 50), () => 'done');
  final result = smAwait(promise);
  assert(result == 'done', 'Unexpected: $result');
  // 验证至少用了 5 ticks
  assert(GlobalScheduler.instance.currentTick >= 5,
      'Expected >= 5 ticks, got ${GlobalScheduler.instance.currentTick}');
  print('  ✓ promiseDelayed(50ms) → ${GlobalScheduler.instance.currentTick} ticks, result="$result"');
}

// ---------------------------------------------------------------------------
// 8. smAwait 递归深度保护
// ---------------------------------------------------------------------------
void testSmAwaitDepthProtection() {
  print('\n--- 8. smAwait 递归深度保护 ---');
  GlobalScheduler.instance.reset();

  // 构造递归 async：每层嵌套调用 smAwait → tick → startCallback → smAwait ...
  // 使用 ClosureEnv 模式模拟深层递归
  Promise<int> recursiveAsync(int depth) {
    final promise = Promise<int>();
    promise.setStartCallback(() {
      if (depth <= 0) {
        promise.complete(0);
      } else {
        try {
          final inner = smAwait<int>(recursiveAsync(depth - 1));
          promise.complete(inner + 1);
        } catch (e) {
          promise.completeError(e);
        }
      }
    });
    return promise;
  }

  // 正常深度应该能工作
  final normalResult = smAwait<int>(recursiveAsync(10));
  assert(normalResult == 10, 'Expected 10, got $normalResult');
  print('  ✓ recursiveAsync(10) = $normalResult');

  // 超深递归应该报错
  GlobalScheduler.instance.reset();
  String? depthError;
  try {
    smAwait<int>(recursiveAsync(600));
  } catch (e) {
    depthError = e.toString();
  }
  assert(depthError != null && depthError!.contains('recursion depth'),
      'Expected depth error, got: $depthError');
  print('  ✓ recursiveAsync(600) caught: "${depthError!.substring(0, 60)}..."');
}

// ---------------------------------------------------------------------------
// 9. 组合链：then + catchError + whenComplete
// ---------------------------------------------------------------------------
void testCombinedChain() {
  print('\n--- 9. 组合链 then + catchError + whenComplete ---');
  GlobalScheduler.instance.reset();

  bool finalized = false;
  final result = smAwait(
    Promise.value<int>(10)
      .then<int>((v) => v * 2)
      .then<int>((v) { throw Exception('mid-chain error'); })
      .catchError((e) => -1)
      .whenComplete(() { finalized = true; }),
  );
  assert(result == -1, 'Expected -1, got $result');
  assert(finalized, 'whenComplete not called');
  print('  ✓ combined chain: result=$result, finalized=$finalized');
}
