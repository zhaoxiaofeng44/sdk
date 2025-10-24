# 快速参考手册

## 基础类型 API

### Int
```cpp
Int a(10);
Int b = a + Int(20);        // 加法
Int c = a * b;              // 乘法
bool eq = (a == b);         // 比较
Int abs = a.abs();          // 绝对值
String str = a.toString();  // 转字符串
double d = a.toDouble();    // 转浮点
```

### Double
```cpp
Double x(3.14);
Double y = x * Double(2.0);
Double z = x.floor();       // 向下取整
Double w = x.ceil();        // 向上取整
Double r = x.round();       // 四舍五入
```

### Bool
```cpp
Bool t(true);
Bool f = !t;                // 非
Bool and = t && Bool(false); // 与
Bool or = t || Bool(false);  // 或
```

### String
```cpp
String s("Hello");
String s2 = s + String(" World");  // 连接
int len = s.get_length();          // 长度
char c = s[0];                     // 索引
String upper = s.toUpperCase();    // 大写
String lower = s.toLowerCase();    // 小写
String sub = s.substring(0, 3);    // 子串
bool has = s.contains(String("ll")); // 包含
```

## 泛型容器 API

### List<T>
```cpp
List<Int> list;
list.add(Int(1));              // 添加
Int val = list.get(0);         // 获取
list.set(0, Int(2));           // 设置
int len = list.get_length();   // 长度
bool empty = list.get_isEmpty(); // 是否为空
list.removeAt(0);              // 删除
list.clear();                  // 清空
bool has = list.contains(Int(1)); // 包含
int idx = list.indexOf(Int(1));   // 查找索引
```

### Map<K,V>
```cpp
Map<String, Int> map;
map.set(String("key"), Int(42));    // 设置
Int val = map.get(String("key"));   // 获取
bool has = map.containsKey(String("key")); // 检查键
map.remove(String("key"));          // 删除
map.clear();                        // 清空
int len = map.get_length();         // 大小
```

### Pair<T1,T2>
```cpp
Pair<Int, String> p(Int(1), String("one"));
Int first = p.get_first();
String second = p.get_second();
p.set_first(Int(2));
```

### Optional<T>
```cpp
Optional<Int> opt1(Int(42));        // 有值
Optional<Int> opt2;                 // 无值
bool has = opt1.hasValue();         // 检查
Int val = opt1.get();               // 获取
Int def = opt2.getOrDefault(Int(0)); // 默认值
```

## 继承和多态

### 定义类
```cpp
class MyClass : public BaseClass {
private:
    Int value_;
public:
    MyClass(int v) : BaseClass(), value_(v) {}
    
    // 重写虚函数
    String getName() const override {
        return String("MyClass");
    }
    
    // 新方法
    Int getValue() const { return value_; }
};
```

### 多态使用
```cpp
BaseClass* obj = new MyClass(42);
String name = obj->getName();  // 调用 MyClass 的实现
delete obj;
```

## 抽象类和接口

### 定义抽象类
```cpp
class Interface : public Object {
public:
    virtual ~Interface() {}
    virtual void method() const = 0;  // 纯虚函数
};
```

### 实现接口
```cpp
class Concrete : public Interface {
public:
    void method() const override {
        // 实现
    }
};
```

## 异常处理

### 抛出异常
```cpp
throw ArgumentException(String("Error message"));
```

### 捕获异常
```cpp
try {
    // 可能抛出异常的代码
} catch (const ArgumentException& e) {
    // 处理特定异常
    String msg = e.get_message();
} catch (const Exception& e) {
    // 处理通用异常
}
```

## 函数对象

### Lambda 函数
```cpp
Function<Int, Int, Int> add([](Int a, Int b) {
    return a + b;
});
Int result = add(Int(10), Int(20));
```

### 带捕获的 Lambda
```cpp
Int multiplier(5);
Function<Int, Int> multiply([multiplier](Int x) {
    return x * multiplier;
});
Int result = multiply(Int(7));  // 35
```

## Math 工具

### 静态方法
```cpp
Int max = Math::max(Int(10), Int(20));
Int min = Math::min(Int(10), Int(20));
Double sqrt = Math::sqrt(Double(16.0));
Double pow = Math::pow(Double(2.0), Double(3.0));
```

### 常量
```cpp
Double pi = Math::PI;   // 3.14159...
Double e = Math::E;     // 2.71828...
```

## 智能指针

### ObjectPtr<T>
```cpp
ObjectPtr<Dog> dog(new Dog(String("Max"), 5, String("Husky")));
String name = dog->get_name();    // 使用 ->
Dog& ref = *dog;                  // 使用 *
bool null = dog.isNull();         // 检查空
Dog* ptr = dog.get();             // 获取原始指针
// 自动释放内存，无需手动 delete
```

## 常见模式

### 模式1：集合遍历
```cpp
List<String> items;
for (int i = 0; i < items.get_length(); i++) {
    String item = items.get(i);
    // 处理 item
}
```

### 模式2：多态列表
```cpp
List<ObjectPtr<Animal>> animals;
animals.add(ObjectPtr<Animal>(new Dog(...)));
animals.add(ObjectPtr<Animal>(new Cat(...)));

for (int i = 0; i < animals.get_length(); i++) {
    ObjectPtr<Animal> animal = animals.get(i);
    std::cout << animal->makeSound().toString();
}
```

### 模式3：键值对映射
```cpp
Map<String, Int> scores;
scores.set(String("Alice"), Int(95));
scores.set(String("Bob"), Int(87));

if (scores.containsKey(String("Alice"))) {
    Int score = scores.get(String("Alice"));
}
```

### 模式4：可选值处理
```cpp
Optional<String> maybeValue = someFunction();
if (maybeValue.hasValue()) {
    String value = maybeValue.get();
    // 使用 value
} else {
    // 处理无值情况
}
```

### 模式5：错误处理
```cpp
try {
    // 可能失败的操作
    if (invalid) {
        throw ArgumentException(String("Invalid input"));
    }
} catch (const Exception& e) {
    std::cerr << e.toString() << std::endl;
}
```

## 类型转换

### 基础类型转换
```cpp
Int i(42);
double d = i.toDouble();
String s = i.toString();
bool b = i;  // 隐式转换

Double x(3.14);
int num = x.toInt();
String str = x.toString();
```

### 对象类型转换
```cpp
// 向上转型（安全）
Dog* dog = new Dog(...);
Animal* animal = dog;

// 向下转型（需要检查）
Animal* animal = getAnimal();
Dog* dog = dynamic_cast<Dog*>(animal);
if (dog != nullptr) {
    // 使用 dog
}
```

## 编译命令

### 单文件编译
```bash
g++ -std=c++11 -I pkg/dart2bytecode/base \
    pkg/dart2bytecode/base/object.cpp \
    pkg/dart2bytecode/base/object_extended.cpp \
    your_code.cpp -o program
```

### 使用 Makefile
```bash
cd pkg/dart2bytecode/base
make clean
make test-advanced
```

## 常用头文件

```cpp
// 基础类型
#include "object.h"

// 扩展类型
#include "object_extended.h"

// 标准库（如需要）
#include <iostream>
#include <vector>
#include <string>
```

## 调试技巧

### 打印调试
```cpp
std::cout << "Value: " << value.toString() << std::endl;
std::cout << "Size: " << list.get_length() << std::endl;
```

### 断言检查
```cpp
assert(value > Int(0));
assert(!list.get_isEmpty());
```

### 异常调试
```cpp
try {
    // 代码
} catch (const std::exception& e) {
    std::cerr << "Error: " << e.what() << std::endl;
}
```

## 性能提示

1. **使用引用避免拷贝**
```cpp
void process(const String& s) {  // 引用参数
    // 避免拷贝
}
```

2. **预分配容器大小**
```cpp
// 如果知道大小，可以预先分配
// (当前实现使用 std::vector 会自动优化)
```

3. **字符串池自动优化**
```cpp
String s1("same");
String s2("same");
// s1 和 s2 共享同一字符串，比较是 O(1)
bool eq = (s1 == s2);  // 快速
```

4. **智能指针管理**
```cpp
// 使用 ObjectPtr 避免内存泄漏
ObjectPtr<Dog> dog(new Dog(...));
// 自动释放，无需 delete
```

## 完整示例

```cpp
#include "object.h"
#include "object_extended.h"
#include <iostream>

int main() {
    // 创建学生成绩管理系统
    Map<String, List<Int>> studentScores;
    
    // 添加学生成绩
    List<Int> aliceScores;
    aliceScores.add(Int(95));
    aliceScores.add(Int(87));
    aliceScores.add(Int(92));
    studentScores.set(String("Alice"), aliceScores);
    
    // 计算平均分
    List<Int> scores = studentScores.get(String("Alice"));
    Int sum(0);
    for (int i = 0; i < scores.get_length(); i++) {
        sum = sum + scores.get(i);
    }
    Double average(sum.toDouble() / scores.get_length());
    
    std::cout << "Alice's average: " 
              << average.toString() << std::endl;
    
    return 0;
}
```

---

更多详细信息请查看：
- **doc/advanced_features.md** - 完整 API 文档
- **doc/EXTENDED_README.md** - 使用指南
- **doc/扩展总结.md** - 快速概览

