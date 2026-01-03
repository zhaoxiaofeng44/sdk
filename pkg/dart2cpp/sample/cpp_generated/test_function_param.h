#ifndef _TEST_FUNCTION_PARAM_H_
#define _TEST_FUNCTION_PARAM_H_

#include "dart2cpp.h"

// 工具宏定义

// 前向声明
Int add(Int a, Int b);
Int subtract(Int a, Int b);
template<typename _F3>
Int calculate(Int a, Int b, ObjectPtr<TypedFunction<_F3, Int, Int, Int>> operation);


#endif // _TEST_FUNCTION_PARAM_H_
