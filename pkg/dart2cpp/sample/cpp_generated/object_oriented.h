#ifndef _OBJECT_ORIENTED_H_
#define _OBJECT_ORIENTED_H_

#include "dart2cpp.h"

// 工具宏定义

// 前向声明
class Person;
class BankAccount;
class Rectangle;
class Animal;
class Dog;
class Cat;
class Employee;
class Drivable;
class Car;
class Bicycle;
class Callable;
class Messageable;
class Smartphone;
class Singing;
class Playing;
class Dancing;
class Painting;
class Performer;
class Musician;
class Dancer;
class Artist;
class Shape;
class Circle;
class RectangleShape;
class Triangle;
class Weekday;
class Color;
class OrderStatus;
class Student;
class Logger;
class Point;
class _Musician_Performer_Singing;
class _Musician_Performer_Singing_Playing;
class _Dancer_Performer_Dancing;
class _Artist_Performer_Singing;
class _Artist_Performer_Singing_Playing;
class _Artist_Performer_Singing_Playing_Dancing;
class _Artist_Performer_Singing_Playing_Dancing_Painting;
namespace MathExtension {
  Double sqrt(Double this_);
}; // namespace MathExtension
Nullable testBasicClasses();
Nullable testInheritance();
Nullable testInterfaces();
Nullable testMixins();
Nullable testAbstractClasses();
Nullable testEnums();
Nullable testConstructors();
Double MathExtension::sqrt(Double _this);
ObjectPtr<TypedFunction<std::function<Double()>, Double>> MathExtension::get_sqrt(Double _this);


#endif // _OBJECT_ORIENTED_H_
