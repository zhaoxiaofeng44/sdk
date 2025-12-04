# Dart2CPP Testing - Quick Start Guide

## Overview

This guide will help you quickly get started with testing the Dart2CPP transpiler using the comprehensive test suite.

## Prerequisites

Before running the tests, ensure you have:

- ✅ Dart SDK installed (version 2.12 or later)
- ✅ G++ compiler with C++17 support
- ✅ Make or CMake (optional, for building C++ runtime)

### Verify Prerequisites

```bash
# Check Dart version
dart --version

# Check G++ version
g++ --version

# Check C++17 support
g++ -std=c++17 --version
```

## Quick Start (5 Minutes)

### Step 1: Navigate to Project Directory

```bash
cd /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2cpp
```

### Step 2: Install Dart Dependencies

```bash
dart pub get
```

### Step 3: Run Dart Tests Only

```bash
# Run all Dart tests
dart test/comprehensive_syntax_test.dart
dart test/advanced_features_test.dart
dart test/edge_cases_test.dart
```

Expected output:
```
=== Comprehensive Dart to C++ Syntax Test ===

Test 1: Basic Types
  Int: 42, -10, 0
  Double: 3.14159, -2.5, 1500.0
  Bool: true, false
  String: Hello, World, ""
  ✓ Basic types test passed

...

=== All Tests Completed ===
```

### Step 4: Test Dart to C++ Conversion

```bash
# Convert a single test file
dart bin/dart2cpp.dart test/comprehensive_syntax_test.dart -o test/comprehensive_syntax_test.cpp

# Check if conversion succeeded
ls -lh test/comprehensive_syntax_test.cpp
```

### Step 5: Compile Generated C++ Code

```bash
# Compile the generated C++ code
g++ -std=c++17 -I./cpp/core \
    test/comprehensive_syntax_test.cpp \
    cpp/core/object.cpp \
    -o test/comprehensive_syntax_test.out

# Check if compilation succeeded
ls -lh test/comprehensive_syntax_test.out
```

### Step 6: Run C++ Executable

```bash
# Run the compiled executable
./test/comprehensive_syntax_test.out
```

Expected output should match the Dart version output.

## Automated Testing (Recommended)

### Run All Tests Automatically

```bash
# This will:
# 1. Run Dart version
# 2. Convert to C++
# 3. Compile C++
# 4. Run C++ version
# 5. Report results

dart test/run_comprehensive_tests.dart
```

Expected output:
```
╔════════════════════════════════════════════════════════════╗
║     Dart2CPP Comprehensive Test Suite Runner              ║
╚════════════════════════════════════════════════════════════╝

═══════════════════════════════════════════════════════════
Running: comprehensive_syntax_test.dart
═══════════════════════════════════════════════════════════
Step 1: Running Dart version...
  ✅ Dart execution successful
Step 2: Converting to C++...
  ✅ Conversion successful: test/comprehensive_syntax_test.cpp
Step 3: Compiling C++...
  ✅ Compilation successful: test/comprehensive_syntax_test.out
Step 4: Running C++ version...
  ✅ C++ execution successful
✅ PASSED

...

╔════════════════════════════════════════════════════════════╗
║                    TEST SUMMARY                            ║
╚════════════════════════════════════════════════════════════╝

Total Tests:  3
Passed:       3 ✅
Failed:       0 ❌
Success Rate: 100.0%
```

## Test Files Overview

### 1. comprehensive_syntax_test.dart
Tests all basic Dart syntax features:
- Basic types (int, double, bool, String)
- Operators (arithmetic, comparison, logical)
- String operations
- Collections (List, Map, Set)
- Control flow (if, for, while, switch)
- Functions
- Classes and objects
- Inheritance
- Exception handling
- Type conversions
- Null safety

### 2. advanced_features_test.dart
Tests advanced Dart language features:
- Generics
- Closures
- Higher-order functions
- Cascade notation
- Enums
- Mixins
- Factory constructors
- Operator overloading
- Getters and setters
- Static members

### 3. edge_cases_test.dart
Tests edge cases and boundary conditions:
- Numeric edge cases
- String edge cases
- Collection edge cases
- Null edge cases
- Division edge cases
- Overflow cases
- Empty collections
- Nested structures
- Recursion edge cases
- Boundary conditions

## Common Issues and Solutions

### Issue 1: Dart SDK Not Found

**Error:**
```
dart: command not found
```

**Solution:**
```bash
# Install Dart SDK
# macOS
brew install dart

# Linux
sudo apt-get install dart

# Or download from https://dart.dev/get-dart
```

### Issue 2: G++ Not Found

**Error:**
```
g++: command not found
```

**Solution:**
```bash
# macOS
xcode-select --install

# Linux
sudo apt-get install g++

# Or install build-essential
sudo apt-get install build-essential
```

### Issue 3: C++17 Not Supported

**Error:**
```
error: unrecognized command line option '-std=c++17'
```

**Solution:**
```bash
# Update G++ to version 7 or later
# macOS
brew upgrade gcc

# Linux
sudo apt-get update
sudo apt-get upgrade g++
```

### Issue 4: Compilation Errors

**Error:**
```
error: 'object.h' file not found
```

**Solution:**
```bash
# Ensure you're in the correct directory
cd /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2cpp

# Check if cpp/core/object.h exists
ls cpp/core/object.h

# Use correct include path
g++ -std=c++17 -I./cpp/core ...
```

### Issue 5: Runtime Errors

**Error:**
```
Segmentation fault (core dumped)
```

**Solution:**
```bash
# Run with debugging symbols
g++ -std=c++17 -g -I./cpp/core \
    test/comprehensive_syntax_test.cpp \
    cpp/core/object.cpp \
    -o test/comprehensive_syntax_test.out

# Use debugger
gdb ./test/comprehensive_syntax_test.out
```

## Testing Workflow

### For Development

1. **Write Dart Code**
   ```dart
   // test/my_test.dart
   void main() {
     print('Hello, World!');
   }
   ```

2. **Test in Dart**
   ```bash
   dart test/my_test.dart
   ```

3. **Convert to C++**
   ```bash
   dart bin/dart2cpp.dart test/my_test.dart -o test/my_test.cpp
   ```

4. **Compile C++**
   ```bash
   g++ -std=c++17 -I./cpp/core test/my_test.cpp cpp/core/object.cpp -o test/my_test.out
   ```

5. **Run C++**
   ```bash
   ./test/my_test.out
   ```

6. **Compare Outputs**
   ```bash
   dart test/my_test.dart > dart_output.txt
   ./test/my_test.out > cpp_output.txt
   diff dart_output.txt cpp_output.txt
   ```

### For Continuous Integration

```bash
#!/bin/bash
# ci_test.sh

set -e  # Exit on error

echo "Running Dart2CPP CI Tests..."

# Run Dart tests
echo "Step 1: Running Dart tests..."
dart test/comprehensive_syntax_test.dart
dart test/advanced_features_test.dart
dart test/edge_cases_test.dart

# Run full pipeline
echo "Step 2: Running full pipeline..."
dart test/run_comprehensive_tests.dart

echo "All tests passed! ✅"
```

## Performance Testing

### Measure Compilation Time

```bash
# Time the conversion
time dart bin/dart2cpp.dart test/comprehensive_syntax_test.dart -o test/comprehensive_syntax_test.cpp

# Time the C++ compilation
time g++ -std=c++17 -I./cpp/core test/comprehensive_syntax_test.cpp cpp/core/object.cpp -o test/comprehensive_syntax_test.out

# Time the execution
time ./test/comprehensive_syntax_test.out
```

### Measure Memory Usage

```bash
# Linux
/usr/bin/time -v ./test/comprehensive_syntax_test.out

# macOS
/usr/bin/time -l ./test/comprehensive_syntax_test.out
```

## Advanced Testing

### Test with Optimizations

```bash
# Compile with optimizations
g++ -std=c++17 -O3 -march=native -I./cpp/core \
    test/comprehensive_syntax_test.cpp \
    cpp/core/object.cpp \
    -o test/comprehensive_syntax_test_optimized.out

# Compare performance
time ./test/comprehensive_syntax_test.out
time ./test/comprehensive_syntax_test_optimized.out
```

### Test with Debugging

```bash
# Compile with debug symbols
g++ -std=c++17 -g -O0 -I./cpp/core \
    test/comprehensive_syntax_test.cpp \
    cpp/core/object.cpp \
    -o test/comprehensive_syntax_test_debug.out

# Run with debugger
gdb ./test/comprehensive_syntax_test_debug.out
```

### Test with Sanitizers

```bash
# Address sanitizer (detect memory errors)
g++ -std=c++17 -fsanitize=address -g -I./cpp/core \
    test/comprehensive_syntax_test.cpp \
    cpp/core/object.cpp \
    -o test/comprehensive_syntax_test_asan.out

./test/comprehensive_syntax_test_asan.out

# Undefined behavior sanitizer
g++ -std=c++17 -fsanitize=undefined -g -I./cpp/core \
    test/comprehensive_syntax_test.cpp \
    cpp/core/object.cpp \
    -o test/comprehensive_syntax_test_ubsan.out

./test/comprehensive_syntax_test_ubsan.out
```

## Test Coverage

### Check Test Coverage

```bash
# Run all tests and count results
dart test/run_comprehensive_tests.dart | tee test_results.txt

# Analyze results
grep "✅" test_results.txt | wc -l  # Count passed tests
grep "❌" test_results.txt | wc -l  # Count failed tests
```

### Generate Coverage Report

```bash
# Run tests with coverage
dart run coverage:test_with_coverage

# Generate HTML report
dart run coverage:format_coverage \
    --lcov \
    --in=coverage \
    --out=coverage/lcov.info \
    --report-on=lib

# View report
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

## Next Steps

After completing the quick start:

1. **Read Full Documentation**
   - [TEST_SUITE_DOCUMENTATION.md](TEST_SUITE_DOCUMENTATION.md)
   - [OPTIMIZATION_RECOMMENDATIONS.md](OPTIMIZATION_RECOMMENDATIONS.md)
   - [COMPREHENSIVE_TEST_SUMMARY.md](COMPREHENSIVE_TEST_SUMMARY.md)

2. **Explore Test Files**
   - Review test code to understand supported features
   - Use tests as examples for your own code

3. **Run Your Own Tests**
   - Create custom test files
   - Test your specific use cases

4. **Contribute**
   - Report issues
   - Submit improvements
   - Add more tests

## Resources

### Documentation
- [README.md](README.md) - Project overview
- [SUPPORTED_FEATURES.md](SUPPORTED_FEATURES.md) - Supported Dart features
- [PROJECT_STRUCTURE.md](PROJECT_STRUCTURE.md) - Project structure

### Test Files
- [test/comprehensive_syntax_test.dart](test/comprehensive_syntax_test.dart)
- [test/advanced_features_test.dart](test/advanced_features_test.dart)
- [test/edge_cases_test.dart](test/edge_cases_test.dart)
- [test/run_comprehensive_tests.dart](test/run_comprehensive_tests.dart)

### C++ Runtime
- [cpp/core/object.h](cpp/core/object.h) - Core types
- [cpp/core/object.cpp](cpp/core/object.cpp) - Implementation
- [cpp/README.md](cpp/README.md) - C++ runtime documentation

## Support

If you encounter issues:

1. Check this guide for common solutions
2. Review the full documentation
3. Check existing issues on GitHub
4. Create a new issue with:
   - Error message
   - Steps to reproduce
   - Environment details (OS, Dart version, G++ version)

## Summary

You now know how to:
- ✅ Run Dart tests
- ✅ Convert Dart to C++
- ✅ Compile C++ code
- ✅ Run C++ executables
- ✅ Use automated test runner
- ✅ Troubleshoot common issues
- ✅ Measure performance
- ✅ Run advanced tests

**Happy Testing! 🚀**

---

**Last Updated**: 2025-11-10
**Version**: 1.0.0
**Maintainer**: Dart2CPP Team
