# dart2cpp

A Dart-to-C++ compiler that transforms Dart source code into lowered C++ compatible structures via Kernel AST.

## Overview

The core component is a **Dart Restorer** that reconstructs readable Dart source code from Kernel AST with OOP lowering transformations:

- Classes → `XValue` structs + static functions
- Virtual dispatch → `vptr` (virtual pointer) tables
- Closures → environment classes with captured variable boxing
- Async/await → state machine coroutines

## Quick Start

### Prerequisites

- Dart SDK ≥ 3.0.0
- C++17 compiler (for C++ runtime tests)

### Run Tests

```bash
dart test/run_all_restorer_tests.dart
```

### Convert a Dart File

```bash
dart tool/convert_sample.dart <source.dart> <output.dart>
```

### Regenerate Test Outputs

```bash
dart tool/regen_restored.dart <test_base_name>
```

## Project Structure

```
lib/                              # Core converter
├── dart_to_dart_restorer.dart    # Public API entry point
├── restorer/
│   ├── dart_restorer.dart        # Main restorer class + shared state
│   ├── declaration_restorer.dart # Classes, methods, fields, constructors
│   ├── expression_restorer.dart  # Expression handling
│   ├── statement_restorer.dart   # Statement handling
│   ├── constant_restorer.dart    # Constant expressions
│   ├── type_utils.dart           # Type mapping utilities
│   ├── closure_restorer.dart     # Closure environment generation
│   └── enum_restorer.dart        # Enum lowering
└── platform/
    └── dart/
        └── runtime_classes.dart  # Runtime support (VPtr, Box, TypeFunction)

src/platform/                     # Platform runtime source
├── cpp/                          # C++ runtime headers and sources
└── dart/                         # Dart runtime (symlinked from lib/)

test/                             # Test suite (12 cases)
tool/                             # Development utilities
sample/                           # Conversion pipeline examples
cpp/                              # C++ tests and build system
docs/archive/                     # Archived analysis documents
```

## Key Transformations

### Class Methods → Static Functions

```dart
// Original
class Dog { void speak() { print("Woof!"); } }

// Lowered
void Dog_speak(dynamic this_) { print("Woof!"); }
```

### Virtual Dispatch via vptr

```dart
// Original
animal.speak();

// Lowered
(animal.vptr['speak'] as void Function(dynamic))(animal);
```

### Closure Environment Classes

Automatically generates `ClosureEnv_*` classes for closures with captured variables, with boxing for mutable value type captures.

### Type Mapping

| Dart | Lowered |
|------|---------|
| `List` | `StaticList` |
| `Map` | `StaticMap` |
| `Set` | `StaticSet` |
| `Future<T>` | `Promise<T>` |

## Environment Variables

| Variable | Description |
|----------|-------------|
| `DART_SDK_BIN` | Override dart executable path (used by tools) |
| `DART_SDK_ROOT` | Override SDK root for platform dill resolution |

## Documentation

- **[DART_TO_CPP_MAPPING.md](DART_TO_CPP_MAPPING.md)** — Comprehensive Dart-to-C++ type and feature mapping
- **[RESTORER_ANALYSIS.md](RESTORER_ANALYSIS.md)** — Restorer architecture analysis
- **[CLAUDE.md](CLAUDE.md)** — Development guide for AI assistants
- **[cpp/README.md](cpp/README.md)** — C++ runtime documentation

## License

Internal project — see repository root for licensing details.
