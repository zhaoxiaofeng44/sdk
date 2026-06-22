/// Dart→C++ 闭包生成器
///
/// 将 Dart 闭包（FunctionExpression）转换为 C++ ClosureEnv struct + _call 函数：
/// - 捕获分析（analyzeCaptures）
/// - Box 化预分析（preanalyzeBoxedVars）
/// - ClosureEnv struct 生成（含 gcMark）
/// - _new 构造函数
/// - _call 静态函数
/// - async 闭包模式（Promise + setStartCallback）
///
/// 镜像 `lib/restorer/expression_restorer.dart` 的闭包部分。
library;

import 'package:kernel/kernel.dart';
import 'package:kernel/ast.dart';

import 'type_mapper.dart';
import 'class_info_collector.dart';
import 'cpp_emitter.dart';

// ============================================================================
// 数据结构
// ============================================================================

/// 捕获变量信息
class CapturedVar {
  final String name;       // C++ 字段名
  final String cppType;    // C++ 类型（可能是 Box 类型）
  final bool isThis;       // 是否是 this 捕获
  final bool isBoxed;      // 是否需要 Box 化

  CapturedVar({
    required this.name,
    required this.cppType,
    this.isThis = false,
    this.isBoxed = false,
  });
}

/// 捕获分析结果
class CaptureAnalysis {
  final List<VariableDeclaration> capturedDecls;
  final bool capturesThis;

  CaptureAnalysis({
    required this.capturedDecls,
    required this.capturesThis,
  });
}

// ============================================================================
// 闭包生成器
// ============================================================================

/// C++ 闭包生成器。
class ClosureEmitter {
  final CppEmitter emitter;
  final TypeMapper typeMapper;
  final ClassInfo classInfo;

  ClosureEmitter(this.emitter, this.typeMapper, this.classInfo);

  // ============================================================================
  // 主入口：生成 ClosureEnv struct + _new + _call
  // ============================================================================

  /// 生成闭包的完整 C++ 代码，返回构造表达式
  String emitClosure(
    FunctionNode func,
    String contextName,
  ) {
    // 1. 捕获分析
    final analysis = analyzeCaptures(func);
    final capturedDecls = analysis.capturedDecls;
    final capturesThis = analysis.capturesThis;

    // 2. Box 预分析
    preanalyzeBoxedVars(func);

    // 3. 生成唯一名称
    final closureId = emitter.nextClosureId();
    final envClassName = 'ClosureEnv_${contextName}_$closureId';

    // 4. 构建捕获字段列表
    final capturedFields = <CapturedVar>[];

    // this 捕获
    if (capturesThis && emitter.insideMethodBody) {
      capturedFields.add(CapturedVar(
        name: emitter.thisReplacementName,
        cppType: 'VPtr*',
        isThis: true,
      ));
    }

    // 普通变量捕获
    for (final decl in capturedDecls) {
      final varName = typeMapper.cleanIdentifier(decl.name ?? '_cap');
      final isBoxed = emitter.boxedVars.contains(decl);
      final cppType = isBoxed
          ? '${typeMapper.boxTypeNameFor(decl.type)}*'
          : typeMapper.cppType(decl.type);
      capturedFields.add(CapturedVar(
        name: varName,
        cppType: cppType,
        isBoxed: isBoxed,
      ));
    }

    // 5. 设置捕获变量前缀（用于闭包体内的变量访问）
    for (final decl in capturedDecls) {
      emitter.capturedVarEnvPrefix[decl] = 'env->';
    }
    emitter.thisIsCapturedInEnv = capturesThis;

    // 6. 生成 ClosureEnv struct 声明（延迟到末尾输出）
    final structDecl = _buildClosureEnvStruct(
      envClassName,
      capturedFields,
      func,
    );
    emitter.addClosureDecl(structDecl);

    // 7. 生成 _call 函数体（延迟到末尾输出，在 struct 声明之后）
    final callBody = buildClosureCallBody(
      envClassName,
      capturedFields,
      func,
    );
    emitter.addClosureCallBody(callBody);

    // 8. 返回构造表达式
    final ctorArgs = capturedFields.map((f) {
      if (f.isThis) return emitter.thisReplacementName;
      if (f.isBoxed) {
        // Box 化变量在外层已经是 Box
        return f.name;
      }
      return f.name;
    }).join(', ');

    // 恢复状态
    for (final decl in capturedDecls) {
      emitter.capturedVarEnvPrefix.remove(decl);
    }
    emitter.thisIsCapturedInEnv = false;

    return '${envClassName}_new(GC::allocateLocal(new $envClassName())${ctorArgs.isNotEmpty ? ', $ctorArgs' : ''})';
  }

  // ============================================================================
  // 捕获分析
  // ============================================================================

  /// 分析 FunctionNode 捕获的外部变量
  CaptureAnalysis analyzeCaptures(FunctionNode func) {
    final localDecls = <VariableDeclaration>{};
    localDecls.addAll(func.positionalParameters);
    localDecls.addAll(func.namedParameters);

    final capturedSet = <VariableDeclaration>{};
    bool capturesThis = false;

    if (func.body != null) {
      _collectCaptured(func.body!, localDecls, capturedSet, () {
        capturesThis = true;
      });
    }

    return CaptureAnalysis(
      capturedDecls: capturedSet.toList(),
      capturesThis: capturesThis,
    );
  }

  void _collectCaptured(
    TreeNode node,
    Set<VariableDeclaration> localDecls,
    Set<VariableDeclaration> captured,
    void Function() onThisCaptured,
  ) {
    if (node is VariableDeclaration) {
      localDecls.add(node);
      if (node.initializer != null) {
        _collectCaptured(node.initializer!, localDecls, captured, onThisCaptured);
      }
      return;
    }

    if (node is VariableGet) {
      if (!localDecls.contains(node.variable)) {
        captured.add(node.variable);
      }
      return;
    }

    if (node is VariableSet) {
      if (!localDecls.contains(node.variable)) {
        captured.add(node.variable);
      }
      _collectCaptured(node.value, localDecls, captured, onThisCaptured);
      return;
    }

    if (node is ThisExpression) {
      onThisCaptured();
      return;
    }

    if (node is FunctionExpression) {
      // 嵌套闭包：冒泡捕获
      final innerLocalDecls = <VariableDeclaration>{};
      innerLocalDecls.addAll(node.function.positionalParameters);
      innerLocalDecls.addAll(node.function.namedParameters);

      final innerCaptured = <VariableDeclaration>{};
      bool innerCapturesThis = false;

      if (node.function.body != null) {
        _collectCaptured(node.function.body!, innerLocalDecls, innerCaptured, () {
          innerCapturesThis = true;
        });
      }

      for (final decl in innerCaptured) {
        if (!localDecls.contains(decl)) {
          captured.add(decl);
        }
      }
      if (innerCapturesThis) {
        onThisCaptured();
      }
      return;
    }

    // 递归遍历子节点
    _visitChildrenForCapture(node, localDecls, captured, onThisCaptured);
  }

  void _visitChildrenForCapture(
    TreeNode node,
    Set<VariableDeclaration> localDecls,
    Set<VariableDeclaration> captured,
    void Function() onThisCaptured,
  ) {
    void visit(TreeNode child) {
      _collectCaptured(child, localDecls, captured, onThisCaptured);
    }

    if (node is Block) {
      for (final s in node.statements) visit(s);
    } else if (node is ExpressionStatement) {
      visit(node.expression);
    } else if (node is ReturnStatement) {
      if (node.expression != null) visit(node.expression!);
    } else if (node is IfStatement) {
      visit(node.condition);
      visit(node.then);
      if (node.otherwise != null) visit(node.otherwise!);
    } else if (node is ForStatement) {
      for (final v in node.variables) visit(v);
      if (node.condition != null) visit(node.condition!);
      for (final u in node.updates) visit(u);
      visit(node.body);
    } else if (node is ForInStatement) {
      visit(node.variable);
      visit(node.iterable);
      visit(node.body);
    } else if (node is WhileStatement) {
      visit(node.condition);
      visit(node.body);
    } else if (node is DoStatement) {
      visit(node.body);
      visit(node.condition);
    } else if (node is TryCatch) {
      visit(node.body);
      for (final c in node.catches) visit(c.body);
    } else if (node is TryFinally) {
      visit(node.body);
      visit(node.finalizer);
    } else if (node is SwitchStatement) {
      visit(node.expression);
      for (final c in node.cases) visit(c.body);
    } else if (node is Let) {
      visit(node.variable);
      visit(node.body);
    } else if (node is BlockExpression) {
      visit(node.body);
      visit(node.value);
    } else if (node is InstanceInvocation) {
      visit(node.receiver);
      for (final a in node.arguments.positional) visit(a);
      for (final a in node.arguments.named) visit(a.value);
    } else if (node is StaticInvocation) {
      for (final a in node.arguments.positional) visit(a);
      for (final a in node.arguments.named) visit(a.value);
    } else if (node is ConstructorInvocation) {
      for (final a in node.arguments.positional) visit(a);
      for (final a in node.arguments.named) visit(a.value);
    } else if (node is FunctionInvocation) {
      visit(node.receiver);
      for (final a in node.arguments.positional) visit(a);
      for (final a in node.arguments.named) visit(a.value);
    } else if (node is ConditionalExpression) {
      visit(node.condition);
      visit(node.then);
      visit(node.otherwise);
    } else if (node is LogicalExpression) {
      visit(node.left);
      visit(node.right);
    } else if (node is Not) {
      visit(node.operand);
    } else if (node is StringConcatenation) {
      for (final e in node.expressions) visit(e);
    } else if (node is IsExpression) {
      visit(node.operand);
    } else if (node is AsExpression) {
      visit(node.operand);
    } else if (node is InstanceGet) {
      visit(node.receiver);
    } else if (node is InstanceSet) {
      visit(node.receiver);
      visit(node.value);
    } else if (node is Throw) {
      visit(node.expression);
    } else if (node is ListLiteral) {
      for (final e in node.expressions) visit(e);
    } else if (node is SetLiteral) {
      for (final e in node.expressions) visit(e);
    } else if (node is MapLiteral) {
      for (final e in node.entries) {
        visit(e.key);
        visit(e.value);
      }
    } else if (node is SuperMethodInvocation) {
      for (final a in node.arguments.positional) visit(a);
      for (final a in node.arguments.named) visit(a.value);
    } else if (node is AwaitExpression) {
      visit(node.operand);
    }
  }

  // ============================================================================
  // Box 预分析
  // ============================================================================

  /// 预分析：识别哪些参数/局部变量被嵌套闭包捕获且需要 Box 化
  void preanalyzeBoxedVars(FunctionNode func) {
    if (func.body == null) return;

    // 收集本层所有候选变量
    final localOfThisLevel = <VariableDeclaration>{};
    localOfThisLevel.addAll(func.positionalParameters);
    localOfThisLevel.addAll(func.namedParameters);
    _collectShallowDecls(func.body!, localOfThisLevel);

    // 收集所有嵌套闭包
    final innerClosures = <FunctionExpression>[];
    _collectAllFunctionExpressions(func.body!, innerClosures);

    // 排除命名参数
    final namedParamSet = <VariableDeclaration>{};
    namedParamSet.addAll(func.namedParameters);

    for (final fe in innerClosures) {
      final analysis = analyzeCaptures(fe.function);
      for (final captured in analysis.capturedDecls) {
        if (!localOfThisLevel.contains(captured)) continue;
        if (namedParamSet.contains(captured)) continue;
        // for 循环变量排除
        final parent = captured.parent;
        if (parent is ForStatement && parent.variables.contains(captured)) continue;
        // 只对基础值类型装箱
        if (!_needsBoxing(captured.type)) continue;
        emitter.boxedVars.add(captured);
      }
    }
  }

  void _collectShallowDecls(TreeNode node, Set<VariableDeclaration> out) {
    if (node is FunctionExpression) return;
    if (node is FunctionDeclaration) {
      out.add(node.variable);
      return;
    }
    if (node is VariableDeclaration) {
      out.add(node);
      if (node.initializer != null) {
        _collectShallowDecls(node.initializer!, out);
      }
      return;
    }
    _visitChildrenForShallowDecls(node, out);
  }

  void _visitChildrenForShallowDecls(TreeNode node, Set<VariableDeclaration> out) {
    void visit(TreeNode child) => _collectShallowDecls(child, out);

    if (node is Block) {
      for (final s in node.statements) visit(s);
    } else if (node is ExpressionStatement) {
      visit(node.expression);
    } else if (node is ReturnStatement) {
      if (node.expression != null) visit(node.expression!);
    } else if (node is IfStatement) {
      visit(node.condition);
      visit(node.then);
      if (node.otherwise != null) visit(node.otherwise!);
    } else if (node is ForStatement) {
      for (final v in node.variables) visit(v);
      if (node.condition != null) visit(node.condition!);
      for (final u in node.updates) visit(u);
      visit(node.body);
    } else if (node is ForInStatement) {
      visit(node.variable);
      visit(node.iterable);
      visit(node.body);
    } else if (node is WhileStatement) {
      visit(node.condition);
      visit(node.body);
    } else if (node is DoStatement) {
      visit(node.body);
      visit(node.condition);
    } else if (node is TryCatch) {
      visit(node.body);
      for (final c in node.catches) visit(c.body);
    } else if (node is TryFinally) {
      visit(node.body);
      visit(node.finalizer);
    } else if (node is SwitchStatement) {
      visit(node.expression);
      for (final c in node.cases) visit(c.body);
    }
  }

  void _collectAllFunctionExpressions(
      TreeNode node, List<FunctionExpression> out) {
    if (node is FunctionExpression) {
      out.add(node);
      // 继续递归内部
    }
    if (node is Block) {
      for (final s in node.statements) {
        _collectAllFunctionExpressions(s, out);
      }
    } else if (node is ExpressionStatement) {
      _collectAllFunctionExpressions(node.expression, out);
    } else if (node is ReturnStatement) {
      if (node.expression != null) {
        _collectAllFunctionExpressions(node.expression!, out);
      }
    } else if (node is VariableDeclaration) {
      if (node.initializer != null) {
        _collectAllFunctionExpressions(node.initializer!, out);
      }
    } else if (node is IfStatement) {
      _collectAllFunctionExpressions(node.condition, out);
      _collectAllFunctionExpressions(node.then, out);
      if (node.otherwise != null) {
        _collectAllFunctionExpressions(node.otherwise!, out);
      }
    } else if (node is ForStatement) {
      for (final v in node.variables) {
        _collectAllFunctionExpressions(v, out);
      }
      if (node.condition != null) {
        _collectAllFunctionExpressions(node.condition!, out);
      }
      for (final u in node.updates) {
        _collectAllFunctionExpressions(u, out);
      }
      _collectAllFunctionExpressions(node.body, out);
    } else if (node is WhileStatement) {
      _collectAllFunctionExpressions(node.condition, out);
      _collectAllFunctionExpressions(node.body, out);
    } else if (node is DoStatement) {
      _collectAllFunctionExpressions(node.body, out);
      _collectAllFunctionExpressions(node.condition, out);
    } else if (node is ConditionalExpression) {
      _collectAllFunctionExpressions(node.condition, out);
      _collectAllFunctionExpressions(node.then, out);
      _collectAllFunctionExpressions(node.otherwise, out);
    } else if (node is LogicalExpression) {
      _collectAllFunctionExpressions(node.left, out);
      _collectAllFunctionExpressions(node.right, out);
    } else if (node is InstanceInvocation) {
      _collectAllFunctionExpressions(node.receiver, out);
      for (final a in node.arguments.positional) {
        _collectAllFunctionExpressions(a, out);
      }
    } else if (node is StaticInvocation) {
      for (final a in node.arguments.positional) {
        _collectAllFunctionExpressions(a, out);
      }
    } else if (node is FunctionInvocation) {
      _collectAllFunctionExpressions(node.receiver, out);
      for (final a in node.arguments.positional) {
        _collectAllFunctionExpressions(a, out);
      }
    }
  }

  bool _needsBoxing(DartType type) {
    return typeMapper.isPrimitiveValueType(type) || type is TypeParameterType;
  }

  // ============================================================================
  // 生成 ClosureEnv struct 声明
  // ============================================================================

  String _buildClosureEnvStruct(
    String envClassName,
    List<CapturedVar> capturedFields,
    FunctionNode func,
  ) {
    final buf = StringBuffer();

    final retType = typeMapper.cppType(func.returnType);
    final arity = func.positionalParameters.length;
    final paramTypes = func.positionalParameters
        .map((p) => typeMapper.cppType(p.type))
        .join(', ');

    // struct 声明
    buf.writeln('struct $envClassName : TypeFunction$arity<$retType${paramTypes.isNotEmpty ? ', $paramTypes' : ''}> {');

    // 字段
    for (final f in capturedFields) {
      buf.writeln('    ${f.cppType} ${f.name}{};');
    }

    // 构造函数
    buf.writeln('    $envClassName() {}');

    // gcMark
    if (capturedFields.isNotEmpty) {
      buf.writeln();
      buf.writeln('    void gcMark(int flag) override {');
      buf.writeln('        if (gcFlag == flag) return;');
      buf.writeln('        TypeFunction::gcMark(flag);');
      for (final f in capturedFields) {
        if (f.cppType.endsWith('*')) {
          buf.writeln('        if (${f.name}) ${f.name}->gcMark(flag);');
        }
      }
      buf.writeln('    }');
    }

    buf.writeln('};');
    buf.writeln();

    // _new 构造函数
    final newParams = ['$envClassName* env_',
      ...capturedFields.map((f) => '${f.cppType} ${f.name}')
    ].join(', ');
    buf.writeln('$envClassName* ${envClassName}_new($newParams) {');
    for (final f in capturedFields) {
      buf.writeln('    env_->${f.name} = ${f.name};');
    }
    buf.writeln('    env_->closureCall = reinterpret_cast<void*>(&${envClassName}_call);');
    buf.writeln('    GC::allocateLocal(env_);');
    buf.writeln('    return env_;');
    buf.writeln('}');
    buf.writeln();

    // _call 静态函数 — 需要在主生成阶段后单独输出（因为引用了 emitter 子系统）
    // 先只生成前向声明，实际函数体在 _buildClosureCallFunc 中生成
    final callParams = ['AnyPtr env__',
      ...func.positionalParameters.map((p) {
        final cppType = typeMapper.cppType(p.type);
        final name = typeMapper.cleanIdentifier(p.name ?? '_p');
        return '$cppType $name';
      })
    ].join(', ');
    buf.writeln('$retType ${envClassName}_call($callParams);');
    buf.writeln();

    return buf.toString();
  }

  // ============================================================================
  // async 闭包模式
  // ============================================================================

  /// 为 async 函数生成 ClosureEnv（含 Promise）
  String emitAsyncClosureEnv(
    FunctionNode func,
    String contextName,
    String innerReturnType,
  ) {
    final closureId = emitter.nextClosureId();
    final envClassName = 'ClosureEnv_${contextName}_$closureId';

    // 捕获分析
    final analysis = analyzeCaptures(func);
    final capturedDecls = analysis.capturedDecls;
    final capturesThis = analysis.capturesThis;

    // 构建字段
    final capturedFields = <CapturedVar>[];
    if (capturesThis && emitter.insideMethodBody) {
      capturedFields.add(CapturedVar(
        name: emitter.thisReplacementName,
        cppType: 'VPtr*',
        isThis: true,
      ));
    }
    for (final decl in capturedDecls) {
      final varName = typeMapper.cleanIdentifier(decl.name ?? '_cap');
      final isBoxed = emitter.boxedVars.contains(decl);
      final cppType = isBoxed
          ? '${typeMapper.boxTypeNameFor(decl.type)}*'
          : typeMapper.cppType(decl.type);
      capturedFields.add(CapturedVar(
        name: varName,
        cppType: cppType,
        isBoxed: isBoxed,
      ));
    }

    // 生成 struct 声明
    final structDecl = _buildAsyncClosureEnvStruct(
      envClassName,
      capturedFields,
      func,
      innerReturnType,
    );
    emitter.addClosureDecl(structDecl);

    // 生成 _call 函数体（延迟到末尾输出）
    final callBody = buildAsyncClosureCallBody(
      envClassName,
      capturedFields,
      func,
      innerReturnType,
    );
    emitter.addClosureCallBody(callBody);

    // 返回构造表达式
    final ctorArgs = capturedFields.map((f) {
      if (f.isThis) return emitter.thisReplacementName;
      return f.name;
    }).join(', ');

    return '${envClassName}_new(GC::allocateLocal(new $envClassName())${ctorArgs.isNotEmpty ? ', $ctorArgs' : ''})';
  }

  String _buildAsyncClosureEnvStruct(
    String envClassName,
    List<CapturedVar> capturedFields,
    FunctionNode func,
    String innerReturnType,
  ) {
    final buf = StringBuffer();

    // struct 声明
    buf.writeln('struct $envClassName : AnyGC {');
    buf.writeln('    Promise<$innerReturnType>* _promise;');
    for (final f in capturedFields) {
      buf.writeln('    ${f.cppType} ${f.name}{};');
    }
    buf.writeln();
    buf.writeln('    $envClassName() {');
    buf.writeln('        _promise = GC::allocateLocal(new Promise<$innerReturnType>());');
    buf.writeln('    }');
    buf.writeln();
    buf.writeln('    void call() { ${envClassName}_call(this); }');

    // gcMark
    buf.writeln();
    buf.writeln('    void gcMark(int flag) override {');
    buf.writeln('        if (gcFlag == flag) return;');
    buf.writeln('        AnyGC::gcMark(flag);');
    buf.writeln('        if (_promise) _promise->gcMark(flag);');
    for (final f in capturedFields) {
      if (f.cppType.endsWith('*')) {
        buf.writeln('        if (${f.name}) ${f.name}->gcMark(flag);');
      }
    }
    buf.writeln('    }');

    buf.writeln('};');
    buf.writeln();

    // _new 构造函数
    final newParams = ['$envClassName* env_',
      ...capturedFields.map((f) => '${f.cppType} ${f.name}')
    ].join(', ');
    buf.writeln('$envClassName* ${envClassName}_new($newParams) {');
    for (final f in capturedFields) {
      buf.writeln('    env_->${f.name} = ${f.name};');
    }
    buf.writeln('    GC::allocateLocal(env_);');
    buf.writeln('    return env_;');
    buf.writeln('}');
    buf.writeln();

    // _call 静态函数前向声明（async 体）
    buf.writeln('void ${envClassName}_call($envClassName* env);');
    buf.writeln();

    return buf.toString();
  }

  /// 为同步闭包生成 _call 函数体（延迟输出）
  String buildClosureCallBody(
    String envClassName,
    List<CapturedVar> capturedFields,
    FunctionNode func,
  ) {
    final buf = StringBuffer();
    final retType = typeMapper.cppType(func.returnType);
    final callParams = ['AnyPtr env__',
      ...func.positionalParameters.map((p) {
        final cppType = typeMapper.cppType(p.type);
        final name = typeMapper.cleanIdentifier(p.name ?? '_p');
        return '$cppType $name';
      })
    ].join(', ');

    buf.writeln('$retType ${envClassName}_call($callParams) {');
    buf.writeln('    auto env = static_cast<$envClassName*>(env__.toTypeFunction());');

    // 设置闭包体内捕获变量前缀
    for (final f in capturedFields) {
      if (f.isThis) continue;
      // 捕获变量通过 env-> 访问
    }

    // 生成闭包体
    if (func.body != null) {
      // 使用 emitter 的 statement 生成器
      // 设置闭包上下文
      final savedInsideMethodBody = emitter.insideMethodBody;
      final savedThisReplacement = emitter.thisReplacementName;
      final savedCapturedPrefix = Map<VariableDeclaration, String>.from(emitter.capturedVarEnvPrefix);

      // env->this_ 作为 this 替换
      if (capturedFields.any((f) => f.isThis)) {
        emitter.insideMethodBody = true;
        emitter.thisReplacementName = 'env->this_';
      }

      // 生成函数体
      emitter.writeToBuffer(buf);
      emitter.statementEmitter.emit(func.body!);
      emitter.restoreMainBuffer();

      // 恢复上下文
      emitter.insideMethodBody = savedInsideMethodBody;
      emitter.thisReplacementName = savedThisReplacement;
      emitter.capturedVarEnvPrefix.clear();
      emitter.capturedVarEnvPrefix.addAll(savedCapturedPrefix);
    }

    if (retType != 'void' && func.body != null) {
      // 如果方法体没有显式 return，需要补一个默认返回值
      // 检查函数体最后一条语句是否是 ReturnStatement
      final body = func.body!;
      if (!_bodyHasExplicitReturn(body)) {
        buf.writeln('    return ${_defaultReturnValue(retType)};');
      }
    }

    buf.writeln('}');
    buf.writeln();

    return buf.toString();
  }

  /// 检查语句体是否包含显式 return 语句
  bool _bodyHasExplicitReturn(Statement body) {
    if (body is ReturnStatement) return true;
    if (body is Block) {
      if (body.statements.isEmpty) return false;
      // 检查最后一条语句
      final last = body.statements.last;
      return _bodyHasExplicitReturn(last);
    }
    if (body is IfStatement) {
      // if-else 如果两个分支都有return，则视为有return
      final thenReturn = _bodyHasExplicitReturn(body.then);
      final elseReturn = body.otherwise != null
          ? _bodyHasExplicitReturn(body.otherwise!) : false;
      return thenReturn && elseReturn;
    }
    return false;
  }

  /// 根据返回类型生成默认返回值
  String _defaultReturnValue(String retType) {
    if (retType == 'int64_t') return '0';
    if (retType == 'double') return '0.0';
    if (retType == 'bool') return 'false';
    if (retType == 'std::string') return '"\""';
    if (retType == 'AnyPtr') return 'AnyPtr()';
    if (retType.startsWith('StaticList')) return 'StaticList<AnyPtr>::empty()';
    if (retType.startsWith('StaticSet')) return 'StaticSet<AnyPtr>::empty()';
    if (retType.startsWith('StaticMap')) return 'StaticMap<AnyPtr, AnyPtr>::empty()';
    if (retType.startsWith('Promise')) return 'nullptr';
    if (retType.endsWith('*')) return 'nullptr';
    return 'AnyPtr()';
  }

  /// 为 async 闭包生成 _call 函数体（延迟输出）
  String buildAsyncClosureCallBody(
    String envClassName,
    List<CapturedVar> capturedFields,
    FunctionNode func,
    String innerReturnType,
  ) {
    final buf = StringBuffer();

    buf.writeln('void ${envClassName}_call($envClassName* env) {');

    // 设置 async 上下文
    final savedInsideAsync = emitter.insideAsyncFunction;
    final savedAsyncReturnType = emitter.asyncInnerReturnType;
    emitter.insideAsyncFunction = true;
    emitter.asyncInnerReturnType = innerReturnType;

    // 生成函数体
    if (func.body != null) {
      emitter.writeToBuffer(buf);
      emitter.statementEmitter.emit(func.body!);
      emitter.restoreMainBuffer();
    }

    // 恢复上下文
    emitter.insideAsyncFunction = savedInsideAsync;
    emitter.asyncInnerReturnType = savedAsyncReturnType;

    buf.writeln('}');
    buf.writeln();

    return buf.toString();
  }
}
