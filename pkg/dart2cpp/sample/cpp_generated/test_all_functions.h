#ifndef _TEST_ALL_FUNCTIONS_H_
#define _TEST_ALL_FUNCTIONS_H_

#include "dart2cpp.h"

// 工具宏定义

// 前向声明
Int add(Int a, Int b);
Int subtract(Int a, Int b);
Int calculate(Int a, Int b, ObjectPtr<Function> operation);
ObjectPtr<Function> getAddFunction();
ObjectPtr<Function> createMultiplier(Int factor);
Nullable testAnonymousFunction();
Nullable testFunctionAssignment();
Nullable testFunctionList();


#endif // _TEST_ALL_FUNCTIONS_H_
