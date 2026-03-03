#ifndef _GENERICS_H_
#define _GENERICS_H_

#include "dart2cpp.h"

// 工具宏定义

// 前向声明
template<typename T>
class Box;
template<typename T, typename U>
class Pair;
class NumberContainer;
class ContainerFactory;
class NumberCalculator;
class Comparator;
class Serializable;
class Serializer;
class CollectionProcessor;
class AdvancedProcessor;
class GenericList;
class GenericStack;
class GenericQueue;
template<typename K, typename V>
class GenericMap;
class BinaryTree;
class TreeNode;
class Animal;
class Dog;
class Cat;
class AnimalProcessor;
class Producer;
class Consumer;
class DogProducer;
class AnimalConsumer;
class Person;
class Student;
class Repository;
class StringRepository;
class IntRepository;
template<typename T, typename R>
class Converter;
class StringToIntConverter;
class IntToStringConverter;
class Validator;
class EmailValidator;
class AgeValidator;
Nullable testGenericClasses();
Nullable testGenericMethods();
Nullable testTypeConstraints();
Nullable testGenericCollections();
Nullable testVariance();
Nullable testGenericInterfaces();
template<typename T>
T identity(T value);
template<typename T>
ObjectPtr<Pair<T, T>> swap(T a, T b);
template<typename T>
T getFirst(ObjectPtr<List<T>> list);
template<typename T, typename R>
ObjectPtr<List<R>> mapList(ObjectPtr<List<T>> list, ObjectPtr<TypedFunction<R, T>> mapper);
template<typename T>
ObjectPtr<List<T>> filterList(ObjectPtr<List<T>> list, ObjectPtr<TypedFunction<Bool, T>> predicate);
template<typename T>
T reduceList(ObjectPtr<List<T>> list, ObjectPtr<TypedFunction<T, T, T>> reducer);
Nullable processAnimals(ObjectPtr<List<ObjectPtr<Animal>>> animals);


#endif // _GENERICS_H_
