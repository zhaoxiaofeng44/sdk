// ============================================================================
// gc_cpp_leak_test.cpp — C++ 运行时 GC 语义与泄漏测试（保守扫描版）
// ============================================================================
// 模拟 cpp_emitter 生成的代码模式（struct + ClassInfo + gcMark、闭包环境、
// AsyncStateMachine、Promise 链），验证标记-清除 GC（含保守栈扫描）的
// 回收能力，并量化各类泄漏场景：
//
//   T1 循环分配 + collect → 回收（基线，同时演示无自动 GC 时的增长）
//   T2 循环引用：不可达环被回收 / 可达环存活
//   T3 闭包捕获：闭包死 → 捕获对象回收；闭包活 → 捕获对象存活
//   T4 集合清空后元素可回收
//   T5 状态机正常完成 → SM + Promise 无泄漏
//   T6 [F2] 被遗弃的 pending Promise：collect 自动回收（调度器不再钉住）
//   T7 [F4] 全局变量重复赋值：旧模式泄漏 vs removeRoot 修复模式
//   T8 已完成未 tick 的 Promise：不可达即回收，无需等 tick 过滤
//   T9 [F1] 分配阈值自动 GC：长循环下对象数量有界
//
// 保守扫描说明：collect() 会扫描当前栈上的字，已退出帧中的残留指针
// （陈旧栈槽）也会临时钉住对象，需要后续栈复用才会释放。因此"对象死亡"
// 类断言统一采用「辅助函数内分配 → _collectUntilStable（搅拌栈 + 多轮
// collect 至收敛）」模式。预期在 ASan/LSan 下干净通过。
// ============================================================================

#include "dart2cpp_lowered.h"
#include <cstdio>

static int g_pass = 0;
static int g_fail = 0;

#define EXPECT(cond, msg)                                                  \
    do {                                                                   \
        if (cond) {                                                        \
            g_pass++;                                                      \
            printf("  ✅ %s\n", msg);                                      \
        } else {                                                           \
            g_fail++;                                                      \
            printf("  ❌ %s  (at line %d)\n", msg, __LINE__);              \
        }                                                                  \
    } while (0)

// 覆写一段栈区，清除陈旧指针槽（模拟真实程序中后续调用的栈复用）
static void _stackScrub() {
    volatile char buf[16384];
    for (size_t i = 0; i < sizeof(buf); i++) buf[i] = static_cast<char>(i);
}

// 栈搅拌：递归放置大帧，覆写不同深度的陈旧指针槽
static void _deepWork(int depth) {
    volatile char buf[8192];
    for (size_t i = 0; i < sizeof(buf); i++) buf[i] = static_cast<char>(i ^ depth);
    if (depth > 0) _deepWork(depth - 1);
}

// 反复搅拌栈并 collect 直到收敛，返回累计回收数。
// 保守扫描下陈旧栈槽的覆写需要若干轮栈复用，此模式保证"死亡对象"
// 断言的确定性（真实程序中由后续函数调用的栈复用自然完成同样的事）。
static int _collectUntilStable() {
    int total = 0;
    for (int i = 0; i < 8; i++) {
        _deepWork(3);
        int freed = GC::collect();
        total += freed;
        if (freed == 0) break;
    }
    return total;
}

// ============================================================================
// 模拟生成代码的用户类：NodeValue（树节点，带两个子引用）
// ============================================================================

struct NodeValue;
static void Node_gcMark(AnyGC* self, int flag);

struct NodeClassInfo : ClassInfo {
    NodeClassInfo() {
        typeName = "Node";
        gcMark = &Node_gcMark;
    }
};

struct NodeValue : AnyGC {
    NodeValue* left = nullptr;
    NodeValue* right = nullptr;
    int64_t tag = 0;
    static NodeClassInfo _classInfo;
    NodeValue() { AnyGC::_classInfo = &_classInfo; }
};

NodeClassInfo NodeValue::_classInfo;

static void Node_gcMark(AnyGC* self, int flag) {
    auto* n = static_cast<NodeValue*>(self);
    if (n->left) _gcMark(n->left, flag);
    if (n->right) _gcMark(n->right, flag);
}

// ============================================================================
// 模拟生成代码的闭包环境：捕获一个 AnyGC*（对齐 ClosureEnv_N 模式）
// ============================================================================

struct CaptureEnv;
static void CaptureEnv_gcMark(AnyGC* self, int flag);

struct CaptureEnvClassInfo : ClassInfo {
    CaptureEnvClassInfo() {
        typeName = "Closure";
        gcMark = &CaptureEnv_gcMark;
    }
};

struct CaptureEnv : TypeFunction0<int64_t> {
    AnyGC* captured = nullptr;
    static CaptureEnvClassInfo _classInfo;
    CaptureEnv(AnyGC* cap) : captured(cap) {
        this->fnPtr = &_trampoline;
        this->typedFnPtr = &_typedTrampoline;
        AnyGC::_classInfo = &_classInfo;
    }
    static AnyGC* _trampoline(AnyGC* env) { return _box(0LL); }
    static int64_t _typedTrampoline(AnyGC* env) {
        auto* e = static_cast<CaptureEnv*>(env);
        return e->captured ? static_cast<NodeValue*>(e->captured)->tag : -1;
    }
    static void _gcMark_impl(AnyGC* self, int flag) {
        auto* e = static_cast<CaptureEnv*>(self);
        if (e->captured) _gcMark(e->captured, flag);
    }
};

CaptureEnvClassInfo CaptureEnv::_classInfo;

static void CaptureEnv_gcMark(AnyGC* self, int flag) {
    CaptureEnv::_gcMark_impl(self, flag);
}

// ============================================================================
// 模拟生成代码的异步状态机（对齐 AddAsyncStateMachine 模式）
// ============================================================================

struct CounterSMValue;
static bool CounterSM_step(AnyGC* self);
static void CounterSM_gcMark(AnyGC* self, int flag);

struct CounterSMClassInfo : AsyncStateMachineClassInfo<int64_t> {
    CounterSMClassInfo() {
        typeName = "CounterSM";
        step = &CounterSM_step;
        gcMark = &CounterSM_gcMark;
        _parent = &AsyncStateMachine<int64_t>::_baseClassInfo;
    }
};

struct CounterSMValue : AsyncStateMachine<int64_t> {
    int64_t count = 0;
    int64_t target = 3;
    NodeValue* payload = nullptr;  // 模拟 SM 持有的用户对象
    static CounterSMClassInfo _classInfo;
    CounterSMValue() { AnyGC::_classInfo = &_classInfo; }
};

CounterSMClassInfo CounterSMValue::_classInfo;

static bool CounterSM_step(AnyGC* self) {
    auto* sm = static_cast<CounterSMValue*>(self);
    sm->count++;
    if (sm->count >= sm->target) {
        AsyncStateMachine_completeWith(sm, sm->count);
        return true;
    }
    return false;
}

static void CounterSM_gcMark(AnyGC* self, int flag) {
    AsyncStateMachine<int64_t>::_gcMark_impl(self, flag);  // 标记 promise
    auto* sm = static_cast<CounterSMValue*>(self);
    if (sm->payload) _gcMark(sm->payload, flag);
}

// 辅助：模拟生成代码的 X_new 模式
static CounterSMValue* CounterSM_new_helper() {
    auto* sm = GC::allocateLocal(new CounterSMValue());
    sm->target = 3;
    return sm;
}

// ============================================================================
// 测试用例
// ============================================================================

static void test1_loopAllocBaseline() {
    printf("\n--- T1: 循环分配基线（F1 演示：无自动 GC → 线性增长）---\n");
    int base = GC::objectCount();

    for (int round = 0; round < 100; round++) {
        for (int i = 0; i < 100; i++) {
            GC::allocateLocal(new NodeValue());
        }
    }
    int grown = GC::objectCount();
    printf("  分配 10000 个临时对象后: objectCount %d -> %d\n", base, grown);
    EXPECT(grown - base == 10000,
           "无自动 GC：所有临时对象滞留（长程序需显式/自动 collect）");

    _stackScrub();  // 清除循环遗留的陈旧指针槽
    int freed = GC::collect();
    int after = GC::objectCount();
    printf("  collect: freed=%d, objectCount %d -> %d\n", freed, grown, after);
    EXPECT(freed >= 9990 && after - base <= 10,
           "collect 后不可达对象基本全部回收（保守扫描允许少量陈旧栈钉住）");
}

// 不可达环在辅助函数中创建，避免本函数栈槽钉住
static void make_unreachable_cycle() {
    auto* a = GC::allocateLocal(new NodeValue());
    auto* b = GC::allocateLocal(new NodeValue());
    a->left = b;
    b->left = a;
}

static void test2_cycles() {
    printf("\n--- T2: 循环引用 ---\n");
    _collectUntilStable();
    make_unreachable_cycle();
    int freed = _collectUntilStable();
    EXPECT(freed == 2, "不可达循环引用被回收（标记-清除天然处理环）");

    // 可达环：root -> A <-> B
    NodeValue* rootObj = GC::allocateGlobal(new NodeValue());
    auto* a = GC::allocateLocal(new NodeValue());
    auto* b = GC::allocateLocal(new NodeValue());
    rootObj->left = a;
    a->left = b;
    b->left = a;
    _collectUntilStable();  // 清掉上一阶段可能的延迟回收
    freed = GC::collect();
    EXPECT(freed == 0, "可达循环引用存活（无误杀）");
    EXPECT(rootObj->left == a && a->left == b, "可达环结构完整");
}

static void make_dead_closure() {
    auto* payload = GC::allocateLocal(new NodeValue());
    auto* env = GC::allocateLocal(new CaptureEnv(payload));
    (void)env;
}

static void test3_closureCapture() {
    printf("\n--- T3: 闭包捕获对象的可达性 ---\n");
    _collectUntilStable();
    make_dead_closure();
    int freed = _collectUntilStable();
    EXPECT(freed == 2, "闭包与捕获对象均不可达 → 一起回收");

    // 闭包是 root → 捕获的对象必须存活
    auto* payload2 = GC::allocateLocal(new NodeValue());
    payload2->tag = 77;
    auto* env2 = GC::allocateGlobal(new CaptureEnv(payload2));
    freed = GC::collect();
    EXPECT(freed == 0, "root 闭包钉住捕获对象（gcMark 遍历 captured 字段）");
    EXPECT(CaptureEnv::_typedTrampoline(env2) == 77, "捕获对象可正常访问");
}

static StaticList<AnyGC*>* g_t4list = nullptr;  // 数据段持有，不参与栈扫描

static void t4_fill() {
    for (int i = 0; i < 50; i++) {
        g_t4list->_data->_storage.push_back(GC::allocateLocal(new NodeValue()));
    }
}

static void t4_clear() {
    g_t4list->_data->_storage.clear();
}

static void test4_collections() {
    printf("\n--- T4: 集合元素生命周期 ---\n");
    _collectUntilStable();
    int base = GC::objectCount();
    g_t4list = GC::allocateGlobal(new StaticList<AnyGC*>());
    t4_fill();
    GC::collect();
    EXPECT(GC::objectCount() - base == 52, "50 个元素 + Array + List 均存活（无误杀）");

    t4_clear();
    int freed = _collectUntilStable();
    printf("  clear 后 collect: freed=%d\n", freed);
    EXPECT(freed == 50, "clear 后 50 个元素全部可回收（Array gcMark 只标记现存元素）");
}

// SM 完整生命周期在辅助函数中执行
static int64_t run_sm_to_completion() {
    auto* sm = CounterSM_new_helper();
    sm->payload = GC::allocateLocal(new NodeValue());
    Promise<int64_t>* future =
        static_cast<Promise<int64_t>*>(AsyncStateMachine_start(sm));
    return smAwait<int64_t>(future);
}

static void test5_stateMachineHappyPath() {
    printf("\n--- T5: 状态机正常完成 → 无泄漏 ---\n");
    _collectUntilStable();
    int base = GC::objectCount();
    int64_t result = run_sm_to_completion();
    EXPECT(result == 3, "SM 运行完成，结果正确");

    // SM 已完成：观察到完成的 tick 已将其移出调度器
    GlobalScheduler::instance().tick();
    _collectUntilStable();
    int leaked = GC::objectCount() - base;
    printf("  完成后 collect: 相对基线残留=%d\n", leaked);
    EXPECT(leaked == 0, "完成的 SM/Promise/payload 全部回收（keepAlive 随 Promise 一起死）");
}

// 遗弃 SM 的创建在辅助函数中（避免本函数栈槽干扰钉住计数）
static void make_abandoned_sm() {
    CounterSMValue* sm = GC::allocateLocal(new CounterSMValue());
    sm->target = 1000000;  // 永远走不完
    sm->payload = GC::allocateLocal(new NodeValue());
    AsyncStateMachine_start(sm);  // 注册进调度器，但没人再管它
}

static void test6_abandonedPromise() {
    printf("\n--- T6: [F2] 被遗弃的 pending Promise — collect 自动回收 ---\n");
    _collectUntilStable();
    int base = GC::objectCount();
    make_abandoned_sm();
    bool registered = GlobalScheduler::instance().hasActiveWork();
    _collectUntilStable();
    int pinned = GC::objectCount() - base;
    printf("  遗弃后 collect: 钉住=%d, hasActiveWork=%s\n", pinned,
           GlobalScheduler::instance().hasActiveWork() ? "true" : "false");
    EXPECT(registered, "SM 启动后 Promise 已注册调度器");
    EXPECT(pinned == 0,
           "F2 修复：不可达 pending Promise 及 keepAlive 子图被 collect 自动回收");
    EXPECT(!GlobalScheduler::instance().hasActiveWork(),
           "~PromiseBase 自注销清空调度器（drainScheduler 不再死锁）");
}

static void test7_globalReassign() {
    printf("\n--- T7: [F4] 全局变量重复赋值 — 旧模式泄漏 vs removeRoot 修复 ---\n");
    _collectUntilStable();
    int rootsBefore = GC::rootCount();
    int base = GC::objectCount();

    // 旧模式：只 allocateGlobal，不移除旧 root → 旧值永久钉住
    NodeValue* globalVar = nullptr;
    for (int i = 0; i < 10; i++) {
        globalVar = GC::allocateGlobal(new NodeValue());
    }
    GC::collect();
    int pinnedOld = GC::objectCount() - base;
    printf("  旧模式 10 次赋值: rootCount +%d, 钉住=%d\n",
           GC::rootCount() - rootsBefore, pinnedOld);
    EXPECT(pinnedOld == 10, "F4 确认：不移除旧 root 时全部旧值永久钉住");

    // 修复模式（emitter 静态字段赋值现用此模式）：先 removeRoot 再 allocateGlobal
    int rootsMid = GC::rootCount();
    int baseMid = GC::objectCount();
    for (int i = 0; i < 10; i++) {
        GC::removeRoot(globalVar);
        globalVar = GC::allocateGlobal(new NodeValue());
        _collectUntilStable();  // 每轮旧值都应被回收
    }
    int pinnedNew = GC::objectCount() - baseMid;
    printf("  修复模式 10 次赋值: rootCount +%d, 钉住=%d\n",
           GC::rootCount() - rootsMid, pinnedNew);
    EXPECT(pinnedNew == 1 && GC::rootCount() == rootsMid,
           "removeRoot + allocateGlobal：只有当前值钉住，root 集不增长");
    EXPECT(globalVar != nullptr, "当前值仍可用");
}

static CounterSMValue* make_completed_unticked_sm() {
    auto* sm = GC::allocateLocal(new CounterSMValue());
    AsyncStateMachine_start(sm);
    promise_completeTyped(sm->promise, 5LL);  // 手动完成但不 tick
    return nullptr;
}

static void test8_completedUnticked() {
    printf("\n--- T8: 已完成但未 tick 的 Promise — 不再依赖 tick 释放 ---\n");
    _collectUntilStable();
    int base = GC::objectCount();
    make_completed_unticked_sm();
    _collectUntilStable();
    EXPECT(GC::objectCount() == base,
           "F2 修复：已完成未 tick 且不可达的 Promise 直接被 collect 回收（无需等 tick 过滤）");
    EXPECT(!GlobalScheduler::instance().hasActiveWork(), "调度器经析构自注销清空");
}

static void test9_autoCollect() {
    printf("\n--- T9: [F1] 分配阈值自动 GC ---\n");
    GC::setAutoCollectThreshold(500);
    int peak = 0;
    for (int i = 0; i < 5000; i++) {
        GC::allocateLocal(new NodeValue());
        if (GC::objectCount() > peak) peak = GC::objectCount();
    }
    int alive = GC::objectCount();
    printf("  5000 次分配（阈值 500）: 峰值 objectCount=%d, 循环后=%d\n", peak, alive);
    EXPECT(peak < 1500, "自动 collect 控制对象数量（未增长到 5000）");
    EXPECT(alive < 1500, "长循环下内存有界（F1 修复生效）");
    GC::setAutoCollectThreshold(0);  // 恢复：其余测试依赖确定性计数
    _collectUntilStable();
}

int main() {
    printf("═══════════════════════════════════════════\n");
    printf(" C++ GC 语义与泄漏测试（模拟生成代码模式）\n");
    printf("═══════════════════════════════════════════\n");

    // 单元测试需要确定性对象计数：关闭自动 GC（T9 单独开启验证）
    GC::setAutoCollectThreshold(0);

    test1_loopAllocBaseline();
    test2_cycles();
    test3_closureCapture();
    test4_collections();
    test5_stateMachineHappyPath();
    test6_abandonedPromise();
    test7_globalReassign();
    test8_completedUnticked();
    test9_autoCollect();

    // 终态：T6 遗弃 SM 已被自动回收，仅剩显式 root
    int finalAlive = GC::objectCount();
    printf("\n──────────────────────────────────────────\n");
    printf("终态: objectCount=%d, rootCount=%d\n", finalAlive, GC::rootCount());
    printf("（含 T2/T7 的 root 子图 —— 均为显式注册的合法 root）\n");
    printf("结果: %d passed, %d failed\n", g_pass, g_fail);
    return g_fail == 0 ? 0 : 1;
}
