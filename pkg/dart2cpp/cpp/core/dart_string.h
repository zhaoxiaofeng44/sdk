#ifndef _DART_STRING_H_
#define _DART_STRING_H_

#include <algorithm>
#include <cctype>
#include <climits>
#include <cmath>
#include <cstddef>
#include <cstdlib>
#include <functional>
#include <iostream>
#include <memory>
#include <sstream>
#include <stdexcept>
#include <string>
#include <type_traits>
#include <unordered_map>
#include <unordered_set>
#include <utility>
#include <vector>

// ============================================================================
// 基础类型联合体定义 - 必须在String类定义之前
// ============================================================================

// 联合体用于存储所有基础类型的数据
union ValueUnion {
  int int_value;
  double double_value;
  bool bool_value;
  int string_index;  // String类型使用字符串池索引
  void* object_ptr;  // ObjectPtr和Object类型使用指针
  
  ValueUnion() : int_value(0) {}
  ValueUnion(int v) : int_value(v) {}
  ValueUnion(double v) : double_value(v) {}
  ValueUnion(bool v) : bool_value(v) {}
  ValueUnion(void* ptr) : object_ptr(ptr) {}
};

// 前向声明 - 避免循环依赖
class Any;
class Int;
class Double;
class Bool;
class String;
class Nullable;

// 容器类型前向声明
template <typename T>
class List;
template <typename K, typename V>
class Map;
template <typename T>
class ObjectPtr;
class Function;

// TypedFunction 前向声明 - 用于 replaceAllMapped 和 replaceFirstMapped
template<typename F, typename R, typename... Args>
class TypedFunction;

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
// 基础类型定义 - 避免循环依赖
// ============================================================================

// ============================================================================
// String 类声明
// ============================================================================

class String  {
 public:
  int type_id;
  ValueUnion value;
 public:
  // 构造函数
  String();
  String(const String& other);
  explicit String(int index);    // 显式构造，避免隐式转换
  String(const char* v);  // 接受字符串字面量 - 实现在cpp文件中
  String(const std::string& v);  // 接受 std::string - 实现在cpp文件中
  explicit String(const Any& any);  // 显式构造，避免与其他构造函数冲突
  String(const Nullable&);  // NULL构造函数（支持隐式转换）

  // 拷贝赋值运算符
  String& operator=(const String& other);
  String& operator=(const Any& any);
  String& operator=(const Nullable&);  // NULL 赋值操作符

  // 获取值的便捷方法
  int getStringIndex() const;

  // 算术运算符函数（字符串连接）
  String operator_concat(const String& other) const;
  String operator_add(const String& other) const;
  String operator_add(const Bool& other) const;  // String + Bool
  
  String operator+(const String& other) const;
  String operator+(const Bool& other) const;  // String + Bool

  // 比较运算符函数
  Bool operator_equals(const String& other) const;
  Bool operator_equals(const char* other) const;
  Bool operator_equals(const std::string& other) const;
  Bool operator_not_equals(const String& other) const;
  Bool operator_not_equals(const char* other) const;
  Bool operator_not_equals(const std::string& other) const;
  Bool operator_less(const String& other) const;
  Bool operator_less_equals(const String& other) const;
  Bool operator_greater(const String& other) const;
  Bool operator_greater_equals(const String& other) const;

  Bool operator==(const String& other) const;
  Bool operator==(const char* other) const;
  Bool operator==(const std::string& other) const;
  Bool operator!=(const String& other) const;
  Bool operator!=(const char* other) const;
  Bool operator!=(const std::string& other) const;
  Bool operator<(const String& other) const;
  Bool operator<=(const String& other) const;
  Bool operator>(const String& other) const;
  Bool operator>=(const String& other) const;

  // 索引运算符函数
  String operator_index(const Int& index) const;
  
  // 索引运算符
  String operator[](const Int& index) const;

  // Dart 方法实现
  String toString() const;
  Int get_length() const;
  Int length() const;  // 方法调用形式的 length
  Int size() const;    // size() 方法，等同于 length()
  Bool get_isEmpty() const;
  Bool isEmpty() const;  // 方法调用形式的 isEmpty
  Bool get_isNotEmpty() const;
  Bool isNotEmpty() const;  // 方法调用形式的 isNotEmpty
  Bool isNull() const;  // 空值检查方法
  Int compareTo(const String& other) const;

  // 字符串操作方法
  String substring(const Int& start, const Int& end) const;
  String substring(const Int& start) const;  // 单参数版本，从 start 到字符串末尾
  Int indexOf(const String& pattern) const;
  Int indexOf(const String& pattern, const Int& start) const;
  Int lastIndexOf(const String& pattern) const;
  Int lastIndexOf(const String& pattern, const Int& start) const;
  Bool startsWith(const String& pattern) const;
  Bool endsWith(const String& pattern) const;
  Bool contains(const String& pattern) const;
  String toLowerCase() const;
  String toUpperCase() const;
  String trim() const;
  String trimLeft() const;
  String trimRight() const;
  String replaceAll(const String& from, const String& to) const;
  String replaceFirst(const String& from, const String& to) const;
  String padLeft(const Int& width, const String& padding) const;
  String padRight(const Int& width, const String& padding) const;
  
  // 字符串分割和连接方法
  ObjectPtr<List<String> > split(const String& separator) const;
  ObjectPtr<List<String> > splitMapJoin(const String& pattern) const;
  
  // 其他 Dart String 方法
  String replaceRange(const Int& start, const Int& end, const String& replacement) const;
  template<typename ReplaceFunc>
  String replaceAllMapped(const String& from, const ObjectPtr<TypedFunction<ReplaceFunc, String, String>>& replace) const;
  template<typename ReplaceFunc>
  String replaceFirstMapped(const String& from, const ObjectPtr<TypedFunction<ReplaceFunc, String, String>>& replace) const;
  ObjectPtr<List<String> > splitChars() const;  // 分割为字符列表
  String repeat(const Int& times) const;
  String operator_mul(const Int& times) const;  // 字符串乘法运算 ("a" * 3 = "aaa")
  String operator*(const Int& times) const;  // 标准乘法运算符
  
  // 字符编码相关
  ObjectPtr<List<Int> > get_codeUnits() const;  // 获取字符编码列表
  
  // 静态方法：连接字符串列表
  static String join(const ObjectPtr<List<String> >& strings, const String& separator);
  
  // 静态扩展方法（从 StringExtensions 迁移）
  static ObjectPtr<List<String>> splitStatic(const String& str, const String& delimiter);
  static String interpolate(const String& template_str, const ObjectPtr<Map<String, String>>& variables);
  
  // ============================================================================
  // RegExp 相关方法 - 将正则表达式功能合并到 String 类型
  // String 本身可以用作正则表达式模式
  // ============================================================================
  
  // 检查正则表达式是否在输入字符串中有匹配
  // this 作为正则表达式模式，input 是要匹配的字符串
  Bool hasMatch(const String& input) const;
  
  // 返回正则表达式在输入字符串中的第一个匹配字符串
  // this 作为正则表达式模式，input 是要匹配的字符串
  String stringMatch(const String& input) const;
  
  // 从指定位置开始匹配，返回匹配位置
  // this 作为正则表达式模式
  Int matchAsPrefix(const String& str, const Int& start) const;
  Int matchAsPrefix(const String& str) const;
  
  // 获取正则表达式模式（返回自身）
  String pattern() const;
  
  // 正则表达式属性（简化实现，都返回默认值）
  Bool isCaseSensitive() const;
  Bool isMultiLine() const;
  Bool isDotAll() const;
  
  // format 方法为模板方法，需要在头文件中实现
  template<typename... Args>
  static String format(const String& format_str, Args... args) {
    std::stringstream ss;
    format_helper(ss, format_str.getValue(), args...);
    return String(ss.str());
  }

private:
  // format 辅助方法
  template<typename T>
  static void format_helper(std::stringstream& ss, const std::string& format, T&& value) {
    size_t pos = format.find("{}");
    if (pos != std::string::npos) {
      ss << format.substr(0, pos) << value << format.substr(pos + 2);
    } else {
      ss << format;
    }
  }
  
  template<typename T, typename... Args>
  static void format_helper(std::stringstream& ss, const std::string& format, T&& value, Args&&... args) {
    size_t pos = format.find("{}");
    if (pos != std::string::npos) {
      ss << format.substr(0, pos) << value;
      format_helper(ss, format.substr(pos + 2), args...);
    } else {
      ss << format;
    }
  }

public:

  // 类型转换
  operator std::string() const;
  operator const char*() const;

  // 获取实际字符串值
  const std::string& getValue() const;
  Int getIndex() const;

  // 箭头运算符重载，返回指向自身的指针
  String* operator->() { return this; }
  const String* operator->() const { return this; }
};

// ============================================================================
// 字符串相关的全局函数声明
// ============================================================================

// create_dart_string 全局函数声明
String create_dart_string(const char* str);
String create_dart_string(const std::string& str);
String create_dart_string(int value);
String create_dart_string(double value);
String create_dart_string(bool value);

#endif // _DART_STRING_H_
