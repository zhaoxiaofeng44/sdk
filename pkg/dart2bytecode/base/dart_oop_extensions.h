#ifndef _DART_OOP_EXTENSIONS_H_
#define _DART_OOP_EXTENSIONS_H_

#include "object.h"
#include <typeinfo>

// ============================================================================
// Dart 面向对象扩展 - 接口和 Mixin 模式
// ============================================================================

// ============================================================================
// 1. 接口设计模式 (Interface Pattern)
// ============================================================================

// 接口基类 - 所有接口都应该继承此类
class DartInterface {
public:
    virtual ~DartInterface() {}
    
    // 获取接口类型名称
    virtual String getInterfaceType() const = 0;
};

// 接口定义宏
#define DART_INTERFACE(interface_name) \
    class interface_name : public virtual DartInterface { \
    public: \
        virtual ~interface_name() {} \
        virtual String getInterfaceType() const { \
            return String(#interface_name); \
        }

#define DART_INTERFACE_END };

// 接口方法声明宏
#define DART_ABSTRACT_METHOD(return_type, method_name, params) \
    virtual return_type method_name params = 0;

// ============================================================================
// 2. Mixin 设计模式 (Mixin Pattern)
// ============================================================================

// Mixin 基类
class DartMixin {
public:
    virtual ~DartMixin() {}
    
    // 获取 Mixin 类型名称
    virtual String getMixinType() const = 0;
};

// Mixin 定义宏
#define DART_MIXIN(mixin_name) \
    class mixin_name : public virtual DartMixin { \
    public: \
        virtual ~mixin_name() {} \
        virtual String getMixinType() const { \
            return String(#mixin_name); \
        }

#define DART_MIXIN_END };

// Mixin 方法实现宏
#define DART_MIXIN_METHOD(return_type, method_name, params, body) \
    virtual return_type method_name params body

// ============================================================================
// 3. 类声明和继承宏
// ============================================================================

// 实现接口
#define DART_IMPLEMENTS(interface_name) \
    public virtual interface_name

// 混入 Mixin
#define DART_WITH(mixin_name) \
    public virtual mixin_name

// 类定义宏（支持多继承）
#define DART_CLASS(class_name) \
    class class_name

#define DART_CLASS_EXTENDS(class_name, base_class) \
    class class_name : public base_class

#define DART_CLASS_IMPLEMENTS(class_name, interface1) \
    class class_name : DART_IMPLEMENTS(interface1)

#define DART_CLASS_WITH(class_name, mixin1) \
    class class_name : DART_WITH(mixin1)

#define DART_CLASS_EXTENDS_IMPLEMENTS(class_name, base_class, interface1) \
    class class_name : public base_class, DART_IMPLEMENTS(interface1)

#define DART_CLASS_EXTENDS_WITH(class_name, base_class, mixin1) \
    class class_name : public base_class, DART_WITH(mixin1)

#define DART_CLASS_IMPLEMENTS_WITH(class_name, interface1, mixin1) \
    class class_name : DART_IMPLEMENTS(interface1), DART_WITH(mixin1)

#define DART_CLASS_EXTENDS_IMPLEMENTS_WITH(class_name, base_class, interface1, mixin1) \
    class class_name : public base_class, DART_IMPLEMENTS(interface1), DART_WITH(mixin1)

// ============================================================================
// 4. 类型检查和转换
// ============================================================================

// 检查是否实现了某个接口
template<typename InterfaceType, typename ObjectType>
Bool dart_implements(const ObjectType* obj) {
    const InterfaceType* interface_ptr = dynamic_cast<const InterfaceType*>(obj);
    return Bool(interface_ptr != NULL);
}

// 检查是否混入了某个 Mixin
template<typename MixinType, typename ObjectType>
Bool dart_has_mixin(const ObjectType* obj) {
    const MixinType* mixin_ptr = dynamic_cast<const MixinType*>(obj);
    return Bool(mixin_ptr != NULL);
}

// 安全的接口转换
template<typename InterfaceType, typename ObjectType>
InterfaceType* dart_as_interface(ObjectType* obj) {
    return dynamic_cast<InterfaceType*>(obj);
}

// 安全的 Mixin 转换
template<typename MixinType, typename ObjectType>
MixinType* dart_as_mixin(ObjectType* obj) {
    return dynamic_cast<MixinType*>(obj);
}

// ============================================================================
// 5. 常用接口定义
// ============================================================================

// 可比较接口
DART_INTERFACE(Comparable)
    DART_ABSTRACT_METHOD(Int, compareTo, (const DartInterface* other))
DART_INTERFACE_END

// 可迭代接口
DART_INTERFACE(Iterable)
    DART_ABSTRACT_METHOD(Bool, hasNext, ())
    DART_ABSTRACT_METHOD(Any, next, ())
    DART_ABSTRACT_METHOD(void, reset, ())
DART_INTERFACE_END

// 可序列化接口
DART_INTERFACE(Serializable)
    DART_ABSTRACT_METHOD(String, serialize, ())
    DART_ABSTRACT_METHOD(Bool, deserialize, (const String& data))
DART_INTERFACE_END

// 可克隆接口
DART_INTERFACE(Cloneable)
    DART_ABSTRACT_METHOD(DartInterface*, clone, ())
DART_INTERFACE_END

// 可观察接口
DART_INTERFACE(Observable)
    DART_ABSTRACT_METHOD(void, addObserver, (DartInterface* observer))
    DART_ABSTRACT_METHOD(void, removeObserver, (DartInterface* observer))
    DART_ABSTRACT_METHOD(void, notifyObservers, ())
DART_INTERFACE_END

// ============================================================================
// 6. 常用 Mixin 定义
// ============================================================================

// 时间戳 Mixin
DART_MIXIN(TimestampMixin)
private:
    Double created_at_;
    Double updated_at_;
    
public:
    TimestampMixin() : created_at_(0.0), updated_at_(0.0) {}
    
    DART_MIXIN_METHOD(void, touch, (), {
        // 这里应该获取当前时间戳，简化为递增
        static double counter = 1.0;
        updated_at_ = counter++;
    })
    
    DART_MIXIN_METHOD(void, onCreate, (), {
        static double counter = 1.0;
        created_at_ = counter;
        updated_at_ = counter++;
    })
    
    DART_MIXIN_METHOD(Double, getCreatedAt, (), {
        return Double(created_at_);
    })
    
    DART_MIXIN_METHOD(Double, getUpdatedAt, (), {
        return Double(updated_at_);
    })
DART_MIXIN_END

// 标识符 Mixin
DART_MIXIN(IdentifiableMixin)
private:
    Int id_;
    
public:
    IdentifiableMixin() : id_(0) {}
    
    DART_MIXIN_METHOD(void, setId, (const Int& id), {
        id_ = id;
    })
    
    DART_MIXIN_METHOD(Int, getId, (), {
        return id_;
    })
    
    DART_MIXIN_METHOD(String, getIdString, (), {
        return String("ID:") + id_.toString();
    })
DART_MIXIN_END

// 名称 Mixin
DART_MIXIN(NameableMixin)
private:
    String name_;
    
public:
    NameableMixin() : name_("Unnamed") {}
    
    DART_MIXIN_METHOD(void, setName, (const String& name), {
        name_ = name;
    })
    
    DART_MIXIN_METHOD(String, getName, (), {
        return name_;
    })
    
    DART_MIXIN_METHOD(String, getDisplayName, (), {
        return String("[") + name_ + String("]");
    })
DART_MIXIN_END

// 验证 Mixin
DART_MIXIN(ValidatableMixin)
private:
    Bool is_valid_;
    String error_message_;
    
public:
    ValidatableMixin() : is_valid_(true), error_message_("") {}
    
    DART_MIXIN_METHOD(Bool, isValid, (), {
        return is_valid_;
    })
    
    DART_MIXIN_METHOD(String, getErrorMessage, (), {
        return error_message_;
    })
    
    DART_MIXIN_METHOD(void, setValid, (Bool valid), {
        is_valid_ = valid;
        if (valid.toBool()) {
            error_message_ = String("");
        }
    })
    
    DART_MIXIN_METHOD(void, setError, (const String& message), {
        is_valid_ = Bool(false);
        error_message_ = message;
    })
    
    DART_MIXIN_METHOD(Bool, validate, (), {
        // 默认实现 - 子类应该重写
        return Bool(true);
    })
DART_MIXIN_END

// ============================================================================
// 7. 工厂模式支持
// ============================================================================

// 工厂接口
DART_INTERFACE(Factory)
    DART_ABSTRACT_METHOD(DartInterface*, create, ())
    DART_ABSTRACT_METHOD(String, getProductType, ())
DART_INTERFACE_END

// 单例 Mixin
DART_MIXIN(SingletonMixin)
private:
    static DartInterface* instance_;
    
public:
    DART_MIXIN_METHOD(DartInterface*, getInstance, (), {
        if (instance_ == NULL) {
            // 注意：这里需要子类实现具体的创建逻辑
            // instance_ = new ConcreteClass();
        }
        return instance_;
    })
    
    DART_MIXIN_METHOD(void, resetInstance, (), {
        if (instance_ != NULL) {
            delete instance_;
            instance_ = NULL;
        }
    })
DART_MIXIN_END

// 初始化静态成员
template<typename T>
DartInterface* SingletonMixin::instance_ = NULL;

// ============================================================================
// 8. 便利宏和工具
// ============================================================================

// 快速实现接口方法
#define DART_OVERRIDE(return_type, method_name, params, body) \
    virtual return_type method_name params override body

// 检查类型宏
#define DART_IS_INSTANCE_OF(obj, type) \
    (dynamic_cast<const type*>(obj) != NULL)

#define DART_CAST_TO(obj, type) \
    dynamic_cast<type*>(obj)

// 安全调用宏
#define DART_SAFE_CALL(obj, interface_type, method_call) \
    do { \
        interface_type* __interface = dart_as_interface<interface_type>(obj); \
        if (__interface != NULL) { \
            __interface->method_call; \
        } \
    } while(0)

// 调试信息宏
#define DART_CLASS_INFO(obj) \
    String("Class: ") + String(typeid(*obj).name())

#define DART_PRINT_TYPE_INFO(obj) \
    std::cout << "Object type: " << typeid(*obj).name() << std::endl

// ============================================================================
// 9. 示例用法说明
// ============================================================================

/*
使用示例：

// 1. 定义接口
DART_INTERFACE(Drawable)
    DART_ABSTRACT_METHOD(void, draw, ())
    DART_ABSTRACT_METHOD(Double, getArea, ())
DART_INTERFACE_END

// 2. 定义 Mixin
DART_MIXIN(ColorMixin)
private:
    String color_;
public:
    DART_MIXIN_METHOD(void, setColor, (const String& color), {
        color_ = color;
    })
    DART_MIXIN_METHOD(String, getColor, (), {
        return color_;
    })
DART_MIXIN_END

// 3. 定义类（继承、实现接口、混入 Mixin）
DART_CLASS_IMPLEMENTS_WITH(Rectangle, Drawable, ColorMixin) {
private:
    Double width_, height_;
    
public:
    Rectangle(Double w, Double h) : width_(w), height_(h) {
        setColor(String("white"));
    }
    
    // 实现接口方法
    virtual void draw() override {
        std::cout << "Drawing " << getColor().getValue() 
                  << " rectangle" << std::endl;
    }
    
    virtual Double getArea() override {
        return width_ * height_;
    }
};

// 4. 使用
Rectangle rect(Double(10), Double(5));
rect.setColor(String("red"));
rect.draw();

// 5. 类型检查
Bool isDrawable = dart_implements<Drawable>(&rect);
Bool hasColorMixin = dart_has_mixin<ColorMixin>(&rect);
*/

#endif // _DART_OOP_EXTENSIONS_H_
