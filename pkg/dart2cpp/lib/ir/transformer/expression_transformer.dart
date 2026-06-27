/// 表达式转换器 — 将 Kernel Expression 转为 IrExpression。
///
/// 合并自：
/// - `restorer/expression_restorer.dart`
/// - `cpp_compiler/expression_emitter.dart`
///
/// 核心决策（vptr 调度、闭包捕获、Box 装箱）在此完成，
/// 发射器只做语法翻译。
library expression_transformer;

import 'package:kernel/kernel.dart';
import 'package:dart2cpp/ir/ir_nodes.dart';
import 'package:dart2cpp/shared/shared.dart';
import 'ir_transformer.dart';

/// 表达式转换器。
class ExpressionTransformer {
  final IrTransformer ir;

  /// Counter for generating unique variable names
  int _unnamedVarCounter = 0;

  /// Map to track variable names by their declaration
  final Map<VariableDeclaration, String> _variableNames = {};

  ExpressionTransformer(this.ir);

  /// 将 Kernel Expression 转为 IrExpression。
  IrExpression transform(Expression expr) {
    // -- 字面量 --
    if (expr is IntLiteral) return IrIntLiteral(expr.value);
    if (expr is DoubleLiteral) return IrDoubleLiteral(expr.value);
    if (expr is BoolLiteral) return IrBoolLiteral(expr.value);
    if (expr is StringLiteral) return IrStringLiteral(expr.value);
    if (expr is NullLiteral) return const IrNullLiteral();
    if (expr is SymbolLiteral) return IrSymbolLiteral(expr.value);
    if (expr is TypeLiteral) {
      return IrTypeLiteral(ir.typeTransformer.transform(expr.type));
    }

    // -- 变量 --
    if (expr is VariableGet) return _transformVarGet(expr);
    if (expr is VariableSet) return _transformVarSet(expr);

    // -- 实例访问 --
    if (expr is InstanceGet) return _transformInstanceGet(expr);
    if (expr is InstanceSet) return _transformInstanceSet(expr);
    if (expr is InstanceInvocation) return _transformInstanceInvocation(expr);
    if (expr is InstanceGetterInvocation) {
      return _transformInstanceGetterInvocation(expr);
    }

    // -- 函数调用 --
    if (expr is FunctionInvocation) return _transformFunctionInvocation(expr);
    if (expr is DynamicInvocation) return _transformDynamicInvocation(expr);

    // -- 静态调用 --
    if (expr is StaticInvocation) return _transformStaticInvocation(expr);
    if (expr is StaticGet) return _transformStaticGet(expr);
    if (expr is StaticSet) return _transformStaticSet(expr);

    // -- 构造函数 --
    if (expr is ConstructorInvocation) return _transformConstructor(expr);

    // -- 控制 --
    if (expr is ConditionalExpression) return _transformConditional(expr);
    if (expr is LogicalExpression) return _transformLogical(expr);
    if (expr is Not) return IrNotExpr(transform(expr.operand));
    if (expr is StringConcatenation) return _transformStringConcat(expr);

    // -- 集合 --
    if (expr is ListLiteral) return _transformListLiteral(expr);
    if (expr is MapLiteral) return _transformMapLiteral(expr);
    if (expr is SetLiteral) return _transformSetLiteral(expr);

    // -- 类型操作 --
    if (expr is IsExpression) return _transformIs(expr);
    if (expr is AsExpression) return _transformAs(expr);
    if (expr is NullCheck) {
      return IrNullCheck(transform(expr.operand));
    }

    // -- Let / Block --
    if (expr is Let) return _transformLet(expr);
    if (expr is BlockExpression) return _transformBlockExpr(expr);

    // -- 闭包 --
    if (expr is FunctionExpression) return _transformFuncExpr(expr);

    // -- throw --
    if (expr is Throw) return IrThrowExpr(transform(expr.expression));
    if (expr is Rethrow) return const IrRethrowExpr();

    // -- await --
    if (expr is AwaitExpression) return _transformAwait(expr);

    // -- this / super --
    if (expr is ThisExpression) return _transformThis(expr);
    if (expr is SuperPropertyGet) return _transformSuperGet(expr);
    if (expr is SuperMethodInvocation) return _transformSuperCall(expr);
    if (expr is SuperPropertySet) return _transformSuperSet(expr);
    if (expr is AbstractSuperPropertyGet) {
      return IrSuperFieldGet(expr.name.text);
    }

    // -- 相等检查 --
    if (expr is EqualsNull) return IrEqualsNull(transform(expr.expression));
    if (expr is EqualsCall) {
      return IrEqualsCall(
        transform(expr.left),
        transform(expr.right),
      );
    }

    // -- Dynamic --
    if (expr is DynamicGet) {
      return IrFieldGet(transform(expr.receiver), expr.name.text);
    }
    if (expr is DynamicSet) {
      return IrFieldSet(
          transform(expr.receiver), expr.name.text, transform(expr.value));
    }

    // -- Record --
    if (expr is RecordLiteral) return _transformRecordLiteral(expr);
    if (expr is RecordIndexGet) {
      return IrRecordGet(transform(expr.receiver), index: expr.index);
    }
    if (expr is RecordNameGet) {
      return IrRecordGet(transform(expr.receiver), name: expr.name);
    }

    // -- Constant --
    if (expr is ConstantExpression) {
      return ir.constantTransformer.transform(expr.constant);
    }

    // -- Tear-off --
    if (expr is InstanceTearOff) return _transformTearOff(expr);

    // -- 其他 --
    if (expr is LocalFunctionInvocation) {
      // 处理本地函数调用
      // 优先使用 variable.name（实际的函数名），如果名称是 "call" 则使用当前本地函数名
      var funcName = expr.variable?.name ?? expr.name.text;
      if (funcName == 'call' && ir.currentLocalFunctionName != null) {
        funcName = ir.currentLocalFunctionName!;
      }
      return IrStaticCall(
        funcName,
        expr.arguments.positional.map((a) => transform(a)).toList(),
      );
    }
    if (expr is InvalidExpression) {
      return IrRawCode(dartCode: '/* invalid */', cppCode: '/* invalid */');
    }
    if (expr is CheckLibraryIsLoaded) {
      return const IrBoolLiteral(true);
    }
    if (expr is LoadLibrary) {
      return IrStringLiteral(expr.import.name ?? 'unknown');
    }

    // Fallback
    return IrRawCode(
      dartCode: '/* unknown expr: ${expr.runtimeType} */',
      cppCode: '/* unknown expr: ${expr.runtimeType} */',
    );
  }

  // -----------------------------------------------------------------------
  // 变量
  // -----------------------------------------------------------------------

  IrExpression _transformVarGet(VariableGet expr) {
    final name = _getVariableName(expr.variable);
    final isBoxed = ir.boxedVars.contains(expr.variable);
    final envPrefix = ir.capturedVarEnvPrefix[expr.variable];
    final type = ir.typeTransformer.transform(expr.variable.type);

    return IrVariableGet(name,
        isBoxed: isBoxed, envPrefix: envPrefix, type: type);
  }

  IrExpression _transformVarSet(VariableSet expr) {
    final name = _getVariableName(expr.variable);
    final isBoxed = ir.boxedVars.contains(expr.variable);
    final envPrefix = ir.capturedVarEnvPrefix[expr.variable];
    final type = ir.typeTransformer.transform(expr.variable.type);

    return IrVariableSet(name, transform(expr.value),
        isBoxed: isBoxed, envPrefix: envPrefix, type: type);
  }

  // -----------------------------------------------------------------------
  // 实例访问
  // -----------------------------------------------------------------------

  IrExpression _transformInstanceGet(InstanceGet expr) {
    final receiver = transform(expr.receiver);
    final fieldName = expr.name.text;
    final receiverClassName = _getReceiverClassName(expr.receiver, expr.interfaceTarget);

    // 私有字段：直接访问，不使用 vptr
    // 私有字段不应该通过 vptr 访问，因为它们不是虚方法
    if (fieldName.startsWith('_')) {
      return IrFieldGet(receiver, fieldName,
          type: ir.typeTransformer.transform(expr.resultType));
    }

    // 用户类或 mixin 的 getter → vptr dispatch
    if (receiverClassName != null && ir.ctx.needsLowering(receiverClassName)) {
      final target = expr.interfaceTarget;
      if (target is Procedure && target.isGetter) {
        final declClass = target.enclosingClass;
        var declClassName = declClass?.name;
        // 对合成 mixin 中间类名进行 sanitize（_X&Y&Z → X_Y_Z）
        if (declClassName != null && declClassName.contains('&')) {
          declClassName = _sanitizeSyntheticName(declClassName);
        }
        if (declClassName != null && !ir.ctx.needsLowering(declClassName)) {
          return IrFieldGet(receiver, fieldName,
              type: ir.typeTransformer.transform(expr.resultType));
        }

        final returnType = ir.typeTransformer.transform(expr.resultType);
        return IrVptrDispatch(receiver, 'get_$fieldName', [],
            returnType: returnType, paramTypes: [const IrDynamicType()]);
      }
    }

    // Enum getter → 静态函数
    if (receiverClassName != null && ir.ctx.isEnum(receiverClassName)) {
      final target = expr.interfaceTarget;
      if (target is Procedure && target.isGetter) {
        return IrFieldGet(receiver, fieldName,
            type: ir.typeTransformer.transform(expr.resultType),
            isEnumGetter: true,
            enumGetterFuncName: '${receiverClassName}_get_$fieldName');
      }
    }

    // Enum 字段访问 → 静态函数调用
    if (receiverClassName != null && ir.ctx.isEnum(receiverClassName)) {
      // 排除内置字段（index 和 _name 由 Dart 枚举自动提供）
      if (fieldName != 'index' && fieldName != '_name' && !fieldName.startsWith('_')) {
        final returnType = ir.typeTransformer.transform(expr.resultType);
        return IrStaticCall('${receiverClassName}_get_$fieldName', [receiver],
            returnType: returnType);
      }
    }

    return IrFieldGet(receiver, fieldName,
        type: ir.typeTransformer.transform(expr.resultType));
  }

  IrExpression _transformInstanceSet(InstanceSet expr) {
    final receiver = transform(expr.receiver);
    final fieldName = expr.name.text;
    final value = transform(expr.value);

    // 私有字段直接赋值
    if (fieldName.startsWith('_')) {
      return IrFieldSet(receiver, fieldName, value);
    }

    // 用户类的 setter → vptr dispatch
    final receiverClassName = _getReceiverClassName(expr.receiver, expr.interfaceTarget);
    if (receiverClassName != null && ir.ctx.needsLowering(receiverClassName)) {
      final target = expr.interfaceTarget;
      if (target is Procedure && target.isSetter) {
        return IrVptrDispatch(
          receiver,
          'set_$fieldName',
          [value],
          returnType: const IrDynamicType(),
          paramTypes: [const IrDynamicType(), const IrDynamicType()],
        );
      }
    }

    return IrFieldSet(receiver, fieldName, value);
  }

  IrExpression _transformInstanceInvocation(InstanceInvocation expr) {
    final receiver = transform(expr.receiver);
    final name = expr.name.text;
    final receiverClassName = _getReceiverClassName(expr.receiver, expr.interfaceTarget);
    final funcType = expr.functionType;
    final returnType = ir.typeTransformer.transform(funcType.returnType);

    // 用户类或 mixin 的实例方法
    if (receiverClassName != null && ir.ctx.needsLowering(receiverClassName)) {
      final enclosingClass = expr.interfaceTarget.enclosingClass;
      var actualClassName = enclosingClass?.name;
      // 对合成 mixin 中间类名进行 sanitize（_X&Y&Z → X_Y_Z）
      if (actualClassName != null && actualClassName.contains('&')) {
        actualClassName = _sanitizeSyntheticName(actualClassName);
      }

      // 方法定义在非用户类基类 → 直接调用
      if (actualClassName != null && !ir.ctx.needsLowering(actualClassName)) {
        final args = expr.arguments.positional.map((a) => transform(a)).toList();
        // Built-in type operators → native syntax
        if (OperatorNames.isOperator(name)) {
          if (name == 'unary-') {
            return IrNativeOpExpr('unary-', receiver, type: returnType);
          }
          if (name == '~') {
            return IrNativeOpExpr('~', receiver, type: returnType);
          }
          if (name == '[]') {
            return IrNativeOpExpr('[]', receiver, right: args.isNotEmpty ? args.first : const IrNullLiteral(), type: returnType);
          }
          if (name == '[]=') {
            return IrNativeOpExpr('[]=', receiver,
                right: args.isNotEmpty ? args.first : const IrNullLiteral(),
                indexSetValue: args.length > 1 ? args[1] : const IrNullLiteral(),
                type: returnType);
          }
          // Binary operator
          return IrNativeOpExpr(name, receiver,
              right: args.isNotEmpty ? args.first : const IrNullLiteral(),
              type: returnType);
        }
        return IrDynamicCall(receiver, name, args, returnType: returnType);
      }

      // 私有方法 → 直接静态调用（绕过 vptr）
      if (name.startsWith('_') && !OperatorNames.isBinaryOp(name) &&
          name != 'unary-' && name != '~' && name != '[]' && name != '[]=') {
        var resolvedClassName = actualClassName ?? receiverClassName;
        if (ir.ctx.isSyntheticMixin(resolvedClassName)) {
          resolvedClassName = ir.ctx.findUserClassForSynthetic(resolvedClassName);
        }
        final staticFuncName = '${resolvedClassName}_$name';
        final args = <IrExpression>[receiver];
        for (final a in expr.arguments.positional) {
          args.add(transform(a));
        }
        return IrVptrDispatch(
          receiver, name, expr.arguments.positional.map((a) => transform(a)).toList(),
          returnType: returnType,
          isPrivateDirectCall: true,
          directStaticFuncName: staticFuncName,
        );
      }

      // 运算符
      if (OperatorNames.isOperator(name)) {
        final vptrKey = OperatorNames.vptrKey(name, VTableEntryKind.operator_);
        final args = expr.arguments.positional.map((a) => transform(a)).toList();
        return IrVptrDispatch(receiver, vptrKey, args, returnType: returnType);
      }

      // 检测方法级递归调用：如果当前方法有方法级类型参数，且调用的是同一个类的同一个方法，
      // 则使用直接静态调用而不是 vptr 分发，以保留方法级类型参数
      if (ir.currentMethodTypeParams != null &&
          ir.currentMethodTypeParams!.isNotEmpty &&
          ir.currentMethodName != null &&
          ir.currentMethodClassName != null &&
          name == ir.currentMethodName &&
          receiverClassName == ir.currentMethodClassName) {
        // 构建直接静态调用：ClassName_methodName<T_class, T_method>(receiver, args)
        final staticFuncName = '${ir.currentMethodClassName}_$name';
        final args = <IrExpression>[receiver];
        for (final a in expr.arguments.positional) {
          args.add(transform(a));
        }

        // 收集所有类型参数：类类型参数 + 方法类型参数
        final allTypeArgs = <IrType>[];

        // 添加类类型参数（从当前类获取）
        if (ir.currentClass != null) {
          for (final tp in ir.currentClass!.typeParameters) {
            allTypeArgs.add(IrTypeParameterType(tp.name ?? 'T'));
          }
        }

        // 添加方法类型参数（从调用处获取实际类型参数）
        final typeArgs = expr.arguments.types;
        final funcTypeParams = expr.interfaceTarget.function.typeParameters;
        if (typeArgs.length >= funcTypeParams.length) {
          for (var i = 0; i < funcTypeParams.length; i++) {
            allTypeArgs.add(ir.typeTransformer.transform(typeArgs[i]));
          }
        }

        return IrStaticCall(staticFuncName, args,
            typeArgs: allTypeArgs,
            returnType: returnType);
      }

      // 普通方法 → vptr dispatch
      final args = expr.arguments.positional.map((a) => transform(a)).toList();
      final namedArgs = <String, IrExpression>{};
      for (final named in expr.arguments.named) {
        namedArgs[named.name] = transform(named.value);
      }
      final paramTypes = <IrType>[const IrDynamicType()];
      for (final p in funcType.positionalParameters) {
        paramTypes.add(ir.typeTransformer.transform(p));
      }

      // 方法级泛型特化
      String? specSuffix;
      List<String>? specTypeArgs;
      if (receiverClassName != null &&
          ir.ctx.methodTypeSpecializations.containsKey(receiverClassName)) {
        final methodSpecs = ir.ctx.methodTypeSpecializations[receiverClassName]![name];
        if (methodSpecs != null) {
          final funcTypeParams = expr.interfaceTarget.function.typeParameters;
          final typeArgs = expr.arguments.types;
          if (typeArgs.length >= funcTypeParams.length) {
            final concreteArgs = typeArgs.sublist(0, funcTypeParams.length);
            final typeArgStrs = concreteArgs
                .map((t) => _typeToSpecString(t))
                .toList();
            final suffix = typeArgStrs.join('_');
            if (methodSpecs.any((s) => s.vptrSuffix == suffix)) {
              specSuffix = suffix;
              specTypeArgs = typeArgStrs;
            }
          }
        }
      }

      return IrVptrDispatch(
        receiver, name, args,
        namedArgs: namedArgs,
        returnType: returnType,
        paramTypes: paramTypes,
        specializationSuffix: specSuffix,
        specializationTypeArgs: specTypeArgs,
      );
    }

    // Enum 方法 → 静态函数
    if (receiverClassName != null && ir.ctx.isEnum(receiverClassName)) {
      final args = <IrExpression>[receiver];
      for (final a in expr.arguments.positional) {
        args.add(transform(a));
      }
      return IrStaticCall(
        '${receiverClassName}_$name', args,
        returnType: returnType,
      );
    }

    // 非用户类 → 保持原样（运算符用原生语法）
    final args = expr.arguments.positional.map((a) => transform(a)).toList();

    // Built-in type operators → native syntax (int, double, String, etc.)
    if (OperatorNames.isOperator(name)) {
      if (name == 'unary-') {
        return IrNativeOpExpr('unary-', receiver, type: returnType);
      }
      if (name == '~') {
        return IrNativeOpExpr('~', receiver, type: returnType);
      }
      if (name == '[]') {
        return IrNativeOpExpr('[]', receiver,
            right: args.isNotEmpty ? args.first : const IrNullLiteral(),
            type: returnType);
      }
      if (name == '[]=') {
        return IrNativeOpExpr('[]=', receiver,
            right: args.isNotEmpty ? args.first : const IrNullLiteral(),
            indexSetValue: args.length > 1 ? args[1] : const IrNullLiteral(),
            type: returnType);
      }
      // Binary operator
      return IrNativeOpExpr(name, receiver,
          right: args.isNotEmpty ? args.first : const IrNullLiteral(),
          type: returnType);
    }

    // Detect .toList() / .toSet() / .toMap() calls — wrap with Static*.of()
    // But skip if the receiver already returns a StaticList/StaticSet/StaticMap
    if (name == 'toList' && returnType is IrCollectionType) {
      // Check if the receiver already returns a StaticList
      if (receiver is IrDynamicCall && _returnsStaticList(receiver)) {
        // Skip .toList() call - receiver already returns StaticList
        return receiver;
      }
      final innerCall = IrDynamicCall(receiver, name, args, returnType: returnType);
      return IrStaticCall('StaticList.of', [innerCall], typeArgs: returnType.typeArgs);
    }
    if (name == 'toSet' && returnType is IrCollectionType) {
      // Check if the receiver already returns a StaticSet
      if (receiver is IrDynamicCall && _returnsStaticSet(receiver)) {
        return receiver;
      }
      final innerCall = IrDynamicCall(receiver, name, args, returnType: returnType);
      return IrStaticCall('StaticSet.of', [innerCall], typeArgs: returnType.typeArgs);
    }
    // Detect .split() on String — wrap with StaticList.of()
    if (name == 'split' && returnType is IrCollectionType) {
      final innerCall = IrDynamicCall(receiver, name, args, returnType: returnType);
      return IrStaticCall('StaticList.of', [innerCall], typeArgs: returnType.typeArgs);
    }
    // Detect methods that return Iterable/List and need wrapping
    // Check the receiver type to determine whether to wrap with StaticList or StaticMap
    if ((name == 'map' || name == 'where' || name == 'expand' || name == 'take' || name == 'skip')
        && returnType is IrCollectionType) {
      final innerCall = IrDynamicCall(receiver, name, args, returnType: returnType);
      // Check if receiver is a Map type
      if (receiver.resultType is IrCollectionType &&
          (receiver.resultType as IrCollectionType).kind == CollectionKind.map) {
        return IrStaticCall('StaticMap.of', [innerCall], typeArgs: returnType.typeArgs);
      }
      return IrStaticCall('StaticList.of', [innerCall], typeArgs: returnType.typeArgs);
    }

    // Detect .toStringAsFixed() on double — transform to helper function
    if (name == 'toStringAsFixed' && args.length == 1) {
      return IrStaticCall('dart_str_toStringAsFixed', [receiver, args[0]]);
    }

    return IrDynamicCall(receiver, name, args, returnType: returnType);
  }

  IrExpression _transformInstanceGetterInvocation(
      InstanceGetterInvocation expr) {
    final receiver = transform(expr.receiver);
    final name = expr.name.text;
    final returnType = ir.typeTransformer.transform(
        expr.functionType?.returnType ?? const DynamicType());

    return IrVptrDispatch(receiver, 'get_$name', [],
        returnType: returnType, paramTypes: [const IrDynamicType()]);
  }

  // -----------------------------------------------------------------------
  // 函数调用
  // -----------------------------------------------------------------------

  IrExpression _transformFunctionInvocation(FunctionInvocation expr) {
    final target = transform(expr.receiver);
    final args = expr.arguments.positional.map((a) => transform(a)).toList();
    final returnType = ir.typeTransformer.transform(
        expr.functionType?.returnType ?? const DynamicType());

    return IrFunctionInvocation(target, args, returnType: returnType);
  }

  IrExpression _transformDynamicInvocation(DynamicInvocation expr) {
    final receiver = transform(expr.receiver);
    final name = expr.name.text;
    final args = expr.arguments.positional.map((a) => transform(a)).toList();

    return IrDynamicCall(receiver, name, args);
  }

  // -----------------------------------------------------------------------
  // 静态调用
  // -----------------------------------------------------------------------

  IrExpression _transformStaticInvocation(StaticInvocation expr) {
    final target = expr.target;
    var name = target.name.text;
    // Sanitize extension method names at call sites
    if (name.contains('|') || name.contains('#')) {
      name = OperatorNames.sanitizeExtensionMethodName(name);
    }
    final args = expr.arguments.positional.map((a) => transform(a)).toList();
    final enclosingClass = target.enclosingClass;

    // Get the return type from the target function
    final returnType = ir.typeTransformer.transform(target.function.returnType);

    // 静态集合: _GrowableList → StaticList
    if (enclosingClass != null && enclosingClass.name == '_GrowableList') {
      final typeArgs = expr.arguments.types
          .map((t) => ir.typeTransformer.transform(t))
          .toList();
      if (name.startsWith('_literal')) {
        return IrListLiteral(args, typeArgs: typeArgs);
      }
      if (name.isEmpty) {
        return IrListLiteral([], typeArgs: typeArgs);
      }
      // fallthrough to factory handler
    }

    // Set 内部类 → StaticSet
    if (enclosingClass != null &&
        TypeClassifier.isSetInternalClass(enclosingClass.name)) {
      final typeArgs = expr.arguments.types
          .map((t) => ir.typeTransformer.transform(t))
          .toList();
      if (name == 'from' || name == 'of') {
        return IrSetLiteral(args, typeArgs: typeArgs);
      }
      if (name.isEmpty || name == '_default') {
        return IrSetLiteral([], typeArgs: typeArgs);
      }
      return IrStaticCall('StaticSet.$name', args, returnType: returnType);
    }

    // Map 内部类 → StaticMap
    if (enclosingClass != null &&
        TypeClassifier.isMapInternalClass(enclosingClass.name)) {
      final typeArgs = expr.arguments.types
          .map((t) => ir.typeTransformer.transform(t))
          .toList();
      if (name.isEmpty || name == '_default') {
        return IrMapLiteral([], typeArgs: typeArgs);
      }
      return IrStaticCall('StaticMap.$name', args, returnType: returnType);
    }

    // 顶层函数映射: print → staticPrint
    if (enclosingClass == null) {
      final mappedName = _mapTopLevelFuncName(name);
      final namedArgs = <String, IrExpression>{};
      for (final named in expr.arguments.named) {
        namedArgs[named.name] = transform(named.value);
      }
      return IrStaticCall(mappedName, args, namedArgs: namedArgs, returnType: returnType);
    }

    // Future/_Future factory → Promise
    if (enclosingClass.name == 'Future' || enclosingClass.name == '_Future') {
      return _transformFutureFactory(expr, args);
    }

    // List/Map/Set factory → Static*
    if (TypeClassifier.isListInternalClass(enclosingClass.name)) {
      final typeArgs = expr.arguments.types
          .map((t) => ir.typeTransformer.transform(t))
          .toList();
      return IrStaticCall('StaticList.$name', args, typeArgs: typeArgs, returnType: returnType);
    }

    // SDK 类名映射
    final mappedSdkName = TypeClassifier.mapSdkClassName(enclosingClass.name);
    if (mappedSdkName != null) {
      // For unnamed constructors (empty name), just use the mapped name
      final funcName = name.isEmpty ? mappedSdkName : '$mappedSdkName.$name';
      return IrStaticCall(funcName, args, returnType: returnType);
    }

    // Primitive type static methods: int.parse, double.parse, String.fromCharCode, etc.
    if (const {'int', 'double', 'num', 'String', 'bool', 'BigInt'}.contains(enclosingClass.name)) {
      return IrStaticCall('${enclosingClass.name}.$name', args, returnType: returnType);
    }

    // 用户类的 static 方法 / factory
    if (ir.ctx.isUserClass(enclosingClass.name)) {
      if (target.isFactory) {
        final ctorName = target.name.text;
        final newFuncName = ctorName.isEmpty
            ? '${enclosingClass.name}_new'
            : '${enclosingClass.name}_new_$ctorName';
        // Collect named arguments for factory constructors
        final namedArgs = <String, IrExpression>{};
        for (final named in expr.arguments.named) {
          namedArgs[named.name] = transform(named.value);
        }
        return IrConstructorCall(enclosingClass.name, newFuncName, args,
            namedArgs: namedArgs,
            ctorName: ctorName.isEmpty ? null : ctorName, isFactory: true);
      }
      return IrStaticCall('${enclosingClass.name}_$name', args, returnType: returnType);
    }

    // 通用静态调用 — sanitize extension method names
    var callName = name;
    if (callName.contains('|') || callName.contains('#')) {
      callName = OperatorNames.sanitizeExtensionMethodName(callName);
    }
    return IrStaticCall(callName, args, returnType: returnType);
  }

  IrExpression _transformStaticGet(StaticGet expr) {
    final target = expr.target;
    if (target is Field) {
      final cls = target.enclosingClass;
      if (cls != null && ir.ctx.isUserClass(cls.name)) {
        return IrRawCode(
          dartCode: '${cls.name}_${target.name.text}',
          cppCode: '${cls.name}_${target.name.text}',
        );
      }
      return IrRawCode(
        dartCode: '${cls?.name ?? ''}.${target.name.text}',
        cppCode: '${cls?.name ?? ''}::${target.name.text}',
      );
    }
    // Handle static getters on user classes
    if (target is Procedure && target.isGetter && target.isStatic) {
      final cls = target.enclosingClass;
      if (cls != null && ir.ctx.isUserClass(cls.name)) {
        return IrStaticCall('${cls.name}_get_${target.name.text}', []);
      }
    }
    var name = target.name.text;
    if (name.contains('|') || name.contains('#')) {
      name = OperatorNames.sanitizeExtensionMethodName(name);
    }
    return IrRawCode(
      dartCode: name,
      cppCode: name,
    );
  }

  IrExpression _transformStaticSet(StaticSet expr) {
    final target = expr.target;
    final value = transform(expr.value);
    if (target is Field) {
      final cls = target.enclosingClass;
      if (cls != null) {
        return IrStaticFieldSet(cls.name, target.name.text, value);
      }
    }
    return value;
  }

  // -----------------------------------------------------------------------
  // 构造函数
  // -----------------------------------------------------------------------

  IrExpression _transformConstructor(ConstructorInvocation expr) {
    final className = expr.target.enclosingClass.name;
    final ctorName = expr.target.name.text;
    final args = expr.arguments.positional.map((a) => transform(a)).toList();
    final namedArgs = <String, IrExpression>{};
    for (final named in expr.arguments.named) {
      namedArgs[named.name] = transform(named.value);
    }
    final typeArgs = expr.arguments.types
        .map((t) => ir.typeTransformer.transform(t))
        .toList();

    // 静态集合
    if (className == '_GrowableList') {
      if (ctorName.startsWith('_literal')) {
        return IrListLiteral(args, typeArgs: typeArgs);
      }
      return IrListLiteral([], typeArgs: typeArgs);
    }
    if (TypeClassifier.isSetInternalClass(className)) {
      return IrSetLiteral([], typeArgs: typeArgs);
    }

    // 用户类
    if (ir.ctx.isUserClass(className)) {
      final newFuncName = ctorName.isEmpty
          ? '${className}_new'
          : '${className}_new_$ctorName';
      return IrConstructorCall(className, newFuncName, args,
          namedArgs: namedArgs,
          typeArgs: typeArgs,
          ctorName: ctorName.isEmpty ? null : ctorName);
    }

    // Fallback: non-user class constructors
    // Map SDK class names if needed
    final mappedName = TypeClassifier.mapSdkClassName(className) ?? className;
    // For named constructors, use ClassName.constructorName format
    // Treat '_' as unnamed constructor for mapped SDK classes
    final isUnnamed = ctorName.isEmpty || (mappedName != className && ctorName == '_');
    final funcName = isUnnamed ? mappedName : '$mappedName.$ctorName';
    return IrStaticCall(
      funcName,
      args,
      namedArgs: namedArgs,
      typeArgs: typeArgs,
    );
  }

  // -----------------------------------------------------------------------
  // 控制
  // -----------------------------------------------------------------------

  IrExpression _transformConditional(ConditionalExpression expr) {
    return IrConditional(
      transform(expr.condition),
      transform(expr.then),
      transform(expr.otherwise),
      type: ir.typeTransformer.transform(expr.staticType),
    );
  }

  IrExpression _transformLogical(LogicalExpression expr) {
    return IrLogicalExpr(
      transform(expr.left),
      expr.operatorEnum == LogicalExpressionOperator.AND ? LogicalOp.and : LogicalOp.or,
      transform(expr.right),
    );
  }

  IrExpression _transformStringConcat(StringConcatenation expr) {
    final parts = <IrExpression>[];
    for (final e in expr.expressions) {
      final transformed = transform(e);

      // Check if this is a TypeLiteral referring to a type parameter
      // If so, we need to use runtimeType instead of the type name
      if (e is TypeLiteral && e.type is TypeParameterType) {
        // This is a type parameter in string interpolation
        // We need to find a value of this type and use its runtimeType

        // For mixin methods, we can use the 'value' getter if it exists
        if (ir.currentClassName != null && ir.ctx.isMixin(ir.currentClassName!)) {
          // Check if there's a 'value' getter in the current mixin
          final mixinClass = ir.currentClass;
          if (mixinClass != null) {
            final hasValueGetter = mixinClass.procedures.any((p) =>
                p.name.text == 'value' && p.isGetter && !p.isStatic);
            if (hasValueGetter) {
              // Use ((this_.vptr['get_value'] as Function)(this_)).runtimeType
              final valueCall = IrVptrDispatch(
                IrThisExpr(replacementName: 'this_'),
                'get_value',
                [],
                returnType: const IrDynamicType(),
              );
              parts.add(IrFieldGet(
                valueCall,
                'runtimeType',
                type: const IrPrimitiveType(PrimitiveKind.string_),
              ));
              continue;
            }
          }
        }

        // For regular classes, we can use any field that has the type parameter type
        if (ir.currentClassName != null && ir.currentClass != null) {
          final currentClass = ir.currentClass!;
          final typeParamName = (e.type as TypeParameterType).parameter.name;

          // Find a field that has this type parameter type
          for (final field in currentClass.fields) {
            if (field.isStatic) continue;
            final fieldType = field.type;
            if (fieldType is TypeParameterType && fieldType.parameter.name == typeParamName) {
              // Use this_.fieldName.runtimeType
              final fieldGet = IrFieldGet(
                IrThisExpr(replacementName: 'this_'),
                field.name.text,
                type: const IrDynamicType(),
              );
              parts.add(IrFieldGet(
                fieldGet,
                'runtimeType',
                type: const IrPrimitiveType(PrimitiveKind.string_),
              ));
              break;
            }
          }
          continue;
        }
      }

      // Check if this is an enum value in string interpolation
      // If so, wrap it with a call to the toString function (if it has one)
      String? enumClassName;

      if (e is VariableGet) {
        final varType = e.variable.type;
        if (varType is InterfaceType) {
          final className = varType.classNode.name;
          if (ir.ctx.isEnum(className)) {
            // Check if the enum has a custom toString method
            final enumClass = varType.classNode;
            final hasToStringMethod = enumClass.procedures.any((p) =>
                p.name.text == 'toString' && !p.isStatic && !p.isFactory);
            if (hasToStringMethod) {
              enumClassName = className;
            }
          }
        }
      } else if (e is InstanceGet) {
        // Check if this is a field access that returns an enum
        final target = e.interfaceTarget;
        if (target is Field) {
          final fieldType = target.type;
          if (fieldType is InterfaceType) {
            final className = fieldType.classNode.name;
            if (ir.ctx.isEnum(className)) {
              // Check if the enum has a custom toString method
              final enumClass = fieldType.classNode;
              final hasToStringMethod = enumClass.procedures.any((p) =>
                  p.name.text == 'toString' && !p.isStatic && !p.isFactory);
              if (hasToStringMethod) {
                enumClassName = className;
              }
            }
          }
        }
      } else if (e is InstanceGetterInvocation) {
        // Check if this is a getter invocation that returns an enum
        final target = e.interfaceTarget;
        if (target is Procedure && target.isGetter) {
          final returnType = target.function.returnType;
          if (returnType is InterfaceType) {
            final className = returnType.classNode.name;
            if (ir.ctx.isEnum(className)) {
              // Check if the enum has a custom toString method
              final enumClass = returnType.classNode;
              final hasToStringMethod = enumClass.procedures.any((p) =>
                  p.name.text == 'toString' && !p.isStatic && !p.isFactory);
              if (hasToStringMethod) {
                enumClassName = className;
              }
            }
          }
        }
      }

      if (enumClassName != null) {
        // This is an enum value with custom toString, wrap with toString call
        parts.add(IrStaticCall(
          '${enumClassName}_toString',
          [transformed],
          returnType: const IrPrimitiveType(PrimitiveKind.string_),
        ));
      } else {
        parts.add(transformed);
      }
    }
    return IrStringConcat(parts);
  }

  // -----------------------------------------------------------------------
  // 集合
  // -----------------------------------------------------------------------

  IrExpression _transformListLiteral(ListLiteral expr) {
    final elements = expr.expressions.map((e) => transform(e)).toList();
    final typeArgs = expr.typeArgument != null
        ? [ir.typeTransformer.transform(expr.typeArgument!)]
        : <IrType>[];
    return IrListLiteral(elements, typeArgs: typeArgs, isConst: expr.isConst);
  }

  IrExpression _transformMapLiteral(MapLiteral expr) {
    final entries = <IrMapEntry>[];
    for (var i = 0; i < expr.entries.length; i++) {
      entries.add(IrMapEntry(
        transform(expr.entries[i].key),
        transform(expr.entries[i].value),
      ));
    }
    final typeArgs = expr.keyType != null && expr.valueType != null
        ? [
            ir.typeTransformer.transform(expr.keyType!),
            ir.typeTransformer.transform(expr.valueType!),
          ]
        : <IrType>[];
    return IrMapLiteral(entries, typeArgs: typeArgs, isConst: expr.isConst);
  }

  IrExpression _transformSetLiteral(SetLiteral expr) {
    final elements = expr.expressions.map((e) => transform(e)).toList();
    final typeArgs = expr.typeArgument != null
        ? [ir.typeTransformer.transform(expr.typeArgument!)]
        : <IrType>[];
    return IrSetLiteral(elements, typeArgs: typeArgs, isConst: expr.isConst);
  }

  // -----------------------------------------------------------------------
  // 类型操作
  // -----------------------------------------------------------------------

  IrExpression _transformIs(IsExpression expr) {
    return IrIsCheck(
      transform(expr.operand),
      ir.typeTransformer.transform(expr.type),
    );
  }

  IrExpression _transformAs(AsExpression expr) {
    return IrCastExpr(
      transform(expr.operand),
      ir.typeTransformer.transform(expr.type),
    );
  }

  // -----------------------------------------------------------------------
  // Let / Block
  // -----------------------------------------------------------------------

  IrExpression _transformLet(Let expr) {
    // Generate a unique variable name for this let expression
    final varName = _getVariableName(expr.variable);
    final init = expr.variable.initializer != null
        ? transform(expr.variable.initializer!)
        : const IrNullLiteral();
    final body = transform(expr.body);

    // 模式识别：?? / ?. / ..
    // 简化：统一用 IrLet，并保留类型信息
    final bodyType = body.resultType;

    // 如果 body 是条件表达式，且返回类型是基础类型，但 init 是 AnyPtr，
    // 需要转换返回值为基础类型
    if (body is IrConditional &&
        bodyType is IrPrimitiveType &&
        init.resultType is IrDynamicType) {
      // 转换 then 分支的返回值
      final thenExpr = body.thenExpr;
      final elseExpr = body.elseExpr;

      // 转换 then 分支
      IrExpression convertedThen = thenExpr;
      if (thenExpr.resultType is IrDynamicType &&
          bodyType is IrPrimitiveType) {
        convertedThen = IrCastExpr(thenExpr, bodyType);
      }

      // 转换 else 分支
      IrExpression convertedElse = elseExpr;
      if (elseExpr.resultType is IrDynamicType &&
          bodyType is IrPrimitiveType) {
        convertedElse = IrCastExpr(elseExpr, bodyType);
      }

      final convertedBody = IrConditional(
        body.condition,
        convertedThen,
        convertedElse,
        type: bodyType,
      );

      return IrLetExpr(varName, init, convertedBody, type: bodyType);
    }

    return IrLetExpr(varName, init, body, type: bodyType);
  }

  IrExpression _transformBlockExpr(BlockExpression expr) {
    final stmts =
        expr.body.statements.map((s) => ir.statementTransformer.transform(s)).toList();
    final result = transform(expr.value);
    return IrBlockExpr(stmts, result);
  }

  // -----------------------------------------------------------------------
  // 闭包
  // -----------------------------------------------------------------------

  IrExpression _transformFuncExpr(FunctionExpression expr) {
    return ir.closureTransformer.transform(expr.function);
  }

  // -----------------------------------------------------------------------
  // await
  // -----------------------------------------------------------------------

  IrExpression _transformAwait(AwaitExpression expr) {
    final operand = transform(expr.operand);
    // Try to infer the inner type from the operand
    IrType innerType = const IrDynamicType();
    final operandType = operand.resultType;
    if (operandType is IrPromiseType) {
      innerType = operandType.innerType;
    } else if (operandType is IrUserType && operandType.className == 'Promise') {
      // If it's a Promise type, extract the inner type
      if (operandType.typeArgs.isNotEmpty) {
        innerType = operandType.typeArgs.first;
      }
    } else if (operand is IrFunctionInvocation && operand.returnType is IrPromiseType) {
      // If the operand is a function call that returns a Promise, extract the inner type
      innerType = (operand.returnType as IrPromiseType).innerType;
    } else if (operand is IrStaticCall && operand.returnType is IrPromiseType) {
      // If the operand is a static call that returns a Promise, extract the inner type
      innerType = (operand.returnType as IrPromiseType).innerType;
    }
    return IrAwaitExpr(operand, innerType);
  }

  // -----------------------------------------------------------------------
  // this / super
  // -----------------------------------------------------------------------

  IrExpression _transformThis(ThisExpression expr) {
    IrType? type;
    if (ir.currentClass != null) {
      type = IrUserType(ir.currentClass!.name);
    }
    return IrThisExpr(
      replacementName: ir.thisReplacementName,
      inClosureEnv: ir.thisIsCapturedInEnv,
      className: ir.currentClassName,
      type: type,
    );
  }

  IrExpression _transformSuperGet(SuperPropertyGet expr) {
    final fieldName = expr.name.text;
    // For synthetic mixin intermediates, super.field should resolve to the mixin's getter
    if (ir.currentClassName != null && ir.ctx.isSyntheticMixin(ir.currentClassName!)) {
      for (final mixinName in ir.ctx.mixinNames) {
        if (ir.currentClassName!.endsWith(mixinName)) {
          return IrStaticCall('${mixinName}_get_$fieldName',
              [IrThisExpr(replacementName: ir.thisReplacementName)],
              returnType: const IrDynamicType());
        }
      }
    }
    // For regular user classes, super.field should resolve to the parent's static getter
    if (ir.currentClassName != null && ir.ctx.isUserClass(ir.currentClassName!)) {
      final parentClassName = ir.ctx.classHierarchy[ir.currentClassName!];
      if (parentClassName != null) {
        return IrStaticCall('${parentClassName}_get_$fieldName',
            [IrThisExpr(replacementName: ir.thisReplacementName)],
            returnType: const IrDynamicType());
      }
    }
    return IrSuperFieldGet(fieldName);
  }

  IrExpression _transformSuperCall(SuperMethodInvocation expr) {
    final name = expr.name.text;
    final args = <IrExpression>[
      IrThisExpr(replacementName: ir.thisReplacementName)
    ];
    for (final a in expr.arguments.positional) {
      args.add(transform(a));
    }

    // 找到父类名
    String? parentClassName;
    if (ir.currentClassName != null) {
      // For synthetic mixin intermediates, super.method() should resolve
      // to the mixin's method, not the parent's method
      if (ir.ctx.isSyntheticMixin(ir.currentClassName!)) {
        // Find the applied mixin name from the class name
        for (final mixinName in ir.ctx.mixinNames) {
          if (ir.currentClassName!.endsWith(mixinName)) {
            parentClassName = mixinName;
            break;
          }
        }
      }
      parentClassName ??= ir.ctx.classHierarchy[ir.currentClassName!];
    }

    final staticFuncName = parentClassName != null
        ? '${parentClassName}_$name'
        : 'super_$name';

    return IrSuperCall(staticFuncName, args);
  }

  IrExpression _transformSuperSet(SuperPropertySet expr) {
    // For synthetic mixin intermediates, super.field = val should resolve to the mixin's setter
    if (ir.currentClassName != null && ir.ctx.isSyntheticMixin(ir.currentClassName!)) {
      for (final mixinName in ir.ctx.mixinNames) {
        if (ir.currentClassName!.endsWith(mixinName)) {
          return IrStaticCall('${mixinName}_set_${expr.name.text}',
              [IrThisExpr(replacementName: ir.thisReplacementName), transform(expr.value)],
              returnType: const IrVoidType());
        }
      }
    }
    return IrSuperFieldSet(expr.name.text, transform(expr.value));
  }

  // -----------------------------------------------------------------------
  // Record
  // -----------------------------------------------------------------------

  IrExpression _transformRecordLiteral(RecordLiteral expr) {
    final positional = expr.positional.map((e) => transform(e)).toList();
    final named = <String, IrExpression>{
      for (final n in expr.named)
        n.name: transform(n.value),
    };
    return IrRecordLiteral(positional, named);
  }

  // -----------------------------------------------------------------------
  // Tear-off
  // -----------------------------------------------------------------------

  IrExpression _transformTearOff(InstanceTearOff expr) {
    final receiver = transform(expr.receiver);
    final methodName = expr.name.text;
    final className = _getReceiverClassName(expr.receiver, expr.interfaceTarget);

    if (className != null && ir.ctx.isUserClass(className)) {
      final staticFuncName = '${className}_$methodName';
      // InstanceTearOff has no .type — derive function type from interfaceTarget.
      final targetFunc = expr.interfaceTarget.function;
      final funcRetType = ir.typeTransformer.transform(targetFunc.returnType);
      final funcType = IrFunctionType(
        funcRetType,
        [const IrDynamicType()],
        arity: 1,
      );
      return IrTearOff(receiver, methodName, staticFuncName, funcType);
    }

    return IrRawCode(
      dartCode: '${_irToDartHint(receiver)}.$methodName',
      cppCode: '${_irToCppHint(receiver)}.$methodName',
    );
  }

  // -----------------------------------------------------------------------
  // Future factory → Promise
  // -----------------------------------------------------------------------

  IrExpression _transformFutureFactory(StaticInvocation expr, List<IrExpression> args) {
    final name = expr.target.name.text;
    final typeArgs = expr.arguments.types
        .map((t) => ir.typeTransformer.transform(t))
        .toList();

    if (name == 'value') {
      // Future.value(v) → Promise.value<T>(v)
      return IrStaticCall(
        'Promise.value',
        args.isNotEmpty ? args : [const IrNullLiteral()],
        typeArgs: typeArgs,
        isStaticMethod: true,
      );
    }
    if (name == 'error') {
      // Future.error(e) → Promise.rejected<T>(e)
      return IrStaticCall(
        'Promise.rejected',
        args,
        typeArgs: typeArgs,
        isStaticMethod: true,
      );
    }
    if (name == 'delayed') {
      // Future.delayed(Duration, [computation]) -> promiseDelayed(duration, computation)
      if (args.isNotEmpty) {
        final durationArg = args.first;

        // Provide a no-op computation if not provided
        final computation = args.length > 1
            ? args[1]
            : IrRawCode(
                dartCode: '() => null',
                cppCode: '[]() { return AnyPtr(); }',
              );

        return IrStaticCall('promiseDelayed', [durationArg, computation]);
      }
      return IrStaticCall('promiseDelayed', args);
    }
    if (name == 'microtask' || name == 'sync') {
      return IrStaticCall('Promise.$name', args);
    }

    return IrStaticCall('Promise.$name', args);
  }

  // -----------------------------------------------------------------------
  // Helpers
  // -----------------------------------------------------------------------

  /// 从接收者表达式推断类名。
  String? _getReceiverClassName(Expression receiver, Member? interfaceTarget) {
    // 从 receiver 的类型推断
    if (receiver is VariableGet) {
      final type = receiver.variable.type;
      if (type is InterfaceType) {
        var name = type.classNode.name;
        if (name.contains('&')) {
          name = _sanitizeSyntheticName(name);
        }
        return name;
      }
    }
    if (receiver is ThisExpression && ir.currentClass != null) {
      return ir.currentClassName;
    }
    // 从 interfaceTarget 推断
    if (interfaceTarget != null) {
      final cls = interfaceTarget.enclosingClass;
      if (cls != null) {
        var name = cls.name;
        if (name.contains('&')) {
          name = _sanitizeSyntheticName(name);
        }
        return name;
      }
    }
    return null;
  }

  String _sanitizeSyntheticName(String name) {
    var result = name;
    if (result.startsWith('_')) result = result.substring(1);
    return result.replaceAll('&', '_');
  }

  /// Get or generate a variable name for a variable declaration
  String _getVariableName(VariableDeclaration variable) {
    // Check if we've already generated a name for this variable
    if (_variableNames.containsKey(variable)) {
      return _variableNames[variable]!;
    }

    // Generate a new name
    final name = _cleanVarName(variable.name, isNewVariable: true);
    _variableNames[variable] = name;
    return name;
  }

  String _cleanVarName(String? name, {bool isNewVariable = false}) {
    if (name == null || name.isEmpty) {
      if (isNewVariable) {
        _unnamedVarCounter++;
      }
      return '_unnamed$_unnamedVarCounter';
    }
    var result = name;
    if (result.startsWith(':#')) result = result.substring(2);
    if (result.startsWith('#')) result = result.substring(1);
    result = result.replaceAll('#', '_').replaceAll(':', '_');
    // Prefix digit-starting names with underscore (e.g., `0_0` → `_0_0`)
    if (result.isNotEmpty && result.codeUnitAt(0) >= 0x30 && result.codeUnitAt(0) <= 0x39) {
      result = '_$result';
    }
    // Avoid Dart keywords
    const keywords = {
      'this', 'super', 'null', 'true', 'false', 'abstract', 'as', 'assert',
      'async', 'await', 'break', 'case', 'catch', 'class', 'const', 'continue',
      'covariant', 'default', 'deferred', 'do', 'dynamic', 'else', 'enum',
      'export', 'extends', 'extension', 'external', 'factory', 'final',
      'finally', 'for', 'Function', 'get', 'hide', 'if', 'implements',
      'import', 'in', 'interface', 'is', 'late', 'library', 'mixin', 'new',
      'on', 'operator', 'part', 'required', 'rethrow', 'return', 'set', 'show',
      'static', 'switch', 'sync', 'throw', 'try', 'typedef', 'var', 'void',
      'while', 'with', 'yield',
    };
    if (keywords.contains(result)) return '${result}_';
    return result;
  }

  String _mapTopLevelFuncName(String name) {
    if (name == 'print') return 'staticPrint';
    return name;
  }

  String _typeToSpecString(DartType type) {
    if (type is InterfaceType) {
      final name = type.classNode.name;
      if (name == 'List' || name == '_GrowableList') return 'StaticList';
      if (name == 'Map' || name == 'LinkedHashMap') return 'StaticMap';
      if (name == 'Set' || name == '_CompactLinkedHashSet') return 'StaticSet';
      if (name == 'Future' || name == '_Future') return 'Promise';
      return name;
    }
    if (type is VoidType) return 'void';
    if (type is DynamicType) return 'dynamic';
    return 'dynamic';
  }

  /// 简单 IR → Dart 字符串提示（用于 RawCode fallback）。
  String _irToDartHint(IrExpression expr) {
    if (expr is IrIntLiteral) return '${expr.value}';
    if (expr is IrDoubleLiteral) return '${expr.value}';
    if (expr is IrBoolLiteral) return '${expr.value}';
    if (expr is IrStringLiteral) return "'${expr.value}'";
    if (expr is IrNullLiteral) return 'null';
    if (expr is IrVariableGet) return expr.name;
    return '/* expr */';
  }

  /// 简单 IR → C++ 字符串提示（用于 RawCode fallback）。
  String _irToCppHint(IrExpression expr) {
    if (expr is IrIntLiteral) return '${expr.value}';
    if (expr is IrDoubleLiteral) return '${expr.value}';
    if (expr is IrBoolLiteral) return '${expr.value}';
    if (expr is IrStringLiteral) return '"${expr.value}"';
    if (expr is IrNullLiteral) return 'AnyPtr()';
    if (expr is IrVariableGet) return expr.name;
    return '/* expr */';
  }

  /// 检查动态调用是否返回 StaticList。
  bool _returnsStaticList(IrDynamicCall call) {
    // Check if the method name is one that returns a StaticList
    // Common methods: map, where, reversed, etc.
    if (call.methodName == 'map' ||
        call.methodName == 'where' ||
        call.methodName == 'reversed' ||
        call.methodName == 'toList') {
      return true;
    }
    return false;
  }

  /// 检查动态调用是否返回 StaticSet。
  bool _returnsStaticSet(IrDynamicCall call) {
    // Check if the method name is one that returns a StaticSet
    if (call.methodName == 'toSet') {
      return true;
    }
    return false;
  }
}
