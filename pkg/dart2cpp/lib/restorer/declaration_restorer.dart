part of 'dart_restorer.dart';

// ============================================================================
// Declaration Restorer: Handles type definitions, classes, fields, and methods
// ============================================================================

mixin _DeclarationRestorer on _DartRestorerBase, _TypeUtils, _ExpressionRestorer, _StatementRestorer {
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
    
    final returnType = _restoreType(proc.function.returnType);
    
    _buf.write('$returnType $funcName');
    // 类型参数声明：mixin 类的类型参数 + 方法自身的类型参数
    _writeCombinedTypeParams(cls.typeParameters, proc.function.typeParameters);
    _buf.write('(dynamic this__');
    
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
      if (marker == AsyncMarker.Async && !isVoidReturn) {
        final retType = proc.function.returnType;
        String innerRetType = 'dynamic';
        if (retType is InterfaceType && retType.typeArguments.isNotEmpty) {
          innerRetType = _restoreType(retType.typeArguments.first);
        }
        final allParams = <VariableDeclaration>[
          ...proc.function.positionalParameters,
          ...proc.function.namedParameters,
        ];
        final envBaseName = '${mixinName}_$methodName';
        _buf.write(' ');
        _pushClosureContext(envBaseName);
        _emitAsyncClosureEnvForMethod(
          envBaseName: _closureContext,
          func: proc.function,
          innerReturnType: innerRetType,
          params: allParams,
          thisParam: 'dynamic',
          thisRawParam: 'this__',
        );
        _popClosureContext();
      } else {
        // 非 async 路径：保持原有逻辑
        _buf.write(' {\n');
        _indent++;
        _buf.write('${_pad}final this_ = this__;\n');

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
    // 检查是否是 Kernel 脱糖后的 enum（superclass 是 _Enum）
    if (_isEnumClass(cls)) {
      _restoreEnum(cls);
      return;
    }

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
    final allEntries = _collectAllVTableEntries(className);
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
    
    _buf.write('${_pad}dynamic $funcName(${className}Value this_) {\n');
    _indent++;
    _buf.write("${_pad}throw UnimplementedError('$className.$methodName delegate missing proc');\n");
    _indent--;
    _buf.write('}\n\n');
  }
  
  /// 使用原始 Procedure 的参数信息生成委托静态函数
  /// 委托函数直接调用原始定义该方法的类的静态函数，避免通过 vptr 调用自己形成无限递归
  void _emitDelegateFromProc(Class cls, Procedure proc, _VTableEntry entry, String className) {
    final methodName = entry.name;
    String funcName;
    if (entry.kind == 'getter') {
      funcName = _staticGetterName(className, methodName);
    } else if (entry.kind == 'setter') {
      funcName = _staticSetterName(className, methodName);
    } else {
      funcName = _staticMethodName(className, methodName);
    }
    
    // 找到原始定义该方法的类名
    final originClass = proc.enclosingClass;
    String originClassName = originClass != null ? _loweredClassName(originClass.name) : className;
    
    // 如果原始类是合成中间类（不生成静态函数），
    // 需要找到真正定义该方法的 mixin 或用户类
    if (_syntheticLoweredNames.contains(originClassName)) {
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
            final parentEntries = _classVTableEntries[parentName];
            if (parentEntries != null && parentEntries.any((e) => e.name == methodName && e.kind == entry.kind)) {
              originClassName = parentName;
              break;
            }
          }
          parentName = _getParentClassName(parentName);
        }
      }
    }
    
    // 原始定义类的静态函数名
    String originFuncName;
    if (entry.kind == 'getter') {
      originFuncName = _staticGetterName(originClassName, methodName);
    } else if (entry.kind == 'setter') {
      originFuncName = _staticSetterName(originClassName, methodName);
    } else {
      originFuncName = _staticMethodName(originClassName, methodName);
    }
    
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
    // 但不包含已被具体化（替换掉）的父类类型参数
    if (typeSubstitution.isNotEmpty) {
      // 只写方法自身的类型参数（非来自类的类型参数）
      _writeCombinedTypeParams(cls.typeParameters, proc.function.typeParameters);
    } else {
      _writeCombinedTypeParams(cls.typeParameters, proc.function.typeParameters);
    }
    // this_ 参数类型：统一使用 dynamic，消除调用侧的 as Function
    _buf.write('(dynamic this__');
    
    // 构建参数列表和转发参数
    final forwardArgs = <String>['this_'];
    
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
    
    _buf.write(') {\n');
    _indent++;
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

      _buf.write('$originFuncName$originTypeArgStr(${forwardArgs.join(', ')});\n');
    }
    
    _indent--;
    _buf.write('}\n\n');
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
      final concreteArgs = _resolveOriginConcreteTypeArgs(cls, originClass);
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
  List<String>? _resolveOriginConcreteTypeArgs(Class cls, Class originClass) {
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
      if (mixedIn != null && mixedIn.classNode == originClass) {
        if (mixedIn.typeArguments.isEmpty) return null;
        return mixedIn.typeArguments
            .map((ta) => _substituteTypeStr(_restoreType(ta), typeParamMap))
            .toList();
      }

      // 进入上一层之前，更新 typeParamMap：
      // currentClass 的类型参数 → superType.typeArguments（用 typeParamMap 替换后）
      final nextClass = superType.classNode;
      if (nextClass == originClass) {
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
      _buf.write(' extends ${parentName}Value$parentTypeArgs');
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
      _buf.write(';\n');
    }

    // 当继承非用户类基类（如 AsyncStateMachine）时，需要添加 vptr 字段和桥接方法
    // 因为该基类不提供 vptr，且可能有抽象方法需要桥接
    final hasRuntimeParent = parentName != null && !_isUserClass(parentName) && superType != null;
    if (hasRuntimeParent) {
      // 添加 vptr 字段
      _buf.write('${_pad}late Map<String, dynamic> vptr = <String, dynamic>{};\n');
      // 为基类中的抽象方法生成桥接实现（delegate 到 vptr）
      _emitRuntimeParentBridgeMethods(cls, parentName!);
    }

    // vptr 字段和 toString/operator==/hashCode 覆写由 VPtr 基类统一提供
    // 不再在每个 Value 类中重复生成（仅对继承 VPtr 的类有效）

    // 生成构造方法，在其中注册 vptr 条目
    _emitValueClassConstructor(cls, className, parentName, isSyntheticMixinClass);

    _indent--;
    _buf.write('}\n\n');
  }

  /// 在 Value 类中生成构造方法，注册 vptr 条目
  /// 非合成类：注册当前类所有的 vtable 条目（含继承，使用当前类的委托函数名）
  /// 合成 mixin 中间类：注册该层 mixin 引入的 vtable 条目
  void _emitValueClassConstructor(Class cls, String className, String? parentName, bool isSyntheticMixinClass) {
    if (isSyntheticMixinClass) {
      _emitSyntheticMixinValueConstructor(cls, className, parentName);
      return;
    }

    // 非合成类：收集所有 vtable 条目
    final entries = _collectAllVTableEntries(className);
    if (entries.isEmpty) return;

    final hasClassTypeParams = cls.typeParameters.isNotEmpty;
    final typeParamNames = cls.typeParameters.map((tp) => tp.name ?? 'T').toList();
    final typeParamStr = hasClassTypeParams ? '<${typeParamNames.join(', ')}>' : '';
    final classTpNames = cls.typeParameters.map((tp) => tp.name).toSet();

    // 检查是否存在方法级泛型特化条目（这些仍需在 _new 函数中注册）
    // 构造方法中只注册非特化条目
    final normalEntries = <_VTableEntry>[];
    for (final entry in entries) {
      if (entry.proc != null) {
        final dedupedMethodTps = entry.proc!.function.typeParameters
            .where((tp) => !classTpNames.contains(tp.name))
            .toList();
        if (dedupedMethodTps.isNotEmpty) {
          // 方法级泛型特化条目，跳过（在 _new 函数中处理）
          continue;
        }
      }
      normalEntries.add(entry);
    }

    if (normalEntries.isEmpty) return;

    // 生成构造方法
    _buf.write('$_pad${className}Value() {\n');
    _indent++;

    for (final entry in normalEntries) {
      final key = _vptrEntryKey(entry);
      final rhs = _buildVptrLambdaWrapper(cls, entry, className, typeParamStr);
      _buf.write("${_pad}vptr['$key'] = $rhs;\n");
    }

    _indent--;
    _buf.write('$_pad}\n');
  }

  /// 合成 mixin 中间类的 Value 构造方法：注册该层 mixin 引入的 vptr 条目
  void _emitSyntheticMixinValueConstructor(Class cls, String className, String? parentName) {
    // 获取该层 mixin 引入的方法名集合
    final mixinMethodNames = <String>{};
    if (cls.mixedInType != null) {
      final mixinCls = cls.mixedInType!.classNode;
      for (final p in mixinCls.procedures) {
        if (p.isStatic || p.isFactory || p.isAbstract) continue;
        mixinMethodNames.add(p.name.text);
      }
    }

    if (mixinMethodNames.isEmpty) return;

    // 从 _classVTableEntries 中找到对应的 VTable 条目
    final allEntries = _classVTableEntries[className] ?? [];
    final mixinEntries = allEntries.where((entry) {
      return mixinMethodNames.contains(entry.name);
    }).toList();

    if (mixinEntries.isEmpty) return;

    // 生成构造方法
    _buf.write('$_pad${className}Value() {\n');
    _indent++;

    for (final entry in mixinEntries) {
      final key = _vptrEntryKey(entry);
      // 找到该方法的原始 mixin 静态函数名
      final mixinName = cls.mixedInType!.classNode.name;
      String rhs;
      if (entry.kind == 'getter') {
        rhs = _staticGetterName(mixinName, entry.name);
      } else if (entry.kind == 'setter') {
        rhs = _staticSetterName(mixinName, entry.name);
      } else {
        rhs = _staticMethodName(mixinName, entry.name);
      }
      _buf.write("${_pad}vptr['$key'] = $rhs;\n");
    }

    _indent--;
    _buf.write('$_pad}\n');
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
      _buf.write('${_pad}return (vptr[\'$methodName\'] as $returnType Function(dynamic))(this);\n');
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
          // 构建接口 Value 类型（含泛型参数）
          final buf = StringBuffer('${implClassName}Value');
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

  /// 在 Value 类中生成 toString()/operator==/hashCode 的覆写方法
  /// 这些方法桥接到 vptr 中对应的函数指针，确保 Dart 运行时调用时能正确分派
  void _emitObjectMethodOverrides(Class cls, String className, String? parentName) {
    // 检查当前类或其继承链中是否定义了 toString
    final hasToString = _classHasVTableEntry(className, 'toString_', 'method') ||
        _classHasVTableEntry(className, 'toString', 'method');
    // 检查是否定义了 operator==
    final hasOperatorEq = _classHasVTableEntry(className, '==', 'operator');
    // 检查是否定义了 hashCode getter
    final hasHashCode = _classHasVTableEntry(className, 'hashCode', 'getter');

    if (hasToString) {
      _buf.write('$_pad@override\n');
      _buf.write('${_pad}String toString() {\n');
      _indent++;
      _buf.write("${_pad}final toStringFn = vptr['toString_'];\n");
      _buf.write('${_pad}if (toStringFn != null) return (toStringFn as Function)(this) as String;\n');
      _buf.write('${_pad}return super.toString();\n');
      _indent--;
      _buf.write('$_pad}\n');
    }

    if (hasOperatorEq) {
      _buf.write('$_pad@override\n');
      _buf.write('${_pad}bool operator ==(Object other) {\n');
      _indent++;
      _buf.write("${_pad}final eqFn = vptr['operatorEq'];\n");
      _buf.write('${_pad}if (eqFn != null) return (eqFn as Function)(this, other) as bool;\n');
      _buf.write('${_pad}return identical(this, other);\n');
      _indent--;
      _buf.write('$_pad}\n');
    }

    if (hasHashCode) {
      _buf.write('$_pad@override\n');
      _buf.write('${_pad}int get hashCode {\n');
      _indent++;
      _buf.write("${_pad}final hashFn = vptr['get_hashCode'];\n");
      _buf.write('${_pad}if (hashFn != null) return (hashFn as Function)(this) as int;\n');
      _buf.write('${_pad}return super.hashCode;\n');
      _indent--;
      _buf.write('$_pad}\n');
    }
  }

  /// 检查类的 VTable 中是否包含指定名称和类型的条目
  bool _classHasVTableEntry(String className, String entryName, String kind) {
    final entries = _classVTableEntries[className];
    if (entries != null) {
      for (final entry in entries) {
        if (entry.name == entryName && entry.kind == kind) return true;
        // toString 在 vptr 中可能注册为 'toString_' 或 'toString'
        if (kind == 'method' && entryName == 'toString_' && entry.name == 'toString') return true;
      }
    }
    // 检查父类
    final parentName = _getParentClassName(className);
    if (parentName != null && _isUserClass(parentName)) {
      return _classHasVTableEntry(parentName, entryName, kind);
    }
    return false;
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
  List<_VTableEntry> _collectAllVTableEntries(String className) {
    final entries = <_VTableEntry>[];
    final seenKeys = <String>{};
    
    // 从当前类开始，向上遍历继承链
    String? currentClass = className;
    while (currentClass != null && _isUserClass(currentClass)) {
      final classEntries = _classVTableEntries[currentClass];
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
      currentClass = _getParentClassName(currentClass);
    }
    
    return entries;
  }
  
  /// 查找方法的首次声明类名（declaringClassName）
  /// 在 _classVTableEntries 中查找指定方法首次被声明的类名
  /// 返回原始的 declaringClassName，调用方根据类型决定 this_ 参数类型：
  /// - mixin → dynamic
  /// - 合成中间类 → dynamic
  /// - extends 链上的父类 → declaringClassName + Value
  /// - 接口 implements → 当前类名 + Value
  String _findDeclaringClassName(String className, String methodName, String kind) {
    final entries = _classVTableEntries[className];
    if (entries != null) {
      for (final entry in entries) {
        if (entry.name == methodName && entry.kind == kind) {
          return entry.declaringClassName ?? className;
        }
      }
    }
    return className;
  }

  /// 判断 ancestorName 是否在 className 的 extends 继承链上
  bool _isInExtendsChain(String className, String ancestorName) {
    var current = _getParentClassName(className);
    while (current != null) {
      if (current == ancestorName) return true;
      current = _getParentClassName(current);
    }
    return false;
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
        _buf.write(_restoreExpr(field.initializer!));
      }
      _buf.write(';\n');
    }
  }

  /// 生成构造函数 → X_new / X_new_name 顶层函数
  /// 新模式：接收外部传入的 this_，返回 void，只负责设置 vptr 和初始化字段
  /// 调用点负责创建 XValue 对象并传入
  void _emitConstructorFunction(Class cls, Constructor ctor, String className, String? parentName) {
    final ctorName = ctor.name.text;
    final funcName = ctorName.isEmpty ? '${className}_new' : '${className}_new_$ctorName';

    // 获取所有 VTable 条目（包括从父类和 mixin 继承的）
    final entries = _collectAllVTableEntries(className);

    // 返回类型为 XValue，第一个参数为 this_，函数返回 this_ 以支持内联构造表达式
    final typeParamNamesForReturn = cls.typeParameters.isNotEmpty
        ? '<${cls.typeParameters.map((tp) => tp.name ?? 'T').join(', ')}>'
        : '';
    final returnType = '${className}Value$typeParamNamesForReturn';
    _buf.write('$returnType $funcName');
    // 构造函数也需要类型参数（如 Pair_new<A, B>），声明位置用完整约束
    _writeTypeParams(cls.typeParameters);
    _buf.write('(dynamic this__');

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

    // vptr 普通条目已由 Value 类构造方法注册（通过 Dart 构造链自动调用）。
    // 此处只处理方法级泛型特化条目（如 fold_String、then_int），
    // 因为这些条目依赖预扫描收集的具体类型，无法在 Value 类构造方法中静态注册。
    final hasClassTypeParams = cls.typeParameters.isNotEmpty;
    final typeParamNames = cls.typeParameters.map((tp) => tp.name ?? 'T').toList();
    final typeParamStr = hasClassTypeParams ? '<${typeParamNames.join(', ')}>' : '';
    final classTpNames = cls.typeParameters.map((tp) => tp.name).toSet();
    for (final entry in entries) {
      if (entry.proc != null) {
        final dedupedMethodTps = entry.proc!.function.typeParameters
            .where((tp) => !classTpNames.contains(tp.name))
            .toList();
        if (dedupedMethodTps.isNotEmpty) {
          _emitSpecializedVptrEntries(cls, entry, className, typeParamStr, classTpNames, dedupedMethodTps);
        }
      }
    }

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

  /// 类级共享 vtable 常量的全局变量名：`_XX_vtable`
  String _sharedVTableName(String className) => '_${className}_vtable';

  /// 在顶层缓冲区注册类级共享 vtable 常量。
  /// 同一个类有多个构造函数（如 X.named）也只会输出一次。
  /// 形如：
  ///   final Map<String, dynamic> _XX_vtable = <String, dynamic>{
  ///     'k1': v1,
  ///     'k2': v2,
  ///   };
  void _emitSharedVTableConstant(String className, List<(String, String)> keyRhsList) {
    if (_emittedSharedVTableClasses.contains(className)) return;
    _emittedSharedVTableClasses.add(className);

    final sb = StringBuffer();
    sb.write('final Map<String, dynamic> ${_sharedVTableName(className)} = <String, dynamic>{\n');
    for (final kv in keyRhsList) {
      sb.write("  '${kv.$1}': ${kv.$2},\n");
    }
    sb.write('};\n');
    _pendingTopLevelDecls.add(sb.toString());
  }

  /// 判断给定的直接父类名沿合成链向上是否能找到真实的非合成用户类。
  /// 与 _emitSuperInit 中查找真实父类构造函数的行为保持一致：
  /// 跳过合成 mixin 中间类（带 '&'）和合成 lowered 类，
  /// 只要顶端能找到非合成用户类，就视为"有真实用户父类构造"。
  bool _hasRealUserAncestor(String? parentName) {
    if (parentName == null || !_isUserClass(parentName)) return false;
    String current = parentName;
    while (_isSyntheticMixinClassName(current) || _isSyntheticLoweredName(current)) {
      final next = _getParentClassName(current);
      if (next == null || !_isUserClass(next)) return false;
      current = next;
    }
    return !_isSyntheticLoweredName(current) && !_isSyntheticMixinClassName(current);
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
    _buf.write('${_pad}$parentFuncName$typeArgStr(this_');
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
  void _emitFieldDefaultValues(Constructor ctor, Class cls) {
    // 收集已经在初始化列表中处理过的字段名
    final initedFields = <String>{};
    for (final init in ctor.initializers) {
      if (init is FieldInitializer) {
        initedFields.add(init.field.name.text);
      }
    }
    // 收集已经在 this.field 参数中处理过的字段名
    final fieldNames = cls.fields.where((f) => !f.isStatic).map((f) => f.name.text).toSet();
    for (final param in ctor.function.positionalParameters) {
      final paramName = _cleanVarName(param.name ?? '');
      if (fieldNames.contains(paramName)) {
        initedFields.add(paramName);
      }
    }
    for (final param in ctor.function.namedParameters) {
      final paramName = _cleanVarName(param.name ?? '');
      if (fieldNames.contains(paramName)) {
        initedFields.add(paramName);
      }
    }

    // 收集当前类及所有父类/mixin 的字段（与 _emitValueClass 中 _collectAllFields 一致）
    final allFields = <Field>[];
    _collectAllFields(cls, allFields, <String>{});

    // 为有初始值但未处理的字段生成赋值
    // 简化方案（Bug 12）：late field with initializer 也在构造时 eager 求值
    //   原始语义：late + initializer → 首次访问时 lazy 求值并缓存
    //   简化语义：late + initializer → 构造时 eager 求值
    //   限制：
    //   - 改变了 lazy 语义（副作用提前发生）
    //   - 不支持 initializer 依赖构造后才赋值的字段
    //   依赖前提：Bug 14 已修复，initializer 中的私有方法调用可直接走静态函数
    //
    // 还原 initializer 表达式前需要正确设置上下文：
    // - _insideMethodBody = true 让 ThisExpression 被替换为 this_
    // - _thisReplacementName = 'this_' 是当前构造函数中 this 的占位符
    // 调用方（_emitConstructorFunction）此时尚未设置这两个状态
    // Bug 21: 构建 mixin 类型参数替换映射
    // 当 mixin 的字段初始化器引用了 mixin 的类型参数（如 Observable<T> 的 T），
    // 需要替换为当前类对应的类型参数（如 ReactiveStore<V> 的 V）
    final mixinTypeSubstitution = _buildMixinFieldTypeSubstitution(cls);

    final savedInsideMethodBody = _insideMethodBody;
    final savedThisReplacementName = _thisReplacementName;
    final savedTypeParamSubstitution = _activeTypeParamSubstitution;
    _insideMethodBody = true;
    _thisReplacementName = 'this_';
    if (mixinTypeSubstitution.isNotEmpty) {
      // 合并外层已有的替换映射（如非用户类基类的类型参数映射）
      _activeTypeParamSubstitution = {..._activeTypeParamSubstitution, ...mixinTypeSubstitution};
    }
    try {
      for (final field in allFields) {
        if (field.isStatic) continue;
        if (initedFields.contains(field.name.text)) continue;
        if (field.initializer == null) continue;
        _buf.write('${_pad}this_.${field.name.text} = ');
        _buf.write(_restoreExpr(field.initializer!));
        _buf.write(';\n');
      }
    } finally {
      _insideMethodBody = savedInsideMethodBody;
      _thisReplacementName = savedThisReplacementName;
      _activeTypeParamSubstitution = savedTypeParamSubstitution;
    }
  }

  /// 为 vptr 条目生成注册值
  /// 默认参数在调用处补齐，所以注册时按全部参数注册，直接使用静态函数引用。
  /// 为带方法级泛型的方法生成特化 vptr 注册条目。
  /// 根据 _methodTypeSpecializations 中预扫描收集的具体类型，
  /// 为每个特化类型组合生成 'methodName_TypeSuffix' 的 vptr 条目。
  /// 闭包内直接调用原始泛型函数并传入具体类型。
  void _emitSpecializedVptrEntries(
    Class cls,
    _VTableEntry entry,
    String className,
    String typeParamStr,
    Set<String?> classTpNames,
    List<TypeParameter> dedupedMethodTps,
  ) {
    final methodName = entry.name;

    // 查找该类该方法的所有特化条目
    // 需要沿继承链查找：子类可能继承父类的方法，特化注册可能记录在父类名下
    final specEntries = <MethodSpecEntry>{};
    // 先查当前类名
    final classSpecs = _methodTypeSpecializations[className];
    if (classSpecs != null && classSpecs[methodName] != null) {
      specEntries.addAll(classSpecs[methodName]!);
    }
    // 再沿继承链向上查找（方法可能定义在父类中）
    var parentName = _classHierarchy[className];
    while (parentName != null) {
      final parentSpecs = _methodTypeSpecializations[parentName];
      if (parentSpecs != null && parentSpecs[methodName] != null) {
        specEntries.addAll(parentSpecs[methodName]!);
      }
      parentName = _classHierarchy[parentName];
    }

    if (specEntries.isEmpty) return;

    // 为每个特化条目生成 vptr 条目
    final proc = entry.proc!;
    for (final specEntry in specEntries) {
      final specKey = '${_vptrEntryKey(entry)}_${specEntry.vptrSuffix}';

      // 构建调用处类型实参：类的类型参数 + 特化的具体类型
      // 类的类型参数保持原样（如 L, R），方法级泛型替换为具体类型（如 String）
      final callTypeArgsList = <String>[
        ...cls.typeParameters.map((tp) => tp.name ?? 'T'),
        ...specEntry.typeArgStrs,
      ];
      final callTypeArgsStr = '<${callTypeArgsList.join(', ')}>';

      // 直接使用 tear-off 形式：Box_mapValue<T, int>
      // 特化方法的 lambda wrapper 只是原样转发参数，语义等价于直接函数引用
      final rhs = '${entry.staticFuncName}$callTypeArgsStr';
      _buf.write("${_pad}this_.vptr['$specKey'] = $rhs;\n");
    }
  }

  /// 生成 vptr 注册的右值表达式。
  /// 调用点已负责补全命名参数和可选参数，注册端只需要绑定类型参数。
  /// 所有情况都直接使用函数引用（tear-off），不需要 lambda wrapper。
  String _buildVptrLambdaWrapper(Class cls, _VTableEntry entry, String className, String typeParamStr) {
    final proc = entry.proc;
    if (proc == null) {
      return entry.staticFuncName;
    }

    final hasClassTypeParams = typeParamStr.isNotEmpty;
    // 与静态函数签名生成器 `_writeCombinedTypeParams` 完全一致的去重逻辑：
    // 类参数优先，方法参数中与类同名的被去除（避免 `<A,B,C,C>` 这种重复声明）。
    // 例：Triple<A,B,C>.mapFirst<C> → method=[C] 与 cls 中的 C 同名 → dedup 后为空。
    //     TreeNode<T>.map<R>      → method=[R] 不与 cls 同名 → dedup 后 [R]。
    final classTpNames = cls.typeParameters.map((tp) => tp.name).toSet();
    final dedupedMethodTps = proc.function.typeParameters
        .where((tp) => !classTpNames.contains(tp.name))
        .toList();

    // 无泛型 → 直接使用静态函数引用
    if (!hasClassTypeParams && dedupedMethodTps.isEmpty) {
      return entry.staticFuncName;
    }

    // 有泛型 → 带类型参数的函数引用（tear-off）
    // 类型实参：类的类型参数 + 去重后的方法级类型参数
    final callTypeArgsList = <String>[
      ...cls.typeParameters.map((tp) => tp.name ?? 'T'),
      ...dedupedMethodTps.map((tp) => tp.name ?? 'T'),
    ];
    final callTypeArgsStr = '<${callTypeArgsList.join(', ')}>';
    return '${entry.staticFuncName}$callTypeArgsStr';
  }

  // _defaultValueForType 已移至 _DartRestorerBase 基类中

  /// 在类型字符串中替换类型参数名为指定的替换值
  /// 例如：将 "R Function(T)" 中的 R 和 T 替换为 dynamic
  String _replaceTypeParam(String typeStr, String paramName, String replacement) {
    // 使用单词边界匹配，避免替换部分匹配（如 "Result" 中的 "R"）
    return typeStr.replaceAllMapped(
      RegExp('\\b$paramName\\b'),
      (m) => replacement,
    );
  }

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
      // 抽象方法：生成一个抛出 UnimplementedError 的占位实现
      // 这样虚表中的槽位可以正确引用到这个函数
      _emitAbstractMethodPlaceholder(cls, proc, className);
      return;
    }

    // Bug 11: 预分析本方法，识别哪些参数/局部变量被内部闭包捕获，需要 Box 化
    final savedBoxedVars = Set<VariableDeclaration>.from(_boxedVars);
    final savedCurrentParams = Set<VariableDeclaration>.from(_currentFunctionParams);
    if (proc.function.body != null) {
      _preanalyzeBoxedVarsForFunc(proc.function);
      _currentFunctionParams.clear();
      _currentFunctionParams.addAll(proc.function.positionalParameters);
      _currentFunctionParams.addAll(proc.function.namedParameters);
    }
    final boxedParamsForMethod = <VariableDeclaration>[];
    for (final p in proc.function.positionalParameters) {
      if (_boxedVars.contains(p)) boxedParamsForMethod.add(p);
    }
    for (final p in proc.function.namedParameters) {
      if (_boxedVars.contains(p)) boxedParamsForMethod.add(p);
    }

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

    // 返回类型（包含类型参数，如 PairValue<B, A> Pair_swap<A, B>(...)）
    _buf.write(_restoreType(proc.function.returnType));
    _buf.write(' $funcName');
    // 类型参数声明：类的类型参数 + 方法自身的类型参数
    _writeCombinedTypeParams(cls.typeParameters, proc.function.typeParameters);
    _buf.write('(');

    // 第一个参数：this_ 统一使用 dynamic 类型
    // 所有注册到 vptr 的函数 this_ 都是 dynamic，消除调用侧的 as Function
    _buf.write('dynamic this__');

    // 其余参数（顶层静态函数中不允许 covariant）
    if (proc.isSetter) {
      if (proc.function.positionalParameters.isNotEmpty) {
        final p = proc.function.positionalParameters.first;
        final cleanName = _cleanVarName(p.name ?? 'value');
        p.name = cleanName;
        _buf.write(', ${_restoreType(p.type)} $cleanName');
      }
    } else if (!proc.isGetter) {
      // 普通方法的参数
      // flattenOptional: true → 去掉可选参数的默认值和 [] 括号，
      // 所有参数变成必需的，默认值在调用处补齐
      final pos = proc.function.positionalParameters;
      final named = proc.function.namedParameters;
      if (pos.isNotEmpty || named.isNotEmpty) {
        _buf.write(', ');
        _writeParams(proc.function, proc: proc, suppressCovariant: true, flattenOptional: true);
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
      _buf.write(' ');
      _insideMethodBody = true;

      final isVoidReturn = proc.function.returnType is VoidType || proc.isSetter;

      // async 实例方法 → ClosureEnv 闭包延迟执行模式
      if (marker == AsyncMarker.Async && !isVoidReturn) {
        final retType = proc.function.returnType;
        String innerRetType = 'dynamic';
        if (retType is InterfaceType && retType.typeArguments.isNotEmpty) {
          innerRetType = _restoreType(retType.typeArguments.first);
        }
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
          boxedParams: boxedParamsForMethod,
        );
        _popClosureContext();
      } else {
        // 非 async 路径：保持原有逻辑
        _buf.write('{\n');
        _indent++;
        final classTypeParamStr = cls.typeParameters.isNotEmpty
            ? '<${cls.typeParameters.map((tp) => tp.name ?? 'T').join(', ')}>'
            : '';
        _buf.write('${_pad}final this_ = this__ as ${className}Value$classTypeParamStr;\n');
        // Bug 11: 参数 Box 包装（仅基础值类型）
        for (final p in boxedParamsForMethod) {
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
          if ((body as ReturnStatement).expression != null) {
            _buf.write('$_pad${_restoreExpr((body as ReturnStatement).expression!)};\n');
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

    // Bug 11: 恢复快照
    _boxedVars.clear();
    _boxedVars.addAll(savedBoxedVars);
    _currentFunctionParams.clear();
    _currentFunctionParams.addAll(savedCurrentParams);
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

      final marker = proc.function.asyncMarker;
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

  // ---- Enum ----

  bool _isEnumClass(Class cls) {
    if (cls.supertype == null) return false;
    return cls.supertype!.classNode.name == '_Enum';
  }

  void _restoreEnum(Class cls) {
    final enumName = cls.name;
    _buf.write('enum $enumName');
    _writeTypeParams(cls.typeParameters);
    _buf.write(' {\n');
    _indent++;

    // 收集 enum 值字段（static const 且类型为自身类型，排除 values 列表）
    final enumValueFields = cls.fields.where((f) =>
        f.isStatic && f.isConst && f.type is InterfaceType &&
        (f.type as InterfaceType).classNode == cls &&
        f.name.text != 'values').toList();

    // 收集用户自定义字段（非 static、非 _Enum 内部字段）
    final enumInternalFields = {'index', '_name'};
    final userFields = cls.fields.where((f) =>
        !f.isStatic && !enumInternalFields.contains(f.name.text)).toList();

    // 从构造函数提取用户自定义参数名（排除 _Enum 内部参数 index/name）
    List<String> userParamNames = [];
    if (cls.constructors.isNotEmpty) {
      final ctor = cls.constructors.first;
      for (final p in ctor.function.positionalParameters) {
        final paramName = _cleanVarName(p.name ?? '');
        if (_isEnumInternalParam(paramName)) continue;
        userParamNames.add(paramName);
      }
      for (final p in ctor.function.namedParameters) {
        final paramName = _cleanVarName(p.name ?? '');
        if (_isEnumInternalParam(paramName)) continue;
        userParamNames.add(paramName);
      }
    }

    // 输出 enum 值
    for (var i = 0; i < enumValueFields.length; i++) {
      final field = enumValueFields[i];
      _buf.write('$_pad${field.name.text}');

      if (userParamNames.isNotEmpty && field.initializer != null) {
        final args = _extractEnumValueArgs(field.initializer!, userParamNames);
        if (args.isNotEmpty) {
          _buf.write('($args)');
        }
      }

      if (i < enumValueFields.length - 1) {
        _buf.write(',\n');
      } else {
        _buf.write(';\n');
      }
    }

    // 输出用户自定义字段
    if (userFields.isNotEmpty) {
      _buf.write('\n');
      for (final f in userFields) {
        _restoreField(f);
      }
    }

    // 输出构造函数（简化为用户参数）
    if (userParamNames.isNotEmpty) {
      _buf.write('\n');
      _buf.write('${_pad}const $enumName(');
      _buf.write(userParamNames.map((name) => 'this.$name').join(', '));
      _buf.write(');\n');
    }

    // enum 声明中不再输出方法体（方法提取为顶层静态函数）
    _indent--;
    _buf.write('}\n\n');

    // ---- 输出 enum 方法为顶层静态函数 ----
    final syntheticMethods = {'_enumToString'};
    final userMethods = cls.procedures.where((p) =>
        !syntheticMethods.contains(p.name.text) &&
        !p.isAbstract && p.function.body != null).toList();

    _currentClass = cls;
    for (final proc in userMethods) {
      _emitEnumMethodAsStatic(cls, proc, enumName);
    }
    _currentClass = null;
  }

  /// 将 enum 的实例方法提取为顶层静态函数
  /// enum 方法的 this_ 参数类型用 enum 类型名
  void _emitEnumMethodAsStatic(Class cls, Procedure proc, String enumName) {
    final methodName = proc.name.text;
    String funcName;
    if (proc.isGetter) {
      funcName = '${enumName}_get_$methodName';
    } else if (proc.isSetter) {
      funcName = '${enumName}_set_$methodName';
    } else {
      funcName = '${enumName}_$methodName';
    }

    _buf.write(_pad);
    _buf.write(_restoreType(proc.function.returnType));
    _buf.write(' $funcName(');

    // 第一个参数：this_ (enum 类型)
    _buf.write('$enumName this_');

    // 其余参数
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
        _writeParams(proc.function, proc: proc);
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
      _buf.write(' ');
      _insideMethodBody = true;
      _pushClosureContext('${enumName}_$methodName');
      final isVoidReturn = proc.function.returnType is VoidType || proc.isSetter;
      if (isVoidReturn) {
        _restoreSetterBody(proc.function.body!);
      } else {
        _restoreBody(proc.function.body!);
      }
      _popClosureContext();
      _insideMethodBody = false;
    } else {
      _buf.write(';\n');
    }
    _buf.write('\n');
  }

  bool _isEnumInternalParam(String name) {
    // _Enum 内部参数名（可能带 # 前缀，cleanVarName 后变为 index/name）
    return name == 'index' || name == 'name' ||
           name == '#index' || name == '#name';
  }

  /// 从 enum 值的 ConstructorInvocation 中提取用户自定义参数值
  String _extractEnumValueArgs(Expression expr, List<String> userParamNames) {
    // enum 值的初始化器是 ConstantExpression 包裹的 InstanceConstant
    if (expr is ConstantExpression && expr.constant is InstanceConstant) {
      final ic = expr.constant as InstanceConstant;
      final parts = <String>[];
      // 从 fieldValues 中提取用户自定义字段的值
      for (final entry in ic.fieldValues.entries) {
        final fieldName = entry.key.asField.name.text;
        if (userParamNames.contains(fieldName)) {
          parts.add(_restoreConstant(entry.value));
        }
      }
      return parts.join(', ');
    }
    return '';
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
      _buf.write(_restoreExpr(field.initializer!));
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
    // 直接输出为顶层静态函数，函数名清理为合法标识符
    final rawName = proc.name.text;
    if (_isExtensionMethodName(rawName)) {
      _restoreExtensionProcedure(proc);
      return;
    }

    // Bug 11: 预分析本函数，识别哪些参数/局部变量被内部闭包捕获，需要 Box 化
    // 记录 _boxedVars 的快照，退出时恢复（避免跨函数污染）
    final savedBoxedVars = Set<VariableDeclaration>.from(_boxedVars);
    final savedCurrentParams = Set<VariableDeclaration>.from(_currentFunctionParams);
    if (proc.function.body != null) {
      _preanalyzeBoxedVarsForFunc(proc.function);
      _currentFunctionParams.clear();
      _currentFunctionParams.addAll(proc.function.positionalParameters);
      _currentFunctionParams.addAll(proc.function.namedParameters);
    }
    // 识别本函数中被 Box 化的参数
    final boxedParamsForProc = <VariableDeclaration>[];
    for (final p in proc.function.positionalParameters) {
      if (_boxedVars.contains(p)) boxedParamsForProc.add(p);
    }
    for (final p in proc.function.namedParameters) {
      if (_boxedVars.contains(p)) boxedParamsForProc.add(p);
    }

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
      // 普通方法/函数
      if (proc.enclosingClass != null) {
        // 检查是否是 @override
        for (final ann in proc.annotations) {
          if (ann is ConstantExpression && ann.constant is InstanceConstant) {
            final ic = ann.constant as InstanceConstant;
            if (ic.classNode.name == 'override') {
              _buf.write('@override\n$_pad');
            }
          }
        }
      }
      _buf.write(_restoreType(proc.function.returnType));
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

    // async marker
    final marker = proc.function.asyncMarker;
    // async marker removed: replaced by state machine smAwait
    if (marker == AsyncMarker.AsyncStar) _buf.write(' async*');
    if (marker == AsyncMarker.SyncStar) _buf.write(' sync*');

    // body
    if (proc.function.body != null) {
      _buf.write(' ');
      final isVoidReturn = proc.function.returnType is VoidType || proc.isSetter;

      // async 函数 → ClosureEnv 闭包延迟执行模式
      if (marker == AsyncMarker.Async && !isVoidReturn) {
        final retType = proc.function.returnType;
        String innerRetType = 'dynamic';
        if (retType is InterfaceType && retType.typeArguments.isNotEmpty) {
          innerRetType = _restoreType(retType.typeArguments.first);
        }
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
          boxedParams: boxedParamsForProc,
        );
        _popClosureContext();
      } else {
        if (isVoidReturn) {
          _restoreSetterBody(proc.function.body!);
        } else {
          if (boxedParamsForProc.isNotEmpty) {
            _restoreBodyWithBoxedParams(proc.function.body!, boxedParamsForProc);
          } else {
            _restoreBody(proc.function.body!);
          }
        }
      }
    } else {
      _buf.write(';\n');
    }
    _buf.write('\n');

    // Bug 11: 恢复快照
    _boxedVars.clear();
    _boxedVars.addAll(savedBoxedVars);
    _currentFunctionParams.clear();
    _currentFunctionParams.addAll(savedCurrentParams);
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
    _buf.write(_restoreType(proc.function.returnType));
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
    if (marker == AsyncMarker.Async && !isVoidReturn) {
      final retType = proc.function.returnType;
      String innerRetType = 'dynamic';
      if (retType is InterfaceType && retType.typeArguments.isNotEmpty) {
        innerRetType = _restoreType(retType.typeArguments.first);
      }
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

  /// 返回类型参数名称字符串（不含 extends 约束），如 "<T>" 或 "<K, V>"
  String _typeParamNamesStr(List<TypeParameter> params) {
    if (params.isEmpty) return '';
    final names = params.map((tp) => tp.name ?? 'T').join(', ');
    return '<$names>';
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
      sb.write(_restoreType(p.type));
      sb.write(' ');
      final cleanName = _cleanVarName(p.name ?? '_p$i');
      // 写回清理后的名称
      p.name = cleanName;
      // Bug 11: 被 Box 化的参数，输出时参数名加 _raw 后缀（原名留给函数体内 Box 局部变量）
      final displayName = _boxedVars.contains(p) ? '${cleanName}_raw' : cleanName;
      sb.write(displayName);
      // flattenOptional 模式下不输出默认值（调用处补齐）
      if (!flattenOptional && i >= reqCount && p.initializer != null) {
        sb.write(' = ${_restoreExpr(p.initializer!)}');
      }
      parts.add(sb.toString());
    }

    if (!flattenOptional && openedBracket) {
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
      sb.write(_restoreType(p.type));
      sb.write(' ');
      final cleanName = _cleanVarName(p.name ?? '_n');
      p.name = cleanName;
      // Bug 11: 被 Box 化的 named 参数也加 _raw 后缀
      final displayName = _boxedVars.contains(p) ? '${cleanName}_raw' : cleanName;
      sb.write(displayName);
      if (p.initializer != null) {
        sb.write(' = ${_restoreExpr(p.initializer!)}');
      }
      return sb.toString();
    }).join(', ');
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
      _indent--;
      _buf.write('$_pad}\n');
    } else {
      _buf.write(' {\n');
      _indent++;
      _restoreStmt(body);
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
  }) {
    final closureId = _closureCounter++;
    final envClassName = 'ClosureEnv_${envBaseName}_$closureId';

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
    declBuf.write('class $envClassName {\n');
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
    declBuf.write('  void call() => $staticCallName(this);\n');
    declBuf.write('}\n');

    // ---- 生成静态 call 函数（包含原函数体）----
    declBuf.write('void $staticCallName($envClassName env)');

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
      _indent--;
      _buf.write('$_pad}\n');
    } else {
      _buf.write(' {\n');
      _indent++;
      _restoreStmt(body);
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

    _buf.write('${_pad}final env = $envClassName(${envCtorArgs.join(', ')});\n');
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
