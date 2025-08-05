import 'dart:core';
import 'dart:io';
import './lib/demo/api.dart';

/// 全局Void类型变量，用于替代void返回值
final Void = null;

/// 转换后的类: CppList
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/collection.dart

class CppList<E> extends CppIterable<E> implements List<E> {
  int _length;
  CppUserData _array;
CppList.fromCppArray(CppUserData array) : _length = CppApi.cppGetPointerArrayLength(array), _array = array, super()   {
    ;
  }
  
CppList(int length, int capacity) : _length = length, _array = CppApi.cppCreatePointerArray(length), super()   {
    ;
  }
  
  static int length(Object self) {
    return return this._length;;
  }
  
  Object ensureCapacity(int newLen) {
    {
  if (newLen > (CppApi.cppGetPointerArrayLength(this._array))) {
  CppUserData newArray = CppApi.cppCreatePointerArray(CppList._getSuggestCapacity(newLen));
  for (int i = 0; i < (CppApi.cppGetPointerArrayLength(this._array)); i = i + (1)) {
  {
  CppApi.cppSetPointerArrayItem(newArray, i, CppApi.cppGetPointerArrayItem(this._array, i));
}
}
  this._array = newArray;
}
}
  }
  
  static set length(Object self, int newLen) {
    {
  this.ensureCapacity(newLen);
  this._length = newLen;
}
  }
  
  Object [](int index) {
    return CppApi.cppGetPointerArrayItem(this._array, index) as Object;
  }
  
  Object []=(int index, Object value) {
    return CppApi.cppSetPointerArrayItem(this._array, index, value);
  }
  
  Object add(Object value) {
    {
  this.ensureCapacity(this._length + (1));
  CppApi.cppSetPointerArrayItem(this._array, (() { final int temp = this._length; return (() { final int temp = this._length = temp + (1); return temp; })(); })(), value);
}
  }
  
  Object addAll(Iterable iterable) {
    {
  {
  Iterator _sync_for_iterator = iterable.iterator;
  for (; _sync_for_iterator.moveNext();) {
  {
  Object element = _sync_for_iterator.current;
  {
  this.add(element);
}
}
}
}
}
  }
  
  bool any(Function(Object) => Object test) {
    {
  for (int i = 0; i < (this._length); i = i + (1)) {
  {
  if (test(CppApi.cppGetPointerArrayItem(this._array, i) as Object)) return true;
}
}
  return false;
}
  }
  
  Map asMap() {
    {
  Map map = {};
  for (int i = 0; i < (this._length); i = i + (1)) {
  {
  map[i] = CppApi.cppGetPointerArrayItem(this._array, i) as Object;
}
}
  return map;
}
  }
  
  List cast() {
    {
  return CppList.castFrom(this);
}
  }
  
  Object clear() {
    {
  this._length = 0;
}
  }
  
  bool contains(Object element) {
    {
  for (int i = 0; i < (this._length); i = i + (1)) {
  {
  if (CppApi.cppGetPointerArrayItem(this._array, i) == element) return true;
}
}
  return false;
}
  }
  
  Object elementAt(int index) {
    return CppApi.cppGetPointerArrayItem(this._array, index) as Object;
  }
  
  bool every(Function(Object) => Object test) {
    {
  for (int i = 0; i < (this._length); i = i + (1)) {
  {
  if (!test(CppApi.cppGetPointerArrayItem(this._array, i) as Object)) return false;
}
}
  return true;
}
  }
  
  Object fillRange(int start, int end, Object fillValue) {
    {
  for (int i = start; i < (end); i = i + (1)) {
  {
  CppApi.cppSetPointerArrayItem(this._array, i, (() { final Object temp = fillValue; return temp == null ? temp as Object : temp; })());
}
}
}
  }
  
  Object firstWhere(Function(Object) => Object test) {
    {
  for (int i = 0; i < (this._length); i = i + (1)) {
  {
  if (test(CppApi.cppGetPointerArrayItem(this._array, i) as Object)) {
  return CppApi.cppGetPointerArrayItem(this._array, i) as Object;
}
}
}
  if (!orElse == null) return orElse();
  throw new StateError("No element")
}
  }
  
  Object fold(Object initialValue, Function(ObjectObject) => Object combine) {
    {
  Object value = initialValue;
  for (int i = 0; i < (this._length); i = i + (1)) {
  {
  value = combine(value, CppApi.cppGetPointerArrayItem(this._array, i) as Object);
}
}
  return value;
}
  }
  
  Object forEach(Function(Object) => Object action) {
    {
  for (int i = 0; i < (this._length); i = i + (1)) {
  {
  action(CppApi.cppGetPointerArrayItem(this._array, i) as Object);
}
}
}
  }
  
  Iterable getRange(int start, int end) {
    {
  return CppList.from(Iterable.generate(end - (start), (int i) => return CppApi.cppGetPointerArrayItem(this._array, start + (i));));
}
  }
  
  int indexOf(Object element, int start) {
    {
  for (int i = start; i < (this._length); i = i + (1)) {
  {
  if (CppApi.cppGetPointerArrayItem(this._array, i) == element) return i;
}
}
  return 1.unary-();
}
  }
  
  int indexWhere(Function(Object) => Object test, int start) {
    {
  for (int i = start; i < (this._length); i = i + (1)) {
  {
  if (test(CppApi.cppGetPointerArrayItem(this._array, i) as Object)) return i;
}
}
  return 1.unary-();
}
  }
  
  Object insert(int index, Object element) {
    {
  if (index < (0) || index > (this._length)) throw new IndexError(index, this)
  this.ensureCapacity(this._length + (1));
  for (int i = this._length; i > (index); i = i - (1)) {
  {
  CppApi.cppSetPointerArrayItem(this._array, i, CppApi.cppGetPointerArrayItem(this._array, i - (1)));
}
}
  CppApi.cppSetPointerArrayItem(this._array, index, element);
  this._length = this._length + (1);
}
  }
  
  Object insertAll(int index, Iterable iterable) {
    {
  if (index < (0) || index > (this._length)) throw new IndexError(index, this)
  List elements = iterable.toList();
  int insertLength = elements.length;
  if (insertLength == 0) return;
  this.ensureCapacity(this._length + (insertLength));
  for (int i = this._length - (1); i >= (index); i = i - (1)) {
  {
  CppApi.cppSetPointerArrayItem(this._array, i + (insertLength), CppApi.cppGetPointerArrayItem(this._array, i));
}
}
  for (int i = 0; i < (insertLength); i = i + (1)) {
  {
  CppApi.cppSetPointerArrayItem(this._array, index + (i), elements[i]);
}
}
  this._length = this._length + (insertLength);
}
  }
  
  static Object first(Object self) {
    return {
  if (this._length == 0) throw new StateError("No element")
  return CppApi.cppGetPointerArrayItem(this._array, 0) as Object;
};
  }
  
  static set first(Object self, Object value) {
    {
  if (this._length == 0) throw new StateError("No element")
  CppApi.cppSetPointerArrayItem(this._array, 0, value);
}
  }
  
  static Object last(Object self) {
    return {
  if (this._length == 0) throw new StateError("No element")
  return CppApi.cppGetPointerArrayItem(this._array, this._length - (1)) as Object;
};
  }
  
  static set last(Object self, Object value) {
    {
  if (this._length == 0) throw new StateError("No element")
  CppApi.cppSetPointerArrayItem(this._array, this._length - (1), value);
}
  }
  
  static Object single(Object self) {
    return {
  if (this._length == 0) throw new StateError("No element")
  if (this._length > (1)) throw new StateError("Too many elements")
  return CppApi.cppGetPointerArrayItem(this._array, 0) as Object;
};
  }
  
  static bool isEmpty(Object self) {
    return return this._length == 0;;
  }
  
  static bool isNotEmpty(Object self) {
    return return !this._length == 0;;
  }
  
  static Iterator iterator(Object self) {
    return return new _CppListIterator(this);;
  }
  
  String join(String separator) {
    {
  if (this._length == 0) return "";
  return CppApi.cppJoinListString(this._array, separator);
}
  }
  
  int lastIndexOf(Object element, int start) {
    {
  int startIndex = (() { final int temp = start; return temp == null ? this._length - (1) : temp; })();
  for (int i = startIndex; i >= (0); i = i - (1)) {
  {
  if (CppApi.cppGetPointerArrayItem(this._array, i) == element) return i;
}
}
  return 1.unary-();
}
  }
  
  int lastIndexWhere(Function(Object) => Object test, int start) {
    {
  int startIndex = (() { final int temp = start; return temp == null ? this._length - (1) : temp; })();
  for (int i = startIndex; i >= (0); i = i - (1)) {
  {
  if (test(CppApi.cppGetPointerArrayItem(this._array, i) as Object)) return i;
}
}
  return 1.unary-();
}
  }
  
  Object lastWhere(Function(Object) => Object test) {
    {
  for (int i = this._length - (1); i >= (0); i = i - (1)) {
  {
  if (test(CppApi.cppGetPointerArrayItem(this._array, i) as Object)) {
  return CppApi.cppGetPointerArrayItem(this._array, i) as Object;
}
}
}
  if (!orElse == null) return orElse();
  throw new StateError("No element")
}
  }
  
  Object reduce(Function(ObjectObject) => Object combine) {
    {
  if (this._length == 0) throw new StateError("No element")
  Object value = CppApi.cppGetPointerArrayItem(this._array, 0) as Object;
  for (int i = 1; i < (this._length); i = i + (1)) {
  {
  value = combine(value, CppApi.cppGetPointerArrayItem(this._array, i) as Object);
}
}
  return value;
}
  }
  
  bool remove(Object value) {
    {
  int index = this.indexOf(value as Object);
  if (!index == 1.unary-()) {
  this.removeAt(index);
  return true;
}
  return false;
}
  }
  
  Object removeAt(int index) {
    {
  if (index < (0) || index >= (this._length)) throw new IndexError(index, this)
  Object element = CppApi.cppGetPointerArrayItem(this._array, index);
  for (int i = index; i < (this._length - (1)); i = i + (1)) {
  {
  CppApi.cppSetPointerArrayItem(this._array, i, CppApi.cppGetPointerArrayItem(this._array, i + (1)));
}
}
  this._length = this._length - (1);
  return element as Object;
}
  }
  
  Object removeLast() {
    {
  if (this._length == 0) throw new StateError("No element")
  return this.removeAt(this._length - (1));
}
  }
  
  Object removeRange(int start, int end) {
    {
  if (start < (0) || start > (this._length) || end < (start) || end > (this._length)) {
  throw new RangeError.range(start, 0, this._length)
}
  int length = end - (start);
  for (int i = start; i < (this._length - (length)); i = i + (1)) {
  {
  CppApi.cppSetPointerArrayItem(this._array, i, CppApi.cppGetPointerArrayItem(this._array, i + (length)));
}
}
  this._length = this._length - (length);
}
  }
  
  Object removeWhere(Function(Object) => Object test) {
    {
  int writeIndex = 0;
  for (int readIndex = 0; readIndex < (this._length); readIndex = readIndex + (1)) {
  {
  if (!test(CppApi.cppGetPointerArrayItem(this._array, readIndex) as Object)) {
  if (!writeIndex == readIndex) {
  CppApi.cppSetPointerArrayItem(this._array, writeIndex, CppApi.cppGetPointerArrayItem(this._array, readIndex));
}
  writeIndex = writeIndex + (1);
}
}
}
  this._length = writeIndex;
}
  }
  
  Object replaceRange(int start, int end, Iterable replacements) {
    {
  if (start < (0) || start > (this._length) || end < (start) || end > (this._length)) {
  throw new RangeError.range(start, 0, this._length)
}
  List replacementList = replacements.toList();
  int replacementLength = replacementList.length;
  int rangeLength = end - (start);
  if (replacementLength > (rangeLength)) {
  this.ensureCapacity(this._length + (replacementLength) - (rangeLength));
}
  if (!replacementLength == rangeLength) {
  for (int i = this._length - (1); i >= (end); i = i - (1)) {
  {
  CppApi.cppSetPointerArrayItem(this._array, i + (replacementLength) - (rangeLength), CppApi.cppGetPointerArrayItem(this._array, i));
}
}
}
  for (int i = 0; i < (replacementLength); i = i + (1)) {
  {
  CppApi.cppSetPointerArrayItem(this._array, start + (i), replacementList[i]);
}
}
  this._length = this._length + (replacementLength - (rangeLength));
}
  }
  
  Object retainWhere(Function(Object) => Object test) {
    {
  int writeIndex = 0;
  for (int readIndex = 0; readIndex < (this._length); readIndex = readIndex + (1)) {
  {
  if (test(CppApi.cppGetPointerArrayItem(this._array, readIndex) as Object)) {
  if (!writeIndex == readIndex) {
  CppApi.cppSetPointerArrayItem(this._array, writeIndex, CppApi.cppGetPointerArrayItem(this._array, readIndex));
}
  writeIndex = writeIndex + (1);
}
}
}
  this._length = writeIndex;
}
  }
  
  Object setAll(int index, Iterable iterable) {
    {
  if (index < (0) || index > (this._length)) throw new IndexError(index, this)
  int i = index;
  {
  Iterator _sync_for_iterator = iterable.iterator;
  for (; _sync_for_iterator.moveNext();) {
  {
  Object element = _sync_for_iterator.current;
  {
  if (i >= (this._length)) {
  this.add(element);
} else {
  CppApi.cppSetPointerArrayItem(this._array, i, element);
}
  i = i + (1);
}
}
}
}
}
  }
  
  Object setRange(int start, int end, Iterable iterable, int skipCount) {
    {
  if (start < (0) || start > (this._length) || end < (start) || end > (this._length)) {
  throw new RangeError.range(start, 0, this._length)
}
  Iterator iterator = iterable.iterator;
  for (int i = 0; i < (skipCount); i = i + (1)) {
  {
  if (!iterator.moveNext()) return;
}
}
  LabeledStatement(label0:
for (int i = start; i.{num.<}(end); i = i.{num.+}(1)) {
  if (!iterator.{Iterator.moveNext}()) break label0;
  CppApi.cppSetPointerArrayItem(this.{CppList._array}, i, iterator.{Iterator.current});
})
}
  }
  
  Object shuffle(Random random) {
    {
  random == null ? random = Random.() : null;
  for (int i = this._length - (1); i > (0); i = i - (1)) {
  {
  int j = random.nextInt(i + (1));
  Object temp = CppApi.cppGetPointerArrayItem(this._array, i);
  CppApi.cppSetPointerArrayItem(this._array, i, CppApi.cppGetPointerArrayItem(this._array, j));
  CppApi.cppSetPointerArrayItem(this._array, j, temp);
}
}
}
  }
  
  Object sort(Function(ObjectObject) => Object compare) {
    {
  if (this._length <= (1)) return;
  this._quickSort(0, this._length - (1), compare);
}
  }
  
  Object _quickSort(int low, int high, Function(ObjectObject) => Object compare) {
    {
  if (low < (high)) {
  int pi = this._partition(low, high, compare);
  this._quickSort(low, pi - (1), compare);
  this._quickSort(pi + (1), high, compare);
}
}
  }
  
  int _partition(int low, int high, Function(ObjectObject) => Object compare) {
    {
  Object pivot = CppApi.cppGetPointerArrayItem(this._array, high) as Object;
  int i = low - (1);
  for (int j = low; j < (high); j = j + (1)) {
  {
  Object current = CppApi.cppGetPointerArrayItem(this._array, j) as Object;
  bool shouldSwap;
  if (!compare == null) {
  shouldSwap = compare(current, pivot) <= (0);
} else {
  shouldSwap = current as Comparable.compareTo(pivot) <= (0);
}
  if (shouldSwap) {
  i = i + (1);
  this._swap(i, j);
}
}
}
  this._swap(i + (1), high);
  return i + (1);
}
  }
  
  Object _swap(int i, int j) {
    {
  Object temp = CppApi.cppGetPointerArrayItem(this._array, i) as Object;
  CppApi.cppSetPointerArrayItem(this._array, i, CppApi.cppGetPointerArrayItem(this._array, j));
  CppApi.cppSetPointerArrayItem(this._array, j, temp);
}
  }
  
  List sublist(int start, int end) {
    {
  int endIndex = (() { final int temp = end; return temp == null ? this._length : temp; })();
  if (start < (0) || start > (this._length) || endIndex < (start) || endIndex > (this._length)) {
  throw new RangeError.range(start, 0, this._length)
}
  return CppList.from(Iterable.generate(endIndex - (start), (int i) => return CppApi.cppGetPointerArrayItem(this._array, start + (i));));
}
  }
  
  List toList() {
    {
  return CppList.from(this, growable: growable);
}
  }
  
  Set toSet() {
    {
  return CppSet.from(this);
}
  }
  
  Object singleWhere(Function(Object) => Object test) {
    {
  Object result;
  bool found = false;
  for (int i = 0; i < (this._length); i = i + (1)) {
  {
  if (test(CppApi.cppGetPointerArrayItem(this._array, i) as Object)) {
  if (found) throw new StateError("Too many elements")
  result = CppApi.cppGetPointerArrayItem(this._array, i) as Object;
  found = true;
}
}
}
  if (found) return result!;
  if (!orElse == null) return orElse();
  throw new StateError("No element")
}
  }
  
  List +(List other) {
    {
  CppList result = new CppList(0, this._length + (other.length));
  for (int i = 0; i < (this._length); i = i + (1)) {
  {
  result.add(CppApi.cppGetPointerArrayItem(this._array, i) as Object);
}
}
  {
  Iterator _sync_for_iterator = other.iterator;
  for (; _sync_for_iterator.moveNext();) {
  {
  Object element = _sync_for_iterator.current;
  {
  result.add(element);
}
}
}
}
  return result;
}
  }
  
  String toString() {
    {
  if (this._length == 0) return "[]";
  StringBuffer buffer = new StringBuffer("[");
  buffer.write(CppApi.cppGetPointerArrayItem(this._array, 0));
  for (int i = 1; i < (this._length); i = i + (1)) {
  {
  buffer.write(", ");
  buffer.write(CppApi.cppGetPointerArrayItem(this._array, i));
}
}
  buffer.write("]");
  return buffer.toString();
}
  }
  
  static Object ensureCapacity(Object self, int newLen) {
    {
  if (newLen > (CppApi.cppGetPointerArrayLength(this._array))) {
  CppUserData newArray = CppApi.cppCreatePointerArray(CppList._getSuggestCapacity(newLen));
  for (int i = 0; i < (CppApi.cppGetPointerArrayLength(this._array)); i = i + (1)) {
  {
  CppApi.cppSetPointerArrayItem(newArray, i, CppApi.cppGetPointerArrayItem(this._array, i));
}
}
  this._array = newArray;
}
}
  }
  
  static Object add(Object self, Object value) {
    {
  this.ensureCapacity(this._length + (1));
  CppApi.cppSetPointerArrayItem(this._array, (() { final int temp = this._length; return (() { final int temp = this._length = temp + (1); return temp; })(); })(), value);
}
  }
  
  static Object addAll(Object self, Iterable iterable) {
    {
  {
  Iterator _sync_for_iterator = iterable.iterator;
  for (; _sync_for_iterator.moveNext();) {
  {
  Object element = _sync_for_iterator.current;
  {
  this.add(element);
}
}
}
}
}
  }
  
  static bool any(Object self, Function(Object) => Object test) {
    {
  for (int i = 0; i < (this._length); i = i + (1)) {
  {
  if (test(CppApi.cppGetPointerArrayItem(this._array, i) as Object)) return true;
}
}
  return false;
}
  }
  
  static Map asMap(Object self) {
    {
  Map map = {};
  for (int i = 0; i < (this._length); i = i + (1)) {
  {
  map[i] = CppApi.cppGetPointerArrayItem(this._array, i) as Object;
}
}
  return map;
}
  }
  
  static List cast(Object self) {
    {
  return CppList.castFrom(this);
}
  }
  
  static Object clear(Object self) {
    {
  this._length = 0;
}
  }
  
  static bool contains(Object self, Object element) {
    {
  for (int i = 0; i < (this._length); i = i + (1)) {
  {
  if (CppApi.cppGetPointerArrayItem(this._array, i) == element) return true;
}
}
  return false;
}
  }
  
  static Object elementAt(Object self, int index) {
    return CppApi.cppGetPointerArrayItem(this._array, index) as Object;
  }
  
  static bool every(Object self, Function(Object) => Object test) {
    {
  for (int i = 0; i < (this._length); i = i + (1)) {
  {
  if (!test(CppApi.cppGetPointerArrayItem(this._array, i) as Object)) return false;
}
}
  return true;
}
  }
  
  static Object fillRange(Object self, int start, int end, Object fillValue) {
    {
  for (int i = start; i < (end); i = i + (1)) {
  {
  CppApi.cppSetPointerArrayItem(this._array, i, (() { final Object temp = fillValue; return temp == null ? temp as Object : temp; })());
}
}
}
  }
  
  static Object firstWhere(Object self, Function(Object) => Object test) {
    {
  for (int i = 0; i < (this._length); i = i + (1)) {
  {
  if (test(CppApi.cppGetPointerArrayItem(this._array, i) as Object)) {
  return CppApi.cppGetPointerArrayItem(this._array, i) as Object;
}
}
}
  if (!orElse == null) return orElse();
  throw new StateError("No element")
}
  }
  
  static Object fold(Object self, Object initialValue, Function(ObjectObject) => Object combine) {
    {
  Object value = initialValue;
  for (int i = 0; i < (this._length); i = i + (1)) {
  {
  value = combine(value, CppApi.cppGetPointerArrayItem(this._array, i) as Object);
}
}
  return value;
}
  }
  
  static Object forEach(Object self, Function(Object) => Object action) {
    {
  for (int i = 0; i < (this._length); i = i + (1)) {
  {
  action(CppApi.cppGetPointerArrayItem(this._array, i) as Object);
}
}
}
  }
  
  static Iterable getRange(Object self, int start, int end) {
    {
  return CppList.from(Iterable.generate(end - (start), (int i) => return CppApi.cppGetPointerArrayItem(this._array, start + (i));));
}
  }
  
  static int indexOf(Object self, Object element, int start) {
    {
  for (int i = start; i < (this._length); i = i + (1)) {
  {
  if (CppApi.cppGetPointerArrayItem(this._array, i) == element) return i;
}
}
  return 1.unary-();
}
  }
  
  static int indexWhere(Object self, Function(Object) => Object test, int start) {
    {
  for (int i = start; i < (this._length); i = i + (1)) {
  {
  if (test(CppApi.cppGetPointerArrayItem(this._array, i) as Object)) return i;
}
}
  return 1.unary-();
}
  }
  
  static Object insert(Object self, int index, Object element) {
    {
  if (index < (0) || index > (this._length)) throw new IndexError(index, this)
  this.ensureCapacity(this._length + (1));
  for (int i = this._length; i > (index); i = i - (1)) {
  {
  CppApi.cppSetPointerArrayItem(this._array, i, CppApi.cppGetPointerArrayItem(this._array, i - (1)));
}
}
  CppApi.cppSetPointerArrayItem(this._array, index, element);
  this._length = this._length + (1);
}
  }
  
  static Object insertAll(Object self, int index, Iterable iterable) {
    {
  if (index < (0) || index > (this._length)) throw new IndexError(index, this)
  List elements = iterable.toList();
  int insertLength = elements.length;
  if (insertLength == 0) return;
  this.ensureCapacity(this._length + (insertLength));
  for (int i = this._length - (1); i >= (index); i = i - (1)) {
  {
  CppApi.cppSetPointerArrayItem(this._array, i + (insertLength), CppApi.cppGetPointerArrayItem(this._array, i));
}
}
  for (int i = 0; i < (insertLength); i = i + (1)) {
  {
  CppApi.cppSetPointerArrayItem(this._array, index + (i), elements[i]);
}
}
  this._length = this._length + (insertLength);
}
  }
  
  static String join(Object self, String separator) {
    {
  if (this._length == 0) return "";
  return CppApi.cppJoinListString(this._array, separator);
}
  }
  
  static int lastIndexOf(Object self, Object element, int start) {
    {
  int startIndex = (() { final int temp = start; return temp == null ? this._length - (1) : temp; })();
  for (int i = startIndex; i >= (0); i = i - (1)) {
  {
  if (CppApi.cppGetPointerArrayItem(this._array, i) == element) return i;
}
}
  return 1.unary-();
}
  }
  
  static int lastIndexWhere(Object self, Function(Object) => Object test, int start) {
    {
  int startIndex = (() { final int temp = start; return temp == null ? this._length - (1) : temp; })();
  for (int i = startIndex; i >= (0); i = i - (1)) {
  {
  if (test(CppApi.cppGetPointerArrayItem(this._array, i) as Object)) return i;
}
}
  return 1.unary-();
}
  }
  
  static Object lastWhere(Object self, Function(Object) => Object test) {
    {
  for (int i = this._length - (1); i >= (0); i = i - (1)) {
  {
  if (test(CppApi.cppGetPointerArrayItem(this._array, i) as Object)) {
  return CppApi.cppGetPointerArrayItem(this._array, i) as Object;
}
}
}
  if (!orElse == null) return orElse();
  throw new StateError("No element")
}
  }
  
  static Object reduce(Object self, Function(ObjectObject) => Object combine) {
    {
  if (this._length == 0) throw new StateError("No element")
  Object value = CppApi.cppGetPointerArrayItem(this._array, 0) as Object;
  for (int i = 1; i < (this._length); i = i + (1)) {
  {
  value = combine(value, CppApi.cppGetPointerArrayItem(this._array, i) as Object);
}
}
  return value;
}
  }
  
  static bool remove(Object self, Object value) {
    {
  int index = this.indexOf(value as Object);
  if (!index == 1.unary-()) {
  this.removeAt(index);
  return true;
}
  return false;
}
  }
  
  static Object removeAt(Object self, int index) {
    {
  if (index < (0) || index >= (this._length)) throw new IndexError(index, this)
  Object element = CppApi.cppGetPointerArrayItem(this._array, index);
  for (int i = index; i < (this._length - (1)); i = i + (1)) {
  {
  CppApi.cppSetPointerArrayItem(this._array, i, CppApi.cppGetPointerArrayItem(this._array, i + (1)));
}
}
  this._length = this._length - (1);
  return element as Object;
}
  }
  
  static Object removeLast(Object self) {
    {
  if (this._length == 0) throw new StateError("No element")
  return this.removeAt(this._length - (1));
}
  }
  
  static Object removeRange(Object self, int start, int end) {
    {
  if (start < (0) || start > (this._length) || end < (start) || end > (this._length)) {
  throw new RangeError.range(start, 0, this._length)
}
  int length = end - (start);
  for (int i = start; i < (this._length - (length)); i = i + (1)) {
  {
  CppApi.cppSetPointerArrayItem(this._array, i, CppApi.cppGetPointerArrayItem(this._array, i + (length)));
}
}
  this._length = this._length - (length);
}
  }
  
  static Object removeWhere(Object self, Function(Object) => Object test) {
    {
  int writeIndex = 0;
  for (int readIndex = 0; readIndex < (this._length); readIndex = readIndex + (1)) {
  {
  if (!test(CppApi.cppGetPointerArrayItem(this._array, readIndex) as Object)) {
  if (!writeIndex == readIndex) {
  CppApi.cppSetPointerArrayItem(this._array, writeIndex, CppApi.cppGetPointerArrayItem(this._array, readIndex));
}
  writeIndex = writeIndex + (1);
}
}
}
  this._length = writeIndex;
}
  }
  
  static Object replaceRange(Object self, int start, int end, Iterable replacements) {
    {
  if (start < (0) || start > (this._length) || end < (start) || end > (this._length)) {
  throw new RangeError.range(start, 0, this._length)
}
  List replacementList = replacements.toList();
  int replacementLength = replacementList.length;
  int rangeLength = end - (start);
  if (replacementLength > (rangeLength)) {
  this.ensureCapacity(this._length + (replacementLength) - (rangeLength));
}
  if (!replacementLength == rangeLength) {
  for (int i = this._length - (1); i >= (end); i = i - (1)) {
  {
  CppApi.cppSetPointerArrayItem(this._array, i + (replacementLength) - (rangeLength), CppApi.cppGetPointerArrayItem(this._array, i));
}
}
}
  for (int i = 0; i < (replacementLength); i = i + (1)) {
  {
  CppApi.cppSetPointerArrayItem(this._array, start + (i), replacementList[i]);
}
}
  this._length = this._length + (replacementLength - (rangeLength));
}
  }
  
  static Object retainWhere(Object self, Function(Object) => Object test) {
    {
  int writeIndex = 0;
  for (int readIndex = 0; readIndex < (this._length); readIndex = readIndex + (1)) {
  {
  if (test(CppApi.cppGetPointerArrayItem(this._array, readIndex) as Object)) {
  if (!writeIndex == readIndex) {
  CppApi.cppSetPointerArrayItem(this._array, writeIndex, CppApi.cppGetPointerArrayItem(this._array, readIndex));
}
  writeIndex = writeIndex + (1);
}
}
}
  this._length = writeIndex;
}
  }
  
  static Object setAll(Object self, int index, Iterable iterable) {
    {
  if (index < (0) || index > (this._length)) throw new IndexError(index, this)
  int i = index;
  {
  Iterator _sync_for_iterator = iterable.iterator;
  for (; _sync_for_iterator.moveNext();) {
  {
  Object element = _sync_for_iterator.current;
  {
  if (i >= (this._length)) {
  this.add(element);
} else {
  CppApi.cppSetPointerArrayItem(this._array, i, element);
}
  i = i + (1);
}
}
}
}
}
  }
  
  static Object setRange(Object self, int start, int end, Iterable iterable, int skipCount) {
    {
  if (start < (0) || start > (this._length) || end < (start) || end > (this._length)) {
  throw new RangeError.range(start, 0, this._length)
}
  Iterator iterator = iterable.iterator;
  for (int i = 0; i < (skipCount); i = i + (1)) {
  {
  if (!iterator.moveNext()) return;
}
}
  LabeledStatement(label0:
for (int i = start; i.{num.<}(end); i = i.{num.+}(1)) {
  if (!iterator.{Iterator.moveNext}()) break label0;
  CppApi.cppSetPointerArrayItem(this.{CppList._array}, i, iterator.{Iterator.current});
})
}
  }
  
  static Object shuffle(Object self, Random random) {
    {
  random == null ? random = Random.() : null;
  for (int i = this._length - (1); i > (0); i = i - (1)) {
  {
  int j = random.nextInt(i + (1));
  Object temp = CppApi.cppGetPointerArrayItem(this._array, i);
  CppApi.cppSetPointerArrayItem(this._array, i, CppApi.cppGetPointerArrayItem(this._array, j));
  CppApi.cppSetPointerArrayItem(this._array, j, temp);
}
}
}
  }
  
  static Object sort(Object self, Function(ObjectObject) => Object compare) {
    {
  if (this._length <= (1)) return;
  this._quickSort(0, this._length - (1), compare);
}
  }
  
  static Object _quickSort(Object self, int low, int high, Function(ObjectObject) => Object compare) {
    {
  if (low < (high)) {
  int pi = this._partition(low, high, compare);
  this._quickSort(low, pi - (1), compare);
  this._quickSort(pi + (1), high, compare);
}
}
  }
  
  static int _partition(Object self, int low, int high, Function(ObjectObject) => Object compare) {
    {
  Object pivot = CppApi.cppGetPointerArrayItem(this._array, high) as Object;
  int i = low - (1);
  for (int j = low; j < (high); j = j + (1)) {
  {
  Object current = CppApi.cppGetPointerArrayItem(this._array, j) as Object;
  bool shouldSwap;
  if (!compare == null) {
  shouldSwap = compare(current, pivot) <= (0);
} else {
  shouldSwap = current as Comparable.compareTo(pivot) <= (0);
}
  if (shouldSwap) {
  i = i + (1);
  this._swap(i, j);
}
}
}
  this._swap(i + (1), high);
  return i + (1);
}
  }
  
  static Object _swap(Object self, int i, int j) {
    {
  Object temp = CppApi.cppGetPointerArrayItem(this._array, i) as Object;
  CppApi.cppSetPointerArrayItem(this._array, i, CppApi.cppGetPointerArrayItem(this._array, j));
  CppApi.cppSetPointerArrayItem(this._array, j, temp);
}
  }
  
  static List sublist(Object self, int start, int end) {
    {
  int endIndex = (() { final int temp = end; return temp == null ? this._length : temp; })();
  if (start < (0) || start > (this._length) || endIndex < (start) || endIndex > (this._length)) {
  throw new RangeError.range(start, 0, this._length)
}
  return CppList.from(Iterable.generate(endIndex - (start), (int i) => return CppApi.cppGetPointerArrayItem(this._array, start + (i));));
}
  }
  
  static List toList(Object self) {
    {
  return CppList.from(this, growable: growable);
}
  }
  
  static Set toSet(Object self) {
    {
  return CppSet.from(this);
}
  }
  
  static Object singleWhere(Object self, Function(Object) => Object test) {
    {
  Object result;
  bool found = false;
  for (int i = 0; i < (this._length); i = i + (1)) {
  {
  if (test(CppApi.cppGetPointerArrayItem(this._array, i) as Object)) {
  if (found) throw new StateError("Too many elements")
  result = CppApi.cppGetPointerArrayItem(this._array, i) as Object;
  found = true;
}
}
}
  if (found) return result!;
  if (!orElse == null) return orElse();
  throw new StateError("No element")
}
  }
  
  static String toString(Object self) {
    {
  if (this._length == 0) return "[]";
  StringBuffer buffer = new StringBuffer("[");
  buffer.write(CppApi.cppGetPointerArrayItem(this._array, 0));
  for (int i = 1; i < (this._length); i = i + (1)) {
  {
  buffer.write(", ");
  buffer.write(CppApi.cppGetPointerArrayItem(this._array, i));
}
}
  buffer.write("]");
  return buffer.toString();
}
  }
  
  Object operator [](int index) {
    return CppApi.cppGetPointerArrayItem(this._array, index) as Object;
  }
  
  Object operator []=(int index, Object value) {
    return CppApi.cppSetPointerArrayItem(this._array, index, value);
  }
  
  List operator +(List other) {
    {
  CppList result = new CppList(0, this._length + (other.length));
  for (int i = 0; i < (this._length); i = i + (1)) {
  {
  result.add(CppApi.cppGetPointerArrayItem(this._array, i) as Object);
}
}
  {
  Iterator _sync_for_iterator = other.iterator;
  for (; _sync_for_iterator.moveNext();) {
  {
  Object element = _sync_for_iterator.current;
  {
  result.add(element);
}
}
}
}
  return result;
}
  }
  
}

/// 转换后的类: _CppListIterator
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/collection.dart

class _CppListIterator<E> implements Iterator<E> {
  int _index;
  late CppList _list;
_CppListIterator(CppList _list) : _list = _list, super()   {
    ;
  }
  
  static Object current(Object self) {
    return return this._list[this._index];;
  }
  
  bool moveNext() {
    {
  this._index = this._index + (1);
  return this._index < (this._list.length);
}
  }
  
  static bool moveNext(Object self) {
    {
  this._index = this._index + (1);
  return this._index < (this._list.length);
}
  }
  
}

/// 转换后的类: CppSet
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/collection.dart

class CppSet<E> extends CppIterable<E> implements Set<E> {
  late CppList _list;
CppSet.fromCppArray(CppUserData array) : _list = new CppList.fromCppArray(array), super()   {
    ;
  }
  
CppSet(int capacity) : _list = new CppList(0, capacity), super()   {
    ;
  }
  
  bool add(Object value) {
    {
  if (this.contains(value)) {
  return false;
}
  this._list.add(value);
  return true;
}
  }
  
  Object addAll(Iterable elements) {
    {
  {
  Iterator _sync_for_iterator = elements.iterator;
  for (; _sync_for_iterator.moveNext();) {
  {
  Object element = _sync_for_iterator.current;
  {
  this.add(element);
}
}
}
}
}
  }
  
  Set cast() {
    {
  return CppSet.castFrom(this);
}
  }
  
  Object clear() {
    {
  this._list.clear();
}
  }
  
  bool contains(Object element) {
    {
  for (int i = 0; i < (this._list.length); i = i + (1)) {
  {
  if (element == this._list[i]) {
  return true;
}
}
}
  return false;
}
  }
  
  bool containsAll(Iterable other) {
    {
  {
  Iterator _sync_for_iterator = other.iterator;
  for (; _sync_for_iterator.moveNext();) {
  {
  Object element = _sync_for_iterator.current;
  {
  if (!this.contains(element)) return false;
}
}
}
}
  return true;
}
  }
  
  Set difference(Set other) {
    {
  CppSet result = new CppSet();
  {
  Iterator _sync_for_iterator = this._list.iterator;
  for (; _sync_for_iterator.moveNext();) {
  {
  Object element = _sync_for_iterator.current;
  {
  if (!other.contains(element)) {
  result.add(element);
}
}
}
}
}
  return result;
}
  }
  
  Object elementAt(int index) {
    return this._list.elementAt(index);
  }
  
  Set intersection(Set other) {
    {
  CppSet result = new CppSet();
  {
  Iterator _sync_for_iterator = this._list.iterator;
  for (; _sync_for_iterator.moveNext();) {
  {
  Object element = _sync_for_iterator.current;
  {
  if (other.contains(element)) {
  result.add(element);
}
}
}
}
}
  return result;
}
  }
  
  static Object first(Object self) {
    return {
  if (this._list.isEmpty) throw new StateError("No element")
  return this._list.first;
};
  }
  
  static Object last(Object self) {
    return {
  if (this._list.isEmpty) throw new StateError("No element")
  return this._list.last;
};
  }
  
  static Object single(Object self) {
    return {
  if (this._list.isEmpty) throw new StateError("No element")
  if (this._list.length > (1)) throw new StateError("Too many elements")
  return this._list.single;
};
  }
  
  static bool isEmpty(Object self) {
    return return this._list.isEmpty;;
  }
  
  static bool isNotEmpty(Object self) {
    return return this._list.isNotEmpty;;
  }
  
  static Iterator iterator(Object self) {
    return return this._list.iterator;;
  }
  
  static int length(Object self) {
    return return this._list.length;;
  }
  
  Object lookup(Object element) {
    {
  for (int i = 0; i < (this._list.length); i = i + (1)) {
  {
  if (element == this._list[i]) {
  return this._list[i];
}
}
}
  return null;
}
  }
  
  bool remove(Object value) {
    {
  return this._list.remove(value);
}
  }
  
  Object removeAll(Iterable elementsToRemove) {
    {
  {
  Iterator _sync_for_iterator = elementsToRemove.iterator;
  for (; _sync_for_iterator.moveNext();) {
  {
  Object element = _sync_for_iterator.current;
  {
  this.remove(element);
}
}
}
}
}
  }
  
  Object removeWhere(Function(Object) => Object test) {
    {
  this._list.removeWhere(test);
}
  }
  
  Object retainAll(Iterable elementsToRetain) {
    {
  CppSet retainSet = CppSet.from(elementsToRetain);
  this.removeWhere((Object element) => return !retainSet.contains(element););
}
  }
  
  Object retainWhere(Function(Object) => Object test) {
    {
  this._list.retainWhere(test);
}
  }
  
  Set union(Set other) {
    {
  CppSet result = new CppSet();
  result.addAll(this);
  result.addAll(other);
  return result;
}
  }
  
  String toString() {
    {
  if (this._list.isEmpty) return "{}";
  StringBuffer buffer = new StringBuffer("{");
  Iterator iterator = this._list.iterator;
  if (iterator.moveNext()) {
  buffer.write(iterator.current);
  while (iterator.moveNext()) {
  buffer.write(", ");
  buffer.write(iterator.current);
}
}
  buffer.write("}");
  return buffer.toString();
}
  }
  
  static bool add(Object self, Object value) {
    {
  if (this.contains(value)) {
  return false;
}
  this._list.add(value);
  return true;
}
  }
  
  static Object addAll(Object self, Iterable elements) {
    {
  {
  Iterator _sync_for_iterator = elements.iterator;
  for (; _sync_for_iterator.moveNext();) {
  {
  Object element = _sync_for_iterator.current;
  {
  this.add(element);
}
}
}
}
}
  }
  
  static Set cast(Object self) {
    {
  return CppSet.castFrom(this);
}
  }
  
  static Object clear(Object self) {
    {
  this._list.clear();
}
  }
  
  static bool contains(Object self, Object element) {
    {
  for (int i = 0; i < (this._list.length); i = i + (1)) {
  {
  if (element == this._list[i]) {
  return true;
}
}
}
  return false;
}
  }
  
  static bool containsAll(Object self, Iterable other) {
    {
  {
  Iterator _sync_for_iterator = other.iterator;
  for (; _sync_for_iterator.moveNext();) {
  {
  Object element = _sync_for_iterator.current;
  {
  if (!this.contains(element)) return false;
}
}
}
}
  return true;
}
  }
  
  static Set difference(Object self, Set other) {
    {
  CppSet result = new CppSet();
  {
  Iterator _sync_for_iterator = this._list.iterator;
  for (; _sync_for_iterator.moveNext();) {
  {
  Object element = _sync_for_iterator.current;
  {
  if (!other.contains(element)) {
  result.add(element);
}
}
}
}
}
  return result;
}
  }
  
  static Object elementAt(Object self, int index) {
    return this._list.elementAt(index);
  }
  
  static Set intersection(Object self, Set other) {
    {
  CppSet result = new CppSet();
  {
  Iterator _sync_for_iterator = this._list.iterator;
  for (; _sync_for_iterator.moveNext();) {
  {
  Object element = _sync_for_iterator.current;
  {
  if (other.contains(element)) {
  result.add(element);
}
}
}
}
}
  return result;
}
  }
  
  static Object lookup(Object self, Object element) {
    {
  for (int i = 0; i < (this._list.length); i = i + (1)) {
  {
  if (element == this._list[i]) {
  return this._list[i];
}
}
}
  return null;
}
  }
  
  static bool remove(Object self, Object value) {
    {
  return this._list.remove(value);
}
  }
  
  static Object removeAll(Object self, Iterable elementsToRemove) {
    {
  {
  Iterator _sync_for_iterator = elementsToRemove.iterator;
  for (; _sync_for_iterator.moveNext();) {
  {
  Object element = _sync_for_iterator.current;
  {
  this.remove(element);
}
}
}
}
}
  }
  
  static Object removeWhere(Object self, Function(Object) => Object test) {
    {
  this._list.removeWhere(test);
}
  }
  
  static Object retainAll(Object self, Iterable elementsToRetain) {
    {
  CppSet retainSet = CppSet.from(elementsToRetain);
  this.removeWhere((Object element) => return !retainSet.contains(element););
}
  }
  
  static Object retainWhere(Object self, Function(Object) => Object test) {
    {
  this._list.retainWhere(test);
}
  }
  
  static Set union(Object self, Set other) {
    {
  CppSet result = new CppSet();
  result.addAll(this);
  result.addAll(other);
  return result;
}
  }
  
  static String toString(Object self) {
    {
  if (this._list.isEmpty) return "{}";
  StringBuffer buffer = new StringBuffer("{");
  Iterator iterator = this._list.iterator;
  if (iterator.moveNext()) {
  buffer.write(iterator.current);
  while (iterator.moveNext()) {
  buffer.write(", ");
  buffer.write(iterator.current);
}
}
  buffer.write("}");
  return buffer.toString();
}
  }
  
}

/// 转换后的类: CppMap
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/collection.dart

class CppMap<K, V> implements Map<K, V> {
  late CppList _list;
CppMap.fromCppArray(CppUserData array) : _list = new CppList.fromCppArray(array), super()   {
    ;
  }
  
CppMap(int capacity) : _list = new CppList(0, capacity), super()   {
    ;
  }
  
  Object [](Object key) {
    {
  {
  Iterator _sync_for_iterator = this._list.iterator;
  for (; _sync_for_iterator.moveNext();) {
  {
  MapEntry entry = _sync_for_iterator.current;
  {
  if (entry.key == key) {
  return entry.value;
}
}
}
}
}
  return null;
}
  }
  
  Object []=(Object key, Object value) {
    {
  for (int i = 0; i < (this._list.length); i = i + (1)) {
  {
  if (this._list[i].key == key) {
  this._list[i] = new MapEntry._(key, value);
  return;
}
}
}
  this._list.add(new MapEntry._(key, value));
}
  }
  
  Object addAll(Map other) {
    {
  other.forEach((Object k, Object v) => return (() { final Object temp = k; return (() { final Object temp = v; return (() { final Object temp = this[temp] = temp; return temp; })(); })(); })(););
}
  }
  
  Object addEntries(Iterable entries) {
    {
  {
  Iterator _sync_for_iterator = entries.iterator;
  for (; _sync_for_iterator.moveNext();) {
  {
  MapEntry entry = _sync_for_iterator.current;
  {
  this[entry.key] = entry.value;
}
}
}
}
}
  }
  
  Map cast() {
    return CppMap.castFrom(this);
  }
  
  Object clear() {
    {
  this._list.clear();
}
  }
  
  bool containsKey(Object key) {
    {
  {
  Iterator _sync_for_iterator = this._list.iterator;
  for (; _sync_for_iterator.moveNext();) {
  {
  MapEntry entry = _sync_for_iterator.current;
  {
  if (entry.key == key) return true;
}
}
}
}
  return false;
}
  }
  
  bool containsValue(Object value) {
    {
  {
  Iterator _sync_for_iterator = this._list.iterator;
  for (; _sync_for_iterator.moveNext();) {
  {
  MapEntry entry = _sync_for_iterator.current;
  {
  if (entry.value == value) return true;
}
}
}
}
  return false;
}
  }
  
  static Iterable entries(Object self) {
    return return this._list;;
  }
  
  Object forEach(Function(ObjectObject) => Object action) {
    {
  {
  Iterator _sync_for_iterator = this._list.iterator;
  for (; _sync_for_iterator.moveNext();) {
  {
  MapEntry entry = _sync_for_iterator.current;
  {
  action(entry.key, entry.value);
}
}
}
}
}
  }
  
  static bool isEmpty(Object self) {
    return return this._list.isEmpty;;
  }
  
  static bool isNotEmpty(Object self) {
    return return this._list.isNotEmpty;;
  }
  
  static Iterable keys(Object self) {
    return return this._list.map((MapEntry e) => return e.key;);;
  }
  
  static int length(Object self) {
    return return this._list.length;;
  }
  
  Object putIfAbsent(Object key, Function() => Object ifAbsent) {
    {
  {
  Iterator _sync_for_iterator = this._list.iterator;
  for (; _sync_for_iterator.moveNext();) {
  {
  MapEntry entry = _sync_for_iterator.current;
  {
  if (entry.key == key) return entry.value;
}
}
}
}
  Object v = ifAbsent();
  this._list.add(new MapEntry._(key, v));
  return v;
}
  }
  
  Object remove(Object key) {
    {
  for (int i = 0; i < (this._list.length); i = i + (1)) {
  {
  if (this._list[i].key == key) {
  Object v = this._list[i].value;
  for (int j = i; j < (this._list.length - (1)); j = j + (1)) {
  {
  this._list[j] = this._list[j + (1)];
}
}
  this._list.length = this._list.length - (1);
  return v;
}
}
}
  return null;
}
  }
  
  Object removeWhere(Function(ObjectObject) => Object test) {
    {
  int i = 0;
  while (i < (this._list.length)) {
  MapEntry entry = this._list[i];
  if (test(entry.key, entry.value)) {
  this.remove(entry.key);
} else {
  i = i + (1);
}
}
}
  }
  
  Object update(Object key, Function(Object) => Object update) {
    {
  for (int i = 0; i < (this._list.length); i = i + (1)) {
  {
  if (this._list[i].key == key) {
  Object newValue = update(this._list[i].value);
  this._list[i] = new MapEntry._(key, newValue);
  return newValue;
}
}
}
  if (!ifAbsent == null) {
  Object v = ifAbsent();
  this._list.add(new MapEntry._(key, v));
  return v;
}
  throw new ArgumentError("Key not found")
}
  }
  
  Object updateAll(Function(ObjectObject) => Object update) {
    {
  for (int i = 0; i < (this._list.length); i = i + (1)) {
  {
  MapEntry entry = this._list[i];
  this._list[i] = new MapEntry._(entry.key, update(entry.key, entry.value));
}
}
}
  }
  
  static Iterable values(Object self) {
    return return this._list.map((MapEntry e) => return e.value;);;
  }
  
  Map map(Function(ObjectObject) => Object transform) {
    {
  CppMap result = new CppMap();
  {
  Iterator _sync_for_iterator = this._list.iterator;
  for (; _sync_for_iterator.moveNext();) {
  {
  MapEntry entry = _sync_for_iterator.current;
  {
  MapEntry newEntry = transform(entry.key, entry.value);
  result[newEntry.key] = newEntry.value;
}
}
}
}
  return result;
}
  }
  
  String toString() {
    {
  if (this._list.isEmpty) return "{}";
  StringBuffer buffer = new StringBuffer("{");
  Iterator iterator = this._list.iterator;
  if (iterator.moveNext()) {
  buffer.write(iterator.current.key + ": " + iterator.current.value);
  while (iterator.moveNext()) {
  buffer.write(", " + iterator.current.key + ": " + iterator.current.value);
}
}
  buffer.write("}");
  return buffer.toString();
}
  }
  
  static Object addAll(Object self, Map other) {
    {
  other.forEach((Object k, Object v) => return (() { final Object temp = k; return (() { final Object temp = v; return (() { final Object temp = this[temp] = temp; return temp; })(); })(); })(););
}
  }
  
  static Object addEntries(Object self, Iterable entries) {
    {
  {
  Iterator _sync_for_iterator = entries.iterator;
  for (; _sync_for_iterator.moveNext();) {
  {
  MapEntry entry = _sync_for_iterator.current;
  {
  this[entry.key] = entry.value;
}
}
}
}
}
  }
  
  static Map cast(Object self) {
    return CppMap.castFrom(this);
  }
  
  static Object clear(Object self) {
    {
  this._list.clear();
}
  }
  
  static bool containsKey(Object self, Object key) {
    {
  {
  Iterator _sync_for_iterator = this._list.iterator;
  for (; _sync_for_iterator.moveNext();) {
  {
  MapEntry entry = _sync_for_iterator.current;
  {
  if (entry.key == key) return true;
}
}
}
}
  return false;
}
  }
  
  static bool containsValue(Object self, Object value) {
    {
  {
  Iterator _sync_for_iterator = this._list.iterator;
  for (; _sync_for_iterator.moveNext();) {
  {
  MapEntry entry = _sync_for_iterator.current;
  {
  if (entry.value == value) return true;
}
}
}
}
  return false;
}
  }
  
  static Object forEach(Object self, Function(ObjectObject) => Object action) {
    {
  {
  Iterator _sync_for_iterator = this._list.iterator;
  for (; _sync_for_iterator.moveNext();) {
  {
  MapEntry entry = _sync_for_iterator.current;
  {
  action(entry.key, entry.value);
}
}
}
}
}
  }
  
  static Object putIfAbsent(Object self, Object key, Function() => Object ifAbsent) {
    {
  {
  Iterator _sync_for_iterator = this._list.iterator;
  for (; _sync_for_iterator.moveNext();) {
  {
  MapEntry entry = _sync_for_iterator.current;
  {
  if (entry.key == key) return entry.value;
}
}
}
}
  Object v = ifAbsent();
  this._list.add(new MapEntry._(key, v));
  return v;
}
  }
  
  static Object remove(Object self, Object key) {
    {
  for (int i = 0; i < (this._list.length); i = i + (1)) {
  {
  if (this._list[i].key == key) {
  Object v = this._list[i].value;
  for (int j = i; j < (this._list.length - (1)); j = j + (1)) {
  {
  this._list[j] = this._list[j + (1)];
}
}
  this._list.length = this._list.length - (1);
  return v;
}
}
}
  return null;
}
  }
  
  static Object removeWhere(Object self, Function(ObjectObject) => Object test) {
    {
  int i = 0;
  while (i < (this._list.length)) {
  MapEntry entry = this._list[i];
  if (test(entry.key, entry.value)) {
  this.remove(entry.key);
} else {
  i = i + (1);
}
}
}
  }
  
  static Object update(Object self, Object key, Function(Object) => Object update) {
    {
  for (int i = 0; i < (this._list.length); i = i + (1)) {
  {
  if (this._list[i].key == key) {
  Object newValue = update(this._list[i].value);
  this._list[i] = new MapEntry._(key, newValue);
  return newValue;
}
}
}
  if (!ifAbsent == null) {
  Object v = ifAbsent();
  this._list.add(new MapEntry._(key, v));
  return v;
}
  throw new ArgumentError("Key not found")
}
  }
  
  static Object updateAll(Object self, Function(ObjectObject) => Object update) {
    {
  for (int i = 0; i < (this._list.length); i = i + (1)) {
  {
  MapEntry entry = this._list[i];
  this._list[i] = new MapEntry._(entry.key, update(entry.key, entry.value));
}
}
}
  }
  
  static Map map(Object self, Function(ObjectObject) => Object transform) {
    {
  CppMap result = new CppMap();
  {
  Iterator _sync_for_iterator = this._list.iterator;
  for (; _sync_for_iterator.moveNext();) {
  {
  MapEntry entry = _sync_for_iterator.current;
  {
  MapEntry newEntry = transform(entry.key, entry.value);
  result[newEntry.key] = newEntry.value;
}
}
}
}
  return result;
}
  }
  
  static String toString(Object self) {
    {
  if (this._list.isEmpty) return "{}";
  StringBuffer buffer = new StringBuffer("{");
  Iterator iterator = this._list.iterator;
  if (iterator.moveNext()) {
  buffer.write(iterator.current.key + ": " + iterator.current.value);
  while (iterator.moveNext()) {
  buffer.write(", " + iterator.current.key + ": " + iterator.current.value);
}
}
  buffer.write("}");
  return buffer.toString();
}
  }
  
  Object operator [](Object key) {
    {
  {
  Iterator _sync_for_iterator = this._list.iterator;
  for (; _sync_for_iterator.moveNext();) {
  {
  MapEntry entry = _sync_for_iterator.current;
  {
  if (entry.key == key) {
  return entry.value;
}
}
}
}
}
  return null;
}
  }
  
  Object operator []=(Object key, Object value) {
    {
  for (int i = 0; i < (this._list.length); i = i + (1)) {
  {
  if (this._list[i].key == key) {
  this._list[i] = new MapEntry._(key, value);
  return;
}
}
}
  this._list.add(new MapEntry._(key, value));
}
  }
  
}

/// 转换后的类: CppIterator
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/Iterable.dart

class CppIterator<E> implements Iterator<E> {
CppIterator() : super()   {
    ;
  }
  
  static Object current(Object self) {
    return null;
  }
  
}

/// 转换后的类: CppIterable
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/Iterable.dart

class CppIterable<E> implements Iterable<E> {
CppIterable() : super()   {
    ;
  }
  
  static Iterator iterator(Object self) {
    return null;
  }
  
  static int length(Object self) {
    return null;
  }
  
  static bool isEmpty(Object self) {
    return return this.length == 0;;
  }
  
  static bool isNotEmpty(Object self) {
    return return this.length > (0);;
  }
  
  static Object first(Object self) {
    return {
  if (this.isEmpty) throw new StateError("No element")
  Iterator it = this.iterator;
  if (!it.moveNext()) throw new StateError("No element")
  return it.current;
};
  }
  
  static Object last(Object self) {
    return {
  if (this.isEmpty) throw new StateError("No element")
  Iterator it = this.iterator;
  Object result;
  while (it.moveNext()) {
  result = it.current;
}
  return (() { final Object temp = result; return temp == null ? temp as Object : temp; })();
};
  }
  
  static Object single(Object self) {
    return {
  if (this.isEmpty) throw new StateError("No element")
  Iterator it = this.iterator;
  it.moveNext();
  Object result = it.current;
  if (it.moveNext()) throw new StateError("Too many elements")
  return result;
};
  }
  
  Object elementAt(int index) {
    {
  if (index < (0)) throw new ArgumentError("Index cannot be negative")
  Iterator it = this.iterator;
  for (int i = 0; i <= (index); i = i + (1)) {
  {
  if (!it.moveNext()) throw new IndexError(index, this)
  if (i == index) return it.current;
}
}
  throw new IndexError(index, this)
}
  }
  
  bool contains(Object element) {
    {
  Iterator it = this.iterator;
  while (it.moveNext()) {
  if (it.current == element) return true;
}
  return false;
}
  }
  
  Object forEach(Function(Object) => Object action) {
    {
  Iterator it = this.iterator;
  while (it.moveNext()) {
  action(it.current);
}
}
  }
  
  Iterable map(Function(Object) => Object toElement) {
    {
  return new CppMappedIterable(this, toElement);
}
  }
  
  Iterable where(Function(Object) => Object test) {
    {
  return new CppWhereIterable(this, test);
}
  }
  
  Iterable whereType() {
    {
  return new CppWhereTypeIterable(this);
}
  }
  
  Iterable expand(Function(Object) => Object toElements) {
    {
  return new CppExpandIterable(this, toElements);
}
  }
  
  bool any(Function(Object) => Object test) {
    {
  Iterator it = this.iterator;
  while (it.moveNext()) {
  if (test(it.current)) return true;
}
  return false;
}
  }
  
  bool every(Function(Object) => Object test) {
    {
  Iterator it = this.iterator;
  while (it.moveNext()) {
  if (!test(it.current)) return false;
}
  return true;
}
  }
  
  Object firstWhere(Function(Object) => Object test) {
    {
  Iterator it = this.iterator;
  while (it.moveNext()) {
  if (test(it.current)) return it.current;
}
  if (!orElse == null) return orElse();
  throw new StateError("No element")
}
  }
  
  Object lastWhere(Function(Object) => Object test) {
    {
  Iterator it = this.iterator;
  Object result;
  bool found = false;
  while (it.moveNext()) {
  if (test(it.current)) {
  result = it.current;
  found = true;
}
}
  if (found) return (() { final Object temp = result; return temp == null ? temp as Object : temp; })();
  if (!orElse == null) return orElse();
  throw new StateError("No element")
}
  }
  
  Object singleWhere(Function(Object) => Object test) {
    {
  Iterator it = this.iterator;
  Object result;
  bool found = false;
  while (it.moveNext()) {
  if (test(it.current)) {
  if (found) throw new StateError("Too many elements")
  result = it.current;
  found = true;
}
}
  if (found) return (() { final Object temp = result; return temp == null ? temp as Object : temp; })();
  if (!orElse == null) return orElse();
  throw new StateError("No element")
}
  }
  
  Object reduce(Function(ObjectObject) => Object combine) {
    {
  Iterator it = this.iterator;
  if (!it.moveNext()) throw new StateError("No element")
  Object value = it.current;
  while (it.moveNext()) {
  value = combine(value, it.current);
}
  return value;
}
  }
  
  Object fold(Object initialValue, Function(ObjectObject) => Object combine) {
    {
  Object value = initialValue;
  Iterator it = this.iterator;
  while (it.moveNext()) {
  value = combine(value, it.current);
}
  return value;
}
  }
  
  String join(String separator) {
    {
  Iterator it = this.iterator;
  if (!it.moveNext()) return "";
  StringBuffer buffer = new StringBuffer(it.current.toString());
  while (it.moveNext()) {
  buffer.write(separator);
  buffer.write(it.current.toString());
}
  return buffer.toString();
}
  }
  
  Iterable take(int count) {
    {
  return new CppTakeIterable(this, count);
}
  }
  
  Iterable takeWhile(Function(Object) => Object test) {
    {
  return new CppTakeWhileIterable(this, test);
}
  }
  
  Iterable skip(int count) {
    {
  return new CppSkipIterable(this, count);
}
  }
  
  Iterable skipWhile(Function(Object) => Object test) {
    {
  return new CppSkipWhileIterable(this, test);
}
  }
  
  static Iterable reversed(Object self) {
    return {
  return new CppReversedIterable(this);
};
  }
  
  Iterable followedBy(Iterable other) {
    {
  return new CppFollowedByIterable(this, other);
}
  }
  
  List toList() {
    {
  return CppList.from(this, growable: growable);
}
  }
  
  Set toSet() {
    {
  return CppSet.from(this);
}
  }
  
  Iterable cast() {
    {
  return new CppCastIterable(this);
}
  }
  
  static Object elementAt(Object self, int index) {
    {
  if (index < (0)) throw new ArgumentError("Index cannot be negative")
  Iterator it = this.iterator;
  for (int i = 0; i <= (index); i = i + (1)) {
  {
  if (!it.moveNext()) throw new IndexError(index, this)
  if (i == index) return it.current;
}
}
  throw new IndexError(index, this)
}
  }
  
  static bool contains(Object self, Object element) {
    {
  Iterator it = this.iterator;
  while (it.moveNext()) {
  if (it.current == element) return true;
}
  return false;
}
  }
  
  static Object forEach(Object self, Function(Object) => Object action) {
    {
  Iterator it = this.iterator;
  while (it.moveNext()) {
  action(it.current);
}
}
  }
  
  static Iterable map(Object self, Function(Object) => Object toElement) {
    {
  return new CppMappedIterable(this, toElement);
}
  }
  
  static Iterable where(Object self, Function(Object) => Object test) {
    {
  return new CppWhereIterable(this, test);
}
  }
  
  static Iterable whereType(Object self) {
    {
  return new CppWhereTypeIterable(this);
}
  }
  
  static Iterable expand(Object self, Function(Object) => Object toElements) {
    {
  return new CppExpandIterable(this, toElements);
}
  }
  
  static bool any(Object self, Function(Object) => Object test) {
    {
  Iterator it = this.iterator;
  while (it.moveNext()) {
  if (test(it.current)) return true;
}
  return false;
}
  }
  
  static bool every(Object self, Function(Object) => Object test) {
    {
  Iterator it = this.iterator;
  while (it.moveNext()) {
  if (!test(it.current)) return false;
}
  return true;
}
  }
  
  static Object firstWhere(Object self, Function(Object) => Object test) {
    {
  Iterator it = this.iterator;
  while (it.moveNext()) {
  if (test(it.current)) return it.current;
}
  if (!orElse == null) return orElse();
  throw new StateError("No element")
}
  }
  
  static Object lastWhere(Object self, Function(Object) => Object test) {
    {
  Iterator it = this.iterator;
  Object result;
  bool found = false;
  while (it.moveNext()) {
  if (test(it.current)) {
  result = it.current;
  found = true;
}
}
  if (found) return (() { final Object temp = result; return temp == null ? temp as Object : temp; })();
  if (!orElse == null) return orElse();
  throw new StateError("No element")
}
  }
  
  static Object singleWhere(Object self, Function(Object) => Object test) {
    {
  Iterator it = this.iterator;
  Object result;
  bool found = false;
  while (it.moveNext()) {
  if (test(it.current)) {
  if (found) throw new StateError("Too many elements")
  result = it.current;
  found = true;
}
}
  if (found) return (() { final Object temp = result; return temp == null ? temp as Object : temp; })();
  if (!orElse == null) return orElse();
  throw new StateError("No element")
}
  }
  
  static Object reduce(Object self, Function(ObjectObject) => Object combine) {
    {
  Iterator it = this.iterator;
  if (!it.moveNext()) throw new StateError("No element")
  Object value = it.current;
  while (it.moveNext()) {
  value = combine(value, it.current);
}
  return value;
}
  }
  
  static Object fold(Object self, Object initialValue, Function(ObjectObject) => Object combine) {
    {
  Object value = initialValue;
  Iterator it = this.iterator;
  while (it.moveNext()) {
  value = combine(value, it.current);
}
  return value;
}
  }
  
  static String join(Object self, String separator) {
    {
  Iterator it = this.iterator;
  if (!it.moveNext()) return "";
  StringBuffer buffer = new StringBuffer(it.current.toString());
  while (it.moveNext()) {
  buffer.write(separator);
  buffer.write(it.current.toString());
}
  return buffer.toString();
}
  }
  
  static Iterable take(Object self, int count) {
    {
  return new CppTakeIterable(this, count);
}
  }
  
  static Iterable takeWhile(Object self, Function(Object) => Object test) {
    {
  return new CppTakeWhileIterable(this, test);
}
  }
  
  static Iterable skip(Object self, int count) {
    {
  return new CppSkipIterable(this, count);
}
  }
  
  static Iterable skipWhile(Object self, Function(Object) => Object test) {
    {
  return new CppSkipWhileIterable(this, test);
}
  }
  
  static Iterable followedBy(Object self, Iterable other) {
    {
  return new CppFollowedByIterable(this, other);
}
  }
  
  static List toList(Object self) {
    {
  return CppList.from(this, growable: growable);
}
  }
  
  static Set toSet(Object self) {
    {
  return CppSet.from(this);
}
  }
  
  static Iterable cast(Object self) {
    {
  return new CppCastIterable(this);
}
  }
  
}

/// 转换后的类: CppMappedIterable
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/Iterable.dart

class CppMappedIterable<S, T> extends CppIterable<S, T> {
  late Iterable _source;
  late Function(Object) => Object _f;
CppMappedIterable(Iterable _source, Function(Object) => Object _f) : _source = _source, _f = _f, super()   {
    ;
  }
  
  static Iterator iterator(Object self) {
    return return new CppMappedIterator(this._source.iterator, this._f);;
  }
  
  static int length(Object self) {
    return return this._source.length;;
  }
  
}

/// 转换后的类: CppMappedIterator
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/Iterable.dart

class CppMappedIterator<S, T> extends CppIterator<S, T> {
  Object _current;
  late Iterator _iterator;
  late Function(Object) => Object _f;
CppMappedIterator(Iterator _iterator, Function(Object) => Object _f) : _iterator = _iterator, _f = _f, super()   {
    ;
  }
  
  static Object current(Object self) {
    return return (() { final Object temp = this._current; return temp == null ? temp as Object : temp; })();;
  }
  
  bool moveNext() {
    {
  if (this._iterator.moveNext()) {
  this._current = (() { final Object temp = this._iterator.current; return this._f(temp); })();
  return true;
}
  return false;
}
  }
  
  static bool moveNext(Object self) {
    {
  if (this._iterator.moveNext()) {
  this._current = (() { final Object temp = this._iterator.current; return this._f(temp); })();
  return true;
}
  return false;
}
  }
  
}

/// 转换后的类: CppWhereIterable
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/Iterable.dart

class CppWhereIterable<E> extends CppIterable<E> {
  late Iterable _source;
  late Function(Object) => Object _test;
CppWhereIterable(Iterable _source, Function(Object) => Object _test) : _source = _source, _test = _test, super()   {
    ;
  }
  
  static Iterator iterator(Object self) {
    return return new CppWhereIterator(this._source.iterator, this._test);;
  }
  
  static int length(Object self) {
    return {
  int count = 0;
  Iterator it = this.iterator;
  while (it.moveNext()) {
  count = count + (1);
}
  return count;
};
  }
  
}

/// 转换后的类: CppWhereIterator
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/Iterable.dart

class CppWhereIterator<E> extends CppIterator<E> {
  late Iterator _iterator;
  late Function(Object) => Object _test;
CppWhereIterator(Iterator _iterator, Function(Object) => Object _test) : _iterator = _iterator, _test = _test, super()   {
    ;
  }
  
  static Object current(Object self) {
    return return this._iterator.current;;
  }
  
  bool moveNext() {
    {
  while (this._iterator.moveNext()) {
  if ((() { final Object temp = this._iterator.current; return this._test(temp); })()) {
  return true;
}
}
  return false;
}
  }
  
  static bool moveNext(Object self) {
    {
  while (this._iterator.moveNext()) {
  if ((() { final Object temp = this._iterator.current; return this._test(temp); })()) {
  return true;
}
}
  return false;
}
  }
  
}

/// 转换后的类: CppWhereTypeIterable
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/Iterable.dart

class CppWhereTypeIterable<T> extends CppIterable<T> {
  late Iterable _source;
CppWhereTypeIterable(Iterable _source) : _source = _source, super()   {
    ;
  }
  
  static Iterator iterator(Object self) {
    return return new CppWhereTypeIterator(this._source.iterator);;
  }
  
  static int length(Object self) {
    return {
  int count = 0;
  Iterator it = this.iterator;
  while (it.moveNext()) {
  count = count + (1);
}
  return count;
};
  }
  
}

/// 转换后的类: CppWhereTypeIterator
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/Iterable.dart

class CppWhereTypeIterator<T> extends CppIterator<T> {
  late Iterator _iterator;
CppWhereTypeIterator(Iterator _iterator) : _iterator = _iterator, super()   {
    ;
  }
  
  static Object current(Object self) {
    return return this._iterator.current as Object;;
  }
  
  bool moveNext() {
    {
  while (this._iterator.moveNext()) {
  if (this._iterator.current is Object) {
  return true;
}
}
  return false;
}
  }
  
  static bool moveNext(Object self) {
    {
  while (this._iterator.moveNext()) {
  if (this._iterator.current is Object) {
  return true;
}
}
  return false;
}
  }
  
}

/// 转换后的类: CppExpandIterable
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/Iterable.dart

class CppExpandIterable<S, T> extends CppIterable<S, T> {
  late Iterable _source;
  late Function(Object) => Object _f;
CppExpandIterable(Iterable _source, Function(Object) => Object _f) : _source = _source, _f = _f, super()   {
    ;
  }
  
  static Iterator iterator(Object self) {
    return return new CppExpandIterator(this._source.iterator, this._f);;
  }
  
  static int length(Object self) {
    return {
  int count = 0;
  Iterator it = this.iterator;
  while (it.moveNext()) {
  count = count + (1);
}
  return count;
};
  }
  
}

/// 转换后的类: CppExpandIterator
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/Iterable.dart

class CppExpandIterator<S, T> extends CppIterator<S, T> {
  Iterator _currentIterator;
  late Iterator _iterator;
  late Function(Object) => Object _f;
CppExpandIterator(Iterator _iterator, Function(Object) => Object _f) : _iterator = _iterator, _f = _f, super()   {
    ;
  }
  
  static Object current(Object self) {
    return return this._currentIterator!.current;;
  }
  
  bool moveNext() {
    {
  while (true) {
  if (!this._currentIterator == null && this._currentIterator!.moveNext()) {
  return true;
}
  if (!this._iterator.moveNext()) {
  return false;
}
  this._currentIterator = (() { final Object temp = this._iterator.current; return this._f(temp); })().iterator;
}
}
  }
  
  static bool moveNext(Object self) {
    {
  while (true) {
  if (!this._currentIterator == null && this._currentIterator!.moveNext()) {
  return true;
}
  if (!this._iterator.moveNext()) {
  return false;
}
  this._currentIterator = (() { final Object temp = this._iterator.current; return this._f(temp); })().iterator;
}
}
  }
  
}

/// 转换后的类: CppTakeIterable
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/Iterable.dart

class CppTakeIterable<E> extends CppIterable<E> {
  late Iterable _source;
  late int _count;
CppTakeIterable(Iterable _source, int _count) : _source = _source, _count = _count, super()   {
    ;
  }
  
  static Iterator iterator(Object self) {
    return return new CppTakeIterator(this._source.iterator, this._count);;
  }
  
  static int length(Object self) {
    return return UnknownClass.min(this._count, this._source.length);;
  }
  
}

/// 转换后的类: CppTakeIterator
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/Iterable.dart

class CppTakeIterator<E> extends CppIterator<E> {
  int _remaining;
  late Iterator _iterator;
  late int _count;
CppTakeIterator(Iterator _iterator, int _count) : _iterator = _iterator, _count = _count, _remaining = _count, super()   {
    ;
  }
  
  static Object current(Object self) {
    return return this._iterator.current;;
  }
  
  bool moveNext() {
    {
  if (this._remaining <= (0)) return false;
  if (this._iterator.moveNext()) {
  this._remaining = this._remaining - (1);
  return true;
}
  return false;
}
  }
  
  static bool moveNext(Object self) {
    {
  if (this._remaining <= (0)) return false;
  if (this._iterator.moveNext()) {
  this._remaining = this._remaining - (1);
  return true;
}
  return false;
}
  }
  
}

/// 转换后的类: CppTakeWhileIterable
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/Iterable.dart

class CppTakeWhileIterable<E> extends CppIterable<E> {
  late Iterable _source;
  late Function(Object) => Object _test;
CppTakeWhileIterable(Iterable _source, Function(Object) => Object _test) : _source = _source, _test = _test, super()   {
    ;
  }
  
  static Iterator iterator(Object self) {
    return return new CppTakeWhileIterator(this._source.iterator, this._test);;
  }
  
  static int length(Object self) {
    return {
  int count = 0;
  Iterator it = this.iterator;
  while (it.moveNext()) {
  count = count + (1);
}
  return count;
};
  }
  
}

/// 转换后的类: CppTakeWhileIterator
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/Iterable.dart

class CppTakeWhileIterator<E> extends CppIterator<E> {
  bool _finished;
  late Iterator _iterator;
  late Function(Object) => Object _test;
CppTakeWhileIterator(Iterator _iterator, Function(Object) => Object _test) : _iterator = _iterator, _test = _test, super()   {
    ;
  }
  
  static Object current(Object self) {
    return return this._iterator.current;;
  }
  
  bool moveNext() {
    {
  if (this._finished) return false;
  if (this._iterator.moveNext()) {
  if ((() { final Object temp = this._iterator.current; return this._test(temp); })()) {
  return true;
}
  this._finished = true;
}
  return false;
}
  }
  
  static bool moveNext(Object self) {
    {
  if (this._finished) return false;
  if (this._iterator.moveNext()) {
  if ((() { final Object temp = this._iterator.current; return this._test(temp); })()) {
  return true;
}
  this._finished = true;
}
  return false;
}
  }
  
}

/// 转换后的类: CppSkipIterable
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/Iterable.dart

class CppSkipIterable<E> extends CppIterable<E> {
  late Iterable _source;
  late int _count;
CppSkipIterable(Iterable _source, int _count) : _source = _source, _count = _count, super()   {
    ;
  }
  
  static Iterator iterator(Object self) {
    return return new CppSkipIterator(this._source.iterator, this._count);;
  }
  
  static int length(Object self) {
    return return UnknownClass.max(0, this._source.length - (this._count));;
  }
  
}

/// 转换后的类: CppSkipIterator
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/Iterable.dart

class CppSkipIterator<E> extends CppIterator<E> {
  bool _skipped;
  late Iterator _iterator;
  late int _count;
CppSkipIterator(Iterator _iterator, int _count) : _iterator = _iterator, _count = _count, super()   {
    ;
  }
  
  static Object current(Object self) {
    return return this._iterator.current;;
  }
  
  bool moveNext() {
    {
  if (!this._skipped) {
  for (int i = 0; i < (this._count); i = i + (1)) {
  {
  if (!this._iterator.moveNext()) return false;
}
}
  this._skipped = true;
}
  return this._iterator.moveNext();
}
  }
  
  static bool moveNext(Object self) {
    {
  if (!this._skipped) {
  for (int i = 0; i < (this._count); i = i + (1)) {
  {
  if (!this._iterator.moveNext()) return false;
}
}
  this._skipped = true;
}
  return this._iterator.moveNext();
}
  }
  
}

/// 转换后的类: CppSkipWhileIterable
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/Iterable.dart

class CppSkipWhileIterable<E> extends CppIterable<E> {
  late Iterable _source;
  late Function(Object) => Object _test;
CppSkipWhileIterable(Iterable _source, Function(Object) => Object _test) : _source = _source, _test = _test, super()   {
    ;
  }
  
  static Iterator iterator(Object self) {
    return return new CppSkipWhileIterator(this._source.iterator, this._test);;
  }
  
  static int length(Object self) {
    return {
  int count = 0;
  Iterator it = this.iterator;
  while (it.moveNext()) {
  count = count + (1);
}
  return count;
};
  }
  
}

/// 转换后的类: CppSkipWhileIterator
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/Iterable.dart

class CppSkipWhileIterator<E> extends CppIterator<E> {
  bool _skipped;
  late Iterator _iterator;
  late Function(Object) => Object _test;
CppSkipWhileIterator(Iterator _iterator, Function(Object) => Object _test) : _iterator = _iterator, _test = _test, super()   {
    ;
  }
  
  static Object current(Object self) {
    return return this._iterator.current;;
  }
  
  bool moveNext() {
    {
  if (!this._skipped) {
  while (this._iterator.moveNext()) {
  if (!(() { final Object temp = this._iterator.current; return this._test(temp); })()) {
  this._skipped = true;
  return true;
}
}
  return false;
}
  return this._iterator.moveNext();
}
  }
  
  static bool moveNext(Object self) {
    {
  if (!this._skipped) {
  while (this._iterator.moveNext()) {
  if (!(() { final Object temp = this._iterator.current; return this._test(temp); })()) {
  this._skipped = true;
  return true;
}
}
  return false;
}
  return this._iterator.moveNext();
}
  }
  
}

/// 转换后的类: CppReversedIterable
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/Iterable.dart

class CppReversedIterable<E> extends CppIterable<E> {
  late Iterable _source;
CppReversedIterable(Iterable _source) : _source = _source, super()   {
    ;
  }
  
  static Iterator iterator(Object self) {
    return return new CppReversedIterator(this._source);;
  }
  
  static int length(Object self) {
    return return this._source.length;;
  }
  
}

/// 转换后的类: CppReversedIterator
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/Iterable.dart

class CppReversedIterator<E> extends CppIterator<E> {
  int _index;
  late CppList _elements;
CppReversedIterator(Iterable source) : _elements = CppList.from(source), _index = source.length, super()   {
    ;
  }
  
  static Object current(Object self) {
    return return this._elements[this._index];;
  }
  
  bool moveNext() {
    {
  if (this._index > (0)) {
  this._index = this._index - (1);
  return true;
}
  return false;
}
  }
  
  static bool moveNext(Object self) {
    {
  if (this._index > (0)) {
  this._index = this._index - (1);
  return true;
}
  return false;
}
  }
  
}

/// 转换后的类: CppFollowedByIterable
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/Iterable.dart

class CppFollowedByIterable<E> extends CppIterable<E> {
  late Iterable _first;
  late Iterable _second;
CppFollowedByIterable(Iterable _first, Iterable _second) : _first = _first, _second = _second, super()   {
    ;
  }
  
  static Iterator iterator(Object self) {
    return return new CppFollowedByIterator(this._first.iterator, this._second.iterator);;
  }
  
  static int length(Object self) {
    return return this._first.length + (this._second.length);;
  }
  
}

/// 转换后的类: CppFollowedByIterator
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/Iterable.dart

class CppFollowedByIterator<E> extends CppIterator<E> {
  bool _usingFirst;
  late Iterator _first;
  late Iterator _second;
CppFollowedByIterator(Iterator _first, Iterator _second) : _first = _first, _second = _second, super()   {
    ;
  }
  
  static Object current(Object self) {
    return return this._usingFirst ? this._first.current : this._second.current;;
  }
  
  bool moveNext() {
    {
  if (this._usingFirst) {
  if (this._first.moveNext()) {
  return true;
}
  this._usingFirst = false;
}
  return this._second.moveNext();
}
  }
  
  static bool moveNext(Object self) {
    {
  if (this._usingFirst) {
  if (this._first.moveNext()) {
  return true;
}
  this._usingFirst = false;
}
  return this._second.moveNext();
}
  }
  
}

/// 转换后的类: CppCastIterable
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/Iterable.dart

class CppCastIterable<S, T> extends CppIterable<S, T> {
  late Iterable _source;
CppCastIterable(Iterable _source) : _source = _source, super()   {
    ;
  }
  
  static Iterator iterator(Object self) {
    return return new CppCastIterator(this._source.iterator);;
  }
  
  static int length(Object self) {
    return return this._source.length;;
  }
  
}

/// 转换后的类: CppCastIterator
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/Iterable.dart

class CppCastIterator<S, T> extends CppIterator<S, T> {
  late Iterator _iterator;
CppCastIterator(Iterator _iterator) : _iterator = _iterator, super()   {
    ;
  }
  
  static Object current(Object self) {
    return return this._iterator.current as Object;;
  }
  
  bool moveNext() {
    return this._iterator.moveNext();
  }
  
  static bool moveNext(Object self) {
    return this._iterator.moveNext();
  }
  
}

/// 转换后的类: _CppEmptyIterable
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/Iterable.dart

class _CppEmptyIterable<E> extends CppIterable<E> {
_CppEmptyIterable() : super()   {
    ;
  }
  
  static Iterator iterator(Object self) {
    return return new _CppEmptyIterator();;
  }
  
  static int length(Object self) {
    return return 0;;
  }
  
}

/// 转换后的类: _CppEmptyIterator
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/Iterable.dart

class _CppEmptyIterator<E> extends CppIterator<E> {
_CppEmptyIterator() : super()   {
    ;
  }
  
  static Object current(Object self) {
    return return throw new StateError("No element");;
  }
  
  bool moveNext() {
    return false;
  }
  
  static bool moveNext(Object self) {
    return false;
  }
  
}

/// 转换后的类: _CppGenerateIterable
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/Iterable.dart

class _CppGenerateIterable<E> extends CppIterable<E> {
  late int _count;
  late Function(Object) => Object _generator;
_CppGenerateIterable(int _count, Function(Object) => Object _generator) : _count = _count, _generator = _generator, super()   {
    ;
  }
  
  static Iterator iterator(Object self) {
    return return new _CppGenerateIterator(this._count, this._generator);;
  }
  
  static int length(Object self) {
    return return this._count;;
  }
  
}

/// 转换后的类: _CppGenerateIterator
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/Iterable.dart

class _CppGenerateIterator<E> extends CppIterator<E> {
  int _index;
  Object _current;
  late int _count;
  late Function(Object) => Object _generator;
_CppGenerateIterator(int _count, Function(Object) => Object _generator) : _count = _count, _generator = _generator, super()   {
    ;
  }
  
  static Object current(Object self) {
    return return (() { final Object temp = this._current; return temp == null ? temp as Object : temp; })();;
  }
  
  bool moveNext() {
    {
  if (this._index < (this._count)) {
  this._current = (() { final int temp = (() { final int temp = this._index; return (() { final int temp = this._index = temp + (1); return temp; })(); })(); return this._generator(temp); })();
  return true;
}
  return false;
}
  }
  
  static bool moveNext(Object self) {
    {
  if (this._index < (this._count)) {
  this._current = (() { final int temp = (() { final int temp = this._index; return (() { final int temp = this._index = temp + (1); return temp; })(); })(); return this._generator(temp); })();
  return true;
}
  return false;
}
  }
  
}

/// 转换后的类: _CppUnmodifiableIterable
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/Iterable.dart

class _CppUnmodifiableIterable<E> extends CppIterable<E> {
  late List _elements;
_CppUnmodifiableIterable(List _elements) : _elements = _elements, super()   {
    ;
  }
  
  static Iterator iterator(Object self) {
    return return this._elements.iterator;;
  }
  
  static int length(Object self) {
    return return this._elements.length;;
  }
  
}

/// 转换后的类: _CppCastFromIterable
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/Iterable.dart

class _CppCastFromIterable<S, R> extends CppIterable<S, R> {
  late Iterable _source;
_CppCastFromIterable(Iterable _source) : _source = _source, super()   {
    ;
  }
  
  static Iterator iterator(Object self) {
    return return new _CppCastFromIterator(this._source.iterator);;
  }
  
  static int length(Object self) {
    return return this._source.length;;
  }
  
}

/// 转换后的类: _CppCastFromIterator
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/Iterable.dart

class _CppCastFromIterator<S, R> extends CppIterator<S, R> {
  late Iterator _iterator;
_CppCastFromIterator(Iterator _iterator) : _iterator = _iterator, super()   {
    ;
  }
  
  static Object current(Object self) {
    return return this._iterator.current as Object;;
  }
  
  bool moveNext() {
    return this._iterator.moveNext();
  }
  
  static bool moveNext(Object self) {
    return this._iterator.moveNext();
  }
  
}

/// 转换后的类: CppError
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/error.dart

class CppError implements Error {
CppError() : super()   {
    ;
  }
  
  static StackTrace stackTrace(Object self) {
    return return current;;
  }
  
  static StackTrace _stackTrace(Object self) {
    return return throw NoSuchMethodError.withInvocation(this, new _InvocationMirror._withType(ConstantExpression(#_stackTrace), 1, [], [], Map.unmodifiable({})));;
  }
  
  static set _stackTrace(Object self, StackTrace value) {
    return throw NoSuchMethodError.withInvocation(this, new _InvocationMirror._withType(ConstantExpression(#_stackTrace=), 2, [], List.unmodifiable(_GrowableList._literal1(value)), Map.unmodifiable({})));
  }
  
}

/// 转换后的类: CppStackTrace
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/error.dart

class CppStackTrace implements StackTrace {
  static CppStackTrace _current;
CppStackTrace() : super()   {
    ;
  }
  
  static CppStackTrace current(Object self) {
    return return _current;;
  }
  
  String toString() {
    return CppApi.getCurrentStackTrace();
  }
  
  static String toString(Object self) {
    return CppApi.getCurrentStackTrace();
  }
  
}

/// 转换后的类: CppStringBuffer
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/string.dart

class CppStringBuffer implements StringBuffer {
  late CppList _parts;
CppStringBuffer(Object content) : _parts = (() { final CppList temp = new CppList(0, 16); return (() {
temp.add(content.toString());
return temp;
})(); })(), super()   {
    ;
  }
  
  Object write(Object obj) {
    {
  this._parts.add(obj.toString());
}
  }
  
  Object writeAll(Iterable objects, String separator) {
    {
  Iterator iterator = objects.iterator;
  if (iterator.moveNext()) {
  this._parts.add(iterator.current.toString());
  while (iterator.moveNext()) {
  if (separator.isNotEmpty) {
  this._parts.add(separator);
}
  this._parts.add(iterator.current.toString());
}
}
}
  }
  
  Object writeCharCode(int charCode) {
    {
  this._parts.add(String.fromCharCode(charCode));
}
  }
  
  Object writeln(Object obj) {
    {
  this._parts.add(obj.toString());
  this._parts.add("
");
}
  }
  
  Object clear() {
    {
  this._parts.clear();
}
  }
  
  String toString() {
    {
  return this._parts.join("");
}
  }
  
  static int length(Object self) {
    return {
  return this._parts.fold(0, (int sum, String part) => return sum + (part.length););
};
  }
  
  static bool isEmpty(Object self) {
    return return this._parts.isEmpty;;
  }
  
  static bool isNotEmpty(Object self) {
    return return this._parts.isNotEmpty;;
  }
  
  static List _parts(Object self) {
    return return throw NoSuchMethodError.withInvocation(this, new _InvocationMirror._withType(ConstantExpression(#_parts), 1, [], [], Map.unmodifiable({})));;
  }
  
  static set _parts(Object self, List value) {
    return throw NoSuchMethodError.withInvocation(this, new _InvocationMirror._withType(ConstantExpression(#_parts=), 2, [], List.unmodifiable(_GrowableList._literal1(value)), Map.unmodifiable({})));
  }
  
  static int _partsCodeUnits(Object self) {
    return return throw NoSuchMethodError.withInvocation(this, new _InvocationMirror._withType(ConstantExpression(#_partsCodeUnits), 1, [], [], Map.unmodifiable({})));;
  }
  
  static set _partsCodeUnits(Object self, int value) {
    return throw NoSuchMethodError.withInvocation(this, new _InvocationMirror._withType(ConstantExpression(#_partsCodeUnits=), 2, [], List.unmodifiable(_GrowableList._literal1(value)), Map.unmodifiable({})));
  }
  
  static int _partsCompactionIndex(Object self) {
    return return throw NoSuchMethodError.withInvocation(this, new _InvocationMirror._withType(ConstantExpression(#_partsCompactionIndex), 1, [], [], Map.unmodifiable({})));;
  }
  
  static set _partsCompactionIndex(Object self, int value) {
    return throw NoSuchMethodError.withInvocation(this, new _InvocationMirror._withType(ConstantExpression(#_partsCompactionIndex=), 2, [], List.unmodifiable(_GrowableList._literal1(value)), Map.unmodifiable({})));
  }
  
  static int _partsCodeUnitsSinceCompaction(Object self) {
    return return throw NoSuchMethodError.withInvocation(this, new _InvocationMirror._withType(ConstantExpression(#_partsCodeUnitsSinceCompaction), 1, [], [], Map.unmodifiable({})));;
  }
  
  static set _partsCodeUnitsSinceCompaction(Object self, int value) {
    return throw NoSuchMethodError.withInvocation(this, new _InvocationMirror._withType(ConstantExpression(#_partsCodeUnitsSinceCompaction=), 2, [], List.unmodifiable(_GrowableList._literal1(value)), Map.unmodifiable({})));
  }
  
  static Uint16List _buffer(Object self) {
    return return throw NoSuchMethodError.withInvocation(this, new _InvocationMirror._withType(ConstantExpression(#_buffer), 1, [], [], Map.unmodifiable({})));;
  }
  
  static set _buffer(Object self, Uint16List value) {
    return throw NoSuchMethodError.withInvocation(this, new _InvocationMirror._withType(ConstantExpression(#_buffer=), 2, [], List.unmodifiable(_GrowableList._literal1(value)), Map.unmodifiable({})));
  }
  
  static int _bufferPosition(Object self) {
    return return throw NoSuchMethodError.withInvocation(this, new _InvocationMirror._withType(ConstantExpression(#_bufferPosition), 1, [], [], Map.unmodifiable({})));;
  }
  
  static set _bufferPosition(Object self, int value) {
    return throw NoSuchMethodError.withInvocation(this, new _InvocationMirror._withType(ConstantExpression(#_bufferPosition=), 2, [], List.unmodifiable(_GrowableList._literal1(value)), Map.unmodifiable({})));
  }
  
  static int _bufferCodeUnitMagnitude(Object self) {
    return return throw NoSuchMethodError.withInvocation(this, new _InvocationMirror._withType(ConstantExpression(#_bufferCodeUnitMagnitude), 1, [], [], Map.unmodifiable({})));;
  }
  
  static set _bufferCodeUnitMagnitude(Object self, int value) {
    return throw NoSuchMethodError.withInvocation(this, new _InvocationMirror._withType(ConstantExpression(#_bufferCodeUnitMagnitude=), 2, [], List.unmodifiable(_GrowableList._literal1(value)), Map.unmodifiable({})));
  }
  
  Object _writeString(String str) {
    return throw NoSuchMethodError.withInvocation(this, new _InvocationMirror._withType(ConstantExpression(#_writeString), 0, [], List.unmodifiable(_GrowableList._literal1(str)), Map.unmodifiable({})));
  }
  
  Object _ensureCapacity(int n) {
    return throw NoSuchMethodError.withInvocation(this, new _InvocationMirror._withType(ConstantExpression(#_ensureCapacity), 0, [], List.unmodifiable(_GrowableList._literal1(n)), Map.unmodifiable({})));
  }
  
  Object _consumeBuffer() {
    return throw NoSuchMethodError.withInvocation(this, new _InvocationMirror._withType(ConstantExpression(#_consumeBuffer), 0, [], [], Map.unmodifiable({})));
  }
  
  Object _addPart(String str) {
    return throw NoSuchMethodError.withInvocation(this, new _InvocationMirror._withType(ConstantExpression(#_addPart), 0, [], List.unmodifiable(_GrowableList._literal1(str)), Map.unmodifiable({})));
  }
  
  Object _compact() {
    return throw NoSuchMethodError.withInvocation(this, new _InvocationMirror._withType(ConstantExpression(#_compact), 0, [], [], Map.unmodifiable({})));
  }
  
  static Object write(Object self, Object obj) {
    {
  this._parts.add(obj.toString());
}
  }
  
  static Object writeAll(Object self, Iterable objects, String separator) {
    {
  Iterator iterator = objects.iterator;
  if (iterator.moveNext()) {
  this._parts.add(iterator.current.toString());
  while (iterator.moveNext()) {
  if (separator.isNotEmpty) {
  this._parts.add(separator);
}
  this._parts.add(iterator.current.toString());
}
}
}
  }
  
  static Object writeCharCode(Object self, int charCode) {
    {
  this._parts.add(String.fromCharCode(charCode));
}
  }
  
  static Object writeln(Object self, Object obj) {
    {
  this._parts.add(obj.toString());
  this._parts.add("
");
}
  }
  
  static Object clear(Object self) {
    {
  this._parts.clear();
}
  }
  
  static String toString(Object self) {
    {
  return this._parts.join("");
}
  }
  
  static Object _writeString(Object self, String str) {
    return throw NoSuchMethodError.withInvocation(this, new _InvocationMirror._withType(ConstantExpression(#_writeString), 0, [], List.unmodifiable(_GrowableList._literal1(str)), Map.unmodifiable({})));
  }
  
  static Object _ensureCapacity(Object self, int n) {
    return throw NoSuchMethodError.withInvocation(this, new _InvocationMirror._withType(ConstantExpression(#_ensureCapacity), 0, [], List.unmodifiable(_GrowableList._literal1(n)), Map.unmodifiable({})));
  }
  
  static Object _consumeBuffer(Object self) {
    return throw NoSuchMethodError.withInvocation(this, new _InvocationMirror._withType(ConstantExpression(#_consumeBuffer), 0, [], [], Map.unmodifiable({})));
  }
  
  static Object _addPart(Object self, String str) {
    return throw NoSuchMethodError.withInvocation(this, new _InvocationMirror._withType(ConstantExpression(#_addPart), 0, [], List.unmodifiable(_GrowableList._literal1(str)), Map.unmodifiable({})));
  }
  
  static Object _compact(Object self) {
    return throw NoSuchMethodError.withInvocation(this, new _InvocationMirror._withType(ConstantExpression(#_compact), 0, [], [], Map.unmodifiable({})));
  }
  
}

/// 转换后的类: CppUserData
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/api.dart

class CppUserData {
CppUserData() : super()   {
    ;
  }
  
}

/// 转换后的类: CppApi
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/api.dart


