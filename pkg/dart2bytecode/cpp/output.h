#ifndef OUTPUT_H
#define OUTPUT_H

#include <cstdio>
#include <cstdlib>
#include <map>
#include <sstream>
#include "./core/api.h"
#include "./core/func.h"
#include "./core/math.h"
#include "./core/num.h"
#include "./core/string.h"

inline void print(Object* obj) {
  if (obj) {
    // String* str = obj->toString();
    // printf("%s", str->c_str());
    // delete str;
  } else {
    printf("null");
  }
}

inline void print(String* str) {
  if (str) {
    printf("%s", str->c_str());
  } else {
    printf("null");
  }
}

inline void print(char* str) {
  if (str) {
    printf("%s", str);
  }
}

class Uint16List;

inline Int* _getSuggestCapacity(int length) {
  return Int::cppNew(length);
}

inline Int* _getSuggestCapacity(Int* length) {
  return length;
}

template <typename T>
inline Bool* checkNotNullable(T count, String* name) {
  if (count == nullptr) {
    throw "error";
  }
  return Bool::cppNew(true);
}

class CppList;
class _CppListIterator;
class CppSet;
class CppMap;
class CppIterator;
class CppIterable;
class CppMappedIterable;
class CppMappedIterator;
class CppWhereIterable;
class CppWhereIterator;
class CppWhereTypeIterable;
class CppWhereTypeIterator;
class CppExpandIterable;
class CppExpandIterator;
class CppTakeIterable;
class CppTakeIterator;
class CppTakeWhileIterable;
class CppTakeWhileIterator;
class CppSkipIterable;
class CppSkipIterator;
class CppSkipWhileIterable;
class CppSkipWhileIterator;
class CppReversedIterable;
class CppReversedIterator;
class CppFollowedByIterable;
class CppFollowedByIterator;
class CppCastIterable;
class CppCastIterator;
class _CppEmptyIterable;
class _CppEmptyIterator;
class _CppGenerateIterable;
class _CppGenerateIterator;
class _CppUnmodifiableIterable;
class _CppCastFromIterable;
class _CppCastFromIterator;
class CppError;
class CppStackTrace;
class CppStringBuffer;
class Sort;
class NativeFieldWrapperClass1;
class NativeFieldWrapperClass2;
class NativeFieldWrapperClass3;
class NativeFieldWrapperClass4;
class Comparable;
class ArgumentError;
class RangeError;
class IndexError;
class StateError;
class MapEntry;
//  library package:dart2bytecode/demo/collection.dart
class CppIterable {
 public:
  static Object* cppCtr_(Object* cppThis);

  static Bool* cppGet_isEmpty(Object* cppThis);

  static Bool* cppGet_isNotEmpty(Object* cppThis);

  static Object* cppGet_first(Object* cppThis);

  static Object* cppGet_last(Object* cppThis);

  static Object* cppGet_single(Object* cppThis);

  static Object* elementAt(Object* cppThis, Int* index);

  static Bool* contains(Object* cppThis, Object* element);

  static void forEach(Object* cppThis, Function* action);

  static Object* map(Object* cppThis, Function* toElement);

  static Object* where(Object* cppThis, Function* test);

  static Object* whereType(Object* cppThis);

  static Object* expand(Object* cppThis, Function* toElements);

  static Bool* any(Object* cppThis, Function* test);

  static Bool* every(Object* cppThis, Function* test);

  static Object* firstWhere(Object* cppThis, Function* test, Function* orElse);

  static Object* lastWhere(Object* cppThis, Function* test, Function* orElse);

  static Object* singleWhere(Object* cppThis, Function* test, Function* orElse);

  static Object* reduce(Object* cppThis, Function* combine);

  static Object* fold(Object* cppThis, Object* initialValue, Function* combine);

  static String* join(Object* cppThis, String* separator);

  static Object* take(Object* cppThis, Int* count);

  static Object* takeWhile(Object* cppThis, Function* test);

  static Object* skip(Object* cppThis, Int* count);

  static Object* skipWhile(Object* cppThis, Function* test);

  static Object* cppGet_reversed(Object* cppThis);

  static Object* followedBy(Object* cppThis, Object* other);

  static Object* toList(Object* cppThis, Bool* growable);

  static Object* toSet(Object* cppThis);

  static Object* cast(Object* cppThis);

  static Object* empty();

  static Object* generate(Int* count, Function* generator);

  static Object* unmodifiable(Object* elements);

  static Object* castFrom(Object* source);
};
class CppList {
 public:
  static Object* cppCtr_fromCppArray(Object* cppThis, CppPointerArray* array);

  static Object* cppCtr_(Object* cppThis, Int* length, Int* capacity);

  static Object* empty(Bool* growable);

  static Object* filled(Int* length, Object* fill, Bool* growable);

  static Object* from(Object* elements, Bool* growable);

  static Object* of(Object* elements, Bool* growable);

  static Object* generate(Int* length, Function* generator, Bool* growable);

  static Object* unmodifiable(Object* elements);

  static Int* _getSuggestCapacity(Int* newLen);

  static Int* cppGet_length(Object* cppThis);

  static void ensureCapacity(Object* cppThis, Int* newLen);

  static void cppSet_length(Object* cppThis, Int* newLen);

  static Object* cpp_subscript(Object* cppThis, Int* index);

  static void cpp_subscriptAssign(Object* cppThis, Int* index, Object* value);

  static void add(Object* cppThis, Object* value);

  static void addAll(Object* cppThis, Object* iterable);

  static Bool* any(Object* cppThis, Function* test);

  static Object* asMap(Object* cppThis);

  static Object* cast(Object* cppThis);

  static Object* castFrom(Object* source);

  static Object* castFromWithFactory(Object* source, Function* newList);

  static void clear(Object* cppThis);

  static Bool* contains(Object* cppThis, Object* element);

  static Object* elementAt(Object* cppThis, Int* index);

  static Bool* every(Object* cppThis, Function* test);

  static void fillRange(Object* cppThis,
                        Int* start,
                        Int* end,
                        Object* fillValue);

  static Object* firstWhere(Object* cppThis, Function* test, Function* orElse);

  static Object* fold(Object* cppThis, Object* initialValue, Function* combine);

  static void forEach(Object* cppThis, Function* action);

  static Object* getRange(Object* cppThis, Int* start, Int* end);

  static Int* indexOf(Object* cppThis, Object* element, Int* start);

  static Int* indexWhere(Object* cppThis, Function* test, Int* start);

  static void insert(Object* cppThis, Int* index, Object* element);

  static void insertAll(Object* cppThis, Int* index, Object* iterable);

  static Object* cppGet_first(Object* cppThis);

  static void cppSet_first(Object* cppThis, Object* value);

  static Object* cppGet_last(Object* cppThis);

  static void cppSet_last(Object* cppThis, Object* value);

  static Object* cppGet_single(Object* cppThis);

  static Bool* cppGet_isEmpty(Object* cppThis);

  static Bool* cppGet_isNotEmpty(Object* cppThis);

  static Object* cppGet_iterator(Object* cppThis);

  static String* join(Object* cppThis, String* separator);

  static Int* lastIndexOf(Object* cppThis, Object* element, Int* start);

  static Int* lastIndexWhere(Object* cppThis, Function* test, Int* start);

  static Object* lastWhere(Object* cppThis, Function* test, Function* orElse);

  static Object* reduce(Object* cppThis, Function* combine);

  static Bool* remove(Object* cppThis, Object* value);

  static Object* removeAt(Object* cppThis, Int* index);

  static Object* removeLast(Object* cppThis);

  static void removeRange(Object* cppThis, Int* start, Int* end);

  static void removeWhere(Object* cppThis, Function* test);

  static void replaceRange(Object* cppThis,
                           Int* start,
                           Int* end,
                           Object* replacements);

  static void retainWhere(Object* cppThis, Function* test);

  static void setAll(Object* cppThis, Int* index, Object* iterable);

  static void setRange(Object* cppThis,
                       Int* start,
                       Int* end,
                       Object* iterable,
                       Int* skipCount);

  static void shuffle(Object* cppThis, Object* random);

  static void sort(Object* cppThis, Function* compare);

  static void _quickSort(Object* cppThis,
                         Int* low,
                         Int* high,
                         Function* compare);

  static Int* _partition(Object* cppThis,
                         Int* low,
                         Int* high,
                         Function* compare);

  static void _swap(Object* cppThis, Int* i, Int* j);

  static Object* sublist(Object* cppThis, Int* start, Int* end);

  static Object* toList(Object* cppThis, Bool* growable);

  static Object* toSet(Object* cppThis);

  static Object* singleWhere(Object* cppThis, Function* test, Function* orElse);

  static Object* cpp_add(Object* cppThis, Object* other);

  static String* toString(Object* cppThis);

  static Object* cppNew();
};
//  library package:dart2bytecode/demo/collection.dart
class _CppListIterator {
 public:
  static Object* cppCtr_(Object* cppThis, Object* _list);

  static Object* cppGet_current(Object* cppThis);

  static Bool* moveNext(Object* cppThis);

  static Object* cppNew();
};
//  library package:dart2bytecode/demo/collection.dart
class CppSet {
 public:
  static Object* cppCtr_fromCppArray(Object* cppThis, CppPointerArray* array);

  static Object* cppCtr_(Object* cppThis, Int* capacity);

  static Object* identity();

  static Object* from(Object* elements);

  static Object* of(Object* elements);

  static Object* unmodifiable(Object* elements);

  static Object* castFrom(Object* source);

  static Object* castFromWithFactory(Object* source, Function* newSet);

  static Bool* add(Object* cppThis, Object* value);

  static void addAll(Object* cppThis, Object* elements);

  static Object* cast(Object* cppThis);

  static void clear(Object* cppThis);

  static Bool* contains(Object* cppThis, Object* element);

  static Bool* containsAll(Object* cppThis, Object* other);

  static Object* difference(Object* cppThis, Object* other);

  static Object* elementAt(Object* cppThis, Int* index);

  static Object* intersection(Object* cppThis, Object* other);

  static Object* cppGet_first(Object* cppThis);

  static Object* cppGet_last(Object* cppThis);

  static Object* cppGet_single(Object* cppThis);

  static Bool* cppGet_isEmpty(Object* cppThis);

  static Bool* cppGet_isNotEmpty(Object* cppThis);

  static Object* cppGet_iterator(Object* cppThis);

  static Int* cppGet_length(Object* cppThis);

  static Object* lookup(Object* cppThis, Object* element);

  static Bool* remove(Object* cppThis, Object* value);

  static void removeAll(Object* cppThis, Object* elementsToRemove);

  static void removeWhere(Object* cppThis, Function* test);

  static void retainAll(Object* cppThis, Object* elementsToRetain);

  static void retainWhere(Object* cppThis, Function* test);

  static Object* cpp_union(Object* cppThis, Object* other);

  static String* toString(Object* cppThis);

  static Object* cppNew();
};
//  library package:dart2bytecode/demo/collection.dart
class CppMap {
 public:
  static Object* cppCtr_fromCppArray(Object* cppThis, CppPointerArray* array);

  static Object* cppCtr_(Object* cppThis, Int* capacity);

  static Object* identity();

  static Object* from(Object* other);

  static Object* of(Object* other);

  static Object* unmodifiable(Object* other);

  static Object* fromIterable(Object* iterable, Function* key, Function* value);

  static Object* fromIterables(Object* keys, Object* values);

  static Object* fromEntries(Object* entries);

  static Object* cpp_subscript(Object* cppThis, Object* key);

  static void cpp_subscriptAssign(Object* cppThis, Object* key, Object* value);

  static void addAll(Object* cppThis, Object* other);

  static void addEntries(Object* cppThis, Object* entries);

  static Object* cast(Object* cppThis);

  static Object* castFrom(Object* source);

  static Object* castFromWithFactory(Object* source, Function* newMap);

  static void clear(Object* cppThis);

  static Bool* containsKey(Object* cppThis, Object* key);

  static Bool* containsValue(Object* cppThis, Object* value);

  static Object* cppGet_entries(Object* cppThis);

  static void forEach(Object* cppThis, Function* action);

  static Bool* cppGet_isEmpty(Object* cppThis);

  static Bool* cppGet_isNotEmpty(Object* cppThis);

  static Object* cppGet_keys(Object* cppThis);

  static Int* cppGet_length(Object* cppThis);

  static Object* putIfAbsent(Object* cppThis, Object* key, Function* ifAbsent);

  static Object* remove(Object* cppThis, Object* key);

  static void removeWhere(Object* cppThis, Function* test);

  static Object* update(Object* cppThis,
                        Object* key,
                        Function* update,
                        Function* ifAbsent);

  static void updateAll(Object* cppThis, Function* update);

  static Object* cppGet_values(Object* cppThis);

  static Object* map(Object* cppThis, Function* transform);

  static String* toString(Object* cppThis);

  static Object* cppNew();
};
//  library package:dart2bytecode/demo/Iterable.dart
class CppIterator {
 public:
  static Object* cppCtr_(Object* cppThis);
};
//  library package:dart2bytecode/demo/Iterable.dart
//  library package:dart2bytecode/demo/Iterable.dart
class CppMappedIterable {
 public:
  static Object* cppCtr_(Object* cppThis, Object* _source, Function* _f);

  static Object* cppGet_iterator(Object* cppThis);

  static Int* cppGet_length(Object* cppThis);

  static Object* cppNew();
};
//  library package:dart2bytecode/demo/Iterable.dart
class CppMappedIterator {
 public:
  static Object* cppCtr_(Object* cppThis, Object* _iterator, Function* _f);

  static Object* cppGet_current(Object* cppThis);

  static Bool* moveNext(Object* cppThis);

  static Object* cppNew();
};
//  library package:dart2bytecode/demo/Iterable.dart
class CppWhereIterable {
 public:
  static Object* cppCtr_(Object* cppThis, Object* _source, Function* _test);

  static Object* cppGet_iterator(Object* cppThis);

  static Int* cppGet_length(Object* cppThis);

  static Object* cppNew();
};
//  library package:dart2bytecode/demo/Iterable.dart
class CppWhereIterator {
 public:
  static Object* cppCtr_(Object* cppThis, Object* _iterator, Function* _test);

  static Object* cppGet_current(Object* cppThis);

  static Bool* moveNext(Object* cppThis);

  static Object* cppNew();
};
//  library package:dart2bytecode/demo/Iterable.dart
class CppWhereTypeIterable {
 public:
  static Object* cppCtr_(Object* cppThis, Object* _source);

  static Object* cppGet_iterator(Object* cppThis);

  static Int* cppGet_length(Object* cppThis);

  static Object* cppNew();
};
//  library package:dart2bytecode/demo/Iterable.dart
class CppWhereTypeIterator {
 public:
  static Object* cppCtr_(Object* cppThis, Object* _iterator);

  static Object* cppGet_current(Object* cppThis);

  static Bool* moveNext(Object* cppThis);

  static Object* cppNew();
};
//  library package:dart2bytecode/demo/Iterable.dart
class CppExpandIterable {
 public:
  static Object* cppCtr_(Object* cppThis, Object* _source, Function* _f);

  static Object* cppGet_iterator(Object* cppThis);

  static Int* cppGet_length(Object* cppThis);

  static Object* cppNew();
};
//  library package:dart2bytecode/demo/Iterable.dart
class CppExpandIterator {
 public:
  static Object* cppCtr_(Object* cppThis, Object* _iterator, Function* _f);

  static Object* cppGet_current(Object* cppThis);

  static Bool* moveNext(Object* cppThis);

  static Object* cppNew();
};
//  library package:dart2bytecode/demo/Iterable.dart
class CppTakeIterable {
 public:
  static Object* cppCtr_(Object* cppThis, Object* _source, Int* _count);

  static Object* cppGet_iterator(Object* cppThis);

  static Int* cppGet_length(Object* cppThis);

  static Object* cppNew();
};
//  library package:dart2bytecode/demo/Iterable.dart
class CppTakeIterator {
 public:
  static Object* cppCtr_(Object* cppThis, Object* _iterator, Int* _count);

  static Object* cppGet_current(Object* cppThis);

  static Bool* moveNext(Object* cppThis);

  static Object* cppNew();
};
//  library package:dart2bytecode/demo/Iterable.dart
class CppTakeWhileIterable {
 public:
  static Object* cppCtr_(Object* cppThis, Object* _source, Function* _test);

  static Object* cppGet_iterator(Object* cppThis);

  static Int* cppGet_length(Object* cppThis);

  static Object* cppNew();
};
//  library package:dart2bytecode/demo/Iterable.dart
class CppTakeWhileIterator {
 public:
  static Object* cppCtr_(Object* cppThis, Object* _iterator, Function* _test);

  static Object* cppGet_current(Object* cppThis);

  static Bool* moveNext(Object* cppThis);

  static Object* cppNew();
};
//  library package:dart2bytecode/demo/Iterable.dart
class CppSkipIterable {
 public:
  static Object* cppCtr_(Object* cppThis, Object* _source, Int* _count);

  static Object* cppGet_iterator(Object* cppThis);

  static Int* cppGet_length(Object* cppThis);

  static Object* cppNew();
};
//  library package:dart2bytecode/demo/Iterable.dart
class CppSkipIterator {
 public:
  static Object* cppCtr_(Object* cppThis, Object* _iterator, Int* _count);

  static Object* cppGet_current(Object* cppThis);

  static Bool* moveNext(Object* cppThis);

  static Object* cppNew();
};
//  library package:dart2bytecode/demo/Iterable.dart
class CppSkipWhileIterable {
 public:
  static Object* cppCtr_(Object* cppThis, Object* _source, Function* _test);

  static Object* cppGet_iterator(Object* cppThis);

  static Int* cppGet_length(Object* cppThis);

  static Object* cppNew();
};
//  library package:dart2bytecode/demo/Iterable.dart
class CppSkipWhileIterator {
 public:
  static Object* cppCtr_(Object* cppThis, Object* _iterator, Function* _test);

  static Object* cppGet_current(Object* cppThis);

  static Bool* moveNext(Object* cppThis);

  static Object* cppNew();
};
//  library package:dart2bytecode/demo/Iterable.dart
class CppReversedIterable {
 public:
  static Object* cppCtr_(Object* cppThis, Object* _source);

  static Object* cppGet_iterator(Object* cppThis);

  static Int* cppGet_length(Object* cppThis);

  static Object* cppNew();
};
//  library package:dart2bytecode/demo/Iterable.dart
class CppReversedIterator {
 public:
  static Object* cppCtr_(Object* cppThis, Object* source);

  static Object* cppGet_current(Object* cppThis);

  static Bool* moveNext(Object* cppThis);

  static Object* cppNew();
};
//  library package:dart2bytecode/demo/Iterable.dart
class CppFollowedByIterable {
 public:
  static Object* cppCtr_(Object* cppThis, Object* _first, Object* _second);

  static Object* cppGet_iterator(Object* cppThis);

  static Int* cppGet_length(Object* cppThis);

  static Object* cppNew();
};
//  library package:dart2bytecode/demo/Iterable.dart
class CppFollowedByIterator {
 public:
  static Object* cppCtr_(Object* cppThis, Object* _first, Object* _second);

  static Object* cppGet_current(Object* cppThis);

  static Bool* moveNext(Object* cppThis);

  static Object* cppNew();
};
//  library package:dart2bytecode/demo/Iterable.dart
class CppCastIterable {
 public:
  static Object* cppCtr_(Object* cppThis, Object* _source);

  static Object* cppGet_iterator(Object* cppThis);

  static Int* cppGet_length(Object* cppThis);

  static Object* cppNew();
};
//  library package:dart2bytecode/demo/Iterable.dart
class CppCastIterator {
 public:
  static Object* cppCtr_(Object* cppThis, Object* _iterator);

  static Object* cppGet_current(Object* cppThis);

  static Bool* moveNext(Object* cppThis);

  static Object* cppNew();
};
//  library package:dart2bytecode/demo/Iterable.dart
class _CppEmptyIterable {
 public:
  static Object* cppCtr_(Object* cppThis);

  static Object* cppGet_iterator(Object* cppThis);

  static Int* cppGet_length(Object* cppThis);

  static Object* cppNew();
};
//  library package:dart2bytecode/demo/Iterable.dart
class _CppEmptyIterator {
 public:
  static Object* cppCtr_(Object* cppThis);

  static Object* cppGet_current(Object* cppThis);

  static Bool* moveNext(Object* cppThis);

  static Object* cppNew();
};
//  library package:dart2bytecode/demo/Iterable.dart
class _CppGenerateIterable {
 public:
  static Object* cppCtr_(Object* cppThis, Int* _count, Function* _generator);

  static Object* cppGet_iterator(Object* cppThis);

  static Int* cppGet_length(Object* cppThis);

  static Object* cppNew();
};
//  library package:dart2bytecode/demo/Iterable.dart
class _CppGenerateIterator {
 public:
  static Object* cppCtr_(Object* cppThis, Int* _count, Function* _generator);

  static Object* cppGet_current(Object* cppThis);

  static Bool* moveNext(Object* cppThis);

  static Object* cppNew();
};
//  library package:dart2bytecode/demo/Iterable.dart
class _CppUnmodifiableIterable {
 public:
  static Object* cppCtr_(Object* cppThis, Object* _elements);

  static Object* cppGet_iterator(Object* cppThis);

  static Int* cppGet_length(Object* cppThis);

  static Object* cppNew();
};
//  library package:dart2bytecode/demo/Iterable.dart
class _CppCastFromIterable {
 public:
  static Object* cppCtr_(Object* cppThis, Object* _source);

  static Object* cppGet_iterator(Object* cppThis);

  static Int* cppGet_length(Object* cppThis);

  static Object* cppNew();
};
//  library package:dart2bytecode/demo/Iterable.dart
class _CppCastFromIterator {
 public:
  static Object* cppCtr_(Object* cppThis, Object* _iterator);

  static Object* cppGet_current(Object* cppThis);

  static Bool* moveNext(Object* cppThis);

  static Object* cppNew();
};
//  library package:dart2bytecode/demo/error.dart
class CppError {
 public:
  static Object* cppCtr_(Object* cppThis);

  static String* safeToString(Object* object);

  static Object* cppGet_stackTrace(Object* cppThis);

  static Object* cppGet__stackTrace(Object* cppThis);

  static void cppSet__stackTrace(Object* cppThis, Object* value);

  static Object* cppNew();
};
//  library package:dart2bytecode/demo/error.dart
class CppStackTrace {
 public:
  static Object* _current;
  static Object* cppCtr_(Object* cppThis);

  static Object* cppGet_current();

  static String* toString(Object* cppThis);

  static Object* cppNew();
};
//  library package:dart2bytecode/demo/string.dart
class CppStringBuffer {
 public:
  static Object* cppCtr_(Object* cppThis, Object* content);

  static void write(Object* cppThis, Object* obj);

  static void writeAll(Object* cppThis, Object* objects, String* separator);

  static void writeCharCode(Object* cppThis, Int* charCode);

  static void writeln(Object* cppThis, Object* obj);

  static void clear(Object* cppThis);

  static String* toString(Object* cppThis);

  static Int* cppGet_length(Object* cppThis);

  static Bool* cppGet_isEmpty(Object* cppThis);

  static Bool* cppGet_isNotEmpty(Object* cppThis);

  static Object* cppGet__parts(Object* cppThis);

  static void cppSet__parts(Object* cppThis, Object* value);

  static Int* cppGet__partsCodeUnits(Object* cppThis);

  static void cppSet__partsCodeUnits(Object* cppThis, Int* value);

  static Int* cppGet__partsCompactionIndex(Object* cppThis);

  static void cppSet__partsCompactionIndex(Object* cppThis, Int* value);

  static Int* cppGet__partsCodeUnitsSinceCompaction(Object* cppThis);

  static void cppSet__partsCodeUnitsSinceCompaction(Object* cppThis,
                                                    Int* value);

  static Object* cppGet__buffer(Object* cppThis);

  static void cppSet__buffer(Object* cppThis, Object* value);

  static Int* cppGet__bufferPosition(Object* cppThis);

  static void cppSet__bufferPosition(Object* cppThis, Int* value);

  static Int* cppGet__bufferCodeUnitMagnitude(Object* cppThis);

  static void cppSet__bufferCodeUnitMagnitude(Object* cppThis, Int* value);

  static void _writeString(Object* cppThis, String* str);

  static void _ensureCapacity(Object* cppThis, Int* n);

  static void _consumeBuffer(Object* cppThis);

  static void _addPart(Object* cppThis, String* str);

  static void _compact(Object* cppThis);

  static Object* cppNew();
};
//  dart._internal
class Sort {
 public:
  static Int* _INSERTION_SORT_THRESHOLD;
  static Object* cppCtr_(Object* cppThis);

  static void sort(Object* a, Function* compare);

  static void sortRange(Object* a, Int* from, Int* to, Function* compare);

  static void _doSort(Object* a, Int* left, Int* right, Function* compare);

  static void _insertionSort(Object* a,
                             Int* left,
                             Int* right,
                             Function* compare);

  static void _dualPivotQuicksort(Object* a,
                                  Int* left,
                                  Int* right,
                                  Function* compare);

  static Object* cppNew();
};
//  nativewrappers
class NativeFieldWrapperClass1 {
 public:
  static Object* cppCtr_(Object* cppThis);

  static Object* cppNew();
};
//  nativewrappers
class NativeFieldWrapperClass2 {
 public:
  static Object* cppCtr_(Object* cppThis);

  static Object* cppNew();
};
//  nativewrappers
class NativeFieldWrapperClass3 {
 public:
  static Object* cppCtr_(Object* cppThis);

  static Object* cppNew();
};
//  nativewrappers
class NativeFieldWrapperClass4 {
 public:
  static Object* cppCtr_(Object* cppThis);

  static Object* cppNew();
};
//  dart.core
class Comparable {
 public:
  static Object* cppCtr_(Object* cppThis);

  static Int* compare(Object* a, Object* b);
};
//  dart.core
class ArgumentError {
 public:
  static Object* cppCtr_(Object* cppThis, Object* message, String* name);

  static Object* cppCtr_value(Object* cppThis,
                              Object* value,
                              String* name,
                              Object* message);

  static Object* cppCtr_notNull(Object* cppThis, String* name);

  static Object* checkNotNull(Object* argument, String* name);

  static String* cppGet__errorName(Object* cppThis);

  static String* cppGet__errorExplanation(Object* cppThis);

  static String* toString(Object* cppThis);

  static Object* cppNew();
};
//  dart.core
class RangeError {
 public:
  static Object* cppCtr_(Object* cppThis, Object* message);

  static Object* cppCtr_value(Object* cppThis,
                              Num* value,
                              String* name,
                              String* message);

  static Object* cppCtr_range(Object* cppThis,
                              Num* invalidValue,
                              Int* minValue,
                              Int* maxValue,
                              String* name,
                              String* message);

  static Num* cppGet_invalidValue(Object* cppThis);

  static Object* index(Int* index,
                       Object* indexable,
                       String* name,
                       String* message,
                       Int* length);

  static Int* checkValueInInterval(Int* value,
                                   Int* minValue,
                                   Int* maxValue,
                                   String* name,
                                   String* message);

  static Int* checkValidIndex(Int* index,
                              Object* indexable,
                              String* name,
                              Int* length,
                              String* message);

  static Int* checkValidRange(Int* start,
                              Int* end,
                              Int* length,
                              String* startName,
                              String* endName,
                              String* message);

  static Int* checkNotNegative(Int* value, String* name, String* message);

  static String* cppGet__errorName(Object* cppThis);

  static String* cppGet__errorExplanation(Object* cppThis);

  static Object* cppNew();
};
//  dart.core
class IndexError {
 public:
  static Object* cppCtr_(Object* cppThis,
                         Int* invalidValue,
                         Object* indexable,
                         String* name,
                         String* message,
                         Int* length);

  static Object* cppCtr_withLength(Object* cppThis,
                                   Int* invalidValue,
                                   Int* length,
                                   Object* indexable,
                                   String* name,
                                   String* message);

  static Int* cppGet_invalidValue(Object* cppThis);

  static Int* check(Int* index,
                    Int* length,
                    Object* indexable,
                    String* name,
                    String* message);

  static Int* cppGet_start(Object* cppThis);

  static Int* cppGet_end(Object* cppThis);

  static String* cppGet__errorName(Object* cppThis);

  static String* cppGet__errorExplanation(Object* cppThis);

  static Object* cppNew();
};
//  dart.core
class StateError {
 public:
  static Object* cppCtr_(Object* cppThis, String* message);

  static void _throwNew(String* msg);

  static String* toString(Object* cppThis);

  static Object* cppNew();
};
//  dart.core
class MapEntry {
 public:
  static Object* cppCtr__(Object* cppThis, Object* key, Object* value);

  static Object* cppEpt_(Object* key, Object* value);

  static String* toString(Object* cppThis);

  static Object* cppNew();
};

#endif