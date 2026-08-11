# Dart2Cpp Project

This project implements a Dart-to-C++ compiler that lowers Dart Kernel AST into procedural C++ with OOP lowering transformations.

## Project Structure

```
lib/
├── dart_to_cpp.dart                    # Public API: emitCppFromComponent / CppEmitter
├── restorer/
│   ├── dart_restorer.dart              # Analyzer: class hierarchy, vtables, closure envs,
│   │                                   #   generic specialization collection
│   └── cpp_emitter.dart                # C++ code emitter
└── platform/
    └── cpp/
        └── dart2cpp_lowered.h          # C++ runtime: GC, ClassInfo vtable, TypeFunction,
                                        #   Box types, static collections, Promise/scheduler

test/                                   # Test suite (10 cases) + GC/leak verification
tool/                                   # Development utilities
sample/                                 # Conversion pipeline examples
docs/                                   # GC and leak analysis reports
```

## Core Functionality

The pipeline: Dart source → `dart compile kernel` → Kernel AST → C++ source, with special handling for:

### OOP Lowering
- Class methods become static free functions taking an explicit `this` pointer
- Virtual method dispatch via `ClassInfo` vtable (typed function pointers)
- Closure environment generation for captured variables
- Box types for mutable value captures

### Key Transformations

1. **Class Methods → Static Functions**
   ```cpp
   // Dart:  class Dog { void speak() { print("Woof!"); } }
   void Dog_speak(AnyGC this_);
   ```

2. **Virtual Dispatch via ClassInfo**
   ```cpp
   // Dart:  animal.speak();
   animal->classInfo()->speak(animal);
   ```

3. **Closure Environment Classes**
   - Automatically generates `ClosureEnv_N` classes for closures with captures
   - Handles variable boxing for mutable value type captures
   - Preserves reference semantics across closure boundaries

4. **Type Mapping**
   - Collections: `List` → `List`, `Map` → `Map`, `Set` → `Set`
   - Futures: `Future<T>` → `Promise<T>`
   - Primitives: `int` → `int64_t`, `double` → `double`, `String` → `std::string` wrapper

5. **Async/await → State Machine Coroutines**
   - `AsyncStateMachine` subclasses + `Promise<T>` + `GlobalScheduler`
   - Cooperative scheduling driven by `sm_await`

## Architecture Highlights

### Emitter
- Single-pass emission driven by pre-collected class metadata
  (`_ClassInfoCollector`: hierarchy, vtables, closure envs, generic specializations)
- Generic method calls are specialized at each call site; vptr keys carry type suffixes

### Runtime (dart2cpp_lowered.h)
- Mark-and-sweep GC with root registration (`GC::allocateGlobal`) and
  automatic threshold-triggered collection
- Conservative stack scanning in `collect()`

## Testing

All 10 test cases pass: Kernel compile → C++ generation → C++ compilation:

```bash
dart test/run_all_restorer_tests.dart
```

Runtime verification (compile & run generated programs, GC/leak checks):

```bash
./run_all_cpp_tests.sh        # behavior regression
./test/run_gc_leak_tests.sh   # GC semantics, UAF, exit-time leak measurement (ASan/LSan)
```

Test coverage includes:
- Basic types and operators
- Control flow and loops
- Classes, inheritance, and mixins
- Generics and type parameters
- Closures and variable capture
- Async/await state machines
- Collections and complex OOP patterns

## Development Tools

- `dart tool/convert_dual.dart <src.dart> <out_dir>` — convert a single Dart file to C++
- `dart tool/test_cpp_compilation.dart [test_name]` — generate + compile verification
- `dart tool/gen_cpp.dart [test_name]` — generate C++ to /tmp for inspection
- `dart tool/inspect_kernel.dart <dill> <class>` — inspect Kernel AST

### Environment Variables
- `DART_SDK_BIN` — Override dart executable path (used by tools)
- `DART_SDK_ROOT` — Override SDK root for platform dill resolution

## Dependencies

- `kernel`: Dart Kernel AST (via local path override)
- `_fe_analyzer_shared`: Frontend analyzer shared components (via local path override)
