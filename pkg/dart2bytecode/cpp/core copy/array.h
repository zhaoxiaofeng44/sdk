#ifndef CORE_ARRAY_H
#define CORE_ARRAY_H

#include "num.h"
#include "object.h"
#include "string.h"

class CppArray : public Object {
 private:
  Object** data;

 public:
  int length;

  ~CppArray() noexcept override;

  CppArray* cppCtr_initializer(std::initializer_list<Object*> list) noexcept;

  CppArray* cppCtr_(Int* len) noexcept;

  Int* getLength() noexcept;

  void setLength(Int* len) noexcept;

  Object* getItem(Int* index) noexcept;
  void setItem(Int* index, Object* value) noexcept;

  static CppArray* cppNew() noexcept;
};

#endif  // CORE_ARRAY_H
