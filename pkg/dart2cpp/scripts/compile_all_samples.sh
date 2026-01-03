#!/bin/bash

# 编译所有sample测试并收集错误信息

cd "$(dirname "$0")/.."

echo "正在编译所有sample测试用例..."
echo ""

# 计数器
total=0
success=0
failed=0

# 错误日志文件
error_log="sample/compile_errors.log"
> "$error_log"

# 遍历所有Dart测试文件
for dart_file in sample/dart/*.dart; do
    filename=$(basename "$dart_file" .dart)
    cpp_file="sample/cpp_generated/${filename}.cpp"
    
    total=$((total + 1))
    echo "[$total] 编译 $filename..."
    
    # 编译
    if dart bin/dart2cpp.dart "$dart_file" "$cpp_file" 2>&1 | grep -q "Successfully compiled"; then
        # 尝试用C++编译器检查
        if clang++ -std=c++17 -I cpp/core -fsyntax-only "$cpp_file" 2>&1 | tee -a "$error_log" | grep -q "error:"; then
            echo "  ✗ C++编译失败"
            failed=$((failed + 1))
        else
            echo "  ✓ 编译成功"
            success=$((success + 1))
        fi
    else
        echo "  ✗ Dart转C++失败"
        failed=$((failed + 1))
    fi
done

echo ""
echo "=========================================="
echo "编译统计:"
echo "  总计: $total"
echo "  成功: $success"
echo "  失败: $failed"
echo "=========================================="
echo ""
echo "错误日志已保存至: $error_log"
