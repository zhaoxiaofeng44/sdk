#include "object.h"
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include "num.h"
#include "string.h"

// 定义全局null变量
Null null;

// 自定义字符串比较函数，避免使用strcmp
static bool stringEqual(const char* s1, const char* s2) {
  if (!s1 || !s2) return s1 == s2;

  int i = 0;
  while (s1[i] != '\0' && s2[i] != '\0') {
    if (s1[i] != s2[i]) return false;
    i++;
  }
  return s1[i] == s2[i];  // 都应该是'\0'
}

// Object类实现

Object::Object() : gc_mark(0) {}

Object::~Object() {
  // 基础析构函数
}

// ==================== 静态方法实现 ====================

// 操作符方法
Bool* Object::cpp_equals(Object* b) {
  return new Bool(this == b);
}

Type* Object::cppGet_runtimeType() {
  return Type::getObjectType();
}

// Dart Object的核心方法
String* Object::toString() {
  // 默认实现：显示类型和地址
  char buffer[64];
  snprintf(buffer, sizeof(buffer), "Object@%p", static_cast<void*>(this));
  return new String(buffer);
}

Int* Object::hashCode() {
  // 默认实现：使用对象地址作为哈希
  return new Int(reinterpret_cast<intptr_t>(this));
}

Object* Object::noSuchMethod(Object* obj,
                             String* methodName,
                             Object** args,
                             Int* argCount) {
  if (!obj || !methodName) return nullptr;

  // 简单实现：输出错误信息并返回null
  printf("NoSuchMethodError: Method '%s' not found on object\n",
         methodName->c_str());
  return nullptr;
}

Bool* Object::equals(Object* a, Object* b) {
  if (a == nullptr && b == nullptr) return new Bool(true);
  if (a == nullptr || b == nullptr) return new Bool(false);
  return new Bool(a->cpp_equals(b));
}

// ==================== Type类实现 ====================

// 预定义类型的静态实例
static Type* objectType = nullptr;
static Type* stringType = nullptr;
static Type* intType = nullptr;
static Type* doubleType = nullptr;
static Type* boolType = nullptr;
static Type* nullType = nullptr;

Type::Type(const char* name) : superType(nullptr) {
  typeName = new String(name);
}

Type::~Type() {
  delete typeName;
}

Bool* Type::isSubtypeOf(Type* type, Type* supertype) {
  if (!type || !supertype) return new Bool(false);
  if (type == supertype) return new Bool(true);

  // 检查继承链
  Type* current = type->superType;
  while (current) {
    if (current == supertype) return new Bool(true);
    current = current->superType;
  }

  return new Bool(false);
}

Bool* Type::isSameType(Type* a, Type* b) {
  if (!a || !b) return new Bool(false);
  return new Bool(a == b);
}

Type* Type::getObjectType() {
  if (!objectType) {
    objectType = new Type("Object");
  }
  return objectType;
}

Type* Type::getStringType() {
  if (!stringType) {
    stringType = new Type("String");
    stringType->superType = getObjectType();
  }
  return stringType;
}

Type* Type::getIntType() {
  if (!intType) {
    intType = new Type("Int");
    intType->superType = getObjectType();
  }
  return intType;
}

Type* Type::getDoubleType() {
  if (!doubleType) {
    doubleType = new Type("Double");
    doubleType->superType = getObjectType();
  }
  return doubleType;
}

Type* Type::getBoolType() {
  if (!boolType) {
    boolType = new Type("Bool");
    boolType->superType = getObjectType();
  }
  return boolType;
}

Type* Type::getNullType() {
  if (!nullType) {
    nullType = new Type("Null");
    nullType->superType = getObjectType();
  }
  return nullType;
}