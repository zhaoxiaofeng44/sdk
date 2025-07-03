#include "array.h"
#include <cstddef>

CppArray::~CppArray() noexcept {
  if (data) {
    delete[] data;
    data = nullptr;
  }
}

Object* CppArray::get(Int* index) noexcept {
  if (index != nullptr && (index->value < 0 || index->value >= length)) {
    return nullptr;
  }
  return data[index->value];
}

void CppArray::set(Int* index, Object* value) noexcept {
  if (index != nullptr && (index->value < 0 || index->value >= length)) {
    return;
  }
  data[index->value] = value;
}

CppArray* CppArray::cppCtr_initializer(
    std::initializer_list<Object*> list) noexcept {
  this->length = list.size();
  this->data = new Object*[this->length];
  for (int i = 0; i < this->length; i++) {
    this->data[i] = list[i];
  }
  return this;
}

CppArray* CppArray::cppCtr_(Int* len) noexcept {
  this->length = len->value;
  this->data = new Object*[this->length];
  for (int i = 0; i < this->length; i++) {
    this->data[i] = nullptr;
  }
  return this;
}

CppArray* CppArray::cppNew() noexcept {
  auto ptr = (CppArray*)malloc(sizeof(CppArray));
  return ptr;
}

Int* CppArray::getLength() noexcept {
  return Int::cppNew(length);
}

void CppArray::setLength(Int* len) noexcept {
  this->length = len->value;
  int capacity = len->getInt();
  Object* newElements = new Object[capacity];
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