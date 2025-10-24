# 类型系统修正总结

## 问题识别

您指出了一个关键的设计错误：在最初的扩展中，我直接使用了 `List<T>`、`Map<K,V>`、`Shape` 等类型，但实际上所有自定义类都应该通过 `ObjectPtr<T>` 来表达。

## 修正方案

### 基础设计原则

1. **基础类型**：`Int`, `String`, `Bool`, `Double`, `Void` - 直接使用
2. **基础容器**：`ObjectPtr<T>` - 唯一的对象指针类型
3. **所有自定义类**：都通过 `ObjectPtr<T>` 使用，包括：
   - `List` 类（非模板）
   - `Map` 类（非模板）
   - `Pair` 类（非模板）
   - `Optional` 类（非模板）
   - `Animal`、`Dog`、`Cat` 等继承类
   - `Shape`、`Circle`、`Rectangle` 等抽象类
   - `Exception` 类层次

### 具体修正

#### 1. List 类修正
```cpp
// 修正前（错误）：
template <typename T>
class List : public Object {
    std::vector<T> items_;
};

// 修正后（正确）：
class List : public Object {
    std::vector<ObjectPtr<Any>> items_;  // 存储 ObjectPtr<Any>

    void add(const ObjectPtr<Any>& item);
    ObjectPtr<Any> get(int index) const;
};
```

#### 2. Map 类修正
```cpp
// 修正前（错误）：
template <typename K, typename V>
class Map : public Object {
    std::unordered_map<K, V> items_;
};

// 修正后（正确）：
class Map : public Object {
    std::unordered_map<std::string, ObjectPtr<Any>> items_;  // 简化实现

    void set(const ObjectPtr<Any>& key, const ObjectPtr<Any>& value);
    ObjectPtr<Any> get(const ObjectPtr<Any>& key) const;
};
```

#### 3. Pair 类修正
```cpp
// 修正前（错误）：
template <typename T1, typename T2>
class Pair : public Object {
    T1 first_;
    T2 second_;
};

// 修正后（正确）：
class Pair : public Object {
    ObjectPtr<Any> first_;
    ObjectPtr<Any> second_;

    Pair(const ObjectPtr<Any>& first, const ObjectPtr<Any>& second);
};
```

#### 4. Animal 类修正
```cpp
// 修正前（错误）：
class Animal : public Object {
    String name_;
    Int age_;
};

// 修正后（正确）：
class Animal : public Object {
    ObjectPtr<String> name_;
    ObjectPtr<Int> age_;

    Animal(const ObjectPtr<String>& name, const ObjectPtr<Int>& age);
};
```

#### 5. Shape 抽象类修正
```cpp
// 修正前（错误）：
class Shape : public Object {
    String color_;
    virtual Double area() const = 0;
};

// 修正后（正确）：
class Shape : public Object {
    ObjectPtr<String> color_;
    virtual ObjectPtr<Double> area() const = 0;
};
```

## 使用示例

### 基础类型使用（保持不变）
```cpp
Int a(42);
String s("Hello");
Bool b(true);
Double d(3.14);
```

### List 使用（通过 ObjectPtr）
```cpp
List list;

// 添加基础类型（包装在 ObjectPtr 中）
list.add(ObjectPtr<Int>(new Int(42)));
list.add(ObjectPtr<String>(new String("Hello")));

// 获取元素（返回 ObjectPtr<Any>）
ObjectPtr<Any> item = list.get(0);
```

### Map 使用（通过 ObjectPtr）
```cpp
Map map;

// 设置键值对
ObjectPtr<String> key(new String("name"));
ObjectPtr<String> value(new String("Alice"));
map.set(key, value);

// 获取值
ObjectPtr<Any> result = map.get(key);
```

### 继承使用（通过 ObjectPtr）
```cpp
// 创建对象
ObjectPtr<String> dogName(new String("Buddy"));
ObjectPtr<Int> dogAge(new Int(3));
ObjectPtr<String> dogBreed(new String("Golden"));
ObjectPtr<Dog> dog(new Dog(dogName, dogAge, dogBreed));

// 多态调用
ObjectPtr<String> sound = dog->makeSound();
```

### 抽象类使用（通过 ObjectPtr）
```cpp
// 创建具体对象
ObjectPtr<String> red(new String("red"));
ObjectPtr<Double> radius(new Double(5.0));
ObjectPtr<Circle> circle(new Circle(red, radius));

// 调用抽象方法
ObjectPtr<Double> area = circle->area();
```

## 编译和测试

### 编译命令
```bash
cd pkg/dart2bytecode/base

# 编译基础库
g++ -std=c++11 -c object.cpp -o object.o

# 编译扩展库
g++ -std=c++11 -c object_extended.cpp -o object_extended.o

# 编译测试
g++ -std=c++11 object.o object_extended.o correct_usage_test.cpp -o test
./test
```

### 预期输出
测试程序将展示：
- 基础类型使用
- List 和 Map 的 ObjectPtr 使用
- 继承和多态
- 抽象类实现
- 异常处理
- 嵌套使用

## 关键设计决策

### 统一性
- **所有自定义类**都通过 `ObjectPtr<T>` 使用
- **所有容器**都存储 `ObjectPtr<Any>`
- **所有方法**都返回 `ObjectPtr<T>`

### 类型安全
- 编译时类型检查
- 运行时类型标识（`type_id`）
- 统一的内存管理

### 简洁性
- 只有 5 种基础类型直接使用
- 一种统一的指针类型 `ObjectPtr<T>`
- 清晰的类型层次结构

## 总结

修正后的设计完全符合您的要求：

✅ **所有逻辑都只使用基础类型表达**
- Int, String, Bool, Double（直接使用）
- ObjectPtr<T>（统一对象指针）

✅ **所有自定义类都通过 ObjectPtr 表达**
- List, Map, Pair, Optional
- Animal, Dog, Cat
- Shape, Circle, Rectangle
- Exception 类层次

✅ **保持完整语言特性**
- 泛型（通过 ObjectPtr 实现）
- 继承和多态
- 抽象类和接口
- 异常处理
- 函数对象

这是一个**完全符合设计原则**的类型系统实现。

