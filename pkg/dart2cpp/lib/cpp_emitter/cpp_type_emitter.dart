/// C++ 类型发射器 — 将 IR 类型节点转为 C++ 类型字符串。
///
/// 映射规则：
/// - int → int64_t
/// - double → double
/// - bool → bool
/// - String → std::string
/// - dynamic/Object → AnyPtr
/// - 用户类 X → XValue*
/// - List<T> → StaticList<CppT>*
/// - Future<T> → Promise<CppT>*
library cpp_type_emitter;

import 'package:dart2cpp/ir/ir_nodes.dart';
import 'package:dart2cpp/shared/analysis_context.dart';

/// C++ 类型发射器。
class CppTypeEmitter {
  final AnalysisContext ctx;

  CppTypeEmitter(this.ctx);

  /// 将 IR 类型转为 C++ 类型字符串。
  String emit(IrType type) {
    if (type is IrVoidType) return 'void';

    if (type is IrPrimitiveType) {
      return switch (type.kind) {
        PrimitiveKind.int_ => 'int',  // Use int instead of int64_t for main function compatibility
        PrimitiveKind.double_ => 'double',
        PrimitiveKind.bool_ => 'bool',
        PrimitiveKind.string_ => 'std::string',
      };
    }

    if (type is IrDynamicType) return 'AnyPtr';
    if (type is IrAnyPtrType) return 'AnyPtr';

    if (type is IrUserType) {
      final isUser = ctx.isUserClass(type.className);
      final baseName = isUser ? '${type.className}Value' : type.className;

      // Add template arguments if present
      if (type.typeArgs.isNotEmpty) {
        final args = type.typeArgs.map(emit).join(', ');
        return isUser ? '$baseName<$args>*' : '$baseName<$args>';
      }

      return isUser ? '$baseName*' : baseName;
    }

    if (type is IrCollectionType) {
      final name = switch (type.kind) {
        CollectionKind.list => 'StaticList',
        CollectionKind.map => 'StaticMap',
        CollectionKind.set_ => 'StaticSet',
        CollectionKind.iterator => 'StaticIterator',
        CollectionKind.iterable => 'StaticList',
      };
      if (type.typeArgs.isEmpty) return '$name<AnyPtr>*';
      final args = type.typeArgs.map(emit).join(', ');
      return '$name<$args>*';
    }

    if (type is IrPromiseType) {
      return 'Promise<${emit(type.innerType)}>*';
    }

    if (type is IrFunctionType) {
      if (type.arity < 0 || type.hasNamedParams) return 'TypeFunction*';
      final retStr = emit(type.returnType);
      if (type.paramTypes.isEmpty) {
        return 'TypeFunction0<$retStr>*';
      }
      final paramStr = type.paramTypes.map(emit).join(', ');
      return 'TypeFunction${type.arity}<$retStr, $paramStr>*';
    }

    if (type is IrBoxType) {
      final name = switch (type.kind) {
        BoxKind.intBox => 'IntBox',
        BoxKind.doubleBox => 'DoubleBox',
        BoxKind.boolBox => 'BoolBox',
        BoxKind.stringBox => 'StringBox',
        BoxKind.objectBox => 'ObjectBox<${type.innerType != null ? emit(type.innerType!) : 'AnyPtr'}>',
      };
      return '$name*';
    }

    if (type is IrTypeParameterType) return type.name;

    if (type is IrNullableType) {
      // Nullable types should be represented as AnyPtr in C++ to support null checks
      // This allows null-aware access (?.) to work correctly
      return 'AnyPtr';
    }

    if (type is IrRecordType) {
      // Records map to AnyPtr in C++
      return 'AnyPtr';
    }

    return 'AnyPtr';
  }

  /// 获取类型的默认值表达式。
  String defaultValue(IrType type) {
    if (type is IrPrimitiveType) {
      return switch (type.kind) {
        PrimitiveKind.int_ => '0',
        PrimitiveKind.double_ => '0.0',
        PrimitiveKind.bool_ => 'false',
        PrimitiveKind.string_ => '""',
      };
    }
    if (type is IrVoidType) return '';
    if (type is IrDynamicType || type is IrAnyPtrType) return 'AnyPtr()';
    if (type is IrUserType) return 'nullptr';
    if (type is IrCollectionType) return 'nullptr';
    if (type is IrPromiseType) return 'nullptr';
    if (type is IrFunctionType) return 'nullptr';
    if (type is IrBoxType) return 'nullptr';
    return 'AnyPtr()';
  }

  /// 生成 AnyPtr 包装表达式。
  String wrapInAnyPtr(String expr, IrType type) {
    if (type is IrPrimitiveType) {
      return switch (type.kind) {
        PrimitiveKind.int_ => 'AnyPtr::fromInt($expr)',
        PrimitiveKind.double_ => 'AnyPtr::fromDouble($expr)',
        PrimitiveKind.bool_ => 'AnyPtr::fromBool($expr)',
        PrimitiveKind.string_ => 'AnyPtr::fromString($expr)',
      };
    }
    if (type is IrUserType) return 'AnyPtr::fromVPtr($expr)';
    if (type is IrCollectionType) return 'AnyPtr::fromGC($expr)';
    if (type is IrFunctionType) return 'AnyPtr::fromTypeFunction($expr)';
    if (type is IrDynamicType || type is IrAnyPtrType) return expr;
    return 'AnyPtr::fromAuto($expr)';
  }

  /// 生成 AnyPtr 解包表达式。
  String unwrapFromAnyPtr(String expr, IrType type) {
    if (type is IrPrimitiveType) {
      return switch (type.kind) {
        PrimitiveKind.int_ => '$expr.toInt()',
        PrimitiveKind.double_ => '$expr.toDouble()',
        PrimitiveKind.bool_ => '$expr.toBool()',
        PrimitiveKind.string_ => '$expr.castTo<std::string>()',
      };
    }
    if (type is IrUserType) {
      return 'static_cast<${type.className}Value*>($expr.toVPtr())';
    }
    if (type is IrDynamicType || type is IrAnyPtrType) return expr;
    return '$expr.castTo<${emit(type)}>()';
  }

  /// 生成类型参数声明（模板参数）。
  String emitTypeParamDecl(IrTypeParameterType tp) {
    if (tp.bound != null) {
      return 'typename ${tp.name}';
    }
    return 'typename ${tp.name}';
  }
}
