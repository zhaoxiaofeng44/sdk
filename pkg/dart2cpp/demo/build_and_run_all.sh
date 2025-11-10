#!/bin/bash

# Dart2CPP 统一编译和运行脚本
# 功能：将demo下的所有Dart文件编译成C++，然后编译运行所有生成的C++代码

set -e  # 遇到错误立即退出

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 项目路径
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SDK_ROOT="$(cd "$SCRIPT_DIR/../../.." && pwd)"
DEMO_DIR="$SCRIPT_DIR"
DART2CPP_TOOL="$SDK_ROOT/pkg/dart2cpp/lib/dart2cpp.dart"
CPP_DIR="$DEMO_DIR/cpp"

echo -e "${BLUE}🚀 Dart2CPP 统一编译和运行脚本${NC}"
echo -e "${BLUE}================================${NC}"
echo "SDK根目录: $SDK_ROOT"
echo "Demo目录: $DEMO_DIR"
echo "C++输出目录: $CPP_DIR"
echo ""

# 检查必要文件是否存在
if [ ! -f "$DART2CPP_TOOL" ]; then
    echo -e "${RED}❌ 错误: 找不到dart2cpp工具: $DART2CPP_TOOL${NC}"
    exit 1
fi

if [ ! -f "$DEMO_DIR/Makefile" ]; then
    echo -e "${RED}❌ 错误: 找不到Makefile: $DEMO_DIR/Makefile${NC}"
    exit 1
fi

# 创建C++输出目录
mkdir -p "$CPP_DIR"

# 第一步：编译所有Dart文件到C++
echo -e "${YELLOW}📝 第一步：编译Dart文件到C++${NC}"
echo "----------------------------------------"

# 统计变量
dart_files=($(find "$DEMO_DIR" -name "*.dart" -type f | sort))

# 查找所有Dart文件
dart_files=($(find "$DEMO_DIR" -name "*.dart" -type f | sort))

if [ ${#dart_files[@]} -eq 0 ]; then
    echo -e "${YELLOW}⚠️  警告: 没有找到Dart文件${NC}"
    exit 0
fi

echo "找到 ${#dart_files[@]} 个Dart文件"
echo ""

# 编译每个Dart文件
for dart_file in "${dart_files[@]}"; do
    filename=$(basename "$dart_file")
    echo -e "${BLUE}🔄 编译: $filename${NC}"
    
    total_files=$((total_files + 1))
    
    # 切换到SDK根目录执行dart2cpp
    cd "$SDK_ROOT"
    
    # 捕获详细的错误信息
    if error_output=$(dart "$DART2CPP_TOOL" "$dart_file" 2>&1); then
        echo -e "${GREEN}✅ 成功: $filename${NC}"
        success_files=$((success_files + 1))
    else
        echo -e "${RED}❌ 失败: $filename${NC}"
        # 显示错误的前几行（不显示全部避免输出过长）
        echo "$error_output" | head -3 | sed 's/^/    /'
        failed_files=$((failed_files + 1))
        failed_list+=("$filename")
    fi
    echo ""
done

# 显示编译统计
echo -e "${BLUE}📊 Dart编译统计:${NC}"
echo "  总文件数: $total_files"
echo -e "  成功: ${GREEN}$success_files${NC}"
echo -e "  失败: ${RED}$failed_files${NC}"

if [ $failed_files -gt 0 ]; then
    echo -e "${RED}失败的文件:${NC}"
    for failed_file in "${failed_list[@]}"; do
        echo "  - $failed_file"
    done
fi
echo ""

# 第二步：修复生成的C++文件的include路径
echo -e "${YELLOW}🔧 第二步：修复C++文件include路径${NC}"
echo "----------------------------------------"

cpp_files=($(find "$CPP_DIR" -name "*.cpp" -type f | sort))
fixed_files=0

for cpp_file in "${cpp_files[@]}"; do
    filename=$(basename "$cpp_file")
    echo -e "${BLUE}🔄 修复: $filename${NC}"
    
    # 修复include路径
    if sed -i '' 's|#include "./core/object.h"|#include "../../cpp/core/object.h"|g' "$cpp_file" 2>/dev/null; then
        # 删除不存在的头文件引用
        sed -i '' '/^#include "\.\/core\/dart_oop_extensions\.h"$/d' "$cpp_file" 2>/dev/null || true
        sed -i '' '/^#include "\.\/core\/dart_async\.h"$/d' "$cpp_file" 2>/dev/null || true
        
        echo -e "${GREEN}✅ 修复完成: $filename${NC}"
        fixed_files=$((fixed_files + 1))
    else
        echo -e "${YELLOW}⚠️  跳过: $filename (可能已经修复)${NC}"
    fi
done

echo -e "${BLUE}📊 修复统计: 处理了 $fixed_files 个C++文件${NC}"
echo ""

# 第三步：编译和运行所有C++程序
echo -e "${YELLOW}🔨 第三步：编译和运行C++程序${NC}"
echo "----------------------------------------"

# 切换到demo目录
cd "$DEMO_DIR"

# 清理之前的编译结果
echo -e "${BLUE}🧹 清理之前的编译结果...${NC}"
make clean 2>/dev/null || true
echo ""

# 编译所有程序
echo -e "${BLUE}🔨 编译所有C++程序...${NC}"
if make all; then
    echo -e "${GREEN}✅ 编译成功${NC}"
else
    echo -e "${RED}❌ 编译失败${NC}"
    echo -e "${YELLOW}💡 提示: 可以尝试单独编译和运行特定文件${NC}"
    echo "   例如: make run-simple_test"
    exit 1
fi
echo ""

# 运行所有程序
echo -e "${YELLOW}🏃 第四步：运行所有程序${NC}"
echo "========================================"

# 查找所有可执行文件
executables=($(find "$DEMO_DIR/build" -type f -executable 2>/dev/null | sort))

if [ ${#executables[@]} -eq 0 ]; then
    echo -e "${YELLOW}⚠️  没有找到可执行文件${NC}"
    exit 0
fi

run_success=0
run_failed=0
run_failed_list=()

for exe in "${executables[@]}"; do
    exe_name=$(basename "$exe")
    echo ""
    echo -e "${BLUE}🏃 运行: $exe_name${NC}"
    echo "----------------------------------------"
    
    # 设置超时时间（30秒）
    if timeout 30s "$exe"; then
        echo -e "${GREEN}✅ $exe_name 运行成功${NC}"
        run_success=$((run_success + 1))
    else
        exit_code=$?
        if [ $exit_code -eq 124 ]; then
            echo -e "${YELLOW}⏰ $exe_name 运行超时（30秒）${NC}"
        else
            echo -e "${RED}❌ $exe_name 运行失败 (退出码: $exit_code)${NC}"
        fi
        run_failed=$((run_failed + 1))
        run_failed_list+=("$exe_name")
    fi
done

# 最终统计
echo ""
echo -e "${BLUE}🎯 最终统计${NC}"
echo "========================================"
echo -e "${BLUE}Dart编译:${NC}"
echo "  总文件数: $total_files"
echo -e "  成功: ${GREEN}$success_files${NC}"
echo -e "  失败: ${RED}$failed_files${NC}"

echo -e "${BLUE}C++运行:${NC}"
echo "  总程序数: ${#executables[@]}"
echo -e "  成功: ${GREEN}$run_success${NC}"
echo -e "  失败: ${RED}$run_failed${NC}"

if [ $run_failed -gt 0 ]; then
    echo -e "${RED}运行失败的程序:${NC}"
    for failed_exe in "${run_failed_list[@]}"; do
        echo "  - $failed_exe"
    done
fi

echo ""
if [ $failed_files -eq 0 ] && [ $run_failed -eq 0 ]; then
    echo -e "${GREEN}🎉 所有任务完成！全部成功！${NC}"
    exit 0
else
    echo -e "${YELLOW}⚠️  部分任务失败，请检查上述错误信息${NC}"
    exit 1
fi