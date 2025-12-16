#!/bin/bash
# 修复生成的 C++ 代码中的特殊字符（|、#等）

if [ -z "$1" ]; then
  echo "Usage: $0 <cpp_file>"
  echo "Example: $0 sample/cpp_generated/constants.cpp"
  exit 1
fi

FILE="$1"

if [ ! -f "$FILE" ]; then
  echo "Error: File $FILE not found"
  exit 1
fi

echo "🔧 Fixing identifiers in $FILE..."

# 恢复原始文件（如果有备份的话）
if [ -f "${FILE}.bak" ]; then
  cp "${FILE}.bak" "$FILE"
else
  # 创建新备份
  cp "$FILE" "${FILE}.bak"
fi

# 替换特殊字符（注意：不要替换 #include 等预处理指令）
# 1. 替换类型名和函数名中的 | 为 _
sed -i '' 's/\([a-zA-Z_][a-zA-Z0-9_]*\)|/\1_/g' "$FILE"

# 2. 替换参数名 #this 为 _this（只在参数列表中）
sed -i '' 's/Double #this/Double _this/g' "$FILE"
sed -i '' 's/Int #this/Int _this/g' "$FILE"
sed -i '' 's/String #this/String _this/g' "$FILE"
sed -i '' 's/Bool #this/Bool _this/g' "$FILE"

# 3. 替换 get# 为 get_（在函数名中）
sed -i '' 's/get#/get_/g' "$FILE"

echo "✅ Fixed! Backup saved as ${FILE}.bak"
echo ""
echo "🔍 Verifying changes..."
echo "Checking for remaining special characters..."
grep -n "Extension|" "$FILE" | head -3 && echo "⚠️  Still has | characters" || echo "✅ No | in extension names"
grep -n "Double #\|Int #\|String #" "$FILE" | head -3 && echo "⚠️  Still has # in parameters" || echo "✅ No # in parameters"
