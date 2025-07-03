#include <cstdio>
#include <cstdlib>
#include <sstream>
#include "./core/array.h"
#include "./core/func.h"
#include "./core/num.h"
#include "./core/string.h"
#include "./core/api.h"

void print(Object* obj) {
  if (obj) {
    String* str = obj->toString();
    printf("%s", str->c_str());
    delete str;
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
class EfficientLengthIterable;
class HideEfficientLengthIterable;
class SubListIterable;
class ListIterator;
class EfficientLengthMappedIterable;
class MappedListIterable;
class WhereIterable;
class ExpandIterable;
class TakeIterable;
class TakeWhileIterable;
class SkipWhileIterable;
class FollowedByIterable;
class EfficientLengthFollowedByIterable;
class WhereTypeIterable;
class ReversedListIterable;
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
class CyBase : public Object {
 public:
  Int* a;
  String* aa;
  CyBase* cppCtr_(Int* c);

  virtual void test();

  static CyBase* cppNew();
};
//  library file:///Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/test/hello.dart
class CyFather : virtual public CyBase {
 public:
  Int* b;
  CyBase* base;
  CyFather* cppCtr_();

  CyFather* cppCtr_ee();

  virtual void myTest();

  static CyFather* cppNew();
};
//  library file:///Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/test/hello.dart
class CyChild : virtual public CyFather {
 public:
  Int* c;
  Num* e;
  CyChild* cppCtr_();

  virtual void myTest();

  static CyChild* cppNew();
};
//  library file:///Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/test/hello.dart
class CyComplexTest : public Object {
 public:
  List* _messages;
  Map* _scores;
  Set* _uniqueIds;
  CyComplexTest* cppCtr_();

  virtual void testConditionals();

  virtual void testSwitch(Int* value);

  virtual void testLoops();

  virtual void testmain();

  static CyComplexTest* cppNew();
};
//  library file:///Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/test/list.dart
class CppPointerArray : public Object {
 public:
  void** _data;
  Int* _length;
  CppPointerArray* cppCtr_(Int* _length, void** data);

  virtual Int* cppGet_length();

  virtual Object* getItem(Int* index);

  virtual void setItem(Int* index, Object* value);

  STATIC_METHOD_FORWARD(CppApi,cppCreatePointerArray);
  STATIC_METHOD_FORWARD(CppApi,cppGetPointerArrayItem);
  STATIC_METHOD_FORWARD(CppApi,cppSetPointerArrayItem);

  static CppPointerArray* cppNew();
};
//  library file:///Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/test/list.dart
class CppByteArray : public Object {
 public:
  void** _data;
  Int* _length;
  CppByteArray* cppCtr_(Int* _length, void** data);

  virtual Int* cppGet_length();

  virtual Int* getItem(Int* index);

  virtual void setItem(Int* index, Int* value);

  STATIC_METHOD_FORWARD(CppApi,cppCreateByteArray);
  STATIC_METHOD_FORWARD(CppApi,cppGetByteArrayItem);
  STATIC_METHOD_FORWARD(CppApi,cppSetByteArrayItem);

  static CppByteArray* cppNew();
};
//  library file:///Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/test/list.dart
class Iterable : public Object {
 public:
  virtual String* toString();

  Iterable* cppCtr_();

  static Iterable* generate(Int* count, Function* generator);

  static Iterable* withIterator(Function* iteratorFactory);

  static Iterable* empty();

  static Iterable* castFrom(Iterable* source);

  virtual Iterator* cppGet_iterator() = 0;

  virtual Iterable* cast();

  virtual Iterable* followedBy(Iterable* other);

  virtual Iterable* map(Function* toElement);

  virtual Iterable* where(Function* test);

  virtual Iterable* whereType();

  virtual Iterable* expand(Function* toElements);

  virtual Bool* contains(Object* element);

  virtual void forEach(Function* action);

  virtual Object* reduce(Function* combine);

  virtual Object* fold(Object* initialValue, Function* combine);

  virtual Bool* every(Function* test);

  virtual String* join(String* separator);

  virtual Bool* any(Function* test);

  virtual List* toList(Bool* growable);

  virtual Set* toSet();

  virtual Int* cppGet_length();

  virtual Bool* cppGet_isEmpty();

  virtual Bool* cppGet_isNotEmpty();

  virtual Iterable* take(Int* count);

  virtual Iterable* takeWhile(Function* test);

  virtual Iterable* skip(Int* count);

  virtual Iterable* skipWhile(Function* test);

  virtual Object* cppGet_first();

  virtual Object* cppGet_last();

  virtual Object* cppGet_single();

  virtual Object* firstWhere(Function* test, Function* orElse);

  virtual Object* lastWhere(Function* test, Function* orElse);

  virtual Object* singleWhere(Function* test, Function* orElse);

  virtual Object* elementAt(Int* index);

  static String* iterableToShortString(Iterable* iterable,
                                       String* leftDelimiter,
                                       String* rightDelimiter);

  static String* iterableToFullString(Iterable* iterable,
                                      String* leftDelimiter,
                                      String* rightDelimiter);

  static Iterable* cppNew();
};
class EfficientLengthIterable : virtual public Iterable {
 public:
  EfficientLengthIterable* cppCtr_();

  virtual Int* cppGet_length() = 0;

  static EfficientLengthIterable* cppNew();
};
class HideEfficientLengthIterable : virtual public Iterable {
 public:
  HideEfficientLengthIterable* cppCtr_();

  static HideEfficientLengthIterable* cppNew();
};
class _ListIterable : virtual public EfficientLengthIterable,
                      virtual public HideEfficientLengthIterable {
 public:
  _ListIterable* cppCtr_();

  static _ListIterable* cppNew();
};
class List : virtual public Iterable {
 public:
  static List* filled(Int* length, Object* fill, Bool* growable);

  static List* from(Iterable* elements, Bool* growable);

  static List* of(Iterable* elements, Bool* growable);

  static List* unmodifiable(Iterable* elements);

  static void copyRange(List* target,
                        Int* at,
                        List* source,
                        Int* start,
                        Int* end);

  static void writeIterable(List* target, Int* at, Iterable* source);

  virtual Object* cpp_subscript(Int* index) = 0;

  virtual void cpp_subscriptAssign(Int* index, Object* value) = 0;

  virtual void cppSet_first(Object* value) = 0;

  virtual void cppSet_last(Object* value) = 0;

  virtual void cppSet_length(Int* newLength) = 0;

  virtual void add(Object* value) = 0;

  virtual void addAll(Iterable* iterable) = 0;

  virtual Iterable* cppGet_reversed() = 0;

  virtual void sort(Function* compare) = 0;

  virtual void shuffle(Random* random) = 0;

  virtual Int* indexOf(Object* element, Int* start) = 0;

  virtual Int* indexWhere(Function* test, Int* start) = 0;

  virtual Int* lastIndexWhere(Function* test, Int* start) = 0;

  virtual Int* lastIndexOf(Object* element, Int* start) = 0;

  virtual void clear() = 0;

  virtual void insert(Int* index, Object* element) = 0;

  virtual void insertAll(Int* index, Iterable* iterable) = 0;

  virtual void setAll(Int* index, Iterable* iterable) = 0;

  virtual Bool* remove(Object* value) = 0;

  virtual Object* removeAt(Int* index) = 0;

  virtual Object* removeLast() = 0;

  virtual void removeWhere(Function* test) = 0;

  virtual void retainWhere(Function* test) = 0;

  virtual List* cpp_add(List* other) = 0;

  virtual List* sublist(Int* start, Int* end) = 0;

  virtual Iterable* getRange(Int* start, Int* end) = 0;

  virtual void setRange(Int* start,
                        Int* end,
                        Iterable* iterable,
                        Int* skipCount) = 0;

  virtual void removeRange(Int* start, Int* end) = 0;

  virtual void fillRange(Int* start, Int* end, Object* fillValue) = 0;

  virtual void replaceRange(Int* start, Int* end, Iterable* replacements) = 0;

  virtual Map* asMap() = 0;

  virtual Bool* cpp_equals(Object* other) = 0;

  static List* cppNew();
};
class CppList : virtual public List {
 public:
  Int* _length;
  CppPointerArray* _array;
  virtual String* toString();

  CppList* cppCtr_fromCppArray(CppPointerArray* array);

  CppList* cppCtr_(Int* length, Int* capacity);

  static Int* _getSuggestCapacity(Int* newLen);

  virtual void ensureCapacity(Int* newLen);

  virtual Bool* any(Function* test);

  virtual Bool* contains(Object* element);

  virtual Object* elementAt(Int* index);

  virtual Bool* every(Function* test);

  virtual Iterable* expand(Function* toElements);

  virtual Object* firstWhere(Function* test, Function* orElse);

  virtual Object* fold(Object* initialValue, Function* combine);

  virtual Iterable* followedBy(Iterable* other);

  virtual void forEach(Function* action);

  virtual Object* cppGet_first();

  virtual Object* cppGet_last();

  virtual Object* cppGet_single();

  virtual Bool* cppGet_isEmpty();

  virtual Bool* cppGet_isNotEmpty();

  virtual Iterator* cppGet_iterator();

  virtual String* join(String* separator);



  STATIC_METHOD_FORWARD(CppApi,cppJoinListString);

  virtual Object* lastWhere(Function* test, Function* orElse);

  virtual Iterable* map(Function* toElement);

  virtual Object* reduce(Function* combine);

  virtual void _quickSort(Int* low, Int* high, Function* compare);

  virtual Int* _partition(Int* low, Int* high, Function* compare);

  virtual void _swap(Int* i, Int* j);

  virtual Iterable* take(Int* count);

  virtual Iterable* takeWhile(Function* test);

  virtual List* toList(Bool* growable);

  virtual Set* toSet();

  virtual Iterable* where(Function* test);

  virtual Iterable* whereType();

  virtual Object* singleWhere(Function* test, Function* orElse);

  virtual Iterable* skip(Int* count);

  virtual Iterable* skipWhile(Function* test);

  static CppList* cppNew();
};
//  library file:///Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/test/list.dart
class Iterator : public Object {
 public:
  Iterator* cppCtr_();

  virtual Bool* moveNext() = 0;

  virtual Object* cppGet_current() = 0;

  static Iterator* cppNew();
};
class _CppListIterator : virtual public Iterator {
 public:
  CppList* _list;
  Int* _index;
  _CppListIterator* cppCtr_(CppList* _list);

  static _CppListIterator* cppNew();
};
//  library file:///Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/test/list.dart
class _SetIterable : virtual public EfficientLengthIterable,
                     virtual public HideEfficientLengthIterable {
 public:
  _SetIterable* cppCtr_();

  static _SetIterable* cppNew();
};
class Set : virtual public Iterable {
 public:
  static Set* cppEpt_();

  static Set* identity();

  static Set* from(Iterable* elements);

  static Set* of(Iterable* elements);

  static Set* unmodifiable(Iterable* elements);

  virtual Bool* add(Object* value) = 0;

  virtual void addAll(Iterable* elements) = 0;

  virtual Bool* remove(Object* value) = 0;

  virtual Object* lookup(Object* object) = 0;

  virtual void removeAll(Iterable* elements) = 0;

  virtual void retainAll(Iterable* elements) = 0;

  virtual void removeWhere(Function* test) = 0;

  virtual void retainWhere(Function* test) = 0;

  virtual Bool* containsAll(Iterable* other) = 0;

  virtual Set* intersection(Set* other) = 0;

  virtual Set* cpp_union(Set* other) = 0;

  virtual Set* difference(Set* other) = 0;

  virtual void clear() = 0;

  static Set* cppNew();
};
class CppSet : virtual public Set {
 public:
  CppList* _list;
  virtual String* toString();

  CppSet* cppCtr_fromCppArray(CppPointerArray* array);

  CppSet* cppCtr_(Int* capacity);

  virtual Bool* any(Function* test);

  virtual Object* elementAt(Int* index);

  virtual Bool* every(Function* test);

  virtual Iterable* expand(Function* toElements);

  virtual Object* firstWhere(Function* test, Function* orElse);

  virtual Object* fold(Object* initialValue, Function* combine);

  virtual Iterable* followedBy(Iterable* other);

  virtual void forEach(Function* action);

  virtual Object* cppGet_first();

  virtual Object* cppGet_last();

  virtual Object* cppGet_single();

  virtual Bool* cppGet_isEmpty();

  virtual Bool* cppGet_isNotEmpty();

  virtual String* join(String* separator);

  virtual Object* lastWhere(Function* test, Function* orElse);

  virtual Int* cppGet_length();

  virtual Iterable* map(Function* toElement);

  virtual Object* reduce(Function* combine);

  virtual Object* singleWhere(Function* test, Function* orElse);

  virtual Iterable* skip(Int* count);

  virtual Iterable* skipWhile(Function* test);

  virtual Iterable* take(Int* count);

  virtual Iterable* takeWhile(Function* test);

  virtual List* toList(Bool* growable);

  virtual Iterable* where(Function* test);

  virtual Iterable* whereType();

  static CppSet* cppNew();
};
//  library file:///Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/test/list.dart
class Map : public Object {
 public:
  static Map* _fromLiteral(List* elements);

  static Map* cppEpt_();

  static Map* from(Map* other);

  static Map* of(Map* other);

  static Map* unmodifiable(Map* other);

  static Map* identity();

  static Map* fromIterable(Iterable* iterable, Function* key, Function* value);

  static Map* fromIterables(Iterable* keys, Iterable* values);

  static Map* castFrom(Map* source);

  static Map* fromEntries(Iterable* entries);

  virtual Map* cast() = 0;

  virtual Bool* containsValue(Object* value) = 0;

  virtual Bool* containsKey(Object* key) = 0;

  virtual Object* cpp_subscript(Object* key) = 0;

  virtual void cpp_subscriptAssign(Object* key, Object* value) = 0;

  virtual Iterable* cppGet_entries() = 0;

  virtual Map* map(Function* convert) = 0;

  virtual void addEntries(Iterable* newEntries) = 0;

  virtual Object* update(Object* key, Function* update, Function* ifAbsent) = 0;

  virtual void updateAll(Function* update) = 0;

  virtual void removeWhere(Function* test) = 0;

  virtual Object* putIfAbsent(Object* key, Function* ifAbsent) = 0;

  virtual void addAll(Map* other) = 0;

  virtual Object* remove(Object* key) = 0;

  virtual void clear() = 0;

  virtual void forEach(Function* action) = 0;

  virtual Iterable* cppGet_keys() = 0;

  virtual Iterable* cppGet_values() = 0;

  virtual Int* cppGet_length() = 0;

  virtual Bool* cppGet_isEmpty() = 0;

  virtual Bool* cppGet_isNotEmpty() = 0;

  static Map* cppNew();
};
class CppMap : virtual public Map {
 public:
  CppList* _list;
  virtual String* toString();

  CppMap* cppCtr_fromCppArray(CppPointerArray* array);

  CppMap* cppCtr_(Int* capacity);

  static CppMap* cppNew();
};
//  library file:///Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/test/list.dart
class CppStringBuffer : public Object {
 public:
  CppList* _parts;
  virtual String* toString();

  CppStringBuffer* cppCtr_();

  virtual void write(Object* obj);

  virtual void writeAll(Iterable* objects, String* separator);

  virtual void writeCharCode(Int* charCode);

  virtual void writeln(Object* obj);

  virtual void clear();

  virtual Int* cppGet_length();

  virtual Bool* cppGet_isEmpty();

  virtual Bool* cppGet_isNotEmpty();

  static CppStringBuffer* cppNew();
};
//  dart.collection
class MapView : virtual public Map {
 public:
  Map* _map;
  virtual String* toString();

  MapView* cppCtr_(Map* map);

  static MapView* cppNew();
};
class _UnmodifiableMapMixin : virtual public Map {
 public:
  static _UnmodifiableMapMixin* cppNew();
};
class _UnmodifiableMapView$MapView$_UnmodifiableMapMixin : public Object {
 public:
  _UnmodifiableMapView$MapView$_UnmodifiableMapMixin* cppCtr_(Map* map);

  static _UnmodifiableMapView$MapView$_UnmodifiableMapMixin* cppNew();
};
class CppWasmMap : public Object {
 public:
  CppWasmMap* cppCtr_(Map* map);

  virtual Map* cast();

  static CppWasmMap* cppNew();
};
//  dart._internal
//  dart._internal
//  dart._internal
class ListIterable : virtual public EfficientLengthIterable,
                     virtual public HideEfficientLengthIterable {
 public:
  ListIterable* cppCtr_();

  virtual Iterator* cppGet_iterator();

  virtual Iterable* map(Function* toElement);

  virtual Iterable* where(Function* test);

  virtual Bool* contains(Object* element);

  virtual void forEach(Function* action);

  virtual Object* reduce(Function* combine);

  virtual Object* fold(Object* initialValue, Function* combine);

  virtual Bool* every(Function* test);

  virtual String* join(String* separator);

  virtual Bool* any(Function* test);

  virtual List* toList(Bool* growable);

  virtual Set* toSet();

  virtual Int* cppGet_length() = 0;

  virtual Bool* cppGet_isEmpty();

  virtual Iterable* take(Int* count);

  virtual Iterable* takeWhile(Function* test);

  virtual Iterable* skip(Int* count);

  virtual Iterable* skipWhile(Function* test);

  virtual Object* cppGet_first();

  virtual Object* cppGet_last();

  virtual Object* cppGet_single();

  virtual Object* firstWhere(Function* test, Function* orElse);

  virtual Object* lastWhere(Function* test, Function* orElse);

  virtual Object* singleWhere(Function* test, Function* orElse);

  virtual Object* elementAt(Int* i) = 0;

  static ListIterable* cppNew();
};
class SubListIterable : public Object {
 public:
  Iterable* _iterable;
  Int* _start;
  Int* _endOrLength;
  SubListIterable* cppCtr_(Iterable* _iterable, Int* _start, Int* _endOrLength);

  virtual List* toList(Bool* growable);

  virtual Int* cppGet_length();

  virtual Iterable* take(Int* count);

  virtual Iterable* skip(Int* count);

  virtual Object* elementAt(Int* index);

  static Iterable* iterableOf(SubListIterable* subListIterable);

  static Int* startOf(SubListIterable* subListIterable);

  virtual Int* cppGet__endIndex();

  virtual Int* cppGet__startIndex();

  static SubListIterable* cppNew();
};
//  dart._internal
class ListIterator : virtual public Iterator {
 public:
  Iterable* _iterable;
  Int* _length;
  Int* _index;
  Object* _current;
  ListIterator* cppCtr_(Iterable* iterable);

  static ListIterator* cppNew();
};
//  dart._internal
class MappedIterable : virtual public Iterable {
 public:
  Iterable* _iterable;
  Function* _f;
  virtual Iterator* cppGet_iterator();

  virtual Int* cppGet_length();

  virtual Bool* cppGet_isEmpty();

  virtual Object* cppGet_first();

  virtual Object* cppGet_last();

  virtual Object* cppGet_single();

  virtual Object* elementAt(Int* index);

  MappedIterable* cppCtr__(Iterable* _iterable, Function* _f);

  static MappedIterable* cppEpt_(Iterable* iterable, Function* function);

  static MappedIterable* cppNew();
};
class EfficientLengthMappedIterable
    : virtual public EfficientLengthIterable,
      virtual public HideEfficientLengthIterable {
 public:
  EfficientLengthMappedIterable* cppCtr_(Iterable* iterable,
                                         Function* function);

  static EfficientLengthMappedIterable* cppNew();
};
//  dart._internal
class MappedListIterable : public Object {
 public:
  Iterable* _source;
  Function* _f;
  MappedListIterable* cppCtr_(Iterable* _source, Function* _f);

  virtual Int* cppGet_length();

  virtual Object* elementAt(Int* index);

  static MappedListIterable* cppNew();
};
//  dart._internal
class WhereIterable : virtual public Iterable {
 public:
  Iterable* _iterable;
  Function* _f;
  WhereIterable* cppCtr_(Iterable* _iterable, Function* _f);

  virtual Iterator* cppGet_iterator();

  virtual Iterable* map(Function* toElement);

  static WhereIterable* cppNew();
};
//  dart._internal
class ExpandIterable : virtual public Iterable {
 public:
  Iterable* _iterable;
  Function* _f;
  ExpandIterable* cppCtr_(Iterable* _iterable, Function* _f);

  virtual Iterator* cppGet_iterator();

  static ExpandIterable* cppNew();
};
//  dart._internal
class TakeIterable : virtual public Iterable {
 public:
  Iterable* _iterable;
  Int* _takeCount;
  virtual Iterator* cppGet_iterator();

  TakeIterable* cppCtr__(Iterable* _iterable, Int* _takeCount);

  static TakeIterable* cppEpt_(Iterable* iterable, Int* takeCount);

  static TakeIterable* cppNew();
};
//  dart._internal
class TakeWhileIterable : virtual public Iterable {
 public:
  Iterable* _iterable;
  Function* _f;
  TakeWhileIterable* cppCtr_(Iterable* _iterable, Function* _f);

  virtual Iterator* cppGet_iterator();

  static TakeWhileIterable* cppNew();
};
//  dart._internal
class SkipWhileIterable : virtual public Iterable {
 public:
  Iterable* _iterable;
  Function* _f;
  SkipWhileIterable* cppCtr_(Iterable* _iterable, Function* _f);

  virtual Iterator* cppGet_iterator();

  static SkipWhileIterable* cppNew();
};
//  dart._internal
class FollowedByIterable : virtual public Iterable {
 public:
  Iterable* _first;
  Iterable* _second;
  FollowedByIterable* cppCtr_(Iterable* _first, Iterable* _second);

  virtual Iterator* cppGet_iterator();

  virtual Bool* contains(Object* value);

  virtual Int* cppGet_length();

  virtual Bool* cppGet_isEmpty();

  virtual Bool* cppGet_isNotEmpty();

  virtual Object* cppGet_first();

  virtual Object* cppGet_last();

  static FollowedByIterable* firstEfficient(EfficientLengthIterable* first,
                                            Iterable* second);

  static FollowedByIterable* cppNew();
};
//  dart._internal
class EfficientLengthFollowedByIterable
    : virtual public FollowedByIterable,
      virtual public EfficientLengthIterable,
      virtual public HideEfficientLengthIterable {
 public:
  EfficientLengthFollowedByIterable* cppCtr_(EfficientLengthIterable* first,
                                             EfficientLengthIterable* second);

  virtual Object* cppGet_first();

  virtual Object* cppGet_last();

  virtual Object* elementAt(Int* index);

  static EfficientLengthFollowedByIterable* cppNew();
};
//  dart._internal
class WhereTypeIterable : virtual public Iterable {
 public:
  Iterable* _source;
  WhereTypeIterable* cppCtr_(Iterable* _source);

  virtual Iterator* cppGet_iterator();

  static WhereTypeIterable* cppNew();
};
//  dart._internal
class ReversedListIterable : public Object {
 public:
  Iterable* _source;
  ReversedListIterable* cppCtr_(Iterable* _source);

  virtual Int* cppGet_length();

  virtual Object* elementAt(Int* index);

  static ReversedListIterable* cppNew();
};
//  dart._internal
class Sort : public Object {
 public:
  static Int* _INSERTION_SORT_THRESHOLD;
  Sort* cppCtr_();

  static void sort(List* a, Function* compare);

  static void sortRange(List* a, Int* from, Int* to, Function* compare);

  static void _doSort(List* a, Int* left, Int* right, Function* compare);

  static void _insertionSort(List* a, Int* left, Int* right, Function* compare);

  static void _dualPivotQuicksort(List* a,
                                  Int* left,
                                  Int* right,
                                  Function* compare);

  static Sort* cppNew();
};
//  dart.math
class Random : public Object {
 public:
  static Random* _secureRandom;
  static Random* cppEpt_(Int* seed);

  static Random* secure();

  virtual Int* nextInt(Int* max) = 0;

  virtual Double* nextDouble() = 0;

  virtual Bool* nextBool() = 0;

  static Random* cppNew();
};
//  nativewrappers
class NativeFieldWrapperClass1 : public Object {
 public:
  NativeFieldWrapperClass1* cppCtr_();

  static NativeFieldWrapperClass1* cppNew();
};
//  nativewrappers
class NativeFieldWrapperClass2 : virtual public NativeFieldWrapperClass1 {
 public:
  NativeFieldWrapperClass2* cppCtr_();

  static NativeFieldWrapperClass2* cppNew();
};
//  nativewrappers
class NativeFieldWrapperClass3 : virtual public NativeFieldWrapperClass2 {
 public:
  NativeFieldWrapperClass3* cppCtr_();

  static NativeFieldWrapperClass3* cppNew();
};
//  nativewrappers
class NativeFieldWrapperClass4 : virtual public NativeFieldWrapperClass3 {
 public:
  NativeFieldWrapperClass4* cppCtr_();

  static NativeFieldWrapperClass4* cppNew();
};
//  dart.core
class Comparable : public Object {
 public:
  Comparable* cppCtr_();

  virtual Int* compareTo(Object* other) = 0;

  static Int* compare(Comparable* a, Comparable* b);

  static Comparable* cppNew();
};
//  dart.core
class Error : public Object {
 public:
  StackTrace* _stackTrace;
  Error* cppCtr_();

  static String* safeToString(Object* object);

  static String* _stringToSafeString(String* string);

  static String* _objectToString(Object* object);

  virtual StackTrace* cppGet_stackTrace();

  static void throwWithStackTrace(Object* error, StackTrace* stackTrace);

  static void _throw(Object* error, StackTrace* stackTrace);

  static Error* cppNew();
};
class ArgumentError : public Object {
 public:
  Bool* _hasValue;
  void** invalidValue;
  String* name;
  void** message;
  virtual String* toString();

  ArgumentError* cppCtr_(void** message, String* name);

  ArgumentError* cppCtr_value(void** value, String* name, void** message);

  ArgumentError* cppCtr_notNull(String* name);

  static Object* checkNotNull(Object* argument, String* name);

  virtual String* cppGet__errorName();

  virtual String* cppGet__errorExplanation();

  static ArgumentError* cppNew();
};
class RangeError : public Object {
 public:
  Num* start;
  Num* end;
  RangeError* cppCtr_(void** message);

  RangeError* cppCtr_value(Num* value, String* name, String* message);

  virtual String* cppGet__errorName();

  virtual String* cppGet__errorExplanation();

  RangeError* cppCtr_range(Num* invalidValue,
                           Int* minValue,
                           Int* maxValue,
                           String* name,
                           String* message);

  virtual Num* cppGet_invalidValue();

  static RangeError* index(Int* index,
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

  static RangeError* cppNew();
};
//  dart.core
//  dart.core
//  dart.core
//  dart.core
//  dart.core
class MapEntry : public Object {
 public:
  Object* key;
  Object* value;
  virtual String* toString();

  MapEntry* cppCtr__(Object* key, Object* value);

  static MapEntry* cppEpt_(Object* key, Object* value);

  static MapEntry* cppNew();
};
//  dart.core
//  dart.core
class StackTrace : public Object {
 public:
  static _StringStackTrace* empty;
  virtual String* toString() = 0;

  StackTrace* cppCtr_();

  static StackTrace* fromString(String* stackTraceString);

  static StackTrace* cppGet_current();

  static StackTrace* cppNew();
};
//  dart.core
class StringSink : public Object {
 public:
  StringSink* cppCtr_();

  virtual void write(Object* object) = 0;

  virtual void writeAll(Iterable* objects, String* separator) = 0;

  virtual void writeln(Object* object) = 0;

  virtual void writeCharCode(Int* charCode) = 0;

  static StringSink* cppNew();
};
class StringBuffer : public Object {
 public:
  static Int* _BUFFER_SIZE;
  static Int* _PARTS_TO_COMPACT;
  static Int* _PARTS_TO_COMPACT_SIZE_LIMIT;
  List* _parts;
  Int* _partsCodeUnits;
  Int* _partsCompactionIndex;
  Int* _partsCodeUnitsSinceCompaction;
  Uint16List* _buffer;
  Int* _bufferPosition;
  Int* _bufferCodeUnitMagnitude;
  virtual String* toString();

  StringBuffer* cppCtr_(Object* content);

  virtual void _writeString(String* str);

  virtual void _ensureCapacity(Int* n);

  virtual void _consumeBuffer();

  virtual void _addPart(String* str);

  virtual void _compact();

  static String* _create(Uint16List* buffer, Int* length, Bool* isLatin1);

  virtual Int* cppGet_length();

  virtual Bool* cppGet_isEmpty();

  virtual Bool* cppGet_isNotEmpty();

  virtual void clear();

  static StringBuffer* cppNew();
};
