part of 'dart_restorer.dart';

// -----------------------------------------------------------------------------

mixin _TypeUtils on _DartRestorerBase {
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
        parts.add(_restoreExpr(args.positional[i]));
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
          parts.add(_restoreExpr(supplied[name]!));
        } else {
          parts.add(p.initializer != null
              ? _restoreExpr(p.initializer!)
              : _defaultValueForType(p.type));
        }
      }
    }

    return parts.join(', ');
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
      // Future<T> → Promise<T>（状态机协程替代）
      // 集合静态化: List→StaticList, Map→StaticMap, Set→StaticSet
      String name;
      if (rawName == 'Future' || rawName == '_Future') {
        name = 'Promise';
      } else if (rawName == 'List' || rawName == '_GrowableList' || rawName == '_List') {
        name = 'StaticList';
      } else if (rawName == 'Map' || rawName == '_Map' || rawName == 'LinkedHashMap' || rawName == '_InternalLinkedHashMap') {
        name = 'StaticMap';
      } else if (rawName == 'Set' || rawName == '_Set' || rawName == 'LinkedHashSet' || rawName == '_CompactLinkedHashSet') {
        name = 'StaticSet';
      } else if (rawName == 'Function') {
        // dart:core 的 `Function` 顶层类型缺少 arity 信息，无法选具体的
        // TypeFunctionN；退化到 `dynamic`（变量仍能被动态派发调用，且产物
        // 中不再出现 `Function` 字面量）。
        return 'dynamic';
      } else if (rawName == 'StringBuffer') {
        name = 'StaticStringBuffer';
      } else if (rawName == 'Iterator' || rawName == '_ListIterator') {
        name = 'StaticIterator';
      } else if (rawName == 'MapEntry') {
        name = 'StaticMapEntry';
      } else if (rawName == 'Duration') {
        name = 'StaticDuration';
      } else if (rawName == 'DateTime') {
        name = 'StaticDateTime';
      } else if (rawName == 'RegExp' || rawName == '_RegExp') {
        name = 'StaticRegExp';
      } else if (_isUserClass(rawName)) {
        name = '${rawName}Value';
      } else {
        name = rawName;
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
      return 'FutureOr<${_restoreType(type.typeArgument)}>$suffix';
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
      if (lastPart.isEmpty || RegExp(r'^[0-9]').hasMatch(lastPart)) {
        // 后面部分是空或以数字开头，生成 _v 前缀的变量名
        cleaned = '_v${_varCounter++}';
      } else {
        cleaned = '_v${_varCounter++}_$lastPart';
      }
    } else {
      cleaned = name;
    }
    // 确保清理后的变量名是合法的 Dart 标识符（不能以数字开头，不能包含 - 等特殊字符）
    if (cleaned.isNotEmpty && RegExp(r'^[0-9]').hasMatch(cleaned)) {
      cleaned = '_v${_varCounter++}';
    }
    // 替换非法字符（如 -、|、# 等）为下划线
    cleaned = cleaned.replaceAll(RegExp(r'[^a-zA-Z0-9_]'), '_');
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
      final isContainer = raw == 'List' || raw == '_List' || raw == '_GrowableList'
          || raw == 'Map' || raw == '_Map' || raw == 'LinkedHashMap' || raw == '_InternalLinkedHashMap'
          || raw == 'Set' || raw == '_Set' || raw == 'LinkedHashSet' || raw == '_CompactLinkedHashSet'
          || raw == 'Iterable';
      if (!isContainer) {
        return _restoreType(type);
      }
      String mapped;
      if (raw == 'List' || raw == '_List' || raw == '_GrowableList') {
        mapped = 'StaticList';
      } else if (raw == 'Map' || raw == '_Map' || raw == 'LinkedHashMap' || raw == '_InternalLinkedHashMap') {
        mapped = 'StaticMap';
      } else if (raw == 'Set' || raw == '_Set' || raw == 'LinkedHashSet' || raw == '_CompactLinkedHashSet') {
        mapped = 'StaticSet';
      } else {
        mapped = 'Iterable';
      }
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