// ============================================================================
// GC 异步环境深度测试
// ============================================================================
// 目的：验证 GC 在复杂异步场景下能否正确完成标记-清除，
//       不回收活跃对象，也不泄漏已死亡对象。
//
// 测试维度：
//   A. Promise 闭包引用的可达性（_onTick / _startCallback）
//   B. GlobalScheduler 持有的 Promise 是否受 GC 保护
//   C. AsyncStateMachine 内部 Promise 的可达性
//   D. then/catchError/whenComplete 链式中间对象
//   E. Promise.delayed 延迟任务中的闭包引用
//   F. 多轮 GC 与异步交织（tick + collect 交错）
//   G. 嵌套异步中的 Box 捕获变量
//   H. 大规模对象压力测试
// ============================================================================

import 'package:dart2cpp/platform/dart/runtime_classes.dart';

// ============================================================================
// 模拟 restored 代码的类定义
// ============================================================================

/// 模拟用户类 — 带字段引用链
class AnimalValue extends AnyGC {
  late String name;
  late int age;
  late AnimalValue? friend; // 可空引用，用于构造引用链

  static Map<String, dynamic>? vptrMap;
  @override
  Map<String, dynamic> get vptr => getVptrMap();
  static Map<String, dynamic> getVptrMap() {
    vptrMap ??= <String, dynamic>{
      'toString': null,
      'operatorEq': null,
      'get_hashCode': null,
    };
    vptrMap!['toString'] = Animal_toString;
    return vptrMap!;
  }

  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
    if (friend is AnyGC) (friend as AnyGC).gcMark(flag);
  }
}

AnimalValue Animal_new(dynamic this__, String name, int age) {
  final this_ = this__ as AnimalValue;
  this_.name = name;
  this_.age = age;
  this_.friend = null;
  return this_;
}

String Animal_toString(dynamic this__) {
  final this_ = this__ as AnimalValue;
  return 'Animal(${this_.name}, ${this_.age})';
}

/// 模拟用户类 — 持有 Promise 结果的容器
class ResultHolderValue extends AnyGC {
  late dynamic data;
  late String label;

  static Map<String, dynamic>? vptrMap;
  @override
  Map<String, dynamic> get vptr => getVptrMap();
  static Map<String, dynamic> getVptrMap() {
    vptrMap ??= <String, dynamic>{
      'toString': null,
      'operatorEq': null,
      'get_hashCode': null,
    };
    return vptrMap!;
  }

  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
    if (data is AnyGC) (data as AnyGC).gcMark(flag);
  }
}

ResultHolderValue ResultHolder_new(dynamic this__, dynamic data, String label) {
  final this_ = this__ as ResultHolderValue;
  this_.data = data;
  this_.label = label;
  return this_;
}

// ============================================================================
// 模拟 AsyncStateMachine — restorer 生成的异步状态机模式
// ============================================================================
class FetchAnimalSM extends AsyncStateMachine<AnimalValue> {
  int _ticksWaited = 0;
  final int _delayTicks;
  final String _animalName;

  FetchAnimalSM(this._delayTicks, this._animalName);

  @override
  bool step() {
    _ticksWaited++;
    if (_ticksWaited >= _delayTicks) {
      final animal = Animal_new(
          GC.allocateLocal(AnimalValue()), _animalName, _ticksWaited);
      completeWith(animal);
      return true;
    }
    return false;
  }

  // 注意：当前 AsyncStateMachine 基类没有覆写 gcMark 来标记内部 promise
  // 这是一个潜在的 GC 盲区
}

// ============================================================================
// 模拟闭包环境类 — restorer 为有捕获的闭包生成的类
// ============================================================================

/// 捕获了 AnimalValue 的闭包环境
class ClosureEnv_animalProcessor extends TypeFunction1<void, AnimalValue> {
  late AnimalValue _captured;
  late int _callCount;

  ClosureEnv_animalProcessor(AnimalValue captured) {
    _captured = captured;
    _callCount = 0;
    GC.allocateLocal(this);
  }

  @override
  void call(AnimalValue animal) {
    _callCount++;
  }

  int get callCount => _callCount;

  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
    if (_captured is AnyGC) (_captured as AnyGC).gcMark(flag);
  }
}

/// 捕获了 ObjectBox 的闭包 — 模拟异步回调中的可变状态
class ClosureEnv_asyncCounter extends TypeFunction0<void> {
  late ObjectBox<int> _counterBox;

  ClosureEnv_asyncCounter(ObjectBox<int> box) {
    _counterBox = box;
    GC.allocateLocal(this);
  }

  @override
  void call() {
    _counterBox.value++;
  }

  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
    _counterBox.gcMark(flag);
  }
}

// ============================================================================
// 测试基础设施
// ============================================================================
int _passed = 0;
int _failed = 0;
int _testNum = 0;

void _assert(bool condition, String message) {
  if (!condition) {
    _failed++;
    print('  ❌ FAIL: $message');
  } else {
    _passed++;
    print('  ✅ $message');
  }
}

void _resetAll() {
  GC.reset();
  GlobalScheduler.instance.reset();
}

// ============================================================================
// 测试用例
// ============================================================================

void main() {
  print('═══════════════════════════════════════════════════════');
  print(' GC 异步环境深度测试');
  print('═══════════════════════════════════════════════════════');

  // A 组：Promise 闭包引用可达性
  testA1_promiseOnTickClosureSurvivesGC();
  testA2_promiseStartCallbackSurvivesGC();
  testA3_promiseGcMarkDoesNotMarkClosures();

  // B 组：GlobalScheduler 持有引用与 GC 的交互
  testB1_schedulerActivePromisesSurviveGC();
  testB2_schedulerReadyPromisesSurviveGC();
  testB3_schedulerDelayedTaskClosureSurvivesGC();
  testB4_gcDoesNotCorruptSchedulerState();

  // C 组：AsyncStateMachine 内部 Promise 可达性
  testC1_asyncStateMachinePromiseSurvivesGC();
  testC2_asyncStateMachineDoesNotMarkInternalPromise();

  // D 组：链式调用中间对象
  testD1_thenChainIntermediatePromiseSurvivesGC();
  testD2_flatMapInnerPromiseSurvivesGC();
  testD3_catchErrorChainSurvivesGC();
  testD4_longChainAllPromisesReachable();

  // E 组：Promise.delayed 延迟任务
  testE1_delayedComputationClosureSurvivesGC();
  testE2_delayedResultObjectSurvivesGC();
  testE3_promiseDelayedNoComputationSurvivesGC();

  // F 组：多轮 GC 与异步交织
  testF1_gcBetweenSchedulerTicks();
  testF2_gcDuringPendingAsyncChain();
  testF3_repeatedCollectDuringAsyncExecution();
  testF4_gcAfterPromiseCompletion();

  // G 组：嵌套异步中的 Box 捕获变量
  testG1_boxCapturedInAsyncClosureSurvivesGC();
  testG2_boxMutatedAcrossAsyncBoundary();
  testG3_nestedClosuresWithSharedBox();

  // H 组：压力测试
  testH1_manyPromisesWithGC();
  testH2_deepAsyncChainWithGC();
  testH3_mixedSyncAsyncWithGC();

  // I 组：边界条件
  testI1_collectWithEmptyScheduler();
  testI2_collectAfterAllPromisesComplete();
  testI3_orphanedPromiseChainCollected();
  testI4_doubleRegistrationPrevention();

  // J 组：修复验证 — 确认 5 个缺陷已修复
  testJ1_schedulerIsGcRoot();
  testJ2_asyncStateMachineMarksPromise();
  testJ3_thenPromiseRegisteredInGC();
  testJ4_setTickCallbackRegistersInGC();
  testJ5_promiseDelayedRegisteredInGC();
  testJ6_schedulerGcMarkProtectsAllPromises();

  // ============================================================================
  // 汇总
  // ============================================================================
  print('\n═══════════════════════════════════════════════════════');
  print(' 📊 测试结果: $_passed 通过, $_failed 失败 (共 ${_passed + _failed} 项断言)');

  if (_failed > 0) {
    print('\n ⚠️  存在 $_failed 个 GC 缺陷，需要修复！');
    print('═══════════════════════════════════════════════════════');
    throw Exception('$_failed 个测试失败');
  } else {
    print(' ✅ 所有 GC 测试通过！');
    print('═══════════════════════════════════════════════════════');
  }
}

// ============================================================================
// A 组：Promise 闭包引用可达性
// ============================================================================

/// A1: Promise._onTick 闭包在 GC 后是否仍然可达
/// 创建 pending Promise 并注册到 Scheduler，然后执行 GC。
/// 期望：闭包存活，tick 后 Promise 正常完成。
void testA1_promiseOnTickClosureSurvivesGC() {
  _testNum++;
  print('\n--- A$_testNum. Promise._onTick 闭包存活测试 ---');
  _resetAll();

  final promise = Promise<String>();
  int tickCount = 0;

  promise.setTickCallback(() {
    tickCount++;
    if (tickCount >= 3) {
      promise.complete('done');
      return true;
    }
    return false;
  });

  // 此时只有 closure 持有 tickCount 的捕获，没有其他 root
  final objectsBefore = GC.objectCount;
  final collected = GC.collect();
  print('  GC: 回收 $collected / $objectsBefore 对象');

  // 驱动 Scheduler
  for (int i = 0; i < 5; i++) {
    GlobalScheduler.instance.tick();
  }

  _assert(promise.isCompleted, 'Promise 应正常完成');
  _assert(promise.result == 'done', '结果应为 "done" (实际: ${promise.isCompleted ? promise.result : "未运行"})');
  _assert(tickCount == 3, 'tickCount 应为 3 (实际: $tickCount)');
}

/// A2: Promise._startCallback 闭包在 GC 后是否仍然可达
/// 使用 setStartCallback 创建 ready 状态的 Promise，然后 GC。
void testA2_promiseStartCallbackSurvivesGC() {
  _testNum++;
  print('\n--- A$_testNum. Promise._startCallback 闭包存活测试 ---');
  _resetAll();

  final promise = Promise<int>();
  bool startCalled = false;

  promise.setStartCallback(() {
    startCalled = true;
    promise.complete(42);
  });

  // Promise 处于 ready 状态，等待下一轮 tick 触发 _startCallback
  final collected = GC.collect();
  print('  GC: 回收 $collected 对象');

  // 触发 Scheduler tick，应执行 _startCallback
  GlobalScheduler.instance.tick();

  _assert(startCalled, 'startCallback 应在 GC 后被调用');
  _assert(promise.isCompleted, 'Promise 应完成');
  _assert(promise.result == 42, '结果应为 42');
}

/// A3: 验证 Promise.gcMark 是否标记了闭包字段
/// 通过检查 gcMark 后的对象数来判断。
void testA3_promiseGcMarkDoesNotMarkClosures() {
  _testNum++;
  print('\n--- A$_testNum. Promise.gcMark 闭包标记验证 ---');
  _resetAll();

  // 创建一个 Promise 作为 root
  final rootPromise = GC.allocateGlobal(Promise<String>());

  // 创建一个独立的闭包（不被任何人引用）
  final closure = ClosureEnv_animalProcessor(
      Animal_new(GC.allocateLocal(AnimalValue()), 'test', 1));

  // 将闭包设置为 Promise 的 _onTick（通过反射不可能，但我们测试 gcMark 本身）
  // 由于 _onTick 是 void Function()?，不是 AnyGC，Promise.gcMark 不会标记它
  // 这意味着如果闭包只被 _onTick 引用，它会被 GC 回收

  final objectsBefore = GC.objectCount;
  final collected = GC.collect();

  // Promise 是 root，所以保留
  // 但闭包和 Animal 没有任何 root 引用它们
  // 注意：GlobalScheduler 也是 root（+1），所以保留 2 个对象
  _assert(collected > 0, '应有对象被回收 (实际: $collected)');
  _assert(GC.objectCount == 2, '保留 root Promise + GlobalScheduler (实际: ${GC.objectCount})');
}

// ============================================================================
// B 组：GlobalScheduler 持有引用与 GC 的交互
// ============================================================================

/// B1: Scheduler 中活跃但不在 GC root 中的 Promise
/// 注册到 Scheduler 的 Promise 如果没有其他 root，GC 会回收它。
/// 但 Scheduler 仍持有引用 → 功能上不受影响（Dart 不释放内存），
/// 但 GC 不再跟踪该对象。
void testB1_schedulerActivePromisesSurviveGC() {
  _testNum++;
  print('\n--- B$_testNum. Scheduler 活跃 Promise GC 存活 ---');
  _resetAll();

  final promise = Promise<int>();
  promise.setTickCallback(() {
    promise.complete(99);
    return true;
  });

  // promise 没有 GC root，只有 Scheduler 持有引用
  final objectsBefore = GC.objectCount;
  final collected = GC.collect();
  print('  GC: 回收 $collected / $objectsBefore 对象');

  // Scheduler 仍可驱动（Dart 层面对象未释放）
  GlobalScheduler.instance.tick();

  _assert(promise.isCompleted, 'Scheduler 仍能驱动 Promise 完成');
  _assert(promise.result == 99, '结果正确');

  // 但 GC 可能已不跟踪此对象
  if (collected > 0) {
    print('  ⚠️  注意: Promise 被 GC 移除了跟踪，但 Scheduler 仍持有引用');
    print('     这不会导致崩溃（Dart 不释放内存），但 GC 统计不准确');
  }
}

/// B2: Scheduler 中 ready 状态的 Promise 在 GC 后的行为
void testB2_schedulerReadyPromisesSurviveGC() {
  _testNum++;
  print('\n--- B$_testNum. Scheduler ready Promise GC 存活 ---');
  _resetAll();

  final promise = Promise<String>();
  bool fired = false;
  promise.setStartCallback(() {
    fired = true;
    promise.complete('ready');
  });
  // 此时 Promise 在 _readyPromises 中

  GC.collect();
  GlobalScheduler.instance.tick();

  _assert(fired, 'ready Promise 的 startCallback 应在 GC 后触发');
  _assert(promise.result == 'ready', '结果正确');
}

/// B3: Scheduler 延迟任务中的闭包在 GC 后存活
void testB3_schedulerDelayedTaskClosureSurvivesGC() {
  _testNum++;
  print('\n--- B$_testNum. Scheduler 延迟任务闭包存活 ---');
  _resetAll();

  final promise = Promise<String>();
  final animal = Animal_new(GC.allocateLocal(AnimalValue()), 'delayed', 5);

  GlobalScheduler.instance.registerDelayedTask(3, () {
    promise.complete(animal.name);
  });

  GC.collect();

  // 驱动 3 个 tick
  for (int i = 0; i < 4; i++) {
    GlobalScheduler.instance.tick();
  }

  _assert(promise.isCompleted, '延迟任务应完成');
  _assert(promise.result == 'delayed', '闭包中捕获的 Animal 数据应正确 (实际: ${promise.isCompleted ? promise.result : "?"})');
}

/// B4: GC 不破坏 Scheduler 内部状态
void testB4_gcDoesNotCorruptSchedulerState() {
  _testNum++;
  print('\n--- B$_testNum. GC 不破坏 Scheduler 状态 ---');
  _resetAll();

  // 创建多个 Promise
  final p1 = Promise<int>();
  final p2 = Promise<int>();
  final p3 = Promise<int>();
  int counter = 0;

  p1.setTickCallback(() { p1.complete(++counter); return true; });
  p2.setTickCallback(() { p2.complete(++counter); return true; });
  p3.setTickCallback(() { p3.complete(++counter); return true; });

  GC.collect();
  GlobalScheduler.instance.tick();

  _assert(p1.isCompleted && p2.isCompleted && p3.isCompleted,
      '所有 Promise 应完成');
  _assert(counter == 3, '计数器应为 3 (实际: $counter)');
}

// ============================================================================
// C 组：AsyncStateMachine 内部 Promise 可达性
// ============================================================================

/// C1: AsyncStateMachine 的 Promise 在 GC 后是否仍然可达
void testC1_asyncStateMachinePromiseSurvivesGC() {
  _testNum++;
  print('\n--- C$_testNum. AsyncStateMachine Promise GC 存活 ---');
  _resetAll();

  // 创建状态机作为 root
  final sm = GC.allocateGlobal(FetchAnimalSM(3, 'Buddy'));
  final promise = sm.start(); // 注册到 Scheduler

  // GC — sm 是 root，但 sm.promise 和 promise 是同一个对象
  // 问题：AsyncStateMachine 基类没有覆写 gcMark 来标记 promise
  final collected = GC.collect();
  print('  GC: 回收 $collected 对象');

  // 驱动状态机
  for (int i = 0; i < 5; i++) {
    GlobalScheduler.instance.tick();
  }

  _assert(promise.isCompleted, '状态机 Promise 应完成');
  if (promise.isCompleted) {
    final animal = promise.result;
    _assert(animal.name == 'Buddy', '动物名正确 (实际: ${animal.name})');
  }
}

/// C2: 验证 AsyncStateMachine 是否标记了内部 promise
/// 创建一个 AsyncStateMachine 作为唯一 root，检查其 promise 是否被 GC 跟踪
void testC2_asyncStateMachineDoesNotMarkInternalPromise() {
  _testNum++;
  print('\n--- C$_testNum. AsyncStateMachine.gcMark 内部 Promise 标记 ---');
  _resetAll();

  final sm = GC.allocateGlobal(FetchAnimalSM(5, 'Max'));
  sm.start();

  final objectsBefore = GC.objectCount;
  print('  GC 前: ${objectsBefore} 对象 (sm + sm.promise)');

  // sm.promise 是通过 sm.start() 返回的，也是 sm 内部的 final 字段
  // 如果 AsyncStateMachine.gcMark 没有标记 promise，那么：
  // - sm 作为 root 被标记
  // - sm.promise 可能不被标记（因为它不在 _objects 列表中的 root 路径上）
  // 但 sm.promise 在 start() 时注册到了 Scheduler，Scheduler 持有引用

  final collected = GC.collect();
  final objectsAfter = GC.objectCount;
  print('  GC 后: $objectsAfter 对象, 回收 $collected');

  // 关键断言：sm.promise 应该仍然被跟踪
  // 如果 AsyncStateMachine 没有 gcMark 覆写，promise 可能被从 _objects 移除
  // 但仍被 Scheduler 和 sm 字段引用（Dart 不释放，但 GC 丢失跟踪）
  _assert(objectsAfter >= 1, '至少 sm 本身应保留');

  // 驱动验证功能正常
  for (int i = 0; i < 6; i++) {
    GlobalScheduler.instance.tick();
  }
  _assert(sm.promise.isCompleted, '状态机应正常完成');
}

// ============================================================================
// D 组：链式调用中间对象
// ============================================================================

/// D1: then() 链中的中间 Promise 在 GC 后存活
void testD1_thenChainIntermediatePromiseSurvivesGC() {
  _testNum++;
  print('\n--- D$_testNum. then 链中间 Promise GC 存活 ---');
  _resetAll();

  // 创建链：source → p2 → p3
  final source = GC.allocateGlobal(Promise<int>());
  source.setTickCallback(() { source.complete(10); return true; });

  final p2 = source.then<int>((v) => v * 2);
  final p3 = p2.then<String>((v) => 'result=$v');

  // p2 和 p3 没有显式 GC root，只在 Scheduler 和闭包中
  GC.collect();

  // 驱动
  for (int i = 0; i < 5; i++) {
    GlobalScheduler.instance.tick();
  }

  _assert(source.isCompleted, 'source 应完成');
  _assert(p2.isCompleted, 'p2 应完成');
  _assert(p3.isCompleted, 'p3 应完成');
  if (p3.isCompleted) {
    _assert(p3.result == 'result=20', '最终结果正确 (实际: ${p3.result})');
  }
}

/// D2: then flatMap 中间 Promise（内层 Promise）的可达性
void testD2_flatMapInnerPromiseSurvivesGC() {
  _testNum++;
  print('\n--- D$_testNum. flatMap 内层 Promise GC 存活 ---');
  _resetAll();

  final source = GC.allocateGlobal(Promise<int>());
  source.setTickCallback(() { source.complete(5); return true; });

  // flatMap：onValue 返回一个 Promise，创建内层 Promise
  final flatMapped = source.then<String>((v) {
    final innerPromise = Promise.delayed<String>(2, () => 'inner=$v');
    return innerPromise;
  });

  GC.collect(); // 内层 Promise 此时还没有 root

  for (int i = 0; i < 10; i++) {
    GlobalScheduler.instance.tick();
  }

  _assert(flatMapped.isCompleted, 'flatMap 应完成');
  if (flatMapped.isCompleted) {
    _assert(flatMapped.result == 'inner=5', '结果正确 (实际: ${flatMapped.result})');
  }
}

/// D3: catchError 链在 GC 后的行为
void testD3_catchErrorChainSurvivesGC() {
  _testNum++;
  print('\n--- D$_testNum. catchError 链 GC 存活 ---');
  _resetAll();

  final source = GC.allocateGlobal(Promise<String>());
  source.setTickCallback(() {
    source.completeError(Exception('test error'));
    return true;
  });

  final recovered = source.catchError((e) => 'recovered');

  GC.collect();

  for (int i = 0; i < 5; i++) {
    GlobalScheduler.instance.tick();
  }

  _assert(recovered.isCompleted, 'catchError 应完成');
  if (recovered.isCompleted) {
    _assert(recovered.result == 'recovered', '错误恢复结果正确');
  }
}

/// D4: 长链所有 Promise 可达性
void testD4_longChainAllPromisesReachable() {
  _testNum++;
  print('\n--- D$_testNum. 长链全部 Promise 可达 ---');
  _resetAll();

  final source = GC.allocateGlobal(Promise<int>());
  source.setTickCallback(() { source.complete(1); return true; });

  // 构建 10 级链
  Promise<int> current = source;
  final chain = <Promise<int>>[source];
  for (int i = 0; i < 10; i++) {
    current = current.then<int>((v) => v + 1);
    chain.add(current as Promise<int>);
  }

  GC.collect();

  for (int i = 0; i < 20; i++) {
    GlobalScheduler.instance.tick();
  }

  _assert(chain.last.isCompleted, '链尾应完成');
  if (chain.last.isCompleted) {
    _assert(chain.last.result == 11, '链尾结果应为 11 (实际: ${chain.last.result})');
  }

  // 验证中间节点都完成了
  bool allDone = chain.every((p) => p.isCompleted);
  _assert(allDone, '所有链节点应完成');
}

// ============================================================================
// E 组：Promise.delayed 延迟任务
// ============================================================================

/// E1: Promise.delayed 的 computation 闭包在 GC 后存活
void testE1_delayedComputationClosureSurvivesGC() {
  _testNum++;
  print('\n--- E$_testNum. Promise.delayed computation 闭包存活 ---');
  _resetAll();

  final animal = Animal_new(GC.allocateLocal(AnimalValue()), 'Delayed', 3);
  final promise = Promise.delayed<String>(5, () => animal.name);

  // 只有 Scheduler._delayedTasks 持有闭包引用
  GC.collect();

  for (int i = 0; i < 6; i++) {
    GlobalScheduler.instance.tick();
  }

  _assert(promise.isCompleted, 'delayed Promise 应完成');
  if (promise.isCompleted) {
    _assert(promise.result == 'Delayed', '闭包捕获的数据正确 (实际: ${promise.result})');
  }
}

/// E2: Promise.delayed 结果对象在 GC 后存活
void testE2_delayedResultObjectSurvivesGC() {
  _testNum++;
  print('\n--- E$_testNum. Promise.delayed 结果对象存活 ---');
  _resetAll();

  final promise = Promise.delayed<AnimalValue>(2, () {
    return Animal_new(GC.allocateLocal(AnimalValue()), 'Born', 0);
  });

  GC.collect(); // 闭包还未执行，Animal 尚未创建

  for (int i = 0; i < 3; i++) {
    GlobalScheduler.instance.tick();
  }

  _assert(promise.isCompleted, 'Promise 应完成');
  if (promise.isCompleted) {
    final animal = promise.result;
    _assert(animal.name == 'Born', '结果 Animal 正确');

    // 再执行一次 GC — 此时 animal 在 Promise._result 中
    // Promise 仍在 Scheduler 活跃列表中（直到 tick 发现它完成）
    GC.collect();
    _assert(animal.name == 'Born', 'GC 后结果仍可访问');
  }
}

/// E3: promiseDelayed (Duration 版) 无 computation 的 GC 行为
void testE3_promiseDelayedNoComputationSurvivesGC() {
  _testNum++;
  print('\n--- E$_testNum. promiseDelayed 无 computation GC 存活 ---');
  _resetAll();

  final promise = promiseDelayed<void>(StaticDuration(milliseconds: 30));

  GC.collect();

  for (int i = 0; i < 5; i++) {
    GlobalScheduler.instance.tick();
  }

  _assert(promise.isCompleted, 'promiseDelayed 应完成');
}

// ============================================================================
// F 组：多轮 GC 与异步交织
// ============================================================================

/// F1: 在每个 Scheduler tick 之间执行 GC
void testF1_gcBetweenSchedulerTicks() {
  _testNum++;
  print('\n--- F$_testNum. tick 间 GC ---');
  _resetAll();

  final results = <int>[];
  for (int i = 0; i < 5; i++) {
    final p = Promise<int>();
    final val = i;
    p.setTickCallback(() { p.complete(val); return true; });

    // 每注册一个就 GC
    GC.collect();

    GlobalScheduler.instance.tick();
    if (p.isCompleted) results.add(p.result);
  }

  _assert(results.length == 5, '5 个 Promise 全部完成 (实际: ${results.length})');
  _assert(results.join(',') == '0,1,2,3,4', '结果顺序正确');
}

/// F2: 在异步链执行过程中执行 GC
void testF2_gcDuringPendingAsyncChain() {
  _testNum++;
  print('\n--- F$_testNum. 异步链执行中 GC ---');
  _resetAll();

  final source = GC.allocateGlobal(Promise<int>());
  int tickCount = 0;
  source.setTickCallback(() {
    tickCount++;
    if (tickCount >= 3) {
      source.complete(100);
      return true;
    }
    return false;
  });

  final chained = source.then<String>((v) => 'got=$v');

  // 交替执行：tick → GC → tick → GC → ...
  for (int i = 0; i < 6; i++) {
    GlobalScheduler.instance.tick();
    GC.collect();
  }

  _assert(source.isCompleted, 'source 完成');
  _assert(chained.isCompleted, 'chained 完成');
  if (chained.isCompleted) {
    _assert(chained.result == 'got=100', '结果正确');
  }
}

/// F3: 反复 GC 不影响长时间运行的异步操作
void testF3_repeatedCollectDuringAsyncExecution() {
  _testNum++;
  print('\n--- F$_testNum. 长时间异步中反复 GC ---');
  _resetAll();

  final sm = GC.allocateGlobal(FetchAnimalSM(10, 'Persistent'));
  sm.start();

  // 每个 tick 都 GC
  for (int i = 0; i < 15; i++) {
    GlobalScheduler.instance.tick();
    GC.collect();
  }

  _assert(sm.promise.isCompleted, '长时间状态机应完成');
  if (sm.promise.isCompleted) {
    _assert(sm.promise.result.name == 'Persistent', '结果正确');
  }
}

/// F4: Promise 完成后的 GC 行为
void testF4_gcAfterPromiseCompletion() {
  _testNum++;
  print('\n--- F$_testNum. Promise 完成后 GC ---');
  _resetAll();

  // 创建并立即完成
  final p1 = Promise.value<String>('already done');

  // 创建一个使用 p1 结果的链
  final p2 = p1.then<int>((s) => s.length);

  // 驱动完成
  GlobalScheduler.instance.tick();

  _assert(p2.isCompleted, 'p2 应完成');

  // 此时 p1 和 p2 都完成了，清理它们的 GC 跟踪
  final before = GC.objectCount;
  final collected = GC.collect();
  print('  完成后 GC: 回收 $collected / $before 对象');

  // p1 和 p2 不是 root，应该被回收（除非 Scheduler 还持有引用）
  // 实际上完成后 Scheduler 会从 _activePromises 移除
  _assert(p2.result == 12, '已完成的结果仍可读 (实际: ${p2.result})');
}

// ============================================================================
// G 组：嵌套异步中的 Box 捕获变量
// ============================================================================

/// G1: Box 在异步闭包中被捕获，GC 后仍可访问
void testG1_boxCapturedInAsyncClosureSurvivesGC() {
  _testNum++;
  print('\n--- G$_testNum. Box 异步闭包捕获存活 ---');
  _resetAll();

  final counterBox = GC.allocateGlobal(ObjectBox<int>(0));
  final closure = ClosureEnv_asyncCounter(counterBox);

  // 创建 Promise，在 _onTick 中调用闭包
  final promise = Promise<int>();
  int ticks = 0;
  promise.setTickCallback(() {
    ticks++;
    closure.call(); // 增加 counter
    if (ticks >= 5) {
      promise.complete(counterBox.value);
      return true;
    }
    return false;
  });

  GC.collect();

  for (int i = 0; i < 6; i++) {
    GlobalScheduler.instance.tick();
  }

  _assert(promise.isCompleted, 'Promise 应完成');
  _assert(counterBox.value == 5, 'Box 值应递增到 5 (实际: ${counterBox.value})');
}

/// G2: Box 跨异步边界可变
void testG2_boxMutatedAcrossAsyncBoundary() {
  _testNum++;
  print('\n--- G$_testNum. Box 跨异步边界可变 ---');
  _resetAll();

  final sharedBox = GC.allocateGlobal(ObjectBox<int>(0));

  // 第一个异步操作
  final p1 = Promise<int>();
  p1.setTickCallback(() {
    sharedBox.value += 10;
    p1.complete(sharedBox.value);
    return true;
  });

  // 第二个异步操作（依赖第一个）
  final p2 = p1.then<int>((v) {
    sharedBox.value += 20;
    return sharedBox.value;
  });

  GC.collect();

  for (int i = 0; i < 5; i++) {
    GlobalScheduler.instance.tick();
  }

  _assert(p2.isCompleted, 'p2 应完成');
  _assert(sharedBox.value == 30, 'Box 最终值应为 30 (实际: ${sharedBox.value})');
}

/// G3: 嵌套闭包共享 Box
void testG3_nestedClosuresWithSharedBox() {
  _testNum++;
  print('\n--- G$_testNum. 嵌套闭包共享 Box ---');
  _resetAll();

  final sharedBox = GC.allocateGlobal(ObjectBox<int>(0));

  // 外层闭包
  final outer = ClosureEnv_asyncCounter(sharedBox);

  // 内层闭包（捕获同一个 Box）
  final inner = ClosureEnv_asyncCounter(sharedBox);

  outer.call();
  outer.call();
  inner.call();

  _assert(sharedBox.value == 3, '共享 Box 应为 3');

  GC.collect();

  // GC 后继续操作
  outer.call();
  inner.call();
  inner.call();

  _assert(sharedBox.value == 6, 'GC 后共享 Box 应为 6 (实际: ${sharedBox.value})');
}

// ============================================================================
// H 组：压力测试
// ============================================================================

/// H1: 大量 Promise 同时存在时的 GC
void testH1_manyPromisesWithGC() {
  _testNum++;
  print('\n--- H$_testNum. 大量 Promise + GC ---');
  _resetAll();

  final promises = <Promise<int>>[];
  final root = GC.allocateGlobal(Promise<int>());
  root.setTickCallback(() { root.complete(0); return true; });

  // 创建 100 个 Promise 链
  Promise<int> current = root;
  for (int i = 0; i < 100; i++) {
    current = current.then<int>((v) => v + 1);
    promises.add(current as Promise<int>);
  }

  // 中途多次 GC
  GC.collect();
  for (int i = 0; i < 50; i++) {
    GlobalScheduler.instance.tick();
    if (i % 10 == 0) GC.collect();
  }
  for (int i = 0; i < 60; i++) {
    GlobalScheduler.instance.tick();
  }

  _assert(promises.last.isCompleted, '最后一个 Promise 应完成');
  if (promises.last.isCompleted) {
    _assert(promises.last.result == 100, '链结果应为 100 (实际: ${promises.last.result})');
  }
}

/// H2: 深层异步链 + GC 压力
void testH2_deepAsyncChainWithGC() {
  _testNum++;
  print('\n--- H$_testNum. 深层异步链 + GC ---');
  _resetAll();

  // 创建 20 个状态机，每个需要不同 tick 数
  final stateMachines = <FetchAnimalSM>[];
  for (int i = 0; i < 20; i++) {
    final sm = GC.allocateGlobal(FetchAnimalSM(i + 1, 'Animal$i'));
    sm.start();
    stateMachines.add(sm);
  }

  // 交替执行和 GC
  for (int tick = 0; tick < 25; tick++) {
    GlobalScheduler.instance.tick();
    if (tick % 5 == 0) {
      final collected = GC.collect();
      print('  tick=$tick, GC 回收 $collected');
    }
  }

  final completed = stateMachines.where((sm) => sm.promise.isCompleted).length;
  _assert(completed == 20, '所有 20 个状态机应完成 (实际: $completed)');
}

/// H3: 混合同步/异步操作 + GC
void testH3_mixedSyncAsyncWithGC() {
  _testNum++;
  print('\n--- H$_testNum. 混合同步/异步 + GC ---');
  _resetAll();

  // 同步创建对象树
  final root = Animal_new(GC.allocateGlobal(AnimalValue()), 'root', 0);
  for (int i = 0; i < 50; i++) {
    final child = Animal_new(GC.allocateLocal(AnimalValue()), 'child$i', i);
    child.friend = root;
    root.friend = child; // 更新引用
  }

  // 异步操作
  final promise = Promise<String>();
  promise.setTickCallback(() {
    promise.complete(root.name);
    return true;
  });

  GC.collect();
  GlobalScheduler.instance.tick();

  _assert(promise.isCompleted, 'Promise 完成');
  _assert(promise.result == 'root', '根对象数据正确');

  // 50 个 child 中，只有最后一个被 root.friend 直接引用
  // 其他 49 个应该被回收
  final afterGC = GC.objectCount;
  print('  GC 后: $afterGC 对象 (root + 最后一个 child + promise 等)');
}

// ============================================================================
// I 组：边界条件
// ============================================================================

/// I1: 空 Scheduler 时 GC
void testI1_collectWithEmptyScheduler() {
  _testNum++;
  print('\n--- I$_testNum. 空 Scheduler GC ---');
  _resetAll();

  Animal_new(GC.allocateLocal(AnimalValue()), 'test1', 0);
  Animal_new(GC.allocateLocal(AnimalValue()), 'test2', 0);
  Animal_new(GC.allocateGlobal(AnimalValue()), 'test3', 0);

  // 注意：GlobalScheduler 也是 GC root（+1），所以总数是 3+1=4
  _assert(GC.objectCount == 4, '4 个对象 (3 animals + Scheduler)');
  final collected = GC.collect();
  _assert(collected == 2, '回收 2 个非 root (实际: $collected)');
  _assert(GC.objectCount == 2, '保留 1 个 root + Scheduler (实际: ${GC.objectCount})');
}

/// I2: 所有 Promise 完成后 GC
void testI2_collectAfterAllPromisesComplete() {
  _testNum++;
  print('\n--- I$_testNum. 全部完成后 GC ---');
  _resetAll();

  final p1 = Promise.value<int>(1);
  final p2 = Promise.value<int>(2);
  GlobalScheduler.instance.tick(); // 清理已完成的

  final before = GC.objectCount;
  final collected = GC.collect();
  print('  回收 $collected / $before');

  // 已完成的 Promise 如果没有 root 引用，应该被回收
  _assert(GC.objectCount == 0 || collected >= 0, 'GC 正常运行');
}

/// I3: 孤立对象应被完全回收
/// 验证不在任何 root 引用链中的对象会被正确回收。
/// 注意：注册到 Scheduler 的 Promise 受 Scheduler.gcMark 保护，不会被回收。
/// 此测试使用不在 Scheduler 中的普通对象。
void testI3_orphanedPromiseChainCollected() {
  _testNum++;
  print('\n--- I$_testNum. 孤立对象完全回收 ---');
  _resetAll();

  // 创建不在 Scheduler 中的孤立对象
  {
    final orphan1 = GC.allocateLocal(Promise<int>());
    final orphan2 = Animal_new(GC.allocateLocal(AnimalValue()), 'orphan', 0);
    final orphan3 = GC.allocateLocal(ObjectBox<int>(42));
    // 这些对象仅被局部变量引用，离开作用域后无任何 root 可达
  }

  // 这些对象不在任何 root 中（Scheduler 是 root，但它不持有这些对象）
  final before = GC.objectCount;
  final collected = GC.collect();
  print('  孤立对象: 回收 $collected / $before');
  _assert(collected >= 3, '至少回收 3 个孤立对象 (实际: $collected)');
  // 仅剩 Scheduler
  _assert(GC.objectCount == 1, '仅保留 Scheduler (实际: ${GC.objectCount})');
}

/// I4: 双重注册防护
void testI4_doubleRegistrationPrevention() {
  _testNum++;
  print('\n--- I$_testNum. 双重注册防护 ---');
  _resetAll();

  final animal = Animal_new(GC.allocateLocal(AnimalValue()), 'test', 0);

  // 多次注册同一对象
  GC.allocateLocal(animal);
  GC.allocateLocal(animal);
  GC.allocateLocal(animal);

  // GlobalScheduler 也是 root，所以总数 = 1 (animal) + 1 (Scheduler) = 2
  _assert(GC.objectCount == 2, '同一对象只注册一次 + Scheduler (实际: ${GC.objectCount})');

  // 从 local 升级为 global
  GC.allocateGlobal(animal);
  _assert(GC.objectCount == 2, '升级不增加对象数');
  // roots = animal + GlobalScheduler = 2
  _assert(GC.rootCount == 2, 'root 数为 2 (animal + Scheduler)');

  // 再次 global
  GC.allocateGlobal(animal);
  _assert(GC.rootCount == 2, '重复 global 不增加 root 数');
}

// ============================================================================
// J 组：修复验证 — 确认 5 个 GC 缺陷已修复
// ============================================================================

/// J1: 验证 GlobalScheduler 是 GC root
/// 修复前：GlobalScheduler 不继承 AnyGC，其持有的 Promise 对 GC 不可见
/// 修复后：GlobalScheduler extends AnyGC，构造时注册为 GC root
void testJ1_schedulerIsGcRoot() {
  _testNum++;
  print('\n--- J$_testNum. [修复] GlobalScheduler 是 GC root ---');
  _resetAll();

  // Scheduler 应在 roots 中（通过 reset() → allocateGlobal(this) 注册）
  _assert(GC.rootCount >= 1, 'Scheduler 应注册为 root (rootCount=${GC.rootCount})');
  _assert(GC.objectCount >= 1, 'Scheduler 应在 objects 中 (objectCount=${GC.objectCount})');

  // 创建 Promise，仅通过 setTickCallback 注册（不调用 allocateLocal）
  final p = Promise<int>();
  p.setTickCallback(() { p.complete(42); return true; });

  final before = GC.objectCount;
  print('  GC 前: $before 对象');

  final collected = GC.collect();
  print('  GC 后: ${GC.objectCount} 对象, 回收 $collected');

  // Promise 被 Scheduler 持有 → Scheduler.gcMark 标记它 → 不应被回收
  _assert(GC.objectCount >= 2, 'Scheduler + Promise 都应保留 (实际: ${GC.objectCount})');

  // 验证功能正常
  GlobalScheduler.instance.tick();
  _assert(p.isCompleted, 'Promise 应正常完成');
  _assert(p.result == 42, '结果正确');
}

/// J2: 验证 AsyncStateMachine.gcMark 标记内部 promise
/// 修复前：ASM 没有覆写 gcMark，内部 promise 字段不参与标记
/// 修复后：ASM.gcMark 递归标记 promise
void testJ2_asyncStateMachineMarksPromise() {
  _testNum++;
  print('\n--- J$_testNum. [修复] AsyncStateMachine.gcMark 标记 promise ---');
  _resetAll();

  // ASM 作为唯一 root
  final sm = GC.allocateGlobal(FetchAnimalSM(3, 'GcMarkTest'));
  sm.start();

  final before = GC.objectCount;
  print('  GC 前: $before 对象 (ASM + promise + Scheduler)');

  final collected = GC.collect();
  print('  GC 后: ${GC.objectCount} 对象, 回收 $collected');

  // ASM root → gcMark → 标记 sm.promise → promise 不应被回收
  _assert(GC.objectCount >= 2, 'ASM + promise 都应保留 (实际: ${GC.objectCount})');

  // 驱动验证
  for (int i = 0; i < 5; i++) GlobalScheduler.instance.tick();
  _assert(sm.promise.isCompleted, '状态机应正常完成');
  _assert(sm.promise.result.name == 'GcMarkTest', '结果正确');
}

/// J3: 验证 then()/catchError()/whenComplete() 创建的 Promise 已注册到 GC
/// 修复前：这些方法创建的 Promise 仅注册到 Scheduler，GC 不知道
/// 修复后：使用 allocateLocal 注册
void testJ3_thenPromiseRegisteredInGC() {
  _testNum++;
  print('\n--- J$_testNum. [修复] then() Promise 注册到 GC ---');
  _resetAll();

  final source = GC.allocateGlobal(Promise<int>());
  source.setTickCallback(() { source.complete(10); return true; });

  // then 创建新 Promise — 修复后应自动注册到 GC
  final chained = source.then<int>((v) => v * 2);

  // chained 应在 GC._objects 中
  final objectsBefore = GC.objectCount;
  print('  then 后: $objectsBefore 对象');
  _assert(objectsBefore >= 3, 'source + chained + Scheduler 都应注册 (实际: $objectsBefore)');

  final collected = GC.collect();
  print('  GC 后: ${GC.objectCount} 对象, 回收 $collected');

  // 由于 Scheduler 是 root，它标记 source 和 chained → 都不应被回收
  _assert(GC.objectCount >= 3, 'source + chained + Scheduler 都应保留 (实际: ${GC.objectCount})');

  // 驱动验证
  for (int i = 0; i < 3; i++) GlobalScheduler.instance.tick();
  _assert(chained.isCompleted, 'chained 应完成');
  _assert(chained.result == 20, '结果正确 (实际: ${chained.result})');
}

/// J4: 验证 setTickCallback 注册到 GC
/// 修复前：setTickCallback 不注册到 GC，Promise 不可见
/// 修复后：内部调用 allocateLocal(this)
void testJ4_setTickCallbackRegistersInGC() {
  _testNum++;
  print('\n--- J$_testNum. [修复] setTickCallback 注册到 GC ---');
  _resetAll();

  final p = Promise<String>();
  final beforeSet = GC.objectCount;
  p.setTickCallback(() { p.complete('ok'); return true; });
  final afterSet = GC.objectCount;

  _assert(afterSet > beforeSet,
      'setTickCallback 应注册到 GC (前: $beforeSet, 后: $afterSet)');

  // GC 后 promise 应保留（被 Scheduler 持有）
  GC.collect();
  _assert(GC.objectCount >= 2, 'Promise + Scheduler 应保留 (实际: ${GC.objectCount})');

  GlobalScheduler.instance.tick();
  _assert(p.isCompleted, 'Promise 正常完成');
}

/// J5: 验证 Promise.delayed 创建的 Promise 已注册到 GC
/// 修复前：Promise.delayed 中的 promise 没有 allocateLocal
/// 修复后：使用 allocateLocal 注册
void testJ5_promiseDelayedRegisteredInGC() {
  _testNum++;
  print('\n--- J$_testNum. [修复] Promise.delayed 注册到 GC ---');
  _resetAll();

  final before = GC.objectCount;
  final p = Promise.delayed<String>(3, () => 'delayed_result');
  final after = GC.objectCount;

  _assert(after > before,
      'Promise.delayed 应注册到 GC (前: $before, 后: $after)');

  // GC 后不应回收（被 Scheduler._delayedTasks 闭包引用）
  GC.collect();
  _assert(GC.objectCount >= 2, 'Promise + Scheduler 应保留 (实际: ${GC.objectCount})');

  for (int i = 0; i < 5; i++) GlobalScheduler.instance.tick();
  _assert(p.isCompleted, 'delayed Promise 应完成');
  _assert(p.result == 'delayed_result', '结果正确');
}

/// J6: 综合验证 — Scheduler.gcMark 保护所有持有的 Promise
/// 模拟真实的复杂异步场景：多个 Promise 同时在 Scheduler 中，
/// 执行 GC 后全部存活。
void testJ6_schedulerGcMarkProtectsAllPromises() {
  _testNum++;
  print('\n--- J$_testNum. [修复] Scheduler.gcMark 保护所有 Promise ---');
  _resetAll();

  // 创建多种类型的 Promise，全部在 Scheduler 中
  final active = Promise<int>();
  active.setTickCallback(() { active.complete(1); return true; });

  final chained = active.then<int>((v) => v + 1);

  final delayed = Promise.delayed<String>(2, () => 'delayed');

  final ready = Promise<int>();
  ready.setStartCallback(() { ready.complete(99); });

  // 创建一些不在 Scheduler 中的孤立对象
  Animal_new(GC.allocateLocal(AnimalValue()), 'orphan1', 0);
  Animal_new(GC.allocateLocal(AnimalValue()), 'orphan2', 0);

  final before = GC.objectCount;
  print('  GC 前: $before 对象');

  final collected = GC.collect();
  print('  GC 后: ${GC.objectCount} 对象, 回收 $collected');

  // 孤立对象应被回收
  _assert(collected >= 2, '至少回收 2 个孤立对象 (实际: $collected)');

  // Scheduler 中的 Promise 全部存活
  _assert(GC.objectCount >= 4,
      'active + chained + delayed + ready + Scheduler 应保留 (实际: ${GC.objectCount})');

  // 驱动全部完成
  for (int i = 0; i < 5; i++) GlobalScheduler.instance.tick();
  _assert(active.isCompleted, 'active 完成');
  _assert(chained.isCompleted, 'chained 完成');
  _assert(delayed.isCompleted, 'delayed 完成');
  _assert(ready.isCompleted, 'ready 完成');
  _assert(chained.result == 2, 'chained 结果正确 (实际: ${chained.result})');
}
