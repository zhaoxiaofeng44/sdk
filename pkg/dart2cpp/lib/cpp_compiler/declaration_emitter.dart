/// Dart→C++ 声明生成器
///
/// 将 Dart 类/混入/枚举/扩展转换为 C++ 代码：
/// - 类 → Value struct + _new 构造函数 + 静态方法函数 + 委托函数
/// - mixin → 仅静态函数（无 Value struct）
/// - enum → enum class
/// - extension → 静态函数
///
/// 镜像 `lib/restorer/declaration_restorer.dart`。
library;

import 'package:kernel/kernel.dart';
import 'package:kernel/ast.dart';

import 'type_mapper.dart';
import 'class_info_collector.dart';
import 'cpp_emitter.dart';
import 'expression_emitter.dart';
import 'statement_emitter.dart';

/// C++ 声明生成器。
class DeclarationEmitter {
  final CppEmitter emitter;
  final TypeMapper typeMapper;
  final ClassInfo classInfo;

  DeclarationEmitter(this.emitter, this.typeMapper, this.classInfo);

  /// 获取表达式生成器（通过 emitter 间接引用，避免循环依赖）
  ExpressionEmitter get _exprEmitter => emitter.expressionEmitter;

  /// 获取语句生成器（通过 emitter 间接引用）
  StatementEmitter get _stmtEmitter => emitter.statementEmitter;

  // ============================================================================
  // 主入口
  // ============================================================================

  /// 为所有用户类生成 C++ 声明
  void emitAll(Library lib) {
    // typedef
    for (final td in lib.typedefs) {
      _emitTypedef(td);
    }

    // mixin 静态函数
    for (final cls in lib.classes) {
      if (cls.isMixinDeclaration && !cls.name.contains('&')) {
        _emitMixin(cls);
      }
    }

    // 用户类（含合成中间类）
    for (final cls in lib.classes) {
      if (cls.isMixinDeclaration && !cls.name.contains('&')) continue;
      if (_isEnumClass(cls)) {
        _emitEnum(cls);
        continue;
      }
      final loweredName = cls.name.contains('&')
          ? _sanitizeSyntheticName(cls.name)
          : cls.name;
      if (loweredName.isEmpty) continue;
      _emitClassLowered(cls, loweredName);
    }

    // 顶层函数
    for (final proc in lib.procedures) {
      if (proc.name.text == 'main') continue;  // main 单独处理
      _emitTopLevelProcedure(proc);
    }

    // 顶层字段
    for (final field in lib.fields) {
      _emitTopLevelField(field);
    }
  }

  // ============================================================================
  // typedef
  // ============================================================================

  void _emitTypedef(Typedef td) {
    // typedef → using alias
    final name = td.name;
    if (td.type is FunctionType) {
      final ft = td.type as FunctionType;
      final ret = typeMapper.cppType(ft.returnType);
      final params = ft.positionalParameters
          .map((p) => typeMapper.cppType(p))
          .join(', ');
      emitter.writeLine('using $name = std::function<$ret($params)>;');
    }
    emitter.writeLine();
  }

  // ============================================================================
  // Mixin → 静态函数
  // ============================================================================

  void _emitMixin(Class cls) {
    final mixinName = cls.name;
    emitter.writeLine('// === Mixin: $mixinName ===');

    // 静态字段
    _emitStaticFields(cls, mixinName);

    // 方法 → 静态函数
    for (final proc in cls.procedures) {
      if (proc.isStatic || proc.isFactory) continue;
      _emitMixinMethodAsStatic(cls, proc, mixinName);
    }
    emitter.writeLine();
  }

  void _emitMixinMethodAsStatic(Class cls, Procedure proc, String mixinName) {
    final methodName = proc.name.text;
    String funcName;
    if (proc.isGetter) {
      funcName = '${mixinName}_get_$methodName';
    } else if (proc.isSetter) {
      funcName = '${mixinName}_set_$methodName';
    } else if (TypeMapper.isOperatorName(methodName)) {
      funcName = '${mixinName}_operator${TypeMapper.operatorCppSuffix(methodName)}';
    } else {
      funcName = '${mixinName}_$methodName';
    }

    final retType = typeMapper.cppType(proc.function.returnType);
    final params = _buildParamList(proc.function, includeThis: true, thisType: 'AnyPtr');

    emitter.writeLine('$retType $funcName($params) {');
    emitter.indentMore();
    // Mixin方法中的this_需要cast到MixinValue*（与普通方法的cast逻辑一致）
    emitter.writeLine('auto this_ = static_cast<${mixinName}Value*>(this__.toVPtr());');
    emitter.insideMethodBody = true;
    emitter.thisReplacementName = 'this_';
    if (proc.function.body != null) {
      _stmtEmitter.emit(proc.function.body!);
    }
    emitter.insideMethodBody = false;
    // 非 void 方法：如果方法体没有显式 return，补一个默认返回值
    if (retType != 'void' && proc.function.body != null) {
      if (!_bodyHasExplicitReturn(proc.function.body!)) {
        emitter.writeLine('return ${_defaultReturnValue(retType)};');
      }
    }
    emitter.indentLess();
    emitter.writeLine('}');
    emitter.writeLine();
  }

  // ============================================================================
  // Enum → enum class
  // ============================================================================

  void _emitEnum(Class cls) {
    final name = cls.name;
    emitter.writeLine('// === Enum: $name ===');

    // 收集枚举值
    final values = <String>[];
    for (final field in cls.fields) {
      if (field.isStatic && field.isConst && field.name.text.isNotEmpty) {
        values.add(field.name.text);
      }
    }

    emitter.writeLine('enum class $name {');
    emitter.indentMore();
    for (var i = 0; i < values.length; i++) {
      final sep = i < values.length - 1 ? ',' : '';
      emitter.writeLine('${values[i]}$sep');
    }
    emitter.indentLess();
    emitter.writeLine('};');
    emitter.writeLine();
  }

  bool _isEnumClass(Class cls) {
    if (cls.supertype == null) return false;
    return cls.supertype!.classNode.name == '_Enum' ||
        cls.supertype!.classNode.name == 'Enum';
  }

  // ============================================================================
  // 类 → Value struct + _new + 静态方法
  // ============================================================================

  void _emitClassLowered(Class cls, String className) {
    final parentName = _getParentClassName(className);
    final isSyntheticMixin = cls.name.contains('&');

    emitter.writeLine('// === Class: $className ===');

    // 1. Value struct
    _emitValueStruct(cls, className, parentName, isSyntheticMixin);

    // 合成中间类不生成构造函数和静态方法
    if (isSyntheticMixin) {
      emitter.writeLine();
      return;
    }

    // 2. 静态字段
    _emitStaticFields(cls, className);

    // 3. 构造函数 → _new 函数
    for (final ctor in cls.constructors) {
      _emitConstructorFunction(cls, ctor, className, parentName);
    }

    // 4. 实例方法 → 静态函数
    final definedMethods = <String>{};
    for (final proc in cls.procedures) {
      if (proc.isStatic || proc.isFactory) continue;
      definedMethods.add(proc.name.text);
      _emitInstanceMethodAsStatic(cls, proc, className);
    }

    // 5. 委托函数（继承但未在当前类定义的方法）
    final allEntries = _collectAllVTableEntries(className);
    for (final entry in allEntries) {
      if (!definedMethods.contains(entry.name)) {
        _emitDelegateMethod(cls, entry, className);
      }
    }

    emitter.writeLine();
  }

  // ============================================================================
  // Value struct 生成
  // ============================================================================

  void _emitValueStruct(Class cls, String className, String? parentName,
      bool isSyntheticMixin) {
    // struct 声明
    final parent = parentName != null
        ? '${parentName}Value'
        : 'VPtr';
    emitter.writeLine('struct ${className}Value : $parent {');
    emitter.indentMore();

    // 字段
    final fields = _collectAllFields(cls);
    for (final field in fields) {
      if (field.isStatic) continue;
      final cppType = typeMapper.cppType(field.type);
      final fieldName = typeMapper.cleanIdentifier(field.name.text);
      emitter.writeLine('$cppType $fieldName{};');
    }

    // 构造函数（注册 vptr 条目）
    emitter.writeLine();
    emitter.writeLine('${className}Value() {');
    emitter.indentMore();
    emitter.writeLine('_typeName = "$className";');

    // vptr 注册
    final vtableEntries = classInfo.classVTableEntries[className] ?? [];
    for (final entry in vtableEntries) {
      final key = entry.vptrKey();
      emitter.writeLine(
          'vptr["$key"] = reinterpret_cast<void*>(&${entry.staticFuncName});');
    }

    // 方法级泛型特化的 vptr 条目
    final specs = classInfo.methodTypeSpecializations[className];
    if (specs != null) {
      for (final methodEntry in specs.entries) {
        final methodName = methodEntry.key;
        for (final spec in methodEntry.value) {
          final specKey = '${methodName}_${spec.vptrSuffix}';
          // 查找对应的基础 VTableEntry
          final baseEntry = vtableEntries
              .where((e) => e.name == methodName)
              .firstOrNull;
          if (baseEntry != null) {
            emitter.writeLine(
                'vptr["$specKey"] = reinterpret_cast<void*>(&${baseEntry.staticFuncName});');
          }
        }
      }
    }

    emitter.indentLess();
    emitter.writeLine('}');

    // staticTypeName 静态方法
    emitter.writeLine();
    emitter.writeLine('static const char* staticTypeName() { return "$className"; }');

    // gcMark 覆写
    _emitGcMarkOverride(cls, className);

    emitter.indentLess();
    emitter.writeLine('};');
  }

  void _emitGcMarkOverride(Class cls, String className) {
    // 收集需要标记的 AnyGC 字段
    final gcFields = <String>[];
    for (final field in cls.fields) {
      if (field.isStatic) continue;
      final cppType = typeMapper.cppType(field.type);
      // 指针类型和 AnyPtr 类型需要标记
      if (cppType.endsWith('*') || cppType == 'AnyPtr') {
        gcFields.add(typeMapper.cleanIdentifier(field.name.text));
      }
    }

    if (gcFields.isEmpty) return;

    emitter.writeLine();
    emitter.writeLine('void gcMark(int flag) override {');
    emitter.indentMore();
    emitter.writeLine('if (gcFlag == flag) return;');
    final parent = classInfo.classHierarchy[className];
    if (parent != null) {
      emitter.writeLine('${parent}Value::gcMark(flag);');
    } else {
      emitter.writeLine('VPtr::gcMark(flag);');
    }
    for (final f in gcFields) {
      emitter.writeLine('if ($f) $f->gcMark(flag);');
    }
    emitter.indentLess();
    emitter.writeLine('}');
  }

  // ============================================================================
  // 构造函数 → _new 函数
  // ============================================================================

  void _emitConstructorFunction(
      Class cls, Constructor ctor, String className, String? parentName) {
    // 确定函数名
    String funcName;
    if (ctor.name.text.isEmpty || ctor.name.text == '') {
      funcName = '${className}_new';
    } else {
      funcName = '${className}_new_${typeMapper.cleanIdentifier(ctor.name.text)}';
    }

    // 参数列表：this__ + positional + named(展平为positional)
    final params = _buildParamList(ctor.function,
        includeThis: true, thisType: '$className*');

    emitter.writeLine('$className* $funcName($params) {');
    emitter.indentMore();

    // 处理初始化器列表
    for (final init in ctor.initializers) {
      if (init is SuperInitializer) {
        // 调用父类构造函数，传递参数
        final superCtor = init.target;
        final superClassName = superCtor.enclosingClass.name;
        String superCtorName;
        if (superCtor.name.text.isEmpty) {
          superCtorName = '${superClassName}_new';
        } else {
          superCtorName = '${superClassName}_new_${typeMapper.cleanIdentifier(superCtor.name.text)}';
        }

        // 构建父类构造参数
        final superArgs = <String>['this__'];
        for (final a in init.arguments.positional) {
          superArgs.add(_exprEmitter.emit(a));
        }
        for (final n in init.arguments.named) {
          superArgs.add(_exprEmitter.emit(n.value));
        }
        emitter.writeLine('$superCtorName(${superArgs.join(', ')});');
      } else if (init is FieldInitializer) {
        final fieldName = typeMapper.cleanIdentifier(init.field.name.text);
        final initExpr = _exprEmitter.emit(init.value);
        emitter.writeLine('this__->$fieldName = $initExpr;');
      } else if (init is LocalInitializer) {
        // LocalInitializer → 声明局部变量
        final varName = typeMapper.cleanIdentifier(init.variable.name ?? '_v');
        final initExpr = _exprEmitter.emit(init.variable.initializer!);
        final cppType = typeMapper.cppType(init.variable.type);
        emitter.writeLine('$cppType $varName = $initExpr;');
      }
    }

    // 如果没有 SuperInitializer 但有父类，调用默认父类构造
    final hasSuperInit = ctor.initializers.any((i) => i is SuperInitializer);
    if (!hasSuperInit && parentName != null &&
        !classInfo.syntheticLoweredNames.contains(className)) {
      emitter.writeLine('${parentName}_new(this__);');
    }

    // 构造函数体
    if (ctor.function.body != null) {
      _stmtEmitter.emit(ctor.function.body!);
    }

    emitter.writeLine('return this__;');
    emitter.indentLess();
    emitter.writeLine('}');
    emitter.writeLine();
  }

  // ============================================================================
  // 实例方法 → 静态函数
  // ============================================================================

  void _emitInstanceMethodAsStatic(
      Class cls, Procedure proc, String className) {
    final methodName = proc.name.text;
    String funcName;
    if (proc.isGetter) {
      funcName = '${className}_get_$methodName';
    } else if (proc.isSetter) {
      funcName = '${className}_set_$methodName';
    } else if (TypeMapper.isOperatorName(methodName)) {
      funcName = '${className}_operator${TypeMapper.operatorCppSuffix(methodName)}';
    } else {
      funcName = '${className}_$methodName';
    }

    final retType = typeMapper.cppType(proc.function.returnType);
    final params = _buildParamList(proc.function,
        includeThis: true, thisType: 'AnyPtr');

    emitter.writeLine('$retType $funcName($params) {');
    emitter.indentMore();

    // 首行：cast this__ → this_
    emitter.writeLine(
        'auto this_ = static_cast<${className}Value*>(this__.toVPtr());');

    // 设置方法体上下文
    emitter.insideMethodBody = true;
    emitter.thisReplacementName = 'this_';

    // 方法体
    if (proc.function.body != null) {
      _stmtEmitter.emit(proc.function.body!);
    }

    // 恢复上下文
    emitter.insideMethodBody = false;

    // 非 void 方法：如果方法体没有显式 return，补一个默认返回值
    if (retType != 'void' && proc.function.body != null) {
      if (!_bodyHasExplicitReturn(proc.function.body!)) {
        emitter.writeLine('return ${_defaultReturnValue(retType)};');
      }
    }

    emitter.indentLess();
    emitter.writeLine('}');
    emitter.writeLine();
  }

  /// 检查语句体是否包含显式 return 语句
  bool _bodyHasExplicitReturn(Statement body) {
    if (body is ReturnStatement) return true;
    if (body is Block) {
      if (body.statements.isEmpty) return false;
      final last = body.statements.last;
      return _bodyHasExplicitReturn(last);
    }
    if (body is IfStatement) {
      final thenReturn = _bodyHasExplicitReturn(body.then);
      final elseReturn = body.otherwise != null
          ? _bodyHasExplicitReturn(body.otherwise!) : false;
      return thenReturn && elseReturn;
    }
    return false;
  }

  /// 根据返回类型生成默认返回值
  String _defaultReturnValue(String retType) {
    if (retType == 'int64_t') return '0';
    if (retType == 'double') return '0.0';
    if (retType == 'bool') return 'false';
    if (retType == 'std::string') return '"\""';
    if (retType == 'AnyPtr') return 'AnyPtr()';
    if (retType.startsWith('StaticList')) return 'StaticList<AnyPtr>::empty()';
    if (retType.startsWith('StaticSet')) return 'StaticSet<AnyPtr>::empty()';
    if (retType.startsWith('StaticMap')) return 'StaticMap<AnyPtr, AnyPtr>::empty()';
    if (retType.startsWith('Promise')) return 'nullptr';
    if (retType.endsWith('*')) return 'nullptr';
    return 'AnyPtr()';
  }

  // ============================================================================
  // 委托函数
  // ============================================================================

  void _emitDelegateMethod(
      Class cls, VTableEntry entry, String className) {
    // 委托函数名：ClassName_methodName（继承但未在当前类重新定义的方法）
    // 但需要与 VTableEntry 的命名规则一致
    String funcName;
    if (entry.kind == 'getter') {
      funcName = '${className}_get_${entry.name}';
    } else if (entry.kind == 'setter') {
      funcName = '${className}_set_${entry.name}';
    } else if (entry.kind == 'operator') {
      funcName = '${className}_operator${TypeMapper.operatorCppSuffix(entry.name)}';
    } else {
      funcName = '${className}_${entry.name}';
    }

    final retType = entry.cppReturnType;
    final params = ['AnyPtr this__',
      ...entry.cppParamTypes.asMap().entries.map((e) => '${e.value} _p${e.key}')
    ].join(', ');

    emitter.writeLine('$retType $funcName($params) {');
    emitter.indentMore();

    // 委托到原始实现（entry.staticFuncName 是声明该方法的类的静态函数名）
    final args = ['this__',
      ...entry.cppParamTypes.asMap().entries.map((e) => '_p${e.key}')
    ].join(', ');
    if (retType == 'void') {
      emitter.writeLine('${entry.staticFuncName}($args);');
    } else {
      emitter.writeLine('return ${entry.staticFuncName}($args);');
    }

    emitter.indentLess();
    emitter.writeLine('}');
    emitter.writeLine();
  }

  // ============================================================================
  // 静态字段
  // ============================================================================

  void _emitStaticFields(Class cls, String className) {
    for (final field in cls.fields) {
      if (!field.isStatic) continue;
      final cppType = typeMapper.cppType(field.type);
      final fieldName = '${className}_${typeMapper.cleanIdentifier(field.name.text)}';
      if (field.initializer != null) {
        final initExpr = _exprEmitter.emit(field.initializer!);
        emitter.writeLine('$cppType $fieldName = $initExpr;');
      } else {
        emitter.writeLine('$cppType $fieldName{};');
      }
    }
  }

  // ============================================================================
  // 顶层函数
  // ============================================================================

  void _emitTopLevelProcedure(Procedure proc) {
    final name = typeMapper.cleanIdentifier(proc.name.text);
    final retType = typeMapper.cppType(proc.function.returnType);
    final params = _buildParamList(proc.function, includeThis: false);

    emitter.writeLine('$retType $name($params) {');
    emitter.indentMore();

    if (proc.function.body != null) {
      _stmtEmitter.emit(proc.function.body!);
    }

    emitter.indentLess();
    emitter.writeLine('}');
    emitter.writeLine();
  }

  // ============================================================================
  // 顶层字段
  // ============================================================================

  void _emitTopLevelField(Field field) {
    final name = typeMapper.cleanIdentifier(field.name.text);
    final cppType = typeMapper.cppType(field.type);
    if (field.initializer != null) {
      final initExpr = _exprEmitter.emit(field.initializer!);
      emitter.writeLine('$cppType $name = $initExpr;');
    } else {
      emitter.writeLine('$cppType $name{};');
    }
  }

  // ============================================================================
  // main() 函数
  // ============================================================================

  /// 生成 main() 入口（包装用户的 main 过程体）
  void emitMain(Procedure? mainProc) {
    emitter.writeLine('int main() {');
    emitter.indentMore();

    if (mainProc != null && mainProc.function.body != null) {
      _stmtEmitter.emit(mainProc.function.body!);
    }

    emitter.writeLine('return 0;');
    emitter.indentLess();
    emitter.writeLine('}');
  }

  // ============================================================================
  // 辅助方法
  // ============================================================================

  String? _getParentClassName(String className) {
    return classInfo.classHierarchy[className];
  }

  String _sanitizeSyntheticName(String name) {
    var cleaned = name.startsWith('_') ? name.substring(1) : name;
    cleaned = cleaned.replaceAll('&', '_');
    return cleaned;
  }

  /// 收集类的所有字段（包括从父类继承的）
  List<Field> _collectAllFields(Class cls) {
    final fields = <Field>[];
    // 先收集父类字段
    if (cls.supertype != null) {
      final superClass = cls.supertype!.classNode;
      if (superClass.name != 'Object' && superClass.name != '_Enum') {
        fields.addAll(_collectAllFields(superClass));
      }
    }
    // 当前类字段
    for (final f in cls.fields) {
      if (!f.isStatic) {
        fields.add(f);
      }
    }
    return fields;
  }

  /// 收集某类的所有虚表条目（含继承链）
  List<VTableEntry> _collectAllVTableEntries(String className) {
    return classInfo.classVTableEntries[className] ?? [];
  }

  /// 构建 C++ 参数列表字符串
  String _buildParamList(FunctionNode func,
      {bool includeThis = false, String thisType = 'AnyPtr'}) {
    final parts = <String>[];

    if (includeThis) {
      parts.add('$thisType this__');
    }

    for (final p in func.positionalParameters) {
      final cppType = typeMapper.cppType(p.type);
      final name = typeMapper.cleanIdentifier(p.name ?? '_p');
      parts.add('$cppType $name');
    }

    for (final p in func.namedParameters) {
      final cppType = typeMapper.cppType(p.type);
      final name = typeMapper.cleanIdentifier(p.name ?? '_p');
      parts.add('$cppType $name');
    }

    return parts.join(', ');
  }
}
