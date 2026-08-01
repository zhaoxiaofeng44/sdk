part of 'dart_restorer.dart';

// ============================================================================
// Enum Restorer: Handles enum class detection and restoration
// ============================================================================

mixin _EnumRestorer on _DartRestorerBase, _TypeUtils, _ExpressionRestorer, _StatementRestorer, _DeclarationRestorer {
  // ---- Enum ----

  /// Override _restoreClass to intercept enum classes before standard class lowering.
  @override
  void _restoreClass(Class cls) {
    if (_isEnumClass(cls)) {
      _restoreEnum(cls);
      return;
    }
    super._restoreClass(cls);
  }

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
        _writeParams(proc.function);
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
}
