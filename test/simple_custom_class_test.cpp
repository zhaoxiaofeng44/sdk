#include "./core/object.h"
#include <iostream>

// 简单的自定义类 - 必须通过ObjectPtr使用
class Counter : public Object {
private:
    Int value_;
    
    Counter(const Int& initial) : value_(initial) {
        std::cout << "Counter构造: " << value_.toInt() << std::endl;
    }
    
public:
    static ObjectPtr<Counter> create(const Int& initial) {
        return ObjectPtr<Counter>(new Counter(initial));
    }
    
    virtual ~Counter() {
        std::cout << "Counter析构: " << value_.toInt() << std::endl;
    }
    
    void increment() {
        value_ = value_ + Int(1);
    }
    
    Int getValue() const { return value_; }
    
    virtual String toString() const override {
        return String("Counter(") + value_.toString() + String(")");
    }
    
    bool operator==(const Counter& other) const {
        return value_ == other.value_;
    }
};

int main() {
    std::cout << "=== 自定义类ObjectPtr测试 ===" << std::endl;
    
    // 测试1: 基本创建和使用
    std::cout << "\n测试1: 基本创建" << std::endl;
    ObjectPtr<Counter> counter1 = Counter::create(Int(0));
    std::cout << "初始值: " << counter1->getValue().toInt() << std::endl;
    
    counter1->increment();
    std::cout << "递增后: " << counter1->getValue().toInt() << std::endl;
    
    // 测试2: 引用计数
    std::cout << "\n测试2: 引用计数" << std::endl;
    {
        ObjectPtr<Counter> counter2 = counter1;
        std::cout << "共享引用: " << counter2->getValue().toInt() << std::endl;
    }
    std::cout << "counter2销毁后，counter1仍有效: " << counter1->getValue().toInt() << std::endl;
    
    // 测试3: toString
    std::cout << "\n测试3: toString" << std::endl;
    std::cout << counter1->toString().getValue() << std::endl;
    
    // 测试4: 泛型容器
    std::cout << "\n测试4: 与基础类型容器结合" << std::endl;
    ObjectPtr<List<Int>> values = List<Int>::create();
    values->add(Int(1));
    values->add(Int(2));
    values->add(Int(3));
    
    std::cout << "List大小: " << values->size().toInt() << std::endl;
    values->forEach([](const Int& v) {
        std::cout << "  " << v.toInt() << std::endl;
    });
    
    std::cout << "\n所有测试完成！" << std::endl;
    return 0;
}
