/// VPtr 虚表基类、TypeFunction 函数值基类族、Box 类型（闭包引用语义）

import '_gc.dart';

// ============================================================================
// TypeFunction 基类族 — 替代 Dart 内建 Function 类型
// ============================================================================

abstract class TypeFunction extends AnyGC {
  TypeFunction();
  late dynamic closureCall;
}

abstract class TypeFunction0<R> extends TypeFunction {
  TypeFunction0();
  R call();
}

abstract class TypeFunction1<R, T1> extends TypeFunction {
  TypeFunction1();
  R call(T1 a1);
}

abstract class TypeFunction2<R, T1, T2> extends TypeFunction {
  TypeFunction2();
  R call(T1 a1, T2 a2);
}

abstract class TypeFunction3<R, T1, T2, T3> extends TypeFunction {
  TypeFunction3();
  R call(T1 a1, T2 a2, T3 a3);
}

abstract class TypeFunction4<R, T1, T2, T3, T4> extends TypeFunction {
  TypeFunction4();
  R call(T1 a1, T2 a2, T3 a3, T4 a4);
}

abstract class TypeFunction5<R, T1, T2, T3, T4, T5> extends TypeFunction {
  TypeFunction5();
  R call(T1 a1, T2 a2, T3 a3, T4 a4, T5 a5);
}

abstract class TypeFunction6<R, T1, T2, T3, T4, T5, T6> extends TypeFunction {
  TypeFunction6();
  R call(T1 a1, T2 a2, T3 a3, T4 a4, T5 a5, T6 a6);
}

abstract class TypeFunction7<R, T1, T2, T3, T4, T5, T6, T7> extends TypeFunction {
  TypeFunction7();
  R call(T1 a1, T2 a2, T3 a3, T4 a4, T5 a5, T6 a6, T7 a7);
}

abstract class TypeFunction8<R, T1, T2, T3, T4, T5, T6, T7, T8> extends TypeFunction {
  TypeFunction8();
  R call(T1 a1, T2 a2, T3 a3, T4 a4, T5 a5, T6 a6, T7 a7, T8 a8);
}

abstract class TypeFunction9<R, T1, T2, T3, T4, T5, T6, T7, T8, T9>
    extends TypeFunction {
  TypeFunction9();
  R call(T1 a1, T2 a2, T3 a3, T4 a4, T5 a5, T6 a6, T7 a7, T8 a8, T9 a9);
}

abstract class TypeFunction10<R, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10>
    extends TypeFunction {
  TypeFunction10();
  R call(T1 a1, T2 a2, T3 a3, T4 a4, T5 a5, T6 a6, T7 a7, T8 a8, T9 a9, T10 a10);
}

abstract class TypeFunction11<R, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11>
    extends TypeFunction {
  TypeFunction11();
  R call(T1 a1, T2 a2, T3 a3, T4 a4, T5 a5, T6 a6, T7 a7, T8 a8, T9 a9, T10 a10,
      T11 a11);
}

abstract class TypeFunction12<R, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12>
    extends TypeFunction {
  TypeFunction12();
  R call(T1 a1, T2 a2, T3 a3, T4 a4, T5 a5, T6 a6, T7 a7, T8 a8, T9 a9, T10 a10,
      T11 a11, T12 a12);
}

abstract class TypeFunction13<R, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13>
    extends TypeFunction {
  TypeFunction13();
  R call(T1 a1, T2 a2, T3 a3, T4 a4, T5 a5, T6 a6, T7 a7, T8 a8, T9 a9, T10 a10,
      T11 a11, T12 a12, T13 a13);
}

abstract class TypeFunction14<R, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14>
    extends TypeFunction {
  TypeFunction14();
  R call(T1 a1, T2 a2, T3 a3, T4 a4, T5 a5, T6 a6, T7 a7, T8 a8, T9 a9, T10 a10,
      T11 a11, T12 a12, T13 a13, T14 a14);
}

abstract class TypeFunction15<R, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15>
    extends TypeFunction {
  TypeFunction15();
  R call(T1 a1, T2 a2, T3 a3, T4 a4, T5 a5, T6 a6, T7 a7, T8 a8, T9 a9, T10 a10,
      T11 a11, T12 a12, T13 a13, T14 a14, T15 a15);
}

abstract class TypeFunction16<R, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16>
    extends TypeFunction {
  TypeFunction16();
  R call(T1 a1, T2 a2, T3 a3, T4 a4, T5 a5, T6 a6, T7 a7, T8 a8, T9 a9, T10 a10,
      T11 a11, T12 a12, T13 a13, T14 a14, T15 a15, T16 a16);
}

// ============================================================================
// VPtr 基类 — 虚函数表
// ============================================================================

/// VPtr 基类 - 所有无基类（或继承自 Object）的 Value 类都继承自它。
/// 提供 vptr 抽象 getter 和 toString/operator==/hashCode 的桥接覆写。
///
/// 每个具体 Value 类通过静态 `_vptr` 字段实现 per-type 共享的 vptr，
/// 惰性初始化，所有实例共享同一份虚函数表。
///
/// 注：vptr 槽里存的函数现在统一是 TypeFunctionN 子类实例（由还原器生成的
/// 各种 _Closure_ / _TearOff_ 类）。这里用对应 arity 的 TypeFunctionN 做
/// cast，避免出现 `Function` 字面量。
abstract class VPtr extends AnyGC {
  /// 子类必须实现此 getter，返回 per-type 共享的静态 vptr。
  Map<String, dynamic> get vptr;

  VPtr();

  @override
  String toString() {
    final fn = vptr['toString'];
    if (fn != null) return (fn as Function)(this) as String;
    return super.toString();
  }
  @override
  bool operator ==(Object other) {
    final fn = vptr['operatorEq'];
    if (fn != null) {
      return (fn as Function)(this, other) as bool;
    }
    return identical(this, other);
  }
  @override
  int get hashCode {
    final fn = vptr['get_hashCode'];
    if (fn != null) return (fn as Function)(this) as int;
    return super.hashCode;
  }
}

// ============================================================================
// Box 类型 — 闭包引用语义
// ============================================================================

/// Box 类型定义（闭包引用语义）
/// 用于在闭包中捕获可变的值类型变量。
/// 所有 Box 继承 AnyGC 以参与 GC 管理，构造时自动注册到 GC。

class IntBox extends AnyGC {
  int value;
  IntBox(this.value) {
    GC.allocateLocal(this);
  }
}

class DoubleBox extends AnyGC {
  double value;
  DoubleBox(this.value) {
    GC.allocateLocal(this);
  }
}

class StringBox extends AnyGC {
  String value;
  StringBox(this.value) {
    GC.allocateLocal(this);
  }
}

class BoolBox extends AnyGC {
  bool value;
  BoolBox(this.value) {
    GC.allocateLocal(this);
  }
}

class ObjectBox<T> extends AnyGC {
  T value;
  ObjectBox(this.value) {
    GC.allocateLocal(this);
  }

  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
    // 如果持有的值是 AnyGC 类型，递归标记
    final v = value;
    if (v is AnyGC) {
      v.gcMark(flag);
    }
  }
}
