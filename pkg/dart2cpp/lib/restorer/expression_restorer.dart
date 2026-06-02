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
          // DynamicSet 没有 interfaceTarget，使用 TypeFunction2<void, dynamic, dynamic> 签名
          return "($recv.vptr['set_$fieldName'] as TypeFunction2<void, dynamic, dynamic>)($recv, $value)";
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
          // 显式传递泛型类型参数（this_ 为 dynamic 后编译器无法推断）
          // 优先使用 expr.arguments.types，否则从当前类的类型参数获取
          final typeArgs = expr.arguments.types;
          String typeArgStr;
          if (typeArgs.isNotEmpty) {
            typeArgStr = '<${typeArgs.map((t) => _restoreType(t)).join(', ')}>';
          } else if (_currentClass!.typeParameters.isNotEmpty) {
            typeArgStr = '<${_currentClass!.typeParameters.map((tp) => tp.name ?? 'T').join(', ')}>';
          } else {
            typeArgStr = '';
          }
          if (args.isEmpty) {
            return '$staticName$typeArgStr($selfArg)';
          }
          return '$staticName$typeArgStr($selfArg, $args)';
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
        final target = expr.interfaceTarget;
        if (target is Procedure) {
          final sig = _buildPreciseFuncSignature(target,
              receiverClassName: receiverClassName, receiver: expr.receiver);
          // Lowered ABI：named 全部铺平为 positional，缺省值由调用方补齐
          final args =
              _restoreFlattenedArgs(target.function, expr.arguments);
          if (args.isEmpty) {
            return "($recv.vptr['$methodName'] as $sig)($recv)";
          }
          return "($recv.vptr['$methodName'] as $sig)($recv, $args)";
        }
        // fallback: 非 Procedure 类型的 target
        final args = _restoreArgs(expr.arguments);
        if (args.isEmpty) {
          return "$recv.$methodName()";
        }
        return "$recv.$methodName($args)";
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
    if (expr is AwaitExpression) return 'smAwait(${_restoreExpr(expr.operand)})';
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
    // Bug 11: Box 化访问——被 Box 化的变量读取时追加 .value
    final boxed = _boxedVars.contains(expr.variable);
    final suffix = boxed ? '.value' : '';
    if (prefix != null) return '$prefix$name$suffix';
    return '$name$suffix';
  }

  String _restoreVarSet(VariableSet expr) {
    if (expr.variable.name == null) {
      expr.variable.name = '_v${_varCounter++}';
    }
    final name = _cleanVarName(expr.variable.name!);
    // 闭包 lowering: 如果变量被捕获到 env 中，加 env. 前缀
    final prefix = _capturedVarEnvPrefix[expr.variable];
    // Bug 11: Box 化访问——被 Box 化的变量写入时目标为 .value
    final boxed = _boxedVars.contains(expr.variable);
    final suffix = boxed ? '.value' : '';
    final base = prefix != null ? '$prefix$name' : name;
    return '$base$suffix = ${_restoreExpr(expr.value)}';
  }

  String _restoreInstanceGet(InstanceGet expr) {
    final recv = _restoreExpr(expr.receiver);
    final fieldName = expr.name.text;

    final receiverClassName = _getReceiverClassNameFromReceiver(expr.receiver, expr.interfaceTarget);

    // Bug 16: 私有字段/getter 不在 vtable 中
    // _collectVTableEntries（dart_restorer.dart:867）跳过 name.startsWith('_') 的 procedure，
    // 因此私有字段对应的 get_xxx 条目不存在于 vptr。
    // Dart Kernel 对 final field 会合成隐式 getter Procedure，使得 target.isGetter=true，
    // 导致私有 final 字段被错误路由到 vtable getter 路径，运行时返回 null 导致 cast 失败。
    // 修复：私有字段/getter 直接字段访问，绕过 vtable。
    // 对称场景见 _restoreInstanceSet（私有 setter）和 _restoreInstanceInvocation（Bug 14 私有方法）。
    if (fieldName.startsWith('_')) {
      return '$recv.$fieldName';
    }

    // 用户自定义类或 mixin 的 getter 调用 → 通过 Map 查找类型转换
    if (receiverClassName != null && (_isUserClass(receiverClassName) || _isMixinName(receiverClassName))) {
      final target = expr.interfaceTarget;
      if (target is Procedure && target.isGetter) {
        // 方法定义在非用户类基类中 → 直接属性访问
        final declClass = target.enclosingClass;
        final declClassName = declClass != null ? _getActualClassName(declClass.name) : null;
        if (declClassName != null && !_isUserClass(declClassName) && !_isMixinName(declClassName)) {
          return '$recv.$fieldName';
        }
        // 使用 expr.resultType 获取调用处已具体化的返回类型（避免泛型 T 未替换问题）
        final returnType = _restoreTypeForSignature(expr.resultType);
        final sig = _emitFuncSig(returnType, [_thisParamType]);
        return "($recv.vptr['get_$fieldName'] as $sig)($recv)";
      }
    }

    // enum getter 调用 → 静态函数: EnumName_get_field(recv)
    if (receiverClassName != null && _isEnumName(receiverClassName)) {
      final target = expr.interfaceTarget;
      if (target is Procedure && target.isGetter) {
        // SDK 内置枚举属性（name, index, hashCode）直接用属性访问，不生成静态函数
        // 这些属性来自 Dart SDK 的 Enum/_Enum/_EnumName 等类
        final declClassName = target.enclosingClass?.name ?? '';
        if (fieldName == 'name' || fieldName == 'index' || fieldName == 'hashCode'
            || declClassName == '_Enum' || declClassName == 'Enum'
            || declClassName == '_EnumName' || declClassName == 'EnumName') {
          return '$recv.$fieldName';
        }
        return '${receiverClassName}_get_$fieldName($recv)';
      }
    }

    return '$recv.$fieldName';
  }

  String _restoreInstanceSet(InstanceSet expr) {
    final recv = _restoreExpr(expr.receiver);
    final fieldName = expr.name.text;

    final receiverClassName = _getReceiverClassNameFromReceiver(expr.receiver, expr.interfaceTarget);

    // Bug 16（对称）：私有字段的 setter 不在 vtable 中，直接字段赋值
    // 见 _restoreInstanceGet 中的详细说明
    if (fieldName.startsWith('_')) {
      return '$recv.$fieldName = ${_restoreExpr(expr.value)}';
    }

    // 用户自定义类或 mixin 的 setter 调用 → 通过 Map 查找类型转换
    // 与 _restoreInstanceGet/_restoreInstanceInvocation 的条件保持一致
    if (receiverClassName != null && (_isUserClass(receiverClassName) || _isMixinName(receiverClassName))) {
      final target = expr.interfaceTarget;
      if (target is Procedure && target.isSetter) {
        // this_ 统一为 dynamic，精确签名始终安全
        final sig = _buildPreciseFuncSignature(target, receiverClassName: receiverClassName, receiver: expr.receiver);
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

      // 方法定义在非用户类基类中（如 AsyncStateMachine.completeWith）→ 直接调用，不走 vptr
      if (actualClassName != null && !_isUserClass(actualClassName) && !_isMixinName(actualClassName)) {
        final args = _restoreArgs(expr.arguments);
        if (args.isEmpty) return '$recv.$name()';
        return '$recv.$name($args)';
      }

      // Bug 14: 私有实例方法（name 以 _ 开头）不在 vtable 中
      // _collectVTableEntries（dart_restorer.dart）跳过 startsWith('_') 的方法，
      // 不会注册到 vptr。但实例方法的静态函数（_emitInstanceMethodAsStatic）
      // 仍然为所有方法生成。因此私有方法必须直接调用静态函数，绕过 vptr。
      // 限制：运算符不能私有，不需要处理；abstract 方法没有 body，但私有 abstract 极少见。
      if (name.startsWith('_') && !_isBinaryOp(name) && name != 'unary-' && name != '~' && name != '[]' && name != '[]=') {
        // 解析声明类：合成中间类需要找到真正的用户类
        var resolvedClassName = actualClassName ?? receiverClassName;
        if (_syntheticLoweredNames.contains(resolvedClassName)) {
          resolvedClassName = _findUserClassForSynthetic(resolvedClassName);
        }
        final staticFuncName = '${resolvedClassName}_$name';

        // 构建类型参数：类的类型参数 + 方法的类型参数
        final allTypeArgs = <String>[];
        final receiverClassTypeArgs = _extractClassTypeArgsFromReceiver(expr.receiver);
        allTypeArgs.addAll(receiverClassTypeArgs);
        for (final ta in expr.arguments.types) {
          allTypeArgs.add(_restoreType(ta));
        }
        final typeArgStr = allTypeArgs.isNotEmpty ? '<${allTypeArgs.join(', ')}>' : '';

        // 构建参数列表：补齐可选参数默认值（静态函数签名固定）
        final tFunc = expr.interfaceTarget.function;
        final argParts = <String>[];
        for (var i = 0; i < expr.arguments.positional.length; i++) {
          argParts.add(_restoreExpr(expr.arguments.positional[i]));
        }
        for (var i = expr.arguments.positional.length; i < tFunc.positionalParameters.length; i++) {
          final p = tFunc.positionalParameters[i];
          if (p.initializer != null) {
            argParts.add(_restoreExpr(p.initializer!));
          } else {
            argParts.add(_defaultValueForType(p.type));
          }
        }
        for (final n in expr.arguments.named) {
          argParts.add('${n.name}: ${_restoreExpr(n.value)}');
        }
        final argsStr = argParts.join(', ');
        if (argsStr.isEmpty) {
          return '$staticFuncName$typeArgStr($recv)';
        }
        return '$staticFuncName$typeArgStr($recv, $argsStr)';
      }

      // this_ 类型：声明侧统一为 dynamic，调用侧签名直接使用 dynamic
      final thisType = _thisParamType;

      // 二元运算符 → Map 查找精确类型转换调用
      if (_isBinaryOp(name) && expr.arguments.positional.length == 1) {
        final right = _restoreExpr(expr.arguments.positional[0]);
        final rightType = _restoreTypeForSignature(expr.functionType.positionalParameters[0]);
        final sig = _emitFuncSig(returnType, [thisType, rightType]);
        final vtableField = 'operator${_operatorFuncName(name)}';
        return "($recv.vptr['$vtableField'] as $sig)($recv, $right)";
      }
      // 一元运算符
      if (name == 'unary-') {
        final sig = _emitFuncSig(returnType, [thisType]);
        return "($recv.vptr['operatorNeg'] as $sig)($recv)";
      }
      if (name == '~') {
        final sig = _emitFuncSig(returnType, [thisType]);
        return "($recv.vptr['operatorBitNot'] as $sig)($recv)";
      }
      if (name == '[]') {
        final idx = _restoreExpr(expr.arguments.positional[0]);
        final idxType = _restoreTypeForSignature(expr.functionType.positionalParameters[0]);
        final sig = _emitFuncSig(returnType, [thisType, idxType]);
        return "($recv.vptr['operatorIndex'] as $sig)($recv, $idx)";
      }
      if (name == '[]=') {
        final idx = _restoreExpr(expr.arguments.positional[0]);
        final val = _restoreExpr(expr.arguments.positional[1]);
        final idxType = _restoreTypeForSignature(expr.functionType.positionalParameters[0]);
        final valType = expr.functionType.positionalParameters.length > 1
            ? _restoreTypeForSignature(expr.functionType.positionalParameters[1])
            : 'dynamic';
        final sig = _emitFuncSig(returnType, [thisType, idxType, valType]);
        return "($recv.vptr['operatorIndexSet'] as $sig)($recv, $idx, $val)";
      }
      // 普通方法 → Map 查找精确类型转换调用
      final vtableField = _vtableFieldName(name);
      final allArgs = _restoreArgs(expr.arguments);

      // Lowered ABI：positional 缺省值 + named 全部按声明顺序铺平为 positional，
      // 调用方负责补齐缺省值。
      String _buildArgsWithDefaults() {
        return _restoreFlattenedArgs(
            expr.interfaceTarget.function, expr.arguments);
      }

      // 检查方法是否有方法级类型参数（如 fold<T>、mapRight<R2>）
      // 如果有，通过 vptr 特化名调用：'methodName_TypeSuffix'
      // 注意：必须在命名参数检查之前，因为带命名参数的方法级泛型方法也走特化路径
      final hasMethodTypeParams = expr.interfaceTarget.function.typeParameters.isNotEmpty;
      if (hasMethodTypeParams) {
        final enclosingClass = expr.interfaceTarget.enclosingClass;
        final classTpNames = enclosingClass != null
            ? enclosingClass.typeParameters.map((tp) => tp.name).toSet()
            : <String?>{};
        final dedupedMethodTps = expr.interfaceTarget.function.typeParameters
            .where((tp) => !classTpNames.contains(tp.name))
            .toList();

        // 只有去重后仍有方法级泛型参数，且类型实参全部为具体类型（非 TypeParameterType）时，
        // 才走 vptr 特化调用。如果类型实参包含类型参数（泛型上下文中的调用，如递归），
        // 则回退到直接静态函数调用。
        final hasConcreteTypeArgs = dedupedMethodTps.isNotEmpty &&
            expr.arguments.types.isNotEmpty &&
            !expr.arguments.types.any((ta) => _containsTypeParameter(ta));
        if (hasConcreteTypeArgs) {
          // 生成特化后缀（与预扫描阶段 _typeToSpecSuffix 一致）
          final typeSuffix = expr.arguments.types.map((ta) => _typeToSpecSuffix(ta)).join('_');
          final baseKey = _isBinaryOp(name) ? 'operator${_operatorFuncName(name)}'
              : name == 'unary-' ? 'operatorNeg'
              : name == '~' ? 'operatorBitwiseNot'
              : name == '[]' ? 'operatorIndex'
              : name == '[]=' ? 'operatorIndexSet'
              : _vtableFieldName(name);
          final specKey = '${baseKey}_$typeSuffix';
          final args = _buildArgsWithDefaults();

          // this_ 统一为 dynamic，逆变问题已消除，统一使用精确签名
          final specReturnType = _restoreTypeForSignature(expr.functionType.returnType);
          final specSigParams = <String>[thisType];
          final targetFunc = expr.interfaceTarget.function;
          for (var i = 0; i < targetFunc.positionalParameters.length; i++) {
            if (i < expr.functionType.positionalParameters.length) {
              specSigParams.add(_restoreTypeForSignature(expr.functionType.positionalParameters[i]));
            } else {
              specSigParams.add(_restoreTypeForSignature(targetFunc.positionalParameters[i].type));
            }
          }
          // Lowered ABI：named 已铺平到 positional，按 **target 的声明顺序**
          // 取，不能用 expr.functionType.namedParameters 因为后者是 kernel 在
          // call-site 处的视角顺序，与 target 声明顺序可能不一致。
          // 类型仍要走 functionType（含具体化后的 R/T 实参），因此按名字索引
          // 到 functionType.namedParameters 的对应类型。
          final ftNamedByName = <String, DartType>{
            for (final np in expr.functionType.namedParameters)
              np.name: np.type,
          };
          final specNamedTypes = <String>[
            for (final np in targetFunc.namedParameters)
              _restoreTypeForSignature(ftNamedByName[np.name] ?? np.type),
          ];
          final specSig = _emitFuncSig(specReturnType, specSigParams,
              namedTypes: specNamedTypes);

          if (args.isEmpty) {
            return "($recv.vptr['$specKey'] as $specSig)($recv)";
          }
          return "($recv.vptr['$specKey'] as $specSig)($recv, $args)";
        }

        // 去重后无方法级泛型（如 Triple.mapFirst<C> 中 C 与类泛型同名）
        // 或者无类型实参：回退到直接静态函数调用
        var resolvedClassName = actualClassName ?? receiverClassName;
        if (_syntheticLoweredNames.contains(resolvedClassName)) {
          resolvedClassName = _findUserClassForSynthetic(resolvedClassName);
        }
        final staticFuncName = '${resolvedClassName}_$name';
        final allTypeArgs = <String>[];
        final receiverClassTypeArgs = _extractClassTypeArgsFromReceiver(expr.receiver);
        allTypeArgs.addAll(receiverClassTypeArgs);
        for (final ta in expr.arguments.types) {
          allTypeArgs.add(_restoreType(ta));
        }
        final typeArgStr = allTypeArgs.isNotEmpty ? '<${allTypeArgs.join(', ')}>' : '';
        if (allArgs.isEmpty) {
          return '$staticFuncName$typeArgStr($recv)';
        }
        return '$staticFuncName$typeArgStr($recv, $allArgs)';
      }

      // this_ 统一为 dynamic，逆变问题已消除，统一使用精确签名
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
      // Lowered ABI：named 已铺平到 positional，这里只把类型透传给 sig
      // builder，由它接到 positional 列表末尾。
      final namedTypes = <String>[
        for (final np in expr.functionType.namedParameters)
          _restoreTypeForSignature(np.type),
      ];
      final sig =
          _emitFuncSig(returnType, sigParamTypes, namedTypes: namedTypes);

      // Lowered ABI：positional 缺省值 + named 都按声明顺序铺平为 positional，
      // 调用方补默认值。
      final fullArgs = _restoreFlattenedArgs(targetFunc, expr.arguments);
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
      final allArgs = _restoreFlattenedArgs(target.function, expr.arguments);
      if (allArgs.isEmpty) {
        return "($recv.vptr['$vtableField'] as $sig)($recv)";
      }
      return "($recv.vptr['$vtableField'] as $sig)($recv, $allArgs)";
    }

    // 静态集合: 拦截集合类返回 List/Set 的方法，包装为 StaticList/StaticSet
    if (receiverClassName != null && _isCollectionClass(receiverClassName)) {
      if (name == 'toList') {
        return 'StaticList.of($recv.$name())';
      }
      if (name == 'toSet') {
        return 'StaticSet.of($recv.$name().toList())';
      }
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
  ///
  /// Lowered ABI：named 已铺平为 positional，没有可选参数。这里直接把
  /// proc.function 的全部参数（this_ + positional + named）按顺序当成
  /// positional 传给 [_emitFuncSig]。
  String _buildPreciseFuncSignature(Procedure proc, {String? receiverClassName, Expression? receiver}) {
    final returnType = _restoreTypeForSignature(proc.function.returnType);
    final paramTypes = <String>[_thisParamType];
    for (final param in proc.function.positionalParameters) {
      paramTypes.add(_restoreTypeForSignature(param.type));
    }
    final namedTypes = <String>[
      for (final np in proc.function.namedParameters)
        _restoreTypeForSignature(np.type),
    ];
    return _emitFuncSig(returnType, paramTypes, namedTypes: namedTypes);
  }

  /// this_ 参数统一为 dynamic（声明侧和调用侧一致，消除 as Function 转换）
  static const String _thisParamType = 'dynamic';

  /// 将函数签名构造为 `TypeFunctionN<R, T1..Tn>` 字符串，用于 vptr 槽位的
  /// 静态类型 cast。
  ///
  /// Lowered ABI：所有原 named 参数都已铺平为 positional，没有可选参数，
  /// 默认值由调用点补齐。`namedTypes` 应是**纯类型字符串**，会顺次接到
  /// positional 列表末尾；`required` 关键字与参数名都不属于函数类型。
  /// 仅当 arity 超过 [_TypeUtils.kMaxArity] 时，兜底成 `dynamic`。
  String _emitFuncSig(String returnType, List<String> positional,
      {List<String> namedTypes = const []}) {
    final all = [...positional, ...namedTypes];
    if (all.length > _TypeUtils.kMaxArity) {
      return 'dynamic';
    }
    final arity = all.length;
    final args = [returnType, ...all].join(', ');
    return 'TypeFunction$arity<$args>';
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
      // 优先使用 promotedType（type promotion 后的类型）
      // 例如：if (other is WeightedScore) { other.weightedPoints; } 中
      //   other 的声明类型是 Score，但 promotedType 是 WeightedScore
      //   调用 weightedPoints 时必须使用 WeightedScore 的 vtable
      final varType = receiver.promotedType ?? receiver.variable.type;
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
    // NullCheck：如 this_.left! → 递归提取 operand 的类型参数
    if (receiver is NullCheck) {
      return _extractClassTypeArgsFromReceiver(receiver.operand);
    }
    // InstanceGet：如 this_.left → 从属性访问的结果类型中提取
    if (receiver is InstanceGet) {
      final resultType = receiver.resultType;
      if (resultType is InterfaceType && resultType.typeArguments.isNotEmpty) {
        return resultType.typeArguments.map((ta) => _restoreType(ta)).toList();
      }
      // 对于 nullable 类型（如 TreeNodeValue<T>?），unwrap nullable
      if (resultType is NullType) return [];
    }
    // AsExpression：如 (x as SomeType) → 递归提取
    if (receiver is AsExpression) {
      final castType = receiver.type;
      if (castType is InterfaceType && castType.typeArguments.isNotEmpty) {
        return castType.typeArguments.map((ta) => _restoreType(ta)).toList();
      }
      return _extractClassTypeArgsFromReceiver(receiver.operand);
    }
    // 尝试从 Let 表达式的 body 中提取
    if (receiver is Let) {
      return _extractClassTypeArgsFromReceiver(receiver.body);
    }
    // 尝试从 BlockExpression 的 value 中提取
    if (receiver is BlockExpression) {
      return _extractClassTypeArgsFromReceiver(receiver.value);
    }
    // ThisExpression：从当前类的类型参数提取
    if (receiver is ThisExpression && _currentClass != null) {
      final tps = _currentClass!.typeParameters;
      if (tps.isNotEmpty) {
        return tps.map((tp) => tp.name ?? 'dynamic').toList();
      }
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
    // 处理下标操作符 []
    if (name == '[]') {
      final idx = _restoreExpr(expr.arguments.positional[0]);
      return '$recv[$idx]';
    }
    // 处理下标赋值操作符 []=
    if (name == '[]=') {
      final idx = _restoreExpr(expr.arguments.positional[0]);
      final val = _restoreExpr(expr.arguments.positional[1]);
      return '$recv[$idx] = $val';
    }
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

    // 静态集合: _GrowableList → StaticList
    // 只在这里处理 *字面量*（_literal* 系列，没有真实命名构造的入口）和
    // 真正的空构造（name 为空）。其它带名 factory（generate / filled / of /
    // from / unmodifiable …）必须落到下面 `target.isFactory` 分支统一处理，
    // 否则参数和构造名都会被丢掉（曾导致 `List.generate(rows, gen)` 被还原
    // 成 `StaticList<T>()` 这种空表）。
    if (target.enclosingClass != null && target.enclosingClass!.name == '_GrowableList') {
      final typeArgs = expr.arguments.types;
      final typeArgStr = typeArgs.isNotEmpty ? '<${typeArgs.map((t) => _restoreType(t)).join(', ')}>' : '';
      if (name.startsWith('_literal')) {
        final items = expr.arguments.positional.map((e) => _restoreExpr(e)).join(', ');
        return 'StaticList$typeArgStr.of([$items])';
      }
      if (name.isEmpty) {
        return 'StaticList$typeArgStr()';
      }
      // fallthrough to factory handler
    }

    // 静态集合: Set 内部实现类 → StaticSet
    if (target.enclosingClass != null && _isSetInternalClass(target.enclosingClass!.name)) {
      final typeArgs = expr.arguments.types;
      final typeArgStr = typeArgs.isNotEmpty ? '<${typeArgs.map((t) => _restoreType(t)).join(', ')}>' : '';
      if (name == 'from' || name == 'of') return 'StaticSet$typeArgStr.of($args)';
      if (name.isEmpty || name == '_default') return 'StaticSet$typeArgStr()';
      return 'StaticSet$typeArgStr.$name($args)';
    }

    // 静态集合: Map 内部实现类（LinkedHashMap 等）→ StaticMap
    if (target.enclosingClass != null && _isMapInternalClass(target.enclosingClass!.name)) {
      final typeArgs = expr.arguments.types;
      final typeArgStr = typeArgs.isNotEmpty ? '<${typeArgs.map((t) => _restoreType(t)).join(', ')}>' : '';
      if (name.isEmpty || name == '_default') return 'StaticMap$typeArgStr()';
      return 'StaticMap$typeArgStr.$name($args)';
    }

    // 扩展方法调用：函数名包含 | 字符（如 "StringExtensions|capitalize"）
    // 需要将函数名清理为合法标识符，并将 receiver 参数（this_）正确传递
    if (_isExtensionMethodName(name)) {
      // Bug 25: SDK 内置枚举扩展（EnumName|get#name）→ 直接属性访问
      // Kernel 将枚举值的 .name getter 编译为 StaticInvocation 调用 EnumName|get#name
      final pipeIdx = name.indexOf('|');
      final extensionName = name.substring(0, pipeIdx);
      final memberPart = name.substring(pipeIdx + 1);
      if ((extensionName == 'EnumName' || extensionName == '_EnumName') &&
          memberPart.startsWith('get#')) {
        final propName = memberPart.substring(4);
        // receiver 是第一个位置参数
        if (expr.arguments.positional.isNotEmpty) {
          final recv = _restoreExpr(expr.arguments.positional.first);
          return '$recv.$propName';
        }
      }
      final cleanedName = _sanitizeExtensionMethodName(name);
      return '$cleanedName($args)';
    }

    // factory 构造函数
    if (target.isFactory && target.enclosingClass != null) {
      final className = target.enclosingClass!.name;

      // 状态机协程替代：Future/_Future 的 factory → Promise
      if (className == 'Future' || className == '_Future') {
        final typeArgs = expr.arguments.types;
        final typeArgStr = typeArgs.isNotEmpty
            ? '<${typeArgs.map((t) => _restoreType(t)).join(', ')}>'
            : '';
        // Future.delayed(Duration, [computation]) → promiseDelayed(duration, [computation])
        if (name == 'delayed') {
          return 'promiseDelayed$typeArgStr($args)';
        }
        if (name.isEmpty) return 'Promise$typeArgStr($args)';
        return 'Promise$typeArgStr.$name($args)';
      }

      // 静态集合: List/Map/Set 的 factory 构造 → StaticList/StaticMap/StaticSet
      if (className == 'List' || className == '_GrowableList' || className == '_List') {
        final typeArgs = expr.arguments.types;
        final typeArgStr = typeArgs.isNotEmpty
            ? '<${typeArgs.map((t) => _restoreType(t)).join(', ')}>'
            : '';
        if (name == 'filled') return 'StaticList$typeArgStr.filled($args)';
        if (name == 'from' || name == 'of') return 'StaticList$typeArgStr.of($args)';
        if (name.isEmpty) return 'StaticList$typeArgStr()';
        return 'StaticList$typeArgStr.$name($args)';
      }
      if (className == 'Map' || _isMapInternalClass(className)) {
        final typeArgs = expr.arguments.types;
        final typeArgStr = typeArgs.isNotEmpty
            ? '<${typeArgs.map((t) => _restoreType(t)).join(', ')}>'
            : '';
        if (name == 'from' || name == 'of') return 'StaticMap$typeArgStr.of($args)';
        if (name.isEmpty || name == '_default') return 'StaticMap$typeArgStr()';
        return 'StaticMap$typeArgStr.$name($args)';
      }
      if (className == 'Set' || _isSetInternalClass(className)) {
        final typeArgs = expr.arguments.types;
        final typeArgStr = typeArgs.isNotEmpty
            ? '<${typeArgs.map((t) => _restoreType(t)).join(', ')}>'
            : '';
        if (name == 'from' || name == 'of') return 'StaticSet$typeArgStr.of($args)';
        if (name.isEmpty) return 'StaticSet$typeArgStr()';
        return 'StaticSet$typeArgStr.$name($args)';
      }

      // OOP Lowering: 用户自定义类的 factory → X_new / X_new_name
      if (_isUserClass(className)) {
        final funcName = name.isEmpty
            ? '${className}_new'
            : '${className}_new_$name';
        // 显式传递泛型类型参数（this_ 为 dynamic 后编译器无法从参数推断）
        final typeArgs = expr.arguments.types;
        final typeArgStr = typeArgs.isNotEmpty
            ? '<${typeArgs.map((t) => _restoreType(t)).join(', ')}>'
            : '';
        return '$funcName$typeArgStr($args)';
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
        // 显式传递泛型类型参数（this_ 为 dynamic 后编译器无法推断）
        final typeArgs = expr.arguments.types;
        final typeArgStr = typeArgs.isNotEmpty
            ? '<${typeArgs.map((t) => _restoreType(t)).join(', ')}>'
            : '';
        return '${className}_$name$typeArgStr($args)';
      }
      return '$className.$name($args)';
    }

    // 顶层函数（包括 mixin lowering 后提升的构造函数和方法）
    // 显式传递泛型类型参数（this_ 为 dynamic 后编译器可能无法从参数推断）
    final typeArgs = expr.arguments.types;
    final typeArgStr = typeArgs.isNotEmpty
        ? '<${typeArgs.map((t) => _restoreType(t)).join(', ')}>'
        : '';
    return '$name$typeArgStr($args)';
  }

  String _restoreStaticGet(StaticGet expr) {
    final target = expr.target;
    if (target.enclosingClass != null) {
      final className = target.enclosingClass!.name;
      final memberName = target.name.text;
      // OOP Lowering: 用户自定义类/mixin 的静态字段/getter → 使用 lowered 名称
      if (_isUserClass(className) || _isMixinName(className)) {
        // 静态字段和静态 getter 都被提升为顶层函数/变量 ClassName_memberName
        // 静态 getter 生成为 ClassName_memberName() 函数
        if (target is Procedure && target.isGetter) {
          return '${className}_$memberName()';
        }
        // 静态字段 → 顶层变量 ClassName_memberName
        return '${className}_$memberName';
      }
      // SDK 扩展类（如 _EnumName）的 getter → 直接在对象上访问
      // 例如 EnumName.name getter → p.name
      if (className == '_EnumName' || className == 'EnumName') {
        return '$memberName'; // 会被上层替换为直接属性访问
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
    
    // 静态集合: _GrowableList → StaticList
    if (className == '_GrowableList') {
      final typeArgs = expr.arguments.types;
      final typeArgStr = typeArgs.isNotEmpty ? '<${typeArgs.map((t) => _restoreType(t)).join(', ')}>' : '';
      if (ctorName.startsWith('_literal')) {
        final items = expr.arguments.positional.map((e) => _restoreExpr(e)).join(', ');
        return 'StaticList$typeArgStr.of([$items])';
      } else if (ctorName.isEmpty) {
        return 'StaticList$typeArgStr()';
      }
    }

    // 静态集合: Set 内部实现类 → StaticSet
    if (_isSetInternalClass(className)) {
      final typeArgs = expr.arguments.types;
      final typeArgStr = typeArgs.isNotEmpty ? '<${typeArgs.map((t) => _restoreType(t)).join(', ')}>' : '';
      return 'StaticSet$typeArgStr()';
    }
    
    final allArgs = _restoreArgs(expr.arguments);

    // OOP Lowering: 用户自定义类的构造调用 → X_new<T>(XValue<T>(), args)
    // X_new 返回 this_，可直接作为表达式使用
    if (_isUserClass(className)) {
      final funcName = ctorName.isEmpty
          ? '${className}_new'
          : '${className}_new_$ctorName';
      // 获取类型参数（如 Pair<String, int>）
      // ConstructorInvocation 中类级泛型参数存储在 arguments.types
      final typeArgs = expr.arguments.types.isNotEmpty
          ? '<${expr.arguments.types.map(_restoreType).join(', ')}>'
          : '';
      final valueType = '${className}Value$typeArgs';
      // 显式传递泛型类型参数（this_ 为 dynamic 后编译器无法从参数推断）
      return allArgs.isEmpty
          ? '$funcName$typeArgs($valueType())'
          : '$funcName$typeArgs($valueType(), $allArgs)';
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

  /// 判断是否是集合类（List/Map/Set 及其内部实现类）
  bool _isCollectionClass(String className) {
    return className == 'List' || className == '_GrowableList' || className == '_List' ||
        className == 'Iterable' || className == '_Iterable' ||
        className == 'Map' || _isMapInternalClass(className) ||
        className == 'Set' || _isSetInternalClass(className);
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
    // 静态集合: ListLiteral → StaticList<T>.of([...])
    if (expr.isConst) {
      return 'StaticList<$typeArg>.of([$items])';
    }
    if (typeArg == 'dynamic') {
      return 'StaticList.of([$items])';
    }
    return 'StaticList<$typeArg>.of([$items])';
  }

  String _restoreMapLiteral(MapLiteral expr) {
    final keyType = _restoreType(expr.keyType);
    final valueType = _restoreType(expr.valueType);
    final entries = expr.entries.map((e) {
      return '${_restoreExpr(e.key)}: ${_restoreExpr(e.value)}';
    }).join(', ');
    // 静态集合: MapLiteral → StaticMap<K, V>.of({...})
    if (keyType == 'dynamic' && valueType == 'dynamic') {
      return 'StaticMap.of({$entries})';
    }
    return 'StaticMap<$keyType, $valueType>.of({$entries})';
  }

  String _restoreSetLiteral(SetLiteral expr) {
    final typeArg = _restoreType(expr.typeArgument);
    final items = expr.expressions.map((e) => _restoreExpr(e)).join(', ');
    // 静态集合: SetLiteral → StaticSet<T>.of([...])
    return 'StaticSet<$typeArg>.of([$items])';
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
    //
    // 例外：kernel 还会把 `expr as L`（L 非空、expr 可空）脱糖成形如
    //   Let(tmp = expr, tmp == null ? (tmp as L) : tmp)
    // 这种形式 fallback 引用了 tmp 自身（其实是用于触发 TypeError）。
    // 若我们仍按 `??` 还原，fallback 会保留 `_letN`，但 `_letN` 永远不
    // 会被声明，从而产生 undefined_identifier。优先识别它并还原成
    // `(expr as L)`。
    if (v.initializer != null) {
      final body = expr.body;
      if (body is ConditionalExpression) {
        final condition = body.condition;
        if (condition is EqualsNull) {
          final condExpr = condition.expression;
          if (condExpr is VariableGet && condExpr.variable == v) {
            // 优先：`expr as L` 的脱糖形式
            final thenBranch = body.then;
            final otherwise = body.otherwise;
            if (thenBranch is AsExpression &&
                thenBranch.operand is VariableGet &&
                (thenBranch.operand as VariableGet).variable == v &&
                otherwise is VariableGet &&
                otherwise.variable == v) {
              final lhs = _restoreExpr(v.initializer!);
              final castType = _restoreType(thenBranch.type);
              return '($lhs as $castType)';
            }
            // 检查 otherwise 分支是否也引用同一个变量（即 tmp != null 时返回 tmp）
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
          // Bug 24: 检查接收者是否是用户自定义类（需要 OOP lowering）
          // 如果是，级联中的方法调用需要转为 vptr 调用而非 .. 语法
          final receiverNeedsLowering = _cascadeReceiverNeedsLowering(v);
          if (receiverNeedsLowering) {
            // 用户类级联 → 转为 IIFE + vptr 调用
            final receiver = _restoreExpr(v.initializer!);
            final tmpName = cleanedName;
            final stmtBuf = StringBuffer();
            for (final stmt in body.body.statements) {
              if (stmt is ExpressionStatement) {
                // 直接还原表达式（_restoreExpr 中 InstanceInvocation 会自动转为 vptr 调用）
                stmtBuf.write('${_restoreExpr(stmt.expression)}; ');
              }
            }
            return '(() { final $tmpName = $receiver; ${stmtBuf}return $tmpName; })()';
          }
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

    // 全部走 ClosureEnv 路径：即使无捕获，也要把闭包包成 `extends TypeFunctionN`
    // 的具名子类实例，否则推断出来仍是 Dart 原生 `Function`。
    return _restoreFuncExprAsClosure(func, capturedDecls, capturesThis);
  }

  /// 原始的 lambda 输出（已被 closure 路径替代，保留以便回滚）。
  // ignore: unused_element
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
    // Bug 11: 被 Box 化的捕获变量，env 字段类型为 Box 类型（而非原类型），
    // 构造时传入外层的 Box 实例（外层变量已是 Box，或参数已被包装为 Box）。
    // 这样多个闭包共享同一个 Box，实现引用语义。
    for (final decl in capturedDecls) {
      final varName = _cleanVarName(decl.name ?? '_cap${_varCounter++}');
      decl.name = varName;
      final isBoxed = _boxedVars.contains(decl);
      final typeStr = isBoxed ? _boxTypeNameFor(decl.type)! : _restoreType(decl.type);
      capturedFields.add(_CapturedVar(
        name: varName,
        typeStr: typeStr,
        isBoxed: isBoxed,
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

    // Bug 11: 对闭包自身做预分析，识别哪些参数/局部变量被更深层嵌套闭包捕获
    // 使得闭包 body 内的 VarDecl/VarGet/VarSet 能正确 Box 化
    _preanalyzeBoxedVarsForFunc(func);

    // 识别被 Box 化的参数（需要在参数名后加 _raw 后缀，并在函数体开头插入 Box 包装）
    final boxedParams = <VariableDeclaration>[];
    for (final p in func.positionalParameters) {
      if (_boxedVars.contains(p)) boxedParams.add(p);
    }
    for (final p in func.namedParameters) {
      if (_boxedVars.contains(p)) boxedParams.add(p);
    }

    // 构建参数列表字符串（用于 call 方法和静态函数）
    // 被 Box 化的参数在外部接口上仍是原类型，参数名加 _raw 后缀
    //
    // Object/dynamic 兼容性：kernel 对闭包参数有时会推断出 `Map<K, Object>` 而上下
    // 文期望 `Map<K, dynamic>`（典型场景：map literal 推断成 `Map<String, Object>`
    // 然后做为 sort 的比较函数参数）。对闭包参数侧把容器类型实参中的 `Object`
    // 归一为 `dynamic`，可让 `TypeFunctionN`/`call`/静态函数三处签名保持自洽，
    // 也能匹配调用点的期望签名。Static 集合 + 用户类型 + 基础类型均不受影响。
    final callParams = <String>[];
    for (final p in func.positionalParameters) {
      final baseName = p.name!;
      final pName = _boxedVars.contains(p) ? '${baseName}_raw' : baseName;
      callParams.add('${_restoreClosureParamType(p.type)} $pName');
    }
    for (final p in func.namedParameters) {
      final baseName = p.name!;
      final pName = _boxedVars.contains(p) ? '${baseName}_raw' : baseName;
      callParams.add('${_restoreClosureParamType(p.type)} $pName');
    }
    final callParamStr = callParams.join(', ');

    // 参数名列表（用于转发调用 call → staticFunc）：
    // 转发时直接透传原始参数（_raw 名对应外部接口的传入值），让静态函数内部自己包装 Box
    final callArgNames = <String>[];
    for (final p in func.positionalParameters) {
      final baseName = p.name!;
      final argName = _boxedVars.contains(p) ? '${baseName}_raw' : baseName;
      callArgNames.add(argName);
    }
    for (final p in func.namedParameters) {
      final baseName = p.name!;
      final argName = _boxedVars.contains(p) ? '${baseName}_raw' : baseName;
      callArgNames.add(argName);
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

    // 泛型参数串：
    // - typeParamNameStr：仅名称（`<T>`），用于类型引用 / 实例化 / 转发调用。
    // - typeParamDeclStr：带 `extends Bound`（`<T extends num>`），用于
    //   闭包类与静态 _call 函数的声明位。若 bound 是 Object/Object?/dynamic，
    //   保持仅名称形式（与 _writeTypeParams 一致）。
    //   修复点：之前两处都只写名称，导致 `extends Iterable<num>` 这种带约束的
    //   闭包（如 IterableStats.sum/max/min）丢失 `T extends num` 约束，闭包体
    //   `(a + b)` / `a > b` 因 T 可空而报 unchecked_use_of_nullable_value。
    final typeParamNameStr = typeParams.isEmpty
        ? ''
        : '<${typeParams.map((tp) => tp.name ?? 'T').join(', ')}>';
    final typeParamDeclStr = typeParams.isEmpty
        ? ''
        : '<${typeParams.map(_formatTypeParamDecl).join(', ')}>';
    // 兼容旧变量名（其余引用仍用 typeParamStr 时也指仅名称形式）
    final typeParamStr = typeParamNameStr;

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

    // Bug 11: 在生成闭包 body 之前，切换当前函数参数作用域（用于 _isParameter 判定）
    final savedCurrentParams = Set<VariableDeclaration>.from(_currentFunctionParams);
    _currentFunctionParams.clear();
    _currentFunctionParams.addAll(func.positionalParameters);
    _currentFunctionParams.addAll(func.namedParameters);

    // Bug 11: 生成参数 Box 包装语句（插入到闭包 body 最开头）
    // 形式：`BoxType x = BoxType(x_raw);`
    final paramBoxInitLines = <String>[];
    for (final p in boxedParams) {
      final baseName = p.name!;
      final boxType = _boxTypeNameFor(p.type)!;
      paramBoxInitLines.add('  $boxType $baseName = $boxType(${baseName}_raw);\n');
    }

    String bodyStr;
    if (func.body is ReturnStatement && paramBoxInitLines.isEmpty) {
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
      // 若有参数 Box 包装，先写入包装语句；再还原 body
      if (paramBoxInitLines.isNotEmpty) {
        tmpBuf.write('{\n');
        for (final line in paramBoxInitLines) {
          tmpBuf.write(line);
        }
        // body 若本身是 Block，则继续使用其内容但去掉外层大括号
        if (func.body is Block) {
          final oldIndent = _indent;
          _indent = 1;
          for (final s in (func.body as Block).statements) {
            _restoreStmt(s);
          }
          _indent = oldIndent;
        } else if (func.body is ReturnStatement) {
          final ret = func.body as ReturnStatement;
          if (ret.expression != null) {
            tmpBuf.write('  return ${_restoreExpr(ret.expression!)};\n');
          }
        } else {
          _restoreStmt(func.body!);
        }
        tmpBuf.write('}\n');
      } else {
        _restoreStmt(func.body!);
      }
      _buf = oldBuf;
      bodyStr = ' $tmpBuf';
    } else {
      bodyStr = ' {}\n';
    }

    // 恢复 _currentFunctionParams
    _currentFunctionParams.clear();
    _currentFunctionParams.addAll(savedCurrentParams);

    _popClosureContext();

    // 恢复 env 映射
    _capturedVarEnvPrefix.clear();
    _capturedVarEnvPrefix.addAll(savedEnvPrefix);
    _thisIsCapturedInEnv = savedThisInEnv;

    // ---- 生成 ClosureEnv 类定义 ----
    // ClosureEnv 现在是 TypeFunctionN 的具名子类：值本身就是 callable class
    // 实例，不再需要 `.call` tear-off 把它适配成 Function。
    final declBuf = StringBuffer();

    // 选择 base：无命名参数且 arity ≤ 上限 → TypeFunctionN<R, T1..Tn>
    // 否则 → TypeFunction<R> 基类（仍由本类自带的 call 方法提供 callable 语义）
    final positionalParamTypes = <String>[
      for (final p in func.positionalParameters) _restoreClosureParamType(p.type),
    ];
    final hasNamedParam = func.namedParameters.isNotEmpty;
    String baseClause;
    bool callIsOverride;
    if (!hasNamedParam &&
        positionalParamTypes.length <= _TypeUtils.kMaxArity) {
      final arity = positionalParamTypes.length;
      final args = [returnType, ...positionalParamTypes].join(', ');
      baseClause = ' extends TypeFunction$arity<$args>';
      callIsOverride = true;
    } else {
      baseClause = ' extends TypeFunction<$returnType>';
      callIsOverride = false;
    }

    // class ClosureEnv_xxx<T extends Bound> extends TypeFunctionN<...> {
    declBuf.write('class $envClassName$typeParamDeclStr$baseClause {\n');

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
    if (callIsOverride) {
      declBuf.write('  @override\n');
    }
    declBuf.write('  $returnType call($callParamStr) => $staticCallName$typeParamStr($forwardArgs);\n');

    declBuf.write('}\n');

    // ---- 生成静态 call 函数 ----
    final envClassWithTypeParams = '$envClassName$typeParamStr';
    final staticParams = callParamStr.isEmpty
        ? '$envClassWithTypeParams env'
        : '$envClassWithTypeParams env, $callParamStr';

    // async marker: Async 已由状态机替代，不输出；保留 async*/sync*
    final marker = func.asyncMarker;
    String asyncStr = '';
    if (marker == AsyncMarker.AsyncStar) asyncStr = ' async*';
    if (marker == AsyncMarker.SyncStar) asyncStr = ' sync*';

    declBuf.write('$returnType $staticCallName$typeParamDeclStr($staticParams)$asyncStr$bodyStr\n');

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
    // ClosureEnv 是 TypeFunctionN 子类，实例本身就是合法的函数值，
    // 不需要再追加 `.call` 做 tear-off。显式带上 type 实参，让 Dart 把闭包
    // 的类型参数与外层方法的 T 绑定（否则 ClosureEnv<T>() 会被推断为
    // ClosureEnv<dynamic>，导致传给 reduce/sort 等期望 `T Function(T, T)`
    // 的位置发生类型不兼容）。
    return '$envClassName$typeParamStr($constructArgs)';
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

  /// Bug 24: 判断级联操作的接收者是否是用户自定义类（需要 OOP lowering）
  /// 如果是，级联中的方法调用需要转为 vptr 调用而非 .. 语法
  bool _cascadeReceiverNeedsLowering(VariableDeclaration v) {
    final varType = v.type;
    if (varType is InterfaceType) {
      final rawName = varType.classNode.name;
      // Value 类名去掉 Value 后缀得到实际类名
      if (rawName.endsWith('Value')) {
        final className = rawName.substring(0, rawName.length - 5);
        if (_isUserClass(className) || _isMixinName(className) || _isEnumName(className)) {
          return true;
        }
      }
      final className = _getActualClassName(rawName);
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
