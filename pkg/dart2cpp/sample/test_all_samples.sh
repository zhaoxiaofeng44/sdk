#!/bin/bash

# ============================================================================
# Dart到C++批量转换和测试脚本
# 功能: 将sample/dart下所有.dart文件转换为C++并编译运行
# ============================================================================

set -e  # 遇到错误立即退出

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 项目根目录
PROJECT_ROOT=$(cd "$(dirname "$0")/.." && pwd)
SAMPLE_DIR="$PROJECT_ROOT/sample"
DART_DIR="$SAMPLE_DIR/dart"
CPP_OUTPUT_DIR="$SAMPLE_DIR/cpp_generated"
BUILD_DIR="$SAMPLE_DIR/build"
LOG_FILE="$SAMPLE_DIR/test_results.log"

# 创建必要的目录
mkdir -p "$CPP_OUTPUT_DIR"
mkdir -p "$BUILD_DIR"

echo -e "${BLUE}=== Dart到C++批量转换测试 ===${NC}"
echo "项目根目录: $PROJECT_ROOT"
echo "Dart源码目录: $DART_DIR"
echo "C++输出目录: $CPP_OUTPUT_DIR"
echo "构建目录: $BUILD_DIR"
echo "日志文件: $LOG_FILE"
echo ""

# 清空日志文件
> "$LOG_FILE"

# 统计变量
total_files=0
converted_files=0
compiled_files=0
executed_files=0
failed_conversions=()
failed_compilations=()
failed_executions=()

# 获取所有.dart文件
dart_files=$(find "$DART_DIR" -name "*.dart" -type f | grep -v "\.cpp$" | sort)

if [ -z "$dart_files" ]; then
    echo -e "${RED}错误: 在 $DART_DIR 中未找到.dart文件${NC}"
    exit 1
fi

echo -e "${YELLOW}找到以下Dart文件:${NC}"
for file in $dart_files; do
    basename=$(basename "$file")
    echo "  - $basename"
    ((total_files++))
done
echo "总计: $total_files 个文件"
echo ""

# 转换函数
convert_dart_file() {
    local dart_file="$1"
    local basename=$(basename "$dart_file" .dart)
    local cpp_file="$CPP_OUTPUT_DIR/${basename}.cpp"
    
    echo -e "${BLUE}[转换]${NC} $basename.dart -> $basename.cpp"
    
    # 使用dart2cpp转换器
    if cd "$PROJECT_ROOT" && dart run bin/dart2cpp.dart -o "$cpp_file" "$dart_file" 2>>"$LOG_FILE"; then
        if [ -s "$cpp_file" ]; then
            echo -e "${GREEN}  ✓ 转换成功${NC}"
            echo "转换成功: $basename.dart -> $basename.cpp" >> "$LOG_FILE"
            ((converted_files++))
            return 0
        else
            echo -e "${RED}  ✗ 转换失败 (空文件)${NC}"
            echo "转换失败 (空文件): $basename.dart" >> "$LOG_FILE"
            failed_conversions+=("$basename (空文件)")
            return 1
        fi
    else
        echo -e "${RED}  ✗ 转换失败${NC}"
        echo "转换失败: $basename.dart" >> "$LOG_FILE"
        failed_conversions+=("$basename")
        return 1
    fi
}

# 编译函数
compile_cpp_file() {
    local cpp_file="$1"
    local basename=$(basename "$cpp_file" .cpp)
    local executable="$BUILD_DIR/$basename"
    
    echo -e "${BLUE}[编译]${NC} $basename.cpp -> $basename"
    
    # C++编译选项
    local compile_cmd="g++ -std=c++17 -I$PROJECT_ROOT/cpp/core -L$PROJECT_ROOT/cpp/build -o $executable $cpp_file -ldart_object -ldart_string"
    
    if eval "$compile_cmd" 2>>"$LOG_FILE"; then
        echo -e "${GREEN}  ✓ 编译成功${NC}"
        echo "编译成功: $basename.cpp -> $basename" >> "$LOG_FILE"
        ((compiled_files++))
        return 0
    else
        echo -e "${RED}  ✗ 编译失败${NC}"
        echo "编译失败: $basename.cpp" >> "$LOG_FILE"
        failed_compilations+=("$basename")
        return 1
    fi
}

# 运行函数
execute_program() {
    local executable="$1"
    local basename=$(basename "$executable")
    
    echo -e "${BLUE}[运行]${NC} $basename"
    
    if timeout 10s "$executable" >>"$LOG_FILE" 2>&1; then
        echo -e "${GREEN}  ✓ 运行成功${NC}"
        echo "运行成功: $basename" >> "$LOG_FILE"
        ((executed_files++))
        return 0
    else
        local exit_code=$?
        if [ $exit_code -eq 124 ]; then
            echo -e "${YELLOW}  ⚠ 运行超时 (10秒)${NC}"
            echo "运行超时: $basename" >> "$LOG_FILE"
        else
            echo -e "${RED}  ✗ 运行失败 (退出码: $exit_code)${NC}"
            echo "运行失败: $basename (退出码: $exit_code)" >> "$LOG_FILE"
        fi
        failed_executions+=("$basename")
        return 1
    fi
}

# 主处理循环
echo -e "${YELLOW}=== 开始批量处理 ===${NC}"
echo ""

for dart_file in $dart_files; do
    basename=$(basename "$dart_file" .dart)
    cpp_file="$CPP_OUTPUT_DIR/${basename}.cpp"
    executable="$BUILD_DIR/$basename"
    
    echo -e "${YELLOW}处理文件: $basename${NC}"
    
    # 步骤1: 转换
    if convert_dart_file "$dart_file"; then
        # 步骤2: 编译
        if compile_cpp_file "$cpp_file"; then
            # 步骤3: 运行
            execute_program "$executable"
        fi
    fi
    
    echo ""
done

# 生成测试报告
echo -e "${YELLOW}=== 测试结果汇总 ===${NC}"
echo ""
echo -e "${BLUE}统计信息:${NC}"
echo "  总文件数: $total_files"
echo "  转换成功: $converted_files"
echo "  编译成功: $compiled_files"  
echo "  运行成功: $executed_files"
echo ""

echo -e "${BLUE}成功率:${NC}"
conversion_rate=$(( converted_files * 100 / total_files ))
compilation_rate=$(( total_files > 0 ? compiled_files * 100 / total_files : 0 ))
execution_rate=$(( total_files > 0 ? executed_files * 100 / total_files : 0 ))

echo "  转换成功率: $conversion_rate% ($converted_files/$total_files)"
echo "  编译成功率: $compilation_rate% ($compiled_files/$total_files)"
echo "  运行成功率: $execution_rate% ($executed_files/$total_files)"
echo ""

# 失败详情
if [ ${#failed_conversions[@]} -gt 0 ]; then
    echo -e "${RED}转换失败的文件:${NC}"
    for file in "${failed_conversions[@]}"; do
        echo "  - $file"
    done
    echo ""
fi

if [ ${#failed_compilations[@]} -gt 0 ]; then
    echo -e "${RED}编译失败的文件:${NC}"
    for file in "${failed_compilations[@]}"; do
        echo "  - $file"
    done
    echo ""
fi

if [ ${#failed_executions[@]} -gt 0 ]; then
    echo -e "${RED}运行失败的文件:${NC}"
    for file in "${failed_executions[@]}"; do
        echo "  - $file"
    done
    echo ""
fi

# 总体结果
overall_success_rate=$(( executed_files * 100 / total_files ))
if [ $overall_success_rate -ge 80 ]; then
    echo -e "${GREEN}🎉 测试总体成功! 成功率: $overall_success_rate%${NC}"
    exit_code=0
elif [ $overall_success_rate -ge 60 ]; then
    echo -e "${YELLOW}⚠️  测试部分成功! 成功率: $overall_success_rate%${NC}"
    exit_code=1
else
    echo -e "${RED}❌ 测试失败! 成功率: $overall_success_rate%${NC}"
    exit_code=2
fi

echo ""
echo "详细日志请查看: $LOG_FILE"
echo -e "${BLUE}测试完成!${NC}"

exit $exit_code