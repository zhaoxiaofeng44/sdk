/// Dart 发射器 — 将 IR 节点树转为降低后的 Dart 源码。
///
/// 输出格式与 `restorer/` 的输出完全一致，
/// 保证 `test/run_restorer_test.dart` 测试通过。
library dart_emitter;

import 'package:dart2cpp/ir/ir_nodes.dart';
import 'package:dart2cpp/shared/analysis_context.dart';

/// Dart 发射器。
class DartEmitter {
  final StringBuffer _buf = StringBuffer();
  int _indent = 0;
  late AnalysisContext ctx;

  /// Track late variables already declared in current scope to avoid duplicates
  Set<String> _declaredLateVars = {};

  /// Map of class name to IrValueClass for looking up field information
  final Map<String, IrValueClass> _valueClasses = {};

  String get _pad => '  ' * _indent;

  /// 发射完整程序。
  String emit(IrProgram program, AnalysisContext context) {
    ctx = context;
    _buf.clear();
    _emitRuntimeImport();

    for (final lib in program.libraries) {
      _emitLibrary(lib);
    }

    return _buf.toString();
  }

  void _emitRuntimeImport() {
    _buf.writeln(
        "import 'package:dart2cpp/restorer/runtime_classes.dart';\n");
  }

  void _emitLibrary(IrLibrary lib) {
    // typedef
    for (final td in lib.typedefs) {
      _emitTypedef(td);
    }

    // mixin
    for (final m in lib.mixins) {
      _emitMixin(m);
    }

    // 声明
    for (final decl in lib.declarations) {
      if (decl is IrValueClass) _emitValueClass(decl);
      if (decl is IrConstructorFunc) _emitConstructorFunc(decl);
      if (decl is IrStaticFunc) _emitStaticFunc(decl);
      if (decl is IrDelegateFunc) _emitDelegateFunc(decl);
      if (decl is IrTopLevelField) _emitTopLevelField(decl);
      if (decl is IrEnumDecl) _emitEnum(decl);
    }

    // 顶层字段
    for (final field in lib.fields) {
      _emitTopLevelField(field);
    }

    // main 函数
    if (lib.mainFunc != null) {
      _emitStaticFunc(lib.mainFunc!);
    }

    // 延迟输出：闭包类
    for (final closure in lib.pendingClosures) {
      _emitClosureClass(closure);
    }

    // 延迟输出：顶层声明
    for (final pending in lib.pendingTopLevel) {
      if (pending is IrStaticFunc) _emitStaticFunc(pending);
    }
  }

  // -----------------------------------------------------------------------
  // Typedef
  // -----------------------------------------------------------------------

  void _emitTypedef(IrTypedef td) {
    _buf.write('${_pad}typedef ${td.name}');
    if (td.typeParams.isNotEmpty) {
      _buf.write('<${td.typeParams.map((t) => _emitTypeParamDecl(t)).join(', ')}>');
    }
    _buf.writeln(' = ${_emitType(td.type)};');
    _buf.writeln();
  }

  // -----------------------------------------------------------------------
  // Mixin
  // -----------------------------------------------------------------------

  void _emitMixin(IrMixinFuncs mixin) {
    // 静态字段
    for (final field in mixin.staticFields) {
      _emitTopLevelField(field);
    }

    // 静态函数
    for (final func in mixin.funcs) {
      _emitStaticFunc(func);
    }
  }

  // -----------------------------------------------------------------------
  // Value 类
  // -----------------------------------------------------------------------

  void _emitValueClass(IrValueClass cls) {
    // Store the class for later lookup
    _valueClasses[cls.className] = cls;

    _buf.write('${_pad}class ${cls.className}Value');
    if (cls.typeParams.isNotEmpty) {
      _buf.write('<${cls.typeParams.map((t) => _emitTypeParamDecl(t)).join(', ')}>');
    }

    // extends
    if (cls.parentClassName != null) {
      final parentValue = ctx.isUserClass(cls.parentClassName!)
          ? '${cls.parentClassName}Value'
          : cls.parentClassName!;
      _buf.write(' extends $parentValue');
      if (cls.parentTypeArgs.isNotEmpty) {
        _buf.write('<${cls.parentTypeArgs.map(_emitType).join(', ')}>');
      }
    } else {
      _buf.write(' extends VPtr');
    }

    // implements
    if (cls.implementsNames.isNotEmpty) {
      _buf.write(' implements ${cls.implementsNames.map((n) => '${n}Value').join(', ')}');
    }

    _buf.writeln(' {');
    _indent++;

    // 字段
    for (final field in cls.fields) {
      if (field.isLate) {
        // Late fields with initializers that reference `this` should not have
        // their default values emitted at field declaration time.
        // Check if the default value references `this_` or `obj`
        final hasThisReference = field.defaultValue != null &&
            _emitExpr(field.defaultValue!).contains(RegExp(r'\bthis_\b|\bobj\b'));

        if (hasThisReference) {
          // Emit without initializer - will be set in constructor or lazily
          _buf.writeln('${_pad}late ${_emitType(field.type)} ${field.name};');
        } else {
          // Safe to emit with initializer
          _buf.write('${_pad}late ${_emitType(field.type)} ${field.name}');
          if (field.defaultValue != null) {
            _buf.write(' = ${_emitExpr(field.defaultValue!)}');
          }
          _buf.writeln(';');
        }
      } else {
        _buf.write('${_pad}${_emitType(field.type)} ${field.name}');
        if (field.defaultValue != null) {
          _buf.write(' = ${_emitExpr(field.defaultValue!)}');
        }
        _buf.writeln(';');
      }
    }

    _buf.writeln();

    // 构造函数（注册 vptr）
    _buf.writeln('${_pad}${cls.className}Value() {');
    _indent++;
    for (final reg in cls.vptrEntries) {
      _buf.writeln("${_pad}vptr['${reg.key}'] = ${_emitExpr(reg.value)};");
    }
    _indent--;
    _buf.writeln('${_pad}}');

    // gcMark
    if (cls.fields.isNotEmpty) {
      _buf.writeln();
      _buf.writeln('${_pad}@override');
      _buf.writeln('${_pad}void gcMark(int flag) {');
      _indent++;
      _buf.writeln('${_pad}super.gcMark(flag);');
      for (final field in cls.fields) {
        // 只对 AnyGC 类型的字段调用 gcMark
        if (_isAnyGCType(field.type)) {
          _buf.writeln('${_pad}${field.name}?.gcMark(flag);');
        }
      }
      _indent--;
      _buf.writeln('${_pad}}');
    }

    _indent--;
    _buf.writeln('${_pad}}');
    _buf.writeln();
  }

  /// Find a value class by name
  IrValueClass? _findValueClass(String className) {
    return _valueClasses[className];
  }

  // -----------------------------------------------------------------------
  // 构造函数
  // -----------------------------------------------------------------------

  void _emitConstructorFunc(IrConstructorFunc ctor) {
    final typeParamDecl = ctor.typeParams.isNotEmpty
        ? '<${ctor.typeParams.map((t) => _emitTypeParamDecl(t)).join(', ')}>'
        : '';
    final typeParamNames = ctor.typeParams.isNotEmpty
        ? '<${ctor.typeParams.map((t) => t.name).join(', ')}>'
        : '';

    _buf.write('${_pad}${ctor.className}Value$typeParamNames ${ctor.name}$typeParamDecl(');
    _buf.write('dynamic this__');
    final positional = <String>[];
    final optionalPositional = <String>[];
    final named = <String>[];
    for (final p in ctor.params) {
      var s = '${_emitType(p.type)} ${p.name}';
      if (p.defaultValue != null) {
        s += ' = ${_emitExpr(p.defaultValue!)}';
      }
      if (p.isNamed) {
        final req = p.isRequired ? 'required ' : '';
        named.add('$req$s');
      } else if (p.isOptional) {
        optionalPositional.add(s);
      } else {
        positional.add(s);
      }
    }
    for (final p in positional) {
      _buf.write(', $p');
    }
    if (optionalPositional.isNotEmpty) {
      _buf.write(', [${optionalPositional.join(', ')}]');
    }
    if (named.isNotEmpty) {
      _buf.write(', {${named.join(', ')}}');
    }
    _buf.writeln(') {');
    _indent++;

    // cast this__
    _buf.writeln('${_pad}final this_ = this__ as ${ctor.className}Value$typeParamNames;');

    // 处理重定向构造函数
    if (ctor.redirectTargetName != null) {
      final argsList = <String>[];
      argsList.add('this_');

      // 添加位置参数
      if (ctor.redirectArgs != null) {
        for (final arg in ctor.redirectArgs!) {
          argsList.add(_emitExpr(arg));
        }
      }

      // 添加命名参数
      if (ctor.redirectNamedArgs != null && ctor.redirectNamedArgs!.isNotEmpty) {
        for (final entry in ctor.redirectNamedArgs!.entries) {
          argsList.add('${entry.key}: ${_emitExpr(entry.value)}');
        }
      }

      _buf.writeln('${_pad}return ${ctor.redirectTargetName}(${argsList.join(', ')});');
      _indent--;
      _buf.writeln('${_pad}}');
      _buf.writeln();
      return;
    }

    // 调用父类构造
    if (ctor.parentNewFuncName != null && !ctor.isSyntheticMixin) {
      final argsList = <String>[];
      argsList.add('this_');

      // 添加位置参数
      if (ctor.superArgs != null) {
        for (final arg in ctor.superArgs!) {
          argsList.add(_emitExpr(arg));
        }
      }

      // 添加命名参数（不使用花括号，直接作为命名参数传递）
      if (ctor.superNamedArgs != null && ctor.superNamedArgs!.isNotEmpty) {
        for (final entry in ctor.superNamedArgs!.entries) {
          argsList.add('${entry.key}: ${_emitExpr(entry.value)}');
        }
      }

      _buf.writeln('${_pad}${ctor.parentNewFuncName}(${argsList.join(', ')});');
    }

    // 字段初始化
    for (final entry in ctor.fieldInitializers.entries) {
      _buf.writeln('${_pad}this_.${entry.key} = ${_emitExpr(entry.value)};');
    }

    // Late field initializers that reference `this` should be emitted here
    // Get the class information to find late fields with `this` references
    final valueClass = _findValueClass(ctor.className);
    if (valueClass != null) {
      for (final field in valueClass.fields) {
        if (field.isLate && field.defaultValue != null) {
          final valueStr = _emitExpr(field.defaultValue!);
          if (valueStr.contains(RegExp(r'\bthis_\b|\bobj\b'))) {
            _buf.writeln('${_pad}this_.${field.name} = $valueStr;');
          }
        }
      }
    }

    // 方法级泛型特化
    for (final reg in ctor.specializedVptrEntries) {
      _buf.writeln("${_pad}this_.vptr['${reg.key}'] = ${_emitExpr(reg.value)};");
    }

    // 构造函数体
    for (final stmt in ctor.bodyStatements) {
      _emitStmt(stmt);
    }

    _buf.writeln('${_pad}return this_;');
    _indent--;
    _buf.writeln('${_pad}}');
    _buf.writeln();
  }

  // -----------------------------------------------------------------------
  // 静态函数
  // -----------------------------------------------------------------------

  void _emitStaticFunc(IrStaticFunc func) {
    // Reset late var tracking for each function
    _declaredLateVars = {};

    if (func.isAbstract) {
      // Emit a stub that throws — needed because vptr references this name
      final typeParamDecl = func.typeParams.isNotEmpty
          ? '<${func.typeParams.map((t) => _emitTypeParamDecl(t)).join(', ')}>'
          : '';
      _buf.write('${_pad}${_emitType(func.returnType)} ${func.name}$typeParamDecl(');
      _writeParams(func.params);
      _buf.writeln(") {");
      _indent++;
      _buf.writeln("${_pad}throw UnimplementedError('${func.name} is abstract');");
      _indent--;
      _buf.writeln('${_pad}}');
      _buf.writeln();
      return;
    }

    final typeParamDecl = func.typeParams.isNotEmpty
        ? '<${func.typeParams.map((t) => _emitTypeParamDecl(t)).join(', ')}>'
        : '';

    // For sync* functions, use Iterable<T> return type and sync* keyword
    String returnStr;
    String syncPrefix = '';
    if (func.isSyncStar) {
      // Extract inner type from StaticList<T> or use the return type directly
      final retType = func.returnType;
      if (retType is IrCollectionType && retType.typeArgs.isNotEmpty) {
        returnStr = 'Iterable<${_emitType(retType.typeArgs.first)}>';
      } else {
        returnStr = 'Iterable<${_emitType(retType)}>';
      }
      syncPrefix = 'sync* ';
    } else {
      returnStr = _emitType(func.returnType);
    }

    _buf.write('${_pad}$returnStr ${func.name}$typeParamDecl(');
    _writeParams(func.params);
    _buf.writeln(') $syncPrefix{');
    _indent++;

    // this_ cast（如果第一个参数是 this__）
    if (func.params.isNotEmpty && func.params.first.name == 'this__') {
      if (func.sourceClassName != null) {
        final srcClass = func.sourceClassName!;
        if (ctx.isMixin(srcClass)) {
          // Mixins don't have Value classes — cast to dynamic
          _buf.writeln('${_pad}final this_ = this__ as dynamic;');
        } else {
          final className = ctx.isUserClass(srcClass)
              ? '${srcClass}Value'
              : srcClass;
          // Include class type params in the cast if applicable
          final clsNode = ctx.classNodes[srcClass];
          if (clsNode != null && clsNode.typeParameters.isNotEmpty) {
            final typeParamNames = clsNode.typeParameters
                .map((tp) => tp.name ?? 'T')
                .join(', ');
            _buf.writeln('${_pad}final this_ = this__ as $className<$typeParamNames>;');
          } else {
            _buf.writeln('${_pad}final this_ = this__ as $className;');
          }
        }
      }
    }

    _emitStmt(func.body);

    _indent--;
    _buf.writeln('${_pad}}');
    _buf.writeln();
  }

  // -----------------------------------------------------------------------
  // 委托函数
  // -----------------------------------------------------------------------

  void _emitDelegateFunc(IrDelegateFunc func) {
    final typeParamDecl = func.typeParams.isNotEmpty
        ? '<${func.typeParams.map((t) => _emitTypeParamDecl(t)).join(', ')}>'
        : '';

    _buf.write('${_pad}${_emitType(func.returnType)} ${func.name}$typeParamDecl(');
    _writeParams(func.params);
    _buf.write(') ');

    // 委托调用（带类型参数）
    final typeArgStr = func.targetTypeArgs.isNotEmpty
        ? '<${func.targetTypeArgs.join(', ')}>'
        : '';
    final args = func.params.map((p) => p.name).join(', ');
    if (_emitType(func.returnType) == 'void') {
      _buf.writeln('{ ${func.targetFuncName}$typeArgStr($args); }');
    } else {
      _buf.writeln('=> ${func.targetFuncName}$typeArgStr($args);');
    }
    _buf.writeln();
  }

  // -----------------------------------------------------------------------
  // 闭包类
  // -----------------------------------------------------------------------

  void _emitClosureClass(IrClosureClass closure) {
    final typeParamDecl = closure.typeParams.isNotEmpty
        ? '<${closure.typeParams.map((t) => _emitTypeParamDecl(t)).join(', ')}>'
        : '';

    // TypeFunctionN 基类
    String baseClass;
    if (closure.arity < 0 || closure.hasNamedParams) {
      baseClass = 'TypeFunction';
    } else if (closure.arity == 0) {
      baseClass = 'TypeFunction0<${_emitType(closure.returnType)}>';
    } else {
      final paramTypes = closure.params.map((p) => _emitType(p.type)).join(', ');
      baseClass = 'TypeFunction${closure.arity}<${_emitType(closure.returnType)}, $paramTypes>';
    }

    _buf.writeln('${_pad}class ${closure.envClassName}$typeParamDecl extends $baseClass {');
    _indent++;

    // 字段
    for (final field in closure.capturedFields) {
      final fieldType = field.isBoxed && field.boxType != null
          ? _emitType(field.boxType!)
          : _emitType(field.type);
      _buf.writeln('${_pad}late $fieldType ${field.name};');
    }

    // Promise 字段（async）
    if (closure.isAsync) {
      final innerType = closure.asyncInnerType != null
          ? _emitType(closure.asyncInnerType!)
          : 'dynamic';
      _buf.writeln('${_pad}late Promise<$innerType> _promise;');
    }

    _buf.writeln();

    // 构造函数 — parameterless; fields set by _new
    _buf.writeln('${_pad}${closure.envClassName}() {');
    _indent++;
    if (closure.isAsync) {
      final innerType = closure.asyncInnerType != null
          ? _emitType(closure.asyncInnerType!)
          : 'dynamic';
      _buf.writeln('${_pad}_promise = Promise<$innerType>();');
    }
    _indent--;
    _buf.writeln('${_pad}}');

    // call 方法
    _buf.write('${_pad}${_emitType(closure.returnType)} call(');
    final callParams = closure.params
        .map((p) => '${_emitType(p.type)} ${p.name}')
        .join(', ');
    _buf.writeln('$callParams) =>');
    _buf.writeln('${_pad}    ${closure.envClassName}_call(this${closure.params.isNotEmpty ? ', ' : ''}${closure.params.map((p) => p.name).join(', ')});');

    // gcMark
    if (closure.capturedFields.isNotEmpty) {
      _buf.writeln();
      _buf.writeln('${_pad}@override');
      _buf.writeln('${_pad}void gcMark(int flag) {');
      _indent++;
      _buf.writeln('${_pad}super.gcMark(flag);');
      for (final field in closure.capturedFields) {
        if (_isAnyGCType(field.type) || field.isBoxed) {
          _buf.writeln('${_pad}${field.name}?.gcMark(flag);');
        }
      }
      _indent--;
      _buf.writeln('${_pad}}');
    }

    _indent--;
    _buf.writeln('${_pad}}');
    _buf.writeln();

    // _call 静态函数
    final callTypeParams = closure.typeParams.isNotEmpty
        ? '<${closure.typeParams.map((t) => _emitTypeParamDecl(t)).join(', ')}>'
        : '';
    final callTypeArgs = closure.typeParams.isNotEmpty
        ? '<${closure.typeParams.map((t) => t.name).join(', ')}>'
        : '';
    _buf.write('${_pad}${_emitType(closure.returnType)} ${closure.envClassName}_call$callTypeParams(');
    _buf.write('dynamic env__');
    for (final p in closure.params) {
      _buf.write(', ${_emitType(p.type)} ${p.name}');
    }
    _buf.writeln(') {');
    _indent++;
    _buf.writeln('${_pad}final env = env__ as ${closure.envClassName}$callTypeArgs;');
    _emitStmt(closure.callBody);
    _indent--;
    _buf.writeln('${_pad}}');
    _buf.writeln();

    // _new 构造函数
    _buf.write('${_pad}${closure.envClassName}$callTypeArgs ${closure.envClassName}_new$callTypeParams(');
    _buf.write('${closure.envClassName}$callTypeArgs env_');
    for (final field in closure.capturedFields) {
      final fieldType = field.isBoxed && field.boxType != null
          ? _emitType(field.boxType!)
          : _emitType(field.type);
      _buf.write(', $fieldType ${field.name}');
    }
    _buf.writeln(') {');
    _indent++;
    for (final field in closure.capturedFields) {
      if (field.isBoxed && field.boxType != null) {
        _buf.writeln('${_pad}env_.${field.name} = ${field.name};');
      } else {
        _buf.writeln('${_pad}env_.${field.name} = ${field.name};');
      }
    }
    _buf.writeln('${_pad}return env_;');
    _indent--;
    _buf.writeln('${_pad}}');
    _buf.writeln();
  }

  // -----------------------------------------------------------------------
  // Enum
  // -----------------------------------------------------------------------

  void _emitEnum(IrEnumDecl enumDecl) {
    _buf.write('${_pad}enum ${enumDecl.name}');
    if (enumDecl.typeParams.isNotEmpty) {
      _buf.write('<${enumDecl.typeParams.map((t) => _emitTypeParamDecl(t)).join(', ')}>');
    }
    _buf.writeln(' {');
    _indent++;

    for (var i = 0; i < enumDecl.values.length; i++) {
      final v = enumDecl.values[i];
      if (v.args.isEmpty) {
        _buf.write('${_pad}${v.name}');
      } else {
        _buf.write('${_pad}${v.name}(${v.args.map(_emitExpr).join(', ')})');
      }
      if (i < enumDecl.values.length - 1) {
        _buf.writeln(',');
      } else {
        _buf.writeln(';');
      }
    }

    // 如果有用户字段，发射字段声明和构造函数
    if (enumDecl.userFields.isNotEmpty) {
      _buf.writeln();
      // 字段声明
      for (final field in enumDecl.userFields) {
        _buf.writeln('${_pad}final ${_emitType(field.type)} ${field.name};');
      }
      _buf.writeln();
      // 构造函数
      _buf.write('${_pad}const ${enumDecl.name}(');
      final params = enumDecl.userFields.map((f) => 'this.${f.name}').join(', ');
      _buf.writeln('$params);');
    }

    _indent--;
    _buf.writeln('${_pad}}');
    _buf.writeln();

    // 为每个用户字段生成静态 getter 函数
    for (var fieldIdx = 0; fieldIdx < enumDecl.userFields.length; fieldIdx++) {
      final field = enumDecl.userFields[fieldIdx];
      _buf.write('${_pad}${_emitType(field.type)} ${enumDecl.name}_get_${field.name}(dynamic this__) {');
      _buf.writeln();
      _indent++;
      _buf.writeln('${_pad}final this_ = this__ as ${enumDecl.name};');
      _buf.writeln('${_pad}switch (this_) {');
      _indent++;
      for (final v in enumDecl.values) {
        if (fieldIdx < v.args.length) {
          _buf.writeln('${_pad}case ${enumDecl.name}.${v.name}:');
          _indent++;
          _buf.writeln('${_pad}return ${_emitExpr(v.args[fieldIdx])};');
          _indent--;
        }
      }
      _indent--;
      _buf.writeln('${_pad}}');
      _buf.writeln("${_pad}throw StateError('Unknown ${enumDecl.name} value');");
      _indent--;
      _buf.writeln('${_pad}}');
      _buf.writeln();
    }

    // 方法 - 作为静态函数在枚举外部发射
    for (final method in enumDecl.methods) {
      _emitStaticFunc(method);
    }
  }

  // -----------------------------------------------------------------------
  // 顶层字段
  // -----------------------------------------------------------------------

  void _emitTopLevelField(IrTopLevelField field) {
    if (field.isFinal) {
      _buf.write('${_pad}final ${_emitType(field.type)} ${field.name}');
    } else {
      _buf.write('${_pad}${_emitType(field.type)} ${field.name}');
    }
    if (field.init != null) {
      _buf.write(' = ${_emitExpr(field.init!)}');
    }
    _buf.writeln(';');
    _buf.writeln();
  }

  // -----------------------------------------------------------------------
  // 语句
  // -----------------------------------------------------------------------

  void _emitStmt(IrStatement stmt) {
    if (stmt is IrBlockStmt) {
      for (final s in stmt.statements) {
        _emitStmt(s);
      }
    } else if (stmt is IrVarDecl) {
      _emitVarDecl(stmt);
    } else if (stmt is IrReturnStmt) {
      _emitReturn(stmt);
    } else if (stmt is IrIfStmt) {
      _emitIf(stmt);
    } else if (stmt is IrForStmt) {
      _emitFor(stmt);
    } else if (stmt is IrForInStmt) {
      _buf.writeln('${_pad}for (final ${stmt.varName} in ${_emitExpr(stmt.iterable)}) {');
      _indent++;
      _emitStmt(stmt.body);
      _indent--;
      _buf.writeln('${_pad}}');
    } else if (stmt is IrWhileStmt) {
      _buf.writeln('${_pad}while (${_emitExpr(stmt.condition)}) {');
      _indent++;
      _emitStmt(stmt.body);
      _indent--;
      _buf.writeln('${_pad}}');
    } else if (stmt is IrDoWhileStmt) {
      _buf.writeln('${_pad}do {');
      _indent++;
      _emitStmt(stmt.body);
      _indent--;
      _buf.writeln('${_pad}} while (${_emitExpr(stmt.condition)});');
    } else if (stmt is IrTryCatch) {
      _emitTryCatch(stmt);
    } else if (stmt is IrSwitchStmt) {
      _emitSwitch(stmt);
    } else if (stmt is IrBreakStmt) {
      _buf.writeln('${_pad}break;');
    } else if (stmt is IrContinueStmt) {
      _buf.writeln('${_pad}continue;');
    } else if (stmt is IrLabeledStmt) {
      _buf.writeln('${_pad}do {');
      _indent++;
      _emitStmt(stmt.body);
      _indent--;
      _buf.writeln('${_pad}} while (false);');
    } else if (stmt is IrYieldStmt) {
      _buf.writeln('${_pad}yield ${_emitExpr(stmt.value)};');
    } else if (stmt is IrExprStmt) {
      _buf.writeln('${_pad}${_emitExpr(stmt.expression)};');
    } else if (stmt is IrFuncDecl) {
      _emitFuncDecl(stmt);
    } else if (stmt is IrAssertStmt) {
      if (stmt.message != null) {
        _buf.writeln('${_pad}assert(${_emitExpr(stmt.condition)}, ${_emitExpr(stmt.message!)});');
      } else {
        _buf.writeln('${_pad}assert(${_emitExpr(stmt.condition)});');
      }
    }
  }

  void _emitVarDecl(IrVarDecl decl) {
    // Skip duplicate late declarations (from pattern matching lowering)
    if (decl.isLate) {
      if (_declaredLateVars.contains(decl.name)) {
        return; // Already declared
      }
      _declaredLateVars.add(decl.name);
    }

    final prefix = decl.isLate ? 'late ' : '';

    if (decl.isBoxed && decl.boxType != null) {
      _buf.write('${_pad}$prefix${_emitType(decl.boxType!)} ${decl.name}');
      if (decl.init != null) {
        _buf.write(' = ${_emitType(decl.boxType!)}(${_emitExpr(decl.init!)})');
      }
    } else {
      _buf.write('${_pad}$prefix${_emitType(decl.type)} ${decl.name}');
      if (decl.init != null) {
        _buf.write(' = ${_emitExpr(decl.init!)}');
      }
    }
    _buf.writeln(';');
  }

  void _emitReturn(IrReturnStmt stmt) {
    if (stmt.isAsync) {
      if (stmt.value != null) {
        _buf.writeln('${_pad}env._promise.complete(${_emitExpr(stmt.value!)});');
      } else {
        _buf.writeln('${_pad}env._promise.complete(null);');
      }
      _buf.writeln('${_pad}return;');
    } else if (stmt.value != null) {
      _buf.writeln('${_pad}return ${_emitExpr(stmt.value!)};');
    } else {
      _buf.writeln('${_pad}return;');
    }
  }

  void _emitIf(IrIfStmt stmt) {
    _buf.writeln('${_pad}if (${_emitExpr(stmt.condition)}) {');
    _indent++;
    _emitStmt(stmt.thenBranch);
    _indent--;
    if (stmt.elseBranch != null) {
      _buf.writeln('${_pad}} else {');
      _indent++;
      _emitStmt(stmt.elseBranch!);
      _indent--;
    }
    _buf.writeln('${_pad}}');
  }

  void _emitFor(IrForStmt stmt) {
    _buf.write('${_pad}for (');
    if (stmt.init != null) {
      // inline init without semicolon
      if (stmt.init is IrVarDecl) {
        final decl = stmt.init as IrVarDecl;
        _buf.write('${_emitType(decl.type)} ${decl.name}');
        if (decl.init != null) {
          _buf.write(' = ${_emitExpr(decl.init!)}');
        }
      }
    }
    _buf.write('; ');
    if (stmt.condition != null) {
      _buf.write(_emitExpr(stmt.condition!));
    }
    _buf.write('; ');
    _buf.write(stmt.updaters.map(_emitExpr).join(', '));
    _buf.writeln(') {');
    _indent++;
    _emitStmt(stmt.body);
    _indent--;
    _buf.writeln('${_pad}}');
  }

  void _emitTryCatch(IrTryCatch stmt) {
    _buf.writeln('${_pad}try {');
    _indent++;
    _emitStmt(stmt.tryBody);
    _indent--;
    for (final c in stmt.catches) {
      final typeStr = c.exceptionType != null ? _emitType(c.exceptionType!) : 'Object';
      final varStr = c.exceptionVar != null ? ' ${c.exceptionVar}' : ' _';
      _buf.writeln('${_pad}} on $typeStr catch ($varStr) {');
      _indent++;
      _emitStmt(c.body);
      _indent--;
    }
    if (stmt.finallyBody != null) {
      _buf.writeln('${_pad}} finally {');
      _indent++;
      _emitStmt(stmt.finallyBody!);
      _indent--;
    }
    _buf.writeln('${_pad}}');
  }

  void _emitSwitch(IrSwitchStmt stmt) {
    _buf.writeln('${_pad}switch (${_emitExpr(stmt.subject)}) {');
    _indent++;
    for (final c in stmt.cases) {
      _buf.writeln('${_pad}case ${c.values.map(_emitExpr).join(' || ')}:');
      _indent++;
      _emitStmt(c.body);
      _indent--;
    }
    if (stmt.defaultCase != null) {
      _buf.writeln('${_pad}default:');
      _indent++;
      _emitStmt(stmt.defaultCase!);
      _indent--;
    }
    _indent--;
    _buf.writeln('${_pad}}');
  }

  void _emitFuncDecl(IrFuncDecl stmt) {
    _buf.write('${_pad}${_emitType(stmt.returnType)} ${stmt.name}(');
    final paramStr = stmt.params
        .map((p) => '${_emitType(p.type)} ${p.name}')
        .join(', ');
    _buf.writeln('$paramStr) {');
    _indent++;
    _emitStmt(stmt.body);
    _indent--;
    _buf.writeln('${_pad}}');
  }

  // -----------------------------------------------------------------------
  // 表达式
  // -----------------------------------------------------------------------

  String _emitExpr(IrExpression expr) {
    if (expr is IrIntLiteral) return '${expr.value}';
    if (expr is IrDoubleLiteral) {
      var s = '${expr.value}';
      if (!s.contains('.')) s = '$s.0';
      return s;
    }
    if (expr is IrBoolLiteral) return '${expr.value}';
    if (expr is IrStringLiteral) return "'${_escapeString(expr.value)}'";
    if (expr is IrNullLiteral) return 'null';
    if (expr is IrSymbolLiteral) return '#${expr.name}';
    if (expr is IrTypeLiteral) return _emitType(expr.type);

    if (expr is IrStringConcat) {
      return "'${expr.parts.map((p) {
        if (p is IrStringLiteral) return _escapeString(p.value);
        return '\${${_emitExpr(p)}}';
      }).join()}'";
    }

    if (expr is IrVariableGet) {
      final prefix = expr.envPrefix ?? '';
      final dot = prefix.isNotEmpty ? '.' : '';
      final suffix = expr.isBoxed ? '.value' : '';
      return '$prefix$dot${expr.name}$suffix';
    }
    if (expr is IrVariableSet) {
      final prefix = expr.envPrefix ?? '';
      final dot = prefix.isNotEmpty ? '.' : '';
      if (expr.isBoxed) {
        return '$prefix$dot${expr.name}.value = ${_emitExpr(expr.value)}';
      }
      return '$prefix$dot${expr.name} = ${_emitExpr(expr.value)}';
    }

    if (expr is IrVptrDispatch) return _emitVptrDispatch(expr);
    if (expr is IrStaticCall) return _emitStaticCall(expr);
    if (expr is IrDynamicCall) {
      return '${_emitExpr(expr.receiver)}.${expr.methodName}(${expr.args.map(_emitExpr).join(', ')})';
    }
    if (expr is IrFunctionInvocation) {
      return '${_emitExpr(expr.target)}(${expr.args.map(_emitExpr).join(', ')})';
    }

    if (expr is IrConstructorCall) return _emitConstructorCall(expr);

    if (expr is IrFieldGet) {
      if (expr.isEnumGetter) {
        return '${expr.enumGetterFuncName}(${_emitExpr(expr.receiver)})';
      }
      return '${_emitExpr(expr.receiver)}.${expr.fieldName}';
    }
    if (expr is IrFieldSet) {
      return '${_emitExpr(expr.receiver)}.${expr.fieldName} = ${_emitExpr(expr.value)}';
    }
    if (expr is IrStaticFieldSet) {
      final className = ctx.isUserClass(expr.className) ? expr.className : expr.className;
      return '${className}_${expr.fieldName} = ${_emitExpr(expr.value)}';
    }

    if (expr is IrClosureExpr) {
      // 返回构造函数调用
      final captureArgs = expr.capturedFields
          .map((f) {
            if (f.isThis) return 'this_';
            final prefix = f.envPrefix != null ? '${f.envPrefix}.' : '';
            // If the field comes from an outer closure (has envPrefix), pass the box itself
            // Otherwise, if it's boxed, pass the value
            final suffix = (f.isBoxed && f.envPrefix == null) ? '.value' : '';
            return '$prefix${f.name}$suffix';
          })
          .join(', ');
      final typeArgs = expr.typeParams.isNotEmpty
          ? '<${expr.typeParams.map((t) => t.name).join(', ')}>'
          : '';
      final allArgs = <String>[
        'GC.allocateLocal(${expr.envClassName}$typeArgs())',
        if (captureArgs.isNotEmpty) captureArgs,
      ];
      return '${expr.envClassName}_new$typeArgs(${allArgs.join(', ')})';
    }

    if (expr is IrListLiteral) {
      final typeArgs = expr.typeArgs.isNotEmpty
          ? '<${expr.typeArgs.map(_emitType).join(', ')}>'
          : '';
      return 'StaticList$typeArgs.of([${expr.elements.map(_emitExpr).join(', ')}])';
    }
    if (expr is IrMapLiteral) {
      final typeArgs = expr.typeArgs.isNotEmpty
          ? '<${expr.typeArgs.map(_emitType).join(', ')}>'
          : '';
      final entries = expr.entries
          .map((e) => '${_emitExpr(e.key)}: ${_emitExpr(e.value)}')
          .join(', ');
      return 'StaticMap$typeArgs.of({$entries})';
    }
    if (expr is IrSetLiteral) {
      final typeArgs = expr.typeArgs.isNotEmpty
          ? '<${expr.typeArgs.map(_emitType).join(', ')}>'
          : '';
      return 'StaticSet$typeArgs.of({${expr.elements.map(_emitExpr).join(', ')}})';
    }

    if (expr is IrConditional) {
      return '(${_emitExpr(expr.condition)} ? ${_emitExpr(expr.thenExpr)} : ${_emitExpr(expr.elseExpr)})';
    }
    if (expr is IrLogicalExpr) {
      final op = expr.op == LogicalOp.and ? '&&' : '||';
      return '${_emitExpr(expr.left)} $op ${_emitExpr(expr.right)}';
    }
    if (expr is IrNotExpr) return '!${_emitExpr(expr.operand)}';
    if (expr is IrThrowExpr) return 'throw ${_emitExpr(expr.exception)}';
    if (expr is IrRethrowExpr) return 'rethrow';
    if (expr is IrAwaitExpr) return 'smAwait(${_emitExpr(expr.operand)})';

    if (expr is IrIsCheck) {
      return '${_emitExpr(expr.operand)} is ${_emitType(expr.checkType)}';
    }
    if (expr is IrCastExpr) {
      return '(${_emitExpr(expr.operand)} as ${_emitType(expr.castType)})';
    }
    if (expr is IrNullCheck) return '${_emitExpr(expr.operand)}!';

    if (expr is IrLetExpr) {
      return '(() { final ${expr.varName} = ${_emitExpr(expr.init)}; return ${_emitExpr(expr.body)}; })()';
    }

    if (expr is IrThisExpr) {
      if (expr.inClosureEnv) return 'env.this_';
      return expr.replacementName;
    }
    if (expr is IrSuperCall) {
      return '${expr.staticFuncName}(${expr.args.map(_emitExpr).join(', ')})';
    }
    if (expr is IrSuperFieldGet) return 'super.${expr.fieldName}';
    if (expr is IrSuperFieldSet) {
      return 'super.${expr.fieldName} = ${_emitExpr(expr.value)}';
    }

    if (expr is IrRecordLiteral) {
      final parts = <String>[];
      for (final p in expr.positional) {
        parts.add(_emitExpr(p));
      }
      for (final entry in expr.named.entries) {
        parts.add('${entry.key}: ${_emitExpr(entry.value)}');
      }
      return '(${parts.join(', ')})';
    }
    if (expr is IrRecordGet) {
      if (expr.index != null) {
        // Dart records use 1-based indexing: $1, $2, etc.
        return '${_emitExpr(expr.receiver)}.\$${expr.index! + 1}';
      }
      return '${_emitExpr(expr.receiver)}.${expr.name}';
    }

    if (expr is IrTearOff) return expr.staticFuncName;

    if (expr is IrBlockExpr) {
      // Emit block expression as an IIFE: (() { stmts; return result; })()
      final inner = _emitBlockExprBody(expr);
      return '(() { $inner})()';
    }

    if (expr is IrEqualsNull) return '(${_emitExpr(expr.operand)} == null)';
    if (expr is IrEqualsCall) {
      return '(${_emitExpr(expr.left)} == ${_emitExpr(expr.right)})';
    }

    if (expr is IrNativeOpExpr) return _emitNativeOp(expr);
    if (expr is IrRawCode) return expr.dartCode;

    return '/* unknown expr: ${expr.runtimeType} */';
  }

  String _emitVptrDispatch(IrVptrDispatch expr) {
    // 私有方法直接调用
    if (expr.isPrivateDirectCall && expr.directStaticFuncName != null) {
      final args = <String>[_emitExpr(expr.receiver)];
      for (final a in expr.args) {
        args.add(_emitExpr(a));
      }
      for (final entry in expr.namedArgs.entries) {
        args.add('${entry.key}: ${_emitExpr(entry.value)}');
      }
      return '${expr.directStaticFuncName}(${args.join(', ')})';
    }

    // 泛型特化
    var vptrKey = expr.vptrKey;
    if (expr.specializationSuffix != null) {
      vptrKey = '${expr.vptrKey}_${expr.specializationSuffix}';
    }

    // 构建参数
    final args = <String>[_emitExpr(expr.receiver)];
    for (final a in expr.args) {
      args.add(_emitExpr(a));
    }
    for (final entry in expr.namedArgs.entries) {
      args.add('${entry.key}: ${_emitExpr(entry.value)}');
    }

    // Use Function as intermediate cast to support generic methods
    final callExpr = '(${_emitExpr(expr.receiver)}.vptr[\'$vptrKey\'] as Function)(${args.join(', ')})';

    // Don't cast result — generic methods through vptr lose type arguments
    // The caller will handle type conversion if needed
    final retType = _emitType(expr.returnType);
    if (retType == 'void') {
      return callExpr;
    }
    return callExpr;
  }

  String _emitStaticCall(IrStaticCall expr) {
    final typeArgs = expr.typeArgs.isNotEmpty
        ? '<${expr.typeArgs.map(_emitType).join(', ')}>'
        : '';
    final allArgs = <String>[
      ...expr.args.map(_emitExpr),
      ...expr.namedArgs.entries.map((e) => '${e.key}: ${_emitExpr(e.value)}'),
    ];
    final argsStr = allArgs.join(', ');
    // Handle ClassName.method type args placement
    if (expr.funcName.contains('.')) {
      final dotIdx = expr.funcName.indexOf('.');
      final className = expr.funcName.substring(0, dotIdx);
      final methodName = expr.funcName.substring(dotIdx + 1);
      if (expr.isStaticMethod) {
        // Static method: ClassName.methodName<T>(args)
        return '$className.$methodName$typeArgs($argsStr)';
      } else {
        // Named constructor: ClassName<T>.methodName(args)
        return '$className$typeArgs.$methodName($argsStr)';
      }
    }
    return '${expr.funcName}$typeArgs($argsStr)';
  }

  String _emitConstructorCall(IrConstructorCall expr) {
    final typeArgs = expr.typeArgs.isNotEmpty
        ? '<${expr.typeArgs.map(_emitType).join(', ')}>'
        : '';

    // Build argument list
    final argsList = <String>[];

    // Add positional arguments
    for (final arg in expr.args) {
      argsList.add(_emitExpr(arg));
    }

    // Add named arguments
    if (expr.namedArgs.isNotEmpty) {
      for (final entry in expr.namedArgs.entries) {
        argsList.add('${entry.key}: ${_emitExpr(entry.value)}');
      }
    }

    final argsStr = argsList.join(', ');

    // Factory constructors don't have a this__ parameter
    if (expr.isFactory) {
      return '${expr.newFuncName}$typeArgs($argsStr)';
    }
    final valueExpr = '${expr.className}Value$typeArgs()';
    if (argsStr.isEmpty) {
      return '${expr.newFuncName}$typeArgs($valueExpr)';
    }
    return '${expr.newFuncName}$typeArgs($valueExpr, $argsStr)';
  }

  // -----------------------------------------------------------------------
  // 类型
  // -----------------------------------------------------------------------

  String _emitType(IrType type) {
    if (type is IrVoidType) return 'void';
    if (type is IrPrimitiveType) {
      return switch (type.kind) {
        PrimitiveKind.int_ => 'int',
        PrimitiveKind.double_ => 'double',
        PrimitiveKind.bool_ => 'bool',
        PrimitiveKind.string_ => 'String',
      };
    }
    if (type is IrDynamicType) return 'dynamic';
    if (type is IrUserType) {
      final name = ctx.isUserClass(type.className)
          ? '${type.className}Value'
          : type.className;
      if (type.typeArgs.isEmpty) return name;
      return '$name<${type.typeArgs.map(_emitType).join(', ')}>';
    }
    if (type is IrCollectionType) {
      final name = switch (type.kind) {
        CollectionKind.list => 'StaticList',
        CollectionKind.map => 'StaticMap',
        CollectionKind.set_ => 'StaticSet',
        CollectionKind.iterator => 'StaticIterator',
        CollectionKind.iterable => 'StaticList',
      };
      if (type.typeArgs.isEmpty) return name;
      return '$name<${type.typeArgs.map(_emitType).join(', ')}>';
    }
    if (type is IrPromiseType) return 'Promise<${_emitType(type.innerType)}>';
    if (type is IrFunctionType) {
      if (type.arity < 0 || type.hasNamedParams) return 'dynamic';
      final retStr = _emitType(type.returnType);
      if (type.paramTypes.isEmpty) {
        return 'TypeFunction0<$retStr>';
      }
      final paramStr = type.paramTypes.map(_emitType).join(', ');
      return 'TypeFunction${type.arity}<$retStr, $paramStr>';
    }
    if (type is IrBoxType) {
      return switch (type.kind) {
        BoxKind.intBox => 'IntBox',
        BoxKind.doubleBox => 'DoubleBox',
        BoxKind.boolBox => 'BoolBox',
        BoxKind.stringBox => 'StringBox',
        BoxKind.objectBox => 'ObjectBox<${type.innerType != null ? _emitType(type.innerType!) : 'dynamic'}>',
      };
    }
    if (type is IrTypeParameterType) return type.name;
    if (type is IrNullableType) return '${_emitType(type.inner)}?';
    if (type is IrAnyPtrType) return 'dynamic';
    if (type is IrRecordType) return '(${type.positionalTypes.map(_emitType).join(', ')})';

    return 'dynamic';
  }

  String _emitTypeParamDecl(IrTypeParameterType tp) {
    if (tp.bound != null) {
      return '${tp.name} extends ${_emitType(tp.bound!)}';
    }
    return tp.name;
  }

  // -----------------------------------------------------------------------
  // Helpers
  // -----------------------------------------------------------------------

  void _writeParams(List<IrFuncParam> params) {
    final positional = <String>[];
    final optionalPositional = <String>[];
    final named = <String>[];

    for (final p in params) {
      var s = '${_emitType(p.type)} ${p.name}';
      if (p.defaultValue != null) {
        s += ' = ${_emitExpr(p.defaultValue!)}';
      }
      if (p.isNamed) {
        final req = p.isRequired ? 'required ' : '';
        named.add('$req$s');
      } else if (p.isOptional) {
        optionalPositional.add(s);
      } else {
        positional.add(s);
      }
    }

    final parts = <String>[...positional];
    if (optionalPositional.isNotEmpty) {
      parts.add('[${optionalPositional.join(', ')}]');
    }
    if (named.isNotEmpty) {
      parts.add('{${named.join(', ')}}');
    }
    _buf.write(parts.join(', '));
  }

  String _escapeString(String s) {
    return s
        .replaceAll(r'\', r'\\')
        .replaceAll("'", r"\'")
        .replaceAll(r'$', r'\$')
        .replaceAll('\n', r'\n')
        .replaceAll('\r', r'\r')
        .replaceAll('\t', r'\t');
  }

  bool _isAnyGCType(IrType type) {
    if (type is IrUserType) {
      // Enums don't need gcMark
      if (ctx.isEnum(type.className)) return false;
      return true;
    }
    if (type is IrCollectionType) return true;
    if (type is IrPromiseType) return true;
    if (type is IrFunctionType) return true;
    return false;
  }

  String _emitNativeOp(IrNativeOpExpr expr) {
    final left = _emitExpr(expr.left);
    // Unary operators
    if (expr.op == 'unary-') return '-$left';
    if (expr.op == '~') return '~$left';
    // Index operators
    if (expr.op == '[]' && expr.right != null) {
      return '$left[${_emitExpr(expr.right!)}]';
    }
    if (expr.op == '[]=' && expr.right != null && expr.indexSetValue != null) {
      return '$left[${_emitExpr(expr.right!)}] = ${_emitExpr(expr.indexSetValue!)}';
    }
    // Binary operators
    if (expr.right != null) {
      return '($left ${expr.op} ${_emitExpr(expr.right!)})';
    }
    return left;
  }

  /// Emit the body of a block expression (statements + return value) as a string.
  /// Uses a temporary emitter instance to avoid clobbering the main buffer.
  String _emitBlockExprBody(IrBlockExpr expr) {
    final tmp = DartEmitter();
    tmp.ctx = ctx; // Copy the analysis context
    tmp._indent = 0;
    for (final s in expr.statements) {
      tmp._emitStmt(s);
    }
    if (expr.result != null) {
      tmp._buf.write('return ${tmp._emitExpr(expr.result!)}; ');
    }
    return tmp._buf.toString();
  }
}
