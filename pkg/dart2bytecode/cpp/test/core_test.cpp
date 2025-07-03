#include "../core/string.h"
#include "../core/num.h"
#include "../core/array.h"
#include "../core/object.h"
#include <iostream>
#include <cstring>

// 简单的测试框架
#define TEST(name) void test_##name()
#define RUN_TEST(name) std::cout << "Running test: " << #name << "... "; test_##name(); std::cout << "PASSED" << std::endl

// 简单的断言宏
#define ASSERT(condition) if (!(condition)) { std::cout << "FAILED: " << #condition << " at line " << __LINE__ << std::endl; exit(1); }
#define ASSERT_EQ(a, b) if ((a) != (b)) { std::cout << "FAILED: " << #a << " == " << #b << " at line " << __LINE__ << std::endl; exit(1); }
#define ASSERT_STR_EQ(a, b) ASSERT(strcmp((a), (b)) == 0)

// 测试String类
TEST(string_basic) {
    String s1("hello");
    String s2("world");
    
    ASSERT_EQ(s1.length(), 5);
    ASSERT_STR_EQ(s1.c_str(), "hello");
    
    String* s3 = s1.cpp_add(&s2);
    ASSERT_STR_EQ(s3->c_str(), "helloworld");
    delete s3;
    
    Bool* eq = s1.cpp_equals(&s1);
    ASSERT_EQ(eq->getValue(), true);
    delete eq;
    
    eq = s1.cpp_equals(&s2);
    ASSERT_EQ(eq->getValue(), false);
    delete eq;
}

TEST(string_methods) {
    String s1("hello world");
    
    String* upper = s1.toUpperCase();
    ASSERT_STR_EQ(upper->c_str(), "HELLO WORLD");
    delete upper;
    
    String* lower = s1.toLowerCase();
    ASSERT_STR_EQ(lower->c_str(), "hello world");
    delete lower;
    
    String* sub = s1.substring(new Int(0), new Int(5));
    ASSERT_STR_EQ(sub->c_str(), "hello");
    delete sub;
    
    Bool* contains = s1.contains(new String("world"));
    ASSERT_EQ(contains->getValue(), true);
    delete contains;
    
    Bool* startsWith = s1.startsWith(new String("hello"));
    ASSERT_EQ(startsWith->getValue(), true);
    delete startsWith;
    
    Int* index = s1.indexOf(new String("world"));
    ASSERT_EQ(index->getValue(), 6);
    delete index;
}

// 测试Num类
TEST(num_basic) {
    Num n1(42);
    Num n2(3.14);
    
    ASSERT_EQ(n1.isInt(), true);
    ASSERT_EQ(n1.isDouble(), false);
    ASSERT_EQ(n1.getInt(), 42);
    
    ASSERT_EQ(n2.isInt(), false);
    ASSERT_EQ(n2.isDouble(), true);
    ASSERT(abs(n2.getDouble() - 3.14) < 0.001);
    
    Num* sum = n1.cpp_add(&n2);
    ASSERT_EQ(sum->isDouble(), true);
    ASSERT(abs(sum->getDouble() - 45.14) < 0.001);
    delete sum;
    
    Num* product = n1.cpp_multiply(&n2);
    ASSERT_EQ(product->isDouble(), true);
    ASSERT(abs(product->getDouble() - 131.88) < 0.001);
    delete product;
}

TEST(int_methods) {
    Int i1(42);
    
    Bool* isEven = i1.isEven();
    ASSERT_EQ(isEven->getValue(), true);
    delete isEven;
    
    Bool* isOdd = i1.isOdd();
    ASSERT_EQ(isOdd->getValue(), false);
    delete isOdd;
    
    Int* bitLen = i1.bitLength();
    ASSERT_EQ(bitLen->getValue(), 6); // 42 = 101010 (6位)
    delete bitLen;
}

TEST(double_methods) {
    Double d1(3.14);
    Double d2(0.0/0.0); // NaN
    
    Bool* isFinite = d1.isFinite();
    ASSERT_EQ(isFinite->getValue(), true);
    delete isFinite;
    
    Bool* isNaN = d2.isNaN();
    ASSERT_EQ(isNaN->getValue(), true);
    delete isNaN;
}

// 测试Bool类
TEST(bool_methods) {
    Bool b1(true);
    Bool b2(false);
    
    Bool* b_not = b1.cpp_not();
    ASSERT_EQ(b_not->getValue(), false);
    delete b_not;
    
    Bool* b_and = b1.cpp_bitwiseAnd(&b2);
    ASSERT_EQ(b_and->getValue(), false);
    delete b_and;
    
    Bool* b_or = b1.cpp_bitwiseOr(&b2);
    ASSERT_EQ(b_or->getValue(), true);
    delete b_or;
}

// 测试Array类
TEST(array_basic) {
    CppArray arr(5);
    
    ASSERT_EQ(arr.length, 5);
    
    arr.set(0, new Int(10));
    arr.set(1, new Int(20));
    arr.set(2, new String("hello"));
    
    Int* i1 = dynamic_cast<Int*>(arr.get(0));
    ASSERT_EQ(i1->getValue(), 10);
    
    Int* i2 = dynamic_cast<Int*>(arr.get(1));
    ASSERT_EQ(i2->getValue(), 20);
    
    String* s = dynamic_cast<String*>(arr.get(2));
    ASSERT_STR_EQ(s->c_str(), "hello");
    
    // 测试边界检查
    ASSERT_EQ(arr.get(-1), nullptr);
    ASSERT_EQ(arr.get(5), nullptr);
}

// 测试Object类
TEST(object_basic) {
    Object obj;
    String* str = obj.toString();
    ASSERT(str != nullptr);
    delete str;
    
    Int* hash = obj.hashCode();
    ASSERT(hash != nullptr);
    delete hash;
}

int main() {
    std::cout << "Running core library tests..." << std::endl;
    
    RUN_TEST(string_basic);
    RUN_TEST(string_methods);
    RUN_TEST(num_basic);
    RUN_TEST(int_methods);
    RUN_TEST(double_methods);
    RUN_TEST(bool_methods);
    RUN_TEST(array_basic);
    RUN_TEST(object_basic);
    
    std::cout << "All tests passed!" << std::endl;
    return 0;
}
