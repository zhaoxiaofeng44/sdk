import 'dart:core';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

/// 全局Void类型变量，用于替代void返回值
final Void = null;

/// 转换后的类: CppUserData
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/api.dart

class CppUserData {
  List<dynamic?> data = _GrowableList.<dynamic?>(0);
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
  CppUserData userData = CppUserData();
  userData.data.length = length;
  return userData;
}
  }
  
  static int cppGetPointerArrayLength(CppUserData array) {
    {
  return array.data.length;
}
  }
  
  static Object? cppGetPointerArrayItem(CppUserData array, int index) {
    {
  return array.data[index];
}
  }
  
  static void cppSetPointerArrayItem(CppUserData array, int index, Object? value) {
    {
  array.data[index] = value;
}
  }
  
  static CppUserData cppCreateByteArray(int length) {
    {
  CppUserData userData = CppUserData();
  userData.data.length = length;
  return userData;
}
  }
  
  static int cppGetByteArrayLength(CppUserData array) {
    {
  return array.data.length;
}
  }
  
  static int cppGetByteArrayItem(CppUserData array, int index) {
    {
  return array.data[index] as int;
}
  }
  
  static void cppSetByteArrayItem(CppUserData array, int index, int value) {
    {
  array.data[index] = value;
}
  }
  
  static bool cppBoolValue(bool value) {
    {
  return value;
}
  }
  
  static String getCurrentStackTrace() {
    {
  return StackTrace.current.toString();
}
  }
  
  static void print(Object? object) {
    {
  CppApi.print(object);
}
  }
  
}

/// 转换后的类: CppList
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/collection.dart

class CppList<E> extends CppIterable<E> implements List<E> {
  late int _length;
  late CppUserData _array;
CppList.fromCppArray(CppUserData array) : _length = CppApi.cppGetPointerArrayLength(array), _array = array, super()   {
    ;
  }
  
CppList(int length, int capacity) : _length = length, _array = CppApi.cppCreatePointerArray(length), super()   {
    ;
  }
  
  factory CppList.empty({bool growable = false}) {
    {
  return growable ? CppList<E>(0, 0) : CppList<E>(0, 0);
}
  }
  
  factory CppList.filled(int length, E fill, {bool growable = false}) {
    {
  CppUserData array = CppApi.cppCreatePointerArray(length);
  for (int i = 0; (i < length); i = (i + 1)) {
  {
  CppApi.cppSetPointerArrayItem(array, i, fill);
}
}
  return CppList<E>.fromCppArray(array);
}
  }
  
  factory CppList.from(Iterable<dynamic?> elements, {bool growable = true}) {
    {
  int length = elements.length;
  CppUserData array = growable ? CppApi.cppCreatePointerArray(length) : CppApi.cppCreatePointerArray(CppList._getSuggestCapacity(length));
  int i = 0;
  {
  Iterator<dynamic?> _sync_for_iterator = elements.iterator;
  for (; _sync_for_iterator.moveNext();) {
  {
  dynamic? element = _sync_for_iterator.current;
  {
  CppApi.cppSetPointerArrayItem(array, (() { final int temp_1290_2299 = i; return (() { final int temp_1290_2303 = i = (temp_1290_2299 + 1); return temp_1290_2299; })(); })(), element);
}
}
}
}
  return CppList<E>.fromCppArray(array);
}
  }
  
  factory CppList.of(Iterable<E> elements, {bool growable = true}) {
    return CppList<E>.from(elements, growable: growable);
  }
  
  factory CppList.generate(int length, E Function(int) generator, {bool growable = true}) {
    {
  CppUserData array = growable ? CppApi.cppCreatePointerArray(length) : CppApi.cppCreatePointerArray(CppList._getSuggestCapacity(length));
  for (int i = 0; (i < length); i = (i + 1)) {
  {
  CppApi.cppSetPointerArrayItem(array, i, generator(i));
}
}
  return CppList<E>.fromCppArray(array);
}
  }
  
  factory CppList.unmodifiable(Iterable<dynamic?> elements) {
    {
  int length = elements.length;
  CppUserData array = CppApi.cppCreatePointerArray(length);
  int i = 0;
  {
  Iterator<dynamic?> _sync_for_iterator = elements.iterator;
  for (; _sync_for_iterator.moveNext();) {
  {
  dynamic? element = _sync_for_iterator.current;
  {
  CppApi.cppSetPointerArrayItem(array, (() { final int temp_2119_2395 = i; return (() { final int temp_2119_2399 = i = (temp_2119_2395 + 1); return temp_2119_2395; })(); })(), element as E);
}
}
}
}
  return CppList<E>.fromCppArray(array);
}
  }
  
  int get length {
    return this._length;
  }
  
  void ensureCapacity(int newLen) {
    {
  if ((newLen > CppApi.cppGetPointerArrayLength(this._array))) {
  CppUserData newArray = CppApi.cppCreatePointerArray(CppList._getSuggestCapacity(newLen));
  for (int i = 0; (i < CppApi.cppGetPointerArrayLength(this._array)); i = (i + 1)) {
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
  this.ensureCapacity((this._length + 1));
  CppApi.cppSetPointerArrayItem(this._array, (() { final int temp_3215_2552 = this._length; return (() { final int temp_3208_2557 = this._length = (temp_3215_2552 + 1); return temp_3215_2552; })(); })(), value);
}
  }
  
  void addAll(Iterable<E> iterable) {
    {
  {
  Iterator<E> _sync_for_iterator = iterable.iterator;
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
  for (int i = 0; (i < this._length); i = (i + 1)) {
  {
  if (test(CppApi.cppGetPointerArrayItem(this._array, i) as E)) return true;
}
}
  return false;
}
  }
  
  Map<int, E> asMap() {
    {
  Map<int, E> map = <int, E>{};
  for (int i = 0; (i < this._length); i = (i + 1)) {
  {
  map[i] = CppApi.cppGetPointerArrayItem(this._array, i) as E;
}
}
  return map;
}
  }
  
  List<R> cast<R>() {
    {
  return CppList.castFrom<E, R>(this);
}
  }
  
  void clear() {
    {
  this._length = 0;
}
  }
  
  bool contains(Object? element) {
    {
  for (int i = 0; (i < this._length); i = (i + 1)) {
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
  for (int i = 0; (i < this._length); i = (i + 1)) {
  {
  if (!(test(CppApi.cppGetPointerArrayItem(this._array, i) as E))) return false;
}
}
  return true;
}
  }
  
  void fillRange(int start, int end, [E? fillValue = null]) {
    {
  for (int i = start; (i < end); i = (i + 1)) {
  {
  CppApi.cppSetPointerArrayItem(this._array, i, (() { final E? temp_1563 = fillValue; return temp_1563 == null ? temp_1563 as E : temp_1563; })());
}
}
}
  }
  
  E firstWhere(bool Function(E) test, {E Function()? orElse = null}) {
    {
  for (int i = 0; (i < this._length); i = (i + 1)) {
  {
  if (test(CppApi.cppGetPointerArrayItem(this._array, i) as E)) {
  return CppApi.cppGetPointerArrayItem(this._array, i) as E;
}
}
}
  if (!(orElse == null)) return orElse();
  throw StateError("No element");
}
  }
  
  T fold<T>(T initialValue, T Function(T, E) combine) {
    {
  T value = initialValue;
  for (int i = 0; (i < this._length); i = (i + 1)) {
  {
  value = combine(value, CppApi.cppGetPointerArrayItem(this._array, i) as E);
}
}
  return value;
}
  }
  
  void forEach(void Function(E) action) {
    {
  for (int i = 0; (i < this._length); i = (i + 1)) {
  {
  action(CppApi.cppGetPointerArrayItem(this._array, i) as E);
}
}
}
  }
  
  Iterable<E> getRange(int start, int end) {
    {
  return CppList<E>.from(Iterable<dynamic?>.generate((end - start), (int i) { return CppApi.cppGetPointerArrayItem(this._array, (start + i));}));
}
  }
  
  int indexOf(E element, [int start = 0]) {
    {
  for (int i = start; (i < this._length); i = (i + 1)) {
  {
  if (CppApi.cppGetPointerArrayItem(this._array, i) == element) return i;
}
}
  return -1;
}
  }
  
  int indexWhere(bool Function(E) test, [int start = 0]) {
    {
  for (int i = start; (i < this._length); i = (i + 1)) {
  {
  if (test(CppApi.cppGetPointerArrayItem(this._array, i) as E)) return i;
}
}
  return -1;
}
  }
  
  void insert(int index, E element) {
    {
  if ((index < 0) || (index > this._length)) throw IndexError(index, this);
  this.ensureCapacity((this._length + 1));
  for (int i = this._length; (i > index); i = (i - 1)) {
  {
  CppApi.cppSetPointerArrayItem(this._array, i, CppApi.cppGetPointerArrayItem(this._array, (i - 1)));
}
}
  CppApi.cppSetPointerArrayItem(this._array, index, element);
  this._length = (this._length + 1);
}
  }
  
  void insertAll(int index, Iterable<E> iterable) {
    {
  if ((index < 0) || (index > this._length)) throw IndexError(index, this);
  List<E> elements = iterable.toList();
  int insertLength = elements.length;
  if (insertLength == 0) return;
  this.ensureCapacity((this._length + insertLength));
  for (int i = (this._length - 1); (i >= index); i = (i - 1)) {
  {
  CppApi.cppSetPointerArrayItem(this._array, (i + insertLength), CppApi.cppGetPointerArrayItem(this._array, i));
}
}
  for (int i = 0; (i < insertLength); i = (i + 1)) {
  {
  CppApi.cppSetPointerArrayItem(this._array, (index + i), elements[i]);
}
}
  this._length = (this._length + insertLength);
}
  }
  
  E get first {
    {
  if (this._length == 0) throw StateError("No element");
  return CppApi.cppGetPointerArrayItem(this._array, 0) as E;
}
  }
  
  set first(E value) {
    {
  if (this._length == 0) throw StateError("No element");
  CppApi.cppSetPointerArrayItem(this._array, 0, value);
}
  }
  
  E get last {
    {
  if (this._length == 0) throw StateError("No element");
  return CppApi.cppGetPointerArrayItem(this._array, (this._length - 1)) as E;
}
  }
  
  set last(E value) {
    {
  if (this._length == 0) throw StateError("No element");
  CppApi.cppSetPointerArrayItem(this._array, (this._length - 1), value);
}
  }
  
  E get single {
    {
  if (this._length == 0) throw StateError("No element");
  if ((this._length > 1)) throw StateError("Too many elements");
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
    return _CppListIterator<E>(this);
  }
  
  String join([String separator = ""]) {
    {
  if (this._length == 0) return "";
  StringBuffer buffer = StringBuffer();
  buffer.writeAll(this, separator);
  return buffer.toString();
}
  }
  
  int lastIndexOf(E element, [int? start = null]) {
    {
  int startIndex = (start) ?? ((this._length - 1));
  for (int i = startIndex; (i >= 0); i = (i - 1)) {
  {
  if (CppApi.cppGetPointerArrayItem(this._array, i) == element) return i;
}
}
  return -1;
}
  }
  
  int lastIndexWhere(bool Function(E) test, [int? start = null]) {
    {
  int startIndex = (start) ?? ((this._length - 1));
  for (int i = startIndex; (i >= 0); i = (i - 1)) {
  {
  if (test(CppApi.cppGetPointerArrayItem(this._array, i) as E)) return i;
}
}
  return -1;
}
  }
  
  E lastWhere(bool Function(E) test, {E Function()? orElse = null}) {
    {
  for (int i = (this._length - 1); (i >= 0); i = (i - 1)) {
  {
  if (test(CppApi.cppGetPointerArrayItem(this._array, i) as E)) {
  return CppApi.cppGetPointerArrayItem(this._array, i) as E;
}
}
}
  if (!(orElse == null)) return orElse();
  throw StateError("No element");
}
  }
  
  E reduce(E Function(E, E) combine) {
    {
  if (this._length == 0) throw StateError("No element");
  E value = CppApi.cppGetPointerArrayItem(this._array, 0) as E;
  for (int i = 1; (i < this._length); i = (i + 1)) {
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
  if (!(index == -1)) {
  this.removeAt(index);
  return true;
}
  return false;
}
  }
  
  E removeAt(int index) {
    {
  if ((index < 0) || (index >= this._length)) throw IndexError(index, this);
  Object? element = CppApi.cppGetPointerArrayItem(this._array, index);
  for (int i = index; (i < (this._length - 1)); i = (i + 1)) {
  {
  CppApi.cppSetPointerArrayItem(this._array, i, CppApi.cppGetPointerArrayItem(this._array, (i + 1)));
}
}
  this._length = (this._length - 1);
  return element as E;
}
  }
  
  E removeLast() {
    {
  if (this._length == 0) throw StateError("No element");
  return this.removeAt((this._length - 1));
}
  }
  
  void removeRange(int start, int end) {
    {
  if ((start < 0) || (start > this._length) || (end < start) || (end > this._length)) {
  throw RangeError.range(start, 0, this._length);
}
  int length = (end - start);
  for (int i = start; (i < (this._length - length)); i = (i + 1)) {
  {
  CppApi.cppSetPointerArrayItem(this._array, i, CppApi.cppGetPointerArrayItem(this._array, (i + length)));
}
}
  this._length = (this._length - length);
}
  }
  
  void removeWhere(bool Function(E) test) {
    {
  int writeIndex = 0;
  for (int readIndex = 0; (readIndex < this._length); readIndex = (readIndex + 1)) {
  {
  if (!(test(CppApi.cppGetPointerArrayItem(this._array, readIndex) as E))) {
  if (!(writeIndex == readIndex)) {
  CppApi.cppSetPointerArrayItem(this._array, writeIndex, CppApi.cppGetPointerArrayItem(this._array, readIndex));
}
  writeIndex = (writeIndex + 1);
}
}
}
  this._length = writeIndex;
}
  }
  
  void replaceRange(int start, int end, Iterable<E> replacements) {
    {
  if ((start < 0) || (start > this._length) || (end < start) || (end > this._length)) {
  throw RangeError.range(start, 0, this._length);
}
  List<E> replacementList = replacements.toList();
  int replacementLength = replacementList.length;
  int rangeLength = (end - start);
  if ((replacementLength > rangeLength)) {
  this.ensureCapacity(((this._length + replacementLength) - rangeLength));
}
  if (!(replacementLength == rangeLength)) {
  for (int i = (this._length - 1); (i >= end); i = (i - 1)) {
  {
  CppApi.cppSetPointerArrayItem(this._array, ((i + replacementLength) - rangeLength), CppApi.cppGetPointerArrayItem(this._array, i));
}
}
}
  for (int i = 0; (i < replacementLength); i = (i + 1)) {
  {
  CppApi.cppSetPointerArrayItem(this._array, (start + i), replacementList[i]);
}
}
  this._length = (this._length + (replacementLength - rangeLength));
}
  }
  
  void retainWhere(bool Function(E) test) {
    {
  int writeIndex = 0;
  for (int readIndex = 0; (readIndex < this._length); readIndex = (readIndex + 1)) {
  {
  if (test(CppApi.cppGetPointerArrayItem(this._array, readIndex) as E)) {
  if (!(writeIndex == readIndex)) {
  CppApi.cppSetPointerArrayItem(this._array, writeIndex, CppApi.cppGetPointerArrayItem(this._array, readIndex));
}
  writeIndex = (writeIndex + 1);
}
}
}
  this._length = writeIndex;
}
  }
  
  void setAll(int index, Iterable<E> iterable) {
    {
  if ((index < 0) || (index > this._length)) throw IndexError(index, this);
  int i = index;
  {
  Iterator<E> _sync_for_iterator = iterable.iterator;
  for (; _sync_for_iterator.moveNext();) {
  {
  E element = _sync_for_iterator.current;
  {
  if ((i >= this._length)) {
  this.add(element);
} else {
  CppApi.cppSetPointerArrayItem(this._array, i, element);
}
  i = (i + 1);
}
}
}
}
}
  }
  
  void setRange(int start, int end, Iterable<E> iterable, [int skipCount = 0]) {
    {
  if ((start < 0) || (start > this._length) || (end < start) || (end > this._length)) {
  throw RangeError.range(start, 0, this._length);
}
  Iterator<E> iterator = iterable.iterator;
  for (int i = 0; (i < skipCount); i = (i + 1)) {
  {
  if (!(iterator.moveNext())) return;
}
}
  label: for (int i = start; (i < end); i = (i + 1)) {
  {
  if (!(iterator.moveNext())) break;
  CppApi.cppSetPointerArrayItem(this._array, i, iterator.current);
}
}
}
  }
  
  void shuffle([Random? random = null]) {
    {
  random == null ? random = Random() : null;
  for (int i = (this._length - 1); (i > 0); i = (i - 1)) {
  {
  int j = random.nextInt((i + 1));
  Object? temp = CppApi.cppGetPointerArrayItem(this._array, i);
  CppApi.cppSetPointerArrayItem(this._array, i, CppApi.cppGetPointerArrayItem(this._array, j));
  CppApi.cppSetPointerArrayItem(this._array, j, temp);
}
}
}
  }
  
  void sort([int Function(E, E)? compare = null]) {
    {
  if ((this._length <= 1)) return;
  this._quickSort(0, (this._length - 1), compare);
}
  }
  
  void _quickSort(int low, int high, int Function(E, E)? compare) {
    {
  if ((low < high)) {
  int pi = this._partition(low, high, compare);
  this._quickSort(low, (pi - 1), compare);
  this._quickSort((pi + 1), high, compare);
}
}
  }
  
  int _partition(int low, int high, int Function(E, E)? compare) {
    {
  E pivot = CppApi.cppGetPointerArrayItem(this._array, high) as E;
  int i = (low - 1);
  for (int j = low; (j < high); j = (j + 1)) {
  {
  E current = CppApi.cppGetPointerArrayItem(this._array, j) as E;
  bool shouldSwap;
  if (!(compare == null)) {
  shouldSwap = (compare(current, pivot) <= 0);
} else {
  shouldSwap = ((current as Comparable<dynamic?>).compareTo(pivot) <= 0);
}
  if (shouldSwap) {
  i = (i + 1);
  this._swap(i, j);
}
}
}
  this._swap((i + 1), high);
  return (i + 1);
}
  }
  
  void _swap(int i, int j) {
    {
  E temp = CppApi.cppGetPointerArrayItem(this._array, i) as E;
  CppApi.cppSetPointerArrayItem(this._array, i, CppApi.cppGetPointerArrayItem(this._array, j));
  CppApi.cppSetPointerArrayItem(this._array, j, temp);
}
  }
  
  List<E> sublist(int start, [int? end = null]) {
    {
  int endIndex = (end) ?? (this._length);
  if ((start < 0) || (start > this._length) || (endIndex < start) || (endIndex > this._length)) {
  throw RangeError.range(start, 0, this._length);
}
  return CppList<E>.from(Iterable<dynamic?>.generate((endIndex - start), (int i) { return CppApi.cppGetPointerArrayItem(this._array, (start + i));}));
}
  }
  
  List<E> toList({bool growable = true}) {
    {
  return CppList<E>.from(this, growable: growable);
}
  }
  
  Set<E> toSet() {
    {
  return CppSet<E>.from(this);
}
  }
  
  E singleWhere(bool Function(E) test, {E Function()? orElse = null}) {
    {
  E? result;
  bool found = false;
  for (int i = 0; (i < this._length); i = (i + 1)) {
  {
  if (test(CppApi.cppGetPointerArrayItem(this._array, i) as E)) {
  if (found) throw StateError("Too many elements");
  result = CppApi.cppGetPointerArrayItem(this._array, i) as E;
  found = true;
}
}
}
  if (found) return result!;
  if (!(orElse == null)) return orElse();
  throw StateError("No element");
}
  }
  
  String toString() {
    {
  if (this._length == 0) return "[]";
  StringBuffer buffer = StringBuffer("[");
  buffer.write(CppApi.cppGetPointerArrayItem(this._array, 0));
  for (int i = 1; (i < this._length); i = (i + 1)) {
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
  return (newLen > 256) ? newLen : pow(2, (log(newLen) / log(2)).ceil()).toInt();
}
  }
  
  static List<R> castFrom<S, R>(List<S> source) {
    {
  CppList<R> result = CppList<R>(0, 4);
  {
  Iterator<S> _sync_for_iterator = source.iterator;
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
  
  static List<R> castFromWithFactory<S, R>(List<S> source, List<R> Function() newList) {
    {
  List<R> result = newList();
  {
  Iterator<S> _sync_for_iterator = source.iterator;
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
    CppApi.cppSetPointerArrayItem(this._array, index, value);
  }
  
  List<E> operator +(List<E> other) {
    {
  CppList<E> result = CppList<E>(0, (this._length + other.length));
  for (int i = 0; (i < this._length); i = (i + 1)) {
  {
  result.add(CppApi.cppGetPointerArrayItem(this._array, i) as E);
}
}
  {
  Iterator<E> _sync_for_iterator = other.iterator;
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
  int _index = -1;
  late CppList<E> _list;
_CppListIterator(CppList<E> _list) : _list = _list, super()   {
    ;
  }
  
  E get current {
    return this._list[this._index];
  }
  
  bool moveNext() {
    {
  this._index = (this._index + 1);
  return (this._index < this._list.length);
}
  }
  
}

/// 转换后的类: CppSet
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/collection.dart

class CppSet<E> extends CppIterable<E> implements Set<E> {
  late CppList<E> _list;
CppSet.fromCppArray(CppUserData array) : _list = CppList<E>.fromCppArray(array), super()   {
    ;
  }
  
CppSet([int capacity = 4]) : _list = CppList<E>(0, capacity), super()   {
    ;
  }
  
  factory CppSet.identity() {
    return CppSet<E>(4);
  }
  
  factory CppSet.from(Iterable<dynamic?> elements) {
    {
  CppSet<E> set = CppSet<E>();
  {
  Iterator<dynamic?> _sync_for_iterator = elements.iterator;
  for (; _sync_for_iterator.moveNext();) {
  {
  dynamic? element = _sync_for_iterator.current;
  {
  set.add(element as E);
}
}
}
}
  return set;
}
  }
  
  factory CppSet.of(Iterable<E> elements) {
    return CppSet<E>.from(elements);
  }
  
  factory CppSet.unmodifiable(Iterable<E> elements) {
    {
  CppSet<E> set = CppSet<E>();
  {
  Iterator<E> _sync_for_iterator = elements.iterator;
  for (; _sync_for_iterator.moveNext();) {
  {
  E element = _sync_for_iterator.current;
  {
  set.add(element);
}
}
}
}
  return set;
}
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
  Iterator<E> _sync_for_iterator = elements.iterator;
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
  return CppSet.castFrom<E, R>(this);
}
  }
  
  void clear() {
    {
  this._list.clear();
}
  }
  
  bool contains(Object? element) {
    {
  for (int i = 0; (i < this._list.length); i = (i + 1)) {
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
  Iterator<Object?> _sync_for_iterator = other.iterator;
  for (; _sync_for_iterator.moveNext();) {
  {
  Object? element = _sync_for_iterator.current;
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
  CppSet<E> result = CppSet<E>();
  {
  Iterator<E> _sync_for_iterator = this._list.iterator;
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
  CppSet<E> result = CppSet<E>();
  {
  Iterator<E> _sync_for_iterator = this._list.iterator;
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
  if (this._list.isEmpty) throw StateError("No element");
  return this._list.first;
}
  }
  
  E get last {
    {
  if (this._list.isEmpty) throw StateError("No element");
  return this._list.last;
}
  }
  
  E get single {
    {
  if (this._list.isEmpty) throw StateError("No element");
  if ((this._list.length > 1)) throw StateError("Too many elements");
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
  for (int i = 0; (i < this._list.length); i = (i + 1)) {
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
  Iterator<Object?> _sync_for_iterator = elementsToRemove.iterator;
  for (; _sync_for_iterator.moveNext();) {
  {
  Object? element = _sync_for_iterator.current;
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
  CppSet<dynamic?> retainSet = CppSet<dynamic?>.from(elementsToRetain);
  this.removeWhere((E element) { return !(retainSet.contains(element));});
}
  }
  
  void retainWhere(bool Function(E) test) {
    {
  this._list.retainWhere(test);
}
  }
  
  Set<E> union(Set<E> other) {
    {
  CppSet<E> result = CppSet<E>();
  result.addAll(this);
  result.addAll(other);
  return result;
}
  }
  
  String toString() {
    {
  if (this._list.isEmpty) return "{}";
  StringBuffer buffer = StringBuffer("{");
  Iterator<E> iterator = this._list.iterator;
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
  
  static Set<R> castFrom<S, R>(Set<S> source) {
    {
  CppSet<R> result = CppSet<R>();
  {
  Iterator<S> _sync_for_iterator = source.iterator;
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
  
  static Set<R> castFromWithFactory<S, R>(Set<S> source, Set<R> Function() newSet) {
    {
  Set<R> result = newSet();
  {
  Iterator<S> _sync_for_iterator = source.iterator;
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

/// 转换后的类: CppMapEntry
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/collection.dart

class CppMapEntry<K, V> {
  late K key;
  late V value;
CppMapEntry(K key, V value) : key = key, value = value, super()   {
    ;
  }
  
}

/// 转换后的类: CppMap
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/collection.dart

class CppMap<K, V> implements Map<K, V> {
  late CppList<MapEntry<K, V>> _list;
CppMap.fromCppArray(CppUserData array) : _list = CppList<MapEntry<K, V>>.fromCppArray(array), super()   {
    ;
  }
  
CppMap([int capacity = 4]) : _list = CppList<MapEntry<K, V>>(0, capacity), super()   {
    ;
  }
  
  factory CppMap.identity() {
    return CppMap<K, V>();
  }
  
  factory CppMap.from(Map<dynamic?, dynamic?> other) {
    return CppMap<K, V>.unmodifiable(other);
  }
  
  factory CppMap.of(Map<K, V> other) {
    return CppMap<K, V>.fromEntries(other.entries);
  }
  
  factory CppMap.unmodifiable(Map<dynamic?, dynamic?> other) {
    {
  CppMap<K, V> map = CppMap<K, V>();
  other.forEach((dynamic? key, dynamic? value) { {
  map[key as K] = value as V;
}});
  return map;
}
  }
  
  factory CppMap.fromIterable(Iterable<dynamic?> iterable, {K Function(dynamic?)? key = null, V Function(dynamic?)? value = null}) {
    {
  CppMap<K, V> map = CppMap<K, V>();
  {
  Iterator<dynamic?> _sync_for_iterator = iterable.iterator;
  for (; _sync_for_iterator.moveNext();) {
  {
  dynamic? element = _sync_for_iterator.current;
  {
  dynamic? k = ((() { final K Function(dynamic?)? temp_22638_5693 = key; return temp_22638_5693 == null ? null : temp_22638_5693(element); })()) ?? (element);
  dynamic? v = ((() { final V Function(dynamic?)? temp_22683_5703 = value; return temp_22683_5703 == null ? null : temp_22683_5703(element); })()) ?? (element);
  map[k as K] = v as V;
}
}
}
}
  return map;
}
  }
  
  factory CppMap.fromIterables(Iterable<K> keys, Iterable<V> values) {
    {
  CppMap<K, V> map = CppMap<K, V>();
  Iterator<K> keyIter = keys.iterator;
  Iterator<V> valueIter = values.iterator;
  while (keyIter.moveNext() && valueIter.moveNext()) {
  map[keyIter.current] = valueIter.current;
}
  return map;
}
  }
  
  factory CppMap.fromEntries(Iterable<MapEntry<K, V>> entries) {
    {
  CppMap<K, V> map = CppMap<K, V>();
  {
  Iterator<MapEntry<K, V>> _sync_for_iterator = entries.iterator;
  for (; _sync_for_iterator.moveNext();) {
  {
  MapEntry<K, V> entry = _sync_for_iterator.current;
  {
  map[entry.key] = entry.value;
}
}
}
}
  return map;
}
  }
  
  void addAll(Map<K, V> other) {
    {
  other.forEach((K k, V v) { return (() { final K temp_23755_5918 = k; return (() { final V temp_23761_5920 = v; return (() { this[temp_23755_5918] = temp_23761_5920; temp_23761_5920; })(); })(); })();});
}
  }
  
  void addEntries(Iterable<MapEntry<K, V>> entries) {
    {
  {
  Iterator<MapEntry<K, V>> _sync_for_iterator = entries.iterator;
  for (; _sync_for_iterator.moveNext();) {
  {
  MapEntry<K, V> entry = _sync_for_iterator.current;
  {
  this[entry.key] = entry.value;
}
}
}
}
}
  }
  
  Map<RK, RV> cast<RK, RV>() {
    return CppMap.castFrom<K, V, RK, RV>(this);
  }
  
  void clear() {
    {
  this._list.clear();
}
  }
  
  bool containsKey(Object? key) {
    {
  {
  Iterator<MapEntry<K, V>> _sync_for_iterator = this._list.iterator;
  for (; _sync_for_iterator.moveNext();) {
  {
  MapEntry<K, V> entry = _sync_for_iterator.current;
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
  Iterator<MapEntry<K, V>> _sync_for_iterator = this._list.iterator;
  for (; _sync_for_iterator.moveNext();) {
  {
  MapEntry<K, V> entry = _sync_for_iterator.current;
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
  Iterator<MapEntry<K, V>> _sync_for_iterator = this._list.iterator;
  for (; _sync_for_iterator.moveNext();) {
  {
  MapEntry<K, V> entry = _sync_for_iterator.current;
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
    return this._list.map((MapEntry<K, V> e) { return e.key;});
  }
  
  int get length {
    return this._list.length;
  }
  
  V putIfAbsent(K key, V Function() ifAbsent) {
    {
  {
  Iterator<MapEntry<K, V>> _sync_for_iterator = this._list.iterator;
  for (; _sync_for_iterator.moveNext();) {
  {
  MapEntry<K, V> entry = _sync_for_iterator.current;
  {
  if (entry.key == key) return entry.value;
}
}
}
}
  V v = ifAbsent();
  this._list.add(MapEntry<K, V>(key, v));
  return v;
}
  }
  
  V? remove(Object? key) {
    {
  for (int i = 0; (i < this._list.length); i = (i + 1)) {
  {
  if (this._list[i].key == key) {
  V v = this._list[i].value;
  for (int j = i; (j < (this._list.length - 1)); j = (j + 1)) {
  {
  this._list[j] = this._list[(j + 1)];
}
}
  this._list.length = (this._list.length - 1);
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
  while ((i < this._list.length)) {
  MapEntry<K, V> entry = this._list[i];
  if (test(entry.key, entry.value)) {
  this.remove(entry.key);
} else {
  i = (i + 1);
}
}
}
  }
  
  V update(K key, V Function(V) update, {V Function()? ifAbsent = null}) {
    {
  for (int i = 0; (i < this._list.length); i = (i + 1)) {
  {
  if (this._list[i].key == key) {
  V newValue = update(this._list[i].value);
  this._list[i] = MapEntry<K, V>(key, newValue);
  return newValue;
}
}
}
  if (!(ifAbsent == null)) {
  V v = ifAbsent();
  this._list.add(MapEntry<K, V>(key, v));
  return v;
}
  throw ArgumentError("Key not found");
}
  }
  
  void updateAll(V Function(K, V) update) {
    {
  for (int i = 0; (i < this._list.length); i = (i + 1)) {
  {
  MapEntry<K, V> entry = this._list[i];
  this._list[i] = MapEntry<K, V>(entry.key, update(entry.key, entry.value));
}
}
}
  }
  
  Iterable<V> get values {
    return this._list.map((MapEntry<K, V> e) { return e.value;});
  }
  
  Map<K2, V2> map<K2, V2>(MapEntry<K2, V2> Function(K, V) transform) {
    {
  CppMap<K2, V2> result = CppMap<K2, V2>();
  {
  Iterator<MapEntry<K, V>> _sync_for_iterator = this._list.iterator;
  for (; _sync_for_iterator.moveNext();) {
  {
  MapEntry<K, V> entry = _sync_for_iterator.current;
  {
  MapEntry<K2, V2> newEntry = transform(entry.key, entry.value);
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
  StringBuffer buffer = StringBuffer("{");
  Iterator<MapEntry<K, V>> iterator = this._list.iterator;
  if (iterator.moveNext()) {
  buffer.write((iterator.current.key).toString() + ": " + (iterator.current.value).toString());
  while (iterator.moveNext()) {
  buffer.write(", " + (iterator.current.key).toString() + ": " + (iterator.current.value).toString());
}
}
  buffer.write("}");
  return buffer.toString();
}
  }
  
  static Map<RK, RV> castFrom<K, V, RK, RV>(Map<K, V> source) {
    {
  CppMap<RK, RV> result = CppMap<RK, RV>();
  source.forEach((K key, V value) { {
  result[key as RK] = value as RV;
}});
  return result;
}
  }
  
  static Map<RK, RV> castFromWithFactory<K, V, RK, RV>(Map<K, V> source, Map<RK, RV> Function() newMap) {
    {
  Map<RK, RV> result = newMap();
  source.forEach((K key, V value) { {
  result[key as RK] = value as RV;
}});
  return result;
}
  }
  
  V? operator [](Object? key) {
    {
  {
  Iterator<MapEntry<K, V>> _sync_for_iterator = this._list.iterator;
  for (; _sync_for_iterator.moveNext();) {
  {
  MapEntry<K, V> entry = _sync_for_iterator.current;
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
  for (int i = 0; (i < this._list.length); i = (i + 1)) {
  {
  if (this._list[i].key == key) {
  this._list[i] = MapEntry<K, V>(key, value);
  return;
}
}
}
  this._list.add(MapEntry<K, V>(key, value));
}
  }
  
}

/// 转换后的类: CppError
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/error.dart

class CppError implements Error {
CppError() : super()   {
    ;
  }
  
  StackTrace? get stackTrace {
    return CppStackTrace.current;
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
  static CppStackTrace _current = CppStackTrace();
CppStackTrace() : super()   {
    ;
  }
  
  static CppStackTrace get current {
    return CppStackTrace._current;
  }
  
  String toString() {
    return CppApi.getCurrentStackTrace();
  }
  
}

/// 转换后的类: CppStringPool
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/string.dart

class CppStringPool {
  static final CppStringPool _instance = CppStringPool._internal();
  late List<CppUserData> _pool = _GrowableList._literal1<CppUserData>(cppUserDataEmpty);
CppStringPool._internal() : super()   {
    ;
  }
  
  static CppStringPool get instance {
    return CppStringPool._instance;
  }
  
  CppUserData getOrCreateFromCodeUnits(List<int> codeUnits) {
    {
  {
  Iterator<CppUserData> _sync_for_iterator = this._pool.iterator;
  for (; _sync_for_iterator.moveNext();) {
  {
  CppUserData existing = _sync_for_iterator.current;
  {
  if (this._compareUserData(existing, codeUnits)) {
  return existing;
}
}
}
}
}
  CppUserData userData = CppApi.cppCreateByteArray(codeUnits.length);
  for (int i = 0; (i < codeUnits.length); i = (i + 1)) {
  {
  CppApi.cppSetByteArrayItem(userData, i, codeUnits[i]);
}
}
  this._pool.add(userData);
  return userData;
}
  }
  
  CppUserData getOrCreateFromUserData(CppUserData userData) {
    {
  if (this._pool.contains(userData)) {
  return userData;
}
  this._pool.add(userData);
  return userData;
}
  }
  
  bool _compareUserData(CppUserData userData, List<int> codeUnits) {
    {
  int length = CppApi.cppGetByteArrayLength(userData);
  if (!(length == codeUnits.length)) return false;
  for (int i = 0; (i < length); i = (i + 1)) {
  {
  if (!(CppApi.cppGetByteArrayItem(userData, i) == codeUnits[i])) {
  return false;
}
}
}
  return true;
}
  }
  
  void clear() {
    {
  this._pool.clear();
}
  }
  
  CppStringPoolStats getStats() {
    {
  int totalMemory = 0;
  {
  Iterator<CppUserData> _sync_for_iterator = this._pool.iterator;
  for (; _sync_for_iterator.moveNext();) {
  {
  CppUserData userData = _sync_for_iterator.current;
  {
  totalMemory = (totalMemory + CppApi.cppGetByteArrayLength(userData));
}
}
}
}
  return CppStringPoolStats(totalStrings: this._pool.length, totalMemory: totalMemory);
}
  }
  
}

/// 转换后的类: CppStringPoolStats
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/string.dart

class CppStringPoolStats {
  late int totalStrings;
  late int totalMemory;
CppStringPoolStats({int totalStrings, int totalMemory}) : totalStrings = totalStrings, totalMemory = totalMemory, super()   {
    ;
  }
  
  String toString() {
    {
  return "CppStringPoolStats{\n" + "  不同字符串数: " + (this.totalStrings).toString() + "\n" + "  总内存使用: " + (this.totalMemory).toString() + " 字符\n" + "}";
}
  }
  
}

/// 转换后的类: CppStringBuffer
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/string.dart

class CppStringBuffer {
  late List<CppUserData> _parts;
CppStringBuffer([Object content = ""]) : _parts = _GrowableList._literal1<CppUserData>(CppStringBuffer._convertStringToUserData(content)), super()   {
    ;
  }
  
  void write(Object? obj) {
    {
  if (obj == null) return;
  this._parts.add(CppStringBuffer._convertStringToUserData(obj));
}
  }
  
  void writeAll(Iterable<dynamic?> objects, [CppString? separator = null]) {
    {
  Iterator<dynamic?> iterator = objects.iterator;
  if (iterator.moveNext()) {
  this._parts.add(CppStringBuffer._convertStringToUserData((() { final dynamic? temp_1800 = iterator.current; return temp_1800 == null ? temp_1800 as Object : temp_1800; })()));
  while (iterator.moveNext()) {
  if (!(separator == null) && separator.isNotEmpty) {
  this._parts.add(separator._codeUnits);
}
  this._parts.add(CppStringBuffer._convertStringToUserData((() { final dynamic? temp_1808 = iterator.current; return temp_1808 == null ? temp_1808 as Object : temp_1808; })()));
}
}
}
  }
  
  void writeCharCode(int charCode) {
    {
  this._parts.add(CppStringBuffer._convertStringToUserData(CppString.fromCharCode(charCode)));
}
  }
  
  void writeln([Object? obj = ""]) {
    {
  if (!(obj == null)) {
  this._parts.add(CppStringBuffer._convertStringToUserData(obj));
}
  this._parts.add(CppStringBuffer._convertStringToUserData(CppString.fromCharCode(10)));
}
  }
  
  void clear() {
    {
  this._parts.clear();
}
  }
  
  CppString toCppString() {
    {
  List<int> codeUnits = _GrowableList.<int>(0);
  {
  Iterator<CppUserData> _sync_for_iterator = this._parts.iterator;
  for (; _sync_for_iterator.moveNext();) {
  {
  CppUserData part = _sync_for_iterator.current;
  {
  int length = CppApi.cppGetByteArrayLength(part);
  for (int i = 0; (i < length); i = (i + 1)) {
  {
  codeUnits.add(CppApi.cppGetByteArrayItem(part, i));
}
}
}
}
}
}
  return CppString.fromCodeUnits(codeUnits);
}
  }
  
  int get length {
    {
  int totalLength = 0;
  {
  Iterator<CppUserData> _sync_for_iterator = this._parts.iterator;
  for (; _sync_for_iterator.moveNext();) {
  {
  CppUserData part = _sync_for_iterator.current;
  {
  totalLength = (totalLength + CppApi.cppGetByteArrayLength(part));
}
}
}
}
  return totalLength;
}
  }
  
  bool get isEmpty {
    return this._parts.isEmpty;
  }
  
  bool get isNotEmpty {
    return this._parts.isNotEmpty;
  }
  
  static CppUserData _convertStringToUserData(Object obj) {
    {
  if (obj is CppString) {
  return obj._codeUnits;
}
  return CppStringPool.instance.getOrCreateFromCodeUnits(CppStringBuffer._convertStringToCodeUnits(obj.toString()));
}
  }
  
  static List<int> _convertStringToCodeUnits(String str) {
    {
  List<int> codeUnits = _GrowableList.<int>(0);
  for (int i = 0; (i < str.length); i = (i + 1)) {
  {
  codeUnits.add(str.codeUnitAt(i));
}
}
  return codeUnits;
}
  }
  
}

/// 转换后的类: CppString
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/string.dart

class CppString implements Comparable<CppString> {
  static CppString Empty = CppString.fromCppUserData(cppUserDataEmpty);
  late CppUserData _codeUnits;
CppString.fromCppUserData(CppUserData userData) : _codeUnits = CppStringPool.instance.getOrCreateFromUserData(userData), super()   {
    ;
  }
  
CppString.fromCodeUnits(List<int> codeUnits) : _codeUnits = CppStringPool.instance.getOrCreateFromCodeUnits(codeUnits), super()   {
    ;
  }
  
CppString.fromCharCode(int charCode) : _codeUnits = CppStringPool.instance.getOrCreateFromCodeUnits(_GrowableList._literal1<int>(charCode)), super()   {
    ;
  }
  
CppString.fromCharCodes(Iterable<int> charCodes, [int start = 0, int? end = null]) : _codeUnits = CppStringPool.instance.getOrCreateFromCodeUnits(charCodes.skip(start).take(((end) ?? (charCodes.length) - start)).toList()), super()   {
    ;
  }
  
  String _toExternalString() {
    {
  List<int> codeUnits = _GrowableList.<int>(0);
  for (int i = 0; (i < this.length); i = (i + 1)) {
  {
  codeUnits.add(CppApi.cppGetByteArrayItem(this._codeUnits, i));
}
}
  return String.fromCharCodes(codeUnits);
}
  }
  
  bool _equalCodeUnits(CppString other) {
    {
  int thisLength = this.length;
  int otherLength = other.length;
  if (!(thisLength == otherLength)) return false;
  for (int i = 0; (i < thisLength); i = (i + 1)) {
  {
  if (!(CppApi.cppGetByteArrayItem(this._codeUnits, i) == CppApi.cppGetByteArrayItem(other._codeUnits, i))) {
  return false;
}
}
}
  return true;
}
  }
  
  int get length {
    return CppApi.cppGetByteArrayLength(this._codeUnits);
  }
  
  bool get isEmpty {
    return this.length == 0;
  }
  
  bool get isNotEmpty {
    return (this.length > 0);
  }
  
  int get hashCode {
    {
  int hash = 0;
  for (int i = 0; (i < this.length); i = (i + 1)) {
  {
  hash = (((hash * 31) + CppApi.cppGetByteArrayItem(this._codeUnits, i)) & 2147483647);
}
}
  return hash;
}
  }
  
  int codeUnitAt(int index) {
    {
  if ((index < 0) || (index >= this.length)) {
  throw IndexError(index, this, "index");
}
  return CppApi.cppGetByteArrayItem(this._codeUnits, index);
}
  }
  
  List<int> get codeUnits {
    {
  int thisLength = this.length;
  List<int> units = _GrowableList.<int>(0);
  for (int i = 0; (i < thisLength); i = (i + 1)) {
  {
  units.add(CppApi.cppGetByteArrayItem(this._codeUnits, i));
}
}
  return units;
}
  }
  
  Runes get runes {
    return this._toExternalString().runes;
  }
  
  int compareTo(CppString other) {
    {
  int thisLength = this.length;
  int otherLength = other.length;
  int minLength = (thisLength < otherLength) ? thisLength : otherLength;
  for (int i = 0; (i < minLength); i = (i + 1)) {
  {
  int thisCodeUnit = CppApi.cppGetByteArrayItem(this._codeUnits, i);
  int otherCodeUnit = CppApi.cppGetByteArrayItem(other._codeUnits, i);
  if (!(thisCodeUnit == otherCodeUnit)) {
  return (thisCodeUnit - otherCodeUnit);
}
}
}
  return (thisLength - otherLength);
}
  }
  
  bool startsWith(CppString pattern, [int index = 0]) {
    {
  if ((index < 0) || (index >= this.length)) return false;
  if (((index + pattern.length) > this.length)) return false;
  for (int i = 0; (i < pattern.length); i = (i + 1)) {
  {
  if (!(CppApi.cppGetByteArrayItem(this._codeUnits, (index + i)) == CppApi.cppGetByteArrayItem(pattern._codeUnits, i))) {
  return false;
}
}
}
  return true;
}
  }
  
  bool endsWith(CppString other) {
    {
  if ((other.length > this.length)) return false;
  int startIndex = (this.length - other.length);
  for (int i = 0; (i < other.length); i = (i + 1)) {
  {
  if (!(CppApi.cppGetByteArrayItem(this._codeUnits, (startIndex + i)) == CppApi.cppGetByteArrayItem(other._codeUnits, i))) {
  return false;
}
}
}
  return true;
}
  }
  
  int indexOf(CppString pattern, [int start = 0]) {
    {
  if ((start < 0)) start = 0;
  if (pattern.isEmpty) return start;
  if (((start + pattern.length) > this.length)) return -1;
  for (int i = start; (i <= (this.length - pattern.length)); i = (i + 1)) {
  {
  bool match = true;
  label: for (int j = 0; (j < pattern.length); j = (j + 1)) {
  {
  if (!(CppApi.cppGetByteArrayItem(this._codeUnits, (i + j)) == CppApi.cppGetByteArrayItem(pattern._codeUnits, j))) {
  match = false;
  break;
}
}
}
  if (match) return i;
}
}
  return -1;
}
  }
  
  int lastIndexOf(CppString pattern, [int? start = null]) {
    {
  if (pattern.isEmpty) return (start) ?? (this.length);
  start == null ? start = this.length : null;
  if ((start < 0)) return -1;
  if (((start + pattern.length) > this.length)) start = (this.length - pattern.length);
  for (int i = start; (i >= 0); i = (i - 1)) {
  {
  bool match = true;
  label: for (int j = 0; (j < pattern.length); j = (j + 1)) {
  {
  if (!(CppApi.cppGetByteArrayItem(this._codeUnits, (i + j)) == CppApi.cppGetByteArrayItem(pattern._codeUnits, j))) {
  match = false;
  break;
}
}
}
  if (match) return i;
}
}
  return -1;
}
  }
  
  bool contains(CppString other, [int startIndex = 0]) {
    {
  return !(this.indexOf(other, startIndex) == -1);
}
  }
  
  CppString substring(int start, [int? end = null]) {
    {
  end == null ? end = this.length : null;
  if ((start < 0)) start = 0;
  if ((end > this.length)) end = this.length;
  if ((start >= end)) return CppString.Empty;
  int newLength = (end - start);
  List<int> newCodeUnits = _GrowableList.<int>(0);
  for (int i = 0; (i < newLength); i = (i + 1)) {
  {
  int codeUnit = CppApi.cppGetByteArrayItem(this._codeUnits, (start + i));
  newCodeUnits.add(codeUnit);
}
}
  return CppString.fromCodeUnits(newCodeUnits);
}
  }
  
  CppString trim() {
    {
  int start = 0;
  int end = this.length;
  while ((start < end) && this._isWhitespace(CppApi.cppGetByteArrayItem(this._codeUnits, start))) {
  start = (start + 1);
}
  while ((end > start) && this._isWhitespace(CppApi.cppGetByteArrayItem(this._codeUnits, (end - 1)))) {
  end = (end - 1);
}
  return this.substring(start, end);
}
  }
  
  CppString trimLeft() {
    {
  int start = 0;
  while ((start < this.length) && this._isWhitespace(CppApi.cppGetByteArrayItem(this._codeUnits, start))) {
  start = (start + 1);
}
  return this.substring(start);
}
  }
  
  CppString trimRight() {
    {
  int end = this.length;
  while ((end > 0) && this._isWhitespace(CppApi.cppGetByteArrayItem(this._codeUnits, (end - 1)))) {
  end = (end - 1);
}
  return this.substring(0, end);
}
  }
  
  bool _isWhitespace(int codeUnit) {
    {
  return codeUnit == 9 || codeUnit == 10 || codeUnit == 11 || codeUnit == 12 || codeUnit == 13 || codeUnit == 32 || codeUnit == 160;
}
  }
  
  CppString padLeft(int width, [CppString? padding = null]) {
    {
  if ((width <= this.length)) return this;
  padding == null ? padding = CppString.fromCharCode(32) : null;
  int padLength = (width - this.length);
  int padCount = (padLength / padding.length).ceil();
  CppString padString = (padding * padCount);
  CppString actualPad = padString.substring(0, padLength);
  return (actualPad + this);
}
  }
  
  CppString padRight(int width, [CppString? padding = null]) {
    {
  if ((width <= this.length)) return this;
  padding == null ? padding = CppString.fromCharCode(32) : null;
  int padLength = (width - this.length);
  int padCount = (padLength / padding.length).ceil();
  CppString padString = (padding * padCount);
  CppString actualPad = padString.substring(0, padLength);
  return (this + actualPad);
}
  }
  
  CppString replaceFirst(CppString from, CppString to, [int startIndex = 0]) {
    {
  int index = this.indexOf(from, startIndex);
  if (index == -1) return this;
  CppString beforePart = this.substring(0, index);
  CppString afterPart = this.substring((index + from.length));
  return ((beforePart + to) + afterPart);
}
  }
  
  CppString replaceAll(CppString from, CppString replace) {
    {
  if (from.isEmpty) return this;
  List<CppString> parts = this.split(from);
  if (parts.length == 1) return this;
  List<CppString> result = _GrowableList.<CppString>(0);
  for (int i = 0; (i < parts.length); i = (i + 1)) {
  {
  result.add(parts[i]);
  if ((i < (parts.length - 1))) {
  result.add(replace);
}
}
}
  return CppString.join(result);
}
  }
  
  CppString replaceRange(int start, int? end, CppString replacement) {
    {
  end == null ? end = this.length : null;
  if ((start < 0)) start = 0;
  if ((end > this.length)) end = this.length;
  if ((start >= end)) return (this + replacement);
  CppString beforePart = this.substring(0, start);
  CppString afterPart = this.substring(end);
  return ((beforePart + replacement) + afterPart);
}
  }
  
  List<CppString> split(CppString separator) {
    {
  if (separator.isEmpty) {
  List<CppString> result = _GrowableList.<CppString>(0);
  for (int i = 0; (i < this.length); i = (i + 1)) {
  {
  result.add(this.substring(i, (i + 1)));
}
}
  return result;
}
  List<CppString> result = _GrowableList.<CppString>(0);
  int start = 0;
  int index = this.indexOf(separator, start);
  while (!(index == -1)) {
  result.add(this.substring(start, index));
  start = (index + separator.length);
  index = this.indexOf(separator, start);
}
  result.add(this.substring(start));
  return result;
}
  }
  
  CppString toLowerCase() {
    {
  List<int> resultCodeUnits = _GrowableList.<int>(0);
  for (int i = 0; (i < this.length); i = (i + 1)) {
  {
  int codeUnit = CppApi.cppGetByteArrayItem(this._codeUnits, i);
  if ((codeUnit >= 65) && (codeUnit <= 90)) {
  codeUnit = (codeUnit + 32);
}
  resultCodeUnits.add(codeUnit);
}
}
  return CppString.fromCodeUnits(resultCodeUnits);
}
  }
  
  CppString toUpperCase() {
    {
  List<int> resultCodeUnits = _GrowableList.<int>(0);
  for (int i = 0; (i < this.length); i = (i + 1)) {
  {
  int codeUnit = CppApi.cppGetByteArrayItem(this._codeUnits, i);
  if ((codeUnit >= 97) && (codeUnit <= 122)) {
  codeUnit = (codeUnit - 32);
}
  resultCodeUnits.add(codeUnit);
}
}
  return CppString.fromCodeUnits(resultCodeUnits);
}
  }
  
  Iterable<CppStringMatch> allMatches(CppString string, [int start = 0]) {
    {
  if ((start < 0) || (start > string.length)) {
  throw RangeError.range(start, 0, string.length, "start");
}
  return _CppStringAllMatchesIterable(string, this, start);
}
  }
  
  CppStringMatch? matchAsPrefix(CppString string, [int start = 0]) {
    {
  if ((start < 0) || (start > string.length)) {
  throw RangeError.range(start, 0, string.length);
}
  if (((start + this.length) > string.length)) return null;
  for (int i = 0; (i < this.length); i = (i + 1)) {
  {
  if (!(CppApi.cppGetByteArrayItem(string._codeUnits, (start + i)) == CppApi.cppGetByteArrayItem(this._codeUnits, i))) {
  return null;
}
}
}
  return CppStringMatch(start, string, this);
}
  }
  
  CppString toCppString() {
    {
  return this;
}
  }
  
  String toStandardString() {
    {
  return this._toExternalString();
}
  }
  
  void dispose() {
    {
  
}
  }
  
  bool sharesDataWith(CppString other) {
    {
  return identical(this._codeUnits, other._codeUnits);
}
  }
  
  int get dataHashCode {
    return this._codeUnits.hashCode;
  }
  
  static CppString fromString(String source) {
    {
  List<int> codeUnits = _GrowableList.<int>(0);
  for (int i = 0; (i < source.length); i = (i + 1)) {
  {
  codeUnits.add(source.codeUnitAt(i));
}
}
  return CppString.fromCodeUnits(codeUnits);
}
  }
  
  static CppString join(Iterable<CppString> strings, [CppString? separator = null]) {
    {
  separator == null ? separator = CppString.Empty : null;
  List<CppString> stringList = strings.toList();
  if (stringList.isEmpty) return CppString.Empty;
  if (stringList.length == 1) return stringList[0];
  List<int> newCodeUnits = _GrowableList.<int>(0);
  for (int i = 0; (i < stringList.length); i = (i + 1)) {
  {
  CppString str = stringList[i];
  for (int j = 0; (j < str.length); j = (j + 1)) {
  {
  newCodeUnits.add(CppApi.cppGetByteArrayItem(str._codeUnits, j));
}
}
  if ((i < (stringList.length - 1))) {
  for (int j = 0; (j < separator.length); j = (j + 1)) {
  {
  newCodeUnits.add(CppApi.cppGetByteArrayItem(separator._codeUnits, j));
}
}
}
}
}
  return CppString.fromCodeUnits(newCodeUnits);
}
  }
  
  CppString operator [](int index) {
    {
  int thisLength = this.length;
  if ((index < 0) || (index >= thisLength)) {
  throw IndexError(index, this, "index");
}
  int codeUnit = CppApi.cppGetByteArrayItem(this._codeUnits, index);
  return CppString.fromCharCode(codeUnit);
}
  }
  
  bool operator ==(Object other) {
    {
  if (identical(this, other)) return true;
  if (other is CppString) {
  return this._equalCodeUnits(other);
}
  return false;
}
  }
  
  CppString operator +(CppString other) {
    {
  int thisLength = this.length;
  int otherLength = other.length;
  List<int> newCodeUnits = _GrowableList.<int>(0);
  for (int i = 0; (i < thisLength); i = (i + 1)) {
  {
  newCodeUnits.add(CppApi.cppGetByteArrayItem(this._codeUnits, i));
}
}
  for (int i = 0; (i < otherLength); i = (i + 1)) {
  {
  newCodeUnits.add(CppApi.cppGetByteArrayItem(other._codeUnits, i));
}
}
  return CppString.fromCodeUnits(newCodeUnits);
}
  }
  
  CppString operator *(int times) {
    {
  if ((times <= 0)) return CppString.Empty;
  if (times == 1) return this;
  int thisLength = this.length;
  List<int> newCodeUnits = _GrowableList.<int>(0);
  for (int repeat = 0; (repeat < times); repeat = (repeat + 1)) {
  {
  for (int i = 0; (i < thisLength); i = (i + 1)) {
  {
  newCodeUnits.add(CppApi.cppGetByteArrayItem(this._codeUnits, i));
}
}
}
}
  return CppString.fromCodeUnits(newCodeUnits);
}
  }
  
}

/// 转换后的类: CppStringMatch
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/string.dart

class CppStringMatch {
  late int start;
  late CppString input;
  late CppString pattern;
CppStringMatch(int start, CppString input, CppString pattern) : start = start, input = input, pattern = pattern, super()   {
    ;
  }
  
  int get end {
    return (this.start + this.pattern.length);
  }
  
  CppString group(int group) {
    {
  if (!(group == 0)) {
  throw RangeError.value(group);
}
  return this.pattern;
}
  }
  
  int get groupCount {
    return 0;
  }
  
  CppString operator [](int group) {
    return group == 0 ? this.pattern : throw RangeError.value(group);
  }
  
}

/// 转换后的类: _CppStringAllMatchesIterable
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/string.dart

class _CppStringAllMatchesIterable extends Iterable<CppStringMatch> {
  late CppString _input;
  late CppString _pattern;
  late int _index;
_CppStringAllMatchesIterable(CppString _input, CppString _pattern, int _index) : _input = _input, _pattern = _pattern, _index = _index, super()   {
    ;
  }
  
  Iterator<CppStringMatch> get iterator {
    return _CppStringAllMatchesIterator(this._input, this._pattern, this._index);
  }
  
  CppStringMatch get first {
    {
  int index = this._input.indexOf(this._pattern, this._index);
  if ((index >= 0)) {
  return CppStringMatch(index, this._input, this._pattern);
}
  throw StateError("No element");
}
  }
  
}

/// 转换后的类: _CppStringAllMatchesIterator
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/string.dart

class _CppStringAllMatchesIterator implements Iterator<CppStringMatch> {
  late int _index;
  CppStringMatch? _current = null;
  late CppString _input;
  late CppString _pattern;
_CppStringAllMatchesIterator(CppString _input, CppString _pattern, int _index) : _input = _input, _pattern = _pattern, _index = _index, super()   {
    ;
  }
  
  bool moveNext() {
    {
  int patternLen = this._pattern.length;
  if (((this._index + patternLen) > this._input.length)) {
  this._current = null;
  return false;
}
  int index = this._input.indexOf(this._pattern, this._index);
  if ((index < 0)) {
  this._index = (this._input.length + 1);
  this._current = null;
  return false;
}
  int end = (index + patternLen);
  this._current = CppStringMatch(index, this._input, this._pattern);
  this._index = end == this._index ? (end + 1) : end;
  return true;
}
  }
  
  CppStringMatch get current {
    return (() { final CppStringMatch? temp_1877 = this._current; return temp_1877 == null ? temp_1877 as CppStringMatch : temp_1877; })();
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
    return (this.length > 0);
  }
  
  E get first {
    {
  if (this.isEmpty) throw StateError("No element");
  Iterator<E> it = this.iterator;
  if (!(it.moveNext())) throw StateError("No element");
  return it.current;
}
  }
  
  E get last {
    {
  if (this.isEmpty) throw StateError("No element");
  Iterator<E> it = this.iterator;
  E? result;
  while (it.moveNext()) {
  result = it.current;
}
  return (() { final E? temp_1885 = result; return temp_1885 == null ? temp_1885 as E : temp_1885; })();
}
  }
  
  E get single {
    {
  if (this.isEmpty) throw StateError("No element");
  Iterator<E> it = this.iterator;
  it.moveNext();
  E result = it.current;
  if (it.moveNext()) throw StateError("Too many elements");
  return result;
}
  }
  
  E elementAt(int index) {
    {
  if ((index < 0)) throw ArgumentError("Index cannot be negative");
  Iterator<E> it = this.iterator;
  for (int i = 0; (i <= index); i = (i + 1)) {
  {
  if (!(it.moveNext())) throw IndexError(index, this);
  if (i == index) return it.current;
}
}
  throw IndexError(index, this);
}
  }
  
  bool contains(Object? element) {
    {
  Iterator<E> it = this.iterator;
  while (it.moveNext()) {
  if (it.current == element) return true;
}
  return false;
}
  }
  
  void forEach(void Function(E) action) {
    {
  Iterator<E> it = this.iterator;
  while (it.moveNext()) {
  action(it.current);
}
}
  }
  
  Iterable<T> map<T>(T Function(E) toElement) {
    {
  return CppMappedIterable<E, T>(this, toElement);
}
  }
  
  Iterable<E> where(bool Function(E) test) {
    {
  return CppWhereIterable<E>(this, test);
}
  }
  
  Iterable<T> whereType<T>() {
    {
  return CppWhereTypeIterable<T>(this);
}
  }
  
  Iterable<T> expand<T>(Iterable<T> Function(E) toElements) {
    {
  return CppExpandIterable<E, T>(this, toElements);
}
  }
  
  bool any(bool Function(E) test) {
    {
  Iterator<E> it = this.iterator;
  while (it.moveNext()) {
  if (test(it.current)) return true;
}
  return false;
}
  }
  
  bool every(bool Function(E) test) {
    {
  Iterator<E> it = this.iterator;
  while (it.moveNext()) {
  if (!(test(it.current))) return false;
}
  return true;
}
  }
  
  E firstWhere(bool Function(E) test, {E Function()? orElse = null}) {
    {
  Iterator<E> it = this.iterator;
  while (it.moveNext()) {
  if (test(it.current)) return it.current;
}
  if (!(orElse == null)) return orElse();
  throw StateError("No element");
}
  }
  
  E lastWhere(bool Function(E) test, {E Function()? orElse = null}) {
    {
  Iterator<E> it = this.iterator;
  E? result;
  bool found = false;
  while (it.moveNext()) {
  if (test(it.current)) {
  result = it.current;
  found = true;
}
}
  if (found) return (() { final E? temp_1893 = result; return temp_1893 == null ? temp_1893 as E : temp_1893; })();
  if (!(orElse == null)) return orElse();
  throw StateError("No element");
}
  }
  
  E singleWhere(bool Function(E) test, {E Function()? orElse = null}) {
    {
  Iterator<E> it = this.iterator;
  E? result;
  bool found = false;
  while (it.moveNext()) {
  if (test(it.current)) {
  if (found) throw StateError("Too many elements");
  result = it.current;
  found = true;
}
}
  if (found) return (() { final E? temp_1901 = result; return temp_1901 == null ? temp_1901 as E : temp_1901; })();
  if (!(orElse == null)) return orElse();
  throw StateError("No element");
}
  }
  
  E reduce(E Function(E, E) combine) {
    {
  Iterator<E> it = this.iterator;
  if (!(it.moveNext())) throw StateError("No element");
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
  Iterator<E> it = this.iterator;
  while (it.moveNext()) {
  value = combine(value, it.current);
}
  return value;
}
  }
  
  String join([String separator = ""]) {
    {
  Iterator<E> it = this.iterator;
  if (!(it.moveNext())) return "";
  StringBuffer buffer = StringBuffer(it.current.toString());
  while (it.moveNext()) {
  buffer.write(separator);
  buffer.write(it.current.toString());
}
  return buffer.toString();
}
  }
  
  Iterable<E> take(int count) {
    {
  return CppTakeIterable<E>(this, count);
}
  }
  
  Iterable<E> takeWhile(bool Function(E) test) {
    {
  return CppTakeWhileIterable<E>(this, test);
}
  }
  
  Iterable<E> skip(int count) {
    {
  return CppSkipIterable<E>(this, count);
}
  }
  
  Iterable<E> skipWhile(bool Function(E) test) {
    {
  return CppSkipWhileIterable<E>(this, test);
}
  }
  
  Iterable<E> get reversed {
    {
  return CppReversedIterable<E>(this);
}
  }
  
  Iterable<E> followedBy(Iterable<E> other) {
    {
  return CppFollowedByIterable<E>(this, other);
}
  }
  
  List<E> toList({bool growable = true}) {
    {
  return CppList<E>.from(this, growable: growable);
}
  }
  
  Set<E> toSet() {
    {
  return CppSet<E>.from(this);
}
  }
  
  Iterable<T> cast<T>() {
    {
  return CppCastIterable<E, T>(this);
}
  }
  
  static CppIterable<E> empty<E>() {
    return _CppEmptyIterable<E>();
  }
  
  static CppIterable<E> generate<E>(int count, E Function(int) generator) {
    {
  return _CppGenerateIterable<E>(count, generator);
}
  }
  
  static CppIterable<E> unmodifiable<E>(Iterable<E> elements) {
    {
  return _CppUnmodifiableIterable<E>(elements.toList());
}
  }
  
  static CppIterable<R> castFrom<S, R>(Iterable<S> source) {
    {
  return _CppCastFromIterable<S, R>(source);
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
    return CppMappedIterator<S, T>(this._source.iterator, this._f);
  }
  
  int get length {
    return this._source.length;
  }
  
}

/// 转换后的类: CppMappedIterator
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/Iterable.dart

class CppMappedIterator<S, T> extends CppIterator<T> {
  T? _current = null;
  late Iterator<S> _iterator;
  late T Function(S) _f;
CppMappedIterator(Iterator<S> _iterator, T Function(S) _f) : _iterator = _iterator, _f = _f, super()   {
    ;
  }
  
  T get current {
    return (() { final T? temp_1909 = this._current; return temp_1909 == null ? temp_1909 as T : temp_1909; })();
  }
  
  bool moveNext() {
    {
  if (this._iterator.moveNext()) {
  this._current = (() { final S temp_6672_154 = this._iterator.current; return this._f(temp_6672_154); })();
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
    return CppWhereIterator<E>(this._source.iterator, this._test);
  }
  
  int get length {
    {
  int count = 0;
  Iterator<E> it = this.iterator;
  while (it.moveNext()) {
  count = (count + 1);
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
  if ((() { final E temp_7471_240 = this._iterator.current; return this._test(temp_7471_240); })()) {
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
  late Iterable<dynamic?> _source;
CppWhereTypeIterable(Iterable<dynamic?> _source) : _source = _source, super()   {
    ;
  }
  
  Iterator<T> get iterator {
    return CppWhereTypeIterator<T>(this._source.iterator);
  }
  
  int get length {
    {
  int count = 0;
  Iterator<T> it = this.iterator;
  while (it.moveNext()) {
  count = (count + 1);
}
  return count;
}
  }
  
}

/// 转换后的类: CppWhereTypeIterator
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/Iterable.dart

class CppWhereTypeIterator<T> extends CppIterator<T> {
  late Iterator<dynamic?> _iterator;
CppWhereTypeIterator(Iterator<dynamic?> _iterator) : _iterator = _iterator, super()   {
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
    return CppExpandIterator<S, T>(this._source.iterator, this._f);
  }
  
  int get length {
    {
  int count = 0;
  Iterator<T> it = this.iterator;
  while (it.moveNext()) {
  count = (count + 1);
}
  return count;
}
  }
  
}

/// 转换后的类: CppExpandIterator
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/Iterable.dart

class CppExpandIterator<S, T> extends CppIterator<T> {
  Iterator<T>? _currentIterator = null;
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
  this._currentIterator = (() { final S temp_9233_421 = this._iterator.current; return this._f(temp_9233_421); })().iterator;
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
    return CppTakeIterator<E>(this._source.iterator, this._count);
  }
  
  int get length {
    return min<int>(this._count, this._source.length);
  }
  
}

/// 转换后的类: CppTakeIterator
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/Iterable.dart

class CppTakeIterator<E> extends CppIterator<E> {
  late int _remaining;
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
  if ((this._remaining <= 0)) return false;
  if (this._iterator.moveNext()) {
  this._remaining = (this._remaining - 1);
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
    return CppTakeWhileIterator<E>(this._source.iterator, this._test);
  }
  
  int get length {
    {
  int count = 0;
  Iterator<E> it = this.iterator;
  while (it.moveNext()) {
  count = (count + 1);
}
  return count;
}
  }
  
}

/// 转换后的类: CppTakeWhileIterator
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/Iterable.dart

class CppTakeWhileIterator<E> extends CppIterator<E> {
  bool _finished = false;
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
  if ((() { final E temp_10824_602 = this._iterator.current; return this._test(temp_10824_602); })()) {
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
    return CppSkipIterator<E>(this._source.iterator, this._count);
  }
  
  int get length {
    return max<int>(0, (this._source.length - this._count));
  }
  
}

/// 转换后的类: CppSkipIterator
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/Iterable.dart

class CppSkipIterator<E> extends CppIterator<E> {
  bool _skipped = false;
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
  for (int i = 0; (i < this._count); i = (i + 1)) {
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
    return CppSkipWhileIterator<E>(this._source.iterator, this._test);
  }
  
  int get length {
    {
  int count = 0;
  Iterator<E> it = this.iterator;
  while (it.moveNext()) {
  count = (count + 1);
}
  return count;
}
  }
  
}

/// 转换后的类: CppSkipWhileIterator
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/Iterable.dart

class CppSkipWhileIterator<E> extends CppIterator<E> {
  bool _skipped = false;
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
  if (!((() { final E temp_12510_804 = this._iterator.current; return this._test(temp_12510_804); })())) {
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
    return CppReversedIterator<E>(this._source);
  }
  
  int get length {
    return this._source.length;
  }
  
}

/// 转换后的类: CppReversedIterator
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/Iterable.dart

class CppReversedIterator<E> extends CppIterator<E> {
  late int _index;
  late CppList<E> _elements;
CppReversedIterator(Iterable<E> source) : _elements = CppList<E>.from(source), _index = source.length, super()   {
    ;
  }
  
  E get current {
    return this._elements[this._index];
  }
  
  bool moveNext() {
    {
  if ((this._index > 0)) {
  this._index = (this._index - 1);
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
    return CppFollowedByIterator<E>(this._first.iterator, this._second.iterator);
  }
  
  int get length {
    return (this._first.length + this._second.length);
  }
  
}

/// 转换后的类: CppFollowedByIterator
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/Iterable.dart

class CppFollowedByIterator<E> extends CppIterator<E> {
  bool _usingFirst = true;
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
    return CppCastIterator<S, T>(this._source.iterator);
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
    return _CppEmptyIterator<E>();
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
    throw StateError("No element");
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
    return _CppGenerateIterator<E>(this._count, this._generator);
  }
  
  int get length {
    return this._count;
  }
  
}

/// 转换后的类: _CppGenerateIterator
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/Iterable.dart

class _CppGenerateIterator<E> extends CppIterator<E> {
  int _index = 0;
  E? _current = null;
  late int _count;
  late E Function(int) _generator;
_CppGenerateIterator(int _count, E Function(int) _generator) : _count = _count, _generator = _generator, super()   {
    ;
  }
  
  E get current {
    return (() { final E? temp_1917 = this._current; return temp_1917 == null ? temp_1917 as E : temp_1917; })();
  }
  
  bool moveNext() {
    {
  if ((this._index < this._count)) {
  this._current = (() { final int temp_15700_1110 = (() { final int temp_15700_1078 = this._index; return (() { final int temp_15694_1083 = this._index = (temp_15700_1078 + 1); return temp_15700_1078; })(); })(); return this._generator(temp_15700_1110); })();
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
    return _CppCastFromIterator<S, R>(this._source.iterator);
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

/// 全局函数和变量
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/hello.dart

void main() {
  {
  CppString a = CppString.fromCppUserData(CppApi.cppCreateByteArray(6));
  a.toString();
  a.length;
  a.codeUnitAt(0);
  a.substring(0, 1);
  a.compareTo(CppString.Empty);
  a.contains(CppString.Empty);
  testCollectionMethods();
  testIterableMethods();
}
}

void testCollectionMethods() {
  {
  Random aa = Random();
  aa.nextDouble();
  aa.nextDouble();
  aa.nextDouble();
  CppList<int> list = CppList<int>.filled(3, 0);
  list[0] = 1;
  list[1] = 2;
  list[2] = 3;
  assert(list.length == 3);
  assert(list[0] == 1);
  assert(list[1] == 2);
  assert(list[2] == 3);
  assert(list.contains(2));
  assert(!(list.contains(4)));
  list.add(4);
  assert(list.length == 4);
  assert(list[3] == 4);
  list.removeAt(1);
  assert(list.length == 3);
  assert(list[1] == 3);
  print("CppList 方法测试通过！");
}
}

void testIterableMethods() {
  {
  CppList<int> iterableList = CppList<int>.from(List<dynamic?>.from(_GrowableList._literal5<dynamic?>(1, 2, 3, 4, 5)));
  assert(iterableList.first == 1);
  assert(iterableList.last == 5);
  assert(iterableList.length == 5);
  assert(iterableList.any((int element) { return (element > 3);}));
  assert(!(iterableList.every((int element) { return (element < 3);})));
  Iterable<int> mappedList = iterableList.map((int e) { return (e * 2);});
  assert(mappedList.toList().toString() == _GrowableList._literal5<int>(2, 4, 6, 8, 10).toString());
  Iterable<int> filteredList = iterableList.where((int e) { return (e % 2) == 0;});
  assert(filteredList.toList().toString() == _GrowableList._literal2<int>(2, 4).toString());
  print("CppIterable 方法测试通过！");
  CppStringBuffer buffer = CppStringBuffer();
  buffer.write("Hello");
  buffer.write("World");
  print(buffer.toString());
  CppError error = CppError();
  error.toString();
  StringBuffer buffer2 = StringBuffer("xx");
  buffer2.write("Hello");
  buffer2.write("World");
  print(buffer2.toString());
  List<int> list = _GrowableList.generate<int>(10, (int index) { return index;});
  list.add(11);
  print(list.toString());
}
}

/// 全局函数和变量
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/string.dart

final CppUserData cppUserDataEmpty = CppApi.cppCreateByteArray(0);

