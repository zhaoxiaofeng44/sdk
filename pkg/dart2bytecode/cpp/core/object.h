#ifndef _OBJECT_H_
#define _OBJECT_H_

#include <cstddef>  // 为了使用 NULL
#include <cstdlib>  // 为了使用 malloc

#define CppNew(C, name, args...) C::cppNew()->name(args)

#define CppApply(C, name, obj, i, args...)                                     \
  reinterpret_cast<decltype(&C::name)>(obj->vtab[i])(obj, args);

#define CppNewMap(args...)                                                     \
  CppMap::cppNew()->cppCtr_fromCppArray(nullptr)

#define CppNewList(args...)                                                    \
  CppList::cppNew()->cppCtr_fromCppArray(nullptr)

#define CppNewSet(args...)                                                     \
  CppSet::cppNew()->cppCtr_fromCppArray(nullptr)

// 前向声明
class String;
class Bool;
class Int;
class Double;
class Type;

class Any {};

class Null : public Any {};

extern Null null;  // 声明为extern，在cpp文件中定义

class Object : public Any {
 public:
  int gc_mark;
  // 构造函数和析构函数
  Object();
  virtual ~Object();

  // 操作符和访问器方法 (根据映射表转换，添加前缀)
  Bool* cpp_equals(Object* b);  // == 相等比较
  Type* cppGet_runtimeType();   // runtimeType getter

  // Dart Object的核心方法
  String* toString();  // 获取字符串表示
  Int* hashCode();     // 获取哈希码
  Object* noSuchMethod(Object* obj,
                       String* methodName,
                       Object** args,
                       Int* argCount);  // 处理不存在的方法调用

  static Bool* equals(Object* a, Object* b);  // == 相等比较
  static Object* cppNew() {
    auto ptr = (Object*)malloc(sizeof(Object));
    return ptr;
  }
};

// Type类 - 表示运行时类型信息
class Type : public Object {
 public:
  String* typeName;
  Type* superType;

  Type(const char* name);
  ~Type();

  // 类型比较
  static Bool* isSubtypeOf(Type* type, Type* supertype);
  static Bool* isSameType(Type* a, Type* b);

  // 获取预定义类型
  static Type* getObjectType();
  static Type* getStringType();
  static Type* getIntType();
  static Type* getDoubleType();
  static Type* getBoolType();
  static Type* getNullType();
};

#endif