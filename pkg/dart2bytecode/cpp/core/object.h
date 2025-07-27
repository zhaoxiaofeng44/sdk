#ifndef _OBJECT_H_
#define _OBJECT_H_

#include <cstddef>  // 为了使用 NULL
#include <cstdlib>  // 为了使用 malloc
#include <map>      // 为了使用 malloc

// 前向声明
class String;
class Bool;
class Int;
class Double;
class Type;
class Object {
 public:
  int mark;
  // 构造函数和析构函数
  Object();

  virtual ~Object();

  static Type* cppGet_runtimeType(Object* a);  // runtimeType getter

  // 操作符和访问器方法 (根据映射表转换，添加前缀)
  static Bool* cpp_equals(Object* a, Object* b);  // == 相等比较
  static String* toString(Object* obj);           // 获取字符串表示
  static Int* cppGet_hashCode(Object* obj);       // 获取哈希码
  static Object* noSuchMethod(Object* obj,
                              String* methodName,
                              Object** args,
                              Int* argCount);  // 处理不存在的方法调用
};

class ObjectImp : public Object {
 public:
  std::map<String*, void*>* ptrs;
  Type* runtimeType;
  std::map<String*, Object*>* metas;
  ObjectImp(Type* type, std::map<String*, void*>* ptrs);

  virtual ~ObjectImp();

  static Type* cppGet_runtimeType(Object* a);

  static Object* cppNew();
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