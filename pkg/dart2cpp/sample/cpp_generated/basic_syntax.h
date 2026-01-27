#ifndef _BASIC_SYNTAX_H_
#define _BASIC_SYNTAX_H_

#include "dart2cpp.h"

// 工具宏定义

// 前向声明
Nullable testBasicTypes();
Nullable testVariableDeclarations();
Nullable testOperators();
Nullable testControlFlow();
Nullable testStringOperations();
Nullable testFunctions();
Int add(Int a, Int b);
Int subtract(Int a, Int b);
Nullable greet(String name, String title);
Nullable createUser(String name, Int age, String email);
Int calculate(Int a, Int b, ObjectPtr<TypedFunction<Int, Int, Int>> operation);


#endif // _BASIC_SYNTAX_H_
