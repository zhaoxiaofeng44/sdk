// ============================================================================
// gc_cpp_leak_test.cpp — C++ 运行时 GC 语义与泄漏测试（精确根）
// ============================================================================
// 模拟 cpp_emitter 生成的代码模式（struct + ClassInfo + gcMark、闭包环境、
// AsyncStateMachine、Promise 链），验证 Cheney Minor + Full 标记清除，
// 以及 GC::RootPin 精确根的回收能力：
//
//   T1 循环分配 + collect → 回收（基线）
//   T2 循环引用：不可达环被回收 / 可达环存活
//   T3 闭包捕获：闭包死 → 捕获对象回收；闭包活 → 捕获对象存活
//   T4 集合清空后元素可回收
//   T5 状态机正常完成 → SM + Promise 无泄漏
//   T6 [F2] 被遗弃的 pending Promise：collect 自动回收
//   T7 [F4] 全局变量重复赋值：removeRoot 修复模式
//   T8 已完成未 tick 的 Promise：不可达即回收
//   T9 [F1] 分配频率自动 GC：长循环下对象数量有界
//   T15 精确根（RootPin）保住局部存活对象
//
// 栈局部若在 collect 后仍需访问，必须 GC::RootPin；辅助函数内分配的
// 临时对象在返回后自然不可达，单次 collect 即可回收。
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

// 精确根下单次 Full 即可回收不可达对象（辅助函数返回后无栈钉住）。
static int _collectUntilStable() {
    return GC::collect();
}

// ============================================================================
// 模拟生成代码的用户类：NodeValue（树节点，带两个子引用）
// ============================================================================

struct NodeValue;
static void Node_gcMark(AnyGC* self, int flag);

struct NodeClassInfo : ClassInfo {
    NodeClassInfo();
};

struct NodeValue : AnyGC {
    NodeValue* left = nullptr;
    NodeValue* right = nullptr;
    int64_t tag = 0;
    static NodeClassInfo _classInfo;
    NodeValue() { AnyGC::_classInfo = &_classInfo; }
};

inline NodeClassInfo::NodeClassInfo() {
    typeName = "Node";
    destroy = &_gcDestroy<NodeValue>;
    gcMark = &Node_gcMark;
}

NodeClassInfo NodeValue::_classInfo;

static void Node_gcMark(AnyGC* self, int flag) {
    auto* n = static_cast<NodeValue*>(self);
    if (n->left) _gcEdge(n->left, flag);
    if (n->right) _gcEdge(n->right, flag);
}

// ============================================================================
// 模拟生成代码的闭包环境：捕获一个 AnyGC*（对齐 ClosureEnv_N 模式）
// ============================================================================

struct CaptureEnv;
static void CaptureEnv_gcMark(AnyGC* self, int flag);

struct CaptureEnvClassInfo : ClassInfo {
    CaptureEnvClassInfo();
};

struct CaptureEnv : TypeFunction0<int64_t> {
    AnyGC* captured = nullptr;
    static CaptureEnvClassInfo _classInfo;
    CaptureEnv(AnyGC* cap) : captured(cap) {
        this->fnPtr = &_trampoline;
        AnyGC::_classInfo = &_classInfo;
    }
    static AnyGC* _trampoline(AnyGC* env) {
        auto* e = static_cast<CaptureEnv*>(env);
        return _box(e->captured ? static_cast<NodeValue*>(e->captured)->tag : -1);
    }
    static void _gcMark_impl(AnyGC* self, int flag) {
        auto* e = static_cast<CaptureEnv*>(self);
        if (e->captured) _gcEdge(e->captured, flag);
    }
};

inline CaptureEnvClassInfo::CaptureEnvClassInfo() {
    typeName = "Closure";
    destroy = &_gcDestroy<CaptureEnv>;
    gcMark = &CaptureEnv_gcMark;
}

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
    CounterSMClassInfo();
};

struct CounterSMValue : AsyncStateMachine<int64_t> {
    int64_t count = 0;
    int64_t target = 3;
    NodeValue* payload = nullptr;  // 模拟 SM 持有的用户对象
    static CounterSMClassInfo _classInfo;
    CounterSMValue() { AnyGC::_classInfo = &_classInfo; }
};

inline CounterSMClassInfo::CounterSMClassInfo() {
    typeName = "CounterSM";
    destroy = &_gcDestroy<CounterSMValue>;
    step = &CounterSM_step;
    gcMark = &CounterSM_gcMark;
    _parent = &AsyncStateMachine<int64_t>::_baseClassInfo;
}

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
    if (sm->payload) _gcEdge(sm->payload, flag);
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

    int freed = GC::collect();
    int after = GC::objectCount();
    printf("  collect: freed=%d, objectCount %d -> %d\n", freed, grown, after);
    EXPECT(freed >= 9990 && after - base <= 10,
           "collect 后不可达对象基本全部回收");
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
    GC::RootPin pin_a(a);
    GC::RootPin pin_b(b);
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
    EXPECT(dynAs<int64_t>(CaptureEnv::_trampoline(env2)) == 77, "捕获对象可正常访问");
}

static List<AnyGC*>* g_t4list = nullptr;  // 数据段持有，不参与栈扫描

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
    g_t4list = GC::allocateGlobal(new List<AnyGC*>());
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
    return sm_await<int64_t>(future);
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
    EXPECT(pinnedNew <= 1 && GC::rootCount() == rootsMid,
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
    // 允许基线因 nursery 计数/前序 root 子图略降；关键是不增长、调度器清空
    EXPECT(GC::objectCount() <= base,
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

// ── T10+: Cheney 半空间扩容 / 搬迁 / 大对象 ──

struct FatNodeValue;
static void FatNode_gcMark(AnyGC* self, int flag);

struct FatNodeClassInfo : ClassInfo {
    FatNodeClassInfo();
};

/// 半空间友好的“胖”节点：垫片让单对象约 256B，便于快速填满小半空间
struct FatNodeValue : AnyGC {
    FatNodeValue* next = nullptr;
    int64_t tag = 0;
    char pad[224]{};
    static FatNodeClassInfo _classInfo;
    FatNodeValue() { AnyGC::_classInfo = &_classInfo; }
};

inline FatNodeClassInfo::FatNodeClassInfo() {
    typeName = "FatNode";
    destroy = &_gcDestroy<FatNodeValue>;
    gcMark = &FatNode_gcMark;
}

FatNodeClassInfo FatNodeValue::_classInfo;

static void FatNode_gcMark(AnyGC* self, int flag) {
    auto* n = static_cast<FatNodeValue*>(self);
    if (n->next) _gcEdge(n->next, flag);
}

struct BigBoxValue : AnyGC {
    char payload[4096];
    int64_t magic = 0;
    static ClassInfo _classInfo;
    BigBoxValue() {
        magic = 0xC0FFEE;
        AnyGC::_classInfo = &_classInfo;
    }
};
inline ClassInfo BigBoxValue::_classInfo = []() {
    ClassInfo ci;
    ci.typeName = "BigBox";
    ci.destroy = &_gcDestroy<BigBoxValue>;
    return ci;
}();

static void test10_semiSpaceGrow() {
    printf("\n--- T10: 半空间扩容（小 nursery + 存活压力）---\n");
    GC::reset();
    GC::setAutoCollectThreshold(0);
    GC::setSemiSpaceSizeForTest(64 * 1024);  // 64KB 半空间

    size_t cap0 = GC::semiCapacity();
    // 首次分配触发建堆
    auto* head = GC::allocateLocal(new FatNodeValue());
    GC::RootPin pin_head(head);
    head->tag = 1;
    if (cap0 == 0) cap0 = GC::semiCapacity();
    printf("  初始半空间 capacity=%zu used=%zu\n", GC::semiCapacity(), GC::nurseryUsed());
    EXPECT(GC::semiCapacity() == 64 * 1024 || GC::semiCapacity() >= 64 * 1024,
           "测试半空间按设定大小创建");

    // 用 root 链钉住大量存活对象，填满并超过半空间 → 触发 collect + 扩容
    FatNodeValue* root = GC::allocateGlobal(new FatNodeValue());
    root->tag = 100;
    FatNodeValue* cur = root;
    GC::RootPin pin_cur(cur);
    int live = 1;
    for (int i = 0; i < 800; i++) {  // ~800 * 256B ≈ 200KB > 64KB
        auto* n = GC::allocateLocal(new FatNodeValue());
        n->tag = 200 + i;
        cur->next = n;
        cur = n;
        live++;
    }
    size_t cap1 = GC::semiCapacity();
    printf("  分配存活链后 capacity=%zu used=%zu objects=%d\n",
           cap1, GC::nurseryUsed(), GC::objectCount());
    EXPECT(cap1 > cap0 && cap1 >= 128 * 1024,
           "半空间在存活压力下扩容（> 初始）");

    // 数据完好：遍历链
    int walked = 0;
    for (FatNodeValue* p = root; p; p = p->next) walked++;
    EXPECT(walked == live, "扩容后存活对象链完整可遍历");
    EXPECT(root->tag == 100, "root 对象内容在扩容后保持");

    (void)head;
    GC::reset();
    GC::setSemiSpaceSizeForTest(0);  // 恢复默认（0 → kDefaultSemiSize）
}

static void test11_cheneyMoveKeepsGraph() {
    printf("\n--- T11: Cheney 搬迁后指针图仍正确 ---\n");
    GC::reset();
    GC::setAutoCollectThreshold(0);
    GC::setSemiSpaceSizeForTest(128 * 1024);

    // 栈上持有局部节点：RootPin 钉住并在 evacuate 后 fixup 槽
    auto* a = GC::allocateLocal(new NodeValue());
    auto* b = GC::allocateLocal(new NodeValue());
    auto* c = GC::allocateLocal(new NodeValue());
    GC::RootPin pin_a(a);
    GC::RootPin pin_b(b);
    GC::RootPin pin_c(c);
    a->tag = 11; b->tag = 22; c->tag = 33;
    a->left = b;
    b->left = c;
    uintptr_t addrBefore = reinterpret_cast<uintptr_t>(b);

    // 制造大量垃圾迫使 evacuate
    for (int i = 0; i < 2000; i++) {
        GC::allocateLocal(new NodeValue());
    }
    GC::collect();

    EXPECT(a->tag == 11 && b->tag == 22 && c->tag == 33, "搬迁后节点字段完好");
    EXPECT(a->left == b && b->left == c, "搬迁后 left 指针仍指向正确对象");
    // 地址可能变（被 evacuate）也可能因钉住不变；只要语义正确即可
    printf("  b 地址: before=%p after=%p nursery=%d\n",
           reinterpret_cast<void*>(addrBefore), static_cast<void*>(b),
           GC::inNursery(b) ? 1 : 0);
    EXPECT(a->left->left->tag == 33, "经两跳指针访问正确");

    GC::reset();
    GC::setSemiSpaceSizeForTest(0);
}

static void test12_largeObjectImmovable() {
    printf("\n--- T12: 超大对象不进入半空间、地址稳定 ---\n");
    GC::reset();
    GC::setAutoCollectThreshold(0);

    auto* big = GC::allocateLocal(new BigBoxValue());
    GC::RootPin pin_big(big);
    uintptr_t addr0 = reinterpret_cast<uintptr_t>(big);
    EXPECT(!GC::inNursery(big), "≥4KB 对象不在半空间（大对象堆）");
    EXPECT(big->magic == 0xC0FFEE, "大对象内容正确");

    for (int i = 0; i < 500; i++) GC::allocateLocal(new NodeValue());
    GC::collect();
    EXPECT(reinterpret_cast<uintptr_t>(big) == addr0, "大对象 collect 后地址不变");
    EXPECT(big->magic == 0xC0FFEE, "大对象 collect 后内容不变");

    GC::reset();
}

static void test13_globalStableNurseryLocalMoves() {
    printf("\n--- T13: Global 提升后地址稳定 ---\n");
    GC::reset();
    GC::setAutoCollectThreshold(0);
    GC::setSemiSpaceSizeForTest(64 * 1024);

    auto* g = GC::allocateGlobal(new NodeValue());
    g->tag = 55;
    uintptr_t gAddr = reinterpret_cast<uintptr_t>(g);
    EXPECT(!GC::inNursery(g), "allocateGlobal 提升出半空间");

    for (int i = 0; i < 400; i++) {
        auto* n = GC::allocateLocal(new FatNodeValue());
        n->tag = i;
    }
    size_t cap = GC::semiCapacity();
    GC::collect();
    EXPECT(reinterpret_cast<uintptr_t>(g) == gAddr && g->tag == 55,
           "Global 根在半空间扩容/collect 后仍稳定");
    printf("  global=%p capacity=%zu\n", static_cast<void*>(g), cap);

    GC::reset();
    GC::setSemiSpaceSizeForTest(0);
}

static void test14_allocTriggersGrowWithoutLostLive() {
    printf("\n--- T14: 分配路径触发扩容且不丢存活对象 ---\n");
    GC::reset();
    GC::setAutoCollectThreshold(0);
    GC::setSemiSpaceSizeForTest(32 * 1024);

    // 全部存活：挂到 root 链上，分配到超过初始半空间
    FatNodeValue* root = GC::allocateGlobal(new FatNodeValue());
    FatNodeValue* cur = root;
    GC::RootPin pin_cur(cur);
    const int N = 500;
    for (int i = 0; i < N; i++) {
        auto* n = GC::allocateLocal(new FatNodeValue());
        n->tag = i;
        cur->next = n;
        cur = n;
    }
    size_t cap = GC::semiCapacity();
    printf("  存活 %d 个 FatNode 后 capacity=%zu used=%zu\n",
           N + 1, cap, GC::nurseryUsed());
    EXPECT(cap > 32 * 1024, "持续分配存活对象触发半空间扩容");

    int sum = 0;
    for (FatNodeValue* p = root->next; p; p = p->next) sum += static_cast<int>(p->tag);
    EXPECT(sum == (N - 1) * N / 2, "扩容过程中无对象丢失（tag 求和正确）");

    GC::reset();
    GC::setSemiSpaceSizeForTest(0);
}

static void test15_preciseRootsKeepLocals() {
    printf("\n--- T15: 精确根 RootPin 保住局部 ---\n");
    GC::reset();
    GC::setAutoCollectThreshold(0);
    GC::setSemiSpaceSizeForTest(64 * 1024);

    NodeValue* live = GC::allocateLocal(new NodeValue());
    live->tag = 42;
    GC::RootPin pin_live(live);

    for (int i = 0; i < 200; i++) {
        GC::allocateLocal(new NodeValue());
    }
    int dead = GC::collectMinor();
    EXPECT(dead > 0, "未 pin 短命对象被 Minor 回收");
    EXPECT(live != nullptr && live->tag == 42, "RootPin 保住局部 live 且可读");

    for (int i = 0; i < 100; i++) {
        GC::allocateLocal(new NodeValue());
    }
    GC::collect();
    EXPECT(live != nullptr && live->tag == 42, "RootPin 在 Full collect 后仍保住 live");

    GC::reset();
    GC::setSemiSpaceSizeForTest(0);
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
    test10_semiSpaceGrow();
    test11_cheneyMoveKeepsGraph();
    test12_largeObjectImmovable();
    test13_globalStableNurseryLocalMoves();
    test14_allocTriggersGrowWithoutLostLive();
    test15_preciseRootsKeepLocals();

    // 终态：T6 遗弃 SM 已被自动回收，仅剩显式 root
    int finalAlive = GC::objectCount();
    printf("\n──────────────────────────────────────────\n");
    printf("终态: objectCount=%d, rootCount=%d\n", finalAlive, GC::rootCount());
    printf("（含 T2/T7 的 root 子图 —— 均为显式注册的合法 root）\n");
    printf("结果: %d passed, %d failed\n", g_pass, g_fail);
    return g_fail == 0 ? 0 : 1;
}
