import 'package:dart2cpp/restorer/runtime_classes.dart';

Promise<void> main() {
  final env = ClosureEnv_main_0();
  env._promise.setStartCallback(env.call);
  return env._promise;
}

const String _sdkPlatformDill = '/Users/alsc/MyProject/sdk/mydart/sdk/xcodebuild/DebugX64/dart-sdk/lib/_internal/vm_platform_strong.dill';
class ClosureEnv_main_0 {
  Promise<void> _promise;
  ClosureEnv_main_0() : _promise = Promise<void>();
  void call() => ClosureEnv_main_0_call(this);
}
void ClosureEnv_main_0_call(ClosureEnv_main_0 env) {
  final String testSource = 'mixin Printable {\n  String get displayName;\n  void printInfo() => print(\'[$displayName]\');\n}\n\nmixin Orderable<T> {\n  int compareTo(T other);\n  bool isLessThan(T other) => compareTo(other) < 0;\n}\n\nclass Animal {\n  final String name;\n  final int age;\n  Animal(this.name, this.age);\n  String speak() => \'...\';\n}\n\nclass Dog extends Animal with Printable, Orderable<Dog> {\n  final String breed;\n  Dog(super.name, super.age, this.breed);\n  \n  @override\n  String get displayName => \'Dog:$name\';\n  \n  @override\n  String speak() => \'Woof!\';\n  \n  @override\n  int compareTo(Dog other) => age.compareTo(other.age);\n}\n\nvoid main() {\n  final dog = Dog(\'Rex\', 5, \'Labrador\');\n  dog.printInfo();\n  print(dog.speak());\n  final dog2 = Dog(\'Buddy\', 3, \'Golden\');\n  print(\'dog < dog2: ${dog.isLessThan(dog2)}\');\n}\n';
  final File tempFile = File('/tmp/mixin_test_source.dart');
  smAwait(tempFile.writeAsString(testSource));
  print('=== 测试 Mixin Lowering ===\n');
  print('原始源码:');
  print(testSource);
  print('\n--- 编译为 Kernel AST ---');
  final CompilerOptions compilerOptions = (CompilerOptions()..sdkSummary = _Uri.file('/Users/alsc/MyProject/sdk/mydart/sdk/xcodebuild/DebugX64/dart-sdk/lib/_internal/vm_platform_strong.dill')..fileSystem = createFrontEndFileSystem(null, null)..embedSourceText = false..target = createFrontEndTarget('vm', trackWidgetCreation: false, supportMirrors: false));
  final KernelCompilationResults results = smAwait(compileToKernel(KernelCompilationArguments(source: tempFile.uri, options: compilerOptions, requireMain: false, includePlatform: false, environmentDefines: StaticMap<String, String>.of({}), enableAsserts: false)));
  final Component? component = results.component;
  if ((component == null)) {
    print('❌ 编译失败');
    return;
  }
  print('✅ 编译成功');
  print('\n--- DartRestorer 还原 ---');
  final String restoredSource = restoreDartFromComponent(component);
  print('还原后的代码:');
  print(restoredSource);
  final File restoredFile = File('/tmp/mixin_test_restored.dart');
  smAwait(restoredFile.writeAsString(restoredSource));
  print('\n✅ 已写入: /tmp/mixin_test_restored.dart');
  print('\n--- 运行还原后的代码 ---');
  final ProcessResult runResult = smAwait(Process.run('dart', StaticList<String>.of(['/tmp/mixin_test_restored.dart'])));
  if ((runResult.exitCode == 0)) {
    print('✅ 运行成功');
    print('输出:');
    print(runResult.stdout);
  }
 else {
    print('❌ 运行失败 (exit=${runResult.exitCode})');
    print('stderr:');
    print(runResult.stderr);
  }
  smAwait(tempFile.delete());
}
class MethodSpecEntryValue extends VPtr {
  late String vptrSuffix;
  late StaticList<String> typeArgStrs;
  MethodSpecEntryValue() {
    vptr['operatorEq'] = const _TearOff_MethodSpecEntry_operatorEq();
    vptr['get_hashCode'] = const _TearOff_MethodSpecEntry_get_hashCode();
  }
}

MethodSpecEntryValue MethodSpecEntry_new(dynamic this__, String vptrSuffix, StaticList<String> typeArgStrs) {
  final this_ = this__ as MethodSpecEntryValue;
  this_.vptrSuffix = vptrSuffix;
  this_.typeArgStrs = typeArgStrs;
  return this_;
}

bool MethodSpecEntry_operatorEq(dynamic this__, Object other) {
  final this_ = this__ as MethodSpecEntryValue;
  return ((other is MethodSpecEntryValue) && (other.vptrSuffix == this_.vptrSuffix));
}

int MethodSpecEntry_get_hashCode(dynamic this__) {
  final this_ = this__ as MethodSpecEntryValue;
  return this_.vptrSuffix.hashCode;
}


class _DartRestorerBaseValue extends VPtr {
  late StringBuffer _buf;
  late int _indent;
  late int _varCounter;
  late StaticMap<String, String> _cleanedNames;
  late StaticSet<String> _userClasses;
  late StaticSet<String> _mixinNames;
  late StaticSet<String> _enumNames;
  late StaticSet<String> _enumsWithCustomToString;
  late StaticMap<String, String> _classHierarchy;
  late StaticMap<String, StaticList<_VTableEntryValue>> _classVTableEntries;
  late StaticMap<String, Class> _classNodes;
  late StaticSet<String> _syntheticLoweredNames;
  late Class? _currentClass;
  late StaticMap<String, String> _activeTypeParamSubstitution;
  late StaticSet<TypeParameter> _activeTypeParamTargets;
  late bool _insideMethodBody;
  late String _thisReplacementName;
  late bool _insideAsyncFunction;
  late String _asyncInnerReturnType;
  late int _closureCounter;
  late StaticList<String> _closureContextStack;
  late StaticList<String> _pendingClosureDecls;
  late StaticSet<String> _emittedTearOffWrappers;
  late StaticList<String> _pendingTopLevelDecls;
  late StaticSet<String> _emittedSharedVTableClasses;
  late StaticMap<String, StaticMap<String, StaticSet<MethodSpecEntryValue>>> _methodTypeSpecializations;
  late StaticMap<VariableDeclaration, String> _capturedVarEnvPrefix;
  late bool _thisIsCapturedInEnv;
  late StaticSet<VariableDeclaration> _boxedVars;
  late StaticSet<VariableDeclaration> _currentFunctionParams;
}

_DartRestorerBaseValue _DartRestorerBase_new(dynamic this__) {
  final this_ = this__ as _DartRestorerBaseValue;
  this_._buf = StringBuffer();
  this_._indent = 0;
  this_._varCounter = 0;
  this_._cleanedNames = StaticMap<String, String>.of({});
  this_._userClasses = StaticSet<String>.of([]);
  this_._mixinNames = StaticSet<String>.of([]);
  this_._enumNames = StaticSet<String>.of([]);
  this_._enumsWithCustomToString = StaticSet<String>.of([]);
  this_._classHierarchy = StaticMap<String, String>.of({});
  this_._classVTableEntries = StaticMap<String, StaticList<_VTableEntryValue>>.of({});
  this_._classNodes = StaticMap<String, Class>.of({});
  this_._syntheticLoweredNames = StaticSet<String>.of([]);
  this_._currentClass = null;
  this_._activeTypeParamSubstitution = StaticMap<String, String>.of({});
  this_._activeTypeParamTargets = StaticSet<TypeParameter>.of([]);
  this_._insideMethodBody = false;
  this_._thisReplacementName = 'this_';
  this_._insideAsyncFunction = false;
  this_._asyncInnerReturnType = 'dynamic';
  this_._closureCounter = 0;
  this_._closureContextStack = StaticList<String>.of([]);
  this_._pendingClosureDecls = StaticList<String>.of([]);
  this_._emittedTearOffWrappers = StaticSet<String>.of([]);
  this_._pendingTopLevelDecls = StaticList<String>.of([]);
  this_._emittedSharedVTableClasses = StaticSet<String>.of([]);
  this_._methodTypeSpecializations = StaticMap<String, StaticMap<String, StaticSet<MethodSpecEntryValue>>>.of({});
  this_._capturedVarEnvPrefix = StaticMap<VariableDeclaration, String>.of({});
  this_._thisIsCapturedInEnv = false;
  this_._boxedVars = StaticSet<VariableDeclaration>.of([]);
  this_._currentFunctionParams = StaticSet<VariableDeclaration>.of([]);
  return this_;
}

String _DartRestorerBase_get__pad(dynamic this__) {
  final this_ = this__ as _DartRestorerBaseValue;
  return ('  ' * this_._indent);
}

bool _DartRestorerBase__isOperatorName(dynamic this__, String name) {
  final this_ = this__ as _DartRestorerBaseValue;
  return const {'+', '-', '*', '/', '%', '~/', '>', '<', '>=', '<=', '&', '|', '^', '<<', '>>', '==', '[]', '[]=', '~', 'unary-'}.contains(name);
}

bool _DartRestorerBase__containsTypeParameter(dynamic this__, DartType type) {
  final this_ = this__ as _DartRestorerBaseValue;
  if ((type is TypeParameterType))   return true;
  if ((type is InterfaceType)) {
    return type.typeArguments.any(ClosureEnv_anon_1(this_));
  }
  if ((type is FunctionType)) {
    if (_DartRestorerBase__containsTypeParameter(this_, type.returnType))     return true;
    return type.positionalParameters.any(ClosureEnv_anon_2(this_));
  }
  if ((type is FutureOrType)) {
    return _DartRestorerBase__containsTypeParameter(this_, type.typeArgument);
  }
  return false;
}

String _DartRestorerBase__typeToSpecStr(dynamic this__, DartType type, {bool asSuffix = false}) {
  final this_ = this__ as _DartRestorerBaseValue;
  if ((type is InterfaceType)) {
    final String name = type.classNode.name;
    if (type.typeArguments.isEmpty)     return name;
    final String separator = (asSuffix ? '_' : ', ');
    final String args = type.typeArguments.map(ClosureEnv_anon_3(this_, asSuffix)).join(separator);
    return (asSuffix ? '${name}_${args}' : '${name}<${args}>');
  }
  if ((type is TypeParameterType))   return (type.parameter.name ?? 'T');
  if ((type is DynamicType))   return 'dynamic';
  if ((type is VoidType))   return 'void';
  if ((type is FunctionType)) {
    return 'TypeFunction';
  }
  return 'dynamic';
}

String _DartRestorerBase__typeToSpecSuffix(dynamic this__, DartType type) {
  final this_ = this__ as _DartRestorerBaseValue;
  return _DartRestorerBase__typeToSpecStr(this_, type, asSuffix: true);
}

String _DartRestorerBase__typeToSpecRestoreStr(dynamic this__, DartType type) {
  final this_ = this__ as _DartRestorerBaseValue;
  return _DartRestorerBase__typeToSpecStr(this_, type, asSuffix: false);
}

bool _DartRestorerBase__needsBoxing(dynamic this__, DartType type) {
  final this_ = this__ as _DartRestorerBaseValue;
  if (!((_DartRestorerBase__primitiveBoxName(this_, type) == null)))   return true;
  if ((type is TypeParameterType))   return true;
  return false;
}

String? _DartRestorerBase__primitiveBoxName(dynamic this__, DartType type) {
  final this_ = this__ as _DartRestorerBaseValue;
  if ((type is InterfaceType)) {
    final String name = type.classNode.name;
    final bool nonNull = !((type.nullability == Nullability.nullable));
    if (nonNull) {
      if ((name == 'int'))       return 'IntBox';
      if ((name == 'double'))       return 'DoubleBox';
      if ((name == 'String'))       return 'StringBox';
      if ((name == 'bool'))       return 'BoolBox';
    }
  }
  return null;
}

void _DartRestorerBase__preanalyzeBoxedVarsForFunc(dynamic this__, FunctionNode func) {
  final this_ = this__ as _DartRestorerBaseValue;
  if ((func.body == null))   return;
  final StaticSet<VariableDeclaration> localOfThisLevel = StaticSet<VariableDeclaration>.of([]);
  localOfThisLevel.addAll(func.positionalParameters);
  localOfThisLevel.addAll(func.namedParameters);
  _DartRestorerBase__collectShallowDecls(this_, func.body!, localOfThisLevel);
  final StaticList<FunctionExpression> innerClosures = StaticList<FunctionExpression>.of([]);
  _DartRestorerBase__collectAllFunctionExpressions(this_, func.body!, innerClosures);
  final StaticSet<VariableDeclaration> namedParamSet = StaticSet<VariableDeclaration>.of([]);
  namedParamSet.addAll(func.namedParameters);
  for (final fe in innerClosures) {
    final _CaptureAnalysisResultValue analysis = analyzeCapturedVarsFromFunc(fe.function);
    for (final captured in analysis.capturedDecls)     do {
{
        if (!(localOfThisLevel.contains(captured)))         break;
        if (namedParamSet.contains(captured))         break;
        final TreeNode? parent = captured.parent;
        if (((parent is ForStatement) && parent.variables.contains(captured)))         break;
        if (!(_DartRestorerBase__needsBoxing(this_, captured.type)))         break;
        this_._boxedVars.add(captured);
      }
    } while (false);
  }
}

void _DartRestorerBase__collectShallowDecls(dynamic this__, TreeNode node, StaticSet<VariableDeclaration> out) {
  final this_ = this__ as _DartRestorerBaseValue;
  if ((node is FunctionExpression))   return;
  if ((node is FunctionDeclaration)) {
    out.add(node.variable);
    return;
  }
  if ((node is VariableDeclaration)) {
    out.add(node);
    if (!((node.initializer == null))) {
      _DartRestorerBase__collectShallowDecls(this_, node.initializer!, out);
    }
    return;
  }
  _DartRestorerBase__visitChildrenForLocalDecl(this_, node, out);
}

void _DartRestorerBase__forEachChildNode(dynamic this__, TreeNode node, TypeFunction1<void, TreeNode> visit, {TypeFunction1<void, VariableDeclaration>? onTryCatchVar = null, TypeFunction1<void, VariableDeclaration>? onLetVar = null}) {
  final this_ = this__ as _DartRestorerBaseValue;
  if ((node is Block)) {
    for (final s in node.statements)     visit(s);
  }
 else   if ((node is ExpressionStatement)) {
    visit(node.expression);
  }
 else   if ((node is ReturnStatement)) {
    if (!((node.expression == null)))     visit(node.expression!);
  }
 else   if ((node is IfStatement)) {
    visit(node.condition);
    visit(node.then);
    if (!((node.otherwise == null)))     visit(node.otherwise!);
  }
 else   if ((node is ForStatement)) {
    for (final v in node.variables)     visit(v);
    if (!((node.condition == null)))     visit(node.condition!);
    for (final u in node.updates)     visit(u);
    visit(node.body);
  }
 else   if ((node is ForInStatement)) {
    visit(node.variable);
    visit(node.iterable);
    visit(node.body);
  }
 else   if ((node is WhileStatement)) {
    visit(node.condition);
    visit(node.body);
  }
 else   if ((node is DoStatement)) {
    visit(node.body);
    visit(node.condition);
  }
 else   if ((node is TryCatch)) {
    visit(node.body);
    for (final c in node.catches) {
      if (!((onTryCatchVar == null))) {
        if (!((c.exception == null)))         onTryCatchVar(c.exception!);
        if (!((c.stackTrace == null)))         onTryCatchVar(c.stackTrace!);
      }
      visit(c.body);
    }
  }
 else   if ((node is TryFinally)) {
    visit(node.body);
    visit(node.finalizer);
  }
 else   if ((node is SwitchStatement)) {
    visit(node.expression);
    for (final c in node.cases)     visit(c.body);
  }
 else   if ((node is LabeledStatement)) {
    visit(node.body);
  }
 else   if ((node is YieldStatement)) {
    visit(node.expression);
  }
 else   if ((node is AssertStatement)) {
    visit(node.condition);
    if (!((node.message == null)))     visit(node.message!);
  }
 else   if ((node is VariableDeclaration)) {
    if (!((node.initializer == null)))     visit(node.initializer!);
  }
 else   if ((node is Let)) {
    if (!((onLetVar == null)))     onLetVar(node.variable);
    if (!((node.variable.initializer == null)))     visit(node.variable.initializer!);
    visit(node.body);
  }
 else   if ((node is BlockExpression)) {
    visit(node.body);
    visit(node.value);
  }
 else   if ((node is InstanceInvocation)) {
    visit(node.receiver);
    for (final a in node.arguments.positional)     visit(a);
    for (final a in node.arguments.named)     visit(a.value);
  }
 else   if ((node is StaticInvocation)) {
    for (final a in node.arguments.positional)     visit(a);
    for (final a in node.arguments.named)     visit(a.value);
  }
 else   if ((node is ConstructorInvocation)) {
    for (final a in node.arguments.positional)     visit(a);
    for (final a in node.arguments.named)     visit(a.value);
  }
 else   if ((node is InstanceGet)) {
    visit(node.receiver);
  }
 else   if ((node is InstanceSet)) {
    visit(node.receiver);
    visit(node.value);
  }
 else   if ((node is VariableSet)) {
    visit(node.value);
  }
 else   if ((node is ConditionalExpression)) {
    visit(node.condition);
    visit(node.then);
    visit(node.otherwise);
  }
 else   if ((node is LogicalExpression)) {
    visit(node.left);
    visit(node.right);
  }
 else   if ((node is Not)) {
    visit(node.operand);
  }
 else   if ((node is StringConcatenation)) {
    for (final e in node.expressions)     visit(e);
  }
 else   if ((node is AsExpression)) {
    visit(node.operand);
  }
 else   if ((node is IsExpression)) {
    visit(node.operand);
  }
 else   if ((node is NullCheck)) {
    visit(node.operand);
  }
 else   if ((node is AwaitExpression)) {
    visit(node.operand);
  }
 else   if ((node is ListLiteral)) {
    for (final e in node.expressions)     visit(e);
  }
 else   if ((node is SetLiteral)) {
    for (final e in node.expressions)     visit(e);
  }
 else   if ((node is MapLiteral)) {
    for (final e in node.entries) {
      visit(e.key);
      visit(e.value);
    }
  }
 else   if ((node is Throw)) {
    visit(node.expression);
  }
 else   if ((node is EqualsCall)) {
    visit(node.left);
    visit(node.right);
  }
 else   if ((node is EqualsNull)) {
    visit(node.expression);
  }
 else   if ((node is FunctionInvocation)) {
    visit(node.receiver);
    for (final a in node.arguments.positional)     visit(a);
    for (final a in node.arguments.named)     visit(a.value);
  }
 else   if ((node is DynamicInvocation)) {
    visit(node.receiver);
    for (final a in node.arguments.positional)     visit(a);
    for (final a in node.arguments.named)     visit(a.value);
  }
 else   if ((node is LocalFunctionInvocation)) {
    for (final a in node.arguments.positional)     visit(a);
    for (final a in node.arguments.named)     visit(a.value);
  }
}

void _DartRestorerBase__visitChildrenForLocalDecl(dynamic this__, TreeNode node, StaticSet<VariableDeclaration> out) {
  final this_ = this__ as _DartRestorerBaseValue;
  _DartRestorerBase__forEachChildNode(this_, node, ClosureEnv_anon_4(this_, out), onTryCatchVar: ClosureEnv_anon_5(out), onLetVar: ClosureEnv_anon_6(out));
}

void _DartRestorerBase__collectAllFunctionExpressions(dynamic this__, TreeNode node, StaticList<FunctionExpression> out) {
  final this_ = this__ as _DartRestorerBaseValue;
  if ((node is FunctionExpression)) {
    out.add(node);
    if (!((node.function.body == null))) {
      _DartRestorerBase__collectAllFunctionExpressions(this_, node.function.body!, out);
    }
    return;
  }
  if ((node is FunctionDeclaration)) {
    if (!((node.function.body == null))) {
      _DartRestorerBase__collectAllFunctionExpressions(this_, node.function.body!, out);
    }
    return;
  }
  _DartRestorerBase__forEachChildNode(this_, node, ClosureEnv_anon_7(this_, out));
}

String _DartRestorerBase__sanitizeClosureContextName(dynamic this__, String name) {
  final this_ = this__ as _DartRestorerBaseValue;
  if (name.contains('|')) {
    return _DartRestorerBase__sanitizeExtensionMethodName(this_, name);
  }
  return name.replaceAll(RegExp('[^a-zA-Z0-9_]'), '_');
}

void _DartRestorerBase__pushClosureContext(dynamic this__, String name) {
  final this_ = this__ as _DartRestorerBaseValue;
  this_._closureContextStack.add(_DartRestorerBase__sanitizeClosureContextName(this_, name));
}

void _DartRestorerBase__popClosureContext(dynamic this__) {
  final this_ = this__ as _DartRestorerBaseValue;
  if (this_._closureContextStack.isNotEmpty)   this_._closureContextStack.removeLast();
}

String _DartRestorerBase_get__closureContext(dynamic this__) {
  final this_ = this__ as _DartRestorerBaseValue;
  if (this_._closureContextStack.isNotEmpty)   return this_._closureContextStack.last;
  return 'anon';
}

String _DartRestorerBase__vtableFieldName(dynamic this__, String methodName) {
  final this_ = this__ as _DartRestorerBaseValue;
  return methodName;
}

String _DartRestorerBase__restoreTypeForSignature(dynamic this__, DartType type) {
  final this_ = this__ as _DartRestorerBaseValue;
  final bool nullable = (type.nullability == Nullability.nullable);
  final String suffix = (nullable ? '?' : '');
  if ((type is InterfaceType)) {
    final String name = type.classNode.name;
    late String mappedName;
    if (_DartRestorerBase__isUserClass(this_, name)) {
      mappedName = '${name}Value';
    }
 else     if ((((name == 'List') || (name == '_GrowableList')) || (name == '_List'))) {
      mappedName = 'StaticList';
    }
 else     if (((((name == 'Map') || (name == '_Map')) || (name == 'LinkedHashMap')) || (name == '_InternalLinkedHashMap'))) {
      mappedName = 'StaticMap';
    }
 else     if (((((name == 'Set') || (name == '_Set')) || (name == 'LinkedHashSet')) || (name == '_CompactLinkedHashSet'))) {
      mappedName = 'StaticSet';
    }
 else     if (((name == 'Future') || (name == '_Future'))) {
      mappedName = 'Promise';
    }
 else     if ((name == 'Function')) {
      return 'dynamic';
    }
 else {
      mappedName = name;
    }
    if (type.typeArguments.isEmpty)     return '${mappedName}${suffix}';
    final String args = type.typeArguments.map(ClosureEnv_anon_8(this_)).join(', ');
    return '${mappedName}<${args}>${suffix}';
  }
  if ((type is FunctionType)) {
    final String ret = _DartRestorerBase__restoreTypeForSignature(this_, type.returnType);
    final bool hasNamed = type.namedParameters.isNotEmpty;
    final StaticList<DartType> positional = type.positionalParameters;
    final int required_ = type.requiredParameterCount;
    final bool hasOptional = (positional.length > required_);
    if (((hasNamed || hasOptional) || (positional.length > 16))) {
      return 'TypeFunction<${ret}>${suffix}';
    }
    final int arity = positional.length;
    final StaticList<String> paramTexts = (() {     final StaticList<String> _v2 = StaticList<String>.of([]);
    for (final p in positional)     _v2.add(_DartRestorerBase__restoreTypeForSignature(this_, p));
 return _v2; })();
    final String args = (() {     final StaticList<String> _v3 = StaticList<String>.of([ret]);
    _v3.addAll(paramTexts);
 return _v3; })().join(', ');
    return 'TypeFunction${arity}<${args}>${suffix}';
  }
  if ((type is TypeParameterType)) {
    final String paramName = (type.parameter.name ?? 'T');
    final String? replacement = this_._activeTypeParamSubstitution[paramName];
    if (!((replacement == null))) {
      if ((this_._activeTypeParamTargets.isEmpty || this_._activeTypeParamTargets.contains(type.parameter))) {
        return '${replacement}${suffix}';
      }
    }
    if (!(this_._insideMethodBody)) {
      return 'dynamic';
    }
    return '${paramName}${suffix}';
  }
  if ((type is DynamicType))   return 'dynamic';
  if ((type is VoidType))   return 'void';
  if ((type is NeverType))   return 'Never${suffix}';
  return 'dynamic';
}

bool _DartRestorerBase__isUserClass(dynamic this__, String name) {
  final this_ = this__ as _DartRestorerBaseValue;
  if (this_._userClasses.contains(name))   return true;
  if (name.contains('&')) {
    return this_._userClasses.contains(_DartRestorerBase__sanitizeSyntheticName(this_, name));
  }
  return false;
}

bool _DartRestorerBase__isMixinName(dynamic this__, String name) {
  final this_ = this__ as _DartRestorerBaseValue;
  return this_._mixinNames.contains(name);
}

bool _DartRestorerBase__isEnumName(dynamic this__, String name) {
  final this_ = this__ as _DartRestorerBaseValue;
  return this_._enumNames.contains(name);
}

bool _DartRestorerBase__needsLowering(dynamic this__, String name) {
  final this_ = this__ as _DartRestorerBaseValue;
  if (((this_._userClasses.contains(name) || this_._mixinNames.contains(name)) || this_._enumNames.contains(name))) {
    return true;
  }
  if (name.contains('&')) {
    return this_._userClasses.contains(_DartRestorerBase__sanitizeSyntheticName(this_, name));
  }
  return false;
}

bool _DartRestorerBase__isSyntheticMixinClassName(dynamic this__, String name) {
  final this_ = this__ as _DartRestorerBaseValue;
  return name.contains('&');
}

String _DartRestorerBase__sanitizeSyntheticName(dynamic this__, String name) {
  final this_ = this__ as _DartRestorerBaseValue;
  String result = name;
  if (result.startsWith('_'))   result = result.substring(1);
  return result.replaceAll('&', '_');
}

String _DartRestorerBase__loweredClassName(dynamic this__, String rawName) {
  final this_ = this__ as _DartRestorerBaseValue;
  if (_DartRestorerBase__isSyntheticMixinClassName(this_, rawName)) {
    return _DartRestorerBase__sanitizeSyntheticName(this_, rawName);
  }
  return rawName;
}

String? _DartRestorerBase__getParentClassName(dynamic this__, String className) {
  final this_ = this__ as _DartRestorerBaseValue;
  return this_._classHierarchy[className];
}

String _DartRestorerBase__operatorFuncName(dynamic this__, String operatorSymbol) {
  final this_ = this__ as _DartRestorerBaseValue;
  return (const {'+': 'Plus', '-': 'Minus', '*': 'Star', '/': 'Div', '%': 'Mod', '~/': 'TruncDiv', '>': 'Gt', '<': 'Lt', '>=': 'Gte', '<=': 'Lte', '&': 'BitAnd', '|': 'BitOr', '^': 'BitXor', '<<': 'Shl', '>>': 'Shr', '==': 'Eq', '[]': 'Index', '[]=': 'IndexSet', '~': 'BitNot', 'unary-': 'Neg'}[operatorSymbol] ?? operatorSymbol);
}

String _DartRestorerBase__staticMethodName(dynamic this__, String className, String methodName) {
  final this_ = this__ as _DartRestorerBaseValue;
  if (_DartRestorerBase__isOperatorName(this_, methodName)) {
    return '${className}_operator${_DartRestorerBase__operatorFuncName(this_, methodName)}';
  }
  return '${className}_${methodName}';
}

String _DartRestorerBase__staticGetterName(dynamic this__, String className, String propName) {
  final this_ = this__ as _DartRestorerBaseValue;
  return '${className}_get_${propName}';
}

String _DartRestorerBase__staticSetterName(dynamic this__, String className, String propName) {
  final this_ = this__ as _DartRestorerBaseValue;
  return '${className}_set_${propName}';
}

String _DartRestorerBase__sanitizeExtensionMethodName(dynamic this__, String rawName) {
  final this_ = this__ as _DartRestorerBaseValue;
  if (!(rawName.contains('|')))   return rawName;
  final int pipeIdx = rawName.indexOf('|');
  final String extensionName = rawName.substring(0, pipeIdx);
  String memberPart = rawName.substring((pipeIdx + 1));
  if (memberPart.startsWith('get#')) {
    final String propName = memberPart.substring(4);
    return '${extensionName}_get_${propName}';
  }
  if (memberPart.startsWith('set#')) {
    final String propName = memberPart.substring(4);
    return '${extensionName}_set_${propName}';
  }
  memberPart = memberPart.replaceAll(RegExp('[^a-zA-Z0-9_]'), '_');
  return '${extensionName}_${memberPart}';
}

bool _DartRestorerBase__isExtensionMethodName(dynamic this__, String name) {
  final this_ = this__ as _DartRestorerBaseValue;
  return name.contains('|');
}

String _DartRestorerBase__defaultValueForType(dynamic this__, DartType type) {
  final this_ = this__ as _DartRestorerBaseValue;
  if ((type is InterfaceType)) {
    final String name = type.classNode.name;
    if (((name == 'int') && !((type.nullability == Nullability.nullable))))     return '0';
    if (((name == 'double') && !((type.nullability == Nullability.nullable))))     return '0.0';
    if (((name == 'bool') && !((type.nullability == Nullability.nullable))))     return 'false';
    if (((name == 'String') && !((type.nullability == Nullability.nullable))))     return '\'\'';
  }
  return 'null';
}

String _DartRestorerBase__restoreExpr(dynamic this_, Expression expr) {
  throw UnimplementedError('_DartRestorerBase._restoreExpr is abstract');
}

void _DartRestorerBase__restoreStmt(dynamic this_, Statement stmt) {
  throw UnimplementedError('_DartRestorerBase._restoreStmt is abstract');
}

void _DartRestorerBase__writeTypeParams(dynamic this_, StaticList<TypeParameter> params) {
  throw UnimplementedError('_DartRestorerBase._writeTypeParams is abstract');
}

void _DartRestorerBase__writeParams(dynamic this_, FunctionNode func, {Procedure? proc = null}) {
  throw UnimplementedError('_DartRestorerBase._writeParams is abstract');
}


class _CaptureAnalysisResultValue extends VPtr {
  late StaticList<VariableDeclaration> capturedDecls;
  late bool capturesThis;
}

_CaptureAnalysisResultValue _CaptureAnalysisResult_new(dynamic this__, {required StaticList<VariableDeclaration> capturedDecls, required bool capturesThis}) {
  final this_ = this__ as _CaptureAnalysisResultValue;
  this_.capturedDecls = capturedDecls;
  this_.capturesThis = capturesThis;
  return this_;
}


class _CapturedVarValue extends VPtr {
  late String name;
  late String typeStr;
  late bool isThis;
  late bool isBoxed;
  _CapturedVarValue() {
    vptr['operatorEq'] = const _TearOff__CapturedVar_operatorEq();
    vptr['get_hashCode'] = const _TearOff__CapturedVar_get_hashCode();
  }
}

_CapturedVarValue _CapturedVar_new(dynamic this__, {required String name, required String typeStr, bool isThis = false, bool isBoxed = false}) {
  final this_ = this__ as _CapturedVarValue;
  this_.name = name;
  this_.typeStr = typeStr;
  this_.isThis = isThis;
  this_.isBoxed = isBoxed;
  return this_;
}

bool _CapturedVar_operatorEq(dynamic this__, Object other) {
  final this_ = this__ as _CapturedVarValue;
  return ((other is _CapturedVarValue) && (this_.name == other.name));
}

int _CapturedVar_get_hashCode(dynamic this__) {
  final this_ = this__ as _CapturedVarValue;
  return this_.name.hashCode;
}


class _VTableEntryValue extends VPtr {
  late String name;
  late String kind;
  late String staticFuncName;
  late String signature;
  late Procedure? proc;
  late String? declaringClassName;
}

_VTableEntryValue _VTableEntry_new(dynamic this__, {required String name, required String kind, required String staticFuncName, required String signature, Procedure? proc = null, String? declaringClassName = null}) {
  final this_ = this__ as _VTableEntryValue;
  this_.name = name;
  this_.kind = kind;
  this_.staticFuncName = staticFuncName;
  this_.signature = signature;
  this_.proc = proc;
  this_.declaringClassName = declaringClassName;
  return this_;
}


class DartRestorerValue extends DartRestorer__DartRestorerBase__TypeUtils__ConstantRestorer__ExpressionRestorer__StatementRestorer__DeclarationRestorerValue {
  DartRestorerValue() {
    vptr['restore'] = const _TearOff_DartRestorer_restore();
  }
}

DartRestorerValue DartRestorer_new(dynamic this__) {
  final this_ = this__ as DartRestorerValue;
  _DartRestorerBase_new(this_);
  this_._buf = StringBuffer();
  this_._indent = 0;
  this_._varCounter = 0;
  this_._cleanedNames = StaticMap<String, String>.of({});
  this_._userClasses = StaticSet<String>.of([]);
  this_._mixinNames = StaticSet<String>.of([]);
  this_._enumNames = StaticSet<String>.of([]);
  this_._enumsWithCustomToString = StaticSet<String>.of([]);
  this_._classHierarchy = StaticMap<String, String>.of({});
  this_._classVTableEntries = StaticMap<String, StaticList<_VTableEntryValue>>.of({});
  this_._classNodes = StaticMap<String, Class>.of({});
  this_._syntheticLoweredNames = StaticSet<String>.of([]);
  this_._currentClass = null;
  this_._activeTypeParamSubstitution = StaticMap<String, String>.of({});
  this_._activeTypeParamTargets = StaticSet<TypeParameter>.of([]);
  this_._insideMethodBody = false;
  this_._thisReplacementName = 'this_';
  this_._insideAsyncFunction = false;
  this_._asyncInnerReturnType = 'dynamic';
  this_._closureCounter = 0;
  this_._closureContextStack = StaticList<String>.of([]);
  this_._pendingClosureDecls = StaticList<String>.of([]);
  this_._emittedTearOffWrappers = StaticSet<String>.of([]);
  this_._pendingTopLevelDecls = StaticList<String>.of([]);
  this_._emittedSharedVTableClasses = StaticSet<String>.of([]);
  this_._methodTypeSpecializations = StaticMap<String, StaticMap<String, StaticSet<MethodSpecEntryValue>>>.of({});
  this_._capturedVarEnvPrefix = StaticMap<VariableDeclaration, String>.of({});
  this_._thisIsCapturedInEnv = false;
  this_._boxedVars = StaticSet<VariableDeclaration>.of([]);
  this_._currentFunctionParams = StaticSet<VariableDeclaration>.of([]);
  return this_;
}

String DartRestorer_restore(dynamic this__, Component component) {
  final this_ = this__ as DartRestorerValue;
  this_._buf.clear();
  this_._userClasses.clear();
  this_._mixinNames.clear();
  this_._enumNames.clear();
  this_._classHierarchy.clear();
  this_._classVTableEntries.clear();
  this_._classNodes.clear();
  this_._syntheticLoweredNames.clear();
  for (final lib in component.libraries)   do {
{
      final String uri = lib.importUri.toString();
      if ((uri.startsWith('dart:') || uri.startsWith('package:')))       break;
      DartRestorer__collectClassInfo(this_, lib);
    }
  } while (false);
  this_._methodTypeSpecializations.clear();
  for (final lib in component.libraries)   do {
{
      final String uri = lib.importUri.toString();
      if ((uri.startsWith('dart:') || uri.startsWith('package:')))       break;
      DartRestorer__collectMethodTypeSpecializations(this_, lib);
    }
  } while (false);
  DartRestorer__emitRuntimeImport(this_);
  for (final lib in component.libraries)   do {
{
      final String uri = lib.importUri.toString();
      if ((uri.startsWith('dart:') || uri.startsWith('package:')))       break;
      DartRestorer__restoreLibrary(this_, lib);
    }
  } while (false);
  return this_._buf.toString();
}

void DartRestorer__collectClassInfo(dynamic this__, Library lib) {
  final this_ = this__ as DartRestorerValue;
  final StaticList<(String, Class)> userClassEntries = StaticList<(String, Class)>.of([]);
  for (final cls in lib.classes)   do {
{
      if (cls.isMixinDeclaration) {
        this_._mixinNames.add(cls.name);
        this_._classNodes[cls.name] = cls;
        break;
      }
      if (DartRestorer__isEnumClass(this_, cls)) {
        this_._enumNames.add(cls.name);
        this_._classNodes[cls.name] = cls;
        final bool hasCustomToString = cls.procedures.any(ClosureEnv_anon_9());
        if (hasCustomToString) {
          this_._enumsWithCustomToString.add(cls.name);
        }
        break;
      }
      final bool isSynthetic = cls.name.contains('&');
      final String className = (isSynthetic ? _DartRestorerBase__sanitizeSyntheticName(this_, cls.name) : cls.name);
      this_._userClasses.add(className);
      if (isSynthetic) {
        this_._syntheticLoweredNames.add(className);
      }
      this_._classNodes[className] = cls;
      if (!((cls.supertype == null))) {
        final String superName = cls.supertype!.classNode.name;
        if (superName.contains('&')) {
          final String parentLowered = _DartRestorerBase__sanitizeSyntheticName(this_, superName);
          this_._classHierarchy[className] = parentLowered;
        }
 else         if (!((superName == 'Object'))) {
          this_._classHierarchy[className] = superName;
        }
      }
      userClassEntries.add((className, cls));
    }
  } while (false);
  final StaticList<(String, Class)> sorted = DartRestorer__topologicalSort(this_, userClassEntries);
  for (final _item6 in sorted) {
    final String className;
    final Class cls;
{
      final (String, Class) _v7 = _item6;
      className = _v7.$1;
      cls = _v7.$2;
    }
    DartRestorer__collectVTableEntries(this_, cls, overrideName: className);
  }
}

StaticList<(String, Class)> DartRestorer__topologicalSort(dynamic this__, StaticList<(String, Class)> entries) {
  final this_ = this__ as DartRestorerValue;
  final StaticMap<String, (String, Class)> nameToEntry = StaticMap<String, (String, Class)>.of({});
  for (final entry in entries) {
    nameToEntry[entry.$1] = entry;
  }
  final StaticList<(String, Class)> sorted = StaticList<(String, Class)>.of([]);
  final StaticSet<String> visited = StaticSet<String>.of([]);
  void visit(String className) {
    if (visited.contains(className))     return;
    visited.add(className);
    final String? parent = this_._classHierarchy[className];
    if ((!((parent == null)) && nameToEntry.containsKey(parent))) {
      visit(parent);
    }
    final (String, Class)? entry = nameToEntry[className];
    if (!((entry == null))) {
      sorted.add(entry);
    }
  }

  for (final entry in entries) {
    visit(entry.$1);
  }
  return sorted;
}

void DartRestorer__collectMethodTypeSpecializations(dynamic this__, Library lib) {
  final this_ = this__ as DartRestorerValue;
  for (final cls in lib.classes) {
    for (final proc in cls.procedures) {
      if (!((proc.function.body == null))) {
        DartRestorer__scanNodeForMethodTypeSpecs(this_, proc.function.body!);
      }
    }
    for (final ctor in cls.constructors) {
      if (!((ctor.function.body == null))) {
        DartRestorer__scanNodeForMethodTypeSpecs(this_, ctor.function.body!);
      }
      for (final init in ctor.initializers) {
        if ((init is FieldInitializer)) {
          DartRestorer__scanNodeForMethodTypeSpecs(this_, init.value);
        }
      }
    }
    for (final field in cls.fields) {
      if (!((field.initializer == null))) {
        DartRestorer__scanNodeForMethodTypeSpecs(this_, field.initializer!);
      }
    }
  }
  for (final proc in lib.procedures) {
    if (!((proc.function.body == null))) {
      DartRestorer__scanNodeForMethodTypeSpecs(this_, proc.function.body!);
    }
  }
  for (final field in lib.fields) {
    if (!((field.initializer == null))) {
      DartRestorer__scanNodeForMethodTypeSpecs(this_, field.initializer!);
    }
  }
}

void DartRestorer__scanNodeForMethodTypeSpecs(dynamic this__, TreeNode node) {
  final this_ = this__ as DartRestorerValue;
  if ((node is InstanceInvocation)) {
    DartRestorer__checkAndRecordMethodTypeSpec(this_, node);
    DartRestorer__scanNodeForMethodTypeSpecs(this_, node.receiver);
    for (final a in node.arguments.positional) {
      DartRestorer__scanNodeForMethodTypeSpecs(this_, a);
    }
    for (final a in node.arguments.named) {
      DartRestorer__scanNodeForMethodTypeSpecs(this_, a.value);
    }
    return;
  }
  DartRestorer__scanChildrenForMethodTypeSpecs(this_, node);
}

void DartRestorer__checkAndRecordMethodTypeSpec(dynamic this__, InstanceInvocation node) {
  final this_ = this__ as DartRestorerValue;
  final Procedure target = node.interfaceTarget;
  final StaticList<TypeParameter> methodTypeParams = target.function.typeParameters;
  if (methodTypeParams.isEmpty)   return;
  final Class? enclosingClass = target.enclosingClass;
  if ((enclosingClass == null))   return;
  String className = enclosingClass.name;
  if (className.contains('&')) {
    className = _DartRestorerBase__sanitizeSyntheticName(this_, className);
  }
  if (!(this_._userClasses.contains(className)))   return;
  if (this_._syntheticLoweredNames.contains(className)) {
    className = DartRestorer__findUserClassForSynthetic(this_, className);
  }
  final StaticSet<String?> classTpNames = StaticSet.of(enclosingClass.typeParameters.map(ClosureEnv_anon_10()).toSet().toList());
  final StaticList<TypeParameter> dedupedMethodTps = StaticList.of(methodTypeParams.where(ClosureEnv_anon_11(classTpNames)).toList());
  if (dedupedMethodTps.isEmpty)   return;
  final StaticList<DartType> methodTypeArgs = node.arguments.types;
  if (methodTypeArgs.isEmpty)   return;
  final bool hasAbstractTypeArg = methodTypeArgs.any(ClosureEnv_anon_12(this_));
  if (hasAbstractTypeArg)   return;
  final String methodName = target.name.text;
  final String typeSuffix = methodTypeArgs.map(ClosureEnv_anon_13(this_)).join('_');
  if (typeSuffix.isEmpty)   return;
  final StaticList<String> typeArgStrs = StaticList.of(methodTypeArgs.map(ClosureEnv_anon_14(this_)).toList());
  this_._methodTypeSpecializations.putIfAbsent(className, ClosureEnv_anon_15()).putIfAbsent(methodName, ClosureEnv_anon_16()).add(MethodSpecEntry_new(MethodSpecEntryValue(), typeSuffix, typeArgStrs));
}

void DartRestorer__scanChildrenForMethodTypeSpecs(dynamic this__, TreeNode node) {
  final this_ = this__ as DartRestorerValue;
  if ((node is Block)) {
    for (final s in node.statements)     DartRestorer__scanNodeForMethodTypeSpecs(this_, s);
    return;
  }
  if ((node is ExpressionStatement)) {
    DartRestorer__scanNodeForMethodTypeSpecs(this_, node.expression);
    return;
  }
  if ((node is ReturnStatement)) {
    if (!((node.expression == null)))     DartRestorer__scanNodeForMethodTypeSpecs(this_, node.expression!);
    return;
  }
  if ((node is VariableDeclaration)) {
    if (!((node.initializer == null)))     DartRestorer__scanNodeForMethodTypeSpecs(this_, node.initializer!);
    return;
  }
  if ((node is VariableSet)) {
    DartRestorer__scanNodeForMethodTypeSpecs(this_, node.value);
    return;
  }
  if ((node is VariableGet))   return;
  if ((node is IfStatement)) {
    DartRestorer__scanNodeForMethodTypeSpecs(this_, node.condition);
    DartRestorer__scanNodeForMethodTypeSpecs(this_, node.then);
    if (!((node.otherwise == null)))     DartRestorer__scanNodeForMethodTypeSpecs(this_, node.otherwise!);
    return;
  }
  if ((node is ForStatement)) {
    for (final v in node.variables)     DartRestorer__scanNodeForMethodTypeSpecs(this_, v);
    if (!((node.condition == null)))     DartRestorer__scanNodeForMethodTypeSpecs(this_, node.condition!);
    for (final u in node.updates)     DartRestorer__scanNodeForMethodTypeSpecs(this_, u);
    DartRestorer__scanNodeForMethodTypeSpecs(this_, node.body);
    return;
  }
  if ((node is ForInStatement)) {
    DartRestorer__scanNodeForMethodTypeSpecs(this_, node.variable);
    DartRestorer__scanNodeForMethodTypeSpecs(this_, node.iterable);
    DartRestorer__scanNodeForMethodTypeSpecs(this_, node.body);
    return;
  }
  if ((node is WhileStatement)) {
    DartRestorer__scanNodeForMethodTypeSpecs(this_, node.condition);
    DartRestorer__scanNodeForMethodTypeSpecs(this_, node.body);
    return;
  }
  if ((node is DoStatement)) {
    DartRestorer__scanNodeForMethodTypeSpecs(this_, node.body);
    DartRestorer__scanNodeForMethodTypeSpecs(this_, node.condition);
    return;
  }
  if ((node is TryCatch)) {
    DartRestorer__scanNodeForMethodTypeSpecs(this_, node.body);
    for (final c in node.catches) {
      DartRestorer__scanNodeForMethodTypeSpecs(this_, c.body);
    }
    return;
  }
  if ((node is TryFinally)) {
    DartRestorer__scanNodeForMethodTypeSpecs(this_, node.body);
    DartRestorer__scanNodeForMethodTypeSpecs(this_, node.finalizer);
    return;
  }
  if ((node is SwitchStatement)) {
    DartRestorer__scanNodeForMethodTypeSpecs(this_, node.expression);
    for (final c in node.cases) {
      DartRestorer__scanNodeForMethodTypeSpecs(this_, c.body);
    }
    return;
  }
  if ((node is Let)) {
    DartRestorer__scanNodeForMethodTypeSpecs(this_, node.variable);
    DartRestorer__scanNodeForMethodTypeSpecs(this_, node.body);
    return;
  }
  if ((node is BlockExpression)) {
    DartRestorer__scanNodeForMethodTypeSpecs(this_, node.body);
    DartRestorer__scanNodeForMethodTypeSpecs(this_, node.value);
    return;
  }
  if ((node is StaticInvocation)) {
    for (final a in node.arguments.positional)     DartRestorer__scanNodeForMethodTypeSpecs(this_, a);
    for (final a in node.arguments.named)     DartRestorer__scanNodeForMethodTypeSpecs(this_, a.value);
    return;
  }
  if ((node is ConstructorInvocation)) {
    for (final a in node.arguments.positional)     DartRestorer__scanNodeForMethodTypeSpecs(this_, a);
    for (final a in node.arguments.named)     DartRestorer__scanNodeForMethodTypeSpecs(this_, a.value);
    return;
  }
  if ((node is InstanceGet)) {
    DartRestorer__scanNodeForMethodTypeSpecs(this_, node.receiver);
    return;
  }
  if ((node is InstanceSet)) {
    DartRestorer__scanNodeForMethodTypeSpecs(this_, node.receiver);
    DartRestorer__scanNodeForMethodTypeSpecs(this_, node.value);
    return;
  }
  if ((node is ConditionalExpression)) {
    DartRestorer__scanNodeForMethodTypeSpecs(this_, node.condition);
    DartRestorer__scanNodeForMethodTypeSpecs(this_, node.then);
    DartRestorer__scanNodeForMethodTypeSpecs(this_, node.otherwise);
    return;
  }
  if ((node is LogicalExpression)) {
    DartRestorer__scanNodeForMethodTypeSpecs(this_, node.left);
    DartRestorer__scanNodeForMethodTypeSpecs(this_, node.right);
    return;
  }
  if ((node is Not)) {
    DartRestorer__scanNodeForMethodTypeSpecs(this_, node.operand);
    return;
  }
  if ((node is StringConcatenation)) {
    for (final e in node.expressions)     DartRestorer__scanNodeForMethodTypeSpecs(this_, e);
    return;
  }
  if ((node is AsExpression)) {
    DartRestorer__scanNodeForMethodTypeSpecs(this_, node.operand);
    return;
  }
  if ((node is IsExpression)) {
    DartRestorer__scanNodeForMethodTypeSpecs(this_, node.operand);
    return;
  }
  if ((node is NullCheck)) {
    DartRestorer__scanNodeForMethodTypeSpecs(this_, node.operand);
    return;
  }
  if ((node is Throw)) {
    DartRestorer__scanNodeForMethodTypeSpecs(this_, node.expression);
    return;
  }
  if ((node is AwaitExpression)) {
    DartRestorer__scanNodeForMethodTypeSpecs(this_, node.operand);
    return;
  }
  if ((node is FunctionExpression)) {
    if (!((node.function.body == null)))     DartRestorer__scanNodeForMethodTypeSpecs(this_, node.function.body!);
    return;
  }
  if ((node is FunctionDeclaration)) {
    if (!((node.function.body == null)))     DartRestorer__scanNodeForMethodTypeSpecs(this_, node.function.body!);
    return;
  }
  if ((node is ListLiteral)) {
    for (final e in node.expressions)     DartRestorer__scanNodeForMethodTypeSpecs(this_, e);
    return;
  }
  if ((node is MapLiteral)) {
    for (final e in node.entries) {
      DartRestorer__scanNodeForMethodTypeSpecs(this_, e.key);
      DartRestorer__scanNodeForMethodTypeSpecs(this_, e.value);
    }
    return;
  }
  if ((node is SetLiteral)) {
    for (final e in node.expressions)     DartRestorer__scanNodeForMethodTypeSpecs(this_, e);
    return;
  }
  if ((node is FunctionInvocation)) {
    DartRestorer__scanNodeForMethodTypeSpecs(this_, node.receiver);
    for (final a in node.arguments.positional)     DartRestorer__scanNodeForMethodTypeSpecs(this_, a);
    for (final a in node.arguments.named)     DartRestorer__scanNodeForMethodTypeSpecs(this_, a.value);
    return;
  }
  if ((node is DynamicInvocation)) {
    DartRestorer__scanNodeForMethodTypeSpecs(this_, node.receiver);
    for (final a in node.arguments.positional)     DartRestorer__scanNodeForMethodTypeSpecs(this_, a);
    for (final a in node.arguments.named)     DartRestorer__scanNodeForMethodTypeSpecs(this_, a.value);
    return;
  }
  if ((node is SuperMethodInvocation)) {
    for (final a in node.arguments.positional)     DartRestorer__scanNodeForMethodTypeSpecs(this_, a);
    for (final a in node.arguments.named)     DartRestorer__scanNodeForMethodTypeSpecs(this_, a.value);
    return;
  }
}

void DartRestorer__collectVTableEntries(dynamic this__, Class cls, {String? overrideName = null}) {
  final this_ = this__ as DartRestorerValue;
  final String className = (overrideName ?? cls.name);
  final StaticList<_VTableEntryValue> entries = StaticList<_VTableEntryValue>.of([]);
  final String? parentName = this_._classHierarchy[className];
  if ((!((parentName == null)) && this_._classVTableEntries.containsKey(parentName))) {
    entries.addAll(this_._classVTableEntries[parentName]!);
  }
  for (final impl in cls.implementedTypes) {
    final String ifaceName = impl.classNode.name;
    if (this_._classVTableEntries.containsKey(ifaceName)) {
      for (final ifaceEntry in this_._classVTableEntries[ifaceName]!) {
        final bool alreadyExists = entries.any(ClosureEnv_anon_17(ifaceEntry));
        if (!(alreadyExists)) {
          entries.add(_VTableEntry_new(_VTableEntryValue(), name: ifaceEntry.name, kind: ifaceEntry.kind, staticFuncName: ifaceEntry.staticFuncName, signature: ifaceEntry.signature, declaringClassName: ifaceEntry.declaringClassName));
        }
      }
    }
  }
  for (final proc in cls.procedures)   do {
{
      if (proc.isStatic)       break;
      if (proc.isFactory)       break;
      if (proc.name.text.startsWith('_'))       break;
      StringBox methodName = StringBox(proc.name.text);
      final _VTableEntryValue entry = DartRestorer__buildVTableEntry(this_, cls, proc, methodName.value, className);
      final int existingIdx = entries.indexWhere(ClosureEnv_anon_18(methodName, entry));
      if ((existingIdx >= 0)) {
        final String existingDeclaringClass = (entries[existingIdx].declaringClassName ?? className);
        entries[existingIdx] = _VTableEntry_new(_VTableEntryValue(), name: entry.name, kind: entry.kind, staticFuncName: entry.staticFuncName, signature: entry.signature, proc: entry.proc, declaringClassName: existingDeclaringClass);
      }
 else {
        entries.add(_VTableEntry_new(_VTableEntryValue(), name: entry.name, kind: entry.kind, staticFuncName: entry.staticFuncName, signature: entry.signature, proc: entry.proc, declaringClassName: className));
      }
    }
  } while (false);
  this_._classVTableEntries[className] = entries;
}

_VTableEntryValue DartRestorer__buildVTableEntry(dynamic this__, Class cls, Procedure proc, String methodName, String? loweredName) {
  final this_ = this__ as DartRestorerValue;
  final String className = (loweredName ?? cls.name);
  late String kind;
  late String staticFuncName;
  late String signature;
  if (proc.isGetter) {
    kind = 'getter';
    staticFuncName = _DartRestorerBase__staticGetterName(this_, className, methodName);
    final String retType = _DartRestorerBase__restoreTypeForSignature(this_, proc.function.returnType);
    signature = '${retType} Function(${className}Value this_)';
  }
 else   if (proc.isSetter) {
    kind = 'setter';
    staticFuncName = _DartRestorerBase__staticSetterName(this_, className, methodName);
    final String paramType = (proc.function.positionalParameters.isNotEmpty ? _DartRestorerBase__restoreTypeForSignature(this_, proc.function.positionalParameters.first.type) : 'dynamic');
    signature = 'void Function(${className}Value this_, ${paramType} value)';
  }
 else   if (_DartRestorerBase__isOperatorName(this_, methodName)) {
    kind = 'operator';
    staticFuncName = _DartRestorerBase__staticMethodName(this_, className, methodName);
    final String retType = _DartRestorerBase__restoreTypeForSignature(this_, proc.function.returnType);
    final String paramTypes = proc.function.positionalParameters.map(ClosureEnv_anon_19(this_)).join(', ');
    final String paramPart = (paramTypes.isEmpty ? '${className}Value this_' : '${className}Value this_, ${paramTypes}');
    signature = '${retType} Function(${paramPart})';
  }
 else {
    kind = 'method';
    staticFuncName = _DartRestorerBase__staticMethodName(this_, className, methodName);
    final String retType = _DartRestorerBase__restoreTypeForSignature(this_, proc.function.returnType);
    final StaticList<String> paramTypes = StaticList<String>.of([]);
    for (final p in proc.function.positionalParameters) {
      paramTypes.add(_DartRestorerBase__restoreTypeForSignature(this_, p.type));
    }
    for (final p in proc.function.namedParameters) {
      paramTypes.add(_DartRestorerBase__restoreTypeForSignature(this_, p.type));
    }
    final String paramPart = (paramTypes.isEmpty ? '${className}Value this_' : '${className}Value this_, ${paramTypes.join(', ')}');
    signature = '${retType} Function(${paramPart})';
  }
  return _VTableEntry_new(_VTableEntryValue(), name: methodName, kind: kind, staticFuncName: staticFuncName, signature: signature, proc: proc);
}

void DartRestorer__restoreLibrary(dynamic this__, Library lib) {
  final this_ = this__ as DartRestorerValue;
  this_._pendingClosureDecls.clear();
  for (final td in lib.typedefs)   DartRestorer__restoreTypedef(this_, td);
  for (final cls in lib.classes) {
    if (cls.isMixinDeclaration) {
      DartRestorer__restoreMixin(this_, cls);
    }
 else {
      DartRestorer__restoreClass(this_, cls);
    }
  }
  for (final proc in lib.procedures) {
    _DartRestorerBase__pushClosureContext(this_, proc.name.text);
    DartRestorer__restoreProcedure(this_, proc);
    _DartRestorerBase__popClosureContext(this_);
  }
  for (final field in lib.fields)   DartRestorer__restoreField(this_, field, isTopLevel: true);
  if (this_._pendingTopLevelDecls.isNotEmpty) {
    this_._buf.write('// ---- Class-level shared vtables ----\n');
    for (final decl in this_._pendingTopLevelDecls) {
      this_._buf.write(decl);
    }
    this_._buf.write('\n');
  }
  this_._pendingTopLevelDecls.clear();
  this_._emittedSharedVTableClasses.clear();
  for (final decl in this_._pendingClosureDecls) {
    this_._buf.write(decl);
  }
  this_._pendingClosureDecls.clear();
}

void DartRestorer__emitRuntimeImport(dynamic this__) {
  final this_ = this__ as DartRestorerValue;
  this_._buf.write('import \'package:dart2cpp/restorer/runtime_classes.dart\';\n\n');
}

bool DartRestorer__isSyntheticMixinClass(dynamic this__, Class cls) {
  final this_ = this__ as DartRestorerValue;
  return cls.name.contains('&');
}


// mixin _TypeUtils → static functions for delegation
const StaticSet<String> _TypeUtils__dartKeywords = const {'this', 'super', 'new', 'null', 'true', 'false', 'void', 'var', 'final', 'const', 'return', 'if', 'else', 'for', 'while', 'do', 'switch', 'case', 'default', 'break', 'continue', 'try', 'catch', 'finally', 'throw', 'rethrow', 'class', 'extends', 'implements', 'with', 'mixin', 'enum', 'import', 'export', 'library', 'part', 'of', 'show', 'hide', 'as', 'abstract', 'static', 'dynamic', 'get', 'set', 'operator', 'typedef', 'is', 'in', 'assert', 'async', 'await', 'yield', 'sync', 'late', 'required', 'external', 'factory', 'covariant'};
const int _TypeUtils_kMaxArity = 16;
String? _TypeUtils__boxTypeNameFor(dynamic this__, DartType type) {
  final this_ = this__;
  final String? primitive = _DartRestorerBase__primitiveBoxName(this_, type);
  if (!((primitive == null)))   return primitive;
  if ((type is TypeParameterType)) {
    final String paramName = (type.parameter.name ?? 'T');
    final String? replacement = this_._activeTypeParamSubstitution[paramName];
    return 'ObjectBox<${(replacement ?? paramName)}>';
  }
  return null;
}

String _TypeUtils__restoreArgs(dynamic this__, Arguments args) {
  final this_ = this__;
  final StaticList<String> parts = StaticList<String>.of([]);
  for (final p in args.positional) {
    parts.add(_DartRestorerBase__restoreExpr(this_, p));
  }
  for (final n in args.named) {
    parts.add('${n.name}: ${_DartRestorerBase__restoreExpr(this_, n.value)}');
  }
  return parts.join(', ');
}

String _TypeUtils__restoreSupertype(dynamic this__, Supertype s) {
  final this_ = this__;
  final String name = s.classNode.name;
  if (s.typeArguments.isEmpty)   return name;
  final String args = s.typeArguments.map(ClosureEnv_anon_20(this_)).join(', ');
  return '${name}<${args}>';
}

String _TypeUtils__restoreType(dynamic this__, DartType type) {
  final this_ = this__;
  final bool nullable = (type.nullability == Nullability.nullable);
  final String suffix = (nullable ? '?' : '');
  if ((type is InterfaceType)) {
    final String rawName = type.classNode.name;
    late String name;
    if (((rawName == 'Future') || (rawName == '_Future'))) {
      name = 'Promise';
    }
 else     if ((((rawName == 'List') || (rawName == '_GrowableList')) || (rawName == '_List'))) {
      name = 'StaticList';
    }
 else     if (((((rawName == 'Map') || (rawName == '_Map')) || (rawName == 'LinkedHashMap')) || (rawName == '_InternalLinkedHashMap'))) {
      name = 'StaticMap';
    }
 else     if (((((rawName == 'Set') || (rawName == '_Set')) || (rawName == 'LinkedHashSet')) || (rawName == '_CompactLinkedHashSet'))) {
      name = 'StaticSet';
    }
 else     if ((rawName == 'Function')) {
      return 'dynamic';
    }
 else     if (_DartRestorerBase__isUserClass(this_, rawName)) {
      name = '${rawName}Value';
    }
 else {
      name = rawName;
    }
    if (type.typeArguments.isEmpty)     return '${name}${suffix}';
    final String args = type.typeArguments.map(ClosureEnv_anon_21(this_)).join(', ');
    return '${name}<${args}>${suffix}';
  }
  if ((type is FunctionType)) {
    return _TypeUtils__restoreFunctionTypeAsTypeFunction(this_, type, suffix);
  }
  if ((type is TypeParameterType)) {
    final String paramName = (type.parameter.name ?? 'T');
    final String? replacement = this_._activeTypeParamSubstitution[paramName];
    if (!((replacement == null))) {
      if ((this_._activeTypeParamTargets.isEmpty || this_._activeTypeParamTargets.contains(type.parameter))) {
        return '${replacement}${suffix}';
      }
    }
    return '${paramName}${suffix}';
  }
  if ((type is DynamicType))   return 'dynamic';
  if ((type is VoidType))   return 'void';
  if ((type is NeverType))   return 'Never${suffix}';
  if ((type is FutureOrType)) {
    return 'FutureOr<${_TypeUtils__restoreType(this_, type.typeArgument)}>${suffix}';
  }
  if ((type is RecordType)) {
    final StaticList<String> parts = StaticList<String>.of([]);
    for (final p in type.positional) {
      parts.add(_TypeUtils__restoreType(this_, p));
    }
    for (final n in type.named) {
      parts.add('${_TypeUtils__restoreType(this_, n.type)} ${n.name}');
    }
    return '(${parts.join(', ')})${suffix}';
  }
  return 'dynamic';
}

String _TypeUtils__cleanVarName(dynamic this__, String name) {
  final this_ = this__;
  if (this_._cleanedNames.containsKey(name))   return this_._cleanedNames[name]!;
  late String cleaned;
  if (name.startsWith(':')) {
    cleaned = name.substring(1);
  }
 else   if (name.startsWith('#')) {
    cleaned = name.substring(1);
  }
 else   if (name.contains('#')) {
    final StaticList<String> parts = name.split('#');
    final String lastPart = parts.last;
    if ((lastPart.isEmpty || RegExp('^[0-9]').hasMatch(lastPart))) {
      cleaned = '_v${(() { final _let14 = this_._varCounter; return (() { final _let15 = this_._varCounter = (_let14 + 1); return _let14; })(); })()}';
    }
 else {
      cleaned = '_v${(() { final _let16 = this_._varCounter; return (() { final _let17 = this_._varCounter = (_let16 + 1); return _let16; })(); })()}_${lastPart}';
    }
  }
 else {
    cleaned = name;
  }
  if ((cleaned.isNotEmpty && RegExp('^[0-9]').hasMatch(cleaned))) {
    cleaned = '_v${(() { final _let18 = this_._varCounter; return (() { final _let19 = this_._varCounter = (_let18 + 1); return _let18; })(); })()}';
  }
  cleaned = cleaned.replaceAll(RegExp('[^a-zA-Z0-9_]'), '_');
  if (const {'this', 'super', 'new', 'null', 'true', 'false', 'void', 'var', 'final', 'const', 'return', 'if', 'else', 'for', 'while', 'do', 'switch', 'case', 'default', 'break', 'continue', 'try', 'catch', 'finally', 'throw', 'rethrow', 'class', 'extends', 'implements', 'with', 'mixin', 'enum', 'import', 'export', 'library', 'part', 'of', 'show', 'hide', 'as', 'abstract', 'static', 'dynamic', 'get', 'set', 'operator', 'typedef', 'is', 'in', 'assert', 'async', 'await', 'yield', 'sync', 'late', 'required', 'external', 'factory', 'covariant'}.contains(cleaned)) {
    cleaned = '${cleaned}_';
  }
  this_._cleanedNames[name] = cleaned;
  return cleaned;
}

String _TypeUtils__restoreFunctionTypeAsTypeFunction(dynamic this__, FunctionType type, String suffix) {
  final this_ = this__;
  final String ret = _TypeUtils__restoreType(this_, type.returnType);
  final bool hasNamed = type.namedParameters.isNotEmpty;
  final StaticList<DartType> positional = type.positionalParameters;
  final int required_ = type.requiredParameterCount;
  final bool hasOptionalPositional = (positional.length > required_);
  if (((hasNamed || hasOptionalPositional) || (positional.length > 16))) {
    return 'TypeFunction<${ret}>${suffix}';
  }
  final int arity = positional.length;
  final StaticList<String> paramTexts = (() {   final StaticList<String> _v20 = StaticList<String>.of([]);
  for (final p in positional)   _v20.add(_TypeUtils__restoreType(this_, p));
 return _v20; })();
  final String args = (() {   final StaticList<String> _v21 = StaticList<String>.of([ret]);
  _v21.addAll(paramTexts);
 return _v21; })().join(', ');
  return 'TypeFunction${arity}<${args}>${suffix}';
}

bool _TypeUtils__isBinaryOp(dynamic this__, String name) {
  final this_ = this__;
  return const {'+', '-', '*', '/', '%', '~/', '>', '<', '>=', '<=', '&', '|', '^', '<<', '>>'}.contains(name);
}

bool _TypeUtils__needsCovariant(dynamic this__, VariableDeclaration param, FunctionNode func, Procedure? proc) {
  final this_ = this__;
  return param.isCovariantByDeclaration;
}

String _TypeUtils__resolveRealSuperclass(dynamic this__, Class cls) {
  final this_ = this__;
  if (!(cls.name.contains('&')))   return cls.name;
  if (!((cls.supertype == null))) {
    return _TypeUtils__resolveRealSuperclass(this_, cls.supertype!.classNode);
  }
  return 'Object';
}

StaticList<String> _TypeUtils__collectMixins(dynamic this__, Class cls) {
  final this_ = this__;
  if (!(cls.name.contains('&')))   return StaticList<String>.of([]);
  final StaticList<String> mixins = StaticList<String>.of([]);
  if (!((cls.supertype == null))) {
    mixins.addAll(_TypeUtils__collectMixins(this_, cls.supertype!.classNode));
  }
  for (final impl in cls.implementedTypes) {
    mixins.add(_TypeUtils__restoreSupertype(this_, impl));
  }
  return mixins;
}


// mixin _ConstantRestorer → static functions for delegation
String _ConstantRestorer__restoreConstant(dynamic this__, Constant c) {
  final this_ = this__;
  if ((c is IntConstant))   return '${c.value}';
  if ((c is DoubleConstant)) {
    if ((c.value == c.value.toInt().toDouble()))     return '${c.value.toStringAsFixed(1)}';
    return '${c.value}';
  }
  if ((c is BoolConstant))   return '${c.value}';
  if ((c is StringConstant)) {
    final String escaped = c.value.replaceAll('\\', '\\\\').replaceAll('\'', '\\\'').replaceAll('\n', '\\n');
    return '\'${escaped}\'';
  }
  if ((c is NullConstant))   return 'null';
  if ((c is ListConstant)) {
    final String items = c.entries.map(ClosureEnv_anon_22(this_)).join(', ');
    return 'const [${items}]';
  }
  if ((c is SetConstant)) {
    final String items = c.entries.map(ClosureEnv_anon_23(this_)).join(', ');
    return 'const {${items}}';
  }
  if ((c is MapConstant)) {
    final String entries = c.entries.map(ClosureEnv_anon_24(this_)).join(', ');
    return 'const {${entries}}';
  }
  if ((c is InstanceConstant)) {
    final String className = c.classNode.name;
    if ((className == 'override'))     return '@override';
    if ((className == 'pragma'))     return '@pragma';
    if ((className == 'Duration')) {
      return 'Duration()';
    }
    if (_ConstantRestorer__isEnumConstant(this_, c)) {
      return _ConstantRestorer__restoreEnumConstant(this_, c);
    }
    return _ConstantRestorer__restoreInstanceConstant(this_, c);
  }
  if ((c is TypeLiteralConstant))   return _TypeUtils__restoreType(this_, c.type);
  if ((c is SymbolConstant))   return '#${c.name}';
  if ((c is RecordConstant)) {
    final StaticList<String> parts = StaticList<String>.of([]);
    for (final p in c.positional) {
      parts.add(_ConstantRestorer__restoreConstant(this_, p));
    }
    for (final entry in c.named.entries) {
      parts.add('${entry.key}: ${_ConstantRestorer__restoreConstant(this_, entry.value)}');
    }
    return 'const (${parts.join(', ')})';
  }
  try {
    final dynamic target = (c as dynamic).target;
    if ((target is Procedure)) {
      final String name = target.name.text;
      if (!((target.enclosingClass == null))) {
        final String className = target.enclosingClass!.name;
        if (_DartRestorerBase__isUserClass(this_, className)) {
          return '${className}_${name}';
        }
        return '${className}.${name}';
      }
      return name;
    }
    if ((target is Constructor)) {
      final String className = target.enclosingClass.name;
      final String ctorName = target.name.text;
      if (_DartRestorerBase__isUserClass(this_, className)) {
        return (ctorName.isEmpty ? '${className}_new' : '${className}_new_${ctorName}');
      }
      return (ctorName.isEmpty ? className : '${className}.${ctorName}');
    }
  }
 catch (_) {
  }
  try {
    final dynamic proc = (c as dynamic).procedure;
    if ((proc is Procedure)) {
      final String name = proc.name.text;
      if (!((proc.enclosingClass == null))) {
        return '${proc.enclosingClass!.name}.${name}';
      }
      return name;
    }
  }
 catch (_) {
  }
  return '/* const ${c.runtimeType} */';
}

String _ConstantRestorer__restoreInstanceConstant(dynamic this__, InstanceConstant c) {
  final this_ = this__;
  final Class cls = c.classNode;
  final String className = cls.name;
  if (_DartRestorerBase__isUserClass(this_, className)) {
    return _ConstantRestorer__restoreInstanceConstantLowered(this_, c);
  }
  final StaticMap<String, Constant> fieldValues = StaticMap<String, Constant>.of({});
  for (final entry in c.fieldValues.entries) {
    fieldValues[entry.key.asField.name.text] = entry.value;
  }
  Constructor? bestCtor;
  int bestScore = (-1);
  for (final ctor in cls.constructors)   do {
{
      if (!(ctor.isConst))       break;
      final int score = _ConstantRestorer__matchConstructor(this_, ctor, fieldValues);
      if ((score > bestScore)) {
        bestScore = score;
        bestCtor = ctor;
      }
    }
  } while (false);
  if (!((bestCtor == null))) {
    return _ConstantRestorer__buildConstantCtorCall(this_, className, bestCtor, fieldValues, c.typeArguments);
  }
  final String fields = c.fieldValues.entries.map(ClosureEnv_anon_25(this_)).join(', ');
  return 'const ${className}(${fields})';
}

String _ConstantRestorer__restoreInstanceConstantLowered(dynamic this__, InstanceConstant c) {
  final this_ = this__;
  final String className = c.classNode.name;
  final Class cls = c.classNode;
  final StaticMap<String, Constant> fieldValues = StaticMap<String, Constant>.of({});
  for (final entry in c.fieldValues.entries) {
    fieldValues[entry.key.asField.name.text] = entry.value;
  }
  Constructor? bestCtor;
  int bestScore = (-1);
  for (final ctor in cls.constructors)   do {
{
      if (!(ctor.isConst))       break;
      final int score = _ConstantRestorer__matchConstructor(this_, ctor, fieldValues);
      if ((score > bestScore)) {
        bestScore = score;
        bestCtor = ctor;
      }
    }
  } while (false);
  if (!((bestCtor == null))) {
    final String ctorName = bestCtor.name.text;
    final String funcName = (ctorName.isEmpty ? '${className}_new' : '${className}_new_${ctorName}');
    final StaticMap<String, String> paramToField = StaticMap<String, String>.of({});
    for (final init in bestCtor.initializers) {
      if (((init is FieldInitializer) && (init.value is VariableGet))) {
        final VariableGet varGet = (init.value as VariableGet);
        final String? paramName = varGet.variable.name;
        if (!((paramName == null))) {
          paramToField[paramName] = init.field.name.text;
        }
      }
    }
    final StaticList<String> argParts = StaticList<String>.of([]);
    for (final param in bestCtor.function.positionalParameters) {
      final String paramName = (param.name ?? '');
      final String fieldName = (paramToField[paramName] ?? paramName);
      if (fieldValues.containsKey(fieldName)) {
        argParts.add(_ConstantRestorer__restoreConstant(this_, fieldValues[fieldName]!));
      }
    }
    for (final param in bestCtor.function.namedParameters)     do {
{
        final String paramName = (param.name ?? '');
        final String fieldName = (paramToField[paramName] ?? paramName);
        if (fieldValues.containsKey(fieldName)) {
          final Constant value = fieldValues[fieldName]!;
          if ((!((param.initializer == null)) && _ConstantRestorer__isConstantMatchingDefault(this_, value, param.initializer!))) {
            break;
          }
          argParts.add('${paramName}: ${_ConstantRestorer__restoreConstant(this_, value)}');
        }
      }
    } while (false);
    final String argsStr = argParts.join(', ');
    final String typeArgs = (c.typeArguments.isNotEmpty ? '<${c.typeArguments.map(/* unknown: InstanceTearOff */).join(', ')}>' : '');
    final String valueType = '${className}Value${typeArgs}';
    return (argsStr.isEmpty ? '${funcName}${typeArgs}(${valueType}())' : '${funcName}${typeArgs}(${valueType}(), ${argsStr})');
  }
  final String fields = c.fieldValues.entries.map(ClosureEnv_anon_26(this_)).join(', ');
  final String typeArgs = (c.typeArguments.isNotEmpty ? '<${c.typeArguments.map(/* unknown: InstanceTearOff */).join(', ')}>' : '');
  final String valueType = '${className}Value${typeArgs}';
  return (fields.isEmpty ? '${className}_new(${valueType}())' : '${className}_new(${valueType}(), ${fields})');
}

int _ConstantRestorer__matchConstructor(dynamic this__, Constructor ctor, StaticMap<String, Constant> fieldValues) {
  final this_ = this__;
  final StaticMap<String, String> paramToField = StaticMap<String, String>.of({});
  for (final init in ctor.initializers) {
    if (((init is FieldInitializer) && (init.value is VariableGet))) {
      final VariableGet varGet = (init.value as VariableGet);
      final String? paramName = varGet.variable.name;
      if (!((paramName == null))) {
        paramToField[paramName] = init.field.name.text;
      }
    }
  }
  int score = 0;
  final FunctionNode func = ctor.function;
  for (final param in func.positionalParameters) {
    final String paramName = (param.name ?? '');
    final String fieldName = (paramToField[paramName] ?? paramName);
    if (fieldValues.containsKey(fieldName)) {
      final Constant value = fieldValues[fieldName]!;
      if (((value is NullConstant) && !((param.type.nullability == Nullability.nullable)))) {
        return (-1);
      }
      score = (score + 1);
    }
 else     if (((param.initializer == null) && !(param.isRequired))) {
      return (-1);
    }
  }
  return score;
}

String _ConstantRestorer__buildConstantCtorCall(dynamic this__, String className, Constructor ctor, StaticMap<String, Constant> fieldValues, StaticList<DartType> typeArguments) {
  final this_ = this__;
  final String ctorName = ctor.name.text;
  final FunctionNode func = ctor.function;
  final StaticList<String> argParts = StaticList<String>.of([]);
  final StaticMap<String, String> paramToField = StaticMap<String, String>.of({});
  for (final init in ctor.initializers) {
    if (((init is FieldInitializer) && (init.value is VariableGet))) {
      final VariableGet varGet = (init.value as VariableGet);
      final String? paramName = varGet.variable.name;
      if (!((paramName == null))) {
        paramToField[paramName] = init.field.name.text;
      }
    }
  }
  for (final param in func.positionalParameters) {
    final String paramName = (param.name ?? '');
    final String fieldName = (paramToField[paramName] ?? paramName);
    if (fieldValues.containsKey(fieldName)) {
      argParts.add(_ConstantRestorer__restoreConstant(this_, fieldValues[fieldName]!));
    }
  }
  for (final param in func.namedParameters)   do {
{
      final String paramName = (param.name ?? '');
      final String fieldName = (paramToField[paramName] ?? paramName);
      if (fieldValues.containsKey(fieldName)) {
        final Constant value = fieldValues[fieldName]!;
        if ((!((param.initializer == null)) && _ConstantRestorer__isConstantMatchingDefault(this_, value, param.initializer!))) {
          break;
        }
        argParts.add('${paramName}: ${_ConstantRestorer__restoreConstant(this_, value)}');
      }
    }
  } while (false);
  final StaticList<DartType> typeArgs = StaticList.of(typeArguments.where(ClosureEnv_anon_27()).toList());
  final String typeArgStr = (typeArgs.isNotEmpty ? '<${typeArgs.map(ClosureEnv_anon_28(this_)).join(', ')}>' : '');
  final String argsStr = argParts.join(', ');
  if (ctorName.isEmpty) {
    return 'const ${className}${typeArgStr}(${argsStr})';
  }
  return 'const ${className}${typeArgStr}.${ctorName}(${argsStr})';
}

bool _ConstantRestorer__isConstantMatchingDefault(dynamic this__, Constant value, Expression defaultExpr) {
  final this_ = this__;
  if (((defaultExpr is IntLiteral) && (value is IntConstant))) {
    return (defaultExpr.value == value.value);
  }
  if (((defaultExpr is DoubleLiteral) && (value is DoubleConstant))) {
    return (defaultExpr.value == value.value);
  }
  if (((defaultExpr is BoolLiteral) && (value is BoolConstant))) {
    return (defaultExpr.value == value.value);
  }
  if (((defaultExpr is StringLiteral) && (value is StringConstant))) {
    return (defaultExpr.value == value.value);
  }
  if (((defaultExpr is NullLiteral) && (value is NullConstant))) {
    return true;
  }
  return false;
}

bool _ConstantRestorer__isEnumConstant(dynamic this__, InstanceConstant c) {
  final this_ = this__;
  final Supertype? supertype = c.classNode.supertype;
  if ((supertype == null))   return false;
  return (supertype.classNode.name == '_Enum');
}

String _ConstantRestorer__restoreEnumConstant(dynamic this__, InstanceConstant c) {
  final this_ = this__;
  final String className = c.classNode.name;
  for (final field in c.classNode.fields)   do {
{
      if ((!(field.isStatic) || !(field.isConst)))       break;
      if ((field.name.text == 'values'))       break;
      if ((field.initializer is ConstantExpression)) {
        final Constant fieldConst = (field.initializer as ConstantExpression).constant;
        if ((fieldConst == c)) {
          return '${className}.${field.name.text}';
        }
      }
    }
  } while (false);
  for (final entry in c.fieldValues.entries) {
    final String fieldName = entry.key.asField.name.text;
    if (((fieldName == '_name') && (entry.value is StringConstant))) {
      final String valueName = (entry.value as StringConstant).value;
      return '${className}.${valueName}';
    }
  }
  return '${className}.unknown';
}


// mixin _ExpressionRestorer → static functions for delegation
const String _ExpressionRestorer__thisParamType = 'dynamic';
String _ExpressionRestorer__restoreExpr(dynamic this__, Expression expr) {
  final this_ = this__;
  if ((expr is VariableGet))   return _ExpressionRestorer__restoreVarGet(this_, expr);
  if ((expr is VariableSet))   return _ExpressionRestorer__restoreVarSet(this_, expr);
  if ((expr is InstanceGet))   return _ExpressionRestorer__restoreInstanceGet(this_, expr);
  if ((expr is InstanceSet))   return _ExpressionRestorer__restoreInstanceSet(this_, expr);
  if ((expr is InstanceInvocation))   return _ExpressionRestorer__restoreInstanceInvocation(this_, expr);
  if ((expr is FunctionInvocation))   return _ExpressionRestorer__restoreFunctionInvocation(this_, expr);
  if ((expr is DynamicInvocation))   return _ExpressionRestorer__restoreDynamicInvocation(this_, expr);
  if ((expr is DynamicGet))   return '${_ExpressionRestorer__restoreExpr(this_, expr.receiver)}.${expr.name.text}';
  if ((expr is DynamicSet)) {
    final String recv = _ExpressionRestorer__restoreExpr(this_, expr.receiver);
    final String fieldName = expr.name.text;
    final String value = _ExpressionRestorer__restoreExpr(this_, expr.value);
    final bool insideMixin = (!((this_._currentClass == null)) && _DartRestorerBase__isMixinName(this_, this_._currentClass!.name));
    final bool isThisReceiver = ((expr.receiver is ThisExpression) || ((expr.receiver is VariableGet) && ((expr.receiver as VariableGet).variable.name == this_._thisReplacementName)));
    if (((insideMixin && this_._insideMethodBody) && isThisReceiver)) {
      if (!(fieldName.startsWith('_'))) {
        return '(${recv}.vptr[\'set_${fieldName}\'] as TypeFunction2<void, dynamic, dynamic>)(${recv}, ${value})';
      }
    }
    return '${recv}.${fieldName} = ${value}';
  }
  if ((expr is EqualsNull))   return '(${_ExpressionRestorer__restoreExpr(this_, expr.expression)} == null)';
  if ((expr is EqualsCall))   return _ExpressionRestorer__restoreEqualsCall(this_, expr);
  if ((expr is StaticInvocation))   return _ExpressionRestorer__restoreStaticInvocation(this_, expr);
  if ((expr is StaticGet))   return _ExpressionRestorer__restoreStaticGet(this_, expr);
  if ((expr is StaticSet))   return _ExpressionRestorer__restoreStaticSet(this_, expr);
  if ((expr is ConstructorInvocation))   return _ExpressionRestorer__restoreConstructorInvocation(this_, expr);
  if ((expr is ConditionalExpression))   return _ExpressionRestorer__restoreConditional(this_, expr);
  if ((expr is LogicalExpression))   return _ExpressionRestorer__restoreLogical(this_, expr);
  if ((expr is Not))   return _ExpressionRestorer__restoreNot(this_, expr);
  if ((expr is StringConcatenation))   return _ExpressionRestorer__restoreStringConcat(this_, expr);
  if ((expr is StringLiteral))   return _ExpressionRestorer__restoreStringLiteral(this_, expr);
  if ((expr is IntLiteral))   return '${expr.value}';
  if ((expr is DoubleLiteral))   return _ExpressionRestorer__restoreDoubleLiteral(this_, expr);
  if ((expr is BoolLiteral))   return '${expr.value}';
  if ((expr is NullLiteral))   return 'null';
  if ((expr is SymbolLiteral))   return '#${expr.value}';
  if ((expr is TypeLiteral))   return _TypeUtils__restoreType(this_, expr.type);
  if ((expr is ListLiteral))   return _ExpressionRestorer__restoreListLiteral(this_, expr);
  if ((expr is MapLiteral))   return _ExpressionRestorer__restoreMapLiteral(this_, expr);
  if ((expr is SetLiteral))   return _ExpressionRestorer__restoreSetLiteral(this_, expr);
  if ((expr is IsExpression))   return _ExpressionRestorer__restoreIsExpr(this_, expr);
  if ((expr is AsExpression))   return _ExpressionRestorer__restoreAsExpr(this_, expr);
  if ((expr is Let))   return _ExpressionRestorer__restoreLet(this_, expr);
  if ((expr is BlockExpression))   return _ExpressionRestorer__restoreBlockExpr(this_, expr);
  if ((expr is FunctionExpression))   return _ExpressionRestorer__restoreFuncExpr(this_, expr);
  if ((expr is Throw))   return 'throw ${_ExpressionRestorer__restoreExpr(this_, expr.expression)}';
  if ((expr is Rethrow))   return 'rethrow';
  if ((expr is ThisExpression)) {
    if (this_._thisIsCapturedInEnv) {
      return 'env.${this_._thisReplacementName}';
    }
    if (((this_._insideMethodBody && !((this_._currentClass == null))) && _DartRestorerBase__needsLowering(this_, this_._currentClass!.name))) {
      return this_._thisReplacementName;
    }
    return 'this';
  }
  if ((expr is SuperPropertyGet)) {
    if (((this_._insideMethodBody && !((this_._currentClass == null))) && _DartRestorerBase__needsLowering(this_, this_._currentClass!.name))) {
      final String fieldName = expr.name.text;
      final Member target = expr.interfaceTarget;
      if (((target is Procedure) && target.isGetter)) {
        String? parentName = _DartRestorerBase__getParentClassName(this_, this_._currentClass!.name);
        while ((!((parentName == null)) && this_._syntheticLoweredNames.contains(parentName))) {
          parentName = _DartRestorerBase__getParentClassName(this_, parentName);
        }
        if ((!((parentName == null)) && _DartRestorerBase__needsLowering(this_, parentName))) {
          return '${parentName}_get_${fieldName}(${this_._thisReplacementName})';
        }
      }
      return '${this_._thisReplacementName}.${fieldName}';
    }
    return 'super.${expr.name.text}';
  }
  if ((expr is SuperMethodInvocation)) {
    if ((!((this_._currentClass == null)) && _DartRestorerBase__needsLowering(this_, this_._currentClass!.name))) {
      String? parentName = _DartRestorerBase__getParentClassName(this_, this_._currentClass!.name);
      while ((!((parentName == null)) && this_._syntheticLoweredNames.contains(parentName))) {
        parentName = _DartRestorerBase__getParentClassName(this_, parentName);
      }
      if ((!((parentName == null)) && _DartRestorerBase__needsLowering(this_, parentName))) {
        final String args = _TypeUtils__restoreArgs(this_, expr.arguments);
        final String staticName = _DartRestorerBase__staticMethodName(this_, parentName, expr.name.text);
        final String selfArg = (this_._insideMethodBody ? this_._thisReplacementName : 'this');
        final StaticList<DartType> typeArgs = expr.arguments.types;
        late String typeArgStr;
        if (typeArgs.isNotEmpty) {
          typeArgStr = '<${typeArgs.map(ClosureEnv_anon_29(this_)).join(', ')}>';
        }
 else         if (this_._currentClass!.typeParameters.isNotEmpty) {
          typeArgStr = '<${this_._currentClass!.typeParameters.map(ClosureEnv_anon_30()).join(', ')}>';
        }
 else {
          typeArgStr = '';
        }
        if (args.isEmpty) {
          return '${staticName}${typeArgStr}(${selfArg})';
        }
        return '${staticName}${typeArgStr}(${selfArg}, ${args})';
      }
    }
    return 'super.${expr.name.text}(${_TypeUtils__restoreArgs(this_, expr.arguments)})';
  }
  if ((expr is RecordLiteral))   return _ExpressionRestorer__restoreRecordLiteral(this_, expr);
  if ((expr is RecordIndexGet))   return _ExpressionRestorer__restoreRecordIndexGet(this_, expr);
  if ((expr is RecordNameGet))   return _ExpressionRestorer__restoreRecordNameGet(this_, expr);
  if ((expr is ConstantExpression))   return _ConstantRestorer__restoreConstant(this_, expr.constant);
  if ((expr is InstanceGetterInvocation)) {
    final String recv = _ExpressionRestorer__restoreExpr(this_, expr.receiver);
    final String methodName = expr.name.text;
    final String? receiverClassName = _ExpressionRestorer__getReceiverClassNameFromReceiver(this_, expr.receiver, expr.interfaceTarget);
    if ((!((receiverClassName == null)) && (_DartRestorerBase__isUserClass(this_, receiverClassName) || _DartRestorerBase__isMixinName(this_, receiverClassName)))) {
      final String args = _TypeUtils__restoreArgs(this_, expr.arguments);
      final Member target = expr.interfaceTarget;
      if ((target is Procedure)) {
        final String sig = _ExpressionRestorer__buildPreciseFuncSignature(this_, target, receiverClassName: receiverClassName, receiver: expr.receiver);
        if (args.isEmpty) {
          return '(${recv}.vptr[\'${methodName}\'] as ${sig})(${recv})';
        }
        return '(${recv}.vptr[\'${methodName}\'] as ${sig})(${recv}, ${args})';
      }
      if (args.isEmpty) {
        return '${recv}.${methodName}()';
      }
      return '${recv}.${methodName}(${args})';
    }
    return '${recv}.${methodName}(${_TypeUtils__restoreArgs(this_, expr.arguments)})';
  }
  if ((expr is AbstractSuperPropertyGet)) {
    if (((this_._insideMethodBody && !((this_._currentClass == null))) && _DartRestorerBase__needsLowering(this_, this_._currentClass!.name))) {
      final String fieldName = expr.name.text;
      String? parentName = _DartRestorerBase__getParentClassName(this_, this_._currentClass!.name);
      while ((!((parentName == null)) && this_._syntheticLoweredNames.contains(parentName))) {
        parentName = _DartRestorerBase__getParentClassName(this_, parentName);
      }
      if ((!((parentName == null)) && _DartRestorerBase__needsLowering(this_, parentName))) {
        final StaticList<_VTableEntryValue>? parentEntries = this_._classVTableEntries[parentName];
        if ((!((parentEntries == null)) && parentEntries.any(ClosureEnv_anon_31(fieldName)))) {
          return '${parentName}_get_${fieldName}(${this_._thisReplacementName})';
        }
      }
      return '${this_._thisReplacementName}.${fieldName}';
    }
    return 'super.${expr.name.text}';
  }
  if ((expr is SuperPropertySet)) {
    if (((this_._insideMethodBody && !((this_._currentClass == null))) && _DartRestorerBase__needsLowering(this_, this_._currentClass!.name))) {
      return '${this_._thisReplacementName}.${expr.name.text} = ${_ExpressionRestorer__restoreExpr(this_, expr.value)}';
    }
    return 'super.${expr.name.text} = ${_ExpressionRestorer__restoreExpr(this_, expr.value)}';
  }
  if ((expr is InvalidExpression))   return '/* invalid */';
  if ((expr is NullCheck))   return '${_ExpressionRestorer__restoreExpr(this_, expr.operand)}!';
  if ((expr is AwaitExpression))   return 'smAwait(${_ExpressionRestorer__restoreExpr(this_, expr.operand)})';
  if ((expr is CheckLibraryIsLoaded))   return 'true';
  if ((expr is LoadLibrary))   return '${expr.import.name}';
  if ((expr is LocalFunctionInvocation)) {
    final String funcName = (expr.variable.name ?? '_localFunc');
    final String args = _TypeUtils__restoreArgs(this_, expr.arguments);
    return '${funcName}(${args})';
  }
  return '/* unknown: ${expr.runtimeType} */';
}

String _ExpressionRestorer__restoreVarGet(dynamic this__, VariableGet expr) {
  final this_ = this__;
  if ((expr.variable.name == null)) {
    expr.variable.name = '_v${(() { final _let34 = this_._varCounter; return (() { final _let35 = this_._varCounter = (_let34 + 1); return _let34; })(); })()}';
  }
  final String name = _TypeUtils__cleanVarName(this_, expr.variable.name!);
  final String? prefix = this_._capturedVarEnvPrefix[expr.variable];
  final bool boxed = this_._boxedVars.contains(expr.variable);
  final String suffix = (boxed ? '.value' : '');
  if (!((prefix == null)))   return '${prefix}${name}${suffix}';
  return '${name}${suffix}';
}

String _ExpressionRestorer__restoreVarSet(dynamic this__, VariableSet expr) {
  final this_ = this__;
  if ((expr.variable.name == null)) {
    expr.variable.name = '_v${(() { final _let36 = this_._varCounter; return (() { final _let37 = this_._varCounter = (_let36 + 1); return _let36; })(); })()}';
  }
  final String name = _TypeUtils__cleanVarName(this_, expr.variable.name!);
  final String? prefix = this_._capturedVarEnvPrefix[expr.variable];
  final bool boxed = this_._boxedVars.contains(expr.variable);
  final String suffix = (boxed ? '.value' : '');
  final String base = (!((prefix == null)) ? '${prefix}${name}' : name);
  return '${base}${suffix} = ${_ExpressionRestorer__restoreExpr(this_, expr.value)}';
}

String _ExpressionRestorer__restoreInstanceGet(dynamic this__, InstanceGet expr) {
  final this_ = this__;
  final String recv = _ExpressionRestorer__restoreExpr(this_, expr.receiver);
  final String fieldName = expr.name.text;
  final String? receiverClassName = _ExpressionRestorer__getReceiverClassNameFromReceiver(this_, expr.receiver, expr.interfaceTarget);
  if (fieldName.startsWith('_')) {
    return '${recv}.${fieldName}';
  }
  if ((!((receiverClassName == null)) && (_DartRestorerBase__isUserClass(this_, receiverClassName) || _DartRestorerBase__isMixinName(this_, receiverClassName)))) {
    final Member target = expr.interfaceTarget;
    if (((target is Procedure) && target.isGetter)) {
      final Class? declClass = target.enclosingClass;
      final String? declClassName = (!((declClass == null)) ? _ExpressionRestorer__getActualClassName(this_, declClass.name) : null);
      if (((!((declClassName == null)) && !(_DartRestorerBase__isUserClass(this_, declClassName))) && !(_DartRestorerBase__isMixinName(this_, declClassName)))) {
        return '${recv}.${fieldName}';
      }
      final String returnType = _DartRestorerBase__restoreTypeForSignature(this_, expr.resultType);
      final String sig = _ExpressionRestorer__emitFuncSig(this_, returnType, StaticList<String>.of(['dynamic']));
      return '(${recv}.vptr[\'get_${fieldName}\'] as ${sig})(${recv})';
    }
  }
  if ((!((receiverClassName == null)) && _DartRestorerBase__isEnumName(this_, receiverClassName))) {
    final Member target = expr.interfaceTarget;
    if (((target is Procedure) && target.isGetter)) {
      final String declClassName = (target.enclosingClass?.name ?? '');
      if ((((((((fieldName == 'name') || (fieldName == 'index')) || (fieldName == 'hashCode')) || (declClassName == '_Enum')) || (declClassName == 'Enum')) || (declClassName == '_EnumName')) || (declClassName == 'EnumName'))) {
        return '${recv}.${fieldName}';
      }
      return '${receiverClassName}_get_${fieldName}(${recv})';
    }
  }
  return '${recv}.${fieldName}';
}

String _ExpressionRestorer__restoreInstanceSet(dynamic this__, InstanceSet expr) {
  final this_ = this__;
  final String recv = _ExpressionRestorer__restoreExpr(this_, expr.receiver);
  final String fieldName = expr.name.text;
  final String? receiverClassName = _ExpressionRestorer__getReceiverClassNameFromReceiver(this_, expr.receiver, expr.interfaceTarget);
  if (fieldName.startsWith('_')) {
    return '${recv}.${fieldName} = ${_ExpressionRestorer__restoreExpr(this_, expr.value)}';
  }
  if ((!((receiverClassName == null)) && (_DartRestorerBase__isUserClass(this_, receiverClassName) || _DartRestorerBase__isMixinName(this_, receiverClassName)))) {
    final Member target = expr.interfaceTarget;
    if (((target is Procedure) && target.isSetter)) {
      final String sig = _ExpressionRestorer__buildPreciseFuncSignature(this_, target, receiverClassName: receiverClassName, receiver: expr.receiver);
      return '(${recv}.vptr[\'set_${fieldName}\'] as ${sig})(${recv}, ${_ExpressionRestorer__restoreExpr(this_, expr.value)})';
    }
  }
  if ((!((receiverClassName == null)) && _DartRestorerBase__isEnumName(this_, receiverClassName))) {
    final Member target = expr.interfaceTarget;
    if (((target is Procedure) && target.isSetter)) {
      return '${receiverClassName}_set_${fieldName}(${recv}, ${_ExpressionRestorer__restoreExpr(this_, expr.value)})';
    }
  }
  return '${recv}.${fieldName} = ${_ExpressionRestorer__restoreExpr(this_, expr.value)}';
}

String _ExpressionRestorer__restoreInstanceInvocation(dynamic this__, InstanceInvocation expr) {
  final this_ = this__;
  final String recv = _ExpressionRestorer__restoreExpr(this_, expr.receiver);
  final String name = expr.name.text;
  final String? receiverClassName = _ExpressionRestorer__getReceiverClassNameFromReceiver(this_, expr.receiver, expr.interfaceTarget);
  if ((!((receiverClassName == null)) && (_DartRestorerBase__isUserClass(this_, receiverClassName) || _DartRestorerBase__isMixinName(this_, receiverClassName)))) {
    final String returnType = _DartRestorerBase__restoreTypeForSignature(this_, expr.functionType.returnType);
    final Class? enclosingClass = expr.interfaceTarget.enclosingClass;
    final String? actualClassName = (!((enclosingClass == null)) ? _ExpressionRestorer__getActualClassName(this_, enclosingClass.name) : null);
    if (((!((actualClassName == null)) && !(_DartRestorerBase__isUserClass(this_, actualClassName))) && !(_DartRestorerBase__isMixinName(this_, actualClassName)))) {
      final String args = _TypeUtils__restoreArgs(this_, expr.arguments);
      if (args.isEmpty)       return '${recv}.${name}()';
      return '${recv}.${name}(${args})';
    }
    if ((((((name.startsWith('_') && !(_TypeUtils__isBinaryOp(this_, name))) && !((name == 'unary-'))) && !((name == '~'))) && !((name == '[]'))) && !((name == '[]=')))) {
      String resolvedClassName = (actualClassName ?? receiverClassName);
      if (this_._syntheticLoweredNames.contains(resolvedClassName)) {
        resolvedClassName = _ExpressionRestorer__findUserClassForSynthetic(this_, resolvedClassName);
      }
      final String staticFuncName = '${resolvedClassName}_${name}';
      final StaticList<String> allTypeArgs = StaticList<String>.of([]);
      final StaticList<String> receiverClassTypeArgs = _ExpressionRestorer__extractClassTypeArgsFromReceiver(this_, expr.receiver);
      allTypeArgs.addAll(receiverClassTypeArgs);
      for (final ta in expr.arguments.types) {
        allTypeArgs.add(_TypeUtils__restoreType(this_, ta));
      }
      final String typeArgStr = (allTypeArgs.isNotEmpty ? '<${allTypeArgs.join(', ')}>' : '');
      final FunctionNode tFunc = expr.interfaceTarget.function;
      final StaticList<String> argParts = StaticList<String>.of([]);
      for (var i = 0; (i < expr.arguments.positional.length); i = (i + 1)) {
        argParts.add(_ExpressionRestorer__restoreExpr(this_, expr.arguments.positional[i]));
      }
      for (var i = expr.arguments.positional.length; (i < tFunc.positionalParameters.length); i = (i + 1)) {
        final VariableDeclaration p = tFunc.positionalParameters[i];
        if (!((p.initializer == null))) {
          argParts.add(_ExpressionRestorer__restoreExpr(this_, p.initializer!));
        }
 else {
          argParts.add(_DartRestorerBase__defaultValueForType(this_, p.type));
        }
      }
      for (final n in expr.arguments.named) {
        argParts.add('${n.name}: ${_ExpressionRestorer__restoreExpr(this_, n.value)}');
      }
      final String argsStr = argParts.join(', ');
      if (argsStr.isEmpty) {
        return '${staticFuncName}${typeArgStr}(${recv})';
      }
      return '${staticFuncName}${typeArgStr}(${recv}, ${argsStr})';
    }
    final String thisType = 'dynamic';
    if ((_TypeUtils__isBinaryOp(this_, name) && (expr.arguments.positional.length == 1))) {
      final String right = _ExpressionRestorer__restoreExpr(this_, expr.arguments.positional[0]);
      final String rightType = _DartRestorerBase__restoreTypeForSignature(this_, expr.functionType.positionalParameters[0]);
      final String sig = _ExpressionRestorer__emitFuncSig(this_, returnType, StaticList<String>.of([thisType, rightType]));
      final String vtableField = 'operator${_DartRestorerBase__operatorFuncName(this_, name)}';
      return '(${recv}.vptr[\'${vtableField}\'] as ${sig})(${recv}, ${right})';
    }
    if ((name == 'unary-')) {
      final String sig = _ExpressionRestorer__emitFuncSig(this_, returnType, StaticList<String>.of([thisType]));
      return '(${recv}.vptr[\'operatorNeg\'] as ${sig})(${recv})';
    }
    if ((name == '~')) {
      final String sig = _ExpressionRestorer__emitFuncSig(this_, returnType, StaticList<String>.of([thisType]));
      return '(${recv}.vptr[\'operatorBitNot\'] as ${sig})(${recv})';
    }
    if ((name == '[]')) {
      final String idx = _ExpressionRestorer__restoreExpr(this_, expr.arguments.positional[0]);
      final String idxType = _DartRestorerBase__restoreTypeForSignature(this_, expr.functionType.positionalParameters[0]);
      final String sig = _ExpressionRestorer__emitFuncSig(this_, returnType, StaticList<String>.of([thisType, idxType]));
      return '(${recv}.vptr[\'operatorIndex\'] as ${sig})(${recv}, ${idx})';
    }
    if ((name == '[]=')) {
      final String idx = _ExpressionRestorer__restoreExpr(this_, expr.arguments.positional[0]);
      final String val = _ExpressionRestorer__restoreExpr(this_, expr.arguments.positional[1]);
      final String idxType = _DartRestorerBase__restoreTypeForSignature(this_, expr.functionType.positionalParameters[0]);
      final String valType = ((expr.functionType.positionalParameters.length > 1) ? _DartRestorerBase__restoreTypeForSignature(this_, expr.functionType.positionalParameters[1]) : 'dynamic');
      final String sig = _ExpressionRestorer__emitFuncSig(this_, returnType, StaticList<String>.of([thisType, idxType, valType]));
      return '(${recv}.vptr[\'operatorIndexSet\'] as ${sig})(${recv}, ${idx}, ${val})';
    }
    final String vtableField = _DartRestorerBase__vtableFieldName(this_, name);
    final String allArgs = _TypeUtils__restoreArgs(this_, expr.arguments);
    String _buildArgsWithDefaults() {
      final FunctionNode tFunc = expr.interfaceTarget.function;
      final StaticList<String> parts = StaticList<String>.of([]);
      for (var i = 0; (i < expr.arguments.positional.length); i = (i + 1)) {
        parts.add(_ExpressionRestorer__restoreExpr(this_, expr.arguments.positional[i]));
      }
      for (var i = expr.arguments.positional.length; (i < tFunc.positionalParameters.length); i = (i + 1)) {
        final VariableDeclaration p = tFunc.positionalParameters[i];
        if (!((p.initializer == null))) {
          parts.add(_ExpressionRestorer__restoreExpr(this_, p.initializer!));
        }
 else {
          parts.add('null');
        }
      }
      for (final n in expr.arguments.named) {
        parts.add('${n.name}: ${_ExpressionRestorer__restoreExpr(this_, n.value)}');
      }
      return parts.join(', ');
    }

    final bool hasMethodTypeParams = expr.interfaceTarget.function.typeParameters.isNotEmpty;
    if (hasMethodTypeParams) {
      final Class? enclosingClass = expr.interfaceTarget.enclosingClass;
      final StaticSet<String?> classTpNames = (!((enclosingClass == null)) ? StaticSet.of(enclosingClass.typeParameters.map(ClosureEnv_anon_32()).toSet().toList()) : StaticSet<String?>.of([]));
      final StaticList<TypeParameter> dedupedMethodTps = StaticList.of(expr.interfaceTarget.function.typeParameters.where(ClosureEnv_anon_33(classTpNames)).toList());
      final bool hasConcreteTypeArgs = ((dedupedMethodTps.isNotEmpty && expr.arguments.types.isNotEmpty) && !(expr.arguments.types.any(ClosureEnv_anon_34(this_))));
      if (hasConcreteTypeArgs) {
        final String typeSuffix = expr.arguments.types.map(ClosureEnv_anon_35(this_)).join('_');
        final String baseKey = (_TypeUtils__isBinaryOp(this_, name) ? 'operator${_DartRestorerBase__operatorFuncName(this_, name)}' : ((name == 'unary-') ? 'operatorNeg' : ((name == '~') ? 'operatorBitwiseNot' : ((name == '[]') ? 'operatorIndex' : ((name == '[]=') ? 'operatorIndexSet' : _DartRestorerBase__vtableFieldName(this_, name))))));
        final String specKey = '${baseKey}_${typeSuffix}';
        final String args = _buildArgsWithDefaults();
        final String specReturnType = _DartRestorerBase__restoreTypeForSignature(this_, expr.functionType.returnType);
        final StaticList<String> specSigParams = StaticList<String>.of([thisType]);
        final FunctionNode targetFunc = expr.interfaceTarget.function;
        for (var i = 0; (i < targetFunc.positionalParameters.length); i = (i + 1)) {
          if ((i < expr.functionType.positionalParameters.length)) {
            specSigParams.add(_DartRestorerBase__restoreTypeForSignature(this_, expr.functionType.positionalParameters[i]));
          }
 else {
            specSigParams.add(_DartRestorerBase__restoreTypeForSignature(this_, targetFunc.positionalParameters[i].type));
          }
        }
        final StaticList<String> specNamedParts = StaticList<String>.of([]);
        for (final namedParam in expr.functionType.namedParameters) {
          final String typeStr = _DartRestorerBase__restoreTypeForSignature(this_, namedParam.type);
          final String requiredPrefix = (namedParam.isRequired ? 'required ' : '');
          specNamedParts.add('${requiredPrefix}${typeStr} ${namedParam.name}');
        }
        final String specSig = _ExpressionRestorer__emitFuncSig(this_, specReturnType, specSigParams, named: specNamedParts);
        if (args.isEmpty) {
          return '(${recv}.vptr[\'${specKey}\'] as ${specSig})(${recv})';
        }
        return '(${recv}.vptr[\'${specKey}\'] as ${specSig})(${recv}, ${args})';
      }
      String resolvedClassName = (actualClassName ?? receiverClassName);
      if (this_._syntheticLoweredNames.contains(resolvedClassName)) {
        resolvedClassName = _ExpressionRestorer__findUserClassForSynthetic(this_, resolvedClassName);
      }
      final String staticFuncName = '${resolvedClassName}_${name}';
      final StaticList<String> allTypeArgs = StaticList<String>.of([]);
      final StaticList<String> receiverClassTypeArgs = _ExpressionRestorer__extractClassTypeArgsFromReceiver(this_, expr.receiver);
      allTypeArgs.addAll(receiverClassTypeArgs);
      for (final ta in expr.arguments.types) {
        allTypeArgs.add(_TypeUtils__restoreType(this_, ta));
      }
      final String typeArgStr = (allTypeArgs.isNotEmpty ? '<${allTypeArgs.join(', ')}>' : '');
      if (allArgs.isEmpty) {
        return '${staticFuncName}${typeArgStr}(${recv})';
      }
      return '${staticFuncName}${typeArgStr}(${recv}, ${allArgs})';
    }
    final FunctionNode targetFunc = expr.interfaceTarget.function;
    final StaticList<String> sigParamTypes = StaticList<String>.of([thisType]);
    for (var i = 0; (i < targetFunc.positionalParameters.length); i = (i + 1)) {
      if ((i < expr.functionType.positionalParameters.length)) {
        sigParamTypes.add(_DartRestorerBase__restoreTypeForSignature(this_, expr.functionType.positionalParameters[i]));
      }
 else {
        sigParamTypes.add(_DartRestorerBase__restoreTypeForSignature(this_, targetFunc.positionalParameters[i].type));
      }
    }
    final StaticList<String> namedParts = StaticList<String>.of([]);
    for (final namedParam in expr.functionType.namedParameters) {
      final String typeStr = _DartRestorerBase__restoreTypeForSignature(this_, namedParam.type);
      final String requiredPrefix = (namedParam.isRequired ? 'required ' : '');
      namedParts.add('${requiredPrefix}${typeStr} ${namedParam.name}');
    }
    final String sig = _ExpressionRestorer__emitFuncSig(this_, returnType, sigParamTypes, named: namedParts);
    final StaticList<String> fullArgParts = StaticList<String>.of([]);
    for (var i = 0; (i < expr.arguments.positional.length); i = (i + 1)) {
      fullArgParts.add(_ExpressionRestorer__restoreExpr(this_, expr.arguments.positional[i]));
    }
    for (var i = expr.arguments.positional.length; (i < targetFunc.positionalParameters.length); i = (i + 1)) {
      final VariableDeclaration param = targetFunc.positionalParameters[i];
      if (!((param.initializer == null))) {
        fullArgParts.add(_ExpressionRestorer__restoreExpr(this_, param.initializer!));
      }
 else {
        fullArgParts.add(_DartRestorerBase__defaultValueForType(this_, param.type));
      }
    }
    final String fullArgs = fullArgParts.join(', ');
    if (fullArgs.isEmpty) {
      return '(${recv}.vptr[\'${vtableField}\'] as ${sig})(${recv})';
    }
    return '(${recv}.vptr[\'${vtableField}\'] as ${sig})(${recv}, ${fullArgs})';
  }
  if ((!((receiverClassName == null)) && _DartRestorerBase__isEnumName(this_, receiverClassName))) {
    final String staticName = '${receiverClassName}_${name}';
    final String allArgs = _TypeUtils__restoreArgs(this_, expr.arguments);
    if (allArgs.isEmpty) {
      return '${staticName}(${recv})';
    }
    return '${staticName}(${recv}, ${allArgs})';
  }
  if ((!((receiverClassName == null)) && _DartRestorerBase__isMixinName(this_, receiverClassName))) {
    final Procedure target = expr.interfaceTarget;
    final String sig = _ExpressionRestorer__buildPreciseFuncSignature(this_, target);
    final String vtableField = _DartRestorerBase__vtableFieldName(this_, name);
    final String allArgs = _TypeUtils__restoreArgs(this_, expr.arguments);
    if (allArgs.isEmpty) {
      return '(${recv}.vptr[\'${vtableField}\'] as ${sig})(${recv})';
    }
    return '(${recv}.vptr[\'${vtableField}\'] as ${sig})(${recv}, ${allArgs})';
  }
  if ((!((receiverClassName == null)) && _ExpressionRestorer__isCollectionClass(this_, receiverClassName))) {
    if ((name == 'toList')) {
      return 'StaticList.of(${recv}.${name}())';
    }
    if ((name == 'toSet')) {
      return 'StaticSet.of(${recv}.${name}().toList())';
    }
  }
  if ((_TypeUtils__isBinaryOp(this_, name) && (expr.arguments.positional.length == 1))) {
    final String right = _ExpressionRestorer__restoreExpr(this_, expr.arguments.positional[0]);
    return '(${recv} ${name} ${right})';
  }
  if ((name == 'unary-'))   return '(-${recv})';
  if ((name == '~'))   return '(~${recv})';
  if ((name == '[]')) {
    return '${recv}[${_ExpressionRestorer__restoreExpr(this_, expr.arguments.positional[0])}]';
  }
  if ((name == '[]=')) {
    return '${recv}[${_ExpressionRestorer__restoreExpr(this_, expr.arguments.positional[0])}] = ${_ExpressionRestorer__restoreExpr(this_, expr.arguments.positional[1])}';
  }
  final String allArgs = _TypeUtils__restoreArgs(this_, expr.arguments);
  return '${recv}.${name}(${allArgs})';
}

String _ExpressionRestorer__buildPreciseFuncSignature(dynamic this__, Procedure proc, {String? receiverClassName = null}, {Expression? receiver = null}) {
  final this_ = this__;
  final String returnType = _DartRestorerBase__restoreTypeForSignature(this_, proc.function.returnType);
  final StaticList<String> paramTypes = StaticList<String>.of(['dynamic']);
  for (final param in proc.function.positionalParameters) {
    paramTypes.add(_DartRestorerBase__restoreTypeForSignature(this_, param.type));
  }
  final StaticList<String> namedParts = StaticList<String>.of([]);
  for (final param in proc.function.namedParameters) {
    final String typeStr = _DartRestorerBase__restoreTypeForSignature(this_, param.type);
    final String requiredPrefix = (param.isRequired ? 'required ' : '');
    namedParts.add('${requiredPrefix}${typeStr} ${param.name}');
  }
  return _ExpressionRestorer__emitFuncSig(this_, returnType, paramTypes, named: namedParts);
}

String _ExpressionRestorer__emitFuncSig(dynamic this__, String returnType, StaticList<String> positional, {StaticList<String> named = const []}) {
  final this_ = this__;
  if ((named.isNotEmpty || (positional.length > 16))) {
    return 'dynamic';
  }
  final int arity = positional.length;
  final String args = (() {   final StaticList<String> _v42 = StaticList<String>.of([returnType]);
  _v42.addAll(positional);
 return _v42; })().join(', ');
  return 'TypeFunction${arity}<${args}>';
}

String _ExpressionRestorer__getActualClassName(dynamic this__, String rawName) {
  final this_ = this__;
  if (rawName.contains('&')) {
    return _DartRestorerBase__sanitizeSyntheticName(this_, rawName);
  }
  return rawName;
}

String? _ExpressionRestorer__getReceiverClassNameFromReceiver(dynamic this__, Expression receiver, Member? target) {
  final this_ = this__;
  if ((receiver is VariableGet)) {
    final DartType varType = (receiver.promotedType ?? receiver.variable.type);
    if ((varType is InterfaceType)) {
      final String rawName = varType.classNode.name;
      if (rawName.endsWith('Value')) {
        final String className = rawName.substring(0, (rawName.length - 5));
        if ((_DartRestorerBase__isUserClass(this_, className) || _DartRestorerBase__isMixinName(this_, className))) {
          return className;
        }
      }
      final String className = _ExpressionRestorer__getActualClassName(this_, rawName);
      if ((_DartRestorerBase__isUserClass(this_, className) || _DartRestorerBase__isMixinName(this_, className))) {
        return className;
      }
    }
  }
  if (((receiver is ThisExpression) && !((this_._currentClass == null)))) {
    return _ExpressionRestorer__getActualClassName(this_, this_._currentClass!.name);
  }
  return _ExpressionRestorer__getReceiverClassName(this_, target);
}

String? _ExpressionRestorer__getReceiverClassName(dynamic this__, Member? target) {
  final this_ = this__;
  if ((target == null))   return null;
  final Class? enclosingClass = target.enclosingClass;
  if ((enclosingClass == null))   return null;
  final String className = _ExpressionRestorer__getActualClassName(this_, enclosingClass.name);
  if (this_._syntheticLoweredNames.contains(className)) {
    return _ExpressionRestorer__findUserClassForSynthetic(this_, className);
  }
  return className;
}

String _ExpressionRestorer__findUserClassForSynthetic(dynamic this__, String syntheticClassName) {
  final this_ = this__;
  for (final userClass in this_._userClasses)   do {
{
      if (this_._syntheticLoweredNames.contains(userClass))       break;
      if (_DartRestorerBase__isMixinName(this_, userClass))       break;
      String? current = _DartRestorerBase__getParentClassName(this_, userClass);
      while (!((current == null))) {
        if ((current == syntheticClassName))         return userClass;
        current = _DartRestorerBase__getParentClassName(this_, current);
      }
    }
  } while (false);
  return syntheticClassName;
}

StaticList<String> _ExpressionRestorer__extractClassTypeArgsFromReceiver(dynamic this__, Expression receiver) {
  final this_ = this__;
  if ((receiver is VariableGet)) {
    final DartType varType = receiver.variable.type;
    if (((varType is InterfaceType) && varType.typeArguments.isNotEmpty)) {
      return StaticList.of(varType.typeArguments.map(ClosureEnv_anon_36(this_)).toList());
    }
  }
  if ((receiver is ConstructorInvocation)) {
    final StaticList<DartType> args = receiver.arguments.types;
    if (args.isNotEmpty) {
      return StaticList.of(args.map(ClosureEnv_anon_37(this_)).toList());
    }
  }
  if ((receiver is InstanceInvocation)) {
    final DartType retType = receiver.functionType.returnType;
    if (((retType is InterfaceType) && retType.typeArguments.isNotEmpty)) {
      return StaticList.of(retType.typeArguments.map(ClosureEnv_anon_38(this_)).toList());
    }
  }
  if ((receiver is NullCheck)) {
    return _ExpressionRestorer__extractClassTypeArgsFromReceiver(this_, receiver.operand);
  }
  if ((receiver is InstanceGet)) {
    final DartType resultType = receiver.resultType;
    if (((resultType is InterfaceType) && resultType.typeArguments.isNotEmpty)) {
      return StaticList.of(resultType.typeArguments.map(ClosureEnv_anon_39(this_)).toList());
    }
    if ((resultType is NullType))     return StaticList<String>.of([]);
  }
  if ((receiver is AsExpression)) {
    final DartType castType = receiver.type;
    if (((castType is InterfaceType) && castType.typeArguments.isNotEmpty)) {
      return StaticList.of(castType.typeArguments.map(ClosureEnv_anon_40(this_)).toList());
    }
    return _ExpressionRestorer__extractClassTypeArgsFromReceiver(this_, receiver.operand);
  }
  if ((receiver is Let)) {
    return _ExpressionRestorer__extractClassTypeArgsFromReceiver(this_, receiver.body);
  }
  if ((receiver is BlockExpression)) {
    return _ExpressionRestorer__extractClassTypeArgsFromReceiver(this_, receiver.value);
  }
  if (((receiver is ThisExpression) && !((this_._currentClass == null)))) {
    final StaticList<TypeParameter> tps = this_._currentClass!.typeParameters;
    if (tps.isNotEmpty) {
      return StaticList.of(tps.map(ClosureEnv_anon_41()).toList());
    }
  }
  return StaticList<String>.of([]);
}

String _ExpressionRestorer__restoreFunctionInvocation(dynamic this__, FunctionInvocation expr) {
  final this_ = this__;
  final String recv = _ExpressionRestorer__restoreExpr(this_, expr.receiver);
  final String args = _TypeUtils__restoreArgs(this_, expr.arguments);
  return '${recv}(${args})';
}

String _ExpressionRestorer__restoreDynamicInvocation(dynamic this__, DynamicInvocation expr) {
  final this_ = this__;
  final String recv = _ExpressionRestorer__restoreExpr(this_, expr.receiver);
  final String name = expr.name.text;
  if ((name == '[]')) {
    final String idx = _ExpressionRestorer__restoreExpr(this_, expr.arguments.positional[0]);
    return '${recv}[${idx}]';
  }
  if ((name == '[]=')) {
    final String idx = _ExpressionRestorer__restoreExpr(this_, expr.arguments.positional[0]);
    final String val = _ExpressionRestorer__restoreExpr(this_, expr.arguments.positional[1]);
    return '${recv}[${idx}] = ${val}';
  }
  final String args = _TypeUtils__restoreArgs(this_, expr.arguments);
  return '${recv}.${name}(${args})';
}

String _ExpressionRestorer__restoreEqualsCall(dynamic this__, EqualsCall expr) {
  final this_ = this__;
  final String left = _ExpressionRestorer__restoreExpr(this_, expr.left);
  final String right = _ExpressionRestorer__restoreExpr(this_, expr.right);
  return '(${left} == ${right})';
}

String _ExpressionRestorer__restoreStaticInvocation(dynamic this__, StaticInvocation expr) {
  final this_ = this__;
  final Procedure target = expr.target;
  final String name = target.name.text;
  final String args = _TypeUtils__restoreArgs(this_, expr.arguments);
  if ((!((target.enclosingClass == null)) && (target.enclosingClass!.name == '_GrowableList'))) {
    final StaticList<DartType> typeArgs = expr.arguments.types;
    final String typeArgStr = (typeArgs.isNotEmpty ? '<${typeArgs.map(ClosureEnv_anon_42(this_)).join(', ')}>' : '');
    if (name.startsWith('_literal')) {
      final String items = expr.arguments.positional.map(ClosureEnv_anon_43(this_)).join(', ');
      return 'StaticList${typeArgStr}.of([${items}])';
    }
    return 'StaticList${typeArgStr}()';
  }
  if ((!((target.enclosingClass == null)) && _ExpressionRestorer__isSetInternalClass(this_, target.enclosingClass!.name))) {
    final StaticList<DartType> typeArgs = expr.arguments.types;
    final String typeArgStr = (typeArgs.isNotEmpty ? '<${typeArgs.map(ClosureEnv_anon_44(this_)).join(', ')}>' : '');
    if (((name == 'from') || (name == 'of')))     return 'StaticSet${typeArgStr}.of(${args})';
    if ((name.isEmpty || (name == '_default')))     return 'StaticSet${typeArgStr}()';
    return 'StaticSet${typeArgStr}.${name}(${args})';
  }
  if ((!((target.enclosingClass == null)) && _ExpressionRestorer__isMapInternalClass(this_, target.enclosingClass!.name))) {
    final StaticList<DartType> typeArgs = expr.arguments.types;
    final String typeArgStr = (typeArgs.isNotEmpty ? '<${typeArgs.map(ClosureEnv_anon_45(this_)).join(', ')}>' : '');
    if ((name.isEmpty || (name == '_default')))     return 'StaticMap${typeArgStr}()';
    return 'StaticMap${typeArgStr}.${name}(${args})';
  }
  if (_DartRestorerBase__isExtensionMethodName(this_, name)) {
    final int pipeIdx = name.indexOf('|');
    final String extensionName = name.substring(0, pipeIdx);
    final String memberPart = name.substring((pipeIdx + 1));
    if ((((extensionName == 'EnumName') || (extensionName == '_EnumName')) && memberPart.startsWith('get#'))) {
      final String propName = memberPart.substring(4);
      if (expr.arguments.positional.isNotEmpty) {
        final String recv = _ExpressionRestorer__restoreExpr(this_, expr.arguments.positional.first);
        return '${recv}.${propName}';
      }
    }
    final String cleanedName = _DartRestorerBase__sanitizeExtensionMethodName(this_, name);
    return '${cleanedName}(${args})';
  }
  if ((target.isFactory && !((target.enclosingClass == null)))) {
    final String className = target.enclosingClass!.name;
    if (((className == 'Future') || (className == '_Future'))) {
      final StaticList<DartType> typeArgs = expr.arguments.types;
      final String typeArgStr = (typeArgs.isNotEmpty ? '<${typeArgs.map(ClosureEnv_anon_46(this_)).join(', ')}>' : '');
      if ((name == 'delayed')) {
        return 'promiseDelayed${typeArgStr}(${args})';
      }
      if (name.isEmpty)       return 'Promise${typeArgStr}(${args})';
      return 'Promise${typeArgStr}.${name}(${args})';
    }
    if ((((className == 'List') || (className == '_GrowableList')) || (className == '_List'))) {
      final StaticList<DartType> typeArgs = expr.arguments.types;
      final String typeArgStr = (typeArgs.isNotEmpty ? '<${typeArgs.map(ClosureEnv_anon_47(this_)).join(', ')}>' : '');
      if ((name == 'filled'))       return 'StaticList${typeArgStr}.filled(${args})';
      if (((name == 'from') || (name == 'of')))       return 'StaticList${typeArgStr}.of(${args})';
      if (name.isEmpty)       return 'StaticList${typeArgStr}()';
      return 'StaticList${typeArgStr}.${name}(${args})';
    }
    if (((className == 'Map') || _ExpressionRestorer__isMapInternalClass(this_, className))) {
      final StaticList<DartType> typeArgs = expr.arguments.types;
      final String typeArgStr = (typeArgs.isNotEmpty ? '<${typeArgs.map(ClosureEnv_anon_48(this_)).join(', ')}>' : '');
      if (((name == 'from') || (name == 'of')))       return 'StaticMap${typeArgStr}.of(${args})';
      if ((name.isEmpty || (name == '_default')))       return 'StaticMap${typeArgStr}()';
      return 'StaticMap${typeArgStr}.${name}(${args})';
    }
    if (((className == 'Set') || _ExpressionRestorer__isSetInternalClass(this_, className))) {
      final StaticList<DartType> typeArgs = expr.arguments.types;
      final String typeArgStr = (typeArgs.isNotEmpty ? '<${typeArgs.map(ClosureEnv_anon_49(this_)).join(', ')}>' : '');
      if (((name == 'from') || (name == 'of')))       return 'StaticSet${typeArgStr}.of(${args})';
      if (name.isEmpty)       return 'StaticSet${typeArgStr}()';
      return 'StaticSet${typeArgStr}.${name}(${args})';
    }
    if (_DartRestorerBase__isUserClass(this_, className)) {
      final String funcName = (name.isEmpty ? '${className}_new' : '${className}_new_${name}');
      final StaticList<DartType> typeArgs = expr.arguments.types;
      final String typeArgStr = (typeArgs.isNotEmpty ? '<${typeArgs.map(ClosureEnv_anon_50(this_)).join(', ')}>' : '');
      return '${funcName}${typeArgStr}(${args})';
    }
    if (name.isEmpty)     return '${className}(${args})';
    return '${className}.${name}(${args})';
  }
  if (!((target.enclosingClass == null))) {
    String className = target.enclosingClass!.name;
    if (_DartRestorerBase__isUserClass(this_, className)) {
      className = _ExpressionRestorer__getActualClassName(this_, className);
      if (this_._syntheticLoweredNames.contains(className)) {
        className = _ExpressionRestorer__findUserClassForSynthetic(this_, className);
      }
      final StaticList<DartType> typeArgs = expr.arguments.types;
      final String typeArgStr = (typeArgs.isNotEmpty ? '<${typeArgs.map(ClosureEnv_anon_51(this_)).join(', ')}>' : '');
      return '${className}_${name}${typeArgStr}(${args})';
    }
    return '${className}.${name}(${args})';
  }
  final StaticList<DartType> typeArgs = expr.arguments.types;
  final String typeArgStr = (typeArgs.isNotEmpty ? '<${typeArgs.map(ClosureEnv_anon_52(this_)).join(', ')}>' : '');
  return '${name}${typeArgStr}(${args})';
}

String _ExpressionRestorer__restoreStaticGet(dynamic this__, StaticGet expr) {
  final this_ = this__;
  final Member target = expr.target;
  if (!((target.enclosingClass == null))) {
    final String className = target.enclosingClass!.name;
    final String memberName = target.name.text;
    if ((_DartRestorerBase__isUserClass(this_, className) || _DartRestorerBase__isMixinName(this_, className))) {
      if (((target is Procedure) && target.isGetter)) {
        return '${className}_${memberName}()';
      }
      return '${className}_${memberName}';
    }
    if (((className == '_EnumName') || (className == 'EnumName'))) {
      return '${memberName}';
    }
    return '${className}.${memberName}';
  }
  return target.name.text;
}

String _ExpressionRestorer__restoreStaticSet(dynamic this__, StaticSet expr) {
  final this_ = this__;
  final Member target = expr.target;
  final String value = _ExpressionRestorer__restoreExpr(this_, expr.value);
  if (!((target.enclosingClass == null))) {
    final String className = target.enclosingClass!.name;
    if (_DartRestorerBase__isUserClass(this_, className)) {
      final String memberName = target.name.text;
      return '${className}_${memberName} = ${value}';
    }
    return '${className}.${target.name.text} = ${value}';
  }
  return '${target.name.text} = ${value}';
}

String _ExpressionRestorer__restoreConstructorInvocation(dynamic this__, ConstructorInvocation expr) {
  final this_ = this__;
  final String className = expr.target.enclosingClass.name;
  final String ctorName = expr.target.name.text;
  if ((className == '_GrowableList')) {
    final StaticList<DartType> typeArgs = expr.arguments.types;
    final String typeArgStr = (typeArgs.isNotEmpty ? '<${typeArgs.map(ClosureEnv_anon_53(this_)).join(', ')}>' : '');
    if (ctorName.startsWith('_literal')) {
      final String items = expr.arguments.positional.map(ClosureEnv_anon_54(this_)).join(', ');
      return 'StaticList${typeArgStr}.of([${items}])';
    }
 else     if (ctorName.isEmpty) {
      return 'StaticList${typeArgStr}()';
    }
  }
  if (_ExpressionRestorer__isSetInternalClass(this_, className)) {
    final StaticList<DartType> typeArgs = expr.arguments.types;
    final String typeArgStr = (typeArgs.isNotEmpty ? '<${typeArgs.map(ClosureEnv_anon_55(this_)).join(', ')}>' : '');
    return 'StaticSet${typeArgStr}()';
  }
  final String allArgs = _TypeUtils__restoreArgs(this_, expr.arguments);
  if (_DartRestorerBase__isUserClass(this_, className)) {
    final String funcName = (ctorName.isEmpty ? '${className}_new' : '${className}_new_${ctorName}');
    final String typeArgs = (expr.arguments.types.isNotEmpty ? '<${expr.arguments.types.map(/* unknown: InstanceTearOff */).join(', ')}>' : '');
    final String valueType = '${className}Value${typeArgs}';
    return (allArgs.isEmpty ? '${funcName}${typeArgs}(${valueType}())' : '${funcName}${typeArgs}(${valueType}(), ${allArgs})');
  }
  final String prefix = (expr.isConst ? 'const ' : '');
  if (ctorName.isEmpty)   return '${prefix}${className}(${allArgs})';
  if (ctorName.startsWith('_'))   return '${prefix}${className}(${allArgs})';
  return '${prefix}${className}.${ctorName}(${allArgs})';
}

bool _ExpressionRestorer__isSetInternalClass(dynamic this__, String className) {
  final this_ = this__;
  return (((((className == '_Set') || (className == '_CompactLinkedHashSet')) || (className == '_LinkedHashSet')) || (className == 'LinkedHashSet')) || (className == '_HashSet'));
}

bool _ExpressionRestorer__isMapInternalClass(dynamic this__, String className) {
  final this_ = this__;
  return ((((className == 'LinkedHashMap') || (className == '_CompactLinkedHashMap')) || (className == '_InternalLinkedHashMap')) || (className == '_LinkedHashMap'));
}

bool _ExpressionRestorer__isCollectionClass(dynamic this__, String className) {
  final this_ = this__;
  return (((((((((className == 'List') || (className == '_GrowableList')) || (className == '_List')) || (className == 'Iterable')) || (className == '_Iterable')) || (className == 'Map')) || _ExpressionRestorer__isMapInternalClass(this_, className)) || (className == 'Set')) || _ExpressionRestorer__isSetInternalClass(this_, className));
}

String _ExpressionRestorer__restoreConditional(dynamic this__, ConditionalExpression expr) {
  final this_ = this__;
  return '(${_ExpressionRestorer__restoreExpr(this_, expr.condition)} ? ${_ExpressionRestorer__restoreExpr(this_, expr.then)} : ${_ExpressionRestorer__restoreExpr(this_, expr.otherwise)})';
}

String _ExpressionRestorer__restoreLogical(dynamic this__, LogicalExpression expr) {
  final this_ = this__;
  final String op = ((expr.operatorEnum == LogicalExpressionOperator.AND) ? '&&' : '||');
  return '(${_ExpressionRestorer__restoreExpr(this_, expr.left)} ${op} ${_ExpressionRestorer__restoreExpr(this_, expr.right)})';
}

String _ExpressionRestorer__restoreNot(dynamic this__, Not expr) {
  final this_ = this__;
  return '!(${_ExpressionRestorer__restoreExpr(this_, expr.operand)})';
}

String _ExpressionRestorer__restoreStringConcat(dynamic this__, StringConcatenation expr) {
  final this_ = this__;
  final String parts = expr.expressions.map(ClosureEnv_anon_56(this_)).join();
  return '\'${parts}\'';
}

String? _ExpressionRestorer__tryEnumToStringInInterpolation(dynamic this__, Expression expr) {
  final this_ = this__;
  DartType? exprType;
  if ((expr is VariableGet)) {
    exprType = expr.variable.type;
  }
 else   if ((expr is InstanceGet)) {
    exprType = expr.resultType;
  }
 else   if (((expr is InstanceInvocation) && (expr.name.text == 'toString'))) {
    final String? receiverClassName = _ExpressionRestorer__getReceiverClassName(this_, expr.interfaceTarget);
    if ((!((receiverClassName == null)) && this_._enumsWithCustomToString.contains(receiverClassName))) {
      final String recv = _ExpressionRestorer__restoreExpr(this_, expr.receiver);
      return '${receiverClassName}_toString(${recv})';
    }
    return null;
  }
  if ((exprType is InterfaceType)) {
    final String className = exprType.classNode.name;
    if (this_._enumsWithCustomToString.contains(className)) {
      final String restored = _ExpressionRestorer__restoreExpr(this_, expr);
      return '${className}_toString(${restored})';
    }
  }
  return null;
}

String _ExpressionRestorer__restoreStringLiteral(dynamic this__, StringLiteral expr) {
  final this_ = this__;
  final String escaped = expr.value.replaceAll('\\', '\\\\').replaceAll('\'', '\\\'').replaceAll('\n', '\\n').replaceAll('\r', '\\r').replaceAll('\t', '\\t');
  return '\'${escaped}\'';
}

String _ExpressionRestorer__restoreDoubleLiteral(dynamic this__, DoubleLiteral expr) {
  final this_ = this__;
  final double v = expr.value;
  if ((v == v.toInt().toDouble()))   return '${v.toStringAsFixed(1)}';
  return '${v}';
}

String _ExpressionRestorer__restoreListLiteral(dynamic this__, ListLiteral expr) {
  final this_ = this__;
  final String typeArg = _TypeUtils__restoreType(this_, expr.typeArgument);
  final String items = expr.expressions.map(ClosureEnv_anon_57(this_)).join(', ');
  if (expr.isConst) {
    return 'StaticList<${typeArg}>.of([${items}])';
  }
  if ((typeArg == 'dynamic')) {
    return 'StaticList.of([${items}])';
  }
  return 'StaticList<${typeArg}>.of([${items}])';
}

String _ExpressionRestorer__restoreMapLiteral(dynamic this__, MapLiteral expr) {
  final this_ = this__;
  final String keyType = _TypeUtils__restoreType(this_, expr.keyType);
  final String valueType = _TypeUtils__restoreType(this_, expr.valueType);
  final String entries = expr.entries.map(ClosureEnv_anon_58(this_)).join(', ');
  if (((keyType == 'dynamic') && (valueType == 'dynamic'))) {
    return 'StaticMap.of({${entries}})';
  }
  return 'StaticMap<${keyType}, ${valueType}>.of({${entries}})';
}

String _ExpressionRestorer__restoreSetLiteral(dynamic this__, SetLiteral expr) {
  final this_ = this__;
  final String typeArg = _TypeUtils__restoreType(this_, expr.typeArgument);
  final String items = expr.expressions.map(ClosureEnv_anon_59(this_)).join(', ');
  return 'StaticSet<${typeArg}>.of([${items}])';
}

String _ExpressionRestorer__restoreIsExpr(dynamic this__, IsExpression expr) {
  final this_ = this__;
  return '(${_ExpressionRestorer__restoreExpr(this_, expr.operand)} is ${_TypeUtils__restoreType(this_, expr.type)})';
}

String _ExpressionRestorer__restoreAsExpr(dynamic this__, AsExpression expr) {
  final this_ = this__;
  return '(${_ExpressionRestorer__restoreExpr(this_, expr.operand)} as ${_TypeUtils__restoreType(this_, expr.type)})';
}

String _ExpressionRestorer__restoreLet(dynamic this__, Let expr) {
  final this_ = this__;
  final VariableDeclaration v = expr.variable;
  if ((v.name == null))   v.name = '_let${(() { final _let45 = this_._varCounter; return (() { final _let46 = this_._varCounter = (_let45 + 1); return _let45; })(); })()}';
  final String cleanedName = _TypeUtils__cleanVarName(this_, v.name!);
  v.name = cleanedName;
  if (!((v.initializer == null))) {
    final Expression body = expr.body;
    if ((body is ConditionalExpression)) {
      final Expression condition = body.condition;
      if ((condition is EqualsNull)) {
        final Expression condExpr = condition.expression;
        if (((condExpr is VariableGet) && (condExpr.variable == v))) {
          final Expression otherwise = body.otherwise;
          if (((otherwise is VariableGet) && (otherwise.variable == v))) {
            final String lhs = _ExpressionRestorer__restoreExpr(this_, v.initializer!);
            final String fallback = _ExpressionRestorer__restoreExpr(this_, body.then);
            return '(${lhs} ?? ${fallback})';
          }
          if ((otherwise is AsExpression)) {
            final Expression inner = otherwise.operand;
            if (((inner is VariableGet) && (inner.variable == v))) {
              final String lhs = _ExpressionRestorer__restoreExpr(this_, v.initializer!);
              final String fallback = _ExpressionRestorer__restoreExpr(this_, body.then);
              return '(${lhs} ?? ${fallback})';
            }
          }
        }
      }
    }
  }
  if (!((v.initializer == null))) {
    final Expression body = expr.body;
    if ((body is ConditionalExpression)) {
      final Expression condition = body.condition;
      if ((condition is EqualsNull)) {
        final Expression condExpr = condition.expression;
        if (((condExpr is VariableGet) && (condExpr.variable == v))) {
          final Expression thenBranch = body.then;
          if ((thenBranch is NullLiteral)) {
            final Expression otherwiseExpr = body.otherwise;
            final bool receiverNeedsLowering = _ExpressionRestorer__nullSafeReceiverNeedsLowering(this_, v);
            if (!(receiverNeedsLowering)) {
              final String lhs = _ExpressionRestorer__restoreExpr(this_, v.initializer!);
              final String? memberAccess = _ExpressionRestorer__extractMemberAccessOnVar(this_, otherwiseExpr, v);
              if (!((memberAccess == null))) {
                return '${lhs}?.${memberAccess}';
              }
            }
            final String lhs = _ExpressionRestorer__restoreExpr(this_, v.initializer!);
            final String tmpName = cleanedName;
            return '(() { final ${tmpName} = ${lhs}; return (${tmpName} == null) ? null : ${_ExpressionRestorer__restoreExpr(this_, otherwiseExpr)}; })()';
          }
        }
      }
    }
  }
  if (!((v.initializer == null))) {
    final Expression body = expr.body;
    if ((body is BlockExpression)) {
      final Expression blockValue = body.value;
      if (((blockValue is VariableGet) && (blockValue.variable == v))) {
        final bool receiverNeedsLowering = _ExpressionRestorer__cascadeReceiverNeedsLowering(this_, v);
        if (receiverNeedsLowering) {
          final String receiver = _ExpressionRestorer__restoreExpr(this_, v.initializer!);
          final String tmpName = cleanedName;
          final StringBuffer stmtBuf = StringBuffer();
          for (final stmt in body.body.statements) {
            if ((stmt is ExpressionStatement)) {
              stmtBuf.write('${_ExpressionRestorer__restoreExpr(this_, stmt.expression)}; ');
            }
          }
          return '(() { final ${tmpName} = ${receiver}; ${stmtBuf}return ${tmpName}; })()';
        }
        final StaticList<String>? cascadeOps = _ExpressionRestorer__extractCascadeOps(this_, body.body.statements, v);
        if ((!((cascadeOps == null)) && cascadeOps.isNotEmpty)) {
          final String receiver = _ExpressionRestorer__restoreExpr(this_, v.initializer!);
          final String opsStr = cascadeOps.join('');
          return '(${receiver}${opsStr})';
        }
      }
    }
  }
  final String init = _ExpressionRestorer__restoreExpr(this_, v.initializer!);
  final String body = _ExpressionRestorer__restoreExpr(this_, expr.body);
  return '(() { final ${cleanedName} = ${init}; return ${body}; })()';
}

StaticList<String>? _ExpressionRestorer__extractCascadeOps(dynamic this__, StaticList<Statement> stmts, VariableDeclaration cascadeVar) {
  final this_ = this__;
  final StaticList<String> ops = StaticList<String>.of([]);
  for (final stmt in stmts) {
    if ((stmt is ExpressionStatement)) {
      final String? cascadeOp = _ExpressionRestorer__extractSingleCascadeOp(this_, stmt.expression, cascadeVar);
      if (!((cascadeOp == null))) {
        ops.add(cascadeOp);
      }
 else {
        return null;
      }
    }
 else {
      return null;
    }
  }
  return ops;
}

String? _ExpressionRestorer__extractSingleCascadeOp(dynamic this__, Expression expr, VariableDeclaration cascadeVar) {
  final this_ = this__;
  if ((expr is InstanceInvocation)) {
    final Expression receiver = expr.receiver;
    if (((receiver is VariableGet) && (receiver.variable == cascadeVar))) {
      final String args = _TypeUtils__restoreArgs(this_, expr.arguments);
      return '..${expr.name.text}(${args})';
    }
  }
  if ((expr is InstanceSet)) {
    final Expression receiver = expr.receiver;
    if (((receiver is VariableGet) && (receiver.variable == cascadeVar))) {
      return '..${expr.name.text} = ${_ExpressionRestorer__restoreExpr(this_, expr.value)}';
    }
  }
  if ((expr is DynamicInvocation)) {
    final Expression receiver = expr.receiver;
    if (((receiver is VariableGet) && (receiver.variable == cascadeVar))) {
      final String args = _TypeUtils__restoreArgs(this_, expr.arguments);
      return '..${expr.name.text}(${args})';
    }
  }
  return null;
}

String _ExpressionRestorer__restoreBlockExpr(dynamic this__, BlockExpression expr) {
  final this_ = this__;
  final StringBuffer stmts = StringBuffer();
  for (final s in expr.body.statements) {
    final StringBuffer oldBuf = this_._buf;
    final StringBuffer tmpBuf = StringBuffer();
    this_._buf = tmpBuf;
    _DartRestorerBase__restoreStmt(this_, s);
    this_._buf = oldBuf;
    stmts.write(tmpBuf);
  }
  final String value = _ExpressionRestorer__restoreExpr(this_, expr.value);
  final String cleanedStmts = stmts.toString();
  return '(() { ${cleanedStmts} return ${value}; })()';
}

String _ExpressionRestorer__restoreFuncExpr(dynamic this__, FunctionExpression expr) {
  final this_ = this__;
  final FunctionNode func = expr.function;
  final _CaptureAnalysisResultValue analysis = analyzeCapturedVarsFromFunc(func);
  final StaticList<VariableDeclaration> capturedDecls = analysis.capturedDecls;
  final bool capturesThis = analysis.capturesThis;
  return _ExpressionRestorer__restoreFuncExprAsClosure(this_, func, capturedDecls, capturesThis);
}

String _ExpressionRestorer__restoreFuncExprAsLambda(dynamic this__, FunctionNode func) {
  final this_ = this__;
  final StringBuffer sb = StringBuffer();
  sb.write('(');
  final StaticList<String> params = StaticList<String>.of([]);
  for (final p in func.positionalParameters) {
    final String pName = _TypeUtils__cleanVarName(this_, (p.name ?? '_p${(() { final _let48 = this_._varCounter; return (() { final _let49 = this_._varCounter = (_let48 + 1); return _let48; })(); })()}'));
    p.name = pName;
    params.add('${_TypeUtils__restoreType(this_, p.type)} ${pName}');
  }
  for (final p in func.namedParameters) {
    final String pName = _TypeUtils__cleanVarName(this_, (p.name ?? '_n${(() { final _let51 = this_._varCounter; return (() { final _let52 = this_._varCounter = (_let51 + 1); return _let51; })(); })()}'));
    p.name = pName;
    params.add('${_TypeUtils__restoreType(this_, p.type)} ${pName}');
  }
  sb.write(params.join(', '));
  sb.write(')');
  if ((func.body is ReturnStatement)) {
    final ReturnStatement ret = (func.body as ReturnStatement);
    if (!((ret.expression == null))) {
      sb.write(' => ${_ExpressionRestorer__restoreExpr(this_, ret.expression!)}');
    }
  }
 else   if (!((func.body == null))) {
    final StringBuffer oldBuf = this_._buf;
    final StringBuffer tmpBuf = StringBuffer();
    this_._buf = tmpBuf;
    _DartRestorerBase__restoreStmt(this_, func.body!);
    this_._buf = oldBuf;
    sb.write(' ${tmpBuf}');
  }
  return sb.toString();
}

String _ExpressionRestorer__restoreFuncExprAsClosure(dynamic this__, FunctionNode func, StaticList<VariableDeclaration> capturedDecls, bool capturesThis) {
  final this_ = this__;
  final int closureId = (() { final _let53 = this_._closureCounter; return (() { final _let54 = this_._closureCounter = (_let53 + 1); return _let53; })(); })();
  final String envClassName = 'ClosureEnv_${this_._closureContext}_${closureId}';
  final StaticList<_CapturedVarValue> capturedFields = StaticList<_CapturedVarValue>.of([]);
  if ((((capturesThis && this_._insideMethodBody) && !((this_._currentClass == null))) && _DartRestorerBase__needsLowering(this_, this_._currentClass!.name))) {
    late String thisTypeStr;
    if (_DartRestorerBase__isUserClass(this_, this_._currentClass!.name)) {
      final StaticList<TypeParameter> classTypeParams = this_._currentClass!.typeParameters;
      final String typeParamSuffix = (classTypeParams.isNotEmpty ? '<${classTypeParams.map(ClosureEnv_anon_60()).join(', ')}>' : '');
      thisTypeStr = '${this_._currentClass!.name}Value${typeParamSuffix}';
    }
 else     if (_DartRestorerBase__isEnumName(this_, this_._currentClass!.name)) {
      thisTypeStr = this_._currentClass!.name;
    }
 else {
      thisTypeStr = 'dynamic';
    }
    capturedFields.add(_CapturedVar_new(_CapturedVarValue(), name: this_._thisReplacementName, typeStr: thisTypeStr, isThis: true));
  }
  for (final decl in capturedDecls) {
    final String varName = _TypeUtils__cleanVarName(this_, (decl.name ?? '_cap${(() { final _let57 = this_._varCounter; return (() { final _let58 = this_._varCounter = (_let57 + 1); return _let57; })(); })()}'));
    decl.name = varName;
    final bool isBoxed = this_._boxedVars.contains(decl);
    final String typeStr = (isBoxed ? _TypeUtils__boxTypeNameFor(this_, decl.type)! : _TypeUtils__restoreType(this_, decl.type));
    capturedFields.add(_CapturedVar_new(_CapturedVarValue(), name: varName, typeStr: typeStr, isBoxed: isBoxed));
  }
  for (final p in func.positionalParameters) {
    final String pName = _TypeUtils__cleanVarName(this_, (p.name ?? '_p${(() { final _let60 = this_._varCounter; return (() { final _let61 = this_._varCounter = (_let60 + 1); return _let60; })(); })()}'));
    p.name = pName;
  }
  for (final p in func.namedParameters) {
    final String pName = _TypeUtils__cleanVarName(this_, (p.name ?? '_n${(() { final _let63 = this_._varCounter; return (() { final _let64 = this_._varCounter = (_let63 + 1); return _let63; })(); })()}'));
    p.name = pName;
  }
  _DartRestorerBase__preanalyzeBoxedVarsForFunc(this_, func);
  final StaticList<VariableDeclaration> boxedParams = StaticList<VariableDeclaration>.of([]);
  for (final p in func.positionalParameters) {
    if (this_._boxedVars.contains(p))     boxedParams.add(p);
  }
  for (final p in func.namedParameters) {
    if (this_._boxedVars.contains(p))     boxedParams.add(p);
  }
  final StaticList<String> callParams = StaticList<String>.of([]);
  for (final p in func.positionalParameters) {
    final String baseName = p.name!;
    final String pName = (this_._boxedVars.contains(p) ? '${baseName}_raw' : baseName);
    callParams.add('${_TypeUtils__restoreType(this_, p.type)} ${pName}');
  }
  for (final p in func.namedParameters) {
    final String baseName = p.name!;
    final String pName = (this_._boxedVars.contains(p) ? '${baseName}_raw' : baseName);
    callParams.add('${_TypeUtils__restoreType(this_, p.type)} ${pName}');
  }
  final String callParamStr = callParams.join(', ');
  final StaticList<String> callArgNames = StaticList<String>.of([]);
  for (final p in func.positionalParameters) {
    final String baseName = p.name!;
    final String argName = (this_._boxedVars.contains(p) ? '${baseName}_raw' : baseName);
    callArgNames.add(argName);
  }
  for (final p in func.namedParameters) {
    final String baseName = p.name!;
    final String argName = (this_._boxedVars.contains(p) ? '${baseName}_raw' : baseName);
    callArgNames.add(argName);
  }
  final String callArgStr = callArgNames.join(', ');
  final String returnType = _TypeUtils__restoreType(this_, func.returnType);
  final StaticSet<TypeParameter> typeParams = StaticSet<TypeParameter>.of([]);
  for (final decl in capturedDecls) {
    _ExpressionRestorer__collectTypeParameters(this_, decl.type, typeParams);
  }
  for (final p in func.positionalParameters) {
    _ExpressionRestorer__collectTypeParameters(this_, p.type, typeParams);
  }
  for (final p in func.namedParameters) {
    _ExpressionRestorer__collectTypeParameters(this_, p.type, typeParams);
  }
  _ExpressionRestorer__collectTypeParameters(this_, func.returnType, typeParams);
  final String typeParamStr = (typeParams.isEmpty ? '' : '<${typeParams.map(ClosureEnv_anon_61()).join(', ')}>');
  final StaticMap<VariableDeclaration, String> savedEnvPrefix = StaticMap<VariableDeclaration, String>.from(this_._capturedVarEnvPrefix);
  final bool savedThisInEnv = this_._thisIsCapturedInEnv;
  for (final decl in capturedDecls) {
    this_._capturedVarEnvPrefix[decl] = 'env.';
  }
  if ((((capturesThis && this_._insideMethodBody) && !((this_._currentClass == null))) && _DartRestorerBase__isUserClass(this_, this_._currentClass!.name))) {
    this_._thisIsCapturedInEnv = true;
  }
  _DartRestorerBase__pushClosureContext(this_, envClassName);
  final StaticSet<VariableDeclaration> savedCurrentParams = StaticSet<VariableDeclaration>.of(this_._currentFunctionParams);
  this_._currentFunctionParams.clear();
  this_._currentFunctionParams.addAll(func.positionalParameters);
  this_._currentFunctionParams.addAll(func.namedParameters);
  final StaticList<String> paramBoxInitLines = StaticList<String>.of([]);
  for (final p in boxedParams) {
    final String baseName = p.name!;
    final String boxType = _TypeUtils__boxTypeNameFor(this_, p.type)!;
    paramBoxInitLines.add('  ${boxType} ${baseName} = ${boxType}(${baseName}_raw);\n');
  }
  late String bodyStr;
  if (((func.body is ReturnStatement) && paramBoxInitLines.isEmpty)) {
    final ReturnStatement ret = (func.body as ReturnStatement);
    if (!((ret.expression == null))) {
      bodyStr = ' {\n  return ${_ExpressionRestorer__restoreExpr(this_, ret.expression!)};\n}\n';
    }
 else {
      bodyStr = ' {}\n';
    }
  }
 else   if (!((func.body == null))) {
    final StringBuffer oldBuf = this_._buf;
    final StringBuffer tmpBuf = StringBuffer();
    this_._buf = tmpBuf;
    if (paramBoxInitLines.isNotEmpty) {
      tmpBuf.write('{\n');
      for (final line in paramBoxInitLines) {
        tmpBuf.write(line);
      }
      if ((func.body is Block)) {
        final int oldIndent = this_._indent;
        this_._indent = 1;
        for (final s in (func.body as Block).statements) {
          _DartRestorerBase__restoreStmt(this_, s);
        }
        this_._indent = oldIndent;
      }
 else       if ((func.body is ReturnStatement)) {
        final ReturnStatement ret = (func.body as ReturnStatement);
        if (!((ret.expression == null))) {
          tmpBuf.write('  return ${_ExpressionRestorer__restoreExpr(this_, ret.expression!)};\n');
        }
      }
 else {
        _DartRestorerBase__restoreStmt(this_, func.body!);
      }
      tmpBuf.write('}\n');
    }
 else {
      _DartRestorerBase__restoreStmt(this_, func.body!);
    }
    this_._buf = oldBuf;
    bodyStr = ' ${tmpBuf}';
  }
 else {
    bodyStr = ' {}\n';
  }
  this_._currentFunctionParams.clear();
  this_._currentFunctionParams.addAll(savedCurrentParams);
  _DartRestorerBase__popClosureContext(this_);
  this_._capturedVarEnvPrefix.clear();
  this_._capturedVarEnvPrefix.addAll(savedEnvPrefix);
  this_._thisIsCapturedInEnv = savedThisInEnv;
  final StringBuffer declBuf = StringBuffer();
  final StaticList<String> positionalParamTypes = (() {   final StaticList<String> _v66 = StaticList<String>.of([]);
  for (final p in func.positionalParameters)   _v66.add(_TypeUtils__restoreType(this_, p.type));
 return _v66; })();
  final bool hasNamedParam = func.namedParameters.isNotEmpty;
  late String baseClause;
  late bool callIsOverride;
  if ((!(hasNamedParam) && (positionalParamTypes.length <= 16))) {
    final int arity = positionalParamTypes.length;
    final String args = (() {     final StaticList<String> _v67 = StaticList<String>.of([returnType]);
    _v67.addAll(positionalParamTypes);
 return _v67; })().join(', ');
    baseClause = ' extends TypeFunction${arity}<${args}>';
    callIsOverride = true;
  }
 else {
    baseClause = ' extends TypeFunction<${returnType}>';
    callIsOverride = false;
  }
  declBuf.write('class ${envClassName}${typeParamStr}${baseClause} {\n');
  for (final field in capturedFields) {
    declBuf.write('  ${field.typeStr} ${field.name};\n');
  }
  final String ctorParams = capturedFields.map(ClosureEnv_anon_62()).join(', ');
  declBuf.write('  ${envClassName}(${ctorParams});\n');
  final String staticCallName = '${envClassName}_call';
  final String forwardArgs = (callArgStr.isEmpty ? 'this' : 'this, ${callArgStr}');
  if (callIsOverride) {
    declBuf.write('  @override\n');
  }
  declBuf.write('  ${returnType} call(${callParamStr}) => ${staticCallName}${typeParamStr}(${forwardArgs});\n');
  declBuf.write('}\n');
  final String envClassWithTypeParams = '${envClassName}${typeParamStr}';
  final String staticParams = (callParamStr.isEmpty ? '${envClassWithTypeParams} env' : '${envClassWithTypeParams} env, ${callParamStr}');
  final AsyncMarker marker = func.asyncMarker;
  String asyncStr = '';
  if ((marker == AsyncMarker.AsyncStar))   asyncStr = ' async*';
  if ((marker == AsyncMarker.SyncStar))   asyncStr = ' sync*';
  declBuf.write('${returnType} ${staticCallName}${typeParamStr}(${staticParams})${asyncStr}${bodyStr}\n');
  this_._pendingClosureDecls.add(declBuf.toString());
  final StaticList<String> constructArgsList = StaticList<String>.of([]);
  for (var _i = 0; (_i < capturedFields.length); _i = (_i + 1)) {
    final _CapturedVarValue field = capturedFields[_i];
    if (field.isThis) {
      if (savedThisInEnv) {
        constructArgsList.add('env.${field.name}');
      }
 else {
        constructArgsList.add(field.name);
      }
    }
 else     if ((_i < (capturedDecls.length + ((((capturesThis && this_._insideMethodBody) && !((this_._currentClass == null))) && _DartRestorerBase__needsLowering(this_, this_._currentClass!.name)) ? 1 : 0)))) {
      final int declIdx = (field.isThis ? (-1) : (_i - (capturedFields.any(ClosureEnv_anon_63()) ? 1 : 0)));
      if (((declIdx >= 0) && (declIdx < capturedDecls.length))) {
        final String? prefix = savedEnvPrefix[capturedDecls[declIdx]];
        if (!((prefix == null))) {
          constructArgsList.add('${prefix}${field.name}');
        }
 else {
          constructArgsList.add(field.name);
        }
      }
 else {
        constructArgsList.add(field.name);
      }
    }
 else {
      constructArgsList.add(field.name);
    }
  }
  final String constructArgs = constructArgsList.join(', ');
  return '${envClassName}${typeParamStr}(${constructArgs})';
}

void _ExpressionRestorer__collectTypeParameters(dynamic this__, DartType type, StaticSet<TypeParameter> result) {
  final this_ = this__;
  if ((type is TypeParameterType)) {
    result.add(type.parameter);
  }
 else   if ((type is InterfaceType)) {
    for (final arg in type.typeArguments) {
      _ExpressionRestorer__collectTypeParameters(this_, arg, result);
    }
  }
 else   if ((type is FunctionType)) {
    _ExpressionRestorer__collectTypeParameters(this_, type.returnType, result);
    for (final p in type.positionalParameters) {
      _ExpressionRestorer__collectTypeParameters(this_, p, result);
    }
    for (final n in type.namedParameters) {
      _ExpressionRestorer__collectTypeParameters(this_, n.type, result);
    }
  }
 else   if ((type is FutureOrType)) {
    _ExpressionRestorer__collectTypeParameters(this_, type.typeArgument, result);
  }
 else   if ((type is RecordType)) {
    for (final p in type.positional) {
      _ExpressionRestorer__collectTypeParameters(this_, p, result);
    }
    for (final n in type.named) {
      _ExpressionRestorer__collectTypeParameters(this_, n.type, result);
    }
  }
}

String? _ExpressionRestorer__extractMemberAccessOnVar(dynamic this__, Expression expr, VariableDeclaration targetVar) {
  final this_ = this__;
  if ((expr is InstanceGet)) {
    if (((expr.receiver is VariableGet) && ((expr.receiver as VariableGet).variable == targetVar))) {
      return expr.name.text;
    }
  }
  if ((expr is InstanceInvocation)) {
    if (((expr.receiver is VariableGet) && ((expr.receiver as VariableGet).variable == targetVar))) {
      final String args = _TypeUtils__restoreArgs(this_, expr.arguments);
      return '${expr.name.text}(${args})';
    }
  }
  if ((expr is InstanceSet)) {
    if (((expr.receiver is VariableGet) && ((expr.receiver as VariableGet).variable == targetVar))) {
      return '${expr.name.text} = ${_ExpressionRestorer__restoreExpr(this_, expr.value)}';
    }
  }
  if ((expr is AsExpression)) {
    return _ExpressionRestorer__extractMemberAccessOnVar(this_, expr.operand, targetVar);
  }
  return null;
}

bool _ExpressionRestorer__nullSafeReceiverNeedsLowering(dynamic this__, VariableDeclaration v) {
  final this_ = this__;
  final DartType varType = v.type;
  if ((varType is InterfaceType)) {
    final String className = varType.classNode.name;
    if (((_DartRestorerBase__isUserClass(this_, className) || _DartRestorerBase__isMixinName(this_, className)) || _DartRestorerBase__isEnumName(this_, className))) {
      return true;
    }
  }
  return false;
}

bool _ExpressionRestorer__cascadeReceiverNeedsLowering(dynamic this__, VariableDeclaration v) {
  final this_ = this__;
  final DartType varType = v.type;
  if ((varType is InterfaceType)) {
    final String rawName = varType.classNode.name;
    if (rawName.endsWith('Value')) {
      final String className = rawName.substring(0, (rawName.length - 5));
      if (((_DartRestorerBase__isUserClass(this_, className) || _DartRestorerBase__isMixinName(this_, className)) || _DartRestorerBase__isEnumName(this_, className))) {
        return true;
      }
    }
    final String className = _ExpressionRestorer__getActualClassName(this_, rawName);
    if (((_DartRestorerBase__isUserClass(this_, className) || _DartRestorerBase__isMixinName(this_, className)) || _DartRestorerBase__isEnumName(this_, className))) {
      return true;
    }
  }
  return false;
}

String _ExpressionRestorer__restoreRecordLiteral(dynamic this__, RecordLiteral expr) {
  final this_ = this__;
  final StaticList<String> parts = StaticList<String>.of([]);
  for (final p in expr.positional) {
    parts.add(_ExpressionRestorer__restoreExpr(this_, p));
  }
  for (final n in expr.named) {
    parts.add('${n.name}: ${_ExpressionRestorer__restoreExpr(this_, n.value)}');
  }
  return '(${parts.join(', ')})';
}

String _ExpressionRestorer__restoreRecordIndexGet(dynamic this__, RecordIndexGet expr) {
  final this_ = this__;
  final String recv = _ExpressionRestorer__restoreExpr(this_, expr.receiver);
  final int idx = (expr.index + 1);
  return '${recv}.\$${idx}';
}

String _ExpressionRestorer__restoreRecordNameGet(dynamic this__, RecordNameGet expr) {
  final this_ = this__;
  final String recv = _ExpressionRestorer__restoreExpr(this_, expr.receiver);
  return '${recv}.${expr.name}';
}


// mixin _StatementRestorer → static functions for delegation
void _StatementRestorer__restoreStmt(dynamic this__, Statement stmt) {
  final this_ = this__;
  if ((stmt is Block)) {
    _StatementRestorer__restoreBlock(this_, stmt);
  }
 else   if ((stmt is ReturnStatement)) {
    if (this_._insideAsyncFunction) {
      if (!((stmt.expression == null))) {
        final String exprStr = _DartRestorerBase__restoreExpr(this_, stmt.expression!);
        this_._buf.write('${this_._pad}env._promise.complete(${exprStr});\n');
      }
      this_._buf.write('${this_._pad}return;\n');
    }
 else {
      this_._buf.write('${this_._pad}return');
      if (!((stmt.expression == null))) {
        this_._buf.write(' ${_DartRestorerBase__restoreExpr(this_, stmt.expression!)}');
      }
      this_._buf.write(';\n');
    }
  }
 else   if ((stmt is ExpressionStatement)) {
    _StatementRestorer__restoreExprStmt(this_, stmt);
  }
 else   if ((stmt is VariableDeclaration)) {
    _StatementRestorer__restoreVarDecl(this_, stmt);
  }
 else   if ((stmt is IfStatement)) {
    this_._buf.write('${this_._pad}if (${_DartRestorerBase__restoreExpr(this_, stmt.condition)}) ');
    _StatementRestorer__restoreStmt(this_, stmt.then);
    if (!((stmt.otherwise == null))) {
      this_._buf.write(' else ');
      _StatementRestorer__restoreStmt(this_, stmt.otherwise!);
    }
  }
 else   if ((stmt is ForStatement)) {
    this_._buf.write('${this_._pad}for (');
    if (stmt.variables.isNotEmpty) {
      final VariableDeclaration v = stmt.variables.first;
      final String vName = _TypeUtils__cleanVarName(this_, (v.name ?? '_i'));
      v.name = vName;
      if (this_._boxedVars.contains(v)) {
        final String boxType = _TypeUtils__boxTypeNameFor(this_, v.type)!;
        final String initStr = (!((v.initializer == null)) ? _DartRestorerBase__restoreExpr(this_, v.initializer!) : _DartRestorerBase__defaultValueForType(this_, v.type));
        this_._buf.write('${boxType} ${vName} = ${boxType}(${initStr})');
      }
 else {
        this_._buf.write('var ${vName} = ${_DartRestorerBase__restoreExpr(this_, v.initializer!)}');
      }
    }
    this_._buf.write('; ');
    if (!((stmt.condition == null)))     this_._buf.write(_DartRestorerBase__restoreExpr(this_, stmt.condition!));
    this_._buf.write('; ');
    this_._buf.write(stmt.updates.map(ClosureEnv_anon_64(this_)).join(', '));
    this_._buf.write(') ');
    _StatementRestorer__restoreStmt(this_, stmt.body);
  }
 else   if ((stmt is WhileStatement)) {
    this_._buf.write('${this_._pad}while (${_DartRestorerBase__restoreExpr(this_, stmt.condition)}) ');
    _StatementRestorer__restoreStmt(this_, stmt.body);
  }
 else   if ((stmt is DoStatement)) {
    this_._buf.write('${this_._pad}do ');
    _StatementRestorer__restoreStmt(this_, stmt.body);
    this_._buf.write(' while (${_DartRestorerBase__restoreExpr(this_, stmt.condition)});\n');
  }
 else   if ((stmt is TryCatch)) {
    this_._buf.write('${this_._pad}try ');
    _StatementRestorer__restoreStmt(this_, stmt.body);
    for (final c in stmt.catches) {
      _StatementRestorer__restoreCatch(this_, c);
    }
  }
 else   if ((stmt is TryFinally)) {
    final Statement body = stmt.body;
    if ((body is TryCatch)) {
      this_._buf.write('${this_._pad}try ');
      _StatementRestorer__restoreStmt(this_, body.body);
      for (final c in body.catches) {
        _StatementRestorer__restoreCatch(this_, c);
      }
      this_._buf.write(' finally ');
      _StatementRestorer__restoreStmt(this_, stmt.finalizer);
    }
 else {
      this_._buf.write('${this_._pad}try ');
      _StatementRestorer__restoreStmt(this_, stmt.body);
      this_._buf.write(' finally ');
      _StatementRestorer__restoreStmt(this_, stmt.finalizer);
    }
  }
 else   if ((stmt is YieldStatement)) {
    this_._buf.write('${this_._pad}yield ');
    this_._buf.write(_DartRestorerBase__restoreExpr(this_, stmt.expression));
    this_._buf.write(';\n');
  }
 else   if ((stmt is AssertStatement)) {
    this_._buf.write('${this_._pad}assert(${_DartRestorerBase__restoreExpr(this_, stmt.condition)}');
    if (!((stmt.message == null))) {
      this_._buf.write(', ${_DartRestorerBase__restoreExpr(this_, stmt.message!)}');
    }
    this_._buf.write(');\n');
  }
 else   if ((stmt is SwitchStatement)) {
    _StatementRestorer__restoreSwitch(this_, stmt);
  }
 else   if ((stmt is LabeledStatement)) {
    this_._buf.write('${this_._pad}do {\n');
    this_._indent = (this_._indent + 1);
    _StatementRestorer__restoreStmt(this_, stmt.body);
    this_._indent = (this_._indent - 1);
    this_._buf.write('${this_._pad}} while (false);\n');
  }
 else   if ((stmt is BreakStatement)) {
    this_._buf.write('${this_._pad}break;\n');
  }
 else   if ((stmt is EmptyStatement)) {
  }
 else   if ((stmt is ForInStatement)) {
    _StatementRestorer__restoreForIn(this_, stmt);
  }
 else   if ((stmt is FunctionDeclaration)) {
    _StatementRestorer__restoreFuncDecl(this_, stmt);
  }
}

void _StatementRestorer__restoreForIn(dynamic this__, ForInStatement stmt) {
  final this_ = this__;
  final VariableDeclaration varDecl = stmt.variable;
  final String varName = _TypeUtils__cleanVarName(this_, (varDecl.name ?? '_item${(() { final _let70 = this_._varCounter; return (() { final _let71 = this_._varCounter = (_let70 + 1); return _let70; })(); })()}'));
  varDecl.name = varName;
  final String iterableExpr = _DartRestorerBase__restoreExpr(this_, stmt.iterable);
  final String keyword = (varDecl.isFinal ? 'final' : 'var');
  this_._buf.write('${this_._pad}for (${keyword} ${varName} in ${iterableExpr}) ');
  _StatementRestorer__restoreStmt(this_, stmt.body);
}

void _StatementRestorer__restoreBlock(dynamic this__, Block block) {
  final this_ = this__;
  this_._buf.write('{\n');
  this_._indent = (this_._indent + 1);
  for (final s in block.statements) {
    _StatementRestorer__restoreStmt(this_, s);
  }
  this_._indent = (this_._indent - 1);
  this_._buf.write('${this_._pad}}\n');
}

void _StatementRestorer__restoreExprStmt(dynamic this__, ExpressionStatement stmt) {
  final this_ = this__;
  final Expression expr = stmt.expression;
  if (_StatementRestorer__isReachabilityError(this_, expr))   return;
  if (((expr is Throw) && _StatementRestorer__isReachabilityError(this_, expr.expression)))   return;
  this_._buf.write('${this_._pad}${_DartRestorerBase__restoreExpr(this_, expr)};\n');
}

bool _StatementRestorer__isReachabilityError(dynamic this__, Expression expr) {
  final this_ = this__;
  if ((expr is ConstructorInvocation)) {
    return expr.target.enclosingClass.name.contains('ReachabilityError');
  }
  if ((expr is Throw))   return _StatementRestorer__isReachabilityError(this_, expr.expression);
  return false;
}

void _StatementRestorer__restoreVarDecl(dynamic this__, VariableDeclaration v) {
  final this_ = this__;
  final String originalName = (v.name ?? '_v${(() { final _let73 = this_._varCounter; return (() { final _let74 = this_._varCounter = (_let73 + 1); return _let73; })(); })()}');
  final String name = _TypeUtils__cleanVarName(this_, originalName);
  v.name = name;
  if (name.startsWith('_alreadyDeclared_')) {
    final String realName = name.substring('_alreadyDeclared_'.length);
    if (!((v.initializer == null))) {
      this_._buf.write('${this_._pad}${realName} = ${_DartRestorerBase__restoreExpr(this_, v.initializer!)};\n');
    }
    return;
  }
  if (this_._boxedVars.contains(v)) {
    final String boxType = _TypeUtils__boxTypeNameFor(this_, v.type)!;
    this_._buf.write(this_._pad);
    this_._buf.write('${boxType} ${name} = ${boxType}(');
    if (!((v.initializer == null))) {
      this_._buf.write(_DartRestorerBase__restoreExpr(this_, v.initializer!));
    }
 else {
      this_._buf.write(_DartRestorerBase__defaultValueForType(this_, v.type));
    }
    this_._buf.write(');\n');
    return;
  }
  this_._buf.write(this_._pad);
  final bool needsLate = (v.isLate || ((((v.initializer == null) && !(v.isFinal)) && !(v.isConst)) && !((v.type.nullability == Nullability.nullable))));
  if (needsLate)   this_._buf.write('late ');
  if (v.isConst)   this_._buf.write('const ');
 else   if (v.isFinal)   this_._buf.write('final ');
  this_._buf.write(_TypeUtils__restoreType(this_, v.type));
  this_._buf.write(' ${name}');
  if (!((v.initializer == null))) {
    this_._buf.write(' = ${_DartRestorerBase__restoreExpr(this_, v.initializer!)}');
  }
  this_._buf.write(';\n');
}

void _StatementRestorer__restoreCatch(dynamic this__, Catch c) {
  final this_ = this__;
  if ((c.guard is InterfaceType)) {
    final InterfaceType guardType = (c.guard as InterfaceType);
    final String guardName = guardType.classNode.name;
    if (!((guardName == 'Object'))) {
      this_._buf.write(' on ${guardName}');
    }
  }
  if (!((c.exception == null))) {
    this_._buf.write(' catch (');
    final String eName = _TypeUtils__cleanVarName(this_, (c.exception!.name ?? 'e'));
    c.exception!.name = eName;
    this_._buf.write(eName);
    if (!((c.stackTrace == null))) {
      final String stName = _TypeUtils__cleanVarName(this_, (c.stackTrace!.name ?? 'st'));
      c.stackTrace!.name = stName;
      this_._buf.write(', ${stName}');
    }
    this_._buf.write(')');
  }
  this_._buf.write(' ');
  _StatementRestorer__restoreStmt(this_, c.body);
}

void _StatementRestorer__restoreSwitch(dynamic this__, SwitchStatement stmt) {
  final this_ = this__;
  this_._buf.write('${this_._pad}switch (${_DartRestorerBase__restoreExpr(this_, stmt.expression)}) {\n');
  this_._indent = (this_._indent + 1);
  for (final c in stmt.cases) {
    if (c.isDefault) {
      this_._buf.write('${this_._pad}default:\n');
    }
 else {
      for (final e in c.expressions) {
        this_._buf.write('${this_._pad}case ${_DartRestorerBase__restoreExpr(this_, e)}:\n');
      }
    }
    this_._indent = (this_._indent + 1);
    _StatementRestorer__restoreStmt(this_, c.body);
    this_._indent = (this_._indent - 1);
  }
  this_._indent = (this_._indent - 1);
  this_._buf.write('${this_._pad}}\n');
}

void _StatementRestorer__restoreFuncDecl(dynamic this__, FunctionDeclaration stmt) {
  final this_ = this__;
  final String name = _TypeUtils__cleanVarName(this_, (stmt.variable.name ?? '_fn${(() { final _let78 = this_._varCounter; return (() { final _let79 = this_._varCounter = (_let78 + 1); return _let78; })(); })()}'));
  stmt.variable.name = name;
  this_._buf.write('${this_._pad}');
  this_._buf.write(_TypeUtils__restoreType(this_, stmt.function.returnType));
  this_._buf.write(' ${name}');
  _DartRestorerBase__writeTypeParams(this_, stmt.function.typeParameters);
  this_._buf.write('(');
  _DartRestorerBase__writeParams(this_, stmt.function);
  this_._buf.write(')');
  final AsyncMarker marker = stmt.function.asyncMarker;
  if ((marker == AsyncMarker.AsyncStar))   this_._buf.write(' async*');
  if ((marker == AsyncMarker.SyncStar))   this_._buf.write(' sync*');
  if (!((stmt.function.body == null))) {
    this_._buf.write(' ');
    _StatementRestorer__restoreStmt(this_, stmt.function.body!);
  }
  this_._buf.write('\n');
}


// mixin _DeclarationRestorer → static functions for delegation
void _DeclarationRestorer__restoreTypedef(dynamic this__, Typedef td) {
  final this_ = this__;
  this_._buf.write('typedef ${td.name}');
  _DeclarationRestorer__writeTypeParams(this_, td.typeParameters);
  this_._buf.write(' = ');
  this_._buf.write(_TypeUtils__restoreType(this_, td.type!));
  this_._buf.write(';\n\n');
}

void _DeclarationRestorer__restoreMixin(dynamic this__, Class cls) {
  final this_ = this__;
  this_._buf.write('// mixin ${cls.name} → static functions for delegation\n');
  _DeclarationRestorer__emitStaticFields(this_, cls, cls.name);
  this_._currentClass = cls;
  final String mixinName = cls.name;
  for (final proc in cls.procedures)   do {
{
      if (((proc.isStatic || proc.isFactory) || proc.isAbstract))       break;
      if (((proc.function.body == null) || (proc.function.body is EmptyStatement)))       break;
      _DeclarationRestorer__emitMixinMethodAsStatic(this_, cls, proc, mixinName);
    }
  } while (false);
  this_._currentClass = null;
  this_._buf.write('\n');
}

void _DeclarationRestorer__emitMixinMethodAsStatic(dynamic this__, Class cls, Procedure proc, String mixinName) {
  final this_ = this__;
  final String methodName = proc.name.text;
  late String funcName;
  if (proc.isGetter) {
    funcName = _DartRestorerBase__staticGetterName(this_, mixinName, methodName);
  }
 else   if (proc.isSetter) {
    funcName = _DartRestorerBase__staticSetterName(this_, mixinName, methodName);
  }
 else {
    funcName = _DartRestorerBase__staticMethodName(this_, mixinName, methodName);
  }
  final String returnType = _TypeUtils__restoreType(this_, proc.function.returnType);
  this_._buf.write('${returnType} ${funcName}');
  _DeclarationRestorer__writeCombinedTypeParams(this_, cls.typeParameters, proc.function.typeParameters);
  this_._buf.write('(dynamic this__');
  if (proc.isSetter) {
    if (proc.function.positionalParameters.isNotEmpty) {
      final VariableDeclaration p = proc.function.positionalParameters.first;
      final String paramName = _TypeUtils__cleanVarName(this_, (p.name ?? 'value'));
      this_._buf.write(', ${_TypeUtils__restoreType(this_, p.type)} ${paramName}');
    }
  }
 else   if (!(proc.isGetter)) {
    for (final p in proc.function.positionalParameters) {
      final String paramName = _TypeUtils__cleanVarName(this_, (p.name ?? '_p'));
      this_._buf.write(', ${_TypeUtils__restoreType(this_, p.type)} ${paramName}');
    }
    for (final p in proc.function.namedParameters) {
      final String paramName = _TypeUtils__cleanVarName(this_, (p.name ?? '_n'));
      final bool isRequired = p.isRequired;
      if (isRequired) {
        this_._buf.write(', {required ${_TypeUtils__restoreType(this_, p.type)} ${paramName}}');
      }
 else {
        this_._buf.write(', {${_TypeUtils__restoreType(this_, p.type)} ${paramName}');
        if (!((p.initializer == null))) {
          this_._buf.write(' = ${_DartRestorerBase__restoreExpr(this_, p.initializer!)}');
        }
        this_._buf.write('}');
      }
    }
  }
  this_._buf.write(')');
  final AsyncMarker marker = proc.function.asyncMarker;
  if ((marker == AsyncMarker.AsyncStar))   this_._buf.write(' async*');
  if ((marker == AsyncMarker.SyncStar))   this_._buf.write(' sync*');
  if (!((proc.function.body == null))) {
    this_._insideMethodBody = true;
    this_._thisReplacementName = 'this_';
    final bool isVoidReturn = ((proc.function.returnType is VoidType) || proc.isSetter);
    if (((marker == AsyncMarker.Async) && !(isVoidReturn))) {
      final DartType retType = proc.function.returnType;
      String innerRetType = 'dynamic';
      if (((retType is InterfaceType) && retType.typeArguments.isNotEmpty)) {
        innerRetType = _TypeUtils__restoreType(this_, retType.typeArguments.first);
      }
      final StaticList<VariableDeclaration> allParams = (() {       final StaticList<VariableDeclaration> _v83 = StaticList<VariableDeclaration>.of(proc.function.positionalParameters);
      _v83.addAll(proc.function.namedParameters);
 return _v83; })();
      final String envBaseName = '${mixinName}_${methodName}';
      this_._buf.write(' ');
      _DartRestorerBase__pushClosureContext(this_, envBaseName);
      _DeclarationRestorer__emitAsyncClosureEnvForMethod(this_, envBaseName: this_._closureContext, func: proc.function, innerReturnType: innerRetType, params: allParams, thisParam: 'dynamic', thisRawParam: 'this__');
      _DartRestorerBase__popClosureContext(this_);
    }
 else {
      this_._buf.write(' {\n');
      this_._indent = (this_._indent + 1);
      this_._buf.write('${this_._pad}final this_ = this__;\n');
      final Statement body = proc.function.body!;
      if ((body is Block)) {
        for (final s in body.statements)         do {
{
            if ((isVoidReturn && (s is ReturnStatement))) {
              if (!((s.expression == null))) {
                this_._buf.write('${this_._pad}${_DartRestorerBase__restoreExpr(this_, s.expression!)};\n');
              }
              break;
            }
            _DartRestorerBase__restoreStmt(this_, s);
          }
        } while (false);
      }
 else       if ((isVoidReturn && (body is ReturnStatement))) {
        if (!((body.expression == null))) {
          this_._buf.write('${this_._pad}${_DartRestorerBase__restoreExpr(this_, body.expression!)};\n');
        }
      }
 else {
        _DartRestorerBase__restoreStmt(this_, body);
      }
      this_._indent = (this_._indent - 1);
      this_._buf.write('${this_._pad}}\n');
    }
    this_._insideMethodBody = false;
  }
 else {
    this_._buf.write(';\n');
  }
  this_._buf.write('\n');
}

void _DeclarationRestorer__restoreClass(dynamic this__, Class cls) {
  final this_ = this__;
  if (_DeclarationRestorer__isEnumClass(this_, cls)) {
    _DeclarationRestorer__restoreEnum(this_, cls);
    return;
  }
  this_._currentClass = cls;
  final String loweredName = _DartRestorerBase__loweredClassName(this_, cls.name);
  if (_DartRestorerBase__isUserClass(this_, loweredName)) {
    _DeclarationRestorer__restoreClassLowered(this_, cls, loweredName);
  }
 else {
    _DeclarationRestorer__restoreClassOriginal(this_, cls);
  }
  this_._currentClass = null;
}

void _DeclarationRestorer__restoreClassLowered(dynamic this__, Class cls, String? overrideName) {
  final this_ = this__;
  final String className = (overrideName ?? cls.name);
  final String? parentName = _DartRestorerBase__getParentClassName(this_, className);
  final bool isSyntheticMixinClass = _DartRestorerBase__isSyntheticMixinClassName(this_, cls.name);
  final StaticMap<String, String> savedTypeParamSubstitution = this_._activeTypeParamSubstitution;
  final StaticSet<TypeParameter> savedTypeParamTargets = this_._activeTypeParamTargets;
  if (!((cls.supertype == null))) {
    final Supertype superType = cls.supertype!;
    final Class superClass = superType.classNode;
    if ((superClass.typeParameters.isNotEmpty && superType.typeArguments.isNotEmpty)) {
      final StaticSet<String?> currentTypeParamNames = StaticSet.of(cls.typeParameters.map(ClosureEnv_anon_65()).toSet().toList());
      final StaticMap<String, String> substitution = StaticMap<String, String>.of({});
      final StaticSet<TypeParameter> targets = StaticSet<TypeParameter>.of([]);
      for (var i = 0; ((i < superClass.typeParameters.length) && (i < superType.typeArguments.length)); i = (i + 1)) {
        final String paramName = (superClass.typeParameters[i].name ?? 'T${i}');
        if (!(currentTypeParamNames.contains(paramName))) {
          substitution[paramName] = _TypeUtils__restoreType(this_, superType.typeArguments[i]);
          targets.add(superClass.typeParameters[i]);
        }
      }
      if (substitution.isNotEmpty) {
        this_._activeTypeParamSubstitution = (() {         final StaticMap<String, String> _v86 = StaticMap<String, String>.of(this_._activeTypeParamSubstitution);
        _v86.addAll(substitution);
 return _v86; })();
        this_._activeTypeParamTargets = (() {         final StaticSet<TypeParameter> _v87 = StaticSet<TypeParameter>.of(this_._activeTypeParamTargets);
        _v87.addAll(targets);
 return _v87; })();
      }
    }
  }
  _DeclarationRestorer__emitValueClass(this_, cls, className, parentName, isSyntheticMixinClass);
  if (isSyntheticMixinClass) {
    this_._buf.write('\n');
    return;
  }
  _DeclarationRestorer__emitStaticFields(this_, cls, className);
  for (final ctor in cls.constructors) {
    _DeclarationRestorer__emitConstructorFunction(this_, cls, ctor, className, parentName);
  }
  final StaticSet<String> definedMethods = StaticSet<String>.of([]);
  for (final proc in cls.procedures)   do {
{
      if ((proc.isStatic || proc.isFactory))       break;
      definedMethods.add(proc.name.text);
    }
  } while (false);
  for (final proc in cls.procedures) {
    if ((proc.isStatic || proc.isFactory)) {
      _DeclarationRestorer__emitStaticOrFactoryProcedure(this_, cls, proc, className);
    }
 else {
      _DeclarationRestorer__emitInstanceMethodAsStatic(this_, cls, proc, className);
    }
  }
  final StaticList<_VTableEntryValue> allEntries = _DeclarationRestorer__collectAllVTableEntries(this_, className);
  for (final entry in allEntries) {
    if (!(definedMethods.contains(entry.name))) {
      _DeclarationRestorer__emitDelegateMethodAsStatic(this_, cls, entry, className);
    }
  }
  this_._activeTypeParamSubstitution = savedTypeParamSubstitution;
  this_._activeTypeParamTargets = savedTypeParamTargets;
  this_._buf.write('\n');
}

void _DeclarationRestorer__emitDelegateMethodAsStatic(dynamic this__, Class cls, _VTableEntryValue entry, String className) {
  final this_ = this__;
  final String methodName = entry.name;
  final Procedure? proc = entry.proc;
  if (!((proc == null))) {
    _DeclarationRestorer__emitDelegateFromProc(this_, cls, proc, entry, className);
    return;
  }
  late String funcName;
  if ((entry.kind == 'getter')) {
    funcName = _DartRestorerBase__staticGetterName(this_, className, methodName);
  }
 else   if ((entry.kind == 'setter')) {
    funcName = _DartRestorerBase__staticSetterName(this_, className, methodName);
  }
 else {
    funcName = _DartRestorerBase__staticMethodName(this_, className, methodName);
  }
  this_._buf.write('${this_._pad}dynamic ${funcName}(${className}Value this_) {\n');
  this_._indent = (this_._indent + 1);
  this_._buf.write('${this_._pad}throw UnimplementedError(\'${className}.${methodName} delegate missing proc\');\n');
  this_._indent = (this_._indent - 1);
  this_._buf.write('}\n\n');
}

void _DeclarationRestorer__emitDelegateFromProc(dynamic this__, Class cls, Procedure proc, _VTableEntryValue entry, String className) {
  final this_ = this__;
  final String methodName = entry.name;
  late String funcName;
  if ((entry.kind == 'getter')) {
    funcName = _DartRestorerBase__staticGetterName(this_, className, methodName);
  }
 else   if ((entry.kind == 'setter')) {
    funcName = _DartRestorerBase__staticSetterName(this_, className, methodName);
  }
 else {
    funcName = _DartRestorerBase__staticMethodName(this_, className, methodName);
  }
  final Class? originClass = proc.enclosingClass;
  String originClassName = (!((originClass == null)) ? _DartRestorerBase__loweredClassName(this_, originClass.name) : className);
  if (this_._syntheticLoweredNames.contains(originClassName)) {
    Procedure realProc = proc;
    StaticSet<Procedure> visited = StaticSet<Procedure>.of([proc]);
    do {
      while ((realProc.stubTarget is Procedure)) {
        final Procedure target = (realProc.stubTarget as Procedure);
        if (visited.contains(target))         break;
        visited.add(target);
        realProc = target;
      }
    } while (false);
    final Class? realOriginClass = realProc.enclosingClass;
    if (!((realOriginClass == null))) {
      final String realOriginName = _DartRestorerBase__loweredClassName(this_, realOriginClass.name);
      if ((_DartRestorerBase__isMixinName(this_, realOriginName) || (!(this_._syntheticLoweredNames.contains(realOriginName)) && _DartRestorerBase__isUserClass(this_, realOriginName)))) {
        originClassName = realOriginName;
      }
    }
    if (((this_._syntheticLoweredNames.contains(originClassName) && !((originClass == null))) && originClass.name.contains('&'))) {
      final StaticList<String> parts = originClass.name.split('&');
      if (parts.isNotEmpty) {
        final String lastMixin = parts.last.trim();
        if (_DartRestorerBase__isMixinName(this_, lastMixin)) {
          originClassName = lastMixin;
        }
      }
    }
    if (this_._syntheticLoweredNames.contains(originClassName)) {
      Class? searchClass = originClass;
      do {
        while (!((searchClass == null))) {
          final Supertype? superType = searchClass.supertype;
          if ((superType == null))           break;
          searchClass = superType.classNode;
          do {
            for (final p in searchClass.procedures) {
              if (((p.name.text == proc.name.text) && (p.kind == proc.kind))) {
                final String searchName = _DartRestorerBase__loweredClassName(this_, searchClass.name);
                if ((_DartRestorerBase__isMixinName(this_, searchName) || (!(this_._syntheticLoweredNames.contains(searchName)) && _DartRestorerBase__isUserClass(this_, searchName)))) {
                  originClassName = searchName;
                  break;
                }
              }
            }
          } while (false);
          if (!(this_._syntheticLoweredNames.contains(originClassName)))           break;
        }
      } while (false);
    }
    if (this_._syntheticLoweredNames.contains(originClassName)) {
      String? parentName = _DartRestorerBase__getParentClassName(this_, className);
      do {
        while (!((parentName == null))) {
          if (((!(this_._syntheticLoweredNames.contains(parentName)) && !(_DartRestorerBase__isMixinName(this_, parentName))) && _DartRestorerBase__isUserClass(this_, parentName))) {
            final StaticList<_VTableEntryValue>? parentEntries = this_._classVTableEntries[parentName];
            if ((!((parentEntries == null)) && parentEntries.any(ClosureEnv_anon_66(methodName, entry)))) {
              originClassName = parentName;
              break;
            }
          }
          parentName = _DartRestorerBase__getParentClassName(this_, parentName);
        }
      } while (false);
    }
  }
  late String originFuncName;
  if ((entry.kind == 'getter')) {
    originFuncName = _DartRestorerBase__staticGetterName(this_, originClassName, methodName);
  }
 else   if ((entry.kind == 'setter')) {
    originFuncName = _DartRestorerBase__staticSetterName(this_, originClassName, methodName);
  }
 else {
    originFuncName = _DartRestorerBase__staticMethodName(this_, originClassName, methodName);
  }
  final StaticMap<String, String> typeSubstitution = _DeclarationRestorer__buildTypeSubstitutionForDelegate(this_, cls, proc);
  String restoreTypeWithSub(DartType type) {
    if (typeSubstitution.isEmpty)     return _TypeUtils__restoreType(this_, type);
    if ((type is TypeParameterType)) {
      final String paramName = (type.parameter.name ?? 'T');
      final String? replacement = typeSubstitution[paramName];
      if (!((replacement == null))) {
        final bool nullable = (type.nullability == Nullability.nullable);
        return (nullable ? '${replacement}?' : replacement);
      }
    }
    String result = _TypeUtils__restoreType(this_, type);
    for (final entry in typeSubstitution.entries) {
      result = result.replaceAll(RegExp('\b${entry.key}\b'), entry.value);
    }
    return result;
  }

  final String returnType = restoreTypeWithSub(proc.function.returnType);
  this_._buf.write(this_._pad);
  this_._buf.write('${returnType} ${funcName}');
  if (typeSubstitution.isNotEmpty) {
    _DeclarationRestorer__writeCombinedTypeParams(this_, cls.typeParameters, proc.function.typeParameters);
  }
 else {
    _DeclarationRestorer__writeCombinedTypeParams(this_, cls.typeParameters, proc.function.typeParameters);
  }
  this_._buf.write('(dynamic this__');
  final StaticList<String> forwardArgs = StaticList<String>.of(['this_']);
  if ((entry.kind == 'setter')) {
    if (proc.function.positionalParameters.isNotEmpty) {
      final VariableDeclaration p = proc.function.positionalParameters.first;
      final String paramName = _TypeUtils__cleanVarName(this_, (p.name ?? 'value'));
      this_._buf.write(', ${restoreTypeWithSub(p.type)} ${paramName}');
      forwardArgs.add(paramName);
    }
  }
 else   if (!((entry.kind == 'getter'))) {
    for (final p in proc.function.positionalParameters) {
      final String paramName = _TypeUtils__cleanVarName(this_, (p.name ?? '_p'));
      this_._buf.write(', ${restoreTypeWithSub(p.type)} ${paramName}');
      forwardArgs.add(paramName);
    }
    for (final p in proc.function.namedParameters) {
      final String paramName = _TypeUtils__cleanVarName(this_, (p.name ?? '_n'));
      this_._buf.write(', {${restoreTypeWithSub(p.type)} ${paramName}}');
    }
  }
  this_._buf.write(') {\n');
  this_._indent = (this_._indent + 1);
  final String delegateClassTypeParamStr = (cls.typeParameters.isNotEmpty ? '<${cls.typeParameters.map(ClosureEnv_anon_67()).join(', ')}>' : '');
  this_._buf.write('${this_._pad}final this_ = this__ as ${className}Value${delegateClassTypeParamStr};\n');
  final bool isAbstractOrigin = (proc.isAbstract || (proc.function.body == null));
  if ((isAbstractOrigin && (entry.kind == 'getter'))) {
    this_._buf.write('${this_._pad}return this_.${methodName};\n');
  }
 else   if ((isAbstractOrigin && (entry.kind == 'setter'))) {
    final String valueName = ((forwardArgs.length > 1) ? forwardArgs[1] : 'value');
    this_._buf.write('${this_._pad}this_.${methodName} = ${valueName};\n');
  }
 else {
    if ((!((returnType == 'void')) || (entry.kind == 'getter'))) {
      this_._buf.write('${this_._pad}return ');
    }
 else {
      this_._buf.write(this_._pad);
    }
    final StaticList<String> originTypeArgs = _DeclarationRestorer__buildOriginTypeArgs(this_, cls, proc, originClassName);
    final String originTypeArgStr = (originTypeArgs.isEmpty ? '' : '<${originTypeArgs.join(', ')}>');
    this_._buf.write('${originFuncName}${originTypeArgStr}(${forwardArgs.join(', ')});\n');
  }
  this_._indent = (this_._indent - 1);
  this_._buf.write('}\n\n');
}

StaticList<String> _DeclarationRestorer__buildOriginTypeArgs(dynamic this__, Class cls, Procedure proc, String originClassName) {
  final this_ = this__;
  final StaticList<String> result = StaticList<String>.of([]);
  final Class? originClass = (this_._classNodes[originClassName] ?? proc.enclosingClass);
  if (((!((originClass == null)) && !((originClass == cls))) && originClass.typeParameters.isNotEmpty)) {
    final StaticList<String>? concreteArgs = _DeclarationRestorer__resolveOriginConcreteTypeArgs(this_, cls, originClass);
    if ((!((concreteArgs == null)) && (concreteArgs.length == originClass.typeParameters.length))) {
      result.addAll(concreteArgs);
    }
 else {
      final StaticSet<String?> clsParamNames = StaticSet.of(cls.typeParameters.map(ClosureEnv_anon_68()).toSet().toList());
      for (final tp in originClass.typeParameters) {
        final String name = (tp.name ?? 'T');
        result.add((clsParamNames.contains(name) ? name : 'dynamic'));
      }
    }
  }
  final StaticSet<String> addedNames = StaticSet.of(result.toSet().toList());
  for (final tp in proc.function.typeParameters) {
    final String name = (tp.name ?? 'T');
    if (!(addedNames.contains(name))) {
      result.add(name);
    }
  }
  return result;
}

StaticList<String>? _DeclarationRestorer__resolveOriginConcreteTypeArgs(dynamic this__, Class cls, Class originClass) {
  final this_ = this__;
  final StaticList<String>? viaExtends = _DeclarationRestorer__resolveConcreteTypeArgsForAncestor(this_, cls, originClass);
  if (!((viaExtends == null)))   return viaExtends;
  Class currentClass = cls;
  final StaticMap<String, String> typeParamMap = StaticMap<String, String>.of({});
  for (final tp in cls.typeParameters) {
    final String name = (tp.name ?? 'T');
    typeParamMap[name] = name;
  }
  while (true) {
    final Supertype? superType = currentClass.supertype;
    if ((superType == null))     return null;
    final Supertype? mixedIn = currentClass.mixedInType;
    if ((!((mixedIn == null)) && (mixedIn.classNode == originClass))) {
      if (mixedIn.typeArguments.isEmpty)       return null;
      return StaticList.of(mixedIn.typeArguments.map(ClosureEnv_anon_69(this_, typeParamMap)).toList());
    }
    final Class nextClass = superType.classNode;
    if ((nextClass == originClass)) {
      if (superType.typeArguments.isEmpty)       return null;
      return StaticList.of(superType.typeArguments.map(ClosureEnv_anon_70(this_, typeParamMap)).toList());
    }
    final StaticMap<String, String> newMap = StaticMap<String, String>.of({});
    for (var i = 0; ((i < nextClass.typeParameters.length) && (i < superType.typeArguments.length)); i = (i + 1)) {
      final String paramName = (nextClass.typeParameters[i].name ?? 'T${i}');
      final String argStr = _TypeUtils__restoreType(this_, superType.typeArguments[i]);
      newMap[paramName] = _DeclarationRestorer__substituteTypeStr(this_, argStr, typeParamMap);
    }
    (typeParamMap..clear()..addAll(newMap));
    currentClass = nextClass;
  }
}

String _DeclarationRestorer__substituteTypeStr(dynamic this__, String typeStr, StaticMap<String, String> map) {
  final this_ = this__;
  if (map.isEmpty)   return typeStr;
  String result = typeStr;
  map.forEach(ClosureEnv_anon_71(result));
  return result;
}

StaticMap<String, String> _DeclarationRestorer__buildTypeSubstitutionForDelegate(dynamic this__, Class cls, Procedure proc) {
  final this_ = this__;
  final Class? originClass = proc.enclosingClass;
  if ((originClass == null))   return StaticMap<String, String>.of({});
  if ((originClass == cls))   return StaticMap<String, String>.of({});
  if (originClass.typeParameters.isEmpty)   return StaticMap<String, String>.of({});
  final StaticSet<String?> currentTypeParamNames = StaticSet.of(cls.typeParameters.map(ClosureEnv_anon_73()).toSet().toList());
  final StaticSet<String?> parentTypeParamNames = StaticSet.of(originClass.typeParameters.map(ClosureEnv_anon_74()).toSet().toList());
  if (parentTypeParamNames.every(ClosureEnv_anon_75(currentTypeParamNames)))   return StaticMap<String, String>.of({});
  final StaticList<String>? concreteTypeArgs = _DeclarationRestorer__resolveConcreteTypeArgsForAncestor(this_, cls, originClass);
  if (((concreteTypeArgs == null) || concreteTypeArgs.isEmpty))   return StaticMap<String, String>.of({});
  final StaticMap<String, String> substitution = StaticMap<String, String>.of({});
  for (var i = 0; ((i < originClass.typeParameters.length) && (i < concreteTypeArgs.length)); i = (i + 1)) {
    final String paramName = (originClass.typeParameters[i].name ?? 'T${i}');
    substitution[paramName] = concreteTypeArgs[i];
  }
  return substitution;
}

void _DeclarationRestorer__emitValueClass(dynamic this__, Class cls, String className, String? parentName, bool isSyntheticMixinClass) {
  final this_ = this__;
  this_._buf.write('class ${className}Value');
  _DeclarationRestorer__writeTypeParams(this_, cls.typeParameters);
  final bool hasUserParent = (!((parentName == null)) && _DartRestorerBase__isUserClass(this_, parentName));
  final Supertype? superType = cls.supertype;
  if (hasUserParent) {
    String parentTypeArgs = '';
    if ((!((superType == null)) && superType.typeArguments.isNotEmpty)) {
      final StaticList<String> concreteArgs = StaticList.of(superType.typeArguments.map(ClosureEnv_anon_76(this_)).toList());
      if (concreteArgs.isNotEmpty) {
        parentTypeArgs = '<${concreteArgs.join(', ')}>';
      }
    }
    this_._buf.write(' extends ${parentName}Value${parentTypeArgs}');
  }
 else   if (((!((parentName == null)) && !(_DartRestorerBase__isUserClass(this_, parentName))) && !((superType == null)))) {
    String parentTypeArgs = '';
    if (superType.typeArguments.isNotEmpty) {
      final StaticList<String> concreteArgs = StaticList.of(superType.typeArguments.map(ClosureEnv_anon_77(this_)).toList());
      if (concreteArgs.isNotEmpty) {
        parentTypeArgs = '<${concreteArgs.join(', ')}>';
      }
    }
    this_._buf.write(' extends ${parentName}${parentTypeArgs}');
  }
 else {
    this_._buf.write(' extends VPtr');
  }
  final StaticList<String> implementedInterfaces = _DeclarationRestorer__collectUserImplementedInterfaces(this_, cls, className);
  if (implementedInterfaces.isNotEmpty) {
    this_._buf.write(' implements ');
    this_._buf.write(implementedInterfaces.join(', '));
  }
  this_._buf.write(' {\n');
  this_._indent = (this_._indent + 1);
  final StaticList<Field> fieldsToEmit = StaticList<Field>.of([]);
  if (hasUserParent) {
    _DeclarationRestorer__collectOwnFields(this_, cls, fieldsToEmit);
  }
 else {
    _DeclarationRestorer__collectAllFields(this_, cls, fieldsToEmit, StaticSet<String>.of([]));
  }
  final StaticMap<String, String> mixinTypeSubstitution = _DeclarationRestorer__buildMixinFieldTypeSubstitution(this_, cls);
  for (final field in fieldsToEmit)   do {
{
      if (field.isStatic)       break;
      this_._buf.write('${this_._pad}');
      this_._buf.write('late ');
      String fieldTypeStr = _TypeUtils__restoreType(this_, field.type);
      if (mixinTypeSubstitution.isNotEmpty) {
        fieldTypeStr = _DeclarationRestorer__substituteTypeStr(this_, fieldTypeStr, mixinTypeSubstitution);
      }
      this_._buf.write(fieldTypeStr);
      this_._buf.write(' ${field.name.text}');
      this_._buf.write(';\n');
    }
  } while (false);
  final bool hasRuntimeParent = ((!((parentName == null)) && !(_DartRestorerBase__isUserClass(this_, parentName))) && !((superType == null)));
  if (hasRuntimeParent) {
    this_._buf.write('${this_._pad}late Map<String, dynamic> vptr = <String, dynamic>{};\n');
    _DeclarationRestorer__emitRuntimeParentBridgeMethods(this_, cls, parentName!);
  }
  _DeclarationRestorer__emitValueClassConstructor(this_, cls, className, parentName, isSyntheticMixinClass);
  this_._indent = (this_._indent - 1);
  this_._buf.write('}\n\n');
}

void _DeclarationRestorer__emitValueClassConstructor(dynamic this__, Class cls, String className, String? parentName, bool isSyntheticMixinClass) {
  final this_ = this__;
  if (isSyntheticMixinClass) {
    _DeclarationRestorer__emitSyntheticMixinValueConstructor(this_, cls, className, parentName);
    return;
  }
  final StaticList<_VTableEntryValue> entries = _DeclarationRestorer__collectAllVTableEntries(this_, className);
  if (entries.isEmpty)   return;
  final bool hasClassTypeParams = cls.typeParameters.isNotEmpty;
  final StaticList<String> typeParamNames = StaticList.of(cls.typeParameters.map(ClosureEnv_anon_78()).toList());
  final String typeParamStr = (hasClassTypeParams ? '<${typeParamNames.join(', ')}>' : '');
  final StaticSet<String?> classTpNames = StaticSet.of(cls.typeParameters.map(ClosureEnv_anon_79()).toSet().toList());
  final StaticList<_VTableEntryValue> normalEntries = StaticList<_VTableEntryValue>.of([]);
  for (final entry in entries)   do {
{
      if (!((entry.proc == null))) {
        final StaticList<TypeParameter> dedupedMethodTps = StaticList.of(entry.proc!.function.typeParameters.where(ClosureEnv_anon_80(classTpNames)).toList());
        if (dedupedMethodTps.isNotEmpty) {
          break;
        }
      }
      normalEntries.add(entry);
    }
  } while (false);
  if (normalEntries.isEmpty)   return;
  this_._buf.write('${this_._pad}${className}Value() {\n');
  this_._indent = (this_._indent + 1);
  for (final entry in normalEntries) {
    final String key = _DeclarationRestorer__vptrEntryKey(this_, entry);
    final String rhs = _DeclarationRestorer__buildVptrLambdaWrapper(this_, cls, entry, className, typeParamStr);
    this_._buf.write('${this_._pad}vptr[\'${key}\'] = ${rhs};\n');
  }
  this_._indent = (this_._indent - 1);
  this_._buf.write('${this_._pad}}\n');
}

void _DeclarationRestorer__emitSyntheticMixinValueConstructor(dynamic this__, Class cls, String className, String? parentName) {
  final this_ = this__;
  final StaticSet<String> mixinMethodNames = StaticSet<String>.of([]);
  if (!((cls.mixedInType == null))) {
    final Class mixinCls = cls.mixedInType!.classNode;
    for (final p in mixinCls.procedures)     do {
{
        if (((p.isStatic || p.isFactory) || p.isAbstract))         break;
        mixinMethodNames.add(p.name.text);
      }
    } while (false);
  }
  if (mixinMethodNames.isEmpty)   return;
  final StaticList<_VTableEntryValue> allEntries = (this_._classVTableEntries[className] ?? StaticList<_VTableEntryValue>.of([]));
  final StaticList<_VTableEntryValue> mixinEntries = StaticList.of(allEntries.where(ClosureEnv_anon_81(mixinMethodNames)).toList());
  if (mixinEntries.isEmpty)   return;
  this_._buf.write('${this_._pad}${className}Value() {\n');
  this_._indent = (this_._indent + 1);
  final Class mixinClass = cls.mixedInType!.classNode;
  for (final entry in mixinEntries) {
    final String key = _DeclarationRestorer__vptrEntryKey(this_, entry);
    final String mixinName = mixinClass.name;
    late String staticFuncName;
    if ((entry.kind == 'getter')) {
      staticFuncName = _DartRestorerBase__staticGetterName(this_, mixinName, entry.name);
    }
 else     if ((entry.kind == 'setter')) {
      staticFuncName = _DartRestorerBase__staticSetterName(this_, mixinName, entry.name);
    }
 else {
      staticFuncName = _DartRestorerBase__staticMethodName(this_, mixinName, entry.name);
    }
    late String rhs;
    if (!((entry.proc == null))) {
      final StaticSet<String?> mixinClassTpNames = StaticSet.of(mixinClass.typeParameters.map(ClosureEnv_anon_82()).toSet().toList());
      final StaticList<TypeParameter> methodTpsDedup = StaticList.of(entry.proc!.function.typeParameters.where(ClosureEnv_anon_83(mixinClassTpNames)).toList());
      final StaticList<String> wrapperTpDecls = (() {       final StaticList<String> _v102 = StaticList<String>.of(mixinClass.typeParameters.map(/* unknown: InstanceTearOff */));
 return _v102; })();
      final StaticList<String> callTypeArgsList = (() {       final StaticList<String> _v103 = StaticList<String>.of(mixinClass.typeParameters.map(ClosureEnv_anon_84()));
      _v103.addAll(methodTpsDedup.map(ClosureEnv_anon_85()));
 return _v103; })();
      final String callTypeArgsStr = (callTypeArgsList.isEmpty ? '' : '<${callTypeArgsList.join(', ')}>');
      final StaticMap<String, String> methodTpToDynamic = (() {       final StaticMap<String, String> _v105 = StaticMap<String, String>.of({});
      for (final tp in methodTpsDedup)       if (!((tp.name == null)))       _v105[tp.name!] = 'dynamic';
 return _v105; })();
      rhs = _DeclarationRestorer__buildTearOffWrapperExpr(this_, staticFuncName: staticFuncName, callTypeArgsStr: callTypeArgsStr, functionNode: entry.proc!.function, hostingCls: mixinClass, methodTpNames: wrapperTpDecls, additionalSubstitution: methodTpToDynamic);
    }
 else {
      rhs = staticFuncName;
    }
    this_._buf.write('${this_._pad}vptr[\'${key}\'] = ${rhs};\n');
  }
  this_._indent = (this_._indent - 1);
  this_._buf.write('${this_._pad}}\n');
}

void _DeclarationRestorer__emitRuntimeParentBridgeMethods(dynamic this__, Class cls, String parentName) {
  final this_ = this__;
  final Class? superClass = cls.supertype?.classNode;
  if ((superClass == null))   return;
  final StaticList<Procedure> abstractMethods = StaticList<Procedure>.of([]);
  _DeclarationRestorer__collectAbstractMethodsFromChain(this_, superClass, abstractMethods, StaticSet<String>.of([]));
  for (final method in abstractMethods) {
    final String methodName = method.name.text;
    final String returnType = _TypeUtils__restoreType(this_, method.function.returnType);
    final StaticList<VariableDeclaration> params = method.function.positionalParameters;
    final String paramStr = params.map(ClosureEnv_anon_86(this_)).join(', ');
    this_._buf.write('${this_._pad}@override\n');
    this_._buf.write('${this_._pad}${returnType} ${methodName}(${paramStr}) {\n');
    this_._indent = (this_._indent + 1);
    this_._buf.write('${this_._pad}return (vptr[\'${methodName}\'] as TypeFunction1<${returnType}, dynamic>)(this);\n');
    this_._indent = (this_._indent - 1);
    this_._buf.write('${this_._pad}}\n');
  }
}

void _DeclarationRestorer__collectAbstractMethodsFromChain(dynamic this__, Class cls, StaticList<Procedure> result, StaticSet<String> visited) {
  final this_ = this__;
  for (final proc in cls.procedures) {
    if ((proc.isAbstract && !(visited.contains(proc.name.text)))) {
      visited.add(proc.name.text);
      result.add(proc);
    }
  }
  final Supertype? superType = cls.supertype;
  if ((!((superType == null)) && !((superType.classNode.name == 'Object')))) {
    _DeclarationRestorer__collectAbstractMethodsFromChain(this_, superType.classNode, result, visited);
  }
}

StaticList<String> _DeclarationRestorer__collectUserImplementedInterfaces(dynamic this__, Class cls, String className) {
  final this_ = this__;
  final StaticList<String> interfaces = StaticList<String>.of([]);
  final StaticSet<String> visited = StaticSet<String>.of([]);
  void collectFromClass(Class currentCls) {
    for (final implType in currentCls.implementedTypes)     do {
{
        final String implClassName = _ExpressionRestorer__getActualClassName(this_, implType.classNode.name);
        if (visited.contains(implClassName))         break;
        visited.add(implClassName);
        if (((_DartRestorerBase__isUserClass(this_, implClassName) && !(_DartRestorerBase__isMixinName(this_, implClassName))) && !(this_._syntheticLoweredNames.contains(implClassName)))) {
          final StringBuffer buf = StringBuffer('${implClassName}Value');
          if (implType.typeArguments.isNotEmpty) {
            buf.write('<');
            buf.write(implType.typeArguments.map(ClosureEnv_anon_87(this_)).join(', '));
            buf.write('>');
          }
          interfaces.add(buf.toString());
        }
      }
    } while (false);
    final Supertype? superType = currentCls.supertype;
    if (!((superType == null))) {
      final String superName = _ExpressionRestorer__getActualClassName(this_, superType.classNode.name);
      if ((this_._syntheticLoweredNames.contains(superName) || _DartRestorerBase__isSyntheticMixinClassName(this_, superType.classNode.name))) {
        collectFromClass(superType.classNode);
      }
    }
  }

  collectFromClass(cls);
  return interfaces;
}

StaticMap<String, String> _DeclarationRestorer__buildMixinFieldTypeSubstitution(dynamic this__, Class cls) {
  final this_ = this__;
  final StaticMap<String, String> substitution = StaticMap<String, String>.of({});
  if (!((cls.mixedInType == null))) {
    final Class mixinClass = cls.mixedInType!.classNode;
    final StaticList<DartType> mixedInArgs = cls.mixedInType!.typeArguments;
    for (var i = 0; ((i < mixinClass.typeParameters.length) && (i < mixedInArgs.length)); i = (i + 1)) {
      final String mixinParamName = (mixinClass.typeParameters[i].name ?? 'T${i}');
      final String actualType = _TypeUtils__restoreType(this_, mixedInArgs[i]);
      if (!((mixinParamName == actualType))) {
        substitution[mixinParamName] = actualType;
      }
    }
  }
  Class currentClass = cls;
  do {
    while (!((currentClass.supertype == null))) {
      final Class superCls = currentClass.supertype!.classNode;
      if (!(_DartRestorerBase__isSyntheticMixinClassName(this_, superCls.name)))       break;
      if (!((superCls.mixedInType == null))) {
        final Class mixinClass = superCls.mixedInType!.classNode;
        final StaticList<DartType> mixedInArgs = superCls.mixedInType!.typeArguments;
        final StaticList<DartType> superTypeArgs = currentClass.supertype!.typeArguments;
        final StaticMap<String, String> superParamMap = StaticMap<String, String>.of({});
        for (var i = 0; ((i < superCls.typeParameters.length) && (i < superTypeArgs.length)); i = (i + 1)) {
          final String paramName = (superCls.typeParameters[i].name ?? 'T${i}');
          superParamMap[paramName] = _TypeUtils__restoreType(this_, superTypeArgs[i]);
        }
        for (var i = 0; ((i < mixinClass.typeParameters.length) && (i < mixedInArgs.length)); i = (i + 1)) {
          final String mixinParamName = (mixinClass.typeParameters[i].name ?? 'T${i}');
          String actualType = _TypeUtils__restoreType(this_, mixedInArgs[i]);
          actualType = _DeclarationRestorer__substituteTypeStr(this_, actualType, superParamMap);
          actualType = _DeclarationRestorer__substituteTypeStr(this_, actualType, substitution);
          if (!((mixinParamName == actualType))) {
            substitution[mixinParamName] = actualType;
          }
        }
      }
      currentClass = superCls;
    }
  } while (false);
  return substitution;
}

void _DeclarationRestorer__emitObjectMethodOverrides(dynamic this__, Class cls, String className, String? parentName) {
  final this_ = this__;
  final bool hasToString = (_DeclarationRestorer__classHasVTableEntry(this_, className, 'toString_', 'method') || _DeclarationRestorer__classHasVTableEntry(this_, className, 'toString', 'method'));
  final bool hasOperatorEq = _DeclarationRestorer__classHasVTableEntry(this_, className, '==', 'operator');
  final bool hasHashCode = _DeclarationRestorer__classHasVTableEntry(this_, className, 'hashCode', 'getter');
  if (hasToString) {
    this_._buf.write('${this_._pad}@override\n');
    this_._buf.write('${this_._pad}String toString() {\n');
    this_._indent = (this_._indent + 1);
    this_._buf.write('${this_._pad}final toStringFn = vptr[\'toString_\'];\n');
    this_._buf.write('${this_._pad}if (toStringFn != null) return (toStringFn as TypeFunction1<String, dynamic>)(this);\n');
    this_._buf.write('${this_._pad}return super.toString();\n');
    this_._indent = (this_._indent - 1);
    this_._buf.write('${this_._pad}}\n');
  }
  if (hasOperatorEq) {
    this_._buf.write('${this_._pad}@override\n');
    this_._buf.write('${this_._pad}bool operator ==(Object other) {\n');
    this_._indent = (this_._indent + 1);
    this_._buf.write('${this_._pad}final eqFn = vptr[\'operatorEq\'];\n');
    this_._buf.write('${this_._pad}if (eqFn != null) return (eqFn as TypeFunction2<bool, dynamic, dynamic>)(this, other);\n');
    this_._buf.write('${this_._pad}return identical(this, other);\n');
    this_._indent = (this_._indent - 1);
    this_._buf.write('${this_._pad}}\n');
  }
  if (hasHashCode) {
    this_._buf.write('${this_._pad}@override\n');
    this_._buf.write('${this_._pad}int get hashCode {\n');
    this_._indent = (this_._indent + 1);
    this_._buf.write('${this_._pad}final hashFn = vptr[\'get_hashCode\'];\n');
    this_._buf.write('${this_._pad}if (hashFn != null) return (hashFn as TypeFunction1<int, dynamic>)(this);\n');
    this_._buf.write('${this_._pad}return super.hashCode;\n');
    this_._indent = (this_._indent - 1);
    this_._buf.write('${this_._pad}}\n');
  }
}

bool _DeclarationRestorer__classHasVTableEntry(dynamic this__, String className, String entryName, String kind) {
  final this_ = this__;
  final StaticList<_VTableEntryValue>? entries = this_._classVTableEntries[className];
  if (!((entries == null))) {
    for (final entry in entries) {
      if (((entry.name == entryName) && (entry.kind == kind)))       return true;
      if ((((kind == 'method') && (entryName == 'toString_')) && (entry.name == 'toString')))       return true;
    }
  }
  final String? parentName = _DartRestorerBase__getParentClassName(this_, className);
  if ((!((parentName == null)) && _DartRestorerBase__isUserClass(this_, parentName))) {
    return _DeclarationRestorer__classHasVTableEntry(this_, parentName, entryName, kind);
  }
  return false;
}

void _DeclarationRestorer__collectOwnFields(dynamic this__, Class cls, StaticList<Field> fieldsToEmit) {
  final this_ = this__;
  final StaticSet<String> seenNames = StaticSet<String>.of([]);
  if (!((cls.mixedInType == null))) {
    final Class mixinClass = cls.mixedInType!.classNode;
    for (final field in mixinClass.fields)     do {
{
        if (field.isStatic)         break;
        if (!(seenNames.contains(field.name.text))) {
          seenNames.add(field.name.text);
          fieldsToEmit.add(field);
        }
      }
    } while (false);
  }
  for (final field in cls.fields)   do {
{
      if (field.isStatic)       break;
      if (!(seenNames.contains(field.name.text))) {
        seenNames.add(field.name.text);
        fieldsToEmit.add(field);
      }
    }
  } while (false);
}

void _DeclarationRestorer__collectAllFields(dynamic this__, Class cls, StaticList<Field> allFields, StaticSet<String> seenNames) {
  final this_ = this__;
  if (!((cls.supertype == null))) {
    final Class superClass = cls.supertype!.classNode;
    if (((_DartRestorerBase__isUserClass(this_, superClass.name) || _DartRestorerBase__isSyntheticMixinClassName(this_, superClass.name)) || _DartRestorerBase__isMixinName(this_, superClass.name))) {
      _DeclarationRestorer__collectAllFields(this_, superClass, allFields, seenNames);
    }
  }
  if (!((cls.mixedInType == null))) {
    final Class mixinClass = cls.mixedInType!.classNode;
    if (((_DartRestorerBase__isMixinName(this_, mixinClass.name) || _DartRestorerBase__isUserClass(this_, mixinClass.name)) || _DartRestorerBase__isSyntheticMixinClassName(this_, mixinClass.name))) {
      _DeclarationRestorer__collectAllFields(this_, mixinClass, allFields, seenNames);
    }
  }
  for (final field in cls.fields)   do {
{
      if (field.isStatic)       break;
      if (!(seenNames.contains(field.name.text))) {
        seenNames.add(field.name.text);
        allFields.add(field);
      }
    }
  } while (false);
}

StaticList<_VTableEntryValue> _DeclarationRestorer__collectAllVTableEntries(dynamic this__, String className) {
  final this_ = this__;
  final StaticList<_VTableEntryValue> entries = StaticList<_VTableEntryValue>.of([]);
  final StaticSet<String> seenKeys = StaticSet<String>.of([]);
  String? currentClass = className;
  while ((!((currentClass == null)) && _DartRestorerBase__isUserClass(this_, currentClass))) {
    final StaticList<_VTableEntryValue>? classEntries = this_._classVTableEntries[currentClass];
    if (!((classEntries == null))) {
      for (final entry in classEntries) {
        final String key = '${entry.kind}:${entry.name}';
        if (!(seenKeys.contains(key))) {
          seenKeys.add(key);
          final _VTableEntryValue updatedEntry = _VTableEntry_new(_VTableEntryValue(), name: entry.name, kind: entry.kind, staticFuncName: _DeclarationRestorer__getStaticFuncName(this_, className, entry.name, entry.kind), signature: entry.signature, proc: entry.proc, declaringClassName: entry.declaringClassName);
          entries.add(updatedEntry);
        }
      }
    }
    currentClass = _DartRestorerBase__getParentClassName(this_, currentClass);
  }
  return entries;
}

String _DeclarationRestorer__findDeclaringClassName(dynamic this__, String className, String methodName, String kind) {
  final this_ = this__;
  final StaticList<_VTableEntryValue>? entries = this_._classVTableEntries[className];
  if (!((entries == null))) {
    for (final entry in entries) {
      if (((entry.name == methodName) && (entry.kind == kind))) {
        return (entry.declaringClassName ?? className);
      }
    }
  }
  return className;
}

bool _DeclarationRestorer__isInExtendsChain(dynamic this__, String className, String ancestorName) {
  final this_ = this__;
  String? current = _DartRestorerBase__getParentClassName(this_, className);
  while (!((current == null))) {
    if ((current == ancestorName))     return true;
    current = _DartRestorerBase__getParentClassName(this_, current);
  }
  return false;
}

StaticList<String>? _DeclarationRestorer__resolveConcreteTypeArgsForAncestor(dynamic this__, Class cls, Class ancestorCls) {
  final this_ = this__;
  Class currentClass = cls;
  while (true) {
    final Supertype? superType = currentClass.supertype;
    if ((superType == null))     return null;
    if ((superType.classNode == ancestorCls)) {
      if (superType.typeArguments.isEmpty)       return null;
      return StaticList.of(superType.typeArguments.map(ClosureEnv_anon_88(this_)).toList());
    }
    currentClass = superType.classNode;
    final StaticList<String>? result = _DeclarationRestorer__resolveConcreteTypeArgsForAncestor(this_, currentClass, ancestorCls);
    if (!((result == null))) {
      if ((superType.typeArguments.isNotEmpty && currentClass.typeParameters.isNotEmpty)) {
        final StaticMap<String, String> typeParamMap = StaticMap<String, String>.of({});
        for (var i = 0; ((i < currentClass.typeParameters.length) && (i < superType.typeArguments.length)); i = (i + 1)) {
          final String paramName = (currentClass.typeParameters[i].name ?? 'T${i}');
          typeParamMap[paramName] = _TypeUtils__restoreType(this_, superType.typeArguments[i]);
        }
        return StaticList.of(result.map(ClosureEnv_anon_89(typeParamMap)).toList());
      }
      return result;
    }
    return null;
  }
}

String _DeclarationRestorer__getStaticFuncName(dynamic this__, String className, String methodName, String kind) {
  final this_ = this__;
  if ((kind == 'getter')) {
    return _DartRestorerBase__staticGetterName(this_, className, methodName);
  }
 else   if ((kind == 'setter')) {
    return _DartRestorerBase__staticSetterName(this_, className, methodName);
  }
 else   if ((kind == 'operator')) {
    return _DartRestorerBase__staticMethodName(this_, className, methodName);
  }
 else {
    return _DartRestorerBase__staticMethodName(this_, className, methodName);
  }
}

void _DeclarationRestorer__emitStaticFields(dynamic this__, Class cls, String className) {
  final this_ = this__;
  for (final field in cls.fields)   do {
{
      if (!(field.isStatic))       break;
      this_._buf.write(this_._pad);
      if (field.isLate)       this_._buf.write('late ');
      if (field.isConst)       this_._buf.write('const ');
 else       if (field.isFinal)       this_._buf.write('final ');
      this_._buf.write(_TypeUtils__restoreType(this_, field.type));
      this_._buf.write(' ${className}_${field.name.text}');
      if (!((field.initializer == null))) {
        this_._buf.write(' = ');
        this_._buf.write(_DartRestorerBase__restoreExpr(this_, field.initializer!));
      }
      this_._buf.write(';\n');
    }
  } while (false);
}

void _DeclarationRestorer__emitConstructorFunction(dynamic this__, Class cls, Constructor ctor, String className, String? parentName) {
  final this_ = this__;
  final String ctorName = ctor.name.text;
  final String funcName = (ctorName.isEmpty ? '${className}_new' : '${className}_new_${ctorName}');
  final StaticList<_VTableEntryValue> entries = _DeclarationRestorer__collectAllVTableEntries(this_, className);
  final String typeParamNamesForReturn = (cls.typeParameters.isNotEmpty ? '<${cls.typeParameters.map(ClosureEnv_anon_90()).join(', ')}>' : '');
  final String returnType = '${className}Value${typeParamNamesForReturn}';
  this_._buf.write('${returnType} ${funcName}');
  _DeclarationRestorer__writeTypeParams(this_, cls.typeParameters);
  this_._buf.write('(dynamic this__');
  final bool hasParams = _DeclarationRestorer__hasParams(this_, ctor.function);
  if (hasParams) {
    this_._buf.write(', ');
    _DeclarationRestorer__writeParams(this_, ctor.function);
  }
  this_._buf.write(') {\n');
  this_._indent = (this_._indent + 1);
  this_._buf.write('${this_._pad}final this_ = this__ as ${className}Value');
  _DeclarationRestorer__writeTypeParamNames(this_, cls.typeParameters);
  this_._buf.write(';\n');
  final bool hasRedirecting = ctor.initializers.any(ClosureEnv_anon_91());
  if (hasRedirecting) {
    for (final init in ctor.initializers) {
      if ((init is RedirectingInitializer)) {
        final String redirCtorName = init.target.name.text;
        final String targetFuncName = (redirCtorName.isEmpty ? '${className}_new' : '${className}_new_${redirCtorName}');
        final String redirArgs = _TypeUtils__restoreArgs(this_, init.arguments);
        this_._buf.write('${this_._pad}${targetFuncName}(this_');
        if (redirArgs.isNotEmpty)         this_._buf.write(', ${redirArgs}');
        this_._buf.write(');\n');
      }
    }
    this_._buf.write('${this_._pad}return this_;\n');
    this_._indent = (this_._indent - 1);
    this_._buf.write('}\n\n');
    return;
  }
  for (final init in ctor.initializers) {
    if ((init is SuperInitializer)) {
      _DeclarationRestorer__emitSuperInit(this_, init, parentName, className);
    }
  }
  final bool hasClassTypeParams = cls.typeParameters.isNotEmpty;
  final StaticList<String> typeParamNames = StaticList.of(cls.typeParameters.map(ClosureEnv_anon_92()).toList());
  final String typeParamStr = (hasClassTypeParams ? '<${typeParamNames.join(', ')}>' : '');
  final StaticSet<String?> classTpNames = StaticSet.of(cls.typeParameters.map(ClosureEnv_anon_93()).toSet().toList());
  for (final entry in entries) {
    if (!((entry.proc == null))) {
      final StaticList<TypeParameter> dedupedMethodTps = StaticList.of(entry.proc!.function.typeParameters.where(ClosureEnv_anon_94(classTpNames)).toList());
      if (dedupedMethodTps.isNotEmpty) {
        _DeclarationRestorer__emitSpecializedVptrEntries(this_, cls, entry, className, typeParamStr, classTpNames, dedupedMethodTps);
      }
    }
  }
  for (final init in ctor.initializers) {
    if ((init is FieldInitializer)) {
      this_._buf.write('${this_._pad}this_.${init.field.name.text} = ');
      this_._insideMethodBody = true;
      this_._buf.write(_DartRestorerBase__restoreExpr(this_, init.value));
      this_._insideMethodBody = false;
      this_._buf.write(';\n');
    }
 else     if ((init is AssertInitializer)) {
      this_._buf.write('${this_._pad}assert(');
      this_._insideMethodBody = true;
      this_._buf.write(_DartRestorerBase__restoreExpr(this_, init.statement.condition));
      if (!((init.statement.message == null))) {
        this_._buf.write(', ${_DartRestorerBase__restoreExpr(this_, init.statement.message!)}');
      }
      this_._insideMethodBody = false;
      this_._buf.write(');\n');
    }
  }
  _DeclarationRestorer__emitThisFieldAssignments(this_, ctor, cls);
  _DeclarationRestorer__emitFieldDefaultValues(this_, ctor, cls);
  if ((!((ctor.function.body == null)) && !((ctor.function.body is EmptyStatement)))) {
    this_._insideMethodBody = true;
    this_._thisReplacementName = 'this_';
    final String ctorContextName = (ctorName.isEmpty ? '${className}_new' : '${className}_new_${ctorName}');
    _DartRestorerBase__pushClosureContext(this_, ctorContextName);
    _DeclarationRestorer__emitBodyWithThisReplacement(this_, ctor.function.body!, 'this_');
    _DartRestorerBase__popClosureContext(this_);
    this_._thisReplacementName = 'this_';
    this_._insideMethodBody = false;
  }
  this_._buf.write('${this_._pad}return this_;\n');
  this_._indent = (this_._indent - 1);
  this_._buf.write('}\n\n');
}

bool _DeclarationRestorer__hasParams(dynamic this__, FunctionNode func) {
  final this_ = this__;
  return (func.positionalParameters.isNotEmpty || func.namedParameters.isNotEmpty);
}

String _DeclarationRestorer__vptrEntryKey(dynamic this__, _VTableEntryValue entry) {
  final this_ = this__;
  if ((entry.kind == 'getter'))   return 'get_${entry.name}';
  if ((entry.kind == 'setter'))   return 'set_${entry.name}';
  if ((entry.kind == 'operator'))   return 'operator${_DartRestorerBase__operatorFuncName(this_, entry.name)}';
  return _DartRestorerBase__vtableFieldName(this_, entry.name);
}

String _DeclarationRestorer__sharedVTableName(dynamic this__, String className) {
  final this_ = this__;
  return '_${className}_vtable';
}

void _DeclarationRestorer__emitSharedVTableConstant(dynamic this__, String className, StaticList<(String, String)> keyRhsList) {
  final this_ = this__;
  if (this_._emittedSharedVTableClasses.contains(className))   return;
  this_._emittedSharedVTableClasses.add(className);
  final StringBuffer sb = StringBuffer();
  sb.write('final Map<String, dynamic> ${_DeclarationRestorer__sharedVTableName(this_, className)} = <String, dynamic>{\n');
  for (final kv in keyRhsList) {
    sb.write('  \'${kv.$1}\': ${kv.$2},\n');
  }
  sb.write('};\n');
  this_._pendingTopLevelDecls.add(sb.toString());
}

bool _DeclarationRestorer__hasRealUserAncestor(dynamic this__, String? parentName) {
  final this_ = this__;
  if (((parentName == null) || !(_DartRestorerBase__isUserClass(this_, parentName))))   return false;
  String current = parentName;
  while ((_DartRestorerBase__isSyntheticMixinClassName(this_, current) || _DeclarationRestorer__isSyntheticLoweredName(this_, current))) {
    final String? next = _DartRestorerBase__getParentClassName(this_, current);
    if (((next == null) || !(_DartRestorerBase__isUserClass(this_, next))))     return false;
    current = next;
  }
  return (!(_DeclarationRestorer__isSyntheticLoweredName(this_, current)) && !(_DartRestorerBase__isSyntheticMixinClassName(this_, current)));
}

void _DeclarationRestorer__emitSuperInit(dynamic this__, SuperInitializer init, String? parentName, String className) {
  final this_ = this__;
  if (((parentName == null) || !(_DartRestorerBase__isUserClass(this_, parentName))))   return;
  String actualParent = parentName;
  do {
    while ((_DartRestorerBase__isSyntheticMixinClassName(this_, actualParent) || _DeclarationRestorer__isSyntheticLoweredName(this_, actualParent))) {
      final String? next = _DartRestorerBase__getParentClassName(this_, actualParent);
      if (((next == null) || !(_DartRestorerBase__isUserClass(this_, next))))       break;
      actualParent = next;
    }
  } while (false);
  if (_DeclarationRestorer__isSyntheticLoweredName(this_, actualParent))   return;
  final String superCtorName = init.target.name.text;
  final String parentFuncName = (superCtorName.isEmpty ? '${actualParent}_new' : '${actualParent}_new_${superCtorName}');
  String typeArgStr = '';
  if ((!((this_._currentClass == null)) && !((this_._currentClass!.supertype == null)))) {
    final Supertype superType = this_._currentClass!.supertype!;
    final Class? targetClass = this_._classNodes[actualParent];
    if ((!((targetClass == null)) && targetClass.typeParameters.isNotEmpty)) {
      final StaticList<String>? concreteArgs = _DeclarationRestorer__resolveConcreteTypeArgsForAncestor(this_, this_._currentClass!, targetClass);
      if ((!((concreteArgs == null)) && concreteArgs.isNotEmpty)) {
        typeArgStr = '<${concreteArgs.join(', ')}>';
      }
 else       if (superType.typeArguments.isNotEmpty) {
        typeArgStr = '<${superType.typeArguments.map(ClosureEnv_anon_95(this_)).join(', ')}>';
      }
    }
  }
  final String superArgs = _TypeUtils__restoreArgs(this_, init.arguments);
  this_._buf.write('${this_._pad}${parentFuncName}${typeArgStr}(this_');
  if (superArgs.isNotEmpty)   this_._buf.write(', ${superArgs}');
  this_._buf.write(');\n');
}

bool _DeclarationRestorer__isSyntheticLoweredName(dynamic this__, String name) {
  final this_ = this__;
  return this_._syntheticLoweredNames.contains(name);
}

void _DeclarationRestorer__emitThisFieldAssignments(dynamic this__, Constructor ctor, Class cls) {
  final this_ = this__;
  final StaticSet<String> fieldNames = StaticSet.of(cls.fields.where(ClosureEnv_anon_96()).map(ClosureEnv_anon_97()).toSet().toList());
  for (final param in ctor.function.positionalParameters) {
    final String paramName = _TypeUtils__cleanVarName(this_, (param.name ?? ''));
    if (fieldNames.contains(paramName)) {
      final bool alreadyInited = ctor.initializers.any(ClosureEnv_anon_98(paramName));
      if (!(alreadyInited)) {
        this_._buf.write('${this_._pad}this_.${paramName} = ${paramName};\n');
      }
    }
  }
  for (final param in ctor.function.namedParameters) {
    final String paramName = _TypeUtils__cleanVarName(this_, (param.name ?? ''));
    if (fieldNames.contains(paramName)) {
      final bool alreadyInited = ctor.initializers.any(ClosureEnv_anon_99(paramName));
      if (!(alreadyInited)) {
        this_._buf.write('${this_._pad}this_.${paramName} = ${paramName};\n');
      }
    }
  }
}

void _DeclarationRestorer__emitFieldDefaultValues(dynamic this__, Constructor ctor, Class cls) {
  final this_ = this__;
  final StaticSet<String> initedFields = StaticSet<String>.of([]);
  for (final init in ctor.initializers) {
    if ((init is FieldInitializer)) {
      initedFields.add(init.field.name.text);
    }
  }
  final StaticSet<String> fieldNames = StaticSet.of(cls.fields.where(ClosureEnv_anon_100()).map(ClosureEnv_anon_101()).toSet().toList());
  for (final param in ctor.function.positionalParameters) {
    final String paramName = _TypeUtils__cleanVarName(this_, (param.name ?? ''));
    if (fieldNames.contains(paramName)) {
      initedFields.add(paramName);
    }
  }
  for (final param in ctor.function.namedParameters) {
    final String paramName = _TypeUtils__cleanVarName(this_, (param.name ?? ''));
    if (fieldNames.contains(paramName)) {
      initedFields.add(paramName);
    }
  }
  final StaticList<Field> allFields = StaticList<Field>.of([]);
  _DeclarationRestorer__collectAllFields(this_, cls, allFields, StaticSet<String>.of([]));
  final StaticMap<String, String> mixinTypeSubstitution = _DeclarationRestorer__buildMixinFieldTypeSubstitution(this_, cls);
  final bool savedInsideMethodBody = this_._insideMethodBody;
  final String savedThisReplacementName = this_._thisReplacementName;
  final StaticMap<String, String> savedTypeParamSubstitution = this_._activeTypeParamSubstitution;
  this_._insideMethodBody = true;
  this_._thisReplacementName = 'this_';
  if (mixinTypeSubstitution.isNotEmpty) {
    this_._activeTypeParamSubstitution = (() {     final StaticMap<String, String> _v120 = StaticMap<String, String>.of(this_._activeTypeParamSubstitution);
    _v120.addAll(mixinTypeSubstitution);
 return _v120; })();
  }
  try {
    for (final field in allFields)     do {
{
        if (field.isStatic)         break;
        if (initedFields.contains(field.name.text))         break;
        if ((field.initializer == null))         break;
        this_._buf.write('${this_._pad}this_.${field.name.text} = ');
        this_._buf.write(_DartRestorerBase__restoreExpr(this_, field.initializer!));
        this_._buf.write(';\n');
      }
    } while (false);
  }
 finally {
    this_._insideMethodBody = savedInsideMethodBody;
    this_._thisReplacementName = savedThisReplacementName;
    this_._activeTypeParamSubstitution = savedTypeParamSubstitution;
  }
}

void _DeclarationRestorer__emitSpecializedVptrEntries(dynamic this__, Class cls, _VTableEntryValue entry, String className, String typeParamStr, StaticSet<String?> classTpNames, StaticList<TypeParameter> dedupedMethodTps) {
  final this_ = this__;
  final String methodName = entry.name;
  final StaticSet<MethodSpecEntryValue> specEntries = StaticSet<MethodSpecEntryValue>.of([]);
  final StaticMap<String, StaticSet<MethodSpecEntryValue>>? classSpecs = this_._methodTypeSpecializations[className];
  if ((!((classSpecs == null)) && !((classSpecs[methodName] == null)))) {
    specEntries.addAll(classSpecs[methodName]!);
  }
  String? parentName = this_._classHierarchy[className];
  while (!((parentName == null))) {
    final StaticMap<String, StaticSet<MethodSpecEntryValue>>? parentSpecs = this_._methodTypeSpecializations[parentName];
    if ((!((parentSpecs == null)) && !((parentSpecs[methodName] == null)))) {
      specEntries.addAll(parentSpecs[methodName]!);
    }
    parentName = this_._classHierarchy[parentName];
  }
  if (specEntries.isEmpty)   return;
  final Procedure proc = entry.proc!;
  final StaticSet<String?> classTpNames = StaticSet.of(cls.typeParameters.map(ClosureEnv_anon_102()).toSet().toList());
  final StaticList<TypeParameter> dedupedMethodTps = StaticList.of(proc.function.typeParameters.where(ClosureEnv_anon_103(classTpNames)).toList());
  for (final specEntry in specEntries) {
    final String specKey = '${_DeclarationRestorer__vptrEntryKey(this_, entry)}_${specEntry.vptrSuffix}';
    final StaticList<String> callTypeArgsList = (() {     final StaticList<String> _v121 = StaticList<String>.of(cls.typeParameters.map(ClosureEnv_anon_104()));
    _v121.addAll(specEntry.typeArgStrs);
 return _v121; })();
    final String callTypeArgsStr = '<${callTypeArgsList.join(', ')}>';
    final StaticList<String> wrapperTpNames = StaticList.of(cls.typeParameters.map(/* unknown: InstanceTearOff */).toList());
    final StaticMap<String, String> extraSub = StaticMap<String, String>.of({});
    for (var i = 0; ((i < dedupedMethodTps.length) && (i < specEntry.typeArgStrs.length)); i = (i + 1)) {
      final String? name = dedupedMethodTps[i].name;
      if (!((name == null))) {
        extraSub[name] = specEntry.typeArgStrs[i];
      }
    }
    final String rhs = _DeclarationRestorer__buildTearOffWrapperExpr(this_, staticFuncName: entry.staticFuncName, callTypeArgsStr: callTypeArgsStr, functionNode: proc.function, hostingCls: cls, methodTpNames: wrapperTpNames, nameSuffix: '_${specEntry.vptrSuffix}', additionalSubstitution: extraSub);
    this_._buf.write('${this_._pad}this_.vptr[\'${specKey}\'] = ${rhs};\n');
  }
}

String _DeclarationRestorer__buildVptrLambdaWrapper(dynamic this__, Class cls, _VTableEntryValue entry, String className, String typeParamStr) {
  final this_ = this__;
  final Procedure? proc = entry.proc;
  final bool hasClassTypeParams = typeParamStr.isNotEmpty;
  if ((proc == null)) {
    return entry.staticFuncName;
  }
  final StaticSet<String?> classTpNames = StaticSet.of(cls.typeParameters.map(ClosureEnv_anon_105()).toSet().toList());
  final StaticList<TypeParameter> dedupedMethodTps = StaticList.of(proc.function.typeParameters.where(ClosureEnv_anon_106(classTpNames)).toList());
  final StaticList<String> callTypeArgsList = (() {   final StaticList<String> _v123 = StaticList<String>.of(cls.typeParameters.map(ClosureEnv_anon_107()));
  _v123.addAll(dedupedMethodTps.map(ClosureEnv_anon_108()));
 return _v123; })();
  final String callTypeArgsStr = (callTypeArgsList.isEmpty ? '' : '<${callTypeArgsList.join(', ')}>');
  return _DeclarationRestorer__buildTearOffWrapperExpr(this_, staticFuncName: entry.staticFuncName, callTypeArgsStr: callTypeArgsStr, functionNode: proc.function, hostingCls: ((hasClassTypeParams || dedupedMethodTps.isNotEmpty) ? cls : null), methodTpNames: (() {   final StaticList<String> _v126 = StaticList<String>.of(cls.typeParameters.map(/* unknown: InstanceTearOff */));
  _v126.addAll(dedupedMethodTps.map(/* unknown: InstanceTearOff */));
 return _v126; })());
}

String _DeclarationRestorer__typeParamDecl(dynamic this__, TypeParameter tp) {
  final this_ = this__;
  final String name = (tp.name ?? 'T');
  final DartType bound = tp.bound;
  if (((bound is InterfaceType) && (bound.classNode.name == 'Object'))) {
    return name;
  }
  return '${name} extends ${_DartRestorerBase__restoreTypeForSignature(this_, bound)}';
}

String _DeclarationRestorer__buildTearOffWrapperExpr(dynamic this__, {required String staticFuncName}, {required String callTypeArgsStr}, {required FunctionNode functionNode}, {required Class? hostingCls}, {required StaticList<String> methodTpNames}, {String nameSuffix = ''}, {StaticMap<String, String> additionalSubstitution = const {}}) {
  final this_ = this__;
  final String wrapperTpDeclStr = (methodTpNames.isEmpty ? '' : '<${methodTpNames.join(', ')}>');
  final String wrapperTpRefStr = (methodTpNames.isEmpty ? '' : '<${methodTpNames.map(/* unknown: InstanceTearOff */).join(', ')}>');
  final String wrapperName = '_TearOff_${staticFuncName}${nameSuffix}';
  final String emissionKey = '${wrapperName}::${wrapperTpDeclStr}';
  if (!(this_._emittedTearOffWrappers.contains(emissionKey))) {
    this_._emittedTearOffWrappers.add(emissionKey);
    final StaticMap<String, String> savedSub = this_._activeTypeParamSubstitution;
    final StaticSet<TypeParameter> savedTargets = this_._activeTypeParamTargets;
    final bool savedInsideMethodBody = this_._insideMethodBody;
    this_._activeTypeParamSubstitution = (() {     final StaticMap<String, String> _v128 = StaticMap<String, String>.of(savedSub);
    _v128.addAll(additionalSubstitution);
 return _v128; })();
    this_._activeTypeParamTargets = (additionalSubstitution.isEmpty ? savedTargets : const {});
    this_._insideMethodBody = true;
    final String returnText = _DartRestorerBase__restoreTypeForSignature(this_, functionNode.returnType);
    final StaticList<String> argTexts = StaticList<String>.of(['dynamic']);
    final StaticList<String> argNames = StaticList<String>.of(['this_']);
    for (var i = 0; (i < functionNode.positionalParameters.length); i = (i + 1)) {
      final VariableDeclaration p = functionNode.positionalParameters[i];
      argTexts.add(_DartRestorerBase__restoreTypeForSignature(this_, p.type));
      argNames.add((p.name ?? 'a${(i + 1)}'));
    }
    final bool hasNamed = functionNode.namedParameters.isNotEmpty;
    late String baseClause;
    late bool callIsOverride;
    if ((!(hasNamed) && (argTexts.length <= 16))) {
      final int arity = argTexts.length;
      final String args = (() {       final StaticList<String> _v130 = StaticList<String>.of([returnText]);
      _v130.addAll(argTexts);
 return _v130; })().join(', ');
      baseClause = ' extends TypeFunction${arity}<${args}>';
      callIsOverride = true;
    }
 else {
      baseClause = ' extends TypeFunction<${returnText}>';
      callIsOverride = false;
    }
    final StringBuffer declBuf = StringBuffer();
    declBuf.write('class ${wrapperName}${wrapperTpDeclStr}${baseClause} {\n');
    declBuf.write((wrapperTpDeclStr.isEmpty ? '  const ${wrapperName}();\n' : '  ${wrapperName}();\n'));
    if (!(callIsOverride)) {
      final int positionalArity = argTexts.length;
      declBuf.write('  @override\n');
      declBuf.write('  int get arity => ${positionalArity};\n');
    }
    if (callIsOverride)     declBuf.write('  @override\n');
    final StaticList<String> positionalParts = (() {     final StaticList<String> _v131 = StaticList<String>.of([]);
    for (var i = 0; (i < argTexts.length); i = (i + 1))     _v131.add('${argTexts[i]} ${argNames[i]}');
 return _v131; })();
    final StaticList<String> namedSigParts = StaticList<String>.of([]);
    final StaticList<String> namedFwdParts = StaticList<String>.of([]);
    if (hasNamed) {
      for (final np in functionNode.namedParameters) {
        final String t = _DartRestorerBase__restoreTypeForSignature(this_, np.type);
        final String req = (np.isRequired ? 'required ' : '');
        namedSigParts.add('${req}${t} ${np.name}');
        namedFwdParts.add('${np.name}: ${np.name}');
      }
    }
    final StringBuffer sigBuf = StringBuffer(positionalParts.join(', '));
    if (namedSigParts.isNotEmpty) {
      if (positionalParts.isNotEmpty)       sigBuf.write(', ');
      sigBuf.write('{${namedSigParts.join(', ')}}');
    }
    final StringBuffer fwdBuf = StringBuffer(argNames.join(', '));
    if (namedFwdParts.isNotEmpty) {
      fwdBuf.write(', ${namedFwdParts.join(', ')}');
    }
    declBuf.write('  ${returnText} call(${sigBuf}) => ${staticFuncName}${callTypeArgsStr}(${fwdBuf});\n');
    declBuf.write('}\n');
    this_._pendingClosureDecls.add(declBuf.toString());
    this_._activeTypeParamSubstitution = savedSub;
    this_._activeTypeParamTargets = savedTargets;
    this_._insideMethodBody = savedInsideMethodBody;
  }
  return (wrapperTpRefStr.isEmpty ? 'const ${wrapperName}()' : '${wrapperName}${wrapperTpRefStr}()');
}

String _DeclarationRestorer__extractTypeFormalName(dynamic this__, String decl) {
  final this_ = this__;
  final int i = decl.indexOf(' ');
  return ((i < 0) ? decl : decl.substring(0, i));
}

String _DeclarationRestorer__replaceTypeParam(dynamic this__, String typeStr, String paramName, String replacement) {
  final this_ = this__;
  return typeStr.replaceAllMapped(RegExp('\b${paramName}\b'), ClosureEnv_anon_109(replacement));
}

void _DeclarationRestorer__emitBodyWithThisReplacement(dynamic this__, Statement body, String thisReplacement) {
  final this_ = this__;
  if ((body is Block)) {
    for (final s in body.statements) {
      _DartRestorerBase__restoreStmt(this_, s);
    }
  }
 else {
    _DartRestorerBase__restoreStmt(this_, body);
  }
}

void _DeclarationRestorer__emitInstanceMethodAsStatic(dynamic this__, Class cls, Procedure proc, String className) {
  final this_ = this__;
  if ((proc.isAbstract && (proc.function.body == null))) {
    _DeclarationRestorer__emitAbstractMethodPlaceholder(this_, cls, proc, className);
    return;
  }
  final StaticSet<VariableDeclaration> savedBoxedVars = StaticSet<VariableDeclaration>.of(this_._boxedVars);
  final StaticSet<VariableDeclaration> savedCurrentParams = StaticSet<VariableDeclaration>.of(this_._currentFunctionParams);
  if (!((proc.function.body == null))) {
    _DartRestorerBase__preanalyzeBoxedVarsForFunc(this_, proc.function);
    this_._currentFunctionParams.clear();
    this_._currentFunctionParams.addAll(proc.function.positionalParameters);
    this_._currentFunctionParams.addAll(proc.function.namedParameters);
  }
  final StaticList<VariableDeclaration> boxedParamsForMethod = StaticList<VariableDeclaration>.of([]);
  for (final p in proc.function.positionalParameters) {
    if (this_._boxedVars.contains(p))     boxedParamsForMethod.add(p);
  }
  for (final p in proc.function.namedParameters) {
    if (this_._boxedVars.contains(p))     boxedParamsForMethod.add(p);
  }
  final String methodName = proc.name.text;
  late String funcName;
  if (proc.isGetter) {
    funcName = _DartRestorerBase__staticGetterName(this_, className, methodName);
  }
 else   if (proc.isSetter) {
    funcName = _DartRestorerBase__staticSetterName(this_, className, methodName);
  }
 else {
    funcName = _DartRestorerBase__staticMethodName(this_, className, methodName);
  }
  this_._buf.write(this_._pad);
  this_._buf.write(_TypeUtils__restoreType(this_, proc.function.returnType));
  this_._buf.write(' ${funcName}');
  _DeclarationRestorer__writeCombinedTypeParams(this_, cls.typeParameters, proc.function.typeParameters);
  this_._buf.write('(');
  this_._buf.write('dynamic this__');
  if (proc.isSetter) {
    if (proc.function.positionalParameters.isNotEmpty) {
      final VariableDeclaration p = proc.function.positionalParameters.first;
      final String cleanName = _TypeUtils__cleanVarName(this_, (p.name ?? 'value'));
      p.name = cleanName;
      this_._buf.write(', ${_TypeUtils__restoreType(this_, p.type)} ${cleanName}');
    }
  }
 else   if (!(proc.isGetter)) {
    final StaticList<VariableDeclaration> pos = proc.function.positionalParameters;
    final StaticList<VariableDeclaration> named = proc.function.namedParameters;
    if ((pos.isNotEmpty || named.isNotEmpty)) {
      this_._buf.write(', ');
      _DeclarationRestorer__writeParams(this_, proc.function, proc: proc, suppressCovariant: true, flattenOptional: true);
    }
  }
  this_._buf.write(')');
  final AsyncMarker marker = proc.function.asyncMarker;
  if ((marker == AsyncMarker.AsyncStar))   this_._buf.write(' async*');
  if ((marker == AsyncMarker.SyncStar))   this_._buf.write(' sync*');
  if (!((proc.function.body == null))) {
    this_._buf.write(' ');
    this_._insideMethodBody = true;
    final bool isVoidReturn = ((proc.function.returnType is VoidType) || proc.isSetter);
    if (((marker == AsyncMarker.Async) && !(isVoidReturn))) {
      final DartType retType = proc.function.returnType;
      String innerRetType = 'dynamic';
      if (((retType is InterfaceType) && retType.typeArguments.isNotEmpty)) {
        innerRetType = _TypeUtils__restoreType(this_, retType.typeArguments.first);
      }
      final StaticList<VariableDeclaration> allParams = (() {       final StaticList<VariableDeclaration> _v133 = StaticList<VariableDeclaration>.of(proc.function.positionalParameters);
      _v133.addAll(proc.function.namedParameters);
 return _v133; })();
      final String classTypeParamStr = (cls.typeParameters.isNotEmpty ? '<${cls.typeParameters.map(ClosureEnv_anon_110()).join(', ')}>' : '');
      final String thisTypeStr = '${className}Value${classTypeParamStr}';
      final String envBaseName = '${className}_${methodName}';
      _DartRestorerBase__pushClosureContext(this_, envBaseName);
      _DeclarationRestorer__emitAsyncClosureEnvForMethod(this_, envBaseName: this_._closureContext, func: proc.function, innerReturnType: innerRetType, params: allParams, thisParam: thisTypeStr, thisRawParam: 'this__', boxedParams: boxedParamsForMethod);
      _DartRestorerBase__popClosureContext(this_);
    }
 else {
      this_._buf.write('{\n');
      this_._indent = (this_._indent + 1);
      final String classTypeParamStr = (cls.typeParameters.isNotEmpty ? '<${cls.typeParameters.map(ClosureEnv_anon_111()).join(', ')}>' : '');
      this_._buf.write('${this_._pad}final this_ = this__ as ${className}Value${classTypeParamStr};\n');
      for (final p in boxedParamsForMethod) {
        final String baseName = p.name!;
        final String boxType = _TypeUtils__boxTypeNameFor(this_, p.type)!;
        this_._buf.write('${this_._pad}${boxType} ${baseName} = ${boxType}(${baseName}_raw);\n');
      }
      final Statement body = proc.function.body!;
      if ((body is Block)) {
        for (final s in body.statements)         do {
{
            if ((isVoidReturn && (s is ReturnStatement))) {
              if (!((s.expression == null))) {
                this_._buf.write('${this_._pad}${_DartRestorerBase__restoreExpr(this_, s.expression!)};\n');
              }
              break;
            }
            _DartRestorerBase__restoreStmt(this_, s);
          }
        } while (false);
      }
 else       if ((isVoidReturn && (body is ReturnStatement))) {
        if (!(((body as ReturnStatement).expression == null))) {
          this_._buf.write('${this_._pad}${_DartRestorerBase__restoreExpr(this_, (body as ReturnStatement).expression!)};\n');
        }
      }
 else {
        _DartRestorerBase__restoreStmt(this_, body);
      }
      this_._indent = (this_._indent - 1);
      this_._buf.write('${this_._pad}}\n');
    }
    this_._insideMethodBody = false;
  }
 else {
    this_._buf.write(';\n');
  }
  this_._buf.write('\n');
  this_._boxedVars.clear();
  this_._boxedVars.addAll(savedBoxedVars);
  this_._currentFunctionParams.clear();
  this_._currentFunctionParams.addAll(savedCurrentParams);
}

void _DeclarationRestorer__emitAbstractMethodPlaceholder(dynamic this__, Class cls, Procedure proc, String className) {
  final this_ = this__;
  final String methodName = proc.name.text;
  late String funcName;
  if (proc.isGetter) {
    funcName = _DartRestorerBase__staticGetterName(this_, className, methodName);
  }
 else   if (proc.isSetter) {
    funcName = _DartRestorerBase__staticSetterName(this_, className, methodName);
  }
 else {
    funcName = _DartRestorerBase__staticMethodName(this_, className, methodName);
  }
  this_._buf.write(this_._pad);
  this_._buf.write(_TypeUtils__restoreType(this_, proc.function.returnType));
  this_._buf.write(' ${funcName}');
  _DeclarationRestorer__writeCombinedTypeParams(this_, cls.typeParameters, proc.function.typeParameters);
  this_._buf.write('(dynamic this_');
  if (proc.isSetter) {
    if (proc.function.positionalParameters.isNotEmpty) {
      final VariableDeclaration p = proc.function.positionalParameters.first;
      final String cleanName = _TypeUtils__cleanVarName(this_, (p.name ?? 'value'));
      p.name = cleanName;
      this_._buf.write(', ${_TypeUtils__restoreType(this_, p.type)} ${cleanName}');
    }
  }
 else   if (!(proc.isGetter)) {
    final StaticList<VariableDeclaration> pos = proc.function.positionalParameters;
    final StaticList<VariableDeclaration> named = proc.function.namedParameters;
    if ((pos.isNotEmpty || named.isNotEmpty)) {
      this_._buf.write(', ');
      _DeclarationRestorer__writeParams(this_, proc.function, proc: proc, suppressCovariant: true);
    }
  }
  this_._buf.write(') {\n');
  this_._indent = (this_._indent + 1);
  this_._buf.write('${this_._pad}throw UnimplementedError(\'${className}.${methodName} is abstract\');\n');
  this_._indent = (this_._indent - 1);
  this_._buf.write('}\n\n');
}

void _DeclarationRestorer__emitStaticOrFactoryProcedure(dynamic this__, Class cls, Procedure proc, String className) {
  final this_ = this__;
  if (proc.isFactory) {
    final String factoryName = proc.name.text;
    final String funcName = (factoryName.isEmpty ? '${className}_new' : '${className}_new_${factoryName}');
    this_._buf.write(this_._pad);
    this_._buf.write('${className}Value');
    _DeclarationRestorer__writeTypeParams(this_, cls.typeParameters);
    this_._buf.write(' ${funcName}(');
    _DeclarationRestorer__writeParams(this_, proc.function, proc: proc);
    this_._buf.write(')');
    final AsyncMarker marker = proc.function.asyncMarker;
    if (!((proc.function.body == null))) {
      this_._buf.write(' ');
      this_._insideMethodBody = true;
      _DeclarationRestorer__restoreBody(this_, proc.function.body!);
      this_._insideMethodBody = false;
    }
 else {
      this_._buf.write(';\n');
    }
    this_._buf.write('\n');
  }
 else {
    this_._buf.write(this_._pad);
    this_._buf.write(_TypeUtils__restoreType(this_, proc.function.returnType));
    this_._buf.write(' ${className}_${proc.name.text}');
    _DeclarationRestorer__writeTypeParams(this_, proc.function.typeParameters);
    this_._buf.write('(');
    _DeclarationRestorer__writeParams(this_, proc.function, proc: proc);
    this_._buf.write(')');
    final AsyncMarker marker = proc.function.asyncMarker;
    if ((marker == AsyncMarker.AsyncStar))     this_._buf.write(' async*');
    if ((marker == AsyncMarker.SyncStar))     this_._buf.write(' sync*');
    if (!((proc.function.body == null))) {
      this_._buf.write(' ');
      final bool savedInsideMethodBody = this_._insideMethodBody;
      this_._insideMethodBody = true;
      _DeclarationRestorer__restoreBody(this_, proc.function.body!);
      this_._insideMethodBody = savedInsideMethodBody;
    }
 else {
      this_._buf.write(';\n');
    }
    this_._buf.write('\n');
  }
}

void _DeclarationRestorer__restoreClassOriginal(dynamic this__, Class cls) {
  final this_ = this__;
  if (cls.isAbstract)   this_._buf.write('abstract ');
  this_._buf.write('class ${cls.name}');
  _DeclarationRestorer__writeTypeParams(this_, cls.typeParameters);
  if (!((cls.supertype == null))) {
    final String superName = cls.supertype!.classNode.name;
    if (superName.contains('&')) {
      final String realSuper = _TypeUtils__resolveRealSuperclass(this_, cls.supertype!.classNode);
      final StaticList<String> mixins = _TypeUtils__collectMixins(this_, cls.supertype!.classNode);
      if (!((realSuper == 'Object'))) {
        this_._buf.write(' extends ${realSuper}');
      }
      if (mixins.isNotEmpty) {
        this_._buf.write(' with ${mixins.join(', ')}');
      }
    }
 else     if (!((superName == 'Object'))) {
      this_._buf.write(' extends ');
      this_._buf.write(_TypeUtils__restoreSupertype(this_, cls.supertype!));
    }
  }
  if (cls.implementedTypes.isNotEmpty) {
    this_._buf.write(' implements ');
    this_._buf.write(cls.implementedTypes.map(ClosureEnv_anon_112(this_)).join(', '));
  }
  this_._buf.write(' {\n');
  this_._indent = (this_._indent + 1);
  _DeclarationRestorer__restoreClassMembers(this_, cls);
  this_._indent = (this_._indent - 1);
  this_._buf.write('}\n\n');
}

bool _DeclarationRestorer__isEnumClass(dynamic this__, Class cls) {
  final this_ = this__;
  if ((cls.supertype == null))   return false;
  return (cls.supertype!.classNode.name == '_Enum');
}

void _DeclarationRestorer__restoreEnum(dynamic this__, Class cls) {
  final this_ = this__;
  final String enumName = cls.name;
  this_._buf.write('enum ${enumName}');
  _DeclarationRestorer__writeTypeParams(this_, cls.typeParameters);
  this_._buf.write(' {\n');
  this_._indent = (this_._indent + 1);
  final StaticList<Field> enumValueFields = StaticList.of(cls.fields.where(ClosureEnv_anon_113(cls)).toList());
  final StaticSet<String> enumInternalFields = StaticSet<String>.of(['index', '_name']);
  final StaticList<Field> userFields = StaticList.of(cls.fields.where(ClosureEnv_anon_114(enumInternalFields)).toList());
  StaticList<String> userParamNames = StaticList<String>.of([]);
  if (cls.constructors.isNotEmpty) {
    final Constructor ctor = cls.constructors.first;
    for (final p in ctor.function.positionalParameters)     do {
{
        final String paramName = _TypeUtils__cleanVarName(this_, (p.name ?? ''));
        if (_DeclarationRestorer__isEnumInternalParam(this_, paramName))         break;
        userParamNames.add(paramName);
      }
    } while (false);
    for (final p in ctor.function.namedParameters)     do {
{
        final String paramName = _TypeUtils__cleanVarName(this_, (p.name ?? ''));
        if (_DeclarationRestorer__isEnumInternalParam(this_, paramName))         break;
        userParamNames.add(paramName);
      }
    } while (false);
  }
  for (var i = 0; (i < enumValueFields.length); i = (i + 1)) {
    final Field field = enumValueFields[i];
    this_._buf.write('${this_._pad}${field.name.text}');
    if ((userParamNames.isNotEmpty && !((field.initializer == null)))) {
      final String args = _DeclarationRestorer__extractEnumValueArgs(this_, field.initializer!, userParamNames);
      if (args.isNotEmpty) {
        this_._buf.write('(${args})');
      }
    }
    if ((i < (enumValueFields.length - 1))) {
      this_._buf.write(',\n');
    }
 else {
      this_._buf.write(';\n');
    }
  }
  if (userFields.isNotEmpty) {
    this_._buf.write('\n');
    for (final f in userFields) {
      _DeclarationRestorer__restoreField(this_, f);
    }
  }
  if (userParamNames.isNotEmpty) {
    this_._buf.write('\n');
    this_._buf.write('${this_._pad}const ${enumName}(');
    this_._buf.write(userParamNames.map(ClosureEnv_anon_115()).join(', '));
    this_._buf.write(');\n');
  }
  this_._indent = (this_._indent - 1);
  this_._buf.write('}\n\n');
  final StaticSet<String> syntheticMethods = StaticSet<String>.of(['_enumToString']);
  final StaticList<Procedure> userMethods = StaticList.of(cls.procedures.where(ClosureEnv_anon_116(syntheticMethods)).toList());
  this_._currentClass = cls;
  for (final proc in userMethods) {
    _DeclarationRestorer__emitEnumMethodAsStatic(this_, cls, proc, enumName);
  }
  this_._currentClass = null;
}

void _DeclarationRestorer__emitEnumMethodAsStatic(dynamic this__, Class cls, Procedure proc, String enumName) {
  final this_ = this__;
  final String methodName = proc.name.text;
  late String funcName;
  if (proc.isGetter) {
    funcName = '${enumName}_get_${methodName}';
  }
 else   if (proc.isSetter) {
    funcName = '${enumName}_set_${methodName}';
  }
 else {
    funcName = '${enumName}_${methodName}';
  }
  this_._buf.write(this_._pad);
  this_._buf.write(_TypeUtils__restoreType(this_, proc.function.returnType));
  this_._buf.write(' ${funcName}(');
  this_._buf.write('${enumName} this_');
  if (proc.isSetter) {
    if (proc.function.positionalParameters.isNotEmpty) {
      final VariableDeclaration p = proc.function.positionalParameters.first;
      final String cleanName = _TypeUtils__cleanVarName(this_, (p.name ?? 'value'));
      p.name = cleanName;
      this_._buf.write(', ${_TypeUtils__restoreType(this_, p.type)} ${cleanName}');
    }
  }
 else   if (!(proc.isGetter)) {
    final StaticList<VariableDeclaration> pos = proc.function.positionalParameters;
    final StaticList<VariableDeclaration> named = proc.function.namedParameters;
    if ((pos.isNotEmpty || named.isNotEmpty)) {
      this_._buf.write(', ');
      _DeclarationRestorer__writeParams(this_, proc.function, proc: proc);
    }
  }
  this_._buf.write(')');
  final AsyncMarker marker = proc.function.asyncMarker;
  if ((marker == AsyncMarker.AsyncStar))   this_._buf.write(' async*');
  if ((marker == AsyncMarker.SyncStar))   this_._buf.write(' sync*');
  if (!((proc.function.body == null))) {
    this_._buf.write(' ');
    this_._insideMethodBody = true;
    _DartRestorerBase__pushClosureContext(this_, '${enumName}_${methodName}');
    final bool isVoidReturn = ((proc.function.returnType is VoidType) || proc.isSetter);
    if (isVoidReturn) {
      _DeclarationRestorer__restoreSetterBody(this_, proc.function.body!);
    }
 else {
      _DeclarationRestorer__restoreBody(this_, proc.function.body!);
    }
    _DartRestorerBase__popClosureContext(this_);
    this_._insideMethodBody = false;
  }
 else {
    this_._buf.write(';\n');
  }
  this_._buf.write('\n');
}

bool _DeclarationRestorer__isEnumInternalParam(dynamic this__, String name) {
  final this_ = this__;
  return ((((name == 'index') || (name == 'name')) || (name == '#index')) || (name == '#name'));
}

String _DeclarationRestorer__extractEnumValueArgs(dynamic this__, Expression expr, StaticList<String> userParamNames) {
  final this_ = this__;
  if (((expr is ConstantExpression) && (expr.constant is InstanceConstant))) {
    final InstanceConstant ic = (expr.constant as InstanceConstant);
    final StaticList<String> parts = StaticList<String>.of([]);
    for (final entry in ic.fieldValues.entries) {
      final String fieldName = entry.key.asField.name.text;
      if (userParamNames.contains(fieldName)) {
        parts.add(_ConstantRestorer__restoreConstant(this_, entry.value));
      }
    }
    return parts.join(', ');
  }
  return '';
}

void _DeclarationRestorer__restoreClassMembers(dynamic this__, Class cls) {
  final this_ = this__;
  for (final f in cls.fields)   _DeclarationRestorer__restoreField(this_, f);
  for (final c in cls.constructors)   _DeclarationRestorer__restoreConstructor(this_, cls, c);
  for (final p in cls.procedures)   _DeclarationRestorer__restoreProcedure(this_, p);
}

void _DeclarationRestorer__restoreField(dynamic this__, Field field, {bool isTopLevel = false}) {
  final this_ = this__;
  this_._buf.write(this_._pad);
  if ((field.isStatic && !(isTopLevel)))   this_._buf.write('static ');
  if (field.isLate)   this_._buf.write('late ');
  if (field.isConst)   this_._buf.write('const ');
 else   if (field.isFinal)   this_._buf.write('final ');
  this_._buf.write(_TypeUtils__restoreType(this_, field.type));
  this_._buf.write(' ${field.name.text}');
  if (!((field.initializer == null))) {
    this_._buf.write(' = ');
    this_._buf.write(_DartRestorerBase__restoreExpr(this_, field.initializer!));
  }
  this_._buf.write(';\n');
}

void _DeclarationRestorer__restoreConstructor(dynamic this__, Class cls, Constructor ctor) {
  final this_ = this__;
  this_._buf.write(this_._pad);
  if (ctor.isConst)   this_._buf.write('const ');
  this_._buf.write(cls.name);
  final String ctorName = ctor.name.text;
  if (ctorName.isNotEmpty)   this_._buf.write('.${ctorName}');
  this_._buf.write('(');
  _DeclarationRestorer__writeParams(this_, ctor.function);
  this_._buf.write(')');
  final StaticList<String> inits = StaticList<String>.of([]);
  for (final init in ctor.initializers) {
    if ((init is FieldInitializer)) {
      inits.add('${init.field.name.text} = ${_DartRestorerBase__restoreExpr(this_, init.value)}');
    }
 else     if ((init is SuperInitializer)) {
      final String superCtorName = init.target.name.text;
      final String args = _TypeUtils__restoreArgs(this_, init.arguments);
      if (superCtorName.isEmpty) {
        inits.add('super(${args})');
      }
 else {
        inits.add('super.${superCtorName}(${args})');
      }
    }
 else     if ((init is RedirectingInitializer)) {
      final String redirName = init.target.name.text;
      final String args = _TypeUtils__restoreArgs(this_, init.arguments);
      if (redirName.isEmpty) {
        inits.add('this(${args})');
      }
 else {
        inits.add('this.${redirName}(${args})');
      }
    }
 else     if ((init is AssertInitializer)) {
      final String cond = _DartRestorerBase__restoreExpr(this_, init.statement.condition);
      final String msg = (!((init.statement.message == null)) ? ', ${_DartRestorerBase__restoreExpr(this_, init.statement.message!)}' : '');
      inits.add('assert(${cond}${msg})');
    }
  }
  if (inits.isNotEmpty) {
    this_._buf.write(' : ${inits.join(', ')}');
  }
  if ((!((ctor.function.body == null)) && !((ctor.function.body is EmptyStatement)))) {
    this_._buf.write(' ');
    _DartRestorerBase__restoreStmt(this_, ctor.function.body!);
  }
 else {
    this_._buf.write(';\n');
  }
  this_._buf.write('\n');
}

void _DeclarationRestorer__restoreProcedure(dynamic this__, Procedure proc) {
  final this_ = this__;
  if ((proc.isAbstract && (proc.function.body == null))) {
    _DeclarationRestorer__restoreAbstractProcedure(this_, proc);
    return;
  }
  final String rawName = proc.name.text;
  if (_DartRestorerBase__isExtensionMethodName(this_, rawName)) {
    _DeclarationRestorer__restoreExtensionProcedure(this_, proc);
    return;
  }
  final StaticSet<VariableDeclaration> savedBoxedVars = StaticSet<VariableDeclaration>.of(this_._boxedVars);
  final StaticSet<VariableDeclaration> savedCurrentParams = StaticSet<VariableDeclaration>.of(this_._currentFunctionParams);
  if (!((proc.function.body == null))) {
    _DartRestorerBase__preanalyzeBoxedVarsForFunc(this_, proc.function);
    this_._currentFunctionParams.clear();
    this_._currentFunctionParams.addAll(proc.function.positionalParameters);
    this_._currentFunctionParams.addAll(proc.function.namedParameters);
  }
  final StaticList<VariableDeclaration> boxedParamsForProc = StaticList<VariableDeclaration>.of([]);
  for (final p in proc.function.positionalParameters) {
    if (this_._boxedVars.contains(p))     boxedParamsForProc.add(p);
  }
  for (final p in proc.function.namedParameters) {
    if (this_._boxedVars.contains(p))     boxedParamsForProc.add(p);
  }
  this_._buf.write(this_._pad);
  if (((proc.isStatic && !((proc.enclosingClass == null))) && !(proc.isFactory)))   this_._buf.write('static ');
  if (proc.isFactory) {
    this_._buf.write('factory ');
    this_._buf.write(proc.enclosingClass!.name);
    final String factoryName = proc.name.text;
    if (factoryName.isNotEmpty)     this_._buf.write('.${factoryName}');
    this_._buf.write('(');
    _DeclarationRestorer__writeParams(this_, proc.function, proc: proc);
    this_._buf.write(')');
  }
 else   if (proc.isGetter) {
    this_._buf.write(_TypeUtils__restoreType(this_, proc.function.returnType));
    this_._buf.write(' get ${proc.name.text}');
  }
 else   if (proc.isSetter) {
    this_._buf.write('set ${proc.name.text}');
    this_._buf.write('(');
    _DeclarationRestorer__writeParams(this_, proc.function);
    this_._buf.write(')');
  }
 else {
    if (!((proc.enclosingClass == null))) {
      for (final ann in proc.annotations) {
        if (((ann is ConstantExpression) && (ann.constant is InstanceConstant))) {
          final InstanceConstant ic = (ann.constant as InstanceConstant);
          if ((ic.classNode.name == 'override')) {
            this_._buf.write('@override\n${this_._pad}');
          }
        }
      }
    }
    this_._buf.write(_TypeUtils__restoreType(this_, proc.function.returnType));
    this_._buf.write(' ');
    final String name = proc.name.text;
    if (_DartRestorerBase__isOperatorName(this_, name)) {
      this_._buf.write('operator ${name}');
    }
 else {
      this_._buf.write(name);
    }
    _DeclarationRestorer__writeTypeParams(this_, proc.function.typeParameters);
    this_._buf.write('(');
    _DeclarationRestorer__writeParams(this_, proc.function, proc: proc);
    this_._buf.write(')');
  }
  final AsyncMarker marker = proc.function.asyncMarker;
  if ((marker == AsyncMarker.AsyncStar))   this_._buf.write(' async*');
  if ((marker == AsyncMarker.SyncStar))   this_._buf.write(' sync*');
  if (!((proc.function.body == null))) {
    this_._buf.write(' ');
    final bool isVoidReturn = ((proc.function.returnType is VoidType) || proc.isSetter);
    if (((marker == AsyncMarker.Async) && !(isVoidReturn))) {
      final DartType retType = proc.function.returnType;
      String innerRetType = 'dynamic';
      if (((retType is InterfaceType) && retType.typeArguments.isNotEmpty)) {
        innerRetType = _TypeUtils__restoreType(this_, retType.typeArguments.first);
      }
      final StaticList<VariableDeclaration> allParams = (() {       final StaticList<VariableDeclaration> _v140 = StaticList<VariableDeclaration>.of(proc.function.positionalParameters);
      _v140.addAll(proc.function.namedParameters);
 return _v140; })();
      final String funcName = proc.name.text;
      _DartRestorerBase__pushClosureContext(this_, funcName);
      _DeclarationRestorer__emitAsyncClosureEnv(this_, envBaseName: this_._closureContext, func: proc.function, innerReturnType: innerRetType, params: allParams, boxedParams: boxedParamsForProc);
      _DartRestorerBase__popClosureContext(this_);
    }
 else {
      if (isVoidReturn) {
        _DeclarationRestorer__restoreSetterBody(this_, proc.function.body!);
      }
 else {
        if (boxedParamsForProc.isNotEmpty) {
          _DeclarationRestorer__restoreBodyWithBoxedParams(this_, proc.function.body!, boxedParamsForProc);
        }
 else {
          _DeclarationRestorer__restoreBody(this_, proc.function.body!);
        }
      }
    }
  }
 else {
    this_._buf.write(';\n');
  }
  this_._buf.write('\n');
  this_._boxedVars.clear();
  this_._boxedVars.addAll(savedBoxedVars);
  this_._currentFunctionParams.clear();
  this_._currentFunctionParams.addAll(savedCurrentParams);
}

void _DeclarationRestorer__restoreExtensionProcedure(dynamic this__, Procedure proc) {
  final this_ = this__;
  if ((proc.function.body == null))   return;
  final String rawName = proc.name.text;
  final String cleanedFuncName = _DartRestorerBase__sanitizeExtensionMethodName(this_, rawName);
  this_._buf.write(this_._pad);
  this_._buf.write(_TypeUtils__restoreType(this_, proc.function.returnType));
  this_._buf.write(' ${cleanedFuncName}');
  _DeclarationRestorer__writeTypeParams(this_, proc.function.typeParameters);
  this_._buf.write('(');
  _DeclarationRestorer__writeParamsWithExtensionThis(this_, proc.function, proc: proc);
  this_._buf.write(')');
  final AsyncMarker marker = proc.function.asyncMarker;
  if ((marker == AsyncMarker.AsyncStar))   this_._buf.write(' async*');
  if ((marker == AsyncMarker.SyncStar))   this_._buf.write(' sync*');
  this_._buf.write(' ');
  this_._insideMethodBody = true;
  final bool isVoidReturn = ((proc.function.returnType is VoidType) || proc.isSetter);
  if (((marker == AsyncMarker.Async) && !(isVoidReturn))) {
    final DartType retType = proc.function.returnType;
    String innerRetType = 'dynamic';
    if (((retType is InterfaceType) && retType.typeArguments.isNotEmpty)) {
      innerRetType = _TypeUtils__restoreType(this_, retType.typeArguments.first);
    }
    final StaticList<VariableDeclaration> allParams = (() {     final StaticList<VariableDeclaration> _v141 = StaticList<VariableDeclaration>.of(proc.function.positionalParameters);
    _v141.addAll(proc.function.namedParameters);
 return _v141; })();
    _DartRestorerBase__pushClosureContext(this_, cleanedFuncName);
    _DeclarationRestorer__emitAsyncClosureEnv(this_, envBaseName: this_._closureContext, func: proc.function, innerReturnType: innerRetType, params: allParams);
    _DartRestorerBase__popClosureContext(this_);
  }
 else {
    _DartRestorerBase__pushClosureContext(this_, cleanedFuncName);
    if (isVoidReturn) {
      _DeclarationRestorer__restoreSetterBody(this_, proc.function.body!);
    }
 else {
      _DeclarationRestorer__restoreBody(this_, proc.function.body!);
    }
    _DartRestorerBase__popClosureContext(this_);
  }
  this_._insideMethodBody = false;
  this_._buf.write('\n');
}

void _DeclarationRestorer__writeParamsWithExtensionThis(dynamic this__, FunctionNode func, {Procedure? proc = null}) {
  final this_ = this__;
  final StaticList<VariableDeclaration> pos = func.positionalParameters;
  final StaticList<VariableDeclaration> named = func.namedParameters;
  final int reqCount = func.requiredParameterCount;
  final StaticList<String> parts = StaticList<String>.of([]);
  for (var i = 0; (i < pos.length); i = (i + 1)) {
    final VariableDeclaration p = pos[i];
    final StringBuffer sb = StringBuffer();
    if (_TypeUtils__needsCovariant(this_, p, func, proc))     sb.write('covariant ');
    if (p.isFinal)     sb.write('final ');
    sb.write(_TypeUtils__restoreType(this_, p.type));
    sb.write(' ');
    final String rawParamName = (p.name ?? '_p${i}');
    final String cleanName = ((rawParamName == 'this') ? 'this_' : _TypeUtils__cleanVarName(this_, rawParamName));
    sb.write(cleanName);
    p.name = cleanName;
    if (((i >= reqCount) && !((p.initializer == null)))) {
      sb.write(' = ${_DartRestorerBase__restoreExpr(this_, p.initializer!)}');
    }
    parts.add(sb.toString());
  }
  if (named.isNotEmpty) {
    if (parts.isNotEmpty) {
      this_._buf.write(parts.join(', '));
      this_._buf.write(', ');
    }
    this_._buf.write('{${_DeclarationRestorer__namedParams(this_, named)}}');
  }
 else {
    this_._buf.write(parts.join(', '));
  }
}

void _DeclarationRestorer__restoreAbstractProcedure(dynamic this__, Procedure proc) {
  final this_ = this__;
  this_._buf.write(this_._pad);
  if (proc.isGetter) {
    this_._buf.write(_TypeUtils__restoreType(this_, proc.function.returnType));
    this_._buf.write(' get ${proc.name.text};\n\n');
  }
 else {
    this_._buf.write(_TypeUtils__restoreType(this_, proc.function.returnType));
    this_._buf.write(' ');
    this_._buf.write(proc.name.text);
    _DeclarationRestorer__writeTypeParams(this_, proc.function.typeParameters);
    this_._buf.write('(');
    _DeclarationRestorer__writeParams(this_, proc.function, proc: proc);
    this_._buf.write(');\n\n');
  }
}

void _DeclarationRestorer__restoreBody(dynamic this__, Statement body) {
  final this_ = this__;
  if ((body is Block)) {
    _StatementRestorer__restoreBlock(this_, body);
  }
 else {
    this_._buf.write('{\n');
    this_._indent = (this_._indent + 1);
    _DartRestorerBase__restoreStmt(this_, body);
    this_._indent = (this_._indent - 1);
    this_._buf.write('${this_._pad}}\n');
  }
}

void _DeclarationRestorer__restoreBodyWithBoxedParams(dynamic this__, Statement body, StaticList<VariableDeclaration> boxedParams) {
  final this_ = this__;
  if (boxedParams.isEmpty) {
    _DeclarationRestorer__restoreBody(this_, body);
    return;
  }
  this_._buf.write('{\n');
  this_._indent = (this_._indent + 1);
  for (final p in boxedParams) {
    final String baseName = p.name!;
    final String boxType = _TypeUtils__boxTypeNameFor(this_, p.type)!;
    this_._buf.write('${this_._pad}${boxType} ${baseName} = ${boxType}(${baseName}_raw);\n');
  }
  if ((body is Block)) {
    for (final s in body.statements) {
      _DartRestorerBase__restoreStmt(this_, s);
    }
  }
 else {
    _DartRestorerBase__restoreStmt(this_, body);
  }
  this_._indent = (this_._indent - 1);
  this_._buf.write('${this_._pad}}\n');
}

void _DeclarationRestorer__restoreSetterBody(dynamic this__, Statement body) {
  final this_ = this__;
  if ((body is Block)) {
    this_._buf.write('{\n');
    this_._indent = (this_._indent + 1);
    for (final s in body.statements)     do {
{
        if ((s is ReturnStatement)) {
          if (!((s.expression == null))) {
            this_._buf.write('${this_._pad}${_DartRestorerBase__restoreExpr(this_, s.expression!)};\n');
          }
          break;
        }
        _DartRestorerBase__restoreStmt(this_, s);
      }
    } while (false);
    this_._indent = (this_._indent - 1);
    this_._buf.write('${this_._pad}}\n');
  }
 else   if ((body is ReturnStatement)) {
    this_._buf.write('{\n');
    this_._indent = (this_._indent + 1);
    if (!((body.expression == null))) {
      this_._buf.write('${this_._pad}${_DartRestorerBase__restoreExpr(this_, body.expression!)};\n');
    }
    this_._indent = (this_._indent - 1);
    this_._buf.write('${this_._pad}}\n');
  }
 else {
    _DeclarationRestorer__restoreBody(this_, body);
  }
}

void _DeclarationRestorer__writeTypeParams(dynamic this__, StaticList<TypeParameter> params) {
  final this_ = this__;
  if (params.isEmpty)   return;
  this_._buf.write('<');
  for (var i = 0; (i < params.length); i = (i + 1)) {
    if ((i > 0))     this_._buf.write(', ');
    this_._buf.write((params[i].name ?? 'T'));
{
      final String bound = _TypeUtils__restoreType(this_, params[i].bound);
      if (((!((bound == 'Object')) && !((bound == 'Object?'))) && !((bound == 'dynamic')))) {
        this_._buf.write(' extends ${bound}');
      }
    }
  }
  this_._buf.write('>');
}

void _DeclarationRestorer__writeTypeParamNames(dynamic this__, StaticList<TypeParameter> params) {
  final this_ = this__;
  if (params.isEmpty)   return;
  this_._buf.write('<');
  for (var i = 0; (i < params.length); i = (i + 1)) {
    if ((i > 0))     this_._buf.write(', ');
    this_._buf.write((params[i].name ?? 'T'));
  }
  this_._buf.write('>');
}

String _DeclarationRestorer__typeParamNamesStr(dynamic this__, StaticList<TypeParameter> params) {
  final this_ = this__;
  if (params.isEmpty)   return '';
  final String names = params.map(ClosureEnv_anon_117()).join(', ');
  return '<${names}>';
}

void _DeclarationRestorer__writeCombinedTypeParams(dynamic this__, StaticList<TypeParameter> classParams, StaticList<TypeParameter> methodParams) {
  final this_ = this__;
  if ((classParams.isEmpty && methodParams.isEmpty))   return;
  final StaticSet<String?> classParamNames = StaticSet.of(classParams.map(ClosureEnv_anon_118()).toSet().toList());
  final StaticList<TypeParameter> deduped = (() {   final StaticList<TypeParameter> _v146 = StaticList<TypeParameter>.of(classParams);
  _v146.addAll(methodParams.where(ClosureEnv_anon_119(classParamNames)));
 return _v146; })();
  if (deduped.isEmpty)   return;
  _DeclarationRestorer__writeTypeParams(this_, deduped);
}

void _DeclarationRestorer__writeParams(dynamic this__, FunctionNode func, {Procedure? proc = null}, {bool suppressCovariant = false}, {bool flattenOptional = false}) {
  final this_ = this__;
  final StaticList<VariableDeclaration> pos = func.positionalParameters;
  final StaticList<VariableDeclaration> named = func.namedParameters;
  final int reqCount = func.requiredParameterCount;
  final StaticList<String> parts = StaticList<String>.of([]);
  bool openedBracket = false;
  for (var i = 0; (i < pos.length); i = (i + 1)) {
    final VariableDeclaration p = pos[i];
    if ((((i == reqCount) && !(openedBracket)) && !(flattenOptional))) {
      openedBracket = true;
    }
    final StringBuffer sb = StringBuffer();
    if ((!(suppressCovariant) && _TypeUtils__needsCovariant(this_, p, func, proc)))     sb.write('covariant ');
    if (p.isFinal)     sb.write('final ');
    sb.write(_TypeUtils__restoreType(this_, p.type));
    sb.write(' ');
    final String cleanName = _TypeUtils__cleanVarName(this_, (p.name ?? '_p${i}'));
    p.name = cleanName;
    final String displayName = (this_._boxedVars.contains(p) ? '${cleanName}_raw' : cleanName);
    sb.write(displayName);
    if (((!(flattenOptional) && (i >= reqCount)) && !((p.initializer == null)))) {
      sb.write(' = ${_DartRestorerBase__restoreExpr(this_, p.initializer!)}');
    }
    parts.add(sb.toString());
  }
  if ((!(flattenOptional) && openedBracket)) {
    final StaticList<String> reqParts = parts.sublist(0, reqCount);
    final StaticList<String> optParts = parts.sublist(reqCount);
    final StaticList<String> allParts = (() {     final StaticList<String> _v148 = StaticList<String>.of(reqParts);
    _v148.add('[${optParts.join(', ')}]');
 return _v148; })();
    if (named.isNotEmpty) {
      allParts.add('{${_DeclarationRestorer__namedParams(this_, named)}}');
    }
    this_._buf.write(allParts.join(', '));
  }
 else   if (named.isNotEmpty) {
    if (parts.isNotEmpty) {
      this_._buf.write(parts.join(', '));
      this_._buf.write(', ');
    }
    this_._buf.write('{${_DeclarationRestorer__namedParams(this_, named)}}');
  }
 else {
    this_._buf.write(parts.join(', '));
  }
}

String _DeclarationRestorer__namedParams(dynamic this__, StaticList<VariableDeclaration> named) {
  final this_ = this__;
  return named.map(ClosureEnv_anon_120(this_)).join(', ');
}

void _DeclarationRestorer__emitAsyncClosureEnv(dynamic this__, {required String envBaseName}, {required FunctionNode func}, {required String innerReturnType}, {required StaticList<VariableDeclaration> params}, {String? thisParam = null}, {StaticList<VariableDeclaration> boxedParams = const []}) {
  final this_ = this__;
  final int closureId = (() { final _let150 = this_._closureCounter; return (() { final _let151 = this_._closureCounter = (_let150 + 1); return _let150; })(); })();
  final String envClassName = 'ClosureEnv_${envBaseName}_${closureId}';
  final StringBuffer declBuf = StringBuffer();
  final StaticList<_AsyncEnvFieldValue> fields = StaticList<_AsyncEnvFieldValue>.of([]);
  if (!((thisParam == null))) {
    fields.add(_AsyncEnvField_new(_AsyncEnvFieldValue(), name: 'this_', typeStr: thisParam));
  }
  for (final p in params) {
    final String paramName = p.name!;
    final String rawType = _TypeUtils__restoreType(this_, p.type);
    final String? boxType = _TypeUtils__boxTypeNameFor(this_, p.type);
    if (!((boxType == null))) {
      fields.add(_AsyncEnvField_new(_AsyncEnvFieldValue(), name: paramName, typeStr: boxType, isBoxed: true, boxType: boxType, rawType: rawType));
    }
 else {
      fields.add(_AsyncEnvField_new(_AsyncEnvFieldValue(), name: paramName, typeStr: rawType));
    }
  }
  fields.add(_AsyncEnvField_new(_AsyncEnvFieldValue(), name: '_promise', typeStr: 'Promise<${innerReturnType}>'));
  declBuf.write('class ${envClassName} {\n');
  for (final f in fields) {
    declBuf.write('  ${f.typeStr} ${f.name};\n');
  }
  final StaticList<String> ctorParams = StaticList<String>.of([]);
  final StaticList<String> initParts = StaticList<String>.of(['_promise = Promise<${innerReturnType}>()']);
  for (final f in fields)   do {
{
      if ((f.name == '_promise'))       break;
      if (f.isBoxed) {
        ctorParams.add('${f.rawType} ${f.name}');
        initParts.add('${f.name} = ${f.boxType}(${f.name})');
      }
 else {
        ctorParams.add('this.${f.name}');
      }
    }
  } while (false);
  declBuf.write('  ${envClassName}(${ctorParams.join(', ')}) : ${initParts.join(', ')};\n');
  final String staticCallName = '${envClassName}_call';
  declBuf.write('  void call() => ${staticCallName}(this);\n');
  declBuf.write('}\n');
  declBuf.write('void ${staticCallName}(${envClassName} env)');
  final StaticMap<VariableDeclaration, String> savedEnvPrefix = StaticMap<VariableDeclaration, String>.from(this_._capturedVarEnvPrefix);
  for (final p in params) {
    this_._capturedVarEnvPrefix[p] = 'env.';
  }
  final StaticSet<VariableDeclaration> savedBoxedVarsForAsync = StaticSet<VariableDeclaration>.of(this_._boxedVars);
  for (final p in params) {
    if (!((_TypeUtils__boxTypeNameFor(this_, p.type) == null))) {
      this_._boxedVars.add(p);
    }
  }
  _DartRestorerBase__pushClosureContext(this_, envClassName);
  final bool savedInsideAsync = this_._insideAsyncFunction;
  final String savedAsyncInnerType = this_._asyncInnerReturnType;
  this_._insideAsyncFunction = true;
  this_._asyncInnerReturnType = innerReturnType;
  final StringBuffer oldBuf = this_._buf;
  final StringBuffer tmpBuf = StringBuffer();
  this_._buf = tmpBuf;
  final Statement body = func.body!;
  if ((body is Block)) {
    this_._buf.write(' {\n');
    this_._indent = (this_._indent + 1);
    for (final p in boxedParams)     do {
{
        if (!((_TypeUtils__boxTypeNameFor(this_, p.type) == null)))         break;
        final String baseName = p.name!;
        final String boxType = _TypeUtils__boxTypeNameFor(this_, p.type)!;
        this_._buf.write('${this_._pad}${boxType} ${baseName} = ${boxType}(${baseName}_raw);\n');
      }
    } while (false);
    for (final s in body.statements) {
      _DartRestorerBase__restoreStmt(this_, s);
    }
    this_._indent = (this_._indent - 1);
    this_._buf.write('${this_._pad}}\n');
  }
 else {
    this_._buf.write(' {\n');
    this_._indent = (this_._indent + 1);
    _DartRestorerBase__restoreStmt(this_, body);
    this_._indent = (this_._indent - 1);
    this_._buf.write('${this_._pad}}\n');
  }
  this_._buf = oldBuf;
  declBuf.write(tmpBuf);
  this_._insideAsyncFunction = savedInsideAsync;
  this_._asyncInnerReturnType = savedAsyncInnerType;
  _DartRestorerBase__popClosureContext(this_);
  this_._capturedVarEnvPrefix.clear();
  this_._capturedVarEnvPrefix.addAll(savedEnvPrefix);
  this_._boxedVars.clear();
  this_._boxedVars.addAll(savedBoxedVarsForAsync);
  this_._pendingClosureDecls.add(declBuf.toString());
  this_._buf.write('{\n');
  this_._indent = (this_._indent + 1);
  final StaticList<String> envCtorArgs = StaticList<String>.of([]);
  if (!((thisParam == null))) {
    envCtorArgs.add('this_');
  }
  for (final p in params) {
    envCtorArgs.add(p.name!);
  }
  this_._buf.write('${this_._pad}final env = ${envClassName}(${envCtorArgs.join(', ')});\n');
  this_._buf.write('${this_._pad}env._promise.setStartCallback(env.call);\n');
  this_._buf.write('${this_._pad}return env._promise;\n');
  this_._indent = (this_._indent - 1);
  this_._buf.write('${this_._pad}}\n');
}

void _DeclarationRestorer__emitAsyncClosureEnvForMethod(dynamic this__, {required String envBaseName}, {required FunctionNode func}, {required String innerReturnType}, {required StaticList<VariableDeclaration> params}, {required String thisParam}, {required String thisRawParam}, {StaticList<VariableDeclaration> boxedParams = const []}) {
  final this_ = this__;
  final int closureId = (() { final _let152 = this_._closureCounter; return (() { final _let153 = this_._closureCounter = (_let152 + 1); return _let152; })(); })();
  final String envClassName = 'ClosureEnv_${envBaseName}_${closureId}';
  final StringBuffer declBuf = StringBuffer();
  final StaticList<_AsyncEnvFieldValue> fields = StaticList<_AsyncEnvFieldValue>.of([]);
  fields.add(_AsyncEnvField_new(_AsyncEnvFieldValue(), name: 'this_', typeStr: thisParam));
  for (final p in params) {
    final String paramName = p.name!;
    final String rawType = _TypeUtils__restoreType(this_, p.type);
    final String? boxType = _TypeUtils__boxTypeNameFor(this_, p.type);
    if (!((boxType == null))) {
      fields.add(_AsyncEnvField_new(_AsyncEnvFieldValue(), name: paramName, typeStr: boxType, isBoxed: true, boxType: boxType, rawType: rawType));
    }
 else {
      fields.add(_AsyncEnvField_new(_AsyncEnvFieldValue(), name: paramName, typeStr: rawType));
    }
  }
  fields.add(_AsyncEnvField_new(_AsyncEnvFieldValue(), name: '_promise', typeStr: 'Promise<${innerReturnType}>'));
  declBuf.write('class ${envClassName} {\n');
  for (final f in fields) {
    declBuf.write('  ${f.typeStr} ${f.name};\n');
  }
  final StaticList<String> ctorParams = StaticList<String>.of([]);
  final StaticList<String> initParts = StaticList<String>.of(['_promise = Promise<${innerReturnType}>()']);
  for (final f in fields)   do {
{
      if ((f.name == '_promise'))       break;
      if (f.isBoxed) {
        ctorParams.add('${f.rawType} ${f.name}');
        initParts.add('${f.name} = ${f.boxType}(${f.name})');
      }
 else {
        ctorParams.add('this.${f.name}');
      }
    }
  } while (false);
  declBuf.write('  ${envClassName}(${ctorParams.join(', ')}) : ${initParts.join(', ')};\n');
  final String staticCallName = '${envClassName}_call';
  declBuf.write('  void call() => ${staticCallName}(this);\n');
  declBuf.write('}\n');
  declBuf.write('void ${staticCallName}(${envClassName} env)');
  final StaticMap<VariableDeclaration, String> savedEnvPrefix = StaticMap<VariableDeclaration, String>.from(this_._capturedVarEnvPrefix);
  for (final p in params) {
    this_._capturedVarEnvPrefix[p] = 'env.';
  }
  final StaticSet<VariableDeclaration> savedBoxedVarsForAsync = StaticSet<VariableDeclaration>.of(this_._boxedVars);
  for (final p in params) {
    if (!((_TypeUtils__boxTypeNameFor(this_, p.type) == null))) {
      this_._boxedVars.add(p);
    }
  }
  final bool savedThisInEnv = this_._thisIsCapturedInEnv;
  this_._thisIsCapturedInEnv = true;
  _DartRestorerBase__pushClosureContext(this_, envClassName);
  final bool savedInsideAsync = this_._insideAsyncFunction;
  final String savedAsyncInnerType = this_._asyncInnerReturnType;
  this_._insideAsyncFunction = true;
  this_._asyncInnerReturnType = innerReturnType;
  final StringBuffer oldBuf = this_._buf;
  final StringBuffer tmpBuf = StringBuffer();
  this_._buf = tmpBuf;
  final Statement body = func.body!;
  if ((body is Block)) {
    this_._buf.write(' {\n');
    this_._indent = (this_._indent + 1);
    for (final p in boxedParams)     do {
{
        if (!((_TypeUtils__boxTypeNameFor(this_, p.type) == null)))         break;
        final String baseName = p.name!;
        final String boxType = _TypeUtils__boxTypeNameFor(this_, p.type)!;
        this_._buf.write('${this_._pad}${boxType} ${baseName} = ${boxType}(${baseName}_raw);\n');
      }
    } while (false);
    for (final s in body.statements) {
      _DartRestorerBase__restoreStmt(this_, s);
    }
    this_._indent = (this_._indent - 1);
    this_._buf.write('${this_._pad}}\n');
  }
 else {
    this_._buf.write(' {\n');
    this_._indent = (this_._indent + 1);
    _DartRestorerBase__restoreStmt(this_, body);
    this_._indent = (this_._indent - 1);
    this_._buf.write('${this_._pad}}\n');
  }
  this_._buf = oldBuf;
  declBuf.write(tmpBuf);
  this_._insideAsyncFunction = savedInsideAsync;
  this_._asyncInnerReturnType = savedAsyncInnerType;
  _DartRestorerBase__popClosureContext(this_);
  this_._capturedVarEnvPrefix.clear();
  this_._capturedVarEnvPrefix.addAll(savedEnvPrefix);
  this_._boxedVars.clear();
  this_._boxedVars.addAll(savedBoxedVarsForAsync);
  this_._thisIsCapturedInEnv = savedThisInEnv;
  this_._pendingClosureDecls.add(declBuf.toString());
  this_._buf.write('{\n');
  this_._indent = (this_._indent + 1);
  this_._buf.write('${this_._pad}final this_ = ${thisRawParam} as ${thisParam};\n');
  final StaticList<String> envCtorArgs = StaticList<String>.of(['this_']);
  for (final p in params) {
    envCtorArgs.add(p.name!);
  }
  this_._buf.write('${this_._pad}final env = ${envClassName}(${envCtorArgs.join(', ')});\n');
  this_._buf.write('${this_._pad}env._promise.setStartCallback(env.call);\n');
  this_._buf.write('${this_._pad}return env._promise;\n');
  this_._indent = (this_._indent - 1);
  this_._buf.write('${this_._pad}}\n');
}


class _AsyncEnvFieldValue extends VPtr {
  late String name;
  late String typeStr;
  late bool isBoxed;
  late String? boxType;
  late String? rawType;
}

_AsyncEnvFieldValue _AsyncEnvField_new(dynamic this__, {required String name, required String typeStr, bool isBoxed = false, String? boxType = null, String? rawType = null}) {
  final this_ = this__ as _AsyncEnvFieldValue;
  this_.name = name;
  this_.typeStr = typeStr;
  this_.isBoxed = isBoxed;
  this_.boxType = boxType;
  this_.rawType = rawType;
  return this_;
}


class DartRestorer__DartRestorerBase__TypeUtilsValue extends _DartRestorerBaseValue {
}


class DartRestorer__DartRestorerBase__TypeUtils__ConstantRestorerValue extends DartRestorer__DartRestorerBase__TypeUtilsValue {
}


class DartRestorer__DartRestorerBase__TypeUtils__ConstantRestorer__ExpressionRestorerValue extends DartRestorer__DartRestorerBase__TypeUtils__ConstantRestorerValue {
}


class DartRestorer__DartRestorerBase__TypeUtils__ConstantRestorer__ExpressionRestorer__StatementRestorerValue extends DartRestorer__DartRestorerBase__TypeUtils__ConstantRestorer__ExpressionRestorerValue {
}


class DartRestorer__DartRestorerBase__TypeUtils__ConstantRestorer__ExpressionRestorer__StatementRestorer__DeclarationRestorerValue extends DartRestorer__DartRestorerBase__TypeUtils__ConstantRestorer__ExpressionRestorer__StatementRestorerValue {
}


class _ConstantRestorer__DartRestorerBase__TypeUtilsValue extends VPtr implements _DartRestorerBaseValue {
}


class _ExpressionRestorer__DartRestorerBase__TypeUtilsValue extends VPtr implements _DartRestorerBaseValue {
}


class _ExpressionRestorer__DartRestorerBase__TypeUtils__ConstantRestorerValue extends VPtr {
}


class _StatementRestorer__DartRestorerBase__TypeUtilsValue extends VPtr implements _DartRestorerBaseValue {
}


class _StatementRestorer__DartRestorerBase__TypeUtils__ExpressionRestorerValue extends VPtr {
}


class _DeclarationRestorer__DartRestorerBase__TypeUtilsValue extends VPtr implements _DartRestorerBaseValue {
}


class _DeclarationRestorer__DartRestorerBase__TypeUtils__ExpressionRestorerValue extends VPtr {
}


class _DeclarationRestorer__DartRestorerBase__TypeUtils__ExpressionRestorer__StatementRestorerValue extends VPtr {
}


String restoreDartFromComponent(Component component) {
  return (DartRestorer_new(DartRestorerValue()).vptr['restore'] as TypeFunction2<String, dynamic, Component>)(DartRestorer_new(DartRestorerValue()), component);
}

_CaptureAnalysisResultValue analyzeCapturedVarsFromFunc(FunctionNode func) {
  final StaticSet<VariableDeclaration> localDecls = StaticSet<VariableDeclaration>.of([]);
  localDecls.addAll(func.positionalParameters);
  localDecls.addAll(func.namedParameters);
  final StaticSet<VariableDeclaration> capturedSet = StaticSet<VariableDeclaration>.of([]);
  BoolBox capturesThis = BoolBox(false);
  if (!((func.body == null))) {
    _collectCaptured(func.body!, localDecls, capturedSet, ClosureEnv_analyzeCapturedVarsFromFunc_121(capturesThis));
  }
  return _CaptureAnalysisResult_new(_CaptureAnalysisResultValue(), capturedDecls: StaticList.of(capturedSet.toList()), capturesThis: capturesThis.value);
}

void _collectCaptured(TreeNode node, StaticSet<VariableDeclaration> localDecls, StaticSet<VariableDeclaration> captured, TypeFunction1<void, bool> onThisCaptured) {
  if ((node is VariableDeclaration)) {
    localDecls.add(node);
    if (!((node.initializer == null))) {
      _collectCaptured(node.initializer!, localDecls, captured, onThisCaptured);
    }
    return;
  }
  if ((node is VariableGet)) {
    if (!(localDecls.contains(node.variable))) {
      captured.add(node.variable);
    }
    return;
  }
  if ((node is VariableSet)) {
    if (!(localDecls.contains(node.variable))) {
      captured.add(node.variable);
    }
    _collectCaptured(node.value, localDecls, captured, onThisCaptured);
    return;
  }
  if ((node is ThisExpression)) {
    onThisCaptured(true);
    return;
  }
  if ((node is FunctionExpression)) {
    final StaticSet<VariableDeclaration> innerLocalDecls = StaticSet<VariableDeclaration>.of([]);
    innerLocalDecls.addAll(node.function.positionalParameters);
    innerLocalDecls.addAll(node.function.namedParameters);
    final StaticSet<VariableDeclaration> innerCaptured = StaticSet<VariableDeclaration>.of([]);
    BoolBox innerCapturesThis = BoolBox(false);
    if (!((node.function.body == null))) {
      _collectCaptured(node.function.body!, innerLocalDecls, innerCaptured, ClosureEnv__collectCaptured_122(innerCapturesThis));
    }
    for (final decl in innerCaptured) {
      if (!(localDecls.contains(decl))) {
        captured.add(decl);
      }
    }
    if (innerCapturesThis.value) {
      onThisCaptured(true);
    }
    return;
  }
  if ((node is Block)) {
    for (final s in node.statements) {
      _collectCaptured(s, localDecls, captured, onThisCaptured);
    }
    return;
  }
  if ((node is ReturnStatement)) {
    if (!((node.expression == null))) {
      _collectCaptured(node.expression!, localDecls, captured, onThisCaptured);
    }
    return;
  }
  if ((node is ExpressionStatement)) {
    _collectCaptured(node.expression, localDecls, captured, onThisCaptured);
    return;
  }
  if ((node is IfStatement)) {
    _collectCaptured(node.condition, localDecls, captured, onThisCaptured);
    _collectCaptured(node.then, localDecls, captured, onThisCaptured);
    if (!((node.otherwise == null))) {
      _collectCaptured(node.otherwise!, localDecls, captured, onThisCaptured);
    }
    return;
  }
  if ((node is ForStatement)) {
    for (final v in node.variables) {
      _collectCaptured(v, localDecls, captured, onThisCaptured);
    }
    if (!((node.condition == null))) {
      _collectCaptured(node.condition!, localDecls, captured, onThisCaptured);
    }
    for (final u in node.updates) {
      _collectCaptured(u, localDecls, captured, onThisCaptured);
    }
    _collectCaptured(node.body, localDecls, captured, onThisCaptured);
    return;
  }
  if ((node is ForInStatement)) {
    _collectCaptured(node.variable, localDecls, captured, onThisCaptured);
    _collectCaptured(node.iterable, localDecls, captured, onThisCaptured);
    _collectCaptured(node.body, localDecls, captured, onThisCaptured);
    return;
  }
  if ((node is WhileStatement)) {
    _collectCaptured(node.condition, localDecls, captured, onThisCaptured);
    _collectCaptured(node.body, localDecls, captured, onThisCaptured);
    return;
  }
  if ((node is DoStatement)) {
    _collectCaptured(node.body, localDecls, captured, onThisCaptured);
    _collectCaptured(node.condition, localDecls, captured, onThisCaptured);
    return;
  }
  if ((node is TryCatch)) {
    _collectCaptured(node.body, localDecls, captured, onThisCaptured);
    for (final c in node.catches) {
      if (!((c.exception == null)))       localDecls.add(c.exception!);
      if (!((c.stackTrace == null)))       localDecls.add(c.stackTrace!);
      _collectCaptured(c.body, localDecls, captured, onThisCaptured);
    }
    return;
  }
  if ((node is TryFinally)) {
    _collectCaptured(node.body, localDecls, captured, onThisCaptured);
    _collectCaptured(node.finalizer, localDecls, captured, onThisCaptured);
    return;
  }
  if ((node is SwitchStatement)) {
    _collectCaptured(node.expression, localDecls, captured, onThisCaptured);
    for (final c in node.cases) {
      _collectCaptured(c.body, localDecls, captured, onThisCaptured);
    }
    return;
  }
  if ((node is InstanceInvocation)) {
    _collectCaptured(node.receiver, localDecls, captured, onThisCaptured);
    for (final a in node.arguments.positional) {
      _collectCaptured(a, localDecls, captured, onThisCaptured);
    }
    for (final a in node.arguments.named) {
      _collectCaptured(a.value, localDecls, captured, onThisCaptured);
    }
    return;
  }
  if ((node is StaticInvocation)) {
    for (final a in node.arguments.positional) {
      _collectCaptured(a, localDecls, captured, onThisCaptured);
    }
    for (final a in node.arguments.named) {
      _collectCaptured(a.value, localDecls, captured, onThisCaptured);
    }
    return;
  }
  if ((node is ConstructorInvocation)) {
    for (final a in node.arguments.positional) {
      _collectCaptured(a, localDecls, captured, onThisCaptured);
    }
    for (final a in node.arguments.named) {
      _collectCaptured(a.value, localDecls, captured, onThisCaptured);
    }
    return;
  }
  if ((node is InstanceGet)) {
    _collectCaptured(node.receiver, localDecls, captured, onThisCaptured);
    return;
  }
  if ((node is InstanceSet)) {
    _collectCaptured(node.receiver, localDecls, captured, onThisCaptured);
    _collectCaptured(node.value, localDecls, captured, onThisCaptured);
    return;
  }
  if ((node is ConditionalExpression)) {
    _collectCaptured(node.condition, localDecls, captured, onThisCaptured);
    _collectCaptured(node.then, localDecls, captured, onThisCaptured);
    _collectCaptured(node.otherwise, localDecls, captured, onThisCaptured);
    return;
  }
  if ((node is LogicalExpression)) {
    _collectCaptured(node.left, localDecls, captured, onThisCaptured);
    _collectCaptured(node.right, localDecls, captured, onThisCaptured);
    return;
  }
  if ((node is Not)) {
    _collectCaptured(node.operand, localDecls, captured, onThisCaptured);
    return;
  }
  if ((node is StringConcatenation)) {
    for (final e in node.expressions) {
      _collectCaptured(e, localDecls, captured, onThisCaptured);
    }
    return;
  }
  if ((node is ListLiteral)) {
    for (final e in node.expressions) {
      _collectCaptured(e, localDecls, captured, onThisCaptured);
    }
    return;
  }
  if ((node is MapLiteral)) {
    for (final e in node.entries) {
      _collectCaptured(e.key, localDecls, captured, onThisCaptured);
      _collectCaptured(e.value, localDecls, captured, onThisCaptured);
    }
    return;
  }
  if ((node is Let)) {
    _collectCaptured(node.variable, localDecls, captured, onThisCaptured);
    _collectCaptured(node.body, localDecls, captured, onThisCaptured);
    return;
  }
  if ((node is BlockExpression)) {
    _collectCaptured(node.body, localDecls, captured, onThisCaptured);
    _collectCaptured(node.value, localDecls, captured, onThisCaptured);
    return;
  }
  if ((node is Throw)) {
    _collectCaptured(node.expression, localDecls, captured, onThisCaptured);
    return;
  }
  if ((node is IsExpression)) {
    _collectCaptured(node.operand, localDecls, captured, onThisCaptured);
    return;
  }
  if ((node is AsExpression)) {
    _collectCaptured(node.operand, localDecls, captured, onThisCaptured);
    return;
  }
  if ((node is EqualsCall)) {
    _collectCaptured(node.left, localDecls, captured, onThisCaptured);
    _collectCaptured(node.right, localDecls, captured, onThisCaptured);
    return;
  }
  if ((node is EqualsNull)) {
    _collectCaptured(node.expression, localDecls, captured, onThisCaptured);
    return;
  }
  if ((node is FunctionInvocation)) {
    _collectCaptured(node.receiver, localDecls, captured, onThisCaptured);
    for (final a in node.arguments.positional) {
      _collectCaptured(a, localDecls, captured, onThisCaptured);
    }
    for (final a in node.arguments.named) {
      _collectCaptured(a.value, localDecls, captured, onThisCaptured);
    }
    return;
  }
  if ((node is DynamicInvocation)) {
    _collectCaptured(node.receiver, localDecls, captured, onThisCaptured);
    for (final a in node.arguments.positional) {
      _collectCaptured(a, localDecls, captured, onThisCaptured);
    }
    for (final a in node.arguments.named) {
      _collectCaptured(a.value, localDecls, captured, onThisCaptured);
    }
    return;
  }
  if ((node is DynamicGet)) {
    _collectCaptured(node.receiver, localDecls, captured, onThisCaptured);
    return;
  }
  if ((node is DynamicSet)) {
    _collectCaptured(node.receiver, localDecls, captured, onThisCaptured);
    _collectCaptured(node.value, localDecls, captured, onThisCaptured);
    return;
  }
  if ((node is SuperMethodInvocation)) {
    for (final a in node.arguments.positional) {
      _collectCaptured(a, localDecls, captured, onThisCaptured);
    }
    for (final a in node.arguments.named) {
      _collectCaptured(a.value, localDecls, captured, onThisCaptured);
    }
    return;
  }
  if ((node is SuperPropertyGet)) {
    onThisCaptured(true);
    return;
  }
  if ((node is SuperPropertySet)) {
    onThisCaptured(true);
    _collectCaptured(node.value, localDecls, captured, onThisCaptured);
    return;
  }
  if ((node is StaticGet))   return;
  if ((node is StaticSet)) {
    _collectCaptured(node.value, localDecls, captured, onThisCaptured);
    return;
  }
  if ((node is InstanceGetterInvocation)) {
    _collectCaptured(node.receiver, localDecls, captured, onThisCaptured);
    for (final a in node.arguments.positional) {
      _collectCaptured(a, localDecls, captured, onThisCaptured);
    }
    for (final a in node.arguments.named) {
      _collectCaptured(a.value, localDecls, captured, onThisCaptured);
    }
    return;
  }
  if ((node is SetLiteral)) {
    for (final e in node.expressions) {
      _collectCaptured(e, localDecls, captured, onThisCaptured);
    }
    return;
  }
  if ((node is RecordLiteral)) {
    for (final e in node.positional) {
      _collectCaptured(e, localDecls, captured, onThisCaptured);
    }
    for (final n in node.named) {
      _collectCaptured(n.value, localDecls, captured, onThisCaptured);
    }
    return;
  }
  if ((node is RecordIndexGet)) {
    _collectCaptured(node.receiver, localDecls, captured, onThisCaptured);
    return;
  }
  if ((node is RecordNameGet)) {
    _collectCaptured(node.receiver, localDecls, captured, onThisCaptured);
    return;
  }
  if ((node is LabeledStatement)) {
    _collectCaptured(node.body, localDecls, captured, onThisCaptured);
    return;
  }
  if ((node is YieldStatement)) {
    _collectCaptured(node.expression, localDecls, captured, onThisCaptured);
    return;
  }
  if ((node is AwaitExpression)) {
    _collectCaptured(node.operand, localDecls, captured, onThisCaptured);
    return;
  }
}

class _TearOff_MethodSpecEntry_operatorEq extends TypeFunction2<bool, dynamic, Object> {
  const _TearOff_MethodSpecEntry_operatorEq();
  @override
  bool call(dynamic this_, Object other) => MethodSpecEntry_operatorEq(this_, other);
}
class _TearOff_MethodSpecEntry_get_hashCode extends TypeFunction1<int, dynamic> {
  const _TearOff_MethodSpecEntry_get_hashCode();
  @override
  int call(dynamic this_) => MethodSpecEntry_get_hashCode(this_);
}
class ClosureEnv_anon_1 extends TypeFunction1<bool, DartType> {
  _DartRestorerBaseValue this_;
  ClosureEnv_anon_1(this.this_);
  @override
  bool call(DartType t) => ClosureEnv_anon_1_call(this, t);
}
bool ClosureEnv_anon_1_call(ClosureEnv_anon_1 env, DartType t) {
  return _DartRestorerBase__containsTypeParameter(env.this_, t);
}

class ClosureEnv_anon_2 extends TypeFunction1<bool, DartType> {
  _DartRestorerBaseValue this_;
  ClosureEnv_anon_2(this.this_);
  @override
  bool call(DartType t) => ClosureEnv_anon_2_call(this, t);
}
bool ClosureEnv_anon_2_call(ClosureEnv_anon_2 env, DartType t) {
  return _DartRestorerBase__containsTypeParameter(env.this_, t);
}

class ClosureEnv_anon_3 extends TypeFunction1<String, DartType> {
  _DartRestorerBaseValue this_;
  bool asSuffix;
  ClosureEnv_anon_3(this.this_, this.asSuffix);
  @override
  String call(DartType t) => ClosureEnv_anon_3_call(this, t);
}
String ClosureEnv_anon_3_call(ClosureEnv_anon_3 env, DartType t) {
  return _DartRestorerBase__typeToSpecStr(env.this_, t, asSuffix: env.asSuffix);
}

class ClosureEnv_anon_4 extends TypeFunction1<void, TreeNode> {
  _DartRestorerBaseValue this_;
  StaticSet<VariableDeclaration> out;
  ClosureEnv_anon_4(this.this_, this.out);
  @override
  void call(TreeNode child) => ClosureEnv_anon_4_call(this, child);
}
void ClosureEnv_anon_4_call(ClosureEnv_anon_4 env, TreeNode child) {
  return _DartRestorerBase__collectShallowDecls(env.this_, child, env.out);
}

class ClosureEnv_anon_5 extends TypeFunction1<void, VariableDeclaration> {
  StaticSet<VariableDeclaration> out;
  ClosureEnv_anon_5(this.out);
  @override
  void call(VariableDeclaration v) => ClosureEnv_anon_5_call(this, v);
}
void ClosureEnv_anon_5_call(ClosureEnv_anon_5 env, VariableDeclaration v) {
  return env.out.add(v);
}

class ClosureEnv_anon_6 extends TypeFunction1<void, VariableDeclaration> {
  StaticSet<VariableDeclaration> out;
  ClosureEnv_anon_6(this.out);
  @override
  void call(VariableDeclaration v) => ClosureEnv_anon_6_call(this, v);
}
void ClosureEnv_anon_6_call(ClosureEnv_anon_6 env, VariableDeclaration v) {
  return env.out.add(v);
}

class ClosureEnv_anon_7 extends TypeFunction1<void, TreeNode> {
  _DartRestorerBaseValue this_;
  StaticList<FunctionExpression> out;
  ClosureEnv_anon_7(this.this_, this.out);
  @override
  void call(TreeNode child) => ClosureEnv_anon_7_call(this, child);
}
void ClosureEnv_anon_7_call(ClosureEnv_anon_7 env, TreeNode child) {
  return _DartRestorerBase__collectAllFunctionExpressions(env.this_, child, env.out);
}

class ClosureEnv_anon_8 extends TypeFunction1<String, DartType> {
  _DartRestorerBaseValue this_;
  ClosureEnv_anon_8(this.this_);
  @override
  String call(DartType t) => ClosureEnv_anon_8_call(this, t);
}
String ClosureEnv_anon_8_call(ClosureEnv_anon_8 env, DartType t) {
  return _DartRestorerBase__restoreTypeForSignature(env.this_, t);
}

class _TearOff__CapturedVar_operatorEq extends TypeFunction2<bool, dynamic, Object> {
  const _TearOff__CapturedVar_operatorEq();
  @override
  bool call(dynamic this_, Object other) => _CapturedVar_operatorEq(this_, other);
}
class _TearOff__CapturedVar_get_hashCode extends TypeFunction1<int, dynamic> {
  const _TearOff__CapturedVar_get_hashCode();
  @override
  int call(dynamic this_) => _CapturedVar_get_hashCode(this_);
}
class _TearOff_DartRestorer_restore extends TypeFunction2<String, dynamic, Component> {
  const _TearOff_DartRestorer_restore();
  @override
  String call(dynamic this_, Component component) => DartRestorer_restore(this_, component);
}
class ClosureEnv_anon_9 extends TypeFunction1<bool, Procedure> {
  ClosureEnv_anon_9();
  @override
  bool call(Procedure p) => ClosureEnv_anon_9_call(this, p);
}
bool ClosureEnv_anon_9_call(ClosureEnv_anon_9 env, Procedure p) {
  return (((p.name.text == 'toString') && !(p.isAbstract)) && !((p.function.body == null)));
}

class ClosureEnv_anon_10 extends TypeFunction1<String?, TypeParameter> {
  ClosureEnv_anon_10();
  @override
  String? call(TypeParameter tp) => ClosureEnv_anon_10_call(this, tp);
}
String? ClosureEnv_anon_10_call(ClosureEnv_anon_10 env, TypeParameter tp) {
  return tp.name;
}

class ClosureEnv_anon_11 extends TypeFunction1<bool, TypeParameter> {
  StaticSet<String?> classTpNames;
  ClosureEnv_anon_11(this.classTpNames);
  @override
  bool call(TypeParameter tp) => ClosureEnv_anon_11_call(this, tp);
}
bool ClosureEnv_anon_11_call(ClosureEnv_anon_11 env, TypeParameter tp) {
  return !(env.classTpNames.contains(tp.name));
}

class ClosureEnv_anon_12 extends TypeFunction1<bool, DartType> {
  DartRestorerValue this_;
  ClosureEnv_anon_12(this.this_);
  @override
  bool call(DartType ta) => ClosureEnv_anon_12_call(this, ta);
}
bool ClosureEnv_anon_12_call(ClosureEnv_anon_12 env, DartType ta) {
  return _DartRestorerBase__containsTypeParameter(env.this_, ta);
}

class ClosureEnv_anon_13 extends TypeFunction1<String, DartType> {
  DartRestorerValue this_;
  ClosureEnv_anon_13(this.this_);
  @override
  String call(DartType ta) => ClosureEnv_anon_13_call(this, ta);
}
String ClosureEnv_anon_13_call(ClosureEnv_anon_13 env, DartType ta) {
  return _DartRestorerBase__typeToSpecSuffix(env.this_, ta);
}

class ClosureEnv_anon_14 extends TypeFunction1<String, DartType> {
  DartRestorerValue this_;
  ClosureEnv_anon_14(this.this_);
  @override
  String call(DartType ta) => ClosureEnv_anon_14_call(this, ta);
}
String ClosureEnv_anon_14_call(ClosureEnv_anon_14 env, DartType ta) {
  return _DartRestorerBase__typeToSpecRestoreStr(env.this_, ta);
}

class ClosureEnv_anon_15 extends TypeFunction0<StaticMap<String, StaticSet<MethodSpecEntryValue>>> {
  ClosureEnv_anon_15();
  @override
  StaticMap<String, StaticSet<MethodSpecEntryValue>> call() => ClosureEnv_anon_15_call(this);
}
StaticMap<String, StaticSet<MethodSpecEntryValue>> ClosureEnv_anon_15_call(ClosureEnv_anon_15 env) {
  return StaticMap<String, StaticSet<MethodSpecEntryValue>>.of({});
}

class ClosureEnv_anon_16 extends TypeFunction0<StaticSet<MethodSpecEntryValue>> {
  ClosureEnv_anon_16();
  @override
  StaticSet<MethodSpecEntryValue> call() => ClosureEnv_anon_16_call(this);
}
StaticSet<MethodSpecEntryValue> ClosureEnv_anon_16_call(ClosureEnv_anon_16 env) {
  return StaticSet<MethodSpecEntryValue>.of([]);
}

class ClosureEnv_anon_17 extends TypeFunction1<bool, _VTableEntryValue> {
  _VTableEntryValue ifaceEntry;
  ClosureEnv_anon_17(this.ifaceEntry);
  @override
  bool call(_VTableEntryValue e) => ClosureEnv_anon_17_call(this, e);
}
bool ClosureEnv_anon_17_call(ClosureEnv_anon_17 env, _VTableEntryValue e) {
  return ((e.name == env.ifaceEntry.name) && (e.kind == env.ifaceEntry.kind));
}

class ClosureEnv_anon_18 extends TypeFunction1<bool, _VTableEntryValue> {
  StringBox methodName;
  _VTableEntryValue entry;
  ClosureEnv_anon_18(this.methodName, this.entry);
  @override
  bool call(_VTableEntryValue e) => ClosureEnv_anon_18_call(this, e);
}
bool ClosureEnv_anon_18_call(ClosureEnv_anon_18 env, _VTableEntryValue e) {
  return ((e.name == env.methodName.value) && (e.kind == env.entry.kind));
}

class ClosureEnv_anon_19 extends TypeFunction1<String, VariableDeclaration> {
  DartRestorerValue this_;
  ClosureEnv_anon_19(this.this_);
  @override
  String call(VariableDeclaration p) => ClosureEnv_anon_19_call(this, p);
}
String ClosureEnv_anon_19_call(ClosureEnv_anon_19 env, VariableDeclaration p) {
  return _DartRestorerBase__restoreTypeForSignature(env.this_, p.type);
}

class ClosureEnv_anon_20 extends TypeFunction1<String, DartType> {
  dynamic this_;
  ClosureEnv_anon_20(this.this_);
  @override
  String call(DartType t) => ClosureEnv_anon_20_call(this, t);
}
String ClosureEnv_anon_20_call(ClosureEnv_anon_20 env, DartType t) {
  return _TypeUtils__restoreType(this_, t);
}

class ClosureEnv_anon_21 extends TypeFunction1<String, DartType> {
  dynamic this_;
  ClosureEnv_anon_21(this.this_);
  @override
  String call(DartType t) => ClosureEnv_anon_21_call(this, t);
}
String ClosureEnv_anon_21_call(ClosureEnv_anon_21 env, DartType t) {
  return _TypeUtils__restoreType(this_, t);
}

class ClosureEnv_anon_22 extends TypeFunction1<String, Constant> {
  dynamic this_;
  ClosureEnv_anon_22(this.this_);
  @override
  String call(Constant e) => ClosureEnv_anon_22_call(this, e);
}
String ClosureEnv_anon_22_call(ClosureEnv_anon_22 env, Constant e) {
  return _ConstantRestorer__restoreConstant(this_, e);
}

class ClosureEnv_anon_23 extends TypeFunction1<String, Constant> {
  dynamic this_;
  ClosureEnv_anon_23(this.this_);
  @override
  String call(Constant e) => ClosureEnv_anon_23_call(this, e);
}
String ClosureEnv_anon_23_call(ClosureEnv_anon_23 env, Constant e) {
  return _ConstantRestorer__restoreConstant(this_, e);
}

class ClosureEnv_anon_24 extends TypeFunction1<String, ConstantMapEntry> {
  dynamic this_;
  ClosureEnv_anon_24(this.this_);
  @override
  String call(ConstantMapEntry e) => ClosureEnv_anon_24_call(this, e);
}
String ClosureEnv_anon_24_call(ClosureEnv_anon_24 env, ConstantMapEntry e) {
      return '${_ConstantRestorer__restoreConstant(this_, e.key)}: ${_ConstantRestorer__restoreConstant(this_, e.value)}';
    }

class ClosureEnv_anon_25 extends TypeFunction1<String, MapEntry<Reference, Constant>> {
  dynamic this_;
  ClosureEnv_anon_25(this.this_);
  @override
  String call(MapEntry<Reference, Constant> e) => ClosureEnv_anon_25_call(this, e);
}
String ClosureEnv_anon_25_call(ClosureEnv_anon_25 env, MapEntry<Reference, Constant> e) {
    return '${e.key.asField.name.text}: ${_ConstantRestorer__restoreConstant(this_, e.value)}';
  }

class ClosureEnv_anon_26 extends TypeFunction1<String, MapEntry<Reference, Constant>> {
  dynamic this_;
  ClosureEnv_anon_26(this.this_);
  @override
  String call(MapEntry<Reference, Constant> e) => ClosureEnv_anon_26_call(this, e);
}
String ClosureEnv_anon_26_call(ClosureEnv_anon_26 env, MapEntry<Reference, Constant> e) {
    return '${e.key.asField.name.text}: ${_ConstantRestorer__restoreConstant(this_, e.value)}';
  }

class ClosureEnv_anon_27 extends TypeFunction1<bool, DartType> {
  ClosureEnv_anon_27();
  @override
  bool call(DartType t) => ClosureEnv_anon_27_call(this, t);
}
bool ClosureEnv_anon_27_call(ClosureEnv_anon_27 env, DartType t) {
  return !((t is DynamicType));
}

class ClosureEnv_anon_28 extends TypeFunction1<String, DartType> {
  dynamic this_;
  ClosureEnv_anon_28(this.this_);
  @override
  String call(DartType t) => ClosureEnv_anon_28_call(this, t);
}
String ClosureEnv_anon_28_call(ClosureEnv_anon_28 env, DartType t) {
  return _TypeUtils__restoreType(this_, t);
}

class ClosureEnv_anon_29 extends TypeFunction1<String, DartType> {
  dynamic this_;
  ClosureEnv_anon_29(this.this_);
  @override
  String call(DartType t) => ClosureEnv_anon_29_call(this, t);
}
String ClosureEnv_anon_29_call(ClosureEnv_anon_29 env, DartType t) {
  return _TypeUtils__restoreType(this_, t);
}

class ClosureEnv_anon_30 extends TypeFunction1<String, TypeParameter> {
  ClosureEnv_anon_30();
  @override
  String call(TypeParameter tp) => ClosureEnv_anon_30_call(this, tp);
}
String ClosureEnv_anon_30_call(ClosureEnv_anon_30 env, TypeParameter tp) {
  return (tp.name ?? 'T');
}

class ClosureEnv_anon_31 extends TypeFunction1<bool, _VTableEntryValue> {
  String fieldName;
  ClosureEnv_anon_31(this.fieldName);
  @override
  bool call(_VTableEntryValue e) => ClosureEnv_anon_31_call(this, e);
}
bool ClosureEnv_anon_31_call(ClosureEnv_anon_31 env, _VTableEntryValue e) {
  return ((e.name == env.fieldName) && (e.kind == 'getter'));
}

class ClosureEnv_anon_32 extends TypeFunction1<String?, TypeParameter> {
  ClosureEnv_anon_32();
  @override
  String? call(TypeParameter tp) => ClosureEnv_anon_32_call(this, tp);
}
String? ClosureEnv_anon_32_call(ClosureEnv_anon_32 env, TypeParameter tp) {
  return tp.name;
}

class ClosureEnv_anon_33 extends TypeFunction1<bool, TypeParameter> {
  StaticSet<String?> classTpNames;
  ClosureEnv_anon_33(this.classTpNames);
  @override
  bool call(TypeParameter tp) => ClosureEnv_anon_33_call(this, tp);
}
bool ClosureEnv_anon_33_call(ClosureEnv_anon_33 env, TypeParameter tp) {
  return !(env.classTpNames.contains(tp.name));
}

class ClosureEnv_anon_34 extends TypeFunction1<bool, DartType> {
  dynamic this_;
  ClosureEnv_anon_34(this.this_);
  @override
  bool call(DartType ta) => ClosureEnv_anon_34_call(this, ta);
}
bool ClosureEnv_anon_34_call(ClosureEnv_anon_34 env, DartType ta) {
  return _DartRestorerBase__containsTypeParameter(this_, ta);
}

class ClosureEnv_anon_35 extends TypeFunction1<String, DartType> {
  dynamic this_;
  ClosureEnv_anon_35(this.this_);
  @override
  String call(DartType ta) => ClosureEnv_anon_35_call(this, ta);
}
String ClosureEnv_anon_35_call(ClosureEnv_anon_35 env, DartType ta) {
  return _DartRestorerBase__typeToSpecSuffix(this_, ta);
}

class ClosureEnv_anon_36 extends TypeFunction1<String, DartType> {
  dynamic this_;
  ClosureEnv_anon_36(this.this_);
  @override
  String call(DartType ta) => ClosureEnv_anon_36_call(this, ta);
}
String ClosureEnv_anon_36_call(ClosureEnv_anon_36 env, DartType ta) {
  return _TypeUtils__restoreType(this_, ta);
}

class ClosureEnv_anon_37 extends TypeFunction1<String, DartType> {
  dynamic this_;
  ClosureEnv_anon_37(this.this_);
  @override
  String call(DartType ta) => ClosureEnv_anon_37_call(this, ta);
}
String ClosureEnv_anon_37_call(ClosureEnv_anon_37 env, DartType ta) {
  return _TypeUtils__restoreType(this_, ta);
}

class ClosureEnv_anon_38 extends TypeFunction1<String, DartType> {
  dynamic this_;
  ClosureEnv_anon_38(this.this_);
  @override
  String call(DartType ta) => ClosureEnv_anon_38_call(this, ta);
}
String ClosureEnv_anon_38_call(ClosureEnv_anon_38 env, DartType ta) {
  return _TypeUtils__restoreType(this_, ta);
}

class ClosureEnv_anon_39 extends TypeFunction1<String, DartType> {
  dynamic this_;
  ClosureEnv_anon_39(this.this_);
  @override
  String call(DartType ta) => ClosureEnv_anon_39_call(this, ta);
}
String ClosureEnv_anon_39_call(ClosureEnv_anon_39 env, DartType ta) {
  return _TypeUtils__restoreType(this_, ta);
}

class ClosureEnv_anon_40 extends TypeFunction1<String, DartType> {
  dynamic this_;
  ClosureEnv_anon_40(this.this_);
  @override
  String call(DartType ta) => ClosureEnv_anon_40_call(this, ta);
}
String ClosureEnv_anon_40_call(ClosureEnv_anon_40 env, DartType ta) {
  return _TypeUtils__restoreType(this_, ta);
}

class ClosureEnv_anon_41 extends TypeFunction1<String, TypeParameter> {
  ClosureEnv_anon_41();
  @override
  String call(TypeParameter tp) => ClosureEnv_anon_41_call(this, tp);
}
String ClosureEnv_anon_41_call(ClosureEnv_anon_41 env, TypeParameter tp) {
  return (tp.name ?? 'dynamic');
}

class ClosureEnv_anon_42 extends TypeFunction1<String, DartType> {
  dynamic this_;
  ClosureEnv_anon_42(this.this_);
  @override
  String call(DartType t) => ClosureEnv_anon_42_call(this, t);
}
String ClosureEnv_anon_42_call(ClosureEnv_anon_42 env, DartType t) {
  return _TypeUtils__restoreType(this_, t);
}

class ClosureEnv_anon_43 extends TypeFunction1<String, Expression> {
  dynamic this_;
  ClosureEnv_anon_43(this.this_);
  @override
  String call(Expression e) => ClosureEnv_anon_43_call(this, e);
}
String ClosureEnv_anon_43_call(ClosureEnv_anon_43 env, Expression e) {
  return _ExpressionRestorer__restoreExpr(this_, e);
}

class ClosureEnv_anon_44 extends TypeFunction1<String, DartType> {
  dynamic this_;
  ClosureEnv_anon_44(this.this_);
  @override
  String call(DartType t) => ClosureEnv_anon_44_call(this, t);
}
String ClosureEnv_anon_44_call(ClosureEnv_anon_44 env, DartType t) {
  return _TypeUtils__restoreType(this_, t);
}

class ClosureEnv_anon_45 extends TypeFunction1<String, DartType> {
  dynamic this_;
  ClosureEnv_anon_45(this.this_);
  @override
  String call(DartType t) => ClosureEnv_anon_45_call(this, t);
}
String ClosureEnv_anon_45_call(ClosureEnv_anon_45 env, DartType t) {
  return _TypeUtils__restoreType(this_, t);
}

class ClosureEnv_anon_46 extends TypeFunction1<String, DartType> {
  dynamic this_;
  ClosureEnv_anon_46(this.this_);
  @override
  String call(DartType t) => ClosureEnv_anon_46_call(this, t);
}
String ClosureEnv_anon_46_call(ClosureEnv_anon_46 env, DartType t) {
  return _TypeUtils__restoreType(this_, t);
}

class ClosureEnv_anon_47 extends TypeFunction1<String, DartType> {
  dynamic this_;
  ClosureEnv_anon_47(this.this_);
  @override
  String call(DartType t) => ClosureEnv_anon_47_call(this, t);
}
String ClosureEnv_anon_47_call(ClosureEnv_anon_47 env, DartType t) {
  return _TypeUtils__restoreType(this_, t);
}

class ClosureEnv_anon_48 extends TypeFunction1<String, DartType> {
  dynamic this_;
  ClosureEnv_anon_48(this.this_);
  @override
  String call(DartType t) => ClosureEnv_anon_48_call(this, t);
}
String ClosureEnv_anon_48_call(ClosureEnv_anon_48 env, DartType t) {
  return _TypeUtils__restoreType(this_, t);
}

class ClosureEnv_anon_49 extends TypeFunction1<String, DartType> {
  dynamic this_;
  ClosureEnv_anon_49(this.this_);
  @override
  String call(DartType t) => ClosureEnv_anon_49_call(this, t);
}
String ClosureEnv_anon_49_call(ClosureEnv_anon_49 env, DartType t) {
  return _TypeUtils__restoreType(this_, t);
}

class ClosureEnv_anon_50 extends TypeFunction1<String, DartType> {
  dynamic this_;
  ClosureEnv_anon_50(this.this_);
  @override
  String call(DartType t) => ClosureEnv_anon_50_call(this, t);
}
String ClosureEnv_anon_50_call(ClosureEnv_anon_50 env, DartType t) {
  return _TypeUtils__restoreType(this_, t);
}

class ClosureEnv_anon_51 extends TypeFunction1<String, DartType> {
  dynamic this_;
  ClosureEnv_anon_51(this.this_);
  @override
  String call(DartType t) => ClosureEnv_anon_51_call(this, t);
}
String ClosureEnv_anon_51_call(ClosureEnv_anon_51 env, DartType t) {
  return _TypeUtils__restoreType(this_, t);
}

class ClosureEnv_anon_52 extends TypeFunction1<String, DartType> {
  dynamic this_;
  ClosureEnv_anon_52(this.this_);
  @override
  String call(DartType t) => ClosureEnv_anon_52_call(this, t);
}
String ClosureEnv_anon_52_call(ClosureEnv_anon_52 env, DartType t) {
  return _TypeUtils__restoreType(this_, t);
}

class ClosureEnv_anon_53 extends TypeFunction1<String, DartType> {
  dynamic this_;
  ClosureEnv_anon_53(this.this_);
  @override
  String call(DartType t) => ClosureEnv_anon_53_call(this, t);
}
String ClosureEnv_anon_53_call(ClosureEnv_anon_53 env, DartType t) {
  return _TypeUtils__restoreType(this_, t);
}

class ClosureEnv_anon_54 extends TypeFunction1<String, Expression> {
  dynamic this_;
  ClosureEnv_anon_54(this.this_);
  @override
  String call(Expression e) => ClosureEnv_anon_54_call(this, e);
}
String ClosureEnv_anon_54_call(ClosureEnv_anon_54 env, Expression e) {
  return _ExpressionRestorer__restoreExpr(this_, e);
}

class ClosureEnv_anon_55 extends TypeFunction1<String, DartType> {
  dynamic this_;
  ClosureEnv_anon_55(this.this_);
  @override
  String call(DartType t) => ClosureEnv_anon_55_call(this, t);
}
String ClosureEnv_anon_55_call(ClosureEnv_anon_55 env, DartType t) {
  return _TypeUtils__restoreType(this_, t);
}

class ClosureEnv_anon_56 extends TypeFunction1<String, Expression> {
  dynamic this_;
  ClosureEnv_anon_56(this.this_);
  @override
  String call(Expression e) => ClosureEnv_anon_56_call(this, e);
}
String ClosureEnv_anon_56_call(ClosureEnv_anon_56 env, Expression e) {
    if ((e is StringLiteral)) {
      final String escaped = e.value.replaceAll('\\\\', '\\\\\\\\').replaceAll('\'', '\\\'').replaceAll('$', '\\$').replaceAll('\n', '\\n').replaceAll('\r', '\\r').replaceAll('\t', '\\t');
      return escaped;
    }
    final String? enumToStringCall = _ExpressionRestorer__tryEnumToStringInInterpolation(this_, e);
    if (!((enumToStringCall == null)))     return '\${${enumToStringCall}}';
    return '\${${_ExpressionRestorer__restoreExpr(this_, e)}}';
  }

class ClosureEnv_anon_57 extends TypeFunction1<String, Expression> {
  dynamic this_;
  ClosureEnv_anon_57(this.this_);
  @override
  String call(Expression e) => ClosureEnv_anon_57_call(this, e);
}
String ClosureEnv_anon_57_call(ClosureEnv_anon_57 env, Expression e) {
  return _ExpressionRestorer__restoreExpr(this_, e);
}

class ClosureEnv_anon_58 extends TypeFunction1<String, MapLiteralEntry> {
  dynamic this_;
  ClosureEnv_anon_58(this.this_);
  @override
  String call(MapLiteralEntry e) => ClosureEnv_anon_58_call(this, e);
}
String ClosureEnv_anon_58_call(ClosureEnv_anon_58 env, MapLiteralEntry e) {
    return '${_ExpressionRestorer__restoreExpr(this_, e.key)}: ${_ExpressionRestorer__restoreExpr(this_, e.value)}';
  }

class ClosureEnv_anon_59 extends TypeFunction1<String, Expression> {
  dynamic this_;
  ClosureEnv_anon_59(this.this_);
  @override
  String call(Expression e) => ClosureEnv_anon_59_call(this, e);
}
String ClosureEnv_anon_59_call(ClosureEnv_anon_59 env, Expression e) {
  return _ExpressionRestorer__restoreExpr(this_, e);
}

class ClosureEnv_anon_60 extends TypeFunction1<String, TypeParameter> {
  ClosureEnv_anon_60();
  @override
  String call(TypeParameter tp) => ClosureEnv_anon_60_call(this, tp);
}
String ClosureEnv_anon_60_call(ClosureEnv_anon_60 env, TypeParameter tp) {
  return (tp.name ?? 'T');
}

class ClosureEnv_anon_61 extends TypeFunction1<String, TypeParameter> {
  ClosureEnv_anon_61();
  @override
  String call(TypeParameter tp) => ClosureEnv_anon_61_call(this, tp);
}
String ClosureEnv_anon_61_call(ClosureEnv_anon_61 env, TypeParameter tp) {
  return (tp.name ?? 'T');
}

class ClosureEnv_anon_62 extends TypeFunction1<String, _CapturedVarValue> {
  ClosureEnv_anon_62();
  @override
  String call(_CapturedVarValue f) => ClosureEnv_anon_62_call(this, f);
}
String ClosureEnv_anon_62_call(ClosureEnv_anon_62 env, _CapturedVarValue f) {
  return 'this.${f.name}';
}

class ClosureEnv_anon_63 extends TypeFunction1<bool, _CapturedVarValue> {
  ClosureEnv_anon_63();
  @override
  bool call(_CapturedVarValue f) => ClosureEnv_anon_63_call(this, f);
}
bool ClosureEnv_anon_63_call(ClosureEnv_anon_63 env, _CapturedVarValue f) {
  return f.isThis;
}

class ClosureEnv_anon_64 extends TypeFunction1<String, Expression> {
  dynamic this_;
  ClosureEnv_anon_64(this.this_);
  @override
  String call(Expression e) => ClosureEnv_anon_64_call(this, e);
}
String ClosureEnv_anon_64_call(ClosureEnv_anon_64 env, Expression e) {
  return _DartRestorerBase__restoreExpr(this_, e);
}

class ClosureEnv_anon_65 extends TypeFunction1<String?, TypeParameter> {
  ClosureEnv_anon_65();
  @override
  String? call(TypeParameter tp) => ClosureEnv_anon_65_call(this, tp);
}
String? ClosureEnv_anon_65_call(ClosureEnv_anon_65 env, TypeParameter tp) {
  return tp.name;
}

class ClosureEnv_anon_66 extends TypeFunction1<bool, _VTableEntryValue> {
  String methodName;
  _VTableEntryValue entry;
  ClosureEnv_anon_66(this.methodName, this.entry);
  @override
  bool call(_VTableEntryValue e) => ClosureEnv_anon_66_call(this, e);
}
bool ClosureEnv_anon_66_call(ClosureEnv_anon_66 env, _VTableEntryValue e) {
  return ((e.name == env.methodName) && (e.kind == env.entry.kind));
}

class ClosureEnv_anon_67 extends TypeFunction1<String, TypeParameter> {
  ClosureEnv_anon_67();
  @override
  String call(TypeParameter tp) => ClosureEnv_anon_67_call(this, tp);
}
String ClosureEnv_anon_67_call(ClosureEnv_anon_67 env, TypeParameter tp) {
  return (tp.name ?? 'T');
}

class ClosureEnv_anon_68 extends TypeFunction1<String?, TypeParameter> {
  ClosureEnv_anon_68();
  @override
  String? call(TypeParameter tp) => ClosureEnv_anon_68_call(this, tp);
}
String? ClosureEnv_anon_68_call(ClosureEnv_anon_68 env, TypeParameter tp) {
  return tp.name;
}

class ClosureEnv_anon_69 extends TypeFunction1<String, DartType> {
  dynamic this_;
  StaticMap<String, String> typeParamMap;
  ClosureEnv_anon_69(this.this_, this.typeParamMap);
  @override
  String call(DartType ta) => ClosureEnv_anon_69_call(this, ta);
}
String ClosureEnv_anon_69_call(ClosureEnv_anon_69 env, DartType ta) {
  return _DeclarationRestorer__substituteTypeStr(this_, _TypeUtils__restoreType(this_, ta), env.typeParamMap);
}

class ClosureEnv_anon_70 extends TypeFunction1<String, DartType> {
  dynamic this_;
  StaticMap<String, String> typeParamMap;
  ClosureEnv_anon_70(this.this_, this.typeParamMap);
  @override
  String call(DartType ta) => ClosureEnv_anon_70_call(this, ta);
}
String ClosureEnv_anon_70_call(ClosureEnv_anon_70 env, DartType ta) {
  return _DeclarationRestorer__substituteTypeStr(this_, _TypeUtils__restoreType(this_, ta), env.typeParamMap);
}

class ClosureEnv_ClosureEnv_anon_71_72 extends TypeFunction1<String, Match> {
  StringBox to;
  ClosureEnv_ClosureEnv_anon_71_72(this.to);
  @override
  String call(Match m) => ClosureEnv_ClosureEnv_anon_71_72_call(this, m);
}
String ClosureEnv_ClosureEnv_anon_71_72_call(ClosureEnv_ClosureEnv_anon_71_72 env, Match m) {
  return env.to.value;
}

class ClosureEnv_anon_71 extends TypeFunction2<void, String, String> {
  String result;
  ClosureEnv_anon_71(this.result);
  @override
  void call(String from, String to_raw) => ClosureEnv_anon_71_call(this, from, to_raw);
}
void ClosureEnv_anon_71_call(ClosureEnv_anon_71 env, String from, String to_raw) {
  StringBox to = StringBox(to_raw);
  if ((from == to.value))   return;
  env.result = env.result.replaceAllMapped(RegExp((('\\b' + RegExp.escape(from)) + '\\b')), ClosureEnv_ClosureEnv_anon_71_72(to));
}

class ClosureEnv_anon_73 extends TypeFunction1<String?, TypeParameter> {
  ClosureEnv_anon_73();
  @override
  String? call(TypeParameter tp) => ClosureEnv_anon_73_call(this, tp);
}
String? ClosureEnv_anon_73_call(ClosureEnv_anon_73 env, TypeParameter tp) {
  return tp.name;
}

class ClosureEnv_anon_74 extends TypeFunction1<String?, TypeParameter> {
  ClosureEnv_anon_74();
  @override
  String? call(TypeParameter tp) => ClosureEnv_anon_74_call(this, tp);
}
String? ClosureEnv_anon_74_call(ClosureEnv_anon_74 env, TypeParameter tp) {
  return tp.name;
}

class ClosureEnv_anon_75 extends TypeFunction1<bool, String?> {
  StaticSet<String?> currentTypeParamNames;
  ClosureEnv_anon_75(this.currentTypeParamNames);
  @override
  bool call(String? n) => ClosureEnv_anon_75_call(this, n);
}
bool ClosureEnv_anon_75_call(ClosureEnv_anon_75 env, String? n) {
  return env.currentTypeParamNames.contains(n);
}

class ClosureEnv_anon_76 extends TypeFunction1<String, DartType> {
  dynamic this_;
  ClosureEnv_anon_76(this.this_);
  @override
  String call(DartType ta) => ClosureEnv_anon_76_call(this, ta);
}
String ClosureEnv_anon_76_call(ClosureEnv_anon_76 env, DartType ta) {
  return _TypeUtils__restoreType(this_, ta);
}

class ClosureEnv_anon_77 extends TypeFunction1<String, DartType> {
  dynamic this_;
  ClosureEnv_anon_77(this.this_);
  @override
  String call(DartType ta) => ClosureEnv_anon_77_call(this, ta);
}
String ClosureEnv_anon_77_call(ClosureEnv_anon_77 env, DartType ta) {
  return _TypeUtils__restoreType(this_, ta);
}

class ClosureEnv_anon_78 extends TypeFunction1<String, TypeParameter> {
  ClosureEnv_anon_78();
  @override
  String call(TypeParameter tp) => ClosureEnv_anon_78_call(this, tp);
}
String ClosureEnv_anon_78_call(ClosureEnv_anon_78 env, TypeParameter tp) {
  return (tp.name ?? 'T');
}

class ClosureEnv_anon_79 extends TypeFunction1<String?, TypeParameter> {
  ClosureEnv_anon_79();
  @override
  String? call(TypeParameter tp) => ClosureEnv_anon_79_call(this, tp);
}
String? ClosureEnv_anon_79_call(ClosureEnv_anon_79 env, TypeParameter tp) {
  return tp.name;
}

class ClosureEnv_anon_80 extends TypeFunction1<bool, TypeParameter> {
  StaticSet<String?> classTpNames;
  ClosureEnv_anon_80(this.classTpNames);
  @override
  bool call(TypeParameter tp) => ClosureEnv_anon_80_call(this, tp);
}
bool ClosureEnv_anon_80_call(ClosureEnv_anon_80 env, TypeParameter tp) {
  return !(env.classTpNames.contains(tp.name));
}

class ClosureEnv_anon_81 extends TypeFunction1<bool, _VTableEntryValue> {
  StaticSet<String> mixinMethodNames;
  ClosureEnv_anon_81(this.mixinMethodNames);
  @override
  bool call(_VTableEntryValue entry) => ClosureEnv_anon_81_call(this, entry);
}
bool ClosureEnv_anon_81_call(ClosureEnv_anon_81 env, _VTableEntryValue entry) {
    return env.mixinMethodNames.contains(entry.name);
  }

class ClosureEnv_anon_82 extends TypeFunction1<String?, TypeParameter> {
  ClosureEnv_anon_82();
  @override
  String? call(TypeParameter tp) => ClosureEnv_anon_82_call(this, tp);
}
String? ClosureEnv_anon_82_call(ClosureEnv_anon_82 env, TypeParameter tp) {
  return tp.name;
}

class ClosureEnv_anon_83 extends TypeFunction1<bool, TypeParameter> {
  StaticSet<String?> mixinClassTpNames;
  ClosureEnv_anon_83(this.mixinClassTpNames);
  @override
  bool call(TypeParameter tp) => ClosureEnv_anon_83_call(this, tp);
}
bool ClosureEnv_anon_83_call(ClosureEnv_anon_83 env, TypeParameter tp) {
  return !(env.mixinClassTpNames.contains(tp.name));
}

class ClosureEnv_anon_84 extends TypeFunction1<String, TypeParameter> {
  ClosureEnv_anon_84();
  @override
  String call(TypeParameter tp) => ClosureEnv_anon_84_call(this, tp);
}
String ClosureEnv_anon_84_call(ClosureEnv_anon_84 env, TypeParameter tp) {
  return (tp.name ?? 'T');
}

class ClosureEnv_anon_85 extends TypeFunction1<String, TypeParameter> {
  ClosureEnv_anon_85();
  @override
  String call(TypeParameter _) => ClosureEnv_anon_85_call(this, _);
}
String ClosureEnv_anon_85_call(ClosureEnv_anon_85 env, TypeParameter _) {
  return 'dynamic';
}

class ClosureEnv_anon_86 extends TypeFunction1<String, VariableDeclaration> {
  dynamic this_;
  ClosureEnv_anon_86(this.this_);
  @override
  String call(VariableDeclaration p) => ClosureEnv_anon_86_call(this, p);
}
String ClosureEnv_anon_86_call(ClosureEnv_anon_86 env, VariableDeclaration p) {
  return '${_TypeUtils__restoreType(this_, p.type)} ${(p.name ?? '_')}';
}

class ClosureEnv_anon_87 extends TypeFunction1<String, DartType> {
  dynamic this_;
  ClosureEnv_anon_87(this.this_);
  @override
  String call(DartType ta) => ClosureEnv_anon_87_call(this, ta);
}
String ClosureEnv_anon_87_call(ClosureEnv_anon_87 env, DartType ta) {
  return _TypeUtils__restoreType(this_, ta);
}

class ClosureEnv_anon_88 extends TypeFunction1<String, DartType> {
  dynamic this_;
  ClosureEnv_anon_88(this.this_);
  @override
  String call(DartType ta) => ClosureEnv_anon_88_call(this, ta);
}
String ClosureEnv_anon_88_call(ClosureEnv_anon_88 env, DartType ta) {
  return _TypeUtils__restoreType(this_, ta);
}

class ClosureEnv_anon_89 extends TypeFunction1<String, String> {
  StaticMap<String, String> typeParamMap;
  ClosureEnv_anon_89(this.typeParamMap);
  @override
  String call(String typeStr) => ClosureEnv_anon_89_call(this, typeStr);
}
String ClosureEnv_anon_89_call(ClosureEnv_anon_89 env, String typeStr) {
          return (env.typeParamMap[typeStr] ?? typeStr);
        }

class ClosureEnv_anon_90 extends TypeFunction1<String, TypeParameter> {
  ClosureEnv_anon_90();
  @override
  String call(TypeParameter tp) => ClosureEnv_anon_90_call(this, tp);
}
String ClosureEnv_anon_90_call(ClosureEnv_anon_90 env, TypeParameter tp) {
  return (tp.name ?? 'T');
}

class ClosureEnv_anon_91 extends TypeFunction1<bool, Initializer> {
  ClosureEnv_anon_91();
  @override
  bool call(Initializer init) => ClosureEnv_anon_91_call(this, init);
}
bool ClosureEnv_anon_91_call(ClosureEnv_anon_91 env, Initializer init) {
  return (init is RedirectingInitializer);
}

class ClosureEnv_anon_92 extends TypeFunction1<String, TypeParameter> {
  ClosureEnv_anon_92();
  @override
  String call(TypeParameter tp) => ClosureEnv_anon_92_call(this, tp);
}
String ClosureEnv_anon_92_call(ClosureEnv_anon_92 env, TypeParameter tp) {
  return (tp.name ?? 'T');
}

class ClosureEnv_anon_93 extends TypeFunction1<String?, TypeParameter> {
  ClosureEnv_anon_93();
  @override
  String? call(TypeParameter tp) => ClosureEnv_anon_93_call(this, tp);
}
String? ClosureEnv_anon_93_call(ClosureEnv_anon_93 env, TypeParameter tp) {
  return tp.name;
}

class ClosureEnv_anon_94 extends TypeFunction1<bool, TypeParameter> {
  StaticSet<String?> classTpNames;
  ClosureEnv_anon_94(this.classTpNames);
  @override
  bool call(TypeParameter tp) => ClosureEnv_anon_94_call(this, tp);
}
bool ClosureEnv_anon_94_call(ClosureEnv_anon_94 env, TypeParameter tp) {
  return !(env.classTpNames.contains(tp.name));
}

class ClosureEnv_anon_95 extends TypeFunction1<String, DartType> {
  dynamic this_;
  ClosureEnv_anon_95(this.this_);
  @override
  String call(DartType ta) => ClosureEnv_anon_95_call(this, ta);
}
String ClosureEnv_anon_95_call(ClosureEnv_anon_95 env, DartType ta) {
  return _TypeUtils__restoreType(this_, ta);
}

class ClosureEnv_anon_96 extends TypeFunction1<bool, Field> {
  ClosureEnv_anon_96();
  @override
  bool call(Field f) => ClosureEnv_anon_96_call(this, f);
}
bool ClosureEnv_anon_96_call(ClosureEnv_anon_96 env, Field f) {
  return !(f.isStatic);
}

class ClosureEnv_anon_97 extends TypeFunction1<String, Field> {
  ClosureEnv_anon_97();
  @override
  String call(Field f) => ClosureEnv_anon_97_call(this, f);
}
String ClosureEnv_anon_97_call(ClosureEnv_anon_97 env, Field f) {
  return f.name.text;
}

class ClosureEnv_anon_98 extends TypeFunction1<bool, Initializer> {
  String paramName;
  ClosureEnv_anon_98(this.paramName);
  @override
  bool call(Initializer init) => ClosureEnv_anon_98_call(this, init);
}
bool ClosureEnv_anon_98_call(ClosureEnv_anon_98 env, Initializer init) {
  return ((init is FieldInitializer) && (init.field.name.text == env.paramName));
}

class ClosureEnv_anon_99 extends TypeFunction1<bool, Initializer> {
  String paramName;
  ClosureEnv_anon_99(this.paramName);
  @override
  bool call(Initializer init) => ClosureEnv_anon_99_call(this, init);
}
bool ClosureEnv_anon_99_call(ClosureEnv_anon_99 env, Initializer init) {
  return ((init is FieldInitializer) && (init.field.name.text == env.paramName));
}

class ClosureEnv_anon_100 extends TypeFunction1<bool, Field> {
  ClosureEnv_anon_100();
  @override
  bool call(Field f) => ClosureEnv_anon_100_call(this, f);
}
bool ClosureEnv_anon_100_call(ClosureEnv_anon_100 env, Field f) {
  return !(f.isStatic);
}

class ClosureEnv_anon_101 extends TypeFunction1<String, Field> {
  ClosureEnv_anon_101();
  @override
  String call(Field f) => ClosureEnv_anon_101_call(this, f);
}
String ClosureEnv_anon_101_call(ClosureEnv_anon_101 env, Field f) {
  return f.name.text;
}

class ClosureEnv_anon_102 extends TypeFunction1<String?, TypeParameter> {
  ClosureEnv_anon_102();
  @override
  String? call(TypeParameter tp) => ClosureEnv_anon_102_call(this, tp);
}
String? ClosureEnv_anon_102_call(ClosureEnv_anon_102 env, TypeParameter tp) {
  return tp.name;
}

class ClosureEnv_anon_103 extends TypeFunction1<bool, TypeParameter> {
  StaticSet<String?> classTpNames;
  ClosureEnv_anon_103(this.classTpNames);
  @override
  bool call(TypeParameter tp) => ClosureEnv_anon_103_call(this, tp);
}
bool ClosureEnv_anon_103_call(ClosureEnv_anon_103 env, TypeParameter tp) {
  return !(env.classTpNames.contains(tp.name));
}

class ClosureEnv_anon_104 extends TypeFunction1<String, TypeParameter> {
  ClosureEnv_anon_104();
  @override
  String call(TypeParameter tp) => ClosureEnv_anon_104_call(this, tp);
}
String ClosureEnv_anon_104_call(ClosureEnv_anon_104 env, TypeParameter tp) {
  return (tp.name ?? 'T');
}

class ClosureEnv_anon_105 extends TypeFunction1<String?, TypeParameter> {
  ClosureEnv_anon_105();
  @override
  String? call(TypeParameter tp) => ClosureEnv_anon_105_call(this, tp);
}
String? ClosureEnv_anon_105_call(ClosureEnv_anon_105 env, TypeParameter tp) {
  return tp.name;
}

class ClosureEnv_anon_106 extends TypeFunction1<bool, TypeParameter> {
  StaticSet<String?> classTpNames;
  ClosureEnv_anon_106(this.classTpNames);
  @override
  bool call(TypeParameter tp) => ClosureEnv_anon_106_call(this, tp);
}
bool ClosureEnv_anon_106_call(ClosureEnv_anon_106 env, TypeParameter tp) {
  return !(env.classTpNames.contains(tp.name));
}

class ClosureEnv_anon_107 extends TypeFunction1<String, TypeParameter> {
  ClosureEnv_anon_107();
  @override
  String call(TypeParameter tp) => ClosureEnv_anon_107_call(this, tp);
}
String ClosureEnv_anon_107_call(ClosureEnv_anon_107 env, TypeParameter tp) {
  return (tp.name ?? 'T');
}

class ClosureEnv_anon_108 extends TypeFunction1<String, TypeParameter> {
  ClosureEnv_anon_108();
  @override
  String call(TypeParameter tp) => ClosureEnv_anon_108_call(this, tp);
}
String ClosureEnv_anon_108_call(ClosureEnv_anon_108 env, TypeParameter tp) {
  return (tp.name ?? 'T');
}

class ClosureEnv_anon_109 extends TypeFunction1<String, Match> {
  String replacement;
  ClosureEnv_anon_109(this.replacement);
  @override
  String call(Match m) => ClosureEnv_anon_109_call(this, m);
}
String ClosureEnv_anon_109_call(ClosureEnv_anon_109 env, Match m) {
  return env.replacement;
}

class ClosureEnv_anon_110 extends TypeFunction1<String, TypeParameter> {
  ClosureEnv_anon_110();
  @override
  String call(TypeParameter tp) => ClosureEnv_anon_110_call(this, tp);
}
String ClosureEnv_anon_110_call(ClosureEnv_anon_110 env, TypeParameter tp) {
  return (tp.name ?? 'T');
}

class ClosureEnv_anon_111 extends TypeFunction1<String, TypeParameter> {
  ClosureEnv_anon_111();
  @override
  String call(TypeParameter tp) => ClosureEnv_anon_111_call(this, tp);
}
String ClosureEnv_anon_111_call(ClosureEnv_anon_111 env, TypeParameter tp) {
  return (tp.name ?? 'T');
}

class ClosureEnv_anon_112 extends TypeFunction1<String, Supertype> {
  dynamic this_;
  ClosureEnv_anon_112(this.this_);
  @override
  String call(Supertype s) => ClosureEnv_anon_112_call(this, s);
}
String ClosureEnv_anon_112_call(ClosureEnv_anon_112 env, Supertype s) {
  return _TypeUtils__restoreSupertype(this_, s);
}

class ClosureEnv_anon_113 extends TypeFunction1<bool, Field> {
  Class cls;
  ClosureEnv_anon_113(this.cls);
  @override
  bool call(Field f) => ClosureEnv_anon_113_call(this, f);
}
bool ClosureEnv_anon_113_call(ClosureEnv_anon_113 env, Field f) {
  return ((((f.isStatic && f.isConst) && (f.type is InterfaceType)) && ((f.type as InterfaceType).classNode == env.cls)) && !((f.name.text == 'values')));
}

class ClosureEnv_anon_114 extends TypeFunction1<bool, Field> {
  StaticSet<String> enumInternalFields;
  ClosureEnv_anon_114(this.enumInternalFields);
  @override
  bool call(Field f) => ClosureEnv_anon_114_call(this, f);
}
bool ClosureEnv_anon_114_call(ClosureEnv_anon_114 env, Field f) {
  return (!(f.isStatic) && !(env.enumInternalFields.contains(f.name.text)));
}

class ClosureEnv_anon_115 extends TypeFunction1<String, String> {
  ClosureEnv_anon_115();
  @override
  String call(String name) => ClosureEnv_anon_115_call(this, name);
}
String ClosureEnv_anon_115_call(ClosureEnv_anon_115 env, String name) {
  return 'this.${name}';
}

class ClosureEnv_anon_116 extends TypeFunction1<bool, Procedure> {
  StaticSet<String> syntheticMethods;
  ClosureEnv_anon_116(this.syntheticMethods);
  @override
  bool call(Procedure p) => ClosureEnv_anon_116_call(this, p);
}
bool ClosureEnv_anon_116_call(ClosureEnv_anon_116 env, Procedure p) {
  return ((!(env.syntheticMethods.contains(p.name.text)) && !(p.isAbstract)) && !((p.function.body == null)));
}

class ClosureEnv_anon_117 extends TypeFunction1<String, TypeParameter> {
  ClosureEnv_anon_117();
  @override
  String call(TypeParameter tp) => ClosureEnv_anon_117_call(this, tp);
}
String ClosureEnv_anon_117_call(ClosureEnv_anon_117 env, TypeParameter tp) {
  return (tp.name ?? 'T');
}

class ClosureEnv_anon_118 extends TypeFunction1<String?, TypeParameter> {
  ClosureEnv_anon_118();
  @override
  String? call(TypeParameter tp) => ClosureEnv_anon_118_call(this, tp);
}
String? ClosureEnv_anon_118_call(ClosureEnv_anon_118 env, TypeParameter tp) {
  return tp.name;
}

class ClosureEnv_anon_119 extends TypeFunction1<bool, TypeParameter> {
  StaticSet<String?> classParamNames;
  ClosureEnv_anon_119(this.classParamNames);
  @override
  bool call(TypeParameter tp) => ClosureEnv_anon_119_call(this, tp);
}
bool ClosureEnv_anon_119_call(ClosureEnv_anon_119 env, TypeParameter tp) {
  return !(env.classParamNames.contains(tp.name));
}

class ClosureEnv_anon_120 extends TypeFunction1<String, VariableDeclaration> {
  dynamic this_;
  ClosureEnv_anon_120(this.this_);
  @override
  String call(VariableDeclaration p) => ClosureEnv_anon_120_call(this, p);
}
String ClosureEnv_anon_120_call(ClosureEnv_anon_120 env, VariableDeclaration p) {
    final StringBuffer sb = StringBuffer();
    if (p.isRequired)     sb.write('required ');
    if (p.isFinal)     sb.write('final ');
    sb.write(_TypeUtils__restoreType(this_, p.type));
    sb.write(' ');
    final String cleanName = _TypeUtils__cleanVarName(this_, (p.name ?? '_n'));
    p.name = cleanName;
    final String displayName = (this_._boxedVars.contains(p) ? '${cleanName}_raw' : cleanName);
    sb.write(displayName);
    if (!((p.initializer == null))) {
      sb.write(' = ${_DartRestorerBase__restoreExpr(this_, p.initializer!)}');
    }
    return sb.toString();
  }

class ClosureEnv_analyzeCapturedVarsFromFunc_121 extends TypeFunction1<void, bool> {
  BoolBox capturesThis;
  ClosureEnv_analyzeCapturedVarsFromFunc_121(this.capturesThis);
  @override
  void call(bool flag) => ClosureEnv_analyzeCapturedVarsFromFunc_121_call(this, flag);
}
void ClosureEnv_analyzeCapturedVarsFromFunc_121_call(ClosureEnv_analyzeCapturedVarsFromFunc_121 env, bool flag) {
      env.capturesThis.value = true;
    }

class ClosureEnv__collectCaptured_122 extends TypeFunction1<void, bool> {
  BoolBox innerCapturesThis;
  ClosureEnv__collectCaptured_122(this.innerCapturesThis);
  @override
  void call(bool flag) => ClosureEnv__collectCaptured_122_call(this, flag);
}
void ClosureEnv__collectCaptured_122_call(ClosureEnv__collectCaptured_122 env, bool flag) {
        env.innerCapturesThis.value = true;
      }

