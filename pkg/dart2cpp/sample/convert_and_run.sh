#!/bin/bash

# Dart2Cpp 转换、编译和运行脚本
# 该脚本会转换 sample/dart 目录下的所有 .dart 文件为 C++，然后编译并运行

set -e  # 遇到错误立即退出

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 项目根目录
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
DART_DIR="$SCRIPT_DIR/dart"
CPP_OUTPUT_DIR="$SCRIPT_DIR/cpp_generated"
BUILD_DIR="$SCRIPT_DIR/build"

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}  Dart2Cpp 转换、编译和运行脚本${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

# 创建输出目录
mkdir -p "$CPP_OUTPUT_DIR"
mkdir -p "$BUILD_DIR"

# 统计变量
TOTAL_FILES=0
CONVERTED_FILES=0
COMPILED_FILES=0
RUN_SUCCESS=0
FAILED_FILES=()

# 查找所有 .dart 文件（排除已生成的 .cpp 文件）
echo -e "${YELLOW}📂 扫描 Dart 文件...${NC}"
DART_FILES=($(find "$DART_DIR" -maxdepth 1 -name "*.dart" -type f))
TOTAL_FILES=${#DART_FILES[@]}

echo -e "${GREEN}找到 $TOTAL_FILES 个 Dart 文件${NC}"
echo ""

# 转换阶段
echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}  阶段 1: 转换 Dart 到 C++${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

for dart_file in "${DART_FILES[@]}"; do
    filename=$(basename "$dart_file" .dart)
    cpp_file="$CPP_OUTPUT_DIR/${filename}.cpp"
    
    echo -e "${YELLOW}📝 转换: ${filename}.dart${NC}"
    
    # 执行转换
    if dart "$PROJECT_ROOT/bin/dart2cpp.dart" "$dart_file" -o "$cpp_file" 2>&1; then
        echo -e "${GREEN}✅ 转换成功: ${filename}.cpp${NC}"
        CONVERTED_FILES=$((CONVERTED_FILES + 1))
    else
        echo -e "${RED}❌ 转换失败: ${filename}.dart${NC}"
        FAILED_FILES+=("${filename}.dart (转换失败)")
    fi
    echo ""
done

echo -e "${GREEN}转换完成: $CONVERTED_FILES/$TOTAL_FILES${NC}"
echo ""

# 编译阶段
echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}  阶段 2: 编译 C++ 代码${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

# 先编译核心库
echo -e "${YELLOW}🔨 编译核心库...${NC}"
cd "$PROJECT_ROOT/cpp"
if make all 2>&1; then
    echo -e "${GREEN}✅ 核心库编译成功${NC}"
else
    echo -e "${RED}❌ 核心库编译失败${NC}"
    exit 1
fi
cd "$SCRIPT_DIR"
echo ""

# 查找所有生成的 .cpp 文件
CPP_FILES=($(find "$CPP_OUTPUT_DIR" -name "*.cpp" -type f))

for cpp_file in "${CPP_FILES[@]}"; do
    filename=$(basename "$cpp_file" .cpp)
    executable="$BUILD_DIR/${filename}"
    
    echo -e "${YELLOW}🔨 编译: ${filename}.cpp${NC}"
    
    # 编译 C++ 文件，使用与 Makefile 相同的方式
    if g++ -std=c++17 -Wall -Wextra \
        -I"$PROJECT_ROOT/cpp/core" \
        "$cpp_file" \
        "$PROJECT_ROOT/cpp/build/dart_object.o" \
        "$PROJECT_ROOT/cpp/build/dart_string.o" \
        -o "$executable" \
        2>"$BUILD_DIR/${filename}.err"; then
        echo -e "${GREEN}✅ 编译成功: ${filename}${NC}"
        COMPILED_FILES=$((COMPILED_FILES + 1))
    else
        echo -e "${RED}❌ 编译失败: ${filename}.cpp${NC}"
        echo -e "${RED}错误详情:${NC}"
        head -20 "$BUILD_DIR/${filename}.err" 2>/dev/null || true
        FAILED_FILES+=("${filename}.cpp (编译失败)")
    fi
    echo ""
done

echo -e "${GREEN}编译完成: $COMPILED_FILES/${#CPP_FILES[@]}${NC}"
echo ""

# 运行阶段
echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}  阶段 3: 运行可执行文件${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

# 查找所有可执行文件
EXECUTABLES=($(find "$BUILD_DIR" -type f -perm +111))

for executable in "${EXECUTABLES[@]}"; do
    filename=$(basename "$executable")
    
    echo -e "${YELLOW}🚀 运行: ${filename}${NC}"
    echo -e "${BLUE}----------------------------------------${NC}"
    
    # 运行可执行文件
    if "$executable" 2>&1; then
        echo -e "${BLUE}----------------------------------------${NC}"
        echo -e "${GREEN}✅ 运行成功: ${filename}${NC}"
        RUN_SUCCESS=$((RUN_SUCCESS + 1))
    else
        EXIT_CODE=$?
        echo -e "${BLUE}----------------------------------------${NC}"
        echo -e "${RED}❌ 运行失败: ${filename} (退出码: $EXIT_CODE)${NC}"
        FAILED_FILES+=("${filename} (运行失败)")
    fi
    echo ""
done

# 最终统计
echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}  执行摘要${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""
echo -e "📊 统计信息:"
echo -e "  • 找到 Dart 文件: ${TOTAL_FILES}"
echo -e "  • 转换成功: ${GREEN}${CONVERTED_FILES}${NC}"
echo -e "  • 编译成功: ${GREEN}${COMPILED_FILES}${NC}"
echo -e "  • 运行成功: ${GREEN}${RUN_SUCCESS}${NC}"
echo ""

if [ ${#FAILED_FILES[@]} -gt 0 ]; then
    echo -e "${RED}❌ 失败的文件:${NC}"
    for failed in "${FAILED_FILES[@]}"; do
        echo -e "  • $failed"
    done
    echo ""
    exit 1
else
    echo -e "${GREEN}✅ 所有测试通过！${NC}"
    echo ""
    exit 0
fi
