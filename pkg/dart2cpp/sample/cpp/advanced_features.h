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
  R let(T this_, ObjectPtr<TypedFunction<R, T>> block);
}; // namespace LetExtension
namespace MathExtensions {
  Double sqrt(Double this_);
}; // namespace MathExtensions
Nullable testClosuresAndHigherOrder();
Nullable testCascadeNotation();
Nullable testExtensionMethods();
Nullable testOperatorOverloading();
Nullable testMetadataAnnotations();
Nullable testFunctionalProgramming();
template<typename T, typename R>
R applyTwice(T value, ObjectPtr<TypedFunction<R, T>> func);
template<typename T, typename R, typename S>
ObjectPtr<TypedFunction<S, T>> compose(ObjectPtr<TypedFunction<S, R>> f, ObjectPtr<TypedFunction<R, T>> g);
template<typename T, typename U, typename R>
ObjectPtr<TypedFunction<ObjectPtr<TypedFunction<R, U>>, T>> curry(ObjectPtr<TypedFunction<R, T, U>> func);
template<typename T>
ObjectPtr<TypedFunction<Any, T>> pipe(ObjectPtr<List<ObjectPtr<Function>>> functions);
template<typename T, typename U, typename R>
ObjectPtr<TypedFunction<R, U>> partial(ObjectPtr<TypedFunction<R, T, U>> func, T first);
ObjectPtr<Function> memoize(ObjectPtr<Function> func);
Int fibonacci(Int n);
ObjectPtr<Iterable<Int>> generateLazy(Int max);


#endif // _ADVANCED_FEATURES_H_
