part of 'dart_restorer.dart';

// ============================================================================
// Declaration Restorer: Handles type definitions, classes, fields, and methods
// ============================================================================

mixin _DeclarationRestorer on _DartRestorerBase, _TypeUtils, _ExpressionRestorer, _StatementRestorer, _ClosureRestorer {
  // ---- VTable 字段名工具方法 ----
  // _vtableFieldName 已移至 _DartRestorerBase 基类中

  // ---- Typedef ----

  void _restoreTypedef(Typedef td) {
    _buf.write('typedef ${td.name}');
    _writeTypeParams(td.typeParameters);
    _buf.write(' = ');
    _buf.write(_restoreType(td.type!));
    _buf.write(';\n\n');
  }

  // ---- Mixin ----

  void _restoreMixin(Class cls) {
    // 为 mixin 生成静态函数，供委托函数调用
    // mixin 不生成 XValue 类和构造函数，只生成方法的静态函数
    _buf.write('// mixin ${cls.name} → static functions for delegation\n');

    // Bug 19: mixin 的静态字段也需要提升到模块级（与用户类一致）
    _emitStaticFields(cls, cls.name);
    
    _currentClass = cls;
    final mixinName = cls.name;
    
    for (final proc in cls.procedures) {
      if (proc.isStatic || proc.isFactory || proc.isAbstract) continue;
      // 只生成有方法体的非抽象方法
      if (proc.function.body == null || proc.function.body is EmptyStatement) continue;
      
      // 生成静态函数，this_ 类型使用 dynamic（因为 mixin 可以被任何类使用）
      _emitMixinMethodAsStatic(cls, proc, mixinName);
    }
    
    _currentClass = null;
    _buf.write('\n');
  }
  
  /// 为 mixin 方法生成静态函数
  /// this_ 类型使用 dynamic，因为 mixin 可以被任何类使用
  void _emitMixinMethodAsStatic(Class cls, Procedure proc, String mixinName) {
    final methodName = proc.name.text;
    String funcName;
    if (proc.isGetter) {
      funcName = _staticGetterName(mixinName, methodName);
    } else if (proc.isSetter) {
      funcName = _staticSetterName(mixinName, methodName);
    } else {
      funcName = _staticMethodName(mixinName, methodName);
    }
    
    final returnType = _asyncAwareRestoreType(proc.function.returnType, proc.function.asyncMarker);
    
    _buf.write('$returnType $funcName');
    // 类型参数声明：mixin 类的类型参数 + 方法自身的类型参数
    _writeCombinedTypeParams(cls.typeParameters, proc.function.typeParameters);
    _buf.write('(AnyGC this__');
    
    if (proc.isSetter) {
      if (proc.function.positionalParameters.isNotEmpty) {
        final p = proc.function.positionalParameters.first;
        final paramName = _cleanVarName(p.name ?? 'value');
        _buf.write(', ${_restoreType(p.type)} $paramName');
      }
    } else if (!proc.isGetter) {
      for (final p in proc.function.positionalParameters) {
        final paramName = _cleanVarName(p.name ?? '_p');
        _buf.write(', ${_restoreType(p.type)} $paramName');
      }
      for (final p in proc.function.namedParameters) {
        final paramName = _cleanVarName(p.name ?? '_n');
        final isRequired = p.isRequired;
        if (isRequired) {
          _buf.write(', {required ${_restoreType(p.type)} $paramName}');
        } else {
          _buf.write(', {${_restoreType(p.type)} $paramName');
          if (p.initializer != null) {
            _buf.write(' = ${_restoreExpr(p.initializer!)}');
          }
          _buf.write('}');
        }
      }
    }
    
    _buf.write(')');
    
    // async marker
    final marker = proc.function.asyncMarker;
    // async marker removed: replaced by state machine smAwait
    if (marker == AsyncMarker.AsyncStar) _buf.write(' async*');
    if (marker == AsyncMarker.SyncStar) _buf.write(' sync*');
    
    // body
    if (proc.function.body != null) {
      _insideMethodBody = true;
      _thisReplacementName = 'this_';

      final isVoidReturn = proc.function.returnType is VoidType || proc.isSetter;

      // async mixin 方法 → ClosureEnv 闭包延迟执行模式
      // 所有 async 函数统一 lowering（含 void → int、裸值类型 → Promise<T>）
      if (marker == AsyncMarker.Async) {
        final innerRetType = _computeAsyncInnerReturnType(proc.function.returnType);
        final allParams = <VariableDeclaration>[
          ...proc.function.positionalParameters,
          ...proc.function.namedParameters,
        ];
        final envBaseName = '${mixinName}_$methodName';
        _buf.write(' ');
        _pushClosureContext(envBaseName);
        final mixinTypeParamStr = cls.typeParameters.isNotEmpty
            ? '<${cls.typeParameters.map((tp) => tp.name ?? 'T').join(', ')}>'
            : '';
        _emitAsyncClosureEnvForMethod(
          envBaseName: _closureContext,
          func: proc.function,
          innerReturnType: innerRetType,
          params: allParams,
          thisParam: 'dynamic',
          thisRawParam: 'this__',
          classTypeParams: mixinTypeParamStr,
        );
        _popClosureContext();
      } else {
        // 非 async 路径：保持原有逻辑
        _buf.write(' {\n');
        _indent++;
        // Mixin 方法需要访问私有字段，this_ 保持 dynamic 以支持动态派发
        // （mixin 可以被任何类使用，静态函数无法知道具体类型）
        _buf.write('${_pad}final dynamic this_ = this__;\n');

        final body = proc.function.body!;
        if (body is Block) {
          for (final s in body.statements) {
            if (isVoidReturn && s is ReturnStatement) {
              if (s.expression != null) {
                _buf.write('$_pad${_restoreExpr(s.expression!)};\n');
              }
              continue;
            }
            _restoreStmt(s);
          }
        } else if (isVoidReturn && body is ReturnStatement) {
          if (body.expression != null) {
            _buf.write('$_pad${_restoreExpr(body.expression!)};\n');
          }
        } else {
          _restoreStmt(body);
        }
        _indent--;
        _buf.write('$_pad}\n');
      }
      _insideMethodBody = false;
    } else {
      _buf.write(';\n');
    }
    _buf.write('\n');
  }

  // ---- Class (OOP Lowering) ----

  void _restoreClass(Class cls) {
    _currentClass = cls;

    // 合成 mixin 中间类和普通用户类都走 lowering
    final loweredName = _loweredClassName(cls.name);
    if (_isUserClass(loweredName)) {
      _restoreClassLowered(cls, loweredName);
    } else {
      _restoreClassOriginal(cls);
    }

    _currentClass = null;
  }

  /// OOP Lowering: 将类拆分为 XValue + XVTable + 静态方法 + X_new
  void _restoreClassLowered(Class cls, [String? overrideName]) {
    final className = overrideName ?? cls.name;
    final parentName = _getParentClassName(className);
    
    // 判断是否是合成中间类（原始类名包含 &）
    final isSyntheticMixinClass = _isSyntheticMixinClassName(cls.name);

    // 当子类具体化了父类的类型参数（如 AddAsyncStateMachine extends AsyncStateMachine<int>），
    // 建立父类类型参数→具体类型的映射（T → int）。
    // 这样在还原字段初始化和方法体中的类型引用时，T 会被替换为具体类型。
    // 使用 _activeTypeParamTargets 精确限定只替换属于超类的 TypeParameter 对象。
    final savedTypeParamSubstitution = _activeTypeParamSubstitution;
    final savedTypeParamTargets = _activeTypeParamTargets;
    if (cls.supertype != null) {
      final superType = cls.supertype!;
      final superClass = superType.classNode;
      if (superClass.typeParameters.isNotEmpty && superType.typeArguments.isNotEmpty) {
        // 检查子类是否缺少父类的类型参数（即已具体化）
        final currentTypeParamNames = cls.typeParameters.map((tp) => tp.name).toSet();
        final substitution = <String, String>{};
        final targets = <TypeParameter>{};
        for (var i = 0; i < superClass.typeParameters.length && i < superType.typeArguments.length; i++) {
          final paramName = superClass.typeParameters[i].name ?? 'T$i';
          if (!currentTypeParamNames.contains(paramName)) {
            substitution[paramName] = _restoreType(superType.typeArguments[i]);
            targets.add(superClass.typeParameters[i]);
          }
        }
        if (substitution.isNotEmpty) {
          _activeTypeParamSubstitution = {..._activeTypeParamSubstitution, ...substitution};
          _activeTypeParamTargets = {..._activeTypeParamTargets, ...targets};
        }
      }
    }

    // 1. 生成 XValue 类（只存储实例数据）
    _emitValueClass(cls, className, parentName, isSyntheticMixinClass);

    // 合成中间类：vptr 赋值已在 Value 类构造方法中完成，无需生成 X_init 函数
    if (isSyntheticMixinClass) {
      _buf.write('\n');
      return;
    }

    // 3. 生成静态字段（模块级）
    _emitStaticFields(cls, className);

    // 4. 生成构造函数 → X_new / X_new_name
    for (final ctor in cls.constructors) {
      _emitConstructorFunction(cls, ctor, className, parentName);
    }

    // 5. 收集当前类定义的方法名
    final definedMethods = <String>{};
    for (final proc in cls.procedures) {
      if (proc.isStatic || proc.isFactory) continue;
      definedMethods.add(proc.name.text);
    }

    // 6. 生成实例方法 → 静态函数
    // 首先生成当前类定义的方法
    for (final proc in cls.procedures) {
      if (proc.isStatic || proc.isFactory) {
        // 静态方法和工厂方法保持原样（但工厂方法名需要调整）
        _emitStaticOrFactoryProcedure(cls, proc, className);
      } else {
        // 实例方法 → 静态函数
        _emitInstanceMethodAsStatic(cls, proc, className);
      }
    }
    
    // 7. 为从父类/mixin继承但未在当前类定义的方法生成委托静态函数
    final allEntries = _collectAllVTableEntries(className, cls);
    for (final entry in allEntries) {
      if (!definedMethods.contains(entry.name)) {
        // 生成一个委托静态函数，调用父类的实现
        _emitDelegateMethodAsStatic(cls, entry, className);
      }
    }

    // 恢复类型参数替换映射
    _activeTypeParamSubstitution = savedTypeParamSubstitution;
    _activeTypeParamTargets = savedTypeParamTargets;

    _buf.write('\n');
  }
  
  /// 为合成中间类生成 X_init 函数
  /// X_init 只注册该层 mixin 引入的方法到 vptr，并调用 super 的 X_init（如果有）
  // _emitSyntheticMixinInit 和 _emitSyntheticParentInitCall 已废弃：
  // vptr 赋值已迁移到 Value 类构造方法中（通过 Dart 构造链自动调用），
  // 不再需要单独的 X_init 函数和显式调用。

  /// 生成委托静态函数（用于从父类/mixin继承但未在当前类定义的方法）
  /// 使用原始 Procedure 的参数信息来生成正确的函数签名
  void _emitDelegateMethodAsStatic(Class cls, _VTableEntry entry, String className) {
    final methodName = entry.name;
    final proc = entry.proc;

    // 如果有原始 Procedure 引用，直接使用其参数信息生成正确的委托函数
    if (proc != null) {
      _emitDelegateFromProc(cls, proc, entry, className);
      return;
    }
    
    // 没有 proc 引用时的回退逻辑（不应该发生）
    String funcName;
    if (entry.kind == 'getter') {
      funcName = _staticGetterName(className, methodName);
    } else if (entry.kind == 'setter') {
      funcName = _staticSetterName(className, methodName);
    } else {
      funcName = _staticMethodName(className, methodName);
    }
    
    _buf.write('${_pad}AnyGC $funcName(${className}Value this_) {\n');
    _indent++;
    _buf.write("${_pad}throw UnimplementedError('$className.$methodName delegate missing proc');\n");
    _indent--;
    _buf.write('}\n\n');
  }
  
  /// 使用原始 Procedure 的参数信息生成委托静态函数
  /// 委托函数直接调用原始定义该方法的类的静态函数，避免通过 vptr 调用自己形成无限递归
  void _emitDelegateFromProc(Class cls, Procedure proc, _VTableEntry entry, String className) {
    final methodName = entry.name;
    final funcName = _staticFuncName(className, methodName, entry.kind);

    // 找到原始定义该方法的类名
    final originClass = proc.enclosingClass;
    final originClassName = _resolveOriginClassName(cls, proc, entry, className, originClass);

    // 原始定义类的静态函数名
    final originFuncName = _staticFuncName(originClassName, methodName, entry.kind);

    // 构建类型参数替换映射：当子类不声明父类的类型参数时，
    // 需要将父类类型参数替换为从继承链中解析出的具体类型
    // 例如：StringToIntTransformer extends DataTransformer<String, int>
    // proc 来自 DataTransformer，其类型参数 TInput/TOutput 需替换为 String/int
    final typeSubstitution = _buildTypeSubstitutionForDelegate(cls, proc);

    // 还原类型时使用替换映射（支持嵌套类型如 Promise<T> → Promise<int>）
    String restoreTypeWithSub(DartType type) {
      if (typeSubstitution.isEmpty) return _restoreType(type);
      if (type is TypeParameterType) {
        final paramName = type.parameter.name ?? 'T';
        final replacement = typeSubstitution[paramName];
        if (replacement != null) {
          final nullable = type.nullability == Nullability.nullable;
          return nullable ? '$replacement?' : replacement;
        }
      }
      // 对于 InterfaceType 等嵌套类型，先还原为字符串，再用字符串替换
      var result = _restoreType(type);
      for (final entry in typeSubstitution.entries) {
        // 替换独立出现的类型参数名（避免误替换类名中的子串）
        result = result.replaceAll(RegExp('\\b${entry.key}\\b'), entry.value);
      }
      return result;
    }

    // 返回类型
    final returnType = restoreTypeWithSub(proc.function.returnType);

    _buf.write(_pad);
    _buf.write('$returnType $funcName');
    // 类型参数声明：类的类型参数 + 方法自身的类型参数
    _writeCombinedTypeParams(cls.typeParameters, proc.function.typeParameters);
    // this_ 参数类型：统一使用 dynamic，消除调用侧的 as Function
    _buf.write('(AnyGC this__');

    // 构建参数列表和转发参数
    final forwardArgs = <String>['this_'];
    _emitDelegateParams(proc, entry, restoreTypeWithSub, forwardArgs);

    _buf.write(') {\n');
    _indent++;
    _emitDelegateBody(cls, proc, entry, className, returnType, forwardArgs, originClassName, originFuncName);
    _indent--;
    _buf.write('}\n\n');
  }

  /// 根据 entry.kind 生成对应的静态函数名（getter/setter/method）
  String _staticFuncName(String className, String methodName, String kind) {
    if (kind == 'getter') return _staticGetterName(className, methodName);
    if (kind == 'setter') return _staticSetterName(className, methodName);
    return _staticMethodName(className, methodName);
  }

  /// 解析原始定义该方法的类名
  /// 当原始类是合成中间类（不生成静态函数）时，需要找到真正定义该方法的 mixin 或用户类
  /// 使用 4 个策略依次尝试：
  ///   1. 沿 stubTarget 链找到真正定义该方法的类
  ///   2. 从合成类名中提取最后一个 mixin 名
  ///   3. 在合成类的继承链中查找有方法体的 Procedure
  ///   4. 沿当前类的继承链向上找非合成用户类
  String _resolveOriginClassName(Class cls, Procedure proc, _VTableEntry entry,
      String className, Class? originClass) {
    var originClassName = originClass != null ? _loweredClassName(originClass.name) : className;

    if (!_syntheticLoweredNames.contains(originClassName)) {
      return originClassName;
    }

    // 策略 1: 沿着 stubTarget 链找到真正定义该方法的类
    var realProc = proc;
    var visited = <Procedure>{proc};
    while (realProc.stubTarget is Procedure) {
      final target = realProc.stubTarget as Procedure;
      if (visited.contains(target)) break;
      visited.add(target);
      realProc = target;
    }

    // 检查 realProc 的 enclosingClass 是否是 mixin 或非合成用户类
    final realOriginClass = realProc.enclosingClass;
    if (realOriginClass != null) {
      final realOriginName = _loweredClassName(realOriginClass.name);
      if (_isMixinName(realOriginName) || (!_syntheticLoweredNames.contains(realOriginName) && _isUserClass(realOriginName))) {
        originClassName = realOriginName;
      }
    }

    // 策略 2: 如果仍然是合成类，从合成类名中提取 mixin 名
    // 合成类名格式：Dog_Animal_Printable_Orderable，对应原始名 _Dog&Animal&Printable&Orderable
    // 最后一个部分是 mixin 名
    if (_syntheticLoweredNames.contains(originClassName) && originClass != null && originClass.name.contains('&')) {
      final parts = originClass.name.split('&');
      if (parts.isNotEmpty) {
        final lastMixin = parts.last.trim();
        if (_isMixinName(lastMixin)) {
          originClassName = lastMixin;
        }
      }
    }

    // 策略 3: 如果仍然是合成类，在合成类的继承链中查找有方法体的 Procedure
    if (_syntheticLoweredNames.contains(originClassName)) {
      var searchClass = originClass;
      while (searchClass != null) {
        final superType = searchClass.supertype;
        if (superType == null) break;
        searchClass = superType.classNode;
        for (final p in searchClass.procedures) {
          if (p.name.text == proc.name.text && p.kind == proc.kind) {
            final searchName = _loweredClassName(searchClass.name);
            if (_isMixinName(searchName) || (!_syntheticLoweredNames.contains(searchName) && _isUserClass(searchName))) {
              originClassName = searchName;
              break;
            }
          }
        }
        if (!_syntheticLoweredNames.contains(originClassName)) break;
      }
    }

    // 策略 4: 沿当前类的继承链向上找非合成用户类
    if (_syntheticLoweredNames.contains(originClassName)) {
      var parentName = _getParentClassName(className);
      while (parentName != null) {
        if (!_syntheticLoweredNames.contains(parentName) && !_isMixinName(parentName) && _isUserClass(parentName)) {
          final parentEntries = _getVTableEntriesByName(parentName);
          if (parentEntries != null && parentEntries.any((e) => e.name == entry.name && e.kind == entry.kind)) {
            originClassName = parentName;
            break;
          }
        }
        parentName = _getParentClassName(parentName);
      }
    }

    return originClassName;
  }

  /// 发射委托函数的参数列表
  void _emitDelegateParams(Procedure proc, _VTableEntry entry,
      String Function(DartType) restoreTypeWithSub, List<String> forwardArgs) {
    if (entry.kind == 'setter') {
      if (proc.function.positionalParameters.isNotEmpty) {
        final p = proc.function.positionalParameters.first;
        final paramName = _cleanVarName(p.name ?? 'value');
        _buf.write(', ${restoreTypeWithSub(p.type)} $paramName');
        forwardArgs.add(paramName);
      }
    } else if (entry.kind != 'getter') {
      // method / operator
      for (final p in proc.function.positionalParameters) {
        final paramName = _cleanVarName(p.name ?? '_p');
        _buf.write(', ${restoreTypeWithSub(p.type)} $paramName');
        forwardArgs.add(paramName);
      }
      for (final p in proc.function.namedParameters) {
        final paramName = _cleanVarName(p.name ?? '_n');
        _buf.write(', {${restoreTypeWithSub(p.type)} $paramName}');
      }
    }
  }

  /// 发射委托函数体
  void _emitDelegateBody(Class cls, Procedure proc, _VTableEntry entry,
      String className, String returnType, List<String> forwardArgs,
      String originClassName, String originFuncName) {
    final methodName = entry.name;
    // this__ 是 dynamic，cast 为当前类类型
    final delegateClassTypeParamStr = cls.typeParameters.isNotEmpty
        ? '<${cls.typeParameters.map((tp) => tp.name ?? 'T').join(', ')}>'
        : '';
    _buf.write('${_pad}final this_ = this__ as ${className}Value$delegateClassTypeParamStr;\n');

    // 检查原始方法是否是抽象的（无方法体）
    // 抽象方法（如 mixin 中的抽象 getter）不会生成静态函数，
    // 委托函数应该直接访问字段
    final isAbstractOrigin = proc.isAbstract || proc.function.body == null;
    if (isAbstractOrigin && entry.kind == 'getter') {
      // 抽象 getter → 直接返回字段访问
      _buf.write('${_pad}return this_.$methodName;\n');
    } else if (isAbstractOrigin && entry.kind == 'setter') {
      // 抽象 setter → 直接设置字段
      final valueName = forwardArgs.length > 1 ? forwardArgs[1] : 'value';
      _buf.write('${_pad}this_.$methodName = $valueName;\n');
    } else {
      // 直接调用原始定义类的静态函数（避免通过 vptr 调用自己形成无限递归）
      if (returnType != 'void' || entry.kind == 'getter') {
        _buf.write('${_pad}return ');
      } else {
        _buf.write(_pad);
      }

      // Bug 17: 传递泛型类型参数到 origin 静态函数
      // 例如 Box_describe<T>(this_) 委托给 mixin 时应输出 Mappable_describe<T>(this_)
      // 而不是 Mappable_describe(this_)，否则类型推断会把 T 降级为 dynamic。
      // origin 函数的类型参数顺序：origin 类的类型参数 + 方法自身的类型参数
      final originTypeArgs = _buildOriginTypeArgs(cls, proc, originClassName);
      final originTypeArgStr = originTypeArgs.isEmpty ? '' : '<${originTypeArgs.join(', ')}>';

      // 多文件支持：使用 Class 节点精确匹配，避免同名类冲突
      // 优先使用 proc.enclosingClass（原始定义类），如果不可用则回退到字符串名称
      String prefix;
      if (proc.enclosingClass != null) {
        prefix = _crossLibPrefixForClass(proc.enclosingClass!);
      } else {
        prefix = _crossLibPrefix(originClassName);
      }
      _buf.write('$prefix$originFuncName$originTypeArgStr(${forwardArgs.join(', ')});\n');
    }
  }

  /// Bug 17: 为 origin 静态函数调用构建实参类型列表
  /// 例如：Box<int> with Mappable<int>，委托函数 Box_describe<T>(this_) 调用 Mappable_describe 时，
  /// 应该输出 Mappable_describe<T>(this_)；如果 Box<int> 直接 with Mappable<String>，
  /// 则应输出 Mappable_describe<String>(this_)。
  ///
  /// [originClassName] 是已解析的 origin 静态函数前缀对应的类名（如 "Mappable"、"Validatable"），
  /// 需要用它来查找真正的 origin 类节点，而不是 proc.enclosingClass（可能是合成 mixin 应用类）。
  /// 顺序：origin 类的类型参数实参 + 方法自身的类型参数（同名透传，与类级去重）
  List<String> _buildOriginTypeArgs(Class cls, Procedure proc, String originClassName) {
    final result = <String>[];

    // 使用 originClassName 查找真正的 origin 类节点
    final originClass = _classNodes[originClassName] ?? proc.enclosingClass;
    if (originClass != null && originClass != cls && originClass.typeParameters.isNotEmpty) {
      // 尝试解析 origin 类在当前 cls 继承/混入链中的具体类型实参
      final concreteArgs =
          _resolveOriginConcreteTypeArgs(cls, originClass, originClassName);
      if (concreteArgs != null && concreteArgs.length == originClass.typeParameters.length) {
        result.addAll(concreteArgs);
      } else {
        // 兜底：同名透传（仅当 cls 的类型参数中有同名参数时）
        final clsParamNames = cls.typeParameters.map((tp) => tp.name).toSet();
        for (final tp in originClass.typeParameters) {
          final name = tp.name ?? 'T';
          result.add(clsParamNames.contains(name) ? name : 'dynamic');
        }
      }
    }
    // 方法自身的类型参数：同名透传，但与已添加的 origin 类型参数去重
    final addedNames = result.toSet();
    for (final tp in proc.function.typeParameters) {
      final name = tp.name ?? 'T';
      if (!addedNames.contains(name)) {
        result.add(name);
      }
    }
    return result;
  }

  /// 在 cls 的继承链（含 mixin 应用合成类）中查找 originClass 的具体类型实参。
  /// 同时考虑 supertype 链 和 每一层合成类的 mixedInType。
  /// 类匹配优先用对象身份；不匹配时按 [originClassName] 名字回退，
  /// 兼容 Kernel 在不同位置持有的同名 Class 节点身份不一致的情况。
  List<String>? _resolveOriginConcreteTypeArgs(
      Class cls, Class originClass, String originClassName) {
    bool sameClass(Class? c) =>
        c != null && (identical(c, originClass) || c.name == originClassName);

    // 1) 先尝试常规 extends 链
    final viaExtends = _resolveConcreteTypeArgsForAncestor(cls, originClass);
    if (viaExtends != null) return viaExtends;

    // 2) 沿 supertype 链查找每一层的 mixedInType
    var currentClass = cls;
    final typeParamMap = <String, String>{}; // 当前层类型参数名 → cls 视角下的具体类型
    // 初始化：cls 自身的类型参数同名映射（恒等）
    for (final tp in cls.typeParameters) {
      final name = tp.name ?? 'T';
      typeParamMap[name] = name;
    }

    while (true) {
      final superType = currentClass.supertype;
      if (superType == null) return null;

      // 检查当前类的 mixedInType 是否就是 originClass
      final mixedIn = currentClass.mixedInType;
      if (mixedIn != null && sameClass(mixedIn.classNode)) {
        if (mixedIn.typeArguments.isEmpty) return null;
        return mixedIn.typeArguments
            .map((ta) => _substituteTypeStr(_restoreType(ta), typeParamMap))
            .toList();
      }

      // Kernel mixin full-resolution 之后 mixedInType 会被清空，mixin 绑定
      // 转移到 implementedTypes。沿合成中间类的 implementedTypes 查找 originClass。
      for (final impl in currentClass.implementedTypes) {
        if (sameClass(impl.classNode)) {
          if (impl.typeArguments.isEmpty) return null;
          return impl.typeArguments
              .map((ta) => _substituteTypeStr(_restoreType(ta), typeParamMap))
              .toList();
        }
      }

      // 进入上一层之前，更新 typeParamMap：
      // currentClass 的类型参数 → superType.typeArguments（用 typeParamMap 替换后）
      final nextClass = superType.classNode;
      if (sameClass(nextClass)) {
        if (superType.typeArguments.isEmpty) return null;
        return superType.typeArguments
            .map((ta) => _substituteTypeStr(_restoreType(ta), typeParamMap))
            .toList();
      }

      // 构建 nextClass 类型参数 → 替换后的具体类型 映射
      final newMap = <String, String>{};
      for (var i = 0; i < nextClass.typeParameters.length && i < superType.typeArguments.length; i++) {
        final paramName = nextClass.typeParameters[i].name ?? 'T$i';
        final argStr = _restoreType(superType.typeArguments[i]);
        newMap[paramName] = _substituteTypeStr(argStr, typeParamMap);
      }
      // 没有 supertype 类型实参时，传递空映射（说明无类型参数）
      typeParamMap
        ..clear()
        ..addAll(newMap);
      currentClass = nextClass;
    }
  }

  /// 简单字符串级别的类型参数替换：将 typeStr 中出现的类型参数名替换为映射值。
  /// 仅做整词匹配（避免误替换类似 "T" 在 "Type" 中）。
  String _substituteTypeStr(String typeStr, Map<String, String> map) {
    if (map.isEmpty) return typeStr;
    var result = typeStr;
    map.forEach((from, to) {
      if (from == to) return;
      // 整词替换：前后必须是非标识符字符或边界
      result = result.replaceAllMapped(
        RegExp('\\b' + RegExp.escape(from) + '\\b'),
        (m) => to,
      );
    });
    return result;
  }

  /// 为委托函数构建类型参数替换映射
  /// 当子类不声明父类的类型参数时，将父类类型参数替换为继承链中的具体类型
  /// 返回映射：{父类类型参数名 → 具体类型字符串}，空映射表示不需要替换
  Map<String, String> _buildTypeSubstitutionForDelegate(Class cls, Procedure proc) {
    final originClass = proc.enclosingClass;
    if (originClass == null) return {};
    if (originClass == cls) return {}; // 方法定义在当前类，无需替换
    if (originClass.typeParameters.isEmpty) return {}; // 父类无类型参数

    // 检查当前类是否缺少父类的类型参数
    final currentTypeParamNames = cls.typeParameters.map((tp) => tp.name).toSet();
    final parentTypeParamNames = originClass.typeParameters.map((tp) => tp.name).toSet();
    
    // 如果当前类拥有所有父类类型参数，不需要替换
    if (parentTypeParamNames.every((n) => currentTypeParamNames.contains(n))) return {};

    // 从继承链中解析具体类型参数
    final concreteTypeArgs = _resolveConcreteTypeArgsForAncestor(cls, originClass);
    if (concreteTypeArgs == null || concreteTypeArgs.isEmpty) return {};

    final substitution = <String, String>{};
    for (var i = 0; i < originClass.typeParameters.length && i < concreteTypeArgs.length; i++) {
      final paramName = originClass.typeParameters[i].name ?? 'T$i';
      substitution[paramName] = concreteTypeArgs[i];
    }
    return substitution;
  }

  /// 生成 XValue 类
  void _emitValueClass(Class cls, String className, String? parentName, [bool isSyntheticMixinClass = false]) {
    _buf.write('class ${className}Value');
    _writeTypeParams(cls.typeParameters);

    // 确定继承关系：
    // - 有用户类基类 → extends ${parentName}Value
    // - 有非用户类基类（如 AsyncStateMachine）→ 直接继承该运行时基类
    // - 无基类（根类）→ extends VPtr（VPtr 提供 vptr 字段和 toString/operator==/hashCode 桥接）
    final hasUserParent = parentName != null && _isUserClass(parentName);
    final superType = cls.supertype;
    if (hasUserParent) {
      // 从 supertype 中获取具体化的泛型参数
      String parentTypeArgs = '';
      if (superType != null && superType.typeArguments.isNotEmpty) {
        final concreteArgs = superType.typeArguments.map((ta) => _restoreType(ta)).toList();
        if (concreteArgs.isNotEmpty) {
          parentTypeArgs = '<${concreteArgs.join(', ')}>';
        }
      }
      // 多文件支持：使用 Class 节点精确匹配，避免同名类冲突
      final prefix = superType != null ? _crossLibPrefixForClass(superType.classNode) : '';
      _buf.write(' extends $prefix${parentName}Value$parentTypeArgs');
    } else if (parentName != null && !_isUserClass(parentName) && superType != null) {
      // 非用户类基类（如 AsyncStateMachine 等运行时基类）→ 直接继承
      String parentTypeArgs = '';
      if (superType.typeArguments.isNotEmpty) {
        final concreteArgs = superType.typeArguments.map((ta) => _restoreType(ta)).toList();
        if (concreteArgs.isNotEmpty) {
          parentTypeArgs = '<${concreteArgs.join(', ')}>';
        }
      }
      _buf.write(' extends $parentName$parentTypeArgs');
    } else {
      _buf.write(' extends VPtr');
    }

    // Bug 22+23: 收集当前类及其继承链上所有 implements 的用户自定义接口
    // 生成 implements InterfaceValue，使得子类型关系得以保留
    final implementedInterfaces = _collectUserImplementedInterfaces(cls, className);
    if (implementedInterfaces.isNotEmpty) {
      _buf.write(' implements ');
      _buf.write(implementedInterfaces.join(', '));
    }

    _buf.write(' {\n');
    _indent++;

    // 实例字段（排除静态字段）
    // 当有用户类父类时，父类字段已通过 extends 继承，只收集当前类新增的字段
    // 当无用户类父类时（根类），收集所有字段（包括 mixin 的）
    final fieldsToEmit = <Field>[];
    if (hasUserParent) {
      // 只收集当前类自己定义的字段（不包括继承的）
      _collectOwnFields(cls, fieldsToEmit);
    } else {
      // 根类：收集所有字段（包括 mixin 的）
      _collectAllFields(cls, fieldsToEmit, <String>{});
    }
    
    // Bug 21: 为来自 mixin 的字段建立类型参数替换映射
    // 合成类 ReactiveStore_Object_Loggable_ObservableValue<V> 中，
    // 来自 Observable<T> 的字段类型含 T，需替换为合成类的 V
    final mixinTypeSubstitution = _buildMixinFieldTypeSubstitution(cls);

    for (final field in fieldsToEmit) {
      if (field.isStatic) continue;
      _buf.write('$_pad');
      // 所有字段都标记为 late，因为它们在构造函数外赋值
      _buf.write('late ');
      var fieldTypeStr = _restoreType(field.type);
      // 如果字段来自 mixin，做类型参数替换
      if (mixinTypeSubstitution.isNotEmpty) {
        fieldTypeStr = _substituteTypeStr(fieldTypeStr, mixinTypeSubstitution);
      }
      _buf.write(fieldTypeStr);
      _buf.write(' ${field.name.text}');
      // 如果字段有初始值，直接在字段定义处发射（利用 Dart 的 late lazy 语义）
      // 不再在构造函数中 eager 求值
      if (field.initializer != null) {
        var initStr = _restoreExpr(field.initializer!);
        // 对 mixin 字段做类型参数替换（initializer 表达式中可能含原始类型参数名）
        if (mixinTypeSubstitution.isNotEmpty) {
          initStr = _substituteTypeStr(initStr, mixinTypeSubstitution);
        }
        _buf.write(' = $initStr');
      }
      _buf.write(';\n');
    }

    // 当继承非用户类基类（如 AsyncStateMachine）时，需要添加桥接方法
    // 因为该基类可能有抽象方法需要桥接（delegate 到 vptr）
    final hasRuntimeParent = parentName != null && !_isUserClass(parentName) && superType != null;
    if (hasRuntimeParent) {
      // 为基类中的抽象方法生成桥接实现（delegate 到 vptr）
      _emitRuntimeParentBridgeMethods(cls, parentName);
    }

    // 生成 per-type 静态 vptr 基础设施（替代 per-instance 构造函数注册）
    _emitStaticVptrInfrastructure(cls, className, parentName, isSyntheticMixinClass, hasRuntimeParent);

    // 生成 gcMark 覆写方法：遍历所有 AnyGC 类型的实例字段，递归标记
    _emitGcMarkOverride(fieldsToEmit, hasUserParent);

    _indent--;
    _buf.write('}\n\n');
  }

  /// 生成 gcMark 覆写方法，遍历所有可能持有 AnyGC 引用的实例字段并递归标记。
  /// [fieldsToEmit] 是当前类需要发射的字段列表（可能只含本类新增字段或全部字段）。
  /// [hasUserParent] 表示是否有用户类父类（如果有，super.gcMark 会标记父类字段）。
  void _emitGcMarkOverride(List<Field> fieldsToEmit, bool hasUserParent) {
    // 收集需要在 gcMark 中处理的实例字段（排除静态字段和基础值类型）
    final gcFields = <Field>[];
    for (final field in fieldsToEmit) {
      if (field.isStatic) continue;
      if (_isGcRelevantType(field.type)) {
        gcFields.add(field);
      }
    }

    // 即使没有 gc 字段，如果有父类也需要生成 gcMark 以调用 super
    if (gcFields.isEmpty && !hasUserParent) return;

    _buf.write('${_pad}@override\n');
    _buf.write('${_pad}void gcMark(int flag) {\n');
    _indent++;
    _buf.write('${_pad}if (gcFlag == flag) return;\n');
    _buf.write('${_pad}super.gcMark(flag);\n');

    for (final field in gcFields) {
      final fieldName = field.name.text;
      // 对所有可能是 AnyGC 的字段使用运行时 is 检查，安全且通用
      _buf.write('${_pad}if ($fieldName is AnyGC) ($fieldName as AnyGC).gcMark(flag);\n');
    }

    _indent--;
    _buf.write('$_pad}\n');
  }

  /// 判断字段类型是否可能持有 AnyGC 引用（需要在 gcMark 中递归标记）。
  /// 返回 true 的类型：用户类类型（XValue）、Box 类型、泛型参数、dynamic、Object。
  /// 返回 false 的类型：int、double、bool、String 等基础值类型。
  bool _isGcRelevantType(DartType type) {
    if (type is InterfaceType) {
      final name = type.classNode.name;
      // 基础值类型不持有 AnyGC 引用
      if (name == 'int' || name == 'double' || name == 'bool' || name == 'String') {
        return false;
      }
      // 用户类、集合类、其他引用类型可能持有 AnyGC
      return true;
    }
    if (type is TypeParameterType) return true;  // 泛型参数运行时可能是 AnyGC
    if (type is DynamicType) return true;
    if (type is FunctionType) return true;  // TypeFunction 子类是 AnyGC？不是，但闭包 env 是
    if (type is NullType) return false;
    if (type is VoidType) return false;
    if (type is NeverType) return false;
    return true; // 保守策略：未知类型做运行时检查
  }

  /// 生成 per-type 静态 vptr 基础设施（替代 per-instance 构造函数注册）
  ///
  /// 对于非泛型类：
  /// - `static Map<String, dynamic>? vptrMap;`
  /// - `@override Map<String, dynamic> get vptr => getVptrMap();`
  /// - `static Map<String, dynamic> getVptrMap()` — 惰性初始化
  /// - `static void initVptr()` — 填入本类的 vptr 条目
  ///
  /// 对于泛型类（Dart 不允许在静态成员中使用类型参数）：
  /// - `static final Map<Type, Map<String, dynamic>> vptrCache = {};`
  /// - `Map<String, dynamic>? instanceVptr;`
  /// - `@override Map<String, dynamic> get vptr` — 使用运行时类型做 key 的惰性初始化
  /// - `void initVptr(Map<String, dynamic> target)` — 实例方法，可使用类型参数
  void _emitStaticVptrInfrastructure(
    Class cls,
    String className,
    String? parentName,
    bool isSyntheticMixinClass,
    bool hasRuntimeParent,
  ) {
    if (isSyntheticMixinClass) {
      _emitSyntheticMixinStaticVptr(cls, className, parentName);
      return;
    }

    final isGeneric = cls.typeParameters.isNotEmpty;

    // 非合成类：收集所有 vtable 条目（包括方法级泛型特化）
    final entries = _collectAllVTableEntries(className, cls);

    // 检查祖先链中是否有任何类使用实例方法方式的 vptr
    // 包括：泛型父类、继承泛型类的合成 mixin 中间类、抽象泛型类
    bool parentUsesInstanceApproach = _anyAncestorUsesInstanceApproach(cls);

    // 抽象泛型类：生成占位符，具体子类通过 super.vptr 覆盖
    // 注意：不能生成 instanceVptr/_initVptr，否则 implements 该接口的类也需要实现这些成员
    if (cls.isAbstract && isGeneric) {
      _emitAbstractGenericVptrPlaceholder(cls, className);
      return;
    }

    // 如果当前类是泛型或祖先链中有使用实例方法方式的，使用实例方法方式
    // 泛型类必须使用实例方式（Dart 不允许在静态成员中使用类型参数）
    final useInstanceApproach = isGeneric || parentUsesInstanceApproach;

    // 确定父类的 vptr 初始化表达式
    final hasUserParent = parentName != null && _isUserClass(parentName);
    String parentInitExpr;
    if (hasUserParent) {
      // 从 supertype 获取具体化的泛型参数
      final superType = cls.supertype;
      String parentTypeArgs = '';
      if (superType != null && superType.typeArguments.isNotEmpty) {
        final concreteArgs = superType.typeArguments.map((ta) => _restoreType(ta)).toList();
        if (concreteArgs.isNotEmpty) {
          parentTypeArgs = '<${concreteArgs.join(', ')}>';
        }
      }
      if (useInstanceApproach) {
        // 泛型类或父类是泛型：通过实例方法访问父类 vptr
        parentInitExpr = 'Map<String, dynamic>.from((super.vptr))';
      } else {
        // 多文件支持：使用 Class 节点精确匹配，避免同名类冲突
        final prefix = superType != null ? _crossLibPrefixForClass(superType.classNode) : '';
        parentInitExpr = 'Map<String, dynamic>.from($prefix${parentName}Value$parentTypeArgs.getVptrMap())';
      }
    } else if (hasRuntimeParent) {
      // 继承非用户类基类（如 AsyncStateMachine），无父类 vptr 可继承
      parentInitExpr = '<String, dynamic>{}';
    } else {
      // 根类（extends VPtr）：从 VPtr 的基础条目开始
      parentInitExpr = "<String, dynamic>{'toString': null, 'operatorEq': null, 'get_hashCode': null}";
    }

    // 分离普通条目和方法级泛型特化条目
    final typeParamNames = cls.typeParameters.map((tp) => tp.name ?? 'T').toList();
    final typeParamStr = isGeneric ? '<${typeParamNames.join(', ')}>' : '';
    final classTpNames = cls.typeParameters.map((tp) => tp.name).toSet();

    final normalEntries = <_VTableEntry>[];
    final specializedEntries = <_VTableEntry>[];
    for (final entry in entries) {
      if (entry.proc != null) {
        final dedupedMethodTps = entry.proc!.function.typeParameters
            .where((tp) => !classTpNames.contains(tp.name))
            .toList();
        if (dedupedMethodTps.isNotEmpty) {
          specializedEntries.add(entry);
          continue;
        }
      }
      normalEntries.add(entry);
    }

    if (useInstanceApproach) {
      // 泛型类或祖先链中有泛型：使用实例方法 + 静态缓存
      _emitGenericVptrInfrastructure(cls, className, parentName, hasUserParent, hasRuntimeParent,
          parentInitExpr, normalEntries, specializedEntries, typeParamStr, parentUsesInstanceApproach);
    } else {
      // 非泛型类：使用纯静态方法
      _emitNonGenericVptrInfrastructure(cls, className, parentName, hasUserParent, hasRuntimeParent,
          parentInitExpr, normalEntries, specializedEntries, typeParamStr);
    }
  }

  /// 抽象泛型类的 vptr 占位符
  /// 返回一个每次新建的基础 vptr Map，具体子类通过 super.vptr 获取并扩展
  /// 注意：不能生成 instanceVptr/_initVptr 等实例成员，
  /// 因为 implements 该抽象接口的类也会被要求实现这些成员
  void _emitAbstractGenericVptrPlaceholder(Class cls, String className) {
    _buf.write('${_pad}@override\n');
    _buf.write('${_pad}Map<String, dynamic> get vptr => <String, dynamic>{\'toString\': null, \'operatorEq\': null, \'get_hashCode\': null};\n');
  }

  /// 检查 extends 链中是否有任何祖先使用实例方法方式的 vptr
  /// 沿 supertype 链（即 extends 关系）向上遍历，不检查 implements 接口
  /// 这解决了 Bug B: 非泛型子类 → 非泛型中间类 → 抽象泛型基类 的情况
  /// 同时避免了 implements 接口导致的成员实现要求
  bool _anyAncestorUsesInstanceApproach(Class cls) {
    var current = cls.supertype;
    while (current != null) {
      // 如果父类有类型参数（被实参化），说明父类是泛型的
      if (current.typeArguments.isNotEmpty) return true;

      // 如果父类自身声明了类型参数，说明父类是泛型的
      if (current.classNode.typeParameters.isNotEmpty) return true;

      // 合成 mixin 中间类：继续向上遍历（它们的父类可能是泛型的）
      if (_isSyntheticMixinClassName(current.classNode.name)) {
        current = current.classNode.supertype;
        continue;
      }

      // 非合成用户类且非泛型：停止遍历
      break;
    }
    return false;
  }

  /// 非泛型类的纯静态 vptr 基础设施
  /// 使用内联初始化避免静态方法名冲突
  void _emitNonGenericVptrInfrastructure(
    Class cls,
    String className,
    String? parentName,
    bool hasUserParent,
    bool hasRuntimeParent,
    String parentInitExpr,
    List<_VTableEntry> normalEntries,
    List<_VTableEntry> specializedEntries,
    String typeParamStr,
  ) {
    // 生成 static _vptr 字段
    _buf.write('${_pad}static Map<String, dynamic>? vptrMap;\n');

    // 生成 vptr getter
    _buf.write('${_pad}@override\n');
    _buf.write('${_pad}Map<String, dynamic> get vptr => getVptrMap();\n');

    // 生成 getVptrMap() 方法（内联初始化，避免子类静态方法冲突）
    _buf.write('${_pad}static Map<String, dynamic> getVptrMap() {\n');
    _indent++;
    _buf.write('${_pad}if (vptrMap == null) {\n');
    _indent++;
    _buf.write('${_pad}vptrMap = $parentInitExpr;\n');

    // 内联注册普通条目
    for (final entry in normalEntries) {
      final key = _vptrEntryKey(entry);
      final rhs = _buildVptrLambdaWrapper(cls, entry, className, typeParamStr);
      _buf.write("${_pad}vptrMap!['$key'] = $rhs;\n");
    }

    // 内联注册方法级泛型特化条目
    for (final entry in specializedEntries) {
      _emitSpecializedVptrEntriesStatic(cls, entry, className);
    }

    _indent--;
    _buf.write('${_pad}}\n');
    _buf.write('${_pad}return vptrMap!;\n');
    _indent--;
    _buf.write('${_pad}}\n');
  }

  /// 泛型类的实例方法 + 静态缓存 vptr 基础设施
  /// [parentUsesInstanceApproach] 为 true 时，_initVptr 需要 @override
  void _emitGenericVptrInfrastructure(
    Class cls,
    String className,
    String? parentName,
    bool hasUserParent,
    bool hasRuntimeParent,
    String parentInitExpr,
    List<_VTableEntry> normalEntries,
    List<_VTableEntry> specializedEntries,
    String typeParamStr,
    bool parentUsesInstanceApproach,
  ) {
    // 生成静态缓存（按具体化类型索引）
    _buf.write('${_pad}static final Map<Type, Map<String, dynamic>> vptrCache = {};\n');

    // 生成实例 vptr 字段
    _buf.write('${_pad}Map<String, dynamic>? instanceVptr;\n');

    // 生成 vptr getter
    _buf.write('${_pad}@override\n');
    _buf.write('${_pad}Map<String, dynamic> get vptr {\n');
    _indent++;
    _buf.write('${_pad}if (instanceVptr == null) {\n');
    _indent++;
    _buf.write('${_pad}final _typeKey = ${className}Value${typeParamStr};\n');
    _buf.write('${_pad}instanceVptr = vptrCache[_typeKey];\n');
    _buf.write('${_pad}if (instanceVptr == null) {\n');
    _indent++;
    _buf.write('${_pad}instanceVptr = $parentInitExpr;\n');
    _buf.write('${_pad}initVptr(instanceVptr!);\n');
    _buf.write('${_pad}vptrCache[_typeKey] = instanceVptr!;\n');
    _indent--;
    _buf.write('${_pad}}\n');
    _indent--;
    _buf.write('${_pad}}\n');
    _buf.write('${_pad}return instanceVptr!;\n');
    _indent--;
    _buf.write('${_pad}}\n');

    // 生成 initVptr() 实例方法（可以使用类型参数）
    // 当父类也有 _initVptr 时，需要 @override 以避免 Dart 编译错误
    if (parentUsesInstanceApproach) {
      _buf.write('${_pad}@override\n');
    }
    _buf.write('${_pad}void initVptr(Map<String, dynamic> target) {\n');
    _indent++;

    // 注册普通条目
    for (final entry in normalEntries) {
      final key = _vptrEntryKey(entry);
      final rhs = _buildVptrLambdaWrapper(cls, entry, className, typeParamStr);
      _buf.write("${_pad}target['$key'] = $rhs;\n");
    }

    // 注册方法级泛型特化条目
    for (final entry in specializedEntries) {
      _emitSpecializedVptrEntriesStaticGeneric(cls, entry, className);
    }

    _indent--;
    _buf.write('${_pad}}\n');
  }

  /// 合成 mixin 中间类的静态 vptr 基础设施
  void _emitSyntheticMixinStaticVptr(Class cls, String className, String? parentName) {
    final isGeneric = cls.typeParameters.isNotEmpty;

    // 获取该层 mixin 引入的方法名集合
    final mixinMethodNames = <String>{};
    if (cls.mixedInType != null) {
      final mixinCls = cls.mixedInType!.classNode;
      for (final p in mixinCls.procedures) {
        if (p.isStatic || p.isFactory || p.isAbstract) continue;
        mixinMethodNames.add(p.name.text);
      }
    }

    // 检查祖先链中是否有任何类使用实例方法方式的 vptr
    bool parentUsesInstanceApproach = _anyAncestorUsesInstanceApproach(cls);
    final useInstanceApproach = isGeneric || parentUsesInstanceApproach;

    // 确定父类的 vptr 初始化表达式
    final hasUserParent = parentName != null && _isUserClass(parentName);
    String parentInitExpr;
    if (hasUserParent) {
      final superType = cls.supertype;
      String parentTypeArgs = '';
      if (superType != null && superType.typeArguments.isNotEmpty) {
        final concreteArgs = superType.typeArguments.map((ta) => _restoreType(ta)).toList();
        if (concreteArgs.isNotEmpty) {
          parentTypeArgs = '<${concreteArgs.join(', ')}>';
        }
      }
      if (useInstanceApproach) {
        parentInitExpr = 'Map<String, dynamic>.from((super.vptr))';
      } else {
        // 多文件支持：添加跨库前缀
        final prefix = _crossLibPrefix(parentName);
        parentInitExpr = 'Map<String, dynamic>.from($prefix${parentName}Value$parentTypeArgs.getVptrMap())';
      }
    } else if (parentName != null && !_isUserClass(parentName) && cls.supertype != null) {
      parentInitExpr = '<String, dynamic>{}';
    } else {
      parentInitExpr = "<String, dynamic>{'toString': null, 'operatorEq': null, 'get_hashCode': null}";
    }

    // 从 _classVTableEntries 中找到对应的 VTable 条目
    final allEntries = _getVTableEntries(cls, className);
    final mixinEntries = allEntries.where((entry) {
      return mixinMethodNames.contains(entry.name);
    }).toList();

    if (useInstanceApproach) {
      // 合成 mixin 中间类使用实例方法方式
      final typeParamNames = cls.typeParameters.map((tp) => tp.name ?? 'T').toList();
      final typeParamStr = typeParamNames.isEmpty ? '' : '<${typeParamNames.join(', ')}>';

      _buf.write('${_pad}static final Map<Type, Map<String, dynamic>> vptrCache = {};\n');
      _buf.write('${_pad}Map<String, dynamic>? instanceVptr;\n');

      _buf.write('${_pad}@override\n');
      _buf.write('${_pad}Map<String, dynamic> get vptr {\n');
      _indent++;
      _buf.write('${_pad}if (instanceVptr == null) {\n');
      _indent++;
      _buf.write('${_pad}final _typeKey = ${className}Value${typeParamStr};\n');
      _buf.write('${_pad}instanceVptr = vptrCache[_typeKey];\n');
      _buf.write('${_pad}if (instanceVptr == null) {\n');
      _indent++;
      _buf.write('${_pad}instanceVptr = $parentInitExpr;\n');
      _buf.write('${_pad}initVptr(instanceVptr!);\n');
      _buf.write('${_pad}vptrCache[_typeKey] = instanceVptr!;\n');
      _indent--;
      _buf.write('${_pad}}\n');
      _indent--;
      _buf.write('${_pad}}\n');
      _buf.write('${_pad}return instanceVptr!;\n');
      _indent--;
      _buf.write('${_pad}}\n');

      // 当父类也有 _initVptr 时，需要 @override
      if (parentUsesInstanceApproach) {
        _buf.write('${_pad}@override\n');
      }
      _buf.write('${_pad}void initVptr(Map<String, dynamic> target) {\n');
      _indent++;

      if (mixinEntries.isEmpty) {
        _indent--;
        _buf.write('${_pad}}\n');
        return;
      }
    } else {
      // 非泛型合成 mixin 中间类：内联初始化
      _buf.write('${_pad}static Map<String, dynamic>? vptrMap;\n');
      _buf.write('${_pad}@override\n');
      _buf.write('${_pad}Map<String, dynamic> get vptr => getVptrMap();\n');

      _buf.write('${_pad}static Map<String, dynamic> getVptrMap() {\n');
      _indent++;
      _buf.write('${_pad}if (vptrMap == null) {\n');
      _indent++;
      _buf.write('${_pad}vptrMap = $parentInitExpr;\n');

      // 内联注册 mixin 条目
      if (mixinEntries.isNotEmpty) {
        final mixinSupertype = cls.mixedInType!;
        final mixinClass = mixinSupertype.classNode;
        final mixinIsSpecialized =
            mixinSupertype.typeArguments.any((t) => t is! TypeParameterType);
        final mixinTypeArgStrs = mixinSupertype.typeArguments
            .map((t) => _restoreTypeForSignature(t))
            .toList();
        for (final entry in mixinEntries) {
          final key = _vptrEntryKey(entry);
          final mixinName = mixinClass.name;
          String staticFuncName;
          if (entry.kind == 'getter') {
            staticFuncName = _staticGetterName(mixinName, entry.name);
          } else if (entry.kind == 'setter') {
            staticFuncName = _staticSetterName(mixinName, entry.name);
          } else {
            staticFuncName = _staticMethodName(mixinName, entry.name);
          }
          String rhs;
          if (entry.proc != null) {
            final mixinClassTpNames =
                mixinClass.typeParameters.map((tp) => tp.name).toSet();
            final methodTpsDedup = entry.proc!.function.typeParameters
                .where((tp) => !mixinClassTpNames.contains(tp.name))
                .toList();
            final callTypeArgsList = <String>[
              if (mixinClass.typeParameters.isNotEmpty)
                if (mixinIsSpecialized)
                  ...mixinTypeArgStrs
                else
                  ...cls.typeParameters.map((tp) => tp.name ?? 'T'),
              ...methodTpsDedup.map((_) => 'dynamic'),
            ];
            final callTypeArgsStr = callTypeArgsList.isEmpty
                ? ''
                : '<${callTypeArgsList.join(', ')}>';
            rhs = _buildTearOffWrapperExpr(
              staticFuncName: staticFuncName,
              callTypeArgsStr: callTypeArgsStr,
            );
          } else {
            rhs = staticFuncName;
          }
          _buf.write("${_pad}vptrMap!['$key'] = $rhs;\n");
        }
      }

      _indent--;
      _buf.write('${_pad}}\n');
      _buf.write('${_pad}return vptrMap!;\n');
      _indent--;
      _buf.write('${_pad}}\n');
      return;  // 非泛型情况已完成
    }

    if (mixinEntries.isEmpty) {
      _indent--;
      _buf.write('${_pad}}\n');
      return;
    }

    final mixinSupertype = cls.mixedInType!;
    final mixinClass = mixinSupertype.classNode;
    final mixinIsSpecialized =
        mixinSupertype.typeArguments.any((t) => t is! TypeParameterType);
    final mixinTypeArgStrs = mixinSupertype.typeArguments
        .map((t) => _restoreTypeForSignature(t))
        .toList();
    // 以下代码只在泛型情况下执行（非泛型已在上面 return）
    for (final entry in mixinEntries) {
      final key = _vptrEntryKey(entry);
      final mixinName = mixinClass.name;
      String staticFuncName;
      if (entry.kind == 'getter') {
        staticFuncName = _staticGetterName(mixinName, entry.name);
      } else if (entry.kind == 'setter') {
        staticFuncName = _staticSetterName(mixinName, entry.name);
      } else {
        staticFuncName = _staticMethodName(mixinName, entry.name);
      }
      String rhs;
      if (entry.proc != null) {
        final mixinClassTpNames =
            mixinClass.typeParameters.map((tp) => tp.name).toSet();
        final methodTpsDedup = entry.proc!.function.typeParameters
            .where((tp) => !mixinClassTpNames.contains(tp.name))
            .toList();
        final callTypeArgsList = <String>[
          if (mixinClass.typeParameters.isNotEmpty)
            if (mixinIsSpecialized)
              ...mixinTypeArgStrs
            else
              ...cls.typeParameters.map((tp) => tp.name ?? 'T'),
          ...methodTpsDedup.map((_) => 'AnyGC'),
        ];
        final callTypeArgsStr = callTypeArgsList.isEmpty
            ? ''
            : '<${callTypeArgsList.join(', ')}>';
        rhs = _buildTearOffWrapperExpr(
          staticFuncName: staticFuncName,
          callTypeArgsStr: callTypeArgsStr,
        );
      } else {
        rhs = staticFuncName;
      }
      _buf.write("${_pad}target['$key'] = $rhs;\n");
    }

    _indent--;
    _buf.write('${_pad}}\n');
  }

  /// 在 _initVptr 中生成方法级泛型特化 vptr 条目（静态版本）
  void _emitSpecializedVptrEntriesStatic(
    Class cls,
    _VTableEntry entry,
    String className,
  ) {
    final methodName = entry.name;

    // 查找该类该方法所有特化条目（沿继承链）
    final specEntries = <MethodSpecEntry>{};
    final classSpecs = _methodTypeSpecializations[className];
    if (classSpecs != null && classSpecs[methodName] != null) {
      specEntries.addAll(classSpecs[methodName]!);
    }
    var parentName = _classHierarchy[className];
    while (parentName != null) {
      final parentSpecs = _methodTypeSpecializations[parentName];
      if (parentSpecs != null && parentSpecs[methodName] != null) {
        specEntries.addAll(parentSpecs[methodName]!);
      }
      parentName = _classHierarchy[parentName];
    }

    if (specEntries.isEmpty) return;

    for (final specEntry in specEntries) {
      final specKey = '${_vptrEntryKey(entry)}_${specEntry.vptrSuffix}';
      final callTypeArgsList = <String>[
        ...cls.typeParameters.map((tp) => tp.name ?? 'T'),
        ...specEntry.typeArgStrs,
      ];
      final callTypeArgsStr = '<${callTypeArgsList.join(', ')}>';
      final rhs = _buildTearOffWrapperExpr(
        staticFuncName: entry.staticFuncName,
        callTypeArgsStr: callTypeArgsStr,
      );
      _buf.write("${_pad}vptrMap!['$specKey'] = $rhs;\n");
    }
  }

  /// 在 _initVptr 中生成方法级泛型特化 vptr 条目（泛型类实例方法版本）
  /// 使用 target 参数而非 vptrMap!
  void _emitSpecializedVptrEntriesStaticGeneric(
    Class cls,
    _VTableEntry entry,
    String className,
  ) {
    final methodName = entry.name;

    // 查找该类该方法所有特化条目（沿继承链）
    final specEntries = <MethodSpecEntry>{};
    final classSpecs = _methodTypeSpecializations[className];
    if (classSpecs != null && classSpecs[methodName] != null) {
      specEntries.addAll(classSpecs[methodName]!);
    }
    var parentName = _classHierarchy[className];
    while (parentName != null) {
      final parentSpecs = _methodTypeSpecializations[parentName];
      if (parentSpecs != null && parentSpecs[methodName] != null) {
        specEntries.addAll(parentSpecs[methodName]!);
      }
      parentName = _classHierarchy[parentName];
    }

    if (specEntries.isEmpty) return;

    for (final specEntry in specEntries) {
      final specKey = '${_vptrEntryKey(entry)}_${specEntry.vptrSuffix}';
      final callTypeArgsList = <String>[
        ...cls.typeParameters.map((tp) => tp.name ?? 'T'),
        ...specEntry.typeArgStrs,
      ];
      final callTypeArgsStr = '<${callTypeArgsList.join(', ')}>';
      final rhs = _buildTearOffWrapperExpr(
        staticFuncName: entry.staticFuncName,
        callTypeArgsStr: callTypeArgsStr,
      );
      _buf.write("${_pad}target['$specKey'] = $rhs;\n");
    }
  }

  /// 为继承非用户类基类的 Value 类生成桥接方法
  /// 检测基类中的抽象方法，生成 override 桥接到 vptr 的实现
  void _emitRuntimeParentBridgeMethods(Class cls, String parentName) {
    // 获取实际的超类链中的抽象方法
    final superClass = cls.supertype?.classNode;
    if (superClass == null) return;

    final abstractMethods = <Procedure>[];
    _collectAbstractMethodsFromChain(superClass, abstractMethods, <String>{});

    for (final method in abstractMethods) {
      final methodName = method.name.text;
      final returnType = _restoreType(method.function.returnType);
      final params = method.function.positionalParameters;
      final paramStr = params.map((p) => '${_restoreType(p.type)} ${p.name ?? '_'}').join(', ');
      _buf.write('${_pad}@override\n');
      _buf.write('${_pad}$returnType $methodName($paramStr) {\n');
      _indent++;
      _buf.write('${_pad}return (vptr[\'$methodName\'] as $returnType Function(AnyGC))(this);\n');
      _indent--;
      _buf.write('${_pad}}\n');
    }
  }

  /// 沿着超类链收集所有抽象方法
  void _collectAbstractMethodsFromChain(Class cls, List<Procedure> result, Set<String> visited) {
    for (final proc in cls.procedures) {
      if (proc.isAbstract && !visited.contains(proc.name.text)) {
        visited.add(proc.name.text);
        result.add(proc);
      }
    }
    // 继续向上查找
    final superType = cls.supertype;
    if (superType != null && superType.classNode.name != 'Object') {
      _collectAbstractMethodsFromChain(superType.classNode, result, visited);
    }
  }

  /// Bug 22+23: 收集当前类及其继承链上通过 implements 实现的用户自定义接口
  /// 返回接口 Value 类名列表（如 ['ShapeValue']）
  /// 仅收集用户自定义类（排除 SDK 内置类型和 mixin），
  /// 因为只有用户自定义类才会被 lowering 为 Value 类
  List<String> _collectUserImplementedInterfaces(Class cls, String className) {
    final interfaces = <String>[];
    final visited = <String>{};

    void collectFromClass(Class currentCls) {
      for (final implType in currentCls.implementedTypes) {
        final implClassName = _getActualClassName(implType.classNode.name);
        if (visited.contains(implClassName)) continue;
        visited.add(implClassName);

        // 只收集用户自定义类（排除 mixin 和合成中间类）
        if (_isUserClass(implClassName)
            && !_isMixinName(implClassName)
            && !_syntheticLoweredNames.contains(implClassName)) {
          // 多文件支持：使用 Class 节点精确匹配，避免同名类冲突
          final prefix = _crossLibPrefixForClass(implType.classNode);
          // 构建接口 Value 类型（含泛型参数）
          final buf = StringBuffer('$prefix${implClassName}Value');
          if (implType.typeArguments.isNotEmpty) {
            buf.write('<');
            buf.write(implType.typeArguments.map((ta) => _restoreType(ta)).join(', '));
            buf.write('>');
          }
          interfaces.add(buf.toString());
        }
      }

      // 沿着 supertype 链向上收集合成中间类的 implements
      final superType = currentCls.supertype;
      if (superType != null) {
        final superName = _getActualClassName(superType.classNode.name);
        if (_syntheticLoweredNames.contains(superName) || _isSyntheticMixinClassName(superType.classNode.name)) {
          collectFromClass(superType.classNode);
        }
      }
    }

    collectFromClass(cls);
    return interfaces;
  }

  /// Bug 21: 构建 mixin 字段类型参数替换映射
  /// 当合成 mixin 应用类的类型参数名与 mixin 原始类型参数名不同时，
  /// 需要将 mixin 字段类型中的参数名替换为合成类对应的参数名。
  /// 例如：Observable<T> 混入 ReactiveStore<V>，合成类 ...ObservableValue<V>
  /// → 需要 {T → V} 替换映射
  Map<String, String> _buildMixinFieldTypeSubstitution(Class cls) {
    final substitution = <String, String>{};
    // 收集当前类的 mixedInType 映射
    if (cls.mixedInType != null) {
      final mixinClass = cls.mixedInType!.classNode;
      final mixedInArgs = cls.mixedInType!.typeArguments;
      for (var i = 0; i < mixinClass.typeParameters.length && i < mixedInArgs.length; i++) {
        final mixinParamName = mixinClass.typeParameters[i].name ?? 'T$i';
        final actualType = _restoreType(mixedInArgs[i]);
        if (mixinParamName != actualType) {
          substitution[mixinParamName] = actualType;
        }
      }
    }
    // 同时收集 supertype 链上合成类的 mixedInType 映射
    // 以覆盖多层 mixin 场景
    var currentClass = cls;
    while (currentClass.supertype != null) {
      final superCls = currentClass.supertype!.classNode;
      if (!_isSyntheticMixinClassName(superCls.name)) break;
      if (superCls.mixedInType != null) {
        final mixinClass = superCls.mixedInType!.classNode;
        final mixedInArgs = superCls.mixedInType!.typeArguments;
        // 需要先把 supertype 的类型参数映射应用到 mixedInArgs
        final superTypeArgs = currentClass.supertype!.typeArguments;
        final superParamMap = <String, String>{};
        for (var i = 0; i < superCls.typeParameters.length && i < superTypeArgs.length; i++) {
          final paramName = superCls.typeParameters[i].name ?? 'T$i';
          superParamMap[paramName] = _restoreType(superTypeArgs[i]);
        }
        for (var i = 0; i < mixinClass.typeParameters.length && i < mixedInArgs.length; i++) {
          final mixinParamName = mixinClass.typeParameters[i].name ?? 'T$i';
          var actualType = _restoreType(mixedInArgs[i]);
          actualType = _substituteTypeStr(actualType, superParamMap);
          // 再用已有的 cls 级替换映射替换
          actualType = _substituteTypeStr(actualType, substitution);
          if (mixinParamName != actualType) {
            substitution[mixinParamName] = actualType;
          }
        }
      }
      currentClass = superCls;
    }
    return substitution;
  }

  /// 收集当前类及所有父类的字段
  /// 只收集当前类自己定义的字段（不包括从父类继承的）
  /// 包括 mixin 引入的字段（通过 mixedInType）
  void _collectOwnFields(Class cls, List<Field> fieldsToEmit) {
    final seenNames = <String>{};
    
    // 收集 mixedInType 的字段（mixin 引入的新字段）
    if (cls.mixedInType != null) {
      final mixinClass = cls.mixedInType!.classNode;
      for (final field in mixinClass.fields) {
        if (field.isStatic) continue;
        if (!seenNames.contains(field.name.text)) {
          seenNames.add(field.name.text);
          fieldsToEmit.add(field);
        }
      }
    }
    
    // 收集当前类自己定义的字段
    for (final field in cls.fields) {
      if (field.isStatic) continue;
      if (!seenNames.contains(field.name.text)) {
        seenNames.add(field.name.text);
        fieldsToEmit.add(field);
      }
    }
  }

  void _collectAllFields(Class cls, List<Field> allFields, Set<String> seenNames) {
    // 先收集父类的字段
    if (cls.supertype != null) {
      final superClass = cls.supertype!.classNode;
      if (_isUserClass(superClass.name) || _isSyntheticMixinClassName(superClass.name) || _isMixinName(superClass.name)) {
        _collectAllFields(superClass, allFields, seenNames);
      }
    }

    // 收集 mixedInType 的字段（mixin 的字段可能不在 supertype 链中）
    if (cls.mixedInType != null) {
      final mixinClass = cls.mixedInType!.classNode;
      if (_isMixinName(mixinClass.name) || _isUserClass(mixinClass.name) || _isSyntheticMixinClassName(mixinClass.name)) {
        _collectAllFields(mixinClass, allFields, seenNames);
      }
    }
    
    // 再收集当前类的字段（覆盖同名字段）
    for (final field in cls.fields) {
      if (field.isStatic) continue;
      if (!seenNames.contains(field.name.text)) {
        seenNames.add(field.name.text);
        allFields.add(field);
      }
    }
  }

  /// 收集所有 VTable 条目（包括从父类和 mixin 继承的）
  /// [cls] 是当前类的 Class 节点（多文件模式下需要用来精确查找）
  List<_VTableEntry> _collectAllVTableEntries(String className, [Class? cls]) {
    final entries = <_VTableEntry>[];
    final seenKeys = <String>{};

    // 从当前类开始，向上遍历继承链
    String? currentClass = className;
    Class? currentCls = cls;
    while (currentClass != null && _isUserClass(currentClass)) {
      // 多文件支持：使用 Class 节点精确查找
      final classEntries = _isMultiFileMode && currentCls != null
          ? _getVTableEntries(currentCls, currentClass)
          : _getVTableEntriesByName(currentClass);
      if (classEntries != null) {
        for (final entry in classEntries) {
          final key = '${entry.kind}:${entry.name}';
          if (!seenKeys.contains(key)) {
            seenKeys.add(key);
            // 将 staticFuncName 替换为当前类的静态函数名，保留 declaringClassName
            final updatedEntry = _VTableEntry(
              name: entry.name,
              kind: entry.kind,
              staticFuncName: _getStaticFuncName(className, entry.name, entry.kind),
              signature: entry.signature,
              proc: entry.proc,
              declaringClassName: entry.declaringClassName,
            );
            entries.add(updatedEntry);
          }
        }
      }
      // 获取父类
      if (_isMultiFileMode && currentCls != null && currentCls.supertype != null) {
        currentCls = currentCls.supertype!.classNode;
        currentClass = _loweredClassName(currentCls.name);
      } else {
        currentClass = _getParentClassName(currentClass);
        currentCls = null;
      }
    }

    return entries;
  }
  
  /// 从当前类 cls 的继承链中，解析出祖先类 ancestorCls 的具体类型参数
  /// 例如：StringToIntTransformer extends DataTransformer<String, int>
  /// → 返回 ['String', 'int']
  /// 如果类型参数仍然是类型变量（如 Box<T> extends Container<T>），则返回变量名
  List<String>? _resolveConcreteTypeArgsForAncestor(Class cls, Class ancestorCls) {
    // 沿着 supertype 链向上查找 ancestorCls
    var currentClass = cls;
    while (true) {
      final superType = currentClass.supertype;
      if (superType == null) return null;

      if (superType.classNode == ancestorCls) {
        // 找到了目标祖先类，提取具体化的类型参数
        if (superType.typeArguments.isEmpty) return null;
        return superType.typeArguments.map((ta) => _restoreType(ta)).toList();
      }

      // 如果当前 superType 的类型参数中包含映射关系，需要沿着链继续往上找
      // 并在找到后进行类型参数替换
      currentClass = superType.classNode;

      // 检查 currentClass 是否最终继承自 ancestorCls
      // 递归地在 currentClass 的继承链中查找
      final result = _resolveConcreteTypeArgsForAncestor(currentClass, ancestorCls);
      if (result != null) {
        // 将 currentClass 的类型参数映射到从 cls 传入的具体类型
        // 例如：A extends B<T>, B extends C<T>
        // superType.typeArguments 是从 cls→currentClass 的映射
        if (superType.typeArguments.isNotEmpty && currentClass.typeParameters.isNotEmpty) {
          final typeParamMap = <String, String>{};
          for (var i = 0; i < currentClass.typeParameters.length && i < superType.typeArguments.length; i++) {
            final paramName = currentClass.typeParameters[i].name ?? 'T$i';
            typeParamMap[paramName] = _restoreType(superType.typeArguments[i]);
          }
          // 替换 result 中仍然是类型变量的部分
          return result.map((typeStr) {
            return typeParamMap[typeStr] ?? typeStr;
          }).toList();
        }
        return result;
      }

      return null;
    }
  }

  /// 获取静态函数名
  String _getStaticFuncName(String className, String methodName, String kind) {
    if (kind == 'getter') {
      return _staticGetterName(className, methodName);
    } else if (kind == 'setter') {
      return _staticSetterName(className, methodName);
    } else if (kind == 'operator') {
      return _staticMethodName(className, methodName);
    } else {
      return _staticMethodName(className, methodName);
    }
  }


  /// 生成静态字段（提升到模块级）
  void _emitStaticFields(Class cls, String className) {
    for (final field in cls.fields) {
      if (!field.isStatic) continue;
      _buf.write(_pad);
      if (field.isLate) _buf.write('late ');
      if (field.isConst) _buf.write('const ');
      else if (field.isFinal) _buf.write('final ');
      _buf.write(_restoreType(field.type));
      // 静态字段名加类名前缀避免冲突
      _buf.write(' ${className}_${field.name.text}');
      if (field.initializer != null) {
        _buf.write(' = ');
        _isStaticFieldContext = true;
        _buf.write(_restoreExpr(field.initializer!));
        _isStaticFieldContext = false;
      }
      _buf.write(';\n');
    }
  }

  /// 生成构造函数 → X_new / X_new_name 顶层函数
  /// 新模式：接收外部传入的 this_，返回 void，只负责初始化字段
  /// 调用点负责创建 XValue 对象并传入
  /// 注：vptr 条目已由静态 _initVptr 注册，_new 函数不再操作 vptr
  void _emitConstructorFunction(Class cls, Constructor ctor, String className, String? parentName) {
    final ctorName = ctor.name.text;
    final funcName = ctorName.isEmpty ? '${className}_new' : '${className}_new_$ctorName';

    // 返回类型为 XValue，第一个参数为 this_，函数返回 this_ 以支持内联构造表达式
    final typeParamNamesForReturn = cls.typeParameters.isNotEmpty
        ? '<${cls.typeParameters.map((tp) => tp.name ?? 'T').join(', ')}>'
        : '';
    final returnType = '${className}Value$typeParamNamesForReturn';
    _buf.write('$returnType $funcName');
    // 构造函数也需要类型参数（如 Pair_new<A, B>），声明位置用完整约束
    _writeTypeParams(cls.typeParameters);
    _buf.write('(AnyGC this__');

    // 其余参数列表（排除 this. 语义，直接作为普通参数）
    final hasParams = _hasParams(ctor.function);
    if (hasParams) {
      _buf.write(', ');
      _writeParams(ctor.function);
    }
    _buf.write(') {\n');
    _indent++;
    // cast this__ 为具体类型
    _buf.write('${_pad}final this_ = this__ as ${className}Value');
    _writeTypeParamNames(cls.typeParameters);
    _buf.write(';\n');

    // 检查是否是 redirecting constructor
    final hasRedirecting = ctor.initializers.any((init) => init is RedirectingInitializer);
    if (hasRedirecting) {
      // Redirecting constructor: 调用目标构造函数（传入 this_）
      for (final init in ctor.initializers) {
        if (init is RedirectingInitializer) {
          final redirCtorName = init.target.name.text;
          final targetFuncName = redirCtorName.isEmpty
              ? '${className}_new'
              : '${className}_new_$redirCtorName';
          final redirArgs = _restoreArgs(init.arguments);
          _buf.write('${_pad}$targetFuncName(this_');
          if (redirArgs.isNotEmpty) _buf.write(', $redirArgs');
          _buf.write(');\n');
        }
      }
      _buf.write('${_pad}return this_;\n');
      _indent--;
      _buf.write('}\n\n');
      return;
    }

    // 父类初始化：先调用父类 new 函数（传入 this_），父类会设置父类的 vptr
    for (final init in ctor.initializers) {
      if (init is SuperInitializer) {
        _emitSuperInit(init, parentName, className);
      }
    }

    // vptr 条目已由静态 _initVptr 注册（per-type 共享），_new 函数不再操作 vptr

    // 字段初始化（展开初始化列表）
    for (final init in ctor.initializers) {
      if (init is FieldInitializer) {
        _buf.write('${_pad}this_.${init.field.name.text} = ');
        _insideMethodBody = true;
        _buf.write(_restoreExpr(init.value));
        _insideMethodBody = false;
        _buf.write(';\n');
      } else if (init is AssertInitializer) {
        _buf.write('${_pad}assert(');
        _insideMethodBody = true;
        _buf.write(_restoreExpr(init.statement.condition));
        if (init.statement.message != null) {
          _buf.write(', ${_restoreExpr(init.statement.message!)}');
        }
        _insideMethodBody = false;
        _buf.write(');\n');
      }
    }

    // 处理 this.field 参数 → this_.field = param
    _emitThisFieldAssignments(ctor, cls);

    // 为有初始值但未在初始化列表或 this.field 参数中处理的字段生成默认值赋值
    _emitFieldDefaultValues(ctor, cls);

    // 构造函数体（this → this_）
    if (ctor.function.body != null && ctor.function.body is! EmptyStatement) {
      _insideMethodBody = true;
      _thisReplacementName = 'this_';
      final ctorContextName = ctorName.isEmpty ? '${className}_new' : '${className}_new_$ctorName';
      _pushClosureContext(ctorContextName);
      _emitBodyWithThisReplacement(ctor.function.body!, 'this_');
      _popClosureContext();
      _thisReplacementName = 'this_';
      _insideMethodBody = false;
    }

    _buf.write('${_pad}return this_;\n');
    _indent--;
    _buf.write('}\n\n');
  }

  /// 判断构造函数是否有参数（排除 this. 参数）
  bool _hasParams(FunctionNode func) {
    return func.positionalParameters.isNotEmpty || func.namedParameters.isNotEmpty;
  }

  /// 根据 VTable 条目类型生成 vptr Map 的 key 字符串
  /// - getter → 'get_xxx'
  /// - setter → 'set_xxx'
  /// - operator → 'operatorXxx'（由 _operatorFuncName 决定后缀）
  /// - 普通 method → 由 _vtableFieldName 决定（保留特殊命名如 toString_）
  String _vptrEntryKey(_VTableEntry entry) {
    if (entry.kind == 'getter') return 'get_${entry.name}';
    if (entry.kind == 'setter') return 'set_${entry.name}';
    if (entry.kind == 'operator') return 'operator${_operatorFuncName(entry.name)}';
    return _vtableFieldName(entry.name);
  }

  /// 调用父类 new 函数（传入 this_）实现基类构造
  /// 如果父类是合成 mixin 中间类（不生成构造函数），则沿继承链向上
  /// 找到真正的非合成用户类来调用其构造函数
  void _emitSuperInit(SuperInitializer init, String? parentName, String className) {
    if (parentName == null || !_isUserClass(parentName)) return;
    
    // 沿继承链向上找到真正的非合成类（合成类不生成构造函数）
    String actualParent = parentName;
    while (_isSyntheticMixinClassName(actualParent) || 
           _isSyntheticLoweredName(actualParent)) {
      final next = _getParentClassName(actualParent);
      if (next == null || !_isUserClass(next)) break;
      actualParent = next;
    }
    
    // 如果最终找到的父类仍然是合成类，说明没有真正的用户类构造函数可调用
    if (_isSyntheticLoweredName(actualParent)) return;
    
    final superCtorName = init.target.name.text;
    final parentFuncName = superCtorName.isEmpty
        ? '${actualParent}_new'
        : '${actualParent}_new_$superCtorName';

    // 构建类型参数：从当前类的 supertype 获取具体化的类型实参
    String typeArgStr = '';
    if (_currentClass != null && _currentClass!.supertype != null) {
      final superType = _currentClass!.supertype!;
      // 沿继承链找到 actualParent 对应的具体类型参数
      final targetClass = _classNodes[actualParent];
      if (targetClass != null && targetClass.typeParameters.isNotEmpty) {
        final concreteArgs = _resolveConcreteTypeArgsForAncestor(_currentClass!, targetClass);
        if (concreteArgs != null && concreteArgs.isNotEmpty) {
          typeArgStr = '<${concreteArgs.join(', ')}>';
        } else if (superType.typeArguments.isNotEmpty) {
          typeArgStr = '<${superType.typeArguments.map((ta) => _restoreType(ta)).join(', ')}>';
        }
      }
    }

    final superArgs = _restoreArgs(init.arguments);
    // 多文件支持：使用 Class 节点精确匹配，避免同名类冲突
    // 从 init.target 获取父类的 Class 节点
    final prefix = _crossLibPrefixForClass(init.target.enclosingClass);
    _buf.write('${_pad}$prefix$parentFuncName$typeArgStr(this_');
    if (superArgs.isNotEmpty) _buf.write(', $superArgs');
    _buf.write(');\n');
  }
  
  /// 判断是否是合成 mixin 中间类的 lowered 名称（如 Dog_Animal_Printable_Orderable）
  /// 这些类名是由 _sanitizeSyntheticName 生成的，包含多个 _ 分隔的类名
  bool _isSyntheticLoweredName(String name) {
    // 检查原始类名映射：如果 _classHierarchy 中有这个名字，
    // 且它不是原始用户类名（即不在原始 Dart 源码中定义），则是合成类
    // 简单判断：如果名字中包含多个大写字母开头的段（如 Dog_Animal_Printable），
    // 且不是原始用户类名，则认为是合成类
    // 更可靠的方式：检查是否有对应的合成类原始名
    return _syntheticLoweredNames.contains(name);
  }

  /// 处理 this.field 参数 → this_.field = param
  void _emitThisFieldAssignments(Constructor ctor, Class cls) {
    final fieldNames = cls.fields.where((f) => !f.isStatic).map((f) => f.name.text).toSet();
    // 位置参数中的 this.field
    for (final param in ctor.function.positionalParameters) {
      final paramName = _cleanVarName(param.name ?? '');
      if (fieldNames.contains(paramName)) {
        // 检查是否已经在初始化列表中处理过
        final alreadyInited = ctor.initializers.any((init) =>
            init is FieldInitializer && init.field.name.text == paramName);
        if (!alreadyInited) {
          _buf.write('${_pad}this_.$paramName = $paramName;\n');
        }
      }
    }
    // 命名参数中的 this.field
    for (final param in ctor.function.namedParameters) {
      final paramName = _cleanVarName(param.name ?? '');
      if (fieldNames.contains(paramName)) {
        final alreadyInited = ctor.initializers.any((init) =>
            init is FieldInitializer && init.field.name.text == paramName);
        if (!alreadyInited) {
          _buf.write('${_pad}this_.$paramName = $paramName;\n');
        }
      }
    }
  }

  /// 为有初始值但未在初始化列表或 this.field 参数中处理的字段生成默认值赋值
  /// 例如：`bool _initialized = false;` → `this_._initialized = false;`
  /// 注意：当前所有 OOP lowered 字段都是 late，初始化已在字段定义处发射，
  /// 此方法保留作为兜底，但循环体通常不会执行
  void _emitFieldDefaultValues(Constructor ctor, Class cls) {
    // 当前所有字段初始化已在字段定义处发射（利用 Dart late 惰性语义），
    // 构造函数中无需重复赋值。此方法保留作为未来扩展的占位符。
  }

  /// 生成 vptr 注册的右值表达式：直接 tear-off 静态函数本身
  /// （`Dog_speak` 或带类/方法级泛型实参的 `Dog_map<T, U>`）。
  /// 读取端用 `as R Function(...)` 强转后直接调用。
  String _buildVptrLambdaWrapper(Class cls, _VTableEntry entry, String className, String typeParamStr) {
    final proc = entry.proc;
    if (proc == null) {
      // 没有 FunctionNode 信息 → 无类型形参可附加，直接给裸名。
      return entry.staticFuncName;
    }

    // 与静态函数签名生成器 `_writeCombinedTypeParams` 一致的去重逻辑：
    // 类参数优先，方法参数中与类同名的被去除（避免 `<A,B,C,C>` 这种重复声明）。
    final classTpNames = cls.typeParameters.map((tp) => tp.name).toSet();
    final dedupedMethodTps = proc.function.typeParameters
        .where((tp) => !classTpNames.contains(tp.name))
        .toList();

    // tear-off 时附加的泛型实参：类的类型参数 + 去重后的方法级类型参数。
    final callTypeArgsList = <String>[
      ...cls.typeParameters.map((tp) => tp.name ?? 'T'),
      ...dedupedMethodTps.map((tp) => tp.name ?? 'T'),
    ];
    final callTypeArgsStr =
        callTypeArgsList.isEmpty ? '' : '<${callTypeArgsList.join(', ')}>';

    return _buildTearOffWrapperExpr(
      staticFuncName: entry.staticFuncName,
      callTypeArgsStr: callTypeArgsStr,
    );
  }

  /// 返回 vptr 注册用的右值表达式：直接 tear-off 静态函数
  /// （`Dog_speak` 或带泛型实参的 `Dog_map<int, String>`），由读取端
  /// `as R Function(...)` 强转后直接调用，无需再套 wrapper 类。
  ///
  /// `callTypeArgsStr` 是 tear-off 时附加的泛型实参字符串
  /// （如 `'<A, B>'` / `'<int, String>'` / 空串）。
  String _buildTearOffWrapperExpr({
    required String staticFuncName,
    required String callTypeArgsStr,
  }) {
    return '$staticFuncName$callTypeArgsStr';
  }

  // _defaultValueForType 已移至 _DartRestorerBase 基类中

  /// 输出方法体，将 this 替换为指定变量名
  void _emitBodyWithThisReplacement(Statement body, String thisReplacement) {
    // 方法体内的 this 会在 _ExpressionRestorer 中被替换
    // 这里只需要正常输出语句
    if (body is Block) {
      for (final s in body.statements) {
        _restoreStmt(s);
      }
    } else {
      _restoreStmt(body);
    }
  }

  /// 生成实例方法 → 静态函数
  void _emitInstanceMethodAsStatic(Class cls, Procedure proc, String className) {
    if (proc.isAbstract && proc.function.body == null) {
      _emitAbstractMethodPlaceholder(cls, proc, className);
      return;
    }

    // Bug 11: 预分析本方法，识别哪些参数/局部变量被内部闭包捕获，需要 Box 化
    final savedBoxedVars = Set<VariableDeclaration>.from(_boxedVars);
    final savedCurrentParams = Set<VariableDeclaration>.from(_currentFunctionParams);
    final boxedParamsForMethod = _preanalyzeBoxedParams(proc);

    final methodName = proc.name.text;
    final funcName = proc.isGetter
        ? _staticGetterName(className, methodName)
        : proc.isSetter
            ? _staticSetterName(className, methodName)
            : _staticMethodName(className, methodName);

    _emitInstanceMethodSignature(cls, proc, className, funcName);

    // body
    final marker = proc.function.asyncMarker;
    if (proc.function.body != null) {
      _buf.write(' ');
      _insideMethodBody = true;
      final isVoidReturn = proc.function.returnType is VoidType || proc.isSetter;
      _emitInstanceMethodBody(cls, proc, className, boxedParamsForMethod, isVoidReturn, marker);
      _insideMethodBody = false;
    } else {
      _buf.write(';\n');
    }
    _buf.write('\n');

    // Bug 11: 恢复快照
    _boxedVars
      ..clear()
      ..addAll(savedBoxedVars);
    _currentFunctionParams
      ..clear()
      ..addAll(savedCurrentParams);
  }

  /// 预分析方法参数，识别被闭包捕获需要 Box 化的参数
  List<VariableDeclaration> _preanalyzeBoxedParams(Procedure proc) {
    if (proc.function.body != null) {
      _preanalyzeBoxedVarsForFunc(proc.function);
      _currentFunctionParams
        ..clear()
        ..addAll(proc.function.positionalParameters)
        ..addAll(proc.function.namedParameters);
    }
    final boxedParams = <VariableDeclaration>[];
    for (final p in proc.function.positionalParameters) {
      if (_boxedVars.contains(p)) boxedParams.add(p);
    }
    for (final p in proc.function.namedParameters) {
      if (_boxedVars.contains(p)) boxedParams.add(p);
    }
    return boxedParams;
  }

  /// 发射实例方法转静态函数的签名
  void _emitInstanceMethodSignature(Class cls, Procedure proc, String className, String funcName) {
    _buf.write(_pad);
    _buf.write(_asyncAwareRestoreType(proc.function.returnType, proc.function.asyncMarker));
    _buf.write(' $funcName');
    _writeCombinedTypeParams(cls.typeParameters, proc.function.typeParameters);
    _buf.write('(AnyGC this__');

    if (proc.isSetter) {
      if (proc.function.positionalParameters.isNotEmpty) {
        final p = proc.function.positionalParameters.first;
        final cleanName = _cleanVarName(p.name ?? 'value');
        p.name = cleanName;
        _buf.write(', ${_restoreType(p.type)} $cleanName');
      }
    } else if (!proc.isGetter) {
      final pos = proc.function.positionalParameters;
      final named = proc.function.namedParameters;
      if (pos.isNotEmpty || named.isNotEmpty) {
        _buf.write(', ');
        _writeParams(proc.function, proc: proc, suppressCovariant: true, flattenOptional: true);
      }
    }

    _buf.write(')');
    final marker = proc.function.asyncMarker;
    if (marker == AsyncMarker.AsyncStar) _buf.write(' async*');
    if (marker == AsyncMarker.SyncStar) _buf.write(' sync*');
  }

  /// 发射实例方法的方法体（区分 async 和 sync 路径）
  void _emitInstanceMethodBody(Class cls, Procedure proc, String className,
      List<VariableDeclaration> boxedParams, bool isVoidReturn, AsyncMarker marker) {
    if (marker == AsyncMarker.Async) {
      _emitAsyncInstanceMethodBody(cls, proc, className, boxedParams);
    } else {
      _emitSyncInstanceMethodBody(cls, proc, className, boxedParams, isVoidReturn);
    }
  }

  /// 发射 async 实例方法体 — ClosureEnv 闭包延迟执行模式
  void _emitAsyncInstanceMethodBody(Class cls, Procedure proc, String className,
      List<VariableDeclaration> boxedParams) {
    final methodName = proc.name.text;
    final innerRetType = _computeAsyncInnerReturnType(proc.function.returnType);
    final allParams = <VariableDeclaration>[
      ...proc.function.positionalParameters,
      ...proc.function.namedParameters,
    ];
    final classTypeParamStr = cls.typeParameters.isNotEmpty
        ? '<${cls.typeParameters.map((tp) => tp.name ?? 'T').join(', ')}>'
        : '';
    final thisTypeStr = '${className}Value$classTypeParamStr';
    final envBaseName = '${className}_$methodName';
    _pushClosureContext(envBaseName);
    _emitAsyncClosureEnvForMethod(
      envBaseName: _closureContext,
      func: proc.function,
      innerReturnType: innerRetType,
      params: allParams,
      thisParam: thisTypeStr,
      thisRawParam: 'this__',
      boxedParams: boxedParams,
      classTypeParams: classTypeParamStr,
    );
    _popClosureContext();
  }

  /// 发射 sync 实例方法体 — 直接内联
  void _emitSyncInstanceMethodBody(Class cls, Procedure proc, String className,
      List<VariableDeclaration> boxedParams, bool isVoidReturn) {
    _buf.write('{\n');
    _indent++;
    final classTypeParamStr = cls.typeParameters.isNotEmpty
        ? '<${cls.typeParameters.map((tp) => tp.name ?? 'T').join(', ')}>'
        : '';
    _buf.write('${_pad}final this_ = this__ as ${className}Value$classTypeParamStr;\n');
    // Bug 11: 参数 Box 包装（仅基础值类型）
    for (final p in boxedParams) {
      final baseName = p.name!;
      final boxType = _boxTypeNameFor(p.type)!;
      _buf.write('$_pad$boxType $baseName = $boxType(${baseName}_raw);\n');
    }
    final body = proc.function.body!;
    if (body is Block) {
      for (final s in body.statements) {
        if (isVoidReturn && s is ReturnStatement) {
          if (s.expression != null) {
            _buf.write('$_pad${_restoreExpr(s.expression!)};\n');
          }
          continue;
        }
        _restoreStmt(s);
      }
    } else if (isVoidReturn && body is ReturnStatement) {
      if (body.expression != null) {
        _buf.write('$_pad${_restoreExpr(body.expression!)};\n');
      }
    } else {
      _restoreStmt(body);
    }
    _indent--;
    _buf.write('$_pad}\n');
  }

  /// 为抽象方法生成占位实现（抛出 UnimplementedError）
  /// 这样虚表中的槽位可以正确引用到这个函数，子类会覆盖虚表中的函数指针
  void _emitAbstractMethodPlaceholder(Class cls, Procedure proc, String className) {
    final methodName = proc.name.text;
    String funcName;
    if (proc.isGetter) {
      funcName = _staticGetterName(className, methodName);
    } else if (proc.isSetter) {
      funcName = _staticSetterName(className, methodName);
    } else {
      funcName = _staticMethodName(className, methodName);
    }

    _buf.write(_pad);
    _buf.write(_restoreType(proc.function.returnType));
    _buf.write(' $funcName');
    // 抽象方法也需要类型参数声明：类的类型参数 + 方法自身的类型参数
    _writeCombinedTypeParams(cls.typeParameters, proc.function.typeParameters);
    // 抽象方法的 this_ 参数也统一使用 dynamic，和普通方法/委托方法一致
    _buf.write('(dynamic this_');

    if (proc.isSetter) {
      if (proc.function.positionalParameters.isNotEmpty) {
        final p = proc.function.positionalParameters.first;
        final cleanName = _cleanVarName(p.name ?? 'value');
        p.name = cleanName;
        _buf.write(', ${_restoreType(p.type)} $cleanName');
      }
    } else if (!proc.isGetter) {
      final pos = proc.function.positionalParameters;
      final named = proc.function.namedParameters;
      if (pos.isNotEmpty || named.isNotEmpty) {
        _buf.write(', ');
        _writeParams(proc.function, proc: proc, suppressCovariant: true);
      }
    }

    _buf.write(') {\n');
    _indent++;
    _buf.write('${_pad}throw UnimplementedError(\'${className}.$methodName is abstract\');\n');
    _indent--;
    _buf.write('}\n\n');
  }

  /// 生成静态方法或工厂方法
  void _emitStaticOrFactoryProcedure(Class cls, Procedure proc, String className) {
    if (proc.isFactory) {
      // 工厂方法 → 顶层函数 X_new_factoryName 或 X_new
      final factoryName = proc.name.text;
      final funcName = factoryName.isEmpty
          ? '${className}_new'
          : '${className}_new_$factoryName';

      _buf.write(_pad);
      _buf.write('${className}Value');
      _writeTypeParams(cls.typeParameters);
      _buf.write(' $funcName(');
      _writeParams(proc.function, proc: proc);
      _buf.write(')');

      // async marker removed: replaced by state machine smAwait

      if (proc.function.body != null) {
        _buf.write(' ');
        _insideMethodBody = true;
        _restoreBody(proc.function.body!);
        _insideMethodBody = false;
      } else {
        _buf.write(';\n');
      }
      _buf.write('\n');
    } else {
      // 静态方法 → 顶层函数 X_methodName
      _buf.write(_pad);
      _buf.write(_restoreType(proc.function.returnType));
      _buf.write(' ${className}_${proc.name.text}');
      _writeTypeParams(proc.function.typeParameters);
      _buf.write('(');
      _writeParams(proc.function, proc: proc);
      _buf.write(')');

      final marker = proc.function.asyncMarker;
      // async marker removed: replaced by state machine smAwait
      if (marker == AsyncMarker.AsyncStar) _buf.write(' async*');
      if (marker == AsyncMarker.SyncStar) _buf.write(' sync*');

      if (proc.function.body != null) {
        _buf.write(' ');
        final savedInsideMethodBody = _insideMethodBody;
        _insideMethodBody = true;
        _restoreBody(proc.function.body!);
        _insideMethodBody = savedInsideMethodBody;
      } else {
        _buf.write(';\n');
      }
      _buf.write('\n');
    }
  }

  /// 非用户自定义类保持原始输出
  void _restoreClassOriginal(Class cls) {
    if (cls.isAbstract) _buf.write('abstract ');
    _buf.write('class ${cls.name}');
    _writeTypeParams(cls.typeParameters);

    if (cls.supertype != null) {
      final superName = cls.supertype!.classNode.name;
      if (superName.contains('&')) {
        final realSuper = _resolveRealSuperclass(cls.supertype!.classNode);
        final mixins = _collectMixins(cls.supertype!.classNode);
        if (realSuper != 'Object') {
          _buf.write(' extends $realSuper');
        }
        if (mixins.isNotEmpty) {
          _buf.write(' with ${mixins.join(', ')}');
        }
      } else if (superName != 'Object') {
        _buf.write(' extends ');
        _buf.write(_restoreSupertype(cls.supertype!));
      }
    }

    if (cls.implementedTypes.isNotEmpty) {
      _buf.write(' implements ');
      _buf.write(cls.implementedTypes.map((s) => _restoreSupertype(s)).join(', '));
    }

    _buf.write(' {\n');
    _indent++;
    _restoreClassMembers(cls);
    _indent--;
    _buf.write('}\n\n');
  }

  void _restoreClassMembers(Class cls) {
    for (final f in cls.fields) _restoreField(f);
    for (final c in cls.constructors) _restoreConstructor(cls, c);
    for (final p in cls.procedures) _restoreProcedure(p);
  }

  // ---- Field ----

  void _restoreField(Field field, {bool isTopLevel = false}) {
    _buf.write(_pad);
    // 顶层字段在 Kernel 中标记为 isStatic，但 Dart 源码中不输出 static
    if (field.isStatic && !isTopLevel) _buf.write('static ');
    if (field.isLate) _buf.write('late ');
    if (field.isConst) _buf.write('const ');
    else if (field.isFinal) _buf.write('final ');
    _buf.write(_restoreType(field.type));
    _buf.write(' ${field.name.text}');
    if (field.initializer != null) {
      _buf.write(' = ');
      // 顶层/静态字段初始化中的对象创建应使用 GC.allocateGlobal
      final newContext = isTopLevel || field.isStatic;
      final savedStaticFieldContext = _isStaticFieldContext;
      _isStaticFieldContext = newContext;
      try {
        _buf.write(_restoreExpr(field.initializer!));
      } finally {
        _isStaticFieldContext = savedStaticFieldContext;
      }
    }
    _buf.write(';\n');
  }

  // ---- Constructor ----

  void _restoreConstructor(Class cls, Constructor ctor) {
    _buf.write(_pad);
    if (ctor.isConst) _buf.write('const ');
    _buf.write(cls.name);
    final ctorName = ctor.name.text;
    if (ctorName.isNotEmpty) _buf.write('.$ctorName');
    _buf.write('(');
    _writeParams(ctor.function);
    _buf.write(')');

    // 初始化列表
    final inits = <String>[];
    for (final init in ctor.initializers) {
      if (init is FieldInitializer) {
        inits.add('${init.field.name.text} = ${_restoreExpr(init.value)}');
      } else if (init is SuperInitializer) {
        final superCtorName = init.target.name.text;
        final args = _restoreArgs(init.arguments);
        if (superCtorName.isEmpty) {
          inits.add('super($args)');
        } else {
          inits.add('super.$superCtorName($args)');
        }
      } else if (init is RedirectingInitializer) {
        final redirName = init.target.name.text;
        final args = _restoreArgs(init.arguments);
        if (redirName.isEmpty) {
          inits.add('this($args)');
        } else {
          inits.add('this.$redirName($args)');
        }
      } else if (init is AssertInitializer) {
        final cond = _restoreExpr(init.statement.condition);
        final msg = init.statement.message != null
            ? ', ${_restoreExpr(init.statement.message!)}'
            : '';
        inits.add('assert($cond$msg)');
      }
    }
    if (inits.isNotEmpty) {
      _buf.write(' : ${inits.join(', ')}');
    }

    // body
    if (ctor.function.body != null && ctor.function.body is! EmptyStatement) {
      _buf.write(' ');
      _restoreStmt(ctor.function.body!);
    } else {
      _buf.write(';\n');
    }
    _buf.write('\n');
  }

  // ---- Procedure ----

  void _restoreProcedure(Procedure proc) {
    if (proc.isAbstract && proc.function.body == null) {
      _restoreAbstractProcedure(proc);
      return;
    }

    // 扩展方法：函数名包含 | 字符（如 "StringExtensions|capitalize"）
    final rawName = proc.name.text;
    if (_isExtensionMethodName(rawName)) {
      _restoreExtensionProcedure(proc);
      return;
    }

    // Bug 11: 预分析本函数，识别哪些参数/局部变量被内部闭包捕获，需要 Box 化
    final savedBoxedVars = Set<VariableDeclaration>.from(_boxedVars);
    final savedCurrentParams = Set<VariableDeclaration>.from(_currentFunctionParams);
    final boxedParamsForProc = _preanalyzeBoxedParams(proc);

    _emitProcedureSignature(proc);

    // async marker
    final marker = proc.function.asyncMarker;
    if (marker == AsyncMarker.AsyncStar) _buf.write(' async*');
    if (marker == AsyncMarker.SyncStar) _buf.write(' sync*');

    // body
    _emitProcedureBody(proc, boxedParamsForProc);
    _buf.write('\n');

    // Bug 11: 恢复快照
    _boxedVars
      ..clear()
      ..addAll(savedBoxedVars);
    _currentFunctionParams
      ..clear()
      ..addAll(savedCurrentParams);
  }

  /// 发射普通过程的签名（工厂/getter/setter/普通方法/运算符）
  void _emitProcedureSignature(Procedure proc) {
    _buf.write(_pad);
    if (proc.isStatic && proc.enclosingClass != null && !proc.isFactory) _buf.write('static ');
    if (proc.isFactory) {
      _buf.write('factory ');
      _buf.write(proc.enclosingClass!.name);
      final factoryName = proc.name.text;
      if (factoryName.isNotEmpty) _buf.write('.$factoryName');
      _buf.write('(');
      _writeParams(proc.function, proc: proc);
      _buf.write(')');
    } else if (proc.isGetter) {
      _buf.write(_restoreType(proc.function.returnType));
      _buf.write(' get ${proc.name.text}');
    } else if (proc.isSetter) {
      _buf.write('set ${proc.name.text}');
      _buf.write('(');
      _writeParams(proc.function);
      _buf.write(')');
    } else {
      _emitNormalProcedureSignature(proc);
    }
  }

  /// 发射普通方法/函数的签名（含 @override 检查、main 特殊处理、运算符）
  void _emitNormalProcedureSignature(Procedure proc) {
    if (proc.enclosingClass != null) {
      for (final ann in proc.annotations) {
        if (ann is ConstantExpression && ann.constant is InstanceConstant) {
          final ic = ann.constant as InstanceConstant;
          if (ic.classNode.name == 'override') {
            _buf.write('@override\n$_pad');
          }
        }
      }
    }
    // main 函数特殊处理：保持 void 返回，body 同步执行
    final isMainFunc = proc.name.text == 'main' && proc.enclosingClass == null;
    if (isMainFunc) {
      _buf.write(_restoreType(proc.function.returnType));
    } else {
      _buf.write(_asyncAwareRestoreType(proc.function.returnType, proc.function.asyncMarker));
    }
    _buf.write(' ');
    final name = proc.name.text;
    if (_isOperatorName(name)) {
      _buf.write('operator $name');
    } else {
      _buf.write(name);
    }
    _writeTypeParams(proc.function.typeParameters);
    _buf.write('(');
    _writeParams(proc.function, proc: proc);
    _buf.write(')');
  }

  /// 发射过程的方法体（区分 async 和 sync 路径）
  void _emitProcedureBody(Procedure proc, List<VariableDeclaration> boxedParams) {
    if (proc.function.body == null) {
      _buf.write(';\n');
      return;
    }
    _buf.write(' ');
    final isVoidReturn = proc.function.returnType is VoidType || proc.isSetter;
    final marker = proc.function.asyncMarker;
    final isMainFunc = proc.name.text == 'main' && proc.enclosingClass == null;

    // async 函数 → ClosureEnv 闭包延迟执行模式（main 函数例外）
    if (marker == AsyncMarker.Async && !isMainFunc) {
      _emitAsyncProcedureBody(proc, boxedParams);
    } else if (isMainFunc) {
      _restoreMainBody(proc.function.body!, boxedParams);
    } else if (isVoidReturn) {
      _restoreSetterBody(proc.function.body!);
    } else if (boxedParams.isNotEmpty) {
      _restoreBodyWithBoxedParams(proc.function.body!, boxedParams);
    } else {
      _restoreBody(proc.function.body!);
    }
  }

  /// 发射 async 过程体 — ClosureEnv 闭包延迟执行模式
  void _emitAsyncProcedureBody(Procedure proc, List<VariableDeclaration> boxedParams) {
    final innerRetType = _computeAsyncInnerReturnType(proc.function.returnType);
    final allParams = <VariableDeclaration>[
      ...proc.function.positionalParameters,
      ...proc.function.namedParameters,
    ];
    final funcName = proc.name.text;
    _pushClosureContext(funcName);
    _emitAsyncClosureEnv(
      envBaseName: _closureContext,
      func: proc.function,
      innerReturnType: innerRetType,
      params: allParams,
      boxedParams: boxedParams,
    );
    _popClosureContext();
  }

  /// 还原扩展方法（函数名包含 | 字符）为顶层静态函数
  /// Kernel AST 中扩展方法格式：
  ///   "StringExtensions|capitalize"      → StringExtensions_capitalize(String this_, ...)
  ///   "StringExtensions|get#capitalize"  → String Function() StringExtensions_get_capitalize(String this_)
  ///   "ListExtensions|filterWhere"        → ListExtensions_filterWhere(List<T> this_, ...)
  void _restoreExtensionProcedure(Procedure proc) {
    if (proc.function.body == null) return;

    final rawName = proc.name.text;
    final cleanedFuncName = _sanitizeExtensionMethodName(rawName);

    _buf.write(_pad);
    _buf.write(_asyncAwareRestoreType(proc.function.returnType, proc.function.asyncMarker));
    _buf.write(' $cleanedFuncName');
    _writeTypeParams(proc.function.typeParameters);
    _buf.write('(');
    _writeParamsWithExtensionThis(proc.function, proc: proc);
    _buf.write(')');

    final marker = proc.function.asyncMarker;
    // async marker removed: replaced by state machine smAwait
    if (marker == AsyncMarker.AsyncStar) _buf.write(' async*');
    if (marker == AsyncMarker.SyncStar) _buf.write(' sync*');

    _buf.write(' ');
    _insideMethodBody = true;

    final isVoidReturn = proc.function.returnType is VoidType || proc.isSetter;

    // async 扩展方法 → ClosureEnv 闭包延迟执行模式
    // 所有 async 函数统一 lowering（含 void → int、裸值类型 → Promise<T>）
    if (marker == AsyncMarker.Async) {
      final innerRetType = _computeAsyncInnerReturnType(proc.function.returnType);
      final allParams = <VariableDeclaration>[
        ...proc.function.positionalParameters,
        ...proc.function.namedParameters,
      ];
      _pushClosureContext(cleanedFuncName);
      _emitAsyncClosureEnv(
        envBaseName: _closureContext,
        func: proc.function,
        innerReturnType: innerRetType,
        params: allParams,
      );
      _popClosureContext();
    } else {
      _pushClosureContext(cleanedFuncName);
      if (isVoidReturn) {
        _restoreSetterBody(proc.function.body!);
      } else {
        _restoreBody(proc.function.body!);
      }
      _popClosureContext();
    }
    _insideMethodBody = false;
    _buf.write('\n');
  }

  /// 输出扩展方法的参数列表，将 "this" 参数名改为 "this_"
  void _writeParamsWithExtensionThis(FunctionNode func, {Procedure? proc}) {
    final pos = func.positionalParameters;
    final named = func.namedParameters;
    final reqCount = func.requiredParameterCount;
    final parts = <String>[];

    for (var i = 0; i < pos.length; i++) {
      final p = pos[i];
      final sb = StringBuffer();
      if (_needsCovariant(p, func, proc)) sb.write('covariant ');
      if (p.isFinal) sb.write('final ');
      sb.write(_restoreType(p.type));
      sb.write(' ');
      // 将 "this" 参数名改为 "this_"（扩展方法的 receiver 参数）
      final rawParamName = p.name ?? '_p$i';
      final cleanName = rawParamName == 'this' ? 'this_' : _cleanVarName(rawParamName);
      sb.write(cleanName);
      p.name = cleanName;
      if (i >= reqCount && p.initializer != null) {
        sb.write(' = ${_restoreExpr(p.initializer!)}');
      }
      parts.add(sb.toString());
    }

    if (named.isNotEmpty) {
      if (parts.isNotEmpty) {
        _buf.write(parts.join(', '));
        _buf.write(', ');
      }
      _buf.write('{${_namedParams(named)}}');
    } else {
      _buf.write(parts.join(', '));
    }
  }

  void _restoreAbstractProcedure(Procedure proc) {
    _buf.write(_pad);
    if (proc.isGetter) {
      _buf.write(_restoreType(proc.function.returnType));
      _buf.write(' get ${proc.name.text};\n\n');
    } else {
      _buf.write(_restoreType(proc.function.returnType));
      _buf.write(' ');
      _buf.write(proc.name.text);
      _writeTypeParams(proc.function.typeParameters);
      _buf.write('(');
      _writeParams(proc.function, proc: proc);
      _buf.write(');\n\n');
    }
  }

  /// 输出方法体，确保始终包裹在 {} 中
  void _restoreBody(Statement body) {
    if (body is Block) {
      _restoreBlock(body);
    } else {
      // 单条语句（如 ReturnStatement）也要包裹在 {} 中
      _buf.write('{\n');
      _indent++;
      _restoreStmt(body);
      _indent--;
      _buf.write('$_pad}\n');
    }
  }

  /// 输出方法体，支持在 body 开头插入参数 Box 包装语句（Bug 11）。
  /// - boxedParams: 需要 Box 化的参数列表
  /// - 对每个 p，生成 `BoxType name = BoxType(name_raw);` 插入到 body 开头
  /// - 调用此方法前，应当已经把 p 加入 `_boxedVars` 集合，这样 _writeParams 会输出 _raw 后缀
  void _restoreBodyWithBoxedParams(Statement body, List<VariableDeclaration> boxedParams) {
    if (boxedParams.isEmpty) {
      _restoreBody(body);
      return;
    }
    _buf.write('{\n');
    _indent++;
    // 写入参数 Box 包装（仅基础值类型）
    for (final p in boxedParams) {
      final baseName = p.name!;
      final boxType = _boxTypeNameFor(p.type)!;
      _buf.write('$_pad$boxType $baseName = $boxType(${baseName}_raw);\n');
    }
    // 写入原 body 内容
    if (body is Block) {
      for (final s in body.statements) {
        _restoreStmt(s);
      }
    } else {
      _restoreStmt(body);
    }
    _indent--;
    _buf.write('$_pad}\n');
  }

  void _restoreSetterBody(Statement body) {
    if (body is Block) {
      _buf.write('{\n');
      _indent++;
      for (final s in body.statements) {
        if (s is ReturnStatement) {
          // setter 中 return expr; → 只输出 expr;（去掉 return）
          if (s.expression != null) {
            _buf.write('$_pad${_restoreExpr(s.expression!)};\n');
          }
          continue;
        }
        _restoreStmt(s);
      }
      _indent--;
      _buf.write('$_pad}\n');
    } else if (body is ReturnStatement) {
      // 单条 return 语句的 setter body
      _buf.write('{\n');
      _indent++;
      if (body.expression != null) {
        _buf.write('$_pad${_restoreExpr(body.expression!)};\n');
      }
      _indent--;
      _buf.write('$_pad}\n');
    } else {
      _restoreBody(body);
    }
  }

  /// 还原 main 函数体，在末尾添加 drainScheduler() 调用
  /// 模拟 Dart 事件循环在 main() 返回后继续处理异步任务的行为
  void _restoreMainBody(Statement body, List<VariableDeclaration> boxedParams) {
    _buf.write('{\n');
    _indent++;

    // 写入参数 Box 包装（仅基础值类型）
    for (final p in boxedParams) {
      final baseName = p.name!;
      final boxType = _boxTypeNameFor(p.type)!;
      _buf.write('$_pad$boxType $baseName = $boxType(${baseName}_raw);\n');
    }

    if (body is Block) {
      for (final s in body.statements) {
        _restoreStmt(s);
      }
    } else {
      _restoreStmt(body);
    }

    // 在 body 末尾添加 drainScheduler() 调用
    _buf.write('${_pad}drainScheduler();\n');

    _indent--;
    _buf.write('$_pad}\n');
  }

  // ---- Parameters ----

  void _writeTypeParams(List<TypeParameter> params) {
    if (params.isEmpty) return;
    _buf.write('<');
    for (var i = 0; i < params.length; i++) {
      if (i > 0) _buf.write(', ');
      _buf.write(params[i].name ?? 'T');
      {
        final bound = _restoreType(params[i].bound);
        if (bound != 'Object' && bound != 'Object?' && bound != 'dynamic') {
          _buf.write(' extends $bound');
        }
      }
    }
    _buf.write('>');
  }

  /// 只写类型参数名称（不含 extends 约束），用于函数参数类型位置
  /// 例如：`<T>` 而非 `<T extends Comparable<dynamic>>`
  void _writeTypeParamNames(List<TypeParameter> params) {
    if (params.isEmpty) return;
    _buf.write('<');
    for (var i = 0; i < params.length; i++) {
      if (i > 0) _buf.write(', ');
      _buf.write(params[i].name ?? 'T');
    }
    _buf.write('>');
  }

  /// 写入合并后的类型参数声明（类的类型参数 + 方法自身的类型参数）
  /// 用于实例方法转静态函数时的类型参数声明位置
  void _writeCombinedTypeParams(List<TypeParameter> classParams, List<TypeParameter> methodParams) {
    if (classParams.isEmpty && methodParams.isEmpty) return;
    // 去重：方法类型参数中与类类型参数同名的跳过，避免 <A,B,C,C> 这种重复声明
    final classParamNames = classParams.map((tp) => tp.name).toSet();
    final deduped = <TypeParameter>[
      ...classParams,
      ...methodParams.where((tp) => !classParamNames.contains(tp.name)),
    ];
    if (deduped.isEmpty) return;
    _writeTypeParams(deduped);
  }

  void _writeParams(FunctionNode func, {Procedure? proc, bool suppressCovariant = false, bool flattenOptional = false}) {
    final pos = func.positionalParameters;
    final named = func.namedParameters;
    final reqCount = func.requiredParameterCount;
    final parts = <String>[];
    var openedBracket = false;

    for (var i = 0; i < pos.length; i++) {
      final p = pos[i];
      if (i == reqCount && !openedBracket && !flattenOptional) {
        openedBracket = true;
        // 开始可选位置参数
      }
      final sb = StringBuffer();
      // covariant 必须在 final 前面（顶层静态函数中不允许 covariant）
      if (!suppressCovariant && _needsCovariant(p, func, proc)) sb.write('covariant ');
      if (p.isFinal) sb.write('final ');
      final defaultExpr =
          (!flattenOptional && i >= reqCount && p.initializer != null)
              ? _restoreExpr(p.initializer!)
              : null;
      sb.write(_paramTypeForDefault(p.type, defaultExpr));
      sb.write(' ');
      final cleanName = _cleanVarName(p.name ?? '_p$i');
      // 写回清理后的名称
      p.name = cleanName;
      // Bug 11: 被 Box 化的参数，输出时参数名加 _raw 后缀（原名留给函数体内 Box 局部变量）
      final displayName = _boxedVars.contains(p) ? '${cleanName}_raw' : cleanName;
      sb.write(displayName);
      if (defaultExpr != null) {
        sb.write(' = $defaultExpr');
      }
      parts.add(sb.toString());
    }

    if (flattenOptional) {
      // flattenOptional：named 也按声明顺序铺平为 positional，没有 `{...}`
      // 块、没有 `required`、没有默认值（调用方补齐）。
      for (final p in named) {
        final sb = StringBuffer();
        if (p.isFinal) sb.write('final ');
        sb.write(_restoreParamType(p.type));
        sb.write(' ');
        final cleanName = _cleanVarName(p.name ?? '_n');
        p.name = cleanName;
        final displayName =
            _boxedVars.contains(p) ? '${cleanName}_raw' : cleanName;
        sb.write(displayName);
        parts.add(sb.toString());
      }
      _buf.write(parts.join(', '));
      return;
    }

    if (openedBracket) {
      final reqParts = parts.sublist(0, reqCount);
      final optParts = parts.sublist(reqCount);
      final allParts = <String>[...reqParts, '[${optParts.join(', ')}]'];
      if (named.isNotEmpty) {
        allParts.add('{${_namedParams(named)}}');
      }
      _buf.write(allParts.join(', '));
    } else if (named.isNotEmpty) {
      if (parts.isNotEmpty) {
        _buf.write(parts.join(', '));
        _buf.write(', ');
      }
      _buf.write('{${_namedParams(named)}}');
    } else {
      _buf.write(parts.join(', '));
    }
  }

  String _namedParams(List<VariableDeclaration> named) {
    return named.map((p) {
      final sb = StringBuffer();
      if (p.isRequired) sb.write('required ');
      if (p.isFinal) sb.write('final ');
      final defaultExpr =
          p.initializer != null ? _restoreExpr(p.initializer!) : null;
      sb.write(_paramTypeForDefault(p.type, defaultExpr));
      sb.write(' ');
      final cleanName = _cleanVarName(p.name ?? '_n');
      p.name = cleanName;
      // Bug 11: 被 Box 化的 named 参数也加 _raw 后缀
      final displayName = _boxedVars.contains(p) ? '${cleanName}_raw' : cleanName;
      sb.write(displayName);
      if (defaultExpr != null) {
        sb.write(' = ${_promoteConstCollectionDefault(defaultExpr, p.type)}');
      }
      return sb.toString();
    }).join(', ');
  }

  /// 当默认值是 const 集合字面量时，直接保留原始默认值表达式。
  /// 参数类型会通过 _paramTypeForDefault 降级为原生 Iterable 类型以兼容 const 默认值。
  String _promoteConstCollectionDefault(String defaultExpr, DartType type) {
    return defaultExpr;
  }

  /// 参数签名类型解析：当默认值是 const 集合字面量时，降级为原生 Iterable/Map 类型
  /// 以兼容 compile-time constant 约束。StaticList extends Iterable<T>，所以
  /// 调用端传入 StaticList 实例兼容 Iterable<T> 参数。
  String _paramTypeForDefault(DartType type, String? defaultExpr) {
    final restored = _restoreParamType(type);
    if (defaultExpr == null) return restored;
    if (!_isConstCollectionLiteral(defaultExpr)) return restored;
    return _demoteStaticCollectionType(restored);
  }

  bool _isConstCollectionLiteral(String s) {
    final t = s.trimLeft();
    return t.startsWith('const [') ||
        t.startsWith('const {') ||
        t.startsWith('const <');
  }

  /// 降级 Static* 类型：StaticList→Iterable, StaticSet→Iterable, StaticMap→Map
  /// StaticList/StaticSet extends Iterable<T>，降级到 Iterable 而非 List/Set
  /// 确保 const 默认值（原生类型）和调用端 Static* 实例都兼容。
  String _demoteStaticCollectionType(String restored) {
    for (final entry in const [
      ('StaticList', 'Iterable'),
      ('StaticSet', 'Iterable'),
      ('StaticMap', 'Map'),
    ]) {
      final (from, to) = entry;
      if (restored == from || restored == '$from?') {
        return restored.replaceFirst(from, to);
      }
      if (restored.startsWith('$from<')) {
        return '$to${restored.substring(from.length)}';
      }
    }
    return restored;
  }

}
