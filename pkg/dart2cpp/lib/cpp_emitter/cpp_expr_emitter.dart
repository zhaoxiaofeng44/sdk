/// C++ 表达式发射器 — 将 IR 表达式节点转为 C++ 表达式字符串。
library cpp_expr_emitter;

import 'package:dart2cpp/ir/ir_nodes.dart';
import 'package:dart2cpp/shared/analysis_context.dart';
import 'cpp_type_emitter.dart';

/// C++ 表达式发射器。
class CppExprEmitter {
  final AnalysisContext ctx;
  final CppTypeEmitter typeEmitter;

  CppExprEmitter(this.ctx, this.typeEmitter);

  /// 将 IR 表达式转为 C++ 表达式字符串。
  String emit(IrExpression expr) {
    if (expr is IrIntLiteral) return '${expr.value}';
    if (expr is IrDoubleLiteral) {
      var s = '${expr.value}';
      if (!s.contains('.')) s = '$s.0';
      return s;
    }
    if (expr is IrBoolLiteral) return '${expr.value}';
    if (expr is IrStringLiteral) return '"${_escapeString(expr.value)}"';
    if (expr is IrNullLiteral) return 'AnyPtr()';
    if (expr is IrSymbolLiteral) return '"${expr.name}"';
    if (expr is IrTypeLiteral) return '"${typeEmitter.emit(expr.type)}"';

    if (expr is IrStringConcat) {
      final parts = expr.parts.map((p) {
        if (p is IrStringLiteral) return '"${_escapeString(p.value)}"';
        return 'dart_str(${emit(p)})';
      }).join(' + ');
      return parts;
    }

    if (expr is IrVariableGet) {
      final prefix = expr.envPrefix ?? '';
      final arrowOrDot = prefix.contains('env') ? '->' : '.';
      final name = prefix.isNotEmpty ? '$prefix$arrowOrDot${expr.name}' : expr.name;
      if (expr.isBoxed) return '$name->value';
      return name;
    }

    if (expr is IrVariableSet) {
      final prefix = expr.envPrefix ?? '';
      final arrowOrDot = prefix.contains('env') ? '->' : '.';
      final name = prefix.isNotEmpty ? '$prefix$arrowOrDot${expr.name}' : expr.name;
      if (expr.isBoxed) {
        return '$name->value = ${emit(expr.value)}';
      }
      return '$name = ${emit(expr.value)}';
    }

    if (expr is IrVptrDispatch) return _emitVptrDispatch(expr);
    if (expr is IrStaticCall) return _emitStaticCall(expr);
    if (expr is IrDynamicCall) {
      return _emitDynamicCall(expr);
    }
    if (expr is IrFunctionInvocation) {
      // Check if the target is a TypeFunction - if so, use ->call() method
      final targetType = expr.target.resultType;
      if (targetType is IrFunctionType) {
        return '${emit(expr.target)}->call(${expr.args.map(emit).join(', ')})';
      }
      return '${emit(expr.target)}(${expr.args.map(emit).join(', ')})';
    }

    if (expr is IrConstructorCall) return _emitConstructorCall(expr);

    if (expr is IrFieldGet) {
      if (expr.isEnumGetter && expr.enumGetterFuncName != null) {
        return '${expr.enumGetterFuncName}(${emit(expr.receiver)})';
      }
      // Special handling for String properties
      if (_isStringType(expr.receiver.resultType)) {
        final receiverStr = emit(expr.receiver);
        // If the receiver is a nullable string (AnyPtr), convert it to std::string first
        if (expr.receiver.resultType is IrNullableType) {
          return _emitStringProperty('$receiverStr.toStringValue()', expr.fieldName);
        }
        return _emitStringProperty(receiverStr, expr.fieldName);
      }
      // Special handling for StaticList properties that are methods in C++
      if (_isStaticListType(expr.receiver.resultType)) {
        final receiverStr = emit(expr.receiver);
        // reversed is a method in C++, not a property
        if (expr.fieldName == 'reversed') {
          return '$receiverStr->reversed()';
        }
        // first and last are properties in C++
        if (expr.fieldName == 'first' || expr.fieldName == 'last') {
          return '$receiverStr->${expr.fieldName}()';
        }
        return _emitStaticListMethod(receiverStr, expr.fieldName, []);
      }
      // Check if receiver is a value type (not a pointer)
      final receiverType = expr.receiver.resultType;
      if (_isValueType(receiverType)) {
        return '${emit(expr.receiver)}.${expr.fieldName}';
      }
      return '${emit(expr.receiver)}->${expr.fieldName}';
    }
    if (expr is IrFieldSet) {
      return '${emit(expr.receiver)}->${expr.fieldName} = ${emit(expr.value)}';
    }
    if (expr is IrStaticFieldSet) {
      return '${expr.className}_${expr.fieldName} = ${emit(expr.value)}';
    }

    if (expr is IrClosureExpr) return _emitClosureExpr(expr);

    if (expr is IrListLiteral) {
      final innerType = expr.typeArgs.isNotEmpty
          ? typeEmitter.emit(expr.typeArgs.first)
          : 'AnyPtr';
      return 'StaticList<$innerType>::of({${expr.elements.map(emit).join(', ')}})';
    }
    if (expr is IrMapLiteral) {
      final kType = expr.typeArgs.length > 0 ? typeEmitter.emit(expr.typeArgs[0]) : 'AnyPtr';
      final vType = expr.typeArgs.length > 1 ? typeEmitter.emit(expr.typeArgs[1]) : 'AnyPtr';
      final entries = expr.entries.map((e) =>
          'StaticMapEntry<$kType, $vType>(${emit(e.key)}, ${emit(e.value)})').join(', ');
      return 'StaticMap<$kType, $vType>::of({$entries})';
    }
    if (expr is IrSetLiteral) {
      final innerType = expr.typeArgs.isNotEmpty
          ? typeEmitter.emit(expr.typeArgs.first)
          : 'AnyPtr';
      return 'StaticSet<$innerType>::of({${expr.elements.map(emit).join(', ')}})';
    }

    if (expr is IrConditional) {
      final condStr = emit(expr.condition);
      var thenStr = emit(expr.thenExpr);
      var elseStr = emit(expr.elseExpr);

      // If one branch is AnyPtr and the other is a primitive type, wrap the primitive
      final thenType = expr.thenExpr.resultType;
      final elseType = expr.elseExpr.resultType;

      // Check if thenExpr is AnyPtr (either by type or by emitted string)
      final thenIsAnyPtr = thenType is IrAnyPtrType ||
          thenType is IrDynamicType ||
          thenStr == 'AnyPtr()' ||
          (expr.thenExpr is IrConstructorCall && (expr.thenExpr as IrConstructorCall).className == 'AnyPtr') ||
          (expr.thenExpr is IrVariableGet && (thenType is IrAnyPtrType || thenType is IrDynamicType || thenType == null));

      // Check if elseExpr is AnyPtr
      final elseIsAnyPtr = elseType is IrAnyPtrType ||
          elseType is IrDynamicType ||
          elseStr == 'AnyPtr()' ||
          (expr.elseExpr is IrConstructorCall && (expr.elseExpr as IrConstructorCall).className == 'AnyPtr') ||
          (expr.elseExpr is IrVariableGet && (elseType is IrAnyPtrType || elseType is IrDynamicType || elseType == null));

      // Also check by pattern: if one branch is a simple integer and the other is a variable, wrap the integer
      final thenIsSimpleInt = thenStr == '0' || RegExp(r'^-?\d+$').hasMatch(thenStr);
      final elseIsSimpleInt = elseStr == '0' || RegExp(r'^-?\d+$').hasMatch(elseStr);
      final thenIsVariable = RegExp(r'^[a-zA-Z_][a-zA-Z0-9_]*$').hasMatch(thenStr);
      final elseIsVariable = RegExp(r'^[a-zA-Z_][a-zA-Z0-9_]*$').hasMatch(elseStr);

      if (thenIsAnyPtr && elseType is IrPrimitiveType) {
        elseStr = _wrapInAnyPtr(elseStr, elseType);
      } else if (elseIsAnyPtr && thenType is IrPrimitiveType) {
        thenStr = _wrapInAnyPtr(thenStr, thenType);
      } else if ((thenIsAnyPtr || elseIsVariable) && thenIsSimpleInt) {
        // If one branch is AnyPtr/variable and the other is a simple integer, wrap the integer
        thenStr = 'AnyPtr::fromInt($thenStr)';
      } else if ((elseIsAnyPtr || thenIsVariable) && elseIsSimpleInt) {
        elseStr = 'AnyPtr::fromInt($elseStr)';
      }

      return '($condStr ? $thenStr : $elseStr)';
    }
    if (expr is IrLogicalExpr) {
      final op = expr.op == LogicalOp.and ? '&&' : '||';
      return '(${emit(expr.left)} $op ${emit(expr.right)})';
    }
    if (expr is IrNotExpr) return '!(${emit(expr.operand)})';
    if (expr is IrThrowExpr) return 'throw ${emit(expr.exception)}';
    if (expr is IrRethrowExpr) return 'throw';
    if (expr is IrAwaitExpr) return 'smAwait<${typeEmitter.emit(expr.innerType)}>(${emit(expr.operand)})';

    if (expr is IrIsCheck) {
      return 'dart_is<${typeEmitter.emit(expr.checkType)}>(${emit(expr.operand)})';
    }
    if (expr is IrCastExpr) {
      return 'dart_cast<${typeEmitter.emit(expr.castType)}>(${emit(expr.operand)})';
    }
    if (expr is IrNullCheck) return '${emit(expr.operand)}';

    if (expr is IrLetExpr) {
      return '([&]() { auto ${expr.varName} = ${emit(expr.init)}; return ${emit(expr.body)}; })()';
    }

    if (expr is IrThisExpr) {
      if (expr.inClosureEnv) return 'env->this_';
      return expr.replacementName;
    }
    if (expr is IrSuperCall) {
      return '${expr.staticFuncName}(AnyPtr::fromVPtr(this_), ${expr.args.map(emit).join(', ')})';
    }
    if (expr is IrSuperFieldGet) return 'this_->${expr.fieldName}';
    if (expr is IrSuperFieldSet) {
      return 'this_->${expr.fieldName} = ${emit(expr.value)}';
    }

    if (expr is IrRecordLiteral) {
      // Records map to AnyPtr in C++
      return 'AnyPtr()';
    }
    if (expr is IrRecordGet) {
      return '${emit(expr.receiver)}';
    }

    if (expr is IrTearOff) return expr.staticFuncName;

    if (expr is IrBlockExpr) {
      final parts = <String>[];
      for (final s in expr.statements) {
        if (s is IrVarDecl) {
          parts.add('auto ${s.name} = ${emit(s.init ?? const IrNullLiteral())}');
        }
      }
      if (expr.result != null) {
        parts.add('return ${emit(expr.result!)}');
      }
      return '([&]() { ${parts.join('; ')}; })()';
    }

    if (expr is IrEqualsNull) return '(${emit(expr.operand)} == AnyPtr())';
    if (expr is IrEqualsCall) {
      return '(${emit(expr.left)} == ${emit(expr.right)})';
    }

    if (expr is IrNativeOpExpr) return _emitNativeOp(expr);

    if (expr is IrRawCode) return expr.cppCode;

    return '/* unknown expr: ${expr.runtimeType} */';
  }

  String _emitVptrDispatch(IrVptrDispatch expr) {
    // 私有方法直接调用
    if (expr.isPrivateDirectCall && expr.directStaticFuncName != null) {
      final args = <String>['AnyPtr::fromVPtr(${emit(expr.receiver)})'];
      for (var i = 0; i < expr.args.length; i++) {
        final a = expr.args[i];
        final argType = i < expr.paramTypes.length - 1 ? expr.paramTypes[i + 1] : null;
        args.add(_wrapArgForAnyPtr(emit(a), a.resultType ?? argType));
      }
      return '${expr.directStaticFuncName}(${args.join(', ')})';
    }

    // 泛型特化
    var vptrKey = expr.vptrKey;
    if (expr.specializationSuffix != null) {
      vptrKey = '${expr.vptrKey}_${expr.specializationSuffix}';
    }

    // 构建函数指针类型
    final retType = typeEmitter.emit(expr.returnType);
    final paramTypeStrs = <String>['AnyPtr'];
    for (final p in expr.paramTypes.skip(1)) {
      paramTypeStrs.add(typeEmitter.emit(p));
    }
    final funcPtrType = '$retType(*)(${paramTypeStrs.join(', ')})';

    // 构建参数 — 第一个参数用 AnyPtr::fromVPtr 包装
    final args = <String>['AnyPtr::fromVPtr(${emit(expr.receiver)})'];
    for (var i = 0; i < expr.args.length; i++) {
      final a = expr.args[i];
      final argType = i < expr.paramTypes.length - 1 ? expr.paramTypes[i + 1] : null;
      args.add(_wrapArgForAnyPtr(emit(a), a.resultType ?? argType));
    }

    return 'reinterpret_cast<$funcPtrType>(${emit(expr.receiver)}->vptr["$vptrKey"])(${args.join(', ')})';
  }

  /// Wrap an argument in AnyPtr based on its type
  String _wrapArgForAnyPtr(String argStr, IrType? type) {
    if (type == null) return argStr;
    if (type is IrPrimitiveType) {
      switch (type.kind) {
        case PrimitiveKind.int_:
          return 'AnyPtr::fromInt($argStr)';
        case PrimitiveKind.double_:
          return 'AnyPtr::fromDouble($argStr)';
        case PrimitiveKind.bool_:
          return 'AnyPtr::fromBool($argStr)';
        case PrimitiveKind.string_:
          return 'AnyPtr::fromString($argStr)';
      }
    }
    if (type is IrDynamicType || type is IrAnyPtrType) {
      return argStr; // Already AnyPtr
    }
    if (type is IrUserType || type is IrCollectionType || type is IrPromiseType) {
      return 'AnyPtr::fromGC($argStr)';
    }
    if (type is IrFunctionType) {
      return 'AnyPtr::fromTypeFunction($argStr)';
    }
    // Default: assume it's already AnyPtr or needs no wrapping
    return argStr;
  }

  String _emitDynamicCall(IrDynamicCall expr) {
    final receiver = emit(expr.receiver);
    final method = expr.methodName;
    final args = expr.args.map(emit).join(', ');

    // Special handling for String methods
    if (_isStringType(expr.receiver.resultType)) {
      return _emitStringMethod(receiver, method, expr.args);
    }

    // Special handling for StaticList properties and methods
    if (_isStaticListType(expr.receiver.resultType)) {
      return _emitStaticListMethod(receiver, method, expr.args);
    }

    // Default: use dot notation
    return '$receiver.$method($args)';
  }

  bool _isStringType(IrType? type) {
    if (type is IrPrimitiveType && type.kind == PrimitiveKind.string_) {
      return true;
    }
    // Handle nullable string types
    if (type is IrNullableType) {
      return _isStringType(type.inner);
    }
    return false;
  }

  bool _isValueType(IrType? type) {
    if (type == null) return false;
    // Primitive types are value types (int, double, bool, string)
    if (type is IrPrimitiveType) return true;
    // MapEntry is a value type (not a pointer)
    if (type is IrUserType && type.className.contains('MapEntry')) return true;
    return false;
  }

  /// Wrap a primitive type value in AnyPtr::fromX()
  String _wrapInAnyPtr(String exprStr, IrType type) {
    if (type is IrPrimitiveType) {
      switch (type.kind) {
        case PrimitiveKind.int_:
          return 'AnyPtr::fromInt($exprStr)';
        case PrimitiveKind.double_:
          return 'AnyPtr::fromDouble($exprStr)';
        case PrimitiveKind.bool_:
          return 'AnyPtr::fromBool($exprStr)';
        case PrimitiveKind.string_:
          return 'AnyPtr::fromString($exprStr)';
      }
    }
    return exprStr;
  }

  bool _isStaticListType(IrType? type) {
    if (type is IrCollectionType && type.kind == CollectionKind.list) {
      return true;
    }
    return false;
  }

  String _emitStaticListMethod(String receiver, String method, List<IrExpression> args) {
    // Special handling for 'reversed' property
    if (method == 'reversed' && args.isEmpty) {
      return '$receiver->reversed()';
    }

    // Special handling for 'join' method
    if (method == 'join') {
      if (args.isEmpty) {
        return '$receiver->join()';
      } else if (args.length == 1) {
        final separator = emit(args[0]);
        return '$receiver->join($separator)';
      }
    }

    // Default: use arrow notation for pointer types
    final argsStr = args.map(emit).join(', ');
    return '$receiver->$method($argsStr)';
  }

  String _emitStringProperty(String receiver, String property) {
    switch (property) {
      case 'isEmpty':
        return '$receiver.empty()';
      case 'isNotEmpty':
        return '!$receiver.empty()';
      case 'length':
        return 'static_cast<int64_t>($receiver.length())';
      default:
        // Fallback: use dot notation
        return '$receiver.$property';
    }
  }

  String _emitStringMethod(String receiver, String method, List<IrExpression> args) {
    switch (method) {
      case 'isEmpty':
        return '$receiver.empty()';
      case 'length':
        return '$receiver.length()';
      case 'startsWith':
        if (args.length == 1) {
          final prefix = emit(args[0]);
          return '($receiver.find($prefix) == 0)';
        }
        break;
      case 'endsWith':
        if (args.length == 1) {
          final suffix = emit(args[0]);
          return '($receiver.length() >= $suffix.length() && $receiver.compare($receiver.length() - $suffix.length(), $suffix.length(), $suffix) == 0)';
        }
        break;
      case 'contains':
        if (args.length == 1) {
          final substr = emit(args[0]);
          return '($receiver.find($substr) != std::string::npos)';
        }
        break;
      case 'substring':
        if (args.length == 1) {
          final start = emit(args[0]);
          return '$receiver.substr($start)';
        } else if (args.length == 2) {
          final start = emit(args[0]);
          final end = emit(args[1]);
          return '$receiver.substr($start, $end - $start)';
        }
        break;
      case 'toUpperCase':
        return 'dart_str_toUpper($receiver)';
      case 'toLowerCase':
        return 'dart_str_toLower($receiver)';
      case 'trim':
        return 'dart_str_trim($receiver)';
      case 'trimLeft':
        return 'dart_str_trimLeft($receiver)';
      case 'trimRight':
        return 'dart_str_trimRight($receiver)';
      case 'split':
        if (args.length == 1) {
          final delimiter = emit(args[0]);
          return 'dart_str_split($receiver, $delimiter)';
        }
        break;
      case 'replaceAll':
        if (args.length == 2) {
          final from = emit(args[0]);
          final to = emit(args[1]);
          return 'dart_str_replaceAll($receiver, $from, $to)';
        }
        break;
      case 'indexOf':
        if (args.length == 1) {
          final substr = emit(args[0]);
          return '$receiver.find($substr)';
        } else if (args.length == 2) {
          final substr = emit(args[0]);
          final start = emit(args[1]);
          return '$receiver.find($substr, $start)';
        }
        break;
      case 'padLeft':
        if (args.length == 2) {
          final width = emit(args[0]);
          final padding = emit(args[1]);
          return 'dart_str_padLeft($receiver, $width, $padding)';
        }
        break;
      case 'padRight':
        if (args.length == 2) {
          final width = emit(args[0]);
          final padding = emit(args[1]);
          return 'dart_str_padRight($receiver, $width, $padding)';
        }
        break;
      case 'toStringAsFixed':
        if (args.length == 1) {
          final digits = emit(args[0]);
          return 'dart_str_toStringAsFixed($receiver, $digits)';
        }
        break;
    }

    // Fallback: use dot notation
    final argsStr = args.map(emit).join(', ');
    return '$receiver.$method($argsStr)';
  }

  String _emitStaticCall(IrStaticCall expr) {
    final typeArgs = expr.typeArgs.isNotEmpty
        ? '<${expr.typeArgs.map(typeEmitter.emit).join(', ')}>'
        : '';
    // Convert dot notation to C++ scope resolution operator
    // For StaticList.of, we need StaticList<T>::of, not StaticList::of<T>
    if (expr.funcName.contains('.')) {
      final parts = expr.funcName.split('.');
      final className = parts[0];
      final methodName = parts.sublist(1).join('.');
      return '$className$typeArgs::$methodName(${expr.args.map(emit).join(', ')})';
    }
    return '${expr.funcName}$typeArgs(${expr.args.map(emit).join(', ')})';
  }

  String _emitConstructorCall(IrConstructorCall expr) {
    final typeArgs = expr.typeArgs.isNotEmpty
        ? '<${expr.typeArgs.map(typeEmitter.emit).join(', ')}>'
        : '';
    final args = expr.args.map(emit).join(', ');
    return expr.args.isNotEmpty
        ? '${expr.newFuncName}$typeArgs(GC::allocateLocal(new ${expr.className}Value$typeArgs()), $args)'
        : '${expr.newFuncName}$typeArgs(GC::allocateLocal(new ${expr.className}Value$typeArgs()))';
  }

  String _emitClosureExpr(IrClosureExpr expr) {
    final typeArgs = expr.typeParams.isNotEmpty
        ? '<${expr.typeParams.map((t) => t.name).join(', ')}>'
        : '';
    final capturedArgs = expr.capturedFields.map((f) => f.isThis ? 'this_' : f.name).join(', ');
    final closurePtr = expr.capturedFields.isNotEmpty
        ? '${expr.envClassName}_new$typeArgs(GC::allocateLocal(new ${expr.envClassName}$typeArgs()), $capturedArgs)'
        : '${expr.envClassName}_new$typeArgs(GC::allocateLocal(new ${expr.envClassName}$typeArgs()))';
    // Return the TypeFunction pointer directly
    // C++ will implicitly convert it to AnyPtr when needed
    return closurePtr;
  }

  String _emitNativeOp(IrNativeOpExpr expr) {
    final left = emit(expr.left);
    if (expr.op == 'unary-') return '-$left';
    if (expr.op == '~') return '~$left';
    if (expr.op == '[]' && expr.right != null) {
      // For String types, use substr to get a single character as a string
      if (_isStringType(expr.left.resultType)) {
        final index = emit(expr.right!);
        return '$left.substr($index, 1)';
      }
      return '$left->operator[](${emit(expr.right!)})';
    }
    if (expr.op == '[]=' && expr.right != null && expr.indexSetValue != null) {
      // For String types, use [] directly instead of ->operator[]
      if (_isStringType(expr.left.resultType)) {
        return '$left[${emit(expr.right!)}] = ${emit(expr.indexSetValue!)}';
      }
      return '$left->operator[](${emit(expr.right!)}) = ${emit(expr.indexSetValue!)}';
    }
    if (expr.right != null) {
      return '($left ${expr.op} ${emit(expr.right!)})';
    }
    return left;
  }

  String _escapeString(String s) {
    return s
        .replaceAll(r'\', r'\\')
        .replaceAll('"', r'\"')
        .replaceAll('\n', r'\n')
        .replaceAll('\r', r'\r')
        .replaceAll('\t', r'\t');
  }
}
