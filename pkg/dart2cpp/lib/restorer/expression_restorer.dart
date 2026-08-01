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
    if (expr is ThisExpression) return _restoreThisExpression();
    if (expr is SuperPropertyGet) return _restoreSuperPropertyGet(expr);
    if (expr is SuperMethodInvocation) return _restoreSuperMethodInvocation(expr);
    if (expr is RecordLiteral) return _restoreRecordLiteral(expr);
    if (expr is RecordIndexGet) return _restoreRecordIndexGet(expr);
    if (expr is RecordNameGet) return _restoreRecordNameGet(expr);
    if (expr is ConstantExpression) return _restoreConstant(expr.constant);
    if (expr is InstanceGetterInvocation) return _restoreInstanceGetterInvocation(expr);
    if (expr is AbstractSuperPropertyGet) return _restoreAbstractSuperPropertyGet(expr);
    if (expr is SuperPropertySet) return _restoreSuperPropertySet(expr);
    if (expr is InvalidExpression) return '/* invalid */';
    if (expr is NullCheck) return '${_restoreExpr(expr.operand)}!';
    if (expr is AwaitExpression) return 'smAwait(${_restoreExpr(expr.operand)})';
    if (expr is CheckLibraryIsLoaded) return 'true';
    if (expr is LoadLibrary) return '${expr.import.name}';
    if (expr is LocalFunctionInvocation) return _restoreLocalFunctionInvocation(expr);
    if (expr is InstanceTearOff) return _restoreInstanceTearOff(expr);
    return '/* unknown: ${expr.runtimeType} */';
  }

  /// 还原 ThisExpression
  String _restoreThisExpression() {
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

  /// 还原 SuperPropertyGet 表达式
  String _restoreSuperPropertyGet(SuperPropertyGet expr) {
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

  /// 还原 SuperMethodInvocation 表达式
  String _restoreSuperMethodInvocation(SuperMethodInvocation expr) {
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

  /// 还原 InstanceGetterInvocation 表达式
  String _restoreInstanceGetterInvocation(InstanceGetterInvocation expr) {
    final recv = _restoreExpr(expr.receiver);
    final methodName = expr.name.text;
    // OOP Lowering: 泛型方法调用 → 通过虚表或静态函数
    final receiverClassName = _getReceiverClassNameFromReceiver(expr.receiver, expr.interfaceTarget);
    if (receiverClassName != null && (_isUserClass(receiverClassName) || _isMixinName(receiverClassName))) {
      final target = expr.interfaceTarget;
      if (target is Procedure) {
        // Lowered ABI：named 全部铺平为 positional，缺省值由调用方补齐
        final args = _restoreFlattenedArgs(target.function, expr.arguments);
        return _emitVptrMethodCall(recv, expr.receiver, methodName, args);
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

  /// 还原 AbstractSuperPropertyGet 表达式
  String _restoreAbstractSuperPropertyGet(AbstractSuperPropertyGet expr) {
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
        final parentEntries = _getVTableEntriesByName(parentName);
        if (parentEntries != null && parentEntries.any((e) => e.name == fieldName && e.kind == 'getter')) {
          return '${parentName}_get_$fieldName($_thisReplacementName)';
        }
      }
      return '$_thisReplacementName.$fieldName';
    }
    return 'super.${expr.name.text}';
  }

  /// 还原 SuperPropertySet 表达式
  String _restoreSuperPropertySet(SuperPropertySet expr) {
    // OOP Lowering: super.field = value → this_/obj .field = value
    if (_insideMethodBody && _currentClass != null && _needsLowering(_currentClass!.name)) {
      return '$_thisReplacementName.${expr.name.text} = ${_restoreExpr(expr.value)}';
    }
    return 'super.${expr.name.text} = ${_restoreExpr(expr.value)}';
  }

  /// 还原 LocalFunctionInvocation 表达式
  String _restoreLocalFunctionInvocation(LocalFunctionInvocation expr) {
    final funcName = expr.variable.name ?? '_localFunc';
    final args = _restoreArgs(expr.arguments);
    return '$funcName($args)';
  }

  /// `obj.method`（不带括号）实例方法 tear-off。
  /// OOP lowering 后用户方法都是按 ClassInfo 分发的静态函数，tear-off 必须捕获
  /// receiver 并保留虚分发语义。这里合成一个 `ClosureEnv_*` 子类（继承
  /// `TypeFunctionN<R, T...>`），把 receiver 存为字段，`call(...)` 体内
  /// 走 `((_r.classInfo as XxxClassInfo).name as R Function(AnyGC, T...))(...)`。
  String _restoreInstanceTearOff(InstanceTearOff expr) {
    final target = expr.interfaceTarget;
    final func = target.function;
    final methodName = expr.name.text;
    final recv = _restoreExpr(expr.receiver);
    final receiverClassName =
        _getReceiverClassNameFromReceiver(expr.receiver, target);

    // Lowered ABI：named 铺平为 positional。
    final returnType = _restoreTypeForSignature(func.returnType);
    final paramTypes = <String>[];
    for (final p in func.positionalParameters) {
      paramTypes.add(_restoreTypeForSignature(p.type));
    }
    for (final p in func.namedParameters) {
      paramTypes.add(_restoreTypeForSignature(p.type));
    }
    final arity = paramTypes.length;
    if (arity > _TypeUtils.kMaxArity) {
      return "/* unsupported InstanceTearOff arity=$arity for $methodName */";
    }

    final closureId = _closureCounter++;
    final envClassName = 'ClosureEnv_${_closureContext}_$closureId';
    final paramNames = [for (var i = 0; i < arity; i++) 'a${i + 1}'];
    final callSig = [
      for (var i = 0; i < arity; i++) '${paramTypes[i]} ${paramNames[i]}',
    ].join(', ');

    final isVptrTarget = receiverClassName != null &&
        (_isUserClass(receiverClassName) || _isMixinName(receiverClassName));

    //  lowered 用户类 / mixin 方法通过 classInfo 派发，receiver 用 AnyGC；
    //  非 lowered 目标（如 SDK 类型方法）尽量使用接收者静态类型，推断不出时回退 dynamic。
    final receiverFieldType = isVptrTarget
        ? 'AnyGC'
        : () {
            final recvDartType = _getExpressionDartType(expr.receiver);
            if (recvDartType != null) return _restoreTypeForSignature(recvDartType);
            return 'dynamic';
          }();

    final typeArgs = [returnType, ...paramTypes].join(', ');
    final newFuncName = '${envClassName}_new';
    final staticCallName = '${envClassName}_call';
    final tearOffCallArgs = paramNames.isEmpty ? 'this' : 'this, ${paramNames.join(', ')}';
    final decl = StringBuffer()
      ..writeln('class $envClassName extends TypeFunction$arity<$typeArgs> {')
      ..writeln('  late $receiverFieldType _r;')
      ..writeln('  $envClassName();')
      ..writeln('  @override')
      ..writeln('  $returnType call($callSig) => fnPtr($tearOffCallArgs);')
      ..writeln('  @override')
      ..writeln('  void gcMark(int flag) {')
      ..writeln('    if (gcFlag == flag) return;')
      ..writeln('    super.gcMark(flag);')
      ..writeln('    if (_r is AnyGC) (_r as AnyGC).gcMark(flag);')
      ..writeln('  }')
      ..writeln('}')
      ..writeln('$envClassName $newFuncName($envClassName env_, $receiverFieldType _r) {')
      ..writeln('  env_.fnPtr = $staticCallName;')
      ..writeln('  env_._r = _r;')
      ..writeln('  return env_;')
      ..writeln('}');
    // _call 静态函数：第一个参数为 AnyGC（闭包环境自身），内部 cast 到具体环境类
    if (isVptrTarget) {
      // mixin 没有独立的 ClassInfo 类（方法合并进具体用户类），回退到 dynamic 派发
      final classInfoName = _isUserClass(receiverClassName) ? '${receiverClassName}ClassInfo' : 'dynamic';
      decl.writeln('$returnType $staticCallName(AnyGC env__${paramNames.isEmpty ? '' : ', ${callSig}'}) {');
      decl.writeln('  final _r = (env__ as $envClassName)._r;');
      final invokeArgs = ['_r', ...paramNames].join(', ');
      decl.writeln("  return (_r.classInfo as $classInfoName).$methodName!($invokeArgs);");
      decl.writeln('}');
    } else {
      decl.writeln('$returnType $staticCallName(AnyGC env__${paramNames.isEmpty ? '' : ', ${callSig}'}) {');
      decl.writeln('  final _r = (env__ as $envClassName)._r;');
      final invokeArgs = paramNames.join(', ');
      decl.writeln('  return _r.$methodName($invokeArgs);');
      decl.writeln('}');
    }
    _pendingClosureDecls.add(decl.toString());

    final gcMethod = _isStaticFieldContext ? 'allocateGlobal' : 'allocateLocal';
    return '$newFuncName(GC.$gcMethod($envClassName()), $recv)';
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
    final valueStr = _restoreExpr(expr.value);
    return '$base$suffix = $valueStr';
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
        return _emitVptrMethodCall(recv, expr.receiver, 'get_$fieldName', '');
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

    // 集合类属性访问 → 通过 ClassInfo 分派
    if (receiverClassName != null && (_isCollectionClass(receiverClassName) || platformClassInfoNames.containsKey(receiverClassName))) {
      final isSdkType = _isCollectionClass(receiverClassName!);
      final platformName = isSdkType ? _mapSdkTypeName(receiverClassName) : receiverClassName;
      final ciName = platformClassInfoNames[platformName];
      if (ciName != null) {
        final call = _emitVptrMethodCall(recv, expr.receiver, 'get_$fieldName', '', classInfoName: ciName, platformName: platformName);
        // 类型擦除包装：keys/values/entries/reversed 等返回 StaticXxx<T>，
        // ClassInfo 分派擦除为 StaticXxx<dynamic>，需用 StaticXxx<T>.of() 包装
        final returnTypeStr = _restoreType(expr.resultType);
        for (final sn in const ['StaticList', 'StaticSet', 'StaticMap']) {
          if (returnTypeStr.startsWith(sn)) {
            return '$returnTypeStr.of($call)';
          }
        }
        return call;
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
      final valueStr = _restoreExpr(expr.value);
      return '$recv.$fieldName = $valueStr';
    }

    // 用户自定义类或 mixin 的 setter 调用 → 通过 Map 查找类型转换
    // 与 _restoreInstanceGet/_restoreInstanceInvocation 的条件保持一致
    if (receiverClassName != null && (_isUserClass(receiverClassName) || _isMixinName(receiverClassName))) {
      final target = expr.interfaceTarget;
      if (target is Procedure && target.isSetter) {
        final value = _restoreExpr(expr.value);
        return _emitVptrMethodCall(recv, expr.receiver, 'set_$fieldName', value);
      }
    }

    // enum setter 调用 → 静态函数: EnumName_set_field(recv, value)
    if (receiverClassName != null && _isEnumName(receiverClassName)) {
      final target = expr.interfaceTarget;
      if (target is Procedure && target.isSetter) {
        return '${receiverClassName}_set_$fieldName($recv, ${_restoreExpr(expr.value)})';
      }
    }

    // 集合类属性赋值 → 通过 ClassInfo 分派
    if (receiverClassName != null && (_isCollectionClass(receiverClassName) || platformClassInfoNames.containsKey(receiverClassName))) {
      final isSdkType = _isCollectionClass(receiverClassName!);
      final platformName = isSdkType ? _mapSdkTypeName(receiverClassName) : receiverClassName;
      final ciName = platformClassInfoNames[platformName];
      if (ciName != null) {
        final value = _restoreExpr(expr.value);
        return _emitVptrMethodCall(recv, expr.receiver, 'set_$fieldName', value, classInfoName: ciName, platformName: platformName);
      }
    }

    return '$recv.$fieldName = ${_restoreExpr(expr.value)}';
  }

  /// 判断表达式是否是"简单"的（可以安全地重复求值）
  /// 简单表达式：变量引用、字面量、简单的字段访问
  /// 复杂表达式：方法调用、构造函数、有副作用的表达式
  bool _isSimpleExpression(Expression expr) {
    if (expr is VariableGet) return true;
    if (expr is IntLiteral || expr is DoubleLiteral || expr is BoolLiteral || expr is NullLiteral || expr is StringLiteral) return true;
    if (expr is ThisExpression) return true;
    // 简单的字段访问（接收者也是简单的）
    if (expr is InstanceGet) return _isSimpleExpression(expr.receiver);
    if (expr is StaticGet) return true;
    return false;
  }

  /// 生成 ClassInfo 方法调用，处理复杂接收者避免重复求值
  /// 字段已有真实函数类型，无需 as 转换，只需 ! 非空断言
  String _emitVptrMethodCall(String recv, Expression recvExpr, String vtableField, String args, {String? classInfoName, String? platformName}) {
    var ciName = classInfoName ?? _classInfoNameForReceiver(recvExpr);
    // 回退到基类 ClassInfo 时，非基类固定字段（如 mixin 引入的 get_xxx）
    // 只存在于具体子类上，改用 dynamic 派发在运行期解析
    const baseClassInfoFields = {
      'toString_', 'operatorEq', 'get_hashCode', 'get_runtimeType', 'gcMark',
      'get_length', 'get_isEmpty', 'get_isNotEmpty', 'get_iterator',
      'contains', 'compareTo', 'operatorIndex', 'operatorIndexSet',
    };
    if (ciName == 'ClassInfo' && !baseClassInfoFields.contains(vtableField)) {
      ciName = 'dynamic';
    }
    // 集合类非简单表达式可能产生原生 List/Set/Map（无 classInfo）
    // 用 StaticXxx.of() 包装确保有 classInfo
    // 仅对非简单表达式应用——简单变量引用已是 StaticList（类型映射时包装过）
    String wrapIfNeeded(String expr) {
      if (platformName == null) return expr;
      // ClassInfo dispatch 结果已是 StaticList——不再包装
      if (expr.contains('.classInfo')) return expr;
      var probe = expr.trimLeft();
      while (probe.startsWith('(')) {
        probe = probe.substring(1).trimLeft();
      }
      if (probe.startsWith(platformName)) return expr;
      return '$platformName.of($expr)';
    }
    if (_isSimpleExpression(recvExpr)) {
      if (args.isEmpty) {
        return "($recv.classInfo as $ciName).$vtableField!($recv)";
      }
      return "($recv.classInfo as $ciName).$vtableField!($recv, $args)";
    }
    final tmpVar = '_r${_varCounter++}';
    final initExpr = wrapIfNeeded(recv);
    if (args.isEmpty) {
      return "(() { final $tmpVar = $initExpr; return ($tmpVar.classInfo as $ciName).$vtableField!($tmpVar); })()";
    }
    return "(() { final $tmpVar = $initExpr; return ($tmpVar.classInfo as $ciName).$vtableField!($tmpVar, $args); })()";
  }

  /// Platform types that have ClassInfo subclasses in runtime_classes.dart
  static const platformClassInfoNames = {
    'StaticList': 'StaticListClassInfo',
    'StaticSet': 'StaticSetClassInfo',
    'StaticMap': 'StaticMapClassInfo',
  };

  /// 根据接收者表达式的静态类型推断具体的 ClassInfo 类名（含泛型实参）。
  /// vtable 字段声明在具体的 XxxClassInfo 子类上，基类 ClassInfo 只有固定字段，
  /// 因此派发时必须 cast 到具体子类；无法确定时回退到基类 ClassInfo。
  String _classInfoNameForReceiver(Expression recvExpr) {
    final className = _getReceiverClassNameFromReceiver(recvExpr, null) ??
        _classNameFromExprType(recvExpr);
    if (className != null && _isUserClass(className)) {
      final typeArgs = _classInfoCastTypeArgs(recvExpr, className);
      final typeArgStr = typeArgs.isEmpty ? '' : '<${typeArgs.join(', ')}>';
      return '${className}ClassInfo$typeArgStr';
    }
    if (className != null) {
      final platformName = _mapSdkTypeName(className);
      if (platformClassInfoNames.containsKey(platformName)) {
        return platformClassInfoNames[platformName]!;
      }
    }
    return 'ClassInfo';
  }

  /// 从表达式的静态类型提取用户类名（处理 InstanceGet / InstanceInvocation 等
  /// _getReceiverClassNameFromReceiver 未覆盖的表达式形态）
  String? _classNameFromExprType(Expression expr) {
    if (expr is NullCheck) {
      return _classNameFromExprType(expr.operand);
    }
    DartType? type;
    if (expr is InstanceGet) {
      type = expr.resultType;
    } else if (expr is InstanceInvocation) {
      final target = expr.interfaceTarget;
      if (target is Procedure) {
        type = target.function.returnType;
      }
    } else if (expr is InstanceTearOff) {
      type = expr.resultType;
    } else if (expr is StaticInvocation) {
      final target = expr.target;
      if (target is Procedure && target.enclosingClass != null) {
        final className = _getActualClassName(target.enclosingClass!.name);
        if (_isUserClass(className) || _isMixinName(className)) return className;
        if (_isCollectionClass(className) || platformClassInfoNames.containsKey(className)) {
          return className;
        }
      }
    }
    if (type is InterfaceType) {
      final rawName = type.classNode.name;
      if (rawName.endsWith('Value')) {
        final className = rawName.substring(0, rawName.length - 5);
        if (_isUserClass(className)) return className;
      }
      final className = _mapSdkTypeName(_getActualClassName(rawName));
      if (_isUserClass(className) || _isMixinName(className)) return className;
      if (_isCollectionClass(className) || platformClassInfoNames.containsKey(className)) {
        return className;
      }
    }
    return null;
  }

  String _restoreInstanceInvocation(InstanceInvocation expr) {
    final recv = _restoreExpr(expr.receiver);
    final name = expr.name.text;

    // 从 receiver 表达式的类型推断实际接收者类名
    final receiverClassName = _getReceiverClassNameFromReceiver(expr.receiver, expr.interfaceTarget);

    // 对于用户自定义类或 mixin 的实例方法调用，改写为 Map 查找 + 精确类型转换调用
    if (receiverClassName != null && (_isUserClass(receiverClassName) || _isMixinName(receiverClassName))) {
      return _restoreUserClassMethodInvocation(expr, recv, name, receiverClassName);
    }

    // enum 方法调用 → 直接调用静态函数: EnumName_method(recv, args)
    if (receiverClassName != null && _isEnumName(receiverClassName)) {
      return _restoreEnumMethodInvocation(recv, name, receiverClassName, expr.arguments);
    }

    // 集合类方法调用 → 通过 ClassInfo 分派
    if (receiverClassName != null && (_isCollectionClass(receiverClassName) || platformClassInfoNames.containsKey(receiverClassName))) {
      final isSdkType = _isCollectionClass(receiverClassName!);
      final platformName = isSdkType ? _mapSdkTypeName(receiverClassName) : receiverClassName;
      final ciName = platformClassInfoNames[platformName];
      if (ciName != null) {
        // 返回类型检查：ClassInfo 分派会擦除泛型（StaticList<T> → StaticList<dynamic>），
        // 需用 StaticXxx<T>.of() 包装以匹配精确返回类型
        final returnTypeStr = _restoreType(expr.functionType.returnType);
        String? wrapType;
        for (final sn in const ['StaticList', 'StaticSet', 'StaticMap']) {
          if (returnTypeStr.startsWith(sn)) {
            wrapType = returnTypeStr;
            break;
          }
        }
        // toList/toSet
        if (name == 'toList' || name == 'toSet') {
          final call = _emitVptrMethodCall(recv, expr.receiver, name, '', classInfoName: ciName, platformName: platformName);
          return wrapType != null ? '$wrapType.of($call)' : call;
        }
        // 运算符 → _tryRestoreOperatorCall
        final opReturnType = _restoreTypeForSignature(expr.functionType.returnType);
        final opResult = _tryRestoreOperatorCall(expr, recv, name, opReturnType, _thisParamType);
        if (opResult != null) return opResult;
        // 普通方法 → vtable 分派
        final vtableField = _vtableFieldName(name);
        final args = _restoreArgs(expr.arguments);
        final call = _emitVptrMethodCall(recv, expr.receiver, vtableField, args, classInfoName: ciName, platformName: platformName);
        return wrapType != null ? '$wrapType.of($call)' : call;
      }
    }

    // 非用户自定义类：保持原始调用方式
    return _restoreDirectMethodCall(recv, name, expr.arguments);
  }

  /// 还原用户类或 mixin 的实例方法调用
  String _restoreUserClassMethodInvocation(
      InstanceInvocation expr, String recv, String name, String receiverClassName) {
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
    if (name.startsWith('_') && !_isBinaryOp(name) && name != 'unary-' && name != '~' && name != '[]' && name != '[]=') {
      return _restorePrivateMethodCall(expr, recv, name, actualClassName, receiverClassName);
    }

    // this_ 类型：声明侧统一为 dynamic，调用侧签名直接使用 dynamic
    final thisType = _thisParamType;

    // 运算符调用
    final operatorResult = _tryRestoreOperatorCall(expr, recv, name, returnType, thisType);
    if (operatorResult != null) return operatorResult;

    // 普通方法 → Map 查找精确类型转换调用
    final vtableField = _vtableFieldName(name);

    // 检查方法是否有方法级类型参数（如 fold<T>、mapRight<R2>）
    final hasMethodTypeParams = expr.interfaceTarget.function.typeParameters.isNotEmpty;
    if (hasMethodTypeParams) {
      return _restoreGenericMethodCall(expr, recv, name, vtableField, returnType, thisType, actualClassName, receiverClassName);
    }

    // Lowered ABI：positional 缺省值 + named 都按声明顺序铺平为 positional，
    // 调用方补默认值。
    final targetFunc = expr.interfaceTarget.function;
    final fullArgs = _restoreFlattenedArgs(targetFunc, expr.arguments);
    // mixin 没有独立的 ClassInfo 类（方法合并进具体用户类），回退到 dynamic 派发
    // ClassInfo 携带与类相同的泛型参数，cast 时带上接收者的具体类型实参，
    // 使字段的泛型返回/参数类型（如 PairValue<B, A>）在调用处具体化
    String? ciName;
    if (_isUserClass(receiverClassName)) {
      final typeArgs = _classInfoCastTypeArgs(expr.receiver, receiverClassName);
      final typeArgStr = typeArgs.isEmpty ? '' : '<${typeArgs.join(', ')}>';
      ciName = '${receiverClassName}ClassInfo$typeArgStr';
    }
    return _emitVptrMethodCall(recv, expr.receiver, vtableField, fullArgs, classInfoName: ciName);
  }

  /// 计算 ClassInfo cast 需要的泛型实参。
  /// 优先取接收者静态类型上的类型实参；如果为空且目标类（声明方法的类）是
  /// 泛型的，则沿接收者实际类的继承链解析祖先的具体类型实参
  /// （如 ComputeStepStateMachine extends AsyncStateMachine<int> → ['int']）。
  List<String> _classInfoCastTypeArgs(Expression receiver, String receiverClassName) {
    final args = _extractClassTypeArgsFromReceiver(receiver);
    if (args.isNotEmpty) return args;
    final declaringCls = _classNodes[receiverClassName];
    if (declaringCls == null || declaringCls.typeParameters.isEmpty) return const [];
    final actualCls = _receiverActualClassNode(receiver);
    if (actualCls == null || actualCls == declaringCls) return const [];
    return _resolveConcreteTypeArgsForAncestor(actualCls, declaringCls) ?? const [];
  }

  /// 提取接收者表达式静态类型对应的 Class 节点
  Class? _receiverActualClassNode(Expression receiver) {
    if (receiver is ConstructorInvocation) return receiver.target.enclosingClass;
    if (receiver is NullCheck) return _receiverActualClassNode(receiver.operand);
    DartType? t;
    if (receiver is VariableGet) {
      t = receiver.promotedType ?? receiver.variable.type;
    } else if (receiver is InstanceGet) {
      t = receiver.resultType;
    } else if (receiver is InstanceInvocation) {
      t = receiver.functionType.returnType;
    } else if (receiver is StaticInvocation) {
      t = receiver.target.function.returnType;
    } else if (receiver is ThisExpression) {
      return _currentClass;
    }
    if (t is InterfaceType) return t.classNode;
    return null;
  }

  /// 还原私有方法调用
  String _restorePrivateMethodCall(
      InstanceInvocation expr, String recv, String name, String? actualClassName, String receiverClassName) {
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

  /// 尝试还原运算符调用，如果不是运算符则返回 null
  String? _tryRestoreOperatorCall(
      InstanceInvocation expr, String recv, String name, String returnType, String thisType) {
    // 二元运算符 → ClassInfo 分派
    if (_isBinaryOp(name) && expr.arguments.positional.length == 1) {
      final rightParamType = expr.functionType.positionalParameters[0];
      final rightExpr = _restoreExpr(expr.arguments.positional[0]);
      final rightDartType = _getExpressionDartType(expr.arguments.positional[0]);
      final right = _maybeBoxForAnyGC(rightParamType, rightExpr, rightDartType);
      final vtableField = 'operator${_operatorFuncName(name)}';
      return _emitVptrMethodCall(recv, expr.receiver, vtableField, right);
    }
    // 一元运算符
    if (name == 'unary-') {
      return _emitVptrMethodCall(recv, expr.receiver, 'operatorNeg', '');
    }
    if (name == '~') {
      return _emitVptrMethodCall(recv, expr.receiver, 'operatorBitNot', '');
    }
    if (name == '[]') {
      final idxParamType = expr.functionType.positionalParameters[0];
      final idxExpr = _restoreExpr(expr.arguments.positional[0]);
      final idxDartType = _getExpressionDartType(expr.arguments.positional[0]);
      final idx = _maybeBoxForAnyGC(idxParamType, idxExpr, idxDartType);
      return _emitVptrMethodCall(recv, expr.receiver, 'operatorIndex', idx);
    }
    if (name == '[]=') {
      final idxParamType = expr.functionType.positionalParameters[0];
      final idxExpr = _restoreExpr(expr.arguments.positional[0]);
      final idxDartType = _getExpressionDartType(expr.arguments.positional[0]);
      final idx = _maybeBoxForAnyGC(idxParamType, idxExpr, idxDartType);
      final valParamType = expr.functionType.positionalParameters.length > 1
          ? expr.functionType.positionalParameters[1]
          : null;
      final valExpr = _restoreExpr(expr.arguments.positional[1]);
      final valDartType = _getExpressionDartType(expr.arguments.positional[1]);
      final val = valParamType != null
          ? _maybeBoxForAnyGC(valParamType, valExpr, valDartType)
          : valExpr;
      return _emitVptrMethodCall(recv, expr.receiver, 'operatorIndexSet', '$idx, $val');
    }
    return null;
  }

  /// 还原泛型方法调用（带方法级类型参数）
  String _restoreGenericMethodCall(
      InstanceInvocation expr, String recv, String name, String vtableField,
      String returnType, String thisType, String? actualClassName, String receiverClassName) {
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
      final args = _restoreFlattenedArgs(expr.interfaceTarget.function, expr.arguments);

      return _emitVptrMethodCall(recv, expr.receiver, specKey, args);
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
    final allArgs = _restoreArgs(expr.arguments);
    if (allArgs.isEmpty) {
      return '$staticFuncName$typeArgStr($recv)';
    }
    return '$staticFuncName$typeArgStr($recv, $allArgs)';
  }

  /// 还原 enum 方法调用
  String _restoreEnumMethodInvocation(String recv, String name, String receiverClassName, Arguments args) {
    // 特殊处理内置的 toString() 方法
    // 枚举的 toString() 应该返回 "EnumName.valueName" 格式的字符串
    if (name == 'toString' && args.positional.isEmpty && args.named.isEmpty) {
      return "'$receiverClassName.\${$recv.name}'";
    }

    final staticName = '${receiverClassName}_$name';
    final allArgs = _restoreArgs(args);
    if (allArgs.isEmpty) {
      return '$staticName($recv)';
    }
    return '$staticName($recv, $allArgs)';
  }

  /// 还原直接方法调用（非用户类）
  String _restoreDirectMethodCall(String recv, String name, Arguments args) {
    if (_isBinaryOp(name) && args.positional.length == 1) {
      final right = _restoreExpr(args.positional[0]);
      return '($recv $name $right)';
    }
    if (name == 'unary-') return '(-$recv)';
    if (name == '~') return '(~$recv)';
    if (name == '[]') {
      return '$recv[${_restoreExpr(args.positional[0])}]';
    }
    if (name == '[]=') {
      return '$recv[${_restoreExpr(args.positional[0])}] = ${_restoreExpr(args.positional[1])}';
    }
    final allArgs = _restoreArgs(args);
    return '$recv.$name($allArgs)';
  }

  /// this_ 参数统一为 AnyGC（声明侧和调用侧一致，支持 GC 追踪）
  static const String _thisParamType = 'AnyGC';


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
        // 被降级的参数（StaticList→Iterable 等）不走 ClassInfo 分派，
        // 因为运行时值可能是原生类型（const [] 是 Dart List 而非 StaticList）
        if (!_demotedParams.contains(receiver.variable) &&
            (_isCollectionClass(className) || platformClassInfoNames.containsKey(className))) {
          return className;
        }
      }
    }
    // 从 ThisExpression 推断（在类方法内部）
    if (receiver is ThisExpression && _currentClass != null) {
      return _getActualClassName(_currentClass!.name);
    }
    // 从表达式的 resultType 推断（构造函数调用、方法链等）
    final exprTypeName = _classNameFromExprType(receiver);
    if (exprTypeName != null) {
      return exprTypeName;
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
    // StaticInvocation：如 Promise.value<int>(5) → 从返回类型中提取类型实参。
    // 静态方法可能有自己的类型参数（如 value<T>），返回类型中的 TypeParameterType
    // 需用调用处实际类型实参替换后才得到具体类型。
    if (receiver is StaticInvocation) {
      final func = receiver.target.function;
      var retType = func.returnType;
      if (func.typeParameters.isNotEmpty &&
          receiver.arguments.types.isNotEmpty) {
        final sub = Substitution.fromPairs(
            func.typeParameters, receiver.arguments.types);
        retType = sub.substituteType(retType);
      }
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
    // 闭包调用：通过 call() 间接调用
    // recv.call(args) — emitter converts to fnPtr()
    if (args.isEmpty) {
      return '$recv.call()';
    }
    return '$recv.call($args)';
  }

  String _restoreEqualsCall(EqualsCall expr) {
    final left = _restoreExpr(expr.left);
    final right = _restoreExpr(expr.right);
    return '($left == $right)';
  }

  String _restoreStaticInvocation(StaticInvocation expr) {
    final target = expr.target;
    final name = target.name.text;
    // 使用带目标函数类型信息的参数还原，支持 dynamic(AnyGC) 参数自动装箱
    final args = _restoreArgsForTarget(target.function, expr.arguments);

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
        // Future.value(x) → Promise.value<T>(x) (静态方法，类型参数在方法上)
        if (name == 'value' || name == 'rejected' || name == 'error') {
          return 'Promise.$name$typeArgStr($args)';
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
        // 多文件支持：添加跨库前缀
        final prefix = _crossLibPrefix(className);
        // 显式传递泛型类型参数（this_ 为 dynamic 后编译器无法从参数推断）
        final typeArgs = expr.arguments.types;
        final typeArgStr = typeArgs.isNotEmpty
            ? '<${typeArgs.map((t) => _restoreType(t)).join(', ')}>'
            : '';
        return '$prefix$funcName$typeArgStr($args)';
      }
      // 语义脱钩: SDK 类 factory 构造函数映射
      final mappedFactoryClass = _mapSdkTypeName(className);
      if (name.isEmpty) return '$mappedFactoryClass($args)';
      return '$mappedFactoryClass.$name($args)';
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
        // 多文件支持：添加跨库前缀
        final prefix = _crossLibPrefix(className);
        // 显式传递泛型类型参数（this_ 为 dynamic 后编译器无法推断）
        final typeArgs = expr.arguments.types;
        final typeArgStr = typeArgs.isNotEmpty
            ? '<${typeArgs.map((t) => _restoreType(t)).join(', ')}>'
            : '';
        return '$prefix${className}_$name$typeArgStr($args)';
      }
      // 语义脱钩: SDK 静态方法映射
      return '${_mapSdkTypeName(className)}.$name($args)';
    }

    // 顶层函数（包括 mixin lowering 后提升的构造函数和方法）
    // 语义脱钩: print → staticPrint
    final mappedName = _mapTopLevelFuncName(name);
    // 多文件支持：添加跨库前缀
    final prefix = _crossLibPrefix(mappedName);
    // 显式传递泛型类型参数（this_ 为 dynamic 后编译器可能无法从参数推断）
    final typeArgs = expr.arguments.types;
    final typeArgStr = typeArgs.isNotEmpty
        ? '<${typeArgs.map((t) => _restoreType(t)).join(', ')}>'
        : '';
    return '$prefix$mappedName$typeArgStr($args)';
  }

  /// 顶层函数名称映射（语义脱钩）
  static String _mapTopLevelFuncName(String name) {
    if (name == 'print') return 'staticPrint';
    return name;
  }

  String _restoreStaticGet(StaticGet expr) {
    final target = expr.target;
    if (target.enclosingClass != null) {
      final className = target.enclosingClass!.name;
      final memberName = target.name.text;
      // OOP Lowering: 用户自定义类/mixin 的静态字段/getter → 使用 lowered 名称
      if (_isUserClass(className) || _isMixinName(className)) {
        // 多文件支持：添加跨库前缀
        final prefix = _crossLibPrefix(className);
        // 静态字段和静态 getter 都被提升为顶层函数/变量 ClassName_memberName
        // 静态 getter 生成为 ClassName_memberName() 函数
        if (target is Procedure && target.isGetter) {
          return '$prefix${className}_$memberName()';
        }
        // 静态字段 → 顶层变量 ClassName_memberName
        return '$prefix${className}_$memberName';
      }
      // SDK 扩展类（如 _EnumName）的 getter → 直接在对象上访问
      // 例如 EnumName.name getter → p.name
      if (className == '_EnumName' || className == 'EnumName') {
        return memberName; // 会被上层替换为直接属性访问
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
        // 多文件支持：添加跨库前缀
        final prefix = _crossLibPrefix(className);
        return '$prefix${className}_$memberName = $value';
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
    // GC 包裹 Value 对象创建：GC.allocateLocal/Global(XValue()) 作为第一个参数
    if (_isUserClass(className)) {
      final funcName = ctorName.isEmpty
          ? '${className}_new'
          : '${className}_new_$ctorName';
      // 多文件支持：添加跨库前缀
      final prefix = _crossLibPrefix(className);
      // 获取类型参数（如 Pair<String, int>）
      // ConstructorInvocation 中类级泛型参数存储在 arguments.types
      final typeArgs = expr.arguments.types.isNotEmpty
          ? '<${expr.arguments.types.map(_restoreType).join(', ')}>'
          : '';
      final valueType = '${prefix}${className}Value$typeArgs';
      final gcMethod = _isStaticFieldContext ? 'allocateGlobal' : 'allocateLocal';
      final gcWrappedValue = 'GC.$gcMethod($valueType())';
      // 显式传递泛型类型参数（this_ 为 dynamic 后编译器无法从参数推断）
      return allArgs.isEmpty
          ? '$prefix$funcName$typeArgs($gcWrappedValue)'
          : '$prefix$funcName$typeArgs($gcWrappedValue, $allArgs)';
    }

    // 语义脱钩: SDK 类构造函数映射到包装类型
    // 注意：不保留 const 前缀，因为运行时包装类（如 StaticDuration、StaticList 等）
    // 均没有 const 构造器，保留 const 会导致编译错误
    final mappedClassName = _mapSdkTypeName(className);
    if (ctorName.isEmpty) return '$mappedClassName($allArgs)';
    // SDK 类的私有构造函数（如 MapEntry._）应还原为无名构造函数形式
    if (ctorName.startsWith('_')) return '$mappedClassName($allArgs)';
    return '$mappedClassName.$ctorName($allArgs)';
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
  /// Iterable 不包含——Iterable 参数可能被降级为原生类型，不走 ClassInfo 分派
  bool _isCollectionClass(String className) {
    return className == 'List' || className == '_GrowableList' || className == '_List' ||
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
        final escaped = _escapeStringLiteral(e.value, escapeDollar: true);
        return escaped;
      }
      // 对于有自定义 toString 的枚举，在字符串插值中调用静态 toString 函数
      final enumToStringCall = _tryEnumToStringInInterpolation(e);
      if (enumToStringCall != null) return '\${$enumToStringCall}';
      // 集合类已无实例 toString，需通过 ClassInfo 分派
      final collClassName = _getReceiverClassNameFromReceiver(e, null);
      if (collClassName != null &&
          (_isCollectionClass(collClassName) || platformClassInfoNames.containsKey(collClassName))) {
        final isSdkType = _isCollectionClass(collClassName);
        final platformName = isSdkType
            ? _mapSdkTypeName(collClassName) : collClassName;
        final ciName = platformClassInfoNames[platformName];
        if (ciName != null) {
          final recv = _restoreExpr(e);
          return '\${${_emitVptrMethodCall(recv, e, 'toString_', '', classInfoName: ciName, platformName: platformName)}}';
        }
      }
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
    final escaped = _escapeStringLiteral(expr.value);
    return "'$escaped'";
  }

  String _restoreDoubleLiteral(DoubleLiteral expr) {
    final v = expr.value;
    if (v == v.toInt().toDouble()) return '${v.toStringAsFixed(1)}';
    return '$v';
  }

  String _restoreListLiteral(ListLiteral expr) {
    final typeArg = _restoreType(expr.typeArgument);
    // 处理展开元素 ...
    final items = expr.expressions.map(_restoreExpr).join(', ');
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
    final operandStr = _restoreExpr(expr.operand);
    final typeStr = _restoreType(expr.type);
    final operandType = _getExpressionDartType(expr.operand);

    // 如果操作数原类型是 dynamic（现为 AnyGC），且目标是基本类型，使用 dynAs 拆箱
    if (operandType is DynamicType && _isPrimitiveTypeName(typeStr)) {
      return 'dynAs<$typeStr>($operandStr)';
    }
    return '($operandStr as $typeStr)';
  }

  /// 判断类型名是否是基本类型（int, double, bool, String）
  bool _isPrimitiveTypeName(String name) =>
      name == 'int' || name == 'double' || name == 'bool' || name == 'String';

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
    final closureId = _closureCounter++;
    final envClassName = 'ClosureEnv_${_closureContext}_$closureId';

    // Phase 1: 收集捕获变量
    final capturedFields = _collectCapturedFields(capturedDecls, capturesThis);

    // Phase 2: 清理参数名 + 预分析 Box 化
    _cleanClosureParamNames(func);
    _preanalyzeBoxedVarsForFunc(func);
    final boxedParams = _getBoxedParams(func);

    // Phase 3: 构建参数列表
    final returnType = _restoreType(func.returnType);
    final callParamStr = _buildCallParamStr(func);
    final callArgStr = _buildCallArgStr(func);

    // Phase 4: 收集泛型参数
    final typeParamStr = _collectClosureTypeParams(func, capturedDecls);
    final typeParamDeclStr = _buildTypeParamDeclStr(func, capturedDecls);

    // Phase 5: 生成闭包体
    final bodyInfo = _generateClosureBody(func, boxedParams, capturesThis, capturedDecls, envClassName);

    // Phase 6: 生成 ClosureEnv 类 + _new + _call
    final declBuf = StringBuffer();
    _generateClosureClassDef(declBuf, envClassName, capturedFields, returnType,
        callParamStr, callArgStr, typeParamDeclStr, typeParamStr, func);
    _generateClosureNewFunc(declBuf, envClassName, capturedFields, typeParamStr, typeParamDeclStr);
    _generateClosureStaticCall(declBuf, envClassName, returnType, callParamStr,
        typeParamDeclStr, typeParamStr, func, bodyInfo.bodyStr);
    _pendingClosureDecls.add(declBuf.toString());

    // Phase 7: 恢复状态并返回构造表达式
    bodyInfo.restoreState();
    return _buildClosureConstructExpr(envClassName, capturedFields, capturedDecls,
        capturesThis, typeParamStr, bodyInfo.savedEnvPrefix, bodyInfo.savedThisInEnv);
  }

  /// 收集闭包捕获的变量列表（this + 普通变量）
  List<_CapturedVar> _collectCapturedFields(List<VariableDeclaration> capturedDecls, bool capturesThis) {
    final fields = <_CapturedVar>[];

    // this 捕获
    if (capturesThis && _insideMethodBody && _currentClass != null && _needsLowering(_currentClass!.name)) {
      String thisTypeStr;
      if (_isUserClass(_currentClass!.name)) {
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
      fields.add(_CapturedVar(name: _thisReplacementName, typeStr: thisTypeStr, isThis: true));
    }

    // 普通变量捕获
    for (final decl in capturedDecls) {
      final varName = _cleanVarName(decl.name ?? '_cap${_varCounter++}');
      decl.name = varName;
      final isBoxed = _boxedVars.contains(decl);
      final typeStr = isBoxed ? _boxTypeNameFor(decl.type)! : _restoreType(decl.type);
      fields.add(_CapturedVar(name: varName, typeStr: typeStr, isBoxed: isBoxed));
    }
    return fields;
  }

  /// 清理闭包参数名
  void _cleanClosureParamNames(FunctionNode func) {
    for (final p in func.positionalParameters) {
      p.name = _cleanVarName(p.name ?? '_p${_varCounter++}');
    }
    for (final p in func.namedParameters) {
      p.name = _cleanVarName(p.name ?? '_n${_varCounter++}');
    }
  }

  /// 获取被 Box 化的参数
  List<VariableDeclaration> _getBoxedParams(FunctionNode func) {
    final boxed = <VariableDeclaration>[];
    for (final p in func.positionalParameters) {
      if (_boxedVars.contains(p)) boxed.add(p);
    }
    for (final p in func.namedParameters) {
      if (_boxedVars.contains(p)) boxed.add(p);
    }
    return boxed;
  }

  /// 构建 call 方法的参数声明字符串
  String _buildCallParamStr(FunctionNode func) {
    final params = <String>[];
    for (final p in func.positionalParameters) {
      final baseName = p.name!;
      final pName = _boxedVars.contains(p) ? '${baseName}_raw' : baseName;
      params.add('${_restoreClosureParamType(p.type)} $pName');
    }
    for (final p in func.namedParameters) {
      final baseName = p.name!;
      final pName = _boxedVars.contains(p) ? '${baseName}_raw' : baseName;
      params.add('${_restoreClosureParamType(p.type)} $pName');
    }
    return params.join(', ');
  }

  /// 构建 call → staticFunc 的转发参数字符串
  String _buildCallArgStr(FunctionNode func) {
    final args = <String>[];
    for (final p in func.positionalParameters) {
      final baseName = p.name!;
      args.add(_boxedVars.contains(p) ? '${baseName}_raw' : baseName);
    }
    for (final p in func.namedParameters) {
      final baseName = p.name!;
      args.add(_boxedVars.contains(p) ? '${baseName}_raw' : baseName);
    }
    return args.join(', ');
  }

  /// 收集闭包中用到的泛型参数名称字符串（仅名称形式，如 `<T, U>`）
  String _collectClosureTypeParams(FunctionNode func, List<VariableDeclaration> capturedDecls) {
    final typeParams = <TypeParameter>{};
    for (final decl in capturedDecls) _collectTypeParameters(decl.type, typeParams);
    for (final p in func.positionalParameters) _collectTypeParameters(p.type, typeParams);
    for (final p in func.namedParameters) _collectTypeParameters(p.type, typeParams);
    _collectTypeParameters(func.returnType, typeParams);
    return typeParams.isEmpty ? '' : '<${typeParams.map((tp) => tp.name ?? 'T').join(', ')}>';
  }

  /// 构建泛型参数声明字符串（带 extends Bound，如 `<T extends num>`）
  String _buildTypeParamDeclStr(FunctionNode func, List<VariableDeclaration> capturedDecls) {
    final typeParams = <TypeParameter>{};
    for (final decl in capturedDecls) _collectTypeParameters(decl.type, typeParams);
    for (final p in func.positionalParameters) _collectTypeParameters(p.type, typeParams);
    for (final p in func.namedParameters) _collectTypeParameters(p.type, typeParams);
    _collectTypeParameters(func.returnType, typeParams);
    return typeParams.isEmpty ? '' : '<${typeParams.map(_formatTypeParamDecl).join(', ')}>';
  }

  /// 生成闭包体字符串，同时保存/设置闭包上下文状态
  /// 返回 (bodyStr, restoreState, savedEnvPrefix, savedThisInEnv) 记录
  ({String bodyStr, void Function() restoreState, Map<VariableDeclaration, String> savedEnvPrefix, bool savedThisInEnv}) _generateClosureBody(FunctionNode func,
      List<VariableDeclaration> boxedParams, bool capturesThis,
      List<VariableDeclaration> capturedDecls, String envClassName) {
    // 设置 env 映射
    final savedEnvPrefix = Map<VariableDeclaration, String>.from(_capturedVarEnvPrefix);
    final savedThisInEnv = _thisIsCapturedInEnv;

    for (final decl in capturedDecls) {
      _capturedVarEnvPrefix[decl] = 'env.';
    }
    if (capturesThis && _insideMethodBody && _currentClass != null && _isUserClass(_currentClass!.name)) {
      _thisIsCapturedInEnv = true;
    }

    _pushClosureContext(envClassName);
    final savedCurrentParams = Set<VariableDeclaration>.from(_currentFunctionParams);
    _currentFunctionParams
      ..clear()
      ..addAll(func.positionalParameters)
      ..addAll(func.namedParameters);

    // 生成参数 Box 包装语句
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
      if (paramBoxInitLines.isNotEmpty) {
        tmpBuf.write('{\n');
        for (final line in paramBoxInitLines) tmpBuf.write(line);
        if (func.body is Block) {
          final oldIndent = _indent;
          _indent = 1;
          for (final s in (func.body as Block).statements) _restoreStmt(s);
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

    void restoreState() {
      _currentFunctionParams
        ..clear()
        ..addAll(savedCurrentParams);
      _popClosureContext();
      _capturedVarEnvPrefix
        ..clear()
        ..addAll(savedEnvPrefix);
      _thisIsCapturedInEnv = savedThisInEnv;
    }

    return (bodyStr: bodyStr, restoreState: restoreState, savedEnvPrefix: savedEnvPrefix, savedThisInEnv: savedThisInEnv);
  }

  /// 生成 ClosureEnv 类定义
  void _generateClosureClassDef(StringBuffer declBuf, String envClassName,
      List<_CapturedVar> capturedFields, String returnType,
      String callParamStr, String callArgStr, String typeParamDeclStr,
      String typeParamStr, FunctionNode func) {
    final positionalParamTypes = <String>[
      for (final p in func.positionalParameters) _restoreClosureParamType(p.type),
    ];
    final hasNamedParam = func.namedParameters.isNotEmpty;
    String baseClause;
    bool callIsOverride;
    if (!hasNamedParam && positionalParamTypes.length <= _TypeUtils.kMaxArity) {
      final arity = positionalParamTypes.length;
      final args = [returnType, ...positionalParamTypes].join(', ');
      baseClause = ' extends TypeFunction$arity<$args>';
      callIsOverride = true;
    } else {
      baseClause = ' extends TypeFunction';
      callIsOverride = false;
    }

    declBuf.write('class $envClassName$typeParamDeclStr$baseClause {\n');

    // 捕获变量字段
    for (final field in capturedFields) {
      declBuf.write('  late ${field.typeStr} ${field.name};\n');
    }

    // 无参构造函数
    declBuf.write('  $envClassName();\n');

    // call 方法
    final callArgs = callArgStr.isEmpty ? 'this' : 'this, $callArgStr';
    if (callIsOverride) declBuf.write('  @override\n');
    declBuf.write('  $returnType call($callParamStr) => fnPtr($callArgs);\n');

    // gcMark 覆写
    if (capturedFields.isNotEmpty) {
      declBuf.write('  @override\n');
      declBuf.write('  void gcMark(int flag) {\n');
      declBuf.write('    if (gcFlag == flag) return;\n');
      declBuf.write('    super.gcMark(flag);\n');
      for (final field in capturedFields) {
        declBuf.write('    if (${field.name} is AnyGC) (${field.name} as AnyGC).gcMark(flag);\n');
      }
      declBuf.write('  }\n');
    }

    declBuf.write('}\n');
  }

  /// 生成 _new 工厂函数
  void _generateClosureNewFunc(StringBuffer declBuf, String envClassName,
      List<_CapturedVar> capturedFields, String typeParamStr, String typeParamDeclStr) {
    final newFuncName = '${envClassName}_new';
    final envClassWithTypeParams = '$envClassName$typeParamStr';
    final newParams = <String>['$envClassWithTypeParams env_'];
    for (final field in capturedFields) {
      newParams.add('${field.typeStr} ${field.name}');
    }
    declBuf.write('$envClassWithTypeParams $newFuncName$typeParamDeclStr(${newParams.join(', ')}) {\n');
    declBuf.write('  env_.fnPtr = ${envClassName}_call$typeParamStr;\n');
    for (final field in capturedFields) {
      declBuf.write('  env_.${field.name} = ${field.name};\n');
    }
    declBuf.write('  return env_;\n');
    declBuf.write('}\n');
  }

  /// 生成静态 _call 函数
  void _generateClosureStaticCall(StringBuffer declBuf, String envClassName,
      String returnType, String callParamStr, String typeParamDeclStr,
      String typeParamStr, FunctionNode func, String bodyStr) {
    final envClassWithTypeParams = '$envClassName$typeParamStr';
    final staticParams = callParamStr.isEmpty
        ? 'AnyGC env__'
        : 'AnyGC env__, $callParamStr';

    final marker = func.asyncMarker;
    String asyncStr = '';
    if (marker == AsyncMarker.AsyncStar) asyncStr = ' async*';
    if (marker == AsyncMarker.SyncStar) asyncStr = ' sync*';

    final castLine = '  final env = env__ as $envClassWithTypeParams;\n';
    final adjustedBody = _insertCastIntoBody(bodyStr, castLine);
    declBuf.write('$returnType ${envClassName}_call$typeParamDeclStr($staticParams)$asyncStr$adjustedBody\n');
  }

  /// 构建闭包构造表达式
  String _buildClosureConstructExpr(String envClassName, List<_CapturedVar> capturedFields,
      List<VariableDeclaration> capturedDecls, bool capturesThis, String typeParamStr,
      Map<VariableDeclaration, String> savedEnvPrefix, bool savedThisInEnv) {
    final constructArgsList = <String>[];
    for (int _i = 0; _i < capturedFields.length; _i++) {
      final field = capturedFields[_i];
      if (field.isThis) {
        constructArgsList.add(savedThisInEnv ? 'env.${field.name}' : field.name);
      } else if (_i < capturedDecls.length + (capturesThis && _insideMethodBody && _currentClass != null && _needsLowering(_currentClass!.name) ? 1 : 0)) {
        final declIdx = field.isThis ? -1 : _i - (capturedFields.any((f) => f.isThis) ? 1 : 0);
        if (declIdx >= 0 && declIdx < capturedDecls.length) {
          final prefix = savedEnvPrefix[capturedDecls[declIdx]];
          constructArgsList.add(prefix != null ? '$prefix${field.name}' : field.name);
        } else {
          constructArgsList.add(field.name);
        }
      } else {
        constructArgsList.add(field.name);
      }
    }
    final constructArgs = constructArgsList.join(', ');
    final gcMethod = _isStaticFieldContext ? 'allocateGlobal' : 'allocateLocal';
    final gcWrappedValue = 'GC.$gcMethod($envClassName$typeParamStr())';
    if (constructArgs.isEmpty) {
      return '${envClassName}_new$typeParamStr($gcWrappedValue)';
    }
    return '${envClassName}_new$typeParamStr($gcWrappedValue, $constructArgs)';
  }

  /// 将 cast 语句插入到 bodyStr 的 `{` 之后。
  /// bodyStr 格式为 " { stmts }" 或 " => expr;"
  String _insertCastIntoBody(String bodyStr, String castLine) {
    final trimmed = bodyStr.trimLeft();
    if (trimmed.startsWith('{')) {
      // " { stmts }" → " {\n  castLine\n  stmts }"
      final braceIdx = bodyStr.indexOf('{');
      return '${bodyStr.substring(0, braceIdx + 1)}\n$castLine${bodyStr.substring(braceIdx + 1)}';
    }
    // " => expr;" 这种单表达式形式很少出现在闭包 body 中，但保底处理
    return ' {\n$castLine  ${trimmed.substring(3)}\n}';
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
      // 集合类也需要 lowering（级联方法调用走 ClassInfo 分派）
      if (_isCollectionClass(className) || platformClassInfoNames.containsKey(className)) {
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
