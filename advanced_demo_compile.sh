#!/bin/bash
set -e

echo "编译 Dart 到 C++ 转换后的代码..."
echo "================================="

CXX=${CXX:-g++}
CXXFLAGS="${CXXFLAGS:--std=c++17 -Wall -Wextra -O2 -I.}"

echo "使用编译器: $CXX"
echo "编译选项: $CXXFLAGS"
echo ""

# 编译
echo "正在编译 advanced_demo.cpp ..."
$CXX $CXXFLAGS \
    "advanced_demo.cpp" \
    "pkg/dart2bytecode/base/object.cpp" \
    -o "advanced_demo"

if [ $? -eq 0 ]; then
    echo "✅ 编译成功！"
    echo "可执行文件: \/Users/alsc/MyProject/sdk/mydart/sdk/advanced_demo"
    echo ""
    echo "运行程序:"
    echo "=========="
    "./advanced_demo"
else
    echo "❌ 编译失败！"
    exit 1
fi
