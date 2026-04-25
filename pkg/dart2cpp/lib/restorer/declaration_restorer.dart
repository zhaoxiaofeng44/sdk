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
    _buf.write('(dynamic this_');
    
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
    if (marker == AsyncMarker.Async) _buf.write(' async');
    if (marker == AsyncMarker.AsyncStar) _buf.write(' async*');
    if (marker == AsyncMarker.SyncStar) _buf.write(' sync*');
    
    // body
    if (proc.function.body != null) {
      _buf.write(' ');
      _insideMethodBody = true;
      final isVoidReturn = proc.function.returnType is VoidType || proc.isSetter;
      if (isVoidReturn) {
        _restoreSetterBody(proc.function.body!);
      } else {
        _restoreBody(proc.function.body!);
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

    // 1. 生成 XValue 类（只存储实例数据）
    _emitValueClass(cls, className, parentName, isSyntheticMixinClass);

    // 2. 生成 XVTable 类（虚表）
    // 所有类都生成 VTable，用于继承链
    _emitVTableClass(cls, className);

    // 合成中间类不生成构造函数、静态字段和方法实现
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

    _buf.write('\n');
  }
  
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
    
    // 返回类型
    final returnType = _restoreType(proc.function.returnType);
    
    _buf.write(_pad);
    _buf.write('$returnType $funcName');
    // 类型参数声明：类的类型参数 + 方法自身的类型参数
    _writeCombinedTypeParams(cls.typeParameters, proc.function.typeParameters);
    // this_ 参数类型：直接使用 entry.declaringClassName（来自 _collectAllVTableEntries）
    final delegateDeclaringClass = entry.declaringClassName ?? className;
    final delegateThisParamType = _resolveThisParamType(className, delegateDeclaringClass, cls);
    _buf.write('($delegateThisParamType this_');
    
    // 构建参数列表和转发参数
    final forwardArgs = <String>['this_'];
    
    if (entry.kind == 'setter') {
      if (proc.function.positionalParameters.isNotEmpty) {
        final p = proc.function.positionalParameters.first;
        final paramName = _cleanVarName(p.name ?? 'value');
        _buf.write(', ${_restoreType(p.type)} $paramName');
        forwardArgs.add(paramName);
      }
    } else if (entry.kind != 'getter') {
      // method / operator
      for (final p in proc.function.positionalParameters) {
        final paramName = _cleanVarName(p.name ?? '_p');
        _buf.write(', ${_restoreType(p.type)} $paramName');
        forwardArgs.add(paramName);
      }
      for (final p in proc.function.namedParameters) {
        final paramName = _cleanVarName(p.name ?? '_n');
        _buf.write(', {${_restoreType(p.type)} $paramName}');
      }
    }
    
    _buf.write(') {\n');
    _indent++;
    
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
      _buf.write('$originFuncName(${forwardArgs.join(', ')}');
      
      // 命名参数转发
      if (entry.kind != 'getter' && entry.kind != 'setter') {
        for (final p in proc.function.namedParameters) {
          final paramName = _cleanVarName(p.name ?? '_n');
          _buf.write(', ${p.name}: $paramName');
        }
      }
      
      _buf.write(');\n');
    }
    
    _indent--;
    _buf.write('}\n\n');
  }

  /// 生成 XValue 类
  void _emitValueClass(Class cls, String className, String? parentName, [bool isSyntheticMixinClass = false]) {
    _buf.write('class ${className}Value');
    _writeTypeParams(cls.typeParameters);

    // 确定继承关系：
    // - 有用户类基类 → extends ${parentName}Value
    // - 无基类（根类）→ extends VPtr（VPtr 提供 vptr 字段和 toString/operator==/hashCode 桥接）
    final hasUserParent = parentName != null && _isUserClass(parentName);
    if (hasUserParent) {
      _buf.write(' extends ${parentName}Value');
    } else {
      _buf.write(' extends VPtr');
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
    
    for (final field in fieldsToEmit) {
      if (field.isStatic) continue;
      _buf.write('$_pad');
      // 所有字段都标记为 late，因为它们在构造函数外赋值
      _buf.write('late ');
      _buf.write(_restoreType(field.type));
      _buf.write(' ${field.name.text}');
      _buf.write(';\n');
    }

    // vptr 字段和 toString/operator==/hashCode 覆写由 VPtr 基类统一提供
    // 不再在每个 Value 类中重复生成

    _indent--;
    _buf.write('}\n\n');
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

  /// 生成 XVTable 类 → 已废弃，vptr 改为 Map<String, dynamic>，不再需要独立的 VTable 类
  void _emitVTableClass(Class cls, String className) {
    // 不再生成 VTable 类，vptr 已改为 Map<String, dynamic>
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

  /// 根据 declaringClassName 解析 this_ 参数的类型字符串
  /// - className 本身是 mixin → dynamic（mixin 自身的静态函数）
  /// - extends 链上的非合成父类 → declaringClassName + Value
  /// - 其他情况（mixin/合成中间类/接口声明的方法）→ 当前类名 + Value
  String _resolveThisParamType(String className, String declaringClass, Class cls) {
    // className 本身是 mixin → mixin 自身的静态函数用 dynamic
    if (_isMixinName(className)) {
      return 'dynamic';
    }
    // declaringClass 在 extends 链上且不是合成中间类 → 用 declaringClassName + Value
    if (declaringClass != className
        && !_isMixinName(declaringClass)
        && !_syntheticLoweredNames.contains(declaringClass)
        && _isInExtendsChain(className, declaringClass)) {
      final declaringCls = _classNodes[declaringClass];
      final buf = StringBuffer('${declaringClass}Value');
      if (declaringCls != null && declaringCls.typeParameters.isNotEmpty) {
        buf.write('<');
        buf.write(declaringCls.typeParameters.map((tp) => tp.name ?? 'T').join(', '));
        buf.write('>');
      }
      return buf.toString();
    }
    // 其他情况（declaringClass == className / mixin / 合成中间类 / 接口）→ 用当前类名 + Value
    final buf = StringBuffer('${className}Value');
    if (cls.typeParameters.isNotEmpty) {
      buf.write('<');
      buf.write(cls.typeParameters.map((tp) => tp.name ?? 'T').join(', '));
      buf.write('>');
    }
    return buf.toString();
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

  /// 更新 VTable 条目签名，将 this 参数类型替换为当前类的实际类型
  String _updateVTableSignature(String signature, String className) {
    // 签名格式如: String Function(Dog_Animal_PrintableValue this_)
    // 或: void Function(Dog_Animal_PrintableValue this_, String value)
    // 将第一个参数类型替换为当前类的实际类型
    final pattern = RegExp(r'(\w+\??)\s+Function\((\w+Value)\s+this_');
    final match = pattern.firstMatch(signature);
    if (match != null) {
      final returnType = match.group(1);
      return '$returnType Function(${className}Value this_${signature.substring(match.end)}';
    }
    return signature;
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

    // 返回类型为 void，第一个参数为 this_
    _buf.write('void $funcName');
    // 构造函数也需要类型参数（如 Pair_new<A, B>），声明位置用完整约束
    _writeTypeParams(cls.typeParameters);
    _buf.write('(${className}Value');
    // 参数类型位置只写名称，不写 extends 约束
    _writeTypeParamNames(cls.typeParameters);
    _buf.write(' this_');

    // 其余参数列表（排除 this. 语义，直接作为普通参数）
    final hasParams = _hasParams(ctor.function);
    if (hasParams) {
      _buf.write(', ');
      _writeParams(ctor.function);
    }
    _buf.write(') {\n');
    _indent++;

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

    // vptr 设置 - 在父类构造之后设置
    // 只有当父类是非合成的用户自定义类时，才用 ...this_.vptr 展开父类的 vptr
    // 根类（直接继承 VPtr/Object 的类）或父类是合成 mixin 中间类时不展开，
    // 因为这些类没有构造函数来初始化 vptr
    final hasUserParent = parentName != null && _isUserClass(parentName) &&
        !_isSyntheticMixinClassName(parentName) && !_isSyntheticLoweredName(parentName);
    final hasClassTypeParams = cls.typeParameters.isNotEmpty;
    final typeParamNames = cls.typeParameters.map((tp) => tp.name ?? 'T').toList();
    final typeParamStr = hasClassTypeParams ? '<${typeParamNames.join(', ')}>' : '';

    _buf.write('${_pad}this_.vptr = {\n');
    _indent++;

    // 展开父类 vptr（仅当父类是用户自定义类，即父类构造函数已初始化 vptr）
    if (hasUserParent) {
      _buf.write('${_pad}...this_.vptr,\n');
    }

    if (entries.isNotEmpty) {
      for (final entry in entries) {
        String fieldName;
        if (entry.kind == 'getter') {
          fieldName = 'get_${entry.name}';
        } else if (entry.kind == 'setter') {
          fieldName = 'set_${entry.name}';
        } else if (entry.kind == 'operator') {
          fieldName = 'operator${_operatorFuncName(entry.name)}';
        } else {
          fieldName = _vtableFieldName(entry.name);
        }

        final wrapperStr = _buildVptrLambdaWrapper(cls, entry, className, typeParamStr);
        _buf.write("$_pad'$fieldName': $wrapperStr,\n");
      }
    }
    _indent--;
    _buf.write('${_pad}};\n');

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

    _indent--;
    _buf.write('}\n\n');
  }

  /// 判断构造函数是否有参数（排除 this. 参数）
  bool _hasParams(FunctionNode func) {
    return func.positionalParameters.isNotEmpty || func.namedParameters.isNotEmpty;
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
    final superArgs = _restoreArgs(init.arguments);
    _buf.write('${_pad}$parentFuncName(this_');
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
    for (final field in allFields) {
      if (field.isStatic) continue;
      if (field.isLate) continue; // late 字段不需要默认值
      if (initedFields.contains(field.name.text)) continue;
      if (field.initializer != null) {
        _buf.write('${_pad}this_.${field.name.text} = ');
        _buf.write(_restoreExpr(field.initializer!));
        _buf.write(';\n');
      }
    }
  }

  /// 为 vptr 条目生成注册值
  /// 默认参数在调用处补齐，所以注册时按全部参数注册，直接使用静态函数引用。
  /// 仅在以下场景使用 lambda wrapper：
  /// - 泛型类：需要绑定类型参数，如 Pair_swap<A, B>
  /// - 命名参数：lambda 无法声明命名参数语法
  /// - 方法级类型参数：需要特殊处理
  String _buildVptrLambdaWrapper(Class cls, _VTableEntry entry, String className, String typeParamStr) {
    final proc = entry.proc;
    if (proc == null) {
      return entry.staticFuncName;
    }

    final hasClassTypeParams = typeParamStr.isNotEmpty;
    final hasMethodTypeParams = proc.function.typeParameters.isNotEmpty;
    final hasNamedParams = proc.function.namedParameters.isNotEmpty;

    // 当 declaringClassName 在 extends 继承链上时，所有静态函数的 this_ 参数类型一致，
    // 可以直接使用静态函数引用。接口 implements 的情况下 this_ 类型是当前类，也一致。
    // 因此非泛型、非命名参数时可以直接使用静态函数引用。

    // 场景 0: 无泛型、无命名参数 → 直接使用静态函数引用
    if (!hasClassTypeParams && !hasMethodTypeParams && !hasNamedParams) {
      return entry.staticFuncName;
    }

    // 场景 1: 有命名参数 → 生成带命名参数的内联函数
    if (hasNamedParams) {
      final effectiveTypeParamStr = hasMethodTypeParams ? '' : typeParamStr;
      final methodTypeParamNames = proc.function.typeParameters.map((tp) => tp.name ?? 'T').toSet();
      final wrapperParams = <String>['self'];
      for (var i = 0; i < proc.function.positionalParameters.length; i++) {
        wrapperParams.add('_a$i');
      }
      final namedParts = <String>[];
      for (final p in proc.function.namedParameters) {
        final cleanName = _cleanVarName(p.name ?? '_n');
        var paramType = _restoreType(p.type);
        for (final tpName in methodTypeParamNames) {
          paramType = _replaceTypeParam(paramType, tpName, 'dynamic');
        }
        if (p.isRequired) {
          namedParts.add('required $paramType $cleanName');
        } else {
          var part = '$paramType $cleanName';
          if (p.initializer != null) {
            part += ' = ${_restoreExpr(p.initializer!)}';
          }
          namedParts.add(part);
        }
      }
      final posParamStr = wrapperParams.join(', ');
      final namedParamStr = namedParts.join(', ');
      final fullParamStr = '$posParamStr, {$namedParamStr}';
      final forwardParts = <String>['self'];
      for (var i = 0; i < proc.function.positionalParameters.length; i++) {
        forwardParts.add('_a$i');
      }
      for (final p in proc.function.namedParameters) {
        final cleanName = _cleanVarName(p.name ?? '_n');
        forwardParts.add('${p.name}: $cleanName');
      }
      return '($fullParamStr) => ${entry.staticFuncName}$effectiveTypeParamStr(${forwardParts.join(', ')})';
    }

    // 场景 2/3: 泛型类或方法级类型参数 → lambda wrapper（需要绑定类型参数）
    final lambdaParams = <String>['self'];
    if (entry.kind == 'setter') {
      if (proc.function.positionalParameters.isNotEmpty) {
        lambdaParams.add('val');
      }
    } else if (entry.kind != 'getter') {
      for (var i = 0; i < proc.function.positionalParameters.length; i++) {
        lambdaParams.add('_a$i');
      }
    }

    final lambdaParamStr = lambdaParams.join(', ');
    final effectiveTypeParamStr = hasMethodTypeParams ? '' : typeParamStr;

    final forwardParts = <String>['self'];
    if (entry.kind == 'setter') {
      if (proc.function.positionalParameters.isNotEmpty) {
        forwardParts.add('val');
      }
    } else if (entry.kind != 'getter') {
      for (var i = 0; i < proc.function.positionalParameters.length; i++) {
        forwardParts.add('_a$i');
      }
    }

    return '($lambdaParamStr) => ${entry.staticFuncName}$effectiveTypeParamStr(${forwardParts.join(', ')})';
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

    // 第一个参数：this_ 类型使用 declaringClassName 解析
    // mixin/合成中间类 → dynamic，extends 链上的父类 → 父类Value，其他 → 当前类Value
    final kind = proc.isGetter ? 'getter' : (proc.isSetter ? 'setter' : 'method');
    final declaringClass = _findDeclaringClassName(className, methodName, kind);
    final thisParamType = _resolveThisParamType(className, declaringClass, cls);
    final needsCast = thisParamType != '${className}Value' && !thisParamType.startsWith('${className}Value<');
    _buf.write('$thisParamType');
    // 参数名：需要 cast 时用 this__，否则直接用 this_
    _buf.write(needsCast ? ' this__' : ' this_');

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
    if (marker == AsyncMarker.Async) _buf.write(' async');
    if (marker == AsyncMarker.AsyncStar) _buf.write(' async*');
    if (marker == AsyncMarker.SyncStar) _buf.write(' sync*');

    // body
    if (proc.function.body != null) {
      _buf.write(' ');
      _insideMethodBody = true;
      if (needsCast) {
        // declaringClass != className：参数是 this__，方法体开头 cast 为当前类类型
        _buf.write('{\n');
        _indent++;
        final classTypeParamStr = cls.typeParameters.isNotEmpty
            ? '<${cls.typeParameters.map((tp) => tp.name ?? 'T').join(', ')}>'
            : '';
        _buf.write('${_pad}final this_ = this__ as ${className}Value$classTypeParamStr;\n');
        final body = proc.function.body!;
        if (body is Block) {
          for (final s in body.statements) {
            if ((proc.function.returnType is VoidType || proc.isSetter) && s is ReturnStatement) {
              if (s.expression != null) {
                _buf.write('$_pad${_restoreExpr(s.expression!)};\n');
              }
              continue;
            }
            _restoreStmt(s);
          }
        } else {
          _restoreStmt(body);
        }
        _indent--;
        _buf.write('$_pad}\n');
      } else {
        final isVoidReturn = proc.function.returnType is VoidType || proc.isSetter;
        if (isVoidReturn) {
          _restoreSetterBody(proc.function.body!);
        } else {
          _restoreBody(proc.function.body!);
        }
      }
      _insideMethodBody = false;
    } else {
      _buf.write(';\n');
    }
    _buf.write('\n');
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
    // 抽象方法的 this_ 参数类型也用 _resolveThisParamType，保持和子类重载一致
    final absKind = proc.isGetter ? 'getter' : (proc.isSetter ? 'setter' : 'method');
    final absDeclaringClass = _findDeclaringClassName(className, methodName, absKind);
    final absThisParamType = _resolveThisParamType(className, absDeclaringClass, cls);
    _buf.write('($absThisParamType this_');

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
      if (marker == AsyncMarker.Async) _buf.write(' async');

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
      _buf.write(' ${className}_${proc.name.text}(');
      _writeParams(proc.function, proc: proc);
      _buf.write(')');

      final marker = proc.function.asyncMarker;
      if (marker == AsyncMarker.Async) _buf.write(' async');
      if (marker == AsyncMarker.AsyncStar) _buf.write(' async*');
      if (marker == AsyncMarker.SyncStar) _buf.write(' sync*');

      if (proc.function.body != null) {
        _buf.write(' ');
        _restoreBody(proc.function.body!);
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
    if (marker == AsyncMarker.Async) _buf.write(' async');
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

  void _restoreField(Field field) {
    _buf.write(_pad);
    if (field.isStatic) _buf.write('static ');
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
    if (marker == AsyncMarker.Async) _buf.write(' async');
    if (marker == AsyncMarker.AsyncStar) _buf.write(' async*');
    if (marker == AsyncMarker.SyncStar) _buf.write(' sync*');

    // body
    if (proc.function.body != null) {
      _buf.write(' ');
      final isVoidReturn = proc.function.returnType is VoidType || proc.isSetter;
      if (isVoidReturn) {
        _restoreSetterBody(proc.function.body!);
      } else {
        _restoreBody(proc.function.body!);
      }
    } else {
      _buf.write(';\n');
    }
    _buf.write('\n');
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
    if (marker == AsyncMarker.Async) _buf.write(' async');
    if (marker == AsyncMarker.AsyncStar) _buf.write(' async*');
    if (marker == AsyncMarker.SyncStar) _buf.write(' sync*');

    _buf.write(' ');
    _insideMethodBody = true;
    // 推入闭包上下文，确保函数体内生成的闭包以当前扩展方法名命名
    _pushClosureContext(cleanedFuncName);
    final isVoidReturn = proc.function.returnType is VoidType || proc.isSetter;
    if (isVoidReturn) {
      _restoreSetterBody(proc.function.body!);
    } else {
      _restoreBody(proc.function.body!);
    }
    _popClosureContext();
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
    final allParams = [...classParams, ...methodParams];
    if (allParams.isEmpty) return;
    _writeTypeParams(allParams);
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
      sb.write(cleanName);
      // 写回清理后的名称
      p.name = cleanName;
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
      sb.write(_cleanVarName(p.name ?? '_n'));
      p.name = _cleanVarName(p.name ?? '_n');
      if (p.initializer != null) {
        sb.write(' = ${_restoreExpr(p.initializer!)}');
      }
      return sb.toString();
    }).join(', ');
  }
}
