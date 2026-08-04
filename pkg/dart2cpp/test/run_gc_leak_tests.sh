#!/bin/bash
# ============================================================================
# run_gc_leak_tests.sh — GC 机制与内存泄漏/逃逸验证套件
# ============================================================================
# 三部分：
#   A. gc_cpp_leak_test        — GC 语义 + 泄漏量化（ASan/LSan 下须干净通过）
#   B. gc_cpp_escape_uaf_test  — 逃逸场景修复验证（U1-U5 须在 ASan 下干净退出）
#   C. 11 个生成程序           — 每个测试用例尾部自带 GC::collect + reportAlive；
#                                驱动在 main 返回后多轮 collect 测量真实残留：
#                                收敛后 alive 应为 0（或 root 单例子树）
# ============================================================================
set -u

cd "$(dirname "$0")/.."

CXX=clang++
CXXFLAGS="-std=c++17 -I lib/platform/cpp"
ASANFLAGS="-fsanitize=address -fno-omit-frame-pointer -g"
OUT=cpp_output/gc_leak
mkdir -p "$OUT"

PASS=0
FAIL=0
RESULTS=""

report() {  # report <ok:0|1> <name> <detail>
    if [ "$1" -eq 0 ]; then
        PASS=$((PASS+1)); RESULTS+="✅ $2: $3\n"
    else
        FAIL=$((FAIL+1)); RESULTS+="❌ $2: $3\n"
    fi
}

echo "══════════════════════════════════════════════════"
echo " A. GC 语义与泄漏量化测试（ASan/LSan）"
echo "══════════════════════════════════════════════════"
if $CXX $CXXFLAGS $ASANFLAGS test/gc_cpp_leak_test.cpp -o "$OUT/leak_test" 2> "$OUT/leak_test_compile.log"; then
    chmod +x "$OUT/leak_test" 2>/dev/null
    xattr -cr "$OUT/leak_test" 2>/dev/null || true
    if "$OUT/leak_test" > "$OUT/leak_test_out.txt" 2>&1; then
        tail -2 "$OUT/leak_test_out.txt"
        report 0 "A/leak_test" "全部断言通过，LSan 无泄漏报告"
    else
        tail -25 "$OUT/leak_test_out.txt"
        report 1 "A/leak_test" "断言失败或 LSan/ASan 报错（见 $OUT/leak_test_out.txt）"
    fi
else
    tail -20 "$OUT/leak_test_compile.log"
    report 1 "A/leak_test" "编译失败"
fi

echo ""
echo "══════════════════════════════════════════════════"
echo " B. 逃逸场景修复验证（ASan 下须干净退出）"
echo "══════════════════════════════════════════════════"
if $CXX $CXXFLAGS $ASANFLAGS test/gc_cpp_escape_uaf_test.cpp -o "$OUT/uaf_test" 2> "$OUT/uaf_compile.log"; then
    chmod +x "$OUT/uaf_test" 2>/dev/null
    xattr -cr "$OUT/uaf_test" 2>/dev/null || true
    for sc in U1 U2 U3 U4 U5; do
        "$OUT/uaf_test" "$sc" > "$OUT/uaf_${sc}.txt" 2>&1
        rc=$?
        if [ $rc -eq 0 ] && grep -q "PASS" "$OUT/uaf_${sc}.txt" && \
           ! grep -q "Sanitizer" "$OUT/uaf_${sc}.txt"; then
            echo "  [$sc] ✓ $(grep -m1 PASS "$OUT/uaf_${sc}.txt")"
            report 0 "B/$sc" "修复生效，ASan 干净"
        else
            echo "  [$sc] ✗ rc=$rc"
            head -8 "$OUT/uaf_${sc}.txt"
            report 1 "B/$sc" "场景失败或 ASan 报错"
        fi
    done
else
    tail -20 "$OUT/uaf_compile.log"
    report 1 "B/uaf_test" "编译失败"
fi

echo ""
echo "══════════════════════════════════════════════════"
echo " C. 生成程序：用例尾部 GC + 退出残留测量 + ASan 回归"
echo "══════════════════════════════════════════════════"
TESTS=(
    "restorer_full_test"
    "restorer_advanced_test"
    "restorer_async_test"
    "restorer_complex_test"
    "restorer_complex_oop_test"
    "restorer_stress_test"
    "restorer_edge_test"
    "state_machine_advanced_test"
    "state_machine_coroutine_test"
    "static_collections_test"
    "runtime_gap_test"
)

# 驱动统一编译一次
$CXX $CXXFLAGS -c test/gc_exit_measure_driver.cpp -o "$OUT/driver.o" 2> "$OUT/driver_compile.log"

for test in "${TESTS[@]}"; do
    CPP_FILE="cpp_output/${test}_verify.cpp"
    [ -f "$CPP_FILE" ] || { report 1 "C/$test" "缺少 $CPP_FILE（先运行 dart test/run_all_restorer_tests.dart 重新生成）"; continue; }

    # C1: 退出时残留测量（生成文件单独编译并重命名 main，驱动不带 -Dmain）
    if $CXX $CXXFLAGS -Dmain=dart_main -c "$CPP_FILE" -o "$OUT/${test}_gen.o" 2> "$OUT/${test}_measure_compile.log" \
        && $CXX "$OUT/${test}_gen.o" "$OUT/driver.o" -o "$OUT/${test}_measure" 2>> "$OUT/${test}_measure_compile.log"; then
        chmod +x "$OUT/${test}_measure" 2>/dev/null
        xattr -cr "$OUT/${test}_measure" 2>/dev/null || true
        MOUT=$(timeout 60 "$OUT/${test}_measure" 2> "$OUT/${test}_measure_report.txt")
        rc=$?
        FINAL=$(echo "$MOUT" | grep "round=3" | sed 's/.*alive=\([0-9]*\).*/\1/')
        ROOTS=$(echo "$MOUT" | grep "scheduler" | sed 's/.*roots=\([0-9]*\).*/\1/')
        CASES=$(grep -c "^\[GC:" "$OUT/${test}_measure_report.txt" 2>/dev/null)
        if [ $rc -eq 0 ] && [ -n "$FINAL" ]; then
            # 判定：收敛后无残留；有 root 时允许 root 子图（单例，≤20 对象）
            if [ "$FINAL" -eq 0 ]; then
                echo "  [$test] 用例检查点=$CASES 退出残留=0 ✅ 零泄漏"
                report 0 "C/$test" "退出残留=0（$CASES 个用例 GC 检查点），零泄漏"
            elif [ "$ROOTS" -gt 0 ] && [ "$FINAL" -le 20 ]; then
                TYPES=$(grep "GC:exit-driver" "$OUT/${test}_measure_report.txt" | cut -c1-90)
                echo "  [$test] 退出残留=${FINAL}（root 子图）: $TYPES"
                report 0 "C/$test" "退出残留=${FINAL}，均为 root 单例子图（roots=${ROOTS}）"
            else
                echo "  [$test] ❌ 退出残留=${FINAL} roots=${ROOTS} —— 存在泄漏"
                grep "GC:exit-driver" "$OUT/${test}_measure_report.txt"
                report 1 "C/$test" "退出残留=${FINAL}（roots=${ROOTS}），存在泄漏对象"
            fi
        else
            tail -3 "$OUT/${test}_measure_report.txt" 2>/dev/null
            report 1 "C/$test" "运行失败（rc=$rc）"
        fi
    else
        tail -5 "$OUT/${test}_measure_compile.log"
        report 1 "C/$test" "测量版编译失败"
    fi

    # C2: ASan 回归（含用例尾部 collect，验证无 UAF）
    if $CXX $CXXFLAGS $ASANFLAGS "$CPP_FILE" -o "$OUT/${test}_asan" 2> "$OUT/${test}_asan_compile.log"; then
        chmod +x "$OUT/${test}_asan" 2>/dev/null
        xattr -cr "$OUT/${test}_asan" 2>/dev/null || true
        if timeout 120 "$OUT/${test}_asan" > "$OUT/${test}_asan_out.txt" 2>&1; then
            report 0 "C/${test}_asan" "ASan 干净（用例尾部 GC 无 UAF）"
        else
            if grep -q "Sanitizer" "$OUT/${test}_asan_out.txt"; then
                report 1 "C/${test}_asan" "ASan 报错（见 $OUT/${test}_asan_out.txt）"
            else
                report 1 "C/${test}_asan" "运行失败（非 ASan 错误）"
            fi
        fi
    else
        report 1 "C/${test}_asan" "ASan 版编译失败"
    fi
done

echo ""
echo "══════════════════════════════════════════════════"
echo " SUMMARY: $PASS passed, $FAIL failed"
echo "══════════════════════════════════════════════════"
echo -e "$RESULTS"
[ "$FAIL" -eq 0 ]
