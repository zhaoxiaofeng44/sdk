// ============================================================================
// gc_cpp_escape_uaf_test.cpp — 逃逸场景修复验证（需 ASan 运行）
// ============================================================================
// 每个场景对应一种"对象逃逸到 GC 视野之外"的历史缺陷。修复后所有场景
// 必须在 ASan 下**干净退出（exit 0，无 ASan 报告）**：
//
//   U1 [F3 已修] 单例/静态字段：emitter 现用 allocateGlobal 注册为 root，
//      collect 不再回收仍被全局变量引用的对象
//   U2 [F5 已修] 裸 promise_then：运行时已补 addKeepAlive(self)，
//      上游 Promise 在 nextPromise 存活期间不被回收
//   U3 [F6 已修] 栈上唯一引用：GC::collect 内置保守栈扫描，
//      栈变量持有的对象不被回收
//   U4 [F2 已修] 被遗弃的 pending Promise：调度器不再钉住 active/ready
//      Promise，collect 自动回收，~PromiseBase 析构自注销调度器
//   U5 [F2 配套] 栈持有的 pending Promise 必须在 collect 后存活并可继续驱动
//
// 用法: ./gc_cpp_escape_uaf_test <U1|U2|U3|U4>
// ============================================================================

#include "dart2cpp_lowered.h"
#include <cstdio>
#include <cstring>

// ── 模拟生成代码的用户类 ──
struct NodeValue;
static void Node_gcMark(AnyGC* self, int flag);

struct NodeClassInfo : ClassInfo {
    NodeClassInfo() {
        typeName = "Node";
        gcMark = &Node_gcMark;
    }
};

struct NodeValue : AnyGC {
    int64_t tag = 0;
    static NodeClassInfo _classInfo;
    NodeValue() { AnyGC::_classInfo = &_classInfo; }
};

NodeClassInfo NodeValue::_classInfo;

static void Node_gcMark(AnyGC* self, int flag) {}

// ── U1: 单例模式 — 修复后模式（emitter 现在生成 allocateGlobal）──
NodeValue* g_singleton = nullptr;

static void scenario_U1_singleton() {
    g_singleton = GC::allocateGlobal(new NodeValue());  // F3 修复后的生成模式
    g_singleton->tag = 42;

    int freed = GC::collect();  // g_singleton 是 root → 不被回收
    printf("U1: collect freed=%d, singleton %s\n", freed,
           g_singleton ? "存活" : "被错误回收");
    if (!g_singleton || g_singleton->tag != 42) {
        printf("U1: FAILED — root 对象被回收\n");
        exit(1);
    }
    printf("U1: PASS — root 注册保护了单例\n");
}

// ── U2: 裸 promise_then — 运行时已补 keepAlive ──
static void scenario_U2_rawThen() {
    auto* upstream = GC::allocateLocal(new Promise<int64_t>());  // pending，未注册调度器
    auto* next = promise_then<int64_t>(
        upstream, std::function<AnyGC*(int64_t)>(
                      [](int64_t v) -> AnyGC* { return _box(v + 1); }));

    GC::collect();  // F5 修复：upstream 被 next->keepAlive 钉住，不回收

    // 完成上游并 tick：next->onTick 安全读取 upstream
    promise_completeTyped(upstream, 41LL);
    GlobalScheduler::instance().tick();

    bool ok = next->state == PromiseBase::COMPLETED &&
              dynAs<int64_t>(next->result) == 42;
    printf("U2: %s — 上游 Promise 经 keepAlive 存活，then 链结果=%s\n",
           ok ? "PASS" : "FAILED",
           ok ? "42" : "?");
    if (!ok) exit(1);
}

// ── U3: 栈上唯一引用 — 保守栈扫描保护 ──
static void scenario_U3_stackResult() {
    AnyGC* result;
    {
        auto* p = Promise<int64_t>::resolved(42);
        result = p->result;  // IntBox：被栈变量引用
    }
    GC::collect();  // F6 修复：栈扫描发现 result 指针 → Box 存活

    int64_t v = static_cast<IntBox*>(result)->value;
    printf("U3: %s — 栈引用经保守扫描保活，value=%lld\n",
           v == 42 ? "PASS" : "FAILED", (long long)v);
    if (v != 42) exit(1);
}

// ── U4: 遗弃的 pending Promise — F2 修复：collect 自动回收 ──
// 调度器不再钉住 active/ready Promise；不可达的 pending Promise 被 collect
// 回收，析构时经 ~PromiseBase 自注销调度器（无需显式 unregisterPromise）
static void u4_create() {
    auto* promise = GC::allocateLocal(new Promise<int64_t>());
    GlobalScheduler::instance().registerActivePromise(promise);
    promise->addKeepAlive(GC::allocateLocal(new NodeValue()));
}

// 覆写陈旧栈槽（保守扫描会把已退出帧中的残留指针当作 root）
static void u4_scrub() {
    volatile char buf[8192];
    for (size_t i = 0; i < sizeof(buf); i++) buf[i] = static_cast<char>(i);
}

static void scenario_U4_abandoned() {
    int base = GC::objectCount();
    u4_create();
    bool registered = GlobalScheduler::instance().hasActiveWork();

    u4_scrub();
    GC::collect();  // Promise 不可达 → 回收 → 析构自注销
    int pinned = GC::objectCount() - base;

    bool ok = registered && pinned == 0 &&
              !GlobalScheduler::instance().hasActiveWork();
    printf("U4: %s — 遗弃后 collect 自动回收（钉住=%d），调度器自注销（hasActiveWork=%s）\n",
           ok ? "PASS" : "FAILED", pinned,
           GlobalScheduler::instance().hasActiveWork() ? "true" : "false");
    if (!ok) exit(1);
}

// ── U5: 栈持有的 pending Promise — 必须存活且继续被驱动 ──
static void scenario_U5_heldPending() {
    int base = GC::objectCount();
    auto* promise = GC::allocateLocal(new Promise<int64_t>());
    GlobalScheduler::instance().registerActivePromise(promise);
    promise->addKeepAlive(GC::allocateLocal(new NodeValue()));

    GC::collect();  // promise 被栈局部变量持有 → 存活
    bool alive = (GC::objectCount() - base == 2) &&
                 promise->state == PromiseBase::PENDING &&
                 GlobalScheduler::instance().hasActiveWork();

    // 清理：完成后 tick 过滤，对象随函数退出变为可回收
    promise_completeTyped(promise, 1LL);
    GlobalScheduler::instance().tick();

    printf("U5: %s — 栈持有的 pending Promise 在 collect 后存活（keepAlive 子图完整）\n",
           alive ? "PASS" : "FAILED");
    if (!alive) exit(1);
}

int main(int argc, char** argv) {
    // 场景测试需要确定性对象计数：关闭自动 GC
    GC::setAutoCollectThreshold(0);

    if (argc < 2) {
        printf("用法: %s <U1|U2|U3|U4|U5>\n", argv[0]);
        return 2;
    }
    if (strcmp(argv[1], "U1") == 0) scenario_U1_singleton();
    else if (strcmp(argv[1], "U2") == 0) scenario_U2_rawThen();
    else if (strcmp(argv[1], "U3") == 0) scenario_U3_stackResult();
    else if (strcmp(argv[1], "U4") == 0) scenario_U4_abandoned();
    else if (strcmp(argv[1], "U5") == 0) scenario_U5_heldPending();
    else {
        printf("未知场景: %s\n", argv[1]);
        return 2;
    }
    return 0;
}
