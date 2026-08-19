# dart2cpp

A Dart-to-C++ compiler that transforms Dart source code into lowered C++ via Kernel AST.

## Overview

The pipeline compiles Dart source to Kernel AST, then emits C++ with OOP lowering transformations:

- Classes → `XValue` structs + static functions
- Virtual dispatch → `ClassInfo` vtable (typed function pointers)
- Closures → environment classes with captured variable boxing
- Async/await → state machine coroutines (`Promise` + `GlobalScheduler`)
- Memory → mark-and-sweep GC (`AnyGC` base + `GC::collect`)

## Quick Start

### Prerequisites

- Dart SDK ≥ 3.0.0
- C++17 compiler (clang++ / g++)

### Run Tests

```bash
dart test/run_all_restorer_tests.dart   # Kernel compile → C++ generate → C++ compile
./run_all_cpp_tests.sh                  # Compile & run generated C++ programs
dart test/run_multifile_tests.dart      # Multi-file / multi-package emission (runtime diff vs dart run)
```

### Convert a Dart File

```bash
dart tool/convert_dual.dart <source.dart> <output_dir>
```

By default this emits **multiple C++ files** — one `.cpp` per Dart library the
entry imports (local files and `package:` libraries), plus a shared header and a
build script:

```
<output_dir>/
├── <program>.h        # shared declarations (all libraries)
├── <program>.cpp      # entry library (contains main)
├── <lib>.cpp          # one per imported library
└── build.sh           # clang++ -std=c++17 compile & link
```

Build and run with the generated script:

```bash
bash <output_dir>/build.sh && <output_dir>/<program>
```

Options:

- `--single` — emit one combined `.cpp` (legacy layout).
- `--packages=<package_config.json>` — resolve `package:` imports.

Generated C++ depends on the runtime header `lib/platform/cpp/dart2cpp_lowered.h`.
For a single file you can still compile directly:

```bash
clang++ -std=c++17 -I lib/platform/cpp <output>.cpp -o <output>
```

### Programmatic API

```dart
import 'package:dart2cpp/dart_to_cpp.dart';

// Single combined source string (legacy).
String cpp = emitCppFromComponent(component);

// Multi-file: one .cpp per library + shared header + build.sh.
CppEmissionResult result = emitCppFilesFromComponent(
  component,
  outDir,
  runtimeIncludeDir: 'lib/platform/cpp',
);
```

## Project Structure

```
lib/
├── dart_to_cpp.dart                    # Public API entry point
├── restorer/
│   ├── dart_restorer.dart              # Analyzer: class info collection, vtables, closures
│   └── cpp_emitter.dart                # C++ code emitter
└── platform/
    └── cpp/
        └── dart2cpp_lowered.h          # C++ runtime (GC, vtable, closures, async, collections)

test/                                   # Test suite (10 cases) + GC/leak verification
tool/                                   # Development utilities
sample/                                 # Conversion pipeline examples
docs/                                   # GC and leak analysis reports
```

## Key Transformations

### Class Methods → Static Functions

```cpp
// Dart:  class Dog { void speak() { print("Woof!"); } }
void Dog_speak(AnyGC this_);
```

### Virtual Dispatch via ClassInfo

```cpp
// Dart:  animal.speak();
animal->classInfo()->speak(animal);
```

### Closure Environment Classes

Automatically generates `ClosureEnv_N` classes for closures with captured variables, with Box types (`IntBox`, `ObjectBox<T>`, ...) for mutable value captures.

### Type Mapping

| Dart | C++ |
|------|---------|
| `List` | `List` |
| `Map` | `Map` |
| `Set` | `Set` |
| `Future<T>` | `Promise<T>` |

## Environment Variables

| Variable | Description |
|----------|-------------|
| `DART_SDK_BIN` | Override dart executable path (used by tools) |
| `DART_SDK_ROOT` | Override SDK root for platform dill resolution |

## Documentation

- **[docs/gc_leak_analysis.md](docs/gc_leak_analysis.md)** — C++ runtime GC mechanism and leak test report
- **[CLAUDE.md](CLAUDE.md)** — Development guide for AI assistants

## License

Internal project — see repository root for licensing details.
