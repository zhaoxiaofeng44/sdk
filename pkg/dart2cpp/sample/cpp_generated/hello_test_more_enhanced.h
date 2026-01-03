#ifndef _HELLO_TEST_MORE_ENHANCED_H_
#define _HELLO_TEST_MORE_ENHANCED_H_

#include "dart2cpp.h"

// 工具宏定义

// 前向声明
class MorePerson;
class Student;
template<typename T>
class GenericContainer;
class Color;
Nullable testDataTypes();
Nullable testMoreControlFlow();
Nullable testMoreFunctions();
Nullable testMoreCollections();
Nullable testMoreClasses();
Nullable testMoreGenerics();
Nullable testExceptionHandling();
Nullable testNullSafety();
Nullable testAdvancedFeatures();
T getFirstElement(ObjectPtr<List<T>> list);


#endif // _HELLO_TEST_MORE_ENHANCED_H_
