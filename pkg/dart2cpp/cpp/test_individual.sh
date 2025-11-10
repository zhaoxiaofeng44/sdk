#!/bin/bash

# 测试单个文件编译的脚本
cd "$(dirname "$0")"

echo "=== 测试各个文件的编译情况 ==="

# 核心库编译
echo "编译核心库..."
g++ -std=c++11 -Wall -Wextra -I./core -c core/object.cpp -o build/object.o
if [ $? -eq 0 ]; then
    echo "✓ 核心库编译成功"
else
    echo "✗ 核心库编译失败"
    exit 1
fi

# 测试文件列表
test_files=(
    "test_transformed_simple.cpp"
    "enhanced_test_output_fixed.cpp"
    "objectptr_containers_test.cpp"
    "advanced_converted_fixed.cpp"
)

echo ""
echo "=== 测试各个测试文件 ==="

for test_file in "${test_files[@]}"; do
    if [ -f "test/$test_file" ]; then
        echo "编译 $test_file..."
        g++ -std=c++11 -Wall -Wextra -I./core test/$test_file build/object.o -o build/$(basename $test_file .cpp) 2>&1
        if [ $? -eq 0 ]; then
            echo "✓ $test_file 编译成功"
            echo "运行 $test_file..."
            ./build/$(basename $test_file .cpp)
            echo ""
        else
            echo "✗ $test_file 编译失败"
        fi
    else
        echo "⚠ $test_file 不存在"
    fi
done

echo "=== 测试完成 ==="