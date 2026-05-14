import 'package:kernel/kernel.dart';
import 'package:kernel/ast.dart';

part 'type_utils.dart';
part 'constant_restorer.dart';
part 'expression_restorer.dart';
part 'statement_restorer.dart';
part 'declaration_restorer.dart';

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
// 共享状态基类
// ============================================================================

abstract class _DartRestorerBase {
  StringBuffer _buf = StringBuffer();
  int _indent = 0;
  int _varCounter = 0;
  final Map<String, String> _cleanedNames = {};

  String get _pad => '  ' * _indent;

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

  /// 是否在实例方法体内（用于 this → this_ 转换）
  bool _insideMethodBody = false;

  /// this 的替换名称（在方法体内为 'this_'，在构造函数体内为 'obj'）
  String _thisReplacementName = 'this_';

  // ---- 闭包 Lowering 状态 ----

  /// 全局闭包计数器（用于生成唯一名称）
  int _closureCounter = 0;

  /// 当前上下文名称栈（用于生成闭包命名，如 'foo', 'MyClass_doSomething'）
  final List<String> _closureContextStack = [];

  /// 待输出的闭包类和静态函数定义（延迟到顶层输出）
  final List<String> _pendingClosureDecls = [];

  /// 待输出的顶层声明：如类级共享的 vtable 常量
  /// `final Map<String, dynamic> _XX_vtable = <String, dynamic>{ ... };`
  /// 这些声明会在所有类/函数输出之后、_pendingClosureDecls 之前写到 _buf。
  final List<String> _pendingTopLevelDecls = [];

  /// 已经登记过共享 vtable 常量的类名集合，避免同类多构造函数（如 .named）重复输出。
  final Set<String> _emittedSharedVTableClasses = {};

  /// 方法级泛型特化收集：className → { methodName → { 特化条目 } }
  /// 预扫描 AST 收集所有调用处的方法级类型实参，用于在构造函数中按特化 key 注册。
  /// 每个特化条目包含：vptrSuffix（用于 vptr key）和 typeArgStrs（用于生成调用类型实参）。
  /// 例如 Either.fold<String> → { 'Either': { 'fold': { MethodSpecEntry('String', ['String']) } } }
  final Map<String, Map<String, Set<MethodSpecEntry>>> _methodTypeSpecializations = {};

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

  /// 将 DartType 转为还原后的类型字符串（用于生成调用类型实参）。
  /// 与 _typeToSpecSuffix 不同，此方法保留完整的泛型语法。
  /// 例如：String → 'String', int → 'int', List<int> → 'List<int>'
  String _typeToSpecRestoreStr(DartType type) {
    if (type is InterfaceType) {
      final name = type.classNode.name;
      if (type.typeArguments.isEmpty) return name;
      final args = type.typeArguments.map((t) => _typeToSpecRestoreStr(t)).join(', ');
      return '$name<$args>';
    }
    if (type is TypeParameterType) {
      return type.parameter.name ?? 'T';
    }
    if (type is DynamicType) return 'dynamic';
    if (type is VoidType) return 'void';
    if (type is FunctionType) return 'Function';
    return 'dynamic';
  }

  /// 将 DartType 转为特化后缀字符串（用于 vptr key）。
  /// 例如：String → 'String', int → 'int', List<int> → 'List_int'
  String _typeToSpecSuffix(DartType type) {
    if (type is InterfaceType) {
      final name = type.classNode.name;
      if (type.typeArguments.isEmpty) return name;
      final args = type.typeArguments.map((t) => _typeToSpecSuffix(t)).join('_');
      return '${name}_$args';
    }
    if (type is TypeParameterType) {
      return type.parameter.name ?? 'T';
    }
    if (type is DynamicType) return 'dynamic';
    if (type is VoidType) return 'void';
    if (type is FunctionType) return 'Function';
    return 'dynamic';
  }

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

  void _visitChildrenForLocalDecl(TreeNode node, Set<VariableDeclaration> out) {
    if (node is Block) {
      for (final s in node.statements) _collectShallowDecls(s, out);
      return;
    }
    if (node is ExpressionStatement) {
      _collectShallowDecls(node.expression, out);
      return;
    }
    if (node is ReturnStatement) {
      if (node.expression != null) _collectShallowDecls(node.expression!, out);
      return;
    }
    if (node is IfStatement) {
      _collectShallowDecls(node.condition, out);
      _collectShallowDecls(node.then, out);
      if (node.otherwise != null) _collectShallowDecls(node.otherwise!, out);
      return;
    }
    if (node is ForStatement) {
      for (final v in node.variables) _collectShallowDecls(v, out);
      if (node.condition != null) _collectShallowDecls(node.condition!, out);
      for (final u in node.updates) _collectShallowDecls(u, out);
      _collectShallowDecls(node.body, out);
      return;
    }
    if (node is ForInStatement) {
      _collectShallowDecls(node.variable, out);
      _collectShallowDecls(node.iterable, out);
      _collectShallowDecls(node.body, out);
      return;
    }
    if (node is WhileStatement) {
      _collectShallowDecls(node.condition, out);
      _collectShallowDecls(node.body, out);
      return;
    }
    if (node is DoStatement) {
      _collectShallowDecls(node.body, out);
      _collectShallowDecls(node.condition, out);
      return;
    }
    if (node is TryCatch) {
      _collectShallowDecls(node.body, out);
      for (final c in node.catches) {
        if (c.exception != null) out.add(c.exception!);
        if (c.stackTrace != null) out.add(c.stackTrace!);
        _collectShallowDecls(c.body, out);
      }
      return;
    }
    if (node is TryFinally) {
      _collectShallowDecls(node.body, out);
      _collectShallowDecls(node.finalizer, out);
      return;
    }
    if (node is SwitchStatement) {
      _collectShallowDecls(node.expression, out);
      for (final c in node.cases) _collectShallowDecls(c.body, out);
      return;
    }
    if (node is LabeledStatement) {
      _collectShallowDecls(node.body, out);
      return;
    }
    if (node is YieldStatement) {
      _collectShallowDecls(node.expression, out);
      return;
    }
    if (node is AssertStatement) {
      _collectShallowDecls(node.condition, out);
      if (node.message != null) _collectShallowDecls(node.message!, out);
      return;
    }
    if (node is Let) {
      out.add(node.variable);
      _collectShallowDecls(node.variable, out);
      _collectShallowDecls(node.body, out);
      return;
    }
    if (node is BlockExpression) {
      _collectShallowDecls(node.body, out);
      _collectShallowDecls(node.value, out);
      return;
    }
    // 表达式节点常规分派：继续走子节点
    if (node is InstanceInvocation) {
      _collectShallowDecls(node.receiver, out);
      for (final a in node.arguments.positional) _collectShallowDecls(a, out);
      for (final a in node.arguments.named) _collectShallowDecls(a.value, out);
      return;
    }
    if (node is StaticInvocation) {
      for (final a in node.arguments.positional) _collectShallowDecls(a, out);
      for (final a in node.arguments.named) _collectShallowDecls(a.value, out);
      return;
    }
    if (node is ConstructorInvocation) {
      for (final a in node.arguments.positional) _collectShallowDecls(a, out);
      for (final a in node.arguments.named) _collectShallowDecls(a.value, out);
      return;
    }
    if (node is InstanceGet) {
      _collectShallowDecls(node.receiver, out);
      return;
    }
    if (node is InstanceSet) {
      _collectShallowDecls(node.receiver, out);
      _collectShallowDecls(node.value, out);
      return;
    }
    if (node is VariableSet) {
      _collectShallowDecls(node.value, out);
      return;
    }
    if (node is ConditionalExpression) {
      _collectShallowDecls(node.condition, out);
      _collectShallowDecls(node.then, out);
      _collectShallowDecls(node.otherwise, out);
      return;
    }
    if (node is LogicalExpression) {
      _collectShallowDecls(node.left, out);
      _collectShallowDecls(node.right, out);
      return;
    }
    if (node is Not) {
      _collectShallowDecls(node.operand, out);
      return;
    }
    if (node is StringConcatenation) {
      for (final e in node.expressions) _collectShallowDecls(e, out);
      return;
    }
    if (node is AsExpression) {
      _collectShallowDecls(node.operand, out);
      return;
    }
    if (node is IsExpression) {
      _collectShallowDecls(node.operand, out);
      return;
    }
    if (node is NullCheck) {
      _collectShallowDecls(node.operand, out);
      return;
    }
    if (node is AwaitExpression) {
      _collectShallowDecls(node.operand, out);
      return;
    }
    if (node is ListLiteral) {
      for (final e in node.expressions) _collectShallowDecls(e, out);
      return;
    }
    if (node is SetLiteral) {
      for (final e in node.expressions) _collectShallowDecls(e, out);
      return;
    }
    if (node is MapLiteral) {
      for (final e in node.entries) {
        _collectShallowDecls(e.key, out);
        _collectShallowDecls(e.value, out);
      }
      return;
    }
    if (node is Throw) {
      _collectShallowDecls(node.expression, out);
      return;
    }
    if (node is EqualsCall) {
      _collectShallowDecls(node.left, out);
      _collectShallowDecls(node.right, out);
      return;
    }
    if (node is EqualsNull) {
      _collectShallowDecls(node.expression, out);
      return;
    }
    if (node is FunctionInvocation) {
      _collectShallowDecls(node.receiver, out);
      for (final a in node.arguments.positional) _collectShallowDecls(a, out);
      for (final a in node.arguments.named) _collectShallowDecls(a.value, out);
      return;
    }
    if (node is DynamicInvocation) {
      _collectShallowDecls(node.receiver, out);
      for (final a in node.arguments.positional) _collectShallowDecls(a, out);
      for (final a in node.arguments.named) _collectShallowDecls(a.value, out);
      return;
    }
    if (node is LocalFunctionInvocation) {
      for (final a in node.arguments.positional) _collectShallowDecls(a, out);
      for (final a in node.arguments.named) _collectShallowDecls(a.value, out);
      return;
    }
    // 其他节点默认跳过（字面量、VariableGet、ThisExpression 等无需继续）
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
    _visitChildrenForFuncExpr(node, out);
  }

  void _visitChildrenForFuncExpr(TreeNode node, List<FunctionExpression> out) {
    if (node is Block) {
      for (final s in node.statements) _collectAllFunctionExpressions(s, out);
      return;
    }
    if (node is ExpressionStatement) {
      _collectAllFunctionExpressions(node.expression, out);
      return;
    }
    if (node is ReturnStatement) {
      if (node.expression != null) _collectAllFunctionExpressions(node.expression!, out);
      return;
    }
    if (node is IfStatement) {
      _collectAllFunctionExpressions(node.condition, out);
      _collectAllFunctionExpressions(node.then, out);
      if (node.otherwise != null) _collectAllFunctionExpressions(node.otherwise!, out);
      return;
    }
    if (node is ForStatement) {
      for (final v in node.variables) _collectAllFunctionExpressions(v, out);
      if (node.condition != null) _collectAllFunctionExpressions(node.condition!, out);
      for (final u in node.updates) _collectAllFunctionExpressions(u, out);
      _collectAllFunctionExpressions(node.body, out);
      return;
    }
    if (node is ForInStatement) {
      _collectAllFunctionExpressions(node.variable, out);
      _collectAllFunctionExpressions(node.iterable, out);
      _collectAllFunctionExpressions(node.body, out);
      return;
    }
    if (node is WhileStatement) {
      _collectAllFunctionExpressions(node.condition, out);
      _collectAllFunctionExpressions(node.body, out);
      return;
    }
    if (node is DoStatement) {
      _collectAllFunctionExpressions(node.body, out);
      _collectAllFunctionExpressions(node.condition, out);
      return;
    }
    if (node is TryCatch) {
      _collectAllFunctionExpressions(node.body, out);
      for (final c in node.catches) _collectAllFunctionExpressions(c.body, out);
      return;
    }
    if (node is TryFinally) {
      _collectAllFunctionExpressions(node.body, out);
      _collectAllFunctionExpressions(node.finalizer, out);
      return;
    }
    if (node is SwitchStatement) {
      _collectAllFunctionExpressions(node.expression, out);
      for (final c in node.cases) _collectAllFunctionExpressions(c.body, out);
      return;
    }
    if (node is LabeledStatement) {
      _collectAllFunctionExpressions(node.body, out);
      return;
    }
    if (node is YieldStatement) {
      _collectAllFunctionExpressions(node.expression, out);
      return;
    }
    if (node is AssertStatement) {
      _collectAllFunctionExpressions(node.condition, out);
      if (node.message != null) _collectAllFunctionExpressions(node.message!, out);
      return;
    }
    if (node is VariableDeclaration) {
      if (node.initializer != null) _collectAllFunctionExpressions(node.initializer!, out);
      return;
    }
    if (node is Let) {
      if (node.variable.initializer != null) {
        _collectAllFunctionExpressions(node.variable.initializer!, out);
      }
      _collectAllFunctionExpressions(node.body, out);
      return;
    }
    if (node is BlockExpression) {
      _collectAllFunctionExpressions(node.body, out);
      _collectAllFunctionExpressions(node.value, out);
      return;
    }
    if (node is InstanceInvocation) {
      _collectAllFunctionExpressions(node.receiver, out);
      for (final a in node.arguments.positional) _collectAllFunctionExpressions(a, out);
      for (final a in node.arguments.named) _collectAllFunctionExpressions(a.value, out);
      return;
    }
    if (node is StaticInvocation) {
      for (final a in node.arguments.positional) _collectAllFunctionExpressions(a, out);
      for (final a in node.arguments.named) _collectAllFunctionExpressions(a.value, out);
      return;
    }
    if (node is ConstructorInvocation) {
      for (final a in node.arguments.positional) _collectAllFunctionExpressions(a, out);
      for (final a in node.arguments.named) _collectAllFunctionExpressions(a.value, out);
      return;
    }
    if (node is InstanceGet) {
      _collectAllFunctionExpressions(node.receiver, out);
      return;
    }
    if (node is InstanceSet) {
      _collectAllFunctionExpressions(node.receiver, out);
      _collectAllFunctionExpressions(node.value, out);
      return;
    }
    if (node is VariableSet) {
      _collectAllFunctionExpressions(node.value, out);
      return;
    }
    if (node is ConditionalExpression) {
      _collectAllFunctionExpressions(node.condition, out);
      _collectAllFunctionExpressions(node.then, out);
      _collectAllFunctionExpressions(node.otherwise, out);
      return;
    }
    if (node is LogicalExpression) {
      _collectAllFunctionExpressions(node.left, out);
      _collectAllFunctionExpressions(node.right, out);
      return;
    }
    if (node is Not) {
      _collectAllFunctionExpressions(node.operand, out);
      return;
    }
    if (node is StringConcatenation) {
      for (final e in node.expressions) _collectAllFunctionExpressions(e, out);
      return;
    }
    if (node is AsExpression) {
      _collectAllFunctionExpressions(node.operand, out);
      return;
    }
    if (node is IsExpression) {
      _collectAllFunctionExpressions(node.operand, out);
      return;
    }
    if (node is NullCheck) {
      _collectAllFunctionExpressions(node.operand, out);
      return;
    }
    if (node is AwaitExpression) {
      _collectAllFunctionExpressions(node.operand, out);
      return;
    }
    if (node is ListLiteral) {
      for (final e in node.expressions) _collectAllFunctionExpressions(e, out);
      return;
    }
    if (node is SetLiteral) {
      for (final e in node.expressions) _collectAllFunctionExpressions(e, out);
      return;
    }
    if (node is MapLiteral) {
      for (final e in node.entries) {
        _collectAllFunctionExpressions(e.key, out);
        _collectAllFunctionExpressions(e.value, out);
      }
      return;
    }
    if (node is Throw) {
      _collectAllFunctionExpressions(node.expression, out);
      return;
    }
    if (node is EqualsCall) {
      _collectAllFunctionExpressions(node.left, out);
      _collectAllFunctionExpressions(node.right, out);
      return;
    }
    if (node is EqualsNull) {
      _collectAllFunctionExpressions(node.expression, out);
      return;
    }
    if (node is FunctionInvocation) {
      _collectAllFunctionExpressions(node.receiver, out);
      for (final a in node.arguments.positional) _collectAllFunctionExpressions(a, out);
      for (final a in node.arguments.named) _collectAllFunctionExpressions(a.value, out);
      return;
    }
    if (node is DynamicInvocation) {
      _collectAllFunctionExpressions(node.receiver, out);
      for (final a in node.arguments.positional) _collectAllFunctionExpressions(a, out);
      for (final a in node.arguments.named) _collectAllFunctionExpressions(a.value, out);
      return;
    }
    if (node is LocalFunctionInvocation) {
      for (final a in node.arguments.positional) _collectAllFunctionExpressions(a, out);
      for (final a in node.arguments.named) _collectAllFunctionExpressions(a.value, out);
      return;
    }
  }

  /// 清理闭包上下文名称，确保是合法的 Dart 标识符
  /// 扩展方法名如 "StringExtensions|get#capitalize" 需要转换为 "StringExtensions_get_capitalize"
  String _sanitizeClosureContextName(String name) {
    if (name.contains('|')) {
      return _sanitizeExtensionMethodName(name);
    }
    // 替换所有非法字符为下划线
    return name.replaceAll(RegExp(r'[^a-zA-Z0-9_]'), '_');
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
      final mappedName = _isUserClass(name) ? '${name}Value' : name;
      if (type.typeArguments.isEmpty) return '$mappedName$suffix';
      final args = type.typeArguments.map((t) => _restoreTypeForSignature(t)).join(', ');
      return '$mappedName<$args>$suffix';
    }
    if (type is FunctionType) {
      final ret = _restoreTypeForSignature(type.returnType);
      final params = <String>[];
      for (final p in type.positionalParameters) {
        params.add(_restoreTypeForSignature(p));
      }
      return '$ret Function(${params.join(', ')})$suffix';
    }
    if (type is TypeParameterType) {
      // 在 vptr 签名中，类型参数可能在调用处不可用（如 main 函数中调用泛型类的方法）
      // 检查类型参数是否来自类的声明（而非方法的局部类型参数）
      // 如果在方法体内（_insideMethodBody），类型参数可能可用；否则替换为 dynamic
      if (!_insideMethodBody) {
        return 'dynamic';
      }
      return '${type.parameter.name ?? 'T'}$suffix';
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

  /// 判断是否是运算符名称（基类版本，供 lowering 辅助方法使用）
  bool _isOperatorNameBase(String name) {
    return const {'+', '-', '*', '/', '%', '~/', '>', '<', '>=', '<=', '&', '|', '^', '<<', '>>', '==', '[]', '[]=', '~', 'unary-'}.contains(name);
  }

  /// 生成方法的静态函数名
  String _staticMethodName(String className, String methodName) {
    if (_isOperatorNameBase(methodName)) {
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

  // 跨模块方法的抽象声明（打破 mixin 循环依赖）
  String _restoreExpr(Expression expr);
  void _restoreStmt(Statement stmt);
  void _writeTypeParams(List<TypeParameter> params);
  void _writeParams(FunctionNode func, {Procedure? proc});
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
        _DeclarationRestorer {
  String restore(Component component) {
    _buf.clear();
    _userClasses.clear();
    _mixinNames.clear();
    _enumNames.clear();
    _classHierarchy.clear();
    _classVTableEntries.clear();
    _classNodes.clear();
    _syntheticLoweredNames.clear();

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

    // 输出 VPtr 基类：所有无基类的 Value 类都继承自它
    _emitVPtrBaseClass();

    // 输出 Box 类型定义（用于闭包引用语义，Bug 11）
    _emitBoxClasses();

    for (final lib in component.libraries) {
      final uri = lib.importUri.toString();
      if (uri.startsWith('dart:') || uri.startsWith('package:')) continue;
      _restoreLibrary(lib);
    }
    return _buf.toString();
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
  void _scanChildrenForMethodTypeSpecs(TreeNode node) {
    if (node is Block) {
      for (final s in node.statements) _scanNodeForMethodTypeSpecs(s);
      return;
    }
    if (node is ExpressionStatement) {
      _scanNodeForMethodTypeSpecs(node.expression);
      return;
    }
    if (node is ReturnStatement) {
      if (node.expression != null) _scanNodeForMethodTypeSpecs(node.expression!);
      return;
    }
    if (node is VariableDeclaration) {
      if (node.initializer != null) _scanNodeForMethodTypeSpecs(node.initializer!);
      return;
    }
    if (node is VariableSet) {
      _scanNodeForMethodTypeSpecs(node.value);
      return;
    }
    if (node is VariableGet) return;
    if (node is IfStatement) {
      _scanNodeForMethodTypeSpecs(node.condition);
      _scanNodeForMethodTypeSpecs(node.then);
      if (node.otherwise != null) _scanNodeForMethodTypeSpecs(node.otherwise!);
      return;
    }
    if (node is ForStatement) {
      for (final v in node.variables) _scanNodeForMethodTypeSpecs(v);
      if (node.condition != null) _scanNodeForMethodTypeSpecs(node.condition!);
      for (final u in node.updates) _scanNodeForMethodTypeSpecs(u);
      _scanNodeForMethodTypeSpecs(node.body);
      return;
    }
    if (node is ForInStatement) {
      _scanNodeForMethodTypeSpecs(node.variable);
      _scanNodeForMethodTypeSpecs(node.iterable);
      _scanNodeForMethodTypeSpecs(node.body);
      return;
    }
    if (node is WhileStatement) {
      _scanNodeForMethodTypeSpecs(node.condition);
      _scanNodeForMethodTypeSpecs(node.body);
      return;
    }
    if (node is DoStatement) {
      _scanNodeForMethodTypeSpecs(node.body);
      _scanNodeForMethodTypeSpecs(node.condition);
      return;
    }
    if (node is TryCatch) {
      _scanNodeForMethodTypeSpecs(node.body);
      for (final c in node.catches) {
        _scanNodeForMethodTypeSpecs(c.body);
      }
      return;
    }
    if (node is TryFinally) {
      _scanNodeForMethodTypeSpecs(node.body);
      _scanNodeForMethodTypeSpecs(node.finalizer);
      return;
    }
    if (node is SwitchStatement) {
      _scanNodeForMethodTypeSpecs(node.expression);
      for (final c in node.cases) {
        _scanNodeForMethodTypeSpecs(c.body);
      }
      return;
    }
    if (node is Let) {
      _scanNodeForMethodTypeSpecs(node.variable);
      _scanNodeForMethodTypeSpecs(node.body);
      return;
    }
    if (node is BlockExpression) {
      _scanNodeForMethodTypeSpecs(node.body);
      _scanNodeForMethodTypeSpecs(node.value);
      return;
    }
    if (node is StaticInvocation) {
      for (final a in node.arguments.positional) _scanNodeForMethodTypeSpecs(a);
      for (final a in node.arguments.named) _scanNodeForMethodTypeSpecs(a.value);
      return;
    }
    if (node is ConstructorInvocation) {
      for (final a in node.arguments.positional) _scanNodeForMethodTypeSpecs(a);
      for (final a in node.arguments.named) _scanNodeForMethodTypeSpecs(a.value);
      return;
    }
    if (node is InstanceGet) {
      _scanNodeForMethodTypeSpecs(node.receiver);
      return;
    }
    if (node is InstanceSet) {
      _scanNodeForMethodTypeSpecs(node.receiver);
      _scanNodeForMethodTypeSpecs(node.value);
      return;
    }
    if (node is ConditionalExpression) {
      _scanNodeForMethodTypeSpecs(node.condition);
      _scanNodeForMethodTypeSpecs(node.then);
      _scanNodeForMethodTypeSpecs(node.otherwise);
      return;
    }
    if (node is LogicalExpression) {
      _scanNodeForMethodTypeSpecs(node.left);
      _scanNodeForMethodTypeSpecs(node.right);
      return;
    }
    if (node is Not) {
      _scanNodeForMethodTypeSpecs(node.operand);
      return;
    }
    if (node is StringConcatenation) {
      for (final e in node.expressions) _scanNodeForMethodTypeSpecs(e);
      return;
    }
    if (node is AsExpression) {
      _scanNodeForMethodTypeSpecs(node.operand);
      return;
    }
    if (node is IsExpression) {
      _scanNodeForMethodTypeSpecs(node.operand);
      return;
    }
    if (node is NullCheck) {
      _scanNodeForMethodTypeSpecs(node.operand);
      return;
    }
    if (node is Throw) {
      _scanNodeForMethodTypeSpecs(node.expression);
      return;
    }
    if (node is AwaitExpression) {
      _scanNodeForMethodTypeSpecs(node.operand);
      return;
    }
    if (node is FunctionExpression) {
      if (node.function.body != null) _scanNodeForMethodTypeSpecs(node.function.body!);
      return;
    }
    if (node is FunctionDeclaration) {
      if (node.function.body != null) _scanNodeForMethodTypeSpecs(node.function.body!);
      return;
    }
    if (node is ListLiteral) {
      for (final e in node.expressions) _scanNodeForMethodTypeSpecs(e);
      return;
    }
    if (node is MapLiteral) {
      for (final e in node.entries) {
        _scanNodeForMethodTypeSpecs(e.key);
        _scanNodeForMethodTypeSpecs(e.value);
      }
      return;
    }
    if (node is SetLiteral) {
      for (final e in node.expressions) _scanNodeForMethodTypeSpecs(e);
      return;
    }
    if (node is FunctionInvocation) {
      _scanNodeForMethodTypeSpecs(node.receiver);
      for (final a in node.arguments.positional) _scanNodeForMethodTypeSpecs(a);
      for (final a in node.arguments.named) _scanNodeForMethodTypeSpecs(a.value);
      return;
    }
    if (node is DynamicInvocation) {
      _scanNodeForMethodTypeSpecs(node.receiver);
      for (final a in node.arguments.positional) _scanNodeForMethodTypeSpecs(a);
      for (final a in node.arguments.named) _scanNodeForMethodTypeSpecs(a.value);
      return;
    }
    if (node is SuperMethodInvocation) {
      for (final a in node.arguments.positional) _scanNodeForMethodTypeSpecs(a);
      for (final a in node.arguments.named) _scanNodeForMethodTypeSpecs(a.value);
      return;
    }
    // 其他节点类型不处理
  }

  void _collectVTableEntries(Class cls, {String? overrideName}) {
    final className = overrideName ?? cls.name;
    final entries = <_VTableEntry>[];

    // 先继承父类的虚表条目
    final parentName = _classHierarchy[className];
    if (parentName != null && _classVTableEntries.containsKey(parentName)) {
      entries.addAll(_classVTableEntries[parentName]!);
    }

    // 收集 implements 接口中的方法（如果本类或父类尚未声明）
    for (final impl in cls.implementedTypes) {
      final ifaceName = impl.classNode.name;
      if (_classVTableEntries.containsKey(ifaceName)) {
        for (final ifaceEntry in _classVTableEntries[ifaceName]!) {
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

    _classVTableEntries[className] = entries;
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
    } else if (_isOperatorNameBase(methodName)) {
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
    for (final field in lib.fields) _restoreField(field);

    // 输出所有延迟的顶层声明：类级共享 vtable 常量
    if (_pendingTopLevelDecls.isNotEmpty) {
      _buf.write('// ---- Class-level shared vtables ----\n');
      for (final decl in _pendingTopLevelDecls) {
        _buf.write(decl);
      }
      _buf.write('\n');
    }
    _pendingTopLevelDecls.clear();
    _emittedSharedVTableClasses.clear();

    // 输出所有延迟的闭包类和静态函数定义
    for (final decl in _pendingClosureDecls) {
      _buf.write(decl);
    }
    _pendingClosureDecls.clear();
  }

  /// 输出 VPtr 基类定义
  /// 所有无基类（或继承自 Object）的 Value 类都继承自它
  /// 提供 vptr 字段和 toString/operator==/hashCode 的桥接覆写
  void _emitVPtrBaseClass() {
    _buf.write('class VPtr {\n');
    _buf.write('  late Map<String, dynamic> vptr;\n');
    _buf.write('  VPtr() {\n');
    _buf.write('    vptr = <String, dynamic>{\n');
    _buf.write("      'toString': null,\n");
    _buf.write("      'operatorEq': null,\n");
    _buf.write("      'get_hashCode': null,\n");
    _buf.write('    };\n');
    _buf.write('  }\n');
    _buf.write('  @override\n');
    _buf.write('  String toString() {\n');
    _buf.write("    final fn = vptr['toString'];\n");
    _buf.write('    if (fn != null) return (fn as Function)(this) as String;\n');
    _buf.write('    return super.toString();\n');
    _buf.write('  }\n');
    _buf.write('  @override\n');
    _buf.write('  bool operator ==(Object other) {\n');
    _buf.write("    final fn = vptr['operatorEq'];\n");
    _buf.write('    if (fn != null) return (fn as Function)(this, other) as bool;\n');
    _buf.write('    return identical(this, other);\n');
    _buf.write('  }\n');
    _buf.write('  @override\n');
    _buf.write('  int get hashCode {\n');
    _buf.write("    final fn = vptr['get_hashCode'];\n");
    _buf.write('    if (fn != null) return (fn as Function)(this) as int;\n');
    _buf.write('    return super.hashCode;\n');
    _buf.write('  }\n');
    _buf.write('}\n\n');
  }

  bool _isSyntheticMixinClass(Class cls) {
    return cls.name.contains('&');
  }

  /// 输出 Box 类型定义（Bug 11 闭包引用语义）
  /// - IntBox/DoubleBox/StringBox/BoolBox 针对非空基础值类型
  /// - ObjectBox<T> 针对泛型参数类型（运行时可能是值类型）
  void _emitBoxClasses() {
    _buf.write('class IntBox {\n');
    _buf.write('  int value;\n');
    _buf.write('  IntBox(this.value);\n');
    _buf.write('}\n\n');

    _buf.write('class DoubleBox {\n');
    _buf.write('  double value;\n');
    _buf.write('  DoubleBox(this.value);\n');
    _buf.write('}\n\n');

    _buf.write('class StringBox {\n');
    _buf.write('  String value;\n');
    _buf.write('  StringBox(this.value);\n');
    _buf.write('}\n\n');

    _buf.write('class BoolBox {\n');
    _buf.write('  bool value;\n');
    _buf.write('  BoolBox(this.value);\n');
    _buf.write('}\n\n');

    _buf.write('class ObjectBox<T> {\n');
    _buf.write('  T value;\n');
    _buf.write('  ObjectBox(this.value);\n');
    _buf.write('}\n\n');
  }
}
