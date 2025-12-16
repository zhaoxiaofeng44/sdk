// ============================================================================
// C++ 面向对象编程测试用例
// 测试类继承、多态、封装等OOP特性
// 注意：使用联合体 ValueUnion 访问 .value.object_ptr 等
// 所有自定义类都继承自 Object 类，应该使用 ObjectPtr 包装
// ============================================================================

#include "../core/dart2cpp.h"
#include <iostream>
#include <cassert>
#include <memory>

// 简单的测试框架
#define TEST(name) \
    void test_##name(); \
    void test_##name()

#define ASSERT_EQ(expected, actual) \
    do { \
        if ((expected) != (actual)) { \
            std::cerr << "ASSERTION FAILED: " << #expected << " != " << #actual \
                      << " (expected: " << (expected) << ", actual: " << (actual) << ")" \
                      << " at " << __FILE__ << ":" << __LINE__ << std::endl; \
            std::abort(); \
        } \
    } while(0)

#define ASSERT_TRUE(condition) \
    do { \
        if (!(condition)) { \
            std::cerr << "ASSERTION FAILED: " << #condition << " is false" \
                      << " at " << __FILE__ << ":" << __LINE__ << std::endl; \
            std::abort(); \
        } \
    } while(0)

#define ASSERT_FALSE(condition) \
    do { \
        if (condition) { \
            std::cerr << "ASSERTION FAILED: " << #condition << " is true" \
                      << " at " << __FILE__ << ":" << __LINE__ << std::endl; \
            std::abort(); \
        } \
    } while(0)

#define ASSERT_NEAR(expected, actual, tolerance) \
    do { \
        if (std::abs((expected) - (actual)) > (tolerance)) { \
            std::cerr << "ASSERTION FAILED: " << #expected << " != " << #actual \
                      << " (expected: " << (expected) << ", actual: " << (actual) \
                      << ", tolerance: " << (tolerance) << ")" \
                      << " at " << __FILE__ << ":" << __LINE__ << std::endl; \
            std::abort(); \
        } \
    } while(0)

#define RUN_TEST(name) \
    do { \
        std::cout << "Running test_" << #name << "..." << std::endl; \
        test_##name(); \
        std::cout << "✓ test_" << #name << " passed" << std::endl; \
    } while(0)

// ============================================================================
// 基础类定义 - 几何图形类层次结构
// ============================================================================

// 抽象基类：Shape
class Shape : public Object {
protected:
    String name_;
    
public:
    Shape(const String& name) : name_(name) {
        type_id = 5;  // Object 类型ID为5
    }
    
    virtual ~Shape() {}
    
    // 纯虚函数
    virtual Double area() const = 0;
    virtual Double perimeter() const = 0;
    
    // 虚函数
    virtual String toString() const override {
        return String("Shape: ") + name_;
    }
    
    // 普通方法
    String getName() const {
        return name_;
    }
    
    void setName(const String& name) {
        name_ = name;
    }
    
    // 静态工厂方法
    template<typename T, typename... Args>
    static ObjectPtr<T> create(Args&&... args) {
        return ObjectPtr<T>(new T(std::forward<Args>(args)...));
    }
};

// 具体类：Rectangle
class Rectangle : public Shape {
private:
    Double width_;
    Double height_;
    
public:
    Rectangle(const String& name, const Double& width, const Double& height)
        : Shape(name), width_(width), height_(height) {}
    
    Double area() const override {
        Double result(width_.value.double_value * height_.value.double_value);
        return result;
    }
    
    Double perimeter() const override {
        Double result(2.0 * (width_.value.double_value + height_.value.double_value));
        return result;
    }
    
    String toString() const override {
        return String("Rectangle: ") + getName() + 
               String(" (") + width_.toString() + String("x") + height_.toString() + String(")");
    }
    
    // 访问器方法
    Double getWidth() const { return width_; }
    Double getHeight() const { return height_; }
    
    void setWidth(const Double& width) { width_ = width; }
    void setHeight(const Double& height) { height_ = height; }
    
    // 特有方法
    Bool isSquare() const {
        return Bool(width_.value.double_value == height_.value.double_value);
    }
};

// 具体类：Circle
class Circle : public Shape {
private:
    Double radius_;
    
public:
    Circle(const String& name, const Double& radius)
        : Shape(name), radius_(radius) {}
    
    Double area() const override {
        const double PI = 3.14159265359;
        Double result(PI * radius_.value.double_value * radius_.value.double_value);
        return result;
    }
    
    Double perimeter() const override {
        const double PI = 3.14159265359;
        Double result(2.0 * PI * radius_.value.double_value);
        return result;
    }
    
    String toString() const override {
        return String("Circle: ") + getName() + 
               String(" (radius=") + radius_.toString() + String(")");
    }
    
    // 访问器方法
    Double getRadius() const { return radius_; }
    void setRadius(const Double& radius) { radius_ = radius; }
    
    // 特有方法
    Double getDiameter() const {
        Double result(2.0 * radius_.value.double_value);
        return result;
    }
};

// 具体类：Triangle
class Triangle : public Shape {
private:
    Double side1_;
    Double side2_;
    Double side3_;
    
public:
    Triangle(const String& name, const Double& side1, const Double& side2, const Double& side3)
        : Shape(name), side1_(side1), side2_(side2), side3_(side3) {}
    
    Double area() const override {
        // 使用海伦公式计算面积
        double s = (side1_.value.double_value + side2_.value.double_value + side3_.value.double_value) / 2.0;
        double area_squared = s * (s - side1_.value.double_value) * (s - side2_.value.double_value) * (s - side3_.value.double_value);
        Double result(std::sqrt(area_squared));
        return result;
    }
    
    Double perimeter() const override {
        Double result(side1_.value.double_value + side2_.value.double_value + side3_.value.double_value);
        return result;
    }
    
    String toString() const override {
        return String("Triangle: ") + getName() + 
               String(" (") + side1_.toString() + String(",") + 
               side2_.toString() + String(",") + side3_.toString() + String(")");
    }
    
    // 访问器方法
    Double getSide1() const { return side1_; }
    Double getSide2() const { return side2_; }
    Double getSide3() const { return side3_; }
    
    // 特有方法
    Bool isEquilateral() const {
        return Bool(side1_.value.double_value == side2_.value.double_value && 
                   side2_.value.double_value == side3_.value.double_value);
    }
    
    Bool isIsosceles() const {
        return Bool(side1_.value.double_value == side2_.value.double_value ||
                   side2_.value.double_value == side3_.value.double_value ||
                   side1_.value.double_value == side3_.value.double_value);
    }
};

// ============================================================================
// 基础OOP测试
// ============================================================================

TEST(basic_object_creation) {
    // 创建 Rectangle 对象
    ObjectPtr<Rectangle> rect = Shape::create<Rectangle>(
        String("MyRect"), Double(5.0), Double(3.0)
    );
    
    // 验证 ObjectPtr 不为null
    ASSERT_TRUE(rect.get() != nullptr);
    
    // 验证对象属性
    String name = rect->getName();
    ASSERT_EQ("MyRect", name.getValue());
    
    Double width = rect->getWidth();
    ASSERT_NEAR(5.0, width.value.double_value, 0.001);
    
    Double height = rect->getHeight();
    ASSERT_NEAR(3.0, height.value.double_value, 0.001);
    
    // 验证引用计数
    ASSERT_EQ(1, rect->getRefCount());
}

TEST(inheritance_and_polymorphism) {
    // 创建不同类型的图形对象（使用具体类型而不是基类指针）
    ObjectPtr<Rectangle> rect = Shape::create<Rectangle>(String("Rect"), Double(4.0), Double(3.0));
    ObjectPtr<Circle> circle = Shape::create<Circle>(String("Circle"), Double(2.0));
    ObjectPtr<Triangle> triangle = Shape::create<Triangle>(String("Triangle"), Double(3.0), Double(4.0), Double(5.0));
    
    // 验证面积计算
    Double rect_area = rect->area();
    ASSERT_NEAR(12.0, rect_area.value.double_value, 0.001);
    
    Double circle_area = circle->area();
    ASSERT_NEAR(12.566, circle_area.value.double_value, 0.01);
    
    Double triangle_area = triangle->area();
    ASSERT_NEAR(6.0, triangle_area.value.double_value, 0.001);
    
    // 验证周长计算
    Double rect_perimeter = rect->perimeter();
    ASSERT_NEAR(14.0, rect_perimeter.value.double_value, 0.001);
    
    Double circle_perimeter = circle->perimeter();
    ASSERT_NEAR(12.566, circle_perimeter.value.double_value, 0.01);
    
    Double triangle_perimeter = triangle->perimeter();
    ASSERT_NEAR(12.0, triangle_perimeter.value.double_value, 0.001);
}

TEST(virtual_function_calls) {
    ObjectPtr<Rectangle> rect = Shape::create<Rectangle>(String("TestRect"), Double(2.0), Double(3.0));
    ObjectPtr<Circle> circle = Shape::create<Circle>(String("TestCircle"), Double(1.0));
    
    // 测试 toString()
    String rect_str = rect->toString();
    ASSERT_TRUE(rect_str.contains(String("Rectangle")).value.bool_value);
    ASSERT_TRUE(rect_str.contains(String("TestRect")).value.bool_value);
    
    String circle_str = circle->toString();
    ASSERT_TRUE(circle_str.contains(String("Circle")).value.bool_value);
    ASSERT_TRUE(circle_str.contains(String("TestCircle")).value.bool_value);
}

TEST(dynamic_casting) {
    ObjectPtr<Rectangle> rect = Shape::create<Rectangle>(String("CastTest"), Double(5.0), Double(4.0));
    
    // 验证对象功能
    Bool is_square = rect->isSquare();
    ASSERT_FALSE(is_square.value.bool_value);
    
    // 验证对象不为null
    ASSERT_TRUE(rect.get() != nullptr);
}

// ============================================================================
// 封装性测试
// ============================================================================

TEST(encapsulation_and_access_control) {
    ObjectPtr<Rectangle> rect = Shape::create<Rectangle>(String("EncapTest"), Double(10.0), Double(5.0));
    
    // 测试公共接口
    Double original_width = rect->getWidth();
    ASSERT_NEAR(10.0, original_width.value.double_value, 0.001);
    
    // 修改属性
    rect->setWidth(Double(15.0));
    Double new_width = rect->getWidth();
    ASSERT_NEAR(15.0, new_width.value.double_value, 0.001);
    
    // 验证计算结果更新
    Double new_area = rect->area();
    ASSERT_NEAR(75.0, new_area.value.double_value, 0.001);  // 15 * 5 = 75
}

TEST(method_overriding) {
    ObjectPtr<Rectangle> rect = Shape::create<Rectangle>(String("Override"), Double(3.0), Double(4.0));
    ObjectPtr<Circle> circle = Shape::create<Circle>(String("Override"), Double(2.0));
    
    // 测试方法重写 - toString()
    String rect_str = rect->toString();
    String circle_str = circle->toString();
    
    // 每个类都应该有自己的 toString 实现
    ASSERT_TRUE(rect_str.contains(String("Rectangle")).value.bool_value);
    ASSERT_TRUE(circle_str.contains(String("Circle")).value.bool_value);
    
    // 验证内容不同
    Bool strings_different = !(rect_str == circle_str);
    ASSERT_TRUE(strings_different.value.bool_value);
}

// ============================================================================
// 特殊方法测试
// ============================================================================

TEST(special_shape_methods) {
    // 测试 Rectangle 的特殊方法
    ObjectPtr<Rectangle> square = Shape::create<Rectangle>(String("Square"), Double(5.0), Double(5.0));
    ObjectPtr<Rectangle> rect = Shape::create<Rectangle>(String("Rect"), Double(5.0), Double(3.0));
    
    Bool square_is_square = square->isSquare();
    ASSERT_TRUE(square_is_square.value.bool_value);
    
    Bool rect_is_square = rect->isSquare();
    ASSERT_FALSE(rect_is_square.value.bool_value);
    
    // 测试 Circle 的特殊方法
    ObjectPtr<Circle> circle = Shape::create<Circle>(String("TestCircle"), Double(3.0));
    Double diameter = circle->getDiameter();
    ASSERT_NEAR(6.0, diameter.value.double_value, 0.001);
    
    // 测试 Triangle 的特殊方法
    ObjectPtr<Triangle> equilateral = Shape::create<Triangle>(String("Equi"), Double(5.0), Double(5.0), Double(5.0));
    ObjectPtr<Triangle> isosceles = Shape::create<Triangle>(String("Iso"), Double(5.0), Double(5.0), Double(3.0));
    ObjectPtr<Triangle> scalene = Shape::create<Triangle>(String("Scalene"), Double(3.0), Double(4.0), Double(5.0));
    
    Bool equi_is_equilateral = equilateral->isEquilateral();
    ASSERT_TRUE(equi_is_equilateral.value.bool_value);
    
    Bool equi_is_isosceles = equilateral->isIsosceles();
    ASSERT_TRUE(equi_is_isosceles.value.bool_value);  // 等边三角形也是等腰三角形
    
    Bool iso_is_equilateral = isosceles->isEquilateral();
    ASSERT_FALSE(iso_is_equilateral.value.bool_value);
    
    Bool iso_is_isosceles = isosceles->isIsosceles();
    ASSERT_TRUE(iso_is_isosceles.value.bool_value);
    
    Bool scalene_is_isosceles = scalene->isIsosceles();
    ASSERT_FALSE(scalene_is_isosceles.value.bool_value);
}

// ============================================================================
// 集合中的对象测试
// ============================================================================

TEST(objects_in_collections) {
    // 创建图形对象列表（使用具体类型）
    ObjectPtr<List<ObjectPtr<Rectangle>>> rectangles = List<ObjectPtr<Rectangle>>::create();
    
    rectangles->add(Shape::create<Rectangle>(String("Rect1"), Double(2.0), Double(3.0)));
    rectangles->add(Shape::create<Rectangle>(String("Rect2"), Double(4.0), Double(5.0)));
    rectangles->add(Shape::create<Rectangle>(String("Rect3"), Double(1.0), Double(6.0)));
    
    ASSERT_EQ(3, rectangles->size().value.int_value);
    
    // 计算总面积使用索引访问
    double total_area = 0.0;
    for (int i = 0; i < 3; i++) {
        ObjectPtr<Rectangle> rect = rectangles->get(Int(i));
        Double area = rect->area();
        total_area += area.value.double_value;
    }
    
    // 验证总面积 (2*3 + 4*5 + 1*6 = 6 + 20 + 6 = 32)
    ASSERT_NEAR(32.0, total_area, 0.1);
}

TEST(shape_polymorphic_operations) {
    ObjectPtr<List<ObjectPtr<Rectangle>>> rectangles = List<ObjectPtr<Rectangle>>::create();
    
    rectangles->add(Shape::create<Rectangle>(String("R1"), Double(4.0), Double(2.0)));
    rectangles->add(Shape::create<Rectangle>(String("R2"), Double(3.0), Double(3.0)));  // 正方形
    rectangles->add(Shape::create<Rectangle>(String("R3"), Double(5.0), Double(1.0)));
    
    // 统计正方形
    int square_count = 0;
    
    for (int i = 0; i < 3; i++) {
        ObjectPtr<Rectangle> rect = rectangles->get(Int(i));
        if (rect->isSquare().value.bool_value) {
            square_count++;
        }
    }
    
    ASSERT_EQ(1, square_count);
}

// ============================================================================
// 内存管理和引用计数测试
// ============================================================================

TEST(reference_counting) {
    ObjectPtr<Rectangle> rect1 = Shape::create<Rectangle>(String("RefTest"), Double(1.0), Double(1.0));
    
    // 验证对象创建成功
    ASSERT_TRUE(rect1.get() != nullptr);
    ASSERT_EQ(1, rect1->getRefCount());
    
    // 验证对象功能
    Double area = rect1->area();
    ASSERT_NEAR(1.0, area.value.double_value, 0.001);
    
    Bool is_square = rect1->isSquare();
    ASSERT_TRUE(is_square.value.bool_value);
}

TEST(object_lifetime_management) {
    ObjectPtr<Rectangle> shape;
    
    {
        // 在作用域内创建对象
        ObjectPtr<Rectangle> rect = Shape::create<Rectangle>(String("Lifetime"), Double(2.0), Double(2.0));
        ASSERT_TRUE(rect.get() != nullptr);
        
        // 赋值给外部指针
        shape = rect;
        
        // 验证对象功能
        Double area_in_scope = rect->area();
        ASSERT_NEAR(4.0, area_in_scope.value.double_value, 0.001);
    }
    
    // 对象应该仍然可用
    ASSERT_TRUE(shape.get() != nullptr);
    Double area = shape->area();
    ASSERT_NEAR(4.0, area.value.double_value, 0.001);
    
    String name = shape->getName();
    ASSERT_EQ("Lifetime", name.getValue());
}

// ============================================================================
// 主函数
// ============================================================================

int main() {
    std::cout << "=== 面向对象编程测试开始 ===" << std::endl;
    std::cout << std::endl;
    
    std::cout << "--- 基础OOP测试 ---" << std::endl;
    RUN_TEST(basic_object_creation);
    RUN_TEST(inheritance_and_polymorphism);
    RUN_TEST(virtual_function_calls);
    RUN_TEST(dynamic_casting);
    std::cout << std::endl;
    
    std::cout << "--- 封装性测试 ---" << std::endl;
    RUN_TEST(encapsulation_and_access_control);
    RUN_TEST(method_overriding);
    std::cout << std::endl;
    
    std::cout << "--- 特殊方法测试 ---" << std::endl;
    RUN_TEST(special_shape_methods);
    std::cout << std::endl;
    
    std::cout << "--- 集合中的对象测试 ---" << std::endl;
    RUN_TEST(objects_in_collections);
    RUN_TEST(shape_polymorphic_operations);
    std::cout << std::endl;
    
    std::cout << "--- 内存管理和引用计数测试 ---" << std::endl;
    RUN_TEST(reference_counting);
    RUN_TEST(object_lifetime_management);
    std::cout << std::endl;
    
    std::cout << "=== 所有面向对象编程测试通过! ===" << std::endl;
    
    return 0;
}
