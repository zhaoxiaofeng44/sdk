part of 'dart_restorer.dart';

// ============================================================================
// Dart Kernel AST → C++ 代码生成器
// ============================================================================
// CppEmitter 复用 _ClassInfoCollector 的类信息收集、VTable 构建、泛型特化分析，
// 使用独立的 C++ 代码发射逻辑，输出依赖 dart2cpp_lowered.h 运行时。
// ============================================================================

/// 将 Dart Kernel Component 转换为 C++ 源码字符串
String emitCppFromComponent(Component component) {
  return CppEmitter().emit(component);
}

/// C++ 代码生成器
class CppEmitter {
  /// 前向声明缓冲区
  final StringBuffer _fwdBuf = StringBuffer();

  /// 结构体/类定义缓冲区
  StringBuffer _structBuf = StringBuffer();

  /// 函数实现缓冲区
  StringBuffer _implBuf = StringBuffer();

  /// main 函数缓冲区
  final StringBuffer _mainBuf = StringBuffer();

  /// 缩进级别
  int _indent = 0;

  /// 变量计数器
  int _varCounter = 0;

  /// 已声明的变量集合（用于避免变量名冲突）
  final Set<String> _declaredVariables = {};

  /// catch 块中的异常变量名（这些变量是 DartException&，不是 AnyGC*）
  final Set<String> _catchExceptionVars = {};

  /// 变量名映射（用于处理变量名冲突）
  final Map<String, String> _variableNameMappings = {};

  /// 当前作用域中的闭包参数名称（用于解决 # 后缀变量名问题）
  final Set<String> _currentClosureParamNames = {};

  /// 变量类型映射（用于判断变量是否是 AnyGC* 类型）
  final Map<String, String> _variableTypeMap = {};

  /// 枚举常量索引映射：'EnumName.constantName' → index
  final Map<String, int> _enumConstantIndices = {};

  /// 函数返回类型映射：'funcName' → C++ return type
  final Map<String, String> _functionReturnTypes = {};

  /// 闭包计数器
  int _closureCounter = 0;

  /// 已发出的前向声明
  final Set<String> _emittedForwardDecls = {};

  /// 已解析的函数返回类型（函数名 → 返回类型）
  final Map<String, String> _resolvedFuncReturnTypes = {};

  /// 已发出的结构体定义
  final Set<String> _emittedStructs = {};

  /// 当前函数返回类型
  String _currentReturnType = 'void';

  /// 需要 Box 化的变量（被闭包捕获的可变基础类型变量）
  final Set<VariableDeclaration> _boxedVars = {};

  /// 当前闭包 env 中新装箱的值类型捕获变量（需要在创建时用 new BoxType(var) 包装）
  final Set<VariableDeclaration> _envBoxedVars = {};

  /// 当前作用域中所有已装箱的变量（_boxedVars + _envBoxedVars + 外层继承，用于 ->value 访问）
  final Set<VariableDeclaration> _scopeBoxedVars = {};

  /// 当前函数是否为 async 函数
  bool _isAsyncFunction = false;

  /// 当前是否在闭包 trampoline 中生成代码（trampoline 返回 AnyGC*，需要装箱返回值）
  bool _inClosureTrampoline = false;

  /// async 函数体是否已包含 return 语句
  bool _asyncBodyHasReturn = false;

  /// async 函数内部返回类型（Promise<T> 中的 T）
  String _asyncInnerType = 'AnyGC*';

  /// 当前生成器函数的元素类型（sync*/async* 中 StaticList<T> 的 T）
  String? _currentGeneratorInnerType;

  /// 泛型构造函数中期望的集合元素类型（用于将 StaticList<AnyGC*> 替换为正确的类型）
  String? _expectedCollectionElementType;

  /// 泛型构造函数中期望的 Map 键值类型
  String? _expectedMapKeyType;
  String? _expectedMapValueType;

  /// 当前类名
  String _currentClassName = '';

  /// 当前作用域内的模板类型参数名称（用于判断 static_cast 是否可用）
  Set<String> _inScopeTypeParams = {};

  /// 类型提升映射：变量名 -> 提升后的类型（用于 is 检查后的 ClassInfo 派发）
  final Map<String, DartType> _typePromotions = {};

  /// 已清理的名称缓存
  final Map<String, String> _cleanedNames = {};

  /// 所有用户自定义类名集合
  final Set<String> _userClasses = {};

  /// 所有 mixin 名称集合
  final Set<String> _mixinNames = {};

  /// 所有 enum 名称集合
  final Set<String> _enumNames = {};

  /// 类继承关系
  final Map<String, String> _classHierarchy = {};

  /// 类 → 其所有虚方法名列表
  final Map<String, List<_VTableEntry>> _classVTableEntries = {};

  /// 类 → 其 Class AST 节点
  final Map<String, Class> _classNodes = {};

  /// 合成名称集合
  final Set<String> _syntheticLoweredNames = {};

  /// 方法级泛型特化
  final Map<String, Map<String, Set<MethodSpecEntry>>> _methodTypeSpecializations = {};

  /// 检查类（含祖先）是否有对应的 struct 字段（非静态）
  bool _classHasStructField(String className, String fieldName) {
    final cls = _classNodes[className];
    if (cls == null) return false;
    for (final f in cls.fields) {
      if (!f.isStatic && f.name.text == fieldName) return true;
    }
    // 检查祖先类（包括 mixin application 类）
    var ancestor = cls.superclass;
    while (ancestor != null) {
      for (final f in ancestor.fields) {
        if (!f.isStatic && f.name.text == fieldName) return true;
      }
      ancestor = ancestor.superclass;
    }
    return false;
  }

  /// 已生成的方法实现函数名集合（防止重复生成）
  final Set<String> _emittedImplementations = {};

  /// null 命名变量的映射（VariableDeclaration → 生成的名称）
  final Map<VariableDeclaration, String> _nullNamedVarMap = {};

  /// 变量重命名映射（VariableDeclaration → 实际 C++ 名称），用于处理变量名冲突
  final Map<VariableDeclaration, String> _varDeclNameMap = {};

  String get _pad => '    ' * _indent;

  // ==========================================================================
  // 主入口
  // ==========================================================================

  /// 生成 C++ 代码
  String emit(Component component) {
    // 重置所有状态
    _fwdBuf.clear();
    _structBuf.clear();
    _implBuf.clear();
    _mainBuf.clear();
    _emittedForwardDecls.clear();
    _resolvedFuncReturnTypes.clear();
    _emittedStructs.clear();
    _emittedImplementations.clear();
    _userClasses.clear();
    _mixinNames.clear();
    _enumNames.clear();
    _classHierarchy.clear();
    _classVTableEntries.clear();
    _classNodes.clear();
    _syntheticLoweredNames.clear();
    _methodTypeSpecializations.clear();
    _declaredVariables.clear();
    _variableNameMappings.clear();

    // 第一遍：收集类信息（复用 _ClassInfoCollector 的分析逻辑）
    final collector = _ClassInfoCollector();
    for (final lib in component.libraries) {
      final uri = lib.importUri.toString();
      if (uri.startsWith('dart:') || uri.startsWith('package:')) continue;
      collector._collectClassInfo(lib);
    }

    // 复制分析结果
    _userClasses.addAll(collector._userClasses);
    _mixinNames.addAll(collector._mixinNames);
    _enumNames.addAll(collector._enumNames);
    _classHierarchy.addAll(collector._classHierarchy);
    _classVTableEntries.addAll(collector._classVTableEntries);
    _classNodes.addAll(collector._classNodes);
    _syntheticLoweredNames.addAll(collector._syntheticLoweredNames);

    // 第二遍：预扫描泛型特化
    for (final lib in component.libraries) {
      final uri = lib.importUri.toString();
      if (uri.startsWith('dart:') || uri.startsWith('package:')) continue;
      collector._collectMethodTypeSpecializations(lib);
    }
    _methodTypeSpecializations.addAll(collector._methodTypeSpecializations);

    // 第三遍：生成 C++ 代码
    for (final lib in component.libraries) {
      final uri = lib.importUri.toString();
      if (uri.startsWith('dart:') || uri.startsWith('package:')) continue;
      _emitCppLibrary(lib);
    }

    // 组装最终输出
    final result = StringBuffer();
    result.writeln('#include "dart2cpp_lowered.h"');
    result.writeln();

    if (_fwdBuf.isNotEmpty) {
      result.write(_fwdBuf);
      result.writeln();
    }

    if (_structBuf.isNotEmpty) {
      result.write(_structBuf);
      result.writeln();
    }

    if (_implBuf.isNotEmpty) {
      result.write(_implBuf);
    }

    return result.toString();
  }

  // ==========================================================================
  // Library 处理
  // ==========================================================================

  void _emitCppLibrary(Library lib) {
    // 前向声明所有用户类（包括模板参数）
    for (final cls in lib.classes) {
      if (cls.isMixinDeclaration) {
        final cleanMixin = _cleanName(cls.name);
        final mixinTypeParams = cls.typeParameters;
        if (mixinTypeParams.isNotEmpty) {
          final mixinTemplateDecl = 'template<${mixinTypeParams.map((tp) => 'typename ${tp.name ?? 'T'}').join(', ')}>';
          _addForwardDecl('$mixinTemplateDecl struct ${cleanMixin}Mixin');
        } else {
          _addForwardDecl('${cleanMixin}Mixin');
        }
        continue;
      }
      if (_isEnumClass(cls)) continue;
      final name = _cleanName(cls.name);
      if (_syntheticLoweredNames.contains(cls.name)) continue;
      if (cls.name.contains('&')) continue;
      if (_userClasses.contains(cls.name)) {
        final typeParams = cls.typeParameters;
        if (typeParams.isNotEmpty) {
          final templateDecl = 'template<${typeParams.map((tp) => 'typename ${tp.name ?? 'T'}').join(', ')}>';
          _addForwardDecl('$templateDecl struct ${name}Value');
        } else {
          _addForwardDecl('struct ${name}Value');
        }
      }
    }

    // 处理枚举
    for (final cls in lib.classes) {
      if (_isEnumClass(cls)) {
        _emitCppEnum(cls);
      }
    }

    // 处理 Mixin
    for (final cls in lib.classes) {
      if (cls.isMixinDeclaration) {
        _emitCppMixin(cls);
      }
    }

    // 为所有类的方法生成前向声明（在类定义之前）
    for (final cls in lib.classes) {
      if (cls.isMixinDeclaration) continue;
      if (_isEnumClass(cls)) continue;
      if (cls.name.contains('&') || cls.isMixinApplication) continue;
      _emitCppMethodForwardDecls(cls);
    }

    // 为缺失的 lowered 方法生成前向声明（确保 wrapper 可以查找签名）
    // 先生成顶层函数的前向声明（这些包含 lowered 方法的实际签名）
    for (final proc in lib.procedures) {
      final funcName = _cleanName(proc.name.text);
      if (_emittedForwardDecls.contains(funcName) ||
          _emittedForwardDecls.any((decl) => decl.contains('$funcName('))) {
        continue;
      }
      _emitCppProcedureForwardDecl(proc);
    }
    for (final cls in lib.classes) {
      if (cls.isMixinDeclaration) continue;
      if (_isEnumClass(cls)) continue;
      if (cls.name.contains('&') || cls.isMixinApplication) continue;
      _emitMissingMethodForwardDecls(cls);
    }

    // 处理类（按继承关系拓扑排序，确保父类在子类之前定义）
    final sortedClasses = _topologicalSortClasses(
      lib.classes.where((cls) =>
        !cls.isMixinDeclaration &&
        !_isEnumClass(cls) &&
        !cls.name.contains('&') &&
        !cls.isMixinApplication &&
        !_isRuntimeClass(cls)).toList(),
    );
    for (final cls in sortedClasses) {
      _emitCppClass(cls);
    }

    // 处理顶层函数
    for (final proc in lib.procedures) {
      _emitCppProcedure(proc);
    }

    // 处理顶层字段
    for (final field in lib.fields) {
      if (field.isStatic) {
        _emitCppTopLevelField(field);
      }
    }

    // 为所有类生成缺失的 lowered 方法（这些方法在 lowered Dart 中是顶层函数）
    for (final cls in lib.classes) {
      if (cls.isMixinDeclaration) continue;
      if (_isEnumClass(cls)) continue;
      if (cls.name.contains('&') || cls.isMixinApplication) continue;
      final name = cls.name;
      if (_syntheticLoweredNames.contains(name)) continue;
      _emitMissingLoweredMethods(cls);
    }
  }

  /// 检查方法体是否包含 SuperMethodInvocation
  bool _bodyContainsSuperCall(Statement body) {
    bool found = false;
    void check(TreeNode node) {
      if (found) return;
      if (node is SuperMethodInvocation) {
        found = true;
        return;
      }
      if (node is Block) {
        for (final s in node.statements) check(s);
      } else if (node is ExpressionStatement) {
        check(node.expression);
      } else if (node is ReturnStatement && node.expression != null) {
        check(node.expression!);
      } else if (node is IfStatement) {
        check(node.condition);
        check(node.then);
        if (node.otherwise != null) check(node.otherwise!);
      } else if (node is ForStatement) {
        for (final v in node.variables) check(v);
        if (node.condition != null) check(node.condition!);
        for (final u in node.updates) check(u);
        check(node.body);
      } else if (node is WhileStatement) {
        check(node.condition);
        check(node.body);
      } else if (node is VariableDeclaration && node.initializer != null) {
        check(node.initializer!);
      } else if (node is TryCatch) {
        check(node.body);
        for (final c in node.catches) check(c.body);
      } else if (node is TryFinally) {
        check(node.body);
        check(node.finalizer);
      } else if (node is LabeledStatement) {
        check(node.body);
      } else if (node is YieldStatement && node.expression != null) {
        check(node.expression!);
      } else if (node is InstanceInvocation) {
        check(node.receiver);
        for (final a in node.arguments.positional) check(a);
      } else if (node is StaticInvocation) {
        for (final a in node.arguments.positional) check(a);
      } else if (node is InstanceGet) {
        check(node.receiver);
      } else if (node is InstanceSet) {
        check(node.receiver);
        check(node.value);
      } else if (node is VariableSet) {
        check(node.value);
      } else if (node is ConditionalExpression) {
        check(node.condition);
        check(node.then);
        check(node.otherwise);
      } else if (node is LogicalExpression) {
        check(node.left);
        check(node.right);
      } else if (node is Not) {
        check(node.operand);
      } else if (node is StringConcatenation) {
        for (final e in node.expressions) check(e);
      } else if (node is AsExpression) {
        check(node.operand);
      } else if (node is IsExpression) {
        check(node.operand);
      } else if (node is NullCheck) {
        check(node.operand);
      } else if (node is AwaitExpression) {
        check(node.operand);
      } else if (node is ListLiteral) {
        for (final e in node.expressions) check(e);
      } else if (node is MapLiteral) {
        for (final entry in node.entries) {
          check(entry.key);
          check(entry.value);
        }
      } else if (node is Throw) {
        check(node.expression);
      } else if (node is FunctionInvocation) {
        check(node.receiver);
        for (final a in node.arguments.positional) check(a);
      } else if (node is BlockExpression) {
        check(node.body);
        check(node.value);
      }
    }
    check(body);
    return found;
  }

  /// 将 AnyGC* 转换为 C++ 类型的表达式
  String _anyPtrToCppExpr(String expr, String cppType) {
    switch (cppType) {
      case 'int64_t':
        return 'dynAs<int64_t>($expr)';
      case 'double':
        return 'dynAs<double>($expr)';
      case 'bool':
        return 'dynAs<bool>($expr)';
      case 'DartString':
        return 'dynAs<DartString>($expr)';
      default:
        if (cppType.endsWith('*')) {
          return 'reinterpret_cast<$cppType>($expr)';
        }
        return expr;
    }
  }

  /// 为类生成缺失的 lowered 方法
  /// 这些方法在 lowered Dart 中是顶层函数，但可能不在 lib.procedures 中
  void _emitMissingLoweredMethods(Class cls) {
    final className = _cleanName(cls.name);

    // 获取类的所有虚方法
    final vtableEntries = _classVTableEntries[className] ?? [];

    for (final entry in vtableEntries) {
      final methodName = _cleanMethodName(entry.name);
      // 根据方法类型构建函数名
      String funcName;
      if (entry.kind == 'getter') {
        funcName = '${className}_get_$methodName';
      } else if (entry.kind == 'setter') {
        funcName = '${className}_set_$methodName';
      } else {
        funcName = '${className}_$methodName';
      }

      // 跳过已经生成实现的方法
      if (_emittedImplementations.contains(funcName)) {
        continue;
      }

      // 如果方法在 cls.procedures 中，_emitCppMethod 会在后续阶段生成实现
      // 这里只处理不在 cls.procedures 中的 "缺失" 方法（如从 mixin 继承的方法）
      final hasMatchingProc = cls.procedures.any((p) {
        final pn = _cleanMethodName(p.name.text);
        if (pn != methodName) return false;
        if (entry.kind == 'getter') return p.isGetter;
        if (entry.kind == 'setter') return p.isSetter;
        return !p.isGetter && !p.isSetter;
      });
      if (hasMatchingProc) {
        continue; // 实现将在 _emitCppMethod 中生成
      }

      // 检查是否是 getter 或 setter
      final isGetter = entry.kind == 'getter';
      final isSetter = entry.kind == 'setter';

      // 确定返回类型
      String returnType;
      if (isGetter) {
        // 尝试从字段获取类型
        Field? field;
        try {
          field = cls.fields.firstWhere(
            (f) => f.name.text == entry.name || f.name.text == '_${entry.name}',
          );
        } catch (_) {
          field = null;
        }

        if (field != null) {
          returnType = _cppType(field.type);
        } else {
          returnType = 'AnyGC*'; // 默认返回类型
        }
      } else if (isSetter) {
        returnType = 'void';
      } else {
        if (entry.proc != null &&
            _cppType(entry.proc!.function.returnType) == 'void') {
          returnType = 'void';
        } else {
          returnType = 'AnyGC*';
        }
      }

      // 收集参数 - 使用具体结构体类型而非 AnyPtr
      final clsTypeParams = cls.typeParameters;
      // 运行时类使用类名本身（如 Promise），用户类使用 ClassNameValue
      final structName = _isRuntimeClassName(className) ? className : '${className}Value';
      final structTemplateArgs = clsTypeParams.isNotEmpty
          ? '<${clsTypeParams.map((tp) => tp.name ?? 'T').join(', ')}>'
          : '';
      final params = <String>['$structName$structTemplateArgs* this_'];
      if (isSetter) {
        params.add('AnyGC* value');
      }

      // 对于普通方法，从 entry.proc 获取额外参数
      final classParamNames = clsTypeParams.map((tp) => tp.name ?? 'T').toSet();
      final extraParams = <String>[];
      final methodTypeParamNames = <String>[];
      if (!isGetter && !isSetter && entry.proc != null) {
        final funcNode = entry.proc!.function;

        // 收集方法级类型参数
        for (final tp in funcNode.typeParameters) {
          final tpName = tp.name ?? 'T';
          if (!classParamNames.contains(tpName)) {
            methodTypeParamNames.add(tpName);
          }
        }

        // 构建类型参数替换映射（将父类的模板参数替换为具体类型）
        final typeSubstitutions = <String, String>{};
        final superClass = cls.superclass;
        if (superClass != null && superClass.typeParameters.isNotEmpty) {
          final clsNode = _classNodes[cls.name];
          if (clsNode != null && clsNode.supertype != null && clsNode.supertype!.typeArguments.isNotEmpty) {
            for (int i = 0; i < superClass.typeParameters.length && i < clsNode.supertype!.typeArguments.length; i++) {
              final paramName = superClass.typeParameters[i].name ?? 'T';
              final concreteType = _cppType(clsNode.supertype!.typeArguments[i]);
              typeSubstitutions[paramName] = concreteType;
            }
          }
        }
        // classParamNames 已在外部声明，这里直接使用

        for (final p in funcNode.positionalParameters) {
          var paramType = _cppType(p.type);
          // 替换已知的类型参数
          for (final entry in typeSubstitutions.entries) {
            paramType = paramType.replaceAll(RegExp('\\b${entry.key}\\b'), entry.value);
          }
          // 对于未解析的模板类型参数（非当前类的，也非方法级的），使用 AnyPtr
          if (!classParamNames.contains(paramType) &&
              !methodTypeParamNames.contains(paramType) &&
              _isTemplateTypeParam(paramType)) {
            paramType = 'AnyGC*';
          }
          // 替换复合类型中未解析的类型参数（如 TypeFunction1<R, T>* 中的 R → AnyPtr）
          paramType = _replaceUnresolvedTypeParamsInComposite(paramType, classParamNames, methodTypeParamNames.toSet());
          final paramName = _cleanName(p.name ?? 'p${params.length}');
          params.add('$paramType $paramName');
          extraParams.add(paramName);
        }

        // 收集命名参数
        for (final p in funcNode.namedParameters) {
          var paramType = _cppType(p.type);
          // 替换已知的类型参数
          for (final entry in typeSubstitutions.entries) {
            paramType = paramType.replaceAll(RegExp('\\b${entry.key}\\b'), entry.value);
          }
          if (!classParamNames.contains(paramType) &&
              !methodTypeParamNames.contains(paramType) &&
              _isTemplateTypeParam(paramType)) {
            paramType = 'AnyGC*';
          }
          // 替换复合类型中未解析的类型参数
          paramType = _replaceUnresolvedTypeParamsInComposite(paramType, classParamNames, methodTypeParamNames.toSet());
          final paramName = _cleanName(p.name ?? 'p${params.length}');
          params.add('$paramType $paramName');
          extraParams.add(paramName);
        }
      }

      // 检查返回类型是否使用了类的模板参数
      // 合并类级和方法级类型参数
      final allTypeParams = <String>[
        ...clsTypeParams.map((tp) => 'typename ${tp.name ?? 'T'}'),
        ...methodTypeParamNames.map((name) => 'typename $name'),
      ];
      final templateDecl = allTypeParams.isNotEmpty
          ? 'template<${allTypeParams.join(', ')}>'
          : '';

      // 生成前向声明
      final fwdStr = templateDecl.isNotEmpty
          ? '$templateDecl $returnType $funcName(${params.join(', ')})'
          : '$returnType $funcName(${params.join(', ')})';
      _addForwardDecl(fwdStr);

      // 生成函数实现
      final implTemplateDecl = templateDecl.isNotEmpty ? '$templateDecl\n' : '';
      _implBuf.writeln('$implTemplateDecl$returnType $funcName(${params.join(', ')}) {');
      _indent = 1;

      // 检查是否有父类方法可以调用
      final superClass = cls.superclass;
      // 解析父类名称 — 合成名（含 &）需要通过 _classHierarchy 解析到真实父类
      String superName = superClass?.name ?? '';
      if (superName.contains('&')) {
        final sanitized = _sanitizeSyntheticName(superName);
        var resolved = _classHierarchy[sanitized] ?? '';
        while (resolved.isNotEmpty && _syntheticLoweredNames.contains(resolved)) {
          final next = _classHierarchy[resolved];
          if (next == null || next == 'Object') { resolved = ''; break; }
          resolved = next;
        }
        superName = resolved;
      }
      // 检查方法是否来自父类（而非 mixin）
      final declaringClass = entry.declaringClassName ?? '';
      final methodFromSuperClass = declaringClass.isEmpty ||
          _cleanName(declaringClass) == superName;
      if (superClass != null && superName.isNotEmpty && _userClasses.contains(superName) && !_syntheticLoweredNames.contains(superName) && methodFromSuperClass) {
        // 为 getter/setter 添加 get_/set_ 前缀
        String prefixedMethodName;
        if (isGetter) {
          prefixedMethodName = 'get_$methodName';
        } else if (isSetter) {
          prefixedMethodName = 'set_$methodName';
        } else {
          prefixedMethodName = methodName;
        }
        final superMethodName = '${superName}_$prefixedMethodName';
        // 如果父类也是模板类，需要传递模板参数
        final superTypeParams = superClass.typeParameters;
        String superTemplateArgs = '';
        if (superTypeParams.isNotEmpty) {
          // 优先使用 supertype 的实际类型参数（正确处理 ChainedTransformer<A,B,C> extends DataTransformer<A,C> 的情况）
          final clsNode = _classNodes[cls.name];
          if (clsNode != null && clsNode.supertype != null && clsNode.supertype!.typeArguments.isNotEmpty) {
            final args = clsNode.supertype!.typeArguments.map((t) => _cppType(t)).join(', ');
            superTemplateArgs = '<$args>';
          } else if (clsTypeParams.isNotEmpty) {
            // 回退：使用当前类的模板参数（截取与父类参数数量相同的个数）
            superTemplateArgs = '<${clsTypeParams.take(superTypeParams.length).map((tp) => tp.name ?? 'T').join(', ')}>';
          } else {
            // 回退：使用 AnyPtr
            superTemplateArgs = '<${superTypeParams.map((_) => 'AnyGC*').join(', ')}>';
          }
        }
        // Compute method type params separately — needed because method type params
        // are no longer deducible after making closures return AnyGC*
        String methodTemplateArgs = '';
        if (!isGetter && !isSetter && entry.proc != null) {
          final methodTypeParams = entry.proc!.function.typeParameters.map((tp) => tp.name ?? 'T').toList();
          if (methodTypeParams.isNotEmpty) {
            methodTemplateArgs = methodTypeParams.join(', ');
          }
        }
        // Build function call template args (class + method params)
        String funcTemplateArgs = superTemplateArgs;
        if (methodTemplateArgs.isNotEmpty) {
          if (funcTemplateArgs.isNotEmpty) {
            funcTemplateArgs = '${funcTemplateArgs.substring(0, funcTemplateArgs.length - 1)}, $methodTemplateArgs>';
          } else {
            funcTemplateArgs = '<$methodTemplateArgs>';
          }
        }
        final superCall = '$superMethodName$funcTemplateArgs';
        // static_cast only uses class template args (struct has class params only, not method params)
        final superStructName = _isRuntimeClassName(superName)
            ? superName
            : '${superName}Value';
        String thisArg;
        if (superTemplateArgs.isNotEmpty && clsTypeParams.isEmpty) {
          thisArg = 'static_cast<$superStructName$superTemplateArgs*>(this_)';
        } else if (superTemplateArgs.isNotEmpty) {
          thisArg = 'static_cast<$superStructName$superTemplateArgs*>(this_)';
        } else {
          thisArg = 'this_';
        }
        final extraArgsStr = extraParams.isNotEmpty ? ', ${extraParams.join(', ')}' : '';
        if (isGetter) {
          if (returnType == 'AnyGC*') {
            _implBuf.writeln('${_pad}return _box($superCall($thisArg));');
          } else {
            _implBuf.writeln('${_pad}return $superCall($thisArg);');
          }
        } else if (isSetter) {
          _implBuf.writeln('${_pad}$superCall($thisArg, value);');
        } else {
          // 检查父类方法是否返回 void
          final superProc = superClass.procedures.where((p) => p.name.text == entry.name && !p.isGetter && !p.isSetter).toList();
          final superReturnsVoid = superProc.isNotEmpty && _cppType(superProc.first.function.returnType) == 'void';
          if (superReturnsVoid) {
            _implBuf.writeln('${_pad}$superCall($thisArg$extraArgsStr);');
            if (returnType != 'void') {
              _implBuf.writeln('${_pad}return nullptr;');
            }
          } else {
            // 如果当前函数返回 AnyGC* 但父类方法返回具体类型，需要包装
            if (returnType == 'AnyGC*') {
              _implBuf.writeln('${_pad}return _box($superCall($thisArg$extraArgsStr));');
            } else {
              _implBuf.writeln('${_pad}return $superCall($thisArg$extraArgsStr);');
            }
          }
        }
      } else if (entry.proc != null && entry.proc!.function.body != null &&
                 !_bodyContainsSuperCall(entry.proc!.function.body!)) {
        // 从 proc 直接生成方法体（如 mixin 继承的方法）
        final savedVarNameMappings = Map<String, String>.from(_variableNameMappings);
        final savedVariableTypeMap = Map<String, String>.from(_variableTypeMap);
        final savedDeclaredVariables = Set<String>.from(_declaredVariables);
        final savedClassName = _currentClassName;
        final savedReturnType = _currentReturnType;
        final savedAsync = _isAsyncFunction;
        final savedAsyncHasReturn = _asyncBodyHasReturn;
        final savedAsyncInnerType = _asyncInnerType;
        final savedInScopeTypeParams = _inScopeTypeParams;
        final savedIndent = _indent;
        _variableNameMappings.clear();
        _declaredVariables.clear();

        // 设置参数变量名映射
        final funcNode = entry.proc!.function;

        // 检测 async 方法
        final isAsync = funcNode.asyncMarker == AsyncMarker.Async;
        _isAsyncFunction = isAsync;
        _asyncBodyHasReturn = false;
        if (isAsync) {
          _asyncInnerType = _extractPromiseInnerType(funcNode.returnType);
        }
        _currentClassName = className;
        _currentReturnType = returnType;
        _inScopeTypeParams = clsTypeParams.map((tp) => tp.name ?? 'T').toSet();

        final allParams = <VariableDeclaration>[
          ...funcNode.positionalParameters,
          ...funcNode.namedParameters,
        ];
        for (int i = 0; i < extraParams.length && i < allParams.length; i++) {
          final dartName = _cleanName(allParams[i].name ?? 'p$i');
          _variableNameMappings[dartName] = extraParams[i];
          _variableTypeMap[dartName] = _cppType(allParams[i].type);
        }

        // setter 参数需要从 AnyGC* 转换为字段类型
        if (isSetter && funcNode.positionalParameters.isNotEmpty) {
          final setterParam = funcNode.positionalParameters.first;
          final fieldType = _cppType(setterParam.type);
          final dartParamName = _cleanName(setterParam.name ?? 'value');
          final convertedExpr = _anyPtrToCppExpr('value', fieldType);
          _implBuf.writeln('${_pad}auto _setter_value = $convertedExpr;');
          _variableNameMappings[dartParamName] = '_setter_value';
        }

        // async 方法：创建 Promise 包装
        if (isAsync) {
          _implBuf.writeln('${_pad}auto _promise = GC::allocateLocal(new Promise<$_asyncInnerType>());');
        }

        // 生成方法体
        final bodyBuf = StringBuffer();
        _emitCppStmtToBuffer(funcNode.body!, bodyBuf);
        _implBuf.write(bodyBuf);

        // async 方法：如果函数体没有 return，添加兜底 complete 和 return
        if (isAsync && !_asyncBodyHasReturn) {
          if (_asyncInnerType == 'int') {
            _implBuf.writeln('${_pad}promise_completeTyped(_promise, 0);');
          } else {
            _implBuf.writeln('${_pad}promise_complete(_promise, nullptr);');
          }
          _implBuf.writeln('${_pad}return _promise;');
        }

        // 恢复上下文
        _variableNameMappings
          ..clear()
          ..addAll(savedVarNameMappings);
        _variableTypeMap
          ..clear()
          ..addAll(savedVariableTypeMap);
        _declaredVariables
          ..clear()
          ..addAll(savedDeclaredVariables);
        _currentClassName = savedClassName;
        _currentReturnType = savedReturnType;
        _isAsyncFunction = savedAsync;
        _asyncBodyHasReturn = savedAsyncHasReturn;
        _asyncInnerType = savedAsyncInnerType;
        _inScopeTypeParams = savedInScopeTypeParams;
        _indent = savedIndent;
      } else {
        // 没有父类方法且无方法体，返回默认值
        if (returnType != 'void') {
          final defaultReturn = _cppDefaultValue(returnType);
          if (defaultReturn.isEmpty && isGetter) {
            // 模板类型参数的 getter — 生成 return this_->fieldName;
            _implBuf.writeln('${_pad}return this_->$methodName;');
          } else {
            _implBuf.writeln('${_pad}return $defaultReturn;');
          }
        }
      }

      _implBuf.writeln('}\n');
      _indent = 0;
    }
  }

  /// 为缺失的 lowered 方法生成前向声明（仅声明，不实现）
  /// 确保 _emitVptrWrappers 可以查找实际函数的参数类型
  void _emitMissingMethodForwardDecls(Class cls) {
    final className = _cleanName(cls.name);
    final vtableEntries = _classVTableEntries[className] ?? [];
    final clsTypeParams = cls.typeParameters;
    final structName = _isRuntimeClassName(className) ? className : '${className}Value';
    final structTemplateArgs = clsTypeParams.isNotEmpty
        ? '<${clsTypeParams.map((tp) => tp.name ?? 'T').join(', ')}>'
        : '';
    final templateDecl = clsTypeParams.isNotEmpty
        ? 'template<${clsTypeParams.map((tp) => 'typename ${tp.name ?? 'T'}').join(', ')}>'
        : '';

    for (final entry in vtableEntries) {
      final methodName = _cleanMethodName(entry.name);
      String funcName;
      if (entry.kind == 'getter') {
        // 从 staticFuncName 提取类名
        final parts = entry.staticFuncName.split('_get_');
        if (parts.length == 2) {
          funcName = '${_cleanName(parts[0])}_get_$methodName';
        } else {
          funcName = '${className}_get_$methodName';
        }
      } else if (entry.kind == 'setter') {
        final parts = entry.staticFuncName.split('_set_');
        if (parts.length == 2) {
          funcName = '${_cleanName(parts[0])}_set_$methodName';
        } else {
          funcName = '${className}_set_$methodName';
        }
      } else {
        // 从 staticFuncName 提取类名
        final suffix = '_$methodName';
        if (entry.staticFuncName.endsWith(suffix)) {
          final classPart = entry.staticFuncName.substring(0, entry.staticFuncName.length - suffix.length);
          funcName = '${_cleanName(classPart)}_$methodName';
        } else {
          funcName = '${className}_$methodName';
        }
      }

      // 跳过已有的前向声明或实现
      if (_emittedForwardDecls.contains(funcName) ||
          _emittedForwardDecls.any((decl) => decl.contains('$funcName(')) ||
          _emittedImplementations.contains(funcName)) {
        continue;
      }

      // 使用 _emitMissingLoweredMethods 中相同的逻辑确定返回类型和参数
      final isGetter = entry.kind == 'getter';
      final isSetter = entry.kind == 'setter';

      String returnType;
      if (isGetter) {
        Field? field;
        try {
          field = cls.fields.firstWhere(
            (f) => f.name.text == entry.name || f.name.text == '_${entry.name}',
          );
        } catch (_) { field = null; }
        returnType = field != null ? _cppType(field.type) : 'AnyGC*';
      } else if (isSetter) {
        returnType = 'void';
      } else {
        if (entry.proc != null &&
            _cppType(entry.proc!.function.returnType) == 'void') {
          returnType = 'void';
        } else {
          returnType = 'AnyGC*';
        }
      }

      final params = <String>['$structName$structTemplateArgs* this_'];
      if (isSetter) {
        params.add('AnyGC* value');
      } else if (!isGetter && entry.proc != null) {
        final funcNode = entry.proc!.function;
        for (final p in funcNode.positionalParameters) {
          params.add('${_cppType(p.type)} ${_cleanName(p.name ?? 'p${params.length}')}');
        }
      }

      // 跳过包含未解析类型参数的前向声明（由 _emitCppProcedureForwardDecl 处理）
      final classTypeParamNames = clsTypeParams.map((tp) => tp.name ?? 'T').toSet();
      bool hasUnresolved = _isCppTypeParameter(returnType) && !classTypeParamNames.contains(returnType);
      if (!hasUnresolved) {
        for (final p in params) {
          final lastSpace = p.lastIndexOf(' ');
          final type = lastSpace > 0 ? p.substring(0, lastSpace).trim() : p;
          if (_isCppTypeParameter(type) && !classTypeParamNames.contains(type)) {
            hasUnresolved = true;
            break;
          }
          if (_containsUnresolvedTypeParam(type, classTypeParamNames)) {
            hasUnresolved = true;
            break;
          }
        }
      }
      // 对于包含未解析类型参数（方法级）的前向声明，使用组合的类型参数列表
      if (hasUnresolved && entry.proc != null) {
        final methodTypeParams = entry.proc!.function.typeParameters;
        final allTypeParams = _deduplicateTypeParams([...clsTypeParams, ...methodTypeParams]);
        // 如果类不是泛型的且方法也没有类型参数，跳过（使用 AnyGC* 作为后备）
        if (allTypeParams.isEmpty) {
          continue;
        }
        final combinedTemplateDecl = allTypeParams.isNotEmpty
            ? 'template<${allTypeParams.map((tp) => 'typename ${tp.name ?? 'T'}').join(', ')}>'
            : '';
        // 应用类型替换（从父类/接口的类型参数映射）
        final typeSubstitution = _buildTypeSubstitutionMap(cls);
        final substitutedParams = params.map((p) {
          final lastSpace = p.lastIndexOf(' ');
          if (lastSpace <= 0) return p;
          final type = p.substring(0, lastSpace).trim();
          final name = p.substring(lastSpace + 1);
          final substitutedType = _applyTypeSubstitution(type, typeSubstitution);
          return '$substitutedType $name';
        }).toList();
        final substitutedReturnType = _applyTypeSubstitution(returnType, typeSubstitution);
        final fwdDecl = combinedTemplateDecl.isNotEmpty
            ? '$combinedTemplateDecl $substitutedReturnType $funcName(${substitutedParams.join(', ')})'
            : '$substitutedReturnType $funcName(${substitutedParams.join(', ')})';
        _addForwardDecl(fwdDecl);
        continue;
      }
      if (hasUnresolved) continue;

      final fwdDecl = templateDecl.isNotEmpty
          ? '$templateDecl $returnType $funcName(${params.join(', ')})'
          : '$returnType $funcName(${params.join(', ')})';
      _addForwardDecl(fwdDecl);
    }
  }

  /// 为类的所有方法生成前向声明
  void _emitCppMethodForwardDecls(Class cls) {
    final className = _cleanName(cls.name);
    // 运行时类使用类名本身（如 Promise），用户类使用 ClassNameValue
    final structName = _isRuntimeClassName(className) ? className : '${className}Value';

    // 检查是否是模板类
    final typeParams = cls.typeParameters;
    final hasTemplate = typeParams.isNotEmpty;
    final templateDecl = hasTemplate
        ? 'template<${typeParams.map((tp) => 'typename ${tp.name ?? 'T'}').join(', ')}>'
        : '';
    final templateArgs = hasTemplate
        ? '<${typeParams.map((tp) => tp.name ?? 'T').join(', ')}>'
        : '';

    // 构造函数前向声明
    for (final ctor in cls.constructors) {
      final ctorName = ctor.name.text.isEmpty ? 'new' : 'new_${_cleanName(ctor.name.text)}';
      final funcName = '${className}_$ctorName';
      final func = ctor.function;

      final params = <String>['$structName$templateArgs* this_'];
      final requiredCount = func.requiredParameterCount;
      for (var i = 0; i < func.positionalParameters.length; i++) {
        final param = func.positionalParameters[i];
        final paramType = _cppType(param.type);
        final paramName = _cleanName(param.name ?? 'p${params.length}');
        if (i >= requiredCount && param.initializer != null) {
          final defaultValue = _convertNullToType(_emitCppExpr(param.initializer!), paramType);
          params.add('$paramType $paramName = $defaultValue');
        } else {
          params.add('$paramType $paramName');
        }
      }

      // 收集命名参数
      for (final param in func.namedParameters) {
        final paramType = _cppType(param.type);
        final paramName = _cleanName(param.name ?? 'p${params.length}');
        // 如果有默认值，添加默认值
        if (param.initializer != null) {
          final defaultValue = _convertNullToType(_emitCppExpr(param.initializer!), paramType);
          params.add('$paramType $paramName = $defaultValue');
        } else {
          params.add('$paramType $paramName');
        }
      }

      final fwdDecl = templateDecl.isNotEmpty
          ? '$templateDecl $structName$templateArgs* $funcName(${params.join(', ')})'
          : '$structName* $funcName(${params.join(', ')})';
      _addForwardDecl(fwdDecl);
    }

    // 方法前向声明
    for (final proc in cls.procedures) {
      // 工厂构造函数特殊处理
      if (proc.isFactory) {
        final factoryName = proc.name.text;
        final funcName = factoryName.isEmpty
            ? '${className}_new'
            : '${className}_new_${_cleanName(factoryName)}';
        final func = proc.function;

        // 返回类型为类实例指针
        String returnType = '$structName$templateArgs*';

        final params = <String>[];
        final factoryRequiredCount = func.requiredParameterCount;
        for (var i = 0; i < func.positionalParameters.length; i++) {
          final param = func.positionalParameters[i];
          final paramType = _cppType(param.type);
          final paramName = _cleanName(param.name ?? 'p${params.length}');
          if (i >= factoryRequiredCount && param.initializer != null) {
            final defaultValue = _convertNullToType(_emitCppExpr(param.initializer!), paramType);
            params.add('$paramType $paramName = $defaultValue');
          } else {
            params.add('$paramType $paramName');
          }
        }
        // 收集命名参数
        for (final param in func.namedParameters) {
          final paramType = _cppType(param.type);
          final paramName = _cleanName(param.name ?? 'p${params.length}');
          if (param.initializer != null) {
            final defaultValue = _convertNullToType(_emitCppExpr(param.initializer!), paramType);
            params.add('$paramType $paramName = $defaultValue');
          } else {
            params.add('$paramType $paramName');
          }
        }

        final fwdDecl = templateDecl.isNotEmpty
            ? '$templateDecl $returnType $funcName(${params.join(', ')})'
            : '$returnType $funcName(${params.join(', ')})';
        _addForwardDecl(fwdDecl);
        continue;
      }

      final methodName = _cleanMethodName(proc.name.text);
      // 根据方法类型确定函数名
      String funcName;
      if (proc.isGetter) {
        funcName = '${className}_get_$methodName';
      } else if (proc.isSetter) {
        funcName = '${className}_set_$methodName';
      } else {
        funcName = '${className}_$methodName';
      }
      final func = proc.function;

      String returnType;
      if (proc.isGetter) {
        returnType = _cppType(func.returnType);
      } else if (proc.isSetter) {
        returnType = 'void';
      } else {
        returnType = _cppType(func.returnType);
      }

      // 如果返回类型是模板类本身，需要添加模板参数
      if (hasTemplate && returnType == '$structName*') {
        returnType = '$structName$templateArgs*';
      }

      final params = <String>[];
      if (!proc.isStatic) {
        params.add('$structName$templateArgs* this_');
      }

      for (final param in func.positionalParameters) {
        final paramType = _cppType(param.type);
        final paramName = _cleanName(param.name ?? 'p${params.length}');
        params.add('$paramType $paramName');
      }

      // 收集命名参数
      for (final param in func.namedParameters) {
        final paramType = _cppType(param.type);
        final paramName = _cleanName(param.name ?? 'p${params.length}');
        params.add('$paramType $paramName');
      }

      // 合并类和方法的类型参数（按 name 去重）
      final methodTypeParams = func.typeParameters;
      final allTypeParams = _deduplicateTypeParams([...typeParams, ...methodTypeParams]);
      final combinedTemplateDecl = allTypeParams.isNotEmpty
          ? 'template<${allTypeParams.map((tp) => 'typename ${tp.name ?? 'T'}').join(', ')}>'
          : '';

      // 跳过包含未解析类型参数的前向声明（由 _emitCppProcedureForwardDecl 提供正确版本）
      final allTypeParamNames = allTypeParams.map((tp) => tp.name ?? 'T').toSet();
      bool hasUnresolved = false;
      if (_isCppTypeParameter(returnType) && !allTypeParamNames.contains(returnType)) {
        hasUnresolved = true;
      }
      if (!hasUnresolved) {
        for (final p in params) {
          // 提取完整类型（去掉参数名，保留模板参数部分）
          final lastSpace = p.lastIndexOf(' ');
          final type = lastSpace > 0 ? p.substring(0, lastSpace).trim() : p;
          // 检查裸类型参数
          if (_isCppTypeParameter(type) && !allTypeParamNames.contains(type)) {
            hasUnresolved = true;
            break;
          }
          // 检查复合类型中的类型参数（如 TypeFunction1<R, T>*）
          if (_containsUnresolvedTypeParam(type, allTypeParamNames)) {
            hasUnresolved = true;
            break;
          }
        }
      }
      if (hasUnresolved) continue;

      _resolvedFuncReturnTypes[funcName] = returnType;

      final fwdDecl = combinedTemplateDecl.isNotEmpty
          ? '$combinedTemplateDecl $returnType $funcName(${params.join(', ')})'
          : '$returnType $funcName(${params.join(', ')})';
      _addForwardDecl(fwdDecl);
    }
  }

  // ==========================================================================
  // 类处理
  // ==========================================================================

  void _emitCppClass(Class cls) {
    final className = cls.name.contains('&')
        ? _sanitizeSyntheticName(cls.name)
        : cls.name;
    final cleanClassName = _cleanName(className);
    final structName = _isRuntimeClassName(className) ? cleanClassName : '${cleanClassName}Value';

    if (!_emittedStructs.add(structName)) return;

    // 收集类型参数
    final typeParams = cls.typeParameters;
    final hasTemplate = typeParams.isNotEmpty;
    final templatePrefix = hasTemplate
        ? 'template<${typeParams.map((tp) => 'typename ${tp.name ?? 'T'}').join(', ')}>\n'
        : '';

    // 收集字段（包括以下划线开头的字段）
    final fields = <Field>[];
    final fieldNames = <String>{};
    for (final field in cls.fields) {
      if (!field.isStatic) {
        fields.add(field);
        fieldNames.add(field.name.text);
      }
    }

    // Also collect fields from mixin application classes in the hierarchy
    // (these are synthetic intermediate classes that hold mixin fields)
    if (cls.superclass != null) {
      var ancestor = cls.superclass;
      while (ancestor != null) {
        final ancestorName = ancestor.name;
        if (_syntheticLoweredNames.contains(ancestorName) || ancestorName.contains('&')) {
          // This is a mixin application class — collect its fields
          for (final field in ancestor.fields) {
            if (!field.isStatic && !fieldNames.contains(field.name.text)) {
              fields.add(field);
              fieldNames.add(field.name.text);
            }
          }
        }
        ancestor = ancestor.superclass;
      }
    }

    // 收集方法
    final methods = <Procedure>[];
    for (final proc in cls.procedures) {
      methods.add(proc);
    }

    // 收集构造函数
    final constructors = <Constructor>[];
    for (final ctor in cls.constructors) {
      constructors.add(ctor);
    }

    // 确定父类
    final superClass = cls.superclass;
    String superName;
    if (superClass != null) {
      // 合成 mixin 中间类的名称需要 sanitize（将 & 替换为 _）
      final superClassName = superClass.name.contains('&')
          ? _sanitizeSyntheticName(superClass.name)
          : superClass.name;

      // 对于合成 mixin 中间类，找到真正的基类（非合成类）
      String? realBaseClassName = superClassName;
      while (realBaseClassName != null && _syntheticLoweredNames.contains(realBaseClassName)) {
        // 查找这个合成类的父类
        final parentOfSynthetic = _classHierarchy[realBaseClassName];
        if (parentOfSynthetic == null || parentOfSynthetic == realBaseClassName) {
          // 合成类的父类是 Object 或不存在，使用 AnyGC
          realBaseClassName = null;
          break;
        }
        realBaseClassName = parentOfSynthetic;
      }

      // 检查父类是否为运行时类（如 AsyncStateMachine）
      if (_isRuntimeClass(superClass)) {
        // 运行时类直接使用其 C++ 类型
        final clsNode = _classNodes[cls.name];
        if (clsNode != null && clsNode.supertype != null && clsNode.supertype!.typeArguments.isNotEmpty) {
          final args = clsNode.supertype!.typeArguments.map((t) => _cppType(t)).join(', ');
          superName = '${superClass.name}<$args>';
        } else {
          superName = superClass.name;
        }
      } else if (realBaseClassName != null && _userClasses.contains(realBaseClassName) && !_syntheticLoweredNames.contains(realBaseClassName)) {
        // 使用真正的基类（非合成类）
        final superClean = _cleanName(realBaseClassName);
        final realBaseClass = _classNodes[realBaseClassName];
        final superTypeParams = realBaseClass?.typeParameters ?? [];
        if (superTypeParams.isNotEmpty) {
          // 模板父类需要指定模板参数
          final clsNode = _classNodes[cls.name];
          if (clsNode != null && clsNode.supertype != null && clsNode.supertype!.typeArguments.isNotEmpty) {
            final args = clsNode.supertype!.typeArguments.map((t) => _cppType(t)).join(', ');
            superName = '${superClean}Value<$args>';
          } else {
            if (hasTemplate) {
              final args = typeParams.map((tp) => tp.name ?? 'T').join(', ');
              superName = '${superClean}Value<$args>';
            } else {
              final args = superTypeParams.map((_) => 'AnyGC*').join(', ');
              superName = '${superClean}Value<$args>';
            }
          }
        } else {
          superName = '${superClean}Value';
        }
      } else if (realBaseClassName == null && _syntheticLoweredNames.contains(superClassName)) {
        // 合成 mixin 中间类的基类是 Object，使用 AnyGC
        superName = 'AnyGC';
      } else if (_userClasses.contains(superClassName)) {
        final superClean = _cleanName(superClassName);
        final superTypeParams = superClass.typeParameters;
        if (superTypeParams.isNotEmpty) {
          final clsNode = _classNodes[cls.name];
          if (clsNode != null && clsNode.supertype != null && clsNode.supertype!.typeArguments.isNotEmpty) {
            final args = clsNode.supertype!.typeArguments.map((t) => _cppType(t)).join(', ');
            superName = '${superClean}Value<$args>';
          } else {
            if (hasTemplate) {
              final args = typeParams.map((tp) => tp.name ?? 'T').join(', ');
              superName = '${superClean}Value<$args>';
            } else {
              final args = superTypeParams.map((_) => 'AnyGC*').join(', ');
              superName = '${superClean}Value<$args>';
            }
          }
        } else {
          superName = '${superClean}Value';
        }
      } else {
        superName = 'AnyGC';
      }
    } else {
      superName = 'AnyGC';
    }

    // 如果当前类的 C++ 基类是 AnyGC（即 lowered 形式），但实现了用户定义的接口，
    // 则让 C++ 结构体继承接口类以支持多态（如 Dog implements Animal → DogValue : AnimalValue）
    if (superName == 'AnyGC' && cls.implementedTypes.isNotEmpty) {
      for (final impl in cls.implementedTypes) {
        final implClassName = impl.classNode.name;
        if (_userClasses.contains(implClassName) && !_syntheticLoweredNames.contains(implClassName)) {
          final implClean = _cleanName(implClassName);
          final implClass = _classNodes[implClassName];
          final implTypeParams = implClass?.typeParameters ?? [];
          if (implTypeParams.isNotEmpty) {
            if (impl.typeArguments.isNotEmpty) {
              final args = impl.typeArguments.map((t) => _cppType(t)).join(', ');
              superName = '${implClean}Value<$args>';
            } else if (hasTemplate) {
              final args = typeParams.map((tp) => tp.name ?? 'T').join(', ');
              superName = '${implClean}Value<$args>';
            } else {
              superName = '${implClean}Value';
            }
          } else {
            superName = '${implClean}Value';
          }
          break; // 只使用第一个匹配的接口
        }
      }
    }

    // 生成 ClassInfo 结构体定义（继承自父类的 ClassInfo）
    final cleanName = _cleanName(className);
    final classInfoName = '${cleanName}ClassInfo';
    final inheritsVPtr = superClass == null || !_isRuntimeClass(superClass);
    final isAsyncSM = superClass != null && superClass.name == 'AsyncStateMachine';
    // 确定父类 ClassInfo 名称（保留模板参数）
    String parentClassInfoName;
    if (superName == 'AnyGC') {
      parentClassInfoName = 'ClassInfo';
    } else if (isAsyncSM) {
      // AsyncStateMachine 子类继承 AsyncStateMachineClassInfo
      final clsNode = _classNodes[cls.name];
      if (clsNode != null && clsNode.supertype != null && clsNode.supertype!.typeArguments.isNotEmpty) {
        final args = clsNode.supertype!.typeArguments.map((t) => _cppType(t)).join(', ');
        parentClassInfoName = 'AsyncStateMachineClassInfo<$args>';
      } else {
        parentClassInfoName = 'AsyncStateMachineClassInfo<AnyGC*>';
      }
    } else {
      final match = RegExp(r'^(.+?)Value(<.*>)?$').firstMatch(superName);
      if (match != null) {
        final templateArgs = match.group(2) ?? '';
        parentClassInfoName = '${match.group(1)!}ClassInfo$templateArgs';
      } else {
        parentClassInfoName = 'ClassInfo';
      }
    }
    // 确定父类 ClassInfo 静态实例（用于 _parent 链）
    String? parentCiInstance;
    if (parentClassInfoName != 'ClassInfo') {
      if (isAsyncSM) {
        parentCiInstance = '${superName}::_baseClassInfo';
      } else {
        parentCiInstance = '${superName}::_classInfo';
      }
    }
    // 收集本类新增的 vtable 方法名（不含继承的）
    final vtableEntries = _classVTableEntries[className] ?? [];
    // 只排除实际 ClassInfo 父类中已有的字段
    final parentEntryNames = <String>{..._baseClassInfoFields};
    if (parentClassInfoName != 'ClassInfo') {
      // 用户类父类：从 parentClassInfoName 提取父类名，沿 _classHierarchy 收集所有祖先的 vtable 条目
      // parentClassInfoName 格式: "AnimalClassInfo" 或 "AnimalClassInfo<T>"
      final parentMatch = RegExp(r'^(.+?)ClassInfo(<.*>)?$').firstMatch(parentClassInfoName);
      if (parentMatch != null) {
        var ancestorName = parentMatch.group(1)!;
        final visited = <String>{};
        while (ancestorName.isNotEmpty && !visited.contains(ancestorName)) {
          visited.add(ancestorName);
          // 收集该祖先类的 vtable entries
          final ancestorEntries = _classVTableEntries[ancestorName] ?? [];
          for (final e in ancestorEntries) {
            parentEntryNames.add(_classInfoFieldName(e));
          }
          // 继续向上查找
          final nextAncestor = _classHierarchy[ancestorName];
          if (nextAncestor == null || nextAncestor == ancestorName || nextAncestor == 'Object') break;
          // 跳过合成类
          var resolved = nextAncestor;
          while (resolved.isNotEmpty && _syntheticLoweredNames.contains(resolved)) {
            final next = _classHierarchy[resolved];
            if (next == null || next == resolved || next == 'Object') { resolved = ''; break; }
            resolved = next;
          }
          ancestorName = resolved;
        }
      }
    }
    // AsyncStateMachine 子类：排除 AsyncStateMachineClassInfo 中已有的字段
    if (isAsyncSM) {
      parentEntryNames.addAll(['step', 'start', 'completeWith', 'completeWithError']);
    }
    // 生成 wrapper/gcMark 前向声明 + ClassInfo 结构体（含构造函数自初始化）
    final tplArgs = hasTemplate ? '<${typeParams.map((tp) => tp.name ?? 'T').join(', ')}>' : '';
    // 前向声明 gcMark 和 wrapper 函数（供 ClassInfo 构造函数引用）
    if (inheritsVPtr || vtableEntries.isNotEmpty || isAsyncSM) {
      if (inheritsVPtr || isAsyncSM) {
        _structBuf.writeln('${templatePrefix}void _gcMark_$cleanName(AnyGC*, int);');
      }
      for (final entry in vtableEntries) {
        final fieldName = _classInfoFieldName(entry);
        final argCount = _vtableEntryArgCount(entry);
        final argList = ['AnyGC*'] + List.filled(argCount, 'AnyGC*');
        final retType = _vptrWrapReturnType(entry, cls);
        _structBuf.writeln('${templatePrefix}$retType _vptr_wrap_${cleanName}_$fieldName(${argList.join(', ')});');
      }
      if (isAsyncSM) {
        _structBuf.writeln('${templatePrefix}AnyGC* _vptr_wrap_${cleanName}_start(AnyGC*);');
        _structBuf.writeln('${templatePrefix}void _vptr_wrap_${cleanName}_completeWith(AnyGC*, AnyGC*);');
        _structBuf.writeln('${templatePrefix}void _vptr_wrap_${cleanName}_completeWithError(AnyGC*, AnyGC*);');
      }
    }
    _structBuf.write(templatePrefix);
    _structBuf.writeln('struct $classInfoName : $parentClassInfoName {');
    // 构造函数：赋值所有函数指针（含继承方法的重写）
    final hasCtorAssignments = inheritsVPtr || vtableEntries.isNotEmpty || isAsyncSM || parentCiInstance != null;
    if (hasCtorAssignments) {
      // 模板类需要 this-> 前缀访问依赖基类成员
      final prefix = hasTemplate ? 'this->' : '';
      _structBuf.writeln('    $classInfoName() {');
      _structBuf.writeln('        ${prefix}typeName = "$className";');
      for (final entry in vtableEntries) {
        final fieldName = _classInfoFieldName(entry);
        _structBuf.writeln('        ${prefix}$fieldName = &_vptr_wrap_${cleanName}_$fieldName$tplArgs;');
      }
      if (isAsyncSM) {
        _structBuf.writeln('        ${prefix}start = &_vptr_wrap_${cleanName}_start$tplArgs;');
        _structBuf.writeln('        ${prefix}completeWith = &_vptr_wrap_${cleanName}_completeWith$tplArgs;');
        _structBuf.writeln('        ${prefix}completeWithError = &_vptr_wrap_${cleanName}_completeWithError$tplArgs;');
      }
      if (inheritsVPtr || isAsyncSM) {
        _structBuf.writeln('        ${prefix}gcMark = &_gcMark_$cleanName$tplArgs;');
      }
      if (parentCiInstance != null) {
        _structBuf.writeln('        ${prefix}_parent = &$parentCiInstance;');
      }
      _structBuf.writeln('    }');
    }
    // 字段声明（仅新增字段，不含父类已有的）
    for (final entry in vtableEntries) {
      final fieldName = _classInfoFieldName(entry);
      if (!parentEntryNames.contains(fieldName)) {
        final argCount = _vtableEntryArgCount(entry);
        final retType = _vptrWrapReturnType(entry, cls);
        _structBuf.writeln('    ${_classInfoFieldDecl(fieldName, argCount, retType: retType)};');
      }
    }
    _structBuf.writeln('};');
    _structBuf.writeln();

    // 生成结构体定义
    _structBuf.write(templatePrefix);
    _structBuf.writeln('struct $structName : $superName {');

    // 字段
    for (final field in fields) {
      final fieldType = _cppType(field.type);
      final fieldName = _cleanName(field.name.text);
      final defaultVal = _cppDefaultValue(fieldType);
      _structBuf.writeln('    $fieldType $fieldName\{$defaultVal\};');
    }

    // ClassInfo 静态实例
    _structBuf.writeln();
    // _classInfo 实例指针在 AnyGC 上，需要 AnyGC:: 限定符与静态 _classInfo 成员区分分
    final baseQualifier = 'AnyGC';
    final gcMarkAssignment = '';
    if (hasTemplate) {
      final tplArgs = '<${typeParams.map((tp) => tp.name ?? 'T').join(', ')}>';
      _structBuf.writeln('    static $classInfoName$tplArgs _classInfo;');
      _structBuf.writeln('    $structName() { $baseQualifier::_classInfo = &_classInfo;$gcMarkAssignment }');
    } else {
      _structBuf.writeln('    static $classInfoName _classInfo;');
      _structBuf.writeln('    $structName() { $baseQualifier::_classInfo = &_classInfo;$gcMarkAssignment }');
    }

    _structBuf.writeln();

    _structBuf.writeln('};');
    _structBuf.writeln();

    // 静态 ClassInfo 定义（模板类需要特殊处理）
    if (hasTemplate) {
      final templateDecl = 'template<${typeParams.map((tp) => 'typename ${tp.name ?? 'T'}').join(', ')}>';
      final tplArgs = '<${typeParams.map((tp) => tp.name ?? 'T').join(', ')}>';
      _structBuf.writeln('$templateDecl $classInfoName$tplArgs $structName$tplArgs::_classInfo;');
    } else {
      _structBuf.writeln('$classInfoName $structName::_classInfo;');
    }
    _structBuf.writeln();

    // 生成 vptr wrapper 函数（在构造函数之前，这样构造函数可以引用它们）
    _emitVptrWrappers(className, structName, cls, typeParams);

    // gcMark 静态函数 — 通过 ClassInfo dispatch 派发，不依赖 C++ virtual override
    if (inheritsVPtr) {
      final cleanName = _cleanName(className);
      final gcMarkFuncName = '_gcMark_$cleanName';

      // 计算父类 gcMark 调用
      String? parentGcMarkCall;
      if (superName != 'AnyGC') {
        final match = RegExp(r'^(.+)Value(<.*>)?$').firstMatch(superName);
        if (match != null) {
          final baseName = match.group(1)!;
          final templateArgs = match.group(2) ?? '';
          parentGcMarkCall = '_gcMark_$baseName$templateArgs(obj__, flag)';
        }
      }

      final hasGcPointerFields = fields.any((f) => _isGcPointerType(_cppType(f.type)));

      if (hasTemplate) {
        final tplDecl = 'template<${typeParams.map((tp) => 'typename ${tp.name ?? 'T'}').join(', ')}>';
        final tplArgs = '<${typeParams.map((tp) => tp.name ?? 'T').join(', ')}>';
        _implBuf.writeln('$tplDecl void $gcMarkFuncName(AnyGC* obj__, int flag) {');
        if (hasGcPointerFields) {
          _implBuf.writeln('    auto* self__ = static_cast<$structName$tplArgs*>(obj__);');
        }
      } else {
        _implBuf.writeln('void $gcMarkFuncName(AnyGC* obj__, int flag) {');
        if (hasGcPointerFields) {
          _implBuf.writeln('    auto* self__ = static_cast<$structName*>(obj__);');
        }
      }

      if (parentGcMarkCall != null) {
        _implBuf.writeln('    $parentGcMarkCall;');
      }

      for (final field in fields) {
        final fieldType = _cppType(field.type);
        if (_isGcPointerType(fieldType)) {
          final fieldName = _cleanName(field.name.text);
          _implBuf.writeln('    if (self__->$fieldName) _gcMark(self__->$fieldName, flag);');
        }
      }

      _implBuf.writeln('}');
      _implBuf.writeln();
    }

    // AsyncStateMachine 子类：生成 _gcMark 静态函数（标记子类字段，由 AsyncStateMachine::gcMark 通过 ClassInfo dispatch 调用）
    if (isAsyncSM) {
      final cleanName = _cleanName(className);
      _implBuf.writeln('void _gcMark_$cleanName(AnyGC* obj__, int flag) {');
      // 调用 AsyncStateMachine<T>::_gcMark_impl 标记 promise 字段
      final asyncSmMatch = RegExp(r'^AsyncStateMachine<(.+)>$').firstMatch(superName);
      if (asyncSmMatch != null) {
        final tplArg = asyncSmMatch.group(1)!;
        _implBuf.writeln('    AsyncStateMachine<$tplArg>::_gcMark_impl(obj__, flag);');
      }
      final hasGcPointerFields = fields.any((f) => _isGcPointerType(_cppType(f.type)));
      if (hasGcPointerFields) {
        _implBuf.writeln('    auto* self__ = static_cast<$structName*>(obj__);');
      }
      for (final field in fields) {
        final fieldType = _cppType(field.type);
        if (_isGcPointerType(fieldType)) {
          final fieldName = _cleanName(field.name.text);
          _implBuf.writeln('    if (self__->$fieldName) _gcMark(self__->$fieldName, flag);');
        }
      }
      _implBuf.writeln('}');
      _implBuf.writeln();
    }

    // 非模板类：通过静态初始化器提前注册 ClassInfo dispatch，确保即使通过 new X() 直接创建对象也能正确派发
    final vtableEntriesForReg = _classVTableEntries[className] ?? [];

    // AsyncStateMachine 子类：生成继承方法的 wrapper（直接调用基类方法）
    // 跳过已在 vtable entries 中的方法（避免重复生成）
    if (superClass != null && superClass.name == 'AsyncStateMachine') {
      final cleanName = _cleanName(cls.name);
      final existingNames = vtableEntriesForReg.map((e) => e.name).toSet();
      // 获取 AsyncStateMachine<T> 的实际类型参数
      String smInnerType = 'AnyGC*';
      final clsNode = _classNodes[cls.name];
      if (clsNode != null && clsNode.supertype != null && clsNode.supertype!.typeArguments.isNotEmpty) {
        smInnerType = _cppType(clsNode.supertype!.typeArguments.first);
      }
      // start() → Promise<T>* (dispatch through AsyncStateMachine<T> base vptr)
      if (!existingNames.contains('start')) {
        _implBuf.writeln('AnyGC* _vptr_wrap_${cleanName}_start(AnyGC* obj__) {');
        _implBuf.writeln('    return AsyncStateMachine<$smInnerType>::_vptr_start(obj__);');
        _implBuf.writeln('}');
      }
      // completeWith(value) (dispatch through AsyncStateMachine<T> base vptr)
      if (!existingNames.contains('completeWith')) {
        _implBuf.writeln('void _vptr_wrap_${cleanName}_completeWith(AnyGC* obj__, AnyGC* arg0) {');
        _implBuf.writeln('    AsyncStateMachine<$smInnerType>::_vptr_completeWith(obj__, arg0);');
        _implBuf.writeln('}');
      }
      // completeWithError(error) (dispatch through AsyncStateMachine<T> base vptr)
      if (!existingNames.contains('completeWithError')) {
        _implBuf.writeln('void _vptr_wrap_${cleanName}_completeWithError(AnyGC* obj__, AnyGC* arg0) {');
        _implBuf.writeln('    AsyncStateMachine<$smInnerType>::_vptr_completeWithError(obj__, arg0);');
        _implBuf.writeln('}');
      }
    }

    // 类的静态字段声明为全局变量
    for (final field in cls.fields) {
      if (field.isStatic && !field.isConst) {
        final fieldName = _cleanName(field.name.text);
        final fieldType = _cppType(field.type);
        final defaultVal = _cppDefaultValue(fieldType);
        if (field.initializer != null) {
          final initVal = _emitCppExpr(field.initializer!);
          // F3 修复：GC 对象指针类型的静态字段必须注册为 root，
          // 否则 collect() 会回收仍被全局变量引用的对象（use-after-free）
          if (fieldType.endsWith('*') && initVal != 'nullptr') {
            _implBuf.writeln('$fieldType $fieldName = GC::allocateGlobal($initVal);');
          } else {
            _implBuf.writeln('$fieldType $fieldName = $initVal;');
          }
        } else {
          _implBuf.writeln('$fieldType $fieldName\{$defaultVal\};');
        }
      }
    }

    // 生成静态函数前向声明和实现
    // 构造函数
    for (final ctor in constructors) {
      _emitCppConstructor(className, structName, ctor, classNode: cls);
    }

    // 方法
    for (final method in methods) {
      _emitCppMethod(className, structName, method, classNode: cls);
    }
  }

  // ==========================================================================
  // VPtr Wrapper 函数生成
  // ==========================================================================

  /// 从类的继承层次构建类型参数替换映射
  /// 例如：StringToIntTransformer extends DataTransformer<String, int>
  /// 产生映射：TInput → DartString, TOutput → int64_t
  Map<String, String> _buildTypeSubstitutionMap(Class cls) {
    final map = <String, String>{};
    final clsNode = _classNodes[cls.name];
    if (clsNode == null) return map;

    // 从父类（supertype）构建映射
    final superClass = cls.superclass;
    if (superClass != null && superClass.typeParameters.isNotEmpty) {
      if (clsNode.supertype != null && clsNode.supertype!.typeArguments.isNotEmpty) {
        for (int i = 0; i < superClass.typeParameters.length && i < clsNode.supertype!.typeArguments.length; i++) {
          final paramName = superClass.typeParameters[i].name ?? 'T';
          final concreteType = _cppType(clsNode.supertype!.typeArguments[i]);
          map[paramName] = concreteType;
        }
      }
      // 递归处理祖父类（通过父类的 supertype）
      final superNode = _classNodes[superClass.name];
      if (superNode != null && superNode.supertype != null &&
          superNode.supertype!.typeArguments.isNotEmpty &&
          superClass.superclass != null && superClass.superclass!.typeParameters.isNotEmpty) {
        final grandParent = superClass.superclass!;
        for (int i = 0; i < grandParent.typeParameters.length && i < superNode.supertype!.typeArguments.length; i++) {
          final paramName = grandParent.typeParameters[i].name ?? 'T';
          if (!map.containsKey(paramName)) {
            var concreteType = _cppType(superNode.supertype!.typeArguments[i]);
            // 如果祖父类的类型参数是父类的类型参数，需要递归替换
            if (map.containsKey(concreteType)) {
              concreteType = map[concreteType]!;
            }
            map[paramName] = concreteType;
          }
        }
      }
    }

    // 从实现的接口构建映射
    for (final impl in cls.implementedTypes) {
      final ifaceClass = impl.classNode;
      if (ifaceClass.typeParameters.isNotEmpty && impl.typeArguments.isNotEmpty) {
        for (int i = 0; i < ifaceClass.typeParameters.length && i < impl.typeArguments.length; i++) {
          final paramName = ifaceClass.typeParameters[i].name ?? 'T';
          if (!map.containsKey(paramName)) {
            var concreteType = _cppType(impl.typeArguments[i]);
            // 如果接口的类型参数映射到父类的类型参数，需要递归替换
            if (map.containsKey(concreteType)) {
              concreteType = map[concreteType]!;
            }
            map[paramName] = concreteType;
          }
        }
      }
    }

    // 添加类自身的类型参数（identity mapping，用于在作用域内检查）
    for (final tp in cls.typeParameters) {
      final name = tp.name ?? 'T';
      map.putIfAbsent(name, () => name);
    }

    return map;
  }

  /// 使用类型替换映射替换类型字符串中的类型参数
  String _applyTypeSubstitution(String type, Map<String, String> substitution) {
    if (substitution.isEmpty) return type;
    var result = type;
    for (final entry in substitution.entries) {
      if (entry.key != entry.value) {
        result = result.replaceAll(RegExp('\\b${entry.key}\\b'), entry.value);
      }
    }
    return result;
  }

  /// 为每个 vptr 入口生成 wrapper 函数
  /// wrapper 使用 void* 作为额外参数类型，AnyGC* 作为返回类型
  /// 避免 vptr dispatch 时的函数签名不匹配问题
  void _emitVptrWrappers(String className, String structName, Class cls, List<TypeParameter> typeParams) {
    final vtableEntries = _classVTableEntries[className] ?? [];
    if (vtableEntries.isEmpty) return;

    final cleanClassName = _cleanName(className);
    final hasTemplate = typeParams.isNotEmpty;
    final templateDecl = hasTemplate
        ? 'template<${typeParams.map((tp) => 'typename ${tp.name ?? 'T'}').join(', ')}>'
        : '';
    final templateArgs = hasTemplate
        ? '<${typeParams.map((tp) => tp.name ?? 'T').join(', ')}>'
        : '';

    // 构建类型参数替换映射（从类的继承层次解析接口/父类的类型参数）
    final typeSubstitution = _buildTypeSubstitutionMap(cls);

    for (final entry in vtableEntries) {
      final methodName = _cleanMethodName(entry.name);
      final proc = entry.proc;

      // 确定目标函数名 — 始终使用当前类名（lowered 函数使用基类名，不使用 mixin 链名）
      String targetFuncName;
      if (entry.kind == 'getter') {
        targetFuncName = '${cleanClassName}_get_$methodName';
      } else if (entry.kind == 'setter') {
        targetFuncName = '${cleanClassName}_set_$methodName';
      } else {
        targetFuncName = '${cleanClassName}_$methodName';
      }

      // 如果 proc 为 null（如字段 getter），尝试从前向声明推断签名
      if (proc == null) {
        // 对于 getter，从前向声明获取返回类型
        if (entry.kind == 'getter') {
          final resolvedReturn = _resolveReturnTypeFromForwardDecl(targetFuncName);
          final returnType = resolvedReturn ?? 'AnyGC*';
          final wrapperName = '_vptr_wrap_${cleanClassName}_get_$methodName';
          final wrapRetType = _vptrWrapReturnType(entry, cls);
          if (hasTemplate) {
            _implBuf.writeln(templateDecl);
          }
          _implBuf.writeln('$wrapRetType $wrapperName(AnyGC* obj__) {');
          if (wrapRetType == 'bool' || wrapRetType == 'int64_t') {
            final callExpr = '$targetFuncName$templateArgs(static_cast<$structName$templateArgs*>(obj__))';
            _implBuf.writeln('    return _vptrRet<$wrapRetType>($callExpr);');
          } else if (wrapRetType != 'AnyGC*') {
            // Type parameter, double, DartString, or pointer type
            // _vptrRet handles both boxed (AnyGC*) and unboxed returns
            final callExpr = '$targetFuncName$templateArgs(static_cast<$structName$templateArgs*>(obj__))';
            _implBuf.writeln('    return _vptrRet<$wrapRetType>($callExpr);');
          } else if (returnType == 'int64_t' || returnType == 'double' ||
              returnType == 'bool' || returnType == 'DartString') {
            _implBuf.writeln('    return _box($targetFuncName$templateArgs(static_cast<$structName$templateArgs*>(obj__)));');
          } else if (returnType.endsWith('*')) {
            _implBuf.writeln('    return _box($targetFuncName$templateArgs(static_cast<$structName$templateArgs*>(obj__)));');
          } else if (returnType == 'AnyGC*') {
            _implBuf.writeln('    return $targetFuncName$templateArgs(static_cast<$structName$templateArgs*>(obj__));');
          } else {
            _implBuf.writeln('    return _box($targetFuncName$templateArgs(static_cast<$structName$templateArgs*>(obj__)));');
          }
          _implBuf.writeln('}\n');
        } else if (entry.kind == 'setter') {
          // 对于 setter，从前向声明获取参数类型
          final resolvedParams = _resolveParamsFromForwardDecl(targetFuncName, 1);
          final paramType = (resolvedParams != null && resolvedParams.isNotEmpty) ? resolvedParams[0] : 'AnyGC*';
          final wrapperName = '_vptr_wrap_${cleanClassName}_set_$methodName';
          if (hasTemplate) {
            _implBuf.writeln(templateDecl);
          }
          _implBuf.writeln('void $wrapperName(AnyGC* obj__, AnyGC* arg0) {');
          if (paramType == 'int64_t') {
            _implBuf.writeln('    $targetFuncName$templateArgs(static_cast<$structName$templateArgs*>(obj__), dynAs<int64_t>(arg0));');
          } else if (paramType == 'double') {
            _implBuf.writeln('    $targetFuncName$templateArgs(static_cast<$structName$templateArgs*>(obj__), dynAs<double>(arg0));');
          } else if (paramType == 'bool') {
            _implBuf.writeln('    $targetFuncName$templateArgs(static_cast<$structName$templateArgs*>(obj__), dynAs<bool>(arg0));');
          } else if (paramType == 'DartString') {
            _implBuf.writeln('    $targetFuncName$templateArgs(static_cast<$structName$templateArgs*>(obj__), dynAs<DartString>(arg0));');
          } else if (paramType.endsWith('*')) {
            if (paramType == 'AnyGC*') {
              _implBuf.writeln('    $targetFuncName$templateArgs(static_cast<$structName$templateArgs*>(obj__), arg0);');
            } else {
              _implBuf.writeln('    $targetFuncName$templateArgs(static_cast<$structName$templateArgs*>(obj__), static_cast<$paramType>(arg0));');
            }
          } else {
            _implBuf.writeln('    $targetFuncName$templateArgs(static_cast<$structName$templateArgs*>(obj__), dynAs<$paramType>(arg0));');
          }
          _implBuf.writeln('}\n');
        }
        continue;
      }

      // 方法可能有额外的模板参数（如 Pair<A,B>.mapFirst<C>）
      // wrapper 只使用类级模板参数（方法级参数如 R 无法从 AnyGC* 推导，用 AnyGC* 占位）
      final methodTypeParams = proc.function.typeParameters;
      final wrapperHasTemplate = typeParams.isNotEmpty;
      final wrapperTemplateDecl = wrapperHasTemplate
          ? 'template<${typeParams.map((tp) => 'typename ${tp.name ?? 'T'}').join(', ')}>'
          : '';
      final wrapperTemplateArgs = wrapperHasTemplate
          ? '<${typeParams.map((tp) => tp.name ?? 'T').join(', ')}>'
          : '';

      // 构建函数引用（方法自身的模板参数用 AnyGC* 占位）
      String funcRef;

      if (methodTypeParams.isNotEmpty) {
        final classParamNames = typeParams.map((tp) => tp.name ?? 'T').toSet();
        final extraParams = methodTypeParams.where((tp) => !classParamNames.contains(tp.name ?? 'T')).toList();
        if (extraParams.isNotEmpty && hasTemplate) {
          final classArgsList = typeParams.map((tp) => tp.name ?? 'T').toList();
          final allArgs = [
            ...classArgsList,
            ...extraParams.map((_) => 'AnyGC*'),
          ];
          funcRef = '$targetFuncName<${allArgs.join(', ')}>';
        } else {
          funcRef = '$targetFuncName$templateArgs';
        }
      } else {
        funcRef = '$targetFuncName$templateArgs';
      }

      // 获取参数类型 — 优先从类的实际方法中获取（解析后的类型），
      // 避免使用接口方法的未解析类型参数（如 T）
      final func = proc.function;
      FunctionNode? resolvedFunc;
      // 从类中查找同名方法的实际实现
      final matchingProcs = cls.procedures.where((p) =>
        p.name.text == entry.name &&
        ((entry.kind == 'getter' && p.isGetter) ||
         (entry.kind == 'setter' && p.isSetter) ||
         (entry.kind == 'method' && !p.isGetter && !p.isSetter))
      ).toList();
      if (matchingProcs.length == 1) {
        resolvedFunc = matchingProcs.first.function;
      }
      final paramFunc = resolvedFunc ?? func;
      final params = <String>[];
      for (final p in paramFunc.positionalParameters) {
        params.add(_cppType(p.type));
      }
      // 命名参数也需要收集（如 fold<R>({onSuccess, onFailure})）
      for (final p in paramFunc.namedParameters) {
        params.add(_cppType(p.type));
      }

      // setter 函数的参数类型可能使用 AnyGC*（内部自行拆箱）或具体类型。
      // 以前向声明中的实际参数类型为准，避免 wrapper 拆箱/不拆箱不匹配。
      // 如果前向声明未找到（可能由 _emitMissingLoweredMethods 后续生成，使用 AnyGC*），
      // 默认使用 AnyGC* 以匹配 _emitMissingLoweredMethods 的签名。
      if (entry.kind == 'setter') {
        final resolvedSetterParams = _resolveParamsFromForwardDecl(targetFuncName, params.length);
        if (resolvedSetterParams != null) {
          for (var i = 0; i < params.length && i < resolvedSetterParams.length; i++) {
            params[i] = resolvedSetterParams[i];
          }
        } else {
          for (var i = 0; i < params.length; i++) {
            params[i] = 'AnyGC*';
          }
        }
      }

      // 使用类型替换映射解析继承自接口/父类的类型参数
      // 例如：TInput → DartString (from DataTransformer<String, int>)
      for (var i = 0; i < params.length; i++) {
        if (_isCppTypeParameter(params[i]) || _containsTypeParameter(params[i])) {
          params[i] = _applyTypeSubstitution(params[i], typeSubstitution);
        }
      }

      // 如果参数类型中仍有未解析的类型参数（不在 wrapper 模板作用域内），
      // 尝试从已解析的签名或前向声明中查找实际函数的参数类型
      // wrapper 只模板化类级参数，方法级参数（如 R, R2）不在作用域内
      final classTypeParamNames = typeParams.map((tp) => tp.name ?? 'T').toSet();
      final methodTypeParamNames = methodTypeParams.map((tp) => tp.name ?? 'R').toSet();
      // 未解析 = 方法级类型参数名（不在类级参数中）
      final unresolvedNames = methodTypeParamNames.difference(classTypeParamNames);
      bool hasUnresolvedTypeParam = unresolvedNames.isNotEmpty && params.any((p) {
        for (final name in unresolvedNames) {
          if (p == name || p.contains('<') && RegExp('\\b$name\\b').hasMatch(p)) return true;
        }
        return false;
      });
      // 对于仍然未解析的类型参数（方法级类型参数如 R），用 AnyGC* 替换
      if (hasUnresolvedTypeParam) {
        for (var i = 0; i < params.length; i++) {
          // 替换复合类型中未解析的类型参数为 AnyPtr
          if (params[i].contains('<')) {
            final templateMatch = RegExp(r'<(.+)>').firstMatch(params[i]);
            if (templateMatch != null) {
              var templateArgs = templateMatch.group(1)!;
              final args = templateArgs.split(',');
              final newArgs = args.map((arg) {
                final trimmed = arg.trim();
                if (unresolvedNames.contains(trimmed)) {
                  return ' AnyGC*';
                }
                return arg;
              }).toList();
              params[i] = params[i].replaceFirst(RegExp(r'<.+>'), '<${newArgs.join(',')}>');
            }
          }
          // 裸类型参数
          if (unresolvedNames.contains(params[i])) {
            params[i] = 'AnyGC*';
          }
        }
      }

      // 获取返回类型
      String returnType;
      if (entry.kind == 'setter') {
        returnType = 'void';
      } else {
        returnType = _cppType(paramFunc.returnType);
        // 使用类型替换映射解析返回类型中的类型参数
        if (_isCppTypeParameter(returnType) || _containsTypeParameter(returnType)) {
          returnType = _applyTypeSubstitution(returnType, typeSubstitution);
        }
        // 如果返回类型仍然是未解析的类型参数，尝试从已解析签名或前向声明中获取
        if (_isCppTypeParameter(returnType) && !classTypeParamNames.contains(returnType)) {
          final resolved = _resolvedFuncReturnTypes[targetFuncName]
              ?? _resolveReturnTypeFromForwardDecl(targetFuncName);
          if (resolved != null) {
            returnType = resolved;
          } else {
            returnType = 'AnyGC*'; // 方法级类型参数默认为 AnyPtr
          }
        }
      }

      // 生成 wrapper 函数名
      final wrapperName = '_vptr_wrap_${cleanClassName}_${entry.kind == 'getter' ? 'get_' : entry.kind == 'setter' ? 'set_' : ''}$methodName';

      // 生成 wrapper 参数列表（AnyGC* 用于额外参数，统一签名避免 UB）
      final wrapperParams = <String>['AnyGC* obj__'];
      for (var i = 0; i < params.length; i++) {
        wrapperParams.add('AnyGC* arg$i');
      }

      // 生成参数转换
      final castArgs = <String>[];
      for (var i = 0; i < params.length; i++) {
        final paramType = params[i];
        // 检查参数类型是否包含不在 wrapper 作用域内的类型参数
        final hasUnresolved = _typeHasUnresolvedParam(paramType, classTypeParamNames);
        if (paramType.endsWith('*')) {
          if (hasUnresolved) {
            // 包含未解析类型参数的指针：arg$i 已经是 AnyGC*
            castArgs.add('arg$i');
          } else if (paramType == 'AnyGC*') {
            castArgs.add('arg$i');
          } else {
            castArgs.add('static_cast<$paramType>(arg$i)');
          }
        } else if (paramType == 'int64_t') {
          castArgs.add('dynAs<int64_t>(arg$i)');
        } else if (paramType == 'double') {
          castArgs.add('dynAs<double>(arg$i)');
        } else if (paramType == 'bool') {
          castArgs.add('dynAs<bool>(arg$i)');
        } else if (paramType == 'DartString') {
          castArgs.add('dynAs<DartString>(arg$i)');
        } else if (_isCppTypeParameter(paramType) && !classTypeParamNames.contains(paramType)) {
          // 不在作用域内的类型参数：直接传递 AnyGC*
          castArgs.add('arg$i');
        } else if (_isCppTypeParameter(paramType)) {
          // 在作用域内的模板类型参数：使用 dynAs<T>() 解包
          castArgs.add('dynAs<$paramType>(arg$i)');
        } else {
          castArgs.add('dynAs<$paramType>(arg$i)');
        }
      }

      // 生成调用表达式
      final callExpr = '$funcRef(static_cast<$structName$templateArgs*>(obj__)${castArgs.isNotEmpty ? ", ${castArgs.join(', ')}" : ""})';

      // 生成返回值包装
      final wrapRetType = _vptrWrapReturnType(entry, cls);
      String returnStmt;
      if (wrapRetType == 'void') {
        returnStmt = '    $callExpr;';
      } else if (wrapRetType == 'bool' || wrapRetType == 'int64_t') {
        returnStmt = '    return _vptrRet<$wrapRetType>($callExpr);';
      } else if (wrapRetType != 'AnyGC*') {
        // Type parameter (TOutput), double, DartString, or pointer type
        // _vptrRet handles both boxed (AnyGC*) and unboxed returns
        returnStmt = '    return _vptrRet<$wrapRetType>($callExpr);';
      } else if (returnType == 'void') {
        returnStmt = '    $callExpr;';
      } else if (returnType == 'int64_t' || returnType == 'double' ||
                 returnType == 'bool' || returnType == 'DartString') {
        returnStmt = '    return _box($callExpr);';
      } else if (returnType.endsWith('*')) {
        returnStmt = '    return _box($callExpr);';
      } else if (returnType == 'AnyGC*') {
        returnStmt = '    return $callExpr;';
      } else {
        returnStmt = '    return _box($callExpr);';
      }

      // 输出 wrapper 函数（定义时不在函数名后加模板参数，避免 partial specialization 错误）
      if (wrapperTemplateDecl.isNotEmpty) {
        _implBuf.writeln(wrapperTemplateDecl);
      }
      _implBuf.writeln('$wrapRetType $wrapperName(${wrapperParams.join(', ')}) {');
      _implBuf.writeln(returnStmt);
      _implBuf.writeln('}\n');
    }
  }

  // ==========================================================================
  // 构造函数
  // ==========================================================================

  void _emitCppConstructor(String className, String structName, Constructor ctor, {Class? classNode}) {
    // 保存并清除外部作用域的变量名映射
    final savedVarNameMappings = Map<String, String>.from(_variableNameMappings);
    final savedVariableTypeMap = Map<String, String>.from(_variableTypeMap);
    final savedDeclaredVariables = Set<String>.from(_declaredVariables);
    _variableNameMappings.clear();
    _declaredVariables.clear();

    final cleanClassName = _cleanName(className);
    final ctorName = ctor.name.text.isEmpty ? 'new' : 'new_${_cleanName(ctor.name.text)}';
    final funcName = '${cleanClassName}_$ctorName';

    // 检查是否已经生成了该构造函数的实现（防止重复生成）
    if (_emittedImplementations.contains(funcName)) {
      // 恢复作用域
      _variableNameMappings
        ..clear()
        ..addAll(savedVarNameMappings);
      _variableTypeMap
        ..clear()
        ..addAll(savedVariableTypeMap);
      _declaredVariables
        ..clear()
        ..addAll(savedDeclaredVariables);
      return;
    }
    _emittedImplementations.add(funcName);

    final func = ctor.function;

    // 设置当前类名（供 _emitCppInitializer 使用）
    final savedClassName = _currentClassName;
    _currentClassName = className;

    // 检查是否是模板类
    final typeParams = classNode?.typeParameters ?? [];
    final hasTemplate = typeParams.isNotEmpty;
    final savedInScopeTypeParams = _inScopeTypeParams;
    _inScopeTypeParams = typeParams.map((tp) => tp.name ?? 'T').toSet();
    final templatePrefix = hasTemplate
        ? 'template<${typeParams.map((tp) => 'typename ${tp.name ?? 'T'}').join(', ')}>'
        : '';
    final templateArgs = hasTemplate
        ? '<${typeParams.map((tp) => tp.name ?? 'T').join(', ')}>'
        : '';

    // 收集参数（实现中不添加默认值）
    final params = <String>['$structName$templateArgs* this_'];
    for (final param in func.positionalParameters) {
      final paramType = _cppType(param.type);
      final paramName = _cleanName(param.name ?? 'p${params.length}');
      params.add('$paramType $paramName');
    }

    // 收集命名参数（实现中不添加默认值）
    for (final param in func.namedParameters) {
      final paramType = _cppType(param.type);
      final paramName = _cleanName(param.name ?? 'p${params.length}');
      params.add('$paramType $paramName');  // 不添加默认值
    }

    // 返回类型
    final returnType = '$structName$templateArgs*';

    // 函数实现（带模板前缀）
    if (templatePrefix.isNotEmpty) {
      _implBuf.writeln('$templatePrefix');
    }
    _implBuf.writeln('$returnType $funcName(${params.join(', ')}) {');
    _indent = 1;

    // 处理初始化器（含 super 构造函数调用）
    if (ctor.initializers.isNotEmpty) {
      for (final init in ctor.initializers) {
        _emitCppInitializer(init, structName);
      }
    }

    // 处理 Dart 字段初始化器（如 `final _listeners = []`）
    // 这些存储在 Field 节点上，不在构造函数的 initializers 中
    if (classNode != null) {
      // 收集已由 ctor.initializers 处理的字段名
      final initializedFields = <String>{};
      for (final init in ctor.initializers) {
        if (init is FieldInitializer) {
          initializedFields.add(init.field.name.text);
        }
      }
      // 收集已由构造函数参数赋值的字段名
      for (final p in func.positionalParameters) {
        initializedFields.add(p.name ?? '');
      }
      // 收集所有需要初始化的字段：类自身字段 + mixin 应用类层次中的字段。
      // 必须与结构体字段收集逻辑一致（见上方 struct 生成处），否则 mixin 字段
      // （如 Loggable._logs、Observable._observers）会被遗漏，导致构造后为 nullptr。
      final ctorFields = <Field>[];
      final ctorSeenNames = <String>{};
      for (final field in classNode.fields) {
        ctorFields.add(field);
        ctorSeenNames.add(field.name.text);
      }
      if (classNode.superclass != null) {
        var ancestor = classNode.superclass;
        while (ancestor != null) {
          final ancestorName = ancestor.name;
          if (_syntheticLoweredNames.contains(ancestorName) || ancestorName.contains('&')) {
            for (final field in ancestor.fields) {
              if (!field.isStatic && !ctorSeenNames.contains(field.name.text)) {
                ctorFields.add(field);
                ctorSeenNames.add(field.name.text);
              }
            }
          }
          ancestor = ancestor.superclass;
        }
      }
      for (final field in ctorFields) {
        if (field.isStatic || field.isConst) continue;
        if (field.name.text.startsWith('_name') || field.name.text.startsWith('_index')) continue;
        if (initializedFields.contains(field.name.text)) continue;
        if (field.initializer != null) {
          // 可空字段的隐式 null 初始化器（如 `DateTime? _cachedAt;`）跳过赋值：
          // C++ 结构体的默认成员初始化器（{nullptr}/{0}/{false}/{...}）已提供正确默认值，
          // 直接赋 nullptr 对值类型（如 StaticDateTime）会编译失败。
          if (field.initializer is NullLiteral) continue;
          final fieldName = _cleanName(field.name.text);
          final fieldCppType = _cppType(field.type);
          // 设置集合/Map 类型上下文
          String? savedMapKeyType, savedMapValueType, savedCollElemType;
          final dartType = field.type;
          if (dartType is InterfaceType) {
            final clsName = dartType.classNode.name;
            if ((clsName == 'Map' || clsName == 'StaticMap') && dartType.typeArguments.length >= 2) {
              savedMapKeyType = _expectedMapKeyType;
              savedMapValueType = _expectedMapValueType;
              _expectedMapKeyType = _cppType(dartType.typeArguments[0]);
              _expectedMapValueType = _cppType(dartType.typeArguments[1]);
            } else if ((clsName == 'List' || clsName == 'StaticList' || clsName == 'Set' || clsName == 'StaticSet') && dartType.typeArguments.isNotEmpty) {
              savedCollElemType = _expectedCollectionElementType;
              _expectedCollectionElementType = _cppType(dartType.typeArguments[0]);
            }
          }
          final initVal = _emitCppExpr(field.initializer!);
          // 恢复类型上下文
          if (savedMapKeyType != null || savedMapValueType != null) {
            _expectedMapKeyType = savedMapKeyType;
            _expectedMapValueType = savedMapValueType;
          }
          if (savedCollElemType != null) {
            _expectedCollectionElementType = savedCollElemType;
          }
          final wrappedInit = _wrapToType(initVal, fieldCppType, field.initializer!);
          _implBuf.writeln('${_pad}this_->$fieldName = $wrappedInit;');
        }
      }
    }

    // 函数体
    if (func.body != null) {
      _emitCppStmt(func.body!, _implBuf);
    }

    _implBuf.writeln('${_pad}return this_;');
    _implBuf.writeln('}\n');
    _indent = 0;
    _currentClassName = savedClassName;
    _inScopeTypeParams = savedInScopeTypeParams;

    // 恢复外部作用域的变量名映射和类型映射
    _variableNameMappings
      ..clear()
      ..addAll(savedVarNameMappings);
    _variableTypeMap
      ..clear()
      ..addAll(savedVariableTypeMap);
    _declaredVariables
      ..clear()
      ..addAll(savedDeclaredVariables);
  }

  void _emitCppInitializer(Initializer init, String structName) {
    if (init is FieldInitializer) {
      final fieldName = _cleanName(init.field.name.text);
      final value = _emitCppExpr(init.value);
      // 转换 null 值为字段类型的默认值（特别是模板类型参数如 L, R）
      final fieldCppType = _cppType(init.field.type);
      final convertedValue = _convertNullToType(value, fieldCppType);
      _implBuf.writeln('${_pad}this_->$fieldName = $convertedValue;');
    } else if (init is SuperInitializer) {
      // Skip Object super constructor calls
      final superClassName = init.target.enclosingClass.name;
      if (superClassName != 'Object') {
        // 解析合成 mixin 类名（含 &）到真实父类
        String realSuperName = superClassName;
        if (superClassName.contains('&')) {
          final sanitized = _sanitizeSyntheticName(superClassName);
          realSuperName = _classHierarchy[sanitized] ?? '';
          while (realSuperName.isNotEmpty && _syntheticLoweredNames.contains(realSuperName)) {
            final next = _classHierarchy[realSuperName];
            if (next == null || next == 'Object') { realSuperName = ''; break; }
            realSuperName = next;
          }
        }
        // 如果解析后为空（合成类的父类是 Object），跳过 super 调用
        if (realSuperName.isEmpty || realSuperName == 'Object' || _isRuntimeClassName(realSuperName)) {
          return;
        }
        if (!_userClasses.contains(realSuperName)) {
          return;
        }
        final cleanSuperName = _cleanName(realSuperName);
        final superCtorName = init.target.name.text.isEmpty ? 'new' : 'new_${_cleanName(init.target.name.text)}';
        final superFuncName = '${cleanSuperName}_$superCtorName';
        final args = init.arguments.positional.map((e) => _emitCppExpr(e)).join(', ');

        // 检查父类是否为模板类，需要传递模板参数
        String superTemplateArgs = '';
        final superCls = _classNodes[realSuperName];
        final superTypeParams = superCls?.typeParameters ?? [];
        if (superTypeParams.isNotEmpty) {
          // 尝试从当前类的 supertype 获取具体类型参数
          final clsNode = _classNodes[_currentClassName];
          if (clsNode != null && clsNode.supertype != null && clsNode.supertype!.typeArguments.isNotEmpty) {
            final typeArgs = clsNode.supertype!.typeArguments.map((t) => _cppType(t)).join(', ');
            superTemplateArgs = '<$typeArgs>';
          } else {
            superTemplateArgs = '<${superTypeParams.map((_) => 'AnyGC*').join(', ')}>';
          }
        }

        _implBuf.writeln('${_pad}${superFuncName}$superTemplateArgs(this_${args.isNotEmpty ? ", $args" : ""});');
      }
    }
  }

  // ==========================================================================
  // 方法
  // ==========================================================================

  void _emitCppMethod(String className, String structName, Procedure proc, {Class? classNode}) {
    // 保存并清除外部作用域的变量名映射（每个方法有独立作用域）
    final savedVarNameMappings = Map<String, String>.from(_variableNameMappings);
    final savedVariableTypeMap = Map<String, String>.from(_variableTypeMap);
    final savedDeclaredVariables = Set<String>.from(_declaredVariables);
    final savedExpectedMapKeyType = _expectedMapKeyType;
    final savedExpectedMapValueType = _expectedMapValueType;
    _variableNameMappings.clear();
    _declaredVariables.clear();
    _expectedMapKeyType = null;
    _expectedMapValueType = null;

    final cleanClassName = _cleanName(className);

    // 工厂构造函数特殊处理：生成为顶层函数 ClassName_new 或 ClassName_new_factoryName
    if (proc.isFactory) {
      _emitCppFactoryConstructor(className, structName, proc, classNode: classNode);
      // 恢复作用域
      _variableNameMappings
        ..clear()
        ..addAll(savedVarNameMappings);
      _variableTypeMap
        ..clear()
        ..addAll(savedVariableTypeMap);
      _declaredVariables
        ..clear()
        ..addAll(savedDeclaredVariables);
      return;
    }

    final methodName = _cleanMethodName(proc.name.text);
    // 根据方法类型确定函数名
    String funcName;
    if (proc.isGetter) {
      funcName = '${cleanClassName}_get_$methodName';
    } else if (proc.isSetter) {
      funcName = '${cleanClassName}_set_$methodName';
    } else {
      funcName = '${cleanClassName}_$methodName';
    }

    // 检查是否已经生成了该方法的实现（防止重复生成）
    if (_emittedImplementations.contains(funcName)) {
      // 恢复作用域
      _variableNameMappings
        ..clear()
        ..addAll(savedVarNameMappings);
      _variableTypeMap
        ..clear()
        ..addAll(savedVariableTypeMap);
      _declaredVariables
        ..clear()
        ..addAll(savedDeclaredVariables);
      _expectedMapKeyType = savedExpectedMapKeyType;
      _expectedMapValueType = savedExpectedMapValueType;
      return;
    }
    _emittedImplementations.add(funcName);

    final func = proc.function;

    // 检测 async 方法
    final isAsync = func.asyncMarker == AsyncMarker.Async;
    final isSyncStar = func.asyncMarker == AsyncMarker.SyncStar;
    final isAsyncStar = func.asyncMarker == AsyncMarker.AsyncStar;
    final isGenerator = isSyncStar || isAsyncStar;
    _isAsyncFunction = isAsync;
    _asyncBodyHasReturn = false;

    // 检查是否是模板类
    final typeParams = classNode?.typeParameters ?? [];
    final hasTemplate = typeParams.isNotEmpty;
    final templateArgs = hasTemplate
        ? '<${typeParams.map((tp) => tp.name ?? 'T').join(', ')}>'
        : '';

    // 确定返回类型
    String returnType;
    if (proc.isGetter) {
      returnType = _cppType(func.returnType);
    } else if (proc.isSetter) {
      returnType = 'void';
    } else if (isGenerator) {
      // sync*/async* 生成器：返回 StaticList<T>*
      final innerType = _extractIterableInnerType(func.returnType);
      returnType = 'StaticList<$innerType>*';
    } else {
      returnType = _cppType(func.returnType);
    }

    // async 方法：提取内部类型（Promise<T> 中的 T）
    if (isAsync && !proc.isGetter && !proc.isSetter) {
      final innerType = _extractPromiseInnerType(func.returnType);
      _asyncInnerType = innerType;
      // 确保返回类型是 Promise<InnerType>*
      // void → int: Promise<void> 已移除，始终用 innerType 重建返回类型
      returnType = 'Promise<$innerType>*';
    }

    // 如果返回类型是模板类本身，需要添加模板参数
    if (hasTemplate && returnType == '$structName*') {
      returnType = '$structName$templateArgs*';
    }

    _currentReturnType = returnType;
    _currentClassName = className;
    final savedInScopeTypeParams = _inScopeTypeParams;
    _inScopeTypeParams = {};

    // 跟踪函数返回类型（用于后续类型推断）
    _functionReturnTypes[funcName] = returnType;

    // 收集参数 - 使用具体结构体类型而非 AnyPtr
    final params = <String>[];
    if (!proc.isStatic) {
      // 运行时类使用运行时名称（如 Promise<T>*），用户类使用 ClassNameValue
      final thisType = _isRuntimeClassName(className)
          ? '$className$templateArgs'
          : '$structName$templateArgs';
      params.add('$thisType* this_');
    }

    for (final param in func.positionalParameters) {
      final paramType = _cppType(param.type);
      final paramName = _cleanName(param.name ?? 'p${params.length}');
      params.add('$paramType $paramName');
      _variableTypeMap[paramName] = paramType;
    }

    // 收集命名参数
    for (final param in func.namedParameters) {
      final paramType = _cppType(param.type);
      final paramName = _cleanName(param.name ?? 'p${params.length}');
      params.add('$paramType $paramName');
      _variableTypeMap[paramName] = paramType;
    }

    // 合并类和方法的类型参数（按 name 去重，避免 template<typename T, typename T>）
    final methodTypeParams = func.typeParameters;
    final allTypeParams = _deduplicateTypeParams([...typeParams, ...methodTypeParams]);
    _inScopeTypeParams = allTypeParams.map((tp) => tp.name ?? 'T').toSet();
    final combinedTemplatePrefix = allTypeParams.isNotEmpty
        ? 'template<${allTypeParams.map((tp) => 'typename ${tp.name ?? 'T'}').join(', ')}>'
        : '';

    // 函数实现（带模板前缀）
    if (combinedTemplatePrefix.isNotEmpty) {
      _implBuf.writeln(combinedTemplatePrefix);
    }
    _implBuf.writeln('$returnType $funcName(${params.join(', ')}) {');
    _indent = 1;

    // async 方法：创建 Promise 包装
    if (isAsync && !proc.isGetter && !proc.isSetter) {
      _implBuf.writeln('${_pad}auto _promise = GC::allocateLocal(new Promise<$_asyncInnerType>());');
    }

    // sync*/async* 生成器：创建结果列表
    if (isGenerator) {
      final innerType = _extractIterableInnerType(func.returnType);
      _currentGeneratorInnerType = innerType;
      _implBuf.writeln('${_pad}auto _result = GC::allocateLocal(new StaticList<$innerType>());');
    }

    // 函数体
    if (func.body != null) {
      // 对于 getter 函数，尝试检测简单的字段返回模式
      if (proc.isGetter && !proc.isStatic && classNode != null) {
        final bodyStr = _tryEmitGetterFieldReturn(func.body!, classNode);
        if (bodyStr != null) {
          _implBuf.writeln(bodyStr);
        } else {
          _emitCppStmt(func.body!, _implBuf);
        }
      } else {
        _emitCppStmt(func.body!, _implBuf);
      }
    }

    // async 方法：如果函数体没有 return，添加兜底 complete 和 return
    if (isAsync && !proc.isGetter && !proc.isSetter && !_asyncBodyHasReturn) {
      if (_asyncInnerType == 'int') {
        _implBuf.writeln('${_pad}promise_completeTyped(_promise, 0);');
      } else {
        _implBuf.writeln('${_pad}promise_complete(_promise, nullptr);');
      }
      _implBuf.writeln('${_pad}return _promise;');
    } else if (isGenerator) {
      // sync*/async* 生成器：返回收集的结果列表
      _implBuf.writeln('${_pad}return _result;');
    } else if (returnType != 'void' && (func.body == null || _isEmptyBody(func.body!))) {
      // 非 async 方法：如果函数体为空且返回类型不是 void，添加默认返回
      if (func.body == null && !proc.isGetter) {
        // 抽象方法（body == null）：抛出异常
        _implBuf.writeln('${_pad}throw DartUnimplementedError(dart_str("abstract method ${cleanClassName}.${proc.name.text}"));');
      } else if (proc.isGetter && !proc.isStatic) {
        // Getter 函数：如果默认值是空（模板类型参数），尝试返回字段
        final fieldName = _cleanName(methodName);
        final defaultReturn = _cppDefaultValue(returnType);
        if (defaultReturn.isEmpty) {
          // 模板类型参数的 getter — 生成 return this_->fieldName;
          _implBuf.writeln('${_pad}return this_->$fieldName;');
        } else {
          _implBuf.writeln('${_pad}return $defaultReturn;');
        }
      } else {
        final defaultReturn = _cppDefaultValue(returnType);
        if (defaultReturn.isEmpty) {
          // 模板类型参数：使用默认构造值
          _implBuf.writeln('${_pad}return $returnType{};');
        } else {
          _implBuf.writeln('${_pad}return $defaultReturn;');
        }
      }
    }

    _implBuf.writeln('}\n');
    _indent = 0;

    // 重置 async 标志
    _isAsyncFunction = false;

    // 恢复外部作用域的变量名映射和类型映射
    _variableNameMappings
      ..clear()
      ..addAll(savedVarNameMappings);
    _variableTypeMap
      ..clear()
      ..addAll(savedVariableTypeMap);
    _declaredVariables
      ..clear()
      ..addAll(savedDeclaredVariables);
    _expectedMapKeyType = savedExpectedMapKeyType;
    _expectedMapValueType = savedExpectedMapValueType;
    _inScopeTypeParams = savedInScopeTypeParams;
  }
  void _emitCppFactoryConstructor(String className, String structName, Procedure proc, {Class? classNode}) {
    final cleanClassName = _cleanName(className);
    final factoryName = proc.name.text;
    final funcName = factoryName.isEmpty
        ? '${cleanClassName}_new'
        : '${cleanClassName}_new_${_cleanName(factoryName)}';

    // 检查是否已经生成了该工厂构造函数的实现（防止重复生成）
    if (_emittedImplementations.contains(funcName)) {
      return;
    }
    _emittedImplementations.add(funcName);

    final func = proc.function;

    // 检查是否是模板类
    final typeParams = classNode?.typeParameters ?? [];
    final hasTemplate = typeParams.isNotEmpty;
    final templateArgs = hasTemplate
        ? '<${typeParams.map((tp) => tp.name ?? 'T').join(', ')}>'
        : '';
    final templatePrefix = hasTemplate
        ? 'template<${typeParams.map((tp) => 'typename ${tp.name ?? 'T'}').join(', ')}>'
        : '';

    // 确定返回类型 - 工厂构造函数返回类的实例
    final returnType = '$structName$templateArgs*';

    // 收集参数
    final params = <String>[];
    final paramsWithDefaults = <String>[];
    final requiredCount = func.requiredParameterCount;
    for (var i = 0; i < func.positionalParameters.length; i++) {
      final param = func.positionalParameters[i];
      final paramType = _cppType(param.type);
      final paramName = _cleanName(param.name ?? 'p${params.length}');
      params.add('$paramType $paramName');
      _variableTypeMap[paramName] = paramType;
      if (i >= requiredCount && param.initializer != null) {
        final defaultValue = _convertNullToType(_emitCppExpr(param.initializer!), paramType);
        paramsWithDefaults.add('$paramType $paramName = $defaultValue');
      } else {
        paramsWithDefaults.add('$paramType $paramName');
      }
    }

    // 收集命名参数
    for (final param in func.namedParameters) {
      final paramType = _cppType(param.type);
      final paramName = _cleanName(param.name ?? 'p${params.length}');
      params.add('$paramType $paramName');
      _variableTypeMap[paramName] = paramType;
      if (param.initializer != null) {
        final defaultValue = _convertNullToType(_emitCppExpr(param.initializer!), paramType);
        paramsWithDefaults.add('$paramType $paramName = $defaultValue');
      } else {
        paramsWithDefaults.add('$paramType $paramName');
      }
    }

    // 生成前向声明（使用带默认值的参数）
    final fwdDecl = templatePrefix.isNotEmpty
        ? '$templatePrefix $returnType $funcName(${paramsWithDefaults.join(', ')})'
        : '$returnType $funcName(${paramsWithDefaults.join(', ')})';
    _addForwardDecl(fwdDecl);

    // 函数实现
    if (templatePrefix.isNotEmpty) {
      _implBuf.writeln(templatePrefix);
    }
    _implBuf.writeln('$returnType $funcName(${params.join(', ')}) {');
    _indent = 1;

    // 函数体
    if (func.body != null) {
      _emitCppStmt(func.body!, _implBuf);
    }

    // 如果函数体为空，添加默认返回
    if (func.body == null || _isEmptyBody(func.body!)) {
      _implBuf.writeln('${_pad}auto* _obj = GC::allocateLocal(new $structName$templateArgs());');
      _implBuf.writeln('${_pad}_obj->AnyGC::_classInfo = &$structName$templateArgs::_classInfo;');
      _implBuf.writeln('${_pad}return _obj;');
    }

    _implBuf.writeln('}\n');
    _indent = 0;
  }

  bool _isEmptyBody(Statement stmt) {
    if (stmt is Block && stmt.statements.isEmpty) return true;
    if (stmt is EmptyStatement) return true;
    return false;
  }

  /// 检测 getter 函数体是否是简单的 `return this.field;` 模式
  /// 如果是，返回生成的 C++ 代码；否则返回 null
  String? _tryEmitGetterFieldReturn(Statement stmt, Class classNode) {
    ReturnStatement? retStmt;
    if (stmt is ReturnStatement) {
      retStmt = stmt;
    } else if (stmt is Block && stmt.statements.length == 1 && stmt.statements.first is ReturnStatement) {
      retStmt = stmt.statements.first as ReturnStatement;
    }
    if (retStmt == null || retStmt.expression == null) return null;

    final expr = retStmt.expression!;
    if (expr is InstanceGet) {
      // 检查接收器是否是 this
      if (expr.receiver is VariableGet) {
        final recv = expr.receiver as VariableGet;
        if (recv.variable.name == 'this' || recv.variable.name == '#this') {
          final fieldName = _cleanName(expr.name.text);
          // 验证字段确实存在于类中
          for (final f in classNode.fields) {
            if (_cleanName(f.name.text) == fieldName) {
              return '${_pad}return this_->$fieldName;';
            }
          }
        }
      }
    }
    return null;
  }

  // ==========================================================================
  // 顶层函数
  // ==========================================================================

  /// 为顶层函数生成前向声明（不生成实现）
  /// 用于在 wrapper 生成前提供正确的函数签名
  void _emitCppProcedureForwardDecl(Procedure proc) {
    final rawName = proc.name.text;
    if (rawName.contains('&')) return;

    final funcName = _cleanName(rawName);
    if (_emittedForwardDecls.any((decl) => decl.contains('$funcName('))) {
      return; // 已有正确的前向声明
    }

    final func = proc.function;
    final isAsync = func.asyncMarker == AsyncMarker.Async;
    final isSyncStar = func.asyncMarker == AsyncMarker.SyncStar;
    final isAsyncStar = func.asyncMarker == AsyncMarker.AsyncStar;
    final isMainFunc = funcName == 'main';

    String returnType;
    if (isMainFunc) {
      returnType = 'int';
    } else if (isSyncStar || isAsyncStar) {
      final innerType = _extractIterableInnerType(func.returnType);
      returnType = 'StaticList<$innerType>*';
    } else {
      returnType = _cppType(func.returnType);
    }
    if (isAsync && !isMainFunc) {
      final innerType = _extractPromiseInnerType(func.returnType);
      returnType = 'Promise<$innerType>*';
    }

    final typeParams = func.typeParameters;
    final templatePrefix = typeParams.isNotEmpty
        ? 'template<${typeParams.map((tp) => 'typename ${tp.name ?? 'T'}').join(', ')}>'
        : '';

    final params = <String>[];
    for (final param in func.positionalParameters) {
      final paramType = _cppType(param.type);
      final paramName = _cleanName(param.name ?? 'p${params.length}');
      params.add('$paramType $paramName');
    }
    for (final param in func.namedParameters) {
      final paramType = _cppType(param.type);
      final paramName = _cleanName(param.name ?? 'p${params.length}');
      params.add('$paramType $paramName');
    }

    final fwdDecl = templatePrefix.isNotEmpty
        ? '$templatePrefix $returnType $funcName(${params.join(', ')})'
        : '$returnType $funcName(${params.join(', ')})';
    _addForwardDecl(fwdDecl);

    _resolvedFuncReturnTypes[funcName] = returnType;
  }

  void _emitCppProcedure(Procedure proc) {
    final rawName = proc.name.text;
    // 跳过 mixin 应用类的 lowered 函数（合成类，由 mixin 初始化链处理）
    if (rawName.contains('&')) return;

    // 保存并清除外部作用域的变量名映射
    final savedVarNameMappings = Map<String, String>.from(_variableNameMappings);
    final savedVariableTypeMap = Map<String, String>.from(_variableTypeMap);
    final savedDeclaredVariables = Set<String>.from(_declaredVariables);
    final savedExpectedMapKeyType = _expectedMapKeyType;
    final savedExpectedMapValueType = _expectedMapValueType;
    _variableNameMappings.clear();
    _declaredVariables.clear();
    _expectedMapKeyType = null;
    _expectedMapValueType = null;

    final funcName = _cleanName(rawName);
    final func = proc.function;

    // 预分析 Box 化变量
    final savedBoxedVars = Set<VariableDeclaration>.from(_boxedVars);
    _preanalyzeCppBoxedVars(func);

    // 检测 async 函数
    final isAsync = func.asyncMarker == AsyncMarker.Async;
    final isSyncStar = func.asyncMarker == AsyncMarker.SyncStar;
    final isAsyncStar = func.asyncMarker == AsyncMarker.AsyncStar;
    final isGenerator = isSyncStar || isAsyncStar;
    _isAsyncFunction = isAsync;
    _asyncBodyHasReturn = false;

    // 特殊处理 main 函数：C++ 要求返回 int
    final isMainFunc = funcName == 'main';
    String returnType;
    if (isMainFunc) {
      returnType = 'int';
    } else if (isGenerator) {
      // sync*/async* 生成器：返回 StaticList<T>*
      final innerType = _extractIterableInnerType(func.returnType);
      returnType = 'StaticList<$innerType>*';
    } else {
      returnType = _cppType(func.returnType);
    }

    // async 函数：提取内部类型（Promise<T> 中的 T）
    if (isAsync && !isMainFunc) {
      final innerType = _extractPromiseInnerType(func.returnType);
      _asyncInnerType = innerType;
      // 确保返回类型是 Promise<InnerType>*
      if (!returnType.startsWith('Promise<')) {
        returnType = 'Promise<$innerType>*';
      }
    }

    _currentReturnType = returnType;
    _currentClassName = '';
    final savedInScopeTypeParams = _inScopeTypeParams;
    _inScopeTypeParams = func.typeParameters.map((tp) => tp.name ?? 'T').toSet();

    // 跟踪函数返回类型（用于后续类型推断）
    _functionReturnTypes[funcName] = returnType;

    // 收集类型参数
    final typeParams = func.typeParameters;
    final hasTemplate = typeParams.isNotEmpty;
    final templatePrefix = hasTemplate
        ? 'template<${typeParams.map((tp) => 'typename ${tp.name ?? 'T'}').join(', ')}>'
        : '';

    // 收集参数
    final params = <String>[];  // 用于实现（无默认值）
    final paramsWithDefaults = <String>[];  // 用于前向声明（有默认值）
    final requiredCount = func.requiredParameterCount;
    for (var i = 0; i < func.positionalParameters.length; i++) {
      final param = func.positionalParameters[i];
      final paramType = _cppType(param.type);
      final paramName = _cleanName(param.name ?? 'p${params.length}');
      params.add('$paramType $paramName');
      // 可选位置参数：添加默认值
      if (i >= requiredCount && param.initializer != null) {
        final defaultValue = _convertNullToType(_emitCppExpr(param.initializer!), paramType);
        paramsWithDefaults.add('$paramType $paramName = $defaultValue');
      } else {
        paramsWithDefaults.add('$paramType $paramName');
      }
    }

    // 收集命名参数
    for (final param in func.namedParameters) {
      final paramType = _cppType(param.type);
      final paramName = _cleanName(param.name ?? 'p${params.length}');
      params.add('$paramType $paramName');  // 实现中无默认值
      // 如果有默认值，在前向声明中添加
      if (param.initializer != null) {
        final defaultValue = _convertNullToType(_emitCppExpr(param.initializer!), paramType);
        paramsWithDefaults.add('$paramType $paramName = $defaultValue');
      } else {
        paramsWithDefaults.add('$paramType $paramName');
      }
    }

    // 前向声明（带模板前缀，使用带默认值的参数）
    final fwdDecl = templatePrefix.isNotEmpty
        ? '$templatePrefix $returnType $funcName(${paramsWithDefaults.join(', ')})'
        : '$returnType $funcName(${paramsWithDefaults.join(', ')})';
    _addForwardDecl(fwdDecl);

    // 函数实现（使用无默认值的参数）
    if (templatePrefix.isNotEmpty) {
      _implBuf.writeln('$templatePrefix');
    }
    _implBuf.writeln('$returnType $funcName(${params.join(', ')}) {');
    _indent = 1;

    if (isAsync && !isMainFunc) {
      // async 函数：包装在 Promise 中
      // 使用与返回类型匹配的 Promise 类型
      _implBuf.writeln('${_pad}auto _promise = GC::allocateLocal(new Promise<$_asyncInnerType>());');
      if (func.body != null) {
        _emitCppStmt(func.body!, _implBuf);
      }
      // 兜底: 如果函数体没有 return，确保 Promise 完成
      if (!_asyncBodyHasReturn) {
        if (_asyncInnerType == 'int') {
          _implBuf.writeln('${_pad}promise_completeTyped(_promise, 0);');
        } else {
          _implBuf.writeln('${_pad}promise_complete(_promise, nullptr);');
        }
        _implBuf.writeln('${_pad}return _promise;');
      }
    } else if (isGenerator) {
      // sync*/async* 生成器：创建结果列表，收集 yield 值，返回列表
      final innerType = _extractIterableInnerType(func.returnType);
      _currentGeneratorInnerType = innerType;
      _implBuf.writeln('${_pad}auto _result = GC::allocateLocal(new StaticList<$innerType>());');
      if (func.body != null) {
        _emitCppStmt(func.body!, _implBuf);
      }
      _implBuf.writeln('${_pad}return _result;');
    } else {
      if (func.body != null) {
        _emitCppStmt(func.body!, _implBuf);
      }
      if (isMainFunc) {
        // 程序退出前 GC 检查点：回收不可达对象并输出泄漏分析（stderr）
        _implBuf.writeln('${_pad}GC::collect();');
        _implBuf.writeln('${_pad}GC::reportAlive("exit");');
        _implBuf.writeln('${_pad}return 0;');
      } else if (returnType == 'void') {
        // 每个测试用例（void 顶层函数）结束时 GC 检查点：
        // 栈扫描 + root 化静态字段保证安全性，泄漏分析输出到 stderr
        _implBuf.writeln('${_pad}GC::collect();');
        _implBuf.writeln('${_pad}GC::reportAlive("$funcName");');
      }
    }

    _implBuf.writeln('}\n');
    _indent = 0;

    // 重置异步标志
    _isAsyncFunction = false;
    _asyncInnerType = 'AnyGC*';
    _currentGeneratorInnerType = null;

    // 恢复 Box 化变量集合
    _boxedVars
      ..clear()
      ..addAll(savedBoxedVars);

    // 恢复外部作用域的变量名映射和类型映射
    _variableNameMappings
      ..clear()
      ..addAll(savedVarNameMappings);
    _variableTypeMap
      ..clear()
      ..addAll(savedVariableTypeMap);
    _declaredVariables
      ..clear()
      ..addAll(savedDeclaredVariables);
    _expectedMapKeyType = savedExpectedMapKeyType;
    _expectedMapValueType = savedExpectedMapValueType;
    _inScopeTypeParams = savedInScopeTypeParams;
  }

  /// 从 Future/Promise 类型中提取内部类型
  String _extractPromiseInnerType(DartType type) {
    if (type is InterfaceType) {
      if (type.classNode.name == 'Future' || type.classNode.name == '_Future') {
        if (type.typeArguments.isNotEmpty) {
          final inner = _cppType(type.typeArguments[0]);
          // void → int: 所有异步方法默认有返回值，void 更改为 int
          if (inner == 'void') return 'int';
          return inner;
        }
      }
    }
    if (type is FutureOrType) {
      final inner = _cppType(type.typeArgument);
      if (inner == 'void') return 'int';
      return inner;
    }
    // 无法提取时，使用 AnyPtr
    return 'AnyGC*';
  }

  String _extractIterableInnerType(DartType type) {
    if (type is InterfaceType) {
      final name = type.classNode.name;
      if (name == 'Iterable' || name == 'List' || name == 'StaticList' ||
          name == '_Iterable' || name == '_List' || name == '_GrowableList') {
        if (type.typeArguments.isNotEmpty) {
          return _cppType(type.typeArguments[0]);
        }
      }
    }
    return 'AnyGC*';
  }

  // ==========================================================================
  // 顶层字段
  // ==========================================================================

  void _emitCppTopLevelField(Field field) {
    final fieldName = _cleanName(field.name.text);
    final fieldType = _cppType(field.type);

    // 添加前向声明（变量可能在定义前被使用）
    _addForwardDecl('extern $fieldType $fieldName');

    if (field.initializer != null) {
      final value = _emitCppExpr(field.initializer!);
      _implBuf.writeln('$fieldType $fieldName = $value;');
    } else {
      final defaultVal = _cppDefaultValue(fieldType);
      _implBuf.writeln('$fieldType $fieldName\{$defaultVal\};');
    }
    _implBuf.writeln();
  }

  // ==========================================================================
  // 枚举
  // ==========================================================================

  void _emitCppEnum(Class cls) {
    final enumName = cls.name;
    if (!_emittedStructs.add(enumName)) return;

    _addForwardDecl(enumName);

    // 收集枚举值
    final enumValues = <String>[];
    for (final field in cls.fields) {
      if (field.isStatic && field.isConst) {
        enumValues.add(field.name.text);
      }
    }

    // 收集自定义字段（非静态、非 const、非内部字段）
    final customFields = <Field>[];
    for (final field in cls.fields) {
      if (!field.isStatic && field.name.text != '_name' && field.name.text != '_index' &&
          !field.name.text.startsWith('_')) {
        customFields.add(field);
      }
    }

    // 收集枚举方法/getter（排除构造函数、合成访问器和内置 name/index getter）
    final enumProcs = cls.procedures.where((p) =>
        !p.isFactory && !p.isStatic &&
        p.name.text != 'name' && p.name.text != 'index' &&
        !p.name.text.startsWith('_')).toList();

    // 生成枚举结构体
    // 先生成 ClassInfo 结构体（如果有自定义方法）
    if (enumProcs.isNotEmpty) {
      _structBuf.writeln('struct ${enumName}ClassInfo : ClassInfo {');
      for (final proc in enumProcs) {
        final methodName = _cleanMethodName(proc.name.text);
        String fieldName;
        int argCount;
        if (proc.isGetter) {
          fieldName = 'get_$methodName';
          argCount = 0;
        } else if (proc.isSetter) {
          fieldName = 'set_$methodName';
          argCount = 1;
        } else {
          fieldName = methodName;
          argCount = proc.function.positionalParameters.length + proc.function.namedParameters.length;
        }
        final retType = _procReturnType(proc, isSetter: proc.isSetter);
        _structBuf.writeln('    ${_classInfoFieldDecl(fieldName, argCount, retType: retType)};');
      }
      _structBuf.writeln('    ${enumName}ClassInfo() { typeName = "$enumName"; }');
      _structBuf.writeln('};');
      _structBuf.writeln();
    }

    _structBuf.writeln('struct $enumName : AnyGC {');
    _structBuf.writeln('    DartString _name;');
    _structBuf.writeln('    int64_t _index;');
    // 自定义字段
    for (final field in customFields) {
      final fieldName = _cleanName(field.name.text);
      final fieldType = _cppType(field.type);
      final defaultVal = _cppDefaultValue(fieldType);
      _structBuf.writeln('    $fieldType $fieldName\{$defaultVal\};');
    }
    _structBuf.writeln();

    // ClassInfo 支持（用于方法派发）
    if (enumProcs.isNotEmpty) {
      _structBuf.writeln('    static ${enumName}ClassInfo _classInfo;');
      _structBuf.writeln();
    }

    for (final val in enumValues) {
      final cleanVal = _cleanName(val);
      _structBuf.writeln('    static $enumName* $cleanVal;');
    }
    _structBuf.writeln();

    // 构造函数（含自定义字段参数）
    final ctorParams = <String>['DartString n', 'int64_t i'];
    final ctorInits = <String>['_name(std::move(n))', '_index(i)'];
    for (final field in customFields) {
      final fieldName = _cleanName(field.name.text);
      final fieldType = _cppType(field.type);
      ctorParams.add('$fieldType $fieldName');
      ctorInits.add('$fieldName($fieldName)');
    }
    // 设置 ClassInfo 指针（用于方法派发）
    final ciInit = enumProcs.isNotEmpty ? ' AnyGC::_classInfo = &_classInfo;' : '';
    _structBuf.writeln('    $enumName(${ctorParams.join(', ')}) : ${ctorInits.join(', ')} {$ciInit}');
    _structBuf.writeln();

    _structBuf.writeln('    DartString toString() const override { return "$enumName." + _name; }');
    _structBuf.writeln('};');
    _structBuf.writeln();

    // ClassInfo 静态成员定义
    if (enumProcs.isNotEmpty) {
      _structBuf.writeln('${enumName}ClassInfo $enumName::_classInfo;');
      _structBuf.writeln();
    }

    // 静态实例 (不使用 GC，枚举值是全局常量，生命周期与程序相同)
    for (var i = 0; i < enumValues.length; i++) {
      final cleanVal = _cleanName(enumValues[i]);
      // 从枚举值的 InstanceConstant 初始化器中提取自定义字段值
      final ctorArgs = <String>['"$cleanVal"', '$i'];
      if (customFields.isNotEmpty) {
        final fieldConst = cls.fields.firstWhere(
            (f) => f.name.text == enumValues[i], orElse: () => cls.fields.first);
        final initExpr = fieldConst.initializer;
        if (initExpr is ConstantExpression && initExpr.constant is InstanceConstant) {
          final instConst = initExpr.constant as InstanceConstant;
          final fieldValues = <String, Constant>{};
          for (final entry in instConst.fieldValues.entries) {
            fieldValues[entry.key.asField.name.text] = entry.value;
          }
          for (final field in customFields) {
            final fv = fieldValues[field.name.text];
            if (fv != null) {
              ctorArgs.add(_emitCppConstant(fv));
            } else {
              ctorArgs.add(_cppDefaultValue(_cppType(field.type)));
            }
          }
        } else {
          for (final field in customFields) {
            ctorArgs.add(_cppDefaultValue(_cppType(field.type)));
          }
        }
      }
      _structBuf.writeln('$enumName* $enumName::$cleanVal = new $enumName(${ctorArgs.join(', ')});');
      _enumConstantIndices['$enumName.${enumValues[i]}'] = i;
    }
    _structBuf.writeln();

    // 生成枚举方法作为顶层函数 + vptr wrapper + 注册
    for (final proc in enumProcs) {
      final methodName = _cleanMethodName(proc.name.text);
      String funcName;
      String vptrKey;
      if (proc.isGetter) {
        funcName = '${enumName}_get_$methodName';
        vptrKey = 'get_$methodName';
      } else if (proc.isSetter) {
        funcName = '${enumName}_set_$methodName';
        vptrKey = 'set_$methodName';
      } else if (_isOperatorName(proc.name.text)) {
        funcName = '${enumName}_$methodName';
        vptrKey = proc.name.text;
      } else {
        funcName = '${enumName}_$methodName';
        vptrKey = methodName;
      }

      if (!_emittedImplementations.add(funcName)) continue;

      final func = proc.function;
      final returnType = proc.isSetter ? 'void' : _cppType(func.returnType);
      _currentReturnType = returnType;
      _currentClassName = enumName;

      // 参数列表
      final params = <String>['$enumName* this_'];
      for (final param in func.positionalParameters) {
        final paramType = _cppType(param.type);
        final paramName = _cleanName(param.name ?? 'p${params.length}');
        params.add('$paramType $paramName');
      }

      // 前向声明
      _addForwardDecl('$returnType $funcName(${params.join(', ')})');

      // 函数实现
      final savedVarNameMappings = Map<String, String>.from(_variableNameMappings);
      final savedVariableTypeMap = Map<String, String>.from(_variableTypeMap);
      final savedDeclaredVariables = Set<String>.from(_declaredVariables);
      _variableNameMappings.clear();
      _declaredVariables.clear();

      _implBuf.writeln('$returnType $funcName(${params.join(', ')}) {');
      _indent = 1;
      if (func.body != null) {
        _emitCppStmt(func.body!, _implBuf);
      }
      _implBuf.writeln('}\n');

      _variableNameMappings
        ..clear()
        ..addAll(savedVarNameMappings);
      _variableTypeMap
        ..clear()
        ..addAll(savedVariableTypeMap);
      _declaredVariables
        ..clear()
        ..addAll(savedDeclaredVariables);

      // vptr wrapper（统一 AnyGC*/AnyGC* 签名）
      final wrapperName = '_vptr_wrap_${enumName}_${proc.isGetter ? 'get_' : proc.isSetter ? 'set_' : ''}$methodName';
      final wrapperParams = <String>['AnyGC* obj__'];
      for (var i = 0; i < func.positionalParameters.length; i++) {
        wrapperParams.add('AnyGC* arg$i');
      }
      final castArgs = <String>[];
      for (var i = 0; i < func.positionalParameters.length; i++) {
        final paramType = _cppType(func.positionalParameters[i].type);
        if (paramType == 'int64_t') {
          castArgs.add('dynAs<int64_t>(arg$i)');
        } else if (paramType == 'double') {
          castArgs.add('dynAs<double>(arg$i)');
        } else if (paramType == 'bool') {
          castArgs.add('dynAs<bool>(arg$i)');
        } else if (paramType == 'DartString') {
          castArgs.add('dynAs<DartString>(arg$i)');
        } else if (paramType.endsWith('*')) {
          castArgs.add('static_cast<$paramType>(arg$i)');
        } else {
          castArgs.add('dynAs<$paramType>(arg$i)');
        }
      }
      final callExpr = '$funcName(static_cast<$enumName*>(obj__)${castArgs.isNotEmpty ? ", ${castArgs.join(', ')}" : ""})';
      final wrapRetType = returnType == 'void' ? 'void'
          : returnType == 'bool' ? 'bool'
          : returnType == 'int64_t' ? 'int64_t'
          : 'AnyGC*';
      _implBuf.writeln('$wrapRetType $wrapperName(${wrapperParams.join(', ')}) {');
      if (wrapRetType == 'void') {
        _implBuf.writeln('    $callExpr;');
      } else if (wrapRetType == 'bool' || wrapRetType == 'int64_t') {
        _implBuf.writeln('    return $callExpr;');
      } else if (returnType == 'int64_t' || returnType == 'double' ||
                 returnType == 'bool' || returnType == 'DartString') {
        _implBuf.writeln('    return _box($callExpr);');
      } else if (returnType.endsWith('*')) {
        _implBuf.writeln('    return _box($callExpr);');
      } else {
        _implBuf.writeln('    return _box($callExpr);');
      }
      _implBuf.writeln('}\n');

      // 注册到 ClassInfo（在第一个枚举值初始化后）
      _implBuf.writeln('static bool _${enumName}_${methodName}_registered = []{ $enumName::_classInfo.$vptrKey = &$wrapperName; return true; }();');
    }
  }

  // ==========================================================================
  // Mixin 处理
  // ==========================================================================

  void _emitCppMixin(Class cls) {
    final mixinName = _cleanName(cls.name);
    final structName = '${mixinName}Mixin';

    if (!_emittedStructs.add(structName)) return;

    // 检查是否有类型参数
    final typeParams = cls.typeParameters;
    final hasTemplate = typeParams.isNotEmpty;
    final templatePrefix = hasTemplate
        ? 'template<${typeParams.map((tp) => 'typename ${tp.name ?? 'T'}').join(', ')}>'
        : '';

    // Mixin 作为独立的 struct，包含 vptr 支持和字段
    // 继承 AnyGC 以支持作为 AnyGC* 参数传递
    // 先生成 ClassInfo 结构体
    final mixinProcs = cls.procedures.where((p) =>
        !p.isFactory && !p.isStatic &&
        !p.name.text.startsWith('_')).toList();
    if (templatePrefix.isNotEmpty) {
      _structBuf.writeln('$templatePrefix');
    }
    _structBuf.writeln('struct ${structName}ClassInfo : ClassInfo {');
    for (final proc in mixinProcs) {
      final methodName = _cleanMethodName(proc.name.text);
      String fieldName;
      int argCount;
      if (proc.isGetter) {
        fieldName = 'get_$methodName';
        argCount = 0;
      } else if (proc.isSetter) {
        fieldName = 'set_$methodName';
        argCount = 1;
      } else {
        fieldName = methodName;
        argCount = proc.function.positionalParameters.length + proc.function.namedParameters.length;
      }
      _structBuf.writeln('    ${_classInfoFieldDecl(fieldName, argCount, retType: _procReturnType(proc, isSetter: proc.isSetter))};');
    }
    _structBuf.writeln('    ${structName}ClassInfo() { typeName = "$structName"; }');
    _structBuf.writeln('};');
    _structBuf.writeln();

    if (templatePrefix.isNotEmpty) {
      _structBuf.writeln('$templatePrefix');
    }
    _structBuf.writeln('struct $structName : AnyGC {');
    if (hasTemplate) {
      final tplArgs = '<${typeParams.map((tp) => tp.name ?? 'T').join(', ')}>';
      _structBuf.writeln('    static ${structName}ClassInfo$tplArgs _classInfo;');
    } else {
      _structBuf.writeln('    static ${structName}ClassInfo _classInfo;');
    }
    // Mixin 字段
    for (final field in cls.fields) {
      if (!field.isStatic) {
        final fieldName = _cleanName(field.name.text);
        final fieldType = _cppType(field.type);
        final defaultVal = _cppDefaultValue(fieldType);
        _structBuf.writeln('    $fieldType $fieldName\{$defaultVal\};');
      }
    }
    _structBuf.writeln('};');
    // 静态成员定义（模板类使用 template 前缀）
    if (hasTemplate) {
      final templateDecl = 'template<${typeParams.map((tp) => 'typename ${tp.name ?? 'T'}').join(', ')}>';
      final tplArgs = '<${typeParams.map((tp) => tp.name ?? 'T').join(', ')}>';
      _structBuf.writeln('$templateDecl ${structName}ClassInfo$tplArgs $structName$tplArgs::_classInfo;');
    } else {
      _structBuf.writeln('${structName}ClassInfo $structName::_classInfo;');
    }
    // Mixin 的静态字段声明为全局变量
    for (final field in cls.fields) {
      if (field.isStatic && !field.isConst) {
        final fieldName = _cleanName(field.name.text);
        final fieldType = _cppType(field.type);
        // 添加前向声明（方法的前向声明可能引用这些变量）
        _addForwardDecl('extern $fieldType $fieldName');
        if (field.initializer != null) {
          // 设置期望的集合类型上下文，确保初始化器使用正确的类型参数
          String? savedMapKeyType, savedMapValueType, savedCollElemType;
          final dartType = field.type;
          if (dartType is InterfaceType) {
            final clsName = dartType.classNode.name;
            if ((clsName == 'Map' || clsName == 'StaticMap') && dartType.typeArguments.length >= 2) {
              savedMapKeyType = _expectedMapKeyType;
              savedMapValueType = _expectedMapValueType;
              _expectedMapKeyType = _cppType(dartType.typeArguments[0]);
              _expectedMapValueType = _cppType(dartType.typeArguments[1]);
            } else if ((clsName == 'List' || clsName == 'StaticList' || clsName == 'Set' || clsName == 'StaticSet') && dartType.typeArguments.isNotEmpty) {
              savedCollElemType = _expectedCollectionElementType;
              _expectedCollectionElementType = _cppType(dartType.typeArguments[0]);
            }
          }
          final initVal = _emitCppExpr(field.initializer!);
          // 恢复期望的类型上下文
          if (savedMapKeyType != null || savedMapValueType != null) {
            _expectedMapKeyType = savedMapKeyType;
            _expectedMapValueType = savedMapValueType;
          }
          if (savedCollElemType != null) {
            _expectedCollectionElementType = savedCollElemType;
          }
          _implBuf.writeln('$fieldType $fieldName = $initVal;');
        } else {
          final defaultVal = _cppDefaultValue(fieldType);
          _implBuf.writeln('$fieldType $fieldName\{$defaultVal\};');
        }
      }
    }
    _structBuf.writeln();

    // Mixin 方法生成为静态函数
    for (final proc in cls.procedures) {
      final methodName = _cleanMethodName(proc.name.text);
      final funcName = '${mixinName}_$methodName';
      final func = proc.function;

      // 确定返回类型
      String returnType;
      if (proc.isGetter) {
        returnType = _cppType(func.returnType);
      } else if (proc.isSetter) {
        returnType = 'void';
      } else {
        returnType = _cppType(func.returnType);
      }
      // async 方法：覆盖返回类型为 Promise<innerType>*
      final isMixinAsync = func.asyncMarker == AsyncMarker.Async;
      if (isMixinAsync && !proc.isGetter && !proc.isSetter) {
        final innerType = _extractPromiseInnerType(func.returnType);
        returnType = 'Promise<$innerType>*';
      }

      // 收集参数 - 使用具体结构体类型
      final params = <String>[];
      if (!proc.isStatic) {
        final mixinTemplateArgs = hasTemplate
            ? '<${typeParams.map((tp) => tp.name ?? 'T').join(', ')}>'
            : '';
        params.add('$structName$mixinTemplateArgs* this_');
      }

      for (final param in func.positionalParameters) {
        final paramType = _cppType(param.type);
        final paramName = _cleanName(param.name ?? 'p${params.length}');
        params.add('$paramType $paramName');
      }

      // 收集方法级别的类型参数（与类的类型参数合并，按 name 去重）
      final methodTypeParams = func.typeParameters;
      final allTypeParams = _deduplicateTypeParams([...typeParams, ...methodTypeParams]);
      final methodHasTemplate = allTypeParams.isNotEmpty;
      final methodTemplateDecl = methodHasTemplate
          ? 'template<${allTypeParams.map((tp) => 'typename ${tp.name ?? 'T'}').join(', ')}>'
          : '';

      // 前向声明
      final fwdDecl = methodTemplateDecl.isNotEmpty
          ? '$methodTemplateDecl $returnType $funcName(${params.join(', ')})'
          : '$returnType $funcName(${params.join(', ')})';
      _addForwardDecl(fwdDecl);

      // 函数实现
      if (methodTemplateDecl.isNotEmpty) {
        _implBuf.writeln(methodTemplateDecl);
      }
      _implBuf.writeln('$returnType $funcName(${params.join(', ')}) {');
      _indent = 1;

      // 检测 async 方法
      final isAsync = func.asyncMarker == AsyncMarker.Async;
      final savedIsAsync = _isAsyncFunction;
      final savedAsyncHasReturn = _asyncBodyHasReturn;
      final savedAsyncInnerType = _asyncInnerType;
      _isAsyncFunction = isAsync;
      _asyncBodyHasReturn = false;

      // async 方法：提取内部类型（Promise<T> 中的 T）
      if (isAsync) {
        _asyncInnerType = _extractPromiseInnerType(func.returnType);
      }

      // 设置当前返回类型（确保 return 语句正确处理）
      final savedReturnType = _currentReturnType;
      _currentReturnType = returnType;
      final savedClassName = _currentClassName;
      _currentClassName = mixinName;
      final savedInScopeTypeParams = _inScopeTypeParams;
      _inScopeTypeParams = allTypeParams.map((tp) => tp.name ?? 'T').toSet();

      // async 方法：创建 Promise 包装
      if (isAsync) {
        _implBuf.writeln('${_pad}auto _promise = GC::allocateLocal(new Promise<$_asyncInnerType>());');
      }

      // 函数体
      if (func.body != null) {
        _emitCppStmt(func.body!, _implBuf);
      }

      // async 方法：如果函数体没有 return，添加兜底 complete 和 return
      if (isAsync && !_asyncBodyHasReturn) {
        if (_asyncInnerType == 'int') {
          _implBuf.writeln('${_pad}promise_completeTyped(_promise, 0);');
        } else {
          _implBuf.writeln('${_pad}promise_complete(_promise, nullptr);');
        }
        _implBuf.writeln('${_pad}return _promise;');
      }

      // 如果函数体为空且返回类型不是 void，添加默认返回
      if (!isAsync && returnType != 'void' && (func.body == null || _isEmptyBody(func.body!))) {
        if (func.body == null && !proc.isGetter) {
          // 抽象方法（body == null）：抛出异常
          _implBuf.writeln('${_pad}throw DartUnimplementedError(dart_str("abstract method ${mixinName}.${proc.name.text}"));');
        } else if (proc.isGetter && !proc.isStatic) {
          // Getter 函数：检查是否有对应字段
          final fieldName = _cleanName(methodName);
          final hasField = cls.fields.any((f) => _cleanName(f.name.text) == fieldName);
          if (hasField) {
            _implBuf.writeln('${_pad}return this_->$fieldName;');
          } else {
            final defaultReturn = _cppDefaultValue(returnType);
            if (defaultReturn.isEmpty) {
              _implBuf.writeln('${_pad}return $returnType{};');
            } else {
              _implBuf.writeln('${_pad}return $defaultReturn;');
            }
          }
        } else {
          final defaultReturn = _cppDefaultValue(returnType);
          if (defaultReturn.isEmpty) {
            _implBuf.writeln('${_pad}return $returnType{};');
          } else {
            _implBuf.writeln('${_pad}return $defaultReturn;');
          }
        }
      }

      _implBuf.writeln('}\n');
      _indent = 0;
      _currentReturnType = savedReturnType;
      _currentClassName = savedClassName;
      _inScopeTypeParams = savedInScopeTypeParams;
      _isAsyncFunction = savedIsAsync;
      _asyncBodyHasReturn = savedAsyncHasReturn;
      _asyncInnerType = savedAsyncInnerType;
    }

    _structBuf.writeln();
  }

  // ==========================================================================
  // 表达式生成
  // ==========================================================================

  String _emitCppExpr(Expression expr) {
    if (expr is IntLiteral) return '${expr.value}LL';
    if (expr is DoubleLiteral) {
      final val = expr.value.toString();
      return val.contains('.') ? val : '$val.0';
    }
    if (expr is BoolLiteral) return expr.value ? 'true' : 'false';
    if (expr is StringLiteral) return _cppStringLiteral(expr.value);
    if (expr is NullLiteral) return 'nullptr';

    if (expr is VariableGet) return _emitCppVariableGet(expr);
    if (expr is VariableSet) return _emitCppVariableSet(expr);
    if (expr is ThisExpression) return 'this_';

    if (expr is InstanceGet) return _emitCppInstanceGet(expr);
    if (expr is InstanceSet) return _emitCppInstanceSet(expr);
    if (expr is InstanceInvocation) {
      return _emitCppInstanceInvocation(expr);
    }
    if (expr is StaticInvocation) return _emitCppStaticInvocation(expr);
    if (expr is ConstructorInvocation) return _emitCppConstructorInvocation(expr);

    if (expr is StringConcatenation) return _emitCppStringConcat(expr);
    if (expr is ConditionalExpression) return _emitCppConditional(expr);
    if (expr is LogicalExpression) return _emitCppLogical(expr);
    if (expr is Not) return '!(${_emitCppExpr(expr.operand)})';

    if (expr is ListLiteral) return _emitCppListLiteral(expr);
    if (expr is MapLiteral) return _emitCppMapLiteral(expr);
    if (expr is SetLiteral) return _emitCppSetLiteral(expr);

    if (expr is AsExpression) return _emitCppAsExpression(expr);
    if (expr is IsExpression) return _emitCppIsExpression(expr);
    if (expr is NullCheck) return _emitCppExpr(expr.operand);

    if (expr is FunctionExpression) return _emitCppFunctionExpression(expr);
    if (expr is FunctionInvocation) return _emitCppFunctionInvocation(expr);

    if (expr is AwaitExpression) return _emitCppAwait(expr);
    if (expr is Throw) return _emitCppThrow(expr);

    if (expr is StaticGet) return _emitCppStaticGet(expr);
    if (expr is StaticSet) return _emitCppStaticSet(expr);

    if (expr is EqualsCall) {
      final left = _emitCppExpr(expr.left);
      final right = _emitCppExpr(expr.right);
      // 当比较 map[key] == null 时，检查指针而不是解引用的值
      if ((right == 'nullptr') && left.startsWith('(*(*') && left.endsWith(')')) {
        // 移除外层解引用：(*(*map)[key]) -> (*map)[key]
        final ptrExpr = left.substring(2, left.length - 1);
        return '(dart_isNull($ptrExpr))';
      }
      if ((left == 'nullptr') && right.startsWith('(*(*') && right.endsWith(')')) {
        final ptrExpr = right.substring(2, right.length - 1);
        return '(dart_isNull($ptrExpr))';
      }
      // 获取操作数类型信息
      final leftType = _getExpressionType(expr.left);
      final rightType = _getExpressionType(expr.right);
      final leftCppType = leftType != null ? _cppType(leftType) : '';
      final rightCppType = rightType != null ? _cppType(rightType) : '';
      // AnyGC* 与具体类型比较：拆箱
      // 排除已被 _unboxElem<> 或 dynAs<> 转换为具体类型的表达式
      // 当类型是 AnyGC*、类型未知、或表达式是直接 ClassInfo 派发结果时，需要拆箱
      // 但 raw-returning ClassInfo dispatch (get_length→int64_t, contains→bool) 不需要
      final leftAlreadyUnboxed = left.startsWith('dynAs<') || left.startsWith('_unboxElem<');
      final rightAlreadyUnboxed = right.startsWith('dynAs<') || right.startsWith('_unboxElem<');
      // ClassInfo dispatch returning AnyGC* (e.g., toString) is not raw even if Dart type maps to raw
      final leftIsAnyGCDispatch = _isDirectClassInfoDispatchResult(left) &&
          !_isRawReturnClassInfoDispatch(left);
      final rightIsAnyGCDispatch = _isDirectClassInfoDispatchResult(right) &&
          !_isRawReturnClassInfoDispatch(right);
      final leftIsRawDispatch = _isDirectClassInfoDispatchResult(left) &&
          _isRawReturnClassInfoDispatch(left);
      final rightIsRawDispatch = _isDirectClassInfoDispatchResult(right) &&
          _isRawReturnClassInfoDispatch(right);
      final leftIsRawType = !leftIsAnyGCDispatch && (leftCppType == 'int64_t' || leftCppType == 'bool' ||
          leftCppType == 'double' || leftCppType == 'DartString');
      final rightIsRawType = !rightIsAnyGCDispatch && (rightCppType == 'int64_t' || rightCppType == 'bool' ||
          rightCppType == 'double' || rightCppType == 'DartString');
      final leftIsAnyGC = !leftAlreadyUnboxed && !leftIsRawType && !leftIsRawDispatch &&
          (leftCppType == 'AnyGC*' || _isDirectClassInfoDispatchResult(left) ||
           (leftCppType.isEmpty && (_isAnyGCPtrExpr(left) || left.contains('_classInfo'))));
      final rightIsAnyGC = !rightAlreadyUnboxed && !rightIsRawType && !rightIsRawDispatch &&
          (rightCppType == 'AnyGC*' || _isDirectClassInfoDispatchResult(right) ||
           (rightCppType.isEmpty && (_isAnyGCPtrExpr(right) || right.contains('_classInfo'))));
      if (leftIsAnyGC && !rightIsAnyGC) {
        final unwrapped = _unwrapAnyGCForComparison(left, right);
        if (unwrapped != null) return '($unwrapped == $right)';
        // 特殊处理：index 派发结果与 int 比较
        if (left.contains('->index(') && RegExp(r'^-?\d+(LL)?$').hasMatch(right)) {
          return '(dynAs<int64_t>($left) == $right)';
        }
      }
      if (rightIsAnyGC && !leftIsAnyGC) {
        final unwrapped = _unwrapAnyGCForComparison(right, left);
        if (unwrapped != null) return '($left == $unwrapped)';
        // 特殊处理：index 派发结果与 int 比较
        if (right.contains('->index(') && RegExp(r'^-?\d+(LL)?$').hasMatch(left)) {
          return '($left == dynAs<int64_t>($right))';
        }
      }
      // 集合类型：通过 ClassInfo 派发 == 运算符
      if (leftType is InterfaceType) {
        final typeName = leftType.classNode.name;
        final isListType = typeName == 'List' || typeName == 'StaticList' ||
            typeName == '_List' || typeName == '_GrowableList' ||
            typeName == 'Iterable' || typeName == '_Iterable';
        final isMapType = typeName == 'Map' || typeName == 'StaticMap' || typeName == '_Map';
        final isSetType = typeName == 'Set' || typeName == 'StaticSet' || typeName == '_Set';
        if (isListType || isMapType || isSetType) {
          return 'static_cast<AnyGC*>($left)->_classInfo->eq(static_cast<AnyGC*>($left), static_cast<AnyGC*>($right))';
        }
      }
      // 用户类（AnyGC 子类）：通过 ClassInfo 派发 == 运算符
      if (leftType is InterfaceType && _userClasses.contains(leftType.classNode.name)) {
        return 'static_cast<AnyGC*>($left)->_classInfo->eq(static_cast<AnyGC*>($left), _box($right))';
      }
      return '($left == $right)';
    }
    if (expr is EqualsNull) {
      final operand = _emitCppExpr(expr.expression);
      // 当检查 map[key] == null 时，检查指针而不是解引用的值
      if (operand.startsWith('(*(*') && operand.endsWith(')')) {
        final ptrExpr = operand.substring(2, operand.length - 1);
        return '(dart_isNull($ptrExpr))';
      }
      // ClassInfo index dispatch: map[key] via ->index() returns nullptr for missing keys
      if (operand.contains('->index(')) {
        String rawExpr = operand;
        // Unwrap dynAs<T>(...), static_cast<T>(...), _unboxElem<T>(...)
        if (operand.startsWith('dynAs<') || operand.startsWith('static_cast<') || operand.startsWith('_unboxElem<')) {
          int startIdx = operand.startsWith('_unboxElem<') ? 11 : (operand.startsWith('static_cast<') ? 12 : 6);
          int depth = 1;
          int closeIdx = -1;
          for (int i = startIdx; i < operand.length; i++) {
            if (operand[i] == '<') depth++;
            else if (operand[i] == '>') { depth--; if (depth == 0) { closeIdx = i; break; } }
          }
          if (closeIdx >= 0 && closeIdx + 1 < operand.length && operand[closeIdx + 1] == '(') {
            rawExpr = operand.substring(closeIdx + 2, operand.length - 1);
          }
        }
        if (rawExpr.contains('->index(')) {
          return '(dart_isNull($rawExpr))';
        }
      }
      // 根据类型选择不同的空值检查方式
      final type = _getExpressionType(expr.expression);
      if (type != null) {
        final cppType = _cppType(type);
        // 对于 AnyGC* 类型，使用 dart_isNull
        if (cppType == 'AnyGC*') {
          return '(dart_isNull($operand))';
        }
        // 对于指针类型，使用 dart_isNull
        if (cppType.endsWith('*')) {
          return '(dart_isNull($operand))';
        }
        // 对于基本类型（int, double, bool），它们不能为 null
        if (cppType == 'int64_t' || cppType == 'double' || cppType == 'bool') {
          return 'false';  // 基本类型不能为 null
        }
        // DartString：可空类型用 empty() 检查（null 表示为空字符串）
        if (cppType == 'DartString') {
          if (type.nullability == Nullability.nullable) {
            return '($operand.empty())';
          }
          return 'false';
        }
      }
      // 默认使用 dart_isNull
      return '(dart_isNull($operand))';
    }

    if (expr is Let) return _emitCppLet(expr);
    if (expr is ConstantExpression) return _emitCppConstant(expr.constant);
    if (expr is BlockExpression) return _emitCppBlockExpression(expr);

    // Super access expressions
    if (expr is SuperPropertyGet) return _emitCppSuperPropertyGet(expr);
    if (expr is SuperMethodInvocation) return _emitCppSuperMethodInvocation(expr);
    if (expr is SuperPropertySet) return _emitCppSuperPropertySet(expr);
    if (expr is AbstractSuperPropertyGet) return _emitCppAbstractSuperPropertyGet(expr);
    if (expr is InstanceGetterInvocation) return _emitCppInstanceGetterInvocation(expr);

    // Record expressions (Dart 3)
    if (expr is RecordLiteral) return _emitCppRecordLiteral(expr);
    if (expr is RecordIndexGet) return _emitCppRecordIndexGet(expr);
    if (expr is RecordNameGet) return _emitCppRecordNameGet(expr);

    // Rethrow
    if (expr is Rethrow) return 'throw';

    // Symbol and Type literals
    if (expr is SymbolLiteral) return _emitCppSymbolLiteral(expr);
    if (expr is TypeLiteral) return _emitCppTypeLiteral(expr);

    // Local function invocation
    if (expr is LocalFunctionInvocation) return _emitCppLocalFunctionInvocation(expr);

    // Instance tear-off (method reference)
    if (expr is InstanceTearOff) return _emitCppInstanceTearOff(expr);

    // Deferred loading stubs
    if (expr is CheckLibraryIsLoaded) return 'true';
    if (expr is LoadLibrary) return '/* loadLibrary */';

    return '/* TODO: ${expr.runtimeType} */';
  }

  String _emitCppBlockExpression(BlockExpression expr) {
    // BlockExpression 使用 IIFE (Immediately Invoked Function Expression) 模式
    // (() { stmts; return value; })()
    final oldBuf = _implBuf;
    final tmpBuf = StringBuffer();
    _implBuf = tmpBuf;
    for (final s in expr.body.statements) {
      _emitCppStmt(s, _implBuf);
    }
    _implBuf = oldBuf;
    final value = _emitCppExpr(expr.value);
    final cleanedStmts = tmpBuf.toString();
    return '([&]() { $cleanedStmts return $value; })()';
  }

  // ==========================================================================
  // Super access expressions
  // ==========================================================================

  String _emitCppSuperPropertyGet(SuperPropertyGet expr) {
    final fieldName = _cleanName(expr.name.text);
    // 查找父类名
    final superClass = _findSuperClassName();
    if (superClass != null) {
      return '${superClass}_get_$fieldName(this_)';
    }
    return 'this_.$fieldName';
  }

  String _emitCppSuperMethodInvocation(SuperMethodInvocation expr) {
    final methodName = _cleanName(expr.name.text);
    final args = expr.arguments.positional.map((e) => _emitCppExpr(e)).join(', ');
    final superClass = _findSuperClassName();
    if (superClass != null) {
      // For AsyncStateMachine, need to cast to base class and specify template parameter
      if (superClass == 'AsyncStateMachine') {
        final typeParam = _findAsyncStateMachineTypeParam();
        if (typeParam.isNotEmpty) {
          final castExpr = 'static_cast<AsyncStateMachine<$typeParam>*>(this_)';
          final allArgs = args.isNotEmpty ? '$castExpr, $args' : castExpr;
          return '${superClass}_$methodName<$typeParam>($allArgs)';
        }
      }
      final allArgs = args.isNotEmpty ? 'this_, $args' : 'this_';
      // Check if target is a getter — add get_ prefix
      final target = expr.interfaceTarget;
      if (target is Procedure && target.isGetter) {
        return '${superClass}_get_$methodName($allArgs)';
      }
      return '${superClass}_$methodName($allArgs)';
    }
    return 'this_.$methodName(${args})';
  }

  String _findAsyncStateMachineTypeParam() {
    // Find the type parameter for AsyncStateMachine by looking at the current class's superclass
    if (_currentClassName.isEmpty) return '';
    final cls = _classNodes[_currentClassName];
    if (cls == null) return '';
    final supertype = cls.supertype;
    if (supertype == null) return '';
    if (supertype.classNode.name == 'AsyncStateMachine') {
      final typeArgs = supertype.typeArguments;
      if (typeArgs.isNotEmpty) {
        return _cppType(typeArgs[0]);
      }
    }
    return '';
  }

  String _emitCppSuperPropertySet(SuperPropertySet expr) {
    final fieldName = _cleanName(expr.name.text);
    final value = _emitCppExpr(expr.value);
    return '(this_.$fieldName = $value)';
  }

  String _emitCppAbstractSuperPropertyGet(AbstractSuperPropertyGet expr) {
    final fieldName = _cleanName(expr.name.text);
    final superClass = _findSuperClassName();
    if (superClass != null) {
      return '${superClass}_get_$fieldName(this_)';
    }
    return 'this_.$fieldName';
  }

  String _emitCppInstanceGetterInvocation(InstanceGetterInvocation expr) {
    final rawReceiver = _emitCppExpr(expr.receiver);
    final target = expr.interfaceTarget;
    if (target is Procedure && target.isGetter) {
      final methodName = _cleanName(target.name.text);

      // 检查接收器类型，对已知类型使用直接访问
      final receiverType = _getExpressionType(expr.receiver);
      final receiver = _castReceiverToType(rawReceiver, receiverType);
      if (receiverType is InterfaceType) {
        final typeName = receiverType.classNode.name;
        // Promise/Future getter
        if ((typeName == 'Promise' || typeName == 'Future' || typeName == '_Promise') && !_userClasses.contains(typeName)) {
          return _emitCppPromiseGetter(receiver, methodName);
        }
        // String 属性
        if (typeName == 'String') {
          String actualReceiver = receiver;
          if (_isAnyPtrExpr(receiver)) {
            actualReceiver = 'dynAs<DartString>($receiver)';
          }
          switch (methodName) {
            case 'isEmpty': return '$actualReceiver.empty()';
            case 'isNotEmpty': return '!$actualReceiver.empty()';
            case 'length': return 'static_cast<int64_t>($actualReceiver.length())';
          }
        }
        // 集合类型 getter — ClassInfo 派发
        final isListType = typeName == 'List' || typeName == 'StaticList' ||
            typeName == 'Iterable' || typeName == '_Iterable' ||
            typeName == '_List' || typeName == '_GrowableList';
        final isMapType = typeName == 'Map' || typeName == 'StaticMap' || typeName == '_Map';
        final isSetType = typeName == 'Set' || typeName == 'StaticSet' || typeName == '_Set';
        if (isListType || isMapType || isSetType) {
          final collectionGetters = {
            'length', 'isEmpty', 'isNotEmpty',
            'first', 'last', 'single', 'reversed', 'iterator',
            'keys', 'values', 'entries',
          };
          if (collectionGetters.contains(methodName)) {
            if (_dartTypeHasUnresolvedTypeParam(receiverType)) {
              final collTypeName = _normalizeCollTypeName(typeName);
              final result = _patternGetterFallback(receiver, methodName, collTypeName);
              if (result.isNotEmpty) return result;
            }
            final ciField = _collectionMethodToCiField[methodName] ?? methodName;
            final vptrReceiver = 'static_cast<AnyGC*>($receiver)';
            final ciCall = '${_classInfoAccess(vptrReceiver, receiverType, ciField)}($vptrReceiver)';
            return _unboxCollectionResult(ciCall, receiverType, methodName);
          }
        }
        if (typeName == 'Iterator') {
          if (methodName == 'current') return 'iterator_current(static_cast<AnyGC*>($receiver))';
        }
        if (typeName == 'Array') {
          if (methodName == 'length') return 'static_cast<int>($receiver->_storage.size())';
        }
        // StringBuffer
        if (typeName == 'StringBuffer' || typeName == 'StaticStringBuffer') {
          if (methodName == 'length') return 'static_cast<int64_t>($receiver->_buf.str().length())';
          if (methodName == 'isEmpty') return '($receiver->_buf.str().empty())';
        }
      }

      // 基于 C++ 表达式模式的 fallback：StaticList/StaticMap/StaticSet → ClassInfo 派发
      {
        final result = _patternGetterFallback(receiver, methodName);
        if (result.isNotEmpty) return result;
      }

      // Pattern-based fallback: methods that return collection types → ClassInfo dispatch via base fields
      if (rawReceiver.contains('->keys()') || rawReceiver.contains('->values()') ||
          rawReceiver.contains('->entries()') || rawReceiver.contains('->toList()')) {
        final vptrRecv = 'static_cast<AnyGC*>($receiver)';
        switch (methodName) {
          case 'length': return 'static_cast<int64_t>($vptrRecv->_classInfo->get_length($vptrRecv))';
          case 'isEmpty': return '$vptrRecv->_classInfo->get_isEmpty($vptrRecv)';
          case 'isNotEmpty': return '$vptrRecv->_classInfo->get_isNotEmpty($vptrRecv)';
          case 'iterator': return '$vptrRecv->_classInfo->get_iterator($vptrRecv)';
        }
      }

      // 通过 ClassInfo 派发 getter 调用
      String vptrReceiver = receiver;
      if (_needsToVPtr(receiver, receiverType)) {
        vptrReceiver = _convertToVPtr(receiver, receiverType);
      }
      final retSuffix = _vptrReturnSuffix(target);
      final ciField = 'get_$methodName';
      final _call = '${_classInfoAccess(vptrReceiver, receiverType, ciField)}($vptrReceiver)';
      if (_isRawReturnField(ciField, target is Procedure ? target : null)) return _call;
      return retSuffix.isNotEmpty ? '$retSuffix($_call)' : _call;
    }
    return rawReceiver;
  }

  /// 查找当前类的父类名
  String? _findSuperClassName() {
    if (_currentClassName.isNotEmpty) {
      var parent = _classHierarchy[_currentClassName];
      // Skip synthetic mixin classes to find the real base class
      while (parent != null && _syntheticLoweredNames.contains(parent)) {
        parent = _classHierarchy[parent];
      }
      if (parent != null && _userClasses.contains(parent)) {
        return parent;
      }
    }
    return null;
  }

  // ==========================================================================
  // Record expressions (Dart 3)
  // ==========================================================================

  String _emitCppRecordLiteral(RecordLiteral expr) {
    final allExprs = <String>[];
    for (final e in expr.positional) {
      allExprs.add(_emitCppExpr(e));
    }
    for (final ne in expr.named) {
      allExprs.add(_emitCppExpr(ne.value));
    }
    final n = allExprs.length;
    if (n == 0) {
      return 'GC::allocateLocal(new TupleBox(nullptr, DartString("()")))';
    }
    final temps = List.generate(n, (i) => '_r$i');
    final decls =
        List.generate(n, (i) => 'auto ${temps[i]} = ${allExprs[i]}').join('; ');
    final tupleArgs = temps.join(', ');
    final strParts = <String>['DartString("(")'];
    for (int i = 0; i < n; i++) {
      if (i > 0) strParts.add('DartString(", ")');
      strParts.add(temps[i]);
    }
    strParts.add('DartString(")")');
    final strExpr = 'dart_str(${strParts.join(', ')})';
    return '[&]() -> AnyGC* { $decls; auto* _t = new std::tuple($tupleArgs); return GC::allocateLocal(new TupleBox(_t, $strExpr)); }()';
  }

  String _emitCppRecordIndexGet(RecordIndexGet expr) {
    final receiver = _emitCppExpr(expr.receiver);
    // Record 索引：Kernel 使用 0-based，std::tuple 也是 0-based
    final index = expr.index;
    // 使用 RecordIndexGet 自带的 receiverType（比从表达式推断更可靠）
    final recordType = expr.receiverType;
    final tupleTypes = recordType.positional.map(_cppType).join(', ');
    // 将 AnyGC* 转换为 tuple 指针并解引用
    return 'std::get<$index>(*reinterpret_cast<std::tuple<$tupleTypes>*>(static_cast<TupleBox*>($receiver)->data))';
  }

  String _emitCppRecordNameGet(RecordNameGet expr) {
    final receiver = _emitCppExpr(expr.receiver);
    final name = _cleanName(expr.name);
    // 命名字段：找到在 tuple 中的索引（positional 字段之后）
    final recordType = expr.receiverType;
    final namedIndex = recordType.named.indexWhere((n) => n.name == name);
    final tupleIndex = recordType.positional.length + namedIndex;
    // 构建 tuple 类型（positional + named）
    final allTypes = [
      ...recordType.positional.map(_cppType),
      ...recordType.named.map((n) => _cppType(n.type)),
    ];
    final tupleTypes = allTypes.join(', ');
    return 'std::get<$tupleIndex>(*reinterpret_cast<std::tuple<$tupleTypes>*>(static_cast<TupleBox*>($receiver)->data))';
  }

  // ==========================================================================
  // Symbol and Type literals
  // ==========================================================================

  String _emitCppSymbolLiteral(SymbolLiteral expr) {
    // Symbol → 字符串表示
    return _cppStringLiteral('#${expr.value}');
  }

  String _emitCppTypeLiteral(TypeLiteral expr) {
    final t = expr.type;
    if (t is InterfaceType) {
      return _cppStringLiteral(t.classNode.name);
    }
    return _cppStringLiteral(t.toString());
  }

  // ==========================================================================
  // Local function invocation and tear-off
  // ==========================================================================

  String _emitCppLocalFunctionInvocation(LocalFunctionInvocation expr) {
    final funcName = _cleanName(expr.variable.name ?? 'func');
    final args = expr.arguments.positional.map((e) => _emitCppExpr(e)).join(', ');
    return '$funcName($args)';
  }

  String _emitCppInstanceTearOff(InstanceTearOff expr) {
    final receiver = _emitCppExpr(expr.receiver);
    final methodName = _cleanName(expr.name.text);
    // Determine return type from the tear-off's function type
    String returnType = 'AnyGC*';
    final exprType = _getExpressionType(expr);
    if (exprType is FunctionType) {
      returnType = _cppType(exprType.returnType);
    }
    // Tear-off → 创建 TypeFunction 包装，捕获 receiver
    final closureId = _closureCounter++;
    final className = '${_currentClassName}Value';
    _structBuf.writeln('struct TearOff_$closureId : TypeFunction0<$returnType> {');
    _structBuf.writeln('    $className* recv_;');
    _structBuf.writeln('    TearOff_$closureId($className* r) : recv_(r) {');
    _structBuf.writeln('        this->fnPtr = &_trampoline;');
    _structBuf.writeln('        this->typedFnPtr = &_typedTrampoline;');
    _structBuf.writeln('    }');
    _structBuf.writeln('    static AnyGC* _trampoline(AnyGC* _env) {');
    _structBuf.writeln('        auto* _self = static_cast<TearOff_$closureId*>(_env);');
    _structBuf.writeln('        return (static_cast<${className}ClassInfo*>(_self->recv_->AnyGC::_classInfo)->$methodName)(_self->recv_);');
    _structBuf.writeln('    }');
    _structBuf.writeln('    static $returnType _typedTrampoline(AnyGC* _env) {');
    _structBuf.writeln('        auto* _self = static_cast<TearOff_$closureId*>(_env);');
    if (returnType == 'void') {
      _structBuf.writeln('        (static_cast<${className}ClassInfo*>(_self->recv_->AnyGC::_classInfo)->$methodName)(_self->recv_);');
    } else if (returnType == 'AnyGC*') {
      _structBuf.writeln('        return (static_cast<${className}ClassInfo*>(_self->recv_->AnyGC::_classInfo)->$methodName)(_self->recv_);');
    } else {
      _structBuf.writeln('        return dynAs<$returnType>((static_cast<${className}ClassInfo*>(_self->recv_->AnyGC::_classInfo)->$methodName)(_self->recv_));');
    }
    _structBuf.writeln('    }');
    _structBuf.writeln('};');
    return 'GC::allocateLocal(new TearOff_$closureId($receiver))';
  }

  String _cppStringLiteral(String value) {
    final escaped = value
        .replaceAll('\\', '\\\\')
        .replaceAll('"', '\\"')
        .replaceAll('\n', '\\n')
        .replaceAll('\r', '\\r')
        .replaceAll('\t', '\\t');
    return 'DartString("$escaped")';
  }

  String _emitCppVariableGet(VariableGet expr) {
    // Box 化变量：通过 box->value 访问
    if (_boxedVars.contains(expr.variable) || _scopeBoxedVars.contains(expr.variable)) {
      final rawName = expr.variable.name ?? 'v';
      final name = _cleanName(rawName);
      final mappedName = _variableNameMappings[name] ?? name;
      return '$mappedName->value';
    }
    // 优先检查 VariableDeclaration 对象映射（最精确）
    if (_varDeclNameMap.containsKey(expr.variable)) {
      return _varDeclNameMap[expr.variable]!;
    }
    // 检查是否是 null 命名的变量
    if (expr.variable.name == null && _nullNamedVarMap.containsKey(expr.variable)) {
      return _nullNamedVarMap[expr.variable]!;
    }
    final rawName = expr.variable.name ?? 'v';
    // 如果变量名包含 # 后缀（如 n#6），且基础名匹配当前闭包参数，使用参数名
    if (rawName.contains('#') && _currentClosureParamNames.isNotEmpty) {
      final baseName = rawName.split('#').first;
      final cleanedBase = _cleanName(baseName);
      if (_currentClosureParamNames.contains(cleanedBase)) {
        return cleanedBase;
      }
    }
    final name = _cleanName(rawName);
    if (name == 'this') return 'this_';
    // 检查变量名映射
    if (_variableNameMappings.containsKey(name)) {
      return _variableNameMappings[name]!;
    }
    return name;
  }

  String _emitCppVariableSet(VariableSet expr) {
    // Box 化变量：通过 box->value 赋值
    if (_boxedVars.contains(expr.variable) || _scopeBoxedVars.contains(expr.variable)) {
      final rawName = expr.variable.name ?? 'v';
      final name = _cleanName(rawName);
      final mappedName = _variableNameMappings[name] ?? name;
      final value = _emitCppExpr(expr.value);
      final varCppType = _cppType(expr.variable.type);
      final unwrappedValue = _unwrapFromAnyPtrIfNeeded(value, varCppType);
      return '($mappedName->value = $unwrappedValue)';
    }
    // 优先检查 VariableDeclaration 对象映射
    if (_varDeclNameMap.containsKey(expr.variable)) {
      final varName = _varDeclNameMap[expr.variable]!;
      final value = _emitCppExpr(expr.value);
      final varCppType = _variableTypeMap[varName] ?? _cppType(expr.variable.type);
      final unwrappedValue = _unwrapFromAnyPtrIfNeeded(value, varCppType);
      return '($varName = $unwrappedValue)';
    }
    // 检查是否是 null 命名的变量
    if (expr.variable.name == null && _nullNamedVarMap.containsKey(expr.variable)) {
      final varName = _nullNamedVarMap[expr.variable]!;
      final value = _emitCppExpr(expr.value);
      // 应用类型转换（如 AnyGC* → int64_t）
      final varCppType = _variableTypeMap[varName] ?? _cppType(expr.variable.type);
      final unwrappedValue = _unwrapFromAnyPtrIfNeeded(value, varCppType);
      return '($varName = $unwrappedValue)';
    }
    final rawName = expr.variable.name ?? 'v';
    String name;
    // 如果变量名包含 # 后缀，且基础名匹配当前闭包参数，使用参数名
    if (rawName.contains('#') && _currentClosureParamNames.isNotEmpty) {
      final baseName = rawName.split('#').first;
      final cleanedBase = _cleanName(baseName);
      if (_currentClosureParamNames.contains(cleanedBase)) {
        name = cleanedBase;
      } else {
        name = _cleanName(rawName);
      }
    } else {
      name = _cleanName(rawName);
    }
    final value = _emitCppExpr(expr.value);
    // 检查变量名映射
    final mappedName = _variableNameMappings.containsKey(name)
        ? _variableNameMappings[name]!
        : name;
    // 如果值是 AnyGC* 但变量类型是具体类型，自动解包
    var varCppType = _cppType(expr.variable.type);
    if (varCppType.isEmpty || varCppType == 'AnyGC*') {
      // 从类型映射中查找
      varCppType = _variableTypeMap[mappedName] ?? varCppType;
    }
    final unwrappedValue = _unwrapFromAnyPtrIfNeeded(value, varCppType);
    return '($mappedName = $unwrappedValue)';
  }

  String _emitCppInstanceGet(InstanceGet expr) {
    final rawReceiver = _emitCppExpr(expr.receiver);
    final fieldName = _cleanName(expr.name.text);

    // 对 this.field，优先使用直接字段访问（避免 ClassInfo dispatch 返回 AnyGC* 的类型不匹配）
    // 跳过枚举类型（枚举有特殊的字段名映射，如 index → _index）
    if (rawReceiver == 'this_' && _currentClassName.isNotEmpty &&
        !_enumNames.contains(_currentClassName)) {
      if (_classHasStructField(_currentClassName, expr.name.text)) {
        return 'this_->$fieldName';
      }
    }

    // 检查接收器类型
    final receiverType = _getExpressionType(expr.receiver);
    // 将 AnyGC* 接收器转换为真实类型（仿照 Dart 的 dynamic dispatch）
    final receiver = _castReceiverToType(rawReceiver, receiverType);

    // 枚举内置字段映射：index → _index, name → _name
    if (receiverType is InterfaceType && _enumNames.contains(receiverType.classNode.name)) {
      if (fieldName == 'index') return '$receiver->_index';
      if (fieldName == 'name') return '$receiver->_name';
    }
    // 枚举方法体中 this_.index / this_.name
    if (receiver == 'this_' && _enumNames.contains(_currentClassName)) {
      if (fieldName == 'index') return 'this_->_index';
      if (fieldName == 'name') return 'this_->_name';
    }

    if (receiverType != null) {
      final cppType = _cppType(receiverType);

      // 特殊处理 String 类型的属性
      if (receiverType is InterfaceType && receiverType.classNode.name == 'String') {
        // 检查是否是可空类型
        final isNullable = receiverType.nullability == Nullability.nullable;
        switch (fieldName) {
          case 'isEmpty':
            // DartString 是非空的，直接使用 empty()
            return '$receiver.empty()';
          case 'isNotEmpty':
            // DartString 是非空的，直接使用 !empty()
            return '!$receiver.empty()';
          case 'length':
            // DartString 是非空的，直接调用 length()
            return 'static_cast<int64_t>($receiver.length())';
          case 'hashCode':
            return 'static_cast<int64_t>(std::hash<DartString>{}($receiver))';
        }
      }

      // 特殊处理 int/double 类型的属性
      if (receiverType is InterfaceType && (receiverType.classNode.name == 'int' || receiverType.classNode.name == 'double')) {
        final typeName = receiverType.classNode.name;
        switch (fieldName) {
          case 'hashCode':
            if (typeName == 'int') return 'static_cast<int64_t>($receiver)';
            return 'static_cast<int64_t>(std::hash<double>{}($receiver))';
          case 'sign':
            if (typeName == 'int') return '(($receiver > 0) ? 1LL : (($receiver < 0) ? -1LL : 0LL))';
            return '(std::isnan($receiver) ? $receiver : (($receiver == 0.0) ? $receiver : (($receiver > 0.0) ? 1.0 : -1.0)))';
          case 'isNegative':
            if (typeName == 'int') return '($receiver < 0)';
            return '(($receiver < 0.0) || ($receiver == 0.0 && std::signbit($receiver)))';
          case 'isNaN':
            if (typeName == 'double') return 'std::isnan($receiver)';
            return 'false';
          case 'isInfinite':
            if (typeName == 'double') return 'std::isinf($receiver)';
            return 'false';
        }
      }

      // 集合类型 getter — ClassInfo 派发
      if (receiverType is InterfaceType) {
        final typeName = receiverType.classNode.name;
        final isListType = typeName == 'List' || typeName == 'StaticList' ||
            typeName == 'Iterable' || typeName == '_Iterable' ||
            typeName == '_List' || typeName == '_GrowableList';
        final isMapType = typeName == 'Map' || typeName == 'StaticMap' || typeName == '_Map';
        final isSetType = typeName == 'Set' || typeName == 'StaticSet' || typeName == '_Set';
        if (isListType || isMapType || isSetType) {
          final collectionGetters = {
            'length', 'isEmpty', 'isNotEmpty',
            'first', 'last', 'single', 'reversed', 'iterator',
            'keys', 'values', 'entries',
          };
          if (collectionGetters.contains(fieldName)) {
            // 含未解析类型参数时使用 ClassInfo 派发（AnyGC* 替代未解析类型参数）
            if (_dartTypeHasUnresolvedTypeParam(receiverType)) {
              final collTypeName = _normalizeCollTypeName(typeName);
              final result = _patternGetterFallback(receiver, fieldName, collTypeName);
              if (result.isNotEmpty) return result;
            }
            final ciField = _collectionMethodToCiField[fieldName] ?? fieldName;
            final vptrReceiver = 'static_cast<AnyGC*>($receiver)';
            final ciCall = '${_classInfoAccess(vptrReceiver, receiverType, ciField)}($vptrReceiver)';
            return _unboxCollectionResult(ciCall, receiverType, fieldName);
          }
        }
      }

      // 特殊处理 Iterator 类型的属性
      if (receiverType is InterfaceType && receiverType.classNode.name == 'Iterator') {
        switch (fieldName) {
          case 'current':
            return 'iterator_current(static_cast<AnyGC*>($receiver))';
        }
      }

      // 特殊处理 Array 类型的属性
      if (receiverType is InterfaceType && receiverType.classNode.name == 'Array') {
        switch (fieldName) {
          case 'length':
            return 'static_cast<int>($receiver->_storage.size())';
          case 'isEmpty':
            return '($receiver->_storage.empty())';
          case 'isNotEmpty':
            return '(!$receiver->_storage.empty())';
        }
      }

      // 特殊处理 StaticSet 类型的属性 — 已由上方统一 ClassInfo 派发处理

      // 特殊处理 Promise/Future 类型的属性
      if (receiverType is InterfaceType && (receiverType.classNode.name == 'Promise' || receiverType.classNode.name == 'Future')) {
        return _emitCppPromiseGetter(receiver, fieldName);
      }

      // 特殊处理 StringBuffer 类型的属性
      if (receiverType is InterfaceType && (receiverType.classNode.name == 'StringBuffer' || receiverType.classNode.name == 'StaticStringBuffer')) {
        switch (fieldName) {
          case 'length': return 'static_cast<int64_t>($receiver->_buf.str().length())';
          case 'isEmpty': return '($receiver->_buf.str().empty())';
          case 'isNotEmpty': return '(!$receiver->_buf.str().empty())';
          default: return '$receiver->$fieldName';
        }
      }

      // 特殊处理 Duration/StaticDuration 类型的属性（值类型，无 *）
      if (receiverType is InterfaceType &&
          (receiverType.classNode.name == 'StaticDuration' || receiverType.classNode.name == 'Duration')) {
        // receiver 可能是 AnyPtr（来自 vptr 派发），需要转为 StaticDuration 值
        String durReceiver = receiver;
        if (_isAnyPtrResult(receiver)) {
          durReceiver = '(*static_cast<StaticDuration*>($receiver))';
        }
        switch (fieldName) {
          case 'inMilliseconds': return '$durReceiver.inMilliseconds()';
          case 'inSeconds': return '$durReceiver.inSeconds()';
          case 'inMicroseconds': return '$durReceiver.inMicroseconds';
        }
      }

      // 如果不是指针类型，使用 . 访问
      if (!cppType.endsWith('*')) {
        return '$receiver.$fieldName';
      }

      // 如果接收器类型是指向声明字段的类的指针，直接使用 -> 访问
      if (expr.interfaceTarget is Field && cppType.endsWith('*')) {
        final fieldTarget = expr.interfaceTarget as Field;
        final declaringClass = fieldTarget.enclosingClass;
        if (declaringClass != null) {
          final declaringClassName = _cleanName(declaringClass.name);
          final receiverClassName = receiverType is InterfaceType ? _cleanName(receiverType.classNode.name) : '';
          if (receiverClassName == declaringClassName) {
            // 接收器类型匹配字段声明类 → 直接 -> 访问
            return '$receiver->$fieldName';
          }
        }
      }
    }

    // 基于 C++ 表达式模式的 fallback：StaticList/StaticMap/StaticSet → ClassInfo 派发
    {
      final result = _patternGetterFallback(receiver, fieldName);
      if (result.isNotEmpty) return result;
    }

    // Pattern-based fallback: methods that return collection types → ClassInfo dispatch via base fields
    if (receiver.contains('->keys()') || receiver.contains('->values()') ||
        receiver.contains('->entries()') || receiver.contains('->toList()')) {
      final vptrReceiver = 'static_cast<AnyGC*>($receiver)';
      switch (fieldName) {
        case 'length': return 'static_cast<int64_t>($vptrReceiver->_classInfo->get_length($vptrReceiver))';
        case 'isEmpty': return '$vptrReceiver->_classInfo->get_isEmpty($vptrReceiver)';
        case 'isNotEmpty': return '$vptrReceiver->_classInfo->get_isNotEmpty($vptrReceiver)';
        case 'iterator': return '$vptrReceiver->_classInfo->get_iterator($vptrReceiver)';
      }
    }

    // 后备：检查接收器是否返回 DartString（基于 C++ 表达式模式）
    if (_cppExprReturnsString(receiver)) {
      switch (fieldName) {
        case 'isEmpty': return '$receiver.empty()';
        case 'isNotEmpty': return '!$receiver.empty()';
        case 'length': return 'static_cast<int64_t>($receiver.length())';
        case 'hashCode': return 'static_cast<int64_t>(std::hash<DartString>{}($receiver))';
      }
    }

    // 检查是否是 getter（通过 interfaceTarget）
    final target = expr.interfaceTarget;
    if (target is Procedure && target.isGetter) {
      // 如果类有对应的 struct 字段，说明是字段的合成 getter，直接访问
      if (receiverType is InterfaceType &&
          _classHasStructField(receiverType.classNode.name, expr.name.text)) {
        return '$receiver->$fieldName';
      }
      // 通过 ClassInfo 访问 getter
      String vptrReceiver = receiver;
      if (_needsToVPtr(receiver, receiverType)) {
        vptrReceiver = _convertToVPtr(receiver, receiverType);
      }
      final ciField = 'get_$fieldName';
      final vptrCall = '${_classInfoAccess(vptrReceiver, receiverType, ciField)}($vptrReceiver)';
      if (_isRawReturnField(ciField, target is Procedure ? target : null)) return vptrCall;
      // 如果 getter 返回基本类型，需要从 AnyGC* 提取值
      final returnType = target.function.returnType;
      if (returnType is InterfaceType) {
        final returnTypeName = returnType.classNode.name;
        if (returnTypeName == 'double') return 'dynAs<double>($vptrCall)';
        if (returnTypeName == 'String') return 'dynAs<DartString>($vptrCall)';
        // int/bool now return raw from ClassInfo — no dynAs needed
        final cppRetType = _cppType(returnType);
        if (cppRetType == 'int64_t' || cppRetType == 'bool') return vptrCall;
        // 集合和用户类返回指针类型（排除不存在的 TypeValue）
        if (cppRetType.endsWith('*') && cppRetType != 'AnyGC*' && cppRetType != 'TypeValue*') return 'static_cast<$cppRetType>($vptrCall)';
        if (_isConcreteCppReturnType(cppRetType)) return 'dynAs<$cppRetType>($vptrCall)';
      }
      // 回退：从表达式静态类型推断
      final exprType = _getExpressionType(expr);
      if (exprType != null && exprType is InterfaceType) {
        final exprTypeName = exprType.classNode.name;
        if (exprTypeName == 'double') return 'dynAs<double>($vptrCall)';
        if (exprTypeName == 'String') return 'dynAs<DartString>($vptrCall)';
        final cppExprType = _cppType(exprType);
        if (cppExprType == 'int64_t' || cppExprType == 'bool') return vptrCall;
        if (cppExprType.endsWith('*') && cppExprType != 'AnyGC*' && cppExprType != 'TypeValue*') return 'static_cast<$cppExprType>($vptrCall)';
        if (_isConcreteCppReturnType(cppExprType)) return 'dynAs<$cppExprType>($vptrCall)';
      }
      // 已知字段名回退 — index still returns AnyGC* (boxed)
      if (fieldName == 'index') return 'dynAs<int64_t>($vptrCall)';
      return vptrCall;
    }

    // 当接收器是 AnyGC* 但访问的是具体类的字段时，需要向下转型
    if (target is Field) {
      final declaringClass = target.enclosingClass;
      if (declaringClass != null) {
        final declaringClassName = _cleanName(declaringClass.name);
        // 构建模板参数（如果声明类有类型参数）
        String castTypeName = '${declaringClassName}Value';
        if (declaringClass.typeParameters.isNotEmpty) {
          // 尝试从接收器类型获取类型参数
          if (receiverType is InterfaceType && receiverType.classNode == declaringClass && receiverType.typeArguments.isNotEmpty) {
            final typeArgs = receiverType.typeArguments.map(_cppType).join(', ');
            castTypeName = '${declaringClassName}Value<$typeArgs>';
          } else if (receiverType is InterfaceType && receiverType.typeArguments.isNotEmpty) {
            // 接收器是子类，使用子类的类型参数
            final typeArgs = receiverType.typeArguments.map(_cppType).join(', ');
            // 只有当类型参数数量匹配时才使用
            if (receiverType.typeArguments.length == declaringClass.typeParameters.length) {
              castTypeName = '${declaringClassName}Value<$typeArgs>';
            }
          } else {
            // 回退：使用变量类型中的模板参数
            final receiverVarType = _variableTypeMap[receiver];
            if (receiverVarType != null && receiverVarType.contains('<')) {
              final match = RegExp(r'<(.+)>').firstMatch(receiverVarType);
              if (match != null) {
                castTypeName = '${declaringClassName}Value<${match.group(1)}>';
              }
            }
          }
        }
        // 检查接收器是否是 AnyGC* 类型
        if (receiverType != null) {
          final receiverCppType = _cppType(receiverType);
          if (receiverCppType == 'AnyGC*') {
            // 向下转型到声明字段的类
            return 'static_cast<$castTypeName*>($receiver)->$fieldName';
          }
          // 检查接收器类型和字段声明类型是否不同（子类字段访问）
          if (receiverCppType.endsWith('*') && receiverCppType != '$castTypeName*') {
            // 接收器是父类指针，但字段在子类中声明 → 需要 static_cast
            if (receiverCppType != '${declaringClassName}*') {
              return 'static_cast<$castTypeName*>($receiver)->$fieldName';
            }
          }
        } else {
          // 类型未知 — 检查 C++ 表达式类型是否和字段声明类匹配
          final receiverVarType = _variableTypeMap[receiver];
          if (receiverVarType != null && receiverVarType.endsWith('*') &&
              receiverVarType != '$castTypeName*') {
            return 'static_cast<$castTypeName*>($receiver)->$fieldName';
          }
        }
      }
    }

    // Duration 属性访问的特殊处理：当 AnyGC* 结果上访问 Duration 属性时
    // Duration 在 lowered 代码中通常存储为 int64_t（毫秒）
    if (_isAnyPtrResult(receiver)) {
      switch (fieldName) {
        case 'inMilliseconds': return 'dynAs<int64_t>($receiver)';
        case 'inSeconds': return '(dynAs<int64_t>($receiver) / 1000)';
        case 'inMicroseconds': return '(dynAs<int64_t>($receiver) * 1000)';
        case 'inMinutes': return '(dynAs<int64_t>($receiver) / 60000)';
        case 'inHours': return '(dynAs<int64_t>($receiver) / 3600000)';
        case 'inDays': return '(dynAs<int64_t>($receiver) / 86400000)';
      }
    }

    final receiverVarType = _variableTypeMap[receiver];
    if (receiverVarType != null && receiverVarType.endsWith('&')) {
      return '$receiver.$fieldName';
    }
    return '$receiver->$fieldName';
  }

  String _emitCppInstanceSet(InstanceSet expr) {
    final receiver = _emitCppExpr(expr.receiver);
    final rawFieldName = expr.name.text;
    final fieldName = _cleanName(rawFieldName);
    final value = _emitCppExpr(expr.value);

    // 查找字段类型以便进行类型转换
    String? fieldCppType;
    final target = expr.interfaceTarget;
    if (target is Field) {
      fieldCppType = _cppType(target.type);
    } else if (target is Procedure && target.isSetter && target.function.positionalParameters.isNotEmpty) {
      fieldCppType = _cppType(target.function.positionalParameters.first.type);
    }

    // 如果值是 AnyGC* 但字段是具体类型，需要解包
    String convertedValue = value;
    if (fieldCppType != null && fieldCppType != 'AnyGC*') {
      convertedValue = _unwrapFromAnyPtrIfNeeded(value, fieldCppType);
      // 对于模板类型参数字段（如 L, R），将 nullptr 转换为默认构造值
      convertedValue = _convertNullToType(convertedValue, fieldCppType);
    }

    // 私有字段直接字段赋值（不在 vtable 中）
    if (rawFieldName.startsWith('_')) {
      return '($receiver->$fieldName = $convertedValue)';
    }

    // 检查是否是 setter（通过 interfaceTarget）
    final receiverType = _getExpressionType(expr.receiver);
    if (target is Procedure && target.isSetter) {
      // 获取接收者的类名
      if (receiverType is InterfaceType) {
        final receiverClassName = receiverType.classNode.name;
        // 如果类有对应的 struct 字段，说明是字段的合成 setter，直接赋值
        if (_classHasStructField(receiverClassName, rawFieldName)) {
          return '($receiver->$fieldName = $convertedValue)';
        }
        // 用户自定义类或 mixin 的 setter 调用 → 通过 ClassInfo
        if (_userClasses.contains(receiverClassName) || _mixinNames.contains(receiverClassName)) {
          String vptrReceiver = receiver;
          if (_needsToVPtr(receiver, receiverType)) {
            vptrReceiver = _convertToVPtr(receiver, receiverType);
          }
          return '${_classInfoAccess(vptrReceiver, receiverType, 'set_$fieldName')}($vptrReceiver, _box($convertedValue))';
        }
      }
    }

    // 后备：如果接收器是 mixin 或用户类，且字段是公开的 setter（非普通字段），使用 vptr setter
    // 注意：普通字段（target is Field）应直接赋值，不走 vptr
    if (target is! Field) {
      String? receiverClassName;
      if (receiverType is InterfaceType) {
        receiverClassName = receiverType.classNode.name;
      } else if (receiver == 'this_' && _currentClassName.isNotEmpty) {
        // 如果接收器是 this_ 且当前在类/混上下文中，使用当前类名
        receiverClassName = _currentClassName;
      }
      if (receiverClassName != null &&
          (_userClasses.contains(receiverClassName) || _mixinNames.contains(receiverClassName)) &&
          !rawFieldName.startsWith('_')) {
        String vptrReceiver = receiver;
        if (_needsToVPtr(receiver, receiverType)) {
          vptrReceiver = _convertToVPtr(receiver, receiverType);
        }
        return '${_classInfoAccess(vptrReceiver, receiverType, 'set_$fieldName')}($vptrReceiver, _box($convertedValue))';
      }
    }

    // 检查接收器类型
    if (receiverType != null) {
      final cppType = _cppType(receiverType);
      // 如果不是指针类型，使用 . 访问
      if (!cppType.endsWith('*')) {
        return '($receiver.$fieldName = $convertedValue)';
      }
    }

    // 默认使用 -> 访问指针
    return '($receiver->$fieldName = $convertedValue)';
  }

  String _emitCppInstanceInvocation(InstanceInvocation expr) {
    final rawReceiver = _emitCppExpr(expr.receiver);
    final rawMethodName = expr.name.text;
    // 收集位置参数和命名参数（命名参数如 fold 的 onSuccess/onFailure 回调）
    final positionalArgs = expr.arguments.positional.map((e) => _emitCppExpr(e)).toList();
    final namedArgs = expr.arguments.named.map((e) => _emitCppExpr(e.value)).toList();
    final allArgExprs = [...positionalArgs, ...namedArgs];
    final args = allArgExprs.join(', ');

    // For catch block exception variables, use direct method calls (DartException does not use ClassInfo dispatch)
    if (_catchExceptionVars.contains(rawReceiver)) {
      final methodName = _cleanName(rawMethodName);
      if (methodName == 'toString') return '$rawReceiver.toString()';
      if (methodName == 'get_message' || methodName == 'message') return '$rawReceiver.message';
      return '$rawReceiver.$methodName($args)';
    }

    // 检查接收器类型
    final receiverType = _getExpressionType(expr.receiver);
    // 将 AnyGC* 接收器转换为真实类型（仿照 Dart 的 dynamic dispatch）
    final receiver = _castReceiverToType(rawReceiver, receiverType);

    // 推断接收器的有效类型名 — 检查 C++ 表达式的后缀模式
    String? inferredTypeName;
    if (receiver.startsWith('dynAs<DartString>')) inferredTypeName = 'String';
    else if (receiver.startsWith('dynAs<int64_t>')) inferredTypeName = 'int';
    else if (receiver.startsWith('dynAs<double>')) inferredTypeName = 'double';
    else if (receiver.startsWith('dynAs<bool>')) inferredTypeName = 'bool';

    // 如果类型信息表明是基本类型，使用它
    if (inferredTypeName == null && receiverType != null && _isPrimitiveType(receiverType)) {
      inferredTypeName = (receiverType as InterfaceType).classNode.name;
    }

    // 后备：如果 receiverType 未检测到但 C++ 表达式返回 DartString，推断为 String
    if (inferredTypeName == null && _cppExprReturnsString(receiver)) {
      inferredTypeName = 'String';
    }

    // 后备：如果接收器看起来像算术表达式（包含运算符），推断为 int/double
    if (inferredTypeName == null && _looksLikeArithmeticExpr(receiver)) {
      inferredTypeName = 'int';  // 默认推断为 int，clamp 等方法对 int/double 通用
    }

    // 检查是否是运算符调用（使用原始方法名）
    if (_isOperatorName(rawMethodName)) {
      return _emitCppOperatorCall(expr, rawReceiver, rawMethodName, args);
    }

    // 清理方法名用于非运算符调用
    final methodName = _cleanName(rawMethodName);

    // 如果接收器表达式是 DartString 类型，处理字符串方法
    if (_cppExprReturnsString(receiver) || receiver.startsWith('dynAs<DartString>')) {
      final strResult = _emitCppStringMethodCall(receiver, methodName, args);
      if (strResult != null) return strResult;
    }

    if (receiverType != null) {
      // 检查是否为基本类型（int, double, bool, string）
      if (_isPrimitiveType(receiverType)) {
        return _emitCppPrimitiveMethodCallByName(receiver, methodName, args, (receiverType as InterfaceType).classNode.name);
      }

      // 检查是否为集合类型（List, Set, Map, Iterable, StaticList, StaticSet, StaticMap, StaticIterator, Array, Iterator）
      if (receiverType is InterfaceType) {
        final typeName = receiverType.classNode.name;
        if (typeName == 'List' || typeName == 'Set' || typeName == 'Map' || typeName == 'Iterable' ||
            typeName == 'StaticList' || typeName == 'StaticSet' || typeName == 'StaticMap' ||
            typeName == 'StaticIterator' || typeName == 'Array' || typeName == 'Iterator' ||
            typeName == '_List' || typeName == '_GrowableList' || typeName == '_Iterable' ||
            typeName == '_Set' || typeName == '_Map' ||
            typeName.contains('Iterator')) {
          return _emitCppCollectionMethodCall(receiver, methodName, expr.arguments, receiverType, expr.arguments.types);
        }

        // 检查是否为 Promise/Future 类型
        if (typeName == 'Promise' || typeName == 'Future') {
          return _emitCppPromiseMethodCall(receiver, methodName, args, receiverType, expr.arguments.types);
        }

        // 检查是否为 Stream 类型
        if (typeName == 'Stream' || typeName == 'StreamValue') {
          return _emitCppStreamMethodCall(receiver, methodName, args, receiverType);
        }

        // 检查是否为 StringBuffer 类型
        if (typeName == 'StringBuffer' || typeName == 'StaticStringBuffer') {
          return _emitCppStringBufferMethodCall(receiver, methodName, args);
        }

        // 检查是否为 GlobalScheduler 类型
        if (typeName == 'GlobalScheduler') {
          return _emitCppGlobalSchedulerMethodCall(receiver, methodName, args);
        }
      }
    }

    // 如果类型未知但方法是集合方法
    final _isCollectionMethod = _collectionMethods.values.any((s) => s.contains(methodName));
    if (_isCollectionMethod &&
        (receiverType == null || _classInfoTypeName(receiverType) == 'ClassInfo')) {
      final collTypeName = _detectCollTypeFromPattern(receiver);
      if (collTypeName != null && _collectionMethods[collTypeName]!.contains(methodName)) {
        final ciField = _collectionMethodToCiField[methodName] ?? methodName;
        final argList = args.isEmpty ? <String>[] : _splitTopLevel(args);
        final boxedArgs = argList.map((a) => _boxCollectionArg(a, null)).toList();
        final maxArgs = _collectionMethodMaxArgs[methodName];
        if (maxArgs != null) {
          while (boxedArgs.length < maxArgs) {
            boxedArgs.add('nullptr');
          }
        }
        final ciCall = _patternClassInfoDispatch(receiver, collTypeName, ciField, boxedArgs);
        if (ciCall.isNotEmpty) {
          if (methodName == 'map' || methodName == 'expand' || methodName == 'cast' ||
              methodName == 'fold' || methodName == 'whereType') {
            return _castTemplateMethodResult(ciCall, methodName, collTypeName, expr.arguments.types);
          }
          return _unboxPatternMethodResult(ciCall, methodName, collTypeName);
        }
      }
      if (args.isEmpty) return '$receiver->$methodName()';
      return '$receiver->$methodName($args)';
    }

    // 如果 _castReceiverToType 将接收器转换为基本类型（如 .toStringValue()），
    // 则根据推断类型进行方法派发
    if (inferredTypeName != null) {
      return _emitCppPrimitiveMethodCallByName(receiver, methodName, args, inferredTypeName);
    }

    // 模板类型参数上的方法调用：使用 if constexpr 兼容指针和值类型
    if (receiverType is TypeParameterType) {
      return _emitCppTemplateParamMethodCall(receiver, methodName, args, expr);
    }

    // TypeFunction.call() → cast to typed TypeFunctionN<AnyGC*, ...> and call fnPtr()
    if (methodName == 'call' && (receiverType == null || _isDynamicOrAnyGC(receiverType))) {
      final argList = args.isEmpty ? <String>[] : _splitTopLevel(args);
      final anyArgs = List.filled(argList.length, 'AnyGC*').join(', ');
      final typeArgs = anyArgs.isEmpty ? 'AnyGC*' : 'AnyGC*, $anyArgs';
      final castReceiver = 'static_cast<TypeFunctionN<$typeArgs>*>($receiver)';
      if (args.isEmpty) return '$castReceiver->fnPtr($castReceiver)';
      return '$castReceiver->fnPtr($castReceiver, ${_wrapVptrArgs(args)})';
    }

    // 私有方法调用 — 不在 ClassInfo dispatch 中，直接调用静态函数
    if (rawMethodName.startsWith('_') && receiver == 'this_' && _currentClassName.isNotEmpty) {
      final cls = _classNodes[_currentClassName];
      if (cls != null && _userClasses.contains(_currentClassName) && cls.typeParameters.isEmpty) {
        final className = _cleanName(_currentClassName);
        final funcName = '${className}_${_cleanName(rawMethodName)}';
        final callArgs = allArgExprs.isNotEmpty ? '$receiver, $args' : receiver;
        return '$funcName($callArgs)';
      }
    }

    // 虚方法调用 - 通过 ClassInfo 派发
    // 填充可选参数的默认值（vptr wrapper 需要全部参数）
    final vptrPositionalArgs = [...positionalArgs];
    vptrPositionalArgs.addAll(
        _collectDefaultPositionalArgs(expr.interfaceTarget, expr.arguments.positional.length));
    final vptrAllArgs = [...vptrPositionalArgs, ...namedArgs];
    final vptrArgsStr = vptrAllArgs.join(', ');
    final argCount = vptrAllArgs.length;
    String vptrReceiver = receiver;

    if (_needsToVPtr(receiver, receiverType)) {
      vptrReceiver = _convertToVPtr(receiver, receiverType);
    }
    final wrappedArgs = _wrapVptrArgs(vptrArgsStr);
    final allArgs = wrappedArgs.isNotEmpty ? '$receiver, $wrappedArgs' : receiver;
    var retSuffix = _vptrReturnSuffix(expr.interfaceTarget);
    final ciField = _cleanMethodName(methodName);
    final _call = '${_classInfoAccess(vptrReceiver, receiverType, ciField)}($allArgs)';
    if (_isRawReturnField(ciField, expr.interfaceTarget is Procedure ? expr.interfaceTarget : null)) return _call;
    // 泛型方法：retSuffix 为空时，从函数签名的返回类型推断返回值转换
    if (retSuffix.isEmpty) {
      // 优先使用 functionType.returnType（含已解析的类型参数）
      DartType? exprType = expr.functionType.returnType is! VoidType ? expr.functionType.returnType : null;
      // 回退到表达式静态类型
      if (exprType == null || _cppType(exprType) == 'AnyGC*') {
        exprType = _getExpressionType(expr);
      }
      if (exprType != null) {
        final cppRetType = _cppType(exprType);
        if (cppRetType == 'double') retSuffix = 'dynAs<double>';
        else if (cppRetType == 'DartString') retSuffix = 'dynAs<DartString>';
        else if (cppRetType == 'int64_t') retSuffix = 'dynAs<int64_t>';
        else if (cppRetType == 'bool') retSuffix = 'dynAs<bool>';
        else if (cppRetType.endsWith('*') && cppRetType != 'AnyGC*') {
          // Collection template methods return type-erased AnyGC* — skip cast
          if (methodName == 'map' || methodName == 'expand' || methodName == 'cast' || methodName == 'whereType') return _call;
          return 'static_cast<$cppRetType>($_call)';
        }
        else if (exprType is TypeParameterType) retSuffix = 'dynAs<$cppRetType>';
      }
    }
    return retSuffix.isNotEmpty ? '$retSuffix($_call)' : _call;
  }

  /// 收集方法签名中未提供的可选位置参数的默认值。
  /// vptr wrapper 的签名是固定的 (AnyGC*, AnyGC*, ...)，
  /// 调用时必须提供全部参数，否则会因参数不足而崩溃。
  List<String> _collectDefaultPositionalArgs(Member? target, int providedArgCount) {
    if (target is! Procedure) return [];
    final params = target.function.positionalParameters;
    final defaults = <String>[];
    for (var i = providedArgCount; i < params.length; i++) {
      final param = params[i];
      if (param.initializer != null) {
        defaults.add(_emitCppExpr(param.initializer!));
      } else {
        break;
      }
    }
    return defaults;
  }

  /// 生成模板类型参数上的方法调用
  /// 使用 if constexpr 兼容指针类型（ClassInfo 派发）和值类型（直接操作）
  String _emitCppTemplateParamMethodCall(String receiver, String methodName, String args, InstanceInvocation expr) {
    final argCount = expr.arguments.positional.length;

    // compareTo: 指针类型用 ClassInfo 派发，值类型用 > 运算符
    if (methodName == 'compareTo' && argCount == 1) {
      final arg = args;
      final vptrCall = 'static_cast<AnyGC*>($receiver)->_classInfo->compareTo(static_cast<AnyGC*>($receiver), _box($arg))';
      final valueCall = '(($receiver) > ($arg) ? 1LL : (($receiver) < ($arg) ? -1LL : 0LL))';
      return '([&]() -> int64_t { if constexpr (std::is_pointer_v<decltype($receiver)>) { auto* _gc = static_cast<AnyGC*>($receiver); if (_gc) { return $vptrCall; } else { return static_cast<int64_t>(0); } } else { return $valueCall; } })()';
    }

    // toString: 指针类型用 ClassInfo 派发，值类型用 dart_str
    if (methodName == 'toString' && argCount == 0) {
      final vptrCall = 'static_cast<AnyGC*>($receiver)->_classInfo->toString(static_cast<AnyGC*>($receiver))';
      final valueCall = 'dart_str($receiver)';
      return '([&]() -> AnyGC* { if constexpr (std::is_pointer_v<decltype($receiver)>) { auto* _gc = static_cast<AnyGC*>($receiver); if (_gc) { return $vptrCall; } else { return _box(static_cast<AnyGC*>($receiver)); } } else { return $valueCall; } })()';
    }

    // 默认：通过 ClassInfo 派发（13 个常用方法在基类 ClassInfo 中）
    final wrappedArgs = _wrapVptrArgs(args);
    final allArgs = wrappedArgs.isNotEmpty ? 'static_cast<AnyGC*>($receiver), $wrappedArgs' : 'static_cast<AnyGC*>($receiver)';
    final vptrCall = '(static_cast<ClassInfo*>(static_cast<AnyGC*>($receiver)->_classInfo)->$methodName)($allArgs)';
    return '([&]() { if constexpr (std::is_pointer_v<decltype($receiver)>) { return $vptrCall; } else { return _box($receiver); } })()';
  }

  /// 生成集合类型的方法调用
  /// 集合类型方法名 → 无参数方法集合
  static const _noArgMethods = <String>{
    'clear', 'isEmpty', 'isNotEmpty', 'length', 'toList', 'toSet',
    'reversed', 'first', 'last', 'single', 'removeLast',
    'keys', 'values', 'entries', 'moveNext', 'current', 'reset', 'iterator',
  };

  /// 集合类型 → 支持的方法名集合
  static final _collectionMethods = <String, Set<String>>{
    'List': {
      'add', 'addAll', 'clear', 'contains', 'isEmpty', 'isNotEmpty', 'length',
      'map', 'expand', 'where', 'forEach', 'join', 'toList', 'toSet', 'sort', 'sublist',
      'first', 'last', 'single', 'any', 'every', 'fold', 'reduce', 'reversed',
      'indexOf', 'insert', 'insertAll', 'remove', 'removeAt', 'removeLast', 'removeWhere',
      'retainWhere', 'removeRange', 'fillRange', 'iterator', 'take', 'skip', 'takeWhile', 'skipWhile',
      'firstWhere', 'lastWhere', 'singleWhere', 'indexWhere', 'lastIndexWhere', 'lastIndexOf',
      'getRange', 'cast', 'whereType', 'toString', 'asMap', 'followedBy', 'elementAt',
    },
    'Iterable': {
      'contains', 'isEmpty', 'isNotEmpty', 'length', 'map', 'expand', 'where', 'forEach',
      'join', 'toList', 'toSet', 'first', 'last', 'single', 'any', 'every',
      'fold', 'reduce', 'reversed', 'iterator', 'take', 'skip', 'takeWhile',
      'skipWhile', 'firstWhere', 'lastWhere', 'singleWhere', 'indexWhere',
      'cast', 'whereType', 'toString', 'followedBy', 'elementAt',
    },
    'StaticList': {
      'add', 'addAll', 'clear', 'contains', 'isEmpty', 'isNotEmpty', 'length',
      'map', 'expand', 'where', 'forEach', 'join', 'toList', 'toSet', 'sort', 'sublist',
      'first', 'last', 'single', 'any', 'every', 'fold', 'reduce', 'reversed',
      'indexOf', 'insert', 'insertAll', 'remove', 'removeAt', 'removeLast', 'removeWhere',
      'retainWhere', 'removeRange', 'fillRange', 'iterator', 'take', 'skip', 'takeWhile', 'skipWhile',
      'firstWhere', 'lastWhere', 'singleWhere', 'indexWhere', 'lastIndexWhere', 'lastIndexOf',
      'getRange', 'cast', 'whereType', 'toString', 'asMap', 'followedBy', 'elementAt',
    },
    'Set': {
      'add', 'addAll', 'clear', 'contains', 'isEmpty', 'isNotEmpty', 'length',
      'map', 'expand', 'where', 'forEach', 'join', 'toList', 'toSet', 'first', 'last',
      'single', 'any', 'every', 'iterator', 'take', 'skip', 'takeWhile',
      'skipWhile', 'firstWhere', 'lastWhere', 'singleWhere',
      'remove', 'containsAll', 'removeWhere', 'retainWhere', 'lookup',
      'union', 'unionSet', 'union_', 'intersection', 'difference',
      'reduce', 'cast', 'whereType', 'toString', 'fold', 'elementAt',
    },
    'StaticSet': {
      'add', 'addAll', 'clear', 'contains', 'isEmpty', 'isNotEmpty', 'length',
      'map', 'expand', 'where', 'forEach', 'join', 'toList', 'toSet', 'first', 'last',
      'single', 'any', 'every', 'remove', 'containsAll', 'removeWhere', 'retainWhere', 'lookup',
      'union', 'unionSet', 'union_', 'intersection', 'difference',
      'take', 'skip', 'takeWhile', 'skipWhile', 'firstWhere', 'lastWhere', 'singleWhere',
      'reduce', 'cast', 'whereType', 'toString', 'fold', 'elementAt',
    },
    'Map': {
      'clear', 'containsKey', 'containsValue', 'isEmpty', 'isNotEmpty', 'length',
      'map', 'forEach', 'keys', 'values', 'entries', 'remove', 'putIfAbsent',
      'update', 'updateAll', 'addAll', 'addEntries', 'removeWhere',
      'set', 'cast', 'toString',
    },
    'StaticMap': {
      'clear', 'containsKey', 'containsValue', 'isEmpty', 'isNotEmpty', 'length',
      'map', 'forEach', 'keys', 'values', 'entries', 'remove', 'putIfAbsent',
      'update', 'updateAll', 'addAll', 'addEntries', 'removeWhere',
      'set', 'cast', 'toString',
    },
    'Array': {
      'add', 'clear', 'contains', 'indexOf', 'insert', 'length',
      'removeAt', 'isEmpty', 'isNotEmpty',
    },
    'Iterator': {'moveNext', 'current', 'reset'},
    'StaticIterator': {'moveNext', 'current', 'reset'},
  };

  /// Promise/Future 类型方法调用 — 直接调用而非 vptr 派发
  String _emitCppPromiseMethodCall(String receiver, String methodName, String args, InterfaceType type, [List<DartType>? methodTypeArgs]) {
    switch (methodName) {
      case 'then':
        String R = 'AnyGC*';
        if (methodTypeArgs != null && methodTypeArgs.isNotEmpty) {
          final resolved = _cppType(methodTypeArgs.first);
          if (!_isCppTypeParameter(resolved)) R = resolved;
        }
        // void → int: Promise<void> 已移除
        if (R == 'void') R = 'int';
        if (args.contains('[') && args.contains('](') && !args.contains('TypeFunction')) {
          return 'promise_then<$R>($receiver, $args)';
        }
        return '_PromiseThen<$R>::call($receiver, $args)';
      case 'catchError': return 'promise_catchError($receiver, $args)';
      case 'whenComplete': return 'promise_whenComplete($receiver, $args)';
      case 'complete': return 'promise_complete($receiver, $args)';
      case 'completeError': return 'promise_completeError($receiver, $args)';
      case 'completeWith': return 'promise_complete($receiver, $args)';
      case 'completeWithError': return 'promise_completeError($receiver, $args)';
      case 'toList': return '$receiver->toList()';
      case 'toString': return '_anyToString($receiver)';
      // Promise getters
      case 'get_result': return 'promise_typedResult($receiver)';
      case 'get_isPending': return 'promise_isPending($receiver)';
      case 'get_isCompleted': return 'promise_isCompleted($receiver)';
      case 'get_isError': return 'promise_isError($receiver)';
      case 'get_error': return '$receiver->error';
      case 'get_isReady': return 'promise_isReady($receiver)';
      default:
        // 对于未知方法，尝试直接调用
        if (args.isNotEmpty) {
          return '$receiver->$methodName($args)';
        }
        return '$receiver->$methodName()';
    }
  }

  /// Stream 类型方法调用
  String _emitCppStreamMethodCall(String receiver, String methodName, String args, InterfaceType type) {
    switch (methodName) {
      case 'toList':
        // Stream.toList() returns Future<List<T>>, which is Promise<StaticList<T>*>*
        // Create a resolved promise with the list
        final typeArg = type.typeArguments.isNotEmpty ? _cppType(type.typeArguments.first) : 'AnyGC*';
        return '([&]() { auto* _stream = $receiver; auto* _promise = GC::allocateLocal(new Promise<StaticList<$typeArg>*>()); promise_complete(_promise, _box(streamValue_toList(static_cast<AnyGC*>(_stream)))); return _promise; })()';
      case 'map':
        return 'streamValue_map(static_cast<AnyGC*>($receiver), $args)';
      case 'where':
        return 'streamValue_where(static_cast<AnyGC*>($receiver), $args)';
      case 'fold':
        return 'streamValue_fold(static_cast<AnyGC*>($receiver), $args)';
      default:
        if (args.isNotEmpty) {
          return '$receiver->$methodName($args)';
        }
        return '$receiver->$methodName()';
    }
  }

  /// Promise getter 访问
  String _emitCppPromiseGetter(String receiver, String fieldName) {
    switch (fieldName) {
      case 'result': return 'promise_typedResult($receiver)';
      case 'isPending': return 'promise_isPending($receiver)';
      case 'isCompleted': return 'promise_isCompleted($receiver)';
      case 'isError': return 'promise_isError($receiver)';
      case 'error': return '$receiver->error';
      case 'isReady': return 'promise_isReady($receiver)';
      default: return '$receiver->$fieldName';
    }
  }

  /// StringBuffer 类型方法调用
  String _emitCppStringBufferMethodCall(String receiver, String methodName, String args) {
    switch (methodName) {
      case 'write': return 'sbuf_write($receiver, $args)';
      case 'writeln': return 'sbuf_writeln($receiver, $args)';
      case 'clear': return 'sbuf_clear($receiver)';
      case 'toString': return '_anyToString($receiver)';
      default:
        if (args.isNotEmpty) {
          return '$receiver->$methodName($args)';
        }
        return '$receiver->$methodName()';
    }
  }

  /// GlobalScheduler 方法调用
  String _emitCppGlobalSchedulerMethodCall(String receiver, String methodName, String args) {
    // 无论 receiver 是什么形式（instance、GlobalScheduler::instance() 等），
    // 都直接使用 GlobalScheduler::instance() 调用
    switch (methodName) {
      case 'reset': return 'GlobalScheduler::instance().reset()';
      case 'tick': return 'GlobalScheduler::instance().tick()';
      case 'registerActivePromise': return 'GlobalScheduler::instance().registerActivePromise($args)';
      case 'registerDelayedTask': return 'GlobalScheduler::instance().registerDelayedTask($args)';
      case 'registerReadyPromise': return 'GlobalScheduler::instance().registerReadyPromise($args)';
      case 'hasActiveWork': return 'GlobalScheduler::instance().hasActiveWork()';
      case 'get_currentTick': return 'GlobalScheduler::instance().tickCount()';
      default:
        if (args.isNotEmpty) {
          return 'GlobalScheduler::instance().$methodName($args)';
        }
        return 'GlobalScheduler::instance().$methodName()';
    }
  }

  /// 集合方法的可选参数最大数量（不含 self）
  static const _collectionMethodMaxArgs = <String, int>{
    'firstWhere': 2, 'lastWhere': 2, 'singleWhere': 2,
    'indexOf': 2, 'lastIndexOf': 2, 'indexWhere': 2, 'lastIndexWhere': 2,
    'sublist': 2, 'getRange': 2, 'join': 1, 'sort': 1, 'update': 3,
    'fillRange': 3, 'setRange': 4,
    'map': 1, 'expand': 1, 'fold': 2,
  };

  /// Dart method名 → ClassInfo field名映射
  static const _collectionMethodToCiField = <String, String>{
    'isEmpty': 'get_isEmpty',
    'isNotEmpty': 'get_isNotEmpty',
    'first': 'get_first',
    'last': 'get_last',
    'single': 'get_single',
    'reversed': 'get_reversed',
    'iterator': 'get_iterator',
    'keys': 'get_keys',
    'values': 'get_values',
    'entries': 'get_entries',
    'length': 'get_length',
    'any': 'any_',
    'every': 'every_',
    'union': 'unionSet',
    'union_': 'unionSet',
    'cast': 'cast_',
  };

  /// 规范化集合类型名：将所有 Dart 集合类型别名映射到 C++ ClassInfo 对应的规范名
  static String _normalizeCollTypeName(String typeName) {
    if (['List', '_List', '_GrowableList', 'StaticList', 'Iterable', '_Iterable'].contains(typeName)) return 'StaticList';
    if (['Set', '_Set', 'StaticSet'].contains(typeName)) return 'StaticSet';
    if (['Map', '_Map', 'StaticMap'].contains(typeName)) return 'StaticMap';
    return typeName;
  }

  /// Pattern-based ClassInfo dispatch: when Dart type info is lost but the collection
  /// type can be inferred from the C++ expression pattern, generate ClassInfo dispatch.
  /// Base ClassInfo fields use static_cast<ClassInfo*>, collection-specific fields
  /// use static_cast<StaticXxxClassInfo<AnyGC*>*> (safe because all specializations
  /// have identical struct layouts — function pointers only use AnyGC* signatures).
  String _patternClassInfoDispatch(String receiver, String collTypeName, String ciField, [List<String> boxedArgs = const []]) {
    final vptrReceiver = 'static_cast<AnyGC*>($receiver)';
    String ciType;
    // Prefer the collection-specific ClassInfo subclass so that shadowed fields
    // (e.g. StaticList's lastIndexOf) resolve to the correct implementation.
    // Base fields are inherited, so accessing them through the derived cast is safe.
    if (collTypeName == 'StaticList') {
      ciType = 'StaticListClassInfo<AnyGC*>';
    } else if (collTypeName == 'StaticSet') {
      ciType = 'StaticSetClassInfo<AnyGC*>';
    } else if (collTypeName == 'StaticMap') {
      ciType = 'StaticMapClassInfo<AnyGC*, AnyGC*>';
    } else if (_baseClassInfoFields.contains(ciField)) {
      ciType = 'ClassInfo';
    } else {
      return '';
    }
    final allArgs = boxedArgs.isNotEmpty ? '$vptrReceiver, ${boxedArgs.join(', ')}' : vptrReceiver;
    return 'static_cast<$ciType*>(${vptrReceiver}->AnyGC::_classInfo)->$ciField($allArgs)';
  }

  /// Unbox collection method result for pattern-based dispatch (element type unknown).
  String _unboxPatternMethodResult(String ciCall, String methodName, String collTypeName) {
    final ciField = _collectionMethodToCiField[methodName] ?? methodName;
    if (_voidCollectionMethods.contains(methodName)) return ciCall;
    if (_stringCollectionMethods.contains(ciField)) return 'dynAs<DartString>($ciCall)';
    return ciCall;
  }

  /// Detect collection type name from C++ expression pattern
  String? _detectCollTypeFromPattern(String expr) {
    if (expr.contains('StaticList<')) return 'StaticList';
    if (expr.contains('StaticSet<')) return 'StaticSet';
    if (expr.contains('StaticMap<')) return 'StaticMap';
    return null;
  }

  /// Pattern-based getter fallback: ClassInfo dispatch for primitive-return getters,
  /// direct call for typed-return getters (element type can't be determined from pattern).
  /// [collTypeName] overrides pattern detection when the collection type is known from Dart type info.
  String _patternGetterFallback(String receiver, String fieldName, [String? collTypeName]) {
    collTypeName ??= _detectCollTypeFromPattern(receiver);
    if (collTypeName == null) return '';

    final primitiveGetters = {'length', 'isEmpty', 'isNotEmpty'};
    if (primitiveGetters.contains(fieldName)) {
      final ciField = _collectionMethodToCiField[fieldName] ?? 'get_$fieldName';
      final ciCall = _patternClassInfoDispatch(receiver, collTypeName, ciField);
      if (ciCall.isNotEmpty) return ciCall;
    }

    final typedGetters = {'first', 'last', 'single', 'reversed', 'iterator', 'keys', 'values', 'entries'};
    if (typedGetters.contains(fieldName)) {
      final ciField = 'get_$fieldName';
      final ciCall = _patternClassInfoDispatch(receiver, collTypeName, ciField);
      if (ciCall.isNotEmpty) return ciCall;
    }

    return '';
  }

  /// 将 C++ 参数表达式 boxing 为 AnyGC*
  String _boxCollectionArg(String argExpr, DartType? argType) {
    if (argType == null) {
      // 无类型信息：使用泛型 lambda 编译时判断指针/值类型
      return '([&](auto&& _x) -> AnyGC* { if constexpr (std::is_pointer_v<std::decay_t<decltype(_x)>>) return static_cast<AnyGC*>(_x); else return _box(_x); })($argExpr)';
    }
    final cppType = _cppType(argType);
    if (cppType == 'int64_t' || cppType == 'int') {
      return '_box(static_cast<int64_t>($argExpr))';
    }
    if (cppType == 'double') {
      return '_box($argExpr)';
    }
    if (cppType == 'bool') {
      return '_box($argExpr)';
    }
    if (cppType == 'DartString') {
      return '_box($argExpr)';
    }
    if (cppType == 'AnyGC*') {
      return argExpr;
    }
    if (cppType.endsWith('*')) {
      return 'static_cast<AnyGC*>($argExpr)';
    }
    // 值类型（如 StaticMapEntry）
    return '_box($argExpr)';
  }

  /// 集合方法的 void 返回（返回 nullptr，结果不使用）
  static const _voidCollectionMethods = <String>{
    'add', 'addAll', 'clear', 'forEach', 'insert', 'insertAll',
    'removeWhere', 'retainWhere', 'removeRange', 'fillRange', 'sort', 'updateAll', 'addEntries',
    'put',
  };

  /// 集合方法的 bool 返回
  static const _boolCollectionMethods = <String>{
    'get_isEmpty', 'get_isNotEmpty', 'contains', 'containsKey', 'containsValue',
    'any_', 'every_',
  };

  /// 集合方法的 int 返回
  static const _intCollectionMethods = <String>{
    'get_length', 'indexOf', 'lastIndexOf', 'indexWhere', 'lastIndexWhere',
  };

  /// 集合方法的 String 返回
  static const _stringCollectionMethods = <String>{
    'join',
  };

  /// 元素返回方法（返回 T）：first, last, single, firstWhere, lastWhere, singleWhere,
  /// reduce, removeAt, removeLast, lookup, remove(Map→V)
  static const _elementReturnMethods = <String>{
    'get_first', 'get_last', 'get_single',
    'firstWhere', 'lastWhere', 'singleWhere',
    'reduce', 'removeAt', 'removeLast', 'lookup',
    'remove',  // Map.remove returns V
    'elementAt',  // List.elementAt and Set.elementAt return T
  };

  /// 将 ClassInfo dispatch 调用结果 unboxing 为正确的 C++ 类型
  String _unboxCollectionResult(String ciCall, InterfaceType type, String methodName) {
    final ciField = _collectionMethodToCiField[methodName] ?? methodName;
    final typeName = type.classNode.name;
    final isSetType = typeName == 'Set' || typeName == 'StaticSet' || typeName == '_Set';
    final isMapType = typeName == 'Map' || typeName == 'StaticMap' || typeName == '_Map';
    final isListType = typeName == 'List' || typeName == 'StaticList' ||
        typeName == '_List' || typeName == '_GrowableList' ||
        typeName == 'Iterable' || typeName == '_Iterable';

    // Set.add 返回 bool（List.add 返回 void）— now returns bool directly
    if (methodName == 'add' && isSetType) {
      return ciCall;
    }
    // List.remove / Set.remove 返回 bool（Map.remove 返回 V）— now returns bool directly
    if (methodName == 'remove' && (isListType || isSetType)) {
      return ciCall;
    }

    // void 方法 — 返回 nullptr，结果不使用
    if (_voidCollectionMethods.contains(methodName)) {
      return ciCall;
    }
    // bool 返回 — now returns bool directly
    if (_boolCollectionMethods.contains(ciField)) {
      return ciCall;
    }
    // int 返回 — now returns int64_t directly
    if (_intCollectionMethods.contains(ciField)) {
      return ciCall;
    }
    // String 返回
    if (_stringCollectionMethods.contains(ciField)) {
      return 'dynAs<DartString>($ciCall)';
    }
    // 元素返回 — 需要 _unboxElem<T>
    if (_elementReturnMethods.contains(ciField)) {
      String elemCppType;
      if (isMapType) {
        // Map.remove returns V
        final typeArgs = type.typeArguments;
        if (typeArgs.length >= 2) {
          if (_dartTypeHasUnresolvedTypeParam(typeArgs[1])) return ciCall;
          elemCppType = _cppType(typeArgs[1]);
        } else {
          return ciCall;
        }
      } else {
        final typeArgs = type.typeArguments;
        if (typeArgs.isNotEmpty) {
          if (_dartTypeHasUnresolvedTypeParam(typeArgs[0])) return ciCall;
          elemCppType = _cppType(typeArgs[0]);
        } else {
          return ciCall;
        }
      }
      return '_unboxElem<$elemCppType>($ciCall)';
    }
    // 集合返回 — static_cast 到期望的 C++ 类型
    final returnType = _collectionMethodReturnType(ciField, type);
    if (returnType != null && returnType != 'AnyGC*') {
      return 'static_cast<$returnType>($ciCall)';
    }
    // 默认：返回 AnyGC* 不转换
    return ciCall;
  }

  /// 获取集合方法的返回 C++ 类型
  String? _collectionMethodReturnType(String methodName, InterfaceType type) {
    // Strip get_ prefix — getter ciField names (get_iterator, get_keys, etc.)
    // need to match switch cases that use bare method names (iterator, keys, etc.)
    if (methodName.startsWith('get_')) {
      methodName = methodName.substring(4);
    }
    final typeName = type.classNode.name;
    final typeArgs = type.typeArguments;
    final isList = typeName == 'List' || typeName == 'StaticList' ||
        typeName == '_List' || typeName == '_GrowableList' ||
        typeName == 'Iterable' || typeName == '_Iterable';
    final isSet = typeName == 'Set' || typeName == 'StaticSet' || typeName == '_Set';
    final isMap = typeName == 'Map' || typeName == 'StaticMap' || typeName == '_Map';

    String? elemType;
    if (typeArgs.isNotEmpty) {
      if (_dartTypeHasUnresolvedTypeParam(typeArgs[0])) {
        return null;
      }
      elemType = _cppType(typeArgs[0]);
    }

    switch (methodName) {
      case 'where':
      case 'take':
      case 'skip':
      case 'takeWhile':
      case 'skipWhile':
        if (isList) return 'StaticList<$elemType>*';
        if (isSet) return 'StaticSet<$elemType>*';
        return null;
      case 'sublist':
      case 'reversed':
      case 'followedBy':
      case 'plus':
        if (isList) return 'StaticList<$elemType>*';
        return null;
      case 'toList':
        if (isList) return 'StaticList<$elemType>*';
        if (isSet) return 'StaticList<$elemType>*';
        return null;
      case 'toSet':
        if (isSet) return 'StaticSet<$elemType>*';
        if (isList) return 'StaticSet<$elemType>*';
        return null;
      case 'iterator':
        if (isList || isSet) return 'StaticIterator<$elemType>*';
        return null;
      case 'asMap':
        if (isList) return 'StaticMap<int, $elemType>*';
        return null;
      case 'keys':
        if (isMap && typeArgs.isNotEmpty) return 'StaticList<${_cppType(typeArgs[0])}>*';
        return null;
      case 'values':
        if (isMap && typeArgs.length >= 2) return 'StaticList<${_cppType(typeArgs[1])}>*';
        return null;
      case 'entries':
        if (isMap && typeArgs.length >= 2) {
          return 'StaticList<StaticMapEntry<${_cppType(typeArgs[0])}, ${_cppType(typeArgs[1])}>>*';
        }
        return null;
      case 'unionSet':
      case 'intersection':
      case 'difference':
        if (isSet) return 'StaticSet<$elemType>*';
        return null;
      case 'lookup':
        if (isSet) return '$elemType*';
        return null;
      default:
        return null;
    }
  }

  String _emitCppCollectionMethodCall(String receiver, String methodName, Arguments arguments, InterfaceType type, [List<DartType>? methodTypeArgs]) {
    // Normalize type name to canonical collection type
    final rawTypeName = type.classNode.name;
    final typeName = _normalizeCollTypeName(rawTypeName);
    final methods = _collectionMethods[typeName];
    // Build args string from arguments (for template methods and fallback)
    final positionalArgs = arguments.positional.map((e) => _emitCppExpr(e)).toList();
    final namedArgs = arguments.named.map((e) => _emitCppExpr(e.value)).toList();
    final allArgExprs = [...positionalArgs, ...namedArgs];
    final args = allArgExprs.join(', ');
    
    if (methods == null || !methods.contains(methodName)) {
      return '(throw DartUnsupportedError("unsupported collection method: $methodName on $typeName"), $receiver)';
    }

    // toList on List/Iterable returns self; toSet on Set returns self
    if (methodName == 'toList' && (typeName == 'Iterable' || typeName == 'StaticList' ||
        typeName == 'List' || typeName == '_List' || typeName == '_GrowableList' ||
        typeName == '_Iterable')) {
      return receiver;
    }
    if (methodName == 'toSet' && (typeName == 'StaticSet' || typeName == 'Set' || typeName == '_Set')) {
      return receiver;
    }

    // Array 类型 — 内部 C++ 类型，直接访问 _storage
    if (typeName == 'Array') {
      switch (methodName) {
        case 'isEmpty': return '($receiver->_storage.empty())';
        case 'isNotEmpty': return '(!$receiver->_storage.empty())';
        case 'length': return 'static_cast<int>($receiver->_storage.size())';
        case 'add': return '$receiver->_storage.push_back($args)';
        case 'clear': return '$receiver->_storage.clear()';
        case 'contains': return 'array_contains($receiver, $args)';
        case 'indexOf': return 'array_indexOf($receiver, $args)';
        case 'removeAt': return 'array_removeAt($receiver, $args)';
        case 'insert': return 'array_insert($receiver, $args)';
        default:
          if (args.isNotEmpty) return '$receiver->$methodName($args)';
          return '$receiver->$methodName()';
      }
    }

    // StaticIterator — 通过 ClassInfo 派发
    if (typeName == 'StaticIterator' || typeName == 'Iterator' || typeName.contains('Iterator')) {
      switch (methodName) {
        case 'moveNext': return 'iterator_moveNext(static_cast<AnyGC*>($receiver))';
        case 'current': return 'iterator_current(static_cast<AnyGC*>($receiver))';
        case 'reset': return 'iterator_reset(static_cast<AnyGC*>($receiver))';
        default:
          if (args.isNotEmpty) return '$receiver->$methodName($args)';
          return '$receiver->$methodName()';
      }
    }

    // ── ClassInfo 派发 ──
    final ciField = _collectionMethodToCiField[methodName] ?? methodName;
    // 完全未知类型且非 base ClassInfo 字段 → 无法派发，使用直接调用
    if (_classInfoTypeName(type) == 'ClassInfo' && !_baseClassInfoFields.contains(ciField)) {
      // 剥离 static_cast<AnyGC*>(...) 包装以访问具体类型的方法
      String directReceiver = receiver;
      final castPrefix = 'static_cast<AnyGC*>(';
      if (directReceiver.startsWith(castPrefix) && directReceiver.endsWith(')')) {
        directReceiver = directReceiver.substring(castPrefix.length, directReceiver.length - 1);
      }
      if (_noArgMethods.contains(methodName)) {
        return '$directReceiver->$methodName()';
      }
      return '$directReceiver->$methodName($args)';
    }
    // 含未解析类型参数时，_classInfoTypeName 将类型参数替换为 AnyGC*，
    // 生成 StaticXxxClassInfo<AnyGC*> 派发（所有特化结构布局相同）

    final vptrReceiver = 'static_cast<AnyGC*>($receiver)';

    // Build boxed args
    final allArgNodes = <Expression>[
      ...arguments.positional,
      ...arguments.named.map((e) => e.value),
    ];
    final boxedArgs = <String>[];
    for (int i = 0; i < allArgExprs.length; i++) {
      final argExpr = allArgExprs[i];
      final argNode = i < allArgNodes.length ? allArgNodes[i] : null;
      // 字面量直接 boxing（_getExpressionType 对字面量返回 null）
      if (argNode is IntLiteral) {
        boxedArgs.add('_box(static_cast<int64_t>($argExpr))');
      } else if (argNode is DoubleLiteral) {
        boxedArgs.add('_box($argExpr)');
      } else if (argNode is BoolLiteral) {
        boxedArgs.add('_box($argExpr)');
      } else if (argNode is StringLiteral) {
        boxedArgs.add('_box($argExpr)');
      } else if (argNode is NullLiteral) {
        boxedArgs.add('nullptr');
      } else {
        final argType = argNode != null ? _getExpressionType(argNode) : null;
        boxedArgs.add(_boxCollectionArg(argExpr, argType));
      }
    }

    // Build the ClassInfo dispatch call
    // 可选参数用 nullptr 填充以匹配 ClassInfo 函数指针的固定参数数量
    final maxArgs = _collectionMethodMaxArgs[methodName];
    if (maxArgs != null) {
      while (boxedArgs.length < maxArgs) {
        boxedArgs.add('nullptr');
      }
    }
    final ciCallArgs = boxedArgs.isNotEmpty ? '$vptrReceiver, ${boxedArgs.join(', ')}' : vptrReceiver;
    final ciAccess = _classInfoAccess(vptrReceiver, type, ciField);
    final ciCall = '$ciAccess($ciCallArgs)';

    // Template methods: cast AnyGC* result back to concrete type
    if (methodName == 'map' || methodName == 'expand' || methodName == 'cast' ||
        methodName == 'fold' || methodName == 'whereType') {
      return _castTemplateMethodResult(ciCall, methodName, typeName, methodTypeArgs);
    }

    return _unboxCollectionResult(ciCall, type, methodName);
  }

  /// Cast ClassInfo dispatch result for template methods (map, expand, cast, fold, whereType).
  /// The _vptr_* trampolines erase return type to AnyGC*; this casts it back to the
  /// concrete collection type or primitive based on the method's type arguments.
  String _castTemplateMethodResult(String ciCall, String methodName, String collTypeName, List<DartType>? methodTypeArgs) {
    final isSetType = collTypeName == 'StaticSet' || collTypeName == 'Set' || collTypeName == '_Set';
    final isMapType = collTypeName == 'StaticMap' || collTypeName == 'Map' || collTypeName == '_Map';

    // fold<R> returns R (primitive or pointer)
    if (methodName == 'fold') {
      if (methodTypeArgs != null && methodTypeArgs.isNotEmpty) {
        final R = _cppType(methodTypeArgs.first);
        if (R == 'int64_t' || R == 'double' || R == 'bool' || R == 'DartString') {
          return 'dynAs<$R>($ciCall)';
        }
        return 'static_cast<$R>($ciCall)';
      }
      return ciCall;
    }

    // Map.map<K2,V2> and Map.cast<K2,V2> return StaticMap<K2,V2>*
    // but _vptr_map creates StaticMap<AnyGC*,AnyGC*>*, so the cast would be
    // between unrelated types. All chained calls use ClassInfo dispatch
    // (identical layout regardless of type args), so return as AnyGC*.
    if ((methodName == 'map' || methodName == 'cast') && isMapType) {
      return ciCall;
    }

    // Determine R from method type args
    String R = 'AnyGC*';
    if (methodTypeArgs != null && methodTypeArgs.isNotEmpty) {
      R = _cppType(methodTypeArgs.first);
    }
    // If R contains unresolved type parameters not in scope, fall back to AnyGC*
    if (R != 'AnyGC*' && _containsUnresolvedTypeParam(R, _inScopeTypeParams)) {
      R = 'AnyGC*';
    }

    // expand, map, whereType, cast on Set/List → return AnyGC* (type-erased
    // StaticList/StaticSet). The _vptr_* trampolines create StaticList<AnyGC*>*,
    // so static_cast to StaticList<R>* would be invalid. ClassInfo dispatch
    // works correctly regardless of the type parameter.
    return ciCall;
  }

  /// 检查是否是运算符名称
  bool _isOperatorName(String name) {
    const operators = {
      '+', '-', '*', '/', '%', '<', '>', '<=', '>=', '==', '!=',
      '&', '|', '^', '~', '<<', '>>', '>>>', '~/', '_', 'unary-',
      '[]', '[]=',  // 索引运算符
    };
    return operators.contains(name);
  }

  /// 检查 C++ 表达式是否看起来像算术表达式（包含运算符）
  bool _looksLikeArithmeticExpr(String expr) {
    // 排除 C++ 构造：指针访问 (->), IIFE (([&]), 命名空间 (::), new, auto
    if (expr.contains('->') || expr.contains('[&]') || expr.contains('::') ||
        expr.contains('new ') || expr.contains('auto')) {
      return false;
    }
    // 检查是否包含算术运算符
    if (expr.contains('+') || expr.contains('-') || expr.contains('*') || expr.contains('/')) {
      return true;
    }
    return false;
  }

  /// 检查 C++ 表达式是否返回 DartString（基于函数调用模式）
  bool _cppExprReturnsString(String expr) {
    // 检查是否是已知的返回 DartString 的函数调用
    if (expr.startsWith('dart_str_') || expr.startsWith('std::to_string')) {
      return true;
    }
    // 检查是否是 dart_str() 调用
    if (expr.startsWith('dart_str(')) {
      return true;
    }
    // 检查是否是 dynAs<DartString>() 调用
    if (expr.startsWith('dynAs<DartString>')) {
      return true;
    }
    // 检查是否是 Dart 字符串字面量生成的 DartString("...")
    if (expr.startsWith('DartString("') && expr.endsWith('")')) {
      return true;
    }
    // 检查是否是 StaticList<DartString> 的索引访问: (*var)[i]
    final listAccess = RegExp(r'^\(\*([A-Za-z_][A-Za-z0-9_]*)\)\[').firstMatch(expr);
    if (listAccess != null) {
      final varName = listAccess.group(1)!;
      final varType = _variableTypeMap[varName];
      if (varType != null && varType.contains('StaticList<DartString>')) {
        return true;
      }
    }
    // 检查是否是已跟踪的函数调用
    final match = RegExp(r'^([A-Za-z_][A-Za-z0-9_]*)\(').firstMatch(expr);
    if (match != null) {
      final funcName = match.group(1)!;
      if (_functionReturnTypes.containsKey(funcName)) {
        return _functionReturnTypes[funcName] == 'DartString';
      }
    }
    return false;
  }

  /// 生成运算符调用
  String _emitCppOperatorCall(Expression expr, String receiver, String op, String args) {
    // 清理运算符名称：operator== -> ==, operator[] -> [], etc.
    if (op.startsWith('operator')) {
      op = op.substring('operator'.length);
    }
    final right = args.isNotEmpty ? _splitTopLevel(args).first.trim() : '';

    // 特殊处理索引运算符
    if (op == '[]') {
      final receiverExpr = (expr is InstanceInvocation) ? expr.receiver : expr;
      final receiverType = _getExpressionType(receiverExpr);
      final receiverCppType = receiverType != null ? _cppType(receiverType) : '';

      // 如果接收器是 AnyPtr/AnyGC* 且类型未知，通过 ClassInfo 派发 [] 运算符
      if (_needsToVPtr(receiver, receiverType) && (receiverCppType.isEmpty || receiverCppType == 'AnyGC*')) {
        final vptrRecv = _convertToVPtr(receiver, receiverType);
        final call = 'static_cast<AnyGC*>($vptrRecv)->_classInfo->index(static_cast<AnyGC*>($vptrRecv), _box($right))';
        // 根据表达式静态类型添加返回值转换
        var exprType = _getExpressionType(expr);
        // 回退：从接收器的类型参数推断元素类型
        if (exprType == null && receiverType is InterfaceType && receiverType.typeArguments.isNotEmpty) {
          exprType = receiverType.typeArguments.first;
        }
        if (exprType != null) {
          final cppRetType = _cppType(exprType);
          if (cppRetType == 'int64_t') return 'dynAs<int64_t>($call)';
          if (cppRetType == 'double') return 'dynAs<double>($call)';
          if (cppRetType == 'bool') return 'dynAs<bool>($call)';
          if (cppRetType == 'DartString') return 'dynAs<DartString>($call)';
          if (cppRetType.endsWith('*') && cppRetType != 'AnyGC*') return 'static_cast<$cppRetType>($call)';
        }
        return call;
      }

      // 集合类型通过 ClassInfo 派发 [] 运算符
      if (receiverType is InterfaceType) {
        final typeName = receiverType.classNode.name;
        final isListType = typeName == 'List' || typeName == 'StaticList' ||
            typeName == '_List' || typeName == '_GrowableList' ||
            typeName == 'Iterable' || typeName == '_Iterable';
        final isMapType = typeName == 'Map' || typeName == 'StaticMap' || typeName == '_Map';
        if (isListType || isMapType) {
          // 未解析类型参数时使用直接访问
          if (!_dartTypeHasUnresolvedTypeParam(receiverType)) {
            final vptrRecv = 'static_cast<AnyGC*>($receiver)';
            final ciCall = '${_classInfoAccess(vptrRecv, receiverType, 'index')}($vptrRecv, _box($right))';
            // 根据 element/value 类型 unbox
            final elementType = isMapType
                ? (receiverType.typeArguments.length > 1 ? receiverType.typeArguments[1] : null)
                : (receiverType.typeArguments.isNotEmpty ? receiverType.typeArguments.first : null);
            if (elementType != null) {
              final elemCppType = _cppType(elementType);
              if (elemCppType == 'int64_t') return 'dynAs<int64_t>($ciCall)';
              if (elemCppType == 'double') return 'dynAs<double>($ciCall)';
              if (elemCppType == 'bool') return 'dynAs<bool>($ciCall)';
              if (elemCppType == 'DartString') return 'dynAs<DartString>($ciCall)';
              if (elemCppType.endsWith('*') && elemCppType != 'AnyGC*') return 'static_cast<$elemCppType>($ciCall)';
              if (_isCppTypeParameter(elemCppType)) return '_unboxElem<$elemCppType>($ciCall)';
            }
            return ciCall;
          }
        }
      }

      // 集合类型（未解析类型参数）通过 base ClassInfo 派发 [] 运算符
      if (receiverType is InterfaceType) {
        final typeName = receiverType.classNode.name;
        final isListType = typeName == 'List' || typeName == 'StaticList' ||
            typeName == '_List' || typeName == '_GrowableList';
        final isMapType = typeName == 'Map' || typeName == 'StaticMap' || typeName == '_Map';
        if (isListType || isMapType) {
          final vptrRecv = 'static_cast<AnyGC*>($receiver)';
          final ciCall = 'static_cast<ClassInfo*>(${vptrRecv}->AnyGC::_classInfo)->index($vptrRecv, _box($right))';
          final elementType = isMapType
              ? (receiverType.typeArguments.length > 1 ? receiverType.typeArguments[1] : null)
              : (receiverType.typeArguments.isNotEmpty ? receiverType.typeArguments.first : null);
          if (elementType != null) {
            final elemCppType = _cppType(elementType);
            if (elemCppType == 'int64_t') return 'dynAs<int64_t>($ciCall)';
            if (elemCppType == 'double') return 'dynAs<double>($ciCall)';
            if (elemCppType == 'bool') return 'dynAs<bool>($ciCall)';
            if (elemCppType == 'DartString') return 'dynAs<DartString>($ciCall)';
            if (elemCppType.endsWith('*') && elemCppType != 'AnyGC*') return 'static_cast<$elemCppType>($ciCall)';
            if (_isCppTypeParameter(elemCppType) && !_dartTypeHasUnresolvedTypeParam(elementType)) return '_unboxElem<$elemCppType>($ciCall)';
          }
          return ciCall;
        }
      }
      // 非指针类型（如 DartString）不需要解引用
      if (receiverCppType.isNotEmpty && !receiverCppType.endsWith('*')) {
        // DartString 的 operator[] 返回 char，但 Dart 中 String[index] 返回单字符 String
        if (receiverCppType == 'DartString') {
          return 'DartString(1, $receiver[$right])';
        }
        return '$receiver[$right]';
      }
      // 用户自定义类的 [] 运算符通过 ClassInfo 派发
      if (receiverType is InterfaceType && _userClasses.contains(receiverType.classNode.name)) {
        String vptrRecv = receiver;
        if (_needsToVPtr(receiver, receiverType)) {
          vptrRecv = _convertToVPtr(receiver, receiverType);
        }
        return '${_classInfoAccess(vptrRecv, receiverType, 'index')}($vptrRecv, _box($right))';
      }
      return '(*$receiver)[$right]';
    }
    if (op == '[]=') {
      final argList = _splitTopLevel(args);
      if (argList.length >= 2) {
        final index = argList[0].trim();
        final value = argList[1].trim();
        final receiverExpr = (expr is InstanceInvocation) ? expr.receiver : expr;
      final receiverType = _getExpressionType(receiverExpr);
        final receiverCppType = receiverType != null ? _cppType(receiverType) : '';
        // 集合类型通过 ClassInfo 派发 []= 运算符
        if (receiverType is InterfaceType) {
          final typeName = receiverType.classNode.name;
          final isListType = typeName == 'List' || typeName == 'StaticList' ||
              typeName == '_List' || typeName == '_GrowableList';
          final isMapType = typeName == 'Map' || typeName == 'StaticMap' || typeName == '_Map';
          if ((isListType || isMapType) && !_dartTypeHasUnresolvedTypeParam(receiverType)) {
            final vptrRecv = 'static_cast<AnyGC*>($receiver)';
            return '${_classInfoAccess(vptrRecv, receiverType, 'setIndex')}($vptrRecv, _box($index), _box($value))';
          }
        }
        // 集合类型（未解析类型参数）通过 base ClassInfo 派发 []= 运算符
        if (receiverType is InterfaceType) {
          final typeName = receiverType.classNode.name;
          final isListType = typeName == 'List' || typeName == 'StaticList' ||
              typeName == '_List' || typeName == '_GrowableList';
          final isMapType = typeName == 'Map' || typeName == 'StaticMap' || typeName == '_Map';
          if (isListType || isMapType) {
            final vptrRecv = 'static_cast<AnyGC*>($receiver)';
            return 'static_cast<ClassInfo*>(${vptrRecv}->AnyGC::_classInfo)->setIndex($vptrRecv, _box($index), _box($value))';
          }
        }
        // AnyGC* receiver: use ClassInfo dispatch
        if (receiverCppType.isEmpty || receiverCppType == 'AnyGC*') {
          return 'static_cast<AnyGC*>($receiver)->_classInfo->setIndex(static_cast<AnyGC*>($receiver), _box($index), _box($value))';
        }
        // 用户自定义类的 []= 运算符通过 ClassInfo 派发
        if (receiverType is InterfaceType && _userClasses.contains(receiverType.classNode.name)) {
          String vptrRecv = receiver;
          if (_needsToVPtr(receiver, receiverType)) {
            vptrRecv = _convertToVPtr(receiver, receiverType);
          }
          return '${_classInfoAccess(vptrRecv, receiverType, 'setIndex')}($vptrRecv, _box($index), _box($value))';
        }
        // 非指针类型不需要解引用
        if (receiverCppType.isNotEmpty && !receiverCppType.endsWith('*')) {
          return '$receiver[$index] = $value';
        }
        return '(*$receiver)[$index] = $value';
      }
    }

    // 用户自定义类的运算符通过 vptr 调度（指针类型不能直接用 C++ 运算符）
    final opReceiverExpr = (expr is InstanceInvocation) ? expr.receiver : expr;
    final receiverType = _getExpressionType(opReceiverExpr);
    if (receiverType is InterfaceType && _userClasses.contains(receiverType.classNode.name)) {
      final receiverCppType = _cppType(receiverType);
      String vptrReceiver = receiver;
      if (_needsToVPtr(receiver, receiverType)) {
        vptrReceiver = _convertToVPtr(receiver, receiverType);
      }
      if (right.isEmpty) {
        // 一元运算符
        final cleanOp = _cleanMethodName(op);
        final raw = '${_classInfoAccess(vptrReceiver, receiverType, cleanOp)}($vptrReceiver)';
        // 如果返回类型是指针，需要转换
        if (receiverCppType.endsWith('*')) {
          return 'reinterpret_cast<$receiverCppType>($raw)';
        }
        return raw;
      }
      final cleanOp = _cleanMethodName(op);
      final raw = '${_classInfoAccess(vptrReceiver, receiverType, cleanOp)}($vptrReceiver, _box($right))';
      // 对于比较运算符，返回 bool — ClassInfo dispatch returns bool directly
      if (['==', '!=', '<', '>', '<=', '>='].contains(op)) {
        return raw;
      }
      // 如果返回类型是指针，需要转换
      if (receiverCppType.endsWith('*')) {
        return 'reinterpret_cast<$receiverCppType>($raw)';
      }
      return raw;
    }

    // 对 AnyGC* 接收器的算术运算符，需要先拆箱
    final opReceiverExpr2 = (expr is InstanceInvocation) ? expr.receiver : null;
    final opReceiverType2 = opReceiverExpr2 != null ? _getExpressionType(opReceiverExpr2) : null;
    final opReceiverCppType2 = opReceiverType2 != null ? _cppType(opReceiverType2) : '';
    if (opReceiverCppType2 == 'AnyGC*' && ['+', '-', '*', '/', '%'].contains(op)) {
      final numType = right.contains('.') ? 'double' : 'int64_t';
      final unboxed = 'dynAs<$numType>($receiver)';
      switch (op) {
        case '+': return '($unboxed + $right)';
        case '-': return right.isEmpty ? '(-$unboxed)' : '($unboxed - $right)';
        case '*': return '($unboxed * $right)';
        case '/': return numType == 'int64_t' ? '(static_cast<double>($unboxed) / static_cast<double>($right))' : '($unboxed / $right)';
        case '%': return '($unboxed % $right)';
      }
    }

    // 当右操作数是 AnyGC* 时（如 Promise->result），需要根据接收器类型转换
    if (_isAnyPtrResult(right) && ['+', '-', '*', '/', '%'].contains(op)) {
      final numType = receiver.contains('.') ? 'double' : 'int64_t';
      final unboxedRight = 'dynAs<$numType>($right)';
      switch (op) {
        case '+': return '($receiver + $unboxedRight)';
        case '-': return '($receiver - $unboxedRight)';
        case '*': return '($receiver * $unboxedRight)';
        case '/': return numType == 'int64_t' ? '(static_cast<double>($receiver) / static_cast<double>($unboxedRight))' : '($receiver / $unboxedRight)';
        case '%': return '($receiver % $unboxedRight)';
      }
    }

    // 对 AnyGC* 接收器的比较运算符，也需要先拆箱
    final effectiveReceiverCppType = opReceiverCppType2.isNotEmpty
        ? opReceiverCppType2
        : (_isAnyGCPtrExpr(receiver) ? 'AnyGC*' : '');
    if (effectiveReceiverCppType == 'AnyGC*' && ['==', '!=', '<', '>', '<=', '>='].contains(op)) {
      // 根据右操作数判断拆箱类型
      if (RegExp(r'^-?\d+(LL)?$').hasMatch(right) || right.endsWith('LL')) {
        final unboxed = 'dynAs<int64_t>($receiver)';
        return '($unboxed $op $right)';
      }
      if (RegExp(r'^-?\d+\.\d+$').hasMatch(right)) {
        final unboxed = 'dynAs<double>($receiver)';
        return '($unboxed $op $right)';
      }
      if (right.startsWith('DartString(') || right.startsWith('"')) {
        final unboxed = 'dynAs<DartString>($receiver)';
        return '($unboxed $op $right)';
      }
      if (right == 'true' || right == 'false') {
        final unboxed = 'dynAs<bool>($receiver)';
        return '($unboxed $op $right)';
      }
      // 右操作数也是 AnyGC*：直接比较指针
      if (_isAnyGCPtrExpr(right)) {
        return '($receiver $op $right)';
      }
    }

    // 对 AnyGC* 右操作数的比较，左操作数是具体类型时，拆箱右操作数
    if (_isAnyGCPtrExpr(right) && ['==', '!=', '<', '>', '<=', '>='].contains(op)) {
      if (effectiveReceiverCppType == 'int64_t' || effectiveReceiverCppType == 'int') {
        return '($receiver $op dynAs<int64_t>($right))';
      }
      if (effectiveReceiverCppType == 'double') {
        return '($receiver $op dynAs<double>($right))';
      }
      if (effectiveReceiverCppType == 'DartString') {
        return '($receiver $op dynAs<DartString>($right))';
      }
      if (effectiveReceiverCppType == 'bool') {
        return '($receiver $op dynAs<bool>($right))';
      }
    }

    // List + List 通过 ClassInfo 派发
    if (op == '+') {
      final opReceiverExpr = (expr is InstanceInvocation) ? expr.receiver : expr;
      final opType = _getExpressionType(opReceiverExpr);
      if (opType is InterfaceType) {
        final typeName = opType.classNode.name;
        final isListType = typeName == 'List' || typeName == 'StaticList' ||
            typeName == '_List' || typeName == '_GrowableList';
        if (isListType && !_dartTypeHasUnresolvedTypeParam(opType)) {
          final vptrRecv = 'static_cast<AnyGC*>($receiver)';
          final ciCall = '${_classInfoAccess(vptrRecv, opType, 'plus')}($vptrRecv, _box($right))';
          final elemType = opType.typeArguments.isNotEmpty ? _cppType(opType.typeArguments.first) : 'AnyGC*';
          return 'static_cast<StaticList<$elemType>*>($ciCall)';
        }
      }
    }

    switch (op) {
      case '+': return '($receiver + $right)';
      case '-': return right.isEmpty ? '(-$receiver)' : '($receiver - $right)';
      case '*': return '($receiver * $right)';
      case '/':
        if (effectiveReceiverCppType == 'int64_t' || effectiveReceiverCppType == 'int') {
          return '(static_cast<double>($receiver) / static_cast<double>($right))';
        }
        return '($receiver / $right)';
      case '%': return '($receiver % $right)';
      case '<': return '($receiver < $right)';
      case '>': return '($receiver > $right)';
      case '<=': return '($receiver <= $right)';
      case '>=': return '($receiver >= $right)';
      case '==':
        // 当比较 map[key] == null 时，检查指针而不是解引用的值
        if ((right == 'nullptr') && receiver.startsWith('(*(*') && receiver.endsWith(')')) {
          // 移除外层解引用：(*(*map)[key]) -> (*map)[key]
          final ptrExpr = receiver.substring(2, receiver.length - 1);
          return '(dart_isNull($ptrExpr))';
        }
        return '($receiver == $right)';
      case '!=':
        // 当比较 map[key] != null 时，检查指针而不是解引用的值
        if ((right == 'nullptr') && receiver.startsWith('(*(*') && receiver.endsWith(')')) {
          final ptrExpr = receiver.substring(2, receiver.length - 1);
          return '($ptrExpr != nullptr)';
        }
        return '($receiver != $right)';
      case '&': return '($receiver & $right)';
      case '|': return '($receiver | $right)';
      case '^': return '($receiver ^ $right)';
      case '~': return '(~$receiver)';
      case '<<': return '($receiver << $right)';
      case '>>': return '($receiver >> $right)';
      case '>>>': return 'static_cast<int64_t>(static_cast<uint64_t>($receiver) >> $right)';
      case '~/': return '($receiver / $right)';  // Integer division
      case 'unary-': return '(-$receiver)';
      default: return '(throw DartUnsupportedError("unsupported operator: $op"), $receiver)';
    }
  }

  /// 获取表达式的类型信息
  DartType? _getExpressionType(Expression expr) {
    if (expr is VariableGet) {
      return expr.variable.type;
    } else if (expr is InstanceGet) {
      final target = expr.interfaceTarget;
      if (target is Field) {
        return target.type;
      } else if (target is Procedure && target.isGetter) {
        return target.function.returnType;
      }
    } else if (expr is StaticGet) {
      final target = expr.target;
      if (target is Field) {
        return target.type;
      } else if (target is Procedure && target.isGetter) {
        return target.function.returnType;
      }
    } else if (expr is StaticInvocation) {
      final target = expr.target;
      return target.function.returnType;
    } else if (expr is InstanceInvocation) {
      final target = expr.interfaceTarget;
      // 对于运算符调用，使用接收器类型作为结果类型（int+int→int, double+double→double）
      final opName = target.name.text;
      if (_isOperatorName(opName) && opName != '[]' && opName != '[]=') {
        if (opName == '/' || opName == '>=' || opName == '<=' || opName == '>' || opName == '<' || opName == '==' || opName == '!=') {
          return target.function.returnType;
        }
        final receiverType = _getExpressionType(expr.receiver);
        if (receiverType != null && _isPrimitiveType(receiverType)) {
          return receiverType;
        }
      }
      // 对于 [] 操作符，从接收器的泛型参数推断元素类型
      if (opName == '[]') {
        final receiverType = _getExpressionType(expr.receiver);
        if (receiverType is InterfaceType && receiverType.typeArguments.isNotEmpty) {
          // List<T>、Set<T> 返回 T，Map<K,V> 返回 V
          final typeName = receiverType.classNode.name;
          if (typeName == 'List' || typeName == 'StaticList' || typeName == 'Set' || typeName == 'StaticSet') {
            return receiverType.typeArguments.first;
          }
          if (typeName == 'Map' || typeName == 'StaticMap') {
            return receiverType.typeArguments.length >= 2 ? receiverType.typeArguments[1] : null;
          }
        }
      }
      final returnType = target.function.returnType;
      // If return type has unresolved type parameters, try substituting from receiver
      if (_dartTypeHasUnresolvedTypeParam(returnType)) {
        final recvType = _getExpressionType(expr.receiver);
        if (recvType is InterfaceType) {
          final substituted = _trySubstTypeParams(returnType, recvType);
          if (substituted != null && !_dartTypeHasUnresolvedTypeParam(substituted)) {
            return substituted;
          }
        }
      }
      return returnType;
    } else if (expr is ConstructorInvocation) {
      final target = expr.target;
      final enclosing = target.enclosingClass;
      if (expr.arguments.types.isNotEmpty) {
        return InterfaceType(enclosing, Nullability.nonNullable, expr.arguments.types);
      }
      return InterfaceType(enclosing, Nullability.nonNullable);
    } else if (expr is NullCheck) {
      return _getExpressionType(expr.operand);
    } else if (expr is AsExpression) {
      // AsExpression 的类型就是目标类型
      return expr.type;
    } else if (expr is Let) {
      return _getExpressionType(expr.body);
    } else if (expr is MapLiteral) {
      // MapLiteral 的类型信息需要从上下文推断，简化返回 null
      return null;
    } else if (expr is ListLiteral) {
      // ListLiteral 在 C++ 中映射为 StaticList<T>，但无法构造 InterfaceType
      // 返回 null，由调用方检查 expr is ListLiteral
      return null;
    } else if (expr is SetLiteral) {
      // SetLiteral 在 C++ 中映射为 StaticSet<T>
      return null;
    } else if (expr is RecordIndexGet) {
      // Record 字段访问：使用 RecordIndexGet 自带的 receiverType
      final recordType = expr.receiverType;
      if (expr.index < recordType.positional.length) {
        return recordType.positional[expr.index];
      }
    } else if (expr is RecordNameGet) {
      // Record 命名字段访问
      final receiverType = _getExpressionType(expr.receiver);
      if (receiverType is RecordType) {
        final name = expr.name;
        for (final n in receiverType.named) {
          if (n.name == name) return n.type;
        }
      }
    } else if (expr is VariableSet) {
      return expr.variable.type;
    } else if (expr is InstanceSet) {
      final target = expr.interfaceTarget;
      if (target is Field) {
        return target.type;
      } else if (target is Procedure && target.isSetter && target.function.positionalParameters.isNotEmpty) {
        return target.function.positionalParameters.first.type;
      }
      return null;
    } else if (expr is ConstantExpression) {
      final c = expr.constant;
      if (c is InstanceConstant) {
        if (c.typeArguments.isNotEmpty) {
          return InterfaceType(c.classNode, Nullability.nonNullable, c.typeArguments);
        }
        return InterfaceType(c.classNode, Nullability.nonNullable);
      } else if (c is StringConstant) {
        // 返回 String 类型 — 需要查找 String 类
        // 简化处理，返回 null（DartString 不是 InterfaceType）
        return null;
      } else if (c is IntConstant) {
        return null;
      } else if (c is DoubleConstant) {
        return null;
      } else if (c is BoolConstant) {
        return null;
      } else if (c is ListConstant) {
        if (c.typeArgument != null) {
          // 需要查找 List 类，简化返回 null
          return null;
        }
      }
    } else if (expr is ThisExpression) {
      // 返回当前类类型，但排除 mixin（mixin 自调用需要 null 类型走 mixin 专用派发路径）
      // 且所有类型参数必须在作用域内（避免静态上下文中 T 未声明）
      if (_currentClassName.isNotEmpty && !_mixinNames.contains(_currentClassName)) {
        final cls = _classNodes[_currentClassName];
        if (cls != null) {
          if (cls.typeParameters.isNotEmpty) {
            final allInScope = cls.typeParameters.every((tp) =>
              _inScopeTypeParams.contains(tp.name ?? 'T'));
            if (!allInScope) return null;
            final typeArgs = cls.typeParameters.map((tp) =>
              TypeParameterType(tp, Nullability.nonNullable)
            ).toList();
            return InterfaceType(cls, Nullability.nonNullable, typeArgs);
          }
          return InterfaceType(cls, Nullability.nonNullable);
        }
      }
      return null;
    }
    return null;
  }

  /// 检查是否是基本类型
  bool _isPrimitiveType(DartType? type) {
    if (type is InterfaceType) {
      final name = type.classNode.name;
      return name == 'int' || name == 'double' || name == 'bool' || name == 'String';
    }
    return false;
  }

  bool _isDynamicOrAnyGC(DartType? type) {
    if (type is DynamicType) return true;
    if (type is InterfaceType) {
      final name = type.classNode.name;
      return name == 'Object' || name.startsWith('TypeFunction');
    }
    return false;
  }

  /// 检查 C++ 表达式是否需要转换为 AnyGC* 才能使用 -> 访问
  /// 综合模式匹配和类型信息判断
  bool _needsToVPtr(String expr, DartType? type) {
    if (_isAnyPtrExpr(expr)) return true;
    if (type != null && _cppType(type) == 'AnyGC*') return true;
    if (_isAnyGCPtrExpr(expr)) return true;
    return false;
  }

  /// 将 AnyPtr/AnyGC* 转换为 AnyGC*（用于访问 _classInfo）
  String _convertToVPtr(String expr, DartType? type) {
    return 'static_cast<AnyGC*>($expr)';
  }

  /// 检查 C++ 表达式字符串是否可能是 AnyGC* 值类型（非指针）
  /// 用于在 vptr 派发时决定是否需要 static_cast 到 AnyGC*
  bool _isAnyPtrExpr(String expr) {
    // 已经通过 dynAs<T>(...) 转换的，是具体类型值
    if (expr.startsWith('dynAs<')) return false;
    if (expr.endsWith('this_')) return false;       // 本地 this 指针
    if (expr.startsWith('new ')) return false;      // new 表达式返回指针
    if (expr.startsWith('static_cast<')) return false; // 类型转换
    if (expr.startsWith('reinterpret_cast<')) return false;
    if (expr.contains('::')) return false;           // 命名空间/静态访问
    if (expr.contains('->')) return false;           // 指针成员访问
    if (expr.contains('_new(')) return false;        // 构造函数返回指针
    // 明确是 AnyGC* 值类型的模式
    if (expr.startsWith('(*')) return true;        // 解引用的指针（如 Map 访问）
    if (expr.startsWith('_box(')) return true;   // AnyGC* 构造
    if (expr == '_box()') return true;
    // 默认认为不是 AnyPtr（保守，避免误加 static_cast 到 AnyGC*）
    return false;
  }

  /// 根据类型名生成基本类型方法调用（不需要 DartType 对象）
  String _emitCppPrimitiveMethodCallByName(String receiver, String methodName, String args, String typeName) {

    // String 类型的方法
    if (typeName == 'String') {
      switch (methodName) {
        case 'startsWith':
          final arg = args.split(',').first.trim();
          return '($receiver.find($arg) == 0)';
        case 'endsWith':
          final arg = args.split(',').first.trim();
          return '($receiver.length() >= $arg.length() && $receiver.substr($receiver.length() - $arg.length()) == $arg)';
        case 'contains':
          final arg = args.split(',').first.trim();
          return '($receiver.find($arg) != DartString::npos)';
        case 'indexOf':
          final arg = args.split(',').first.trim();
          return 'static_cast<int64_t>($receiver.find($arg))';
        case 'substring':
          final argList = args.split(',');
          if (argList.length == 1) {
            return '$receiver.substr(${argList[0].trim()})';
          } else {
            return '$receiver.substr(${argList[0].trim()}, ${argList[1].trim()} - ${argList[0].trim()})';
          }
        case 'toLowerCase':
          return 'dart_str_toLower($receiver)';
        case 'toUpperCase':
          return 'dart_str_toUpper($receiver)';
        case 'trim':
          return 'dart_str_trim($receiver)';
        case 'split':
          final arg = args.split(',').first.trim();
          return 'dart_str_split($receiver, $arg)';
        case 'replaceAll':
          final argList = args.split(',');
          return 'dart_str_replaceAll($receiver, ${argList[0].trim()}, ${argList[1].trim()})';
        case 'replaceFirst':
          final argList = args.split(',');
          final from = argList[0].trim();
          final to = argList[1].trim();
          final start = argList.length > 2 ? argList[2].trim() : '0';
          return 'dart_str_replaceFirst($receiver, $from, $to, $start)';
        case 'replaceRange':
          final argList = args.split(',');
          return 'dart_str_replaceRange($receiver, ${argList[0].trim()}, ${argList[1].trim()}, ${argList[2].trim()})';
        case 'padLeft':
          final argList = args.split(',');
          final width = argList[0].trim();
          final padding = argList.length > 1 ? argList[1].trim() : 'DartString(" ")';
          return 'dart_str_padLeft($receiver, $width, $padding)';
        case 'padRight':
          final argList = args.split(',');
          final width = argList[0].trim();
          final padding = argList.length > 1 ? argList[1].trim() : 'DartString(" ")';
          return 'dart_str_padRight($receiver, $width, $padding)';
        case 'trimLeft':
          return 'dart_str_trimLeft($receiver)';
        case 'trimRight':
          return 'dart_str_trimRight($receiver)';
        case 'lastIndexOf':
          final argList = args.split(',');
          final pattern = argList[0].trim();
          final start = argList.length > 1 ? argList[1].trim() : 'static_cast<int64_t>($receiver.size()) - 1';
          return 'dart_str_lastIndexOf($receiver, $pattern, $start)';
        case 'codeUnitAt':
          final arg = args.split(',').first.trim();
          return 'dart_str_codeUnitAt($receiver, $arg)';
        case 'length':
          return 'static_cast<int64_t>($receiver.length())';
        case 'isEmpty':
          return '$receiver.empty()';
        case 'isNotEmpty':
          return '!$receiver.empty()';
        case 'compareTo':
          final arg = args.split(',').first.trim();
          return 'static_cast<int64_t>($receiver.compare($arg))';
        case 'hashCode':
          return 'static_cast<int64_t>(std::hash<DartString>{}($receiver))';
        default:
          return '(throw DartUnsupportedError("unsupported String method: $methodName"), $receiver)';
      }
    }

    // int/double 类型的方法
    if (typeName == 'int' || typeName == 'double') {
      switch (methodName) {
        case 'abs':
          return 'std::abs($receiver)';
        case 'toString':
          if (typeName == 'double') return '_toStr($receiver)';
          return 'std::to_string($receiver)';
        case 'toInt':
          return 'static_cast<int64_t>($receiver)';
        case 'toDouble':
          return 'static_cast<double>($receiver)';
        case 'hashCode':
          if (typeName == 'int') {
            return 'static_cast<int64_t>($receiver)';
          } else {
            return 'static_cast<int64_t>(std::hash<double>{}($receiver))';
          }
        case 'clamp':
          final argList = args.split(',');
          if (argList.length >= 2) {
            final lower = argList[0].trim();
            final upper = argList[1].trim();
            final cppType = typeName == 'int' ? 'int64_t' : 'double';
            return 'std::max(static_cast<$cppType>($lower), std::min($receiver, static_cast<$cppType>($upper)))';
          }
          return '(throw DartUnsupportedError("unsupported clamp arguments"), $receiver)';
        case 'toStringAsFixed':
          if (typeName == 'double') {
            final fracDigits = args.split(',').first.trim();
            return '([&]() { std::ostringstream _ss; _ss << std::fixed << std::setprecision($fracDigits) << $receiver; return _ss.str(); })()';
          }
          return 'std::to_string($receiver)';
        case 'toStringAsPrecision':
          if (typeName == 'double') {
            final precision = args.split(',').first.trim();
            return '([&]() { std::ostringstream _ss; _ss << std::setprecision($precision) << $receiver; return _ss.str(); })()';
          }
          return 'std::to_string($receiver)';
        case 'toRadixString':
          if (typeName == 'int') {
            final radix = args.split(',').first.trim();
            return 'dart_int_toRadixString($receiver, $radix)';
          }
          return 'std::to_string($receiver)';
        case 'round':
          if (typeName == 'double') return 'static_cast<int64_t>(std::round($receiver))';
          return '$receiver';
        case 'floor':
          if (typeName == 'double') return 'static_cast<int64_t>(std::floor($receiver))';
          return '$receiver';
        case 'ceil':
          if (typeName == 'double') return 'static_cast<int64_t>(std::ceil($receiver))';
          return '$receiver';
        case 'truncate':
          if (typeName == 'double') return 'static_cast<int64_t>($receiver)';
          return '$receiver';
        case 'sign':
          if (typeName == 'int') return '(($receiver > 0) ? 1LL : (($receiver < 0) ? -1LL : 0LL))';
          return '(std::isnan($receiver) ? $receiver : (($receiver == 0.0) ? $receiver : (($receiver > 0.0) ? 1.0 : -1.0)))';
        case 'isNaN':
          if (typeName == 'double') return 'std::isnan($receiver)';
          return 'false';
        case 'isInfinite':
          if (typeName == 'double') return 'std::isinf($receiver)';
          return 'false';
        case 'isNegative':
          if (typeName == 'double') return '(($receiver < 0.0) || ($receiver == 0.0 && std::signbit($receiver)))';
          return '($receiver < 0)';
        case 'compareTo':
          final cmpType = typeName == 'int' ? 'int64_t' : 'double';
          return '(($receiver) > static_cast<$cmpType>($args) ? 1LL : (($receiver) < static_cast<$cmpType>($args) ? -1LL : 0LL))';
        case 'ceilToDouble':
          return 'static_cast<double>(std::ceil($receiver))';
        case 'floorToDouble':
          return 'static_cast<double>(std::floor($receiver))';
        case 'roundToDouble':
          return 'static_cast<double>(std::round($receiver))';
        case 'truncateToDouble':
          return 'static_cast<double>(static_cast<int64_t>($receiver))';
        case 'toStringAsExponential':
          if (typeName == 'double') {
            final fracDigits = args.split(',').first.trim();
            return 'dart_double_toStringAsExponential($receiver, $fracDigits)';
          }
          return 'std::to_string($receiver)';
        case 'remainder':
          if (typeName == 'double') {
            final other = args.split(',').first.trim();
            return 'std::remainder($receiver, static_cast<double>($other))';
          }
          return 'static_cast<double>(0)';
        default:
          return '(throw DartUnsupportedError("unsupported ${typeName} method: $methodName"), $receiver)';
      }
    }

    return '(throw DartUnsupportedError("unsupported primitive method: $methodName on $typeName"), $receiver)';
  }

  /// 当接收器是 DartString C++ 表达式时，处理字符串方法调用
  /// 返回 null 如果方法无法处理
  String? _emitCppStringMethodCall(String receiver, String methodName, String args) {
    switch (methodName) {
      case 'contains':
        final arg = args.split(',').first.trim();
        return '($receiver.find($arg) != DartString::npos)';
      case 'startsWith':
        final arg = args.split(',').first.trim();
        return '($receiver.find($arg) == 0)';
      case 'endsWith':
        final arg = args.split(',').first.trim();
        return '($receiver.length() >= $arg.length() && $receiver.substr($receiver.length() - $arg.length()) == $arg)';
      case 'indexOf':
        final arg = args.split(',').first.trim();
        return 'static_cast<int64_t>($receiver.find($arg))';
      case 'length':
        return 'static_cast<int64_t>($receiver.length())';
      case 'isEmpty':
        return '$receiver.empty()';
      case 'isNotEmpty':
        return '!$receiver.empty()';
      case 'substring':
        final argList = args.split(',');
        if (argList.length == 1) return '$receiver.substr(${argList[0].trim()})';
        return '$receiver.substr(${argList[0].trim()}, ${argList[1].trim()} - ${argList[0].trim()})';
      case 'trim': return 'dart_str_trim($receiver)';
      case 'toLowerCase': return 'dart_str_toLower($receiver)';
      case 'toUpperCase': return 'dart_str_toUpper($receiver)';
      case 'split':
        final arg = args.split(',').first.trim();
        return 'dart_str_split($receiver, $arg)';
      case 'replaceAll':
        final argList = args.split(',');
        return 'dart_str_replaceAll($receiver, ${argList[0].trim()}, ${argList[1].trim()})';
      case 'replaceFirst':
        final argList = args.split(',');
        final from = argList[0].trim();
        final to = argList[1].trim();
        final start = argList.length > 2 ? argList[2].trim() : '0';
        return 'dart_str_replaceFirst($receiver, $from, $to, $start)';
      case 'replaceRange':
        final argList = args.split(',');
        return 'dart_str_replaceRange($receiver, ${argList[0].trim()}, ${argList[1].trim()}, ${argList[2].trim()})';
      case 'padLeft':
        final argList = args.split(',');
        final width = argList[0].trim();
        final padding = argList.length > 1 ? argList[1].trim() : 'DartString(" ")';
        return 'dart_str_padLeft($receiver, $width, $padding)';
      case 'padRight':
        final argList = args.split(',');
        final width = argList[0].trim();
        final padding = argList.length > 1 ? argList[1].trim() : 'DartString(" ")';
        return 'dart_str_padRight($receiver, $width, $padding)';
      case 'trimLeft':
        return 'dart_str_trimLeft($receiver)';
      case 'trimRight':
        return 'dart_str_trimRight($receiver)';
      case 'lastIndexOf':
        final argList = args.split(',');
        final pattern = argList[0].trim();
        final start = argList.length > 1 ? argList[1].trim() : 'static_cast<int64_t>($receiver.size()) - 1';
        return 'dart_str_lastIndexOf($receiver, $pattern, $start)';
      case 'codeUnitAt':
        final arg = args.split(',').first.trim();
        return 'dart_str_codeUnitAt($receiver, $arg)';
      case 'hashCode':
        return 'static_cast<int64_t>(std::hash<DartString>{}($receiver))';
      case 'compareTo':
        final arg = args.split(',').first.trim();
        return 'static_cast<int64_t>($receiver.compare($arg))';
      default:
        return null;
    }
  }

  String _emitCppStaticInvocation(StaticInvocation expr) {
    final Member? target = expr.target;
    if (target == null) return '/* null target */';

    // 处理 _GrowableList (Dart 内部列表实现) → StaticList
    if (target.enclosingClass != null && target.enclosingClass!.name == '_GrowableList') {
      final typeArgs = expr.arguments.types;
      final name = target.name.text;

      // 辅助函数：获取列表元素类型，优先使用外层泛型构造函数期望的类型
      String resolveStaticListElementType() {
        if (typeArgs.isNotEmpty) {
          final typeArg = _cppType(typeArgs.first);
          if (typeArg == 'AnyGC*' && _expectedCollectionElementType != null) {
            return _expectedCollectionElementType!;
          }
          return typeArg;
        }
        if (_expectedCollectionElementType != null) {
          return _expectedCollectionElementType!;
        }
        return 'AnyGC*';
      }

      // 处理 _literal* 系列 (列表字面量)
      if (name.startsWith('_literal')) {
        var typeArg = resolveStaticListElementType();
        final rawElems = expr.arguments.positional.toList();
        final emittedElems = rawElems.map((e) => _emitCppExpr(e)).toList();
        typeArg = _correctListInnerType(typeArg, emittedElems);
        final elements = emittedElems.asMap().entries.map((entry) {
          var s = entry.value;
          if (typeArg == 'AnyGC*') {
            s = _cppMaybeBoxForAnyGC(s, rawElems[entry.key]);
          }
          return s;
        }).join(', ');
        return 'GC::allocateLocal(new StaticList<$typeArg>({$elements}))';
      }

      // 处理空构造函数
      if (name.isEmpty) {
        final typeArg = resolveStaticListElementType();
        return 'GC::allocateLocal(new StaticList<$typeArg>())';
      }
    }

    // 检查是否是 print
    if (target.name.text == 'print') {
      final arg = expr.arguments.positional.isNotEmpty
          ? _emitCppExpr(expr.arguments.positional.first)
          : '""';
      return 'staticPrint($arg)';
    }

    // identical(a, b) → (a == b)
    if (target.name.text == 'identical' && expr.arguments.positional.length == 2) {
      final a = _emitCppExpr(expr.arguments.positional[0]);
      final b = _emitCppExpr(expr.arguments.positional[1]);
      return '($a == $b)';
    }

    // RegExp 构造函数 → 直接使用 pattern 字符串（C++ 不支持正则）
    if (target.enclosingClass != null && target.enclosingClass!.name == 'RegExp') {
      if (expr.arguments.positional.isNotEmpty) {
        return _emitCppExpr(expr.arguments.positional.first);
      }
      return 'DartString("")';
    }

    // 检查是否是 smAwait (异步等待运行时函数)
    if (target.name.text == 'smAwait') {
      final arg = expr.arguments.positional.isNotEmpty
          ? _emitCppExpr(expr.arguments.positional.first)
          : 'nullptr';
      // 从类型参数推断返回类型
      String resultType = 'AnyGC*';
      if (expr.arguments.types.isNotEmpty) {
        resultType = _cppType(expr.arguments.types.first);
      }
      // void → int: Promise<void> 已移除，void 默认更改为 int
      if (resultType == 'void') resultType = 'int';
      // smAwait<T> returns T, so no conversion needed
      // When T is AnyGC*, primitive args need boxing
      final boxedArg = resultType == 'AnyGC*' ? '_box($arg)' : arg;
      return 'smAwait<$resultType>($boxedArg)';
    }

    // 检查是否是构造函数
    if (target is Constructor) {
      final Class? enclosing = target.enclosingClass;
      if (enclosing != null) {
        return _emitCppConstructorCall(enclosing.name, target, expr.arguments);
      }
    }


    // 检查是否是集合类型的工厂构造函数或静态方法
    if (target is Procedure) {
      final enclosing = target.enclosingClass;
      if (enclosing != null) {
        final className = enclosing.name;
        final isCollection = (className == 'StaticList' || className == 'List' ||
                             className == 'StaticSet' || className == 'Set' ||
                             className == 'StaticMap' || className == 'Map');

        // 处理集合类型的 .of() 方法
        if (isCollection && target.name.text == 'of') {
          if (className == 'StaticList' || className == 'List') {
            if (expr.arguments.positional.length == 1) {
              final arg = expr.arguments.positional.first;
              if (arg is ListLiteral) {
                // StaticList.of([list_literal]) - extract elements directly
                // Set expected map types if element type is a map
                String? savedMapKeyType, savedMapValueType;
                if (expr.arguments.types.isNotEmpty) {
                  final elemDartType = expr.arguments.types.first;
                  if (elemDartType is InterfaceType &&
                      (elemDartType.classNode.name == 'Map' || elemDartType.classNode.name == 'StaticMap') &&
                      elemDartType.typeArguments.length >= 2) {
                    savedMapKeyType = _expectedMapKeyType;
                    savedMapValueType = _expectedMapValueType;
                    _expectedMapKeyType = _cppType(elemDartType.typeArguments[0]);
                    _expectedMapValueType = _cppType(elemDartType.typeArguments[1]);
                  }
                }
                final typeArg = expr.arguments.types.isNotEmpty
                    ? _cppType(expr.arguments.types.first)
                    : 'AnyGC*';
                final rawElems = arg.expressions.toList();
                final emittedElems = rawElems.map((e) => _emitCppExpr(e)).toList();
                final correctedTypeArg =
                    _correctListInnerType(typeArg, emittedElems);
                final elements = emittedElems.asMap().entries.map((entry) {
                  var s = entry.value;
                  if (correctedTypeArg == 'AnyGC*') {
                    s = _cppMaybeBoxForAnyGC(s, rawElems[entry.key]);
                  }
                  return s;
                }).join(', ');
                // Restore expected map types
                if (savedMapKeyType != null || savedMapValueType != null) {
                  _expectedMapKeyType = savedMapKeyType;
                  _expectedMapValueType = savedMapValueType;
                }
                return 'GC::allocateLocal(new StaticList<$correctedTypeArg>({$elements}))';
              } else if (arg is StaticInvocation) {
                // StaticList.of(StaticList<int>({1, 2, 3, 4, 5})) - the inner StaticList is already created
                // Use StaticList::from() to copy elements from the source
                final innerExpr = _emitCppExpr(arg);
                if (expr.arguments.types.isNotEmpty) {
                  final typeArg = _cppType(expr.arguments.types.first);
                  return 'StaticList<$typeArg>::from($innerExpr)';
                }
                return 'StaticList<AnyGC*>::from($innerExpr)';
              } else if (arg is ConstructorInvocation) {
                // Handle constructor invocations (e.g., _GrowableList._literal)
                final innerExpr = _emitCppExpr(arg);
                if (expr.arguments.types.isNotEmpty) {
                  final typeArg = _cppType(expr.arguments.types.first);
                  return 'StaticList<$typeArg>::from($innerExpr)';
                }
                return 'StaticList<AnyGC*>::from($innerExpr)';
              } else {
                // StaticList.of(other_list) - need to copy elements
                final listExpr = _emitCppExpr(arg);
                if (expr.arguments.types.isNotEmpty) {
                  final typeArg = _cppType(expr.arguments.types.first);
                  // If the inner expression is already a StaticList pointer, use ::from()
                  if (listExpr.startsWith('GC::allocateLocal(new StaticList')) {
                    return 'StaticList<$typeArg>::from($listExpr)';
                  }
                  // Create a new StaticList and copy from the source
                  return '([&]() { auto* _src = $listExpr; auto* _dst = GC::allocateLocal(new StaticList<$typeArg>()); for (int _i = 0; _i < _src->_data->_storage.size(); _i++) _dst->_data->_storage.push_back(_src->_data->_storage[_i]); return _dst; })()';
                }
                if (listExpr.startsWith('GC::allocateLocal(new StaticList')) {
                  return 'StaticList<AnyGC*>::from($listExpr)';
                }
                return '([&]() { auto* _src = $listExpr; auto* _dst = GC::allocateLocal(new StaticList<AnyGC*>()); for (int _i = 0; _i < _src->_data->_storage.size(); _i++) _dst->_data->_storage.push_back(_src->_data->_storage[_i]); return _dst; })()';
              }
            }
          } else if (className == 'StaticSet' || className == 'Set') {
            if (expr.arguments.positional.length == 1) {
              final arg = expr.arguments.positional.first;
              if (arg is ListLiteral) {
                final typeArg = expr.arguments.types.isNotEmpty
                    ? _cppType(expr.arguments.types.first)
                    : 'AnyGC*';
                final rawElems = arg.expressions.toList();
                final emittedElems = rawElems.map((e) => _emitCppExpr(e)).toList();
                final correctedTypeArg =
                    _correctListInnerType(typeArg, emittedElems);
                final elements = emittedElems.asMap().entries.map((entry) {
                  var s = entry.value;
                  if (correctedTypeArg == 'AnyGC*') {
                    s = _cppMaybeBoxForAnyGC(s, rawElems[entry.key]);
                  }
                  return s;
                }).join(', ');
                return 'GC::allocateLocal(new StaticSet<$correctedTypeArg>({$elements}))';
              } else if (arg is StaticInvocation) {
                // StaticSet.of(StaticList<int>({1, 2, 3})) - need to convert StaticList to StaticSet
                final listExpr = _emitCppExpr(arg);
                if (expr.arguments.types.isNotEmpty) {
                  final typeArg = _cppType(expr.arguments.types.first);
                  return '([&]() { auto* _src = $listExpr; auto* _dst = GC::allocateLocal(new StaticSet<$typeArg>()); for (int _i = 0; _i < _src->_data->_storage.size(); _i++) _dst->_data->_storage.push_back(_src->_data->_storage[_i]); return _dst; })()';
                }
                return '([&]() { auto* _src = $listExpr; auto* _dst = GC::allocateLocal(new StaticSet<AnyGC*>()); for (int _i = 0; _i < _src->_data->_storage.size(); _i++) _dst->_data->_storage.push_back(_src->_data->_storage[_i]); return _dst; })()';
              } else {
                final listExpr = _emitCppExpr(arg);
                if (expr.arguments.types.isNotEmpty) {
                  final typeArg = _cppType(expr.arguments.types.first);
                  return '([&]() { auto* _src = $listExpr; auto* _dst = GC::allocateLocal(new StaticSet<$typeArg>()); for (int _i = 0; _i < _src->_data->_storage.size(); _i++) _dst->_data->_storage.push_back(_src->_data->_storage[_i]); return _dst; })()';
                }
                return '([&]() { auto* _src = $listExpr; auto* _dst = GC::allocateLocal(new StaticSet<AnyGC*>()); for (int _i = 0; _i < _src->_data->_storage.size(); _i++) _dst->_data->_storage.push_back(_src->_data->_storage[_i]); return _dst; })()';
              }
            }
          }
          // 处理 StaticMap.of(map_expr) — 类型转换（copy or cast）
          if (className == 'StaticMap' || className == 'Map') {
            if (expr.arguments.positional.length == 1) {
              // Set expected map types before emitting the argument
              String? savedMapKeyType, savedMapValueType;
              if (expr.arguments.types.length >= 2) {
                savedMapKeyType = _expectedMapKeyType;
                savedMapValueType = _expectedMapValueType;
                _expectedMapKeyType = _cppType(expr.arguments.types[0]);
                _expectedMapValueType = _cppType(expr.arguments.types[1]);
              }
              final innerExpr = _emitCppExpr(expr.arguments.positional.first);
              // Restore expected map types
              if (savedMapKeyType != null || savedMapValueType != null) {
                _expectedMapKeyType = savedMapKeyType;
                _expectedMapValueType = savedMapValueType;
              }
              // StaticMap<K,V>.of(expr) → static_cast to StaticMap<K,V>*
              if (expr.arguments.types.length >= 2) {
                final keyType = _cppType(expr.arguments.types[0]);
                final valType = _cppType(expr.arguments.types[1]);
                // If the inner expression is a map literal, it was already generated with the right type
                if (expr.arguments.positional.first is MapLiteral) {
                  return innerExpr;
                }
                // Otherwise cast: AnyGC* → StaticMap<K,V>* or reinterpret_cast
                if (_isAnyGCPtrExpr(innerExpr) || innerExpr.startsWith('(*(*')) {
                  return 'static_cast<StaticMap<$keyType, $valType>*>($innerExpr)';
                }
                if (innerExpr.startsWith('_box(') || _isAnyPtrResult(innerExpr)) {
                  return 'static_cast<StaticMap<$keyType, $valType>*>($innerExpr)';
                }
                return 'static_cast<StaticMap<$keyType, $valType>*>($innerExpr)';
              }
              return innerExpr;
            }
          }
        }

        // 处理集合类型的默认构造函数
        // 检查是否是默认构造函数（空名称、'new'、'_new'、'#new' 等）
        final isDefaultCtor = target.name.text.isEmpty ||
                               target.name.text == '_new' ||
                               target.name.text == 'new' ||
                               target.name.text == '#new' ||
                               target.name.text == '';
        if (isCollection && isDefaultCtor) {
          if (className == 'StaticList' || className == 'List') {
            if (expr.arguments.positional.isEmpty && expr.arguments.named.isEmpty) {
              if (expr.arguments.types.isNotEmpty) {
                final typeArg = _cppType(expr.arguments.types.first);
                return 'GC::allocateLocal(new StaticList<$typeArg>())';
              }
              return 'GC::allocateLocal(new StaticList<AnyGC*>())';
            }
          } else if (className == 'StaticSet' || className == 'Set') {
            if (expr.arguments.positional.isEmpty && expr.arguments.named.isEmpty) {
              if (expr.arguments.types.isNotEmpty) {
                final typeArg = _cppType(expr.arguments.types.first);
                return 'GC::allocateLocal(new StaticSet<$typeArg>())';
              }
              return 'GC::allocateLocal(new StaticSet<AnyGC*>())';
            }
          } else if (className == 'StaticMap' || className == 'Map') {
            if (expr.arguments.positional.isEmpty && expr.arguments.named.isEmpty) {
              if (expr.arguments.types.length >= 2) {
                final keyType = _cppType(expr.arguments.types[0]);
                final valueType = _cppType(expr.arguments.types[1]);
                return 'GC::allocateLocal(new StaticMap<$keyType, $valueType>())';
              }
              return 'GC::allocateLocal(new StaticMap<AnyGC*, AnyGC*>())';
            }
          }
        }
      }
    }

    // Future/Promise 静态方法映射
    if (target is Procedure) {
      final enclosing = target.enclosingClass;
      if (enclosing != null && (enclosing.name == 'Future' || enclosing.name == '_Future')) {
        final methodName = target.name.text;
        final args = expr.arguments.positional.map((e) => _emitCppExpr(e)).join(', ');
        final typeArgs = expr.arguments.types;
        final typeArg = typeArgs.isNotEmpty ? _cppType(typeArgs.first) : 'AnyGC*';
        final safeTypeArg = _isCppTypeParameter(typeArg) ? 'AnyGC*' : typeArg;

        if (methodName == 'delayed') {
          // Future.delayed(Duration, [computation]) → promiseDelayed(ticks, computation)
          // 参数1: Duration → ticks (1 tick = 10ms)
          // 参数2: 可选的 computation，默认为返回 null
          final argList = expr.arguments.positional;
          String ticksExpr;
          String computationExpr;

          if (argList.isNotEmpty) {
            // 尝试从 Duration 提取 ticks
            final durExpr = argList[0];
            if (durExpr is ConstructorInvocation &&
                (durExpr.target.enclosingClass.name == 'Duration' ||
                 durExpr.target.enclosingClass.name == 'DurationValue')) {
              // 提取 milliseconds 参数
              int? ms;
              for (final named in durExpr.arguments.named) {
                if (named.name == 'milliseconds' && named.value is IntLiteral) {
                  ms = (named.value as IntLiteral).value;
                } else if (named.name == 'seconds' && named.value is IntLiteral) {
                  ms = (named.value as IntLiteral).value * 1000;
                }
              }
              if (durExpr.arguments.positional.isNotEmpty &&
                  durExpr.arguments.positional[0] is IntLiteral) {
                ms = (durExpr.arguments.positional[0] as IntLiteral).value;
              }
              final ticks = ms != null ? (ms / 10).ceil().clamp(1, 100000) : 1;
              ticksExpr = '$ticks';
            } else {
              // 通用情况：使用表达式的 inMilliseconds / 10
              final durCpp = _emitCppExpr(durExpr);
              ticksExpr = '(($durCpp).inMilliseconds() / 10)';
            }
          } else {
            ticksExpr = '1';
          }

          if (argList.length >= 2) {
            computationExpr = _emitCppExpr(argList[1]);
          } else {
            computationExpr = 'nullptr';
          }

          return 'Promise_delayed<$safeTypeArg>($ticksExpr, $computationExpr)';
        }
        if (methodName == 'value') {
          return 'Promise<$safeTypeArg>::resolved($args)';
        }
        if (methodName == 'error' || methodName == 'rejected') {
          return 'Promise<$safeTypeArg>::rejected($args)';
        }
      }
    }

    // 处理基本类型的静态方法（如 int.parse, double.parse）
    if (target is Procedure && target.enclosingClass != null) {
      final className = target.enclosingClass!.name;
      final methodName = target.name.text;

      if (className == 'int' && methodName == 'parse') {
        final arg = expr.arguments.positional.isNotEmpty
            ? _emitCppExpr(expr.arguments.positional.first)
            : '""';
        return 'dart_stoll($arg)';
      }
      if (className == 'double' && methodName == 'parse') {
        final arg = expr.arguments.positional.isNotEmpty
            ? _emitCppExpr(expr.arguments.positional.first)
            : '""';
        return 'dart_stod($arg)';
      }
      // Handle List.from, Set.from, Map.from static methods
      if ((className == 'List' || className == 'StaticList') && methodName == 'from') {
        String? savedExpectedType;
        if (expr.arguments.types.isNotEmpty) {
          savedExpectedType = _expectedCollectionElementType;
          _expectedCollectionElementType = _cppType(expr.arguments.types.first);
        }
        final arg = expr.arguments.positional.isNotEmpty
            ? _emitCppExpr(expr.arguments.positional.first)
            : 'nullptr';
        if (savedExpectedType != null) {
          _expectedCollectionElementType = savedExpectedType;
        }
        if (expr.arguments.types.isNotEmpty) {
          final typeArg = _cppType(expr.arguments.types.first);
          return 'StaticList<$typeArg>::from($arg)';
        }
        return 'StaticList<AnyGC*>::from($arg)';
      }
      if ((className == 'Set' || className == 'StaticSet') && methodName == 'from') {
        String? savedExpectedType;
        if (expr.arguments.types.isNotEmpty) {
          savedExpectedType = _expectedCollectionElementType;
          _expectedCollectionElementType = _cppType(expr.arguments.types.first);
        }
        final arg = expr.arguments.positional.isNotEmpty
            ? _emitCppExpr(expr.arguments.positional.first)
            : 'nullptr';
        if (savedExpectedType != null) {
          _expectedCollectionElementType = savedExpectedType;
        }
        if (expr.arguments.types.isNotEmpty) {
          final typeArg = _cppType(expr.arguments.types.first);
          return 'StaticSet<$typeArg>::from($arg)';
        }
        return 'StaticSet<AnyGC*>::from($arg)';
      }
      if ((className == 'Map' || className == 'StaticMap') && methodName == 'from') {
        final arg = expr.arguments.positional.isNotEmpty
            ? _emitCppExpr(expr.arguments.positional.first)
            : 'nullptr';
        if (expr.arguments.types.length >= 2) {
          final keyType = _cppType(expr.arguments.types[0]);
          final valType = _cppType(expr.arguments.types[1]);
          return 'StaticMap<$keyType, $valType>::from($arg)';
        }
        return 'StaticMap<AnyGC*, AnyGC*>::from($arg)';
      }
      // Handle String.fromCharCode(code) / String.fromCharCodes(list)
      if (className == 'String' && methodName == 'fromCharCode') {
        final arg = _emitCppExpr(expr.arguments.positional.first);
        return 'dart_str_fromCharCode($arg)';
      }
      if (className == 'String' && methodName == 'fromCharCodes') {
        final arg = _emitCppExpr(expr.arguments.positional.first);
        return 'dart_str_fromCharCodes($arg)';
      }
      // Handle List.filled(count, value) → create StaticList with count copies of value
      if ((className == 'List' || className == 'StaticList') && methodName == 'filled') {
        final args = expr.arguments.positional;
        if (args.length >= 2) {
          final countExpr = _emitCppExpr(args[0]);
          final valueExpr = _emitCppExpr(args[1]);
          final typeArg = expr.arguments.types.isNotEmpty
              ? _cppType(expr.arguments.types.first)
              : 'AnyGC*';
          return '([&]() { auto* _list = GC::allocateLocal(new StaticList<$typeArg>()); for (int64_t _i = 0; _i < $countExpr; _i++) _list->_data->_storage.push_back($valueExpr); return _list; })()';
        }
      }
      // Handle List.generate(count, generator) → create StaticList by calling generator for each index
      if ((className == 'List' || className == 'StaticList') && methodName == 'generate') {
        final args = expr.arguments.positional;
        if (args.length >= 2) {
          final countExpr = _emitCppExpr(args[0]);
          final genExpr = _emitCppExpr(args[1]);
          final typeArg = expr.arguments.types.isNotEmpty
              ? _cppType(expr.arguments.types.first)
              : 'AnyGC*';
          return '([&]() { auto* _list = GC::allocateLocal(new StaticList<$typeArg>()); auto* _gen = $genExpr; for (int64_t _i = 0; _i < $countExpr; _i++) _list->_data->_storage.push_back(_gen->typedFnPtr(_gen, _i)); return _list; })()';
        }
      }
    }

    // 处理运行时类的静态方法（如 StaticList.filled, StaticList.generate）
    // 这些方法可能没有 enclosingClass（因为是 C++ 运行时类）
    final funcNameLower = target.name.text.toLowerCase();
    if (funcNameLower == 'filled' && expr.arguments.positional.length >= 2) {
      final countExpr = _emitCppExpr(expr.arguments.positional[0]);
      final valueExpr = _emitCppExpr(expr.arguments.positional[1]);
      final typeArg = expr.arguments.types.isNotEmpty
          ? _cppType(expr.arguments.types.first)
          : 'AnyGC*';
      return '([&]() { auto* _list = GC::allocateLocal(new StaticList<$typeArg>()); for (int64_t _i = 0; _i < $countExpr; _i++) _list->_data->_storage.push_back($valueExpr); return _list; })()';
    }
    if (funcNameLower == 'generate' && expr.arguments.positional.length >= 2) {
      final countExpr = _emitCppExpr(expr.arguments.positional[0]);
      final genExpr = _emitCppExpr(expr.arguments.positional[1]);
      final typeArg = expr.arguments.types.isNotEmpty
          ? _cppType(expr.arguments.types.first)
          : 'AnyGC*';
      return '([&]() { auto* _list = GC::allocateLocal(new StaticList<$typeArg>()); auto* _gen = $genExpr; for (int64_t _i = 0; _i < $countExpr; _i++) _list->_data->_storage.push_back(dynAs<$typeArg>(_gen->fnPtr(_gen, _box(_i)))); return _list; })()';
    }

    var funcName = _cleanName(target.name.text);
    // 对参数进行类型转换（AnyGC* 装箱 + nullptr 转换 + 命名参数映射）
    FunctionNode? targetFunc;
    if (target is Procedure) targetFunc = target.function;
    else if (target is Constructor) targetFunc = target.function;
    final argExprs = <String>[];
    // 处理位置参数
    for (var i = 0; i < expr.arguments.positional.length; i++) {
      var argStr = _emitCppExpr(expr.arguments.positional[i]);
      if (targetFunc != null && i < targetFunc.positionalParameters.length) {
        final paramDartType = targetFunc.positionalParameters[i].type;
        // 解析类型参数：如果函数有类型参数且调用提供了类型实参，则解析
        String paramCppType;
        if (targetFunc.typeParameters.isNotEmpty && expr.arguments.types.isNotEmpty) {
          paramCppType = _resolveTypeParamInType(paramDartType, targetFunc.typeParameters, expr.arguments.types);
        } else {
          paramCppType = _cppType(paramDartType);
        }
        if (paramCppType == 'AnyGC*') {
          argStr = _cppMaybeBoxForAnyGC(argStr, expr.arguments.positional[i]);
        } else if (paramCppType.endsWith('*') && paramCppType != 'AnyGC*' &&
                   (argStr.contains('static_cast<AnyGC*>') || _isAnyGCPtrExpr(argStr) ||
                    argStr.contains('-> AnyGC*'))) {
          // 参数期望具体指针类型但实参是 AnyGC*，需要 static_cast
          argStr = 'static_cast<$paramCppType>($argStr)';
        } else {
          argStr = _convertNullToType(argStr, paramCppType);
        }
      }
      argExprs.add(argStr);
    }
    // 处理命名参数：映射到位置参数顺序
    if (targetFunc != null && targetFunc.namedParameters.isNotEmpty) {
      // 构建命名参数映射
      final namedArgMap = <String, Expression>{};
      for (final named in expr.arguments.named) {
        namedArgMap[named.name] = named.value;
      }
      // 按函数定义的命名参数顺序填充
      for (final param in targetFunc.namedParameters) {
        final paramName = param.name ?? '';
        final paramCppType = _cppType(param.type);
        if (namedArgMap.containsKey(paramName)) {
          // 设置期望的集合/映射类型（供字面量发射使用）
          String? savedMapKeyType, savedMapValueType, savedCollElemType;
          final paramDartType = param.type;
          if (paramDartType is InterfaceType) {
            final clsName = paramDartType.classNode.name;
            if ((clsName == 'Map' || clsName == 'StaticMap') && paramDartType.typeArguments.length >= 2) {
              savedMapKeyType = _expectedMapKeyType;
              savedMapValueType = _expectedMapValueType;
              _expectedMapKeyType = _cppType(paramDartType.typeArguments[0]);
              _expectedMapValueType = _cppType(paramDartType.typeArguments[1]);
            }
            if ((clsName == 'List' || clsName == 'StaticList' || clsName == 'Set' || clsName == 'StaticSet') && paramDartType.typeArguments.isNotEmpty) {
              savedCollElemType = _expectedCollectionElementType;
              _expectedCollectionElementType = _cppType(paramDartType.typeArguments[0]);
            }
          }
          var argStr = _emitCppExpr(namedArgMap[paramName]!);
          // 恢复期望的类型
          if (savedMapKeyType != null || savedMapValueType != null) {
            _expectedMapKeyType = savedMapKeyType;
            _expectedMapValueType = savedMapValueType;
          }
          if (savedCollElemType != null) {
            _expectedCollectionElementType = savedCollElemType;
          }
          if (paramCppType == 'AnyGC*') {
            argStr = _cppMaybeBoxForAnyGC(argStr, namedArgMap[paramName]!);
          } else {
            argStr = _convertNullToType(argStr, paramCppType);
          }
          argExprs.add(argStr);
        } else if (param.initializer != null) {
          // 调用方未提供该命名参数，使用 Dart 默认值
          var defaultStr = _emitCppExpr(param.initializer!);
          defaultStr = _convertNullToType(defaultStr, paramCppType);
          argExprs.add(defaultStr);
        }
      }
    }
    final args = argExprs.join(', ');
    var nameAlreadyQualified = false;

    // 处理合成/空名称的静态调用（如 lowered 构造函数辅助函数）
    final _isUnnamedCtor = (funcName == '_unnamed' && target.name.text.isEmpty) ||
                           (funcName == '_' && target.name.text == '_' && target is Procedure && target.isFactory);
    if (_isUnnamedCtor && target.enclosingClass != null) {
      final encClassName = target.enclosingClass!.name;
      // Exception 特殊处理：直接生成 DartException
      if (encClassName == 'Exception' || encClassName == 'ExceptionValue') {
        // 从 StringBox 中提取字符串值
        final boxMatch = RegExp(r'GC::allocateLocal\(new StringBox\((.+)\)\)$').firstMatch(args);
        if (boxMatch != null) {
          return 'DartException(${boxMatch.group(1)})';
        }
        return 'DartException($args)';
      }
      // MapEntry/StaticMapEntry 特殊处理
      if (encClassName == 'MapEntry' || encClassName == 'StaticMapEntry') {
        final posArgs = argExprs;
        String keyType = 'DartString';
        String valType = 'AnyGC*';
        if (expr.arguments.types.length >= 2) {
          keyType = _cppType(expr.arguments.types[0]);
          valType = _cppType(expr.arguments.types[1]);
        }
        final keyExpr = posArgs.isNotEmpty ? posArgs[0] : '""';
        String valExpr = posArgs.length > 1 ? posArgs[1] : 'nullptr';
        if (valType == 'AnyGC*' && expr.arguments.positional.length > 1) {
          valExpr = _cppMaybeBoxForAnyGC(valExpr, expr.arguments.positional[1]);
        }
        return 'StaticMapEntry<$keyType, $valType>($keyExpr, $valExpr)';
      }
      funcName = '${_cleanName(encClassName)}_new';
      nameAlreadyQualified = true;
    }

    // 静态方法调用：加上类名前缀（如 MathUtils.factorial → MathUtils_factorial）
    if (!nameAlreadyQualified && target is Procedure && target.enclosingClass != null) {
      final encClassName = _cleanName(target.enclosingClass!.name);
      // 跳过 SDK 内置类的静态方法（已特殊处理的除外）
      final isUserClass = _userClasses.contains(target.enclosingClass!.name);
      if (isUserClass) {
        if (target.isFactory) {
          // 工厂构造函数：ClassName_new_name
          funcName = '${encClassName}_new_$funcName';
        } else if (target.isGetter) {
          // getter：ClassName_get_name
          funcName = '${encClassName}_get_$funcName';
        } else if (target.isSetter) {
          // setter：ClassName_set_name
          funcName = '${encClassName}_set_$funcName';
        } else {
          funcName = '${encClassName}_$funcName';
        }
      }
    }

    // 添加显式模板参数（当函数有类型参数且调用提供了类型实参时）
    String templateArgs = '';
    if (expr.arguments.types.isNotEmpty) {
      final targetHasTypeParams = (target is Procedure && target.function.typeParameters.isNotEmpty) ||
                                  (target is Constructor && target.function.typeParameters.isNotEmpty);
      if (targetHasTypeParams) {
        // 检查是否有类型参数解析为 AnyGC*（如 Comparable, Object 等接口类型）
        // 如果所有类型参数都是 AnyGC*，让 C++ 从函数参数推断类型
        final cppTypeArgsList = expr.arguments.types.map((t) => _cppType(t)).toList();
        final allAnyGC = cppTypeArgsList.every((t) => t == 'AnyGC*');
        if (!allAnyGC) {
          templateArgs = '<${cppTypeArgsList.join(', ')}>';
        }
      }
    }

    // Catch-all for collection .from() factory methods that weren't caught earlier
    // (e.g., when enclosingClass name doesn't match expected patterns)
    if (funcName == 'from' && target.enclosingClass != null) {
      final encName = target.enclosingClass!.name;
      if (encName == 'StaticMap' || encName == 'Map' || encName == '_Map' ||
          encName == '_InternalLinkedHashMap' || encName == 'LinkedHashMap' ||
          encName == '_LinkedHashMap') {
        if (expr.arguments.types.length >= 2) {
          final keyType = _cppType(expr.arguments.types[0]);
          final valType = _cppType(expr.arguments.types[1]);
          return 'StaticMap<$keyType, $valType>::from($args)';
        }
        return 'StaticMap<AnyGC*, AnyGC*>::from($args)';
      }
      if (encName == 'StaticList' || encName == 'List' || encName == '_GrowableList') {
        if (expr.arguments.types.isNotEmpty) {
          final typeArg = _cppType(expr.arguments.types.first);
          return 'StaticList<$typeArg>::from($args)';
        }
        return 'StaticList<AnyGC*>::from($args)';
      }
      if (encName == 'StaticSet' || encName == 'Set') {
        if (expr.arguments.types.isNotEmpty) {
          final typeArg = _cppType(expr.arguments.types.first);
          return 'StaticSet<$typeArg>::from($args)';
        }
        return 'StaticSet<AnyGC*>::from($args)';
      }
    }

    return '$funcName$templateArgs($args)';
  }

  String _emitCppConstructorInvocation(ConstructorInvocation expr) {
    return _emitCppConstructorCall(expr.target.enclosingClass.name, expr.target, expr.arguments);
  }

  String _emitCppConstructorCall(String className, Constructor ctor, Arguments args) {
    // RegExp 构造函数 → 直接使用 pattern 字符串
    if (className == 'RegExp') {
      if (args.positional.isNotEmpty) {
        return _emitCppExpr(args.positional.first);
      }
      return 'DartString("")';
    }

    // 处理 _GrowableList (Dart 内部列表实现) → StaticList
    if (className == '_GrowableList') {
      final ctorName = ctor.name.text;
      final typeArgs = args.types;

      // 辅助函数：获取列表元素类型，优先使用外层泛型构造函数期望的类型
      String resolveListElementType() {
        if (typeArgs.isNotEmpty) {
          final typeArg = _cppType(typeArgs.first);
          // 如果类型参数映射到 AnyGC* 且有外层期望的类型，使用期望的类型
          if (typeArg == 'AnyGC*' && _expectedCollectionElementType != null) {
            return _expectedCollectionElementType!;
          }
          return typeArg;
        }
        if (_expectedCollectionElementType != null) {
          return _expectedCollectionElementType!;
        }
        return 'AnyGC*';
      }

      // 处理 _literal* 系列 (列表字面量)
      if (ctorName.startsWith('_literal')) {
        final typeArg = resolveListElementType();
        final rawElems = args.positional.toList();
        final emittedElems = rawElems.map((e) => _emitCppExpr(e)).toList();
        final correctedTypeArg = _correctListInnerType(typeArg, emittedElems);
        final elements = emittedElems.asMap().entries.map((entry) {
          var s = entry.value;
          if (correctedTypeArg == 'AnyGC*') {
            s = _cppMaybeBoxForAnyGC(s, rawElems[entry.key]);
          }
          return s;
        }).join(', ');
        return 'GC::allocateLocal(new StaticList<$correctedTypeArg>({$elements}))';
      }

      // 处理空构造函数
      if (ctorName.isEmpty) {
        final typeArg = resolveListElementType();
        return 'GC::allocateLocal(new StaticList<$typeArg>())';
      }
    }

    // 处理内置类型的构造函数
    if (className == 'ArgumentError' || className == 'ArgumentErrorValue') {
      final callArgs = args.positional.map((e) => _emitCppExpr(e)).join(', ');
      return 'DartArgumentError(${_extractStringFromBox(callArgs)})';
    }
    if (className == 'Exception' || className == 'ExceptionValue') {
      final callArgs = args.positional.map((e) => _emitCppExpr(e)).join(', ');
      return 'DartException(${_extractStringFromBox(callArgs)})';
    }
    if (className == 'StateError' || className == 'StateErrorValue') {
      final callArgs = args.positional.map((e) => _emitCppExpr(e)).join(', ');
      return 'DartStateError(${_extractStringFromBox(callArgs)})';
    }
    if (className == 'RangeError' || className == 'RangeErrorValue') {
      final callArgs = args.positional.map((e) => _emitCppExpr(e)).join(', ');
      return 'DartRangeError(${_extractStringFromBox(callArgs)})';
    }
    if (className == 'FormatException' || className == 'FormatExceptionValue') {
      final callArgs = args.positional.map((e) => _emitCppExpr(e)).join(', ');
      return 'DartFormatException(${_extractStringFromBox(callArgs)})';
    }
    if (className == 'UnsupportedError' || className == 'UnsupportedErrorValue') {
      final callArgs = args.positional.map((e) => _emitCppExpr(e)).join(', ');
      return 'DartUnsupportedError(${_extractStringFromBox(callArgs)})';
    }
    if (className == 'UnimplementedError' || className == 'UnimplementedErrorValue') {
      final callArgs = args.positional.map((e) => _emitCppExpr(e)).join(', ');
      return 'DartUnimplementedError(${_extractStringFromBox(callArgs)})';
    }
    if (className == 'ReachabilityError') {
      final msg = args.positional.isNotEmpty
          ? _emitCppExpr(args.positional.first)
          : 'DartString("")';
      return 'ReachabilityError{._msg = $msg}';
    }
    if (className == 'Duration' || className == 'DurationValue') {
      final callArgs = args.positional.map((e) => _emitCppExpr(e)).join(', ');
      if (args.named.isNotEmpty) {
        // 处理命名参数，转换为 StaticDuration 的静态方法调用
        for (final named in args.named) {
          final name = named.name;
          final value = _emitCppExpr(named.value);
          if (name == 'milliseconds') {
            return 'StaticDuration::milliseconds($value)';
          } else if (name == 'seconds') {
            return 'StaticDuration::seconds($value)';
          } else if (name == 'minutes') {
            return 'StaticDuration::minutes($value)';
          } else if (name == 'hours') {
            return 'StaticDuration::hours($value)';
          } else if (name == 'days') {
            return 'StaticDuration::days($value)';
          } else if (name == 'microseconds') {
            return 'StaticDuration($value)';
          }
        }
      }
      return 'StaticDuration($callArgs)';
    }

    // 处理 DateTime 构造函数 → StaticDateTime
    if (className == 'DateTime' || className == 'DateTimeValue') {
      final ctorName = ctor.name.text;
      if (ctorName == 'now') {
        return 'StaticDateTime::now()';
      }
      final callArgs = args.positional.map((e) => _emitCppExpr(e)).join(', ');
      return 'StaticDateTime($callArgs)';
    }

    // 处理 MapEntry / StaticMapEntry 构造函数
    if (className == 'MapEntry' || className == 'StaticMapEntry') {
      final keyExpr = args.positional.length > 0 ? _emitCppExpr(args.positional[0]) : '""';
      final valExpr = args.positional.length > 1 ? _emitCppExpr(args.positional[1]) : 'nullptr';
      String keyType = 'DartString';
      String valType = 'AnyGC*';
      if (args.types.length >= 2) {
        keyType = _cppType(args.types[0]);
        valType = _cppType(args.types[1]);
      }
      // 对值进行装箱（如果目标是 AnyGC* 但值是基本类型）
      String boxedVal = valExpr;
      if (valType == 'AnyGC*' && args.positional.length > 1) {
        boxedVal = _cppMaybeBoxForAnyGC(valExpr, args.positional[1]);
      }
      return 'StaticMapEntry<$keyType, $valType>($keyExpr, $boxedVal)';
    }

    // 处理集合类型的构造函数
    if (className == 'StaticList' || className == 'List') {
      if (args.positional.isEmpty && args.named.isEmpty) {
        // 空列表：StaticList<T>()
        if (args.types.isNotEmpty) {
          final typeArg = _cppType(args.types.first);
          return 'GC::allocateLocal(new StaticList<$typeArg>())';
        }
        return 'GC::allocateLocal(new StaticList<AnyGC*>())';
      }
      // 带参数的列表构造函数
      // 检查是否是 StaticList.of([list_literal]) 模式
      if (args.positional.length == 1) {
        final arg = args.positional.first;
        if (arg is ListLiteral) {
          // Direct list literal
          // Set expected map types if element type is a map
          String? savedMapKeyType, savedMapValueType;
          if (args.types.isNotEmpty) {
            final elemDartType = args.types.first;
            if (elemDartType is InterfaceType &&
                (elemDartType.classNode.name == 'Map' || elemDartType.classNode.name == 'StaticMap') &&
                elemDartType.typeArguments.length >= 2) {
              savedMapKeyType = _expectedMapKeyType;
              savedMapValueType = _expectedMapValueType;
              _expectedMapKeyType = _cppType(elemDartType.typeArguments[0]);
              _expectedMapValueType = _cppType(elemDartType.typeArguments[1]);
            }
          }
          final typeArg = args.types.isNotEmpty ? _cppType(args.types.first) : 'AnyGC*';
          final rawElems = arg.expressions.toList();
          final emittedElems = rawElems.map((e) => _emitCppExpr(e)).toList();
          final correctedTypeArg = _correctListInnerType(typeArg, emittedElems);
          final elements = emittedElems.asMap().entries.map((entry) {
            var s = entry.value;
            if (correctedTypeArg == 'AnyGC*') {
              s = _cppMaybeBoxForAnyGC(s, rawElems[entry.key]);
            }
            return s;
          }).join(', ');
          // Restore expected map types
          if (savedMapKeyType != null || savedMapValueType != null) {
            _expectedMapKeyType = savedMapKeyType;
            _expectedMapValueType = savedMapValueType;
          }
          return 'GC::allocateLocal(new StaticList<$correctedTypeArg>({$elements}))';
        } else if (arg is ConstructorInvocation) {
          // Handle _GrowableList._literal* (Dart lowers [1,2,3] to _GrowableList._literal3(1,2,3))
          final innerClassName = arg.target.enclosingClass.name;
          final innerCtorName = arg.target.name.text;
          if (innerClassName == '_GrowableList' && innerCtorName.startsWith('_literal')) {
            final typeArg = args.types.isNotEmpty ? _cppType(args.types.first) : 'AnyGC*';
            final rawElems = arg.arguments.positional.toList();
            final emittedElems = rawElems.map((e) => _emitCppExpr(e)).toList();
            final correctedTypeArg = _correctListInnerType(typeArg, emittedElems);
            final elements = emittedElems.asMap().entries.map((entry) {
              var s = entry.value;
              if (correctedTypeArg == 'AnyGC*') {
                s = _cppMaybeBoxForAnyGC(s, rawElems[entry.key]);
              }
              return s;
            }).join(', ');
            return 'GC::allocateLocal(new StaticList<$correctedTypeArg>({$elements}))';
          }
        } else if (arg is StaticInvocation) {
          // Check if it's a StaticList creation (e.g., from List literal compilation)
          final target = arg.target;
          // Handle _GrowableList._literal* (Dart lowers [1,2,3] to _GrowableList._literal3(1,2,3))
          if (target is Procedure && target.enclosingClass != null) {
            final enclosingName = target.enclosingClass!.name;
            if (enclosingName == '_GrowableList' && target.name.text.startsWith('_literal')) {
              final typeArg = args.types.isNotEmpty ? _cppType(args.types.first) : 'AnyGC*';
              final rawElems = arg.arguments.positional.toList();
              final emittedElems = rawElems.map((e) => _emitCppExpr(e)).toList();
              final correctedTypeArg = _correctListInnerType(typeArg, emittedElems);
              final elements = emittedElems.asMap().entries.map((entry) {
                var s = entry.value;
                if (correctedTypeArg == 'AnyGC*') {
                  s = _cppMaybeBoxForAnyGC(s, rawElems[entry.key]);
                }
                return s;
              }).join(', ');
              return 'GC::allocateLocal(new StaticList<$correctedTypeArg>({$elements}))';
            }
          }
          if (target is Constructor && target.enclosingClass != null &&
              (target.enclosingClass!.name == 'StaticList' || target.enclosingClass!.name == 'List')) {
            // Extract the elements from the nested StaticList creation
            if (arg.arguments.positional.length == 1 && arg.arguments.positional.first is ListLiteral) {
              final listLiteral = arg.arguments.positional.first as ListLiteral;
              final typeArg = args.types.isNotEmpty ? _cppType(args.types.first) : 'AnyGC*';
              final rawElems = listLiteral.expressions.toList();
              final emittedElems = rawElems.map((e) => _emitCppExpr(e)).toList();
              final correctedTypeArg = _correctListInnerType(typeArg, emittedElems);
              final elements = emittedElems.asMap().entries.map((entry) {
                var s = entry.value;
                if (correctedTypeArg == 'AnyGC*') {
                  s = _cppMaybeBoxForAnyGC(s, rawElems[entry.key]);
                }
                return s;
              }).join(', ');
              return 'GC::allocateLocal(new StaticList<$correctedTypeArg>({$elements}))';
            }
          }
        }
      }
      final callArgs = args.positional.map((e) => _emitCppExpr(e)).join(', ');
      if (args.types.isNotEmpty) {
        final typeArg = _cppType(args.types.first);
        return 'GC::allocateLocal(new StaticList<$typeArg>($callArgs))';
      }
      return 'GC::allocateLocal(new StaticList<AnyGC*>($callArgs))';
    }

    if (className == 'StaticSet' || className == 'Set' || className == '_Set') {
      if (args.positional.isEmpty && args.named.isEmpty) {
        // 空集合：StaticSet<T>()
        if (args.types.isNotEmpty) {
          final typeArg = _cppType(args.types.first);
          return 'GC::allocateLocal(new StaticSet<$typeArg>())';
        }
        return 'GC::allocateLocal(new StaticSet<AnyGC*>())';
      }
      // 带参数的集合构造函数
      // 检查是否是 StaticSet.of([list_literal]) 模式
      if (args.positional.length == 1) {
        final arg = args.positional.first;
        if (arg is ListLiteral) {
          final elements = arg.expressions.map((e) => _emitCppExpr(e)).join(', ');
          if (args.types.isNotEmpty) {
            final typeArg = _cppType(args.types.first);
            return 'GC::allocateLocal(new StaticSet<$typeArg>({$elements}))';
          }
          return 'GC::allocateLocal(new StaticSet<AnyGC*>({$elements}))';
        } else if (arg is ConstructorInvocation) {
          // Handle _GrowableList._literal* (Dart lowers [1,2,3] to _GrowableList._literal3(1,2,3))
          final innerClassName = arg.target.enclosingClass.name;
          final innerCtorName = arg.target.name.text;
          if (innerClassName == '_GrowableList' && innerCtorName.startsWith('_literal')) {
            final elements = arg.arguments.positional.map((e) => _emitCppExpr(e)).join(', ');
            if (args.types.isNotEmpty) {
              final typeArg = _cppType(args.types.first);
              return 'GC::allocateLocal(new StaticSet<$typeArg>({$elements}))';
            }
            return 'GC::allocateLocal(new StaticSet<AnyGC*>({$elements}))';
          }
        } else if (arg is StaticInvocation) {
          final target = arg.target;
          // Handle _GrowableList._literal* (Dart lowers [1,2,3] to _GrowableList._literal3(1,2,3))
          if (target is Procedure && target.enclosingClass != null) {
            final enclosingName = target.enclosingClass!.name;
            if (enclosingName == '_GrowableList' && target.name.text.startsWith('_literal')) {
              final elements = arg.arguments.positional.map((e) => _emitCppExpr(e)).join(', ');
              if (args.types.isNotEmpty) {
                final typeArg = _cppType(args.types.first);
                return 'GC::allocateLocal(new StaticSet<$typeArg>({$elements}))';
              }
              return 'GC::allocateLocal(new StaticSet<AnyGC*>({$elements}))';
            }
          }
          if (target is Constructor && target.enclosingClass != null &&
              (target.enclosingClass!.name == 'StaticList' || target.enclosingClass!.name == 'List')) {
            if (arg.arguments.positional.length == 1 && arg.arguments.positional.first is ListLiteral) {
              final listLiteral = arg.arguments.positional.first as ListLiteral;
              final elements = listLiteral.expressions.map((e) => _emitCppExpr(e)).join(', ');
              if (args.types.isNotEmpty) {
                final typeArg = _cppType(args.types.first);
                return 'GC::allocateLocal(new StaticSet<$typeArg>({$elements}))';
              }
              return 'GC::allocateLocal(new StaticSet<AnyGC*>({$elements}))';
            }
          }
        }
      }
      final callArgs = args.positional.map((e) => _emitCppExpr(e)).join(', ');
      if (args.types.isNotEmpty) {
        final typeArg = _cppType(args.types.first);
        return 'GC::allocateLocal(new StaticSet<$typeArg>($callArgs))';
      }
      return 'GC::allocateLocal(new StaticSet<AnyGC*>($callArgs))';
    }

    if (className == 'StaticMap' || className == 'Map') {
      // Handle StaticMap.from(source) → StaticMap<K,V>::from(source)
      final ctorName = ctor.name.text;
      if (ctorName == 'from' && args.positional.length == 1) {
        // Set expected map types before emitting the argument
        String? savedMapKeyType, savedMapValueType;
        if (args.types.length >= 2) {
          savedMapKeyType = _expectedMapKeyType;
          savedMapValueType = _expectedMapValueType;
          _expectedMapKeyType = _cppType(args.types[0]);
          _expectedMapValueType = _cppType(args.types[1]);
        }
        final argExpr = _emitCppExpr(args.positional.first);
        if (savedMapKeyType != null || savedMapValueType != null) {
          _expectedMapKeyType = savedMapKeyType;
          _expectedMapValueType = savedMapValueType;
        }
        if (args.types.length >= 2) {
          final keyType = _cppType(args.types[0]);
          final valueType = _cppType(args.types[1]);
          return 'StaticMap<$keyType, $valueType>::from($argExpr)';
        }
        return 'StaticMap<AnyGC*, AnyGC*>::from($argExpr)';
      }
      if (ctorName == 'of' && args.positional.length == 1) {
        // Set expected map types before emitting the argument
        String? savedMapKeyType, savedMapValueType;
        if (args.types.length >= 2) {
          savedMapKeyType = _expectedMapKeyType;
          savedMapValueType = _expectedMapValueType;
          _expectedMapKeyType = _cppType(args.types[0]);
          _expectedMapValueType = _cppType(args.types[1]);
        }
        final argExpr = _emitCppExpr(args.positional.first);
        if (savedMapKeyType != null || savedMapValueType != null) {
          _expectedMapKeyType = savedMapKeyType;
          _expectedMapValueType = savedMapValueType;
        }
        // If argument is a MapLiteral, it was already generated as the right type
        if (args.positional.first is MapLiteral) {
          return argExpr;
        }
        if (args.types.length >= 2) {
          final keyType = _cppType(args.types[0]);
          final valueType = _cppType(args.types[1]);
          return 'StaticMap<$keyType, $valueType>::from($argExpr)';
        }
        return 'StaticMap<AnyGC*, AnyGC*>::from($argExpr)';
      }
      if (args.positional.isEmpty && args.named.isEmpty) {
        // 空映射：StaticMap<K, V>()
        if (args.types.length >= 2) {
          final keyType = _cppType(args.types[0]);
          final valueType = _cppType(args.types[1]);
          return 'GC::allocateLocal(new StaticMap<$keyType, $valueType>())';
        }
        return 'GC::allocateLocal(new StaticMap<AnyGC*, AnyGC*>())';
      }
      // 带参数的映射构造函数
      // 如果参数是 MapLiteral，设置期望的键值类型
      String? savedMapKeyType;
      String? savedMapValueType;
      if (args.types.length >= 2) {
        savedMapKeyType = _expectedMapKeyType;
        savedMapValueType = _expectedMapValueType;
        _expectedMapKeyType = _cppType(args.types[0]);
        _expectedMapValueType = _cppType(args.types[1]);
      }
      // 如果参数是 MapLiteral，map 字面量已经生成完整的 StaticMap*，直接返回
      if (args.positional.length == 1 && args.positional.first is MapLiteral) {
        final mapExpr = _emitCppExpr(args.positional.first);
        // 恢复期望的类型
        if (savedMapKeyType != null || savedMapValueType != null) {
          _expectedMapKeyType = savedMapKeyType;
          _expectedMapValueType = savedMapValueType;
        }
        return mapExpr;
      }
      final callArgs = args.positional.map((e) => _emitCppExpr(e)).join(', ');
      // 恢复期望的类型
      if (savedMapKeyType != null || savedMapValueType != null) {
        _expectedMapKeyType = savedMapKeyType;
        _expectedMapValueType = savedMapValueType;
      }
      if (args.types.length >= 2) {
        final keyType = _cppType(args.types[0]);
        final valueType = _cppType(args.types[1]);
        return 'GC::allocateLocal(new StaticMap<$keyType, $valueType>($callArgs))';
      }
      return 'GC::allocateLocal(new StaticMap<AnyGC*, AnyGC*>($callArgs))';
    }

    // 处理 Array 类型
    if (className == 'Array' || className == 'ArrayValue') {
      final typeArg = args.types.isNotEmpty ? _cppType(args.types.first) : 'AnyGC*';
      if (args.positional.isEmpty && args.named.isEmpty) {
        // 空数组
        return 'GC::allocateLocal(new Array<$typeArg>())';
      }
      // Array(size, fill) 或 Array.from(list)
      if (args.positional.isNotEmpty) {
        final sizeArg = _emitCppExpr(args.positional.first);
        if (args.named.isNotEmpty) {
          // 处理命名参数
          for (final named in args.named) {
            if (named.name == 'fill') {
              final fillArg = _emitCppExpr(named.value);
              return 'GC::allocateLocal(new Array<$typeArg>($sizeArg, $fillArg))';
            }
          }
        }
        return 'GC::allocateLocal(new Array<$typeArg>($sizeArg))';
      }
      return 'GC::allocateLocal(new Array<$typeArg>())';
    }

    // 处理 StringBuffer 构造函数 → StaticStringBuffer
    if (className == 'StringBuffer' || className == 'StaticStringBuffer') {
      final callArgs = args.positional.map((e) => _emitCppExpr(e)).join(', ');
      return 'GC::allocateLocal(new StaticStringBuffer($callArgs))';
    }

    final structName = _isRuntimeClassName(className) ? _cleanName(className) : '${_cleanName(className)}Value';
    final ctorName = ctor.name.text.isEmpty ? 'new' : 'new_${_cleanName(ctor.name.text)}';
    final funcName = '${_cleanName(className)}_$ctorName';

    // 检查是否是模板类
    final enclosingClass = ctor.enclosingClass;
    final typeParams = enclosingClass.typeParameters;
    final hasTemplate = typeParams.isNotEmpty;

    // 生成模板参数
    String templateArgs = '';
    if (hasTemplate) {
      // 优先使用调用时提供的类型参数
      if (args.types.isNotEmpty) {
        final typeArgs = args.types.map((t) => _cppType(t)).join(', ');
        templateArgs = '<$typeArgs>';
      } else {
        // 如果没有提供类型参数，使用类型参数名
        final typeArgs = typeParams.map((tp) => tp.name ?? 'T').join(', ');
        templateArgs = '<$typeArgs>';
      }
    }

    // 泛型类的构造函数：传递期望的集合元素类型给嵌套的列表/映射字面量
    final savedExpectedType = _expectedCollectionElementType;
    if (hasTemplate && args.types.isNotEmpty) {
      _expectedCollectionElementType = _cppType(args.types.first);
    }
    final positionalArgs = <String>[];
    final ctorFunc = ctor.function;
    for (var i = 0; i < args.positional.length; i++) {
      var argStr = _emitCppExpr(args.positional[i]);
      // Convert argument to appropriate parameter type
      if (i < ctorFunc.positionalParameters.length) {
        final paramDartType = ctorFunc.positionalParameters[i].type;
        String paramCppType;
        if (hasTemplate && args.types.isNotEmpty) {
          paramCppType = _resolveTypeParamInType(paramDartType, typeParams, args.types);
        } else {
          paramCppType = _cppType(paramDartType);
        }
        if (paramCppType == 'AnyGC*') {
          argStr = _cppMaybeBoxForAnyGC(argStr, args.positional[i]);
        } else if (paramCppType.endsWith('*') && paramCppType != 'AnyGC*' &&
                   (argStr.contains('static_cast<AnyGC*>') || _isAnyGCPtrExpr(argStr) ||
                    argStr.contains('-> AnyGC*') || argStr.endsWith(''))) {
          argStr = 'static_cast<$paramCppType>($argStr)';
        } else {
          argStr = _wrapToType(argStr, paramCppType, args.positional[i]);
        }
      }
      positionalArgs.add(argStr);
    }
    _expectedCollectionElementType = savedExpectedType;

    // 处理命名参数：映射到位置参数顺序
    if (args.named.isNotEmpty && ctorFunc.namedParameters.isNotEmpty) {
      final namedArgMap = <String, Expression>{};
      for (final named in args.named) {
        namedArgMap[named.name] = named.value;
      }
      for (final param in ctorFunc.namedParameters) {
        final paramName = param.name ?? '';
        if (namedArgMap.containsKey(paramName)) {
          final argStr = _emitCppExpr(namedArgMap[paramName]!);
          final paramCppType = _cppType(param.type);
          if (paramCppType == 'AnyGC*') {
            positionalArgs.add(_cppMaybeBoxForAnyGC(argStr, namedArgMap[paramName]!));
          } else {
            positionalArgs.add(argStr);
          }
        }
        // 如果调用方没有提供该命名参数，跳过（依赖 C++ 默认值）
      }
    }

    final callArgs = positionalArgs.join(', ');
    return '$funcName$templateArgs(GC::allocateLocal(new $structName$templateArgs())${callArgs.isNotEmpty ? ", $callArgs" : ""})';
  }

  String _emitCppStringConcat(StringConcatenation expr) {
    final parts = expr.expressions.map((e) {
      final part = _emitCppExpr(e);
      if (part.startsWith('DartString(') || part.startsWith('dart_str(')) return part;
      return 'dart_str($part)';
    });
    return parts.join(' + ');
  }

  String _emitCppConditional(ConditionalExpression expr) {
    final cond = _emitCppExpr(expr.condition);
    final then = _emitCppExpr(expr.then);
    final otherwise = _emitCppExpr(expr.otherwise);

    // 如果一个分支是 void（如 setter 调用），需要特殊处理
    // 将 void 分支包装为 (expr, nullptr) 使其返回 AnyPtr
    String thenFinal = then;
    String otherwiseFinal = otherwise;
    if (_isVoidExpression(then) && !_isVoidExpression(otherwise)) {
      thenFinal = '($then, nullptr)';
    } else if (_isVoidExpression(otherwise) && !_isVoidExpression(then)) {
      otherwiseFinal = '($otherwise, nullptr)';
    } else if (_isVoidExpression(then) && _isVoidExpression(otherwise)) {
      // 两边都是 void，使用 if-else 语句模式
      return '($cond ? ($then) : ($otherwise))';
    }

    // 检查是否需要类型转换 — 使用实际类型信息而非表达式字符串
    final thenDartType = _getExpressionType(expr.then);
    final otherwiseDartType = _getExpressionType(expr.otherwise);
    final thenCppTypeStr = thenDartType != null ? _cppType(thenDartType) : '';
    final otherwiseCppTypeStr = otherwiseDartType != null ? _cppType(otherwiseDartType) : '';
    thenFinal = _convertNullToType(thenFinal, otherwiseCppTypeStr.isNotEmpty ? otherwiseCppTypeStr : otherwiseFinal);
    otherwiseFinal = _convertNullToType(otherwiseFinal, thenCppTypeStr.isNotEmpty ? thenCppTypeStr : thenFinal);

    // 处理 AnyGC* 与原始类型的歧义（如 int 0 与 AnyGC* 在三元表达式中）
    thenFinal = _wrapForAnyPtrContext(thenFinal, otherwiseFinal, expr.then, expr.otherwise);
    otherwiseFinal = _wrapForAnyPtrContext(otherwiseFinal, thenFinal, expr.otherwise, expr.then);

    // 统一三元表达式两个分支的模板类型（如 Either_new_right<A,B> vs Either_new_left<A,C>）
    final unified = _unifyTernaryTemplateTypes(thenFinal, otherwiseFinal);
    thenFinal = unified[0];
    otherwiseFinal = unified[1];

    if (cond == 'true') return thenFinal;
    if (cond == 'false') return otherwiseFinal;
    return '($cond ? $thenFinal : $otherwiseFinal)';
  }

  /// 尝试统一三元表达式两个分支的返回类型。
  /// 当两个分支都是同一类模板的工厂函数调用但类型参数不同时
  /// （如 Either_new_right<string,string> vs Either_new_left<string,AnyGC*>），
  /// 使用 reinterpret_cast 将具体类型分支转换为 AnyGC* 版本，以便三元表达式类型匹配。
  List<String> _unifyTernaryTemplateTypes(String thenStr, String otherwiseStr) {
    // 匹配: ClassName_method<TypeArgs>(GC::allocateLocal(new ValueType<TypeArgs>()), ...)
    final pattern = RegExp(
      r'^(\w+)_new_(\w+)<([^>]+)>\(GC::allocateLocal\(new (\w+)<([^>]+)>\(\)\)(.*)$',
    );
    final thenMatch = pattern.firstMatch(thenStr);
    final otherwiseMatch = pattern.firstMatch(otherwiseStr);
    if (thenMatch == null || otherwiseMatch == null) return [thenStr, otherwiseStr];

    // 检查是否是同一个类和值类型
    final thenClass = thenMatch.group(1)!;
    final otherwiseClass = otherwiseMatch.group(1)!;
    final thenValueType = thenMatch.group(4)!;
    final otherwiseValueType = otherwiseMatch.group(4)!;
    if (thenClass != otherwiseClass || thenValueType != otherwiseValueType) {
      return [thenStr, otherwiseStr];
    }

    // 解析 ValueType 的模板参数（group 5）
    final thenTypeArgs = _splitTemplateArgs(thenMatch.group(5)!);
    final otherwiseTypeArgs = _splitTemplateArgs(otherwiseMatch.group(5)!);
    if (thenTypeArgs.length != otherwiseTypeArgs.length) return [thenStr, otherwiseStr];

    // 检查是否有不一致的 AnyGC* vs 具体类型
    bool hasAnyGCMismatch = false;
    for (var i = 0; i < thenTypeArgs.length; i++) {
      final a = thenTypeArgs[i].trim();
      final b = otherwiseTypeArgs[i].trim();
      if (a != b && (a == 'AnyGC*' || b == 'AnyGC*')) {
        hasAnyGCMismatch = true;
      }
    }
    if (!hasAnyGCMismatch) return [thenStr, otherwiseStr];

    // 构建统一的 AnyGC* 类型（用于 reinterpret_cast 目标）
    final unifiedArgs = <String>[];
    for (var i = 0; i < thenTypeArgs.length; i++) {
      final a = thenTypeArgs[i].trim();
      final b = otherwiseTypeArgs[i].trim();
      if (a == b) {
        unifiedArgs.add(a);
      } else if (a == 'AnyGC*' || b == 'AnyGC*') {
        unifiedArgs.add('AnyGC*');
      } else {
        unifiedArgs.add(a);
      }
    }
    final targetType = '$thenValueType<${unifiedArgs.join(', ')}>*';

    // 保持原始模板参数不变（值参数匹配），用 reinterpret_cast 转换指针类型
    var newThen = thenStr;
    var newOtherwise = otherwiseStr;
    final thenArgsStr = thenTypeArgs.map((s) => s.trim()).join(', ');
    final otherwiseArgsStr = otherwiseTypeArgs.map((s) => s.trim()).join(', ');
    if (thenArgsStr != unifiedArgs.join(', ')) {
      newThen = 'reinterpret_cast<$targetType>($thenStr)';
    }
    if (otherwiseArgsStr != unifiedArgs.join(', ')) {
      newOtherwise = 'reinterpret_cast<$targetType>($otherwiseStr)';
    }
    return [newThen, newOtherwise];
  }

  /// 拆分模板参数（处理嵌套的 <> 如 `StaticMap<String, int>`)
  List<String> _splitTemplateArgs(String args) {
    final result = <String>[];
    var depth = 0;
    var start = 0;
    for (var i = 0; i < args.length; i++) {
      if (args[i] == '<') depth++;
      else if (args[i] == '>') depth--;
      else if (args[i] == ',' && depth == 0) {
        result.add(args.substring(start, i));
        start = i + 1;
      }
    }
    result.add(args.substring(start));
    return result;
  }

  /// 拆分函数参数（处理嵌套的 ()、{}、[]、<> 如 `func(a, b)` 或 `static_cast<Type<A, B>>`）
  List<String> _splitTopLevel(String args) {
    final result = <String>[];
    var depth = 0;
    var angleDepth = 0;
    var start = 0;
    for (var i = 0; i < args.length; i++) {
      final c = args[i];
      if (c == '(' || c == '{' || c == '[') depth++;
      else if (c == ')' || c == '}' || c == ']') depth--;
      else if (c == '<') angleDepth++;
      else if (c == '>' && i > 0 && args[i - 1] != '-') { if (angleDepth > 0) angleDepth--; }
      else if (c == ',' && depth == 0 && angleDepth == 0) {
        result.add(args.substring(start, i));
        start = i + 1;
      }
    }
    result.add(args.substring(start));
    return result;
  }

  /// 检查表达式是否为 void（如 setter 调用）
  bool _isVoidExpression(String expr) {
    // vptr setter 调用返回 void
    if (expr.startsWith('static_cast<') && expr.contains('->set_')) return true;
    // 直接字段赋值返回 void（在某些情况下）
    if (expr.contains(' = ') && !expr.startsWith('(')) return true;
    return false;
  }

  /// 如果一个分支是 AnyGC* 而另一个是裸原始值，包装原始值以避免转换歧义
  String _wrapForAnyPtrContext(String thisValue, String otherValue, Expression thisExpr, Expression otherExpr) {
    // 如果对方是 AnyGC* 相关值，而本值是裸数字/字面量
    final otherIsAnyGCVal = otherValue.startsWith('AnyGC*') ||
        otherValue == 'nullptr' ||
        otherValue.contains('_box(');
    // 也检查对方表达式的类型
    final otherExprType = _getExpressionType(otherExpr);
    final otherTypeIsAnyGCVal = otherExprType != null && _cppType(otherExprType) == 'AnyGC*';
    if (!otherIsAnyGCVal && !otherTypeIsAnyGCVal) return thisValue;
    // 如果本值已经是 AnyGC* 包装
    if (thisValue.startsWith('AnyGC*') || thisValue.contains('_box(')) return thisValue;
    // 检查本表达式类型是否已经是 AnyPtr
    final thisExprType = _getExpressionType(thisExpr);
    if (thisExprType != null && _cppType(thisExprType) == 'AnyGC*') return thisValue;
    // 裸整数
    if (RegExp(r'^-?\d+$').hasMatch(thisValue)) {
      return '_box($thisValue)';
    }
    // 裸浮点数
    if (RegExp(r'^-?\d+\.\d+$').hasMatch(thisValue)) {
      return '_box($thisValue)';
    }
    if (thisValue == 'true' || thisValue == 'false') {
      return '_box($thisValue)';
    }
    return thisValue;
  }

  /// 如果 value 是 nullptr，根据 targetType 转换为对应的默认值
  String _convertNullToType(String value, String targetType) {
    if (value != 'nullptr') {
      return value;
    }

    // 指针类型优先检查（避免与模板参数中的类型名冲突）
    if (targetType.endsWith('*') && !targetType.contains('AnyGC*')) {
      return 'nullptr';
    } else if (targetType == 'int64_t' || targetType == 'int') {
      return '0';
    } else if (targetType == 'double') {
      return '0.0';
    } else if (targetType == 'bool') {
      return 'false';
    } else if (targetType == 'DartString') {
      return '""';
    } else if (_isCppTypeParameter(targetType) || _containsTypeParameter(targetType)) {
      // 模板类型参数（如 L, R, T）：使用默认构造值
      // 当 L=DartString 时 L{} = ""，当 L=AnyGC* 时 L{} = nullptr
      return '$targetType{}';
    } else {
      return value;
    }
  }

  String _emitCppLogical(LogicalExpression expr) {
    final left = _emitCppExpr(expr.left);
    final right = _emitCppExpr(expr.right);
    final op = expr.operatorEnum == LogicalExpressionOperator.AND ? '&&' : '||';
    return '($left $op $right)';
  }

  String _emitCppListLiteral(ListLiteral expr) {
    String innerType = 'AnyGC*';
    bool isDynamicList = true; // true = Dart type is dynamic/unknown
    final listType = _getExpressionType(expr);
    if (listType is InterfaceType && listType.typeArguments.isNotEmpty) {
      final typeArg = listType.typeArguments[0];
      isDynamicList = typeArg is DynamicType;
      innerType = _cppType(typeArg);
    }
    // 仅当列表 Dart 类型是 dynamic（innerType 为 AnyGC*）时，
    // 才使用外层期望的元素类型来推断具体类型。
    // 对于已有具体类型参数的列表，保持其类型不变。
    if (isDynamicList && innerType == 'AnyGC*' && _expectedCollectionElementType != null) {
      innerType = _expectedCollectionElementType!;
    }
    // 如果 innerType 是未在作用域内的类型参数（如 T），使用 AnyGC*
    if (_isCppTypeParameter(innerType) && !_inScopeTypeParams.contains(innerType)) {
      innerType = 'AnyGC*';
    }

    // If element type is a map, set expected map key/value types for inner map literals
    String? savedMapKeyType, savedMapValueType;
    if (listType is InterfaceType && listType.typeArguments.isNotEmpty) {
      final elemDartType = listType.typeArguments[0];
      if (elemDartType is InterfaceType &&
          (elemDartType.classNode.name == 'Map' || elemDartType.classNode.name == 'StaticMap') &&
          elemDartType.typeArguments.length >= 2) {
        savedMapKeyType = _expectedMapKeyType;
        savedMapValueType = _expectedMapValueType;
        _expectedMapKeyType = _cppType(elemDartType.typeArguments[0]);
        _expectedMapValueType = _cppType(elemDartType.typeArguments[1]);
      }
    }

    if (expr.expressions.isEmpty) {
      // Restore expected map types
      if (savedMapKeyType != null || savedMapValueType != null) {
        _expectedMapKeyType = savedMapKeyType;
        _expectedMapValueType = savedMapValueType;
      }
      return 'GC::allocateLocal(new StaticList<$innerType>())';
    }
    // 先发出元素（暂不装箱），然后根据修正后的 innerType 决定是否需要装箱
    final rawElements = expr.expressions.toList();
    final emittedElements = rawElements.map((e) => _emitCppExpr(e)).toList();

    // Restore expected map types
    if (savedMapKeyType != null || savedMapValueType != null) {
      _expectedMapKeyType = savedMapKeyType;
      _expectedMapValueType = savedMapValueType;
    }

    // 使用共享的修正函数检测元素类型不匹配
    innerType = _correctListInnerType(innerType, emittedElements);

    // 如果最终 innerType 是 AnyGC*，对基本类型元素装箱
    final finalElements = <String>[];
    for (var i = 0; i < emittedElements.length; i++) {
      var elemStr = emittedElements[i];
      if (innerType == 'AnyGC*') {
        elemStr = _cppMaybeBoxForAnyGC(elemStr, rawElements[i]);
      }
      finalElements.add(elemStr);
    }
    final elements = finalElements.join(', ');

    return 'GC::allocateLocal(new StaticList<$innerType>({$elements}))';
  }

  /// 根据已发出的元素字符串修正列表的内部类型。
  /// 如果 innerType 不是 AnyGC* 但元素含有 AnyGC* 值、异构基本类型、
  /// 或 innerType 是函数指针类型但元素不是函数，则改为 AnyGC*。
  String _correctListInnerType(String innerType, List<String> emittedElements) {
    if (innerType == 'AnyGC*') return innerType;
    // 仅检测真正产生 AnyGC* 的模式，不包括 GC::allocateLocal（所有 GC 对象都用它）
    final hasAnyGCElements = emittedElements.any((emitted) =>
      emitted.contains('TupleBox') || emitted.contains('_box(') ||
      emitted.startsWith('[&]') || emitted.contains('-> AnyGC*')
    );
    bool hasHeterogeneousElements = false;
    if (emittedElements.length > 1) {
      final typeCategories = <String>{};
      for (final e in emittedElements) {
        if (RegExp(r'^-?\d+LL$').hasMatch(e)) {
          typeCategories.add('int');
        } else if (RegExp(r'^-?\d+\.\d+$').hasMatch(e)) {
          typeCategories.add('double');
        } else if (e == 'true' || e == 'false') {
          typeCategories.add('bool');
        } else if (e.startsWith('DartString(') || e.startsWith('"')) {
          typeCategories.add('string');
        } else if (e.contains('TupleBox') || e.contains('_box(') ||
                   e.startsWith('[&]') || e.contains('-> AnyGC*')) {
          typeCategories.add('anycg');
        } else {
          // 对象/指针等 — 不参与异构检测
        }
      }
      // 仅在有 2 个或以上基本类型类别时才视为异构
      hasHeterogeneousElements = typeCategories.length > 1;
    }
    final isFunctionPtrType = innerType.contains('TypeFunction');
    if (hasAnyGCElements || hasHeterogeneousElements || isFunctionPtrType) {
      return 'AnyGC*';
    }
    return innerType;
  }

  String _emitCppMapLiteral(MapLiteral expr) {
    // 从 MapLiteral 的类型推断键值类型
    String keyType = 'AnyGC*';
    String valType = 'AnyGC*';
    bool hasExplicitType = false;
    final mapType = _getExpressionType(expr);
    if (mapType is InterfaceType && mapType.typeArguments.length >= 2) {
      keyType = _cppType(mapType.typeArguments[0]);
      valType = _cppType(mapType.typeArguments[1]);
      hasExplicitType = true;
    }
    // Only use expected types if the map literal has NO explicit type information
    if (!hasExplicitType) {
      if (keyType == 'AnyGC*' && _expectedMapKeyType != null) {
        keyType = _expectedMapKeyType!;
      }
      if (valType == 'AnyGC*' && _expectedMapValueType != null) {
        valType = _expectedMapValueType!;
      }
    }
    // 后备：从实际的 key 表达式推断类型（keys 通常是同质的）
    if (keyType == 'AnyGC*' && expr.entries.isNotEmpty) {
      final firstKeyType = _getExpressionType(expr.entries.first.key);
      if (firstKeyType is InterfaceType) {
        final name = firstKeyType.classNode.name;
        if (name == 'String') keyType = 'DartString';
        else if (name == 'int') keyType = 'int64_t';
        else if (name == 'double') keyType = 'double';
        else if (name == 'bool') keyType = 'bool';
      } else {
        // 后备：检查 C++ 表达式模式
        final firstKeyExpr = _emitCppExpr(expr.entries.first.key);
        if (firstKeyExpr.startsWith('DartString(') || firstKeyExpr.startsWith('"')) {
          keyType = 'DartString';
        } else if (RegExp(r'^-?\d+$').hasMatch(firstKeyExpr)) {
          keyType = 'int64_t';
        }
      }
    }
    // 对于 value，只有当所有 values 类型相同时才推断，否则保持 AnyGC*
    if (valType == 'AnyGC*' && expr.entries.isNotEmpty) {
      final firstValType = _getExpressionType(expr.entries.first.value);
      if (firstValType is InterfaceType) {
        final firstName = firstValType.classNode.name;
        // 检查所有 values 是否都是同一类型
        final allSame = expr.entries.every((e) {
          final t = _getExpressionType(e.value);
          return t is InterfaceType && t.classNode.name == firstName;
        });
        if (allSame) {
          if (firstName == 'String') valType = 'DartString';
          else if (firstName == 'int') valType = 'int64_t';
          else if (firstName == 'double') valType = 'double';
          else if (firstName == 'bool') valType = 'bool';
        }
      }
    }
    if (expr.entries.isEmpty) {
      return 'StaticMap<$keyType, $valType>::empty()';
    }
    // 非空 map 字面量：创建空 map 然后逐个添加
    final entries = expr.entries.map((e) {
      var k = _emitCppExpr(e.key);
      var v = _emitCppExpr(e.value);
      // 如果 key/value 类型不匹配，需要 boxing
      k = _boxForMapComponent(k, e.key, keyType);
      v = _boxForMapComponent(v, e.value, valType);
      return '_m->set($k, $v)';
    }).join('; ');
    return '([&]() { auto* _m = StaticMap<$keyType, $valType>::empty(); $entries; return _m; })()';
  }

  /// 为 Map 的 key 或 value 进行 boxing（当期望 AnyGC* 但实际是基本类型时）
  String _boxForMapComponent(String expr, Expression origExpr, String expectedType) {
    if (expectedType != 'AnyGC*') return expr;
    // 检查是否是比较运算表达式（>=, <=, >, <, ==, !=）— 这些产生 bool
    if (origExpr is InstanceInvocation) {
      final opName = origExpr.interfaceTarget.name.text;
      if (opName == '>=' || opName == '<=' || opName == '>' || opName == '<' ||
          opName == '==' || opName == '!=') {
        return 'GC::allocateLocal(new BoolBox($expr))';
      }
    }
    // 检查表达式的实际类型
    final actualType = _getExpressionType(origExpr);
    if (actualType is InterfaceType) {
      final name = actualType.classNode.name;
      if (name == 'String') {
        return 'GC::allocateLocal(new StringBox($expr))';
      }
      if (name == 'int') {
        return 'GC::allocateLocal(new IntBox($expr))';
      }
      if (name == 'double') {
        return 'GC::allocateLocal(new DoubleBox($expr))';
      }
      if (name == 'bool') {
        return 'GC::allocateLocal(new BoolBox($expr))';
      }
    }
    // 检查 C++ 表达式模式
    if (expr.startsWith('DartString(') || expr.startsWith('"') || expr.startsWith('dart_str(')) {
      return 'GC::allocateLocal(new StringBox($expr))';
    }
    if (expr.startsWith('GC::allocateLocal(new IntBox(') ||
        expr.startsWith('GC::allocateLocal(new StringBox(') ||
        expr.startsWith('GC::allocateLocal(new DoubleBox(') ||
        expr.startsWith('GC::allocateLocal(new BoolBox(')) {
      return expr; // already boxed
    }
    if (expr.startsWith('dynAs<int64_t>(') || RegExp(r'^-?\d+$').hasMatch(expr) || RegExp(r'^-?\d+LL$').hasMatch(expr)) {
      return 'GC::allocateLocal(new IntBox($expr))';
    }
    if (expr.startsWith('dynAs<double>(') || RegExp(r'^-?\d+\.\d+$').hasMatch(expr)) {
      return 'GC::allocateLocal(new DoubleBox($expr))';
    }
    if (expr.startsWith('dynAs<bool>(') || expr == 'true' || expr == 'false') {
      return 'GC::allocateLocal(new BoolBox($expr))';
    }
    return expr;
  }

  String _emitCppSetLiteral(SetLiteral expr) {
    String innerType = 'AnyGC*';
    final setType = _getExpressionType(expr);
    if (setType is InterfaceType && setType.typeArguments.isNotEmpty) {
      innerType = _cppType(setType.typeArguments[0]);
    }
    if (expr.expressions.isEmpty) {
      return 'GC::allocateLocal(new StaticSet<$innerType>())';
    }
    final rawElems = expr.expressions.toList();
    final emittedElems = rawElems.map((e) => _emitCppExpr(e)).toList();
    final correctedInnerType = _correctListInnerType(innerType, emittedElems);
    final elements = emittedElems.asMap().entries.map((entry) {
      var s = entry.value;
      if (correctedInnerType == 'AnyGC*') {
        s = _cppMaybeBoxForAnyGC(s, rawElems[entry.key]);
      }
      return s;
    }).join(', ');
    return 'GC::allocateLocal(new StaticSet<$correctedInnerType>({$elements}))';
  }

  String _emitCppAsExpression(AsExpression expr) {
    final operand = _emitCppExpr(expr.operand);
    final targetType = _cppType(expr.type);
    if (targetType == 'AnyGC*') return operand;

    // Check if operand is already the target type
    final operandType = _getExpressionType(expr.operand);
    final operandCppType = operandType != null ? _cppType(operandType) : '';
    if (operandCppType == targetType) return operand;

    if (targetType.endsWith('*')) {
      final baseType = targetType.substring(0, targetType.length - 1);
      if (_isCppTypeParameter(baseType)) {
        return 'static_cast<AnyGC*>($operand)';
      }
      return 'static_cast<$baseType*>($operand)';
    }
    // 检查操作数是否为 AnyGC* 或 AnyGC*

    // Raw-returning ClassInfo dispatch (e.g., contains→bool, get_length→int64_t):
    // no dynAs needed — the field returns the raw type directly
    if (_isRawReturnClassInfoDispatch(operand)) {
      return operand;
    }

    // AnyGC* → 基本类型：使用 dynAs
    if (operandCppType == 'AnyGC*') {
      if (targetType == 'int64_t') return 'dynAs<int64_t>($operand)';
      if (targetType == 'double') return 'dynAs<double>($operand)';
      if (targetType == 'bool') return 'dynAs<bool>($operand)';
      if (targetType == 'DartString') return 'dynAs<DartString>($operand)';
      return 'static_cast<$targetType>($operand)';
    }

    // AnyGC* → 具体类型
    final isAnyGCVal = operandCppType == 'AnyGC*' ||
                     operandCppType.isEmpty ||
                     operand.startsWith('(*') ||
                     operand.startsWith('AnyGC*') ||
                     operand.endsWith('->result') ||
                     operand.endsWith('->error');
    if (isAnyGCVal) {
      if (targetType == 'int64_t') return 'dynAs<int64_t>($operand)';
      if (targetType == 'double') return 'dynAs<double>($operand)';
      if (targetType == 'bool') return 'dynAs<bool>($operand)';
      if (targetType == 'DartString') return 'dynAs<DartString>($operand)';
      return 'dynAs<$targetType>($operand)';
    }

    // 后备：表达式实际产生 AnyGC* 但类型系统未识别（如 promise_typedResult()）
    if (operand.contains('promise_typedResult(') || _isAnyGCPtrExpr(operand)) {
      if (targetType == 'int64_t') return 'dynAs<int64_t>($operand)';
      if (targetType == 'double') return 'dynAs<double>($operand)';
      if (targetType == 'bool') return 'dynAs<bool>($operand)';
      if (targetType == 'DartString') return 'dynAs<DartString>($operand)';
      if (targetType.endsWith('*')) {
        final baseType = targetType.substring(0, targetType.length - 1);
        return 'static_cast<$baseType*>($operand)';
      }
    }

    return 'static_cast<$targetType>($operand)';
  }

  String _emitCppIsExpression(IsExpression expr) {
    final operand = _emitCppExpr(expr.operand);
    final targetType = _cppType(expr.type);
    if (targetType.endsWith('Value*')) {
      final baseType = targetType.substring(0, targetType.length - 1);
      return 'dart_is<$baseType>($operand)';
    }
    String gcOperand = operand;
    if (_isAnyPtrResult(operand) || _getExpressionType(expr.operand) == null) {
      gcOperand = '$operand';
    }
    if (expr.type is InterfaceType) {
      final typeName = (expr.type as InterfaceType).classNode.name;
      switch (typeName) {
        case 'int': return 'dart_is<IntBox>($gcOperand)';
        case 'double': return 'dart_is<DoubleBox>($gcOperand)';
        case 'bool': return 'dart_is<BoolBox>($gcOperand)';
        case 'String': return 'dart_is<StringBox>($gcOperand)';
        case 'List':
          if (targetType == 'StaticList<AnyGC*>*') {
            return '($gcOperand && static_cast<AnyGC*>($gcOperand)->_classInfo->typeName == "List")';
          }
          final baseType = targetType.substring(0, targetType.length - 1);
          return 'dart_is<$baseType>($gcOperand)';
        case 'Map':
          if (targetType == 'StaticMap<AnyGC*, AnyGC*>*') {
            return '($gcOperand && static_cast<AnyGC*>($gcOperand)->_classInfo->typeName == "Map")';
          }
          final baseType = targetType.substring(0, targetType.length - 1);
          return 'dart_is<$baseType>($gcOperand)';
      }
    }
    return 'false /* is ${expr.type} */';
  }

  /// 判断类型是否需要装箱（基础值类型被闭包捕获时需要装箱以保持引用语义）
  bool _cppNeedsBoxing(DartType type) {
    return _cppBoxTypeName(type) != null;
  }

  /// 返回基础类型对应的 Box 类型名，非基础类型返回 null
  String? _cppBoxTypeName(DartType type) {
    if (type is InterfaceType) {
      final name = type.classNode.name;
      if (name == 'int') return 'IntBox';
      if (name == 'double') return 'DoubleBox';
      if (name == 'bool') return 'BoolBox';
      if (name == 'String') return 'StringBox';
    }
    if (type is TypeParameterType) return 'ValueBox<${type.parameter.name ?? 'T'}>';
    return null;
  }

  /// 预分析函数体，识别被内层闭包捕获的可变基础类型变量，标记为需要 Box 化
  void _preanalyzeCppBoxedVars(FunctionNode func) {
    if (func.body == null) return;
    // 收集本层作用域的局部变量（不含参数 — 参数按值捕获即可）
    final localOfThisLevel = <VariableDeclaration>{};
    _collectShallowCppDecls(func.body!, localOfThisLevel);

    // 收集所有嵌套闭包
    final innerClosures = <FunctionExpression>[];
    _collectAllCppFunctionExpressions(func.body!, innerClosures);

    for (final fe in innerClosures) {
      final captured = <VariableDeclaration>[];
      _collectCapturedVars(fe.function.body ?? EmptyStatement(), captured);
      for (final v in captured) {
        if (!localOfThisLevel.contains(v)) continue;
        final parent = v.parent;
        if (parent is ForStatement && parent.variables.contains(v)) continue;
        if (!_cppNeedsBoxing(v.type)) continue;
        _boxedVars.add(v);
      }
    }
  }

  /// 浅层收集变量声明（不穿透进 FunctionExpression）
  void _collectShallowCppDecls(TreeNode node, Set<VariableDeclaration> out) {
    if (node is VariableDeclaration) {
      out.add(node);
    } else if (node is FunctionExpression) {
      // 不穿透进闭包
    } else if (node is Let) {
      out.add(node.variable);
      _collectShallowCppDecls(node.body, out);
      if (node.variable.initializer != null) {
        _collectShallowCppDecls(node.variable.initializer!, out);
      }
    } else if (node is Block) {
      for (final s in node.statements) {
        _collectShallowCppDecls(s, out);
      }
    } else if (node is ExpressionStatement) {
      _collectShallowCppDecls(node.expression, out);
    } else if (node is IfStatement) {
      _collectShallowCppDecls(node.then, out);
      if (node.otherwise != null) _collectShallowCppDecls(node.otherwise!, out);
    } else if (node is ForStatement) {
      for (final v in node.variables) {
        out.add(v);
      }
      _collectShallowCppDecls(node.body, out);
    } else if (node is WhileStatement) {
      _collectShallowCppDecls(node.body, out);
    } else if (node is ReturnStatement) {
      if (node.expression != null) _collectShallowCppDecls(node.expression!, out);
    }
  }

  /// 收集所有嵌套的 FunctionExpression（任意深度）
  void _collectAllCppFunctionExpressions(TreeNode node, List<FunctionExpression> out) {
    if (node is FunctionExpression) {
      out.add(node);
      // 穿透进闭包体以发现更深层的闭包
      _collectAllCppFunctionExpressions(node.function.body ?? EmptyStatement(), out);
    } else if (node is Let) {
      if (node.variable.initializer != null) _collectAllCppFunctionExpressions(node.variable.initializer!, out);
      _collectAllCppFunctionExpressions(node.body, out);
    } else if (node is Block) {
      for (final s in node.statements) {
        _collectAllCppFunctionExpressions(s, out);
      }
    } else if (node is ExpressionStatement) {
      _collectAllCppFunctionExpressions(node.expression, out);
    } else if (node is IfStatement) {
      _collectAllCppFunctionExpressions(node.then, out);
      if (node.otherwise != null) _collectAllCppFunctionExpressions(node.otherwise!, out);
    } else if (node is ForStatement) {
      _collectAllCppFunctionExpressions(node.body, out);
    } else if (node is WhileStatement) {
      _collectAllCppFunctionExpressions(node.body, out);
    } else if (node is ReturnStatement) {
      if (node.expression != null) _collectAllCppFunctionExpressions(node.expression!, out);
    } else if (node is VariableDeclaration) {
      if (node.initializer != null) _collectAllCppFunctionExpressions(node.initializer!, out);
    } else if (node is TryCatch) {
      _collectAllCppFunctionExpressions(node.body, out);
      for (final catch_ in node.catches) {
        _collectAllCppFunctionExpressions(catch_.body, out);
      }
    } else if (node is TryFinally) {
      _collectAllCppFunctionExpressions(node.body, out);
      _collectAllCppFunctionExpressions(node.finalizer, out);
    } else if (node is InstanceInvocation) {
      // F7 修复：闭包常作为调用实参传递（如 map.forEach((k,v){...})），
      // 必须穿透进 receiver 与实参，否则预分析漏掉闭包 → 可变捕获变量
      // 不会在声明处装箱 → 闭包内修改无法传播到外层
      _collectAllCppFunctionExpressions(node.receiver, out);
      _collectAllCppFunctionExpressionsFromArgs(node.arguments, out);
    } else if (node is StaticInvocation) {
      _collectAllCppFunctionExpressionsFromArgs(node.arguments, out);
    } else if (node is FunctionInvocation) {
      _collectAllCppFunctionExpressions(node.receiver, out);
      _collectAllCppFunctionExpressionsFromArgs(node.arguments, out);
    } else if (node is ConstructorInvocation) {
      _collectAllCppFunctionExpressionsFromArgs(node.arguments, out);
    } else if (node is SuperMethodInvocation) {
      _collectAllCppFunctionExpressionsFromArgs(node.arguments, out);
    } else if (node is LocalFunctionInvocation) {
      _collectAllCppFunctionExpressionsFromArgs(node.arguments, out);
    } else if (node is ConditionalExpression) {
      _collectAllCppFunctionExpressions(node.condition, out);
      _collectAllCppFunctionExpressions(node.then, out);
      _collectAllCppFunctionExpressions(node.otherwise, out);
    } else if (node is LogicalExpression) {
      _collectAllCppFunctionExpressions(node.left, out);
      _collectAllCppFunctionExpressions(node.right, out);
    } else if (node is EqualsCall) {
      _collectAllCppFunctionExpressions(node.left, out);
      _collectAllCppFunctionExpressions(node.right, out);
    } else if (node is Not) {
      _collectAllCppFunctionExpressions(node.operand, out);
    } else if (node is StringConcatenation) {
      for (final e in node.expressions) {
        _collectAllCppFunctionExpressions(e, out);
      }
    } else if (node is ListLiteral) {
      for (final e in node.expressions) {
        _collectAllCppFunctionExpressions(e, out);
      }
    } else if (node is SetLiteral) {
      for (final e in node.expressions) {
        _collectAllCppFunctionExpressions(e, out);
      }
    } else if (node is MapLiteral) {
      for (final entry in node.entries) {
        _collectAllCppFunctionExpressions(entry.key, out);
        _collectAllCppFunctionExpressions(entry.value, out);
      }
    } else if (node is AwaitExpression) {
      _collectAllCppFunctionExpressions(node.operand, out);
    } else if (node is Throw) {
      _collectAllCppFunctionExpressions(node.expression, out);
    } else if (node is AsExpression) {
      _collectAllCppFunctionExpressions(node.operand, out);
    } else if (node is IsExpression) {
      _collectAllCppFunctionExpressions(node.operand, out);
    } else if (node is InstanceGet) {
      _collectAllCppFunctionExpressions(node.receiver, out);
    } else if (node is InstanceSet) {
      _collectAllCppFunctionExpressions(node.receiver, out);
      _collectAllCppFunctionExpressions(node.value, out);
    }
  }

  /// 穿透调用实参（位置 + 命名）收集 FunctionExpression
  void _collectAllCppFunctionExpressionsFromArgs(
      Arguments args, List<FunctionExpression> out) {
    for (final arg in args.positional) {
      _collectAllCppFunctionExpressions(arg, out);
    }
    for (final named in args.named) {
      _collectAllCppFunctionExpressions(named.value, out);
    }
  }

  String _emitCppFunctionExpression(FunctionExpression expr) {
    final func = expr.function;
    final closureId = _closureCounter++;
    final closureName = 'ClosureEnv_$closureId';

    // 预分析闭包体内的 Box 化变量（闭包体内声明的变量被更深层闭包捕获时需要装箱）
    _preanalyzeCppBoxedVars(func);

    // 收集函数内部声明的局部变量（不包括函数参数）
    final localVars = <VariableDeclaration>{};
    _collectLocalVars(func.body ?? EmptyStatement(), localVars);

    // 收集当前函数的参数
    final funcParams = <VariableDeclaration>{};
    funcParams.addAll(func.positionalParameters);
    funcParams.addAll(func.namedParameters);

    // 收集捕获的变量（排除局部变量和当前函数参数）
    final capturedVars = <VariableDeclaration>[];
    _collectCapturedVars(func.body ?? EmptyStatement(), capturedVars);

    // 过滤掉局部变量和当前函数参数，只保留真正需要捕获的外部变量
    // 同时过滤掉无名称的编译器中间变量
    // 以及编译器生成的 _letN 变量（这些是跨函数的中间变量，不应被捕获）
    capturedVars.removeWhere((v) => localVars.contains(v) ||
        funcParams.contains(v) ||
        v.name == null ||
        v.name!.isEmpty ||
        RegExp(r'^_let\d+$').hasMatch(v.name!));

    // 计算需要在 env 中装箱的值类型捕获变量
    // _envBoxedVars: 当前闭包新装箱的（不在 _boxedVars 也不在 _scopeBoxedVars 中）
    // _scopeBoxedVars: 累积所有作用域中已装箱的变量（用于 ->value 访问）
    final savedEnvBoxedVars = Set<VariableDeclaration>.from(_envBoxedVars);
    final savedScopeBoxedVars = Set<VariableDeclaration>.from(_scopeBoxedVars);
    _envBoxedVars.clear();
    for (final v in capturedVars) {
      if (_cppNeedsBoxing(v.type) && !_boxedVars.contains(v) && !_scopeBoxedVars.contains(v)) {
        _envBoxedVars.add(v);
        _scopeBoxedVars.add(v);
      }
    }

    // 检查是否需要模板参数
    final typeParams = <String>[];

    // 检查闭包体是否使用了 ThisExpression（即捕获了 this）
    final capturesThis = _bodyUsesThis(func.body);

    // 如果捕获了 this，获取当前类的指针类型
    String? thisType;
    if (capturesThis && _currentClassName.isNotEmpty) {
      final cls = _classNodes[_currentClassName];
      if (cls != null && cls.typeParameters.isNotEmpty) {
        final targs = cls.typeParameters.map((tp) => tp.name ?? 'T').join(', ');
        thisType = '${_currentClassName}Value<$targs>*';
        // 收集类模板参数
        for (final tp in cls.typeParameters) {
          final tpName = tp.name ?? 'T';
          if (!typeParams.contains(tpName)) {
            typeParams.add(tpName);
          }
        }
      } else {
        thisType = '${_currentClassName}Value*';
      }
    }

    // 检查是否需要模板参数
    for (final v in capturedVars) {
      _collectTypeParameters(v.type, typeParams);
    }

    // 也从闭包自身的返回类型和参数类型中收集模板参数
    _collectTypeParameters(func.returnType, typeParams);
    for (final p in func.positionalParameters) {
      _collectTypeParameters(p.type, typeParams);
    }
    for (final p in func.namedParameters) {
      _collectTypeParameters(p.type, typeParams);
    }

    // 确定 TypeFunction 基类类型
    String returnType;
    if (func.returnType is NeverType ||
        func.returnType is DynamicType ||
        func.returnType is NullType) {
      // 推断返回类型：先从调用上下文推断，再从闭包体推断
      final inferred = _inferNeverReturnType(expr);
      if (inferred != null) {
        returnType = inferred;
      } else {
        returnType = _inferReturnTypeFromBody(func) ?? _cppType(func.returnType);
      }
    } else {
      returnType = _cppType(func.returnType);
    }
    final paramTypes = func.positionalParameters.map((p) => _cppType(p.type)).toList();

    String typeFunctionBase;
    if (paramTypes.isEmpty) {
      typeFunctionBase = 'TypeFunction0<$returnType>';
    } else {
      final paramTypesStr = paramTypes.join(', ');
      typeFunctionBase = 'TypeFunction${paramTypes.length}<$returnType, $paramTypesStr>';
    }

    // 生成闭包结构体（带模板参数如果需要）
    final templatePrefix = typeParams.isNotEmpty
        ? 'template<${typeParams.map((tp) => 'typename $tp').join(', ')}>'
        : '';
    final templateArgs = typeParams.isNotEmpty
        ? '<${typeParams.join(', ')}>'
        : '';

    // call 方法 - 设置当前返回类型
    final paramNames = <String>[];
    final paramDecls = paramTypes.isNotEmpty
        ? func.positionalParameters.asMap().entries.map((e) {
            final paramName = _cleanName(e.value.name ?? 'p${e.key}');
            paramNames.add(paramName);
            return '${paramTypes[e.key]} $paramName';
          }).join(', ')
        : '';

    // 保存并设置当前返回类型
    final savedReturnType = _currentReturnType;
    // 闭包 trampoline 返回 AnyGC*（boxed），但 body 内的 return 语句需要返回原始类型 R
    // 设置 _currentReturnType=returnType 让 return 语句正确处理（lambda 内返回 R，外部 _box）
    _currentReturnType = returnType;
    final savedInClosureTrampoline = _inClosureTrampoline;
    _inClosureTrampoline = true;
    final savedInScopeTypeParams = _inScopeTypeParams;
    // 闭包不是模板函数，但继承外部作用域的模板参数
    // _inScopeTypeParams 保持不变

    // 保存并清除 async 标志（闭包本身不是 async 函数）
    final savedIsAsync = _isAsyncFunction;
    _isAsyncFunction = false;

    // 保存并设置闭包参数名称（用于解决 # 后缀变量名问题）
    final savedParamNames = Set<String>.from(_currentClosureParamNames);
    _currentClosureParamNames
      ..clear()
      ..addAll(paramNames);

    // 保存并清除外部作用域的变量名映射（闭包有自己的作用域）
    // 外部 Let 表达式的变量重命名不应泄漏到闭包体中
    final savedVarNameMappings = Map<String, String>.from(_variableNameMappings);
    final savedDeclaredVariables = Set<String>.from(_declaredVariables);
    _variableNameMappings.clear();
    _declaredVariables.clear();

    // 先生成函数体（以发现嵌套闭包，它们的 struct 需要先定义）
    // 嵌套闭包的 struct 定义写到独立的缓冲区
    final savedStructBuf = _structBuf;
    final nestedClosureBuf = StringBuffer();
    _structBuf = nestedClosureBuf;

    final bodyBuf = StringBuffer();
    if (func.body != null) {
      _emitCppStmtToBuffer(func.body!, bodyBuf);
      // 被擦除返回类型（Never/Dynamic/Null）被推断为具体类型时，添加兜底 return
      if ((func.returnType is NeverType ||
           func.returnType is DynamicType ||
           func.returnType is NullType) && returnType != 'void') {
        bodyBuf.writeln('        return ${_cppDefaultValue(returnType)}; /* unreachable */');
      }
    } else {
      if (returnType != 'void') {
        bodyBuf.writeln('        return ${_cppDefaultValue(returnType)};');
      }
    }

    // 恢复 _structBuf
    _structBuf = savedStructBuf;

    // 恢复返回类型和 async 标志
    _currentReturnType = savedReturnType;
    _inClosureTrampoline = savedInClosureTrampoline;
    _isAsyncFunction = savedIsAsync;
    _inScopeTypeParams = savedInScopeTypeParams;
    // 恢复闭包参数名称
    _currentClosureParamNames
      ..clear()
      ..addAll(savedParamNames);
    // 恢复外部作用域的变量名映射
    _variableNameMappings
      ..clear()
      ..addAll(savedVarNameMappings);
    _declaredVariables
      ..clear()
      ..addAll(savedDeclaredVariables);

    // 先输出嵌套闭包的 struct 定义（在被当前闭包引用之前）
    if (nestedClosureBuf.isNotEmpty) {
      _structBuf.write(nestedClosureBuf);
    }

    // 现在输出当前闭包的 struct 定义
    // ClassInfo subclass declaration (constructor body defined after struct)
    if (templatePrefix.isNotEmpty) {
      _structBuf.writeln('$templatePrefix');
    }
    _structBuf.writeln('struct ${closureName}ClassInfo : ClassInfo { ${closureName}ClassInfo(); };');
    if (templatePrefix.isNotEmpty) {
      _structBuf.writeln('$templatePrefix');
    }
    _structBuf.writeln('struct $closureName : $typeFunctionBase {');

    // 字段：先放 this_（如果捕获了 this），再放其他捕获变量
    if (capturesThis && thisType != null) {
      _structBuf.writeln('    $thisType this_;');
    }
    for (final v in capturedVars) {
      final varName = _cleanName(v.name ?? 'v');
      if (_boxedVars.contains(v) || _scopeBoxedVars.contains(v)) {
        // Box 化变量：存储 box 指针（共享引用）
        final boxType = _cppBoxTypeName(v.type)!;
        _structBuf.writeln('    $boxType* $varName;');
      } else {
        final varType = _cppType(v.type);
        _structBuf.writeln('    $varType $varName;');
      }
    }
    _structBuf.writeln('    static ${closureName}ClassInfo$templateArgs _classInfo;');

    // 构造函数 — 设置 fnPtr 指向静态 trampoline
    final allCtorParams = <String>[];
    final allInitList = <String>[];
    if (capturesThis && thisType != null) {
      allCtorParams.add('$thisType this_');
      allInitList.add('this_(this_)');
    }
    for (final v in capturedVars) {
      final varName = _cleanName(v.name ?? 'v');
      if (_boxedVars.contains(v) || _scopeBoxedVars.contains(v)) {
        // Box 化变量：接收 box 指针
        final boxType = _cppBoxTypeName(v.type)!;
        allCtorParams.add('$boxType* $varName');
        allInitList.add('$varName($varName)');
      } else {
        final varType = _cppType(v.type);
        allCtorParams.add('$varType $varName');
        allInitList.add('$varName(std::move($varName))');
      }
    }

    // typed trampoline 参数：直接使用具体类型和参数名
    final typedParams = paramTypes.isNotEmpty
        ? paramTypes.asMap().entries.map((e) => '${paramTypes[e.key]} ${paramNames[e.key]}').join(', ')
        : '';
    final anyPtrParam = 'AnyGC* _env';
    final allTypedParams = typedParams.isNotEmpty
        ? '$anyPtrParam, $typedParams'
        : anyPtrParam;

    // 擦除（boxed）trampoline 参数：统一为 AnyGC*，与 TypeFunctionN::FnPtr 一致
    final erasedParams = <String>['AnyGC* _env'];
    for (var i = 0; i < paramTypes.length; i++) {
      erasedParams.add('AnyGC* _arg$i');
    }
    final allErasedParams = erasedParams.join(', ');
    // 入口拆箱：指针/AnyGC* 参数 static_cast，值类型经 dynAs 拆箱
    final erasedUnboxLines = StringBuffer();
    for (var i = 0; i < paramTypes.length; i++) {
      final paramType = paramTypes[i];
      final paramName = paramNames[i];
      if (paramType == 'AnyGC*' || paramType.endsWith('*')) {
        erasedUnboxLines.writeln('        $paramType $paramName = static_cast<$paramType>(_arg$i);');
      } else {
        erasedUnboxLines.writeln('        $paramType $paramName = dynAs<$paramType>(_arg$i);');
      }
    }

    if (allCtorParams.isNotEmpty) {
      _structBuf.writeln('    $closureName(${allCtorParams.join(', ')}) : ${allInitList.join(', ')} {');
      _structBuf.writeln('        this->fnPtr = &_trampoline;');
      _structBuf.writeln('        this->typedFnPtr = &_typedTrampoline;');
      _structBuf.writeln('        AnyGC::_classInfo = &_classInfo;');
      _structBuf.writeln('    }');
    } else {
      _structBuf.writeln('    $closureName() {');
      _structBuf.writeln('        this->fnPtr = &_trampoline;');
      _structBuf.writeln('        this->typedFnPtr = &_typedTrampoline;');
      _structBuf.writeln('        AnyGC::_classInfo = &_classInfo;');
      _structBuf.writeln('    }');
    }

    // typed trampoline — 函数体的唯一宿主，直接返回 R（无 _box/_impl 包装）。
    // _vptr_ 路径经 typedFnPtr 调用；_trampoline 也委托到这里。
    _structBuf.writeln('    static $returnType _typedTrampoline($allTypedParams) {');
    if (capturesThis || capturedVars.isNotEmpty) {
      _structBuf.writeln('        auto* _self = static_cast<$closureName$templateArgs*>(_env);');
      if (capturesThis && thisType != null) {
        _structBuf.writeln('        auto& this_ = _self->this_;');
      }
      for (final v in capturedVars) {
        final varName = _cleanName(v.name ?? 'v');
        _structBuf.writeln('        auto& $varName = _self->$varName;');
      }
    }
    _structBuf.write(bodyBuf);
    _structBuf.writeln('    }');

    // 擦除 trampoline — fnPtr 的统一签名（AnyGC* 参数，AnyGC* 返回）。
    // 纯转发：入口 dynAs 拆箱 → 委托 _typedTrampoline → _box 装箱返回值。
    _structBuf.writeln('    static AnyGC* _trampoline($allErasedParams) {');
    _structBuf.write(erasedUnboxLines.toString());
    final delegateArgs = [paramNames.map((n) => n).join(', ')];
    if (delegateArgs.first.isEmpty) delegateArgs.removeLast();
    final delegateCall = '_typedTrampoline(_env${delegateArgs.isNotEmpty ? ', ${delegateArgs.first}' : ''})';
    if (returnType == 'void') {
      _structBuf.writeln('        $delegateCall;');
      _structBuf.writeln('        return nullptr;');
    } else {
      _structBuf.writeln('        return _box($delegateCall);');
    }
    _structBuf.writeln('    }');
    // GC mark function — marks captured GC pointer fields
    _structBuf.writeln('    static void _gcMark_impl(AnyGC* self, int flag) {');
    _structBuf.writeln('        auto* _env = static_cast<$closureName$templateArgs*>(self);');
    if (capturesThis && thisType != null && _isGcPointerType(thisType)) {
      _structBuf.writeln('        if (_env->this_) _gcMark(_env->this_, flag);');
    }
    for (final v in capturedVars) {
      final varName = _cleanName(v.name ?? 'v');
      if (_boxedVars.contains(v) || _scopeBoxedVars.contains(v)) {
        _structBuf.writeln('        if (_env->$varName) _gcMark(_env->$varName, flag);');
      } else {
        final varType = _cppType(v.type);
        if (_isGcPointerType(varType)) {
          _structBuf.writeln('        if (_env->$varName) _gcMark(_env->$varName, flag);');
        }
      }
    }
    _structBuf.writeln('    }');
    _structBuf.writeln('};');
    if (templatePrefix.isNotEmpty) {
      _structBuf.writeln(templatePrefix);
    }
    _structBuf.writeln('${closureName}ClassInfo$templateArgs::${closureName}ClassInfo() {');
    _structBuf.writeln('    typeName = "Closure";');
    _structBuf.writeln('    gcMark = &$closureName$templateArgs::_gcMark_impl;');
    _structBuf.writeln('}');
    if (templatePrefix.isNotEmpty) {
      _structBuf.writeln(templatePrefix);
    }
    _structBuf.writeln('${closureName}ClassInfo$templateArgs $closureName$templateArgs::_classInfo = ${closureName}ClassInfo$templateArgs();');
    _structBuf.writeln();

    // 创建闭包实例
    final allArgs = <String>[];
    if (capturesThis && thisType != null) {
      allArgs.add('this_');
    }
    for (final v in capturedVars) {
      final varName = _cleanName(v.name ?? 'v');
      if (_boxedVars.contains(v)) {
        // 已在声明处装箱 — 直接传递 box 指针
        allArgs.add(varName);
      } else if (_envBoxedVars.contains(v)) {
        // 未在声明处装箱 — 创建新 box 包装值
        final boxType = _cppBoxTypeName(v.type)!;
        allArgs.add('new $boxType($varName)');
      } else {
        allArgs.add(varName);
      }
    }
    final args = allArgs.join(', ');
    // 使用 static_cast 确保返回类型与声明的 TypeFunction 基类匹配
    final result = 'GC::allocateLocal(static_cast<$typeFunctionBase*>(new $closureName$templateArgs($args)))';
    // 恢复 _envBoxedVars 和 _scopeBoxedVars
    _envBoxedVars
      ..clear()
      ..addAll(savedEnvBoxedVars);
    _scopeBoxedVars
      ..clear()
      ..addAll(savedScopeBoxedVars);
    return result;
  }

  /// 从调用上下文推断闭包返回类型（支持 Never/Dynamic/Null）
  String? _inferNeverReturnType(FunctionExpression expr) {
    // 查找父节点：FunctionExpression → Arguments → StaticInvocation/ConstructorInvocation
    final parent = expr.parent;
    if (parent is Arguments) {
      final grandParent = parent.parent;
      StaticInvocation? staticInv;
      ConstructorInvocation? ctorInv;
      if (grandParent is StaticInvocation) {
        staticInv = grandParent;
      } else if (grandParent is ConstructorInvocation) {
        ctorInv = grandParent;
      }

      if (staticInv != null || ctorInv != null) {
        final args = staticInv?.arguments ?? ctorInv!.arguments;
        final idx = parent.positional.indexOf(expr);
        if (idx >= 0 && idx < args.positional.length) {
          // 从目标函数的参数类型获取期望的 TypeFunction 类型
          final target = staticInv?.target ?? ctorInv!.target;
          FunctionNode? targetFunc;
          if (target is Procedure) targetFunc = target.function;
          else if (target is Constructor) targetFunc = target.function;
          if (targetFunc != null && idx < targetFunc.positionalParameters.length) {
            final paramType = targetFunc.positionalParameters[idx].type;
            // 处理 InterfaceType (TypeFunction0<R>*)
            if (paramType is InterfaceType) {
              final name = paramType.classNode.name;
              if (name.startsWith('TypeFunction') && paramType.typeArguments.isNotEmpty) {
                final resolved = _resolveClosureTypeArg(
                    paramType.typeArguments[0], targetFunc, args.types);
                if (resolved != null) return resolved;
              }
            }
            // 处理 FunctionType (T Function())
            if (paramType is FunctionType) {
              final resolved = _resolveClosureTypeArg(
                  paramType.returnType, targetFunc, args.types);
              if (resolved != null) return resolved;
            }
          }
        }
      }
    }
    return null;
  }

  /// 解析闭包返回类型中的类型参数（支持 Never/Dynamic/Null 推断）
  String? _resolveClosureTypeArg(
      DartType typeArg, FunctionNode targetFunc, List<DartType> callTypes) {
    if (typeArg is TypeParameterType) {
      final paramName = typeArg.parameter.name;
      final tpIdx = targetFunc.typeParameters.indexWhere((tp) => tp.name == paramName);
      if (tpIdx >= 0 && tpIdx < callTypes.length) {
        return _cppType(callTypes[tpIdx]);
      }
    } else if (typeArg is VoidType) {
      return 'void';
    } else if (typeArg is! DynamicType) {
      return _cppType(typeArg);
    }
    return null;
  }

  /// 从闭包体的 return 语句推断返回类型
  String? _inferReturnTypeFromBody(FunctionNode func) {
    final returnTypes = <String>{};
    _collectReturnTypes(func.body, returnTypes);
    if (returnTypes.isEmpty) return 'void';
    if (returnTypes.length == 1) return returnTypes.first;
    return null;
  }

  void _collectReturnTypes(Statement? stmt, Set<String> out) {
    if (stmt == null) return;
    if (stmt is ReturnStatement) {
      if (stmt.expression != null) {
        final type = _getReturnTypeOfExpression(stmt.expression!);
        if (type != null) out.add(type);
      }
      return;
    }
    if (stmt is Block) {
      for (final s in stmt.statements) {
        _collectReturnTypes(s, out);
      }
    } else if (stmt is IfStatement) {
      _collectReturnTypes(stmt.then, out);
      if (stmt.otherwise != null) {
        _collectReturnTypes(stmt.otherwise!, out);
      }
    } else if (stmt is WhileStatement) {
      _collectReturnTypes(stmt.body, out);
    } else if (stmt is ForStatement) {
      _collectReturnTypes(stmt.body, out);
    } else if (stmt is ForInStatement) {
      _collectReturnTypes(stmt.body, out);
    } else if (stmt is DoStatement) {
      _collectReturnTypes(stmt.body, out);
    } else if (stmt is TryCatch) {
      _collectReturnTypes(stmt.body, out);
      for (final catch_ in stmt.catches) {
        _collectReturnTypes(catch_.body, out);
      }
    } else if (stmt is TryFinally) {
      _collectReturnTypes(stmt.body, out);
      _collectReturnTypes(stmt.finalizer, out);
    } else if (stmt is LabeledStatement) {
      _collectReturnTypes(stmt.body, out);
    } else if (stmt is SwitchStatement) {
      for (final case_ in stmt.cases) {
        _collectReturnTypes(case_.body, out);
      }
    }
  }

  String? _getReturnTypeOfExpression(Expression expr) {
    if (expr is IntLiteral) return 'int64_t';
    if (expr is DoubleLiteral) return 'double';
    if (expr is BoolLiteral) return 'bool';
    if (expr is StringLiteral) return 'DartString';
    if (expr is NullLiteral) return 'AnyGC*';
    if (expr is FunctionExpression) return null;
    final dartType = _getExpressionType(expr);
    if (dartType == null) return null;
    final cppType = _cppType(dartType);
    if (cppType == 'AnyGC*') return null;
    return cppType;
  }

  /// 收集函数内部声明的局部变量
  void _collectLocalVars(TreeNode node, Set<VariableDeclaration> out) {
    if (node is VariableDeclaration) {
      out.add(node);
    }
    if (node is Statement) {
      _collectLocalVarsFromStatement(node, out);
    } else if (node is Expression) {
      _collectLocalVarsFromExpression(node, out);
    }
  }

  void _collectLocalVarsFromStatement(Statement stmt, Set<VariableDeclaration> out) {
    if (stmt is Block) {
      for (final s in stmt.statements) {
        _collectLocalVarsFromStatement(s, out);
      }
    } else if (stmt is ExpressionStatement) {
      _collectLocalVarsFromExpression(stmt.expression, out);
    } else if (stmt is ReturnStatement && stmt.expression != null) {
      _collectLocalVarsFromExpression(stmt.expression!, out);
    } else if (stmt is VariableDeclaration) {
      out.add(stmt);
      if (stmt.initializer != null) {
        _collectLocalVarsFromExpression(stmt.initializer!, out);
      }
    } else if (stmt is IfStatement) {
      _collectLocalVarsFromExpression(stmt.condition, out);
      _collectLocalVarsFromStatement(stmt.then, out);
      if (stmt.otherwise != null) {
        _collectLocalVarsFromStatement(stmt.otherwise!, out);
      }
    } else if (stmt is WhileStatement) {
      _collectLocalVarsFromExpression(stmt.condition, out);
      _collectLocalVarsFromStatement(stmt.body, out);
    } else if (stmt is ForStatement) {
      for (final v in stmt.variables) {
        out.add(v);
        _collectLocalVarsFromStatement(v, out);
      }
      if (stmt.condition != null) {
        _collectLocalVarsFromExpression(stmt.condition!, out);
      }
      for (final u in stmt.updates) {
        _collectLocalVarsFromExpression(u, out);
      }
      _collectLocalVarsFromStatement(stmt.body, out);
    } else if (stmt is TryCatch) {
      _collectLocalVarsFromStatement(stmt.body, out);
      for (final catch_ in stmt.catches) {
        if (catch_.exception != null) out.add(catch_.exception!);
        if (catch_.stackTrace != null) out.add(catch_.stackTrace!);
        _collectLocalVarsFromStatement(catch_.body, out);
      }
    } else if (stmt is TryFinally) {
      _collectLocalVarsFromStatement(stmt.body, out);
      _collectLocalVarsFromStatement(stmt.finalizer, out);
    }
  }

  void _collectLocalVarsFromExpression(Expression expr, Set<VariableDeclaration> out) {
    if (expr is Let) {
      out.add(expr.variable);
      if (expr.variable.initializer != null) {
        _collectLocalVarsFromExpression(expr.variable.initializer!, out);
      }
      _collectLocalVarsFromExpression(expr.body, out);
    } else if (expr is ConditionalExpression) {
      _collectLocalVarsFromExpression(expr.condition, out);
      _collectLocalVarsFromExpression(expr.then, out);
      _collectLocalVarsFromExpression(expr.otherwise, out);
    } else if (expr is InstanceInvocation) {
      _collectLocalVarsFromExpression(expr.receiver, out);
      for (final arg in expr.arguments.positional) {
        _collectLocalVarsFromExpression(arg, out);
      }
    } else if (expr is StaticInvocation) {
      for (final arg in expr.arguments.positional) {
        _collectLocalVarsFromExpression(arg, out);
      }
    } else if (expr is StringConcatenation) {
      for (final e in expr.expressions) {
        _collectLocalVarsFromExpression(e, out);
      }
    }
  }


  /// 从类型中收集所有类型参数
  void _collectTypeParameters(DartType type, List<String> typeParams) {
    if (type is TypeParameterType) {
      final paramName = type.parameter.name ?? 'T';
      if (!typeParams.contains(paramName)) {
        typeParams.add(paramName);
      }
    } else if (type is InterfaceType && type.typeArguments.isNotEmpty) {
      for (final arg in type.typeArguments) {
        _collectTypeParameters(arg, typeParams);
      }
    } else if (type is FunctionType) {
      _collectTypeParameters(type.returnType, typeParams);
      for (final param in type.positionalParameters) {
        _collectTypeParameters(param, typeParams);
      }
      for (final param in type.namedParameters) {
        _collectTypeParameters(param.type, typeParams);
      }
    }
  }

  /// 检查闭包体中是否使用了 ThisExpression 或 this 变量
  bool _bodyUsesThis(TreeNode? node) {
    if (node == null) return false;
    if (node is ThisExpression) return true;
    if (node is VariableGet && (node.variable.name == 'this' || node.variable.name == 'this_')) return true;
    if (node is FunctionExpression) return false; // 不进入嵌套闭包
    bool found = false;
    if (node is Block) {
      for (final s in node.statements) {
        if (_bodyUsesThis(s)) return true;
      }
    } else if (node is ExpressionStatement) {
      return _bodyUsesThis(node.expression);
    } else if (node is ReturnStatement) {
      return _bodyUsesThis(node.expression);
    } else if (node is VariableDeclaration) {
      return _bodyUsesThis(node.initializer);
    } else if (node is Let) {
      return _bodyUsesThis(node.variable.initializer) || _bodyUsesThis(node.body);
    } else if (node is StaticInvocation) {
      for (final a in node.arguments.positional) {
        if (_bodyUsesThis(a)) return true;
      }
    } else if (node is FunctionInvocation) {
      if (_bodyUsesThis(node.receiver)) return true;
      for (final a in node.arguments.positional) {
        if (_bodyUsesThis(a)) return true;
      }
    } else if (node is InstanceInvocation) {
      if (_bodyUsesThis(node.receiver)) return true;
      for (final a in node.arguments.positional) {
        if (_bodyUsesThis(a)) return true;
      }
    } else if (node is InstanceGet) {
      return _bodyUsesThis(node.receiver);
    } else if (node is InstanceSet) {
      return _bodyUsesThis(node.receiver) || _bodyUsesThis(node.value);
    } else if (node is ConditionalExpression) {
      return _bodyUsesThis(node.condition) || _bodyUsesThis(node.then) || _bodyUsesThis(node.otherwise);
    } else if (node is StringConcatenation) {
      for (final e in node.expressions) {
        if (_bodyUsesThis(e)) return true;
      }
    } else if (node is LogicalExpression) {
      return _bodyUsesThis(node.left) || _bodyUsesThis(node.right);
    } else if (node is Not) {
      return _bodyUsesThis(node.operand);
    } else if (node is ConstructorInvocation) {
      for (final a in node.arguments.positional) {
        if (_bodyUsesThis(a)) return true;
      }
    } else if (node is TryCatch) {
      if (_bodyUsesThis(node.body)) return true;
      for (final catch_ in node.catches) {
        if (_bodyUsesThis(catch_.body)) return true;
      }
    } else if (node is TryFinally) {
      if (_bodyUsesThis(node.body)) return true;
      if (_bodyUsesThis(node.finalizer)) return true;
    } else if (node is IfStatement) {
      if (_bodyUsesThis(node.condition)) return true;
      if (_bodyUsesThis(node.then)) return true;
      if (node.otherwise != null && _bodyUsesThis(node.otherwise)) return true;
    } else if (node is WhileStatement) {
      if (_bodyUsesThis(node.condition)) return true;
      if (_bodyUsesThis(node.body)) return true;
    } else if (node is ForStatement) {
      for (final v in node.variables) {
        if (_bodyUsesThis(v)) return true;
      }
      if (node.condition != null && _bodyUsesThis(node.condition)) return true;
      for (final u in node.updates) {
        if (_bodyUsesThis(u)) return true;
      }
      if (_bodyUsesThis(node.body)) return true;
    }
    return found;
  }

  void _collectCapturedVars(TreeNode node, List<VariableDeclaration> out) {
    if (node is VariableGet) {
      final decl = node.variable;
      if (!out.contains(decl)) {
        out.add(decl);
      }
    }
    // 使用递归遍历代替 visitChildren
    if (node is Statement) {
      _collectCapturedVarsFromStatement(node, out);
    } else if (node is Expression) {
      _collectCapturedVarsFromExpression(node, out);
    }
  }

  void _collectCapturedVarsFromStatement(Statement stmt, List<VariableDeclaration> out) {
    if (stmt is Block) {
      for (final s in stmt.statements) {
        _collectCapturedVarsFromStatement(s, out);
      }
    } else if (stmt is ExpressionStatement) {
      _collectCapturedVarsFromExpression(stmt.expression, out);
    } else if (stmt is ReturnStatement && stmt.expression != null) {
      _collectCapturedVarsFromExpression(stmt.expression!, out);
    } else if (stmt is VariableDeclaration && stmt.initializer != null) {
      _collectCapturedVarsFromExpression(stmt.initializer!, out);
    } else if (stmt is IfStatement) {
      _collectCapturedVarsFromExpression(stmt.condition, out);
      _collectCapturedVarsFromStatement(stmt.then, out);
      if (stmt.otherwise != null) {
        _collectCapturedVarsFromStatement(stmt.otherwise!, out);
      }
    } else if (stmt is WhileStatement) {
      _collectCapturedVarsFromExpression(stmt.condition, out);
      _collectCapturedVarsFromStatement(stmt.body, out);
    } else if (stmt is ForStatement) {
      for (final v in stmt.variables) {
        _collectCapturedVarsFromStatement(v, out);
      }
      if (stmt.condition != null) {
        _collectCapturedVarsFromExpression(stmt.condition!, out);
      }
      for (final u in stmt.updates) {
        _collectCapturedVarsFromExpression(u, out);
      }
      _collectCapturedVarsFromStatement(stmt.body, out);
    } else if (stmt is TryCatch) {
      _collectCapturedVarsFromStatement(stmt.body, out);
      for (final catch_ in stmt.catches) {
        _collectCapturedVarsFromStatement(catch_.body, out);
      }
    } else if (stmt is TryFinally) {
      _collectCapturedVarsFromStatement(stmt.body, out);
      _collectCapturedVarsFromStatement(stmt.finalizer, out);
    }
  }

  /// 穿透调用实参（位置 + 命名）收集捕获变量
  void _collectCapturedVarsFromArgs(Arguments args, List<VariableDeclaration> out) {
    for (final arg in args.positional) {
      _collectCapturedVarsFromExpression(arg, out);
    }
    for (final named in args.named) {
      _collectCapturedVarsFromExpression(named.value, out);
    }
  }

  void _collectCapturedVarsFromExpression(Expression expr, List<VariableDeclaration> out) {
    if (expr is VariableGet) {
      final decl = expr.variable;
      if (!out.contains(decl)) {
        out.add(decl);
      }
    } else if (expr is VariableSet) {
      // VariableSet 修改捕获的变量，需要同时收集该变量
      final decl = expr.variable;
      if (!out.contains(decl)) {
        out.add(decl);
      }
      _collectCapturedVarsFromExpression(expr.value, out);
    } else if (expr is InstanceInvocation) {
      _collectCapturedVarsFromExpression(expr.receiver, out);
      _collectCapturedVarsFromArgs(expr.arguments, out);
    } else if (expr is StaticInvocation) {
      _collectCapturedVarsFromArgs(expr.arguments, out);
    } else if (expr is StringConcatenation) {
      for (final e in expr.expressions) {
        _collectCapturedVarsFromExpression(e, out);
      }
    } else if (expr is ConditionalExpression) {
      _collectCapturedVarsFromExpression(expr.condition, out);
      _collectCapturedVarsFromExpression(expr.then, out);
      _collectCapturedVarsFromExpression(expr.otherwise, out);
    } else if (expr is EqualsCall) {
      _collectCapturedVarsFromExpression(expr.left, out);
      _collectCapturedVarsFromExpression(expr.right, out);
    } else if (expr is InstanceGet) {
      _collectCapturedVarsFromExpression(expr.receiver, out);
    } else if (expr is InstanceSet) {
      _collectCapturedVarsFromExpression(expr.receiver, out);
      _collectCapturedVarsFromExpression(expr.value, out);
    } else if (expr is Not) {
      _collectCapturedVarsFromExpression(expr.operand, out);
    } else if (expr is LogicalExpression) {
      _collectCapturedVarsFromExpression(expr.left, out);
      _collectCapturedVarsFromExpression(expr.right, out);
    } else if (expr is ListLiteral) {
      for (final e in expr.expressions) {
        _collectCapturedVarsFromExpression(e, out);
      }
    } else if (expr is MapLiteral) {
      for (final entry in expr.entries) {
        _collectCapturedVarsFromExpression(entry.key, out);
        _collectCapturedVarsFromExpression(entry.value, out);
      }
    } else if (expr is SetLiteral) {
      for (final e in expr.expressions) {
        _collectCapturedVarsFromExpression(e, out);
      }
    } else if (expr is AsExpression) {
      _collectCapturedVarsFromExpression(expr.operand, out);
    } else if (expr is IsExpression) {
      _collectCapturedVarsFromExpression(expr.operand, out);
    } else if (expr is FunctionInvocation) {
      _collectCapturedVarsFromExpression(expr.receiver, out);
      _collectCapturedVarsFromArgs(expr.arguments, out);
    } else if (expr is AwaitExpression) {
      _collectCapturedVarsFromExpression(expr.operand, out);
    } else if (expr is Throw) {
      _collectCapturedVarsFromExpression(expr.expression, out);
    } else if (expr is ConstructorInvocation) {
      _collectCapturedVarsFromArgs(expr.arguments, out);
    } else if (expr is Let) {
      if (expr.variable.initializer != null) {
        _collectCapturedVarsFromExpression(expr.variable.initializer!, out);
      }
      _collectCapturedVarsFromExpression(expr.body, out);
    } else if (expr is FunctionExpression) {
      // 递归收集嵌套闭包中引用的变量，但排除嵌套闭包自己的参数
      final func = expr.function;
      if (func.body != null) {
        // 先收集嵌套闭包体中引用的所有变量
        final nestedCaptured = <VariableDeclaration>[];
        _collectCapturedVarsFromStatement(func.body!, nestedCaptured);

        // 排除嵌套闭包自己的参数
        final nestedParams = <VariableDeclaration>{};
        nestedParams.addAll(func.positionalParameters);
        nestedParams.addAll(func.namedParameters);

        // 只添加不在嵌套闭包参数中的变量
        for (final v in nestedCaptured) {
          if (!nestedParams.contains(v) && !out.contains(v)) {
            out.add(v);
          }
        }
      }
    }
  }

  void _emitCppStmtToBuffer(Statement stmt, StringBuffer buf) {
    final oldBuf = _implBuf;
    _implBuf = buf;
    _emitCppStmt(stmt, buf);
    _implBuf = oldBuf;
  }

  String _emitCppFunctionInvocation(FunctionInvocation expr) {
    // 检查是否是 IIFE (Immediately Invoked Function Expression) 模式
    // 即 (() { ... })() 形式的调用，应该生成内联 lambda
    if (expr.receiver is FunctionExpression) {
      final funcExpr = expr.receiver as FunctionExpression;
      final func = funcExpr.function;
      // 如果函数没有参数且没有捕获变量，可以生成简单的内联 lambda
      if (func.positionalParameters.isEmpty && func.namedParameters.isEmpty) {
        final returnType = _cppType(func.returnType);
        final bodyBuf = StringBuffer();
        if (func.body != null) {
          _emitCppStmtToBuffer(func.body!, bodyBuf);
        }
        var body = bodyBuf.toString().trim();
        // 如果 body 是 return 语句，提取表达式并包装在 lambda 中
        if (body.startsWith('return ') && body.endsWith(';')) {
          final exprStr = body.substring(7, body.length - 1).trim();
          // 使用 IIFE 确保 Let 表达式的变量在作用域内
          return '([&]() -> $returnType { return $exprStr; })()';
        }
        return '([&]() -> $returnType { $body })()';
      }
    }

    final receiver = _emitCppExpr(expr.receiver);
    final argExprs = expr.arguments.positional.map((e) => _emitCppExpr(e)).toList();

    // Typed dispatch: when receiver has a known FunctionType, call fnPtr directly
    final receiverType = _getExpressionType(expr.receiver);
    if (receiverType is FunctionType) {
      final returnType = _cppType(receiverType.returnType);
      final paramTypes = receiverType.positionalParameters.map(_cppType).toList();

      final convertedArgs = <String>[];
      for (var i = 0; i < argExprs.length; i++) {
        final arg = argExprs[i];
        // fnPtr 统一擦除签名：实参一律装箱为 AnyGC*（指针 static_cast，值类型 _box）
        convertedArgs.add(_isAnyPtrResult(arg) ? arg : '_box($arg)');
      }

      final callExpr = convertedArgs.isEmpty
          ? '$receiver->fnPtr($receiver)'
          : '$receiver->fnPtr($receiver, ${convertedArgs.join(', ')})';

      if (returnType == 'void') {
        return callExpr;
      }
      if (returnType == 'AnyGC*') {
        return callExpr;
      }
      return 'dynAs<$returnType>($callExpr)';
    }

    // Type-erased fallback: downcast from AnyGC* (legal) for unknown receiver types
    final argCount = argExprs.length;
    final anyArgs = List.filled(argCount, 'AnyGC*').join(', ');
    final typeArgs = anyArgs.isEmpty ? 'AnyGC*' : 'AnyGC*, $anyArgs';
    final castReceiver = 'static_cast<TypeFunctionN<$typeArgs>*>($receiver)';
    if (argExprs.isEmpty) return '$castReceiver->fnPtr($castReceiver)';
    final wrappedArgs = argExprs.map((a) => '_box($a)').join(', ');
    return '$castReceiver->fnPtr($castReceiver, $wrappedArgs)';
  }

  String _emitCppAwait(AwaitExpression expr) {
    final operand = _emitCppExpr(expr.operand);
    // 推断返回类型，默认为 AnyPtr
    final resultType = _inferAwaitReturnType(expr.operand);
    // smAwait<T> returns T, so no conversion needed
    // When T is AnyGC*, primitive args need boxing
    final boxedOperand = resultType == 'AnyGC*' ? '_box($operand)' : operand;
    return 'smAwait<$resultType>($boxedOperand)';
  }

  String _inferAwaitReturnType(Expression expr) {
    // 尝试从表达式类型推断 await 的返回类型
    // 由于无法直接获取静态类型，我们从表达式的结构推断
    if (expr is StaticInvocation) {
      final target = expr.target;
      final returnType = target.function.returnType;
      if (returnType is InterfaceType && returnType.classNode.name == 'Future') {
        final typeArgs = returnType.typeArguments;
        if (typeArgs.isNotEmpty) {
          final resolved = _cppType(typeArgs[0]);
          // 避免使用裸类型参数（如 T），改为 AnyPtr
          if (_isCppTypeParameter(resolved)) return 'AnyGC*';
          if (resolved == 'void') return 'int';
          return resolved;
        }
      }
      if (returnType is FutureOrType) {
        final resolved = _cppType(returnType.typeArgument);
        if (_isCppTypeParameter(resolved)) return 'AnyGC*';
        if (resolved == 'void') return 'int';
        return resolved;
      }
    } else if (expr is InstanceInvocation) {
      final target = expr.interfaceTarget;
      final returnType = target.function.returnType;
      if (returnType is InterfaceType && returnType.classNode.name == 'Future') {
        final typeArgs = returnType.typeArguments;
        if (typeArgs.isNotEmpty) {
          final resolved = _cppType(typeArgs[0]);
          if (_isCppTypeParameter(resolved)) return 'AnyGC*';
          if (resolved == 'void') return 'int';
          return resolved;
        }
      }
      if (returnType is FutureOrType) {
        final resolved = _cppType(returnType.typeArgument);
        if (_isCppTypeParameter(resolved)) return 'AnyGC*';
        if (resolved == 'void') return 'int';
        return resolved;
      }
    } else if (expr is ConstructorInvocation) {
      final target = expr.target;
      final enclosing = target.enclosingClass;
      if (enclosing.name == 'Future' || enclosing.name == '_Future') {
        final typeArgs = expr.arguments.types;
        if (typeArgs.isNotEmpty) {
          final resolved = _cppType(typeArgs[0]);
          if (_isCppTypeParameter(resolved)) return 'AnyGC*';
          if (resolved == 'void') return 'int';
          return resolved;
        }
      }
    }
    return 'AnyGC*';
  }

  /// 检查 C++ 类型名是否是裸类型参数（如 T, E, R 等），
  /// 这些在非模板上下文中不可用
  bool _isCppTypeParameter(String cppType) {
    if (cppType.isEmpty) return false;
    // 裸类型参数通常是单个大写字母
    if (cppType.length == 1 && cppType.codeUnitAt(0) >= 65 && cppType.codeUnitAt(0) <= 90) {
      return true;
    }
    // 以 T 开头后跟大写字母的名称（如 TInput, TOutput, TNewOutput, TR, TKey, TValue）
    if (cppType.startsWith('T') && cppType.length > 1 &&
        cppType.codeUnitAt(1) >= 65 && cppType.codeUnitAt(1) <= 90 &&
        !cppType.contains('::') && !cppType.contains('*') && !cppType.contains('<')) {
      return true;
    }
    return false;
  }

  /// 检查 C++ 类型字符串是否包含未解析的类型参数（如 PipelineValue<TInput, TNewOutput>）
  bool _containsTypeParameter(String cppType) {
    // 检查模板参数部分 <...>
    final templateMatch = RegExp(r'<(.+)>').firstMatch(cppType);
    if (templateMatch != null) {
      final args = _splitTemplateArgs(templateMatch.group(1)!);
      for (final arg in args) {
        final trimmed = arg.trim();
        if (_isCppTypeParameter(trimmed)) return true;
        // 递归检查嵌套模板
        if (trimmed.contains('<') && _containsTypeParameter(trimmed)) return true;
      }
    }
    return false;
  }

  /// 检查 C++ 类型是否包含不在给定作用域名称集合内的模板类型参数
  bool _containsUnresolvedTypeParam(String cppType, Set<String> inScopeNames) {
    final templateMatch = RegExp(r'<(.+)>').firstMatch(cppType);
    if (templateMatch != null) {
      final args = _splitTemplateArgs(templateMatch.group(1)!);
      for (final arg in args) {
        final trimmed = arg.trim();
        if (_isCppTypeParameter(trimmed) && !inScopeNames.contains(trimmed)) return true;
        if (trimmed.contains('<') && _containsUnresolvedTypeParam(trimmed, inScopeNames)) return true;
      }
    }
    return false;
  }

  /// 检查类型字符串是否包含不在作用域内的类型参数（如 R2, T 等）
  bool _typeHasUnresolvedParam(String cppType, Set<String> inScopeNames) {
    // 提取所有看起来像类型参数的标识符（单个大写字母，或大写字母开头后跟字母/数字）
    final matches = RegExp(r'\b([A-Z][A-Za-z0-9]*)\b').allMatches(cppType);
    for (final m in matches) {
      final name = m.group(1)!;
      // 排除已知的 C++ 类型名
      if (['AnyGC*', 'AnyGC', 'StaticList', 'StaticMap', 'StaticSet', 'TypeFunction0',
            'TypeFunction1', 'TypeFunction2', 'Promise'].contains(name)) continue;
      // 如果看起来像类型参数（短名称）且不在作用域内
      if (name.length <= 3 && name.codeUnitAt(0) >= 65 && name.codeUnitAt(0) <= 90 &&
          !inScopeNames.contains(name)) {
        return true;
      }
    }
    return false;
  }

  /// 替换复合类型（如 TypeFunction1<R, T>*）中未解析的类型参数为 AnyPtr
  String _replaceUnresolvedTypeParamsInComposite(String cppType, Set<String> classParamNames, Set<String> methodParamNames) {
    final templateMatch = RegExp(r'<(.+)>').firstMatch(cppType);
    if (templateMatch == null) return cppType;

    final allInScope = {...classParamNames, ...methodParamNames};
    final argsStr = templateMatch.group(1)!;
    final args = _splitTopLevel(argsStr);
    bool changed = false;
    final newArgs = args.map((arg) {
      final trimmed = arg.trim();
      if (_isTemplateTypeParam(trimmed) && !allInScope.contains(trimmed)) {
        changed = true;
        return 'AnyGC*';
      }
      // 递归处理嵌套模板
      if (trimmed.contains('<')) {
        final replaced = _replaceUnresolvedTypeParamsInComposite(trimmed, classParamNames, methodParamNames);
        if (replaced != trimmed) changed = true;
        return replaced;
      }
      return arg;
    }).toList();

    if (!changed) return cppType;
    final prefix = cppType.substring(0, templateMatch.start);
    final suffix = cppType.substring(templateMatch.end);
    return '$prefix<${newArgs.join(',')}>$suffix';
  }

  /// 检查 C++ 类型是否包含不在当前作用域内的模板类型参数
  bool _hasOutOfScopeTypeParam(String cppType) {
    final templateMatch = RegExp(r'<(.+)>').firstMatch(cppType);
    if (templateMatch != null) {
      final args = _splitTemplateArgs(templateMatch.group(1)!);
      for (final arg in args) {
        final trimmed = arg.trim();
        if (_isCppTypeParameter(trimmed) && !_inScopeTypeParams.contains(trimmed)) return true;
        if (trimmed.contains('<') && _hasOutOfScopeTypeParam(trimmed)) return true;
      }
    }
    return false;
  }

  String _emitCppThrow(Throw expr) {
    final value = _emitCppExpr(expr.expression);
    // 检查是否已经是 DartException 或其子类
    if (value.startsWith('DartException') ||
        value.startsWith('DartArgumentError') ||
        value.startsWith('DartStateError') ||
        value.startsWith('DartRangeError') ||
        value.startsWith('DartFormatException') ||
        value.startsWith('DartUnsupportedError') ||
        value.startsWith('DartUnimplementedError')) {
      return 'throw $value';
    }
    // 检查是否已经是 std::exception 子类（排除 DartString）
    if (value.startsWith('std::') && !value.startsWith('DartString')) {
      return 'throw $value';
    }
    // 如果 value 已经是字符串字面量或 DartString，直接使用
    if (value.startsWith('"') || value.startsWith('dart_str(') || value.startsWith('DartString(')) {
      return 'throw DartException($value)';
    }
    // 检查是否是 Box 类型（StringBox, IntBox, DoubleBox, BoolBox, ObjectBox）
    // 从 GC::allocateLocal(new XxxBox(...)) 提取值
    final boxMatch = RegExp(r'GC::allocateLocal\(new (String|Int|Double|Bool|Object)Box\((.+)\)\)$').firstMatch(value);
    if (boxMatch != null) {
      final boxType = boxMatch.group(1)!;
      final innerValue = boxMatch.group(2)!;
      if (boxType == 'String') {
        return 'throw DartException($innerValue)';
      }
      // 对于非字符串类型，转换为字符串
      return 'throw DartException(std::to_string($innerValue))';
    }
    // 检查是否是 StringBox* 变量
    if (value.endsWith('Box') || value.contains('Box(')) {
      return 'throw DartException(dart_str($value))';
    }
    // 兜底：尝试 dart_str
    return 'throw DartException(dart_str($value))';
  }

  String _emitCppStaticGet(StaticGet expr) {
    final target = expr.target;
    if (target is Field) {
      final fieldName = _cleanName(target.name.text);
      // 检查是否属于特定类（如 GlobalScheduler.instance）
      final enclosingClass = target.enclosingClass;
      if (enclosingClass != null) {
        final className = enclosingClass.name;
        if (className == 'GlobalScheduler' && fieldName == 'instance') {
          return 'GlobalScheduler::instance()';
        }
        // 对于枚举类的静态字段，使用 ClassName::fieldName
        if (_enumNames.contains(className)) {
          return '$className::$fieldName';
        }
        // 用户类的静态字段：直接使用全局变量名
        if (_userClasses.contains(className) || _mixinNames.contains(className)) {
          // 私有字段使用原始名（如 _callCount），公开字段也用原始名
          return fieldName;
        }
      }
      return fieldName;
    }
    if (target is Procedure) {
      final procName = _cleanName(target.name.text);
      final enclosingClass = target.enclosingClass;
      if (enclosingClass != null) {
        if (enclosingClass.name == 'GlobalScheduler') {
          return 'GlobalScheduler::$procName';
        }
        // 用户类的静态 getter：调用 lowered getter 函数
        if (_userClasses.contains(enclosingClass.name) && target.isGetter) {
          final cleanClassName = _cleanName(enclosingClass.name);
          return '${cleanClassName}_get_$procName()';
        }
        // 用户类的其他静态方法引用
        if (_userClasses.contains(enclosingClass.name)) {
          final cleanClassName = _cleanName(enclosingClass.name);
          return '${cleanClassName}_$procName';
        }
      }
      return procName;
    }
    return '/* StaticGet */';
  }

  String _emitCppStaticSet(StaticSet expr) {
    final target = expr.target;
    final value = _emitCppExpr(expr.value);
    if (target is Field) {
      final fieldName = _cleanName(target.name.text);
      final fieldType = _cppType(target.type);
      // F3/F4 修复：GC 对象指针类型的静态字段赋值时，
      // 旧值移出 root 集（避免永久钉住），新值注册为 root
      if (fieldType.endsWith('*') &&
          !_enumNames.contains(target.enclosingClass?.name ?? '')) {
        if (value == 'nullptr') {
          return '(GC::removeRoot($fieldName), $fieldName = nullptr)';
        }
        return '(GC::removeRoot($fieldName), $fieldName = GC::allocateGlobal($value))';
      }
      return '$fieldName = $value';
    }
    return '/* StaticSet */';
  }

  String _emitCppLet(Let expr) {
    // 如果变量没有名称，分配一个（与 Dart restorer 保持一致）
    if (expr.variable.name == null) {
      expr.variable.name = '_let${_varCounter++}';
    }
    final originalName = expr.variable.name!;
    final varName = _cleanName(originalName);
    final varType = _cppType(expr.variable.type);

    // void 类型变量：直接执行表达式，不声明变量
    if (varType == 'void') {
      final init = expr.variable.initializer != null
          ? _emitCppExpr(expr.variable.initializer!)
          : '';
      final body = _emitCppExpr(expr.body);
      if (init.isNotEmpty) {
        return '([&]() { $init; return $body; })()';
      }
      return body;
    }

    // 如果 initializer 是 Let 表达式，将其作为嵌套 Let 处理
    if (expr.variable.initializer is Let) {
      final innerLet = expr.variable.initializer as Let;
      // 将 innerLet 的 body 设置为 expr，形成嵌套结构
      // 但实际上我们应该直接处理嵌套的 Let
      return _emitCppNestedLetFromInit(innerLet, expr, varName, varType);
    }

    final init = expr.variable.initializer != null
        ? _emitCppExpr(expr.variable.initializer!)
        : _cppDefaultValue(varType);

    // 包装初始化器以匹配目标类型
    String wrappedInit;
    if (expr.variable.initializer != null) {
      wrappedInit = _wrapToType(init, varType, expr.variable.initializer!);
      // 如果目标类型是 AnyGC* 但初始化器产生了非指针类型（如 int64_t, DartString），
      // 使用 IIFE 执行副作用并返回 nullptr
      if (varType == 'AnyGC*') {
        final initType = _getExpressionType(expr.variable.initializer!);
        final initCppType = initType != null ? _cppType(initType) : '';
        if (initCppType.isNotEmpty && initCppType != 'AnyGC*' && initCppType != 'AnyGC*' &&
            !initCppType.endsWith('*')) {
          wrappedInit = '([&]() { (void)($init); return nullptr; })()';
        }
      }
    } else {
      wrappedInit = init;
    }

    // 设置变量名映射
    if (originalName != varName) {
      _variableNameMappings[originalName] = varName;
    }
    // 记录变量类型
    _variableTypeMap[varName] = varType;

    // 检查是否是嵌套的 Let 表达式（用于 ?. 操作符链）
    if (expr.body is Let) {
      final result = _emitCppNestedLet(expr, varName, varType, init);
      // 清理变量名映射
      if (originalName != varName) {
        _variableNameMappings.remove(originalName);
      }
      return result;
    }

    // 尝试识别 ?. 或 ?? 操作符的脱糖形式
    final nullSafe = _tryEmitNullSafeOperator(expr, varName, varType, init);
    if (nullSafe != null) {
      // 清理变量名映射
      if (originalName != varName) {
        _variableNameMappings.remove(originalName);
      }
      return nullSafe;
    }

    final body = _emitCppExpr(expr.body);

    // 清理变量名映射
    if (originalName != varName) {
      _variableNameMappings.remove(originalName);
    }

    return '([&]() { $varType $varName = $wrappedInit; return $body; })()';
  }

  /// 处理 initializer 是 Let 表达式的情况
  String _emitCppNestedLetFromInit(Let innerLet, Let outerLet, String outerVarName, String outerVarType) {
    // 收集所有嵌套的 Let 变量（从 innerLet 开始，到 outerLet）
    final vars = <String>[];
    final originalNames = <String>[];
    final types = <String>[];
    final inits = <String>[];

    // 先处理 innerLet 链
    Let? current = innerLet;
    while (current != null) {
      if (current.variable.name == null) {
        current.variable.name = '_let${_varCounter++}';
      }
      final originalName = current.variable.name!;
      final name = _cleanName(originalName);
      final type = _cppType(current.variable.type);
      final initVal = current.variable.initializer != null
          ? _emitCppExpr(current.variable.initializer!)
          : _cppDefaultValue(type);

      vars.add(name);
      originalNames.add(originalName);
      types.add(type);
      inits.add(initVal);

      if (originalName != name) {
        _variableNameMappings[originalName] = name;
      }

      if (current.body is Let) {
        current = current.body as Let;
      } else {
        // innerLet 的 body 不是 Let，跳出循环
        break;
      }
    }

    // 然后处理 outerLet
    vars.add(outerVarName);
    originalNames.add(outerVarName);
    types.add(outerVarType);

    // outerLet 的 initializer 是 innerLet，我们需要生成 innerLet 的完整表达式
    // 检查 innerLet 的 body 是否是 null-safe 或 null-coalescing 模式
    final innerBody = current!.body;
    if (innerBody is ConditionalExpression) {
      // 使用 current（内层 Let）变量的类型和名称（EqualsNull 检查的是 current.variable）
      final innerVarName = _cleanName(current.variable.name ?? 'v');
      final innerVarType = _cppType(current.variable.type);
      final innerVarInit = current.variable.initializer != null
          ? _emitCppExpr(current.variable.initializer!)
          : _cppDefaultValue(innerVarType);
      final nullSafe = _tryEmitNullSafeOperator(current, innerVarName, innerVarType, innerVarInit);
      if (nullSafe != null) {
        inits.add(nullSafe);
      } else {
        inits.add(_emitCppExpr(innerBody));
      }
    } else {
      inits.add(_emitCppExpr(innerBody));
    }

    if (outerVarName != _cleanName(outerVarName)) {
      _variableNameMappings[outerVarName] = _cleanName(outerVarName);
    }

    // 生成 IIFE
    final body = _emitCppExpr(outerLet.body);
    final varDecls = StringBuffer();
    for (var i = 0; i < vars.length; i++) {
      if (types[i] == 'void') {
        varDecls.write('${inits[i]}; ');
      } else {
        varDecls.write('${types[i]} ${vars[i]} = ${inits[i]}; ');
      }
    }

    // 清理变量名映射
    for (final origName in originalNames) {
      if (origName != _cleanName(origName)) {
        _variableNameMappings.remove(origName);
      }
    }

    return '([&]() { $varDecls return $body; })()';
  }

  /// 处理嵌套的 Let 表达式（用于 ?. 操作符链）
  String _emitCppNestedLet(Let expr, String varName, String varType, String init) {
    // 收集所有嵌套的 Let 变量
    final vars = <String>[];
    final originalNames = <String>[];
    final types = <String>[];
    final inits = <String>[];

    Let? current = expr;
    while (current != null) {
      // 如果变量没有名称，分配一个（与 Dart restorer 保持一致）
      if (current.variable.name == null) {
        current.variable.name = '_let${_varCounter++}';
      }
      final originalName = current.variable.name!;
      final name = _cleanName(originalName);
      final type = _cppType(current.variable.type);
      final initVal = current.variable.initializer != null
          ? _emitCppExpr(current.variable.initializer!)
          : _cppDefaultValue(type);

      vars.add(name);
      originalNames.add(originalName);
      types.add(type);
      inits.add(initVal);

      // 设置变量名映射
      if (originalName != name) {
        _variableNameMappings[originalName] = name;
      }

      if (current.body is Let) {
        current = current.body as Let;
      } else {
        // 到达最内层，生成完整的 IIFE
        final body = _emitCppExpr(current.body);
        final varDecls = StringBuffer();
        for (var i = 0; i < vars.length; i++) {
          if (types[i] == 'void') {
            // void 类型：直接执行表达式，不声明变量
            varDecls.write('${inits[i]}; ');
          } else {
            varDecls.write('${types[i]} ${vars[i]} = ${inits[i]}; ');
          }
        }

        // 清理变量名映射
        for (final origName in originalNames) {
          if (origName != _cleanName(origName)) {
            _variableNameMappings.remove(origName);
          }
        }

        return '([&]() { $varDecls return $body; })()';
      }
    }

    // 不应该到达这里
    return '/* error: nested let */';
  }

  /// 尝试识别 ?. 或 ?? 操作符的脱糖形式
  /// 返回 null 如果 expr 不是 null 操作符的脱糖
  String? _tryEmitNullSafeOperator(Let expr, String varName, String varType, String init) {
    if (expr.body is! ConditionalExpression) return null;
    final cond = expr.body as ConditionalExpression;
    if (cond.condition is! EqualsNull) return null;
    final eqNull = cond.condition as EqualsNull;
    if (eqNull.expression is! VariableGet) return null;
    final varGet = eqNull.expression as VariableGet;
    if (varGet.variable != expr.variable) return null;

    if (cond.then is NullLiteral) {
      // ?. 操作符的脱糖形式: Let _v = x in (_v == null) ? null : _v.something
      return _emitNullPropagation(varName, varType, init, cond);
    }

    // ?? 操作符的脱糖形式: Let _v = x in (_v == null) ? fallback : _v
    // 验证 otherwise 分支是对 Let 变量的引用，且 then 分支不是 Let 变量引用
    if (cond.otherwise is VariableGet) {
      final otherwiseVar = (cond.otherwise as VariableGet).variable;
      final thenReferencesLetVar = _expressionReferencesVariable(cond.then, expr.variable);
      if (otherwiseVar == expr.variable && !thenReferencesLetVar) {
        // 标准 ?? 模式：then 是 fallback（不引用 Let 变量），otherwise 是变量
        final fallbackExpr = _emitCppExpr(cond.then);
        return _emitNullCoalescing(varType, init, cond, fallbackExpr);
      }
    }

    // 不匹配任何已知的 null 操作符模式，返回 null 让调用方处理
    return null;
  }

  /// 检查表达式是否引用了指定的变量
  bool _expressionReferencesVariable(Expression expr, VariableDeclaration variable) {
    if (expr is VariableGet) {
      return expr.variable == variable;
    } else if (expr is AsExpression) {
      return _expressionReferencesVariable(expr.operand, variable);
    } else if (expr is NullCheck) {
      return _expressionReferencesVariable(expr.operand, variable);
    } else if (expr is InstanceGet) {
      return _expressionReferencesVariable(expr.receiver, variable);
    } else if (expr is InstanceInvocation) {
      return _expressionReferencesVariable(expr.receiver, variable);
    } else if (expr is Not) {
      return _expressionReferencesVariable(expr.operand, variable);
    } else if (expr is ConditionalExpression) {
      return _expressionReferencesVariable(expr.condition, variable) ||
          _expressionReferencesVariable(expr.then, variable) ||
          _expressionReferencesVariable(expr.otherwise, variable);
    }
    return false;
  }

  /// 发射 ?. 操作符的 C++ 代码
  /// 根据类型生成不同的 null 检查
  String _emitNullPropagation(String varName, String varType, String init, ConditionalExpression cond) {
    final otherwise = _emitCppExpr(cond.otherwise);

    // DartString 需要特殊处理嵌套的 ?. 链
    if (varType == 'DartString' && cond.otherwise is Let) {
      final nestedResult = _tryEmitNestedNullSafeChain(cond.otherwise as Let, varName, varType, init);
      if (nestedResult != null) return nestedResult;
    }

    return _cppNullCheck(varType, init, otherwise, otherwiseExpr: cond.otherwise, varName: varName);
  }

  /// 尝试发射嵌套的 ?. 链（DartString 特殊处理）
  String? _tryEmitNestedNullSafeChain(Let nestedLet, String varName, String varType, String init) {
    final nestedVarType = _cppType(nestedLet.variable.type);
    final nestedInit = nestedLet.variable.initializer != null
        ? _emitCppExpr(nestedLet.variable.initializer!)
        : _cppDefaultValue(nestedVarType);
    final nestedVarName = _cleanName(nestedLet.variable.name ?? 'v');

    if (nestedLet.body is! ConditionalExpression) return null;
    final nestedCond = nestedLet.body as ConditionalExpression;
    if (nestedCond.condition is! EqualsNull) return null;
    final nestedEqNull = nestedCond.condition as EqualsNull;
    if (nestedEqNull.expression is! VariableGet) return null;
    final nestedVarGet = nestedEqNull.expression as VariableGet;
    if (nestedVarGet.variable != nestedLet.variable) return null;

    if (nestedCond.then is NullLiteral) {
      // 嵌套 ?. 链
      final nestedOtherwise = _emitCppExpr(nestedCond.otherwise);
      final nullCheck1 = _emitNullCheck(varName, varType);
      final nullCheck2 = _emitNullCheck(nestedVarName, nestedVarType);
      return '([&]() { $varType $varName = $init; if ($nullCheck1) return $varType{}; $nestedVarType $nestedVarName = $nestedInit; if ($nullCheck2) return $nestedVarType{}; return $nestedOtherwise; })()';
    } else {
      // 嵌套 ?. 后跟 ??
      final nestedFallback = _emitCppExpr(nestedCond.otherwise);
      final nullCheck1 = _emitNullCheck(varName, varType);
      final nullCheck2 = _emitNullCheck(nestedVarName, nestedVarType);
      return '([&]() { $varType $varName = $init; if ($nullCheck1) return $varType{}; $nestedVarType $nestedVarName = $nestedInit; return ($nullCheck2 ? $nestedFallback : $nestedVarName); })()';
    }
  }

  /// 发射 ?? 操作符的 C++ 代码
  String _emitNullCoalescing(String varType, String init, ConditionalExpression cond, [String? fallbackOverride]) {
    final fallback = fallbackOverride ?? _emitCppExpr(cond.then);
    if (varType == 'AnyGC*') {
      // 当变量是 AnyGC* 时，需要确保三元表达式的两个分支类型一致
      // 如果 fallback 是原始类型，将其转换为 AnyGC*
      final fallbackWrapped = _wrapAsAnyGCPtrIfNeeded(fallback, cond.then);
      return '(dart_isNull($init) ? $fallbackWrapped : $init)';
    } else if (varType.endsWith('*')) {
      return '(dart_isNull($init) ? $fallback : $init)';
    } else if (varType == 'DartString') {
      // 可空字符串来自 Map 访问时，init 形如 (*(*map)[key])（已解引用的指针）。
      if (init.startsWith('(*(*') && init.endsWith(')')) {
        final ptrExpr = init.substring(2, init.length - 1);
        return '(dart_isNull($ptrExpr) ? $fallback : $init)';
      }
      // 可空字符串的 null 表示为空字符串
      return '($init.empty() ? $fallback : $init)';
    } else if (varType == 'int64_t' || varType == 'double' || varType == 'bool') {
      // 可空基本类型来自 Map 访问时，init 形如 (*(*map)[key])（已解引用的指针）。
      // 此时指针可能为 nullptr（key 不存在），需要生成空检查。
      if (init.startsWith('(*(*') && init.endsWith(')')) {
        final ptrExpr = init.substring(2, init.length - 1);
        return '(dart_isNull($ptrExpr) ? $fallback : $init)';
      }
      // 非指针来源的基本类型确实不能为 null，直接返回初始化值
      return init;
    } else {
      // 其他类型（如用户自定义类）检查 nullptr
      return '(dart_isNull($init) ? $fallback : $init)';
    }
  }

  /// 生成 null 检查表达式
  /// 对于基本类型（int64_t, double, bool），不生成 null 检查
  /// 对于 DartString，检查 empty()（可空字符串的 null 表示为空字符串）
  /// 对于指针类型，生成 dart_isNull 检查
  String _emitNullCheck(String expr, String type) {
    if (type == 'int64_t' || type == 'double' || type == 'bool') {
      return 'false';
    } else if (type == 'DartString') {
      return '($expr.empty())';
    } else {
      return 'dart_isNull($expr)';
    }
  }

  /// 将表达式包装为 AnyGC*（如果需要）
  /// 用于确保三元表达式的两个分支类型一致
  String _wrapAsAnyGCPtrIfNeeded(String expr, Expression originalExpr) {
    // 如果已经是 AnyGC* 或 nullptr，不需要包装
    if (expr == 'nullptr' || expr.startsWith('static_cast<AnyGC*>')) {
      return expr;
    }
    // 检查是否是原始类型字面量
    if (originalExpr is IntLiteral) {
      return 'GC::allocateLocal(new IntBox($expr))';
    }
    if (originalExpr is DoubleLiteral) {
      return 'GC::allocateLocal(new DoubleBox($expr))';
    }
    if (originalExpr is BoolLiteral) {
      return 'GC::allocateLocal(new BoolBox($expr))';
    }
    if (originalExpr is StringLiteral) {
      return 'GC::allocateLocal(new StringBox($expr))';
    }
    // 默认返回表达式
    return expr;
  }

  /// 根据类型生成 null 检查表达式
  String _cppNullCheck(String varType, String init, String otherwise, {Expression? otherwiseExpr, String? varName}) {
    if (varType == 'AnyGC*') {
      // 确保 otherwise 也是 AnyGC* 类型
      String otherwiseWrapped = otherwise;
      if (otherwiseExpr != null) {
        otherwiseWrapped = _wrapAsAnyGCPtrIfNeeded(otherwise, otherwiseExpr);
      }
      // 如果 otherwise 引用了 Let 变量，需要包装在 lambda 中声明变量
      if (varName != null && otherwiseWrapped.contains(varName)) {
        return '([&]() { $varType $varName = $init; return (dart_isNull($varName) ? nullptr : $otherwiseWrapped); })()';
      }
      return '(dart_isNull($init) ? nullptr : $otherwiseWrapped)';
    } else if (varType.endsWith('*')) {
      // 检查 otherwise 的返回类型 — 如果是值类型（DartString 等），null 分支需要用对应的默认值
      final otherwiseResultType = otherwiseExpr != null ? _getExpressionType(otherwiseExpr) : null;
      final otherwiseCppType = otherwiseResultType != null ? _cppType(otherwiseResultType) : '';
      if (otherwiseCppType == 'DartString') {
        // ?. 链结果是 DartString，null 分支返回空字符串
        if (varName != null && otherwise.contains(varName)) {
          return '([&]() { $varType $varName = $init; return (dart_isNull($varName) ? DartString("") : $otherwise); })()';
        }
        return '(dart_isNull($init) ? DartString("") : $otherwise)';
      }
      if (otherwiseCppType == 'int64_t' || otherwiseCppType == 'double' || otherwiseCppType == 'bool') {
        final defVal = _cppDefaultValue(otherwiseCppType);
        if (varName != null && otherwise.contains(varName)) {
          return '([&]() { $varType $varName = $init; return (dart_isNull($varName) ? $defVal : $otherwise); })()';
        }
        return '(dart_isNull($init) ? $defVal : $otherwise)';
      }
      // 如果 otherwise 返回 AnyPtr，null 分支也需要是 AnyGC* 以避免三元表达式类型歧义
      if (_isAnyPtrResult(otherwise)) {
        // 从 AnyGC* 提取指针： 返回 AnyGC*，然后 static_cast 到目标指针类型
        // 使用 lambda 确保变量在作用域内
        if (varName != null && otherwise.contains(varName)) {
          return '([&]() -> AnyGC* { $varType $varName = $init; if (dart_isNull($varName)) return nullptr; return ($otherwise); })()';
        }
        return '(dart_isNull($init) ? static_cast<AnyGC*>(nullptr) : static_cast<AnyGC*>($otherwise))';
      }
      final nullValue = 'nullptr';
      // 如果 otherwise 引用了 Let 变量，需要包装在 lambda 中声明变量
      if (varName != null && otherwise.contains(varName)) {
        return '([&]() { $varType $varName = $init; return (dart_isNull($varName) ? $nullValue : $otherwise); })()';
      }
      return '(dart_isNull($init) ? $nullValue : $otherwise)';
    } else if (varType == 'DartString') {
      // DartString：可空字符串的 null 表示为空字符串
      final otherwiseResultType = otherwiseExpr != null ? _getExpressionType(otherwiseExpr) : null;
      final otherwiseCppType = otherwiseResultType != null ? _cppType(otherwiseResultType) : '';
      final nullVal = _cppDefaultValue(otherwiseCppType.isNotEmpty ? otherwiseCppType : 'DartString');
      if (varName != null && otherwise.contains(varName)) {
        return '([&]() { $varType $varName = $init; return ($varName.empty() ? $nullVal : $otherwise); })()';
      }
      return '($init.empty() ? $nullVal : $otherwise)';
    } else if (varType == 'int64_t' || varType == 'double' || varType == 'bool') {
      // 基本类型：如果 otherwise 引用了 Let 变量，需要包装在 lambda 中声明变量
      if (varName != null && otherwise.contains(varName)) {
        return '([&]() { $varType $varName = $init; return $otherwise; })()';
      }
      // 基本类型不能为 null，直接返回 otherwise
      return otherwise;
    } else {
      // 其他类型检查 nullptr
      return '(dart_isNull($init) ? $varType{} : $otherwise)';
    }
  }

  // ==========================================================================
  // 语句生成
  // ==========================================================================

  void _emitCppStmt(Statement stmt, StringBuffer buf) {
    if (stmt is Block) {
      for (final s in stmt.statements) {
        _emitCppStmt(s, buf);
      }
    } else if (stmt is ExpressionStatement) {
      final expr = _emitCppExpr(stmt.expression);
      buf.writeln('$_pad$expr;');
    } else if (stmt is ReturnStatement) {
      _emitCppReturn(stmt, buf);
    } else if (stmt is IfStatement) {
      _emitCppIf(stmt, buf);
    } else if (stmt is ForStatement) {
      _emitCppFor(stmt, buf);
    } else if (stmt is ForInStatement) {
      _emitCppForIn(stmt, buf);
    } else if (stmt is WhileStatement) {
      _emitCppWhile(stmt, buf);
    } else if (stmt is DoStatement) {
      _emitCppDoWhile(stmt, buf);
    } else if (stmt is VariableDeclaration) {
      _emitCppVarDecl(stmt, buf);
    } else if (stmt is TryCatch) {
      _emitCppTryCatch(stmt, buf);
    } else if (stmt is TryFinally) {
      _emitCppTryFinally(stmt, buf);
    } else if (stmt is SwitchStatement) {
      _emitCppSwitch(stmt, buf);
    } else if (stmt is BreakStatement) {
      buf.writeln('${_pad}break;');
    } else if (stmt is ContinueSwitchStatement) {
      // ContinueSwitchStatement.target is a SwitchCase reference
      // We emit a goto to the corresponding case label
      final target = stmt.target;
      final switchStmt = target.parent;
      if (switchStmt is SwitchStatement) {
        final caseIndex = switchStmt.cases.indexOf(target);
        buf.writeln('${_pad}goto _sw_case_$caseIndex;');
      } else {
        buf.writeln('${_pad}/* continue switch */;');
      }
    } else if (stmt is LabeledStatement) {
      _emitCppLabeledStatement(stmt, buf);
    } else if (stmt is YieldStatement) {
      var value = _emitCppExpr(stmt.expression);
      // 当生成器元素类型为 AnyGC* 时，需要装箱原始值
      if (_currentGeneratorInnerType == 'AnyGC*') {
        value = '_box($value)';
      }
      buf.writeln('${_pad}_result->_data->_storage.push_back($value);');
    } else if (stmt is FunctionDeclaration) {
      _emitCppFunctionDeclaration(stmt, buf);
    } else if (stmt is EmptyStatement) {
      // 空语句，不生成任何代码
    } else if (stmt is AssertStatement) {
      final cond = _emitCppExpr(stmt.condition);
      // C++ assert 只接受一个 bool 参数，消息忽略（避免 DartString 与 bool 不兼容）
      // Wrap in extra parens to protect commas in template arguments from the macro
      buf.writeln('${_pad}assert(($cond));');
    } else {
      buf.writeln('${_pad}throw DartUnsupportedError("unsupported statement: ${stmt.runtimeType}");');
    }
  }

  void _emitCppReturn(ReturnStatement stmt, StringBuffer buf) {
    if (_isAsyncFunction) {
      _asyncBodyHasReturn = true;
      // async 函数：return expr; → _promise->complete(expr); return _promise;
      if (stmt.expression == null) {
        // void → int: bare return completes with 0
        if (_asyncInnerType == 'int') {
          buf.writeln('${_pad}promise_completeTyped(_promise, 0);');
        } else {
          buf.writeln('${_pad}promise_complete(_promise, nullptr);');
        }
        buf.writeln('${_pad}return _promise;');
      } else {
        final value = _emitCppExpr(stmt.expression!);
        // 包装为 AnyPtr（Promise::complete 接受 AnyPtr）
        final wrappedValue = _wrapValueForPromise(value, stmt.expression!);
        buf.writeln('${_pad}promise_complete(_promise, $wrappedValue);');
        buf.writeln('${_pad}return _promise;');
      }
    } else if (_currentReturnType == 'void') {
      // void 函数：不允许 return expr;，先执行表达式再 return
      if (stmt.expression != null) {
        final value = _emitCppExpr(stmt.expression!);
        if (value.isNotEmpty && value != 'void') {
          buf.writeln('${_pad}$value;');
        }
      }
      buf.writeln('${_pad}return;');
    } else if (stmt.expression == null) {
      buf.writeln('${_pad}return ${_inClosureTrampoline ? _cppDefaultValue(_currentReturnType) : ''};');
    } else {
      var value = _emitCppExpr(stmt.expression!);
      // 如果表达式产生了空结果，尝试检测 this.field 模式
      if (value.isEmpty) {
        final expr = stmt.expression!;
        if (expr is InstanceGet && expr.receiver is VariableGet) {
          final recv = expr.receiver as VariableGet;
          if (recv.variable.name == 'this' || recv.variable.name == '#this') {
            final fieldName = _cleanName(expr.name.text);
            value = 'this_->$fieldName';
          }
        }
        // 最后的后备：如果是 PropertyGet 的子类型
        if (value.isEmpty) {
          value = '/* empty return expr: ${expr.runtimeType} */ this_->value';
        }
      }
      // 如果返回值是 throw 表达式，在 C++ 中 throw 是语句不能作为表达式
      if (value.startsWith('throw ')) {
        buf.writeln('${_pad}$value;');
        buf.writeln('${_pad}return ${_cppDefaultValue(_currentReturnType)};');
        return;
      }
      // 如果当前函数返回类型是 AnyPtr，始终包装返回值
      if (_currentReturnType == 'AnyGC*') {
        final wrappedValue = _wrapIn_box(value, stmt.expression!);
        buf.writeln('${_pad}return $wrappedValue;');
      } else {
        // 如果返回值是 nullptr，需要转换为对应的类型
        if (value == 'nullptr') {
          final defaultValue = _getDefaultValueForType(_currentReturnType);
          buf.writeln('${_pad}return $defaultValue;');
        } else {
          // 检查表达式类型是否为 AnyPtr，但函数返回基本类型，需要解包
          final exprType = _getExpressionType(stmt.expression!);
          final exprCppType = exprType != null ? _cppType(exprType) : '';
          // 如果表达式已经是具体类型（如 Map[] 解引用），不需要解包
          final needsUnwrap = exprCppType == 'AnyGC*' &&
              _currentReturnType != 'AnyGC*' &&
              !_looksLikeConcreteValue(value);
          if (needsUnwrap) {
            if (_currentReturnType == 'int64_t') {
              buf.writeln('${_pad}return dynAs<int64_t>($value);');
            } else if (_currentReturnType == 'double') {
              buf.writeln('${_pad}return dynAs<double>($value);');
            } else if (_currentReturnType == 'bool') {
              buf.writeln('${_pad}return dynAs<bool>($value);');
            } else if (_currentReturnType == 'DartString') {
              buf.writeln('${_pad}return dynAs<DartString>($value);');
            } else if (_isCppTypeParameter(_currentReturnType)) {
              buf.writeln('${_pad}return dynAs<$_currentReturnType>($value);');
            } else {
              buf.writeln('${_pad}return $value;');
            }
          } else {
            // 检查值是否为 AnyPtr（通过表达式类型或 C++ 模式）
            if (_isAnyPtrResult(value) && _currentReturnType != 'AnyGC*') {
              buf.writeln('${_pad}return ${_unwrapFrom_box(value, _currentReturnType)};');
            } else {
              buf.writeln('${_pad}return $value;');
            }
          }
        }
      }
    }
  }

  /// 将值包装为 AnyGC* 以传递给 Promise::complete
  String _wrapValueForPromise(String value, Expression expr) {
    if (value.startsWith('_box(') || value == 'nullptr') {
      return value;
    }
    // fnPtr always returns AnyGC* — if value is dynAs<R>(fnPtrCall), extract fnPtrCall directly
    if (value.startsWith('dynAs<') && value.contains('->fnPtr(')) {
      final firstParen = value.indexOf('(');
      if (firstParen > 0) {
        return value.substring(firstParen + 1, value.length - 1);
      }
    }
    // Raw fnPtr call already returns AnyGC*
    if (value.contains('->fnPtr(') && !value.startsWith('_box(')) {
      final callStart = value.indexOf('->fnPtr(');
      final beforeCall = value.substring(0, callStart);
      if (beforeCall.isEmpty || beforeCall.endsWith(')') || beforeCall.endsWith(']') ||
          beforeCall.contains('static_cast<') || _isValidIdentifier(beforeCall)) {
        return value;
      }
    }
    return '_box($value)';
  }

  /// 根据类型获取默认值
  String _getDefaultValueForType(String cppType) {
    if (cppType == 'DartString') {
      return '""';
    } else if (cppType == 'int64_t') {
      return '0';
    } else if (cppType == 'double') {
      return '0.0';
    } else if (cppType == 'bool') {
      return 'false';
    } else if (cppType.endsWith('*')) {
      return 'nullptr';
    } else {
      return '{}';
    }
  }

  /// 将值包装为 AnyPtr，根据表达式类型选择合适的包装方法
  String _wrapIn_box(String value, Expression expr) {
    if (value.startsWith('_box(') || value.startsWith('GC::allocateLocal(')) return value;
    // fnPtr always returns AnyGC* — if value is dynAs<R>(fnPtrCall), extract fnPtrCall directly
    if (value.startsWith('dynAs<') && value.contains('->fnPtr(')) {
      final firstParen = value.indexOf('(');
      if (firstParen > 0) {
        return value.substring(firstParen + 1, value.length - 1);
      }
    }
    // Raw fnPtr call already returns AnyGC*
    if (value.contains('->fnPtr(') && !value.startsWith('_box(')) {
      final callStart = value.indexOf('->fnPtr(');
      final beforeCall = value.substring(0, callStart);
      // Ensure the entire value is a fnPtr call (not e.g. fnPtr(x) + 1)
      if (beforeCall.isEmpty || beforeCall.endsWith(')') || beforeCall.endsWith(']') ||
          beforeCall.contains('static_cast<') || _isValidIdentifier(beforeCall)) {
        return value;
      }
    }
    if (expr is NullLiteral) return 'nullptr';
    if (expr is VariableGet) return _wrapValueByType(value, expr.variable.type);
    if (expr is StaticInvocation) return _wrapValueByType(value, expr.target.function.returnType);
    if (expr is InstanceInvocation) return _wrapValueByType(value, expr.interfaceTarget.function.returnType);
    if (expr is ConditionalExpression) return _wrapIn_box(value, expr.then);
    return '_box($value)';
  }

  bool _isValidIdentifier(String s) {
    if (s.isEmpty) return false;
    for (final c in s.runes) {
      final isAlpha = (c >= 65 && c <= 90) || (c >= 97 && c <= 122) || c == 95;
      final isDigit = c >= 48 && c <= 57;
      if (!isAlpha && !isDigit) return false;
    }
    return true;
  }

  /// 根据 Dart 类型包装值为 AnyPtr
  String _wrapValueByType(String value, DartType type) {
    if (type is VoidType) return value;
    if (type is InterfaceType && type.classNode.name == 'Null') return 'nullptr';
    return '_box($value)';
  }

  /// 将 AnyGC* 值解包为目标 C++ 类型
  String _unwrapFrom_box(String value, String targetCppType) {
    if (targetCppType == 'int64_t') return 'dynAs<int64_t>($value)';
    if (targetCppType == 'double') return 'dynAs<double>($value)';
    if (targetCppType == 'bool') return 'dynAs<bool>($value)';
    if (targetCppType == 'DartString') return 'dynAs<DartString>($value)';
    if (targetCppType.endsWith('*')) {
      final baseType = targetCppType.substring(0, targetCppType.length - 1);
      // 裸类型参数（如 T*）：使用 toGC() 兼容所有 AnyGC 子类
      if (_isCppTypeParameter(baseType)) {
        return 'reinterpret_cast<AnyGC*>($value)';
      }
      return 'reinterpret_cast<$baseType*>($value)';
    }
    // 裸模板类型参数（如 T, TInput, TOutput）：使用 dynAs 运行时转换
    if (_isCppTypeParameter(targetCppType)) {
      return 'dynAs<$targetCppType>($value)';
    }
    return value;
  }

  /// 仅当值可能是 AnyPtr/AnyGC* 且目标类型是具体类型时才解包
  String _unwrapFromAnyPtrIfNeeded(String value, String targetCppType) {
    if (targetCppType.isEmpty || targetCppType == 'AnyGC*' || targetCppType == 'void') return value;

    // Handle Promise type casting: Promise<T>* → Promise<AnyGC*>*
    if (targetCppType.startsWith('Promise<') && targetCppType.endsWith('>*')) {
      final targetTypeParam = targetCppType.substring(8, targetCppType.length - 2);
      if (targetTypeParam == 'AnyGC*' && (value.startsWith('delayed(') || value.startsWith('delayed<'))) {
        // Cast delayed() result to Promise<AnyGC*>*
        return 'reinterpret_cast<Promise<AnyGC*>*>($value)';
      }
      // General Promise covariance cast: Promise<X>* → Promise<AnyGC*>*
      if (targetTypeParam == 'AnyGC*' && value.startsWith('Promise<') && !value.startsWith('Promise<AnyGC*>')) {
        return 'reinterpret_cast<Promise<AnyGC*>*>($value)';
      }
    }

    // 如果表达式已经是具体类型值，不解包
    if (_looksLikeConcreteValue(value)) return value;
    // 检查值是否可能是 AnyPtr/AnyGC*：模式匹配 或 变量类型查找
    final isAnyGCPtr = _isAnyGCPtrExpr(value);
    final isAnyGCVal = !isAnyGCPtr && (_isAnyPtrExpr(value) || _isAnyGCPtrExpr(value));
    if (!isAnyGCPtr && !isAnyGCVal) return value;
    if (isAnyGCPtr) return _unwrapFromAnyGCPtr(value, targetCppType);
    return _unwrapFrom_box(value, targetCppType);
  }

  /// 检查表达式是否是 AnyGC* 类型（简单变量名为 AnyGC* 类型）
  bool _isAnyGCPtrExpr(String expr) {
    // 检查复杂表达式是否返回 AnyGC*（ClassInfo dispatch 调用、_box、smAwait 等）
    if (_isAnyPtrResult(expr)) return true;
    final cleanName = expr.replaceAll(RegExp(r'^[&*]+'), '').trim();
    final type = _variableTypeMap[cleanName];
    return type == 'AnyGC*';
  }

  /// 将 AnyGC* 表达式拆箱为与 otherOperand 匹配的具体类型（用于比较运算）
  String? _unwrapAnyGCForComparison(String anyGCExpr, String otherOperand) {
    // 根据 otherOperand 的形式推断目标类型
    if (RegExp(r'^-?\d+(LL)?$').hasMatch(otherOperand) || otherOperand.endsWith('LL')) {
      return 'dynAs<int64_t>($anyGCExpr)';
    }
    if (RegExp(r'^-?\d+\.\d+$').hasMatch(otherOperand)) {
      return 'dynAs<double>($anyGCExpr)';
    }
    if (otherOperand.startsWith('DartString(') || otherOperand.startsWith('"')) {
      return 'dynAs<DartString>($anyGCExpr)';
    }
    if (otherOperand == 'true' || otherOperand == 'false') {
      return 'dynAs<bool>($anyGCExpr)';
    }
    // 检查 otherOperand 的变量类型
    final otherType = _variableTypeMap[otherOperand] ?? '';
    if (otherType == 'int64_t') return 'dynAs<int64_t>($anyGCExpr)';
    if (otherType == 'double') return 'dynAs<double>($anyGCExpr)';
    if (otherType == 'DartString') return 'dynAs<DartString>($anyGCExpr)';
    if (otherType == 'bool') return 'dynAs<bool>($anyGCExpr)';
    return null;
  }

  /// 当参数期望 AnyGC* 但实参是基本类型时，自动装箱
  String _cppMaybeBoxForAnyGC(String argExpr, Expression argNode) {
    final argType = _getExpressionType(argNode);
    final argCppType = argType != null ? _cppType(argType) : '';
    if (argCppType == 'int64_t' || RegExp(r'^-?\d+(LL)?$').hasMatch(argExpr)) {
      return 'GC::allocateLocal(new IntBox($argExpr))';
    }
    if (argCppType == 'double' || RegExp(r'^-?\d+\.\d+$').hasMatch(argExpr)) {
      return 'GC::allocateLocal(new DoubleBox($argExpr))';
    }
    if (argCppType == 'bool' || argExpr == 'true' || argExpr == 'false') {
      return 'GC::allocateLocal(new BoolBox($argExpr))';
    }
    if (argCppType == 'DartString' || (argExpr.startsWith('DartString(') && argExpr.endsWith(')'))) {
      return 'GC::allocateLocal(new StringBox($argExpr))';
    }
    if (argExpr == 'nullptr') return 'nullptr';
    if (argCppType.endsWith('*') || argCppType == 'AnyGC*') return argExpr;
    // If the expression already produces a pointer (GC::allocateLocal, new, etc.)
    if (_isPointerTypeExpr(argExpr)) return argExpr;
    return argExpr;
  }

  /// 从 Box 类型中提取字符串值（用于异常构造函数）
  /// 例如：GC::allocateLocal(new StringBox(DartString("msg"))) → DartString("msg")
  String _extractStringFromBox(String args) {
    // 匹配 StringBox
    final stringBoxMatch = RegExp(r'GC::allocateLocal\(new StringBox\((.+)\)\)$').firstMatch(args);
    if (stringBoxMatch != null) {
      return stringBoxMatch.group(1)!;
    }
    // 匹配 IntBox/DoubleBox/BoolBox - 转换为字符串
    final otherBoxMatch = RegExp(r'GC::allocateLocal\(new (Int|Double|Bool)Box\((.+)\)\)$').firstMatch(args);
    if (otherBoxMatch != null) {
      final innerValue = otherBoxMatch.group(2)!;
      return 'std::to_string($innerValue)';
    }
    // 不是 Box 类型，直接返回
    return args;
  }

  /// 检查 C++ 表达式是否产生指针类型值
  bool _isPointerTypeExpr(String expr) {
    if (expr == 'nullptr') return true;
    if (expr.startsWith('new ')) return true;
    if (expr.startsWith('GC::allocateLocal(')) return true;
    if (expr.startsWith('GC::allocate(')) return true;
    if (expr.startsWith('static_cast<') && expr.contains('*>')) return true;
    if (expr.startsWith('reinterpret_cast<') && expr.contains('*>')) return true;
    if (expr.startsWith('dynAs<') && expr.contains('*>')) return true;
    // 检查变量类型
    final type = _variableTypeMap[expr];
    if (type != null && type.endsWith('*')) return true;
    return false;
  }

  /// 从 AnyGC* 解包到目标 C++ 类型
  String _unwrapFromAnyGCPtr(String value, String targetCppType) {
    if (targetCppType == 'int64_t') return 'dynAs<int64_t>($value)';
    if (targetCppType == 'double') return 'dynAs<double>($value)';
    if (targetCppType == 'bool') return 'dynAs<bool>($value)';
    if (targetCppType == 'DartString') return 'dynAs<DartString>($value)';
    if (targetCppType.endsWith('*')) {
      // 对于包含模板参数的类型（如 LinkedNodeValue<T>*），仍然使用 static_cast
      // 因为目标类型与 AnyGC 有继承关系
      final baseType = targetCppType.substring(0, targetCppType.length - 1);
      if (_isCppTypeParameter(baseType)) {
        // 裸类型参数（如 T*）：不能直接 static_cast，使用 reinterpret_cast
        return 'static_cast<$targetCppType>(static_cast<void*>($value))';
      }
      // Skip wrapping if target type contains unresolved type parameters not in scope
      if (_containsUnresolvedTypeParam(targetCppType, _inScopeTypeParams)) {
        return value;
      }
      return 'static_cast<$targetCppType>($value)';
    }
    // 裸模板类型参数（如 T, TInput, TOutput）：使用 dynAs 运行时转换
    if (_isCppTypeParameter(targetCppType)) {
      return 'dynAs<$targetCppType>($value)';
    }
    return value;
  }

  /// 检查 C++ 表达式是否已经产生了具体类型值（非 AnyPtr）
  /// 例如：Map 解引用 `(*(*m)[k])`, 字面量, 已转换的表达式
  bool _looksLikeConcreteValue(String expr) {
    // 已经通过 dynAs<T>(...) 转换的
    if (expr.startsWith('dynAs<')) return true;
    // Map/List 解引用: (*(*map)[key]) 或 (*list)[i]
    if (expr.startsWith('(*(') && expr.endsWith('])')) return true;
    if (expr.startsWith('(*') && expr.endsWith(']')) return true;
    // 字面量
    if (RegExp(r'^-?\d+(\.\d+)?$').hasMatch(expr)) return true;
    if (expr == 'true' || expr == 'false') return true;
    if (expr.startsWith('"') && expr.endsWith('"')) return true;
    // 函数调用返回具体类型（如 static_cast<int64_t>(...)）
    if (expr.startsWith('static_cast<') && expr.contains('>')) return true;
    return false;
  }

  /// 检查表达式是否是直接的 ClassInfo 派发结果（返回 AnyGC*）
  /// 仅匹配 static_cast<XxxClassInfo<...>*>(...->_classInfo)->method(args) 模式
  /// 排除已被 _unboxElem<> / dynAs<> 转换或被进一步 ->method()/->field 访问的表达式
  bool _isDirectClassInfoDispatchResult(String expr) {
    if (expr.startsWith('dynAs<') || expr.startsWith('_unboxElem<')) return false;
    if (!expr.contains('_classInfo')) return false;
    if (!expr.startsWith('static_cast<')) return false;
    int depth = 1;
    int closeIdx = -1;
    for (int i = 11; i < expr.length; i++) {
      if (expr[i] == '<') depth++;
      else if (expr[i] == '>') {
        depth--;
        if (depth == 0) { closeIdx = i; break; }
      }
    }
    if (closeIdx < 0) return false;
    final typeName = expr.substring(11, closeIdx);
    if (!typeName.contains('ClassInfo')) return false;
    final ciIdx = expr.lastIndexOf('_classInfo');
    if (ciIdx < 0) return false;
    final afterCi = expr.substring(ciIdx);
    int pdepth = 0;
    bool foundMethodStart = false;
    for (int i = 0; i < afterCi.length; i++) {
      if (afterCi[i] == '(') { pdepth++; foundMethodStart = true; }
      else if (afterCi[i] == ')') {
        pdepth--;
        if (pdepth == 0 && foundMethodStart) {
          if (i < afterCi.length - 1) {
            final rest = afterCi.substring(i + 1);
            if (rest.contains('->') || rest.contains('.')) return false;
          }
          break;
        }
      }
    }
    return true;
  }

  /// All ClassInfo field names that return raw types (not AnyGC*).
  /// Must match the struct definitions in dart2cpp_lowered.h.
  static const _rawReturnClassInfoFields = {
    // Base ClassInfo
    'eq', 'get_hashCode', 'compareTo', 'get_length',
    'contains', 'containsKey', 'setIndex',
    // StaticListClassInfo
    'get_isEmpty', 'get_isNotEmpty', 'remove', 'any_', 'every_',
    'indexOf', 'lastIndexOf', 'indexWhere', 'lastIndexWhere',
    'removeRange', 'fillRange',
    // StaticSetClassInfo
    'add', // Set.add returns bool (List.add is void, handled separately)
    'containsValue', 'containsAll', 'removeWhere', 'retainWhere', 'clear',
    // StaticIteratorClassInfo
    'moveNext',
    // PromiseBaseClassInfo
    'get_isCompleted', 'get_isError', 'get_isReady', 'get_isPending',
    // StaticDateTimeClassInfo
    'get_isUtc', 'get_year', 'get_month', 'get_day', 'get_hour',
    'get_minute', 'get_second', 'get_millisecond', 'get_weekday',
    'get_millisecondsSinceEpoch', 'get_microsecondsSinceEpoch',
    // StaticDurationClassInfo
    'get_inDays', 'get_inHours', 'get_inMinutes', 'get_inSeconds',
    'get_inMilliseconds',
    // AsyncStateMachineClassInfo
    'step',
  };

  /// Extract the ClassInfo field name from a dispatch expression.
  /// Returns null if the expression is not a ClassInfo dispatch.
  /// Tracks parenthesis depth to find the outermost dispatch in nested expressions.
  String? _extractClassInfoFieldName(String expr) {
    if (!expr.contains('_classInfo')) return null;
    // Find all _classInfo->field( or _classInfo)->field( patterns,
    // return the one at the lowest parenthesis depth (outermost dispatch).
    final pattern = RegExp(r'_classInfo\)?->(\w+)\(');
    String? bestField;
    int bestDepth = 0x7FFFFFFF;
    for (final match in pattern.allMatches(expr)) {
      int depth = 0;
      for (int i = 0; i < match.start; i++) {
        if (expr[i] == '(') depth++;
        else if (expr[i] == ')') depth--;
      }
      if (depth < bestDepth) {
        bestDepth = depth;
        bestField = match.group(1);
      }
    }
    return bestField;
  }

  /// Check if a ClassInfo field returns a raw type (bool/int64_t/void) instead of AnyGC*.
  /// Uses the field name and optional Procedure to determine the return type,
  /// mirroring _vptrWrapReturnType logic. More reliable than _isRawReturnClassInfoDispatch.
  bool _isRawReturnField(String ciField, [Procedure? proc]) {
    // index always returns AnyGC* (returns boxed element)
    if (ciField == 'index') return false;
    // Base ClassInfo fields with fixed return types
    if (_baseClassInfoFieldTypes.containsKey(ciField)) {
      final t = _baseClassInfoFieldTypes[ciField]!;
      return t == 'bool' || t == 'int64_t' || t == 'void';
    }
    // Known collection raw return fields
    if (_rawReturnClassInfoFields.contains(ciField)) return true;
    // User-defined fields: check procedure return type
    if (proc != null) {
      final retType = _cppType(proc.function.returnType);
      if (retType == 'void') return true;
      // Return type is itself a class-level type parameter (method defined in template class)
      if (_isCppTypeParameter(retType)) {
        final enclosingClass = proc.enclosingClass;
        if (enclosingClass != null && enclosingClass.typeParameters.isNotEmpty) {
          final classTypeParamNames = enclosingClass.typeParameters.map((tp) => tp.name ?? 'T').toSet();
          if (classTypeParamNames.contains(retType)) return true;
        }
      }
      // Generic parent inheritance: field returns type parameter or resolved type, not AnyGC*
      if (_getParentTypeParamReturn(proc, proc.name.text) != null) {
        // For concrete classes inheriting from generic parent, resolved type is used
        if (retType == 'int64_t' || retType == 'bool' || retType == 'double' ||
            retType == 'DartString' || (retType.endsWith('*') && retType != 'AnyGC*')) {
          return true;
        }
      }
      if (retType == 'int64_t' || retType == 'bool') {
        return true;
      }
    }
    return false;
  }

  /// Try to resolve the Procedure for a ClassInfo dispatch expression.
  /// Handles patterns like `static_cast<XxxClassInfo<TArgs>*>(...)->method(...)`.
  /// Returns null if the class or method cannot be determined from the expression.
  Procedure? _resolveClassInfoMethodProc(String expr, String fieldName) {
    // Pattern 1: static_cast<XxxClassInfo<TArgs>*>(...)->field(
    final castMatch = RegExp(r'static_cast<([A-Za-z_][A-Za-z0-9_]*ClassInfo)(?:<[^>]*>)?\*>\(')
        .firstMatch(expr);
    if (castMatch != null) {
      final ciClassName = castMatch.group(1)!;
      if (ciClassName == 'ClassInfo') return null;
      final dartClassName = ciClassName.substring(0, ciClassName.length - 'ClassInfo'.length);
      final cls = _classNodes[dartClassName];
      if (cls != null) {
        // Search class and its superclasses for the procedure.
        Class? current = cls;
        while (current != null) {
          for (final p in current.procedures) {
            if (_cleanMethodName(p.name.text) == fieldName) return p;
          }
          current = current.supertype?.classNode;
        }
      }
    }
    return null;
  }

  /// Check if a ClassInfo dispatch expression returns a raw type (bool/int64_t/void)
  /// instead of AnyGC*. Used to avoid unnecessary dynAs wrapping.
  /// Fallback for cases where ciField/proc are not available (uses string parsing).
  bool _isRawReturnClassInfoDispatch(String expr) {
    if (!expr.contains('_classInfo')) return false;
    final fieldName = _extractClassInfoFieldName(expr);
    if (fieldName == null) return false;
    final proc = _resolveClassInfoMethodProc(expr, fieldName);
    if (proc != null) return _isRawReturnField(fieldName, proc);
    return _isRawReturnField(fieldName);
  }

  /// 检查 C++ 表达式是否返回 AnyGC* 类型（基于字符串模式）
  bool _isAnyPtrResult(String expr) {
    // 如果表达式已经通过 dynAs<T>(...) 转换为具体类型，不再是 AnyGC*
    if (expr.startsWith('dynAs<')) {
      return false;
    }
    // Raw-returning ClassInfo dispatch (get_length→int64_t, contains→bool, etc.)
    // returns raw types, not AnyGC*
    if (_isRawReturnClassInfoDispatch(expr)) return false;
    if (expr.startsWith("static_cast<") && expr.contains("_classInfo)->")) return true;  // ClassInfo vptr dispatch (handles both ->_classInfo and AnyGC::_classInfo)
    if (expr.startsWith("(static_cast<ClassInfo*>")) return true;  // ClassInfo dispatch
    // ClassInfo function-pointer dispatch via AnyGC*->_classInfo->method(...) returns AnyGC*
    if (expr.startsWith('static_cast<AnyGC*>(') && expr.contains('_classInfo->')) return true;
    // iterator_current / iterator_moveNext dispatch via ClassInfo returns AnyGC*
    if (expr.startsWith('iterator_current(')) return true;
    if (expr.startsWith('_box(')) return true;
    if (expr == 'nullptr') return true;
    // smAwait<AnyGC*> returns AnyGC*, but smAwait<T> returns T
    if (expr.startsWith('smAwait<AnyGC*>') || expr.startsWith('smAwait(')) return true;
    // Promise/CompleterState 的 .result 和 .error 字段是 AnyGC*
    if (expr.endsWith('->result') || expr.endsWith('.result')) return true;
    if (expr.endsWith('->error') || expr.endsWith('.error')) return true;
    // IIFE from null-check pattern: ([&]() { ... return (... dart_isNull ? nullptr : ...); })()
    if (expr.startsWith('([&]') && expr.contains('nullptr ? nullptr')) {
      return true;
    }
    // Map access 返回类型取决于值类型：
    // - 值类型 (int64_t, string): (*(*map)[key]) — 直接返回值，不是 AnyPtr
    // - 指针类型 (AnyGC*, StaticList<...>*): _box(*(*map)[key]) — 被 AnyPtr::from 捕获
    // 不再需要 (*(* 模式检测
    return false;
  }

  /// 判断表达式是否是类型擦除的集合模板方法结果（map/expand/cast/whereType）。
  /// 这些方法通过 ClassInfo 派发返回 StaticList/Set/Map<AnyGC*, ...>*，
  /// 不应该再 static_cast 到具体的 StaticList<T>* 类型。
  bool _isTypeErasedCollectionResult(String expr) {
    // 匹配 ...ClassInfo<...>->map(...) / ->expand(...) / ->cast_(...) / ->whereType(...)
    final dispatchPattern = RegExp(r'_classInfo\)->(map|expand|cast_|whereType)\(');
    return dispatchPattern.hasMatch(expr);
  }

  /// 将 AnyPtr/AnyGC* 接收器转换为真实类型（仿照 Dart 的 dynamic dispatch）
  /// 如果接收器已经是真实类型，直接返回
  String _castReceiverToType(String receiver, DartType? expectedType) {
    if (expectedType == null) return receiver;
    if (!_isAnyPtrResult(receiver)) return receiver;

    final cppType = _cppType(expectedType);
    if (cppType == 'AnyGC*' || cppType.isEmpty) return receiver;

    // 基本类型 — 使用 dynAs<T>() 拆箱（支持 AnyGC* 接收器）
    if (cppType == 'int64_t') return 'dynAs<int64_t>($receiver)';
    if (cppType == 'double') return 'dynAs<double>($receiver)';
    if (cppType == 'bool') return 'dynAs<bool>($receiver)';
    if (cppType == 'DartString') return 'dynAs<DartString>($receiver)';

    // 指针类型（集合、用户类等）— 使用 static_cast 向下转型
    // 需要先将 AnyGC* 转换为 AnyGC*，再 static_cast 到目标类型
    if (cppType.endsWith('*')) {
      final baseType = cppType.substring(0, cppType.length - 1);
      // 裸类型参数（如 T*）：需要通过 void* 中间转换
      if (_isCppTypeParameter(baseType)) {
        return 'static_cast<$baseType*>(static_cast<void*>($receiver))';
      }
      // 模板类型包含未解析的类型参数（如 PipelineValue<TInput, TNewOutput>）：
      // 如果类型参数不在当前作用域内，无法使用该类型，回退到 AnyGC* 以保留派发能力
      if (_containsTypeParameter(cppType) && _hasOutOfScopeTypeParam(cppType)) {
        return 'static_cast<AnyGC*>($receiver)';
      }
      // Collection template methods (map/expand/cast/whereType) return type-erased
      // StaticList<AnyGC*>* / StaticSet<AnyGC*>* / StaticMap<AnyGC*,AnyGC*>*.
      // Casting that to a specific StaticList<T>* is invalid; leave as AnyGC*.
      if (_isTypeErasedCollectionResult(receiver)) {
        return 'static_cast<AnyGC*>($receiver)';
      }
      return 'static_cast<$baseType*>($receiver)';
    }

    return receiver;
  }

  void _emitCppIf(IfStatement stmt, StringBuffer buf) {
    // 检测 is 检查条件，添加类型提升
    final savedPromotions = Map<String, DartType>.from(_typePromotions);
    _extractTypePromotion(stmt.condition);

    final cond = _emitCppExpr(stmt.condition);
    buf.writeln('${_pad}if ($cond) {');
    _indent++;
    _emitCppStmt(stmt.then, buf);
    _indent--;
    // 恢复类型提升状态
    _typePromotions.clear();
    _typePromotions.addAll(savedPromotions);

    if (stmt.otherwise != null) {
      buf.writeln('${_pad}} else {');
      _indent++;
      _emitCppStmt(stmt.otherwise!, buf);
      _indent--;
    }
    buf.writeln('$_pad}');
  }

  /// 从 is 检查条件中提取类型提升信息
  void _extractTypePromotion(Expression cond) {
    if (cond is IsExpression) {
      final operand = cond.operand;
      if (operand is VariableGet) {
        final varName = _cleanName(operand.variable.name ?? 'v');
        _typePromotions[varName] = cond.type;
      }
    } else if (cond is LogicalExpression) {
      // 处理 && 连接的多个 is 检查
      _extractTypePromotion(cond.left);
      _extractTypePromotion(cond.right);
    }
  }

  void _emitCppFor(ForStatement stmt, StringBuffer buf) {
    for (final v in stmt.variables) {
      _emitCppVarDecl(v, buf);
    }
    final cond = stmt.condition != null ? _emitCppExpr(stmt.condition!) : 'true';
    final updates = stmt.updates.map((u) => _emitCppExpr(u)).join(', ');

    buf.writeln('${_pad}while ($cond) {');
    _indent++;
    _emitCppStmt(stmt.body, buf);
    if (updates.isNotEmpty) {
      buf.writeln('${_pad}$updates;');
    }
    _indent--;
    buf.writeln('$_pad}');
  }

  void _emitCppForIn(ForInStatement stmt, StringBuffer buf) {
    final varName = _cleanName(stmt.variable.name ?? 'item');
    final iterable = _emitCppExpr(stmt.iterable);

    // 使用固定的迭代器变量名，添加计数器以避免冲突
    final iterVarBase = 'sync_for_iterator';
    String iterVar = iterVarBase;
    int iterSuffix = 0;
    while (_declaredVariables.contains(iterVar)) {
      iterVar = '${iterVarBase}_${iterSuffix++}';
    }
    _declaredVariables.add(iterVar);

    // 获取迭代器类型
    final iterableType = _getExpressionType(stmt.iterable);
    String iteratorType = 'auto';
    if (iterableType is InterfaceType) {
      final typeName = iterableType.classNode.name;
      if (typeName == 'List' || typeName == 'StaticList') {
        final elemType = iterableType.typeArguments.isNotEmpty
            ? _cppType(iterableType.typeArguments.first)
            : 'AnyGC*';
        iteratorType = 'StaticIterator<$elemType>*';
      }
    }

    buf.writeln('${_pad}AnyGC* $iterVar = static_cast<AnyGC*>($iterable)->AnyGC::_classInfo->get_iterator(static_cast<AnyGC*>($iterable));');
    buf.writeln('${_pad}while (iterator_moveNext($iterVar)) {');
    _indent++;

    final varType = _cppType(stmt.variable.type);
    if (varType == 'AnyGC*') {
      buf.writeln('${_pad}$varType $varName = iterator_current($iterVar);');
    } else {
      buf.writeln('${_pad}$varType $varName = dynAs<$varType>(iterator_current($iterVar));');
    }

    // 设置映射供体内使用
    final savedIterVarMapping = _variableNameMappings[iterVarBase];
    _variableNameMappings[iterVarBase] = iterVar;

    _emitCppStmt(stmt.body, buf);

    // 恢复映射
    if (savedIterVarMapping != null) {
      _variableNameMappings[iterVarBase] = savedIterVarMapping;
    } else {
      _variableNameMappings.remove(iterVarBase);
    }

    _indent--;
    buf.writeln('$_pad}');
  }

  void _emitCppWhile(WhileStatement stmt, StringBuffer buf) {
    final cond = _emitCppExpr(stmt.condition);
    buf.writeln('${_pad}while ($cond) {');
    _indent++;
    _emitCppStmt(stmt.body, buf);
    _indent--;
    buf.writeln('$_pad}');
  }

  void _emitCppDoWhile(DoStatement stmt, StringBuffer buf) {
    buf.writeln('${_pad}do {');
    _indent++;
    _emitCppStmt(stmt.body, buf);
    _indent--;
    final cond = _emitCppExpr(stmt.condition);
    buf.writeln('${_pad}} while ($cond);');
  }

  void _emitCppVarDecl(VariableDeclaration stmt, StringBuffer buf) {
    final name = stmt.name;
    String varName;
    String? originalName;
    if (name == null || name.isEmpty) {
      varName = '_var${_varCounter++}';
      // 为 null 命名的变量记录映射，以便后续引用可以找到它
      _nullNamedVarMap[stmt] = varName;
    } else {
      originalName = name;  // 保存原始名称（在清理之前）
      varName = _cleanName(name);
      // 检查变量名是否已经存在于当前作用域
      // 如果存在，添加后缀以避免冲突
      if (_declaredVariables.contains(varName)) {
        varName = '${varName}_${_varCounter++}';
      }
      _declaredVariables.add(varName);
      // 记录 VariableDeclaration 到实际名称的映射
      _varDeclNameMap[stmt] = varName;
      // 记录重命名映射（原始名 → 实际名）
      if (originalName != varName) {
        _variableNameMappings[originalName] = varName;
      }
    }
    final varType = _cppType(stmt.type);
    // 记录变量类型
    _variableTypeMap[varName] = varType;

    // Box 化变量：声明为 Box 指针（Box 构造函数内部已注册 GC）
    if (_boxedVars.contains(stmt)) {
      final boxType = _cppBoxTypeName(stmt.type)!;
      if (stmt.initializer != null) {
        final init = _emitCppExpr(stmt.initializer!);
        final wrappedInit = _wrapToType(init, varType, stmt.initializer!);
        buf.writeln('${_pad}$boxType* $varName = new $boxType($wrappedInit);');
      } else {
        final defVal = _cppDefaultValue(varType);
        buf.writeln('${_pad}$boxType* $varName = new $boxType($defVal);');
      }
      return;
    }

    if (stmt.initializer != null) {
      // 如果初始化器是 MapLiteral，设置期望的键值类型
      String? savedMapKeyType;
      String? savedMapValueType;
      if (stmt.initializer is MapLiteral && stmt.type is InterfaceType) {
        final mapType = stmt.type as InterfaceType;
        if (mapType.typeArguments.length >= 2) {
          savedMapKeyType = _expectedMapKeyType;
          savedMapValueType = _expectedMapValueType;
          _expectedMapKeyType = _cppType(mapType.typeArguments[0]);
          _expectedMapValueType = _cppType(mapType.typeArguments[1]);
        }
      }
      final init = _emitCppExpr(stmt.initializer!);
      final wrappedInit = _wrapToType(init, varType, stmt.initializer!);
      // 恢复期望的类型
      if (savedMapKeyType != null || savedMapValueType != null) {
        _expectedMapKeyType = savedMapKeyType;
        _expectedMapValueType = savedMapValueType;
      }
      buf.writeln('${_pad}$varType $varName = $wrappedInit;');
    } else {
      final defaultVal = _cppDefaultValue(varType);
      buf.writeln('${_pad}$varType $varName\{$defaultVal\};');
    }
  }

  void _emitCppTryCatch(TryCatch stmt, StringBuffer buf) {
    buf.writeln('${_pad}try {');
    _indent++;
    _emitCppStmt(stmt.body, buf);
    _indent--;

    for (final c in stmt.catches) {
      final exName = c.exception != null ? _cleanName(c.exception!.name ?? 'e') : '_e';
      // Check if there's a guard type (typed catch)
      final guardType = c.guard;
      final cppCatchType = _cppCatchType(guardType);
      buf.writeln('${_pad}} catch (const $cppCatchType& $exName) {');
      _indent++;
      // 记录异常变量
      _catchExceptionVars.add(exName);
      // 生成 catch 体到临时缓冲区，然后将 exName-> 替换为 exName.
      // （catch by reference 使用 . 而非 ->）
      final catchBuf = StringBuffer();
      _emitCppStmt(c.body, catchBuf);
      _catchExceptionVars.remove(exName);
      var catchCode = catchBuf.toString();
      // 替换 exName-> 为 exName.（使用正则确保只匹配完整变量名，避免误替换 _promise-> 等）
      catchCode = catchCode.replaceAllMapped(
        RegExp('(?<![a-zA-Z0-9_])${RegExp.escape(exName)}->'),
        (m) => '$exName.',
      );
      // 也替换其他可能的异常变量名（使用正则确保只匹配完整变量名）
      for (final altName in ['e', '_e']) {
        if (altName != exName) {
          catchCode = catchCode.replaceAllMapped(
            RegExp('(?<![a-zA-Z0-9_])${RegExp.escape(altName)}->'),
            (m) => '$altName.',
          );
        }
      }
      // DartException 继承 std::exception（不是 AnyGC），无法 static_cast 到用户类型指针
      // 将 static_cast<UserType*>(exName) 替换为 nullptr（原始异常对象在字符串化时已丢失）
      for (final name in [exName, ...(['e', '_e']..remove(exName))]) {
        catchCode = catchCode.replaceAllMapped(
          RegExp(r'static_cast<(\w+Value\*|AnyGC\*)>\(' + RegExp.escape(name) + r'\)'),
          (m) => 'nullptr',
        );
        // 修复 nullptr->_classInfo 导致的编译错误：
        // 将 ClassInfo dispatch 的 toString 调用替换为 exName.message
        catchCode = catchCode.replaceAllMapped(
          RegExp(r'\(static_cast<\w+ClassInfo\*>\(nullptr->(?:AnyGC::)?_classInfo\)->toString\)\(' + RegExp.escape(name) + r'\)'),
          (m) => '$name.message',
        );
        // 也处理直接使用 nullptr-> 的其他情况（替换为异常对象的 message 访问）
        catchCode = catchCode.replaceAll('nullptr->AnyGC::_classInfo', '$name._classInfo');
        catchCode = catchCode.replaceAll('nullptr->_classInfo', '$name._classInfo');
      }
      buf.write(catchCode);
      _indent--;
    }
    buf.writeln('$_pad}');
  }

  /// 将 Dart 异常类型映射为 C++ catch 类型
  String _cppCatchType(DartType? type) {
    if (type == null) return 'DartException';
    if (type is DynamicType) return 'DartException';
    if (type is InterfaceType) {
      final name = type.classNode.name;
      const exceptionMap = {
        'ArgumentError': 'DartArgumentError',
        'StateError': 'DartStateError',
        'RangeError': 'DartRangeError',
        'FormatException': 'DartFormatException',
        'UnsupportedError': 'DartUnsupportedError',
        'UnimplementedError': 'DartUnimplementedError',
        'Exception': 'DartException',
        'Error': 'DartException',
        'Object': 'DartException',
      };
      if (exceptionMap.containsKey(name)) return exceptionMap[name]!;
      // 检查是否继承自 Exception 或 Error
      final superCls = type.classNode.superclass;
      if (superCls != null) {
        final superName = superCls.name;
        if (superName == 'Exception' || superName == 'Error' ||
            superName == 'DartException') {
          return 'DartException';
        }
      }
    }
    return 'DartException';
  }

  void _emitCppTryFinally(TryFinally stmt, StringBuffer buf) {
    // TryFinally can wrap a TryCatch or a plain body
    final body = stmt.body;
    buf.writeln('${_pad}try {');
    _indent++;
    if (body is TryCatch) {
      _emitCppStmt(body.body, buf);
      _indent--;
      for (final c in body.catches) {
        final exName = c.exception != null ? _cleanName(c.exception!.name ?? 'e') : '_e';
        buf.writeln('${_pad}} catch (const DartException& $exName) {');
        _indent++;
        // 记录异常变量，以便在动态派发中使用直接调用
        _catchExceptionVars.add(exName);
        // 生成 catch 体到临时缓冲区，替换 -> 为 .
        final catchBuf = StringBuffer();
        _emitCppStmt(c.body, catchBuf);
        _catchExceptionVars.remove(exName);
        var catchCode = catchBuf.toString();
        catchCode = catchCode.replaceAllMapped(
          RegExp('(?<![a-zA-Z0-9_])${RegExp.escape(exName)}->'),
          (m) => '$exName.',
        );
        for (final altName in ['e', '_e']) {
          if (altName != exName) {
            catchCode = catchCode.replaceAllMapped(
              RegExp('(?<![a-zA-Z0-9_])${RegExp.escape(altName)}->'),
              (m) => '$altName.',
            );
          }
        }
        buf.write(catchCode);
        _indent--;
      }
    } else {
      _emitCppStmt(body, buf);
      _indent--;
    }
    buf.writeln('${_pad}}');
    // finally block
    buf.writeln('${_pad}// finally');
    _emitCppStmt(stmt.finalizer, buf);
  }

  void _emitCppLabeledStatement(LabeledStatement stmt, StringBuffer buf) {
    final labelId = _varCounter++;
    buf.writeln('${_pad}_L$labelId:');
    // 如果 body 不是循环，包装为 do { } while(false) 以支持 break label
    if (!_isCppLoopStatement(stmt.body)) {
      buf.writeln('${_pad}do {');
      _indent++;
      _emitCppStmt(stmt.body, buf);
      _indent--;
      buf.writeln('${_pad}} while (false);');
    } else {
      _emitCppStmt(stmt.body, buf);
    }
  }

  bool _isCppLoopStatement(Statement stmt) {
    return stmt is ForStatement ||
        stmt is ForInStatement ||
        stmt is WhileStatement ||
        stmt is DoStatement;
  }

  void _emitCppFunctionDeclaration(FunctionDeclaration stmt, StringBuffer buf) {
    final funcName = _cleanName(stmt.variable.name ?? '_localFunc');
    final func = stmt.function;

    // 预分析 Box 化变量
    _preanalyzeCppBoxedVars(func);

    // 生成参数列表
    final params = func.positionalParameters.map((p) {
      final pType = _cppType(p.type);
      final pName = _cleanName(p.name ?? 'p');
      return '$pType $pName';
    }).join(', ');

    final retType = _cppType(func.returnType);

    // 使用 std::function 以支持递归本地函数（auto 不支持自引用）
    final paramTypes = func.positionalParameters.map((p) => _cppType(p.type)).join(', ');
    final stdFuncType = paramTypes.isEmpty
        ? 'std::function<$retType()>'
        : 'std::function<$retType($paramTypes)>';

    buf.writeln('${_pad}$stdFuncType $funcName = [&]($params) -> $retType {');
    _indent++;
    // 保存并清除 async 标志（本地函数本身不是 async）
    final savedIsAsync = _isAsyncFunction;
    final savedReturnType = _currentReturnType;
    final savedInScopeTypeParams = _inScopeTypeParams;
    _isAsyncFunction = false;
    _currentReturnType = retType;
    if (func.body != null) {
      _emitCppStmt(func.body!, buf);
    }
    _isAsyncFunction = savedIsAsync;
    _currentReturnType = savedReturnType;
    _inScopeTypeParams = savedInScopeTypeParams;
    _indent--;
    buf.writeln('${_pad}};');
  }

  void _emitCppSwitch(SwitchStatement stmt, StringBuffer buf) {
    final expr = _emitCppExpr(stmt.expression);
    // 检测是否在枚举类型上 switch — C++ switch 需要整型表达式
    final isEnumSwitch = _isEnumExpression(stmt.expression);
    // 检测是否在字符串类型上 switch — C++ 不支持 switch on DartString
    final isStringSwitch = _isStringExpression(stmt.expression);

    if (isStringSwitch) {
      // 将 string switch 转换为 if-else 链
      final varName = '_sw${_varCounter++}';
      buf.writeln('${_pad}const DartString& $varName = $expr;');
      bool first = true;
      for (int i = 0; i < stmt.cases.length; i++) {
        final c = stmt.cases[i];
        buf.write(_pad);
        if (c.isDefault) {
          if (!first) buf.write('else ');
          buf.writeln('{');
        } else {
          if (!first) buf.write('else ');
          // 生成条件：varName == case1 || varName == case2 || ...
          final conditions = <String>[];
          for (final e in c.expressions) {
            final caseExpr = _emitCppExpr(e);
            conditions.add('$varName == $caseExpr');
          }
          buf.writeln('if (${conditions.join(' || ')}) {');
        }
        _indent++;
        _emitCppStmt(c.body, buf);
        _indent--;
        buf.writeln('${_pad}}');
        first = false;
      }
      return;
    }

    final switchExpr = isEnumSwitch ? '$expr->_index' : expr;
    buf.writeln('${_pad}switch ($switchExpr) {');
    _indent++;

    for (int i = 0; i < stmt.cases.length; i++) {
      final c = stmt.cases[i];
      // 为每个 case 生成标签，供 ContinueSwitchStatement 的 goto 跳转
      buf.writeln('${_pad}_sw_case_$i:');
      if (c.isDefault) {
        buf.writeln('${_pad}default: {');
      } else {
        // 生成实际的 case 表达式
        for (final e in c.expressions) {
          final caseExpr = _emitCppExpr(e);
          // 枚举 case 标签：使用字面量索引值（C++ 需要编译期常量）
          String caseValue;
          if (isEnumSwitch) {
            final idx = _getEnumConstantIndex(e);
            caseValue = idx != null ? '$idx' : '$caseExpr->_index';
          } else {
            caseValue = caseExpr;
          }
          buf.writeln('${_pad}case $caseValue:');
        }
        buf.writeln('${_pad}{');
      }
      _indent++;
      _emitCppStmt(c.body, buf);
      buf.writeln('${_pad}break;');
      _indent--;
      buf.writeln('$_pad}');
    }

    _indent--;
    buf.writeln('$_pad}');
  }

  /// 检测表达式是否为枚举类型
  bool _isEnumExpression(Expression expr) {
    DartType? type;
    if (expr is VariableGet) {
      type = expr.variable.type;
    } else if (expr is InstanceGet) {
      type = expr.interfaceTarget.getterType;
    } else if (expr is ThisExpression) {
      // switch(this) in enum method — check current class context
      return _enumNames.contains(_currentClassName);
    }
    if (type is InterfaceType) {
      final name = type.classNode.name;
      if (_enumNames.contains(name)) return true;
      // 检查父类是否为 Enum
      final superCls = type.classNode.superclass;
      if (superCls != null && (superCls.name == '_Enum' || superCls.name == 'Enum')) {
        return true;
      }
    }
    return false;
  }

  /// 检测表达式是否为字符串类型（用于 switch 转 if-else）
  bool _isStringExpression(Expression expr) {
    DartType? type;
    if (expr is VariableGet) {
      type = expr.variable.type;
    } else if (expr is InstanceGet) {
      type = expr.interfaceTarget.getterType;
    }
    if (type is InterfaceType) {
      final name = type.classNode.name;
      return name == 'String';
    }
    return false;
  }

  /// 获取枚举常量的索引值（用于 switch case 标签）
  int? _getEnumConstantIndex(Expression expr) {
    if (expr is ConstantExpression) {
      final constant = expr.constant;
      if (constant is InstanceConstant) {
        // Enum constants are InstanceConstant with an index field
        // (field name is 'index' in kernel, not '_index')
        for (final entry in constant.fieldValues.entries) {
          final field = entry.key.node;
          if (field is Field && field.name.text == 'index' && entry.value is IntConstant) {
            return (entry.value as IntConstant).value;
          }
        }
      } else if (constant is IntConstant) {
        return constant.value;
      }
    }
    // StaticGet 访问枚举常量：Direction.north
    if (expr is StaticGet) {
      final target = expr.target;
      if (target is Field) {
        final cls = target.enclosingClass;
        final fieldName = target.name.text;
        if (cls != null) {
          final key = '${cls.name}.$fieldName';
          return _enumConstantIndices[key];
        }
      }
    }
    return null;
  }

  // ==========================================================================
  // 常量生成
  // ==========================================================================

  /// 将常量值装箱为 AnyGC*（用于 StaticList<AnyGC*> / StaticSet<AnyGC*> 的元素）
  String _boxConstantForAnyGC(String elemStr, Constant constant) {
    if (constant is IntConstant) return '_box(${constant.value}LL)';
    if (constant is DoubleConstant) return '_box($elemStr)';
    if (constant is BoolConstant) return '_box($elemStr)';
    if (constant is StringConstant) return '_box($elemStr)';
    if (constant is NullConstant) return 'nullptr';
    // 已经是指针类型的常量（ListConstant、InstanceConstant 等）不需要装箱
    return elemStr;
  }

  String _emitCppConstant(Constant constant) {
    if (constant is IntConstant) return constant.value.toString();
    if (constant is DoubleConstant) {
      final val = constant.value.toString();
      return val.contains('.') ? val : '$val.0';
    }
    if (constant is BoolConstant) return constant.value ? 'true' : 'false';
    if (constant is StringConstant) return _cppStringLiteral(constant.value);
    if (constant is NullConstant) return 'nullptr';
    if (constant is ListConstant) {
      final inner = constant.typeArgument != null ? _cppType(constant.typeArgument!) : 'AnyGC*';
      if (constant.entries.isEmpty) {
        return 'GC::allocateLocal(new StaticList<$inner>())';
      }
      final elements = constant.entries.map((e) {
        var elemStr = _emitCppConstant(e);
        if (inner == 'AnyGC*') {
          elemStr = _boxConstantForAnyGC(elemStr, e);
        }
        return elemStr;
      }).join(', ');
      return 'GC::allocateLocal(new StaticList<$inner>({$elements}))';
    }
    if (constant is MapConstant) {
      final keyType = constant.keyType != null ? _cppType(constant.keyType!) : 'AnyGC*';
      final valType = constant.valueType != null ? _cppType(constant.valueType!) : 'AnyGC*';
      return 'GC::allocateLocal(new StaticMap<$keyType, $valType>())';
    }
    if (constant is SetConstant) {
      final inner = constant.typeArgument != null ? _cppType(constant.typeArgument!) : 'AnyGC*';
      if (constant.entries.isEmpty) return 'GC::allocateLocal(new StaticSet<$inner>())';
      final elements = constant.entries.map((e) {
        var elemStr = _emitCppConstant(e);
        if (inner == 'AnyGC*') {
          elemStr = _boxConstantForAnyGC(elemStr, e);
        }
        return elemStr;
      }).join(', ');
      return 'GC::allocateLocal(new StaticSet<$inner>({$elements}))';
    }
    if (constant is InstanceConstant) {
      final className = _cleanName(constant.classNode.name);
      // 检查是否是 enum 值（superclass 是 _Enum 或 Enum）
      final superClass = constant.classNode.superclass;
      if (superClass != null && (superClass.name == '_Enum' || superClass.name == 'Enum')) {
        // 枚举常量：EnumName::value
        // 查找 fieldValues 中的 _name 字段来获取枚举值名称
        String enumValueName = '';
        for (final entry in constant.fieldValues.entries) {
          final fieldName = entry.key.asField.name.text;
          if (fieldName == '_name' && entry.value is StringConstant) {
            enumValueName = (entry.value as StringConstant).value;
            break;
          }
        }
        if (enumValueName.isNotEmpty) {
          return '${className}::$enumValueName';
        }
        // fallback: 使用 fieldValues 中的 index
        for (final entry in constant.fieldValues.entries) {
          final fieldName = entry.key.asField.name.text;
          if (fieldName == '_index' && entry.value is IntConstant) {
            return '${className}::values[${(entry.value as IntConstant).value}]';
          }
        }
      }
      // 其他 InstanceConstant（如 Duration 等）
      if (className == 'Duration') {
        return 'StaticDuration()';
      }
      // 用户自定义类的 const 构造函数：生成 IIFE 初始化
      final structName = _isRuntimeClassName(className) ? className : '${className}Value';
      final typeParams = constant.classNode.typeParameters;
      String templateArgs = '';
      if (typeParams.isNotEmpty) {
        if (constant.typeArguments.isNotEmpty) {
          templateArgs = '<${constant.typeArguments.map((t) => _cppType(t)).join(', ')}>';
        } else {
          templateArgs = '<${typeParams.map((tp) => tp.name ?? 'T').join(', ')}>';
        }
      }
      // 收集字段赋值
      final fieldAssignments = <String>[];
      // 构建类型参数映射（用于泛型字段类型替换）
      final typeParamSubst = <String, String>{};
      if (typeParams.isNotEmpty && constant.typeArguments.isNotEmpty) {
        for (var ti = 0; ti < typeParams.length && ti < constant.typeArguments.length; ti++) {
          typeParamSubst[typeParams[ti].name ?? 'T'] = _cppType(constant.typeArguments[ti]);
        }
      }
      for (final entry in constant.fieldValues.entries) {
        final fieldName = _cleanName(entry.key.asField.name.text);
        var fieldValue = _emitCppConstant(entry.value);
        // 获取字段的 C++ 类型，用于 null 值转换
        var fieldCppType = _cppType(entry.key.asField.type);
        // 替换泛型类型参数
        for (final sub in typeParamSubst.entries) {
          fieldCppType = fieldCppType.replaceAll(RegExp('\\b${sub.key}\\b'), sub.value);
        }
        // 转换 null 值
        fieldValue = _convertNullToType(fieldValue, fieldCppType);
        fieldAssignments.add('_obj->$fieldName = $fieldValue');
      }
      final assignStmts = fieldAssignments.isNotEmpty ? ' ${fieldAssignments.join('; ')};' : '';
      final ciInit = ' _obj->AnyGC::_classInfo = &$structName$templateArgs::_classInfo;';
      return '([&]() { auto* _obj = GC::allocateLocal(new $structName$templateArgs());$ciInit$assignStmts return _obj; })()';
    }
    if (constant is StaticTearOffConstant) {
      final target = constant.target;
      final funcName = target.name.text;
      final function = target.function;

      // Generate a closure struct that inherits from TypeFunctionN
      final params = function.positionalParameters;
      final returnType = _cppType(function.returnType);
      final paramTypes = params.map((p) => _cppType(p.type)).toList();

      // Build TypeFunction base class
      String typeFunctionBase;
      if (paramTypes.isEmpty) {
        typeFunctionBase = 'TypeFunction0<$returnType>';
      } else {
        typeFunctionBase = 'TypeFunction${paramTypes.length}<$returnType, ${paramTypes.join(', ')}>';
      }

      // Build parameter list for call method
      final callParams = <String>[];
      final callArgs = <String>[];
      for (var i = 0; i < params.length; i++) {
        final param = params[i];
        final paramName = param.name ?? 'arg$i';
        final paramType = paramTypes[i];
        callParams.add('$paramType $paramName');
        callArgs.add(paramName);
      }

      // Determine the function to call
      String callTarget;
      if (funcName == 'print') {
        callTarget = 'staticPrint';
      } else {
        callTarget = _cleanName(funcName);
      }

      // Generate closure struct with trampoline + fnPtr
      final closureId = _closureCounter++;
      final closureName = 'TearOff_$closureId';
      final argsStr = callArgs.join(', ');

      // Build typed trampoline params (concrete types with actual names)
      final typedTrampParams = <String>['AnyGC* _env'];
      for (var i = 0; i < params.length; i++) {
        final paramName = params[i].name ?? 'arg$i';
        final paramType = paramTypes[i];
        typedTrampParams.add('$paramType $paramName');
      }

      // 擦除 trampoline 参数：统一 AnyGC*，与 TypeFunctionN::FnPtr 一致
      final erasedTrampParams = <String>['AnyGC* _env'];
      final erasedUnbox = StringBuffer();
      for (var i = 0; i < params.length; i++) {
        final paramName = params[i].name ?? 'arg$i';
        final paramType = paramTypes[i];
        erasedTrampParams.add('AnyGC* _arg$i');
        if (paramType == 'AnyGC*' || paramType.endsWith('*')) {
          erasedUnbox.writeln('        $paramType $paramName = static_cast<$paramType>(_arg$i);');
        } else {
          erasedUnbox.writeln('        $paramType $paramName = dynAs<$paramType>(_arg$i);');
        }
      }

      String typedCallBody;
      if (returnType == 'void') {
        typedCallBody = '$callTarget($argsStr);';
      } else {
        typedCallBody = 'return $callTarget($argsStr);';
      }

      // 擦除 trampoline 为纯转发：拆箱 → 委托 _typedTrampoline → 装箱
      final tearOffArgNames = <String>[];
      for (var i = 0; i < params.length; i++) {
        tearOffArgNames.add(params[i].name ?? 'arg$i');
      }
      final tearOffDelegateArgs = tearOffArgNames.isEmpty ? '' : ', ${tearOffArgNames.join(', ')}';
      final tearOffDelegate = '_typedTrampoline(_env$tearOffDelegateArgs)';
      String erasedCallBody;
      if (returnType == 'void') {
        erasedCallBody = '$tearOffDelegate; return nullptr;';
      } else {
        erasedCallBody = 'return _box($tearOffDelegate);';
      }

      // Emit the closure struct to _structBuf
      _structBuf.writeln('struct $closureName : $typeFunctionBase {');
      _structBuf.writeln('    $closureName() {');
      _structBuf.writeln('        this->fnPtr = &_trampoline;');
      _structBuf.writeln('        this->typedFnPtr = &_typedTrampoline;');
      _structBuf.writeln('    }');
      _structBuf.writeln('    static AnyGC* _trampoline(${erasedTrampParams.join(', ')}) {');
      _structBuf.write(erasedUnbox.toString());
      _structBuf.writeln('        $erasedCallBody');
      _structBuf.writeln('    }');
      _structBuf.writeln('    static $returnType _typedTrampoline(${typedTrampParams.join(', ')}) {');
      _structBuf.writeln('        $typedCallBody');
      _structBuf.writeln('    }');
      _structBuf.writeln('};');
      _structBuf.writeln();

      // Return an instance of the closure with static_cast to base type
      return 'GC::allocateLocal(static_cast<$typeFunctionBase*>(new $closureName()))';
    }
    if (constant is TypeLiteralConstant) {
      final t = constant.type;
      if (t is InterfaceType) {
        return _cppStringLiteral(t.classNode.name);
      }
      return _cppStringLiteral(t.toString());
    }
    return '/* TODO: constant ${constant.runtimeType} */';
  }

  // ==========================================================================
  // Type conversion helpers
  // ==========================================================================

  /// Wrap an expression to match the target C++ type.
  /// If the source expression is AnyGC* and target is a basic type,
  /// use AnyGC* conversion methods instead of static_cast.
  String _wrapToType(String expr, String targetType, Expression sourceExpr) {
    if (targetType.isEmpty) return expr;
    // AnyGC* 目标：nullptr → nullptr, 基本类型需要装箱
    if (targetType == 'AnyGC*') {
      if (expr == 'nullptr') return 'nullptr';
      if (_isAnyPtrResult(expr) || expr.startsWith('_box(') || expr.startsWith('GC::allocateLocal(')) {
        return expr;
      }
      final sourceType = _getExpressionType(sourceExpr);
      final sourceCppType = sourceType != null ? _cppType(sourceType) : '';
      if (sourceCppType == 'int64_t' || sourceCppType == 'int' ||
          sourceCppType == 'double' || sourceCppType == 'bool' ||
          sourceCppType == 'DartString' ||
          RegExp(r'^-?\d+LL$').hasMatch(expr) ||
          RegExp(r'^-?\d+\.\d+$').hasMatch(expr) ||
          expr == 'true' || expr == 'false' ||
          expr.startsWith('DartString(') || expr.startsWith('"')) {
        return '_box($expr)';
      }
      return expr;
    }

    final sourceType = _getExpressionType(sourceExpr);
    final sourceCppType = sourceType != null ? _cppType(sourceType) : '';

    // Type-erased collection dispatch (map/expand/cast_/whereType) returns AnyGC*
    // pointing to a collection whose element type is erased. When the target type
    // is a concrete StaticList/Set/Map, copy the elements into a properly typed
    // collection instead of doing an unsafe static_cast.
    if (_isTypeErasedCollectionResult(expr)) {
      final listMatch = RegExp(r'^StaticList<(.+)>\*$').firstMatch(targetType);
      if (listMatch != null) {
        return '_typedListFromAnyGC<${listMatch.group(1)}>($expr)';
      }
      final setMatch = RegExp(r'^StaticSet<(.+)>\*$').firstMatch(targetType);
      if (setMatch != null) {
        return '_typedSetFromAnyGC<${setMatch.group(1)}>($expr)';
      }
      final mapMatch = RegExp(r'^StaticMap<(.+)>\*$').firstMatch(targetType);
      if (mapMatch != null) {
        return '_typedMapFromAnyGC<${mapMatch.group(1)}>($expr)';
      }
    }

    // Wrap if source is explicitly AnyPtr
    if (sourceCppType == 'AnyGC*' || _isAnyPtrResult(expr)) {
      switch (targetType) {
        case 'int64_t': return 'dynAs<int64_t>($expr)';
        case 'int': return 'static_cast<int>(dynAs<int64_t>($expr))';
        case 'double': return 'dynAs<double>($expr)';
        case 'bool': return 'dynAs<bool>($expr)';
        case 'DartString': return 'dynAs<DartString>($expr)';
      }
      // For template type parameters (like TInput, TOutput), use dynAs<T>()
      if (_isCppTypeParameter(targetType)) {
        return 'dynAs<$targetType>($expr)';
      }
      // Skip wrapping if targetType contains unresolved type parameters not in scope
      if (_containsUnresolvedTypeParam(targetType, _inScopeTypeParams)) {
        return expr;
      }
      // For pointer types, use toGC() + static_cast
      if (targetType.endsWith('*')) {
        final baseType = targetType.substring(0, targetType.length - 1);
        // 裸类型参数（如 T*）：需要通过 void* 中间转换
        if (_isCppTypeParameter(baseType)) {
          return 'static_cast<$baseType*>(static_cast<void*>($expr))';
        }
        return 'static_cast<$baseType*>($expr)';
      }
      // For boxed value types (StaticMapEntry, StaticDuration, etc.)
      return 'dynAs<$targetType>($expr)';
    }

    // Wrap if source is AnyGC* (use dynAs for basic types, static_cast for pointers)
    if (sourceCppType == 'AnyGC*' || _isAnyGCPtrExpr(expr)) {
      return _unwrapFromAnyGCPtr(expr, targetType);
    }

    return expr;
  }

  // ==========================================================================
  // VPtr dispatch helpers
  // ==========================================================================

  /// Generate a typed ClassInfo field declaration.
  /// e.g. _classInfoFieldDecl('area', 0, retType: 'double') → 'double(*area)(AnyGC*) = nullptr'
  /// e.g. _classInfoFieldDecl('format', 1) → 'AnyGC*(*format)(AnyGC*, AnyGC*) = nullptr'
  String _classInfoFieldDecl(String fieldName, int argCount, {String retType = 'AnyGC*'}) {
    if (argCount == 0) return '$retType(*$fieldName)(AnyGC*) = nullptr';
    final restParams = List.filled(argCount, 'AnyGC*').join(', ');
    return '$retType(*$fieldName)(AnyGC*, $restParams) = nullptr';
  }

  /// Determine the C++ return type for a ClassInfo field based on a Procedure.
  String _procReturnType(Procedure proc, {bool isSetter = false}) {
    if (isSetter) return 'void';
    final retType = _cppType(proc.function.returnType);
    if (retType == 'void' || retType == 'int64_t' || retType == 'bool') return retType;
    return 'AnyGC*';
  }

  /// 根据目标方法的返回类型生成 vptr 函数指针类型
  /// 从前向声明中解析实际函数的参数类型
  /// 用于解析继承方法中未解析的类型参数（如 T → int64_t）
  List<String>? _resolveParamsFromForwardDecl(String funcName, int expectedParamCount) {
    List<String>? bestResult;
    for (final decl in _emittedForwardDecls) {
      if (!decl.contains('$funcName(')) continue;
      // 提取参数列表
      final parenStart = decl.indexOf('(', decl.indexOf(funcName));
      final parenEnd = decl.lastIndexOf(')');
      if (parenStart < 0 || parenEnd < 0) continue;
      final paramStr = decl.substring(parenStart + 1, parenEnd).trim();
      if (paramStr.isEmpty) continue;
      final paramParts = _splitTopLevel(paramStr);
      // 跳过 this__ 参数（第一个）
      if (paramParts.length < expectedParamCount + 1) continue;
      final result = <String>[];
      bool hasTypeParam = false;
      for (var i = 1; i <= expectedParamCount; i++) {
        final part = paramParts[i].trim();
        // 提取类型（去掉参数名）
        final lastSpace = part.lastIndexOf(' ');
        final type = lastSpace > 0 ? part.substring(0, lastSpace).trim() : part;
        result.add(type);
        if (_isCppTypeParameter(type)) hasTypeParam = true;
      }
      // 优先使用没有类型参数的声明（已解析的具体类型）
      if (!hasTypeParam) return result;
      bestResult ??= result;
    }
    return bestResult;
  }

  /// 从前向声明中解析实际函数的返回类型
  String? _resolveReturnTypeFromForwardDecl(String funcName) {
    String? bestResult;
    for (final decl in _emittedForwardDecls) {
      if (!decl.contains('$funcName(')) continue;
      // 返回类型在函数名之前
      final funcIdx = decl.indexOf(funcName);
      if (funcIdx <= 0) continue;
      final beforeFunc = decl.substring(0, funcIdx).trim();
      // 去掉可能的 template<...> 前缀
      String returnType;
      if (beforeFunc.contains('>')) {
        final gtIdx = beforeFunc.lastIndexOf('>');
        returnType = beforeFunc.substring(gtIdx + 1).trim();
      } else {
        returnType = beforeFunc;
      }
      // 优先使用没有类型参数的返回类型
      if (!_isCppTypeParameter(returnType)) return returnType;
      bestResult ??= returnType;
    }
    return bestResult;
  }

  /// 根据目标方法的返回类型生成 vptr 派发后的转换包装函数
  /// 返回包装函数名如 dynAs<int64_t>，空字符串表示无需转换
  String _vptrReturnSuffix(Member? target) {
    String? retType;
    if (target is Procedure) {
      retType = _cppType(target.function.returnType);
    } else if (target is Field) {
      retType = _cppType(target.type);
    }
    if (retType == null) return '';
    // int64_t and bool now return raw from ClassInfo — no dynAs needed
    if (retType == 'int64_t' || retType == 'bool') return '';
    if (retType == 'double') return 'dynAs<double>';
    if (retType == 'DartString') return 'dynAs<DartString>';
    // 用户定义值类型（如 StaticDuration, StaticDateTime）需要 dynAs 解包
    if (_isConcreteCppReturnType(retType)) return 'dynAs<$retType>';
    return '';
  }

  /// 将参数列表中的每个参数包装为 _box(...)
  /// 用于 vptr 派发时的参数传递
  String _wrapVptrArgs(String args) {
    if (args.isEmpty) return '';
    final argList = _splitTopLevel(args);
    return argList.map((a) => '_box(${a.trim()})').join(', ');
  }

  /// 检查 C++ 类型是否是具体的（非模板参数、非 AnyPtr、非指针）
  /// 用于决定 vptr 函数指针的返回类型
  bool _isConcreteCppReturnType(String type) {
    if (type == 'AnyGC*' || type == 'void') return false;
    if (type.endsWith('*')) return false;
    // 排除单字母模板参数 (T, R, A, B, C, etc.)
    if (RegExp(r'^[A-Z]$').hasMatch(type)) return false;
    // 已知的具体类型（含用户定义值类型）
    const concreteTypes = {'int64_t', 'double', 'bool', 'DartString', 'int32_t', 'int16_t', 'int8_t', 'uint64_t', 'uint32_t', 'float',
      'StaticDuration', 'StaticDateTime', 'StaticRegExp'};
    return concreteTypes.contains(type);
  }

  /// 检查 DartType 是否包含不在作用域内的类型参数（递归检查嵌套类型参数）
  bool _dartTypeHasUnresolvedTypeParam(DartType type) {
    if (type is TypeParameterType) {
      return !_inScopeTypeParams.contains(type.parameter.name ?? 'T');
    }
    if (type is InterfaceType) {
      return type.typeArguments.any(_dartTypeHasUnresolvedTypeParam);
    }
    if (type is FunctionType) {
      if (_dartTypeHasUnresolvedTypeParam(type.returnType)) return true;
      if (type.positionalParameters.any(_dartTypeHasUnresolvedTypeParam)) return true;
      if (type.namedParameters.any((p) => _dartTypeHasUnresolvedTypeParam(p.type))) return true;
    }
    return false;
  }

  /// 尝试将返回类型中的类型参数替换为接收器类型的实际类型参数
  /// 通过遍历接收器的类层次结构（包括超类型）构建名称→类型映射
  DartType? _trySubstTypeParams(DartType type, InterfaceType recvType) {
    final nameMap = <String, DartType>{};
    final recvClass = recvType.classNode;
    for (int i = 0; i < recvClass.typeParameters.length && i < recvType.typeArguments.length; i++) {
      final name = recvClass.typeParameters[i].name;
      if (name != null) nameMap[name] = recvType.typeArguments[i];
    }
    void processSupertype(Supertype? st) {
      if (st == null) return;
      final superCls = st.classNode;
      final superArgs = st.typeArguments;
      for (int i = 0; i < superCls.typeParameters.length && i < superArgs.length; i++) {
        final name = superCls.typeParameters[i].name;
        if (name == null) continue;
        nameMap[name] = _substByName(superArgs[i], nameMap);
      }
      processSupertype(superCls.supertype);
      for (final impl in superCls.implementedTypes) {
        processSupertype(impl);
      }
    }
    processSupertype(recvClass.supertype);
    for (final impl in recvClass.implementedTypes) {
      processSupertype(impl);
    }
    return _substByName(type, nameMap);
  }

  DartType _substByName(DartType type, Map<String, DartType> nameMap) {
    if (type is TypeParameterType) {
      final name = type.parameter.name;
      if (name != null && nameMap.containsKey(name)) return nameMap[name]!;
      return type;
    }
    if (type is InterfaceType) {
      if (type.typeArguments.isEmpty) return type;
      final newArgs = type.typeArguments.map((t) => _substByName(t, nameMap)).toList();
      return InterfaceType(type.classNode, type.nullability, newArgs);
    }
    return type;
  }

  /// 根据 DartType 获取对应的 ClassInfo 类型名
  String _classInfoTypeName(DartType? type) {
    if (type is InterfaceType) {
      final name = type.classNode.name;
      // Object 使用基类 ClassInfo
      if (name == 'Object') return 'ClassInfo';
      // Dart 集合类型 → C++ StaticXxxClassInfo 映射
      const ciNameMap = {
        'List': 'StaticListClassInfo',
        'StaticList': 'StaticListClassInfo',
        '_List': 'StaticListClassInfo',
        '_GrowableList': 'StaticListClassInfo',
        'Iterable': 'StaticListClassInfo',
        '_Iterable': 'StaticListClassInfo',
        'Map': 'StaticMapClassInfo',
        'StaticMap': 'StaticMapClassInfo',
        '_Map': 'StaticMapClassInfo',
        'Set': 'StaticSetClassInfo',
        'StaticSet': 'StaticSetClassInfo',
        '_Set': 'StaticSetClassInfo',
        'StringBuffer': 'StaticStringBufferClassInfo',
        'StaticStringBuffer': 'StaticStringBufferClassInfo',
        'Duration': 'StaticDurationClassInfo',
        'StaticDuration': 'StaticDurationClassInfo',
        'DateTime': 'StaticDateTimeClassInfo',
        'StaticDateTime': 'StaticDateTimeClassInfo',
      };
      final typeArgs = type.typeArguments;
      if (ciNameMap.containsKey(name)) {
        final ciName = ciNameMap[name]!;
        if (typeArgs.isNotEmpty) {
          final args = typeArgs.map((t) {
            if (_dartTypeHasUnresolvedTypeParam(t)) return 'AnyGC*';
            return _cppType(t);
          }).join(', ');
          return '$ciName<$args>';
        }
        return ciName;
      }
      final cleanName = _cleanName(name);
      if (typeArgs.isNotEmpty) {
        final args = typeArgs.map((t) {
          if (_dartTypeHasUnresolvedTypeParam(t)) return 'AnyGC*';
          return _cppType(t);
        }).join(', ');
        return '${cleanName}ClassInfo<$args>';
      }
      return '${cleanName}ClassInfo';
    }
    return 'ClassInfo';
  }

  /// 生成 ClassInfo 字段访问表达式
  /// 对 AnyGC 子类: static_cast<XxxClassInfo*>(receiver->_classInfo)->fieldName
  /// 对 Mixin (AnyGC 子类): XxxMixin::_classInfo.fieldName
  String _classInfoAccess(String receiver, DartType? receiverType, String fieldName) {
    // 检查类型提升：如果 receiver 是变量且有提升类型，使用提升类型
    if (_typePromotions.containsKey(receiver)) {
      receiverType = _typePromotions[receiver];
    }
    var ciType = _classInfoTypeName(receiverType);
    final cppType = receiverType != null ? _cppType(receiverType) : '';

    // Mixin 类型继承 AnyGC，没有 _classInfo 指针字段，使用静态成员直接访问
    if (receiverType is InterfaceType) {
      final className = receiverType.classNode.name;
      if (_mixinNames.contains(className)) {
        final mixinStructName = '${_cleanName(className)}Mixin';
        // 模板 mixin 需要模板参数
        final mixinCls = _classNodes[className];
        final mixinTypeParams = mixinCls?.typeParameters ?? [];
        if (mixinTypeParams.isNotEmpty) {
          final args = mixinTypeParams.map((tp) => tp.name ?? 'T').join(', ');
          return '$mixinStructName<$args>::_classInfo.$fieldName';
        }
        return '$mixinStructName::_classInfo.$fieldName';
      }
    }
    // 也检查 C++ 类型名是否以 Mixin 结尾（处理 receiverType 为 null 的情况）
    if (cppType.endsWith('Mixin') || cppType.endsWith('Mixin*')) {
      final mixinStructName = cppType.replaceAll('*', '');
      return '$mixinStructName::_classInfo.$fieldName';
    }
    // 当前正在生成的类是 mixin 时（receiverType 为 null 的 self-call）
    // 通过 _classInfo 获取具体类的 ClassInfo 指针，
    // 这样可以访问 on 约束中的方法（如 Scalable on Measurable 中的 measure）
    // 仅当 receiver 是简单变量（self 引用）时才走此路径，
    // 对于字段访问（如 this_->_tags）应使用字段类型的 ClassInfo
    if (_mixinNames.contains(_currentClassName) &&
        ciType == 'ClassInfo' &&
        !receiver.contains('->') && !receiver.contains('.')) {
      // 检查方法是否在 mixin 自身的 procedures 中
      final mixinCls = _classNodes[_currentClassName];
      bool hasOwnMethod = false;
      if (mixinCls != null) {
        hasOwnMethod = mixinCls.procedures.any((p) {
          if (p.isStatic || p.isFactory || p.name.text.startsWith('_')) return false;
          final pn = _cleanMethodName(p.name.text);
          if (p.isGetter) return 'get_$pn' == fieldName;
          if (p.isSetter) return 'set_$pn' == fieldName;
          return pn == fieldName;
        });
      }
      if (hasOwnMethod) {
        final mixinStructName = '${_cleanName(_currentClassName)}Mixin';
        // 模板 mixin 需要模板参数
        final mixinTypeParams = mixinCls?.typeParameters ?? [];
        if (mixinTypeParams.isNotEmpty) {
          final args = mixinTypeParams.map((tp) => tp.name ?? 'T').join(', ');
          return '$mixinStructName<$args>::_classInfo.$fieldName';
        }
        return '$mixinStructName::_classInfo.$fieldName';
      }
      // 方法不在 mixin 自身中，通过 _classInfo 派发
      String mixinCiType = 'ClassInfo';
      if (mixinCls != null && mixinCls.supertype != null) {
        final superType = mixinCls.supertype!;
        final superName = superType.classNode.name;
        if (_userClasses.contains(superName) && !_mixinNames.contains(superName)) {
          final cleanName = _cleanName(superName);
          final superTypeArgs = superType.typeArguments;
          if (superTypeArgs.isNotEmpty) {
            final args = superTypeArgs.map((t) {
              if (t is TypeParameterType && !_inScopeTypeParams.contains(t.parameter.name ?? 'T')) {
                return 'AnyGC*';
              }
              return _cppType(t);
            }).join(', ');
            mixinCiType = '$cleanName' 'ClassInfo<$args>';
          } else {
            mixinCiType = '$cleanName' 'ClassInfo';
          }
        }
      }
      return 'static_cast<$mixinCiType*>(static_cast<AnyGC*>($receiver)->_classInfo)->$fieldName';
    }
    // receiverType 为 null 时，使用当前类的 ClassInfo 类型
    if (ciType == 'ClassInfo' && _currentClassName.isNotEmpty && _userClasses.contains(_currentClassName)) {
      final cleanName = _cleanName(_currentClassName);
      final cls = _classNodes[_currentClassName];
      final typeParams = cls?.typeParameters ?? [];
      // 仅当模板参数在当前作用域内时才添加模板参数
      if (typeParams.isNotEmpty && typeParams.every((tp) => _inScopeTypeParams.contains(tp.name ?? 'T'))) {
        final args = typeParams.map((tp) => tp.name ?? 'T').join(', ');
        ciType = '$cleanName' 'ClassInfo<$args>';
      } else {
        ciType = '${cleanName}ClassInfo';
      }
    }

    String rcv;
    if (cppType == 'AnyGC*' || _isAnyGCPtrExpr(receiver) || receiver.contains('->_classInfo)->')) {
      rcv = 'static_cast<AnyGC*>($receiver)';
    } else {
      rcv = receiver;
    }
    return 'static_cast<$ciType*>($rcv->AnyGC::_classInfo)->$fieldName';
  }

  // ==========================================================================
  // 类型映射
  // ==========================================================================

  String _cppType(DartType type) {
    if (type is InterfaceType) {
      final name = type.classNode.name;
      final args = type.typeArguments;

      // 运行时类优先处理（这些类在 C++ 运行时头文件中定义，不需要 Value 后缀）
      if (_isRuntimeClassName(name)) {
        return _runtimeCppType(name, args);
      }

      // 用户定义类优先于内置类型（避免 Array/Promise 等名称冲突）
      if (_userClasses.contains(name)) {
        final cleanName = _cleanName(name);
        if (_enumNames.contains(name)) {
          return '$cleanName*';
        }
        if (args.isEmpty) {
          // 检查该类是否有类型参数，如果有则用 AnyGC* 作为默认参数
          final clsNode = _classNodes[name];
          if (clsNode != null && clsNode.typeParameters.isNotEmpty) {
            final defaultArgs = clsNode.typeParameters.map((_) => 'AnyGC*').join(', ');
            return '${cleanName}Value<$defaultArgs>*';
          }
          return '${cleanName}Value*';
        }
        final cppArgs = args.map(_cppType).join(', ');
        return '${cleanName}Value<$cppArgs>*';
      }

      switch (name) {
        case 'int':
          return 'int64_t';
        case 'double':
          return 'double';
        case 'bool':
          return 'bool';
        case 'String':
          return 'DartString';
        case 'void': return 'void';
        case 'Null':
        case 'Object':
        case 'dynamic': return 'AnyGC*';
        case 'num': return 'double';
        case 'List':
          final inner = args.isNotEmpty ? _cppType(args[0]) : 'AnyGC*';
          return 'StaticList<$inner>*';
        case 'StaticList':
          final inner2 = args.isNotEmpty ? _cppType(args[0]) : 'AnyGC*';
          return 'StaticList<$inner2>*';
        case 'Map':
          if (args.length >= 2) {
            return 'StaticMap<${_cppType(args[0])}, ${_cppType(args[1])}>*';
          }
          return 'StaticMap<AnyGC*, AnyGC*>*';
        case 'StaticMap':
          if (args.length >= 2) {
            return 'StaticMap<${_cppType(args[0])}, ${_cppType(args[1])}>*';
          }
          return 'StaticMap<AnyGC*, AnyGC*>*';
        case 'Set':
          final inner3 = args.isNotEmpty ? _cppType(args[0]) : 'AnyGC*';
          return 'StaticSet<$inner3>*';
        case 'StaticSet':
          final inner4 = args.isNotEmpty ? _cppType(args[0]) : 'AnyGC*';
          return 'StaticSet<$inner4>*';
        case 'Future': {
          var inner = args.isNotEmpty ? _cppType(args[0]) : 'AnyGC*';
          if (inner == 'void') inner = 'int';
          return 'Promise<$inner>*';
        }
        case 'Promise': {
          var inner = args.isNotEmpty ? _cppType(args[0]) : 'AnyGC*';
          if (inner == 'void') inner = 'int';
          return 'Promise<$inner>*';
        }
        case 'Iterable':
          final inner = args.isNotEmpty ? _cppType(args[0]) : 'AnyGC*';
          return 'StaticList<$inner>*';
        case 'Iterator':
          final inner = args.isNotEmpty ? _cppType(args[0]) : 'AnyGC*';
          return 'StaticIterator<$inner>*';
        case 'MapEntry':
          if (args.length >= 2) {
            return 'StaticMapEntry<${_cppType(args[0])}, ${_cppType(args[1])}>';
          }
          return 'StaticMapEntry<AnyGC*, AnyGC*>';
        case 'Array':
          final inner = args.isNotEmpty ? _cppType(args[0]) : 'AnyGC*';
          return 'Array<$inner>*';
        case 'Duration': return 'StaticDuration';
        case 'DateTime': return 'StaticDateTime';
        case 'RegExp': return 'StaticRegExp';
        case 'StringBuffer': return 'StaticStringBuffer*';
        case 'Function': return 'TypeFunction*';
        case 'Comparable':
          // Comparable<T> 作为类型参数时，使用 AnyGC* 代替（C++ 没有接口约束）
          return 'AnyGC*';
        default:
          final cleanName = _cleanName(name);
          if (_enumNames.contains(name)) {
            return '$cleanName*';
          }
          if (args.isEmpty) {
            // 检查是否为模板类，如果是则需要提供默认模板参数
            final clsNode = _classNodes[name];
            if (clsNode != null && clsNode.typeParameters.isNotEmpty) {
              final defaultArgs = clsNode.typeParameters.map((_) => 'AnyGC*').join(', ');
              return '${cleanName}Value<$defaultArgs>*';
            }
            return '${cleanName}Value*';
          }
          final cppArgs = args.map(_cppType).join(', ');
          return '${cleanName}Value<$cppArgs>*';
      }
    }
    if (type is TypeParameterType) return type.parameter.name ?? 'T';
    if (type is DynamicType) return 'AnyGC*';
    if (type is VoidType) return 'void';
    if (type is NeverType) return 'AnyGC*';
    if (type is FunctionType) {
      final returnType = _cppType(type.returnType);
      final paramTypes = type.positionalParameters.map(_cppType).toList();
      if (paramTypes.isEmpty) return 'TypeFunction0<$returnType>*';
      if (paramTypes.length <= 2) {
        return 'TypeFunction${paramTypes.length}<$returnType, ${paramTypes.join(', ')}>*';
      }
      return 'AnyGC*';
    }
    if (type is FutureOrType) {
      var inner = _cppType(type.typeArgument);
      if (inner == 'void') inner = 'int';
      return 'Promise<$inner>*';
    }
    // Record 类型映射为 std::tuple 指针
    if (type is RecordType) {
      final positionalTypes = type.positional.map(_cppType).toList();
      // 由于 std::tuple 不是 GC 类型，我们使用 AnyGC* 作为占位符
      // 实际使用时需要转换为正确的 tuple 类型
      return 'AnyGC*';
    }
    return 'AnyGC*';
  }

  /// 解析类型参数：将 TypeParameterType 替换为实际的类型实参
  String _resolveTypeParamInType(DartType type, List<TypeParameter> typeParams, List<DartType> typeArgs) {
    if (type is TypeParameterType) {
      final paramName = type.parameter.name;
      final idx = typeParams.indexWhere((tp) => tp.name == paramName);
      if (idx >= 0 && idx < typeArgs.length) {
        return _cppType(typeArgs[idx]);
      }
      return _cppType(type);
    }
    if (type is FunctionType) {
      final returnType = _resolveTypeParamInType(type.returnType, typeParams, typeArgs);
      final paramTypes = type.positionalParameters.map((p) => _resolveTypeParamInType(p, typeParams, typeArgs)).toList();
      if (paramTypes.isEmpty) return 'TypeFunction0<$returnType>*';
      if (paramTypes.length <= 2) {
        return 'TypeFunction${paramTypes.length}<$returnType, ${paramTypes.join(', ')}>*';
      }
      return 'AnyGC*';
    }
    if (type is InterfaceType) {
      final name = type.classNode.name;
      final args = type.typeArguments;
      if (args.isEmpty) return _cppType(type);
      final argList = args.map((a) => _resolveTypeParamInType(a, typeParams, typeArgs)).toList();
      final resolvedArgs = argList.join(', ');
      // 重建类型字符串
      if (name.startsWith('TypeFunction')) {
        final returnType = argList[0];
        final paramArgs = argList.skip(1).join(', ');
        if (paramArgs.isEmpty) return 'TypeFunction0<$returnType>*';
        if (argList.length - 1 <= 2) return 'TypeFunction${argList.length - 1}<$returnType, $paramArgs>*';
        return 'AnyGC*';
      }
      // Built-in collection types — map to runtime C++ types
      if (name == 'List' || name == 'StaticList' || name == 'Iterable' ||
          name == '_Iterable' || name == '_List' || name == '_GrowableList') {
        return 'StaticList<$resolvedArgs>*';
      }
      if (name == 'Map' || name == 'StaticMap') {
        return 'StaticMap<$resolvedArgs>*';
      }
      if (name == 'Set' || name == 'StaticSet') {
        return 'StaticSet<$resolvedArgs>*';
      }
      // MapEntry → StaticMapEntry (值类型，不加 * 后缀)
      if (name == 'MapEntry' || name == 'StaticMapEntry') {
        if (argList.length >= 2) {
          return 'StaticMapEntry<$resolvedArgs>';
        }
        return 'StaticMapEntry<AnyGC*, AnyGC*>';
      }
      // For user classes and known generic types, rebuild with resolved args
      final cppName = _isRuntimeClassName(name) ? _cleanName(name) : '${_cleanName(name)}Value';
      return '$cppName<$resolvedArgs>*';
    }
    return _cppType(type);
  }

  // ==========================================================================
  // 辅助方法
  // ==========================================================================

  void _addForwardDecl(String name) {
    if (_emittedForwardDecls.add(name)) {
      if (name.contains('(')) {
        // 函数前向声明 - 直接写入
        _fwdBuf.writeln('$name;');
      } else if (name.startsWith('template<') || name.startsWith('struct ') || name.startsWith('extern ')) {
        // 已经是完整的前向声明（模板类、结构体、或外部变量）
        _fwdBuf.writeln('$name;');
      } else {
        // 结构体前向声明 - 添加 struct 关键字
        _fwdBuf.writeln('struct $name;');
      }
    }
  }

  /// C++ 保留字和替代标记集合，用作标识符时需要追加 _ 后缀
  static const Set<String> _cppReservedWords = {
    // C++ 关键字
    'alignas', 'alignof', 'and', 'and_eq', 'asm', 'auto', 'bitand', 'bitor',
    'bool', 'break', 'case', 'catch', 'char', 'char8_t', 'char16_t', 'char32_t',
    'class', 'compl', 'concept', 'const', 'consteval', 'constexpr', 'constinit',
    'const_cast', 'continue', 'co_await', 'co_return', 'co_yield', 'decltype',
    'default', 'delete', 'do', 'double', 'dynamic_cast', 'else', 'enum',
    'explicit', 'export', 'extern', 'false', 'float', 'for', 'friend', 'goto',
    'if', 'inline', 'int', 'long', 'mutable', 'namespace', 'new', 'noexcept',
    'not', 'not_eq', 'nullptr', 'operator', 'or', 'or_eq', 'private', 'protected',
    'public', 'register', 'reinterpret_cast', 'requires', 'return', 'short',
    'signed', 'sizeof', 'static', 'static_assert', 'static_cast', 'struct',
    'switch', 'template', 'this', 'thread_local', 'throw', 'true', 'try',
    'typedef', 'typeid', 'typename', 'union', 'unsigned', 'using', 'virtual',
    'void', 'volatile', 'wchar_t', 'while', 'xor', 'xor_eq',
    // 常见宏/标识符冲突（注意：main 不在此列表中，因为 emitter 已特殊处理 main 函数）
    'stdin', 'stdout', 'stderr', 'log',
  };

  /// 运算符名称映射（用于生成唯一的函数名）
  static const Map<String, String> _operatorNameMap = {
    '+': 'add',
    '-': 'sub',
    '*': 'mul',
    '/': 'div',
    '%': 'mod',
    '~/': 'idiv',
    '<': 'lt',
    '>': 'gt',
    '<=': 'le',
    '>=': 'ge',
    '==': 'eq',
    '!=': 'ne',
    '&': 'band',
    '|': 'bor',
    '^': 'bxor',
    '~': 'bnot',
    '<<': 'shl',
    '>>': 'shr',
    '>>>': 'ushr',
    '[]': 'index',
    '[]=': 'setIndex',
    'unary-': 'neg',
    '_': 'call',
  };

  /// Method fields defined in the base ClassInfo struct.
  /// User class ClassInfo subclasses inherit these — must not redeclare (would shadow base fields).
  static const Set<String> _baseClassInfoFields = {
    'toString', 'get_runtimeType', 'eq', 'get_hashCode', 'compareTo',
    'get_length', 'get_isEmpty', 'get_isNotEmpty', 'get_iterator',
    'toUpperCase', 'toLowerCase', 'contains', 'trim', 'trimLeft', 'trimRight',
    'replaceFirst', 'replaceRange', 'padLeft', 'padRight',
    'lastIndexOf', 'codeUnitAt',
    'index', 'setIndex', 'containsKey',
  };

  /// 清理方法名，运算符使用可读名称
  String _cleanMethodName(String name) {
    if (_operatorNameMap.containsKey(name)) {
      return _operatorNameMap[name]!;
    }
    return _cleanName(name);
  }

  /// 将 _VTableEntry 转换为 ClassInfo 字段名
  String _classInfoFieldName(dynamic entry) {
    final methodName = _cleanMethodName(entry.name as String);
    final kind = entry.kind as String;
    if (kind == 'getter') return 'get_$methodName';
    if (kind == 'setter') return 'set_$methodName';
    if (kind == 'operator') return _cleanMethodName(entry.name as String);
    return methodName;
  }

  /// Base ClassInfo fields with fixed return types (must match struct ClassInfo in header)
  static const _baseClassInfoFieldTypes = {
    'eq': 'bool',
    'get_hashCode': 'int64_t',
    'compareTo': 'int64_t',
    'get_length': 'int64_t',
    'contains': 'bool',
    'containsKey': 'bool',
    'setIndex': 'void',
  };

  /// Get the type parameter name from a generic parent's method return type.
  /// Returns the C++ type parameter name (e.g., 'TOutput') if the method is
  /// inherited from a generic parent where the return type was a type parameter.
  /// Returns null if not applicable.
  String? _getParentTypeParamReturn(Procedure proc, String procName) {
    final enclosingClass = proc.enclosingClass;
    if (enclosingClass == null) return null;
    var parent = enclosingClass.supertype;
    while (parent != null) {
      final parentClass = parent.classNode;
      for (final p in parentClass.procedures) {
        if (p.name.text == procName) {
          final parentRetType = _cppType(p.function.returnType);
          if (_isCppTypeParameter(parentRetType)) return parentRetType;
        }
      }
      parent = parentClass.supertype;
    }
    return null;
  }

  /// 确定 _vptr_wrap_* 函数的返回类型
  /// 与 ClassInfo 结构体字段类型一致
  /// [currentClass] is the class whose ClassInfo is being generated (may differ
  /// from proc.enclosingClass when the method is inherited from a generic parent).
  String _vptrWrapReturnType(dynamic entry, [Class? currentClass]) {
    final fieldName = _classInfoFieldName(entry);
    if (fieldName == 'index') return 'AnyGC*';
    if (_baseClassInfoFieldTypes.containsKey(fieldName)) {
      return _baseClassInfoFieldTypes[fieldName]!;
    }
    final kind = entry.kind as String;
    if (kind == 'setter') return 'void';
    final proc = entry.proc;
    if (proc is Procedure) {
      final retType = _cppType(proc.function.returnType);
      if (retType == 'void') return 'void';
      final classIsTemplate = currentClass != null && currentClass.typeParameters.isNotEmpty;
      final classTypeParamNames = classIsTemplate
          ? currentClass!.typeParameters.map((tp) => tp.name ?? 'T').toSet()
          : <String>{};
      // Build type substitution map (resolves parent type params to current class's params or concrete types)
      final substitution = currentClass != null ? _buildTypeSubstitutionMap(currentClass) : <String, String>{};

      // Try to resolve a type parameter to a usable return type
      String? resolveTypeParam(String tp) {
        if (classTypeParamNames.contains(tp)) return tp;
        final resolved = _applyTypeSubstitution(tp, substitution);
        if (resolved != tp) {
          if (classTypeParamNames.contains(resolved)) return resolved;
          if (!_isCppTypeParameter(resolved) &&
              (resolved == 'int64_t' || resolved == 'bool' || resolved == 'double' ||
               resolved == 'DartString' || (resolved.endsWith('*') && resolved != 'AnyGC*'))) {
            return resolved;
          }
        }
        return null;
      }

      // If return type is itself a type parameter
      if (_isCppTypeParameter(retType)) {
        final resolved = resolveTypeParam(retType);
        if (resolved != null) return resolved;
      }
      // Check if inherited from generic parent where return type was a type parameter
      final typeParam = _getParentTypeParamReturn(proc, proc.name.text);
      if (typeParam != null) {
        final resolved = resolveTypeParam(typeParam);
        if (resolved != null) return resolved;
        // Fallback: use resolved retType if it's a concrete type
        if (retType == 'int64_t' || retType == 'bool' || retType == 'double' || retType == 'DartString') {
          return retType;
        }
        if (retType.endsWith('*') && retType != 'AnyGC*') {
          return retType;
        }
      }
      if (retType == 'int64_t' || retType == 'bool') {
        return retType;
      }
      return 'AnyGC*';
    }
    return 'AnyGC*';
  }

  /// 获取 _VTableEntry 的参数个数（不含 this）
  int _vtableEntryArgCount(dynamic entry) {
    final kind = entry.kind as String;
    if (kind == 'getter') return 0;
    if (kind == 'setter') return 1;
    final proc = entry.proc;
    if (proc is Procedure) {
      return proc.function.positionalParameters.length + proc.function.namedParameters.length;
    }
    // operator 默认按二元处理
    if (kind == 'operator') {
      final name = entry.name as String;
      if (name == 'unary-' || name == '~') return 0;
      if (name == '[]') return 1;
      if (name == '[]=') return 2;
      return 1;
    }
    return 0;
  }

  String _cleanName(String name) {
    if (_cleanedNames.containsKey(name)) return _cleanedNames[name]!;
    // 先将 & 替换为 _and_，避免与 C++ 语法冲突
    var cleaned = name.replaceAll('&', '_and_');
    // 再替换其他非法字符
    cleaned = cleaned.replaceAll(RegExp(r'[^a-zA-Z0-9_]'), '_');
    if (cleaned.isNotEmpty && RegExp(r'^[0-9]').hasMatch(cleaned)) {
      cleaned = '_$cleaned';
    }
    if (cleaned.isEmpty) cleaned = '_unnamed';
    // C++ 保留字冲突时追加 _ 后缀
    if (_cppReservedWords.contains(cleaned)) {
      cleaned = '${cleaned}_';
    }
    _cleanedNames[name] = cleaned;
    return cleaned;
  }

  /// Sanitize synthetic mixin class names (e.g., _Dog&Animal&Printable → Dog_Animal_Printable)
  String _sanitizeSyntheticName(String name) {
    var result = name;
    if (result.startsWith('_')) result = result.substring(1);
    return result.replaceAll('&', '_');
  }

  String _cppDefaultValue(String cppType) {
    if (cppType == 'int64_t') return '0';
    if (cppType == 'double') return '0.0';
    if (cppType == 'bool') return 'false';
    if (cppType == 'DartString') return '""';
    if (cppType.endsWith('*')) return 'nullptr';
    // 对于模板类型参数（如 A, B, T），返回空字符串以避免 {{}} 歧义
    // 使用 A field{}; 而非 A field{{}};
    if (_isTemplateTypeParam(cppType)) return '';
    return '{}';
  }

  /// 检查类型名是否看起来像模板类型参数（单一大写名称）
  bool _isTemplateTypeParam(String type) {
    // 模板参数通常是单个大写字母或短名称如 T, ID, V, R 等
    return RegExp(r'^[A-Z][A-Za-z0-9_]*$').hasMatch(type) &&
           !_userClasses.contains(type) &&
           !_enumNames.contains(type) &&
           type != 'DartString' &&
           type != 'AnyGC*' && type != 'AnyGC' && type != 'Promise';
  }

  bool _isGcPointerType(String cppType) {
    return cppType.endsWith('*') && cppType != 'void*';
  }

  /// 按名称去重类型参数列表，避免 template<typename T, typename T>
  List<TypeParameter> _deduplicateTypeParams(List<TypeParameter> params) {
    final seen = <String>{};
    final result = <TypeParameter>[];
    for (final tp in params) {
      final name = tp.name ?? 'T';
      if (seen.add(name)) {
        result.add(tp);
      }
    }
    return result;
  }

  /// 按继承关系拓扑排序类列表，确保父类在子类之前定义
  List<Class> _topologicalSortClasses(List<Class> classes) {
    final nameToClass = <String, Class>{};
    for (final cls in classes) {
      nameToClass[cls.name] = cls;
    }

    final result = <Class>[];
    final visited = <String>{};
    final inStack = <String>{};

    void visit(Class cls) {
      if (visited.contains(cls.name)) return;
      if (inStack.contains(cls.name)) return; // 循环依赖，跳过
      inStack.add(cls.name);

      // 先访问父类
      final superClass = cls.superclass;
      if (superClass != null && nameToClass.containsKey(superClass.name)) {
        visit(nameToClass[superClass.name]!);
      }

      inStack.remove(cls.name);
      visited.add(cls.name);
      result.add(cls);
    }

    for (final cls in classes) {
      visit(cls);
    }
    return result;
  }

  bool _isEnumClass(Class cls) {
    return cls.superclass?.name == '_Enum' ||
        cls.superclass?.name == 'Enum' ||
        _enumNames.contains(cls.name);
  }

  /// 检查是否是运行时类（已在 C++ 运行时头文件中定义，不应重新生成）
  static const Set<String> _runtimeClassNames = {
    'Promise', '_Promise',
    'StaticList', 'StaticSet', 'StaticMap',
    'Array', 'StaticDuration', 'StaticStringBuffer', 'StringBuffer',
    'StaticDateTime', 'DateTime',
    'GlobalScheduler', 'CompleterState',
    'StaticIterator', 'StaticMapEntry',
    'AsyncStateMachine',
  };

  bool _isRuntimeClass(Class cls) {
    // 运行时头文件已提供这些类的 C++ 实现，即使用户在 Dart 侧重新定义了同名类，
    // 也应映射到运行时类型，避免生成重复的 struct 定义导致编译冲突。
    return _runtimeClassNames.contains(cls.name) && !_enumNames.contains(cls.name);
  }

  /// 按名称检查是否为运行时类（用户自定义同名枚举优先，其余同名类映射到运行时类型）
  bool _isRuntimeClassName(String name) {
    return _runtimeClassNames.contains(name) && !_enumNames.contains(name);
  }

  /// 运行时类的 C++ 类型映射（不加 Value 后缀，因为这些类在运行时头文件中已定义）
  String _runtimeCppType(String name, List<DartType> args) {
    switch (name) {
      case 'Promise':
      case '_Promise':
        var inner = args.isNotEmpty ? _cppType(args[0]) : 'AnyGC*';
        if (inner == 'void') inner = 'int';
        return 'Promise<$inner>*';
      case 'StaticList':
        final inner = args.isNotEmpty ? _cppType(args[0]) : 'AnyGC*';
        return 'StaticList<$inner>*';
      case 'StaticSet':
        final inner = args.isNotEmpty ? _cppType(args[0]) : 'AnyGC*';
        return 'StaticSet<$inner>*';
      case 'StaticMap':
        if (args.length >= 2) {
          return 'StaticMap<${_cppType(args[0])}, ${_cppType(args[1])}>*';
        }
        return 'StaticMap<AnyGC*, AnyGC*>*';
      case 'Array':
        final inner = args.isNotEmpty ? _cppType(args[0]) : 'AnyGC*';
        return 'Array<$inner>*';
      case 'StaticDuration':
        return 'StaticDuration';
      case 'StaticDateTime':
      case 'DateTime':
        return 'StaticDateTime';
      case 'StaticStringBuffer':
      case 'StringBuffer':
        return 'StaticStringBuffer*';
      case 'GlobalScheduler':
        return 'GlobalScheduler';
      case 'CompleterState':
        return 'CompleterState';
      case 'StaticIterator':
        final inner = args.isNotEmpty ? _cppType(args[0]) : 'AnyGC*';
        return 'StaticIterator<$inner>*';
      case 'StaticMapEntry':
        if (args.length >= 2) {
          return 'StaticMapEntry<${_cppType(args[0])}, ${_cppType(args[1])}>';
        }
        return 'StaticMapEntry<AnyGC*, AnyGC*>';
      default:
        // 未知运行时类，直接使用名称
        if (args.isEmpty) return name;
        final cppArgs = args.map(_cppType).join(', ');
        return '$name<$cppArgs>';
    }
  }
}
