part of 'dart_restorer.dart';

// ============================================================================
// Dart Kernel AST → C++ 代码生成器
// ============================================================================
// 与 DartRestorer 平级，共享 Kernel AST 中间表示和类信息分析结果，
// 分别生成静态 Dart 和 C++ 两份输出。
//
// 架构：
//   Kernel AST (共享中间表示)
//       ├─→ DartRestorer  → 静态 Dart (Lowered Dart)
//       └─→ CppEmitter    → C++ (使用 dart2cpp_lowered.h 运行时)
//
// CppEmitter 复用 DartRestorer 的类信息收集、VTable 构建、泛型特化分析，
// 但使用独立的 C++ 代码发射逻辑。
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

  /// 变量名映射（用于处理变量名冲突）
  final Map<String, String> _variableNameMappings = {};

  /// 当前作用域中的闭包参数名称（用于解决 # 后缀变量名问题）
  final Set<String> _currentClosureParamNames = {};

  /// 变量类型映射（用于判断变量是否是 AnyPtr 类型）
  final Map<String, String> _variableTypeMap = {};

  /// catch 块中的引用变量名（使用 . 而非 -> 访问成员）
  final Set<String> _referenceVariables = {};

  /// 枚举常量索引映射：'EnumName.constantName' → index
  final Map<String, int> _enumConstantIndices = {};

  /// 函数返回类型映射：'funcName' → C++ return type
  final Map<String, String> _functionReturnTypes = {};

  /// 闭包计数器
  int _closureCounter = 0;

  /// 已发出的前向声明
  final Set<String> _emittedForwardDecls = {};

  /// 已发出的结构体定义
  final Set<String> _emittedStructs = {};

  /// 当前函数返回类型
  String _currentReturnType = 'void';

  /// 当前函数是否为 async 函数
  bool _isAsyncFunction = false;

  /// async 函数内部返回类型（Promise<T> 中的 T）
  String _asyncInnerType = 'AnyGC*';

  /// 泛型构造函数中期望的集合元素类型（用于将 StaticList<AnyGC*> 替换为正确的类型）
  String? _expectedCollectionElementType = null;

  /// 泛型构造函数中期望的 Map 键值类型
  String? _expectedMapKeyType = null;
  String? _expectedMapValueType = null;

  /// 当前类名
  String _currentClassName = '';

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

    // 第一遍：收集类信息（复用 DartRestorer 的分析逻辑）
    final restorer = DartRestorer();
    for (final lib in component.libraries) {
      final uri = lib.importUri.toString();
      if (uri.startsWith('dart:') || uri.startsWith('package:')) continue;
      restorer._collectClassInfo(lib);
    }

    // 复制分析结果
    _userClasses.addAll(restorer._userClasses);
    _mixinNames.addAll(restorer._mixinNames);
    _enumNames.addAll(restorer._enumNames);
    _classHierarchy.addAll(restorer._classHierarchy);
    _classVTableEntries.addAll(restorer._classVTableEntries);
    _classNodes.addAll(restorer._classNodes);
    _syntheticLoweredNames.addAll(restorer._syntheticLoweredNames);

    // 第二遍：预扫描泛型特化
    for (final lib in component.libraries) {
      final uri = lib.importUri.toString();
      if (uri.startsWith('dart:') || uri.startsWith('package:')) continue;
      restorer._collectMethodTypeSpecializations(lib);
    }
    _methodTypeSpecializations.addAll(restorer._methodTypeSpecializations);

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

      // 检查是否已经生成了这个方法
      if (_emittedForwardDecls.contains(funcName) ||
          _emittedForwardDecls.any((decl) => decl.contains('$funcName(')) ||
          _emittedImplementations.contains(funcName)) {
        continue; // 已经生成过了
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
          returnType = 'AnyPtr'; // 默认返回类型
        }
      } else if (isSetter) {
        returnType = 'void';
      } else {
        returnType = 'AnyPtr'; // 默认返回类型
      }

      // 收集参数 - 使用具体结构体类型而非 AnyPtr
      final clsTypeParams = cls.typeParameters;
      // 运行时类使用类名本身（如 Promise），用户类使用 ClassNameValue
      final structName = _isRuntimeClassName(className) ? className : '${className}Value';
      final structTemplateArgs = clsTypeParams.isNotEmpty
          ? '<${clsTypeParams.map((tp) => tp.name ?? 'T').join(', ')}>'
          : '';
      final params = <String>['$structName$structTemplateArgs* this__'];
      if (isSetter) {
        params.add('AnyPtr value');
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
            paramType = 'AnyPtr';
          }
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
            paramType = 'AnyPtr';
          }
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

      // 转换 this__ - 现在 this__ 已经是具体类型，直接赋值
      _implBuf.writeln('${_pad}auto this_ = this__;');

      // 检查是否有父类方法可以调用
      final superClass = cls.superclass;
      if (superClass != null && _userClasses.contains(superClass.name)) {
        // 为 getter/setter 添加 get_/set_ 前缀
        String prefixedMethodName;
        if (isGetter) {
          prefixedMethodName = 'get_$methodName';
        } else if (isSetter) {
          prefixedMethodName = 'set_$methodName';
        } else {
          prefixedMethodName = methodName;
        }
        final superMethodName = '${superClass.name}_$prefixedMethodName';
        // 如果父类也是模板类，需要传递模板参数
        final superTypeParams = superClass.typeParameters;
        String superTemplateArgs = '';
        if (superTypeParams.isNotEmpty) {
          if (clsTypeParams.isNotEmpty) {
            // 当前类也是模板类：使用当前类的模板参数
            superTemplateArgs = '<${clsTypeParams.take(superTypeParams.length).map((tp) => tp.name ?? 'T').join(', ')}>';
          } else {
            // 当前类是具体类：从 supertype 获取具体类型参数
            final clsNode = _classNodes[cls.name];
            if (clsNode != null && clsNode.supertype != null && clsNode.supertype!.typeArguments.isNotEmpty) {
              final args = clsNode.supertype!.typeArguments.map((t) => _cppType(t)).join(', ');
              superTemplateArgs = '<$args>';
            } else {
              // 回退：使用 AnyPtr
              superTemplateArgs = '<${superTypeParams.map((_) => 'AnyPtr').join(', ')}>';
            }
          }
        }
        final superCall = '$superMethodName$superTemplateArgs';
        // 当父类是模板类且当前类是具体类时，需要 static_cast 到父类模板实例
        // 运行时类使用类名本身（如 AsyncStateMachine），用户类使用 ClassNameValue
        final superStructName = _isRuntimeClassName(superClass.name)
            ? superClass.name
            : '${superClass.name}Value';
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
          _implBuf.writeln('${_pad}return $superCall($thisArg);');
        } else if (isSetter) {
          _implBuf.writeln('${_pad}$superCall($thisArg, value);');
        } else {
          // 检查父类方法是否返回 void
          final superProc = superClass.procedures.where((p) => p.name.text == entry.name && !p.isGetter && !p.isSetter).toList();
          final superReturnsVoid = superProc.isNotEmpty && _cppType(superProc.first.function.returnType) == 'void';
          if (superReturnsVoid) {
            _implBuf.writeln('${_pad}$superCall($thisArg$extraArgsStr);');
            _implBuf.writeln('${_pad}return AnyPtr::null();');
          } else {
            _implBuf.writeln('${_pad}return $superCall($thisArg$extraArgsStr);');
          }
        }
      } else {
        // 没有父类方法，返回默认值
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

      final params = <String>['$structName$templateArgs* this__'];
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
        params.add('$structName$templateArgs* this__');
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
    for (final field in cls.fields) {
      if (!field.isStatic) {
        fields.add(field);
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
          // 合成类的父类是 Object 或不存在，使用 VPtr
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
              final args = superTypeParams.map((_) => 'AnyPtr').join(', ');
              superName = '${superClean}Value<$args>';
            }
          }
        } else {
          superName = '${superClean}Value';
        }
      } else if (realBaseClassName == null && _syntheticLoweredNames.contains(superClassName)) {
        // 合成 mixin 中间类的基类是 Object，使用 VPtr
        superName = 'VPtr';
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
              final args = superTypeParams.map((_) => 'AnyPtr').join(', ');
              superName = '${superClean}Value<$args>';
            }
          }
        } else {
          superName = '${superClean}Value';
        }
      } else {
        superName = 'VPtr';
      }
    } else {
      superName = 'VPtr';
    }

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

    // vptr 映射（静态共享）
    _structBuf.writeln();
    _structBuf.writeln('    static std::unordered_map<std::string, void*> _vptrMap;');
    _structBuf.writeln('    std::unordered_map<std::string, void*>& getVptrMap() { return _vptrMap; }');

    // gcMark
    _structBuf.writeln();
    _structBuf.writeln('    void gcMark(int flag) override {');
    _structBuf.writeln('        if (this->gcFlag == flag) return;');
    _structBuf.writeln('        $superName::gcMark(flag);');
    for (final field in fields) {
      final fieldType = _cppType(field.type);
      if (_isGcPointerType(fieldType)) {
        final fieldName = _cleanName(field.name.text);
        _structBuf.writeln('        if ($fieldName) $fieldName->gcMark(flag);');
      }
    }
    _structBuf.writeln('    }');

    // 如果继承自 AsyncStateMachine，生成 step() override 委托给静态函数
    if (superClass != null && superClass.name == 'AsyncStateMachine') {
      final stepFuncName = '${_cleanName(cls.name)}_step';
      _structBuf.writeln();
      _structBuf.writeln('    bool step() override {');
      _structBuf.writeln('        return $stepFuncName(this);');
      _structBuf.writeln('    }');
    }

    _structBuf.writeln('};');
    _structBuf.writeln();

    // 静态 vptr 映射定义（模板类需要特殊处理）
    if (hasTemplate) {
      // 模板类的静态成员定义 — 使用 template 前缀
      final templateDecl = 'template<${typeParams.map((tp) => 'typename ${tp.name ?? 'T'}').join(', ')}>';
      final tplArgs = '<${typeParams.map((tp) => tp.name ?? 'T').join(', ')}>';
      _structBuf.writeln('$templateDecl std::unordered_map<std::string, void*> $structName$tplArgs::_vptrMap;');
    } else {
      _structBuf.writeln('std::unordered_map<std::string, void*> $structName::_vptrMap;');
    }
    _structBuf.writeln();

    // 类的静态字段声明为全局变量
    for (final field in cls.fields) {
      if (field.isStatic && !field.isConst) {
        final fieldName = _cleanName(field.name.text);
        final fieldType = _cppType(field.type);
        final defaultVal = _cppDefaultValue(fieldType);
        if (field.initializer != null) {
          final initVal = _emitCppExpr(field.initializer!);
          _implBuf.writeln('$fieldType $fieldName = $initVal;');
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
    final templatePrefix = hasTemplate
        ? 'template<${typeParams.map((tp) => 'typename ${tp.name ?? 'T'}').join(', ')}>'
        : '';
    final templateArgs = hasTemplate
        ? '<${typeParams.map((tp) => tp.name ?? 'T').join(', ')}>'
        : '';

    // 收集参数（实现中不添加默认值）
    final params = <String>['$structName$templateArgs* this__'];
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

    // 转换 this__
    _implBuf.writeln('${_pad}auto this_ = this__;');

    // 初始化 vptr（仅在第一个构造函数中）
    final vtableEntries = _classVTableEntries[className] ?? [];
    if (vtableEntries.isNotEmpty && ctorName == 'new') {
      _implBuf.writeln('${_pad}if ($structName$templateArgs::_vptrMap.empty()) {');
      for (final entry in vtableEntries) {
        final methodName = _cleanMethodName(entry.name);
        // 根据 entry 类型确定目标函数名
        String targetFuncName;
        if (entry.kind == 'getter') {
          targetFuncName = '${cleanClassName}_get_$methodName';
        } else if (entry.kind == 'setter') {
          targetFuncName = '${cleanClassName}_set_$methodName';
        } else {
          targetFuncName = '${cleanClassName}_$methodName';
        }
        // 如果是模板类，需要指定模板参数
        String funcRef;
        if (hasTemplate) {
          // 检查方法是否有额外的类型参数（如 Pair<A,B>.mapFirst<C>）
          final methodTypeParams = entry.proc?.function.typeParameters ?? [];
          if (methodTypeParams.isNotEmpty) {
            // 去重：排除类已有的模板参数
            final classParamNames = classNode?.typeParameters.map((tp) => tp.name ?? 'T').toSet() ?? {};
            final extraParams = methodTypeParams.where((tp) => !classParamNames.contains(tp.name ?? 'T')).toList();
            if (extraParams.isNotEmpty) {
              final classArgsList = typeParams.map((tp) => tp.name ?? 'T').toList();
              final allArgs = [
                ...classArgsList,
                ...extraParams.map((_) => 'AnyPtr'),
              ];
              funcRef = '$targetFuncName<${allArgs.join(', ')}>';
            } else {
              funcRef = '$targetFuncName$templateArgs';
            }
          } else {
            funcRef = '$targetFuncName$templateArgs';
          }
        } else {
          funcRef = targetFuncName;
        }

        // 构建精确的函数指针类型用于消歧（当存在同名重载时）
        final funcPtrCast = _buildVptrFuncPtrCast(entry, funcRef, structName, hasTemplate, templateArgs, classNode);
        // vptr key 需要区分 getter/setter/方法，避免同名冲突
        final vptrKey = entry.kind == 'getter' ? 'get_$methodName'
            : entry.kind == 'setter' ? 'set_$methodName'
            : methodName;
        _implBuf.writeln('${_pad}    $structName$templateArgs::_vptrMap["$vptrKey"] = $funcPtrCast;');
      }
      _implBuf.writeln('${_pad}}');
    }

    // 处理初始化器
    if (ctor.initializers.isNotEmpty) {
      for (final init in ctor.initializers) {
        _emitCppInitializer(init, structName);
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
      _implBuf.writeln('${_pad}this_->$fieldName = $value;');
    } else if (init is SuperInitializer) {
      // Skip Object super constructor calls
      final superClassName = init.target.enclosingClass.name;
      if (superClassName != 'Object' && !superClassName.contains('&')) {
        // 如果父类是运行时类（如 AsyncStateMachine），跳过 super 调用
        // C++ 会自动调用父类构造函数
        if (_isRuntimeClassName(superClassName)) {
          return;
        }
        final cleanSuperName = _cleanName(superClassName);
        final superCtorName = init.target.name.text.isEmpty ? 'new' : 'new_${_cleanName(init.target.name.text)}';
        final superFuncName = '${cleanSuperName}_$superCtorName';
        final args = init.arguments.positional.map((e) => _emitCppExpr(e)).join(', ');

        // 检查父类是否为模板类，需要传递模板参数
        String superTemplateArgs = '';
        final superCls = init.target.enclosingClass;
        final superTypeParams = superCls.typeParameters;
        if (superTypeParams.isNotEmpty) {
          // 尝试从当前类的 supertype 获取具体类型参数
          final clsNode = _classNodes[_currentClassName];
          if (clsNode != null && clsNode.supertype != null && clsNode.supertype!.typeArguments.isNotEmpty) {
            final typeArgs = clsNode.supertype!.typeArguments.map((t) => _cppType(t)).join(', ');
            superTemplateArgs = '<$typeArgs>';
          } else {
            superTemplateArgs = '<${superTypeParams.map((_) => 'AnyPtr').join(', ')}>';
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
    _variableNameMappings.clear();
    _declaredVariables.clear();

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
      return;
    }
    _emittedImplementations.add(funcName);

    final func = proc.function;

    // 检测 async 方法
    final isAsync = func.asyncMarker == AsyncMarker.Async;
    final isSyncStar = func.asyncMarker == AsyncMarker.SyncStar;
    _isAsyncFunction = isAsync;

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
    } else if (isSyncStar) {
      // sync* 生成器：返回 StaticList<T>*
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
      if (!returnType.startsWith('Promise<')) {
        returnType = 'Promise<$innerType>*';
      }
    }

    // 如果返回类型是模板类本身，需要添加模板参数
    if (hasTemplate && returnType == '$structName*') {
      returnType = '$structName$templateArgs*';
    }

    _currentReturnType = returnType;
    _currentClassName = className;

    // 跟踪函数返回类型（用于后续类型推断）
    _functionReturnTypes[funcName] = returnType;

    // 收集参数 - 使用具体结构体类型而非 AnyPtr
    final params = <String>[];
    if (!proc.isStatic) {
      // 运行时类使用运行时名称（如 Promise<T>*），用户类使用 ClassNameValue
      final thisType = _isRuntimeClassName(className)
          ? '$className$templateArgs'
          : '$structName$templateArgs';
      params.add('$thisType* this__');
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
    final combinedTemplatePrefix = allTypeParams.isNotEmpty
        ? 'template<${allTypeParams.map((tp) => 'typename ${tp.name ?? 'T'}').join(', ')}>'
        : '';

    // 函数实现（带模板前缀）
    if (combinedTemplatePrefix.isNotEmpty) {
      _implBuf.writeln(combinedTemplatePrefix);
    }
    _implBuf.writeln('$returnType $funcName(${params.join(', ')}) {');
    _indent = 1;

    // 转换 this__ - 现在 this__ 已经是具体类型，直接赋值
    if (!proc.isStatic) {
      _implBuf.writeln('${_pad}auto this_ = this__;');
    }

    // async 方法：创建 Promise 包装
    if (isAsync && !proc.isGetter && !proc.isSetter) {
      _implBuf.writeln('${_pad}auto _promise = GC::allocateLocal(new Promise<$_asyncInnerType>());');
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

    // async 方法：添加兜底 complete 和 return
    if (isAsync && !proc.isGetter && !proc.isSetter) {
      _implBuf.writeln('${_pad}_promise->complete(AnyPtr::null());');
      _implBuf.writeln('${_pad}return _promise;');
    } else if (returnType != 'void' && (func.body == null || _isEmptyBody(func.body!))) {
      // 非 async 方法：如果函数体为空且返回类型不是 void，添加默认返回
      if (proc.isGetter && !proc.isStatic) {
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
        _implBuf.writeln('${_pad}return $defaultReturn;');
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
  }

  /// 生成工厂构造函数作为顶层函数（ClassName_new 或 ClassName_new_factoryName）
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
      _implBuf.writeln('${_pad}return GC::allocateLocal(new $structName$templateArgs());');
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

  void _emitCppProcedure(Procedure proc) {
    final rawName = proc.name.text;
    // 跳过 mixin 应用类的 lowered 函数（合成类，由 mixin 初始化链处理）
    if (rawName.contains('&')) return;

    // 保存并清除外部作用域的变量名映射
    final savedVarNameMappings = Map<String, String>.from(_variableNameMappings);
    final savedVariableTypeMap = Map<String, String>.from(_variableTypeMap);
    final savedDeclaredVariables = Set<String>.from(_declaredVariables);
    _variableNameMappings.clear();
    _declaredVariables.clear();

    final funcName = _cleanName(rawName);
    final func = proc.function;

    // 检测 async 函数
    final isAsync = func.asyncMarker == AsyncMarker.Async;
    final isSyncStar = func.asyncMarker == AsyncMarker.SyncStar;
    _isAsyncFunction = isAsync;

    // 特殊处理 main 函数：C++ 要求返回 int
    final isMainFunc = funcName == 'main';
    String returnType;
    if (isMainFunc) {
      returnType = 'int';
    } else if (isSyncStar) {
      // sync* 生成器：返回 StaticList<T>*
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
      _implBuf.writeln('${_pad}_promise->complete(AnyPtr::null());');
      _implBuf.writeln('${_pad}return _promise;');
    } else {
      if (func.body != null) {
        _emitCppStmt(func.body!, _implBuf);
      }
      // main 函数需要返回 0
      if (isMainFunc) {
        _implBuf.writeln('${_pad}return 0;');
      }
    }

    _implBuf.writeln('}\n');
    _indent = 0;

    // 重置异步标志
    _isAsyncFunction = false;
    _asyncInnerType = 'AnyPtr';

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

  /// 从 Future/Promise 类型中提取内部类型
  String _extractPromiseInnerType(DartType type) {
    if (type is InterfaceType) {
      if (type.classNode.name == 'Future' || type.classNode.name == '_Future') {
        if (type.typeArguments.isNotEmpty) {
          return _cppType(type.typeArguments[0]);
        }
      }
    }
    if (type is FutureOrType) {
      return _cppType(type.typeArgument);
    }
    // 无法提取时，使用 AnyPtr
    return 'AnyPtr';
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
    return 'AnyPtr';
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

    // 生成枚举结构体
    _structBuf.writeln('struct $enumName : VPtr {');
    _structBuf.writeln('    std::string _name;');
    _structBuf.writeln('    int64_t _index;');
    _structBuf.writeln();

    for (final val in enumValues) {
      final cleanVal = _cleanName(val);
      _structBuf.writeln('    static $enumName* $cleanVal;');
    }
    _structBuf.writeln();

    _structBuf.writeln('    $enumName(std::string n, int64_t i) : _name(std::move(n)), _index(i) {');
    _structBuf.writeln('        GC::allocateLocal(this);');
    _structBuf.writeln('    }');
    _structBuf.writeln();

    _structBuf.writeln('    std::string toString() override { return _name; }');
    _structBuf.writeln('};');
    _structBuf.writeln();

    // 静态实例
    for (var i = 0; i < enumValues.length; i++) {
      final cleanVal = _cleanName(enumValues[i]);
      _structBuf.writeln('$enumName* $enumName::$cleanVal = new $enumName("${enumValues[i]}", $i);');
      _enumConstantIndices['$enumName.${enumValues[i]}'] = i;
    }
    _structBuf.writeln();
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
    if (templatePrefix.isNotEmpty) {
      _structBuf.writeln('$templatePrefix');
    }
    _structBuf.writeln('struct $structName : AnyGC {');
    _structBuf.writeln('    static std::unordered_map<std::string, void*> _vptrMap;');
    _structBuf.writeln('    std::unordered_map<std::string, void*>& getVptrMap() { return _vptrMap; }');
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
      _structBuf.writeln('$templateDecl std::unordered_map<std::string, void*> $structName$tplArgs::_vptrMap;');
    } else {
      _structBuf.writeln('std::unordered_map<std::string, void*> $structName::_vptrMap;');
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

      // 收集参数 - 使用具体结构体类型
      final params = <String>[];
      if (!proc.isStatic) {
        final mixinTemplateArgs = hasTemplate
            ? '<${typeParams.map((tp) => tp.name ?? 'T').join(', ')}>'
            : '';
        params.add('$structName$mixinTemplateArgs* this__');
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

      // 设置当前返回类型（确保 return 语句正确处理）
      final savedReturnType = _currentReturnType;
      _currentReturnType = returnType;
      final savedClassName = _currentClassName;
      _currentClassName = mixinName;

      // 转换 this__ - 使用 mixin 结构体类型
      if (!proc.isStatic) {
        _implBuf.writeln('${_pad}auto this_ = this__;');
      }

      // 函数体
      if (func.body != null) {
        _emitCppStmt(func.body!, _implBuf);
      }

      // 如果函数体为空且返回类型不是 void，添加默认返回
      if (returnType != 'void' && (func.body == null || _isEmptyBody(func.body!))) {
        if (proc.isGetter && !proc.isStatic) {
          // Getter 函数：检查是否有对应字段
          final fieldName = _cleanName(methodName);
          final hasField = cls.fields.any((f) => _cleanName(f.name.text) == fieldName);
          if (hasField) {
            _implBuf.writeln('${_pad}return this_->$fieldName;');
          } else {
            final defaultReturn = _cppDefaultValue(returnType);
            _implBuf.writeln('${_pad}return $defaultReturn;');
          }
        } else {
          final defaultReturn = _cppDefaultValue(returnType);
          _implBuf.writeln('${_pad}return $defaultReturn;');
        }
      }

      _implBuf.writeln('}\n');
      _indent = 0;
      _currentReturnType = savedReturnType;
      _currentClassName = savedClassName;
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
    if (expr is NullLiteral) return 'AnyPtr::null()';

    if (expr is VariableGet) return _emitCppVariableGet(expr);
    if (expr is VariableSet) return _emitCppVariableSet(expr);
    if (expr is ThisExpression) return 'this_';

    if (expr is InstanceGet) return _emitCppInstanceGet(expr);
    if (expr is InstanceSet) return _emitCppInstanceSet(expr);
    if (expr is InstanceInvocation) return _emitCppInstanceInvocation(expr);
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
      if ((right == 'nullptr' || right == 'AnyPtr::null()') && left.startsWith('(*(*') && left.endsWith(')')) {
        // 移除外层解引用：(*(*map)[key]) -> (*map)[key]
        final ptrExpr = left.substring(2, left.length - 1);
        return '($ptrExpr == nullptr)';
      }
      if ((left == 'nullptr' || left == 'AnyPtr::null()') && right.startsWith('(*(*') && right.endsWith(')')) {
        final ptrExpr = right.substring(2, right.length - 1);
        return '($ptrExpr == nullptr)';
      }
      // AnyGC* 与具体类型比较：拆箱
      final leftIsAnyGC = _isAnyGCPtrExpr(left);
      final rightIsAnyGC = _isAnyGCPtrExpr(right);
      if (leftIsAnyGC && !rightIsAnyGC) {
        final unwrapped = _unwrapAnyGCForComparison(left, right);
        if (unwrapped != null) return '($unwrapped == $right)';
      }
      if (rightIsAnyGC && !leftIsAnyGC) {
        final unwrapped = _unwrapAnyGCForComparison(right, left);
        if (unwrapped != null) return '($left == $unwrapped)';
      }
      return '($left == $right)';
    }
    if (expr is EqualsNull) {
      final operand = _emitCppExpr(expr.expression);
      // 当检查 map[key] == null 时，检查指针而不是解引用的值
      if (operand.startsWith('(*(*') && operand.endsWith(')')) {
        final ptrExpr = operand.substring(2, operand.length - 1);
        return '($ptrExpr == nullptr)';
      }
      // 根据类型选择不同的空值检查方式
      final type = _getExpressionType(expr.expression);
      if (type != null) {
        final cppType = _cppType(type);
        // 对于 AnyGC* 类型，使用 == nullptr
        if (cppType == 'AnyGC*') {
          return '($operand == nullptr)';
        }
        // 对于指针类型，使用 == nullptr
        if (cppType.endsWith('*')) {
          return '($operand == nullptr)';
        }
        // 对于基本类型（int, double, bool, std::string），它们不能为 null
        if (cppType == 'int64_t' || cppType == 'double' || cppType == 'bool' || cppType == 'std::string') {
          return 'false';  // 基本类型不能为 null
        }
      }
      // 默认使用 == nullptr
      return '($operand == nullptr)';
    }

    if (expr is Let) return _emitCppLet(expr);
    if (expr is ConstantExpression) return _emitCppConstant(expr.constant);
    if (expr is BlockExpression) return _emitCppBlockExpression(expr);

    // Dynamic dispatch expressions
    if (expr is DynamicInvocation) return _emitCppDynamicInvocation(expr);
    if (expr is DynamicGet) return _emitCppDynamicGet(expr);
    if (expr is DynamicSet) return _emitCppDynamicSet(expr);

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
  // Dynamic dispatch expressions
  // ==========================================================================

  String _emitCppDynamicInvocation(DynamicInvocation expr) {
    final rawReceiver = _emitCppExpr(expr.receiver);
    final methodName = _cleanName(expr.name.text);
    final args = expr.arguments.positional.map((e) => _emitCppExpr(e)).join(', ');

    // 检查接收器类型，对已知类型使用直接调用
    final receiverType = _getExpressionType(expr.receiver);
    // 将 AnyPtr 接收器转换为真实类型（仿照 Dart 的 dynamic dispatch）
    final receiver = _castReceiverToType(rawReceiver, receiverType);

    // 检查是否是运算符
    if (_isOperatorName(expr.name.text)) {
      return _emitCppOperatorCall(expr, rawReceiver, expr.name.text, args);
    }

    // 检查是否是索引操作符 [] / []=
    if (expr.name.text == '[]') {
      final index = args;
      return '$receiver->get($index)';
    }
    if (expr.name.text == '[]=') {
      final argList = args.split(',');
      if (argList.length >= 2) {
        return '$receiver->set(${argList[0].trim()}, ${argList[1].trim()})';
      }
    }

    // 如果接收器表达式是 std::string 类型，处理字符串方法
    if (_cppExprReturnsString(receiver) || receiver.startsWith('dynAs<std::string>')) {
      final strResult = _emitCppStringMethodCall(receiver, methodName, args);
      if (strResult != null) return strResult;
    }

    if (receiverType != null) {
      // 检查是否为基本类型（int, double, bool, String）
      if (_isPrimitiveType(receiverType)) {
        return _emitCppPrimitiveMethodCall(receiver, methodName, args, receiverType);
      }

      if (receiverType is InterfaceType) {
        final typeName = receiverType.classNode.name;
        // 集合类型
        if (typeName == 'List' || typeName == 'Set' || typeName == 'Map' || typeName == 'Iterable' ||
            typeName == 'StaticList' || typeName == 'StaticSet' || typeName == 'StaticMap' ||
            typeName == 'StaticIterator' || typeName == 'Array' || typeName == 'Iterator' ||
            typeName.contains('Iterator')) {
          return _emitCppCollectionMethodCall(receiver, methodName, args, receiverType);
        }
        if (typeName == 'Promise' || typeName == 'Future') {
          return _emitCppPromiseMethodCall(receiver, methodName, args, receiverType);
        }
        if (typeName == 'StringBuffer' || typeName == 'StaticStringBuffer') {
          return _emitCppStringBufferMethodCall(receiver, methodName, args);
        }
        if (typeName == 'GlobalScheduler') {
          return _emitCppGlobalSchedulerMethodCall(receiver, methodName, args);
        }
      }
    }

    // 动态方法调用 → 通过 vptr 派发
    // 对 AnyPtr 值类型使用 .toVPtr() 转换后再访问 getVptrMap()
    // 对 AnyGC* 使用 static_cast<VPtr*>() 转换
    final argCount = expr.arguments.positional.length;
    String vptrReceiver = receiver;
    if (_needsToVPtr(receiver, receiverType)) {
      vptrReceiver = _convertToVPtr(receiver, receiverType);
    }
    // 使用 vptrReceiver（VPtr*）作为 this__ 参数，可隐式转换为 AnyGC*
    final allArgs = args.isNotEmpty ? '$vptrReceiver, $args' : vptrReceiver;
    final fnType = _vptrFnType(argCount);
    return '(reinterpret_cast<$fnType>($vptrReceiver->getVptrMap()["$methodName"]))($allArgs)';
  }

  String _emitCppDynamicGet(DynamicGet expr) {
    final rawReceiver = _emitCppExpr(expr.receiver);
    final fieldName = _cleanName(expr.name.text);

    // 对引用变量（如 catch 块中的异常变量），直接访问字段
    if (_referenceVariables.contains(rawReceiver)) {
      return '$rawReceiver.$fieldName';
    }

    // 检查接收器类型，对已知类型使用直接属性访问
    final receiverType = _getExpressionType(expr.receiver);
    // 将 AnyPtr 接收器转换为真实类型
    final receiver = _castReceiverToType(rawReceiver, receiverType);

    if (receiverType is InterfaceType) {
      final typeName = receiverType.classNode.name;
      if (typeName == 'Promise' || typeName == 'Future') {
        return _emitCppPromiseGetter(receiver, fieldName);
      }
      if (typeName == 'GlobalScheduler') {
        // GlobalScheduler.instance → GlobalScheduler::instance()
        if (fieldName == 'instance') return 'GlobalScheduler::instance()';
      }
      // String 属性
      if (typeName == 'String') {
        switch (fieldName) {
          case 'isEmpty': return '$receiver.empty()';
          case 'isNotEmpty': return '!$receiver.empty()';
          case 'length': return 'static_cast<int64_t>($receiver.length())';
        }
      }
    }

    // 基于 C++ 表达式模式的 fallback：StaticList/StaticMap/StaticSet 不需要 vptr 派发
    if (receiver.contains('StaticList<') || receiver.contains('StaticSet<') || receiver.contains('StaticMap<')) {
      switch (fieldName) {
        case 'length': return '$receiver->length()';
        case 'isEmpty': return '$receiver->isEmpty()';
        case 'isNotEmpty': return '$receiver->isNotEmpty()';
        case 'first': return '$receiver->first()';
        case 'last': return '$receiver->last()';
        case 'iterator': return '$receiver->iterator()';
        case 'keys': return '$receiver->keys()';
        case 'values': return '$receiver->values()';
        case 'entries': return '$receiver->entries()';
      }
    }

    // 通过 vptr 派发 getter（使用 "get_" 前缀与 vptr 注册一致）
    String vptrReceiver = receiver;
    if (_needsToVPtr(receiver, receiverType)) {
      vptrReceiver = _convertToVPtr(receiver, receiverType);
    }
    return '(reinterpret_cast<AnyPtr(*)(AnyGC*)>($vptrReceiver->getVptrMap()["get_$fieldName"]))($vptrReceiver)';
  }

  String _emitCppDynamicSet(DynamicSet expr) {
    final receiver = _emitCppExpr(expr.receiver);
    final fieldName = _cleanName(expr.name.text);
    final value = _emitCppExpr(expr.value);
    final receiverType = _getExpressionType(expr.receiver);
    // 通过 vptr 派发 setter
    String vptrReceiver = receiver;
    if (_needsToVPtr(receiver, receiverType)) {
      vptrReceiver = _convertToVPtr(receiver, receiverType);
    }
    return '(reinterpret_cast<void(*)(AnyGC*, AnyPtr)>($vptrReceiver->getVptrMap()["set_$fieldName"]))($vptrReceiver, $value)';
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
        if (typeName == 'Promise' || typeName == 'Future' || typeName == '_Promise') {
          return _emitCppPromiseGetter(receiver, methodName);
        }
        // String 属性
        if (typeName == 'String') {
          String actualReceiver = receiver;
          if (_isAnyPtrExpr(receiver)) {
            actualReceiver = '$receiver.toStringValue()';
          }
          switch (methodName) {
            case 'isEmpty': return '$actualReceiver.empty()';
            case 'isNotEmpty': return '!$actualReceiver.empty()';
            case 'length': return 'static_cast<int64_t>($actualReceiver.length())';
          }
        }
        // 集合类型属性
        if (typeName == 'List' || typeName == 'StaticList') {
          switch (methodName) {
            case 'length': return '$receiver->length()';
            case 'isEmpty': return '$receiver->isEmpty()';
            case 'isNotEmpty': return '$receiver->isNotEmpty()';
            case 'first': return '$receiver->first()';
            case 'last': return '$receiver->last()';
            case 'iterator': return '$receiver->iterator()';
          }
        }
        if (typeName == 'Map' || typeName == 'StaticMap') {
          switch (methodName) {
            case 'length': return '$receiver->length()';
            case 'isEmpty': return '$receiver->isEmpty()';
            case 'isNotEmpty': return '$receiver->isNotEmpty()';
            case 'keys': return '$receiver->keys()';
            case 'values': return '$receiver->values()';
            case 'entries': return '$receiver->entries()';
          }
        }
        if (typeName == 'Set' || typeName == 'StaticSet') {
          switch (methodName) {
            case 'length': return '$receiver->length()';
            case 'isEmpty': return '$receiver->isEmpty()';
            case 'isNotEmpty': return '$receiver->isNotEmpty()';
          }
        }
        if (typeName == 'Iterator') {
          if (methodName == 'current') return '$receiver->current()';
        }
        if (typeName == 'Array') {
          if (methodName == 'length') return '$receiver->length()';
        }
        // StringBuffer
        if (typeName == 'StringBuffer' || typeName == 'StaticStringBuffer') {
          if (methodName == 'length') return '$receiver->length()';
          if (methodName == 'isEmpty') return '$receiver->isEmpty()';
        }
      }

      // 基于 C++ 表达式模式的 fallback：StaticList/StaticMap/StaticSet
      if (rawReceiver.contains('StaticList<') || rawReceiver.contains('StaticSet<') || rawReceiver.contains('StaticMap<')) {
        switch (methodName) {
          case 'length': return '$receiver->length()';
          case 'isEmpty': return '$receiver->isEmpty()';
          case 'isNotEmpty': return '$receiver->isNotEmpty()';
          case 'first': return '$receiver->first()';
          case 'last': return '$receiver->last()';
          case 'iterator': return '$receiver->iterator()';
          case 'keys': return '$receiver->keys()';
          case 'values': return '$receiver->values()';
          case 'entries': return '$receiver->entries()';
        }
      }

      // 通过 vptr 派发 getter 调用（使用 "get_" 前缀与 vptr 注册一致）
      String vptrReceiver = receiver;
      if (_needsToVPtr(receiver, receiverType)) {
        vptrReceiver = _convertToVPtr(receiver, receiverType);
      }
      // 使用目标方法的返回类型生成更精确的函数指针类型
      final getterFnType = _vptrFnTypeForTarget(target, 0);
      return '(reinterpret_cast<$getterFnType>($vptrReceiver->getVptrMap()["get_$methodName"]))($vptrReceiver)';
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
    final positional = expr.positional.map((e) => _emitCppExpr(e)).toList();
    final named = <String>[];
    for (final ne in expr.named) {
      named.add('${_cleanName(ne.name)}: ${_emitCppExpr(ne.value)}');
    }
    // 使用堆分配的 std::tuple 表示 Record（转换为 AnyGC* 传递）
    if (named.isEmpty && positional.isNotEmpty) {
      return 'reinterpret_cast<AnyGC*>(new std::tuple(${positional.join(', ')}))';
    }
    // 带命名字段的 Record：只使用值（std::tuple 不支持命名字段）
    final namedValues = named.map((n) {
      // 从 "name: value" 中提取 value
      final colonIdx = n.indexOf(':');
      return colonIdx >= 0 ? n.substring(colonIdx + 1).trim() : n;
    }).toList();
    final allElements = [...positional, ...namedValues];
    return 'reinterpret_cast<AnyGC*>(new std::tuple(${allElements.join(', ')}))';
  }

  String _emitCppRecordIndexGet(RecordIndexGet expr) {
    final receiver = _emitCppExpr(expr.receiver);
    // Record 索引：Kernel 使用 0-based，std::tuple 也是 0-based
    final index = expr.index;
    // 使用 RecordIndexGet 自带的 receiverType（比从表达式推断更可靠）
    final recordType = expr.receiverType;
    final tupleTypes = recordType.positional.map(_cppType).join(', ');
    // 将 AnyGC* 转换为 tuple 指针并解引用
    return 'std::get<$index>(*reinterpret_cast<std::tuple<$tupleTypes>*>($receiver))';
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
    return 'std::get<$tupleIndex>(*reinterpret_cast<std::tuple<$tupleTypes>*>($receiver))';
  }

  // ==========================================================================
  // Symbol and Type literals
  // ==========================================================================

  String _emitCppSymbolLiteral(SymbolLiteral expr) {
    // Symbol → 字符串表示
    return _cppStringLiteral('#${expr.value}');
  }

  String _emitCppTypeLiteral(TypeLiteral expr) {
    // Type as value → 类型名字符串
    final typeStr = expr.type.toString();
    return _cppStringLiteral(typeStr);
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
    // Tear-off → 创建 TypeFunction 包装，捕获 receiver
    final closureId = _closureCounter++;
    final className = '${_currentClassName}Value';
    _structBuf.writeln('struct TearOff_$closureId : TypeFunction0<AnyPtr> {');
    _structBuf.writeln('    $className* recv_;');
    _structBuf.writeln('    TearOff_$closureId($className* r) : recv_(r) {}');
    _structBuf.writeln('    AnyPtr call() override {');
    _structBuf.writeln('        return (reinterpret_cast<AnyPtr(*)(AnyGC*)>(recv_->getVptrMap()["$methodName"]))(recv_);');
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
    return 'std::string("$escaped")';
  }

  String _emitCppVariableGet(VariableGet expr) {
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
    // 如果值是 AnyPtr 但变量类型是具体类型，自动解包
    var varCppType = _cppType(expr.variable.type);
    if (varCppType.isEmpty || varCppType == 'AnyPtr') {
      // 从类型映射中查找
      varCppType = _variableTypeMap[mappedName] ?? varCppType;
    }
    final unwrappedValue = _unwrapFromAnyPtrIfNeeded(value, varCppType);
    return '($mappedName = $unwrappedValue)';
  }

  String _emitCppInstanceGet(InstanceGet expr) {
    final rawReceiver = _emitCppExpr(expr.receiver);
    final fieldName = _cleanName(expr.name.text);

    // 对引用变量（如 catch 块中的异常变量），直接访问字段
    if (_referenceVariables.contains(rawReceiver)) {
      return '$rawReceiver.$fieldName';
    }

    // 检查接收器类型
    final receiverType = _getExpressionType(expr.receiver);
    // 将 AnyPtr 接收器转换为真实类型（仿照 Dart 的 dynamic dispatch）
    final receiver = _castReceiverToType(rawReceiver, receiverType);

    if (receiverType != null) {
      final cppType = _cppType(receiverType);

      // 特殊处理 String 类型的属性
      if (receiverType is InterfaceType && receiverType.classNode.name == 'String') {
        // 检查是否是可空类型
        final isNullable = receiverType.nullability == Nullability.nullable;
        switch (fieldName) {
          case 'isEmpty':
            // std::string 是非空的，直接使用 empty()
            return '$receiver.empty()';
          case 'isNotEmpty':
            // std::string 是非空的，直接使用 !empty()
            return '!$receiver.empty()';
          case 'length':
            // std::string 是非空的，直接调用 length()
            return 'static_cast<int64_t>($receiver.length())';
          case 'hashCode':
            return 'static_cast<int64_t>(std::hash<std::string>{}($receiver))';
        }
      }

      // 特殊处理 int/double 类型的属性
      if (receiverType is InterfaceType && (receiverType.classNode.name == 'int' || receiverType.classNode.name == 'double')) {
        if (fieldName == 'hashCode') {
          if (receiverType.classNode.name == 'int') {
            return 'static_cast<int64_t>($receiver)';
          } else {
            return 'static_cast<int64_t>(std::hash<double>{}($receiver))';
          }
        }
      }

      // 特殊处理 StaticList 类型的属性
      if (receiverType is InterfaceType && (receiverType.classNode.name == 'List' || receiverType.classNode.name == 'StaticList')) {
        switch (fieldName) {
          case 'length':
            return '$receiver->length()';
          case 'isEmpty':
            return '$receiver->isEmpty()';
          case 'isNotEmpty':
            return '$receiver->isNotEmpty()';
          case 'first':
            return '$receiver->first()';
          case 'last':
            return '$receiver->last()';
          case 'reversed':
            return '$receiver->reversed()';
          case 'iterator':
            return '$receiver->iterator()';
        }
      }

      // 特殊处理 Iterator 类型的属性
      if (receiverType is InterfaceType && receiverType.classNode.name == 'Iterator') {
        switch (fieldName) {
          case 'current':
            return '$receiver->current()';
        }
      }

      // 特殊处理 Array 类型的属性
      if (receiverType is InterfaceType && receiverType.classNode.name == 'Array') {
        switch (fieldName) {
          case 'length':
            return '$receiver->length()';
          case 'isEmpty':
            return '($receiver->length() == 0)';
          case 'isNotEmpty':
            return '($receiver->length() > 0)';
        }
      }

      // 特殊处理 StaticMap 类型的属性
      if (receiverType is InterfaceType && (receiverType.classNode.name == 'Map' || receiverType.classNode.name == 'StaticMap')) {
        switch (fieldName) {
          case 'length':
            return '$receiver->length()';
          case 'isEmpty':
            return '$receiver->isEmpty()';
          case 'isNotEmpty':
            return '$receiver->isNotEmpty()';
          case 'keys':
            return '$receiver->keys()';
          case 'values':
            return '$receiver->values()';
          case 'entries':
            return '$receiver->entries()';
        }
      }

      // 特殊处理 StaticSet 类型的属性
      if (receiverType is InterfaceType && (receiverType.classNode.name == 'Set' || receiverType.classNode.name == 'StaticSet')) {
        switch (fieldName) {
          case 'length':
            return '$receiver->length()';
          case 'isEmpty':
            return '$receiver->isEmpty()';
          case 'isNotEmpty':
            return '$receiver->isNotEmpty()';
          case 'first':
            return '$receiver->first()';
          case 'last':
            return '$receiver->last()';
          case 'iterator':
            return '$receiver->iterator()';
        }
      }

      // 特殊处理 Promise/Future 类型的属性
      if (receiverType is InterfaceType && (receiverType.classNode.name == 'Promise' || receiverType.classNode.name == 'Future')) {
        return _emitCppPromiseGetter(receiver, fieldName);
      }

      // 特殊处理 StringBuffer 类型的属性
      if (receiverType is InterfaceType && (receiverType.classNode.name == 'StringBuffer' || receiverType.classNode.name == 'StaticStringBuffer')) {
        switch (fieldName) {
          case 'length': return '$receiver->length()';
          case 'isEmpty': return '$receiver->isEmpty()';
          case 'isNotEmpty': return '$receiver->isNotEmpty()';
          default: return '$receiver->$fieldName';
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

    // 基于 C++ 表达式模式的 fallback：StaticList/StaticMap/StaticSet
    if (receiver.contains('StaticList<') || receiver.contains('StaticSet<') || receiver.contains('StaticMap<')) {
      switch (fieldName) {
        case 'length': return '$receiver->length()';
        case 'isEmpty': return '$receiver->isEmpty()';
        case 'isNotEmpty': return '$receiver->isNotEmpty()';
        case 'first': return '$receiver->first()';
        case 'last': return '$receiver->last()';
        case 'iterator': return '$receiver->iterator()';
        case 'keys': return '$receiver->keys()';
        case 'values': return '$receiver->values()';
        case 'entries': return '$receiver->entries()';
      }
    }

    // 后备：检查接收器是否返回 std::string（基于 C++ 表达式模式）
    if (_cppExprReturnsString(receiver)) {
      switch (fieldName) {
        case 'isEmpty': return '$receiver.empty()';
        case 'isNotEmpty': return '!$receiver.empty()';
        case 'length': return 'static_cast<int64_t>($receiver.length())';
        case 'hashCode': return 'static_cast<int64_t>(std::hash<std::string>{}($receiver))';
      }
    }

    // 检查是否是 getter（通过 interfaceTarget）
    final target = expr.interfaceTarget;
    if (target is Procedure && target.isGetter) {
      // 通过 vptr 访问 getter（使用 "get_" 前缀与 vptr 注册一致）
      String vptrReceiver = receiver;
      if (_needsToVPtr(receiver, receiverType)) {
        vptrReceiver = _convertToVPtr(receiver, receiverType);
      }
      final vptrCall = '(reinterpret_cast<AnyPtr(*)(AnyGC*)>($vptrReceiver->getVptrMap()["get_$fieldName"]))($vptrReceiver)';
      // 如果 getter 返回基本类型，需要从 AnyPtr 提取值
      final returnType = target.function.returnType;
      if (returnType is InterfaceType) {
        final returnTypeName = returnType.classNode.name;
        if (returnTypeName == 'int') return '$vptrCall.toInt()';
        if (returnTypeName == 'double') return '$vptrCall.toDouble()';
        if (returnTypeName == 'bool') return '$vptrCall.toBool()';
        if (returnTypeName == 'String') return '$vptrCall.toStringValue()';
      }
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

    // 默认使用 -> 访问指针，但对引用类型使用 .
    if (_referenceVariables.contains(receiver)) {
      return '$receiver.$fieldName';
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

    // 如果值是 AnyPtr 但字段是具体类型，需要解包
    String convertedValue = value;
    if (fieldCppType != null && fieldCppType != 'AnyPtr') {
      convertedValue = _unwrapFromAnyPtrIfNeeded(value, fieldCppType);
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
        // 用户自定义类或 mixin 的 setter 调用 → 通过 vptr
        if (_userClasses.contains(receiverClassName) || _mixinNames.contains(receiverClassName)) {
          String vptrReceiver = receiver;
          if (_needsToVPtr(receiver, receiverType)) {
            vptrReceiver = _convertToVPtr(receiver, receiverType);
          }
          return '(reinterpret_cast<void(*)(AnyGC*, ${fieldCppType ?? 'AnyPtr'})>($vptrReceiver->getVptrMap()["set_$fieldName"]))($vptrReceiver, $convertedValue)';
        }
      }
    }

    // 后备：如果接收器是 mixin 或用户类，且字段是公开的，使用 vptr setter
    // 检查接收器类型或当前类上下文
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
      return '(reinterpret_cast<void(*)(AnyGC*, ${fieldCppType ?? 'AnyPtr'})>($vptrReceiver->getVptrMap()["set_$fieldName"]))($vptrReceiver, $convertedValue)';
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
    final args = expr.arguments.positional.map((e) => _emitCppExpr(e)).join(', ');

    // 检查接收器类型
    final receiverType = _getExpressionType(expr.receiver);
    // 将 AnyPtr 接收器转换为真实类型（仿照 Dart 的 dynamic dispatch）
    final receiver = _castReceiverToType(rawReceiver, receiverType);

    // 推断接收器的有效类型名 — 检查 C++ 表达式的后缀模式
    String? inferredTypeName;
    if (receiver.endsWith('.toStringValue()')) inferredTypeName = 'String';
    else if (receiver.endsWith('.toInt()')) inferredTypeName = 'int';
    else if (receiver.endsWith('.toDouble()')) inferredTypeName = 'double';
    else if (receiver.endsWith('.toBool()')) inferredTypeName = 'bool';
    // 也检查 dynAs<T> 前缀模式
    else if (receiver.startsWith('dynAs<std::string>')) inferredTypeName = 'String';
    else if (receiver.startsWith('dynAs<int64_t>')) inferredTypeName = 'int';
    else if (receiver.startsWith('dynAs<double>')) inferredTypeName = 'double';
    else if (receiver.startsWith('dynAs<bool>')) inferredTypeName = 'bool';

    // 如果类型信息表明是基本类型，使用它
    if (inferredTypeName == null && receiverType != null && _isPrimitiveType(receiverType)) {
      inferredTypeName = (receiverType as InterfaceType).classNode.name;
    }

    // 后备：如果 receiverType 未检测到但 C++ 表达式返回 std::string，推断为 String
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

    // 如果接收器表达式是 std::string 类型，处理字符串方法
    if (_cppExprReturnsString(receiver) || receiver.startsWith('dynAs<std::string>')) {
      final strResult = _emitCppStringMethodCall(receiver, methodName, args);
      if (strResult != null) return strResult;
    }

    if (receiverType != null) {
      // 检查是否为基本类型（int, double, bool, string）
      if (_isPrimitiveType(receiverType)) {
        return _emitCppPrimitiveMethodCall(receiver, methodName, args, receiverType);
      }

      // 检查是否为集合类型（List, Set, Map, Iterable, StaticList, StaticSet, StaticMap, StaticIterator, Array, Iterator）
      if (receiverType is InterfaceType) {
        final typeName = receiverType.classNode.name;
        if (typeName == 'List' || typeName == 'Set' || typeName == 'Map' || typeName == 'Iterable' ||
            typeName == 'StaticList' || typeName == 'StaticSet' || typeName == 'StaticMap' ||
            typeName == 'StaticIterator' || typeName == 'Array' || typeName == 'Iterator' ||
            typeName.contains('Iterator')) {
          return _emitCppCollectionMethodCall(receiver, methodName, args, receiverType);
        }

        // 检查是否为 Promise/Future 类型
        if (typeName == 'Promise' || typeName == 'Future') {
          return _emitCppPromiseMethodCall(receiver, methodName, args, receiverType);
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

    // 如果 _castReceiverToType 将接收器转换为基本类型（如 .toStringValue()），
    // 则根据推断类型进行方法派发
    if (inferredTypeName != null) {
      return _emitCppPrimitiveMethodCallByName(receiver, methodName, args, inferredTypeName);
    }

    // 模板类型参数上的方法调用：使用 if constexpr 兼容指针和值类型
    if (receiverType is TypeParameterType) {
      return _emitCppTemplateParamMethodCall(receiver, methodName, args, expr);
    }

    // 虚方法调用 - 使用 getVptrMap() 访问 vptr 映射
    final argCount = expr.arguments.positional.length;
    String vptrReceiver = receiver;
    if (_needsToVPtr(receiver, receiverType)) {
      vptrReceiver = _convertToVPtr(receiver, receiverType);
    }
    final allArgs = args.isNotEmpty ? '$receiver, $args' : receiver;
    // 查找目标方法的返回类型，以便生成正确的函数指针类型
    final fnType = _vptrFnTypeForTarget(expr.interfaceTarget, argCount);
    return '(reinterpret_cast<$fnType>($vptrReceiver->getVptrMap()["$methodName"]))($allArgs)';
  }

  /// 生成模板类型参数上的方法调用
  /// 使用 if constexpr 兼容指针类型（vptr 派发）和值类型（直接操作）
  String _emitCppTemplateParamMethodCall(String receiver, String methodName, String args, InstanceInvocation expr) {
    final argCount = expr.arguments.positional.length;
    final fnType = _vptrFnType(argCount);

    // compareTo: 指针类型用 vptr，值类型用 > 运算符
    if (methodName == 'compareTo' && argCount == 1) {
      final arg = args;
      final vptrCall = '(reinterpret_cast<$fnType>(static_cast<VPtr*>($receiver)->getVptrMap()["compareTo"]))(static_cast<AnyGC*>($receiver), AnyPtr($arg)).toInt()';
      final valueCall = '(($receiver) > ($arg) ? 1LL : (($receiver) < ($arg) ? -1LL : 0LL))';
      return '([&]() -> int64_t { if constexpr (std::is_pointer_v<decltype($receiver)>) { return $vptrCall; } else { return $valueCall; } })()';
    }

    // toString: 指针类型用 dart_str，值类型用 std::to_string 或直接返回
    if (methodName == 'toString' && argCount == 0) {
      final vptrCall = '(reinterpret_cast<$fnType>(static_cast<VPtr*>($receiver)->getVptrMap()["toString"]))(static_cast<AnyGC*>($receiver))';
      final valueCall = 'dart_str($receiver)';
      return '([&]() -> AnyPtr { if constexpr (std::is_pointer_v<decltype($receiver)>) { return $vptrCall; } else { return $valueCall; } })()';
    }

    // 默认：假设是指针类型，使用 vptr 派发（可能在值类型上失败）
    final allArgs = args.isNotEmpty ? 'static_cast<AnyGC*>($receiver), $args' : 'static_cast<AnyGC*>($receiver)';
    final vptrCall = '(reinterpret_cast<$fnType>(static_cast<VPtr*>($receiver)->getVptrMap()["$methodName"]))($allArgs)';
    return '([&]() { if constexpr (std::is_pointer_v<decltype($receiver)>) { return $vptrCall; } else { return AnyPtr($receiver); } })()';
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
      'map', 'where', 'forEach', 'join', 'toList', 'toSet', 'sort', 'sublist',
      'first', 'last', 'single', 'any', 'every', 'fold', 'reduce', 'reversed',
      'indexOf', 'insert', 'remove', 'removeAt', 'removeLast', 'removeWhere', 'iterator',
    },
    'Iterable': {
      'contains', 'isEmpty', 'isNotEmpty', 'length', 'map', 'where', 'forEach',
      'join', 'toList', 'toSet', 'first', 'last', 'single', 'any', 'every',
      'fold', 'reduce', 'reversed', 'iterator',
    },
    'StaticList': {
      'add', 'addAll', 'clear', 'contains', 'isEmpty', 'isNotEmpty', 'length',
      'map', 'where', 'forEach', 'join', 'toList', 'toSet', 'sort', 'sublist',
      'first', 'last', 'single', 'any', 'every', 'fold', 'reduce', 'reversed',
      'indexOf', 'insert', 'remove', 'removeAt', 'removeLast', 'removeWhere',
      'toString',
    },
    'Set': {
      'add', 'addAll', 'clear', 'contains', 'isEmpty', 'isNotEmpty', 'length',
      'map', 'where', 'forEach', 'join', 'toList', 'toSet', 'first', 'last',
      'single', 'any', 'every', 'iterator',
    },
    'StaticSet': {
      'add', 'addAll', 'clear', 'contains', 'isEmpty', 'isNotEmpty', 'length',
      'map', 'where', 'forEach', 'join', 'toList', 'toSet', 'first', 'last',
      'single', 'any', 'every', 'remove', 'unionSet', 'union_', 'intersection', 'difference', 'toString',
    },
    'Map': {
      'clear', 'containsKey', 'containsValue', 'isEmpty', 'isNotEmpty', 'length',
      'map', 'forEach', 'keys', 'values', 'entries', 'remove', 'putIfAbsent',
    },
    'StaticMap': {
      'clear', 'containsKey', 'containsValue', 'isEmpty', 'isNotEmpty', 'length',
      'map', 'forEach', 'keys', 'values', 'entries', 'remove', 'putIfAbsent',
      'toString',
    },
    'Array': {
      'add', 'clear', 'contains', 'indexOf', 'insert', 'length',
      'removeAt', 'isEmpty', 'isNotEmpty',
    },
    'Iterator': {'moveNext', 'current', 'reset'},
    'StaticIterator': {'moveNext', 'current', 'reset'},
  };

  /// Promise/Future 类型方法调用 — 直接调用而非 vptr 派发
  String _emitCppPromiseMethodCall(String receiver, String methodName, String args, InterfaceType type) {
    switch (methodName) {
      case 'then':
        // 当参数是 C++ lambda 时使用成员函数 ->then()，当是 TypeFunction* 时使用 Promise_then
        if (args.contains('[') && args.contains('](') && !args.contains('TypeFunction')) {
          return '$receiver->then($args)';
        }
        return 'Promise_then($receiver, $args)';
      case 'catchError': return '$receiver->catchError($args)';
      case 'whenComplete': return '$receiver->whenComplete($args)';
      case 'complete': return '$receiver->complete($args)';
      case 'completeError': return '$receiver->completeError($args)';
      case 'completeWith': return '$receiver->complete($args)';
      case 'completeWithError': return '$receiver->completeError($args)';
      case 'toList': return '$receiver->toList()';
      case 'toString': return '$receiver->toString()';
      // Promise getters
      case 'get_result': return '$receiver->typedResult()';
      case 'get_isPending': return '$receiver->isPending()';
      case 'get_isCompleted': return '$receiver->isCompleted()';
      case 'get_isError': return '$receiver->isError()';
      case 'get_error': return '$receiver->error';
      case 'get_isReady': return '$receiver->isReady()';
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
        return '([&]() { auto* _stream = $receiver; auto* _promise = GC::allocateLocal(new Promise<StaticList<$typeArg>*>()); _promise->complete(AnyPtr::fromGC(_stream->toList())); return _promise; })()';
      case 'map':
        return '$receiver->map($args)';
      case 'where':
        return '$receiver->where($args)';
      case 'fold':
        return '$receiver->fold($args)';
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
      case 'result': return '$receiver->typedResult()';
      case 'isPending': return '$receiver->isPending()';
      case 'isCompleted': return '$receiver->isCompleted()';
      case 'isError': return '$receiver->isError()';
      case 'error': return '$receiver->error';
      case 'isReady': return '$receiver->isReady()';
      default: return '$receiver->$fieldName';
    }
  }

  /// StringBuffer 类型方法调用
  String _emitCppStringBufferMethodCall(String receiver, String methodName, String args) {
    switch (methodName) {
      case 'write': return '$receiver->write($args)';
      case 'writeln': return '$receiver->writeln($args)';
      case 'clear': return '$receiver->clear()';
      case 'toString': return '$receiver->toString()';
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

  String _emitCppCollectionMethodCall(String receiver, String methodName, String args, InterfaceType type) {
    final typeName = type.classNode.name;
    final methods = _collectionMethods[typeName];
    if (methods == null || !methods.contains(methodName)) {
      return '/* unsupported collection method: $methodName on $typeName */ $receiver->$methodName($args)';
    }

    // 特殊处理：add 方法需要转换 AnyPtr 参数为列表元素类型
    if (methodName == 'add' && (typeName == 'List' || typeName == 'StaticList' || typeName == 'Set' || typeName == 'StaticSet')) {
      final typeArgs = type.typeArguments;
      if (typeArgs.isNotEmpty) {
        final elementType = _cppType(typeArgs[0]);
        // If the argument is AnyPtr and element type is concrete, convert it
        if (elementType != 'AnyPtr' && elementType != 'AnyGC*' && _isAnyPtrResult(args)) {
          final convertedArg = _convertAnyPtrToType(args, elementType);
          return '$receiver->$methodName($convertedArg)';
        }
      }
    }

    // 特殊处理：Array 的 isEmpty/isNotEmpty
    if (typeName == 'Array') {
      if (methodName == 'isEmpty') return '($receiver->length() == 0)';
      if (methodName == 'isNotEmpty') return '($receiver->length() > 0)';
    }

    // 特殊处理：Iterable/StaticList/StaticSet 的 toList/toSet 返回自身
    if (methodName == 'toList' && (typeName == 'Iterable' || typeName == 'StaticList')) {
      return receiver;
    }
    if (methodName == 'toSet' && (typeName == 'StaticSet' || typeName == 'Set')) {
      return receiver;
    }

    // 特殊处理：StaticSet 的 union/intersection/difference 方法（避免 C++ 关键字冲突）
    if (typeName == 'StaticSet' || typeName == 'Set') {
      if (methodName == 'union' || methodName == 'union_') {
        return '$receiver->unionSet($args)';
      }
      if (methodName == 'intersection') {
        return '$receiver->intersection($args)';
      }
      if (methodName == 'difference') {
        return '$receiver->difference($args)';
      }
    }

    // 特殊处理：StaticMap/Map 的 remove 方法（返回类型需要包装为 AnyPtr）
    if (typeName == 'StaticMap' || typeName == 'Map') {
      if (methodName == 'remove') {
        // 获取 Map 的值类型
        final typeArgs = type.typeArguments;
        if (typeArgs.length >= 2) {
          final valueType = _cppType(typeArgs[1]);
          // 如果值类型不是 AnyPtr，需要包装
          if (valueType != 'AnyPtr') {
            return 'AnyPtr::fromAuto($receiver->remove($args))';
          }
        }
      }
    }

    // 通用模式：无参数方法 → $receiver->$methodName()，有参数方法 → $receiver->$methodName($args)
    if (_noArgMethods.contains(methodName)) {
      return '$receiver->$methodName()';
    }
    return '$receiver->$methodName($args)';
  }

  /// 将 AnyPtr 表达式转换为指定的 C++ 类型
  String _convertAnyPtrToType(String expr, String targetType) {
    if (targetType == 'int64_t') return '$expr.toInt()';
    if (targetType == 'double') return '$expr.toDouble()';
    if (targetType == 'bool') return '$expr.toBool()';
    if (targetType == 'std::string') return '$expr.toStringValue()';
    if (targetType.endsWith('*')) {
      return 'static_cast<$targetType>($expr.toGC())';
    }
    return expr;
  }

  /// 检查是否是运算符名称
  bool _isOperatorName(String name) {
    const operators = {
      '+', '-', '*', '/', '%', '<', '>', '<=', '>=', '==', '!=',
      '&', '|', '^', '~', '<<', '>>', '~/', '_', 'unary-',
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

  /// 检查 C++ 表达式是否返回 std::string（基于函数调用模式）
  bool _cppExprReturnsString(String expr) {
    // 检查是否是已知的返回 std::string 的函数调用
    if (expr.startsWith('dart_str_') || expr.startsWith('std::to_string')) {
      return true;
    }
    // 检查是否是 dart_str() 调用
    if (expr.startsWith('dart_str(')) {
      return true;
    }
    // 检查是否是 dynAs<std::string>() 调用
    if (expr.startsWith('dynAs<std::string>')) {
      return true;
    }
    // 检查是否是 StaticList<std::string> 的索引访问: (*var)[i]
    final listAccess = RegExp(r'^\(\*([A-Za-z_][A-Za-z0-9_]*)\)\[').firstMatch(expr);
    if (listAccess != null) {
      final varName = listAccess.group(1)!;
      final varType = _variableTypeMap[varName];
      if (varType != null && varType.contains('StaticList<std::string>')) {
        return true;
      }
    }
    // 检查是否是已跟踪的函数调用
    final match = RegExp(r'^([A-Za-z_][A-Za-z0-9_]*)\(').firstMatch(expr);
    if (match != null) {
      final funcName = match.group(1)!;
      if (_functionReturnTypes.containsKey(funcName)) {
        return _functionReturnTypes[funcName] == 'std::string';
      }
    }
    return false;
  }

  /// 生成运算符调用
  String _emitCppOperatorCall(Expression expr, String receiver, String op, String args) {
    final right = args.isNotEmpty ? args.split(',').first.trim() : '';

    // 特殊处理索引运算符
    if (op == '[]') {
      final receiverExpr = (expr is InstanceInvocation) ? expr.receiver : (expr is DynamicInvocation ? expr.receiver : expr);
      final receiverType = _getExpressionType(receiverExpr);
      final receiverCppType = receiverType != null ? _cppType(receiverType) : '';

      // 如果接收器是 AnyPtr/AnyGC* 且类型未知，通过 vptr 派发 [] 运算符
      if (_needsToVPtr(receiver, receiverType) && (receiverCppType.isEmpty || receiverCppType == 'AnyPtr' || receiverCppType == 'AnyGC*')) {
        final vptrRecv = _convertToVPtr(receiver, receiverType);
        return '(reinterpret_cast<AnyPtr(*)(AnyGC*,AnyPtr)>($vptrRecv->getVptrMap()["[]"]))( $vptrRecv, $right)';
      }

      // 对于 Map 类型，operator[] 返回指针，需要解引用
      if (receiverType is InterfaceType &&
          (receiverType.classNode.name == 'Map' || receiverType.classNode.name == 'StaticMap')) {
        final accessExpr = '(*(*$receiver)[$right])';
        // 检查 Map 的值类型，如果是 AnyGC* 则需要包装为 AnyPtr
        final valueType = receiverType.typeArguments.length > 1 ? receiverType.typeArguments[1] : null;
        final valueCppType = valueType != null ? _cppType(valueType) : '';
        if (valueCppType == 'AnyGC*') {
          // 将 AnyGC* 包装为 AnyPtr，以便调用 .toInt() 等方法
          return 'AnyPtr::fromGC($accessExpr)';
        }
        return accessExpr;
      }
      // 非指针类型（如 std::string）不需要解引用
      if (receiverCppType.isNotEmpty && !receiverCppType.endsWith('*')) {
        // std::string 的 operator[] 返回 char，但 Dart 中 String[index] 返回单字符 String
        if (receiverCppType == 'std::string') {
          return 'std::string(1, $receiver[$right])';
        }
        return '$receiver[$right]';
      }
      return '(*$receiver)[$right]';
    }
    if (op == '[]=') {
      final argList = args.split(',');
      if (argList.length >= 2) {
        final index = argList[0].trim();
        final value = argList[1].trim();
        final receiverExpr = (expr is InstanceInvocation) ? expr.receiver : (expr is DynamicInvocation ? expr.receiver : expr);
      final receiverType = _getExpressionType(receiverExpr);
        final receiverCppType = receiverType != null ? _cppType(receiverType) : '';
        // 对于 Map 类型，使用 set 方法
        if (receiverType is InterfaceType &&
            (receiverType.classNode.name == 'Map' || receiverType.classNode.name == 'StaticMap')) {
          return '$receiver->set($index, $value)';
        }
        // 非指针类型不需要解引用
        if (receiverCppType.isNotEmpty && !receiverCppType.endsWith('*')) {
          return '$receiver[$index] = $value';
        }
        return '(*$receiver)[$index] = $value';
      }
    }

    // 用户自定义类的运算符通过 vptr 调度（指针类型不能直接用 C++ 运算符）
    final opReceiverExpr = (expr is InstanceInvocation) ? expr.receiver : (expr is DynamicInvocation ? expr.receiver : expr);
    final receiverType = _getExpressionType(opReceiverExpr);
    if (receiverType is InterfaceType && _userClasses.contains(receiverType.classNode.name)) {
      final receiverCppType = _cppType(receiverType);
      String vptrReceiver = receiver;
      if (_needsToVPtr(receiver, receiverType)) {
        vptrReceiver = _convertToVPtr(receiver, receiverType);
      }
      if (right.isEmpty) {
        // 一元运算符
        final raw = '(reinterpret_cast<AnyPtr(*)(AnyGC*)>($vptrReceiver->getVptrMap()["$op"]))($vptrReceiver)';
        // 如果返回类型是指针，需要转换
        if (receiverCppType.endsWith('*')) {
          return 'reinterpret_cast<$receiverCppType>($raw.toVPtr())';
        }
        return raw;
      }
      final raw = '(reinterpret_cast<AnyPtr(*)(AnyGC*,AnyPtr)>($vptrReceiver->getVptrMap()["$op"]))($vptrReceiver, $right)';
      // 对于比较运算符，返回 bool 不需要转换
      if (['==', '!=', '<', '>', '<=', '>='].contains(op)) {
        return '$raw.toBool()';
      }
      // 如果返回类型是指针，需要转换
      if (receiverCppType.endsWith('*')) {
        return 'reinterpret_cast<$receiverCppType>($raw.toVPtr())';
      }
      return raw;
    }

    // 对 AnyGC* 接收器的算术运算符，需要先拆箱
    final opReceiverExpr2 = (expr is InstanceInvocation) ? expr.receiver : (expr is DynamicInvocation ? expr.receiver : null);
    final opReceiverType2 = opReceiverExpr2 != null ? _getExpressionType(opReceiverExpr2) : null;
    final opReceiverCppType2 = opReceiverType2 != null ? _cppType(opReceiverType2) : '';
    if (opReceiverCppType2 == 'AnyGC*' && ['+', '-', '*', '/', '%'].contains(op)) {
      final numType = right.contains('.') ? 'double' : 'int64_t';
      final unboxed = 'dynAs<$numType>($receiver)';
      switch (op) {
        case '+': return '($unboxed + $right)';
        case '-': return right.isEmpty ? '(-$unboxed)' : '($unboxed - $right)';
        case '*': return '($unboxed * $right)';
        case '/': return '($unboxed / $right)';
        case '%': return '($unboxed % $right)';
      }
    }

    // 当右操作数是 AnyPtr 时（如 Promise->result），需要根据接收器类型转换
    if (_isAnyPtrResult(right) && ['+', '-', '*', '/', '%'].contains(op)) {
      final numType = receiver.contains('.') ? 'double' : 'int64_t';
      final unboxedRight = 'dynAs<$numType>($right)';
      switch (op) {
        case '+': return '($receiver + $unboxedRight)';
        case '-': return '($receiver - $unboxedRight)';
        case '*': return '($receiver * $unboxedRight)';
        case '/': return '($receiver / $unboxedRight)';
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
      if (right.startsWith('std::string(') || right.startsWith('"')) {
        final unboxed = 'dynAs<std::string>($receiver)';
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
      if (effectiveReceiverCppType == 'std::string') {
        return '($receiver $op dynAs<std::string>($right))';
      }
      if (effectiveReceiverCppType == 'bool') {
        return '($receiver $op dynAs<bool>($right))';
      }
    }

    switch (op) {
      case '+': return '($receiver + $right)';
      case '-': return right.isEmpty ? '(-$receiver)' : '($receiver - $right)';
      case '*': return '($receiver * $right)';
      case '/': return '($receiver / $right)';
      case '%': return '($receiver % $right)';
      case '<': return '($receiver < $right)';
      case '>': return '($receiver > $right)';
      case '<=': return '($receiver <= $right)';
      case '>=': return '($receiver >= $right)';
      case '==':
        // 当比较 map[key] == null 时，检查指针而不是解引用的值
        if ((right == 'nullptr' || right == 'AnyPtr::null()') && receiver.startsWith('(*(*') && receiver.endsWith(')')) {
          // 移除外层解引用：(*(*map)[key]) -> (*map)[key]
          final ptrExpr = receiver.substring(2, receiver.length - 1);
          return '($ptrExpr == nullptr)';
        }
        return '($receiver == $right)';
      case '!=':
        // 当比较 map[key] != null 时，检查指针而不是解引用的值
        if ((right == 'nullptr' || right == 'AnyPtr::null()') && receiver.startsWith('(*(*') && receiver.endsWith(')')) {
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
      case '~/': return '($receiver / $right)';  // Integer division
      case 'unary-': return '(-$receiver)';
      default: return '/* unsupported operator: $op */ $receiver';
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
      return target.function.returnType;
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
    } else if (expr is DynamicInvocation) {
      // 尝试通过方法名推断返回类型
      // 对于 [] 操作符，无法直接推断，返回 null
      return null;
    } else if (expr is DynamicGet) {
      // 动态属性访问，无法静态推断类型
      return null;
    } else if (expr is Let) {
      return _getExpressionType(expr.body);
    } else if (expr is MapLiteral) {
      // MapLiteral 的类型信息需要从上下文推断，简化返回 null
      return null;
    } else if (expr is ListLiteral) {
      // ListLiteral 的类型信息需要从上下文推断，简化返回 null
      return null;
    } else if (expr is SetLiteral) {
      // SetLiteral 的类型信息需要从上下文推断，简化返回 null
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
    } else if (expr is ConstantExpression) {
      final c = expr.constant;
      if (c is InstanceConstant) {
        if (c.typeArguments.isNotEmpty) {
          return InterfaceType(c.classNode, Nullability.nonNullable, c.typeArguments);
        }
        return InterfaceType(c.classNode, Nullability.nonNullable);
      } else if (c is StringConstant) {
        // 返回 String 类型 — 需要查找 String 类
        // 简化处理，返回 null（std::string 不是 InterfaceType）
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

  /// 检查 C++ 表达式是否需要 .toVPtr() 转换才能使用 -> 访问
  /// 综合模式匹配和类型信息判断
  bool _needsToVPtr(String expr, DartType? type) {
    if (_isAnyPtrExpr(expr)) return true;
    if (type != null && _cppType(type) == 'AnyPtr') return true;
    // AnyGC* 接收器需要 static_cast 到 VPtr*
    if (type != null && _cppType(type) == 'AnyGC*') return true;
    if (_isAnyGCPtrExpr(expr)) return true;
    return false;
  }

  /// 将 AnyPtr/AnyGC* 转换为 VPtr*
  String _convertToVPtr(String expr, DartType? type) {
    final cppType = type != null ? _cppType(type) : '';
    if (cppType == 'AnyGC*' || _isAnyGCPtrExpr(expr)) {
      return 'static_cast<VPtr*>($expr)';
    }
    return '$expr.toVPtr()';
  }

  /// 检查 C++ 表达式字符串是否可能是 AnyPtr 值类型（非指针）
  /// 用于在 vptr 派发时决定是否需要 .toVPtr() 转换
  bool _isAnyPtrExpr(String expr) {
    // 已经是指针或基本类型的，不需要 .toVPtr()（先检查 ending，更具体）
    if (expr.endsWith('.toInt()')) return false;
    if (expr.endsWith('.toDouble()')) return false;
    if (expr.endsWith('.toBool()')) return false;
    if (expr.endsWith('.toStringValue()')) return false;
    if (expr.endsWith('.toVPtr()')) return false;
    if (expr.endsWith('this_')) return false;       // 本地 this 指针
    if (expr.startsWith('new ')) return false;      // new 表达式返回指针
    if (expr.startsWith('static_cast<')) return false; // 类型转换
    if (expr.startsWith('reinterpret_cast<')) return false;
    if (expr.contains('::')) return false;           // 命名空间/静态访问
    if (expr.contains('->')) return false;           // 指针成员访问
    if (expr.contains('_new(')) return false;        // 构造函数返回指针
    // 明确是 AnyPtr 值类型的模式
    if (expr.startsWith('(*')) return true;        // 解引用的指针（如 Map 访问）
    if (expr.startsWith('AnyPtr(')) return true;   // AnyPtr 构造
    if (expr == 'AnyPtr()') return true;
    // 默认认为不是 AnyPtr（保守，避免误加 .toVPtr()）
    return false;
  }

  /// 生成基本类型的方法调用
  String _emitCppPrimitiveMethodCall(String receiver, String methodName, String args, DartType type) {
    final typeName = (type as InterfaceType).classNode.name;
    return _emitCppPrimitiveMethodCallByName(receiver, methodName, args, typeName);
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
          return '($receiver.find($arg) != std::string::npos)';
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
          return 'static_cast<int64_t>(std::hash<std::string>{}($receiver))';
        default:
          return '/* unsupported String method: $methodName */ $receiver';
      }
    }

    // int/double 类型的方法
    if (typeName == 'int' || typeName == 'double') {
      switch (methodName) {
        case 'abs':
          return 'std::abs($receiver)';
        case 'toString':
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
          return '/* unsupported clamp args */ $receiver';
        default:
          return '/* unsupported ${typeName} method: $methodName */ $receiver';
      }
    }

    return '/* unsupported primitive method: $methodName on $typeName */ $receiver';
  }

  /// 当接收器是 std::string C++ 表达式时，处理字符串方法调用
  /// 返回 null 如果方法无法处理
  String? _emitCppStringMethodCall(String receiver, String methodName, String args) {
    switch (methodName) {
      case 'contains':
        final arg = args.split(',').first.trim();
        return '($receiver.find($arg) != std::string::npos)';
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
      case 'hashCode':
        return 'static_cast<int64_t>(std::hash<std::string>{}($receiver))';
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
          if (typeArg == 'AnyPtr' && _expectedCollectionElementType != null) {
            return _expectedCollectionElementType!;
          }
          return typeArg;
        }
        if (_expectedCollectionElementType != null) {
          return _expectedCollectionElementType!;
        }
        return 'AnyPtr';
      }

      // 处理 _literal* 系列 (列表字面量)
      if (name.startsWith('_literal')) {
        final typeArg = resolveStaticListElementType();
        final elemExprs = <String>[];
        for (final e in expr.arguments.positional) {
          var elemStr = _emitCppExpr(e);
          if (typeArg == 'AnyGC*') {
            elemStr = _cppMaybeBoxForAnyGC(elemStr, e);
          }
          elemExprs.add(elemStr);
        }
        final elements = elemExprs.join(', ');
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
                final elements = arg.expressions.map((e) => _emitCppExpr(e)).join(', ');
                if (expr.arguments.types.isNotEmpty) {
                  final typeArg = _cppType(expr.arguments.types.first);
                  return 'GC::allocateLocal(new StaticList<$typeArg>({$elements}))';
                }
                return 'GC::allocateLocal(new StaticList<AnyGC*>({$elements}))';
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
                  return '([&]() { auto* _src = $listExpr; auto* _dst = GC::allocateLocal(new StaticList<$typeArg>()); for (int _i = 0; _i < _src->length(); _i++) _dst->add((*_src)[_i]); return _dst; })()';
                }
                if (listExpr.startsWith('GC::allocateLocal(new StaticList')) {
                  return 'StaticList<AnyGC*>::from($listExpr)';
                }
                return '([&]() { auto* _src = $listExpr; auto* _dst = GC::allocateLocal(new StaticList<AnyGC*>()); for (int _i = 0; _i < _src->length(); _i++) _dst->add((*_src)[_i]); return _dst; })()';
              }
            }
          } else if (className == 'StaticSet' || className == 'Set') {
            if (expr.arguments.positional.length == 1) {
              final arg = expr.arguments.positional.first;
              if (arg is ListLiteral) {
                final elements = arg.expressions.map((e) => _emitCppExpr(e)).join(', ');
                if (expr.arguments.types.isNotEmpty) {
                  final typeArg = _cppType(expr.arguments.types.first);
                  return 'GC::allocateLocal(new StaticSet<$typeArg>({$elements}))';
                }
                return 'GC::allocateLocal(new StaticSet<AnyGC*>({$elements}))';
              } else if (arg is StaticInvocation) {
                // StaticSet.of(StaticList<int>({1, 2, 3})) - need to convert StaticList to StaticSet
                final listExpr = _emitCppExpr(arg);
                if (expr.arguments.types.isNotEmpty) {
                  final typeArg = _cppType(expr.arguments.types.first);
                  return '([&]() { auto* _src = $listExpr; auto* _dst = GC::allocateLocal(new StaticSet<$typeArg>()); for (int _i = 0; _i < _src->length(); _i++) _dst->add((*_src)[_i]); return _dst; })()';
                }
                return '([&]() { auto* _src = $listExpr; auto* _dst = GC::allocateLocal(new StaticSet<AnyGC*>()); for (int _i = 0; _i < _src->length(); _i++) _dst->add((*_src)[_i]); return _dst; })()';
              } else {
                final listExpr = _emitCppExpr(arg);
                if (expr.arguments.types.isNotEmpty) {
                  final typeArg = _cppType(expr.arguments.types.first);
                  return '([&]() { auto* _src = $listExpr; auto* _dst = GC::allocateLocal(new StaticSet<$typeArg>()); for (int _i = 0; _i < _src->length(); _i++) _dst->add((*_src)[_i]); return _dst; })()';
                }
                return '([&]() { auto* _src = $listExpr; auto* _dst = GC::allocateLocal(new StaticSet<AnyGC*>()); for (int _i = 0; _i < _src->length(); _i++) _dst->add((*_src)[_i]); return _dst; })()';
              }
            }
          }
          // 处理 StaticMap.of(map_expr) — 类型转换（copy or cast）
          if (className == 'StaticMap' || className == 'Map') {
            if (expr.arguments.positional.length == 1) {
              final innerExpr = _emitCppExpr(expr.arguments.positional.first);
              // StaticMap<K,V>.of(expr) → static_cast to StaticMap<K,V>*
              if (expr.arguments.types.length >= 2) {
                final keyType = _cppType(expr.arguments.types[0]);
                final valType = _cppType(expr.arguments.types[1]);
                // If the inner expression is already the right type, just return it
                // Otherwise cast: AnyGC* → StaticMap<K,V>* or reinterpret_cast
                if (_isAnyGCPtrExpr(innerExpr) || innerExpr.startsWith('(*(*')) {
                  return 'static_cast<StaticMap<$keyType, $valType>*>($innerExpr)';
                }
                if (innerExpr.startsWith('AnyPtr::') || _isAnyPtrResult(innerExpr)) {
                  return 'static_cast<StaticMap<$keyType, $valType>*>($innerExpr.toGC())';
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
        final typeArg = typeArgs.isNotEmpty ? _cppType(typeArgs.first) : 'AnyPtr';

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
            computationExpr = '[]() -> AnyPtr { return AnyPtr::null(); }';
          }

          return 'promiseDelayed($ticksExpr, $computationExpr)';
        }
        if (methodName == 'value') {
          return 'Promise<$typeArg>::resolved($args)';
        }
        if (methodName == 'error' || methodName == 'rejected') {
          return 'Promise<$typeArg>::rejected($args)';
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
        return 'std::stoll($arg)';
      }
      if (className == 'double' && methodName == 'parse') {
        final arg = expr.arguments.positional.isNotEmpty
            ? _emitCppExpr(expr.arguments.positional.first)
            : '""';
        return 'std::stod($arg)';
      }
      // Handle List.from, Set.from, Map.from static methods
      if ((className == 'List' || className == 'StaticList') && methodName == 'from') {
        final arg = expr.arguments.positional.isNotEmpty
            ? _emitCppExpr(expr.arguments.positional.first)
            : 'nullptr';
        if (expr.arguments.types.isNotEmpty) {
          final typeArg = _cppType(expr.arguments.types.first);
          return 'StaticList<$typeArg>::from($arg)';
        }
        return 'StaticList<AnyGC*>::from($arg)';
      }
      if ((className == 'Set' || className == 'StaticSet') && methodName == 'from') {
        final arg = expr.arguments.positional.isNotEmpty
            ? _emitCppExpr(expr.arguments.positional.first)
            : 'nullptr';
        if (expr.arguments.types.isNotEmpty) {
          final typeArg = _cppType(expr.arguments.types.first);
          return 'StaticSet<$typeArg>::from($arg)';
        }
        return 'StaticSet<AnyGC*>::from($arg)';
      }
    }

    var funcName = _cleanName(target.name.text);
    // 对参数进行类型转换（AnyGC* 装箱 + AnyPtr::null() 转换 + 命名参数映射）
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
        } else {
          argStr = _convertNullToType(argStr, paramCppType);
        }
      }
      argExprs.add(argStr);
    }
    // 处理命名参数：映射到位置参数顺序
    if (targetFunc != null && expr.arguments.named.isNotEmpty && targetFunc.namedParameters.isNotEmpty) {
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
        }
        // 如果调用方没有提供该命名参数，跳过（依赖 C++ 默认值）
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
        String keyType = 'std::string';
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
        final cppTypeArgs = expr.arguments.types.map((t) => _cppType(t)).join(', ');
        templateArgs = '<$cppTypeArgs>';
      }
    }

    return '$funcName$templateArgs($args)';
  }

  String _emitCppConstructorInvocation(ConstructorInvocation expr) {
    return _emitCppConstructorCall(expr.target.enclosingClass.name, expr.target, expr.arguments);
  }

  String _emitCppConstructorCall(String className, Constructor ctor, Arguments args) {
    // 处理 _GrowableList (Dart 内部列表实现) → StaticList
    if (className == '_GrowableList') {
      final ctorName = ctor.name.text;
      final typeArgs = args.types;

      // 辅助函数：获取列表元素类型，优先使用外层泛型构造函数期望的类型
      String resolveListElementType() {
        if (typeArgs.isNotEmpty) {
          final typeArg = _cppType(typeArgs.first);
          // 如果类型参数映射到 AnyPtr 且有外层期望的类型，使用期望的类型
          if (typeArg == 'AnyPtr' && _expectedCollectionElementType != null) {
            return _expectedCollectionElementType!;
          }
          return typeArg;
        }
        if (_expectedCollectionElementType != null) {
          return _expectedCollectionElementType!;
        }
        return 'AnyPtr';
      }

      // 处理 _literal* 系列 (列表字面量)
      if (ctorName.startsWith('_literal')) {
        final elements = args.positional.map((e) => _emitCppExpr(e)).join(', ');
        final typeArg = resolveListElementType();
        return 'GC::allocateLocal(new StaticList<$typeArg>({$elements}))';
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

    // 处理 MapEntry / StaticMapEntry 构造函数
    if (className == 'MapEntry' || className == 'StaticMapEntry') {
      final keyExpr = args.positional.length > 0 ? _emitCppExpr(args.positional[0]) : '""';
      final valExpr = args.positional.length > 1 ? _emitCppExpr(args.positional[1]) : 'nullptr';
      String keyType = 'std::string';
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
          final elements = arg.expressions.map((e) => _emitCppExpr(e)).join(', ');
          if (args.types.isNotEmpty) {
            final typeArg = _cppType(args.types.first);
            return 'GC::allocateLocal(new StaticList<$typeArg>({$elements}))';
          }
          return 'GC::allocateLocal(new StaticList<AnyGC*>({$elements}))';
        } else if (arg is ConstructorInvocation) {
          // Handle _GrowableList._literal* (Dart lowers [1,2,3] to _GrowableList._literal3(1,2,3))
          final innerClassName = arg.target.enclosingClass.name;
          final innerCtorName = arg.target.name.text;
          if (innerClassName == '_GrowableList' && innerCtorName.startsWith('_literal')) {
            final elements = arg.arguments.positional.map((e) => _emitCppExpr(e)).join(', ');
            if (args.types.isNotEmpty) {
              final typeArg = _cppType(args.types.first);
              return 'GC::allocateLocal(new StaticList<$typeArg>({$elements}))';
            }
            return 'GC::allocateLocal(new StaticList<AnyGC*>({$elements}))';
          }
        } else if (arg is StaticInvocation) {
          // Check if it's a StaticList creation (e.g., from List literal compilation)
          final target = arg.target;
          // Handle _GrowableList._literal* (Dart lowers [1,2,3] to _GrowableList._literal3(1,2,3))
          if (target is Procedure && target.enclosingClass != null) {
            final enclosingName = target.enclosingClass!.name;
            if (enclosingName == '_GrowableList' && target.name.text.startsWith('_literal')) {
              final elements = arg.arguments.positional.map((e) => _emitCppExpr(e)).join(', ');
              if (args.types.isNotEmpty) {
                final typeArg = _cppType(args.types.first);
                return 'GC::allocateLocal(new StaticList<$typeArg>({$elements}))';
              }
              return 'GC::allocateLocal(new StaticList<AnyGC*>({$elements}))';
            }
          }
          if (target is Constructor && target.enclosingClass != null &&
              (target.enclosingClass!.name == 'StaticList' || target.enclosingClass!.name == 'List')) {
            // Extract the elements from the nested StaticList creation
            if (arg.arguments.positional.length == 1 && arg.arguments.positional.first is ListLiteral) {
              final listLiteral = arg.arguments.positional.first as ListLiteral;
              final elements = listLiteral.expressions.map((e) => _emitCppExpr(e)).join(', ');
              if (args.types.isNotEmpty) {
                final typeArg = _cppType(args.types.first);
                return 'GC::allocateLocal(new StaticList<$typeArg>({$elements}))';
              }
              return 'GC::allocateLocal(new StaticList<AnyGC*>({$elements}))';
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

    if (className == 'StaticSet' || className == 'Set') {
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
      final typeArg = args.types.isNotEmpty ? _cppType(args.types.first) : 'AnyPtr';
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
    final positionalArgs = args.positional.map((e) => _emitCppExpr(e)).toList();
    _expectedCollectionElementType = savedExpectedType;

    // 处理命名参数：映射到位置参数顺序
    final ctorFunc = ctor.function;
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
      return 'dart_str($part)';
    });
    return parts.join(' + ');
  }

  String _emitCppConditional(ConditionalExpression expr) {
    final cond = _emitCppExpr(expr.condition);
    final then = _emitCppExpr(expr.then);
    final otherwise = _emitCppExpr(expr.otherwise);

    // 如果一个分支是 void（如 setter 调用），需要特殊处理
    // 将 void 分支包装为 (expr, AnyPtr::null()) 使其返回 AnyPtr
    String thenFinal = then;
    String otherwiseFinal = otherwise;
    if (_isVoidExpression(then) && !_isVoidExpression(otherwise)) {
      thenFinal = '($then, AnyPtr::null())';
    } else if (_isVoidExpression(otherwise) && !_isVoidExpression(then)) {
      otherwiseFinal = '($otherwise, AnyPtr::null())';
    } else if (_isVoidExpression(then) && _isVoidExpression(otherwise)) {
      // 两边都是 void，使用 if-else 语句模式
      return '($cond ? ($then) : ($otherwise))';
    }

    // 检查是否需要类型转换
    thenFinal = _convertNullToType(thenFinal, otherwiseFinal);
    otherwiseFinal = _convertNullToType(otherwiseFinal, thenFinal);

    // 处理 AnyPtr 与原始类型的歧义（如 int 0 与 AnyPtr 在三元表达式中）
    thenFinal = _wrapForAnyPtrContext(thenFinal, otherwiseFinal, expr.then, expr.otherwise);
    otherwiseFinal = _wrapForAnyPtrContext(otherwiseFinal, thenFinal, expr.otherwise, expr.then);

    return '($cond ? $thenFinal : $otherwiseFinal)';
  }

  /// 检查表达式是否为 void（如 setter 调用）
  bool _isVoidExpression(String expr) {
    // vptr setter 调用返回 void
    if (expr.startsWith('(reinterpret_cast<void(')) return true;
    // 直接字段赋值返回 void（在某些情况下）
    if (expr.contains(' = ') && !expr.startsWith('(')) return true;
    return false;
  }

  /// 如果一个分支是 AnyPtr 而另一个是裸原始值，包装原始值以避免转换歧义
  String _wrapForAnyPtrContext(String thisValue, String otherValue, Expression thisExpr, Expression otherExpr) {
    // 如果对方是 AnyPtr 相关值，而本值是裸数字/字面量
    final otherIsAnyPtr = otherValue.startsWith('AnyPtr') ||
        otherValue == 'AnyPtr::null()' ||
        otherValue.contains('AnyPtr::from');
    // 也检查对方表达式的类型
    final otherExprType = _getExpressionType(otherExpr);
    final otherTypeIsAnyPtr = otherExprType != null && _cppType(otherExprType) == 'AnyPtr';
    if (!otherIsAnyPtr && !otherTypeIsAnyPtr) return thisValue;
    // 如果本值已经是 AnyPtr 包装
    if (thisValue.startsWith('AnyPtr') || thisValue.contains('AnyPtr::from')) return thisValue;
    // 检查本表达式类型是否已经是 AnyPtr
    final thisExprType = _getExpressionType(thisExpr);
    if (thisExprType != null && _cppType(thisExprType) == 'AnyPtr') return thisValue;
    // 裸整数
    if (RegExp(r'^-?\d+$').hasMatch(thisValue)) {
      return 'AnyPtr::fromInt($thisValue)';
    }
    // 裸浮点数
    if (RegExp(r'^-?\d+\.\d+$').hasMatch(thisValue)) {
      return 'AnyPtr::fromDouble($thisValue)';
    }
    if (thisValue == 'true' || thisValue == 'false') {
      return 'AnyPtr::fromBool($thisValue)';
    }
    return thisValue;
  }

  /// 如果 value 是 AnyPtr::null()，根据 targetType 转换为对应的默认值
  String _convertNullToType(String value, String targetType) {
    if (value != 'AnyPtr::null()') {
      return value;
    }

    // 指针类型优先检查（避免与模板参数中的类型名冲突）
    if (targetType.endsWith('*') && !targetType.contains('AnyPtr')) {
      return 'nullptr';
    } else if (targetType == 'int64_t' || targetType == 'int') {
      return '0';
    } else if (targetType == 'double') {
      return '0.0';
    } else if (targetType == 'bool') {
      return 'false';
    } else if (targetType == 'std::string') {
      return '""';
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
    final listType = _getExpressionType(expr);
    if (listType is InterfaceType && listType.typeArguments.isNotEmpty) {
      innerType = _cppType(listType.typeArguments[0]);
    }
    // 如果外层泛型构造函数提供了期望的元素类型，且当前类型是 AnyGC*，使用期望的类型
    if (innerType == 'AnyGC*' && _expectedCollectionElementType != null) {
      innerType = _expectedCollectionElementType!;
    }
    if (expr.expressions.isEmpty) {
      return 'GC::allocateLocal(new StaticList<$innerType>())';
    }
    final elements = expr.expressions.map((e) => _emitCppExpr(e)).join(', ');
    return 'GC::allocateLocal(new StaticList<$innerType>({$elements}))';
  }

  String _emitCppMapLiteral(MapLiteral expr) {
    // 从 MapLiteral 的类型推断键值类型
    String keyType = 'AnyGC*';
    String valType = 'AnyGC*';
    final mapType = _getExpressionType(expr);
    if (mapType is InterfaceType && mapType.typeArguments.length >= 2) {
      keyType = _cppType(mapType.typeArguments[0]);
      valType = _cppType(mapType.typeArguments[1]);
    }
    // 如果推断的类型是 AnyGC*，但有期望的类型，使用期望的类型
    if (keyType == 'AnyGC*' && _expectedMapKeyType != null) {
      keyType = _expectedMapKeyType!;
    }
    if (valType == 'AnyGC*' && _expectedMapValueType != null) {
      valType = _expectedMapValueType!;
    }
    // 后备：从实际的 key 表达式推断类型（keys 通常是同质的）
    if (keyType == 'AnyGC*' && expr.entries.isNotEmpty) {
      final firstKeyType = _getExpressionType(expr.entries.first.key);
      if (firstKeyType is InterfaceType) {
        final name = firstKeyType.classNode.name;
        if (name == 'String') keyType = 'std::string';
        else if (name == 'int') keyType = 'int64_t';
        else if (name == 'double') keyType = 'double';
        else if (name == 'bool') keyType = 'bool';
      } else {
        // 后备：检查 C++ 表达式模式
        final firstKeyExpr = _emitCppExpr(expr.entries.first.key);
        if (firstKeyExpr.startsWith('std::string(') || firstKeyExpr.startsWith('"')) {
          keyType = 'std::string';
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
          if (firstName == 'String') valType = 'std::string';
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
    if (expr.startsWith('std::string(') || expr.startsWith('"') || expr.startsWith('dart_str(')) {
      return 'GC::allocateLocal(new StringBox($expr))';
    }
    if (expr.startsWith('GC::allocateLocal(new IntBox(') ||
        expr.startsWith('GC::allocateLocal(new StringBox(') ||
        expr.startsWith('GC::allocateLocal(new DoubleBox(') ||
        expr.startsWith('GC::allocateLocal(new BoolBox(')) {
      return expr; // already boxed
    }
    if (expr.endsWith('.toInt()') || RegExp(r'^-?\d+$').hasMatch(expr) || RegExp(r'^-?\d+LL$').hasMatch(expr)) {
      return 'GC::allocateLocal(new IntBox($expr))';
    }
    if (expr.endsWith('.toDouble()') || RegExp(r'^-?\d+\.\d+$').hasMatch(expr)) {
      return 'GC::allocateLocal(new DoubleBox($expr))';
    }
    if (expr.endsWith('.toBool()') || expr == 'true' || expr == 'false') {
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
    final elements = expr.expressions.map((e) => _emitCppExpr(e)).join(', ');
    return 'GC::allocateLocal(new StaticSet<$innerType>({$elements}))';
  }

  String _emitCppAsExpression(AsExpression expr) {
    final operand = _emitCppExpr(expr.operand);
    final targetType = _cppType(expr.type);
    if (targetType == 'AnyPtr' || targetType == 'AnyGC*') return operand;

    // Check if operand is already the target type
    final operandType = _getExpressionType(expr.operand);
    final operandCppType = operandType != null ? _cppType(operandType) : '';
    if (operandCppType == targetType) return operand;

    if (targetType.endsWith('*')) {
      final baseType = targetType.substring(0, targetType.length - 1);
      // 如果类型包含未解析的模板参数，使用 VPtr* 转换
      if (_isCppTypeParameter(baseType) || _containsTypeParameter(baseType)) {
        if (operandCppType == 'AnyGC*') return 'static_cast<VPtr*>($operand)';
        if (_isAnyPtrResult(operand) || operand.startsWith('AnyPtr::')) {
          return 'static_cast<VPtr*>($operand.toGC())';
        }
        return 'static_cast<VPtr*>($operand.toGC())';
      }
      // AnyGC* → pointer: use static_cast
      if (operandCppType == 'AnyGC*') {
        // 但如果 C++ 表达式实际产生 AnyPtr（如 AnyPtr::fromGC），需要先 .toGC()
        if (_isAnyPtrResult(operand) || operand.startsWith('AnyPtr::') || operand.endsWith('.toInt()') || operand.endsWith('.toDouble()') || operand.endsWith('.toBool()') || operand.endsWith('.toStringValue()')) {
          return 'static_cast<$baseType*>($operand.toGC())';
        }
        return 'static_cast<$baseType*>($operand)';
      }
      // AnyPtr → pointer: use .toGC() + static_cast, or .toVPtr() + reinterpret_cast
      if (_isAnyPtrResult(operand) || operand.startsWith('AnyPtr::') || operandCppType == 'AnyPtr') {
        return 'static_cast<$baseType*>($operand.toGC())';
      }
      return 'reinterpret_cast<$baseType*>($operand.toVPtr())';
    }
    // 检查操作数是否为 AnyPtr 或 AnyGC*

    // AnyGC* → 基本类型：使用 dynAs
    if (operandCppType == 'AnyGC*') {
      if (targetType == 'int64_t') return 'dynAs<int64_t>($operand)';
      if (targetType == 'double') return 'dynAs<double>($operand)';
      if (targetType == 'bool') return 'dynAs<bool>($operand)';
      if (targetType == 'std::string') return 'dynAs<std::string>($operand)';
      return 'static_cast<$targetType>($operand)';
    }

    // AnyPtr → 具体类型
    final isAnyPtr = operandCppType == 'AnyPtr' ||
                     operandCppType.isEmpty ||
                     operand.startsWith('(*') ||
                     operand.startsWith('AnyPtr') ||
                     operand.endsWith('->result') ||
                     operand.endsWith('->error');
    if (isAnyPtr) {
      if (targetType == 'int64_t') return '$operand.toInt()';
      if (targetType == 'double') return '$operand.toDouble()';
      if (targetType == 'bool') return '$operand.toBool()';
      if (targetType == 'std::string') return '$operand.toStringValue()';
      return '$operand.castTo<$targetType>()';
    }

    // 后备：表达式实际产生 AnyGC* 但类型系统未识别（如 ->typedResult()）
    if (operand.endsWith('->typedResult()') || _isAnyGCPtrExpr(operand)) {
      if (targetType == 'int64_t') return 'dynAs<int64_t>($operand)';
      if (targetType == 'double') return 'dynAs<double>($operand)';
      if (targetType == 'bool') return 'dynAs<bool>($operand)';
      if (targetType == 'std::string') return 'dynAs<std::string>($operand)';
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
    return 'false /* is ${expr.type} */';
  }

  String _emitCppFunctionExpression(FunctionExpression expr) {
    final func = expr.function;
    final closureId = _closureCounter++;
    final closureName = 'ClosureEnv_$closureId';

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
    capturedVars.removeWhere((v) => localVars.contains(v) || funcParams.contains(v) || v.name == null || v.name!.isEmpty);

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
    if (func.returnType is NeverType) {
      // Never 返回类型：从调用上下文推断实际返回类型
      returnType = _inferNeverReturnType(expr);
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
    _currentReturnType = returnType;

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
      // Never 返回类型的闭包被推断为其他类型时，添加兜底 return
      if (func.returnType is NeverType && returnType != 'void' && returnType != 'AnyGC*') {
        bodyBuf.writeln('        return ${_cppDefaultValue(returnType)}; /* unreachable */');
      }
    } else {
      bodyBuf.writeln('        return ${_cppDefaultValue(returnType)};');
    }

    // 恢复 _structBuf
    _structBuf = savedStructBuf;

    // 恢复返回类型和 async 标志
    _currentReturnType = savedReturnType;
    _isAsyncFunction = savedIsAsync;
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
      final varType = _cppType(v.type);
      _structBuf.writeln('    $varType $varName;');
    }

    // 构造函数
    final allCtorParams = <String>[];
    final allInitList = <String>[];
    if (capturesThis && thisType != null) {
      allCtorParams.add('$thisType this_');
      allInitList.add('this_(this_)');
    }
    for (final v in capturedVars) {
      final varName = _cleanName(v.name ?? 'v');
      final varType = _cppType(v.type);
      allCtorParams.add('$varType $varName');
      allInitList.add('$varName(std::move($varName))');
    }

    if (allCtorParams.isNotEmpty) {
      _structBuf.writeln('    $closureName(${allCtorParams.join(', ')}) : ${allInitList.join(', ')} {}');
    } else {
      _structBuf.writeln('    $closureName() {}');
    }

    // call 方法体
    _structBuf.writeln('    $returnType call($paramDecls) {');
    _structBuf.write(bodyBuf);
    _indent = 1;
    _structBuf.writeln('    }');
    _structBuf.writeln('};');
    _structBuf.writeln();

    // 创建闭包实例
    final allArgs = <String>[];
    if (capturesThis && thisType != null) {
      allArgs.add('this_');
    }
    for (final v in capturedVars) {
      allArgs.add(_cleanName(v.name ?? 'v'));
    }
    final args = allArgs.join(', ');
    final templateArgs = typeParams.isNotEmpty
        ? '<${typeParams.join(', ')}>'
        : '';
    // 使用 static_cast 确保返回类型与声明的 TypeFunction 基类匹配
    return 'GC::allocateLocal(static_cast<$typeFunctionBase*>(new $closureName$templateArgs($args)))';
  }

  /// 当闭包返回 Never 时，从调用上下文推断实际返回类型
  String _inferNeverReturnType(FunctionExpression expr) {
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
                final resolved = _resolveNeverTypeArg(
                    paramType.typeArguments[0], targetFunc, args.types);
                if (resolved != null) return resolved;
              }
            }
            // 处理 FunctionType (T Function())
            if (paramType is FunctionType) {
              final resolved = _resolveNeverTypeArg(
                  paramType.returnType, targetFunc, args.types);
              if (resolved != null) return resolved;
            }
          }
        }
      }
    }
    return 'AnyGC*';
  }

  /// 解析 Never 闭包返回类型中的类型参数
  String? _resolveNeverTypeArg(
      DartType typeArg, FunctionNode targetFunc, List<DartType> callTypes) {
    if (typeArg is TypeParameterType) {
      final paramName = typeArg.parameter.name;
      final tpIdx = targetFunc.typeParameters.indexWhere((tp) => tp.name == paramName);
      if (tpIdx >= 0 && tpIdx < callTypes.length) {
        return _cppType(callTypes[tpIdx]);
      }
    } else if (typeArg is! DynamicType && typeArg is! VoidType) {
      return _cppType(typeArg);
    }
    return null;
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
    }
  }

  void _collectCapturedVarsFromExpression(Expression expr, List<VariableDeclaration> out) {
    if (expr is VariableGet) {
      final decl = expr.variable;
      if (!out.contains(decl)) {
        out.add(decl);
      }
    } else if (expr is InstanceInvocation) {
      _collectCapturedVarsFromExpression(expr.receiver, out);
      for (final arg in expr.arguments.positional) {
        _collectCapturedVarsFromExpression(arg, out);
      }
    } else if (expr is StaticInvocation) {
      for (final arg in expr.arguments.positional) {
        _collectCapturedVarsFromExpression(arg, out);
      }
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
      for (final arg in expr.arguments.positional) {
        _collectCapturedVarsFromExpression(arg, out);
      }
    } else if (expr is AwaitExpression) {
      _collectCapturedVarsFromExpression(expr.operand, out);
    } else if (expr is Throw) {
      _collectCapturedVarsFromExpression(expr.expression, out);
    } else if (expr is Let) {
      if (expr.variable.initializer != null) {
        _collectCapturedVarsFromExpression(expr.variable.initializer!, out);
      }
      _collectCapturedVarsFromExpression(expr.body, out);
    }
  }

  void _emitCppStmtToBuffer(Statement stmt, StringBuffer buf) {
    final oldBuf = _implBuf;
    _implBuf = buf;
    _emitCppStmt(stmt, buf);
    _implBuf = oldBuf;
  }

  String _emitCppFunctionInvocation(FunctionInvocation expr) {
    final receiver = _emitCppExpr(expr.receiver);
    final args = expr.arguments.positional.map((e) => _emitCppExpr(e)).join(', ');
    // 当接收器类型是 TypeFunction 基类（非具体 TypeFunctionN）时，使用 dynCall
    final receiverType = _getExpressionType(expr.receiver);
    if (receiverType != null && _cppType(receiverType) == 'TypeFunction*') {
      return '$receiver->dynCall($args)';
    }
    return '$receiver->call($args)';
  }

  String _emitCppAwait(AwaitExpression expr) {
    final operand = _emitCppExpr(expr.operand);
    // 推断返回类型，默认为 AnyPtr
    final resultType = _inferAwaitReturnType(expr.operand);
    return 'smAwait<$resultType>($operand)';
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
          if (_isCppTypeParameter(resolved)) return 'AnyPtr';
          return resolved;
        }
      }
      if (returnType is FutureOrType) {
        final resolved = _cppType(returnType.typeArgument);
        if (_isCppTypeParameter(resolved)) return 'AnyPtr';
        return resolved;
      }
    } else if (expr is InstanceInvocation) {
      final target = expr.interfaceTarget;
      final returnType = target.function.returnType;
      if (returnType is InterfaceType && returnType.classNode.name == 'Future') {
        final typeArgs = returnType.typeArguments;
        if (typeArgs.isNotEmpty) {
          final resolved = _cppType(typeArgs[0]);
          if (_isCppTypeParameter(resolved)) return 'AnyPtr';
          return resolved;
        }
      }
      if (returnType is FutureOrType) {
        final resolved = _cppType(returnType.typeArgument);
        if (_isCppTypeParameter(resolved)) return 'AnyPtr';
        return resolved;
      }
    } else if (expr is ConstructorInvocation) {
      final target = expr.target;
      final enclosing = target.enclosingClass;
      if (enclosing.name == 'Future' || enclosing.name == '_Future') {
        final typeArgs = expr.arguments.types;
        if (typeArgs.isNotEmpty) {
          final resolved = _cppType(typeArgs[0]);
          if (_isCppTypeParameter(resolved)) return 'AnyPtr';
          return resolved;
        }
      }
    }
    return 'AnyPtr';
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
      final args = templateMatch.group(1)!.split(',');
      for (final arg in args) {
        final trimmed = arg.trim();
        if (_isCppTypeParameter(trimmed)) return true;
        // 递归检查嵌套模板
        if (trimmed.contains('<') && _containsTypeParameter(trimmed)) return true;
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
    // 检查是否已经是 std::exception
    if (value.startsWith('std::')) {
      return 'throw $value';
    }
    // 如果 value 已经是字符串字面量或 std::string，直接使用
    if (value.startsWith('"') || value.startsWith('dart_str(') || value.startsWith('std::string(')) {
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
        if (_userClasses.contains(className)) {
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
    if (target is Field) return '${_cleanName(target.name.text)} = $value';
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
      // 如果目标类型是 AnyGC* 但初始化器产生了非指针类型（如 int64_t, std::string），
      // 使用 IIFE 执行副作用并返回 nullptr
      if (varType == 'AnyGC*') {
        final initType = _getExpressionType(expr.variable.initializer!);
        final initCppType = initType != null ? _cppType(initType) : '';
        if (initCppType.isNotEmpty && initCppType != 'AnyGC*' && initCppType != 'AnyPtr' &&
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
      // 检查是否是 null-safe 或 null-coalescing 模式
      // 使用最后一个变量的类型和名称
      final lastVarName = vars.isNotEmpty ? vars.last : _cleanName(innerLet.variable.name ?? 'v');
      final lastVarType = types.isNotEmpty ? types.last : _cppType(innerLet.variable.type);
      final lastVarInit = inits.isNotEmpty ? inits.last : 'text';
      final nullSafe = _tryEmitNullSafeOperator(current, lastVarName, lastVarType, lastVarInit);
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
        return _emitNullCoalescing(varType, init, cond);
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
    } else if (expr is DynamicInvocation) {
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

    // std::string 需要特殊处理嵌套的 ?. 链
    if (varType == 'std::string' && cond.otherwise is Let) {
      final nestedResult = _tryEmitNestedNullSafeChain(cond.otherwise as Let, varName, varType, init);
      if (nestedResult != null) return nestedResult;
    }

    return _cppNullCheck(varType, init, otherwise, otherwiseExpr: cond.otherwise, varName: varName);
  }

  /// 尝试发射嵌套的 ?. 链（std::string 特殊处理）
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
  String _emitNullCoalescing(String varType, String init, ConditionalExpression cond) {
    final fallback = _emitCppExpr(cond.otherwise);
    if (varType == 'AnyGC*') {
      // 当变量是 AnyGC* 时，需要确保三元表达式的两个分支类型一致
      // 如果 fallback 是原始类型，将其转换为 AnyGC*
      final fallbackWrapped = _wrapAsAnyGCPtrIfNeeded(fallback, cond.otherwise);
      return '($init == nullptr ? $fallbackWrapped : $init)';
    } else if (varType.endsWith('*')) {
      return '($init == nullptr ? $fallback : $init)';
    } else if (varType == 'int64_t' || varType == 'double' || varType == 'bool' || varType == 'std::string') {
      // 基本类型不能为 null，直接返回初始化值
      return init;
    } else {
      // 其他类型（如用户自定义类）检查 nullptr
      return '($init == nullptr ? $fallback : $init)';
    }
  }

  /// 生成 null 检查表达式
  /// 对于基本类型（int64_t, double, bool, std::string），不生成 null 检查
  /// 对于指针类型，生成 == nullptr 检查
  String _emitNullCheck(String expr, String type) {
    if (type == 'int64_t' || type == 'double' || type == 'bool' || type == 'std::string') {
      // 基本类型不能为 null，返回 false
      return 'false';
    } else if (type.endsWith('*')) {
      // 指针类型检查 nullptr
      return '$expr == nullptr';
    } else {
      // 其他类型（AnyGC* 等）也检查 nullptr
      return '$expr == nullptr';
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
      return '($init == nullptr ? nullptr : $otherwiseWrapped)';
    } else if (varType.endsWith('*')) {
      return '($init == nullptr ? nullptr : $otherwise)';
    } else if (varType == 'int64_t' || varType == 'double' || varType == 'bool' || varType == 'std::string') {
      // 基本类型：如果 otherwise 引用了 Let 变量，需要包装在 lambda 中声明变量
      if (varName != null && otherwise.contains(varName)) {
        return '([&]() { $varType $varName = $init; return $otherwise; })()';
      }
      // 基本类型不能为 null，直接返回 otherwise
      return otherwise;
    } else {
      // 其他类型检查 nullptr
      return '($init == nullptr ? $varType{} : $otherwise)';
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
      final value = _emitCppExpr(stmt.expression);
      buf.writeln('${_pad}/* yield */ $value;');
    } else if (stmt is FunctionDeclaration) {
      _emitCppFunctionDeclaration(stmt, buf);
    } else if (stmt is EmptyStatement) {
      // 空语句，不生成任何代码
    } else if (stmt is AssertStatement) {
      final cond = _emitCppExpr(stmt.condition);
      // C++ assert 只接受一个 bool 参数，消息忽略（避免 std::string 与 bool 不兼容）
      buf.writeln('${_pad}assert($cond);');
    } else {
      buf.writeln('${_pad}// unsupported: ${stmt.runtimeType}');
    }
  }

  void _emitCppReturn(ReturnStatement stmt, StringBuffer buf) {
    if (_isAsyncFunction) {
      // async 函数：return expr; → _promise->complete(expr); return _promise;
      if (stmt.expression == null) {
        buf.writeln('${_pad}_promise->complete(AnyPtr::null());');
        buf.writeln('${_pad}return _promise;');
      } else {
        final value = _emitCppExpr(stmt.expression!);
        // 包装为 AnyPtr（Promise::complete 接受 AnyPtr）
        final wrappedValue = _wrapValueForPromise(value, stmt.expression!);
        buf.writeln('${_pad}_promise->complete($wrappedValue);');
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
      buf.writeln('${_pad}return;');
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
        } else if (expr is DynamicGet && expr.receiver is VariableGet) {
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
      if (_currentReturnType == 'AnyPtr') {
        final wrappedValue = _wrapInAnyPtr(value, stmt.expression!);
        buf.writeln('${_pad}return $wrappedValue;');
      } else {
        // 如果返回值是 AnyPtr::null()，需要转换为对应的类型
        if (value == 'AnyPtr::null()') {
          final defaultValue = _getDefaultValueForType(_currentReturnType);
          buf.writeln('${_pad}return $defaultValue;');
        } else {
          // 检查表达式类型是否为 AnyPtr，但函数返回基本类型，需要解包
          final exprType = _getExpressionType(stmt.expression!);
          final exprCppType = exprType != null ? _cppType(exprType) : '';
          // 如果表达式已经是具体类型（如 Map[] 解引用），不需要解包
          final needsUnwrap = exprCppType == 'AnyPtr' &&
              _currentReturnType != 'AnyPtr' &&
              !_looksLikeConcreteValue(value);
          if (needsUnwrap) {
            if (_currentReturnType == 'int64_t') {
              buf.writeln('${_pad}return $value.toInt();');
            } else if (_currentReturnType == 'double') {
              buf.writeln('${_pad}return $value.toDouble();');
            } else if (_currentReturnType == 'bool') {
              buf.writeln('${_pad}return $value.toBool();');
            } else if (_currentReturnType == 'std::string') {
              buf.writeln('${_pad}return $value.toStringValue();');
            } else {
              buf.writeln('${_pad}return $value;');
            }
          } else {
            // 检查值是否为 AnyPtr（通过表达式类型或 C++ 模式）
            if (_isAnyPtrResult(value) && _currentReturnType != 'AnyPtr') {
              buf.writeln('${_pad}return ${_unwrapFromAnyPtr(value, _currentReturnType)};');
            } else {
              buf.writeln('${_pad}return $value;');
            }
          }
        }
      }
    }
  }

  /// 将值包装为 AnyPtr 以传递给 Promise::complete
  String _wrapValueForPromise(String value, Expression expr) {
    // 如果已经是 AnyPtr 相关，直接返回
    if (value.startsWith('AnyPtr::') || value == 'AnyPtr::null()') {
      return value;
    }
    // 根据表达式类型选择包装方法
    if (expr is StringLiteral || expr is StringConcatenation) {
      return 'AnyPtr::fromString($value)';
    }
    if (expr is IntLiteral) {
      return 'AnyPtr::fromInt($value)';
    }
    if (expr is DoubleLiteral) {
      return 'AnyPtr::fromDouble($value)';
    }
    if (expr is BoolLiteral) {
      return 'AnyPtr::fromBool($value)';
    }
    // 通用情况使用 fromAuto
    return 'AnyPtr::fromAuto($value)';
  }

  /// 根据类型获取默认值
  String _getDefaultValueForType(String cppType) {
    if (cppType == 'std::string') {
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
  String _wrapInAnyPtr(String value, Expression expr) {
    // 如果已经是 AnyPtr 相关调用，不需要包装
    if (value.startsWith('AnyPtr::') || value.startsWith('GC::allocateLocal(')) {
      return value;
    }

    // DartException 需要包装为 AnyPtr
    if (value.startsWith('DartException(')) {
      return 'AnyPtr::fromException($value)';
    }

    // 根据表达式类型选择包装方法
    if (expr is StringLiteral || expr is StringConcatenation) {
      return 'AnyPtr::fromString($value)';
    } else if (expr is IntLiteral) {
      return 'AnyPtr::fromInt($value)';
    } else if (expr is DoubleLiteral) {
      return 'AnyPtr::fromDouble($value)';
    } else if (expr is BoolLiteral) {
      return 'AnyPtr::fromBool($value)';
    } else if (expr is NullLiteral) {
      return 'AnyPtr::null()';
    } else if (expr is VariableGet) {
      // 变量需要根据其类型判断
      final varType = expr.variable.type;
      return _wrapValueByType(value, varType);
    } else if (expr is StaticInvocation) {
      // 静态函数调用，根据返回类型判断
      final target = expr.target;
      final returnType = target.function.returnType;
      return _wrapValueByType(value, returnType);
    } else if (expr is InstanceInvocation) {
      // 实例方法调用，根据返回类型判断
      final target = expr.interfaceTarget;
      final returnType = target.function.returnType;
      return _wrapValueByType(value, returnType);
    } else if (expr is ConditionalExpression) {
      // 条件表达式，根据 then 分支的类型判断
      return _wrapInAnyPtr(value, expr.then);
    } else if (expr is LogicalExpression) {
      // 逻辑表达式返回 bool
      return 'AnyPtr::fromBool($value)';
    } else if (expr is EqualsCall || expr is EqualsNull) {
      // 相等性比较返回 bool
      return 'AnyPtr::fromBool($value)';
    } else if (expr is Not) {
      // 逻辑非返回 bool
      return 'AnyPtr::fromBool($value)';
    } else if (expr is IsExpression || expr is AsExpression) {
      // 类型检查和转换
      if (expr is IsExpression) {
        return 'AnyPtr::fromBool($value)';
      } else {
        return 'AnyPtr::fromAuto($value)';
      }
    }

    // 对于无法确定类型的表达式，使用自动包装
    // 这包括运算符表达式等
    return 'AnyPtr::fromAuto($value)';
  }

  /// 根据 Dart 类型包装值为 AnyPtr
  String _wrapValueByType(String value, DartType type) {
    if (type is InterfaceType) {
      final typeName = type.classNode.name;
      switch (typeName) {
        case 'String':
          return 'AnyPtr::fromString($value)';
        case 'int':
          return 'AnyPtr::fromInt($value)';
        case 'double':
          return 'AnyPtr::fromDouble($value)';
        case 'bool':
          return 'AnyPtr::fromBool($value)';
        case 'Null':
          return 'AnyPtr::null()';
        default:
          // 用户自定义类型或其他类型
          if (_userClasses.contains(typeName)) {
            return 'AnyPtr::fromVPtr($value)';
          }
          return 'AnyPtr::fromAuto($value)';
      }
    } else if (type is VoidType) {
      return value; // void 类型不需要包装
    }
    return 'AnyPtr::fromAuto($value)';
  }

  /// 将 AnyPtr 值解包为目标 C++ 类型
  String _unwrapFromAnyPtr(String value, String targetCppType) {
    if (targetCppType == 'int64_t') return '$value.toInt()';
    if (targetCppType == 'double') return '$value.toDouble()';
    if (targetCppType == 'bool') return '$value.toBool()';
    if (targetCppType == 'std::string') return '$value.toStringValue()';
    if (targetCppType.endsWith('*')) {
      final baseType = targetCppType.substring(0, targetCppType.length - 1);
      // 如果类型包含未解析的模板参数，使用 VPtr* 转换
      if (_isCppTypeParameter(baseType) || _containsTypeParameter(baseType)) {
        return 'reinterpret_cast<VPtr*>($value.toVPtr())';
      }
      return 'reinterpret_cast<$baseType*>($value.toVPtr())';
    }
    return value;
  }

  /// 仅当值可能是 AnyPtr/AnyGC* 且目标类型是具体类型时才解包
  String _unwrapFromAnyPtrIfNeeded(String value, String targetCppType) {
    if (targetCppType.isEmpty || targetCppType == 'AnyPtr' || targetCppType == 'AnyGC*' || targetCppType == 'void') return value;

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
    final isAnyPtr = !isAnyGCPtr && (_isAnyPtrExpr(value) || _isAnyPtrResult(value) || _isVariableOfTypeAnyPtr(value));
    if (!isAnyGCPtr && !isAnyPtr) return value;
    if (isAnyGCPtr) return _unwrapFromAnyGCPtr(value, targetCppType);
    return _unwrapFromAnyPtr(value, targetCppType);
  }

  /// 检查表达式是否是 AnyGC* 类型（简单变量名为 AnyGC* 类型）
  bool _isAnyGCPtrExpr(String expr) {
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
    if (otherOperand.startsWith('std::string(') || otherOperand.startsWith('"')) {
      return 'dynAs<std::string>($anyGCExpr)';
    }
    if (otherOperand == 'true' || otherOperand == 'false') {
      return 'dynAs<bool>($anyGCExpr)';
    }
    // 检查 otherOperand 的变量类型
    final otherType = _variableTypeMap[otherOperand] ?? '';
    if (otherType == 'int64_t') return 'dynAs<int64_t>($anyGCExpr)';
    if (otherType == 'double') return 'dynAs<double>($anyGCExpr)';
    if (otherType == 'std::string') return 'dynAs<std::string>($anyGCExpr)';
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
    if (argCppType == 'std::string' || (argExpr.startsWith('std::string(') && argExpr.endsWith(')'))) {
      return 'GC::allocateLocal(new StringBox($argExpr))';
    }
    if (argExpr == 'nullptr' || argExpr == 'AnyPtr::null()') return 'nullptr';
    if (argCppType.endsWith('*') || argCppType == 'AnyGC*') return argExpr;
    // If the expression already produces a pointer (GC::allocateLocal, new, etc.)
    if (_isPointerTypeExpr(argExpr)) return argExpr;
    return argExpr;
  }

  /// 从 Box 类型中提取字符串值（用于异常构造函数）
  /// 例如：GC::allocateLocal(new StringBox(std::string("msg"))) → std::string("msg")
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
    if (targetCppType == 'std::string') return 'dynAs<std::string>($value)';
    if (targetCppType.endsWith('*')) {
      // 如果类型包含未解析的模板参数，使用 VPtr* 转换
      final baseType = targetCppType.substring(0, targetCppType.length - 1);
      if (_isCppTypeParameter(baseType) || _containsTypeParameter(baseType)) {
        return 'static_cast<VPtr*>($value)';
      }
      return 'static_cast<$targetCppType>($value)';
    }
    return value;
  }

  /// 检查 C++ 表达式是否已经产生了具体类型值（非 AnyPtr）
  /// 例如：Map 解引用 `(*(*m)[k])`, 字面量, 已转换的表达式
  bool _looksLikeConcreteValue(String expr) {
    // 已经通过 .toInt() 等转换的
    if (expr.endsWith('.toInt()') || expr.endsWith('.toDouble()') ||
        expr.endsWith('.toBool()') || expr.endsWith('.toStringValue()')) return true;
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

  /// 检查简单变量名是否声明为 AnyPtr 类型
  bool _isVariableOfTypeAnyPtr(String name) {
    // 去除可能的前缀 & 或 * 操作符
    final cleanName = name.replaceAll(RegExp(r'^[&*]+'), '').trim();
    final type = _variableTypeMap[cleanName];
    return type == 'AnyPtr' || type == 'AnyGC*';
  }

  /// 检查 C++ 表达式是否返回 AnyPtr 类型（基于字符串模式）
  bool _isAnyPtrResult(String expr) {
    // 如果表达式已经通过 .toInt() 等转换为具体类型，不再是 AnyPtr
    if (expr.endsWith('.toInt()') || expr.endsWith('.toDouble()') ||
        expr.endsWith('.toBool()') || expr.endsWith('.toStringValue()')) {
      return false;
    }
    if (expr.startsWith('(reinterpret_cast<AnyPtr')) return true;  // vptr dispatch
    if (expr.startsWith('AnyPtr(')) return true;
    if (expr == 'AnyPtr::null()') return true;
    if (expr.startsWith('AnyPtr::from')) return true;
    // smAwait<AnyPtr> returns AnyPtr
    if (expr.startsWith('smAwait<AnyPtr>')) return true;
    // Promise/CompleterState 的 .result 和 .error 字段是 AnyPtr
    if (expr.endsWith('->result') || expr.endsWith('.result')) return true;
    if (expr.endsWith('->error') || expr.endsWith('.error')) return true;
    // Map access returns AnyPtr: (*(*map)[key]) - has nested (*
    if (expr.startsWith('(*(*')) return true;
    return false;
  }

  /// 将 AnyPtr/AnyGC* 接收器转换为真实类型（仿照 Dart 的 dynamic dispatch）
  /// 如果接收器已经是真实类型，直接返回
  String _castReceiverToType(String receiver, DartType? expectedType) {
    if (expectedType == null) return receiver;
    if (!_isAnyPtrResult(receiver)) return receiver;

    final cppType = _cppType(expectedType);
    if (cppType == 'AnyPtr' || cppType == 'AnyGC*' || cppType.isEmpty) return receiver;

    // 基本类型 — 使用 dynAs<T>() 拆箱（支持 AnyGC* 接收器）
    if (cppType == 'int64_t') return 'dynAs<int64_t>($receiver)';
    if (cppType == 'double') return 'dynAs<double>($receiver)';
    if (cppType == 'bool') return 'dynAs<bool>($receiver)';
    if (cppType == 'std::string') return 'dynAs<std::string>($receiver)';

    // 指针类型（集合、用户类等）— 使用 static_cast 向下转型
    // 需要先将 AnyPtr 转换为 AnyGC*，再 static_cast 到目标类型
    if (cppType.endsWith('*')) {
      final baseType = cppType.substring(0, cppType.length - 1);
      // 如果类型包含未解析的模板参数，跳过 static_cast（保留 AnyPtr 使用 VPtr* 转换）
      if (_isCppTypeParameter(baseType) || _containsTypeParameter(baseType)) {
        return 'static_cast<VPtr*>($receiver.toGC())';
      }
      return 'static_cast<$baseType*>($receiver.toGC())';
    }

    return receiver;
  }

  void _emitCppIf(IfStatement stmt, StringBuffer buf) {
    final cond = _emitCppExpr(stmt.condition);
    buf.writeln('${_pad}if ($cond) {');
    _indent++;
    _emitCppStmt(stmt.then, buf);
    _indent--;
    if (stmt.otherwise != null) {
      buf.writeln('${_pad}} else {');
      _indent++;
      _emitCppStmt(stmt.otherwise!, buf);
      _indent--;
    }
    buf.writeln('$_pad}');
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
            : 'AnyPtr';
        iteratorType = 'StaticIterator<$elemType>*';
      }
    }

    buf.writeln('${_pad}$iteratorType $iterVar = $iterable->iterator();');
    buf.writeln('${_pad}while ($iterVar->moveNext()) {');
    _indent++;

    final varType = _cppType(stmt.variable.type);
    buf.writeln('${_pad}$varType $varName = $iterVar->current();');

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
      // 生成 catch 体到临时缓冲区，然后将 exName-> 替换为 exName.
      // （catch by reference 使用 . 而非 ->）
      final catchBuf = StringBuffer();
      _emitCppStmt(c.body, catchBuf);
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
        // 生成 catch 体到临时缓冲区，替换 -> 为 .
        final catchBuf = StringBuffer();
        _emitCppStmt(c.body, catchBuf);
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

    // 生成参数列表
    final params = func.positionalParameters.map((p) {
      final pType = _cppType(p.type);
      final pName = _cleanName(p.name ?? 'p');
      return '$pType $pName';
    }).join(', ');

    final retType = _cppType(func.returnType);

    // 使用 lambda 表达式生成本地函数
    buf.writeln('${_pad}auto $funcName = [&]($params) -> $retType {');
    _indent++;
    // 保存并清除 async 标志（本地函数本身不是 async）
    final savedIsAsync = _isAsyncFunction;
    final savedReturnType = _currentReturnType;
    _isAsyncFunction = false;
    _currentReturnType = retType;
    if (func.body != null) {
      _emitCppStmt(func.body!, buf);
    }
    _isAsyncFunction = savedIsAsync;
    _currentReturnType = savedReturnType;
    _indent--;
    buf.writeln('${_pad}};');
  }

  void _emitCppSwitch(SwitchStatement stmt, StringBuffer buf) {
    final expr = _emitCppExpr(stmt.expression);
    // 检测是否在枚举类型上 switch — C++ switch 需要整型表达式
    final isEnumSwitch = _isEnumExpression(stmt.expression);
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

  String _emitCppConstant(Constant constant) {
    if (constant is IntConstant) return constant.value.toString();
    if (constant is DoubleConstant) {
      final val = constant.value.toString();
      return val.contains('.') ? val : '$val.0';
    }
    if (constant is BoolConstant) return constant.value ? 'true' : 'false';
    if (constant is StringConstant) return _cppStringLiteral(constant.value);
    if (constant is NullConstant) return 'AnyPtr::null()';
    if (constant is ListConstant) {
      if (constant.entries.isEmpty) {
        final inner = constant.typeArgument != null ? _cppType(constant.typeArgument!) : 'AnyPtr';
        return 'GC::allocateLocal(new StaticList<$inner>())';
      }
      final elements = constant.entries.map((e) => _emitCppConstant(e)).join(', ');
      final inner = constant.typeArgument != null ? _cppType(constant.typeArgument!) : 'AnyPtr';
      return 'GC::allocateLocal(new StaticList<$inner>({$elements}))';
    }
    if (constant is MapConstant) {
      final keyType = constant.keyType != null ? _cppType(constant.keyType!) : 'AnyPtr';
      final valType = constant.valueType != null ? _cppType(constant.valueType!) : 'AnyPtr';
      return 'GC::allocateLocal(new StaticMap<$keyType, $valType>())';
    }
    if (constant is SetConstant) {
      final inner = constant.typeArgument != null ? _cppType(constant.typeArgument!) : 'AnyPtr';
      if (constant.entries.isEmpty) return 'GC::allocateLocal(new StaticSet<$inner>())';
      final elements = constant.entries.map((e) => _emitCppConstant(e)).join(', ');
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
      return '([&]() { auto* _obj = GC::allocateLocal(new $structName$templateArgs());$assignStmts return _obj; })()';
    }
    if (constant is StaticTearOffConstant) {
      final target = constant.target;
      final funcName = target.name.text;
      final function = target.function;

      // Generate a generic lambda wrapper that matches std::function signature
      // Use 'auto' parameters to allow type inference from the call context
      final params = function.positionalParameters;
      final returnType = _cppType(function.returnType);

      // Build parameter list for lambda using auto
      final lambdaParams = <String>[];
      final callArgs = <String>[];
      for (var i = 0; i < params.length; i++) {
        final param = params[i];
        final paramName = param.name ?? 'arg$i';
        lambdaParams.add('auto $paramName');
        callArgs.add(paramName);
      }

      // Determine the function to call
      String callTarget;
      if (funcName == 'print') {
        callTarget = 'staticPrint';
      } else {
        callTarget = _cleanName(funcName);
      }

      // Generate lambda body
      final argsStr = callArgs.join(', ');
      if (returnType == 'void') {
        // For void functions, wrap to return AnyPtr::null()
        return '[](${lambdaParams.join(', ')}) -> AnyPtr { $callTarget($argsStr); return AnyPtr::null(); }';
      } else {
        // For non-void functions, wrap the return value if needed
        return '[](${lambdaParams.join(', ')}) -> AnyPtr { return AnyPtr::fromValue($callTarget($argsStr)); }';
      }
    }
    if (constant is TypeLiteralConstant) {
      return '/* TypeLiteral: ${constant.type} */';
    }
    return '/* TODO: constant ${constant.runtimeType} */';
  }

  // ==========================================================================
  // Type conversion helpers
  // ==========================================================================

  /// Wrap an expression to match the target C++ type.
  /// If the source expression is AnyPtr and target is a basic type,
  /// use AnyPtr conversion methods instead of static_cast.
  String _wrapToType(String expr, String targetType, Expression sourceExpr) {
    if (targetType == 'AnyPtr' || targetType.isEmpty) return expr;
    // AnyGC* 目标：AnyPtr::null() → nullptr, 基本类型需要装箱
    if (targetType == 'AnyGC*') {
      if (expr == 'AnyPtr::null()') return 'nullptr';
      // 检查源表达式类型，如果是基本类型则需要装箱
      final sourceType = _getExpressionType(sourceExpr);
      final sourceCppType = sourceType != null ? _cppType(sourceType) : '';
      if (sourceCppType == 'int64_t' || sourceCppType == 'int') {
        return 'GC::allocateLocal(new IntBox($expr))';
      }
      if (sourceCppType == 'double') {
        return 'GC::allocateLocal(new DoubleBox($expr))';
      }
      if (sourceCppType == 'bool') {
        return 'GC::allocateLocal(new BoolBox($expr))';
      }
      if (sourceCppType == 'std::string') {
        return 'GC::allocateLocal(new StringBox($expr))';
      }
      // 检查表达式是否是字面量
      if (RegExp(r'^-?\d+LL$').hasMatch(expr)) {
        return 'GC::allocateLocal(new IntBox($expr))';
      }
      if (RegExp(r'^-?\d+\.\d+$').hasMatch(expr)) {
        return 'GC::allocateLocal(new DoubleBox($expr))';
      }
      if (expr == 'true' || expr == 'false') {
        return 'GC::allocateLocal(new BoolBox($expr))';
      }
      if (expr.startsWith('std::string(') || expr.startsWith('"')) {
        return 'GC::allocateLocal(new StringBox($expr))';
      }
      return expr;
    }

    // Check if source expression type is explicitly AnyPtr or AnyGC*
    final sourceType = _getExpressionType(sourceExpr);
    final sourceCppType = sourceType != null ? _cppType(sourceType) : '';

    // Wrap if source is explicitly AnyPtr
    if (sourceCppType == 'AnyPtr' || _isAnyPtrResult(expr)) {
      switch (targetType) {
        case 'int64_t': return '$expr.toInt()';
        case 'int': return 'static_cast<int>($expr.toInt())';
        case 'double': return '$expr.toDouble()';
        case 'bool': return '$expr.toBool()';
        case 'std::string': return '$expr.toStringValue()';
      }
      // For pointer types, use toGC() + static_cast
      if (targetType.endsWith('*')) {
        final baseType = targetType.substring(0, targetType.length - 1);
        // 如果类型包含未解析的模板参数，使用 VPtr* 转换
        if (_isCppTypeParameter(baseType) || _containsTypeParameter(baseType)) {
          return 'static_cast<VPtr*>($expr.toGC())';
        }
        return 'static_cast<$baseType*>($expr.toGC())';
      }
    }

    // Wrap if source is AnyGC* (use dynAs for basic types, static_cast for pointers)
    if (sourceCppType == 'AnyGC*' || _isAnyGCPtrExpr(expr)) {
      return _unwrapFromAnyGCPtr(expr, targetType);
    }

    // 后备：如果目标类型是基本类型但表达式看起来产生 AnyPtr，进行解包
    if (_isAnyPtrResult(expr)) {
      switch (targetType) {
        case 'int64_t': return '$expr.toInt()';
        case 'int': return 'static_cast<int>($expr.toInt())';
        case 'double': return '$expr.toDouble()';
        case 'bool': return '$expr.toBool()';
        case 'std::string': return '$expr.toStringValue()';
      }
    }

    return expr;
  }

  // ==========================================================================
  // VPtr dispatch helpers
  // ==========================================================================

  /// Generate function pointer type for vptr dispatch.
  /// [argCount] is the number of method arguments (excluding `this`).
  /// 第一个参数（this__）使用 AnyGC*，其余使用 AnyPtr（reinterpret_cast 不检查类型）
  String _vptrFnType(int argCount) {
    if (argCount == 0) return 'AnyPtr(*)(AnyGC*)';
    final restParams = List.filled(argCount, 'AnyPtr').join(', ');
    return 'AnyPtr(*)(AnyGC*, $restParams)';
  }

  /// 根据目标方法的返回类型生成更精确的 vptr 函数指针类型
  /// 当返回类型是基本 C++ 类型（如 double, int64_t）时使用具体类型，避免 AnyPtr 转换问题
  String _vptrFnTypeForTarget(Member? target, int argCount) {
    String returnType = 'AnyPtr';
    if (target is Procedure) {
      final retType = _cppType(target.function.returnType);
      // 只有具体的 C++ 基本类型才使用具体类型（排除 AnyPtr、指针、模板参数）
      if (_isConcreteCppReturnType(retType)) {
        returnType = retType;
      }
    } else if (target is Field) {
      final fieldType = _cppType(target.type);
      if (_isConcreteCppReturnType(fieldType)) {
        returnType = fieldType;
      }
    }
    if (argCount == 0) return '$returnType(*)(AnyGC*)';
    final restParams = List.filled(argCount, 'AnyPtr').join(', ');
    return '$returnType(*)(AnyGC*, $restParams)';
  }

  /// 检查 C++ 类型是否是具体的（非模板参数、非 AnyPtr、非指针）
  /// 用于决定 vptr 函数指针的返回类型
  bool _isConcreteCppReturnType(String type) {
    if (type == 'AnyPtr' || type == 'void') return false;
    if (type.endsWith('*')) return false;
    // 排除单字母模板参数 (T, R, A, B, C, etc.)
    if (RegExp(r'^[A-Z]$').hasMatch(type)) return false;
    // 已知的具体类型
    const concreteTypes = {'int64_t', 'double', 'bool', 'std::string', 'int32_t', 'int16_t', 'int8_t', 'uint64_t', 'uint32_t', 'float'};
    return concreteTypes.contains(type);
  }

  /// 生成 vptr map 访问，处理 AnyGC* 到 VPtr* 的转换
  String _vptrMapAccess(String receiver, DartType? receiverType) {
    final cppType = receiverType != null ? _cppType(receiverType) : '';
    if (cppType == 'AnyGC*' || _isAnyGCPtrExpr(receiver)) {
      return 'static_cast<VPtr*>($receiver)->getVptrMap()';
    }
    return '$receiver->getVptrMap()';
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
          return 'std::string';
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
        case 'Future':
          final inner = args.isNotEmpty ? _cppType(args[0]) : 'AnyGC*';
          return 'Promise<$inner>*';
        case 'Promise':
          final inner = args.isNotEmpty ? _cppType(args[0]) : 'AnyGC*';
          return 'Promise<$inner>*';
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
      final retType = _cppType(type.returnType);
      final paramTypes = type.positionalParameters.map(_cppType).toList();
      if (paramTypes.isEmpty) return 'TypeFunction0<$retType>*';
      if (paramTypes.length <= 16) {
        return 'TypeFunction${paramTypes.length}<$retType, ${paramTypes.join(', ')}>*';
      }
      return 'AnyGC*';
    }
    if (type is FutureOrType) {
      final inner = _cppType(type.typeArgument);
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
      // 解析函数类型的返回类型和参数类型
      final retType = _resolveTypeParamInType(type.returnType, typeParams, typeArgs);
      final paramTypes = type.positionalParameters.map((p) => _resolveTypeParamInType(p, typeParams, typeArgs)).toList();
      if (paramTypes.isEmpty) return 'TypeFunction0<$retType>*';
      if (paramTypes.length <= 16) {
        return 'TypeFunction${paramTypes.length}<$retType, ${paramTypes.join(', ')}>*';
      }
      return 'AnyGC*';
    }
    if (type is InterfaceType) {
      final name = type.classNode.name;
      final args = type.typeArguments;
      if (args.isEmpty) return _cppType(type);
      final resolvedArgs = args.map((a) => _resolveTypeParamInType(a, typeParams, typeArgs)).join(', ');
      // 重建类型字符串
      if (name.startsWith('TypeFunction')) {
        return '$name<$resolvedArgs>*';
      }
      // 对于其他泛型类型，使用 _cppType 的结果（因为参数可能不是类型参数）
      return _cppType(type);
    }
    return _cppType(type);
  }

  /// C++ 参数类型映射：仅在参数位置将 DynamicType 映射为 AnyGC*
  /// 其他位置（字段、返回值等）保持 AnyPtr 不变
  String _cppParamType(DartType type) {
    if (type is DynamicType) return 'AnyGC*';
    if (type is InterfaceType) {
      final name = type.classNode.name;
      if (name == 'Object' || name == 'Null') return 'AnyGC*';
    }
    return _cppType(type);
  }

  /// C++ 调用侧自动装箱：将基本类型参数包装为 Box
  /// 当参数目标是 AnyGC*（原 dynamic）且实参是基本类型时自动装箱
  String _cppMaybeBoxArg(DartType paramType, String argExpr, DartType argType) {
    if (paramType is! DynamicType) return argExpr;
    final cppArgType = _cppType(argType);
    if (cppArgType == 'int64_t') return 'GC::allocateLocal(new IntBox($argExpr))';
    if (cppArgType == 'double') return 'GC::allocateLocal(new DoubleBox($argExpr))';
    if (cppArgType == 'bool') return 'GC::allocateLocal(new BoolBox($argExpr))';
    if (cppArgType == 'std::string') return 'GC::allocateLocal(new StringBox($argExpr))';
    return argExpr;
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
    '[]': 'index',
    '[]=': 'indexSet',
    'unary-': 'neg',
    '_': 'call',
  };

  /// 清理方法名，运算符使用可读名称
  String _cleanMethodName(String name) {
    if (_operatorNameMap.containsKey(name)) {
      return _operatorNameMap[name]!;
    }
    return _cleanName(name);
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
    if (cppType == 'std::string') return '""';
    if (cppType == 'AnyPtr') return 'AnyPtr::null()';
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
           type != 'AnyPtr' && type != 'VPtr' && type != 'Promise';
  }

  bool _isGcPointerType(String cppType) {
    return cppType.endsWith('*') && cppType != 'void*';
  }

  /// 构建 vptr 函数指针的精确类型转换，用于消除同名重载的歧义
  String _buildVptrFuncPtrCast(_VTableEntry entry, String funcRef,
      String structName, bool hasTemplate, String templateArgs, Class? cls) {
    if (hasTemplate) {
      return 'reinterpret_cast<void*>(&${funcRef})';
    }

    // 获取函数签名信息
    // 优先使用 entry.proc，否则从类中查找匹配的 procedure 或 constructor
    FunctionNode? funcNode;
    if (entry.proc != null) {
      funcNode = entry.proc!.function;
    } else if (cls != null) {
      // 尝试从 procedures 中查找
      final matchingProcs = cls.procedures.where((p) => p.name.text == entry.name).toList();
      if (matchingProcs.length == 1) {
        funcNode = matchingProcs.first.function;
      } else if (matchingProcs.length > 1) {
        // 多个同名 procedure，无法确定具体是哪一个
        // 尝试通过 kind 过滤
        final filtered = matchingProcs.where((p) {
          if (entry.kind == 'getter') return p.isGetter;
          if (entry.kind == 'setter') return p.isSetter;
          return !p.isGetter && !p.isSetter;
        }).toList();
        if (filtered.length == 1) funcNode = filtered.first.function;
      }
      // 尝试从 constructors 中查找
      if (funcNode == null) {
        final matchingCtors = cls.constructors.where((c) {
          final ctorName = c.name.text.isEmpty ? '' : c.name.text;
          return ctorName == entry.name || entry.name == '_' || entry.name == '';
        }).toList();
        if (matchingCtors.length >= 1) {
          funcNode = matchingCtors.first.function;
        }
      }
    }

    // 检查是否存在重载（同名方法有多个定义）
    bool hasOverload = false;
    if (cls != null) {
      final sameNameProcs = cls.procedures.where((p) => p.name.text == entry.name).toList();
      // 只在同名方法有多个不同签名时才认为是重载
      if (sameNameProcs.length > 1) {
        hasOverload = true;
      }
    }

    if (!hasOverload || funcNode == null) {
      return 'reinterpret_cast<void*>(&${funcRef})';
    }

    // 有重载且有签名信息：使用精确的函数指针类型消歧
    final retType = entry.kind == 'setter' ? 'void' : _cppType(funcNode.returnType);
    final thisType = '$structName$templateArgs*';
    final paramTypes = <String>[thisType]; // this__
    if (entry.kind == 'getter') {
      // getter 无额外参数
    } else if (entry.kind == 'setter') {
      if (funcNode.positionalParameters.isNotEmpty) {
        paramTypes.add(_cppType(funcNode.positionalParameters.first.type));
      } else {
        paramTypes.add('AnyPtr');
      }
    } else {
      for (final p in funcNode.positionalParameters) {
        paramTypes.add(_cppType(p.type));
      }
    }

    return 'reinterpret_cast<void*>(static_cast<$retType(*)(${paramTypes.join(', ')})>(&${funcRef}))';
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
    'GlobalScheduler', 'CompleterState',
    'StaticIterator', 'StaticMapEntry',
    'AsyncStateMachine',
  };

  bool _isRuntimeClass(Class cls) {
    return _runtimeClassNames.contains(cls.name);
  }

  /// 按名称检查是否为运行时类
  bool _isRuntimeClassName(String name) {
    return _runtimeClassNames.contains(name);
  }

  /// 运行时类的 C++ 类型映射（不加 Value 后缀，因为这些类在运行时头文件中已定义）
  String _runtimeCppType(String name, List<DartType> args) {
    switch (name) {
      case 'Promise':
      case '_Promise':
        final inner = args.isNotEmpty ? _cppType(args[0]) : 'AnyPtr';
        return 'Promise<$inner>*';
      case 'StaticList':
        final inner = args.isNotEmpty ? _cppType(args[0]) : 'AnyPtr';
        return 'StaticList<$inner>*';
      case 'StaticSet':
        final inner = args.isNotEmpty ? _cppType(args[0]) : 'AnyPtr';
        return 'StaticSet<$inner>*';
      case 'StaticMap':
        if (args.length >= 2) {
          return 'StaticMap<${_cppType(args[0])}, ${_cppType(args[1])}>*';
        }
        return 'StaticMap<AnyPtr, AnyPtr>*';
      case 'Array':
        final inner = args.isNotEmpty ? _cppType(args[0]) : 'AnyPtr';
        return 'Array<$inner>*';
      case 'StaticDuration':
        return 'StaticDuration';
      case 'StaticStringBuffer':
      case 'StringBuffer':
        return 'StaticStringBuffer*';
      case 'GlobalScheduler':
        return 'GlobalScheduler';
      case 'CompleterState':
        return 'CompleterState';
      case 'StaticIterator':
        final inner = args.isNotEmpty ? _cppType(args[0]) : 'AnyPtr';
        return 'StaticIterator<$inner>*';
      case 'StaticMapEntry':
        if (args.length >= 2) {
          return 'StaticMapEntry<${_cppType(args[0])}, ${_cppType(args[1])}>';
        }
        return 'StaticMapEntry<AnyPtr, AnyPtr>';
      default:
        // 未知运行时类，直接使用名称
        if (args.isEmpty) return name;
        final cppArgs = args.map(_cppType).join(', ');
        return '$name<$cppArgs>';
    }
  }
}
