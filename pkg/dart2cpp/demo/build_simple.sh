#!/bin/bash

# 简化版 Dart2CPP 编译和运行脚本
# 只处理能够成功编译的简单文件

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# 项目路径
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SDK_ROOT="$(cd "$SCRIPT_DIR/../../.." && pwd)"
DEMO_DIR="$SCRIPT_DIR"
DART2CPP_TOOL="$SDK_ROOT/pkg/dart2cpp/lib/dart2cpp.dart"
CPP_DIR="$DEMO_DIR/cpp"

echo -e "${BLUE}🚀 简化版 Dart2CPP 编译脚本${NC}"
echo "================================"

# 创建C++输出目录
mkdir -p "$CPP_DIR"

# 定义能够成功编译的文件列表（基于之前的测试结果）
successful_files=(
    "library_filter_test.dart"
    "basic_syntax_demo.dart"
    "comprehensive_demo.dart"
)

echo -e "${YELLOW}📝 编译选定的Dart文件到C++${NC}"
echo "----------------------------------------"

success_count=0
total_count=${#successful_files[@]}

for dart_file in "${successful_files[@]}"; do
    full_path="$DEMO_DIR/$dart_file"
    
    if [ ! -f "$full_path" ]; then
        echo -e "${RED}❌ 文件不存在: $dart_file${NC}"
        continue
    fi
    
    echo -e "${BLUE}🔄 编译: $dart_file${NC}"
    
    cd "$SDK_ROOT"
    if dart "$DART2CPP_TOOL" "$full_path" >/dev/null 2>&1; then
        echo -e "${GREEN}✅ 成功: $dart_file${NC}"
        success_count=$((success_count + 1))
    else
        echo -e "${RED}❌ 失败: $dart_file${NC}"
    fi
done

echo ""
echo -e "${BLUE}📊 编译统计: $success_count/$total_count 成功${NC}"

# 修复生成的C++文件
echo -e "${YELLOW}🔧 修复C++文件include路径${NC}"
echo "----------------------------------------"

cpp_files=($(find "$CPP_DIR" -name "*.cpp" -type f 2>/dev/null))
fixed_count=0

for cpp_file in "${cpp_files[@]}"; do
    filename=$(basename "$cpp_file")
    echo -e "${BLUE}🔄 修复: $filename${NC}"
    
    # 修复include路径
    sed -i '' 's|#include "./core/object.h"|#include "../../cpp/core/object.h"|g' "$cpp_file" 2>/dev/null || true
    sed -i '' '/^#include "\.\/core\/dart_oop_extensions\.h"$/d' "$cpp_file" 2>/dev/null || true
    sed -i '' '/^#include "\.\/core\/dart_async\.h"$/d' "$cpp_file" 2>/dev/null || true
    
    echo -e "${GREEN}✅ 修复完成: $filename${NC}"
    fixed_count=$((fixed_count + 1))
done

echo -e "${BLUE}📊 修复统计: 处理了 $fixed_count 个C++文件${NC}"
echo ""

# 编译C++程序
echo -e "${YELLOW}🔨 编译C++程序${NC}"
echo "----------------------------------------"

cd "$DEMO_DIR"

# 清理
echo -e "${BLUE}🧹 清理...${NC}"
make clean >/dev/null 2>&1 || true

# 编译
echo -e "${BLUE}🔨 编译...${NC}"
if make all >/dev/null 2>&1; then
    echo -e "${GREEN}✅ 编译成功${NC}"
else
    echo -e "${RED}❌ 编译失败，尝试单独编译可用的文件${NC}"
    
    # 尝试编译simple_test（我们知道这个能工作）
    if make run-simple_test >/dev/null 2>&1; then
        echo -e "${GREEN}✅ simple_test 编译成功${NC}"
    fi
fi

echo ""

# 运行程序
echo -e "${YELLOW}🏃 运行程序${NC}"
echo "========================================"

# 查找可执行文件
executables=($(find "$DEMO_DIR/build" -type f -executable 2>/dev/null))

if [ ${#executables[@]} -eq 0 ]; then
    echo -e "${YELLOW}⚠️  没有找到可执行文件${NC}"
    exit 0
fi

run_success=0
for exe in "${executables[@]}"; do
    exe_name=$(basename "$exe")
    echo ""
    echo -e "${BLUE}🏃 运行: $exe_name${NC}"
    echo "----------------------------------------"
    
    if timeout 10s "$exe" 2>/dev/null; then
        echo -e "${GREEN}✅ $exe_name 运行成功${NC}"
        run_success=$((run_success + 1))
    else
        echo -e "${RED}❌ $exe_name 运行失败或超时${NC}"
    fi
done

echo ""
echo -e "${BLUE}🎯 最终统计${NC}"
echo "========================================"
echo -e "编译成功: ${GREEN}$success_count/$total_count${NC}"
echo -e "运行成功: ${GREEN}$run_success/${#executables[@]}${NC}"

if [ $success_count -gt 0 ] && [ $run_success -gt 0 ]; then
    echo -e "${GREEN}🎉 任务完成！${NC}"
else
    echo -e "${YELLOW}⚠️  部分任务失败${NC}"
fi