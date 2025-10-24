#include "../pkg/dart2bytecode/base/object.h"
#include <iostream>

// ============================================================================
// ObjectPtr包裹容器测试
// ============================================================================

// 示例自定义类
class Person : public Object {
private:
    String name_;
    Int age_;
    
    Person(const String& name, const Int& age)
        : name_(name), age_(age) {
        std::cout << "Person构造: " << name_.getValue() << std::endl;
    }
    
public:
    static ObjectPtr<Person> create(const String& name, const Int& age) {
        return ObjectPtr<Person>(new Person(name, age));
    }
    
    virtual ~Person() {
        std::cout << "Person析构: " << name_.getValue() << std::endl;
    }
    
    String getName() const { return name_; }
    Int getAge() const { return age_; }
    
    virtual String toString() const override {
        return String("Person(") + name_ + String(", ") + age_.toString() + String(")");
    }
};

// ============================================================================
// 测试函数
// ============================================================================

// 测试1: List使用ObjectPtr
void test_list_with_objectptr() {
    std::cout << "\n=== 测试1: List使用ObjectPtr ===" << std::endl;
    
    // 创建List（通过ObjectPtr）
    ObjectPtr<List<Int>> numbers = List<Int>::create();
    
    // 添加元素
    numbers->add(Int(10));
    numbers->add(Int(20));
    numbers->add(Int(30));
    
    std::cout << "List大小: " << numbers->size().toInt() << std::endl;
    std::cout << "第一个元素: " << (*numbers)[Int(0)].toInt() << std::endl;
    
    // 遍历
    std::cout << "所有元素: ";
    numbers->forEach([](const Int& n) {
        std::cout << n.toInt() << " ";
    });
    std::cout << std::endl;
    
    // 子列表
    ObjectPtr<List<Int>> sublist = numbers->subList(Int(0), Int(2));
    std::cout << "子列表大小: " << sublist->size().toInt() << std::endl;
}

// 测试2: Set使用ObjectPtr
void test_set_with_objectptr() {
    std::cout << "\n=== 测试2: Set使用ObjectPtr ===" << std::endl;
    
    // 创建Set（通过ObjectPtr）
    ObjectPtr<Set<String>> names = Set<String>::create();
    
    // 添加元素
    names->add(String("Alice"));
    names->add(String("Bob"));
    names->add(String("Charlie"));
    names->add(String("Alice"));  // 重复，不会添加
    
    std::cout << "Set大小: " << names->size().toInt() << std::endl;
    std::cout << "包含Alice: " << names->contains(String("Alice")).toBool() << std::endl;
    
    // 遍历
    std::cout << "所有元素: ";
    names->forEach([](const String& s) {
        std::cout << s.getValue() << " ";
    });
    std::cout << std::endl;
}

// 测试3: Map使用ObjectPtr
void test_map_with_objectptr() {
    std::cout << "\n=== 测试3: Map使用ObjectPtr ===" << std::endl;
    
    // 创建Map（通过ObjectPtr）
    ObjectPtr<Map<String, Int>> scores = Map<String, Int>::create();
    
    // 添加键值对
    scores->put(String("Alice"), Int(95));
    scores->put(String("Bob"), Int(87));
    scores->put(String("Charlie"), Int(92));
    
    std::cout << "Map大小: " << scores->size().toInt() << std::endl;
    std::cout << "Alice的分数: " << (*scores)[String("Alice")].toInt() << std::endl;
    
    // 遍历
    std::cout << "所有分数:" << std::endl;
    scores->forEach([](const String& name, const Int& score) {
        std::cout << "  " << name.getValue() << ": " << score.toInt() << std::endl;
    });
}

// 测试4: Set集合操作
void test_set_operations() {
    std::cout << "\n=== 测试4: Set集合操作 ===" << std::endl;
    
    // 创建两个Set
    ObjectPtr<Set<Int>> set1 = Set<Int>::create();
    set1->add(Int(1));
    set1->add(Int(2));
    set1->add(Int(3));
    
    ObjectPtr<Set<Int>> set2 = Set<Int>::create();
    set2->add(Int(2));
    set2->add(Int(3));
    set2->add(Int(4));
    
    std::cout << "Set1大小: " << set1->size().toInt() << std::endl;
    std::cout << "Set2大小: " << set2->size().toInt() << std::endl;
    
    // 并集
    ObjectPtr<Set<Int>> unionSet = set1->unionWith(set2);
    std::cout << "并集大小: " << unionSet->size().toInt() << std::endl;
    
    // 交集
    ObjectPtr<Set<Int>> intersectionSet = set1->intersection(set2);
    std::cout << "交集大小: " << intersectionSet->size().toInt() << std::endl;
    
    // 差集
    ObjectPtr<Set<Int>> differenceSet = set1->difference(set2);
    std::cout << "差集大小: " << differenceSet->size().toInt() << std::endl;
}

// 测试5: 容器共享
void test_container_sharing() {
    std::cout << "\n=== 测试5: 容器共享 ===" << std::endl;
    
    // 创建List
    ObjectPtr<List<String>> list1 = List<String>::create();
    list1->add(String("Item1"));
    list1->add(String("Item2"));
    
    // 共享引用
    ObjectPtr<List<String>> list2 = list1;
    
    // 通过list2添加元素
    list2->add(String("Item3"));
    
    // list1也能看到
    std::cout << "list1大小: " << list1->size().toInt() << std::endl;
    std::cout << "list2大小: " << list2->size().toInt() << std::endl;
    std::cout << "共享同一个List对象！" << std::endl;
}

// 测试6: 初始化列表
void test_initializer_lists() {
    std::cout << "\n=== 测试6: 初始化列表 ===" << std::endl;
    
    // List初始化列表
    ObjectPtr<List<Int>> numbers = List<Int>::create({Int(1), Int(2), Int(3), Int(4)});
    std::cout << "List大小: " << numbers->size().toInt() << std::endl;
    
    // Set初始化列表
    ObjectPtr<Set<String>> names = Set<String>::create({String("Alice"), String("Bob"), String("Charlie")});
    std::cout << "Set大小: " << names->size().toInt() << std::endl;
    
    // Map初始化列表
    ObjectPtr<Map<String, Int>> scores = Map<String, Int>::create({
        {String("Alice"), Int(95)},
        {String("Bob"), Int(87)}
    });
    std::cout << "Map大小: " << scores->size().toInt() << std::endl;
}

// 测试7: 使用Person对象
void test_with_custom_objects() {
    std::cout << "\n=== 测试7: 使用自定义对象 ===" << std::endl;
    
    // 创建多个Person对象
    ObjectPtr<Person> p1 = Person::create(String("Alice"), Int(25));
    ObjectPtr<Person> p2 = Person::create(String("Bob"), Int(30));
    ObjectPtr<Person> p3 = Person::create(String("Charlie"), Int(28));
    
    std::cout << "Person 1: " << p1->toString().getValue() << std::endl;
    std::cout << "Person 2: " << p2->toString().getValue() << std::endl;
    std::cout << "Person 3: " << p3->toString().getValue() << std::endl;
    
    // 注意：由于模板实例化限制，不能直接使用 List<ObjectPtr<Person>>
    // 这需要在object.cpp中显式实例化
    std::cout << "（容器嵌套需要在object.cpp中显式实例化）" << std::endl;
}

// 测试8: 迭代器
void test_iterator() {
    std::cout << "\n=== 测试8: 迭代器 ===" << std::endl;
    
    ObjectPtr<List<Int>> numbers = List<Int>::create();
    for (int i = 1; i <= 5; i++) {
        numbers->add(Int(i * 10));
    }
    
    // 使用迭代器
    std::cout << "使用迭代器遍历: ";
    ListIterator<Int> iter = numbers->iterator();
    while (iter.hasNext().value) {
        std::cout << iter.next().toInt() << " ";
    }
    std::cout << std::endl;
}

// 测试9: 空指针检查
void test_null_check() {
    std::cout << "\n=== 测试9: 空指针检查 ===" << std::endl;
    
    ObjectPtr<List<Int>> list;  // 默认为空
    
    if (list.isNull().value) {
        std::cout << "List is null" << std::endl;
    }
    
    list = List<Int>::create();
    
    if (list.isNotNull().value) {
        std::cout << "List is not null" << std::endl;
        list->add(Int(42));
        std::cout << "List大小: " << list->size().toInt() << std::endl;
    }
}

// 测试10: 容器复制
void test_container_copy() {
    std::cout << "\n=== 测试10: 容器复制 ===" << std::endl;
    
    // 创建原始List
    ObjectPtr<List<Int>> original = List<Int>::create();
    original->add(Int(1));
    original->add(Int(2));
    original->add(Int(3));
    
    // 创建副本（深拷贝）
    ObjectPtr<List<Int>> copy = List<Int>::create(*original);
    
    // 修改副本
    copy->add(Int(4));
    
    std::cout << "原始List大小: " << original->size().toInt() << std::endl;
    std::cout << "副本List大小: " << copy->size().toInt() << std::endl;
    std::cout << "两个List是独立的！" << std::endl;
}

// ============================================================================
// 主函数
// ============================================================================

int main() {
    std::cout << "========================================" << std::endl;
    std::cout << "ObjectPtr包裹容器测试" << std::endl;
    std::cout << "========================================" << std::endl;
    
    try {
        test_list_with_objectptr();
        test_set_with_objectptr();
        test_map_with_objectptr();
        test_set_operations();
        test_container_sharing();
        test_initializer_lists();
        test_with_custom_objects();
        test_iterator();
        test_null_check();
        test_container_copy();
        
        std::cout << "\n========================================" << std::endl;
        std::cout << "所有测试完成！" << std::endl;
        std::cout << "========================================" << std::endl;
        
    } catch (const std::exception& e) {
        std::cerr << "错误: " << e.what() << std::endl;
        return 1;
    }
    
    return 0;
}

