# Dart2CPP Demo Root Makefile
# 用于编译由dart2cpp.dart生成的C++代码

CXX = g++
CXXFLAGS = -std=c++14 -Wall -Wextra -Icpp/../../cpp/core -pthread

# 目录定义
CORE_DIR = cpp/../../cpp/core
BUILD_DIR = build
CPP_DIR = cpp

# 核心库文件
CORE_SRC = $(CORE_DIR)/object.cpp
CORE_OBJ = $(BUILD_DIR)/object.o

# 生成的C++源文件（在cpp目录中）
GENERATED_SOURCES = $(wildcard $(CPP_DIR)/*.cpp)
GENERATED_TARGETS = $(patsubst $(CPP_DIR)/%.cpp,$(BUILD_DIR)/%,$(GENERATED_SOURCES))

# 手动编写的演示文件（在cpp目录中）
MANUAL_SOURCES = $(wildcard $(CPP_DIR)/*_demo.cpp)
MANUAL_TARGETS = $(patsubst $(CPP_DIR)/%.cpp,$(BUILD_DIR)/%,$(MANUAL_SOURCES))

.PHONY: all clean run-all help generated manual

all: $(BUILD_DIR) $(CORE_OBJ) $(GENERATED_TARGETS)

# 创建构建目录
$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

# 编译核心库
$(CORE_OBJ): $(CORE_SRC)
	$(CXX) $(CXXFLAGS) -c $< -o $@

# 编译生成的C++文件
$(BUILD_DIR)/%: $(CPP_DIR)/%.cpp $(CORE_OBJ)
	$(CXX) $(CXXFLAGS) $< $(CORE_OBJ) -o $@

# 编译所有生成的文件
generated: $(BUILD_DIR) $(CORE_OBJ) $(GENERATED_TARGETS)
	@echo "✅ 所有生成的C++文件编译完成"

# 编译手动编写的演示文件
manual: $(BUILD_DIR) $(CORE_OBJ) $(MANUAL_TARGETS)
	@echo "✅ 所有手动演示文件编译完成"

# 运行所有可执行文件
run-all: all
	@echo "=== 运行所有编译的程序 ==="
	@for exe in $(BUILD_DIR)/*; do \
		if [ -f "$$exe" ] && [ -x "$$exe" ]; then \
			echo ""; \
			echo "=== 运行 $$(basename $$exe) ==="; \
			$$exe || echo "程序 $$(basename $$exe) 执行失败"; \
		fi \
	done
	@echo ""
	@echo "=== 所有程序运行完成 ==="

# 运行特定程序
run-%: $(BUILD_DIR)/%
	@echo "=== 运行 $* ==="
	@$(BUILD_DIR)/$*

# 列出所有可用的目标
list:
	@echo "可用的编译目标:"
	@for src in $(GENERATED_SOURCES); do \
		target=$$(basename $$src .cpp); \
		echo "  run-$$target"; \
	done

# 清理生成的文件
clean:
	rm -rf $(BUILD_DIR)
	@echo "✅ 清理完成"

# 重新编译
rebuild: clean all

# 帮助信息
help:
	@echo "Dart2CPP Demo Makefile"
	@echo ""
	@echo "可用命令:"
	@echo "  make all           - 编译所有生成的C++文件"
	@echo "  make generated     - 只编译生成的C++文件"
	@echo "  make manual        - 只编译手动编写的演示文件"
	@echo "  make run-all       - 运行所有编译的程序"
	@echo "  make run-<name>    - 运行特定程序（如: make run-async_demo）"
	@echo "  make list          - 列出所有可用的运行目标"
	@echo "  make clean         - 清理编译文件"
	@echo "  make rebuild       - 重新编译"
	@echo "  make help          - 显示此帮助信息"
	@echo ""
	@echo "示例:"
	@echo "  make run-async_demo     # 运行异步演示"
	@echo "  make run-library_filter_test  # 运行库过滤测试"