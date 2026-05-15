/// Dart2Cpp restorer 运行时基础类定义
///
/// 包含 VPtr 虚函数表基类和 Box 类型（闭包引用语义）。
/// 由 dart_restorer 生成的还原代码通过 import 引入本文件。

/// VPtr 基类 - 所有无基类（或继承自 Object）的 Value 类都继承自它。
/// 提供 vptr 字段和 toString/operator==/hashCode 的桥接覆写。
class VPtr {
  late Map<String, dynamic> vptr;
  VPtr() {
    vptr = <String, dynamic>{
      'toString': null,
      'operatorEq': null,
      'get_hashCode': null,
    };
  }
  @override
  String toString() {
    final fn = vptr['toString'];
    if (fn != null) return (fn as Function)(this) as String;
    return super.toString();
  }
  @override
  bool operator ==(Object other) {
    final fn = vptr['operatorEq'];
    if (fn != null) return (fn as Function)(this, other) as bool;
    return identical(this, other);
  }
  @override
  int get hashCode {
    final fn = vptr['get_hashCode'];
    if (fn != null) return (fn as Function)(this) as int;
    return super.hashCode;
  }
}

/// Box 类型定义（闭包引用语义）
/// 用于在闭包中捕获可变的值类型变量。

class IntBox {
  int value;
  IntBox(this.value);
}

class DoubleBox {
  double value;
  DoubleBox(this.value);
}

class StringBox {
  String value;
  StringBox(this.value);
}

class BoolBox {
  bool value;
  BoolBox(this.value);
}

class ObjectBox<T> {
  T value;
  ObjectBox(this.value);
}
