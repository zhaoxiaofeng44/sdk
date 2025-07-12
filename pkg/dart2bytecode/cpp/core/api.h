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
         CppNew(CppPointerArray, cppCtr_, , Int::cppNew(PP_NARG(__VA_ARGS__)), \
                reinterpret_cast<void**>(                                      \
                    new Object* [PP_NARG(__VA_ARGS__)] { __VA_ARGS__ })))

#define CppNewList(...)                                                        \
  CppNew(CppList, cppCtr_fromCppArray,                                         \
         CppNew(CppPointerArray, cppCtr_, Int::cppNew(PP_NARG(__VA_ARGS__)),   \
                reinterpret_cast<void**>(                                      \
                    new Object* [PP_NARG(__VA_ARGS__)] { __VA_ARGS__ })))

#define CppNewSet(...)                                                         \
  CppNew(CppSet, cppCtr_fromCppArray,                                          \
         CppNew(CppPointerArray, cppCtr_, Int::cppNew(PP_NARG(__VA_ARGS__)),   \
                reinterpret_cast<void**>(                                      \
                    new Object* [PP_NARG(__VA_ARGS__)] { __VA_ARGS__ })))
class CppApi {
 public:
  static void** cppCreatePointerArray(Int* length);

  static Object* cppGetPointerArrayItem(void** array, Int* index);

  static void cppSetPointerArrayItem(void** array, Int* index, Object* value);

  static void** cppCreateByteArray(Int* length);

  static Int* cppGetByteArrayItem(void** array, Int* index);

  static void cppSetByteArrayItem(void** array, Int* index, Object* value);

  static String* cppJoinListString(void** array,
                                   Int* length,
                                   String* separator);

  static bool cppBoolValue(Bool* value);

  static bool cppBoolValue(bool value);
};

#endif