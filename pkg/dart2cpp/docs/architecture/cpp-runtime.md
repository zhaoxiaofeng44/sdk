# C++ 运行时库设计

## 🎯 设计目标

C++ 运行时库的主要目标是提供与 Dart 语义完全等价的 C++ 类型系统，确保转换后的代码能够正确运行并保持原有的行为特征。

## 🏗️ 核心架构

### 类型层次结构

```cpp
Any (基类)
├── Nullable (空值类型)
├── Int (整数类型)
├── Double (浮点数类型) 
├── Bool (布尔类型)
├── String (字符串类型)
└── ObjectPtr<T> (智能指针模板)
    ├── List<T> (列表类型)
    ├── Set<T> (集合类型)
    ├── Map<K,V> (映射类型)
    └── UserDefinedClass (用户自定义类)
```

### 核心组件

#### 1. 基础类型系统 (`object.h/cpp`)

**Any 基类**:
```cpp
class Any {
public:
    int type_id;  // 类型标识符
    virtual String toString() const;
    virtual ~Any() {}
    bool isNull() const { return type_id == 0; }
};
```

**类型标识符**:
- `Void/Null`: 0
- `Int`: 1  
- `Double`: 2
- `Bool`: 3
- `String`: 4
- `Object`: 5
- `UserData`: 6

#### 2. 基础数值类型

**Int 类型**:
```cpp
class Int : public Any {
public:
    int value;
    
    // 构造函数
    Int(int v = 0) : value(v) { type_id = 1; }
    
    // 算术运算
    Int operator+(const Int& other) const;
    Int operator-(const Int& other) const;
    Int operator*(const Int& other) const;
    Int operator/(const Int& other) const;
    Int operator%(const Int& other) const;
    
    // 比较运算
    Bool operator==(const Int& other) const;
    Bool operator<(const Int& other) const;
    // ... 其他比较运算符
    
    // Dart 特有方法
    Int abs() const;
    Bool get_isEven() const;
    Bool get_isOdd() const;
    String toString() const;
};
```

**Double 类型**:
```cpp
class Double : public Any {
public:
    double value;
    
    // 类似 Int 的接口设计
    Double operator+(const Double& other) const;
    Double floor() const;
    Double ceil() const;
    Double round() const;
    String toStringAsFixed(Int digits) const;
};
```

#### 3. 字符串类型和字符串池

**字符串池优化**:
```cpp
class StringPool {
private:
    static StringPool* instance_;
    std::vector<std::string> pool_;
    std::unordered_map<std::string, int> index_map_;
    
public:
    static StringPool* getInstance();
    int intern(const std::string& str);
    const std::string& getString(int index) const;
};
```

**String 类型**:
```cpp
class String : public Any {
private:
    int pool_index_;  // 字符串池索引
    
public:
    String(const std::string& str);
    
    // 字符串操作
    String operator+(const String& other) const;
    Int length() const;
    Bool isEmpty() const;
    String substring(Int start, Int end) const;
    String toUpperCase() const;
    String toLowerCase() const;
    Bool contains(const String& other) const;
    Bool startsWith(const String& prefix) const;
    Bool endsWith(const String& suffix) const;
    String replaceAll(const String& from, const String& to) const;
    ObjectPtr<List<String>> split(const String& delimiter) const;
};
```

#### 4. 集合类型

**List 类型**:
```cpp
template<typename T>
class List : public Any {
private:
    std::vector<T> elements_;
    
public:
    static ObjectPtr<List<T>> create();
    
    // 基本操作
    void add(const T& element);
    void insert(Int index, const T& element);
    T get(Int index) const;
    void set(Int index, const T& value);
    T remove(Int index);
    void clear();
    
    // 查询操作
    Int size() const;
    Bool isEmpty() const;
    Bool contains(const T& element) const;
    Int indexOf(const T& element) const;
    
    // 高阶函数
    template<typename R>
    ObjectPtr<List<R>> map(std::function<R(const T&)> mapper) const;
    
    ObjectPtr<List<T>> where(std::function<Bool(const T&)> predicate) const;
    
    // 迭代器支持
    ObjectPtr<Iterator<T>> iterator() const;
};
```

**Map 类型**:
```cpp
template<typename K, typename V>
class Map : public Any {
private:
    std::unordered_map<K, V> map_;
    
public:
    static ObjectPtr<Map<K, V>> create();
    
    void put(const K& key, const V& value);
    V get(const K& key) const;
    Bool containsKey(const K& key) const;
    Bool containsValue(const V& value) const;
    V remove(const K& key);
    ObjectPtr<Set<K>> keySet() const;
    ObjectPtr<List<V>> values() const;
};
```

#### 5. 智能指针系统

**ObjectPtr 模板**:
```cpp
template<typename T>
class ObjectPtr {
private:
    T* ptr_;
    std::shared_ptr<int> ref_count_;
    
public:
    ObjectPtr(T* ptr = nullptr);
    ObjectPtr(const ObjectPtr& other);
    ObjectPtr& operator=(const ObjectPtr& other);
    ~ObjectPtr();
    
    T* operator->() const { return ptr_; }
    T& operator*() const { return *ptr_; }
    
    Bool isNull() const { return ptr_ == nullptr; }
    void reset(T* ptr = nullptr);
};
```

### 6. Dart 语法糖宏 (`dart_macros.h`)

#### 基础类型构造宏:
```cpp
#define dart_int(value) Int(value)
#define dart_double(value) Double(value)
#define dart_bool(value) Bool(value)
#define dart_string(value) String(value)
```

#### 集合创建宏:
```cpp
#define dart_list_int() List<Int>::create()
#define dart_list_string() List<String>::create()
#define dart_map_string_int() Map<String, Int>::create()
```

#### 控制流宏:
```cpp
// for-in 循环支持
#define dart_for_each(item_type, item_name, container) \
    for (Int _i(0); _i < (container)->size(); ++_i) { \
        item_type item_name = (container)->get(_i);

#define dart_end_for }
```

#### 空值处理宏:
```cpp
// 空值检查
template<typename T>
constexpr bool dart_is_null(const T& obj) {
    if constexpr (is_object_ptr<T>::value) {
        return obj->isNull();
    } else {
        return obj.isNull();
    }
}

// 空安全操作符 ?.
#define dart_null_check(left, right) \
    (dart_is_null(left) ? Null : (right))

// 空合并操作符 ??
#define dart_null_coalesce(left, right) \
    (dart_is_null(left) ? (right) : (left))
```

#### 调试和工具宏:
```cpp
#define dart_print(value) \
    do { \
        std::cout << (value).toString().getValue() << std::endl; \
    } while (0)

#define dart_assert(condition, message) \
    do { \
        if (!(condition)) { \
            std::cerr << "Assertion failed: " << message << std::endl; \
            std::abort(); \
        } \
    } while (0)
```

## 🔧 高级特性

### 1. 异步编程支持 (`dart_async.h`)

```cpp
template<typename T>
class Future {
private:
    std::future<T> future_;
    
public:
    static ObjectPtr<Future<T>> value(const T& value);
    static ObjectPtr<Future<T>> delayed(Duration duration, std::function<T()> computation);
    
    template<typename R>
    ObjectPtr<Future<R>> then(std::function<R(const T&)> onValue);
    
    ObjectPtr<Future<T>> catchError(std::function<T(const Any&)> onError);
    T await();  // 同步等待结果
};

// 异步函数宏
#define DART_ASYNC_FUNCTION auto
#define DART_AWAIT(future) (future)->await()
```

### 2. OOP 扩展支持 (`dart_oop_extensions.h`)

```cpp
// 接口定义宏
#define interface class

// Mixin 定义宏  
#define mixin class

// 示例：
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

// 使用多重继承实现
class Rectangle : public virtual Drawable, public virtual ColorMixin {
    // 实现...
};
```

### 3. 内存管理策略

#### 引用计数:
- 使用 `std::shared_ptr` 实现自动内存管理
- 循环引用检测和处理
- 弱引用支持

#### 字符串池:
- 全局字符串池减少内存占用
- 字符串去重和复用
- 线程安全的字符串管理

#### 对象生命周期:
- RAII 原则确保资源正确释放
- 智能指针自动管理对象生命周期
- 异常安全保证

## 📊 性能优化

### 1. 编译时优化:
- 模板特化减少运行时开销
- 内联函数优化
- 常量表达式计算

### 2. 运行时优化:
- 字符串池减少分配
- 容器预分配
- 缓存友好的数据布局

### 3. 内存优化:
- 小对象优化
- 内存池分配器
- 垃圾回收友好的设计

## 🧪 测试和验证

### 单元测试:
- 每个类型的完整测试覆盖
- 边界条件测试
- 性能基准测试

### 集成测试:
- 与 Dart 行为对比测试
- 内存泄漏检测
- 多线程安全测试

### 兼容性测试:
- 不同编译器支持
- 不同平台验证
- 不同 C++ 标准兼容性
