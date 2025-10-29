# Dart2CPP C++ Runtime Makefile

CXX = g++
CXXFLAGS = -std=c++11 -Wall -Wextra -I./core

CORE_DIR = core
TEST_DIR = test
EXAMPLES_DIR = examples
BUILD_DIR = build

# Core library
CORE_SRC = $(CORE_DIR)/object.cpp
CORE_OBJ = $(BUILD_DIR)/object.o

# Test files
TEST_SOURCES = $(wildcard $(TEST_DIR)/*.cpp)
TEST_TARGETS = $(patsubst $(TEST_DIR)/%.cpp,$(BUILD_DIR)/%,$(TEST_SOURCES))

# Example files  
EXAMPLE_SOURCES = $(wildcard $(EXAMPLES_DIR)/*.cpp)
EXAMPLE_TARGETS = $(patsubst $(EXAMPLES_DIR)/%.cpp,$(BUILD_DIR)/%,$(EXAMPLE_SOURCES))

.PHONY: all clean test examples

all: $(BUILD_DIR) $(CORE_OBJ)

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

$(CORE_OBJ): $(CORE_SRC)
	$(CXX) $(CXXFLAGS) -c $< -o $@

test: $(BUILD_DIR) $(CORE_OBJ)
	@echo "Compiling tests..."
	@for test_file in $(TEST_SOURCES); do \
		test_name=$$(basename $$test_file .cpp); \
		$(CXX) $(CXXFLAGS) $$test_file $(CORE_OBJ) -o $(BUILD_DIR)/$$test_name || exit 1; \
	done
	@echo "Tests compiled successfully"

examples: $(BUILD_DIR) $(CORE_OBJ)
	@echo "Compiling examples..."
	@for example_file in $(EXAMPLE_SOURCES); do \
		example_name=$$(basename $$example_file .cpp); \
		$(CXX) $(CXXFLAGS) $$example_file $(CORE_OBJ) -o $(BUILD_DIR)/$$example_name || exit 1; \
	done
	@echo "Examples compiled successfully"

clean:
	rm -rf $(BUILD_DIR)

rebuild: clean all

