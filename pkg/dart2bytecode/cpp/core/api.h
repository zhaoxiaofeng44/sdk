#ifndef CORE_API_H
#define CORE_API_H

#include "./num.h"
#include "./string.h"
#include "./object.h"


#define STATIC_METHOD_FORWARD(cls, meth) \
    template <typename... Args> \
    static auto meth(Args&&... args) -> decltype(cls::meth(std::forward<Args>(args)...)) { \
        return cls::meth(std::forward<Args>(args)...); \
    }

class CppApi {
public:
  static void** cppCreatePointerArray(Int* length);

  static Object* cppGetPointerArrayItem(void** array, Int* index);

  static void cppSetPointerArrayItem(void** array, Int* index, Object* value);

  static void** cppCreateByteArray(Int* length);

  static Int* cppGetByteArrayItem(void** array, Int* index);

  static void cppSetByteArrayItem(void** array, Int* index, Object* value);

  static String* cppJoinListString(void** array, Int* length, String* separator);
};

#endif