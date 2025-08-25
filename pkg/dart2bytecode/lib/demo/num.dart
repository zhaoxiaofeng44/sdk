// /// 自定义Int类，完全对齐Dart内置int类型
// class Int {
//   final int value;

//   const Int(this.value);

//   // 构造函数
//   Int.from(int value) : value = value;

//   // 类型转换
//   int toInt() => value;
//   double toDouble() => value.toDouble();
//   String toString() => value.toString();
//   bool toBool() => value != 0;

//   // 算术运算符
//   Int operator +(Int other) => Int(value + other.value);
//   Int operator -(Int other) => Int(value - other.value);
//   Int operator *(Int other) => Int(value * other.value);
//   double operator /(Int other) => value / other.value;
//   Int operator ~/(Int other) => Int(value ~/ other.value);
//   Int operator %(Int other) => Int(value % other.value);
//   Int operator -() => Int(-value);

//   // 位运算符
//   Int operator &(Int other) => Int(value & other.value);
//   Int operator |(Int other) => Int(value | other.value);
//   Int operator ^(Int other) => Int(value ^ other.value);
//   Int operator <<(Int other) => Int(value << other.value);
//   Int operator >>(Int other) => Int(value >> other.value);
//   Int operator ~() => Int(~value);

//   // 比较运算符
//   bool operator ==(Object other) => other is Int && value == other.value;
//   bool operator <(Int other) => value < other.value;
//   bool operator <=(Int other) => value <= other.value;
//   bool operator >(Int other) => value > other.value;
//   bool operator >=(Int other) => value >= other.value;

//   // 自增自减方法（不能重载运算符）
//   Int increment() => Int(value + 1);
//   Int decrement() => Int(value - 1);

//   // 复合赋值方法（不能重载运算符）
//   Int add(Int other) => Int(value + other.value);
//   Int subtract(Int other) => Int(value - other.value);
//   Int multiply(Int other) => Int(value * other.value);
//   Int divideTruncate(Int other) => Int(value ~/ other.value);
//   Int modulo(Int other) => Int(value % other.value);
//   Int bitwiseAnd(Int other) => Int(value & other.value);
//   Int bitwiseOr(Int other) => Int(value | other.value);
//   Int bitwiseXor(Int other) => Int(value ^ other.value);
//   Int leftShift(Int other) => Int(value << other.value);
//   Int rightShift(Int other) => Int(value >> other.value);

//   // 数学函数
//   Int abs() => Int(value.abs());
//   Int sign() => Int(value.sign);
//   bool get isEven => value.isEven;
//   bool get isOdd => value.isOdd;
//   bool get isNegative => value.isNegative;
//   bool get isFinite => value.isFinite;
//   bool get isInfinite => value.isInfinite;
//   bool get isNaN => false; // int 永远不会是 NaN

//   // 位操作
//   Int bitLength() => Int(value.bitLength);

//   // 进制转换
//   String toRadixString(int radix) => value.toRadixString(radix);
//   String toHexString() => value.toRadixString(16);
//   String toOctalString() => value.toRadixString(8);
//   String toBinaryString() => value.toRadixString(2);

//   // 常量值
//   static const Int zero = Int(0);
//   static const Int one = Int(1);
//   static const Int two = Int(2);
//   static const Int ten = Int(10);
//   static const Int maxValue = Int(9223372036854775807);
//   static const Int minValue = Int(-9223372036854775808);

//   // 静态方法
//   static Int parse(String source, {int? radix}) {
//     return Int(int.parse(source, radix: radix));
//   }

//   static Int? tryParse(String source, {int? radix}) {
//     final result = int.tryParse(source, radix: radix);
//     return result != null ? Int(result) : null;
//   }

//   // 哈希码
//   @override
//   int get hashCode => value.hashCode;

//   // 运行时类型
//   Type get runtimeType => int;
// }

// /// 自定义Double类，完全对齐Dart内置double类型
// class Double {
//   final double value;

//   const Double(this.value);

//   // 构造函数
//   Double.from(double value) : value = value;
//   Double.fromInt(int value) : value = value.toDouble();

//   // 类型转换
//   int toInt() => value.toInt();
//   double toDouble() => value;
//   String toString() => value.toString();
//   bool toBool() => value != 0.0;

//   // 算术运算符
//   Double operator +(Double other) => Double(value + other.value);
//   Double operator -(Double other) => Double(value - other.value);
//   Double operator *(Double other) => Double(value * other.value);
//   Double operator /(Double other) => Double(value / other.value);
//   Double operator ~/(Double other) => Double((value ~/ other.value).toDouble());
//   Double operator %(Double other) => Double(value % other.value);
//   Double operator -() => Double(-value);

//   // 比较运算符
//   bool operator ==(Object other) => other is Double && value == other.value;
//   bool operator <(Double other) => value < other.value;
//   bool operator <=(Double other) => value <= other.value;
//   bool operator >(Double other) => value > other.value;
//   bool operator >=(Double other) => value >= other.value;

//   // 自增自减方法（不能重载运算符）
//   Double increment() => Double(value + 1.0);
//   Double decrement() => Double(value - 1.0);

//   // 复合赋值方法（不能重载运算符）
//   Double add(Double other) => Double(value + other.value);
//   Double subtract(Double other) => Double(value - other.value);
//   Double multiply(Double other) => Double(value * other.value);
//   Double divide(Double other) => Double(value / other.value);
//   Double divideTruncate(Double other) =>
//       Double((value ~/ other.value).toDouble());
//   Double modulo(Double other) => Double(value % other.value);

//   // 数学函数
//   Double abs() => Double(value.abs());
//   Double sign() => Double(value.sign);
//   Double ceil() => Double(value.ceil().toDouble());
//   Double floor() => Double(value.floor().toDouble());
//   Double round() => Double(value.round().toDouble());
//   Double truncate() => Double(value.truncate().toDouble());
//   Double remainder(Double other) => Double(value.remainder(other.value));

//   // 数学常量
//   static const Double e = Double(2.718281828459045);
//   static const Double ln10 = Double(2.302585092994046);
//   static const Double ln2 = Double(0.6931471805599453);
//   static const Double log10e = Double(0.4342944819032518);
//   static const Double log2e = Double(1.4426950408889634);
//   static const Double pi = Double(3.1415926535897932);
//   static const Double sqrt1_2 = Double(0.7071067811865476);
//   static const Double sqrt2 = Double(1.4142135623730951);

//   // 特殊值
//   static const Double infinity = Double(double.infinity);
//   static const Double negativeInfinity = Double(double.negativeInfinity);
//   static const Double nan = Double(double.nan);
//   static const Double maxFinite = Double(double.maxFinite);
//   static const Double minPositive = Double(double.minPositive);

//   // 属性
//   bool get isNegative => value.isNegative;
//   bool get isFinite => value.isFinite;
//   bool get isInfinite => value.isInfinite;
//   bool get isNaN => value.isNaN;

//   // 字符串转换
//   String toStringAsFixed(int fractionDigits) =>
//       value.toStringAsFixed(fractionDigits);
//   String toStringAsExponential([int? fractionDigits]) =>
//       value.toStringAsExponential(fractionDigits);
//   String toStringAsPrecision(int precision) =>
//       value.toStringAsPrecision(precision);

//   // 静态方法
//   static Double parse(String source) {
//     return Double(double.parse(source));
//   }

//   static Double? tryParse(String source) {
//     final result = double.tryParse(source);
//     return result != null ? Double(result) : null;
//   }

//   // 哈希码
//   @override
//   int get hashCode => value.hashCode;

//   // 运行时类型
//   Type get runtimeType => double;
// }

// /// 扩展方法，使Int和Double能够与内置类型互操作
// extension IntExtensions on int {
//   Int toCustomInt() => Int(this);
// }

// extension DoubleExtensions on double {
//   Double toCustomDouble() => Double(this);
// }

// extension CustomIntExtensions on Int {
//   int toBuiltinInt() => value;
// }

// extension CustomDoubleExtensions on Double {
//   double toBuiltinDouble() => value;
// }

// /// 混合类型操作
// extension MixedOperations on Int {
//   Double operator +(Double other) => Double(value + other.value);
//   Double operator -(Double other) => Double(value - other.value);
//   Double operator *(Double other) => Double(value * other.value);
//   Double operator /(Double other) => Double(value / other.value);
//   Double operator ~/(Double other) => Double((value ~/ other.value) as double);
//   Double operator %(Double other) => Double(value % other.value);

//   bool operator <(Double other) => value < other.value;
//   bool operator <=(Double other) => value <= other.value;
//   bool operator >(Double other) => value > other.value;
//   bool operator >=(Double other) => value >= other.value;
// }

// extension MixedOperationsDouble on Double {
//   Double operator +(Int other) => Double(value + other.value.toDouble());
//   Double operator -(Int other) => Double(value - other.value.toDouble());
//   Double operator *(Int other) => Double(value * other.value.toDouble());
//   Double operator /(Int other) => Double(value / other.value.toDouble());
//   Double operator ~/(Int other) =>
//       Double((value ~/ other.value.toDouble()).toDouble());
//   Double operator %(Int other) => Double(value % other.value.toDouble());

//   bool operator <(Int other) => value < other.value.toDouble();
//   bool operator <=(Int other) => value <= other.value.toDouble();
//   bool operator >(Int other) => value > other.value.toDouble();
//   bool operator >=(Int other) => value >= other.value.toDouble();
// }

// /// 自定义Bool类，完全对齐Dart内置bool类型
// class Bool {
//   final bool value;

//   const Bool(this.value);

//   // 构造函数
//   Bool.from(bool value) : value = value;
//   Bool.fromString(String value) : value = value.toLowerCase() == 'true';

//   // 类型转换
//   bool toBool() => value;
//   int toInt() => value ? 1 : 0;
//   double toDouble() => value ? 1.0 : 0.0;
//   String toString() => value.toString();

//   // 逻辑运算符
//   Bool operator &(Bool other) => Bool(value && other.value);
//   Bool operator |(Bool other) => Bool(value || other.value);
//   Bool operator ^(Bool other) => Bool(value != other.value);
//   // 注意：! 运算符不能重载，使用 not() 方法代替

//   // 比较运算符
//   bool operator ==(Object other) => other is Bool && value == other.value;
//   bool operator <(Bool other) => !value && other.value; // false < true
//   bool operator <=(Bool other) => !value || other.value;
//   bool operator >(Bool other) => value && !other.value; // true > false
//   bool operator >=(Bool other) => value || !other.value;

//   // 逻辑运算方法
//   Bool and(Bool other) => Bool(value && other.value);
//   Bool or(Bool other) => Bool(value || other.value);
//   Bool xor(Bool other) => Bool(value != other.value);
//   Bool not() => Bool(!value);

//   // 条件运算
//   T? ifTrue<T>(T Function()? then) => value ? (then?.call()) : null;
//   T? ifFalse<T>(T Function()? then) => !value ? (then?.call()) : null;
//   T? when<T>({T? Function()? ifTrue, T? Function()? ifFalse}) {
//     if (value) {
//       return ifTrue?.call();
//     } else {
//       return ifFalse?.call();
//     }
//   }

//   // 常量值
//   static const Bool true_ = Bool(true);
//   static const Bool false_ = Bool(false);

//   // 静态方法
//   static Bool parse(String source) {
//     final lowerSource = source.toLowerCase();
//     if (lowerSource == 'true') {
//       return Bool(true);
//     } else if (lowerSource == 'false') {
//       return Bool(false);
//     } else {
//       throw FormatException('Invalid boolean: $source');
//     }
//   }

//   static Bool? tryParse(String source) {
//     try {
//       return parse(source);
//     } catch (e) {
//       return null;
//     }
//   }

//   // 工厂构造函数
//   factory Bool.fromInt(int value) => Bool(value != 0);
//   factory Bool.fromDouble(double value) => Bool(value != 0.0);

//   // 哈希码
//   @override
//   int get hashCode => value.hashCode;

//   // 运行时类型
//   Type get runtimeType => bool;

//   // 属性
//   bool get isTrue => value;
//   bool get isFalse => !value;
// }

// /// 扩展方法，使Bool能够与内置类型互操作
// extension BoolExtensions on bool {
//   Bool toCustomBool() => Bool(this);
// }

// extension CustomBoolExtensions on Bool {
//   bool toBuiltinBool() => value;
// }

// /// 混合类型操作
// extension MixedBoolOperations on Bool {
//   // 与Int的混合操作
//   Int add(Int other) => Int(value ? other.value + 1 : other.value);
//   Int subtract(Int other) => Int(value ? other.value - 1 : other.value);
//   Int multiply(Int other) => Int(value ? other.value : 0);
//   double divide(Int other) => value ? other.value.toDouble() : 0.0;
//   Int divideTruncate(Int other) => Int(value ? other.value : 0);
//   Int modulo(Int other) => Int(value ? other.value % 1 : 0);

//   // 与Double的混合操作
//   Double addDouble(Double other) =>
//       Double(value ? other.value + 1.0 : other.value);
//   Double subtractDouble(Double other) =>
//       Double(value ? other.value - 1.0 : other.value);
//   Double multiplyDouble(Double other) => Double(value ? other.value : 0.0);
//   Double divideDouble(Double other) => Double(value ? other.value : 0.0);
//   Double divideTruncateDouble(Double other) =>
//       Double(value ? (other.value ~/ 1.0).toDouble() : 0.0);
//   Double moduloDouble(Double other) => Double(value ? other.value % 1.0 : 0.0);

//   // 比较操作
//   bool lessThan(Int other) => !value && other.value > 0;
//   bool lessThanOrEqual(Int other) => !value || other.value >= 0;
//   bool greaterThan(Int other) => value && other.value <= 0;
//   bool greaterThanOrEqual(Int other) => value || other.value < 0;

//   bool lessThanDouble(Double other) => !value && other.value > 0.0;
//   bool lessThanOrEqualDouble(Double other) => !value || other.value >= 0.0;
//   bool greaterThanDouble(Double other) => value && other.value <= 0.0;
//   bool greaterThanOrEqualDouble(Double other) => value || other.value < 0.0;
// }

// extension MixedBoolOperationsInt on Int {
//   // Int与Bool的混合操作
//   Int addBool(Bool other) => Int(value + (other.value ? 1 : 0));
//   Int subtractBool(Bool other) => Int(value - (other.value ? 1 : 0));
//   Int multiplyBool(Bool other) => Int(value * (other.value ? 1 : 0));
//   double divideBool(Bool other) => value / (other.value ? 1 : 1);
//   Int divideTruncateBool(Bool other) => Int(value ~/ (other.value ? 1 : 1));
//   Int moduloBool(Bool other) => Int(value % (other.value ? 1 : 1));

//   // 比较操作
//   bool lessThanBool(Bool other) => value < (other.value ? 1 : 0);
//   bool lessThanOrEqualBool(Bool other) => value <= (other.value ? 1 : 0);
//   bool greaterThanBool(Bool other) => value > (other.value ? 1 : 0);
//   bool greaterThanOrEqualBool(Bool other) => value >= (other.value ? 1 : 0);
// }

// extension MixedBoolOperationsDouble on Double {
//   // Double与Bool的混合操作
//   Double addBool(Bool other) => Double(value + (other.value ? 1.0 : 0.0));
//   Double subtractBool(Bool other) => Double(value - (other.value ? 1.0 : 0.0));
//   Double multiplyBool(Bool other) => Double(value * (other.value ? 1.0 : 0.0));
//   Double divideBool(Bool other) => Double(value / (other.value ? 1.0 : 1.0));
//   Double divideTruncateBool(Bool other) =>
//       Double((value ~/ (other.value ? 1.0 : 1.0)).toDouble());
//   Double moduloBool(Bool other) => Double(value % (other.value ? 1.0 : 1.0));

//   // 比较操作
//   bool lessThanBool(Bool other) => value < (other.value ? 1.0 : 0.0);
//   bool lessThanOrEqualBool(Bool other) => value <= (other.value ? 1.0 : 0.0);
//   bool greaterThanBool(Bool other) => value > (other.value ? 1.0 : 0.0);
//   bool greaterThanOrEqualBool(Bool other) => value >= (other.value ? 1.0 : 0.0);
// }
