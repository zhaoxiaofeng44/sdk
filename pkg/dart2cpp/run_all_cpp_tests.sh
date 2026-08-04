#!/bin/bash
set -e

cd "$(dirname "$0")"

TESTS=(
    "restorer_full_test"
    "restorer_advanced_test"
    "restorer_async_test"
    "restorer_complex_test"
    "restorer_complex_oop_test"
    "restorer_stress_test"
    "restorer_edge_test"
    "state_machine_coroutine_test"
    "static_collections_test"
    "runtime_gap_test"
)

PASS=0
FAIL=0
RESULTS=""

for test in "${TESTS[@]}"; do
    echo "=========================================="
    echo "Testing: $test"
    echo "=========================================="
    
    CPP_FILE="cpp_output/${test}_verify.cpp"
    BIN_FILE="cpp_output/${test}_verify_run"
    
    # Compile
    echo "Compiling..."
    if ! clang++ -std=c++17 -I lib/platform/cpp "$CPP_FILE" -o "$BIN_FILE" 2>&1; then
        echo "❌ COMPILE FAILED"
        RESULTS+="❌ $test: COMPILE FAILED\n"
        ((FAIL++))
        continue
    fi
    
    # Set permissions
    chmod +x "$BIN_FILE"
    xattr -cr "$BIN_FILE" 2>/dev/null || true
    
    # Run
    echo "Running..."
    if timeout 10 ./"$BIN_FILE" > "cpp_output/${test}_output.txt" 2>&1; then
        LINES=$(wc -l < "cpp_output/${test}_output.txt")
        echo "✅ PASS ($LINES lines output)"
        RESULTS+="✅ $test: PASS ($LINES lines)\n"
        ((PASS++))
    else
        EXIT_CODE=$?
        echo "❌ RUN FAILED (exit code: $EXIT_CODE)"
        tail -20 "cpp_output/${test}_output.txt"
        RESULTS+="❌ $test: RUN FAILED (exit $EXIT_CODE)\n"
        ((FAIL++))
    fi
    echo ""
done

echo "=========================================="
echo "SUMMARY"
echo "=========================================="
echo "Pass: $PASS / ${#TESTS[@]}"
echo "Fail: $FAIL / ${#TESTS[@]}"
echo ""
echo -e "$RESULTS"
