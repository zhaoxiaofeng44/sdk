#include "./output.h"
//  library package:dart2bytecode/demo/collection.dart
Object* CppList::cppCtr_fromCppArray(Object* cppThis, CppUserData* array) {
  CppObjectSet<Int*>(cppThis, String::cppNew("_length"),
                     CppApi::cppGetPointerArrayLength(array));
  CppObjectSet<CppUserData*>(cppThis, String::cppNew("_array"), array);

  return cppThis;
}

Object* CppList::cppCtr_(Object* cppThis, Int* length, Int* capacity) {
  CppObjectSet<Int*>(cppThis, String::cppNew("_length"), length);
  CppObjectSet<CppUserData*>(cppThis, String::cppNew("_array"),
                             CppApi::cppCreatePointerArray(length));

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
  CppUserData* array = CppApi::cppCreatePointerArray(length);
  {
    Int* i = Int::cppNew(0);
    while (CppApi::cppBoolValue(Num::cpp_lessThan(i, length))) {
      { CppApi::cppSetPointerArrayItem(array, i, fill); }
      i = Num::cpp_add(i, Int::cppNew(1));
    }
  }
  return CppList::cppCtr_fromCppArray(CppList::cppNew(), array);
}

Object* CppList::from(Object* elements, Bool* growable) {
  Int* length = cppApply<Int*>(elements, String::cppNew("cppGet_length"));
  CppUserData* array =
      CppApi::cppBoolValue(growable)
          ? CppApi::cppCreatePointerArray(length)
          : CppApi::cppCreatePointerArray(CppList::_getSuggestCapacity(length));
  Int* i = Int::cppNew(0);
  {
    Object* $sync_for_iterator =
        cppApply<Object*>(elements, String::cppNew("cppGet_iterator"));
    {
      while (CppApi::cppBoolValue(
          cppApply<Bool*>($sync_for_iterator, String::cppNew("moveNext")))) {
        {
          Object* element = cppApply<Object*>($sync_for_iterator,
                                              String::cppNew("cppGet_current"));
          {
            CppApi::cppSetPointerArrayItem(array, ([&]() {
                                             Int* cppLet_0 = i;
                                             return ([&]() {
                                               Int* cppLet_0 = i = Num::cpp_add(
                                                   cppLet_0, Int::cppNew(1));
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
  CppUserData* array =
      CppApi::cppBoolValue(growable)
          ? CppApi::cppCreatePointerArray(length)
          : CppApi::cppCreatePointerArray(CppList::_getSuggestCapacity(length));
  {
    Int* i = Int::cppNew(0);
    while (CppApi::cppBoolValue(Num::cpp_lessThan(i, length))) {
      {
        CppApi::cppSetPointerArrayItem(array, i,
                                       cppApply<Object*>(generator, i));
      }
      i = Num::cpp_add(i, Int::cppNew(1));
    }
  }
  return CppList::cppCtr_fromCppArray(CppList::cppNew(), array);
}

Object* CppList::unmodifiable(Object* elements) {
  Int* length = cppApply<Int*>(elements, String::cppNew("cppGet_length"));
  CppUserData* array = CppApi::cppCreatePointerArray(length);
  Int* i = Int::cppNew(0);
  {
    Object* $sync_for_iterator =
        cppApply<Object*>(elements, String::cppNew("cppGet_iterator"));
    {
      while (CppApi::cppBoolValue(
          cppApply<Bool*>($sync_for_iterator, String::cppNew("moveNext")))) {
        {
          Object* element = cppApply<Object*>($sync_for_iterator,
                                              String::cppNew("cppGet_current"));
          {
            CppApi::cppSetPointerArrayItem(array, ([&]() {
                                             Int* cppLet_0 = i;
                                             return ([&]() {
                                               Int* cppLet_0 = i = Num::cpp_add(
                                                   cppLet_0, Int::cppNew(1));
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
  return CppObjectGet<Int*>(cppThis, String::cppNew("_length"));
}

void CppList::ensureCapacity(Object* cppThis, Int* newLen) {
  if (CppApi::cppBoolValue(Num::cpp_greaterThan(
          newLen, CppApi::cppGetPointerArrayLength(CppObjectGet<CppUserData*>(
                      cppThis, String::cppNew("_array")))))) {
    CppUserData* newArray =
        CppApi::cppCreatePointerArray(CppList::_getSuggestCapacity(newLen));
    {
      Int* i = Int::cppNew(0);
      while (CppApi::cppBoolValue(Num::cpp_lessThan(
          i, CppApi::cppGetPointerArrayLength(CppObjectGet<CppUserData*>(
                 cppThis, String::cppNew("_array")))))) {
        {
          CppApi::cppSetPointerArrayItem(
              newArray, i,
              CppApi::cppGetPointerArrayItem(
                  CppObjectGet<CppUserData*>(cppThis, String::cppNew("_array")),
                  i));
        }
        i = Num::cpp_add(i, Int::cppNew(1));
      }
    }
    CppObjectSet<CppUserData*>(cppThis, String::cppNew("_array"), newArray);
  }
}

void CppList::cppSet_length(Object* cppThis, Int* newLen) {
  cppApply<void, Int*>(cppThis, String::cppNew("ensureCapacity"), newLen);
  CppObjectSet<Int*>(cppThis, String::cppNew("_length"), newLen);
}

Object* CppList::cpp_subscript(Object* cppThis, Int* index) {
  return reinterpret_cast<Object*>(CppApi::cppGetPointerArrayItem(
      CppObjectGet<CppUserData*>(cppThis, String::cppNew("_array")), index));
}

void CppList::cpp_subscriptAssign(Object* cppThis, Int* index, Object* value) {
  return CppApi::cppSetPointerArrayItem(
      CppObjectGet<CppUserData*>(cppThis, String::cppNew("_array")), index,
      value);
}

void CppList::add(Object* cppThis, Object* value) {
  cppApply<void, Int*>(
      cppThis, String::cppNew("ensureCapacity"),
      Num::cpp_add(CppObjectGet<Int*>(cppThis, String::cppNew("_length")),
                   Int::cppNew(1)));
  CppApi::cppSetPointerArrayItem(
      CppObjectGet<CppUserData*>(cppThis, String::cppNew("_array")), ([&]() {
        Int* cppLet_0 = CppObjectGet<Int*>(cppThis, String::cppNew("_length"));
        return ([&]() {
          Int* cppLet_0 =
              CppObjectSet<Int*>(cppThis, String::cppNew("_length"),
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
        i, CppObjectGet<Int*>(cppThis, String::cppNew("_length"))))) {
      {
        if (CppApi::cppBoolValue(cppApply<Bool*>(
                test, reinterpret_cast<Object*>(CppApi::cppGetPointerArrayItem(
                          CppObjectGet<CppUserData*>(cppThis,
                                                     String::cppNew("_array")),
                          i)))))
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
        i, CppObjectGet<Int*>(cppThis, String::cppNew("_length"))))) {
      {
        cppApply<void, Int*, Object*>(
            map, String::cppNew("cpp_subscriptAssign"), i,
            reinterpret_cast<Object*>(CppApi::cppGetPointerArrayItem(
                CppObjectGet<CppUserData*>(cppThis, String::cppNew("_array")),
                i)));
      }
      i = Num::cpp_add(i, Int::cppNew(1));
    }
  }
  return map;
}

Object* CppList::cast(Object* cppThis) {
  return CppList::castFrom(cppThis);
}

Object* CppList::castFrom(Object* source) {
  Object* result =
      CppList::cppCtr_(CppList::cppNew(), Int::cppNew(0), Int::cppNew(4));
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
            cppApply<void, Object*>(result, String::cppNew("add"),
                                    reinterpret_cast<Object*>(element));
          }
        }
      }
    }
  }
  return result;
}

Object* CppList::castFromWithFactory(Object* source, Function* newList) {
  Object* result = cppApply<Object*>(newList);
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
            cppApply<void, Object*>(result, String::cppNew("add"),
                                    reinterpret_cast<Object*>(element));
          }
        }
      }
    }
  }
  return result;
}

void CppList::clear(Object* cppThis) {
  CppObjectSet<Object*>(cppThis, String::cppNew("_length"), Int::cppNew(0));
}

Bool* CppList::contains(Object* cppThis, Object* element) {
  {
    Int* i = Int::cppNew(0);
    while (CppApi::cppBoolValue(Num::cpp_lessThan(
        i, CppObjectGet<Int*>(cppThis, String::cppNew("_length"))))) {
      {
        if (CppApi::cppBoolValue(
                Object::cpp_equals(CppApi::cppGetPointerArrayItem(
                                       CppObjectGet<CppUserData*>(
                                           cppThis, String::cppNew("_array")),
                                       i),
                                   element)))
          return Bool::cppNew(true);
      }
      i = Num::cpp_add(i, Int::cppNew(1));
    }
  }
  return Bool::cppNew(false);
}

Object* CppList::elementAt(Object* cppThis, Int* index) {
  return reinterpret_cast<Object*>(CppApi::cppGetPointerArrayItem(
      CppObjectGet<CppUserData*>(cppThis, String::cppNew("_array")), index));
}

Bool* CppList::every(Object* cppThis, Function* test) {
  {
    Int* i = Int::cppNew(0);
    while (CppApi::cppBoolValue(Num::cpp_lessThan(
        i, CppObjectGet<Int*>(cppThis, String::cppNew("_length"))))) {
      {
        if (CppApi::cppBoolValue(Bool::cpp_not(cppApply<Bool*>(
                test, reinterpret_cast<Object*>(CppApi::cppGetPointerArrayItem(
                          CppObjectGet<CppUserData*>(cppThis,
                                                     String::cppNew("_array")),
                          i))))))
          return Bool::cppNew(false);
      }
      i = Num::cpp_add(i, Int::cppNew(1));
    }
  }
  return Bool::cppNew(true);
}

void CppList::fillRange(Object* cppThis,
                        Int* start,
                        Int* end,
                        Object* fillValue) {
  {
    Int* i = start;
    while (CppApi::cppBoolValue(Num::cpp_lessThan(i, end))) {
      {
        CppApi::cppSetPointerArrayItem(
            CppObjectGet<CppUserData*>(cppThis, String::cppNew("_array")), i,
            ([&]() {
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
        i, CppObjectGet<Int*>(cppThis, String::cppNew("_length"))))) {
      {
        if (CppApi::cppBoolValue(cppApply<Bool*>(
                test, reinterpret_cast<Object*>(CppApi::cppGetPointerArrayItem(
                          CppObjectGet<CppUserData*>(cppThis,
                                                     String::cppNew("_array")),
                          i))))) {
          return reinterpret_cast<Object*>(CppApi::cppGetPointerArrayItem(
              CppObjectGet<CppUserData*>(cppThis, String::cppNew("_array")),
              i));
        }
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
        i, CppObjectGet<Int*>(cppThis, String::cppNew("_length"))))) {
      {
        value = cppApply<Object*>(
            combine, value,
            reinterpret_cast<Object*>(CppApi::cppGetPointerArrayItem(
                CppObjectGet<CppUserData*>(cppThis, String::cppNew("_array")),
                i)));
      }
      i = Num::cpp_add(i, Int::cppNew(1));
    }
  }
  return value;
}

void CppList::forEach(Object* cppThis, Function* action) {
  {
    Int* i = Int::cppNew(0);
    while (CppApi::cppBoolValue(Num::cpp_lessThan(
        i, CppObjectGet<Int*>(cppThis, String::cppNew("_length"))))) {
      {
        cppApply<void>(
            action,
            reinterpret_cast<Object*>(CppApi::cppGetPointerArrayItem(
                CppObjectGet<CppUserData*>(cppThis, String::cppNew("_array")),
                i)));
      }
      i = Num::cpp_add(i, Int::cppNew(1));
    }
  }
}

Object* CppList::getRange(Object* cppThis, Int* start, Int* end) {
  return CppList::from(
      CppIterable::generate(
          Num::cpp_subtract(end, start),
          new LambdaWrapper<Object*, Int*>([&](Int* i) -> Object* {
            return CppApi::cppGetPointerArrayItem(
                CppObjectGet<CppUserData*>(cppThis, String::cppNew("_array")),
                Num::cpp_add(start, i));
          })),
      Bool::cppNew(true));
}

Int* CppList::indexOf(Object* cppThis, Object* element, Int* start) {
  {
    Int* i = start;
    while (CppApi::cppBoolValue(Num::cpp_lessThan(
        i, CppObjectGet<Int*>(cppThis, String::cppNew("_length"))))) {
      {
        if (CppApi::cppBoolValue(
                Object::cpp_equals(CppApi::cppGetPointerArrayItem(
                                       CppObjectGet<CppUserData*>(
                                           cppThis, String::cppNew("_array")),
                                       i),
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
        i, CppObjectGet<Int*>(cppThis, String::cppNew("_length"))))) {
      {
        if (CppApi::cppBoolValue(cppApply<Bool*>(
                test, reinterpret_cast<Object*>(CppApi::cppGetPointerArrayItem(
                          CppObjectGet<CppUserData*>(cppThis,
                                                     String::cppNew("_array")),
                          i)))))
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
              index, CppObjectGet<Int*>(cppThis, String::cppNew("_length"))))))
    throw "ConstructorInvocation(new IndexError(index, this))";
  cppApply<void, Int*>(
      cppThis, String::cppNew("ensureCapacity"),
      Num::cpp_add(CppObjectGet<Int*>(cppThis, String::cppNew("_length")),
                   Int::cppNew(1)));
  {
    Int* i = CppObjectGet<Int*>(cppThis, String::cppNew("_length"));
    while (CppApi::cppBoolValue(Num::cpp_greaterThan(i, index))) {
      {
        CppApi::cppSetPointerArrayItem(
            CppObjectGet<CppUserData*>(cppThis, String::cppNew("_array")), i,
            CppApi::cppGetPointerArrayItem(
                CppObjectGet<CppUserData*>(cppThis, String::cppNew("_array")),
                Num::cpp_subtract(i, Int::cppNew(1))));
      }
      i = Num::cpp_subtract(i, Int::cppNew(1));
    }
  }
  CppApi::cppSetPointerArrayItem(
      CppObjectGet<CppUserData*>(cppThis, String::cppNew("_array")), index,
      element);
  CppObjectSet<Int*>(
      cppThis, String::cppNew("_length"),
      Num::cpp_add(CppObjectGet<Int*>(cppThis, String::cppNew("_length")),
                   Int::cppNew(1)));
}

void CppList::insertAll(Object* cppThis, Int* index, Object* iterable) {
  if (CppApi::cppBoolValue(
          CppApi::cppBoolValue(Num::cpp_lessThan(index, Int::cppNew(0))) ||
          CppApi::cppBoolValue(Num::cpp_greaterThan(
              index, CppObjectGet<Int*>(cppThis, String::cppNew("_length"))))))
    throw "ConstructorInvocation(new IndexError(index, this))";
  Object* elements =
      cppApply<Object*, Bool*>(iterable, String::cppNew("toList"), nullptr);
  Int* insertLength = cppApply<Int*>(elements, String::cppNew("cppGet_length"));
  if (CppApi::cppBoolValue(Object::cpp_equals(insertLength, Int::cppNew(0))))
    return;
  cppApply<void, Int*>(
      cppThis, String::cppNew("ensureCapacity"),
      Num::cpp_add(CppObjectGet<Int*>(cppThis, String::cppNew("_length")),
                   insertLength));
  {
    Int* i = Num::cpp_subtract(
        CppObjectGet<Int*>(cppThis, String::cppNew("_length")), Int::cppNew(1));
    while (CppApi::cppBoolValue(Num::cpp_greaterThanOrEqual(i, index))) {
      {
        CppApi::cppSetPointerArrayItem(
            CppObjectGet<CppUserData*>(cppThis, String::cppNew("_array")),
            Num::cpp_add(i, insertLength),
            CppApi::cppGetPointerArrayItem(
                CppObjectGet<CppUserData*>(cppThis, String::cppNew("_array")),
                i));
      }
      i = Num::cpp_subtract(i, Int::cppNew(1));
    }
  }
  {
    Int* i = Int::cppNew(0);
    while (CppApi::cppBoolValue(Num::cpp_lessThan(i, insertLength))) {
      {
        CppApi::cppSetPointerArrayItem(
            CppObjectGet<CppUserData*>(cppThis, String::cppNew("_array")),
            Num::cpp_add(index, i),
            cppApply<Object*, Int*>(elements, String::cppNew("cpp_subscript"),
                                    i));
      }
      i = Num::cpp_add(i, Int::cppNew(1));
    }
  }
  CppObjectSet<Int*>(
      cppThis, String::cppNew("_length"),
      Num::cpp_add(CppObjectGet<Int*>(cppThis, String::cppNew("_length")),
                   insertLength));
}

Object* CppList::cppGet_first(Object* cppThis) {
  if (CppApi::cppBoolValue(Object::cpp_equals(
          CppObjectGet<Int*>(cppThis, String::cppNew("_length")),
          Int::cppNew(0))))
    throw "ConstructorInvocation(new StateError(No element))";
  return reinterpret_cast<Object*>(CppApi::cppGetPointerArrayItem(
      CppObjectGet<CppUserData*>(cppThis, String::cppNew("_array")),
      Int::cppNew(0)));
}

void CppList::cppSet_first(Object* cppThis, Object* value) {
  if (CppApi::cppBoolValue(Object::cpp_equals(
          CppObjectGet<Int*>(cppThis, String::cppNew("_length")),
          Int::cppNew(0))))
    throw "ConstructorInvocation(new StateError(No element))";
  CppApi::cppSetPointerArrayItem(
      CppObjectGet<CppUserData*>(cppThis, String::cppNew("_array")),
      Int::cppNew(0), value);
}

Object* CppList::cppGet_last(Object* cppThis) {
  if (CppApi::cppBoolValue(Object::cpp_equals(
          CppObjectGet<Int*>(cppThis, String::cppNew("_length")),
          Int::cppNew(0))))
    throw "ConstructorInvocation(new StateError(No element))";
  return reinterpret_cast<Object*>(CppApi::cppGetPointerArrayItem(
      CppObjectGet<CppUserData*>(cppThis, String::cppNew("_array")),
      Num::cpp_subtract(CppObjectGet<Int*>(cppThis, String::cppNew("_length")),
                        Int::cppNew(1))));
}

void CppList::cppSet_last(Object* cppThis, Object* value) {
  if (CppApi::cppBoolValue(Object::cpp_equals(
          CppObjectGet<Int*>(cppThis, String::cppNew("_length")),
          Int::cppNew(0))))
    throw "ConstructorInvocation(new StateError(No element))";
  CppApi::cppSetPointerArrayItem(
      CppObjectGet<CppUserData*>(cppThis, String::cppNew("_array")),
      Num::cpp_subtract(CppObjectGet<Int*>(cppThis, String::cppNew("_length")),
                        Int::cppNew(1)),
      value);
}

Object* CppList::cppGet_single(Object* cppThis) {
  if (CppApi::cppBoolValue(Object::cpp_equals(
          CppObjectGet<Int*>(cppThis, String::cppNew("_length")),
          Int::cppNew(0))))
    throw "ConstructorInvocation(new StateError(No element))";
  if (CppApi::cppBoolValue(Num::cpp_greaterThan(
          CppObjectGet<Int*>(cppThis, String::cppNew("_length")),
          Int::cppNew(1))))
    throw "ConstructorInvocation(new StateError(Too many elements))";
  return reinterpret_cast<Object*>(CppApi::cppGetPointerArrayItem(
      CppObjectGet<CppUserData*>(cppThis, String::cppNew("_array")),
      Int::cppNew(0)));
}

Bool* CppList::cppGet_isEmpty(Object* cppThis) {
  return Object::cpp_equals(
      CppObjectGet<Int*>(cppThis, String::cppNew("_length")), Int::cppNew(0));
}

Bool* CppList::cppGet_isNotEmpty(Object* cppThis) {
  return Bool::cpp_not(Object::cpp_equals(
      CppObjectGet<Int*>(cppThis, String::cppNew("_length")), Int::cppNew(0)));
}

Object* CppList::cppGet_iterator(Object* cppThis) {
  return _CppListIterator::cppCtr_(_CppListIterator::cppNew(), cppThis);
}

String* CppList::join(Object* cppThis, String* separator) {
  if (CppApi::cppBoolValue(Object::cpp_equals(
          CppObjectGet<Int*>(cppThis, String::cppNew("_length")),
          Int::cppNew(0))))
    return String::cppNew(new uint8_t[1]{0});
  return CppApi::cppJoinListString(
      CppObjectGet<CppUserData*>(cppThis, String::cppNew("_array")), separator);
}

Int* CppList::lastIndexOf(Object* cppThis, Object* element, Int* start) {
  Int* startIndex = ([&]() {
    Int* cppLet_0 = start;
    return CppApi::cppBoolValue(Bool::cppNew(cppLet_0 == nullptr))
               ? Num::cpp_subtract(
                     CppObjectGet<Int*>(cppThis, String::cppNew("_length")),
                     Int::cppNew(1))
               : cppLet_0;
  })();
  {
    Int* i = startIndex;
    while (
        CppApi::cppBoolValue(Num::cpp_greaterThanOrEqual(i, Int::cppNew(0)))) {
      {
        if (CppApi::cppBoolValue(
                Object::cpp_equals(CppApi::cppGetPointerArrayItem(
                                       CppObjectGet<CppUserData*>(
                                           cppThis, String::cppNew("_array")),
                                       i),
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
                     CppObjectGet<Int*>(cppThis, String::cppNew("_length")),
                     Int::cppNew(1))
               : cppLet_0;
  })();
  {
    Int* i = startIndex;
    while (
        CppApi::cppBoolValue(Num::cpp_greaterThanOrEqual(i, Int::cppNew(0)))) {
      {
        if (CppApi::cppBoolValue(cppApply<Bool*>(
                test, reinterpret_cast<Object*>(CppApi::cppGetPointerArrayItem(
                          CppObjectGet<CppUserData*>(cppThis,
                                                     String::cppNew("_array")),
                          i)))))
          return i;
      }
      i = Num::cpp_subtract(i, Int::cppNew(1));
    }
  }
  return Int::cpp_negation(Int::cppNew(1));
}

Object* CppList::lastWhere(Object* cppThis, Function* test, Function* orElse) {
  {
    Int* i = Num::cpp_subtract(
        CppObjectGet<Int*>(cppThis, String::cppNew("_length")), Int::cppNew(1));
    while (
        CppApi::cppBoolValue(Num::cpp_greaterThanOrEqual(i, Int::cppNew(0)))) {
      {
        if (CppApi::cppBoolValue(cppApply<Bool*>(
                test, reinterpret_cast<Object*>(CppApi::cppGetPointerArrayItem(
                          CppObjectGet<CppUserData*>(cppThis,
                                                     String::cppNew("_array")),
                          i))))) {
          return reinterpret_cast<Object*>(CppApi::cppGetPointerArrayItem(
              CppObjectGet<CppUserData*>(cppThis, String::cppNew("_array")),
              i));
        }
      }
      i = Num::cpp_subtract(i, Int::cppNew(1));
    }
  }
  if (CppApi::cppBoolValue(Bool::cpp_not(Bool::cppNew(orElse == nullptr))))
    return cppApply<Object*>(orElse);
  throw "ConstructorInvocation(new StateError(No element))";
}

Object* CppList::reduce(Object* cppThis, Function* combine) {
  if (CppApi::cppBoolValue(Object::cpp_equals(
          CppObjectGet<Int*>(cppThis, String::cppNew("_length")),
          Int::cppNew(0))))
    throw "ConstructorInvocation(new StateError(No element))";
  Object* value = reinterpret_cast<Object*>(CppApi::cppGetPointerArrayItem(
      CppObjectGet<CppUserData*>(cppThis, String::cppNew("_array")),
      Int::cppNew(0)));
  {
    Int* i = Int::cppNew(1);
    while (CppApi::cppBoolValue(Num::cpp_lessThan(
        i, CppObjectGet<Int*>(cppThis, String::cppNew("_length"))))) {
      {
        value = cppApply<Object*>(
            combine, value,
            reinterpret_cast<Object*>(CppApi::cppGetPointerArrayItem(
                CppObjectGet<CppUserData*>(cppThis, String::cppNew("_array")),
                i)));
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
              index, CppObjectGet<Int*>(cppThis, String::cppNew("_length"))))))
    throw "ConstructorInvocation(new IndexError(index, this))";
  Object* element = CppApi::cppGetPointerArrayItem(
      CppObjectGet<CppUserData*>(cppThis, String::cppNew("_array")), index);
  {
    Int* i = index;
    while (CppApi::cppBoolValue(Num::cpp_lessThan(
        i, Num::cpp_subtract(
               CppObjectGet<Int*>(cppThis, String::cppNew("_length")),
               Int::cppNew(1))))) {
      {
        CppApi::cppSetPointerArrayItem(
            CppObjectGet<CppUserData*>(cppThis, String::cppNew("_array")), i,
            CppApi::cppGetPointerArrayItem(
                CppObjectGet<CppUserData*>(cppThis, String::cppNew("_array")),
                Num::cpp_add(i, Int::cppNew(1))));
      }
      i = Num::cpp_add(i, Int::cppNew(1));
    }
  }
  CppObjectSet<Int*>(
      cppThis, String::cppNew("_length"),
      Num::cpp_subtract(CppObjectGet<Int*>(cppThis, String::cppNew("_length")),
                        Int::cppNew(1)));
  return reinterpret_cast<Object*>(element);
}

Object* CppList::removeLast(Object* cppThis) {
  if (CppApi::cppBoolValue(Object::cpp_equals(
          CppObjectGet<Int*>(cppThis, String::cppNew("_length")),
          Int::cppNew(0))))
    throw "ConstructorInvocation(new StateError(No element))";
  return cppApply<Object*, Int*>(
      cppThis, String::cppNew("removeAt"),
      Num::cpp_subtract(CppObjectGet<Int*>(cppThis, String::cppNew("_length")),
                        Int::cppNew(1)));
}

void CppList::removeRange(Object* cppThis, Int* start, Int* end) {
  if (CppApi::cppBoolValue(
          CppApi::cppBoolValue(
              CppApi::cppBoolValue(
                  CppApi::cppBoolValue(
                      Num::cpp_lessThan(start, Int::cppNew(0))) ||
                  CppApi::cppBoolValue(Num::cpp_greaterThan(
                      start, CppObjectGet<Int*>(cppThis,
                                                String::cppNew("_length"))))) ||
              CppApi::cppBoolValue(Num::cpp_lessThan(end, start))) ||
          CppApi::cppBoolValue(Num::cpp_greaterThan(
              end, CppObjectGet<Int*>(cppThis, String::cppNew("_length")))))) {
    throw "ConstructorInvocation(new RangeError.range(start, 0, this.{CppList._length}))";
  }
  Int* length = Num::cpp_subtract(end, start);
  {
    Int* i = start;
    while (CppApi::cppBoolValue(Num::cpp_lessThan(
        i,
        Num::cpp_subtract(
            CppObjectGet<Int*>(cppThis, String::cppNew("_length")), length)))) {
      {
        CppApi::cppSetPointerArrayItem(
            CppObjectGet<CppUserData*>(cppThis, String::cppNew("_array")), i,
            CppApi::cppGetPointerArrayItem(
                CppObjectGet<CppUserData*>(cppThis, String::cppNew("_array")),
                Num::cpp_add(i, length)));
      }
      i = Num::cpp_add(i, Int::cppNew(1));
    }
  }
  CppObjectSet<Int*>(
      cppThis, String::cppNew("_length"),
      Num::cpp_subtract(CppObjectGet<Int*>(cppThis, String::cppNew("_length")),
                        length));
}

void CppList::removeWhere(Object* cppThis, Function* test) {
  Int* writeIndex = Int::cppNew(0);
  {
    Int* readIndex = Int::cppNew(0);
    while (CppApi::cppBoolValue(Num::cpp_lessThan(
        readIndex, CppObjectGet<Int*>(cppThis, String::cppNew("_length"))))) {
      {
        if (CppApi::cppBoolValue(Bool::cpp_not(cppApply<Bool*>(
                test, reinterpret_cast<Object*>(CppApi::cppGetPointerArrayItem(
                          CppObjectGet<CppUserData*>(cppThis,
                                                     String::cppNew("_array")),
                          readIndex)))))) {
          if (CppApi::cppBoolValue(
                  Bool::cpp_not(Object::cpp_equals(writeIndex, readIndex)))) {
            CppApi::cppSetPointerArrayItem(
                CppObjectGet<CppUserData*>(cppThis, String::cppNew("_array")),
                writeIndex,
                CppApi::cppGetPointerArrayItem(
                    CppObjectGet<CppUserData*>(cppThis,
                                               String::cppNew("_array")),
                    readIndex));
          }
          writeIndex = Num::cpp_add(writeIndex, Int::cppNew(1));
        }
      }
      readIndex = Num::cpp_add(readIndex, Int::cppNew(1));
    }
  }
  CppObjectSet<Int*>(cppThis, String::cppNew("_length"), writeIndex);
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
                      start, CppObjectGet<Int*>(cppThis,
                                                String::cppNew("_length"))))) ||
              CppApi::cppBoolValue(Num::cpp_lessThan(end, start))) ||
          CppApi::cppBoolValue(Num::cpp_greaterThan(
              end, CppObjectGet<Int*>(cppThis, String::cppNew("_length")))))) {
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
            Num::cpp_add(CppObjectGet<Int*>(cppThis, String::cppNew("_length")),
                         replacementLength),
            rangeLength));
  }
  if (CppApi::cppBoolValue(
          Bool::cpp_not(Object::cpp_equals(replacementLength, rangeLength)))) {
    {
      Int* i = Num::cpp_subtract(
          CppObjectGet<Int*>(cppThis, String::cppNew("_length")),
          Int::cppNew(1));
      while (CppApi::cppBoolValue(Num::cpp_greaterThanOrEqual(i, end))) {
        {
          CppApi::cppSetPointerArrayItem(
              CppObjectGet<CppUserData*>(cppThis, String::cppNew("_array")),
              Num::cpp_subtract(Num::cpp_add(i, replacementLength),
                                rangeLength),
              CppApi::cppGetPointerArrayItem(
                  CppObjectGet<CppUserData*>(cppThis, String::cppNew("_array")),
                  i));
        }
        i = Num::cpp_subtract(i, Int::cppNew(1));
      }
    }
  }
  {
    Int* i = Int::cppNew(0);
    while (CppApi::cppBoolValue(Num::cpp_lessThan(i, replacementLength))) {
      {
        CppApi::cppSetPointerArrayItem(
            CppObjectGet<CppUserData*>(cppThis, String::cppNew("_array")),
            Num::cpp_add(start, i),
            cppApply<Object*, Int*>(replacementList,
                                    String::cppNew("cpp_subscript"), i));
      }
      i = Num::cpp_add(i, Int::cppNew(1));
    }
  }
  CppObjectSet<Int*>(
      cppThis, String::cppNew("_length"),
      Num::cpp_add(CppObjectGet<Int*>(cppThis, String::cppNew("_length")),
                   Num::cpp_subtract(replacementLength, rangeLength)));
}

void CppList::retainWhere(Object* cppThis, Function* test) {
  Int* writeIndex = Int::cppNew(0);
  {
    Int* readIndex = Int::cppNew(0);
    while (CppApi::cppBoolValue(Num::cpp_lessThan(
        readIndex, CppObjectGet<Int*>(cppThis, String::cppNew("_length"))))) {
      {
        if (CppApi::cppBoolValue(cppApply<Bool*>(
                test, reinterpret_cast<Object*>(CppApi::cppGetPointerArrayItem(
                          CppObjectGet<CppUserData*>(cppThis,
                                                     String::cppNew("_array")),
                          readIndex))))) {
          if (CppApi::cppBoolValue(
                  Bool::cpp_not(Object::cpp_equals(writeIndex, readIndex)))) {
            CppApi::cppSetPointerArrayItem(
                CppObjectGet<CppUserData*>(cppThis, String::cppNew("_array")),
                writeIndex,
                CppApi::cppGetPointerArrayItem(
                    CppObjectGet<CppUserData*>(cppThis,
                                               String::cppNew("_array")),
                    readIndex));
          }
          writeIndex = Num::cpp_add(writeIndex, Int::cppNew(1));
        }
      }
      readIndex = Num::cpp_add(readIndex, Int::cppNew(1));
    }
  }
  CppObjectSet<Int*>(cppThis, String::cppNew("_length"), writeIndex);
}

void CppList::setAll(Object* cppThis, Int* index, Object* iterable) {
  if (CppApi::cppBoolValue(
          CppApi::cppBoolValue(Num::cpp_lessThan(index, Int::cppNew(0))) ||
          CppApi::cppBoolValue(Num::cpp_greaterThan(
              index, CppObjectGet<Int*>(cppThis, String::cppNew("_length"))))))
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
                    i,
                    CppObjectGet<Int*>(cppThis, String::cppNew("_length"))))) {
              cppApply<void, Object*>(cppThis, String::cppNew("add"), element);
            } else {
              CppApi::cppSetPointerArrayItem(
                  CppObjectGet<CppUserData*>(cppThis, String::cppNew("_array")),
                  i, element);
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
                      start, CppObjectGet<Int*>(cppThis,
                                                String::cppNew("_length"))))) ||
              CppApi::cppBoolValue(Num::cpp_lessThan(end, start))) ||
          CppApi::cppBoolValue(Num::cpp_greaterThan(
              end, CppObjectGet<Int*>(cppThis, String::cppNew("_length")))))) {
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
        CppApi::cppSetPointerArrayItem(
            CppObjectGet<CppUserData*>(cppThis, String::cppNew("_array")), i,
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
    Int* i = Num::cpp_subtract(
        CppObjectGet<Int*>(cppThis, String::cppNew("_length")), Int::cppNew(1));
    while (CppApi::cppBoolValue(Num::cpp_greaterThan(i, Int::cppNew(0)))) {
      {
        Int* j = cppApply<Int*, Int*>(random, String::cppNew("nextInt"),
                                      Num::cpp_add(i, Int::cppNew(1)));
        Object* temp = CppApi::cppGetPointerArrayItem(
            CppObjectGet<CppUserData*>(cppThis, String::cppNew("_array")), i);
        CppApi::cppSetPointerArrayItem(
            CppObjectGet<CppUserData*>(cppThis, String::cppNew("_array")), i,
            CppApi::cppGetPointerArrayItem(
                CppObjectGet<CppUserData*>(cppThis, String::cppNew("_array")),
                j));
        CppApi::cppSetPointerArrayItem(
            CppObjectGet<CppUserData*>(cppThis, String::cppNew("_array")), j,
            temp);
      }
      i = Num::cpp_subtract(i, Int::cppNew(1));
    }
  }
}

void CppList::sort(Object* cppThis, Function* compare) {
  if (CppApi::cppBoolValue(Num::cpp_lessThanOrEqual(
          CppObjectGet<Int*>(cppThis, String::cppNew("_length")),
          Int::cppNew(1))))
    return;
  cppApply<void, Int*, Int*, Function*>(
      cppThis, String::cppNew("_quickSort"), Int::cppNew(0),
      Num::cpp_subtract(CppObjectGet<Int*>(cppThis, String::cppNew("_length")),
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
  Object* pivot = reinterpret_cast<Object*>(CppApi::cppGetPointerArrayItem(
      CppObjectGet<CppUserData*>(cppThis, String::cppNew("_array")), high));
  Int* i = Num::cpp_subtract(low, Int::cppNew(1));
  {
    Int* j = low;
    while (CppApi::cppBoolValue(Num::cpp_lessThan(j, high))) {
      {
        Object* current =
            reinterpret_cast<Object*>(CppApi::cppGetPointerArrayItem(
                CppObjectGet<CppUserData*>(cppThis, String::cppNew("_array")),
                j));
        Bool* shouldSwap;
        if (CppApi::cppBoolValue(
                Bool::cpp_not(Bool::cppNew(compare == nullptr)))) {
          shouldSwap = Num::cpp_lessThanOrEqual(
              cppApply<Int*>(compare, current, pivot), Int::cppNew(0));
        } else {
          shouldSwap = Num::cpp_lessThanOrEqual(
              cppApply<Int*, Object*>(reinterpret_cast<Object*>(current),
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
  Object* temp = reinterpret_cast<Object*>(CppApi::cppGetPointerArrayItem(
      CppObjectGet<CppUserData*>(cppThis, String::cppNew("_array")), i));
  CppApi::cppSetPointerArrayItem(
      CppObjectGet<CppUserData*>(cppThis, String::cppNew("_array")), i,
      CppApi::cppGetPointerArrayItem(
          CppObjectGet<CppUserData*>(cppThis, String::cppNew("_array")), j));
  CppApi::cppSetPointerArrayItem(
      CppObjectGet<CppUserData*>(cppThis, String::cppNew("_array")), j, temp);
}

Object* CppList::sublist(Object* cppThis, Int* start, Int* end) {
  Int* endIndex = ([&]() {
    Int* cppLet_0 = end;
    return CppApi::cppBoolValue(Bool::cppNew(cppLet_0 == nullptr))
               ? CppObjectGet<Int*>(cppThis, String::cppNew("_length"))
               : cppLet_0;
  })();
  if (CppApi::cppBoolValue(
          CppApi::cppBoolValue(
              CppApi::cppBoolValue(
                  CppApi::cppBoolValue(
                      Num::cpp_lessThan(start, Int::cppNew(0))) ||
                  CppApi::cppBoolValue(Num::cpp_greaterThan(
                      start, CppObjectGet<Int*>(cppThis,
                                                String::cppNew("_length"))))) ||
              CppApi::cppBoolValue(Num::cpp_lessThan(endIndex, start))) ||
          CppApi::cppBoolValue(Num::cpp_greaterThan(
              endIndex,
              CppObjectGet<Int*>(cppThis, String::cppNew("_length")))))) {
    throw "ConstructorInvocation(new RangeError.range(start, 0, this.{CppList._length}))";
  }
  return CppList::from(
      CppIterable::generate(
          Num::cpp_subtract(endIndex, start),
          new LambdaWrapper<Object*, Int*>([&](Int* i) -> Object* {
            return CppApi::cppGetPointerArrayItem(
                CppObjectGet<CppUserData*>(cppThis, String::cppNew("_array")),
                Num::cpp_add(start, i));
          })),
      Bool::cppNew(true));
}

Object* CppList::toList(Object* cppThis, Bool* growable) {
  return CppList::from(cppThis, growable);
}

Object* CppList::toSet(Object* cppThis) {
  return CppSet::from(cppThis);
}

Object* CppList::singleWhere(Object* cppThis,
                             Function* test,
                             Function* orElse) {
  Object* result;
  Bool* found = Bool::cppNew(false);
  {
    Int* i = Int::cppNew(0);
    while (CppApi::cppBoolValue(Num::cpp_lessThan(
        i, CppObjectGet<Int*>(cppThis, String::cppNew("_length"))))) {
      {
        if (CppApi::cppBoolValue(cppApply<Bool*>(
                test, reinterpret_cast<Object*>(CppApi::cppGetPointerArrayItem(
                          CppObjectGet<CppUserData*>(cppThis,
                                                     String::cppNew("_array")),
                          i))))) {
          if (CppApi::cppBoolValue(found))
            throw "ConstructorInvocation(new StateError(Too many elements))";
          result = reinterpret_cast<Object*>(CppApi::cppGetPointerArrayItem(
              CppObjectGet<CppUserData*>(cppThis, String::cppNew("_array")),
              i));
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

Object* CppList::cpp_add(Object* cppThis, Object* other) {
  Object* result = CppList::cppCtr_(
      CppList::cppNew(), Int::cppNew(0),
      Num::cpp_add(CppObjectGet<Int*>(cppThis, String::cppNew("_length")),
                   cppApply<Int*>(other, String::cppNew("cppGet_length"))));
  {
    Int* i = Int::cppNew(0);
    while (CppApi::cppBoolValue(Num::cpp_lessThan(
        i, CppObjectGet<Int*>(cppThis, String::cppNew("_length"))))) {
      {
        cppApply<void, Object*>(
            result, String::cppNew("add"),
            reinterpret_cast<Object*>(CppApi::cppGetPointerArrayItem(
                CppObjectGet<CppUserData*>(cppThis, String::cppNew("_array")),
                i)));
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
          CppObjectGet<Int*>(cppThis, String::cppNew("_length")),
          Int::cppNew(0))))
    return String::cppNew(new uint8_t[3]{91, 93, 0});
  Object* buffer = CppStringBuffer::cppCtr_(
      CppStringBuffer::cppNew(), String::cppNew(new uint8_t[2]{91, 0}));
  cppApply<void, Object*>(
      buffer, String::cppNew("write"),
      CppApi::cppGetPointerArrayItem(
          CppObjectGet<CppUserData*>(cppThis, String::cppNew("_array")),
          Int::cppNew(0)));
  {
    Int* i = Int::cppNew(1);
    while (CppApi::cppBoolValue(Num::cpp_lessThan(
        i, CppObjectGet<Int*>(cppThis, String::cppNew("_length"))))) {
      {
        cppApply<void, Object*>(buffer, String::cppNew("write"),
                                String::cppNew(new uint8_t[3]{44, 32, 0}));
        cppApply<void, Object*>(
            buffer, String::cppNew("write"),
            CppApi::cppGetPointerArrayItem(
                CppObjectGet<CppUserData*>(cppThis, String::cppNew("_array")),
                i));
      }
      i = Num::cpp_add(i, Int::cppNew(1));
    }
  }
  cppApply<void, Object*>(buffer, String::cppNew("write"),
                          String::cppNew(new uint8_t[2]{93, 0}));
  return cppApply<String*>(buffer, String::cppNew("toString"));
}

Object* CppList::cppNew() {
  static std::map<String*, void*> v_ptrs = {
      {String::cppNew("cpp_equals"),
       reinterpret_cast<void*>(&Object::cpp_equals)},
      {String::cppNew("cppGet_hashCode"),
       reinterpret_cast<void*>(&Object::cppGet_hashCode)},
      {String::cppNew("toString"), reinterpret_cast<void*>(&CppList::toString)},
      {String::cppNew("noSuchMethod"),
       reinterpret_cast<void*>(&Object::noSuchMethod)},
      {String::cppNew("cppGet_runtimeType"),
       reinterpret_cast<void*>(&Object::cppGet_runtimeType)},
      {String::cppNew("cppGet_isEmpty"),
       reinterpret_cast<void*>(&CppList::cppGet_isEmpty)},
      {String::cppNew("cppGet_isNotEmpty"),
       reinterpret_cast<void*>(&CppList::cppGet_isNotEmpty)},
      {String::cppNew("cppGet_first"),
       reinterpret_cast<void*>(&CppList::cppGet_first)},
      {String::cppNew("cppGet_last"),
       reinterpret_cast<void*>(&CppList::cppGet_last)},
      {String::cppNew("cppGet_single"),
       reinterpret_cast<void*>(&CppList::cppGet_single)},
      {String::cppNew("elementAt"),
       reinterpret_cast<void*>(&CppList::elementAt)},
      {String::cppNew("contains"), reinterpret_cast<void*>(&CppList::contains)},
      {String::cppNew("forEach"), reinterpret_cast<void*>(&CppList::forEach)},
      {String::cppNew("map"), reinterpret_cast<void*>(&CppIterable::map)},
      {String::cppNew("where"), reinterpret_cast<void*>(&CppIterable::where)},
      {String::cppNew("whereType"),
       reinterpret_cast<void*>(&CppIterable::whereType)},
      {String::cppNew("expand"), reinterpret_cast<void*>(&CppIterable::expand)},
      {String::cppNew("any"), reinterpret_cast<void*>(&CppList::any)},
      {String::cppNew("every"), reinterpret_cast<void*>(&CppList::every)},
      {String::cppNew("firstWhere"),
       reinterpret_cast<void*>(&CppList::firstWhere)},
      {String::cppNew("lastWhere"),
       reinterpret_cast<void*>(&CppList::lastWhere)},
      {String::cppNew("singleWhere"),
       reinterpret_cast<void*>(&CppList::singleWhere)},
      {String::cppNew("reduce"), reinterpret_cast<void*>(&CppList::reduce)},
      {String::cppNew("fold"), reinterpret_cast<void*>(&CppList::fold)},
      {String::cppNew("join"), reinterpret_cast<void*>(&CppList::join)},
      {String::cppNew("take"), reinterpret_cast<void*>(&CppIterable::take)},
      {String::cppNew("takeWhile"),
       reinterpret_cast<void*>(&CppIterable::takeWhile)},
      {String::cppNew("skip"), reinterpret_cast<void*>(&CppIterable::skip)},
      {String::cppNew("skipWhile"),
       reinterpret_cast<void*>(&CppIterable::skipWhile)},
      {String::cppNew("cppGet_reversed"),
       reinterpret_cast<void*>(&CppIterable::cppGet_reversed)},
      {String::cppNew("followedBy"),
       reinterpret_cast<void*>(&CppIterable::followedBy)},
      {String::cppNew("toList"), reinterpret_cast<void*>(&CppList::toList)},
      {String::cppNew("toSet"), reinterpret_cast<void*>(&CppList::toSet)},
      {String::cppNew("cast"), reinterpret_cast<void*>(&CppList::cast)},
      {String::cppNew("cppGet_iterator"),
       reinterpret_cast<void*>(&CppList::cppGet_iterator)},
      {String::cppNew("cppGet_length"),
       reinterpret_cast<void*>(&CppList::cppGet_length)},
      {String::cppNew("ensureCapacity"),
       reinterpret_cast<void*>(&CppList::ensureCapacity)},
      {String::cppNew("cppSet_length"),
       reinterpret_cast<void*>(&CppList::cppSet_length)},
      {String::cppNew("cpp_subscript"),
       reinterpret_cast<void*>(&CppList::cpp_subscript)},
      {String::cppNew("cpp_subscriptAssign"),
       reinterpret_cast<void*>(&CppList::cpp_subscriptAssign)},
      {String::cppNew("add"), reinterpret_cast<void*>(&CppList::add)},
      {String::cppNew("addAll"), reinterpret_cast<void*>(&CppList::addAll)},
      {String::cppNew("asMap"), reinterpret_cast<void*>(&CppList::asMap)},
      {String::cppNew("clear"), reinterpret_cast<void*>(&CppList::clear)},
      {String::cppNew("fillRange"),
       reinterpret_cast<void*>(&CppList::fillRange)},
      {String::cppNew("getRange"), reinterpret_cast<void*>(&CppList::getRange)},
      {String::cppNew("indexOf"), reinterpret_cast<void*>(&CppList::indexOf)},
      {String::cppNew("indexWhere"),
       reinterpret_cast<void*>(&CppList::indexWhere)},
      {String::cppNew("insert"), reinterpret_cast<void*>(&CppList::insert)},
      {String::cppNew("insertAll"),
       reinterpret_cast<void*>(&CppList::insertAll)},
      {String::cppNew("cppSet_first"),
       reinterpret_cast<void*>(&CppList::cppSet_first)},
      {String::cppNew("cppSet_last"),
       reinterpret_cast<void*>(&CppList::cppSet_last)},
      {String::cppNew("lastIndexOf"),
       reinterpret_cast<void*>(&CppList::lastIndexOf)},
      {String::cppNew("lastIndexWhere"),
       reinterpret_cast<void*>(&CppList::lastIndexWhere)},
      {String::cppNew("remove"), reinterpret_cast<void*>(&CppList::remove)},
      {String::cppNew("removeAt"), reinterpret_cast<void*>(&CppList::removeAt)},
      {String::cppNew("removeLast"),
       reinterpret_cast<void*>(&CppList::removeLast)},
      {String::cppNew("removeRange"),
       reinterpret_cast<void*>(&CppList::removeRange)},
      {String::cppNew("removeWhere"),
       reinterpret_cast<void*>(&CppList::removeWhere)},
      {String::cppNew("replaceRange"),
       reinterpret_cast<void*>(&CppList::replaceRange)},
      {String::cppNew("retainWhere"),
       reinterpret_cast<void*>(&CppList::retainWhere)},
      {String::cppNew("setAll"), reinterpret_cast<void*>(&CppList::setAll)},
      {String::cppNew("setRange"), reinterpret_cast<void*>(&CppList::setRange)},
      {String::cppNew("shuffle"), reinterpret_cast<void*>(&CppList::shuffle)},
      {String::cppNew("sort"), reinterpret_cast<void*>(&CppList::sort)},
      {String::cppNew("_quickSort"),
       reinterpret_cast<void*>(&CppList::_quickSort)},
      {String::cppNew("_partition"),
       reinterpret_cast<void*>(&CppList::_partition)},
      {String::cppNew("_swap"), reinterpret_cast<void*>(&CppList::_swap)},
      {String::cppNew("sublist"), reinterpret_cast<void*>(&CppList::sublist)},
      {String::cppNew("cpp_add"), reinterpret_cast<void*>(&CppList::cpp_add)}};
  static Type* runtimeType = new Type("CppList");
  Object* ptr = new ObjectImp(const_cast<Type*>(runtimeType), &v_ptrs);
  return ptr;
}

//  library package:dart2bytecode/demo/collection.dart
Object* _CppListIterator::cppCtr_(Object* cppThis, Object* _list) {
  CppObjectSet<Object*>(cppThis, String::cppNew("_list"), _list);

  return cppThis;
}

Object* _CppListIterator::cppGet_current(Object* cppThis) {
  return cppApply<Object*, Int*>(
      CppObjectGet<Object*>(cppThis, String::cppNew("_list")),
      String::cppNew("cpp_subscript"),
      CppObjectGet<Int*>(cppThis, String::cppNew("_index")));
}

Bool* _CppListIterator::moveNext(Object* cppThis) {
  CppObjectSet<Int*>(
      cppThis, String::cppNew("_index"),
      Num::cpp_add(CppObjectGet<Int*>(cppThis, String::cppNew("_index")),
                   Int::cppNew(1)));
  return Num::cpp_lessThan(
      CppObjectGet<Int*>(cppThis, String::cppNew("_index")),
      cppApply<Int*>(CppObjectGet<Object*>(cppThis, String::cppNew("_list")),
                     String::cppNew("cppGet_length")));
}

Object* _CppListIterator::cppNew() {
  static std::map<String*, void*> v_ptrs = {
      {String::cppNew("cpp_equals"),
       reinterpret_cast<void*>(&Object::cpp_equals)},
      {String::cppNew("cppGet_hashCode"),
       reinterpret_cast<void*>(&Object::cppGet_hashCode)},
      {String::cppNew("toString"), reinterpret_cast<void*>(&Object::toString)},
      {String::cppNew("noSuchMethod"),
       reinterpret_cast<void*>(&Object::noSuchMethod)},
      {String::cppNew("cppGet_runtimeType"),
       reinterpret_cast<void*>(&Object::cppGet_runtimeType)},
      {String::cppNew("cppGet_current"),
       reinterpret_cast<void*>(&_CppListIterator::cppGet_current)},
      {String::cppNew("moveNext"),
       reinterpret_cast<void*>(&_CppListIterator::moveNext)}};
  static Type* runtimeType = new Type("_CppListIterator");
  Object* ptr = new ObjectImp(const_cast<Type*>(runtimeType), &v_ptrs);
  return ptr;
}

//  library package:dart2bytecode/demo/collection.dart
Object* CppSet::cppCtr_fromCppArray(Object* cppThis, CppUserData* array) {
  CppObjectSet<Object*>(cppThis, String::cppNew("_list"),
                        CppList::cppCtr_fromCppArray(CppList::cppNew(), array));

  return cppThis;
}

Object* CppSet::cppCtr_(Object* cppThis, Int* capacity) {
  CppObjectSet<Object*>(
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
          Object* element = cppApply<Object*>($sync_for_iterator,
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

Object* CppSet::castFrom(Object* source) {
  Object* result = CppSet::cppCtr_(CppSet::cppNew(), Int::cppNew(4));
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
            cppApply<Bool*, Object*>(result, String::cppNew("add"),
                                     reinterpret_cast<Object*>(element));
          }
        }
      }
    }
  }
  return result;
}

Object* CppSet::castFromWithFactory(Object* source, Function* newSet) {
  Object* result = cppApply<Object*>(newSet);
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
            cppApply<Bool*, Object*>(result, String::cppNew("add"),
                                     reinterpret_cast<Object*>(element));
          }
        }
      }
    }
  }
  return result;
}

Bool* CppSet::add(Object* cppThis, Object* value) {
  if (CppApi::cppBoolValue(cppApply<Bool*, Object*>(
          cppThis, String::cppNew("contains"), value))) {
    return Bool::cppNew(false);
  }
  cppApply<void, Object*>(
      CppObjectGet<Object*>(cppThis, String::cppNew("_list")),
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

Object* CppSet::cast(Object* cppThis) {
  return CppSet::castFrom(cppThis);
}

void CppSet::clear(Object* cppThis) {
  cppApply<void>(CppObjectGet<Object*>(cppThis, String::cppNew("_list")),
                 String::cppNew("clear"));
}

Bool* CppSet::contains(Object* cppThis, Object* element) {
  {
    Int* i = Int::cppNew(0);
    while (CppApi::cppBoolValue(Num::cpp_lessThan(
        i,
        cppApply<Int*>(CppObjectGet<Object*>(cppThis, String::cppNew("_list")),
                       String::cppNew("cppGet_length"))))) {
      {
        if (CppApi::cppBoolValue(Object::cpp_equals(
                element,
                cppApply<Object*, Int*>(
                    CppObjectGet<Object*>(cppThis, String::cppNew("_list")),
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
    Object* $sync_for_iterator = cppApply<Object*>(
        CppObjectGet<Object*>(cppThis, String::cppNew("_list")),
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
      CppObjectGet<Object*>(cppThis, String::cppNew("_list")),
      String::cppNew("elementAt"), index);
}

Object* CppSet::intersection(Object* cppThis, Object* other) {
  Object* result = CppSet::cppCtr_(CppSet::cppNew(), Int::cppNew(4));
  {
    Object* $sync_for_iterator = cppApply<Object*>(
        CppObjectGet<Object*>(cppThis, String::cppNew("_list")),
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
  if (CppApi::cppBoolValue(cppApply<Bool*>(
          CppObjectGet<Object*>(cppThis, String::cppNew("_list")),
          String::cppNew("cppGet_isEmpty"))))
    throw "ConstructorInvocation(new StateError(No element))";
  return cppApply<Object*>(
      CppObjectGet<Object*>(cppThis, String::cppNew("_list")),
      String::cppNew("cppGet_first"));
}

Object* CppSet::cppGet_last(Object* cppThis) {
  if (CppApi::cppBoolValue(cppApply<Bool*>(
          CppObjectGet<Object*>(cppThis, String::cppNew("_list")),
          String::cppNew("cppGet_isEmpty"))))
    throw "ConstructorInvocation(new StateError(No element))";
  return cppApply<Object*>(
      CppObjectGet<Object*>(cppThis, String::cppNew("_list")),
      String::cppNew("cppGet_last"));
}

Object* CppSet::cppGet_single(Object* cppThis) {
  if (CppApi::cppBoolValue(cppApply<Bool*>(
          CppObjectGet<Object*>(cppThis, String::cppNew("_list")),
          String::cppNew("cppGet_isEmpty"))))
    throw "ConstructorInvocation(new StateError(No element))";
  if (CppApi::cppBoolValue(Num::cpp_greaterThan(
          cppApply<Int*>(
              CppObjectGet<Object*>(cppThis, String::cppNew("_list")),
              String::cppNew("cppGet_length")),
          Int::cppNew(1))))
    throw "ConstructorInvocation(new StateError(Too many elements))";
  return cppApply<Object*>(
      CppObjectGet<Object*>(cppThis, String::cppNew("_list")),
      String::cppNew("cppGet_single"));
}

Bool* CppSet::cppGet_isEmpty(Object* cppThis) {
  return cppApply<Bool*>(
      CppObjectGet<Object*>(cppThis, String::cppNew("_list")),
      String::cppNew("cppGet_isEmpty"));
}

Bool* CppSet::cppGet_isNotEmpty(Object* cppThis) {
  return cppApply<Bool*>(
      CppObjectGet<Object*>(cppThis, String::cppNew("_list")),
      String::cppNew("cppGet_isNotEmpty"));
}

Object* CppSet::cppGet_iterator(Object* cppThis) {
  return cppApply<Object*>(
      CppObjectGet<Object*>(cppThis, String::cppNew("_list")),
      String::cppNew("cppGet_iterator"));
}

Int* CppSet::cppGet_length(Object* cppThis) {
  return cppApply<Int*>(CppObjectGet<Object*>(cppThis, String::cppNew("_list")),
                        String::cppNew("cppGet_length"));
}

Object* CppSet::lookup(Object* cppThis, Object* element) {
  {
    Int* i = Int::cppNew(0);
    while (CppApi::cppBoolValue(Num::cpp_lessThan(
        i,
        cppApply<Int*>(CppObjectGet<Object*>(cppThis, String::cppNew("_list")),
                       String::cppNew("cppGet_length"))))) {
      {
        if (CppApi::cppBoolValue(Object::cpp_equals(
                element,
                cppApply<Object*, Int*>(
                    CppObjectGet<Object*>(cppThis, String::cppNew("_list")),
                    String::cppNew("cpp_subscript"), i)))) {
          return cppApply<Object*, Int*>(
              CppObjectGet<Object*>(cppThis, String::cppNew("_list")),
              String::cppNew("cpp_subscript"), i);
        }
      }
      i = Num::cpp_add(i, Int::cppNew(1));
    }
  }
  return nullptr;
}

Bool* CppSet::remove(Object* cppThis, Object* value) {
  return cppApply<Bool*, Object*>(
      CppObjectGet<Object*>(cppThis, String::cppNew("_list")),
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
  cppApply<void, Function*>(
      CppObjectGet<Object*>(cppThis, String::cppNew("_list")),
      String::cppNew("removeWhere"), test);
}

void CppSet::retainAll(Object* cppThis, Object* elementsToRetain) {
  Object* retainSet = CppSet::from(elementsToRetain);
  cppApply<void, Function*>(
      cppThis, String::cppNew("removeWhere"),
      new LambdaWrapper<Bool*, Object*>([&](Object* element) -> Bool* {
        return Bool::cpp_not(cppApply<Bool*, Object*>(
            retainSet, String::cppNew("contains"), element));
      }));
}

void CppSet::retainWhere(Object* cppThis, Function* test) {
  cppApply<void, Function*>(
      CppObjectGet<Object*>(cppThis, String::cppNew("_list")),
      String::cppNew("retainWhere"), test);
}

Object* CppSet::cpp_union(Object* cppThis, Object* other) {
  Object* result = CppSet::cppCtr_(CppSet::cppNew(), Int::cppNew(4));
  cppApply<void, Object*>(result, String::cppNew("addAll"), cppThis);
  cppApply<void, Object*>(result, String::cppNew("addAll"), other);
  return result;
}

String* CppSet::toString(Object* cppThis) {
  if (CppApi::cppBoolValue(cppApply<Bool*>(
          CppObjectGet<Object*>(cppThis, String::cppNew("_list")),
          String::cppNew("cppGet_isEmpty"))))
    return String::cppNew(new uint8_t[3]{123, 125, 0});
  Object* buffer = CppStringBuffer::cppCtr_(
      CppStringBuffer::cppNew(), String::cppNew(new uint8_t[2]{123, 0}));
  Object* iterator =
      cppApply<Object*>(CppObjectGet<Object*>(cppThis, String::cppNew("_list")),
                        String::cppNew("cppGet_iterator"));
  if (CppApi::cppBoolValue(
          cppApply<Bool*>(iterator, String::cppNew("moveNext")))) {
    cppApply<void, Object*>(
        buffer, String::cppNew("write"),
        cppApply<Object*>(iterator, String::cppNew("cppGet_current")));
    while (CppApi::cppBoolValue(
        cppApply<Bool*>(iterator, String::cppNew("moveNext")))) {
      cppApply<void, Object*>(buffer, String::cppNew("write"),
                              String::cppNew(new uint8_t[3]{44, 32, 0}));
      cppApply<void, Object*>(
          buffer, String::cppNew("write"),
          cppApply<Object*>(iterator, String::cppNew("cppGet_current")));
    }
  }
  cppApply<void, Object*>(buffer, String::cppNew("write"),
                          String::cppNew(new uint8_t[2]{125, 0}));
  return cppApply<String*>(buffer, String::cppNew("toString"));
}

Object* CppSet::cppNew() {
  static std::map<String*, void*> v_ptrs = {
      {String::cppNew("cpp_equals"),
       reinterpret_cast<void*>(&Object::cpp_equals)},
      {String::cppNew("cppGet_hashCode"),
       reinterpret_cast<void*>(&Object::cppGet_hashCode)},
      {String::cppNew("toString"), reinterpret_cast<void*>(&CppSet::toString)},
      {String::cppNew("noSuchMethod"),
       reinterpret_cast<void*>(&Object::noSuchMethod)},
      {String::cppNew("cppGet_runtimeType"),
       reinterpret_cast<void*>(&Object::cppGet_runtimeType)},
      {String::cppNew("cppGet_isEmpty"),
       reinterpret_cast<void*>(&CppSet::cppGet_isEmpty)},
      {String::cppNew("cppGet_isNotEmpty"),
       reinterpret_cast<void*>(&CppSet::cppGet_isNotEmpty)},
      {String::cppNew("cppGet_first"),
       reinterpret_cast<void*>(&CppSet::cppGet_first)},
      {String::cppNew("cppGet_last"),
       reinterpret_cast<void*>(&CppSet::cppGet_last)},
      {String::cppNew("cppGet_single"),
       reinterpret_cast<void*>(&CppSet::cppGet_single)},
      {String::cppNew("elementAt"),
       reinterpret_cast<void*>(&CppSet::elementAt)},
      {String::cppNew("contains"), reinterpret_cast<void*>(&CppSet::contains)},
      {String::cppNew("forEach"),
       reinterpret_cast<void*>(&CppIterable::forEach)},
      {String::cppNew("map"), reinterpret_cast<void*>(&CppIterable::map)},
      {String::cppNew("where"), reinterpret_cast<void*>(&CppIterable::where)},
      {String::cppNew("whereType"),
       reinterpret_cast<void*>(&CppIterable::whereType)},
      {String::cppNew("expand"), reinterpret_cast<void*>(&CppIterable::expand)},
      {String::cppNew("any"), reinterpret_cast<void*>(&CppIterable::any)},
      {String::cppNew("every"), reinterpret_cast<void*>(&CppIterable::every)},
      {String::cppNew("firstWhere"),
       reinterpret_cast<void*>(&CppIterable::firstWhere)},
      {String::cppNew("lastWhere"),
       reinterpret_cast<void*>(&CppIterable::lastWhere)},
      {String::cppNew("singleWhere"),
       reinterpret_cast<void*>(&CppIterable::singleWhere)},
      {String::cppNew("reduce"), reinterpret_cast<void*>(&CppIterable::reduce)},
      {String::cppNew("fold"), reinterpret_cast<void*>(&CppIterable::fold)},
      {String::cppNew("join"), reinterpret_cast<void*>(&CppIterable::join)},
      {String::cppNew("take"), reinterpret_cast<void*>(&CppIterable::take)},
      {String::cppNew("takeWhile"),
       reinterpret_cast<void*>(&CppIterable::takeWhile)},
      {String::cppNew("skip"), reinterpret_cast<void*>(&CppIterable::skip)},
      {String::cppNew("skipWhile"),
       reinterpret_cast<void*>(&CppIterable::skipWhile)},
      {String::cppNew("cppGet_reversed"),
       reinterpret_cast<void*>(&CppIterable::cppGet_reversed)},
      {String::cppNew("followedBy"),
       reinterpret_cast<void*>(&CppIterable::followedBy)},
      {String::cppNew("toList"), reinterpret_cast<void*>(&CppIterable::toList)},
      {String::cppNew("toSet"), reinterpret_cast<void*>(&CppIterable::toSet)},
      {String::cppNew("cast"), reinterpret_cast<void*>(&CppSet::cast)},
      {String::cppNew("cppGet_iterator"),
       reinterpret_cast<void*>(&CppSet::cppGet_iterator)},
      {String::cppNew("cppGet_length"),
       reinterpret_cast<void*>(&CppSet::cppGet_length)},
      {String::cppNew("add"), reinterpret_cast<void*>(&CppSet::add)},
      {String::cppNew("addAll"), reinterpret_cast<void*>(&CppSet::addAll)},
      {String::cppNew("clear"), reinterpret_cast<void*>(&CppSet::clear)},
      {String::cppNew("containsAll"),
       reinterpret_cast<void*>(&CppSet::containsAll)},
      {String::cppNew("difference"),
       reinterpret_cast<void*>(&CppSet::difference)},
      {String::cppNew("intersection"),
       reinterpret_cast<void*>(&CppSet::intersection)},
      {String::cppNew("lookup"), reinterpret_cast<void*>(&CppSet::lookup)},
      {String::cppNew("remove"), reinterpret_cast<void*>(&CppSet::remove)},
      {String::cppNew("removeAll"),
       reinterpret_cast<void*>(&CppSet::removeAll)},
      {String::cppNew("removeWhere"),
       reinterpret_cast<void*>(&CppSet::removeWhere)},
      {String::cppNew("retainAll"),
       reinterpret_cast<void*>(&CppSet::retainAll)},
      {String::cppNew("retainWhere"),
       reinterpret_cast<void*>(&CppSet::retainWhere)},
      {String::cppNew("cpp_union"),
       reinterpret_cast<void*>(&CppSet::cpp_union)}};
  static Type* runtimeType = new Type("CppSet");
  Object* ptr = new ObjectImp(const_cast<Type*>(runtimeType), &v_ptrs);
  return ptr;
}

//  library package:dart2bytecode/demo/collection.dart
Object* CppMap::cppCtr_fromCppArray(Object* cppThis, CppUserData* array) {
  CppObjectSet<Object*>(cppThis, String::cppNew("_list"),
                        CppList::cppCtr_fromCppArray(CppList::cppNew(), array));

  return cppThis;
}

Object* CppMap::cppCtr_(Object* cppThis, Int* capacity) {
  CppObjectSet<Object*>(
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
      new LambdaWrapper<void, Object*, Object*>([&](Object* key,
                                                    Object* value) -> void {
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
          Object* element = cppApply<Object*>($sync_for_iterator,
                                              String::cppNew("cppGet_current"));
          {
            Object* k = ([&]() {
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
            Object* v = ([&]() {
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
                CppObjectGet<Object*>(entry, String::cppNew("key")),
                CppObjectGet<Object*>(entry, String::cppNew("value")));
          }
        }
      }
    }
  }
  return map;
}

Object* CppMap::cpp_subscript(Object* cppThis, Object* key) {
  {
    Object* $sync_for_iterator = cppApply<Object*>(
        CppObjectGet<Object*>(cppThis, String::cppNew("_list")),
        String::cppNew("cppGet_iterator"));
    {
      while (CppApi::cppBoolValue(
          cppApply<Bool*>($sync_for_iterator, String::cppNew("moveNext")))) {
        {
          Object* entry = cppApply<Object*>($sync_for_iterator,
                                            String::cppNew("cppGet_current"));
          {
            if (CppApi::cppBoolValue(Object::cpp_equals(
                    CppObjectGet<Object*>(entry, String::cppNew("key")),
                    key))) {
              return CppObjectGet<Object*>(entry, String::cppNew("value"));
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
        i,
        cppApply<Int*>(CppObjectGet<Object*>(cppThis, String::cppNew("_list")),
                       String::cppNew("cppGet_length"))))) {
      {
        if (CppApi::cppBoolValue(Object::cpp_equals(
                CppObjectGet<Object*>(
                    cppApply<Object*, Int*>(
                        CppObjectGet<Object*>(cppThis, String::cppNew("_list")),
                        String::cppNew("cpp_subscript"), i),
                    String::cppNew("key")),
                key))) {
          cppApply<void, Int*, Object*>(
              CppObjectGet<Object*>(cppThis, String::cppNew("_list")),
              String::cppNew("cpp_subscriptAssign"), i,
              MapEntry::cppCtr__(MapEntry::cppNew(), key, value));
          return;
        }
      }
      i = Num::cpp_add(i, Int::cppNew(1));
    }
  }
  cppApply<void, Object*>(
      CppObjectGet<Object*>(cppThis, String::cppNew("_list")),
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
                  cppApply<void, Object*, Object*>(
                      cppThis, String::cppNew("cpp_subscriptAssign"), cppLet_0,
                      cppLet_0);
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
                CppObjectGet<Object*>(entry, String::cppNew("key")),
                CppObjectGet<Object*>(entry, String::cppNew("value")));
          }
        }
      }
    }
  }
}

Object* CppMap::cast(Object* cppThis) {
  return CppMap::castFrom(cppThis);
}

Object* CppMap::castFrom(Object* source) {
  Object* result = CppMap::cppCtr_(CppMap::cppNew(), Int::cppNew(4));
  cppApply<void, Function*>(
      source, String::cppNew("forEach"),
      new LambdaWrapper<void, Object*, Object*>([&](Object* key,
                                                    Object* value) -> void {
        cppApply<void, Object*, Object*>(
            result, String::cppNew("cpp_subscriptAssign"),
            reinterpret_cast<Object*>(key), reinterpret_cast<Object*>(value));
      }));
  return result;
}

Object* CppMap::castFromWithFactory(Object* source, Function* newMap) {
  Object* result = cppApply<Object*>(newMap);
  cppApply<void, Function*>(
      source, String::cppNew("forEach"),
      new LambdaWrapper<void, Object*, Object*>([&](Object* key,
                                                    Object* value) -> void {
        cppApply<void, Object*, Object*>(
            result, String::cppNew("cpp_subscriptAssign"),
            reinterpret_cast<Object*>(key), reinterpret_cast<Object*>(value));
      }));
  return result;
}

void CppMap::clear(Object* cppThis) {
  cppApply<void>(CppObjectGet<Object*>(cppThis, String::cppNew("_list")),
                 String::cppNew("clear"));
}

Bool* CppMap::containsKey(Object* cppThis, Object* key) {
  {
    Object* $sync_for_iterator = cppApply<Object*>(
        CppObjectGet<Object*>(cppThis, String::cppNew("_list")),
        String::cppNew("cppGet_iterator"));
    {
      while (CppApi::cppBoolValue(
          cppApply<Bool*>($sync_for_iterator, String::cppNew("moveNext")))) {
        {
          Object* entry = cppApply<Object*>($sync_for_iterator,
                                            String::cppNew("cppGet_current"));
          {
            if (CppApi::cppBoolValue(Object::cpp_equals(
                    CppObjectGet<Object*>(entry, String::cppNew("key")), key)))
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
    Object* $sync_for_iterator = cppApply<Object*>(
        CppObjectGet<Object*>(cppThis, String::cppNew("_list")),
        String::cppNew("cppGet_iterator"));
    {
      while (CppApi::cppBoolValue(
          cppApply<Bool*>($sync_for_iterator, String::cppNew("moveNext")))) {
        {
          Object* entry = cppApply<Object*>($sync_for_iterator,
                                            String::cppNew("cppGet_current"));
          {
            if (CppApi::cppBoolValue(Object::cpp_equals(
                    CppObjectGet<Object*>(entry, String::cppNew("value")),
                    value)))
              return Bool::cppNew(true);
          }
        }
      }
    }
  }
  return Bool::cppNew(false);
}

Object* CppMap::cppGet_entries(Object* cppThis) {
  return CppObjectGet<Object*>(cppThis, String::cppNew("_list"));
}

void CppMap::forEach(Object* cppThis, Function* action) {
  {
    Object* $sync_for_iterator = cppApply<Object*>(
        CppObjectGet<Object*>(cppThis, String::cppNew("_list")),
        String::cppNew("cppGet_iterator"));
    {
      while (CppApi::cppBoolValue(
          cppApply<Bool*>($sync_for_iterator, String::cppNew("moveNext")))) {
        {
          Object* entry = cppApply<Object*>($sync_for_iterator,
                                            String::cppNew("cppGet_current"));
          {
            cppApply<void>(
                action, CppObjectGet<Object*>(entry, String::cppNew("key")),
                CppObjectGet<Object*>(entry, String::cppNew("value")));
          }
        }
      }
    }
  }
}

Bool* CppMap::cppGet_isEmpty(Object* cppThis) {
  return cppApply<Bool*>(
      CppObjectGet<Object*>(cppThis, String::cppNew("_list")),
      String::cppNew("cppGet_isEmpty"));
}

Bool* CppMap::cppGet_isNotEmpty(Object* cppThis) {
  return cppApply<Bool*>(
      CppObjectGet<Object*>(cppThis, String::cppNew("_list")),
      String::cppNew("cppGet_isNotEmpty"));
}

Object* CppMap::cppGet_keys(Object* cppThis) {
  return cppApply<Object*, Function*>(
      CppObjectGet<Object*>(cppThis, String::cppNew("_list")),
      String::cppNew("map"),
      new LambdaWrapper<Object*, Object*>([&](Object* e) -> Object* {
        return CppObjectGet<Object*>(e, String::cppNew("key"));
      }));
}

Int* CppMap::cppGet_length(Object* cppThis) {
  return cppApply<Int*>(CppObjectGet<Object*>(cppThis, String::cppNew("_list")),
                        String::cppNew("cppGet_length"));
}

Object* CppMap::putIfAbsent(Object* cppThis, Object* key, Function* ifAbsent) {
  {
    Object* $sync_for_iterator = cppApply<Object*>(
        CppObjectGet<Object*>(cppThis, String::cppNew("_list")),
        String::cppNew("cppGet_iterator"));
    {
      while (CppApi::cppBoolValue(
          cppApply<Bool*>($sync_for_iterator, String::cppNew("moveNext")))) {
        {
          Object* entry = cppApply<Object*>($sync_for_iterator,
                                            String::cppNew("cppGet_current"));
          {
            if (CppApi::cppBoolValue(Object::cpp_equals(
                    CppObjectGet<Object*>(entry, String::cppNew("key")), key)))
              return CppObjectGet<Object*>(entry, String::cppNew("value"));
          }
        }
      }
    }
  }
  Object* v = cppApply<Object*>(ifAbsent);
  cppApply<void, Object*>(
      CppObjectGet<Object*>(cppThis, String::cppNew("_list")),
      String::cppNew("add"), MapEntry::cppCtr__(MapEntry::cppNew(), key, v));
  return v;
}

Object* CppMap::remove(Object* cppThis, Object* key) {
  {
    Int* i = Int::cppNew(0);
    while (CppApi::cppBoolValue(Num::cpp_lessThan(
        i,
        cppApply<Int*>(CppObjectGet<Object*>(cppThis, String::cppNew("_list")),
                       String::cppNew("cppGet_length"))))) {
      {
        if (CppApi::cppBoolValue(Object::cpp_equals(
                CppObjectGet<Object*>(
                    cppApply<Object*, Int*>(
                        CppObjectGet<Object*>(cppThis, String::cppNew("_list")),
                        String::cppNew("cpp_subscript"), i),
                    String::cppNew("key")),
                key))) {
          Object* v = CppObjectGet<Object*>(
              cppApply<Object*, Int*>(
                  CppObjectGet<Object*>(cppThis, String::cppNew("_list")),
                  String::cppNew("cpp_subscript"), i),
              String::cppNew("value"));
          {
            Int* j = i;
            while (CppApi::cppBoolValue(Num::cpp_lessThan(
                j, Num::cpp_subtract(
                       cppApply<Int*>(CppObjectGet<Object*>(
                                          cppThis, String::cppNew("_list")),
                                      String::cppNew("cppGet_length")),
                       Int::cppNew(1))))) {
              {
                cppApply<void, Int*, Object*>(
                    CppObjectGet<Object*>(cppThis, String::cppNew("_list")),
                    String::cppNew("cpp_subscriptAssign"), j,
                    cppApply<Object*, Int*>(
                        CppObjectGet<Object*>(cppThis, String::cppNew("_list")),
                        String::cppNew("cpp_subscript"),
                        Num::cpp_add(j, Int::cppNew(1))));
              }
              j = Num::cpp_add(j, Int::cppNew(1));
            }
          }
          cppApply<void, Int*>(
              CppObjectGet<Object*>(cppThis, String::cppNew("_list")),
              String::cppNew("cppSet_length"),
              Num::cpp_subtract(
                  cppApply<Int*>(
                      CppObjectGet<Object*>(cppThis, String::cppNew("_list")),
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
      i, cppApply<Int*>(CppObjectGet<Object*>(cppThis, String::cppNew("_list")),
                        String::cppNew("cppGet_length"))))) {
    Object* entry = cppApply<Object*, Int*>(
        CppObjectGet<Object*>(cppThis, String::cppNew("_list")),
        String::cppNew("cpp_subscript"), i);
    if (CppApi::cppBoolValue(cppApply<Bool*>(
            test, CppObjectGet<Object*>(entry, String::cppNew("key")),
            CppObjectGet<Object*>(entry, String::cppNew("value"))))) {
      cppApply<Object*, Object*>(
          cppThis, String::cppNew("remove"),
          CppObjectGet<Object*>(entry, String::cppNew("key")));
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
        i,
        cppApply<Int*>(CppObjectGet<Object*>(cppThis, String::cppNew("_list")),
                       String::cppNew("cppGet_length"))))) {
      {
        if (CppApi::cppBoolValue(Object::cpp_equals(
                CppObjectGet<Object*>(
                    cppApply<Object*, Int*>(
                        CppObjectGet<Object*>(cppThis, String::cppNew("_list")),
                        String::cppNew("cpp_subscript"), i),
                    String::cppNew("key")),
                key))) {
          Object* newValue = cppApply<Object*>(
              update,
              CppObjectGet<Object*>(
                  cppApply<Object*, Int*>(
                      CppObjectGet<Object*>(cppThis, String::cppNew("_list")),
                      String::cppNew("cpp_subscript"), i),
                  String::cppNew("value")));
          cppApply<void, Int*, Object*>(
              CppObjectGet<Object*>(cppThis, String::cppNew("_list")),
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
    cppApply<void, Object*>(
        CppObjectGet<Object*>(cppThis, String::cppNew("_list")),
        String::cppNew("add"), MapEntry::cppCtr__(MapEntry::cppNew(), key, v));
    return v;
  }
  throw "ConstructorInvocation(new ArgumentError(Key not found))";
}

void CppMap::updateAll(Object* cppThis, Function* update) {
  {
    Int* i = Int::cppNew(0);
    while (CppApi::cppBoolValue(Num::cpp_lessThan(
        i,
        cppApply<Int*>(CppObjectGet<Object*>(cppThis, String::cppNew("_list")),
                       String::cppNew("cppGet_length"))))) {
      {
        Object* entry = cppApply<Object*, Int*>(
            CppObjectGet<Object*>(cppThis, String::cppNew("_list")),
            String::cppNew("cpp_subscript"), i);
        cppApply<void, Int*, Object*>(
            CppObjectGet<Object*>(cppThis, String::cppNew("_list")),
            String::cppNew("cpp_subscriptAssign"), i,
            MapEntry::cppCtr__(
                MapEntry::cppNew(),
                CppObjectGet<Object*>(entry, String::cppNew("key")),
                cppApply<Object*>(
                    update, CppObjectGet<Object*>(entry, String::cppNew("key")),
                    CppObjectGet<Object*>(entry, String::cppNew("value")))));
      }
      i = Num::cpp_add(i, Int::cppNew(1));
    }
  }
}

Object* CppMap::cppGet_values(Object* cppThis) {
  return cppApply<Object*, Function*>(
      CppObjectGet<Object*>(cppThis, String::cppNew("_list")),
      String::cppNew("map"),
      new LambdaWrapper<Object*, Object*>([&](Object* e) -> Object* {
        return CppObjectGet<Object*>(e, String::cppNew("value"));
      }));
}

Object* CppMap::map(Object* cppThis, Function* transform) {
  Object* result = CppMap::cppCtr_(CppMap::cppNew(), Int::cppNew(4));
  {
    Object* $sync_for_iterator = cppApply<Object*>(
        CppObjectGet<Object*>(cppThis, String::cppNew("_list")),
        String::cppNew("cppGet_iterator"));
    {
      while (CppApi::cppBoolValue(
          cppApply<Bool*>($sync_for_iterator, String::cppNew("moveNext")))) {
        {
          Object* entry = cppApply<Object*>($sync_for_iterator,
                                            String::cppNew("cppGet_current"));
          {
            Object* newEntry = cppApply<Object*>(
                transform, CppObjectGet<Object*>(entry, String::cppNew("key")),
                CppObjectGet<Object*>(entry, String::cppNew("value")));
            cppApply<void, Object*, Object*>(
                result, String::cppNew("cpp_subscriptAssign"),
                CppObjectGet<Object*>(newEntry, String::cppNew("key")),
                CppObjectGet<Object*>(newEntry, String::cppNew("value")));
          }
        }
      }
    }
  }
  return result;
}

String* CppMap::toString(Object* cppThis) {
  if (CppApi::cppBoolValue(cppApply<Bool*>(
          CppObjectGet<Object*>(cppThis, String::cppNew("_list")),
          String::cppNew("cppGet_isEmpty"))))
    return String::cppNew(new uint8_t[3]{123, 125, 0});
  Object* buffer = CppStringBuffer::cppCtr_(
      CppStringBuffer::cppNew(), String::cppNew(new uint8_t[2]{123, 0}));
  Object* iterator =
      cppApply<Object*>(CppObjectGet<Object*>(cppThis, String::cppNew("_list")),
                        String::cppNew("cppGet_iterator"));
  if (CppApi::cppBoolValue(
          cppApply<Bool*>(iterator, String::cppNew("moveNext")))) {
    cppApply<void, Object*>(
        buffer, String::cppNew("write"),
        String::cpp_add(
            String::cpp_add(
                cppToString(CppObjectGet<Object*>(
                    cppApply<Object*>(iterator,
                                      String::cppNew("cppGet_current")),
                    String::cppNew("key"))),
                cppToString(String::cppNew(new uint8_t[3]{58, 32, 0}))),
            cppToString(CppObjectGet<Object*>(
                cppApply<Object*>(iterator, String::cppNew("cppGet_current")),
                String::cppNew("value")))));
    while (CppApi::cppBoolValue(
        cppApply<Bool*>(iterator, String::cppNew("moveNext")))) {
      cppApply<void, Object*>(
          buffer, String::cppNew("write"),
          String::cpp_add(
              String::cpp_add(
                  String::cpp_add(
                      cppToString(String::cppNew(new uint8_t[3]{44, 32, 0})),
                      cppToString(CppObjectGet<Object*>(
                          cppApply<Object*>(iterator,
                                            String::cppNew("cppGet_current")),
                          String::cppNew("key")))),
                  cppToString(String::cppNew(new uint8_t[3]{58, 32, 0}))),
              cppToString(CppObjectGet<Object*>(
                  cppApply<Object*>(iterator, String::cppNew("cppGet_current")),
                  String::cppNew("value")))));
    }
  }
  cppApply<void, Object*>(buffer, String::cppNew("write"),
                          String::cppNew(new uint8_t[2]{125, 0}));
  return cppApply<String*>(buffer, String::cppNew("toString"));
}

Object* CppMap::cppNew() {
  static std::map<String*, void*> v_ptrs = {
      {String::cppNew("cpp_equals"),
       reinterpret_cast<void*>(&Object::cpp_equals)},
      {String::cppNew("cppGet_hashCode"),
       reinterpret_cast<void*>(&Object::cppGet_hashCode)},
      {String::cppNew("toString"), reinterpret_cast<void*>(&CppMap::toString)},
      {String::cppNew("noSuchMethod"),
       reinterpret_cast<void*>(&Object::noSuchMethod)},
      {String::cppNew("cppGet_runtimeType"),
       reinterpret_cast<void*>(&Object::cppGet_runtimeType)},
      {String::cppNew("cpp_subscript"),
       reinterpret_cast<void*>(&CppMap::cpp_subscript)},
      {String::cppNew("cpp_subscriptAssign"),
       reinterpret_cast<void*>(&CppMap::cpp_subscriptAssign)},
      {String::cppNew("addAll"), reinterpret_cast<void*>(&CppMap::addAll)},
      {String::cppNew("addEntries"),
       reinterpret_cast<void*>(&CppMap::addEntries)},
      {String::cppNew("cast"), reinterpret_cast<void*>(&CppMap::cast)},
      {String::cppNew("clear"), reinterpret_cast<void*>(&CppMap::clear)},
      {String::cppNew("containsKey"),
       reinterpret_cast<void*>(&CppMap::containsKey)},
      {String::cppNew("containsValue"),
       reinterpret_cast<void*>(&CppMap::containsValue)},
      {String::cppNew("cppGet_entries"),
       reinterpret_cast<void*>(&CppMap::cppGet_entries)},
      {String::cppNew("forEach"), reinterpret_cast<void*>(&CppMap::forEach)},
      {String::cppNew("cppGet_isEmpty"),
       reinterpret_cast<void*>(&CppMap::cppGet_isEmpty)},
      {String::cppNew("cppGet_isNotEmpty"),
       reinterpret_cast<void*>(&CppMap::cppGet_isNotEmpty)},
      {String::cppNew("cppGet_keys"),
       reinterpret_cast<void*>(&CppMap::cppGet_keys)},
      {String::cppNew("cppGet_length"),
       reinterpret_cast<void*>(&CppMap::cppGet_length)},
      {String::cppNew("putIfAbsent"),
       reinterpret_cast<void*>(&CppMap::putIfAbsent)},
      {String::cppNew("remove"), reinterpret_cast<void*>(&CppMap::remove)},
      {String::cppNew("removeWhere"),
       reinterpret_cast<void*>(&CppMap::removeWhere)},
      {String::cppNew("update"), reinterpret_cast<void*>(&CppMap::update)},
      {String::cppNew("updateAll"),
       reinterpret_cast<void*>(&CppMap::updateAll)},
      {String::cppNew("cppGet_values"),
       reinterpret_cast<void*>(&CppMap::cppGet_values)},
      {String::cppNew("map"), reinterpret_cast<void*>(&CppMap::map)}};
  static Type* runtimeType = new Type("CppMap");
  Object* ptr = new ObjectImp(const_cast<Type*>(runtimeType), &v_ptrs);
  return ptr;
}

//  library package:dart2bytecode/demo/Iterable.dart
Object* CppIterator::cppCtr_(Object* cppThis) {
  return cppThis;
}

//  library package:dart2bytecode/demo/Iterable.dart
Object* CppIterable::cppCtr_(Object* cppThis) {
  return cppThis;
}

Bool* CppIterable::cppGet_isEmpty(Object* cppThis) {
  return Object::cpp_equals(
      cppApply<Int*>(cppThis, String::cppNew("cppGet_length")), Int::cppNew(0));
}

Bool* CppIterable::cppGet_isNotEmpty(Object* cppThis) {
  return Num::cpp_greaterThan(
      cppApply<Int*>(cppThis, String::cppNew("cppGet_length")), Int::cppNew(0));
}

Object* CppIterable::cppGet_first(Object* cppThis) {
  if (CppApi::cppBoolValue(
          cppApply<Bool*>(cppThis, String::cppNew("cppGet_isEmpty"))))
    throw "ConstructorInvocation(new StateError(No element))";
  Object* it = cppApply<Object*>(cppThis, String::cppNew("cppGet_iterator"));
  if (CppApi::cppBoolValue(
          Bool::cpp_not(cppApply<Bool*>(it, String::cppNew("moveNext")))))
    throw "ConstructorInvocation(new StateError(No element))";
  return cppApply<Object*>(it, String::cppNew("cppGet_current"));
}

Object* CppIterable::cppGet_last(Object* cppThis) {
  if (CppApi::cppBoolValue(
          cppApply<Bool*>(cppThis, String::cppNew("cppGet_isEmpty"))))
    throw "ConstructorInvocation(new StateError(No element))";
  Object* it = cppApply<Object*>(cppThis, String::cppNew("cppGet_iterator"));
  Object* result;
  while (
      CppApi::cppBoolValue(cppApply<Bool*>(it, String::cppNew("moveNext")))) {
    result = cppApply<Object*>(it, String::cppNew("cppGet_current"));
  }
  return ([&]() {
    Object* cppLet_0 = result;
    return CppApi::cppBoolValue(Bool::cppNew(cppLet_0 == nullptr))
               ? reinterpret_cast<Object*>(cppLet_0)
               : cppLet_0;
  })();
}

Object* CppIterable::cppGet_single(Object* cppThis) {
  if (CppApi::cppBoolValue(
          cppApply<Bool*>(cppThis, String::cppNew("cppGet_isEmpty"))))
    throw "ConstructorInvocation(new StateError(No element))";
  Object* it = cppApply<Object*>(cppThis, String::cppNew("cppGet_iterator"));
  cppApply<Bool*>(it, String::cppNew("moveNext"));
  Object* result = cppApply<Object*>(it, String::cppNew("cppGet_current"));
  if (CppApi::cppBoolValue(cppApply<Bool*>(it, String::cppNew("moveNext"))))
    throw "ConstructorInvocation(new StateError(Too many elements))";
  return result;
}

Object* CppIterable::elementAt(Object* cppThis, Int* index) {
  if (CppApi::cppBoolValue(Num::cpp_lessThan(index, Int::cppNew(0))))
    throw "ConstructorInvocation(new ArgumentError(Index cannot be negative))";
  Object* it = cppApply<Object*>(cppThis, String::cppNew("cppGet_iterator"));
  {
    Int* i = Int::cppNew(0);
    while (CppApi::cppBoolValue(Num::cpp_lessThanOrEqual(i, index))) {
      {
        if (CppApi::cppBoolValue(
                Bool::cpp_not(cppApply<Bool*>(it, String::cppNew("moveNext")))))
          throw "ConstructorInvocation(new IndexError(index, this))";
        if (CppApi::cppBoolValue(Object::cpp_equals(i, index)))
          return cppApply<Object*>(it, String::cppNew("cppGet_current"));
      }
      i = Num::cpp_add(i, Int::cppNew(1));
    }
  }
  throw "ConstructorInvocation(new IndexError(index, this))";
}

Bool* CppIterable::contains(Object* cppThis, Object* element) {
  Object* it = cppApply<Object*>(cppThis, String::cppNew("cppGet_iterator"));
  while (
      CppApi::cppBoolValue(cppApply<Bool*>(it, String::cppNew("moveNext")))) {
    if (CppApi::cppBoolValue(Object::cpp_equals(
            cppApply<Object*>(it, String::cppNew("cppGet_current")), element)))
      return Bool::cppNew(true);
  }
  return Bool::cppNew(false);
}

void CppIterable::forEach(Object* cppThis, Function* action) {
  Object* it = cppApply<Object*>(cppThis, String::cppNew("cppGet_iterator"));
  while (
      CppApi::cppBoolValue(cppApply<Bool*>(it, String::cppNew("moveNext")))) {
    cppApply<void>(action,
                   cppApply<Object*>(it, String::cppNew("cppGet_current")));
  }
}

Object* CppIterable::map(Object* cppThis, Function* toElement) {
  return CppMappedIterable::cppCtr_(CppMappedIterable::cppNew(), cppThis,
                                    toElement);
}

Object* CppIterable::where(Object* cppThis, Function* test) {
  return CppWhereIterable::cppCtr_(CppWhereIterable::cppNew(), cppThis, test);
}

Object* CppIterable::whereType(Object* cppThis) {
  return CppWhereTypeIterable::cppCtr_(CppWhereTypeIterable::cppNew(), cppThis);
}

Object* CppIterable::expand(Object* cppThis, Function* toElements) {
  return CppExpandIterable::cppCtr_(CppExpandIterable::cppNew(), cppThis,
                                    toElements);
}

Bool* CppIterable::any(Object* cppThis, Function* test) {
  Object* it = cppApply<Object*>(cppThis, String::cppNew("cppGet_iterator"));
  while (
      CppApi::cppBoolValue(cppApply<Bool*>(it, String::cppNew("moveNext")))) {
    if (CppApi::cppBoolValue(cppApply<Bool*>(
            test, cppApply<Object*>(it, String::cppNew("cppGet_current")))))
      return Bool::cppNew(true);
  }
  return Bool::cppNew(false);
}

Bool* CppIterable::every(Object* cppThis, Function* test) {
  Object* it = cppApply<Object*>(cppThis, String::cppNew("cppGet_iterator"));
  while (
      CppApi::cppBoolValue(cppApply<Bool*>(it, String::cppNew("moveNext")))) {
    if (CppApi::cppBoolValue(Bool::cpp_not(cppApply<Bool*>(
            test, cppApply<Object*>(it, String::cppNew("cppGet_current"))))))
      return Bool::cppNew(false);
  }
  return Bool::cppNew(true);
}

Object* CppIterable::firstWhere(Object* cppThis,
                                Function* test,
                                Function* orElse) {
  Object* it = cppApply<Object*>(cppThis, String::cppNew("cppGet_iterator"));
  while (
      CppApi::cppBoolValue(cppApply<Bool*>(it, String::cppNew("moveNext")))) {
    if (CppApi::cppBoolValue(cppApply<Bool*>(
            test, cppApply<Object*>(it, String::cppNew("cppGet_current")))))
      return cppApply<Object*>(it, String::cppNew("cppGet_current"));
  }
  if (CppApi::cppBoolValue(Bool::cpp_not(Bool::cppNew(orElse == nullptr))))
    return cppApply<Object*>(orElse);
  throw "ConstructorInvocation(new StateError(No element))";
}

Object* CppIterable::lastWhere(Object* cppThis,
                               Function* test,
                               Function* orElse) {
  Object* it = cppApply<Object*>(cppThis, String::cppNew("cppGet_iterator"));
  Object* result;
  Bool* found = Bool::cppNew(false);
  while (
      CppApi::cppBoolValue(cppApply<Bool*>(it, String::cppNew("moveNext")))) {
    if (CppApi::cppBoolValue(cppApply<Bool*>(
            test, cppApply<Object*>(it, String::cppNew("cppGet_current"))))) {
      result = cppApply<Object*>(it, String::cppNew("cppGet_current"));
      found = Bool::cppNew(true);
    }
  }
  if (CppApi::cppBoolValue(found))
    return ([&]() {
      Object* cppLet_0 = result;
      return CppApi::cppBoolValue(Bool::cppNew(cppLet_0 == nullptr))
                 ? reinterpret_cast<Object*>(cppLet_0)
                 : cppLet_0;
    })();
  if (CppApi::cppBoolValue(Bool::cpp_not(Bool::cppNew(orElse == nullptr))))
    return cppApply<Object*>(orElse);
  throw "ConstructorInvocation(new StateError(No element))";
}

Object* CppIterable::singleWhere(Object* cppThis,
                                 Function* test,
                                 Function* orElse) {
  Object* it = cppApply<Object*>(cppThis, String::cppNew("cppGet_iterator"));
  Object* result;
  Bool* found = Bool::cppNew(false);
  while (
      CppApi::cppBoolValue(cppApply<Bool*>(it, String::cppNew("moveNext")))) {
    if (CppApi::cppBoolValue(cppApply<Bool*>(
            test, cppApply<Object*>(it, String::cppNew("cppGet_current"))))) {
      if (CppApi::cppBoolValue(found))
        throw "ConstructorInvocation(new StateError(Too many elements))";
      result = cppApply<Object*>(it, String::cppNew("cppGet_current"));
      found = Bool::cppNew(true);
    }
  }
  if (CppApi::cppBoolValue(found))
    return ([&]() {
      Object* cppLet_0 = result;
      return CppApi::cppBoolValue(Bool::cppNew(cppLet_0 == nullptr))
                 ? reinterpret_cast<Object*>(cppLet_0)
                 : cppLet_0;
    })();
  if (CppApi::cppBoolValue(Bool::cpp_not(Bool::cppNew(orElse == nullptr))))
    return cppApply<Object*>(orElse);
  throw "ConstructorInvocation(new StateError(No element))";
}

Object* CppIterable::reduce(Object* cppThis, Function* combine) {
  Object* it = cppApply<Object*>(cppThis, String::cppNew("cppGet_iterator"));
  if (CppApi::cppBoolValue(
          Bool::cpp_not(cppApply<Bool*>(it, String::cppNew("moveNext")))))
    throw "ConstructorInvocation(new StateError(No element))";
  Object* value = cppApply<Object*>(it, String::cppNew("cppGet_current"));
  while (
      CppApi::cppBoolValue(cppApply<Bool*>(it, String::cppNew("moveNext")))) {
    value = cppApply<Object*>(
        combine, value,
        cppApply<Object*>(it, String::cppNew("cppGet_current")));
  }
  return value;
}

Object* CppIterable::fold(Object* cppThis,
                          Object* initialValue,
                          Function* combine) {
  Object* value = initialValue;
  Object* it = cppApply<Object*>(cppThis, String::cppNew("cppGet_iterator"));
  while (
      CppApi::cppBoolValue(cppApply<Bool*>(it, String::cppNew("moveNext")))) {
    value = cppApply<Object*>(
        combine, value,
        cppApply<Object*>(it, String::cppNew("cppGet_current")));
  }
  return value;
}

String* CppIterable::join(Object* cppThis, String* separator) {
  Object* it = cppApply<Object*>(cppThis, String::cppNew("cppGet_iterator"));
  if (CppApi::cppBoolValue(
          Bool::cpp_not(cppApply<Bool*>(it, String::cppNew("moveNext")))))
    return String::cppNew(new uint8_t[1]{0});
  Object* buffer = CppStringBuffer::cppCtr_(
      CppStringBuffer::cppNew(),
      cppApply<String*>(cppApply<Object*>(it, String::cppNew("cppGet_current")),
                        String::cppNew("toString")));
  while (
      CppApi::cppBoolValue(cppApply<Bool*>(it, String::cppNew("moveNext")))) {
    cppApply<void, Object*>(buffer, String::cppNew("write"), separator);
    cppApply<void, Object*>(
        buffer, String::cppNew("write"),
        cppApply<String*>(
            cppApply<Object*>(it, String::cppNew("cppGet_current")),
            String::cppNew("toString")));
  }
  return cppApply<String*>(buffer, String::cppNew("toString"));
}

Object* CppIterable::take(Object* cppThis, Int* count) {
  return CppTakeIterable::cppCtr_(CppTakeIterable::cppNew(), cppThis, count);
}

Object* CppIterable::takeWhile(Object* cppThis, Function* test) {
  return CppTakeWhileIterable::cppCtr_(CppTakeWhileIterable::cppNew(), cppThis,
                                       test);
}

Object* CppIterable::skip(Object* cppThis, Int* count) {
  return CppSkipIterable::cppCtr_(CppSkipIterable::cppNew(), cppThis, count);
}

Object* CppIterable::skipWhile(Object* cppThis, Function* test) {
  return CppSkipWhileIterable::cppCtr_(CppSkipWhileIterable::cppNew(), cppThis,
                                       test);
}

Object* CppIterable::cppGet_reversed(Object* cppThis) {
  return CppReversedIterable::cppCtr_(CppReversedIterable::cppNew(), cppThis);
}

Object* CppIterable::followedBy(Object* cppThis, Object* other) {
  return CppFollowedByIterable::cppCtr_(CppFollowedByIterable::cppNew(),
                                        cppThis, other);
}

Object* CppIterable::toList(Object* cppThis, Bool* growable) {
  return CppList::from(cppThis, growable);
}

Object* CppIterable::toSet(Object* cppThis) {
  return CppSet::from(cppThis);
}

Object* CppIterable::cast(Object* cppThis) {
  return CppCastIterable::cppCtr_(CppCastIterable::cppNew(), cppThis);
}

Object* CppIterable::empty() {
  return _CppEmptyIterable::cppCtr_(_CppEmptyIterable::cppNew());
}

Object* CppIterable::generate(Int* count, Function* generator) {
  return _CppGenerateIterable::cppCtr_(_CppGenerateIterable::cppNew(), count,
                                       generator);
}

Object* CppIterable::unmodifiable(Object* elements) {
  return _CppUnmodifiableIterable::cppCtr_(
      _CppUnmodifiableIterable::cppNew(),
      cppApply<Object*, Bool*>(elements, String::cppNew("toList"), nullptr));
}

Object* CppIterable::castFrom(Object* source) {
  return _CppCastFromIterable::cppCtr_(_CppCastFromIterable::cppNew(), source);
}

//  library package:dart2bytecode/demo/Iterable.dart
Object* CppMappedIterable::cppCtr_(Object* cppThis,
                                   Object* _source,
                                   Function* _f) {
  CppObjectSet<Object*>(cppThis, String::cppNew("_source"), _source);
  CppObjectSet<Function*>(cppThis, String::cppNew("_f"), _f);

  return cppThis;
}

Object* CppMappedIterable::cppGet_iterator(Object* cppThis) {
  return CppMappedIterator::cppCtr_(
      CppMappedIterator::cppNew(),
      cppApply<Object*>(
          CppObjectGet<Object*>(cppThis, String::cppNew("_source")),
          String::cppNew("cppGet_iterator")),
      CppObjectGet<Function*>(cppThis, String::cppNew("_f")));
}

Int* CppMappedIterable::cppGet_length(Object* cppThis) {
  return cppApply<Int*>(
      CppObjectGet<Object*>(cppThis, String::cppNew("_source")),
      String::cppNew("cppGet_length"));
}

Object* CppMappedIterable::cppNew() {
  static std::map<String*, void*> v_ptrs = {
      {String::cppNew("cpp_equals"),
       reinterpret_cast<void*>(&Object::cpp_equals)},
      {String::cppNew("cppGet_hashCode"),
       reinterpret_cast<void*>(&Object::cppGet_hashCode)},
      {String::cppNew("toString"), reinterpret_cast<void*>(&Object::toString)},
      {String::cppNew("noSuchMethod"),
       reinterpret_cast<void*>(&Object::noSuchMethod)},
      {String::cppNew("cppGet_runtimeType"),
       reinterpret_cast<void*>(&Object::cppGet_runtimeType)},
      {String::cppNew("cppGet_isEmpty"),
       reinterpret_cast<void*>(&CppIterable::cppGet_isEmpty)},
      {String::cppNew("cppGet_isNotEmpty"),
       reinterpret_cast<void*>(&CppIterable::cppGet_isNotEmpty)},
      {String::cppNew("cppGet_first"),
       reinterpret_cast<void*>(&CppIterable::cppGet_first)},
      {String::cppNew("cppGet_last"),
       reinterpret_cast<void*>(&CppIterable::cppGet_last)},
      {String::cppNew("cppGet_single"),
       reinterpret_cast<void*>(&CppIterable::cppGet_single)},
      {String::cppNew("elementAt"),
       reinterpret_cast<void*>(&CppIterable::elementAt)},
      {String::cppNew("contains"),
       reinterpret_cast<void*>(&CppIterable::contains)},
      {String::cppNew("forEach"),
       reinterpret_cast<void*>(&CppIterable::forEach)},
      {String::cppNew("map"), reinterpret_cast<void*>(&CppIterable::map)},
      {String::cppNew("where"), reinterpret_cast<void*>(&CppIterable::where)},
      {String::cppNew("whereType"),
       reinterpret_cast<void*>(&CppIterable::whereType)},
      {String::cppNew("expand"), reinterpret_cast<void*>(&CppIterable::expand)},
      {String::cppNew("any"), reinterpret_cast<void*>(&CppIterable::any)},
      {String::cppNew("every"), reinterpret_cast<void*>(&CppIterable::every)},
      {String::cppNew("firstWhere"),
       reinterpret_cast<void*>(&CppIterable::firstWhere)},
      {String::cppNew("lastWhere"),
       reinterpret_cast<void*>(&CppIterable::lastWhere)},
      {String::cppNew("singleWhere"),
       reinterpret_cast<void*>(&CppIterable::singleWhere)},
      {String::cppNew("reduce"), reinterpret_cast<void*>(&CppIterable::reduce)},
      {String::cppNew("fold"), reinterpret_cast<void*>(&CppIterable::fold)},
      {String::cppNew("join"), reinterpret_cast<void*>(&CppIterable::join)},
      {String::cppNew("take"), reinterpret_cast<void*>(&CppIterable::take)},
      {String::cppNew("takeWhile"),
       reinterpret_cast<void*>(&CppIterable::takeWhile)},
      {String::cppNew("skip"), reinterpret_cast<void*>(&CppIterable::skip)},
      {String::cppNew("skipWhile"),
       reinterpret_cast<void*>(&CppIterable::skipWhile)},
      {String::cppNew("cppGet_reversed"),
       reinterpret_cast<void*>(&CppIterable::cppGet_reversed)},
      {String::cppNew("followedBy"),
       reinterpret_cast<void*>(&CppIterable::followedBy)},
      {String::cppNew("toList"), reinterpret_cast<void*>(&CppIterable::toList)},
      {String::cppNew("toSet"), reinterpret_cast<void*>(&CppIterable::toSet)},
      {String::cppNew("cast"), reinterpret_cast<void*>(&CppIterable::cast)},
      {String::cppNew("cppGet_iterator"),
       reinterpret_cast<void*>(&CppMappedIterable::cppGet_iterator)},
      {String::cppNew("cppGet_length"),
       reinterpret_cast<void*>(&CppMappedIterable::cppGet_length)}};
  static Type* runtimeType = new Type("CppMappedIterable");
  Object* ptr = new ObjectImp(const_cast<Type*>(runtimeType), &v_ptrs);
  return ptr;
}

//  library package:dart2bytecode/demo/Iterable.dart
Object* CppMappedIterator::cppCtr_(Object* cppThis,
                                   Object* _iterator,
                                   Function* _f) {
  CppObjectSet<Object*>(cppThis, String::cppNew("_iterator"), _iterator);
  CppObjectSet<Function*>(cppThis, String::cppNew("_f"), _f);

  return cppThis;
}

Object* CppMappedIterator::cppGet_current(Object* cppThis) {
  return ([&]() {
    Object* cppLet_0 =
        CppObjectGet<Object*>(cppThis, String::cppNew("_current"));
    return CppApi::cppBoolValue(Bool::cppNew(cppLet_0 == nullptr))
               ? reinterpret_cast<Object*>(cppLet_0)
               : cppLet_0;
  })();
}

Bool* CppMappedIterator::moveNext(Object* cppThis) {
  if (CppApi::cppBoolValue(cppApply<Bool*>(
          CppObjectGet<Object*>(cppThis, String::cppNew("_iterator")),
          String::cppNew("moveNext")))) {
    CppObjectSet<Object*>(
        cppThis, String::cppNew("_current"), ([&]() {
          Object* cppLet_0 = cppApply<Object*>(
              CppObjectGet<Object*>(cppThis, String::cppNew("_iterator")),
              String::cppNew("cppGet_current"));
          return cppApply<Object*>(
              CppObjectGet<Function*>(cppThis, String::cppNew("_f")), cppLet_0);
        })());
    return Bool::cppNew(true);
  }
  return Bool::cppNew(false);
}

Object* CppMappedIterator::cppNew() {
  static std::map<String*, void*> v_ptrs = {
      {String::cppNew("cpp_equals"),
       reinterpret_cast<void*>(&Object::cpp_equals)},
      {String::cppNew("cppGet_hashCode"),
       reinterpret_cast<void*>(&Object::cppGet_hashCode)},
      {String::cppNew("toString"), reinterpret_cast<void*>(&Object::toString)},
      {String::cppNew("noSuchMethod"),
       reinterpret_cast<void*>(&Object::noSuchMethod)},
      {String::cppNew("cppGet_runtimeType"),
       reinterpret_cast<void*>(&Object::cppGet_runtimeType)},
      {String::cppNew("moveNext"),
       reinterpret_cast<void*>(&CppMappedIterator::moveNext)},
      {String::cppNew("cppGet_current"),
       reinterpret_cast<void*>(&CppMappedIterator::cppGet_current)}};
  static Type* runtimeType = new Type("CppMappedIterator");
  Object* ptr = new ObjectImp(const_cast<Type*>(runtimeType), &v_ptrs);
  return ptr;
}

//  library package:dart2bytecode/demo/Iterable.dart
Object* CppWhereIterable::cppCtr_(Object* cppThis,
                                  Object* _source,
                                  Function* _test) {
  CppObjectSet<Object*>(cppThis, String::cppNew("_source"), _source);
  CppObjectSet<Function*>(cppThis, String::cppNew("_test"), _test);

  return cppThis;
}

Object* CppWhereIterable::cppGet_iterator(Object* cppThis) {
  return CppWhereIterator::cppCtr_(
      CppWhereIterator::cppNew(),
      cppApply<Object*>(
          CppObjectGet<Object*>(cppThis, String::cppNew("_source")),
          String::cppNew("cppGet_iterator")),
      CppObjectGet<Function*>(cppThis, String::cppNew("_test")));
}

Int* CppWhereIterable::cppGet_length(Object* cppThis) {
  Int* count = Int::cppNew(0);
  Object* it = cppApply<Object*>(cppThis, String::cppNew("cppGet_iterator"));
  while (
      CppApi::cppBoolValue(cppApply<Bool*>(it, String::cppNew("moveNext")))) {
    count = Num::cpp_add(count, Int::cppNew(1));
  }
  return count;
}

Object* CppWhereIterable::cppNew() {
  static std::map<String*, void*> v_ptrs = {
      {String::cppNew("cpp_equals"),
       reinterpret_cast<void*>(&Object::cpp_equals)},
      {String::cppNew("cppGet_hashCode"),
       reinterpret_cast<void*>(&Object::cppGet_hashCode)},
      {String::cppNew("toString"), reinterpret_cast<void*>(&Object::toString)},
      {String::cppNew("noSuchMethod"),
       reinterpret_cast<void*>(&Object::noSuchMethod)},
      {String::cppNew("cppGet_runtimeType"),
       reinterpret_cast<void*>(&Object::cppGet_runtimeType)},
      {String::cppNew("cppGet_isEmpty"),
       reinterpret_cast<void*>(&CppIterable::cppGet_isEmpty)},
      {String::cppNew("cppGet_isNotEmpty"),
       reinterpret_cast<void*>(&CppIterable::cppGet_isNotEmpty)},
      {String::cppNew("cppGet_first"),
       reinterpret_cast<void*>(&CppIterable::cppGet_first)},
      {String::cppNew("cppGet_last"),
       reinterpret_cast<void*>(&CppIterable::cppGet_last)},
      {String::cppNew("cppGet_single"),
       reinterpret_cast<void*>(&CppIterable::cppGet_single)},
      {String::cppNew("elementAt"),
       reinterpret_cast<void*>(&CppIterable::elementAt)},
      {String::cppNew("contains"),
       reinterpret_cast<void*>(&CppIterable::contains)},
      {String::cppNew("forEach"),
       reinterpret_cast<void*>(&CppIterable::forEach)},
      {String::cppNew("map"), reinterpret_cast<void*>(&CppIterable::map)},
      {String::cppNew("where"), reinterpret_cast<void*>(&CppIterable::where)},
      {String::cppNew("whereType"),
       reinterpret_cast<void*>(&CppIterable::whereType)},
      {String::cppNew("expand"), reinterpret_cast<void*>(&CppIterable::expand)},
      {String::cppNew("any"), reinterpret_cast<void*>(&CppIterable::any)},
      {String::cppNew("every"), reinterpret_cast<void*>(&CppIterable::every)},
      {String::cppNew("firstWhere"),
       reinterpret_cast<void*>(&CppIterable::firstWhere)},
      {String::cppNew("lastWhere"),
       reinterpret_cast<void*>(&CppIterable::lastWhere)},
      {String::cppNew("singleWhere"),
       reinterpret_cast<void*>(&CppIterable::singleWhere)},
      {String::cppNew("reduce"), reinterpret_cast<void*>(&CppIterable::reduce)},
      {String::cppNew("fold"), reinterpret_cast<void*>(&CppIterable::fold)},
      {String::cppNew("join"), reinterpret_cast<void*>(&CppIterable::join)},
      {String::cppNew("take"), reinterpret_cast<void*>(&CppIterable::take)},
      {String::cppNew("takeWhile"),
       reinterpret_cast<void*>(&CppIterable::takeWhile)},
      {String::cppNew("skip"), reinterpret_cast<void*>(&CppIterable::skip)},
      {String::cppNew("skipWhile"),
       reinterpret_cast<void*>(&CppIterable::skipWhile)},
      {String::cppNew("cppGet_reversed"),
       reinterpret_cast<void*>(&CppIterable::cppGet_reversed)},
      {String::cppNew("followedBy"),
       reinterpret_cast<void*>(&CppIterable::followedBy)},
      {String::cppNew("toList"), reinterpret_cast<void*>(&CppIterable::toList)},
      {String::cppNew("toSet"), reinterpret_cast<void*>(&CppIterable::toSet)},
      {String::cppNew("cast"), reinterpret_cast<void*>(&CppIterable::cast)},
      {String::cppNew("cppGet_iterator"),
       reinterpret_cast<void*>(&CppWhereIterable::cppGet_iterator)},
      {String::cppNew("cppGet_length"),
       reinterpret_cast<void*>(&CppWhereIterable::cppGet_length)}};
  static Type* runtimeType = new Type("CppWhereIterable");
  Object* ptr = new ObjectImp(const_cast<Type*>(runtimeType), &v_ptrs);
  return ptr;
}

//  library package:dart2bytecode/demo/Iterable.dart
Object* CppWhereIterator::cppCtr_(Object* cppThis,
                                  Object* _iterator,
                                  Function* _test) {
  CppObjectSet<Object*>(cppThis, String::cppNew("_iterator"), _iterator);
  CppObjectSet<Function*>(cppThis, String::cppNew("_test"), _test);

  return cppThis;
}

Object* CppWhereIterator::cppGet_current(Object* cppThis) {
  return cppApply<Object*>(
      CppObjectGet<Object*>(cppThis, String::cppNew("_iterator")),
      String::cppNew("cppGet_current"));
}

Bool* CppWhereIterator::moveNext(Object* cppThis) {
  while (CppApi::cppBoolValue(cppApply<Bool*>(
      CppObjectGet<Object*>(cppThis, String::cppNew("_iterator")),
      String::cppNew("moveNext")))) {
    if (CppApi::cppBoolValue(([&]() {
          Object* cppLet_0 = cppApply<Object*>(
              CppObjectGet<Object*>(cppThis, String::cppNew("_iterator")),
              String::cppNew("cppGet_current"));
          return cppApply<Bool*>(
              CppObjectGet<Function*>(cppThis, String::cppNew("_test")),
              cppLet_0);
        })())) {
      return Bool::cppNew(true);
    }
  }
  return Bool::cppNew(false);
}

Object* CppWhereIterator::cppNew() {
  static std::map<String*, void*> v_ptrs = {
      {String::cppNew("cpp_equals"),
       reinterpret_cast<void*>(&Object::cpp_equals)},
      {String::cppNew("cppGet_hashCode"),
       reinterpret_cast<void*>(&Object::cppGet_hashCode)},
      {String::cppNew("toString"), reinterpret_cast<void*>(&Object::toString)},
      {String::cppNew("noSuchMethod"),
       reinterpret_cast<void*>(&Object::noSuchMethod)},
      {String::cppNew("cppGet_runtimeType"),
       reinterpret_cast<void*>(&Object::cppGet_runtimeType)},
      {String::cppNew("moveNext"),
       reinterpret_cast<void*>(&CppWhereIterator::moveNext)},
      {String::cppNew("cppGet_current"),
       reinterpret_cast<void*>(&CppWhereIterator::cppGet_current)}};
  static Type* runtimeType = new Type("CppWhereIterator");
  Object* ptr = new ObjectImp(const_cast<Type*>(runtimeType), &v_ptrs);
  return ptr;
}

//  library package:dart2bytecode/demo/Iterable.dart
Object* CppWhereTypeIterable::cppCtr_(Object* cppThis, Object* _source) {
  CppObjectSet<Object*>(cppThis, String::cppNew("_source"), _source);

  return cppThis;
}

Object* CppWhereTypeIterable::cppGet_iterator(Object* cppThis) {
  return CppWhereTypeIterator::cppCtr_(
      CppWhereTypeIterator::cppNew(),
      cppApply<Object*>(
          CppObjectGet<Object*>(cppThis, String::cppNew("_source")),
          String::cppNew("cppGet_iterator")));
}

Int* CppWhereTypeIterable::cppGet_length(Object* cppThis) {
  Int* count = Int::cppNew(0);
  Object* it = cppApply<Object*>(cppThis, String::cppNew("cppGet_iterator"));
  while (
      CppApi::cppBoolValue(cppApply<Bool*>(it, String::cppNew("moveNext")))) {
    count = Num::cpp_add(count, Int::cppNew(1));
  }
  return count;
}

Object* CppWhereTypeIterable::cppNew() {
  static std::map<String*, void*> v_ptrs = {
      {String::cppNew("cpp_equals"),
       reinterpret_cast<void*>(&Object::cpp_equals)},
      {String::cppNew("cppGet_hashCode"),
       reinterpret_cast<void*>(&Object::cppGet_hashCode)},
      {String::cppNew("toString"), reinterpret_cast<void*>(&Object::toString)},
      {String::cppNew("noSuchMethod"),
       reinterpret_cast<void*>(&Object::noSuchMethod)},
      {String::cppNew("cppGet_runtimeType"),
       reinterpret_cast<void*>(&Object::cppGet_runtimeType)},
      {String::cppNew("cppGet_isEmpty"),
       reinterpret_cast<void*>(&CppIterable::cppGet_isEmpty)},
      {String::cppNew("cppGet_isNotEmpty"),
       reinterpret_cast<void*>(&CppIterable::cppGet_isNotEmpty)},
      {String::cppNew("cppGet_first"),
       reinterpret_cast<void*>(&CppIterable::cppGet_first)},
      {String::cppNew("cppGet_last"),
       reinterpret_cast<void*>(&CppIterable::cppGet_last)},
      {String::cppNew("cppGet_single"),
       reinterpret_cast<void*>(&CppIterable::cppGet_single)},
      {String::cppNew("elementAt"),
       reinterpret_cast<void*>(&CppIterable::elementAt)},
      {String::cppNew("contains"),
       reinterpret_cast<void*>(&CppIterable::contains)},
      {String::cppNew("forEach"),
       reinterpret_cast<void*>(&CppIterable::forEach)},
      {String::cppNew("map"), reinterpret_cast<void*>(&CppIterable::map)},
      {String::cppNew("where"), reinterpret_cast<void*>(&CppIterable::where)},
      {String::cppNew("whereType"),
       reinterpret_cast<void*>(&CppIterable::whereType)},
      {String::cppNew("expand"), reinterpret_cast<void*>(&CppIterable::expand)},
      {String::cppNew("any"), reinterpret_cast<void*>(&CppIterable::any)},
      {String::cppNew("every"), reinterpret_cast<void*>(&CppIterable::every)},
      {String::cppNew("firstWhere"),
       reinterpret_cast<void*>(&CppIterable::firstWhere)},
      {String::cppNew("lastWhere"),
       reinterpret_cast<void*>(&CppIterable::lastWhere)},
      {String::cppNew("singleWhere"),
       reinterpret_cast<void*>(&CppIterable::singleWhere)},
      {String::cppNew("reduce"), reinterpret_cast<void*>(&CppIterable::reduce)},
      {String::cppNew("fold"), reinterpret_cast<void*>(&CppIterable::fold)},
      {String::cppNew("join"), reinterpret_cast<void*>(&CppIterable::join)},
      {String::cppNew("take"), reinterpret_cast<void*>(&CppIterable::take)},
      {String::cppNew("takeWhile"),
       reinterpret_cast<void*>(&CppIterable::takeWhile)},
      {String::cppNew("skip"), reinterpret_cast<void*>(&CppIterable::skip)},
      {String::cppNew("skipWhile"),
       reinterpret_cast<void*>(&CppIterable::skipWhile)},
      {String::cppNew("cppGet_reversed"),
       reinterpret_cast<void*>(&CppIterable::cppGet_reversed)},
      {String::cppNew("followedBy"),
       reinterpret_cast<void*>(&CppIterable::followedBy)},
      {String::cppNew("toList"), reinterpret_cast<void*>(&CppIterable::toList)},
      {String::cppNew("toSet"), reinterpret_cast<void*>(&CppIterable::toSet)},
      {String::cppNew("cast"), reinterpret_cast<void*>(&CppIterable::cast)},
      {String::cppNew("cppGet_iterator"),
       reinterpret_cast<void*>(&CppWhereTypeIterable::cppGet_iterator)},
      {String::cppNew("cppGet_length"),
       reinterpret_cast<void*>(&CppWhereTypeIterable::cppGet_length)}};
  static Type* runtimeType = new Type("CppWhereTypeIterable");
  Object* ptr = new ObjectImp(const_cast<Type*>(runtimeType), &v_ptrs);
  return ptr;
}

//  library package:dart2bytecode/demo/Iterable.dart
Object* CppWhereTypeIterator::cppCtr_(Object* cppThis, Object* _iterator) {
  CppObjectSet<Object*>(cppThis, String::cppNew("_iterator"), _iterator);

  return cppThis;
}

Object* CppWhereTypeIterator::cppGet_current(Object* cppThis) {
  return reinterpret_cast<Object*>(cppApply<Object*>(
      CppObjectGet<Object*>(cppThis, String::cppNew("_iterator")),
      String::cppNew("cppGet_current")));
}

Bool* CppWhereTypeIterator::moveNext(Object* cppThis) {
  while (CppApi::cppBoolValue(cppApply<Bool*>(
      CppObjectGet<Object*>(cppThis, String::cppNew("_iterator")),
      String::cppNew("moveNext")))) {
    if (CppApi::cppBoolValue(Bool::cppNew(
            reinterpret_cast<Object*>(cppApply<Object*>(
                CppObjectGet<Object*>(cppThis, String::cppNew("_iterator")),
                String::cppNew("cppGet_current"))) == nullptr))) {
      return Bool::cppNew(true);
    }
  }
  return Bool::cppNew(false);
}

Object* CppWhereTypeIterator::cppNew() {
  static std::map<String*, void*> v_ptrs = {
      {String::cppNew("cpp_equals"),
       reinterpret_cast<void*>(&Object::cpp_equals)},
      {String::cppNew("cppGet_hashCode"),
       reinterpret_cast<void*>(&Object::cppGet_hashCode)},
      {String::cppNew("toString"), reinterpret_cast<void*>(&Object::toString)},
      {String::cppNew("noSuchMethod"),
       reinterpret_cast<void*>(&Object::noSuchMethod)},
      {String::cppNew("cppGet_runtimeType"),
       reinterpret_cast<void*>(&Object::cppGet_runtimeType)},
      {String::cppNew("moveNext"),
       reinterpret_cast<void*>(&CppWhereTypeIterator::moveNext)},
      {String::cppNew("cppGet_current"),
       reinterpret_cast<void*>(&CppWhereTypeIterator::cppGet_current)}};
  static Type* runtimeType = new Type("CppWhereTypeIterator");
  Object* ptr = new ObjectImp(const_cast<Type*>(runtimeType), &v_ptrs);
  return ptr;
}

//  library package:dart2bytecode/demo/Iterable.dart
Object* CppExpandIterable::cppCtr_(Object* cppThis,
                                   Object* _source,
                                   Function* _f) {
  CppObjectSet<Object*>(cppThis, String::cppNew("_source"), _source);
  CppObjectSet<Function*>(cppThis, String::cppNew("_f"), _f);

  return cppThis;
}

Object* CppExpandIterable::cppGet_iterator(Object* cppThis) {
  return CppExpandIterator::cppCtr_(
      CppExpandIterator::cppNew(),
      cppApply<Object*>(
          CppObjectGet<Object*>(cppThis, String::cppNew("_source")),
          String::cppNew("cppGet_iterator")),
      CppObjectGet<Function*>(cppThis, String::cppNew("_f")));
}

Int* CppExpandIterable::cppGet_length(Object* cppThis) {
  Int* count = Int::cppNew(0);
  Object* it = cppApply<Object*>(cppThis, String::cppNew("cppGet_iterator"));
  while (
      CppApi::cppBoolValue(cppApply<Bool*>(it, String::cppNew("moveNext")))) {
    count = Num::cpp_add(count, Int::cppNew(1));
  }
  return count;
}

Object* CppExpandIterable::cppNew() {
  static std::map<String*, void*> v_ptrs = {
      {String::cppNew("cpp_equals"),
       reinterpret_cast<void*>(&Object::cpp_equals)},
      {String::cppNew("cppGet_hashCode"),
       reinterpret_cast<void*>(&Object::cppGet_hashCode)},
      {String::cppNew("toString"), reinterpret_cast<void*>(&Object::toString)},
      {String::cppNew("noSuchMethod"),
       reinterpret_cast<void*>(&Object::noSuchMethod)},
      {String::cppNew("cppGet_runtimeType"),
       reinterpret_cast<void*>(&Object::cppGet_runtimeType)},
      {String::cppNew("cppGet_isEmpty"),
       reinterpret_cast<void*>(&CppIterable::cppGet_isEmpty)},
      {String::cppNew("cppGet_isNotEmpty"),
       reinterpret_cast<void*>(&CppIterable::cppGet_isNotEmpty)},
      {String::cppNew("cppGet_first"),
       reinterpret_cast<void*>(&CppIterable::cppGet_first)},
      {String::cppNew("cppGet_last"),
       reinterpret_cast<void*>(&CppIterable::cppGet_last)},
      {String::cppNew("cppGet_single"),
       reinterpret_cast<void*>(&CppIterable::cppGet_single)},
      {String::cppNew("elementAt"),
       reinterpret_cast<void*>(&CppIterable::elementAt)},
      {String::cppNew("contains"),
       reinterpret_cast<void*>(&CppIterable::contains)},
      {String::cppNew("forEach"),
       reinterpret_cast<void*>(&CppIterable::forEach)},
      {String::cppNew("map"), reinterpret_cast<void*>(&CppIterable::map)},
      {String::cppNew("where"), reinterpret_cast<void*>(&CppIterable::where)},
      {String::cppNew("whereType"),
       reinterpret_cast<void*>(&CppIterable::whereType)},
      {String::cppNew("expand"), reinterpret_cast<void*>(&CppIterable::expand)},
      {String::cppNew("any"), reinterpret_cast<void*>(&CppIterable::any)},
      {String::cppNew("every"), reinterpret_cast<void*>(&CppIterable::every)},
      {String::cppNew("firstWhere"),
       reinterpret_cast<void*>(&CppIterable::firstWhere)},
      {String::cppNew("lastWhere"),
       reinterpret_cast<void*>(&CppIterable::lastWhere)},
      {String::cppNew("singleWhere"),
       reinterpret_cast<void*>(&CppIterable::singleWhere)},
      {String::cppNew("reduce"), reinterpret_cast<void*>(&CppIterable::reduce)},
      {String::cppNew("fold"), reinterpret_cast<void*>(&CppIterable::fold)},
      {String::cppNew("join"), reinterpret_cast<void*>(&CppIterable::join)},
      {String::cppNew("take"), reinterpret_cast<void*>(&CppIterable::take)},
      {String::cppNew("takeWhile"),
       reinterpret_cast<void*>(&CppIterable::takeWhile)},
      {String::cppNew("skip"), reinterpret_cast<void*>(&CppIterable::skip)},
      {String::cppNew("skipWhile"),
       reinterpret_cast<void*>(&CppIterable::skipWhile)},
      {String::cppNew("cppGet_reversed"),
       reinterpret_cast<void*>(&CppIterable::cppGet_reversed)},
      {String::cppNew("followedBy"),
       reinterpret_cast<void*>(&CppIterable::followedBy)},
      {String::cppNew("toList"), reinterpret_cast<void*>(&CppIterable::toList)},
      {String::cppNew("toSet"), reinterpret_cast<void*>(&CppIterable::toSet)},
      {String::cppNew("cast"), reinterpret_cast<void*>(&CppIterable::cast)},
      {String::cppNew("cppGet_iterator"),
       reinterpret_cast<void*>(&CppExpandIterable::cppGet_iterator)},
      {String::cppNew("cppGet_length"),
       reinterpret_cast<void*>(&CppExpandIterable::cppGet_length)}};
  static Type* runtimeType = new Type("CppExpandIterable");
  Object* ptr = new ObjectImp(const_cast<Type*>(runtimeType), &v_ptrs);
  return ptr;
}

//  library package:dart2bytecode/demo/Iterable.dart
Object* CppExpandIterator::cppCtr_(Object* cppThis,
                                   Object* _iterator,
                                   Function* _f) {
  CppObjectSet<Object*>(cppThis, String::cppNew("_iterator"), _iterator);
  CppObjectSet<Function*>(cppThis, String::cppNew("_f"), _f);

  return cppThis;
}

Object* CppExpandIterator::cppGet_current(Object* cppThis) {
  return cppApply<Object*>(
      CppObjectGet<Object*>(cppThis, String::cppNew("_currentIterator")),
      String::cppNew("cppGet_current"));
}

Bool* CppExpandIterator::moveNext(Object* cppThis) {
  while (CppApi::cppBoolValue(Bool::cppNew(true))) {
    if (CppApi::cppBoolValue(
            CppApi::cppBoolValue(Bool::cpp_not(
                Bool::cppNew(CppObjectGet<Object*>(
                                 cppThis, String::cppNew("_currentIterator")) ==
                             nullptr))) &&
            CppApi::cppBoolValue(cppApply<Bool*>(
                CppObjectGet<Object*>(cppThis,
                                      String::cppNew("_currentIterator")),
                String::cppNew("moveNext"))))) {
      return Bool::cppNew(true);
    }
    if (CppApi::cppBoolValue(Bool::cpp_not(cppApply<Bool*>(
            CppObjectGet<Object*>(cppThis, String::cppNew("_iterator")),
            String::cppNew("moveNext"))))) {
      return Bool::cppNew(false);
    }
    CppObjectSet<Object*>(
        cppThis, String::cppNew("_currentIterator"),
        cppApply<Object*>(
            ([&]() {
              Object* cppLet_0 = cppApply<Object*>(
                  CppObjectGet<Object*>(cppThis, String::cppNew("_iterator")),
                  String::cppNew("cppGet_current"));
              return cppApply<Object*>(
                  CppObjectGet<Function*>(cppThis, String::cppNew("_f")),
                  cppLet_0);
            })(),
            String::cppNew("cppGet_iterator")));
  }
}

Object* CppExpandIterator::cppNew() {
  static std::map<String*, void*> v_ptrs = {
      {String::cppNew("cpp_equals"),
       reinterpret_cast<void*>(&Object::cpp_equals)},
      {String::cppNew("cppGet_hashCode"),
       reinterpret_cast<void*>(&Object::cppGet_hashCode)},
      {String::cppNew("toString"), reinterpret_cast<void*>(&Object::toString)},
      {String::cppNew("noSuchMethod"),
       reinterpret_cast<void*>(&Object::noSuchMethod)},
      {String::cppNew("cppGet_runtimeType"),
       reinterpret_cast<void*>(&Object::cppGet_runtimeType)},
      {String::cppNew("moveNext"),
       reinterpret_cast<void*>(&CppExpandIterator::moveNext)},
      {String::cppNew("cppGet_current"),
       reinterpret_cast<void*>(&CppExpandIterator::cppGet_current)}};
  static Type* runtimeType = new Type("CppExpandIterator");
  Object* ptr = new ObjectImp(const_cast<Type*>(runtimeType), &v_ptrs);
  return ptr;
}

//  library package:dart2bytecode/demo/Iterable.dart
Object* CppTakeIterable::cppCtr_(Object* cppThis,
                                 Object* _source,
                                 Int* _count) {
  CppObjectSet<Object*>(cppThis, String::cppNew("_source"), _source);
  CppObjectSet<Int*>(cppThis, String::cppNew("_count"), _count);

  return cppThis;
}

Object* CppTakeIterable::cppGet_iterator(Object* cppThis) {
  return CppTakeIterator::cppCtr_(
      CppTakeIterator::cppNew(),
      cppApply<Object*>(
          CppObjectGet<Object*>(cppThis, String::cppNew("_source")),
          String::cppNew("cppGet_iterator")),
      CppObjectGet<Int*>(cppThis, String::cppNew("_count")));
}

Int* CppTakeIterable::cppGet_length(Object* cppThis) {
  return min(
      CppObjectGet<Int*>(cppThis, String::cppNew("_count")),
      cppApply<Int*>(CppObjectGet<Object*>(cppThis, String::cppNew("_source")),
                     String::cppNew("cppGet_length")));
}

Object* CppTakeIterable::cppNew() {
  static std::map<String*, void*> v_ptrs = {
      {String::cppNew("cpp_equals"),
       reinterpret_cast<void*>(&Object::cpp_equals)},
      {String::cppNew("cppGet_hashCode"),
       reinterpret_cast<void*>(&Object::cppGet_hashCode)},
      {String::cppNew("toString"), reinterpret_cast<void*>(&Object::toString)},
      {String::cppNew("noSuchMethod"),
       reinterpret_cast<void*>(&Object::noSuchMethod)},
      {String::cppNew("cppGet_runtimeType"),
       reinterpret_cast<void*>(&Object::cppGet_runtimeType)},
      {String::cppNew("cppGet_isEmpty"),
       reinterpret_cast<void*>(&CppIterable::cppGet_isEmpty)},
      {String::cppNew("cppGet_isNotEmpty"),
       reinterpret_cast<void*>(&CppIterable::cppGet_isNotEmpty)},
      {String::cppNew("cppGet_first"),
       reinterpret_cast<void*>(&CppIterable::cppGet_first)},
      {String::cppNew("cppGet_last"),
       reinterpret_cast<void*>(&CppIterable::cppGet_last)},
      {String::cppNew("cppGet_single"),
       reinterpret_cast<void*>(&CppIterable::cppGet_single)},
      {String::cppNew("elementAt"),
       reinterpret_cast<void*>(&CppIterable::elementAt)},
      {String::cppNew("contains"),
       reinterpret_cast<void*>(&CppIterable::contains)},
      {String::cppNew("forEach"),
       reinterpret_cast<void*>(&CppIterable::forEach)},
      {String::cppNew("map"), reinterpret_cast<void*>(&CppIterable::map)},
      {String::cppNew("where"), reinterpret_cast<void*>(&CppIterable::where)},
      {String::cppNew("whereType"),
       reinterpret_cast<void*>(&CppIterable::whereType)},
      {String::cppNew("expand"), reinterpret_cast<void*>(&CppIterable::expand)},
      {String::cppNew("any"), reinterpret_cast<void*>(&CppIterable::any)},
      {String::cppNew("every"), reinterpret_cast<void*>(&CppIterable::every)},
      {String::cppNew("firstWhere"),
       reinterpret_cast<void*>(&CppIterable::firstWhere)},
      {String::cppNew("lastWhere"),
       reinterpret_cast<void*>(&CppIterable::lastWhere)},
      {String::cppNew("singleWhere"),
       reinterpret_cast<void*>(&CppIterable::singleWhere)},
      {String::cppNew("reduce"), reinterpret_cast<void*>(&CppIterable::reduce)},
      {String::cppNew("fold"), reinterpret_cast<void*>(&CppIterable::fold)},
      {String::cppNew("join"), reinterpret_cast<void*>(&CppIterable::join)},
      {String::cppNew("take"), reinterpret_cast<void*>(&CppIterable::take)},
      {String::cppNew("takeWhile"),
       reinterpret_cast<void*>(&CppIterable::takeWhile)},
      {String::cppNew("skip"), reinterpret_cast<void*>(&CppIterable::skip)},
      {String::cppNew("skipWhile"),
       reinterpret_cast<void*>(&CppIterable::skipWhile)},
      {String::cppNew("cppGet_reversed"),
       reinterpret_cast<void*>(&CppIterable::cppGet_reversed)},
      {String::cppNew("followedBy"),
       reinterpret_cast<void*>(&CppIterable::followedBy)},
      {String::cppNew("toList"), reinterpret_cast<void*>(&CppIterable::toList)},
      {String::cppNew("toSet"), reinterpret_cast<void*>(&CppIterable::toSet)},
      {String::cppNew("cast"), reinterpret_cast<void*>(&CppIterable::cast)},
      {String::cppNew("cppGet_iterator"),
       reinterpret_cast<void*>(&CppTakeIterable::cppGet_iterator)},
      {String::cppNew("cppGet_length"),
       reinterpret_cast<void*>(&CppTakeIterable::cppGet_length)}};
  static Type* runtimeType = new Type("CppTakeIterable");
  Object* ptr = new ObjectImp(const_cast<Type*>(runtimeType), &v_ptrs);
  return ptr;
}

//  library package:dart2bytecode/demo/Iterable.dart
Object* CppTakeIterator::cppCtr_(Object* cppThis,
                                 Object* _iterator,
                                 Int* _count) {
  CppObjectSet<Object*>(cppThis, String::cppNew("_iterator"), _iterator);
  CppObjectSet<Int*>(cppThis, String::cppNew("_count"), _count);
  CppObjectSet<Int*>(cppThis, String::cppNew("_remaining"), _count);

  return cppThis;
}

Object* CppTakeIterator::cppGet_current(Object* cppThis) {
  return cppApply<Object*>(
      CppObjectGet<Object*>(cppThis, String::cppNew("_iterator")),
      String::cppNew("cppGet_current"));
}

Bool* CppTakeIterator::moveNext(Object* cppThis) {
  if (CppApi::cppBoolValue(Num::cpp_lessThanOrEqual(
          CppObjectGet<Int*>(cppThis, String::cppNew("_remaining")),
          Int::cppNew(0))))
    return Bool::cppNew(false);
  if (CppApi::cppBoolValue(cppApply<Bool*>(
          CppObjectGet<Object*>(cppThis, String::cppNew("_iterator")),
          String::cppNew("moveNext")))) {
    CppObjectSet<Int*>(
        cppThis, String::cppNew("_remaining"),
        Num::cpp_subtract(
            CppObjectGet<Int*>(cppThis, String::cppNew("_remaining")),
            Int::cppNew(1)));
    return Bool::cppNew(true);
  }
  return Bool::cppNew(false);
}

Object* CppTakeIterator::cppNew() {
  static std::map<String*, void*> v_ptrs = {
      {String::cppNew("cpp_equals"),
       reinterpret_cast<void*>(&Object::cpp_equals)},
      {String::cppNew("cppGet_hashCode"),
       reinterpret_cast<void*>(&Object::cppGet_hashCode)},
      {String::cppNew("toString"), reinterpret_cast<void*>(&Object::toString)},
      {String::cppNew("noSuchMethod"),
       reinterpret_cast<void*>(&Object::noSuchMethod)},
      {String::cppNew("cppGet_runtimeType"),
       reinterpret_cast<void*>(&Object::cppGet_runtimeType)},
      {String::cppNew("moveNext"),
       reinterpret_cast<void*>(&CppTakeIterator::moveNext)},
      {String::cppNew("cppGet_current"),
       reinterpret_cast<void*>(&CppTakeIterator::cppGet_current)}};
  static Type* runtimeType = new Type("CppTakeIterator");
  Object* ptr = new ObjectImp(const_cast<Type*>(runtimeType), &v_ptrs);
  return ptr;
}

//  library package:dart2bytecode/demo/Iterable.dart
Object* CppTakeWhileIterable::cppCtr_(Object* cppThis,
                                      Object* _source,
                                      Function* _test) {
  CppObjectSet<Object*>(cppThis, String::cppNew("_source"), _source);
  CppObjectSet<Function*>(cppThis, String::cppNew("_test"), _test);

  return cppThis;
}

Object* CppTakeWhileIterable::cppGet_iterator(Object* cppThis) {
  return CppTakeWhileIterator::cppCtr_(
      CppTakeWhileIterator::cppNew(),
      cppApply<Object*>(
          CppObjectGet<Object*>(cppThis, String::cppNew("_source")),
          String::cppNew("cppGet_iterator")),
      CppObjectGet<Function*>(cppThis, String::cppNew("_test")));
}

Int* CppTakeWhileIterable::cppGet_length(Object* cppThis) {
  Int* count = Int::cppNew(0);
  Object* it = cppApply<Object*>(cppThis, String::cppNew("cppGet_iterator"));
  while (
      CppApi::cppBoolValue(cppApply<Bool*>(it, String::cppNew("moveNext")))) {
    count = Num::cpp_add(count, Int::cppNew(1));
  }
  return count;
}

Object* CppTakeWhileIterable::cppNew() {
  static std::map<String*, void*> v_ptrs = {
      {String::cppNew("cpp_equals"),
       reinterpret_cast<void*>(&Object::cpp_equals)},
      {String::cppNew("cppGet_hashCode"),
       reinterpret_cast<void*>(&Object::cppGet_hashCode)},
      {String::cppNew("toString"), reinterpret_cast<void*>(&Object::toString)},
      {String::cppNew("noSuchMethod"),
       reinterpret_cast<void*>(&Object::noSuchMethod)},
      {String::cppNew("cppGet_runtimeType"),
       reinterpret_cast<void*>(&Object::cppGet_runtimeType)},
      {String::cppNew("cppGet_isEmpty"),
       reinterpret_cast<void*>(&CppIterable::cppGet_isEmpty)},
      {String::cppNew("cppGet_isNotEmpty"),
       reinterpret_cast<void*>(&CppIterable::cppGet_isNotEmpty)},
      {String::cppNew("cppGet_first"),
       reinterpret_cast<void*>(&CppIterable::cppGet_first)},
      {String::cppNew("cppGet_last"),
       reinterpret_cast<void*>(&CppIterable::cppGet_last)},
      {String::cppNew("cppGet_single"),
       reinterpret_cast<void*>(&CppIterable::cppGet_single)},
      {String::cppNew("elementAt"),
       reinterpret_cast<void*>(&CppIterable::elementAt)},
      {String::cppNew("contains"),
       reinterpret_cast<void*>(&CppIterable::contains)},
      {String::cppNew("forEach"),
       reinterpret_cast<void*>(&CppIterable::forEach)},
      {String::cppNew("map"), reinterpret_cast<void*>(&CppIterable::map)},
      {String::cppNew("where"), reinterpret_cast<void*>(&CppIterable::where)},
      {String::cppNew("whereType"),
       reinterpret_cast<void*>(&CppIterable::whereType)},
      {String::cppNew("expand"), reinterpret_cast<void*>(&CppIterable::expand)},
      {String::cppNew("any"), reinterpret_cast<void*>(&CppIterable::any)},
      {String::cppNew("every"), reinterpret_cast<void*>(&CppIterable::every)},
      {String::cppNew("firstWhere"),
       reinterpret_cast<void*>(&CppIterable::firstWhere)},
      {String::cppNew("lastWhere"),
       reinterpret_cast<void*>(&CppIterable::lastWhere)},
      {String::cppNew("singleWhere"),
       reinterpret_cast<void*>(&CppIterable::singleWhere)},
      {String::cppNew("reduce"), reinterpret_cast<void*>(&CppIterable::reduce)},
      {String::cppNew("fold"), reinterpret_cast<void*>(&CppIterable::fold)},
      {String::cppNew("join"), reinterpret_cast<void*>(&CppIterable::join)},
      {String::cppNew("take"), reinterpret_cast<void*>(&CppIterable::take)},
      {String::cppNew("takeWhile"),
       reinterpret_cast<void*>(&CppIterable::takeWhile)},
      {String::cppNew("skip"), reinterpret_cast<void*>(&CppIterable::skip)},
      {String::cppNew("skipWhile"),
       reinterpret_cast<void*>(&CppIterable::skipWhile)},
      {String::cppNew("cppGet_reversed"),
       reinterpret_cast<void*>(&CppIterable::cppGet_reversed)},
      {String::cppNew("followedBy"),
       reinterpret_cast<void*>(&CppIterable::followedBy)},
      {String::cppNew("toList"), reinterpret_cast<void*>(&CppIterable::toList)},
      {String::cppNew("toSet"), reinterpret_cast<void*>(&CppIterable::toSet)},
      {String::cppNew("cast"), reinterpret_cast<void*>(&CppIterable::cast)},
      {String::cppNew("cppGet_iterator"),
       reinterpret_cast<void*>(&CppTakeWhileIterable::cppGet_iterator)},
      {String::cppNew("cppGet_length"),
       reinterpret_cast<void*>(&CppTakeWhileIterable::cppGet_length)}};
  static Type* runtimeType = new Type("CppTakeWhileIterable");
  Object* ptr = new ObjectImp(const_cast<Type*>(runtimeType), &v_ptrs);
  return ptr;
}

//  library package:dart2bytecode/demo/Iterable.dart
Object* CppTakeWhileIterator::cppCtr_(Object* cppThis,
                                      Object* _iterator,
                                      Function* _test) {
  CppObjectSet<Object*>(cppThis, String::cppNew("_iterator"), _iterator);
  CppObjectSet<Function*>(cppThis, String::cppNew("_test"), _test);

  return cppThis;
}

Object* CppTakeWhileIterator::cppGet_current(Object* cppThis) {
  return cppApply<Object*>(
      CppObjectGet<Object*>(cppThis, String::cppNew("_iterator")),
      String::cppNew("cppGet_current"));
}

Bool* CppTakeWhileIterator::moveNext(Object* cppThis) {
  if (CppApi::cppBoolValue(
          CppObjectGet<Bool*>(cppThis, String::cppNew("_finished"))))
    return Bool::cppNew(false);
  if (CppApi::cppBoolValue(cppApply<Bool*>(
          CppObjectGet<Object*>(cppThis, String::cppNew("_iterator")),
          String::cppNew("moveNext")))) {
    if (CppApi::cppBoolValue(([&]() {
          Object* cppLet_0 = cppApply<Object*>(
              CppObjectGet<Object*>(cppThis, String::cppNew("_iterator")),
              String::cppNew("cppGet_current"));
          return cppApply<Bool*>(
              CppObjectGet<Function*>(cppThis, String::cppNew("_test")),
              cppLet_0);
        })())) {
      return Bool::cppNew(true);
    }
    CppObjectSet<Object*>(cppThis, String::cppNew("_finished"),
                          Bool::cppNew(true));
  }
  return Bool::cppNew(false);
}

Object* CppTakeWhileIterator::cppNew() {
  static std::map<String*, void*> v_ptrs = {
      {String::cppNew("cpp_equals"),
       reinterpret_cast<void*>(&Object::cpp_equals)},
      {String::cppNew("cppGet_hashCode"),
       reinterpret_cast<void*>(&Object::cppGet_hashCode)},
      {String::cppNew("toString"), reinterpret_cast<void*>(&Object::toString)},
      {String::cppNew("noSuchMethod"),
       reinterpret_cast<void*>(&Object::noSuchMethod)},
      {String::cppNew("cppGet_runtimeType"),
       reinterpret_cast<void*>(&Object::cppGet_runtimeType)},
      {String::cppNew("moveNext"),
       reinterpret_cast<void*>(&CppTakeWhileIterator::moveNext)},
      {String::cppNew("cppGet_current"),
       reinterpret_cast<void*>(&CppTakeWhileIterator::cppGet_current)}};
  static Type* runtimeType = new Type("CppTakeWhileIterator");
  Object* ptr = new ObjectImp(const_cast<Type*>(runtimeType), &v_ptrs);
  return ptr;
}

//  library package:dart2bytecode/demo/Iterable.dart
Object* CppSkipIterable::cppCtr_(Object* cppThis,
                                 Object* _source,
                                 Int* _count) {
  CppObjectSet<Object*>(cppThis, String::cppNew("_source"), _source);
  CppObjectSet<Int*>(cppThis, String::cppNew("_count"), _count);

  return cppThis;
}

Object* CppSkipIterable::cppGet_iterator(Object* cppThis) {
  return CppSkipIterator::cppCtr_(
      CppSkipIterator::cppNew(),
      cppApply<Object*>(
          CppObjectGet<Object*>(cppThis, String::cppNew("_source")),
          String::cppNew("cppGet_iterator")),
      CppObjectGet<Int*>(cppThis, String::cppNew("_count")));
}

Int* CppSkipIterable::cppGet_length(Object* cppThis) {
  return max(
      Int::cppNew(0),
      Num::cpp_subtract(cppApply<Int*>(CppObjectGet<Object*>(
                                           cppThis, String::cppNew("_source")),
                                       String::cppNew("cppGet_length")),
                        CppObjectGet<Int*>(cppThis, String::cppNew("_count"))));
}

Object* CppSkipIterable::cppNew() {
  static std::map<String*, void*> v_ptrs = {
      {String::cppNew("cpp_equals"),
       reinterpret_cast<void*>(&Object::cpp_equals)},
      {String::cppNew("cppGet_hashCode"),
       reinterpret_cast<void*>(&Object::cppGet_hashCode)},
      {String::cppNew("toString"), reinterpret_cast<void*>(&Object::toString)},
      {String::cppNew("noSuchMethod"),
       reinterpret_cast<void*>(&Object::noSuchMethod)},
      {String::cppNew("cppGet_runtimeType"),
       reinterpret_cast<void*>(&Object::cppGet_runtimeType)},
      {String::cppNew("cppGet_isEmpty"),
       reinterpret_cast<void*>(&CppIterable::cppGet_isEmpty)},
      {String::cppNew("cppGet_isNotEmpty"),
       reinterpret_cast<void*>(&CppIterable::cppGet_isNotEmpty)},
      {String::cppNew("cppGet_first"),
       reinterpret_cast<void*>(&CppIterable::cppGet_first)},
      {String::cppNew("cppGet_last"),
       reinterpret_cast<void*>(&CppIterable::cppGet_last)},
      {String::cppNew("cppGet_single"),
       reinterpret_cast<void*>(&CppIterable::cppGet_single)},
      {String::cppNew("elementAt"),
       reinterpret_cast<void*>(&CppIterable::elementAt)},
      {String::cppNew("contains"),
       reinterpret_cast<void*>(&CppIterable::contains)},
      {String::cppNew("forEach"),
       reinterpret_cast<void*>(&CppIterable::forEach)},
      {String::cppNew("map"), reinterpret_cast<void*>(&CppIterable::map)},
      {String::cppNew("where"), reinterpret_cast<void*>(&CppIterable::where)},
      {String::cppNew("whereType"),
       reinterpret_cast<void*>(&CppIterable::whereType)},
      {String::cppNew("expand"), reinterpret_cast<void*>(&CppIterable::expand)},
      {String::cppNew("any"), reinterpret_cast<void*>(&CppIterable::any)},
      {String::cppNew("every"), reinterpret_cast<void*>(&CppIterable::every)},
      {String::cppNew("firstWhere"),
       reinterpret_cast<void*>(&CppIterable::firstWhere)},
      {String::cppNew("lastWhere"),
       reinterpret_cast<void*>(&CppIterable::lastWhere)},
      {String::cppNew("singleWhere"),
       reinterpret_cast<void*>(&CppIterable::singleWhere)},
      {String::cppNew("reduce"), reinterpret_cast<void*>(&CppIterable::reduce)},
      {String::cppNew("fold"), reinterpret_cast<void*>(&CppIterable::fold)},
      {String::cppNew("join"), reinterpret_cast<void*>(&CppIterable::join)},
      {String::cppNew("take"), reinterpret_cast<void*>(&CppIterable::take)},
      {String::cppNew("takeWhile"),
       reinterpret_cast<void*>(&CppIterable::takeWhile)},
      {String::cppNew("skip"), reinterpret_cast<void*>(&CppIterable::skip)},
      {String::cppNew("skipWhile"),
       reinterpret_cast<void*>(&CppIterable::skipWhile)},
      {String::cppNew("cppGet_reversed"),
       reinterpret_cast<void*>(&CppIterable::cppGet_reversed)},
      {String::cppNew("followedBy"),
       reinterpret_cast<void*>(&CppIterable::followedBy)},
      {String::cppNew("toList"), reinterpret_cast<void*>(&CppIterable::toList)},
      {String::cppNew("toSet"), reinterpret_cast<void*>(&CppIterable::toSet)},
      {String::cppNew("cast"), reinterpret_cast<void*>(&CppIterable::cast)},
      {String::cppNew("cppGet_iterator"),
       reinterpret_cast<void*>(&CppSkipIterable::cppGet_iterator)},
      {String::cppNew("cppGet_length"),
       reinterpret_cast<void*>(&CppSkipIterable::cppGet_length)}};
  static Type* runtimeType = new Type("CppSkipIterable");
  Object* ptr = new ObjectImp(const_cast<Type*>(runtimeType), &v_ptrs);
  return ptr;
}

//  library package:dart2bytecode/demo/Iterable.dart
Object* CppSkipIterator::cppCtr_(Object* cppThis,
                                 Object* _iterator,
                                 Int* _count) {
  CppObjectSet<Object*>(cppThis, String::cppNew("_iterator"), _iterator);
  CppObjectSet<Int*>(cppThis, String::cppNew("_count"), _count);

  return cppThis;
}

Object* CppSkipIterator::cppGet_current(Object* cppThis) {
  return cppApply<Object*>(
      CppObjectGet<Object*>(cppThis, String::cppNew("_iterator")),
      String::cppNew("cppGet_current"));
}

Bool* CppSkipIterator::moveNext(Object* cppThis) {
  if (CppApi::cppBoolValue(Bool::cpp_not(
          CppObjectGet<Bool*>(cppThis, String::cppNew("_skipped"))))) {
    {
      Int* i = Int::cppNew(0);
      while (CppApi::cppBoolValue(Num::cpp_lessThan(
          i, CppObjectGet<Int*>(cppThis, String::cppNew("_count"))))) {
        {
          if (CppApi::cppBoolValue(Bool::cpp_not(cppApply<Bool*>(
                  CppObjectGet<Object*>(cppThis, String::cppNew("_iterator")),
                  String::cppNew("moveNext")))))
            return Bool::cppNew(false);
        }
        i = Num::cpp_add(i, Int::cppNew(1));
      }
    }
    CppObjectSet<Object*>(cppThis, String::cppNew("_skipped"),
                          Bool::cppNew(true));
  }
  return cppApply<Bool*>(
      CppObjectGet<Object*>(cppThis, String::cppNew("_iterator")),
      String::cppNew("moveNext"));
}

Object* CppSkipIterator::cppNew() {
  static std::map<String*, void*> v_ptrs = {
      {String::cppNew("cpp_equals"),
       reinterpret_cast<void*>(&Object::cpp_equals)},
      {String::cppNew("cppGet_hashCode"),
       reinterpret_cast<void*>(&Object::cppGet_hashCode)},
      {String::cppNew("toString"), reinterpret_cast<void*>(&Object::toString)},
      {String::cppNew("noSuchMethod"),
       reinterpret_cast<void*>(&Object::noSuchMethod)},
      {String::cppNew("cppGet_runtimeType"),
       reinterpret_cast<void*>(&Object::cppGet_runtimeType)},
      {String::cppNew("moveNext"),
       reinterpret_cast<void*>(&CppSkipIterator::moveNext)},
      {String::cppNew("cppGet_current"),
       reinterpret_cast<void*>(&CppSkipIterator::cppGet_current)}};
  static Type* runtimeType = new Type("CppSkipIterator");
  Object* ptr = new ObjectImp(const_cast<Type*>(runtimeType), &v_ptrs);
  return ptr;
}

//  library package:dart2bytecode/demo/Iterable.dart
Object* CppSkipWhileIterable::cppCtr_(Object* cppThis,
                                      Object* _source,
                                      Function* _test) {
  CppObjectSet<Object*>(cppThis, String::cppNew("_source"), _source);
  CppObjectSet<Function*>(cppThis, String::cppNew("_test"), _test);

  return cppThis;
}

Object* CppSkipWhileIterable::cppGet_iterator(Object* cppThis) {
  return CppSkipWhileIterator::cppCtr_(
      CppSkipWhileIterator::cppNew(),
      cppApply<Object*>(
          CppObjectGet<Object*>(cppThis, String::cppNew("_source")),
          String::cppNew("cppGet_iterator")),
      CppObjectGet<Function*>(cppThis, String::cppNew("_test")));
}

Int* CppSkipWhileIterable::cppGet_length(Object* cppThis) {
  Int* count = Int::cppNew(0);
  Object* it = cppApply<Object*>(cppThis, String::cppNew("cppGet_iterator"));
  while (
      CppApi::cppBoolValue(cppApply<Bool*>(it, String::cppNew("moveNext")))) {
    count = Num::cpp_add(count, Int::cppNew(1));
  }
  return count;
}

Object* CppSkipWhileIterable::cppNew() {
  static std::map<String*, void*> v_ptrs = {
      {String::cppNew("cpp_equals"),
       reinterpret_cast<void*>(&Object::cpp_equals)},
      {String::cppNew("cppGet_hashCode"),
       reinterpret_cast<void*>(&Object::cppGet_hashCode)},
      {String::cppNew("toString"), reinterpret_cast<void*>(&Object::toString)},
      {String::cppNew("noSuchMethod"),
       reinterpret_cast<void*>(&Object::noSuchMethod)},
      {String::cppNew("cppGet_runtimeType"),
       reinterpret_cast<void*>(&Object::cppGet_runtimeType)},
      {String::cppNew("cppGet_isEmpty"),
       reinterpret_cast<void*>(&CppIterable::cppGet_isEmpty)},
      {String::cppNew("cppGet_isNotEmpty"),
       reinterpret_cast<void*>(&CppIterable::cppGet_isNotEmpty)},
      {String::cppNew("cppGet_first"),
       reinterpret_cast<void*>(&CppIterable::cppGet_first)},
      {String::cppNew("cppGet_last"),
       reinterpret_cast<void*>(&CppIterable::cppGet_last)},
      {String::cppNew("cppGet_single"),
       reinterpret_cast<void*>(&CppIterable::cppGet_single)},
      {String::cppNew("elementAt"),
       reinterpret_cast<void*>(&CppIterable::elementAt)},
      {String::cppNew("contains"),
       reinterpret_cast<void*>(&CppIterable::contains)},
      {String::cppNew("forEach"),
       reinterpret_cast<void*>(&CppIterable::forEach)},
      {String::cppNew("map"), reinterpret_cast<void*>(&CppIterable::map)},
      {String::cppNew("where"), reinterpret_cast<void*>(&CppIterable::where)},
      {String::cppNew("whereType"),
       reinterpret_cast<void*>(&CppIterable::whereType)},
      {String::cppNew("expand"), reinterpret_cast<void*>(&CppIterable::expand)},
      {String::cppNew("any"), reinterpret_cast<void*>(&CppIterable::any)},
      {String::cppNew("every"), reinterpret_cast<void*>(&CppIterable::every)},
      {String::cppNew("firstWhere"),
       reinterpret_cast<void*>(&CppIterable::firstWhere)},
      {String::cppNew("lastWhere"),
       reinterpret_cast<void*>(&CppIterable::lastWhere)},
      {String::cppNew("singleWhere"),
       reinterpret_cast<void*>(&CppIterable::singleWhere)},
      {String::cppNew("reduce"), reinterpret_cast<void*>(&CppIterable::reduce)},
      {String::cppNew("fold"), reinterpret_cast<void*>(&CppIterable::fold)},
      {String::cppNew("join"), reinterpret_cast<void*>(&CppIterable::join)},
      {String::cppNew("take"), reinterpret_cast<void*>(&CppIterable::take)},
      {String::cppNew("takeWhile"),
       reinterpret_cast<void*>(&CppIterable::takeWhile)},
      {String::cppNew("skip"), reinterpret_cast<void*>(&CppIterable::skip)},
      {String::cppNew("skipWhile"),
       reinterpret_cast<void*>(&CppIterable::skipWhile)},
      {String::cppNew("cppGet_reversed"),
       reinterpret_cast<void*>(&CppIterable::cppGet_reversed)},
      {String::cppNew("followedBy"),
       reinterpret_cast<void*>(&CppIterable::followedBy)},
      {String::cppNew("toList"), reinterpret_cast<void*>(&CppIterable::toList)},
      {String::cppNew("toSet"), reinterpret_cast<void*>(&CppIterable::toSet)},
      {String::cppNew("cast"), reinterpret_cast<void*>(&CppIterable::cast)},
      {String::cppNew("cppGet_iterator"),
       reinterpret_cast<void*>(&CppSkipWhileIterable::cppGet_iterator)},
      {String::cppNew("cppGet_length"),
       reinterpret_cast<void*>(&CppSkipWhileIterable::cppGet_length)}};
  static Type* runtimeType = new Type("CppSkipWhileIterable");
  Object* ptr = new ObjectImp(const_cast<Type*>(runtimeType), &v_ptrs);
  return ptr;
}

//  library package:dart2bytecode/demo/Iterable.dart
Object* CppSkipWhileIterator::cppCtr_(Object* cppThis,
                                      Object* _iterator,
                                      Function* _test) {
  CppObjectSet<Object*>(cppThis, String::cppNew("_iterator"), _iterator);
  CppObjectSet<Function*>(cppThis, String::cppNew("_test"), _test);

  return cppThis;
}

Object* CppSkipWhileIterator::cppGet_current(Object* cppThis) {
  return cppApply<Object*>(
      CppObjectGet<Object*>(cppThis, String::cppNew("_iterator")),
      String::cppNew("cppGet_current"));
}

Bool* CppSkipWhileIterator::moveNext(Object* cppThis) {
  if (CppApi::cppBoolValue(Bool::cpp_not(
          CppObjectGet<Bool*>(cppThis, String::cppNew("_skipped"))))) {
    while (CppApi::cppBoolValue(cppApply<Bool*>(
        CppObjectGet<Object*>(cppThis, String::cppNew("_iterator")),
        String::cppNew("moveNext")))) {
      if (CppApi::cppBoolValue(Bool::cpp_not(([&]() {
            Object* cppLet_0 = cppApply<Object*>(
                CppObjectGet<Object*>(cppThis, String::cppNew("_iterator")),
                String::cppNew("cppGet_current"));
            return cppApply<Bool*>(
                CppObjectGet<Function*>(cppThis, String::cppNew("_test")),
                cppLet_0);
          })()))) {
        CppObjectSet<Object*>(cppThis, String::cppNew("_skipped"),
                              Bool::cppNew(true));
        return Bool::cppNew(true);
      }
    }
    return Bool::cppNew(false);
  }
  return cppApply<Bool*>(
      CppObjectGet<Object*>(cppThis, String::cppNew("_iterator")),
      String::cppNew("moveNext"));
}

Object* CppSkipWhileIterator::cppNew() {
  static std::map<String*, void*> v_ptrs = {
      {String::cppNew("cpp_equals"),
       reinterpret_cast<void*>(&Object::cpp_equals)},
      {String::cppNew("cppGet_hashCode"),
       reinterpret_cast<void*>(&Object::cppGet_hashCode)},
      {String::cppNew("toString"), reinterpret_cast<void*>(&Object::toString)},
      {String::cppNew("noSuchMethod"),
       reinterpret_cast<void*>(&Object::noSuchMethod)},
      {String::cppNew("cppGet_runtimeType"),
       reinterpret_cast<void*>(&Object::cppGet_runtimeType)},
      {String::cppNew("moveNext"),
       reinterpret_cast<void*>(&CppSkipWhileIterator::moveNext)},
      {String::cppNew("cppGet_current"),
       reinterpret_cast<void*>(&CppSkipWhileIterator::cppGet_current)}};
  static Type* runtimeType = new Type("CppSkipWhileIterator");
  Object* ptr = new ObjectImp(const_cast<Type*>(runtimeType), &v_ptrs);
  return ptr;
}

//  library package:dart2bytecode/demo/Iterable.dart
Object* CppReversedIterable::cppCtr_(Object* cppThis, Object* _source) {
  CppObjectSet<Object*>(cppThis, String::cppNew("_source"), _source);

  return cppThis;
}

Object* CppReversedIterable::cppGet_iterator(Object* cppThis) {
  return CppReversedIterator::cppCtr_(
      CppReversedIterator::cppNew(),
      CppObjectGet<Object*>(cppThis, String::cppNew("_source")));
}

Int* CppReversedIterable::cppGet_length(Object* cppThis) {
  return cppApply<Int*>(
      CppObjectGet<Object*>(cppThis, String::cppNew("_source")),
      String::cppNew("cppGet_length"));
}

Object* CppReversedIterable::cppNew() {
  static std::map<String*, void*> v_ptrs = {
      {String::cppNew("cpp_equals"),
       reinterpret_cast<void*>(&Object::cpp_equals)},
      {String::cppNew("cppGet_hashCode"),
       reinterpret_cast<void*>(&Object::cppGet_hashCode)},
      {String::cppNew("toString"), reinterpret_cast<void*>(&Object::toString)},
      {String::cppNew("noSuchMethod"),
       reinterpret_cast<void*>(&Object::noSuchMethod)},
      {String::cppNew("cppGet_runtimeType"),
       reinterpret_cast<void*>(&Object::cppGet_runtimeType)},
      {String::cppNew("cppGet_isEmpty"),
       reinterpret_cast<void*>(&CppIterable::cppGet_isEmpty)},
      {String::cppNew("cppGet_isNotEmpty"),
       reinterpret_cast<void*>(&CppIterable::cppGet_isNotEmpty)},
      {String::cppNew("cppGet_first"),
       reinterpret_cast<void*>(&CppIterable::cppGet_first)},
      {String::cppNew("cppGet_last"),
       reinterpret_cast<void*>(&CppIterable::cppGet_last)},
      {String::cppNew("cppGet_single"),
       reinterpret_cast<void*>(&CppIterable::cppGet_single)},
      {String::cppNew("elementAt"),
       reinterpret_cast<void*>(&CppIterable::elementAt)},
      {String::cppNew("contains"),
       reinterpret_cast<void*>(&CppIterable::contains)},
      {String::cppNew("forEach"),
       reinterpret_cast<void*>(&CppIterable::forEach)},
      {String::cppNew("map"), reinterpret_cast<void*>(&CppIterable::map)},
      {String::cppNew("where"), reinterpret_cast<void*>(&CppIterable::where)},
      {String::cppNew("whereType"),
       reinterpret_cast<void*>(&CppIterable::whereType)},
      {String::cppNew("expand"), reinterpret_cast<void*>(&CppIterable::expand)},
      {String::cppNew("any"), reinterpret_cast<void*>(&CppIterable::any)},
      {String::cppNew("every"), reinterpret_cast<void*>(&CppIterable::every)},
      {String::cppNew("firstWhere"),
       reinterpret_cast<void*>(&CppIterable::firstWhere)},
      {String::cppNew("lastWhere"),
       reinterpret_cast<void*>(&CppIterable::lastWhere)},
      {String::cppNew("singleWhere"),
       reinterpret_cast<void*>(&CppIterable::singleWhere)},
      {String::cppNew("reduce"), reinterpret_cast<void*>(&CppIterable::reduce)},
      {String::cppNew("fold"), reinterpret_cast<void*>(&CppIterable::fold)},
      {String::cppNew("join"), reinterpret_cast<void*>(&CppIterable::join)},
      {String::cppNew("take"), reinterpret_cast<void*>(&CppIterable::take)},
      {String::cppNew("takeWhile"),
       reinterpret_cast<void*>(&CppIterable::takeWhile)},
      {String::cppNew("skip"), reinterpret_cast<void*>(&CppIterable::skip)},
      {String::cppNew("skipWhile"),
       reinterpret_cast<void*>(&CppIterable::skipWhile)},
      {String::cppNew("cppGet_reversed"),
       reinterpret_cast<void*>(&CppIterable::cppGet_reversed)},
      {String::cppNew("followedBy"),
       reinterpret_cast<void*>(&CppIterable::followedBy)},
      {String::cppNew("toList"), reinterpret_cast<void*>(&CppIterable::toList)},
      {String::cppNew("toSet"), reinterpret_cast<void*>(&CppIterable::toSet)},
      {String::cppNew("cast"), reinterpret_cast<void*>(&CppIterable::cast)},
      {String::cppNew("cppGet_iterator"),
       reinterpret_cast<void*>(&CppReversedIterable::cppGet_iterator)},
      {String::cppNew("cppGet_length"),
       reinterpret_cast<void*>(&CppReversedIterable::cppGet_length)}};
  static Type* runtimeType = new Type("CppReversedIterable");
  Object* ptr = new ObjectImp(const_cast<Type*>(runtimeType), &v_ptrs);
  return ptr;
}

//  library package:dart2bytecode/demo/Iterable.dart
Object* CppReversedIterator::cppCtr_(Object* cppThis, Object* source) {
  CppObjectSet<Object*>(cppThis, String::cppNew("_elements"),
                        CppList::from(source, Bool::cppNew(true)));
  CppObjectSet<Int*>(cppThis, String::cppNew("_index"),
                     cppApply<Int*>(source, String::cppNew("cppGet_length")));

  return cppThis;
}

Object* CppReversedIterator::cppGet_current(Object* cppThis) {
  return cppApply<Object*, Int*>(
      CppObjectGet<Object*>(cppThis, String::cppNew("_elements")),
      String::cppNew("cpp_subscript"),
      CppObjectGet<Int*>(cppThis, String::cppNew("_index")));
}

Bool* CppReversedIterator::moveNext(Object* cppThis) {
  if (CppApi::cppBoolValue(Num::cpp_greaterThan(
          CppObjectGet<Int*>(cppThis, String::cppNew("_index")),
          Int::cppNew(0)))) {
    CppObjectSet<Int*>(
        cppThis, String::cppNew("_index"),
        Num::cpp_subtract(CppObjectGet<Int*>(cppThis, String::cppNew("_index")),
                          Int::cppNew(1)));
    return Bool::cppNew(true);
  }
  return Bool::cppNew(false);
}

Object* CppReversedIterator::cppNew() {
  static std::map<String*, void*> v_ptrs = {
      {String::cppNew("cpp_equals"),
       reinterpret_cast<void*>(&Object::cpp_equals)},
      {String::cppNew("cppGet_hashCode"),
       reinterpret_cast<void*>(&Object::cppGet_hashCode)},
      {String::cppNew("toString"), reinterpret_cast<void*>(&Object::toString)},
      {String::cppNew("noSuchMethod"),
       reinterpret_cast<void*>(&Object::noSuchMethod)},
      {String::cppNew("cppGet_runtimeType"),
       reinterpret_cast<void*>(&Object::cppGet_runtimeType)},
      {String::cppNew("moveNext"),
       reinterpret_cast<void*>(&CppReversedIterator::moveNext)},
      {String::cppNew("cppGet_current"),
       reinterpret_cast<void*>(&CppReversedIterator::cppGet_current)}};
  static Type* runtimeType = new Type("CppReversedIterator");
  Object* ptr = new ObjectImp(const_cast<Type*>(runtimeType), &v_ptrs);
  return ptr;
}

//  library package:dart2bytecode/demo/Iterable.dart
Object* CppFollowedByIterable::cppCtr_(Object* cppThis,
                                       Object* _first,
                                       Object* _second) {
  CppObjectSet<Object*>(cppThis, String::cppNew("_first"), _first);
  CppObjectSet<Object*>(cppThis, String::cppNew("_second"), _second);

  return cppThis;
}

Object* CppFollowedByIterable::cppGet_iterator(Object* cppThis) {
  return CppFollowedByIterator::cppCtr_(
      CppFollowedByIterator::cppNew(),
      cppApply<Object*>(
          CppObjectGet<Object*>(cppThis, String::cppNew("_first")),
          String::cppNew("cppGet_iterator")),
      cppApply<Object*>(
          CppObjectGet<Object*>(cppThis, String::cppNew("_second")),
          String::cppNew("cppGet_iterator")));
}

Int* CppFollowedByIterable::cppGet_length(Object* cppThis) {
  return Num::cpp_add(
      cppApply<Int*>(CppObjectGet<Object*>(cppThis, String::cppNew("_first")),
                     String::cppNew("cppGet_length")),
      cppApply<Int*>(CppObjectGet<Object*>(cppThis, String::cppNew("_second")),
                     String::cppNew("cppGet_length")));
}

Object* CppFollowedByIterable::cppNew() {
  static std::map<String*, void*> v_ptrs = {
      {String::cppNew("cpp_equals"),
       reinterpret_cast<void*>(&Object::cpp_equals)},
      {String::cppNew("cppGet_hashCode"),
       reinterpret_cast<void*>(&Object::cppGet_hashCode)},
      {String::cppNew("toString"), reinterpret_cast<void*>(&Object::toString)},
      {String::cppNew("noSuchMethod"),
       reinterpret_cast<void*>(&Object::noSuchMethod)},
      {String::cppNew("cppGet_runtimeType"),
       reinterpret_cast<void*>(&Object::cppGet_runtimeType)},
      {String::cppNew("cppGet_isEmpty"),
       reinterpret_cast<void*>(&CppIterable::cppGet_isEmpty)},
      {String::cppNew("cppGet_isNotEmpty"),
       reinterpret_cast<void*>(&CppIterable::cppGet_isNotEmpty)},
      {String::cppNew("cppGet_first"),
       reinterpret_cast<void*>(&CppIterable::cppGet_first)},
      {String::cppNew("cppGet_last"),
       reinterpret_cast<void*>(&CppIterable::cppGet_last)},
      {String::cppNew("cppGet_single"),
       reinterpret_cast<void*>(&CppIterable::cppGet_single)},
      {String::cppNew("elementAt"),
       reinterpret_cast<void*>(&CppIterable::elementAt)},
      {String::cppNew("contains"),
       reinterpret_cast<void*>(&CppIterable::contains)},
      {String::cppNew("forEach"),
       reinterpret_cast<void*>(&CppIterable::forEach)},
      {String::cppNew("map"), reinterpret_cast<void*>(&CppIterable::map)},
      {String::cppNew("where"), reinterpret_cast<void*>(&CppIterable::where)},
      {String::cppNew("whereType"),
       reinterpret_cast<void*>(&CppIterable::whereType)},
      {String::cppNew("expand"), reinterpret_cast<void*>(&CppIterable::expand)},
      {String::cppNew("any"), reinterpret_cast<void*>(&CppIterable::any)},
      {String::cppNew("every"), reinterpret_cast<void*>(&CppIterable::every)},
      {String::cppNew("firstWhere"),
       reinterpret_cast<void*>(&CppIterable::firstWhere)},
      {String::cppNew("lastWhere"),
       reinterpret_cast<void*>(&CppIterable::lastWhere)},
      {String::cppNew("singleWhere"),
       reinterpret_cast<void*>(&CppIterable::singleWhere)},
      {String::cppNew("reduce"), reinterpret_cast<void*>(&CppIterable::reduce)},
      {String::cppNew("fold"), reinterpret_cast<void*>(&CppIterable::fold)},
      {String::cppNew("join"), reinterpret_cast<void*>(&CppIterable::join)},
      {String::cppNew("take"), reinterpret_cast<void*>(&CppIterable::take)},
      {String::cppNew("takeWhile"),
       reinterpret_cast<void*>(&CppIterable::takeWhile)},
      {String::cppNew("skip"), reinterpret_cast<void*>(&CppIterable::skip)},
      {String::cppNew("skipWhile"),
       reinterpret_cast<void*>(&CppIterable::skipWhile)},
      {String::cppNew("cppGet_reversed"),
       reinterpret_cast<void*>(&CppIterable::cppGet_reversed)},
      {String::cppNew("followedBy"),
       reinterpret_cast<void*>(&CppIterable::followedBy)},
      {String::cppNew("toList"), reinterpret_cast<void*>(&CppIterable::toList)},
      {String::cppNew("toSet"), reinterpret_cast<void*>(&CppIterable::toSet)},
      {String::cppNew("cast"), reinterpret_cast<void*>(&CppIterable::cast)},
      {String::cppNew("cppGet_iterator"),
       reinterpret_cast<void*>(&CppFollowedByIterable::cppGet_iterator)},
      {String::cppNew("cppGet_length"),
       reinterpret_cast<void*>(&CppFollowedByIterable::cppGet_length)}};
  static Type* runtimeType = new Type("CppFollowedByIterable");
  Object* ptr = new ObjectImp(const_cast<Type*>(runtimeType), &v_ptrs);
  return ptr;
}

//  library package:dart2bytecode/demo/Iterable.dart
Object* CppFollowedByIterator::cppCtr_(Object* cppThis,
                                       Object* _first,
                                       Object* _second) {
  CppObjectSet<Object*>(cppThis, String::cppNew("_first"), _first);
  CppObjectSet<Object*>(cppThis, String::cppNew("_second"), _second);

  return cppThis;
}

Object* CppFollowedByIterator::cppGet_current(Object* cppThis) {
  return CppApi::cppBoolValue(
             CppObjectGet<Bool*>(cppThis, String::cppNew("_usingFirst")))
             ? cppApply<Object*>(
                   CppObjectGet<Object*>(cppThis, String::cppNew("_first")),
                   String::cppNew("cppGet_current"))
             : cppApply<Object*>(
                   CppObjectGet<Object*>(cppThis, String::cppNew("_second")),
                   String::cppNew("cppGet_current"));
}

Bool* CppFollowedByIterator::moveNext(Object* cppThis) {
  if (CppApi::cppBoolValue(
          CppObjectGet<Bool*>(cppThis, String::cppNew("_usingFirst")))) {
    if (CppApi::cppBoolValue(cppApply<Bool*>(
            CppObjectGet<Object*>(cppThis, String::cppNew("_first")),
            String::cppNew("moveNext")))) {
      return Bool::cppNew(true);
    }
    CppObjectSet<Object*>(cppThis, String::cppNew("_usingFirst"),
                          Bool::cppNew(false));
  }
  return cppApply<Bool*>(
      CppObjectGet<Object*>(cppThis, String::cppNew("_second")),
      String::cppNew("moveNext"));
}

Object* CppFollowedByIterator::cppNew() {
  static std::map<String*, void*> v_ptrs = {
      {String::cppNew("cpp_equals"),
       reinterpret_cast<void*>(&Object::cpp_equals)},
      {String::cppNew("cppGet_hashCode"),
       reinterpret_cast<void*>(&Object::cppGet_hashCode)},
      {String::cppNew("toString"), reinterpret_cast<void*>(&Object::toString)},
      {String::cppNew("noSuchMethod"),
       reinterpret_cast<void*>(&Object::noSuchMethod)},
      {String::cppNew("cppGet_runtimeType"),
       reinterpret_cast<void*>(&Object::cppGet_runtimeType)},
      {String::cppNew("moveNext"),
       reinterpret_cast<void*>(&CppFollowedByIterator::moveNext)},
      {String::cppNew("cppGet_current"),
       reinterpret_cast<void*>(&CppFollowedByIterator::cppGet_current)}};
  static Type* runtimeType = new Type("CppFollowedByIterator");
  Object* ptr = new ObjectImp(const_cast<Type*>(runtimeType), &v_ptrs);
  return ptr;
}

//  library package:dart2bytecode/demo/Iterable.dart
Object* CppCastIterable::cppCtr_(Object* cppThis, Object* _source) {
  CppObjectSet<Object*>(cppThis, String::cppNew("_source"), _source);

  return cppThis;
}

Object* CppCastIterable::cppGet_iterator(Object* cppThis) {
  return CppCastIterator::cppCtr_(
      CppCastIterator::cppNew(),
      cppApply<Object*>(
          CppObjectGet<Object*>(cppThis, String::cppNew("_source")),
          String::cppNew("cppGet_iterator")));
}

Int* CppCastIterable::cppGet_length(Object* cppThis) {
  return cppApply<Int*>(
      CppObjectGet<Object*>(cppThis, String::cppNew("_source")),
      String::cppNew("cppGet_length"));
}

Object* CppCastIterable::cppNew() {
  static std::map<String*, void*> v_ptrs = {
      {String::cppNew("cpp_equals"),
       reinterpret_cast<void*>(&Object::cpp_equals)},
      {String::cppNew("cppGet_hashCode"),
       reinterpret_cast<void*>(&Object::cppGet_hashCode)},
      {String::cppNew("toString"), reinterpret_cast<void*>(&Object::toString)},
      {String::cppNew("noSuchMethod"),
       reinterpret_cast<void*>(&Object::noSuchMethod)},
      {String::cppNew("cppGet_runtimeType"),
       reinterpret_cast<void*>(&Object::cppGet_runtimeType)},
      {String::cppNew("cppGet_isEmpty"),
       reinterpret_cast<void*>(&CppIterable::cppGet_isEmpty)},
      {String::cppNew("cppGet_isNotEmpty"),
       reinterpret_cast<void*>(&CppIterable::cppGet_isNotEmpty)},
      {String::cppNew("cppGet_first"),
       reinterpret_cast<void*>(&CppIterable::cppGet_first)},
      {String::cppNew("cppGet_last"),
       reinterpret_cast<void*>(&CppIterable::cppGet_last)},
      {String::cppNew("cppGet_single"),
       reinterpret_cast<void*>(&CppIterable::cppGet_single)},
      {String::cppNew("elementAt"),
       reinterpret_cast<void*>(&CppIterable::elementAt)},
      {String::cppNew("contains"),
       reinterpret_cast<void*>(&CppIterable::contains)},
      {String::cppNew("forEach"),
       reinterpret_cast<void*>(&CppIterable::forEach)},
      {String::cppNew("map"), reinterpret_cast<void*>(&CppIterable::map)},
      {String::cppNew("where"), reinterpret_cast<void*>(&CppIterable::where)},
      {String::cppNew("whereType"),
       reinterpret_cast<void*>(&CppIterable::whereType)},
      {String::cppNew("expand"), reinterpret_cast<void*>(&CppIterable::expand)},
      {String::cppNew("any"), reinterpret_cast<void*>(&CppIterable::any)},
      {String::cppNew("every"), reinterpret_cast<void*>(&CppIterable::every)},
      {String::cppNew("firstWhere"),
       reinterpret_cast<void*>(&CppIterable::firstWhere)},
      {String::cppNew("lastWhere"),
       reinterpret_cast<void*>(&CppIterable::lastWhere)},
      {String::cppNew("singleWhere"),
       reinterpret_cast<void*>(&CppIterable::singleWhere)},
      {String::cppNew("reduce"), reinterpret_cast<void*>(&CppIterable::reduce)},
      {String::cppNew("fold"), reinterpret_cast<void*>(&CppIterable::fold)},
      {String::cppNew("join"), reinterpret_cast<void*>(&CppIterable::join)},
      {String::cppNew("take"), reinterpret_cast<void*>(&CppIterable::take)},
      {String::cppNew("takeWhile"),
       reinterpret_cast<void*>(&CppIterable::takeWhile)},
      {String::cppNew("skip"), reinterpret_cast<void*>(&CppIterable::skip)},
      {String::cppNew("skipWhile"),
       reinterpret_cast<void*>(&CppIterable::skipWhile)},
      {String::cppNew("cppGet_reversed"),
       reinterpret_cast<void*>(&CppIterable::cppGet_reversed)},
      {String::cppNew("followedBy"),
       reinterpret_cast<void*>(&CppIterable::followedBy)},
      {String::cppNew("toList"), reinterpret_cast<void*>(&CppIterable::toList)},
      {String::cppNew("toSet"), reinterpret_cast<void*>(&CppIterable::toSet)},
      {String::cppNew("cast"), reinterpret_cast<void*>(&CppIterable::cast)},
      {String::cppNew("cppGet_iterator"),
       reinterpret_cast<void*>(&CppCastIterable::cppGet_iterator)},
      {String::cppNew("cppGet_length"),
       reinterpret_cast<void*>(&CppCastIterable::cppGet_length)}};
  static Type* runtimeType = new Type("CppCastIterable");
  Object* ptr = new ObjectImp(const_cast<Type*>(runtimeType), &v_ptrs);
  return ptr;
}

//  library package:dart2bytecode/demo/Iterable.dart
Object* CppCastIterator::cppCtr_(Object* cppThis, Object* _iterator) {
  CppObjectSet<Object*>(cppThis, String::cppNew("_iterator"), _iterator);

  return cppThis;
}

Object* CppCastIterator::cppGet_current(Object* cppThis) {
  return reinterpret_cast<Object*>(cppApply<Object*>(
      CppObjectGet<Object*>(cppThis, String::cppNew("_iterator")),
      String::cppNew("cppGet_current")));
}

Bool* CppCastIterator::moveNext(Object* cppThis) {
  return cppApply<Bool*>(
      CppObjectGet<Object*>(cppThis, String::cppNew("_iterator")),
      String::cppNew("moveNext"));
}

Object* CppCastIterator::cppNew() {
  static std::map<String*, void*> v_ptrs = {
      {String::cppNew("cpp_equals"),
       reinterpret_cast<void*>(&Object::cpp_equals)},
      {String::cppNew("cppGet_hashCode"),
       reinterpret_cast<void*>(&Object::cppGet_hashCode)},
      {String::cppNew("toString"), reinterpret_cast<void*>(&Object::toString)},
      {String::cppNew("noSuchMethod"),
       reinterpret_cast<void*>(&Object::noSuchMethod)},
      {String::cppNew("cppGet_runtimeType"),
       reinterpret_cast<void*>(&Object::cppGet_runtimeType)},
      {String::cppNew("moveNext"),
       reinterpret_cast<void*>(&CppCastIterator::moveNext)},
      {String::cppNew("cppGet_current"),
       reinterpret_cast<void*>(&CppCastIterator::cppGet_current)}};
  static Type* runtimeType = new Type("CppCastIterator");
  Object* ptr = new ObjectImp(const_cast<Type*>(runtimeType), &v_ptrs);
  return ptr;
}

//  library package:dart2bytecode/demo/Iterable.dart
Object* _CppEmptyIterable::cppCtr_(Object* cppThis) {
  return cppThis;
}

Object* _CppEmptyIterable::cppGet_iterator(Object* cppThis) {
  return _CppEmptyIterator::cppCtr_(_CppEmptyIterator::cppNew());
}

Int* _CppEmptyIterable::cppGet_length(Object* cppThis) {
  return Int::cppNew(0);
}

Object* _CppEmptyIterable::cppNew() {
  static std::map<String*, void*> v_ptrs = {
      {String::cppNew("cpp_equals"),
       reinterpret_cast<void*>(&Object::cpp_equals)},
      {String::cppNew("cppGet_hashCode"),
       reinterpret_cast<void*>(&Object::cppGet_hashCode)},
      {String::cppNew("toString"), reinterpret_cast<void*>(&Object::toString)},
      {String::cppNew("noSuchMethod"),
       reinterpret_cast<void*>(&Object::noSuchMethod)},
      {String::cppNew("cppGet_runtimeType"),
       reinterpret_cast<void*>(&Object::cppGet_runtimeType)},
      {String::cppNew("cppGet_isEmpty"),
       reinterpret_cast<void*>(&CppIterable::cppGet_isEmpty)},
      {String::cppNew("cppGet_isNotEmpty"),
       reinterpret_cast<void*>(&CppIterable::cppGet_isNotEmpty)},
      {String::cppNew("cppGet_first"),
       reinterpret_cast<void*>(&CppIterable::cppGet_first)},
      {String::cppNew("cppGet_last"),
       reinterpret_cast<void*>(&CppIterable::cppGet_last)},
      {String::cppNew("cppGet_single"),
       reinterpret_cast<void*>(&CppIterable::cppGet_single)},
      {String::cppNew("elementAt"),
       reinterpret_cast<void*>(&CppIterable::elementAt)},
      {String::cppNew("contains"),
       reinterpret_cast<void*>(&CppIterable::contains)},
      {String::cppNew("forEach"),
       reinterpret_cast<void*>(&CppIterable::forEach)},
      {String::cppNew("map"), reinterpret_cast<void*>(&CppIterable::map)},
      {String::cppNew("where"), reinterpret_cast<void*>(&CppIterable::where)},
      {String::cppNew("whereType"),
       reinterpret_cast<void*>(&CppIterable::whereType)},
      {String::cppNew("expand"), reinterpret_cast<void*>(&CppIterable::expand)},
      {String::cppNew("any"), reinterpret_cast<void*>(&CppIterable::any)},
      {String::cppNew("every"), reinterpret_cast<void*>(&CppIterable::every)},
      {String::cppNew("firstWhere"),
       reinterpret_cast<void*>(&CppIterable::firstWhere)},
      {String::cppNew("lastWhere"),
       reinterpret_cast<void*>(&CppIterable::lastWhere)},
      {String::cppNew("singleWhere"),
       reinterpret_cast<void*>(&CppIterable::singleWhere)},
      {String::cppNew("reduce"), reinterpret_cast<void*>(&CppIterable::reduce)},
      {String::cppNew("fold"), reinterpret_cast<void*>(&CppIterable::fold)},
      {String::cppNew("join"), reinterpret_cast<void*>(&CppIterable::join)},
      {String::cppNew("take"), reinterpret_cast<void*>(&CppIterable::take)},
      {String::cppNew("takeWhile"),
       reinterpret_cast<void*>(&CppIterable::takeWhile)},
      {String::cppNew("skip"), reinterpret_cast<void*>(&CppIterable::skip)},
      {String::cppNew("skipWhile"),
       reinterpret_cast<void*>(&CppIterable::skipWhile)},
      {String::cppNew("cppGet_reversed"),
       reinterpret_cast<void*>(&CppIterable::cppGet_reversed)},
      {String::cppNew("followedBy"),
       reinterpret_cast<void*>(&CppIterable::followedBy)},
      {String::cppNew("toList"), reinterpret_cast<void*>(&CppIterable::toList)},
      {String::cppNew("toSet"), reinterpret_cast<void*>(&CppIterable::toSet)},
      {String::cppNew("cast"), reinterpret_cast<void*>(&CppIterable::cast)},
      {String::cppNew("cppGet_iterator"),
       reinterpret_cast<void*>(&_CppEmptyIterable::cppGet_iterator)},
      {String::cppNew("cppGet_length"),
       reinterpret_cast<void*>(&_CppEmptyIterable::cppGet_length)}};
  static Type* runtimeType = new Type("_CppEmptyIterable");
  Object* ptr = new ObjectImp(const_cast<Type*>(runtimeType), &v_ptrs);
  return ptr;
}

//  library package:dart2bytecode/demo/Iterable.dart
Object* _CppEmptyIterator::cppCtr_(Object* cppThis) {
  return cppThis;
}

Object* _CppEmptyIterator::cppGet_current(Object* cppThis) {
  throw "ConstructorInvocation(new StateError(No element))";
}

Bool* _CppEmptyIterator::moveNext(Object* cppThis) {
  return Bool::cppNew(false);
}

Object* _CppEmptyIterator::cppNew() {
  static std::map<String*, void*> v_ptrs = {
      {String::cppNew("cpp_equals"),
       reinterpret_cast<void*>(&Object::cpp_equals)},
      {String::cppNew("cppGet_hashCode"),
       reinterpret_cast<void*>(&Object::cppGet_hashCode)},
      {String::cppNew("toString"), reinterpret_cast<void*>(&Object::toString)},
      {String::cppNew("noSuchMethod"),
       reinterpret_cast<void*>(&Object::noSuchMethod)},
      {String::cppNew("cppGet_runtimeType"),
       reinterpret_cast<void*>(&Object::cppGet_runtimeType)},
      {String::cppNew("moveNext"),
       reinterpret_cast<void*>(&_CppEmptyIterator::moveNext)},
      {String::cppNew("cppGet_current"),
       reinterpret_cast<void*>(&_CppEmptyIterator::cppGet_current)}};
  static Type* runtimeType = new Type("_CppEmptyIterator");
  Object* ptr = new ObjectImp(const_cast<Type*>(runtimeType), &v_ptrs);
  return ptr;
}

//  library package:dart2bytecode/demo/Iterable.dart
Object* _CppGenerateIterable::cppCtr_(Object* cppThis,
                                      Int* _count,
                                      Function* _generator) {
  CppObjectSet<Int*>(cppThis, String::cppNew("_count"), _count);
  CppObjectSet<Function*>(cppThis, String::cppNew("_generator"), _generator);

  return cppThis;
}

Object* _CppGenerateIterable::cppGet_iterator(Object* cppThis) {
  return _CppGenerateIterator::cppCtr_(
      _CppGenerateIterator::cppNew(),
      CppObjectGet<Int*>(cppThis, String::cppNew("_count")),
      CppObjectGet<Function*>(cppThis, String::cppNew("_generator")));
}

Int* _CppGenerateIterable::cppGet_length(Object* cppThis) {
  return CppObjectGet<Int*>(cppThis, String::cppNew("_count"));
}

Object* _CppGenerateIterable::cppNew() {
  static std::map<String*, void*> v_ptrs = {
      {String::cppNew("cpp_equals"),
       reinterpret_cast<void*>(&Object::cpp_equals)},
      {String::cppNew("cppGet_hashCode"),
       reinterpret_cast<void*>(&Object::cppGet_hashCode)},
      {String::cppNew("toString"), reinterpret_cast<void*>(&Object::toString)},
      {String::cppNew("noSuchMethod"),
       reinterpret_cast<void*>(&Object::noSuchMethod)},
      {String::cppNew("cppGet_runtimeType"),
       reinterpret_cast<void*>(&Object::cppGet_runtimeType)},
      {String::cppNew("cppGet_isEmpty"),
       reinterpret_cast<void*>(&CppIterable::cppGet_isEmpty)},
      {String::cppNew("cppGet_isNotEmpty"),
       reinterpret_cast<void*>(&CppIterable::cppGet_isNotEmpty)},
      {String::cppNew("cppGet_first"),
       reinterpret_cast<void*>(&CppIterable::cppGet_first)},
      {String::cppNew("cppGet_last"),
       reinterpret_cast<void*>(&CppIterable::cppGet_last)},
      {String::cppNew("cppGet_single"),
       reinterpret_cast<void*>(&CppIterable::cppGet_single)},
      {String::cppNew("elementAt"),
       reinterpret_cast<void*>(&CppIterable::elementAt)},
      {String::cppNew("contains"),
       reinterpret_cast<void*>(&CppIterable::contains)},
      {String::cppNew("forEach"),
       reinterpret_cast<void*>(&CppIterable::forEach)},
      {String::cppNew("map"), reinterpret_cast<void*>(&CppIterable::map)},
      {String::cppNew("where"), reinterpret_cast<void*>(&CppIterable::where)},
      {String::cppNew("whereType"),
       reinterpret_cast<void*>(&CppIterable::whereType)},
      {String::cppNew("expand"), reinterpret_cast<void*>(&CppIterable::expand)},
      {String::cppNew("any"), reinterpret_cast<void*>(&CppIterable::any)},
      {String::cppNew("every"), reinterpret_cast<void*>(&CppIterable::every)},
      {String::cppNew("firstWhere"),
       reinterpret_cast<void*>(&CppIterable::firstWhere)},
      {String::cppNew("lastWhere"),
       reinterpret_cast<void*>(&CppIterable::lastWhere)},
      {String::cppNew("singleWhere"),
       reinterpret_cast<void*>(&CppIterable::singleWhere)},
      {String::cppNew("reduce"), reinterpret_cast<void*>(&CppIterable::reduce)},
      {String::cppNew("fold"), reinterpret_cast<void*>(&CppIterable::fold)},
      {String::cppNew("join"), reinterpret_cast<void*>(&CppIterable::join)},
      {String::cppNew("take"), reinterpret_cast<void*>(&CppIterable::take)},
      {String::cppNew("takeWhile"),
       reinterpret_cast<void*>(&CppIterable::takeWhile)},
      {String::cppNew("skip"), reinterpret_cast<void*>(&CppIterable::skip)},
      {String::cppNew("skipWhile"),
       reinterpret_cast<void*>(&CppIterable::skipWhile)},
      {String::cppNew("cppGet_reversed"),
       reinterpret_cast<void*>(&CppIterable::cppGet_reversed)},
      {String::cppNew("followedBy"),
       reinterpret_cast<void*>(&CppIterable::followedBy)},
      {String::cppNew("toList"), reinterpret_cast<void*>(&CppIterable::toList)},
      {String::cppNew("toSet"), reinterpret_cast<void*>(&CppIterable::toSet)},
      {String::cppNew("cast"), reinterpret_cast<void*>(&CppIterable::cast)},
      {String::cppNew("cppGet_iterator"),
       reinterpret_cast<void*>(&_CppGenerateIterable::cppGet_iterator)},
      {String::cppNew("cppGet_length"),
       reinterpret_cast<void*>(&_CppGenerateIterable::cppGet_length)}};
  static Type* runtimeType = new Type("_CppGenerateIterable");
  Object* ptr = new ObjectImp(const_cast<Type*>(runtimeType), &v_ptrs);
  return ptr;
}

//  library package:dart2bytecode/demo/Iterable.dart
Object* _CppGenerateIterator::cppCtr_(Object* cppThis,
                                      Int* _count,
                                      Function* _generator) {
  CppObjectSet<Int*>(cppThis, String::cppNew("_count"), _count);
  CppObjectSet<Function*>(cppThis, String::cppNew("_generator"), _generator);

  return cppThis;
}

Object* _CppGenerateIterator::cppGet_current(Object* cppThis) {
  return ([&]() {
    Object* cppLet_0 =
        CppObjectGet<Object*>(cppThis, String::cppNew("_current"));
    return CppApi::cppBoolValue(Bool::cppNew(cppLet_0 == nullptr))
               ? reinterpret_cast<Object*>(cppLet_0)
               : cppLet_0;
  })();
}

Bool* _CppGenerateIterator::moveNext(Object* cppThis) {
  if (CppApi::cppBoolValue(Num::cpp_lessThan(
          CppObjectGet<Int*>(cppThis, String::cppNew("_index")),
          CppObjectGet<Int*>(cppThis, String::cppNew("_count"))))) {
    CppObjectSet<Object*>(
        cppThis, String::cppNew("_current"), ([&]() {
          Int* cppLet_0 = ([&]() {
            Int* cppLet_0 =
                CppObjectGet<Int*>(cppThis, String::cppNew("_index"));
            return ([&]() {
              Int* cppLet_0 =
                  CppObjectSet<Int*>(cppThis, String::cppNew("_index"),
                                     Num::cpp_add(cppLet_0, Int::cppNew(1)));
              return cppLet_0;
            })();
          })();
          return cppApply<Object*>(
              CppObjectGet<Function*>(cppThis, String::cppNew("_generator")),
              cppLet_0);
        })());
    return Bool::cppNew(true);
  }
  return Bool::cppNew(false);
}

Object* _CppGenerateIterator::cppNew() {
  static std::map<String*, void*> v_ptrs = {
      {String::cppNew("cpp_equals"),
       reinterpret_cast<void*>(&Object::cpp_equals)},
      {String::cppNew("cppGet_hashCode"),
       reinterpret_cast<void*>(&Object::cppGet_hashCode)},
      {String::cppNew("toString"), reinterpret_cast<void*>(&Object::toString)},
      {String::cppNew("noSuchMethod"),
       reinterpret_cast<void*>(&Object::noSuchMethod)},
      {String::cppNew("cppGet_runtimeType"),
       reinterpret_cast<void*>(&Object::cppGet_runtimeType)},
      {String::cppNew("moveNext"),
       reinterpret_cast<void*>(&_CppGenerateIterator::moveNext)},
      {String::cppNew("cppGet_current"),
       reinterpret_cast<void*>(&_CppGenerateIterator::cppGet_current)}};
  static Type* runtimeType = new Type("_CppGenerateIterator");
  Object* ptr = new ObjectImp(const_cast<Type*>(runtimeType), &v_ptrs);
  return ptr;
}

//  library package:dart2bytecode/demo/Iterable.dart
Object* _CppUnmodifiableIterable::cppCtr_(Object* cppThis, Object* _elements) {
  CppObjectSet<Object*>(cppThis, String::cppNew("_elements"), _elements);

  return cppThis;
}

Object* _CppUnmodifiableIterable::cppGet_iterator(Object* cppThis) {
  return cppApply<Object*>(
      CppObjectGet<Object*>(cppThis, String::cppNew("_elements")),
      String::cppNew("cppGet_iterator"));
}

Int* _CppUnmodifiableIterable::cppGet_length(Object* cppThis) {
  return cppApply<Int*>(
      CppObjectGet<Object*>(cppThis, String::cppNew("_elements")),
      String::cppNew("cppGet_length"));
}

Object* _CppUnmodifiableIterable::cppNew() {
  static std::map<String*, void*> v_ptrs = {
      {String::cppNew("cpp_equals"),
       reinterpret_cast<void*>(&Object::cpp_equals)},
      {String::cppNew("cppGet_hashCode"),
       reinterpret_cast<void*>(&Object::cppGet_hashCode)},
      {String::cppNew("toString"), reinterpret_cast<void*>(&Object::toString)},
      {String::cppNew("noSuchMethod"),
       reinterpret_cast<void*>(&Object::noSuchMethod)},
      {String::cppNew("cppGet_runtimeType"),
       reinterpret_cast<void*>(&Object::cppGet_runtimeType)},
      {String::cppNew("cppGet_isEmpty"),
       reinterpret_cast<void*>(&CppIterable::cppGet_isEmpty)},
      {String::cppNew("cppGet_isNotEmpty"),
       reinterpret_cast<void*>(&CppIterable::cppGet_isNotEmpty)},
      {String::cppNew("cppGet_first"),
       reinterpret_cast<void*>(&CppIterable::cppGet_first)},
      {String::cppNew("cppGet_last"),
       reinterpret_cast<void*>(&CppIterable::cppGet_last)},
      {String::cppNew("cppGet_single"),
       reinterpret_cast<void*>(&CppIterable::cppGet_single)},
      {String::cppNew("elementAt"),
       reinterpret_cast<void*>(&CppIterable::elementAt)},
      {String::cppNew("contains"),
       reinterpret_cast<void*>(&CppIterable::contains)},
      {String::cppNew("forEach"),
       reinterpret_cast<void*>(&CppIterable::forEach)},
      {String::cppNew("map"), reinterpret_cast<void*>(&CppIterable::map)},
      {String::cppNew("where"), reinterpret_cast<void*>(&CppIterable::where)},
      {String::cppNew("whereType"),
       reinterpret_cast<void*>(&CppIterable::whereType)},
      {String::cppNew("expand"), reinterpret_cast<void*>(&CppIterable::expand)},
      {String::cppNew("any"), reinterpret_cast<void*>(&CppIterable::any)},
      {String::cppNew("every"), reinterpret_cast<void*>(&CppIterable::every)},
      {String::cppNew("firstWhere"),
       reinterpret_cast<void*>(&CppIterable::firstWhere)},
      {String::cppNew("lastWhere"),
       reinterpret_cast<void*>(&CppIterable::lastWhere)},
      {String::cppNew("singleWhere"),
       reinterpret_cast<void*>(&CppIterable::singleWhere)},
      {String::cppNew("reduce"), reinterpret_cast<void*>(&CppIterable::reduce)},
      {String::cppNew("fold"), reinterpret_cast<void*>(&CppIterable::fold)},
      {String::cppNew("join"), reinterpret_cast<void*>(&CppIterable::join)},
      {String::cppNew("take"), reinterpret_cast<void*>(&CppIterable::take)},
      {String::cppNew("takeWhile"),
       reinterpret_cast<void*>(&CppIterable::takeWhile)},
      {String::cppNew("skip"), reinterpret_cast<void*>(&CppIterable::skip)},
      {String::cppNew("skipWhile"),
       reinterpret_cast<void*>(&CppIterable::skipWhile)},
      {String::cppNew("cppGet_reversed"),
       reinterpret_cast<void*>(&CppIterable::cppGet_reversed)},
      {String::cppNew("followedBy"),
       reinterpret_cast<void*>(&CppIterable::followedBy)},
      {String::cppNew("toList"), reinterpret_cast<void*>(&CppIterable::toList)},
      {String::cppNew("toSet"), reinterpret_cast<void*>(&CppIterable::toSet)},
      {String::cppNew("cast"), reinterpret_cast<void*>(&CppIterable::cast)},
      {String::cppNew("cppGet_iterator"),
       reinterpret_cast<void*>(&_CppUnmodifiableIterable::cppGet_iterator)},
      {String::cppNew("cppGet_length"),
       reinterpret_cast<void*>(&_CppUnmodifiableIterable::cppGet_length)}};
  static Type* runtimeType = new Type("_CppUnmodifiableIterable");
  Object* ptr = new ObjectImp(const_cast<Type*>(runtimeType), &v_ptrs);
  return ptr;
}

//  library package:dart2bytecode/demo/Iterable.dart
Object* _CppCastFromIterable::cppCtr_(Object* cppThis, Object* _source) {
  CppObjectSet<Object*>(cppThis, String::cppNew("_source"), _source);

  return cppThis;
}

Object* _CppCastFromIterable::cppGet_iterator(Object* cppThis) {
  return _CppCastFromIterator::cppCtr_(
      _CppCastFromIterator::cppNew(),
      cppApply<Object*>(
          CppObjectGet<Object*>(cppThis, String::cppNew("_source")),
          String::cppNew("cppGet_iterator")));
}

Int* _CppCastFromIterable::cppGet_length(Object* cppThis) {
  return cppApply<Int*>(
      CppObjectGet<Object*>(cppThis, String::cppNew("_source")),
      String::cppNew("cppGet_length"));
}

Object* _CppCastFromIterable::cppNew() {
  static std::map<String*, void*> v_ptrs = {
      {String::cppNew("cpp_equals"),
       reinterpret_cast<void*>(&Object::cpp_equals)},
      {String::cppNew("cppGet_hashCode"),
       reinterpret_cast<void*>(&Object::cppGet_hashCode)},
      {String::cppNew("toString"), reinterpret_cast<void*>(&Object::toString)},
      {String::cppNew("noSuchMethod"),
       reinterpret_cast<void*>(&Object::noSuchMethod)},
      {String::cppNew("cppGet_runtimeType"),
       reinterpret_cast<void*>(&Object::cppGet_runtimeType)},
      {String::cppNew("cppGet_isEmpty"),
       reinterpret_cast<void*>(&CppIterable::cppGet_isEmpty)},
      {String::cppNew("cppGet_isNotEmpty"),
       reinterpret_cast<void*>(&CppIterable::cppGet_isNotEmpty)},
      {String::cppNew("cppGet_first"),
       reinterpret_cast<void*>(&CppIterable::cppGet_first)},
      {String::cppNew("cppGet_last"),
       reinterpret_cast<void*>(&CppIterable::cppGet_last)},
      {String::cppNew("cppGet_single"),
       reinterpret_cast<void*>(&CppIterable::cppGet_single)},
      {String::cppNew("elementAt"),
       reinterpret_cast<void*>(&CppIterable::elementAt)},
      {String::cppNew("contains"),
       reinterpret_cast<void*>(&CppIterable::contains)},
      {String::cppNew("forEach"),
       reinterpret_cast<void*>(&CppIterable::forEach)},
      {String::cppNew("map"), reinterpret_cast<void*>(&CppIterable::map)},
      {String::cppNew("where"), reinterpret_cast<void*>(&CppIterable::where)},
      {String::cppNew("whereType"),
       reinterpret_cast<void*>(&CppIterable::whereType)},
      {String::cppNew("expand"), reinterpret_cast<void*>(&CppIterable::expand)},
      {String::cppNew("any"), reinterpret_cast<void*>(&CppIterable::any)},
      {String::cppNew("every"), reinterpret_cast<void*>(&CppIterable::every)},
      {String::cppNew("firstWhere"),
       reinterpret_cast<void*>(&CppIterable::firstWhere)},
      {String::cppNew("lastWhere"),
       reinterpret_cast<void*>(&CppIterable::lastWhere)},
      {String::cppNew("singleWhere"),
       reinterpret_cast<void*>(&CppIterable::singleWhere)},
      {String::cppNew("reduce"), reinterpret_cast<void*>(&CppIterable::reduce)},
      {String::cppNew("fold"), reinterpret_cast<void*>(&CppIterable::fold)},
      {String::cppNew("join"), reinterpret_cast<void*>(&CppIterable::join)},
      {String::cppNew("take"), reinterpret_cast<void*>(&CppIterable::take)},
      {String::cppNew("takeWhile"),
       reinterpret_cast<void*>(&CppIterable::takeWhile)},
      {String::cppNew("skip"), reinterpret_cast<void*>(&CppIterable::skip)},
      {String::cppNew("skipWhile"),
       reinterpret_cast<void*>(&CppIterable::skipWhile)},
      {String::cppNew("cppGet_reversed"),
       reinterpret_cast<void*>(&CppIterable::cppGet_reversed)},
      {String::cppNew("followedBy"),
       reinterpret_cast<void*>(&CppIterable::followedBy)},
      {String::cppNew("toList"), reinterpret_cast<void*>(&CppIterable::toList)},
      {String::cppNew("toSet"), reinterpret_cast<void*>(&CppIterable::toSet)},
      {String::cppNew("cast"), reinterpret_cast<void*>(&CppIterable::cast)},
      {String::cppNew("cppGet_iterator"),
       reinterpret_cast<void*>(&_CppCastFromIterable::cppGet_iterator)},
      {String::cppNew("cppGet_length"),
       reinterpret_cast<void*>(&_CppCastFromIterable::cppGet_length)}};
  static Type* runtimeType = new Type("_CppCastFromIterable");
  Object* ptr = new ObjectImp(const_cast<Type*>(runtimeType), &v_ptrs);
  return ptr;
}

//  library package:dart2bytecode/demo/Iterable.dart
Object* _CppCastFromIterator::cppCtr_(Object* cppThis, Object* _iterator) {
  CppObjectSet<Object*>(cppThis, String::cppNew("_iterator"), _iterator);

  return cppThis;
}

Object* _CppCastFromIterator::cppGet_current(Object* cppThis) {
  return reinterpret_cast<Object*>(cppApply<Object*>(
      CppObjectGet<Object*>(cppThis, String::cppNew("_iterator")),
      String::cppNew("cppGet_current")));
}

Bool* _CppCastFromIterator::moveNext(Object* cppThis) {
  return cppApply<Bool*>(
      CppObjectGet<Object*>(cppThis, String::cppNew("_iterator")),
      String::cppNew("moveNext"));
}

Object* _CppCastFromIterator::cppNew() {
  static std::map<String*, void*> v_ptrs = {
      {String::cppNew("cpp_equals"),
       reinterpret_cast<void*>(&Object::cpp_equals)},
      {String::cppNew("cppGet_hashCode"),
       reinterpret_cast<void*>(&Object::cppGet_hashCode)},
      {String::cppNew("toString"), reinterpret_cast<void*>(&Object::toString)},
      {String::cppNew("noSuchMethod"),
       reinterpret_cast<void*>(&Object::noSuchMethod)},
      {String::cppNew("cppGet_runtimeType"),
       reinterpret_cast<void*>(&Object::cppGet_runtimeType)},
      {String::cppNew("moveNext"),
       reinterpret_cast<void*>(&_CppCastFromIterator::moveNext)},
      {String::cppNew("cppGet_current"),
       reinterpret_cast<void*>(&_CppCastFromIterator::cppGet_current)}};
  static Type* runtimeType = new Type("_CppCastFromIterator");
  Object* ptr = new ObjectImp(const_cast<Type*>(runtimeType), &v_ptrs);
  return ptr;
}

//  library package:dart2bytecode/demo/error.dart
Object* CppError::cppCtr_(Object* cppThis) {
  return cppThis;
}

String* CppError::safeToString(Object* object) {
  if (CppApi::cppBoolValue(Bool::cppNew(object == nullptr))) {
    return String::cppNew(new uint8_t[5]{110, 117, 108, 108, 0});
  }
  if (CppApi::cppBoolValue(
          Bool::cppNew(reinterpret_cast<String*>(object) == nullptr))) {
    return reinterpret_cast<String*>(object);
  }
  return cppApply<String*>(object, String::cppNew("toString"));
}

Object* CppError::cppGet_stackTrace(Object* cppThis) {
  return CppStackTrace::cppGet_current();
}

Object* CppError::cppGet__stackTrace(Object* cppThis) {
  throw "StaticInvocation(NoSuchMethodError.withInvocation(this, new _InvocationMirror._withType(#_stackTrace, 1, const <Type>[], const <dynamic>[], Map.unmodifiable<Symbol, dynamic>(const <Symbol, dynamic>{}))))";
}

void CppError::cppSet__stackTrace(Object* cppThis, Object* value) {
  throw "StaticInvocation(NoSuchMethodError.withInvocation(this, new _InvocationMirror._withType(#_stackTrace=, 2, const <Type>[], List.unmodifiable<dynamic>(_GrowableList._literal1<dynamic>(value)), Map.unmodifiable<Symbol, dynamic>(const <Symbol, dynamic>{}))))";
}

Object* CppError::cppNew() {
  static std::map<String*, void*> v_ptrs = {
      {String::cppNew("cpp_equals"),
       reinterpret_cast<void*>(&Object::cpp_equals)},
      {String::cppNew("cppGet_hashCode"),
       reinterpret_cast<void*>(&Object::cppGet_hashCode)},
      {String::cppNew("toString"), reinterpret_cast<void*>(&Object::toString)},
      {String::cppNew("noSuchMethod"),
       reinterpret_cast<void*>(&Object::noSuchMethod)},
      {String::cppNew("cppGet_runtimeType"),
       reinterpret_cast<void*>(&Object::cppGet_runtimeType)},
      {String::cppNew("cppGet_stackTrace"),
       reinterpret_cast<void*>(&CppError::cppGet_stackTrace)},
      {String::cppNew("cppGet__stackTrace"),
       reinterpret_cast<void*>(&CppError::cppGet__stackTrace)},
      {String::cppNew("cppSet__stackTrace"),
       reinterpret_cast<void*>(&CppError::cppSet__stackTrace)}};
  static Type* runtimeType = new Type("CppError");
  Object* ptr = new ObjectImp(const_cast<Type*>(runtimeType), &v_ptrs);
  return ptr;
}

//  library package:dart2bytecode/demo/error.dart
Object* CppStackTrace::_current =
    CppStackTrace::cppCtr_(CppStackTrace::cppNew());
Object* CppStackTrace::cppCtr_(Object* cppThis) {
  return cppThis;
}

Object* CppStackTrace::cppGet_current() {
  return CppStackTrace::_current;
}

String* CppStackTrace::toString(Object* cppThis) {
  return CppApi::getCurrentStackTrace();
}

Object* CppStackTrace::cppNew() {
  static std::map<String*, void*> v_ptrs = {
      {String::cppNew("cpp_equals"),
       reinterpret_cast<void*>(&Object::cpp_equals)},
      {String::cppNew("cppGet_hashCode"),
       reinterpret_cast<void*>(&Object::cppGet_hashCode)},
      {String::cppNew("toString"),
       reinterpret_cast<void*>(&CppStackTrace::toString)},
      {String::cppNew("noSuchMethod"),
       reinterpret_cast<void*>(&Object::noSuchMethod)},
      {String::cppNew("cppGet_runtimeType"),
       reinterpret_cast<void*>(&Object::cppGet_runtimeType)}};
  static Type* runtimeType = new Type("CppStackTrace");
  Object* ptr = new ObjectImp(const_cast<Type*>(runtimeType), &v_ptrs);
  return ptr;
}

//  library package:dart2bytecode/demo/string.dart
Object* CppStringBuffer::cppCtr_(Object* cppThis, Object* content) {
  CppObjectSet<Object*>(
      cppThis, String::cppNew("_parts"), ([&]() {
        Object* cppLet_0 = CppList::cppCtr_(CppList::cppNew(), Int::cppNew(0),
                                            Int::cppNew(16));
        cppApply<void, String*>(
            cppLet_0, String::cppNew("add"),
            cppApply<String*>(content, String::cppNew("toString")));
        return cppLet_0;
      })());

  return cppThis;
}

void CppStringBuffer::write(Object* cppThis, Object* obj) {
  cppApply<void, String*>(
      CppObjectGet<Object*>(cppThis, String::cppNew("_parts")),
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
        CppObjectGet<Object*>(cppThis, String::cppNew("_parts")),
        String::cppNew("add"),
        cppApply<String*>(
            cppApply<Object*>(iterator, String::cppNew("cppGet_current")),
            String::cppNew("toString")));
    while (CppApi::cppBoolValue(
        cppApply<Bool*>(iterator, String::cppNew("moveNext")))) {
      if (CppApi::cppBoolValue(cppApply<Bool*>(
              separator, String::cppNew("cppGet_isNotEmpty")))) {
        cppApply<void, String*>(
            CppObjectGet<Object*>(cppThis, String::cppNew("_parts")),
            String::cppNew("add"), separator);
      }
      cppApply<void, String*>(
          CppObjectGet<Object*>(cppThis, String::cppNew("_parts")),
          String::cppNew("add"),
          cppApply<String*>(
              cppApply<Object*>(iterator, String::cppNew("cppGet_current")),
              String::cppNew("toString")));
    }
  }
}

void CppStringBuffer::writeCharCode(Object* cppThis, Int* charCode) {
  cppApply<void, String*>(
      CppObjectGet<Object*>(cppThis, String::cppNew("_parts")),
      String::cppNew("add"), String::fromCharCode(charCode));
}

void CppStringBuffer::writeln(Object* cppThis, Object* obj) {
  cppApply<void, String*>(
      CppObjectGet<Object*>(cppThis, String::cppNew("_parts")),
      String::cppNew("add"),
      cppApply<String*>(obj, String::cppNew("toString")));
  cppApply<void, String*>(
      CppObjectGet<Object*>(cppThis, String::cppNew("_parts")),
      String::cppNew("add"), String::cppNew(new uint8_t[2]{10, 0}));
}

void CppStringBuffer::clear(Object* cppThis) {
  cppApply<void>(CppObjectGet<Object*>(cppThis, String::cppNew("_parts")),
                 String::cppNew("clear"));
}

String* CppStringBuffer::toString(Object* cppThis) {
  return cppApply<String*, String*>(
      CppObjectGet<Object*>(cppThis, String::cppNew("_parts")),
      String::cppNew("join"), String::cppNew(new uint8_t[1]{0}));
}

Int* CppStringBuffer::cppGet_length(Object* cppThis) {
  return cppApply<Int*, Int*, Function*>(
      CppObjectGet<Object*>(cppThis, String::cppNew("_parts")),
      String::cppNew("fold"), Int::cppNew(0),
      new LambdaWrapper<Int*, Int*, String*>(
          [&](Int* sum, String* part) -> Int* {
            return Num::cpp_add(
                sum, cppApply<Int*>(part, String::cppNew("cppGet_length")));
          }));
}

Bool* CppStringBuffer::cppGet_isEmpty(Object* cppThis) {
  return cppApply<Bool*>(
      CppObjectGet<Object*>(cppThis, String::cppNew("_parts")),
      String::cppNew("cppGet_isEmpty"));
}

Bool* CppStringBuffer::cppGet_isNotEmpty(Object* cppThis) {
  return cppApply<Bool*>(
      CppObjectGet<Object*>(cppThis, String::cppNew("_parts")),
      String::cppNew("cppGet_isNotEmpty"));
}

Object* CppStringBuffer::cppGet__parts(Object* cppThis) {
  throw "StaticInvocation(NoSuchMethodError.withInvocation(this, new _InvocationMirror._withType(#_parts, 1, const <Type>[], const <dynamic>[], Map.unmodifiable<Symbol, dynamic>(const <Symbol, dynamic>{}))))";
}

void CppStringBuffer::cppSet__parts(Object* cppThis, Object* value) {
  throw "StaticInvocation(NoSuchMethodError.withInvocation(this, new _InvocationMirror._withType(#_parts=, 2, const <Type>[], List.unmodifiable<dynamic>(_GrowableList._literal1<dynamic>(value)), Map.unmodifiable<Symbol, dynamic>(const <Symbol, dynamic>{}))))";
}

Int* CppStringBuffer::cppGet__partsCodeUnits(Object* cppThis) {
  throw "StaticInvocation(NoSuchMethodError.withInvocation(this, new _InvocationMirror._withType(#_partsCodeUnits, 1, const <Type>[], const <dynamic>[], Map.unmodifiable<Symbol, dynamic>(const <Symbol, dynamic>{}))))";
}

void CppStringBuffer::cppSet__partsCodeUnits(Object* cppThis, Int* value) {
  throw "StaticInvocation(NoSuchMethodError.withInvocation(this, new _InvocationMirror._withType(#_partsCodeUnits=, 2, const <Type>[], List.unmodifiable<dynamic>(_GrowableList._literal1<dynamic>(value)), Map.unmodifiable<Symbol, dynamic>(const <Symbol, dynamic>{}))))";
}

Int* CppStringBuffer::cppGet__partsCompactionIndex(Object* cppThis) {
  throw "StaticInvocation(NoSuchMethodError.withInvocation(this, new _InvocationMirror._withType(#_partsCompactionIndex, 1, const <Type>[], const <dynamic>[], Map.unmodifiable<Symbol, dynamic>(const <Symbol, dynamic>{}))))";
}

void CppStringBuffer::cppSet__partsCompactionIndex(Object* cppThis,
                                                   Int* value) {
  throw "StaticInvocation(NoSuchMethodError.withInvocation(this, new _InvocationMirror._withType(#_partsCompactionIndex=, 2, const <Type>[], List.unmodifiable<dynamic>(_GrowableList._literal1<dynamic>(value)), Map.unmodifiable<Symbol, dynamic>(const <Symbol, dynamic>{}))))";
}

Int* CppStringBuffer::cppGet__partsCodeUnitsSinceCompaction(Object* cppThis) {
  throw "StaticInvocation(NoSuchMethodError.withInvocation(this, new _InvocationMirror._withType(#_partsCodeUnitsSinceCompaction, 1, const <Type>[], const <dynamic>[], Map.unmodifiable<Symbol, dynamic>(const <Symbol, dynamic>{}))))";
}

void CppStringBuffer::cppSet__partsCodeUnitsSinceCompaction(Object* cppThis,
                                                            Int* value) {
  throw "StaticInvocation(NoSuchMethodError.withInvocation(this, new _InvocationMirror._withType(#_partsCodeUnitsSinceCompaction=, 2, const <Type>[], List.unmodifiable<dynamic>(_GrowableList._literal1<dynamic>(value)), Map.unmodifiable<Symbol, dynamic>(const <Symbol, dynamic>{}))))";
}

Object* CppStringBuffer::cppGet__buffer(Object* cppThis) {
  throw "StaticInvocation(NoSuchMethodError.withInvocation(this, new _InvocationMirror._withType(#_buffer, 1, const <Type>[], const <dynamic>[], Map.unmodifiable<Symbol, dynamic>(const <Symbol, dynamic>{}))))";
}

void CppStringBuffer::cppSet__buffer(Object* cppThis, Object* value) {
  throw "StaticInvocation(NoSuchMethodError.withInvocation(this, new _InvocationMirror._withType(#_buffer=, 2, const <Type>[], List.unmodifiable<dynamic>(_GrowableList._literal1<dynamic>(value)), Map.unmodifiable<Symbol, dynamic>(const <Symbol, dynamic>{}))))";
}

Int* CppStringBuffer::cppGet__bufferPosition(Object* cppThis) {
  throw "StaticInvocation(NoSuchMethodError.withInvocation(this, new _InvocationMirror._withType(#_bufferPosition, 1, const <Type>[], const <dynamic>[], Map.unmodifiable<Symbol, dynamic>(const <Symbol, dynamic>{}))))";
}

void CppStringBuffer::cppSet__bufferPosition(Object* cppThis, Int* value) {
  throw "StaticInvocation(NoSuchMethodError.withInvocation(this, new _InvocationMirror._withType(#_bufferPosition=, 2, const <Type>[], List.unmodifiable<dynamic>(_GrowableList._literal1<dynamic>(value)), Map.unmodifiable<Symbol, dynamic>(const <Symbol, dynamic>{}))))";
}

Int* CppStringBuffer::cppGet__bufferCodeUnitMagnitude(Object* cppThis) {
  throw "StaticInvocation(NoSuchMethodError.withInvocation(this, new _InvocationMirror._withType(#_bufferCodeUnitMagnitude, 1, const <Type>[], const <dynamic>[], Map.unmodifiable<Symbol, dynamic>(const <Symbol, dynamic>{}))))";
}

void CppStringBuffer::cppSet__bufferCodeUnitMagnitude(Object* cppThis,
                                                      Int* value) {
  throw "StaticInvocation(NoSuchMethodError.withInvocation(this, new _InvocationMirror._withType(#_bufferCodeUnitMagnitude=, 2, const <Type>[], List.unmodifiable<dynamic>(_GrowableList._literal1<dynamic>(value)), Map.unmodifiable<Symbol, dynamic>(const <Symbol, dynamic>{}))))";
}

void CppStringBuffer::_writeString(Object* cppThis, String* str) {
  throw "StaticInvocation(NoSuchMethodError.withInvocation(this, new _InvocationMirror._withType(#_writeString, 0, const <Type>[], List.unmodifiable<dynamic>(_GrowableList._literal1<dynamic>(str)), Map.unmodifiable<Symbol, dynamic>(const <Symbol, dynamic>{}))))";
}

void CppStringBuffer::_ensureCapacity(Object* cppThis, Int* n) {
  throw "StaticInvocation(NoSuchMethodError.withInvocation(this, new _InvocationMirror._withType(#_ensureCapacity, 0, const <Type>[], List.unmodifiable<dynamic>(_GrowableList._literal1<dynamic>(n)), Map.unmodifiable<Symbol, dynamic>(const <Symbol, dynamic>{}))))";
}

void CppStringBuffer::_consumeBuffer(Object* cppThis) {
  throw "StaticInvocation(NoSuchMethodError.withInvocation(this, new _InvocationMirror._withType(#_consumeBuffer, 0, const <Type>[], const <dynamic>[], Map.unmodifiable<Symbol, dynamic>(const <Symbol, dynamic>{}))))";
}

void CppStringBuffer::_addPart(Object* cppThis, String* str) {
  throw "StaticInvocation(NoSuchMethodError.withInvocation(this, new _InvocationMirror._withType(#_addPart, 0, const <Type>[], List.unmodifiable<dynamic>(_GrowableList._literal1<dynamic>(str)), Map.unmodifiable<Symbol, dynamic>(const <Symbol, dynamic>{}))))";
}

void CppStringBuffer::_compact(Object* cppThis) {
  throw "StaticInvocation(NoSuchMethodError.withInvocation(this, new _InvocationMirror._withType(#_compact, 0, const <Type>[], const <dynamic>[], Map.unmodifiable<Symbol, dynamic>(const <Symbol, dynamic>{}))))";
}

Object* CppStringBuffer::cppNew() {
  static std::map<String*, void*> v_ptrs = {
      {String::cppNew("cpp_equals"),
       reinterpret_cast<void*>(&Object::cpp_equals)},
      {String::cppNew("cppGet_hashCode"),
       reinterpret_cast<void*>(&Object::cppGet_hashCode)},
      {String::cppNew("toString"),
       reinterpret_cast<void*>(&CppStringBuffer::toString)},
      {String::cppNew("noSuchMethod"),
       reinterpret_cast<void*>(&Object::noSuchMethod)},
      {String::cppNew("cppGet_runtimeType"),
       reinterpret_cast<void*>(&Object::cppGet_runtimeType)},
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
       reinterpret_cast<void*>(&CppStringBuffer::cppGet_isNotEmpty)},
      {String::cppNew("cppGet__parts"),
       reinterpret_cast<void*>(&CppStringBuffer::cppGet__parts)},
      {String::cppNew("cppSet__parts"),
       reinterpret_cast<void*>(&CppStringBuffer::cppSet__parts)},
      {String::cppNew("cppGet__partsCodeUnits"),
       reinterpret_cast<void*>(&CppStringBuffer::cppGet__partsCodeUnits)},
      {String::cppNew("cppSet__partsCodeUnits"),
       reinterpret_cast<void*>(&CppStringBuffer::cppSet__partsCodeUnits)},
      {String::cppNew("cppGet__partsCompactionIndex"),
       reinterpret_cast<void*>(&CppStringBuffer::cppGet__partsCompactionIndex)},
      {String::cppNew("cppSet__partsCompactionIndex"),
       reinterpret_cast<void*>(&CppStringBuffer::cppSet__partsCompactionIndex)},
      {String::cppNew("cppGet__partsCodeUnitsSinceCompaction"),
       reinterpret_cast<void*>(
           &CppStringBuffer::cppGet__partsCodeUnitsSinceCompaction)},
      {String::cppNew("cppSet__partsCodeUnitsSinceCompaction"),
       reinterpret_cast<void*>(
           &CppStringBuffer::cppSet__partsCodeUnitsSinceCompaction)},
      {String::cppNew("cppGet__buffer"),
       reinterpret_cast<void*>(&CppStringBuffer::cppGet__buffer)},
      {String::cppNew("cppSet__buffer"),
       reinterpret_cast<void*>(&CppStringBuffer::cppSet__buffer)},
      {String::cppNew("cppGet__bufferPosition"),
       reinterpret_cast<void*>(&CppStringBuffer::cppGet__bufferPosition)},
      {String::cppNew("cppSet__bufferPosition"),
       reinterpret_cast<void*>(&CppStringBuffer::cppSet__bufferPosition)},
      {String::cppNew("cppGet__bufferCodeUnitMagnitude"),
       reinterpret_cast<void*>(
           &CppStringBuffer::cppGet__bufferCodeUnitMagnitude)},
      {String::cppNew("cppSet__bufferCodeUnitMagnitude"),
       reinterpret_cast<void*>(
           &CppStringBuffer::cppSet__bufferCodeUnitMagnitude)},
      {String::cppNew("_writeString"),
       reinterpret_cast<void*>(&CppStringBuffer::_writeString)},
      {String::cppNew("_ensureCapacity"),
       reinterpret_cast<void*>(&CppStringBuffer::_ensureCapacity)},
      {String::cppNew("_consumeBuffer"),
       reinterpret_cast<void*>(&CppStringBuffer::_consumeBuffer)},
      {String::cppNew("_addPart"),
       reinterpret_cast<void*>(&CppStringBuffer::_addPart)},
      {String::cppNew("_compact"),
       reinterpret_cast<void*>(&CppStringBuffer::_compact)}};
  static Type* runtimeType = new Type("CppStringBuffer");
  Object* ptr = new ObjectImp(const_cast<Type*>(runtimeType), &v_ptrs);
  return ptr;
}

//  dart._internal
Int* Sort::_INSERTION_SORT_THRESHOLD = Int::cppNew(32);
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
      {String::cppNew("cpp_equals"),
       reinterpret_cast<void*>(&Object::cpp_equals)},
      {String::cppNew("cppGet_hashCode"),
       reinterpret_cast<void*>(&Object::cppGet_hashCode)},
      {String::cppNew("toString"), reinterpret_cast<void*>(&Object::toString)},
      {String::cppNew("noSuchMethod"),
       reinterpret_cast<void*>(&Object::noSuchMethod)},
      {String::cppNew("cppGet_runtimeType"),
       reinterpret_cast<void*>(&Object::cppGet_runtimeType)}};
  static Type* runtimeType = new Type("Sort");
  Object* ptr = new ObjectImp(const_cast<Type*>(runtimeType), &v_ptrs);
  return ptr;
}

//  nativewrappers
Object* NativeFieldWrapperClass1::cppCtr_(Object* cppThis) {
  return cppThis;
}

Object* NativeFieldWrapperClass1::cppNew() {
  static std::map<String*, void*> v_ptrs = {
      {String::cppNew("cpp_equals"),
       reinterpret_cast<void*>(&Object::cpp_equals)},
      {String::cppNew("cppGet_hashCode"),
       reinterpret_cast<void*>(&Object::cppGet_hashCode)},
      {String::cppNew("toString"), reinterpret_cast<void*>(&Object::toString)},
      {String::cppNew("noSuchMethod"),
       reinterpret_cast<void*>(&Object::noSuchMethod)},
      {String::cppNew("cppGet_runtimeType"),
       reinterpret_cast<void*>(&Object::cppGet_runtimeType)}};
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
      {String::cppNew("cpp_equals"),
       reinterpret_cast<void*>(&Object::cpp_equals)},
      {String::cppNew("cppGet_hashCode"),
       reinterpret_cast<void*>(&Object::cppGet_hashCode)},
      {String::cppNew("toString"), reinterpret_cast<void*>(&Object::toString)},
      {String::cppNew("noSuchMethod"),
       reinterpret_cast<void*>(&Object::noSuchMethod)},
      {String::cppNew("cppGet_runtimeType"),
       reinterpret_cast<void*>(&Object::cppGet_runtimeType)}};
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
      {String::cppNew("cpp_equals"),
       reinterpret_cast<void*>(&Object::cpp_equals)},
      {String::cppNew("cppGet_hashCode"),
       reinterpret_cast<void*>(&Object::cppGet_hashCode)},
      {String::cppNew("toString"), reinterpret_cast<void*>(&Object::toString)},
      {String::cppNew("noSuchMethod"),
       reinterpret_cast<void*>(&Object::noSuchMethod)},
      {String::cppNew("cppGet_runtimeType"),
       reinterpret_cast<void*>(&Object::cppGet_runtimeType)}};
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
      {String::cppNew("cpp_equals"),
       reinterpret_cast<void*>(&Object::cpp_equals)},
      {String::cppNew("cppGet_hashCode"),
       reinterpret_cast<void*>(&Object::cppGet_hashCode)},
      {String::cppNew("toString"), reinterpret_cast<void*>(&Object::toString)},
      {String::cppNew("noSuchMethod"),
       reinterpret_cast<void*>(&Object::noSuchMethod)},
      {String::cppNew("cppGet_runtimeType"),
       reinterpret_cast<void*>(&Object::cppGet_runtimeType)}};
  static Type* runtimeType = new Type("NativeFieldWrapperClass4");
  Object* ptr = new ObjectImp(const_cast<Type*>(runtimeType), &v_ptrs);
  return ptr;
}

//  dart.core
Object* Comparable::cppCtr_(Object* cppThis) {
  return cppThis;
}

Int* Comparable::compare(Object* a, Object* b) {
  return cppApply<Int*, Object*>(a, String::cppNew("compareTo"), b);
}

//  dart.core
Object* ArgumentError::cppCtr_(Object* cppThis, Object* message, String* name) {
  CppObjectSet<Object*>(cppThis, String::cppNew("message"), message);
  CppObjectSet<String*>(cppThis, String::cppNew("name"), name);
  CppObjectSet<Object*>(cppThis, String::cppNew("invalidValue"), nullptr);
  CppObjectSet<Bool*>(cppThis, String::cppNew("_hasValue"),
                      Bool::cppNew(false));

  return cppThis;
}

Object* ArgumentError::cppCtr_value(Object* cppThis,
                                    Object* value,
                                    String* name,
                                    Object* message) {
  CppObjectSet<String*>(cppThis, String::cppNew("name"), name);
  CppObjectSet<Object*>(cppThis, String::cppNew("message"), message);
  CppObjectSet<Object*>(cppThis, String::cppNew("invalidValue"), value);
  CppObjectSet<Bool*>(cppThis, String::cppNew("_hasValue"), Bool::cppNew(true));

  return cppThis;
}

Object* ArgumentError::cppCtr_notNull(Object* cppThis, String* name) {
  CppObjectSet<String*>(cppThis, String::cppNew("name"), name);
  CppObjectSet<Bool*>(cppThis, String::cppNew("_hasValue"),
                      Bool::cppNew(false));
  CppObjectSet<Object*>(
      cppThis, String::cppNew("message"),
      String::cppNew(new uint8_t[17]{77, 117, 115, 116, 32, 110, 111, 116, 32,
                                     98, 101, 32, 110, 117, 108, 108, 0}));
  CppObjectSet<Object*>(cppThis, String::cppNew("invalidValue"), nullptr);

  return cppThis;
}

Object* ArgumentError::checkNotNull(Object* argument, String* name) {
  return ([&]() {
    Object* cppLet_0 = argument;
    return CppApi::cppBoolValue(Bool::cppNew(cppLet_0 == nullptr))
               ? throw "ConstructorInvocation(new ArgumentError.notNull(name))"
               : cppLet_0;
  })();
}

String* ArgumentError::cppGet__errorName(Object* cppThis) {
  return String::cpp_add(
      cppToString(String::cppNew(new uint8_t[17]{73, 110, 118, 97, 108, 105,
                                                 100, 32, 97, 114, 103, 117,
                                                 109, 101, 110, 116, 0})),
      cppToString(CppApi::cppBoolValue(Bool::cpp_not(CppObjectGet<Bool*>(
                      cppThis, String::cppNew("_hasValue"))))
                      ? String::cppNew(new uint8_t[4]{40, 115, 41, 0})
                      : String::cppNew(new uint8_t[1]{0})));
}

String* ArgumentError::cppGet__errorExplanation(Object* cppThis) {
  return String::cppNew(new uint8_t[1]{0});
}

String* ArgumentError::toString(Object* cppThis) {
  String* name = CppObjectGet<String*>(cppThis, String::cppNew("name"));
  String* nameString =
      CppApi::cppBoolValue(Bool::cppNew(name == nullptr))
          ? String::cppNew(new uint8_t[1]{0})
          : String::cpp_add(
                String::cpp_add(
                    cppToString(String::cppNew(new uint8_t[3]{32, 40, 0})),
                    cppToString(name)),
                cppToString(String::cppNew(new uint8_t[2]{41, 0})));
  Object* message = CppObjectGet<Object*>(cppThis, String::cppNew("message"));
  String* messageString =
      CppApi::cppBoolValue(Bool::cppNew(message == nullptr))
          ? String::cppNew(new uint8_t[1]{0})
          : String::cpp_add(
                cppToString(String::cppNew(new uint8_t[3]{58, 32, 0})),
                cppToString(message));
  String* prefix = String::cpp_add(
      String::cpp_add(cppToString(cppApply<String*>(
                          cppThis, String::cppNew("cppGet__errorName"))),
                      cppToString(nameString)),
      cppToString(messageString));
  if (CppApi::cppBoolValue(Bool::cpp_not(
          CppObjectGet<Bool*>(cppThis, String::cppNew("_hasValue")))))
    return prefix;
  String* explanation =
      cppApply<String*>(cppThis, String::cppNew("cppGet__errorExplanation"));
  String* errorValue = CppError::safeToString(
      CppObjectGet<Object*>(cppThis, String::cppNew("invalidValue")));
  return String::cpp_add(
      String::cpp_add(
          String::cpp_add(cppToString(prefix), cppToString(explanation)),
          cppToString(String::cppNew(new uint8_t[3]{58, 32, 0}))),
      cppToString(errorValue));
}

Object* ArgumentError::cppNew() {
  static std::map<String*, void*> v_ptrs = {
      {String::cppNew("cpp_equals"),
       reinterpret_cast<void*>(&Object::cpp_equals)},
      {String::cppNew("cppGet_hashCode"),
       reinterpret_cast<void*>(&Object::cppGet_hashCode)},
      {String::cppNew("toString"),
       reinterpret_cast<void*>(&ArgumentError::toString)},
      {String::cppNew("noSuchMethod"),
       reinterpret_cast<void*>(&Object::noSuchMethod)},
      {String::cppNew("cppGet_runtimeType"),
       reinterpret_cast<void*>(&Object::cppGet_runtimeType)},
      {String::cppNew("cppGet_stackTrace"),
       reinterpret_cast<void*>(&CppError::cppGet_stackTrace)},
      {String::cppNew("cppGet__errorName"),
       reinterpret_cast<void*>(&ArgumentError::cppGet__errorName)},
      {String::cppNew("cppGet__errorExplanation"),
       reinterpret_cast<void*>(&ArgumentError::cppGet__errorExplanation)}};
  static Type* runtimeType = new Type("ArgumentError");
  Object* ptr = new ObjectImp(const_cast<Type*>(runtimeType), &v_ptrs);
  return ptr;
}

//  dart.core
Object* RangeError::cppCtr_(Object* cppThis, Object* message) {
  CppObjectSet<Num*>(cppThis, String::cppNew("start"), nullptr);
  CppObjectSet<Num*>(cppThis, String::cppNew("end"), nullptr);

  return cppThis;
}

Object* RangeError::cppCtr_value(Object* cppThis,
                                 Num* value,
                                 String* name,
                                 String* message) {
  CppObjectSet<Num*>(cppThis, String::cppNew("start"), nullptr);
  CppObjectSet<Num*>(cppThis, String::cppNew("end"), nullptr);

  return cppThis;
}

Object* RangeError::cppCtr_range(Object* cppThis,
                                 Num* invalidValue,
                                 Int* minValue,
                                 Int* maxValue,
                                 String* name,
                                 String* message) {
  CppObjectSet<Num*>(cppThis, String::cppNew("start"), minValue);
  CppObjectSet<Num*>(cppThis, String::cppNew("end"), maxValue);

  return cppThis;
}

Num* RangeError::cppGet_invalidValue(Object* cppThis) {
  return reinterpret_cast<Num*>(
      CppObjectGet<Object*>(cppThis, String::cppNew("invalidValue")));
}

Object* RangeError::index(Int* index,
                          Object* indexable,
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

Int* RangeError::checkValidIndex(Int* index,
                                 Object* indexable,
                                 String* name,
                                 Int* length,
                                 String* message) {
  CppApi::cppBoolValue(Bool::cppNew(length == nullptr))
      ? length = reinterpret_cast<Int*>(
            CppObjectGet<Object*>(indexable, String::cppNew("length")))
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
        ? startName = String::cppNew(new uint8_t[6]{115, 116, 97, 114, 116, 0})
        : nullptr;
    throw "ConstructorInvocation(new RangeError.range(start, 0, length, startName{String}, message))";
  }
  if (CppApi::cppBoolValue(Bool::cpp_not(Bool::cppNew(end == nullptr)))) {
    if (CppApi::cppBoolValue(
            CppApi::cppBoolValue(Num::cpp_greaterThan(start, end)) ||
            CppApi::cppBoolValue(Num::cpp_greaterThan(end, length)))) {
      CppApi::cppBoolValue(Bool::cppNew(endName == nullptr))
          ? endName = String::cppNew(new uint8_t[4]{101, 110, 100, 0})
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
  return String::cppNew(
      new uint8_t[11]{82, 97, 110, 103, 101, 69, 114, 114, 111, 114, 0});
}

String* RangeError::cppGet__errorExplanation(Object* cppThis) {
  print("assert");
  String* explanation = String::cppNew(new uint8_t[1]{0});
  Num* start = CppObjectGet<Num*>(cppThis, String::cppNew("start"));
  Num* end = CppObjectGet<Num*>(cppThis, String::cppNew("end"));
  if (CppApi::cppBoolValue(Bool::cppNew(start == nullptr))) {
    if (CppApi::cppBoolValue(Bool::cpp_not(Bool::cppNew(end == nullptr)))) {
      explanation =
          String::cpp_add(cppToString(String::cppNew(new uint8_t[29]{
                              58,  32,  78,  111, 116, 32,  108, 101, 115, 115,
                              32,  116, 104, 97,  110, 32,  111, 114, 32,  101,
                              113, 117, 97,  108, 32,  116, 111, 32,  0})),
                          cppToString(end));
    }
  } else if (CppApi::cppBoolValue(Bool::cppNew(end == nullptr))) {
    explanation = String::cpp_add(
        cppToString(String::cppNew(new uint8_t[32]{
            58,  32,  78,  111, 116, 32, 103, 114, 101, 97,  116,
            101, 114, 32,  116, 104, 97, 110, 32,  111, 114, 32,
            101, 113, 117, 97,  108, 32, 116, 111, 32,  0})),
        cppToString(start));
  } else if (CppApi::cppBoolValue(Num::cpp_greaterThan(end, start))) {
    explanation = String::cpp_add(
        String::cpp_add(
            String::cpp_add(cppToString(String::cppNew(new uint8_t[26]{
                                58,  32,  78, 111, 116, 32,  105, 110, 32,
                                105, 110, 99, 108, 117, 115, 105, 118, 101,
                                32,  114, 97, 110, 103, 101, 32,  0})),
                            cppToString(start)),
            cppToString(String::cppNew(new uint8_t[3]{46, 46, 0}))),
        cppToString(end));
  } else if (CppApi::cppBoolValue(Num::cpp_lessThan(end, start))) {
    explanation = String::cppNew(new uint8_t[29]{
        58, 32,  86,  97,  108, 105, 100, 32, 118, 97,  108, 117, 101, 32, 114,
        97, 110, 103, 101, 32,  105, 115, 32, 101, 109, 112, 116, 121, 0});
  } else {
    explanation = String::cpp_add(
        cppToString(String::cppNew(new uint8_t[23]{
            58, 32,  79, 110, 108, 121, 32, 118, 97,  108, 105, 100,
            32, 118, 97, 108, 117, 101, 32, 105, 115, 32,  0})),
        cppToString(start));
  }
  return explanation;
}

Object* RangeError::cppNew() {
  static std::map<String*, void*> v_ptrs = {
      {String::cppNew("cpp_equals"),
       reinterpret_cast<void*>(&Object::cpp_equals)},
      {String::cppNew("cppGet_hashCode"),
       reinterpret_cast<void*>(&Object::cppGet_hashCode)},
      {String::cppNew("toString"),
       reinterpret_cast<void*>(&ArgumentError::toString)},
      {String::cppNew("noSuchMethod"),
       reinterpret_cast<void*>(&Object::noSuchMethod)},
      {String::cppNew("cppGet_runtimeType"),
       reinterpret_cast<void*>(&Object::cppGet_runtimeType)},
      {String::cppNew("cppGet_stackTrace"),
       reinterpret_cast<void*>(&CppError::cppGet_stackTrace)},
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
Object* IndexError::cppCtr_(Object* cppThis,
                            Int* invalidValue,
                            Object* indexable,
                            String* name,
                            String* message,
                            Int* length) {
  CppObjectSet<Object*>(cppThis, String::cppNew("indexable"), indexable);
  CppObjectSet<Int*>(
      cppThis, String::cppNew("length"), reinterpret_cast<Int*>(([&]() {
        Int* cppLet_0 = length;
        return CppApi::cppBoolValue(Bool::cppNew(cppLet_0 == nullptr))
                   ? CppObjectGet<Object*>(indexable, String::cppNew("length"))
                   : cppLet_0;
      })()));

  return cppThis;
}

Object* IndexError::cppCtr_withLength(Object* cppThis,
                                      Int* invalidValue,
                                      Int* length,
                                      Object* indexable,
                                      String* name,
                                      String* message) {
  CppObjectSet<Int*>(cppThis, String::cppNew("length"), length);
  CppObjectSet<Object*>(cppThis, String::cppNew("indexable"), indexable);

  return cppThis;
}

Int* IndexError::cppGet_invalidValue(Object* cppThis) {
  return reinterpret_cast<Int*>(
      CppObjectGet<Object*>(cppThis, String::cppNew("invalidValue")));
}

Int* IndexError::check(Int* index,
                       Int* length,
                       Object* indexable,
                       String* name,
                       String* message) {
  if (CppApi::cppBoolValue(
          CppApi::cppBoolValue(Num::cpp_greaterThan(Int::cppNew(0), index)) ||
          CppApi::cppBoolValue(Num::cpp_greaterThanOrEqual(index, length)))) {
    CppApi::cppBoolValue(Bool::cppNew(name == nullptr))
        ? name = String::cppNew(new uint8_t[6]{105, 110, 100, 101, 120, 0})
        : nullptr;
    throw "ConstructorInvocation(new IndexError.withLength(index, length, indexable: indexable, name: name{String}, message: message))";
  }
  return index;
}

Int* IndexError::cppGet_start(Object* cppThis) {
  return Int::cppNew(0);
}

Int* IndexError::cppGet_end(Object* cppThis) {
  return Num::cpp_subtract(
      CppObjectGet<Int*>(cppThis, String::cppNew("length")), Int::cppNew(1));
}

String* IndexError::cppGet__errorName(Object* cppThis) {
  return String::cppNew(
      new uint8_t[11]{82, 97, 110, 103, 101, 69, 114, 114, 111, 114, 0});
}

String* IndexError::cppGet__errorExplanation(Object* cppThis) {
  print("assert");
  Int* invalidValue =
      cppApply<Int*>(cppThis, String::cppNew("cppGet_invalidValue"));
  if (CppApi::cppBoolValue(Num::cpp_lessThan(invalidValue, Int::cppNew(0)))) {
    return String::cppNew(
        new uint8_t[29]{58,  32,  105, 110, 100, 101, 120, 32,  109, 117,
                        115, 116, 32,  110, 111, 116, 32,  98,  101, 32,
                        110, 101, 103, 97,  116, 105, 118, 101, 0});
  }
  if (CppApi::cppBoolValue(Object::cpp_equals(
          CppObjectGet<Int*>(cppThis, String::cppNew("length")),
          Int::cppNew(0)))) {
    return String::cppNew(
        new uint8_t[23]{58, 32, 110, 111, 32, 105, 110, 100, 105, 99,  101, 115,
                        32, 97, 114, 101, 32, 118, 97,  108, 105, 100, 0});
  }
  return String::cpp_add(
      cppToString(String::cppNew(
          new uint8_t[29]{58,  32,  105, 110, 100, 101, 120, 32, 115, 104,
                          111, 117, 108, 100, 32,  98,  101, 32, 108, 101,
                          115, 115, 32,  116, 104, 97,  110, 32, 0})),
      cppToString(CppObjectGet<Int*>(cppThis, String::cppNew("length"))));
}

Object* IndexError::cppNew() {
  static std::map<String*, void*> v_ptrs = {
      {String::cppNew("cpp_equals"),
       reinterpret_cast<void*>(&Object::cpp_equals)},
      {String::cppNew("cppGet_hashCode"),
       reinterpret_cast<void*>(&Object::cppGet_hashCode)},
      {String::cppNew("toString"),
       reinterpret_cast<void*>(&ArgumentError::toString)},
      {String::cppNew("noSuchMethod"),
       reinterpret_cast<void*>(&Object::noSuchMethod)},
      {String::cppNew("cppGet_runtimeType"),
       reinterpret_cast<void*>(&Object::cppGet_runtimeType)},
      {String::cppNew("cppGet_stackTrace"),
       reinterpret_cast<void*>(&CppError::cppGet_stackTrace)},
      {String::cppNew("cppGet__errorName"),
       reinterpret_cast<void*>(&IndexError::cppGet__errorName)},
      {String::cppNew("cppGet__errorExplanation"),
       reinterpret_cast<void*>(&IndexError::cppGet__errorExplanation)},
      {String::cppNew("cppGet_invalidValue"),
       reinterpret_cast<void*>(&IndexError::cppGet_invalidValue)},
      {String::cppNew("cppGet_start"),
       reinterpret_cast<void*>(&IndexError::cppGet_start)},
      {String::cppNew("cppGet_end"),
       reinterpret_cast<void*>(&IndexError::cppGet_end)}};
  static Type* runtimeType = new Type("IndexError");
  Object* ptr = new ObjectImp(const_cast<Type*>(runtimeType), &v_ptrs);
  return ptr;
}

//  dart.core
Object* StateError::cppCtr_(Object* cppThis, String* message) {
  CppObjectSet<String*>(cppThis, String::cppNew("message"), message);

  return cppThis;
}

void StateError::_throwNew(String* msg) {
  throw "ConstructorInvocation(new StateError(msg))";
}

String* StateError::toString(Object* cppThis) {
  return String::cpp_add(
      cppToString(String::cppNew(
          new uint8_t[12]{66, 97, 100, 32, 115, 116, 97, 116, 101, 58, 32, 0})),
      cppToString(CppObjectGet<String*>(cppThis, String::cppNew("message"))));
}

Object* StateError::cppNew() {
  static std::map<String*, void*> v_ptrs = {
      {String::cppNew("cpp_equals"),
       reinterpret_cast<void*>(&Object::cpp_equals)},
      {String::cppNew("cppGet_hashCode"),
       reinterpret_cast<void*>(&Object::cppGet_hashCode)},
      {String::cppNew("toString"),
       reinterpret_cast<void*>(&StateError::toString)},
      {String::cppNew("noSuchMethod"),
       reinterpret_cast<void*>(&Object::noSuchMethod)},
      {String::cppNew("cppGet_runtimeType"),
       reinterpret_cast<void*>(&Object::cppGet_runtimeType)},
      {String::cppNew("cppGet_stackTrace"),
       reinterpret_cast<void*>(&CppError::cppGet_stackTrace)}};
  static Type* runtimeType = new Type("StateError");
  Object* ptr = new ObjectImp(const_cast<Type*>(runtimeType), &v_ptrs);
  return ptr;
}

//  dart.core
Object* MapEntry::cppCtr__(Object* cppThis, Object* key, Object* value) {
  CppObjectSet<Object*>(cppThis, String::cppNew("key"), key);
  CppObjectSet<Object*>(cppThis, String::cppNew("value"), value);

  return cppThis;
}

Object* MapEntry::cppEpt_(Object* key, Object* value) {
  return MapEntry::cppCtr__(MapEntry::cppNew(), key, value);
}

String* MapEntry::toString(Object* cppThis) {
  return String::cpp_add(
      String::cpp_add(
          String::cpp_add(
              String::cpp_add(cppToString(String::cppNew(new uint8_t[10]{
                                  77, 97, 112, 69, 110, 116, 114, 121, 40, 0})),
                              cppToString(CppObjectGet<Object*>(
                                  cppThis, String::cppNew("key")))),
              cppToString(String::cppNew(new uint8_t[3]{58, 32, 0}))),
          cppToString(CppObjectGet<Object*>(cppThis, String::cppNew("value")))),
      cppToString(String::cppNew(new uint8_t[2]{41, 0})));
}

Object* MapEntry::cppNew() {
  static std::map<String*, void*> v_ptrs = {
      {String::cppNew("cpp_equals"),
       reinterpret_cast<void*>(&Object::cpp_equals)},
      {String::cppNew("cppGet_hashCode"),
       reinterpret_cast<void*>(&Object::cppGet_hashCode)},
      {String::cppNew("toString"),
       reinterpret_cast<void*>(&MapEntry::toString)},
      {String::cppNew("noSuchMethod"),
       reinterpret_cast<void*>(&Object::noSuchMethod)},
      {String::cppNew("cppGet_runtimeType"),
       reinterpret_cast<void*>(&Object::cppGet_runtimeType)}};
  static Type* runtimeType = new Type("MapEntry");
  Object* ptr = new ObjectImp(const_cast<Type*>(runtimeType), &v_ptrs);
  return ptr;
}
