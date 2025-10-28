#!/bin/bash
set -e

echo "编译 Dart 到 C++ 生成的代码..."
echo "=========================="

CXX=${CXX:-g++}
CXXFLAGS="${CXXFLAGS:--std=c++17 -Wall -Wextra -O2}"

echo "使用编译器: $CXX"
echo "编译选项: $CXXFLAGS"
echo ""

# 编译
echo "正在编译 /Users/alsc/MyProject/sdk/mydart/sdk/test/generated_example.cpp ..."
$CXX $CXXFLAGS \
    "/Users/alsc/MyProject/sdk/mydart/sdk/test/generated_example.cpp" \
    "/Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/base/object.cpp" \
    -o "/Users/alsc/MyProject/sdk/mydart/sdk/test/generated_example"

if [ $? -eq 0 ]; then
    echo "✅ 编译成功！"
    echo "可执行文件: /Users/alsc/MyProject/sdk/mydart/sdk/test/generated_example"
    echo ""
    echo "运行程序:"
    echo "=========="
    "/Users/alsc/MyProject/sdk/mydart/sdk/test/generated_example"
else
    echo "❌ 编译失败！"
    exit 1
fi
