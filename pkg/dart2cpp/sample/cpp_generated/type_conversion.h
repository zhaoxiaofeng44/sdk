#ifndef _TYPE_CONVERSION_H_
#define _TYPE_CONVERSION_H_

#include "dart2cpp.h"

// 工具宏定义

// 前向声明
class Animal;
class Dog;
class Cat;
class City;
class Address;
class Person;
template<typename T>
class NumberProcessor;
Nullable testAsExpressions();
Nullable testIsTypeChecks();
Nullable testTypeConversionMethods();
Nullable testNullSafetyConversions();
Nullable testDynamicTypeHandling();
Nullable testGenericTypeConversions();
ObjectPtr<List<T>> createList(T first, T second);


#endif // _TYPE_CONVERSION_H_
