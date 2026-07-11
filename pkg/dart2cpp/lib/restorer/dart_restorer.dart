import 'package:kernel/kernel.dart';
import 'package:kernel/ast.dart';

part 'type_utils.dart';
part 'constant_restorer.dart';
part 'expression_restorer.dart';
part 'statement_restorer.dart';
part 'enum_restorer.dart';
part 'closure_restorer.dart';
part 'declaration_restorer.dart';
part 'cpp_emitter.dart';

// ============================================================================
// 预编译正则表达式（性能优化）
// ============================================================================

/// 匹配非标识符字符（用于清理变量名/方法名）
final _nonIdentifierPattern = RegExp(r'[^a-zA-Z0-9_]');

/// 匹配以数字开头的字符串
final _digitStartPattern = RegExp(r'^[0-9]');

// ============================================================================
// 公共 API
// ============================================================================

/// 将 Dart Kernel Component 还原为 OOP-lowered Dart 源码字符串
/// （Value 对象 + 静态函数 + vptr 虚表）
String restoreDartFromComponent(Component component) {
  return DartRestorer().restore(component);
}

// ============================================================================
// 方法级泛型特化条目
// ============================================================================

/// 记录一个方法级泛型调用的特化信息。
/// [vptrSuffix] 用于生成 vptr key（如 'String'、'int'），
/// [typeArgStrs] 是原始类型字符串列表（如 ['String']、['int']），用于生成调用类型实参。
class MethodSpecEntry {
  final String vptrSuffix;
  final List<String> typeArgStrs;

  MethodSpecEntry(this.vptrSuffix, this.typeArgStrs);

  @override
  bool operator ==(Object other) =>
      other is MethodSpecEntry && other.vptrSuffix == vptrSuffix;

  @override
  int get hashCode => vptrSuffix.hashCode;
}

// ============================================================================
// 多文件支持：Library 信息
// ============================================================================

/// 记录一个 Library 的元数据，用于多文件转换时的跨库引用管理
class _LibraryInfo {
  /// 原始 Library 对象
  final Library library;

  /// import 前缀（如 'lib_0'）
  final String prefix;

  /// 输出文件名（如 'multi_file_a_restored.dart'）
  final String outputFileName;

  /// 该库定义的类名（包括合成类）
  final Set<String> classNames = {};

  /// 该库定义的 mixin 名
  final Set<String> mixinNames = {};

  /// 该库定义的 enum 名
  final Set<String> enumNames = {};

  /// 该库定义的顶层函数名
  final Set<String> procNames = {};

  /// 该库定义的顶层字段名
  final Set<String> fieldNames = {};

  /// 完全限定名到简单名的映射（多文件模式下使用）
  /// 例如：'lib_0.Animal' -> 'Animal'
  final Map<String, String> qualifiedToSimpleName = {};

  _LibraryInfo(this.library, this.prefix, this.outputFileName);

  /// 生成完全限定名（多文件模式下用于避免同名类冲突）
  /// 例如：prefix='lib_0', className='Animal' -> 'lib_0.Animal'
  String qualifiedName(String className) => '$prefix.$className';

  /// 检查某个名称是否属于该库
  bool contains(String name) =>
      classNames.contains(name) ||
      mixinNames.contains(name) ||
      enumNames.contains(name) ||
      procNames.contains(name) ||
      fieldNames.contains(name);
}

// ============================================================================
// 共享状态基类
// ============================================================================

abstract class _DartRestorerBase {
  StringBuffer _buf = StringBuffer();
  int _indent = 0;
  int _varCounter = 0;
  final Map<String, String> _cleanedNames = {};

  /// 当前 switch 语句中 ContinueSwitchStatement 的目标 case 标签映射
  Map<SwitchCase, String> _currentSwitchContinueTargets = {};

  /// LabeledStatement → 生成的标签名，用于 break label; 还原
  final Map<LabeledStatement, String> _breakTargetLabels = {};

  String get _pad => '  ' * _indent;

  /// 判断是否是运算符名称
  bool _isOperatorName(String name) {
    return const {'+', '-', '*', '/', '%', '~/', '>', '<', '>=', '<=', '&', '|', '^', '<<', '>>', '==', '[]', '[]=', '~', 'unary-'}.contains(name);
  }


  // ---- OOP Lowering 状态 ----

  /// 所有用户自定义类名集合（排除 dart: / package: 中的类）
  final Set<String> _userClasses = {};

  /// 所有 mixin 名称集合
  final Set<String> _mixinNames = {};

  /// 所有 enum 名称集合
  final Set<String> _enumNames = {};

  /// 有自定义 toString 方法的枚举名称集合
  final Set<String> _enumsWithCustomToString = {};

  /// 类继承关系：子类名 → 父类名（仅用户自定义类）
  final Map<String, String> _classHierarchy = {};

  /// 类 → 其所有虚方法名列表（含 getter/setter/operator）
  final Map<String, List<_VTableEntry>> _classVTableEntries = {};

  /// 类 → 其 Class AST 节点（用于查询字段等）
  final Map<String, Class> _classNodes = {};

  /// 合成 mixin 中间类的 lowered 名称集合（如 Dog_Animal_Printable_Orderable）
  /// 这些类不生成构造函数，需要在 super init 时跳过
  final Set<String> _syntheticLoweredNames = {};

  /// 当前正在处理的类（null 表示在顶层）
  Class? _currentClass;

  /// Bug 21: 活跃的类型参数替换映射
  /// 在还原 mixin 字段初始化器时，将 mixin 类型参数名替换为当前类的类型参数名
  /// 例如：Observable<T> → ReactiveStore<V> 时，映射 {T → V}
  Map<String, String> _activeTypeParamSubstitution = {};

  /// 精确替换：存储应该被替换的 TypeParameter 对象引用
  /// 只有在此集合中的 TypeParameter 才会被 _activeTypeParamSubstitution 替换
  /// 为空时表示按名称匹配（向后兼容 mixin 场景）
  Set<TypeParameter> _activeTypeParamTargets = {};

  /// 是否在实例方法体内（用于 this → this_ 转换）
  bool _insideMethodBody = false;

  /// 是否在静态/顶层字段初始化上下文中（用于 GC.allocateGlobal 包装）
  bool _isStaticFieldContext = false;

  /// this 的替换名称（在方法体内为 'this_'，在构造函数体内为 'obj'）
  String _thisReplacementName = 'this_';

  /// 是否在 async 函数体内（用于 return 语句包装为 Promise.value）
  bool _insideAsyncFunction = false;

  /// 当前 async 函数的内部返回类型（Future<T> 中的 T）
  String _asyncInnerReturnType = 'dynamic';

  // ---- 闭包 Lowering 状态 ----

  /// 全局闭包计数器（用于生成唯一名称）
  int _closureCounter = 0;

  /// 当前上下文名称栈（用于生成闭包命名，如 'foo', 'MyClass_doSomething'）
  final List<String> _closureContextStack = [];

  /// 待输出的闭包类和静态函数定义（延迟到顶层输出）
  final List<String> _pendingClosureDecls = [];

  /// 方法级泛型特化收集：className → { methodName → { 特化条目 } }
  /// 预扫描 AST 收集所有调用处的方法级类型实参，用于在构造函数中按特化 key 注册。
  /// 每个特化条目包含：vptrSuffix（用于 vptr key）和 typeArgStrs（用于生成调用类型实参）。
  /// 例如 Either.fold<String> → { 'Either': { 'fold': { MethodSpecEntry('String', ['String']) } } }
  final Map<String, Map<String, Set<MethodSpecEntry>>> _methodTypeSpecializations = {};

  // ---- 多文件支持状态 ----

  /// 当前正在还原的 Library 信息（多文件模式）
  _LibraryInfo? _currentLib;

  /// 所有 Library 信息（多文件模式）：importUri → info
  final Map<String, _LibraryInfo> _libInfos = {};

  /// 类名 → 所属 Library 信息（用于跨库引用时添加 prefix）
  /// 注意：当多个库有同名类时，需要使用 Class 节点作为 key
  final Map<String, _LibraryInfo> _classToLib = {};

  /// Class 节点 → 所属 Library 信息（精确匹配，避免同名类冲突）
  final Map<Class, _LibraryInfo> _classNodeToLib = {};

  /// 顶层函数名 → 所属 Library 信息
  final Map<String, _LibraryInfo> _procToLib = {};

  /// 顶层字段名 → 所属 Library 信息
  final Map<String, _LibraryInfo> _fieldToLib = {};

  /// 是否为多文件模式
  bool _isMultiFileMode = false;

  /// 获取跨库引用的前缀
  /// 如果 [name] 属于当前库，返回空字符串
  /// 如果属于其他库，返回 'prefix.'
  String _crossLibPrefix(String name) {
    if (!_isMultiFileMode) return '';

    // 检查类
    final classLib = _classToLib[name];
    if (classLib != null && classLib != _currentLib) {
      return '${classLib.prefix}.';
    }

    // 检查函数
    final procLib = _procToLib[name];
    if (procLib != null && procLib != _currentLib) {
      return '${procLib.prefix}.';
    }

    // 检查字段
    final fieldLib = _fieldToLib[name];
    if (fieldLib != null && fieldLib != _currentLib) {
      return '${fieldLib.prefix}.';
    }

    return '';
  }

  /// 获取 Class 节点的跨库引用前缀（精确匹配，避免同名类冲突）
  /// 如果 [cls] 属于当前库，返回空字符串
  /// 如果属于其他库，返回 'prefix.'
  String _crossLibPrefixForClass(Class cls) {
    if (!_isMultiFileMode) return '';

    final classLib = _classNodeToLib[cls];
    if (classLib != null && classLib != _currentLib) {
      return '${classLib.prefix}.';
    }

    return '';
  }

  /// 获取类的 VTable 条目（多文件模式下使用完全限定名）
  List<_VTableEntry> _getVTableEntries(Class cls, String className) {
    final key = _isMultiFileMode
        ? _classNodeToLib[cls]?.qualifiedName(className) ?? className
        : className;
    return _classVTableEntries[key] ?? [];
  }

  /// 根据类名获取 VTable 条目（用于查找父类或接口的条目）
  /// 在多文件模式下，需要遍历所有库来查找匹配的类
  List<_VTableEntry>? _getVTableEntriesByName(String className) {
    if (!_isMultiFileMode) {
      return _classVTableEntries[className];
    }

    // 多文件模式：尝试所有可能的完全限定名
    for (final libInfo in _libInfos.values) {
      final qualifiedKey = libInfo.qualifiedName(className);
      if (_classVTableEntries.containsKey(qualifiedKey)) {
        return _classVTableEntries[qualifiedKey];
      }
    }

    // 回退到简单名称（用于接口等）
    return _classVTableEntries[className];
  }

  /// 检查 DartType 是否包含（或就是）TypeParameterType。
  /// 用于过滤泛型上下文中的调用（如递归调用），这类调用不应该生成特化条目。
  bool _containsTypeParameter(DartType type) {
    if (type is TypeParameterType) return true;
    if (type is InterfaceType) {
      return type.typeArguments.any((t) => _containsTypeParameter(t));
    }
    if (type is FunctionType) {
      if (_containsTypeParameter(type.returnType)) return true;
      return type.positionalParameters.any((t) => _containsTypeParameter(t));
    }
    if (type is FutureOrType) {
      return _containsTypeParameter(type.typeArgument);
    }
    return false;
  }

  /// 将 DartType 转为简化的类型字符串。
  /// [asSuffix] 为 true 时用 '_' 分隔（用于 vptr key 后缀，如 'List_int'）；
  /// 为 false 时保留完整泛型语法（用于类型实参，如 'List<int>'）。
  String _typeToSpecStr(DartType type, {bool asSuffix = false}) {
    if (type is InterfaceType) {
      final name = type.classNode.name;
      if (type.typeArguments.isEmpty) return name;
      final separator = asSuffix ? '_' : ', ';
      final args = type.typeArguments.map((t) => _typeToSpecStr(t, asSuffix: asSuffix)).join(separator);
      return asSuffix ? '${name}_$args' : '$name<$args>';
    }
    if (type is TypeParameterType) return type.parameter.name ?? 'T';
    if (type is DynamicType) return 'dynamic';
    if (type is VoidType) return 'void';
    if (type is FunctionType) {
      // vptr key / spec 后缀里不带 `<...>`，否则会污染 key 命名空间；这里
      // 只用一个稳定的标记词，使用 `TypeFunction` 即可（不出现 `Function`
      // 字面量）。
      return 'TypeFunction';
    }
    return 'dynamic';
  }

  /// 便捷方法：生成 vptr key 后缀（如 'String', 'List_int'）
  String _typeToSpecSuffix(DartType type) => _typeToSpecStr(type, asSuffix: true);

  /// 便捷方法：生成类型实参字符串（如 'String', 'List<int>'）
  String _typeToSpecRestoreStr(DartType type) => _typeToSpecStr(type, asSuffix: false);

  /// 当前闭包体内，被捕获变量 → env 前缀的映射
  /// key: VariableDeclaration (identity), value: env 字段访问前缀（如 'env.'）
  /// 当此映射非空时，_restoreVarGet/Set 会检查变量是否在映射中，
  /// 如果在则输出 'env.varName' 而非 'varName'
  final Map<VariableDeclaration, String> _capturedVarEnvPrefix = {};

  /// 当前闭包体内，this 是否被捕获到 env 中
  /// 如果为 true，ThisExpression 会被替换为 'env._thisReplacementName'
  bool _thisIsCapturedInEnv = false;

  // ---- Box 化 (Bug 11 闭包引用语义) ----

  /// 需要 Box 化的变量声明集合。
  /// 进入函数/方法前预分析：凡是被内层 FunctionExpression 捕获的"局部变量"或"参数"，
  /// 都需要装箱以保证闭包持有引用、读写可见多个闭包共享。
  /// 当变量在此集合中时：
  ///   - 声明处（_restoreVarDecl）：生成 `BoxType v = BoxType(init);`
  ///   - 读取（_restoreVarGet）：追加 `.value`
  ///   - 写入（_restoreVarSet）：追加 `.value`
  ///   - 作为闭包构造参数传递：直接传 Box 实例（多个闭包共享同一 Box）
  ///   - 闭包 env 字段类型：Box 类型；env 内部访问额外 `.value`
  final Set<VariableDeclaration> _boxedVars = {};

  /// 当前正在生成的函数/方法的参数列表（用于判断 VariableDeclaration 是参数还是局部变量）
  /// 在进入函数/方法/闭包前填充，退出时清理。
  final Set<VariableDeclaration> _currentFunctionParams = {};

  /// 判断类型是否需要装箱：
  /// - int/double/bool/String 基础值类型需要装箱
  /// - TypeParameterType 泛型参数运行时可能是值类型，也需要装箱
  /// - 其他确定的引用类型（List、Map、函数、用户类等）不需要装箱
  bool _needsBoxing(DartType type) {
    if (_primitiveBoxName(type) != null) return true;
    if (type is TypeParameterType) return true;
    return false;
  }

  /// 根据 DartType 选择合适的 Box 类型名称（基础类型识别）
  /// 仅对 int/double/bool/String 返回 IntBox/DoubleBox/BoolBox/StringBox；
  /// 其他类型（函数、对象、泛型参数等）为引用类型，不需要装箱，返回 null。
  String? _primitiveBoxName(DartType type) {
    if (type is InterfaceType) {
      final name = type.classNode.name;
      final nonNull = type.nullability != Nullability.nullable;
      if (nonNull) {
        if (name == 'int') return 'IntBox';
        if (name == 'double') return 'DoubleBox';
        if (name == 'String') return 'StringBox';
        if (name == 'bool') return 'BoolBox';
      }
    }
    return null;
  }

  /// 预分析：遍历一个 FunctionNode 的函数体，收集所有被内层 FunctionExpression
  /// 捕获的"本层作用域的局部变量或参数"。这些变量需要 Box 化以保证引用语义。
  ///
  /// 规则：
  /// - `func` 本身的 positional/named 参数和其函数体内声明的局部变量视为"本层"
  /// - 任意层级嵌套的 FunctionExpression 若捕获了"本层变量"，都计入 Box 化集合
  /// - 结果累加到 `_boxedVars`
  ///
  /// 必须在进入该函数体之前调用，这样后续 _restoreVarDecl/_restoreVarGet 才能看到标记。
  void _preanalyzeBoxedVarsForFunc(FunctionNode func) {
    if (func.body == null) return;

    // 收集本层作用域的所有候选变量（参数 + 局部变量，不穿透进嵌套 FunctionExpression）
    final localOfThisLevel = <VariableDeclaration>{};
    localOfThisLevel.addAll(func.positionalParameters);
    localOfThisLevel.addAll(func.namedParameters);
    _collectShallowDecls(func.body!, localOfThisLevel);

    // 收集所有嵌套 FunctionExpression（任意深度；对每个运行捕获分析）
    final innerClosures = <FunctionExpression>[];
    _collectAllFunctionExpressions(func.body!, innerClosures);

    // 排除：命名参数（_raw 改名会破坏调用处的命名参数调用）
    // 排除：for 循环变量（Dart 语义为每次迭代独立，值捕获即可符合用户期望）
    final namedParamSet = <VariableDeclaration>{};
    namedParamSet.addAll(func.namedParameters);

    for (final fe in innerClosures) {
      final analysis = analyzeCapturedVarsFromFunc(fe.function);
      for (final captured in analysis.capturedDecls) {
        if (!localOfThisLevel.contains(captured)) continue;
        if (namedParamSet.contains(captured)) continue;
        // for 循环变量：parent 为 ForStatement，且位于 variables 列表
        final parent = captured.parent;
        if (parent is ForStatement && parent.variables.contains(captured)) continue;
        // 只对基础值类型和泛型参数类型装箱；
        // 函数类型、对象类型（List、Map、用户类等确定的引用类型）不需要装箱
        if (!_needsBoxing(captured.type)) continue;
        _boxedVars.add(captured);
      }
    }
  }

  /// 浅层收集 VariableDeclaration：不穿透进 FunctionExpression，因为嵌套闭包的
  /// 局部变量属于它自己的作用域，由各自层级单独预分析。
  /// 对 FunctionDeclaration 仅添加其绑定的变量但不穿透其函数体。
  void _collectShallowDecls(TreeNode node, Set<VariableDeclaration> out) {
    if (node is FunctionExpression) return;
    if (node is FunctionDeclaration) {
      out.add(node.variable);
      return;
    }
    if (node is VariableDeclaration) {
      out.add(node);
      // 继续遍历 initializer（子表达式可能含嵌套结构，但不会再有另一个顶层 decl）
      if (node.initializer != null) {
        _collectShallowDecls(node.initializer!, out);
      }
      return;
    }
    _visitChildrenForLocalDecl(node, out);
  }

  /// 通用 AST 子节点遍历器。
  /// 对 [node] 的每个直接子节点调用 [visit]。
  /// [onTryCatchVar]：TryCatch 中的 exception/stackTrace 变量声明回调（可选）。
  /// [onLetVar]：Let 表达式中的变量声明回调（可选）。
  void _forEachChildNode(
    TreeNode node,
    void Function(TreeNode) visit, {
    void Function(VariableDeclaration)? onTryCatchVar,
    void Function(VariableDeclaration)? onLetVar,
  }) {
    if (node is Block) {
      for (final s in node.statements) visit(s);
    } else if (node is ExpressionStatement) {
      visit(node.expression);
    } else if (node is ReturnStatement) {
      if (node.expression != null) visit(node.expression!);
    } else if (node is IfStatement) {
      visit(node.condition);
      visit(node.then);
      if (node.otherwise != null) visit(node.otherwise!);
    } else if (node is ForStatement) {
      for (final v in node.variables) visit(v);
      if (node.condition != null) visit(node.condition!);
      for (final u in node.updates) visit(u);
      visit(node.body);
    } else if (node is ForInStatement) {
      visit(node.variable);
      visit(node.iterable);
      visit(node.body);
    } else if (node is WhileStatement) {
      visit(node.condition);
      visit(node.body);
    } else if (node is DoStatement) {
      visit(node.body);
      visit(node.condition);
    } else if (node is TryCatch) {
      visit(node.body);
      for (final c in node.catches) {
        if (onTryCatchVar != null) {
          if (c.exception != null) onTryCatchVar(c.exception!);
          if (c.stackTrace != null) onTryCatchVar(c.stackTrace!);
        }
        visit(c.body);
      }
    } else if (node is TryFinally) {
      visit(node.body);
      visit(node.finalizer);
    } else if (node is SwitchStatement) {
      visit(node.expression);
      for (final c in node.cases) visit(c.body);
    } else if (node is LabeledStatement) {
      visit(node.body);
    } else if (node is YieldStatement) {
      visit(node.expression);
    } else if (node is AssertStatement) {
      visit(node.condition);
      if (node.message != null) visit(node.message!);
    } else if (node is VariableDeclaration) {
      if (node.initializer != null) visit(node.initializer!);
    } else if (node is Let) {
      if (onLetVar != null) onLetVar(node.variable);
      if (node.variable.initializer != null) visit(node.variable.initializer!);
      visit(node.body);
    } else if (node is BlockExpression) {
      visit(node.body);
      visit(node.value);
    } else if (node is InstanceInvocation) {
      visit(node.receiver);
      for (final a in node.arguments.positional) visit(a);
      for (final a in node.arguments.named) visit(a.value);
    } else if (node is StaticInvocation) {
      for (final a in node.arguments.positional) visit(a);
      for (final a in node.arguments.named) visit(a.value);
    } else if (node is ConstructorInvocation) {
      for (final a in node.arguments.positional) visit(a);
      for (final a in node.arguments.named) visit(a.value);
    } else if (node is InstanceGet) {
      visit(node.receiver);
    } else if (node is InstanceSet) {
      visit(node.receiver);
      visit(node.value);
    } else if (node is VariableSet) {
      visit(node.value);
    } else if (node is ConditionalExpression) {
      visit(node.condition);
      visit(node.then);
      visit(node.otherwise);
    } else if (node is LogicalExpression) {
      visit(node.left);
      visit(node.right);
    } else if (node is Not) {
      visit(node.operand);
    } else if (node is StringConcatenation) {
      for (final e in node.expressions) visit(e);
    } else if (node is AsExpression) {
      visit(node.operand);
    } else if (node is IsExpression) {
      visit(node.operand);
    } else if (node is NullCheck) {
      visit(node.operand);
    } else if (node is AwaitExpression) {
      visit(node.operand);
    } else if (node is ListLiteral) {
      for (final e in node.expressions) visit(e);
    } else if (node is SetLiteral) {
      for (final e in node.expressions) visit(e);
    } else if (node is MapLiteral) {
      for (final e in node.entries) {
        visit(e.key);
        visit(e.value);
      }
    } else if (node is Throw) {
      visit(node.expression);
    } else if (node is EqualsCall) {
      visit(node.left);
      visit(node.right);
    } else if (node is EqualsNull) {
      visit(node.expression);
    } else if (node is FunctionInvocation) {
      visit(node.receiver);
      for (final a in node.arguments.positional) visit(a);
      for (final a in node.arguments.named) visit(a.value);
    } else if (node is DynamicInvocation) {
      visit(node.receiver);
      for (final a in node.arguments.positional) visit(a);
      for (final a in node.arguments.named) visit(a.value);
    } else if (node is LocalFunctionInvocation) {
      for (final a in node.arguments.positional) visit(a);
      for (final a in node.arguments.named) visit(a.value);
    }
    // 其他叶子节点（字面量、VariableGet、ThisExpression 等）无子节点，跳过
  }

  void _visitChildrenForLocalDecl(TreeNode node, Set<VariableDeclaration> out) {
    _forEachChildNode(node, (child) => _collectShallowDecls(child, out),
        onTryCatchVar: (v) => out.add(v),
        onLetVar: (v) => out.add(v));
  }

  /// 深层收集：任意嵌套层级的 FunctionExpression 都收集
  void _collectAllFunctionExpressions(TreeNode node, List<FunctionExpression> out) {
    if (node is FunctionExpression) {
      out.add(node);
      // 继续穿透进其 body，收集内部嵌套
      if (node.function.body != null) {
        _collectAllFunctionExpressions(node.function.body!, out);
      }
      return;
    }
    if (node is FunctionDeclaration) {
      // function declaration 内部也可能有 FunctionExpression
      if (node.function.body != null) {
        _collectAllFunctionExpressions(node.function.body!, out);
      }
      return;
    }
    // 通用递归：遍历所有子节点
    _forEachChildNode(node, (child) => _collectAllFunctionExpressions(child, out));
  }

  /// 清理闭包上下文名称，确保是合法的 Dart 标识符
  /// 扩展方法名如 "StringExtensions|get#capitalize" 需要转换为 "StringExtensions_get_capitalize"
  String _sanitizeClosureContextName(String name) {
    if (name.contains('|')) {
      return _sanitizeExtensionMethodName(name);
    }
    // 替换所有非法字符为下划线
    return name.replaceAll(_nonIdentifierPattern, '_');
  }

  /// 推入闭包上下文名称（自动清理非法字符）
  void _pushClosureContext(String name) =>
      _closureContextStack.add(_sanitizeClosureContextName(name));

  /// 弹出闭包上下文名称
  void _popClosureContext() {
    if (_closureContextStack.isNotEmpty) _closureContextStack.removeLast();
  }

  /// 获取当前闭包上下文名称
  String get _closureContext {
    if (_closureContextStack.isNotEmpty) return _closureContextStack.last;
    return 'anon';
  }

  /// 将方法名转换为 VTable 字段名
  /// 特殊处理：避免与 Object 内置方法冲突（如 toString、hashCode、noSuchMethod）
  String _vtableFieldName(String methodName) {
    return methodName;
  }

  /// 简化版类型还原（用于签名生成）
  /// 将 Kernel DartType 转换为 Dart 类型字符串，用户自定义类映射为 XValue 形式
  String _restoreTypeForSignature(DartType type) {
    final nullable = type.nullability == Nullability.nullable;
    final suffix = nullable ? '?' : '';
    if (type is InterfaceType) {
      final name = type.classNode.name;
      // 集合静态化映射（与 _restoreType 保持一致）
      String mappedName;
      if (_isUserClass(name)) {
        mappedName = '${name}Value';
      } else if (name == 'List' || name == '_GrowableList' || name == '_List') {
        mappedName = 'StaticList';
      } else if (name == 'Map' || name == '_Map' || name == 'LinkedHashMap' || name == '_InternalLinkedHashMap') {
        mappedName = 'StaticMap';
      } else if (name == 'Set' || name == '_Set' || name == 'LinkedHashSet' || name == '_CompactLinkedHashSet') {
        mappedName = 'StaticSet';
      } else if (name == 'Future' || name == '_Future') {
        mappedName = 'Promise';
      } else if (name == 'Function') {
        // dart:core 的 `Function` interface type 缺少 arity → 退化到 `dynamic`
        return 'dynamic';
      } else if (name == 'StringBuffer') {
        mappedName = 'StaticStringBuffer';
      } else if (name == 'Iterator' || name == '_ListIterator') {
        mappedName = 'StaticIterator';
      } else if (name == 'MapEntry') {
        mappedName = 'StaticMapEntry';
      } else if (name == 'Duration') {
        mappedName = 'StaticDuration';
      } else if (name == 'DateTime') {
        mappedName = 'StaticDateTime';
      } else if (name == 'RegExp' || name == '_RegExp') {
        mappedName = 'StaticRegExp';
      } else {
        mappedName = name;
      }
      if (type.typeArguments.isEmpty) return '$mappedName$suffix';
      final args = type.typeArguments.map((t) => _restoreTypeForSignature(t)).join(', ');
      return '$mappedName<$args>$suffix';
    }
    if (type is FunctionType) {
      // 与 _TypeUtils._restoreFunctionTypeAsTypeFunction 等价的本地版本：
      // 复用 signature 上下文的递归 `_restoreTypeForSignature` 解析子类型。
      final ret = _restoreTypeForSignature(type.returnType);
      final hasNamed = type.namedParameters.isNotEmpty;
      final positional = type.positionalParameters;
      final required = type.requiredParameterCount;
      final hasOptional = positional.length > required;
      const kMax = _TypeUtils.kMaxArity;
      if (hasNamed || hasOptional || positional.length > kMax) {
        return 'TypeFunction<$ret>$suffix';
      }
      final arity = positional.length;
      final paramTexts =
          [for (final p in positional) _restoreTypeForSignature(p)];
      final args = [ret, ...paramTexts].join(', ');
      return 'TypeFunction$arity<$args>$suffix';
    }
    if (type is TypeParameterType) {
      // 在 vptr 签名中，类型参数可能在调用处不可用（如 main 函数中调用泛型类的方法）
      // 检查类型参数是否来自类的声明（而非方法的局部类型参数）
      // 如果在方法体内（_insideMethodBody），类型参数可能可用；否则替换为 dynamic
      final paramName = type.parameter.name ?? 'T';
      // 先检查活跃的类型参数替换映射（如子类具体化了父类类型参数 T → int）
      // 精确匹配：如果 _activeTypeParamTargets 非空，只替换属于目标集合中的 TypeParameter
      final replacement = _activeTypeParamSubstitution[paramName];
      if (replacement != null) {
        if (_activeTypeParamTargets.isEmpty || _activeTypeParamTargets.contains(type.parameter)) {
          return '$replacement$suffix';
        }
      }
      if (!_insideMethodBody) {
        return 'dynamic';
      }
      return '$paramName$suffix';
    }
    if (type is DynamicType) return 'dynamic';
    if (type is VoidType) return 'void';
    if (type is NeverType) return 'Never$suffix';
    return 'dynamic';
  }

  /// 判断类名是否是用户自定义类（包括合成 mixin 中间类）
  bool _isUserClass(String name) {
    if (_userClasses.contains(name)) return true;
    // 合成 mixin 中间类：原始名包含 &，规范化后在 _userClasses 中
    if (name.contains('&')) {
      return _userClasses.contains(_sanitizeSyntheticName(name));
    }
    return false;
  }

  /// 判断类名是否是 mixin 声明
  bool _isMixinName(String name) => _mixinNames.contains(name);

  /// 判断类名是否是 enum
  bool _isEnumName(String name) => _enumNames.contains(name);

  /// 判断类名是否需要 lowering（用户类、mixin、enum 或合成 mixin 中间类）
  bool _needsLowering(String name) {
    if (_userClasses.contains(name) || _mixinNames.contains(name) || _enumNames.contains(name)) {
      return true;
    }
    // 合成 mixin 中间类：原始名包含 &，规范化后在 _userClasses 中
    if (name.contains('&')) {
      return _userClasses.contains(_sanitizeSyntheticName(name));
    }
    return false;
  }

  /// 判断是否是合成 mixin 中间类（名字包含 &）
  bool _isSyntheticMixinClassName(String name) => name.contains('&');

  /// 规范化合成 mixin 类名：`_Dog&Animal&Printable` → `Dog_Animal_Printable`
  String _sanitizeSyntheticName(String name) {
    // 去掉前缀 _ 并将 & 替换为 _
    var result = name;
    if (result.startsWith('_')) result = result.substring(1);
    return result.replaceAll('&', '_');
  }

  /// 获取类的 lowered 名称（合成类名规范化，普通类名不变）
  String _loweredClassName(String rawName) {
    if (_isSyntheticMixinClassName(rawName)) {
      return _sanitizeSyntheticName(rawName);
    }
    return rawName;
  }

  /// 获取用户自定义类的父类名（如果有）
  String? _getParentClassName(String className) => _classHierarchy[className];

  /// 获取运算符的函数名后缀
  String _operatorFuncName(String operatorSymbol) {
    const mapping = {
      '+': 'Plus', '-': 'Minus', '*': 'Star', '/': 'Div',
      '%': 'Mod', '~/': 'TruncDiv', '>': 'Gt', '<': 'Lt',
      '>=': 'Gte', '<=': 'Lte', '&': 'BitAnd', '|': 'BitOr',
      '^': 'BitXor', '<<': 'Shl', '>>': 'Shr', '==': 'Eq',
      '[]': 'Index', '[]=': 'IndexSet', '~': 'BitNot', 'unary-': 'Neg',
    };
    return mapping[operatorSymbol] ?? operatorSymbol;
  }

  /// 生成方法的静态函数名
  String _staticMethodName(String className, String methodName) {
    if (_isOperatorName(methodName)) {
      return '${className}_operator${_operatorFuncName(methodName)}';
    }
    return '${className}_$methodName';
  }

  /// 生成 getter 的静态函数名
  String _staticGetterName(String className, String propName) {
    return '${className}_get_$propName';
  }

  /// 生成 setter 的静态函数名
  String _staticSetterName(String className, String propName) {
    return '${className}_set_$propName';
  }

  /// 清理扩展方法的原始函数名（Kernel AST 中格式为 "ExtName|methodName" 或 "ExtName|get#propName"）
  /// 返回合法的 Dart 标识符，如：
  ///   "StringExtensions|capitalize"      → "StringExtensions_capitalize"
  ///   "StringExtensions|get#capitalize"  → "StringExtensions_get_capitalize"
  ///   "StringExtensions|get#isPalindrome" → "StringExtensions_get_isPalindrome"
  ///   "ListExtensions|filterWhere"        → "ListExtensions_filterWhere"
  String _sanitizeExtensionMethodName(String rawName) {
    if (!rawName.contains('|')) return rawName;
    // 分割 ExtensionName 和 memberName
    final pipeIdx = rawName.indexOf('|');
    final extensionName = rawName.substring(0, pipeIdx);
    var memberPart = rawName.substring(pipeIdx + 1);
    // 处理 "get#propName" 或 "set#propName" 格式
    if (memberPart.startsWith('get#')) {
      final propName = memberPart.substring(4);
      return '${extensionName}_get_$propName';
    }
    if (memberPart.startsWith('set#')) {
      final propName = memberPart.substring(4);
      return '${extensionName}_set_$propName';
    }
    // 普通方法：替换所有非法字符
    memberPart = memberPart.replaceAll(RegExp(r'[^a-zA-Z0-9_]'), '_');
    return '${extensionName}_$memberPart';
  }

  /// 判断一个函数名是否是扩展方法（包含 | 字符）
  bool _isExtensionMethodName(String name) => name.contains('|');

  /// 获取类型的默认值字符串（用于可选参数的默认值补齐）
  String _defaultValueForType(DartType type) {
    if (type is InterfaceType) {
      final name = type.classNode.name;
      if (name == 'int' && type.nullability != Nullability.nullable) return '0';
      if (name == 'double' && type.nullability != Nullability.nullable) return '0.0';
      if (name == 'bool' && type.nullability != Nullability.nullable) return 'false';
      if (name == 'String' && type.nullability != Nullability.nullable) return "''";
    }
    return 'null';
  }

  /// 当参数目标是 AnyGC（原 dynamic）且实参是基本类型时，自动装箱
  /// [paramType] 是目标函数的声明参数类型（DartType）
  /// [argExpr] 是已还原的参数表达式字符串
  /// [argType] 是参数表达式的静态类型（DartType，可为 null）
  String _maybeBoxForAnyGC(DartType paramType, String argExpr, DartType? argType) {
    // 只有参数类型是 dynamic（现在映射为 AnyGC）时才需要装箱
    if (paramType is! DynamicType) return argExpr;

    // 检查参数的静态类型是否是基础值类型
    if (argType != null) {
      final boxName = _primitiveBoxName(argType);
      if (boxName != null) return '$boxName($argExpr)';
    }

    // 如果类型未知，通过表达式模式匹配判断是否是字面量
    // 整数字面量（正整数或负整数）
    if (RegExp(r'^-?\d+$').hasMatch(argExpr)) return 'IntBox($argExpr)';
    // 浮点数字面量
    if (RegExp(r'^-?\d+\.\d+$').hasMatch(argExpr)) return 'DoubleBox($argExpr)';
    // 布尔字面量
    if (argExpr == 'true' || argExpr == 'false') return 'BoolBox($argExpr)';
    // 字符串字面量（以引号开头和结尾）
    if ((argExpr.startsWith("'") && argExpr.endsWith("'")) ||
        (argExpr.startsWith('"') && argExpr.endsWith('"'))) {
      return 'StringBox($argExpr)';
    }

    return argExpr;
  }

  // 跨模块方法的抽象声明（打破 mixin 循环依赖）
  String _restoreExpr(Expression expr);
  void _restoreStmt(Statement stmt);
  void _writeTypeParams(List<TypeParameter> params);
  void _writeParams(FunctionNode func);
}

/// 闭包捕获变量分析结果（纯 AST 层面，不含类型字符串）
class _CaptureAnalysisResult {
  /// 捕获的外部变量声明（VariableDeclaration 引用）
  final List<VariableDeclaration> capturedDecls;
  /// 是否捕获了 this
  final bool capturesThis;

  _CaptureAnalysisResult({required this.capturedDecls, required this.capturesThis});
}

/// 分析 FunctionNode 捕获的外部变量（纯 AST 遍历，不依赖 restorer 状态）
_CaptureAnalysisResult analyzeCapturedVarsFromFunc(FunctionNode func) {
  final localDecls = <VariableDeclaration>{};
  localDecls.addAll(func.positionalParameters);
  localDecls.addAll(func.namedParameters);

  final capturedSet = <VariableDeclaration>{};
  bool capturesThis = false;

  if (func.body != null) {
    _collectCaptured(func.body!, localDecls, capturedSet, (flag) {
      capturesThis = true;
    });
  }

  return _CaptureAnalysisResult(
    capturedDecls: capturedSet.toList(),
    capturesThis: capturesThis,
  );
}

/// 递归遍历 AST 节点，收集捕获的外部变量声明
void _collectCaptured(
  TreeNode node,
  Set<VariableDeclaration> localDecls,
  Set<VariableDeclaration> captured,
  void Function(bool) onThisCaptured,
) {
  if (node is VariableDeclaration) {
    localDecls.add(node);
    if (node.initializer != null) {
      _collectCaptured(node.initializer!, localDecls, captured, onThisCaptured);
    }
    return;
  }

  if (node is VariableGet) {
    if (!localDecls.contains(node.variable)) {
      captured.add(node.variable);
    }
    return;
  }

  if (node is VariableSet) {
    if (!localDecls.contains(node.variable)) {
      captured.add(node.variable);
    }
    _collectCaptured(node.value, localDecls, captured, onThisCaptured);
    return;
  }

  if (node is ThisExpression) {
    onThisCaptured(true);
    return;
  }

  if (node is FunctionExpression) {
    // 嵌套闭包：分析内层捕获，冒泡到当前层
    final innerLocalDecls = <VariableDeclaration>{};
    innerLocalDecls.addAll(node.function.positionalParameters);
    innerLocalDecls.addAll(node.function.namedParameters);

    final innerCaptured = <VariableDeclaration>{};
    bool innerCapturesThis = false;

    if (node.function.body != null) {
      _collectCaptured(node.function.body!, innerLocalDecls, innerCaptured, (flag) {
        innerCapturesThis = true;
      });
    }

    // 冒泡：内层捕获的变量如果也不在当前层的局部作用域中，则当前层也需要捕获
    for (final decl in innerCaptured) {
      if (!localDecls.contains(decl)) {
        captured.add(decl);
      }
    }

    if (innerCapturesThis) {
      onThisCaptured(true);
    }
    return;
  }

  // 对于 Block、If、For 等复合节点，递归遍历子节点
  if (node is Block) {
    for (final s in node.statements) {
      _collectCaptured(s, localDecls, captured, onThisCaptured);
    }
    return;
  }
  if (node is ReturnStatement) {
    if (node.expression != null) {
      _collectCaptured(node.expression!, localDecls, captured, onThisCaptured);
    }
    return;
  }
  if (node is ExpressionStatement) {
    _collectCaptured(node.expression, localDecls, captured, onThisCaptured);
    return;
  }
  if (node is IfStatement) {
    _collectCaptured(node.condition, localDecls, captured, onThisCaptured);
    _collectCaptured(node.then, localDecls, captured, onThisCaptured);
    if (node.otherwise != null) {
      _collectCaptured(node.otherwise!, localDecls, captured, onThisCaptured);
    }
    return;
  }
  if (node is ForStatement) {
    for (final v in node.variables) {
      _collectCaptured(v, localDecls, captured, onThisCaptured);
    }
    if (node.condition != null) {
      _collectCaptured(node.condition!, localDecls, captured, onThisCaptured);
    }
    for (final u in node.updates) {
      _collectCaptured(u, localDecls, captured, onThisCaptured);
    }
    _collectCaptured(node.body, localDecls, captured, onThisCaptured);
    return;
  }
  if (node is ForInStatement) {
    _collectCaptured(node.variable, localDecls, captured, onThisCaptured);
    _collectCaptured(node.iterable, localDecls, captured, onThisCaptured);
    _collectCaptured(node.body, localDecls, captured, onThisCaptured);
    return;
  }
  if (node is WhileStatement) {
    _collectCaptured(node.condition, localDecls, captured, onThisCaptured);
    _collectCaptured(node.body, localDecls, captured, onThisCaptured);
    return;
  }
  if (node is DoStatement) {
    _collectCaptured(node.body, localDecls, captured, onThisCaptured);
    _collectCaptured(node.condition, localDecls, captured, onThisCaptured);
    return;
  }
  if (node is TryCatch) {
    _collectCaptured(node.body, localDecls, captured, onThisCaptured);
    for (final c in node.catches) {
      if (c.exception != null) localDecls.add(c.exception!);
      if (c.stackTrace != null) localDecls.add(c.stackTrace!);
      _collectCaptured(c.body, localDecls, captured, onThisCaptured);
    }
    return;
  }
  if (node is TryFinally) {
    _collectCaptured(node.body, localDecls, captured, onThisCaptured);
    _collectCaptured(node.finalizer, localDecls, captured, onThisCaptured);
    return;
  }
  if (node is SwitchStatement) {
    _collectCaptured(node.expression, localDecls, captured, onThisCaptured);
    for (final c in node.cases) {
      _collectCaptured(c.body, localDecls, captured, onThisCaptured);
    }
    return;
  }

  // 表达式节点的递归处理
  if (node is InstanceInvocation) {
    _collectCaptured(node.receiver, localDecls, captured, onThisCaptured);
    for (final a in node.arguments.positional) {
      _collectCaptured(a, localDecls, captured, onThisCaptured);
    }
    for (final a in node.arguments.named) {
      _collectCaptured(a.value, localDecls, captured, onThisCaptured);
    }
    return;
  }
  if (node is StaticInvocation) {
    for (final a in node.arguments.positional) {
      _collectCaptured(a, localDecls, captured, onThisCaptured);
    }
    for (final a in node.arguments.named) {
      _collectCaptured(a.value, localDecls, captured, onThisCaptured);
    }
    return;
  }
  if (node is ConstructorInvocation) {
    for (final a in node.arguments.positional) {
      _collectCaptured(a, localDecls, captured, onThisCaptured);
    }
    for (final a in node.arguments.named) {
      _collectCaptured(a.value, localDecls, captured, onThisCaptured);
    }
    return;
  }
  if (node is InstanceGet) {
    _collectCaptured(node.receiver, localDecls, captured, onThisCaptured);
    return;
  }
  if (node is InstanceSet) {
    _collectCaptured(node.receiver, localDecls, captured, onThisCaptured);
    _collectCaptured(node.value, localDecls, captured, onThisCaptured);
    return;
  }
  if (node is ConditionalExpression) {
    _collectCaptured(node.condition, localDecls, captured, onThisCaptured);
    _collectCaptured(node.then, localDecls, captured, onThisCaptured);
    _collectCaptured(node.otherwise, localDecls, captured, onThisCaptured);
    return;
  }
  if (node is LogicalExpression) {
    _collectCaptured(node.left, localDecls, captured, onThisCaptured);
    _collectCaptured(node.right, localDecls, captured, onThisCaptured);
    return;
  }
  if (node is Not) {
    _collectCaptured(node.operand, localDecls, captured, onThisCaptured);
    return;
  }
  if (node is StringConcatenation) {
    for (final e in node.expressions) {
      _collectCaptured(e, localDecls, captured, onThisCaptured);
    }
    return;
  }
  if (node is ListLiteral) {
    for (final e in node.expressions) {
      _collectCaptured(e, localDecls, captured, onThisCaptured);
    }
    return;
  }
  if (node is MapLiteral) {
    for (final e in node.entries) {
      _collectCaptured(e.key, localDecls, captured, onThisCaptured);
      _collectCaptured(e.value, localDecls, captured, onThisCaptured);
    }
    return;
  }
  if (node is Let) {
    _collectCaptured(node.variable, localDecls, captured, onThisCaptured);
    _collectCaptured(node.body, localDecls, captured, onThisCaptured);
    return;
  }
  if (node is BlockExpression) {
    _collectCaptured(node.body, localDecls, captured, onThisCaptured);
    _collectCaptured(node.value, localDecls, captured, onThisCaptured);
    return;
  }
  if (node is Throw) {
    _collectCaptured(node.expression, localDecls, captured, onThisCaptured);
    return;
  }
  if (node is IsExpression) {
    _collectCaptured(node.operand, localDecls, captured, onThisCaptured);
    return;
  }
  if (node is AsExpression) {
    _collectCaptured(node.operand, localDecls, captured, onThisCaptured);
    return;
  }
  if (node is EqualsCall) {
    _collectCaptured(node.left, localDecls, captured, onThisCaptured);
    _collectCaptured(node.right, localDecls, captured, onThisCaptured);
    return;
  }
  if (node is EqualsNull) {
    _collectCaptured(node.expression, localDecls, captured, onThisCaptured);
    return;
  }
  if (node is FunctionInvocation) {
    _collectCaptured(node.receiver, localDecls, captured, onThisCaptured);
    for (final a in node.arguments.positional) {
      _collectCaptured(a, localDecls, captured, onThisCaptured);
    }
    for (final a in node.arguments.named) {
      _collectCaptured(a.value, localDecls, captured, onThisCaptured);
    }
    return;
  }
  if (node is DynamicInvocation) {
    _collectCaptured(node.receiver, localDecls, captured, onThisCaptured);
    for (final a in node.arguments.positional) {
      _collectCaptured(a, localDecls, captured, onThisCaptured);
    }
    for (final a in node.arguments.named) {
      _collectCaptured(a.value, localDecls, captured, onThisCaptured);
    }
    return;
  }
  if (node is DynamicGet) {
    _collectCaptured(node.receiver, localDecls, captured, onThisCaptured);
    return;
  }
  if (node is DynamicSet) {
    _collectCaptured(node.receiver, localDecls, captured, onThisCaptured);
    _collectCaptured(node.value, localDecls, captured, onThisCaptured);
    return;
  }
  if (node is SuperMethodInvocation) {
    for (final a in node.arguments.positional) {
      _collectCaptured(a, localDecls, captured, onThisCaptured);
    }
    for (final a in node.arguments.named) {
      _collectCaptured(a.value, localDecls, captured, onThisCaptured);
    }
    return;
  }
  if (node is SuperPropertyGet) {
    // super.field 隐含 this 捕获
    onThisCaptured(true);
    return;
  }
  if (node is SuperPropertySet) {
    onThisCaptured(true);
    _collectCaptured(node.value, localDecls, captured, onThisCaptured);
    return;
  }
  if (node is StaticGet) return;
  if (node is StaticSet) {
    _collectCaptured(node.value, localDecls, captured, onThisCaptured);
    return;
  }
  if (node is InstanceGetterInvocation) {
    _collectCaptured(node.receiver, localDecls, captured, onThisCaptured);
    for (final a in node.arguments.positional) {
      _collectCaptured(a, localDecls, captured, onThisCaptured);
    }
    for (final a in node.arguments.named) {
      _collectCaptured(a.value, localDecls, captured, onThisCaptured);
    }
    return;
  }
  if (node is SetLiteral) {
    for (final e in node.expressions) {
      _collectCaptured(e, localDecls, captured, onThisCaptured);
    }
    return;
  }
  if (node is RecordLiteral) {
    for (final e in node.positional) {
      _collectCaptured(e, localDecls, captured, onThisCaptured);
    }
    for (final n in node.named) {
      _collectCaptured(n.value, localDecls, captured, onThisCaptured);
    }
    return;
  }
  if (node is RecordIndexGet) {
    _collectCaptured(node.receiver, localDecls, captured, onThisCaptured);
    return;
  }
  if (node is RecordNameGet) {
    _collectCaptured(node.receiver, localDecls, captured, onThisCaptured);
    return;
  }
  if (node is LabeledStatement) {
    _collectCaptured(node.body, localDecls, captured, onThisCaptured);
    return;
  }
  if (node is YieldStatement) {
    _collectCaptured(node.expression, localDecls, captured, onThisCaptured);
    return;
  }
  if (node is AwaitExpression) {
    _collectCaptured(node.operand, localDecls, captured, onThisCaptured);
    return;
  }
  // 叶子节点（IntLiteral, StringLiteral, BoolLiteral, NullLiteral 等）不需要处理
}

/// 闭包捕获变量信息
class _CapturedVar {
  final String name;       // 变量名（清理后的）
  final String typeStr;    // 类型字符串（Box 化时为 Box 类型）
  final bool isThis;       // 是否是 this 捕获
  final bool isBoxed;      // Bug 11: 是否为 Box 化（引用语义）变量

  _CapturedVar({
    required this.name,
    required this.typeStr,
    this.isThis = false,
    this.isBoxed = false,
  });

  @override
  bool operator ==(Object other) =>
      other is _CapturedVar && name == other.name;

  @override
  int get hashCode => name.hashCode;
}

/// 虚表条目：记录方法签名信息
class _VTableEntry {
  final String name;
  final String kind; // 'method', 'getter', 'setter', 'operator'
  final String staticFuncName;
  final String signature; // Function type signature for VTable field
  final Procedure? proc; // 原始 Procedure 引用（用于泛型 lambda wrapper 生成）
  final String? declaringClassName; // 首次声明该方法的类名（用于 this_ 参数类型）

  _VTableEntry({
    required this.name,
    required this.kind,
    required this.staticFuncName,
    required this.signature,
    this.proc,
    this.declaringClassName,
  });
}

// ============================================================================
// DartRestorer 主类
// ============================================================================

class DartRestorer extends _DartRestorerBase
    with
        _TypeUtils,
        _ConstantRestorer,
        _ExpressionRestorer,
        _StatementRestorer,
        _ClosureRestorer,
        _DeclarationRestorer,
        _EnumRestorer {
  String restore(Component component) {
    _buf.clear();
    _userClasses.clear();
    _mixinNames.clear();
    _enumNames.clear();
    _classHierarchy.clear();
    _classVTableEntries.clear();
    _classNodes.clear();
    _syntheticLoweredNames.clear();
    // 清除多文件状态
    _currentLib = null;
    _libInfos.clear();
    _classToLib.clear();
    _procToLib.clear();
    _fieldToLib.clear();
    _isMultiFileMode = false;

    for (final lib in component.libraries) {
      final uri = lib.importUri.toString();
      if (uri.startsWith('dart:') || uri.startsWith('package:')) continue;
      // 第一遍：收集所有用户自定义类信息
      _collectClassInfo(lib);
    }

    // 第二遍：预扫描 AST 收集方法级泛型调用的具体类型实参
    _methodTypeSpecializations.clear();
    for (final lib in component.libraries) {
      final uri = lib.importUri.toString();
      if (uri.startsWith('dart:') || uri.startsWith('package:')) continue;
      _collectMethodTypeSpecializations(lib);
    }

    // 引入运行时基础类（VPtr、Box 类型）
    _emitRuntimeImport();

    for (final lib in component.libraries) {
      final uri = lib.importUri.toString();
      if (uri.startsWith('dart:') || uri.startsWith('package:')) continue;
      _restoreLibrary(lib);
    }
    return _buf.toString();
  }

  /// 多文件还原：每个用户 Library 生成一个独立输出文件
  /// 返回 Map<输出文件名, 文件内容>
  Map<String, String> restoreMultiFile(Component component) {
    _isMultiFileMode = true;

    // 第一遍：构建 Library 信息
    _libInfos.clear();
    _classToLib.clear();
    _procToLib.clear();
    _fieldToLib.clear();
    _userClasses.clear();
    _mixinNames.clear();
    _enumNames.clear();
    _classHierarchy.clear();
    _classVTableEntries.clear();
    _classNodes.clear();
    _syntheticLoweredNames.clear();

    int libIndex = 0;
    final userLibraries = <Library>[];

    for (final lib in component.libraries) {
      final uri = lib.importUri.toString();
      if (uri.startsWith('dart:') || uri.startsWith('package:')) continue;

      // 从 URI 提取文件名作为基础
      final uriPath = Uri.parse(uri).path;
      final fileName = uriPath.split('/').last;
      final baseName = fileName.replaceAll('.dart', '');
      final outputFileName = '${baseName}_restored.dart';
      final prefix = 'lib_${libIndex++}';

      final libInfo = _LibraryInfo(lib, prefix, outputFileName);
      _libInfos[uri] = libInfo;
      userLibraries.add(lib);

      // 收集该库的所有定义
      _collectLibraryDefinitions(lib, libInfo);
    }

    // 第二遍：收集类信息和虚表（与单文件模式相同）
    for (final lib in userLibraries) {
      _collectClassInfo(lib);
    }

    // 第三遍：预扫描方法级泛型特化
    _methodTypeSpecializations.clear();
    for (final lib in userLibraries) {
      _collectMethodTypeSpecializations(lib);
    }

    // 第四遍：逐库生成代码
    final results = <String, String>{};

    for (final lib in userLibraries) {
      final uri = lib.importUri.toString();
      final libInfo = _libInfos[uri]!;

      _buf.clear();
      _pendingClosureDecls.clear();
      _currentLib = libInfo;

      // 生成 import 语句
      _emitMultiFileImports(lib, libInfo);

      // 还原该库的内容
      _restoreLibrary(lib);

      // 输出延迟的闭包定义
      for (final decl in _pendingClosureDecls) {
        _buf.write(decl);
      }
      _pendingClosureDecls.clear();

      results[libInfo.outputFileName] = _buf.toString();
    }

    // 清理状态
    _currentLib = null;
    _isMultiFileMode = false;

    return results;
  }

  /// 收集一个 Library 的所有定义（类、函数、字段等）
  void _collectLibraryDefinitions(Library lib, _LibraryInfo libInfo) {
    // 收集类
    for (final cls in lib.classes) {
      // 记录 Class 节点到 Library 的映射（精确匹配，避免同名类冲突）
      _classNodeToLib[cls] = libInfo;

      if (cls.isMixinDeclaration) {
        libInfo.mixinNames.add(cls.name);
        // 记录完全限定名映射
        libInfo.qualifiedToSimpleName[libInfo.qualifiedName(cls.name)] = cls.name;
      } else if (_isEnumClass(cls)) {
        libInfo.enumNames.add(cls.name);
        libInfo.qualifiedToSimpleName[libInfo.qualifiedName(cls.name)] = cls.name;
      } else {
        final isSynthetic = cls.name.contains('&');
        final className = isSynthetic ? _sanitizeSyntheticName(cls.name) : cls.name;
        libInfo.classNames.add(className);
        _classToLib[className] = libInfo;
        // 在 _classNodes 中存储 Class 节点（用于后续查找）
        _classNodes[className] = cls;
        // 记录完全限定名映射
        libInfo.qualifiedToSimpleName[libInfo.qualifiedName(className)] = className;
      }
    }

    // 收集顶层函数
    for (final proc in lib.procedures) {
      libInfo.procNames.add(proc.name.text);
      _procToLib[proc.name.text] = libInfo;
    }

    // 收集顶层字段
    for (final field in lib.fields) {
      libInfo.fieldNames.add(field.name.text);
      _fieldToLib[field.name.text] = libInfo;
    }
  }

  /// 生成多文件模式的 import 语句
  void _emitMultiFileImports(Library lib, _LibraryInfo currentLibInfo) {
    // 首先导入运行时
    _emitRuntimeImport();

    // 遍历当前库的 dependencies，找到对应的用户库
    for (final dep in lib.dependencies) {
      final depUri = dep.targetLibrary.importUri.toString();
      if (depUri.startsWith('dart:') || depUri.startsWith('package:')) continue;

      final depLibInfo = _libInfos[depUri];
      if (depLibInfo != null && depLibInfo != currentLibInfo) {
        // 导入其他用户库，使用 prefix
        _buf.write("import '${depLibInfo.outputFileName}' as ${depLibInfo.prefix};\n");
      }
    }

    _buf.write('\n');
  }

  // ---- 第一遍：收集类信息 ----

  void _collectClassInfo(Library lib) {
    // 第一遍：收集所有类的基本信息（名称、继承关系），但不收集虚表
    final userClassEntries = <(String className, Class cls)>[];
    
    for (final cls in lib.classes) {
      // mixin 声明：记录名称（不做 lowering，方法通过合成中间类处理）
      if (cls.isMixinDeclaration) {
        _mixinNames.add(cls.name);
        _classNodes[cls.name] = cls;
        continue;
      }

      // enum: 记录名称和节点，检查是否有自定义 toString
      if (_isEnumClass(cls)) {
        _enumNames.add(cls.name);
        _classNodes[cls.name] = cls;
        final hasCustomToString = cls.procedures.any((p) =>
            p.name.text == 'toString' && !p.isAbstract && p.function.body != null);
        if (hasCustomToString) {
          _enumsWithCustomToString.add(cls.name);
        }
        continue;
      }

      // 合成 mixin 中间类（名字包含 &）：作为普通用户类收集
      final isSynthetic = cls.name.contains('&');
      final className = isSynthetic
          ? _sanitizeSyntheticName(cls.name)
          : cls.name;

      _userClasses.add(className);
      if (isSynthetic) {
        _syntheticLoweredNames.add(className);
      }
      _classNodes[className] = cls;

      // 记录继承关系
      if (cls.supertype != null) {
        final superName = cls.supertype!.classNode.name;
        if (superName.contains('&')) {
          final parentLowered = _sanitizeSyntheticName(superName);
          _classHierarchy[className] = parentLowered;
        } else if (superName != 'Object') {
          _classHierarchy[className] = superName;
        }
      }

      userClassEntries.add((className, cls));
    }

    // 第二遍：按拓扑排序收集虚表（确保父类在子类之前处理）
    final sorted = _topologicalSort(userClassEntries);
    for (final (className, cls) in sorted) {
      _collectVTableEntries(cls, overrideName: className);
    }
  }

  /// 按继承关系拓扑排序：父类在子类之前
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
      // 先处理父类
      final parent = _classHierarchy[className];
      if (parent != null && nameToEntry.containsKey(parent)) {
        visit(parent);
      }
      final entry = nameToEntry[className];
      if (entry != null) {
        sorted.add(entry);
      }
    }

    for (final entry in entries) {
      visit(entry.$1);
    }
    return sorted;
  }

  // ---- 第二遍：预扫描方法级泛型特化 ----

  /// 遍历 Library 中所有 AST 节点，收集带方法级泛型参数的 InstanceInvocation，
  /// 记录每个类每个方法的所有具体类型实参后缀到 _methodTypeSpecializations。
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
        for (final init in ctor.initializers) {
          if (init is FieldInitializer) {
            _scanNodeForMethodTypeSpecs(init.value);
          }
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

  /// 递归扫描 AST 节点，查找带方法级泛型的 InstanceInvocation 并记录特化信息。
  void _scanNodeForMethodTypeSpecs(TreeNode node) {
    if (node is InstanceInvocation) {
      _checkAndRecordMethodTypeSpec(node);
      // 继续扫描子节点
      _scanNodeForMethodTypeSpecs(node.receiver);
      for (final a in node.arguments.positional) {
        _scanNodeForMethodTypeSpecs(a);
      }
      for (final a in node.arguments.named) {
        _scanNodeForMethodTypeSpecs(a.value);
      }
      return;
    }
    // 通用子节点遍历
    _scanChildrenForMethodTypeSpecs(node);
  }

  /// 检查一个 InstanceInvocation 是否是带方法级泛型的调用，
  /// 如果是，将其具体类型后缀记录到 _methodTypeSpecializations。
  void _checkAndRecordMethodTypeSpec(InstanceInvocation node) {
    final target = node.interfaceTarget;
    final methodTypeParams = target.function.typeParameters;
    if (methodTypeParams.isEmpty) return;

    // 确定 receiver 的类名
    final enclosingClass = target.enclosingClass;
    if (enclosingClass == null) return;

    var className = enclosingClass.name;
    if (className.contains('&')) {
      className = _sanitizeSyntheticName(className);
    }
    // 只处理用户自定义类
    if (!_userClasses.contains(className)) return;
    // 合成中间类 → 找到实际用户类
    if (_syntheticLoweredNames.contains(className)) {
      className = _findUserClassForSynthetic(className);
    }

    // 去重方法级泛型：与类同名的被去除
    final classTpNames = enclosingClass.typeParameters.map((tp) => tp.name).toSet();
    final dedupedMethodTps = methodTypeParams
        .where((tp) => !classTpNames.contains(tp.name))
        .toList();
    if (dedupedMethodTps.isEmpty) return;

    // 从 arguments.types 中提取方法级泛型的实际类型实参
    // 在 Kernel AST 中，InstanceInvocation.arguments.types 仅包含方法的类型实参
    // （类的类型参数已通过 receiver 的静态类型携带）
    final methodTypeArgs = node.arguments.types;
    if (methodTypeArgs.isEmpty) return;

    // 关键过滤：只有当所有方法级类型实参都是**具体类型**（非 TypeParameterType）时
    // 才生成特化条目。如果任意类型实参仍然是类型参数引用（如递归调用中的 R），
    // 说明调用在泛型上下文中，无法在 vptr 中以具体类型注册。
    final hasAbstractTypeArg = methodTypeArgs.any((ta) => _containsTypeParameter(ta));
    if (hasAbstractTypeArg) return;

    // 生成特化后缀：用所有方法级类型实参的名称连接
    final methodName = target.name.text;
    final typeSuffix = methodTypeArgs.map((ta) => _typeToSpecSuffix(ta)).join('_');
    if (typeSuffix.isEmpty) return;

    // 同时记录原始类型字符串（用于生成正确的调用类型实参）
    final typeArgStrs = methodTypeArgs.map((ta) => _typeToSpecRestoreStr(ta)).toList();

    // 记录到 _methodTypeSpecializations
    _methodTypeSpecializations
        .putIfAbsent(className, () => {})
        .putIfAbsent(methodName, () => {})
        .add(MethodSpecEntry(typeSuffix, typeArgStrs));
  }

  /// 通用子节点遍历（用于预扫描方法级泛型特化）
  /// 使用 _forEachChildNode 避免重复的遍历逻辑
  void _scanChildrenForMethodTypeSpecs(TreeNode node) {
    _forEachChildNode(node, _scanNodeForMethodTypeSpecs);
  }

  void _collectVTableEntries(Class cls, {String? overrideName}) {
    final className = overrideName ?? cls.name;

    // 多文件支持：使用完全限定名作为键，避免同名类冲突
    final vtableKey = _isMultiFileMode
        ? _classNodeToLib[cls]?.qualifiedName(className) ?? className
        : className;

    final entries = <_VTableEntry>[];

    // 先继承父类的虚表条目
    // 多文件支持：使用 cls.supertype 获取正确的父类，避免同名类冲突
    if (_isMultiFileMode && cls.supertype != null) {
      final parentClass = cls.supertype!.classNode;
      final parentName = _loweredClassName(parentClass.name);
      if (_isUserClass(parentName)) {
        final parentEntries = _getVTableEntries(parentClass, parentName);
        entries.addAll(parentEntries);
      }
    } else {
      final parentName = _classHierarchy[className];
      if (parentName != null) {
        final parentEntries = _getVTableEntriesByName(parentName);
        if (parentEntries != null) {
          entries.addAll(parentEntries);
        }
      }
    }

    // 收集 implements 接口中的方法（如果本类或父类尚未声明）
    for (final impl in cls.implementedTypes) {
      final ifaceName = impl.classNode.name;
      final ifaceEntries = _getVTableEntriesByName(ifaceName);
      if (ifaceEntries != null) {
        for (final ifaceEntry in ifaceEntries) {
          final alreadyExists = entries.any(
              (e) => e.name == ifaceEntry.name && e.kind == ifaceEntry.kind);
          if (!alreadyExists) {
            entries.add(_VTableEntry(
              name: ifaceEntry.name,
              kind: ifaceEntry.kind,
              staticFuncName: ifaceEntry.staticFuncName,
              signature: ifaceEntry.signature,
              declaringClassName: ifaceEntry.declaringClassName,
            ));
          }
        }
      }
    }

    // 收集本类自身的方法
    for (final proc in cls.procedures) {
      if (proc.isStatic) continue;
      if (proc.isFactory) continue;
      if (proc.name.text.startsWith('_')) continue;

      final methodName = proc.name.text;
      final entry = _buildVTableEntry(cls, proc, methodName, className);

      final existingIdx = entries.indexWhere((e) => e.name == methodName && e.kind == entry.kind);
      if (existingIdx >= 0) {
        // 重载：保留首次声明类的 declaringClassName
        final existingDeclaringClass = entries[existingIdx].declaringClassName ?? className;
        entries[existingIdx] = _VTableEntry(
          name: entry.name,
          kind: entry.kind,
          staticFuncName: entry.staticFuncName,
          signature: entry.signature,
          proc: entry.proc,
          declaringClassName: existingDeclaringClass,
        );
      } else {
        // 新方法：声明类就是当前类
        entries.add(_VTableEntry(
          name: entry.name,
          kind: entry.kind,
          staticFuncName: entry.staticFuncName,
          signature: entry.signature,
          proc: entry.proc,
          declaringClassName: className,
        ));
      }
    }

    _classVTableEntries[vtableKey] = entries;
  }

  /// 从 Procedure 构建 VTable 条目
  /// [loweredName] 是规范化后的类名（合成类名去掉 & 等）
  _VTableEntry _buildVTableEntry(Class cls, Procedure proc, String methodName, [String? loweredName]) {
    final className = loweredName ?? cls.name;
    String kind;
    String staticFuncName;
    String signature;

    if (proc.isGetter) {
      kind = 'getter';
      staticFuncName = _staticGetterName(className, methodName);
      final retType = _restoreTypeForSignature(proc.function.returnType);
      signature = '$retType Function(${className}Value this_)';
    } else if (proc.isSetter) {
      kind = 'setter';
      staticFuncName = _staticSetterName(className, methodName);
      final paramType = proc.function.positionalParameters.isNotEmpty
          ? _restoreTypeForSignature(proc.function.positionalParameters.first.type)
          : 'dynamic';
      signature = 'void Function(${className}Value this_, $paramType value)';
    } else if (_isOperatorName(methodName)) {
      kind = 'operator';
      staticFuncName = _staticMethodName(className, methodName);
      final retType = _restoreTypeForSignature(proc.function.returnType);
      final paramTypes = proc.function.positionalParameters
          .map((p) => _restoreTypeForSignature(p.type))
          .join(', ');
      final paramPart = paramTypes.isEmpty
          ? '${className}Value this_'
          : '${className}Value this_, $paramTypes';
      signature = '$retType Function($paramPart)';
    } else {
      kind = 'method';
      staticFuncName = _staticMethodName(className, methodName);
      final retType = _restoreTypeForSignature(proc.function.returnType);
      final paramTypes = <String>[];
      for (final p in proc.function.positionalParameters) {
        paramTypes.add(_restoreTypeForSignature(p.type));
      }
      for (final p in proc.function.namedParameters) {
        paramTypes.add(_restoreTypeForSignature(p.type));
      }
      final paramPart = paramTypes.isEmpty
          ? '${className}Value this_'
          : '${className}Value this_, ${paramTypes.join(', ')}';
      signature = '$retType Function($paramPart)';
    }

    return _VTableEntry(
      name: methodName,
      kind: kind,
      staticFuncName: staticFuncName,
      signature: signature,
      proc: proc,
    );
  }

  /// 简化版类型还原（用于签名生成，在第一遍收集时使用）
  /// 注意：此方法已移至 _DartRestorerBase 基类，供所有 mixin 共享访问

  // ---- Library ----

  void _restoreLibrary(Library lib) {
    _pendingClosureDecls.clear();

    for (final td in lib.typedefs) _restoreTypedef(td);
    for (final cls in lib.classes) {
      if (cls.isMixinDeclaration) {
        // mixin 声明：不再输出实体（方法通过合成中间类 lowering）
        _restoreMixin(cls);
      } else {
        // 普通类和合成 mixin 中间类都走 _restoreClass
        _restoreClass(cls);
      }
    }
    for (final proc in lib.procedures) {
      _pushClosureContext(proc.name.text);
      _restoreProcedure(proc);
      _popClosureContext();
    }
    for (final field in lib.fields) _restoreField(field, isTopLevel: true);

    // 输出所有延迟的闭包类和静态函数定义
    for (final decl in _pendingClosureDecls) {
      _buf.write(decl);
    }
    _pendingClosureDecls.clear();
  }

  /// 输出运行时基础类的 import 语句
  /// VPtr 基类和 Box 类型已抽取到 runtime_classes.dart
  void _emitRuntimeImport() {
    _buf.write("import 'package:dart2cpp/platform/dart/runtime_classes.dart';\n\n");
  }

}
