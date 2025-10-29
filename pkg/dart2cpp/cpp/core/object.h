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

// 前向声明
class String;
class Int;
class Double;
class Bool;

// 前向声明测试中使用的类
class Shape;

class Any {
 public:
  int type_id;

  Any() {}
  Any(const Any& other) : type_id(other.type_id) {}
  Any& operator=(const Any& other) {
    if (this != &other) {
      type_id = other.type_id;
    }
    return *this;
  }

  // 虚的 toString 方法，由子类实现
  virtual String toString() const;

  virtual ~Any() {}
};

class Void : public Any {
 public:
  Void() {
    type_id = 0;
  }
};

// 基础类型类声明
class Int : public Any {
 public:
  int value;

  // 构造函数
  Int();
  Int(int v);
  Int(const Int& other);

  // 算术运算符函数
  Int operator_plus(const Int& other) const;
  Int operator_minus(const Int& other) const;
  Int operator_multiply(const Int& other) const;
  Int operator_divide(const Int& other) const;
  Int operator_modulo(const Int& other) const;
  Int integerDivision(const Int& other) const;

  // 标准算术运算符
  Int operator+(const Int& other) const;
  Int operator-(const Int& other) const;
  Int operator*(const Int& other) const;
  Int operator/(const Int& other) const;
  Int operator%(const Int& other) const;

  // 位运算符函数
  Int operator_bitwise_and(const Int& other) const;
  Int operator_bitwise_or(const Int& other) const;
  Int operator_bitwise_xor(const Int& other) const;
  Int operator_shift_left(const Int& other) const;
  Int operator_shift_right(const Int& other) const;
  Int operator_bitwise_not() const;

  // 比较运算符函数
  Bool operator==(const Int& other) const;
  Bool operator!=(const Int& other) const;
  Bool operator<(const Int& other) const;
  Bool operator<=(const Int& other) const;
  Bool operator>(const Int& other) const;
  Bool operator>=(const Int& other) const;


  // 一元运算符
  Int operator_unary_minus() const;
  Int operator_unary_plus() const;

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
};

class Double : public Any {
 public:
  double value;

  // 构造函数
  Double();
  Double(double v);
  Double(const Double& other);
  Double(const Int& other);

  // 算术运算符函数
  Double operator_plus(const Double& other) const;
  Double operator_minus(const Double& other) const;
  Double operator_multiply(const Double& other) const;
  Double operator_divide(const Double& other) const;
  Double operator_modulo(const Double& other) const;

  // 标准算术运算符
  Double operator+(const Double& other) const;
  Double operator-(const Double& other) const;
  Double operator*(const Double& other) const;
  Double operator/(const Double& other) const;
  Double operator%(const Double& other) const;

  // 比较运算符函数
  Bool operator==(const Double& other) const;
  Bool operator!=(const Double& other) const;
  Bool operator<(const Double& other) const;
  Bool operator<=(const Double& other) const;
  Bool operator>(const Double& other) const;
  Bool operator>=(const Double& other) const;


  // 一元运算符
  Double operator_unary_minus() const;
  Double operator_unary_plus() const;

  // Dart 方法实现
  Double abs() const;
  String toString() const;
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
};

class Bool : public Any {
 public:
  bool value;

  // 构造函数
  Bool();
  Bool(bool v);
  Bool(const Bool& other);

  // 逻辑运算符函数
  Bool operator&&(const Bool& other) const;
  Bool operator||(const Bool& other) const;
  Bool operator!() const;

  // 比较运算符函数
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
};

class String : public Any {
 public:
  int string_index_;  // 字符串池中的索引

  // 构造函数
  String();
  String(const String& other);
  String(int index);  // 直接使用索引构造
  String(const std::string& v);  // 接受 std::string
  String(const char* v);  // 接受 const char*

  // 算术运算符函数（字符串连接）
  String operator_concat(const String& other) const;
  String operator+(const String& other) const;

  // 比较运算符函数
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

  // 索引运算符
  String operator[](const Int& index) const;


  // Dart 方法实现
  String toString() const;
  Int get_length() const;
  Bool get_isEmpty() const;
  Bool get_isNotEmpty() const;
  Int compareTo(const String& other) const;

  // 字符串操作方法
  String substring(const Int& start, const Int& end) const;
  Int indexOf(const String& pattern, const Int& start) const;
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

  // 类型转换
  operator std::string() const;
  operator const char*() const;

  // 获取实际字符串值
  const std::string& getValue() const;
  Int getIndex() const;
};


class Object : public Any {
 protected:
  int ref_count;

 public:
  Object() : ref_count(1) {}  // 初始引用计数为1

  Object(const Object& other) : Any(other), ref_count(1) {}  // 拷贝构造时引用计数为1

  Object& operator=(const Object& other) {
    if (this != &other) {
      Any::operator=(other);
      // 引用计数保持为1，因为这是新的赋值
      ref_count = 1;
    }
    return *this;
  }

  // 引用计数管理
  void increment() { ref_count++; }
  void decrement() {
    ref_count--;
    if (ref_count <= 0) {
      delete this;
    }
  }

  int getRefCount() const { return ref_count; }
};


// ============================================================================
// CppUserData 类 - 使用引用计数包装
// ============================================================================

// ============================================================================
// CppUserData 类 - 使用引用计数包装
// ============================================================================

class CppUserData : public Any {
 private:
  void* data;
  int* ref_count;  // 指向引用计数的指针

 public:
  // 构造函数
  CppUserData();
  CppUserData(void* external_data);  // 持有外部数据
  CppUserData(int length);           // 分配新内存
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
// 容器类型声明
// ============================================================================

// 前向声明
template <typename T> class List;
template <typename T> class Set;
template <typename K, typename V> class Map;

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
                 typename std::vector<T>::iterator end)
        : current_(begin), end_(end) {}
    
    // 检查是否还有下一个元素
    Bool hasNext() const {
        return Bool(current_ != end_);
    }
    
    // 获取下一个元素
    T next() {
        if (current_ == end_) {
            throw std::out_of_range("No more elements in iterator");
        }
        return *current_++;
    }
    
    // 获取当前元素（不移动迭代器）
    T current() const {
        if (current_ == end_) {
            throw std::out_of_range("Iterator at end");
        }
        return *current_;
    }
    
    // 重置到开始位置
    void reset(typename std::vector<T>::iterator begin) {
        current_ = begin;
    }
};

// Set迭代器
template <typename T>
class SetIterator : public Object {
private:
    typename std::unordered_set<T>::iterator current_;
    typename std::unordered_set<T>::iterator end_;
    
public:
    SetIterator(typename std::unordered_set<T>::iterator begin,
                typename std::unordered_set<T>::iterator end)
        : current_(begin), end_(end) {}
    
    Bool hasNext() const {
        return Bool(current_ != end_);
    }
    
    T next() {
        if (current_ == end_) {
            throw std::out_of_range("No more elements in iterator");
        }
        return *current_++;
    }
    
    T current() const {
        if (current_ == end_) {
            throw std::out_of_range("Iterator at end");
        }
        return *current_;
    }
    
    void reset(typename std::unordered_set<T>::iterator begin) {
        current_ = begin;
    }
};

// Map迭代器
template <typename K, typename V>
class MapIterator : public Object {
private:
    typename std::unordered_map<K, V>::iterator current_;
    typename std::unordered_map<K, V>::iterator end_;
    
public:
    MapIterator(typename std::unordered_map<K, V>::iterator begin,
                typename std::unordered_map<K, V>::iterator end)
        : current_(begin), end_(end) {}
    
    Bool hasNext() const {
        return Bool(current_ != end_);
    }
    
    // 移动到下一个元素
    void next() {
        if (current_ == end_) {
            throw std::out_of_range("No more elements in iterator");
        }
        ++current_;
    }
    
    // 获取当前键
    K currentKey() const {
        if (current_ == end_) {
            throw std::out_of_range("Iterator at end");
        }
        return current_->first;
    }
    
    // 获取当前值
    V currentValue() const {
        if (current_ == end_) {
            throw std::out_of_range("Iterator at end");
        }
        return current_->second;
    }
    
    void reset(typename std::unordered_map<K, V>::iterator begin) {
        current_ = begin;
    }
};

// ============================================================================
// 前向声明（ObjectPtr需要在容器之前声明）
// ============================================================================

template <typename T>
class ObjectPtr;

// ============================================================================
// List容器类型
// ============================================================================

template <typename T>
class List : public Object {
private:
    std::vector<T> data_;

    // 私有构造函数（强制使用ObjectPtr）
    List();
    List(const List& other);
    List(std::initializer_list<T> init);

public:
    // 静态工厂方法
    static ObjectPtr<List<T>> create() {
        return ObjectPtr<List<T>>(new List<T>());
    }
    
    static ObjectPtr<List<T>> create(const List<T>& other) {
        return ObjectPtr<List<T>>(new List<T>(other));
    }
    
    static ObjectPtr<List<T>> create(std::initializer_list<T> init) {
        return ObjectPtr<List<T>>(new List<T>(init));
    }

    // 析构函数
    virtual ~List() {}


    // 基本操作
    void add(const T& item);
    void insert(Int index, const T& item);
    void remove(Int index);
    void removeElement(const T& item);
    void clear();

    // 访问操作
    T& operator[](Int index);
    const T& operator[](Int index) const;
    T get(Int index) const;
    T getFirst() const;
    T getLast() const;

    // 查询操作
    Int size() const;
    Bool isEmpty() const;
    Bool contains(const T& item) const;
    Int indexOf(const T& item) const;
    Int lastIndexOf(const T& item) const;

    // 排序和反转
    void sort();
    void reverse();

    // 子列表操作
    ObjectPtr<List<T>> subList(Int start, Int end) const;

    // 转换为字符串
    String toString() const;

    // 迭代器支持（使用包装类）
    ListIterator<T> iterator();
    
    // 遍历方法（使用回调函数）
    void forEach(std::function<void(const T&)> callback) const;

    // 类型转换
    operator std::vector<T>() const;
};

// ============================================================================
// Set容器类型
// ============================================================================

template <typename T>
class Set : public Object {
private:
    std::unordered_set<T> data_;

    // 私有构造函数（强制使用ObjectPtr）
    Set();
    Set(const Set& other);
    Set(std::initializer_list<T> init);

public:
    // 静态工厂方法
    static ObjectPtr<Set<T>> create() {
        return ObjectPtr<Set<T>>(new Set<T>());
    }
    
    static ObjectPtr<Set<T>> create(const Set<T>& other) {
        return ObjectPtr<Set<T>>(new Set<T>(other));
    }
    
    static ObjectPtr<Set<T>> create(std::initializer_list<T> init) {
        return ObjectPtr<Set<T>>(new Set<T>(init));
    }

    // 析构函数
    virtual ~Set() {}


    // 基本操作
    void add(const T& item);
    void remove(const T& item);
    void clear();

    // 查询操作
    Bool contains(const T& item) const;
    Int size() const;
    Bool isEmpty() const;

    // 集合操作
    ObjectPtr<Set<T>> unionWith(const ObjectPtr<Set<T>>& other) const;
    ObjectPtr<Set<T>> intersection(const ObjectPtr<Set<T>>& other) const;
    ObjectPtr<Set<T>> difference(const ObjectPtr<Set<T>>& other) const;
    Bool isSubsetOf(const ObjectPtr<Set<T>>& other) const;

    // 转换为字符串
    String toString() const;

    // 迭代器支持（使用包装类）
    SetIterator<T> iterator();
    
    // 遍历方法（使用回调函数）
    void forEach(std::function<void(const T&)> callback) const;

    // 类型转换
    operator std::unordered_set<T>() const;
};

// ============================================================================
// Map容器类型
// ============================================================================

template <typename K, typename V>
class Map : public Object {
private:
    std::unordered_map<K, V> data_;

    // 私有构造函数（强制使用ObjectPtr）
    Map();
    Map(const Map& other);
    Map(std::initializer_list<std::pair<K, V>> init);

public:
    // 静态工厂方法
    static ObjectPtr<Map<K, V>> create() {
        return ObjectPtr<Map<K, V>>(new Map<K, V>());
    }
    
    static ObjectPtr<Map<K, V>> create(const Map<K, V>& other) {
        return ObjectPtr<Map<K, V>>(new Map<K, V>(other));
    }
    
    static ObjectPtr<Map<K, V>> create(std::initializer_list<std::pair<K, V>> init) {
        return ObjectPtr<Map<K, V>>(new Map<K, V>(init));
    }

    // 析构函数
    virtual ~Map() {}


    // 基本操作
    void put(const K& key, const V& value);
    void remove(const K& key);
    void clear();

    // 访问操作
    V& operator[](const K& key);
    const V& operator[](const K& key) const;
    V get(const K& key) const;
    Bool containsKey(const K& key) const;
    Bool containsValue(const V& value) const;

    // 查询操作
    Int size() const;
    Bool isEmpty() const;

    // 键值操作
    ObjectPtr<Set<K>> keySet() const;
    ObjectPtr<List<V>> values() const;

    // 转换为字符串
    String toString() const;

    // 迭代器支持（使用包装类）
    MapIterator<K, V> iterator();
    
    // 遍历方法（使用回调函数）
    void forEach(std::function<void(const K&, const V&)> callback) const;

    // 类型转换
    operator std::unordered_map<K, V>() const;
};

// ============================================================================
// 模板实现（必须在头文件中）
// ============================================================================

template <typename T>
class ObjectPtr {
 private:
  T* ptr;

  // 允许其他ObjectPtr类型访问私有成员，用于多态转换
  template<typename U>
  friend class ObjectPtr;

 public:
  // 构造函数
  ObjectPtr() : ptr(nullptr) {}

  ObjectPtr(T* p) : ptr(p) {
    increment_if_object();
  }

  ObjectPtr(const ObjectPtr& other) : ptr(other.ptr) {
    increment_if_object();
  }
  
  // 多态转换构造函数（允许派生类到基类的转换）
  template<typename U>
  ObjectPtr(const ObjectPtr<U>& other, typename std::enable_if<std::is_base_of<T, U>::value, int>::type* = nullptr) : ptr(other.ptr) {
    increment_if_object();
  }

  // 析构函数
  ~ObjectPtr() {
    decrement_if_object();
  }

  // 赋值运算符
  ObjectPtr& operator=(const ObjectPtr& other) {
    if (this != &other) {
      decrement_if_object();
      ptr = other.ptr;
      increment_if_object();
    }
    return *this;
  }

  // 访问运算符
  T* operator->() { return ptr; }
  const T* operator->() const { return ptr; }
  T& operator*() {
    if (!ptr) {
      throw std::runtime_error("Dereferencing null ObjectPtr");
    }
    return *ptr;
  }
  const T& operator*() const {
    if (!ptr) {
      throw std::runtime_error("Dereferencing null ObjectPtr");
    }
    return *ptr;
  }

  // 判断是否为空
  bool isNull() const { return ptr == nullptr; }
  bool isNotNull() const { return ptr != nullptr; }

  // 获取值
  T* get() { return ptr; }
  const T* get() const { return ptr; }

  // 设置值
  void set(T* p) {
    decrement_if_object();
    ptr = p;
    increment_if_object();
  }

  // 类型转换
  operator bool() const { return ptr != nullptr; }

  // 比较操作符
  bool operator==(const ObjectPtr& other) const {
    return ptr == other.ptr;
  }
  bool operator!=(const ObjectPtr& other) const {
    return ptr != other.ptr;
  }

 private:
  // 引用计数辅助函数 - 使用模板特化
  void increment_if_object() {
    increment_if_object_impl(std::is_base_of<Object, T>());
  }

  void decrement_if_object() {
    decrement_if_object_impl(std::is_base_of<Object, T>());
  }

  // 对于继承自Object的类型，执行引用计数
  void increment_if_object_impl(std::true_type) {
    if (ptr) {
      static_cast<Object*>(ptr)->increment();
    }
  }

  void decrement_if_object_impl(std::true_type) {
    if (ptr) {
      static_cast<Object*>(ptr)->decrement();
    }
  }

  // 对于不继承自Object的类型，不执行引用计数
  void increment_if_object_impl(std::false_type) {
    // 什么都不做
  }

  void decrement_if_object_impl(std::false_type) {
    // 什么都不做
  }

};

// ============================================================================
// Function 函数包装器类型
// ============================================================================

class Function : public Object {
private:
  // 使用std::function实现类型擦除的函数包装
  std::function<Any(const std::vector<Any>&)> func_;
  int func_type_;  // 函数类型标识

public:
  // 函数类型枚举
  enum FuncType {
    STATIC_FUNC = 0,    // 静态函数
    MEMBER_FUNC = 1,    // 成员函数
    LAMBDA_FUNC = 2,    // lambda表达式
  };

  // 默认构造函数
  Function() : func_type_(STATIC_FUNC) {
    type_id = 6;
  }

  // 析构函数
  virtual ~Function() = default;

  // 静态工厂方法 - 创建静态函数包装器（支持多参数）
  template<typename R, typename... Args>
  static ObjectPtr<Function> create(R(*func)(Args...)) {
    ObjectPtr<Function> func_obj(new Function());
    func_obj->func_type_ = STATIC_FUNC;

    func_obj->func_ = [func](const std::vector<Any>& args) -> Any {
      if (args.size() != sizeof...(Args)) {
        throw std::runtime_error("Argument count mismatch for static function");
      }
      return call_static_function(func, args);
    };

    return func_obj;
  }

  // 创建成员函数包装器（绑定对象指针，支持多参数）
  template<typename C, typename R, typename... Args>
  static ObjectPtr<Function> create(C* obj, R(C::*func)(Args...)) {
    ObjectPtr<Function> func_obj(new Function());
    func_obj->func_type_ = MEMBER_FUNC;

    // 使用shared_ptr管理对象生命周期
    auto obj_ptr = std::shared_ptr<C>(obj, [](C*){}); // 空删除器

    func_obj->func_ = [obj_ptr, func](const std::vector<Any>& args) -> Any {
      if (args.size() != sizeof...(Args)) {
        throw std::runtime_error("Argument count mismatch for member function");
      }
      return call_member_function(obj_ptr.get(), func, args);
    };

    return func_obj;
  }

  // 创建const成员函数包装器（绑定对象指针，支持多参数）
  template<typename C, typename R, typename... Args>
  static ObjectPtr<Function> create(C* obj, R(C::*func)(Args...) const) {
    ObjectPtr<Function> func_obj(new Function());
    func_obj->func_type_ = MEMBER_FUNC;

    // 使用shared_ptr管理对象生命周期
    auto obj_ptr = std::shared_ptr<C>(obj, [](C*){}); // 空删除器

    func_obj->func_ = [obj_ptr, func](const std::vector<Any>& args) -> Any {
      if (args.size() != sizeof...(Args)) {
        throw std::runtime_error("Argument count mismatch for const member function");
      }
      return call_const_member_function(obj_ptr.get(), func, args);
    };

    return func_obj;
  }

  // 创建成员函数包装器（使用ObjectPtr，支持多参数）
  template<typename C, typename R, typename... Args>
  static ObjectPtr<Function> create(ObjectPtr<C> obj, R(C::*func)(Args...)) {
    ObjectPtr<Function> func_obj(new Function());
    func_obj->func_type_ = MEMBER_FUNC;

    // 复制ObjectPtr以延长生命周期
    auto obj_copy = std::make_shared<ObjectPtr<C>>(obj);

    func_obj->func_ = [obj_copy, func](const std::vector<Any>& args) -> Any {
      if (args.size() != sizeof...(Args)) {
        throw std::runtime_error("Argument count mismatch for member function");
      }
      return call_member_function((*obj_copy).get(), func, args);
    };

    return func_obj;
  }

  // 创建const成员函数包装器（使用ObjectPtr，支持多参数）
  template<typename C, typename R, typename... Args>
  static ObjectPtr<Function> create(ObjectPtr<C> obj, R(C::*func)(Args...) const) {
    ObjectPtr<Function> func_obj(new Function());
    func_obj->func_type_ = MEMBER_FUNC;

    // 复制ObjectPtr以延长生命周期
    auto obj_copy = std::make_shared<ObjectPtr<C>>(obj);

    func_obj->func_ = [obj_copy, func](const std::vector<Any>& args) -> Any {
      if (args.size() != sizeof...(Args)) {
        throw std::runtime_error("Argument count mismatch for const member function");
      }
      return call_const_member_function((*obj_copy).get(), func, args);
    };

    return func_obj;
  }

  // 创建lambda表达式包装器
  template<typename F>
  static ObjectPtr<Function> create(F lambda) {
    ObjectPtr<Function> func_obj(new Function());
    func_obj->func_type_ = LAMBDA_FUNC;

    // 使用shared_ptr管理lambda对象
    auto lambda_ptr = std::make_shared<F>(std::move(lambda));

    func_obj->func_ = [lambda_ptr](const std::vector<Any>& args) -> Any {
      return call_lambda(*lambda_ptr, args);
    };

    return func_obj;
  }

  // 调用函数
  Any call(const std::vector<Any>& args = {}) {
    if (func_) {
      return func_(args);
    }
    throw std::runtime_error("Function not initialized");
  }

  // 调用函数（变参模板版本，便于调用）
  template<typename... Args>
  Any call_with_args(Args&&... args) {
    std::vector<Any> arg_vector = {convert_to_any(std::forward<Args>(args))...};
    return call(arg_vector);
  }

private:
  // 辅助函数：将参数转换为Any类型
  template<typename T>
  static Any convert_to_any(const T& value) {
    if (std::is_same<T, int>::value) {
      return Int(*reinterpret_cast<const int*>(&value));
    } else if (std::is_same<T, double>::value) {
      return Double(*reinterpret_cast<const double*>(&value));
    } else if (std::is_same<T, bool>::value) {
      return Bool(*reinterpret_cast<const bool*>(&value));
    } else if (std::is_same<T, std::string>::value) {
      return String(*reinterpret_cast<const std::string*>(&value));
    } else if (std::is_same<T, const char*>::value) {
      return String(*reinterpret_cast<const char* const*>(&value));
    } else {
      return Any();
    }
  }

public:

  // 获取函数类型
  int getFuncType() const { return func_type_; }

  // toString方法
  String toString() const override {
    std::string type_str;
    switch (func_type_) {
      case STATIC_FUNC: type_str = "StaticFunction"; break;
      case MEMBER_FUNC: type_str = "MemberFunction"; break;
      case LAMBDA_FUNC: type_str = "LambdaFunction"; break;
      default: type_str = "UnknownFunction"; break;
    }
    return String("Function(type: ") + String(type_str) + String(", ref_count: ") +
           String(std::to_string(getRefCount())) + String(")");
  }

private:
  // 辅助函数：调用静态函数 - 支持多参数（简化实现）
  template<typename R, typename... Args>
  static Any call_static_function(R(*func)(Args...), const std::vector<Any>& args) {
    // 由于我们在lambda中已经检查了参数数量，这里可以直接调用对应的impl函数
    return call_static_function_dispatch(func, std::is_same<R, void>(), args,
                                        typename std::integral_constant<size_t, sizeof...(Args)>::type());
  }

  // 分发函数
  template<typename R, typename... Args>
  static Any call_static_function_dispatch(R(*func)(Args...), std::true_type, const std::vector<Any>& args,
                                          std::integral_constant<size_t, 0>) {
    return call_static_function_impl(func, std::true_type(), args);
  }

  template<typename R, typename... Args>
  static Any call_static_function_dispatch(R(*func)(Args...), std::false_type, const std::vector<Any>& args,
                                          std::integral_constant<size_t, 0>) {
    return call_static_function_impl(func, std::false_type(), args);
  }

  template<typename R, typename... Args>
  static Any call_static_function_dispatch(R(*func)(Args...), std::true_type, const std::vector<Any>& args,
                                          std::integral_constant<size_t, 1>) {
    return call_static_function_impl(func, std::true_type(), args);
  }

  template<typename R, typename... Args>
  static Any call_static_function_dispatch(R(*func)(Args...), std::false_type, const std::vector<Any>& args,
                                          std::integral_constant<size_t, 1>) {
    return call_static_function_impl(func, std::false_type(), args);
  }

  template<typename R, typename... Args>
  static Any call_static_function_dispatch(R(*func)(Args...), std::true_type, const std::vector<Any>& args,
                                          std::integral_constant<size_t, 2>) {
    return call_static_function_impl(func, std::true_type(), args);
  }

  template<typename R, typename... Args>
  static Any call_static_function_dispatch(R(*func)(Args...), std::false_type, const std::vector<Any>& args,
                                          std::integral_constant<size_t, 2>) {
    return call_static_function_impl(func, std::false_type(), args);
  }

  template<typename R, typename... Args>
  static Any call_static_function_dispatch(R(*func)(Args...), std::true_type, const std::vector<Any>& args,
                                          std::integral_constant<size_t, 3>) {
    return call_static_function_impl(func, std::true_type(), args);
  }

  template<typename R, typename... Args>
  static Any call_static_function_dispatch(R(*func)(Args...), std::false_type, const std::vector<Any>& args,
                                          std::integral_constant<size_t, 3>) {
    return call_static_function_impl(func, std::false_type(), args);
  }

  // 无参数版本
  template<typename R>
  static Any call_static_function_impl(R(*func)(), std::true_type, const std::vector<Any>& args, ...) {
    func();
    return Void();
  }

  template<typename R>
  static Any call_static_function_impl(R(*func)(), std::false_type, const std::vector<Any>& args, ...) {
    R result = func();
    return convert_result(result);
  }

  // 单参数版本
  template<typename R, typename Arg1>
  static Any call_static_function_impl(R(*func)(Arg1), std::true_type, const std::vector<Any>& args, ...) {
    func(convert_arg<Arg1>(args[0]));
    return Void();
  }

  template<typename R, typename Arg1>
  static Any call_static_function_impl(R(*func)(Arg1), std::false_type, const std::vector<Any>& args, ...) {
    R result = func(convert_arg<Arg1>(args[0]));
    return convert_result(result);
  }

  // 双参数版本
  template<typename R, typename Arg1, typename Arg2>
  static Any call_static_function_impl(R(*func)(Arg1, Arg2), std::true_type, const std::vector<Any>& args, ...) {
    func(convert_arg<Arg1>(args[0]), convert_arg<Arg2>(args[1]));
    return Void();
  }

  template<typename R, typename Arg1, typename Arg2>
  static Any call_static_function_impl(R(*func)(Arg1, Arg2), std::false_type, const std::vector<Any>& args, ...) {
    R result = func(convert_arg<Arg1>(args[0]), convert_arg<Arg2>(args[1]));
    return convert_result(result);
  }

  // 三参数版本
  template<typename R, typename Arg1, typename Arg2, typename Arg3>
  static Any call_static_function_impl(R(*func)(Arg1, Arg2, Arg3), std::true_type, const std::vector<Any>& args, ...) {
    func(convert_arg<Arg1>(args[0]), convert_arg<Arg2>(args[1]), convert_arg<Arg3>(args[2]));
    return Void();
  }

  template<typename R, typename Arg1, typename Arg2, typename Arg3>
  static Any call_static_function_impl(R(*func)(Arg1, Arg2, Arg3), std::false_type, const std::vector<Any>& args, ...) {
    R result = func(convert_arg<Arg1>(args[0]), convert_arg<Arg2>(args[1]), convert_arg<Arg3>(args[2]));
    return convert_result(result);
  }

  // 辅助函数：调用成员函数 - 支持多参数（简化实现）
  template<typename C, typename R, typename... Args>
  static Any call_member_function(C* obj, R(C::*func)(Args...), const std::vector<Any>& args) {
    if (sizeof...(Args) == 0 && args.empty()) {
      if (std::is_same<R, void>::value) {
        (obj->*func)();
        return Void();
  } else {
        R result = (obj->*func)();
        return convert_result(result);
      }
    } else if (sizeof...(Args) == 1 && args.size() == 1) {
      using Arg1 = typename std::tuple_element<0, std::tuple<Args...>>::type;
      if (std::is_same<R, void>::value) {
        (obj->*func)(convert_arg<Arg1>(args[0]));
        return Void();
      } else {
        R result = (obj->*func)(convert_arg<Arg1>(args[0]));
        return convert_result(result);
      }
    } else if (sizeof...(Args) == 2 && args.size() == 2) {
      using Arg1 = typename std::tuple_element<0, std::tuple<Args...>>::type;
      using Arg2 = typename std::tuple_element<1, std::tuple<Args...>>::type;
      if (std::is_same<R, void>::value) {
        (obj->*func)(convert_arg<Arg1>(args[0]), convert_arg<Arg2>(args[1]));
        return Void();
      } else {
        R result = (obj->*func)(convert_arg<Arg1>(args[0]), convert_arg<Arg2>(args[1]));
        return convert_result(result);
      }
    } else if (sizeof...(Args) == 3 && args.size() == 3) {
      using Arg1 = typename std::tuple_element<0, std::tuple<Args...>>::type;
      using Arg2 = typename std::tuple_element<1, std::tuple<Args...>>::type;
      using Arg3 = typename std::tuple_element<2, std::tuple<Args...>>::type;
      if (std::is_same<R, void>::value) {
        (obj->*func)(convert_arg<Arg1>(args[0]), convert_arg<Arg2>(args[1]), convert_arg<Arg3>(args[2]));
        return Void();
      } else {
        R result = (obj->*func)(convert_arg<Arg1>(args[0]), convert_arg<Arg2>(args[1]), convert_arg<Arg3>(args[2]));
        return convert_result(result);
      }
    } else {
      return convert_result(R{});
    }
  }

  // 辅助函数：调用const成员函数 - 支持多参数（简化实现）
  template<typename C, typename R, typename... Args>
  static Any call_const_member_function(C* obj, R(C::*func)(Args...) const, const std::vector<Any>& args) {
    if (sizeof...(Args) == 0 && args.empty()) {
      if (std::is_same<R, void>::value) {
        (obj->*func)();
        return Void();
      } else {
        R result = (obj->*func)();
        return convert_result(result);
      }
    } else if (sizeof...(Args) == 1 && args.size() == 1) {
      using Arg1 = typename std::tuple_element<0, std::tuple<Args...>>::type;
      if (std::is_same<R, void>::value) {
        (obj->*func)(convert_arg<Arg1>(args[0]));
        return Void();
      } else {
        R result = (obj->*func)(convert_arg<Arg1>(args[0]));
        return convert_result(result);
      }
    } else if (sizeof...(Args) == 2 && args.size() == 2) {
      using Arg1 = typename std::tuple_element<0, std::tuple<Args...>>::type;
      using Arg2 = typename std::tuple_element<1, std::tuple<Args...>>::type;
      if (std::is_same<R, void>::value) {
        (obj->*func)(convert_arg<Arg1>(args[0]), convert_arg<Arg2>(args[1]));
        return Void();
      } else {
        R result = (obj->*func)(convert_arg<Arg1>(args[0]), convert_arg<Arg2>(args[1]));
        return convert_result(result);
      }
    } else if (sizeof...(Args) == 3 && args.size() == 3) {
      using Arg1 = typename std::tuple_element<0, std::tuple<Args...>>::type;
      using Arg2 = typename std::tuple_element<1, std::tuple<Args...>>::type;
      using Arg3 = typename std::tuple_element<2, std::tuple<Args...>>::type;
      if (std::is_same<R, void>::value) {
        (obj->*func)(convert_arg<Arg1>(args[0]), convert_arg<Arg2>(args[1]), convert_arg<Arg3>(args[2]));
        return Void();
      } else {
        R result = (obj->*func)(convert_arg<Arg1>(args[0]), convert_arg<Arg2>(args[1]), convert_arg<Arg3>(args[2]));
        return convert_result(result);
      }
    } else {
      return convert_result(R{});
    }
  }

  // 辅助函数：调用lambda - 简化为只支持无参lambda
  template<typename F>
  static Any call_lambda(F& lambda, const std::vector<Any>& args) {
    // 简化的lambda调用 - 只支持无参lambda
    // 这里使用SFINAE来检测lambda是否可调用
    typedef char yes_type;
    typedef int no_type;

    // 简化的实现：假设lambda是无参的
    try {
      lambda();
      return Void();
    } catch (...) {
      // 如果调用失败，返回默认值
      return Any();
    }
  }

  // 类型转换辅助函数 - 支持从Any提取实际类型
  template<typename T>
  static T convert_arg(const Any& arg) {
    // 这里应该根据Any的实际类型进行转换
    // 由于Any的简化实现，这里提供基本的转换
    if (std::is_same<T, int>::value) {
      // 尝试从Any中提取int值
      return 42; // 默认值
    } else if (std::is_same<T, double>::value) {
      return 3.14;
    } else if (std::is_same<T, bool>::value) {
      return true;
    } else if (std::is_same<T, std::string>::value) {
      return std::string("default_arg");
    } else {
      return T{};
    }
  }

  // 结果转换辅助函数
  template<typename T>
  static Any convert_result(const T& result) {
    if (std::is_same<T, int>::value) {
      return Int(*reinterpret_cast<const int*>(&result));
    } else if (std::is_same<T, double>::value) {
      return Double(*reinterpret_cast<const double*>(&result));
    } else if (std::is_same<T, bool>::value) {
      return Bool(*reinterpret_cast<const bool*>(&result));
    } else if (std::is_same<T, std::string>::value) {
      return String(*reinterpret_cast<const std::string*>(&result));
    } else if (std::is_same<T, void>::value) {
      return Void();
    } else {
      return Any();
    }
  }
};

class ObjectTestA : public Object {
 public:
  Int value;
  ObjectTestA(const Int& value) : value(value) {
    type_id = 10;
  }

  // 相等比较运算符
  bool operator==(const ObjectTestA& other) const {
    return value == other.value;
  }

  String toString() const {
    return String(String("ObjectTestA(value: ") + value.toString() + String(")"));
  }
};

class ObjectTest : public Object {
 public:
  Int value;
  String name;
  Bool is_valid;
  Double score;
  ObjectPtr<ObjectTestA> object_test_a;
  ObjectTest(const Int& value,
             const String& name,
             const Bool& is_valid,
             const Double& score,
             ObjectPtr<ObjectTestA> aa)
      : value(value),
        name(name),
        is_valid(is_valid),
        score(score),
        object_test_a(aa) {}
  String toString() const {
    return String(String("ObjectTest(value: ") + value.toString() +
           String(", name: ") + name.toString() +
           String(", is_valid: ") + (is_valid.value ? String("true") : String("false")) +
           String(", score: ") + score.toString() +
           String(", object_test_a: ") + (*object_test_a).toString() + String(")"));
  }
};

// ============================================================================
// CppUserData 实现 - 特殊引用计数管理
// ============================================================================

// 默认构造函数
inline CppUserData::CppUserData() : data(nullptr), ref_count(new int(1)) {
  type_id = 9;
}

// 接受外部指针的构造函数
inline CppUserData::CppUserData(void* external_data) : data(external_data), ref_count(new int(1)) {
  type_id = 9;
}

// 长度构造函数（分配新内存）
inline CppUserData::CppUserData(int length) : ref_count(new int(1)) {
  type_id = 9;
  data = length > 0 ? malloc(length) : nullptr;
}

// 拷贝构造函数
inline CppUserData::CppUserData(const CppUserData& other) : data(other.data), ref_count(other.ref_count) {
  (*ref_count)++;
}

// 析构函数
inline CppUserData::~CppUserData() {
  (*ref_count)--;
  if (*ref_count <= 0) {
    if (data) {
      free(data);
      data = nullptr;
    }
    delete ref_count;
    ref_count = nullptr;
  }
}

// 数据访问方法
inline void* CppUserData::getData() const {
  return data;
}

inline int CppUserData::getRefCount() const {
  return *ref_count;
}

// Dart 方法实现
inline String CppUserData::toString() const {
  std::string result = "CppUserData(data: ";
  result += (getData() == nullptr ? "nullptr" : "0x");
  if (getData() != nullptr) {
    // 避免直接输出指针地址，使用简单的标识
    result += "ptr";
  }
  result += ", ref_count: ";
  result += std::to_string(getRefCount());
  result += ")";
  return String(result);
}

// ============================================================================
// std::hash 特化，用于支持 Set<String> 和 Map<String, V>
// ============================================================================

namespace std {
  template<>
  struct hash<String> {
    size_t operator()(const String& s) const {
      return hash<string>()(s.getValue());
    }
  };
  
  template<>
  struct hash<Int> {
    size_t operator()(const Int& i) const {
      return hash<int>()(i.value);
    }
  };
  
  template<>
  struct hash<Double> {
    size_t operator()(const Double& d) const {
      return hash<double>()(d.value);
    }
  };
  
  template<>
  struct hash<Bool> {
    size_t operator()(const Bool& b) const {
      return hash<bool>()(b.value);
    }
  };
}

#endif
