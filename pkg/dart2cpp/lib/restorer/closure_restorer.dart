part of 'dart_restorer.dart';

// ============================================================================
// Closure Restorer: Async ClosureEnv generation for async→closure lowering
// ============================================================================

mixin _ClosureRestorer on _DartRestorerBase, _TypeUtils, _ExpressionRestorer, _StatementRestorer {
  /// 在 async _call 函数体末尾生成兜底的 promise complete 语句。
  /// 确保即使函数体没有显式 return，promise 也会完成。
  void _emitAsyncCompleteFallback(String innerReturnType) {
    final fallbackValue = _defaultPromiseValue(innerReturnType);
    _buf.write('${_pad}env._promise.complete($fallbackValue);\n');
    _buf.write('${_pad}return;\n');
  }

  // =========================================================================
  // Async ClosureEnv 生成：将 async 函数转为 ClosureEnv_ 闭包延迟执行模式
  // =========================================================================

  /// 生成 async 函数的 ClosureEnv 类 + 静态 call 函数，并输出包装函数体。
  ///
  /// [envBaseName] ClosureEnv 类名的基础部分（如 'foo'、'MyClass_doSomething'）
  /// [func] 函数的 FunctionNode
  /// [innerReturnType] async 函数的内部返回类型字符串（Future<T> 中的 T）
  /// [params] 需要提炼为 ClosureEnv 字段的参数列表（VariableDeclaration）
  /// [thisParam] 如果是实例方法，传入 this_ 的类型字符串（如 'MyClassValue<T>'），否则 null
  /// [boxedParams] 被 Box 化的参数列表
  void _emitAsyncClosureEnv({
    required String envBaseName,
    required FunctionNode func,
    required String innerReturnType,
    required List<VariableDeclaration> params,
    String? thisParam,
    List<VariableDeclaration> boxedParams = const [],
  }) {
    final closureId = _closureCounter++;
    final envClassName = 'ClosureEnv_${envBaseName}_$closureId';

    final declBuf = StringBuffer();

    // ---- 收集字段（基础类型自动装箱）----
    final fields = <_AsyncEnvField>[];

    // this_ 字段（实例方法）
    if (thisParam != null) {
      fields.add(_AsyncEnvField(name: 'this_', typeStr: thisParam));
    }

    // 函数参数字段：基础类型（int/double/bool/String/TypeParam）自动装箱
    for (final p in params) {
      final paramName = p.name!;
      final rawType = _restoreType(p.type);
      final boxType = _boxTypeNameFor(p.type);
      if (boxType != null) {
        fields.add(_AsyncEnvField(
          name: paramName,
          typeStr: boxType,
          isBoxed: true,
          boxType: boxType,
          rawType: rawType,
        ));
      } else {
        fields.add(_AsyncEnvField(name: paramName, typeStr: rawType));
      }
    }

    // _promise 字段
    fields.add(_AsyncEnvField(name: '_promise', typeStr: 'Promise<$innerReturnType>'));

    // ---- 生成 ClosureEnv 类 ----
    declBuf.write('class $envClassName {\n');

    // 字段声明
    for (final f in fields) {
      declBuf.write('  ${f.typeStr} ${f.name};\n');
    }

    // 构造函数：装箱字段接收原始类型并在初始化列表中装箱
    final ctorParams = <String>[];
    final initParts = <String>['_promise = Promise<$innerReturnType>()'];
    for (final f in fields) {
      if (f.name == '_promise') continue;
      if (f.isBoxed) {
        ctorParams.add('${f.rawType} ${f.name}');
        initParts.add('${f.name} = ${f.boxType}(${f.name})');
      } else {
        ctorParams.add('this.${f.name}');
      }
    }
    declBuf.write('  $envClassName(${ctorParams.join(', ')}) : ${initParts.join(', ')};\n');

    // call 方法：无参，转发到静态函数
    final staticCallName = '${envClassName}_call';
    declBuf.write('  void call() => $staticCallName(this);\n');

    declBuf.write('}\n');

    // ---- 生成静态 call 函数（包含原函数体）----
    declBuf.write('void $staticCallName($envClassName env)');

    // 生成函数体：需要把参数变量映射到 env. 前缀
    final savedEnvPrefix = Map<VariableDeclaration, String>.from(_capturedVarEnvPrefix);
    for (final p in params) {
      _capturedVarEnvPrefix[p] = 'env.';
    }

    // 将 async env 中装箱的基础类型参数加入 _boxedVars，
    // 使得 _restoreVarGet/Set 自动追加 .value
    final savedBoxedVarsForAsync = Set<VariableDeclaration>.from(_boxedVars);
    for (final p in params) {
      if (_boxTypeNameFor(p.type) != null) {
        _boxedVars.add(p);
      }
    }

    // 推入闭包上下文
    _pushClosureContext(envClassName);

    // 设置 async 标志
    final savedInsideAsync = _insideAsyncFunction;
    final savedAsyncInnerType = _asyncInnerReturnType;
    _insideAsyncFunction = true;
    _asyncInnerReturnType = innerReturnType;

    // 生成函数体到临时 buffer
    final oldBuf = _buf;
    final tmpBuf = StringBuffer();
    _buf = tmpBuf;

    final body = func.body!;
    if (body is Block) {
      _buf.write(' {\n');
      _indent++;
      // Box 化参数包装（来自外部 boxedParams，由 _preanalyzeBoxedVarsForFunc 识别的）
      for (final p in boxedParams) {
        // 跳过已在 env 字段中装箱的参数（避免重复装箱）
        if (_boxTypeNameFor(p.type) != null) continue;
        final baseName = p.name!;
        final boxType = _boxTypeNameFor(p.type)!;
        _buf.write('${_pad}$boxType $baseName = $boxType(${baseName}_raw);\n');
      }
      for (final s in body.statements) {
        _restoreStmt(s);
      }
      // 兜底：确保 promise 总会完成
      _emitAsyncCompleteFallback(innerReturnType);
      _indent--;
      _buf.write('$_pad}\n');
    } else {
      _buf.write(' {\n');
      _indent++;
      _restoreStmt(body);
      // 兜底：确保 promise 总会完成
      _emitAsyncCompleteFallback(innerReturnType);
      _indent--;
      _buf.write('$_pad}\n');
    }

    _buf = oldBuf;
    declBuf.write(tmpBuf);

    // 恢复状态
    _insideAsyncFunction = savedInsideAsync;
    _asyncInnerReturnType = savedAsyncInnerType;
    _popClosureContext();
    _capturedVarEnvPrefix.clear();
    _capturedVarEnvPrefix.addAll(savedEnvPrefix);
    _boxedVars.clear();
    _boxedVars.addAll(savedBoxedVarsForAsync);

    // 将闭包声明添加到待输出列表
    _pendingClosureDecls.add(declBuf.toString());

    // ---- 输出包装函数体（构造 env → setStartCallback → return promise）----
    _buf.write('{\n');
    _indent++;

    // 构造 env 的参数列表
    final envCtorArgs = <String>[];
    if (thisParam != null) {
      envCtorArgs.add('this_');
    }
    for (final p in params) {
      envCtorArgs.add(p.name!);
    }

    _buf.write('${_pad}final env = $envClassName(${envCtorArgs.join(', ')});\n');
    _buf.write('${_pad}env._promise.setStartCallback(env.call);\n');
    _buf.write('${_pad}return env._promise;\n');
    _indent--;
    _buf.write('$_pad}\n');
  }

  /// 生成 async 实例方法的 ClosureEnv 类 + 静态 call 函数，并输出包装函数体。
  ///
  /// 与 _emitAsyncClosureEnv 的区别：
  /// - 包装函数体中先做 this__ → this_ 的 cast
  /// - ClosureEnv 的静态 call 函数中设置 _insideMethodBody + this_ 通过 env.this_ 访问
  /// - [thisRawParam] 原始 this 参数名（如 'this__'），用于 cast
  void _emitAsyncClosureEnvForMethod({
    required String envBaseName,
    required FunctionNode func,
    required String innerReturnType,
    required List<VariableDeclaration> params,
    required String thisParam,
    required String thisRawParam,
    List<VariableDeclaration> boxedParams = const [],
    String classTypeParams = '',
  }) {
    final closureId = _closureCounter++;
    final envClassName = 'ClosureEnv_${envBaseName}_$closureId';
    final envClassWithTypeParams = '$envClassName$classTypeParams';

    final declBuf = StringBuffer();

    // ---- 收集字段（基础类型自动装箱）----
    final fields = <_AsyncEnvField>[];

    // this_ 字段
    fields.add(_AsyncEnvField(name: 'this_', typeStr: thisParam));

    // 函数参数字段：基础类型自动装箱
    for (final p in params) {
      final paramName = p.name!;
      final rawType = _restoreType(p.type);
      final boxType = _boxTypeNameFor(p.type);
      if (boxType != null) {
        fields.add(_AsyncEnvField(
          name: paramName,
          typeStr: boxType,
          isBoxed: true,
          boxType: boxType,
          rawType: rawType,
        ));
      } else {
        fields.add(_AsyncEnvField(name: paramName, typeStr: rawType));
      }
    }

    // _promise 字段
    fields.add(_AsyncEnvField(name: '_promise', typeStr: 'Promise<$innerReturnType>'));

    // ---- 生成 ClosureEnv 类 ----
    declBuf.write('class $envClassWithTypeParams {\n');
    for (final f in fields) {
      declBuf.write('  ${f.typeStr} ${f.name};\n');
    }

    // 构造函数：装箱字段接收原始类型并在初始化列表中装箱
    final ctorParams = <String>[];
    final initParts = <String>['_promise = Promise<$innerReturnType>()'];
    for (final f in fields) {
      if (f.name == '_promise') continue;
      if (f.isBoxed) {
        ctorParams.add('${f.rawType} ${f.name}');
        initParts.add('${f.name} = ${f.boxType}(${f.name})');
      } else {
        ctorParams.add('this.${f.name}');
      }
    }
    declBuf.write('  $envClassName(${ctorParams.join(', ')}) : ${initParts.join(', ')};\n');

    final staticCallName = '${envClassName}_call';
    declBuf.write('  void call() => $staticCallName$classTypeParams(this);\n');
    declBuf.write('}\n');

    // ---- 生成静态 call 函数（包含原函数体）----
    declBuf.write('void $staticCallName$classTypeParams($envClassWithTypeParams env)');

    // 设置 env 前缀映射：参数通过 env. 访问
    final savedEnvPrefix = Map<VariableDeclaration, String>.from(_capturedVarEnvPrefix);
    for (final p in params) {
      _capturedVarEnvPrefix[p] = 'env.';
    }

    // 将 async env 中装箱的基础类型参数加入 _boxedVars
    final savedBoxedVarsForAsync = Set<VariableDeclaration>.from(_boxedVars);
    for (final p in params) {
      if (_boxTypeNameFor(p.type) != null) {
        _boxedVars.add(p);
      }
    }

    // 设置 this 捕获标志：this_ 通过 env.this_ 访问
    final savedThisInEnv = _thisIsCapturedInEnv;
    _thisIsCapturedInEnv = true;

    _pushClosureContext(envClassName);

    final savedInsideAsync = _insideAsyncFunction;
    final savedAsyncInnerType = _asyncInnerReturnType;
    _insideAsyncFunction = true;
    _asyncInnerReturnType = innerReturnType;

    // 生成函数体到临时 buffer
    final oldBuf = _buf;
    final tmpBuf = StringBuffer();
    _buf = tmpBuf;

    final body = func.body!;
    if (body is Block) {
      _buf.write(' {\n');
      _indent++;
      for (final p in boxedParams) {
        // 跳过已在 env 字段中装箱的参数
        if (_boxTypeNameFor(p.type) != null) continue;
        final baseName = p.name!;
        final boxType = _boxTypeNameFor(p.type)!;
        _buf.write('$_pad$boxType $baseName = $boxType(${baseName}_raw);\n');
      }
      for (final s in body.statements) {
        _restoreStmt(s);
      }
      // 兜底：确保 promise 总会完成（即使函数体没有显式 return）
      _emitAsyncCompleteFallback(innerReturnType);
      _indent--;
      _buf.write('$_pad}\n');
    } else {
      _buf.write(' {\n');
      _indent++;
      _restoreStmt(body);
      // 兜底：确保 promise 总会完成
      _emitAsyncCompleteFallback(innerReturnType);
      _indent--;
      _buf.write('$_pad}\n');
    }

    _buf = oldBuf;
    declBuf.write(tmpBuf);

    // 恢复状态
    _insideAsyncFunction = savedInsideAsync;
    _asyncInnerReturnType = savedAsyncInnerType;
    _popClosureContext();
    _capturedVarEnvPrefix.clear();
    _capturedVarEnvPrefix.addAll(savedEnvPrefix);
    _boxedVars.clear();
    _boxedVars.addAll(savedBoxedVarsForAsync);
    _thisIsCapturedInEnv = savedThisInEnv;

    _pendingClosureDecls.add(declBuf.toString());

    // ---- 输出包装函数体 ----
    _buf.write('{\n');
    _indent++;

    // 先做 this__ → this_ cast
    _buf.write('${_pad}final this_ = $thisRawParam as $thisParam;\n');

    // 构造 env
    final envCtorArgs = <String>['this_'];
    for (final p in params) {
      envCtorArgs.add(p.name!);
    }

    _buf.write('${_pad}final env = $envClassWithTypeParams(${envCtorArgs.join(', ')});\n');
    _buf.write('${_pad}env._promise.setStartCallback(env.call);\n');
    _buf.write('${_pad}return env._promise;\n');
    _indent--;
    _buf.write('$_pad}\n');
  }
}

/// async ClosureEnv 字段描述
class _AsyncEnvField {
  final String name;
  final String typeStr;
  /// 是否为装箱字段（基础类型参数需装箱以支持 C++ 引用语义）
  final bool isBoxed;
  /// 装箱类型名（如 IntBox、StringBox 等），isBoxed 为 true 时有效
  final String? boxType;
  /// 原始类型（未装箱时的类型），isBoxed 为 true 时有效
  final String? rawType;
  _AsyncEnvField({
    required this.name,
    required this.typeStr,
    this.isBoxed = false,
    this.boxType,
    this.rawType,
  });
}
