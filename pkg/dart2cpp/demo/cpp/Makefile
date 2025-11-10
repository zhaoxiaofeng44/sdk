# Dart2CPP Demo C++ Project Makefile

CXX = g++
CXXFLAGS = -std=c++14 -Wall -Wextra -I../../cpp/core -pthread

# 目录定义
CORE_DIR = ../../cpp/core
BUILD_DIR = build

# 核心库文件
CORE_SRC = $(CORE_DIR)/object.cpp
CORE_OBJ = $(BUILD_DIR)/object.o

# Demo 源文件
DEMO_SOURCES = $(wildcard *.cpp)
DEMO_TARGETS = $(patsubst %.cpp,$(BUILD_DIR)/%,$(DEMO_SOURCES))

.PHONY: all clean run-all

all: $(BUILD_DIR) $(CORE_OBJ) $(DEMO_TARGETS)

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

$(CORE_OBJ): $(CORE_SRC)
	$(CXX) $(CXXFLAGS) -c $< -o $@

$(BUILD_DIR)/%: %.cpp $(CORE_OBJ)
	$(CXX) $(CXXFLAGS) $< $(CORE_OBJ) -o $@

# 运行所有演示
run-all: all
	@echo "=== 运行所有 C++ 演示程序 ==="
	@for demo in $(DEMO_TARGETS); do \
		if [ -f "$demo" ]; then \
			echo ""; \
			echo "=== 运行 $(basename $demo) ==="; \
			$demo; \
		fi \
	done
	@echo ""
	@echo "=== 所有演示程序运行完成 ==="

# 单独运行各个演示
run-basic: $(BUILD_DIR)/basic_syntax_demo
	@echo "=== 运行基础语法演示 ==="
	@$(BUILD_DIR)/basic_syntax_demo

run-collections: $(BUILD_DIR)/collections_demo
	@echo "=== 运行集合演示 ==="
	@$(BUILD_DIR)/collections_demo

run-oop: $(BUILD_DIR)/oop_demo
	@echo "=== 运行面向对象演示 ==="
	@$(BUILD_DIR)/oop_demo

run-generics: $(BUILD_DIR)/generics_demo
	@echo "=== 运行泛型演示 ==="
	@$(BUILD_DIR)/generics_demo

run-exception: $(BUILD_DIR)/exception_demo
	@echo "=== 运行异常处理演示 ==="
	@$(BUILD_DIR)/exception_demo

run-async: $(BUILD_DIR)/async_demo
	@echo "=== 运行异步编程演示 ==="
	@$(BUILD_DIR)/async_demo

run-comprehensive: $(BUILD_DIR)/comprehensive_demo
	@echo "=== 运行综合演示 ==="
	@$(BUILD_DIR)/comprehensive_demo

run-test: $(BUILD_DIR)/comprehensive_test
	@echo "=== 运行综合测试 ==="
	@$(BUILD_DIR)/comprehensive_test

run-optimization: $(BUILD_DIR)/optimization_demo
	@echo "=== 运行优化演示 ==="
	@$(BUILD_DIR)/optimization_demo

run-library-filter: $(BUILD_DIR)/library_filter_test
	@echo "=== 运行库过滤测试 ==="
	@$(BUILD_DIR)/library_filter_test

# 帮助信息
help:
	@echo "可用的目标:"
	@echo "  all              - 编译所有演示程序"
	@echo "  run-all          - 运行所有演示程序"
	@echo "  run-basic        - 运行基础语法演示"
	@echo "  run-collections  - 运行集合演示"
	@echo "  run-oop          - 运行面向对象演示"
	@echo "  run-generics     - 运行泛型演示"
	@echo "  run-exception    - 运行异常处理演示"
	@echo "  run-async        - 运行异步编程演示"
	@echo "  run-comprehensive- 运行综合演示"
	@echo "  run-test         - 运行综合测试"
	@echo "  run-optimization - 运行优化演示"
	@echo "  run-library-filter - 运行库过滤测试"
	@echo "  clean            - 清理编译文件"
	@echo "  rebuild          - 重新编译"
	@echo "  help             - 显示此帮助信息"

clean:
	rm -rf $(BUILD_DIR)

rebuild: clean all