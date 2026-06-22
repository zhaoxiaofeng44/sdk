/// Dart→C++ 编译器（OOP Lowering 版本）
///
/// 公开 API：将 Dart Kernel `Component` 编译为 C++ 源码。
///
/// 与 `lib/restorer/` 的 `DartRestorer` 共享相同的 OOP lowering 策略：
/// - 类 → Value struct + 构造函数 + 静态函数
/// - 虚表 → `void*` 字典 + `reinterpret_cast`
/// - 闭包 → ClosureEnv struct + `_call` 静态函数
/// - 异步 → Promise + GlobalScheduler + smAwait
/// - GC → 标记-清除
///
/// 区别在于输出目标：本模块生成 C++ 源码，restorer 生成 lowered Dart 源码。
library;

import 'package:kernel/kernel.dart';

import 'type_mapper.dart';
import 'class_info_collector.dart';
import 'cpp_emitter.dart';

// ============================================================================
// 公共 API
// ============================================================================

/// 将 Dart Kernel Component 编译为 C++ 源码字符串。
///
/// 输出使用 `cpp/core/dart2cpp_lowered.h` 运行时。
/// 编译命令示例：
/// ```
/// g++ -std=c++17 -I cpp/core/ output.cpp -o output
/// ```
String compileToCpp(Component component) {
  return CppCompiler().compile(component);
}

// ============================================================================
// 编译器编排器
// ============================================================================

/// Dart→C++ 编译器（OOP Lowering 版本）。
///
/// 编排流程：
/// 1. Phase 1: 类信息收集（ClassInfoCollector）
/// 2. Phase 2: C++ 代码生成（CppEmitter 驱动各 emitter）
class CppCompiler {
  /// 编译 Component → C++ 源码
  String compile(Component component) {
    // ── 创建 TypeMapper（初始为空，由 Collector 填充）──
    final typeMapper = TypeMapper(
      userClasses: {},
      mixinNames: {},
    );

    // ── Phase 1: 收集类信息 + 构建虚表 + 泛型特化 ──
    final collector = ClassInfoCollector(typeMapper);
    final classInfo = collector.collect(component);

    // ── Phase 2: 代码生成 ──
    final emitter = CppEmitter();
    emitter.prepare(component, typeMapper, classInfo);
    return emitter.emit(component);
  }
}
