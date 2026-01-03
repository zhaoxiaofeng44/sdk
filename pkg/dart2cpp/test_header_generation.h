#ifndef _TEST_HEADER_GENERATION_H_
#define _TEST_HEADER_GENERATION_H_

#include "dart2cpp.h"

// 工具宏定义

// 前向声明
class Point;
namespace MathExtension {
  Double sqrt(Double this_);
}
Double MathExtension|sqrt(Double #this);
ObjectPtr<TypedFunction<std::function<Double()>, Double>> MathExtension|get#sqrt(Double #this);
Double calculateDistance(ObjectPtr<Point> a, ObjectPtr<Point> b);


#endif // _TEST_HEADER_GENERATION_H_
