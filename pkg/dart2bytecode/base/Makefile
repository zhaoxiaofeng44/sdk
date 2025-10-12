# Makefile for object.h/cpp

CXX = g++
CXXFLAGS = -std=c++11 -Wall -Wextra -O2
INCLUDES = -I.

# 源文件
SOURCES = object.cpp
OBJECTS = $(SOURCES:.cpp=.o)

# 测试文件
TEST_SOURCE = ../../../test_api/string_pool_test.cpp
TEST_EXEC = string_pool_test

# 默认目标
all: test

# 编译对象文件
%.o: %.cpp %.h
	$(CXX) $(CXXFLAGS) $(INCLUDES) -c $< -o $@

# 编译测试程序
$(TEST_EXEC): $(OBJECTS) $(TEST_SOURCE)
	$(CXX) $(CXXFLAGS) $(INCLUDES) $(OBJECTS) $(TEST_SOURCE) -o $(TEST_EXEC)

# 运行测试
test: $(TEST_EXEC)
	@echo "运行测试..."
	@./$(TEST_EXEC)

# 清理
clean:
	rm -f $(OBJECTS) $(TEST_EXEC)

# 重新编译
rebuild: clean all

# 显示帮助
help:
	@echo "可用目标:"
	@echo "  make all     - 编译并运行测试（默认）"
	@echo "  make test    - 编译并运行测试"
	@echo "  make clean   - 清理生成的文件"
	@echo "  make rebuild - 清理并重新编译"
	@echo "  make help    - 显示此帮助信息"

.PHONY: all test clean rebuild help

