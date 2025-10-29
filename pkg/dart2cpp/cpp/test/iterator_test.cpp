#include "../pkg/dart2bytecode/base/object.h"
#include <iostream>

// 测试List迭代器
void test_list_iterator() {
    std::cout << "\n=== 测试List迭代器 ===" << std::endl;
    
    ObjectPtr<List<Int>> list = List<Int>::create();
    list->add(Int(10));
    list->add(Int(20));
    list->add(Int(30));
    list->add(Int(40));
    list->add(Int(50));
    
    std::cout << "List大小: " << list->size().toInt() << std::endl;
    
    // 使用迭代器遍历
    std::cout << "使用迭代器遍历:" << std::endl;
    ListIterator<Int> iter = list->iterator();
    while (iter.hasNext().value) {
        Int value = iter.next();
        std::cout << "  值: " << value.toInt() << std::endl;
    }
    
    // 使用forEach遍历
    std::cout << "使用forEach遍历:" << std::endl;
    list->forEach([](const Int& value) {
        std::cout << "  值: " << value.toInt() << std::endl;
    });
}

// 测试Set迭代器
void test_set_iterator() {
    std::cout << "\n=== 测试Set迭代器 ===" << std::endl;
    
    ObjectPtr<Set<String>> set = Set<String>::create();
    set->add(String("apple"));
    set->add(String("banana"));
    set->add(String("cherry"));
    set->add(String("date"));
    
    std::cout << "Set大小: " << set->size().toInt() << std::endl;
    
    // 使用迭代器遍历
    std::cout << "使用迭代器遍历:" << std::endl;
    SetIterator<String> iter = set->iterator();
    while (iter.hasNext().value) {
        String value = iter.next();
        std::cout << "  值: " << value.getValue() << std::endl;
    }
    
    // 使用forEach遍历
    std::cout << "使用forEach遍历:" << std::endl;
    set->forEach([](const String& value) {
        std::cout << "  值: " << value.getValue() << std::endl;
    });
}

// 测试Map迭代器
void test_map_iterator() {
    std::cout << "\n=== 测试Map迭代器 ===" << std::endl;
    
    ObjectPtr<Map<String, Int>> map = Map<String, Int>::create();
    map->put(String("one"), Int(1));
    map->put(String("two"), Int(2));
    map->put(String("three"), Int(3));
    map->put(String("four"), Int(4));
    
    std::cout << "Map大小: " << map->size().toInt() << std::endl;
    
    // 使用迭代器遍历
    std::cout << "使用迭代器遍历:" << std::endl;
    MapIterator<String, Int> iter = map->iterator();
    while (iter.hasNext().value) {
        String key = iter.currentKey();
        Int value = iter.currentValue();
        std::cout << "  键: " << key.getValue() 
                  << ", 值: " << value.toInt() << std::endl;
        iter.next();
    }
    
    // 使用forEach遍历
    std::cout << "使用forEach遍历:" << std::endl;
    map->forEach([](const String& key, const Int& value) {
        std::cout << "  键: " << key.getValue() 
                  << ", 值: " << value.toInt() << std::endl;
    });
}

// 测试迭代器异常处理
void test_iterator_exceptions() {
    std::cout << "\n=== 测试迭代器异常处理 ===" << std::endl;
    
    ObjectPtr<List<Int>> list = List<Int>::create();
    list->add(Int(1));
    list->add(Int(2));
    
    ListIterator<Int> iter = list->iterator();
    
    // 正常遍历
    while (iter.hasNext().value) {
        iter.next();
    }
    
    // 尝试在结束后继续
    try {
        iter.next();
        std::cout << "错误：应该抛出异常" << std::endl;
    } catch (const std::out_of_range& e) {
        std::cout << "正确捕获异常: " << e.what() << std::endl;
    }
}

// 测试迭代器与算法结合
void test_iterator_with_algorithms() {
    std::cout << "\n=== 测试迭代器与算法结合 ===" << std::endl;
    
    ObjectPtr<List<Int>> numbers = List<Int>::create();
    for (int i = 1; i <= 10; i++) {
        numbers->add(Int(i));
    }
    
    // 计算总和
    Int sum(0);
    numbers->forEach([&sum](const Int& value) {
        sum = sum + value;
    });
    std::cout << "总和: " << sum.toInt() << std::endl;
    
    // 过滤偶数
    std::cout << "偶数:" << std::endl;
    numbers->forEach([](const Int& value) {
        if (value.get_isEven().value) {
            std::cout << "  " << value.toInt() << std::endl;
        }
    });
    
    // 转换和打印
    std::cout << "平方值:" << std::endl;
    numbers->forEach([](const Int& value) {
        Int squared = value * value;
        std::cout << "  " << value.toInt() << "² = " 
                  << squared.toInt() << std::endl;
    });
}

// 测试迭代器的多次使用
void test_iterator_reuse() {
    std::cout << "\n=== 测试迭代器的多次使用 ===" << std::endl;
    
    ObjectPtr<List<Int>> list = List<Int>::create();
    list->add(Int(1));
    list->add(Int(2));
    list->add(Int(3));
    
    std::cout << "第一次遍历:" << std::endl;
    ListIterator<Int> iter1 = list->iterator();
    while (iter1.hasNext().value) {
        std::cout << "  " << iter1.next().toInt() << std::endl;
    }
    
    std::cout << "第二次遍历（新迭代器）:" << std::endl;
    ListIterator<Int> iter2 = list->iterator();
    while (iter2.hasNext().value) {
        std::cout << "  " << iter2.next().toInt() << std::endl;
    }
}

int main() {
    std::cout << "========================================" << std::endl;
    std::cout << "迭代器包装类测试（ObjectPtr版本）" << std::endl;
    std::cout << "========================================" << std::endl;
    
    try {
        test_list_iterator();
        test_set_iterator();
        test_map_iterator();
        test_iterator_exceptions();
        test_iterator_with_algorithms();
        test_iterator_reuse();
        
        std::cout << "\n========================================" << std::endl;
        std::cout << "所有迭代器测试完成！" << std::endl;
        std::cout << "========================================" << std::endl;
        
    } catch (const std::exception& e) {
        std::cerr << "测试过程中发生异常: " << e.what() << std::endl;
        return 1;
    }
    
    return 0;
}
