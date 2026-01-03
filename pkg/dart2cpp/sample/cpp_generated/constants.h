#ifndef _CONSTANTS_H_
#define _CONSTANTS_H_

#include "dart2cpp.h"

// 工具宏定义

// 前向声明
class Point;
class Color;
class Rectangle;
class Circle;
class MathConstants;
class PhysicsConstants;
class AppConfig;
class HttpStatus;
class FileTypes;
class Settings;
namespace MathExtension {
  Double sqrt(Double this_);
}; // namespace MathExtension
Nullable testBasicConstants();
Nullable testConstantCollections();
Nullable testConstantConstructors();
Nullable testStaticConstants();
Nullable testCompileTimeExpressions();
Double MathExtension::sqrt(Double _this);
ObjectPtr<TypedFunction<std::function<Double()>, Double>> MathExtension::get_sqrt(Double _this);


#endif // _CONSTANTS_H_
