/// 闭包转换器 — 将 FunctionExpression 转为 ClosureEnv IR 节点。
///
/// 合并自：
/// - `restorer/expression_restorer.dart` 的 `_restoreFuncExprAsClosure`
/// - `cpp_compiler/closure_emitter.dart` 的 `emitClosure`
library closure_transformer;

import 'package:kernel/kernel.dart';
import 'package:dart2cpp/ir/ir_nodes.dart';
import 'package:dart2cpp/shared/shared.dart';
import 'ir_transformer.dart';

/// 闭包转换器。
class ClosureTransformer {
  final IrTransformer ir;

  ClosureTransformer(this.ir);

  /// 将 FunctionNode 转为 IrClosureExpr。
  ///
  /// 分析捕获变量、Box 化需求，生成完整的闭包元数据。
  IrExpression transform(FunctionNode func) {
    final captureAnalysis = CaptureAnalyzer().analyze(func);
    final boxSet = BoxAnalyzer().analyze(func);

    // 无捕获 → 简单 lambda（退化为 IrRawCode）
    if (captureAnalysis.capturedDecls.isEmpty &&
        !captureAnalysis.capturesThis) {
      return _transformAsLambda(func);
    }

    return _transformAsClosure(func, captureAnalysis, boxSet);
  }

  /// 无捕获 → 简单 lambda。
  IrExpression _transformAsLambda(FunctionNode func) {
    final closureId = ir.freshClosureId();
    final envClassName = 'ClosureEnv_${ir.closureContext}_$closureId';

    // Save async state — lambdas don't inherit async context from enclosing function
    final savedAsync = ir.insideAsyncFunction;
    final savedAsyncReturnType = ir.asyncInnerReturnType;
    final savedReturnType = ir.currentFunctionReturnType;
    ir.insideAsyncFunction = false;
    ir.asyncInnerReturnType = const IrDynamicType();

    final params = <IrClosureParam>[];
    for (final p in func.positionalParameters) {
      params.add(IrClosureParam(
        _cleanVarName(p.name),
        ir.typeTransformer.transform(p.type),
      ));
    }
    for (final p in func.namedParameters) {
      params.add(IrClosureParam(
        _cleanVarName(p.name),
        ir.typeTransformer.transform(p.type),
        defaultValue: p.initializer != null
            ? ir.expressionTransformer.transform(p.initializer!)
            : null,
      ));
    }

    final returnType = ir.typeTransformer.transform(func.returnType);
    ir.currentFunctionReturnType = returnType;
    final body = func.body != null
        ? ir.statementTransformer.transform(func.body!)
        : const IrBlockStmt([]);

    // Restore async state
    ir.insideAsyncFunction = savedAsync;
    ir.asyncInnerReturnType = savedAsyncReturnType;
    ir.currentFunctionReturnType = savedReturnType;

    // Collect type parameters (same as _transformAsClosure)
    final typeParams = <IrTypeParameterType>[
      ...ir.typeTransformer.transformTypeParameters(func.typeParameters),
    ];
    final seenTypeParamNames = typeParams.map((t) => t.name).toSet();
    for (final p in params) {
      _collectTypeParamRefs(p.type, typeParams, seenTypeParamNames);
    }
    _collectTypeParamRefs(returnType, typeParams, seenTypeParamNames);

    // Even no-capture lambdas need a ClosureEnv class for the emitter
    final closureClass = IrClosureClass(
      envClassName: envClassName,
      capturedFields: const [],
      params: params,
      callBody: body,
      returnType: returnType,
      typeParams: typeParams,
      arity: params.length,
      hasNamedParams: func.namedParameters.isNotEmpty,
    );
    ir.pendingClosureDecls.add(closureClass);

    return IrClosureExpr(
      envClassName: envClassName,
      capturedFields: const [],
      params: params,
      body: body,
      returnType: returnType,
      typeParams: typeParams,
      arity: params.length,
    );
  }

  /// 有捕获 → ClosureEnv 类 + _call 静态函数。
  IrExpression _transformAsClosure(
    FunctionNode func,
    CaptureAnalysis captureAnalysis,
    Set<VariableDeclaration> boxSet,
  ) {
    final closureId = ir.freshClosureId();
    final envClassName = 'ClosureEnv_${ir.closureContext}_$closureId';

    // 保存状态
    final savedBoxedVars = ir.boxedVars;
    final savedCapturedPrefix = ir.capturedVarEnvPrefix;
    final savedThisCaptured = ir.thisIsCapturedInEnv;
    final savedCurrentParams = ir.currentFunctionParams;
    final savedAsync = ir.insideAsyncFunction;
    final savedAsyncReturnType = ir.asyncInnerReturnType;

    // 设置新状态
    ir.boxedVars = {...ir.boxedVars, ...boxSet};
    // 保留已有的 env 前缀（从外层闭包继承），并添加新的
    ir.capturedVarEnvPrefix = Map.from(ir.capturedVarEnvPrefix);
    ir.thisIsCapturedInEnv = captureAnalysis.capturesThis;
    // Reset async state — closures don't inherit async context from enclosing function
    ir.insideAsyncFunction = false;
    ir.asyncInnerReturnType = const IrDynamicType();

    // 构建捕获字段列表
    final capturedFields = <IrCapturedField>[];

    // this 捕获
    if (captureAnalysis.capturesThis && ir.insideMethodBody) {
      IrType thisType = const IrDynamicType();
      if (ir.currentClass != null) {
        thisType = IrUserType(ir.currentClass!.name);
      }
      capturedFields.add(IrCapturedField(
        ir.thisReplacementName,
        thisType,
        isThis: true,
      ));
    }

    // 普通变量捕获
    for (final decl in captureAnalysis.capturedDecls) {
      final name = _cleanVarName(decl.name);
      final isBoxed = boxSet.contains(decl);
      final type = ir.typeTransformer.transform(decl.type);
      final boxType = isBoxed ? ir.typeTransformer.getBoxType(decl.type) : null;
      // 检查是否已有 env 前缀（从外层闭包继承）
      final existingEnvPrefix = ir.capturedVarEnvPrefix[decl];

      capturedFields.add(IrCapturedField(
        name,
        type,
        isBoxed: isBoxed,
        boxType: boxType,
        envPrefix: existingEnvPrefix,
      ));

      // 设置 env 前缀
      ir.capturedVarEnvPrefix[decl] = 'env';
    }

    // 构建参数列表
    final params = <IrClosureParam>[];
    for (final p in func.positionalParameters) {
      final name = _cleanVarName(p.name);
      final isBoxed = boxSet.contains(p);
      final type = ir.typeTransformer.transform(p.type);
      final boxType = isBoxed ? ir.typeTransformer.getBoxType(p.type) : null;
      params.add(IrClosureParam(
        name, type,
        isBoxed: isBoxed,
        boxType: boxType,
        defaultValue: p.initializer != null
            ? ir.expressionTransformer.transform(p.initializer!)
            : null,
      ));
    }

    // 转换函数体
    ir.currentFunctionParams = func.positionalParameters;

    // Set the current function return type before transforming the body
    final savedReturnType = ir.currentFunctionReturnType;
    final returnType = ir.typeTransformer.transform(func.returnType);
    ir.currentFunctionReturnType = returnType;

    final body = func.body != null
        ? ir.statementTransformer.transform(func.body!)
        : const IrBlockStmt([]);

    // 泛型类型参数（Dart 闭包类需要）
    // Collect from the closure's own type params + any type params
    // referenced by captured fields and params
    final typeParams = <IrTypeParameterType>[
      ...ir.typeTransformer.transformTypeParameters(func.typeParameters),
    ];
    // Scan captured fields and params for type parameter references
    final seenTypeParamNames = typeParams.map((t) => t.name).toSet();
    for (final field in capturedFields) {
      _collectTypeParamRefs(field.type, typeParams, seenTypeParamNames);
      if (field.boxType != null) {
        _collectTypeParamRefs(field.boxType!, typeParams, seenTypeParamNames);
      }
    }
    for (final p in params) {
      _collectTypeParamRefs(p.type, typeParams, seenTypeParamNames);
    }
    _collectTypeParamRefs(ir.typeTransformer.transform(func.returnType),
        typeParams, seenTypeParamNames);

    // 计算 arity
    final arity = func.namedParameters.isNotEmpty
        ? -1
        : func.positionalParameters.length;

    // 生成 ClosureClass 并加入待输出队列
    final closureClass = IrClosureClass(
      envClassName: envClassName,
      capturedFields: capturedFields,
      params: params,
      callBody: body,
      returnType: returnType,
      typeParams: typeParams,
      arity: arity,
      hasNamedParams: func.namedParameters.isNotEmpty,
    );
    ir.pendingClosureDecls.add(closureClass);

    // 恢复状态
    ir.boxedVars = savedBoxedVars;
    ir.capturedVarEnvPrefix = savedCapturedPrefix;
    ir.thisIsCapturedInEnv = savedThisCaptured;
    ir.currentFunctionParams = savedCurrentParams;
    ir.currentFunctionReturnType = savedReturnType;
    ir.insideAsyncFunction = savedAsync;
    ir.asyncInnerReturnType = savedAsyncReturnType;

    // 返回构造表达式
    return IrClosureExpr(
      envClassName: envClassName,
      capturedFields: capturedFields,
      params: params,
      body: body,
      returnType: returnType,
      typeParams: typeParams,
      arity: arity,
      hasNamedParams: func.namedParameters.isNotEmpty,
    );
  }

  String _cleanVarName(String? name) {
    if (name == null || name.isEmpty) return '_unnamed';
    var result = name;
    if (result.startsWith(':#')) result = result.substring(2);
    if (result.startsWith('#')) result = result.substring(1);
    result = result.replaceAll('#', '_').replaceAll(':', '_');
    // Prefix digit-starting names with underscore (e.g., `0_0` → `_0_0`)
    if (result.isNotEmpty && result.codeUnitAt(0) >= 0x30 && result.codeUnitAt(0) <= 0x39) {
      result = '_$result';
    }
    // Avoid Dart keywords
    if (result == 'this' || result == 'super' || result == 'null' ||
        result == 'true' || result == 'false') {
      return '${result}_';
    }
    return result;
  }

  /// Collect IrTypeParameterType references from a type tree.
  void _collectTypeParamRefs(
      IrType type,
      List<IrTypeParameterType> out,
      Set<String> seen) {
    if (type is IrTypeParameterType) {
      if (!seen.contains(type.name)) {
        seen.add(type.name);
        out.add(type);
      }
    } else if (type is IrUserType) {
      for (final ta in type.typeArgs) {
        _collectTypeParamRefs(ta, out, seen);
      }
    } else if (type is IrCollectionType) {
      for (final ta in type.typeArgs) {
        _collectTypeParamRefs(ta, out, seen);
      }
    } else if (type is IrPromiseType) {
      _collectTypeParamRefs(type.innerType, out, seen);
    } else if (type is IrFunctionType) {
      _collectTypeParamRefs(type.returnType, out, seen);
      for (final pt in type.paramTypes) {
        _collectTypeParamRefs(pt, out, seen);
      }
    } else if (type is IrNullableType) {
      _collectTypeParamRefs(type.inner, out, seen);
    } else if (type is IrBoxType) {
      if (type.innerType != null) {
        _collectTypeParamRefs(type.innerType!, out, seen);
      }
    }
  }
}
