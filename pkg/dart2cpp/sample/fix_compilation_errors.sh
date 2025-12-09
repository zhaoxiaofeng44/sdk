#!/bin/bash

# 修复常见编译错误的脚本
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CPP_DIR="$SCRIPT_DIR/cpp"

echo "🔧 开始修复C++编译错误..."

cd "$CPP_DIR"

# 修复1: ObjectPtr<T>的toString()调用问题
echo "修复 toString() 调用问题..."
for file in *.cpp; do
    if [ -f "$file" ]; then
        # 将 .toString() 替换为 ->toString()
        sed -i.bak 's/\([a-zA-Z_][a-zA-Z0-9_]*\)\.toString()/\1->toString()/g' "$file"
        # 将 (this->xxx).toString() 替换为 (this->xxx)->toString()
        sed -i.bak 's/(\([^)]*\))\.toString()/(\1)->toString()/g' "$file"
    fi
done

# 修复2: 类型转换问题 - dart_int(), dart_double() 等需要包装在 ObjectPtr 中
echo "修复类型转换问题..."
for file in *.cpp; do
    if [ -f "$file" ]; then
        # 修复 ObjectPtr<Int> var = dart_int(x) 的问题
        sed -i.bak 's/ObjectPtr<Int> \([a-zA-Z_][a-zA-Z0-9_]*\) = dart_int(\([^)]*\))/ObjectPtr<Int> \1 = ObjectPtr<Int>(new Int(\2))/g' "$file"
        sed -i.bak 's/ObjectPtr<Double> \([a-zA-Z_][a-zA-Z0-9_]*\) = dart_double(\([^)]*\))/ObjectPtr<Double> \1 = ObjectPtr<Double>(new Double(\2))/g' "$file"
        sed -i.bak 's/ObjectPtr<String> \([a-zA-Z_][a-zA-Z0-9_]*\) = dart_string(\([^)]*\))/ObjectPtr<String> \1 = ObjectPtr<String>(new String(\2))/g' "$file"
    fi
done

# 修复3: return *this 问题
echo "修复 return *this 问题..."
for file in *.cpp; do
    if [ -f "$file" ]; then
        # 将 return *this 替换为 return ObjectPtr<T>(this)
        sed -i.bak 's/return \*this;/return ObjectPtr<StringBuilder>(this);/g' "$file"
    fi
done

# 删除备份文件
rm -f *.bak

echo "✅ 编译错误修复完成"

# 尝试重新编译所有文件
echo "🔄 重新编译所有文件..."
success_count=0
total_count=0

for file in *.cpp; do
    if [ -f "$file" ]; then
        total_count=$((total_count + 1))
        base_name="${file%.cpp}"
        echo "编译 $file..."
        
        if g++ -std=c++17 -Wall -Wextra -I../../cpp/core -Wno-unused-parameter -Wno-deprecated-copy-with-user-provided-copy -o "$base_name.out" "$file" ../../cpp/core/dart_object.cpp ../../cpp/core/dart_string.cpp 2>/dev/null; then
            echo "✅ $base_name 编译成功"
            success_count=$((success_count + 1))
        else
            echo "❌ $base_name 编译失败"
        fi
    fi
done

echo "=================================="
echo "编译统计:"
echo "  总文件数: $total_count"
echo "  成功: $success_count"
echo "  失败: $((total_count - success_count))"
echo "=================================="

# 运行所有成功编译的程序
echo "🚀 运行所有成功编译的程序..."
for file in *.out; do
    if [ -f "$file" ]; then
        echo ""
        echo "=== 运行 $file ==="
        if ./"$file"; then
            echo "✅ $file 运行成功"
        else
            echo "❌ $file 运行失败"
        fi
    fi
done

echo ""
echo "🎉 修复和测试完成！"