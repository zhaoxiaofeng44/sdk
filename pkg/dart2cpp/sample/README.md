# Dart2Cpp Sample Directory

This directory contains example Dart code and demonstrates the full conversion pipeline from Dart to lowered Dart (and optionally to C++).

## Directory Structure

```
sample/
├── src/           # Source Dart files to convert
│   └── hello.dart # Example: Simple class with methods
├── dart/          # Generated lowered Dart files
│   └── hello_restored.dart
├── cpp/           # Generated C++ files (manual conversion)
├── convert.sh     # Conversion pipeline script
└── README.md      # This file
```

## Quick Start

### 1. Run the conversion pipeline

```bash
cd sample
chmod +x convert.sh
./convert.sh
```

This will:
1. Compile each `.dart` file in `src/` to kernel format (`.dill`)
2. Convert the kernel to lowered Dart using the restorer
3. Run the converted code to verify it works

### 2. Manual conversion

For more control, you can run each step manually:

```bash
# Step 1: Compile to kernel
dart compile kernel src/hello.dart -o /tmp/hello.dill

# Step 2: Convert to lowered Dart
dart tool/regen_restored.dart hello

# Step 3: Run the converted code
dart test/hello_restored.dart
```

## Adding Your Own Examples

1. Create a new `.dart` file in `sample/src/`
2. Run `./convert.sh` to convert and test it
3. Check the output in `sample/dart/`

## Understanding the Output

### Lowered Dart

The converted Dart code uses the OOP-lowering transformation:
- Classes become `XValue` structs + static functions
- Virtual method dispatch via `vptr` Map
- Closures become `ClosureEnv` classes

Example transformation:
```dart
// Original
class Dog {
  void speak() { print("Woof!"); }
}

// Lowered
class DogClassInfo extends ClassInfo {
  void Function(DogValue this_)? speak;
}

class DogValue extends AnyGC {
  static DogClassInfo? _classInfo;
  @override
  DogClassInfo get classInfo => _classInfo ??= _initClassInfo();
  // ...
}

void Dog_speak(dynamic this__) {
  final this_ = this__ as DogValue;
  staticPrint("Woof!");
}
```

### Runtime Dependencies

The generated code imports the runtime from:
```dart
import 'package:dart2cpp/platform/dart/runtime_classes.dart';
```

This provides:
- `AnyGC` - Base class with GC management and virtual method table
- `TypeFunction` - Callable closure base classes
- Box types - For closure capture semantics
- Static collections - `StaticList`, `StaticMap`, `StaticSet`
- Async support - `Promise`, `smAwait`

## Troubleshooting

### Import errors
If you see `import 'package:dart2cpp/platform/dart/runtime_classes.dart'` errors:
- Make sure you're running from the project root
- Check that `lib/platform/dart/runtime_classes.dart` exists

### Compilation failures
If the conversion fails:
- Check the Dart syntax in your source file
- Ensure all classes and functions are properly defined
- Look for unsupported features (see `docs/archive/RUNTIME_GAP_DEEP_ANALYSIS.md`)

### Execution errors
If the converted code doesn't run:
- Compare with the original source
- Check for missing vptr registrations
- Verify closure environment setup

## Related Documentation

- [Runtime Gap Analysis](../docs/archive/RUNTIME_GAP_DEEP_ANALYSIS.md) - Feature coverage
- [Runtime Optimization Summary](../docs/archive/RUNTIME_OPTIMIZATION_SUMMARY.md) - Recent fixes
