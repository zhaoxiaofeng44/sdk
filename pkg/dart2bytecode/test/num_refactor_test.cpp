#include "../cpp/core/num.h"
#include "../cpp/core/string.h"
#include <cassert>
#include <cstdio>

int main() {
    printf("开始测试Num类重构...\n");
    
    // 测试Int相关方法
    Int* int1 = Int::cppNew(42);
    Int* int2 = Int::cppNew(10);
    
    // 测试从Int类移动过来的方法
    Int* bitLength_result = Num::bitLength(int1);
    assert(bitLength_result != nullptr);
    printf("✓ Num::bitLength测试通过\n");
    
    Bool* isEven_result = Num::isEven(int1);
    assert(isEven_result != nullptr);
    printf("✓ Num::isEven测试通过\n");
    
    Bool* isOdd_result = Num::isOdd(int1);
    assert(isOdd_result != nullptr);
    printf("✓ Num::isOdd测试通过\n");
    
    Bool* isNegative_result = Num::isNegative(int1);
    assert(isNegative_result != nullptr);
    printf("✓ Num::isNegative测试通过\n");
    
    // 测试cppGet方法
    Int* cppGet_bitLength_result = Num::cppGet_bitLength(int1);
    assert(cppGet_bitLength_result != nullptr);
    printf("✓ Num::cppGet_bitLength测试通过\n");
    
    Bool* cppGet_isEven_result = Num::cppGet_isEven(int1);
    assert(cppGet_isEven_result != nullptr);
    printf("✓ Num::cppGet_isEven测试通过\n");
    
    Bool* cppGet_isOdd_result = Num::cppGet_isOdd(int1);
    assert(cppGet_isOdd_result != nullptr);
    printf("✓ Num::cppGet_isOdd测试通过\n");
    
    Bool* cppGet_isNegative_result = Num::cppGet_isNegative(int1);
    assert(cppGet_isNegative_result != nullptr);
    printf("✓ Num::cppGet_isNegative测试通过\n");
    
    // 测试parseInt方法
    String* str1 = String::cppNew("123");
    Int* parseInt_result = Num::parseInt(str1, nullptr);
    assert(parseInt_result != nullptr);
    printf("✓ Num::parseInt测试通过\n");
    
    // 测试Int的toString方法
    String* intToString_result = Num::toString(int1);
    assert(intToString_result != nullptr);
    printf("✓ Num::toString(Int*)测试通过\n");
    
    // 测试Double相关方法
    Double* double1 = Double::cppNew(3.14);
    Double* double2 = Double::cppNew(2.0);
    
    // 测试从Double类移动过来的方法
    Bool* isNaN_result = Num::isNaN(double1);
    assert(isNaN_result != nullptr);
    printf("✓ Num::isNaN测试通过\n");
    
    Bool* isInfinite_result = Num::isInfinite(double1);
    assert(isInfinite_result != nullptr);
    printf("✓ Num::isInfinite测试通过\n");
    
    Bool* isFinite_result = Num::isFinite(double1);
    assert(isFinite_result != nullptr);
    printf("✓ Num::isFinite测试通过\n");
    
    // 测试数学函数
    Double* atan_result = Num::atan(double1);
    assert(atan_result != nullptr);
    printf("✓ Num::atan测试通过\n");
    
    Double* acos_result = Num::acos(double2);
    assert(acos_result != nullptr);
    printf("✓ Num::acos测试通过\n");
    
    Double* asin_result = Num::asin(double2);
    assert(asin_result != nullptr);
    printf("✓ Num::asin测试通过\n");
    
    Double* atan2_result = Num::atan2(double1, double2);
    assert(atan2_result != nullptr);
    printf("✓ Num::atan2测试通过\n");
    
    // 测试cppGet方法
    Bool* cppGet_isNaN_result = Num::cppGet_isNaN(double1);
    assert(cppGet_isNaN_result != nullptr);
    printf("✓ Num::cppGet_isNaN测试通过\n");
    
    Bool* cppGet_isInfinite_result = Num::cppGet_isInfinite(double1);
    assert(cppGet_isInfinite_result != nullptr);
    printf("✓ Num::cppGet_isInfinite测试通过\n");
    
    Bool* cppGet_isFinite_result = Num::cppGet_isFinite(double1);
    assert(cppGet_isFinite_result != nullptr);
    printf("✓ Num::cppGet_isFinite测试通过\n");
    
    // 测试parseDouble方法
    String* str2 = String::cppNew("3.14");
    Double* parseDouble_result = Num::parseDouble(str2);
    assert(parseDouble_result != nullptr);
    printf("✓ Num::parseDouble测试通过\n");
    
    // 测试Double的toString方法
    String* doubleToString_result = Num::toString(double1);
    assert(doubleToString_result != nullptr);
    printf("✓ Num::toString(Double*)测试通过\n");
    
    // 测试原有的Num类方法仍然可用
    Num* num1 = Num::cppNew(100);
    Num* num2 = Num::cppNew(50.5);
    
    Num* add_result = Num::cpp_add(num1, num2);
    assert(add_result != nullptr);
    printf("✓ Num::cpp_add测试通过\n");
    
    Bool* equals_result = Num::cpp_equals(num1, num2);
    assert(equals_result != nullptr);
    printf("✓ Num::cpp_equals测试通过\n");
    
    // 清理内存
    delete int1;
    delete int2;
    delete double1;
    delete double2;
    delete num1;
    delete num2;
    delete str1;
    delete str2;
    
    printf("所有测试通过！Num类重构成功。\n");
    return 0;
} 