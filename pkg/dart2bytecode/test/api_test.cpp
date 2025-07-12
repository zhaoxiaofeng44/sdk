#include <iostream>
#include <cassert>
#include "../cpp/core/api.h"

// 测试指针数组操作
void testPointerArray() {
    std::cout << "测试指针数组操作..." << std::endl;
    
    // 创建长度为3的指针数组
    Int* length = Int::cppNew(3);
    void** array = CppApi::cppCreatePointerArray(length);
    
    assert(array != NULL);
    
    // 创建一些测试对象
    String* str1 = String::cppNew("Hello");
    String* str2 = String::cppNew("World");
    Int* num = Int::cppNew(42);
    
    // 设置数组项
    CppApi::cppSetPointerArrayItem(array, Int::cppNew(0), str1);
    CppApi::cppSetPointerArrayItem(array, Int::cppNew(1), str2);
    CppApi::cppSetPointerArrayItem(array, Int::cppNew(2), num);
    
    // 获取数组项并验证
    Object* item0 = CppApi::cppGetPointerArrayItem(array, Int::cppNew(0));
    Object* item1 = CppApi::cppGetPointerArrayItem(array, Int::cppNew(1));
    Object* item2 = CppApi::cppGetPointerArrayItem(array, Int::cppNew(2));
    
    assert(item0 == str1);
    assert(item1 == str2);
    assert(item2 == num);
    
    // 测试边界情况
    void** nullArray = CppApi::cppCreatePointerArray(NULL);
    assert(nullArray == NULL);
    
    void** zeroArray = CppApi::cppCreatePointerArray(Int::cppNew(0));
    assert(zeroArray == NULL);
    
    Object* nullItem = CppApi::cppGetPointerArrayItem(NULL, Int::cppNew(0));
    assert(nullItem == NULL);
    
    delete[] array;
    std::cout << "指针数组测试通过!" << std::endl;
}

// 测试字节数组操作
void testByteArray() {
    std::cout << "测试字节数组操作..." << std::endl;
    
    // 创建长度为3的字节数组
    Int* length = Int::cppNew(3);
    void** array = CppApi::cppCreateByteArray(length);
    
    assert(array != NULL);
    
    // 创建一些整数对象
    Int* byte1 = Int::cppNew(10);
    Int* byte2 = Int::cppNew(20);
    Int* byte3 = Int::cppNew(30);
    
    // 设置数组项
    CppApi::cppSetByteArrayItem(array, Int::cppNew(0), byte1);
    CppApi::cppSetByteArrayItem(array, Int::cppNew(1), byte2);
    CppApi::cppSetByteArrayItem(array, Int::cppNew(2), byte3);
    
    // 获取数组项并验证
    Int* item0 = CppApi::cppGetByteArrayItem(array, Int::cppNew(0));
    Int* item1 = CppApi::cppGetByteArrayItem(array, Int::cppNew(1));
    Int* item2 = CppApi::cppGetByteArrayItem(array, Int::cppNew(2));
    
    assert(item0 == byte1);
    assert(item1 == byte2);
    assert(item2 == byte3);
    
    // 测试边界情况
    void** nullArray = CppApi::cppCreateByteArray(NULL);
    assert(nullArray == NULL);
    
    Int* nullItem = CppApi::cppGetByteArrayItem(NULL, Int::cppNew(0));
    assert(nullItem == NULL);
    
    delete[] array;
    std::cout << "字节数组测试通过!" << std::endl;
}

// 测试字符串连接
void testJoinListString() {
    std::cout << "测试字符串连接..." << std::endl;
    
    // 创建字符串数组
    void** array = new void*[3];
    array[0] = String::cppNew("Hello");
    array[1] = String::cppNew("World");
    array[2] = String::cppNew("Test");
    
    // 使用逗号分隔符
    String* separator = String::cppNew(",");
    String* result = CppApi::cppJoinListString(array, Int::cppNew(3), separator);
    
    std::cout << "连接结果: " << result->c_str() << std::endl;
    
    // 测试无分隔符
    String* result2 = CppApi::cppJoinListString(array, Int::cppNew(3), NULL);
    std::cout << "无分隔符结果: " << result2->c_str() << std::endl;
    
    // 测试空数组
    String* result3 = CppApi::cppJoinListString(NULL, Int::cppNew(0), separator);
    assert(result3 != NULL);
    std::cout << "空数组结果: '" << result3->c_str() << "'" << std::endl;
    
    // 测试单个元素
    void** singleArray = new void*[1];
    singleArray[0] = String::cppNew("Single");
    String* result4 = CppApi::cppJoinListString(singleArray, Int::cppNew(1), separator);
    std::cout << "单个元素结果: " << result4->c_str() << std::endl;
    
    delete[] array;
    delete[] singleArray;
    std::cout << "字符串连接测试通过!" << std::endl;
}

// 测试布尔值获取
void testBoolValue() {
    std::cout << "测试布尔值获取..." << std::endl;
    
    // 创建布尔对象
    Bool* trueValue = Bool::cppNew(true);
    Bool* falseValue = Bool::cppNew(false);
    
    // 获取布尔值
    bool result1 = CppApi::cppBoolValue(trueValue);
    bool result2 = CppApi::cppBoolValue(falseValue);
    bool result3 = CppApi::cppBoolValue(NULL);
    
    assert(result1 == true);
    assert(result2 == false);
    assert(result3 == false);
    
    std::cout << "布尔值测试通过!" << std::endl;
}

int main() {
    std::cout << "开始CppApi测试..." << std::endl;
    
    testPointerArray();
    testByteArray();
    testJoinListString();
    testBoolValue();
    
    std::cout << "所有测试通过!" << std::endl;
    return 0;
} 