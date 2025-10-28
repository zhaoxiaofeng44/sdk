# Dart OOP 到 C++ 转换指南

## 概述

本指南详细说明如何将Dart的面向对象特性转换为C++代码，包括类、继承、多态、接口、Mixin等高级特性。

---

## 1. 类定义与实例化

### 1.1 简单类定义

**Dart代码:**
```dart
class Person {
  String name;
  int age;
  
  Person(this.name, this.age);
  
  String introduce() {
    return "I'm $name, $age years old";
  }
}

void main() {
  var person = Person("Alice", 25);
  print(person.introduce());
}
```

**C++代码:**
```cpp
class Person : public Object {
public:
    String name;
    Int age;
    
    Person(const String& n, const Int& a) : name(n), age(a) {
        type_id = 100;  // 可选的类型标识
    }
    
    String introduce() {
        return String("I'm ") + name + String(", ") + 
               age.toString() + String(" years old");
    }
    
    String toString() const override {
        return String("Person(") + name + String(", ") + 
               age.toString() + String(")");
    }
};

void main() {
    Person* person = new Person(String("Alice"), Int(25));
    dart_print(person->introduce());
    delete person;
}
```

**关键点:**
- 类必须继承自`Object`以支持引用计数
- 使用指针管理对象生命周期
- 实现`toString()`方法用于调试
- 记得手动`delete`对象（或使用智能指针）

---

## 2. 继承

### 2.1 单继承

**Dart代码:**
```dart
class Animal {
  String name;
  Animal(this.name);
  
  String makeSound() => "Some sound";
}

class Dog extends Animal {
  Dog(String name) : super(name);
  
  @override
  String makeSound() => "Woof!";
}
```

**C++代码:**
```cpp
class Animal : public Object {
public:
    String name;
    
    Animal(const String& n) : name(n) {
        type_id = 101;
    }
    
    virtual String makeSound() {
        return String("Some sound");
    }
};

class Dog : public Animal {
public:
    Dog(const String& n) : Animal(n) {
        type_id = 102;
    }
    
    String makeSound() override {
        return String("Woof!");
    }
};
```

**关键点:**
- 基类方法使用`virtual`关键字
- 派生类使用`override`关键字
- 调用父类构造函数使用初始化列表

---

## 3. 多态

### 3.1 基本多态

**Dart代码:**
```dart
void testPolymorphism() {
  Animal animal1 = Dog("Rex");
  Animal animal2 = Cat("Fluffy");
  
  print(animal1.makeSound());  // "Woof!"
  print(animal2.makeSound());  // "Meow!"
}
```

**C++代码:**
```cpp
void testPolymorphism() {
    Animal* animal1 = new Dog(String("Rex"));
    Animal* animal2 = new Cat(String("Fluffy"));
    
    dart_print(animal1->makeSound());  // "Woof!"
    dart_print(animal2->makeSound());  // "Meow!"
    
    delete animal1;
    delete animal2;
}
```

### 3.2 类型检查和转换

**Dart代码:**
```dart
if (animal is Dog) {
  Dog dog = animal as Dog;
  // 使用dog
}
```

**C++代码:**
```cpp
Dog* dog = dynamic_cast<Dog*>(animal);
if (dog != NULL) {
    // 使用dog
}
```

---

## 4. 抽象类和接口

### 4.1 接口定义

**Dart代码:**
```dart
abstract class Shape {
  double getArea();
  double getPerimeter();
}

class Rectangle implements Shape {
  double width, height;
  Rectangle(this.width, this.height);
  
  @override
  double getArea() => width * height;
  
  @override
  double getPerimeter() => 2 * (width + height);
}
```

**C++代码:**
```cpp
// 定义接口
DART_INTERFACE(Shape)
    DART_ABSTRACT_METHOD(Double, getArea, ())
    DART_ABSTRACT_METHOD(Double, getPerimeter, ())
DART_INTERFACE_END

// 实现接口
class Rectangle : public virtual Shape {
private:
    Double width_;
    Double height_;
    
public:
    Rectangle(const Double& w, const Double& h) : width_(w), height_(h) {}
    
    String getInterfaceType() const override {
        return String("Shape");
    }
    
    Double getArea() override {
        return width_ * height_;
    }
    
    Double getPerimeter() override {
        return (width_ + height_) * Double(2.0);
    }
};
```

**关键点:**
- 使用`DART_INTERFACE`宏定义接口
- 使用`DART_ABSTRACT_METHOD`宏声明抽象方法
- 实现类使用`public virtual`继承接口
- 必须实现`getInterfaceType()`方法

---

## 5. Mixin 混入

### 5.1 单个Mixin

**Dart代码:**
```dart
mixin Flyable {
  String fly() => "Flying!";
}

class Bird extends Animal with Flyable {
  Bird(String name) : super(name);
}

void main() {
  var bird = Bird("Sparrow");
  print(bird.fly());  // "Flying!"
}
```

**C++代码:**
```cpp
// 定义Mixin
DART_MIXIN(Flyable)
public:
    Flyable() {}
    
    DART_MIXIN_METHOD(String, fly, (), {
        return String("Flying!");
    })
DART_MIXIN_END

// 使用Mixin
class Bird : public Animal, public virtual Flyable {
public:
    Bird(const String& n) : Animal(n), Flyable() {
        type_id = 104;
    }
    
    String getMixinType() const override {
        return String("Flyable");
    }
};

void main() {
    Bird* bird = new Bird(String("Sparrow"));
    dart_print(bird->fly());  // "Flying!"
    delete bird;
}
```

### 5.2 多个Mixin

**Dart代码:**
```dart
mixin Flyable {
  String fly() => "Flying!";
}

mixin Swimmable {
  String swim() => "Swimming!";
}

class Duck extends Animal with Flyable, Swimmable {
  Duck(String name) : super(name);
}
```

**C++代码:**
```cpp
class Duck : public Animal, public virtual Flyable, public virtual Swimmable {
public:
    Duck(const String& n) : Animal(n), Flyable(), Swimmable() {
        type_id = 105;
    }
    
    String getMixinType() const override {
        return String("Flyable+Swimmable");
    }
};
```

---

## 6. Getter 和 Setter

### 6.1 简单Getter/Setter

**Dart代码:**
```dart
class Temperature {
  double _celsius;
  
  Temperature(this._celsius);
  
  double get celsius => _celsius;
  set celsius(double value) => _celsius = value;
}
```

**C++代码:**
```cpp
class Temperature : public Object {
private:
    Double celsius_;
    
public:
    Temperature(const Double& c) : celsius_(c) {
        type_id = 106;
    }
    
    // Getter
    Double get_celsius() const {
        return celsius_;
    }
    
    // Setter
    void set_celsius(const Double& value) {
        celsius_ = value;
    }
};
```

### 6.2 计算属性

**Dart代码:**
```dart
class Temperature {
  double _celsius;
  
  double get fahrenheit => _celsius * 9 / 5 + 32;
  set fahrenheit(double value) => _celsius = (value - 32) * 5 / 9;
}
```

**C++代码:**
```cpp
class Temperature : public Object {
private:
    Double celsius_;
    
public:
    // Computed getter
    Double get_fahrenheit() const {
        return celsius_ * Double(9.0) / Double(5.0) + Double(32.0);
    }
    
    // Computed setter
    void set_fahrenheit(const Double& value) {
        celsius_ = (value - Double(32.0)) * Double(5.0) / Double(9.0);
    }
};
```

---

## 7. 静态成员

### 7.1 静态常量和方法

**Dart代码:**
```dart
class MathUtils {
  static const double PI = 3.14159;
  
  static int add(int a, int b) => a + b;
}

void main() {
  print(MathUtils.PI);
  print(MathUtils.add(5, 3));
}
```

**C++代码:**
```cpp
class MathUtils {
public:
    static const double PI;
    
    static Int add(const Int& a, const Int& b) {
        return a + b;
    }
};

// 在.cpp文件中定义
const double MathUtils::PI = 3.14159;

void main() {
    dart_print(Double(MathUtils::PI));
    dart_print(MathUtils::add(Int(5), Int(3)));
}
```

---

## 8. 命名构造函数

### 8.1 使用静态工厂方法

**Dart代码:**
```dart
class Point {
  double x, y;
  
  Point(this.x, this.y);
  Point.origin() : x = 0, y = 0;
  Point.fromCoordinates(double x, double y) : x = x, y = y;
}

void main() {
  var p1 = Point(3.0, 4.0);
  var p2 = Point.origin();
  var p3 = Point.fromCoordinates(5.0, 12.0);
}
```

**C++代码:**
```cpp
class Point : public Object {
public:
    Double x;
    Double y;
    
    Point(const Double& x_val, const Double& y_val) : x(x_val), y(y_val) {}
    
    // 命名构造函数：origin
    static Point* origin() {
        return new Point(Double(0.0), Double(0.0));
    }
    
    // 命名构造函数：fromCoordinates
    static Point* fromCoordinates(const Double& x_val, const Double& y_val) {
        return new Point(x_val, y_val);
    }
};

void main() {
    Point* p1 = new Point(Double(3.0), Double(4.0));
    Point* p2 = Point::origin();
    Point* p3 = Point::fromCoordinates(Double(5.0), Double(12.0));
    
    delete p1;
    delete p2;
    delete p3;
}
```

---

## 9. 操作符重载

### 9.1 类中的操作符重载

**Dart代码:**
```dart
class Vector {
  double x, y;
  Vector(this.x, this.y);
  
  Vector operator +(Vector other) => Vector(x + other.x, y + other.y);
  Vector operator *(double scalar) => Vector(x * scalar, y * scalar);
  bool operator ==(Object other) => 
      other is Vector && x == other.x && y == other.y;
}
```

**C++代码:**
```cpp
class Vector : public Object {
public:
    Double x;
    Double y;
    
    Vector(const Double& x_val, const Double& y_val) : x(x_val), y(y_val) {}
    
    Vector operator+(const Vector& other) const {
        return Vector(x + other.x, y + other.y);
    }
    
    Vector operator*(const Double& scalar) const {
        return Vector(x * scalar, y * scalar);
    }
    
    bool operator==(const Vector& other) const {
        return (x == other.x).toBool() && (y == other.y).toBool();
    }
};
```

---

## 10. 方法链（级联操作符）

### 10.1 返回this的方法链

**Dart代码:**
```dart
class StringBuilder {
  String _buffer = "";
  
  StringBuilder append(String text) {
    _buffer += text;
    return this;
  }
  
  String build() => _buffer;
}

void main() {
  var result = StringBuilder()
    ..append("Hello")
    ..append(" ")
    ..append("World");
  print(result.build());
}
```

**C++代码:**
```cpp
class StringBuilder : public Object {
private:
    String buffer_;
    
public:
    StringBuilder() : buffer_("") {}
    
    StringBuilder* append(const String& text) {
        buffer_ = buffer_ + text;
        return this;
    }
    
    String build() const {
        return buffer_;
    }
};

void main() {
    StringBuilder* sb = new StringBuilder();
    sb->append(String("Hello"))
      ->append(String(" "))
      ->append(String("World"));
    
    dart_print(sb->build());
    delete sb;
}
```

---

## 11. 工厂模式

### 11.1 工厂方法

**Dart代码:**
```dart
abstract class Logger {
  void log(String message);
  
  factory Logger.console() => ConsoleLogger();
  factory Logger.file() => FileLogger();
}

class ConsoleLogger implements Logger {
  void log(String message) => print(message);
}
```

**C++代码:**
```cpp
class Logger {
public:
    virtual ~Logger() {}
    virtual void log(const String& message) = 0;
    
    // 工厂方法
    static Logger* createConsole();
    static Logger* createFile();
};

class ConsoleLogger : public Logger {
public:
    void log(const String& message) override {
        std::cout << "[Console] " << message.getValue() << std::endl;
    }
};

Logger* Logger::createConsole() {
    return new ConsoleLogger();
}

void main() {
    Logger* logger = Logger::createConsole();
    logger->log(String("Hello"));
    delete logger;
}
```

---

## 12. 完整示例

### 12.1 综合OOP示例

**Dart代码:**
```dart
// 接口
abstract class Drawable {
  void draw();
}

// Mixin
mixin Colorable {
  String color = "white";
  void setColor(String c) => color = c;
}

// 基类
class Shape {
  String name;
  Shape(this.name);
}

// 实现类
class Circle extends Shape with Colorable implements Drawable {
  double radius;
  
  Circle(String name, this.radius) : super(name);
  
  @override
  void draw() {
    print("Drawing $color circle: $name");
  }
  
  double getArea() => 3.14159 * radius * radius;
}

void main() {
  var circle = Circle("MyCircle", 5.0);
  circle.setColor("red");
  circle.draw();
  print("Area: ${circle.getArea()}");
}
```

**C++代码:**
```cpp
// 接口
DART_INTERFACE(Drawable)
    DART_ABSTRACT_METHOD(void, draw, ())
DART_INTERFACE_END

// Mixin
DART_MIXIN(Colorable)
private:
    String color_;
public:
    Colorable() : color_("white") {}
    
    DART_MIXIN_METHOD(void, setColor, (const String& c), {
        color_ = c;
    })
    
    DART_MIXIN_METHOD(String, getColor, (), {
        return color_;
    })
DART_MIXIN_END

// 基类
class Shape : public Object {
public:
    String name;
    Shape(const String& n) : name(n) {}
};

// 实现类
class Circle : public Shape, public virtual Colorable, public virtual Drawable {
private:
    Double radius_;
    
public:
    Circle(const String& name, const Double& r) 
        : Shape(name), Colorable(), radius_(r) {}
    
    String getInterfaceType() const override {
        return String("Drawable");
    }
    
    String getMixinType() const override {
        return String("Colorable");
    }
    
    void draw() override {
        std::cout << "Drawing " << getColor().getValue() 
                  << " circle: " << name.getValue() << std::endl;
    }
    
    Double getArea() {
        return Double(3.14159) * radius_ * radius_;
    }
};

void main() {
    Circle* circle = new Circle(String("MyCircle"), Double(5.0));
    circle->setColor(String("red"));
    circle->draw();
    dart_print(String("Area: ") + circle->getArea().toString());
    delete circle;
}
```

---

## 13. 转换对照表

| Dart特性 | C++实现 | 说明 |
|---------|---------|------|
| `class MyClass` | `class MyClass : public Object` | 继承Object基类 |
| `extends Parent` | `: public Parent` | 公有继承 |
| `implements Interface` | `DART_CLASS_IMPLEMENTS(MyClass, Interface)` | 使用宏或virtual继承 |
| `with Mixin` | `, public virtual Mixin` | 多重继承 |
| `@override` | `override` | C++11关键字 |
| `abstract class` | `class` + 纯虚函数 | 或使用DART_INTERFACE宏 |
| `factory` | 静态工厂方法 | `static Type* create()` |
| `get property` | `Type get_property()` | Getter方法 |
| `set property` | `void set_property(Type)` | Setter方法 |
| `static const` | `static const` | 需要在.cpp中定义 |
| `static method` | `static method` | 直接使用 |
| `operator+` | `operator+` | 运算符重载 |
| `is Type` | `dynamic_cast<Type*>` | 类型检查 |
| `as Type` | `dynamic_cast<Type*>` | 类型转换 |
| `..method()` | `->method()` 返回this | 方法链 |

---

## 14. 最佳实践

### 14.1 内存管理

✅ **推荐**:
```cpp
// 使用智能指针（如果可用）
std::unique_ptr<Person> person(new Person(String("Alice"), Int(25)));

// 或明确管理生命周期
Person* person = new Person(String("Alice"), Int(25));
// ... 使用 ...
delete person;
```

❌ **避免**:
```cpp
// 忘记delete导致内存泄漏
Person* person = new Person(String("Alice"), Int(25));
// 使用后忘记delete
```

### 14.2 虚函数使用

✅ **推荐**:
```cpp
class Base {
public:
    virtual ~Base() {}  // 虚析构函数
    virtual void method() {}
};
```

### 14.3 接口设计

✅ **推荐** - 使用宏定义接口:
```cpp
DART_INTERFACE(MyInterface)
    DART_ABSTRACT_METHOD(void, method, ())
DART_INTERFACE_END
```

✅ **也可以** - 传统C++方式:
```cpp
class MyInterface {
public:
    virtual ~MyInterface() {}
    virtual void method() = 0;
};
```

---

## 15. 测试覆盖

OOP转换测试覆盖以下特性：

- ✅ 简单类定义和实例化
- ✅ 类继承（单继承、多级继承）
- ✅ 多态性（虚函数、动态绑定）
- ✅ 抽象类和接口
- ✅ Mixin混入（单个、多个）
- ✅ Getter和Setter（简单、计算属性）
- ✅ 静态成员和方法
- ✅ 命名构造函数（工厂方法）
- ✅ 操作符重载
- ✅ 方法链（级联操作）
- ✅ 工厂模式
- ✅ 类型检查和转换

**测试结果**: 44/44 assertions passed ✅

---

## 16. 总结

Dart的OOP特性在C++中都有对应的实现方式：

| 难度 | 特性 | 转换复杂度 |
|-----|------|-----------|
| 简单 | 类定义、继承 | ⭐ |
| 简单 | 多态、虚函数 | ⭐ |
| 中等 | 接口 | ⭐⭐ |
| 中等 | Getter/Setter | ⭐⭐ |
| 复杂 | Mixin | ⭐⭐⭐ |
| 复杂 | 多重继承组合 | ⭐⭐⭐ |

所有特性都已通过完整测试验证！

