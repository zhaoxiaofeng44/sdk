#ifndef _OBJECT_H_
#define _OBJECT_H_

#include <cstdio>
#include <cstdlib>
#include <cstring>

#define CppNewMap(args...)                                                     \
  CppMap::cppNew()->cppCtr_fromCppArray(                                       \
      CppArray::cppNew()->cppCtr_initializer({args}))

#define CppNewList(args...)                                                    \
  CppList::cppNew()->cppCtr_fromCppArray(                                      \
      CppArray::cppNew()->cppCtr_initializer({args}))

#define CppNewSet(args...)                                                     \
  CppSet::cppNew()->cppCtr_fromCppArray(                                       \
      CppArray::cppNew()->cppCtr_initializer({args}))

// 前向声明
class Bool;
class Int;
class String;
class Type;
class Null;

class Any {
 public:
  virtual ~Any() = default;
};

class Object {
 public:
  Object() = default;
  virtual ~Object() = default;

  // 成员方法
  virtual Bool* cppOpr_equals(Object* other);  // == 相等比较
  virtual Int* cppGet_hashCode();              // hashCode getter
  virtual String* cppGet_toString();           // toString getter
  virtual Type* cppGet_runtimeType();          // runtimeType getter
  virtual String* toString();                  // toString方法

  // Dart Object的核心方法
  virtual Int* hashCode();
  virtual Bool* equals(Object* other);
  virtual Type* runtimeType();

  // 处理不存在的方法调用
  virtual Object* noSuchMethod(String* methodName,
                               Object** args,
                               Int* argCount);

  // 静态工厂方法
  static Object* cppNew() { return new Object(); }
};

class Type : public Object {
 private:
  String* typeName;
  Type* superType;

 public:
  explicit Type(const char* name);
  ~Type() override;

  String* getName() const;
  Type* getSuperType() const;
  void setSuperType(Type* type);
  virtual String* toString() override;

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