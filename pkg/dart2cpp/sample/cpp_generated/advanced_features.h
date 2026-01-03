#ifndef _ADVANCED_FEATURES_H_
#define _ADVANCED_FEATURES_H_

#include "dart2cpp.h"

// 工具宏定义

// 前向声明
class Person;
class StringBuilder;
class Calculator;
class Vector;
class Complex;
class Matrix;
class Point;
class UserService;
class DataValidator;
class requiredTag;
class timeout;
class experimental;
namespace StringExtensions {
  String capitalize(String this_);
  Bool isPalindrome(String this_);
  Int wordCount(String this_);
  String reverse(String this_);
}; // namespace StringExtensions
namespace IntExtensions {
  Int factorial(Int this_);
  Bool isPrime(Int this_);
  Int squared(Int this_);
}; // namespace IntExtensions
namespace ListExtensions {
template<typename T>
  T secondOrNull(ObjectPtr<List<T>> this_);
template<typename T>
  T secondLastOrNull(ObjectPtr<List<T>> this_);
template<typename T>
  T random(ObjectPtr<List<T>> this_);
}; // namespace ListExtensions
namespace DateTimeExtensions {
  Bool isToday(ObjectPtr<DateTime> this_);
  String formatDate(ObjectPtr<DateTime> this_);
  ObjectPtr<DateTime> addBusinessDays(ObjectPtr<DateTime> this_, Int days);
}; // namespace DateTimeExtensions
namespace LetExtension {
template<typename T, typename R>
  R let(T this_, ObjectPtr<TypedFunction<std::function<R(T)>, R, T>> block);
}; // namespace LetExtension
namespace MathExtension {
  Double sqrt(Double this_);
}; // namespace MathExtension
Nullable testClosuresAndHigherOrder();
Nullable testCascadeNotation();
Nullable testExtensionMethods();
Nullable testOperatorOverloading();
Nullable testMetadataAnnotations();
Nullable testFunctionalProgramming();
template<typename T, typename R, typename _F2>
R applyTwice(T value, ObjectPtr<TypedFunction<_F2, R, T>> func);
template<typename T, typename R, typename S, typename _F1, typename _F2>
ObjectPtr<TypedFunction<std::function<S(T)>, S, T>> compose(ObjectPtr<TypedFunction<_F1, S, R>> f, ObjectPtr<TypedFunction<_F2, R, T>> g);
template<typename T, typename U, typename R, typename _F1>
ObjectPtr<TypedFunction<std::function<Any(T)>, Any, T>> curry(ObjectPtr<TypedFunction<_F1, R, T, U>> func);
template<typename T>
ObjectPtr<TypedFunction<std::function<Any(T)>, Any, T>> pipe(ObjectPtr<List<ObjectPtr<Function>>> functions);
ObjectPtr<TypedFunction<std::function<Any(U)>, Any, U>> partial(ObjectPtr<TypedFunction<_F1, R, T, U>> func, T first);
ObjectPtr<Function> memoize(ObjectPtr<Function> func);
Int fibonacci(Int n);
ObjectPtr<Iterable<Int>> generateLazy(Int max);


#endif // _ADVANCED_FEATURES_H_
