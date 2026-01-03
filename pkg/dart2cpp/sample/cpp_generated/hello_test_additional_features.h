#ifndef _HELLO_TEST_ADDITIONAL_FEATURES_H_
#define _HELLO_TEST_ADDITIONAL_FEATURES_H_

#include "dart2cpp.h"

// 工具宏定义

// 前向声明
class AdditionalPerson;
class AdditionalStudent;
template<typename T>
class GenericHolder;
Nullable testDataTypes();
Nullable testAdditionalControlFlow();
Nullable testAdditionalFunctions();
Nullable testAdditionalCollections();
Nullable testAdditionalClasses();
Nullable testAdditionalGenerics();
Nullable testSimpleExceptionHandling();
Nullable testSimpleNullSafety();
T getFirst(ObjectPtr<List<T>> list);


#endif // _HELLO_TEST_ADDITIONAL_FEATURES_H_
