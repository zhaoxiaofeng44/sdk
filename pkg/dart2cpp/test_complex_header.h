#ifndef _TEST_COMPLEX_HEADER_H_
#define _TEST_COMPLEX_HEADER_H_

#include "dart2cpp.h"

// 工具宏定义

// 前向声明
class Vector2D;
template<typename T>
class Container;
namespace MathExtension {
  Double sqrt(Double this_);
}
template<typename T, typename R>
namespace LetExtension {
  R let(T this_, ObjectPtr<TypedFunction<std::function<R(T)>, R, T>> block);
Double MathExtension::sqrt(Double _this);
ObjectPtr<TypedFunction<std::function<Double()>, Double>> MathExtension::get_sqrt(Double _this);
template<typename T, typename R, typename _F2>
R LetExtension::let(T _this, ObjectPtr<TypedFunction<_F2, R, T>> block);
ObjectPtr<TypedFunction<std::function<Any(ObjectPtr<TypedFunction<std::function<Any(T)>, Any, T>>)>, Any, ObjectPtr<TypedFunction<std::function<Any(T)>, Any, T>>>> LetExtension::get_let(T _this);
T identity(T value);


#endif // _TEST_COMPLEX_HEADER_H_
