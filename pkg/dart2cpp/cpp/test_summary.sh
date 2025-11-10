#!/bin/bash

# 测试总结脚本
cd "$(dirname "$0")"

echo "=== Dart2CPP C++ 测试总结 ==="
echo ""

# 确保构建目录存在
mkdir -p build

# 编译核心库
echo "1. 编译核心库..."
g++ -std=c++11 -Wall -Wextra -I./core -c core/object.cpp -o build/object.o 2>/dev/null
if [ $? -eq 0 ]; then
    echo "   ✓ 核心库编译成功"
else
    echo "   ✗ 核心库编译失败"
    exit 1
fi

echo ""
echo "2. 测试各个文件..."

# 成功的测试
successful_tests=0
total_tests=0

# 测试 test_transformed_simple.cpp
echo "   测试 test_transformed_simple.cpp..."
total_tests=$((total_tests + 1))
g++ -std=c++11 -Wall -Wextra -I./core test/test_transformed_simple.cpp build/object.o -o build/test_transformed_simple 2>/dev/null
if [ $? -eq 0 ]; then
    echo "     ✓ 编译成功"
    ./build/test_transformed_simple > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        echo "     ✓ 运行成功"
        successful_tests=$((successful_tests + 1))
    else
        echo "     ✗ 运行失败"
    fi
else
    echo "     ✗ 编译失败"
fi

# 测试 advanced_converted_fixed.cpp
echo "   测试 advanced_converted_fixed.cpp..."
total_tests=$((total_tests + 1))
g++ -std=c++11 -Wall -Wextra -I./core test/advanced_converted_fixed.cpp build/object.o -o build/advanced_converted_fixed 2>/dev/null
if [ $? -eq 0 ]; then
    echo "     ✓ 编译成功"
    ./build/advanced_converted_fixed > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        echo "     ✓ 运行成功"
        successful_tests=$((successful_tests + 1))
    else
        echo "     ✗ 运行失败"
    fi
else
    echo "     ✗ 编译失败"
fi

# 测试 enhanced_test_output_fixed.cpp
echo "   测试 enhanced_test_output_fixed.cpp..."
total_tests=$((total_tests + 1))
if [ -f "test/enhanced_test_output_fixed.cpp" ]; then
    g++ -std=c++11 -Wall -Wextra -I./core test/enhanced_test_output_fixed.cpp build/object.o -o build/enhanced_test_output_fixed 2>/dev/null
    if [ $? -eq 0 ]; then
        echo "     ✓ 编译成功"
        ./build/enhanced_test_output_fixed > /dev/null 2>&1
        if [ $? -eq 0 ]; then
            echo "     ✓ 运行成功"
            successful_tests=$((successful_tests + 1))
        else
            echo "     ✗ 运行失败"
        fi
    else
        echo "     ✗ 编译失败"
    fi
else
    echo "     ⚠ 文件不存在"
fi

echo ""
echo "3. 测试总结："
echo "   成功的测试: $successful_tests/$total_tests"
echo "   成功率: $(( successful_tests * 100 / total_tests ))%"

if [ $successful_tests -eq $total_tests ]; then
    echo ""
    echo "🎉 所有测试都通过了！"
    exit 0
else
    echo ""
    echo "⚠️  还有一些测试需要修复"
    exit 1
fi