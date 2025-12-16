// ============================================================================
// C++ 集合类型测试用例 - 修复版
// 测试 List、Set、Map 等集合类型的功能
// 使用正确的 API 调用
// ============================================================================

#include "../core/dart2cpp.h"
#include <iostream>
#include <cassert>

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

#define RUN_TEST(name) \
    do { \
        std::cout << "Running test_" << #name << "..." << std::endl; \
        test_##name(); \
        std::cout << "✓ test_" << #name << " passed" << std::endl; \
    } while(0)

// ============================================================================
// List 集合类型测试（使用正确的 API）
// ============================================================================

TEST(list_basic_operations) {
    // 使用正确的 ObjectPtr 包装 List
    ObjectPtr<List<Int>> list = List<Int>::create();
    
    // 测试空列表
    Bool is_empty = list->isEmpty();
    ASSERT_TRUE(is_empty.value.bool_value);
    
    Int size = list->size();
    ASSERT_EQ(0, size.value.int_value);
    
    // 添加元素
    list->add(Int(1));
    list->add(Int(2));
    list->add(Int(3));
    
    Bool is_empty_after = list->isEmpty();
    ASSERT_FALSE(is_empty_after.value.bool_value);
    
    Int size_after = list->size();
    ASSERT_EQ(3, size_after.value.int_value);
    
    // 访问元素
    Int elem0 = list->get(Int(0));
    ASSERT_EQ(1, elem0.value.int_value);
    
    Int elem1 = list->get(Int(1));
    ASSERT_EQ(2, elem1.value.int_value);
    
    Int elem2 = list->get(Int(2));
    ASSERT_EQ(3, elem2.value.int_value);
}

TEST(list_modification_operations) {
    ObjectPtr<List<Int>> list = List<Int>::create();
    
    // 添加多个元素
    list->add(Int(10));
    list->add(Int(20));
    list->add(Int(30));
    
    // 在指定位置插入元素
    list->insert(Int(1), Int(15));
    ASSERT_EQ(4, list->size().value.int_value);
    
    Int elem1 = list->get(Int(1));
    ASSERT_EQ(15, elem1.value.int_value);
    
    // 移除元素（按索引移除使用 removeAt）
    list->removeAt(Int(1));  // 移除索引1的元素（值为15）
    ASSERT_EQ(3, list->size().value.int_value);
    
    // 移除指定值（使用 removeElement）
    list->removeElement(Int(20));
    ASSERT_EQ(2, list->size().value.int_value);
    
    // 清空列表
    list->clear();
    Bool is_empty = list->isEmpty();
    ASSERT_TRUE(is_empty.value.bool_value);
}

TEST(list_search_operations) {
    ObjectPtr<List<String>> list = List<String>::create();
    
    list->add(String("apple"));
    list->add(String("banana"));
    list->add(String("cherry"));
    list->add(String("banana"));  // 重复元素
    
    // 查找元素
    Bool contains_apple = list->contains(String("apple"));
    ASSERT_TRUE(contains_apple.value.bool_value);
    
    Bool contains_grape = list->contains(String("grape"));
    ASSERT_FALSE(contains_grape.value.bool_value);
    
    // 查找索引
    Int index_banana = list->indexOf(String("banana"));
    ASSERT_EQ(1, index_banana.value.int_value);
    
    Int index_grape = list->indexOf(String("grape"));
    ASSERT_EQ(-1, index_grape.value.int_value);
    
    // 查找最后一个索引
    Int last_index_banana = list->lastIndexOf(String("banana"));
    ASSERT_EQ(3, last_index_banana.value.int_value);
}

TEST(list_accessor_operations) {
    ObjectPtr<List<Int>> list = List<Int>::create();
    
    list->add(Int(1));
    list->add(Int(2));
    list->add(Int(3));
    
    // 测试 first 和 last 访问器
    Int first_elem = list->first();
    ASSERT_EQ(1, first_elem.value.int_value);
    
    Int last_elem = list->last();
    ASSERT_EQ(3, last_elem.value.int_value);
    
    // 测试数组访问操作符
    Int elem_by_index = (*list)[Int(1)];
    ASSERT_EQ(2, elem_by_index.value.int_value);
}

// ============================================================================
// Set 集合类型测试
// ============================================================================

TEST(set_basic_operations) {
    ObjectPtr<Set<Int>> set = Set<Int>::create();
    
    // 测试空集合
    Bool is_empty = set->isEmpty();
    ASSERT_TRUE(is_empty.value.bool_value);
    
    Int size = set->size();
    ASSERT_EQ(0, size.value.int_value);
    
    // 添加元素（add 方法返回 void）
    set->add(Int(1));
    set->add(Int(2));
    set->add(Int(3));
    
    // 尝试添加重复元素
    set->add(Int(1));  // 应该不会增加大小
    
    Int size_after = set->size();
    ASSERT_EQ(3, size_after.value.int_value);
}

TEST(set_membership_operations) {
    ObjectPtr<Set<String>> set = Set<String>::create();
    
    set->add(String("apple"));
    set->add(String("banana"));
    set->add(String("cherry"));
    
    // 测试成员关系
    Bool contains_apple = set->contains(String("apple"));
    ASSERT_TRUE(contains_apple.value.bool_value);
    
    Bool contains_grape = set->contains(String("grape"));
    ASSERT_FALSE(contains_grape.value.bool_value);
    
    // 移除元素（remove 返回 void）
    set->remove(String("banana"));
    
    Int size_after_removal = set->size();
    ASSERT_EQ(2, size_after_removal.value.int_value);
    
    Bool contains_banana_after = set->contains(String("banana"));
    ASSERT_FALSE(contains_banana_after.value.bool_value);
}

// ============================================================================
// 简化的集合操作测试
// ============================================================================

TEST(list_sublist_operations) {
    ObjectPtr<List<Int>> list = List<Int>::create();
    
    // 添加元素
    for (int i = 1; i <= 5; i++) {
        list->add(Int(i));
    }
    
    // 测试子列表操作
    ObjectPtr<List<Int>> sublist = list->subList(Int(1), Int(4));
    ASSERT_EQ(3, sublist->size().value.int_value);
    
    Int first_sub = sublist->get(Int(0));
    ASSERT_EQ(2, first_sub.value.int_value);
    
    Int last_sub = sublist->get(Int(2));
    ASSERT_EQ(4, last_sub.value.int_value);
}

TEST(list_utility_operations) {
    ObjectPtr<List<Int>> list = List<Int>::create();
    
    list->add(Int(3));
    list->add(Int(1));
    list->add(Int(4));
    list->add(Int(2));
    
    // 测试反转
    list->reverse();
    Int first_after_reverse = list->get(Int(0));
    ASSERT_EQ(2, first_after_reverse.value.int_value);
    
    // 测试排序
    list->sort();
    Int first_after_sort = list->get(Int(0));
    ASSERT_EQ(1, first_after_sort.value.int_value);
    
    Int last_after_sort = list->get(Int(3));
    ASSERT_EQ(4, last_after_sort.value.int_value);
}

TEST(list_take_skip_operations) {
    ObjectPtr<List<Int>> list = List<Int>::create();
    
    // 添加元素 1-5
    for (int i = 1; i <= 5; i++) {
        list->add(Int(i));
    }
    
    // 测试 take 操作
    ObjectPtr<List<Int>> taken = list->take(Int(3));
    ASSERT_EQ(3, taken->size().value.int_value);
    
    Int taken_first = taken->get(Int(0));
    ASSERT_EQ(1, taken_first.value.int_value);
    
    Int taken_last = taken->get(Int(2));
    ASSERT_EQ(3, taken_last.value.int_value);
    
    // 测试 skip 操作
    ObjectPtr<List<Int>> skipped = list->skip(Int(2));
    ASSERT_EQ(3, skipped->size().value.int_value);
    
    Int skipped_first = skipped->get(Int(0));
    ASSERT_EQ(3, skipped_first.value.int_value);
    
    Int skipped_last = skipped->get(Int(2));
    ASSERT_EQ(5, skipped_last.value.int_value);
}

TEST(list_copy_operations) {
    ObjectPtr<List<Int>> original = List<Int>::create();
    
    original->add(Int(1));
    original->add(Int(2));
    original->add(Int(3));
    
    // 测试 toList 复制
    ObjectPtr<List<Int>> copy = original->toList();
    ASSERT_EQ(3, copy->size().value.int_value);
    
    Int copy_first = copy->get(Int(0));
    ASSERT_EQ(1, copy_first.value.int_value);
    
    // 测试 reversed 复制
    ObjectPtr<List<Int>> reversed_copy = original->reversed();
    ASSERT_EQ(3, reversed_copy->size().value.int_value);
    
    Int reversed_first = reversed_copy->get(Int(0));
    ASSERT_EQ(3, reversed_first.value.int_value);
    
    Int reversed_last = reversed_copy->get(Int(2));
    ASSERT_EQ(1, reversed_last.value.int_value);
}

// ============================================================================
// 主函数
// ============================================================================

int main() {
    std::cout << "=== Dart2CPP 集合类型测试（修复版） ===" << std::endl;
    std::cout << std::endl;
    
    try {
        RUN_TEST(list_basic_operations);
        RUN_TEST(list_modification_operations);
        RUN_TEST(list_search_operations);
        RUN_TEST(list_accessor_operations);
        RUN_TEST(set_basic_operations);
        RUN_TEST(set_membership_operations);
        RUN_TEST(list_sublist_operations);
        RUN_TEST(list_utility_operations);
        RUN_TEST(list_take_skip_operations);
        RUN_TEST(list_copy_operations);
        
        std::cout << std::endl;
        std::cout << "=== 所有集合类型测试通过! ===" << std::endl;
        
    } catch (const std::exception& e) {
        std::cerr << "测试失败: " << e.what() << std::endl;
        return 1;
    } catch (...) {
        std::cerr << "测试失败: 未知异常" << std::endl;
        return 1;
    }
    
    return 0;
}
