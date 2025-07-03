#include "string.h"
#include "object.h"
#include "num.h"
#include <cstdio>
#include <cstdlib>
#include <cstring>

// 自定义字符串比较函数，避免使用strcmp
static bool stringEqual(const char* s1, const char* s2) {
    if (!s1 || !s2) return s1 == s2;
    
    int i = 0;
    while (s1[i] != '\0' && s2[i] != '\0') {
        if (s1[i] != s2[i]) return false;
        i++;
    }
    return s1[i] == s2[i]; // 都应该是'\0'
}

// Object类实现

// 操作符方法
Bool* Object::cppOpr_equals(Object* other) noexcept {
    if (!other) return new Bool(false);
    if (this == other) return new Bool(true); // 同一个对象
    return new Bool(false); // 默认实现：只有同一个对象才相等
}

Int* Object::cppGet_hashCode() noexcept {
    // 默认实现：使用对象地址作为哈希
    return new Int(reinterpret_cast<intptr_t>(this));
}

String* Object::cppGet_toString() noexcept {
    // 默认实现：显示类型和地址
    char buffer[64];
    snprintf(buffer, sizeof(buffer), "Object@%p", static_cast<void*>(this));
    return new String(buffer);
}

Type* Object::cppGet_runtimeType() noexcept {
    // 默认实现：返回Object类型
    return Type::getObjectType();
}

// Dart Object的核心方法
String* Object::toString() noexcept {
    // 默认实现：显示类型和地址
    char buffer[64];
    snprintf(buffer, sizeof(buffer), "Object@%p", static_cast<void*>(this));
    return new String(buffer);
}

Int* Object::hashCode() noexcept {
    // 默认实现：使用对象地址作为哈希
    return new Int(reinterpret_cast<intptr_t>(this));
}

Bool* Object::equals(Object* other) noexcept {
    if (!other) return new Bool(false);
    if (this == other) return new Bool(true); // 同一个对象
    
    // 默认实现：只有同一个对象才相等
    return new Bool(false);
}

Type* Object::runtimeType() noexcept {
    // 默认实现：返回Object类型
    return Type::getObjectType();
}

Object* Object::noSuchMethod(String* methodName, Object** args, Int* argCount) noexcept {
    if (!methodName) return nullptr;
    
    // 简单实现：输出错误信息并返回null
    printf("NoSuchMethodError: Method '%s' not found on object\n", methodName->c_str());
    return nullptr;
}

// ==================== Type类实现 ====================

// 预定义类型的静态实例
static Type* objectType = nullptr;
static Type* stringType = nullptr;
static Type* intType = nullptr;
static Type* doubleType = nullptr;
static Type* boolType = nullptr;
static Type* nullType = nullptr;

Type::Type(const char* name) : typeName(new String(name)), superType(nullptr) {
}

Type::~Type() noexcept {
    delete typeName;
}

String* Type::getName() const noexcept {
    return typeName;
}

Type* Type::getSuperType() const noexcept {
    return superType;
}

void Type::setSuperType(Type* type) noexcept {
    superType = type;
}

String* Type::toString() noexcept {
    return typeName;
}

Bool* Type::isSubtypeOf(Type* type, Type* supertype) noexcept {
    if (!type || !supertype) return new Bool(false);
    
    Type* current = type;
    while (current) {
        if (current == supertype) return new Bool(true);
        current = current->getSuperType();
    }
    return new Bool(false);
}

Bool* Type::isSameType(Type* a, Type* b) noexcept {
    if (!a || !b) return new Bool(false);
    return new Bool(a == b);
}

Type* Type::getObjectType() noexcept {
    if (!objectType) {
        objectType = new Type("Object");
    }
    return objectType;
}

Type* Type::getStringType() noexcept {
    if (!stringType) {
        stringType = new Type("String");
        stringType->setSuperType(getObjectType());
    }
    return stringType;
}

Type* Type::getIntType() noexcept {
    if (!intType) {
        intType = new Type("Int");
        intType->setSuperType(getObjectType());
    }
    return intType;
}

Type* Type::getDoubleType() noexcept {
    if (!doubleType) {
        doubleType = new Type("Double");
        doubleType->setSuperType(getObjectType());
    }
    return doubleType;
}

Type* Type::getBoolType() noexcept {
    if (!boolType) {
        boolType = new Type("Bool");
        boolType->setSuperType(getObjectType());
    }
    return boolType;
}

Type* Type::getNullType() noexcept {
    if (!nullType) {
        nullType = new Type("Null");
        nullType->setSuperType(getObjectType());
    }
    return nullType;
} 