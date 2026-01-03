#ifndef _HELLO_TEST_ENHANCED_H_
#define _HELLO_TEST_ENHANCED_H_

#include "dart2cpp.h"

// 工具宏定义

// 前向声明
class Person;
class Shape;
class Circle;
class Rectangle;
class Flyable;
class Speakable;
class Bird;
template<typename T>
class Box;
class _Bird_Object_Flyable;
class _Bird_Object_Flyable_Speakable;
Nullable testBasicTypes();
Nullable testControlFlow();
Nullable testEnhancedFunctions();
Nullable testEnhancedCollections();
Nullable testEnhancedClasses();
Nullable testGenerics();
Nullable testExceptions();
Nullable testNullSafety();
T getFirst(ObjectPtr<List<T>> list);
Nullable validateAge(Int age);


#endif // _HELLO_TEST_ENHANCED_H_
