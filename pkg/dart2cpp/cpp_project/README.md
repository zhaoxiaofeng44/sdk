# Dart2Cpp C++ Project

This directory contains the C++ project generated from Dart files using the Dart2Cpp compiler.

## Structure

```
cpp_project/
├── include/              # Header files
│   └── dart2cpp_runtime.h
├── lib/                  # Library implementation
│   └── dart2cpp_runtime.cpp
├── src/                  # Source files
│   ├── main.cpp          # Main entry point (sample)
│   └── *.cpp             # Converted from Dart test files
├── build/                # Build directory (generated)
└── CMakeLists.txt        # Build configuration
```

## Building the Project

### Using CMake (Recommended)

```bash
# Create build directory
mkdir -p build

# Configure the project
cmake -B build

# Build the project
cmake --build build

# Run the executable
./build/dart2cpp_test
```

### Using g++ directly

```bash
# Compile all C++ files
g++ -std=c++17 \
    -I include \
    -o dart2cpp_test \
    src/*.cpp \
    lib/*.cpp

# Run the executable
./dart2cpp_test
```

## Running Tests

To convert Dart test files to C++ and run them:

```bash
# From the dart2cpp root directory
cd /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2cpp

# Run the test builder and runner
dart test/build_and_run.dart
```

This script will:
1. Convert all Dart test files in the `test/` directory to C++
2. Place the C++ files in `cpp_project/src/`
3. Build the C++ project
4. Run the compiled executable

## Runtime Support

The `dart2cpp_runtime.h` header provides C++ implementations of common Dart types:

- **Object**: Base class for all objects
- **String**: String type with concatenation and comparison
- **Int**: Integer type with arithmetic operations
- **Double**: Double-precision floating-point type
- **Bool**: Boolean type with logical operations
- **List<T>**: Generic list/array type
- **Map<K, V>**: Generic map/dictionary type
- **print()**: Print function for debugging

## Adding New Tests

To add a new Dart test file:

1. Create a `.dart` file in the `test/` directory
2. Run `dart test/build_and_run.dart` to convert and build
3. The converted C++ file will appear in `cpp_project/src/`

## Troubleshooting

### CMake not found
If CMake is not available, the build script will fall back to direct g++ compilation.

### Missing includes
Make sure the `include/` directory contains `dart2cpp_runtime.h`.

### Linker errors
If you encounter linker errors, ensure all `.cpp` files in `lib/` are included in the build.

## Example Output

When you run the project, you should see output like:

```
========================================
🚀 Dart2Cpp C++ Project
========================================

📝 Testing String class:
  Hello World
  Length: 5

🔢 Testing int class:
  42 + 8 = 50
  42 * 8 = 336
  42 > 8 = true
...
```

## License

This project uses the same license as the Dart2Cpp compiler.