#!/bin/bash

# Dart2Cpp 简化测试脚本 - 只测试基础语法
set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}  Dart2Cpp 基础语法测试${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

# 确保核心库已编译
echo -e "${YELLOW}🔨 编译核心库...${NC}"
cd "$PROJECT_ROOT/cpp"
make all > /dev/null 2>&1
echo -e "${GREEN}✅ 核心库编译成功${NC}"
echo ""

# 只测试 basic_syntax.dart - 使用项目目录而非/tmp
DART_FILE="$SCRIPT_DIR/dart/basic_syntax.dart"
CPP_FILE="$SCRIPT_DIR/output/basic_syntax.cpp"
EXECUTABLE="$SCRIPT_DIR/output/basic_syntax"
ERR_FILE="$SCRIPT_DIR/output/basic_syntax.err"

# 创建输出目录
mkdir -p "$SCRIPT_DIR/output"

echo -e "${YELLOW}📝 转换 basic_syntax.dart...${NC}"
if dart "$PROJECT_ROOT/bin/dart2cpp.dart" "$DART_FILE" -o "$CPP_FILE" > /dev/null 2>&1; then
    echo -e "${GREEN}✅ 转换成功${NC}"
else
    echo -e "${RED}❌ 转换失败${NC}"
    exit 1
fi

echo ""
echo -e "${YELLOW}🔨 编译 C++ 代码...${NC}"
if g++ -std=c++17 -Wall -Wextra \
    -I"$PROJECT_ROOT/cpp/core" \
    "$CPP_FILE" \
    "$PROJECT_ROOT/cpp/build/dart_object.o" \
    "$PROJECT_ROOT/cpp/build/dart_string.o" \
    -o "$EXECUTABLE" \
    2>"$ERR_FILE"; then
    echo -e "${GREEN}✅ 编译成功${NC}"
else
    echo -e "${RED}❌ 编译失败${NC}"
    echo -e "${RED}错误信息:${NC}"
    cat "$ERR_FILE"
    exit 1
fi

echo ""
echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}  运行测试程序${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

if "$EXECUTABLE"; then
    echo ""
    echo -e "${GREEN}✅ 测试成功！${NC}"
    exit 0
else
    echo ""
    echo -e "${RED}❌ 测试失败${NC}"
    exit 1
fi
