import 'dart:core';
import 'dart:io';

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
  
  int get length {
    return this._length;
  }
  
  void ensureCapacity(int newLen) {
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
  
  set length(int newLen) {
    {
  this.ensureCapacity(newLen);
  this._length = newLen;
}
  }
  
  void add(E value) {
    {
  this.ensureCapacity(this._length + (1));
  CppApi.cppSetPointerArrayItem(this._array, (() { final int temp_942125 = this._length; return (() { final int temp_942209 = this._length = temp_942125 + (1); return temp_942209; })(); })(), value);
}
  }
  
  void addAll(Iterable<E> iterable) {
    {
  {
  Iterator _sync_for_iterator = iterable.iterator;
  for (; _sync_for_iterator.moveNext();) {
  {
  E element = _sync_for_iterator.current;
  {
  this.add(element);
}
}
}
}
}
  }
  
  bool any(bool Function(E) test) {
    {
  for (int i = 0; i < (this._length); i = i + (1)) {
  {
  if (test(CppApi.cppGetPointerArrayItem(this._array, i) as E)) return true;
}
}
  return false;
}
  }
  
  Map<int, E> asMap() {
    {
  Map map = {};
  for (int i = 0; i < (this._length); i = i + (1)) {
  {
  map[i] = CppApi.cppGetPointerArrayItem(this._array, i) as E;
}
}
  return map;
}
  }
  
  List<R> cast<R>() {
    {
  return CppList.castFrom(this);
}
  }
  
  void clear() {
    {
  this._length = 0;
}
  }
  
  bool contains(Object? element) {
    {
  for (int i = 0; i < (this._length); i = i + (1)) {
  {
  if (CppApi.cppGetPointerArrayItem(this._array, i) == element) return true;
}
}
  return false;
}
  }
  
  E elementAt(int index) {
    return CppApi.cppGetPointerArrayItem(this._array, index) as E;
  }
  
  bool every(bool Function(E) test) {
    {
  for (int i = 0; i < (this._length); i = i + (1)) {
  {
  if (!(test(CppApi.cppGetPointerArrayItem(this._array, i) as E))) return false;
}
}
  return true;
}
  }
  
  void fillRange(int start, int end, E? fillValue) {
    {
  for (int i = start; i < (end); i = i + (1)) {
  {
  CppApi.cppSetPointerArrayItem(this._array, i, (() { final E temp_948149 = fillValue; return (temp_948149 as Object) == null ? (temp_948149 as Object) as E : (temp_948149 as Object); })());
}
}
}
  }
  
  E firstWhere(bool Function(E) test) {
    {
  for (int i = 0; i < (this._length); i = i + (1)) {
  {
  if (test(CppApi.cppGetPointerArrayItem(this._array, i) as E)) {
  return CppApi.cppGetPointerArrayItem(this._array, i) as E;
}
}
}
  if (!(orElse == null)) return orElse();
  throw new StateError("No element")
}
  }
  
  T fold<T>(T initialValue, T Function(T, E) combine) {
    {
  T value = initialValue;
  for (int i = 0; i < (this._length); i = i + (1)) {
  {
  value = combine(value, CppApi.cppGetPointerArrayItem(this._array, i) as E);
}
}
  return value;
}
  }
  
  void forEach(void Function(E) action) {
    {
  for (int i = 0; i < (this._length); i = i + (1)) {
  {
  action(CppApi.cppGetPointerArrayItem(this._array, i) as E);
}
}
}
  }
  
  Iterable<E> getRange(int start, int end) {
    {
  return /* auxiliary expression */;
}
  }
  
  int indexOf(E element, int start) {
    {
  for (int i = start; i < (this._length); i = i + (1)) {
  {
  if (CppApi.cppGetPointerArrayItem(this._array, i) == element) return i;
}
}
  return 1.unary-();
}
  }
  
  int indexWhere(bool Function(E) test, int start) {
    {
  for (int i = start; i < (this._length); i = i + (1)) {
  {
  if (test(CppApi.cppGetPointerArrayItem(this._array, i) as E)) return i;
}
}
  return 1.unary-();
}
  }
  
  void insert(int index, E element) {
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
  
  void insertAll(int index, Iterable<E> iterable) {
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
  
  E get first {
    {
  if (this._length == 0) throw new StateError("No element")
  return CppApi.cppGetPointerArrayItem(this._array, 0) as E;
}
  }
  
  set first(E value) {
    {
  if (this._length == 0) throw new StateError("No element")
  CppApi.cppSetPointerArrayItem(this._array, 0, value);
}
  }
  
  E get last {
    {
  if (this._length == 0) throw new StateError("No element")
  return CppApi.cppGetPointerArrayItem(this._array, this._length - (1)) as E;
}
  }
  
  set last(E value) {
    {
  if (this._length == 0) throw new StateError("No element")
  CppApi.cppSetPointerArrayItem(this._array, this._length - (1), value);
}
  }
  
  E get single {
    {
  if (this._length == 0) throw new StateError("No element")
  if (this._length > (1)) throw new StateError("Too many elements")
  return CppApi.cppGetPointerArrayItem(this._array, 0) as E;
}
  }
  
  bool get isEmpty {
    return this._length == 0;
  }
  
  bool get isNotEmpty {
    return !(this._length == 0);
  }
  
  Iterator<E> get iterator {
    return new _CppListIterator<E>(this);
  }
  
  String join(String separator) {
    {
  if (this._length == 0) return "";
  return CppApi.cppJoinListString(this._array, separator);
}
  }
  
  int lastIndexOf(E element, int? start) {
    {
  int startIndex = (() { final int temp_956952 = start; return temp_956952 == null ? this._length - (1) : temp_956952; })();
  for (int i = startIndex; i >= (0); i = i - (1)) {
  {
  if (CppApi.cppGetPointerArrayItem(this._array, i) == element) return i;
}
}
  return 1.unary-();
}
  }
  
  int lastIndexWhere(bool Function(E) test, int? start) {
    {
  int startIndex = (() { final int temp_957479 = start; return temp_957479 == null ? this._length - (1) : temp_957479; })();
  for (int i = startIndex; i >= (0); i = i - (1)) {
  {
  if (test(CppApi.cppGetPointerArrayItem(this._array, i) as E)) return i;
}
}
  return 1.unary-();
}
  }
  
  E lastWhere(bool Function(E) test) {
    {
  for (int i = this._length - (1); i >= (0); i = i - (1)) {
  {
  if (test(CppApi.cppGetPointerArrayItem(this._array, i) as E)) {
  return CppApi.cppGetPointerArrayItem(this._array, i) as E;
}
}
}
  if (!(orElse == null)) return orElse();
  throw new StateError("No element")
}
  }
  
  E reduce(E Function(E, E) combine) {
    {
  if (this._length == 0) throw new StateError("No element")
  E value = CppApi.cppGetPointerArrayItem(this._array, 0) as E;
  for (int i = 1; i < (this._length); i = i + (1)) {
  {
  value = combine(value, CppApi.cppGetPointerArrayItem(this._array, i) as E);
}
}
  return value;
}
  }
  
  bool remove(Object? value) {
    {
  int index = this.indexOf(value as E);
  if (!(index == 1.unary-())) {
  this.removeAt(index);
  return true;
}
  return false;
}
  }
  
  E removeAt(int index) {
    {
  if (index < (0) || index >= (this._length)) throw new IndexError(index, this)
  Object element = CppApi.cppGetPointerArrayItem(this._array, index);
  for (int i = index; i < (this._length - (1)); i = i + (1)) {
  {
  CppApi.cppSetPointerArrayItem(this._array, i, CppApi.cppGetPointerArrayItem(this._array, i + (1)));
}
}
  this._length = this._length - (1);
  return element as E;
}
  }
  
  E removeLast() {
    {
  if (this._length == 0) throw new StateError("No element")
  return this.removeAt(this._length - (1));
}
  }
  
  void removeRange(int start, int end) {
    {
  if (start < (0) || start > (this._length) || end < (start) || end > (this._length)) {
  throw new RangeError(start, 0, this._length)
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
  
  void removeWhere(bool Function(E) test) {
    {
  int writeIndex = 0;
  for (int readIndex = 0; readIndex < (this._length); readIndex = readIndex + (1)) {
  {
  if (!(test(CppApi.cppGetPointerArrayItem(this._array, readIndex) as E))) {
  if (!(writeIndex == readIndex)) {
  CppApi.cppSetPointerArrayItem(this._array, writeIndex, CppApi.cppGetPointerArrayItem(this._array, readIndex));
}
  writeIndex = writeIndex + (1);
}
}
}
  this._length = writeIndex;
}
  }
  
  void replaceRange(int start, int end, Iterable<E> replacements) {
    {
  if (start < (0) || start > (this._length) || end < (start) || end > (this._length)) {
  throw new RangeError(start, 0, this._length)
}
  List replacementList = replacements.toList();
  int replacementLength = replacementList.length;
  int rangeLength = end - (start);
  if (replacementLength > (rangeLength)) {
  this.ensureCapacity(this._length + (replacementLength) - (rangeLength));
}
  if (!(replacementLength == rangeLength)) {
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
  
  void retainWhere(bool Function(E) test) {
    {
  int writeIndex = 0;
  for (int readIndex = 0; readIndex < (this._length); readIndex = readIndex + (1)) {
  {
  if (test(CppApi.cppGetPointerArrayItem(this._array, readIndex) as E)) {
  if (!(writeIndex == readIndex)) {
  CppApi.cppSetPointerArrayItem(this._array, writeIndex, CppApi.cppGetPointerArrayItem(this._array, readIndex));
}
  writeIndex = writeIndex + (1);
}
}
}
  this._length = writeIndex;
}
  }
  
  void setAll(int index, Iterable<E> iterable) {
    {
  if (index < (0) || index > (this._length)) throw new IndexError(index, this)
  int i = index;
  {
  Iterator _sync_for_iterator = iterable.iterator;
  for (; _sync_for_iterator.moveNext();) {
  {
  E element = _sync_for_iterator.current;
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
  
  void setRange(int start, int end, Iterable<E> iterable, int skipCount) {
    {
  if (start < (0) || start > (this._length) || end < (start) || end > (this._length)) {
  throw new RangeError(start, 0, this._length)
}
  Iterator iterator = iterable.iterator;
  for (int i = 0; i < (skipCount); i = i + (1)) {
  {
  if (!(iterator.moveNext())) return;
}
}
  label: for (int i = start; i < (end); i = i + (1)) {
  {
  if (!(iterator.moveNext())) break label;
  CppApi.cppSetPointerArrayItem(this._array, i, iterator.current);
}
}
}
  }
  
  void shuffle(Random? random) {
    {
  random == null ? random = /* auxiliary expression */ : null;
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
  
  void sort(int Function(E, E)? compare) {
    {
  if (this._length <= (1)) return;
  this._quickSort(0, this._length - (1), compare);
}
  }
  
  void _quickSort(int low, int high, int Function(E, E)? compare) {
    {
  if (low < (high)) {
  int pi = this._partition(low, high, compare);
  this._quickSort(low, pi - (1), compare);
  this._quickSort(pi + (1), high, compare);
}
}
  }
  
  int _partition(int low, int high, int Function(E, E)? compare) {
    {
  E pivot = CppApi.cppGetPointerArrayItem(this._array, high) as E;
  int i = low - (1);
  for (int j = low; j < (high); j = j + (1)) {
  {
  E current = CppApi.cppGetPointerArrayItem(this._array, j) as E;
  bool shouldSwap;
  if (!(compare == null)) {
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
  
  void _swap(int i, int j) {
    {
  E temp = CppApi.cppGetPointerArrayItem(this._array, i) as E;
  CppApi.cppSetPointerArrayItem(this._array, i, CppApi.cppGetPointerArrayItem(this._array, j));
  CppApi.cppSetPointerArrayItem(this._array, j, temp);
}
  }
  
  List<E> sublist(int start, int? end) {
    {
  int endIndex = (() { final int temp_990566 = end; return temp_990566 == null ? this._length : temp_990566; })();
  if (start < (0) || start > (this._length) || endIndex < (start) || endIndex > (this._length)) {
  throw new RangeError(start, 0, this._length)
}
  return /* auxiliary expression */;
}
  }
  
  List<E> toList() {
    {
  return /* auxiliary expression */;
}
  }
  
  Set<E> toSet() {
    {
  return /* auxiliary expression */;
}
  }
  
  E singleWhere(bool Function(E) test) {
    {
  E result;
  bool found = false;
  for (int i = 0; i < (this._length); i = i + (1)) {
  {
  if (test(CppApi.cppGetPointerArrayItem(this._array, i) as E)) {
  if (found) throw new StateError("Too many elements")
  result = CppApi.cppGetPointerArrayItem(this._array, i) as E;
  found = true;
}
}
}
  if (found) return result!;
  if (!(orElse == null)) return orElse();
  throw new StateError("No element")
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
  
  static int _getSuggestCapacity(int newLen) {
    {
  return newLen > (256) ? newLen : UnknownClass.pow(2, UnknownClass.log(newLen) / (UnknownClass.log(2)).ceil()).toInt();
}
  }
  
  static List<R> castFrom(List<S> source) {
    {
  CppList result = new CppList<E>(0, 4);
  {
  Iterator _sync_for_iterator = source.iterator;
  for (; _sync_for_iterator.moveNext();) {
  {
  S element = _sync_for_iterator.current;
  {
  result.add(element as R);
}
}
}
}
  return result;
}
  }
  
  static List<R> castFromWithFactory(List<S> source, List<R> Function() newList) {
    {
  List result = newList();
  {
  Iterator _sync_for_iterator = source.iterator;
  for (; _sync_for_iterator.moveNext();) {
  {
  S element = _sync_for_iterator.current;
  {
  result.add(element as R);
}
}
}
}
  return result;
}
  }
  
  E operator [](int index) {
    return CppApi.cppGetPointerArrayItem(this._array, index) as E;
  }
  
  void operator []=(int index, E value) {
    return CppApi.cppSetPointerArrayItem(this._array, index, value);
  }
  
  List<E> operator +(List<E> other) {
    {
  CppList result = new CppList<E>(0, this._length + (other.length));
  for (int i = 0; i < (this._length); i = i + (1)) {
  {
  result.add(CppApi.cppGetPointerArrayItem(this._array, i) as E);
}
}
  {
  Iterator _sync_for_iterator = other.iterator;
  for (; _sync_for_iterator.moveNext();) {
  {
  E element = _sync_for_iterator.current;
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
  late CppList<E> _list;
_CppListIterator(CppList<E> _list) : _list = _list, super()   {
    ;
  }
  
  E get current {
    return this._list[this._index];
  }
  
  bool moveNext() {
    {
  this._index = this._index + (1);
  return this._index < (this._list.length);
}
  }
  
}

/// 转换后的类: CppSet
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/collection.dart

class CppSet<E> extends CppIterable<E> implements Set<E> {
  late CppList<E> _list;
CppSet.fromCppArray(CppUserData array) : _list = new CppList<E>(array), super()   {
    ;
  }
  
CppSet(int capacity) : _list = new CppList<E>(0, capacity), super()   {
    ;
  }
  
  bool add(E value) {
    {
  if (this.contains(value)) {
  return false;
}
  this._list.add(value);
  return true;
}
  }
  
  void addAll(Iterable<E> elements) {
    {
  {
  Iterator _sync_for_iterator = elements.iterator;
  for (; _sync_for_iterator.moveNext();) {
  {
  E element = _sync_for_iterator.current;
  {
  this.add(element);
}
}
}
}
}
  }
  
  Set<R> cast<R>() {
    {
  return CppSet.castFrom(this);
}
  }
  
  void clear() {
    {
  this._list.clear();
}
  }
  
  bool contains(Object? element) {
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
  
  bool containsAll(Iterable<Object?> other) {
    {
  {
  Iterator _sync_for_iterator = other.iterator;
  for (; _sync_for_iterator.moveNext();) {
  {
  Object element = _sync_for_iterator.current;
  {
  if (!(this.contains(element))) return false;
}
}
}
}
  return true;
}
  }
  
  Set<E> difference(Set<Object?> other) {
    {
  CppSet result = new CppSet<E>();
  {
  Iterator _sync_for_iterator = this._list.iterator;
  for (; _sync_for_iterator.moveNext();) {
  {
  E element = _sync_for_iterator.current;
  {
  if (!(other.contains(element))) {
  result.add(element);
}
}
}
}
}
  return result;
}
  }
  
  E elementAt(int index) {
    return this._list.elementAt(index);
  }
  
  Set<E> intersection(Set<Object?> other) {
    {
  CppSet result = new CppSet<E>();
  {
  Iterator _sync_for_iterator = this._list.iterator;
  for (; _sync_for_iterator.moveNext();) {
  {
  E element = _sync_for_iterator.current;
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
  
  E get first {
    {
  if (this._list.isEmpty) throw new StateError("No element")
  return this._list.first;
}
  }
  
  E get last {
    {
  if (this._list.isEmpty) throw new StateError("No element")
  return this._list.last;
}
  }
  
  E get single {
    {
  if (this._list.isEmpty) throw new StateError("No element")
  if (this._list.length > (1)) throw new StateError("Too many elements")
  return this._list.single;
}
  }
  
  bool get isEmpty {
    return this._list.isEmpty;
  }
  
  bool get isNotEmpty {
    return this._list.isNotEmpty;
  }
  
  Iterator<E> get iterator {
    return this._list.iterator;
  }
  
  int get length {
    return this._list.length;
  }
  
  E? lookup(Object? element) {
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
  
  bool remove(Object? value) {
    {
  return this._list.remove(value);
}
  }
  
  void removeAll(Iterable<Object?> elementsToRemove) {
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
  
  void removeWhere(bool Function(E) test) {
    {
  this._list.removeWhere(test);
}
  }
  
  void retainAll(Iterable<Object?> elementsToRetain) {
    {
  CppSet retainSet = /* auxiliary expression */;
  this.removeWhere((E element) => return !(retainSet.contains(element)););
}
  }
  
  void retainWhere(bool Function(E) test) {
    {
  this._list.retainWhere(test);
}
  }
  
  Set<E> union(Set<E> other) {
    {
  CppSet result = new CppSet<E>();
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
  
  static Set<R> castFrom(Set<S> source) {
    {
  CppSet result = new CppSet<E>();
  {
  Iterator _sync_for_iterator = source.iterator;
  for (; _sync_for_iterator.moveNext();) {
  {
  S element = _sync_for_iterator.current;
  {
  result.add(element as R);
}
}
}
}
  return result;
}
  }
  
  static Set<R> castFromWithFactory(Set<S> source, Set<R> Function() newSet) {
    {
  Set result = newSet();
  {
  Iterator _sync_for_iterator = source.iterator;
  for (; _sync_for_iterator.moveNext();) {
  {
  S element = _sync_for_iterator.current;
  {
  result.add(element as R);
}
}
}
}
  return result;
}
  }
  
}

/// 转换后的类: CppMap
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/collection.dart

class CppMap<K, V> implements Map<K, V> {
  late CppList<MapEntry<K, V>> _list;
CppMap.fromCppArray(CppUserData array) : _list = new CppList<E>(array), super()   {
    ;
  }
  
CppMap(int capacity) : _list = new CppList<E>(0, capacity), super()   {
    ;
  }
  
  void addAll(Map<K, V> other) {
    {
  other.forEach((K k, V v) => return (() { final K temp_64875 = k; return (() { final V temp_64911 = v; return (() { final Object temp_64937 = this[(temp_64911 as Object)] = (temp_64911 as Object); return temp_64937; })(); })(); })(););
}
  }
  
  void addEntries(Iterable<MapEntry<K, V>> entries) {
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
  
  Map<Object, Object> cast<RK, RV>() {
    return CppMap.castFrom(this);
  }
  
  void clear() {
    {
  this._list.clear();
}
  }
  
  bool containsKey(Object? key) {
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
  
  bool containsValue(Object? value) {
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
  
  Iterable<MapEntry<K, V>> get entries {
    return this._list;
  }
  
  void forEach(void Function(K, V) action) {
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
  
  bool get isEmpty {
    return this._list.isEmpty;
  }
  
  bool get isNotEmpty {
    return this._list.isNotEmpty;
  }
  
  Iterable<K> get keys {
    return this._list.map((MapEntry e) => return e.key;);
  }
  
  int get length {
    return this._list.length;
  }
  
  V putIfAbsent(K key, V Function() ifAbsent) {
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
  V v = ifAbsent();
  this._list.add(new MapEntry<K, V>(key, v));
  return v;
}
  }
  
  V? remove(Object? key) {
    {
  for (int i = 0; i < (this._list.length); i = i + (1)) {
  {
  if (this._list[i].key == key) {
  V v = this._list[i].value;
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
  
  void removeWhere(bool Function(K, V) test) {
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
  
  V update(K key, V Function(V) update) {
    {
  for (int i = 0; i < (this._list.length); i = i + (1)) {
  {
  if (this._list[i].key == key) {
  V newValue = update(this._list[i].value);
  this._list[i] = new MapEntry<K, V>(key, newValue);
  return newValue;
}
}
}
  if (!(ifAbsent == null)) {
  V v = ifAbsent();
  this._list.add(new MapEntry<K, V>(key, v));
  return v;
}
  throw new ArgumentError("Key not found")
}
  }
  
  void updateAll(V Function(K, V) update) {
    {
  for (int i = 0; i < (this._list.length); i = i + (1)) {
  {
  MapEntry entry = this._list[i];
  this._list[i] = new MapEntry<K, V>(entry.key, update(entry.key, entry.value));
}
}
}
  }
  
  Iterable<V> get values {
    return this._list.map((MapEntry e) => return e.value;);
  }
  
  Map<Object, Object> map<K2, V2>(MapEntry<Object, Object> Function(K, V) transform) {
    {
  CppMap result = new CppMap<K, V>();
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
  
  static Map<Object, Object> castFrom(Map<K, V> source) {
    {
  CppMap result = new CppMap<K, V>();
  source.forEach((K key, V value) => {
  result[key as RK] = value as RV;
});
  return result;
}
  }
  
  static Map<Object, Object> castFromWithFactory(Map<K, V> source, Map<Object, Object> Function() newMap) {
    {
  Map result = newMap();
  source.forEach((K key, V value) => {
  result[key as RK] = value as RV;
});
  return result;
}
  }
  
  V? operator [](Object? key) {
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
  
  void operator []=(K key, V value) {
    {
  for (int i = 0; i < (this._list.length); i = i + (1)) {
  {
  if (this._list[i].key == key) {
  this._list[i] = new MapEntry<K, V>(key, value);
  return;
}
}
}
  this._list.add(new MapEntry<K, V>(key, value));
}
  }
  
}

/// 转换后的类: CppIterator
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/Iterable.dart

abstract class CppIterator<E> implements Iterator<E> {
CppIterator() : super()   {
    ;
  }
  
  E get current;
  
  bool moveNext();
  
}

/// 转换后的类: CppIterable
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/Iterable.dart

abstract class CppIterable<E> implements Iterable<E> {
CppIterable() : super()   {
    ;
  }
  
  Iterator<E> get iterator;
  
  int get length;
  
  bool get isEmpty {
    return this.length == 0;
  }
  
  bool get isNotEmpty {
    return this.length > (0);
  }
  
  E get first {
    {
  if (this.isEmpty) throw new StateError("No element")
  Iterator it = this.iterator;
  if (!(it.moveNext())) throw new StateError("No element")
  return it.current;
}
  }
  
  E get last {
    {
  if (this.isEmpty) throw new StateError("No element")
  Iterator it = this.iterator;
  E result;
  while (it.moveNext()) {
  result = it.current;
}
  return (() { final E temp_108808 = result; return (temp_108808 as Object) == null ? (temp_108808 as Object) as E : (temp_108808 as Object); })();
}
  }
  
  E get single {
    {
  if (this.isEmpty) throw new StateError("No element")
  Iterator it = this.iterator;
  it.moveNext();
  E result = it.current;
  if (it.moveNext()) throw new StateError("Too many elements")
  return result;
}
  }
  
  E elementAt(int index) {
    {
  if (index < (0)) throw new ArgumentError("Index cannot be negative")
  Iterator it = this.iterator;
  for (int i = 0; i <= (index); i = i + (1)) {
  {
  if (!(it.moveNext())) throw new IndexError(index, this)
  if (i == index) return it.current;
}
}
  throw new IndexError(index, this)
}
  }
  
  bool contains(Object? element) {
    {
  Iterator it = this.iterator;
  while (it.moveNext()) {
  if (it.current == element) return true;
}
  return false;
}
  }
  
  void forEach(void Function(E) action) {
    {
  Iterator it = this.iterator;
  while (it.moveNext()) {
  action(it.current);
}
}
  }
  
  Iterable<T> map<T>(T Function(E) toElement) {
    {
  return new CppMappedIterable<S, T>(this, toElement);
}
  }
  
  Iterable<E> where(bool Function(E) test) {
    {
  return new CppWhereIterable<E>(this, test);
}
  }
  
  Iterable<T> whereType<T>() {
    {
  return new CppWhereTypeIterable<T>(this);
}
  }
  
  Iterable<T> expand<T>(Iterable<T> Function(E) toElements) {
    {
  return new CppExpandIterable<S, T>(this, toElements);
}
  }
  
  bool any(bool Function(E) test) {
    {
  Iterator it = this.iterator;
  while (it.moveNext()) {
  if (test(it.current)) return true;
}
  return false;
}
  }
  
  bool every(bool Function(E) test) {
    {
  Iterator it = this.iterator;
  while (it.moveNext()) {
  if (!(test(it.current))) return false;
}
  return true;
}
  }
  
  E firstWhere(bool Function(E) test) {
    {
  Iterator it = this.iterator;
  while (it.moveNext()) {
  if (test(it.current)) return it.current;
}
  if (!(orElse == null)) return orElse();
  throw new StateError("No element")
}
  }
  
  E lastWhere(bool Function(E) test) {
    {
  Iterator it = this.iterator;
  E result;
  bool found = false;
  while (it.moveNext()) {
  if (test(it.current)) {
  result = it.current;
  found = true;
}
}
  if (found) return (() { final E temp_112041 = result; return (temp_112041 as Object) == null ? (temp_112041 as Object) as E : (temp_112041 as Object); })();
  if (!(orElse == null)) return orElse();
  throw new StateError("No element")
}
  }
  
  E singleWhere(bool Function(E) test) {
    {
  Iterator it = this.iterator;
  E result;
  bool found = false;
  while (it.moveNext()) {
  if (test(it.current)) {
  if (found) throw new StateError("Too many elements")
  result = it.current;
  found = true;
}
}
  if (found) return (() { final E temp_113032 = result; return (temp_113032 as Object) == null ? (temp_113032 as Object) as E : (temp_113032 as Object); })();
  if (!(orElse == null)) return orElse();
  throw new StateError("No element")
}
  }
  
  E reduce(E Function(E, E) combine) {
    {
  Iterator it = this.iterator;
  if (!(it.moveNext())) throw new StateError("No element")
  E value = it.current;
  while (it.moveNext()) {
  value = combine(value, it.current);
}
  return value;
}
  }
  
  T fold<T>(T initialValue, T Function(T, E) combine) {
    {
  T value = initialValue;
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
  if (!(it.moveNext())) return "";
  StringBuffer buffer = new StringBuffer(it.current.toString());
  while (it.moveNext()) {
  buffer.write(separator);
  buffer.write(it.current.toString());
}
  return buffer.toString();
}
  }
  
  Iterable<E> take(int count) {
    {
  return new CppTakeIterable<E>(this, count);
}
  }
  
  Iterable<E> takeWhile(bool Function(E) test) {
    {
  return new CppTakeWhileIterable<E>(this, test);
}
  }
  
  Iterable<E> skip(int count) {
    {
  return new CppSkipIterable<E>(this, count);
}
  }
  
  Iterable<E> skipWhile(bool Function(E) test) {
    {
  return new CppSkipWhileIterable<E>(this, test);
}
  }
  
  Iterable<E> get reversed {
    {
  return new CppReversedIterable<E>(this);
}
  }
  
  Iterable<E> followedBy(Iterable<E> other) {
    {
  return new CppFollowedByIterable<E>(this, other);
}
  }
  
  List<E> toList() {
    {
  return /* auxiliary expression */;
}
  }
  
  Set<E> toSet() {
    {
  return /* auxiliary expression */;
}
  }
  
  Iterable<T> cast<T>() {
    {
  return new CppCastIterable<S, T>(this);
}
  }
  
  static CppIterable<E> empty() {
    return new _CppEmptyIterable<E>();
  }
  
  static CppIterable<E> generate(int count, E Function(int) generator) {
    {
  return new _CppGenerateIterable<E>(count, generator);
}
  }
  
  static CppIterable<E> unmodifiable(Iterable<E> elements) {
    {
  return new _CppUnmodifiableIterable<E>(elements.toList());
}
  }
  
  static CppIterable<R> castFrom(Iterable<S> source) {
    {
  return new _CppCastFromIterable<S, R>(source);
}
  }
  
}

/// 转换后的类: CppMappedIterable
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/Iterable.dart

class CppMappedIterable<S, T> extends CppIterable<T> {
  late Iterable<S> _source;
  late T Function(S) _f;
CppMappedIterable(Iterable<S> _source, T Function(S) _f) : _source = _source, _f = _f, super()   {
    ;
  }
  
  Iterator<T> get iterator {
    return new CppMappedIterator<S, T>(this._source.iterator, this._f);
  }
  
  int get length {
    return this._source.length;
  }
  
}

/// 转换后的类: CppMappedIterator
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/Iterable.dart

class CppMappedIterator<S, T> extends CppIterator<T> {
  T? _current;
  late Iterator<S> _iterator;
  late T Function(S) _f;
CppMappedIterator(Iterator<S> _iterator, T Function(S) _f) : _iterator = _iterator, _f = _f, super()   {
    ;
  }
  
  T get current {
    return (() { final T temp_145096 = this._current; return (temp_145096 as Object) == null ? (temp_145096 as Object) as T : (temp_145096 as Object); })();
  }
  
  bool moveNext() {
    {
  if (this._iterator.moveNext()) {
  this._current = (() { final S temp_145782 = this._iterator.current; return this._f((temp_145782 as Object)); })();
  return true;
}
  return false;
}
  }
  
}

/// 转换后的类: CppWhereIterable
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/Iterable.dart

class CppWhereIterable<E> extends CppIterable<E> {
  late Iterable<E> _source;
  late bool Function(E) _test;
CppWhereIterable(Iterable<E> _source, bool Function(E) _test) : _source = _source, _test = _test, super()   {
    ;
  }
  
  Iterator<E> get iterator {
    return new CppWhereIterator<E>(this._source.iterator, this._test);
  }
  
  int get length {
    {
  int count = 0;
  Iterator it = this.iterator;
  while (it.moveNext()) {
  count = count + (1);
}
  return count;
}
  }
  
}

/// 转换后的类: CppWhereIterator
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/Iterable.dart

class CppWhereIterator<E> extends CppIterator<E> {
  late Iterator<E> _iterator;
  late bool Function(E) _test;
CppWhereIterator(Iterator<E> _iterator, bool Function(E) _test) : _iterator = _iterator, _test = _test, super()   {
    ;
  }
  
  E get current {
    return this._iterator.current;
  }
  
  bool moveNext() {
    {
  while (this._iterator.moveNext()) {
  if ((() { final E temp_146845 = this._iterator.current; return this._test((temp_146845 as Object)); })()) {
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
  late Iterable<Object?> _source;
CppWhereTypeIterable(Iterable<Object?> _source) : _source = _source, super()   {
    ;
  }
  
  Iterator<T> get iterator {
    return new CppWhereTypeIterator<T>(this._source.iterator);
  }
  
  int get length {
    {
  int count = 0;
  Iterator it = this.iterator;
  while (it.moveNext()) {
  count = count + (1);
}
  return count;
}
  }
  
}

/// 转换后的类: CppWhereTypeIterator
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/Iterable.dart

class CppWhereTypeIterator<T> extends CppIterator<T> {
  late Iterator<Object?> _iterator;
CppWhereTypeIterator(Iterator<Object?> _iterator) : _iterator = _iterator, super()   {
    ;
  }
  
  T get current {
    return this._iterator.current as T;
  }
  
  bool moveNext() {
    {
  while (this._iterator.moveNext()) {
  if (this._iterator.current is T) {
  return true;
}
}
  return false;
}
  }
  
}

/// 转换后的类: CppExpandIterable
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/Iterable.dart

class CppExpandIterable<S, T> extends CppIterable<T> {
  late Iterable<S> _source;
  late Iterable<T> Function(S) _f;
CppExpandIterable(Iterable<S> _source, Iterable<T> Function(S) _f) : _source = _source, _f = _f, super()   {
    ;
  }
  
  Iterator<T> get iterator {
    return new CppExpandIterator<S, T>(this._source.iterator, this._f);
  }
  
  int get length {
    {
  int count = 0;
  Iterator it = this.iterator;
  while (it.moveNext()) {
  count = count + (1);
}
  return count;
}
  }
  
}

/// 转换后的类: CppExpandIterator
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/Iterable.dart

class CppExpandIterator<S, T> extends CppIterator<T> {
  Iterator<T>? _currentIterator;
  late Iterator<S> _iterator;
  late Iterable<T> Function(S) _f;
CppExpandIterator(Iterator<S> _iterator, Iterable<T> Function(S) _f) : _iterator = _iterator, _f = _f, super()   {
    ;
  }
  
  T get current {
    return this._currentIterator!.current;
  }
  
  bool moveNext() {
    {
  while (true) {
  if (!(this._currentIterator == null) && this._currentIterator!.moveNext()) {
  return true;
}
  if (!(this._iterator.moveNext())) {
  return false;
}
  this._currentIterator = (() { final S temp_149115 = this._iterator.current; return this._f((temp_149115 as Object)); })().iterator;
}
}
  }
  
}

/// 转换后的类: CppTakeIterable
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/Iterable.dart

class CppTakeIterable<E> extends CppIterable<E> {
  late Iterable<E> _source;
  late int _count;
CppTakeIterable(Iterable<E> _source, int _count) : _source = _source, _count = _count, super()   {
    ;
  }
  
  Iterator<E> get iterator {
    return new CppTakeIterator<E>(this._source.iterator, this._count);
  }
  
  int get length {
    return UnknownClass.min(this._count, this._source.length);
  }
  
}

/// 转换后的类: CppTakeIterator
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/Iterable.dart

class CppTakeIterator<E> extends CppIterator<E> {
  int _remaining;
  late Iterator<E> _iterator;
  late int _count;
CppTakeIterator(Iterator<E> _iterator, int _count) : _iterator = _iterator, _count = _count, _remaining = _count, super()   {
    ;
  }
  
  E get current {
    return this._iterator.current;
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
  
}

/// 转换后的类: CppTakeWhileIterable
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/Iterable.dart

class CppTakeWhileIterable<E> extends CppIterable<E> {
  late Iterable<E> _source;
  late bool Function(E) _test;
CppTakeWhileIterable(Iterable<E> _source, bool Function(E) _test) : _source = _source, _test = _test, super()   {
    ;
  }
  
  Iterator<E> get iterator {
    return new CppTakeWhileIterator<E>(this._source.iterator, this._test);
  }
  
  int get length {
    {
  int count = 0;
  Iterator it = this.iterator;
  while (it.moveNext()) {
  count = count + (1);
}
  return count;
}
  }
  
}

/// 转换后的类: CppTakeWhileIterator
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/Iterable.dart

class CppTakeWhileIterator<E> extends CppIterator<E> {
  bool _finished;
  late Iterator<E> _iterator;
  late bool Function(E) _test;
CppTakeWhileIterator(Iterator<E> _iterator, bool Function(E) _test) : _iterator = _iterator, _test = _test, super()   {
    ;
  }
  
  E get current {
    return this._iterator.current;
  }
  
  bool moveNext() {
    {
  if (this._finished) return false;
  if (this._iterator.moveNext()) {
  if ((() { final E temp_151061 = this._iterator.current; return this._test((temp_151061 as Object)); })()) {
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
  late Iterable<E> _source;
  late int _count;
CppSkipIterable(Iterable<E> _source, int _count) : _source = _source, _count = _count, super()   {
    ;
  }
  
  Iterator<E> get iterator {
    return new CppSkipIterator<E>(this._source.iterator, this._count);
  }
  
  int get length {
    return UnknownClass.max(0, this._source.length - (this._count));
  }
  
}

/// 转换后的类: CppSkipIterator
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/Iterable.dart

class CppSkipIterator<E> extends CppIterator<E> {
  bool _skipped;
  late Iterator<E> _iterator;
  late int _count;
CppSkipIterator(Iterator<E> _iterator, int _count) : _iterator = _iterator, _count = _count, super()   {
    ;
  }
  
  E get current {
    return this._iterator.current;
  }
  
  bool moveNext() {
    {
  if (!(this._skipped)) {
  for (int i = 0; i < (this._count); i = i + (1)) {
  {
  if (!(this._iterator.moveNext())) return false;
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
  late Iterable<E> _source;
  late bool Function(E) _test;
CppSkipWhileIterable(Iterable<E> _source, bool Function(E) _test) : _source = _source, _test = _test, super()   {
    ;
  }
  
  Iterator<E> get iterator {
    return new CppSkipWhileIterator<E>(this._source.iterator, this._test);
  }
  
  int get length {
    {
  int count = 0;
  Iterator it = this.iterator;
  while (it.moveNext()) {
  count = count + (1);
}
  return count;
}
  }
  
}

/// 转换后的类: CppSkipWhileIterator
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/Iterable.dart

class CppSkipWhileIterator<E> extends CppIterator<E> {
  bool _skipped;
  late Iterator<E> _iterator;
  late bool Function(E) _test;
CppSkipWhileIterator(Iterator<E> _iterator, bool Function(E) _test) : _iterator = _iterator, _test = _test, super()   {
    ;
  }
  
  E get current {
    return this._iterator.current;
  }
  
  bool moveNext() {
    {
  if (!(this._skipped)) {
  while (this._iterator.moveNext()) {
  if (!((() { final E temp_153208 = this._iterator.current; return this._test((temp_153208 as Object)); })())) {
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
  late Iterable<E> _source;
CppReversedIterable(Iterable<E> _source) : _source = _source, super()   {
    ;
  }
  
  Iterator<E> get iterator {
    return new CppReversedIterator<E>(this._source);
  }
  
  int get length {
    return this._source.length;
  }
  
}

/// 转换后的类: CppReversedIterator
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/Iterable.dart

class CppReversedIterator<E> extends CppIterator<E> {
  int _index;
  late CppList<E> _elements;
CppReversedIterator(Iterable<E> source) : _elements = /* auxiliary expression */, _index = source.length, super()   {
    ;
  }
  
  E get current {
    return this._elements[this._index];
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
  
}

/// 转换后的类: CppFollowedByIterable
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/Iterable.dart

class CppFollowedByIterable<E> extends CppIterable<E> {
  late Iterable<E> _first;
  late Iterable<E> _second;
CppFollowedByIterable(Iterable<E> _first, Iterable<E> _second) : _first = _first, _second = _second, super()   {
    ;
  }
  
  Iterator<E> get iterator {
    return new CppFollowedByIterator<E>(this._first.iterator, this._second.iterator);
  }
  
  int get length {
    return this._first.length + (this._second.length);
  }
  
}

/// 转换后的类: CppFollowedByIterator
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/Iterable.dart

class CppFollowedByIterator<E> extends CppIterator<E> {
  bool _usingFirst;
  late Iterator<E> _first;
  late Iterator<E> _second;
CppFollowedByIterator(Iterator<E> _first, Iterator<E> _second) : _first = _first, _second = _second, super()   {
    ;
  }
  
  E get current {
    return this._usingFirst ? this._first.current : this._second.current;
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
  
}

/// 转换后的类: CppCastIterable
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/Iterable.dart

class CppCastIterable<S, T> extends CppIterable<T> {
  late Iterable<S> _source;
CppCastIterable(Iterable<S> _source) : _source = _source, super()   {
    ;
  }
  
  Iterator<T> get iterator {
    return new CppCastIterator<S, T>(this._source.iterator);
  }
  
  int get length {
    return this._source.length;
  }
  
}

/// 转换后的类: CppCastIterator
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/Iterable.dart

class CppCastIterator<S, T> extends CppIterator<T> {
  late Iterator<S> _iterator;
CppCastIterator(Iterator<S> _iterator) : _iterator = _iterator, super()   {
    ;
  }
  
  T get current {
    return this._iterator.current as T;
  }
  
  bool moveNext() {
    return this._iterator.moveNext();
  }
  
}

/// 转换后的类: _CppEmptyIterable
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/Iterable.dart

class _CppEmptyIterable<E> extends CppIterable<E> {
_CppEmptyIterable() : super()   {
    ;
  }
  
  Iterator<E> get iterator {
    return new _CppEmptyIterator<E>();
  }
  
  int get length {
    return 0;
  }
  
}

/// 转换后的类: _CppEmptyIterator
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/Iterable.dart

class _CppEmptyIterator<E> extends CppIterator<E> {
_CppEmptyIterator() : super()   {
    ;
  }
  
  E get current {
    throw new StateError("No element")
  }
  
  bool moveNext() {
    return false;
  }
  
}

/// 转换后的类: _CppGenerateIterable
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/Iterable.dart

class _CppGenerateIterable<E> extends CppIterable<E> {
  late int _count;
  late E Function(int) _generator;
_CppGenerateIterable(int _count, E Function(int) _generator) : _count = _count, _generator = _generator, super()   {
    ;
  }
  
  Iterator<E> get iterator {
    return new _CppGenerateIterator<E>(this._count, this._generator);
  }
  
  int get length {
    return this._count;
  }
  
}

/// 转换后的类: _CppGenerateIterator
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/Iterable.dart

class _CppGenerateIterator<E> extends CppIterator<E> {
  int _index;
  E? _current;
  late int _count;
  late E Function(int) _generator;
_CppGenerateIterator(int _count, E Function(int) _generator) : _count = _count, _generator = _generator, super()   {
    ;
  }
  
  E get current {
    return (() { final E temp_156100 = this._current; return (temp_156100 as Object) == null ? (temp_156100 as Object) as E : (temp_156100 as Object); })();
  }
  
  bool moveNext() {
    {
  if (this._index < (this._count)) {
  this._current = (() { final int temp_156665 = (() { final int temp_156685 = this._index; return (() { final int temp_156719 = this._index = temp_156685 + (1); return temp_156719; })(); })(); return this._generator(temp_156665); })();
  return true;
}
  return false;
}
  }
  
}

/// 转换后的类: _CppUnmodifiableIterable
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/Iterable.dart

class _CppUnmodifiableIterable<E> extends CppIterable<E> {
  late List<E> _elements;
_CppUnmodifiableIterable(List<E> _elements) : _elements = _elements, super()   {
    ;
  }
  
  Iterator<E> get iterator {
    return this._elements.iterator;
  }
  
  int get length {
    return this._elements.length;
  }
  
}

/// 转换后的类: _CppCastFromIterable
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/Iterable.dart

class _CppCastFromIterable<S, R> extends CppIterable<R> {
  late Iterable<S> _source;
_CppCastFromIterable(Iterable<S> _source) : _source = _source, super()   {
    ;
  }
  
  Iterator<R> get iterator {
    return new _CppCastFromIterator<S, R>(this._source.iterator);
  }
  
  int get length {
    return this._source.length;
  }
  
}

/// 转换后的类: _CppCastFromIterator
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/Iterable.dart

class _CppCastFromIterator<S, R> extends CppIterator<R> {
  late Iterator<S> _iterator;
_CppCastFromIterator(Iterator<S> _iterator) : _iterator = _iterator, super()   {
    ;
  }
  
  R get current {
    return this._iterator.current as R;
  }
  
  bool moveNext() {
    return this._iterator.moveNext();
  }
  
}

/// 转换后的类: CppError
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/error.dart

class CppError implements Error {
CppError() : super()   {
    ;
  }
  
  StackTrace? get stackTrace {
    return current;
  }
  
  StackTrace? get _stackTrace {
    throw NoSuchMethodError.withInvocation(this, new _InvocationMirror(ConstantExpression(#_stackTrace), 1, [], [], Map.unmodifiable({})))
  }
  
  set _stackTrace(StackTrace? value) {
    throw NoSuchMethodError.withInvocation(this, new _InvocationMirror(ConstantExpression(#_stackTrace=), 2, [], List.unmodifiable(_GrowableList._literal1(value)), Map.unmodifiable({})))
  }
  
  static String safeToString(Object? object) {
    {
  if (object == null) {
  return "null";
}
  if (object is String) {
  return object as String;
}
  return object.toString();
}
  }
  
}

/// 转换后的类: CppStackTrace
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/error.dart

class CppStackTrace implements StackTrace {
  static CppStackTrace _current;
CppStackTrace() : super()   {
    ;
  }
  
  CppStackTrace get current {
    return _current;
  }
  
  String toString() {
    return CppApi.getCurrentStackTrace();
  }
  
}

/// 转换后的类: CppStringBuffer
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/string.dart

class CppStringBuffer implements StringBuffer {
  late CppList<String> _parts;
CppStringBuffer(Object content) : _parts = (() { final CppList temp_159208 = new CppList<E>(0, 16); return (() {
temp_159208.add(content.toString());
return temp_159208;
})(); })(), super()   {
    ;
  }
  
  void write(Object? obj) {
    {
  this._parts.add(obj.toString());
}
  }
  
  void writeAll(Iterable<Object?> objects, String separator) {
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
  
  void writeCharCode(int charCode) {
    {
  this._parts.add(/* auxiliary expression */);
}
  }
  
  void writeln(Object? obj) {
    {
  this._parts.add(obj.toString());
  this._parts.add("\n");
}
  }
  
  void clear() {
    {
  this._parts.clear();
}
  }
  
  String toString() {
    {
  return this._parts.join("");
}
  }
  
  int get length {
    {
  return this._parts.fold(0, (int sum, String part) => return sum + (part.length););
}
  }
  
  bool get isEmpty {
    return this._parts.isEmpty;
  }
  
  bool get isNotEmpty {
    return this._parts.isNotEmpty;
  }
  
  List<String>? get _parts {
    throw NoSuchMethodError.withInvocation(this, new _InvocationMirror(ConstantExpression(#_parts), 1, [], [], Map.unmodifiable({})))
  }
  
  set _parts(List<String>? value) {
    throw NoSuchMethodError.withInvocation(this, new _InvocationMirror(ConstantExpression(#_parts=), 2, [], List.unmodifiable(_GrowableList._literal1(value)), Map.unmodifiable({})))
  }
  
  int get _partsCodeUnits {
    throw NoSuchMethodError.withInvocation(this, new _InvocationMirror(ConstantExpression(#_partsCodeUnits), 1, [], [], Map.unmodifiable({})))
  }
  
  set _partsCodeUnits(int value) {
    throw NoSuchMethodError.withInvocation(this, new _InvocationMirror(ConstantExpression(#_partsCodeUnits=), 2, [], List.unmodifiable(_GrowableList._literal1(value)), Map.unmodifiable({})))
  }
  
  int get _partsCompactionIndex {
    throw NoSuchMethodError.withInvocation(this, new _InvocationMirror(ConstantExpression(#_partsCompactionIndex), 1, [], [], Map.unmodifiable({})))
  }
  
  set _partsCompactionIndex(int value) {
    throw NoSuchMethodError.withInvocation(this, new _InvocationMirror(ConstantExpression(#_partsCompactionIndex=), 2, [], List.unmodifiable(_GrowableList._literal1(value)), Map.unmodifiable({})))
  }
  
  int get _partsCodeUnitsSinceCompaction {
    throw NoSuchMethodError.withInvocation(this, new _InvocationMirror(ConstantExpression(#_partsCodeUnitsSinceCompaction), 1, [], [], Map.unmodifiable({})))
  }
  
  set _partsCodeUnitsSinceCompaction(int value) {
    throw NoSuchMethodError.withInvocation(this, new _InvocationMirror(ConstantExpression(#_partsCodeUnitsSinceCompaction=), 2, [], List.unmodifiable(_GrowableList._literal1(value)), Map.unmodifiable({})))
  }
  
  Uint16List? get _buffer {
    throw NoSuchMethodError.withInvocation(this, new _InvocationMirror(ConstantExpression(#_buffer), 1, [], [], Map.unmodifiable({})))
  }
  
  set _buffer(Uint16List? value) {
    throw NoSuchMethodError.withInvocation(this, new _InvocationMirror(ConstantExpression(#_buffer=), 2, [], List.unmodifiable(_GrowableList._literal1(value)), Map.unmodifiable({})))
  }
  
  int get _bufferPosition {
    throw NoSuchMethodError.withInvocation(this, new _InvocationMirror(ConstantExpression(#_bufferPosition), 1, [], [], Map.unmodifiable({})))
  }
  
  set _bufferPosition(int value) {
    throw NoSuchMethodError.withInvocation(this, new _InvocationMirror(ConstantExpression(#_bufferPosition=), 2, [], List.unmodifiable(_GrowableList._literal1(value)), Map.unmodifiable({})))
  }
  
  int get _bufferCodeUnitMagnitude {
    throw NoSuchMethodError.withInvocation(this, new _InvocationMirror(ConstantExpression(#_bufferCodeUnitMagnitude), 1, [], [], Map.unmodifiable({})))
  }
  
  set _bufferCodeUnitMagnitude(int value) {
    throw NoSuchMethodError.withInvocation(this, new _InvocationMirror(ConstantExpression(#_bufferCodeUnitMagnitude=), 2, [], List.unmodifiable(_GrowableList._literal1(value)), Map.unmodifiable({})))
  }
  
  void _writeString(String str) {
    throw NoSuchMethodError.withInvocation(this, new _InvocationMirror(ConstantExpression(#_writeString), 0, [], List.unmodifiable(_GrowableList._literal1(str)), Map.unmodifiable({})))
  }
  
  void _ensureCapacity(int n) {
    throw NoSuchMethodError.withInvocation(this, new _InvocationMirror(ConstantExpression(#_ensureCapacity), 0, [], List.unmodifiable(_GrowableList._literal1(n)), Map.unmodifiable({})))
  }
  
  void _consumeBuffer() {
    throw NoSuchMethodError.withInvocation(this, new _InvocationMirror(ConstantExpression(#_consumeBuffer), 0, [], [], Map.unmodifiable({})))
  }
  
  void _addPart(String str) {
    throw NoSuchMethodError.withInvocation(this, new _InvocationMirror(ConstantExpression(#_addPart), 0, [], List.unmodifiable(_GrowableList._literal1(str)), Map.unmodifiable({})))
  }
  
  void _compact() {
    throw NoSuchMethodError.withInvocation(this, new _InvocationMirror(ConstantExpression(#_compact), 0, [], [], Map.unmodifiable({})))
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

class CppApi {
CppApi() : super()   {
    ;
  }
  
  static CppUserData cppCreatePointerArray(int length) {
    {
  throw new UnimplementedError()
}
  }
  
  static int cppGetPointerArrayLength(CppUserData array) {
    {
  throw new UnimplementedError()
}
  }
  
  static Object? cppGetPointerArrayItem(CppUserData array, int index) {
    {
  throw new UnimplementedError()
}
  }
  
  static void cppSetPointerArrayItem(CppUserData array, int index, Object? value) {
    {
  throw new UnimplementedError()
}
  }
  
  static CppUserData cppCreateByteArray(int length) {
    {
  throw new UnimplementedError()
}
  }
  
  static int cppGetByteArrayLength(CppUserData array) {
    {
  throw new UnimplementedError()
}
  }
  
  static int cppGetByteArrayItem(CppUserData array, int index) {
    {
  throw new UnimplementedError()
}
  }
  
  static int cppSetByteArrayItem(CppUserData array, int index, int value) {
    {
  throw new UnimplementedError()
}
  }
  
  static String cppJoinListString(CppUserData array, String separator) {
    {
  throw new UnimplementedError()
}
  }
  
  static bool cppBoolValue(bool value) {
    {
  throw new UnimplementedError()
}
  }
  
  static String getCurrentStackTrace() {
    {
  throw new UnimplementedError()
}
  }
  
  static void print(Object? object) {
    {
  throw new UnimplementedError()
}
  }
  
}

