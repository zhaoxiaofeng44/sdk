# Dart2Cpp Project

This project implements a Dart code restorer that reconstructs source code from Kernel AST (Abstract Syntax Tree) with OOP lowering transformations.

## Project Structure

```
lib/
├── dart_to_dart_restorer.dart    # Public API entry point
└── restorer/                      # Core restorer implementation
    ├── dart_restorer.dart         # Main restorer class
    ├── declaration_restorer.dart  # Declaration restoration (classes, methods, fields)
    ├── expression_restorer.dart   # Expression restoration
    ├── statement_restorer.dart    # Statement restoration
    ├── constant_restorer.dart     # Constant expression handling
    ├── type_utils.dart            # Type mapping and utilities
    └── runtime_classes.dart       # Runtime support classes

test/                              # Test suite (10 test cases)
tool/                              # Development utilities
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
- Map-based dispatch for O(1) type lookup
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

### State Management
- Generic `_withScope` helper for scoped state changes
- Automatic save/restore to prevent state leakage
- Clear separation of concerns

## Testing

All 10 test cases pass with identical output:

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

## Development Tools

### Regenerate Test Outputs
```bash
dart tool/regen_restored.dart <test_base_name>
```

### Inspect Kernel AST
```bash
dart tool/inspect_kernel.dart <dill_file> <class_name>
```

## Dependencies

- `args`: Command-line argument parsing (for tools)
- `kernel`: Dart Kernel AST (via local path override)
- `front_end`: Dart compiler frontend (via local path override)

## Recent Improvements

1. **Fixed Double Evaluation Bug**
   - Complex receivers in vptr calls now use IIFE wrapping
   - Prevents side effects from being executed twice
   - Fixed state_machine_coroutine_test output inconsistency

2. **Code Quality Optimization**
   - Removed ~12,000 lines of dead code (old compiler)
   - Simplified expression/statement dispatch
   - Unified AST traversal patterns
   - Improved state management
   - 0 analyzer warnings

## Implementation Details

See inline documentation in source files for detailed explanations of:
- Bug fixes (marked with `Bug #N` comments)
- Transformation rules
- Edge case handling
- Performance considerations
