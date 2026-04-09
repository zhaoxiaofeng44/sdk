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

  /// 类继承关系：子类名 → 父类名（仅用户自定义类）
  final Map<String, String> _classHierarchy = {};

  /// 类 → 其所有虚方法名列表（含 getter/setter/operator）
  final Map<String, List<_VTableEntry>> _classVTableEntries = {};

  /// 类 → 其 Class AST 节点（用于查询字段等）
  final Map<String, Class> _classNodes = {};

  /// 当前正在处理的类（null 表示在顶层）
  Class? _currentClass;

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

  /// 当前闭包体内，被捕获变量 → env 前缀的映射
  /// key: VariableDeclaration (identity), value: env 字段访问前缀（如 'env.'）
  /// 当此映射非空时，_restoreVarGet/Set 会检查变量是否在映射中，
  /// 如果在则输出 'env.varName' 而非 'varName'
  final Map<VariableDeclaration, String> _capturedVarEnvPrefix = {};

  /// 当前闭包体内，this 是否被捕获到 env 中
  /// 如果为 true，ThisExpression 会被替换为 'env._thisReplacementName'
  bool _thisIsCapturedInEnv = false;

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
  final String typeStr;    // 类型字符串
  final bool isThis;       // 是否是 this 捕获

  _CapturedVar({
    required this.name,
    required this.typeStr,
    this.isThis = false,
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

  _VTableEntry({
    required this.name,
    required this.kind,
    required this.staticFuncName,
    required this.signature,
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

    for (final lib in component.libraries) {
      final uri = lib.importUri.toString();
      if (uri.startsWith('dart:') || uri.startsWith('package:')) continue;
      // 第一遍：收集所有用户自定义类信息
      _collectClassInfo(lib);
    }

    for (final lib in component.libraries) {
      final uri = lib.importUri.toString();
      if (uri.startsWith('dart:') || uri.startsWith('package:')) continue;
      _restoreLibrary(lib);
    }
    return _buf.toString();
  }

  // ---- 第一遍：收集类信息 ----

  void _collectClassInfo(Library lib) {
    for (final cls in lib.classes) {
      // mixin 声明：记录名称（不做 lowering，方法通过合成中间类处理）
      if (cls.isMixinDeclaration) {
        _mixinNames.add(cls.name);
        _classNodes[cls.name] = cls;
        continue;
      }

      // enum: 记录名称和节点
      if (_isEnumClass(cls)) {
        _enumNames.add(cls.name);
        _classNodes[cls.name] = cls;
        continue;
      }

      // 合成 mixin 中间类（名字包含 &）：作为普通用户类收集
      // 例如 _Dog&Animal&Printable → 规范化名称 Dog_Animal_Printable
      final className = cls.name.contains('&')
          ? _sanitizeSyntheticName(cls.name)
          : cls.name;

      _userClasses.add(className);
      _classNodes[className] = cls;

      // 记录继承关系
      if (cls.supertype != null) {
        final superName = cls.supertype!.classNode.name;
        if (superName.contains('&')) {
          // 合成类的父类也是合成类 → 规范化
          final parentLowered = _sanitizeSyntheticName(superName);
          _classHierarchy[className] = parentLowered;
        } else if (superName != 'Object') {
          // 普通父类
          final parentLowered = _isUserClass(superName) ? superName : superName;
          _classHierarchy[className] = parentLowered;
        }
      }

      // 收集虚表条目（使用规范化后的类名）
      _collectVTableEntries(cls, overrideName: className);
    }
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
        entries[existingIdx] = entry;
      } else {
        entries.add(entry);
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
    );
  }

  /// 简化版类型还原（用于签名生成，在第一遍收集时使用）
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
    if (type is TypeParameterType) return '${type.parameter.name ?? 'T'}$suffix';
    if (type is DynamicType) return 'dynamic';
    if (type is VoidType) return 'void';
    if (type is NeverType) return 'Never$suffix';
    return 'dynamic';
  }

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

    // 输出所有延迟的闭包类和静态函数定义
    for (final decl in _pendingClosureDecls) {
      _buf.write(decl);
    }
    _pendingClosureDecls.clear();
  }

  bool _isSyntheticMixinClass(Class cls) {
    return cls.name.contains('&');
  }
}
