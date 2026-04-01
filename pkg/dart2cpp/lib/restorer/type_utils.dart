part of 'dart_restorer.dart';

// -----------------------------------------------------------------------------

mixin _TypeUtils on _DartRestorerBase {
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
      final name = type.classNode.name;
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
      return '${type.parameter.name ?? 'T'}$suffix';
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
    // 替换非法字符（如 -）为下划线
    cleaned = cleaned.replaceAll(RegExp(r'[^a-zA-Z0-9_]'), '_');
    _cleanedNames[name] = cleaned;
    return cleaned;
  }

  bool _isBinaryOp(String name) {
    return const {'+', '-', '*', '/', '%', '~/', '>', '<', '>=', '<=', '&', '|', '^', '<<', '>>'}.contains(name);
  }

  bool _isOperatorName(String name) {
    return const {'+', '-', '*', '/', '%', '~/', '>', '<', '>=', '<=', '&', '|', '^', '<<', '>>', '==', '[]', '[]=', '~', 'unary-'}.contains(name);
  }

  /// 判断参数是否需要 covariant 关键字
  /// covariant 只能用于类的实例方法重写父类/mixin 方法时的参数
  bool _needsCovariant(VariableDeclaration param, FunctionNode func, Procedure? proc) {
    // 如果没有 Procedure 上下文，无法判断是否是类方法
    if (proc == null) return false;
    
    // 静态方法不需要 covariant
    if (proc.isStatic) return false;
    
    // getter/setter 不需要 covariant
    if (proc.isGetter || proc.isSetter) return false;
    
    // 如果参数类型是 dynamic 或 Object，不需要 covariant
    if (param.type is DynamicType) return false;
    final paramType = _restoreType(param.type);
    if (paramType == 'dynamic' || paramType == 'Object') return false;
    
    // 常见需要 covariant 的方法名（重写父类/mixin 的方法）
    final covariantMethodNames = {'compareTo', '==', 'contains', 'add', 'remove'};
    if (covariantMethodNames.contains(proc.name.text)) {
      return true;
    }
    
    return false;
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

  /// 递归收集所有 mixin 名称
  List<String> _collectMixins(Class cls) {
    if (!cls.name.contains('&')) return [];
    final mixins = <String>[];
    // 先递归收集上层的 mixin
    if (cls.supertype != null) {
      mixins.addAll(_collectMixins(cls.supertype!.classNode));
    }
    // 当前合成类的 implementedTypes 中包含当前层的 mixin
    for (final impl in cls.implementedTypes) {
      mixins.add(impl.classNode.name);
    }
    return mixins;
  }
}