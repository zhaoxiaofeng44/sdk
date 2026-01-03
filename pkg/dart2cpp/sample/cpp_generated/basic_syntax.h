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
Nullable greet(String name, String title = String(Null));
Nullable createUser(String name = String(Null), Int age = Int(Null), String email = String(Null));
template<typename _F3>
Int calculate(Int a, Int b, ObjectPtr<TypedFunction<_F3, Int, Int, Int>> operation);


#endif // _BASIC_SYNTAX_H_
