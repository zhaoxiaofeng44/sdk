part of 'dart_restorer.dart';

// ============================================================================
// Declaration Restorer: Handles type definitions, classes, fields, and methods
// ============================================================================

mixin _DeclarationRestorer on _DartRestorerBase, _TypeUtils, _ExpressionRestorer, _StatementRestorer {
  // ---- VTable 字段名工具方法 ----

  /// 将方法名转换为 VTable 字段名
  /// 特殊处理：避免与 Object 内置方法冲突（如 toString、hashCode、noSuchMethod）
  String _vtableFieldName(String methodName) {
    const conflictingNames = {'toString', 'hashCode', 'noSuchMethod', 'runtimeType'};
    if (conflictingNames.contains(methodName)) {
      return '${methodName}_';
    }
    return methodName;
  }

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
    // Mixin 声明不再输出（mixin 的方法通过合成中间类 lowering）
    // 只保留注释标记，方便调试
    _buf.write('// mixin ${cls.name} → lowered via synthetic intermediate classes\n\n');
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
  void _emitDelegateMethodAsStatic(Class cls, _VTableEntry entry, String className) {
    final methodName = entry.name;
    String funcName;
    if (entry.kind == 'getter') {
      funcName = _staticGetterName(className, methodName);
    } else if (entry.kind == 'setter') {
      funcName = _staticSetterName(className, methodName);
    } else {
      funcName = _staticMethodName(className, methodName);
    }
    
    // 使用更新后的签名（this 参数类型为 dynamic）
    final updatedSignature = _updateVTableSignature(entry.signature, className);
    
    // 解析返回类型和参数
    final sigMatch = RegExp(r'(\w+\??)\s+Function\((.*)\)').firstMatch(updatedSignature);
    if (sigMatch == null) return;
    
    final returnType = sigMatch.group(1);
    final paramsStr = sigMatch.group(2);
    
    // 解析参数列表，提取参数名和类型
    final params = <String>[];
    final paramTypes = <String>[];
    if (paramsStr != null && paramsStr.trim().isNotEmpty) {
      // 分割参数，处理 dynamic this_, DogValue other 这样的格式
      final paramParts = paramsStr.split(',');
      for (final part in paramParts) {
        final trimmed = part.trim();
        if (trimmed.isEmpty) continue;
        
        // 匹配 type name 格式
        final paramMatch = RegExp(r'(\S+)\s+(\w+)').firstMatch(trimmed);
        if (paramMatch != null) {
          paramTypes.add(paramMatch.group(1)!);
          params.add(paramMatch.group(2)!);
        }
      }
    }
    
    // 生成函数签名
    _buf.write(_pad);
    _buf.write('$returnType $funcName(');
    for (int i = 0; i < params.length; i++) {
      if (i > 0) _buf.write(', ');
      _buf.write('${paramTypes[i]} ${params[i]}');
    }
    _buf.write(') {\n');
    _indent++;
    
    // 生成委托调用 - 通过 VTable 调用
    // 假设第一个参数是 this_
    if (params.isNotEmpty) {
      final thisParam = params[0];
      final otherParams = params.skip(1).toList();
      
      if (entry.kind == 'getter') {
        // getter: return this_.vptr.get_methodName(this_);
        _buf.write('${_pad}return $thisParam.vptr.get_$methodName($thisParam');
        for (final p in otherParams) {
          _buf.write(', $p');
        }
        _buf.write(');\n');
      } else if (entry.kind == 'setter') {
        // setter: this_.vptr.set_methodName(this_, value);
        _buf.write('${_pad}$thisParam.vptr.set_$methodName($thisParam');
        for (final p in otherParams) {
          _buf.write(', $p');
        }
        _buf.write(');\n');
      } else {
        // 普通方法: return this_.vptr.vtableFieldName(this_, ...);
        // 注意：使用 _vtableFieldName 避免与 Object 内置方法冲突
        final vtableField = _vtableFieldName(methodName);
        if (returnType != 'void') {
          _buf.write('${_pad}return ');
        }
        _buf.write('$thisParam.vptr.$vtableField($thisParam');
        for (final p in otherParams) {
          _buf.write(', $p');
        }
        _buf.write(');\n');
      }
    }
    
    _indent--;
    _buf.write('}\n\n');
  }

  /// 生成 XValue 类
  void _emitValueClass(Class cls, String className, String? parentName, [bool isSyntheticMixinClass = false]) {
    _buf.write('class ${className}Value');
    _writeTypeParams(cls.typeParameters);
    // 恢复 Value 类继承关系，确保子类可以赋值给父类类型
    if (parentName != null && _isUserClass(parentName)) {
      _buf.write(' extends ${parentName}Value');
    }
    _buf.write(' {\n');
    _indent++;

    // vptr 字段：使用 dynamic 类型，避免子类 VTable 类型与父类 vptr 字段类型冲突
    _buf.write('${_pad}late dynamic vptr;\n');

    // 实例字段（排除静态字段）- 收集当前类及所有父类的字段
    final allFields = <Field>[];
    _collectAllFields(cls, allFields, <String>{});
    
    for (final field in allFields) {
      if (field.isStatic) continue;
      _buf.write('$_pad');
      // 所有字段都标记为 late，因为它们在构造函数外赋值
      _buf.write('late ');
      _buf.write(_restoreType(field.type));
      _buf.write(' ${field.name.text}');
      _buf.write(';\n');
    }

    _indent--;
    _buf.write('}\n\n');
  }
  
  /// 收集当前类及所有父类的字段
  void _collectAllFields(Class cls, List<Field> allFields, Set<String> seenNames) {
    // 先收集父类的字段
    if (cls.supertype != null) {
      final superClass = cls.supertype!.classNode;
      if (_isUserClass(superClass.name) || _isSyntheticMixinClassName(superClass.name)) {
        _collectAllFields(superClass, allFields, seenNames);
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

  /// 生成 XVTable 类
  void _emitVTableClass(Class cls, String className) {
    // 使用 _collectAllVTableEntries 收集所有 VTable 条目（包括从父类和 mixin 继承的）
    final entries = _collectAllVTableEntries(className);
    if (entries.isEmpty) {
      _buf.write('class ${className}VTable');
      _writeTypeParams(cls.typeParameters);
      _buf.write(' {}\n\n');
      return;
    }

    _buf.write('class ${className}VTable');
    _writeTypeParams(cls.typeParameters);
    // 移除 VTable 继承关系，每个 VTable 都是独立的
    _buf.write(' {\n');
    _indent++;

    for (final entry in entries) {
      // 虚表字段名：方法名直接作为字段名，getter/setter 加前缀
      String fieldName;
      if (entry.kind == 'getter') {
        fieldName = 'get_${entry.name}';
      } else if (entry.kind == 'setter') {
        fieldName = 'set_${entry.name}';
      } else if (entry.kind == 'operator') {
        fieldName = 'operator${_operatorFuncName(entry.name)}';
      } else {
        // 避免与 Object.toString() 冲突：将 toString 重命名为 toString_
        fieldName = _vtableFieldName(entry.name);
      }
      // 将所有 VTable 条目的 this 参数类型替换为当前类的类型
      final updatedSignature = _updateVTableSignature(entry.signature, className);
      _buf.write('${_pad}late $updatedSignature $fieldName;\n');
    }

    _indent--;
    _buf.write('}\n\n');
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
            // 将 staticFuncName 替换为当前类的静态函数名
            final updatedEntry = _VTableEntry(
              name: entry.name,
              kind: entry.kind,
              staticFuncName: _getStaticFuncName(className, entry.name, entry.kind),
              signature: entry.signature,
            );
            entries.add(updatedEntry);
          }
        }
      }
      currentClass = _getParentClassName(currentClass);
    }
    
    return entries;
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

  /// 更新 VTable 条目签名，将 this 参数类型替换为 dynamic 以避免类型协变问题
  String _updateVTableSignature(String signature, String className) {
    // 签名格式如: String Function(Dog_Animal_PrintableValue this_)
    // 或: void Function(Dog_Animal_PrintableValue this_, String value)
    // 将第一个参数类型替换为 dynamic
    final pattern = RegExp(r'(\w+\??)\s+Function\((\w+Value)\s+this_');
    final match = pattern.firstMatch(signature);
    if (match != null) {
      final returnType = match.group(1);
      return '$returnType Function(dynamic this_${signature.substring(match.end)}';
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
  void _emitConstructorFunction(Class cls, Constructor ctor, String className, String? parentName) {
    final ctorName = ctor.name.text;
    final funcName = ctorName.isEmpty ? '${className}_new' : '${className}_new_$ctorName';
    
    // 获取所有 VTable 条目（包括从父类和 mixin 继承的）
    final entries = _collectAllVTableEntries(className);

    // 返回类型（包含类型参数）
    _buf.write('${className}Value');
    _writeTypeParams(cls.typeParameters);
    _buf.write(' $funcName');
    // 构造函数也需要类型参数（如 Pair_new<A, B>）
    _writeTypeParams(cls.typeParameters);
    _buf.write('(');

    // 参数列表（排除 this. 语义，直接作为普通参数）
    _writeParams(ctor.function);
    _buf.write(') {\n');
    _indent++;

    // 对象分配
    _buf.write('${_pad}final obj = ${className}Value();\n');

    // vptr 设置 - 初始化所有 VTable 字段
    _buf.write('${_pad}obj.vptr = ${className}VTable()');
    if (entries.isNotEmpty) {
      _buf.write('\n');
      _indent++;
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
        _buf.write('$_pad..$fieldName = ${entry.staticFuncName}\n');
      }
      _indent--;
    }
    _buf.write('${_pad};\n');

    // 检查是否是 redirecting constructor
    final hasRedirecting = ctor.initializers.any((init) => init is RedirectingInitializer);
    if (hasRedirecting) {
      // Redirecting constructor: 展开为调用目标构造函数
      for (final init in ctor.initializers) {
        if (init is RedirectingInitializer) {
          final redirCtorName = init.target.name.text;
          final targetFuncName = redirCtorName.isEmpty
              ? '${className}_new'
              : '${className}_new_$redirCtorName';
          _buf.write('${_pad}final obj = $targetFuncName(');
          _buf.write(_restoreArgs(init.arguments));
          _buf.write(');\n');
        }
      }
      _buf.write('${_pad}return obj;\n');
      _indent--;
      _buf.write('}\n\n');
      return;
    }

    // 父类初始化（展开 super(...)）
    for (final init in ctor.initializers) {
      if (init is SuperInitializer) {
        _emitSuperInit(init, parentName, className);
      }
    }

    // 字段初始化（展开初始化列表）
    for (final init in ctor.initializers) {
      if (init is FieldInitializer) {
        _buf.write('${_pad}obj.${init.field.name.text} = ');
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

    // 处理 this.field 参数 → obj.field = param
    _emitThisFieldAssignments(ctor, cls);

    // 构造函数体（this → obj）
    if (ctor.function.body != null && ctor.function.body is! EmptyStatement) {
      _insideMethodBody = true;
      _thisReplacementName = 'obj';
      final ctorContextName = ctorName.isEmpty ? '${className}_new' : '${className}_new_$ctorName';
      _pushClosureContext(ctorContextName);
      _emitBodyWithThisReplacement(ctor.function.body!, 'obj');
      _popClosureContext();
      _thisReplacementName = 'this_';
      _insideMethodBody = false;
    }

    _buf.write('${_pad}return obj;\n');
    _indent--;
    _buf.write('}\n\n');
  }

  /// 展开 super(...) 初始化
  void _emitSuperInit(SuperInitializer init, String? parentName, String className) {
    if (parentName == null || !_isUserClass(parentName)) return;
    // 展开父类构造函数的字段初始化（不调用父类 X_new，直接内联初始化逻辑）
    final parentCls = _classNodes[parentName];
    if (parentCls != null) {
      final parentCtor = _findMatchingConstructor(parentCls, init.target.name.text);
      if (parentCtor != null) {
        _emitParentFieldInits(parentCtor, init.arguments, parentName);
      }
    }
  }

  /// 查找匹配的构造函数
  Constructor? _findMatchingConstructor(Class cls, String ctorName) {
    for (final ctor in cls.constructors) {
      if (ctor.name.text == ctorName) return ctor;
    }
    return null;
  }

  /// 展开父类构造函数的字段初始化
  void _emitParentFieldInits(Constructor parentCtor, Arguments args, String parentName) {
    // 将参数映射到字段
    for (final init in parentCtor.initializers) {
      if (init is FieldInitializer) {
        // 检查初始化值是否引用了构造函数参数
        final value = init.value;
        if (value is VariableGet) {
          // 找到对应的参数在 args 中的位置
          final paramIdx = parentCtor.function.positionalParameters.indexOf(value.variable);
          if (paramIdx >= 0 && paramIdx < args.positional.length) {
            _buf.write('${_pad}obj.${init.field.name.text} = ');
            _buf.write(_restoreExpr(args.positional[paramIdx]));
            _buf.write(';\n');
          } else {
            // 检查命名参数
            final namedIdx = parentCtor.function.namedParameters.indexOf(value.variable);
            if (namedIdx >= 0) {
              final paramName = parentCtor.function.namedParameters[namedIdx].name;
              for (final namedArg in args.named) {
                if (namedArg.name == paramName) {
                  _buf.write('${_pad}obj.${init.field.name.text} = ');
                  _buf.write(_restoreExpr(namedArg.value));
                  _buf.write(';\n');
                  break;
                }
              }
            }
          }
        } else {
          _buf.write('${_pad}obj.${init.field.name.text} = ');
          _buf.write(_restoreExpr(init.value));
          _buf.write(';\n');
        }
      } else if (init is SuperInitializer) {
        // 递归展开更上层的 super
        final grandParentName = _getParentClassName(parentName);
        _emitSuperInit(init, grandParentName, parentName);
      }
    }

    // 处理父类构造函数中的 this.field 参数
    final parentCls = _classNodes[parentName];
    if (parentCls != null) {
      _emitThisFieldAssignmentsFromArgs(parentCtor, parentCls, args);
    }
  }

  /// 处理 this.field 参数赋值（从外部 Arguments 映射）
  void _emitThisFieldAssignmentsFromArgs(Constructor ctor, Class cls, Arguments args) {
    final fieldNames = cls.fields.where((f) => !f.isStatic).map((f) => f.name.text).toSet();
    // 位置参数
    for (var i = 0; i < ctor.function.positionalParameters.length; i++) {
      final param = ctor.function.positionalParameters[i];
      final paramName = param.name ?? '';
      if (fieldNames.contains(paramName)) {
        // 检查是否已经在初始化列表中处理过
        final alreadyInited = ctor.initializers.any((init) =>
            init is FieldInitializer && init.field.name.text == paramName);
        if (!alreadyInited && i < args.positional.length) {
          _buf.write('${_pad}obj.$paramName = ');
          _buf.write(_restoreExpr(args.positional[i]));
          _buf.write(';\n');
        }
      }
    }
    // 命名参数
    for (final param in ctor.function.namedParameters) {
      final paramName = param.name ?? '';
      if (fieldNames.contains(paramName)) {
        final alreadyInited = ctor.initializers.any((init) =>
            init is FieldInitializer && init.field.name.text == paramName);
        if (!alreadyInited) {
          for (final namedArg in args.named) {
            if (namedArg.name == paramName) {
              _buf.write('${_pad}obj.$paramName = ');
              _buf.write(_restoreExpr(namedArg.value));
              _buf.write(';\n');
              break;
            }
          }
        }
      }
    }
  }

  /// 处理 this.field 参数 → obj.field = param
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
          _buf.write('${_pad}obj.$paramName = $paramName;\n');
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
          _buf.write('${_pad}obj.$paramName = $paramName;\n');
        }
      }
    }
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
    // 实例方法也需要类型参数（来自类的类型参数）
    _writeTypeParams(cls.typeParameters);
    _buf.write('(');

    // 第一个参数：this_ (使用 dynamic 避免类型协变问题)
    _buf.write('dynamic this_');

    // 其余参数
    if (proc.isSetter) {
      if (proc.function.positionalParameters.isNotEmpty) {
        final p = proc.function.positionalParameters.first;
        final cleanName = _cleanVarName(p.name ?? 'value');
        p.name = cleanName;
        _buf.write(', ${_restoreType(p.type)} $cleanName');
      }
    } else if (!proc.isGetter) {
      // 普通方法的参数
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
    _buf.write(' $funcName(dynamic this_');

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
    final isVoidReturn = proc.function.returnType is VoidType || proc.isSetter;
    if (isVoidReturn) {
      _restoreSetterBody(proc.function.body!);
    } else {
      _restoreBody(proc.function.body!);
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

  void _writeParams(FunctionNode func, {Procedure? proc}) {
    final pos = func.positionalParameters;
    final named = func.namedParameters;
    final reqCount = func.requiredParameterCount;
    final parts = <String>[];
    var openedBracket = false;

    for (var i = 0; i < pos.length; i++) {
      final p = pos[i];
      if (i == reqCount && !openedBracket) {
        openedBracket = true;
        // 开始可选位置参数
      }
      final sb = StringBuffer();
      // covariant 必须在 final 前面
      if (_needsCovariant(p, func, proc)) sb.write('covariant ');
      if (p.isFinal) sb.write('final ');
      sb.write(_restoreType(p.type));
      sb.write(' ');
      final cleanName = _cleanVarName(p.name ?? '_p$i');
      sb.write(cleanName);
      // 写回清理后的名称
      p.name = cleanName;
      if (i >= reqCount && p.initializer != null) {
        sb.write(' = ${_restoreExpr(p.initializer!)}');
      }
      parts.add(sb.toString());
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
