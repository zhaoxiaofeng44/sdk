part of 'dart_restorer.dart';

// ---- Statements ----

mixin _StatementRestorer on _DartRestorerBase, _TypeUtils, _ExpressionRestorer {
  void _restoreStmt(Statement stmt) {
    if (stmt is Block) {
      _restoreBlock(stmt);
    } else if (stmt is ReturnStatement) {
      if (_insideAsyncFunction) {
        // async ClosureEnv 模式：return expr → env._promise.complete(expr); return;
        if (stmt.expression != null) {
          final exprStr = _restoreExpr(stmt.expression!);
          _buf.write('${_pad}env._promise.complete($exprStr);\n');
        }
        _buf.write('${_pad}return;\n');
      } else {
        _buf.write('${_pad}return');
        if (stmt.expression != null) {
          _buf.write(' ${_restoreExpr(stmt.expression!)}');
        }
        _buf.write(';\n');
      }
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
        final vName = _cleanVarName(v.name ?? '_i');
        v.name = vName;
        // Bug 11: 若 for 循环变量被内部闭包捕获，需要 Box 化（仅基础值类型）
        if (_boxedVars.contains(v)) {
          final boxType = _boxTypeNameFor(v.type)!;
          final initStr = v.initializer != null
              ? _restoreExpr(v.initializer!)
              : _defaultValueForType(v.type);
          _buf.write('$boxType $vName = $boxType($initStr)');
        } else {
          _buf.write('var $vName = ${_restoreExpr(v.initializer!)}');
        }
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
      // Kernel 将 try-catch-finally 表示为 TryFinally(body: TryCatch(...), finalizer: ...)
      // 需要合并输出为 try { ... } catch ... finally { ... }
      final body = stmt.body;
      if (body is TryCatch) {
        _buf.write('${_pad}try ');
        _restoreStmt(body.body);
        for (final c in body.catches) {
          _restoreCatch(c);
        }
        _buf.write(' finally ');
        _restoreStmt(stmt.finalizer);
      } else {
        _buf.write('${_pad}try ');
        _restoreStmt(stmt.body);
        _buf.write(' finally ');
        _restoreStmt(stmt.finalizer);
      }
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
    } else if (stmt is ForInStatement) {
      _restoreForIn(stmt);
    } else if (stmt is FunctionDeclaration) {
      _restoreFuncDecl(stmt);
    }
  }

  void _restoreForIn(ForInStatement stmt) {
    // 还原 for-in 循环：for (final varName in iterable) { body }
    final varDecl = stmt.variable;
    final varName = _cleanVarName(varDecl.name ?? '_item${_varCounter++}');
    varDecl.name = varName;
    final iterableExpr = _restoreExpr(stmt.iterable);
    final keyword = varDecl.isFinal ? 'final' : 'var';
    _buf.write('${_pad}for ($keyword $varName in $iterableExpr) ');
    _restoreStmt(stmt.body);
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

    // Bug 11: 被 Box 化的局部变量——生成 Box 声明（仅基础值类型）
    // 形式：`BoxType v = BoxType(初始值);`，未初始化时使用类型默认值
    if (_boxedVars.contains(v)) {
      final boxType = _boxTypeNameFor(v.type)!;
      _buf.write(_pad);
      _buf.write('$boxType $name = $boxType(');
      if (v.initializer != null) {
        _buf.write(_restoreExpr(v.initializer!));
      } else {
        _buf.write(_defaultValueForType(v.type));
      }
      _buf.write(');\n');
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
      final initStr = _restoreExpr(v.initializer!);
      _buf.write(' = ${_adaptInitForStaticCollection(v, initStr)}');
    }
    _buf.write(';\n');
  }

  /// 当声明类型还原为 `StaticList/StaticMap/StaticSet<...>`，但 initializer
  /// 是 dart-core 集合（例如 `String.split` 返回 `List<String>`、
  /// `Iterable.toList()` 返回 `_GrowableList<T>`）时，用 `Static*.of(...)`
  /// 包一层，否则会触发 `invalid_assignment: List<String> can't be assigned
  /// to StaticList<String>`。变量初始化器若本身已经是 `Static*` 表达式
  /// （或 `(Static* ... ..xxx)` 这种级联）/ 直接的变量引用，则跳过包装。
  String _adaptInitForStaticCollection(VariableDeclaration v, String initStr) {
    final declType = v.type;
    if (declType is! InterfaceType) return initStr;
    final raw = declType.classNode.name;
    String? staticName;
    if (raw == 'List' || raw == '_List' || raw == '_GrowableList') {
      staticName = 'StaticList';
    } else if (raw == 'Map' || raw == '_Map' || raw == 'LinkedHashMap' || raw == '_InternalLinkedHashMap') {
      staticName = 'StaticMap';
    } else if (raw == 'Set' || raw == '_Set' || raw == 'LinkedHashSet' || raw == '_CompactLinkedHashSet') {
      staticName = 'StaticSet';
    }
    if (staticName == null) return initStr;

    final init = v.initializer;
    if (init is VariableGet) return initStr;

    var probe = initStr.trimLeft();
    while (probe.startsWith('(')) {
      probe = probe.substring(1).trimLeft();
    }
    if (probe.startsWith(staticName)) return initStr;

    final typeArgs = declType.typeArguments.map(_restoreType).join(', ');
    if (typeArgs.isEmpty) {
      return '$staticName.of($initStr)';
    }
    return '$staticName<$typeArgs>.of($initStr)';
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
    // async marker removed: replaced by state machine smAwait
    if (marker == AsyncMarker.AsyncStar) _buf.write(' async*');
    if (marker == AsyncMarker.SyncStar) _buf.write(' sync*');
    if (stmt.function.body != null) {
      _buf.write(' ');
      _restoreStmt(stmt.function.body!);
    }
    _buf.write('\n');
  }
}
