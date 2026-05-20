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
      final name = _isUserClass(rawName) ? '${rawName}Value' : rawName;
      if (type.typeArguments.isEmpty) return '$name$suffix';
      final args = type.typeArguments.map((t) => _restoreType(t)).join(', ');
      return '$name<$args>$suffix';
    }
    if (type is FunctionType) {
      final ret = _restoreType(type.returnType);
      final params = <String>[];
      for (final p in type.positionalParameters) {
        params.add(_restoreType(p));
      }
      for (final n in type.namedParameters) {
        params.add('${_restoreType(n.type)} ${n.name}');
      }
      return '$ret Function(${params.join(', ')})$suffix';
    }
    if (type is TypeParameterType) {
      final paramName = type.parameter.name ?? 'T';
      // Bug 21: 如果有活跃的类型参数替换映射，使用替换后的名称
      final replacement = _activeTypeParamSubstitution[paramName];
      return '${replacement ?? paramName}$suffix';
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
      for (final n in type.named) {
        parts.add('${_restoreType(n.type)} ${n.name}');
      }
      return '(${parts.join(', ')})$suffix';
    }
    return 'dynamic';
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