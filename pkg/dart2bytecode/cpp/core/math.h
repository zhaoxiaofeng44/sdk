#ifndef _MATH_H_
#define _MATH_H_

#include <cmath>
#include <random>
#include "num.h"
#include "object.h"

// 全局函数声明 - Int 参数版本
Double* sin(Int* value);
Double* cos(Int* value);
Double* tan(Int* value);
Double* asin(Int* value);
Double* acos(Int* value);
Double* atan(Int* value);
Double* sqrt(Int* value);
Double* pow(Int* base, Int* exponent);
Double* log(Int* value);
Double* exp(Int* value);
Double* ceil(Int* value);
Double* floor(Int* value);
Double* round(Int* value);

// 全局函数声明 - Double 参数版本
Double* sin(Double* value);
Double* cos(Double* value);
Double* tan(Double* value);
Double* asin(Double* value);
Double* acos(Double* value);
Double* atan(Double* value);
Double* sqrt(Double* value);
Double* pow(Double* base, Double* exponent);
Double* log(Double* value);
Double* exp(Double* value);
Double* ceil(Double* value);
Double* floor(Double* value);
Double* round(Int* value);

// 混合参数版本
Double* pow(Int* base, Double* exponent);
Double* pow(Double* base, Int* exponent);

// 比较函数声明
Int* max(Int* a, Int* b);
Double* max(Double* a, Double* b);
Double* max(Int* a, Double* b);
Double* max(Double* a, Int* b);
Int* min(Int* a, Int* b);
Double* min(Double* a, Double* b);
Double* min(Int* a, Double* b);
Double* min(Double* a, Int* b);

// Random 类 - 对应 Dart Random 类
class Random : public Object {
 private:
  std::mt19937 generator;
  std::uniform_real_distribution<double> double_dist;
  std::uniform_int_distribution<int> int_dist;
  std::uniform_int_distribution<int> bool_dist;

 public:
  static Object* cppEpt_(Int* seed);

  // 构造函数 - 对应 Dart Random([int? seed])

  // 构造函数 - 对应 Dart Random.secure()
  static Random* secure();

  // 生成随机整数 - 对应 int nextInt(int max)
  static Int* nextInt(Object* cppThis, Int* max);

  // 生成随机浮点数 - 对应 double nextDouble()
  static Double* nextDouble(Object* cppThis );

  // 生成随机布尔值 - 对应 bool nextBool()
  static Bool* nextBool(Object* cppThis);

  // 静态工厂方法
  static Random* cppNew();
};

#endif  // _MATH_H_
