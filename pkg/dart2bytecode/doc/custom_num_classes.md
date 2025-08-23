# 自定义Int和Double类实现

## 概述

本文档描述了自定义的 `Int` 和 `Double` 类的实现，这些类旨在完全对齐Dart内置的 `int`、`double` 和 `num` 类型，使其能够完全替换内置类型。

## 实现特性

### Int类特性

#### 基本功能
- **构造函数**: `Int(value)`, `Int.from(value)`
- **类型转换**: `toInt()`, `toDouble()`, `toString()`, `toBool()`
- **常量值**: `zero`, `one`, `two`, `ten`, `maxValue`, `minValue`

#### 算术运算符
- `+`, `-`, `*`, `/`, `~/`, `%`, `-` (一元负号)
- 所有运算符都返回适当的类型（Int或double）

#### 位运算符
- `&`, `|`, `^`, `<<`, `>>`, `~`
- 支持位操作和移位操作

#### 比较运算符
- `==`, `!=`, `<`, `<=`, `>`, `>=`
- 支持相等性和大小比较

#### 数学函数
- `abs()`: 绝对值
- `sign()`: 符号函数
- `bitLength()`: 位长度

#### 属性
- `isEven`: 是否为偶数
- `isOdd`: 是否为奇数
- `isNegative`: 是否为负数
- `isFinite`: 是否为有限数
- `isInfinite`: 是否为无穷大
- `isNaN`: 是否为NaN（int永远为false）

#### 进制转换
- `toRadixString(radix)`: 指定进制转换
- `toHexString()`: 十六进制
- `toOctalString()`: 八进制
- `toBinaryString()`: 二进制

#### 静态方法
- `parse(source, {radix})`: 解析字符串
- `tryParse(source, {radix})`: 安全解析字符串

### Double类特性

#### 基本功能
- **构造函数**: `Double(value)`, `Double.from(value)`, `Double.fromInt(value)`
- **类型转换**: `toInt()`, `toDouble()`, `toString()`, `toBool()`
- **数学常量**: `e`, `ln10`, `ln2`, `log10e`, `log2e`, `pi`, `sqrt1_2`, `sqrt2`

#### 算术运算符
- `+`, `-`, `*`, `/`, `~/`, `%`, `-` (一元负号)
- 所有运算符都返回Double类型

#### 比较运算符
- `==`, `!=`, `<`, `<=`, `>`, `>=`
- 支持相等性和大小比较

#### 数学函数
- `abs()`: 绝对值
- `sign()`: 符号函数
- `ceil()`: 向上取整
- `floor()`: 向下取整
- `round()`: 四舍五入
- `truncate()`: 截断
- `remainder(other)`: 余数

#### 特殊值
- `infinity`: 正无穷大
- `negativeInfinity`: 负无穷大
- `nan`: 非数字
- `maxFinite`: 最大有限值
- `minPositive`: 最小正数

#### 属性
- `isNegative`: 是否为负数
- `isFinite`: 是否为有限数
- `isInfinite`: 是否为无穷大
- `isNaN`: 是否为NaN

#### 字符串转换
- `toStringAsFixed(fractionDigits)`: 固定小数位数
- `toStringAsExponential([fractionDigits])`: 科学计数法
- `toStringAsPrecision(precision)`: 指定精度

#### 静态方法
- `parse(source)`: 解析字符串
- `tryParse(source)`: 安全解析字符串

## 扩展方法

### 类型转换扩展
```dart
extension IntExtensions on int {
  Int toCustomInt() => Int(this);
}

extension DoubleExtensions on double {
  Double toCustomDouble() => Double(this);
}

extension CustomIntExtensions on Int {
  int toBuiltinInt() => value;
}

extension CustomDoubleExtensions on Double {
  double toBuiltinDouble() => value;
}
```

### 混合类型操作
```dart
extension MixedOperations on Int {
  // Int + Double = Double
  Double operator +(Double other) => Double(value + other.value);
  Double operator -(Double other) => Double(value - other.value);
  Double operator *(Double other) => Double(value * other.value);
  Double operator /(Double other) => Double(value / other.value);
  Double operator ~/(Double other) => Double(value ~/ other.value);
  Double operator %(Double other) => Double(value % other.value);
  
  // 比较操作
  bool operator <(Double other) => value < other.value;
  bool operator <=(Double other) => value <= other.value;
  bool operator >(Double other) => value > other.value;
  bool operator >=(Double other) => value >= other.value;
}

extension MixedOperationsDouble on Double {
  // Double + Int = Double
  Double operator +(Int other) => Double(value + other.value.toDouble());
  Double operator -(Int other) => Double(value - other.value.toDouble());
  Double operator *(Int other) => Double(value * other.value.toDouble());
  Double operator /(Int other) => Double(value / other.value.toDouble());
  Double operator ~/(Int other) => Double((value ~/ other.value.toDouble()).toDouble());
  Double operator %(Int other) => Double(value % other.value.toDouble());
  
  // 比较操作
  bool operator <(Int other) => value < other.value.toDouble();
  bool operator <=(Int other) => value <= other.value.toDouble();
  bool operator >(Int other) => value > other.value.toDouble();
  bool operator >=(Int other) => value >= other.value.toDouble();
}
```

## 使用限制

### 不可重载的运算符
由于Dart语言限制，以下运算符无法重载：
- 自增自减: `++`, `--`
- 复合赋值: `+=`, `-=`, `*=`, `/=`, `~/=`, `%=`, `&=`, `|=`, `^=`, `<<=`, `>>=`

这些操作通过方法实现：
- `increment()`, `decrement()`
- `add()`, `subtract()`, `multiply()`, `divide()`, `divideTruncate()`, `modulo()`

### 缺失的方法
某些Dart内置方法在当前实现中不可用：
- `numberOfLeadingZeros()`, `numberOfTrailingZeros()` (int)
- `numberOfSetBits()`, `isPowerOfTwo` (int)
- `isEven`, `isOdd` (double)
- `isNegativeInfinity`, `isPositiveInfinity` (double)
- 三角函数: `acos()`, `asin()`, `atan()`, `atan2()`, `cos()`, `sin()`, `tan()`
- 其他数学函数: `exp()`, `log()`, `sqrt()`, `pow()`

## 使用示例

```dart
// 基本使用
final int1 = Int(42);
final double1 = Double(3.14);

// 算术运算
final sum = int1 + Int(8); // Int(50)
final product = double1 * Double(2.0); // Double(6.28)

// 混合类型运算
final mixed = int1 + double1; // Double(45.14)

// 类型转换
final builtinInt = int1.toBuiltinInt(); // 42
final customDouble = 3.14.toCustomDouble(); // Double(3.14)

// 字符串解析
final parsed = Int.parse('123'); // Int(123)
final parsedDouble = Double.tryParse('3.14'); // Double(3.14)

// 进制转换
final hex = Int(255).toHexString(); // 'ff'
final binary = Int(10).toBinaryString(); // '1010'
```

## 测试覆盖

创建了完整的测试套件，包括：
- 基本构造函数和转换测试
- 算术运算符测试
- 位运算符测试
- 比较运算符测试
- 数学函数测试
- 字符串转换测试
- 静态方法测试
- 混合类型操作测试
- 扩展方法测试

## 总结

自定义的 `Int` 和 `Double` 类提供了与Dart内置类型高度兼容的接口，支持：
1. 完整的算术和位运算
2. 类型转换和比较操作
3. 数学函数和常量
4. 字符串解析和格式化
5. 混合类型操作
6. 与内置类型的互操作

这些类可以用于需要自定义数字类型行为的场景，同时保持与Dart内置类型的兼容性。
