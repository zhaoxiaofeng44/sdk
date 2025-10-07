#ifndef _OBJECT_H_
#define _OBJECT_H_

#include <algorithm>   // 算法函数
#include <cctype>      // 字符处理函数
#include <climits>     // 限制常量
#include <cmath>       // 数学函数
#include <cstddef>     // 为了使用 NULL
#include <cstdlib>     // 为了使用 malloc
#include <functional>  // 函数对象
#include <iostream>    // 输入输出
#include <sstream>     // 字符串流
#include <stdexcept>   // 异常处理
#include <string>      // 字符串操作

class Any {
 public:
  int type_id;
};

class Void : public Any {
 public:
  Void() { type_id = 0; }
};

class Object : public Any {};

class Int : public Object {
 public:
  int value;

  // 构造函数
  Int() : value(0) { type_id = 1; }
  Int(int v) : value(v) { type_id = 1; }
  Int(const Int& other) : value(other.value) { type_id = 1; }

  // 算术运算符重载
  Int operator+(const Int& other) const { return Int(value + other.value); }
  Int operator-(const Int& other) const { return Int(value - other.value); }
  Int operator*(const Int& other) const { return Int(value * other.value); }
  Int operator/(const Int& other) const {
    if (other.value == 0) throw std::runtime_error("Division by zero");
    return Int(value / other.value);
  }
  Int operator%(const Int& other) const {
    if (other.value == 0) throw std::runtime_error("Division by zero");
    return Int(value % other.value);
  }

  // 整除运算符（~/ 在Dart中）
  Int integerDivision(const Int& other) const {
    if (other.value == 0) throw std::runtime_error("Division by zero");
    return Int(value / other.value);
  }

  // 位运算符重载
  Int operator&(const Int& other) const { return Int(value & other.value); }
  Int operator|(const Int& other) const { return Int(value | other.value); }
  Int operator^(const Int& other) const { return Int(value ^ other.value); }
  Int operator<<(const Int& other) const { return Int(value << other.value); }
  Int operator>>(const Int& other) const { return Int(value >> other.value); }
  Int operator~() const { return Int(~value); }

  // 比较运算符重载
  bool operator==(const Int& other) const { return value == other.value; }
  bool operator!=(const Int& other) const { return value != other.value; }
  bool operator<(const Int& other) const { return value < other.value; }
  bool operator<=(const Int& other) const { return value <= other.value; }
  bool operator>(const Int& other) const { return value > other.value; }
  bool operator>=(const Int& other) const { return value >= other.value; }

  // 赋值运算符
  Int& operator=(const Int& other) {
    if (this != &other) value = other.value;
    return *this;
  }

  // 一元运算符
  Int operator-() const { return Int(-value); }
  Int operator+() const { return Int(value); }

  // Dart 方法实现
  Int abs() const { return Int(std::abs(value)); }

  std::string toString() const {
    std::stringstream ss;
    ss << value;
    return ss.str();
  }

  double toDouble() const { return static_cast<double>(value); }

  int compareTo(const Int& other) const {
    if (value < other.value) return -1;
    if (value > other.value) return 1;
    return 0;
  }

  // 最大公约数
  Int gcd(const Int& other) const {
    int a = std::abs(value);
    int b = std::abs(other.value);
    while (b != 0) {
      int temp = b;
      b = a % b;
      a = temp;
    }
    return Int(a);
  }

  // 属性方法
  int get_sign() const {
    if (value > 0) return 1;
    if (value < 0) return -1;
    return 0;
  }

  bool get_isEven() const { return (value % 2) == 0; }
  bool get_isOdd() const { return (value % 2) != 0; }
  bool get_isNegative() const { return value < 0; }
  bool get_isFinite() const { return true; }     // int 总是有限的
  bool get_isInfinite() const { return false; }  // int 永远不是无穷大
  bool get_isNaN() const { return false; }       // int 永远不是 NaN

  // 类型转换
  operator int() const { return value; }
  operator double() const { return static_cast<double>(value); }
  operator bool() const { return value != 0; }
};

class Double : public Object {
 public:
  double value;

  // 构造函数
  Double() : value(0.0) { type_id = 2; }
  Double(double v) : value(v) { type_id = 2; }
  Double(const Double& other) : value(other.value) { type_id = 2; }
  Double(const Int& other) : value(other.toDouble()) { type_id = 2; }

  // 算术运算符重载
  Double operator+(const Double& other) const {
    return Double(value + other.value);
  }
  Double operator-(const Double& other) const {
    return Double(value - other.value);
  }
  Double operator*(const Double& other) const {
    return Double(value * other.value);
  }
  Double operator/(const Double& other) const {
    if (other.value == 0.0) return Double(value > 0 ? INFINITY : -INFINITY);
    return Double(value / other.value);
  }
  Double operator%(const Double& other) const {
    if (other.value == 0.0) return Double(NAN);
    return Double(std::fmod(value, other.value));
  }

  // 比较运算符重载
  bool operator==(const Double& other) const { return value == other.value; }
  bool operator!=(const Double& other) const { return value != other.value; }
  bool operator<(const Double& other) const { return value < other.value; }
  bool operator<=(const Double& other) const { return value <= other.value; }
  bool operator>(const Double& other) const { return value > other.value; }
  bool operator>=(const Double& other) const { return value >= other.value; }

  // 赋值运算符
  Double& operator=(const Double& other) {
    if (this != &other) value = other.value;
    return *this;
  }

  // 一元运算符
  Double operator-() const { return Double(-value); }
  Double operator+() const { return Double(value); }

  // Dart 方法实现
  Double abs() const { return Double(std::abs(value)); }

  std::string toString() const {
    if (get_isNaN()) return "NaN";
    if (get_isInfinite()) return value > 0 ? "Infinity" : "-Infinity";
    std::stringstream ss;
    ss << value;
    return ss.str();
  }

  int toInt() const {
    if (get_isNaN() || get_isInfinite()) return 0;
    return static_cast<int>(value);
  }

  Double floor() const { return Double(std::floor(value)); }
  Double ceil() const { return Double(std::ceil(value)); }
  Double round() const { return Double(std::round(value)); }
  Double truncate() const { return Double(std::trunc(value)); }

  int compareTo(const Double& other) const {
    if (get_isNaN() && other.get_isNaN()) return 0;
    if (get_isNaN()) return 1;
    if (other.get_isNaN()) return -1;
    if (value < other.value) return -1;
    if (value > other.value) return 1;
    return 0;
  }

  // 属性方法
  int get_sign() const {
    if (get_isNaN()) return 0;
    if (value > 0.0 || (value == 0.0 && 1.0 / value > 0.0)) return 1;
    if (value < 0.0 || (value == 0.0 && 1.0 / value < 0.0)) return -1;
    return 0;
  }

  bool get_isNegative() const {
    return value < 0.0 || (value == 0.0 && 1.0 / value < 0.0);
  }
  bool get_isFinite() const { return std::isfinite(value); }
  bool get_isInfinite() const { return std::isinf(value); }
  bool get_isNaN() const { return std::isnan(value); }

  // 类型转换
  operator double() const { return value; }
  operator int() const { return toInt(); }
  operator bool() const { return !get_isNaN() && value != 0.0; }
};

class Bool : public Object {
 public:
  bool value;

  // 构造函数
  Bool() : value(false) { type_id = 3; }
  Bool(bool v) : value(v) { type_id = 3; }
  Bool(const Bool& other) : value(other.value) { type_id = 3; }

  // 逻辑运算符重载
  Bool operator&&(const Bool& other) const {
    return Bool(value && other.value);
  }
  Bool operator||(const Bool& other) const {
    return Bool(value || other.value);
  }
  Bool operator!() const { return Bool(!value); }

  // 比较运算符重载
  bool operator==(const Bool& other) const { return value == other.value; }
  bool operator!=(const Bool& other) const { return value != other.value; }

  // 赋值运算符
  Bool& operator=(const Bool& other) {
    if (this != &other) value = other.value;
    return *this;
  }

  // Dart 方法实现
  std::string toString() const { return value ? "true" : "false"; }

  int compareTo(const Bool& other) const {
    if (value == other.value) return 0;
    return value ? 1 : -1;  // true > false
  }

  // 类型转换
  operator bool() const { return value; }
  operator int() const { return value ? 1 : 0; }
};

class String : public Object {
 public:
  std::string value;

  // 构造函数
  String() : value("") { type_id = 4; }
  String(const std::string& v) : value(v) { type_id = 4; }
  String(const char* v) : value(v) { type_id = 4; }
  String(const String& other) : value(other.value) { type_id = 4; }

  // 算术运算符重载（字符串连接）
  String operator+(const String& other) const {
    return String(value + other.value);
  }

  // 比较运算符重载
  bool operator==(const String& other) const { return value == other.value; }
  bool operator!=(const String& other) const { return value != other.value; }
  bool operator<(const String& other) const { return value < other.value; }
  bool operator<=(const String& other) const { return value <= other.value; }
  bool operator>(const String& other) const { return value > other.value; }
  bool operator>=(const String& other) const { return value >= other.value; }

  // 索引运算符
  char operator[](int index) const {
    if (index >= 0 && index < static_cast<int>(value.length())) {
      return value[index];
    }
    throw std::out_of_range("String index out of range");
  }

  // 赋值运算符
  String& operator=(const String& other) {
    if (this != &other) value = other.value;
    return *this;
  }

  // Dart 方法实现
  std::string toString() const { return value; }

  int get_length() const { return static_cast<int>(value.length()); }
  bool get_isEmpty() const { return value.empty(); }
  bool get_isNotEmpty() const { return !value.empty(); }

  int compareTo(const String& other) const {
    if (value < other.value) return -1;
    if (value > other.value) return 1;
    return 0;
  }

  // 字符串操作方法
  String substring(int start, int end = -1) const {
    if (end == -1) end = get_length();
    if (start < 0 || start > get_length() || end < start ||
        end > get_length()) {
      throw std::out_of_range("Substring range out of bounds");
    }
    return String(value.substr(start, end - start));
  }

  int indexOf(const String& pattern, int start = 0) const {
    if (start < 0 || start >= get_length()) return -1;
    size_t pos = value.find(pattern.value, start);
    return pos == std::string::npos ? -1 : static_cast<int>(pos);
  }

  int lastIndexOf(const String& pattern, int start = -1) const {
    if (start == -1) start = get_length() - 1;
    if (start < 0 || start >= get_length()) return -1;
    size_t pos = value.rfind(pattern.value, start);
    return pos == std::string::npos ? -1 : static_cast<int>(pos);
  }

  bool startsWith(const String& pattern) const {
    if (pattern.get_length() > get_length()) return false;
    return value.substr(0, pattern.get_length()) == pattern.value;
  }

  bool endsWith(const String& pattern) const {
    if (pattern.get_length() > get_length()) return false;
    return value.substr(get_length() - pattern.get_length()) == pattern.value;
  }

  bool contains(const String& pattern) const { return indexOf(pattern) != -1; }

  String toLowerCase() const {
    std::string result = value;
    std::transform(result.begin(), result.end(), result.begin(), ::tolower);
    return String(result);
  }

  String toUpperCase() const {
    std::string result = value;
    std::transform(result.begin(), result.end(), result.begin(), ::toupper);
    return String(result);
  }

  String trim() const {
    std::string result = value;
    // 删除前面的空白字符
    size_t start = result.find_first_not_of(" \t\n\r\f\v");
    if (start == std::string::npos) return String("");
    // 删除后面的空白字符
    size_t end = result.find_last_not_of(" \t\n\r\f\v");
    return String(result.substr(start, end - start + 1));
  }

  String trimLeft() const {
    std::string result = value;
    size_t start = result.find_first_not_of(" \t\n\r\f\v");
    if (start == std::string::npos) return String("");
    return String(result.substr(start));
  }

  String trimRight() const {
    std::string result = value;
    size_t end = result.find_last_not_of(" \t\n\r\f\v");
    if (end == std::string::npos) return String("");
    return String(result.substr(0, end + 1));
  }

  String replaceAll(const String& from, const String& to) const {
    std::string result = value;
    size_t pos = 0;
    while ((pos = result.find(from.value, pos)) != std::string::npos) {
      result.replace(pos, from.get_length(), to.value);
      pos += to.get_length();
    }
    return String(result);
  }

  String replaceFirst(const String& from, const String& to) const {
    std::string result = value;
    size_t pos = result.find(from.value);
    if (pos != std::string::npos) {
      result.replace(pos, from.get_length(), to.value);
    }
    return String(result);
  }

  String padLeft(int width, const String& padding = String(" ")) const {
    if (width <= get_length()) return *this;
    int padCount = width - get_length();
    std::string result;
    for (int i = 0; i < padCount; i++) {
      result += padding.value;
    }
    result += value;
    return String(result);
  }

  String padRight(int width, const String& padding = String(" ")) const {
    if (width <= get_length()) return *this;
    int padCount = width - get_length();
    std::string result = value;
    for (int i = 0; i < padCount; i++) {
      result += padding.value;
    }
    return String(result);
  }

  // 类型转换
  operator std::string() const { return value; }
  operator const char*() const { return value.c_str(); }
};

template <typename T>
class ObjectPtr : public Object {
 private:
  // 内存管理
  void dispose() {
    if (ptr) {
      delete ptr;
      ptr = nullptr;
    }
  }

 public:
  T* ptr;

  // 构造函数
  ObjectPtr() : ptr(nullptr) { type_id = 5; }
  ObjectPtr(T* p) : ptr(p) { type_id = 5; }
  ObjectPtr(const ObjectPtr& other) : ptr(nullptr) {
    type_id = 5;
    if (other.ptr) {
      ptr = new T(*other.ptr);
    }
  }

  // 析构函数
  virtual ~ObjectPtr() { dispose(); }

  // 赋值运算符
  ObjectPtr& operator=(const ObjectPtr& other) {
    if (this != &other) {
      dispose();
      ptr = nullptr;
      if (other.ptr) {
        ptr = new T(*other.ptr);
      }
    }
    return *this;
  }

  // 访问运算符
  T* operator->() { return ptr; }
  const T* operator->() const { return ptr; }
  T& operator*() { return *ptr; }
  const T& operator*() const { return *ptr; }

  // 判断是否为空
  bool isNull() const { return ptr == nullptr; }
  bool isNotNull() const { return ptr != nullptr; }

  // 获取值
  T* get() { return ptr; }
  const T* get() const { return ptr; }

  // 设置值
  void set(T* p) {
    dispose();
    ptr = p;
  }

  // Dart 方法实现
  std::string toString() const {
    if (isNull()) return "null";
    // 这里可以根据需要实现具体类型的toString
    return "Object";
  }

  bool operator==(const ObjectPtr& other) const {
    if (isNull() && other.isNull()) return true;
    if (isNull() || other.isNull()) return false;
    return *ptr == *other.ptr;
  }

  bool operator!=(const ObjectPtr& other) const { return !(*this == other); }

  // 类型转换
  operator bool() const { return isNotNull(); }
};

#endif