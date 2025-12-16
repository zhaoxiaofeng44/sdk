#ifndef _DART2CPP_H_
#define _DART2CPP_H_

// ============================================================================
// Dart2CPP Runtime Library - 简化版本
// ============================================================================
// 本文件是 Dart2CPP 库的对外头文件，提供简洁的 Dart 语法支持
// ============================================================================

// ============================================================================
// 核心类型系统
// ============================================================================
#include "dart_object.h"
#include "dart_string.h"


// ============================================================================
// 统一宏定义
// ============================================================================
#include "dart_macros.h"

// ============================================================================
// OOP 扩展 (interface 和 mixin 支持)
// ============================================================================
#include "dart_oop_extensions.h"

// ============================================================================
// 扩展方法支持
// ============================================================================
#include "dart_extensions.h"

// ============================================================================
// 工具类和辅助函数
// ============================================================================
#include "dart_helpers.h"

// ============================================================================
// 异步编程支持
// ============================================================================
#include "dart_async.h"

// ============================================================================
// 对象扩展和辅助函数
// ============================================================================
#include "object_extensions.h"

// ============================================================================
// 使用示例
// ============================================================================

/*
基本使用示例：

#include "dart2cpp.h"

int main() {
    // 基础类型
    auto x = dart_int(42);
    auto name = dart_string("Dart2CPP");
    
    // 运算符 (直接使用C++重载)
    auto sum = x + dart_int(8);
    auto message = name + dart_string(" Library");
    
    // 条件判断 (Bool 有隐式转换)
    if (sum > dart_int(40)) {
        dart_print(message);
    }
    
    // 集合操作
    auto numbers = dart_list_int();
    numbers->add(x);
    numbers->add(sum);
    
    // 遍历集合
    dart_for_each(Int, num, numbers)
        dart_print(num.toString());
    dart_end_for
    
    return 0;
}

接口和Mixin使用示例：

// 定义接口
interface Drawable {
public:
    virtual ~Drawable() {}
    virtual void draw() = 0;
};

// 定义Mixin
mixin ColorMixin {
private:
    String color_;
public:
    ColorMixin() : color_("white") {}
    virtual ~ColorMixin() {}
    
    virtual void setColor(const String& color) {
        color_ = color;
    }
    
    virtual String getColor() {
        return color_;
    }
};

// 使用C++多重继承实现类
class Rectangle : public virtual Drawable, public virtual ColorMixin {
private:
    Int width_, height_;
    
public:
    Rectangle(Int w, Int h) : width_(w), height_(h) {}
    
    virtual void draw() override {
        dart_print(dart_string("Drawing ") + getColor() + dart_string(" rectangle"));
    }
};

// 使用
int main() {
    Rectangle rect(dart_int(10), dart_int(5));
    rect.setColor(dart_string("red"));
    rect.draw();
    return 0;
}
*/

#endif // _DART2CPP_H_