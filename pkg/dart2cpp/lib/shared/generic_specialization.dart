/// 泛型特化扫描器 — 收集方法级泛型调用的具体类型实参。
///
/// 合并自：
/// - `restorer/dart_restorer.dart` 的 `_collectMethodTypeSpecializations`
/// - `cpp_compiler/class_info_collector.dart` 的 `_collectMethodTypeSpecializations`
library generic_specialization;

import 'package:kernel/kernel.dart';
import 'analysis_context.dart';

/// 泛型特化扫描器。
///
/// 遍历所有用户库的 AST，找到带泛型 *且类型实参全部为具体类型* 的
/// `InstanceInvocation`，按 `className → methodName → Set<MethodSpecEntry>` 登记。
class GenericSpecializationScanner {
  final AnalysisContext ctx;

  GenericSpecializationScanner(this.ctx);

  /// 扫描所有用户库。
  void scan(Component component) {
    for (final lib in component.libraries) {
      final uri = lib.importUri.toString();
      if (uri.startsWith('dart:') || uri.startsWith('package:')) continue;
      _scanLibrary(lib);
    }
  }

  void _scanLibrary(Library lib) {
    for (final cls in lib.classes) {
      for (final proc in cls.procedures) {
        if (proc.function.body != null) {
          _scanNode(proc.function.body!);
        }
      }
      for (final ctor in cls.constructors) {
        if (ctor.function.body != null) {
          _scanNode(ctor.function.body!);
        }
        for (final init in ctor.initializers) {
          _scanNode(init);
        }
      }
      for (final field in cls.fields) {
        if (field.initializer != null) {
          _scanNode(field.initializer!);
        }
      }
    }
    for (final proc in lib.procedures) {
      if (proc.function.body != null) {
        _scanNode(proc.function.body!);
      }
    }
    for (final field in lib.fields) {
      if (field.initializer != null) {
        _scanNode(field.initializer!);
      }
    }
  }

  /// 递归扫描 AST 节点，找到 `InstanceInvocation` 并检查。
  void _scanNode(TreeNode node) {
    if (node is InstanceInvocation) {
      _checkAndRecord(node);
    }
    _scanChildren(node);
  }

  /// 检查一个 `InstanceInvocation` 是否需要泛型特化。
  void _checkAndRecord(InstanceInvocation node) {
    final target = node.interfaceTarget;

    // 获取方法自身的类型参数（不是类级别的）
    final funcTypeParams = target.function.typeParameters;
    if (funcTypeParams.isEmpty) return;

    // 获取调用处的类型实参
    final typeArgs = node.arguments.types;
    if (typeArgs.length < funcTypeParams.length) return;

    // 检查所有类型实参是否都是具体类型（不含类型参数引用）
    final concreteArgs = typeArgs.sublist(0, funcTypeParams.length);
    for (final typeArg in concreteArgs) {
      if (_containsTypeParameter(typeArg)) return;
    }

    // 获取接收者类名
    String? className;
    final enclosingClass = target.enclosingClass;
    if (enclosingClass != null) {
      className = enclosingClass.name;
      if (className.contains('&')) {
        className = _sanitizeSyntheticName(className);
      }
      // 如果是 synthetic mixin 类，解析为用户类名
      if (ctx.isSyntheticMixin(className)) {
        className = ctx.findUserClassForSynthetic(className);
      }
    }
    if (className == null) return;

    // 构建后缀和类型字符串
    final typeArgStrs = concreteArgs.map((t) => _typeToString(t)).toList();
    final suffix = typeArgStrs.join('_');

    final entry = MethodSpecEntry(suffix, typeArgStrs);

    ctx.methodTypeSpecializations
        .putIfAbsent(className, () => {})
        .putIfAbsent(target.name.text, () => {})
        .add(entry);
  }

  /// 检查类型是否包含类型参数。
  bool _containsTypeParameter(DartType type) {
    if (type is TypeParameterType) return true;
    if (type is InterfaceType) {
      return type.typeArguments.any(_containsTypeParameter);
    }
    if (type is FunctionType) {
      if (_containsTypeParameter(type.returnType)) return true;
      return type.positionalParameters.any(_containsTypeParameter);
    }
    return false;
  }

  /// 将类型转为字符串（用于 vptr key 后缀）。
  String _typeToString(DartType type) {
    if (type is InterfaceType) {
      final name = type.classNode.name;
      // 映射集合类型
      if (name == 'List' || name == '_GrowableList' || name == '_List') {
        return 'StaticList';
      }
      if (name == 'Map' ||
          name == '_Map' ||
          name == 'LinkedHashMap' ||
          name == '_InternalLinkedHashMap') {
        return 'StaticMap';
      }
      if (name == 'Set' ||
          name == '_Set' ||
          name == '_CompactLinkedHashSet' ||
          name == 'LinkedHashSet') {
        return 'StaticSet';
      }
      if (name == 'Future' || name == '_Future') return 'Promise';
      return name;
    }
    if (type is VoidType) return 'void';
    if (type is DynamicType) return 'dynamic';
    if (type is TypeParameterType) return type.parameter.name ?? 'T';
    return 'dynamic';
  }

  static String _sanitizeSyntheticName(String name) {
    var result = name;
    if (result.startsWith('_')) result = result.substring(1);
    return result.replaceAll('&', '_');
  }

  /// 递归扫描子节点。
  void _scanChildren(TreeNode node) {
    if (node is Block) {
      for (final stmt in node.statements) {
        _scanNode(stmt);
      }
    } else if (node is ExpressionStatement) {
      _scanNode(node.expression);
    } else if (node is ReturnStatement) {
      if (node.expression != null) _scanNode(node.expression!);
    } else if (node is VariableDeclaration) {
      if (node.initializer != null) _scanNode(node.initializer!);
    } else if (node is VariableSet) {
      _scanNode(node.value);
    } else if (node is IfStatement) {
      _scanNode(node.condition);
      _scanNode(node.then);
      if (node.otherwise != null) _scanNode(node.otherwise!);
    } else if (node is ForStatement) {
      for (final v in node.variables) {
        if (v.initializer != null) _scanNode(v.initializer!);
      }
      if (node.condition != null) _scanNode(node.condition!);
      for (final u in node.updates) {
        _scanNode(u);
      }
      _scanNode(node.body);
    } else if (node is ForInStatement) {
      _scanNode(node.iterable);
      _scanNode(node.body);
    } else if (node is WhileStatement) {
      _scanNode(node.condition);
      _scanNode(node.body);
    } else if (node is DoStatement) {
      _scanNode(node.body);
      _scanNode(node.condition);
    } else if (node is TryCatch) {
      _scanNode(node.body);
      for (final c in node.catches) {
        _scanNode(c.body);
      }
    } else if (node is TryFinally) {
      _scanNode(node.body);
      _scanNode(node.finalizer);
    } else if (node is SwitchStatement) {
      _scanNode(node.expression);
      for (final c in node.cases) {
        for (final e in c.expressions) {
          _scanNode(e);
        }
        _scanNode(c.body);
      }
    } else if (node is Let) {
      if (node.variable.initializer != null) {
        _scanNode(node.variable.initializer!);
      }
      _scanNode(node.body);
    } else if (node is BlockExpression) {
      for (final stmt in node.body.statements) {
        _scanNode(stmt);
      }
      _scanNode(node.value);
    } else if (node is StaticInvocation) {
      for (final arg in node.arguments.positional) {
        _scanNode(arg);
      }
      for (final arg in node.arguments.named) {
        _scanNode(arg.value);
      }
    } else if (node is ConstructorInvocation) {
      for (final arg in node.arguments.positional) {
        _scanNode(arg);
      }
      for (final arg in node.arguments.named) {
        _scanNode(arg.value);
      }
    } else if (node is InstanceGet) {
      _scanNode(node.receiver);
    } else if (node is InstanceSet) {
      _scanNode(node.receiver);
      _scanNode(node.value);
    } else if (node is ConditionalExpression) {
      _scanNode(node.condition);
      _scanNode(node.then);
      _scanNode(node.otherwise);
    } else if (node is LogicalExpression) {
      _scanNode(node.left);
      _scanNode(node.right);
    } else if (node is Not) {
      _scanNode(node.operand);
    } else if (node is StringConcatenation) {
      for (final part in node.expressions) {
        _scanNode(part);
      }
    } else if (node is AsExpression) {
      _scanNode(node.operand);
    } else if (node is IsExpression) {
      _scanNode(node.operand);
    } else if (node is FunctionInvocation) {
      _scanNode(node.receiver);
      for (final arg in node.arguments.positional) {
        _scanNode(arg);
      }
    } else if (node is FunctionExpression) {
      if (node.function.body != null) _scanNode(node.function.body!);
    } else if (node is SuperMethodInvocation) {
      for (final arg in node.arguments.positional) {
        _scanNode(arg);
      }
    } else if (node is InstanceInvocation) {
      _scanNode(node.receiver);
      for (final arg in node.arguments.positional) {
        _scanNode(arg);
      }
      for (final arg in node.arguments.named) {
        _scanNode(arg.value);
      }
    } else if (node is AwaitExpression) {
      _scanNode(node.operand);
    } else if (node is LabeledStatement) {
      _scanNode(node.body);
    } else if (node is BreakStatement) {
      // no children
    } else if (node is EmptyStatement) {
      // no children
    } else if (node is YieldStatement) {
      _scanNode(node.expression);
    } else if (node is AssertStatement) {
      _scanNode(node.condition);
      if (node.message != null) _scanNode(node.message!);
    }
  }
}
