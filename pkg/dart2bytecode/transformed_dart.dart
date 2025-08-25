import 'dart:core';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'lib/demo/box.dart';
import 'lib/demo/function_wrapper.dart';

/// cpp:native 类导入
import 'lib/demo/api.dart';

/// 全局Void类型变量，用于替代void返回值
final Void = null;

/// 文件编码映射注解
/// 用于标识不同源文件中的类，避免类名冲突
/// 格式: 编码 -> 源文件路径
///
/// AA -> /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/collection.dart
/// AB -> /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/error.dart
/// AC -> /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/string.dart
/// AD -> /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/Iterable.dart
/// AE -> /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/object.dart

/// 转换后的类: $AA_CppList
/// 原始类名: CppList
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/collection.dart

abstract class $AA_CppList<E> extends $AD_CppIterable<E> {
  $AA_CppList();
  
  factory $AA_CppList.empty({bool growable = false}) {
    {
  return $AA_CppArrayList<E>.empty(growable: growable);
}
  }
  
  factory $AA_CppList.filled(int length, E fill, {bool growable = false}) {
    {
  return $AA_CppArrayList<E>.filled(length, fill, growable: growable);
}
  }
  
  factory $AA_CppList.from($AD_CppIterable<dynamic?> elements, {bool growable = true}) {
    {
  return $AA_CppArrayList<E>.from(elements, growable: growable);
}
  }
  
  factory $AA_CppList.of($AD_CppIterable<E> elements, {bool growable = true}) {
    {
  return $AA_CppArrayList<E>.of(elements, growable: growable);
}
  }
  
  factory $AA_CppList.generate(int length, E Function(int) generator, {bool growable = true}) {
    {
  return $AA_CppArrayList<E>.generate(length, generator, growable: growable);
}
  }
  
  factory $AA_CppList.unmodifiable($AD_CppIterable<dynamic?> elements) {
    {
  return $AA_CppArrayList<E>.unmodifiable(elements);
}
  }
  
  int get length;
  
  set length(int newLen);
  
  void add(E value);
  
  void addAll($AD_CppIterable<E> iterable);
  
  bool any(bool Function(E) test);
  
  $AA_CppMap<int, E> asMap();
  
  $AD_CppIterable<R> cast<R>();
  
  void clear();
  
  bool contains(Object? element);
  
  E elementAt(int index);
  
  bool every(bool Function(E) test);
  
  void fillRange(int start, int end, [E? fillValue = null]);
  
  E firstWhere(bool Function(E) test, {E Function()? orElse = null});
  
  T fold<T>(T initialValue, T Function(T, E) combine);
  
  void forEach(void Function(E) action);
  
  $AD_CppIterable<E> getRange(int start, int end);
  
  int indexOf(E element, [int start = 0]);
  
  int indexWhere(bool Function(E) test, [int start = 0]);
  
  void insert(int index, E element);
  
  void insertAll(int index, $AD_CppIterable<E> iterable);
  
  E get first;
  
  set first(E value);
  
  E get last;
  
  set last(E value);
  
  E get single;
  
  bool get isEmpty;
  
  bool get isNotEmpty;
  
  $AD_CppIterator<E> get iterator;
  
  $AC_CppString join([$AC_CppString separator = const $AC_CppString($AC_CppString._codeUnits: const CppUserData(CppUserData.data: []))]);
  
  int lastIndexOf(E element, [int? start = null]);
  
  int lastIndexWhere(bool Function(E) test, [int? start = null]);
  
  E lastWhere(bool Function(E) test, {E Function()? orElse = null});
  
  E reduce(E Function(E, E) combine);
  
  bool remove(Object? value);
  
  E removeAt(int index);
  
  E removeLast();
  
  void removeRange(int start, int end);
  
  void removeWhere(bool Function(E) test);
  
  void replaceRange(int start, int end, $AD_CppIterable<E> replacements);
  
  void retainWhere(bool Function(E) test);
  
  void setAll(int index, $AD_CppIterable<E> iterable);
  
  void setRange(int start, int end, $AD_CppIterable<E> iterable, [int skipCount = 0]);
  
  void shuffle([Random? random = null]);
  
  void sort([int Function(E, E)? compare = null]);
  
  $AA_CppList<E> sublist(int start, [int? end = null]);
  
  $AA_CppList<E> toList({bool growable = true});
  
  $AA_CppSet<E> toSet();
  
  E singleWhere(bool Function(E) test, {E Function()? orElse = null});
  
  $AC_CppString toCppString();
  
  static $AA_CppList<R> castFrom<S, R>($AA_CppList<S> source) {
    {
  return $AA_CppArrayList.castFrom<S, R>(source);
}
  }
  
  static $AA_CppList<R> castFromWithFactory<S, R>($AA_CppList<S> source, $AA_CppList<R> Function() newList) {
    {
  return $AA_CppArrayList.castFromWithFactory<S, R>(source, newList);
}
  }
  
}

/// 转换后的类: $AA_CppArrayList
/// 原始类名: CppArrayList
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/collection.dart

class $AA_CppArrayList<E> extends $AD_CppIterable<E> implements $AA_CppList<E> {
  late int _length;
  late CppUserData _array;
$AA_CppArrayList.fromCppArray(CppUserData array) : _length = CppApi.cppGetPointerArrayLength(array), _array = array, super()   {
    ;
  }
  
$AA_CppArrayList(int length, int capacity) : _length = length, _array = CppApi.cppCreatePointerArray(length), super()   {
    ;
  }
  
  factory $AA_CppArrayList.empty({bool growable = false}) {
    {
  return growable ? $AA_CppArrayList<E>(0, 0) : $AA_CppArrayList<E>(0, 0);
}
  }
  
  factory $AA_CppArrayList.filled(int length, E fill, {bool growable = false}) {
    {
  CppUserData array = CppApi.cppCreatePointerArray(length);
  for (int i = 0; (i < length); i = (i + 1)) {
  CppApi.cppSetPointerArrayItem(array, i, fill);
}
  return $AA_CppArrayList<E>.fromCppArray(array);
}
  }
  
  factory $AA_CppArrayList.from($AD_CppIterable<dynamic?> elements, {bool growable = true}) {
    {
  int length = elements.length;
  CppUserData array = growable ? CppApi.cppCreatePointerArray(length) : CppApi.cppCreatePointerArray($AA_CppArrayList._getSuggestCapacity(length));
  int i = 0;
  {
  $AD_CppIterator<dynamic?> _sync_for_iterator = elements.iterator;
  for (; _sync_for_iterator.moveNext(); ) {
  CppApi.cppSetPointerArrayItem(array, (() { final int temp_5346_3152 = i; return (() { final int temp_5346_3156 = i = (temp_5346_3152 + 1); return temp_5346_3152; })(); })(), _sync_for_iterator.current);
}
}
  return $AA_CppArrayList<E>.fromCppArray(array);
}
  }
  
  factory $AA_CppArrayList.of($AD_CppIterable<E> elements, {bool growable = true}) {
    return $AA_CppArrayList<E>.from(elements, growable: growable);
  }
  
  factory $AA_CppArrayList.generate(int length, E Function(int) generator, {bool growable = true}) {
    {
  CppUserData array = growable ? CppApi.cppCreatePointerArray(length) : CppApi.cppCreatePointerArray($AA_CppArrayList._getSuggestCapacity(length));
  for (int i = 0; (i < length); i = (i + 1)) {
  CppApi.cppSetPointerArrayItem(array, i, generator.call(i));
}
  return $AA_CppArrayList<E>.fromCppArray(array);
}
  }
  
  factory $AA_CppArrayList.unmodifiable($AD_CppIterable<dynamic?> elements) {
    {
  int length = elements.length;
  CppUserData array = CppApi.cppCreatePointerArray(length);
  int i = 0;
  {
  $AD_CppIterator<dynamic?> _sync_for_iterator = elements.iterator;
  for (; _sync_for_iterator.moveNext(); ) {
  CppApi.cppSetPointerArrayItem(array, (() { final int temp_6337_3256 = i; return (() { final int temp_6337_3260 = i = (temp_6337_3256 + 1); return temp_6337_3256; })(); })(), _sync_for_iterator.current as E);
}
}
  return $AA_CppArrayList<E>.fromCppArray(array);
}
  }
  
  int get length {
    return this._length;
  }
  
  void ensureCapacity(int newLen) {
    {
  if ((newLen > CppApi.cppGetPointerArrayLength(this._array))) {
  CppUserData newArray = CppApi.cppCreatePointerArray($AA_CppArrayList._getSuggestCapacity(newLen));
  for (int i = 0; (i < CppApi.cppGetPointerArrayLength(this._array)); i = (i + 1)) {
  CppApi.cppSetPointerArrayItem(newArray, i, CppApi.cppGetPointerArrayItem(this._array, i));
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
  CppApi.cppSetPointerArrayItem(this._array, (() { final int temp_7465_3415 = this._length; return (() { final int temp_7458_3420 = this._length = (temp_7465_3415 + 1); return temp_7465_3415; })(); })(), value);
}
  }
  
  void addAll($AD_CppIterable<E> iterable) {
    {
  {
  $AD_CppIterator<E> _sync_for_iterator = iterable.iterator;
  for (; _sync_for_iterator.moveNext(); ) {
  this.add(_sync_for_iterator.current);
}
}
}
  }
  
  bool any(bool Function(E) test) {
    {
  for (int i = 0; (i < this._length); i = (i + 1)) {
  if (test.call(CppApi.cppGetPointerArrayItem(this._array, i) as E)) return true;
}
  return false;
}
  }
  
  $AA_CppMap<int, E> asMap() {
    {
  $AA_CppArrayMap<int, E> map = $AA_CppArrayMap<int, E>();
  for (int i = 0; (i < this._length); i = (i + 1)) {
  map[i] = CppApi.cppGetPointerArrayItem(this._array, i) as E;
}
  return map;
}
  }
  
  $AD_CppIterable<R> cast<R>() {
    {
  return $AA_CppArrayList.castFrom<E, R>(this) as $AD_CppIterable<R>;
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
  if (CppApi.cppGetPointerArrayItem(this._array, i) == element) return true;
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
  if (!(test.call(CppApi.cppGetPointerArrayItem(this._array, i) as E))) return false;
}
  return true;
}
  }
  
  void fillRange(int start, int end, [E? fillValue = null]) {
    {
  for (int i = start; (i < end); i = (i + 1)) {
  CppApi.cppSetPointerArrayItem(this._array, i, (() { final E? temp_2993 = fillValue; return temp_2993 == null ? temp_2993 as E : temp_2993; })());
}
}
  }
  
  E firstWhere(bool Function(E) test, {E Function()? orElse = null}) {
    {
  for (int i = 0; (i < this._length); i = (i + 1)) {
  if (test.call(CppApi.cppGetPointerArrayItem(this._array, i) as E)) {
  return CppApi.cppGetPointerArrayItem(this._array, i) as E;
}
}
  if (!(orElse == null)) return orElse.call();
  throw StateError("No element");
}
  }
  
  T fold<T>(T initialValue, T Function(T, E) combine) {
    {
  T value = initialValue;
  for (int i = 0; (i < this._length); i = (i + 1)) {
  value = combine.call(value, CppApi.cppGetPointerArrayItem(this._array, i) as E);
}
  return value;
}
  }
  
  void forEach(void Function(E) action) {
    {
  for (int i = 0; (i < this._length); i = (i + 1)) {
  action.call(CppApi.cppGetPointerArrayItem(this._array, i) as E);
}
}
  }
  
  $AD_CppIterable<E> getRange(int start, int end) {
    {
  return $AA_CppArrayList<E>.from($AD_CppIterable.generate<dynamic?>((end - start), FunctionWrapper<Object? Function(int)>([], (int i) { return CppApi.cppGetPointerArrayItem(this._array, (start + i));}).call()));
}
  }
  
  int indexOf(E element, [int start = 0]) {
    {
  for (int i = start; (i < this._length); i = (i + 1)) {
  if (CppApi.cppGetPointerArrayItem(this._array, i) == element) return i;
}
  return -1;
}
  }
  
  int indexWhere(bool Function(E) test, [int start = 0]) {
    {
  for (int i = start; (i < this._length); i = (i + 1)) {
  if (test.call(CppApi.cppGetPointerArrayItem(this._array, i) as E)) return i;
}
  return -1;
}
  }
  
  void insert(int index, E element) {
    {
  if ((index < 0) || (index > this._length)) throw IndexError(index, this);
  this.ensureCapacity((this._length + 1));
  for (int i = this._length; (i > index); i = (i - 1)) {
  CppApi.cppSetPointerArrayItem(this._array, i, CppApi.cppGetPointerArrayItem(this._array, (i - 1)));
}
  CppApi.cppSetPointerArrayItem(this._array, index, element);
  this._length = (this._length + 1);
}
  }
  
  void insertAll(int index, $AD_CppIterable<E> iterable) {
    {
  if ((index < 0) || (index > this._length)) throw IndexError(index, this);
  $AA_CppList<E> elements = iterable.toList();
  int insertLength = elements.length;
  if (insertLength == 0) return;
  this.ensureCapacity((this._length + insertLength));
  for (int i = (this._length - 1); (i >= index); i = (i - 1)) {
  CppApi.cppSetPointerArrayItem(this._array, (i + insertLength), CppApi.cppGetPointerArrayItem(this._array, i));
}
  for (int i = 0; (i < insertLength); i = (i + 1)) {
  CppApi.cppSetPointerArrayItem(this._array, (index + i), elements[i]);
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
  
  $AD_CppIterator<E> get iterator {
    return $AA__CppListIterator<E>(this);
  }
  
  int lastIndexOf(E element, [int? start = null]) {
    {
  int startIndex = (start) ?? ((this._length - 1));
  for (int i = startIndex; (i >= 0); i = (i - 1)) {
  if (CppApi.cppGetPointerArrayItem(this._array, i) == element) return i;
}
  return -1;
}
  }
  
  int lastIndexWhere(bool Function(E) test, [int? start = null]) {
    {
  int startIndex = (start) ?? ((this._length - 1));
  for (int i = startIndex; (i >= 0); i = (i - 1)) {
  if (test.call(CppApi.cppGetPointerArrayItem(this._array, i) as E)) return i;
}
  return -1;
}
  }
  
  E lastWhere(bool Function(E) test, {E Function()? orElse = null}) {
    {
  for (int i = (this._length - 1); (i >= 0); i = (i - 1)) {
  if (test.call(CppApi.cppGetPointerArrayItem(this._array, i) as E)) {
  return CppApi.cppGetPointerArrayItem(this._array, i) as E;
}
}
  if (!(orElse == null)) return orElse.call();
  throw StateError("No element");
}
  }
  
  E reduce(E Function(E, E) combine) {
    {
  if (this._length == 0) throw StateError("No element");
  E value = CppApi.cppGetPointerArrayItem(this._array, 0) as E;
  for (int i = 1; (i < this._length); i = (i + 1)) {
  value = combine.call(value, CppApi.cppGetPointerArrayItem(this._array, i) as E);
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
  CppApi.cppSetPointerArrayItem(this._array, i, CppApi.cppGetPointerArrayItem(this._array, (i + 1)));
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
  CppApi.cppSetPointerArrayItem(this._array, i, CppApi.cppGetPointerArrayItem(this._array, (i + length)));
}
  this._length = (this._length - length);
}
  }
  
  void removeWhere(bool Function(E) test) {
    {
  int writeIndex = 0;
  for (int readIndex = 0; (readIndex < this._length); readIndex = (readIndex + 1)) {
  if (!(test.call(CppApi.cppGetPointerArrayItem(this._array, readIndex) as E))) {
  if (!(writeIndex == readIndex)) {
  CppApi.cppSetPointerArrayItem(this._array, writeIndex, CppApi.cppGetPointerArrayItem(this._array, readIndex));
}
  writeIndex = (writeIndex + 1);
}
}
  this._length = writeIndex;
}
  }
  
  void replaceRange(int start, int end, $AD_CppIterable<E> replacements) {
    {
  if ((start < 0) || (start > this._length) || (end < start) || (end > this._length)) {
  throw RangeError.range(start, 0, this._length);
}
  $AA_CppList<E> replacementList = replacements.toList();
  int replacementLength = replacementList.length;
  int rangeLength = (end - start);
  if ((replacementLength > rangeLength)) {
  this.ensureCapacity(((this._length + replacementLength) - rangeLength));
}
  if (!(replacementLength == rangeLength)) {
  for (int i = (this._length - 1); (i >= end); i = (i - 1)) {
  CppApi.cppSetPointerArrayItem(this._array, ((i + replacementLength) - rangeLength), CppApi.cppGetPointerArrayItem(this._array, i));
}
}
  for (int i = 0; (i < replacementLength); i = (i + 1)) {
  CppApi.cppSetPointerArrayItem(this._array, (start + i), replacementList[i]);
}
  this._length = (this._length + (replacementLength - rangeLength));
}
  }
  
  void retainWhere(bool Function(E) test) {
    {
  int writeIndex = 0;
  for (int readIndex = 0; (readIndex < this._length); readIndex = (readIndex + 1)) {
  if (test.call(CppApi.cppGetPointerArrayItem(this._array, readIndex) as E)) {
  if (!(writeIndex == readIndex)) {
  CppApi.cppSetPointerArrayItem(this._array, writeIndex, CppApi.cppGetPointerArrayItem(this._array, readIndex));
}
  writeIndex = (writeIndex + 1);
}
}
  this._length = writeIndex;
}
  }
  
  void setAll(int index, $AD_CppIterable<E> iterable) {
    {
  if ((index < 0) || (index > this._length)) throw IndexError(index, this);
  int i = index;
  {
  $AD_CppIterator<E> _sync_for_iterator = iterable.iterator;
  for (; _sync_for_iterator.moveNext(); ) {
  E element = _sync_for_iterator.current;
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
  
  void setRange(int start, int end, $AD_CppIterable<E> iterable, [int skipCount = 0]) {
    {
  if ((start < 0) || (start > this._length) || (end < start) || (end > this._length)) {
  throw RangeError.range(start, 0, this._length);
}
  $AD_CppIterator<E> iterator = iterable.iterator;
  for (int i = 0; (i < skipCount); i = (i + 1)) {
  if (!(iterator.moveNext())) return;
}
  label: for (int i = start; (i < end); i = (i + 1)) {
  if (!(iterator.moveNext())) break;
  CppApi.cppSetPointerArrayItem(this._array, i, iterator.current);
}
}
  }
  
  void shuffle([Random? random = null]) {
    {
  random == null ? random = Random() : null;
  for (int i = (this._length - 1); (i > 0); i = (i - 1)) {
  int j = random.nextInt((i + 1));
  Object? temp = CppApi.cppGetPointerArrayItem(this._array, i);
  CppApi.cppSetPointerArrayItem(this._array, i, CppApi.cppGetPointerArrayItem(this._array, j));
  CppApi.cppSetPointerArrayItem(this._array, j, temp);
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
  E current = CppApi.cppGetPointerArrayItem(this._array, j) as E;
  bool shouldSwap;
  if (!(compare == null)) {
  shouldSwap = (compare.call(current, pivot) <= 0);
} else {
  shouldSwap = ((current as Comparable<dynamic?>).compareTo(pivot) <= 0);
}
  if (shouldSwap) {
  i = (i + 1);
  this._swap(i, j);
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
  
  $AA_CppList<E> sublist(int start, [int? end = null]) {
    {
  int endIndex = (end) ?? (this._length);
  if ((start < 0) || (start > this._length) || (endIndex < start) || (endIndex > this._length)) {
  throw RangeError.range(start, 0, this._length);
}
  return $AA_CppArrayList<E>.from($AD_CppIterable.generate<dynamic?>((endIndex - start), FunctionWrapper<Object? Function(int)>([], (int i) { return CppApi.cppGetPointerArrayItem(this._array, (start + i));}).call()));
}
  }
  
  $AA_CppList<E> toList({bool growable = true}) {
    {
  return $AA_CppArrayList<E>.from(this as $AD_CppIterable<dynamic?>, growable: growable);
}
  }
  
  $AA_CppSet<E> toSet() {
    {
  return $AA_CppArraySet<E>.from(this);
}
  }
  
  E singleWhere(bool Function(E) test, {E Function()? orElse = null}) {
    {
  E? result;
  bool found = false;
  for (int i = 0; (i < this._length); i = (i + 1)) {
  if (test.call(CppApi.cppGetPointerArrayItem(this._array, i) as E)) {
  if (found) throw StateError("Too many elements");
  result = CppApi.cppGetPointerArrayItem(this._array, i) as E;
  found = true;
}
}
  if (found) return result!;
  if (!(orElse == null)) return orElse.call();
  throw StateError("No element");
}
  }
  
  $AC_CppString toCppString() {
    {
  if (this._length == 0) return $AC_CppString.fromString("[]");
  $AC_CppStringBuffer buffer = $AC_CppStringBuffer("[");
  buffer.write(CppApi.cppGetPointerArrayItem(this._array, 0));
  for (int i = 1; (i < this._length); i = (i + 1)) {
  buffer.write(", ");
  buffer.write(CppApi.cppGetPointerArrayItem(this._array, i));
}
  buffer.write("]");
  return buffer.toCppString();
}
  }
  
  static int _getSuggestCapacity(int newLen) {
    {
  return (newLen > 256) ? newLen : pow(2, (log(newLen) / log(2)).ceil()).toInt();
}
  }
  
  static $AA_CppList<R> castFrom<S, R>($AA_CppList<S> source) {
    {
  $AA_CppArrayList<R> result = $AA_CppArrayList<R>(0, 4);
  {
  $AD_CppIterator<S> _sync_for_iterator = source.iterator;
  for (; _sync_for_iterator.moveNext(); ) {
  result.add(_sync_for_iterator.current as R);
}
}
  return result;
}
  }
  
  static $AA_CppList<R> castFromWithFactory<S, R>($AA_CppList<S> source, $AA_CppList<R> Function() newList) {
    {
  $AA_CppList<R> result = newList.call();
  {
  $AD_CppIterator<S> _sync_for_iterator = source.iterator;
  for (; _sync_for_iterator.moveNext(); ) {
  result.add(_sync_for_iterator.current as R);
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
  
  $AA_CppList<E> operator +($AA_CppList<E> other) {
    {
  $AA_CppArrayList<E> result = $AA_CppArrayList<E>(0, (this._length + other.length));
  for (int i = 0; (i < this._length); i = (i + 1)) {
  result.add(CppApi.cppGetPointerArrayItem(this._array, i) as E);
}
  {
  $AD_CppIterator<E> _sync_for_iterator = other.iterator;
  for (; _sync_for_iterator.moveNext(); ) {
  result.add(_sync_for_iterator.current);
}
}
  return result;
}
  }
  
}

/// 转换后的类: $AA__CppListIterator
/// 原始类名: _CppListIterator
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/collection.dart

class $AA__CppListIterator<E> extends $AE_CppObject implements $AD_CppIterator<E> {
  int _index = -1;
  late $AA_CppArrayList<E> _list;
$AA__CppListIterator($AA_CppArrayList<E> _list) : _list = _list, super()   {
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

/// 转换后的类: $AA_CppSet
/// 原始类名: CppSet
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/collection.dart

abstract class $AA_CppSet<E> extends $AE_CppObject {
  $AA_CppSet();
  
  factory $AA_CppSet.identity() {
    return $AA_CppArraySet<E>.identity();
  }
  
  factory $AA_CppSet.from($AD_CppIterable<dynamic?> elements) {
    {
  return $AA_CppArraySet<E>.from(elements);
}
  }
  
  factory $AA_CppSet.of($AD_CppIterable<E> elements) {
    return $AA_CppArraySet<E>.of(elements);
  }
  
  factory $AA_CppSet.unmodifiable($AD_CppIterable<E> elements) {
    {
  return $AA_CppArraySet<E>.unmodifiable(elements);
}
  }
  
  bool add(E value);
  
  void addAll($AD_CppIterable<E> elements);
  
  $AD_CppIterable<R> cast<R>();
  
  void clear();
  
  bool contains(Object? element);
  
  bool containsAll($AD_CppIterable<Object?> other);
  
  $AA_CppSet<E> difference($AA_CppSet<Object?> other);
  
  E elementAt(int index);
  
  $AA_CppSet<E> intersection($AA_CppSet<Object?> other);
  
  E get first;
  
  E get last;
  
  E get single;
  
  bool get isEmpty;
  
  bool get isNotEmpty;
  
  $AD_CppIterator<E> get iterator;
  
  int get length;
  
  E? lookup(Object? element);
  
  bool remove(Object? value);
  
  void removeAll($AD_CppIterable<Object?> elementsToRemove);
  
  void removeWhere(bool Function(E) test);
  
  void retainAll($AD_CppIterable<Object?> elementsToRetain);
  
  void retainWhere(bool Function(E) test);
  
  $AA_CppSet<E> union($AA_CppSet<E> other);
  
  $AC_CppString toCppString();
  
  static $AA_CppSet<R> castFrom<S, R>($AA_CppSet<S> source) {
    {
  return $AA_CppArraySet.castFrom<S, R>(source);
}
  }
  
  static $AA_CppSet<R> castFromWithFactory<S, R>($AA_CppSet<S> source, $AA_CppSet<R> Function() newSet) {
    {
  return $AA_CppArraySet.castFromWithFactory<S, R>(source, newSet);
}
  }
  
}

/// 转换后的类: $AA_CppArraySet
/// 原始类名: CppArraySet
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/collection.dart

class $AA_CppArraySet<E> extends $AD_CppIterable<E> implements $AA_CppSet<E> {
  late $AA_CppArrayList<E> _list;
$AA_CppArraySet.fromCppArray(CppUserData array) : _list = $AA_CppArrayList<E>.fromCppArray(array), super()   {
    ;
  }
  
$AA_CppArraySet([int capacity = 4]) : _list = $AA_CppArrayList<E>(0, capacity), super()   {
    ;
  }
  
  factory $AA_CppArraySet.identity() {
    return $AA_CppArraySet<E>(4);
  }
  
  factory $AA_CppArraySet.from($AD_CppIterable<dynamic?> elements) {
    {
  $AA_CppArraySet<E> set = $AA_CppArraySet<E>();
  {
  $AD_CppIterator<dynamic?> _sync_for_iterator = elements.iterator;
  for (; _sync_for_iterator.moveNext(); ) {
  set.add(_sync_for_iterator.current as E);
}
}
  return set;
}
  }
  
  factory $AA_CppArraySet.of($AD_CppIterable<E> elements) {
    return $AA_CppArraySet<E>.from(elements);
  }
  
  factory $AA_CppArraySet.unmodifiable($AD_CppIterable<E> elements) {
    {
  $AA_CppArraySet<E> set = $AA_CppArraySet<E>();
  {
  $AD_CppIterator<E> _sync_for_iterator = elements.iterator;
  for (; _sync_for_iterator.moveNext(); ) {
  set.add(_sync_for_iterator.current);
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
  
  void addAll($AD_CppIterable<E> elements) {
    {
  {
  $AD_CppIterator<E> _sync_for_iterator = elements.iterator;
  for (; _sync_for_iterator.moveNext(); ) {
  this.add(_sync_for_iterator.current);
}
}
}
  }
  
  $AD_CppIterable<R> cast<R>() {
    {
  return $AA_CppSet.castFrom<E, R>(this) as $AD_CppIterable<R>;
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
  if (element == this._list[i]) {
  return true;
}
}
  return false;
}
  }
  
  bool containsAll($AD_CppIterable<Object?> other) {
    {
  {
  $AD_CppIterator<Object?> _sync_for_iterator = other.iterator;
  for (; _sync_for_iterator.moveNext(); ) {
  if (!(this.contains(_sync_for_iterator.current))) return false;
}
}
  return true;
}
  }
  
  $AA_CppSet<E> difference($AA_CppSet<Object?> other) {
    {
  $AA_CppArraySet<E> result = $AA_CppArraySet<E>();
  {
  $AD_CppIterator<E> _sync_for_iterator = this._list.iterator;
  for (; _sync_for_iterator.moveNext(); ) {
  E element = _sync_for_iterator.current;
  if (!(other.contains(element))) {
  result.add(element);
}
}
}
  return result;
}
  }
  
  E elementAt(int index) {
    return this._list.elementAt(index);
  }
  
  $AA_CppSet<E> intersection($AA_CppSet<Object?> other) {
    {
  $AA_CppArraySet<E> result = $AA_CppArraySet<E>();
  {
  $AD_CppIterator<E> _sync_for_iterator = this._list.iterator;
  for (; _sync_for_iterator.moveNext(); ) {
  E element = _sync_for_iterator.current;
  if (other.contains(element)) {
  result.add(element);
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
  
  $AD_CppIterator<E> get iterator {
    return this._list.iterator;
  }
  
  int get length {
    return this._list.length;
  }
  
  E? lookup(Object? element) {
    {
  for (int i = 0; (i < this._list.length); i = (i + 1)) {
  if (element == this._list[i]) {
  return this._list[i];
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
  
  void removeAll($AD_CppIterable<Object?> elementsToRemove) {
    {
  {
  $AD_CppIterator<Object?> _sync_for_iterator = elementsToRemove.iterator;
  for (; _sync_for_iterator.moveNext(); ) {
  this.remove(_sync_for_iterator.current);
}
}
}
  }
  
  void removeWhere(bool Function(E) test) {
    {
  this._list.removeWhere(test);
}
  }
  
  void retainAll($AD_CppIterable<Object?> elementsToRetain) {
    {
  $AA_CppSet<dynamic?> retainSet = $AA_CppSet<dynamic?>.from(elementsToRetain);
  this.removeWhere(FunctionWrapper<bool Function(E)>([], (E element) { return !(retainSet.contains(element));}).call());
}
  }
  
  void retainWhere(bool Function(E) test) {
    {
  this._list.retainWhere(test);
}
  }
  
  $AA_CppSet<E> union($AA_CppSet<E> other) {
    {
  $AA_CppArraySet<E> result = $AA_CppArraySet<E>();
  result.addAll(this as $AD_CppIterable<E>);
  result.addAll(other as $AD_CppIterable<E>);
  return result;
}
  }
  
  $AC_CppString toCppString() {
    {
  if (this._list.isEmpty) return $AC_CppString.fromString("{}");
  $AC_CppStringBuffer buffer = $AC_CppStringBuffer("{");
  $AD_CppIterator<E> iterator = this._list.iterator;
  if (iterator.moveNext()) {
  buffer.write(iterator.current);
  while (iterator.moveNext()) {
  buffer.write(", ");
  buffer.write(iterator.current);
}
}
  buffer.write("}");
  return buffer.toCppString();
}
  }
  
  static $AA_CppSet<R> castFrom<S, R>($AA_CppSet<S> source) {
    {
  $AA_CppArraySet<R> result = $AA_CppArraySet<R>();
  {
  $AD_CppIterator<S> _sync_for_iterator = source.iterator;
  for (; _sync_for_iterator.moveNext(); ) {
  result.add(_sync_for_iterator.current as R);
}
}
  return result;
}
  }
  
  static $AA_CppSet<R> castFromWithFactory<S, R>($AA_CppSet<S> source, $AA_CppSet<R> Function() newSet) {
    {
  $AA_CppSet<R> result = newSet.call();
  {
  $AD_CppIterator<S> _sync_for_iterator = source.iterator;
  for (; _sync_for_iterator.moveNext(); ) {
  result.add(_sync_for_iterator.current as R);
}
}
  return result;
}
  }
  
}

/// 转换后的类: $AA_CppMapEntry
/// 原始类名: CppMapEntry
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/collection.dart

class $AA_CppMapEntry<K, V> extends $AE_CppObject {
  late K key;
  late V value;
$AA_CppMapEntry(K key, V value) : key = key, value = value, super()   {
    ;
  }
  
}

/// 转换后的类: $AA_CppMap
/// 原始类名: CppMap
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/collection.dart

abstract class $AA_CppMap<K, V> extends $AE_CppObject {
  $AA_CppMap();
  
  factory $AA_CppMap.identity() {
    return $AA_CppArrayMap<K, V>.identity();
  }
  
  factory $AA_CppMap.from($AA_CppMap<dynamic?, dynamic?> other) {
    return $AA_CppArrayMap<K, V>.from(other);
  }
  
  factory $AA_CppMap.of($AA_CppMap<K, V> other) {
    return $AA_CppArrayMap<K, V>.of(other);
  }
  
  factory $AA_CppMap.unmodifiable($AA_CppMap<dynamic?, dynamic?> other) {
    {
  return $AA_CppArrayMap<K, V>.unmodifiable(other);
}
  }
  
  factory $AA_CppMap.fromIterable($AD_CppIterable<dynamic?> iterable, {K Function(dynamic?)? key = null, V Function(dynamic?)? value = null}) {
    {
  return $AA_CppArrayMap<K, V>.fromIterable(iterable, key: key, value: value);
}
  }
  
  factory $AA_CppMap.fromIterables($AD_CppIterable<K> keys, $AD_CppIterable<V> values) {
    {
  return $AA_CppArrayMap<K, V>.fromIterables(keys, values);
}
  }
  
  factory $AA_CppMap.fromEntries($AD_CppIterable<MapEntry<K, V>> entries) {
    {
  return $AA_CppArrayMap<K, V>.fromEntries(entries);
}
  }
  
  void addAll($AA_CppMap<K, V> other);
  
  void addEntries($AD_CppIterable<MapEntry<K, V>> entries);
  
  $AA_CppMap<RK, RV> cast<RK, RV>();
  
  void clear();
  
  bool containsKey(Object? key);
  
  bool containsValue(Object? value);
  
  $AD_CppIterable<MapEntry<K, V>> get entries;
  
  void forEach(void Function(K, V) action);
  
  bool get isEmpty;
  
  bool get isNotEmpty;
  
  $AD_CppIterable<K> get keys;
  
  int get length;
  
  V putIfAbsent(K key, V Function() ifAbsent);
  
  V? remove(Object? key);
  
  void removeWhere(bool Function(K, V) test);
  
  V update(K key, V Function(V) update, {V Function()? ifAbsent = null});
  
  void updateAll(V Function(K, V) update);
  
  $AD_CppIterable<V> get values;
  
  $AA_CppMap<K2, V2> map<K2, V2>(MapEntry<K2, V2> Function(K, V) transform);
  
  $AC_CppString toCppString();
  
  static $AA_CppMap<RK, RV> castFrom<K, V, RK, RV>($AA_CppMap<K, V> source) {
    {
  return $AA_CppArrayMap.castFrom<K, V, RK, RV>(source);
}
  }
  
  static $AA_CppMap<RK, RV> castFromWithFactory<K, V, RK, RV>($AA_CppMap<K, V> source, $AA_CppMap<RK, RV> Function() newMap) {
    {
  return $AA_CppArrayMap.castFromWithFactory<K, V, RK, RV>(source, newMap);
}
  }
  
}

/// 转换后的类: $AA_CppArrayMap
/// 原始类名: CppArrayMap
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/collection.dart

class $AA_CppArrayMap<K, V> extends $AE_CppObject implements $AA_CppMap<K, V> {
  late $AA_CppArrayList<MapEntry<K, V>> _list;
$AA_CppArrayMap.fromCppArray(CppUserData array) : _list = $AA_CppArrayList<MapEntry<K, V>>.fromCppArray(array), super()   {
    ;
  }
  
$AA_CppArrayMap([int capacity = 4]) : _list = $AA_CppArrayList<MapEntry<K, V>>(0, capacity), super()   {
    ;
  }
  
  factory $AA_CppArrayMap.identity() {
    return $AA_CppArrayMap<K, V>();
  }
  
  factory $AA_CppArrayMap.from($AA_CppMap<dynamic?, dynamic?> other) {
    return $AA_CppArrayMap<K, V>.unmodifiable(other);
  }
  
  factory $AA_CppArrayMap.of($AA_CppMap<K, V> other) {
    return $AA_CppArrayMap<K, V>.fromEntries(other.entries);
  }
  
  factory $AA_CppArrayMap.unmodifiable($AA_CppMap<dynamic?, dynamic?> other) {
    {
  $AA_CppArrayMap<K, V> map = $AA_CppArrayMap<K, V>();
  other.forEach(FunctionWrapper<void Function(dynamic?, dynamic?)>([], (dynamic? key, dynamic? value) { {
  map[key as K] = value as V;
}}).call());
  return map;
}
  }
  
  factory $AA_CppArrayMap.fromIterable($AD_CppIterable<dynamic?> iterable, {K Function(dynamic?)? key = null, V Function(dynamic?)? value = null}) {
    {
  $AA_CppArrayMap<K, V> map = $AA_CppArrayMap<K, V>();
  {
  $AD_CppIterator<dynamic?> _sync_for_iterator = iterable.iterator;
  for (; _sync_for_iterator.moveNext(); ) {
  dynamic? element = _sync_for_iterator.current;
  dynamic? k = ((() { final K Function(dynamic?)? temp_33093_6821 = key; return temp_33093_6821 == null ? null : temp_33093_6821.call(element); })()) ?? (element);
  dynamic? v = ((() { final V Function(dynamic?)? temp_33140_6831 = value; return temp_33140_6831 == null ? null : temp_33140_6831.call(element); })()) ?? (element);
  map[k as K] = v as V;
}
}
  return map;
}
  }
  
  factory $AA_CppArrayMap.fromIterables($AD_CppIterable<K> keys, $AD_CppIterable<V> values) {
    {
  $AA_CppArrayMap<K, V> map = $AA_CppArrayMap<K, V>();
  $AD_CppIterator<K> keyIter = keys.iterator;
  $AD_CppIterator<V> valueIter = values.iterator;
  while (keyIter.moveNext() && valueIter.moveNext()) {
  map[keyIter.current] = valueIter.current;
}
  return map;
}
  }
  
  factory $AA_CppArrayMap.fromEntries($AD_CppIterable<MapEntry<K, V>> entries) {
    {
  $AA_CppArrayMap<K, V> map = $AA_CppArrayMap<K, V>();
  {
  $AD_CppIterator<MapEntry<K, V>> _sync_for_iterator = entries.iterator;
  for (; _sync_for_iterator.moveNext(); ) {
  MapEntry<K, V> entry = _sync_for_iterator.current;
  map[entry.key] = entry.value;
}
}
  return map;
}
  }
  
  void addAll($AA_CppMap<K, V> other) {
    {
  other.forEach(FunctionWrapper<void Function(K, V)>([], (K k, V v) { return (() { final K temp_34567_7068 = k; return (() { final V temp_34573_7070 = v; return (() { this[temp_34567_7068] = temp_34573_7070; temp_34573_7070; })(); })(); })();}).call());
}
  }
  
  void addEntries($AD_CppIterable<MapEntry<K, V>> entries) {
    {
  {
  $AD_CppIterator<MapEntry<K, V>> _sync_for_iterator = entries.iterator;
  for (; _sync_for_iterator.moveNext(); ) {
  MapEntry<K, V> entry = _sync_for_iterator.current;
  this[entry.key] = entry.value;
}
}
}
  }
  
  $AA_CppMap<RK, RV> cast<RK, RV>() {
    return $AA_CppMap.castFrom<K, V, RK, RV>(this);
  }
  
  void clear() {
    {
  this._list.clear();
}
  }
  
  bool containsKey(Object? key) {
    {
  {
  $AD_CppIterator<MapEntry<K, V>> _sync_for_iterator = this._list.iterator;
  for (; _sync_for_iterator.moveNext(); ) {
  MapEntry<K, V> entry = _sync_for_iterator.current;
  if (entry.key == key) return true;
}
}
  return false;
}
  }
  
  bool containsValue(Object? value) {
    {
  {
  $AD_CppIterator<MapEntry<K, V>> _sync_for_iterator = this._list.iterator;
  for (; _sync_for_iterator.moveNext(); ) {
  MapEntry<K, V> entry = _sync_for_iterator.current;
  if (entry.value == value) return true;
}
}
  return false;
}
  }
  
  $AD_CppIterable<MapEntry<K, V>> get entries {
    return this._list;
  }
  
  void forEach(void Function(K, V) action) {
    {
  {
  $AD_CppIterator<MapEntry<K, V>> _sync_for_iterator = this._list.iterator;
  for (; _sync_for_iterator.moveNext(); ) {
  MapEntry<K, V> entry = _sync_for_iterator.current;
  action.call(entry.key, entry.value);
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
  
  $AD_CppIterable<K> get keys {
    return this._list.map(FunctionWrapper<K Function(MapEntry<K, V>)>([], (MapEntry<K, V> e) { return e.key;}).call());
  }
  
  int get length {
    return this._list.length;
  }
  
  V putIfAbsent(K key, V Function() ifAbsent) {
    {
  {
  $AD_CppIterator<MapEntry<K, V>> _sync_for_iterator = this._list.iterator;
  for (; _sync_for_iterator.moveNext(); ) {
  MapEntry<K, V> entry = _sync_for_iterator.current;
  if (entry.key == key) return entry.value;
}
}
  V v = ifAbsent.call();
  this._list.add(MapEntry<K, V>(key, v));
  return v;
}
  }
  
  V? remove(Object? key) {
    {
  for (int i = 0; (i < this._list.length); i = (i + 1)) {
  if (this._list[i].key == key) {
  V v = this._list[i].value;
  for (int j = i; (j < (this._list.length - 1)); j = (j + 1)) {
  this._list[j] = this._list[(j + 1)];
}
  this._list.length = (this._list.length - 1);
  return v;
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
  if (test.call(entry.key, entry.value)) {
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
  if (this._list[i].key == key) {
  V newValue = update.call(this._list[i].value);
  this._list[i] = MapEntry<K, V>(key, newValue);
  return newValue;
}
}
  if (!(ifAbsent == null)) {
  V v = ifAbsent.call();
  this._list.add(MapEntry<K, V>(key, v));
  return v;
}
  throw ArgumentError("Key not found");
}
  }
  
  void updateAll(V Function(K, V) update) {
    {
  for (int i = 0; (i < this._list.length); i = (i + 1)) {
  MapEntry<K, V> entry = this._list[i];
  this._list[i] = MapEntry<K, V>(entry.key, update.call(entry.key, entry.value));
}
}
  }
  
  $AD_CppIterable<V> get values {
    return this._list.map(FunctionWrapper<V Function(MapEntry<K, V>)>([], (MapEntry<K, V> e) { return e.value;}).call());
  }
  
  $AA_CppMap<K2, V2> map<K2, V2>(MapEntry<K2, V2> Function(K, V) transform) {
    {
  $AA_CppArrayMap<K2, V2> result = $AA_CppArrayMap<K2, V2>();
  {
  $AD_CppIterator<MapEntry<K, V>> _sync_for_iterator = this._list.iterator;
  for (; _sync_for_iterator.moveNext(); ) {
  MapEntry<K, V> entry = _sync_for_iterator.current;
  MapEntry<K2, V2> newEntry = transform.call(entry.key, entry.value);
  result[newEntry.key] = newEntry.value;
}
}
  return result;
}
  }
  
  $AC_CppString toCppString() {
    {
  if (this._list.isEmpty) return $AC_CppString.fromString("{}");
  $AC_CppStringBuffer buffer = $AC_CppStringBuffer("{");
  $AD_CppIterator<MapEntry<K, V>> iterator = this._list.iterator;
  if (iterator.moveNext()) {
  buffer.write((iterator.current.key).toString() + ": " + (iterator.current.value).toString());
  while (iterator.moveNext()) {
  buffer.write(", " + (iterator.current.key).toString() + ": " + (iterator.current.value).toString());
}
}
  buffer.write("}");
  return buffer.toCppString();
}
  }
  
  static $AA_CppMap<RK, RV> castFrom<K, V, RK, RV>($AA_CppMap<K, V> source) {
    {
  $AA_CppArrayMap<RK, RV> result = $AA_CppArrayMap<RK, RV>();
  source.forEach(FunctionWrapper<void Function(K, V)>([], (K key, V value) { {
  result[key as RK] = value as RV;
}}).call());
  return result;
}
  }
  
  static $AA_CppMap<RK, RV> castFromWithFactory<K, V, RK, RV>($AA_CppMap<K, V> source, $AA_CppMap<RK, RV> Function() newMap) {
    {
  $AA_CppMap<RK, RV> result = newMap.call();
  source.forEach(FunctionWrapper<void Function(K, V)>([], (K key, V value) { {
  result[key as RK] = value as RV;
}}).call());
  return result;
}
  }
  
  V? operator [](Object? key) {
    {
  {
  $AD_CppIterator<MapEntry<K, V>> _sync_for_iterator = this._list.iterator;
  for (; _sync_for_iterator.moveNext(); ) {
  MapEntry<K, V> entry = _sync_for_iterator.current;
  if (entry.key == key) {
  return entry.value;
}
}
}
  return null;
}
  }
  
  void operator []=(K key, V value) {
    {
  for (int i = 0; (i < this._list.length); i = (i + 1)) {
  if (this._list[i].key == key) {
  this._list[i] = MapEntry<K, V>(key, value);
  return;
}
}
  this._list.add(MapEntry<K, V>(key, value));
}
  }
  
}

/// 转换后的类: $AB_CppError
/// 原始类名: CppError
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/error.dart

class $AB_CppError extends $AE_CppObject {
$AB_CppError() : super()   {
    ;
  }
  
  $AB_CppStackTrace? get stackTrace {
    return $AB_CppStackTrace.current;
  }
  
}

/// 转换后的类: $AB_CppStackTrace
/// 原始类名: CppStackTrace
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/error.dart

class $AB_CppStackTrace extends $AE_CppObject {
  static $AB_CppStackTrace _current = $AB_CppStackTrace();
$AB_CppStackTrace() : super()   {
    ;
  }
  
  static $AB_CppStackTrace get current {
    return $AB_CppStackTrace._current;
  }
  
  $AC_CppString toCppString() {
    return $AC_CppString.fromString(CppApi.getCurrentStackTrace());
  }
  
}

/// 转换后的类: $AC_CppStringPool
/// 原始类名: CppStringPool
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/string.dart

class $AC_CppStringPool {
  static final $AC_CppStringPool _instance = $AC_CppStringPool._internal();
  late $AA_CppList<CppUserData> _pool = $AA_CppList<CppUserData>.from(<CppUserData>[const CppUserData(CppUserData.data: [])] as $AD_CppIterable<dynamic?>);
$AC_CppStringPool._internal() : super()   {
    ;
  }
  
  static $AC_CppStringPool get instance {
    return $AC_CppStringPool._instance;
  }
  
  CppUserData getOrCreateFromCodeUnits($AA_CppList<int> codeUnits) {
    {
  {
  $AD_CppIterator<CppUserData> _sync_for_iterator = this._pool.iterator;
  for (; _sync_for_iterator.moveNext(); ) {
  CppUserData existing = _sync_for_iterator.current;
  if (this._compareUserData(existing, codeUnits)) {
  return existing;
}
}
}
  CppUserData userData = CppApi.cppCreateByteArray(codeUnits.length);
  for (int i = 0; (i < codeUnits.length); i = (i + 1)) {
  CppApi.cppSetByteArrayItem(userData, i, codeUnits[i]);
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
  
  bool _compareUserData(CppUserData userData, $AA_CppList<int> codeUnits) {
    {
  int length = CppApi.cppGetByteArrayLength(userData);
  if (!(length == codeUnits.length)) return false;
  for (int i = 0; (i < length); i = (i + 1)) {
  if (!(CppApi.cppGetByteArrayItem(userData, i) == codeUnits[i])) {
  return false;
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
  
  $AC_CppStringPoolStats getStats() {
    {
  int totalMemory = 0;
  {
  $AD_CppIterator<CppUserData> _sync_for_iterator = this._pool.iterator;
  for (; _sync_for_iterator.moveNext(); ) {
  CppUserData userData = _sync_for_iterator.current;
  totalMemory = (totalMemory + CppApi.cppGetByteArrayLength(userData));
}
}
  return $AC_CppStringPoolStats(totalStrings: this._pool.length, totalMemory: totalMemory);
}
  }
  
}

/// 转换后的类: $AC_CppStringPoolStats
/// 原始类名: CppStringPoolStats
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/string.dart

class $AC_CppStringPoolStats {
  late int totalStrings;
  late int totalMemory;
$AC_CppStringPoolStats({required int totalStrings, required int totalMemory}) : totalStrings = totalStrings, totalMemory = totalMemory, super()   {
    ;
  }
  
  String toString() {
    {
  return "CppStringPoolStats{\n" + "  不同字符串数: " + (this.totalStrings).toString() + "\n" + "  总内存使用: " + (this.totalMemory).toString() + " 字符\n" + "}";
}
  }
  
}

/// 转换后的类: $AC_CppStringBuffer
/// 原始类名: CppStringBuffer
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/string.dart

class $AC_CppStringBuffer {
  late $AA_CppList<CppUserData> _parts;
$AC_CppStringBuffer([Object content = ""]) : _parts = $AA_CppList<CppUserData>.from(<CppUserData>[$AC_CppStringBuffer._convertStringToUserData(content)] as $AD_CppIterable<dynamic?>), super()   {
    ;
  }
  
  void write(Object? obj) {
    {
  if (obj == null) return;
  this._parts.add($AC_CppStringBuffer._convertStringToUserData(obj));
}
  }
  
  void writeAll($AD_CppIterable<dynamic?> objects, [$AC_CppString? separator = null]) {
    {
  $AD_CppIterator<dynamic?> iterator = objects.iterator;
  if (iterator.moveNext()) {
  this._parts.add($AC_CppStringBuffer._convertStringToUserData((() { final dynamic? temp_3005 = iterator.current; return temp_3005 == null ? temp_3005 as Object : temp_3005; })()));
  while (iterator.moveNext()) {
  if (!(separator == null) && separator.isNotEmpty) {
  this._parts.add(separator._codeUnits);
}
  this._parts.add($AC_CppStringBuffer._convertStringToUserData((() { final dynamic? temp_3013 = iterator.current; return temp_3013 == null ? temp_3013 as Object : temp_3013; })()));
}
}
}
  }
  
  void writeCharCode(int charCode) {
    {
  this._parts.add($AC_CppStringBuffer._convertStringToUserData($AC_CppString.fromCharCode(charCode)));
}
  }
  
  void writeln([Object? obj = ""]) {
    {
  if (!(obj == null)) {
  this._parts.add($AC_CppStringBuffer._convertStringToUserData(obj));
}
  this._parts.add($AC_CppStringBuffer._convertStringToUserData($AC_CppString.fromCharCode(10)));
}
  }
  
  void clear() {
    {
  this._parts.clear();
}
  }
  
  $AC_CppString toCppString() {
    {
  $AA_CppList<int> codeUnits = $AA_CppList<int>.empty(growable: true);
  {
  $AD_CppIterator<CppUserData> _sync_for_iterator = this._parts.iterator;
  for (; _sync_for_iterator.moveNext(); ) {
  CppUserData part = _sync_for_iterator.current;
  int length = CppApi.cppGetByteArrayLength(part);
  for (int i = 0; (i < length); i = (i + 1)) {
  codeUnits.add(CppApi.cppGetByteArrayItem(part, i));
}
}
}
  return $AC_CppString.fromCodeUnits(codeUnits);
}
  }
  
  int get length {
    {
  int totalLength = 0;
  {
  $AD_CppIterator<CppUserData> _sync_for_iterator = this._parts.iterator;
  for (; _sync_for_iterator.moveNext(); ) {
  CppUserData part = _sync_for_iterator.current;
  totalLength = (totalLength + CppApi.cppGetByteArrayLength(part));
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
  if (obj is $AC_CppString) {
  return obj._codeUnits;
}
  return $AC_CppStringPool.instance.getOrCreateFromCodeUnits($AC_CppStringBuffer._convertStringToCodeUnits(obj.toString()));
}
  }
  
  static $AA_CppList<int> _convertStringToCodeUnits(String str) {
    {
  $AA_CppList<int> codeUnits = $AA_CppList<int>.empty(growable: true);
  for (int i = 0; (i < str.length); i = (i + 1)) {
  codeUnits.add(str.codeUnitAt(i));
}
  return codeUnits;
}
  }
  
}

/// 转换后的类: $AC_CppString
/// 原始类名: CppString
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/string.dart

class $AC_CppString extends $AE_CppObject implements Comparable<$AC_CppString> {
  static $AC_CppString Empty = const $AC_CppString($AC_CppString._codeUnits: const CppUserData(CppUserData.data: []));
  late CppUserData _codeUnits;
$AC_CppString.fromCppUserData(CppUserData userData) : _codeUnits = userData, super()   {
    ;
  }
  
$AC_CppString.fromCodeUnits($AA_CppList<int> codeUnits) : _codeUnits = $AC_CppStringPool.instance.getOrCreateFromCodeUnits(codeUnits), super()   {
    ;
  }
  
$AC_CppString.fromCharCode(int charCode) : _codeUnits = $AC_CppStringPool.instance.getOrCreateFromCodeUnits($AA_CppList<int>.filled(1, charCode)), super()   {
    ;
  }
  
$AC_CppString.fromCharCodes($AD_CppIterable<int> charCodes, [int start = 0, int? end = null]) : _codeUnits = $AC_CppStringPool.instance.getOrCreateFromCodeUnits(charCodes.skip(start).take(((end) ?? (charCodes.length) - start)).toList()), super()   {
    ;
  }
  
  String _toExternalString() {
    {
  $AA_CppList<int> codeUnits = $AA_CppList<int>.empty(growable: true);
  for (int i = 0; (i < this.length); i = (i + 1)) {
  codeUnits.add(CppApi.cppGetByteArrayItem(this._codeUnits, i));
}
  return String.fromCharCodes(codeUnits as Iterable<int>);
}
  }
  
  bool _equalCodeUnits($AC_CppString other) {
    {
  int thisLength = this.length;
  int otherLength = other.length;
  if (!(thisLength == otherLength)) return false;
  for (int i = 0; (i < thisLength); i = (i + 1)) {
  if (!(CppApi.cppGetByteArrayItem(this._codeUnits, i) == CppApi.cppGetByteArrayItem(other._codeUnits, i))) {
  return false;
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
  hash = (((hash * 31) + CppApi.cppGetByteArrayItem(this._codeUnits, i)) & 2147483647);
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
  
  $AA_CppList<int> get codeUnits {
    {
  int thisLength = this.length;
  $AA_CppList<int> units = $AA_CppList<int>.empty(growable: true);
  for (int i = 0; (i < thisLength); i = (i + 1)) {
  units.add(CppApi.cppGetByteArrayItem(this._codeUnits, i));
}
  return units;
}
  }
  
  Runes get runes {
    return this._toExternalString().runes;
  }
  
  int compareTo($AC_CppString other) {
    {
  int thisLength = this.length;
  int otherLength = other.length;
  int minLength = (thisLength < otherLength) ? thisLength : otherLength;
  for (int i = 0; (i < minLength); i = (i + 1)) {
  int thisCodeUnit = CppApi.cppGetByteArrayItem(this._codeUnits, i);
  int otherCodeUnit = CppApi.cppGetByteArrayItem(other._codeUnits, i);
  if (!(thisCodeUnit == otherCodeUnit)) {
  return (thisCodeUnit - otherCodeUnit);
}
}
  return (thisLength - otherLength);
}
  }
  
  bool startsWith($AC_CppString pattern, [int index = 0]) {
    {
  if ((index < 0) || (index >= this.length)) return false;
  if (((index + pattern.length) > this.length)) return false;
  for (int i = 0; (i < pattern.length); i = (i + 1)) {
  if (!(CppApi.cppGetByteArrayItem(this._codeUnits, (index + i)) == CppApi.cppGetByteArrayItem(pattern._codeUnits, i))) {
  return false;
}
}
  return true;
}
  }
  
  bool endsWith($AC_CppString other) {
    {
  if ((other.length > this.length)) return false;
  int startIndex = (this.length - other.length);
  for (int i = 0; (i < other.length); i = (i + 1)) {
  if (!(CppApi.cppGetByteArrayItem(this._codeUnits, (startIndex + i)) == CppApi.cppGetByteArrayItem(other._codeUnits, i))) {
  return false;
}
}
  return true;
}
  }
  
  int indexOf($AC_CppString pattern, [int start = 0]) {
    {
  if ((start < 0)) start = 0;
  if (pattern.isEmpty) return start;
  if (((start + pattern.length) > this.length)) return -1;
  for (int i = start; (i <= (this.length - pattern.length)); i = (i + 1)) {
  bool match = true;
  label: for (int j = 0; (j < pattern.length); j = (j + 1)) {
  if (!(CppApi.cppGetByteArrayItem(this._codeUnits, (i + j)) == CppApi.cppGetByteArrayItem(pattern._codeUnits, j))) {
  match = false;
  break;
}
}
  if (match) return i;
}
  return -1;
}
  }
  
  int lastIndexOf($AC_CppString pattern, [int? start = null]) {
    {
  if (pattern.isEmpty) return (start) ?? (this.length);
  start == null ? start = this.length : null;
  if ((start < 0)) return -1;
  if (((start + pattern.length) > this.length)) start = (this.length - pattern.length);
  for (int i = start; (i >= 0); i = (i - 1)) {
  bool match = true;
  label: for (int j = 0; (j < pattern.length); j = (j + 1)) {
  if (!(CppApi.cppGetByteArrayItem(this._codeUnits, (i + j)) == CppApi.cppGetByteArrayItem(pattern._codeUnits, j))) {
  match = false;
  break;
}
}
  if (match) return i;
}
  return -1;
}
  }
  
  bool contains($AC_CppString other, [int startIndex = 0]) {
    {
  return !(this.indexOf(other, startIndex) == -1);
}
  }
  
  $AC_CppString substring(int start, [int? end = null]) {
    {
  end == null ? end = this.length : null;
  if ((start < 0)) start = 0;
  if ((end > this.length)) end = this.length;
  if ((start >= end)) return const $AC_CppString($AC_CppString._codeUnits: const CppUserData(CppUserData.data: []));
  int newLength = (end - start);
  $AA_CppList<int> newCodeUnits = $AA_CppList<int>.empty(growable: true);
  for (int i = 0; (i < newLength); i = (i + 1)) {
  int codeUnit = CppApi.cppGetByteArrayItem(this._codeUnits, (start + i));
  newCodeUnits.add(codeUnit);
}
  return $AC_CppString.fromCodeUnits(newCodeUnits);
}
  }
  
  $AC_CppString trim() {
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
  
  $AC_CppString trimLeft() {
    {
  int start = 0;
  while ((start < this.length) && this._isWhitespace(CppApi.cppGetByteArrayItem(this._codeUnits, start))) {
  start = (start + 1);
}
  return this.substring(start);
}
  }
  
  $AC_CppString trimRight() {
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
  
  $AC_CppString padLeft(int width, [$AC_CppString? padding = null]) {
    {
  if ((width <= this.length)) return this;
  padding == null ? padding = $AC_CppString.fromCharCode(32) : null;
  int padLength = (width - this.length);
  int padCount = (padLength / padding.length).ceil();
  $AC_CppString padString = (padding * padCount);
  $AC_CppString actualPad = padString.substring(0, padLength);
  return (actualPad + this);
}
  }
  
  $AC_CppString padRight(int width, [$AC_CppString? padding = null]) {
    {
  if ((width <= this.length)) return this;
  padding == null ? padding = $AC_CppString.fromCharCode(32) : null;
  int padLength = (width - this.length);
  int padCount = (padLength / padding.length).ceil();
  $AC_CppString padString = (padding * padCount);
  $AC_CppString actualPad = padString.substring(0, padLength);
  return (this + actualPad);
}
  }
  
  $AC_CppString replaceFirst($AC_CppString from, $AC_CppString to, [int startIndex = 0]) {
    {
  int index = this.indexOf(from, startIndex);
  if (index == -1) return this;
  $AC_CppString beforePart = this.substring(0, index);
  $AC_CppString afterPart = this.substring((index + from.length));
  return ((beforePart + to) + afterPart);
}
  }
  
  $AC_CppString replaceAll($AC_CppString from, $AC_CppString replace) {
    {
  if (from.isEmpty) return this;
  $AA_CppList<$AC_CppString> parts = this.split(from);
  if (parts.length == 1) return this;
  $AA_CppList<$AC_CppString> result = $AA_CppList<$AC_CppString>.empty(growable: true);
  for (int i = 0; (i < parts.length); i = (i + 1)) {
  result.add(parts[i]);
  if ((i < (parts.length - 1))) {
  result.add(replace);
}
}
  return $AC_CppString.join(result as $AD_CppIterable<$AC_CppString>);
}
  }
  
  $AC_CppString replaceRange(int start, int? end, $AC_CppString replacement) {
    {
  end == null ? end = this.length : null;
  if ((start < 0)) start = 0;
  if ((end > this.length)) end = this.length;
  if ((start >= end)) return (this + replacement);
  $AC_CppString beforePart = this.substring(0, start);
  $AC_CppString afterPart = this.substring(end);
  return ((beforePart + replacement) + afterPart);
}
  }
  
  $AA_CppList<$AC_CppString> split($AC_CppString separator) {
    {
  if (separator.isEmpty) {
  $AA_CppList<$AC_CppString> result = $AA_CppList<$AC_CppString>.empty(growable: true);
  for (int i = 0; (i < this.length); i = (i + 1)) {
  result.add(this.substring(i, (i + 1)));
}
  return result;
}
  $AA_CppList<$AC_CppString> result = $AA_CppList<$AC_CppString>.empty(growable: true);
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
  
  $AC_CppString toLowerCase() {
    {
  $AA_CppList<int> resultCodeUnits = $AA_CppList<int>.empty(growable: true);
  for (int i = 0; (i < this.length); i = (i + 1)) {
  int codeUnit = CppApi.cppGetByteArrayItem(this._codeUnits, i);
  if ((codeUnit >= 65) && (codeUnit <= 90)) {
  codeUnit = (codeUnit + 32);
}
  resultCodeUnits.add(codeUnit);
}
  return $AC_CppString.fromCodeUnits(resultCodeUnits);
}
  }
  
  $AC_CppString toUpperCase() {
    {
  $AA_CppList<int> resultCodeUnits = $AA_CppList<int>.empty(growable: true);
  for (int i = 0; (i < this.length); i = (i + 1)) {
  int codeUnit = CppApi.cppGetByteArrayItem(this._codeUnits, i);
  if ((codeUnit >= 97) && (codeUnit <= 122)) {
  codeUnit = (codeUnit - 32);
}
  resultCodeUnits.add(codeUnit);
}
  return $AC_CppString.fromCodeUnits(resultCodeUnits);
}
  }
  
  $AD_CppIterable<$AC_CppStringMatch> allMatches($AC_CppString string, [int start = 0]) {
    {
  if ((start < 0) || (start > string.length)) {
  throw RangeError.range(start, 0, string.length, "start");
}
  return $AC__CppStringAllMatchesIterable(string, this, start);
}
  }
  
  $AC_CppStringMatch? matchAsPrefix($AC_CppString string, [int start = 0]) {
    {
  if ((start < 0) || (start > string.length)) {
  throw RangeError.range(start, 0, string.length);
}
  if (((start + this.length) > string.length)) return null;
  for (int i = 0; (i < this.length); i = (i + 1)) {
  if (!(CppApi.cppGetByteArrayItem(string._codeUnits, (start + i)) == CppApi.cppGetByteArrayItem(this._codeUnits, i))) {
  return null;
}
}
  return $AC_CppStringMatch(start, string, this);
}
  }
  
  $AC_CppString toCppString() {
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
  
  bool sharesDataWith($AC_CppString other) {
    {
  return identical(this._codeUnits, other._codeUnits);
}
  }
  
  int get dataHashCode {
    return this._codeUnits.hashCode;
  }
  
  static $AC_CppString fromString(String source) {
    {
  $AA_CppList<int> codeUnits = $AA_CppList<int>.empty(growable: true);
  for (int i = 0; (i < source.length); i = (i + 1)) {
  codeUnits.add(source.codeUnitAt(i));
}
  return $AC_CppString.fromCodeUnits(codeUnits);
}
  }
  
  static $AC_CppString join($AD_CppIterable<$AC_CppString> strings, [$AC_CppString? separator = null]) {
    {
  separator == null ? separator = const $AC_CppString($AC_CppString._codeUnits: const CppUserData(CppUserData.data: [])) : null;
  $AA_CppList<$AC_CppString> stringList = strings.toList();
  if (stringList.isEmpty) return const $AC_CppString($AC_CppString._codeUnits: const CppUserData(CppUserData.data: []));
  if (stringList.length == 1) return stringList[0];
  $AA_CppList<int> newCodeUnits = $AA_CppList<int>.empty(growable: true);
  for (int i = 0; (i < stringList.length); i = (i + 1)) {
  $AC_CppString str = stringList[i];
  for (int j = 0; (j < str.length); j = (j + 1)) {
  newCodeUnits.add(CppApi.cppGetByteArrayItem(str._codeUnits, j));
}
  if ((i < (stringList.length - 1))) {
  for (int j = 0; (j < separator.length); j = (j + 1)) {
  newCodeUnits.add(CppApi.cppGetByteArrayItem(separator._codeUnits, j));
}
}
}
  return $AC_CppString.fromCodeUnits(newCodeUnits);
}
  }
  
  $AC_CppString operator [](int index) {
    {
  int thisLength = this.length;
  if ((index < 0) || (index >= thisLength)) {
  throw IndexError(index, this, "index");
}
  int codeUnit = CppApi.cppGetByteArrayItem(this._codeUnits, index);
  return $AC_CppString.fromCharCode(codeUnit);
}
  }
  
  bool operator ==(Object other) {
    {
  if (identical(this, other)) return true;
  if (other is $AC_CppString) {
  return this._equalCodeUnits(other);
}
  return false;
}
  }
  
  $AC_CppString operator +($AC_CppString other) {
    {
  int thisLength = this.length;
  int otherLength = other.length;
  $AA_CppList<int> newCodeUnits = $AA_CppList<int>.empty(growable: true);
  ;
  for (int i = 0; (i < thisLength); i = (i + 1)) {
  newCodeUnits.add(CppApi.cppGetByteArrayItem(this._codeUnits, i));
}
  for (int i = 0; (i < otherLength); i = (i + 1)) {
  newCodeUnits.add(CppApi.cppGetByteArrayItem(other._codeUnits, i));
}
  return $AC_CppString.fromCodeUnits(newCodeUnits);
}
  }
  
  $AC_CppString operator *(int times) {
    {
  if ((times <= 0)) return const $AC_CppString($AC_CppString._codeUnits: const CppUserData(CppUserData.data: []));
  if (times == 1) return this;
  int thisLength = this.length;
  $AA_CppList<int> newCodeUnits = $AA_CppList<int>.empty(growable: true);
  for (int repeat = 0; (repeat < times); repeat = (repeat + 1)) {
  for (int i = 0; (i < thisLength); i = (i + 1)) {
  newCodeUnits.add(CppApi.cppGetByteArrayItem(this._codeUnits, i));
}
}
  return $AC_CppString.fromCodeUnits(newCodeUnits);
}
  }
  
}

/// 转换后的类: $AC_CppStringMatch
/// 原始类名: CppStringMatch
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/string.dart

class $AC_CppStringMatch {
  late int start;
  late $AC_CppString input;
  late $AC_CppString pattern;
$AC_CppStringMatch(int start, $AC_CppString input, $AC_CppString pattern) : start = start, input = input, pattern = pattern, super()   {
    ;
  }
  
  int get end {
    return (this.start + this.pattern.length);
  }
  
  $AC_CppString group(int group) {
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
  
  $AC_CppString operator [](int group) {
    return group == 0 ? this.pattern : throw RangeError.value(group);
  }
  
}

/// 转换后的类: $AC__CppStringAllMatchesIterable
/// 原始类名: _CppStringAllMatchesIterable
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/string.dart

class $AC__CppStringAllMatchesIterable extends $AD_CppIterable<$AC_CppStringMatch> {
  late $AC_CppString _input;
  late $AC_CppString _pattern;
  late int _index;
$AC__CppStringAllMatchesIterable($AC_CppString _input, $AC_CppString _pattern, int _index) : _input = _input, _pattern = _pattern, _index = _index, super()   {
    ;
  }
  
  $AD_CppIterator<$AC_CppStringMatch> get iterator {
    return $AC__CppStringAllMatchesIterator(this._input, this._pattern, this._index);
  }
  
  int get length {
    {
  int count = 0;
  $AD_CppIterator<$AC_CppStringMatch> it = this.iterator;
  while (it.moveNext()) {
  count = (count + 1);
}
  return count;
}
  }
  
  $AC_CppStringMatch get first {
    {
  int index = this._input.indexOf(this._pattern, this._index);
  if ((index >= 0)) {
  return $AC_CppStringMatch(index, this._input, this._pattern);
}
  throw StateError("No element");
}
  }
  
}

/// 转换后的类: $AC__CppStringAllMatchesIterator
/// 原始类名: _CppStringAllMatchesIterator
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/string.dart

class $AC__CppStringAllMatchesIterator extends $AE_CppObject implements $AD_CppIterator<$AC_CppStringMatch> {
  late int _index;
  $AC_CppStringMatch? _current = null;
  late $AC_CppString _input;
  late $AC_CppString _pattern;
$AC__CppStringAllMatchesIterator($AC_CppString _input, $AC_CppString _pattern, int _index) : _input = _input, _pattern = _pattern, _index = _index, super()   {
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
  this._current = $AC_CppStringMatch(index, this._input, this._pattern);
  this._index = end == this._index ? (end + 1) : end;
  return true;
}
  }
  
  $AC_CppStringMatch get current {
    return (() { final $AC_CppStringMatch? temp_3021 = this._current; return temp_3021 == null ? temp_3021 as $AC_CppStringMatch : temp_3021; })();
  }
  
}

/// 转换后的类: $AD_CppIterator
/// 原始类名: CppIterator
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/Iterable.dart

abstract class $AD_CppIterator<E> extends $AE_CppObject {
$AD_CppIterator() : super()   {
    ;
  }
  
  E get current;
  
  bool moveNext();
  
}

/// 转换后的类: $AD_CppIterable
/// 原始类名: CppIterable
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/Iterable.dart

abstract class $AD_CppIterable<E> extends $AE_CppObject {
$AD_CppIterable() : super()   {
    ;
  }
  
  $AD_CppIterator<E> get iterator;
  
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
  $AD_CppIterator<E> it = this.iterator;
  if (!(it.moveNext())) throw StateError("No element");
  return it.current;
}
  }
  
  E get last {
    {
  if (this.isEmpty) throw StateError("No element");
  $AD_CppIterator<E> it = this.iterator;
  E? result;
  while (it.moveNext()) {
  result = it.current;
}
  return (() { final E? temp_3029 = result; return temp_3029 == null ? temp_3029 as E : temp_3029; })();
}
  }
  
  E get single {
    {
  if (this.isEmpty) throw StateError("No element");
  $AD_CppIterator<E> it = this.iterator;
  it.moveNext();
  E result = it.current;
  if (it.moveNext()) throw StateError("Too many elements");
  return result;
}
  }
  
  E elementAt(int index) {
    {
  if ((index < 0)) throw ArgumentError("Index cannot be negative");
  $AD_CppIterator<E> it = this.iterator;
  for (int i = 0; (i <= index); i = (i + 1)) {
  if (!(it.moveNext())) throw IndexError(index, this);
  if (i == index) return it.current;
}
  throw IndexError(index, this);
}
  }
  
  bool contains(Object? element) {
    {
  $AD_CppIterator<E> it = this.iterator;
  while (it.moveNext()) {
  if (it.current == element) return true;
}
  return false;
}
  }
  
  void forEach(void Function(E) action) {
    {
  $AD_CppIterator<E> it = this.iterator;
  while (it.moveNext()) {
  action.call(it.current);
}
}
  }
  
  $AD_CppIterable<T> map<T>(T Function(E) toElement) {
    {
  return $AD_CppMappedIterable<E, T>(this, toElement);
}
  }
  
  $AD_CppIterable<E> where(bool Function(E) test) {
    {
  return $AD_CppWhereIterable<E>(this, test);
}
  }
  
  $AD_CppIterable<T> whereType<T>() {
    {
  return $AD_CppWhereTypeIterable<T>(this);
}
  }
  
  $AD_CppIterable<T> expand<T>($AD_CppIterable<T> Function(E) toElements) {
    {
  return $AD_CppExpandIterable<E, T>(this, toElements);
}
  }
  
  bool any(bool Function(E) test) {
    {
  $AD_CppIterator<E> it = this.iterator;
  while (it.moveNext()) {
  if (test.call(it.current)) return true;
}
  return false;
}
  }
  
  bool every(bool Function(E) test) {
    {
  $AD_CppIterator<E> it = this.iterator;
  while (it.moveNext()) {
  if (!(test.call(it.current))) return false;
}
  return true;
}
  }
  
  E firstWhere(bool Function(E) test, {E Function()? orElse = null}) {
    {
  $AD_CppIterator<E> it = this.iterator;
  while (it.moveNext()) {
  if (test.call(it.current)) return it.current;
}
  if (!(orElse == null)) return orElse.call();
  throw StateError("No element");
}
  }
  
  E lastWhere(bool Function(E) test, {E Function()? orElse = null}) {
    {
  $AD_CppIterator<E> it = this.iterator;
  E? result;
  bool found = false;
  while (it.moveNext()) {
  if (test.call(it.current)) {
  result = it.current;
  found = true;
}
}
  if (found) return (() { final E? temp_3037 = result; return temp_3037 == null ? temp_3037 as E : temp_3037; })();
  if (!(orElse == null)) return orElse.call();
  throw StateError("No element");
}
  }
  
  E singleWhere(bool Function(E) test, {E Function()? orElse = null}) {
    {
  $AD_CppIterator<E> it = this.iterator;
  E? result;
  bool found = false;
  while (it.moveNext()) {
  if (test.call(it.current)) {
  if (found) throw StateError("Too many elements");
  result = it.current;
  found = true;
}
}
  if (found) return (() { final E? temp_3045 = result; return temp_3045 == null ? temp_3045 as E : temp_3045; })();
  if (!(orElse == null)) return orElse.call();
  throw StateError("No element");
}
  }
  
  E reduce(E Function(E, E) combine) {
    {
  $AD_CppIterator<E> it = this.iterator;
  if (!(it.moveNext())) throw StateError("No element");
  E value = it.current;
  while (it.moveNext()) {
  value = combine.call(value, it.current);
}
  return value;
}
  }
  
  T fold<T>(T initialValue, T Function(T, E) combine) {
    {
  T value = initialValue;
  $AD_CppIterator<E> it = this.iterator;
  while (it.moveNext()) {
  value = combine.call(value, it.current);
}
  return value;
}
  }
  
  $AC_CppString join([$AC_CppString separator = const $AC_CppString($AC_CppString._codeUnits: const CppUserData(CppUserData.data: []))]) {
    {
  $AD_CppIterator<E> it = this.iterator;
  if (!(it.moveNext())) return const $AC_CppString($AC_CppString._codeUnits: const CppUserData(CppUserData.data: []));
  $AC_CppStringBuffer buffer = $AC_CppStringBuffer(it.current.toString());
  while (it.moveNext()) {
  buffer.write(separator);
  buffer.write(it.current.toString());
}
  return buffer.toCppString();
}
  }
  
  $AD_CppIterable<E> take(int count) {
    {
  return $AD_CppTakeIterable<E>(this, count);
}
  }
  
  $AD_CppIterable<E> takeWhile(bool Function(E) test) {
    {
  return $AD_CppTakeWhileIterable<E>(this, test);
}
  }
  
  $AD_CppIterable<E> skip(int count) {
    {
  return $AD_CppSkipIterable<E>(this, count);
}
  }
  
  $AD_CppIterable<E> skipWhile(bool Function(E) test) {
    {
  return $AD_CppSkipWhileIterable<E>(this, test);
}
  }
  
  $AD_CppIterable<E> get reversed {
    {
  return $AD_CppReversedIterable<E>(this);
}
  }
  
  $AD_CppIterable<E> followedBy($AD_CppIterable<E> other) {
    {
  return $AD_CppFollowedByIterable<E>(this, other);
}
  }
  
  $AA_CppList<E> toList({bool growable = true}) {
    {
  return $AA_CppList<E>.from(this as $AD_CppIterable<dynamic?>, growable: growable);
}
  }
  
  $AA_CppSet<E> toSet() {
    {
  return $AA_CppSet<E>.from(this);
}
  }
  
  $AD_CppIterable<T> cast<T>() {
    {
  return $AD_CppCastIterable<E, T>(this);
}
  }
  
  static $AD_CppIterable<E> empty<E>() {
    return $AD__CppEmptyIterable<E>();
  }
  
  static $AD_CppIterable<E> generate<E>(int count, E Function(int) generator) {
    {
  return $AD__CppGenerateIterable<E>(count, generator);
}
  }
  
  static $AD_CppIterable<E> unmodifiable<E>($AD_CppIterable<E> elements) {
    {
  return $AD__CppUnmodifiableIterable<E>(elements.toList());
}
  }
  
  static $AD_CppIterable<R> castFrom<S, R>($AD_CppIterable<S> source) {
    {
  return $AD__CppCastFromIterable<S, R>(source);
}
  }
  
}

/// 转换后的类: $AD_CppMappedIterable
/// 原始类名: CppMappedIterable
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/Iterable.dart

class $AD_CppMappedIterable<S, T> extends $AD_CppIterable<T> {
  late $AD_CppIterable<S> _source;
  late T Function(S) _f;
$AD_CppMappedIterable($AD_CppIterable<S> _source, T Function(S) _f) : _source = _source, _f = _f, super()   {
    ;
  }
  
  $AD_CppIterator<T> get iterator {
    return $AD_CppMappedIterator<S, T>(this._source.iterator, this._f);
  }
  
  int get length {
    return this._source.length;
  }
  
}

/// 转换后的类: $AD_CppMappedIterator
/// 原始类名: CppMappedIterator
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/Iterable.dart

class $AD_CppMappedIterator<S, T> extends $AD_CppIterator<T> {
  T? _current = null;
  late $AD_CppIterator<S> _iterator;
  late T Function(S) _f;
$AD_CppMappedIterator($AD_CppIterator<S> _iterator, T Function(S) _f) : _iterator = _iterator, _f = _f, super()   {
    ;
  }
  
  T get current {
    return (() { final T? temp_3053 = this._current; return temp_3053 == null ? temp_3053 as T : temp_3053; })();
  }
  
  bool moveNext() {
    {
  if (this._iterator.moveNext()) {
  this._current = (() { final S temp_6834_1490 = this._iterator.current; return this._f.call(temp_6834_1490); })();
  return true;
}
  return false;
}
  }
  
}

/// 转换后的类: $AD_CppWhereIterable
/// 原始类名: CppWhereIterable
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/Iterable.dart

class $AD_CppWhereIterable<E> extends $AD_CppIterable<E> {
  late $AD_CppIterable<E> _source;
  late bool Function(E) _test;
$AD_CppWhereIterable($AD_CppIterable<E> _source, bool Function(E) _test) : _source = _source, _test = _test, super()   {
    ;
  }
  
  $AD_CppIterator<E> get iterator {
    return $AD_CppWhereIterator<E>(this._source.iterator, this._test);
  }
  
  int get length {
    {
  int count = 0;
  $AD_CppIterator<E> it = this.iterator;
  while (it.moveNext()) {
  count = (count + 1);
}
  return count;
}
  }
  
}

/// 转换后的类: $AD_CppWhereIterator
/// 原始类名: CppWhereIterator
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/Iterable.dart

class $AD_CppWhereIterator<E> extends $AD_CppIterator<E> {
  late $AD_CppIterator<E> _iterator;
  late bool Function(E) _test;
$AD_CppWhereIterator($AD_CppIterator<E> _iterator, bool Function(E) _test) : _iterator = _iterator, _test = _test, super()   {
    ;
  }
  
  E get current {
    return this._iterator.current;
  }
  
  bool moveNext() {
    {
  while (this._iterator.moveNext()) {
  if ((() { final E temp_7642_1576 = this._iterator.current; return this._test.call(temp_7642_1576); })()) {
  return true;
}
}
  return false;
}
  }
  
}

/// 转换后的类: $AD_CppWhereTypeIterable
/// 原始类名: CppWhereTypeIterable
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/Iterable.dart

class $AD_CppWhereTypeIterable<T> extends $AD_CppIterable<T> {
  late $AD_CppIterable<dynamic?> _source;
$AD_CppWhereTypeIterable($AD_CppIterable<dynamic?> _source) : _source = _source, super()   {
    ;
  }
  
  $AD_CppIterator<T> get iterator {
    return $AD_CppWhereTypeIterator<T>(this._source.iterator);
  }
  
  int get length {
    {
  int count = 0;
  $AD_CppIterator<T> it = this.iterator;
  while (it.moveNext()) {
  count = (count + 1);
}
  return count;
}
  }
  
}

/// 转换后的类: $AD_CppWhereTypeIterator
/// 原始类名: CppWhereTypeIterator
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/Iterable.dart

class $AD_CppWhereTypeIterator<T> extends $AD_CppIterator<T> {
  late $AD_CppIterator<dynamic?> _iterator;
$AD_CppWhereTypeIterator($AD_CppIterator<dynamic?> _iterator) : _iterator = _iterator, super()   {
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

/// 转换后的类: $AD_CppExpandIterable
/// 原始类名: CppExpandIterable
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/Iterable.dart

class $AD_CppExpandIterable<S, T> extends $AD_CppIterable<T> {
  late $AD_CppIterable<S> _source;
  late $AD_CppIterable<T> Function(S) _f;
$AD_CppExpandIterable($AD_CppIterable<S> _source, $AD_CppIterable<T> Function(S) _f) : _source = _source, _f = _f, super()   {
    ;
  }
  
  $AD_CppIterator<T> get iterator {
    return $AD_CppExpandIterator<S, T>(this._source.iterator, this._f);
  }
  
  int get length {
    {
  int count = 0;
  $AD_CppIterator<T> it = this.iterator;
  while (it.moveNext()) {
  count = (count + 1);
}
  return count;
}
  }
  
}

/// 转换后的类: $AD_CppExpandIterator
/// 原始类名: CppExpandIterator
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/Iterable.dart

class $AD_CppExpandIterator<S, T> extends $AD_CppIterator<T> {
  $AD_CppIterator<T>? _currentIterator = null;
  late $AD_CppIterator<S> _iterator;
  late $AD_CppIterable<T> Function(S) _f;
$AD_CppExpandIterator($AD_CppIterator<S> _iterator, $AD_CppIterable<T> Function(S) _f) : _iterator = _iterator, _f = _f, super()   {
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
  this._currentIterator = (() { final S temp_9431_1757 = this._iterator.current; return this._f.call(temp_9431_1757); })().iterator;
}
}
  }
  
}

/// 转换后的类: $AD_CppTakeIterable
/// 原始类名: CppTakeIterable
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/Iterable.dart

class $AD_CppTakeIterable<E> extends $AD_CppIterable<E> {
  late $AD_CppIterable<E> _source;
  late int _count;
$AD_CppTakeIterable($AD_CppIterable<E> _source, int _count) : _source = _source, _count = _count, super()   {
    ;
  }
  
  $AD_CppIterator<E> get iterator {
    return $AD_CppTakeIterator<E>(this._source.iterator, this._count);
  }
  
  int get length {
    return min<int>(this._count, this._source.length);
  }
  
}

/// 转换后的类: $AD_CppTakeIterator
/// 原始类名: CppTakeIterator
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/Iterable.dart

class $AD_CppTakeIterator<E> extends $AD_CppIterator<E> {
  late int _remaining;
  late $AD_CppIterator<E> _iterator;
  late int _count;
$AD_CppTakeIterator($AD_CppIterator<E> _iterator, int _count) : _iterator = _iterator, _count = _count, _remaining = _count, super()   {
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

/// 转换后的类: $AD_CppTakeWhileIterable
/// 原始类名: CppTakeWhileIterable
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/Iterable.dart

class $AD_CppTakeWhileIterable<E> extends $AD_CppIterable<E> {
  late $AD_CppIterable<E> _source;
  late bool Function(E) _test;
$AD_CppTakeWhileIterable($AD_CppIterable<E> _source, bool Function(E) _test) : _source = _source, _test = _test, super()   {
    ;
  }
  
  $AD_CppIterator<E> get iterator {
    return $AD_CppTakeWhileIterator<E>(this._source.iterator, this._test);
  }
  
  int get length {
    {
  int count = 0;
  $AD_CppIterator<E> it = this.iterator;
  while (it.moveNext()) {
  count = (count + 1);
}
  return count;
}
  }
  
}

/// 转换后的类: $AD_CppTakeWhileIterator
/// 原始类名: CppTakeWhileIterator
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/Iterable.dart

class $AD_CppTakeWhileIterator<E> extends $AD_CppIterator<E> {
  bool _finished = false;
  late $AD_CppIterator<E> _iterator;
  late bool Function(E) _test;
$AD_CppTakeWhileIterator($AD_CppIterator<E> _iterator, bool Function(E) _test) : _iterator = _iterator, _test = _test, super()   {
    ;
  }
  
  E get current {
    return this._iterator.current;
  }
  
  bool moveNext() {
    {
  if (this._finished) return false;
  if (this._iterator.moveNext()) {
  if ((() { final E temp_11046_1938 = this._iterator.current; return this._test.call(temp_11046_1938); })()) {
  return true;
}
  this._finished = true;
}
  return false;
}
  }
  
}

/// 转换后的类: $AD_CppSkipIterable
/// 原始类名: CppSkipIterable
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/Iterable.dart

class $AD_CppSkipIterable<E> extends $AD_CppIterable<E> {
  late $AD_CppIterable<E> _source;
  late int _count;
$AD_CppSkipIterable($AD_CppIterable<E> _source, int _count) : _source = _source, _count = _count, super()   {
    ;
  }
  
  $AD_CppIterator<E> get iterator {
    return $AD_CppSkipIterator<E>(this._source.iterator, this._count);
  }
  
  int get length {
    return max<int>(0, (this._source.length - this._count));
  }
  
}

/// 转换后的类: $AD_CppSkipIterator
/// 原始类名: CppSkipIterator
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/Iterable.dart

class $AD_CppSkipIterator<E> extends $AD_CppIterator<E> {
  bool _skipped = false;
  late $AD_CppIterator<E> _iterator;
  late int _count;
$AD_CppSkipIterator($AD_CppIterator<E> _iterator, int _count) : _iterator = _iterator, _count = _count, super()   {
    ;
  }
  
  E get current {
    return this._iterator.current;
  }
  
  bool moveNext() {
    {
  if (!(this._skipped)) {
  for (int i = 0; (i < this._count); i = (i + 1)) {
  if (!(this._iterator.moveNext())) return false;
}
  this._skipped = true;
}
  return this._iterator.moveNext();
}
  }
  
}

/// 转换后的类: $AD_CppSkipWhileIterable
/// 原始类名: CppSkipWhileIterable
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/Iterable.dart

class $AD_CppSkipWhileIterable<E> extends $AD_CppIterable<E> {
  late $AD_CppIterable<E> _source;
  late bool Function(E) _test;
$AD_CppSkipWhileIterable($AD_CppIterable<E> _source, bool Function(E) _test) : _source = _source, _test = _test, super()   {
    ;
  }
  
  $AD_CppIterator<E> get iterator {
    return $AD_CppSkipWhileIterator<E>(this._source.iterator, this._test);
  }
  
  int get length {
    {
  int count = 0;
  $AD_CppIterator<E> it = this.iterator;
  while (it.moveNext()) {
  count = (count + 1);
}
  return count;
}
  }
  
}

/// 转换后的类: $AD_CppSkipWhileIterator
/// 原始类名: CppSkipWhileIterator
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/Iterable.dart

class $AD_CppSkipWhileIterator<E> extends $AD_CppIterator<E> {
  bool _skipped = false;
  late $AD_CppIterator<E> _iterator;
  late bool Function(E) _test;
$AD_CppSkipWhileIterator($AD_CppIterator<E> _iterator, bool Function(E) _test) : _iterator = _iterator, _test = _test, super()   {
    ;
  }
  
  E get current {
    return this._iterator.current;
  }
  
  bool moveNext() {
    {
  if (!(this._skipped)) {
  while (this._iterator.moveNext()) {
  if (!((() { final E temp_12756_2140 = this._iterator.current; return this._test.call(temp_12756_2140); })())) {
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

/// 转换后的类: $AD_CppReversedIterable
/// 原始类名: CppReversedIterable
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/Iterable.dart

class $AD_CppReversedIterable<E> extends $AD_CppIterable<E> {
  late $AD_CppIterable<E> _source;
$AD_CppReversedIterable($AD_CppIterable<E> _source) : _source = _source, super()   {
    ;
  }
  
  $AD_CppIterator<E> get iterator {
    return $AD_CppReversedIterator<E>(this._source);
  }
  
  int get length {
    return this._source.length;
  }
  
}

/// 转换后的类: $AD_CppReversedIterator
/// 原始类名: CppReversedIterator
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/Iterable.dart

class $AD_CppReversedIterator<E> extends $AD_CppIterator<E> {
  late int _index;
  late $AA_CppList<E> _elements;
$AD_CppReversedIterator($AD_CppIterable<E> source) : _elements = $AA_CppList<E>.from(source as $AD_CppIterable<dynamic?>), _index = source.length, super()   {
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

/// 转换后的类: $AD_CppFollowedByIterable
/// 原始类名: CppFollowedByIterable
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/Iterable.dart

class $AD_CppFollowedByIterable<E> extends $AD_CppIterable<E> {
  late $AD_CppIterable<E> _first;
  late $AD_CppIterable<E> _second;
$AD_CppFollowedByIterable($AD_CppIterable<E> _first, $AD_CppIterable<E> _second) : _first = _first, _second = _second, super()   {
    ;
  }
  
  $AD_CppIterator<E> get iterator {
    return $AD_CppFollowedByIterator<E>(this._first.iterator, this._second.iterator);
  }
  
  int get length {
    return (this._first.length + this._second.length);
  }
  
}

/// 转换后的类: $AD_CppFollowedByIterator
/// 原始类名: CppFollowedByIterator
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/Iterable.dart

class $AD_CppFollowedByIterator<E> extends $AD_CppIterator<E> {
  bool _usingFirst = true;
  late $AD_CppIterator<E> _first;
  late $AD_CppIterator<E> _second;
$AD_CppFollowedByIterator($AD_CppIterator<E> _first, $AD_CppIterator<E> _second) : _first = _first, _second = _second, super()   {
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

/// 转换后的类: $AD_CppCastIterable
/// 原始类名: CppCastIterable
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/Iterable.dart

class $AD_CppCastIterable<S, T> extends $AD_CppIterable<T> {
  late $AD_CppIterable<S> _source;
$AD_CppCastIterable($AD_CppIterable<S> _source) : _source = _source, super()   {
    ;
  }
  
  $AD_CppIterator<T> get iterator {
    return $AD_CppCastIterator<S, T>(this._source.iterator);
  }
  
  int get length {
    return this._source.length;
  }
  
}

/// 转换后的类: $AD_CppCastIterator
/// 原始类名: CppCastIterator
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/Iterable.dart

class $AD_CppCastIterator<S, T> extends $AD_CppIterator<T> {
  late $AD_CppIterator<S> _iterator;
$AD_CppCastIterator($AD_CppIterator<S> _iterator) : _iterator = _iterator, super()   {
    ;
  }
  
  T get current {
    return this._iterator.current as T;
  }
  
  bool moveNext() {
    return this._iterator.moveNext();
  }
  
}

/// 转换后的类: $AD__CppEmptyIterable
/// 原始类名: _CppEmptyIterable
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/Iterable.dart

class $AD__CppEmptyIterable<E> extends $AD_CppIterable<E> {
$AD__CppEmptyIterable() : super()   {
    ;
  }
  
  $AD_CppIterator<E> get iterator {
    return $AD__CppEmptyIterator<E>();
  }
  
  int get length {
    return 0;
  }
  
}

/// 转换后的类: $AD__CppEmptyIterator
/// 原始类名: _CppEmptyIterator
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/Iterable.dart

class $AD__CppEmptyIterator<E> extends $AD_CppIterator<E> {
$AD__CppEmptyIterator() : super()   {
    ;
  }
  
  E get current {
    throw StateError("No element");
  }
  
  bool moveNext() {
    return false;
  }
  
}

/// 转换后的类: $AD__CppGenerateIterable
/// 原始类名: _CppGenerateIterable
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/Iterable.dart

class $AD__CppGenerateIterable<E> extends $AD_CppIterable<E> {
  late int _count;
  late E Function(int) _generator;
$AD__CppGenerateIterable(int _count, E Function(int) _generator) : _count = _count, _generator = _generator, super()   {
    ;
  }
  
  $AD_CppIterator<E> get iterator {
    return $AD__CppGenerateIterator<E>(this._count, this._generator);
  }
  
  int get length {
    return this._count;
  }
  
}

/// 转换后的类: $AD__CppGenerateIterator
/// 原始类名: _CppGenerateIterator
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/Iterable.dart

class $AD__CppGenerateIterator<E> extends $AD_CppIterator<E> {
  int _index = 0;
  E? _current = null;
  late int _count;
  late E Function(int) _generator;
$AD__CppGenerateIterator(int _count, E Function(int) _generator) : _count = _count, _generator = _generator, super()   {
    ;
  }
  
  E get current {
    return (() { final E? temp_3061 = this._current; return temp_3061 == null ? temp_3061 as E : temp_3061; })();
  }
  
  bool moveNext() {
    {
  if ((this._index < this._count)) {
  this._current = (() { final int temp_16000_2447 = (() { final int temp_16000_2415 = this._index; return (() { final int temp_15994_2420 = this._index = (temp_16000_2415 + 1); return temp_16000_2415; })(); })(); return this._generator.call(temp_16000_2447); })();
  return true;
}
  return false;
}
  }
  
}

/// 转换后的类: $AD__CppUnmodifiableIterable
/// 原始类名: _CppUnmodifiableIterable
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/Iterable.dart

class $AD__CppUnmodifiableIterable<E> extends $AD_CppIterable<E> {
  late $AA_CppList<E> _elements;
$AD__CppUnmodifiableIterable($AA_CppList<E> _elements) : _elements = _elements, super()   {
    ;
  }
  
  $AD_CppIterator<E> get iterator {
    return this._elements.iterator;
  }
  
  int get length {
    return this._elements.length;
  }
  
}

/// 转换后的类: $AD__CppCastFromIterable
/// 原始类名: _CppCastFromIterable
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/Iterable.dart

class $AD__CppCastFromIterable<S, R> extends $AD_CppIterable<R> {
  late $AD_CppIterable<S> _source;
$AD__CppCastFromIterable($AD_CppIterable<S> _source) : _source = _source, super()   {
    ;
  }
  
  $AD_CppIterator<R> get iterator {
    return $AD__CppCastFromIterator<S, R>(this._source.iterator);
  }
  
  int get length {
    return this._source.length;
  }
  
}

/// 转换后的类: $AD__CppCastFromIterator
/// 原始类名: _CppCastFromIterator
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/Iterable.dart

class $AD__CppCastFromIterator<S, R> extends $AD_CppIterator<R> {
  late $AD_CppIterator<S> _iterator;
$AD__CppCastFromIterator($AD_CppIterator<S> _iterator) : _iterator = _iterator, super()   {
    ;
  }
  
  R get current {
    return this._iterator.current as R;
  }
  
  bool moveNext() {
    return this._iterator.moveNext();
  }
  
}

/// 转换后的类: $AE_CppObject
/// 原始类名: CppObject
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/object.dart

class $AE_CppObject {
$AE_CppObject() : super()   {
    ;
  }
  
  $AC_CppString toCppString() {
    {
  return const $AC_CppString($AC_CppString._codeUnits: const CppUserData(CppUserData.data: []));
}
  }
  
}

/// 全局函数和变量
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/hello.dart

void main() {
  {
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
  $AA_CppList<int> list = $AA_CppList<int>.filled(3, 0);
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
  $AA_CppList<int> iterableList = $AA_CppArrayList<int>.fromCppArray(CppApi.cppArrayConst(5, 1, 2, 3, 4, 5));
  assert(iterableList.first == 1);
  assert(iterableList.last == 5);
  assert(iterableList.length == 5);
  assert(iterableList.any(FunctionWrapper<bool Function(int)>([], (int element) { return (element > 3);}).call()));
  assert(!(iterableList.every(FunctionWrapper<bool Function(int)>([], (int element) { return (element < 3);}).call())));
  $AD_CppIterable<int> mappedList = iterableList.map(FunctionWrapper<int Function(int)>([], (int e) { return (e * 2);}).call());
  assert(mappedList.toList().toString() == <int>[2, 4, 6, 8, 10].toString());
  $AD_CppIterable<int> filteredList = iterableList.where(FunctionWrapper<bool Function(int)>([], (int e) { return (e % 2) == 0;}).call());
  assert(filteredList.toList().toString() == <int>[2, 4].toString());
  print("CppIterable 方法测试通过！");
  $AC_CppStringBuffer buffer = $AC_CppStringBuffer();
  buffer.write("Hello");
  buffer.write("World");
  print(buffer.toString());
  $AB_CppError error = $AB_CppError();
  error.toString();
  StringBuffer buffer2 = StringBuffer("xx");
  buffer2.write("Hello");
  buffer2.write("World");
  print(buffer2.toString());
  List<int> list = List<int>.generate(10, FunctionWrapper<int Function(int)>([], (int index) { return index;}).call());
  list.add(11);
  print(list.toString());
  BoxInt g1 = BoxInt(1);
  BoxInt g2 = BoxInt();
  g2.value = 5;
  Object? Function() ff = FunctionWrapper<Object? Function()>([g1, g2], () { {
  g1.value = (g1.value + 1);
  g2.value = (g2.value + 1);
  print(((g1.value.toString() + " ") + g2.value.toString()));
}}).call();
  ff.call();
  List<dynamic?> list2 = <dynamic?>[];
  for (int $origin_i = 0; ($origin_i < 10); $origin_i = ($origin_i + 1)) {
BoxInt i = BoxInt($origin_i);
list2.add(FunctionWrapper<Object? Function()>([i], () { {
  print(i);
}}).call());
$origin_i = i.value;
}
  list2.forEach(FunctionWrapper<void Function(dynamic?)>([], (dynamic? f) { return f.call();}).call());
  {
  List<dynamic?> list3 = <dynamic?>[];
  BoxInt i = BoxInt(0);
  for (i.value = 0; (i.value < 10); i.value = (i.value + 1)) {
  list3.add(FunctionWrapper<Object? Function()>([i], () { {
  print(i.value);
}}).call());
}
  list3.forEach(FunctionWrapper<void Function(dynamic?)>([], (dynamic? f) { return f.call();}).call());
}
  {
  List<dynamic?> list4 = <dynamic?>[];
  for (int $origin_i = 0; ($origin_i < 3); $origin_i = ($origin_i + 1)) {
BoxInt i = BoxInt($origin_i);
list4.add(FunctionWrapper<Object? Function()>([i], () { {
  print(i.value);
}}).call());
$origin_i = i.value;
}
  list4.forEach(FunctionWrapper<void Function(dynamic?)>([], (dynamic? f) { return f.call();}).call());
}
}
}

/// 全局函数和变量
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/api.dart

CppUserData cppUserDataEmpty = const CppUserData(CppUserData.data: []);

