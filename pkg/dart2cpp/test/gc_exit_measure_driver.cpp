// ============================================================================
// gc_exit_measure_driver.cpp — 生成程序退出时的 GC 逃逸测量驱动
// ============================================================================
// 与生成的 C++ 程序一起编译（生成文件的 main 用 -Dmain=dart_main 重命名）：
//
//   clang++ -std=c++17 -Dmain=dart_main -I lib/platform/cpp -c <gen.cpp> -o gen.o
//   clang++ -std=c++17 -I lib/platform/cpp -c test/gc_exit_measure_driver.cpp -o driver.o
//   clang++ gen.o driver.o -o <bin>
//
// dart_main 返回后（所有栈引用消失），执行多轮 GC::collect() 并输出：
//   - 每轮回收数与存活数（收敛情况）
//   - 调度器队列计数（active/ready/delayed）
//   - 存活对象的类型分布（泄漏对象分析）
// ============================================================================

#include "dart2cpp_lowered.h"
#include <cstdio>

int dart_main();

int main() {
    int rc = dart_main();

    int active = 0, ready = 0, delayed = 0;
    GlobalScheduler::instance().schedulerCounts(&active, &ready, &delayed);
    printf("GC_EXIT_MEASURE scheduler active=%d ready=%d delayed=%d roots=%d\n",
           active, ready, delayed, GC::rootCount());

    for (int round = 1; round <= 3; round++) {
        int before = GC::objectCount();
        int freed = GC::collect();
        printf("GC_EXIT_MEASURE round=%d before=%d freed=%d alive=%d\n",
               round, before, freed, GC::objectCount());
    }

    // 最终存活对象 = 真正被钉住的（root / 调度器 / 保守栈残留）
    GC::reportAlive("exit-driver");
    return rc;
}
