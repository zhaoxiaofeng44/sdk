// ============================================================================
// gc_perf_benchmark.cpp — 当前 GC 性能测算（精确根 + Cheney Minor / Full）
// ============================================================================
// 场景：
//   B1 高垃圾：1 root + 大量短命 → Full collect
//   B2 高存活：长链全活 → 重复 Minor
//   B3 混合：~10% 存活
//   B4 宽扇出树 → Minor mark 密集
//   B5 稳态存活集 → 单轮 Minor 平均耗时
//   B6 自动 GC 下分配吞吐
//   B7 同图多轮 Minor 对象吞吐
//
// 用法:
//   ./test/run_gc_perf_benchmark.sh
//   # 或:
//   clang++ -std=c++17 -O2 -I lib/platform/cpp test/gc_perf_benchmark.cpp -o gc_perf && ./gc_perf
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

/// 汇总表（跑完打印）
struct Metrics {
    double allocDeadOpsPerSec = 0;
    double fullHighGarbageMs = 0;
    double minorLiveChainMsPerRound = 0;
    double minorLiveChainObjPerSec = 0;
    double fullMixedMs = 0;
    double minorFanoutMsPerRound = 0;
    double steadyMinorMs = 0;
    double autoAllocOpsPerSec = 0;
    double batchMinorObjPerSec = 0;
    int steadyLive = 0;
    int batchLive = 0;
} g_m;

// ── 基准用节点 ──

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

static void benchSetup() {
    GC::reset();
    GC::setAutoCollectThreshold(0);
    GC::setSemiSpaceSizeForTest(0);  // 默认 2MB
}

/// 经 RootPin 钉住 tip 槽，在可能触发 GC 的分配下安全追加
static PerfNode* appendPinned(PerfNode*& tip, int64_t tag) {
    auto* n = GC::allocateLocal(new PerfNode());
    n->tag = tag;
    tip->next = n;
    tip = n;
    return n;
}

// ── B1 ──

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
    g_m.allocDeadOpsPerSec = allocMs > 0 ? N * 1000.0 / allocMs : 0;

    int before = GC::objectCount();
    auto tGc = Clock::now();
    int freed = GC::collect();
    double gcMs = msSince(tGc);
    reportRate("full collect (mostly dead)", before, gcMs);
    g_m.fullHighGarbageMs = gcMs;

    EXPECT(keep->tag == 1, "唯一存活 root 内容完好");
    EXPECT(freed >= before - 5, "本轮短命对象基本被回收");
    EXPECT(GC::objectCount() <= 5, "collect 后对象数接近 1（root）");
    EXPECT(gcMs < 5000.0, "高垃圾 Full collect 在合理时间内完成");
}

// ── B2 ──

static void bench2_highLiveChain() {
    printf("\n=== B2: 高存活比（长链批量 Minor）===\n");
    benchSetup();

    const int N = 20000;
    auto* root = GC::allocateGlobal(new PerfNode());
    root->tag = 0;
    PerfNode* tip = root;
    GC::RootPin pin_tip(tip);
    auto tBuild = Clock::now();
    for (int i = 1; i < N; i++) {
        appendPinned(tip, i);
    }
    double buildMs = msSince(tBuild);
    reportRate("build live chain", N, buildMs);

    GC::collectMinor();

    const int rounds = 20;
    auto tGc = Clock::now();
    int totalFreed = 0;
    for (int r = 0; r < rounds; r++) {
        totalFreed += GC::collectMinor();
    }
    double gcMs = msSince(tGc);
    reportRate("minor live chain x20", N * rounds, gcMs);
    g_m.minorLiveChainMsPerRound = gcMs / rounds;
    g_m.minorLiveChainObjPerSec = gcMs > 0 ? (N * rounds * 1000.0 / gcMs) : 0;

    int walked = 0;
    int64_t sum = 0;
    for (PerfNode* p = root; p; p = p->next) {
        sum += p->tag;
        walked++;
    }
    EXPECT(walked == N, "长链在多次 Minor 后仍完整");
    EXPECT(sum == static_cast<int64_t>(N - 1) * N / 2, "长链 tag 求和正确");
    EXPECT(totalFreed == 0, "纯存活集重复 Minor 不误回收");
    EXPECT(gcMs < 10000.0, "高存活批量 Minor 在合理时间内完成");
}

// ── B3 ──

static void bench3_mixedLiveRatio() {
    printf("\n=== B3: 混合存活（~10%% 钉住）===\n");
    benchSetup();

    const int liveN = 2000;
    const int deadN = 18000;
    auto* root = GC::allocateGlobal(new PerfNode());
    PerfNode* tip = root;
    GC::RootPin pin_tip(tip);
    for (int i = 0; i < liveN; i++) {
        appendPinned(tip, i);
    }
    for (int i = 0; i < deadN; i++) {
        GC::allocateLocal(new PerfNode())->tag = -1;
    }

    int before = GC::objectCount();
    auto tGc = Clock::now();
    int freed = GC::collect();
    double gcMs = msSince(tGc);
    reportRate("full collect mixed", before, gcMs);
    g_m.fullMixedMs = gcMs;

    int walked = 0;
    for (PerfNode* p = root; p; p = p->next) walked++;
    EXPECT(walked == liveN + 1, "混合场景存活链完整");
    EXPECT(freed >= before - (liveN + 1) - 10, "混合场景短命对象基本回收");
    EXPECT(GC::objectCount() <= liveN + 5, "混合场景 collect 后接近存活集");
    EXPECT(gcMs < 5000.0, "混合 Full collect 在合理时间内完成");
}

// ── B4 ──

static void bench4_wideFanout() {
    printf("\n=== B4: 宽扇出图（每节点 %d 子）===\n", PerfNode::kFanout);
    benchSetup();

    // 完全挂到 root 子图上；扩半空间保证建树中途不 evacuate 栈上 level 指针
    GC::setSemiSpaceSizeForTest(8 * 1024 * 1024);

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

    GC::collectMinor();
    const int rounds = 30;
    auto tGc = Clock::now();
    for (int r = 0; r < rounds; r++) GC::collectMinor();
    double gcMs = msSince(tGc);
    reportRate("minor fanout x30", total * rounds, gcMs);
    g_m.minorFanoutMsPerRound = gcMs / rounds;

    bool ok = true;
    for (int i = 0; i < PerfNode::kFanout; i++) {
        if (!root->child[i] || root->child[i]->tag <= 0) ok = false;
    }
    EXPECT(ok, "扇出树根子节点在 Minor 后仍可达");
    EXPECT(GC::objectCount() >= total, "扇出树对象未被误回收");
    EXPECT(gcMs < 10000.0, "宽扇出 Minor 在合理时间内完成");

    GC::setSemiSpaceSizeForTest(0);
}

// ── B5 ──

static void bench5_steadyCollect() {
    printf("\n=== B5: 稳态存活集重复 Minor ===\n");
    benchSetup();

    const int N = 10000;
    auto* root = GC::allocateGlobal(new PerfNode());
    PerfNode* tip = root;
    GC::RootPin pin_tip(tip);
    for (int i = 0; i < N; i++) {
        appendPinned(tip, i);
    }
    GC::collectMinor();

    const int rounds = 50;
    auto tGc = Clock::now();
    for (int r = 0; r < rounds; r++) {
        int freed = GC::collectMinor();
        if (freed != 0) {
            printf("  ⚠ round %d freed=%d (expected 0)\n", r, freed);
        }
    }
    double gcMs = msSince(tGc);
    double perCollect = gcMs / rounds;
    reportRate("steady minor x50", N * rounds, gcMs);
    printf("  ⏱  avg per minor: %.3f ms (live≈%d)\n", perCollect, N + 1);
    g_m.steadyMinorMs = perCollect;
    g_m.steadyLive = N + 1;

    EXPECT(root->next != nullptr && root->next->tag == 0, "稳态 Minor 后链头完好");
    EXPECT(perCollect < 200.0, "单轮稳态 Minor 平均耗时合理");
}

// ── B6 ──

static void bench6_autoCollectAlloc() {
    printf("\n=== B6: 自动 GC 下持续分配吞吐 ===\n");
    benchSetup();
    GC::setAutoCollectThreshold(2000);

    auto* root = GC::allocateGlobal(new PerfNode());
    PerfNode* tip = root;
    GC::RootPin pin_tip(tip);
    for (int i = 0; i < 100; i++) {
        appendPinned(tip, i);
    }

    const int N = 100000;
    auto t0 = Clock::now();
    for (int i = 0; i < N; i++) {
        GC::allocateLocal(new PerfNode())->tag = i;
    }
    double ms = msSince(t0);
    reportRate("alloc with auto-GC", N, ms);
    g_m.autoAllocOpsPerSec = ms > 0 ? N * 1000.0 / ms : 0;
    printf("  终态 objectCount=%d capacity=%zu\n",
           GC::objectCount(), GC::semiCapacity());

    EXPECT(root->next != nullptr, "自动 GC 下长期存活链仍在");
    EXPECT(GC::objectCount() < N / 2, "自动 GC 显著抑制对象积压");
    EXPECT(ms < 30000.0, "10 万次带自动 GC 的分配在合理时间内完成");

    GC::setAutoCollectThreshold(0);
}

// ── B7 ──

static void bench7_batchMarkMicro() {
    printf("\n=== B7: 同图 100 轮 Minor 对象吞吐 ===\n");
    benchSetup();

    const int chain = 5000;
    auto* root = GC::allocateGlobal(new PerfNode());
    PerfNode* tip = root;
    GC::RootPin pin_tip(tip);
    for (int i = 0; i < chain; i++) {
        appendPinned(tip, i);
        auto* c0 = GC::allocateLocal(new PerfNode());
        c0->tag = i * 2;
        tip->child[0] = c0;
        auto* c1 = GC::allocateLocal(new PerfNode());
        c1->tag = i * 2 + 1;
        tip->child[1] = c1;
    }
    int live = GC::objectCount();
    GC::collectMinor();

    const int rounds = 100;
    auto t0 = Clock::now();
    for (int r = 0; r < rounds; r++) GC::collectMinor();
    double ms = msSince(t0);
    double marksPerSec = ms > 0 ? (live * rounds * 1000.0 / ms) : 0;
    reportRate("batch minor rounds", live * rounds, ms);
    printf("  ⏱  ~%.0f object-visits/s  (live=%d, rounds=%d)\n",
           marksPerSec, live, rounds);
    g_m.batchMinorObjPerSec = marksPerSec;
    g_m.batchLive = live;

    EXPECT(GC::objectCount() >= live - 2, "微基准后存活集基本不变");
    EXPECT(marksPerSec > 100000.0, "Minor 吞吐高于基线门槛（>100k objects/s）");
}

static void printSummary() {
    printf("\n══════════════════════════════════════════════════\n");
    printf(" 当前 GC 性能汇总（-O2，精确根 + Cheney）\n");
    printf("══════════════════════════════════════════════════\n");
    printf("  %-36s %12.0f ops/s\n", "短命对象分配 (B1)", g_m.allocDeadOpsPerSec);
    printf("  %-36s %12.2f ms\n", "高垃圾 Full collect (B1)", g_m.fullHighGarbageMs);
    printf("  %-36s %12.3f ms/轮\n", "2万存活链 Minor (B2)", g_m.minorLiveChainMsPerRound);
    printf("  %-36s %12.0f obj/s\n", "存活链 Minor 吞吐 (B2)", g_m.minorLiveChainObjPerSec);
    printf("  %-36s %12.2f ms\n", "混合 Full collect (B3)", g_m.fullMixedMs);
    printf("  %-36s %12.3f ms/轮\n", "扇出树 Minor (B4)", g_m.minorFanoutMsPerRound);
    printf("  %-36s %12.3f ms  (live≈%d)\n", "稳态 Minor (B5)", g_m.steadyMinorMs, g_m.steadyLive);
    printf("  %-36s %12.0f ops/s\n", "自动 GC 分配 (B6)", g_m.autoAllocOpsPerSec);
    printf("  %-36s %12.0f obj/s  (live=%d)\n", "同图多轮 Minor (B7)", g_m.batchMinorObjPerSec, g_m.batchLive);
    printf("──────────────────────────────────────────────────\n");
}

int main() {
    printf("══════════════════════════════════════════════════\n");
    printf(" GC 性能测算（精确根 RootPin + Cheney Minor/Full）\n");
    printf("══════════════════════════════════════════════════\n");

    bench1_highGarbage();
    bench2_highLiveChain();
    bench3_mixedLiveRatio();
    bench4_wideFanout();
    bench5_steadyCollect();
    bench6_autoCollectAlloc();
    bench7_batchMarkMicro();

    printSummary();
    printf("结果: %d passed, %d failed\n", g_pass, g_fail);
    return g_fail == 0 ? 0 : 1;
}
