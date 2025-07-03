#include "array.h"

// CppArray 类实现 - 简化版本避免编译错误

CppArray* CppArray::cppCtr_(Int* capacity) {
  int len = capacity->getInt();
  Object** newElements = new Object*[len];
  // 对于指针类型，初始化为nullptr
  for (int i = 0; i < len; i++) {
    newElements[i] = nullptr;
  }
  this->length = len;
  this->elements = newElements;
  return this;
}

Int* CppArray::getLength() {
  return Int::cppNew(this->length);
}

void CppArray::setLength(Int* len) {
  int capacity = len->getInt();
  Object** newElements = new Object*[capacity];
  int i = 0;
  for (; i < this->length && i < capacity; i++) {
    newElements[i] = this->elements[i];
  }
  for (; i < capacity; i++) {
    newElements[i] = nullptr;
  }
  if (this->elements) {
    delete[] this->elements;
  }
  this->elements = newElements;
  this->length = capacity;
}

Object* CppArray::getItem(Int* index) {
  return this->elements[index->getInt()];
}

void CppArray::setItem(Int* index, Object* value) {
  this->elements[index->getInt()] = value;
}

CppArray* CppArray::cppNew() {
  CppArray* ptr = new CppArray();
  ptr->elements = nullptr;
  ptr->length = 0;
  return ptr;
}

CppArray* CppArray::cppInitializer(std::initializer_list<Object*> initList) {
  CppArray* array = CppArray::cppNew();
  array->length = static_cast<int>(initList.size());
  array->elements = new Object[array->length];
  int i = 0;
  for (const Object& item : initList) {
    array->elements[i++] = item;
  }
  return array;
}
