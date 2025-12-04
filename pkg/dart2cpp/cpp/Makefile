# Dart2CPP C++ Runtime Makefile

CXX = g++
CXXFLAGS = -std=c++17 -Wall -Wextra -I./core

CORE_DIR = core
TEST_DIR = test
EXAMPLES_DIR = examples
BUILD_DIR = build

# Core library
CORE_SRC = $(CORE_DIR)/dart_object.cpp $(CORE_DIR)/dart_string.cpp
CORE_OBJ = $(BUILD_DIR)/dart_object.o $(BUILD_DIR)/dart_string.o

# Test files - all available tests
TEST_SOURCES = $(wildcard $(TEST_DIR)/*.cpp)
TEST_TARGETS = $(patsubst $(TEST_DIR)/%.cpp,$(BUILD_DIR)/%,$(filter-out %.backup,$(TEST_SOURCES)))

# Example files  
EXAMPLE_SOURCES = $(wildcard $(EXAMPLES_DIR)/*.cpp)
EXAMPLE_TARGETS = $(patsubst $(EXAMPLES_DIR)/%.cpp,$(BUILD_DIR)/%,$(EXAMPLE_SOURCES))

.PHONY: all clean test test-all run-tests examples

all: $(BUILD_DIR) $(CORE_OBJ)

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

$(BUILD_DIR)/dart_object.o: $(CORE_DIR)/dart_object.cpp
	$(CXX) $(CXXFLAGS) -c $< -o $@

$(BUILD_DIR)/dart_string.o: $(CORE_DIR)/dart_string.cpp
	$(CXX) $(CXXFLAGS) -c $< -o $@

examples: $(BUILD_DIR) $(CORE_OBJ)
	@echo "Compiling examples..."
	@for example_file in $(EXAMPLE_SOURCES); do \
		example_name=$$(basename $$example_file .cpp); \
		$(CXX) $(CXXFLAGS) $$example_file $(CORE_OBJ) -o $(BUILD_DIR)/$$example_name || exit 1; \
	done
	@echo "Examples compiled successfully"

# Compile all tests
test: $(BUILD_DIR) $(CORE_OBJ)
	@echo "Compiling tests..."
	@failed_count=0; \
	success_count=0; \
	for test_file in $(TEST_DIR)/*.cpp; do \
		if echo "$$test_file" | grep -q ".backup"; then \
			continue; \
		fi; \
		test_name=$$(basename "$$test_file" .cpp); \
		echo "  Compiling $$test_name..."; \
		if $(CXX) $(CXXFLAGS) "$$test_file" $(CORE_OBJ) -o $(BUILD_DIR)/$$test_name 2>$(BUILD_DIR)/$$test_name.err; then \
			echo "  ✓ $$test_name compiled successfully"; \
			success_count=$$((success_count + 1)); \
		else \
			echo "  ✗ $$test_name failed to compile"; \
			failed_count=$$((failed_count + 1)); \
		fi \
	done; \
	echo ""; \
	echo "Compilation summary:"; \
	echo "  ✓ Successful: $$success_count"; \
	echo "  ✗ Failed: $$failed_count"

# Run the successfully compiled tests
run-tests: test
	@echo ""
	@echo "Running compiled tests..."
	@for test_exe in $(BUILD_DIR)/*_test; do \
		if [ -x "$$test_exe" ]; then \
			test_name=$$(basename "$$test_exe"); \
			echo ""; \
			echo "=== Running $$test_name ==="; \
			if ./$$test_exe; then \
				echo "✓ $$test_name passed"; \
			else \
				echo "✗ $$test_name failed"; \
			fi \
		fi \
	done
	@echo ""
	@echo "All tests completed"

clean:
	rm -rf $(BUILD_DIR)

rebuild: clean all