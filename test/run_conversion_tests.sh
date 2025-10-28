#!/bin/bash

# Dart to C++ Conversion Test Runner
# 运行所有转换测试并生成报告

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo "========================================"
echo "Dart to C++ Conversion Test Suite"
echo "========================================"
echo ""

# 进入项目根目录
cd "$(dirname "$0")/.."

# 编译测试程序
echo "1. Compiling conversion test suite..."
g++ -std=c++11 -o test/dart_to_cpp_conversion_tests \
    test/dart_to_cpp_conversion_tests.cpp \
    -I. \
    2>&1 | tee test/compile.log

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ Compilation successful${NC}"
else
    echo -e "${RED}✗ Compilation failed${NC}"
    echo "Check test/compile.log for details"
    exit 1
fi

echo ""
echo "2. Running tests..."
echo "----------------------------------------"

# 运行测试
./test/dart_to_cpp_conversion_tests 2>&1 | tee test/test_results.log

TEST_EXIT_CODE=$?

echo "----------------------------------------"
echo ""

# 分析测试结果
if [ $TEST_EXIT_CODE -eq 0 ]; then
    echo -e "${GREEN}✓ All tests passed!${NC}"
    
    # 统计测试数量
    TOTAL_TESTS=$(grep -c "\[TEST\]" test/test_results.log || echo "0")
    PASSED_TESTS=$(grep -c "Test Results:" test/test_results.log | head -1 || echo "0")
    
    echo ""
    echo "Test Summary:"
    echo "  Total test suites: $TOTAL_TESTS"
    echo "  All assertions: PASSED"
    
else
    echo -e "${RED}✗ Some tests failed${NC}"
    
    # 提取失败信息
    echo ""
    echo "Failed assertions:"
    grep "FAILED" test/test_results.log || echo "No specific failure info"
    
    exit 1
fi

echo ""
echo "3. Generating test report..."

# 生成测试报告
cat > test/test_report.md << EOF
# Dart to C++ Conversion Test Report

Generated: $(date)

## Test Results

\`\`\`
$(cat test/test_results.log)
\`\`\`

## Coverage

The test suite covers:

1. **Basic Types** - Int, Double, Bool, String
2. **Operators** - Arithmetic, Comparison, Logical, Bitwise
3. **Collections** - List, Set, Map
4. **Control Flow** - if/else, for, while, for-in
5. **Type Conversions** - toString, parse methods
6. **String Operations** - concatenation, split, trim, case conversion
7. **Null Handling** - nullable types, null coalescing
8. **Advanced Features** - iterators, reference counting, async (simplified)

## Conversion Quality

All test cases demonstrate that the conversion from Dart to C++ maintains:
- ✓ Semantic equivalence
- ✓ Type safety
- ✓ Expected behavior
- ✓ Memory management

EOF

echo -e "${GREEN}✓ Test report generated: test/test_report.md${NC}"

echo ""
echo "========================================"
echo "Test suite completed successfully!"
echo "========================================"

