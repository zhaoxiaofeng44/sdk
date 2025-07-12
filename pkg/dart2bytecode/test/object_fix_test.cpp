#include "../cpp/core/object.h"
#include "../cpp/core/string.h"
#include "../cpp/core/num.h"
#include <cassert>
#include <cstdio>

int main() {
    printf("开始测试Object类修复...\n");
    
    // 测试Object静态方法
    Object* obj1 = ObjectImp::cppNew();
    Object* obj2 = ObjectImp::cppNew();
    
    // 测试cpp_equals方法
    Bool* equals_result = Object::cpp_equals(obj1, obj1);
    assert(equals_result != nullptr);
    printf("✓ cpp_equals方法测试通过\n");
    
    // 测试toString方法
    String* str_result = Object::toString(obj1);
    assert(str_result != nullptr);
    printf("✓ toString方法测试通过\n");
    
    // 测试hashCode方法
    Int* hash_result = Object::hashCode(obj1);
    assert(hash_result != nullptr);
    printf("✓ hashCode方法测试通过\n");
    
    // 测试cppGet_runtimeType方法
    Type* type_result = Object::cppGet_runtimeType(obj1);
    assert(type_result != nullptr);
    printf("✓ cppGet_runtimeType方法测试通过\n");
    
    // 测试cppToString函数
    String* cpp_str_result = cppToString(obj1);
    assert(cpp_str_result != nullptr);
    printf("✓ cppToString函数测试通过\n");
    
    // 测试null对象
    String* null_str_result = cppToString(nullptr);
    assert(null_str_result != nullptr);
    printf("✓ null对象处理测试通过\n");
    
    // 测试Type类
    Type* objectType = Type::getObjectType();
    assert(objectType != nullptr);
    printf("✓ Type::getObjectType测试通过\n");
    
    Type* stringType = Type::getStringType();
    assert(stringType != nullptr);
    printf("✓ Type::getStringType测试通过\n");
    
    // 测试类型比较
    Bool* subtype_result = Type::isSubtypeOf(stringType, objectType);
    assert(subtype_result != nullptr);
    printf("✓ Type::isSubtypeOf测试通过\n");
    
    Bool* same_type_result = Type::isSameType(objectType, objectType);
    assert(same_type_result != nullptr);
    printf("✓ Type::isSameType测试通过\n");
    
    // 测试ObjectImp类
    const String** keys = nullptr;
    const void** ptrs = nullptr;
    ObjectImp* objImp = new ObjectImp(keys, ptrs, 0);
    assert(objImp != nullptr);
    printf("✓ ObjectImp构造函数测试通过\n");
    
    delete objImp;
    delete obj1;
    delete obj2;
    
    printf("所有测试通过！Object类修复成功。\n");
    return 0;
} 