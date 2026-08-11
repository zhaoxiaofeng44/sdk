// ============================================================================
// gc_perf_benchmark.cpp — GC 运行时性能基准（批量标记 / collect / 分配）
// ============================================================================
// 目标：在正确性前提下量化 Cheney+标记 GC 的吞吐，重点覆盖：
//   B1 高垃圾比：少量存活 + 大量短命对象 → collect 吞吐
//   B2 高存活比：长链几乎全活 → 批量 mark + evacuate 压力
//   B3 混合存活：约 10% 钉住，90% 可回收
//   B4 宽扇出图：每个节点多子指针 → mark 访问密集
//   B5 稳态重复 collect：存活集不变，测纯 mark/evacuate 开销
//   B6 自动 GC 分配吞吐：阈值触发下的持续分配
//
// 用法:
//   clang++ -std=c++17 -O2 -I lib/platform/cpp test/gc_perf_benchmark.cpp -o gc_perf
//   ./gc_perf
// ============================================================================

#include "dart2cpp_lowered.h"

#include <chrono>
#include <cstdio>
#include <cstring>
#include <string>
#include <vector>

using Clock = std::chrono::steady_clock;

static int g_pass = 0;
static int g_fail = 0;

#define EXPECT(cond, msg)                                                  \
    do {                                                                   \
        if (cond) {                                                        \
            g_pass++;                                                      \
            printf("  ✅ %s\n", msg);                                      \
        } else {                                                           \
            g_fail++;                                                      \
            printf("  ❌ %s  (line %d)\n", msg, __LINE__);                 \
        }                                                                  \
    } while (0)

static double msSince(Clock::time_point t0) {
    return std::chrono::duration<double, std::milli>(Clock::now() - t0).count();
}

static void reportRate(const char* label, int ops, double ms) {
    double opsPerSec = ms > 0 ? (ops * 1000.0 / ms) : 0;
    printf("  ⏱  %s: %.2f ms  (%.0f ops/s, n=%d)\n", label, ms, opsPerSec, ops);
}

// ── 基准用节点类型 ──

struct PerfNode;
static void PerfNode_gcMark(AnyGC* self, int flag);

struct PerfNodeClassInfo : ClassInfo {
    PerfNodeClassInfo();
};

struct PerfNode : AnyGC {
    static constexpr int kFanout = 8;
    PerfNode* child[kFanout]{};
    PerfNode* next = nullptr;
    int64_t tag = 0;
    static PerfNodeClassInfo _classInfo;
    PerfNode() { AnyGC::_classInfo = &_classInfo; }
};

inline PerfNodeClassInfo::PerfNodeClassInfo() {
    typeName = "PerfNode";
    destroy = &_gcDestroy<PerfNode>;
    gcMark = &PerfNode_gcMark;
}

PerfNodeClassInfo PerfNode::_classInfo;

static void PerfNode_gcMark(AnyGC* self, int flag) {
    auto* n = static_cast<PerfNode*>(self);
    for (int i = 0; i < PerfNode::kFanout; i++) {
        if (n->child[i]) _gcEdge(n->child[i], flag);
    }
    if (n->next) _gcEdge(n->next, flag);
}

/// 链尾句柄：tip 存在不可移动 root 的堆字段里，避免 -O2 下局部指针仅在寄存器、
/// GC 搬迁后未 fixup 导致写穿到 from-space 旧副本。
struct TipHolder;
static void TipHolder_gcMark(AnyGC* self, int flag);

struct TipHolderClassInfo : ClassInfo {
    TipHolderClassInfo();
};

struct TipHolder : AnyGC {
    PerfNode* tip = nullptr;
    static TipHolderClassInfo _classInfo;
    TipHolder() { AnyGC::_classInfo = &_classInfo; }
};

inline TipHolderClassInfo::TipHolderClassInfo() {
    typeName = "TipHolder";
    destroy = &_gcDestroy<TipHolder>;
    gcMark = &TipHolder_gcMark;
}

TipHolderClassInfo TipHolder::_classInfo;

static void TipHolder_gcMark(AnyGC* self, int flag) {
    auto* h = static_cast<TipHolder*>(self);
    if (h->tip) _gcEdge(h->tip, flag);
}

static void benchSetup() {
    GC::reset();
    GC::setAutoCollectThreshold(0);
    GC::setSemiSpaceSizeForTest(0);  // 默认 2MB
}

/// 在可能触发 GC 的分配之后，通过 tip holder 安全追加节点
static PerfNode* appendNode(TipHolder* hold, int64_t tag) {
    auto* n = GC::allocateLocal(new PerfNode());
    n->tag = tag;
    hold->tip->next = n;
    hold->tip = n;
    return n;
}

// ── B1: 高垃圾比 ──

static void bench1_highGarbage() {
    printf("\n=== B1: 高垃圾比（1 存活 root + 大量短命）===\n");
    benchSetup();

    auto* keep = GC::allocateGlobal(new PerfNode());
    keep->tag = 1;

    const int N = 50000;
    auto tAlloc = Clock::now();
    for (int i = 0; i < N; i++) {
        GC::allocateLocal(new PerfNode())->tag = i;
    }
    double allocMs = msSince(tAlloc);
    reportRate("alloc dead objects", N, allocMs);

    int before = GC::objectCount();
    auto tGc = Clock::now();
    int freed = GC::collect();
    double gcMs = msSince(tGc);
    reportRate("collect (mostly dead)", before, gcMs);

    EXPECT(keep->tag == 1, "唯一存活 root 内容完好");
    // 分配过程中 nursery 满会穿插 collect，故 freed 相对「本轮开始时」的存活数，而非总分配数 N
    EXPECT(freed >= before - 5, "本轮短命对象基本被回收");
    EXPECT(GC::objectCount() <= 5, "collect 后对象数接近 1（root）");
    // 宽松性能门槛：50k 对象一轮 collect 应在数秒内（防极端回退）
    EXPECT(gcMs < 5000.0, "高垃圾 collect 在合理时间内完成");
}

// ── B2: 高存活比（长链）──

static void bench2_highLiveChain() {
    printf("\n=== B2: 高存活比（长链批量 mark）===\n");
    benchSetup();

    const int N = 20000;
    auto* root = GC::allocateGlobal(new PerfNode());
    root->tag = 0;
    auto* hold = GC::allocateGlobal(new TipHolder());
    hold->tip = root;
    auto tBuild = Clock::now();
    for (int i = 1; i < N; i++) {
        appendNode(hold, i);
    }
    double buildMs = msSince(tBuild);
    reportRate("build live chain", N, buildMs);

    // 预热一轮
    GC::collect();

    const int rounds = 20;
    auto tGc = Clock::now();
    int totalFreed = 0;
    for (int r = 0; r < rounds; r++) {
        totalFreed += GC::collect();
    }
    double gcMs = msSince(tGc);
    reportRate("collect live chain x20", N * rounds, gcMs);

    // 校验链完整
    int walked = 0;
    int64_t sum = 0;
    for (PerfNode* p = root; p; p = p->next) {
        sum += p->tag;
        walked++;
    }
    EXPECT(walked == N, "长链在多次 collect 后仍完整");
    EXPECT(sum == static_cast<int64_t>(N - 1) * N / 2, "长链 tag 求和正确（无丢对象）");
    EXPECT(totalFreed == 0, "纯存活集重复 collect 不误回收");
    EXPECT(gcMs < 10000.0, "高存活批量 mark 在合理时间内完成");
}

// ── B3: 混合存活 ──

static void bench3_mixedLiveRatio() {
    printf("\n=== B3: 混合存活（~10%% 钉住）===\n");
    benchSetup();

    const int liveN = 2000;
    const int deadN = 18000;
    auto* root = GC::allocateGlobal(new PerfNode());
    auto* hold = GC::allocateGlobal(new TipHolder());
    hold->tip = root;
    for (int i = 0; i < liveN; i++) {
        appendNode(hold, i);
    }
    for (int i = 0; i < deadN; i++) {
        GC::allocateLocal(new PerfNode())->tag = -1;
    }

    int before = GC::objectCount();
    auto tGc = Clock::now();
    int freed = GC::collect();
    double gcMs = msSince(tGc);
    reportRate("collect mixed", before, gcMs);

    int walked = 0;
    for (PerfNode* p = root; p; p = p->next) walked++;
    EXPECT(walked == liveN + 1, "混合场景存活链完整");
    EXPECT(freed >= before - (liveN + 1) - 10, "混合场景短命对象基本回收");
    EXPECT(GC::objectCount() <= liveN + 5, "混合场景 collect 后接近存活集大小");
    EXPECT(gcMs < 5000.0, "混合场景 collect 在合理时间内完成");
}

// ── B4: 宽扇出图 ──

static void bench4_wideFanout() {
    printf("\n=== B4: 宽扇出图（每节点 %d 子）===\n", PerfNode::kFanout);
    benchSetup();

    // 完全 8 叉树，深度 4 → (8^5-1)/7 ≈ 4681 节点
    const int depth = 4;
    std::vector<PerfNode*> level;
    auto* root = GC::allocateGlobal(new PerfNode());
    root->tag = 0;
    level.push_back(root);
    int total = 1;
    auto tBuild = Clock::now();
    for (int d = 0; d < depth; d++) {
        std::vector<PerfNode*> next;
        for (PerfNode* p : level) {
            for (int i = 0; i < PerfNode::kFanout; i++) {
                auto* c = GC::allocateLocal(new PerfNode());
                c->tag = total++;
                p->child[i] = c;
                next.push_back(c);
            }
        }
        level.swap(next);
    }
    double buildMs = msSince(tBuild);
    reportRate("build fanout tree", total, buildMs);

    GC::collect();  // 预热
    const int rounds = 30;
    auto tGc = Clock::now();
    for (int r = 0; r < rounds; r++) GC::collect();
    double gcMs = msSince(tGc);
    reportRate("collect fanout x30", total * rounds, gcMs);

    // 抽样校验：root 的每个 child 可达
    bool ok = true;
    for (int i = 0; i < PerfNode::kFanout; i++) {
        if (!root->child[i] || root->child[i]->tag <= 0) ok = false;
    }
    EXPECT(ok, "扇出树根子节点在 collect 后仍可达");
    EXPECT(GC::objectCount() >= total, "扇出树对象未被误回收");
    EXPECT(gcMs < 10000.0, "宽扇出批量 mark 在合理时间内完成");
}

// ── B5: 稳态重复 collect ──

static void bench5_steadyCollect() {
    printf("\n=== B5: 稳态存活集重复 collect（纯 mark/evacuate）===\n");
    benchSetup();

    const int N = 10000;
    auto* root = GC::allocateGlobal(new PerfNode());
    auto* hold = GC::allocateGlobal(new TipHolder());
    hold->tip = root;
    for (int i = 0; i < N; i++) {
        appendNode(hold, i);
    }
    GC::collect();

    const int rounds = 50;
    auto tGc = Clock::now();
    for (int r = 0; r < rounds; r++) {
        int freed = GC::collect();
        if (freed != 0) {
            printf("  ⚠ round %d freed=%d (expected 0)\n", r, freed);
        }
    }
    double gcMs = msSince(tGc);
    double perCollect = gcMs / rounds;
    reportRate("steady collect x50", N * rounds, gcMs);
    printf("  ⏱  avg per collect: %.3f ms (live≈%d)\n", perCollect, N + 1);

    EXPECT(root->next != nullptr && root->next->tag == 0, "稳态 collect 后链头完好");
    EXPECT(perCollect < 200.0, "单轮稳态 collect 平均耗时合理");
}

// ── B6: 自动 GC 分配吞吐 ──

static void bench6_autoCollectAlloc() {
    printf("\n=== B6: 自动 GC 下持续分配吞吐 ===\n");
    benchSetup();
    GC::setAutoCollectThreshold(2000);

    // 少量长期存活，避免半空间被无根垃圾撑爆后只测大对象路径
    auto* root = GC::allocateGlobal(new PerfNode());
    auto* hold = GC::allocateGlobal(new TipHolder());
    hold->tip = root;
    for (int i = 0; i < 100; i++) {
        appendNode(hold, i);
    }

    const int N = 100000;
    auto t0 = Clock::now();
    for (int i = 0; i < N; i++) {
        GC::allocateLocal(new PerfNode())->tag = i;
    }
    double ms = msSince(t0);
    reportRate("alloc with auto-GC", N, ms);
    printf("  终态 objectCount=%d capacity=%zu\n",
           GC::objectCount(), GC::semiCapacity());

    EXPECT(root->next != nullptr, "自动 GC 下长期存活链仍在");
    EXPECT(GC::objectCount() < N / 2, "自动 GC 显著抑制对象积压");
    EXPECT(ms < 30000.0, "10 万次带自动 GC 的分配在合理时间内完成");

    GC::setAutoCollectThreshold(0);
}

// ── B7: batch mark 微基准（同图多次 collect）──

static void bench7_batchMarkMicro() {
    printf("\n=== B7: batch mark 微基准（同图 100 轮 collect）===\n");
    benchSetup();

    // 中等规模扇出 + 链，模拟真实程序里「一批对象一起被 mark」
    const int chain = 5000;
    auto* root = GC::allocateGlobal(new PerfNode());
    auto* hold = GC::allocateGlobal(new TipHolder());
    hold->tip = root;
    for (int i = 0; i < chain; i++) {
        appendNode(hold, i);
        // 每个节点再挂 2 个叶子；写 tip 堆字段，避免 n 局部指针在后续 alloc 触发 GC 后失效
        auto* c0 = GC::allocateLocal(new PerfNode());
        c0->tag = i * 2;
        hold->tip->child[0] = c0;
        auto* c1 = GC::allocateLocal(new PerfNode());
        c1->tag = i * 2 + 1;
        hold->tip->child[1] = c1;
    }
    int live = GC::objectCount();
    GC::collect();

    const int rounds = 100;
    auto t0 = Clock::now();
    for (int r = 0; r < rounds; r++) GC::collect();
    double ms = msSince(t0);
    double marksPerSec = ms > 0 ? (live * rounds * 1000.0 / ms) : 0;
    reportRate("batch mark rounds", live * rounds, ms);
    printf("  ⏱  ~%.0f object-marks/s  (live=%d, rounds=%d)\n",
           marksPerSec, live, rounds);

    EXPECT(GC::objectCount() >= live - 2, "微基准后存活集基本不变");
    EXPECT(marksPerSec > 10000.0, "批量 mark 吞吐高于基线门槛（>10k objects/s）");
}

int main() {
    printf("══════════════════════════════════════════════════\n");
    printf(" GC 运行时性能基准（Cheney + batch mark）\n");
    printf("══════════════════════════════════════════════════\n");

    bench1_highGarbage();
    bench2_highLiveChain();
    bench3_mixedLiveRatio();
    bench4_wideFanout();
    bench5_steadyCollect();
    bench6_autoCollectAlloc();
    bench7_batchMarkMicro();

    printf("\n──────────────────────────────────────────────────\n");
    printf("结果: %d passed, %d failed\n", g_pass, g_fail);
    return g_fail == 0 ? 0 : 1;
}
