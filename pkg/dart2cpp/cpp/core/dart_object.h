#ifndef _DART_OBJECT_H_
#define _DART_OBJECT_H_

#include <algorithm>
#include <cctype>
#include <chrono>
#include <climits>
#include <cmath>
#include <cstddef>
#include <cstdlib>
#include <functional>
#include <iostream>
#include <memory>
#include <sstream>
#include <stdexcept>
#include <thread>
#include <string>
#include <type_traits>
#include <unordered_map>
#include <unordered_set>
#include <utility>
#include <vector>
#include "dart_string.h"  // 包含ValueUnion定义
#include <type_traits>
#include <utility>
#include <cstdint>



// ============================================================================
// 前向声明
// ============================================================================

class Any;
class Int;
class Double;
class Bool;
class Object;
class CppUserData;
class Function;
class String;
class Duration;
// 前向声明测试中使用的类
class Shape;

// 容器类型前向声明
template <typename T>
class List;
template <typename T>
class Set;
template <typename K, typename V>
class Map;
template <typename T>
class ObjectPtr;

/**
 * type_id 
 * Void     00000000
 * Null     00000000
 * Int      00000001
 * Double   00000002
 * Bool     00000003
 * String   00000004
 * Object   00000005
 * UserData 00000006
 * ObjectPtr 00000007
 */

// ValueUnion已在dart_string.h中定义

// ============================================================================
// Any 基类
// ============================================================================

class Any {
 public:
  int type_id;
  ValueUnion value;

  // 构造函数
  Any() : type_id(0) { value.int_value = 0; }
  
  Any(const Any& other) : type_id(other.type_id), value(other.value) {}
  
  // 从基础类型构造
  Any(int v) : type_id(1) { value.int_value = v; }
  Any(double v) : type_id(2) { value.double_value = v; }
  Any(bool v) : type_id(3) { value.bool_value = v; }
  
  // 从String类型构造 - 声明在这里，实现在cpp文件中
  Any(const String& s);
  
  // 从ObjectPtr类型构造 - 模板构造函数
  template<typename T>
  Any(const ObjectPtr<T>& obj) : type_id(100) { 
    value.object_ptr = obj.get();
  }
  
  // 赋值运算符
  Any& operator=(const Any& other) {
    if (this != &other) {
      type_id = other.type_id;
      value = other.value;
    }
    return *this;
  }

  bool isNull() const {
    return (type_id == 0);
  }

  // 类型转换方法
  int toInt() const {
    switch (type_id) {
      case 1: return value.int_value;
      case 2: return static_cast<int>(value.double_value);
      case 3: return value.bool_value ? 1 : 0;
      default: return 0;
    }
  }
  
  double toDouble() const {
    switch (type_id) {
      case 1: return static_cast<double>(value.int_value);
      case 2: return value.double_value;
      case 3: return value.bool_value ? 1.0 : 0.0;
      default: return 0.0;
    }
  }
  
  bool toBool() const {
    switch (type_id) {
      case 1: return value.int_value != 0;
      case 2: return value.double_value != 0.0;
      case 3: return value.bool_value;
      default: return false;
    }
  }
  
  int getStringIndex() const {
    return (type_id == 4) ? value.string_index : 0;
  }
  
  void* getObjectPtr() const {
    return (type_id == 5 || type_id == 7) ? value.object_ptr : nullptr;
  }

  // 虚的 toString 方法，由子类实现
  virtual String toString() const;
  
  // 通用方法调用转发 - 用于dynamic类型的方法调用
  template<typename... Args>
  Any callMethod(const std::string& methodName, Args... args) const {
    // 这是一个简化的实现，实际实现需要根据type_id进行动态分发
    // 在这里我们只是返回一个默认的Any值
    return Any();
  }
  
  // 通用属性访问转发 - 用于dynamic类型的属性访问
  Any getProperty(const std::string& propertyName) const {
    // 这是一个简化的实现，实际实现需要根据type_id进行动态分发
    // 在这里我们只是返回一个默认的Any值
    return Any();
  }

  virtual ~Any() {}
};

// ============================================================================
// Nullable 类
// ============================================================================

class Nullable : public Any {
 public:
  Nullable() { type_id = 0; }
};

// 外部声明 Void 和 Null 实例
extern Nullable Void;
extern Nullable Null;

// ============================================================================
// 通用 Any 类型转换函数声明
// ============================================================================

// 通用的 Any 到具体类型的转换函数
template<typename T>
T convertFromAny(const Any& any);

// 通用的具体类型到 Any 的转换函数
template<typename T>
Any convertToAny(const T& value);

// ============================================================================
// 类型转换函数的特化声明
// ============================================================================

// Int 类型转换
template<>
inline Int convertFromAny<Int>(const Any& any);

template<>
inline Any convertToAny<Int>(const Int& value);

// Double 类型转换
template<>
inline Double convertFromAny<Double>(const Any& any);

template<>
inline Any convertToAny<Double>(const Double& value);

// Bool 类型转换
template<>
inline Bool convertFromAny<Bool>(const Any& any);

template<>
inline Any convertToAny<Bool>(const Bool& value);

// ObjectPtr 类型转换
template<typename T>
ObjectPtr<T> convertFromAny(const Any& any) {
  if (any.type_id == 7 || any.type_id == 5) {
    return ObjectPtr<T>(static_cast<T*>(any.getObjectPtr()));
  }
  return ObjectPtr<T>();
}

template<typename T>
Any convertToAny(const ObjectPtr<T>& value) {
  Any result;
  result.type_id = 7; // ObjectPtr type
  result.value.object_ptr = value.get();
  return result;
}

// 基础类型的直接转换
template<>
inline Any convertToAny<int>(const int& value) {
  return Any(value);
}

template<>
inline Any convertToAny<double>(const double& value) {
  return Any(value);
}

template<>
inline Any convertToAny<bool>(const bool& value) {
  return Any(value);
}

// 通用的 Any 到具体类型的转换函数（向后兼容）
template<typename T>
T convertAnyTo(const Any& any) {
  return convertFromAny<T>(any);
}

// ============================================================================
// Int 类声明
// ============================================================================

class Int : public Any {
 public:
  // 构造函数
  Int();
  Int(int v);
  Int(const Int& other);
  explicit Int(const Any& any);
  explicit Int(const Nullable&);  // NULL 构造函数

  // 拷贝赋值运算符
  Int& operator=(const Int& other);
  Int& operator=(const Any& any);
  Int& operator=(const Nullable&);  // NULL 赋值操作符

  // 获取值的便捷方法
  int getValue() const { return value.int_value; }

  // 算术运算符函数
  Int operator_add(const Int& other) const;
  Double operator_add(const Double& other) const;  // Int + Double = Double
  Int operator_sub(const Int& other) const;
  Double operator_sub(const Double& other) const;  // Int - Double = Double
  Int operator_mul(const Int& other) const;
  Double operator_mul(const Double& other) const;  // Int * Double = Double
  Int operator_div(const Int& other) const;
  Double operator_div(const Double& other) const;  // Int / Double = Double
  Int operator_mod(const Int& other) const;
  Int integerDivision(const Int& other) const;
  Int truncatingDivision(const Int& other) const;  // ~/ 运算符的方法形式

  // 标准算术运算符
  Int operator+(const Int& other) const;
  Int operator-(const Int& other) const;
  Int operator*(const Int& other) const;
  Int operator/(const Int& other) const;
  Int operator%(const Int& other) const;
  
  // 复合赋值运算符函数
  Int& operator_add_assign(const Int& other);
  Int& operator_sub_assign(const Int& other);
  Int& operator_mul_assign(const Int& other);
  Int& operator_div_assign(const Int& other);
  Int& operator_mod_assign(const Int& other);

  // 标准复合赋值运算符
  Int& operator+=(const Int& other);
  Int& operator-=(const Int& other);
  Int& operator*=(const Int& other);
  Int& operator/=(const Int& other);
  Int& operator%=(const Int& other);
  
  // 自增自减运算符函数
  Int& operator_increment();           // 前置++
  Int operator_post_increment();       // 后置++
  Int& operator_decrement();           // 前置--
  Int operator_post_decrement();       // 后置--

  // 标准自增自减运算符
  Int& operator++();    // 前置++
  Int operator++(int);  // 后置++
  Int& operator--();    // 前置--
  Int operator--(int);  // 后置--

  // Int 和 Double 混合运算
  Double operator+(const Double& other) const;
  Double operator-(const Double& other) const;
  Double operator*(const Double& other) const;
  Double operator/(const Double& other) const;

  // 位运算符函数
  Int operator_bitwise_and(const Int& other) const;
  Int operator_bitwise_or(const Int& other) const;
  Int operator_bitwise_xor(const Int& other) const;
  Int operator_shift_left(const Int& other) const;
  Int operator_shift_right(const Int& other) const;
  Int operator_bitwise_not() const;

  // 标准位运算符
  Int operator&(const Int& other) const;
  Int operator|(const Int& other) const;
  Int operator^(const Int& other) const;
  Int operator<<(const Int& other) const;
  Int operator>>(const Int& other) const;
  Int operator~() const;

  // 比较运算符函数
  Bool operator_equals(const Int& other) const;
  Bool operator_not_equals(const Int& other) const;
  Bool operator_less(const Int& other) const;
  Bool operator_less_equals(const Int& other) const;
  Bool operator_greater(const Int& other) const;
  Bool operator_greater_equals(const Int& other) const;

  // 标准比较运算符
  Bool operator==(const Int& other) const;
  Bool operator!=(const Int& other) const;
  Bool operator<(const Int& other) const;
  Bool operator<=(const Int& other) const;
  Bool operator>(const Int& other) const;
  Bool operator>=(const Int& other) const;

  // 一元运算符函数
  Int operator_unary_minus() const;
  Int operator_unary_plus() const;

  // 标准一元运算符
  Int operator-() const;
  Int operator+() const;

  // Dart 方法实现
  Int abs() const;
  String toString() const;
  Double toDouble() const;
  Int compareTo(const Int& other) const;
  Int gcd(const Int& other) const;

  // 属性方法
  Int get_sign() const;
  Bool get_isEven() const;
  Bool get_isOdd() const;
  Bool get_isNegative() const;
  Bool get_isFinite() const;
  Bool get_isInfinite() const;
  Bool get_isNaN() const;

  // 显式类型转换方法
  int toInt() const;
  bool toBool() const;

  // 一元负号运算符（方法调用形式）
  Int operator_negate() const;

  // 箭头运算符重载，返回指向自身的指针
  Int* operator->() { return this; }
  const Int* operator->() const { return this; }

  // 修复#6: parse 静态方法
  static Int parse(const String& source);
  static Int parse(const String& source, const Int& radix);
  static Int tryParse(const String& source);

  // 修复#11: toRadixString 方法
  String toRadixString(const Int& radix) const;
};

// ============================================================================
// Double 类声明
// ============================================================================

class Double : public Any {
 public:
  // 构造函数
  Double();
  Double(double v);
  Double(const Double& other);
  Double(const Int& other);
  explicit Double(const Any& any);
  explicit Double(const Nullable&);  // NULL 构造函数

  // 拷贝赋值运算符
  Double& operator=(const Double& other);
  Double& operator=(const Any& any);
  Double& operator=(const Nullable&);  // NULL 赋值操作符

  // 获取值的便捷方法
  double getValue() const { return value.double_value; }

  // 算术运算符函数
  Double operator_add(const Double& other) const;
  Double operator_add(const Int& other) const;     // Double + Int = Double
  Double operator_sub(const Double& other) const;
  Double operator_sub(const Int& other) const;     // Double - Int = Double
  Double operator_mul(const Double& other) const;
  Double operator_mul(const Int& other) const;     // Double * Int = Double
  Double operator_div(const Double& other) const;
  Double operator_div(const Int& other) const;     // Double / Int = Double
  Double operator_mod(const Double& other) const;

  // 标准算术运算符
  Double operator+(const Double& other) const;
  Double operator-(const Double& other) const;
  Double operator*(const Double& other) const;
  Double operator/(const Double& other) const;
  Double operator%(const Double& other) const;
  
  // 复合赋值运算符函数
  Double& operator_add_assign(const Double& other);
  Double& operator_sub_assign(const Double& other);
  Double& operator_mul_assign(const Double& other);
  Double& operator_div_assign(const Double& other);
  Double& operator_mod_assign(const Double& other);

  // 标准复合赋值运算符
  Double& operator+=(const Double& other);
  Double& operator-=(const Double& other);
  Double& operator*=(const Double& other);
  Double& operator/=(const Double& other);
  Double& operator%=(const Double& other);
  
  // 自增自减运算符函数
  Double& operator_increment();           // 前置++
  Double operator_post_increment();       // 后置++
  Double& operator_decrement();           // 前置--
  Double operator_post_decrement();       // 后置--

  // 标准自增自减运算符
  Double& operator++();    // 前置++
  Double operator++(int);  // 后置++
  Double& operator--();    // 前置--
  Double operator--(int);  // 后置--

  // 比较运算符函数
  Bool operator_equals(const Double& other) const;
  Bool operator_not_equals(const Double& other) const;
  Bool operator_less(const Double& other) const;
  Bool operator_less_equals(const Double& other) const;
  Bool operator_greater(const Double& other) const;
  Bool operator_greater_equals(const Double& other) const;

  // 标准比较运算符
  Bool operator==(const Double& other) const;
  Bool operator!=(const Double& other) const;
  Bool operator<(const Double& other) const;
  Bool operator<=(const Double& other) const;
  Bool operator>(const Double& other) const;
  Bool operator>=(const Double& other) const;

  // 一元运算符函数
  Double operator_unary_minus() const;
  Double operator_unary_plus() const;
  Double operator_negate() const;  // 方法调用形式的一元负号

  // 标准一元运算符
  Double operator-() const;
  Double operator+() const;

  // Dart 方法实现
  Double abs() const;
  String toString() const;
  String toStringAsFixed(const Int& digits) const;
  Int toInt() const;
  Double floor() const;
  Double ceil() const;
  Double round() const;
  Double truncate() const;
  Int compareTo(const Double& other) const;

  // 属性方法
  Int get_sign() const;
  Bool get_isNegative() const;
  Bool get_isFinite() const;
  Bool get_isInfinite() const;
  Bool get_isNaN() const;

  // 显式类型转换方法
  double toDouble() const;
  Bool toBool() const;

  // 箭头运算符重载，返回指向自身的指针
  Double* operator->() { return this; }
  const Double* operator->() const { return this; }

  // 修复#6: parse 静态方法
  static Double parse(const String& source);
  static Double tryParse(const String& source);

  // 修复#7: NaN 和 Infinity 静态常量
  static const Double nan;
  static const Double infinity;
  static const Double negativeInfinity;
  static const Double minPositive;
  static const Double maxFinite;
};

// ============================================================================
// Bool 类声明
// ============================================================================

class Bool : public Any {
 public:
  // 构造函数
  Bool();
  Bool(bool v);
  Bool(const Bool& other);
  explicit Bool(const Any& any);
  explicit Bool(const Nullable&);  // NULL 构造函数

  // 拷贝赋值运算符
  Bool& operator=(const Bool& other);
  Bool& operator=(const Any& any);
  Bool& operator=(const Nullable&);  // NULL 赋值操作符

  // 获取值的便捷方法
  bool getValue() const { return value.bool_value; }

  // 逻辑运算符函数
  Bool operator_and(const Bool& other) const;
  Bool operator_or(const Bool& other) const;
  Bool operator_not() const;

  // 标准逻辑运算符
  Bool operator&&(const Bool& other) const;
  Bool operator||(const Bool& other) const;
  Bool operator!() const;

  // 比较运算符函数
  Bool operator_equals(const Bool& other) const;
  Bool operator_not_equals(const Bool& other) const;

  // 标准比较运算符
  Bool operator==(const Bool& other) const;
  Bool operator!=(const Bool& other) const;

  // Dart 方法实现
  String toString() const;
  Int compareTo(const Bool& other) const;

  // 类型转换运算符 - 允许直接用作条件判断
  operator bool() const;

  // 显式类型转换方法
  bool toBool() const;
  Int toInt() const;

  // 箭头运算符重载，返回指向自身的指针
  Bool* operator->() { return this; }
  const Bool* operator->() const { return this; }
};

// ============================================================================
// Object 类声明
// ============================================================================

class Object : public Any {
 protected:
  int ref_count;

 public:
  Object();  // 初始引用计数为1
  Object(const Object& other);
  Object& operator=(const Object& other);

  // 引用计数管理
  void increment();
  void decrement();
  int getRefCount() const;

  // 修复#9: Object::hash 静态方法
  static Int hash(const Any& object);
  static Int hashAll(const std::vector<Any>& objects);
};

// ============================================================================
// Exception 基类 (修复#5)
// ============================================================================

class Exception : public Object {
protected:
  String message_;

public:
  Exception();
  Exception(const String& message);
  virtual ~Exception() = default;

  // 获取异常信息
  virtual String getMessage() const;
  virtual String toString() const override;

  // 静态创建方法
  static ObjectPtr<Exception> create(const String& message);
};

// FormatException - 格式异常
class FormatException : public Exception {
public:
  FormatException();
  FormatException(const String& message);
  String toString() const override;
  static ObjectPtr<FormatException> create(const String& message);
};

// StateError - 状态错误
class StateError : public Exception {
public:
  StateError();
  StateError(const String& message);
  String toString() const override;
  static ObjectPtr<StateError> create(const String& message);
};

// ArgumentError - 参数错误
class ArgumentError : public Exception {
public:
  ArgumentError();
  ArgumentError(const String& message);
  String toString() const override;
  static ObjectPtr<ArgumentError> create(const String& message);
};

// RangeError - 范围错误
class RangeError : public Exception {
public:
  RangeError();
  RangeError(const String& message);
  String toString() const override;
  static ObjectPtr<RangeError> create(const String& message);
};

// ============================================================================
// CppUserData 类声明
// ============================================================================

class CppUserData : public Any {
 private:
  void* data;
  int* ref_count;  // 指向引用计数的指针

 public:
  // 构造函数
  CppUserData();
  CppUserData(void* external_data);       // 持有外部数据
  CppUserData(int length);                // 分配新内存
  CppUserData(const CppUserData& other);  // 拷贝构造，共享引用
  ~CppUserData();

  // 不允许赋值操作（避免复杂性）
  CppUserData& operator=(const CppUserData& other) = delete;

  // 数据访问
  void* getData() const;
  int getRefCount() const;

  // Dart 方法实现
  String toString() const;
};

// ============================================================================
// Function 类声明
// ============================================================================

// Function类 - 函数类型的基础类型
// 内部有一个虚方法apply，接收std::vector<Any>并返回Any
// 作为通用的函数扩展调用接口
class Function : public Object {
public:
  Function();
  virtual ~Function();
  
  // 虚方法apply - 通用函数调用接口
  // 接收std::vector<Any>参数列表，返回Any结果
  virtual Any apply(const std::vector<Any>& args) = 0;
  
  // 辅助方法
  Bool isNull() const;
  String toString() const override;
};

// TypedFunction模板类 - 统一支持std::function和lambda对象
// 继承自Function，实现apply方法
// 限制参数类型以及返回值
template<typename F, typename R, typename... Args>
class TypedFunction : public Function {
private:
  F func_;
  
public:
  // 构造函数 - 支持任意可调用对象
  template<typename FuncType>
  TypedFunction(FuncType&& func) : func_(std::forward<FuncType>(func)) {}
  
  // 实现apply方法 - 直接转换参数并调用，不做边界检查
  Any apply(const std::vector<Any>& args) override {
    return applyImpl(args, std::index_sequence_for<Args...>{});
  }
  
  // 重载 operator() - 直接调用存储的函数对象
  R operator()(Args... args) {
    return func_(std::forward<Args>(args)...);
  }
  
  // call 方法 - 效果和 operator() 一样，使用 ->call 调用函数
  R call(Args... args) {
    return func_(std::forward<Args>(args)...);
  }
  
private:
  // 使用索引序列展开参数并调用
  template<std::size_t... I>
  Any applyImpl(const std::vector<Any>& args, std::index_sequence<I...>) {
    if constexpr (std::is_void_v<R>) {
      func_(static_cast<Args>(args[I])...);
      return Any();
    } else {
      return Any(func_(static_cast<Args>(args[I])...));
    }
  }
};

// 为了向后兼容，保留原始的TypedFunction特化版本（只接受std::function）
template<typename R, typename... Args>
class TypedFunction<std::function<R(Args...)>, R, Args...> : public Function {
private:
  std::function<R(Args...)> func_;
  
public:
  // 构造函数
  TypedFunction(std::function<R(Args...)> func) : func_(std::move(func)) {}
  
  // 实现apply方法
  Any apply(const std::vector<Any>& args) override {
    return applyImpl(args, std::index_sequence_for<Args...>{});
  }
  
  // 重载 operator()
  R operator()(Args... args) {
    return func_(std::forward<Args>(args)...);
  }
  
  // call 方法 - 效果和 operator() 一样，使用 ->call 调用函数
  R call(Args... args) {
    return func_(std::forward<Args>(args)...);
  }
  
private:
  template<std::size_t... I>
  Any applyImpl(const std::vector<Any>& args, std::index_sequence<I...>) {
    if constexpr (std::is_void_v<R>) {
      func_(static_cast<Args>(args[I])...);
      return Any();
    } else {
      return Any(func_(static_cast<Args>(args[I])...));
    }
  }
};

// makeFunction实现已移至文件末尾

// ============================================================================
// 容器类型声明
// ============================================================================

// ============================================================================
// 迭代器包装类型
// ============================================================================

// List迭代器
template <typename T>
class ListIterator : public Object {
 private:
  typename std::vector<T>::iterator current_;
  typename std::vector<T>::iterator end_;

 public:
  ListIterator(typename std::vector<T>::iterator begin,
               typename std::vector<T>::iterator end);

  // 检查是否还有下一个元素
  Bool hasNext() const;

  // 获取下一个元素
  T next();

  // 获取当前元素（不移动迭代器）
  T current() const;

  // 重置到开始位置
  void reset(typename std::vector<T>::iterator begin);
};

// Set迭代器
template <typename T>
class SetIterator : public Object {
 private:
  typename std::unordered_set<T>::iterator current_;
  typename std::unordered_set<T>::iterator end_;

 public:
  SetIterator(typename std::unordered_set<T>::iterator begin,
              typename std::unordered_set<T>::iterator end);

  Bool hasNext() const;
  T next();
  T current() const;
  void reset(typename std::unordered_set<T>::iterator begin);
};

// Map迭代器
template <typename K, typename V>
class MapIterator : public Object {
 private:
  typename std::unordered_map<K, V>::iterator current_;
  typename std::unordered_map<K, V>::iterator end_;

 public:
  MapIterator(typename std::unordered_map<K, V>::iterator begin,
              typename std::unordered_map<K, V>::iterator end);

  Bool hasNext() const;
  void next();
  K currentKey() const;
  V currentValue() const;
  void reset(typename std::unordered_map<K, V>::iterator begin);
};

// ============================================================================
// ObjectPtr 智能指针类型
// ============================================================================

template <typename T>
class ObjectPtr {
 private:
  T* ptr_;

 public:
  // 构造函数
  ObjectPtr();
  ObjectPtr(T* ptr);
  ObjectPtr(const ObjectPtr<T>& other);
  ObjectPtr(ObjectPtr<T>&& other) noexcept;

  // 析构函数
  ~ObjectPtr();

  // 赋值运算符
  ObjectPtr<T>& operator=(const ObjectPtr<T>& other);
  ObjectPtr<T>& operator=(ObjectPtr<T>&& other) noexcept;
  ObjectPtr<T>& operator=(T* ptr);

  // 访问运算符
  T& operator*() const;
  T* operator->() const;

  // 比较运算符
  Bool operator==(const ObjectPtr<T>& other) const;
  Bool operator!=(const ObjectPtr<T>& other) const;
  Bool operator==(std::nullptr_t) const;
  Bool operator!=(std::nullptr_t) const;

  // 获取原始指针
  T* get() const;

  // 检查是否为空
  Bool isNull() const;

  // 重置指针
  void reset(T* ptr = nullptr);

  // 释放所有权
  T* release();

  // 类型转换
  template <typename U>
  ObjectPtr<U> cast() const;

  // 静态创建方法
  template <typename... Args>
  static ObjectPtr<T> create(Args&&... args);

  String toString() const;
};


// Lambda类型推导辅助结构
template<typename T>
struct lambda_traits;

// 特化：推导lambda的函数签名
template<typename F>
struct lambda_traits : lambda_traits<decltype(&F::operator())> {};

// 特化：从成员函数指针提取签名
template<typename C, typename R, typename... Args>
struct lambda_traits<R(C::*)(Args...) const> {
    using return_type = R;
    using args_tuple = std::tuple<Args...>;
    static constexpr size_t arity = sizeof...(Args);
};

// 特化：非const lambda
template<typename C, typename R, typename... Args>
struct lambda_traits<R(C::*)(Args...)> {
    using return_type = R;
    using args_tuple = std::tuple<Args...>;
    static constexpr size_t arity = sizeof...(Args);
};

// makeFunction 模板函数 - 自动推导 lambda 的参数类型，返回具体的TypedFunction类型
template<typename F>
auto makeFunction(F&& lambda) {
    // 推导lambda的返回类型和参数类型
    using traits = lambda_traits<std::decay_t<F>>;
    using return_type = typename traits::return_type;
    using args_tuple = typename traits::args_tuple;
    
    // 使用辅助函数创建TypedFunction
    return makeFunctionHelper(std::forward<F>(lambda), args_tuple{});
}

// 辅助函数：从参数tuple创建TypedFunction
template<typename F, typename... Args>
auto makeFunctionHelper(F&& lambda, std::tuple<Args...>) {
    using traits = lambda_traits<std::decay_t<F>>;
    using return_type = typename traits::return_type;
    using TypedFuncType = TypedFunction<std::decay_t<F>, return_type, Args...>;
    return ObjectPtr<TypedFuncType>(new TypedFuncType(std::forward<F>(lambda)));
}

// makeFunction 函数指针重载 - 支持普通函数指针
// 将函数指针转换为 std::function，然后创建 TypedFunction
template<typename R, typename... Args>
auto makeFunction(R (*func)(Args...)) {
    // 将函数指针包装为 std::function
    std::function<R(Args...)> stdFunc(func);
    // 使用 std::function 特化版本的 TypedFunction
    using TypedFuncType = TypedFunction<std::function<R(Args...)>, R, Args...>;
    return ObjectPtr<TypedFuncType>(new TypedFuncType(std::move(stdFunc)));
}

// ============================================================================
// List 容器类型
// ============================================================================

template <typename T>
class List : public Object {
 private:
  std::vector<T> data_;

 public:
  // 构造函数
  List();
  List(const List<T>& other);
  List(std::initializer_list<T> init);

  // 赋值运算符
  List<T>& operator=(const List<T>& other);

  // 元素访问
  T& operator[](const Int& index);
  const T& operator[](const Int& index) const;
  T get(const Int& index) const;
  void set(const Int& index, const T& value);
  
  // 索引运算符方法
  T operator_index(const Int& index) const;
  void operator_index_set(const Int& index, const T& value);

  // 容量相关
  Int size() const;
  Int get_length() const;
  Bool isEmpty() const;
  Bool isNotEmpty() const;

  // 修改操作
  void add(const T& item);
  void addAll(const ObjectPtr<List<T>>& items);  // 添加所有元素
  void insert(const Int& index, const T& item);
  void insertAll(const Int& index, const ObjectPtr<List<T>>& items);  // 插入所有元素
  Bool remove(const T& item);
  Bool removeElement(const T& item);  // 别名
  T removeAt(const Int& index);
  T removeLast();  // 移除最后一个元素
  void clear();
  void sort();  // 排序方法（默认排序）
  
  // 排序方法（自定义比较函数）
  // compare 函数返回值：< 0 表示 a < b，0 表示 a == b，> 0 表示 a > b
  template<typename CompareFunc>
  void sort(CompareFunc compare);
  void reverse();  // 原地反转

  // 查找操作
  Int indexOf(const T& item) const;
  Int lastIndexOf(const T& item) const;
  Bool contains(const T& item) const;
  
  // 访问方法
  T first() const;
  T last() const;
  
  // 转换方法
  ObjectPtr<List<T>> take(const Int& n) const;
  ObjectPtr<List<T>> skip(const Int& n) const;
  ObjectPtr<List<T>> toList() const;

  // 迭代器
  ObjectPtr<ListIterator<T>> iterator() const;

  // 转换操作
  ObjectPtr<List<T>> sublist(const Int& start, const Int& end) const;
  ObjectPtr<List<T>> subList(const Int& start, const Int& end) const;  // 别名
  ObjectPtr<List<T>> reversed() const;

  // 函数式操作
  template <typename R, typename MapperFunc>
  ObjectPtr<List<R>> map(const ObjectPtr<TypedFunction<MapperFunc, R, T>>& mapper) const;
  
  template <typename PredicateFunc>
  ObjectPtr<List<T>> where(const ObjectPtr<TypedFunction<PredicateFunc, Bool, T>>& predicate) const;
  
  template <typename CombineFunc>
  T reduce(const ObjectPtr<TypedFunction<CombineFunc, T, T, T>>& combine) const;
  
  template <typename R, typename CombineFunc>
  R fold(const R& initialValue, const ObjectPtr<TypedFunction<CombineFunc, R, R, T>>& combine) const;

  // 静态创建方法
  static ObjectPtr<List<T>> create();
  static ObjectPtr<List<T>> create(const List<T>& other);
  static ObjectPtr<List<T>> create(std::initializer_list<T> init);
  static ObjectPtr<List<T>> createFromValues(std::initializer_list<T> values);

  // 修复#13: List.from 和 List.of 静态工厂方法
  template<typename Iterable>
  static ObjectPtr<List<T>> from(const ObjectPtr<Iterable>& source);
  template<typename Iterable>
  static ObjectPtr<List<T>> of(const ObjectPtr<Iterable>& source);
  static ObjectPtr<List<T>> filled(const Int& length, const T& fill);
  static ObjectPtr<List<T>> generate(const Int& length, std::function<T(Int)> generator);

  // Dart 方法实现
  String toString() const override;
};

// ============================================================================
// List 模板方法实现
// ============================================================================

template <typename T>
template <typename R, typename MapperFunc>
ObjectPtr<List<R>> List<T>::map(const ObjectPtr<TypedFunction<MapperFunc, R, T>>& mapper) const {
  auto result = ObjectPtr<List<R>>(new List<R>());
  for (const auto& item : data_) {
    result->add(mapper->call(item));
  }
  return result;
}

template <typename T>
template <typename PredicateFunc>
ObjectPtr<List<T>> List<T>::where(const ObjectPtr<TypedFunction<PredicateFunc, Bool, T>>& predicate) const {
  auto result = ObjectPtr<List<T>>(new List<T>());
  for (const auto& item : data_) {
    if (predicate->call(item)->toBool()) {
      result->add(item);
    }
  }
  return result;
}

// ============================================================================
// Set 容器类型
// ============================================================================

template <typename T>
class Set : public Object {
 private:
  std::unordered_set<T> data_;

 public:
  // 构造函数
  Set();
  Set(const Set<T>& other);
  Set(std::initializer_list<T> init);

  // 赋值运算符
  Set<T>& operator=(const Set<T>& other);

  // 容量相关
  Int size() const;
  Int get_length() const;
  Bool isEmpty() const;
  Bool isNotEmpty() const;

  // 修改操作
  Bool add(const T& item);
  Bool remove(const T& item);
  void clear();

  // 查找操作
  Bool contains(const T& item) const;

  // 集合操作
  ObjectPtr<Set<T>> union_(const ObjectPtr<Set<T>>& other) const;
  ObjectPtr<Set<T>> intersection(const ObjectPtr<Set<T>>& other) const;
  ObjectPtr<Set<T>> difference(const ObjectPtr<Set<T>>& other) const;

  // 迭代器
  ObjectPtr<SetIterator<T>> iterator() const;

  // 转换操作
  ObjectPtr<List<T>> toList() const;

  // 静态创建方法
  static ObjectPtr<Set<T>> create();
  static ObjectPtr<Set<T>> create(const Set<T>& other);
  static ObjectPtr<Set<T>> create(std::initializer_list<T> init);

  // Dart 方法实现
  String toString() const override;
};

// ============================================================================
// Map 容器类型
// ============================================================================

template <typename K, typename V>
class Map : public Object {
 private:
  std::unordered_map<K, V> data_;

 public:
  // 构造函数
  Map();
  Map(const Map<K, V>& other);
  Map(std::initializer_list<std::pair<K, V>> init);

  // 赋值运算符
  Map<K, V>& operator=(const Map<K, V>& other);

  // 元素访问
  V& operator[](const K& key);
  const V& operator[](const K& key) const;
  V get(const K& key) const;
  void set(const K& key, const V& value);
  
  // 索引运算符方法
  V operator_index(const K& key) const;
  void operator_index_set(const K& key, const V& value);

  // 容量相关
  Int size() const;
  Int get_length() const;
  Bool isEmpty() const;
  Bool isNotEmpty() const;

  // 修改操作
  void put(const K& key, const V& value);
  Bool remove(const K& key);
  void clear();

  // 查找操作
  Bool containsKey(const K& key) const;
  Bool containsValue(const V& value) const;

  // 获取键值集合
  ObjectPtr<Set<K>> keys() const;
  ObjectPtr<List<V>> values() const;

  // 迭代器
  ObjectPtr<MapIterator<K, V>> iterator() const;

  // 静态创建方法
  static ObjectPtr<Map<K, V>> create();
  static ObjectPtr<Map<K, V>> create(const Map<K, V>& other);
  static ObjectPtr<Map<K, V>> create(std::initializer_list<std::pair<K, V>> init);
  static ObjectPtr<Map<K, V>> createFromEntries(std::initializer_list<std::pair<K, V>> entries);

  // Dart 方法实现
  String toString() const override;
};

// ============================================================================
// StringBuffer 类 - 字符串构建器
// ============================================================================

class StringBuffer : public Object {
private:
  std::string buffer_;

public:
  StringBuffer();
  StringBuffer(const String& initial);
  virtual ~StringBuffer() = default;

  // 核心方法
  void write(const String& str);
  void writeln(const String& str = String(""));
  void writeAll(const std::vector<String>& objects, const String& separator = String(""));
  void clear();
  
  // 查询方法
  Int length() const;
  Bool isEmpty() const;
  Bool isNotEmpty() const;
  
  // 转换方法
  String toString() const override;
  
  // 静态创建方法
  static ObjectPtr<StringBuffer> create();
  static ObjectPtr<StringBuffer> create(const String& initial);
};

// ============================================================================
// RegExp 类 - 正则表达式
// ============================================================================

class RegExp : public Object {
private:
  std::string pattern_;
  bool caseSensitive_;
  bool multiLine_;
  bool dotAll_;

public:
  RegExp(const String& pattern, bool caseSensitive = true, bool multiLine = false, bool dotAll = false);
  virtual ~RegExp() = default;

  // 核心方法
  Bool hasMatch(const String& input);
  String stringMatch(const String& input);
  Int matchAsPrefix(const String& string, Int start = Int(0));
  
  // 属性
  String pattern() const;
  Bool isCaseSensitive() const;
  Bool isMultiLine() const;
  Bool isDotAll() const;
  
  String toString() const override;
  
  // 静态创建方法
  static ObjectPtr<RegExp> create(const String& pattern);
  static ObjectPtr<RegExp> create(const String& pattern, bool caseSensitive, bool multiLine = false, bool dotAll = false);
};

// ============================================================================
// Timer 类 - 定时器
// ============================================================================

class Timer : public Object {
private:
  bool isActive_;
  
public:
  Timer();
  virtual ~Timer() = default;
  
  // 核心方法
  void cancel();
  Bool isActive() const;
  
  String toString() const override;
  
  // 静态工厂方法
  template<typename CallbackFunc>
  static ObjectPtr<Timer> periodic(const ObjectPtr<Duration>& duration, ObjectPtr<TypedFunction<CallbackFunc, void, ObjectPtr<Timer>>> callback);
  
  template<typename CallbackFunc>  
  static void run(ObjectPtr<TypedFunction<CallbackFunc, void>> callback);
  
  // 延迟执行 - 支持延迟调用 (实现在cpp文件中)
  template<typename CallbackFunc>
  static ObjectPtr<Timer> delayed(const ObjectPtr<Duration>& duration, ObjectPtr<TypedFunction<CallbackFunc, void>> callback);
  
  static ObjectPtr<Timer> create();
};

// ============================================================================
// 模板类实现部分
// ============================================================================

// ListIterator 实现
template<typename T>
ListIterator<T>::ListIterator(typename std::vector<T>::iterator begin,
                              typename std::vector<T>::iterator end)
    : current_(begin), end_(end) {}

template<typename T>
Bool ListIterator<T>::hasNext() const {
  return Bool(current_ != end_);
}

template<typename T>
T ListIterator<T>::next() {
  if (current_ == end_) {
    throw std::runtime_error("Iterator out of range");
  }
  return *current_++;
}

template<typename T>
T ListIterator<T>::current() const {
  if (current_ == end_) {
    throw std::runtime_error("Iterator out of range");
  }
  return *current_;
}

template<typename T>
void ListIterator<T>::reset(typename std::vector<T>::iterator begin) {
  current_ = begin;
}

// ObjectPtr 实现
template<typename T>
ObjectPtr<T>::ObjectPtr() : ptr_(nullptr) {}

template<typename T>
ObjectPtr<T>::ObjectPtr(T* ptr) : ptr_(ptr) {}

template<typename T>
ObjectPtr<T>::ObjectPtr(const ObjectPtr<T>& other) : ptr_(other.ptr_) {}

template<typename T>
ObjectPtr<T>::ObjectPtr(ObjectPtr<T>&& other) noexcept : ptr_(other.ptr_) {
  other.ptr_ = nullptr;
}

template<typename T>
ObjectPtr<T>::~ObjectPtr() {
  // 简化版本：不自动删除，由外部管理
}

template<typename T>
ObjectPtr<T>& ObjectPtr<T>::operator=(const ObjectPtr<T>& other) {
  if (this != &other) {
    ptr_ = other.ptr_;
  }
  return *this;
}

template<typename T>
ObjectPtr<T>& ObjectPtr<T>::operator=(ObjectPtr<T>&& other) noexcept {
  if (this != &other) {
    ptr_ = other.ptr_;
    other.ptr_ = nullptr;
  }
  return *this;
}

template<typename T>
ObjectPtr<T>& ObjectPtr<T>::operator=(T* ptr) {
  ptr_ = ptr;
  return *this;
}

template<typename T>
T& ObjectPtr<T>::operator*() const {
  return *ptr_;
}

template<typename T>
T* ObjectPtr<T>::operator->() const {
  return ptr_;
}

template<typename T>
Bool ObjectPtr<T>::operator==(const ObjectPtr<T>& other) const {
  return Bool(ptr_ == other.ptr_);
}

template<typename T>
Bool ObjectPtr<T>::operator!=(const ObjectPtr<T>& other) const {
  return Bool(ptr_ != other.ptr_);
}

template<typename T>
Bool ObjectPtr<T>::operator==(std::nullptr_t) const {
  return Bool(ptr_ == nullptr);
}

template<typename T>
Bool ObjectPtr<T>::operator!=(std::nullptr_t) const {
  return Bool(ptr_ != nullptr);
}

template<typename T>
T* ObjectPtr<T>::get() const {
  return ptr_;
}

template<typename T>
Bool ObjectPtr<T>::isNull() const {
  return Bool(ptr_ == nullptr);
}

template<typename T>
void ObjectPtr<T>::reset(T* ptr) {
  ptr_ = ptr;
}

template<typename T>
T* ObjectPtr<T>::release() {
  T* temp = ptr_;
  ptr_ = nullptr;
  return temp;
}


template<typename T>
String ObjectPtr<T>::toString() const {
  return ((T*)ptr_)->toString();
}

template<typename T>
template<typename U>
ObjectPtr<U> ObjectPtr<T>::cast() const {
  return ObjectPtr<U>(dynamic_cast<U*>(ptr_));
}

template<typename T>
template<typename... Args>
ObjectPtr<T> ObjectPtr<T>::create(Args&&... args) {
  return ObjectPtr<T>(new T(std::forward<Args>(args)...));
}

// List 实现
template<typename T>
List<T>::List() {}

template<typename T>
List<T>::List(const List<T>& other) : data_(other.data_) {}

template<typename T>
List<T>::List(std::initializer_list<T> init) : data_(init) {}

template<typename T>
List<T>& List<T>::operator=(const List<T>& other) {
  if (this != &other) {
    data_ = other.data_;
  }
  return *this;
}

template<typename T>
T& List<T>::operator[](const Int& index) {
  return data_[index.toInt()];
}

template<typename T>
const T& List<T>::operator[](const Int& index) const {
  return data_[index.toInt()];
}

template<typename T>
T List<T>::get(const Int& index) const {
  return data_[index.toInt()];
}

template<typename T>
void List<T>::set(const Int& index, const T& value) {
  data_[index.toInt()] = value;
}

template<typename T>
T List<T>::operator_index(const Int& index) const {
  return data_[index.toInt()];
}

template<typename T>
void List<T>::operator_index_set(const Int& index, const T& value) {
  data_[index.toInt()] = value;
}

template<typename T>
Int List<T>::size() const {
  return Int(static_cast<int>(data_.size()));
}

template<typename T>
Int List<T>::get_length() const {
  return size();
}

template<typename T>
Bool List<T>::isEmpty() const {
  return Bool(data_.empty());
}

template<typename T>
Bool List<T>::isNotEmpty() const {
  return Bool(!data_.empty());
}

template<typename T>
void List<T>::add(const T& item) {
  data_.push_back(item);
}

template<typename T>
void List<T>::insert(const Int& index, const T& item) {
  data_.insert(data_.begin() + index.toInt(), item);
}

template<typename T>
Bool List<T>::remove(const T& item) {
  auto it = std::find(data_.begin(), data_.end(), item);
  if (it != data_.end()) {
    data_.erase(it);
    return Bool(true);
  }
  return Bool(false);
}

template<typename T>
Bool List<T>::removeElement(const T& item) {
  return remove(item);
}

template<typename T>
T List<T>::removeAt(const Int& index) {
  T item = data_[index.toInt()];
  data_.erase(data_.begin() + index.toInt());
  return item;
}

template<typename T>
void List<T>::clear() {
  data_.clear();
}

template<typename T>
void List<T>::sort() {
  std::sort(data_.begin(), data_.end());
}

template<typename T>
template<typename CompareFunc>
void List<T>::sort(CompareFunc compare) {
  // 将 Dart 风格的比较函数（返回 int）转换为 C++ 风格（返回 bool）
  std::sort(data_.begin(), data_.end(), 
    [&compare](const T& a, const T& b) {
      // Dart 比较函数返回：< 0 (a < b), 0 (a == b), > 0 (a > b)
      // C++ 需要：true (a < b), false (a >= b)
      auto result = compare(a, b);
      // 如果 result 是 Int 类型，需要转换为 int
      if constexpr (std::is_same_v<decltype(result), Int>) {
        return result.toInt() < 0;
      } else {
        return result < 0;
      }
    }
  );
}

template<typename T>
void List<T>::reverse() {
  std::reverse(data_.begin(), data_.end());
}

template<typename T>
Int List<T>::indexOf(const T& item) const {
  auto it = std::find(data_.begin(), data_.end(), item);
  if (it != data_.end()) {
    return Int(static_cast<int>(std::distance(data_.begin(), it)));
  }
  return Int(-1);
}

template<typename T>
Int List<T>::lastIndexOf(const T& item) const {
  auto it = std::find(data_.rbegin(), data_.rend(), item);
  if (it != data_.rend()) {
    return Int(static_cast<int>(std::distance(it, data_.rend()) - 1));
  }
  return Int(-1);
}

template<typename T>
Bool List<T>::contains(const T& item) const {
  return Bool(std::find(data_.begin(), data_.end(), item) != data_.end());
}

template<typename T>
T List<T>::first() const {
  if (data_.empty()) {
    throw std::runtime_error("List is empty");
  }
  return data_.front();
}

template<typename T>
T List<T>::last() const {
  if (data_.empty()) {
    throw std::runtime_error("List is empty");
  }
  return data_.back();
}

template<typename T>
ObjectPtr<List<T>> List<T>::take(const Int& n) const {
  auto result = new List<T>();
  int count = std::min(n.toInt(), static_cast<int>(data_.size()));
  for (int i = 0; i < count; ++i) {
    result->add(data_[i]);
  }
  return ObjectPtr<List<T>>(result);
}

template<typename T>
ObjectPtr<List<T>> List<T>::skip(const Int& n) const {
  auto result = new List<T>();
  int start = std::min(n.toInt(), static_cast<int>(data_.size()));
  for (size_t i = start; i < data_.size(); ++i) {
    result->add(data_[i]);
  }
  return ObjectPtr<List<T>>(result);
}

template<typename T>
ObjectPtr<List<T>> List<T>::toList() const {
  return ObjectPtr<List<T>>(new List<T>(*this));
}

template<typename T>
ObjectPtr<ListIterator<T>> List<T>::iterator() const {
  return ObjectPtr<ListIterator<T>>(new ListIterator<T>(const_cast<std::vector<T>&>(data_).begin(), 
                                                         const_cast<std::vector<T>&>(data_).end()));
}

template<typename T>
ObjectPtr<List<T>> List<T>::sublist(const Int& start, const Int& end) const {
  auto result = new List<T>();
  int s = start.toInt();
  int e = end.toInt();
  for (int i = s; i < e && i < static_cast<int>(data_.size()); ++i) {
    result->add(data_[i]);
  }
  return ObjectPtr<List<T>>(result);
}

template<typename T>
ObjectPtr<List<T>> List<T>::subList(const Int& start, const Int& end) const {
  return sublist(start, end);
}

template<typename T>
ObjectPtr<List<T>> List<T>::reversed() const {
  auto result = new List<T>();
  for (auto it = data_.rbegin(); it != data_.rend(); ++it) {
    result->add(*it);
  }
  return ObjectPtr<List<T>>(result);
}

template<typename T>
ObjectPtr<List<T>> List<T>::create() {
  return ObjectPtr<List<T>>(new List<T>());
}

template<typename T>
ObjectPtr<List<T>> List<T>::create(const List<T>& other) {
  return ObjectPtr<List<T>>(new List<T>(other));
}

template<typename T>
ObjectPtr<List<T>> List<T>::create(std::initializer_list<T> init) {
  return ObjectPtr<List<T>>(new List<T>(init));
}

template<typename T>
ObjectPtr<List<T>> List<T>::createFromValues(std::initializer_list<T> values) {
  return ObjectPtr<List<T>>(new List<T>(values));
}

// 修复#13: List.from 和 List.of 静态工厂方法实现
template<typename T>
template<typename Iterable>
ObjectPtr<List<T>> List<T>::from(const ObjectPtr<Iterable>& source) {
  auto result = ObjectPtr<List<T>>(new List<T>());
  for (Int i = Int(0); i < source->size(); ++i) {
    result->add(source->get(i));
  }
  return result;
}

template<typename T>
template<typename Iterable>
ObjectPtr<List<T>> List<T>::of(const ObjectPtr<Iterable>& source) {
  return from(source);
}

template<typename T>
ObjectPtr<List<T>> List<T>::filled(const Int& length, const T& fill) {
  auto result = ObjectPtr<List<T>>(new List<T>());
  for (int i = 0; i < length.toInt(); ++i) {
    result->add(fill);
  }
  return result;
}

template<typename T>
ObjectPtr<List<T>> List<T>::generate(const Int& length, std::function<T(Int)> generator) {
  auto result = ObjectPtr<List<T>>(new List<T>());
  for (int i = 0; i < length.toInt(); ++i) {
    result->add(generator(Int(i)));
  }
  return result;
}

template<typename T>
String List<T>::toString() const {
  std::stringstream ss;
  ss << "[";
  for (size_t i = 0; i < data_.size(); ++i) {
    if (i > 0) ss << ", ";
    // 需要根据类型处理toString
  }
  ss << "]";
  return String(ss.str());
}

// Set 实现
template<typename T>
Set<T>::Set() {}

template<typename T>
Set<T>::Set(const Set<T>& other) : data_(other.data_) {}

template<typename T>
Set<T>::Set(std::initializer_list<T> init) : data_(init) {}

template<typename T>
Set<T>& Set<T>::operator=(const Set<T>& other) {
  if (this != &other) {
    data_ = other.data_;
  }
  return *this;
}

template<typename T>
Int Set<T>::size() const {
  return Int(static_cast<int>(data_.size()));
}

template<typename T>
Int Set<T>::get_length() const {
  return size();
}

template<typename T>
Bool Set<T>::isEmpty() const {
  return Bool(data_.empty());
}

template<typename T>
Bool Set<T>::isNotEmpty() const {
  return Bool(!data_.empty());
}

template<typename T>
Bool Set<T>::add(const T& item) {
  auto result = data_.insert(item);
  return Bool(result.second);
}

template<typename T>
Bool Set<T>::remove(const T& item) {
  return Bool(data_.erase(item) > 0);
}

template<typename T>
void Set<T>::clear() {
  data_.clear();
}

template<typename T>
Bool Set<T>::contains(const T& item) const {
  return Bool(data_.find(item) != data_.end());
}

template<typename T>
ObjectPtr<Set<T>> Set<T>::union_(const ObjectPtr<Set<T>>& other) const {
  auto result = new Set<T>(*this);
  for (const auto& item : other->data_) {
    result->data_.insert(item);
  }
  return ObjectPtr<Set<T>>(result);
}

template<typename T>
ObjectPtr<Set<T>> Set<T>::intersection(const ObjectPtr<Set<T>>& other) const {
  auto result = new Set<T>();
  for (const auto& item : data_) {
    if (other->contains(item).toBool()) {
      result->add(item);
    }
  }
  return ObjectPtr<Set<T>>(result);
}

template<typename T>
ObjectPtr<Set<T>> Set<T>::difference(const ObjectPtr<Set<T>>& other) const {
  auto result = new Set<T>();
  for (const auto& item : data_) {
    if (!other->contains(item).toBool()) {
      result->add(item);
    }
  }
  return ObjectPtr<Set<T>>(result);
}

template<typename T>
ObjectPtr<SetIterator<T>> Set<T>::iterator() const {
  return ObjectPtr<SetIterator<T>>(new SetIterator<T>(const_cast<std::unordered_set<T>&>(data_).begin(),
                                                       const_cast<std::unordered_set<T>&>(data_).end()));
}

template<typename T>
ObjectPtr<List<T>> Set<T>::toList() const {
  auto result = new List<T>();
  for (const auto& item : data_) {
    result->add(item);
  }
  return ObjectPtr<List<T>>(result);
}

template<typename T>
ObjectPtr<Set<T>> Set<T>::create() {
  return ObjectPtr<Set<T>>(new Set<T>());
}

template<typename T>
ObjectPtr<Set<T>> Set<T>::create(const Set<T>& other) {
  return ObjectPtr<Set<T>>(new Set<T>(other));
}

template<typename T>
ObjectPtr<Set<T>> Set<T>::create(std::initializer_list<T> init) {
  return ObjectPtr<Set<T>>(new Set<T>(init));
}

template<typename T>
String Set<T>::toString() const {
  std::stringstream ss;
  ss << "{";
  bool first = true;
  for (const auto& item : data_) {
    if (!first) ss << ", ";
    first = false;
    // 需要根据类型处理toString
  }
  ss << "}";
  return String(ss.str());
}

// Map 实现
template<typename K, typename V>
Map<K, V>::Map() {}

template<typename K, typename V>
Map<K, V>::Map(const Map<K, V>& other) : data_(other.data_) {}

template<typename K, typename V>
Map<K, V>::Map(std::initializer_list<std::pair<K, V>> init) {
  for (const auto& pair : init) {
    data_[pair.first] = pair.second;
  }
}

template<typename K, typename V>
Map<K, V>& Map<K, V>::operator=(const Map<K, V>& other) {
  if (this != &other) {
    data_ = other.data_;
  }
  return *this;
}

template<typename K, typename V>
V& Map<K, V>::operator[](const K& key) {
  return data_[key];
}

template<typename K, typename V>
const V& Map<K, V>::operator[](const K& key) const {
  return data_.at(key);
}

template<typename K, typename V>
V Map<K, V>::get(const K& key) const {
  auto it = data_.find(key);
  if (it != data_.end()) {
    return it->second;
  }
  throw std::runtime_error("Key not found");
}

template<typename K, typename V>
void Map<K, V>::set(const K& key, const V& value) {
  data_[key] = value;
}

template<typename K, typename V>
V Map<K, V>::operator_index(const K& key) const {
  auto it = data_.find(key);
  if (it != data_.end()) {
    return it->second;
  }
  throw std::runtime_error("Key not found");
}

template<typename K, typename V>
void Map<K, V>::operator_index_set(const K& key, const V& value) {
  data_[key] = value;
}

template<typename K, typename V>
Int Map<K, V>::size() const {
  return Int(static_cast<int>(data_.size()));
}

template<typename K, typename V>
Int Map<K, V>::get_length() const {
  return size();
}

template<typename K, typename V>
Bool Map<K, V>::isEmpty() const {
  return Bool(data_.empty());
}

template<typename K, typename V>
Bool Map<K, V>::isNotEmpty() const {
  return Bool(!data_.empty());
}

template<typename K, typename V>
void Map<K, V>::put(const K& key, const V& value) {
  data_[key] = value;
}

template<typename K, typename V>
Bool Map<K, V>::remove(const K& key) {
  return Bool(data_.erase(key) > 0);
}

template<typename K, typename V>
void Map<K, V>::clear() {
  data_.clear();
}

template<typename K, typename V>
Bool Map<K, V>::containsKey(const K& key) const {
  return Bool(data_.find(key) != data_.end());
}

template<typename K, typename V>
Bool Map<K, V>::containsValue(const V& value) const {
  for (const auto& pair : data_) {
    if (pair.second == value) {
      return Bool(true);
    }
  }
  return Bool(false);
}

template<typename K, typename V>
ObjectPtr<Set<K>> Map<K, V>::keys() const {
  auto result = new Set<K>();
  for (const auto& pair : data_) {
    result->add(pair.first);
  }
  return ObjectPtr<Set<K>>(result);
}

template<typename K, typename V>
ObjectPtr<List<V>> Map<K, V>::values() const {
  auto result = new List<V>();
  for (const auto& pair : data_) {
    result->add(pair.second);
  }
  return ObjectPtr<List<V>>(result);
}

template<typename K, typename V>
ObjectPtr<MapIterator<K, V>> Map<K, V>::iterator() const {
  return ObjectPtr<MapIterator<K, V>>(new MapIterator<K, V>(const_cast<std::unordered_map<K, V>&>(data_).begin(),
                                                             const_cast<std::unordered_map<K, V>&>(data_).end()));
}

template<typename K, typename V>
ObjectPtr<Map<K, V>> Map<K, V>::create() {
  return ObjectPtr<Map<K, V>>(new Map<K, V>());
}

template<typename K, typename V>
ObjectPtr<Map<K, V>> Map<K, V>::create(const Map<K, V>& other) {
  return ObjectPtr<Map<K, V>>(new Map<K, V>(other));
}

template<typename K, typename V>
ObjectPtr<Map<K, V>> Map<K, V>::create(std::initializer_list<std::pair<K, V>> init) {
  return ObjectPtr<Map<K, V>>(new Map<K, V>(init));
}

template<typename K, typename V>
ObjectPtr<Map<K, V>> Map<K, V>::createFromEntries(std::initializer_list<std::pair<K, V>> entries) {
  auto map = ObjectPtr<Map<K, V>>(new Map<K, V>());
  for (const auto& entry : entries) {
    map->put(entry.first, entry.second);
  }
  return map;
}

template<typename K, typename V>
String Map<K, V>::toString() const {
  std::stringstream ss;
  ss << "{";
  bool first = true;
  for (const auto& pair : data_) {
    if (!first) ss << ", ";
    first = false;
  }
  ss << "}";
  return String(ss.str());
}

// ============================================================================
// std::hash 特化 - 支持Dart类型在std容器中使用
// ============================================================================

namespace std {
  template<>
  struct hash<Int> {
    size_t operator()(const Int& i) const {
      return std::hash<int>()(i.getValue());
    }
  };
  
  template<>
  struct hash<Double> {
    size_t operator()(const Double& d) const {
      return std::hash<double>()(d.toDouble());
    }
  };
  
  template<>
  struct hash<Bool> {
    size_t operator()(const Bool& b) const {
      return std::hash<bool>()(b.toBool());
    }
  };
  
  template<>
  struct hash<String> {
    size_t operator()(const String& s) const {
      return std::hash<std::string>()(s.getValue());
    }
  };
}

// ============================================================================
// 缺失类型的基本实现
// ============================================================================

// Stream 类的基本实现
template<typename T>
class Stream : public Object {
public:
  Stream() {}
  String toString() const override { return String("Stream"); }
};

// Address 类的基本实现  
// class Address : public Object {
// public:
//   Address() {}
//   String toString() const override { return String("Address"); }
// };

// Invocation 类的基本实现
class Invocation : public Object {
public:
  Invocation() {}
  String toString() const override { return String("Invocation"); }
};

// 无穷大常量
const Double Infinity = Double(std::numeric_limits<double>::infinity());

#endif // _DART_OBJECT_H_
