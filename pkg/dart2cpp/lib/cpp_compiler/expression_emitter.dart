/// Dart→C++ 表达式生成器
///
/// 将 Dart Kernel Expression 节点转换为 C++ 表达式字符串。
/// 核心转换：
/// - InstanceInvocation → vptr 派发（reinterpret_cast）
/// - ConstructorInvocation → _new 调用（GC::allocateLocal）
/// - FunctionExpression → ClosureEnv 或 lambda
/// - AwaitExpression → smAwait<T>(expr)
/// - 字面量 → C++ 字面量
///
/// 镜像 `lib/restorer/expression_restorer.dart`。
library;

import 'package:kernel/kernel.dart';
import 'package:kernel/ast.dart';

import 'type_mapper.dart';
import 'class_info_collector.dart';
import 'cpp_emitter.dart';

/// C++ 表达式生成器。
class ExpressionEmitter {
  final CppEmitter emitter;
  final TypeMapper typeMapper;
  final ClassInfo classInfo;

  ExpressionEmitter(this.emitter, this.typeMapper, this.classInfo);

  // ============================================================================
  // 主入口
  // ============================================================================

  /// 将 Expression 转换为 C++ 表达式字符串
  String emit(Expression expr) {
    // ── 字面量 ──
    if (expr is IntLiteral) return _emitIntLiteral(expr);
    if (expr is DoubleLiteral) return _emitDoubleLiteral(expr);
    if (expr is BoolLiteral) return _emitBoolLiteral(expr);
    if (expr is StringLiteral) return _emitStringLiteral(expr);
    if (expr is NullLiteral) return 'AnyPtr()';

    // ── 变量访问 ──
    if (expr is VariableGet) return _emitVariableGet(expr);
    if (expr is VariableSet) return _emitVariableSet(expr);

    // ── 属性访问 ──
    if (expr is InstanceGet) return _emitInstanceGet(expr);
    if (expr is InstanceSet) return _emitInstanceSet(expr);
    if (expr is StaticGet) return _emitStaticGet(expr);
    if (expr is StaticSet) return _emitStaticSet(expr);

    // ── 方法调用 ──
    if (expr is InstanceInvocation) return _emitInstanceInvocation(expr);
    if (expr is StaticInvocation) return _emitStaticInvocation(expr);
    if (expr is ConstructorInvocation) return _emitConstructorInvocation(expr);
    if (expr is DynamicInvocation) return _emitDynamicInvocation(expr);
    if (expr is FunctionInvocation) return _emitFunctionInvocation(expr);
    if (expr is SuperMethodInvocation) return _emitSuperMethodInvocation(expr);

    // ── 闭包 ──
    if (expr is FunctionExpression) return _emitFunctionExpression(expr);

    // ── 逻辑 / 条件 ──
    if (expr is LogicalExpression) return _emitLogicalExpression(expr);
    if (expr is ConditionalExpression) return _emitConditionalExpression(expr);
    if (expr is Not) return '!(${emit(expr.operand)})';

    // ── 字符串拼接 ──
    if (expr is StringConcatenation) return _emitStringConcatenation(expr);

    // ── 类型操作 ──
    if (expr is IsExpression) return _emitIsExpression(expr);
    if (expr is AsExpression) return _emitAsExpression(expr);

    // ── Let / Block ──
    if (expr is Let) return _emitLet(expr);
    if (expr is BlockExpression) return _emitBlockExpression(expr);

    // ── 集合字面量 ──
    if (expr is ListLiteral) return _emitListLiteral(expr);
    if (expr is SetLiteral) return _emitSetLiteral(expr);
    if (expr is MapLiteral) return _emitMapLiteral(expr);

    // ── Throw ──
    if (expr is Throw) return 'throw DartException(${emit(expr.expression)})';

    // ── Await ──
    if (expr is AwaitExpression) return _emitAwaitExpression(expr);

    // ── Constant ──
    if (expr is ConstantExpression) return _emitConstantExpression(expr);

    // ── This ──
    if (expr is ThisExpression) return _emitThisExpression();

    // ── NullCheck ──
    if (expr is NullCheck) return emit(expr.operand);

    // ── Invalid ──
    if (expr is InvalidExpression) return 'AnyPtr()';

    // ── TypeLiteral ──
    if (expr is TypeLiteral) return '"${expr.type.toString()}"';

    // ── LoadLibrary ──
    if (expr is LoadLibrary) return 'AnyPtr()';  // async library load → no-op in C++

    // ── CheckLibraryIsLoaded ──
    if (expr is CheckLibraryIsLoaded) return 'AnyPtr()';  // no-op in C++

    // ── Instantiation ──
    if (expr is Instantiation) {
      final receiver = emit(expr.expression);
      return receiver;  // 泛型实参在C++中已在编译期特化
    }

    // 未识别的表达式类型：输出为注释以便调试，但不中断编译
    return 'AnyPtr() /* unhandled: ${expr.runtimeType} */';
  }

  // ============================================================================
  // 字面量
  // ============================================================================

  String _emitIntLiteral(IntLiteral expr) {
    return expr.value.toString();
  }

  String _emitDoubleLiteral(DoubleLiteral expr) {
    final s = expr.value.toString();
    // 确保有小数点
    if (!s.contains('.') && !s.contains('e') && !s.contains('E')) {
      return '$s.0';
    }
    return s;
  }

  String _emitBoolLiteral(BoolLiteral expr) {
    return expr.value ? 'true' : 'false';
  }

  String _emitStringLiteral(StringLiteral expr) {
    final escaped = _escapeString(expr.value);
    return '"$escaped"';
  }

  String _escapeString(String s) {
    return s
        .replaceAll('\\', '\\\\')
        .replaceAll('"', '\\"')
        .replaceAll('\n', '\\n')
        .replaceAll('\r', '\\r')
        .replaceAll('\t', '\\t');
  }

  // ============================================================================
  // 变量访问
  // ============================================================================

  String _emitVariableGet(VariableGet expr) {
    final variable = expr.variable;
    final name = typeMapper.cleanIdentifier(variable.name ?? '_v');

    // 闭包捕获变量 → env. 前缀
    final envPrefix = emitter.capturedVarEnvPrefix[variable];
    if (envPrefix != null) {
      return '$envPrefix$name';
    }

    // Box 化变量 → .value
    if (emitter.boxedVars.contains(variable)) {
      return '$name->value';
    }

    return name;
  }

  String _emitVariableSet(VariableSet expr) {
    final variable = expr.variable;
    final name = typeMapper.cleanIdentifier(variable.name ?? '_v');
    final value = emit(expr.value);

    // 闭包捕获变量 → env. 前缀
    final envPrefix = emitter.capturedVarEnvPrefix[variable];
    if (envPrefix != null) {
      return '$envPrefix$name = $value';
    }

    // Box 化变量 → .value
    if (emitter.boxedVars.contains(variable)) {
      return '$name->value = $value';
    }

    return '$name = $value';
  }

  // ============================================================================
  // 属性访问
  // ============================================================================

  String _emitInstanceGet(InstanceGet expr) {
    final receiver = emit(expr.receiver);
    final name = expr.name.text;
    final target = expr.interfaceTarget;

    // 使用 interfaceTarget 获取真实的接收者类名
    final receiverClassName = target is Procedure
        ? target.enclosingClass?.name
        : null;

    // 用户类字段/getter 判断
    if (receiverClassName != null &&
        classInfo.userClasses.contains(receiverClassName)) {
      // 检查是否是字段直接访问
      final isField = _isFieldAccess(receiverClassName, name);
      if (isField) {
        // 字段直接访问 → this_->fieldName
        return '$receiver->$name';
      }
      // getter → vptr 派发，使用 interfaceTarget 的真实返回类型
      final retType = target is Procedure
          ? typeMapper.cppType(target.function.returnType)
          : 'AnyPtr';
      final funcPtrType = '$retType(*)(AnyPtr)';
      return 'reinterpret_cast<$funcPtrType>($receiver->vptr["get_$name"])(AnyPtr::fromVPtr($receiver))';
    }

    // 非用户类 → 直接字段访问（如 String.length 等）
    // 也可以是 vptr 派发（如果 target 是 Procedure）
    if (target is Procedure && classInfo.userClasses.contains(target.enclosingClass?.name ?? '')) {
      final retType = typeMapper.cppType(target.function.returnType);
      final funcPtrType = '$retType(*)(AnyPtr)';
      return 'reinterpret_cast<$funcPtrType>($receiver->vptr["get_$name"])(AnyPtr::fromVPtr($receiver))';
    }

    // 默认：直接字段访问
    return '$receiver->$name';
  }

  String _emitInstanceSet(InstanceSet expr) {
    final receiver = emit(expr.receiver);
    final name = expr.name.text;
    final value = emit(expr.value);
    final target = expr.interfaceTarget;

    // 使用 interfaceTarget 获取真实的接收者类名
    final receiverClassName = target is Procedure
        ? target.enclosingClass?.name
        : null;

    if (receiverClassName != null &&
        classInfo.userClasses.contains(receiverClassName)) {
      final isField = _isFieldAccess(receiverClassName, name);
      if (isField) {
        return '$receiver->$name = $value';
      }
      // setter vptr 派发：参数类型从 interfaceTarget 获取
      final paramType = target is Procedure
          ? typeMapper.cppType(target.function.positionalParameters.first.type)
          : 'AnyPtr';
      final wrappedValue = _wrapArgForVptr(value, target is Procedure
          ? target.function.positionalParameters.first.type
          : const DynamicType());
      final funcPtrType = 'void(*)(AnyPtr, $paramType)';
      return 'reinterpret_cast<$funcPtrType>($receiver->vptr["set_$name"])(AnyPtr::fromVPtr($receiver), $wrappedValue)';
    }

    return '$receiver->$name = $value';
  }

  String _emitStaticGet(StaticGet expr) {
    final target = expr.target;
    if (target is Field) {
      final cls = target.enclosingClass;
      if (cls != null) {
        // 用户类静态字段 → ClassName_fieldName
        if (classInfo.userClasses.contains(cls.name)) {
          return '${cls.name}_${typeMapper.cleanIdentifier(target.name.text)}';
        }
        // SDK 类静态字段 → 直接访问
        return '${cls.name}::${typeMapper.cleanIdentifier(target.name.text)}';
      }
      // 顶层字段
      return typeMapper.cleanIdentifier(target.name.text);
    }
    if (target is Procedure) {
      final cls = target.enclosingClass;
      if (cls != null) {
        // 用户类静态方法getter → ClassName_get_methodName()
        if (target.isGetter) {
          return '${cls.name}_get_${target.name.text}';
        }
        return '${cls.name}_${target.name.text}';
      }
      // 顶层getter
      return typeMapper.cleanIdentifier(target.name.text);
    }
    // 其他情况 → target 是 Member（Field/Procedure已处理过，此处为泛用fallback）
    return typeMapper.cleanIdentifier(target.name.text);
  }

  String _emitStaticSet(StaticSet expr) {
    final target = expr.target;
    final value = emit(expr.value);
    if (target is Field) {
      final cls = target.enclosingClass;
      if (cls != null) {
        // 用户类静态字段 → ClassName_fieldName = value
        if (classInfo.userClasses.contains(cls.name)) {
          return '${cls.name}_${typeMapper.cleanIdentifier(target.name.text)} = $value';
        }
        return '${cls.name}::${typeMapper.cleanIdentifier(target.name.text)} = $value';
      }
      // 顶层字段
      return '${typeMapper.cleanIdentifier(target.name.text)} = $value';
    }
    if (target is Procedure) {
      final cls = target.enclosingClass;
      if (cls != null) {
        // 用户类静态setter → ClassName_set_methodName(value)
        if (target.isSetter) {
          return '${cls.name}_set_${target.name.text.substring(0, target.name.text.length - 1)}($value)';
        }
        return '${cls.name}_${target.name.text}($value)';
      }
      return '${typeMapper.cleanIdentifier(target.name.text)}($value)';
    }
    // 其他情况 → target 是 Member（Field/Procedure已处理过，此处为泛用fallback）
    return '${typeMapper.cleanIdentifier(target.name.text)} = $value';
  }

  // ============================================================================
  // 方法调用
  // ============================================================================

  String _emitInstanceInvocation(InstanceInvocation expr) {
    final receiver = emit(expr.receiver);
    final methodName = expr.interfaceTarget.name.text;
    final target = expr.interfaceTarget;

    // 运算符
    if (TypeMapper.isOperatorName(methodName)) {
      return _emitOperatorInvocation(expr, receiver, methodName);
    }

    // 使用 interfaceTarget 获取真实的函数签名
    final retType = typeMapper.cppType(target.function.returnType);
    final positionalParams = target.function.positionalParameters;
    final requiredCount = target.function.requiredParameterCount;

    // 构建 C++ 参数类型列表（不含 this）
    final cppParamTypes = <String>[];
    for (var i = 0; i < requiredCount; i++) {
      cppParamTypes.add(typeMapper.cppType(positionalParams[i].type));
    }
    // named 参数展平为 positional
    for (final named in target.function.namedParameters) {
      cppParamTypes.add(typeMapper.cppType(named.type));
    }

    final paramTypesStr = cppParamTypes.join(', ');
    final funcPtrType = retType == 'void'
        ? 'void(*)(AnyPtr${paramTypesStr.isNotEmpty ? ', $paramTypesStr' : ''})'
        : '$retType(*)(AnyPtr${paramTypesStr.isNotEmpty ? ', $paramTypesStr' : ''})';

    // 构建 C++ 调用参数列表（包装 AnyPtr）
    final callArgs = <String>[];
    // positional args
    final positionalArgs = expr.arguments.positional;
    for (var i = 0; i < positionalArgs.length && i < requiredCount; i++) {
      final argExpr = emit(positionalArgs[i]);
      final paramType = i < positionalParams.length
          ? positionalParams[i].type
          : const DynamicType();
      callArgs.add(_wrapArgForVptr(argExpr, paramType));
    }
    // named args → positional（按 interfaceTarget 的 namedParameters 顺序）
    for (final namedArg in expr.arguments.named) {
      final argExpr = emit(namedArg.value);
      final namedParam = positionalParams.length > requiredCount
          ? const DynamicType()
          : target.function.namedParameters
              .where((p) => p.name == namedArg.name)
              .firstOrNull?.type ?? const DynamicType();
      callArgs.add(_wrapArgForVptr(argExpr, namedParam));
    }

    final callArgsStr = callArgs.join(', ');

    // 检查方法级泛型特化
    final methodArgs = expr.arguments.types;
    if (methodArgs.isNotEmpty) {
      final suffix = methodArgs
          .map((ta) => typeMapper.typeToSpecSuffix(ta))
          .join('_');
      if (suffix.isNotEmpty) {
        return 'reinterpret_cast<$funcPtrType>($receiver->vptr["${methodName}_$suffix"])(AnyPtr::fromVPtr($receiver)${callArgsStr.isNotEmpty ? ', $callArgsStr' : ''})';
      }
    }

    return 'reinterpret_cast<$funcPtrType>($receiver->vptr["$methodName"])(AnyPtr::fromVPtr($receiver)${callArgsStr.isNotEmpty ? ', $callArgsStr' : ''})';
  }

  String _emitOperatorInvocation(
      InstanceInvocation expr, String receiver, String op) {
    final vptrKey = TypeMapper.operatorVptrKey(op);
    final target = expr.interfaceTarget;

    // 使用 interfaceTarget 获取真实的函数签名
    final retType = typeMapper.cppType(target.function.returnType);
    final positionalParams = target.function.positionalParameters;
    final cppParamTypes = positionalParams
        .map((p) => typeMapper.cppType(p.type))
        .toList();
    final paramTypesStr = cppParamTypes.join(', ');
    final funcPtrType = '$retType(*)(AnyPtr${paramTypesStr.isNotEmpty ? ', $paramTypesStr' : ''})';

    // 包装调用参数
    final callArgs = <String>[];
    for (var i = 0; i < expr.arguments.positional.length; i++) {
      final argExpr = emit(expr.arguments.positional[i]);
      final paramType = i < positionalParams.length
          ? positionalParams[i].type
          : const DynamicType();
      callArgs.add(_wrapArgForVptr(argExpr, paramType));
    }
    final callArgsStr = callArgs.join(', ');

    return 'reinterpret_cast<$funcPtrType>($receiver->vptr["$vptrKey"])(AnyPtr::fromVPtr($receiver)${callArgsStr.isNotEmpty ? ', $callArgsStr' : ''})';
  }

  String _emitStaticInvocation(StaticInvocation expr) {
    final target = expr.target;
    final name = target.name.text;

    // print → staticPrint（支持不同参数类型的重载）
    if (name == 'print') {
      final arg = expr.arguments.positional.isNotEmpty
          ? emit(expr.arguments.positional.first)
          : '""';
      // staticPrint 有 AnyPtr/int64_t/double/bool/std::string 重载
      // AnyPtr::fromAuto 会根据值类型自动匹配
      return 'staticPrint(AnyPtr::fromAuto($arg))';
    }

    // 用户类的静态方法 → ClassName_methodName(args)
    final enclosingClass = target.enclosingClass;
    if (enclosingClass != null) {
      final className = enclosingClass.name;
      String funcName;
      if (target.isGetter) {
        funcName = '${className}_get_${target.name.text}';
      } else if (target.isSetter) {
        funcName = '${className}_set_${target.name.text}';
      } else {
        funcName = '${className}_${target.name.text}';
      }
      final args = _emitArgs(expr.arguments);
      return '$funcName($args)';
    }

    // 顶层函数
    final args = _emitArgs(expr.arguments);
    return '${typeMapper.cleanIdentifier(name)}($args)';
  }

  String _emitConstructorInvocation(ConstructorInvocation expr) {
    final cls = expr.target.enclosingClass;
    final className = cls.name;

    // 确定构造函数名
    String ctorName;
    if (expr.target.name.text.isEmpty) {
      ctorName = '${className}_new';
    } else {
      ctorName = '${className}_new_${typeMapper.cleanIdentifier(expr.target.name.text)}';
    }

    // 构建参数列表：GC::allocateLocal(new XValue()) 后面跟构造参数
    // positional args 直接传递
    // named args 按构造函数签名顺序展平为 positional
    final positionalArgs = expr.arguments.positional;
    final namedArgs = expr.arguments.named;

    final callParts = <String>[];
    for (final arg in positionalArgs) {
      callParts.add(emit(arg));
    }
    for (final named in namedArgs) {
      callParts.add(emit(named.value));
    }
    final callArgsStr = callParts.join(', ');

    return '$ctorName(GC::allocateLocal(new ${className}Value())${callArgsStr.isNotEmpty ? ', $callArgsStr' : ''})';
  }

  String _emitDynamicInvocation(DynamicInvocation expr) {
    final receiver = emit(expr.receiver);
    final name = expr.name.text;
    final args = _emitArgs(expr.arguments);

    // 动态调用 → 通过 AnyPtr 的 vptr 派发（退化为 AnyPtr 签名）
    final funcPtrType = 'AnyPtr(*)(AnyPtr${args.isNotEmpty ? ', AnyPtr' : ''})';
    final wrappedArgs = <String>[];
    for (final a in expr.arguments.positional) {
      wrappedArgs.add('AnyPtr::fromAuto(${emit(a)})');
    }
    for (final n in expr.arguments.named) {
      wrappedArgs.add('AnyPtr::fromAuto(${emit(n.value)})');
    }
    final wrappedArgsStr = wrappedArgs.join(', ');
    return 'reinterpret_cast<$funcPtrType>($receiver.toVPtr()->vptr["$name"])(AnyPtr::fromVPtr($receiver)${wrappedArgsStr.isNotEmpty ? ', $wrappedArgsStr' : ''})';
  }

  String _emitFunctionInvocation(FunctionInvocation expr) {
    final receiver = emit(expr.receiver);
    final args = _emitArgs(expr.arguments);

    // TypeFunction 调用 → call(args)
    // 闭包调用 → closureCall 派发
    final argList = args.isNotEmpty ? ', $args' : '';
    return '$receiver->call(AnyPtr::fromAuto($receiver)$argList)';
  }

  String _emitSuperMethodInvocation(SuperMethodInvocation expr) {
    final methodName = expr.interfaceTarget.name.text;
    final target = expr.interfaceTarget;
    final declaringClass = target.enclosingClass?.name ?? 'Parent';

    // 构建调用参数：this__ + 其他参数
    final callArgs = <String>['AnyPtr::fromVPtr(this_)'];
    for (final a in expr.arguments.positional) {
      callArgs.add(emit(a));
    }
    for (final n in expr.arguments.named) {
      callArgs.add(emit(n.value));
    }
    final callArgsStr = callArgs.join(', ');

    if (TypeMapper.isOperatorName(methodName)) {
      final suffix = TypeMapper.operatorCppSuffix(methodName);
      return '${declaringClass}_operator$suffix($callArgsStr)';
    }

    return '${declaringClass}_$methodName($callArgsStr)';
  }

  // ============================================================================
  // 闭包
  // ============================================================================

  String _emitFunctionExpression(FunctionExpression expr) {
    final func = expr.function;
    final contextName = emitter.closureContextStack.isNotEmpty
        ? emitter.closureContextStack.last
        : 'lambda';

    // 使用闭包生成器
    return emitter.closureEmitter.emitClosure(func, contextName);
  }

  // ============================================================================
  // 逻辑 / 条件
  // ============================================================================

  String _emitLogicalExpression(LogicalExpression expr) {
    final left = emit(expr.left);
    final right = emit(expr.right);
    final op = expr.operatorEnum == LogicalExpressionOperator.AND ? '&&' : '||';
    return '($left $op $right)';
  }

  String _emitConditionalExpression(ConditionalExpression expr) {
    final cond = emit(expr.condition);
    final then = emit(expr.then);
    final otherwise = emit(expr.otherwise);
    return '($cond ? $then : $otherwise)';
  }

  // ============================================================================
  // 字符串拼接
  // ============================================================================

  String _emitStringConcatenation(StringConcatenation expr) {
    if (expr.expressions.isEmpty) return '""';

    final parts = expr.expressions.map((e) {
      final s = emit(e);
      // 非字符串类型需要转字符串
      return s;
    }).toList();

    return 'dart_str(${parts.join(', ')})';
  }

  // ============================================================================
  // 类型操作
  // ============================================================================

  String _emitIsExpression(IsExpression expr) {
    final operand = emit(expr.operand);
    final cppType = typeMapper.cppType(expr.type);
    return 'dart_is<$cppType>($operand)';
  }

  String _emitAsExpression(AsExpression expr) {
    final operand = emit(expr.operand);
    final cppType = typeMapper.cppType(expr.type);
    return 'dart_cast<$cppType>($operand)';
  }

  // ============================================================================
  // Let / Block
  // ============================================================================

  String _emitLet(Let expr) {
    final varName = typeMapper.cleanIdentifier(expr.variable.name ?? '_v');
    final init = emit(expr.variable.initializer!);
    final body = emit(expr.body);
    return '([&]() { auto $varName = $init; return $body; })()';
  }

  String _emitBlockExpression(BlockExpression expr) {
    // BlockExpression: 先执行body中的语句，最后返回value
    // 在表达式上下文中无法直接写语句，所以需要用IIFE(lambda)包装
    // 但由于emitter.writeLine直接写入全局缓冲区而非返回字符串，
    // BlockExpression中的语句已经被外层的StatementEmitter处理了
    // （BlockExpression通常出现在Let/Block等语句上下文中）
    // 这里只需返回最终value的表达式
    return emit(expr.value);
  }

  // ============================================================================
  // 集合字面量
  // ============================================================================

  String _emitListLiteral(ListLiteral expr) {
    if (expr.expressions.isEmpty) {
      return 'StaticList<AnyPtr>::empty()';
    }
    final elements = expr.expressions.map((e) => emit(e)).join(', ');
    return 'StaticList<AnyPtr>::of({$elements})';
  }

  String _emitSetLiteral(SetLiteral expr) {
    if (expr.expressions.isEmpty) {
      return 'StaticSet<AnyPtr>::empty()';
    }
    final elements = expr.expressions.map((e) => emit(e)).join(', ');
    return 'StaticSet<AnyPtr>::of({$elements})';
  }

  String _emitMapLiteral(MapLiteral expr) {
    if (expr.entries.isEmpty) {
      return 'StaticMap<AnyPtr, AnyPtr>::empty()';
    }
    final entries = expr.entries.map((e) {
      final key = emit(e.key);
      final value = emit(e.value);
      return 'StaticMapEntry<AnyPtr, AnyPtr>($key, $value)';
    }).join(', ');
    return 'StaticMap<AnyPtr, AnyPtr>::of({$entries})';
  }

  // ============================================================================
  // Await
  // ============================================================================

  String _emitAwaitExpression(AwaitExpression expr) {
    final operand = emit(expr.operand);
    final innerType = emitter.asyncInnerReturnType;
    return 'smAwait<$innerType>($operand)';
  }

  // ============================================================================
  // Constant
  // ============================================================================

  String _emitConstantExpression(ConstantExpression expr) {
    return _emitConstant(expr.constant);
  }

  String _emitConstant(Constant constant) {
    if (constant is IntConstant) return constant.value.toString();
    if (constant is DoubleConstant) return constant.value.toString();
    if (constant is BoolConstant) return constant.value ? 'true' : 'false';
    if (constant is StringConstant) return '"${_escapeString(constant.value)}"';
    if (constant is NullConstant) return 'AnyPtr()';
    if (constant is ListConstant) {
      if (constant.entries.isEmpty) return 'StaticList<AnyPtr>::empty()';
      final elements = constant.entries.map((e) => _emitConstant(e)).join(', ');
      return 'StaticList<AnyPtr>::of({$elements})';
    }
    if (constant is SetConstant) {
      if (constant.entries.isEmpty) return 'StaticSet<AnyPtr>::empty()';
      final elements = constant.entries.map((e) => _emitConstant(e)).join(', ');
      return 'StaticSet<AnyPtr>::of({$elements})';
    }
    if (constant is MapConstant) {
      if (constant.entries.isEmpty) return 'StaticMap<AnyPtr, AnyPtr>::empty()';
      return 'StaticMap<AnyPtr, AnyPtr>::empty()';
    }
    if (constant is InstanceConstant) {
      return emitter.constantEmitter.emit(constant);
    }
    return 'AnyPtr()';
  }

  // ============================================================================
  // This
  // ============================================================================

  String _emitThisExpression() {
    if (emitter.thisIsCapturedInEnv) {
      return 'env->this_';
    }
    return emitter.thisReplacementName;
  }

  // ============================================================================
  // 辅助方法
  // ============================================================================

  /// 构建 C++ 调用参数列表（不包装 AnyPtr，直接传递表达式）
  String _emitArgs(Arguments args) {
    final parts = <String>[];
    for (final a in args.positional) {
      parts.add(emit(a));
    }
    for (final n in args.named) {
      parts.add(emit(n.value));
    }
    return parts.join(', ');
  }

  /// 为 vptr 派发包装参数：
  /// - 用户类指针 → AnyPtr::fromVPtr(expr)
  /// - 基础值类型(int/double/bool/String) → 直接传递（静态函数参数就是原始类型）
  /// - dynamic/AnyPtr → 直接传递
  /// - 集合类型指针 → AnyPtr::fromGC(expr)
  String _wrapArgForVptr(String expr, DartType paramType) {
    if (paramType is InterfaceType) {
      final name = paramType.classNode.name;
      // 基础值类型 → 直接传递（静态函数参数已经是原始类型）
      if (const {'int', 'double', 'bool', 'String'}.contains(name)) {
        return expr;
      }
      // 用户类 → fromVPtr
      if (classInfo.userClasses.contains(name)) {
        return 'AnyPtr::fromVPtr($expr)';
      }
      // 集合类型 → fromGC
      if (_isCollectionType(name)) {
        return expr; // 集合指针本身就是 AnyGC*
      }
    }
    // dynamic → 已经是 AnyPtr
    if (paramType is DynamicType) return expr;
    // TypeParameter → 可能是值类型也可能是指针，用 fromAuto 安全包装
    if (paramType is TypeParameterType) return expr;
    // 其他 → 直接传递
    return expr;
  }

  /// 判断是否是集合类型名称
  bool _isCollectionType(String name) {
    return const {
      'List', '_GrowableList', '_List', '_ImmutableList',
      'Map', '_Map', 'LinkedHashMap', '_InternalLinkedHashMap',
      'Set', '_Set', 'LinkedHashSet', '_CompactLinkedHashSet',
      'Future', '_Future',
    }.contains(name);
  }

  bool _isFieldAccess(String className, String fieldName) {
    final cls = classInfo.classNodes[className];
    if (cls == null) return false;
    // 递归查找字段（含继承链）
    return _hasFieldInClassChain(cls, fieldName);
  }

  /// 在类继承链中查找字段
  bool _hasFieldInClassChain(Class cls, String fieldName) {
    for (final f in cls.fields) {
      if (f.name.text == fieldName && !f.isStatic) return true;
    }
    // 检查父类
    if (cls.supertype != null) {
      final superClass = cls.supertype!.classNode;
      if (superClass.name != 'Object' && superClass.name != '_Enum') {
        return _hasFieldInClassChain(superClass, fieldName);
      }
    }
    return false;
  }

}
