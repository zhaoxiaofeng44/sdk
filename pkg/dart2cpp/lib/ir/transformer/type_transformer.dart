/// 类型转换器 — 将 Kernel DartType 转为 IrType。
///
/// 合并自：
/// - `restorer/type_utils.dart` 的 `_restoreType`
/// - `cpp_compiler/type_mapper.dart` 的 `cppType`
///
/// 产出目标无关的 [IrType] 节点，发射器各自解释。
library type_transformer;

import 'package:kernel/kernel.dart';
import 'package:dart2cpp/ir/ir_types.dart';
import 'package:dart2cpp/shared/analysis_context.dart';
import 'package:dart2cpp/shared/type_classifier.dart';

/// 类型转换器。
///
/// 将 Kernel [DartType] 转为 IR [IrType] 节点。
class TypeTransformer {
  final AnalysisContext ctx;

  /// 活跃的类型参数替换映射（mixin 字段类型参数替换）。
  /// 键为 TypeParameter 名称，值为替换后的类型字符串。
  Map<String, String> activeTypeParamSubstitution = {};

  /// 需要被替换的 TypeParameter 对象引用。
  Set<TypeParameter> activeTypeParamTargets = {};

  /// 精确类型参数替换映射：TypeParameter 对象 → IrType。
  /// 优先级高于 [activeTypeParamSubstitution]（字符串映射）。
  Map<TypeParameter, IrType> directTypeSubstitution = {};

  TypeTransformer(this.ctx);

  /// 将 Kernel DartType 转为 IrType。
  IrType transform(DartType type, {bool isNullable = false, bool isExceptionType = false}) {
    final irType = _transformImpl(type, isExceptionType: isExceptionType);
    // Auto-detect nullability from Kernel type or explicit parameter
    final isNull = isNullable || _isKernelNullable(type);
    if (isNull && irType is! IrDynamicType && irType is! IrVoidType && irType is! IrNullableType) {
      return IrNullableType(irType);
    }
    return irType;
  }

  /// Check if a Kernel DartType is nullable.
  bool _isKernelNullable(DartType type) {
    try {
      // Kernel types have a nullability property
      final nullability = (type as dynamic).nullability;
      if (nullability != null) {
        // Only Nullability.nullable is truly nullable
        return nullability.toString().contains('nullable') &&
               !nullability.toString().contains('non');
      }
    } catch (_) {
      // Ignore if nullability is not available
    }
    return false;
  }

  IrType _transformImpl(DartType type, {bool isExceptionType = false}) {
    if (type is VoidType) return const IrVoidType();
    if (type is DynamicType) return const IrDynamicType();
    if (type is NeverType) return const IrVoidType();
    if (type is NullType) return const IrDynamicType();

    if (type is InterfaceType) {
      return _transformInterfaceType(type, isExceptionType: isExceptionType);
    }

    if (type is TypeParameterType) {
      return _transformTypeParameter(type);
    }

    if (type is FunctionType) {
      return _transformFunctionType(type);
    }

    if (type is RecordType) {
      return _transformRecordType(type);
    }

    return const IrDynamicType();
  }

  /// 转换 InterfaceType。
  IrType _transformInterfaceType(InterfaceType type, {bool isExceptionType = false}) {
    final name = type.classNode.name;
    final category = TypeClassifier.classify(type);
    final typeArgs =
        type.typeArguments.map((t) => _transformImpl(t)).toList();

    switch (category) {
      case TypeCategory.primitiveInt:
        return const IrPrimitiveType(PrimitiveKind.int_);
      case TypeCategory.primitiveDouble:
        return const IrPrimitiveType(PrimitiveKind.double_);
      case TypeCategory.primitiveBool:
        return const IrPrimitiveType(PrimitiveKind.bool_);
      case TypeCategory.primitiveString:
        return const IrPrimitiveType(PrimitiveKind.string_);
      case TypeCategory.dynamic_:
      case TypeCategory.null_:
        return const IrDynamicType();
      case TypeCategory.void_:
        return const IrVoidType();

      case TypeCategory.collectionList:
      case TypeCategory.collectionIterable:
        return IrCollectionType(CollectionKind.list, typeArgs);
      case TypeCategory.collectionMap:
        return IrCollectionType(CollectionKind.map, typeArgs);
      case TypeCategory.collectionSet:
        return IrCollectionType(CollectionKind.set_, typeArgs);
      case TypeCategory.collectionIterator:
        return IrCollectionType(CollectionKind.iterator, typeArgs);

      case TypeCategory.promise:
        return IrPromiseType(typeArgs.isNotEmpty
            ? typeArgs.first
            : const IrDynamicType());

      case TypeCategory.stringBuffer:
        return const IrUserType('StaticStringBuffer');
      case TypeCategory.mapEntry:
        return IrUserType('StaticMapEntry', typeArgs);
      case TypeCategory.regExp:
        return const IrUserType('StaticRegExp');
      case TypeCategory.duration:
        return const IrUserType('StaticDuration');
      case TypeCategory.dateTime:
        return const IrUserType('StaticDateTime');
      case TypeCategory.comparable:
        return IrUserType('Comparable', typeArgs);

      case TypeCategory.stateError:
        // 异常类型在 catch 子句中不应被映射，使用原始 Dart 异常类型
        return isExceptionType ? const IrUserType('StateError') : const IrUserType('DartStateError');
      case TypeCategory.argumentError:
        return isExceptionType ? const IrUserType('ArgumentError') : const IrUserType('DartArgumentError');
      case TypeCategory.rangeError:
        return isExceptionType ? const IrUserType('RangeError') : const IrUserType('DartRangeError');
      case TypeCategory.formatException:
        return isExceptionType ? const IrUserType('FormatException') : const IrUserType('DartFormatException');
      case TypeCategory.unsupportedError:
        return isExceptionType ? const IrUserType('UnsupportedError') : const IrUserType('DartUnsupportedError');
      case TypeCategory.unimplementedError:
        return isExceptionType ? const IrUserType('UnimplementedError') : const IrUserType('DartUnimplementedError');

      case TypeCategory.userClass:
        return IrUserType(name, typeArgs);

      case TypeCategory.futureOr:
        // FutureOr<T> 保留（Dart 发射器直接输出，C++ 退化为 AnyPtr）
        return IrUserType('FutureOr', typeArgs);

      case TypeCategory.function:
      case TypeCategory.typeParameter:
      case TypeCategory.record:
      case TypeCategory.never_:
      case TypeCategory.unknown:
        return const IrDynamicType();
    }
  }

  /// 转换类型参数。
  IrType _transformTypeParameter(TypeParameterType type) {
    final param = type.parameter;
    final name = param.name ?? 'T';

    // 优先检查精确替换映射（TypeParameter 对象 → IrType）
    if (directTypeSubstitution.containsKey(param)) {
      final replacement = directTypeSubstitution[param]!;
      // 处理可空性
      if (type.nullability == Nullability.nullable &&
          replacement is! IrDynamicType &&
          replacement is! IrVoidType &&
          replacement is! IrNullableType) {
        return IrNullableType(replacement);
      }
      return replacement;
    }

    // 检查是否在活跃替换映射中
    if (activeTypeParamTargets.contains(param) &&
        activeTypeParamSubstitution.containsKey(name)) {
      final replacement = activeTypeParamSubstitution[name]!;
      // 替换后的类型已经是一个字符串，需要解析回 IrType
      // 处理嵌套泛型类型（如 Promise<TOutput> → Promise<C>）
      if (replacement.contains('<')) {
        return _parseTypeString(replacement);
      }
      // 如果是基础类型则映射，否则检查是否为类型参数
      switch (replacement) {
        case 'int':
          return const IrPrimitiveType(PrimitiveKind.int_);
        case 'double':
          return const IrPrimitiveType(PrimitiveKind.double_);
        case 'bool':
          return const IrPrimitiveType(PrimitiveKind.bool_);
        case 'String':
          return const IrPrimitiveType(PrimitiveKind.string_);
        case 'void':
          return const IrVoidType();
        case 'dynamic':
          return const IrDynamicType();
        default:
          // 检查是否为类型参数名（单一大写字母开头或已知类型参数）
          if (_isTypeParameterName(replacement)) {
            return IrTypeParameterType(replacement);
          }
          return IrUserType(replacement);
      }
    }

    // 转换上界
    IrType? bound;
    final paramBound = param.bound;
    if (paramBound is! DynamicType) {
      bound = _transformImpl(paramBound);
    }

    return IrTypeParameterType(name, bound);
  }

  /// 检查是否为类型参数名（通常为大写字母开头，如 T, TInput, A, B, C 等）
  bool _isTypeParameterName(String name) {
    // 简单的启发式：如果名称以大写字母开头且长度较短，可能是类型参数
    // 更精确的方法需要检查是否在已知的类型参数集合中
    return name.isNotEmpty && name[0].toUpperCase() == name[0] && name.length <= 10;
  }

  /// 解析类型字符串为 IrType（处理嵌套泛型）
  IrType _parseTypeString(String typeStr) {
    // 简单实现：提取主类型名和类型参数
    final match = RegExp(r'^(\w+)<(.+)>$').firstMatch(typeStr);
    if (match != null) {
      final mainType = match.group(1)!;
      final argsStr = match.group(2)!;
      final args = _splitTypeArgs(argsStr);
      final irArgs = args.map((arg) => _parseTypeString(arg.trim())).toList();

      // 根据主类型名创建对应的 IrType
      switch (mainType) {
        case 'Promise':
          return IrPromiseType(irArgs.first);
        case 'List':
        case 'StaticList':
          return IrCollectionType(CollectionKind.list, irArgs);
        case 'Map':
        case 'StaticMap':
          return IrCollectionType(CollectionKind.map, irArgs);
        case 'Set':
        case 'StaticSet':
          return IrCollectionType(CollectionKind.set_, irArgs);
        default:
          return IrUserType(mainType, irArgs);
      }
    }

    // 非泛型类型，递归处理
    return transform(
      _findTypeByName(typeStr),
    );
  }

  /// 分割类型参数（处理嵌套尖括号）
  List<String> _splitTypeArgs(String argsStr) {
    final result = <String>[];
    var depth = 0;
    var current = '';
    for (final char in argsStr.split('')) {
      if (char == '<') depth++;
      if (char == '>') depth--;
      if (char == ',' && depth == 0) {
        result.add(current);
        current = '';
      } else {
        current += char;
      }
    }
    if (current.isNotEmpty) result.add(current);
    return result;
  }

  /// 根据名称查找类型（简化实现）
  DartType _findTypeByName(String name) {
    // 这是一个简化的占位实现
    // 在实际使用中，应该通过类型参数对象来查找
    throw UnimplementedError('Type lookup by name not implemented');
  }

  /// 转换函数类型。
  IrType _transformFunctionType(FunctionType type) {
    final returnType = _transformImpl(type.returnType);
    final paramTypes =
        type.positionalParameters.map((t) => _transformImpl(t)).toList();

    // 检查是否有命名参数
    final hasNamedParams = type.namedParameters.isNotEmpty;

    // 计算 arity
    final arity = hasNamedParams ? -1 : paramTypes.length;

    // arity 上限为 16（kMaxArity）
    if (arity > 16) {
      return IrFunctionType(returnType, paramTypes, arity: -1);
    }

    return IrFunctionType(returnType, paramTypes,
        arity: arity, hasNamedParams: hasNamedParams);
  }

  /// 转换 Record 类型。
  IrType _transformRecordType(RecordType type) {
    final positional =
        type.positional.map((t) => _transformImpl(t)).toList();
    final named = <String, IrType>{
      for (final nt in type.named) nt.name: _transformImpl(nt.type),
    };
    return IrRecordType(positional, named);
  }

  /// 获取 Box 类型（用于闭包捕获的引用语义）。
  ///
  /// 返回 `null` 表示该类型不需要装箱。
  IrBoxType? getBoxType(DartType type) {
    if (type is InterfaceType) {
      final name = type.classNode.name;
      switch (name) {
        case 'int':
          return const IrBoxType(BoxKind.intBox);
        case 'double':
          return const IrBoxType(BoxKind.doubleBox);
        case 'bool':
          return const IrBoxType(BoxKind.boolBox);
        case 'String':
          return const IrBoxType(BoxKind.stringBox);
        default:
          return null;
      }
    }
    if (type is TypeParameterType) {
      final irType = _transformTypeParameter(type);
      return IrBoxType(BoxKind.objectBox, irType);
    }
    return null;
  }

  /// 获取函数签名类型（用于 vptr cast）。
  ///
  /// this_ 参数始终为 `dynamic`（消除逆变问题）。
  IrFunctionType getSignatureType(Procedure proc) {
    final returnType = _transformImpl(proc.function.returnType);
    final paramTypes = <IrType>[const IrDynamicType()]; // this_ 参数
    for (final p in proc.function.positionalParameters) {
      paramTypes.add(_transformImpl(p.type));
    }
    return IrFunctionType(returnType, paramTypes, arity: paramTypes.length);
  }

  /// 获取调用处的精确签名（用于 vptr dispatch cast）。
  IrFunctionType getCallSiteSignature(
      FunctionType funcType, DartType? receiverType) {
    final returnType = _transformImpl(funcType.returnType);
    final paramTypes = <IrType>[const IrDynamicType()]; // this_ 参数
    for (final p in funcType.positionalParameters) {
      paramTypes.add(_transformImpl(p));
    }
    return IrFunctionType(returnType, paramTypes, arity: paramTypes.length);
  }

  /// 获取类型参数的声明列表（用于 IrTypeParameterType 列表）。
  List<IrTypeParameterType> transformTypeParameters(
      List<TypeParameter> typeParams) {
    return typeParams.map((tp) {
      final name = tp.name ?? 'T';
      final boundType = tp.bound;
      IrType? bound;
      if (boundType is! DynamicType) {
        bound = _transformImpl(boundType);
      }
      return IrTypeParameterType(name, bound);
    }).toList();
  }

  /// 清理类型参数替换状态。
  void clearTypeParamSubstitution() {
    activeTypeParamSubstitution.clear();
    activeTypeParamTargets.clear();
    directTypeSubstitution.clear();
  }
}
