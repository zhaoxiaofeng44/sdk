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
# Compile a Dart source to Kernel, then generate C++ (multi-file by default)
dart tool/convert_dual.dart sample/src/hello.dart sample/output
```

This will:
1. Compile the `.dart` source to kernel format (`.dill`)
2. Convert the kernel AST to C++ — one `.cpp` per Dart library the entry
   imports, plus a shared header `<program>.h` and a `build.sh`

The generated C++ depends on the runtime header `lib/platform/cpp/dart2cpp_lowered.h`, which provides:

- `AnyGC` - Base class with GC management and `classInfo` hook
- `ClassInfo` - Typed function-pointer vtable for virtual dispatch
- `TypeFunction` - Callable closure base classes
- Box types - For closure capture semantics
- Static collections - `List`, `Map`, `Set`
- Async support - `Promise`, `sm_await`

Build and run everything the generator produced:

```bash
bash sample/output/build.sh && sample/output/hello
```

Or compile a single-file emission (`--single`) manually:

```bash
dart tool/convert_dual.dart sample/src/hello.dart sample/output --single
g++ -std=c++17 -c sample/output/hello.cpp -I lib/platform/cpp -Wno-everything
```

## Adding Your Own Examples

1. Create a new `.dart` file in `sample/src/` (it may `import` other local files
   or `package:` libraries — each becomes its own `.cpp`)
2. Run `dart tool/convert_dual.dart sample/src/<name>.dart sample/output`
3. Check the C++ output in `sample/output/` and build with `build.sh`
