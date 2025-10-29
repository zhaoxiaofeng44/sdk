#include "../pkg/dart2bytecode/base/object.h"
#include "../pkg/dart2bytecode/base/object.cpp"
#include "../pkg/dart2bytecode/base/object_extensions_simple.h"
#include "../pkg/dart2bytecode/base/dart_oop_extensions.h"
#include <iostream>
#include <cassert>

// ============================================================================
// Dart OOP (面向对象) Conversion Test Suite - FIXED VERSION
// 所有自定义类使用 ObjectPtr 包装，符合最佳实践
// ============================================================================

int test_count = 0;
int test_passed = 0;

#define TEST_START(name) \
    std::cout << "\n[TEST] " << name << std::endl; \
    test_count++;

#define TEST_ASSERT(condition, message) \
    if (condition) { \
        std::cout << "  ✓ " << message << std::endl; \
        test_passed++; \
    } else { \
        std::cout << "  ✗ " << message << " FAILED" << std::endl; \
    }

// ============================================================================
// Test 1: 简单类定义和实例化（使用ObjectPtr）
// ============================================================================

// Dart代码:
// class Person {
//   String name;
//   int age;
//   
//   Person(this.name, this.age);
//   
//   String introduce() {
//     return "I'm $name, $age years old";
//   }
// }

class Person : public Object {
public:
    String name;
    Int age;
    
    Person(const String& n, const Int& a) : name(n), age(a) {
        type_id = 100;
    }
    
    String introduce() {
        return String("I'm ") + name + String(", ") + age.toString() + String(" years old");
    }
    
    String toString() const override {
        return String("Person(") + name + String(", ") + age.toString() + String(")");
    }
};

void test_simple_class() {
    TEST_START("Simple Class Definition and Instantiation (with ObjectPtr)");
    
    // Dart: var person = Person("Alice", 25);
    // C++: 使用 ObjectPtr 包装
    ObjectPtr<Person> person(new Person(String("Alice"), Int(25)));
    
    TEST_ASSERT(person->name == "Alice", "Class field access - name");
    TEST_ASSERT(person->age.toInt() == 25, "Class field access - age");
    
    String intro = person->introduce();
    TEST_ASSERT(intro.contains(String("Alice")).toBool(), "Method call returns correct value");
    
    // ObjectPtr 自动管理内存，无需手动 delete
}

// ============================================================================
// Test 2: 类的继承（使用ObjectPtr）
// ============================================================================

class Animal : public Object {
public:
    String name;
    
    Animal(const String& n) : name(n) {
        type_id = 101;
    }
    
    virtual String makeSound() {
        return String("Some sound");
    }
    
    String toString() const override {
        return String("Animal(") + name + String(")");
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
    
    String toString() const override {
        return String("Dog(") + name + String(")");
    }
};

class Cat : public Animal {
public:
    Cat(const String& n) : Animal(n) {
        type_id = 103;
    }
    
    String makeSound() override {
        return String("Meow!");
    }
    
    String toString() const override {
        return String("Cat(") + name + String(")");
    }
};

void test_inheritance() {
    TEST_START("Class Inheritance (with ObjectPtr)");
    
    // Dart: var dog = Dog("Buddy");
    // C++: 使用 ObjectPtr
    ObjectPtr<Dog> dog(new Dog(String("Buddy")));
    
    TEST_ASSERT(dog->name == "Buddy", "Inherited field access");
    TEST_ASSERT(dog->makeSound() == "Woof!", "Overridden method");
    
    // Dart: var cat = Cat("Whiskers");
    ObjectPtr<Cat> cat(new Cat(String("Whiskers")));
    TEST_ASSERT(cat->makeSound() == "Meow!", "Different override in sibling class");
    
    // ObjectPtr 自动管理内存
}

// ============================================================================
// Test 3: 多态性（使用ObjectPtr）
// ============================================================================

void test_polymorphism() {
    TEST_START("Polymorphism (with ObjectPtr)");
    
    // Dart: Animal animal1 = Dog("Rex");
    // C++: 基类指针指向派生类对象
    ObjectPtr<Animal> animal1(new Dog(String("Rex")));
    
    // Dart: Animal animal2 = Cat("Fluffy");
    ObjectPtr<Animal> animal2(new Cat(String("Fluffy")));
    
    // 多态调用
    TEST_ASSERT(animal1->makeSound() == "Woof!", "Polymorphic call - Dog");
    TEST_ASSERT(animal2->makeSound() == "Meow!", "Polymorphic call - Cat");
    
    // 类型检查
    Dog* dog = dynamic_cast<Dog*>(animal1.get());
    TEST_ASSERT(dog != NULL, "Type cast to Dog succeeds");
    
    Cat* cat_from_dog = dynamic_cast<Cat*>(animal1.get());
    TEST_ASSERT(cat_from_dog == NULL, "Type cast to wrong type fails");
    
    // ObjectPtr 自动管理内存
}

// ============================================================================
// Test 4: 抽象类和接口（使用ObjectPtr）
// ============================================================================

DART_INTERFACE(Shape)
    DART_ABSTRACT_METHOD(Double, getArea, ())
    DART_ABSTRACT_METHOD(Double, getPerimeter, ())
DART_INTERFACE_END

class Rectangle : public Object, public virtual Shape {
private:
    Double width_;
    Double height_;
    
public:
    Rectangle(const Double& w, const Double& h) : width_(w), height_(h) {
        type_id = 110;
    }
    
    String getInterfaceType() const override {
        return String("Shape");
    }
    
    Double getArea() override {
        return width_ * height_;
    }
    
    Double getPerimeter() override {
        return (width_ + height_) * Double(2.0);
    }
    
    String toString() const override {
        return String("Rectangle(") + width_.toString() + String("x") + height_.toString() + String(")");
    }
};

class Circle : public Object, public virtual Shape {
private:
    Double radius_;
    static constexpr double PI = 3.14159;
    
public:
    Circle(const Double& r) : radius_(r) {
        type_id = 111;
    }
    
    String getInterfaceType() const override {
        return String("Shape");
    }
    
    Double getArea() override {
        return radius_ * radius_ * Double(PI);
    }
    
    Double getPerimeter() override {
        return radius_ * Double(2.0 * PI);
    }
    
    String toString() const override {
        return String("Circle(r=") + radius_.toString() + String(")");
    }
};

void test_abstract_class_interface() {
    TEST_START("Abstract Class and Interface (with ObjectPtr)");
    
    // Dart: Shape rect = Rectangle(5.0, 3.0);
    // C++: 使用 ObjectPtr<Shape> 接口指针
    ObjectPtr<Rectangle> rectObj(new Rectangle(Double(5.0), Double(3.0)));
    Shape* rect = rectObj.get();
    
    Double area = rect->getArea();
    TEST_ASSERT(area.toDouble() == 15.0, "Interface method call - Rectangle area");
    
    Double perimeter = rect->getPerimeter();
    TEST_ASSERT(perimeter.toDouble() == 16.0, "Interface method call - Rectangle perimeter");
    
    // Dart: Shape circle = Circle(2.0);
    ObjectPtr<Circle> circleObj(new Circle(Double(2.0)));
    Shape* circle = circleObj.get();
    
    Double circleArea = circle->getArea();
    TEST_ASSERT(circleArea.toDouble() > 12.5 && circleArea.toDouble() < 12.6, "Circle area");
    
    // 类型检查
    Rectangle* rect_ptr = dynamic_cast<Rectangle*>(rect);
    TEST_ASSERT(rect_ptr != NULL, "Interface type checking");
    
    // ObjectPtr 自动管理内存
}

// ============================================================================
// Test 5: Getter和Setter（使用ObjectPtr）
// ============================================================================

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
    
    // Computed getter
    Double get_fahrenheit() const {
        return celsius_ * Double(9.0) / Double(5.0) + Double(32.0);
    }
    
    // Computed setter
    void set_fahrenheit(const Double& value) {
        celsius_ = (value - Double(32.0)) * Double(5.0) / Double(9.0);
    }
    
    String toString() const override {
        return celsius_.toString() + String("°C");
    }
};

void test_getter_setter() {
    TEST_START("Getter and Setter (with ObjectPtr)");
    
    // Dart: var temp = Temperature(0.0);
    // C++: 使用 ObjectPtr
    ObjectPtr<Temperature> temp(new Temperature(Double(0.0)));
    
    // Getter
    TEST_ASSERT(temp->get_celsius().toDouble() == 0.0, "Getter - celsius");
    
    Double fahrenheit = temp->get_fahrenheit();
    TEST_ASSERT(fahrenheit.toDouble() == 32.0, "Computed getter - fahrenheit from 0°C");
    
    // Setter
    temp->set_celsius(Double(100.0));
    TEST_ASSERT(temp->get_celsius().toDouble() == 100.0, "Setter - celsius");
    TEST_ASSERT(temp->get_fahrenheit().toDouble() == 212.0, "Computed value after setter");
    
    // Computed setter
    temp->set_fahrenheit(Double(32.0));
    TEST_ASSERT(temp->get_celsius().toDouble() == 0.0, "Computed setter - fahrenheit to celsius");
    
    // ObjectPtr 自动管理内存
}

// ============================================================================
// Test 6: 静态成员和方法
// ============================================================================

class MathUtils {
public:
    static const double PI;
    
    static Int add(const Int& a, const Int& b) {
        return a + b;
    }
    
    static Int multiply(const Int& a, const Int& b) {
        return a * b;
    }
};

const double MathUtils::PI = 3.14159;

void test_static_members() {
    TEST_START("Static Members and Methods");
    
    // Dart: var pi = MathUtils.PI;
    double pi = MathUtils::PI;
    TEST_ASSERT(pi > 3.14 && pi < 3.15, "Static constant");
    
    // Dart: var sum = MathUtils.add(5, 3);
    Int sum = MathUtils::add(Int(5), Int(3));
    TEST_ASSERT(sum.toInt() == 8, "Static method");
    
    Int product = MathUtils::multiply(Int(4), Int(7));
    TEST_ASSERT(product.toInt() == 28, "Another static method");
}

// ============================================================================
// Test 7: 命名构造函数（使用ObjectPtr）
// ============================================================================

class Point : public Object {
public:
    Double x;
    Double y;
    
    Point(const Double& x_val, const Double& y_val) : x(x_val), y(y_val) {
        type_id = 107;
    }
    
    // 命名构造函数：origin
    static ObjectPtr<Point> origin() {
        return ObjectPtr<Point>(new Point(Double(0.0), Double(0.0)));
    }
    
    // 命名构造函数：fromCoordinates
    static ObjectPtr<Point> fromCoordinates(const Double& x_val, const Double& y_val) {
        return ObjectPtr<Point>(new Point(x_val, y_val));
    }
    
    Double distance() const {
        return Double(std::sqrt(x.toDouble() * x.toDouble() + y.toDouble() * y.toDouble()));
    }
    
    String toString() const override {
        return String("Point(") + x.toString() + String(", ") + y.toString() + String(")");
    }
};

void test_named_constructors() {
    TEST_START("Named Constructors (Factory Methods with ObjectPtr)");
    
    // Dart: var p1 = Point(3.0, 4.0);
    // C++: 使用 ObjectPtr
    ObjectPtr<Point> p1(new Point(Double(3.0), Double(4.0)));
    TEST_ASSERT(p1->x.toDouble() == 3.0 && p1->y.toDouble() == 4.0, "Regular constructor");
    
    // Dart: var p2 = Point.origin();
    // C++: 工厂方法返回 ObjectPtr
    ObjectPtr<Point> p2 = Point::origin();
    TEST_ASSERT(p2->x.toDouble() == 0.0 && p2->y.toDouble() == 0.0, "Named constructor - origin");
    
    // Dart: var p3 = Point.fromCoordinates(5.0, 12.0);
    ObjectPtr<Point> p3 = Point::fromCoordinates(Double(5.0), Double(12.0));
    Double dist = p3->distance();
    TEST_ASSERT(dist.toDouble() == 13.0, "Named constructor with calculation");
    
    // ObjectPtr 自动管理内存
}

// ============================================================================
// Test 8: 操作符重载（值类型，不需要ObjectPtr）
// ============================================================================

class Vector : public Object {
public:
    Double x;
    Double y;
    
    Vector(const Double& x_val, const Double& y_val) : x(x_val), y(y_val) {
        type_id = 108;
    }
    
    Vector operator+(const Vector& other) const {
        return Vector(x + other.x, y + other.y);
    }
    
    Vector operator*(const Double& scalar) const {
        return Vector(x * scalar, y * scalar);
    }
    
    bool operator==(const Vector& other) const {
        return (x == other.x).toBool() && (y == other.y).toBool();
    }
    
    String toString() const override {
        return String("Vector(") + x.toString() + String(", ") + y.toString() + String(")");
    }
};

void test_operator_overloading() {
    TEST_START("Operator Overloading in Classes");
    
    // 注意：Vector 作为值类型使用，不需要 ObjectPtr
    // Dart: var v1 = Vector(1.0, 2.0);
    Vector v1(Double(1.0), Double(2.0));
    
    // Dart: var v2 = Vector(3.0, 4.0);
    Vector v2(Double(3.0), Double(4.0));
    
    // Dart: var v3 = v1 + v2;
    Vector v3 = v1 + v2;
    TEST_ASSERT(v3.x.toDouble() == 4.0 && v3.y.toDouble() == 6.0, "Vector addition");
    
    // Dart: var v4 = v1 * 2.0;
    Vector v4 = v1 * Double(2.0);
    TEST_ASSERT(v4.x.toDouble() == 2.0 && v4.y.toDouble() == 4.0, "Vector scalar multiplication");
    
    // Dart: v1 == Vector(1.0, 2.0)
    Vector v5(Double(1.0), Double(2.0));
    TEST_ASSERT(v1 == v5, "Vector equality");
}

// ============================================================================
// Test 9: 方法链（使用ObjectPtr）
// ============================================================================

class StringBuilder : public Object {
private:
    String buffer_;
    
public:
    StringBuilder() : buffer_("") {
        type_id = 109;
    }
    
    StringBuilder* append(const String& text) {
        buffer_ = buffer_ + text;
        return this;
    }
    
    StringBuilder* appendLine(const String& text) {
        buffer_ = buffer_ + text + String("\n");
        return this;
    }
    
    String build() const {
        return buffer_;
    }
    
    String toString() const override {
        return buffer_;
    }
};

void test_cascade_method_chaining() {
    TEST_START("Cascade Operator (Method Chaining with ObjectPtr)");
    
    // Dart: var sb = StringBuilder()..append("Hello")..append(" ")..append("World");
    // C++: 使用 ObjectPtr
    ObjectPtr<StringBuilder> sb(new StringBuilder());
    sb->append(String("Hello"))
      ->append(String(" "))
      ->append(String("World"));
    
    String result = sb->build();
    TEST_ASSERT(result == "Hello World", "Method chaining");
    
    // 另一个链式调用示例
    ObjectPtr<StringBuilder> sb2(new StringBuilder());
    sb2->appendLine(String("Line 1"))
       ->appendLine(String("Line 2"))
       ->append(String("Line 3"));
    
    String result2 = sb2->build();
    TEST_ASSERT(result2.contains(String("Line 1")).toBool(), "Chained method contains line 1");
    TEST_ASSERT(result2.contains(String("Line 2")).toBool(), "Chained method contains line 2");
    
    // ObjectPtr 自动管理内存
}

// ============================================================================
// Test 10: 引用计数验证
// ============================================================================

void test_reference_counting() {
    TEST_START("Reference Counting with ObjectPtr");
    
    ObjectPtr<Person> person1(new Person(String("Bob"), Int(30)));
    int initial_count = person1.get()->getRefCount();
    TEST_ASSERT(initial_count >= 1, "Initial ref count");
    
    // 拷贝 ObjectPtr
    ObjectPtr<Person> person2 = person1;
    int after_copy = person1.get()->getRefCount();
    TEST_ASSERT(after_copy == initial_count + 1, "Ref count after copy");
    
    {
        // 在作用域内再次拷贝
        ObjectPtr<Person> person3 = person1;
        int in_scope = person1.get()->getRefCount();
        TEST_ASSERT(in_scope == initial_count + 2, "Ref count in nested scope");
    }
    // person3 离开作用域，引用计数应该减1
    
    int after_scope = person1.get()->getRefCount();
    TEST_ASSERT(after_scope == initial_count + 1, "Ref count after scope exit");
    
    // ObjectPtr 自动管理内存
}

// ============================================================================
// Test 11: 多态与ObjectPtr结合
// ============================================================================

void test_polymorphism_with_objectptr() {
    TEST_START("Polymorphism with ObjectPtr Collection");
    
    // Dart: List<Animal> animals = [Dog("Rex"), Cat("Whiskers"), Dog("Buddy")];
    // C++: 使用 ObjectPtr<Animal> 存储多态对象
    ObjectPtr<List<ObjectPtr<Animal>>> animals = List<ObjectPtr<Animal>>::create();
    
    animals->add(ObjectPtr<Animal>(new Dog(String("Rex"))));
    animals->add(ObjectPtr<Animal>(new Cat(String("Whiskers"))));
    animals->add(ObjectPtr<Animal>(new Dog(String("Buddy"))));
    
    TEST_ASSERT(animals->size().toInt() == 3, "Polymorphic collection size");
    
    // 多态调用
    ObjectPtr<Animal> first = animals->get(Int(0));
    TEST_ASSERT(first->makeSound() == "Woof!", "First animal sound");
    
    ObjectPtr<Animal> second = animals->get(Int(1));
    TEST_ASSERT(second->makeSound() == "Meow!", "Second animal sound");
    
    // 类型检查
    Dog* dog = dynamic_cast<Dog*>(first.get());
    TEST_ASSERT(dog != NULL, "Type check in collection");
    
    // ObjectPtr 自动管理所有对象内存
}

// ============================================================================
// Main测试入口
// ============================================================================

int main() {
    std::cout << "========================================" << std::endl;
    std::cout << "Dart OOP Conversion Test Suite (FIXED)" << std::endl;
    std::cout << "使用 ObjectPtr 包装所有自定义类" << std::endl;
    std::cout << "========================================" << std::endl;
    
    test_simple_class();
    test_inheritance();
    test_polymorphism();
    test_abstract_class_interface();
    test_getter_setter();
    test_static_members();
    test_named_constructors();
    test_operator_overloading();
    test_cascade_method_chaining();
    test_reference_counting();
    test_polymorphism_with_objectptr();
    
    std::cout << "\n========================================" << std::endl;
    std::cout << "Test Results: " << test_passed << "/" << test_count << " passed" << std::endl;
    std::cout << "========================================" << std::endl;
    
    if (test_passed == test_count) {
        std::cout << "\n✅ All tests passed! ObjectPtr usage is correct." << std::endl;
    }
    
    return (test_passed == test_count) ? 0 : 1;
}

