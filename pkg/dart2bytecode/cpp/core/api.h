#ifndef CORE_API_H
#define CORE_API_H

#include "./num.h"
#include "./object.h"
#include "./string.h"

#define STATIC_METHOD_FORWARD(cls, meth)                                       \
  template <typename... Args>                                                  \
  static auto meth(Args&&... args)                                             \
      ->decltype(cls::meth(std::forward<Args>(args)...)) {                     \
    return cls::meth(std::forward<Args>(args)...);                             \
  }

#define PP_NARG(...) PP_NARG_(__VA_ARGS__, PP_RSEQ_N())
#define PP_NARG_(...) PP_ARG_N(__VA_ARGS__)
#define PP_ARG_N(_1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12, _13, _14,  \
                 _15, _16, _17, _18, _19, _20, N, ...)                         \
  N
#define PP_RSEQ_N()                                                            \
  20, 19, 18, 17, 16, 15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0

#define CppNew(C, name, ...) C::name(C::cppNew(), __VA_ARGS__)

#define CppNewMap(...)                                                         \
  CppNew(CppMap, cppCtr_fromCppArray,                                          \
         new CppPointerArray(                                                  \
             PP_NARG(__VA_ARGS__),                                             \
             reinterpret_cast<Object**>(                                       \
                 new Object* [PP_NARG(__VA_ARGS__)] { __VA_ARGS__ })))

#define CppNewList(...)                                                        \
  CppNew(CppList, cppCtr_fromCppArray,                                         \
         new CppPointerArray(                                                  \
             PP_NARG(__VA_ARGS__),                                             \
             reinterpret_cast<Object**>(                                       \
                 new Object* [PP_NARG(__VA_ARGS__)] { __VA_ARGS__ })))

#define CppNewSet(...)                                                         \
  CppNew(CppSet, cppCtr_fromCppArray,                                          \
         new CppPointerArray(                                                  \
             PP_NARG(__VA_ARGS__),                                             \
             reinterpret_cast<Object**>(                                       \
                 new Object* [PP_NARG(__VA_ARGS__)] { __VA_ARGS__ })))


class CppUserData : public Object {};
class CppPointerArray : public CppUserData {
 public:
  int length;
  Object** data;

  CppPointerArray(int length) : length(length), data(new Object*[length]) {}
  CppPointerArray(int length, Object** data) : length(length), data(data) {}

  ~CppPointerArray() { delete[] data; }
};

class CppByteArray : public CppUserData {
 public:
  int length;
  uint8_t* data;

  CppByteArray(int length) : length(length), data(new uint8_t[length]) {}
  CppByteArray(int length, uint8_t* data) : length(length), data(data) {}

  ~CppByteArray() { delete[] data; }
};

class CppApi {
 public:
  static CppUserData* cppCreatePointerArray(Int* length);

  static Int* cppGetPointerArrayLength(CppUserData* array);

  static Object* cppGetPointerArrayItem(CppUserData* array, Int* index);

  static void cppSetPointerArrayItem(CppUserData* array,
                                     Int* index,
                                     Object* value);

  static CppUserData* cppCreateByteArray(Int* length);

  static Int* cppGetByteArrayLength(CppUserData* array);

  static Int* cppGetByteArrayItem(CppUserData* array, Int* index);

  static void cppSetByteArrayItem(CppUserData* array, Int* index, Int* value);

  static String* cppJoinListString(CppUserData* array, String* separator);

  static bool cppBoolValue(Bool* value);

  static bool cppBoolValue(bool value);

  static String* getCurrentStackTrace();
};


// 前向声明
template <typename T>
T CppObjectSet(Object* obj, String* name, Object* value) {
  reinterpret_cast<ObjectImp*>(obj)->metas->operator[](name) = value;
  return reinterpret_cast<T>(value);
}

template <typename T>
T CppObjectGet(Object* obj, String* name) {
  return reinterpret_cast<T>(
      reinterpret_cast<ObjectImp*>(obj)->metas->operator[](name));
}

template <typename R, typename... Args>
static R cppApply(Object* thisPtr, String* name, Args... args);


#endif