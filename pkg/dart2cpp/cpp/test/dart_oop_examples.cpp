#include "../core/object.h"
#include "../core/dart_oop_extensions.h"
#include <iostream>

// ============================================================================
// Dart 面向对象设计模式完整示例
// ============================================================================

// 简化的打印宏
#define dart_print(value) \
    do { \
        std::cout << (value).toString().getValue() << std::endl; \
    } while(0)

// 简化的类型构造宏
#define dart_int(value) Int(value)
#define dart_double(value) Double(value)
#define dart_bool(value) Bool(value)
#define dart_string(value) String(value)

// ============================================================================
// 示例 1: 基础接口定义
// ============================================================================

// 可绘制接口
DART_INTERFACE(Drawable)
    DART_ABSTRACT_METHOD(void, draw, ())
    DART_ABSTRACT_METHOD(Double, getArea, ())
    DART_ABSTRACT_METHOD(String, getShapeType, ())
DART_INTERFACE_END

// 可移动接口
DART_INTERFACE(Movable)
    DART_ABSTRACT_METHOD(void, moveTo, (Double x, Double y))
    DART_ABSTRACT_METHOD(Double, getX, ())
    DART_ABSTRACT_METHOD(Double, getY, ())
DART_INTERFACE_END

// 可缩放接口
DART_INTERFACE(Scalable)
    DART_ABSTRACT_METHOD(void, scale, (Double factor))
    DART_ABSTRACT_METHOD(Double, getScale, ())
DART_INTERFACE_END

// ============================================================================
// 示例 2: 实用 Mixin 定义
// ============================================================================

// 位置 Mixin
DART_MIXIN(PositionMixin)
private:
    Double x_, y_;
    
public:
    PositionMixin() : x_(0.0), y_(0.0) {}
    
    DART_MIXIN_METHOD(void, setPosition, (Double x, Double y), {
        x_ = x;
        y_ = y;
    })
    
    DART_MIXIN_METHOD(Double, getX, (), {
        return x_;
    })
    
    DART_MIXIN_METHOD(Double, getY, (), {
        return y_;
    })
    
    DART_MIXIN_METHOD(String, getPositionString, (), {
        return dart_string("(") + x_.toString() + dart_string(", ") + y_.toString() + dart_string(")");
    })
DART_MIXIN_END

// 颜色 Mixin
DART_MIXIN(ColorMixin)
private:
    String color_;
    
public:
    ColorMixin() : color_("white") {}
    
    DART_MIXIN_METHOD(void, setColor, (const String& color), {
        color_ = color;
    })
    
    DART_MIXIN_METHOD(String, getColor, (), {
        return color_;
    })
    
    DART_MIXIN_METHOD(String, getColorInfo, (), {
        return dart_string("Color: ") + color_;
    })
DART_MIXIN_END

// 缩放 Mixin
DART_MIXIN(ScaleMixin)
private:
    Double scale_factor_;
    
public:
    ScaleMixin() : scale_factor_(1.0) {}
    
    DART_MIXIN_METHOD(void, setScale, (Double factor), {
        if (factor > dart_double(0.0)) {
            scale_factor_ = factor;
        }
    })
    
    DART_MIXIN_METHOD(Double, getScale, (), {
        return scale_factor_;
    })
    
    DART_MIXIN_METHOD(String, getScaleInfo, (), {
        return dart_string("Scale: ") + scale_factor_.toString() + dart_string("x");
    })
DART_MIXIN_END

// ============================================================================
// 示例 3: 具体类实现 - 矩形
// ============================================================================

DART_CLASS_IMPLEMENTS_WITH(Rectangle, Drawable, PositionMixin) {
private:
    Double width_, height_;
    
public:
    Rectangle(Double w, Double h) : width_(w), height_(h) {
        setPosition(dart_double(0.0), dart_double(0.0));
    }
    
    Rectangle(Double w, Double h, Double x, Double y) : width_(w), height_(h) {
        setPosition(x, y);
    }
    
    // 实现 Drawable 接口
    virtual void draw() override {
        String info = dart_string("Drawing Rectangle at ") + getPositionString() +
                     dart_string(" with size ") + width_.toString() + 
                     dart_string("x") + height_.toString();
        dart_print(info);
    }
    
    virtual Double getArea() override {
        return width_ * height_;
    }
    
    virtual String getShapeType() override {
        return dart_string("Rectangle");
    }
    
    // 矩形特有的方法
    void setSize(Double w, Double h) {
        width_ = w;
        height_ = h;
    }
    
    Double getWidth() const { return width_; }
    Double getHeight() const { return height_; }
};

// ============================================================================
// 示例 4: 多接口多 Mixin - 彩色可缩放圆形
// ============================================================================

DART_CLASS rectangle_base : DART_IMPLEMENTS(Drawable), DART_IMPLEMENTS(Movable), 
                           DART_IMPLEMENTS(Scalable), DART_WITH(PositionMixin), 
                           DART_WITH(ColorMixin), DART_WITH(ScaleMixin) {
private:
    Double radius_;
    
public:
    Circle(Double r) : radius_(r) {
        setPosition(dart_double(0.0), dart_double(0.0));
        setColor(dart_string("blue"));
        setScale(dart_double(1.0));
    }
    
    Circle(Double r, Double x, Double y, const String& color) : radius_(r) {
        setPosition(x, y);
        setColor(color);
        setScale(dart_double(1.0));
    }
    
    // 实现 Drawable 接口
    virtual void draw() override {
        String info = dart_string("Drawing ") + getColor() + dart_string(" Circle at ") + 
                     getPositionString() + dart_string(" with radius ") + 
                     (radius_ * getScale()).toString();
        dart_print(info);
    }
    
    virtual Double getArea() override {
        Double scaled_radius = radius_ * getScale();
        return dart_double(3.14159) * scaled_radius * scaled_radius;
    }
    
    virtual String getShapeType() override {
        return dart_string("Circle");
    }
    
    // 实现 Movable 接口
    virtual void moveTo(Double x, Double y) override {
        setPosition(x, y);
        dart_print(dart_string("Circle moved to ") + getPositionString());
    }
    
    // 实现 Scalable 接口  
    virtual void scale(Double factor) override {
        setScale(factor);
        dart_print(dart_string("Circle scaled to ") + getScaleInfo());
    }
    
    // 圆形特有的方法
    void setRadius(Double r) {
        if (r > dart_double(0.0)) {
            radius_ = r;
        }
    }
    
    Double getRadius() const { return radius_; }
    Double getScaledRadius() const { return radius_ * getScale(); }
};

// 修正：使用正确的类定义语法
class Circle : DART_IMPLEMENTS(Drawable), DART_IMPLEMENTS(Movable), 
               DART_IMPLEMENTS(Scalable), DART_WITH(PositionMixin), 
               DART_WITH(ColorMixin), DART_WITH(ScaleMixin) {
private:
    Double radius_;
    
public:
    Circle(Double r) : radius_(r) {
        setPosition(dart_double(0.0), dart_double(0.0));
        setColor(dart_string("blue"));
        setScale(dart_double(1.0));
    }
    
    Circle(Double r, Double x, Double y, const String& color) : radius_(r) {
        setPosition(x, y);
        setColor(color);
        setScale(dart_double(1.0));
    }
    
    // 实现 Drawable 接口
    virtual void draw() override {
        String info = dart_string("Drawing ") + getColor() + dart_string(" Circle at ") + 
                     getPositionString() + dart_string(" with radius ") + 
                     (radius_ * getScale()).toString();
        dart_print(info);
    }
    
    virtual Double getArea() override {
        Double scaled_radius = radius_ * getScale();
        return dart_double(3.14159) * scaled_radius * scaled_radius;
    }
    
    virtual String getShapeType() override {
        return dart_string("Circle");
    }
    
    // 实现 Movable 接口
    virtual void moveTo(Double x, Double y) override {
        setPosition(x, y);
        dart_print(dart_string("Circle moved to ") + getPositionString());
    }
    
    // 实现 Scalable 接口  
    virtual void scale(Double factor) override {
        setScale(factor);
        dart_print(dart_string("Circle scaled to ") + getScaleInfo());
    }
    
    // 圆形特有的方法
    void setRadius(Double r) {
        if (r > dart_double(0.0)) {
            radius_ = r;
        }
    }
    
    Double getRadius() const { return radius_; }
    Double getScaledRadius() const { return radius_ * getScale(); }
};

// ============================================================================
// 示例 5: 使用内置 Mixin 的实体类
// ============================================================================

class User : DART_IMPLEMENTS(Serializable), DART_WITH(IdentifiableMixin), 
             DART_WITH(NameableMixin), DART_WITH(TimestampMixin), 
             DART_WITH(ValidatableMixin) {
private:
    String email_;
    Int age_;
    
public:
    User(const String& name, const String& email, Int age) 
        : email_(email), age_(age) {
        setName(name);
        onCreate();
        setId(dart_int(1000 + age.toInt())); // 简化的ID生成
    }
    
    // 实现 Serializable 接口
    virtual String serialize() override {
        return dart_string("{") +
               dart_string("\"id\":") + getId().toString() + dart_string(",") +
               dart_string("\"name\":\"") + getName() + dart_string("\",") +
               dart_string("\"email\":\"") + email_ + dart_string("\",") +
               dart_string("\"age\":") + age_.toString() +
               dart_string("}");
    }
    
    virtual Bool deserialize(const String& data) override {
        // 简化的反序列化实现
        dart_print(dart_string("Deserializing: ") + data);
        return dart_bool(true);
    }
    
    // 重写验证方法
    virtual Bool validate() override {
        if (getName() == dart_string("") || getName() == dart_string("Unnamed")) {
            setError(dart_string("Name cannot be empty"));
            return dart_bool(false);
        }
        
        if (age_ < dart_int(0) || age_ > dart_int(150)) {
            setError(dart_string("Age must be between 0 and 150"));
            return dart_bool(false);
        }
        
        if (email_.length() < dart_int(5)) {
            setError(dart_string("Email too short"));
            return dart_bool(false);
        }
        
        setValid(dart_bool(true));
        return dart_bool(true);
    }
    
    // User 特有方法
    void setEmail(const String& email) {
        email_ = email;
        touch(); // 更新时间戳
    }
    
    void setAge(Int age) {
        age_ = age;
        touch();
    }
    
    String getEmail() const { return email_; }
    Int getAge() const { return age_; }
    
    String getFullInfo() const {
        return getDisplayName() + dart_string(" (") + getIdString() + dart_string(") - ") +
               email_ + dart_string(", Age: ") + age_.toString();
    }
};

// ============================================================================
// 示例 6: 工厂模式
// ============================================================================

class ShapeFactory : DART_IMPLEMENTS(Factory) {
public:
    virtual DartInterface* create() override {
        return new Rectangle(dart_double(5.0), dart_double(3.0));
    }
    
    virtual String getProductType() override {
        return dart_string("Rectangle");
    }
    
    // 工厂特有方法
    static Drawable* createRectangle(Double w, Double h) {
        return new Rectangle(w, h);
    }
    
    static Drawable* createCircle(Double r) {
        return new Circle(r);
    }
    
    static Drawable* createCircle(Double r, Double x, Double y, const String& color) {
        return new Circle(r, x, y, color);
    }
};

// ============================================================================
// 示例函数
// ============================================================================

void demo_basic_interfaces() {
    dart_print(dart_string("=== 基础接口演示 ==="));
    
    // 创建矩形
    Rectangle rect(dart_double(10.0), dart_double(5.0), dart_double(2.0), dart_double(3.0));
    
    dart_print(dart_string("矩形信息："));
    dart_print(dart_string("  类型: ") + rect.getShapeType());
    dart_print(dart_string("  位置: ") + rect.getPositionString());
    dart_print(dart_string("  面积: ") + rect.getArea().toString());
    
    // 绘制
    rect.draw();
    
    // 类型检查
    Bool isDrawable = dart_implements<Drawable>(&rect);
    Bool hasPositionMixin = dart_has_mixin<PositionMixin>(&rect);
    
    dart_print(dart_string("  实现了 Drawable: ") + isDrawable.toString());
    dart_print(dart_string("  混入了 PositionMixin: ") + hasPositionMixin.toString());
}

void demo_multi_inheritance() {
    dart_print(dart_string("=== 多继承和多 Mixin 演示 ==="));
    
    // 创建彩色可缩放圆形
    Circle circle(dart_double(5.0), dart_double(10.0), dart_double(15.0), dart_string("red"));
    
    dart_print(dart_string("圆形信息："));
    dart_print(dart_string("  类型: ") + circle.getShapeType());
    dart_print(dart_string("  ") + circle.getColorInfo());
    dart_print(dart_string("  ") + circle.getScaleInfo());
    dart_print(dart_string("  半径: ") + circle.getRadius().toString());
    dart_print(dart_string("  面积: ") + circle.getArea().toString());
    
    // 测试各种操作
    circle.draw();
    circle.moveTo(dart_double(20.0), dart_double(25.0));
    circle.scale(dart_double(1.5));
    circle.setColor(dart_string("green"));
    
    dart_print(dart_string("更新后："));
    dart_print(dart_string("  ") + circle.getColorInfo());
    dart_print(dart_string("  ") + circle.getScaleInfo());
    dart_print(dart_string("  缩放后半径: ") + circle.getScaledRadius().toString());
    dart_print(dart_string("  缩放后面积: ") + circle.getArea().toString());
    
    circle.draw();
}

void demo_entity_with_mixins() {
    dart_print(dart_string("=== 实体类与 Mixin 演示 ==="));
    
    // 创建用户
    User user(dart_string("张三"), dart_string("zhangsan@example.com"), dart_int(25));
    
    dart_print(dart_string("用户信息："));
    dart_print(dart_string("  ") + user.getFullInfo());
    dart_print(dart_string("  创建时间: ") + user.getCreatedAt().toString());
    dart_print(dart_string("  更新时间: ") + user.getUpdatedAt().toString());
    
    // 验证
    Bool isValid = user.validate();
    dart_print(dart_string("  验证结果: ") + isValid.toString());
    
    if (!isValid) {
        dart_print(dart_string("  错误信息: ") + user.getErrorMessage());
    }
    
    // 序列化
    String serialized = user.serialize();
    dart_print(dart_string("  序列化数据: ") + serialized);
    
    // 更新数据
    user.setAge(dart_int(26));
    user.setEmail(dart_string("zhangsan.new@example.com"));
    
    dart_print(dart_string("更新后："));
    dart_print(dart_string("  ") + user.getFullInfo());
    dart_print(dart_string("  更新时间: ") + user.getUpdatedAt().toString());
}

void demo_factory_pattern() {
    dart_print(dart_string("=== 工厂模式演示 ==="));
    
    ShapeFactory factory;
    
    dart_print(dart_string("工厂信息："));
    dart_print(dart_string("  产品类型: ") + factory.getProductType());
    
    // 使用工厂创建对象
    DartInterface* product = factory.create();
    Drawable* drawable = dynamic_cast<Drawable*>(product);
    
    if (drawable != NULL) {
        dart_print(dart_string("  创建成功: ") + drawable->getShapeType());
        drawable->draw();
        dart_print(dart_string("  面积: ") + drawable->getArea().toString());
    }
    
    // 使用静态工厂方法
    Drawable* rect = ShapeFactory::createRectangle(dart_double(8.0), dart_double(6.0));
    Drawable* circle = ShapeFactory::createCircle(dart_double(4.0), 
                                                  dart_double(5.0), dart_double(5.0), 
                                                  dart_string("purple"));
    
    dart_print(dart_string("静态工厂创建："));
    rect->draw();
    circle->draw();
    
    // 清理内存
    delete product;
    delete rect;
    delete circle;
}

void demo_type_checking() {
    dart_print(dart_string("=== 类型检查演示 ==="));
    
    Circle circle(dart_double(3.0));
    User user(dart_string("李四"), dart_string("lisi@test.com"), dart_int(30));
    
    // 接口检查
    dart_print(dart_string("Circle 类型检查："));
    dart_print(dart_string("  实现 Drawable: ") + dart_implements<Drawable>(&circle).toString());
    dart_print(dart_string("  实现 Movable: ") + dart_implements<Movable>(&circle).toString());
    dart_print(dart_string("  实现 Scalable: ") + dart_implements<Scalable>(&circle).toString());
    dart_print(dart_string("  实现 Serializable: ") + dart_implements<Serializable>(&circle).toString());
    
    dart_print(dart_string("User 类型检查："));
    dart_print(dart_string("  实现 Serializable: ") + dart_implements<Serializable>(&user).toString());
    dart_print(dart_string("  实现 Drawable: ") + dart_implements<Drawable>(&user).toString());
    
    // Mixin 检查
    dart_print(dart_string("Circle Mixin 检查："));
    dart_print(dart_string("  混入 PositionMixin: ") + dart_has_mixin<PositionMixin>(&circle).toString());
    dart_print(dart_string("  混入 ColorMixin: ") + dart_has_mixin<ColorMixin>(&circle).toString());
    dart_print(dart_string("  混入 IdentifiableMixin: ") + dart_has_mixin<IdentifiableMixin>(&circle).toString());
    
    dart_print(dart_string("User Mixin 检查："));
    dart_print(dart_string("  混入 IdentifiableMixin: ") + dart_has_mixin<IdentifiableMixin>(&user).toString());
    dart_print(dart_string("  混入 NameableMixin: ") + dart_has_mixin<NameableMixin>(&user).toString());
    dart_print(dart_string("  混入 TimestampMixin: ") + dart_has_mixin<TimestampMixin>(&user).toString());
    
    // 安全转换
    Drawable* drawable_circle = dart_as_interface<Drawable>(&circle);
    if (drawable_circle != NULL) {
        dart_print(dart_string("成功转换为 Drawable 接口"));
        drawable_circle->draw();
    }
    
    ColorMixin* colorful_circle = dart_as_mixin<ColorMixin>(&circle);
    if (colorful_circle != NULL) {
        dart_print(dart_string("成功转换为 ColorMixin: ") + colorful_circle->getColor());
    }
}

// 主函数
int main() {
    try {
        dart_print(dart_string("Dart 面向对象设计模式示例"));
        dart_print(dart_string("==========================="));
        std::cout << std::endl;
        
        demo_basic_interfaces();
        std::cout << std::endl;
        
        demo_multi_inheritance();
        std::cout << std::endl;
        
        demo_entity_with_mixins();
        std::cout << std::endl;
        
        demo_factory_pattern();
        std::cout << std::endl;
        
        demo_type_checking();
        std::cout << std::endl;
        
        dart_print(dart_string("✅ 所有 OOP 示例运行完成！"));
        dart_print(dart_string("特性总结："));
        dart_print(dart_string("  1. 接口定义和实现"));
        dart_print(dart_string("  2. Mixin 混入和复用"));
        dart_print(dart_string("  3. 多继承支持"));
        dart_print(dart_string("  4. 动态类型检查"));
        dart_print(dart_string("  5. 安全类型转换"));
        dart_print(dart_string("  6. 工厂模式"));
        dart_print(dart_string("  7. 实体模式"));
        
    } catch (...) {
        std::cerr << "❌ 程序执行出现错误" << std::endl;
        return 1;
    }
    
    return 0;
}
