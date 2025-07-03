#ifndef _ARRAY_H_
#define _ARRAY_H_

#include <cstddef>
#include <initializer_list>  // 为了使用 NULL
#include "num.h"             // 为了使用 Int 类
#include "object.h"          // 为了使用 Object 基类

class CppArray : public Object {
 protected:
  Object**  elements;
  int length;

 public:
  CppArray* cppCtr_(Int* capacity);

  Int* getLength();

  void setLength(Int* len);

  Object* getItem(Int* index);

  void setItem(Int* index, Object* value);

  static CppArray* cppNew();

  static CppArray* cppInitializer(std::initializer_list<Object*> initList);
};

#endif  // _ARRAY_H_
