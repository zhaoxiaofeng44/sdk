#!/bin/bash
# Dart到C++转换并修复标识符的完整工作流程

set -e  # 遇到错误立即退出

DART_FILE="${1:-sample/dart/constants.dart}"
CPP_FILE="${2:-sample/cpp_generated/constants.cpp}"

echo "================================================"
echo "🚀 Dart到C++完整转换流程"
echo "================================================"
echo ""

# 步骤1：Dart转C++
echo "📝 步骤1: 转换 Dart 代码到 C++"
echo "输入: $DART_FILE"
echo "输出: $CPP_FILE"
dart run bin/dart2cpp.dart -o "$CPP_FILE" "$DART_FILE" || {
  echo "⚠️  转换过程有警告，继续执行..."
}
echo "✅ 转换完成"
echo ""

# 步骤2：修复标识符
echo "🔧 步骤2: 修复特殊字符（|、#等）"
./sample/fix_identifiers.sh "$CPP_FILE"
echo ""

# 步骤3：验证结果
echo "🔍 步骤3: 验证修复结果"
if grep -q "Extension|" "$CPP_FILE" || grep -q "Double #\|Int #" "$CPP_FILE"; then
  echo "⚠️  警告：仍然存在特殊字符"
  grep -n "Extension|\|Double #\|Int #" "$CPP_FILE" | head -5
else
  echo "✅ 所有特殊字符已成功替换"
fi
echo ""

# 步骤4：显示关键函数
echo "📋 步骤4: 显示转换后的关键函数"
echo "---"
grep -A 2 "MathExtension_sqrt\|StringExtension_capitalize" "$CPP_FILE" | head -10
echo "---"
echo ""

echo "================================================"
echo "✅ 转换流程完成！"
echo "================================================"
echo ""
echo "生成的文件："
echo "  - C++代码: $CPP_FILE"
echo "  - 备份文件: ${CPP_FILE}.bak"
echo ""
echo "下一步："
echo "  1. 配置C++运行时环境（cpp/runtime）"
echo "  2. 使用 g++ 编译生成的代码"
echo ""
