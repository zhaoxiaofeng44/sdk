#!/bin/bash

# Dart2CPP 转换器修复验证脚本
# 用途：在修改代码后自动运行完整测试套件，对比成功率变化

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 项目根目录
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# 归档目录
ARCHIVE_DIR="$PROJECT_ROOT/test_results_archive"
mkdir -p "$ARCHIVE_DIR"

# 时间戳
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")

# 显示帮助信息
show_help() {
    echo "Dart2CPP 转换器修复验证脚本"
    echo ""
    echo "用法: $0 [选项]"
    echo ""
    echo "选项:"
    echo "  -h, --help              显示此帮助信息"
    echo "  -b, --baseline          仅记录基线（不执行修改）"
    echo "  -c, --compare FILE      与指定基线文件对比"
    echo "  -t, --timeout SECONDS   设置测试超时时间（默认 300 秒）"
    echo ""
    echo "示例:"
    echo "  $0 --baseline                    # 记录当前基线"
    echo "  $0 --compare baseline.txt        # 与基线对比"
    echo "  $0 --timeout 600                 # 设置 10 分钟超时"
}

# 默认参数
BASELINE_ONLY=false
COMPARE_FILE=""
TIMEOUT=300

# 解析命令行参数
while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            show_help
            exit 0
            ;;
        -b|--baseline)
            BASELINE_ONLY=true
            shift
            ;;
        -c|--compare)
            COMPARE_FILE="$2"
            shift 2
            ;;
        -t|--timeout)
            TIMEOUT="$2"
            shift 2
            ;;
        *)
            echo -e "${RED}❌ 未知选项: $1${NC}"
            show_help
            exit 1
            ;;
    esac
done

# 运行测试套件
run_test_suite() {
    local output_file="$1"
    
    echo -e "${BLUE}========================================${NC}"
    echo -e "${BLUE}  运行完整测试套件${NC}"
    echo -e "${BLUE}========================================${NC}"
    echo ""
    
    cd "$PROJECT_ROOT"
    
    # 使用 timeout 命令限制执行时间
    if timeout "$TIMEOUT" bash run_all_sample_tests.sh > "$output_file" 2>&1; then
        echo -e "${GREEN}✅ 测试套件执行完成${NC}"
        return 0
    else
        local exit_code=$?
        if [ $exit_code -eq 124 ]; then
            echo -e "${RED}❌ 测试套件执行超时（${TIMEOUT}秒）${NC}"
        else
            echo -e "${RED}❌ 测试套件执行失败（退出码: $exit_code）${NC}"
        fi
        return $exit_code
    fi
}

# 解析测试结果
parse_test_results() {
    local file="$1"
    
    if [ ! -f "$file" ]; then
        echo "0 0 0"
        return
    fi
    
    # 统计成功和失败的测试
    local total=$(grep -c "Testing:" "$file" || echo "0")
    local conversion_success=$(grep -c "Conversion SUCCESS" "$file" || echo "0")
    local compilation_success=$(grep -c "Compilation SUCCESS" "$file" || echo "0")
    local execution_success=$(grep -c "Execution SUCCESS" "$file" || echo "0")
    
    # 计算完全成功的测试（转换+编译+执行都成功）
    local full_success=$execution_success
    
    # 计算成功率
    local success_rate=0
    if [ $total -gt 0 ]; then
        success_rate=$(awk "BEGIN {printf \"%.2f\", ($full_success / $total) * 100}")
    fi
    
    echo "$total $full_success $success_rate"
}

# 生成测试报告
generate_report() {
    local result_file="$1"
    local baseline_file="$2"
    
    echo -e "${BLUE}========================================${NC}"
    echo -e "${BLUE}  测试结果报告${NC}"
    echo -e "${BLUE}========================================${NC}"
    echo ""
    
    # 解析当前结果
    read -r total success rate <<< $(parse_test_results "$result_file")
    
    echo -e "${YELLOW}📊 当前测试结果:${NC}"
    echo -e "  总测试数: $total"
    echo -e "  成功数: $success"
    echo -e "  成功率: ${rate}%"
    echo ""
    
    # 如果有基线文件，进行对比
    if [ -n "$baseline_file" ] && [ -f "$baseline_file" ]; then
        read -r base_total base_success base_rate <<< $(parse_test_results "$baseline_file")
        
        echo -e "${YELLOW}📊 基线测试结果:${NC}"
        echo -e "  总测试数: $base_total"
        echo -e "  成功数: $base_success"
        echo -e "  成功率: ${base_rate}%"
        echo ""
        
        # 计算变化
        local delta=$(awk "BEGIN {printf \"%.2f\", $rate - $base_rate}")
        
        echo -e "${YELLOW}📈 成功率变化:${NC}"
        if (( $(echo "$delta > 0" | bc -l) )); then
            echo -e "  ${GREEN}+${delta}% ⬆️  (提升)${NC}"
        elif (( $(echo "$delta < 0" | bc -l) )); then
            echo -e "  ${RED}${delta}% ⬇️  (下降)${NC}"
            echo ""
            echo -e "${RED}⚠️  警告：成功率下降！${NC}"
            echo -e "${YELLOW}建议：${NC}"
            echo -e "  1. 检查最近的代码修改"
            echo -e "  2. 查看失败测试的错误信息"
            echo -e "  3. 考虑回滚有问题的修改"
            echo ""
            
            # 显示新增失败的测试
            echo -e "${YELLOW}🔍 分析新增失败:${NC}"
            analyze_new_failures "$baseline_file" "$result_file"
        else
            echo -e "  ${BLUE}${delta}% (持平)${NC}"
        fi
    fi
    
    echo ""
    echo -e "${BLUE}========================================${NC}"
}

# 分析新增失败的测试
analyze_new_failures() {
    local baseline_file="$1"
    local current_file="$2"
    
    # 提取基线中成功的测试
    local baseline_success=$(grep -B1 "Execution SUCCESS" "$baseline_file" | grep "Testing:" | awk '{print $3}' || echo "")
    
    # 提取当前失败的测试
    local current_failures=$(grep -B1 "FAILED" "$current_file" | grep "Testing:" | awk '{print $3}' || echo "")
    
    # 找出新增失败的测试
    local new_failures=""
    for test in $current_failures; do
        if echo "$baseline_success" | grep -q "$test"; then
            new_failures="$new_failures\n  - $test"
        fi
    done
    
    if [ -n "$new_failures" ]; then
        echo -e "${RED}新增失败的测试:${NC}"
        echo -e "$new_failures"
    else
        echo -e "${GREEN}没有新增失败的测试${NC}"
    fi
}

# 归档测试结果
archive_results() {
    local result_file="$1"
    local archive_name="test_results_${TIMESTAMP}.txt"
    local archive_path="$ARCHIVE_DIR/$archive_name"
    
    cp "$result_file" "$archive_path"
    echo -e "${GREEN}✅ 测试结果已归档: $archive_path${NC}"
    
    # 只保留最近 10 次的结果
    cd "$ARCHIVE_DIR"
    ls -t test_results_*.txt | tail -n +11 | xargs -r rm
    echo -e "${BLUE}📁 归档目录已清理（保留最近 10 次）${NC}"
}

# 主流程
main() {
    echo -e "${BLUE}========================================${NC}"
    echo -e "${BLUE}  Dart2CPP 转换器修复验证${NC}"
    echo -e "${BLUE}========================================${NC}"
    echo ""
    
    # 临时结果文件
    TEMP_RESULT="/tmp/dart2cpp_test_result_${TIMESTAMP}.txt"
    
    if [ "$BASELINE_ONLY" = true ]; then
        # 仅记录基线
        echo -e "${YELLOW}📋 记录基线模式${NC}"
        echo ""
        
        run_test_suite "$TEMP_RESULT"
        
        # 保存为基线文件
        BASELINE_FILE="$ARCHIVE_DIR/baseline_${TIMESTAMP}.txt"
        cp "$TEMP_RESULT" "$BASELINE_FILE"
        
        echo ""
        generate_report "$TEMP_RESULT" ""
        
        echo ""
        echo -e "${GREEN}✅ 基线已保存: $BASELINE_FILE${NC}"
        echo -e "${YELLOW}💡 提示: 修改代码后，使用以下命令对比:${NC}"
        echo -e "   $0 --compare $BASELINE_FILE"
        
    else
        # 完整验证模式
        echo -e "${YELLOW}🔍 完整验证模式${NC}"
        echo ""
        
        run_test_suite "$TEMP_RESULT"
        
        echo ""
        
        # 如果指定了对比文件，进行对比
        if [ -n "$COMPARE_FILE" ]; then
            if [ ! -f "$COMPARE_FILE" ]; then
                echo -e "${RED}❌ 基线文件不存在: $COMPARE_FILE${NC}"
                exit 1
            fi
            generate_report "$TEMP_RESULT" "$COMPARE_FILE"
        else
            # 尝试使用最新的基线文件
            LATEST_BASELINE=$(ls -t "$ARCHIVE_DIR"/baseline_*.txt 2>/dev/null | head -1)
            if [ -n "$LATEST_BASELINE" ]; then
                echo -e "${YELLOW}使用最新基线: $(basename $LATEST_BASELINE)${NC}"
                echo ""
                generate_report "$TEMP_RESULT" "$LATEST_BASELINE"
            else
                generate_report "$TEMP_RESULT" ""
                echo -e "${YELLOW}💡 提示: 首次运行，建议先记录基线:${NC}"
                echo -e "   $0 --baseline"
            fi
        fi
        
        # 归档结果
        echo ""
        archive_results "$TEMP_RESULT"
    fi
    
    # 清理临时文件
    rm -f "$TEMP_RESULT"
    
    echo ""
    echo -e "${GREEN}✅ 验证完成${NC}"
}

# 执行主流程
main
