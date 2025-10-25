#!/bin/bash

# Dart 语法扩展示例编译脚本
# ================================

echo "Dart 语法扩展示例编译脚本"
echo "========================="

# 设置编译器和标志
CXX=${CXX:-g++}
CXXFLAGS="-I. -Wall -O2"

# 源文件路径
BASE_DIR="pkg/dart2bytecode/base"
TEST_DIR="test"

echo "使用编译器: $CXX"
echo "编译标志: $CXXFLAGS"
echo ""

# 编译示例程序
echo "编译 Dart 语法示例..."
$CXX $CXXFLAGS \
    "$TEST_DIR/dart_syntax_examples.cpp" \
    "$BASE_DIR/object.cpp" \
    -o "$TEST_DIR/dart_syntax_examples"

echo "编译 Dart 语法优化示例..."
$CXX $CXXFLAGS \
    "$TEST_DIR/dart_syntax_optimized_examples.cpp" \
    "$BASE_DIR/object.cpp" \
    -o "$TEST_DIR/dart_syntax_optimized_examples"

echo "编译 Dart 语法最终简化示例..."
$CXX $CXXFLAGS \
    "$TEST_DIR/dart_syntax_final_examples.cpp" \
    "$BASE_DIR/object.cpp" \
    -o "$TEST_DIR/dart_syntax_final_examples"

echo "编译 Dart 面向对象示例..."
$CXX $CXXFLAGS \
    "$TEST_DIR/dart_oop_examples.cpp" \
    "$BASE_DIR/object.cpp" \
    -o "$TEST_DIR/dart_oop_examples"

echo "编译 Dart 异步编程示例..."
$CXX $CXXFLAGS -pthread \
    "$TEST_DIR/dart_async_examples.cpp" \
    "$BASE_DIR/object.cpp" \
    -o "$TEST_DIR/dart_async_examples"

echo "编译 Dart 简化异步示例..."
$CXX $CXXFLAGS \
    "$TEST_DIR/dart_async_simple_examples.cpp" \
    "$BASE_DIR/object.cpp" \
    -o "$TEST_DIR/dart_async_simple_examples"

# 检查编译结果
if [ $? -eq 0 ]; then
    echo "✅ 编译成功!"
    echo ""
    echo "运行基础示例程序:"
    echo "=================="
    ./test/dart_syntax_examples
    echo ""
    echo "运行优化示例程序:"
    echo "=================="
    ./test/dart_syntax_optimized_examples
    echo ""
    echo "运行最终简化示例程序:"
    echo "===================="
    ./test/dart_syntax_final_examples
    echo ""
    echo "运行面向对象示例程序:"
    echo "===================="
    ./test/dart_oop_examples
    echo ""
    echo "运行异步编程示例程序:"
    echo "===================="
    ./test/dart_async_examples
    echo ""
    echo "运行简化异步编程示例程序:"
    echo "========================"
    ./test/dart_async_simple_examples
    echo ""
    echo "🎉 所有示例运行完成!"
else
    echo "❌ 编译失败!"
    echo "请检查以下可能的问题:"
    echo "1. 确保所有源文件都存在"
    echo "2. 检查编译器是否支持所需的C++特性"
    echo "3. 确保包含路径正确"
    exit 1
fi

echo ""
echo "清理编译产物:"
echo "=============="
echo "如需清理生成的可执行文件，运行："
echo "rm -f test/dart_syntax_examples test/dart_syntax_optimized_examples test/dart_syntax_final_examples test/dart_oop_examples test/dart_async_examples test/dart_async_simple_examples"
