/// C++ 语句发射器 — 将 IR 语句节点转为 C++ 语句。
library cpp_stmt_emitter;

import 'package:dart2cpp/ir/ir_nodes.dart';
import 'package:dart2cpp/shared/analysis_context.dart';
import 'cpp_type_emitter.dart';
import 'cpp_expr_emitter.dart';

/// C++ 语句发射器。
class CppStmtEmitter {
  final AnalysisContext ctx;
  final CppTypeEmitter typeEmitter;
  final CppExprEmitter exprEmitter;
  final StringBuffer _buf = StringBuffer();
  int _indent = 0;

  String get _pad => '    ' * _indent;

  CppStmtEmitter(this.ctx, this.typeEmitter, this.exprEmitter);

  /// 将 IR 语句转为 C++ 语句字符串。
  String emit(IrStatement stmt) {
    _buf.clear();
    _indent = 0;
    _emitStmt(stmt);
    return _buf.toString();
  }

  void _emitStmt(IrStatement stmt) {
    if (stmt is IrBlockStmt) {
      for (final s in stmt.statements) {
        _emitStmt(s);
      }
    } else if (stmt is IrVarDecl) {
      _emitVarDecl(stmt);
    } else if (stmt is IrReturnStmt) {
      _emitReturn(stmt);
    } else if (stmt is IrIfStmt) {
      _emitIf(stmt);
    } else if (stmt is IrForStmt) {
      _emitFor(stmt);
    } else if (stmt is IrForInStmt) {
      // Use auto& for value types, auto* for pointer types
      final isPointer = _isPointerType(stmt.varType);
      final varDecl = isPointer ? 'auto*' : 'auto&';
      _buf.writeln('${_pad}for ($varDecl ${stmt.varName} : *${exprEmitter.emit(stmt.iterable)}) {');
      _indent++;
      _emitStmt(stmt.body);
      _indent--;
      _buf.writeln('${_pad}}');
    } else if (stmt is IrWhileStmt) {
      _buf.writeln('${_pad}while (${exprEmitter.emit(stmt.condition)}) {');
      _indent++;
      _emitStmt(stmt.body);
      _indent--;
      _buf.writeln('${_pad}}');
    } else if (stmt is IrDoWhileStmt) {
      _buf.writeln('${_pad}do {');
      _indent++;
      _emitStmt(stmt.body);
      _indent--;
      _buf.writeln('${_pad}} while (${exprEmitter.emit(stmt.condition)});');
    } else if (stmt is IrTryCatch) {
      _emitTryCatch(stmt);
    } else if (stmt is IrSwitchStmt) {
      _emitSwitch(stmt);
    } else if (stmt is IrBreakStmt) {
      _buf.writeln('${_pad}break;');
    } else if (stmt is IrContinueStmt) {
      _buf.writeln('${_pad}continue;');
    } else if (stmt is IrLabeledStmt) {
      _buf.writeln('${_pad}do {');
      _indent++;
      _emitStmt(stmt.body);
      _indent--;
      _buf.writeln('${_pad}} while (false);');
    } else if (stmt is IrYieldStmt) {
      _buf.writeln('${_pad}// yield ${exprEmitter.emit(stmt.value)};');
    } else if (stmt is IrExprStmt) {
      _buf.writeln('${_pad}${exprEmitter.emit(stmt.expression)};');
    } else if (stmt is IrFuncDecl) {
      _emitFuncDecl(stmt);
    } else if (stmt is IrAssertStmt) {
      if (stmt.message != null) {
        _buf.writeln('${_pad}assert(${exprEmitter.emit(stmt.condition)} && ${exprEmitter.emit(stmt.message!)});');
      } else {
        _buf.writeln('${_pad}assert(${exprEmitter.emit(stmt.condition)});');
      }
    }
  }

  void _emitVarDecl(IrVarDecl decl) {
    final typeStr = decl.isBoxed && decl.boxType != null
        ? typeEmitter.emit(decl.boxType!)
        : typeEmitter.emit(decl.type);

    _buf.write('${_pad}$typeStr ${decl.name}');
    if (decl.init != null) {
      if (decl.isBoxed && decl.boxType != null) {
        _buf.write(' = new ${typeEmitter.emit(decl.boxType!)}(${exprEmitter.emit(decl.init!)})');
      } else {
        _buf.write(' = ${exprEmitter.emit(decl.init!)}');
      }
    } else {
      _buf.write('${typeEmitter.defaultValue(decl.type)}');
    }
    _buf.writeln(';');
  }

  void _emitReturn(IrReturnStmt stmt) {
    if (stmt.isAsync) {
      if (stmt.value != null) {
        _buf.writeln('${_pad}env->_promise->complete(${exprEmitter.emit(stmt.value!)});');
      } else {
        _buf.writeln('${_pad}env->_promise->complete(AnyPtr());');
      }
      _buf.writeln('${_pad}return;');
    } else if (stmt.value != null) {
      final valueStr = exprEmitter.emit(stmt.value!);
      // Check if we need to wrap the return value in AnyPtr
      final valueType = stmt.value!.resultType;
      final returnType = stmt.returnType;
      if ((returnType is IrDynamicType || returnType is IrNullableType) && valueType != null && valueType is! IrDynamicType && valueType is! IrNullableType) {
        // Wrap in AnyPtr::fromAuto()
        _buf.writeln('${_pad}return AnyPtr::fromAuto($valueStr);');
      } else if (returnType != null && returnType is! IrDynamicType && returnType is! IrNullableType && (valueType is IrDynamicType || valueType is IrNullableType)) {
        // Unwrap from AnyPtr
        _buf.writeln('${_pad}return $valueStr.castTo<${typeEmitter.emit(returnType)}>();');
      } else {
        _buf.writeln('${_pad}return $valueStr;');
      }
    } else {
      _buf.writeln('${_pad}return;');
    }
  }

  void _emitIf(IrIfStmt stmt) {
    _buf.writeln('${_pad}if (${exprEmitter.emit(stmt.condition)}) {');
    _indent++;
    _emitStmt(stmt.thenBranch);
    _indent--;
    if (stmt.elseBranch != null) {
      _buf.writeln('${_pad}} else {');
      _indent++;
      _emitStmt(stmt.elseBranch!);
      _indent--;
    }
    _buf.writeln('${_pad}}');
  }

  void _emitFor(IrForStmt stmt) {
    _buf.write('${_pad}for (');
    if (stmt.init != null) {
      if (stmt.init is IrVarDecl) {
        final decl = stmt.init as IrVarDecl;
        _buf.write('${typeEmitter.emit(decl.type)} ${decl.name}');
        if (decl.init != null) {
          _buf.write(' = ${exprEmitter.emit(decl.init!)}');
        }
      }
    }
    _buf.write('; ');
    if (stmt.condition != null) {
      _buf.write(exprEmitter.emit(stmt.condition!));
    }
    _buf.write('; ');
    _buf.write(stmt.updaters.map(exprEmitter.emit).join(', '));
    _buf.writeln(') {');
    _indent++;
    _emitStmt(stmt.body);
    _indent--;
    _buf.writeln('${_pad}}');
  }

  void _emitTryCatch(IrTryCatch stmt) {
    _buf.writeln('${_pad}try {');
    _indent++;
    _emitStmt(stmt.tryBody);
    _indent--;
    for (final c in stmt.catches) {
      final typeStr = c.exceptionType != null
          ? typeEmitter.emit(c.exceptionType!)
          : 'AnyPtr';
      final varStr = c.exceptionVar != null ? ' ${c.exceptionVar}' : '';
      _buf.writeln('${_pad}} catch ($typeStr$varStr) {');
      _indent++;
      _emitStmt(c.body);
      _indent--;
    }
    if (stmt.finallyBody != null) {
      _buf.writeln('${_pad}}');
      _buf.writeln('${_pad}// finally');
      _emitStmt(stmt.finallyBody!);
    }
    _buf.writeln('${_pad}}');
  }

  void _emitSwitch(IrSwitchStmt stmt) {
    _buf.writeln('${_pad}switch (${exprEmitter.emit(stmt.subject)}) {');
    _indent++;
    for (final c in stmt.cases) {
      for (final v in c.values) {
        _buf.writeln('${_pad}case ${exprEmitter.emit(v)}:');
      }
      _indent++;
      _emitStmt(c.body);
      _buf.writeln('${_pad}break;');
      _indent--;
    }
    if (stmt.defaultCase != null) {
      _buf.writeln('${_pad}default:');
      _indent++;
      _emitStmt(stmt.defaultCase!);
      _buf.writeln('${_pad}break;');
      _indent--;
    }
    _buf.writeln('${_pad}}');
  }

  void _emitFuncDecl(IrFuncDecl stmt) {
    final retType = typeEmitter.emit(stmt.returnType);
    _buf.write('${_pad}auto ${stmt.name} = [&](');
    final paramStr = stmt.params
        .map((p) => '${typeEmitter.emit(p.type)} ${p.name}')
        .join(', ');
    _buf.writeln('$paramStr) -> $retType {');
    _indent++;
    _emitStmt(stmt.body);
    _indent--;
    _buf.writeln('${_pad}};');
  }

  /// Check if a type is a pointer type (needs auto* in for-in loops)
  bool _isPointerType(IrType type) {
    // User types (classes) are pointers, but enums are not
    if (type is IrUserType) {
      // Check if it's an enum - enums are value types, not pointers
      if (ctx.isEnum(type.className)) {
        return false;
      }
      return true;
    }
    // Collection types are pointers
    if (type is IrCollectionType) return true;
    // Promise types are pointers
    if (type is IrPromiseType) return true;
    // Function types are pointers
    if (type is IrFunctionType) return true;
    // Box types are pointers
    if (type is IrBoxType) return true;
    // Primitive types and dynamic types are not pointers
    return false;
  }
}
