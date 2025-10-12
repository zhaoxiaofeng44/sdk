#ifndef _OBJECT_H_
#define _OBJECT_H_

#include <algorithm>
#include <cctype>
#include <climits>
#include <cmath>
#include <cstddef>
#include <cstdlib>
#include <functional>
#include <iostream>
#include <sstream>
#include <stdexcept>
#include <string>
#include <unordered_map>
#include <vector>

// ============================================================================
// 全局字符串池
// ============================================================================

class StringPool {
 private:
  static StringPool* instance_;
  std::vector<std::string> pool_;
  std::unordered_map<std::string, int> index_map_;

  StringPool() {}

 public:
  static StringPool* getInstance();
  int intern(const std::string& str);
  const std::string& getString(int index) const;
  int getSize() const;
  void clear();

  // 禁止拷贝
  StringPool(const StringPool&) = delete;
  StringPool& operator=(const StringPool&) = delete;
};

// ============================================================================
// 基础类型
// ============================================================================

class Any {
 public:
  int type_id;
};

class Void : public Any {
 public:
  Void();
};

class Int : public Any {
 public:
  int value;

  // 构造函数
  Int();
  Int(int v);
  Int(const Int& other);

  // 算术运算符重载
  Int operator+(const Int& other) const;
  Int operator-(const Int& other) const;
  Int operator*(const Int& other) const;
  Int operator/(const Int& other) const;
  Int operator%(const Int& other) const;
  Int integerDivision(const Int& other) const;

  // 位运算符重载
  Int operator&(const Int& other) const;
  Int operator|(const Int& other) const;
  Int operator^(const Int& other) const;
  Int operator<<(const Int& other) const;
  Int operator>>(const Int& other) const;
  Int operator~() const;

  // 比较运算符重载
  bool operator==(const Int& other) const;
  bool operator!=(const Int& other) const;
  bool operator<(const Int& other) const;
  bool operator<=(const Int& other) const;
  bool operator>(const Int& other) const;
  bool operator>=(const Int& other) const;

  // 赋值运算符
  Int& operator=(const Int& other);

  // 一元运算符
  Int operator-() const;
  Int operator+() const;

  // Dart 方法实现
  Int abs() const;
  std::string toString() const;
  double toDouble() const;
  int compareTo(const Int& other) const;
  Int gcd(const Int& other) const;

  // 属性方法
  int get_sign() const;
  bool get_isEven() const;
  bool get_isOdd() const;
  bool get_isNegative() const;
  bool get_isFinite() const;
  bool get_isInfinite() const;
  bool get_isNaN() const;

  // 类型转换
  operator int() const;
  operator double() const;
  operator bool() const;
};

class Double : public Any {
 public:
  double value;

  // 构造函数
  Double();
  Double(double v);
  Double(const Double& other);
  Double(const Int& other);

  // 算术运算符重载
  Double operator+(const Double& other) const;
  Double operator-(const Double& other) const;
  Double operator*(const Double& other) const;
  Double operator/(const Double& other) const;
  Double operator%(const Double& other) const;

  // 比较运算符重载
  bool operator==(const Double& other) const;
  bool operator!=(const Double& other) const;
  bool operator<(const Double& other) const;
  bool operator<=(const Double& other) const;
  bool operator>(const Double& other) const;
  bool operator>=(const Double& other) const;

  // 赋值运算符
  Double& operator=(const Double& other);

  // 一元运算符
  Double operator-() const;
  Double operator+() const;

  // Dart 方法实现
  Double abs() const;
  std::string toString() const;
  int toInt() const;
  Double floor() const;
  Double ceil() const;
  Double round() const;
  Double truncate() const;
  int compareTo(const Double& other) const;

  // 属性方法
  int get_sign() const;
  bool get_isNegative() const;
  bool get_isFinite() const;
  bool get_isInfinite() const;
  bool get_isNaN() const;

  // 类型转换
  operator double() const;
  operator int() const;
  operator bool() const;
};

class Bool : public Any {
 public:
  bool value;

  // 构造函数
  Bool();
  Bool(bool v);
  Bool(const Bool& other);

  // 逻辑运算符重载
  Bool operator&&(const Bool& other) const;
  Bool operator||(const Bool& other) const;
  Bool operator!() const;

  // 比较运算符重载
  bool operator==(const Bool& other) const;
  bool operator!=(const Bool& other) const;

  // 赋值运算符
  Bool& operator=(const Bool& other);

  // Dart 方法实现
  std::string toString() const;
  int compareTo(const Bool& other) const;

  // 类型转换
  operator bool() const;
  operator int() const;
};

class String : public Any {
 public:
  int string_index_;  // 字符串池中的索引

  // 构造函数
  String();
  String(const std::string& v);
  String(const char* v);
  String(const String& other);
  String(int index);  // 直接使用索引构造

  // 算术运算符重载（字符串连接）
  String operator+(const String& other) const;

  // 比较运算符重载
  bool operator==(const String& other) const;
  bool operator!=(const String& other) const;
  bool operator<(const String& other) const;
  bool operator<=(const String& other) const;
  bool operator>(const String& other) const;
  bool operator>=(const String& other) const;

  // 索引运算符
  char operator[](int index) const;

  // 赋值运算符
  String& operator=(const String& other);

  // Dart 方法实现
  std::string toString() const;
  int get_length() const;
  bool get_isEmpty() const;
  bool get_isNotEmpty() const;
  int compareTo(const String& other) const;

  // 字符串操作方法
  String substring(int start, int end = -1) const;
  int indexOf(const String& pattern, int start = 0) const;
  int lastIndexOf(const String& pattern, int start = -1) const;
  bool startsWith(const String& pattern) const;
  bool endsWith(const String& pattern) const;
  bool contains(const String& pattern) const;
  String toLowerCase() const;
  String toUpperCase() const;
  String trim() const;
  String trimLeft() const;
  String trimRight() const;
  String replaceAll(const String& from, const String& to) const;
  String replaceFirst(const String& from, const String& to) const;
  String padLeft(int width, const String& padding = String(" ")) const;
  String padRight(int width, const String& padding = String(" ")) const;

  // 类型转换
  operator std::string() const;
  operator const char*() const;

  // 获取实际字符串值
  const std::string& getValue() const;
  int getIndex() const;
};

class CppUserData : public Any {
 public:
  int length;
  void** data;

  CppUserData();
  CppUserData(int length);
  CppUserData(const CppUserData& other);
  ~CppUserData();
  CppUserData& operator=(const CppUserData& other);
};

class Object : public Any {};

template <typename T>
class ObjectPtr : public Object {
 private:
  void dispose();

 public:
  T* ptr;

  // 构造函数
  ObjectPtr();
  ObjectPtr(T* p);
  ObjectPtr(const ObjectPtr& other);

  // 析构函数
  virtual ~ObjectPtr();

  // 赋值运算符
  ObjectPtr& operator=(const ObjectPtr& other);

  // 访问运算符
  T* operator->();
  const T* operator->() const;
  T& operator*();
  const T& operator*() const;

  // 判断是否为空
  bool isNull() const;
  bool isNotNull() const;

  // 获取值
  T* get();
  const T* get() const;

  // 设置值
  void set(T* p);

  // Dart 方法实现
  std::string toString() const;
  bool operator==(const ObjectPtr& other) const;
  bool operator!=(const ObjectPtr& other) const;

  // 类型转换
  operator bool() const;
};

// ============================================================================
// 模板实现（必须在头文件中）
// ============================================================================

template <typename T>
void ObjectPtr<T>::dispose() {
  if (ptr) {
    delete ptr;
    ptr = nullptr;
  }
}

template <typename T>
ObjectPtr<T>::ObjectPtr() : ptr(nullptr) {
  type_id = 5;
}

template <typename T>
ObjectPtr<T>::ObjectPtr(T* p) : ptr(p) {
  type_id = 5;
}

template <typename T>
ObjectPtr<T>::ObjectPtr(const ObjectPtr& other) : ptr(nullptr) {
  type_id = 5;
  if (other.ptr) {
    ptr = new T(*other.ptr);
  }
}

template <typename T>
ObjectPtr<T>::~ObjectPtr() {
  dispose();
}

template <typename T>
ObjectPtr<T>& ObjectPtr<T>::operator=(const ObjectPtr& other) {
  if (this != &other) {
    dispose();
    ptr = nullptr;
    if (other.ptr) {
      ptr = new T(*other.ptr);
    }
  }
  return *this;
}

template <typename T>
T* ObjectPtr<T>::operator->() {
  return ptr;
}

template <typename T>
const T* ObjectPtr<T>::operator->() const {
  return ptr;
}

template <typename T>
T& ObjectPtr<T>::operator*() {
  return *ptr;
}

template <typename T>
const T& ObjectPtr<T>::operator*() const {
  return *ptr;
}

template <typename T>
bool ObjectPtr<T>::isNull() const {
  return ptr == nullptr;
}

template <typename T>
bool ObjectPtr<T>::isNotNull() const {
  return ptr != nullptr;
}

template <typename T>
T* ObjectPtr<T>::get() {
  return ptr;
}

template <typename T>
const T* ObjectPtr<T>::get() const {
  return ptr;
}

template <typename T>
void ObjectPtr<T>::set(T* p) {
  dispose();
  ptr = p;
}

template <typename T>
std::string ObjectPtr<T>::toString() const {
  if (isNull()) return "null";
  return "Object";
}

template <typename T>
bool ObjectPtr<T>::operator==(const ObjectPtr& other) const {
  if (isNull() && other.isNull()) return true;
  if (isNull() || other.isNull()) return false;
  return *ptr == *other.ptr;
}

template <typename T>
bool ObjectPtr<T>::operator!=(const ObjectPtr& other) const {
  return !(*this == other);
}

template <typename T>
ObjectPtr<T>::operator bool() const {
  return isNotNull();
}

class ObjectTestA {
 public:
  Int value;
  ObjectTestA(Int value) : value(value) {}
  std::string toString() const {
    return "ObjectTestA(value: " + value.toString();
  }
};

class ObjectTest {
 public:
  Int value;
  String name;
  Bool is_valid;
  Double score;
  ObjectPtr<ObjectTestA> object_test_a;
  ObjectTest(int value,
             const std::string& name,
             bool is_valid,
             double score,
             ObjectPtr<ObjectTestA> aa)
      : value(value),
        name(name),
        is_valid(is_valid),
        score(score),
        object_test_a(aa) {}
  std::string toString() const {
    return "ObjectTest(value: " + value.toString() +
           ", name: " + name.toString() +
           ", is_valid: " + (is_valid ? "true" : "false") +
           ", score: " + score.toString() +
           ", object_test_a: " + object_test_a.toString() + ")";
  }
};

#endif
