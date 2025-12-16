# ============================================================================
# Makefile for Dart2CPP Test Suite
# ============================================================================

# 编译器设置
CXX = g++
CXXFLAGS = -std=c++17 -Wall -Wextra -O2 -I../core
LDFLAGS = 

# 目录设置
CORE_DIR = ../core
TEST_DIR = .
BUILD_DIR = build

# 源文件 - 只包含实际存在的测试文件
CORE_SOURCES = $(CORE_DIR)/dart_object.cpp $(CORE_DIR)/dart_string.cpp
TEST_SOURCES = basic_types_test.cpp operators_test.cpp macros_test.cpp comprehensive_test.cpp collections_test.cpp oop_test.cpp async_test.cpp function_test.cpp

# 目标文件
CORE_OBJECTS = $(BUILD_DIR)/dart_object.o $(BUILD_DIR)/dart_string.o
TEST_EXECUTABLES = $(BUILD_DIR)/basic_types_test $(BUILD_DIR)/operators_test $(BUILD_DIR)/macros_test $(BUILD_DIR)/comprehensive_test $(BUILD_DIR)/collections_test $(BUILD_DIR)/oop_test $(BUILD_DIR)/async_test $(BUILD_DIR)/function_test

# 默认目标
all: $(BUILD_DIR) $(TEST_EXECUTABLES)

# 创建构建目录
$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

# 编译核心对象文件
$(BUILD_DIR)/dart_object.o: $(CORE_DIR)/dart_object.cpp $(CORE_DIR)/dart_object.h
	$(CXX) $(CXXFLAGS) -c $< -o $@

$(BUILD_DIR)/dart_string.o: $(CORE_DIR)/dart_string.cpp $(CORE_DIR)/dart_string.h
	$(CXX) $(CXXFLAGS) -c $< -o $@

# 编译测试可执行文件
$(BUILD_DIR)/basic_types_test: basic_types_test.cpp $(CORE_OBJECTS)
	$(CXX) $(CXXFLAGS) $< $(CORE_OBJECTS) -o $@ $(LDFLAGS)

$(BUILD_DIR)/operators_test: operators_test.cpp $(CORE_OBJECTS)
	$(CXX) $(CXXFLAGS) $< $(CORE_OBJECTS) -o $@ $(LDFLAGS)

$(BUILD_DIR)/macros_test: macros_test.cpp $(CORE_OBJECTS)
	$(CXX) $(CXXFLAGS) $< $(CORE_OBJECTS) -o $@ $(LDFLAGS)

$(BUILD_DIR)/comprehensive_test: comprehensive_test.cpp $(CORE_OBJECTS)
	$(CXX) $(CXXFLAGS) $< $(CORE_OBJECTS) -o $@ $(LDFLAGS)

$(BUILD_DIR)/collections_test: collections_test.cpp $(CORE_OBJECTS)
	$(CXX) $(CXXFLAGS) $< $(CORE_OBJECTS) -o $@ $(LDFLAGS)

$(BUILD_DIR)/oop_test: oop_test.cpp $(CORE_OBJECTS)
	$(CXX) $(CXXFLAGS) $< $(CORE_OBJECTS) -o $@ $(LDFLAGS)

$(BUILD_DIR)/async_test: async_test.cpp $(CORE_OBJECTS)
	$(CXX) $(CXXFLAGS) $< $(CORE_OBJECTS) -o $@ $(LDFLAGS) -pthread

$(BUILD_DIR)/function_test: function_test.cpp $(CORE_OBJECTS)
	$(CXX) $(CXXFLAGS) $< $(CORE_OBJECTS) -o $@ $(LDFLAGS)

# 运行所有测试
test: all
	@echo "=== 运行所有测试 ==="
	@echo ""
	@echo "--- 基础数据类型测试 ---"
	@$(BUILD_DIR)/basic_types_test
	@echo ""
	@echo "--- 运算符重载测试 ---"
	@$(BUILD_DIR)/operators_test
	@echo ""
	@echo "--- 宏和工具测试 ---"
	@$(BUILD_DIR)/macros_test
	@echo ""
	@echo "--- 综合测试 ---"
	@$(BUILD_DIR)/comprehensive_test
	@echo ""
	@echo "--- 集合类型测试 ---"
	@$(BUILD_DIR)/collections_test
	@echo ""
	@echo "--- 面向对象编程测试 ---"
	@$(BUILD_DIR)/oop_test
	@echo ""
	@echo "--- 异步编程测试 ---"
	@$(BUILD_DIR)/async_test
	@echo ""
	@echo "--- Function 类型测试 ---"
	@$(BUILD_DIR)/function_test
	@echo ""
	@echo "=== 所有测试完成! ==="

# 运行单个测试
test-basic: $(BUILD_DIR)/basic_types_test
	@$(BUILD_DIR)/basic_types_test

test-operators: $(BUILD_DIR)/operators_test
	@$(BUILD_DIR)/operators_test

test-macros: $(BUILD_DIR)/macros_test
	@$(BUILD_DIR)/macros_test

test-comprehensive: $(BUILD_DIR)/comprehensive_test
	@$(BUILD_DIR)/comprehensive_test

test-collections: $(BUILD_DIR)/collections_test
	@$(BUILD_DIR)/collections_test

test-oop: $(BUILD_DIR)/oop_test
	@$(BUILD_DIR)/oop_test

test-async: $(BUILD_DIR)/async_test
	@$(BUILD_DIR)/async_test

test-function: $(BUILD_DIR)/function_test
	@$(BUILD_DIR)/function_test

# 清理构建文件
clean:
	rm -rf $(BUILD_DIR)

# 重新构建
rebuild: clean all

# 调试版本
debug: CXXFLAGS += -g -DDEBUG
debug: all

# 发布版本
release: CXXFLAGS += -O3 -DNDEBUG
release: all

# 代码检查
check:
	@echo "=== 代码检查 ==="
	@echo "检查编译警告..."
	@$(CXX) $(CXXFLAGS) -fsyntax-only $(TEST_SOURCES)
	@echo "代码检查完成!"

# 帮助信息
help:
	@echo "Dart2CPP 测试套件 Makefile"
	@echo ""
	@echo "可用目标:"
	@echo "  all                 - 编译所有测试"
	@echo "  test                - 运行所有测试"
	@echo "  test-basic          - 运行基础数据类型测试"
	@echo "  test-operators      - 运行运算符重载测试"
	@echo "  test-macros         - 运行宏和工具测试"
	@echo "  test-comprehensive  - 运行综合测试"
	@echo "  test-collections    - 运行集合类型测试"
	@echo "  test-oop            - 运行面向对象编程测试"
	@echo "  test-async          - 运行异步编程测试"
	@echo "  test-function       - 运行 Function 类型测试"
	@echo "  clean               - 清理构建文件"
	@echo "  rebuild             - 重新构建"
	@echo "  debug               - 编译调试版本"
	@echo "  release             - 编译发布版本"
	@echo "  check               - 代码检查"
	@echo "  help                - 显示此帮助信息"
	@echo ""
	@echo "示例:"
	@echo "  make                # 编译所有测试"
	@echo "  make test           # 运行所有测试"
	@echo "  make test-basic     # 只运行基础类型测试"
	@echo "  make clean          # 清理构建文件"

# 声明伪目标
.PHONY: all test test-basic test-operators test-macros test-comprehensive test-collections test-oop test-async test-function clean rebuild debug release check help

# 依赖关系
$(TEST_EXECUTABLES): $(CORE_OBJECTS)
