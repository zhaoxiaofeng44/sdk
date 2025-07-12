#include <cstdio>
#include <cstdlib>
#include <map>
#include <sstream>
#include "./core/api.h"
#include "./core/array.h"
#include "./core/func.h"
#include "./core/num.h"
#include "./core/string.h"

void print(Object* obj) {
  if (obj) {
    // String* str = obj->toString();
    // printf("%s", str->c_str());
    // delete str;
  } else {
    printf("null");
  }
}

void print(String* str) {
  if (str) {
    printf("%s", str->c_str());
  } else {
    printf("null");
  }
}

void print(char* str) {
  if (str) {
    printf("%s", str);
  }
}

class Uint16List;

Int* _getSuggestCapacity(int length) {
  return Int::cppNew(length);
}

Int* _getSuggestCapacity(Int* length) {
  return length;
}

template <typename T>
Bool* checkNotNullable(T count, String* name) {
  if (count == nullptr) {
    throw "error";
  }
  return Bool::cppNew(true);
}

class CyBase;
class CyFather;
class CyChild;
class CyComplexTest;
class CppPointerArray;
class CppByteArray;
class CppList;
class _CppListIterator;
class CppSet;
class CppMap;
class CppStringBuffer;
class CppWasmMap;
class Sort;
class Random;
class NativeFieldWrapperClass1;
class NativeFieldWrapperClass2;
class NativeFieldWrapperClass3;
class NativeFieldWrapperClass4;
class Comparable;
class RangeError;
class Iterable;
class Iterator;
class List;
class Map;
class MapEntry;
class Set;
class StackTrace;
class StringBuffer;
//  library file:///Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/test/hello.dart
class CyBase {
 public:
  static Object* cppCtr_(Object* cppThis, Int* c);

  static void test(Object* cppThis);

  static Object* cppNew();
};
//  library file:///Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/test/hello.dart
class CyFather {
 public:
  static Object* cppCtr_(Object* cppThis);

  static Object* cppCtr_ee(Object* cppThis);

  static void myTest(Object* cppThis);

  static Object* cppNew();
};
//  library file:///Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/test/hello.dart
class CyChild {
 public:
  static Object* cppCtr_(Object* cppThis);

  static void myTest(Object* cppThis);

  static Object* cppNew();
};
//  library file:///Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/test/hello.dart
class CyComplexTest {
 public:
  static Object* cppCtr_(Object* cppThis);

  static void testConditionals(Object* cppThis);

  static void testSwitch(Object* cppThis, Int* value);

  static void testLoops(Object* cppThis);

  static void testmain(Object* cppThis);

  static Object* cppNew();
};
//  library file:///Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/test/list.dart
class CppPointerArray {
 public:
  static Object* cppCtr_(Object* cppThis, Int* _length, void** data);

  static Int* cppGet_length(Object* cppThis);

  static Object* getItem(Object* cppThis, Int* index);

  static void setItem(Object* cppThis, Int* index, Object* value);

  STATIC_METHOD_FORWARD(CppApi, cppCreatePointerArray)

  STATIC_METHOD_FORWARD(CppApi, cppGetPointerArrayItem)

  STATIC_METHOD_FORWARD(CppApi, cppSetPointerArrayItem)

  static Object* cppNew();
};
//  library file:///Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/test/list.dart
class CppByteArray {
 public:
  static Object* cppCtr_(Object* cppThis, Int* _length, void** data);

  static Int* cppGet_length(Object* cppThis);

  static Int* getItem(Object* cppThis, Int* index);

  static void setItem(Object* cppThis, Int* index, Int* value);

  STATIC_METHOD_FORWARD(CppApi, cppCreateByteArray)

  STATIC_METHOD_FORWARD(CppApi, cppGetByteArrayItem)

  STATIC_METHOD_FORWARD(CppApi, cppSetByteArrayItem)

  static Object* cppNew();
};
//  library file:///Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/test/list.dart
class Iterable {
 public:
  static Object* cppCtr_(Object* cppThis);

  static Object* generate(Int* count, Function* generator);

  static Object* withIterator(Function* iteratorFactory);

  static Object* empty();

  static Object* castFrom(Object* source);

  static Object* cast(Object* cppThis);

  static Object* followedBy(Object* cppThis, Object* other);

  static Object* map(Object* cppThis, Function* toElement);

  static Object* where(Object* cppThis, Function* test);

  static Object* whereType(Object* cppThis);

  static Object* expand(Object* cppThis, Function* toElements);

  static Bool* contains(Object* cppThis, Object* element);

  static void forEach(Object* cppThis, Function* action);

  static Object* reduce(Object* cppThis, Function* combine);

  static Object* fold(Object* cppThis, Object* initialValue, Function* combine);

  static Bool* every(Object* cppThis, Function* test);

  static String* join(Object* cppThis, String* separator);

  static Bool* any(Object* cppThis, Function* test);

  static Object* toList(Object* cppThis, Bool* growable);

  static Object* toSet(Object* cppThis);

  static Int* cppGet_length(Object* cppThis);

  static Bool* cppGet_isEmpty(Object* cppThis);

  static Bool* cppGet_isNotEmpty(Object* cppThis);

  static Object* take(Object* cppThis, Int* count);

  static Object* takeWhile(Object* cppThis, Function* test);

  static Object* skip(Object* cppThis, Int* count);

  static Object* skipWhile(Object* cppThis, Function* test);

  static Object* cppGet_first(Object* cppThis);

  static Object* cppGet_last(Object* cppThis);

  static Object* cppGet_single(Object* cppThis);

  static Object* firstWhere(Object* cppThis, Function* test, Function* orElse);

  static Object* lastWhere(Object* cppThis, Function* test, Function* orElse);

  static Object* singleWhere(Object* cppThis, Function* test, Function* orElse);

  static Object* elementAt(Object* cppThis, Int* index);

  static String* toString(Object* cppThis);

  static String* iterableToShortString(Object* iterable,
                                       String* leftDelimiter,
                                       String* rightDelimiter);

  static String* iterableToFullString(Object* iterable,
                                      String* leftDelimiter,
                                      String* rightDelimiter);

  static Object* cppNew();
};
class EfficientLengthIterable {
 public:
  static Object* cppCtr_(Object* cppThis);

  static Object* cppNew();
};
class HideEfficientLengthIterable {
 public:
  static Object* cppCtr_(Object* cppThis);

  static Object* cppNew();
};
class _ListIterable {
 public:
  static Object* cppCtr_(Object* cppThis);

  static Object* cppNew();
};
class List {
 public:
  static Object* filled(Int* length, Object* fill, Bool* growable);

  static Object* empty(Bool* growable);

  static Object* from(Object* elements, Bool* growable);

  static Object* of(Object* elements, Bool* growable);

  static Object* generate(Int* length, Function* generator, Bool* growable);

  static Object* unmodifiable(Object* elements);

  static Object* castFrom(Object* source);

  static void copyRange(Object* target,
                        Int* at,
                        Object* source,
                        Int* start,
                        Int* end);

  static void writeIterable(Object* target, Int* at, Object* source);

  static Object* cppNew();
};
class CppList {
 public:
  static Object* cppCtr_fromCppArray(Object* cppThis, Object* array);

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

  static void clear(Object* cppThis);

  static Bool* contains(Object* cppThis, Object* element);

  static Object* elementAt(Object* cppThis, Int* index);

  static Bool* every(Object* cppThis, Function* test);

  static Object* expand(Object* cppThis, Function* toElements);

  static void fillRange(Object* cppThis,
                        Int* start,
                        Int* end,
                        Object* fillValue);

  static Object* firstWhere(Object* cppThis, Function* test, Function* orElse);

  static Object* fold(Object* cppThis, Object* initialValue, Function* combine);

  static Object* followedBy(Object* cppThis, Object* other);

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

  STATIC_METHOD_FORWARD(CppApi, cppJoinListString)

  static Int* lastIndexOf(Object* cppThis, Object* element, Int* start);

  static Int* lastIndexWhere(Object* cppThis, Function* test, Int* start);

  static Object* lastWhere(Object* cppThis, Function* test, Function* orElse);

  static Object* map(Object* cppThis, Function* toElement);

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

  static Object* cppGet_reversed(Object* cppThis);

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

  static Object* take(Object* cppThis, Int* count);

  static Object* takeWhile(Object* cppThis, Function* test);

  static Object* toList(Object* cppThis, Bool* growable);

  static Object* toSet(Object* cppThis);

  static Object* where(Object* cppThis, Function* test);

  static Object* whereType(Object* cppThis);

  static Object* singleWhere(Object* cppThis, Function* test, Function* orElse);

  static Object* skip(Object* cppThis, Int* count);

  static Object* skipWhile(Object* cppThis, Function* test);

  static Object* cpp_add(Object* cppThis, Object* other);

  static String* toString(Object* cppThis);

  static Object* cppNew();
};
//  library file:///Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/test/list.dart
class Iterator {
 public:
  static Object* cppCtr_(Object* cppThis);

  static Object* cppNew();
};
class _CppListIterator {
 public:
  static Object* cppCtr_(Object* cppThis, Object* _list);

  static Object* cppGet_current(Object* cppThis);

  static Bool* moveNext(Object* cppThis);

  static Object* cppNew();
};
//  library file:///Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/test/list.dart
class _SetIterable {
 public:
  static Object* cppCtr_(Object* cppThis);

  static Object* cppNew();
};
class Set {
 public:
  static Object* cppEpt_();

  static Object* identity();

  static Object* from(Object* elements);

  static Object* of(Object* elements);

  static Object* unmodifiable(Object* elements);

  static Object* castFrom(Object* source, Function* newSet);

  static Object* cppNew();
};
class CppSet {
 public:
  static Object* cppCtr_fromCppArray(Object* cppThis, Object* array);

  static Object* cppCtr_(Object* cppThis, Int* capacity);

  static Object* identity();

  static Object* from(Object* elements);

  static Object* of(Object* elements);

  static Object* unmodifiable(Object* elements);

  static Bool* add(Object* cppThis, Object* value);

  static void addAll(Object* cppThis, Object* elements);

  static Bool* any(Object* cppThis, Function* test);

  static Object* cast(Object* cppThis);

  static void clear(Object* cppThis);

  static Bool* contains(Object* cppThis, Object* element);

  static Bool* containsAll(Object* cppThis, Object* other);

  static Object* difference(Object* cppThis, Object* other);

  static Object* elementAt(Object* cppThis, Int* index);

  static Bool* every(Object* cppThis, Function* test);

  static Object* expand(Object* cppThis, Function* toElements);

  static Object* firstWhere(Object* cppThis, Function* test, Function* orElse);

  static Object* fold(Object* cppThis, Object* initialValue, Function* combine);

  static Object* followedBy(Object* cppThis, Object* other);

  static void forEach(Object* cppThis, Function* action);

  static Object* intersection(Object* cppThis, Object* other);

  static Object* cppGet_first(Object* cppThis);

  static Object* cppGet_last(Object* cppThis);

  static Object* cppGet_single(Object* cppThis);

  static Bool* cppGet_isEmpty(Object* cppThis);

  static Bool* cppGet_isNotEmpty(Object* cppThis);

  static Object* cppGet_iterator(Object* cppThis);

  static String* join(Object* cppThis, String* separator);

  static Object* lastWhere(Object* cppThis, Function* test, Function* orElse);

  static Int* cppGet_length(Object* cppThis);

  static Object* lookup(Object* cppThis, Object* element);

  static Object* map(Object* cppThis, Function* toElement);

  static Object* reduce(Object* cppThis, Function* combine);

  static Bool* remove(Object* cppThis, Object* value);

  static void removeAll(Object* cppThis, Object* elementsToRemove);

  static void removeWhere(Object* cppThis, Function* test);

  static void retainAll(Object* cppThis, Object* elementsToRetain);

  static void retainWhere(Object* cppThis, Function* test);

  static Object* singleWhere(Object* cppThis, Function* test, Function* orElse);

  static Object* skip(Object* cppThis, Int* count);

  static Object* skipWhile(Object* cppThis, Function* test);

  static Object* cpp_union(Object* cppThis, Object* other);

  static Object* take(Object* cppThis, Int* count);

  static Object* takeWhile(Object* cppThis, Function* test);

  static Object* toList(Object* cppThis, Bool* growable);

  static Object* toSet(Object* cppThis);

  static Object* where(Object* cppThis, Function* test);

  static Object* whereType(Object* cppThis);

  static String* toString(Object* cppThis);

  static Object* cppNew();
};
//  library file:///Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/test/list.dart
class Map {
 public:
  static Object* _fromLiteral(Object* elements);

  static Object* cppEpt_();

  static Object* from(Object* other);

  static Object* of(Object* other);

  static Object* unmodifiable(Object* other);

  static Object* identity();

  static Object* fromIterable(Object* iterable, Function* key, Function* value);

  static Object* fromIterables(Object* keys, Object* values);

  static Object* castFrom(Object* source);

  static Object* fromEntries(Object* entries);

  static Object* cppNew();
};
class CppMap {
 public:
  static Object* cppCtr_fromCppArray(Object* cppThis, Object* array);

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
//  library file:///Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/test/list.dart
class CppStringBuffer {
 public:
  static Object* cppCtr_(Object* cppThis);

  static void write(Object* cppThis, Object* obj);

  static void writeAll(Object* cppThis, Object* objects, String* separator);

  static void writeCharCode(Object* cppThis, Int* charCode);

  static void writeln(Object* cppThis, Object* obj);

  static void clear(Object* cppThis);

  static String* toString(Object* cppThis);

  static Int* cppGet_length(Object* cppThis);

  static Bool* cppGet_isEmpty(Object* cppThis);

  static Bool* cppGet_isNotEmpty(Object* cppThis);

  static Object* cppNew();
};
//  dart.collection
class MapView {
 public:
  static Object* cppCtr_(Object* cppThis, Object* map);

  static Object* cast(Object* cppThis);

  static Object* cpp_subscript(Object* cppThis, Object* key);

  static void cpp_subscriptAssign(Object* cppThis, Object* key, Object* value);

  static void addAll(Object* cppThis, Object* other);

  static void clear(Object* cppThis);

  static Object* putIfAbsent(Object* cppThis, Object* key, Function* ifAbsent);

  static Bool* containsKey(Object* cppThis, Object* key);

  static Bool* containsValue(Object* cppThis, Object* value);

  static void forEach(Object* cppThis, Function* action);

  static Bool* cppGet_isEmpty(Object* cppThis);

  static Bool* cppGet_isNotEmpty(Object* cppThis);

  static Int* cppGet_length(Object* cppThis);

  static Object* cppGet_keys(Object* cppThis);

  static Object* remove(Object* cppThis, Object* key);

  static String* toString(Object* cppThis);

  static Object* cppGet_values(Object* cppThis);

  static Object* cppGet_entries(Object* cppThis);

  static void addEntries(Object* cppThis, Object* entries);

  static Object* map(Object* cppThis, Function* transform);

  static Object* update(Object* cppThis,
                        Object* key,
                        Function* update,
                        Function* ifAbsent);

  static void updateAll(Object* cppThis, Function* update);

  static void removeWhere(Object* cppThis, Function* test);

  static Object* cppNew();
};
class _UnmodifiableMapMixin {
 public:
  static void cpp_subscriptAssign(Object* cppThis, Object* key, Object* value);

  static void addAll(Object* cppThis, Object* other);

  static void addEntries(Object* cppThis, Object* entries);

  static void clear(Object* cppThis);

  static Object* remove(Object* cppThis, Object* key);

  static void removeWhere(Object* cppThis, Function* test);

  static Object* putIfAbsent(Object* cppThis, Object* key, Function* ifAbsent);

  static Object* update(Object* cppThis,
                        Object* key,
                        Function* update,
                        Function* ifAbsent);

  static void updateAll(Object* cppThis, Function* update);

  static Object* cppNew();
};
class _UnmodifiableMapView$MapView$_UnmodifiableMapMixin {
 public:
  static Object* cppCtr_(Object* cppThis, Object* map);

  static void cpp_subscriptAssign(Object* cppThis, Object* key, Object* value);

  static void addAll(Object* cppThis, Object* other);

  static void addEntries(Object* cppThis, Object* entries);

  static void clear(Object* cppThis);

  static Object* remove(Object* cppThis, Object* key);

  static void removeWhere(Object* cppThis, Function* test);

  static Object* putIfAbsent(Object* cppThis, Object* key, Function* ifAbsent);

  static Object* update(Object* cppThis,
                        Object* key,
                        Function* update,
                        Function* ifAbsent);

  static void updateAll(Object* cppThis, Function* update);

  static Object* cppNew();
};
class CppWasmMap {
 public:
  static Object* cppCtr_(Object* cppThis, Object* map);

  static Object* cast(Object* cppThis);

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
//  dart.math
class Random {
 public:
  static Object* _secureRandom;
  static Object* cppEpt_(Int* seed);

  static Object* secure();

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

  static Object* cppNew();
};
//  dart.core
class Error {
 public:
  static Object* cppCtr_(Object* cppThis);

  static String* safeToString(Object* object);

  static String* _stringToSafeString(String* string);

  static String* _objectToString(Object* object);

  static Object* cppGet_stackTrace(Object* cppThis);

  static void throwWithStackTrace(Object* error, Object* stackTrace);

  static void _throw(Object* error, Object* stackTrace);

  static Object* cppNew();
};
class ArgumentError {
 public:
  static Object* cppCtr_(Object* cppThis, void** message, String* name);

  static Object* cppCtr_value(Object* cppThis,
                              void** value,
                              String* name,
                              void** message);

  static Object* cppCtr_notNull(Object* cppThis, String* name);

  static Object* checkNotNull(Object* argument, String* name);

  static String* cppGet__errorName(Object* cppThis);

  static String* cppGet__errorExplanation(Object* cppThis);

  static String* toString(Object* cppThis);

  static Object* cppNew();
};
class RangeError {
 public:
  static Object* cppCtr_(Object* cppThis, void** message);

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
                       void** indexable,
                       String* name,
                       String* message,
                       Int* length);

  static Int* checkValueInInterval(Int* value,
                                   Int* minValue,
                                   Int* maxValue,
                                   String* name,
                                   String* message);

  static Int* checkValidIndex(Int* index,
                              void** indexable,
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
//  dart.core
//  dart.core
//  dart.core
//  dart.core
class MapEntry {
 public:
  static Object* cppCtr__(Object* cppThis, Object* key, Object* value);

  static Object* cppEpt_(Object* key, Object* value);

  static String* toString(Object* cppThis);

  static Object* cppNew();
};
//  dart.core
//  dart.core
class StackTrace {
 public:
  static Object* empty;
  static Object* cppCtr_(Object* cppThis);

  static Object* fromString(String* stackTraceString);

  static Object* cppGet_current();

  static Object* cppNew();
};
//  dart.core
class StringSink {
 public:
  static Object* cppCtr_(Object* cppThis);

  static Object* cppNew();
};
class StringBuffer {
 public:
  static Int* _BUFFER_SIZE;
  static Int* _PARTS_TO_COMPACT;
  static Int* _PARTS_TO_COMPACT_SIZE_LIMIT;
  static Object* cppCtr_(Object* cppThis, Object* content);

  static void _writeString(Object* cppThis, String* str);

  static void _ensureCapacity(Object* cppThis, Int* n);

  static void _consumeBuffer(Object* cppThis);

  static void _addPart(Object* cppThis, String* str);

  static void _compact(Object* cppThis);

  static String* _create(Object* buffer, Int* length, Bool* isLatin1);

  static Int* cppGet_length(Object* cppThis);

  static Bool* cppGet_isEmpty(Object* cppThis);

  static Bool* cppGet_isNotEmpty(Object* cppThis);

  static void write(Object* cppThis, Object* obj);

  static void writeCharCode(Object* cppThis, Int* charCode);

  static void writeAll(Object* cppThis, Object* objects, String* separator);

  static void writeln(Object* cppThis, Object* obj);

  static void clear(Object* cppThis);

  static String* toString(Object* cppThis);

  static Object* cppNew();
};
