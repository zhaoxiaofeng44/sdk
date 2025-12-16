#!/bin/bash

# Dart2Cpp 单文件转换、编译和运行脚本
# 用法: ./scripts/dart_to_cpp_run.sh <input.dart> [output_name]

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

# 检查参数
if [ $# -lt 1 ]; then
    echo -e "${RED}❌ 用法: $0 <input.dart> [output_name]${NC}"
    echo "示例: $0 hello.dart"
    echo "示例: $0 hello.dart my_hello"
    exit 1
fi

INPUT_DART="$1"
OUTPUT_NAME="${2:-$(basename "$INPUT_DART" .dart)}"

# 检查输入文件是否存在
if [ ! -f "$INPUT_DART" ]; then
    echo -e "${RED}❌ 输入文件不存在: $INPUT_DART${NC}"
    exit 1
fi

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}  Dart2Cpp 单文件转换、编译和运行${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

# 创建临时目录
TEMP_DIR="/tmp/dart2cpp_$$"
mkdir -p "$TEMP_DIR"
CPP_FILE="$TEMP_DIR/${OUTPUT_NAME}.cpp"
EXECUTABLE="$TEMP_DIR/${OUTPUT_NAME}"

echo -e "${YELLOW}📁 工作目录: $TEMP_DIR${NC}"
echo ""

# 阶段 1: 转换 Dart 到 C++
echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}  阶段 1: 转换 Dart 到 C++${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

echo -e "${YELLOW}📝 转换: $(basename "$INPUT_DART") -> ${OUTPUT_NAME}.cpp${NC}"

# 执行转换
if dart "$PROJECT_ROOT/bin/dart2cpp.dart" "$INPUT_DART" -o "$CPP_FILE" 2>&1; then
    echo -e "${GREEN}✅ 转换成功${NC}"
    echo -e "${BLUE}📄 输出文件: $CPP_FILE${NC}"
else
    echo -e "${RED}❌ 转换失败${NC}"
    rm -rf "$TEMP_DIR"
    exit 1
fi

echo ""

# 阶段 2: 编译核心库
echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}  阶段 2: 编译核心库${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

echo -e "${YELLOW}🔨 编译核心库...${NC}"

cd "$PROJECT_ROOT/cpp"
if make all 2>&1; then
    echo -e "${GREEN}✅ 核心库编译成功${NC}"
else
    echo -e "${RED}❌ 核心库编译失败${NC}"
    rm -rf "$TEMP_DIR"
    exit 1
fi

cd "$TEMP_DIR"
echo ""

# 阶段 3: 编译 C++ 代码
echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}  阶段 3: 编译 C++ 代码${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

echo -e "${YELLOW}🔨 编译: ${OUTPUT_NAME}.cpp${NC}"

# 编译 C++ 文件
if g++ -std=c++17 -Wall -Wextra \
    -I"$PROJECT_ROOT/cpp/core" \
    "$CPP_FILE" \
    "$PROJECT_ROOT/cpp/build/dart_object.o" \
    "$PROJECT_ROOT/cpp/build/dart_string.o" \
    -o "$EXECUTABLE" \
    2>"$TEMP_DIR/compile.err"; then    echo -e "${GREEN}✅ 编译成功${NC}"
    echo -e "${BLUE}🔧 可执行文件: $EXECUTABLE${NC}"
else
    echo -e "${RED}❌ 编译失败${NC}"
    echo -e "${RED}错误详情:${NC}"
    head -20 "$TEMP_DIR/compile.err" 2>/dev/null || true
    rm -rf "$TEMP_DIR"
    exit 1
fi

echo ""

# 阶段 4: 运行可执行文件
echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}  阶段 4: 运行程序${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

echo -e "${YELLOW}🚀 运行: ${OUTPUT_NAME}${NC}"
echo -e "${BLUE}----------------------------------------${NC}"

# 运行可执行文件
if "$EXECUTABLE" 2>&1; then
    EXIT_CODE=$?
    echo -e "${BLUE}----------------------------------------${NC}"
    echo -e "${GREEN}✅ 程序运行成功 (退出码: $EXIT_CODE)${NC}"
else
    EXIT_CODE=$?
    echo -e "${BLUE}----------------------------------------${NC}"
    echo -e "${RED}❌ 程序运行失败 (退出码: $EXIT_CODE)${NC}"
fi

echo ""

# 清理临时文件 (可选)
echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}  清理${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

echo -e "${YELLOW}🗑️  清理临时文件...${NC}"
rm -rf "$TEMP_DIR"
echo -e "${GREEN}✅ 清理完成${NC}"

echo ""
echo -e "${GREEN}🎉 所有步骤完成！${NC}"
exit $EXIT_CODE