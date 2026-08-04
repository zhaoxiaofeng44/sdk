# Dart2Cpp Sample Directory

This directory contains example Dart code and demonstrates the conversion pipeline from Dart to C++.

## Directory Structure

```
sample/
├── src/           # Source Dart files to convert
│   └── hello.dart # Example: Simple class with methods
└── README.md      # This file
```

## Quick Start

```bash
# Compile a Dart source to Kernel, then generate C++
dart tool/convert_dual.dart sample/src/hello.dart sample/output

# Batch-generate C++ for all test cases
dart tool/convert_all_dual.dart generated
```

This will:
1. Compile each `.dart` source to kernel format (`.dill`)
2. Convert the kernel AST to C++ source

## Manual conversion

```bash
# Step 1: Compile to kernel
dart compile kernel src/hello.dart -o /tmp/hello.dill

# Step 2: Generate C++
dart tool/gen_cpp.dart hello
```

The generated C++ depends on the runtime header `lib/platform/cpp/dart2cpp_lowered.h`, which provides:

- `AnyGC` - Base class with GC management and `classInfo` hook
- `ClassInfo` - Typed function-pointer vtable for virtual dispatch
- `TypeFunction` - Callable closure base classes
- Box types - For closure capture semantics
- Static collections - `StaticList`, `StaticMap`, `StaticSet`
- Async support - `Promise`, `smAwait`

Compile the output with:

```bash
g++ -std=c++17 -c output/hello_restored.cpp -I lib/platform/cpp -Wno-everything
```

## Adding Your Own Examples

1. Create a new `.dart` file in `sample/src/`
2. Run `dart tool/convert_dual.dart sample/src/<name>.dart sample/output`
3. Check the C++ output in `sample/output/`
