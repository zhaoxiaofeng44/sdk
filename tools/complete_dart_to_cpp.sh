#!/bin/bash

# ============================================================================
# 完整的 Dart 到 C++ 转换工作流
# 包含转换、后处理、编译和测试
# ============================================================================

set -e

# 获取脚本所在目录
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SDK_DIR="$(dirname "$SCRIPT_DIR")"

echo "=== 完整的 Dart 到 C++ 转换工作流 ==="
echo "SDK 目录: $SDK_DIR"
echo ""

# 检查参数
if [ $# -lt 1 ]; then
    echo "使用方法: $0 <input.dart> [output_prefix]"
    echo ""
    echo "示例:"
    echo "  $0 test/advanced_dart_example.dart"
    echo "  $0 test/advanced_dart_example.dart my_program"
    echo ""
    exit 1
fi

INPUT_FILE="$1"
OUTPUT_PREFIX="${2:-converted_program}"

# 检查输入文件
if [ ! -f "$INPUT_FILE" ]; then
    echo "❌ 错误: 输入文件不存在: $INPUT_FILE"
    exit 1
fi

# 设置输出文件名
RAW_CPP="${OUTPUT_PREFIX}_raw.cpp"
FIXED_CPP="${OUTPUT_PREFIX}_fixed.cpp" 
FINAL_CPP="${OUTPUT_PREFIX}.cpp"
EXECUTABLE="${OUTPUT_PREFIX}"
COMPILE_SCRIPT="${OUTPUT_PREFIX}_compile.sh"

echo "步骤 1: 初始转换"
echo "================"
echo "输入文件: $INPUT_FILE"
echo "原始输出: $RAW_CPP"

cd "$SDK_DIR"

# 第一步：使用简化转换器进行初始转换
if ! dart tools/simple_dart_to_cpp.dart "$INPUT_FILE" "$RAW_CPP"; then
    echo "❌ 初始转换失败"
    exit 1
fi
echo "✅ 初始转换完成"
echo ""

echo "步骤 2: 后处理修复"
echo "================"
echo "修复输出: $FIXED_CPP"

# 第二步：使用后处理器修复语法问题
if ! dart tools/cpp_post_processor.dart "$RAW_CPP" "$FIXED_CPP"; then
    echo "❌ 后处理修复失败"
    exit 1
fi
echo "✅ 后处理修复完成"
echo ""

echo "步骤 3: 最终优化"
echo "================"
echo "最终输出: $FINAL_CPP"

# 第三步：创建最终优化版本
cp "$FIXED_CPP" "$FINAL_CPP"

# 添加必要的包含和修复
cat > temp_header.cpp << 'EOF'
#include "../pkg/dart2bytecode/base/object.h"
#include <iostream>
#include <string>
#include <vector>
#include <map>
#include <set>
#include <algorithm>

// 工具宏定义
#define dart_print(value) \
    do { \
        std::cout << (value).toString().getValue() << std::endl; \
    } while(0)

#define dart_int(value) Int(value)
#define dart_double(value) Double(value)
#define dart_bool(value) Bool(value)
#define dart_string(value) String(value)

// 集合类型辅助函数
template<typename T>
List<T> dart_list_from_values(std::initializer_list<T> values) {
    List<T> result = List<T>::create();
    for (const auto& value : values) {
        result.add(value);
    }
    return result;
}

template<typename T>
Set<T> dart_set_from_values(std::initializer_list<T> values) {
    Set<T> result = Set<T>::create();
    for (const auto& value : values) {
        result.add(value);
    }
    return result;
}

EOF

# 提取原文件中除头文件外的内容
tail -n +30 "$FIXED_CPP" > temp_body.cpp

# 合并头文件和主体
cat temp_header.cpp temp_body.cpp > "$FINAL_CPP"

# 清理临时文件
rm -f temp_header.cpp temp_body.cpp

echo "✅ 最终优化完成"
echo ""

echo "步骤 4: 创建编译脚本"
echo "==================="
echo "编译脚本: $COMPILE_SCRIPT"

# 第四步：创建编译脚本
cat > "$COMPILE_SCRIPT" << EOF
#!/bin/bash
set -e

echo "编译 Dart 到 C++ 转换后的代码..."
echo "================================="

CXX=\${CXX:-g++}
CXXFLAGS="\${CXXFLAGS:--std=c++17 -Wall -Wextra -O2 -I.}"

echo "使用编译器: \$CXX"
echo "编译选项: \$CXXFLAGS"
echo ""

# 编译
echo "正在编译 $FINAL_CPP ..."
\$CXX \$CXXFLAGS \\
    "$FINAL_CPP" \\
    "pkg/dart2bytecode/base/object.cpp" \\
    -o "$EXECUTABLE"

if [ \$? -eq 0 ]; then
    echo "✅ 编译成功！"
    echo "可执行文件: \\$PWD/$EXECUTABLE"
    echo ""
    echo "运行程序:"
    echo "=========="
    "./$EXECUTABLE"
else
    echo "❌ 编译失败！"
    exit 1
fi
EOF

chmod +x "$COMPILE_SCRIPT"
echo "✅ 编译脚本创建完成"
echo ""

echo "步骤 5: 尝试编译"
echo "================"

# 第五步：尝试编译
if ./"$COMPILE_SCRIPT"; then
    echo ""
    echo "🎉 完整转换流程成功完成！"
    echo ""
    echo "生成的文件:"
    echo "  - 原始转换: $RAW_CPP"
    echo "  - 修复版本: $FIXED_CPP"
    echo "  - 最终版本: $FINAL_CPP"
    echo "  - 可执行文件: $EXECUTABLE"
    echo "  - 编译脚本: $COMPILE_SCRIPT"
    echo ""
    echo "可以使用以下命令重新编译和运行:"
    echo "  ./$COMPILE_SCRIPT"
else
    echo "⚠️ 编译失败，但转换文件已生成"
    echo "请检查 $FINAL_CPP 中的语法问题"
    echo ""
    echo "生成的文件:"
    echo "  - 原始转换: $RAW_CPP"
    echo "  - 修复版本: $FIXED_CPP"
    echo "  - 最终版本: $FINAL_CPP"
    echo "  - 编译脚本: $COMPILE_SCRIPT"
fi

echo ""
echo "转换统计信息:"
echo "============="
echo "原始 Dart 文件: $(wc -l < "$INPUT_FILE") 行"
echo "转换后 C++ 文件: $(wc -l < "$FINAL_CPP") 行"

# 统计类和函数数量
CLASSES=$(grep -c "^class " "$FINAL_CPP" || true)
FUNCTIONS=$(grep -c "^[[:space:]]*[a-zA-Z_][a-zA-Z0-9_]*[[:space:]]*(" "$FINAL_CPP" || true)

echo "转换后的类数量: $CLASSES"
echo "转换后的函数数量: $FUNCTIONS"
echo ""
echo "=== 转换工作流完成 ==="
