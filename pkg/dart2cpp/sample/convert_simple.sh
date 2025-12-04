#!/bin/bash

# 简化版 Dart to C++ 批量转换脚本
# 将 sample/dart 目录下的所有 .dart 文件转换为 C++ 文件并放到 sample/cpp 目录

# 获取脚本所在目录
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
DART_DIR="$SCRIPT_DIR/dart"
CPP_DIR="$SCRIPT_DIR/cpp"
DART2CPP_BIN="$PROJECT_ROOT/bin/dart2cpp.dart"

echo "========================================"
echo "🚀 Dart to C++ 批量转换工具 (简化版)"
echo "========================================"
echo

# 检查 dart 命令
if ! command -v dart &> /dev/null; then
    echo "❌ 错误: Dart SDK 未找到，请确保 dart 命令在 PATH 中"
    exit 1
fi

# 检查 dart2cpp 工具
if [ ! -f "$DART2CPP_BIN" ]; then
    echo "❌ 错误: dart2cpp 工具未找到: $DART2CPP_BIN"
    exit 1
fi

# 检查输入目录
if [ ! -d "$DART_DIR" ]; then
    echo "❌ 错误: 输入目录不存在: $DART_DIR"
    exit 1
fi

echo "📂 输入目录: $DART_DIR"
echo "📂 输出目录: $CPP_DIR"
echo

# 清理并创建输出目录
echo "🧹 清理输出目录..."
if [ -d "$CPP_DIR" ]; then
    rm -rf "$CPP_DIR"
fi
mkdir -p "$CPP_DIR"
echo "✅ 输出目录已准备完毕"
echo

# 转换所有 .dart 文件
echo "🔄 开始转换文件..."
total_files=0
success_files=0
failed_files=0

for dart_file in "$DART_DIR"/*.dart; do
    if [ -f "$dart_file" ]; then
        # 获取文件名（不含路径和扩展名）
        filename=$(basename "$dart_file" .dart)
        cpp_file="$CPP_DIR/${filename}.cpp"
        
        total_files=$((total_files + 1))
        
        echo "  转换: ${filename}.dart"
        
        # 执行转换
        if dart "$DART2CPP_BIN" --output "$cpp_file" --optimize "$dart_file" 2>/dev/null; then
            echo "  ✅ 成功: ${filename}.dart -> ${filename}.cpp"
            success_files=$((success_files + 1))
        else
            echo "  ❌ 失败: ${filename}.dart"
            failed_files=$((failed_files + 1))
        fi
        echo
    fi
done

# 创建简单的 Makefile
echo "📝 创建 Makefile..."
cat > "$CPP_DIR/Makefile" << 'EOF'
# 简单的 Makefile for Sample C++ Files

CXX = g++
CXXFLAGS = -std=c++17 -Wall -I../../cpp/core -Wno-unused-parameter -Wno-deprecated-copy-with-user-provided-copy

# 查找所有 .cpp 文件
SOURCES = $(wildcard *.cpp)
TARGETS = $(SOURCES:.cpp=.out)

all: $(TARGETS)

%.out: %.cpp ../../cpp/core/object.cpp
	$(CXX) $(CXXFLAGS) -o $@ $< ../../cpp/core/object.cpp

clean:
	rm -f *.out

.PHONY: all clean
EOF

echo "✅ Makefile 已创建"
echo

# 打印统计信息
echo "=================================="
echo "📊 转换统计:"
echo "  总文件数: $total_files"
echo "  成功: $success_files"
echo "  失败: $failed_files"
echo "=================================="

if [ $failed_files -eq 0 ] && [ $total_files -gt 0 ]; then
    echo "🎉 所有文件转换成功！"
    echo
    echo "💡 使用方法:"
    echo "  cd $CPP_DIR"
    echo "  make all      # 编译所有文件"
    echo "  make clean    # 清理编译文件"
    exit 0
elif [ $total_files -eq 0 ]; then
    echo "⚠️  没有找到 .dart 文件"
    exit 1
else
    echo "⚠️  部分文件转换失败"
    exit 1
fi
