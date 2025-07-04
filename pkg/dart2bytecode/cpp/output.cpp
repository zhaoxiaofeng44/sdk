#include "./output.h"
//  library file:///Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/test/hello.dart
  CyBase * CyBase::cppCtr_(Int * c){this->a = c;
   
  return this;}

  void CyBase::test()
{
  print(String::cpp_add(this->aa, Int::toString(this->a)));
  print(this->cppGet_runtimeType()->toString());
}

//  library file:///Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/test/hello.dart
  CyFather * CyFather::cppCtr_(){this->b = Int::cppNew(2);this->base = CyBase::cppNew()->cppCtr_(Int::cppNew(3));
   
  return this;}

  CyFather * CyFather::cppCtr_ee(){this->b = Int::cppNew(2);this->base = CyBase::cppNew()->cppCtr_(Int::cppNew(3));
   
  return this;}

  void CyFather::myTest()
{
  print(String::cpp_add(String::cpp_add(this->base->cppGet_runtimeType()->toString(), String::cppNew("",sizeof(""))), Int::toString(this->b)));
}

//  library file:///Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/test/hello.dart
  CyChild * CyChild::cppCtr_(){this->c = Int::cppNew(2);
   
  return this;}

  void CyChild::myTest()
{
  CyChild * t = ([&](CyChild * cppLet_0){
  cppLet_0->test();
  cppLet_0->myTest();return cppLet_0;}(CyChild::cppNew()->cppCtr_()));
  print(String::cppNew("Gggg",sizeof("Gggg")));
}

//  library file:///Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/test/hello.dart
  CyComplexTest * CyComplexTest::cppCtr_(){
  CyChild * child = CyChild::cppNew()->cppCtr_();
  this->_messages->add(String::cppNew("Initialized",sizeof("Initialized")));
  print(String::cpp_add(String::cppNew("ComplexTest initialized",sizeof("ComplexTest initialized")), Int::toString(child->c)));
  return this;}

  void CyComplexTest::testConditionals()
{
  Int * x = Int::cppNew(10);
  Int * y = Int::cppNew(20);
  if ((Num::cpp_greaterThan(x, y))->getValue()) 
  {
    print(String::cppNew("x is greater than y",sizeof("x is greater than y")));
  } else 
  if ((Num::cpp_lessThan(x, y))->getValue()) 
  {
    print(String::cppNew("x is less than y",sizeof("x is less than y")));
  } else 
  {
    print(String::cppNew("x is equal to y",sizeof("x is equal to y")));
  }
  String * result = (Num::cpp_greaterThan(x, y))->getValue()? String::cppNew("x is greater",sizeof("x is greater")) : String::cppNew("y is greater or equal",sizeof("y is greater or equal"));
  print(String::cpp_add(cppToString(String::cppNew("Ternary result: ",sizeof("Ternary result: "))),cppToString(result)));
  String * nullableStr = nullptr;
  print(String::cpp_add(cppToString(String::cppNew("Null-aware: ",sizeof("Null-aware: "))),cppToString(([&](String * cppLet_0){return (Bool::cppNew(cppLet_0 == nullptr))->getValue()? String::cppNew("Default value",sizeof("Default value")) : cppLet_0;}(nullableStr)))));
}

  void CyComplexTest::testSwitch(Int * value)
{
  
  do {auto switchValue = value;if(switchValue == Int::cppNew(1)){
      print(String::cppNew("One",sizeof("One")));
      break;}if(switchValue == Int::cppNew(2)){
      print(String::cppNew("Two",sizeof("Two")));
      break;}if(switchValue == Int::cppNew(3)){
      print(String::cppNew("Three",sizeof("Three")));
      break;}{
      print(String::cppNew("Unknown number",sizeof("Unknown number")));}} while(0);
}

  void CyComplexTest::testLoops()
{
  print(String::cppNew("For-in loop:",sizeof("For-in loop:")));
  List * list = CppNewList(Int::cppNew(1),Int::cppNew(2),Int::cppNew(3),Int::cppNew(4),Int::cppNew(5));
  {
    Iterator * $sync_for_iterator = list->cppGet_iterator();
    {while (($sync_for_iterator->moveNext())->getValue()){
        {
          Int * item = reinterpret_cast<Int *>($sync_for_iterator->cppGet_current());
          {
            print(item);
          }
        }}}
  }
}

  void CyComplexTest::testmain()
{
}

//  library file:///Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/test/list.dart
  CppPointerArray * CppPointerArray::cppCtr_(Int * _length, void* * data){this->_length = _length;this->_data = ([&](void* * cppLet_0){return (Bool::cppNew(cppLet_0 == nullptr))->getValue()? CppPointerArray::cppCreatePointerArray(_length) : cppLet_0;}(data));
   
  return this;}

  Int * CppPointerArray::cppGet_length(){
return this->_length;}

  Object * CppPointerArray::getItem(Int * index){
return CppPointerArray::cppGetPointerArrayItem(this->_data, index);}

  void CppPointerArray::setItem(Int * index, Object * value){
return CppPointerArray::cppSetPointerArrayItem(this->_data, index, value);}

  void* * CppPointerArray::cppCreatePointerArray(Int * length)
{
  return CppNewList(length);
}

Unhandled expression type: DynamicInvocation
  Object * CppPointerArray::cppGetPointerArrayItem(void* * array, Int * index)
{
  return ;
}

Unhandled expression type: DynamicInvocation
  Object * CppPointerArray::cppSetPointerArrayItem(void* * array, Int * index, Object * value)
{
  return ([&](void* * cppLet_0){return ([&](Int * cppLet_0){return ([&](Object * cppLet_0){return ([&](void cppLet_0){return cppLet_0;}());}(value));}(index));}(array));
}

  void* * CppPointerArray::createArrayDirect(Int * length)
{
  return CppPointerArray::cppCreatePointerArray(length);
}

//  library file:///Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/test/list.dart
  CppByteArray * CppByteArray::cppCtr_(Int * _length, void* * data){this->_length = _length;this->_data = ([&](void* * cppLet_0){return (Bool::cppNew(cppLet_0 == nullptr))->getValue()? CppByteArray::cppCreateByteArray(_length) : cppLet_0;}(data));
   
  return this;}

  Int * CppByteArray::cppGet_length(){
return this->_length;}

  Int * CppByteArray::getItem(Int * index){
return CppByteArray::cppGetByteArrayItem(this->_data, index);}

  void CppByteArray::setItem(Int * index, Int * value){
return CppByteArray::cppSetByteArrayItem(this->_data, index, value);}

  void* * CppByteArray::cppCreateByteArray(Int * length)
{
  return CppNewList(length,Int::cppNew(0));
}

Unhandled expression type: DynamicInvocation
  Int * CppByteArray::cppGetByteArrayItem(void* * array, Int * index)
{
  return reinterpret_cast<Int *>();
}

Unhandled expression type: DynamicInvocation
  Int * CppByteArray::cppSetByteArrayItem(void* * array, Int * index, Int * value)
{
  return ([&](void* * cppLet_0){return ([&](Int * cppLet_0){return ([&](Int * cppLet_0){return ([&](void cppLet_0){return cppLet_0;}());}(value));}(index));}(array));
}

//  library file:///Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/test/list.dart
  String * CppList::toString()
{
  if ((Object::equals(this->_length,Int::cppNew(0)))->getValue()) 
  return String::cppNew("[]",sizeof("[]"));
  StringBuffer * buffer = StringBuffer::cppNew()->cppCtr_(String::cppNew("[",sizeof("[")));
  buffer->write(this->_array->getItem(Int::cppNew(0)));
  {Int * i = Int::cppNew(1);while ((Num::cpp_lessThan(i, this->_length))->getValue()){
      {
        buffer->write(String::cppNew(", ",sizeof(", ")));
        buffer->write(this->_array->getItem(i));
      }i = reinterpret_cast<Int *>(Num::cpp_add(i, Int::cppNew(1)));}}
  buffer->write(String::cppNew("]",sizeof("]")));
  return buffer->toString();
}

  CppList * CppList::cppCtr_fromCppArray(CppPointerArray * array){this->_length = array->cppGet_length();this->_array = array;
   
  return this;}

  CppList * CppList::cppCtr_(Int * length, Int * capacity){this->_length = length;this->_array = CppPointerArray::cppNew()->cppCtr_(length, nullptr);
   
  return this;}

  Int * CppList::_getSuggestCapacity(Int * newLen)
{
  return (Num::cpp_greaterThan(newLen, Int::cppNew(256)))->getValue()? newLen : Num::toInt(pow(Int::cppNew(2), Double::ceil(Double::cpp_divide(log(newLen), log(Int::cppNew(2))))));
}

  void CppList::ensureCapacity(Int * newLen)
{
  if ((Num::cpp_greaterThan(newLen, this->_array->cppGet_length()))->getValue()) 
  {
    CppPointerArray * newArray = CppPointerArray::cppNew()->cppCtr_(CppList::_getSuggestCapacity(newLen), nullptr);
    {Int * i = Int::cppNew(0);while ((Num::cpp_lessThan(i, this->_array->cppGet_length()))->getValue()){
        {
          newArray->setItem(i, this->_array->getItem(i));
        }i = reinterpret_cast<Int *>(Num::cpp_add(i, Int::cppNew(1)));}}
    this->_array = newArray;
  }
}

  Bool * CppList::any(Function * test)
{
  {Int * i = Int::cppNew(0);while ((Num::cpp_lessThan(i, this->_length))->getValue()){
      {
        if ((cppApply<Bool *>(test, reinterpret_cast<Object *>(this->_array->getItem(i))))->getValue()) 
        return Bool::cppNew(true);
      }i = reinterpret_cast<Int *>(Num::cpp_add(i, Int::cppNew(1)));}}
  return Bool::cppNew(false);
}

  Bool * CppList::contains(Object * element)
{
  {Int * i = Int::cppNew(0);while ((Num::cpp_lessThan(i, this->_length))->getValue()){
      {
        if ((Object::equals(this->_array->getItem(i),element))->getValue()) 
        return Bool::cppNew(true);
      }i = reinterpret_cast<Int *>(Num::cpp_add(i, Int::cppNew(1)));}}
  return Bool::cppNew(false);
}

  Object * CppList::elementAt(Int * index){
return reinterpret_cast<Object *>(this->_array->getItem(index));}

  Bool * CppList::every(Function * test)
{
  {Int * i = Int::cppNew(0);while ((Num::cpp_lessThan(i, this->_length))->getValue()){
      {
        if ((Bool::cpp_not(cppApply<Bool *>(test, reinterpret_cast<Object *>(this->_array->getItem(i)))))->getValue()) 
        return Bool::cppNew(false);
      }i = reinterpret_cast<Int *>(Num::cpp_add(i, Int::cppNew(1)));}}
  return Bool::cppNew(true);
}

  Iterable * CppList::expand(Function * toElements)
{
  List * result = CppNewList(Int::cppNew(0));
  {Int * i = Int::cppNew(0);while ((Num::cpp_lessThan(i, this->_length))->getValue()){
      {
        result->addAll(cppApply<Iterable *>(toElements, reinterpret_cast<Object *>(this->_array->getItem(i))));
      }i = reinterpret_cast<Int *>(Num::cpp_add(i, Int::cppNew(1)));}}
  return result;
}

  Object * CppList::firstWhere(Function * test, Function * orElse)
{
  {Int * i = Int::cppNew(0);while ((Num::cpp_lessThan(i, this->_length))->getValue()){
      {
        if ((cppApply<Bool *>(test, reinterpret_cast<Object *>(this->_array->getItem(i))))->getValue()) 
        return reinterpret_cast<Object *>(this->_array->getItem(i));
      }i = reinterpret_cast<Int *>(Num::cpp_add(i, Int::cppNew(1)));}}
  if ((Bool::cpp_not(Bool::cppNew(orElse == nullptr)))->getValue()) 
  return cppApply<Object *>(orElse);
  throw "ConstructorInvocation(new StateError(No element))";
}

  Object * CppList::fold(Object * initialValue, Function * combine)
{
  Object * value = initialValue;
  {Int * i = Int::cppNew(0);while ((Num::cpp_lessThan(i, this->_length))->getValue()){
      {
        value = reinterpret_cast<Object *>(cppApply<Object *>(combine, value, reinterpret_cast<Object *>(this->_array->getItem(i))));
      }i = reinterpret_cast<Int *>(Num::cpp_add(i, Int::cppNew(1)));}}
  return value;
}

  Iterable * CppList::followedBy(Iterable * other)
{
  return [&]{
  List * cppLet_0 = List::of(this, Bool::cppNew(true));
  cppLet_0->addAll(other);return cppLet_0}();
}

  void CppList::forEach(Function * action)
{
  {Int * i = Int::cppNew(0);while ((Num::cpp_lessThan(i, this->_length))->getValue()){
      {
        cppApply<void>(action, reinterpret_cast<Object *>(this->_array->getItem(i)));
      }i = reinterpret_cast<Int *>(Num::cpp_add(i, Int::cppNew(1)));}}
}

  Object * CppList::cppGet_first()
{
  if ((Object::equals(this->_length,Int::cppNew(0)))->getValue()) 
  throw "ConstructorInvocation(new StateError(No element))";
  return reinterpret_cast<Object *>(this->_array->getItem(Int::cppNew(0)));
}

  Object * CppList::cppGet_last()
{
  if ((Object::equals(this->_length,Int::cppNew(0)))->getValue()) 
  throw "ConstructorInvocation(new StateError(No element))";
  return reinterpret_cast<Object *>(this->_array->getItem(Num::cpp_subtract(this->_length, Int::cppNew(1))));
}

  Object * CppList::cppGet_single()
{
  if ((Object::equals(this->_length,Int::cppNew(0)))->getValue()) 
  throw "ConstructorInvocation(new StateError(No element))";
  if ((Num::cpp_greaterThan(this->_length, Int::cppNew(1)))->getValue()) 
  throw "ConstructorInvocation(new StateError(Too many elements))";
  return reinterpret_cast<Object *>(this->_array->getItem(Int::cppNew(0)));
}

  Bool * CppList::cppGet_isEmpty(){
return Object::equals(this->_length,Int::cppNew(0));}

  Bool * CppList::cppGet_isNotEmpty(){
return Bool::cpp_not(Object::equals(this->_length,Int::cppNew(0)));}

  Iterator * CppList::cppGet_iterator(){
return _CppListIterator::cppNew()->cppCtr_(this);}

  String * CppList::join(String * separator)
{
  if ((Object::equals(this->_length,Int::cppNew(0)))->getValue()) 
  return String::cppNew("",sizeof(""));
  return CppList::cppJoinListString(this->_array->_data, this->_length, separator);
}

Unhandled expression type: DynamicInvocation
  String * CppList::cppJoinListString(void* * strings, Int * length, String * separator)
{
  List * list = CppNewList(Int::cppNew(0));
  {Int * i = Int::cppNew(0);while ((Num::cpp_lessThan(i, length))->getValue()){
      {
        list->add(reinterpret_cast<String *>());
      }i = reinterpret_cast<Int *>(Num::cpp_add(i, Int::cppNew(1)));}}
  return list->join(separator);
}

  Object * CppList::lastWhere(Function * test, Function * orElse)
{
  {Int * i = Num::cpp_subtract(this->_length, Int::cppNew(1));while ((Num::cpp_greaterThanOrEqual(i, Int::cppNew(0)))->getValue()){
      {
        if ((cppApply<Bool *>(test, reinterpret_cast<Object *>(this->_array->getItem(i))))->getValue()) 
        return reinterpret_cast<Object *>(this->_array->getItem(i));
      }i = reinterpret_cast<Int *>(Num::cpp_subtract(i, Int::cppNew(1)));}}
  if ((Bool::cpp_not(Bool::cppNew(orElse == nullptr)))->getValue()) 
  return cppApply<Object *>(orElse);
  throw "ConstructorInvocation(new StateError(No element))";
}

  Iterable * CppList::map(Function * toElement)
{
  return Iterable::generate(this->_length, new LambdaWrapper<Object *,Int *>([&](Int * i) -> Object *{
  return cppApply<Object *>(toElement, reinterpret_cast<Object *>(this->_array->getItem(i)));}));
}

  Object * CppList::reduce(Function * combine)
{
  if ((Object::equals(this->_length,Int::cppNew(0)))->getValue()) 
  throw "ConstructorInvocation(new StateError(No element))";
  Object * value = reinterpret_cast<Object *>(this->_array->getItem(Int::cppNew(0)));
  {Int * i = Int::cppNew(1);while ((Num::cpp_lessThan(i, this->_length))->getValue()){
      {
        value = reinterpret_cast<Object *>(cppApply<Object *>(combine, value, reinterpret_cast<Object *>(this->_array->getItem(i))));
      }i = reinterpret_cast<Int *>(Num::cpp_add(i, Int::cppNew(1)));}}
  return value;
}

  void CppList::_quickSort(Int * low, Int * high, Function * compare)
{
  if ((Num::cpp_lessThan(low, high))->getValue()) 
  {
    Int * pi = this->_partition(low, high, compare);
    this->_quickSort(low, Num::cpp_subtract(pi, Int::cppNew(1)), compare);
    this->_quickSort(Num::cpp_add(pi, Int::cppNew(1)), high, compare);
  }
}

  Int * CppList::_partition(Int * low, Int * high, Function * compare)
{
  Object * pivot = reinterpret_cast<Object *>(this->_array->getItem(high));
  Int * i = Num::cpp_subtract(low, Int::cppNew(1));
  {Int * j = low;while ((Num::cpp_lessThan(j, high))->getValue()){
      {
        Object * current = reinterpret_cast<Object *>(this->_array->getItem(j));
        Bool * shouldSwap;
        if ((Bool::cpp_not(Bool::cppNew(compare == nullptr)))->getValue()) 
        {
          shouldSwap = reinterpret_cast<Bool *>(Num::cpp_lessThanOrEqual(cppApply<Int *>(compare, current, pivot), Int::cppNew(0)));
        } else 
        {
          shouldSwap = reinterpret_cast<Bool *>(Num::cpp_lessThanOrEqual(reinterpret_cast<Comparable *>(current)->compareTo(pivot), Int::cppNew(0)));
        }
        if ((shouldSwap)->getValue()) 
        {
          i = reinterpret_cast<Int *>(Num::cpp_add(i, Int::cppNew(1)));
          this->_swap(i, j);
        }
      }j = reinterpret_cast<Int *>(Num::cpp_add(j, Int::cppNew(1)));}}
  this->_swap(Num::cpp_add(i, Int::cppNew(1)), high);
  return Num::cpp_add(i, Int::cppNew(1));
}

  void CppList::_swap(Int * i, Int * j)
{
  Object * temp = reinterpret_cast<Object *>(this->_array->getItem(i));
  this->_array->setItem(i, this->_array->getItem(j));
  this->_array->setItem(j, temp);
}

  Iterable * CppList::take(Int * count)
{
  if ((Num::cpp_lessThan(count, Int::cppNew(0)))->getValue()) 
  throw "ConstructorInvocation(new ArgumentError(Count must be positive))";
  return Iterable::generate((Num::cpp_lessThan(count, this->_length))->getValue()? count : this->_length, new LambdaWrapper<Object *,Int *>([&](Int * i) -> Object *{
  return reinterpret_cast<Object *>(this->_array->getItem(i));}));
}

  Iterable * CppList::takeWhile(Function * test)
{
  {Int * i = Int::cppNew(0);while ((Num::cpp_lessThan(i, this->_length))->getValue()){
      {
        if ((Bool::cpp_not(cppApply<Bool *>(test, reinterpret_cast<Object *>(this->_array->getItem(i)))))->getValue()) 
        {
          return Iterable::generate(i, new LambdaWrapper<Object *,Int *>([&](Int * j) -> Object *{
          return reinterpret_cast<Object *>(this->_array->getItem(j));}));
        }
      }i = reinterpret_cast<Int *>(Num::cpp_add(i, Int::cppNew(1)));}}
  return this;
}

  List * CppList::toList(Bool * growable)
{
  return CppList::from(this, growable);
}

  Set * CppList::toSet()
{
  return LinkedHashSet::from(this);
}

  Iterable * CppList::where(Function * test)
{
  List * result = CppNewList(Int::cppNew(0));
  {Int * i = Int::cppNew(0);while ((Num::cpp_lessThan(i, this->_length))->getValue()){
      {
        Object * element = reinterpret_cast<Object *>(this->_array->getItem(i));
        if ((cppApply<Bool *>(test, element))->getValue()) 
        {
          result->add(element);
        }
      }i = reinterpret_cast<Int *>(Num::cpp_add(i, Int::cppNew(1)));}}
  return result;
}

  Iterable * CppList::whereType()
{
  List * result = CppNewList(Int::cppNew(0));
  {Int * i = Int::cppNew(0);while ((Num::cpp_lessThan(i, this->_length))->getValue()){
      {
        Object * element = this->_array->getItem(i);
        if ((Bool::cppNew(reinterpret_cast<Object *>(element) == nullptr))->getValue()) 
        {
          result->add(element);
        }
      }i = reinterpret_cast<Int *>(Num::cpp_add(i, Int::cppNew(1)));}}
  return result;
}

  Object * CppList::singleWhere(Function * test, Function * orElse)
{
  Object * result;
  Bool * found = Bool::cppNew(false);
  {Int * i = Int::cppNew(0);while ((Num::cpp_lessThan(i, this->_length))->getValue()){
      {
        if ((cppApply<Bool *>(test, reinterpret_cast<Object *>(this->_array->getItem(i))))->getValue()) 
        {
          if ((found)->getValue()) 
          throw "ConstructorInvocation(new StateError(Too many elements))";
          result = reinterpret_cast<Object *>(reinterpret_cast<Object *>(this->_array->getItem(i)));
          found = reinterpret_cast<Bool *>(Bool::cppNew(true));
        }
      }i = reinterpret_cast<Int *>(Num::cpp_add(i, Int::cppNew(1)));}}
  if ((found)->getValue()) 
  return result;
  if ((Bool::cpp_not(Bool::cppNew(orElse == nullptr)))->getValue()) 
  return cppApply<Object *>(orElse);
  throw "ConstructorInvocation(new StateError(No element))";
}

  Iterable * CppList::skip(Int * count)
{
  if ((Num::cpp_lessThan(count, Int::cppNew(0)))->getValue()) 
  throw "ConstructorInvocation(new ArgumentError(Count must be positive))";
  return Iterable::generate((Num::cpp_greaterThan(Num::cpp_subtract(this->_length, count), Int::cppNew(0)))->getValue()? Num::cpp_subtract(this->_length, count) : Int::cppNew(0), new LambdaWrapper<Object *,Int *>([&](Int * i) -> Object *{
  return reinterpret_cast<Object *>(this->_array->getItem(Num::cpp_add(count, i)));}));
}

  Iterable * CppList::skipWhile(Function * test)
{
  Int * skipCount = Int::cppNew(0);
  
  {Int * i = Int::cppNew(0);while ((Num::cpp_lessThan(i, this->_length))->getValue()){
      {
        if ((Bool::cpp_not(cppApply<Bool *>(test, reinterpret_cast<Object *>(this->_array->getItem(i)))))->getValue()) 
        break;
        skipCount = reinterpret_cast<Int *>(Num::cpp_add(skipCount, Int::cppNew(1)));
      }i = reinterpret_cast<Int *>(Num::cpp_add(i, Int::cppNew(1)));}}
  return Iterable::generate(Num::cpp_subtract(this->_length, skipCount), new LambdaWrapper<Object *,Int *>([&](Int * i) -> Object *{
  return reinterpret_cast<Object *>(this->_array->getItem(Num::cpp_add(skipCount, i)));}));
}

//  library file:///Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/test/list.dart
  _CppListIterator * _CppListIterator::cppCtr_(CppList * _list){this->_list = _list;
   
  return this;}

//  library file:///Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/test/list.dart
  String * CppSet::toString()
{
  if ((this->_list->cppGet_isEmpty())->getValue()) 
  return String::cppNew("{}",sizeof("{}"));
  StringBuffer * buffer = StringBuffer::cppNew()->cppCtr_(String::cppNew("{",sizeof("{")));
  Iterator * iterator = this->_list->cppGet_iterator();
  if ((iterator->moveNext())->getValue()) 
  {
    buffer->write(iterator->cppGet_current());
    while ((iterator->moveNext())->getValue()) 
    {
      buffer->write(String::cppNew(", ",sizeof(", ")));
      buffer->write(iterator->cppGet_current());
    }
  }
  buffer->write(String::cppNew("}",sizeof("}")));
  return buffer->toString();
}

  CppSet * CppSet::cppCtr_fromCppArray(CppPointerArray * array){this->_list = CppList::cppNew()->cppCtr_fromCppArray(array);
   
  return this;}

  CppSet * CppSet::cppCtr_(Int * capacity){this->_list = CppList::cppNew()->cppCtr_(Int::cppNew(0), capacity);
   
  return this;}

  Bool * CppSet::any(Function * test)
{
  {
    Iterator * $sync_for_iterator = this->_list->cppGet_iterator();
    {while (($sync_for_iterator->moveNext())->getValue()){
        {
          Object * element = $sync_for_iterator->cppGet_current();
          {
            if ((cppApply<Bool *>(test, element))->getValue()) 
            return Bool::cppNew(true);
          }
        }}}
  }
  return Bool::cppNew(false);
}

  Object * CppSet::elementAt(Int * index){
return this->_list->elementAt(index);}

  Bool * CppSet::every(Function * test)
{
  {
    Iterator * $sync_for_iterator = this->_list->cppGet_iterator();
    {while (($sync_for_iterator->moveNext())->getValue()){
        {
          Object * element = $sync_for_iterator->cppGet_current();
          {
            if ((Bool::cpp_not(cppApply<Bool *>(test, element)))->getValue()) 
            return Bool::cppNew(false);
          }
        }}}
  }
  return Bool::cppNew(true);
}

  Iterable * CppSet::expand(Function * toElements)
{
  List * result = CppNewList(Int::cppNew(0));
  {
    Iterator * $sync_for_iterator = this->_list->cppGet_iterator();
    {while (($sync_for_iterator->moveNext())->getValue()){
        {
          Object * element = $sync_for_iterator->cppGet_current();
          {
            result->addAll(cppApply<Iterable *>(toElements, element));
          }
        }}}
  }
  return result;
}

  Object * CppSet::firstWhere(Function * test, Function * orElse)
{
  {
    Iterator * $sync_for_iterator = this->_list->cppGet_iterator();
    {while (($sync_for_iterator->moveNext())->getValue()){
        {
          Object * element = $sync_for_iterator->cppGet_current();
          {
            if ((cppApply<Bool *>(test, element))->getValue()) 
            return element;
          }
        }}}
  }
  if ((Bool::cpp_not(Bool::cppNew(orElse == nullptr)))->getValue()) 
  return cppApply<Object *>(orElse);
  throw "ConstructorInvocation(new StateError(No element))";
}

  Object * CppSet::fold(Object * initialValue, Function * combine)
{
  Object * value = initialValue;
  {
    Iterator * $sync_for_iterator = this->_list->cppGet_iterator();
    {while (($sync_for_iterator->moveNext())->getValue()){
        {
          Object * element = $sync_for_iterator->cppGet_current();
          {
            value = reinterpret_cast<Object *>(cppApply<Object *>(combine, value, element));
          }
        }}}
  }
  return value;
}

  Iterable * CppSet::followedBy(Iterable * other)
{
  return [&]{
  List * cppLet_0 = List::of(this, Bool::cppNew(true));
  cppLet_0->addAll(other);return cppLet_0}();
}

  void CppSet::forEach(Function * action)
{
  {
    Iterator * $sync_for_iterator = this->_list->cppGet_iterator();
    {while (($sync_for_iterator->moveNext())->getValue()){
        {
          Object * element = $sync_for_iterator->cppGet_current();
          {
            cppApply<void>(action, element);
          }
        }}}
  }
}

  Object * CppSet::cppGet_first()
{
  if ((this->_list->cppGet_isEmpty())->getValue()) 
  throw "ConstructorInvocation(new StateError(No element))";
  return this->_list->cppGet_first();
}

  Object * CppSet::cppGet_last()
{
  if ((this->_list->cppGet_isEmpty())->getValue()) 
  throw "ConstructorInvocation(new StateError(No element))";
  return this->_list->cppGet_last();
}

  Object * CppSet::cppGet_single()
{
  if ((this->_list->cppGet_isEmpty())->getValue()) 
  throw "ConstructorInvocation(new StateError(No element))";
  if ((Num::cpp_greaterThan(this->_list->cppGet_length(), Int::cppNew(1)))->getValue()) 
  throw "ConstructorInvocation(new StateError(Too many elements))";
  return this->_list->cppGet_single();
}

  Bool * CppSet::cppGet_isEmpty(){
return this->_list->cppGet_isEmpty();}

  Bool * CppSet::cppGet_isNotEmpty(){
return this->_list->cppGet_isNotEmpty();}

  String * CppSet::join(String * separator)
{
  if ((this->_list->cppGet_isEmpty())->getValue()) 
  return String::cppNew("",sizeof(""));
  StringBuffer * buffer = StringBuffer::cppNew()->cppCtr_(String::cppNew("",sizeof("")));
  Iterator * iterator = this->_list->cppGet_iterator();
  if ((iterator->moveNext())->getValue()) 
  {
    buffer->write(iterator->cppGet_current());
    while ((iterator->moveNext())->getValue()) 
    {
      buffer->write(separator);
      buffer->write(iterator->cppGet_current());
    }
  }
  return buffer->toString();
}

  Object * CppSet::lastWhere(Function * test, Function * orElse)
{
  {Int * i = Num::cpp_subtract(this->_list->cppGet_length(), Int::cppNew(1));while ((Num::cpp_greaterThanOrEqual(i, Int::cppNew(0)))->getValue()){
      {
        Object * element = this->_list->cpp_subscript(i);
        if ((cppApply<Bool *>(test, element))->getValue()) 
        return element;
      }i = reinterpret_cast<Int *>(Num::cpp_subtract(i, Int::cppNew(1)));}}
  if ((Bool::cpp_not(Bool::cppNew(orElse == nullptr)))->getValue()) 
  return cppApply<Object *>(orElse);
  throw "ConstructorInvocation(new StateError(No element))";
}

  Int * CppSet::cppGet_length(){
return this->_list->cppGet_length();}

  Iterable * CppSet::map(Function * toElement)
{
  return this->_list->map(toElement);
}

  Object * CppSet::reduce(Function * combine)
{
  if ((this->_list->cppGet_isEmpty())->getValue()) 
  throw "ConstructorInvocation(new StateError(No element))";
  Object * value = this->_list->cppGet_first();
  {Int * i = Int::cppNew(1);while ((Num::cpp_lessThan(i, this->_list->cppGet_length()))->getValue()){
      {
        value = reinterpret_cast<Object *>(cppApply<Object *>(combine, value, this->_list->cpp_subscript(i)));
      }i = reinterpret_cast<Int *>(Num::cpp_add(i, Int::cppNew(1)));}}
  return value;
}

  Object * CppSet::singleWhere(Function * test, Function * orElse)
{
  Object * result;
  Bool * found = Bool::cppNew(false);
  {
    Iterator * $sync_for_iterator = this->_list->cppGet_iterator();
    {while (($sync_for_iterator->moveNext())->getValue()){
        {
          Object * element = $sync_for_iterator->cppGet_current();
          {
            if ((cppApply<Bool *>(test, element))->getValue()) 
            {
              if ((found)->getValue()) 
              throw "ConstructorInvocation(new StateError(Too many elements))";
              result = reinterpret_cast<Object *>(element);
              found = reinterpret_cast<Bool *>(Bool::cppNew(true));
            }
          }
        }}}
  }
  if ((found)->getValue()) 
  return result;
  if ((Bool::cpp_not(Bool::cppNew(orElse == nullptr)))->getValue()) 
  return cppApply<Object *>(orElse);
  throw "ConstructorInvocation(new StateError(No element))";
}

  Iterable * CppSet::skip(Int * count)
{
  return this->_list->skip(count);
}

  Iterable * CppSet::skipWhile(Function * test)
{
  return this->_list->skipWhile(test);
}

  Iterable * CppSet::take(Int * count)
{
  return this->_list->take(count);
}

  Iterable * CppSet::takeWhile(Function * test)
{
  return this->_list->takeWhile(test);
}

  List * CppSet::toList(Bool * growable)
{
  return this->_list->toList(growable);
}

  Iterable * CppSet::where(Function * test)
{
  List * result = CppNewList(Int::cppNew(0));
  {Int * i = Int::cppNew(0);while ((Num::cpp_lessThan(i, this->_list->cppGet_length()))->getValue()){
      {
        Object * element = this->_list->cpp_subscript(i);
        if ((cppApply<Bool *>(test, element))->getValue()) 
        {
          result->add(element);
        }
      }i = reinterpret_cast<Int *>(Num::cpp_add(i, Int::cppNew(1)));}}
  return result;
}

  Iterable * CppSet::whereType()
{
  List * result = CppNewList(Int::cppNew(0));
  {Int * i = Int::cppNew(0);while ((Num::cpp_lessThan(i, this->_list->cppGet_length()))->getValue()){
      {
        Object * element = this->_list->cpp_subscript(i);
        if ((Bool::cppNew(reinterpret_cast<Object *>(element) == nullptr))->getValue()) 
        {
          result->add(element);
        }
      }i = reinterpret_cast<Int *>(Num::cpp_add(i, Int::cppNew(1)));}}
  return result;
}

//  library file:///Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/test/list.dart
  String * CppMap::toString()
{
  if ((this->_list->cppGet_isEmpty())->getValue()) 
  return String::cppNew("{}",sizeof("{}"));
  StringBuffer * buffer = StringBuffer::cppNew()->cppCtr_(String::cppNew("{",sizeof("{")));
  Iterator * iterator = this->_list->cppGet_iterator();
  if ((iterator->moveNext())->getValue()) 
  {
    buffer->write(String::cpp_add(String::cpp_add(cppToString(reinterpret_cast<MapEntry *>(iterator->cppGet_current())->key),cppToString(String::cppNew(": ",sizeof(": ")))),cppToString(reinterpret_cast<MapEntry *>(iterator->cppGet_current())->value)));
    while ((iterator->moveNext())->getValue()) 
    {
      buffer->write(String::cpp_add(String::cpp_add(String::cpp_add(cppToString(String::cppNew(", ",sizeof(", "))),cppToString(reinterpret_cast<MapEntry *>(iterator->cppGet_current())->key)),cppToString(String::cppNew(": ",sizeof(": ")))),cppToString(reinterpret_cast<MapEntry *>(iterator->cppGet_current())->value)));
    }
  }
  buffer->write(String::cppNew("}",sizeof("}")));
  return buffer->toString();
}

  CppMap * CppMap::cppCtr_fromCppArray(CppPointerArray * array){this->_list = CppList::cppNew()->cppCtr_fromCppArray(array);
   
  return this;}

  CppMap * CppMap::cppCtr_(Int * capacity){this->_list = CppList::cppNew()->cppCtr_(Int::cppNew(0), capacity);
   
  return this;}

//  library file:///Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/test/list.dart
  String * CppStringBuffer::toString()
{
  return this->_parts->join(String::cppNew("",sizeof("")));
}

  CppStringBuffer * CppStringBuffer::cppCtr_(){this->_parts = CppList::cppNew()->cppCtr_(Int::cppNew(0), Int::cppNew(16));
   
  return this;}

  void CppStringBuffer::write(Object * obj)
{
  this->_parts->add(obj->toString());
}

  void CppStringBuffer::writeAll(Iterable * objects, String * separator)
{
  Iterator * iterator = objects->cppGet_iterator();
  if ((iterator->moveNext())->getValue()) 
  {
    this->_parts->add(reinterpret_cast<void* *>(iterator->cppGet_current())->toString());
    while ((iterator->moveNext())->getValue()) 
    {
      if ((separator->cppGet_isNotEmpty())->getValue()) 
      {
        this->_parts->add(separator);
      }
      this->_parts->add(reinterpret_cast<void* *>(iterator->cppGet_current())->toString());
    }
  }
}

  void CppStringBuffer::writeCharCode(Int * charCode)
{
  this->_parts->add(String::fromCharCode(charCode));
}

  void CppStringBuffer::writeln(Object * obj)
{
  this->_parts->add(obj->toString());
  this->_parts->add(String::cppNew("
",sizeof("
")));
}

  void CppStringBuffer::clear()
{
  this->_parts->clear();
}

  Int * CppStringBuffer::cppGet_length()
{
  return reinterpret_cast<Int *>(this->_parts->fold(Int::cppNew(0), new LambdaWrapper<Int *,Int *,String *>([&](Int * sum, String * part) -> Int *{
  return Num::cpp_add(sum, part->cppGet_length());})));
}

  Bool * CppStringBuffer::cppGet_isEmpty(){
return this->_parts->cppGet_isEmpty();}

  Bool * CppStringBuffer::cppGet_isNotEmpty(){
return this->_parts->cppGet_isNotEmpty();}

//  dart.collection
  CppWasmMap * CppWasmMap::cppCtr_(Map * map){
   
  return this;}

  Map * CppWasmMap::cast(){
return CppWasmMap::cppNew()->cppCtr_(this->_map->cast());}

//  dart._internal
  EfficientLengthIterable * EfficientLengthIterable::cppCtr_(){
   
  return this;}

   EfficientLengthIterable * EfficientLengthIterable::cppNew() {
        auto ptr = (EfficientLengthIterable *)malloc(sizeof(EfficientLengthIterable));
        return ptr;
    }

//  dart._internal
  HideEfficientLengthIterable * HideEfficientLengthIterable::cppCtr_(){
   
  return this;}

   HideEfficientLengthIterable * HideEfficientLengthIterable::cppNew() {
        auto ptr = (HideEfficientLengthIterable *)malloc(sizeof(HideEfficientLengthIterable));
        return ptr;
    }

//  dart._internal
  SubListIterable * SubListIterable::cppCtr_(Iterable * _iterable, Int * _start, Int * _endOrLength){this->_iterable = _iterable;this->_start = _start;this->_endOrLength = _endOrLength;
  RangeError::checkNotNegative(this->_start, String::cppNew("start",sizeof("start")), nullptr);
  Int * endOrLength = this->_endOrLength;
  if ((Bool::cpp_not(Bool::cppNew(endOrLength == nullptr)))->getValue()) 
  {
    RangeError::checkNotNegative(endOrLength, String::cppNew("end",sizeof("end")), nullptr);
    if ((Num::cpp_greaterThan(this->_start, endOrLength))->getValue()) 
    {
      throw "ConstructorInvocation(new RangeError.range(this.{SubListIterable._start}, 0, endOrLength{int}, start))";
    }
  }
  return this;}

  List * SubListIterable::toList(Bool * growable)
{
  Int * start = this->_start;
  Int * end = this->_iterable->cppGet_length();
  Int * endOrLength = this->_endOrLength;
  if ((Bool::cpp_not(Bool::cppNew(endOrLength == nullptr)) && Num::cpp_lessThan(endOrLength, end))->getValue()) 
  end = reinterpret_cast<Int *>(endOrLength);
  Int * length = Num::cpp_subtract(end, start);
  if ((Num::cpp_lessThanOrEqual(length, Int::cppNew(0)))->getValue()) 
  return List::empty(growable);
  List * result = List::filled(length, this->_iterable->elementAt(start), growable);
  {Int * i = Int::cppNew(1);while ((Num::cpp_lessThan(i, length))->getValue()){
      {
        result->cpp_subscriptAssign(i, this->_iterable->elementAt(Num::cpp_add(start, i)));
        if ((Num::cpp_lessThan(this->_iterable->cppGet_length(), end))->getValue()) 
        throw "ConstructorInvocation(new ConcurrentModificationError(this))";
      }i = reinterpret_cast<Int *>(Num::cpp_add(i, Int::cppNew(1)));}}
  return result;
}

  Int * SubListIterable::cppGet_length()
{
  Int * length = this->_iterable->cppGet_length();
  if ((Num::cpp_greaterThanOrEqual(this->_start, length))->getValue()) 
  return Int::cppNew(0);
  Int * endOrLength = this->_endOrLength;
  if ((Bool::cppNew(endOrLength == nullptr) || Num::cpp_greaterThanOrEqual(endOrLength, length))->getValue()) 
  {
    return Num::cpp_subtract(length, this->_start);
  }
  return Num::cpp_subtract(endOrLength, this->_start);
}

  Iterable * SubListIterable::take(Int * count)
{
  RangeError::checkNotNegative(count, String::cppNew("count",sizeof("count")), nullptr);
  Int * endOrLength = this->_endOrLength;
  if ((Bool::cppNew(endOrLength == nullptr))->getValue()) 
  {
    return SubListIterable::cppNew()->cppCtr_(this->_iterable, this->_start, Num::cpp_add(this->_start, count));
  } else 
  {
    Int * newEnd = Num::cpp_add(this->_start, count);
    if ((Num::cpp_lessThan(endOrLength, newEnd))->getValue()) 
    return this;
    return SubListIterable::cppNew()->cppCtr_(this->_iterable, this->_start, newEnd);
  }
}

  Iterable * SubListIterable::skip(Int * count)
{
  RangeError::checkNotNegative(count, String::cppNew("count",sizeof("count")), nullptr);
  Int * newStart = Num::cpp_add(this->_start, count);
  Int * endOrLength = this->_endOrLength;
  if ((Bool::cpp_not(Bool::cppNew(endOrLength == nullptr)) && Num::cpp_greaterThanOrEqual(newStart, endOrLength))->getValue()) 
  {
    return EmptyIterable::cppNew()->cppCtr_();
  }
  return SubListIterable::cppNew()->cppCtr_(this->_iterable, newStart, this->_endOrLength);
}

  Object * SubListIterable::elementAt(Int * index)
{
  Int * realIndex = Num::cpp_add(this->cppGet__startIndex(), index);
  if ((Num::cpp_lessThan(index, Int::cppNew(0)) || Num::cpp_greaterThanOrEqual(realIndex, this->cppGet__endIndex()))->getValue()) 
  {
    throw "ConstructorInvocation(new IndexError.withLength(index, this.{SubListIterable.length}, indexable: this, name: index))";
  }
  return this->_iterable->elementAt(realIndex);
}

  Iterable * SubListIterable::iterableOf(SubListIterable * subListIterable){
return subListIterable->_iterable;}

  Int * SubListIterable::startOf(SubListIterable * subListIterable){
return subListIterable->_start;}

  Int * SubListIterable::cppGet__endIndex()
{
  Int * length = this->_iterable->cppGet_length();
  Int * endOrLength = this->_endOrLength;
  if ((Bool::cppNew(endOrLength == nullptr) || Num::cpp_greaterThan(endOrLength, length))->getValue()) 
  return length;
  return endOrLength;
}

  Int * SubListIterable::cppGet__startIndex()
{
  Int * length = this->_iterable->cppGet_length();
  if ((Num::cpp_greaterThan(this->_start, length))->getValue()) 
  return length;
  return this->_start;
}

//  dart._internal
  ListIterator * ListIterator::cppCtr_(Iterable * iterable){this->_iterable = iterable;this->_length = iterable->cppGet_length();this->_index = Int::cppNew(0);
   
  return this;}

//  dart._internal
  EfficientLengthMappedIterable * EfficientLengthMappedIterable::cppCtr_(Iterable * iterable, Function * function){
   
  return this;}

//  dart._internal
  MappedListIterable * MappedListIterable::cppCtr_(Iterable * _source, Function * _f){this->_source = _source;this->_f = _f;
   
  return this;}

  Int * MappedListIterable::cppGet_length(){
return this->_source->cppGet_length();}

  Object * MappedListIterable::elementAt(Int * index){
return ([&](Object * cppLet_0){return cppApply<Object *>(this->_f, cppLet_0);}(this->_source->elementAt(index)));}

//  dart._internal
  WhereIterable * WhereIterable::cppCtr_(Iterable * _iterable, Function * _f){this->_iterable = _iterable;this->_f = _f;
   
  return this;}

  Iterator * WhereIterable::cppGet_iterator(){
return WhereIterator::cppNew()->cppCtr_(this->_iterable->cppGet_iterator(), this->_f);}

  Iterable * WhereIterable::map(Function * toElement){
return MappedIterable::cppNew()->cppCtr__(this, toElement);}

//  dart._internal
  ExpandIterable * ExpandIterable::cppCtr_(Iterable * _iterable, Function * _f){this->_iterable = _iterable;this->_f = _f;
   
  return this;}

  Iterator * ExpandIterable::cppGet_iterator(){
return ExpandIterator::cppNew()->cppCtr_(this->_iterable->cppGet_iterator(), this->_f);}

//  dart._internal
  Iterator * TakeIterable::cppGet_iterator()
{
  return TakeIterator::cppNew()->cppCtr_(this->_iterable->cppGet_iterator(), this->_takeCount);
}

  TakeIterable * TakeIterable::cppCtr__(Iterable * _iterable, Int * _takeCount){this->_iterable = _iterable;this->_takeCount = _takeCount;
   
  return this;}

  TakeIterable * TakeIterable::cppEpt_(Iterable * iterable, Int * takeCount)
{
  ArgumentError::checkNotNull(takeCount, String::cppNew("takeCount",sizeof("takeCount")));
  RangeError::checkNotNegative(takeCount, String::cppNew("takeCount",sizeof("takeCount")), nullptr);
  if ((Bool::cppNew(reinterpret_cast<EfficientLengthIterable *>(iterable) == nullptr))->getValue()) 
  {
    return EfficientLengthTakeIterable::cppNew()->cppCtr_(iterable, takeCount);
  }
  return TakeIterable::cppNew()->cppCtr__(iterable, takeCount);
}

//  dart._internal
  TakeWhileIterable * TakeWhileIterable::cppCtr_(Iterable * _iterable, Function * _f){this->_iterable = _iterable;this->_f = _f;
   
  return this;}

  Iterator * TakeWhileIterable::cppGet_iterator()
{
  return TakeWhileIterator::cppNew()->cppCtr_(this->_iterable->cppGet_iterator(), this->_f);
}

//  dart._internal
  SkipWhileIterable * SkipWhileIterable::cppCtr_(Iterable * _iterable, Function * _f){this->_iterable = _iterable;this->_f = _f;
   
  return this;}

  Iterator * SkipWhileIterable::cppGet_iterator()
{
  return SkipWhileIterator::cppNew()->cppCtr_(this->_iterable->cppGet_iterator(), this->_f);
}

//  dart._internal
  FollowedByIterable * FollowedByIterable::cppCtr_(Iterable * _first, Iterable * _second){this->_first = _first;this->_second = _second;
   
  return this;}

  Iterator * FollowedByIterable::cppGet_iterator(){
return FollowedByIterator::cppNew()->cppCtr_(this->_first, this->_second);}

  Bool * FollowedByIterable::contains(Object * value){
return this->_first->contains(value) || this->_second->contains(value);}

  Int * FollowedByIterable::cppGet_length(){
return Num::cpp_add(this->_first->cppGet_length(), this->_second->cppGet_length());}

  Bool * FollowedByIterable::cppGet_isEmpty(){
return this->_first->cppGet_isEmpty() && this->_second->cppGet_isEmpty();}

  Bool * FollowedByIterable::cppGet_isNotEmpty(){
return this->_first->cppGet_isNotEmpty() || this->_second->cppGet_isNotEmpty();}

  Object * FollowedByIterable::cppGet_first()
{
  Iterator * iterator = this->_first->cppGet_iterator();
  if ((iterator->moveNext())->getValue()) 
  return iterator->cppGet_current();
  return this->_second->cppGet_first();
}

  Object * FollowedByIterable::cppGet_last()
{
  Iterator * iterator = this->_second->cppGet_iterator();
  if ((iterator->moveNext())->getValue()) 
  {
    Object * last = iterator->cppGet_current();
    while ((iterator->moveNext())->getValue()) 
    last = reinterpret_cast<Object *>(iterator->cppGet_current());
    return last;
  }
  return this->_first->cppGet_last();
}

  FollowedByIterable * FollowedByIterable::firstEfficient(EfficientLengthIterable * first, Iterable * second)
{
  if ((Bool::cppNew(reinterpret_cast<EfficientLengthIterable *>(second) == nullptr))->getValue()) 
  {
    return EfficientLengthFollowedByIterable::cppNew()->cppCtr_(first, second);
  }
  return FollowedByIterable::cppNew()->cppCtr_(first, second);
}

//  dart._internal
  EfficientLengthFollowedByIterable * EfficientLengthFollowedByIterable::cppCtr_(EfficientLengthIterable * first, EfficientLengthIterable * second){
   
  return this;}

  Object * EfficientLengthFollowedByIterable::cppGet_first()
{
  if ((this->_first->cppGet_isNotEmpty())->getValue()) 
  return this->_first->cppGet_first();
  return this->_second->cppGet_first();
}

  Object * EfficientLengthFollowedByIterable::cppGet_last()
{
  if ((this->_second->cppGet_isNotEmpty())->getValue()) 
  return this->_second->cppGet_last();
  return this->_first->cppGet_last();
}

  Object * EfficientLengthFollowedByIterable::elementAt(Int * index)
{
  Int * firstLength = this->_first->cppGet_length();
  if ((Num::cpp_lessThan(index, firstLength))->getValue()) 
  return this->_first->elementAt(index);
  return this->_second->elementAt(Num::cpp_subtract(index, firstLength));
}

//  dart._internal
  WhereTypeIterable * WhereTypeIterable::cppCtr_(Iterable * _source){this->_source = _source;
   
  return this;}

  Iterator * WhereTypeIterable::cppGet_iterator(){
return WhereTypeIterator::cppNew()->cppCtr_(this->_source->cppGet_iterator());}

//  dart._internal
  ReversedListIterable * ReversedListIterable::cppCtr_(Iterable * _source){this->_source = _source;
   
  return this;}

  Int * ReversedListIterable::cppGet_length(){
return this->_source->cppGet_length();}

  Object * ReversedListIterable::elementAt(Int * index){
return this->_source->elementAt(Num::cpp_subtract(Num::cpp_subtract(this->_source->cppGet_length(), Int::cppNew(1)), index));}

//  dart._internal
  Sort * Sort::cppCtr_(){
   
  return this;}

//  dart.math
  Random * Random::cppEpt_(Int * seed)
{
  Int * state = _Random::_setupSeed((Bool::cppNew(seed == nullptr))->getValue()? _Random::_nextSeed() : seed);
  return ([&](_Random * cppLet_0){
  cppLet_0->_nextState();
  cppLet_0->_nextState();
  cppLet_0->_nextState();
  cppLet_0->_nextState();return cppLet_0;}(_Random::cppNew()->cppCtr__withState(state)));
}

  Random * Random::secure(){
return ;}

   Random * Random::cppNew() {
        auto ptr = (Random *)malloc(sizeof(Random));
        return ptr;
    }

//  nativewrappers
  NativeFieldWrapperClass1 * NativeFieldWrapperClass1::cppCtr_(){
   
  return this;}

//  nativewrappers
  NativeFieldWrapperClass2 * NativeFieldWrapperClass2::cppCtr_(){
   
  return this;}

//  nativewrappers
  NativeFieldWrapperClass3 * NativeFieldWrapperClass3::cppCtr_(){
   
  return this;}

//  nativewrappers
  NativeFieldWrapperClass4 * NativeFieldWrapperClass4::cppCtr_(){
   
  return this;}

//  dart.core
  Comparable * Comparable::cppCtr_(){
   
  return this;}

  Int * Comparable::compare(Comparable * a, Comparable * b){
return a->compareTo(b);}

   Comparable * Comparable::cppNew() {
        auto ptr = (Comparable *)malloc(sizeof(Comparable));
        return ptr;
    }

//  dart.core
  RangeError * RangeError::cppCtr_(void* * message){this->start = nullptr;this->end = nullptr;
   
  return this;}

  RangeError * RangeError::cppCtr_value(Num * value, String * name, String * message){this->start = nullptr;this->end = nullptr;
   
  return this;}

  String * RangeError::cppGet__errorName(){
return String::cppNew("RangeError",sizeof("RangeError"));}

  String * RangeError::cppGet__errorExplanation()
{
  print("assert");
  String * explanation = String::cppNew("",sizeof(""));
  Num * start = this->start;
  Num * end = this->end;
  if ((Bool::cppNew(start == nullptr))->getValue()) 
  {
    if ((Bool::cpp_not(Bool::cppNew(end == nullptr)))->getValue()) 
    {
      explanation = reinterpret_cast<String *>(String::cpp_add(cppToString(String::cppNew(": Not less than or equal to ",sizeof(": Not less than or equal to "))),cppToString(end)));
    }
  } else 
  if ((Bool::cppNew(end == nullptr))->getValue()) 
  {
    explanation = reinterpret_cast<String *>(String::cpp_add(cppToString(String::cppNew(": Not greater than or equal to ",sizeof(": Not greater than or equal to "))),cppToString(start)));
  } else 
  if ((Num::cpp_greaterThan(end, start))->getValue()) 
  {
    explanation = reinterpret_cast<String *>(String::cpp_add(String::cpp_add(String::cpp_add(cppToString(String::cppNew(": Not in inclusive range ",sizeof(": Not in inclusive range "))),cppToString(start)),cppToString(String::cppNew("..",sizeof("..")))),cppToString(end)));
  } else 
  if ((Num::cpp_lessThan(end, start))->getValue()) 
  {
    explanation = reinterpret_cast<String *>(String::cppNew(": Valid value range is empty",sizeof(": Valid value range is empty")));
  } else 
  {
    explanation = reinterpret_cast<String *>(String::cpp_add(cppToString(String::cppNew(": Only valid value is ",sizeof(": Only valid value is "))),cppToString(start)));
  }
  return explanation;
}

  RangeError * RangeError::cppCtr_range(Num * invalidValue, Int * minValue, Int * maxValue, String * name, String * message){this->start = minValue;this->end = maxValue;
   
  return this;}

  Num * RangeError::cppGet_invalidValue(){
return reinterpret_cast<Num *>(this->invalidValue);}

  RangeError * RangeError::index(Int * index, void* * indexable, String * name, String * message, Int * length){
return IndexError::cppNew()->cppCtr_(index, indexable, name, message, length);}

  Int * RangeError::checkValueInInterval(Int * value, Int * minValue, Int * maxValue, String * name, String * message)
{
  if ((Num::cpp_lessThan(value, minValue) || Num::cpp_greaterThan(value, maxValue))->getValue()) 
  {
    throw "ConstructorInvocation(new RangeError.range(value, minValue, maxValue, name, message))";
  }
  return value;
}

Unhandled expression type: DynamicGet
  Int * RangeError::checkValidIndex(Int * index, void* * indexable, String * name, Int * length, String * message)
{
  (Bool::cppNew(length == nullptr))->getValue()? length = reinterpret_cast<Int *>(reinterpret_cast<Int *>()) : nullptr;
  return IndexError::check(index, length, indexable, name, message);
}

  Int * RangeError::checkValidRange(Int * start, Int * end, Int * length, String * startName, String * endName, String * message)
{
  if ((Num::cpp_greaterThan(Int::cppNew(0), start) || Num::cpp_greaterThan(start, length))->getValue()) 
  {
    (Bool::cppNew(startName == nullptr))->getValue()? startName = reinterpret_cast<String *>(String::cppNew("start",sizeof("start"))) : nullptr;
    throw "ConstructorInvocation(new RangeError.range(start, 0, length, startName{String}, message))";
  }
  if ((Bool::cpp_not(Bool::cppNew(end == nullptr)))->getValue()) 
  {
    if ((Num::cpp_greaterThan(start, end) || Num::cpp_greaterThan(end, length))->getValue()) 
    {
      (Bool::cppNew(endName == nullptr))->getValue()? endName = reinterpret_cast<String *>(String::cppNew("end",sizeof("end"))) : nullptr;
      throw "ConstructorInvocation(new RangeError.range(end{int}, start, length, endName{String}, message))";
    }
    return end;
  }
  return length;
}

  Int * RangeError::checkNotNegative(Int * value, String * name, String * message)
{
  if ((Num::cpp_lessThan(value, Int::cppNew(0)))->getValue()) 
  {
    throw "ConstructorInvocation(new RangeError.range(value, 0, null, let final String? #0 = name in #0 == null ?{String} index : #0{String}, message))";
  }
  return value;
}

   RangeError * RangeError::cppNew() {
        auto ptr = (RangeError *)malloc(sizeof(RangeError));
        return ptr;
    }

  RangeError * RangeError::cppCtr_(void* * message){this->start = nullptr;this->end = nullptr;
   
  return this;}

  RangeError * RangeError::cppCtr_value(Num * value, String * name, String * message){this->start = nullptr;this->end = nullptr;
   
  return this;}

  String * RangeError::cppGet__errorName(){
return String::cppNew("RangeError",sizeof("RangeError"));}

  String * RangeError::cppGet__errorExplanation()
{
  print("assert");
  String * explanation = String::cppNew("",sizeof(""));
  Num * start = this->start;
  Num * end = this->end;
  if ((Bool::cppNew(start == nullptr))->getValue()) 
  {
    if ((Bool::cpp_not(Bool::cppNew(end == nullptr)))->getValue()) 
    {
      explanation = reinterpret_cast<String *>(String::cpp_add(cppToString(String::cppNew(": Not less than or equal to ",sizeof(": Not less than or equal to "))),cppToString(end)));
    }
  } else 
  if ((Bool::cppNew(end == nullptr))->getValue()) 
  {
    explanation = reinterpret_cast<String *>(String::cpp_add(cppToString(String::cppNew(": Not greater than or equal to ",sizeof(": Not greater than or equal to "))),cppToString(start)));
  } else 
  if ((Num::cpp_greaterThan(end, start))->getValue()) 
  {
    explanation = reinterpret_cast<String *>(String::cpp_add(String::cpp_add(String::cpp_add(cppToString(String::cppNew(": Not in inclusive range ",sizeof(": Not in inclusive range "))),cppToString(start)),cppToString(String::cppNew("..",sizeof("..")))),cppToString(end)));
  } else 
  if ((Num::cpp_lessThan(end, start))->getValue()) 
  {
    explanation = reinterpret_cast<String *>(String::cppNew(": Valid value range is empty",sizeof(": Valid value range is empty")));
  } else 
  {
    explanation = reinterpret_cast<String *>(String::cpp_add(cppToString(String::cppNew(": Only valid value is ",sizeof(": Only valid value is "))),cppToString(start)));
  }
  return explanation;
}

  RangeError * RangeError::cppCtr_range(Num * invalidValue, Int * minValue, Int * maxValue, String * name, String * message){this->start = minValue;this->end = maxValue;
   
  return this;}

  Num * RangeError::cppGet_invalidValue(){
return reinterpret_cast<Num *>(this->invalidValue);}

  RangeError * RangeError::index(Int * index, void* * indexable, String * name, String * message, Int * length){
return IndexError::cppNew()->cppCtr_(index, indexable, name, message, length);}

  Int * RangeError::checkValueInInterval(Int * value, Int * minValue, Int * maxValue, String * name, String * message)
{
  if ((Num::cpp_lessThan(value, minValue) || Num::cpp_greaterThan(value, maxValue))->getValue()) 
  {
    throw "ConstructorInvocation(new RangeError.range(value, minValue, maxValue, name, message))";
  }
  return value;
}

Unhandled expression type: DynamicGet
  Int * RangeError::checkValidIndex(Int * index, void* * indexable, String * name, Int * length, String * message)
{
  (Bool::cppNew(length == nullptr))->getValue()? length = reinterpret_cast<Int *>(reinterpret_cast<Int *>()) : nullptr;
  return IndexError::check(index, length, indexable, name, message);
}

  Int * RangeError::checkValidRange(Int * start, Int * end, Int * length, String * startName, String * endName, String * message)
{
  if ((Num::cpp_greaterThan(Int::cppNew(0), start) || Num::cpp_greaterThan(start, length))->getValue()) 
  {
    (Bool::cppNew(startName == nullptr))->getValue()? startName = reinterpret_cast<String *>(String::cppNew("start",sizeof("start"))) : nullptr;
    throw "ConstructorInvocation(new RangeError.range(start, 0, length, startName{String}, message))";
  }
  if ((Bool::cpp_not(Bool::cppNew(end == nullptr)))->getValue()) 
  {
    if ((Num::cpp_greaterThan(start, end) || Num::cpp_greaterThan(end, length))->getValue()) 
    {
      (Bool::cppNew(endName == nullptr))->getValue()? endName = reinterpret_cast<String *>(String::cppNew("end",sizeof("end"))) : nullptr;
      throw "ConstructorInvocation(new RangeError.range(end{int}, start, length, endName{String}, message))";
    }
    return end;
  }
  return length;
}

  Int * RangeError::checkNotNegative(Int * value, String * name, String * message)
{
  if ((Num::cpp_lessThan(value, Int::cppNew(0)))->getValue()) 
  {
    throw "ConstructorInvocation(new RangeError.range(value, 0, null, let final String? #0 = name in #0 == null ?{String} index : #0{String}, message))";
  }
  return value;
}

//  dart.core
  String * Iterable::toString(){
return Iterable::iterableToShortString(this, String::cppNew("(",sizeof("(")), String::cppNew(")",sizeof(")")));}

  Iterable * Iterable::cppCtr_(){
   
  return this;}

  Iterable * Iterable::generate(Int * count, Function * generator)
{
  if ((Num::cpp_lessThanOrEqual(count, Int::cppNew(0)))->getValue()) 
  return EmptyIterable::cppNew()->cppCtr_();
  if ((Bool::cppNew(generator == nullptr))->getValue()) 
  {
    Function * id = AA<_GeneratorIterable._id>AA;
    if ((Bool::cpp_not(Bool::cppNew(reinterpret_cast<Function *>(id) == nullptr)))->getValue()) 
    {
      throw "ConstructorInvocation(new ArgumentError(Generator must be supplied or element type must allow integers, generator))";
    }
    generator = reinterpret_cast<Function *>(id);
  }
  return _GeneratorIterable::cppNew()->cppCtr_(count, generator);
}

  Iterable * Iterable::withIterator(Function * iteratorFactory){
return _WithIteratorIterable::cppNew()->cppCtr_(iteratorFactory);}

  Iterable * Iterable::empty(){
return EmptyIterable::cppNew()->cppCtr_();}

  Iterable * Iterable::castFrom(Iterable * source){
return CastIterable::cppEpt_(source);}



  Iterable * Iterable::cast(){
return CastIterable::cppEpt_(this);}

  Iterable * Iterable::followedBy(Iterable * other)
{
  Iterable * self = this;
  if ((Bool::cppNew(reinterpret_cast<EfficientLengthIterable *>(self) == nullptr))->getValue()) 
  {
    return FollowedByIterable::firstEfficient(self, other);
  }
  return FollowedByIterable::cppNew()->cppCtr_(this, other);
}

  Iterable * Iterable::map(Function * toElement){
return MappedIterable::cppEpt_(this, toElement);}

  Iterable * Iterable::where(Function * test){
return WhereIterable::cppNew()->cppCtr_(this, test);}

  Iterable * Iterable::whereType(){
return WhereTypeIterable::cppNew()->cppCtr_(this);}

  Iterable * Iterable::expand(Function * toElements){
return ExpandIterable::cppNew()->cppCtr_(this, toElements);}

  Bool * Iterable::contains(Object * element)
{
  {
    Iterator * $sync_for_iterator = this->cppGet_iterator();
    {while (($sync_for_iterator->moveNext())->getValue()){
        {
          Object * e = $sync_for_iterator->cppGet_current();
          {
            if ((Object::equals(e,element))->getValue()) 
            return Bool::cppNew(true);
          }
        }}}
  }
  return Bool::cppNew(false);
}

  void Iterable::forEach(Function * action)
{
  {
    Iterator * $sync_for_iterator = this->cppGet_iterator();
    {while (($sync_for_iterator->moveNext())->getValue()){
        {
          Object * element = $sync_for_iterator->cppGet_current();
          cppApply<void>(action, element);
        }}}
  }
}

  Object * Iterable::reduce(Function * combine)
{
  Iterator * iterator = this->cppGet_iterator();
  if ((Bool::cpp_not(iterator->moveNext()))->getValue()) 
  {
    throw "StaticInvocation(IterableElementError.noElement())";
  }
  Object * value = iterator->cppGet_current();
  while ((iterator->moveNext())->getValue()) 
  {
    value = reinterpret_cast<Object *>(cppApply<Object *>(combine, value, iterator->cppGet_current()));
  }
  return value;
}

  Object * Iterable::fold(Object * initialValue, Function * combine)
{
  Object * value = initialValue;
  {
    Iterator * $sync_for_iterator = this->cppGet_iterator();
    {while (($sync_for_iterator->moveNext())->getValue()){
        {
          Object * element = $sync_for_iterator->cppGet_current();
          value = reinterpret_cast<Object *>(cppApply<Object *>(combine, value, element));
        }}}
  }
  return value;
}

  Bool * Iterable::every(Function * test)
{
  {
    Iterator * $sync_for_iterator = this->cppGet_iterator();
    {while (($sync_for_iterator->moveNext())->getValue()){
        {
          Object * element = $sync_for_iterator->cppGet_current();
          {
            if ((Bool::cpp_not(cppApply<Bool *>(test, element)))->getValue()) 
            return Bool::cppNew(false);
          }
        }}}
  }
  return Bool::cppNew(true);
}

  String * Iterable::join(String * separator)
{
  Iterator * iterator = this->cppGet_iterator();
  if ((Bool::cpp_not(iterator->moveNext()))->getValue()) 
  return String::cppNew("",sizeof(""));
  String * first = iterator->cppGet_current()->toString();
  if ((Bool::cpp_not(iterator->moveNext()))->getValue()) 
  return first;
  StringBuffer * buffer = StringBuffer::cppNew()->cppCtr_(first);
  if ((Bool::cppNew(separator == nullptr) || separator->cppGet_isEmpty())->getValue()) 
  {
    do 
    {
      buffer->write(iterator->cppGet_current()->toString());
    } while ((iterator->moveNext())->getValue());
  } else 
  {
    do 
    {
      ([&](StringBuffer * cppLet_0){
      cppLet_0->write(separator);
      cppLet_0->write(iterator->cppGet_current()->toString());return cppLet_0;}(buffer));
    } while ((iterator->moveNext())->getValue());
  }
  return buffer->toString();
}

  Bool * Iterable::any(Function * test)
{
  {
    Iterator * $sync_for_iterator = this->cppGet_iterator();
    {while (($sync_for_iterator->moveNext())->getValue()){
        {
          Object * element = $sync_for_iterator->cppGet_current();
          {
            if ((cppApply<Bool *>(test, element))->getValue()) 
            return Bool::cppNew(true);
          }
        }}}
  }
  return Bool::cppNew(false);
}

  List * Iterable::toList(Bool * growable){
return List::of(this, growable);}

  Set * Iterable::toSet(){
return LinkedHashSet::of(this);}

  Int * Iterable::cppGet_length()
{
  print("assert");
  Int * count = Int::cppNew(0);
  Iterator * it = this->cppGet_iterator();
  while ((it->moveNext())->getValue()) 
  {
    count = reinterpret_cast<Int *>(Num::cpp_add(count, Int::cppNew(1)));
  }
  return count;
}

  Bool * Iterable::cppGet_isEmpty(){
return Bool::cpp_not(this->cppGet_iterator()->moveNext());}

  Bool * Iterable::cppGet_isNotEmpty(){
return Bool::cpp_not(this->cppGet_isEmpty());}

  Iterable * Iterable::take(Int * count){
return TakeIterable::cppEpt_(this, count);}

  Iterable * Iterable::takeWhile(Function * test){
return TakeWhileIterable::cppNew()->cppCtr_(this, test);}

  Iterable * Iterable::skip(Int * count){
return SkipIterable::cppEpt_(this, count);}

  Iterable * Iterable::skipWhile(Function * test){
return SkipWhileIterable::cppNew()->cppCtr_(this, test);}

  Object * Iterable::cppGet_first()
{
  Iterator * it = this->cppGet_iterator();
  if ((Bool::cpp_not(it->moveNext()))->getValue()) 
  {
    throw "StaticInvocation(IterableElementError.noElement())";
  }
  return it->cppGet_current();
}

  Object * Iterable::cppGet_last()
{
  Iterator * it = this->cppGet_iterator();
  if ((Bool::cpp_not(it->moveNext()))->getValue()) 
  {
    throw "StaticInvocation(IterableElementError.noElement())";
  }
  Object * result;
  do 
  {
    result = reinterpret_cast<Object *>(it->cppGet_current());
  } while ((it->moveNext())->getValue());
  return result;
}

  Object * Iterable::cppGet_single()
{
  Iterator * it = this->cppGet_iterator();
  if ((Bool::cpp_not(it->moveNext()))->getValue()) 
  throw "StaticInvocation(IterableElementError.noElement())";
  Object * result = it->cppGet_current();
  if ((it->moveNext())->getValue()) 
  throw "StaticInvocation(IterableElementError.tooMany())";
  return result;
}

  Object * Iterable::firstWhere(Function * test, Function * orElse)
{
  {
    Iterator * $sync_for_iterator = this->cppGet_iterator();
    {while (($sync_for_iterator->moveNext())->getValue()){
        {
          Object * element = $sync_for_iterator->cppGet_current();
          {
            if ((cppApply<Bool *>(test, element))->getValue()) 
            return element;
          }
        }}}
  }
  if ((Bool::cpp_not(Bool::cppNew(orElse == nullptr)))->getValue()) 
  return cppApply<Object *>(orElse);
  throw "StaticInvocation(IterableElementError.noElement())";
}

  Object * Iterable::lastWhere(Function * test, Function * orElse)
{
  Iterator * iterator = this->cppGet_iterator();
  Object * result;
  do 
  {
    if ((Bool::cpp_not(iterator->moveNext()))->getValue()) 
    {
      if ((Bool::cpp_not(Bool::cppNew(orElse == nullptr)))->getValue()) 
      return cppApply<Object *>(orElse);
      throw "StaticInvocation(IterableElementError.noElement())";
    }
    result = reinterpret_cast<Object *>(iterator->cppGet_current());
  } while ((Bool::cpp_not(cppApply<Bool *>(test, result)))->getValue());
  while ((iterator->moveNext())->getValue()) 
  {
    Object * current = iterator->cppGet_current();
    if ((cppApply<Bool *>(test, current))->getValue()) 
    result = reinterpret_cast<Object *>(current);
  }
  return result;
}

  Object * Iterable::singleWhere(Function * test, Function * orElse)
{
  Iterator * iterator = this->cppGet_iterator();
  Object * result;
  do 
  {
    if ((Bool::cpp_not(iterator->moveNext()))->getValue()) 
    {
      if ((Bool::cpp_not(Bool::cppNew(orElse == nullptr)))->getValue()) 
      return cppApply<Object *>(orElse);
      throw "StaticInvocation(IterableElementError.noElement())";
    }
    result = reinterpret_cast<Object *>(iterator->cppGet_current());
  } while ((Bool::cpp_not(cppApply<Bool *>(test, result)))->getValue());
  while ((iterator->moveNext())->getValue()) 
  {
    if ((cppApply<Bool *>(test, iterator->cppGet_current()))->getValue()) 
    throw "StaticInvocation(IterableElementError.tooMany())";
  }
  return result;
}

  Object * Iterable::elementAt(Int * index)
{
  RangeError::checkNotNegative(index, String::cppNew("index",sizeof("index")), nullptr);
  Iterator * iterator = this->cppGet_iterator();
  Int * skipCount = index;
  while ((iterator->moveNext())->getValue()) 
  {
    if ((Object::equals(skipCount,Int::cppNew(0)))->getValue()) 
    return iterator->cppGet_current();
    skipCount = reinterpret_cast<Int *>(Num::cpp_subtract(skipCount, Int::cppNew(1)));
  }
  throw "ConstructorInvocation(new IndexError.withLength(index, index.{num.-}(skipCount), indexable: this, name: index))";
}

  String * Iterable::iterableToShortString(Iterable * iterable, String * leftDelimiter, String * rightDelimiter)
{
  if ((isToStringVisiting(iterable))->getValue()) 
  {
    if ((Object::equals(leftDelimiter,String::cppNew("(",sizeof("("))) && Object::equals(rightDelimiter,String::cppNew(")",sizeof(")"))))->getValue()) 
    {
      return String::cppNew("(...)",sizeof("(...)"));
    }
    return String::cpp_add(String::cpp_add(cppToString(leftDelimiter),cppToString(String::cppNew("...",sizeof("...")))),cppToString(rightDelimiter));
  }
  List * parts = CppNewList(Int::cppNew(0));
  ->add(iterable);
  try{ 
  {
    _iterablePartsToStrings(iterable, parts);
  }}finally {
  {
    print("assert");
    ->removeLast();
  }};
  return ([&](StringBuffer * cppLet_0){
  cppLet_0->writeAll(parts, String::cppNew(", ",sizeof(", ")));
  cppLet_0->write(rightDelimiter);return cppLet_0;}(StringBuffer::cppNew()->cppCtr_(leftDelimiter)))->toString();
}

  String * Iterable::iterableToFullString(Iterable * iterable, String * leftDelimiter, String * rightDelimiter)
{
  if ((isToStringVisiting(iterable))->getValue()) 
  {
    return String::cpp_add(String::cpp_add(cppToString(leftDelimiter),cppToString(String::cppNew("...",sizeof("...")))),cppToString(rightDelimiter));
  }
  StringBuffer * buffer = StringBuffer::cppNew()->cppCtr_(leftDelimiter);
  ->add(iterable);
  try{ 
  {
    buffer->writeAll(iterable, String::cppNew(", ",sizeof(", ")));
  }}finally {
  {
    print("assert");
    ->removeLast();
  }};
  buffer->write(rightDelimiter);
  return buffer->toString();
}

   Iterable * Iterable::cppNew() {
        auto ptr = (Iterable *)malloc(sizeof(Iterable));
        return ptr;
    }

  String * Iterable::toString(){
return Iterable::iterableToShortString(this, String::cppNew("(",sizeof("(")), String::cppNew(")",sizeof(")")));}

  Iterable * Iterable::cppCtr_(){
   
  return this;}

  Iterable * Iterable::generate(Int * count, Function * generator)
{
  if ((Num::cpp_lessThanOrEqual(count, Int::cppNew(0)))->getValue()) 
  return EmptyIterable::cppNew()->cppCtr_();
  if ((Bool::cppNew(generator == nullptr))->getValue()) 
  {
    Function * id = AA<_GeneratorIterable._id>AA;
    if ((Bool::cpp_not(Bool::cppNew(reinterpret_cast<Function *>(id) == nullptr)))->getValue()) 
    {
      throw "ConstructorInvocation(new ArgumentError(Generator must be supplied or element type must allow integers, generator))";
    }
    generator = reinterpret_cast<Function *>(id);
  }
  return _GeneratorIterable::cppNew()->cppCtr_(count, generator);
}

  Iterable * Iterable::withIterator(Function * iteratorFactory){
return _WithIteratorIterable::cppNew()->cppCtr_(iteratorFactory);}

  Iterable * Iterable::empty(){
return EmptyIterable::cppNew()->cppCtr_();}

  Iterable * Iterable::castFrom(Iterable * source){
return CastIterable::cppEpt_(source);}



  Iterable * Iterable::cast(){
return CastIterable::cppEpt_(this);}

  Iterable * Iterable::followedBy(Iterable * other)
{
  Iterable * self = this;
  if ((Bool::cppNew(reinterpret_cast<EfficientLengthIterable *>(self) == nullptr))->getValue()) 
  {
    return FollowedByIterable::firstEfficient(self, other);
  }
  return FollowedByIterable::cppNew()->cppCtr_(this, other);
}

  Iterable * Iterable::map(Function * toElement){
return MappedIterable::cppEpt_(this, toElement);}

  Iterable * Iterable::where(Function * test){
return WhereIterable::cppNew()->cppCtr_(this, test);}

  Iterable * Iterable::whereType(){
return WhereTypeIterable::cppNew()->cppCtr_(this);}

  Iterable * Iterable::expand(Function * toElements){
return ExpandIterable::cppNew()->cppCtr_(this, toElements);}

  Bool * Iterable::contains(Object * element)
{
  {
    Iterator * $sync_for_iterator = this->cppGet_iterator();
    {while (($sync_for_iterator->moveNext())->getValue()){
        {
          Object * e = $sync_for_iterator->cppGet_current();
          {
            if ((Object::equals(e,element))->getValue()) 
            return Bool::cppNew(true);
          }
        }}}
  }
  return Bool::cppNew(false);
}

  void Iterable::forEach(Function * action)
{
  {
    Iterator * $sync_for_iterator = this->cppGet_iterator();
    {while (($sync_for_iterator->moveNext())->getValue()){
        {
          Object * element = $sync_for_iterator->cppGet_current();
          cppApply<void>(action, element);
        }}}
  }
}

  Object * Iterable::reduce(Function * combine)
{
  Iterator * iterator = this->cppGet_iterator();
  if ((Bool::cpp_not(iterator->moveNext()))->getValue()) 
  {
    throw "StaticInvocation(IterableElementError.noElement())";
  }
  Object * value = iterator->cppGet_current();
  while ((iterator->moveNext())->getValue()) 
  {
    value = reinterpret_cast<Object *>(cppApply<Object *>(combine, value, iterator->cppGet_current()));
  }
  return value;
}

  Object * Iterable::fold(Object * initialValue, Function * combine)
{
  Object * value = initialValue;
  {
    Iterator * $sync_for_iterator = this->cppGet_iterator();
    {while (($sync_for_iterator->moveNext())->getValue()){
        {
          Object * element = $sync_for_iterator->cppGet_current();
          value = reinterpret_cast<Object *>(cppApply<Object *>(combine, value, element));
        }}}
  }
  return value;
}

  Bool * Iterable::every(Function * test)
{
  {
    Iterator * $sync_for_iterator = this->cppGet_iterator();
    {while (($sync_for_iterator->moveNext())->getValue()){
        {
          Object * element = $sync_for_iterator->cppGet_current();
          {
            if ((Bool::cpp_not(cppApply<Bool *>(test, element)))->getValue()) 
            return Bool::cppNew(false);
          }
        }}}
  }
  return Bool::cppNew(true);
}

  String * Iterable::join(String * separator)
{
  Iterator * iterator = this->cppGet_iterator();
  if ((Bool::cpp_not(iterator->moveNext()))->getValue()) 
  return String::cppNew("",sizeof(""));
  String * first = iterator->cppGet_current()->toString();
  if ((Bool::cpp_not(iterator->moveNext()))->getValue()) 
  return first;
  StringBuffer * buffer = StringBuffer::cppNew()->cppCtr_(first);
  if ((Bool::cppNew(separator == nullptr) || separator->cppGet_isEmpty())->getValue()) 
  {
    do 
    {
      buffer->write(iterator->cppGet_current()->toString());
    } while ((iterator->moveNext())->getValue());
  } else 
  {
    do 
    {
      ([&](StringBuffer * cppLet_0){
      cppLet_0->write(separator);
      cppLet_0->write(iterator->cppGet_current()->toString());return cppLet_0;}(buffer));
    } while ((iterator->moveNext())->getValue());
  }
  return buffer->toString();
}

  Bool * Iterable::any(Function * test)
{
  {
    Iterator * $sync_for_iterator = this->cppGet_iterator();
    {while (($sync_for_iterator->moveNext())->getValue()){
        {
          Object * element = $sync_for_iterator->cppGet_current();
          {
            if ((cppApply<Bool *>(test, element))->getValue()) 
            return Bool::cppNew(true);
          }
        }}}
  }
  return Bool::cppNew(false);
}

  List * Iterable::toList(Bool * growable){
return List::of(this, growable);}

  Set * Iterable::toSet(){
return LinkedHashSet::of(this);}

  Int * Iterable::cppGet_length()
{
  print("assert");
  Int * count = Int::cppNew(0);
  Iterator * it = this->cppGet_iterator();
  while ((it->moveNext())->getValue()) 
  {
    count = reinterpret_cast<Int *>(Num::cpp_add(count, Int::cppNew(1)));
  }
  return count;
}

  Bool * Iterable::cppGet_isEmpty(){
return Bool::cpp_not(this->cppGet_iterator()->moveNext());}

  Bool * Iterable::cppGet_isNotEmpty(){
return Bool::cpp_not(this->cppGet_isEmpty());}

  Iterable * Iterable::take(Int * count){
return TakeIterable::cppEpt_(this, count);}

  Iterable * Iterable::takeWhile(Function * test){
return TakeWhileIterable::cppNew()->cppCtr_(this, test);}

  Iterable * Iterable::skip(Int * count){
return SkipIterable::cppEpt_(this, count);}

  Iterable * Iterable::skipWhile(Function * test){
return SkipWhileIterable::cppNew()->cppCtr_(this, test);}

  Object * Iterable::cppGet_first()
{
  Iterator * it = this->cppGet_iterator();
  if ((Bool::cpp_not(it->moveNext()))->getValue()) 
  {
    throw "StaticInvocation(IterableElementError.noElement())";
  }
  return it->cppGet_current();
}

  Object * Iterable::cppGet_last()
{
  Iterator * it = this->cppGet_iterator();
  if ((Bool::cpp_not(it->moveNext()))->getValue()) 
  {
    throw "StaticInvocation(IterableElementError.noElement())";
  }
  Object * result;
  do 
  {
    result = reinterpret_cast<Object *>(it->cppGet_current());
  } while ((it->moveNext())->getValue());
  return result;
}

  Object * Iterable::cppGet_single()
{
  Iterator * it = this->cppGet_iterator();
  if ((Bool::cpp_not(it->moveNext()))->getValue()) 
  throw "StaticInvocation(IterableElementError.noElement())";
  Object * result = it->cppGet_current();
  if ((it->moveNext())->getValue()) 
  throw "StaticInvocation(IterableElementError.tooMany())";
  return result;
}

  Object * Iterable::firstWhere(Function * test, Function * orElse)
{
  {
    Iterator * $sync_for_iterator = this->cppGet_iterator();
    {while (($sync_for_iterator->moveNext())->getValue()){
        {
          Object * element = $sync_for_iterator->cppGet_current();
          {
            if ((cppApply<Bool *>(test, element))->getValue()) 
            return element;
          }
        }}}
  }
  if ((Bool::cpp_not(Bool::cppNew(orElse == nullptr)))->getValue()) 
  return cppApply<Object *>(orElse);
  throw "StaticInvocation(IterableElementError.noElement())";
}

  Object * Iterable::lastWhere(Function * test, Function * orElse)
{
  Iterator * iterator = this->cppGet_iterator();
  Object * result;
  do 
  {
    if ((Bool::cpp_not(iterator->moveNext()))->getValue()) 
    {
      if ((Bool::cpp_not(Bool::cppNew(orElse == nullptr)))->getValue()) 
      return cppApply<Object *>(orElse);
      throw "StaticInvocation(IterableElementError.noElement())";
    }
    result = reinterpret_cast<Object *>(iterator->cppGet_current());
  } while ((Bool::cpp_not(cppApply<Bool *>(test, result)))->getValue());
  while ((iterator->moveNext())->getValue()) 
  {
    Object * current = iterator->cppGet_current();
    if ((cppApply<Bool *>(test, current))->getValue()) 
    result = reinterpret_cast<Object *>(current);
  }
  return result;
}

  Object * Iterable::singleWhere(Function * test, Function * orElse)
{
  Iterator * iterator = this->cppGet_iterator();
  Object * result;
  do 
  {
    if ((Bool::cpp_not(iterator->moveNext()))->getValue()) 
    {
      if ((Bool::cpp_not(Bool::cppNew(orElse == nullptr)))->getValue()) 
      return cppApply<Object *>(orElse);
      throw "StaticInvocation(IterableElementError.noElement())";
    }
    result = reinterpret_cast<Object *>(iterator->cppGet_current());
  } while ((Bool::cpp_not(cppApply<Bool *>(test, result)))->getValue());
  while ((iterator->moveNext())->getValue()) 
  {
    if ((cppApply<Bool *>(test, iterator->cppGet_current()))->getValue()) 
    throw "StaticInvocation(IterableElementError.tooMany())";
  }
  return result;
}

  Object * Iterable::elementAt(Int * index)
{
  RangeError::checkNotNegative(index, String::cppNew("index",sizeof("index")), nullptr);
  Iterator * iterator = this->cppGet_iterator();
  Int * skipCount = index;
  while ((iterator->moveNext())->getValue()) 
  {
    if ((Object::equals(skipCount,Int::cppNew(0)))->getValue()) 
    return iterator->cppGet_current();
    skipCount = reinterpret_cast<Int *>(Num::cpp_subtract(skipCount, Int::cppNew(1)));
  }
  throw "ConstructorInvocation(new IndexError.withLength(index, index.{num.-}(skipCount), indexable: this, name: index))";
}

  String * Iterable::iterableToShortString(Iterable * iterable, String * leftDelimiter, String * rightDelimiter)
{
  if ((isToStringVisiting(iterable))->getValue()) 
  {
    if ((Object::equals(leftDelimiter,String::cppNew("(",sizeof("("))) && Object::equals(rightDelimiter,String::cppNew(")",sizeof(")"))))->getValue()) 
    {
      return String::cppNew("(...)",sizeof("(...)"));
    }
    return String::cpp_add(String::cpp_add(cppToString(leftDelimiter),cppToString(String::cppNew("...",sizeof("...")))),cppToString(rightDelimiter));
  }
  List * parts = CppNewList(Int::cppNew(0));
  ->add(iterable);
  try{ 
  {
    _iterablePartsToStrings(iterable, parts);
  }}finally {
  {
    print("assert");
    ->removeLast();
  }};
  return ([&](StringBuffer * cppLet_0){
  cppLet_0->writeAll(parts, String::cppNew(", ",sizeof(", ")));
  cppLet_0->write(rightDelimiter);return cppLet_0;}(StringBuffer::cppNew()->cppCtr_(leftDelimiter)))->toString();
}

  String * Iterable::iterableToFullString(Iterable * iterable, String * leftDelimiter, String * rightDelimiter)
{
  if ((isToStringVisiting(iterable))->getValue()) 
  {
    return String::cpp_add(String::cpp_add(cppToString(leftDelimiter),cppToString(String::cppNew("...",sizeof("...")))),cppToString(rightDelimiter));
  }
  StringBuffer * buffer = StringBuffer::cppNew()->cppCtr_(leftDelimiter);
  ->add(iterable);
  try{ 
  {
    buffer->writeAll(iterable, String::cppNew(", ",sizeof(", ")));
  }}finally {
  {
    print("assert");
    ->removeLast();
  }};
  buffer->write(rightDelimiter);
  return buffer->toString();
}

//  dart.core
  Iterator * Iterator::cppCtr_(){
   
  return this;}

   Iterator * Iterator::cppNew() {
        auto ptr = (Iterator *)malloc(sizeof(Iterator));
        return ptr;
    }

//  dart.core
  List * List::filled(Int * length, Object * fill, Bool * growable){
return (growable)->getValue()? CppNewList(length,fill) : _List::filled(length, fill);}

  List * List::from(Iterable * elements, Bool * growable)
{
  if ((Bool::cppNew(reinterpret_cast<Iterable *>(elements) == nullptr))->getValue()) 
  {
    return List::of(elements, growable);
  }
  List * list = CppNewList(Int::cppNew(0));
  {
    Iterator * $sync_for_iterator = elements->cppGet_iterator();
    {while (($sync_for_iterator->moveNext())->getValue()){
        {
          void* * cppLet_0 = reinterpret_cast<void* *>($sync_for_iterator->cppGet_current());
          {
            Object * e = reinterpret_cast<Object *>(cppLet_0);
            list->add(e);
          }
        }}}
  }
  if ((growable)->getValue()) 
  return list;
  return makeListFixedLength(list);
}

  List * List::of(Iterable * elements, Bool * growable){
return (growable)->getValue()? CppNewList(elements) : _List::of(elements);}

  List * List::unmodifiable(Iterable * elements)
{
  List * result = List::from(elements, Bool::cppNew(false));
  return makeFixedListUnmodifiable(result);
}

  void List::copyRange(List * target, Int * at, List * source, Int * start, Int * end)
{
  (Bool::cppNew(start == nullptr))->getValue()? start = reinterpret_cast<Int *>(Int::cppNew(0)) : nullptr;
  end = reinterpret_cast<Int *>(RangeError::checkValidRange(start, end, source->cppGet_length(), nullptr, nullptr, nullptr));
  if ((Bool::cppNew(end == nullptr))->getValue()) 
  {
    throw "StringLiteral(unreachable)";
  }
  Int * length = Num::cpp_subtract(end, start);
  if ((Num::cpp_lessThan(target->cppGet_length(), Num::cpp_add(at, length)))->getValue()) 
  {
    throw "ConstructorInvocation(new ArgumentError.value(target, target, Not big enough to hold ${length} elements at position ${at}))";
  }
  if ((Bool::cpp_not(identical(source, target)) || Num::cpp_greaterThanOrEqual(start, at))->getValue()) 
  {
    {Int * i = Int::cppNew(0);while ((Num::cpp_lessThan(i, length))->getValue()){
        {
          target->cpp_subscriptAssign(Num::cpp_add(at, i), source->cpp_subscript(Num::cpp_add(start, i)));
        }i = reinterpret_cast<Int *>(Num::cpp_add(i, Int::cppNew(1)));}}
  } else 
  {
    {Int * i = length;while ((Num::cpp_greaterThanOrEqual(i = reinterpret_cast<Int *>(Num::cpp_subtract(i, Int::cppNew(1))), Int::cppNew(0)))->getValue()){
        {
          target->cpp_subscriptAssign(Num::cpp_add(at, i), source->cpp_subscript(Num::cpp_add(start, i)));
        }}}
  }
}

  void List::writeIterable(List * target, Int * at, Iterable * source)
{
  RangeError::checkValueInInterval(at, Int::cppNew(0), target->cppGet_length(), String::cppNew("at",sizeof("at")), nullptr);
  Int * index = at;
  Int * targetLength = target->cppGet_length();
  {
    Iterator * $sync_for_iterator = source->cppGet_iterator();
    {while (($sync_for_iterator->moveNext())->getValue()){
        {
          Object * element = $sync_for_iterator->cppGet_current();
          {
            if ((Object::equals(index,targetLength))->getValue()) 
            {
              throw "ConstructorInvocation(new IndexError.withLength(index, targetLength, indexable: target))";
            }
            target->cpp_subscriptAssign(index, element);
            index = reinterpret_cast<Int *>(Num::cpp_add(index, Int::cppNew(1)));
          }
        }}}
  }
}

   List * List::cppNew() {
        auto ptr = (List *)malloc(sizeof(List));
        return ptr;
    }

//  dart.core
  Map * Map::_fromLiteral(List * elements)
{
  LinkedHashMap * map = _Map::cppNew()->cppCtr_();
  Int * len = elements->cppGet_length();
  {Int * i = Int::cppNew(1);while ((Num::cpp_lessThan(i, len))->getValue()){
      {
        map->cpp_subscriptAssign(reinterpret_cast<Object *>(reinterpret_cast<void* *>(elements->cpp_subscript(Num::cpp_subtract(i, Int::cppNew(1))))), reinterpret_cast<Object *>(reinterpret_cast<void* *>(elements->cpp_subscript(i))));
      }i = reinterpret_cast<Int *>(Num::cpp_add(i, Int::cppNew(2)));}}
  return map;
}

  Map * Map::cppEpt_(){
return _Map::cppNew()->cppCtr_();}

  Map * Map::from(Map * other){
return LinkedHashMap::from(other);}

  Map * Map::of(Map * other){
return LinkedHashMap::of(other);}

  Map * Map::unmodifiable(Map * other)
{
  return CppWasmMap::cppNew()->cppCtr_(LinkedHashMap::from(other));
}

  Map * Map::identity(){
return LinkedHashMap::identity();}

  Map * Map::fromIterable(Iterable * iterable, Function * key, Function * value){
return LinkedHashMap::fromIterable(iterable, key, value);}

  Map * Map::fromIterables(Iterable * keys, Iterable * values){
return LinkedHashMap::fromIterables(keys, values);}

  Map * Map::castFrom(Map * source){
return CastMap::cppNew()->cppCtr_(source);}

  Map * Map::fromEntries(Iterable * entries){
return ([&](Map * cppLet_0){
cppLet_0->addEntries(entries);return cppLet_0;}(CppNewMap()));}

   Map * Map::cppNew() {
        auto ptr = (Map *)malloc(sizeof(Map));
        return ptr;
    }

//  dart.core
  String * MapEntry::toString(){
return String::cpp_add(String::cpp_add(String::cpp_add(String::cpp_add(cppToString(String::cppNew("MapEntry(",sizeof("MapEntry("))),cppToString(this->key)),cppToString(String::cppNew(": ",sizeof(": ")))),cppToString(this->value)),cppToString(String::cppNew(")",sizeof(")"))));}

  MapEntry * MapEntry::cppCtr__(Object * key, Object * value){this->key = key;this->value = value;
   
  return this;}

  MapEntry * MapEntry::cppEpt_(Object * key, Object * value){
return MapEntry::cppNew()->cppCtr__(key, value);}

//  dart.core
  Set * Set::cppEpt_(){
return LinkedHashSet::cppEpt_(nullptr, nullptr, nullptr);}

  Set * Set::identity(){
return LinkedHashSet::identity();}

  Set * Set::from(Iterable * elements){
return LinkedHashSet::from(elements);}

  Set * Set::of(Iterable * elements){
return LinkedHashSet::of(elements);}

  Set * Set::unmodifiable(Iterable * elements){
return UnmodifiableSetView::cppNew()->cppCtr_([&]{
Set * cppLet_0 = LinkedHashSet::of(elements);return cppLet_0}());}

   Set * Set::cppNew() {
        auto ptr = (Set *)malloc(sizeof(Set));
        return ptr;
    }

//  dart.core
  StackTrace * StackTrace::cppCtr_(){
   
  return this;}

  StackTrace * StackTrace::fromString(String * stackTraceString){
return _StringStackTrace::cppNew()->cppCtr_(stackTraceString);}

  StackTrace * StackTrace::cppGet_current(){}

   StackTrace * StackTrace::cppNew() {
        auto ptr = (StackTrace *)malloc(sizeof(StackTrace));
        return ptr;
    }

//  dart.core
  String * StringBuffer::toString()
{
  this->_consumeBuffer();
  List * localParts = this->_parts;
  return (Object::equals(this->_partsCodeUnits,Int::cppNew(0)) || Bool::cppNew(localParts == nullptr))->getValue()? String::cppNew("",sizeof("")) : _StringBase::_concatRange(localParts, Int::cppNew(0), localParts->cppGet_length());
}

  StringBuffer * StringBuffer::cppCtr_(Object * content){
  this->write(content);
  return this;}

  void StringBuffer::_writeString(String * str)
{
  this->_consumeBuffer();
  this->_addPart(str);
}

  void StringBuffer::_ensureCapacity(Int * n)
{
  Uint16List * localBuffer = this->_buffer;
  if ((Bool::cppNew(localBuffer == nullptr))->getValue()) 
  {
    this->_buffer = Uint16List::cppEpt_(Int::cppNew(64));
  } else 
  if ((Num::cpp_greaterThan(Num::cpp_add(this->_bufferPosition, n), localBuffer->cppGet_length()))->getValue()) 
  {
    this->_consumeBuffer();
  }
}

  void StringBuffer::_consumeBuffer()
{
  if ((Object::equals(this->_bufferPosition,Int::cppNew(0)))->getValue()) 
  return;
  Bool * isLatin1 = Num::cpp_lessThanOrEqual(this->_bufferCodeUnitMagnitude, Int::cppNew(255));
  String * str = StringBuffer::_create(this->_buffer, this->_bufferPosition, isLatin1);
  this->_bufferPosition = this->_bufferCodeUnitMagnitude = Int::cppNew(0);
  this->_addPart(str);
}

  void StringBuffer::_addPart(String * str)
{
  List * localParts = this->_parts;
  Int * length = str->cppGet_length();
  this->_partsCodeUnits = Num::cpp_add(this->_partsCodeUnits, length);
  this->_partsCodeUnitsSinceCompaction = Num::cpp_add(this->_partsCodeUnitsSinceCompaction, length);
  if ((Bool::cppNew(localParts == nullptr))->getValue()) 
  {
    this->_parts = ([&](_GrowableList * cppLet_0){
    cppLet_0->add(str);return cppLet_0;}(CppNewList(Int::cppNew(10))));
  } else 
  {
    localParts->add(str);
    Int * partsSinceCompaction = Num::cpp_subtract(localParts->cppGet_length(), this->_partsCompactionIndex);
    if ((Object::equals(partsSinceCompaction,Int::cppNew(128)))->getValue()) 
    {
      this->_compact();
    }
  }
}

  void StringBuffer::_compact()
{
  List * localParts = this->_parts;
  if ((Num::cpp_lessThan(this->_partsCodeUnitsSinceCompaction, Int::cppNew(1024)))->getValue()) 
  {
    String * compacted = _StringBase::_concatRange(localParts, this->_partsCompactionIndex, Num::cpp_add(this->_partsCompactionIndex, Int::cppNew(128)));
    localParts->cppSet_length(Num::cpp_subtract(localParts->cppGet_length(), Int::cppNew(128)));
    localParts->add(compacted);
  }
  this->_partsCodeUnitsSinceCompaction = Int::cppNew(0);
  this->_partsCompactionIndex = localParts->cppGet_length();
}

  String * StringBuffer::_create(Uint16List * buffer, Int * length, Bool * isLatin1){}

  Int * StringBuffer::cppGet_length(){
return Num::cpp_add(this->_partsCodeUnits, this->_bufferPosition);}

  Bool * StringBuffer::cppGet_isEmpty(){
return Object::equals(this->cppGet_length(),Int::cppNew(0));}

  Bool * StringBuffer::cppGet_isNotEmpty(){
return Bool::cpp_not(this->cppGet_isEmpty());}

  void StringBuffer::clear()
{
  this->_parts = nullptr;
  this->_partsCodeUnits = this->_bufferPosition = this->_bufferCodeUnitMagnitude = Int::cppNew(0);
}

