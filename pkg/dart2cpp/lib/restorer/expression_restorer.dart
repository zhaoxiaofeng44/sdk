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
    if (expr is DynamicSet) {
      final recv = _restoreExpr(expr.receiver);
      final fieldName = expr.name.text;
      final value = _restoreExpr(expr.value);
      // mixin 内部的 setter 调用：通过 vptr 代理
      // OOP lowering 后 this 变成了 this_ 参数变量（VariableGet），不再是 ThisExpression
      final insideMixin = _currentClass != null && _isMixinName(_currentClass!.name);
      final isThisReceiver = expr.receiver is ThisExpression ||
          (expr.receiver is VariableGet &&
              (expr.receiver as VariableGet).variable.name == _thisReplacementName);
      if (insideMixin && _insideMethodBody && isThisReceiver) {
        // 检查是否有对应的 setter（非下划线字段）
        // 下划线字段直接赋值，非下划线字段通过 vptr setter
        if (!fieldName.startsWith('_')) {
          return "($recv.vptr['set_$fieldName'] as Function)($recv, $value)";
        }
      }
      return '$recv.$fieldName = $value';
    }
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
    if (expr is ThisExpression) {
      // 闭包 Lowering: this 被捕获到 env 中 → env.this_
      if (_thisIsCapturedInEnv) {
        return 'env.$_thisReplacementName';
      }
      // OOP Lowering: this → _thisReplacementName
      // 在实例方法体内为 'this_'，在构造函数体内为 'obj'
      // 适用于用户自定义类、mixin、enum
      if (_insideMethodBody && _currentClass != null && _needsLowering(_currentClass!.name)) {
        return _thisReplacementName;
      }
      return 'this';
    }
    if (expr is SuperPropertyGet) {
      // OOP Lowering: super.getter → Parent_get_field(this_) 或 super.field → this_.field
      if (_insideMethodBody && _currentClass != null && _needsLowering(_currentClass!.name)) {
        final fieldName = expr.name.text;
        final target = expr.interfaceTarget;
        // 如果 target 是 getter Procedure，调用父类静态函数
        if (target is Procedure && target.isGetter) {
          var parentName = _getParentClassName(_currentClass!.name);
          // 跳过合成中间类
          while (parentName != null && _syntheticLoweredNames.contains(parentName)) {
            parentName = _getParentClassName(parentName);
          }
          if (parentName != null && _needsLowering(parentName)) {
            return '${parentName}_get_$fieldName($_thisReplacementName)';
          }
        }
        return '$_thisReplacementName.$fieldName';
      }
      return 'super.${expr.name.text}';
    }
    if (expr is SuperMethodInvocation) {
      // OOP Lowering: super.method() → Parent_method(this_/obj, args)
      if (_currentClass != null && _needsLowering(_currentClass!.name)) {
        var parentName = _getParentClassName(_currentClass!.name);
        // 跳过合成中间类，找到实际的父类
        while (parentName != null && _syntheticLoweredNames.contains(parentName)) {
          parentName = _getParentClassName(parentName);
        }
        if (parentName != null && _needsLowering(parentName)) {
          final args = _restoreArgs(expr.arguments);
          final staticName = _staticMethodName(parentName, expr.name.text);
          final selfArg = _insideMethodBody ? _thisReplacementName : 'this';
          if (args.isEmpty) {
            return '$staticName($selfArg)';
          }
          return '$staticName($selfArg, $args)';
        }
      }
      return 'super.${expr.name.text}(${_restoreArgs(expr.arguments)})';
    }
    if (expr is RecordLiteral) return _restoreRecordLiteral(expr);
    if (expr is RecordIndexGet) return _restoreRecordIndexGet(expr);
    if (expr is RecordNameGet) return _restoreRecordNameGet(expr);
    if (expr is ConstantExpression) return _restoreConstant(expr.constant);
    if (expr is InstanceGetterInvocation) {
      final recv = _restoreExpr(expr.receiver);
      final methodName = expr.name.text;
      // OOP Lowering: 泛型方法调用 → 通过虚表或静态函数
      final receiverClassName = _getReceiverClassNameFromReceiver(expr.receiver, expr.interfaceTarget);
      if (receiverClassName != null && (_isUserClass(receiverClassName) || _isMixinName(receiverClassName))) {
        // 泛型方法调用：还原为 vptr 调用
        final args = _restoreArgs(expr.arguments);
        final insideMixin = _currentClass != null && _isMixinName(_currentClass!.name);
        if (insideMixin) {
          final argsStr = args.isEmpty ? recv : '$recv, $args';
          return "($recv.vptr['$methodName'] as Function)($argsStr)";
        }
        // 非 mixin 内部：使用精确签名
        final typeArgs = expr.arguments.types.map((t) => _restoreType(t)).toList();
        final typeArgsStr = typeArgs.isNotEmpty ? '<${typeArgs.join(', ')}>' : '';
        final selfArg = _insideMethodBody ? recv : recv;
        final staticName = '${receiverClassName}_$methodName';
        if (args.isEmpty) {
          return '$staticName$typeArgsStr($selfArg)';
        }
        return '$staticName$typeArgsStr($selfArg, $args)';
      }
      return '$recv.$methodName(${_restoreArgs(expr.arguments)})';
    }
    if (expr is AbstractSuperPropertyGet) {
      // OOP Lowering: super.getter → Parent_get_field(this_) 或 super.field → this_.field
      if (_insideMethodBody && _currentClass != null && _needsLowering(_currentClass!.name)) {
        final fieldName = expr.name.text;
        // AbstractSuperPropertyGet 通常是 getter，尝试调用父类静态函数
        var parentName = _getParentClassName(_currentClass!.name);
        while (parentName != null && _syntheticLoweredNames.contains(parentName)) {
          parentName = _getParentClassName(parentName);
        }
        if (parentName != null && _needsLowering(parentName)) {
          // 检查父类是否有这个 getter 的静态函数
          final parentEntries = _classVTableEntries[parentName];
          if (parentEntries != null && parentEntries.any((e) => e.name == fieldName && e.kind == 'getter')) {
            return '${parentName}_get_$fieldName($_thisReplacementName)';
          }
        }
        return '$_thisReplacementName.$fieldName';
      }
      return 'super.${expr.name.text}';
    }
    if (expr is SuperPropertySet) {
      // OOP Lowering: super.field = value → this_/obj .field = value
      if (_insideMethodBody && _currentClass != null && _needsLowering(_currentClass!.name)) {
        return '$_thisReplacementName.${expr.name.text} = ${_restoreExpr(expr.value)}';
      }
      return 'super.${expr.name.text} = ${_restoreExpr(expr.value)}';
    }
    if (expr is InvalidExpression) return '/* invalid */';
    if (expr is NullCheck) return '${_restoreExpr(expr.operand)}!';
    if (expr is AwaitExpression) return 'await ${_restoreExpr(expr.operand)}';
    if (expr is CheckLibraryIsLoaded) return 'true';
    if (expr is LoadLibrary) return '${expr.import.name}';
    if (expr is LocalFunctionInvocation) {
      final funcName = expr.variable.name ?? '_localFunc';
      final args = _restoreArgs(expr.arguments);
      return '$funcName($args)';
    }
    return '/* unknown: ${expr.runtimeType} */';
  }

  String _restoreVarGet(VariableGet expr) {
    if (expr.variable.name == null) {
      expr.variable.name = '_v${_varCounter++}';
    }
    final name = _cleanVarName(expr.variable.name!);
    // 闭包 lowering: 如果变量被捕获到 env 中，加 env. 前缀
    final prefix = _capturedVarEnvPrefix[expr.variable];
    if (prefix != null) return '$prefix$name';
    return name;
  }

  String _restoreVarSet(VariableSet expr) {
    if (expr.variable.name == null) {
      expr.variable.name = '_v${_varCounter++}';
    }
    final name = _cleanVarName(expr.variable.name!);
    // 闭包 lowering: 如果变量被捕获到 env 中，加 env. 前缀
    final prefix = _capturedVarEnvPrefix[expr.variable];
    final qualifiedName = prefix != null ? '$prefix$name' : name;
    return '$qualifiedName = ${_restoreExpr(expr.value)}';
  }

  String _restoreInstanceGet(InstanceGet expr) {
    final recv = _restoreExpr(expr.receiver);
    final fieldName = expr.name.text;

    final receiverClassName = _getReceiverClassNameFromReceiver(expr.receiver, expr.interfaceTarget);

    // 用户自定义类或 mixin 的 getter 调用 → 通过 Map 查找类型转换
    if (receiverClassName != null && (_isUserClass(receiverClassName) || _isMixinName(receiverClassName))) {
      final target = expr.interfaceTarget;
      if (target is Procedure && target.isGetter) {
        // mixin 内部：使用 Function cast 避免逆变问题
        final insideMixin = _currentClass != null && _isMixinName(_currentClass!.name);
        if (insideMixin) {
          return "($recv.vptr['get_$fieldName'] as Function)($recv)";
        }
        final sig = _buildPreciseFuncSignature(target, receiverClassName: receiverClassName);
        return "($recv.vptr['get_$fieldName'] as $sig)($recv)";
      }
    }

    // enum getter 调用 → 静态函数: EnumName_get_field(recv)
    if (receiverClassName != null && _isEnumName(receiverClassName)) {
      final target = expr.interfaceTarget;
      if (target is Procedure && target.isGetter) {
        return '${receiverClassName}_get_$fieldName($recv)';
      }
    }

    return '$recv.$fieldName';
  }

  String _restoreInstanceSet(InstanceSet expr) {
    final recv = _restoreExpr(expr.receiver);
    final fieldName = expr.name.text;

    final receiverClassName = _getReceiverClassNameFromReceiver(expr.receiver, expr.interfaceTarget);

    // 用户自定义类的 setter 调用 → 通过 Map 查找类型转换
    if (receiverClassName != null && _isUserClass(receiverClassName)) {
      final target = expr.interfaceTarget;
      if (target is Procedure && target.isSetter) {
        // mixin 内部：使用 Function cast 避免逆变问题
        final insideMixin = _currentClass != null && _isMixinName(_currentClass!.name);
        if (insideMixin) {
          return "($recv.vptr['set_$fieldName'] as Function)($recv, ${_restoreExpr(expr.value)})";
        }
        final sig = _buildPreciseFuncSignature(target, receiverClassName: receiverClassName);
        return "($recv.vptr['set_$fieldName'] as $sig)($recv, ${_restoreExpr(expr.value)})";
      }
    }

    // enum setter 调用 → 静态函数: EnumName_set_field(recv, value)
    if (receiverClassName != null && _isEnumName(receiverClassName)) {
      final target = expr.interfaceTarget;
      if (target is Procedure && target.isSetter) {
        return '${receiverClassName}_set_$fieldName($recv, ${_restoreExpr(expr.value)})';
      }
    }

    return '$recv.$fieldName = ${_restoreExpr(expr.value)}';
  }

  String _restoreInstanceInvocation(InstanceInvocation expr) {
    final recv = _restoreExpr(expr.receiver);
    final name = expr.name.text;

    // 从 receiver 表达式的类型推断实际接收者类名
    final receiverClassName = _getReceiverClassNameFromReceiver(expr.receiver, expr.interfaceTarget);

    // 对于用户自定义类或 mixin 的实例方法调用，改写为 Map 查找 + 精确类型转换调用
    if (receiverClassName != null && (_isUserClass(receiverClassName) || _isMixinName(receiverClassName))) {
      // 构建签名：从 interfaceTarget 获取完整参数列表，签名包含全部参数类型
      // 返回类型使用 functionType 中的实际类型（已替换类型参数）
      final returnType = _restoreTypeForSignature(expr.functionType.returnType);
      final enclosingClass = expr.interfaceTarget.enclosingClass;
      final actualClassName = enclosingClass != null ? _getActualClassName(enclosingClass.name) : null;
      // this_ 类型需要和函数定义处保持一致
      // 使用 receiverClassName 解析（而非 target.enclosingClass，后者可能是合成中间类）
      final insideMixin = _currentClass != null && _isMixinName(_currentClass!.name);
      final thisType = insideMixin ? 'dynamic' : _resolveThisTypeForReceiver(receiverClassName, name, expr.interfaceTarget);

      // mixin 内部的 vptr 调用：使用 Function 类型 cast（不带参数签名）
      // 因为 mixin 内部 this_ 是 dynamic，但注册的函数参数是具体类型，
      // Dart 函数类型逆变导致精确签名 cast 不兼容
      if (insideMixin) {
        final vtableField = _isBinaryOp(name) ? 'operator${_operatorFuncName(name)}'
            : name == 'unary-' ? 'operatorNeg'
            : name == '~' ? 'operatorBitNot'
            : name == '[]' ? 'operatorIndex'
            : name == '[]=' ? 'operatorIndexSet'
            : _vtableFieldName(name);
        final allArgs = _restoreArgs(expr.arguments);
        // 补齐缺省的默认参数值
        final targetFunc = expr.interfaceTarget.function;
        final fullArgParts = <String>[];
        for (var i = 0; i < expr.arguments.positional.length; i++) {
          fullArgParts.add(_restoreExpr(expr.arguments.positional[i]));
        }
        for (var i = expr.arguments.positional.length; i < targetFunc.positionalParameters.length; i++) {
          final param = targetFunc.positionalParameters[i];
          if (param.initializer != null) {
            fullArgParts.add(_restoreExpr(param.initializer!));
          }
        }
        final argsStr = fullArgParts.isEmpty ? '' : ', ${fullArgParts.join(', ')}';
        return "($recv.vptr['$vtableField'] as Function)($recv$argsStr)";
      }

      // 二元运算符 → Map 查找精确类型转换调用
      if (_isBinaryOp(name) && expr.arguments.positional.length == 1) {
        final right = _restoreExpr(expr.arguments.positional[0]);
        final rightType = _restoreTypeForSignature(expr.functionType.positionalParameters[0]);
        final sig = '$returnType Function($thisType, $rightType)';
        final vtableField = 'operator${_operatorFuncName(name)}';
        return "($recv.vptr['$vtableField'] as $sig)($recv, $right)";
      }
      // 一元运算符
      if (name == 'unary-') {
        final sig = '$returnType Function($thisType)';
        return "($recv.vptr['operatorNeg'] as $sig)($recv)";
      }
      if (name == '~') {
        final sig = '$returnType Function($thisType)';
        return "($recv.vptr['operatorBitNot'] as $sig)($recv)";
      }
      if (name == '[]') {
        final idx = _restoreExpr(expr.arguments.positional[0]);
        final idxType = _restoreTypeForSignature(expr.functionType.positionalParameters[0]);
        final sig = '$returnType Function($thisType, $idxType)';
        return "($recv.vptr['operatorIndex'] as $sig)($recv, $idx)";
      }
      if (name == '[]=') {
        final idx = _restoreExpr(expr.arguments.positional[0]);
        final val = _restoreExpr(expr.arguments.positional[1]);
        final sig = '$returnType Function($thisType, dynamic, dynamic)';
        return "($recv.vptr['operatorIndexSet'] as $sig)($recv, $idx, $val)";
      }
      // 普通方法 → Map 查找精确类型转换调用
      final vtableField = _vtableFieldName(name);
      final allArgs = _restoreArgs(expr.arguments);
      
      // 检查是否有命名参数：如果有，不能使用精确 Function 类型 cast
      // 因为 Dart 的 Function 类型签名不支持命名参数语法
      final hasNamedArgs = expr.arguments.named.isNotEmpty;
      
      if (hasNamedArgs) {
        // 有命名参数时，使用 Function 类型 cast（不带参数签名）
        if (allArgs.isEmpty) {
          return "($recv.vptr['$vtableField'] as Function)($recv)";
        }
        return "($recv.vptr['$vtableField'] as Function)($recv, $allArgs)";
      }
      
      // 检查方法是否有方法级类型参数（如 then<TNewOutput>）
      // 如果有，vptr 中的 lambda 无法保留类型参数，直接调用静态函数
      final hasMethodTypeParams = expr.interfaceTarget.function.typeParameters.isNotEmpty;
      if (hasMethodTypeParams) {
        // 合成中间类 → 找到实际用户类名
        var resolvedClassName = actualClassName ?? receiverClassName;
        if (resolvedClassName != null && _syntheticLoweredNames.contains(resolvedClassName)) {
          resolvedClassName = _findUserClassForSynthetic(resolvedClassName);
        }
        final staticFuncName = '${resolvedClassName}_$name';
        // 构建完整的类型参数列表：类的类型参数 + 方法的类型参数
        final allTypeArgs = <String>[];
        // 类的类型参数：从 receiver 的静态类型中提取
        final receiverClassTypeArgs = _extractClassTypeArgsFromReceiver(expr.receiver);
        allTypeArgs.addAll(receiverClassTypeArgs);
        // 方法的类型参数：从 arguments.types 中获取
        for (final ta in expr.arguments.types) {
          allTypeArgs.add(_restoreType(ta));
        }
        final typeArgStr = allTypeArgs.isNotEmpty ? '<${allTypeArgs.join(', ')}>' : '';
        if (allArgs.isEmpty) {
          return '$staticFuncName$typeArgStr($recv)';
        }
        return '$staticFuncName$typeArgStr($recv, $allArgs)';
      }

      // 如果方法定义在不同于 receiver 的父类中，或声明类有泛型参数，
      // 使用 Function 类型 cast 避免签名不匹配的运行时错误
      // （Dart 函数参数类型逆变 + 泛型具体化导致精确签名不安全）
      final declClass = expr.interfaceTarget.enclosingClass;
      final declHasTypeParams = declClass != null && declClass.typeParameters.isNotEmpty;
      if (actualClassName != null && (actualClassName != receiverClassName || declHasTypeParams)) {
        if (allArgs.isEmpty) {
          return "($recv.vptr['$vtableField'] as Function)($recv)";
        }
        return "($recv.vptr['$vtableField'] as Function)($recv, $allArgs)";
      }

      // 无命名参数且无方法级类型参数时，使用精确签名
      // 从 interfaceTarget 获取完整参数列表（含默认参数），签名包含全部参数类型
      final targetFunc = expr.interfaceTarget.function;
      final sigParamTypes = <String>[thisType];
      for (var i = 0; i < targetFunc.positionalParameters.length; i++) {
        if (i < expr.functionType.positionalParameters.length) {
          sigParamTypes.add(_restoreTypeForSignature(expr.functionType.positionalParameters[i]));
        } else {
          sigParamTypes.add(_restoreTypeForSignature(targetFunc.positionalParameters[i].type));
        }
      }
      final sig = '$returnType Function(${sigParamTypes.join(', ')})';

      // 补齐缺省的默认参数值
      final fullArgParts = <String>[];
      for (var i = 0; i < expr.arguments.positional.length; i++) {
        fullArgParts.add(_restoreExpr(expr.arguments.positional[i]));
      }
      for (var i = expr.arguments.positional.length; i < targetFunc.positionalParameters.length; i++) {
        final param = targetFunc.positionalParameters[i];
        if (param.initializer != null) {
          fullArgParts.add(_restoreExpr(param.initializer!));
        } else {
          fullArgParts.add(_defaultValueForType(param.type));
        }
      }
      final fullArgs = fullArgParts.join(', ');
      if (fullArgs.isEmpty) {
        return "($recv.vptr['$vtableField'] as $sig)($recv)";
      }
      return "($recv.vptr['$vtableField'] as $sig)($recv, $fullArgs)";
    }

    // enum 方法调用 → 直接调用静态函数: EnumName_method(recv, args)
    if (receiverClassName != null && _isEnumName(receiverClassName)) {
      final staticName = '${receiverClassName}_$name';
      final allArgs = _restoreArgs(expr.arguments);
      if (allArgs.isEmpty) {
        return '$staticName($recv)';
      }
      return '$staticName($recv, $allArgs)';
    }

    // mixin 方法调用 → 通过 Map 查找精确类型转换调用（接收者对象的 vptr Map 中已包含 mixin 方法）
    if (receiverClassName != null && _isMixinName(receiverClassName)) {
      final target = expr.interfaceTarget;
      final sig = _buildPreciseFuncSignature(target);
      final vtableField = _vtableFieldName(name);
      final allArgs = _restoreArgs(expr.arguments);
      if (allArgs.isEmpty) {
        return "($recv.vptr['$vtableField'] as $sig)($recv)";
      }
      return "($recv.vptr['$vtableField'] as $sig)($recv, $allArgs)";
    }

    // 非用户自定义类：保持原始调用方式
    if (_isBinaryOp(name) && expr.arguments.positional.length == 1) {
      final right = _restoreExpr(expr.arguments.positional[0]);
      return '($recv $name $right)';
    }
    if (name == 'unary-') return '(-$recv)';
    if (name == '~') return '(~$recv)';
    if (name == '[]') {
      return '$recv[${_restoreExpr(expr.arguments.positional[0])}]';
    }
    if (name == '[]=') {
      return '$recv[${_restoreExpr(expr.arguments.positional[0])}] = ${_restoreExpr(expr.arguments.positional[1])}';
    }
    final allArgs = _restoreArgs(expr.arguments);
    return '$recv.$name($allArgs)';
  }

  /// 从 Procedure AST 构建精确的函数签名字符串，用于 vptr Map 的类型转换
  /// [receiverClassName] 指定接收者的类名，用于解析 this_ 类型
  /// 如果未指定，则使用 target.enclosingClass 解析
  String _buildPreciseFuncSignature(Procedure proc, {String? receiverClassName}) {
    final String thisType;
    if (receiverClassName != null) {
      thisType = _resolveThisTypeForReceiver(receiverClassName, proc.name.text, proc);
    } else {
      thisType = _resolveThisTypeForSignature(proc);
    }
    final returnType = _restoreTypeForSignature(proc.function.returnType);
    final paramTypes = <String>[thisType];
    for (final param in proc.function.positionalParameters) {
      paramTypes.add(_restoreTypeForSignature(param.type));
    }
    for (final param in proc.function.namedParameters) {
      paramTypes.add(_restoreTypeForSignature(param.type));
    }
    return '$returnType Function(${paramTypes.join(', ')})';
  }

  /// 从 InstanceInvocation.functionType 构建精确的函数签名字符串
  /// functionType 已包含接收者类型实参替换后的实际类型
  /// this_ 参数使用 declaringClassName 的类型，确保和静态函数定义一致
  /// 包含所有位置参数（含可选的）和命名参数
  String _buildPreciseFuncSignatureFromFunctionType(FunctionType functionType, Procedure proc) {
    final thisType = _resolveThisTypeForSignature(proc);
    final returnType = _restoreTypeForSignature(functionType.returnType);
    final paramTypes = <String>[thisType];
    for (final paramType in functionType.positionalParameters) {
      paramTypes.add(_restoreTypeForSignature(paramType));
    }
    for (final namedParam in functionType.namedParameters) {
      paramTypes.add(_restoreTypeForSignature(namedParam.type));
    }
    return '$returnType Function(${paramTypes.join(', ')})';
  }

  /// 解析方法的 this_ 参数类型，用于签名生成
  /// 和定义处保持一致：mixin → dynamic，其他 → 当前类 Value
  String _resolveThisTypeForSignature(Procedure proc) {
    final enclosingClass = proc.enclosingClass;
    if (enclosingClass == null) return 'dynamic';
    final className = _getActualClassName(enclosingClass.name);
    if (_isMixinName(className)) return 'dynamic';
    return '${className}Value';
  }

  /// 判断 declaringClass 是否在 className 的 extends 继承链上
  bool _isDeclaringClassInExtendsChain(String className, String declaringClass) {
    var current = _getParentClassName(className);
    while (current != null) {
      if (current == declaringClass) return true;
      current = _getParentClassName(current);
    }
    return false;
  }

  /// 根据接收者类名解析 vptr 调用处的 this_ 类型
  /// 与 _resolveThisTypeForSignature 不同，这里用 receiverClassName 查找 _classVTableEntries
  /// 而不是用 target.enclosingClass（后者可能是合成中间类或 mixin）
  String _resolveThisTypeForReceiver(String receiverClassName, String methodName, Member target) {
    // mixin 接收者 -> dynamic
    if (_isMixinName(receiverClassName)) {
      return 'dynamic';
    }
    // 如果方法定义在有泛型参数的类中，需要检查 receiver 的类型参数
    // 以确保 vptr 调用处的签名与实际函数签名匹配
    final declaringClass = target.enclosingClass;
    if (declaringClass != null && declaringClass.typeParameters.isNotEmpty) {
      final declClassName = _getActualClassName(declaringClass.name);
      // 如果声明类有泛型参数，使用 dynamic 避免泛型类型不匹配
      // 因为 vptr 中存储的函数签名可能用了具体化的类型参数
      return 'dynamic';
    }
    return '${receiverClassName}Value';
  }

  /// 获取类的实际规范化名称（处理合成 mixin 中间类名）
  String _getActualClassName(String rawName) {
    if (rawName.contains('&')) {
      return _sanitizeSyntheticName(rawName);
    }
    return rawName;
  }

  /// 从 receiver 表达式的变量类型中提取实际的接收者类名
  /// 优先使用 receiver 的静态类型（如 LoggedDataPointValue → LoggedDataPoint）
  /// fallback 到 interfaceTarget.enclosingClass
  String? _getReceiverClassNameFromReceiver(Expression receiver, Member? target) {
    // 从 receiver 的变量类型中提取
    if (receiver is VariableGet) {
      final varType = receiver.variable.type;
      if (varType is InterfaceType) {
        final rawName = varType.classNode.name;
        // Value 类名去掉 Value 后缀得到实际类名
        if (rawName.endsWith('Value')) {
          final className = rawName.substring(0, rawName.length - 5);
          if (_isUserClass(className) || _isMixinName(className)) {
            return className;
          }
        }
        final className = _getActualClassName(rawName);
        if (_isUserClass(className) || _isMixinName(className)) {
          return className;
        }
      }
    }
    // 从 ThisExpression 推断（在类方法内部）
    if (receiver is ThisExpression && _currentClass != null) {
      return _getActualClassName(_currentClass!.name);
    }
    // fallback 到 interfaceTarget.enclosingClass
    return _getReceiverClassName(target);
  }

  /// 从 interfaceTarget 获取接收者的类名（fallback 方法）
  String? _getReceiverClassName(Member? target) {
    if (target == null) return null;
    final enclosingClass = target.enclosingClass;
    if (enclosingClass == null) return null;
    final className = _getActualClassName(enclosingClass.name);
    // 合成中间类（如 Dog_Animal_Printable）→ 提取实际用户类名
    // 查找哪个非合成用户类的继承链包含此合成中间类
    if (_syntheticLoweredNames.contains(className)) {
      return _findUserClassForSynthetic(className);
    }
    return className;
  }

  /// 查找合成中间类对应的实际用户类名
  /// 例如：Dog_Animal_Printable → Dog（Dog 的继承链包含 Dog_Animal_Printable）
  String _findUserClassForSynthetic(String syntheticClassName) {
    for (final userClass in _userClasses) {
      if (_syntheticLoweredNames.contains(userClass)) continue;
      if (_isMixinName(userClass)) continue;
      // 检查 userClass 的继承链是否包含 syntheticClassName
      var current = _getParentClassName(userClass);
      while (current != null) {
        if (current == syntheticClassName) return userClass;
        current = _getParentClassName(current);
      }
    }
    // fallback: 返回合成中间类名本身
    return syntheticClassName;
  }

  /// 从接收者表达式中提取类的类型参数
  /// 例如：对于 PipelineValue<int, String> 类型的接收者，返回 ['int', 'String']
  List<String> _extractClassTypeArgsFromReceiver(Expression receiver) {
    // 尝试从 VariableGet 的变量类型中提取
    if (receiver is VariableGet) {
      final varType = receiver.variable.type;
      if (varType is InterfaceType && varType.typeArguments.isNotEmpty) {
        return varType.typeArguments.map((ta) => _restoreType(ta)).toList();
      }
    }
    // 尝试从 ConstructorInvocation 中提取
    if (receiver is ConstructorInvocation) {
      final args = receiver.arguments.types;
      if (args.isNotEmpty) {
        return args.map((ta) => _restoreType(ta)).toList();
      }
    }
    // 尝试从嵌套的 InstanceInvocation 返回类型中提取
    if (receiver is InstanceInvocation) {
      final retType = receiver.functionType.returnType;
      if (retType is InterfaceType && retType.typeArguments.isNotEmpty) {
        return retType.typeArguments.map((ta) => _restoreType(ta)).toList();
      }
    }
    // 尝试从 Let 表达式的 body 中提取
    if (receiver is Let) {
      return _extractClassTypeArgsFromReceiver(receiver.body);
    }
    // 尝试从 BlockExpression 的 value 中提取
    if (receiver is BlockExpression) {
      return _extractClassTypeArgsFromReceiver(receiver.value);
    }
    return [];
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
      final typeArgs = expr.arguments.types;
      final typePrefix = typeArgs.isNotEmpty ? '<${typeArgs.map((t) => _restoreType(t)).join(', ')}>' : '';
      if (name.startsWith('_literal')) {
        final items = expr.arguments.positional.map((e) => _restoreExpr(e)).join(', ');
        if (expr.isConst) return 'const $typePrefix[$items]';
        return '$typePrefix[$items]';
      }
      return '$typePrefix[]';
    }

    // 特殊处理：Set 内部实现类的静态工厂方法 → {} 字面量
    if (target.enclosingClass != null && _isSetInternalClass(target.enclosingClass!.name)) {
      final typeArgs = expr.arguments.types;
      final typePrefix = typeArgs.isNotEmpty ? '<${typeArgs.map((t) => _restoreType(t)).join(', ')}>' : '';
      return '$typePrefix{}';
    }

    // 特殊处理：Map 内部实现类（LinkedHashMap 等）→ Map
    if (target.enclosingClass != null && _isMapInternalClass(target.enclosingClass!.name)) {
      final publicName = 'Map';
      if (name.isEmpty) return '$publicName($args)';
      return '$publicName.$name($args)';
    }

    // 扩展方法调用：函数名包含 | 字符（如 "StringExtensions|capitalize"）
    // 需要将函数名清理为合法标识符，并将 receiver 参数（this_）正确传递
    if (_isExtensionMethodName(name)) {
      final cleanedName = _sanitizeExtensionMethodName(name);
      return '$cleanedName($args)';
    }

    // factory 构造函数
    if (target.isFactory && target.enclosingClass != null) {
      final className = target.enclosingClass!.name;
      // OOP Lowering: 用户自定义类的 factory → X_new / X_new_name
      if (_isUserClass(className)) {
        final funcName = name.isEmpty
            ? '${className}_new'
            : '${className}_new_$name';
        return '$funcName($args)';
      }
      if (name.isEmpty) return '$className($args)';
      return '$className.$name($args)';
    }

    // 静态方法
    if (target.enclosingClass != null) {
      var className = target.enclosingClass!.name;
      // OOP Lowering: 用户自定义类的静态方法 → X_methodName
      if (_isUserClass(className)) {
        // 规范化类名（处理合成中间类名中的 & 字符）
        className = _getActualClassName(className);
        // 合成中间类 → 找到实际用户类名
        if (_syntheticLoweredNames.contains(className)) {
          className = _findUserClassForSynthetic(className);
        }
        return '${className}_$name($args)';
      }
      return '$className.$name($args)';
    }

    return '$name($args)';
  }

  String _restoreStaticGet(StaticGet expr) {
    final target = expr.target;
    if (target.enclosingClass != null) {
      final className = target.enclosingClass!.name;
      final memberName = target.name.text;
      // OOP Lowering: 用户自定义类的静态字段/getter → 使用 lowered 名称
      if (_isUserClass(className)) {
        // 静态字段和静态 getter 都被提升为顶层函数/变量 ClassName_memberName
        // 静态 getter 生成为 ClassName_memberName() 函数
        if (target is Procedure && (target as Procedure).isGetter) {
          return '${className}_$memberName()';
        }
        // 静态字段 → 顶层变量 ClassName_memberName
        return '${className}_$memberName';
      }
      return '$className.$memberName';
    }
    return target.name.text;
  }

  String _restoreStaticSet(StaticSet expr) {
    final target = expr.target;
    final value = _restoreExpr(expr.value);
    if (target.enclosingClass != null) {
      final className = target.enclosingClass!.name;
      // OOP Lowering: 用户自定义类的静态字段 → 使用 lowered 名称
      if (_isUserClass(className)) {
        final memberName = target.name.text;
        return '${className}_$memberName = $value';
      }
      return '$className.${target.name.text} = $value';
    }
    return '${target.name.text} = $value';
  }

  String _restoreConstructorInvocation(ConstructorInvocation expr) {
    final className = expr.target.enclosingClass.name;
    final ctorName = expr.target.name.text;
    
    // 特殊处理：_GrowableList 转换为列表字面量
    if (className == '_GrowableList') {
      if (ctorName.startsWith('_literal')) {
        final items = expr.arguments.positional.map((e) => _restoreExpr(e)).join(', ');
        return '[$items]';
      } else if (ctorName.isEmpty) {
        return '[]';
      }
    }

    // 特殊处理：Set 内部实现类 → {} 字面量
    // Kernel 将 {1, 2, 3} 脱糖为 _CompactLinkedHashSet / _Set 等内部类的构造
    if (_isSetInternalClass(className)) {
      // 从类型参数获取实际元素类型
      if (expr.arguments.types.isNotEmpty) {
        final elemType = _restoreType(expr.arguments.types.first);
        return '<$elemType>{}';
      }
      return '<dynamic>{}';
    }
    
    final allArgs = _restoreArgs(expr.arguments);

    // OOP Lowering: 用户自定义类的构造调用 → 先创建 Value，再调用 new(this_, args)
    // 生成内联表达式：(() { final _obj = XValue(); X_new(_obj, args); return _obj; })()
    if (_isUserClass(className)) {
      final funcName = ctorName.isEmpty
          ? '${className}_new'
          : '${className}_new_$ctorName';
      // 获取类型参数（如 Pair<String, int>）
      final typeArgs = expr.arguments.types.isNotEmpty
          ? '<${expr.arguments.types.map(_restoreType).join(', ')}>'
          : '';
      final valueType = '${className}Value$typeArgs';
      final newCall = allArgs.isEmpty
          ? '$funcName(_obj)'
          : '$funcName(_obj, $allArgs)';
      return '(() { final _obj = $valueType(); $newCall; return _obj; })()';
    }

    final prefix = expr.isConst ? 'const ' : '';
    if (ctorName.isEmpty) return '$prefix$className($allArgs)';
    // SDK 类的私有构造函数（如 MapEntry._）应还原为无名构造函数形式
    if (ctorName.startsWith('_')) return '$prefix$className($allArgs)';
    return '$prefix$className.$ctorName($allArgs)';
  }

  /// 判断是否是 Set 的内部实现类（Kernel 脱糖后的内部类名）
  bool _isSetInternalClass(String className) {
    return className == '_Set' ||
        className == '_CompactLinkedHashSet' ||
        className == '_LinkedHashSet' ||
        className == 'LinkedHashSet' ||
        className == '_HashSet';
  }

  /// 判断是否是 Map 的内部实现类
  bool _isMapInternalClass(String className) {
    return className == 'LinkedHashMap' ||
        className == '_CompactLinkedHashMap' ||
        className == '_InternalLinkedHashMap' ||
        className == '_LinkedHashMap';
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
      if (e is StringLiteral) {
        // Escape special characters in string literal parts
        // to prevent $$ or unintended interpolation in output
        final escaped = e.value
            .replaceAll(r'\\', r'\\\\')
            .replaceAll("'", "\\'")
            .replaceAll(r'$', r'\$')
            .replaceAll('\n', r'\n')
            .replaceAll('\r', r'\r')
            .replaceAll('\t', r'\t');
        return escaped;
      }
      // 对于有自定义 toString 的枚举，在字符串插值中调用静态 toString 函数
      final enumToStringCall = _tryEnumToStringInInterpolation(e);
      if (enumToStringCall != null) return '\${$enumToStringCall}';
      return '\${${_restoreExpr(e)}}';
    }).join();
    return "'$parts'";
  }

  /// 检查表达式是否是有自定义 toString 的枚举类型
  /// 如果是，返回 EnumName_toString(expr) 的调用字符串
  String? _tryEnumToStringInInterpolation(Expression expr) {
    DartType? exprType;
    if (expr is VariableGet) {
      exprType = expr.variable.type;
    } else if (expr is InstanceGet) {
      // 属性访问（如 this_.priority）的类型
      exprType = expr.resultType;
    } else if (expr is InstanceInvocation && expr.name.text == 'toString') {
      // 已经是 toString() 调用，检查接收者类型
      final receiverClassName = _getReceiverClassName(expr.interfaceTarget);
      if (receiverClassName != null && _enumsWithCustomToString.contains(receiverClassName)) {
        final recv = _restoreExpr(expr.receiver);
        return '${receiverClassName}_toString($recv)';
      }
      return null;
    }
    if (exprType is InterfaceType) {
      final className = exprType.classNode.name;
      if (_enumsWithCustomToString.contains(className)) {
        final restored = _restoreExpr(expr);
        return '${className}_toString($restored)';
      }
    }
    return null;
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

    // 先清理变量名，确保后续 body 中对同一变量的引用能正确解析
    if (v.name == null) v.name = '_let${_varCounter++}';
    final cleanedName = _cleanVarName(v.name!);
    v.name = cleanedName;

    // 识别 null-coalescing 模式（?? 操作符）：
    // Let(tmp = expr, tmp == null ? fallback : tmp)
    // 这是 Dart 编译器将 `expr ?? fallback` 脱糖后的形式
    if (v.initializer != null) {
      final body = expr.body;
      if (body is ConditionalExpression) {
        final condition = body.condition;
        if (condition is EqualsNull) {
          final condExpr = condition.expression;
          if (condExpr is VariableGet && condExpr.variable == v) {
            // 检查 otherwise 分支是否也引用同一个变量（即 tmp != null 时返回 tmp）
            final otherwise = body.otherwise;
            if (otherwise is VariableGet && otherwise.variable == v) {
              // 匹配到 expr ?? fallback 模式
              final lhs = _restoreExpr(v.initializer!);
              final fallback = _restoreExpr(body.then);
              return '($lhs ?? $fallback)';
            }
            // 也可能是 AsExpression 包裹的 tmp（类型转换）
            if (otherwise is AsExpression) {
              final inner = otherwise.operand;
              if (inner is VariableGet && inner.variable == v) {
                final lhs = _restoreExpr(v.initializer!);
                final fallback = _restoreExpr(body.then);
                return '($lhs ?? $fallback)';
              }
            }
          }
        }
      }
    }

    // 识别 null-safe 访问模式（?. 操作符）：
    // Let(tmp = expr, tmp == null ? null : tmp.something)
    // 这是 Dart 编译器将 `expr?.something` 脱糖后的形式
    if (v.initializer != null) {
      final body = expr.body;
      if (body is ConditionalExpression) {
        final condition = body.condition;
        if (condition is EqualsNull) {
          final condExpr = condition.expression;
          if (condExpr is VariableGet && condExpr.variable == v) {
            final thenBranch = body.then;
            if (thenBranch is NullLiteral) {
              // 匹配到 expr?.something 模式
              final otherwiseExpr = body.otherwise;
              
              // 检查 receiver 类型是否是用户自定义类（需要 OOP lowering）
              // 如果是，不能简化为 lhs?.member
              final receiverNeedsLowering = _nullSafeReceiverNeedsLowering(v);
              
              if (!receiverNeedsLowering) {
                // 非用户自定义类：还原为 lhs?.member 形式
                final lhs = _restoreExpr(v.initializer!);
                final memberAccess = _extractMemberAccessOnVar(otherwiseExpr, v);
                if (memberAccess != null) {
                  return '$lhs?.$memberAccess';
                }
              }
              
              // 用户自定义类或无法提取成员访问：使用 IIFE 模式
              final lhs = _restoreExpr(v.initializer!);
              final tmpName = cleanedName;
              return '(() { final $tmpName = $lhs; return ($tmpName == null) ? null : ${_restoreExpr(otherwiseExpr)}; })()';
            }
          }
        }
      }
    }

    // 识别级联操作符模式（.. 语法）：
    // Let(tmp = expr, BlockExpression([tmp.method1(); tmp.method2(); ...], tmp))
    // Kernel 将 `expr..method1()..method2()` 脱糖为上述形式
    if (v.initializer != null) {
      final body = expr.body;
      if (body is BlockExpression) {
        final blockValue = body.value;
        if (blockValue is VariableGet && blockValue.variable == v) {
          // body 的 value 引用了同一个变量 → 可能是级联
          final cascadeOps = _extractCascadeOps(body.body.statements, v);
          if (cascadeOps != null && cascadeOps.isNotEmpty) {
            final receiver = _restoreExpr(v.initializer!);
            final opsStr = cascadeOps.join('');
            return '($receiver$opsStr)';
          }
        }
      }
    }

    final init = _restoreExpr(v.initializer!);
    final body = _restoreExpr(expr.body);
    return '(() { final $cleanedName = $init; return $body; })()';
  }

  /// 从级联的 BlockExpression 语句列表中提取 .. 操作
  /// 每个语句应该是对同一个变量的方法调用或属性设置
  /// 返回 null 表示不是级联模式
  List<String>? _extractCascadeOps(List<Statement> stmts, VariableDeclaration cascadeVar) {
    final ops = <String>[];
    for (final stmt in stmts) {
      if (stmt is ExpressionStatement) {
        final cascadeOp = _extractSingleCascadeOp(stmt.expression, cascadeVar);
        if (cascadeOp != null) {
          ops.add(cascadeOp);
        } else {
          return null; // 不是级联操作
        }
      } else {
        return null; // 非表达式语句，不是级联
      }
    }
    return ops;
  }

  /// 从单个表达式中提取级联操作（如 ..add(1)、..write('x')）
  /// 返回 null 表示不是对 cascadeVar 的操作
  String? _extractSingleCascadeOp(Expression expr, VariableDeclaration cascadeVar) {
    // 方法调用：tmp.method(args) → ..method(args)
    if (expr is InstanceInvocation) {
      final receiver = expr.receiver;
      if (receiver is VariableGet && receiver.variable == cascadeVar) {
        final args = _restoreArgs(expr.arguments);
        return '..${expr.name.text}($args)';
      }
    }
    // 属性设置：tmp.field = value → ..field = value
    if (expr is InstanceSet) {
      final receiver = expr.receiver;
      if (receiver is VariableGet && receiver.variable == cascadeVar) {
        return '..${expr.name.text} = ${_restoreExpr(expr.value)}';
      }
    }
    // DynamicInvocation（某些情况下方法调用可能是 dynamic）
    if (expr is DynamicInvocation) {
      final receiver = expr.receiver;
      if (receiver is VariableGet && receiver.variable == cascadeVar) {
        final args = _restoreArgs(expr.arguments);
        return '..${expr.name.text}($args)';
      }
    }
    return null;
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

    // 分析捕获变量
    final analysis = analyzeCapturedVarsFromFunc(func);
    final capturedDecls = analysis.capturedDecls;
    final capturesThis = analysis.capturesThis;

    // 如果没有捕获任何变量，保持原有的 lambda 输出
    if (capturedDecls.isEmpty && !capturesThis) {
      return _restoreFuncExprAsLambda(func);
    }

    // 有捕获变量 → 生成 ClosureEnv callable class
    return _restoreFuncExprAsClosure(func, capturedDecls, capturesThis);
  }

  /// 原始的 lambda 输出（无捕获变量时使用）
  String _restoreFuncExprAsLambda(FunctionNode func) {
    final sb = StringBuffer();
    sb.write('(');
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

    if (func.body is ReturnStatement) {
      final ret = func.body as ReturnStatement;
      if (ret.expression != null) {
        sb.write(' => ${_restoreExpr(ret.expression!)}');
      }
    } else if (func.body != null) {
      final oldBuf = _buf;
      final tmpBuf = StringBuffer();
      _buf = tmpBuf;
      _restoreStmt(func.body!);
      _buf = oldBuf;
      sb.write(' $tmpBuf');
    }
    return sb.toString();
  }

  /// 闭包 Lowering: 生成 ClosureEnv callable class + 静态 call 函数
  ///
  /// 生成结构示例:
  /// ```dart
  /// class ClosureEnv_foo_0 {
  ///   int captured;
  ///   ClosureEnv_foo_0(this.captured);
  ///   dynamic call(int x) => ClosureEnv_foo_0_call(this, x);
  /// }
  /// int ClosureEnv_foo_0_call(ClosureEnv_foo_0 env, int x) {
  ///   return x + env.captured;
  /// }
  /// ```
  /// 使用处返回: `ClosureEnv_foo_0(captured)`
  String _restoreFuncExprAsClosure(
    FunctionNode func,
    List<VariableDeclaration> capturedDecls,
    bool capturesThis,
  ) {
    // 生成唯一的闭包名称
    final closureId = _closureCounter++;
    final envClassName = 'ClosureEnv_${_closureContext}_$closureId';

    // 构建捕获变量列表（名称 + 类型）
    final capturedFields = <_CapturedVar>[];

    // this 捕获
    if (capturesThis && _insideMethodBody && _currentClass != null && _needsLowering(_currentClass!.name)) {
      String thisTypeStr;
      if (_isUserClass(_currentClass!.name)) {
        // 包含类的类型参数，如 PipelineValue<TInput, TOutput>
        final classTypeParams = _currentClass!.typeParameters;
        final typeParamSuffix = classTypeParams.isNotEmpty
            ? '<${classTypeParams.map((tp) => tp.name ?? 'T').join(', ')}>'
            : '';
        thisTypeStr = '${_currentClass!.name}Value$typeParamSuffix';
      } else if (_isEnumName(_currentClass!.name)) {
        thisTypeStr = _currentClass!.name;
      } else {
        thisTypeStr = 'dynamic';
      }
      capturedFields.add(_CapturedVar(
        name: _thisReplacementName,
        typeStr: thisTypeStr,
        isThis: true,
      ));
    }

    // 普通变量捕获
    for (final decl in capturedDecls) {
      final varName = _cleanVarName(decl.name ?? '_cap${_varCounter++}');
      decl.name = varName;
      capturedFields.add(_CapturedVar(
        name: varName,
        typeStr: _restoreType(decl.type),
      ));
    }

    // 清理闭包参数名
    for (final p in func.positionalParameters) {
      final pName = _cleanVarName(p.name ?? '_p${_varCounter++}');
      p.name = pName;
    }
    for (final p in func.namedParameters) {
      final pName = _cleanVarName(p.name ?? '_n${_varCounter++}');
      p.name = pName;
    }

    // 构建参数列表字符串（用于 call 方法和静态函数）
    final callParams = <String>[];
    for (final p in func.positionalParameters) {
      callParams.add('${_restoreType(p.type)} ${p.name}');
    }
    for (final p in func.namedParameters) {
      callParams.add('${_restoreType(p.type)} ${p.name}');
    }
    final callParamStr = callParams.join(', ');

    // 参数名列表（用于转发调用）
    final callArgNames = <String>[];
    for (final p in func.positionalParameters) {
      callArgNames.add(p.name!);
    }
    for (final p in func.namedParameters) {
      callArgNames.add(p.name!);
    }
    final callArgStr = callArgNames.join(', ');

    // 返回类型
    final returnType = _restoreType(func.returnType);

    // ---- 收集闭包中用到的泛型参数 ----
    // 从捕获变量类型、参数类型、返回类型中递归收集所有 TypeParameter
    final typeParams = <TypeParameter>{};
    for (final decl in capturedDecls) {
      _collectTypeParameters(decl.type, typeParams);
    }
    for (final p in func.positionalParameters) {
      _collectTypeParameters(p.type, typeParams);
    }
    for (final p in func.namedParameters) {
      _collectTypeParameters(p.type, typeParams);
    }
    _collectTypeParameters(func.returnType, typeParams);

    // 生成泛型参数声明字符串，如 "<T>" 或 "<K, V>"
    final typeParamStr = typeParams.isEmpty
        ? ''
        : '<${typeParams.map((tp) => tp.name ?? 'T').join(', ')}>';

    // ---- 生成闭包体（在 env 上下文中还原） ----
    // 设置 env 映射，让 _restoreVarGet/Set 知道哪些变量需要加 env. 前缀
    final savedEnvPrefix = Map<VariableDeclaration, String>.from(_capturedVarEnvPrefix);
    final savedThisInEnv = _thisIsCapturedInEnv;

    for (final decl in capturedDecls) {
      _capturedVarEnvPrefix[decl] = 'env.';
    }
    if (capturesThis && _insideMethodBody && _currentClass != null && _isUserClass(_currentClass!.name)) {
      _thisIsCapturedInEnv = true;
    }

    // 推入闭包上下文（用于嵌套闭包命名）
    _pushClosureContext(envClassName);

    String bodyStr;
    if (func.body is ReturnStatement) {
      final ret = func.body as ReturnStatement;
      if (ret.expression != null) {
        bodyStr = ' {\n  return ${_restoreExpr(ret.expression!)};\n}\n';
      } else {
        bodyStr = ' {}\n';
      }
    } else if (func.body != null) {
      final oldBuf = _buf;
      final tmpBuf = StringBuffer();
      _buf = tmpBuf;
      _restoreStmt(func.body!);
      _buf = oldBuf;
      bodyStr = ' $tmpBuf';
    } else {
      bodyStr = ' {}\n';
    }

    _popClosureContext();

    // 恢复 env 映射
    _capturedVarEnvPrefix.clear();
    _capturedVarEnvPrefix.addAll(savedEnvPrefix);
    _thisIsCapturedInEnv = savedThisInEnv;

    // ---- 生成 ClosureEnv 类定义 ----
    final declBuf = StringBuffer();

    // class ClosureEnv_xxx<T> {
    declBuf.write('class $envClassName$typeParamStr {\n');

    // 字段
    for (final field in capturedFields) {
      declBuf.write('  ${field.typeStr} ${field.name};\n');
    }

    // 构造函数
    final ctorParams = capturedFields.map((f) => 'this.${f.name}').join(', ');
    declBuf.write('  $envClassName($ctorParams);\n');

    // call 方法 → 转发到静态函数
    final staticCallName = '${envClassName}_call';
    final forwardArgs = callArgStr.isEmpty ? 'this' : 'this, $callArgStr';
    declBuf.write('  $returnType call($callParamStr) => $staticCallName$typeParamStr($forwardArgs);\n');

    declBuf.write('}\n');

    // ---- 生成静态 call 函数 ----
    final envClassWithTypeParams = '$envClassName$typeParamStr';
    final staticParams = callParamStr.isEmpty
        ? '$envClassWithTypeParams env'
        : '$envClassWithTypeParams env, $callParamStr';

    // async marker
    final marker = func.asyncMarker;
    String asyncStr = '';
    if (marker == AsyncMarker.Async) asyncStr = ' async';
    if (marker == AsyncMarker.AsyncStar) asyncStr = ' async*';
    if (marker == AsyncMarker.SyncStar) asyncStr = ' sync*';

    declBuf.write('$returnType $staticCallName$typeParamStr($staticParams)$asyncStr$bodyStr\n');

    // 将闭包声明添加到待输出列表
    _pendingClosureDecls.add(declBuf.toString());

    // ---- 返回构造表达式 ----
    // 使用处: ClosureEnv_foo_0(captured1, captured2, ...)
    // 构造参数：如果当前已在外层闭包的 env 上下文中，
    // 被捕获变量需要加 env. 前缀
    final constructArgsList = <String>[];
    for (int _i = 0; _i < capturedFields.length; _i++) {
      final field = capturedFields[_i];
      if (field.isThis) {
        // this 捕获：检查是否在外层 env 中
        if (savedThisInEnv) {
          constructArgsList.add('env.${field.name}');
        } else {
          constructArgsList.add(field.name);
        }
      } else if (_i < capturedDecls.length + (capturesThis && _insideMethodBody && _currentClass != null && _needsLowering(_currentClass!.name) ? 1 : 0)) {
        // 对应的 VariableDeclaration 在 savedEnvPrefix 中有映射则加前缀
        final declIdx = field.isThis ? -1 : _i - (capturedFields.any((f) => f.isThis) ? 1 : 0);
        if (declIdx >= 0 && declIdx < capturedDecls.length) {
          final prefix = savedEnvPrefix[capturedDecls[declIdx]];
          if (prefix != null) {
            constructArgsList.add('$prefix${field.name}');
          } else {
            constructArgsList.add(field.name);
          }
        } else {
          constructArgsList.add(field.name);
        }
      } else {
        constructArgsList.add(field.name);
      }
    }
    final constructArgs = constructArgsList.join(', ');
    return '$envClassName($constructArgs)';
  }

  /// 递归收集 DartType 中引用的所有 TypeParameter
  void _collectTypeParameters(DartType type, Set<TypeParameter> result) {
    if (type is TypeParameterType) {
      result.add(type.parameter);
    } else if (type is InterfaceType) {
      for (final arg in type.typeArguments) {
        _collectTypeParameters(arg, result);
      }
    } else if (type is FunctionType) {
      _collectTypeParameters(type.returnType, result);
      for (final p in type.positionalParameters) {
        _collectTypeParameters(p, result);
      }
      for (final n in type.namedParameters) {
        _collectTypeParameters(n.type, result);
      }
    } else if (type is FutureOrType) {
      _collectTypeParameters(type.typeArgument, result);
    } else if (type is RecordType) {
      for (final p in type.positional) {
        _collectTypeParameters(p, result);
      }
      for (final n in type.named) {
        _collectTypeParameters(n.type, result);
      }
    }
  }

  /// 从表达式中提取对指定变量的成员访问
  /// 例如：InstanceGet(VariableGet(v), 'length') → 'length'
  /// 例如：InstanceInvocation(VariableGet(v), 'toUpperCase', []) → 'toUpperCase()'
  String? _extractMemberAccessOnVar(Expression expr, VariableDeclaration targetVar) {
    if (expr is InstanceGet) {
      if (expr.receiver is VariableGet && (expr.receiver as VariableGet).variable == targetVar) {
        return expr.name.text;
      }
    }
    if (expr is InstanceInvocation) {
      if (expr.receiver is VariableGet && (expr.receiver as VariableGet).variable == targetVar) {
        final args = _restoreArgs(expr.arguments);
        return '${expr.name.text}($args)';
      }
    }
    if (expr is InstanceSet) {
      if (expr.receiver is VariableGet && (expr.receiver as VariableGet).variable == targetVar) {
        return '${expr.name.text} = ${_restoreExpr(expr.value)}';
      }
    }
    // AsExpression 包裹的情况（类型转换）
    if (expr is AsExpression) {
      return _extractMemberAccessOnVar(expr.operand, targetVar);
    }
    return null;
  }

  /// 检查 null-safe 访问的 receiver 变量的基础类型是否是用户自定义类
  /// 如果是，?. 后的成员访问需要 OOP lowering，不能简化为 lhs?.member
  bool _nullSafeReceiverNeedsLowering(VariableDeclaration v) {
    final varType = v.type;
    if (varType is InterfaceType) {
      final className = varType.classNode.name;
      if (_isUserClass(className) || _isMixinName(className) || _isEnumName(className)) {
        return true;
      }
    }
    return false;
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
