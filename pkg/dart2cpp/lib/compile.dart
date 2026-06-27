/// 统一编译入口。
///
/// 替代原来的 `dart_to_dart_restorer.dart` 和 `cpp_compiler/cpp_compiler.dart`
/// 两个独立入口，提供统一的 `compile()` API。
library compile;

import 'package:kernel/kernel.dart';
import 'package:dart2cpp/shared/shared.dart';
import 'package:dart2cpp/ir/transformer/ir_transformer.dart';
import 'package:dart2cpp/dart_emitter/dart_emitter.dart';
import 'package:dart2cpp/cpp_emitter/cpp_emitter.dart';

/// 编译目标。
enum CompileTarget {
  /// 输出降低后的 Dart 源码。
  dart,

  /// 输出 C++ 源码。
  cpp,
}

/// 统一编译入口。
///
/// 三阶段管线：
/// 1. 共享分析（类信息、虚表、泛型特化）
/// 2. AST → IR 转换
/// 3. IR → 目标语言发射
///
/// ```dart
/// // Dart → 降低后的 Dart
/// final dart = compile(component, target: CompileTarget.dart);
///
/// // Dart → C++
/// final cpp = compile(component, target: CompileTarget.cpp);
/// ```
String compile(Component component, {CompileTarget target = CompileTarget.dart}) {
  // Phase 1: 共享分析
  final ctx = AnalysisContext();

  final classInfoCollector = ClassInfoCollector(ctx);
  classInfoCollector.collect(component);

  final vtableBuilder = VTableBuilder(ctx);
  vtableBuilder.build();

  final genericScanner = GenericSpecializationScanner(ctx);
  genericScanner.scan(component);

  // Phase 2: AST → IR
  final transformer = IrTransformer(ctx);
  final ir = transformer.transform(component);

  // Phase 3: IR → 目标语言
  switch (target) {
    case CompileTarget.dart:
      return DartEmitter().emit(ir, ctx);
    case CompileTarget.cpp:
      return CppEmitter().emit(ir, ctx);
  }
}

/// 便捷函数：编译为降低后的 Dart。
String compileToDart(Component component) =>
    compile(component, target: CompileTarget.dart);

/// 便捷函数：编译为 C++。
String compileToCpp(Component component) =>
    compile(component, target: CompileTarget.cpp);
