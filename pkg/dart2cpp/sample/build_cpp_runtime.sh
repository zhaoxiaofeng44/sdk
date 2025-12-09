#!/bin/bash

# ============================================================================
# C++运行时库构建脚本
# 功能: 构建dart2cpp所需的C++运行时库
# ============================================================================

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# 项目路径
PROJECT_ROOT=$(cd "$(dirname "$0")/.." && pwd)
CPP_DIR="$PROJECT_ROOT/cpp"
CORE_DIR="$CPP_DIR/core"
BUILD_DIR="$CPP_DIR/build"

echo -e "${BLUE}=== 构建C++运行时库 ===${NC}"
echo "项目根目录: $PROJECT_ROOT"
echo "C++核心目录: $CORE_DIR"
echo "构建目录: $BUILD_DIR"
echo ""

# 创建构建目录
mkdir -p "$BUILD_DIR"

# 检查必要的源文件
required_files=(
    "$CORE_DIR/dart2cpp.h"
    "$CORE_DIR/dart_object.h"
    "$CORE_DIR/dart_object.cpp"
    "$CORE_DIR/dart_string.h"
    "$CORE_DIR/dart_string.cpp"
)

echo -e "${YELLOW}检查必要文件...${NC}"
missing_files=()
for file in "${required_files[@]}"; do
    if [ -f "$file" ]; then
        echo -e "${GREEN}  ✓ $(basename "$file")${NC}"
    else
        echo -e "${RED}  ✗ $(basename "$file") - 文件不存在${NC}"
        missing_files+=("$file")
    fi
done

if [ ${#missing_files[@]} -gt 0 ]; then
    echo -e "${RED}错误: 缺少必要的源文件，无法构建运行时库${NC}"
    exit 1
fi

echo ""

# 编译dart_object库
echo -e "${BLUE}[构建] dart_object.o${NC}"
if g++ -std=c++17 -fPIC -c "$CORE_DIR/dart_object.cpp" -o "$BUILD_DIR/dart_object.o" 2>&1; then
    echo -e "${GREEN}  ✓ dart_object.o 编译成功${NC}"
else
    echo -e "${RED}  ✗ dart_object.o 编译失败${NC}"
    exit 1
fi

# 编译dart_string库
echo -e "${BLUE}[构建] dart_string.o${NC}"
if g++ -std=c++17 -fPIC -c "$CORE_DIR/dart_string.cpp" -o "$BUILD_DIR/dart_string.o" 2>&1; then
    echo -e "${GREEN}  ✓ dart_string.o 编译成功${NC}"
else
    echo -e "${RED}  ✗ dart_string.o 编译失败${NC}"
    exit 1
fi

# 创建静态库
echo -e "${BLUE}[构建] libdart_object.a${NC}"
if ar rcs "$BUILD_DIR/libdart_object.a" "$BUILD_DIR/dart_object.o" 2>&1; then
    echo -e "${GREEN}  ✓ libdart_object.a 创建成功${NC}"
else
    echo -e "${RED}  ✗ libdart_object.a 创建失败${NC}"
    exit 1
fi

echo -e "${BLUE}[构建] libdart_string.a${NC}"
if ar rcs "$BUILD_DIR/libdart_string.a" "$BUILD_DIR/dart_string.o" 2>&1; then
    echo -e "${GREEN}  ✓ libdart_string.a 创建成功${NC}"
else
    echo -e "${RED}  ✗ libdart_string.a 创建失败${NC}"
    exit 1
fi

# 验证库文件
echo ""
echo -e "${YELLOW}验证构建结果...${NC}"
if [ -f "$BUILD_DIR/libdart_object.a" ] && [ -f "$BUILD_DIR/libdart_string.a" ]; then
    echo -e "${GREEN}✓ 所有库文件构建成功${NC}"
    echo "  - libdart_object.a: $(ls -lh "$BUILD_DIR/libdart_object.a" | awk '{print $5}')"
    echo "  - libdart_string.a: $(ls -lh "$BUILD_DIR/libdart_string.a" | awk '{print $5}')"
else
    echo -e "${RED}✗ 库文件构建不完整${NC}"
    exit 1
fi

echo ""
echo -e "${GREEN}🎉 C++运行时库构建完成!${NC}"
echo ""
echo -e "${BLUE}使用方法:${NC}"
echo "  编译时添加以下选项:"
echo "  g++ -std=c++17 -I$CORE_DIR -L$BUILD_DIR your_file.cpp -ldart_object -ldart_string"
echo ""