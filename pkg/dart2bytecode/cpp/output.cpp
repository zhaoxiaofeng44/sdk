#include "./output.h"
//  library file:///Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/test/hello.dart
Object* CyBase::cppCtr_(Object* cppThis, Int* c) {
  CppSet<Object*>(cppThis, String::cppNew("a"), c);

  return cppThis;
}

void CyBase::test(Object* cppThis) {
  print(String::cpp_add(
      CppGet<String*>(cppThis, String::cppNew("aa")),
      Int::toString(CppGet<Int*>(cppThis, String::cppNew("a")))));
  print(cppApply<String*>(
      cppApply<Object*>(cppThis, String::cppNew("cppGet_runtimeType")),
      String::cppNew("toString")));
}

Object* CyBase::cppNew() {
  static std::map<String*, void*> v_ptrs = {
      {String::cppNew("toString"), reinterpret_cast<void*>(&Object::toString)},
      {String::cppNew("test"), reinterpret_cast<void*>(&CyBase::test)}};
  static Type* runtimeType = new Type("CyBase");
  Object* ptr = new ObjectImp(const_cast<Type*>(runtimeType), &v_ptrs);
  return ptr;
}

//  library file:///Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/test/hello.dart
Object* CyFather::cppCtr_(Object* cppThis) {
  CppSet<Object*>(cppThis, String::cppNew("b"), Int::cppNew(2));
  CppSet<Object*>(cppThis, String::cppNew("base"),
                  CyBase::cppCtr_(CyBase::cppNew(), Int::cppNew(3)));

  return cppThis;
}

Object* CyFather::cppCtr_ee(Object* cppThis) {
  CppSet<Object*>(cppThis, String::cppNew("b"), Int::cppNew(2));
  CppSet<Object*>(cppThis, String::cppNew("base"),
                  CyBase::cppCtr_(CyBase::cppNew(), Int::cppNew(3)));

  return cppThis;
}

void CyFather::myTest(Object* cppThis) {
  print(String::cpp_add(
      String::cpp_add(cppApply<String*>(
                          cppApply<Object*>(
                              CppGet<Object*>(cppThis, String::cppNew("base")),
                              String::cppNew("cppGet_runtimeType")),
                          String::cppNew("toString")),
                      String::cppNew("")),
      Int::toString(CppGet<Int*>(cppThis, String::cppNew("b")))));
}

Object* CyFather::cppNew() {
  static std::map<String*, void*> v_ptrs = {
      {String::cppNew("toString"), reinterpret_cast<void*>(&Object::toString)},
      {String::cppNew("test"), reinterpret_cast<void*>(&CyBase::test)},
      {String::cppNew("myTest"), reinterpret_cast<void*>(&CyFather::myTest)}};
  static Type* runtimeType = new Type("CyFather");
  Object* ptr = new ObjectImp(const_cast<Type*>(runtimeType), &v_ptrs);
  return ptr;
}

//  library file:///Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/test/hello.dart
Object* CyChild::cppCtr_(Object* cppThis) {
  CppSet<Object*>(cppThis, String::cppNew("c"), Int::cppNew(2));

  return cppThis;
}

void CyChild::myTest(Object* cppThis) {
  Object* t = ([&]() {
    Object* cppLet_0 = CyChild::cppCtr_(CyChild::cppNew());
    cppApply<void>(cppLet_0, String::cppNew("test"));
    cppApply<void>(cppLet_0, String::cppNew("myTest"));
    return cppLet_0;
  })();
  print(String::cppNew("Gggg"));
}

Object* CyChild::cppNew() {
  static std::map<String*, void*> v_ptrs = {
      {String::cppNew("toString"), reinterpret_cast<void*>(&Object::toString)},
      {String::cppNew("test"), reinterpret_cast<void*>(&CyBase::test)},
      {String::cppNew("myTest"), reinterpret_cast<void*>(&CyChild::myTest)}};
  static Type* runtimeType = new Type("CyChild");
  Object* ptr = new ObjectImp(const_cast<Type*>(runtimeType), &v_ptrs);
  return ptr;
}

//  library file:///Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/test/hello.dart
Object* CyComplexTest::cppCtr_(Object* cppThis) {
  Object* child = CyChild::cppCtr_(CyChild::cppNew());
  cppApply<void, String*>(CppGet<Object*>(cppThis, String::cppNew("_messages")),
                          String::cppNew("add"), String::cppNew("Initialized"));
  print(
      String::cpp_add(String::cppNew("ComplexTest initialized"),
                      Int::toString(CppGet<Int*>(child, String::cppNew("c")))));
  return cppThis;
}

void CyComplexTest::testConditionals(Object* cppThis) {
  Int* x = Int::cppNew(10);
  Int* y = Int::cppNew(20);
  if (CppApi::cppBoolValue(Num::cpp_greaterThan(x, y))) {
    print(String::cppNew("x is greater than y"));
  } else if (CppApi::cppBoolValue(Num::cpp_lessThan(x, y))) {
    print(String::cppNew("x is less than y"));
  } else {
    print(String::cppNew("x is equal to y"));
  }
  String* result = CppApi::cppBoolValue(Num::cpp_greaterThan(x, y))
                       ? String::cppNew("x is greater")
                       : String::cppNew("y is greater or equal");
  print(String::cpp_add(cppToString(String::cppNew("Ternary result: ")),
                        cppToString(result)));
  String* nullableStr = nullptr;
  print(String::cpp_add(
      cppToString(String::cppNew("Null-aware: ")), cppToString(([&]() {
        String* cppLet_0 = nullableStr;
        return CppApi::cppBoolValue(Bool::cppNew(cppLet_0 == nullptr))
                   ? String::cppNew("Default value")
                   : cppLet_0;
      })())));
}

void CyComplexTest::testSwitch(Object* cppThis, Int* value) {
  do {
    auto switchValue = value;
    if (switchValue == Int::cppNew(1)) {
      print(String::cppNew("One"));
      break;
    }
    if (switchValue == Int::cppNew(2)) {
      print(String::cppNew("Two"));
      break;
    }
    if (switchValue == Int::cppNew(3)) {
      print(String::cppNew("Three"));
      break;
    }
    { print(String::cppNew("Unknown number")); }
  } while (0);
}

void CyComplexTest::testLoops(Object* cppThis) {
  print(String::cppNew("For-in loop:"));
  Object* list = CppNewList(Int::cppNew(1), Int::cppNew(2), Int::cppNew(3),
                            Int::cppNew(4), Int::cppNew(5));
  {
    Object* $sync_for_iterator =
        cppApply<Object*>(list, String::cppNew("cppGet_iterator"));
    {
      while (CppApi::cppBoolValue(
          cppApply<Bool*>($sync_for_iterator, String::cppNew("moveNext")))) {
        {
          Int* item = cppApply<Int*>($sync_for_iterator,
                                     String::cppNew("cppGet_current"));
          { print(item); }
        }
      }
    }
  }
}

void CyComplexTest::testmain(Object* cppThis) {}

Object* CyComplexTest::cppNew() {
  static std::map<String*, void*> v_ptrs = {
      {String::cppNew("toString"), reinterpret_cast<void*>(&Object::toString)},
      {String::cppNew("testConditionals"),
       reinterpret_cast<void*>(&CyComplexTest::testConditionals)},
      {String::cppNew("testSwitch"),
       reinterpret_cast<void*>(&CyComplexTest::testSwitch)},
      {String::cppNew("testLoops"),
       reinterpret_cast<void*>(&CyComplexTest::testLoops)},
      {String::cppNew("testmain"),
       reinterpret_cast<void*>(&CyComplexTest::testmain)}};
  static Type* runtimeType = new Type("CyComplexTest");
  Object* ptr = new ObjectImp(const_cast<Type*>(runtimeType), &v_ptrs);
  return ptr;
}

//  library file:///Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/test/list.dart
Object* CppPointerArray::cppCtr_(Object* cppThis, Int* _length, void** data) {
  CppSet<Object*>(cppThis, String::cppNew("_length"), _length);
  CppSet<Object*>(
      cppThis, String::cppNew("_data"), ([&]() {
        void** cppLet_0 = data;
        return CppApi::cppBoolValue(Bool::cppNew(cppLet_0 == nullptr))
                   ? CppPointerArray::cppCreatePointerArray(_length)
                   : cppLet_0;
      })());

  return cppThis;
}

Int* CppPointerArray::cppGet_length(Object* cppThis) {
  return CppGet<Int*>(cppThis, String::cppNew("_length"));
}

Object* CppPointerArray::getItem(Object* cppThis, Int* index) {
  return CppPointerArray::cppGetPointerArrayItem(
      CppGet<void**>(cppThis, String::cppNew("_data")), index);
}

void CppPointerArray::setItem(Object* cppThis, Int* index, Object* value) {
  return CppPointerArray::cppSetPointerArrayItem(
      CppGet<void**>(cppThis, String::cppNew("_data")), index, value);
}

Object* CppPointerArray::cppNew() {
  static std::map<String*, void*> v_ptrs = {
      {String::cppNew("toString"), reinterpret_cast<void*>(&Object::toString)},
      {String::cppNew("cppGet_length"),
       reinterpret_cast<void*>(&CppPointerArray::cppGet_length)},
      {String::cppNew("getItem"),
       reinterpret_cast<void*>(&CppPointerArray::getItem)},
      {String::cppNew("setItem"),
       reinterpret_cast<void*>(&CppPointerArray::setItem)}};
  static Type* runtimeType = new Type("CppPointerArray");
  Object* ptr = new ObjectImp(const_cast<Type*>(runtimeType), &v_ptrs);
  return ptr;
}

//  library file:///Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/test/list.dart
Object* CppByteArray::cppCtr_(Object* cppThis, Int* _length, void** data) {
  CppSet<Object*>(cppThis, String::cppNew("_length"), _length);
  CppSet<Object*>(
      cppThis, String::cppNew("_data"), ([&]() {
        void** cppLet_0 = data;
        return CppApi::cppBoolValue(Bool::cppNew(cppLet_0 == nullptr))
                   ? CppByteArray::cppCreateByteArray(_length)
                   : cppLet_0;
      })());

  return cppThis;
}

Int* CppByteArray::cppGet_length(Object* cppThis) {
  return CppGet<Int*>(cppThis, String::cppNew("_length"));
}

Int* CppByteArray::getItem(Object* cppThis, Int* index) {
  return CppByteArray::cppGetByteArrayItem(
      CppGet<void**>(cppThis, String::cppNew("_data")), index);
}

void CppByteArray::setItem(Object* cppThis, Int* index, Int* value) {
  return CppByteArray::cppSetByteArrayItem(
      CppGet<void**>(cppThis, String::cppNew("_data")), index, value);
}

Object* CppByteArray::cppNew() {
  static std::map<String*, void*> v_ptrs = {
      {String::cppNew("toString"), reinterpret_cast<void*>(&Object::toString)},
      {String::cppNew("cppGet_length"),
       reinterpret_cast<void*>(&CppByteArray::cppGet_length)},
      {String::cppNew("getItem"),
       reinterpret_cast<void*>(&CppByteArray::getItem)},
      {String::cppNew("setItem"),
       reinterpret_cast<void*>(&CppByteArray::setItem)}};
  static Type* runtimeType = new Type("CppByteArray");
  Object* ptr = new ObjectImp(const_cast<Type*>(runtimeType), &v_ptrs);
  return ptr;
}

//  library file:///Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/test/list.dart
Object* CppList::cppCtr_fromCppArray(Object* cppThis, Object* array) {
  CppSet<Object*>(cppThis, String::cppNew("_length"),
                  cppApply<Int*>(array, String::cppNew("cppGet_length")));
  CppSet<Object*>(cppThis, String::cppNew("_array"), array);

  return cppThis;
}

Object* CppList::cppCtr_(Object* cppThis, Int* length, Int* capacity) {
  CppSet<Object*>(cppThis, String::cppNew("_length"), length);
  CppSet<Object*>(
      cppThis, String::cppNew("_array"),
      CppPointerArray::cppCtr_(CppPointerArray::cppNew(), length, nullptr));

  return cppThis;
}

Object* CppList::empty(Bool* growable) {
  return CppApi::cppBoolValue(growable)
             ? CppList::cppCtr_(CppList::cppNew(), Int::cppNew(0),
                                Int::cppNew(0))
             : CppList::cppCtr_(CppList::cppNew(), Int::cppNew(0),
                                Int::cppNew(0));
}

Object* CppList::filled(Int* length, Object* fill, Bool* growable) {
  Object* array =
      CppPointerArray::cppCtr_(CppPointerArray::cppNew(), length, nullptr);
  {
    Int* i = Int::cppNew(0);
    while (CppApi::cppBoolValue(Num::cpp_lessThan(i, length))) {
      {
        cppApply<void, Int*, Object*>(array, String::cppNew("setItem"), i,
                                      fill);
      }
      i = Num::cpp_add(i, Int::cppNew(1));
    }
  }
  return CppList::cppCtr_fromCppArray(CppList::cppNew(), array);
}

Object* CppList::from(Object* elements, Bool* growable) {
  Int* length = cppApply<Int*>(elements, String::cppNew("cppGet_length"));
  Object* array =
      CppApi::cppBoolValue(growable)
          ? CppPointerArray::cppCtr_(CppPointerArray::cppNew(), length, nullptr)
          : CppPointerArray::cppCtr_(CppPointerArray::cppNew(),
                                     CppList::_getSuggestCapacity(length),
                                     nullptr);
  Int* i = Int::cppNew(0);
  {
    Object* $sync_for_iterator =
        cppApply<Object*>(elements, String::cppNew("cppGet_iterator"));
    {
      while (CppApi::cppBoolValue(
          cppApply<Bool*>($sync_for_iterator, String::cppNew("moveNext")))) {
        {
          void** element = cppApply<void**>($sync_for_iterator,
                                            String::cppNew("cppGet_current"));
          {
            cppApply<void, Int*, Object*>(
                array, String::cppNew("setItem"), ([&]() {
                  Int* cppLet_0 = i;
                  return ([&]() {
                    Int* cppLet_0 = i = Num::cpp_add(cppLet_0, Int::cppNew(1));
                    return cppLet_0;
                  })();
                })(),
                element);
          }
        }
      }
    }
  }
  return CppList::cppCtr_fromCppArray(CppList::cppNew(), array);
}

Object* CppList::of(Object* elements, Bool* growable) {
  return CppList::from(elements, growable);
}

Object* CppList::generate(Int* length, Function* generator, Bool* growable) {
  Object* array =
      CppApi::cppBoolValue(growable)
          ? CppPointerArray::cppCtr_(CppPointerArray::cppNew(), length, nullptr)
          : CppPointerArray::cppCtr_(CppPointerArray::cppNew(),
                                     CppList::_getSuggestCapacity(length),
                                     nullptr);
  {
    Int* i = Int::cppNew(0);
    while (CppApi::cppBoolValue(Num::cpp_lessThan(i, length))) {
      {
        cppApply<void, Int*, Object*>(array, String::cppNew("setItem"), i,
                                      cppApply<Object*>(generator, i));
      }
      i = Num::cpp_add(i, Int::cppNew(1));
    }
  }
  return CppList::cppCtr_fromCppArray(CppList::cppNew(), array);
}

Object* CppList::unmodifiable(Object* elements) {
  Int* length = cppApply<Int*>(elements, String::cppNew("cppGet_length"));
  Object* array =
      CppPointerArray::cppCtr_(CppPointerArray::cppNew(), length, nullptr);
  Int* i = Int::cppNew(0);
  {
    Object* $sync_for_iterator =
        cppApply<Object*>(elements, String::cppNew("cppGet_iterator"));
    {
      while (CppApi::cppBoolValue(
          cppApply<Bool*>($sync_for_iterator, String::cppNew("moveNext")))) {
        {
          void** element = cppApply<void**>($sync_for_iterator,
                                            String::cppNew("cppGet_current"));
          {
            cppApply<void, Int*, Object*>(
                array, String::cppNew("setItem"), ([&]() {
                  Int* cppLet_0 = i;
                  return ([&]() {
                    Int* cppLet_0 = i = Num::cpp_add(cppLet_0, Int::cppNew(1));
                    return cppLet_0;
                  })();
                })(),
                reinterpret_cast<Object*>(element));
          }
        }
      }
    }
  }
  return CppList::cppCtr_fromCppArray(CppList::cppNew(), array);
}

Int* CppList::_getSuggestCapacity(Int* newLen) {
  return CppApi::cppBoolValue(Num::cpp_greaterThan(newLen, Int::cppNew(256)))
             ? newLen
             : Num::toInt(
                   pow(Int::cppNew(2), Double::ceil(Double::cpp_divide(
                                           log(newLen), log(Int::cppNew(2))))));
}

Int* CppList::cppGet_length(Object* cppThis) {
  return CppGet<Int*>(cppThis, String::cppNew("_length"));
}

void CppList::ensureCapacity(Object* cppThis, Int* newLen) {
  if (CppApi::cppBoolValue(Num::cpp_greaterThan(
          newLen,
          cppApply<Int*>(CppGet<Object*>(cppThis, String::cppNew("_array")),
                         String::cppNew("cppGet_length"))))) {
    Object* newArray =
        CppPointerArray::cppCtr_(CppPointerArray::cppNew(),
                                 CppList::_getSuggestCapacity(newLen), nullptr);
    {
      Int* i = Int::cppNew(0);
      while (CppApi::cppBoolValue(Num::cpp_lessThan(
          i, cppApply<Int*>(CppGet<Object*>(cppThis, String::cppNew("_array")),
                            String::cppNew("cppGet_length"))))) {
        {
          cppApply<void, Int*, Object*>(
              newArray, String::cppNew("setItem"), i,
              cppApply<Object*, Int*>(
                  CppGet<Object*>(cppThis, String::cppNew("_array")),
                  String::cppNew("getItem"), i));
        }
        i = Num::cpp_add(i, Int::cppNew(1));
      }
    }
    CppSet<CppList*>(cppThis, String::cppNew("_array"), newArray);
  }
}

void CppList::cppSet_length(Object* cppThis, Int* newLen) {
  cppApply<void, Int*>(cppThis, String::cppNew("ensureCapacity"), newLen);
  CppSet<CppList*>(cppThis, String::cppNew("_length"), newLen);
}

Object* CppList::cpp_subscript(Object* cppThis, Int* index) {
  return reinterpret_cast<Object*>(cppApply<Object*, Int*>(
      CppGet<Object*>(cppThis, String::cppNew("_array")),
      String::cppNew("getItem"), index));
}

void CppList::cpp_subscriptAssign(Object* cppThis, Int* index, Object* value) {
  return cppApply<void, Int*, Object*>(
      CppGet<Object*>(cppThis, String::cppNew("_array")),
      String::cppNew("setItem"), index, value);
}

void CppList::add(Object* cppThis, Object* value) {
  cppApply<void, Int*>(
      cppThis, String::cppNew("ensureCapacity"),
      Num::cpp_add(CppGet<Int*>(cppThis, String::cppNew("_length")),
                   Int::cppNew(1)));
  cppApply<void, Int*, Object*>(
      CppGet<Object*>(cppThis, String::cppNew("_array")),
      String::cppNew("setItem"), ([&]() {
        Int* cppLet_0 = CppGet<Int*>(cppThis, String::cppNew("_length"));
        return ([&]() {
          Int* cppLet_0 =
              CppSet<CppList*>(cppThis, String::cppNew("_length"),
                               Num::cpp_add(cppLet_0, Int::cppNew(1)));
          return cppLet_0;
        })();
      })(),
      value);
}

void CppList::addAll(Object* cppThis, Object* iterable) {
  {
    Object* $sync_for_iterator =
        cppApply<Object*>(iterable, String::cppNew("cppGet_iterator"));
    {
      while (CppApi::cppBoolValue(
          cppApply<Bool*>($sync_for_iterator, String::cppNew("moveNext")))) {
        {
          Object* element = cppApply<Object*>($sync_for_iterator,
                                              String::cppNew("cppGet_current"));
          { cppApply<void, Object*>(cppThis, String::cppNew("add"), element); }
        }
      }
    }
  }
}

Bool* CppList::any(Object* cppThis, Function* test) {
  {
    Int* i = Int::cppNew(0);
    while (CppApi::cppBoolValue(Num::cpp_lessThan(
        i, CppGet<Int*>(cppThis, String::cppNew("_length"))))) {
      {
        if (CppApi::cppBoolValue(cppApply<Bool*>(
                test, reinterpret_cast<Object*>(cppApply<Object*, Int*>(
                          CppGet<Object*>(cppThis, String::cppNew("_array")),
                          String::cppNew("getItem"), i)))))
          return Bool::cppNew(true);
      }
      i = Num::cpp_add(i, Int::cppNew(1));
    }
  }
  return Bool::cppNew(false);
}

Object* CppList::asMap(Object* cppThis) {
  Object* map = CppNewMap();
  {
    Int* i = Int::cppNew(0);
    while (CppApi::cppBoolValue(Num::cpp_lessThan(
        i, CppGet<Int*>(cppThis, String::cppNew("_length"))))) {
      {
        cppApply<void, Int*, Object*>(
            map, String::cppNew("cpp_subscriptAssign"), i,
            reinterpret_cast<Object*>(cppApply<Object*, Int*>(
                CppGet<Object*>(cppThis, String::cppNew("_array")),
                String::cppNew("getItem"), i)));
      }
      i = Num::cpp_add(i, Int::cppNew(1));
    }
  }
  return map;
}

Object* CppList::cast(Object* cppThis) {
  return List::castFrom(cppThis);
}

void CppList::clear(Object* cppThis) {
  CppSet<CppList*>(cppThis, String::cppNew("_length"), Int::cppNew(0));
}

Bool* CppList::contains(Object* cppThis, Object* element) {
  {
    Int* i = Int::cppNew(0);
    while (CppApi::cppBoolValue(Num::cpp_lessThan(
        i, CppGet<Int*>(cppThis, String::cppNew("_length"))))) {
      {
        if (CppApi::cppBoolValue(Object::cpp_equals(
                cppApply<Object*, Int*>(
                    CppGet<Object*>(cppThis, String::cppNew("_array")),
                    String::cppNew("getItem"), i),
                element)))
          return Bool::cppNew(true);
      }
      i = Num::cpp_add(i, Int::cppNew(1));
    }
  }
  return Bool::cppNew(false);
}

Object* CppList::elementAt(Object* cppThis, Int* index) {
  return reinterpret_cast<Object*>(cppApply<Object*, Int*>(
      CppGet<Object*>(cppThis, String::cppNew("_array")),
      String::cppNew("getItem"), index));
}

Bool* CppList::every(Object* cppThis, Function* test) {
  {
    Int* i = Int::cppNew(0);
    while (CppApi::cppBoolValue(Num::cpp_lessThan(
        i, CppGet<Int*>(cppThis, String::cppNew("_length"))))) {
      {
        if (CppApi::cppBoolValue(Bool::cpp_not(cppApply<Bool*>(
                test, reinterpret_cast<Object*>(cppApply<Object*, Int*>(
                          CppGet<Object*>(cppThis, String::cppNew("_array")),
                          String::cppNew("getItem"), i))))))
          return Bool::cppNew(false);
      }
      i = Num::cpp_add(i, Int::cppNew(1));
    }
  }
  return Bool::cppNew(true);
}

Object* CppList::expand(Object* cppThis, Function* toElements) {
  Object* result = CppNewList(Int::cppNew(0));
  {
    Int* i = Int::cppNew(0);
    while (CppApi::cppBoolValue(Num::cpp_lessThan(
        i, CppGet<Int*>(cppThis, String::cppNew("_length"))))) {
      {
        cppApply<void, Object*>(
            result, String::cppNew("addAll"),
            cppApply<Object*>(
                toElements,
                reinterpret_cast<Object*>(cppApply<Object*, Int*>(
                    CppGet<Object*>(cppThis, String::cppNew("_array")),
                    String::cppNew("getItem"), i))));
      }
      i = Num::cpp_add(i, Int::cppNew(1));
    }
  }
  return result;
}

void CppList::fillRange(Object* cppThis,
                        Int* start,
                        Int* end,
                        Object* fillValue) {
  {
    Int* i = start;
    while (CppApi::cppBoolValue(Num::cpp_lessThan(i, end))) {
      {
        cppApply<void, Int*, Object*>(
            CppGet<Object*>(cppThis, String::cppNew("_array")),
            String::cppNew("setItem"), i, ([&]() {
              Object* cppLet_0 = fillValue;
              return CppApi::cppBoolValue(Bool::cppNew(cppLet_0 == nullptr))
                         ? reinterpret_cast<Object*>(cppLet_0)
                         : cppLet_0;
            })());
      }
      i = Num::cpp_add(i, Int::cppNew(1));
    }
  }
}

Object* CppList::firstWhere(Object* cppThis, Function* test, Function* orElse) {
  {
    Int* i = Int::cppNew(0);
    while (CppApi::cppBoolValue(Num::cpp_lessThan(
        i, CppGet<Int*>(cppThis, String::cppNew("_length"))))) {
      {
        if (CppApi::cppBoolValue(cppApply<Bool*>(
                test, reinterpret_cast<Object*>(cppApply<Object*, Int*>(
                          CppGet<Object*>(cppThis, String::cppNew("_array")),
                          String::cppNew("getItem"), i)))))
          return reinterpret_cast<Object*>(cppApply<Object*, Int*>(
              CppGet<Object*>(cppThis, String::cppNew("_array")),
              String::cppNew("getItem"), i));
      }
      i = Num::cpp_add(i, Int::cppNew(1));
    }
  }
  if (CppApi::cppBoolValue(Bool::cpp_not(Bool::cppNew(orElse == nullptr))))
    return cppApply<Object*>(orElse);
  throw "ConstructorInvocation(new StateError(No element))";
}

Object* CppList::fold(Object* cppThis,
                      Object* initialValue,
                      Function* combine) {
  Object* value = initialValue;
  {
    Int* i = Int::cppNew(0);
    while (CppApi::cppBoolValue(Num::cpp_lessThan(
        i, CppGet<Int*>(cppThis, String::cppNew("_length"))))) {
      {
        value = cppApply<Object*>(
            combine, value,
            reinterpret_cast<Object*>(cppApply<Object*, Int*>(
                CppGet<Object*>(cppThis, String::cppNew("_array")),
                String::cppNew("getItem"), i)));
      }
      i = Num::cpp_add(i, Int::cppNew(1));
    }
  }
  return value;
}

Object* CppList::followedBy(Object* cppThis, Object* other) {
  return [&] {
    Object* cppLet_0 = List::of(cppThis, Bool::cppNew(true));
    cppApply<void, Object*>(cppLet_0, String::cppNew("addAll"), other);
    return cppLet_0;
  }();
}

void CppList::forEach(Object* cppThis, Function* action) {
  {
    Int* i = Int::cppNew(0);
    while (CppApi::cppBoolValue(Num::cpp_lessThan(
        i, CppGet<Int*>(cppThis, String::cppNew("_length"))))) {
      {
        cppApply<void>(action,
                       reinterpret_cast<Object*>(cppApply<Object*, Int*>(
                           CppGet<Object*>(cppThis, String::cppNew("_array")),
                           String::cppNew("getItem"), i)));
      }
      i = Num::cpp_add(i, Int::cppNew(1));
    }
  }
}

Object* CppList::getRange(Object* cppThis, Int* start, Int* end) {
  return CppList::from(
      Iterable::generate(
          Num::cpp_subtract(end, start),
          new LambdaWrapper<Object*, Int*>([&](Int* i) -> Object* {
            return cppApply<Object*, Int*>(
                CppGet<Object*>(cppThis, String::cppNew("_array")),
                String::cppNew("getItem"), Num::cpp_add(start, i));
          })),
      Bool::cppNew(true));
}

Int* CppList::indexOf(Object* cppThis, Object* element, Int* start) {
  {
    Int* i = start;
    while (CppApi::cppBoolValue(Num::cpp_lessThan(
        i, CppGet<Int*>(cppThis, String::cppNew("_length"))))) {
      {
        if (CppApi::cppBoolValue(Object::cpp_equals(
                cppApply<Object*, Int*>(
                    CppGet<Object*>(cppThis, String::cppNew("_array")),
                    String::cppNew("getItem"), i),
                element)))
          return i;
      }
      i = Num::cpp_add(i, Int::cppNew(1));
    }
  }
  return Int::cpp_negation(Int::cppNew(1));
}

Int* CppList::indexWhere(Object* cppThis, Function* test, Int* start) {
  {
    Int* i = start;
    while (CppApi::cppBoolValue(Num::cpp_lessThan(
        i, CppGet<Int*>(cppThis, String::cppNew("_length"))))) {
      {
        if (CppApi::cppBoolValue(cppApply<Bool*>(
                test, reinterpret_cast<Object*>(cppApply<Object*, Int*>(
                          CppGet<Object*>(cppThis, String::cppNew("_array")),
                          String::cppNew("getItem"), i)))))
          return i;
      }
      i = Num::cpp_add(i, Int::cppNew(1));
    }
  }
  return Int::cpp_negation(Int::cppNew(1));
}

void CppList::insert(Object* cppThis, Int* index, Object* element) {
  if (CppApi::cppBoolValue(
          CppApi::cppBoolValue(Num::cpp_lessThan(index, Int::cppNew(0))) ||
          CppApi::cppBoolValue(Num::cpp_greaterThan(
              index, CppGet<Int*>(cppThis, String::cppNew("_length"))))))
    throw "ConstructorInvocation(new IndexError(index, this))";
  cppApply<void, Int*>(
      cppThis, String::cppNew("ensureCapacity"),
      Num::cpp_add(CppGet<Int*>(cppThis, String::cppNew("_length")),
                   Int::cppNew(1)));
  {
    Int* i = CppGet<Int*>(cppThis, String::cppNew("_length"));
    while (CppApi::cppBoolValue(Num::cpp_greaterThan(i, index))) {
      {
        cppApply<void, Int*, Object*>(
            CppGet<Object*>(cppThis, String::cppNew("_array")),
            String::cppNew("setItem"), i,
            cppApply<Object*, Int*>(
                CppGet<Object*>(cppThis, String::cppNew("_array")),
                String::cppNew("getItem"),
                Num::cpp_subtract(i, Int::cppNew(1))));
      }
      i = Num::cpp_subtract(i, Int::cppNew(1));
    }
  }
  cppApply<void, Int*, Object*>(
      CppGet<Object*>(cppThis, String::cppNew("_array")),
      String::cppNew("setItem"), index, element);
  CppSet<CppList*>(
      cppThis, String::cppNew("_length"),
      Num::cpp_add(CppGet<Int*>(cppThis, String::cppNew("_length")),
                   Int::cppNew(1)));
}

void CppList::insertAll(Object* cppThis, Int* index, Object* iterable) {
  if (CppApi::cppBoolValue(
          CppApi::cppBoolValue(Num::cpp_lessThan(index, Int::cppNew(0))) ||
          CppApi::cppBoolValue(Num::cpp_greaterThan(
              index, CppGet<Int*>(cppThis, String::cppNew("_length"))))))
    throw "ConstructorInvocation(new IndexError(index, this))";
  Object* elements =
      cppApply<Object*, Bool*>(iterable, String::cppNew("toList"), nullptr);
  Int* insertLength = cppApply<Int*>(elements, String::cppNew("cppGet_length"));
  if (CppApi::cppBoolValue(Object::cpp_equals(insertLength, Int::cppNew(0))))
    return;
  cppApply<void, Int*>(
      cppThis, String::cppNew("ensureCapacity"),
      Num::cpp_add(CppGet<Int*>(cppThis, String::cppNew("_length")),
                   insertLength));
  {
    Int* i = Num::cpp_subtract(CppGet<Int*>(cppThis, String::cppNew("_length")),
                               Int::cppNew(1));
    while (CppApi::cppBoolValue(Num::cpp_greaterThanOrEqual(i, index))) {
      {
        cppApply<void, Int*, Object*>(
            CppGet<Object*>(cppThis, String::cppNew("_array")),
            String::cppNew("setItem"), Num::cpp_add(i, insertLength),
            cppApply<Object*, Int*>(
                CppGet<Object*>(cppThis, String::cppNew("_array")),
                String::cppNew("getItem"), i));
      }
      i = Num::cpp_subtract(i, Int::cppNew(1));
    }
  }
  {
    Int* i = Int::cppNew(0);
    while (CppApi::cppBoolValue(Num::cpp_lessThan(i, insertLength))) {
      {
        cppApply<void, Int*, Object*>(
            CppGet<Object*>(cppThis, String::cppNew("_array")),
            String::cppNew("setItem"), Num::cpp_add(index, i),
            cppApply<Object*, Int*>(elements, String::cppNew("cpp_subscript"),
                                    i));
      }
      i = Num::cpp_add(i, Int::cppNew(1));
    }
  }
  CppSet<CppList*>(
      cppThis, String::cppNew("_length"),
      Num::cpp_add(CppGet<Int*>(cppThis, String::cppNew("_length")),
                   insertLength));
}

Object* CppList::cppGet_first(Object* cppThis) {
  if (CppApi::cppBoolValue(Object::cpp_equals(
          CppGet<Int*>(cppThis, String::cppNew("_length")), Int::cppNew(0))))
    throw "ConstructorInvocation(new StateError(No element))";
  return reinterpret_cast<Object*>(cppApply<Object*, Int*>(
      CppGet<Object*>(cppThis, String::cppNew("_array")),
      String::cppNew("getItem"), Int::cppNew(0)));
}

void CppList::cppSet_first(Object* cppThis, Object* value) {
  if (CppApi::cppBoolValue(Object::cpp_equals(
          CppGet<Int*>(cppThis, String::cppNew("_length")), Int::cppNew(0))))
    throw "ConstructorInvocation(new StateError(No element))";
  cppApply<void, Int*, Object*>(
      CppGet<Object*>(cppThis, String::cppNew("_array")),
      String::cppNew("setItem"), Int::cppNew(0), value);
}

Object* CppList::cppGet_last(Object* cppThis) {
  if (CppApi::cppBoolValue(Object::cpp_equals(
          CppGet<Int*>(cppThis, String::cppNew("_length")), Int::cppNew(0))))
    throw "ConstructorInvocation(new StateError(No element))";
  return reinterpret_cast<Object*>(cppApply<Object*, Int*>(
      CppGet<Object*>(cppThis, String::cppNew("_array")),
      String::cppNew("getItem"),
      Num::cpp_subtract(CppGet<Int*>(cppThis, String::cppNew("_length")),
                        Int::cppNew(1))));
}

void CppList::cppSet_last(Object* cppThis, Object* value) {
  if (CppApi::cppBoolValue(Object::cpp_equals(
          CppGet<Int*>(cppThis, String::cppNew("_length")), Int::cppNew(0))))
    throw "ConstructorInvocation(new StateError(No element))";
  cppApply<void, Int*, Object*>(
      CppGet<Object*>(cppThis, String::cppNew("_array")),
      String::cppNew("setItem"),
      Num::cpp_subtract(CppGet<Int*>(cppThis, String::cppNew("_length")),
                        Int::cppNew(1)),
      value);
}

Object* CppList::cppGet_single(Object* cppThis) {
  if (CppApi::cppBoolValue(Object::cpp_equals(
          CppGet<Int*>(cppThis, String::cppNew("_length")), Int::cppNew(0))))
    throw "ConstructorInvocation(new StateError(No element))";
  if (CppApi::cppBoolValue(Num::cpp_greaterThan(
          CppGet<Int*>(cppThis, String::cppNew("_length")), Int::cppNew(1))))
    throw "ConstructorInvocation(new StateError(Too many elements))";
  return reinterpret_cast<Object*>(cppApply<Object*, Int*>(
      CppGet<Object*>(cppThis, String::cppNew("_array")),
      String::cppNew("getItem"), Int::cppNew(0)));
}

Bool* CppList::cppGet_isEmpty(Object* cppThis) {
  return Object::cpp_equals(CppGet<Int*>(cppThis, String::cppNew("_length")),
                            Int::cppNew(0));
}

Bool* CppList::cppGet_isNotEmpty(Object* cppThis) {
  return Bool::cpp_not(Object::cpp_equals(
      CppGet<Int*>(cppThis, String::cppNew("_length")), Int::cppNew(0)));
}

Object* CppList::cppGet_iterator(Object* cppThis) {
  return _CppListIterator::cppCtr_(_CppListIterator::cppNew(), cppThis);
}

String* CppList::join(Object* cppThis, String* separator) {
  if (CppApi::cppBoolValue(Object::cpp_equals(
          CppGet<Int*>(cppThis, String::cppNew("_length")), Int::cppNew(0))))
    return String::cppNew("");
  return CppList::cppJoinListString(
      CppGet<void**>(CppGet<Object*>(cppThis, String::cppNew("_array")),
                     String::cppNew("_data")),
      CppGet<Int*>(cppThis, String::cppNew("_length")), separator);
}

Int* CppList::lastIndexOf(Object* cppThis, Object* element, Int* start) {
  Int* startIndex = ([&]() {
    Int* cppLet_0 = start;
    return CppApi::cppBoolValue(Bool::cppNew(cppLet_0 == nullptr))
               ? Num::cpp_subtract(
                     CppGet<Int*>(cppThis, String::cppNew("_length")),
                     Int::cppNew(1))
               : cppLet_0;
  })();
  {
    Int* i = startIndex;
    while (
        CppApi::cppBoolValue(Num::cpp_greaterThanOrEqual(i, Int::cppNew(0)))) {
      {
        if (CppApi::cppBoolValue(Object::cpp_equals(
                cppApply<Object*, Int*>(
                    CppGet<Object*>(cppThis, String::cppNew("_array")),
                    String::cppNew("getItem"), i),
                element)))
          return i;
      }
      i = Num::cpp_subtract(i, Int::cppNew(1));
    }
  }
  return Int::cpp_negation(Int::cppNew(1));
}

Int* CppList::lastIndexWhere(Object* cppThis, Function* test, Int* start) {
  Int* startIndex = ([&]() {
    Int* cppLet_0 = start;
    return CppApi::cppBoolValue(Bool::cppNew(cppLet_0 == nullptr))
               ? Num::cpp_subtract(
                     CppGet<Int*>(cppThis, String::cppNew("_length")),
                     Int::cppNew(1))
               : cppLet_0;
  })();
  {
    Int* i = startIndex;
    while (
        CppApi::cppBoolValue(Num::cpp_greaterThanOrEqual(i, Int::cppNew(0)))) {
      {
        if (CppApi::cppBoolValue(cppApply<Bool*>(
                test, reinterpret_cast<Object*>(cppApply<Object*, Int*>(
                          CppGet<Object*>(cppThis, String::cppNew("_array")),
                          String::cppNew("getItem"), i)))))
          return i;
      }
      i = Num::cpp_subtract(i, Int::cppNew(1));
    }
  }
  return Int::cpp_negation(Int::cppNew(1));
}

Object* CppList::lastWhere(Object* cppThis, Function* test, Function* orElse) {
  {
    Int* i = Num::cpp_subtract(CppGet<Int*>(cppThis, String::cppNew("_length")),
                               Int::cppNew(1));
    while (
        CppApi::cppBoolValue(Num::cpp_greaterThanOrEqual(i, Int::cppNew(0)))) {
      {
        if (CppApi::cppBoolValue(cppApply<Bool*>(
                test, reinterpret_cast<Object*>(cppApply<Object*, Int*>(
                          CppGet<Object*>(cppThis, String::cppNew("_array")),
                          String::cppNew("getItem"), i)))))
          return reinterpret_cast<Object*>(cppApply<Object*, Int*>(
              CppGet<Object*>(cppThis, String::cppNew("_array")),
              String::cppNew("getItem"), i));
      }
      i = Num::cpp_subtract(i, Int::cppNew(1));
    }
  }
  if (CppApi::cppBoolValue(Bool::cpp_not(Bool::cppNew(orElse == nullptr))))
    return cppApply<Object*>(orElse);
  throw "ConstructorInvocation(new StateError(No element))";
}

Object* CppList::map(Object* cppThis, Function* toElement) {
  return Iterable::generate(
      CppGet<Int*>(cppThis, String::cppNew("_length")),
      new LambdaWrapper<Object*, Int*>([&](Int* i) -> Object* {
        return cppApply<Object*>(
            toElement, reinterpret_cast<Object*>(cppApply<Object*, Int*>(
                           CppGet<Object*>(cppThis, String::cppNew("_array")),
                           String::cppNew("getItem"), i)));
      }));
}

Object* CppList::reduce(Object* cppThis, Function* combine) {
  if (CppApi::cppBoolValue(Object::cpp_equals(
          CppGet<Int*>(cppThis, String::cppNew("_length")), Int::cppNew(0))))
    throw "ConstructorInvocation(new StateError(No element))";
  Object* value = reinterpret_cast<Object*>(cppApply<Object*, Int*>(
      CppGet<Object*>(cppThis, String::cppNew("_array")),
      String::cppNew("getItem"), Int::cppNew(0)));
  {
    Int* i = Int::cppNew(1);
    while (CppApi::cppBoolValue(Num::cpp_lessThan(
        i, CppGet<Int*>(cppThis, String::cppNew("_length"))))) {
      {
        value = cppApply<Object*>(
            combine, value,
            reinterpret_cast<Object*>(cppApply<Object*, Int*>(
                CppGet<Object*>(cppThis, String::cppNew("_array")),
                String::cppNew("getItem"), i)));
      }
      i = Num::cpp_add(i, Int::cppNew(1));
    }
  }
  return value;
}

Bool* CppList::remove(Object* cppThis, Object* value) {
  Int* index =
      cppApply<Int*, Object*, Int*>(cppThis, String::cppNew("indexOf"),
                                    reinterpret_cast<Object*>(value), nullptr);
  if (CppApi::cppBoolValue(Bool::cpp_not(
          Object::cpp_equals(index, Int::cpp_negation(Int::cppNew(1)))))) {
    cppApply<Object*, Int*>(cppThis, String::cppNew("removeAt"), index);
    return Bool::cppNew(true);
  }
  return Bool::cppNew(false);
}

Object* CppList::removeAt(Object* cppThis, Int* index) {
  if (CppApi::cppBoolValue(
          CppApi::cppBoolValue(Num::cpp_lessThan(index, Int::cppNew(0))) ||
          CppApi::cppBoolValue(Num::cpp_greaterThanOrEqual(
              index, CppGet<Int*>(cppThis, String::cppNew("_length"))))))
    throw "ConstructorInvocation(new IndexError(index, this))";
  Object* element = cppApply<Object*, Int*>(
      CppGet<Object*>(cppThis, String::cppNew("_array")),
      String::cppNew("getItem"), index);
  {
    Int* i = index;
    while (CppApi::cppBoolValue(Num::cpp_lessThan(
        i, Num::cpp_subtract(CppGet<Int*>(cppThis, String::cppNew("_length")),
                             Int::cppNew(1))))) {
      {
        cppApply<void, Int*, Object*>(
            CppGet<Object*>(cppThis, String::cppNew("_array")),
            String::cppNew("setItem"), i,
            cppApply<Object*, Int*>(
                CppGet<Object*>(cppThis, String::cppNew("_array")),
                String::cppNew("getItem"), Num::cpp_add(i, Int::cppNew(1))));
      }
      i = Num::cpp_add(i, Int::cppNew(1));
    }
  }
  CppSet<CppList*>(
      cppThis, String::cppNew("_length"),
      Num::cpp_subtract(CppGet<Int*>(cppThis, String::cppNew("_length")),
                        Int::cppNew(1)));
  return reinterpret_cast<Object*>(element);
}

Object* CppList::removeLast(Object* cppThis) {
  if (CppApi::cppBoolValue(Object::cpp_equals(
          CppGet<Int*>(cppThis, String::cppNew("_length")), Int::cppNew(0))))
    throw "ConstructorInvocation(new StateError(No element))";
  return cppApply<Object*, Int*>(
      cppThis, String::cppNew("removeAt"),
      Num::cpp_subtract(CppGet<Int*>(cppThis, String::cppNew("_length")),
                        Int::cppNew(1)));
}

void CppList::removeRange(Object* cppThis, Int* start, Int* end) {
  if (CppApi::cppBoolValue(
          CppApi::cppBoolValue(
              CppApi::cppBoolValue(
                  CppApi::cppBoolValue(
                      Num::cpp_lessThan(start, Int::cppNew(0))) ||
                  CppApi::cppBoolValue(Num::cpp_greaterThan(
                      start,
                      CppGet<Int*>(cppThis, String::cppNew("_length"))))) ||
              CppApi::cppBoolValue(Num::cpp_lessThan(end, start))) ||
          CppApi::cppBoolValue(Num::cpp_greaterThan(
              end, CppGet<Int*>(cppThis, String::cppNew("_length")))))) {
    throw "ConstructorInvocation(new RangeError.range(start, 0, this.{CppList._length}))";
  }
  Int* length = Num::cpp_subtract(end, start);
  {
    Int* i = start;
    while (CppApi::cppBoolValue(Num::cpp_lessThan(
        i, Num::cpp_subtract(CppGet<Int*>(cppThis, String::cppNew("_length")),
                             length)))) {
      {
        cppApply<void, Int*, Object*>(
            CppGet<Object*>(cppThis, String::cppNew("_array")),
            String::cppNew("setItem"), i,
            cppApply<Object*, Int*>(
                CppGet<Object*>(cppThis, String::cppNew("_array")),
                String::cppNew("getItem"), Num::cpp_add(i, length)));
      }
      i = Num::cpp_add(i, Int::cppNew(1));
    }
  }
  CppSet<CppList*>(
      cppThis, String::cppNew("_length"),
      Num::cpp_subtract(CppGet<Int*>(cppThis, String::cppNew("_length")),
                        length));
}

void CppList::removeWhere(Object* cppThis, Function* test) {
  Int* writeIndex = Int::cppNew(0);
  {
    Int* readIndex = Int::cppNew(0);
    while (CppApi::cppBoolValue(Num::cpp_lessThan(
        readIndex, CppGet<Int*>(cppThis, String::cppNew("_length"))))) {
      {
        if (CppApi::cppBoolValue(Bool::cpp_not(cppApply<Bool*>(
                test, reinterpret_cast<Object*>(cppApply<Object*, Int*>(
                          CppGet<Object*>(cppThis, String::cppNew("_array")),
                          String::cppNew("getItem"), readIndex)))))) {
          if (CppApi::cppBoolValue(
                  Bool::cpp_not(Object::cpp_equals(writeIndex, readIndex)))) {
            cppApply<void, Int*, Object*>(
                CppGet<Object*>(cppThis, String::cppNew("_array")),
                String::cppNew("setItem"), writeIndex,
                cppApply<Object*, Int*>(
                    CppGet<Object*>(cppThis, String::cppNew("_array")),
                    String::cppNew("getItem"), readIndex));
          }
          writeIndex = Num::cpp_add(writeIndex, Int::cppNew(1));
        }
      }
      readIndex = Num::cpp_add(readIndex, Int::cppNew(1));
    }
  }
  CppSet<CppList*>(cppThis, String::cppNew("_length"), writeIndex);
}

void CppList::replaceRange(Object* cppThis,
                           Int* start,
                           Int* end,
                           Object* replacements) {
  if (CppApi::cppBoolValue(
          CppApi::cppBoolValue(
              CppApi::cppBoolValue(
                  CppApi::cppBoolValue(
                      Num::cpp_lessThan(start, Int::cppNew(0))) ||
                  CppApi::cppBoolValue(Num::cpp_greaterThan(
                      start,
                      CppGet<Int*>(cppThis, String::cppNew("_length"))))) ||
              CppApi::cppBoolValue(Num::cpp_lessThan(end, start))) ||
          CppApi::cppBoolValue(Num::cpp_greaterThan(
              end, CppGet<Int*>(cppThis, String::cppNew("_length")))))) {
    throw "ConstructorInvocation(new RangeError.range(start, 0, this.{CppList._length}))";
  }
  Object* replacementList =
      cppApply<Object*, Bool*>(replacements, String::cppNew("toList"), nullptr);
  Int* replacementLength =
      cppApply<Int*>(replacementList, String::cppNew("cppGet_length"));
  Int* rangeLength = Num::cpp_subtract(end, start);
  if (CppApi::cppBoolValue(
          Num::cpp_greaterThan(replacementLength, rangeLength))) {
    cppApply<void, Int*>(
        cppThis, String::cppNew("ensureCapacity"),
        Num::cpp_subtract(
            Num::cpp_add(CppGet<Int*>(cppThis, String::cppNew("_length")),
                         replacementLength),
            rangeLength));
  }
  if (CppApi::cppBoolValue(
          Bool::cpp_not(Object::cpp_equals(replacementLength, rangeLength)))) {
    {
      Int* i = Num::cpp_subtract(
          CppGet<Int*>(cppThis, String::cppNew("_length")), Int::cppNew(1));
      while (CppApi::cppBoolValue(Num::cpp_greaterThanOrEqual(i, end))) {
        {
          cppApply<void, Int*, Object*>(
              CppGet<Object*>(cppThis, String::cppNew("_array")),
              String::cppNew("setItem"),
              Num::cpp_subtract(Num::cpp_add(i, replacementLength),
                                rangeLength),
              cppApply<Object*, Int*>(
                  CppGet<Object*>(cppThis, String::cppNew("_array")),
                  String::cppNew("getItem"), i));
        }
        i = Num::cpp_subtract(i, Int::cppNew(1));
      }
    }
  }
  {
    Int* i = Int::cppNew(0);
    while (CppApi::cppBoolValue(Num::cpp_lessThan(i, replacementLength))) {
      {
        cppApply<void, Int*, Object*>(
            CppGet<Object*>(cppThis, String::cppNew("_array")),
            String::cppNew("setItem"), Num::cpp_add(start, i),
            cppApply<Object*, Int*>(replacementList,
                                    String::cppNew("cpp_subscript"), i));
      }
      i = Num::cpp_add(i, Int::cppNew(1));
    }
  }
  CppSet<CppList*>(
      cppThis, String::cppNew("_length"),
      Num::cpp_add(CppGet<Int*>(cppThis, String::cppNew("_length")),
                   Num::cpp_subtract(replacementLength, rangeLength)));
}

void CppList::retainWhere(Object* cppThis, Function* test) {
  Int* writeIndex = Int::cppNew(0);
  {
    Int* readIndex = Int::cppNew(0);
    while (CppApi::cppBoolValue(Num::cpp_lessThan(
        readIndex, CppGet<Int*>(cppThis, String::cppNew("_length"))))) {
      {
        if (CppApi::cppBoolValue(cppApply<Bool*>(
                test, reinterpret_cast<Object*>(cppApply<Object*, Int*>(
                          CppGet<Object*>(cppThis, String::cppNew("_array")),
                          String::cppNew("getItem"), readIndex))))) {
          if (CppApi::cppBoolValue(
                  Bool::cpp_not(Object::cpp_equals(writeIndex, readIndex)))) {
            cppApply<void, Int*, Object*>(
                CppGet<Object*>(cppThis, String::cppNew("_array")),
                String::cppNew("setItem"), writeIndex,
                cppApply<Object*, Int*>(
                    CppGet<Object*>(cppThis, String::cppNew("_array")),
                    String::cppNew("getItem"), readIndex));
          }
          writeIndex = Num::cpp_add(writeIndex, Int::cppNew(1));
        }
      }
      readIndex = Num::cpp_add(readIndex, Int::cppNew(1));
    }
  }
  CppSet<CppList*>(cppThis, String::cppNew("_length"), writeIndex);
}

Object* CppList::cppGet_reversed(Object* cppThis) {
  return Iterable::generate(
      CppGet<Int*>(cppThis, String::cppNew("_length")),
      new LambdaWrapper<Object*, Int*>([&](Int* i) -> Object* {
        return reinterpret_cast<Object*>(cppApply<Object*, Int*>(
            CppGet<Object*>(cppThis, String::cppNew("_array")),
            String::cppNew("getItem"),
            Num::cpp_subtract(
                Num::cpp_subtract(
                    CppGet<Int*>(cppThis, String::cppNew("_length")),
                    Int::cppNew(1)),
                i)));
      }));
}

void CppList::setAll(Object* cppThis, Int* index, Object* iterable) {
  if (CppApi::cppBoolValue(
          CppApi::cppBoolValue(Num::cpp_lessThan(index, Int::cppNew(0))) ||
          CppApi::cppBoolValue(Num::cpp_greaterThan(
              index, CppGet<Int*>(cppThis, String::cppNew("_length"))))))
    throw "ConstructorInvocation(new IndexError(index, this))";
  Int* i = index;
  {
    Object* $sync_for_iterator =
        cppApply<Object*>(iterable, String::cppNew("cppGet_iterator"));
    {
      while (CppApi::cppBoolValue(
          cppApply<Bool*>($sync_for_iterator, String::cppNew("moveNext")))) {
        {
          Object* element = cppApply<Object*>($sync_for_iterator,
                                              String::cppNew("cppGet_current"));
          {
            if (CppApi::cppBoolValue(Num::cpp_greaterThanOrEqual(
                    i, CppGet<Int*>(cppThis, String::cppNew("_length"))))) {
              cppApply<void, Object*>(cppThis, String::cppNew("add"), element);
            } else {
              cppApply<void, Int*, Object*>(
                  CppGet<Object*>(cppThis, String::cppNew("_array")),
                  String::cppNew("setItem"), i, element);
            }
            i = Num::cpp_add(i, Int::cppNew(1));
          }
        }
      }
    }
  }
}

void CppList::setRange(Object* cppThis,
                       Int* start,
                       Int* end,
                       Object* iterable,
                       Int* skipCount) {
  if (CppApi::cppBoolValue(
          CppApi::cppBoolValue(
              CppApi::cppBoolValue(
                  CppApi::cppBoolValue(
                      Num::cpp_lessThan(start, Int::cppNew(0))) ||
                  CppApi::cppBoolValue(Num::cpp_greaterThan(
                      start,
                      CppGet<Int*>(cppThis, String::cppNew("_length"))))) ||
              CppApi::cppBoolValue(Num::cpp_lessThan(end, start))) ||
          CppApi::cppBoolValue(Num::cpp_greaterThan(
              end, CppGet<Int*>(cppThis, String::cppNew("_length")))))) {
    throw "ConstructorInvocation(new RangeError.range(start, 0, this.{CppList._length}))";
  }
  Object* iterator =
      cppApply<Object*>(iterable, String::cppNew("cppGet_iterator"));
  {
    Int* i = Int::cppNew(0);
    while (CppApi::cppBoolValue(Num::cpp_lessThan(i, skipCount))) {
      {
        if (CppApi::cppBoolValue(Bool::cpp_not(
                cppApply<Bool*>(iterator, String::cppNew("moveNext")))))
          return;
      }
      i = Num::cpp_add(i, Int::cppNew(1));
    }
  }

  {
    Int* i = start;
    while (CppApi::cppBoolValue(Num::cpp_lessThan(i, end))) {
      {
        if (CppApi::cppBoolValue(Bool::cpp_not(
                cppApply<Bool*>(iterator, String::cppNew("moveNext")))))
          break;
        cppApply<void, Int*, Object*>(
            CppGet<Object*>(cppThis, String::cppNew("_array")),
            String::cppNew("setItem"), i,
            cppApply<Object*>(iterator, String::cppNew("cppGet_current")));
      }
      i = Num::cpp_add(i, Int::cppNew(1));
    }
  }
}

void CppList::shuffle(Object* cppThis, Object* random) {
  CppApi::cppBoolValue(Bool::cppNew(random == nullptr))
      ? random = Random::cppEpt_(nullptr)
      : nullptr;
  {
    Int* i = Num::cpp_subtract(CppGet<Int*>(cppThis, String::cppNew("_length")),
                               Int::cppNew(1));
    while (CppApi::cppBoolValue(Num::cpp_greaterThan(i, Int::cppNew(0)))) {
      {
        Int* j = cppApply<Int*, Int*>(random, String::cppNew("nextInt"),
                                      Num::cpp_add(i, Int::cppNew(1)));
        Object* temp = cppApply<Object*, Int*>(
            CppGet<Object*>(cppThis, String::cppNew("_array")),
            String::cppNew("getItem"), i);
        cppApply<void, Int*, Object*>(
            CppGet<Object*>(cppThis, String::cppNew("_array")),
            String::cppNew("setItem"), i,
            cppApply<Object*, Int*>(
                CppGet<Object*>(cppThis, String::cppNew("_array")),
                String::cppNew("getItem"), j));
        cppApply<void, Int*, Object*>(
            CppGet<Object*>(cppThis, String::cppNew("_array")),
            String::cppNew("setItem"), j, temp);
      }
      i = Num::cpp_subtract(i, Int::cppNew(1));
    }
  }
}

void CppList::sort(Object* cppThis, Function* compare) {
  if (CppApi::cppBoolValue(Num::cpp_lessThanOrEqual(
          CppGet<Int*>(cppThis, String::cppNew("_length")), Int::cppNew(1))))
    return;
  cppApply<void, Int*, Int*, Function*>(
      cppThis, String::cppNew("_quickSort"), Int::cppNew(0),
      Num::cpp_subtract(CppGet<Int*>(cppThis, String::cppNew("_length")),
                        Int::cppNew(1)),
      compare);
}

void CppList::_quickSort(Object* cppThis,
                         Int* low,
                         Int* high,
                         Function* compare) {
  if (CppApi::cppBoolValue(Num::cpp_lessThan(low, high))) {
    Int* pi = cppApply<Int*, Int*, Int*, Function*>(
        cppThis, String::cppNew("_partition"), low, high, compare);
    cppApply<void, Int*, Int*, Function*>(
        cppThis, String::cppNew("_quickSort"), low,
        Num::cpp_subtract(pi, Int::cppNew(1)), compare);
    cppApply<void, Int*, Int*, Function*>(cppThis, String::cppNew("_quickSort"),
                                          Num::cpp_add(pi, Int::cppNew(1)),
                                          high, compare);
  }
}

Int* CppList::_partition(Object* cppThis,
                         Int* low,
                         Int* high,
                         Function* compare) {
  Object* pivot = reinterpret_cast<Object*>(cppApply<Object*, Int*>(
      CppGet<Object*>(cppThis, String::cppNew("_array")),
      String::cppNew("getItem"), high));
  Int* i = Num::cpp_subtract(low, Int::cppNew(1));
  {
    Int* j = low;
    while (CppApi::cppBoolValue(Num::cpp_lessThan(j, high))) {
      {
        Object* current = reinterpret_cast<Object*>(cppApply<Object*, Int*>(
            CppGet<Object*>(cppThis, String::cppNew("_array")),
            String::cppNew("getItem"), j));
        Bool* shouldSwap;
        if (CppApi::cppBoolValue(
                Bool::cpp_not(Bool::cppNew(compare == nullptr)))) {
          shouldSwap = Num::cpp_lessThanOrEqual(
              cppApply<Int*>(compare, current, pivot), Int::cppNew(0));
        } else {
          shouldSwap = Num::cpp_lessThanOrEqual(
              cppApply<Int*, void**>(reinterpret_cast<Object*>(current),
                                     String::cppNew("compareTo"), pivot),
              Int::cppNew(0));
        }
        if (CppApi::cppBoolValue(shouldSwap)) {
          i = Num::cpp_add(i, Int::cppNew(1));
          cppApply<void, Int*, Int*>(cppThis, String::cppNew("_swap"), i, j);
        }
      }
      j = Num::cpp_add(j, Int::cppNew(1));
    }
  }
  cppApply<void, Int*, Int*>(cppThis, String::cppNew("_swap"),
                             Num::cpp_add(i, Int::cppNew(1)), high);
  return Num::cpp_add(i, Int::cppNew(1));
}

void CppList::_swap(Object* cppThis, Int* i, Int* j) {
  Object* temp = reinterpret_cast<Object*>(cppApply<Object*, Int*>(
      CppGet<Object*>(cppThis, String::cppNew("_array")),
      String::cppNew("getItem"), i));
  cppApply<void, Int*, Object*>(
      CppGet<Object*>(cppThis, String::cppNew("_array")),
      String::cppNew("setItem"), i,
      cppApply<Object*, Int*>(
          CppGet<Object*>(cppThis, String::cppNew("_array")),
          String::cppNew("getItem"), j));
  cppApply<void, Int*, Object*>(
      CppGet<Object*>(cppThis, String::cppNew("_array")),
      String::cppNew("setItem"), j, temp);
}

Object* CppList::sublist(Object* cppThis, Int* start, Int* end) {
  Int* endIndex = ([&]() {
    Int* cppLet_0 = end;
    return CppApi::cppBoolValue(Bool::cppNew(cppLet_0 == nullptr))
               ? CppGet<Int*>(cppThis, String::cppNew("_length"))
               : cppLet_0;
  })();
  if (CppApi::cppBoolValue(
          CppApi::cppBoolValue(
              CppApi::cppBoolValue(
                  CppApi::cppBoolValue(
                      Num::cpp_lessThan(start, Int::cppNew(0))) ||
                  CppApi::cppBoolValue(Num::cpp_greaterThan(
                      start,
                      CppGet<Int*>(cppThis, String::cppNew("_length"))))) ||
              CppApi::cppBoolValue(Num::cpp_lessThan(endIndex, start))) ||
          CppApi::cppBoolValue(Num::cpp_greaterThan(
              endIndex, CppGet<Int*>(cppThis, String::cppNew("_length")))))) {
    throw "ConstructorInvocation(new RangeError.range(start, 0, this.{CppList._length}))";
  }
  return CppList::from(
      Iterable::generate(
          Num::cpp_subtract(endIndex, start),
          new LambdaWrapper<Object*, Int*>([&](Int* i) -> Object* {
            return cppApply<Object*, Int*>(
                CppGet<Object*>(cppThis, String::cppNew("_array")),
                String::cppNew("getItem"), Num::cpp_add(start, i));
          })),
      Bool::cppNew(true));
}

Object* CppList::take(Object* cppThis, Int* count) {
  if (CppApi::cppBoolValue(Num::cpp_lessThan(count, Int::cppNew(0))))
    throw "ConstructorInvocation(new ArgumentError(Count must be positive))";
  return Iterable::generate(
      CppApi::cppBoolValue(Num::cpp_lessThan(
          count, CppGet<Int*>(cppThis, String::cppNew("_length"))))
          ? count
          : CppGet<Int*>(cppThis, String::cppNew("_length")),
      new LambdaWrapper<Object*, Int*>([&](Int* i) -> Object* {
        return reinterpret_cast<Object*>(cppApply<Object*, Int*>(
            CppGet<Object*>(cppThis, String::cppNew("_array")),
            String::cppNew("getItem"), i));
      }));
}

Object* CppList::takeWhile(Object* cppThis, Function* test) {
  {
    Int* i = Int::cppNew(0);
    while (CppApi::cppBoolValue(Num::cpp_lessThan(
        i, CppGet<Int*>(cppThis, String::cppNew("_length"))))) {
      {
        if (CppApi::cppBoolValue(Bool::cpp_not(cppApply<Bool*>(
                test, reinterpret_cast<Object*>(cppApply<Object*, Int*>(
                          CppGet<Object*>(cppThis, String::cppNew("_array")),
                          String::cppNew("getItem"), i)))))) {
          return Iterable::generate(
              i, new LambdaWrapper<Object*, Int*>([&](Int* j) -> Object* {
                return reinterpret_cast<Object*>(cppApply<Object*, Int*>(
                    CppGet<Object*>(cppThis, String::cppNew("_array")),
                    String::cppNew("getItem"), j));
              }));
        }
      }
      i = Num::cpp_add(i, Int::cppNew(1));
    }
  }
  return cppThis;
}

Object* CppList::toList(Object* cppThis, Bool* growable) {
  return CppList::from(cppThis, growable);
}

Object* CppList::toSet(Object* cppThis) {
  return LinkedHashSet::from(cppThis);
}

Object* CppList::where(Object* cppThis, Function* test) {
  Object* result = CppNewList(Int::cppNew(0));
  {
    Int* i = Int::cppNew(0);
    while (CppApi::cppBoolValue(Num::cpp_lessThan(
        i, CppGet<Int*>(cppThis, String::cppNew("_length"))))) {
      {
        Object* element = reinterpret_cast<Object*>(cppApply<Object*, Int*>(
            CppGet<Object*>(cppThis, String::cppNew("_array")),
            String::cppNew("getItem"), i));
        if (CppApi::cppBoolValue(cppApply<Bool*>(test, element))) {
          cppApply<void, Object*>(result, String::cppNew("add"), element);
        }
      }
      i = Num::cpp_add(i, Int::cppNew(1));
    }
  }
  return result;
}

Object* CppList::whereType(Object* cppThis) {
  Object* result = CppNewList(Int::cppNew(0));
  {
    Int* i = Int::cppNew(0);
    while (CppApi::cppBoolValue(Num::cpp_lessThan(
        i, CppGet<Int*>(cppThis, String::cppNew("_length"))))) {
      {
        Object* element = cppApply<Object*, Int*>(
            CppGet<Object*>(cppThis, String::cppNew("_array")),
            String::cppNew("getItem"), i);
        if (CppApi::cppBoolValue(
                Bool::cppNew(reinterpret_cast<Object*>(element) == nullptr))) {
          cppApply<void, Object*>(result, String::cppNew("add"), element);
        }
      }
      i = Num::cpp_add(i, Int::cppNew(1));
    }
  }
  return result;
}

Object* CppList::singleWhere(Object* cppThis,
                             Function* test,
                             Function* orElse) {
  Object* result;
  Bool* found = Bool::cppNew(false);
  {
    Int* i = Int::cppNew(0);
    while (CppApi::cppBoolValue(Num::cpp_lessThan(
        i, CppGet<Int*>(cppThis, String::cppNew("_length"))))) {
      {
        if (CppApi::cppBoolValue(cppApply<Bool*>(
                test, reinterpret_cast<Object*>(cppApply<Object*, Int*>(
                          CppGet<Object*>(cppThis, String::cppNew("_array")),
                          String::cppNew("getItem"), i))))) {
          if (CppApi::cppBoolValue(found))
            throw "ConstructorInvocation(new StateError(Too many elements))";
          result = reinterpret_cast<Object*>(cppApply<Object*, Int*>(
              CppGet<Object*>(cppThis, String::cppNew("_array")),
              String::cppNew("getItem"), i));
          found = Bool::cppNew(true);
        }
      }
      i = Num::cpp_add(i, Int::cppNew(1));
    }
  }
  if (CppApi::cppBoolValue(found)) return result;
  if (CppApi::cppBoolValue(Bool::cpp_not(Bool::cppNew(orElse == nullptr))))
    return cppApply<Object*>(orElse);
  throw "ConstructorInvocation(new StateError(No element))";
}

Object* CppList::skip(Object* cppThis, Int* count) {
  if (CppApi::cppBoolValue(Num::cpp_lessThan(count, Int::cppNew(0))))
    throw "ConstructorInvocation(new ArgumentError(Count must be positive))";
  return Iterable::generate(
      CppApi::cppBoolValue(Num::cpp_greaterThan(
          Num::cpp_subtract(CppGet<Int*>(cppThis, String::cppNew("_length")),
                            count),
          Int::cppNew(0)))
          ? Num::cpp_subtract(CppGet<Int*>(cppThis, String::cppNew("_length")),
                              count)
          : Int::cppNew(0),
      new LambdaWrapper<Object*, Int*>([&](Int* i) -> Object* {
        return reinterpret_cast<Object*>(cppApply<Object*, Int*>(
            CppGet<Object*>(cppThis, String::cppNew("_array")),
            String::cppNew("getItem"), Num::cpp_add(count, i)));
      }));
}

Object* CppList::skipWhile(Object* cppThis, Function* test) {
  Int* skipCount = Int::cppNew(0);

  {
    Int* i = Int::cppNew(0);
    while (CppApi::cppBoolValue(Num::cpp_lessThan(
        i, CppGet<Int*>(cppThis, String::cppNew("_length"))))) {
      {
        if (CppApi::cppBoolValue(Bool::cpp_not(cppApply<Bool*>(
                test, reinterpret_cast<Object*>(cppApply<Object*, Int*>(
                          CppGet<Object*>(cppThis, String::cppNew("_array")),
                          String::cppNew("getItem"), i))))))
          break;
        skipCount = Num::cpp_add(skipCount, Int::cppNew(1));
      }
      i = Num::cpp_add(i, Int::cppNew(1));
    }
  }
  return Iterable::generate(
      Num::cpp_subtract(CppGet<Int*>(cppThis, String::cppNew("_length")),
                        skipCount),
      new LambdaWrapper<Object*, Int*>([&](Int* i) -> Object* {
        return reinterpret_cast<Object*>(cppApply<Object*, Int*>(
            CppGet<Object*>(cppThis, String::cppNew("_array")),
            String::cppNew("getItem"), Num::cpp_add(skipCount, i)));
      }));
}

Object* CppList::cpp_add(Object* cppThis, Object* other) {
  Object* result = CppList::cppCtr_(
      CppList::cppNew(), Int::cppNew(0),
      Num::cpp_add(CppGet<Int*>(cppThis, String::cppNew("_length")),
                   cppApply<Int*>(other, String::cppNew("cppGet_length"))));
  {
    Int* i = Int::cppNew(0);
    while (CppApi::cppBoolValue(Num::cpp_lessThan(
        i, CppGet<Int*>(cppThis, String::cppNew("_length"))))) {
      {
        cppApply<void, Object*>(
            result, String::cppNew("add"),
            reinterpret_cast<Object*>(cppApply<Object*, Int*>(
                CppGet<Object*>(cppThis, String::cppNew("_array")),
                String::cppNew("getItem"), i)));
      }
      i = Num::cpp_add(i, Int::cppNew(1));
    }
  }
  {
    Object* $sync_for_iterator =
        cppApply<Object*>(other, String::cppNew("cppGet_iterator"));
    {
      while (CppApi::cppBoolValue(
          cppApply<Bool*>($sync_for_iterator, String::cppNew("moveNext")))) {
        {
          Object* element = cppApply<Object*>($sync_for_iterator,
                                              String::cppNew("cppGet_current"));
          { cppApply<void, Object*>(result, String::cppNew("add"), element); }
        }
      }
    }
  }
  return result;
}

String* CppList::toString(Object* cppThis) {
  if (CppApi::cppBoolValue(Object::cpp_equals(
          CppGet<Int*>(cppThis, String::cppNew("_length")), Int::cppNew(0))))
    return String::cppNew("[]");
  Object* buffer =
      StringBuffer::cppCtr_(StringBuffer::cppNew(), String::cppNew("["));
  cppApply<void, Object*>(
      buffer, String::cppNew("write"),
      cppApply<Object*, Int*>(
          CppGet<Object*>(cppThis, String::cppNew("_array")),
          String::cppNew("getItem"), Int::cppNew(0)));
  {
    Int* i = Int::cppNew(1);
    while (CppApi::cppBoolValue(Num::cpp_lessThan(
        i, CppGet<Int*>(cppThis, String::cppNew("_length"))))) {
      {
        cppApply<void, Object*>(buffer, String::cppNew("write"),
                                String::cppNew(", "));
        cppApply<void, Object*>(
            buffer, String::cppNew("write"),
            cppApply<Object*, Int*>(
                CppGet<Object*>(cppThis, String::cppNew("_array")),
                String::cppNew("getItem"), i));
      }
      i = Num::cpp_add(i, Int::cppNew(1));
    }
  }
  cppApply<void, Object*>(buffer, String::cppNew("write"), String::cppNew("]"));
  return cppApply<String*>(buffer, String::cppNew("toString"));
}

Object* CppList::cppNew() {
  static std::map<String*, void*> v_ptrs = {
      {String::cppNew("toString"), reinterpret_cast<void*>(&CppList::toString)},
      {String::cppNew("cppGet_length"),
       reinterpret_cast<void*>(&List::cppGet_length)},
      {String::cppNew("ensureCapacity"),
       reinterpret_cast<void*>(&CppList::ensureCapacity)},
      {String::cppNew("cppSet_length"),
       reinterpret_cast<void*>(&List::cppSet_length)},
      {String::cppNew("cpp_subscript"),
       reinterpret_cast<void*>(&List::cpp_subscript)},
      {String::cppNew("cpp_subscriptAssign"),
       reinterpret_cast<void*>(&List::cpp_subscriptAssign)},
      {String::cppNew("add"), reinterpret_cast<void*>(&List::add)},
      {String::cppNew("addAll"), reinterpret_cast<void*>(&List::addAll)},
      {String::cppNew("any"), reinterpret_cast<void*>(&CppList::any)},
      {String::cppNew("asMap"), reinterpret_cast<void*>(&List::asMap)},
      {String::cppNew("cast"), reinterpret_cast<void*>(&List::cast)},
      {String::cppNew("clear"), reinterpret_cast<void*>(&List::clear)},
      {String::cppNew("contains"), reinterpret_cast<void*>(&CppList::contains)},
      {String::cppNew("elementAt"),
       reinterpret_cast<void*>(&CppList::elementAt)},
      {String::cppNew("every"), reinterpret_cast<void*>(&CppList::every)},
      {String::cppNew("expand"), reinterpret_cast<void*>(&CppList::expand)},
      {String::cppNew("fillRange"), reinterpret_cast<void*>(&List::fillRange)},
      {String::cppNew("firstWhere"),
       reinterpret_cast<void*>(&CppList::firstWhere)},
      {String::cppNew("fold"), reinterpret_cast<void*>(&CppList::fold)},
      {String::cppNew("followedBy"),
       reinterpret_cast<void*>(&CppList::followedBy)},
      {String::cppNew("forEach"), reinterpret_cast<void*>(&CppList::forEach)},
      {String::cppNew("getRange"), reinterpret_cast<void*>(&List::getRange)},
      {String::cppNew("indexOf"), reinterpret_cast<void*>(&List::indexOf)},
      {String::cppNew("indexWhere"),
       reinterpret_cast<void*>(&List::indexWhere)},
      {String::cppNew("insert"), reinterpret_cast<void*>(&List::insert)},
      {String::cppNew("insertAll"), reinterpret_cast<void*>(&List::insertAll)},
      {String::cppNew("cppGet_first"),
       reinterpret_cast<void*>(&CppList::cppGet_first)},
      {String::cppNew("cppSet_first"),
       reinterpret_cast<void*>(&List::cppSet_first)},
      {String::cppNew("cppGet_last"),
       reinterpret_cast<void*>(&CppList::cppGet_last)},
      {String::cppNew("cppSet_last"),
       reinterpret_cast<void*>(&List::cppSet_last)},
      {String::cppNew("cppGet_single"),
       reinterpret_cast<void*>(&CppList::cppGet_single)},
      {String::cppNew("cppGet_isEmpty"),
       reinterpret_cast<void*>(&CppList::cppGet_isEmpty)},
      {String::cppNew("cppGet_isNotEmpty"),
       reinterpret_cast<void*>(&CppList::cppGet_isNotEmpty)},
      {String::cppNew("cppGet_iterator"),
       reinterpret_cast<void*>(&CppList::cppGet_iterator)},
      {String::cppNew("join"), reinterpret_cast<void*>(&CppList::join)},
      {String::cppNew("lastIndexOf"),
       reinterpret_cast<void*>(&List::lastIndexOf)},
      {String::cppNew("lastIndexWhere"),
       reinterpret_cast<void*>(&List::lastIndexWhere)},
      {String::cppNew("lastWhere"),
       reinterpret_cast<void*>(&CppList::lastWhere)},
      {String::cppNew("map"), reinterpret_cast<void*>(&CppList::map)},
      {String::cppNew("reduce"), reinterpret_cast<void*>(&CppList::reduce)},
      {String::cppNew("remove"), reinterpret_cast<void*>(&List::remove)},
      {String::cppNew("removeAt"), reinterpret_cast<void*>(&List::removeAt)},
      {String::cppNew("removeLast"),
       reinterpret_cast<void*>(&List::removeLast)},
      {String::cppNew("removeRange"),
       reinterpret_cast<void*>(&List::removeRange)},
      {String::cppNew("removeWhere"),
       reinterpret_cast<void*>(&List::removeWhere)},
      {String::cppNew("replaceRange"),
       reinterpret_cast<void*>(&List::replaceRange)},
      {String::cppNew("retainWhere"),
       reinterpret_cast<void*>(&List::retainWhere)},
      {String::cppNew("cppGet_reversed"),
       reinterpret_cast<void*>(&List::cppGet_reversed)},
      {String::cppNew("setAll"), reinterpret_cast<void*>(&List::setAll)},
      {String::cppNew("setRange"), reinterpret_cast<void*>(&List::setRange)},
      {String::cppNew("shuffle"), reinterpret_cast<void*>(&List::shuffle)},
      {String::cppNew("sort"), reinterpret_cast<void*>(&List::sort)},
      {String::cppNew("_quickSort"),
       reinterpret_cast<void*>(&CppList::_quickSort)},
      {String::cppNew("_partition"),
       reinterpret_cast<void*>(&CppList::_partition)},
      {String::cppNew("_swap"), reinterpret_cast<void*>(&CppList::_swap)},
      {String::cppNew("sublist"), reinterpret_cast<void*>(&List::sublist)},
      {String::cppNew("take"), reinterpret_cast<void*>(&CppList::take)},
      {String::cppNew("takeWhile"),
       reinterpret_cast<void*>(&CppList::takeWhile)},
      {String::cppNew("toList"), reinterpret_cast<void*>(&CppList::toList)},
      {String::cppNew("toSet"), reinterpret_cast<void*>(&CppList::toSet)},
      {String::cppNew("where"), reinterpret_cast<void*>(&CppList::where)},
      {String::cppNew("whereType"),
       reinterpret_cast<void*>(&CppList::whereType)},
      {String::cppNew("singleWhere"),
       reinterpret_cast<void*>(&CppList::singleWhere)},
      {String::cppNew("skip"), reinterpret_cast<void*>(&CppList::skip)},
      {String::cppNew("skipWhile"),
       reinterpret_cast<void*>(&CppList::skipWhile)},
      {String::cppNew("cpp_add"), reinterpret_cast<void*>(&List::cpp_add)},
      {String::cppNew("cpp_equals"),
       reinterpret_cast<void*>(&List::cpp_equals)}};
  static Type* runtimeType = new Type("CppList");
  Object* ptr = new ObjectImp(const_cast<Type*>(runtimeType), &v_ptrs);
  return ptr;
}

//  library file:///Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/test/list.dart
Object* _CppListIterator::cppCtr_(Object* cppThis, Object* _list) {
  CppSet<Object*>(cppThis, String::cppNew("_list"), _list);

  return cppThis;
}

Object* _CppListIterator::cppGet_current(Object* cppThis) {
  return cppApply<Object*, Int*>(
      CppGet<Object*>(cppThis, String::cppNew("_list")),
      String::cppNew("cpp_subscript"),
      CppGet<Int*>(cppThis, String::cppNew("_index")));
}

Bool* _CppListIterator::moveNext(Object* cppThis) {
  CppSet<_CppListIterator*>(
      cppThis, String::cppNew("_index"),
      Num::cpp_add(CppGet<Int*>(cppThis, String::cppNew("_index")),
                   Int::cppNew(1)));
  return Num::cpp_lessThan(
      CppGet<Int*>(cppThis, String::cppNew("_index")),
      cppApply<Int*>(CppGet<Object*>(cppThis, String::cppNew("_list")),
                     String::cppNew("cppGet_length")));
}

Object* _CppListIterator::cppNew() {
  static std::map<String*, void*> v_ptrs = {
      {String::cppNew("toString"), reinterpret_cast<void*>(&Object::toString)},
      {String::cppNew("cppGet_current"),
       reinterpret_cast<void*>(&Iterator::cppGet_current)},
      {String::cppNew("moveNext"),
       reinterpret_cast<void*>(&Iterator::moveNext)}};
  static Type* runtimeType = new Type("_CppListIterator");
  Object* ptr = new ObjectImp(const_cast<Type*>(runtimeType), &v_ptrs);
  return ptr;
}

//  library file:///Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/test/list.dart
Object* CppSet::cppCtr_fromCppArray(Object* cppThis, Object* array) {
  CppSet<Object*>(cppThis, String::cppNew("_list"),
                  CppList::cppCtr_fromCppArray(CppList::cppNew(), array));

  return cppThis;
}

Object* CppSet::cppCtr_(Object* cppThis, Int* capacity) {
  CppSet<Object*>(
      cppThis, String::cppNew("_list"),
      CppList::cppCtr_(CppList::cppNew(), Int::cppNew(0), capacity));

  return cppThis;
}

Object* CppSet::identity() {
  return CppSet::cppCtr_(CppSet::cppNew(), Int::cppNew(4));
}

Object* CppSet::from(Object* elements) {
  Object* set = CppSet::cppCtr_(CppSet::cppNew(), Int::cppNew(4));
  {
    Object* $sync_for_iterator =
        cppApply<Object*>(elements, String::cppNew("cppGet_iterator"));
    {
      while (CppApi::cppBoolValue(
          cppApply<Bool*>($sync_for_iterator, String::cppNew("moveNext")))) {
        {
          void** element = cppApply<void**>($sync_for_iterator,
                                            String::cppNew("cppGet_current"));
          {
            cppApply<Bool*, Object*>(set, String::cppNew("add"),
                                     reinterpret_cast<Object*>(element));
          }
        }
      }
    }
  }
  return set;
}

Object* CppSet::of(Object* elements) {
  return CppSet::from(elements);
}

Object* CppSet::unmodifiable(Object* elements) {
  Object* set = CppSet::cppCtr_(CppSet::cppNew(), Int::cppNew(4));
  {
    Object* $sync_for_iterator =
        cppApply<Object*>(elements, String::cppNew("cppGet_iterator"));
    {
      while (CppApi::cppBoolValue(
          cppApply<Bool*>($sync_for_iterator, String::cppNew("moveNext")))) {
        {
          Object* element = cppApply<Object*>($sync_for_iterator,
                                              String::cppNew("cppGet_current"));
          { cppApply<Bool*, Object*>(set, String::cppNew("add"), element); }
        }
      }
    }
  }
  return set;
}

Bool* CppSet::add(Object* cppThis, Object* value) {
  if (CppApi::cppBoolValue(cppApply<Bool*, Object*>(
          cppThis, String::cppNew("contains"), value))) {
    return Bool::cppNew(false);
  }
  cppApply<void, Object*>(CppGet<Object*>(cppThis, String::cppNew("_list")),
                          String::cppNew("add"), value);
  return Bool::cppNew(true);
}

void CppSet::addAll(Object* cppThis, Object* elements) {
  {
    Object* $sync_for_iterator =
        cppApply<Object*>(elements, String::cppNew("cppGet_iterator"));
    {
      while (CppApi::cppBoolValue(
          cppApply<Bool*>($sync_for_iterator, String::cppNew("moveNext")))) {
        {
          Object* element = cppApply<Object*>($sync_for_iterator,
                                              String::cppNew("cppGet_current"));
          { cppApply<Bool*, Object*>(cppThis, String::cppNew("add"), element); }
        }
      }
    }
  }
}

Bool* CppSet::any(Object* cppThis, Function* test) {
  {
    Object* $sync_for_iterator =
        cppApply<Object*>(CppGet<Object*>(cppThis, String::cppNew("_list")),
                          String::cppNew("cppGet_iterator"));
    {
      while (CppApi::cppBoolValue(
          cppApply<Bool*>($sync_for_iterator, String::cppNew("moveNext")))) {
        {
          Object* element = cppApply<Object*>($sync_for_iterator,
                                              String::cppNew("cppGet_current"));
          {
            if (CppApi::cppBoolValue(cppApply<Bool*>(test, element)))
              return Bool::cppNew(true);
          }
        }
      }
    }
  }
  return Bool::cppNew(false);
}

Object* CppSet::cast(Object* cppThis) {
  return Set::castFrom(cppThis, nullptr);
}

void CppSet::clear(Object* cppThis) {
  cppApply<void>(CppGet<Object*>(cppThis, String::cppNew("_list")),
                 String::cppNew("clear"));
}

Bool* CppSet::contains(Object* cppThis, Object* element) {
  {
    Int* i = Int::cppNew(0);
    while (CppApi::cppBoolValue(Num::cpp_lessThan(
        i, cppApply<Int*>(CppGet<Object*>(cppThis, String::cppNew("_list")),
                          String::cppNew("cppGet_length"))))) {
      {
        if (CppApi::cppBoolValue(Object::cpp_equals(
                element, cppApply<Object*, Int*>(
                             CppGet<Object*>(cppThis, String::cppNew("_list")),
                             String::cppNew("cpp_subscript"), i)))) {
          return Bool::cppNew(true);
        }
      }
      i = Num::cpp_add(i, Int::cppNew(1));
    }
  }
  return Bool::cppNew(false);
}

Bool* CppSet::containsAll(Object* cppThis, Object* other) {
  {
    Object* $sync_for_iterator =
        cppApply<Object*>(other, String::cppNew("cppGet_iterator"));
    {
      while (CppApi::cppBoolValue(
          cppApply<Bool*>($sync_for_iterator, String::cppNew("moveNext")))) {
        {
          Object* element = cppApply<Object*>($sync_for_iterator,
                                              String::cppNew("cppGet_current"));
          {
            if (CppApi::cppBoolValue(Bool::cpp_not(cppApply<Bool*, Object*>(
                    cppThis, String::cppNew("contains"), element))))
              return Bool::cppNew(false);
          }
        }
      }
    }
  }
  return Bool::cppNew(true);
}

Object* CppSet::difference(Object* cppThis, Object* other) {
  Object* result = CppSet::cppCtr_(CppSet::cppNew(), Int::cppNew(4));
  {
    Object* $sync_for_iterator =
        cppApply<Object*>(CppGet<Object*>(cppThis, String::cppNew("_list")),
                          String::cppNew("cppGet_iterator"));
    {
      while (CppApi::cppBoolValue(
          cppApply<Bool*>($sync_for_iterator, String::cppNew("moveNext")))) {
        {
          Object* element = cppApply<Object*>($sync_for_iterator,
                                              String::cppNew("cppGet_current"));
          {
            if (CppApi::cppBoolValue(Bool::cpp_not(cppApply<Bool*, Object*>(
                    other, String::cppNew("contains"), element)))) {
              cppApply<Bool*, Object*>(result, String::cppNew("add"), element);
            }
          }
        }
      }
    }
  }
  return result;
}

Object* CppSet::elementAt(Object* cppThis, Int* index) {
  return cppApply<Object*, Int*>(
      CppGet<Object*>(cppThis, String::cppNew("_list")),
      String::cppNew("elementAt"), index);
}

Bool* CppSet::every(Object* cppThis, Function* test) {
  {
    Object* $sync_for_iterator =
        cppApply<Object*>(CppGet<Object*>(cppThis, String::cppNew("_list")),
                          String::cppNew("cppGet_iterator"));
    {
      while (CppApi::cppBoolValue(
          cppApply<Bool*>($sync_for_iterator, String::cppNew("moveNext")))) {
        {
          Object* element = cppApply<Object*>($sync_for_iterator,
                                              String::cppNew("cppGet_current"));
          {
            if (CppApi::cppBoolValue(
                    Bool::cpp_not(cppApply<Bool*>(test, element))))
              return Bool::cppNew(false);
          }
        }
      }
    }
  }
  return Bool::cppNew(true);
}

Object* CppSet::expand(Object* cppThis, Function* toElements) {
  Object* result = CppNewList(Int::cppNew(0));
  {
    Object* $sync_for_iterator =
        cppApply<Object*>(CppGet<Object*>(cppThis, String::cppNew("_list")),
                          String::cppNew("cppGet_iterator"));
    {
      while (CppApi::cppBoolValue(
          cppApply<Bool*>($sync_for_iterator, String::cppNew("moveNext")))) {
        {
          Object* element = cppApply<Object*>($sync_for_iterator,
                                              String::cppNew("cppGet_current"));
          {
            cppApply<void, Object*>(result, String::cppNew("addAll"),
                                    cppApply<Object*>(toElements, element));
          }
        }
      }
    }
  }
  return result;
}

Object* CppSet::firstWhere(Object* cppThis, Function* test, Function* orElse) {
  {
    Object* $sync_for_iterator =
        cppApply<Object*>(CppGet<Object*>(cppThis, String::cppNew("_list")),
                          String::cppNew("cppGet_iterator"));
    {
      while (CppApi::cppBoolValue(
          cppApply<Bool*>($sync_for_iterator, String::cppNew("moveNext")))) {
        {
          Object* element = cppApply<Object*>($sync_for_iterator,
                                              String::cppNew("cppGet_current"));
          {
            if (CppApi::cppBoolValue(cppApply<Bool*>(test, element)))
              return element;
          }
        }
      }
    }
  }
  if (CppApi::cppBoolValue(Bool::cpp_not(Bool::cppNew(orElse == nullptr))))
    return cppApply<Object*>(orElse);
  throw "ConstructorInvocation(new StateError(No element))";
}

Object* CppSet::fold(Object* cppThis, Object* initialValue, Function* combine) {
  Object* value = initialValue;
  {
    Object* $sync_for_iterator =
        cppApply<Object*>(CppGet<Object*>(cppThis, String::cppNew("_list")),
                          String::cppNew("cppGet_iterator"));
    {
      while (CppApi::cppBoolValue(
          cppApply<Bool*>($sync_for_iterator, String::cppNew("moveNext")))) {
        {
          Object* element = cppApply<Object*>($sync_for_iterator,
                                              String::cppNew("cppGet_current"));
          { value = cppApply<Object*>(combine, value, element); }
        }
      }
    }
  }
  return value;
}

Object* CppSet::followedBy(Object* cppThis, Object* other) {
  return [&] {
    Object* cppLet_0 = List::of(cppThis, Bool::cppNew(true));
    cppApply<void, Object*>(cppLet_0, String::cppNew("addAll"), other);
    return cppLet_0;
  }();
}

void CppSet::forEach(Object* cppThis, Function* action) {
  {
    Object* $sync_for_iterator =
        cppApply<Object*>(CppGet<Object*>(cppThis, String::cppNew("_list")),
                          String::cppNew("cppGet_iterator"));
    {
      while (CppApi::cppBoolValue(
          cppApply<Bool*>($sync_for_iterator, String::cppNew("moveNext")))) {
        {
          Object* element = cppApply<Object*>($sync_for_iterator,
                                              String::cppNew("cppGet_current"));
          { cppApply<void>(action, element); }
        }
      }
    }
  }
}

Object* CppSet::intersection(Object* cppThis, Object* other) {
  Object* result = CppSet::cppCtr_(CppSet::cppNew(), Int::cppNew(4));
  {
    Object* $sync_for_iterator =
        cppApply<Object*>(CppGet<Object*>(cppThis, String::cppNew("_list")),
                          String::cppNew("cppGet_iterator"));
    {
      while (CppApi::cppBoolValue(
          cppApply<Bool*>($sync_for_iterator, String::cppNew("moveNext")))) {
        {
          Object* element = cppApply<Object*>($sync_for_iterator,
                                              String::cppNew("cppGet_current"));
          {
            if (CppApi::cppBoolValue(cppApply<Bool*, Object*>(
                    other, String::cppNew("contains"), element))) {
              cppApply<Bool*, Object*>(result, String::cppNew("add"), element);
            }
          }
        }
      }
    }
  }
  return result;
}

Object* CppSet::cppGet_first(Object* cppThis) {
  if (CppApi::cppBoolValue(
          cppApply<Bool*>(CppGet<Object*>(cppThis, String::cppNew("_list")),
                          String::cppNew("cppGet_isEmpty"))))
    throw "ConstructorInvocation(new StateError(No element))";
  return cppApply<Object*>(CppGet<Object*>(cppThis, String::cppNew("_list")),
                           String::cppNew("cppGet_first"));
}

Object* CppSet::cppGet_last(Object* cppThis) {
  if (CppApi::cppBoolValue(
          cppApply<Bool*>(CppGet<Object*>(cppThis, String::cppNew("_list")),
                          String::cppNew("cppGet_isEmpty"))))
    throw "ConstructorInvocation(new StateError(No element))";
  return cppApply<Object*>(CppGet<Object*>(cppThis, String::cppNew("_list")),
                           String::cppNew("cppGet_last"));
}

Object* CppSet::cppGet_single(Object* cppThis) {
  if (CppApi::cppBoolValue(
          cppApply<Bool*>(CppGet<Object*>(cppThis, String::cppNew("_list")),
                          String::cppNew("cppGet_isEmpty"))))
    throw "ConstructorInvocation(new StateError(No element))";
  if (CppApi::cppBoolValue(Num::cpp_greaterThan(
          cppApply<Int*>(CppGet<Object*>(cppThis, String::cppNew("_list")),
                         String::cppNew("cppGet_length")),
          Int::cppNew(1))))
    throw "ConstructorInvocation(new StateError(Too many elements))";
  return cppApply<Object*>(CppGet<Object*>(cppThis, String::cppNew("_list")),
                           String::cppNew("cppGet_single"));
}

Bool* CppSet::cppGet_isEmpty(Object* cppThis) {
  return cppApply<Bool*>(CppGet<Object*>(cppThis, String::cppNew("_list")),
                         String::cppNew("cppGet_isEmpty"));
}

Bool* CppSet::cppGet_isNotEmpty(Object* cppThis) {
  return cppApply<Bool*>(CppGet<Object*>(cppThis, String::cppNew("_list")),
                         String::cppNew("cppGet_isNotEmpty"));
}

Object* CppSet::cppGet_iterator(Object* cppThis) {
  return cppApply<Object*>(CppGet<Object*>(cppThis, String::cppNew("_list")),
                           String::cppNew("cppGet_iterator"));
}

String* CppSet::join(Object* cppThis, String* separator) {
  if (CppApi::cppBoolValue(
          cppApply<Bool*>(CppGet<Object*>(cppThis, String::cppNew("_list")),
                          String::cppNew("cppGet_isEmpty"))))
    return String::cppNew("");
  Object* buffer =
      StringBuffer::cppCtr_(StringBuffer::cppNew(), String::cppNew(""));
  Object* iterator =
      cppApply<Object*>(CppGet<Object*>(cppThis, String::cppNew("_list")),
                        String::cppNew("cppGet_iterator"));
  if (CppApi::cppBoolValue(
          cppApply<Bool*>(iterator, String::cppNew("moveNext")))) {
    cppApply<void, Object*>(
        buffer, String::cppNew("write"),
        cppApply<Object*>(iterator, String::cppNew("cppGet_current")));
    while (CppApi::cppBoolValue(
        cppApply<Bool*>(iterator, String::cppNew("moveNext")))) {
      cppApply<void, Object*>(buffer, String::cppNew("write"), separator);
      cppApply<void, Object*>(
          buffer, String::cppNew("write"),
          cppApply<Object*>(iterator, String::cppNew("cppGet_current")));
    }
  }
  return cppApply<String*>(buffer, String::cppNew("toString"));
}

Object* CppSet::lastWhere(Object* cppThis, Function* test, Function* orElse) {
  {
    Int* i = Num::cpp_subtract(
        cppApply<Int*>(CppGet<Object*>(cppThis, String::cppNew("_list")),
                       String::cppNew("cppGet_length")),
        Int::cppNew(1));
    while (
        CppApi::cppBoolValue(Num::cpp_greaterThanOrEqual(i, Int::cppNew(0)))) {
      {
        Object* element = cppApply<Object*, Int*>(
            CppGet<Object*>(cppThis, String::cppNew("_list")),
            String::cppNew("cpp_subscript"), i);
        if (CppApi::cppBoolValue(cppApply<Bool*>(test, element)))
          return element;
      }
      i = Num::cpp_subtract(i, Int::cppNew(1));
    }
  }
  if (CppApi::cppBoolValue(Bool::cpp_not(Bool::cppNew(orElse == nullptr))))
    return cppApply<Object*>(orElse);
  throw "ConstructorInvocation(new StateError(No element))";
}

Int* CppSet::cppGet_length(Object* cppThis) {
  return cppApply<Int*>(CppGet<Object*>(cppThis, String::cppNew("_list")),
                        String::cppNew("cppGet_length"));
}

Object* CppSet::lookup(Object* cppThis, Object* element) {
  {
    Int* i = Int::cppNew(0);
    while (CppApi::cppBoolValue(Num::cpp_lessThan(
        i, cppApply<Int*>(CppGet<Object*>(cppThis, String::cppNew("_list")),
                          String::cppNew("cppGet_length"))))) {
      {
        if (CppApi::cppBoolValue(Object::cpp_equals(
                element, cppApply<Object*, Int*>(
                             CppGet<Object*>(cppThis, String::cppNew("_list")),
                             String::cppNew("cpp_subscript"), i)))) {
          return cppApply<Object*, Int*>(
              CppGet<Object*>(cppThis, String::cppNew("_list")),
              String::cppNew("cpp_subscript"), i);
        }
      }
      i = Num::cpp_add(i, Int::cppNew(1));
    }
  }
  return nullptr;
}

Object* CppSet::map(Object* cppThis, Function* toElement) {
  return cppApply<Object*, Function*>(
      CppGet<Object*>(cppThis, String::cppNew("_list")), String::cppNew("map"),
      toElement);
}

Object* CppSet::reduce(Object* cppThis, Function* combine) {
  if (CppApi::cppBoolValue(
          cppApply<Bool*>(CppGet<Object*>(cppThis, String::cppNew("_list")),
                          String::cppNew("cppGet_isEmpty"))))
    throw "ConstructorInvocation(new StateError(No element))";
  Object* value =
      cppApply<Object*>(CppGet<Object*>(cppThis, String::cppNew("_list")),
                        String::cppNew("cppGet_first"));
  {
    Int* i = Int::cppNew(1);
    while (CppApi::cppBoolValue(Num::cpp_lessThan(
        i, cppApply<Int*>(CppGet<Object*>(cppThis, String::cppNew("_list")),
                          String::cppNew("cppGet_length"))))) {
      {
        value = cppApply<Object*>(
            combine, value,
            cppApply<Object*, Int*>(
                CppGet<Object*>(cppThis, String::cppNew("_list")),
                String::cppNew("cpp_subscript"), i));
      }
      i = Num::cpp_add(i, Int::cppNew(1));
    }
  }
  return value;
}

Bool* CppSet::remove(Object* cppThis, Object* value) {
  return cppApply<Bool*, Object*>(
      CppGet<Object*>(cppThis, String::cppNew("_list")),
      String::cppNew("remove"), value);
}

void CppSet::removeAll(Object* cppThis, Object* elementsToRemove) {
  {
    Object* $sync_for_iterator =
        cppApply<Object*>(elementsToRemove, String::cppNew("cppGet_iterator"));
    {
      while (CppApi::cppBoolValue(
          cppApply<Bool*>($sync_for_iterator, String::cppNew("moveNext")))) {
        {
          Object* element = cppApply<Object*>($sync_for_iterator,
                                              String::cppNew("cppGet_current"));
          {
            cppApply<Bool*, Object*>(cppThis, String::cppNew("remove"),
                                     element);
          }
        }
      }
    }
  }
}

void CppSet::removeWhere(Object* cppThis, Function* test) {
  cppApply<void, Function*>(CppGet<Object*>(cppThis, String::cppNew("_list")),
                            String::cppNew("removeWhere"), test);
}

void CppSet::retainAll(Object* cppThis, Object* elementsToRetain) {
  Object* retainSet = LinkedHashSet::from(elementsToRetain);
  cppApply<void, Function*>(
      cppThis, String::cppNew("removeWhere"),
      new LambdaWrapper<Bool*, Object*>([&](Object* element) -> Bool* {
        return Bool::cpp_not(cppApply<Bool*, Object*>(
            retainSet, String::cppNew("contains"), element));
      }));
}

void CppSet::retainWhere(Object* cppThis, Function* test) {
  cppApply<void, Function*>(CppGet<Object*>(cppThis, String::cppNew("_list")),
                            String::cppNew("retainWhere"), test);
}

Object* CppSet::singleWhere(Object* cppThis, Function* test, Function* orElse) {
  Object* result;
  Bool* found = Bool::cppNew(false);
  {
    Object* $sync_for_iterator =
        cppApply<Object*>(CppGet<Object*>(cppThis, String::cppNew("_list")),
                          String::cppNew("cppGet_iterator"));
    {
      while (CppApi::cppBoolValue(
          cppApply<Bool*>($sync_for_iterator, String::cppNew("moveNext")))) {
        {
          Object* element = cppApply<Object*>($sync_for_iterator,
                                              String::cppNew("cppGet_current"));
          {
            if (CppApi::cppBoolValue(cppApply<Bool*>(test, element))) {
              if (CppApi::cppBoolValue(found))
                throw "ConstructorInvocation(new StateError(Too many "
                      "elements))";
              result = element;
              found = Bool::cppNew(true);
            }
          }
        }
      }
    }
  }
  if (CppApi::cppBoolValue(found)) return result;
  if (CppApi::cppBoolValue(Bool::cpp_not(Bool::cppNew(orElse == nullptr))))
    return cppApply<Object*>(orElse);
  throw "ConstructorInvocation(new StateError(No element))";
}

Object* CppSet::skip(Object* cppThis, Int* count) {
  return cppApply<Object*, Int*>(
      CppGet<Object*>(cppThis, String::cppNew("_list")), String::cppNew("skip"),
      count);
}

Object* CppSet::skipWhile(Object* cppThis, Function* test) {
  return cppApply<Object*, Function*>(
      CppGet<Object*>(cppThis, String::cppNew("_list")),
      String::cppNew("skipWhile"), test);
}

Object* CppSet::cpp_union(Object* cppThis, Object* other) {
  Object* result = CppSet::cppCtr_(CppSet::cppNew(), Int::cppNew(4));
  cppApply<void, Object*>(result, String::cppNew("addAll"), cppThis);
  cppApply<void, Object*>(result, String::cppNew("addAll"), other);
  return result;
}

Object* CppSet::take(Object* cppThis, Int* count) {
  return cppApply<Object*, Int*>(
      CppGet<Object*>(cppThis, String::cppNew("_list")), String::cppNew("take"),
      count);
}

Object* CppSet::takeWhile(Object* cppThis, Function* test) {
  return cppApply<Object*, Function*>(
      CppGet<Object*>(cppThis, String::cppNew("_list")),
      String::cppNew("takeWhile"), test);
}

Object* CppSet::toList(Object* cppThis, Bool* growable) {
  return cppApply<Object*, Bool*>(
      CppGet<Object*>(cppThis, String::cppNew("_list")),
      String::cppNew("toList"), growable);
}

Object* CppSet::toSet(Object* cppThis) {
  return cppThis;
}

Object* CppSet::where(Object* cppThis, Function* test) {
  Object* result = CppNewList(Int::cppNew(0));
  {
    Int* i = Int::cppNew(0);
    while (CppApi::cppBoolValue(Num::cpp_lessThan(
        i, cppApply<Int*>(CppGet<Object*>(cppThis, String::cppNew("_list")),
                          String::cppNew("cppGet_length"))))) {
      {
        Object* element = cppApply<Object*, Int*>(
            CppGet<Object*>(cppThis, String::cppNew("_list")),
            String::cppNew("cpp_subscript"), i);
        if (CppApi::cppBoolValue(cppApply<Bool*>(test, element))) {
          cppApply<void, Object*>(result, String::cppNew("add"), element);
        }
      }
      i = Num::cpp_add(i, Int::cppNew(1));
    }
  }
  return result;
}

Object* CppSet::whereType(Object* cppThis) {
  Object* result = CppNewList(Int::cppNew(0));
  {
    Int* i = Int::cppNew(0);
    while (CppApi::cppBoolValue(Num::cpp_lessThan(
        i, cppApply<Int*>(CppGet<Object*>(cppThis, String::cppNew("_list")),
                          String::cppNew("cppGet_length"))))) {
      {
        Object* element = cppApply<Object*, Int*>(
            CppGet<Object*>(cppThis, String::cppNew("_list")),
            String::cppNew("cpp_subscript"), i);
        if (CppApi::cppBoolValue(
                Bool::cppNew(reinterpret_cast<Object*>(element) == nullptr))) {
          cppApply<void, Object*>(result, String::cppNew("add"), element);
        }
      }
      i = Num::cpp_add(i, Int::cppNew(1));
    }
  }
  return result;
}

String* CppSet::toString(Object* cppThis) {
  if (CppApi::cppBoolValue(
          cppApply<Bool*>(CppGet<Object*>(cppThis, String::cppNew("_list")),
                          String::cppNew("cppGet_isEmpty"))))
    return String::cppNew("{}");
  Object* buffer =
      StringBuffer::cppCtr_(StringBuffer::cppNew(), String::cppNew("{"));
  Object* iterator =
      cppApply<Object*>(CppGet<Object*>(cppThis, String::cppNew("_list")),
                        String::cppNew("cppGet_iterator"));
  if (CppApi::cppBoolValue(
          cppApply<Bool*>(iterator, String::cppNew("moveNext")))) {
    cppApply<void, Object*>(
        buffer, String::cppNew("write"),
        cppApply<Object*>(iterator, String::cppNew("cppGet_current")));
    while (CppApi::cppBoolValue(
        cppApply<Bool*>(iterator, String::cppNew("moveNext")))) {
      cppApply<void, Object*>(buffer, String::cppNew("write"),
                              String::cppNew(", "));
      cppApply<void, Object*>(
          buffer, String::cppNew("write"),
          cppApply<Object*>(iterator, String::cppNew("cppGet_current")));
    }
  }
  cppApply<void, Object*>(buffer, String::cppNew("write"), String::cppNew("}"));
  return cppApply<String*>(buffer, String::cppNew("toString"));
}

Object* CppSet::cppNew() {
  static std::map<String*, void*> v_ptrs = {
      {String::cppNew("toString"), reinterpret_cast<void*>(&CppSet::toString)},
      {String::cppNew("add"), reinterpret_cast<void*>(&Set::add)},
      {String::cppNew("addAll"), reinterpret_cast<void*>(&Set::addAll)},
      {String::cppNew("any"), reinterpret_cast<void*>(&CppSet::any)},
      {String::cppNew("cast"), reinterpret_cast<void*>(&Set::cast)},
      {String::cppNew("clear"), reinterpret_cast<void*>(&Set::clear)},
      {String::cppNew("contains"), reinterpret_cast<void*>(&Set::contains)},
      {String::cppNew("containsAll"),
       reinterpret_cast<void*>(&Set::containsAll)},
      {String::cppNew("difference"), reinterpret_cast<void*>(&Set::difference)},
      {String::cppNew("elementAt"),
       reinterpret_cast<void*>(&CppSet::elementAt)},
      {String::cppNew("every"), reinterpret_cast<void*>(&CppSet::every)},
      {String::cppNew("expand"), reinterpret_cast<void*>(&CppSet::expand)},
      {String::cppNew("firstWhere"),
       reinterpret_cast<void*>(&CppSet::firstWhere)},
      {String::cppNew("fold"), reinterpret_cast<void*>(&CppSet::fold)},
      {String::cppNew("followedBy"),
       reinterpret_cast<void*>(&CppSet::followedBy)},
      {String::cppNew("forEach"), reinterpret_cast<void*>(&CppSet::forEach)},
      {String::cppNew("intersection"),
       reinterpret_cast<void*>(&Set::intersection)},
      {String::cppNew("cppGet_first"),
       reinterpret_cast<void*>(&CppSet::cppGet_first)},
      {String::cppNew("cppGet_last"),
       reinterpret_cast<void*>(&CppSet::cppGet_last)},
      {String::cppNew("cppGet_single"),
       reinterpret_cast<void*>(&CppSet::cppGet_single)},
      {String::cppNew("cppGet_isEmpty"),
       reinterpret_cast<void*>(&CppSet::cppGet_isEmpty)},
      {String::cppNew("cppGet_isNotEmpty"),
       reinterpret_cast<void*>(&CppSet::cppGet_isNotEmpty)},
      {String::cppNew("cppGet_iterator"),
       reinterpret_cast<void*>(&Set::cppGet_iterator)},
      {String::cppNew("join"), reinterpret_cast<void*>(&CppSet::join)},
      {String::cppNew("lastWhere"),
       reinterpret_cast<void*>(&CppSet::lastWhere)},
      {String::cppNew("cppGet_length"),
       reinterpret_cast<void*>(&CppSet::cppGet_length)},
      {String::cppNew("lookup"), reinterpret_cast<void*>(&Set::lookup)},
      {String::cppNew("map"), reinterpret_cast<void*>(&CppSet::map)},
      {String::cppNew("reduce"), reinterpret_cast<void*>(&CppSet::reduce)},
      {String::cppNew("remove"), reinterpret_cast<void*>(&Set::remove)},
      {String::cppNew("removeAll"), reinterpret_cast<void*>(&Set::removeAll)},
      {String::cppNew("removeWhere"),
       reinterpret_cast<void*>(&Set::removeWhere)},
      {String::cppNew("retainAll"), reinterpret_cast<void*>(&Set::retainAll)},
      {String::cppNew("retainWhere"),
       reinterpret_cast<void*>(&Set::retainWhere)},
      {String::cppNew("singleWhere"),
       reinterpret_cast<void*>(&CppSet::singleWhere)},
      {String::cppNew("skip"), reinterpret_cast<void*>(&CppSet::skip)},
      {String::cppNew("skipWhile"),
       reinterpret_cast<void*>(&CppSet::skipWhile)},
      {String::cppNew("cpp_union"), reinterpret_cast<void*>(&Set::cpp_union)},
      {String::cppNew("take"), reinterpret_cast<void*>(&CppSet::take)},
      {String::cppNew("takeWhile"),
       reinterpret_cast<void*>(&CppSet::takeWhile)},
      {String::cppNew("toList"), reinterpret_cast<void*>(&CppSet::toList)},
      {String::cppNew("toSet"), reinterpret_cast<void*>(&Set::toSet)},
      {String::cppNew("where"), reinterpret_cast<void*>(&CppSet::where)},
      {String::cppNew("whereType"),
       reinterpret_cast<void*>(&CppSet::whereType)}};
  static Type* runtimeType = new Type("CppSet");
  Object* ptr = new ObjectImp(const_cast<Type*>(runtimeType), &v_ptrs);
  return ptr;
}

//  library file:///Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/test/list.dart
Object* CppMap::cppCtr_fromCppArray(Object* cppThis, Object* array) {
  CppSet<Object*>(cppThis, String::cppNew("_list"),
                  CppList::cppCtr_fromCppArray(CppList::cppNew(), array));

  return cppThis;
}

Object* CppMap::cppCtr_(Object* cppThis, Int* capacity) {
  CppSet<Object*>(
      cppThis, String::cppNew("_list"),
      CppList::cppCtr_(CppList::cppNew(), Int::cppNew(0), capacity));

  return cppThis;
}

Object* CppMap::identity() {
  return CppMap::cppCtr_(CppMap::cppNew(), Int::cppNew(4));
}

Object* CppMap::from(Object* other) {
  return CppMap::unmodifiable(other);
}

Object* CppMap::of(Object* other) {
  return CppMap::fromEntries(
      cppApply<Object*>(other, String::cppNew("cppGet_entries")));
}

Object* CppMap::unmodifiable(Object* other) {
  Object* map = CppMap::cppCtr_(CppMap::cppNew(), Int::cppNew(4));
  cppApply<void, Function*>(
      other, String::cppNew("forEach"),
      new LambdaWrapper<void, void**, void**>([&](void** key,
                                                  void** value) -> void {
        cppApply<void, Object*, Object*>(
            map, String::cppNew("cpp_subscriptAssign"),
            reinterpret_cast<Object*>(key), reinterpret_cast<Object*>(value));
      }));
  return map;
}

Object* CppMap::fromIterable(Object* iterable, Function* key, Function* value) {
  Object* map = CppMap::cppCtr_(CppMap::cppNew(), Int::cppNew(4));
  {
    Object* $sync_for_iterator =
        cppApply<Object*>(iterable, String::cppNew("cppGet_iterator"));
    {
      while (CppApi::cppBoolValue(
          cppApply<Bool*>($sync_for_iterator, String::cppNew("moveNext")))) {
        {
          void** element = cppApply<void**>($sync_for_iterator,
                                            String::cppNew("cppGet_current"));
          {
            void** k = ([&]() {
              Object* cppLet_0 = ([&]() {
                Function* cppLet_0 = key;
                return CppApi::cppBoolValue(Bool::cppNew(cppLet_0 == nullptr))
                           ? nullptr
                           : cppApply<Object*>(cppLet_0, element);
              })();
              return CppApi::cppBoolValue(Bool::cppNew(cppLet_0 == nullptr))
                         ? element
                         : cppLet_0;
            })();
            void** v = ([&]() {
              Object* cppLet_0 = ([&]() {
                Function* cppLet_0 = value;
                return CppApi::cppBoolValue(Bool::cppNew(cppLet_0 == nullptr))
                           ? nullptr
                           : cppApply<Object*>(cppLet_0, element);
              })();
              return CppApi::cppBoolValue(Bool::cppNew(cppLet_0 == nullptr))
                         ? element
                         : cppLet_0;
            })();
            cppApply<void, Object*, Object*>(
                map, String::cppNew("cpp_subscriptAssign"),
                reinterpret_cast<Object*>(k), reinterpret_cast<Object*>(v));
          }
        }
      }
    }
  }
  return map;
}

Object* CppMap::fromIterables(Object* keys, Object* values) {
  Object* map = CppMap::cppCtr_(CppMap::cppNew(), Int::cppNew(4));
  Object* keyIter = cppApply<Object*>(keys, String::cppNew("cppGet_iterator"));
  Object* valueIter =
      cppApply<Object*>(values, String::cppNew("cppGet_iterator"));
  while (CppApi::cppBoolValue(CppApi::cppBoolValue(cppApply<Bool*>(
                                  keyIter, String::cppNew("moveNext"))) &&
                              CppApi::cppBoolValue(cppApply<Bool*>(
                                  valueIter, String::cppNew("moveNext"))))) {
    cppApply<void, Object*, Object*>(
        map, String::cppNew("cpp_subscriptAssign"),
        cppApply<Object*>(keyIter, String::cppNew("cppGet_current")),
        cppApply<Object*>(valueIter, String::cppNew("cppGet_current")));
  }
  return map;
}

Object* CppMap::fromEntries(Object* entries) {
  Object* map = CppMap::cppCtr_(CppMap::cppNew(), Int::cppNew(4));
  {
    Object* $sync_for_iterator =
        cppApply<Object*>(entries, String::cppNew("cppGet_iterator"));
    {
      while (CppApi::cppBoolValue(
          cppApply<Bool*>($sync_for_iterator, String::cppNew("moveNext")))) {
        {
          Object* entry = cppApply<Object*>($sync_for_iterator,
                                            String::cppNew("cppGet_current"));
          {
            cppApply<void, Object*, Object*>(
                map, String::cppNew("cpp_subscriptAssign"),
                CppGet<Object*>(entry, String::cppNew("key")),
                CppGet<Object*>(entry, String::cppNew("value")));
          }
        }
      }
    }
  }
  return map;
}

Object* CppMap::cpp_subscript(Object* cppThis, Object* key) {
  {
    Object* $sync_for_iterator =
        cppApply<Object*>(CppGet<Object*>(cppThis, String::cppNew("_list")),
                          String::cppNew("cppGet_iterator"));
    {
      while (CppApi::cppBoolValue(
          cppApply<Bool*>($sync_for_iterator, String::cppNew("moveNext")))) {
        {
          Object* entry = cppApply<Object*>($sync_for_iterator,
                                            String::cppNew("cppGet_current"));
          {
            if (CppApi::cppBoolValue(Object::cpp_equals(
                    CppGet<Object*>(entry, String::cppNew("key")), key))) {
              return CppGet<Object*>(entry, String::cppNew("value"));
            }
          }
        }
      }
    }
  }
  return nullptr;
}

void CppMap::cpp_subscriptAssign(Object* cppThis, Object* key, Object* value) {
  {
    Int* i = Int::cppNew(0);
    while (CppApi::cppBoolValue(Num::cpp_lessThan(
        i, cppApply<Int*>(CppGet<Object*>(cppThis, String::cppNew("_list")),
                          String::cppNew("cppGet_length"))))) {
      {
        if (CppApi::cppBoolValue(Object::cpp_equals(
                CppGet<Object*>(
                    cppApply<Object*, Int*>(
                        CppGet<Object*>(cppThis, String::cppNew("_list")),
                        String::cppNew("cpp_subscript"), i),
                    String::cppNew("key")),
                key))) {
          cppApply<void, Int*, Object*>(
              CppGet<Object*>(cppThis, String::cppNew("_list")),
              String::cppNew("cpp_subscriptAssign"), i,
              MapEntry::cppCtr__(MapEntry::cppNew(), key, value));
          return;
        }
      }
      i = Num::cpp_add(i, Int::cppNew(1));
    }
  }
  cppApply<void, Object*>(CppGet<Object*>(cppThis, String::cppNew("_list")),
                          String::cppNew("add"),
                          MapEntry::cppCtr__(MapEntry::cppNew(), key, value));
}

void CppMap::addAll(Object* cppThis, Object* other) {
  cppApply<void, Function*>(
      other, String::cppNew("forEach"),
      new LambdaWrapper<void, Object*, Object*>(
          [&](Object* k, Object* v) -> void {
            return ([&]() {
              Object* cppLet_0 = k;
              return ([&]() {
                Object* cppLet_0 = v;
                return ([&]() {
                  void cppLet_0 = cppApply<void, Object*, Object*>(
                      cppThis, String::cppNew("cpp_subscriptAssign"), cppLet_0,
                      cppLet_0);
                  return cppLet_0;
                })();
              })();
            })();
          }));
}

void CppMap::addEntries(Object* cppThis, Object* entries) {
  {
    Object* $sync_for_iterator =
        cppApply<Object*>(entries, String::cppNew("cppGet_iterator"));
    {
      while (CppApi::cppBoolValue(
          cppApply<Bool*>($sync_for_iterator, String::cppNew("moveNext")))) {
        {
          Object* entry = cppApply<Object*>($sync_for_iterator,
                                            String::cppNew("cppGet_current"));
          {
            cppApply<void, Object*, Object*>(
                cppThis, String::cppNew("cpp_subscriptAssign"),
                CppGet<Object*>(entry, String::cppNew("key")),
                CppGet<Object*>(entry, String::cppNew("value")));
          }
        }
      }
    }
  }
}

Object* CppMap::cast(Object* cppThis) {
  return Map::castFrom(cppThis);
}

void CppMap::clear(Object* cppThis) {
  cppApply<void>(CppGet<Object*>(cppThis, String::cppNew("_list")),
                 String::cppNew("clear"));
}

Bool* CppMap::containsKey(Object* cppThis, Object* key) {
  {
    Object* $sync_for_iterator =
        cppApply<Object*>(CppGet<Object*>(cppThis, String::cppNew("_list")),
                          String::cppNew("cppGet_iterator"));
    {
      while (CppApi::cppBoolValue(
          cppApply<Bool*>($sync_for_iterator, String::cppNew("moveNext")))) {
        {
          Object* entry = cppApply<Object*>($sync_for_iterator,
                                            String::cppNew("cppGet_current"));
          {
            if (CppApi::cppBoolValue(Object::cpp_equals(
                    CppGet<Object*>(entry, String::cppNew("key")), key)))
              return Bool::cppNew(true);
          }
        }
      }
    }
  }
  return Bool::cppNew(false);
}

Bool* CppMap::containsValue(Object* cppThis, Object* value) {
  {
    Object* $sync_for_iterator =
        cppApply<Object*>(CppGet<Object*>(cppThis, String::cppNew("_list")),
                          String::cppNew("cppGet_iterator"));
    {
      while (CppApi::cppBoolValue(
          cppApply<Bool*>($sync_for_iterator, String::cppNew("moveNext")))) {
        {
          Object* entry = cppApply<Object*>($sync_for_iterator,
                                            String::cppNew("cppGet_current"));
          {
            if (CppApi::cppBoolValue(Object::cpp_equals(
                    CppGet<Object*>(entry, String::cppNew("value")), value)))
              return Bool::cppNew(true);
          }
        }
      }
    }
  }
  return Bool::cppNew(false);
}

Object* CppMap::cppGet_entries(Object* cppThis) {
  return CppGet<Object*>(cppThis, String::cppNew("_list"));
}

void CppMap::forEach(Object* cppThis, Function* action) {
  {
    Object* $sync_for_iterator =
        cppApply<Object*>(CppGet<Object*>(cppThis, String::cppNew("_list")),
                          String::cppNew("cppGet_iterator"));
    {
      while (CppApi::cppBoolValue(
          cppApply<Bool*>($sync_for_iterator, String::cppNew("moveNext")))) {
        {
          Object* entry = cppApply<Object*>($sync_for_iterator,
                                            String::cppNew("cppGet_current"));
          {
            cppApply<void>(action,
                           CppGet<Object*>(entry, String::cppNew("key")),
                           CppGet<Object*>(entry, String::cppNew("value")));
          }
        }
      }
    }
  }
}

Bool* CppMap::cppGet_isEmpty(Object* cppThis) {
  return cppApply<Bool*>(CppGet<Object*>(cppThis, String::cppNew("_list")),
                         String::cppNew("cppGet_isEmpty"));
}

Bool* CppMap::cppGet_isNotEmpty(Object* cppThis) {
  return cppApply<Bool*>(CppGet<Object*>(cppThis, String::cppNew("_list")),
                         String::cppNew("cppGet_isNotEmpty"));
}

Object* CppMap::cppGet_keys(Object* cppThis) {
  return cppApply<Object*, Function*>(
      CppGet<Object*>(cppThis, String::cppNew("_list")), String::cppNew("map"),
      new LambdaWrapper<Object*, Object*>([&](Object* e) -> Object* {
        return CppGet<Object*>(e, String::cppNew("key"));
      }));
}

Int* CppMap::cppGet_length(Object* cppThis) {
  return cppApply<Int*>(CppGet<Object*>(cppThis, String::cppNew("_list")),
                        String::cppNew("cppGet_length"));
}

Object* CppMap::putIfAbsent(Object* cppThis, Object* key, Function* ifAbsent) {
  {
    Object* $sync_for_iterator =
        cppApply<Object*>(CppGet<Object*>(cppThis, String::cppNew("_list")),
                          String::cppNew("cppGet_iterator"));
    {
      while (CppApi::cppBoolValue(
          cppApply<Bool*>($sync_for_iterator, String::cppNew("moveNext")))) {
        {
          Object* entry = cppApply<Object*>($sync_for_iterator,
                                            String::cppNew("cppGet_current"));
          {
            if (CppApi::cppBoolValue(Object::cpp_equals(
                    CppGet<Object*>(entry, String::cppNew("key")), key)))
              return CppGet<Object*>(entry, String::cppNew("value"));
          }
        }
      }
    }
  }
  Object* v = cppApply<Object*>(ifAbsent);
  cppApply<void, Object*>(CppGet<Object*>(cppThis, String::cppNew("_list")),
                          String::cppNew("add"),
                          MapEntry::cppCtr__(MapEntry::cppNew(), key, v));
  return v;
}

Object* CppMap::remove(Object* cppThis, Object* key) {
  {
    Int* i = Int::cppNew(0);
    while (CppApi::cppBoolValue(Num::cpp_lessThan(
        i, cppApply<Int*>(CppGet<Object*>(cppThis, String::cppNew("_list")),
                          String::cppNew("cppGet_length"))))) {
      {
        if (CppApi::cppBoolValue(Object::cpp_equals(
                CppGet<Object*>(
                    cppApply<Object*, Int*>(
                        CppGet<Object*>(cppThis, String::cppNew("_list")),
                        String::cppNew("cpp_subscript"), i),
                    String::cppNew("key")),
                key))) {
          Object* v = CppGet<Object*>(
              cppApply<Object*, Int*>(
                  CppGet<Object*>(cppThis, String::cppNew("_list")),
                  String::cppNew("cpp_subscript"), i),
              String::cppNew("value"));
          {
            Int* j = i;
            while (CppApi::cppBoolValue(Num::cpp_lessThan(
                j, Num::cpp_subtract(
                       cppApply<Int*>(
                           CppGet<Object*>(cppThis, String::cppNew("_list")),
                           String::cppNew("cppGet_length")),
                       Int::cppNew(1))))) {
              {
                cppApply<void, Int*, Object*>(
                    CppGet<Object*>(cppThis, String::cppNew("_list")),
                    String::cppNew("cpp_subscriptAssign"), j,
                    cppApply<Object*, Int*>(
                        CppGet<Object*>(cppThis, String::cppNew("_list")),
                        String::cppNew("cpp_subscript"),
                        Num::cpp_add(j, Int::cppNew(1))));
              }
              j = Num::cpp_add(j, Int::cppNew(1));
            }
          }
          cppApply<void, Int*>(
              CppGet<Object*>(cppThis, String::cppNew("_list")),
              String::cppNew("cppSet_length"),
              Num::cpp_subtract(
                  cppApply<Int*>(
                      CppGet<Object*>(cppThis, String::cppNew("_list")),
                      String::cppNew("cppGet_length")),
                  Int::cppNew(1)));
          return v;
        }
      }
      i = Num::cpp_add(i, Int::cppNew(1));
    }
  }
  return nullptr;
}

void CppMap::removeWhere(Object* cppThis, Function* test) {
  Int* i = Int::cppNew(0);
  while (CppApi::cppBoolValue(Num::cpp_lessThan(
      i, cppApply<Int*>(CppGet<Object*>(cppThis, String::cppNew("_list")),
                        String::cppNew("cppGet_length"))))) {
    Object* entry = cppApply<Object*, Int*>(
        CppGet<Object*>(cppThis, String::cppNew("_list")),
        String::cppNew("cpp_subscript"), i);
    if (CppApi::cppBoolValue(
            cppApply<Bool*>(test, CppGet<Object*>(entry, String::cppNew("key")),
                            CppGet<Object*>(entry, String::cppNew("value"))))) {
      cppApply<Object*, Object*>(cppThis, String::cppNew("remove"),
                                 CppGet<Object*>(entry, String::cppNew("key")));
    } else {
      i = Num::cpp_add(i, Int::cppNew(1));
    }
  }
}

Object* CppMap::update(Object* cppThis,
                       Object* key,
                       Function* update,
                       Function* ifAbsent) {
  {
    Int* i = Int::cppNew(0);
    while (CppApi::cppBoolValue(Num::cpp_lessThan(
        i, cppApply<Int*>(CppGet<Object*>(cppThis, String::cppNew("_list")),
                          String::cppNew("cppGet_length"))))) {
      {
        if (CppApi::cppBoolValue(Object::cpp_equals(
                CppGet<Object*>(
                    cppApply<Object*, Int*>(
                        CppGet<Object*>(cppThis, String::cppNew("_list")),
                        String::cppNew("cpp_subscript"), i),
                    String::cppNew("key")),
                key))) {
          Object* newValue = cppApply<Object*>(
              update, CppGet<Object*>(
                          cppApply<Object*, Int*>(
                              CppGet<Object*>(cppThis, String::cppNew("_list")),
                              String::cppNew("cpp_subscript"), i),
                          String::cppNew("value")));
          cppApply<void, Int*, Object*>(
              CppGet<Object*>(cppThis, String::cppNew("_list")),
              String::cppNew("cpp_subscriptAssign"), i,
              MapEntry::cppCtr__(MapEntry::cppNew(), key, newValue));
          return newValue;
        }
      }
      i = Num::cpp_add(i, Int::cppNew(1));
    }
  }
  if (CppApi::cppBoolValue(Bool::cpp_not(Bool::cppNew(ifAbsent == nullptr)))) {
    Object* v = cppApply<Object*>(ifAbsent);
    cppApply<void, Object*>(CppGet<Object*>(cppThis, String::cppNew("_list")),
                            String::cppNew("add"),
                            MapEntry::cppCtr__(MapEntry::cppNew(), key, v));
    return v;
  }
  throw "ConstructorInvocation(new ArgumentError(Key not found))";
}

void CppMap::updateAll(Object* cppThis, Function* update) {
  {
    Int* i = Int::cppNew(0);
    while (CppApi::cppBoolValue(Num::cpp_lessThan(
        i, cppApply<Int*>(CppGet<Object*>(cppThis, String::cppNew("_list")),
                          String::cppNew("cppGet_length"))))) {
      {
        Object* entry = cppApply<Object*, Int*>(
            CppGet<Object*>(cppThis, String::cppNew("_list")),
            String::cppNew("cpp_subscript"), i);
        cppApply<void, Int*, Object*>(
            CppGet<Object*>(cppThis, String::cppNew("_list")),
            String::cppNew("cpp_subscriptAssign"), i,
            MapEntry::cppCtr__(
                MapEntry::cppNew(),
                CppGet<Object*>(entry, String::cppNew("key")),
                cppApply<Object*>(
                    update, CppGet<Object*>(entry, String::cppNew("key")),
                    CppGet<Object*>(entry, String::cppNew("value")))));
      }
      i = Num::cpp_add(i, Int::cppNew(1));
    }
  }
}

Object* CppMap::cppGet_values(Object* cppThis) {
  return cppApply<Object*, Function*>(
      CppGet<Object*>(cppThis, String::cppNew("_list")), String::cppNew("map"),
      new LambdaWrapper<Object*, Object*>([&](Object* e) -> Object* {
        return CppGet<Object*>(e, String::cppNew("value"));
      }));
}

Object* CppMap::map(Object* cppThis, Function* transform) {
  Object* result = CppMap::cppCtr_(CppMap::cppNew(), Int::cppNew(4));
  {
    Object* $sync_for_iterator =
        cppApply<Object*>(CppGet<Object*>(cppThis, String::cppNew("_list")),
                          String::cppNew("cppGet_iterator"));
    {
      while (CppApi::cppBoolValue(
          cppApply<Bool*>($sync_for_iterator, String::cppNew("moveNext")))) {
        {
          Object* entry = cppApply<Object*>($sync_for_iterator,
                                            String::cppNew("cppGet_current"));
          {
            Object* newEntry = cppApply<Object*>(
                transform, CppGet<Object*>(entry, String::cppNew("key")),
                CppGet<Object*>(entry, String::cppNew("value")));
            cppApply<void, Object*, Object*>(
                result, String::cppNew("cpp_subscriptAssign"),
                CppGet<Object*>(newEntry, String::cppNew("key")),
                CppGet<Object*>(newEntry, String::cppNew("value")));
          }
        }
      }
    }
  }
  return result;
}

String* CppMap::toString(Object* cppThis) {
  if (CppApi::cppBoolValue(
          cppApply<Bool*>(CppGet<Object*>(cppThis, String::cppNew("_list")),
                          String::cppNew("cppGet_isEmpty"))))
    return String::cppNew("{}");
  Object* buffer =
      StringBuffer::cppCtr_(StringBuffer::cppNew(), String::cppNew("{"));
  Object* iterator =
      cppApply<Object*>(CppGet<Object*>(cppThis, String::cppNew("_list")),
                        String::cppNew("cppGet_iterator"));
  if (CppApi::cppBoolValue(
          cppApply<Bool*>(iterator, String::cppNew("moveNext")))) {
    cppApply<void, Object*>(
        buffer, String::cppNew("write"),
        String::cpp_add(
            String::cpp_add(cppToString(CppGet<Object*>(
                                cppApply<Object*>(
                                    iterator, String::cppNew("cppGet_current")),
                                String::cppNew("key"))),
                            cppToString(String::cppNew(": "))),
            cppToString(CppGet<Object*>(
                cppApply<Object*>(iterator, String::cppNew("cppGet_current")),
                String::cppNew("value")))));
    while (CppApi::cppBoolValue(
        cppApply<Bool*>(iterator, String::cppNew("moveNext")))) {
      cppApply<void, Object*>(
          buffer, String::cppNew("write"),
          String::cpp_add(
              String::cpp_add(
                  String::cpp_add(
                      cppToString(String::cppNew(", ")),
                      cppToString(CppGet<Object*>(
                          cppApply<Object*>(iterator,
                                            String::cppNew("cppGet_current")),
                          String::cppNew("key")))),
                  cppToString(String::cppNew(": "))),
              cppToString(CppGet<Object*>(
                  cppApply<Object*>(iterator, String::cppNew("cppGet_current")),
                  String::cppNew("value")))));
    }
  }
  cppApply<void, Object*>(buffer, String::cppNew("write"), String::cppNew("}"));
  return cppApply<String*>(buffer, String::cppNew("toString"));
}

Object* CppMap::cppNew() {
  static std::map<String*, void*> v_ptrs = {
      {String::cppNew("toString"), reinterpret_cast<void*>(&CppMap::toString)},
      {String::cppNew("cpp_subscript"),
       reinterpret_cast<void*>(&Map::cpp_subscript)},
      {String::cppNew("cpp_subscriptAssign"),
       reinterpret_cast<void*>(&Map::cpp_subscriptAssign)},
      {String::cppNew("addAll"), reinterpret_cast<void*>(&Map::addAll)},
      {String::cppNew("addEntries"), reinterpret_cast<void*>(&Map::addEntries)},
      {String::cppNew("cast"), reinterpret_cast<void*>(&Map::cast)},
      {String::cppNew("clear"), reinterpret_cast<void*>(&Map::clear)},
      {String::cppNew("containsKey"),
       reinterpret_cast<void*>(&Map::containsKey)},
      {String::cppNew("containsValue"),
       reinterpret_cast<void*>(&Map::containsValue)},
      {String::cppNew("cppGet_entries"),
       reinterpret_cast<void*>(&Map::cppGet_entries)},
      {String::cppNew("forEach"), reinterpret_cast<void*>(&Map::forEach)},
      {String::cppNew("cppGet_isEmpty"),
       reinterpret_cast<void*>(&Map::cppGet_isEmpty)},
      {String::cppNew("cppGet_isNotEmpty"),
       reinterpret_cast<void*>(&Map::cppGet_isNotEmpty)},
      {String::cppNew("cppGet_keys"),
       reinterpret_cast<void*>(&Map::cppGet_keys)},
      {String::cppNew("cppGet_length"),
       reinterpret_cast<void*>(&Map::cppGet_length)},
      {String::cppNew("putIfAbsent"),
       reinterpret_cast<void*>(&Map::putIfAbsent)},
      {String::cppNew("remove"), reinterpret_cast<void*>(&Map::remove)},
      {String::cppNew("removeWhere"),
       reinterpret_cast<void*>(&Map::removeWhere)},
      {String::cppNew("update"), reinterpret_cast<void*>(&Map::update)},
      {String::cppNew("updateAll"), reinterpret_cast<void*>(&Map::updateAll)},
      {String::cppNew("cppGet_values"),
       reinterpret_cast<void*>(&Map::cppGet_values)},
      {String::cppNew("map"), reinterpret_cast<void*>(&Map::map)}};
  static Type* runtimeType = new Type("CppMap");
  Object* ptr = new ObjectImp(const_cast<Type*>(runtimeType), &v_ptrs);
  return ptr;
}

//  library file:///Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/test/list.dart
Object* CppStringBuffer::cppCtr_(Object* cppThis) {
  CppSet<Object*>(
      cppThis, String::cppNew("_parts"),
      CppList::cppCtr_(CppList::cppNew(), Int::cppNew(0), Int::cppNew(16)));

  return cppThis;
}

void CppStringBuffer::write(Object* cppThis, Object* obj) {
  cppApply<void, String*>(CppGet<Object*>(cppThis, String::cppNew("_parts")),
                          String::cppNew("add"),
                          cppApply<String*>(obj, String::cppNew("toString")));
}

void CppStringBuffer::writeAll(Object* cppThis,
                               Object* objects,
                               String* separator) {
  Object* iterator =
      cppApply<Object*>(objects, String::cppNew("cppGet_iterator"));
  if (CppApi::cppBoolValue(
          cppApply<Bool*>(iterator, String::cppNew("moveNext")))) {
    cppApply<void, String*>(
        CppGet<Object*>(cppThis, String::cppNew("_parts")),
        String::cppNew("add"),
        cppApply<String*>(
            cppApply<void**>(iterator, String::cppNew("cppGet_current")),
            String::cppNew("toString")));
    while (CppApi::cppBoolValue(
        cppApply<Bool*>(iterator, String::cppNew("moveNext")))) {
      if (CppApi::cppBoolValue(cppApply<Bool*>(
              separator, String::cppNew("cppGet_isNotEmpty")))) {
        cppApply<void, String*>(
            CppGet<Object*>(cppThis, String::cppNew("_parts")),
            String::cppNew("add"), separator);
      }
      cppApply<void, String*>(
          CppGet<Object*>(cppThis, String::cppNew("_parts")),
          String::cppNew("add"),
          cppApply<String*>(
              cppApply<void**>(iterator, String::cppNew("cppGet_current")),
              String::cppNew("toString")));
    }
  }
}

void CppStringBuffer::writeCharCode(Object* cppThis, Int* charCode) {
  cppApply<void, String*>(CppGet<Object*>(cppThis, String::cppNew("_parts")),
                          String::cppNew("add"),
                          String::fromCharCode(charCode));
}

void CppStringBuffer::writeln(Object* cppThis, Object* obj) {
  cppApply<void, String*>(CppGet<Object*>(cppThis, String::cppNew("_parts")),
                          String::cppNew("add"),
                          cppApply<String*>(obj, String::cppNew("toString")));
  cppApply<void,String *>(CppGet<Object *>(cppThis,String::cppNew("_parts")), String::cppNew("add"), String::cppNew("
"));
}

void CppStringBuffer::clear(Object* cppThis) {
  cppApply<void>(CppGet<Object*>(cppThis, String::cppNew("_parts")),
                 String::cppNew("clear"));
}

String* CppStringBuffer::toString(Object* cppThis) {
  return cppApply<String*, String*>(
      CppGet<Object*>(cppThis, String::cppNew("_parts")),
      String::cppNew("join"), String::cppNew(""));
}

Int* CppStringBuffer::cppGet_length(Object* cppThis) {
  return cppApply<Int*, Int*, Function*>(
      CppGet<Object*>(cppThis, String::cppNew("_parts")),
      String::cppNew("fold"), Int::cppNew(0),
      new LambdaWrapper<Int*, Int*, String*>(
          [&](Int* sum, String* part) -> Int* {
            return Num::cpp_add(
                sum, cppApply<Int*>(part, String::cppNew("cppGet_length")));
          }));
}

Bool* CppStringBuffer::cppGet_isEmpty(Object* cppThis) {
  return cppApply<Bool*>(CppGet<Object*>(cppThis, String::cppNew("_parts")),
                         String::cppNew("cppGet_isEmpty"));
}

Bool* CppStringBuffer::cppGet_isNotEmpty(Object* cppThis) {
  return cppApply<Bool*>(CppGet<Object*>(cppThis, String::cppNew("_parts")),
                         String::cppNew("cppGet_isNotEmpty"));
}

Object* CppStringBuffer::cppNew() {
  static std::map<String*, void*> v_ptrs = {
      {String::cppNew("toString"),
       reinterpret_cast<void*>(&CppStringBuffer::toString)},
      {String::cppNew("write"),
       reinterpret_cast<void*>(&CppStringBuffer::write)},
      {String::cppNew("writeAll"),
       reinterpret_cast<void*>(&CppStringBuffer::writeAll)},
      {String::cppNew("writeCharCode"),
       reinterpret_cast<void*>(&CppStringBuffer::writeCharCode)},
      {String::cppNew("writeln"),
       reinterpret_cast<void*>(&CppStringBuffer::writeln)},
      {String::cppNew("clear"),
       reinterpret_cast<void*>(&CppStringBuffer::clear)},
      {String::cppNew("cppGet_length"),
       reinterpret_cast<void*>(&CppStringBuffer::cppGet_length)},
      {String::cppNew("cppGet_isEmpty"),
       reinterpret_cast<void*>(&CppStringBuffer::cppGet_isEmpty)},
      {String::cppNew("cppGet_isNotEmpty"),
       reinterpret_cast<void*>(&CppStringBuffer::cppGet_isNotEmpty)}};
  static Type* runtimeType = new Type("CppStringBuffer");
  Object* ptr = new ObjectImp(const_cast<Type*>(runtimeType), &v_ptrs);
  return ptr;
}

//  dart.collection
Object* CppWasmMap::cppCtr_(Object* cppThis, Object* map) {
  return cppThis;
}

Object* CppWasmMap::cast(Object* cppThis) {
  return CppWasmMap::cppCtr_(
      CppWasmMap::cppNew(),
      cppApply<Object*>(CppGet<Object*>(cppThis, String::cppNew("_map")),
                        String::cppNew("cast")));
}

Object* CppWasmMap::cppNew() {
  static std::map<String*, void*> v_ptrs = {
      {String::cppNew("toString"), reinterpret_cast<void*>(&MapView::toString)},
      {String::cppNew("cast"), reinterpret_cast<void*>(&CppWasmMap::cast)},
      {String::cppNew("cpp_subscript"),
       reinterpret_cast<void*>(&Map::cpp_subscript)},
      {String::cppNew("cpp_subscriptAssign"),
       reinterpret_cast<void*>(&_UnmodifiableMapMixin::cpp_subscriptAssign)},
      {String::cppNew("addAll"),
       reinterpret_cast<void*>(&_UnmodifiableMapMixin::addAll)},
      {String::cppNew("clear"),
       reinterpret_cast<void*>(&_UnmodifiableMapMixin::clear)},
      {String::cppNew("putIfAbsent"),
       reinterpret_cast<void*>(&_UnmodifiableMapMixin::putIfAbsent)},
      {String::cppNew("containsKey"),
       reinterpret_cast<void*>(&Map::containsKey)},
      {String::cppNew("containsValue"),
       reinterpret_cast<void*>(&Map::containsValue)},
      {String::cppNew("forEach"), reinterpret_cast<void*>(&Map::forEach)},
      {String::cppNew("cppGet_isEmpty"),
       reinterpret_cast<void*>(&Map::cppGet_isEmpty)},
      {String::cppNew("cppGet_isNotEmpty"),
       reinterpret_cast<void*>(&Map::cppGet_isNotEmpty)},
      {String::cppNew("cppGet_length"),
       reinterpret_cast<void*>(&Map::cppGet_length)},
      {String::cppNew("cppGet_keys"),
       reinterpret_cast<void*>(&Map::cppGet_keys)},
      {String::cppNew("remove"),
       reinterpret_cast<void*>(&_UnmodifiableMapMixin::remove)},
      {String::cppNew("cppGet_values"),
       reinterpret_cast<void*>(&Map::cppGet_values)},
      {String::cppNew("cppGet_entries"),
       reinterpret_cast<void*>(&Map::cppGet_entries)},
      {String::cppNew("addEntries"),
       reinterpret_cast<void*>(&_UnmodifiableMapMixin::addEntries)},
      {String::cppNew("map"), reinterpret_cast<void*>(&Map::map)},
      {String::cppNew("update"),
       reinterpret_cast<void*>(&_UnmodifiableMapMixin::update)},
      {String::cppNew("updateAll"),
       reinterpret_cast<void*>(&_UnmodifiableMapMixin::updateAll)},
      {String::cppNew("removeWhere"),
       reinterpret_cast<void*>(&_UnmodifiableMapMixin::removeWhere)}};
  static Type* runtimeType = new Type("CppWasmMap");
  Object* ptr = new ObjectImp(const_cast<Type*>(runtimeType), &v_ptrs);
  return ptr;
}

//  dart._internal
Object* Sort::cppCtr_(Object* cppThis) {
  return cppThis;
}

void Sort::sort(Object* a, Function* compare) {
  Sort::_doSort(
      a, Int::cppNew(0),
      Num::cpp_subtract(cppApply<Int*>(a, String::cppNew("cppGet_length")),
                        Int::cppNew(1)),
      compare);
}

void Sort::sortRange(Object* a, Int* from, Int* to, Function* compare) {
  if (CppApi::cppBoolValue(
          CppApi::cppBoolValue(
              CppApi::cppBoolValue(Num::cpp_lessThan(from, Int::cppNew(0))) ||
              CppApi::cppBoolValue(Num::cpp_greaterThan(
                  to, cppApply<Int*>(a, String::cppNew("cppGet_length"))))) ||
          CppApi::cppBoolValue(Num::cpp_lessThan(to, from)))) {
    throw "StringLiteral(OutOfRange)";
  }
  Sort::_doSort(a, from, Num::cpp_subtract(to, Int::cppNew(1)), compare);
}

void Sort::_doSort(Object* a, Int* left, Int* right, Function* compare) {
  if (CppApi::cppBoolValue(Num::cpp_lessThanOrEqual(
          Num::cpp_subtract(right, left), Int::cppNew(32)))) {
    Sort::_insertionSort(a, left, right, compare);
  } else {
    Sort::_dualPivotQuicksort(a, left, right, compare);
  }
}

void Sort::_insertionSort(Object* a, Int* left, Int* right, Function* compare) {
  {
    Int* i = Num::cpp_add(left, Int::cppNew(1));
    while (CppApi::cppBoolValue(Num::cpp_lessThanOrEqual(i, right))) {
      {
        Object* el =
            cppApply<Object*, Int*>(a, String::cppNew("cpp_subscript"), i);
        Int* j = i;
        while (CppApi::cppBoolValue(
            CppApi::cppBoolValue(Num::cpp_greaterThan(j, left)) &&
            CppApi::cppBoolValue(Num::cpp_greaterThan(
                cppApply<Int*>(compare,
                               cppApply<Object*, Int*>(
                                   a, String::cppNew("cpp_subscript"),
                                   Num::cpp_subtract(j, Int::cppNew(1))),
                               el),
                Int::cppNew(0))))) {
          cppApply<void, Int*, Object*>(
              a, String::cppNew("cpp_subscriptAssign"), j,
              cppApply<Object*, Int*>(a, String::cppNew("cpp_subscript"),
                                      Num::cpp_subtract(j, Int::cppNew(1))));
          j = Num::cpp_subtract(j, Int::cppNew(1));
        }
        cppApply<void, Int*, Object*>(a, String::cppNew("cpp_subscriptAssign"),
                                      j, el);
      }
      i = Num::cpp_add(i, Int::cppNew(1));
    }
  }
}

void Sort::_dualPivotQuicksort(Object* a,
                               Int* left,
                               Int* right,
                               Function* compare) {
  print("assert");
  Int* sixth = Num::cpp_truncDiv(
      Num::cpp_add(Num::cpp_subtract(right, left), Int::cppNew(1)),
      Int::cppNew(6));
  Int* index1 = Num::cpp_add(left, sixth);
  Int* index5 = Num::cpp_subtract(right, sixth);
  Int* index3 = Num::cpp_truncDiv(Num::cpp_add(left, right), Int::cppNew(2));
  Int* index2 = Num::cpp_subtract(index3, sixth);
  Int* index4 = Num::cpp_add(index3, sixth);
  Object* el1 =
      cppApply<Object*, Int*>(a, String::cppNew("cpp_subscript"), index1);
  Object* el2 =
      cppApply<Object*, Int*>(a, String::cppNew("cpp_subscript"), index2);
  Object* el3 =
      cppApply<Object*, Int*>(a, String::cppNew("cpp_subscript"), index3);
  Object* el4 =
      cppApply<Object*, Int*>(a, String::cppNew("cpp_subscript"), index4);
  Object* el5 =
      cppApply<Object*, Int*>(a, String::cppNew("cpp_subscript"), index5);
  if (CppApi::cppBoolValue(Num::cpp_greaterThan(
          cppApply<Int*>(compare, el1, el2), Int::cppNew(0)))) {
    Object* t = el1;
    el1 = el2;
    el2 = t;
  }
  if (CppApi::cppBoolValue(Num::cpp_greaterThan(
          cppApply<Int*>(compare, el4, el5), Int::cppNew(0)))) {
    Object* t = el4;
    el4 = el5;
    el5 = t;
  }
  if (CppApi::cppBoolValue(Num::cpp_greaterThan(
          cppApply<Int*>(compare, el1, el3), Int::cppNew(0)))) {
    Object* t = el1;
    el1 = el3;
    el3 = t;
  }
  if (CppApi::cppBoolValue(Num::cpp_greaterThan(
          cppApply<Int*>(compare, el2, el3), Int::cppNew(0)))) {
    Object* t = el2;
    el2 = el3;
    el3 = t;
  }
  if (CppApi::cppBoolValue(Num::cpp_greaterThan(
          cppApply<Int*>(compare, el1, el4), Int::cppNew(0)))) {
    Object* t = el1;
    el1 = el4;
    el4 = t;
  }
  if (CppApi::cppBoolValue(Num::cpp_greaterThan(
          cppApply<Int*>(compare, el3, el4), Int::cppNew(0)))) {
    Object* t = el3;
    el3 = el4;
    el4 = t;
  }
  if (CppApi::cppBoolValue(Num::cpp_greaterThan(
          cppApply<Int*>(compare, el2, el5), Int::cppNew(0)))) {
    Object* t = el2;
    el2 = el5;
    el5 = t;
  }
  if (CppApi::cppBoolValue(Num::cpp_greaterThan(
          cppApply<Int*>(compare, el2, el3), Int::cppNew(0)))) {
    Object* t = el2;
    el2 = el3;
    el3 = t;
  }
  if (CppApi::cppBoolValue(Num::cpp_greaterThan(
          cppApply<Int*>(compare, el4, el5), Int::cppNew(0)))) {
    Object* t = el4;
    el4 = el5;
    el5 = t;
  }
  Object* pivot1 = el2;
  Object* pivot2 = el4;
  cppApply<void, Int*, Object*>(a, String::cppNew("cpp_subscriptAssign"),
                                index1, el1);
  cppApply<void, Int*, Object*>(a, String::cppNew("cpp_subscriptAssign"),
                                index3, el3);
  cppApply<void, Int*, Object*>(a, String::cppNew("cpp_subscriptAssign"),
                                index5, el5);
  cppApply<void, Int*, Object*>(
      a, String::cppNew("cpp_subscriptAssign"), index2,
      cppApply<Object*, Int*>(a, String::cppNew("cpp_subscript"), left));
  cppApply<void, Int*, Object*>(
      a, String::cppNew("cpp_subscriptAssign"), index4,
      cppApply<Object*, Int*>(a, String::cppNew("cpp_subscript"), right));
  Int* less = Num::cpp_add(left, Int::cppNew(1));
  Int* great = Num::cpp_subtract(right, Int::cppNew(1));
  Bool* pivots_are_equal = Object::cpp_equals(
      cppApply<Int*>(compare, pivot1, pivot2), Int::cppNew(0));
  if (CppApi::cppBoolValue(pivots_are_equal)) {
    Object* pivot = pivot1;
    {
      Int* k = less;
      while (CppApi::cppBoolValue(Num::cpp_lessThanOrEqual(k, great))) {
        {
          Object* ak =
              cppApply<Object*, Int*>(a, String::cppNew("cpp_subscript"), k);
          Int* comp = cppApply<Int*>(compare, ak, pivot);
          if (CppApi::cppBoolValue(Object::cpp_equals(comp, Int::cppNew(0))))
            break;
          if (CppApi::cppBoolValue(Num::cpp_lessThan(comp, Int::cppNew(0)))) {
            if (CppApi::cppBoolValue(
                    Bool::cpp_not(Object::cpp_equals(k, less)))) {
              cppApply<void, Int*, Object*>(
                  a, String::cppNew("cpp_subscriptAssign"), k,
                  cppApply<Object*, Int*>(a, String::cppNew("cpp_subscript"),
                                          less));
              cppApply<void, Int*, Object*>(
                  a, String::cppNew("cpp_subscriptAssign"), less, ak);
            }
            less = Num::cpp_add(less, Int::cppNew(1));
          } else {
            while (CppApi::cppBoolValue(Bool::cppNew(true)))

            {
              comp =
                  cppApply<Int*>(compare,
                                 cppApply<Object*, Int*>(
                                     a, String::cppNew("cpp_subscript"), great),
                                 pivot);
              if (CppApi::cppBoolValue(
                      Num::cpp_greaterThan(comp, Int::cppNew(0)))) {
                great = Num::cpp_subtract(great, Int::cppNew(1));
                break;
              } else if (CppApi::cppBoolValue(
                             Num::cpp_lessThan(comp, Int::cppNew(0)))) {
                cppApply<void, Int*, Object*>(
                    a, String::cppNew("cpp_subscriptAssign"), k,
                    cppApply<Object*, Int*>(a, String::cppNew("cpp_subscript"),
                                            less));
                cppApply<void, Int*, Object*>(
                    a, String::cppNew("cpp_subscriptAssign"), ([&]() {
                      Int* cppLet_0 = less;
                      return ([&]() {
                        Int* cppLet_0 = less =
                            Num::cpp_add(cppLet_0, Int::cppNew(1));
                        return cppLet_0;
                      })();
                    })(),
                    cppApply<Object*, Int*>(a, String::cppNew("cpp_subscript"),
                                            great));
                cppApply<void, Int*, Object*>(
                    a, String::cppNew("cpp_subscriptAssign"), ([&]() {
                      Int* cppLet_0 = great;
                      return ([&]() {
                        Int* cppLet_0 = great =
                            Num::cpp_subtract(cppLet_0, Int::cppNew(1));
                        return cppLet_0;
                      })();
                    })(),
                    ak);
                break;
              } else {
                cppApply<void, Int*, Object*>(
                    a, String::cppNew("cpp_subscriptAssign"), k,
                    cppApply<Object*, Int*>(a, String::cppNew("cpp_subscript"),
                                            great));
                cppApply<void, Int*, Object*>(
                    a, String::cppNew("cpp_subscriptAssign"), ([&]() {
                      Int* cppLet_0 = great;
                      return ([&]() {
                        Int* cppLet_0 = great =
                            Num::cpp_subtract(cppLet_0, Int::cppNew(1));
                        return cppLet_0;
                      })();
                    })(),
                    ak);
                break;
              }
            }
          }
        }
        k = Num::cpp_add(k, Int::cppNew(1));
      }
    }
  } else {
    {
      Int* k = less;
      while (CppApi::cppBoolValue(Num::cpp_lessThanOrEqual(k, great))) {
        {
          Object* ak =
              cppApply<Object*, Int*>(a, String::cppNew("cpp_subscript"), k);
          Int* comp_pivot1 = cppApply<Int*>(compare, ak, pivot1);
          if (CppApi::cppBoolValue(
                  Num::cpp_lessThan(comp_pivot1, Int::cppNew(0)))) {
            if (CppApi::cppBoolValue(
                    Bool::cpp_not(Object::cpp_equals(k, less)))) {
              cppApply<void, Int*, Object*>(
                  a, String::cppNew("cpp_subscriptAssign"), k,
                  cppApply<Object*, Int*>(a, String::cppNew("cpp_subscript"),
                                          less));
              cppApply<void, Int*, Object*>(
                  a, String::cppNew("cpp_subscriptAssign"), less, ak);
            }
            less = Num::cpp_add(less, Int::cppNew(1));
          } else {
            Int* comp_pivot2 = cppApply<Int*>(compare, ak, pivot2);
            if (CppApi::cppBoolValue(
                    Num::cpp_greaterThan(comp_pivot2, Int::cppNew(0)))) {
              while (CppApi::cppBoolValue(Bool::cppNew(true)))

              {
                Int* comp = cppApply<Int*>(
                    compare,
                    cppApply<Object*, Int*>(a, String::cppNew("cpp_subscript"),
                                            great),
                    pivot2);
                if (CppApi::cppBoolValue(
                        Num::cpp_greaterThan(comp, Int::cppNew(0)))) {
                  great = Num::cpp_subtract(great, Int::cppNew(1));
                  if (CppApi::cppBoolValue(Num::cpp_lessThan(great, k))) break;
                  break;
                } else {
                  comp = cppApply<Int*>(
                      compare,
                      cppApply<Object*, Int*>(
                          a, String::cppNew("cpp_subscript"), great),
                      pivot1);
                  if (CppApi::cppBoolValue(
                          Num::cpp_lessThan(comp, Int::cppNew(0)))) {
                    cppApply<void, Int*, Object*>(
                        a, String::cppNew("cpp_subscriptAssign"), k,
                        cppApply<Object*, Int*>(
                            a, String::cppNew("cpp_subscript"), less));
                    cppApply<void, Int*, Object*>(
                        a, String::cppNew("cpp_subscriptAssign"), ([&]() {
                          Int* cppLet_0 = less;
                          return ([&]() {
                            Int* cppLet_0 = less =
                                Num::cpp_add(cppLet_0, Int::cppNew(1));
                            return cppLet_0;
                          })();
                        })(),
                        cppApply<Object*, Int*>(
                            a, String::cppNew("cpp_subscript"), great));
                    cppApply<void, Int*, Object*>(
                        a, String::cppNew("cpp_subscriptAssign"), ([&]() {
                          Int* cppLet_0 = great;
                          return ([&]() {
                            Int* cppLet_0 = great =
                                Num::cpp_subtract(cppLet_0, Int::cppNew(1));
                            return cppLet_0;
                          })();
                        })(),
                        ak);
                  } else {
                    cppApply<void, Int*, Object*>(
                        a, String::cppNew("cpp_subscriptAssign"), k,
                        cppApply<Object*, Int*>(
                            a, String::cppNew("cpp_subscript"), great));
                    cppApply<void, Int*, Object*>(
                        a, String::cppNew("cpp_subscriptAssign"), ([&]() {
                          Int* cppLet_0 = great;
                          return ([&]() {
                            Int* cppLet_0 = great =
                                Num::cpp_subtract(cppLet_0, Int::cppNew(1));
                            return cppLet_0;
                          })();
                        })(),
                        ak);
                  }
                  break;
                }
              }
            }
          }
        }
        k = Num::cpp_add(k, Int::cppNew(1));
      }
    }
  }
  cppApply<void, Int*, Object*>(
      a, String::cppNew("cpp_subscriptAssign"), left,
      cppApply<Object*, Int*>(a, String::cppNew("cpp_subscript"),
                              Num::cpp_subtract(less, Int::cppNew(1))));
  cppApply<void, Int*, Object*>(a, String::cppNew("cpp_subscriptAssign"),
                                Num::cpp_subtract(less, Int::cppNew(1)),
                                pivot1);
  cppApply<void, Int*, Object*>(
      a, String::cppNew("cpp_subscriptAssign"), right,
      cppApply<Object*, Int*>(a, String::cppNew("cpp_subscript"),
                              Num::cpp_add(great, Int::cppNew(1))));
  cppApply<void, Int*, Object*>(a, String::cppNew("cpp_subscriptAssign"),
                                Num::cpp_add(great, Int::cppNew(1)), pivot2);
  Sort::_doSort(a, left, Num::cpp_subtract(less, Int::cppNew(2)), compare);
  Sort::_doSort(a, Num::cpp_add(great, Int::cppNew(2)), right, compare);
  if (CppApi::cppBoolValue(pivots_are_equal)) {
    return;
  }
  if (CppApi::cppBoolValue(
          CppApi::cppBoolValue(Num::cpp_lessThan(less, index1)) &&
          CppApi::cppBoolValue(Num::cpp_greaterThan(great, index5)))) {
    while (CppApi::cppBoolValue(Object::cpp_equals(
        cppApply<Int*>(
            compare,
            cppApply<Object*, Int*>(a, String::cppNew("cpp_subscript"), less),
            pivot1),
        Int::cppNew(0)))) {
      less = Num::cpp_add(less, Int::cppNew(1));
    }
    while (CppApi::cppBoolValue(Object::cpp_equals(
        cppApply<Int*>(
            compare,
            cppApply<Object*, Int*>(a, String::cppNew("cpp_subscript"), great),
            pivot2),
        Int::cppNew(0)))) {
      great = Num::cpp_subtract(great, Int::cppNew(1));
    }
    {
      Int* k = less;
      while (CppApi::cppBoolValue(Num::cpp_lessThanOrEqual(k, great))) {
        {
          Object* ak =
              cppApply<Object*, Int*>(a, String::cppNew("cpp_subscript"), k);
          Int* comp_pivot1 = cppApply<Int*>(compare, ak, pivot1);
          if (CppApi::cppBoolValue(
                  Object::cpp_equals(comp_pivot1, Int::cppNew(0)))) {
            if (CppApi::cppBoolValue(
                    Bool::cpp_not(Object::cpp_equals(k, less)))) {
              cppApply<void, Int*, Object*>(
                  a, String::cppNew("cpp_subscriptAssign"), k,
                  cppApply<Object*, Int*>(a, String::cppNew("cpp_subscript"),
                                          less));
              cppApply<void, Int*, Object*>(
                  a, String::cppNew("cpp_subscriptAssign"), less, ak);
            }
            less = Num::cpp_add(less, Int::cppNew(1));
          } else {
            Int* comp_pivot2 = cppApply<Int*>(compare, ak, pivot2);
            if (CppApi::cppBoolValue(
                    Object::cpp_equals(comp_pivot2, Int::cppNew(0)))) {
              while (CppApi::cppBoolValue(Bool::cppNew(true)))

              {
                Int* comp = cppApply<Int*>(
                    compare,
                    cppApply<Object*, Int*>(a, String::cppNew("cpp_subscript"),
                                            great),
                    pivot2);
                if (CppApi::cppBoolValue(
                        Object::cpp_equals(comp, Int::cppNew(0)))) {
                  great = Num::cpp_subtract(great, Int::cppNew(1));
                  if (CppApi::cppBoolValue(Num::cpp_lessThan(great, k))) break;
                  break;
                } else {
                  comp = cppApply<Int*>(
                      compare,
                      cppApply<Object*, Int*>(
                          a, String::cppNew("cpp_subscript"), great),
                      pivot1);
                  if (CppApi::cppBoolValue(
                          Num::cpp_lessThan(comp, Int::cppNew(0)))) {
                    cppApply<void, Int*, Object*>(
                        a, String::cppNew("cpp_subscriptAssign"), k,
                        cppApply<Object*, Int*>(
                            a, String::cppNew("cpp_subscript"), less));
                    cppApply<void, Int*, Object*>(
                        a, String::cppNew("cpp_subscriptAssign"), ([&]() {
                          Int* cppLet_0 = less;
                          return ([&]() {
                            Int* cppLet_0 = less =
                                Num::cpp_add(cppLet_0, Int::cppNew(1));
                            return cppLet_0;
                          })();
                        })(),
                        cppApply<Object*, Int*>(
                            a, String::cppNew("cpp_subscript"), great));
                    cppApply<void, Int*, Object*>(
                        a, String::cppNew("cpp_subscriptAssign"), ([&]() {
                          Int* cppLet_0 = great;
                          return ([&]() {
                            Int* cppLet_0 = great =
                                Num::cpp_subtract(cppLet_0, Int::cppNew(1));
                            return cppLet_0;
                          })();
                        })(),
                        ak);
                  } else {
                    cppApply<void, Int*, Object*>(
                        a, String::cppNew("cpp_subscriptAssign"), k,
                        cppApply<Object*, Int*>(
                            a, String::cppNew("cpp_subscript"), great));
                    cppApply<void, Int*, Object*>(
                        a, String::cppNew("cpp_subscriptAssign"), ([&]() {
                          Int* cppLet_0 = great;
                          return ([&]() {
                            Int* cppLet_0 = great =
                                Num::cpp_subtract(cppLet_0, Int::cppNew(1));
                            return cppLet_0;
                          })();
                        })(),
                        ak);
                  }
                  break;
                }
              }
            }
          }
        }
        k = Num::cpp_add(k, Int::cppNew(1));
      }
    }
    Sort::_doSort(a, less, great, compare);
  } else {
    Sort::_doSort(a, less, great, compare);
  }
}

Object* Sort::cppNew() {
  static std::map<String*, void*> v_ptrs = {
      {String::cppNew("toString"), reinterpret_cast<void*>(&Object::toString)}};
  static Type* runtimeType = new Type("Sort");
  Object* ptr = new ObjectImp(const_cast<Type*>(runtimeType), &v_ptrs);
  return ptr;
}

//  dart.math
Object* Random::cppEpt_(Int* seed) {
  Int* state = _Random::_setupSeed(
      CppApi::cppBoolValue(Bool::cppNew(seed == nullptr)) ? _Random::_nextSeed()
                                                          : seed);
  return ([&]() {
    Object* cppLet_0 = _Random::cppCtr__withState(_Random::cppNew(), state);
    cppApply<void>(cppLet_0, String::cppNew("_nextState"));
    cppApply<void>(cppLet_0, String::cppNew("_nextState"));
    cppApply<void>(cppLet_0, String::cppNew("_nextState"));
    cppApply<void>(cppLet_0, String::cppNew("_nextState"));
    return cppLet_0;
  })();
}

Object* Random::secure() {
  return;
}

Object* Random::cppNew() {
  static std::map<String*, void*> v_ptrs = {
      {String::cppNew("toString"), reinterpret_cast<void*>(&Object::toString)}};
  static Type* runtimeType = new Type("Random");
  Object* ptr = new ObjectImp(const_cast<Type*>(runtimeType), &v_ptrs);
  return ptr;
}

//  nativewrappers
Object* NativeFieldWrapperClass1::cppCtr_(Object* cppThis) {
  return cppThis;
}

Object* NativeFieldWrapperClass1::cppNew() {
  static std::map<String*, void*> v_ptrs = {
      {String::cppNew("toString"), reinterpret_cast<void*>(&Object::toString)}};
  static Type* runtimeType = new Type("NativeFieldWrapperClass1");
  Object* ptr = new ObjectImp(const_cast<Type*>(runtimeType), &v_ptrs);
  return ptr;
}

//  nativewrappers
Object* NativeFieldWrapperClass2::cppCtr_(Object* cppThis) {
  return cppThis;
}

Object* NativeFieldWrapperClass2::cppNew() {
  static std::map<String*, void*> v_ptrs = {
      {String::cppNew("toString"), reinterpret_cast<void*>(&Object::toString)}};
  static Type* runtimeType = new Type("NativeFieldWrapperClass2");
  Object* ptr = new ObjectImp(const_cast<Type*>(runtimeType), &v_ptrs);
  return ptr;
}

//  nativewrappers
Object* NativeFieldWrapperClass3::cppCtr_(Object* cppThis) {
  return cppThis;
}

Object* NativeFieldWrapperClass3::cppNew() {
  static std::map<String*, void*> v_ptrs = {
      {String::cppNew("toString"), reinterpret_cast<void*>(&Object::toString)}};
  static Type* runtimeType = new Type("NativeFieldWrapperClass3");
  Object* ptr = new ObjectImp(const_cast<Type*>(runtimeType), &v_ptrs);
  return ptr;
}

//  nativewrappers
Object* NativeFieldWrapperClass4::cppCtr_(Object* cppThis) {
  return cppThis;
}

Object* NativeFieldWrapperClass4::cppNew() {
  static std::map<String*, void*> v_ptrs = {
      {String::cppNew("toString"), reinterpret_cast<void*>(&Object::toString)}};
  static Type* runtimeType = new Type("NativeFieldWrapperClass4");
  Object* ptr = new ObjectImp(const_cast<Type*>(runtimeType), &v_ptrs);
  return ptr;
}

//  dart.core
Object* Comparable::cppCtr_(Object* cppThis) {
  return cppThis;
}

Int* Comparable::compare(Object* a, Object* b) {
  return cppApply<Int*, void**>(a, String::cppNew("compareTo"), b);
}

Object* Comparable::cppNew() {
  static std::map<String*, void*> v_ptrs = {
      {String::cppNew("toString"), reinterpret_cast<void*>(&Object::toString)}};
  static Type* runtimeType = new Type("Comparable");
  Object* ptr = new ObjectImp(const_cast<Type*>(runtimeType), &v_ptrs);
  return ptr;
}

//  dart.core
Object* RangeError::cppCtr_(Object* cppThis, void** message) {
  CppSet<Object*>(cppThis, String::cppNew("start"), nullptr);
  CppSet<Object*>(cppThis, String::cppNew("end"), nullptr);

  return cppThis;
}

Object* RangeError::cppCtr_value(Object* cppThis,
                                 Num* value,
                                 String* name,
                                 String* message) {
  CppSet<Object*>(cppThis, String::cppNew("start"), nullptr);
  CppSet<Object*>(cppThis, String::cppNew("end"), nullptr);

  return cppThis;
}

Object* RangeError::cppCtr_range(Object* cppThis,
                                 Num* invalidValue,
                                 Int* minValue,
                                 Int* maxValue,
                                 String* name,
                                 String* message) {
  CppSet<Object*>(cppThis, String::cppNew("start"), minValue);
  CppSet<Object*>(cppThis, String::cppNew("end"), maxValue);

  return cppThis;
}

Num* RangeError::cppGet_invalidValue(Object* cppThis) {
  return reinterpret_cast<Num*>(cppThis->invalidValue);
}

Object* RangeError::index(Int* index,
                          void** indexable,
                          String* name,
                          String* message,
                          Int* length) {
  return IndexError::cppCtr_(IndexError::cppNew(), index, indexable, name,
                             message, length);
}

Int* RangeError::checkValueInInterval(Int* value,
                                      Int* minValue,
                                      Int* maxValue,
                                      String* name,
                                      String* message) {
  if (CppApi::cppBoolValue(
          CppApi::cppBoolValue(Num::cpp_lessThan(value, minValue)) ||
          CppApi::cppBoolValue(Num::cpp_greaterThan(value, maxValue)))) {
    throw "ConstructorInvocation(new RangeError.range(value, minValue, maxValue, name, message))";
  }
  return value;
}

Unhandled expression type : DynamicGet Int* RangeError::checkValidIndex(
                                Int* index,
                                void** indexable,
                                String* name,
                                Int* length,
                                String* message) {
  CppApi::cppBoolValue(Bool::cppNew(length == nullptr))
      ? length = reinterpret_cast<Int*>()
      : nullptr;
  return IndexError::check(index, length, indexable, name, message);
}

Int* RangeError::checkValidRange(Int* start,
                                 Int* end,
                                 Int* length,
                                 String* startName,
                                 String* endName,
                                 String* message) {
  if (CppApi::cppBoolValue(
          CppApi::cppBoolValue(Num::cpp_greaterThan(Int::cppNew(0), start)) ||
          CppApi::cppBoolValue(Num::cpp_greaterThan(start, length)))) {
    CppApi::cppBoolValue(Bool::cppNew(startName == nullptr))
        ? startName = String::cppNew("start")
        : nullptr;
    throw "ConstructorInvocation(new RangeError.range(start, 0, length, startName{String}, message))";
  }
  if (CppApi::cppBoolValue(Bool::cpp_not(Bool::cppNew(end == nullptr)))) {
    if (CppApi::cppBoolValue(
            CppApi::cppBoolValue(Num::cpp_greaterThan(start, end)) ||
            CppApi::cppBoolValue(Num::cpp_greaterThan(end, length)))) {
      CppApi::cppBoolValue(Bool::cppNew(endName == nullptr))
          ? endName = String::cppNew("end")
          : nullptr;
      throw "ConstructorInvocation(new RangeError.range(end{int}, start, length, endName{String}, message))";
    }
    return end;
  }
  return length;
}

Int* RangeError::checkNotNegative(Int* value, String* name, String* message) {
  if (CppApi::cppBoolValue(Num::cpp_lessThan(value, Int::cppNew(0)))) {
    throw "ConstructorInvocation(new RangeError.range(value, 0, null, let final String? #0 = name in #0 == null ?{String} index : #0{String}, message))";
  }
  return value;
}

String* RangeError::cppGet__errorName(Object* cppThis) {
  return String::cppNew("RangeError");
}

String* RangeError::cppGet__errorExplanation(Object* cppThis) {
  print("assert");
  String* explanation = String::cppNew("");
  Num* start = CppGet<Num*>(cppThis, String::cppNew("start"));
  Num* end = CppGet<Num*>(cppThis, String::cppNew("end"));
  if (CppApi::cppBoolValue(Bool::cppNew(start == nullptr))) {
    if (CppApi::cppBoolValue(Bool::cpp_not(Bool::cppNew(end == nullptr)))) {
      explanation = String::cpp_add(
          cppToString(String::cppNew(": Not less than or equal to ")),
          cppToString(end));
    }
  } else if (CppApi::cppBoolValue(Bool::cppNew(end == nullptr))) {
    explanation = String::cpp_add(
        cppToString(String::cppNew(": Not greater than or equal to ")),
        cppToString(start));
  } else if (CppApi::cppBoolValue(Num::cpp_greaterThan(end, start))) {
    explanation = String::cpp_add(
        String::cpp_add(String::cpp_add(cppToString(String::cppNew(
                                            ": Not in inclusive range ")),
                                        cppToString(start)),
                        cppToString(String::cppNew(".."))),
        cppToString(end));
  } else if (CppApi::cppBoolValue(Num::cpp_lessThan(end, start))) {
    explanation = String::cppNew(": Valid value range is empty");
  } else {
    explanation =
        String::cpp_add(cppToString(String::cppNew(": Only valid value is ")),
                        cppToString(start));
  }
  return explanation;
}

Object* RangeError::cppNew() {
  static std::map<String*, void*> v_ptrs = {
      {String::cppNew("toString"),
       reinterpret_cast<void*>(&ArgumentError::toString)},
      {String::cppNew("cppGet_stackTrace"),
       reinterpret_cast<void*>(&Error::cppGet_stackTrace)},
      {String::cppNew("cppGet__errorName"),
       reinterpret_cast<void*>(&RangeError::cppGet__errorName)},
      {String::cppNew("cppGet__errorExplanation"),
       reinterpret_cast<void*>(&RangeError::cppGet__errorExplanation)},
      {String::cppNew("cppGet_invalidValue"),
       reinterpret_cast<void*>(&RangeError::cppGet_invalidValue)}};
  static Type* runtimeType = new Type("RangeError");
  Object* ptr = new ObjectImp(const_cast<Type*>(runtimeType), &v_ptrs);
  return ptr;
}

//  dart.core
Object* Iterable::cppCtr_(Object* cppThis) {
  return cppThis;
}

Object* Iterable::generate(Int* count, Function* generator) {
  if (CppApi::cppBoolValue(Num::cpp_lessThanOrEqual(count, Int::cppNew(0))))
    return EmptyIterable::cppCtr_(EmptyIterable::cppNew());
  if (CppApi::cppBoolValue(Bool::cppNew(generator == nullptr))) {
    Object* id = AA<_GeneratorIterable._id> AA;
    if (CppApi::cppBoolValue(Bool::cpp_not(
            Bool::cppNew(reinterpret_cast<Function*>(id) == nullptr)))) {
      throw "ConstructorInvocation(new ArgumentError(Generator must be supplied or element type must allow integers, generator))";
    }
    generator = id;
  }
  return _GeneratorIterable::cppCtr_(_GeneratorIterable::cppNew(), count,
                                     generator);
}

Object* Iterable::withIterator(Function* iteratorFactory) {
  return _WithIteratorIterable::cppCtr_(_WithIteratorIterable::cppNew(),
                                        iteratorFactory);
}

Object* Iterable::empty() {
  return EmptyIterable::cppCtr_(EmptyIterable::cppNew());
}

Object* Iterable::castFrom(Object* source) {
  return CastIterable::cppEpt_(source);
}

Object* Iterable::cast(Object* cppThis) {
  return CastIterable::cppEpt_(cppThis);
}

Object* Iterable::followedBy(Object* cppThis, Object* other) {
  Object* self = cppThis;
  if (CppApi::cppBoolValue(
          Bool::cppNew(reinterpret_cast<Object*>(self) == nullptr))) {
    return FollowedByIterable::firstEfficient(self, other);
  }
  return FollowedByIterable::cppCtr_(FollowedByIterable::cppNew(), cppThis,
                                     other);
}

Object* Iterable::map(Object* cppThis, Function* toElement) {
  return MappedIterable::cppEpt_(cppThis, toElement);
}

Object* Iterable::where(Object* cppThis, Function* test) {
  return WhereIterable::cppCtr_(WhereIterable::cppNew(), cppThis, test);
}

Object* Iterable::whereType(Object* cppThis) {
  return WhereTypeIterable::cppCtr_(WhereTypeIterable::cppNew(), cppThis);
}

Object* Iterable::expand(Object* cppThis, Function* toElements) {
  return ExpandIterable::cppCtr_(ExpandIterable::cppNew(), cppThis, toElements);
}

Bool* Iterable::contains(Object* cppThis, Object* element) {
  {
    Object* $sync_for_iterator =
        cppApply<Object*>(cppThis, String::cppNew("cppGet_iterator"));
    {
      while (CppApi::cppBoolValue(
          cppApply<Bool*>($sync_for_iterator, String::cppNew("moveNext")))) {
        {
          Object* e = cppApply<Object*>($sync_for_iterator,
                                        String::cppNew("cppGet_current"));
          {
            if (CppApi::cppBoolValue(Object::cpp_equals(e, element)))
              return Bool::cppNew(true);
          }
        }
      }
    }
  }
  return Bool::cppNew(false);
}

void Iterable::forEach(Object* cppThis, Function* action) {
  {
    Object* $sync_for_iterator =
        cppApply<Object*>(cppThis, String::cppNew("cppGet_iterator"));
    {
      while (CppApi::cppBoolValue(
          cppApply<Bool*>($sync_for_iterator, String::cppNew("moveNext")))) {
        {
          Object* element = cppApply<Object*>($sync_for_iterator,
                                              String::cppNew("cppGet_current"));
          cppApply<void>(action, element);
        }
      }
    }
  }
}

Object* Iterable::reduce(Object* cppThis, Function* combine) {
  Object* iterator =
      cppApply<Object*>(cppThis, String::cppNew("cppGet_iterator"));
  if (CppApi::cppBoolValue(Bool::cpp_not(
          cppApply<Bool*>(iterator, String::cppNew("moveNext"))))) {
    throw "StaticInvocation(IterableElementError.noElement())";
  }
  Object* value = cppApply<Object*>(iterator, String::cppNew("cppGet_current"));
  while (CppApi::cppBoolValue(
      cppApply<Bool*>(iterator, String::cppNew("moveNext")))) {
    value = cppApply<Object*>(
        combine, value,
        cppApply<Object*>(iterator, String::cppNew("cppGet_current")));
  }
  return value;
}

Object* Iterable::fold(Object* cppThis,
                       Object* initialValue,
                       Function* combine) {
  Object* value = initialValue;
  {
    Object* $sync_for_iterator =
        cppApply<Object*>(cppThis, String::cppNew("cppGet_iterator"));
    {
      while (CppApi::cppBoolValue(
          cppApply<Bool*>($sync_for_iterator, String::cppNew("moveNext")))) {
        {
          Object* element = cppApply<Object*>($sync_for_iterator,
                                              String::cppNew("cppGet_current"));
          value = cppApply<Object*>(combine, value, element);
        }
      }
    }
  }
  return value;
}

Bool* Iterable::every(Object* cppThis, Function* test) {
  {
    Object* $sync_for_iterator =
        cppApply<Object*>(cppThis, String::cppNew("cppGet_iterator"));
    {
      while (CppApi::cppBoolValue(
          cppApply<Bool*>($sync_for_iterator, String::cppNew("moveNext")))) {
        {
          Object* element = cppApply<Object*>($sync_for_iterator,
                                              String::cppNew("cppGet_current"));
          {
            if (CppApi::cppBoolValue(
                    Bool::cpp_not(cppApply<Bool*>(test, element))))
              return Bool::cppNew(false);
          }
        }
      }
    }
  }
  return Bool::cppNew(true);
}

String* Iterable::join(Object* cppThis, String* separator) {
  Object* iterator =
      cppApply<Object*>(cppThis, String::cppNew("cppGet_iterator"));
  if (CppApi::cppBoolValue(
          Bool::cpp_not(cppApply<Bool*>(iterator, String::cppNew("moveNext")))))
    return String::cppNew("");
  String* first = cppApply<String*>(
      cppApply<Object*>(iterator, String::cppNew("cppGet_current")),
      String::cppNew("toString"));
  if (CppApi::cppBoolValue(
          Bool::cpp_not(cppApply<Bool*>(iterator, String::cppNew("moveNext")))))
    return first;
  Object* buffer = StringBuffer::cppCtr_(StringBuffer::cppNew(), first);
  if (CppApi::cppBoolValue(
          CppApi::cppBoolValue(Bool::cppNew(separator == nullptr)) ||
          CppApi::cppBoolValue(
              cppApply<Bool*>(separator, String::cppNew("cppGet_isEmpty"))))) {
    do {
      cppApply<void, Object*>(
          buffer, String::cppNew("write"),
          cppApply<String*>(
              cppApply<Object*>(iterator, String::cppNew("cppGet_current")),
              String::cppNew("toString")));
    } while (CppApi::cppBoolValue(
        cppApply<Bool*>(iterator, String::cppNew("moveNext"))));
  } else {
    do {
      ([&]() {
        Object* cppLet_0 = buffer;
        cppApply<void, Object*>(cppLet_0, String::cppNew("write"), separator);
        cppApply<void, Object*>(
            cppLet_0, String::cppNew("write"),
            cppApply<String*>(
                cppApply<Object*>(iterator, String::cppNew("cppGet_current")),
                String::cppNew("toString")));
        return cppLet_0;
      })();
    } while (CppApi::cppBoolValue(
        cppApply<Bool*>(iterator, String::cppNew("moveNext"))));
  }
  return cppApply<String*>(buffer, String::cppNew("toString"));
}

Bool* Iterable::any(Object* cppThis, Function* test) {
  {
    Object* $sync_for_iterator =
        cppApply<Object*>(cppThis, String::cppNew("cppGet_iterator"));
    {
      while (CppApi::cppBoolValue(
          cppApply<Bool*>($sync_for_iterator, String::cppNew("moveNext")))) {
        {
          Object* element = cppApply<Object*>($sync_for_iterator,
                                              String::cppNew("cppGet_current"));
          {
            if (CppApi::cppBoolValue(cppApply<Bool*>(test, element)))
              return Bool::cppNew(true);
          }
        }
      }
    }
  }
  return Bool::cppNew(false);
}

Object* Iterable::toList(Object* cppThis, Bool* growable) {
  return List::of(cppThis, growable);
}

Object* Iterable::toSet(Object* cppThis) {
  return LinkedHashSet::of(cppThis);
}

Int* Iterable::cppGet_length(Object* cppThis) {
  print("assert");
  Int* count = Int::cppNew(0);
  Object* it = cppApply<Object*>(cppThis, String::cppNew("cppGet_iterator"));
  while (
      CppApi::cppBoolValue(cppApply<Bool*>(it, String::cppNew("moveNext")))) {
    count = Num::cpp_add(count, Int::cppNew(1));
  }
  return count;
}

Bool* Iterable::cppGet_isEmpty(Object* cppThis) {
  return Bool::cpp_not(cppApply<Bool*>(
      cppApply<Object*>(cppThis, String::cppNew("cppGet_iterator")),
      String::cppNew("moveNext")));
}

Bool* Iterable::cppGet_isNotEmpty(Object* cppThis) {
  return Bool::cpp_not(
      cppApply<Bool*>(cppThis, String::cppNew("cppGet_isEmpty")));
}

Object* Iterable::take(Object* cppThis, Int* count) {
  return TakeIterable::cppEpt_(cppThis, count);
}

Object* Iterable::takeWhile(Object* cppThis, Function* test) {
  return TakeWhileIterable::cppCtr_(TakeWhileIterable::cppNew(), cppThis, test);
}

Object* Iterable::skip(Object* cppThis, Int* count) {
  return SkipIterable::cppEpt_(cppThis, count);
}

Object* Iterable::skipWhile(Object* cppThis, Function* test) {
  return SkipWhileIterable::cppCtr_(SkipWhileIterable::cppNew(), cppThis, test);
}

Object* Iterable::cppGet_first(Object* cppThis) {
  Object* it = cppApply<Object*>(cppThis, String::cppNew("cppGet_iterator"));
  if (CppApi::cppBoolValue(
          Bool::cpp_not(cppApply<Bool*>(it, String::cppNew("moveNext"))))) {
    throw "StaticInvocation(IterableElementError.noElement())";
  }
  return cppApply<Object*>(it, String::cppNew("cppGet_current"));
}

Object* Iterable::cppGet_last(Object* cppThis) {
  Object* it = cppApply<Object*>(cppThis, String::cppNew("cppGet_iterator"));
  if (CppApi::cppBoolValue(
          Bool::cpp_not(cppApply<Bool*>(it, String::cppNew("moveNext"))))) {
    throw "StaticInvocation(IterableElementError.noElement())";
  }
  Object* result;
  do {
    result = cppApply<Object*>(it, String::cppNew("cppGet_current"));
  } while (
      CppApi::cppBoolValue(cppApply<Bool*>(it, String::cppNew("moveNext"))));
  return result;
}

Object* Iterable::cppGet_single(Object* cppThis) {
  Object* it = cppApply<Object*>(cppThis, String::cppNew("cppGet_iterator"));
  if (CppApi::cppBoolValue(
          Bool::cpp_not(cppApply<Bool*>(it, String::cppNew("moveNext")))))
    throw "StaticInvocation(IterableElementError.noElement())";
  Object* result = cppApply<Object*>(it, String::cppNew("cppGet_current"));
  if (CppApi::cppBoolValue(cppApply<Bool*>(it, String::cppNew("moveNext"))))
    throw "StaticInvocation(IterableElementError.tooMany())";
  return result;
}

Object* Iterable::firstWhere(Object* cppThis,
                             Function* test,
                             Function* orElse) {
  {
    Object* $sync_for_iterator =
        cppApply<Object*>(cppThis, String::cppNew("cppGet_iterator"));
    {
      while (CppApi::cppBoolValue(
          cppApply<Bool*>($sync_for_iterator, String::cppNew("moveNext")))) {
        {
          Object* element = cppApply<Object*>($sync_for_iterator,
                                              String::cppNew("cppGet_current"));
          {
            if (CppApi::cppBoolValue(cppApply<Bool*>(test, element)))
              return element;
          }
        }
      }
    }
  }
  if (CppApi::cppBoolValue(Bool::cpp_not(Bool::cppNew(orElse == nullptr))))
    return cppApply<Object*>(orElse);
  throw "StaticInvocation(IterableElementError.noElement())";
}

Object* Iterable::lastWhere(Object* cppThis, Function* test, Function* orElse) {
  Object* iterator =
      cppApply<Object*>(cppThis, String::cppNew("cppGet_iterator"));
  Object* result;
  do {
    if (CppApi::cppBoolValue(Bool::cpp_not(
            cppApply<Bool*>(iterator, String::cppNew("moveNext"))))) {
      if (CppApi::cppBoolValue(Bool::cpp_not(Bool::cppNew(orElse == nullptr))))
        return cppApply<Object*>(orElse);
      throw "StaticInvocation(IterableElementError.noElement())";
    }
    result = cppApply<Object*>(iterator, String::cppNew("cppGet_current"));
  } while (CppApi::cppBoolValue(Bool::cpp_not(cppApply<Bool*>(test, result))));
  while (CppApi::cppBoolValue(
      cppApply<Bool*>(iterator, String::cppNew("moveNext")))) {
    Object* current =
        cppApply<Object*>(iterator, String::cppNew("cppGet_current"));
    if (CppApi::cppBoolValue(cppApply<Bool*>(test, current))) result = current;
  }
  return result;
}

Object* Iterable::singleWhere(Object* cppThis,
                              Function* test,
                              Function* orElse) {
  Object* iterator =
      cppApply<Object*>(cppThis, String::cppNew("cppGet_iterator"));
  Object* result;
  do {
    if (CppApi::cppBoolValue(Bool::cpp_not(
            cppApply<Bool*>(iterator, String::cppNew("moveNext"))))) {
      if (CppApi::cppBoolValue(Bool::cpp_not(Bool::cppNew(orElse == nullptr))))
        return cppApply<Object*>(orElse);
      throw "StaticInvocation(IterableElementError.noElement())";
    }
    result = cppApply<Object*>(iterator, String::cppNew("cppGet_current"));
  } while (CppApi::cppBoolValue(Bool::cpp_not(cppApply<Bool*>(test, result))));
  while (CppApi::cppBoolValue(
      cppApply<Bool*>(iterator, String::cppNew("moveNext")))) {
    if (CppApi::cppBoolValue(cppApply<Bool*>(
            test,
            cppApply<Object*>(iterator, String::cppNew("cppGet_current")))))
      throw "StaticInvocation(IterableElementError.tooMany())";
  }
  return result;
}

Object* Iterable::elementAt(Object* cppThis, Int* index) {
  RangeError::checkNotNegative(index, String::cppNew("index"), nullptr);
  Object* iterator =
      cppApply<Object*>(cppThis, String::cppNew("cppGet_iterator"));
  Int* skipCount = index;
  while (CppApi::cppBoolValue(
      cppApply<Bool*>(iterator, String::cppNew("moveNext")))) {
    if (CppApi::cppBoolValue(Object::cpp_equals(skipCount, Int::cppNew(0))))
      return cppApply<Object*>(iterator, String::cppNew("cppGet_current"));
    skipCount = Num::cpp_subtract(skipCount, Int::cppNew(1));
  }
  throw "ConstructorInvocation(new IndexError.withLength(index, index.{num.-}(skipCount), indexable: this, name: index))";
}

String* Iterable::toString(Object* cppThis) {
  return Iterable::iterableToShortString(cppThis, String::cppNew("("),
                                         String::cppNew(")"));
}

String* Iterable::iterableToShortString(Object* iterable,
                                        String* leftDelimiter,
                                        String* rightDelimiter) {
  if (CppApi::cppBoolValue(isToStringVisiting(iterable))) {
    if (CppApi::cppBoolValue(CppApi::cppBoolValue(Object::cpp_equals(
                                 leftDelimiter, String::cppNew("("))) &&
                             CppApi::cppBoolValue(Object::cpp_equals(
                                 rightDelimiter, String::cppNew(")"))))) {
      return String::cppNew("(...)");
    }
    return String::cpp_add(String::cpp_add(cppToString(leftDelimiter),
                                           cppToString(String::cppNew("..."))),
                           cppToString(rightDelimiter));
  }
  Object* parts = CppNewList(Int::cppNew(0));
  cppApply<void, Object*>(, String::cppNew("add"), iterable);
  try {
    { _iterablePartsToStrings(iterable, parts); }
  } finally {
    {
      print("assert");
      cppApply<Object*>(, String::cppNew("removeLast"));
    }
  };
  return cppApply<String*>(
      ([&]() {
        Object* cppLet_0 =
            StringBuffer::cppCtr_(StringBuffer::cppNew(), leftDelimiter);
        cppApply<void, Object*, String*>(cppLet_0, String::cppNew("writeAll"),
                                         parts, String::cppNew(", "));
        cppApply<void, Object*>(cppLet_0, String::cppNew("write"),
                                rightDelimiter);
        return cppLet_0;
      })(),
      String::cppNew("toString"));
}

String* Iterable::iterableToFullString(Object* iterable,
                                       String* leftDelimiter,
                                       String* rightDelimiter) {
  if (CppApi::cppBoolValue(isToStringVisiting(iterable))) {
    return String::cpp_add(String::cpp_add(cppToString(leftDelimiter),
                                           cppToString(String::cppNew("..."))),
                           cppToString(rightDelimiter));
  }
  Object* buffer = StringBuffer::cppCtr_(StringBuffer::cppNew(), leftDelimiter);
  cppApply<void, Object*>(, String::cppNew("add"), iterable);
  try {
    {
      cppApply<void, Object*, String*>(buffer, String::cppNew("writeAll"),
                                       iterable, String::cppNew(", "));
    }
  } finally {
    {
      print("assert");
      cppApply<Object*>(, String::cppNew("removeLast"));
    }
  };
  cppApply<void, Object*>(buffer, String::cppNew("write"), rightDelimiter);
  return cppApply<String*>(buffer, String::cppNew("toString"));
}

Object* Iterable::cppNew() {
  static std::map<String*, void*> v_ptrs = {
      {String::cppNew("toString"),
       reinterpret_cast<void*>(&Iterable::toString)},
      {String::cppNew("cast"), reinterpret_cast<void*>(&Iterable::cast)},
      {String::cppNew("followedBy"),
       reinterpret_cast<void*>(&Iterable::followedBy)},
      {String::cppNew("map"), reinterpret_cast<void*>(&Iterable::map)},
      {String::cppNew("where"), reinterpret_cast<void*>(&Iterable::where)},
      {String::cppNew("whereType"),
       reinterpret_cast<void*>(&Iterable::whereType)},
      {String::cppNew("expand"), reinterpret_cast<void*>(&Iterable::expand)},
      {String::cppNew("contains"),
       reinterpret_cast<void*>(&Iterable::contains)},
      {String::cppNew("forEach"), reinterpret_cast<void*>(&Iterable::forEach)},
      {String::cppNew("reduce"), reinterpret_cast<void*>(&Iterable::reduce)},
      {String::cppNew("fold"), reinterpret_cast<void*>(&Iterable::fold)},
      {String::cppNew("every"), reinterpret_cast<void*>(&Iterable::every)},
      {String::cppNew("join"), reinterpret_cast<void*>(&Iterable::join)},
      {String::cppNew("any"), reinterpret_cast<void*>(&Iterable::any)},
      {String::cppNew("toList"), reinterpret_cast<void*>(&Iterable::toList)},
      {String::cppNew("toSet"), reinterpret_cast<void*>(&Iterable::toSet)},
      {String::cppNew("cppGet_length"),
       reinterpret_cast<void*>(&Iterable::cppGet_length)},
      {String::cppNew("cppGet_isEmpty"),
       reinterpret_cast<void*>(&Iterable::cppGet_isEmpty)},
      {String::cppNew("cppGet_isNotEmpty"),
       reinterpret_cast<void*>(&Iterable::cppGet_isNotEmpty)},
      {String::cppNew("take"), reinterpret_cast<void*>(&Iterable::take)},
      {String::cppNew("takeWhile"),
       reinterpret_cast<void*>(&Iterable::takeWhile)},
      {String::cppNew("skip"), reinterpret_cast<void*>(&Iterable::skip)},
      {String::cppNew("skipWhile"),
       reinterpret_cast<void*>(&Iterable::skipWhile)},
      {String::cppNew("cppGet_first"),
       reinterpret_cast<void*>(&Iterable::cppGet_first)},
      {String::cppNew("cppGet_last"),
       reinterpret_cast<void*>(&Iterable::cppGet_last)},
      {String::cppNew("cppGet_single"),
       reinterpret_cast<void*>(&Iterable::cppGet_single)},
      {String::cppNew("firstWhere"),
       reinterpret_cast<void*>(&Iterable::firstWhere)},
      {String::cppNew("lastWhere"),
       reinterpret_cast<void*>(&Iterable::lastWhere)},
      {String::cppNew("singleWhere"),
       reinterpret_cast<void*>(&Iterable::singleWhere)},
      {String::cppNew("elementAt"),
       reinterpret_cast<void*>(&Iterable::elementAt)}};
  static Type* runtimeType = new Type("Iterable");
  Object* ptr = new ObjectImp(const_cast<Type*>(runtimeType), &v_ptrs);
  return ptr;
}

//  dart.core
Object* Iterator::cppCtr_(Object* cppThis) {
  return cppThis;
}

Object* Iterator::cppNew() {
  static std::map<String*, void*> v_ptrs = {
      {String::cppNew("toString"), reinterpret_cast<void*>(&Object::toString)}};
  static Type* runtimeType = new Type("Iterator");
  Object* ptr = new ObjectImp(const_cast<Type*>(runtimeType), &v_ptrs);
  return ptr;
}

//  dart.core
Object* List::filled(Int* length, Object* fill, Bool* growable) {
  return CppApi::cppBoolValue(growable) ? CppNewList(length, fill)
                                        : _List::filled(length, fill);
}

Object* List::empty(Bool* growable) {
  return CppApi::cppBoolValue(growable) ? CppNewList(Int::cppNew(0))
                                        : _List::cppEpt_(Int::cppNew(0));
}

Object* List::from(Object* elements, Bool* growable) {
  if (CppApi::cppBoolValue(
          Bool::cppNew(reinterpret_cast<Object*>(elements) == nullptr))) {
    return List::of(elements, growable);
  }
  Object* list = CppNewList(Int::cppNew(0));
  {
    Object* $sync_for_iterator =
        cppApply<Object*>(elements, String::cppNew("cppGet_iterator"));
    {
      while (CppApi::cppBoolValue(
          cppApply<Bool*>($sync_for_iterator, String::cppNew("moveNext")))) {
        {
          void** cppLet_0 = cppApply<void**>($sync_for_iterator,
                                             String::cppNew("cppGet_current"));
          {
            Object* e = reinterpret_cast<Object*>(cppLet_0);
            cppApply<void, Object*>(list, String::cppNew("add"), e);
          }
        }
      }
    }
  }
  if (CppApi::cppBoolValue(growable)) return list;
  return makeListFixedLength(list);
}

Object* List::of(Object* elements, Bool* growable) {
  return CppApi::cppBoolValue(growable) ? CppNewList(elements)
                                        : _List::of(elements);
}

Object* List::generate(Int* length, Function* generator, Bool* growable) {
  return CppApi::cppBoolValue(growable) ? CppNewList(length, generator)
                                        : _List::generate(length, generator);
}

Object* List::unmodifiable(Object* elements) {
  Object* result = List::from(elements, Bool::cppNew(false));
  return makeFixedListUnmodifiable(result);
}

Object* List::castFrom(Object* source) {
  return CastList::cppCtr_(CastList::cppNew(), source);
}

void List::copyRange(Object* target,
                     Int* at,
                     Object* source,
                     Int* start,
                     Int* end) {
  CppApi::cppBoolValue(Bool::cppNew(start == nullptr)) ? start = Int::cppNew(0)
                                                       : nullptr;
  end = RangeError::checkValidRange(
      start, end, cppApply<Int*>(source, String::cppNew("cppGet_length")),
      nullptr, nullptr, nullptr);
  if (CppApi::cppBoolValue(Bool::cppNew(end == nullptr))) {
    throw "StringLiteral(unreachable)";
  }
  Int* length = Num::cpp_subtract(end, start);
  if (CppApi::cppBoolValue(Num::cpp_lessThan(
          cppApply<Int*>(target, String::cppNew("cppGet_length")),
          Num::cpp_add(at, length)))) {
    throw "ConstructorInvocation(new ArgumentError.value(target, target, Not big enough to hold ${length} elements at position ${at}))";
  }
  if (CppApi::cppBoolValue(
          CppApi::cppBoolValue(Bool::cpp_not(identical(source, target))) ||
          CppApi::cppBoolValue(Num::cpp_greaterThanOrEqual(start, at)))) {
    {
      Int* i = Int::cppNew(0);
      while (CppApi::cppBoolValue(Num::cpp_lessThan(i, length))) {
        {
          cppApply<void, Int*, Object*>(
              target, String::cppNew("cpp_subscriptAssign"),
              Num::cpp_add(at, i),
              cppApply<Object*, Int*>(source, String::cppNew("cpp_subscript"),
                                      Num::cpp_add(start, i)));
        }
        i = Num::cpp_add(i, Int::cppNew(1));
      }
    }
  } else {
    {
      Int* i = length;
      while (CppApi::cppBoolValue(Num::cpp_greaterThanOrEqual(
          i = Num::cpp_subtract(i, Int::cppNew(1)), Int::cppNew(0)))) {
        {
          cppApply<void, Int*, Object*>(
              target, String::cppNew("cpp_subscriptAssign"),
              Num::cpp_add(at, i),
              cppApply<Object*, Int*>(source, String::cppNew("cpp_subscript"),
                                      Num::cpp_add(start, i)));
        }
      }
    }
  }
}

void List::writeIterable(Object* target, Int* at, Object* source) {
  RangeError::checkValueInInterval(
      at, Int::cppNew(0),
      cppApply<Int*>(target, String::cppNew("cppGet_length")),
      String::cppNew("at"), nullptr);
  Int* index = at;
  Int* targetLength = cppApply<Int*>(target, String::cppNew("cppGet_length"));
  {
    Object* $sync_for_iterator =
        cppApply<Object*>(source, String::cppNew("cppGet_iterator"));
    {
      while (CppApi::cppBoolValue(
          cppApply<Bool*>($sync_for_iterator, String::cppNew("moveNext")))) {
        {
          Object* element = cppApply<Object*>($sync_for_iterator,
                                              String::cppNew("cppGet_current"));
          {
            if (CppApi::cppBoolValue(Object::cpp_equals(index, targetLength))) {
              throw "ConstructorInvocation(new IndexError.withLength(index, targetLength, indexable: target))";
            }
            cppApply<void, Int*, Object*>(
                target, String::cppNew("cpp_subscriptAssign"), index, element);
            index = Num::cpp_add(index, Int::cppNew(1));
          }
        }
      }
    }
  }
}

Object* List::cppNew() {
  static std::map<String*, void*> v_ptrs = {
      {String::cppNew("toString"),
       reinterpret_cast<void*>(&Iterable::toString)},
      {String::cppNew("cppGet_iterator"),
       reinterpret_cast<void*>(&Iterable::cppGet_iterator)},
      {String::cppNew("cast"), reinterpret_cast<void*>(&Iterable::cast)},
      {String::cppNew("followedBy"),
       reinterpret_cast<void*>(&Iterable::followedBy)},
      {String::cppNew("map"), reinterpret_cast<void*>(&Iterable::map)},
      {String::cppNew("where"), reinterpret_cast<void*>(&Iterable::where)},
      {String::cppNew("whereType"),
       reinterpret_cast<void*>(&Iterable::whereType)},
      {String::cppNew("expand"), reinterpret_cast<void*>(&Iterable::expand)},
      {String::cppNew("contains"),
       reinterpret_cast<void*>(&Iterable::contains)},
      {String::cppNew("forEach"), reinterpret_cast<void*>(&Iterable::forEach)},
      {String::cppNew("reduce"), reinterpret_cast<void*>(&Iterable::reduce)},
      {String::cppNew("fold"), reinterpret_cast<void*>(&Iterable::fold)},
      {String::cppNew("every"), reinterpret_cast<void*>(&Iterable::every)},
      {String::cppNew("join"), reinterpret_cast<void*>(&Iterable::join)},
      {String::cppNew("any"), reinterpret_cast<void*>(&Iterable::any)},
      {String::cppNew("toList"), reinterpret_cast<void*>(&Iterable::toList)},
      {String::cppNew("toSet"), reinterpret_cast<void*>(&Iterable::toSet)},
      {String::cppNew("cppGet_length"),
       reinterpret_cast<void*>(&Iterable::cppGet_length)},
      {String::cppNew("cppGet_isEmpty"),
       reinterpret_cast<void*>(&Iterable::cppGet_isEmpty)},
      {String::cppNew("cppGet_isNotEmpty"),
       reinterpret_cast<void*>(&Iterable::cppGet_isNotEmpty)},
      {String::cppNew("take"), reinterpret_cast<void*>(&Iterable::take)},
      {String::cppNew("takeWhile"),
       reinterpret_cast<void*>(&Iterable::takeWhile)},
      {String::cppNew("skip"), reinterpret_cast<void*>(&Iterable::skip)},
      {String::cppNew("skipWhile"),
       reinterpret_cast<void*>(&Iterable::skipWhile)},
      {String::cppNew("cppGet_first"),
       reinterpret_cast<void*>(&Iterable::cppGet_first)},
      {String::cppNew("cppGet_last"),
       reinterpret_cast<void*>(&Iterable::cppGet_last)},
      {String::cppNew("cppGet_single"),
       reinterpret_cast<void*>(&Iterable::cppGet_single)},
      {String::cppNew("firstWhere"),
       reinterpret_cast<void*>(&Iterable::firstWhere)},
      {String::cppNew("lastWhere"),
       reinterpret_cast<void*>(&Iterable::lastWhere)},
      {String::cppNew("singleWhere"),
       reinterpret_cast<void*>(&Iterable::singleWhere)},
      {String::cppNew("elementAt"),
       reinterpret_cast<void*>(&Iterable::elementAt)}};
  static Type* runtimeType = new Type("List");
  Object* ptr = new ObjectImp(const_cast<Type*>(runtimeType), &v_ptrs);
  return ptr;
}

//  dart.core
Object* Map::_fromLiteral(Object* elements) {
  Object* map = _Map::cppCtr_(_Map::cppNew());
  Int* len = cppApply<Int*>(elements, String::cppNew("cppGet_length"));
  {
    Int* i = Int::cppNew(1);
    while (CppApi::cppBoolValue(Num::cpp_lessThan(i, len))) {
      {
        cppApply<void, Object*, Object*>(
            map, String::cppNew("cpp_subscriptAssign"),
            reinterpret_cast<Object*>(cppApply<void**, Int*>(
                elements, String::cppNew("cpp_subscript"),
                Num::cpp_subtract(i, Int::cppNew(1)))),
            reinterpret_cast<Object*>(cppApply<void**, Int*>(
                elements, String::cppNew("cpp_subscript"), i)));
      }
      i = Num::cpp_add(i, Int::cppNew(2));
    }
  }
  return map;
}

Object* Map::cppEpt_() {
  return _Map::cppCtr_(_Map::cppNew());
}

Object* Map::from(Object* other) {
  return LinkedHashMap::from(other);
}

Object* Map::of(Object* other) {
  return LinkedHashMap::of(other);
}

Object* Map::unmodifiable(Object* other) {
  return CppWasmMap::cppCtr_(CppWasmMap::cppNew(), LinkedHashMap::from(other));
}

Object* Map::identity() {
  return LinkedHashMap::identity();
}

Object* Map::fromIterable(Object* iterable, Function* key, Function* value) {
  return LinkedHashMap::fromIterable(iterable, key, value);
}

Object* Map::fromIterables(Object* keys, Object* values) {
  return LinkedHashMap::fromIterables(keys, values);
}

Object* Map::castFrom(Object* source) {
  return CastMap::cppCtr_(CastMap::cppNew(), source);
}

Object* Map::fromEntries(Object* entries) {
  return ([&]() {
    Object* cppLet_0 = CppNewMap();
    cppApply<void, Object*>(cppLet_0, String::cppNew("addEntries"), entries);
    return cppLet_0;
  })();
}

Object* Map::cppNew() {
  static std::map<String*, void*> v_ptrs = {
      {String::cppNew("toString"), reinterpret_cast<void*>(&Object::toString)}};
  static Type* runtimeType = new Type("Map");
  Object* ptr = new ObjectImp(const_cast<Type*>(runtimeType), &v_ptrs);
  return ptr;
}

//  dart.core
Object* MapEntry::cppCtr__(Object* cppThis, Object* key, Object* value) {
  CppSet<Object*>(cppThis, String::cppNew("key"), key);
  CppSet<Object*>(cppThis, String::cppNew("value"), value);

  return cppThis;
}

Object* MapEntry::cppEpt_(Object* key, Object* value) {
  return MapEntry::cppCtr__(MapEntry::cppNew(), key, value);
}

String* MapEntry::toString(Object* cppThis) {
  return String::cpp_add(
      String::cpp_add(
          String::cpp_add(
              String::cpp_add(
                  cppToString(String::cppNew("MapEntry(")),
                  cppToString(CppGet<Object*>(cppThis, String::cppNew("key")))),
              cppToString(String::cppNew(": "))),
          cppToString(CppGet<Object*>(cppThis, String::cppNew("value")))),
      cppToString(String::cppNew(")")));
}

Object* MapEntry::cppNew() {
  static std::map<String*, void*> v_ptrs = {
      {String::cppNew("toString"),
       reinterpret_cast<void*>(&MapEntry::toString)}};
  static Type* runtimeType = new Type("MapEntry");
  Object* ptr = new ObjectImp(const_cast<Type*>(runtimeType), &v_ptrs);
  return ptr;
}

//  dart.core
Object* Set::cppEpt_() {
  return LinkedHashSet::cppEpt_(nullptr, nullptr, nullptr);
}

Object* Set::identity() {
  return LinkedHashSet::identity();
}

Object* Set::from(Object* elements) {
  return LinkedHashSet::from(elements);
}

Object* Set::of(Object* elements) {
  return LinkedHashSet::of(elements);
}

Object* Set::unmodifiable(Object* elements) {
  return UnmodifiableSetView::cppCtr_(UnmodifiableSetView::cppNew(), [&] {
    Object* cppLet_0 = LinkedHashSet::of(elements);
    return cppLet_0;
  }());
}

Object* Set::castFrom(Object* source, Function* newSet) {
  return CastSet::cppCtr_(CastSet::cppNew(), source, newSet);
}

Object* Set::cppNew() {
  static std::map<String*, void*> v_ptrs = {
      {String::cppNew("toString"),
       reinterpret_cast<void*>(&Iterable::toString)},
      {String::cppNew("cppGet_iterator"),
       reinterpret_cast<void*>(&Iterable::cppGet_iterator)},
      {String::cppNew("cast"), reinterpret_cast<void*>(&Iterable::cast)},
      {String::cppNew("followedBy"),
       reinterpret_cast<void*>(&Iterable::followedBy)},
      {String::cppNew("map"), reinterpret_cast<void*>(&Iterable::map)},
      {String::cppNew("where"), reinterpret_cast<void*>(&Iterable::where)},
      {String::cppNew("whereType"),
       reinterpret_cast<void*>(&Iterable::whereType)},
      {String::cppNew("expand"), reinterpret_cast<void*>(&Iterable::expand)},
      {String::cppNew("contains"),
       reinterpret_cast<void*>(&Iterable::contains)},
      {String::cppNew("forEach"), reinterpret_cast<void*>(&Iterable::forEach)},
      {String::cppNew("reduce"), reinterpret_cast<void*>(&Iterable::reduce)},
      {String::cppNew("fold"), reinterpret_cast<void*>(&Iterable::fold)},
      {String::cppNew("every"), reinterpret_cast<void*>(&Iterable::every)},
      {String::cppNew("join"), reinterpret_cast<void*>(&Iterable::join)},
      {String::cppNew("any"), reinterpret_cast<void*>(&Iterable::any)},
      {String::cppNew("toList"), reinterpret_cast<void*>(&Iterable::toList)},
      {String::cppNew("toSet"), reinterpret_cast<void*>(&Iterable::toSet)},
      {String::cppNew("cppGet_length"),
       reinterpret_cast<void*>(&Iterable::cppGet_length)},
      {String::cppNew("cppGet_isEmpty"),
       reinterpret_cast<void*>(&Iterable::cppGet_isEmpty)},
      {String::cppNew("cppGet_isNotEmpty"),
       reinterpret_cast<void*>(&Iterable::cppGet_isNotEmpty)},
      {String::cppNew("take"), reinterpret_cast<void*>(&Iterable::take)},
      {String::cppNew("takeWhile"),
       reinterpret_cast<void*>(&Iterable::takeWhile)},
      {String::cppNew("skip"), reinterpret_cast<void*>(&Iterable::skip)},
      {String::cppNew("skipWhile"),
       reinterpret_cast<void*>(&Iterable::skipWhile)},
      {String::cppNew("cppGet_first"),
       reinterpret_cast<void*>(&Iterable::cppGet_first)},
      {String::cppNew("cppGet_last"),
       reinterpret_cast<void*>(&Iterable::cppGet_last)},
      {String::cppNew("cppGet_single"),
       reinterpret_cast<void*>(&Iterable::cppGet_single)},
      {String::cppNew("firstWhere"),
       reinterpret_cast<void*>(&Iterable::firstWhere)},
      {String::cppNew("lastWhere"),
       reinterpret_cast<void*>(&Iterable::lastWhere)},
      {String::cppNew("singleWhere"),
       reinterpret_cast<void*>(&Iterable::singleWhere)},
      {String::cppNew("elementAt"),
       reinterpret_cast<void*>(&Iterable::elementAt)}};
  static Type* runtimeType = new Type("Set");
  Object* ptr = new ObjectImp(const_cast<Type*>(runtimeType), &v_ptrs);
  return ptr;
}

//  dart.core
Object* StackTrace::cppCtr_(Object* cppThis) {
  return cppThis;
}

Object* StackTrace::fromString(String* stackTraceString) {
  return _StringStackTrace::cppCtr_(_StringStackTrace::cppNew(),
                                    stackTraceString);
}

Object* StackTrace::cppGet_current() {}

Object* StackTrace::cppNew() {
  static std::map<String*, void*> v_ptrs = {
      {String::cppNew("toString"), reinterpret_cast<void*>(&Object::toString)}};
  static Type* runtimeType = new Type("StackTrace");
  Object* ptr = new ObjectImp(const_cast<Type*>(runtimeType), &v_ptrs);
  return ptr;
}

//  dart.core
Object* StringBuffer::cppCtr_(Object* cppThis, Object* content) {
  cppApply<void, Object*>(cppThis, String::cppNew("write"), content);
  return cppThis;
}

void StringBuffer::_writeString(Object* cppThis, String* str) {
  cppApply<void>(cppThis, String::cppNew("_consumeBuffer"));
  cppApply<void, String*>(cppThis, String::cppNew("_addPart"), str);
}

void StringBuffer::_ensureCapacity(Object* cppThis, Int* n) {
  Object* localBuffer = CppGet<Object*>(cppThis, String::cppNew("_buffer"));
  if (CppApi::cppBoolValue(Bool::cppNew(localBuffer == nullptr))) {
    CppSet<StringBuffer*>(cppThis, String::cppNew("_buffer"),
                          Uint16List::cppEpt_(Int::cppNew(64)));
  } else if (CppApi::cppBoolValue(Num::cpp_greaterThan(
                 Num::cpp_add(
                     CppGet<Int*>(cppThis, String::cppNew("_bufferPosition")),
                     n),
                 cppApply<Int*>(localBuffer,
                                String::cppNew("cppGet_length"))))) {
    cppApply<void>(cppThis, String::cppNew("_consumeBuffer"));
  }
}

void StringBuffer::_consumeBuffer(Object* cppThis) {
  if (CppApi::cppBoolValue(Object::cpp_equals(
          CppGet<Int*>(cppThis, String::cppNew("_bufferPosition")),
          Int::cppNew(0))))
    return;
  Bool* isLatin1 = Num::cpp_lessThanOrEqual(
      CppGet<Int*>(cppThis, String::cppNew("_bufferCodeUnitMagnitude")),
      Int::cppNew(255));
  String* str = StringBuffer::_create(
      CppGet<Object*>(cppThis, String::cppNew("_buffer")),
      CppGet<Int*>(cppThis, String::cppNew("_bufferPosition")), isLatin1);
  CppSet<StringBuffer*>(
      cppThis, String::cppNew("_bufferPosition"),
      CppSet<StringBuffer*>(cppThis, String::cppNew("_bufferCodeUnitMagnitude"),
                            Int::cppNew(0)));
  cppApply<void, String*>(cppThis, String::cppNew("_addPart"), str);
}

void StringBuffer::_addPart(Object* cppThis, String* str) {
  Object* localParts = CppGet<Object*>(cppThis, String::cppNew("_parts"));
  Int* length = cppApply<Int*>(str, String::cppNew("cppGet_length"));
  CppSet<StringBuffer*>(
      cppThis, String::cppNew("_partsCodeUnits"),
      Num::cpp_add(CppGet<Int*>(cppThis, String::cppNew("_partsCodeUnits")),
                   length));
  CppSet<StringBuffer*>(
      cppThis, String::cppNew("_partsCodeUnitsSinceCompaction"),
      Num::cpp_add(CppGet<Int*>(cppThis, String::cppNew(
                                             "_partsCodeUnitsSinceCompaction")),
                   length));
  if (CppApi::cppBoolValue(Bool::cppNew(localParts == nullptr))) {
    CppSet<StringBuffer*>(cppThis, String::cppNew("_parts"), ([&]() {
                            Object* cppLet_0 = CppNewList(Int::cppNew(10));
                            cppApply<void, String*>(cppLet_0,
                                                    String::cppNew("add"), str);
                            return cppLet_0;
                          })());
  } else {
    cppApply<void, String*>(localParts, String::cppNew("add"), str);
    Int* partsSinceCompaction = Num::cpp_subtract(
        cppApply<Int*>(localParts, String::cppNew("cppGet_length")),
        CppGet<Int*>(cppThis, String::cppNew("_partsCompactionIndex")));
    if (CppApi::cppBoolValue(
            Object::cpp_equals(partsSinceCompaction, Int::cppNew(128)))) {
      cppApply<void>(cppThis, String::cppNew("_compact"));
    }
  }
}

void StringBuffer::_compact(Object* cppThis) {
  Object* localParts = CppGet<Object*>(cppThis, String::cppNew("_parts"));
  if (CppApi::cppBoolValue(Num::cpp_lessThan(
          CppGet<Int*>(cppThis,
                       String::cppNew("_partsCodeUnitsSinceCompaction")),
          Int::cppNew(1024)))) {
    String* compacted = _StringBase::_concatRange(
        localParts,
        CppGet<Int*>(cppThis, String::cppNew("_partsCompactionIndex")),
        Num::cpp_add(
            CppGet<Int*>(cppThis, String::cppNew("_partsCompactionIndex")),
            Int::cppNew(128)));
    cppApply<void, Int*>(
        localParts, String::cppNew("cppSet_length"),
        Num::cpp_subtract(
            cppApply<Int*>(localParts, String::cppNew("cppGet_length")),
            Int::cppNew(128)));
    cppApply<void, String*>(localParts, String::cppNew("add"), compacted);
  }
  CppSet<StringBuffer*>(cppThis,
                        String::cppNew("_partsCodeUnitsSinceCompaction"),
                        Int::cppNew(0));
  CppSet<StringBuffer*>(
      cppThis, String::cppNew("_partsCompactionIndex"),
      cppApply<Int*>(localParts, String::cppNew("cppGet_length")));
}

String* StringBuffer::_create(Object* buffer, Int* length, Bool* isLatin1) {}

Int* StringBuffer::cppGet_length(Object* cppThis) {
  return Num::cpp_add(CppGet<Int*>(cppThis, String::cppNew("_partsCodeUnits")),
                      CppGet<Int*>(cppThis, String::cppNew("_bufferPosition")));
}

Bool* StringBuffer::cppGet_isEmpty(Object* cppThis) {
  return Object::cpp_equals(
      cppApply<Int*>(cppThis, String::cppNew("cppGet_length")), Int::cppNew(0));
}

Bool* StringBuffer::cppGet_isNotEmpty(Object* cppThis) {
  return Bool::cpp_not(
      cppApply<Bool*>(cppThis, String::cppNew("cppGet_isEmpty")));
}

void StringBuffer::write(Object* cppThis, Object* obj) {
  String* str = cppApply<String*>(obj, String::cppNew("toString"));
  if (CppApi::cppBoolValue(
          cppApply<Bool*>(str, String::cppNew("cppGet_isEmpty"))))
    return;
  cppApply<void, String*>(cppThis, String::cppNew("_writeString"), str);
}

void StringBuffer::writeCharCode(Object* cppThis, Int* charCode) {
  if (CppApi::cppBoolValue(
          Num::cpp_lessThanOrEqual(charCode, Int::cppNew(65535)))) {
    if (CppApi::cppBoolValue(Num::cpp_lessThan(charCode, Int::cppNew(0)))) {
      throw "ConstructorInvocation(new RangeError.range(charCode, 0, 1114111))";
    }
    cppApply<void, Int*>(cppThis, String::cppNew("_ensureCapacity"),
                         Int::cppNew(1));
    Object* localBuffer = CppGet<Object*>(cppThis, String::cppNew("_buffer"));
    cppApply<void, Int*, Int*>(
        localBuffer, String::cppNew("cpp_subscriptAssign"), ([&]() {
          Int* cppLet_0 =
              CppGet<Int*>(cppThis, String::cppNew("_bufferPosition"));
          return ([&]() {
            Int* cppLet_0 = CppSet<StringBuffer*>(
                cppThis, String::cppNew("_bufferPosition"),
                Num::cpp_add(cppLet_0, Int::cppNew(1)));
            return cppLet_0;
          })();
        })(),
        charCode);
    CppSet<StringBuffer*>(
        cppThis, String::cppNew("_bufferCodeUnitMagnitude"),
        Int::cpp_bitwiseOr(
            CppGet<Int*>(cppThis, String::cppNew("_bufferCodeUnitMagnitude")),
            charCode));
  } else {
    if (CppApi::cppBoolValue(
            Num::cpp_greaterThan(charCode, Int::cppNew(1114111)))) {
      throw "ConstructorInvocation(new RangeError.range(charCode, 0, 1114111))";
    }
    cppApply<void, Int*>(cppThis, String::cppNew("_ensureCapacity"),
                         Int::cppNew(2));
    Int* bits = Num::cpp_subtract(charCode, Int::cppNew(65536));
    Object* localBuffer = CppGet<Object*>(cppThis, String::cppNew("_buffer"));
    cppApply<void, Int*, Int*>(
        localBuffer, String::cppNew("cpp_subscriptAssign"), ([&]() {
          Int* cppLet_0 =
              CppGet<Int*>(cppThis, String::cppNew("_bufferPosition"));
          return ([&]() {
            Int* cppLet_0 = CppSet<StringBuffer*>(
                cppThis, String::cppNew("_bufferPosition"),
                Num::cpp_add(cppLet_0, Int::cppNew(1)));
            return cppLet_0;
          })();
        })(),
        Int::cpp_bitwiseOr(Int::cppNew(55296),
                           Int::cpp_rightShift(bits, Int::cppNew(10))));
    cppApply<void, Int*, Int*>(
        localBuffer, String::cppNew("cpp_subscriptAssign"), ([&]() {
          Int* cppLet_0 =
              CppGet<Int*>(cppThis, String::cppNew("_bufferPosition"));
          return ([&]() {
            Int* cppLet_0 = CppSet<StringBuffer*>(
                cppThis, String::cppNew("_bufferPosition"),
                Num::cpp_add(cppLet_0, Int::cppNew(1)));
            return cppLet_0;
          })();
        })(),
        Int::cpp_bitwiseOr(Int::cppNew(56320),
                           Int::cpp_bitwiseAnd(bits, Int::cppNew(1023))));
    CppSet<StringBuffer*>(
        cppThis, String::cppNew("_bufferCodeUnitMagnitude"),
        Int::cpp_bitwiseOr(
            CppGet<Int*>(cppThis, String::cppNew("_bufferCodeUnitMagnitude")),
            Int::cppNew(65535)));
  }
}

void StringBuffer::writeAll(Object* cppThis,
                            Object* objects,
                            String* separator) {
  Object* iterator =
      cppApply<Object*>(objects, String::cppNew("cppGet_iterator"));
  if (CppApi::cppBoolValue(
          Bool::cpp_not(cppApply<Bool*>(iterator, String::cppNew("moveNext")))))
    return;
  if (CppApi::cppBoolValue(
          cppApply<Bool*>(separator, String::cppNew("cppGet_isEmpty")))) {
    do {
      cppApply<void, Object*>(
          cppThis, String::cppNew("write"),
          cppApply<void**>(iterator, String::cppNew("cppGet_current")));
    } while (CppApi::cppBoolValue(
        cppApply<Bool*>(iterator, String::cppNew("moveNext"))));
  } else {
    cppApply<void, Object*>(
        cppThis, String::cppNew("write"),
        cppApply<void**>(iterator, String::cppNew("cppGet_current")));
    while (CppApi::cppBoolValue(
        cppApply<Bool*>(iterator, String::cppNew("moveNext")))) {
      cppApply<void, Object*>(cppThis, String::cppNew("write"), separator);
      cppApply<void, Object*>(
          cppThis, String::cppNew("write"),
          cppApply<void**>(iterator, String::cppNew("cppGet_current")));
    }
  }
}

void StringBuffer::writeln(Object* cppThis, Object* obj) {
  cppApply<void, Object*>(cppThis, String::cppNew("write"), obj);
  cppApply<void,String *>(cppThis, String::cppNew("_writeString"), String::cppNew("
"));
}

void StringBuffer::clear(Object* cppThis) {
  CppSet<StringBuffer*>(cppThis, String::cppNew("_parts"), nullptr);
  CppSet<StringBuffer*>(
      cppThis, String::cppNew("_partsCodeUnits"),
      CppSet<StringBuffer*>(
          cppThis, String::cppNew("_bufferPosition"),
          CppSet<StringBuffer*>(cppThis,
                                String::cppNew("_bufferCodeUnitMagnitude"),
                                Int::cppNew(0))));
}

String* StringBuffer::toString(Object* cppThis) {
  cppApply<void>(cppThis, String::cppNew("_consumeBuffer"));
  Object* localParts = CppGet<Object*>(cppThis, String::cppNew("_parts"));
  return CppApi::cppBoolValue(
             CppApi::cppBoolValue(Object::cpp_equals(
                 CppGet<Int*>(cppThis, String::cppNew("_partsCodeUnits")),
                 Int::cppNew(0))) ||
             CppApi::cppBoolValue(Bool::cppNew(localParts == nullptr)))
             ? String::cppNew("")
             : _StringBase::_concatRange(
                   localParts, Int::cppNew(0),
                   cppApply<Int*>(localParts, String::cppNew("cppGet_length")));
}

Object* StringBuffer::cppNew() {
  static std::map<String*, void*> v_ptrs = {
      {String::cppNew("toString"),
       reinterpret_cast<void*>(&StringBuffer::toString)},
      {String::cppNew("_writeString"),
       reinterpret_cast<void*>(&StringBuffer::_writeString)},
      {String::cppNew("_ensureCapacity"),
       reinterpret_cast<void*>(&StringBuffer::_ensureCapacity)},
      {String::cppNew("_consumeBuffer"),
       reinterpret_cast<void*>(&StringBuffer::_consumeBuffer)},
      {String::cppNew("_addPart"),
       reinterpret_cast<void*>(&StringBuffer::_addPart)},
      {String::cppNew("_compact"),
       reinterpret_cast<void*>(&StringBuffer::_compact)},
      {String::cppNew("cppGet_length"),
       reinterpret_cast<void*>(&StringBuffer::cppGet_length)},
      {String::cppNew("cppGet_isEmpty"),
       reinterpret_cast<void*>(&StringBuffer::cppGet_isEmpty)},
      {String::cppNew("cppGet_isNotEmpty"),
       reinterpret_cast<void*>(&StringBuffer::cppGet_isNotEmpty)},
      {String::cppNew("write"), reinterpret_cast<void*>(&StringSink::write)},
      {String::cppNew("writeCharCode"),
       reinterpret_cast<void*>(&StringSink::writeCharCode)},
      {String::cppNew("writeAll"),
       reinterpret_cast<void*>(&StringSink::writeAll)},
      {String::cppNew("writeln"),
       reinterpret_cast<void*>(&StringSink::writeln)},
      {String::cppNew("clear"), reinterpret_cast<void*>(&StringBuffer::clear)}};
  static Type* runtimeType = new Type("StringBuffer");
  Object* ptr = new ObjectImp(const_cast<Type*>(runtimeType), &v_ptrs);
  return ptr;
}
