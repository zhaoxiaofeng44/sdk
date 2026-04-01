part of 'dart_restorer.dart';

// ---- Expressions ----

mixin _ExpressionRestorer on _DartRestorerBase, _TypeUtils, _ConstantRestorer {
  String _restoreExpr(Expression expr) {
    if (expr is VariableGet) return _restoreVarGet(expr);
    if (expr is VariableSet) return _restoreVarSet(expr);
    if (expr is InstanceGet) return _restoreInstanceGet(expr);
    if (expr is InstanceSet) return _restoreInstanceSet(expr);
    if (expr is InstanceInvocation) return _restoreInstanceInvocation(expr);
    if (expr is FunctionInvocation) return _restoreFunctionInvocation(expr);
    if (expr is DynamicInvocation) return _restoreDynamicInvocation(expr);
    if (expr is DynamicGet) return '${_restoreExpr(expr.receiver)}.${expr.name.text}';
    if (expr is DynamicSet) return '${_restoreExpr(expr.receiver)}.${expr.name.text} = ${_restoreExpr(expr.value)}';
    if (expr is EqualsNull) return '(${_restoreExpr(expr.expression)} == null)';
    if (expr is EqualsCall) return _restoreEqualsCall(expr);
    if (expr is StaticInvocation) return _restoreStaticInvocation(expr);
    if (expr is StaticGet) return _restoreStaticGet(expr);
    if (expr is StaticSet) return _restoreStaticSet(expr);
    if (expr is ConstructorInvocation) return _restoreConstructorInvocation(expr);
    if (expr is ConditionalExpression) return _restoreConditional(expr);
    if (expr is LogicalExpression) return _restoreLogical(expr);
    if (expr is Not) return _restoreNot(expr);
    if (expr is StringConcatenation) return _restoreStringConcat(expr);
    if (expr is StringLiteral) return _restoreStringLiteral(expr);
    if (expr is IntLiteral) return '${expr.value}';
    if (expr is DoubleLiteral) return _restoreDoubleLiteral(expr);
    if (expr is BoolLiteral) return '${expr.value}';
    if (expr is NullLiteral) return 'null';
    if (expr is SymbolLiteral) return '#${expr.value}';
    if (expr is TypeLiteral) return _restoreType(expr.type);
    if (expr is ListLiteral) return _restoreListLiteral(expr);
    if (expr is MapLiteral) return _restoreMapLiteral(expr);
    if (expr is SetLiteral) return _restoreSetLiteral(expr);
    if (expr is IsExpression) return _restoreIsExpr(expr);
    if (expr is AsExpression) return _restoreAsExpr(expr);
    if (expr is Let) return _restoreLet(expr);
    if (expr is BlockExpression) return _restoreBlockExpr(expr);
    if (expr is FunctionExpression) return _restoreFuncExpr(expr);
    if (expr is Throw) return 'throw ${_restoreExpr(expr.expression)}';
    if (expr is Rethrow) return 'rethrow';
    if (expr is ThisExpression) return 'this';
    if (expr is SuperPropertyGet) return 'super.${expr.name.text}';
    if (expr is SuperMethodInvocation) {
      return 'super.${expr.name.text}(${_restoreArgs(expr.arguments)})';
    }
    if (expr is RecordLiteral) return _restoreRecordLiteral(expr);
    if (expr is RecordIndexGet) return _restoreRecordIndexGet(expr);
    if (expr is RecordNameGet) return _restoreRecordNameGet(expr);
    if (expr is ConstantExpression) return _restoreConstant(expr.constant);
    if (expr is InstanceGetterInvocation) {
      return '${_restoreExpr(expr.receiver)}.${expr.name.text}(${_restoreArgs(expr.arguments)})';
    }
    if (expr is AbstractSuperPropertyGet) return 'super.${expr.name.text}';
    if (expr is InvalidExpression) return '/* invalid */';
    if (expr is NullCheck) return '${_restoreExpr(expr.operand)}!';
    if (expr is AwaitExpression) return 'await ${_restoreExpr(expr.operand)}';
    if (expr is CheckLibraryIsLoaded) return 'true';
    if (expr is LoadLibrary) return '${expr.import.name}';
    return '/* unknown: ${expr.runtimeType} */';
  }

  String _restoreVarGet(VariableGet expr) {
    if (expr.variable.name == null) {
      expr.variable.name = '_v${_varCounter++}';
    }
    return _cleanVarName(expr.variable.name!);
  }

  String _restoreVarSet(VariableSet expr) {
    if (expr.variable.name == null) {
      expr.variable.name = '_v${_varCounter++}';
    }
    return '${_cleanVarName(expr.variable.name!)} = ${_restoreExpr(expr.value)}';
  }

  String _restoreInstanceGet(InstanceGet expr) {
    final recv = _restoreExpr(expr.receiver);
    return '$recv.${expr.name.text}';
  }

  String _restoreInstanceSet(InstanceSet expr) {
    final recv = _restoreExpr(expr.receiver);
    return '$recv.${expr.name.text} = ${_restoreExpr(expr.value)}';
  }

  String _restoreInstanceInvocation(InstanceInvocation expr) {
    final recv = _restoreExpr(expr.receiver);
    final name = expr.name.text;

    // 二元运算符
    if (_isBinaryOp(name) && expr.arguments.positional.length == 1) {
      final right = _restoreExpr(expr.arguments.positional[0]);
      return '($recv $name $right)';
    }
    // 一元运算符
    if (name == 'unary-') return '(-$recv)';
    if (name == '~') return '(~$recv)';
    if (name == '[]') {
      return '$recv[${_restoreExpr(expr.arguments.positional[0])}]';
    }
    if (name == '[]=') {
      return '$recv[${_restoreExpr(expr.arguments.positional[0])}] = ${_restoreExpr(expr.arguments.positional[1])}';
    }
    // 普通方法调用：包含位置参数和命名参数
    final allArgs = _restoreArgs(expr.arguments);
    return '$recv.$name($allArgs)';
  }

  String _restoreFunctionInvocation(FunctionInvocation expr) {
    final recv = _restoreExpr(expr.receiver);
    final args = _restoreArgs(expr.arguments);
    return '$recv($args)';
  }

  String _restoreDynamicInvocation(DynamicInvocation expr) {
    final recv = _restoreExpr(expr.receiver);
    final name = expr.name.text;
    final args = _restoreArgs(expr.arguments);
    return '$recv.$name($args)';
  }

  String _restoreEqualsCall(EqualsCall expr) {
    final left = _restoreExpr(expr.left);
    final right = _restoreExpr(expr.right);
    return '($left == $right)';
  }

  String _restoreStaticInvocation(StaticInvocation expr) {
    final target = expr.target;
    final name = target.name.text;
    final args = _restoreArgs(expr.arguments);

    // 特殊处理：_GrowableList 转换为 List 字面量
    if (target.enclosingClass != null && target.enclosingClass!.name == '_GrowableList') {
      // 获取类型参数（如 _GrowableList<int> → <int>）
      final typeArgs = expr.arguments.types;
      final typePrefix = typeArgs.isNotEmpty ? '<${typeArgs.map((t) => _restoreType(t)).join(', ')}>' : '';
      if (name.startsWith('_literal')) {
        // _GrowableList._literalN(元素...) → [元素...]
        final items = expr.arguments.positional.map((e) => _restoreExpr(e)).join(', ');
        if (expr.isConst) return 'const $typePrefix[$items]';
        return '$typePrefix[$items]';
      }
      // _GrowableList(容量) 或 _GrowableList() → []（参数是容量，不是元素）
      return '$typePrefix[]';
    }

    // factory 构造函数
    if (target.isFactory && target.enclosingClass != null) {
      final className = target.enclosingClass!.name;
      if (name.isEmpty) return '$className($args)';
      return '$className.$name($args)';
    }

    // 静态方法
    if (target.enclosingClass != null) {
      return '${target.enclosingClass!.name}.$name($args)';
    }

    return '$name($args)';
  }

  String _restoreStaticGet(StaticGet expr) {
    final target = expr.target;
    if (target.enclosingClass != null) {
      return '${target.enclosingClass!.name}.${target.name.text}';
    }
    return target.name.text;
  }

  String _restoreStaticSet(StaticSet expr) {
    final target = expr.target;
    final value = _restoreExpr(expr.value);
    if (target.enclosingClass != null) {
      return '${target.enclosingClass!.name}.${target.name.text} = $value';
    }
    return '${target.name.text} = $value';
  }

  String _restoreConstructorInvocation(ConstructorInvocation expr) {
    final className = expr.target.enclosingClass.name;
    final ctorName = expr.target.name.text;
    
    // 特殊处理：_GrowableList 转换为列表字面量
    if (className == '_GrowableList') {
      if (ctorName.startsWith('_literal')) {
        // _GrowableList._literalN(元素...) → [元素...]
        final items = expr.arguments.positional.map((e) => _restoreExpr(e)).join(', ');
        return '[$items]';
      } else if (ctorName.isEmpty) {
        // _GrowableList(容量) 或 _GrowableList() → []
        return '[]';
      }
    }
    
    final allArgs = _restoreArgs(expr.arguments);
    final prefix = expr.isConst ? 'const ' : '';

    if (ctorName.isEmpty) return '$prefix$className($allArgs)';
    return '$prefix$className.$ctorName($allArgs)';
  }

  String _restoreConditional(ConditionalExpression expr) {
    return '(${_restoreExpr(expr.condition)} ? ${_restoreExpr(expr.then)} : ${_restoreExpr(expr.otherwise)})';
  }

  String _restoreLogical(LogicalExpression expr) {
    final op = expr.operatorEnum == LogicalExpressionOperator.AND ? '&&' : '||';
    return '(${_restoreExpr(expr.left)} $op ${_restoreExpr(expr.right)})';
  }

  String _restoreNot(Not expr) {
    return '!(${_restoreExpr(expr.operand)})';
  }

  String _restoreStringConcat(StringConcatenation expr) {
    final parts = expr.expressions.map((e) {
      if (e is StringLiteral) return e.value;
      return '\${${_restoreExpr(e)}}';
    }).join();
    return "'$parts'";
  }

  String _restoreStringLiteral(StringLiteral expr) {
    final escaped = expr.value
        .replaceAll('\\', '\\\\')
        .replaceAll("'", "\\'")
        .replaceAll('\n', '\\n')
        .replaceAll('\r', '\\r')
        .replaceAll('\t', '\\t');
    return "'$escaped'";
  }

  String _restoreDoubleLiteral(DoubleLiteral expr) {
    final v = expr.value;
    if (v == v.toInt().toDouble()) return '${v.toStringAsFixed(1)}';
    return '$v';
  }

  String _restoreListLiteral(ListLiteral expr) {
    final typeArg = _restoreType(expr.typeArgument);
    final items = expr.expressions.map((e) => _restoreExpr(e)).join(', ');
    if (expr.isConst) return 'const <$typeArg>[$items]';
    if (typeArg == 'dynamic') return '[$items]';
    return '<$typeArg>[$items]';
  }

  String _restoreMapLiteral(MapLiteral expr) {
    final keyType = _restoreType(expr.keyType);
    final valueType = _restoreType(expr.valueType);
    final entries = expr.entries.map((e) {
      return '${_restoreExpr(e.key)}: ${_restoreExpr(e.value)}';
    }).join(', ');
    if (expr.isConst) return 'const <$keyType, $valueType>{$entries}';
    if (keyType == 'dynamic' && valueType == 'dynamic') return '{$entries}';
    return '<$keyType, $valueType>{$entries}';
  }

  String _restoreSetLiteral(SetLiteral expr) {
    final typeArg = _restoreType(expr.typeArgument);
    final items = expr.expressions.map((e) => _restoreExpr(e)).join(', ');
    if (expr.isConst) return 'const <$typeArg>{$items}';
    return '<$typeArg>{$items}';
  }

  String _restoreIsExpr(IsExpression expr) {
    return '(${_restoreExpr(expr.operand)} is ${_restoreType(expr.type)})';
  }

  String _restoreAsExpr(AsExpression expr) {
    return '(${_restoreExpr(expr.operand)} as ${_restoreType(expr.type)})';
  }

  String _restoreLet(Let expr) {
    final v = expr.variable;
    if (v.name == null) v.name = '_let${_varCounter++}';
    final name = _cleanVarName(v.name!);
    v.name = name;
    final init = _restoreExpr(v.initializer!);
    final body = _restoreExpr(expr.body);
    return '(() { final $name = $init; return $body; })()';
  }

  String _restoreBlockExpr(BlockExpression expr) {
    final stmts = StringBuffer();
    // 先处理语句，确保变量名被正确清理和记录
    for (final s in expr.body.statements) {
      // 临时保存 indent
      final oldBuf = _buf;
      final tmpBuf = StringBuffer();
      _buf = tmpBuf;
      _restoreStmt(s);
      _buf = oldBuf;
      stmts.write(tmpBuf);
    }
    // 再处理值表达式，此时变量名已经被清理并记录到 _cleanedNames 中
    final value = _restoreExpr(expr.value);
    final cleanedStmts = stmts.toString();
    return '(() { $cleanedStmts return $value; })()';
  }

  String _restoreFuncExpr(FunctionExpression expr) {
    final func = expr.function;
    final sb = StringBuffer();
    sb.write('(');
    // 参数
    final params = <String>[];
    for (final p in func.positionalParameters) {
      final pName = _cleanVarName(p.name ?? '_p${_varCounter++}');
      p.name = pName;
      params.add('${_restoreType(p.type)} $pName');
    }
    for (final p in func.namedParameters) {
      final pName = _cleanVarName(p.name ?? '_n${_varCounter++}');
      p.name = pName;
      params.add('${_restoreType(p.type)} $pName');
    }
    sb.write(params.join(', '));
    sb.write(')');

    // body
    if (func.body is ReturnStatement) {
      final ret = func.body as ReturnStatement;
      if (ret.expression != null) {
        sb.write(' => ${_restoreExpr(ret.expression!)}');
      }
    } else if (func.body != null) {
      // 临时保存 indent
      final oldBuf = _buf;
      final tmpBuf = StringBuffer();
      _buf = tmpBuf;
      _restoreStmt(func.body!);
      _buf = oldBuf;
      sb.write(' $tmpBuf');
    }
    return sb.toString();
  }

  String _restoreRecordLiteral(RecordLiteral expr) {
    final parts = <String>[];
    for (final p in expr.positional) {
      parts.add(_restoreExpr(p));
    }
    for (final n in expr.named) {
      parts.add('${n.name}: ${_restoreExpr(n.value)}');
    }
    return '(${parts.join(', ')})';
  }

  String _restoreRecordIndexGet(RecordIndexGet expr) {
    final recv = _restoreExpr(expr.receiver);
    final idx = expr.index + 1; // Dart record 位置字段从 $1 开始
    return '$recv.\$$idx';
  }

  String _restoreRecordNameGet(RecordNameGet expr) {
    final recv = _restoreExpr(expr.receiver);
    return '$recv.${expr.name}';
  }
}
