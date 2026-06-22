/// Dart→C++ 类信息收集器
///
/// 镜像 `lib/restorer/dart_restorer.dart` 的 Pass 1 + Pass 2：
/// 1. 扫描所有非 SDK 库，收集用户类、mixin、enum 信息
/// 2. 拓扑排序后构建每个类的虚表（VTable）
/// 3. 预扫描方法级泛型特化
///
/// 输出供 CppEmitter 使用的 ClassInfo / VTableEntry / MethodSpecEntry。
library;

import 'package:kernel/kernel.dart';
import 'package:kernel/ast.dart';

import 'type_mapper.dart';

// ============================================================================
// 数据结构
// ============================================================================

/// 虚表条目：记录方法的 C++ 签名信息
class VTableEntry {
  final String name;           // 方法名（如 'speak', 'get_name', 'operatorPlus'）
  final String kind;           // 'method' | 'getter' | 'setter' | 'operator'
  final String staticFuncName; // C++ 静态函数名（如 'Dog_speak', 'Dog_get_name'）
  final String cppReturnType;  // C++ 返回类型
  final List<String> cppParamTypes; // C++ 参数类型（不含 this__）
  final Procedure? proc;       // 原始 Procedure 引用
  final String? declaringClassName; // 首次声明该方法的类名

  VTableEntry({
    required this.name,
    required this.kind,
    required this.staticFuncName,
    required this.cppReturnType,
    required this.cppParamTypes,
    this.proc,
    this.declaringClassName,
  });

  /// 生成 C++ 函数指针类型签名：`RetType(*)(AnyPtr, ParamTypes...)`
  String cppFuncPtrType() {
    final params = ['AnyPtr', ...cppParamTypes].join(', ');
    return '$cppReturnType(*)($params)';
  }

  /// 生成 vptr key
  String vptrKey() {
    switch (kind) {
      case 'getter': return 'get_$name';
      case 'setter': return 'set_$name';
      case 'operator': return name;  // 已经是 operatorPlus 等
      default: return name;          // 'method'
    }
  }
}

/// 方法级泛型特化条目
class MethodSpecEntry {
  final String vptrSuffix;       // vptr key 后缀（如 'String', 'int'）
  final List<String> typeArgStrs; // 类型实参字符串（如 ['String'], ['int']）

  MethodSpecEntry(this.vptrSuffix, this.typeArgStrs);

  @override
  bool operator ==(Object other) =>
      other is MethodSpecEntry && other.vptrSuffix == vptrSuffix;

  @override
  int get hashCode => vptrSuffix.hashCode;
}

/// 类信息收集结果
class ClassInfo {
  final Set<String> userClasses;
  final Set<String> mixinNames;
  final Set<String> enumNames;
  final Set<String> enumsWithCustomToString;
  final Map<String, String> classHierarchy;          // 子 → 父
  final Map<String, List<VTableEntry>> classVTableEntries;
  final Map<String, Class> classNodes;
  final Set<String> syntheticLoweredNames;
  final Map<String, Map<String, Set<MethodSpecEntry>>> methodTypeSpecializations;

  ClassInfo()
      : userClasses = {},
        mixinNames = {},
        enumNames = {},
        enumsWithCustomToString = {},
        classHierarchy = {},
        classVTableEntries = {},
        classNodes = {},
        syntheticLoweredNames = {},
        methodTypeSpecializations = {};
}

// ============================================================================
// 收集器
// ============================================================================

/// 类信息收集器。镜像 DartRestorer 的 Pass 1 + Pass 2。
class ClassInfoCollector {
  final TypeMapper typeMapper;
  final ClassInfo info = ClassInfo();

  ClassInfoCollector(this.typeMapper);

  /// 执行完整的三遍收集
  ClassInfo collect(Component component) {
    // Pass 1: 类信息 + 虚表
    for (final lib in component.libraries) {
      final uri = lib.importUri.toString();
      if (uri.startsWith('dart:') || uri.startsWith('package:')) continue;
      _collectClassInfo(lib);
    }

    // Pass 2: 方法级泛型特化
    for (final lib in component.libraries) {
      final uri = lib.importUri.toString();
      if (uri.startsWith('dart:') || uri.startsWith('package:')) continue;
      _collectMethodTypeSpecializations(lib);
    }

    // 同步 userClasses 到 typeMapper
    typeMapper.userClasses.addAll(info.userClasses);
    typeMapper.mixinNames.addAll(info.mixinNames);

    return info;
  }

  // ============================================================================
  // Pass 1: 类信息收集 + 虚表构建
  // ============================================================================

  void _collectClassInfo(Library lib) {
    final userClassEntries = <(String, Class)>[];

    for (final cls in lib.classes) {
      // mixin 声明
      if (cls.isMixinDeclaration && !cls.name.contains('&')) {
        info.mixinNames.add(cls.name);
        info.classNodes[cls.name] = cls;
        continue;
      }

      // enum
      if (_isEnumClass(cls)) {
        info.enumNames.add(cls.name);
        info.classNodes[cls.name] = cls;
        final hasCustomToString = cls.procedures.any((p) =>
            p.name.text == 'toString' && !p.isAbstract && p.function.body != null);
        if (hasCustomToString) {
          info.enumsWithCustomToString.add(cls.name);
        }
        continue;
      }

      // 合成 mixin 中间类
      final isSynthetic = cls.name.contains('&');
      final className = isSynthetic
          ? _sanitizeSyntheticName(cls.name)
          : cls.name;

      if (className.isEmpty) continue;

      info.userClasses.add(className);
      if (isSynthetic) {
        info.syntheticLoweredNames.add(className);
      }
      info.classNodes[className] = cls;

      // 继承关系
      if (cls.supertype != null) {
        final superName = cls.supertype!.classNode.name;
        if (superName.contains('&')) {
          info.classHierarchy[className] = _sanitizeSyntheticName(superName);
        } else if (superName != 'Object' && superName != '_Enum') {
          info.classHierarchy[className] = superName;
        }
      }

      userClassEntries.add((className, cls));
    }

    // 拓扑排序后构建虚表
    final sorted = _topologicalSort(userClassEntries);
    for (final (className, cls) in sorted) {
      _collectVTableEntries(cls, overrideName: className);
    }
  }

  bool _isEnumClass(Class cls) {
    if (cls.supertype == null) return false;
    return cls.supertype!.classNode.name == '_Enum' ||
        cls.supertype!.classNode.name == 'Enum';
  }

  String _sanitizeSyntheticName(String name) {
    var cleaned = name.startsWith('_') ? name.substring(1) : name;
    cleaned = cleaned.replaceAll('&', '_');
    return cleaned;
  }

  /// 拓扑排序：父类在子类之前
  List<(String, Class)> _topologicalSort(List<(String, Class)> entries) {
    final nameToEntry = <String, (String, Class)>{};
    for (final entry in entries) {
      nameToEntry[entry.$1] = entry;
    }

    final sorted = <(String, Class)>[];
    final visited = <String>{};

    void visit(String className) {
      if (visited.contains(className)) return;
      visited.add(className);
      final parent = info.classHierarchy[className];
      if (parent != null && nameToEntry.containsKey(parent)) {
        visit(parent);
      }
      final entry = nameToEntry[className];
      if (entry != null) sorted.add(entry);
    }

    for (final entry in entries) {
      visit(entry.$1);
    }
    return sorted;
  }

  // ============================================================================
  // 虚表构建
  // ============================================================================

  void _collectVTableEntries(Class cls, {String? overrideName}) {
    final className = overrideName ?? cls.name;
    final entries = <VTableEntry>[];

    // 继承父类虚表
    final parentName = info.classHierarchy[className];
    if (parentName != null && info.classVTableEntries.containsKey(parentName)) {
      entries.addAll(info.classVTableEntries[parentName]!);
    }

    // implements 接口
    for (final impl in cls.implementedTypes) {
      final ifaceName = impl.classNode.name;
      if (info.classVTableEntries.containsKey(ifaceName)) {
        for (final ifaceEntry in info.classVTableEntries[ifaceName]!) {
          final exists = entries.any(
              (e) => e.name == ifaceEntry.name && e.kind == ifaceEntry.kind);
          if (!exists) {
            entries.add(VTableEntry(
              name: ifaceEntry.name,
              kind: ifaceEntry.kind,
              staticFuncName: ifaceEntry.staticFuncName,
              cppReturnType: ifaceEntry.cppReturnType,
              cppParamTypes: List.from(ifaceEntry.cppParamTypes),
              declaringClassName: ifaceEntry.declaringClassName,
            ));
          }
        }
      }
    }

    // 本类方法
    for (final proc in cls.procedures) {
      if (proc.isStatic) continue;
      if (proc.isFactory) continue;
      if (proc.name.text.startsWith('_')) continue;

      final methodName = proc.name.text;
      final entry = _buildVTableEntry(cls, proc, methodName, className);

      final existingIdx = entries.indexWhere(
          (e) => e.name == methodName && e.kind == entry.kind);
      if (existingIdx >= 0) {
        final existingDeclaring = entries[existingIdx].declaringClassName ?? className;
        entries[existingIdx] = VTableEntry(
          name: entry.name,
          kind: entry.kind,
          staticFuncName: entry.staticFuncName,
          cppReturnType: entry.cppReturnType,
          cppParamTypes: entry.cppParamTypes,
          proc: entry.proc,
          declaringClassName: existingDeclaring,
        );
      } else {
        entries.add(VTableEntry(
          name: entry.name,
          kind: entry.kind,
          staticFuncName: entry.staticFuncName,
          cppReturnType: entry.cppReturnType,
          cppParamTypes: entry.cppParamTypes,
          proc: entry.proc,
          declaringClassName: className,
        ));
      }
    }

    info.classVTableEntries[className] = entries;
  }

  VTableEntry _buildVTableEntry(
      Class cls, Procedure proc, String methodName, String className) {
    String kind;
    String staticFuncName;
    String cppReturnType;
    List<String> cppParamTypes;

    if (proc.isGetter) {
      kind = 'getter';
      staticFuncName = '${className}_get_$methodName';
      cppReturnType = typeMapper.cppType(proc.function.returnType);
      cppParamTypes = [];
    } else if (proc.isSetter) {
      kind = 'setter';
      staticFuncName = '${className}_set_$methodName';
      cppReturnType = 'void';
      cppParamTypes = proc.function.positionalParameters.isNotEmpty
          ? [typeMapper.cppType(proc.function.positionalParameters.first.type)]
          : ['AnyPtr'];
    } else if (TypeMapper.isOperatorName(methodName)) {
      kind = 'operator';
      final suffix = TypeMapper.operatorCppSuffix(methodName);
      staticFuncName = '${className}_operator$suffix';
      cppReturnType = typeMapper.cppType(proc.function.returnType);
      cppParamTypes = proc.function.positionalParameters
          .map((p) => typeMapper.cppType(p.type))
          .toList();
    } else {
      kind = 'method';
      staticFuncName = '${className}_$methodName';
      cppReturnType = typeMapper.cppType(proc.function.returnType);
      cppParamTypes = <String>[];
      for (final p in proc.function.positionalParameters) {
        cppParamTypes.add(typeMapper.cppType(p.type));
      }
      for (final p in proc.function.namedParameters) {
        cppParamTypes.add(typeMapper.cppType(p.type));
      }
    }

    return VTableEntry(
      name: methodName,
      kind: kind,
      staticFuncName: staticFuncName,
      cppReturnType: cppReturnType,
      cppParamTypes: cppParamTypes,
      proc: proc,
    );
  }

  // ============================================================================
  // Pass 2: 方法级泛型特化收集
  // ============================================================================

  void _collectMethodTypeSpecializations(Library lib) {
    for (final cls in lib.classes) {
      for (final proc in cls.procedures) {
        if (proc.function.body != null) {
          _scanNodeForMethodTypeSpecs(proc.function.body!);
        }
      }
      for (final ctor in cls.constructors) {
        if (ctor.function.body != null) {
          _scanNodeForMethodTypeSpecs(ctor.function.body!);
        }
      }
      for (final field in cls.fields) {
        if (field.initializer != null) {
          _scanNodeForMethodTypeSpecs(field.initializer!);
        }
      }
    }
    for (final proc in lib.procedures) {
      if (proc.function.body != null) {
        _scanNodeForMethodTypeSpecs(proc.function.body!);
      }
    }
    for (final field in lib.fields) {
      if (field.initializer != null) {
        _scanNodeForMethodTypeSpecs(field.initializer!);
      }
    }
  }

  void _scanNodeForMethodTypeSpecs(TreeNode node) {
    if (node is InstanceInvocation) {
      _checkAndRecordMethodTypeSpec(node);
      _scanNodeForMethodTypeSpecs(node.receiver);
      for (final a in node.arguments.positional) {
        _scanNodeForMethodTypeSpecs(a);
      }
      for (final a in node.arguments.named) {
        _scanNodeForMethodTypeSpecs(a.value);
      }
      return;
    }
    _scanChildrenForMethodTypeSpecs(node);
  }

  void _checkAndRecordMethodTypeSpec(InstanceInvocation node) {
    final target = node.interfaceTarget;
    final methodTypeParams = target.function.typeParameters;
    if (methodTypeParams.isEmpty) return;

    final enclosingClass = target.enclosingClass;
    if (enclosingClass == null) return;

    var className = enclosingClass.name;
    if (className.contains('&')) {
      className = _sanitizeSyntheticName(className);
    }
    if (!info.userClasses.contains(className)) return;
    if (info.syntheticLoweredNames.contains(className)) {
      className = _findUserClassForSynthetic(className);
    }

    // 去重方法级泛型
    final classTpNames = enclosingClass.typeParameters.map((tp) => tp.name).toSet();
    final dedupedMethodTps = methodTypeParams
        .where((tp) => !classTpNames.contains(tp.name))
        .toList();
    if (dedupedMethodTps.isEmpty) return;

    final methodTypeArgs = node.arguments.types;
    if (methodTypeArgs.isEmpty) return;

    // 只处理全部具体的类型实参
    final hasAbstract = methodTypeArgs.any((ta) => typeMapper.containsTypeParameter(ta));
    if (hasAbstract) return;

    final methodName = target.name.text;
    final typeSuffix = methodTypeArgs
        .map((ta) => typeMapper.typeToSpecSuffix(ta))
        .join('_');
    if (typeSuffix.isEmpty) return;

    final typeArgStrs = methodTypeArgs
        .map((ta) => typeMapper.typeToSpecRestoreStr(ta))
        .toList();

    info.methodTypeSpecializations
        .putIfAbsent(className, () => {})
        .putIfAbsent(methodName, () => {})
        .add(MethodSpecEntry(typeSuffix, typeArgStrs));
  }

  String _findUserClassForSynthetic(String syntheticName) {
    // 合成类名如 Dog_Animal_Printable → 找到 Dog
    for (final uc in info.userClasses) {
      if (!info.syntheticLoweredNames.contains(uc)) {
        if (syntheticName.startsWith(uc)) return uc;
      }
    }
    return syntheticName;
  }

  /// 通用子节点遍历
  void _scanChildrenForMethodTypeSpecs(TreeNode node) {
    if (node is Block) {
      for (final s in node.statements) _scanNodeForMethodTypeSpecs(s);
    } else if (node is ExpressionStatement) {
      _scanNodeForMethodTypeSpecs(node.expression);
    } else if (node is ReturnStatement) {
      if (node.expression != null) _scanNodeForMethodTypeSpecs(node.expression!);
    } else if (node is VariableDeclaration) {
      if (node.initializer != null) _scanNodeForMethodTypeSpecs(node.initializer!);
    } else if (node is VariableSet) {
      _scanNodeForMethodTypeSpecs(node.value);
    } else if (node is IfStatement) {
      _scanNodeForMethodTypeSpecs(node.condition);
      _scanNodeForMethodTypeSpecs(node.then);
      if (node.otherwise != null) _scanNodeForMethodTypeSpecs(node.otherwise!);
    } else if (node is ForStatement) {
      for (final v in node.variables) _scanNodeForMethodTypeSpecs(v);
      if (node.condition != null) _scanNodeForMethodTypeSpecs(node.condition!);
      for (final u in node.updates) _scanNodeForMethodTypeSpecs(u);
      _scanNodeForMethodTypeSpecs(node.body);
    } else if (node is ForInStatement) {
      _scanNodeForMethodTypeSpecs(node.variable);
      _scanNodeForMethodTypeSpecs(node.iterable);
      _scanNodeForMethodTypeSpecs(node.body);
    } else if (node is WhileStatement) {
      _scanNodeForMethodTypeSpecs(node.condition);
      _scanNodeForMethodTypeSpecs(node.body);
    } else if (node is DoStatement) {
      _scanNodeForMethodTypeSpecs(node.body);
      _scanNodeForMethodTypeSpecs(node.condition);
    } else if (node is TryCatch) {
      _scanNodeForMethodTypeSpecs(node.body);
      for (final c in node.catches) _scanNodeForMethodTypeSpecs(c.body);
    } else if (node is TryFinally) {
      _scanNodeForMethodTypeSpecs(node.body);
      _scanNodeForMethodTypeSpecs(node.finalizer);
    } else if (node is SwitchStatement) {
      _scanNodeForMethodTypeSpecs(node.expression);
      for (final c in node.cases) _scanNodeForMethodTypeSpecs(c.body);
    } else if (node is Let) {
      _scanNodeForMethodTypeSpecs(node.variable);
      _scanNodeForMethodTypeSpecs(node.body);
    } else if (node is BlockExpression) {
      _scanNodeForMethodTypeSpecs(node.body);
      _scanNodeForMethodTypeSpecs(node.value);
    } else if (node is StaticInvocation) {
      for (final a in node.arguments.positional) _scanNodeForMethodTypeSpecs(a);
      for (final a in node.arguments.named) _scanNodeForMethodTypeSpecs(a.value);
    } else if (node is ConstructorInvocation) {
      for (final a in node.arguments.positional) _scanNodeForMethodTypeSpecs(a);
      for (final a in node.arguments.named) _scanNodeForMethodTypeSpecs(a.value);
    } else if (node is InstanceGet) {
      _scanNodeForMethodTypeSpecs(node.receiver);
    } else if (node is InstanceSet) {
      _scanNodeForMethodTypeSpecs(node.receiver);
      _scanNodeForMethodTypeSpecs(node.value);
    } else if (node is ConditionalExpression) {
      _scanNodeForMethodTypeSpecs(node.condition);
      _scanNodeForMethodTypeSpecs(node.then);
      _scanNodeForMethodTypeSpecs(node.otherwise);
    } else if (node is LogicalExpression) {
      _scanNodeForMethodTypeSpecs(node.left);
      _scanNodeForMethodTypeSpecs(node.right);
    } else if (node is Not) {
      _scanNodeForMethodTypeSpecs(node.operand);
    } else if (node is StringConcatenation) {
      for (final e in node.expressions) _scanNodeForMethodTypeSpecs(e);
    } else if (node is AsExpression) {
      _scanNodeForMethodTypeSpecs(node.operand);
    } else if (node is IsExpression) {
      _scanNodeForMethodTypeSpecs(node.operand);
    } else if (node is FunctionInvocation) {
      _scanNodeForMethodTypeSpecs(node.receiver);
      for (final a in node.arguments.positional) _scanNodeForMethodTypeSpecs(a);
      for (final a in node.arguments.named) _scanNodeForMethodTypeSpecs(a.value);
    } else if (node is FunctionExpression) {
      if (node.function.body != null) {
        _scanNodeForMethodTypeSpecs(node.function.body!);
      }
    } else if (node is SuperMethodInvocation) {
      for (final a in node.arguments.positional) _scanNodeForMethodTypeSpecs(a);
      for (final a in node.arguments.named) _scanNodeForMethodTypeSpecs(a.value);
    }
  }
}
