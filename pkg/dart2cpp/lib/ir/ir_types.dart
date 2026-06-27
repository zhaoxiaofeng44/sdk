/// IR 类型节点层次。
///
/// 所有类型节点都是不可变数据载体，在 AST→IR 阶段由 [TypeTransformer] 生成。
/// 发射器将 [IrType] 解释为目标语言字符串：
///   - Dart: `IrPrimitiveType(Int)` → `int`
///   - C++:  `IrPrimitiveType(Int)` → `int64_t`
library ir_types;

import 'ir_node.dart';

// ---------------------------------------------------------------------------
// 基类
// ---------------------------------------------------------------------------

/// 所有类型节点的根基类。
abstract class IrType extends IrNode {
  const IrType();
}

// ---------------------------------------------------------------------------
// void
// ---------------------------------------------------------------------------

/// `void` 类型（Dart `void` / C++ `void`）。
class IrVoidType extends IrType {
  const IrVoidType();
  @override
  R accept<R>(IrVisitor<R> visitor) => visitor.visitVoidType(this);
  @override
  String toString() => 'void';
}

// ---------------------------------------------------------------------------
// 基础类型：int / double / bool / String
// ---------------------------------------------------------------------------

/// 基础值类型枚举。
enum PrimitiveKind { int_, double_, bool_, string_ }

/// 基础值类型（`int` / `double` / `bool` / `String`）。
class IrPrimitiveType extends IrType {
  final PrimitiveKind kind;
  const IrPrimitiveType(this.kind);

  @override
  R accept<R>(IrVisitor<R> visitor) => visitor.visitPrimitiveType(this);
  @override
  String toString() => switch (kind) {
        PrimitiveKind.int_ => 'int',
        PrimitiveKind.double_ => 'double',
        PrimitiveKind.bool_ => 'bool',
        PrimitiveKind.string_ => 'String',
      };
}

// ---------------------------------------------------------------------------
// dynamic / Object / num / Null → AnyPtr
// ---------------------------------------------------------------------------

/// 动态类型（Dart `dynamic`/`Object` → C++ `AnyPtr`）。
class IrDynamicType extends IrType {
  const IrDynamicType();
  @override
  R accept<R>(IrVisitor<R> visitor) => visitor.visitDynamicType(this);
  @override
  String toString() => 'dynamic';
}

// ---------------------------------------------------------------------------
// 用户类：Foo → FooValue / FooValue*
// ---------------------------------------------------------------------------

/// 用户自定义类类型。
///
/// [className] 是原始类名（如 `Circle`），
/// 发射器负责添加 `Value` 后缀和指针（`CircleValue` / `CircleValue*`）。
class IrUserType extends IrType {
  final String className;
  final List<IrType> typeArgs;

  const IrUserType(this.className, [this.typeArgs = const []]);

  @override
  R accept<R>(IrVisitor<R> visitor) => visitor.visitUserType(this);
  @override
  String toString() =>
      typeArgs.isEmpty ? className : '$className<${typeArgs.join(', ')}>';
}

// ---------------------------------------------------------------------------
// 集合类型：List / Map / Set / Iterator / Iterable
// ---------------------------------------------------------------------------

/// 集合类型枚举。
enum CollectionKind { list, map, set_, iterator, iterable }

/// 静态集合类型（`StaticList<T>` / `StaticMap<K,V>` / `StaticSet<T>` 等）。
class IrCollectionType extends IrType {
  final CollectionKind kind;
  final List<IrType> typeArgs;

  const IrCollectionType(this.kind, [this.typeArgs = const []]);

  @override
  R accept<R>(IrVisitor<R> visitor) => visitor.visitCollectionType(this);
  @override
  String toString() {
    final name = switch (kind) {
      CollectionKind.list => 'StaticList',
      CollectionKind.map => 'StaticMap',
      CollectionKind.set_ => 'StaticSet',
      CollectionKind.iterator => 'StaticIterator',
      CollectionKind.iterable => 'StaticList',
    };
    return typeArgs.isEmpty ? name : '$name<${typeArgs.join(', ')}>';
  }
}

// ---------------------------------------------------------------------------
// Promise / Future
// ---------------------------------------------------------------------------

/// Promise 类型（`Promise<T>`）。
class IrPromiseType extends IrType {
  final IrType innerType;
  const IrPromiseType(this.innerType);

  @override
  R accept<R>(IrVisitor<R> visitor) => visitor.visitPromiseType(this);
  @override
  String toString() => 'Promise<$innerType>';
}

// ---------------------------------------------------------------------------
// 函数类型：TypeFunction / TypeFunctionN
// ---------------------------------------------------------------------------

/// 函数类型（`TypeFunctionN<R, T1, ..., Tn>` / C++ `TypeFunctionN<...>*`）。
class IrFunctionType extends IrType {
  final IrType returnType;
  final List<IrType> paramTypes;

  /// 参数数量（用于选择 TypeFunctionN 的 arity）。
  /// -1 表示参数数量未知或含命名参数（退化为 `TypeFunction<R>`）。
  final int arity;

  /// 是否有命名参数（命名参数无法映射到 TypeFunctionN）。
  final bool hasNamedParams;

  const IrFunctionType(this.returnType, this.paramTypes,
      {this.arity = -1, this.hasNamedParams = false});

  @override
  R accept<R>(IrVisitor<R> visitor) => visitor.visitFunctionType(this);
  @override
  String toString() {
    if (arity < 0 || hasNamedParams) return 'dynamic';
    return 'TypeFunction$arity<$returnType, ${paramTypes.join(', ')}>';
  }
}

// ---------------------------------------------------------------------------
// Box 类型：IntBox / DoubleBox / StringBox / BoolBox / ObjectBox<T>
// ---------------------------------------------------------------------------

/// Box 类型枚举。
enum BoxKind { intBox, doubleBox, boolBox, stringBox, objectBox }

/// Box 包装类型（用于闭包捕获的引用语义）。
class IrBoxType extends IrType {
  final BoxKind kind;

  /// `ObjectBox<T>` 时的内部类型；其他 Box 为 `null`。
  final IrType? innerType;

  const IrBoxType(this.kind, [this.innerType]);

  @override
  R accept<R>(IrVisitor<R> visitor) => visitor.visitBoxType(this);
  @override
  String toString() => switch (kind) {
        BoxKind.intBox => 'IntBox',
        BoxKind.doubleBox => 'DoubleBox',
        BoxKind.boolBox => 'BoolBox',
        BoxKind.stringBox => 'StringBox',
        BoxKind.objectBox => 'ObjectBox<$innerType>',
      };
}

// ---------------------------------------------------------------------------
// 类型参数：T / T extends Bound
// ---------------------------------------------------------------------------

/// 泛型类型参数（如 `T`）。
class IrTypeParameterType extends IrType {
  final String name;

  /// 上界约束（`extends Bound`），`null` 表示无约束。
  final IrType? bound;

  const IrTypeParameterType(this.name, [this.bound]);

  @override
  R accept<R>(IrVisitor<R> visitor) => visitor.visitTypeParameterType(this);
  @override
  String toString() => name;
}

// ---------------------------------------------------------------------------
// 可空类型：T?
// ---------------------------------------------------------------------------

/// 可空类型（`T?`）。
class IrNullableType extends IrType {
  final IrType inner;
  const IrNullableType(this.inner);

  @override
  R accept<R>(IrVisitor<R> visitor) => visitor.visitNullableType(this);
  @override
  String toString() => '$inner?';
}

// ---------------------------------------------------------------------------
// AnyPtr（C++ 专用，Dart 发射器映射为 dynamic）
// ---------------------------------------------------------------------------

/// AnyPtr 类型（C++ 的 `AnyPtr`，Dart 中映射为 `dynamic`）。
class IrAnyPtrType extends IrType {
  const IrAnyPtrType();
  @override
  R accept<R>(IrVisitor<R> visitor) => visitor.visitAnyPtrType(this);
  @override
  String toString() => 'AnyPtr';
}

// ---------------------------------------------------------------------------
// Record 类型：(T1, T2, {named})
// ---------------------------------------------------------------------------

/// Record 类型。
class IrRecordType extends IrType {
  final List<IrType> positionalTypes;
  final Map<String, IrType> namedTypes;

  const IrRecordType(this.positionalTypes, [this.namedTypes = const {}]);

  @override
  R accept<R>(IrVisitor<R> visitor) => visitor.visitRecordType(this);
  @override
  String toString() => '(${positionalTypes.join(', ')})';
}
