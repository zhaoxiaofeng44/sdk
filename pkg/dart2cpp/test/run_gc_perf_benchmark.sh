#!/bin/bash
# run_gc_perf_benchmark.sh — 编译并运行 GC 性能基准（-O2，无 ASan 以免扭曲计时）
set -u
cd "$(dirname "$0")/.."

CXX=clang++
CXXFLAGS="-std=c++17 -O2 -I lib/platform/cpp"
OUT=cpp_output/gc_perf
mkdir -p "$OUT"

echo "══════════════════════════════════════════════════"
echo " GC 性能基准（batch mark / collect / alloc）"
echo "══════════════════════════════════════════════════"

if ! $CXX $CXXFLAGS test/gc_perf_benchmark.cpp -o "$OUT/gc_perf" 2> "$OUT/compile.log"; then
    echo "❌ 编译失败"
    tail -30 "$OUT/compile.log"
    exit 1
fi

chmod +x "$OUT/gc_perf" 2>/dev/null
xattr -cr "$OUT/gc_perf" 2>/dev/null || true

"$OUT/gc_perf" | tee "$OUT/gc_perf_out.txt"
rc=${PIPESTATUS[0]}
exit $rc
