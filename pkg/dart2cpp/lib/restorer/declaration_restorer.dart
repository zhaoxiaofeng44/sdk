part of 'dart_restorer.dart';

// ============================================================================
// Declaration Restorer: Handles type definitions, classes, fields, and methods
// ============================================================================

mixin _DeclarationRestorer on _DartRestorerBase, _TypeUtils, _ExpressionRestorer, _StatementRestorer {
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
    _buf.write('mixin ${cls.name}');
    _writeTypeParams(cls.typeParameters);

    // Kernel 中 mixin 的 on 约束：
    // - supertype 包含第一个 on 约束（如果不是 Object）
    // - implementedTypes 包含剩余的 on 约束
    final onTypes = <String>[];
    if (cls.supertype != null && cls.supertype!.classNode.name != 'Object') {
      onTypes.add(_restoreSupertype(cls.supertype!));
    }
    for (final impl in cls.implementedTypes) {
      onTypes.add(_restoreSupertype(impl));
    }
    if (onTypes.isNotEmpty) {
      _buf.write(' on ');
      _buf.write(onTypes.join(', '));
    }

    _buf.write(' {\n');
    _indent++;
    _restoreClassMembers(cls);
    _indent--;
    _buf.write('}\n\n');
  }

  // ---- Class ----

  void _restoreClass(Class cls) {
    // 检查是否是 Kernel 脱糖后的 enum（superclass 是 _Enum）
    if (_isEnumClass(cls)) {
      _restoreEnum(cls);
      return;
    }

    if (cls.isAbstract) _buf.write('abstract ');
    _buf.write('class ${cls.name}');
    _writeTypeParams(cls.typeParameters);

    if (cls.supertype != null) {
      final superName = cls.supertype!.classNode.name;
      if (superName.contains('&')) {
        // Kernel 脱糖：class Dog extends Animal with Printable, Orderable
        // → superclass = _Dog&Animal&Printable&Orderable (合成类)
        // 需要递归找到真正的 superclass 和 mixin 列表
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
    _buf.write('enum ${cls.name}');
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
        // 排除 _Enum 内部参数（index 和 name，可能带 # 前缀）
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

      // 提取构造函数参数值
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
      _buf.write('${_pad}const ${cls.name}(');
      _buf.write(userParamNames.map((name) => 'this.$name').join(', '));
      _buf.write(');\n');
    }

    // 输出用户自定义方法（排除 _enumToString、toString 如果是默认的）
    final syntheticMethods = {'_enumToString'};
    final userMethods = cls.procedures.where((p) =>
        !syntheticMethods.contains(p.name.text)).toList();
    if (userMethods.isNotEmpty) {
      _buf.write('\n');
      for (final p in userMethods) {
        _restoreProcedure(p);
      }
    }

    _indent--;
    _buf.write('}\n\n');
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
