# C++ 运行时库 API 参考

## 📚 概述

本文档详细介绍了 Dart2CPP C++ 运行时库的完整 API，包括所有基础类型、集合类型、工具函数和宏定义。

## 🏗️ 核心头文件

### 主头文件
```cpp
#include "dart2cpp.h"  // 包含所有核心组件
```

### 分模块头文件
```cpp
#include "object.h"              // 基础类型定义
#include "dart_macros.h"         // Dart 语法糖宏
#include "dart_helpers.h"        // 辅助工具函数
#include "dart_async.h"          // 异步编程支持
#include "dart_oop_extensions.h" // OOP 特性支持
```

## 🔢 基础类型 API

### Any 基类

所有 Dart 类型的基类，提供通用接口。

```cpp
class Any {
public:
    int type_id;  // 类型标识符
    
    // 构造函数
    Any();
    Any(const Any& other);
    Any& operator=(const Any& other);
    virtual ~Any();
    
    // 核心方法
    bool isNull() const;
    virtual String toString() const;
};
```

**类型标识符**:
- `0`: Void/Null
- `1`: Int
- `2`: Double
- `3`: Bool
- `4`: String
- `5`: Object
- `6`: UserData

### Int 类型

32位整数类型，完全兼容 Dart 的 `int` 类型。

```cpp
class Int : public Any {
public:
    int value;
    
    // 构造函数
    Int();
    Int(int v);
    Int(const Int& other);
    Int(const Nullable&);  // 空值构造
    
    // 赋值运算符
    Int& operator=(const Int& other);
    Int& operator=(const Nullable&);
    
    // 算术运算符
    Int operator+(const Int& other) const;
    Int operator-(const Int& other) const;
    Int operator*(const Int& other) const;
    Int operator/(const Int& other) const;
    Int operator%(const Int& other) const;
    
    // 与 Double 的混合运算
    Double operator+(const Double& other) const;
    Double operator-(const Double& other) const;
    Double operator*(const Double& other) const;
    Double operator/(const Double& other) const;
    
    // 比较运算符
    Bool operator==(const Int& other) const;
    Bool operator!=(const Int& other) const;
    Bool operator<(const Int& other) const;
    Bool operator<=(const Int& other) const;
    Bool operator>(const Int& other) const;
    Bool operator>=(const Int& other) const;
    
    // 位运算符
    Int operator_bitwise_and(const Int& other) const;
    Int operator_bitwise_or(const Int& other) const;
    Int operator_bitwise_xor(const Int& other) const;
    Int operator_shift_left(const Int& other) const;
    Int operator_shift_right(const Int& other) const;
    Int operator_bitwise_not() const;
    
    // 一元运算符
    Int operator_unary_minus() const;
    Int operator_unary_plus() const;
    Int operator_negate() const;
    
    // Dart 方法
    Int abs() const;
    String toString() const;
    Double toDouble() const;
    Int compareTo(const Int& other) const;
    Int gcd(const Int& other) const;
    Int truncatingDivision(const Int& other) const;  // ~/ 运算符
    
    // 属性方法
    Int get_sign() const;
    Bool get_isEven() const;
    Bool get_isOdd() const;
    Bool get_isNegative() const;
    Bool get_isFinite() const;
    Bool get_isInfinite() const;
    Bool get_isNaN() const;
    
    // 类型转换
    int toInt() const;
    bool toBool() const;
};
```

### Double 类型

64位浮点数类型，完全兼容 Dart 的 `double` 类型。

```cpp
class Double : public Any {
public:
    double value;
    
    // 构造函数
    Double();
    Double(double v);
    Double(const Double& other);
    Double(const Int& other);
    Double(const Nullable&);
    
    // 赋值运算符
    Double& operator=(const Double& other);
    Double& operator=(const Nullable&);
    
    // 算术运算符
    Double operator+(const Double& other) const;
    Double operator-(const Double& other) const;
    Double operator*(const Double& other) const;
    Double operator/(const Double& other) const;
    Double operator%(const Double& other) const;
    
    // 比较运算符
    Bool operator==(const Double& other) const;
    Bool operator!=(const Double& other) const;
    Bool operator<(const Double& other) const;
    Bool operator<=(const Double& other) const;
    Bool operator>(const Double& other) const;
    Bool operator>=(const Double& other) const;
    
    // 一元运算符
    Double operator_unary_minus() const;
    Double operator_unary_plus() const;
    Double operator_negate() const;
    
    // Dart 方法
    Double abs() const;
    String toString() const;
    String toStringAsFixed(Int digits) const;
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
    
    // 类型转换
    double toDouble() const;
    Bool toBool() const;
};
```

### Bool 类型

布尔类型，支持隐式转换到条件表达式。

```cpp
class Bool : public Any {
public:
    bool value;
    
    // 构造函数
    Bool();
    Bool(bool v);
    Bool(const Bool& other);
    Bool(const Nullable&);
    
    // 赋值运算符
    Bool& operator=(const Bool& other);
    Bool& operator=(const Nullable&);
    
    // 逻辑运算符
    Bool operator&&(const Bool& other) const;
    Bool operator||(const Bool& other) const;
    Bool operator!() const;
    
    // 比较运算符
    Bool operator==(const Bool& other) const;
    Bool operator!=(const Bool& other) const;
    
    // Dart 方法
    String toString() const;
    
    // 类型转换
    bool toBool() const;
    operator bool() const;  // 隐式转换
};
```

### String 类型

字符串类型，带字符串池优化。

```cpp
class String : public Any {
private:
    int pool_index_;  // 字符串池索引
    
public:
    // 构造函数
    String();
    String(const std::string& str);
    String(const char* str);
    String(const String& other);
    String(const Nullable&);
    
    // 赋值运算符
    String& operator=(const String& other);
    String& operator=(const Nullable&);
    
    // 字符串运算符
    String operator+(const String& other) const;
    Bool operator==(const String& other) const;
    Bool operator!=(const String& other) const;
    Bool operator<(const String& other) const;
    Bool operator<=(const String& other) const;
    Bool operator>(const String& other) const;
    Bool operator>=(const String& other) const;
    
    // 索引访问
    String operator[](Int index) const;
    
    // 基本属性
    Int length() const;
    Bool isEmpty() const;
    Bool isNotEmpty() const;
    
    // 字符串方法
    String substring(Int start) const;
    String substring(Int start, Int end) const;
    String toUpperCase() const;
    String toLowerCase() const;
    String trim() const;
    String trimLeft() const;
    String trimRight() const;
    
    // 查找方法
    Bool contains(const String& other) const;
    Bool startsWith(const String& prefix) const;
    Bool endsWith(const String& suffix) const;
    Int indexOf(const String& pattern) const;
    Int indexOf(const String& pattern, Int start) const;
    Int lastIndexOf(const String& pattern) const;
    Int lastIndexOf(const String& pattern, Int start) const;
    
    // 替换方法
    String replaceAll(const String& from, const String& to) const;
    String replaceFirst(const String& from, const String& to) const;
    String replaceRange(Int start, Int end, const String& replacement) const;
    
    // 填充方法
    String padLeft(Int width) const;
    String padLeft(Int width, const String& padding) const;
    String padRight(Int width) const;
    String padRight(Int width, const String& padding) const;
    
    // 分割方法
    ObjectPtr<List<String>> split(const String& pattern) const;
    
    // 比较方法
    Int compareTo(const String& other) const;
    
    // 类型转换
    String toString() const;
    std::string getValue() const;
    const char* c_str() const;
};
```

## 📦 集合类型 API

### List<T> 类型

动态数组类型，对应 Dart 的 `List<T>`。

```cpp
template<typename T>
class List : public Any {
private:
    std::vector<T> elements_;
    
public:
    // 静态工厂方法
    static ObjectPtr<List<T>> create();
    static ObjectPtr<List<T>> filled(Int length, const T& fill);
    static ObjectPtr<List<T>> generate(Int length, std::function<T(Int)> generator);
    
    // 基本操作
    void add(const T& element);
    void addAll(ObjectPtr<List<T>> other);
    void insert(Int index, const T& element);
    void insertAll(Int index, ObjectPtr<List<T>> other);
    T removeAt(Int index);
    Bool remove(const T& element);
    void removeWhere(std::function<Bool(const T&)> test);
    void clear();
    
    // 访问操作
    T get(Int index) const;
    void set(Int index, const T& value);
    T operator[](Int index) const;
    T getFirst() const;
    T getLast() const;
    
    // 查询操作
    Int size() const;
    Int length() const;
    Bool isEmpty() const;
    Bool isNotEmpty() const;
    Bool contains(const T& element) const;
    Int indexOf(const T& element) const;
    Int indexOf(const T& element, Int start) const;
    Int lastIndexOf(const T& element) const;
    Int lastIndexOf(const T& element, Int start) const;
    
    // 子列表操作
    ObjectPtr<List<T>> subList(Int start) const;
    ObjectPtr<List<T>> subList(Int start, Int end) const;
    ObjectPtr<List<T>> getRange(Int start, Int end) const;
    void setRange(Int start, Int end, ObjectPtr<List<T>> iterable);
    void fillRange(Int start, Int end, const T& fillValue);
    
    // 排序和反转
    void sort();
    void sort(std::function<Int(const T&, const T&)> compare);
    void shuffle();
    ObjectPtr<List<T>> reversed() const;
    
    // 高阶函数
    template<typename R>
    ObjectPtr<List<R>> map(std::function<R(const T&)> mapper) const;
    
    ObjectPtr<List<T>> where(std::function<Bool(const T&)> test) const;
    ObjectPtr<List<T>> whereType() const;
    
    template<typename R>
    R fold(R initialValue, std::function<R(R, const T&)> combine) const;
    
    T reduce(std::function<T(const T&, const T&)> combine) const;
    
    Bool every(std::function<Bool(const T&)> test) const;
    Bool any(std::function<Bool(const T&)> test) const;
    
    void forEach(std::function<void(const T&)> action) const;
    
    // 连接操作
    String join() const;
    String join(const String& separator) const;
    
    // 迭代器支持
    ObjectPtr<Iterator<T>> iterator() const;
    
    // 类型转换
    String toString() const;
    ObjectPtr<List<T>> toList() const;
    ObjectPtr<Set<T>> toSet() const;
};
```

### Set<T> 类型

集合类型，对应 Dart 的 `Set<T>`。

```cpp
template<typename T>
class Set : public Any {
private:
    std::unordered_set<T> elements_;
    
public:
    // 静态工厂方法
    static ObjectPtr<Set<T>> create();
    static ObjectPtr<Set<T>> from(ObjectPtr<List<T>> elements);
    
    // 基本操作
    Bool add(const T& element);
    void addAll(ObjectPtr<Set<T>> other);
    Bool remove(const T& element);
    void removeAll(ObjectPtr<Set<T>> other);
    void retainAll(ObjectPtr<Set<T>> other);
    void clear();
    
    // 查询操作
    Int size() const;
    Int length() const;
    Bool isEmpty() const;
    Bool isNotEmpty() const;
    Bool contains(const T& element) const;
    
    // 集合运算
    ObjectPtr<Set<T>> union_(ObjectPtr<Set<T>> other) const;
    ObjectPtr<Set<T>> intersection(ObjectPtr<Set<T>> other) const;
    ObjectPtr<Set<T>> difference(ObjectPtr<Set<T>> other) const;
    Bool isSubsetOf(ObjectPtr<Set<T>> other) const;
    Bool isSupersetOf(ObjectPtr<Set<T>> other) const;
    
    // 高阶函数
    template<typename R>
    ObjectPtr<Set<R>> map(std::function<R(const T&)> mapper) const;
    
    ObjectPtr<Set<T>> where(std::function<Bool(const T&)> test) const;
    
    void forEach(std::function<void(const T&)> action) const;
    
    // 迭代器支持
    ObjectPtr<Iterator<T>> iterator() const;
    
    // 类型转换
    String toString() const;
    ObjectPtr<List<T>> toList() const;
    ObjectPtr<Set<T>> toSet() const;
};
```

### Map<K,V> 类型

映射类型，对应 Dart 的 `Map<K,V>`。

```cpp
template<typename K, typename V>
class Map : public Any {
private:
    std::unordered_map<K, V> map_;
    
public:
    // 静态工厂方法
    static ObjectPtr<Map<K, V>> create();
    static ObjectPtr<Map<K, V>> from(ObjectPtr<Map<K, V>> other);
    
    // 基本操作
    void put(const K& key, const V& value);
    V get(const K& key) const;
    V operator[](const K& key) const;
    V remove(const K& key);
    void clear();
    
    // 查询操作
    Int size() const;
    Int length() const;
    Bool isEmpty() const;
    Bool isNotEmpty() const;
    Bool containsKey(const K& key) const;
    Bool containsValue(const V& value) const;
    
    // 批量操作
    void addAll(ObjectPtr<Map<K, V>> other);
    void removeWhere(std::function<Bool(const K&, const V&)> test);
    
    // 视图操作
    ObjectPtr<Set<K>> keySet() const;
    ObjectPtr<List<V>> values() const;
    ObjectPtr<List<MapEntry<K, V>>> entries() const;
    
    // 高阶函数
    template<typename R>
    ObjectPtr<Map<K, R>> map(std::function<R(const K&, const V&)> mapper) const;
    
    void forEach(std::function<void(const K&, const V&)> action) const;
    
    // 类型转换
    String toString() const;
};
```

## 🔧 工具类和辅助函数

### 智能指针 ObjectPtr<T>

自动内存管理的智能指针模板。

```cpp
template<typename T>
class ObjectPtr {
private:
    T* ptr_;
    std::shared_ptr<int> ref_count_;
    
public:
    // 构造函数
    ObjectPtr(T* ptr = nullptr);
    ObjectPtr(const ObjectPtr& other);
    ObjectPtr(ObjectPtr&& other) noexcept;
    ~ObjectPtr();
    
    // 赋值运算符
    ObjectPtr& operator=(const ObjectPtr& other);
    ObjectPtr& operator=(ObjectPtr&& other) noexcept;
    ObjectPtr& operator=(T* ptr);
    
    // 访问运算符
    T* operator->() const;
    T& operator*() const;
    T* get() const;
    
    // 状态查询
    Bool isNull() const;
    Bool isNotNull() const;
    operator bool() const;
    
    // 重置
    void reset(T* ptr = nullptr);
    T* release();
    
    // 比较运算符
    Bool operator==(const ObjectPtr& other) const;
    Bool operator!=(const ObjectPtr& other) const;
    Bool operator==(std::nullptr_t) const;
    Bool operator!=(std::nullptr_t) const;
};
```

### 迭代器 Iterator<T>

集合迭代器接口。

```cpp
template<typename T>
class Iterator : public Any {
public:
    virtual ~Iterator() {}
    
    // 核心方法
    virtual Bool moveNext() = 0;
    virtual T current() const = 0;
    virtual void reset() = 0;
    
    // 工厂方法
    static ObjectPtr<Iterator<T>> create(ObjectPtr<List<T>> list);
    static ObjectPtr<Iterator<T>> create(ObjectPtr<Set<T>> set);
};
```

### 字符串池 StringPool

全局字符串池，优化字符串内存使用。

```cpp
class StringPool {
private:
    static StringPool* instance_;
    std::vector<std::string> pool_;
    std::unordered_map<std::string, int> index_map_;
    
    StringPool();
    
public:
    // 单例访问
    static StringPool* getInstance();
    
    // 字符串管理
    int intern(const std::string& str);
    const std::string& getString(int index) const;
    int getSize() const;
    void clear();
    
    // 禁止拷贝
    StringPool(const StringPool&) = delete;
    StringPool& operator=(const StringPool&) = delete;
};
```

## 🎯 宏定义 API

### 基础类型构造宏

```cpp
// 基础类型快速构造
#define dart_int(value) Int(value)
#define dart_double(value) Double(value)
#define dart_bool(value) Bool(value)
#define dart_string(value) String(value)
```

### 集合创建宏

```cpp
// List 创建
#define dart_list_int() List<Int>::create()
#define dart_list_string() List<String>::create()
#define dart_list_double() List<Double>::create()

// Set 创建
#define dart_set_int() Set<Int>::create()
#define dart_set_string() Set<String>::create()

// Map 创建
#define dart_map_string_int() Map<String, Int>::create()
#define dart_map_int_string() Map<Int, String>::create()
```

### 控制流宏

```cpp
// for-in 循环
#define dart_for_each(item_type, item_name, container) \
    for (Int _i(0); _i < (container)->size(); ++_i) { \
        item_type item_name = (container)->get(_i);

#define dart_end_for }
```

### 空值处理宏

```cpp
// 空值检查
template<typename T>
constexpr bool dart_is_null(const T& obj);

#define dart_is_not_null(ptr) (!dart_is_null(ptr))

// 空安全操作符 ?.
#define dart_null_check(left, right) \
    (dart_is_null(left) ? Null : (right))

// 空合并操作符 ??
#define dart_null_coalesce(left, right) \
    (dart_is_null(left) ? (right) : (left))
```

### 调试和工具宏

```cpp
// 打印输出
#define dart_print(value) \
    do { \
        std::cout << (value).toString().getValue() << std::endl; \
    } while (0)

// 断言
#define dart_assert(condition, message) \
    do { \
        if (!(condition)) { \
            std::cerr << "Assertion failed: " << message << std::endl; \
            std::abort(); \
        } \
    } while (0)
```

### 字符串拼接宏

```cpp
// 可变参数字符串拼接
template<typename... Args>
inline String dart_concat(const Any& first, const Args&... rest);

// 字面量列表创建
template <typename T, typename... Args>
ObjectPtr<List<T>> dart_literal(const T& first, const Args&... args);
```

## 🔮 异步编程 API

### Future<T> 类型

异步操作结果类型。

```cpp
template<typename T>
class Future : public Any {
private:
    std::future<T> future_;
    
public:
    // 静态工厂方法
    static ObjectPtr<Future<T>> value(const T& value);
    static ObjectPtr<Future<T>> delayed(Duration duration, std::function<T()> computation);
    static ObjectPtr<Future<T>> error(const Any& error);
    
    // 链式操作
    template<typename R>
    ObjectPtr<Future<R>> then(std::function<R(const T&)> onValue);
    
    ObjectPtr<Future<T>> catchError(std::function<T(const Any&)> onError);
    ObjectPtr<Future<T>> whenComplete(std::function<void()> action);
    
    // 同步等待
    T await();
    
    // 状态查询
    Bool isCompleted() const;
    Bool hasError() const;
    
    // 类型转换
    String toString() const;
};
```

### 异步宏

```cpp
// 异步函数定义
#define DART_ASYNC_FUNCTION auto

// 等待异步结果
#define DART_AWAIT(future) (future)->await()
```

## 🏗️ OOP 扩展 API

### 接口和 Mixin 支持

```cpp
// 接口定义
#define interface class

// Mixin 定义
#define mixin class

// 示例使用
interface Drawable {
public:
    virtual ~Drawable() {}
    virtual void draw() = 0;
};

mixin ColorMixin {
private:
    String color_;
public:
    virtual void setColor(const String& color) { color_ = color; }
    virtual String getColor() { return color_; }
};
```

## 📊 使用示例

### 基本类型使用

```cpp
#include "dart2cpp.h"

int main() {
    // 基础类型
    auto number = dart_int(42);
    auto pi = dart_double(3.14159);
    auto flag = dart_bool(true);
    auto message = dart_string("Hello, World!");
    
    // 运算操作
    auto sum = number + dart_int(8);
    auto greeting = message + dart_string(" from C++");
    
    // 输出
    dart_print(sum);
    dart_print(greeting);
    
    return 0;
}
```

### 集合操作示例

```cpp
#include "dart2cpp.h"

int main() {
    // 创建列表
    auto numbers = dart_list_int();
    numbers->add(dart_int(1));
    numbers->add(dart_int(2));
    numbers->add(dart_int(3));
    
    // 或使用字面量
    auto fruits = dart_literal(
        dart_string("apple"),
        dart_string("banana"),
        dart_string("orange")
    );
    
    // 高阶函数
    auto doubled = numbers->map([](Int n) { return n * dart_int(2); });
    auto evens = numbers->where([](Int n) { return (n % dart_int(2)) == dart_int(0); });
    
    // 遍历
    numbers->forEach([](Int n) { dart_print(n); });
    
    return 0;
}
```

### 空安全示例

```cpp
#include "dart2cpp.h"

int main() {
    String nullable_string;  // 默认为 null
    
    // 空值检查
    if (dart_is_null(nullable_string)) {
        dart_print(dart_string("String is null"));
    }
    
    // 空合并操作符
    auto safe_string = dart_null_coalesce(nullable_string, dart_string("default"));
    dart_print(safe_string);
    
    return 0;
}
```

## 📝 注意事项

### 内存管理
- 所有复杂类型使用 `ObjectPtr<T>` 进行自动内存管理
- 基础类型（Int, Double, Bool, String）可以直接使用值语义
- 避免手动 `delete`，智能指针会自动处理

### 性能考虑
- 字符串池自动优化相同字符串的内存使用
- 集合类型使用 STL 容器，性能接近原生 C++
- 避免不必要的类型转换和对象创建

### 线程安全
- 基础类型是线程安全的（不可变）
- 集合类型不是线程安全的，需要外部同步
- 字符串池是线程安全的

### 异常处理
- 运行时库使用 C++ 异常处理机制
- 数组越界、空指针访问等会抛出相应异常
- 建议使用 try-catch 块处理可能的异常
