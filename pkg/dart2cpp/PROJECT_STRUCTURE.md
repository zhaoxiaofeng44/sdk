# Dart2Cpp Project Structure

This document describes the organized structure of the Dart2Cpp project.

## Directory Structure

```
/Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2cpp/
├── bin/                          # Executable scripts
│   ├── dart2cpp.dart            # Main command-line tool
│   ├── dart2bytecode.dart       # Dart bytecode compiler
│   └── dump_bytecode.dart       # Bytecode dump utility
│
├── lib/                          # Core library
│   ├── dart2cpp.dart            # Main conversion logic
│   ├── dart_to_cpp_compiler.dart # Compiler implementation
│   ├── unified_compiler.dart    # Unified compiler API
│   ├── compile_to_dart.dart     # Dart compilation
│   ├── bytecode_generator.dart  # Bytecode generation
│   ├── expression_converter_complete.dart # Expression conversion
│   ├── type_analyzer.dart       # Type analysis
│   └── optimizers/              # Optimization modules
│       └── exceptions.dart      # Exception handling
│
├── test/                         # Test directory (moved from root)
│   ├── *.dart                   # All test files (previously at root)
│   ├── build_and_run.dart       # Test runner for conversion
│   ├── run_tests.dart           # Test suite runner
│   ├── verify_optimization.dart # Optimization verification
│   └── [various test files]     # Individual test cases
│
├── cpp_project/                  # C++ project output
│   ├── include/                 # C++ headers
│   │   └── dart2cpp_runtime.h   # Runtime library header
│   │
│   ├── lib/                     # C++ library implementation
│   │   └── dart2cpp_runtime.cpp # Runtime library implementation
│   │
│   ├── src/                     # C++ source files
│   │   └── main.cpp             # Main C++ entry point (sample)
│   │
│   ├── build/                   # Build directory (generated)
│   │
│   ├── CMakeLists.txt           # Build configuration
│   │
│   └── README.md                # C++ project documentation
│
├── demo/                         # Demo files
│   └── optimization_demo.dart   # Optimization demonstration
│
└── [documentation files]         # Various .md documentation files
```

## Key Components

### 1. Test Organization

All test files have been consolidated into the `test/` directory:

- **Individual tests**: `test_*.dart` - Moved from root directory
- **Test runners**: `build_and_run.dart`, `run_tests.dart`
- **Verification**: `verify_optimization.dart`

### 2. C++ Project Structure

The `cpp_project/` directory serves as the output and build directory for converted C++ code:

- **Runtime Library**: Complete C++ runtime in `include/` and `lib/`
- **Source Files**: Converted `.cpp` files placed in `src/`
- **Build System**: CMakeLists.txt for building with CMake or g++
- **Documentation**: README.md with build instructions

### 3. Core Conversion Tools

- **bin/dart2cpp.dart**: Command-line tool for converting Dart to C++
  - Usage: `dart bin/dart2cpp.dart [options] input.dart`
  - Options:
    - `--output, -o`: Specify output file
    - `--verbose, -v`: Verbose output
    - `--optimize`: Enable optimizations
    - `--no-runtime`: Exclude runtime library
    - `--version`: Show version
    - `--features`: Show supported features

- **lib/unified_compiler.dart**: Unified API for compilation
- **lib/dart_to_cpp_compiler.dart**: Main transformation logic
- **lib/dart2cpp.dart**: Core conversion functions

## Usage

### Converting a Single File

```bash
cd /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2cpp
dart bin/dart2cpp.dart test/test_hello.dart
```

This will create `test/test_hello.dart.cpp` with the converted C++ code.

### Building and Running C++ Project

#### Option 1: Using CMake (Recommended)

```bash
cd cpp_project
mkdir -p build
cmake -B build
cmake --build build
./build/dart2cpp_test
```

#### Option 2: Using g++ directly

```bash
cd cpp_project
g++ -std=c++17 -I include -o dart2cpp_test src/*.cpp lib/*.cpp
./dart2cpp_test
```

### Running the Test Suite

```bash
# Convert all test files and build C++ project
dart test/build_and_run.dart

# Run only the Dart tests
dart test/run_tests.dart
```

## Features

The Dart2Cpp compiler supports:

- ✅ Basic type conversion (int, double, String, bool)
- ✅ Arithmetic operators (+, -, *, /, %)
- ✅ Comparison operators (==, !=, <, <=, >, >=)
- ✅ Logical operators (&&, ||, !)
- ✅ Variable declarations
- ✅ Function definitions
- ✅ Class definitions
- ✅ Control flow (if/else, for, while)
- ✅ String operations
- ✅ Collection literals (List, Map, Set)
- ✅ Method calls
- ✅ Field access
- ✅ Basic inheritance
- ✅ try-catch blocks

## Runtime Library

The C++ runtime library (`dart2cpp_runtime.h`) provides:

- `Object`: Base class for all objects
- `String`: String type with operations
- `Int`: Integer type with arithmetic
- `Double`: Double-precision floating-point
- `Bool`: Boolean type
- `List<T>`: Generic list/array
- `Map<K, V>`: Generic map/dictionary
- `print()`: Print function

## Example

### Dart Input (test/test_hello.dart)

```dart
void main() {
  print('Hello, World!');
  var x = 42;
  var y = x + 1;
  print('x = $x, y = $y');
}
```

### C++ Output

Generated C++ code includes proper type conversion, runtime support, and can be compiled with the provided runtime library.

## Troubleshooting

### Conversion Errors

If conversion fails, check:
1. Dart syntax is valid
2. Only supported features are used
3. Run with `--verbose` flag for detailed output

### Build Errors

If C++ build fails:
1. Ensure C++17 is available
2. Check all source files are in `cpp_project/src/`
3. Verify runtime library files are in `cpp_project/lib/`

### Performance

For better performance:
- Use `--optimize` flag when converting
- Use CMake with Release configuration
- Check the `optimizers/` directory for optimization passes

## Development

### Adding New Tests

1. Create a `.dart` file in the `test/` directory
2. Run `dart test/build_and_run.dart` to convert and build
3. Check generated C++ in `cpp_project/src/`

### Extending the Compiler

1. Modify files in `lib/` directory
2. Update `lib/unified_compiler.dart` for API changes
3. Update `bin/dart2cpp.dart` for CLI changes
4. Add tests in `test/` directory

## License

This project uses the same license as the Dart language project.

---

**Generated**: 2025-10-30
**Version**: 2.0.0