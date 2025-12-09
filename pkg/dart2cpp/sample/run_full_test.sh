#!/bin/bash

# ============================================================================
# 完整测试流程脚本
# 功能: 自动构建运行时库 -> 转换Dart文件 -> 编译C++ -> 运行测试
# ============================================================================

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

# 项目路径
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
PROJECT_ROOT=$(cd "$SCRIPT_DIR/.." && pwd)

# 显示横幅
echo -e "${PURPLE}"
echo "╔══════════════════════════════════════════════════════════════════╗"
echo "║                    Dart2CPP 完整测试套件                        ║"
echo "║                                                                  ║"
echo "║  功能: 自动化测试Dart到C++转换的完整流程                        ║"
echo "║  步骤: 构建运行时 -> 转换代码 -> 编译运行 -> 生成报告            ║"
echo "╚══════════════════════════════════════════════════════════════════╝"
echo -e "${NC}"
echo ""

# 显示系统信息
echo -e "${CYAN}=== 系统环境信息 ===${NC}"
echo "操作系统: $(uname -s)"
echo "架构: $(uname -m)"
echo "当前时间: $(date)"
echo "项目路径: $PROJECT_ROOT"
echo "Dart版本: $(dart --version 2>/dev/null || echo '未安装')"
echo "G++版本: $(g++ --version 2>/dev/null | head -1 || echo '未安装')"
echo ""

# 检查必要工具
echo -e "${YELLOW}检查必要工具...${NC}"
missing_tools=()

if ! command -v dart &> /dev/null; then
    echo -e "${RED}  ✗ Dart SDK${NC}"
    missing_tools+=("dart")
else
    echo -e "${GREEN}  ✓ Dart SDK${NC}"
fi

if ! command -v g++ &> /dev/null; then
    echo -e "${RED}  ✗ G++ 编译器${NC}"
    missing_tools+=("g++")
else
    echo -e "${GREEN}  ✓ G++ 编译器${NC}"
fi

if ! command -v ar &> /dev/null; then
    echo -e "${RED}  ✗ AR 归档工具${NC}"
    missing_tools+=("ar")
else
    echo -e "${GREEN}  ✓ AR 归档工具${NC}"
fi

if [ ${#missing_tools[@]} -gt 0 ]; then
    echo -e "${RED}错误: 缺少必要工具，请先安装: ${missing_tools[*]}${NC}"
    exit 1
fi

echo ""

# 步骤1: 构建C++运行时库
echo -e "${BLUE}=== 步骤1: 构建C++运行时库 ===${NC}"
if [ -f "$SCRIPT_DIR/build_cpp_runtime.sh" ]; then
    chmod +x "$SCRIPT_DIR/build_cpp_runtime.sh"
    if "$SCRIPT_DIR/build_cpp_runtime.sh"; then
        echo -e "${GREEN}✓ C++运行时库构建成功${NC}"
    else
        echo -e "${RED}✗ C++运行时库构建失败${NC}"
        exit 1
    fi
else
    echo -e "${RED}✗ 找不到 build_cpp_runtime.sh 脚本${NC}"
    exit 1
fi

echo ""

# 步骤2: 检查dart2cpp编译器
echo -e "${BLUE}=== 步骤2: 检查Dart2CPP编译器 ===${NC}"
if [ -f "$PROJECT_ROOT/bin/dart2cpp.dart" ]; then
    echo -e "${GREEN}✓ 找到dart2cpp编译器${NC}"
    
    # 测试编译器是否可用
    echo "测试编译器..."
    if cd "$PROJECT_ROOT" && timeout 10s dart run bin/dart2cpp.dart --help >/dev/null 2>&1; then
        echo -e "${GREEN}✓ 编译器测试通过${NC}"
    else
        echo -e "${YELLOW}⚠ 编译器测试超时或失败，但继续执行${NC}"
    fi
else
    echo -e "${RED}✗ 找不到dart2cpp编译器${NC}"
    exit 1
fi

echo ""

# 步骤3: 运行完整测试
echo -e "${BLUE}=== 步骤3: 运行批量转换测试 ===${NC}"
if [ -f "$SCRIPT_DIR/test_all_samples.sh" ]; then
    chmod +x "$SCRIPT_DIR/test_all_samples.sh"
    
    # 记录开始时间
    start_time=$(date +%s)
    
    # 运行测试并捕获退出码
    test_exit_code=0
    "$SCRIPT_DIR/test_all_samples.sh" || test_exit_code=$?
    
    # 记录结束时间
    end_time=$(date +%s)
    duration=$((end_time - start_time))
    
    echo ""
    echo -e "${CYAN}=== 测试执行时间: ${duration}秒 ===${NC}"
    
else
    echo -e "${RED}✗ 找不到 test_all_samples.sh 脚本${NC}"
    exit 1
fi

echo ""

# 步骤4: 生成详细报告
echo -e "${BLUE}=== 步骤4: 生成测试报告 ===${NC}"

# 统计文件数量
dart_count=$(find "$SCRIPT_DIR/dart" -name "*.dart" -type f | wc -l)
cpp_count=$(find "$SCRIPT_DIR/cpp_generated" -name "*.cpp" -type f 2>/dev/null | wc -l || echo 0)
exe_count=$(find "$SCRIPT_DIR/build" -type f -executable 2>/dev/null | wc -l || echo 0)

echo "文件统计:"
echo "  Dart源文件: $dart_count 个"
echo "  生成的C++文件: $cpp_count 个"  
echo "  编译的可执行文件: $exe_count 个"
echo ""

# 计算成功率
if [ $dart_count -gt 0 ]; then
    conversion_rate=$(( cpp_count * 100 / dart_count ))
    execution_rate=$(( exe_count * 100 / dart_count ))
    
    echo "成功率统计:"
    echo "  转换成功率: $conversion_rate% ($cpp_count/$dart_count)"
    echo "  执行成功率: $execution_rate% ($exe_count/$dart_count)"
else
    echo "成功率统计: 无法计算 (没有找到Dart文件)"
fi

echo ""

# 检查日志文件
log_file="$SCRIPT_DIR/test_results.log"
if [ -f "$log_file" ]; then
    log_size=$(wc -l < "$log_file")
    echo "详细日志: $log_file ($log_size 行)"
    
    # 显示最后几行日志
    echo -e "${YELLOW}最近的日志条目:${NC}"
    tail -5 "$log_file" | sed 's/^/  /'
fi

echo ""

# 最终结果
echo -e "${PURPLE}=== 最终测试结果 ===${NC}"
case $test_exit_code in
    0)
        echo -e "${GREEN}🎉 测试完全成功! 所有样例都正确转换、编译和运行${NC}"
        ;;
    1)
        echo -e "${YELLOW}⚠️  测试部分成功! 大部分样例工作正常，但有少量问题${NC}"
        ;;
    2)
        echo -e "${RED}❌ 测试失败! 多数样例转换或运行出现问题${NC}"
        ;;
    *)
        echo -e "${RED}❌ 测试异常退出! 退出码: $test_exit_code${NC}"
        ;;
esac

echo ""
echo -e "${CYAN}测试完成时间: $(date)${NC}"
echo -e "${CYAN}总耗时: ${duration}秒${NC}"

# 提供后续建议
echo ""
echo -e "${BLUE}=== 后续操作建议 ===${NC}"
echo "1. 查看详细日志: cat $log_file"
echo "2. 检查生成的C++代码: ls $SCRIPT_DIR/cpp_generated/"
echo "3. 手动运行特定测试: $SCRIPT_DIR/build/<program_name>"
echo "4. 清理临时文件: rm -rf $SCRIPT_DIR/{cpp_generated,build}/*"

exit $test_exit_code