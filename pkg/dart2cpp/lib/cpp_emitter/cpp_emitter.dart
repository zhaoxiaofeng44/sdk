/// C++ 发射器主控制器 — 将 IR 程序转为完整的 C++ 源码。
library cpp_emitter;

import 'package:dart2cpp/ir/ir_nodes.dart';
import 'package:dart2cpp/shared/analysis_context.dart';
import 'cpp_type_emitter.dart';
import 'cpp_expr_emitter.dart';
import 'cpp_stmt_emitter.dart';
import 'cpp_decl_emitter.dart';
import 'cpp_runtime_header.dart';

/// C++ 发射器。
class CppEmitter {
  final StringBuffer _buf = StringBuffer();

  /// 发射完整程序。
  String emit(IrProgram program, AnalysisContext context) {
    _buf.clear();

    final typeEmitter = CppTypeEmitter(context);
    final exprEmitter = CppExprEmitter(context, typeEmitter);
    final stmtEmitter = CppStmtEmitter(context, typeEmitter, exprEmitter);
    final declEmitter = CppDeclEmitter(context, typeEmitter, exprEmitter, stmtEmitter, _buf);
    final headerEmitter = CppRuntimeHeaderEmitter(context, typeEmitter);

    // 收集前向声明
    final (structs, functions) = headerEmitter.collectForwardDeclarations(program);

    // 发射头部
    _buf.write(headerEmitter.emit(
      forwardDeclStructs: structs,
      forwardDeclFunctions: functions,
    ));

    // 发射每个库
    for (final lib in program.libraries) {
      _emitLibrary(lib, context, typeEmitter, exprEmitter, stmtEmitter, declEmitter);
    }

    return _buf.toString();
  }

  void _emitLibrary(
    IrLibrary lib,
    AnalysisContext context,
    CppTypeEmitter typeEmitter,
    CppExprEmitter exprEmitter,
    CppStmtEmitter stmtEmitter,
    CppDeclEmitter declEmitter,
  ) {
    // typedef
    for (final td in lib.typedefs) {
      _buf.writeln('typedef ${typeEmitter.emit(td.type)} ${td.name};');
      _buf.writeln();
    }

    // 闭包类（提前发射，因为它们被后续的静态函数使用）
    for (final closure in lib.pendingClosures) {
      declEmitter.emitClosureClass(closure);
    }

    // mixin 静态函数
    for (final m in lib.mixins) {
      for (final func in m.funcs) {
        declEmitter.emitStaticFunc(func);
      }
    }

    // 声明
    for (final decl in lib.declarations) {
      if (decl is IrValueClass) declEmitter.emitValueClass(decl);
      if (decl is IrConstructorFunc) declEmitter.emitConstructorFunc(decl);
      if (decl is IrStaticFunc) declEmitter.emitStaticFunc(decl);
      if (decl is IrDelegateFunc) declEmitter.emitDelegateFunc(decl);
      if (decl is IrTopLevelField) declEmitter.emitTopLevelField(decl);
      if (decl is IrEnumDecl) declEmitter.emitEnum(decl);
    }

    // 顶层字段
    for (final field in lib.fields) {
      declEmitter.emitTopLevelField(field);
    }

    // main 函数
    if (lib.mainFunc != null) {
      declEmitter.emitStaticFunc(lib.mainFunc!);
    }
  }
}
