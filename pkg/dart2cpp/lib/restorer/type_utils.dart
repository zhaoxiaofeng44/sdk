part of 'dart_restorer.dart';

// -----------------------------------------------------------------------------

mixin _TypeUtils on _DartRestorerBase {
  /// SDK 类名到静态包装类名的映射
  /// 集中管理所有类型映射，避免在多处重复定义
  static const _sdkTypeMap = <String, String>{
    // 异步类型
    'Future': 'Promise',
    '_Future': 'Promise',
    // 集合类型
    'List': 'StaticList',
    '_GrowableList': 'StaticList',
    '_List': 'StaticList',
    'Map': 'StaticMap',
    '_Map': 'StaticMap',
    'LinkedHashMap': 'StaticMap',
    '_InternalLinkedHashMap': 'StaticMap',
    'Set': 'StaticSet',
    '_Set': 'StaticSet',
    'LinkedHashSet': 'StaticSet',
    '_CompactLinkedHashSet': 'StaticSet',
    // 工具类型
    'StringBuffer': 'StaticStringBuffer',
    'Iterator': 'StaticIterator',
    '_ListIterator': 'StaticIterator',
    'MapEntry': 'StaticMapEntry',
    'Duration': 'StaticDuration',
    'DateTime': 'StaticDateTime',
    'RegExp': 'StaticRegExp',
    '_RegExp': 'StaticRegExp',
    // 异常类型
    'StateError': 'DartStateError',
    'ArgumentError': 'DartArgumentError',
    'RangeError': 'DartRangeError',
    'FormatException': 'DartFormatException',
    'UnsupportedError': 'DartUnsupportedError',
    'UnimplementedError': 'DartUnimplementedError',
  };

  /// 将 SDK 类名映射到静态包装类名
  /// 如果不在映射表中，返回原始名称
  String _mapSdkTypeName(String name) {
    return _sdkTypeMap[name] ?? name;
  }

  /// 判断是否是集合类型（List/Map/Set 及其内部实现类）
  bool _isCollectionType(String name) {
    return name == 'List' || name == '_GrowableList' || name == '_List' ||
        name == 'Map' || name == '_Map' || name == 'LinkedHashMap' || name == '_InternalLinkedHashMap' ||
        name == 'Set' || name == '_Set' || name == 'LinkedHashSet' || name == '_CompactLinkedHashSet' ||
        name == 'Iterable';
  }

  /// 转义字符串字面量中的特殊字符
  /// [escapeDollar] 是否转义 $ 符号（用于字符串插值上下文）
  String _escapeStringLiteral(String value, {bool escapeDollar = false}) {
    var result = value
        .replaceAll('\\', '\\\\')
        .replaceAll("'", "\\'")
        .replaceAll('\n', '\\n')
        .replaceAll('\r', '\\r')
        .replaceAll('\t', '\\t');
    if (escapeDollar) {
      result = result.replaceAll(r'$', r'\$');
    }
    return result;
  }

  /// 根据 DartType 选择合适的 Box 类型名称（Bug 11 闭包引用语义）
  /// - int/double/bool/String → IntBox/DoubleBox/BoolBox/StringBox
  /// - TypeParameterType（泛型参数如 T）→ ObjectBox<T>（运行时可能是值类型）
  /// - 其他确定的引用类型（List、Map、函数、用户类等）→ null（不装箱）
  String? _boxTypeNameFor(DartType type) {
    final primitive = _primitiveBoxName(type);
    if (primitive != null) return primitive;
    // 泛型参数类型运行时可能是值类型，需要用 ObjectBox<T> 装箱
    if (type is TypeParameterType) {
      final paramName = type.parameter.name ?? 'T';
      final replacement = _activeTypeParamSubstitution[paramName];
      return 'ObjectBox<${replacement ?? paramName}>';
    }
    return null;
  }

  // ---- Arguments ----

  String _restoreArgs(Arguments args) {
    final parts = <String>[];
    for (final p in args.positional) {
      parts.add(_restoreExpr(p));
    }
    for (final n in args.named) {
      parts.add('${n.name}: ${_restoreExpr(n.value)}');
    }
    return parts.join(', ');
  }

  /// 还原参数列表，对 dynamic（AnyGC）参数自动装箱基本类型
  /// [target] 是目标函数的 FunctionNode，用于获取参数类型信息
  String _restoreArgsForTarget(FunctionNode target, Arguments args) {
    final parts = <String>[];
    final pos = target.positionalParameters;
    // positional
    for (var i = 0; i < args.positional.length; i++) {
      final argExpr = _restoreExpr(args.positional[i]);
      if (i < pos.length) {
        final argType = _getExpressionDartType(args.positional[i]);
        parts.add(_maybeBoxForAnyGC(pos[i].type, argExpr, argType));
      } else {
        parts.add(argExpr);
      }
    }
    // named
    for (final n in args.named) {
      final argExpr = _restoreExpr(n.value);
      // 查找目标参数类型
      final targetParam = target.namedParameters.where((p) => p.name == n.name).firstOrNull;
      if (targetParam != null) {
        final argType = _getExpressionDartType(n.value);
        parts.add('${n.name}: ${_maybeBoxForAnyGC(targetParam.type, argExpr, argType)}');
      } else {
        parts.add('${n.name}: $argExpr');
      }
    }
    return parts.join(', ');
  }

  /// 按目标 lowered 静态函数的「全 positional」ABI 还原实参列表：
  ///   [positional_0, positional_1, ..., named_0, named_1, ...]
  ///
  /// - positional 缺失（即调用点传的少于声明的）→ 用 initializer 或类型默认值
  ///   补齐；
  /// - named 按 [target.namedParameters] 的声明顺序输出，未传的一律由调用方
  ///   补齐（initializer 优先，否则按类型默认值）；
  /// - 不会输出 `name: value` 语法。
  String _restoreFlattenedArgs(FunctionNode target, Arguments args) {
    final parts = <String>[];

    // positional：先用调用点的，缺的用默认值补齐
    final pos = target.positionalParameters;
    for (var i = 0; i < pos.length; i++) {
      if (i < args.positional.length) {
        final argExpr = _restoreExpr(args.positional[i]);
        final argType = _getExpressionDartType(args.positional[i]);
        parts.add(_maybeBoxForAnyGC(pos[i].type, argExpr, argType));
      } else {
        final p = pos[i];
        parts.add(p.initializer != null
            ? _restoreExpr(p.initializer!)
            : _defaultValueForType(p.type));
      }
    }

    // named：按目标声明顺序，调用点的 name→expr 映射查找
    if (target.namedParameters.isNotEmpty) {
      final supplied = <String, Expression>{
        for (final n in args.named) n.name: n.value,
      };
      for (final p in target.namedParameters) {
        final name = p.name;
        if (name != null && supplied.containsKey(name)) {
          final argExpr = _restoreExpr(supplied[name]!);
          final argType = _getExpressionDartType(supplied[name]!);
          parts.add(_maybeBoxForAnyGC(p.type, argExpr, argType));
        } else {
          parts.add(p.initializer != null
              ? _restoreExpr(p.initializer!)
              : _defaultValueForType(p.type));
        }
      }
    }

    return parts.join(', ');
  }

  /// 从表达式中提取 DartType（用于自动装箱判断）
  /// 支持常见的表达式类型：变量引用等
  /// 对于字面量，返回 null 让调用方使用表达式模式匹配
  DartType? _getExpressionDartType(Expression expr) {
    if (expr is VariableGet) {
      return expr.promotedType ?? expr.variable.type;
    }
    // 其他表达式返回 null，由 _maybeBoxForAnyGC 使用表达式模式匹配
    return null;
  }

  // ---- Supertype ----

  String _restoreSupertype(Supertype s) {
    final name = s.classNode.name;
    if (s.typeArguments.isEmpty) return name;
    final args = s.typeArguments.map((t) => _restoreType(t)).join(', ');
    return '$name<$args>';
  }

  // ---- Types ----

  String _restoreType(DartType type) {
    final nullable = type.nullability == Nullability.nullable;
    final suffix = nullable ? '?' : '';

    if (type is InterfaceType) {
      final rawName = type.classNode.name;
      // OOP Lowering: 用户自定义类的实例类型引用改为 XValue
      // SDK 类型映射：通过 _mapSdkTypeName 统一处理
      String name;
      if (rawName == 'Function') {
        // dart:core 的 `Function` 顶层类型缺少 arity 信息，无法选具体的
        // TypeFunctionN；退化到 `dynamic`（变量仍能被动态派发调用，且产物
        // 中不再出现 `Function` 字面量）。
        return 'dynamic';
      } else if (_isUserClass(rawName)) {
        // 多文件支持：使用 Class 节点精确匹配，避免同名类冲突
        final prefix = _crossLibPrefixForClass(type.classNode);
        name = '$prefix${rawName}Value';
      } else {
        name = _mapSdkTypeName(rawName);
      }
      if (type.typeArguments.isEmpty) return '$name$suffix';
      final args = type.typeArguments.map((t) => _restoreType(t)).join(', ');
      return '$name<$args>$suffix';
    }
    if (type is FunctionType) {
      return _restoreFunctionTypeAsTypeFunction(type, suffix);
    }
    if (type is TypeParameterType) {
      final paramName = type.parameter.name ?? 'T';
      // Bug 21: 如果有活跃的类型参数替换映射，使用替换后的名称
      // 精确匹配：如果 _activeTypeParamTargets 非空，只替换属于目标集合中的 TypeParameter
      final replacement = _activeTypeParamSubstitution[paramName];
      if (replacement != null) {
        if (_activeTypeParamTargets.isEmpty || _activeTypeParamTargets.contains(type.parameter)) {
          return '$replacement$suffix';
        }
      }
      return '$paramName$suffix';
    }
    if (type is DynamicType) return 'dynamic';
    if (type is VoidType) return 'void';
    if (type is NeverType) return 'Never$suffix';
    if (type is FutureOrType) {
      // FutureOr<T> 统一映射为 Promise<T>（Promise 是 Future 的运行时替代）
      return 'Promise<${_restoreType(type.typeArgument)}>$suffix';
    }
    if (type is RecordType) {
      final parts = <String>[];
      for (final p in type.positional) {
        parts.add(_restoreType(p));
      }
      if (type.named.isNotEmpty) {
        final namedParts = <String>[];
        for (final n in type.named) {
          namedParts.add('${_restoreType(n.type)} ${n.name}');
        }
        parts.add('{${namedParts.join(', ')}}');
      }
      return '(${parts.join(', ')})$suffix';
    }
    return 'dynamic';
  }

  /// 变量声明类型还原：将 DynamicType 映射为 AnyGC（仅在变量声明位置使用）
  /// 这确保变量使用 AnyGC 类型而非 dynamic，同时保留装箱/拆箱逻辑
  String _restoreVarDeclType(DartType type) {
    if (type is DynamicType) return 'AnyGC';
    return _restoreType(type);
  }

  /// 仅在函数参数位置使用：将 DynamicType 映射为 AnyGC（而非 dynamic）
  /// 其他类型保持与 _restoreType 相同的行为
  String _restoreParamType(DartType type) {
    if (type is DynamicType) return 'AnyGC';
    // 其他类型委托给 _restoreType
    return _restoreType(type);
  }

  /// 为 async 函数计算包装后的返回类型字符串。
  /// - async void → 'Promise<int>'（统一转化为 async int）
  /// - async Future<T> / _Future<T> → 'Promise<T>'
  /// - async int（裸值类型）→ 'Promise<int>'
  String _asyncAwareRestoreType(DartType type, AsyncMarker marker) {
    if (marker != AsyncMarker.Async) return _restoreType(type);
    if (type is VoidType) return 'Promise<int>';
    if (type is InterfaceType) {
      final raw = type.classNode.name;
      if ((raw == 'Future' || raw == '_Future' || raw == 'Promise') &&
          type.typeArguments.isNotEmpty) {
        return 'Promise<${_restoreType(type.typeArguments.first)}>';
      }
    }
    return 'Promise<${_restoreType(type)}>';
  }

  /// 计算 async 函数的 inner return type（Promise<T> 中的 T）。
  /// - void → 'int'
  /// - Future<T> → T
  /// - 裸值类型 → 还原后的类型字符串
  String _computeAsyncInnerReturnType(DartType retType) {
    if (retType is VoidType) return 'int';
    if (retType is InterfaceType) {
      final raw = retType.classNode.name;
      if ((raw == 'Future' || raw == '_Future' || raw == 'Promise') &&
          retType.typeArguments.isNotEmpty) {
        return _restoreType(retType.typeArguments.first);
      }
    }
    return _restoreType(retType);
  }

  // ---- Helpers ----

  // Dart 保留关键字集合（不能作为标识符使用）
  static const _dartKeywords = {
    'this', 'super', 'new', 'null', 'true', 'false', 'void', 'var', 'final',
    'const', 'return', 'if', 'else', 'for', 'while', 'do', 'switch', 'case',
    'default', 'break', 'continue', 'try', 'catch', 'finally', 'throw',
    'rethrow', 'class', 'extends', 'implements', 'with', 'mixin', 'enum',
    'import', 'export', 'library', 'part', 'of', 'show', 'hide', 'as',
    'abstract', 'static', 'dynamic', 'get', 'set', 'operator', 'typedef',
    'is', 'in', 'assert', 'async', 'await', 'yield', 'sync', 'late',
    'required', 'external', 'factory', 'covariant',
  };

  String _cleanVarName(String name) {
    if (_cleanedNames.containsKey(name)) return _cleanedNames[name]!;
    String cleaned;
    if (name.startsWith(':')) {
      cleaned = name.substring(1);
    } else if (name.startsWith('#')) {
      cleaned = name.substring(1);
    } else if (name.contains('#')) {
      // 处理 0#0 这种格式，直接生成 _v 前缀的变量名，确保声明和引用使用相同的名称
      final parts = name.split('#');
      final lastPart = parts.last;
      if (lastPart.isEmpty || _digitStartPattern.hasMatch(lastPart)) {
        // 后面部分是空或以数字开头，生成 _v 前缀的变量名
        cleaned = '_v${_varCounter++}';
      } else {
        cleaned = '_v${_varCounter++}_$lastPart';
      }
    } else {
      cleaned = name;
    }
    // 确保清理后的变量名是合法的 Dart 标识符（不能以数字开头，不能包含 - 等特殊字符）
    if (cleaned.isNotEmpty && _digitStartPattern.hasMatch(cleaned)) {
      cleaned = '_v${_varCounter++}';
    }
    // 替换非法字符（如 -、|、# 等）为下划线
    cleaned = cleaned.replaceAll(_nonIdentifierPattern, '_');
    // 如果清理后的名称是 Dart 关键字，加 _ 后缀
    if (_dartKeywords.contains(cleaned)) {
      cleaned = '${cleaned}_';
    }
    _cleanedNames[name] = cleaned;
    return cleaned;
  }

  /// arity 上限；与 runtime_classes.dart 的 TypeFunctionN 一致。
  static const int kMaxArity = 16;

  /// 把 kernel FunctionType 还原成 `TypeFunctionN<R, T1..Tn>$suffix`。
  /// 当存在命名/可选位置参数或 arity 超限时，回退到 `TypeFunction<R>$suffix`
  /// 基类（仍然不出现 `Function` 字面量）。
  String _restoreFunctionTypeAsTypeFunction(FunctionType type, String suffix) {
    final ret = _restoreType(type.returnType);
    final hasNamed = type.namedParameters.isNotEmpty;
    final positional = type.positionalParameters;
    final required = type.requiredParameterCount;
    final hasOptionalPositional = positional.length > required;
    if (hasNamed || hasOptionalPositional || positional.length > kMaxArity) {
      return 'TypeFunction<$ret>$suffix';
    }
    final arity = positional.length;
    final paramTexts = [for (final p in positional) _restoreType(p)];
    final args = [ret, ...paramTexts].join(', ');
    return 'TypeFunction$arity<$args>$suffix';
  }

  bool _isBinaryOp(String name) {
    return const {'+', '-', '*', '/', '%', '~/', '>', '<', '>=', '<=', '&', '|', '^', '<<', '>>'}.contains(name);
  }


  /// 判断参数是否需要 covariant 关键字
  bool _needsCovariant(VariableDeclaration param, FunctionNode func, Procedure? proc) {
    return param.isCovariantByDeclaration;
  }

  /// 递归解析合成 mixin 类，找到真正的 superclass 名称
  String _resolveRealSuperclass(Class cls) {
    if (!cls.name.contains('&')) return cls.name;
    // 合成类的 supertype 指向上一层合成类或真正的 superclass
    if (cls.supertype != null) {
      return _resolveRealSuperclass(cls.supertype!.classNode);
    }
    return 'Object';
  }

  /// 把单个 kernel TypeParameter 还原成带 `extends Bound` 的形式。
  /// 与 _writeTypeParams 的策略一致：bound 是 Object/Object?/dynamic 时省略。
  String _formatTypeParamDecl(TypeParameter tp) {
    final name = tp.name ?? 'T';
    final bound = _restoreType(tp.bound);
    if (bound == 'Object' || bound == 'Object?' || bound == 'dynamic') {
      return name;
    }
    return '$name extends $bound';
  }

  /// 闭包参数侧的类型还原：在常规 _restoreType 基础上，把容器类型
  /// (List/Map/Set) 的类型实参中出现的 `Object` / `Object?` 归一为
  /// `dynamic`。仅作用于闭包参数（不影响返回类型 / 普通声明），用于
  /// 把 kernel 推断出的 `Map<K, Object>` 归一回 `Map<K, dynamic>`，与
  /// 调用点上下文（如 `List<Map<K, dynamic>>.sort`）保持兼容。
  String _restoreClosureParamType(DartType type) {
    final nullable = type.nullability == Nullability.nullable;
    final suffix = nullable ? '?' : '';
    if (type is InterfaceType) {
      final raw = type.classNode.name;
      if (!_isCollectionType(raw)) {
        return _restoreType(type);
      }
      // 集合类型映射：通过 _mapSdkTypeName 统一处理
      final mapped = raw == 'Iterable' ? 'Iterable' : _mapSdkTypeName(raw);
      if (type.typeArguments.isEmpty) return '$mapped$suffix';
      final args = type.typeArguments.map((t) {
        if (t is InterfaceType && t.classNode.name == 'Object') {
          return 'dynamic';
        }
        return _restoreClosureParamType(t);
      }).join(', ');
      return '$mapped<$args>$suffix';
    }
    return _restoreType(type);
  }

  /// 递归收集所有 mixin 名称（保留泛型参数）
  List<String> _collectMixins(Class cls) {
    if (!cls.name.contains('&')) return [];
    final mixins = <String>[];
    // 先递归收集上层的 mixin
    if (cls.supertype != null) {
      mixins.addAll(_collectMixins(cls.supertype!.classNode));
    }
    // 当前合成类的 implementedTypes 中包含当前层的 mixin
    for (final impl in cls.implementedTypes) {
      mixins.add(_restoreSupertype(impl));
    }
    return mixins;
  }
}