/// C++ 声明发射器 — 将 IR 声明节点转为 C++ 声明。
library cpp_decl_emitter;

import 'package:dart2cpp/ir/ir_nodes.dart';
import 'package:dart2cpp/shared/analysis_context.dart';
import 'cpp_type_emitter.dart';
import 'cpp_expr_emitter.dart';
import 'cpp_stmt_emitter.dart';

/// C++ 声明发射器。
class CppDeclEmitter {
  final AnalysisContext ctx;
  final CppTypeEmitter typeEmitter;
  final CppExprEmitter exprEmitter;
  final CppStmtEmitter stmtEmitter;
  final StringBuffer _buf;
  int _indent = 0;

  String get _pad => '    ' * _indent;

  CppDeclEmitter(this.ctx, this.typeEmitter, this.exprEmitter, this.stmtEmitter, this._buf);

  /// 发射 Value 结构体。
  void emitValueClass(IrValueClass cls) {
    // Template prefix if generic
    final templatePrefix = cls.typeParams.isNotEmpty
        ? 'template<${cls.typeParams.map((t) => 'typename ${t.name}').join(', ')}> '
        : '';

    // struct 声明 — no type args after struct name in definition
    _buf.write('${_pad}${templatePrefix}struct ${cls.className}Value');
    if (cls.parentClassName != null) {
      final parentValue = ctx.isUserClass(cls.parentClassName!)
          ? '${cls.parentClassName}Value'
          : cls.parentClassName!;
      _buf.write(' : $parentValue');
    } else {
      _buf.write(' : VPtr');
    }
    _buf.writeln(' {');
    _indent++;

    // 字段
    for (final field in cls.fields) {
      final typeStr = typeEmitter.emit(field.type);
      _buf.writeln('${_pad}$typeStr ${field.name}{};');
    }

    _buf.writeln();

    // 构造函数 — 注册 vptr
    _buf.writeln('${_pad}${cls.className}Value() {');
    _indent++;
    _buf.writeln('${_pad}_typeName = "${cls.className}";');
    for (final reg in cls.vptrEntries) {
      final funcName = exprEmitter.emit(reg.value);
      // Use reinterpret_cast directly to void* for function pointers
      _buf.writeln('${_pad}vptr["${reg.key}"] = reinterpret_cast<void*>(&${funcName});');
    }
    _indent--;
    _buf.writeln('${_pad}}');

    // gcMark
    if (cls.fields.isNotEmpty) {
      _buf.writeln();
      _buf.writeln('${_pad}void gcMark(int flag) override {');
      _indent++;
      _buf.writeln('${_pad}if (gcFlag == flag) return;');
      if (cls.parentClassName != null) {
        _buf.writeln('${_pad}${cls.parentClassName}Value::gcMark(flag);');
      } else {
        _buf.writeln('${_pad}VPtr::gcMark(flag);');
      }
      for (final field in cls.fields) {
        if (_isPointerOrGCType(field.type)) {
          _buf.writeln('${_pad}if (${field.name}) ${field.name}->gcMark(flag);');
        }
      }
      _indent--;
      _buf.writeln('${_pad}}');
    }

    _indent--;
    _buf.writeln('${_pad}};');
    _buf.writeln();
  }

  /// 发射构造函数。
  void emitConstructorFunc(IrConstructorFunc ctor) {
    final templatePrefix = ctor.typeParams.isNotEmpty
        ? 'template<${ctor.typeParams.map((t) => 'typename ${t.name}').join(', ')}> '
        : '';
    final typeArgs = ctor.typeParams.isNotEmpty
        ? '<${ctor.typeParams.map((t) => t.name).join(', ')}>'
        : '';

    _buf.write('${_pad}${templatePrefix}${ctor.className}Value$typeArgs* ${ctor.name}(');
    _buf.write('${ctor.className}Value$typeArgs* this__');
    for (final p in ctor.params) {
      _buf.write(', ${typeEmitter.emit(p.type)} ${p.name}');
    }
    _buf.writeln(') {');
    _indent++;

    // 调用父类构造
    if (ctor.parentNewFuncName != null && !ctor.isSyntheticMixin) {
      final superArgs = ctor.superArgs?.map(exprEmitter.emit).join(', ') ?? '';
      _buf.writeln('${_pad}${ctor.parentNewFuncName}(this__${superArgs.isNotEmpty ? ', $superArgs' : ''});');
    }

    // 字段初始化
    for (final entry in ctor.fieldInitializers.entries) {
      _buf.writeln('${_pad}this__->${entry.key} = ${exprEmitter.emit(entry.value)};');
    }

    // 构造函数体
    final bodyStr = stmtEmitter.emit(IrBlockStmt(ctor.bodyStatements));
    _buf.write(bodyStr);

    _buf.writeln('${_pad}return this__;');
    _indent--;
    _buf.writeln('${_pad}}');
    _buf.writeln();
  }

  /// 发射静态函数。
  void emitStaticFunc(IrStaticFunc func) {
    if (func.isAbstract) {
      // Emit stub
      final retType = typeEmitter.emit(func.returnType);
      _buf.write('${_pad}$retType ${func.name}(');
      _writeParams(func.params);
      _buf.writeln(') {');
      _indent++;
      _buf.writeln('${_pad}throw DartUnimplementedError("${func.name} is abstract");');
      _indent--;
      _buf.writeln('${_pad}}');
      _buf.writeln();
      return;
    }

    final templatePrefix = func.typeParams.isNotEmpty
        ? 'template<${func.typeParams.map((t) => 'typename ${t.name}').join(', ')}> '
        : '';

    // C++ main must return int
    final retType = func.name == 'main'
        ? 'int'
        : typeEmitter.emit(func.returnType);
    _buf.write('${_pad}${templatePrefix}$retType ${func.name}(');
    _writeParams(func.params);
    _buf.writeln(') {');
    _indent++;

    // this_ cast
    if (func.params.isNotEmpty && func.params.first.name == 'this__') {
      if (func.sourceClassName != null) {
        final srcClass = func.sourceClassName!;
        var className = ctx.isUserClass(srcClass)
            ? '${srcClass}Value'
            : srcClass;

        // Add template arguments if this is a generic class
        if (ctx.isUserClass(srcClass) && func.typeParams.isNotEmpty) {
          final typeArgs = func.typeParams.map((t) => t.name).join(', ');
          className = '$className<$typeArgs>';
        }

        _buf.writeln('${_pad}auto this_ = static_cast<$className*>(this__.toVPtr());');
      }
    }

    // 函数体
    final bodyStr = stmtEmitter.emit(func.body);
    _buf.write(bodyStr);

    _indent--;
    _buf.writeln('${_pad}}');
    _buf.writeln();
  }

  /// 发射委托函数。
  void emitDelegateFunc(IrDelegateFunc func) {
    // Template prefix for type parameters
    final templatePrefix = func.typeParams.isNotEmpty
        ? 'template<${func.typeParams.map((t) => typeEmitter.emitTypeParamDecl(t)).join(', ')}> '
        : '';
    final retType = typeEmitter.emit(func.returnType);
    _buf.write('${_pad}${templatePrefix}$retType ${func.name}(');
    _writeParams(func.params);
    _buf.write(') ');

    // 委托调用（C++ 中模板参数用 <...> 传递）
    final typeArgStr = func.targetTypeArgs.isNotEmpty
        ? '<${func.targetTypeArgs.join(', ')}>'
        : '';
    final args = func.params.map((p) => p.name).join(', ');
    if (retType == 'void') {
      _buf.writeln('{ ${func.targetFuncName}$typeArgStr($args); }');
    } else {
      _buf.writeln('{ return ${func.targetFuncName}$typeArgStr($args); }');
    }
    _buf.writeln();
  }

  /// 发射闭包类。
  void emitClosureClass(IrClosureClass closure) {
    // Template declaration: template<typename T, typename U>
    final templatePrefix = closure.typeParams.isNotEmpty
        ? 'template<${closure.typeParams.map((t) => typeEmitter.emitTypeParamDecl(t)).join(', ')}> '
        : '';
    // Type arguments: <T, U>
    final typeArgs = closure.typeParams.isNotEmpty
        ? '<${closure.typeParams.map((t) => t.name).join(', ')}>'
        : '';

    // Emit forward declarations for _call and _new functions
    final callTemplatePrefix = closure.typeParams.isNotEmpty
        ? 'template<${closure.typeParams.map((t) => typeEmitter.emitTypeParamDecl(t)).join(', ')}> '
        : '';

    // Forward declare _call
    _buf.write('${_pad}${callTemplatePrefix}${typeEmitter.emit(closure.returnType)} ${closure.envClassName}_call(');
    if (closure.isAsync) {
      _buf.write('${closure.envClassName}$typeArgs* env');
    } else {
      _buf.write('AnyPtr env__');
    }
    for (final p in closure.params) {
      _buf.write(', ${typeEmitter.emit(p.type)} ${p.name}');
    }
    _buf.writeln(');');

    // Forward declare _new
    _buf.write('${_pad}${callTemplatePrefix}${closure.envClassName}$typeArgs* ${closure.envClassName}_new(');
    _buf.write('${closure.envClassName}$typeArgs* env_');
    for (final field in closure.capturedFields) {
      final fieldType = field.isBoxed && field.boxType != null
          ? typeEmitter.emit(field.boxType!)
          : typeEmitter.emit(field.type);
      _buf.write(', $fieldType ${field.name}');
    }
    _buf.writeln(');');
    _buf.writeln();

    // TypeFunctionN 基类
    String baseClass;
    if (closure.isAsync) {
      baseClass = 'AnyGC';
    } else if (closure.arity < 0 || closure.hasNamedParams) {
      baseClass = 'TypeFunction';
    } else if (closure.arity == 0) {
      baseClass = 'TypeFunction0<${typeEmitter.emit(closure.returnType)}>';
    } else {
      final paramTypes = closure.params.map((p) => typeEmitter.emit(p.type)).join(', ');
      baseClass = 'TypeFunction${closure.arity}<${typeEmitter.emit(closure.returnType)}, $paramTypes>';
    }

    _buf.writeln('${_pad}${templatePrefix}struct ${closure.envClassName} : $baseClass {');
    _indent++;

    // 字段
    for (final field in closure.capturedFields) {
      final fieldType = field.isBoxed && field.boxType != null
          ? typeEmitter.emit(field.boxType!)
          : typeEmitter.emit(field.type);
      _buf.writeln('${_pad}$fieldType ${field.name}{};');
    }

    // Promise 字段（async）
    if (closure.isAsync) {
      final innerType = closure.asyncInnerType != null
          ? typeEmitter.emit(closure.asyncInnerType!)
          : 'AnyPtr';
      _buf.writeln('${_pad}Promise<$innerType>* _promise{};');
    }

    _buf.writeln();

    // 构造函数
    _buf.writeln('${_pad}${closure.envClassName}$typeArgs() {');
    _indent++;
    if (closure.isAsync) {
      final innerType = closure.asyncInnerType != null
          ? typeEmitter.emit(closure.asyncInnerType!)
          : 'AnyPtr';
      _buf.writeln('${_pad}_promise = GC::allocateLocal(new Promise<$innerType>());');
    }
    _indent--;
    _buf.writeln('${_pad}}');

    // call 方法
    if (!closure.isAsync) {
      _buf.write('${_pad}${typeEmitter.emit(closure.returnType)} call(');
      final callParams = closure.params
          .map((p) => '${typeEmitter.emit(p.type)} ${p.name}')
          .join(', ');
      _buf.writeln('$callParams) {');
      _indent++;
      final callArgs = closure.params.map((p) => p.name).join(', ');
      final callArgsStr = callArgs.isNotEmpty ? ', $callArgs' : '';
      _buf.writeln('${_pad}return ${closure.envClassName}_call(AnyPtr::fromTypeFunction(this)$callArgsStr);');
      _indent--;
      _buf.writeln('${_pad}}');
    } else {
      _buf.writeln('${_pad}void call() { ${closure.envClassName}_call(this); }');
    }

    // gcMark
    if (closure.capturedFields.isNotEmpty || closure.isAsync) {
      _buf.writeln();
      _buf.writeln('${_pad}void gcMark(int flag) override {');
      _indent++;
      _buf.writeln('${_pad}${closure.isAsync ? "AnyGC" : "TypeFunction"}::gcMark(flag);');
      if (closure.isAsync) {
        _buf.writeln('${_pad}if (_promise) _promise->gcMark(flag);');
      }
      for (final field in closure.capturedFields) {
        if (_isPointerOrGCType(field.type) || field.isBoxed) {
          _buf.writeln('${_pad}if (${field.name}) ${field.name}->gcMark(flag);');
        }
      }
      _indent--;
      _buf.writeln('${_pad}}');
    }

    _indent--;
    _buf.writeln('${_pad}};');
    _buf.writeln();

    // _call 静态函数
    final callTypeArgs = closure.typeParams.isNotEmpty
        ? '<${closure.typeParams.map((t) => t.name).join(', ')}>'
        : '';
    _buf.write('${_pad}${callTemplatePrefix}${typeEmitter.emit(closure.returnType)} ${closure.envClassName}_call(');
    if (closure.isAsync) {
      _buf.write('${closure.envClassName}$callTypeArgs* env');
    } else {
      _buf.write('AnyPtr env__');
    }
    for (final p in closure.params) {
      _buf.write(', ${typeEmitter.emit(p.type)} ${p.name}');
    }
    _buf.writeln(') {');
    _indent++;
    if (!closure.isAsync) {
      _buf.writeln('${_pad}auto env = static_cast<${closure.envClassName}$callTypeArgs*>(env__.toTypeFunction());');
    }
    final bodyStr = stmtEmitter.emit(closure.callBody);
    _buf.write(bodyStr);
    _indent--;
    _buf.writeln('${_pad}}');
    _buf.writeln();

    // _new 构造函数
    _buf.write('${_pad}${callTemplatePrefix}${closure.envClassName}$callTypeArgs* ${closure.envClassName}_new(');
    _buf.write('${closure.envClassName}$callTypeArgs* env_');
    for (final field in closure.capturedFields) {
      final fieldType = field.isBoxed && field.boxType != null
          ? typeEmitter.emit(field.boxType!)
          : typeEmitter.emit(field.type);
      _buf.write(', $fieldType ${field.name}');
    }
    _buf.writeln(') {');
    _indent++;
    for (final field in closure.capturedFields) {
      _buf.writeln('${_pad}env_->${field.name} = ${field.name};');
    }
    if (!closure.isAsync) {
      // Cast function pointer to void* through an intermediate function pointer type
      final retType = typeEmitter.emit(closure.returnType);
      final paramTypes = <String>['AnyPtr'];
      for (final p in closure.params) {
        paramTypes.add(typeEmitter.emit(p.type));
      }
      final funcPtrType = '$retType(*)(${paramTypes.join(', ')})';
      _buf.writeln('${_pad}env_->closureCall = reinterpret_cast<void*>(static_cast<$funcPtrType>(&${closure.envClassName}_call$callTypeArgs));');
    }
    _buf.writeln('${_pad}GC::allocateLocal(env_);');
    _buf.writeln('${_pad}return env_;');
    _indent--;
    _buf.writeln('${_pad}}');
    _buf.writeln();
  }

  /// 发射枚举。
  void emitEnum(IrEnumDecl enumDecl) {
    _buf.write('${_pad}enum class ${enumDecl.name}');
    _buf.writeln(' {');
    _indent++;
    for (var i = 0; i < enumDecl.values.length; i++) {
      final v = enumDecl.values[i];
      _buf.write('${_pad}${v.name}');
      if (i < enumDecl.values.length - 1) {
        _buf.writeln(',');
      } else {
        _buf.writeln('');
      }
    }
    _indent--;
    _buf.writeln('${_pad}};');
    _buf.writeln();
  }

  /// 发射顶层字段。
  void emitTopLevelField(IrTopLevelField field) {
    final typeStr = typeEmitter.emit(field.type);
    _buf.write('${_pad}$typeStr ${field.name}');
    if (field.init != null) {
      _buf.write(' = ${exprEmitter.emit(field.init!)}');
    }
    _buf.writeln(';');
    _buf.writeln();
  }

  void _writeParams(List<IrFuncParam> params) {
    final parts = <String>[];
    for (final p in params) {
      parts.add('${typeEmitter.emit(p.type)} ${p.name}');
    }
    _buf.write(parts.join(', '));
  }

  bool _isPointerOrGCType(IrType type) {
    if (type is IrUserType) return true;
    if (type is IrCollectionType) return true;
    if (type is IrPromiseType) return true;
    if (type is IrFunctionType) return true;
    if (type is IrBoxType) return true;
    return false;
  }
}
