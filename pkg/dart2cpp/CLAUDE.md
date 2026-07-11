# Dart2Cpp Project

This project implements a Dart code restorer that reconstructs source code from Kernel AST (Abstract Syntax Tree) with OOP lowering transformations.

## Project Structure

```
lib/
├── dart_to_dart_restorer.dart    # Public API entry point
├── restorer/                      # Core restorer implementation
│   ├── dart_restorer.dart         # Main restorer class + shared state
│   ├── declaration_restorer.dart  # Classes, methods, fields, constructors
│   ├── expression_restorer.dart   # Expression restoration
│   ├── statement_restorer.dart    # Statement restoration
│   ├── constant_restorer.dart     # Constant expression handling
│   ├── type_utils.dart            # Type mapping and utilities
│   ├── closure_restorer.dart      # Closure environment generation
│   └── enum_restorer.dart         # Enum lowering
└── platform/
    ├── dart/                      # Dart runtime (VPtr, Box, TypeFunction, etc.)
    │   ├── runtime_classes.dart   # Barrel re-export for all runtime classes
    │   └── _*.dart                # Internal implementation files
    └── cpp/                       # C++ runtime headers and sources

test/                              # Test suite (12 test cases)
tool/                              # Development utilities
sample/                            # Conversion pipeline examples
docs/archive/                      # Archived analysis documents
```

## Core Functionality

The restorer transforms Kernel AST back into readable Dart source code with special handling for:

### OOP Lowering
- Converts object-oriented patterns to procedural code
- Virtual method dispatch via vptr (virtual pointer) tables
- Closure environment generation for captured variables
- Box types for mutable value captures

### Key Transformations

1. **Class Methods → Static Functions**
   ```dart
   // Original
   class Dog { void speak() { print("Woof!"); } }

   // Lowered
   void Dog_speak(dynamic this_) { print("Woof!"); }
   ```

2. **Virtual Dispatch via vptr**
   ```dart
   // Original
   animal.speak();

   // Lowered
   (animal.vptr['speak'] as void Function(dynamic))(animal);
   ```

3. **Closure Environment Classes**
   - Automatically generates `ClosureEnv_*` classes for closures with captures
   - Handles variable boxing for mutable value type captures
   - Preserves reference semantics across closure boundaries

4. **Type Mapping**
   - Collections: `List` → `StaticList`, `Map` → `StaticMap`, `Set` → `StaticSet`
   - Futures: `Future<T>` → `Promise<T>`
   - SDK types: Comprehensive mapping table in `type_utils.dart`

## Architecture Highlights

### Expression Restoration
- 15+ specialized helper methods for different expression types
- Smart receiver wrapping to avoid double evaluation in complex expressions

### Statement Restoration
- Dedicated handlers for each statement type
- Special handling for async/await patterns
- Switch statement continue label management

### AST Traversal
- Unified `_forEachChildNode` visitor pattern
- Eliminates code duplication across different traversal needs
- Consistent handling of all AST node types

### Mixin Architecture
- `_TypeUtils` → `_ConstantRestorer` → `_ExpressionRestorer` → `_StatementRestorer` → `_DeclarationRestorer` → `_EnumRestorer` → `_ClosureRestorer`
- Each mixin adds a focused set of capabilities
- Clear separation of concerns with type-safe composition

## Testing

All 12 test cases pass with identical output:

```bash
dart test/run_all_restorer_tests.dart
```

Test coverage includes:
- Basic types and operators
- Control flow and loops
- Classes, inheritance, and mixins
- Generics and type parameters
- Closures and variable capture
- Async/await patterns
- State machine coroutines
- Collections and complex OOP patterns
- Runtime gap analysis (spread, cascade, collection-if/for)

## Development Tools

### Regenerate Test Outputs
```bash
dart tool/regen_restored.dart <test_base_name>
```

### Inspect Kernel AST
```bash
dart tool/inspect_kernel.dart <dill_file> <class_name>
```

### Environment Variables
- `DART_SDK_BIN` — Override dart executable path (used by tools)
- `DART_SDK_ROOT` — Override SDK root for platform dill resolution

## Dependencies

- `args`: Command-line argument parsing (for tools)
- `kernel`: Dart Kernel AST (via local path override)
- `front_end`: Dart compiler frontend (via local path override)

## Implementation Details

See inline documentation in source files for detailed explanations of:
- Bug fixes (marked with `Bug #N` comments)
- Transformation rules
- Edge case handling
- Performance considerations
