/// C++ 运行时头部发射器 — 生成 #include 和前向声明。
library cpp_runtime_header;

import 'package:dart2cpp/ir/ir_nodes.dart';
import 'package:dart2cpp/shared/analysis_context.dart';
import 'cpp_type_emitter.dart';

/// C++ 运行时头部发射器。
class CppRuntimeHeaderEmitter {
  final AnalysisContext ctx;
  final CppTypeEmitter typeEmitter;

  CppRuntimeHeaderEmitter(this.ctx, this.typeEmitter);

  /// 生成头部代码。
  String emit({
    required List<String> forwardDeclStructs,
    required List<String> forwardDeclFunctions,
  }) {
    final buf = StringBuffer();

    buf.writeln('#include "dart2cpp_lowered.h"');
    buf.writeln();

    // 前向声明：Value 结构体
    if (forwardDeclStructs.isNotEmpty) {
      buf.writeln('// === Forward declarations: Value structs ===');
      for (final name in forwardDeclStructs) {
        // name already contains "struct " or "template<...> struct " prefix
        buf.writeln('$name;');
      }
      buf.writeln();
    }

    // 前向声明：静态函数
    if (forwardDeclFunctions.isNotEmpty) {
      buf.writeln('// === Forward declarations: static functions ===');
      for (final decl in forwardDeclFunctions) {
        buf.writeln('$decl;');
      }
      buf.writeln();
    }

    return buf.toString();
  }

  /// 从 IR 程序收集前向声明。
  (List<String>, List<String>) collectForwardDeclarations(IrProgram program) {
    final structs = <String>[];
    final functions = <String>[];

    for (final lib in program.libraries) {
      // 收集声明
      for (final decl in lib.declarations) {
        if (decl is IrValueClass) {
          final templatePrefix = decl.typeParams.isNotEmpty
              ? 'template<${decl.typeParams.map((t) => 'typename ${t.name}').join(', ')}> struct '
              : 'struct ';
          structs.add('$templatePrefix${decl.className}Value');
        }
        if (decl is IrStaticFunc) {
          functions.add(_funcSignature(decl));
        }
        if (decl is IrConstructorFunc) {
          functions.add(_ctorSignature(decl));
        }
        if (decl is IrDelegateFunc) {
          functions.add(_delegateSignature(decl));
        }
      }

      // 收集闭包类前向声明
      for (final closure in lib.pendingClosures) {
        final templatePrefix = closure.typeParams.isNotEmpty
            ? 'template<${closure.typeParams.map((t) => 'typename ${t.name}').join(', ')}> struct '
            : 'struct ';
        structs.add('$templatePrefix${closure.envClassName}');

        // 添加闭包的 _call 和 _new 函数前向声明
        functions.add(_closureCallSignature(closure));
        functions.add(_closureNewSignature(closure));
      }
    }

    return (structs, functions);
  }

  String _funcSignature(IrStaticFunc func) {
    final templatePrefix = func.typeParams.isNotEmpty
        ? 'template<${func.typeParams.map((t) => 'typename ${t.name}').join(', ')}> '
        : '';
    final retType = typeEmitter.emit(func.returnType);
    final params = func.params.map((p) => '${typeEmitter.emit(p.type)} ${p.name}').join(', ');
    return '$templatePrefix$retType ${func.name}($params)';
  }

  String _ctorSignature(IrConstructorFunc ctor) {
    final templatePrefix = ctor.typeParams.isNotEmpty
        ? 'template<${ctor.typeParams.map((t) => 'typename ${t.name}').join(', ')}> '
        : '';
    final typeArgs = ctor.typeParams.isNotEmpty
        ? '<${ctor.typeParams.map((t) => t.name).join(', ')}>'
        : '';
    final params = <String>['${ctor.className}Value$typeArgs* this__'];
    for (final p in ctor.params) {
      params.add('${typeEmitter.emit(p.type)} ${p.name}');
    }
    return '$templatePrefix${ctor.className}Value$typeArgs* ${ctor.name}(${params.join(', ')})';
  }

  String _delegateSignature(IrDelegateFunc func) {
    final retType = typeEmitter.emit(func.returnType);
    final params = func.params.map((p) => '${typeEmitter.emit(p.type)} ${p.name}').join(', ');
    return '$retType ${func.name}($params)';
  }

  String _closureCallSignature(IrClosureClass closure) {
    final templatePrefix = closure.typeParams.isNotEmpty
        ? 'template<${closure.typeParams.map((t) => 'typename ${t.name}').join(', ')}> '
        : '';
    final retType = typeEmitter.emit(closure.returnType);
    // Use AnyPtr for the env parameter to match the actual implementation
    final params = <String>['AnyPtr env__'];
    for (final p in closure.params) {
      params.add('${typeEmitter.emit(p.type)} ${p.name}');
    }
    return '$templatePrefix$retType ${closure.envClassName}_call(${params.join(', ')})';
  }

  String _closureNewSignature(IrClosureClass closure) {
    final templatePrefix = closure.typeParams.isNotEmpty
        ? 'template<${closure.typeParams.map((t) => 'typename ${t.name}').join(', ')}> '
        : '';
    final typeArgs = closure.typeParams.isNotEmpty
        ? '<${closure.typeParams.map((t) => t.name).join(', ')}>'
        : '';
    final params = <String>['${closure.envClassName}$typeArgs* env_'];
    for (final f in closure.capturedFields) {
      final fieldType = f.isBoxed && f.boxType != null
          ? typeEmitter.emit(f.boxType!)
          : typeEmitter.emit(f.type);
      params.add('$fieldType ${f.name}');
    }
    return '$templatePrefix${closure.envClassName}$typeArgs* ${closure.envClassName}_new(${params.join(', ')})';
  }
}
