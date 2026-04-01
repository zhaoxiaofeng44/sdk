part of 'dart_restorer.dart';

// ---- Statements ----

mixin _StatementRestorer on _DartRestorerBase, _TypeUtils, _ExpressionRestorer {
  void _restoreStmt(Statement stmt) {
    if (stmt is Block) {
      _restoreBlock(stmt);
    } else if (stmt is ReturnStatement) {
      _buf.write('${_pad}return');
      if (stmt.expression != null) {
        _buf.write(' ${_restoreExpr(stmt.expression!)}');
      }
      _buf.write(';\n');
    } else if (stmt is ExpressionStatement) {
      _restoreExprStmt(stmt);
    } else if (stmt is VariableDeclaration) {
      _restoreVarDecl(stmt);
    } else if (stmt is IfStatement) {
      _buf.write('${_pad}if (${_restoreExpr(stmt.condition)}) ');
      _restoreStmt(stmt.then);
      if (stmt.otherwise != null) {
        _buf.write(' else ');
        _restoreStmt(stmt.otherwise!);
      }
    } else if (stmt is ForStatement) {
      _buf.write('${_pad}for (');
      if (stmt.variables.isNotEmpty) {
        final v = stmt.variables.first;
        _buf.write('var ${_cleanVarName(v.name ?? '_i')} = ${_restoreExpr(v.initializer!)}');
        v.name = _cleanVarName(v.name ?? '_i');
      }
      _buf.write('; ');
      if (stmt.condition != null) _buf.write(_restoreExpr(stmt.condition!));
      _buf.write('; ');
      _buf.write(stmt.updates.map((e) => _restoreExpr(e)).join(', '));
      _buf.write(') ');
      _restoreStmt(stmt.body);
    } else if (stmt is WhileStatement) {
      _buf.write('${_pad}while (${_restoreExpr(stmt.condition)}) ');
      _restoreStmt(stmt.body);
    } else if (stmt is DoStatement) {
      _buf.write('${_pad}do ');
      _restoreStmt(stmt.body);
      _buf.write(' while (${_restoreExpr(stmt.condition)});\n');
    } else if (stmt is TryCatch) {
      _buf.write('${_pad}try ');
      _restoreStmt(stmt.body);
      for (final c in stmt.catches) {
        _restoreCatch(c);
      }
    } else if (stmt is TryFinally) {
      _buf.write('${_pad}try ');
      _restoreStmt(stmt.body);
      _buf.write(' finally ');
      _restoreStmt(stmt.finalizer);
    } else if (stmt is YieldStatement) {
      _buf.write('${_pad}yield ');
      _buf.write(_restoreExpr(stmt.expression));
      _buf.write(';\n');
    } else if (stmt is AssertStatement) {
      _buf.write('${_pad}assert(${_restoreExpr(stmt.condition)}');
      if (stmt.message != null) {
        _buf.write(', ${_restoreExpr(stmt.message!)}');
      }
      _buf.write(');\n');
    } else if (stmt is SwitchStatement) {
      _restoreSwitch(stmt);
    } else if (stmt is LabeledStatement) {
      // switch pattern 脱糖后的 LabeledStatement + BreakStatement 用 do-while(false) 包裹
      _buf.write('${_pad}do {\n');
      _indent++;
      _restoreStmt(stmt.body);
      _indent--;
      _buf.write('$_pad} while (false);\n');
    } else if (stmt is BreakStatement) {
      _buf.write('${_pad}break;\n');
    } else if (stmt is EmptyStatement) {
      // skip
    } else if (stmt is FunctionDeclaration) {
      _restoreFuncDecl(stmt);
    }
  }

  void _restoreBlock(Block block) {
    _buf.write('{\n');
    _indent++;
    for (final s in block.statements) {
      _restoreStmt(s);
    }
    _indent--;
    _buf.write('$_pad}\n');
  }

  void _restoreExprStmt(ExpressionStatement stmt) {
    final expr = stmt.expression;
    // 过滤 ReachabilityError
    if (_isReachabilityError(expr)) return;
    if (expr is Throw && _isReachabilityError(expr.expression)) return;
    _buf.write('$_pad${_restoreExpr(expr)};\n');
  }

  bool _isReachabilityError(Expression expr) {
    if (expr is ConstructorInvocation) {
      return expr.target.enclosingClass.name.contains('ReachabilityError');
    }
    if (expr is Throw) return _isReachabilityError(expr.expression);
    return false;
  }

  void _restoreVarDecl(VariableDeclaration v) {
    // 先清理变量名并记录到缓存中
    final originalName = v.name ?? '_v${_varCounter++}';
    final name = _cleanVarName(originalName);
    // 确保 v.name 被设置为清理后的名称，这样后续的 _restoreVarGet 能正确引用
    v.name = name;
    
    // 跳过以 _alreadyDeclared_ 开头的重复声明
    if (name.startsWith('_alreadyDeclared_')) {
      final realName = name.substring('_alreadyDeclared_'.length);
      if (v.initializer != null) {
        _buf.write('$_pad$realName = ${_restoreExpr(v.initializer!)};\n');
      }
      return;
    }
    _buf.write(_pad);
    // 如果变量没有初始化器且类型不可空，添加 late 修饰符
    // 这处理了 pattern matching 脱糖后的变量声明（如 int n; 在赋值前使用）
    final needsLate = v.isLate || (v.initializer == null && !v.isFinal && !v.isConst && v.type.nullability != Nullability.nullable);
    if (needsLate) _buf.write('late ');
    if (v.isConst) _buf.write('const ');
    else if (v.isFinal) _buf.write('final ');
    _buf.write(_restoreType(v.type));
    _buf.write(' $name');
    if (v.initializer != null) {
      _buf.write(' = ${_restoreExpr(v.initializer!)}');
    }
    _buf.write(';\n');
  }

  void _restoreCatch(Catch c) {
    if (c.guard is InterfaceType) {
      final guardType = c.guard as InterfaceType;
      final guardName = guardType.classNode.name;
      if (guardName != 'Object') {
        _buf.write(' on $guardName');
      }
    }
    if (c.exception != null) {
      _buf.write(' catch (');
      final eName = _cleanVarName(c.exception!.name ?? 'e');
      c.exception!.name = eName;
      _buf.write(eName);
      if (c.stackTrace != null) {
        final stName = _cleanVarName(c.stackTrace!.name ?? 'st');
        c.stackTrace!.name = stName;
        _buf.write(', $stName');
      }
      _buf.write(')');
    }
    _buf.write(' ');
    _restoreStmt(c.body);
  }

  void _restoreSwitch(SwitchStatement stmt) {
    _buf.write('${_pad}switch (${_restoreExpr(stmt.expression)}) {\n');
    _indent++;
    for (final c in stmt.cases) {
      if (c.isDefault) {
        _buf.write('${_pad}default:\n');
      } else {
        for (final e in c.expressions) {
          _buf.write('${_pad}case ${_restoreExpr(e)}:\n');
        }
      }
      _indent++;
      _restoreStmt(c.body);
      _indent--;
    }
    _indent--;
    _buf.write('$_pad}\n');
  }

  void _restoreFuncDecl(FunctionDeclaration stmt) {
    final name = _cleanVarName(stmt.variable.name ?? '_fn${_varCounter++}');
    stmt.variable.name = name;
    _buf.write('$_pad');
    _buf.write(_restoreType(stmt.function.returnType));
    _buf.write(' $name');
    _writeTypeParams(stmt.function.typeParameters);
    _buf.write('(');
    _writeParams(stmt.function);
    _buf.write(')');
    final marker = stmt.function.asyncMarker;
    if (marker == AsyncMarker.Async) _buf.write(' async');
    if (marker == AsyncMarker.AsyncStar) _buf.write(' async*');
    if (marker == AsyncMarker.SyncStar) _buf.write(' sync*');
    if (stmt.function.body != null) {
      _buf.write(' ');
      _restoreStmt(stmt.function.body!);
    }
    _buf.write('\n');
  }
}
