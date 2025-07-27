#ifndef _NUM_H_
#define _NUM_H_

#include "object.h"
#include "string.h"

// 前向声明
class Int;
class Double;
class Bool;

class Num : public Object {
 public:
  enum Type { INT_TYPE, DOUBLE_TYPE };
  Type type;
  union {
    int i;
    double d;
  } data;

  Num(int i) : type(INT_TYPE) { data.i = i; }
  Num(double d) : type(DOUBLE_TYPE) { data.d = d; }
  Num(const Int& i);     // 只声明，不定义
  Num(const Double& d);  // 只声明，不定义
  Num(const Num& n) : type(n.type), data(n.data) {}

  operator int() const {
    if (type == INT_TYPE) {
      return data.i;
    }
    return static_cast<int>(data.d);
  }

  operator double() const {
    if (type == DOUBLE_TYPE) {
      return data.d;
    }
    return static_cast<double>(data.i);
  }

  bool isInt() const { return type == INT_TYPE; }
  bool isDouble() const { return type == DOUBLE_TYPE; }
  int getInt() const { return data.i; }
  double getDouble() const { return data.d; }

  static Type* cppGet_runtimeType(Object* a);  // runtimeType getter
  static String* toString(Object* obj);        // 获取字符串表示
  static Int* hashCode(Object* obj);  // 获取哈希码// 处理不存在的方法调用

  // ==================== 基础方法（接受Num*参数） ====================
  static Num* cpp_unaryMinus(Num* a);
  static Num* cpp_add(Num* a, Num* b);
  static Num* cpp_subtract(Num* a, Num* b);
  static Num* cpp_multiply(Num* a, Num* b);
  static Num* cpp_divide(Num* a, Num* b);
  static Num* cpp_remainder(Num* a, Num* b);
  static Num* cpp_truncDiv(Num* a, Num* b);
  static Num* cpp_modulo(Num* a, Num* b);
  static Num* cpp_negation(Num* a);

  static Num* abs(Num* a);
  static Int* ceil(Num* a);      // ceil总是返回Int*
  static Int* floor(Num* a);     // floor总是返回Int*
  static Int* round(Num* a);     // round总是返回Int*
  static Int* truncate(Num* a);  // truncate总是返回Int*
  static Num* clamp(Num* a, Num* lower, Num* upper);
  static Bool* cpp_equals(Num* a, Num* b);
  static Int* cpp_compareTo(Num* a, Num* b);
  static Num* cpp_bitwiseNot(Num* a);  // 整数输入返回Int*，否则返回NaN
  static Num* cpp_increment(Num* a);
  static Num* cpp_decrement(Num* a);
  static Num* cpp_bitwiseOr(Num* a, Num* b);   // 整数输入返回Int*，否则返回NaN
  static Num* cpp_bitwiseAnd(Num* a, Num* b);  // 整数输入返回Int*，否则返回NaN
  static Num* cpp_bitwiseXor(Num* a, Num* b);  // 整数输入返回Int*，否则返回NaN
  static Num* cpp_leftShift(Num* a, Num* b);   // 整数输入返回Int*，否则返回NaN
  static Num* cpp_rightShift(Num* a, Num* b);  // 整数输入返回Int*，否则返回NaN
  static Bool* cpp_lessThan(Num* a, Num* b);
  static Bool* cpp_lessThanOrEqual(Num* a, Num* b);
  static Bool* cpp_greaterThan(Num* a, Num* b);
  static Bool* cpp_greaterThanOrEqual(Num* a, Num* b);

  // ==================== Int*参数的重载方法 ====================
  // 算术运算重载（Int* + Int* -> Int*，Int* + Double* -> Double*）
  static Int* cpp_unaryMinus(Int* a);
  static Int* cpp_add(Int* a, Int* b);
  static Int* cpp_subtract(Int* a, Int* b);
  static Int* cpp_multiply(Int* a, Int* b);
  static Double* cpp_divide(Int* a, Int* b);  // 整数除法返回Double
  static Int* cpp_remainder(Int* a, Int* b);
  static Int* cpp_truncDiv(Int* a, Int* b);
  static Int* cpp_modulo(Int* a, Int* b);
  static Int* abs(Int* a);
  static Int* cpp_increment(Int* a);
  static Int* cpp_decrement(Int* a);
  static Int* cpp_negation(Int* a);

  // 位运算重载（只对整数有效）
  static Int* cpp_bitwiseNot(Int* a);
  static Int* cpp_bitwiseOr(Int* a, Int* b);
  static Int* cpp_bitwiseAnd(Int* a, Int* b);
  static Int* cpp_bitwiseXor(Int* a, Int* b);
  static Int* cpp_leftShift(Int* a, Int* b);
  static Int* cpp_rightShift(Int* a, Int* b);

  // 数学函数重载
  static Int* ceil(Int* a);      // 整数的ceil还是整数
  static Int* floor(Int* a);     // 整数的floor还是整数
  static Int* round(Int* a);     // 整数的round还是整数
  static Int* truncate(Int* a);  // 整数的truncate还是整数
  static Int* clamp(Int* a, Int* lower, Int* upper);

  // 比较运算重载
  static Bool* cpp_equals(Int* a, Int* b);
  static Int* cpp_compareTo(Int* a, Int* b);
  static Bool* cpp_lessThan(Int* a, Int* b);
  static Bool* cpp_lessThanOrEqual(Int* a, Int* b);
  static Bool* cpp_greaterThan(Int* a, Int* b);
  static Bool* cpp_greaterThanOrEqual(Int* a, Int* b);

  // ==================== Double*参数的重载方法 ====================
  // 算术运算重载（Double* + Double* -> Double*）
  static Double* cpp_unaryMinus(Double* a);
  static Double* cpp_add(Double* a, Double* b);
  static Double* cpp_subtract(Double* a, Double* b);
  static Double* cpp_multiply(Double* a, Double* b);
  static Double* cpp_divide(Double* a, Double* b);
  static Double* cpp_remainder(Double* a, Double* b);
  static Double* cpp_modulo(Double* a, Double* b);
  static Double* cpp_negation(Double* a);
  static Double* abs(Double* a);
  static Double* cpp_increment(Double* a);
  static Double* cpp_decrement(Double* a);

  // 数学函数重载
  static Int* ceil(Double* a);
  static Int* floor(Double* a);
  static Int* round(Double* a);
  static Int* truncate(Double* a);  // truncate返回Int
  static Double* clamp(Double* a, Double* lower, Double* upper);

  // 比较运算重载
  static Bool* cpp_equals(Double* a, Double* b);
  static Int* cpp_compareTo(Double* a, Double* b);
  static Bool* cpp_lessThan(Double* a, Double* b);
  static Bool* cpp_lessThanOrEqual(Double* a, Double* b);
  static Bool* cpp_greaterThan(Double* a, Double* b);
  static Bool* cpp_greaterThanOrEqual(Double* a, Double* b);

  // ==================== 混合类型重载方法 ====================
  // Int* 和 Double* 混合运算（返回Double*）
  static Double* cpp_add(Int* a, Double* b);
  static Double* cpp_add(Double* a, Int* b);
  static Double* cpp_subtract(Int* a, Double* b);
  static Double* cpp_subtract(Double* a, Int* b);
  static Double* cpp_multiply(Int* a, Double* b);
  static Double* cpp_multiply(Double* a, Int* b);
  static Double* cpp_divide(Int* a, Double* b);
  static Double* cpp_divide(Double* a, Int* b);
  static Double* cpp_remainder(Int* a, Double* b);
  static Double* cpp_remainder(Double* a, Int* b);
  static Double* cpp_modulo(Int* a, Double* b);
  static Double* cpp_modulo(Double* a, Int* b);

  // 混合类型比较
  static Bool* cpp_equals(Int* a, Double* b);
  static Bool* cpp_equals(Double* a, Int* b);
  static Int* cpp_compareTo(Int* a, Double* b);
  static Int* cpp_compareTo(Double* a, Int* b);
  static Bool* cpp_lessThan(Int* a, Double* b);
  static Bool* cpp_lessThan(Double* a, Int* b);
  static Bool* cpp_lessThanOrEqual(Int* a, Double* b);
  static Bool* cpp_lessThanOrEqual(Double* a, Int* b);
  static Bool* cpp_greaterThan(Int* a, Double* b);
  static Bool* cpp_greaterThan(Double* a, Int* b);
  static Bool* cpp_greaterThanOrEqual(Int* a, Double* b);
  static Bool* cpp_greaterThanOrEqual(Double* a, Int* b);

  static Int* toInt(Num* a);
  static Double* toDouble(Num* a);
  static String* toString(Num* a);

  static Num* cppNew(int i);
  static Num* cppNew(double d);

  // ==================== 从Int类移动过来的方法 ====================
  static Int* bitLength(Int* a);
  static Bool* isEven(Int* a);
  static Bool* isOdd(Int* a);
  static Bool* isNegative(Int* a);

  // Getter方法 (使用cppGet前缀)
  static Int* cppGet_bitLength(Int* a);
  static Bool* cppGet_isEven(Int* a);
  static Bool* cppGet_isOdd(Int* a);
  static Bool* cppGet_isNegative(Int* a);

  static Int* parseInt(String* s, Int* radix = NULL);
  static String* toString(Int* a);

  // ==================== 从Double类移动过来的方法 ====================
  static Bool* isNaN(Double* a);
  static Bool* isInfinite(Double* a);
  static Bool* isFinite(Double* a);

  // Getter方法 (使用cppGet前缀)
  static Bool* cppGet_isNaN(Double* a);
  static Bool* cppGet_isInfinite(Double* a);
  static Bool* cppGet_isFinite(Double* a);

  static Double* atan(Double* a);
  static Double* acos(Double* a);
  static Double* asin(Double* a);
  static Double* atan2(Double* a, Double* b);

  static Double* parseDouble(String* s);
  static String* toString(Double* a);
};

class Int : public Num {
 public:
  Int() : Num(0) {}
  Int(int value) : Num(value) {}
  Int(const Int& other) : Num(other) {}

  // 访问数据使用基类的方法
  int getValue() const { return getInt(); }
  operator int() const { return getInt(); }

  static Int* cppNew(int i);
};

class Double : public Num {
 public:
  Double() : Num(0.0) {}
  Double(double value) : Num(value) {}
  Double(const Double& other) : Num(other) {}

  // 访问数据使用基类的方法
  double getValue() const { return getDouble(); }
  operator double() const { return getDouble(); }

  static Double* cppNew(int i);
  static Double* cppNew(double d);
};

class Bool : public Object {
 public:
  bool m_data;

  Bool() : m_data(false) {}
  Bool(bool value) : m_data(value) {}
  Bool(const Bool& other) : m_data(other.m_data) {}

  operator bool() const { return m_data; }

  bool getValue() const { return m_data; }
  String toString() const;

  static Bool* cpp_not(Bool* a);
  static Bool* cpp_equals(Bool* a, Bool* b);
  static Bool* cpp_bitwiseAnd(Bool* a, Bool* b);
  static Bool* cpp_bitwiseXor(Bool* a, Bool* b);
  static Bool* cpp_bitwiseOr(Bool* a, Bool* b);

  static Bool* cppNew(bool i);
  static String* toString(Bool* a);
};

#endif  // _NUM_H_
