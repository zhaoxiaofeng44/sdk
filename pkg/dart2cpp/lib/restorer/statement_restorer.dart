part of 'dart_restorer.dart';

// ---- Statements ----

mixin _StatementRestorer on _DartRestorerBase, _TypeUtils, _ExpressionRestorer {
  void _restoreStmt(Statement stmt) {
    if (stmt is Block) {
      _restoreBlock(stmt);
    } else if (stmt is ReturnStatement) {
      _restoreReturnStatement(stmt);
    } else if (stmt is ExpressionStatement) {
      _restoreExprStmt(stmt);
    } else if (stmt is VariableDeclaration) {
      _restoreVarDecl(stmt);
    } else if (stmt is IfStatement) {
      _restoreIfStatement(stmt);
    } else if (stmt is ForStatement) {
      _restoreForStatement(stmt);
    } else if (stmt is WhileStatement) {
      _restoreWhileStatement(stmt);
    } else if (stmt is DoStatement) {
      _restoreDoStatement(stmt);
    } else if (stmt is TryCatch) {
      _restoreTryCatch(stmt);
    } else if (stmt is TryFinally) {
      _restoreTryFinally(stmt);
    } else if (stmt is YieldStatement) {
      _restoreYieldStatement(stmt);
    } else if (stmt is AssertStatement) {
      _restoreAssertStatement(stmt);
    } else if (stmt is SwitchStatement) {
      _restoreSwitch(stmt);
    } else if (stmt is LabeledStatement) {
      _restoreLabeledStatement(stmt);
    } else if (stmt is BreakStatement) {
      _buf.write('${_pad}break;\n');
    } else if (stmt is ContinueSwitchStatement) {
      _restoreContinueSwitchStatement(stmt);
    } else if (stmt is EmptyStatement) {
      // skip
    } else if (stmt is ForInStatement) {
      _restoreForIn(stmt);
    } else if (stmt is FunctionDeclaration) {
      _restoreFuncDecl(stmt);
    }
  }

  /// 还原 ReturnStatement
  void _restoreReturnStatement(ReturnStatement stmt) {
    if (_insideAsyncFunction) {
      // async ClosureEnv 模式：return expr → { env._promise.complete(expr); return; }
      // 用花括号包裹确保作为 if/while/for 的单语句体时，多条语句都在块内
      _buf.write('{\n');
      _indent++;
      if (stmt.expression != null) {
        final exprStr = _restoreExpr(stmt.expression!);
        _buf.write('${_pad}env._promise.complete($exprStr);\n');
      } else {
        // 裸 return → 根据返回类型生成默认值
        final defaultVal = _defaultPromiseValue(_asyncInnerReturnType);
        _buf.write('${_pad}env._promise.complete($defaultVal);\n');
      }
      _buf.write('${_pad}return;\n');
      _indent--;
      _buf.write('$_pad}\n');
    } else {
      _buf.write('${_pad}return');
      if (stmt.expression != null) {
        _buf.write(' ${_restoreExpr(stmt.expression!)}');
      }
      _buf.write(';\n');
    }
  }

  /// 为 async 函数的裸 return 生成默认 Promise 完成值
  /// 根据返回类型生成合适的默认值
  String _defaultPromiseValue(String type) {
    if (type == 'int') return '0';
    if (type == 'double') return '0.0';
    if (type == 'bool') return 'false';
    if (type == 'String') return "''";
    if (type == 'void' || type == 'dynamic') return '0';
    if (type == 'num') return '0';
    // 对于其他类型（包括自定义类），使用 null as dynamic
    return 'null as dynamic';
  }

  /// 还原 IfStatement
  void _restoreIfStatement(IfStatement stmt) {
    _buf.write('${_pad}if (${_restoreExpr(stmt.condition)}) ');
    _restoreStmt(stmt.then);
    if (stmt.otherwise != null) {
      _buf.write(' else ');
      _restoreStmt(stmt.otherwise!);
    }
  }

  /// 还原 ForStatement
  void _restoreForStatement(ForStatement stmt) {
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
  }

  /// 还原 WhileStatement
  void _restoreWhileStatement(WhileStatement stmt) {
    _buf.write('${_pad}while (${_restoreExpr(stmt.condition)}) ');
    _restoreStmt(stmt.body);
  }

  /// 还原 DoStatement
  void _restoreDoStatement(DoStatement stmt) {
    _buf.write('${_pad}do ');
    _restoreStmt(stmt.body);
    _buf.write(' while (${_restoreExpr(stmt.condition)});\n');
  }

  /// 还原 TryCatch
  void _restoreTryCatch(TryCatch stmt) {
    _buf.write('${_pad}try ');
    _restoreStmt(stmt.body);
    for (final c in stmt.catches) {
      _restoreCatch(c);
    }
  }

  /// 还原 TryFinally
  void _restoreTryFinally(TryFinally stmt) {
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
  }

  /// 还原 YieldStatement
  void _restoreYieldStatement(YieldStatement stmt) {
    _buf.write('${_pad}yield ');
    _buf.write(_restoreExpr(stmt.expression));
    _buf.write(';\n');
  }

  /// 还原 AssertStatement
  void _restoreAssertStatement(AssertStatement stmt) {
    _buf.write('${_pad}assert(${_restoreExpr(stmt.condition)}');
    if (stmt.message != null) {
      _buf.write(', ${_restoreExpr(stmt.message!)}');
    }
    _buf.write(');\n');
  }

  /// 还原 LabeledStatement
  void _restoreLabeledStatement(LabeledStatement stmt) {
    // 检查是否是 switch pattern 脱糖后的标签（包含 break 语句）
    // 如果是，需要用 do-while(false) 包裹
    // 用户定义的循环标签也使用 do-while 包裹（内核将 continue 表示为 break）
    if (_containsBreakStatement(stmt.body)) {
      _buf.write('${_pad}do {\n');
      _indent++;
      _restoreStmt(stmt.body);
      _indent--;
      _buf.write('$_pad} while (false);\n');
    } else {
      // 没有 break 语句的标签：直接保留标签形式（Dart 支持，C++ 可用 goto）
      final labelName = '_label${_varCounter++}';
      _buf.write('${_pad}$labelName:\n');
      _restoreStmt(stmt.body);
    }
  }

  /// 检查语句中是否包含 BreakStatement（用于区分 switch pattern 和用户标签）
  /// 递归检查所有语句，包括循环体内的
  bool _containsBreakStatement(Statement stmt) {
    if (stmt is BreakStatement) return true;
    if (stmt is Block) {
      return stmt.statements.any(_containsBreakStatement);
    }
    if (stmt is IfStatement) {
      if (_containsBreakStatement(stmt.then)) return true;
      if (stmt.otherwise != null && _containsBreakStatement(stmt.otherwise!)) return true;
    }
    if (stmt is LabeledStatement) {
      return _containsBreakStatement(stmt.body);
    }
    if (stmt is ForStatement) {
      return _containsBreakStatement(stmt.body);
    }
    if (stmt is WhileStatement) {
      return _containsBreakStatement(stmt.body);
    }
    if (stmt is DoStatement) {
      return _containsBreakStatement(stmt.body);
    }
    if (stmt is ForInStatement) {
      return _containsBreakStatement(stmt.body);
    }
    if (stmt is TryCatch) {
      if (_containsBreakStatement(stmt.body)) return true;
      for (final c in stmt.catches) {
        if (_containsBreakStatement(c.body)) return true;
      }
    }
    if (stmt is TryFinally) {
      if (_containsBreakStatement(stmt.body)) return true;
      if (_containsBreakStatement(stmt.finalizer)) return true;
    }
    return false;
  }

  /// 还原 ContinueSwitchStatement
  void _restoreContinueSwitchStatement(ContinueSwitchStatement stmt) {
    final label = _currentSwitchContinueTargets[stmt.target];
    if (label != null) {
      _buf.write('${_pad}continue $label;\n');
    } else {
      _buf.write('${_pad}continue;\n');
    }
  }

  void _restoreForIn(ForInStatement stmt) {
    // 还原 for-in 循环：for (final varName in iterable) { body }
    // 或 await for (final varName in stream) { body }
    final varDecl = stmt.variable;
    final varName = _cleanVarName(varDecl.name ?? '_item${_varCounter++}');
    varDecl.name = varName;
    final iterableExpr = _restoreExpr(stmt.iterable);
    final keyword = varDecl.isFinal ? 'final' : 'var';
    final asyncPrefix = stmt.isAsync ? 'await ' : '';
    _buf.write('${_pad}${asyncPrefix}for ($keyword $varName in $iterableExpr) ');
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

    // 检查是否将普通函数赋值给 TypeFunction 类型变量
    // 如果是，需要包装为 ClosureEnv
    if (v.initializer != null) {
      // 检查还原后的类型是否是 TypeFunction 类型
      final restoredType = _restoreType(v.type);
      final isTypeFunction = restoredType.startsWith('TypeFunction');

      if (isTypeFunction) {
        final wrappedInit = _wrapFunctionInTypeFunction(v.initializer!, v.type);
        if (wrappedInit != null) {
          _buf.write(_pad);
          if (v.isConst) _buf.write('const ');
          else if (v.isFinal) _buf.write('final ');
          _buf.write(restoredType);
          _buf.write(' $name = $wrappedInit;\n');
          return;
        }
      }
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

  /// 将普通函数包装为 TypeFunction 实例
  /// 返回包装后的表达式字符串，如果无法包装则返回 null
  String? _wrapFunctionInTypeFunction(Expression init, DartType targetType) {
    Procedure? target;

    // 处理静态函数引用（StaticGet）
    if (init is StaticGet) {
      final t = init.target;
      if (t is Procedure && t.enclosingClass == null) {
        target = t;
      }
    }
    // 处理常量表达式中的 tear-off（ConstantExpression 包装的 StaticTearOffConstant 等）
    else if (init is ConstantExpression) {
      final c = init.constant;
      try {
        final t = (c as dynamic).target;
        if (t is Procedure && t.enclosingClass == null) {
          target = t;
        }
      } catch (_) {}
      // 也尝试 procedure 属性
      if (target == null) {
        try {
          final proc = (c as dynamic).procedure;
          if (proc is Procedure && proc.enclosingClass == null) {
            target = proc;
          }
        } catch (_) {}
      }
    }

    if (target == null) {
      return null;
    }

    // 提取 TypeFunction 的 arity 和类型参数
    // 从还原后的类型字符串中提取（因为 kernel 类型可能是 FunctionType）
    final restoredType = _restoreType(targetType);

    // 从 "TypeFunction1<bool, int>" 中提取类型参数
    final typeMatch = RegExp(r'TypeFunction(\d+)<(.+)>').firstMatch(restoredType);
    if (typeMatch == null) {
      return null;
    }

    final arity = int.parse(typeMatch.group(1)!);
    final typeArgsStr = typeMatch.group(2)!;

    if (arity > _TypeUtils.kMaxArity) {
      return null;
    }

    // 解析类型参数
    final typeArgs = _splitTypeArgs(typeArgsStr);
    if (typeArgs.length != arity + 1) {
      return null;
    }

    final returnType = typeArgs[0];
    final paramTypes = typeArgs.sublist(1);

    // 生成 ClosureEnv 类
    final closureId = _closureCounter++;
    final envClassName = 'ClosureEnv_${_closureContext}_$closureId';
    final paramNames = [for (var i = 0; i < arity; i++) 'a${i + 1}'];
    final callSig = [
      for (var i = 0; i < arity; i++) '${paramTypes[i]} ${paramNames[i]}',
    ].join(', ');

    final typeArgsListStr = [returnType, ...paramTypes].join(', ');
    final newFuncName = '${envClassName}_new';
    final staticCallName = '${envClassName}_call';
    final funcName = target.name.text;

    final decl = StringBuffer()
      ..writeln('class $envClassName extends TypeFunction$arity<$typeArgsListStr> {')
      ..writeln('  $envClassName();')
      ..writeln('  @override')
      ..writeln('  $returnType call($callSig) => closureCall(${paramNames.isEmpty ? 'this' : 'this, ${paramNames.join(', ')}'});')
      ..writeln('}')
      ..writeln('$envClassName $newFuncName($envClassName env_) {')
      ..writeln('  env_.closureCall = $staticCallName;')
      ..writeln('  return env_;')
      ..writeln('}');

    // 生成 call 静态函数
    final callParams = paramNames.isEmpty ? '' : ', ${paramNames.map((n) => '${paramTypes[paramNames.indexOf(n)]} $n').join(', ')}';
    final callArgs = paramNames.join(', ');
    decl.writeln('$returnType $staticCallName(dynamic env__$callParams) {');
    if (callArgs.isEmpty) {
      decl.writeln('  return $funcName();');
    } else {
      decl.writeln('  return $funcName($callArgs);');
    }
    decl.writeln('}');

    _pendingClosureDecls.add(decl.toString());

    final gcMethod = _isStaticFieldContext ? 'allocateGlobal' : 'allocateLocal';
    return '$newFuncName(GC.$gcMethod($envClassName()))';
  }

  /// 拆分类型参数字符串，正确处理嵌套的泛型
  /// 例如 "bool, int" -> ["bool", "int"]
  /// 例如 "List<int>, Map<String, int>" -> ["List<int>", "Map<String, int>"]
  List<String> _splitTypeArgs(String typeArgsStr) {
    final result = <String>[];
    var current = StringBuffer();
    var depth = 0;

    for (var i = 0; i < typeArgsStr.length; i++) {
      final char = typeArgsStr[i];
      if (char == '<') {
        depth++;
        current.write(char);
      } else if (char == '>') {
        depth--;
        current.write(char);
      } else if (char == ',' && depth == 0) {
        result.add(current.toString().trim());
        current = StringBuffer();
      } else {
        current.write(char);
      }
    }

    if (current.isNotEmpty) {
      result.add(current.toString().trim());
    }

    return result;
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

    // Iterator → StaticIterator：某些来源（如 enum .values）的 .iterator 返回原生 Iterator
    // 需用 StaticIterator 包装；StaticList/StaticSet 的 .iterator 已返回 StaticIterator 不需包装
    if (raw == 'Iterator' || raw == '_ListIterator') {
      if (initStr.trimLeft().startsWith('StaticIterator')) return initStr;
      return 'StaticIterator($initStr)';
    }

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
        // catch 中保留原生异常类名（不做映射），因为 dart:core 内部方法
        // 抛出的仍是原生异常类型（如 int.parse 抛 FormatException）。
        // DartXxx extends Xxx，所以 on Xxx 能同时捕获两者。
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
    // 收集所有被 continue 指向的目标 case，为其生成标签
    final savedTargets = _currentSwitchContinueTargets;
    _currentSwitchContinueTargets = <SwitchCase, String>{};
    _collectContinueTargets(stmt, _currentSwitchContinueTargets);

    _buf.write('${_pad}switch (${_restoreExpr(stmt.expression)}) {\n');
    _indent++;
    for (final c in stmt.cases) {
      // 如果此 case 是 continue 目标，输出标签
      if (_currentSwitchContinueTargets.containsKey(c)) {
        _buf.write('${_pad}${_currentSwitchContinueTargets[c]}:\n');
      }
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
    _currentSwitchContinueTargets = savedTargets;
  }

  /// 收集 switch 中所有 ContinueSwitchStatement 的目标 case
  void _collectContinueTargets(SwitchStatement stmt, Map<SwitchCase, String> targets) {
    var labelCounter = 0;
    void visit(TreeNode node) {
      if (node is ContinueSwitchStatement) {
        if (!targets.containsKey(node.target)) {
          targets[node.target] = '_case_${labelCounter++}';
        }
      }
      // 递归遍历子节点（但不进入嵌套的 switch）
      if (node is Block) {
        for (final s in node.statements) visit(s);
      } else if (node is ExpressionStatement) {
        // leaf
      } else if (node is ReturnStatement) {
        // leaf
      } else if (node is IfStatement) {
        visit(node.then);
        if (node.otherwise != null) visit(node.otherwise!);
      } else if (node is SwitchStatement && node != stmt) {
        // 不进入嵌套的 switch（continue 只作用于当前 switch）
        return;
      } else if (node is LabeledStatement) {
        visit(node.body);
      }
    }
    for (final c in stmt.cases) {
      visit(c.body);
    }
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

    // 保存异步状态：局部函数有自己的异步上下文
    // 同步局部函数不应继承外层 async 函数的 _insideAsyncFunction 标志
    final savedInsideAsync = _insideAsyncFunction;
    final savedAsyncInnerType = _asyncInnerReturnType;
    if (marker != AsyncMarker.Async) {
      _insideAsyncFunction = false;
    }

    if (stmt.function.body != null) {
      _buf.write(' ');
      _restoreStmt(stmt.function.body!);
    }
    _buf.write('\n');

    // 恢复异步状态
    _insideAsyncFunction = savedInsideAsync;
    _asyncInnerReturnType = savedAsyncInnerType;
  }
}
