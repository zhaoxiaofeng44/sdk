import 'dart:core';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'lib/demo/box.dart';
import 'lib/demo/function_wrapper.dart';

/// 全局Void类型变量，用于替代void返回值
final Void = null;

/// 文件编码映射注解
/// 用于标识不同源文件中的类，避免类名冲突
/// 格式: 编码 -> 源文件路径
///
/// AA -> /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/api.dart
/// AB -> /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/collection.dart
/// AC -> /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/error.dart
/// AD -> /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/string.dart
/// AE -> /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/Iterable.dart
/// AF -> /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/object.dart

/// 转换后的类: $AA_CppUserData
/// 原始类名: CppUserData
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/api.dart

class $AA_CppUserData {
  late List<dynamic?> data;
$AA_CppUserData() : data = <dynamic?>[], super()   {
    ;
  }
  
$AA_CppUserData.constant(List<dynamic?> data) : data = data, super()   {
    ;
  }
  
}

/// 转换后的类: $AA_CppApi
/// 原始类名: CppApi
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/api.dart

class $AA_CppApi {
$AA_CppApi() : super()   {
    ;
  }
  
  static $AA_CppUserData cppCreatePointerArray(int length) {
    {
  $AA_CppUserData userData = $AA_CppUserData();
  userData.data.length = length;
  return userData;
}
  }
  
  static int cppGetPointerArrayLength($AA_CppUserData array) {
    {
  return array.data.length;
}
  }
  
  static Object? cppGetPointerArrayItem($AA_CppUserData array, int index) {
    {
  return array.data[index];
}
  }
  
  static void cppSetPointerArrayItem($AA_CppUserData array, int index, Object? value) {
    {
  array.data[index] = value;
}
  }
  
  static $AA_CppUserData cppCreateByteArray(int length) {
    {
  return $AA_CppUserData.constant(_GrowableList.empty<dynamic?>());
}
  }
  
  static int cppGetByteArrayLength($AA_CppUserData array) {
    {
  return array.data.length;
}
  }
  
  static int cppGetByteArrayItem($AA_CppUserData array, int index) {
    {
  return array.data[index] as int;
}
  }
  
  static void cppSetByteArrayItem($AA_CppUserData array, int index, int value) {
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
  $AA_CppApi.print(object);
}
  }
  
  static $AA_CppUserData cppArrayConst(int length, [Object? v1 = null, Object? v2 = null, Object? v3 = null, Object? v4 = null, Object? v5 = null, Object? v6 = null, Object? v7 = null, Object? v8 = null, Object? v9 = null, Object? v10 = null]) {
    {
  return $AA_CppUserData.constant((() { final List<dynamic?> temp_1745_2947 = [v1, v2, v3, v4, v5, v6, v7, v8, v9, v10]; return (() {
temp_1745_2947.length = length;
return temp_1745_2947;
})(); })());
}
  }
  
}

/// 转换后的类: $AB_CppList
/// 原始类名: CppList
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/collection.dart

abstract class $AB_CppList<E> extends $AE_CppIterable<E> {
  $AB_CppList();
  
  factory $AB_CppList.empty({bool growable = false}) {
    {
  return $AB_CppArrayList<E>.empty(growable: growable);
}
  }
  
  factory $AB_CppList.filled(int length, E fill, {bool growable = false}) {
    {
  return $AB_CppArrayList<E>.filled(length, fill, growable: growable);
}
  }
  
  factory $AB_CppList.from($AE_CppIterable<dynamic?> elements, {bool growable = true}) {
    {
  return $AB_CppArrayList<E>.from(elements, growable: growable);
}
  }
  
  factory $AB_CppList.of($AE_CppIterable<E> elements, {bool growable = true}) {
    {
  return $AB_CppArrayList<E>.of(elements, growable: growable);
}
  }
  
  factory $AB_CppList.generate(int length, E Function(int) generator, {bool growable = true}) {
    {
  return $AB_CppArrayList<E>.generate(length, generator, growable: growable);
}
  }
  
  factory $AB_CppList.unmodifiable($AE_CppIterable<dynamic?> elements) {
    {
  return $AB_CppArrayList<E>.unmodifiable(elements);
}
  }
  
  int get length;
  
  set length(int newLen);
  
  void add(E value);
  
  void addAll($AE_CppIterable<E> iterable);
  
  bool any(bool Function(E) test);
  
  $AB_CppMap<int, E> asMap();
  
  $AE_CppIterable<R> cast<R>();
  
  void clear();
  
  bool contains(Object? element);
  
  E elementAt(int index);
  
  bool every(bool Function(E) test);
  
  void fillRange(int start, int end, [E? fillValue = null]);
  
  E firstWhere(bool Function(E) test, {E Function()? orElse = null});
  
  T fold<T>(T initialValue, T Function(T, E) combine);
  
  void forEach(void Function(E) action);
  
  $AE_CppIterable<E> getRange(int start, int end);
  
  int indexOf(E element, [int start = 0]);
  
  int indexWhere(bool Function(E) test, [int start = 0]);
  
  void insert(int index, E element);
  
  void insertAll(int index, $AE_CppIterable<E> iterable);
  
  E get first;
  
  set first(E value);
  
  E get last;
  
  set last(E value);
  
  E get single;
  
  bool get isEmpty;
  
  bool get isNotEmpty;
  
  $AE_CppIterator<E> get iterator;
  
  $AD_CppString join([$AD_CppString separator = ConstantExpression(const CppString{CppString._codeUnits: const CppUserData{CppUserData.data: const <dynamic>[]}})]);
  
  int lastIndexOf(E element, [int? start = null]);
  
  int lastIndexWhere(bool Function(E) test, [int? start = null]);
  
  E lastWhere(bool Function(E) test, {E Function()? orElse = null});
  
  E reduce(E Function(E, E) combine);
  
  bool remove(Object? value);
  
  E removeAt(int index);
  
  E removeLast();
  
  void removeRange(int start, int end);
  
  void removeWhere(bool Function(E) test);
  
  void replaceRange(int start, int end, $AE_CppIterable<E> replacements);
  
  void retainWhere(bool Function(E) test);
  
  void setAll(int index, $AE_CppIterable<E> iterable);
  
  void setRange(int start, int end, $AE_CppIterable<E> iterable, [int skipCount = 0]);
  
  void shuffle([Random? random = null]);
  
  void sort([int Function(E, E)? compare = null]);
  
  $AB_CppList<E> sublist(int start, [int? end = null]);
  
  $AB_CppList<E> toList({bool growable = true});
  
  $AB_CppSet<E> toSet();
  
  E singleWhere(bool Function(E) test, {E Function()? orElse = null});
  
  $AD_CppString toCppString();
  
  static $AB_CppList<R> castFrom<S, R>($AB_CppList<S> source) {
    {
  return $AB_CppArrayList.castFrom<S, R>(source);
}
  }
  
  static $AB_CppList<R> castFromWithFactory<S, R>($AB_CppList<S> source, $AB_CppList<R> Function() newList) {
    {
  return $AB_CppArrayList.castFromWithFactory<S, R>(source, newList);
}
  }
  
}

/// 转换后的类: $AB_CppArrayList
/// 原始类名: CppArrayList
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/collection.dart

class $AB_CppArrayList<E> extends $AE_CppIterable<E> implements $AB_CppList<E> {
  late int _length;
  late $AA_CppUserData _array;
$AB_CppArrayList.fromCppArray($AA_CppUserData array) : _length = $AA_CppApi.cppGetPointerArrayLength(array), _array = array, super()   {
    ;
  }
  
$AB_CppArrayList(int length, int capacity) : _length = length, _array = $AA_CppApi.cppCreatePointerArray(length), super()   {
    ;
  }
  
  factory $AB_CppArrayList.empty({bool growable = false}) {
    {
  return growable ? $AB_CppArrayList<E>(0, 0) : $AB_CppArrayList<E>(0, 0);
}
  }
  
  factory $AB_CppArrayList.filled(int length, E fill, {bool growable = false}) {
    {
  $AA_CppUserData array = $AA_CppApi.cppCreatePointerArray(length);
  for (int i = 0; (i < length); i = (i + 1)) {
  $AA_CppApi.cppSetPointerArrayItem(array, i, fill);
}
  return $AB_CppArrayList<E>.fromCppArray(array);
}
  }
  
  factory $AB_CppArrayList.from($AE_CppIterable<dynamic?> elements, {bool growable = true}) {
    {
  int length = elements.length;
  $AA_CppUserData array = growable ? $AA_CppApi.cppCreatePointerArray(length) : $AA_CppApi.cppCreatePointerArray($AB_CppArrayList._getSuggestCapacity(length));
  int i = 0;
  {
  $AE_CppIterator<dynamic?> _sync_for_iterator = elements.iterator;
  for (; _sync_for_iterator.moveNext(); ) {
  $AA_CppApi.cppSetPointerArrayItem(array, (() { final int temp_5417_3188 = i; return (() { final int temp_5417_3192 = i = (temp_5417_3188 + 1); return temp_5417_3188; })(); })(), _sync_for_iterator.current);
}
}
  return $AB_CppArrayList<E>.fromCppArray(array);
}
  }
  
  factory $AB_CppArrayList.of($AE_CppIterable<E> elements, {bool growable = true}) {
    return $AB_CppArrayList<E>.from(elements, growable: growable);
  }
  
  factory $AB_CppArrayList.generate(int length, E Function(int) generator, {bool growable = true}) {
    {
  $AA_CppUserData array = growable ? $AA_CppApi.cppCreatePointerArray(length) : $AA_CppApi.cppCreatePointerArray($AB_CppArrayList._getSuggestCapacity(length));
  for (int i = 0; (i < length); i = (i + 1)) {
  $AA_CppApi.cppSetPointerArrayItem(array, i, generator.call(i));
}
  return $AB_CppArrayList<E>.fromCppArray(array);
}
  }
  
  factory $AB_CppArrayList.unmodifiable($AE_CppIterable<dynamic?> elements) {
    {
  int length = elements.length;
  $AA_CppUserData array = $AA_CppApi.cppCreatePointerArray(length);
  int i = 0;
  {
  $AE_CppIterator<dynamic?> _sync_for_iterator = elements.iterator;
  for (; _sync_for_iterator.moveNext(); ) {
  $AA_CppApi.cppSetPointerArrayItem(array, (() { final int temp_6408_3292 = i; return (() { final int temp_6408_3296 = i = (temp_6408_3292 + 1); return temp_6408_3292; })(); })(), _sync_for_iterator.current as E);
}
}
  return $AB_CppArrayList<E>.fromCppArray(array);
}
  }
  
  int get length {
    return this._length;
  }
  
  void ensureCapacity(int newLen) {
    {
  if ((newLen > $AA_CppApi.cppGetPointerArrayLength(this._array))) {
  $AA_CppUserData newArray = $AA_CppApi.cppCreatePointerArray($AB_CppArrayList._getSuggestCapacity(newLen));
  for (int i = 0; (i < $AA_CppApi.cppGetPointerArrayLength(this._array)); i = (i + 1)) {
  $AA_CppApi.cppSetPointerArrayItem(newArray, i, $AA_CppApi.cppGetPointerArrayItem(this._array, i));
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
  $AA_CppApi.cppSetPointerArrayItem(this._array, (() { final int temp_7536_3451 = this._length; return (() { final int temp_7529_3456 = this._length = (temp_7536_3451 + 1); return temp_7536_3451; })(); })(), value);
}
  }
  
  void addAll($AE_CppIterable<E> iterable) {
    {
  {
  $AE_CppIterator<E> _sync_for_iterator = iterable.iterator;
  for (; _sync_for_iterator.moveNext(); ) {
  this.add(_sync_for_iterator.current);
}
}
}
  }
  
  bool any(bool Function(E) test) {
    {
  for (int i = 0; (i < this._length); i = (i + 1)) {
  if (test.call($AA_CppApi.cppGetPointerArrayItem(this._array, i) as E)) return true;
}
  return false;
}
  }
  
  $AB_CppMap<int, E> asMap() {
    {
  $AB_CppArrayMap<int, E> map = $AB_CppArrayMap<int, E>();
  for (int i = 0; (i < this._length); i = (i + 1)) {
  map[i] = $AA_CppApi.cppGetPointerArrayItem(this._array, i) as E;
}
  return map;
}
  }
  
  $AE_CppIterable<R> cast<R>() {
    {
  return $AB_CppArrayList.castFrom<E, R>(this) as $AE_CppIterable<R>;
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
  if ($AA_CppApi.cppGetPointerArrayItem(this._array, i) == element) return true;
}
  return false;
}
  }
  
  E elementAt(int index) {
    return $AA_CppApi.cppGetPointerArrayItem(this._array, index) as E;
  }
  
  bool every(bool Function(E) test) {
    {
  for (int i = 0; (i < this._length); i = (i + 1)) {
  if (!(test.call($AA_CppApi.cppGetPointerArrayItem(this._array, i) as E))) return false;
}
  return true;
}
  }
  
  void fillRange(int start, int end, [E? fillValue = null]) {
    {
  for (int i = start; (i < end); i = (i + 1)) {
  $AA_CppApi.cppSetPointerArrayItem(this._array, i, (() { final E? temp_3035 = fillValue; return temp_3035 == null ? temp_3035 as E : temp_3035; })());
}
}
  }
  
  E firstWhere(bool Function(E) test, {E Function()? orElse = null}) {
    {
  for (int i = 0; (i < this._length); i = (i + 1)) {
  if (test.call($AA_CppApi.cppGetPointerArrayItem(this._array, i) as E)) {
  return $AA_CppApi.cppGetPointerArrayItem(this._array, i) as E;
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
  value = combine.call(value, $AA_CppApi.cppGetPointerArrayItem(this._array, i) as E);
}
  return value;
}
  }
  
  void forEach(void Function(E) action) {
    {
  for (int i = 0; (i < this._length); i = (i + 1)) {
  action.call($AA_CppApi.cppGetPointerArrayItem(this._array, i) as E);
}
}
  }
  
  $AE_CppIterable<E> getRange(int start, int end) {
    {
  return $AB_CppArrayList<E>.from($AE_CppIterable.generate<dynamic?>((end - start), FunctionWrapper<Object? Function(int)>([], (int i) { return $AA_CppApi.cppGetPointerArrayItem(this._array, (start + i));}).call()));
}
  }
  
  int indexOf(E element, [int start = 0]) {
    {
  for (int i = start; (i < this._length); i = (i + 1)) {
  if ($AA_CppApi.cppGetPointerArrayItem(this._array, i) == element) return i;
}
  return -1;
}
  }
  
  int indexWhere(bool Function(E) test, [int start = 0]) {
    {
  for (int i = start; (i < this._length); i = (i + 1)) {
  if (test.call($AA_CppApi.cppGetPointerArrayItem(this._array, i) as E)) return i;
}
  return -1;
}
  }
  
  void insert(int index, E element) {
    {
  if ((index < 0) || (index > this._length)) throw IndexError(index, this);
  this.ensureCapacity((this._length + 1));
  for (int i = this._length; (i > index); i = (i - 1)) {
  $AA_CppApi.cppSetPointerArrayItem(this._array, i, $AA_CppApi.cppGetPointerArrayItem(this._array, (i - 1)));
}
  $AA_CppApi.cppSetPointerArrayItem(this._array, index, element);
  this._length = (this._length + 1);
}
  }
  
  void insertAll(int index, $AE_CppIterable<E> iterable) {
    {
  if ((index < 0) || (index > this._length)) throw IndexError(index, this);
  $AB_CppList<E> elements = iterable.toList();
  int insertLength = elements.length;
  if (insertLength == 0) return;
  this.ensureCapacity((this._length + insertLength));
  for (int i = (this._length - 1); (i >= index); i = (i - 1)) {
  $AA_CppApi.cppSetPointerArrayItem(this._array, (i + insertLength), $AA_CppApi.cppGetPointerArrayItem(this._array, i));
}
  for (int i = 0; (i < insertLength); i = (i + 1)) {
  $AA_CppApi.cppSetPointerArrayItem(this._array, (index + i), elements[i]);
}
  this._length = (this._length + insertLength);
}
  }
  
  E get first {
    {
  if (this._length == 0) throw StateError("No element");
  return $AA_CppApi.cppGetPointerArrayItem(this._array, 0) as E;
}
  }
  
  set first(E value) {
    {
  if (this._length == 0) throw StateError("No element");
  $AA_CppApi.cppSetPointerArrayItem(this._array, 0, value);
}
  }
  
  E get last {
    {
  if (this._length == 0) throw StateError("No element");
  return $AA_CppApi.cppGetPointerArrayItem(this._array, (this._length - 1)) as E;
}
  }
  
  set last(E value) {
    {
  if (this._length == 0) throw StateError("No element");
  $AA_CppApi.cppSetPointerArrayItem(this._array, (this._length - 1), value);
}
  }
  
  E get single {
    {
  if (this._length == 0) throw StateError("No element");
  if ((this._length > 1)) throw StateError("Too many elements");
  return $AA_CppApi.cppGetPointerArrayItem(this._array, 0) as E;
}
  }
  
  bool get isEmpty {
    return this._length == 0;
  }
  
  bool get isNotEmpty {
    return !(this._length == 0);
  }
  
  $AE_CppIterator<E> get iterator {
    return $AB__CppListIterator<E>(this);
  }
  
  int lastIndexOf(E element, [int? start = null]) {
    {
  int startIndex = (start) ?? ((this._length - 1));
  for (int i = startIndex; (i >= 0); i = (i - 1)) {
  if ($AA_CppApi.cppGetPointerArrayItem(this._array, i) == element) return i;
}
  return -1;
}
  }
  
  int lastIndexWhere(bool Function(E) test, [int? start = null]) {
    {
  int startIndex = (start) ?? ((this._length - 1));
  for (int i = startIndex; (i >= 0); i = (i - 1)) {
  if (test.call($AA_CppApi.cppGetPointerArrayItem(this._array, i) as E)) return i;
}
  return -1;
}
  }
  
  E lastWhere(bool Function(E) test, {E Function()? orElse = null}) {
    {
  for (int i = (this._length - 1); (i >= 0); i = (i - 1)) {
  if (test.call($AA_CppApi.cppGetPointerArrayItem(this._array, i) as E)) {
  return $AA_CppApi.cppGetPointerArrayItem(this._array, i) as E;
}
}
  if (!(orElse == null)) return orElse.call();
  throw StateError("No element");
}
  }
  
  E reduce(E Function(E, E) combine) {
    {
  if (this._length == 0) throw StateError("No element");
  E value = $AA_CppApi.cppGetPointerArrayItem(this._array, 0) as E;
  for (int i = 1; (i < this._length); i = (i + 1)) {
  value = combine.call(value, $AA_CppApi.cppGetPointerArrayItem(this._array, i) as E);
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
  Object? element = $AA_CppApi.cppGetPointerArrayItem(this._array, index);
  for (int i = index; (i < (this._length - 1)); i = (i + 1)) {
  $AA_CppApi.cppSetPointerArrayItem(this._array, i, $AA_CppApi.cppGetPointerArrayItem(this._array, (i + 1)));
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
  $AA_CppApi.cppSetPointerArrayItem(this._array, i, $AA_CppApi.cppGetPointerArrayItem(this._array, (i + length)));
}
  this._length = (this._length - length);
}
  }
  
  void removeWhere(bool Function(E) test) {
    {
  int writeIndex = 0;
  for (int readIndex = 0; (readIndex < this._length); readIndex = (readIndex + 1)) {
  if (!(test.call($AA_CppApi.cppGetPointerArrayItem(this._array, readIndex) as E))) {
  if (!(writeIndex == readIndex)) {
  $AA_CppApi.cppSetPointerArrayItem(this._array, writeIndex, $AA_CppApi.cppGetPointerArrayItem(this._array, readIndex));
}
  writeIndex = (writeIndex + 1);
}
}
  this._length = writeIndex;
}
  }
  
  void replaceRange(int start, int end, $AE_CppIterable<E> replacements) {
    {
  if ((start < 0) || (start > this._length) || (end < start) || (end > this._length)) {
  throw RangeError.range(start, 0, this._length);
}
  $AB_CppList<E> replacementList = replacements.toList();
  int replacementLength = replacementList.length;
  int rangeLength = (end - start);
  if ((replacementLength > rangeLength)) {
  this.ensureCapacity(((this._length + replacementLength) - rangeLength));
}
  if (!(replacementLength == rangeLength)) {
  for (int i = (this._length - 1); (i >= end); i = (i - 1)) {
  $AA_CppApi.cppSetPointerArrayItem(this._array, ((i + replacementLength) - rangeLength), $AA_CppApi.cppGetPointerArrayItem(this._array, i));
}
}
  for (int i = 0; (i < replacementLength); i = (i + 1)) {
  $AA_CppApi.cppSetPointerArrayItem(this._array, (start + i), replacementList[i]);
}
  this._length = (this._length + (replacementLength - rangeLength));
}
  }
  
  void retainWhere(bool Function(E) test) {
    {
  int writeIndex = 0;
  for (int readIndex = 0; (readIndex < this._length); readIndex = (readIndex + 1)) {
  if (test.call($AA_CppApi.cppGetPointerArrayItem(this._array, readIndex) as E)) {
  if (!(writeIndex == readIndex)) {
  $AA_CppApi.cppSetPointerArrayItem(this._array, writeIndex, $AA_CppApi.cppGetPointerArrayItem(this._array, readIndex));
}
  writeIndex = (writeIndex + 1);
}
}
  this._length = writeIndex;
}
  }
  
  void setAll(int index, $AE_CppIterable<E> iterable) {
    {
  if ((index < 0) || (index > this._length)) throw IndexError(index, this);
  int i = index;
  {
  $AE_CppIterator<E> _sync_for_iterator = iterable.iterator;
  for (; _sync_for_iterator.moveNext(); ) {
  E element = _sync_for_iterator.current;
  if ((i >= this._length)) {
  this.add(element);
} else {
  $AA_CppApi.cppSetPointerArrayItem(this._array, i, element);
}
  i = (i + 1);
}
}
}
  }
  
  void setRange(int start, int end, $AE_CppIterable<E> iterable, [int skipCount = 0]) {
    {
  if ((start < 0) || (start > this._length) || (end < start) || (end > this._length)) {
  throw RangeError.range(start, 0, this._length);
}
  $AE_CppIterator<E> iterator = iterable.iterator;
  for (int i = 0; (i < skipCount); i = (i + 1)) {
  if (!(iterator.moveNext())) return;
}
  label: for (int i = start; (i < end); i = (i + 1)) {
  if (!(iterator.moveNext())) break;
  $AA_CppApi.cppSetPointerArrayItem(this._array, i, iterator.current);
}
}
  }
  
  void shuffle([Random? random = null]) {
    {
  random == null ? random = Random() : null;
  for (int i = (this._length - 1); (i > 0); i = (i - 1)) {
  int j = random.nextInt((i + 1));
  Object? temp = $AA_CppApi.cppGetPointerArrayItem(this._array, i);
  $AA_CppApi.cppSetPointerArrayItem(this._array, i, $AA_CppApi.cppGetPointerArrayItem(this._array, j));
  $AA_CppApi.cppSetPointerArrayItem(this._array, j, temp);
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
  E pivot = $AA_CppApi.cppGetPointerArrayItem(this._array, high) as E;
  int i = (low - 1);
  for (int j = low; (j < high); j = (j + 1)) {
  E current = $AA_CppApi.cppGetPointerArrayItem(this._array, j) as E;
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
  E temp = $AA_CppApi.cppGetPointerArrayItem(this._array, i) as E;
  $AA_CppApi.cppSetPointerArrayItem(this._array, i, $AA_CppApi.cppGetPointerArrayItem(this._array, j));
  $AA_CppApi.cppSetPointerArrayItem(this._array, j, temp);
}
  }
  
  $AB_CppList<E> sublist(int start, [int? end = null]) {
    {
  int endIndex = (end) ?? (this._length);
  if ((start < 0) || (start > this._length) || (endIndex < start) || (endIndex > this._length)) {
  throw RangeError.range(start, 0, this._length);
}
  return $AB_CppArrayList<E>.from($AE_CppIterable.generate<dynamic?>((endIndex - start), FunctionWrapper<Object? Function(int)>([], (int i) { return $AA_CppApi.cppGetPointerArrayItem(this._array, (start + i));}).call()));
}
  }
  
  $AB_CppList<E> toList({bool growable = true}) {
    {
  return $AB_CppArrayList<E>.from(this as $AE_CppIterable<dynamic?>, growable: growable);
}
  }
  
  $AB_CppSet<E> toSet() {
    {
  return $AB_CppArraySet<E>.from(this);
}
  }
  
  E singleWhere(bool Function(E) test, {E Function()? orElse = null}) {
    {
  E? result;
  bool found = false;
  for (int i = 0; (i < this._length); i = (i + 1)) {
  if (test.call($AA_CppApi.cppGetPointerArrayItem(this._array, i) as E)) {
  if (found) throw StateError("Too many elements");
  result = $AA_CppApi.cppGetPointerArrayItem(this._array, i) as E;
  found = true;
}
}
  if (found) return result!;
  if (!(orElse == null)) return orElse.call();
  throw StateError("No element");
}
  }
  
  $AD_CppString toCppString() {
    {
  if (this._length == 0) return $AD_CppString.fromString("[]");
  $AD_CppStringBuffer buffer = $AD_CppStringBuffer("[");
  buffer.write($AA_CppApi.cppGetPointerArrayItem(this._array, 0));
  for (int i = 1; (i < this._length); i = (i + 1)) {
  buffer.write(", ");
  buffer.write($AA_CppApi.cppGetPointerArrayItem(this._array, i));
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
  
  static $AB_CppList<R> castFrom<S, R>($AB_CppList<S> source) {
    {
  $AB_CppArrayList<R> result = $AB_CppArrayList<R>(0, 4);
  {
  $AE_CppIterator<S> _sync_for_iterator = source.iterator;
  for (; _sync_for_iterator.moveNext(); ) {
  result.add(_sync_for_iterator.current as R);
}
}
  return result;
}
  }
  
  static $AB_CppList<R> castFromWithFactory<S, R>($AB_CppList<S> source, $AB_CppList<R> Function() newList) {
    {
  $AB_CppList<R> result = newList.call();
  {
  $AE_CppIterator<S> _sync_for_iterator = source.iterator;
  for (; _sync_for_iterator.moveNext(); ) {
  result.add(_sync_for_iterator.current as R);
}
}
  return result;
}
  }
  
  E operator [](int index) {
    return $AA_CppApi.cppGetPointerArrayItem(this._array, index) as E;
  }
  
  void operator []=(int index, E value) {
    $AA_CppApi.cppSetPointerArrayItem(this._array, index, value);
  }
  
  $AB_CppList<E> operator +($AB_CppList<E> other) {
    {
  $AB_CppArrayList<E> result = $AB_CppArrayList<E>(0, (this._length + other.length));
  for (int i = 0; (i < this._length); i = (i + 1)) {
  result.add($AA_CppApi.cppGetPointerArrayItem(this._array, i) as E);
}
  {
  $AE_CppIterator<E> _sync_for_iterator = other.iterator;
  for (; _sync_for_iterator.moveNext(); ) {
  result.add(_sync_for_iterator.current);
}
}
  return result;
}
  }
  
}

/// 转换后的类: $AB__CppListIterator
/// 原始类名: _CppListIterator
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/collection.dart

class $AB__CppListIterator<E> extends $AF_CppObject implements $AE_CppIterator<E> {
  int _index = -1;
  late $AB_CppArrayList<E> _list;
$AB__CppListIterator($AB_CppArrayList<E> _list) : _list = _list, super()   {
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

/// 转换后的类: $AB_CppSet
/// 原始类名: CppSet
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/collection.dart

abstract class $AB_CppSet<E> extends $AF_CppObject {
  $AB_CppSet();
  
  factory $AB_CppSet.identity() {
    return $AB_CppArraySet<E>.identity();
  }
  
  factory $AB_CppSet.from($AE_CppIterable<dynamic?> elements) {
    {
  return $AB_CppArraySet<E>.from(elements);
}
  }
  
  factory $AB_CppSet.of($AE_CppIterable<E> elements) {
    return $AB_CppArraySet<E>.of(elements);
  }
  
  factory $AB_CppSet.unmodifiable($AE_CppIterable<E> elements) {
    {
  return $AB_CppArraySet<E>.unmodifiable(elements);
}
  }
  
  bool add(E value);
  
  void addAll($AE_CppIterable<E> elements);
  
  $AE_CppIterable<R> cast<R>();
  
  void clear();
  
  bool contains(Object? element);
  
  bool containsAll($AE_CppIterable<Object?> other);
  
  $AB_CppSet<E> difference($AB_CppSet<Object?> other);
  
  E elementAt(int index);
  
  $AB_CppSet<E> intersection($AB_CppSet<Object?> other);
  
  E get first;
  
  E get last;
  
  E get single;
  
  bool get isEmpty;
  
  bool get isNotEmpty;
  
  $AE_CppIterator<E> get iterator;
  
  int get length;
  
  E? lookup(Object? element);
  
  bool remove(Object? value);
  
  void removeAll($AE_CppIterable<Object?> elementsToRemove);
  
  void removeWhere(bool Function(E) test);
  
  void retainAll($AE_CppIterable<Object?> elementsToRetain);
  
  void retainWhere(bool Function(E) test);
  
  $AB_CppSet<E> union($AB_CppSet<E> other);
  
  $AD_CppString toCppString();
  
  static $AB_CppSet<R> castFrom<S, R>($AB_CppSet<S> source) {
    {
  return $AB_CppArraySet.castFrom<S, R>(source);
}
  }
  
  static $AB_CppSet<R> castFromWithFactory<S, R>($AB_CppSet<S> source, $AB_CppSet<R> Function() newSet) {
    {
  return $AB_CppArraySet.castFromWithFactory<S, R>(source, newSet);
}
  }
  
}

/// 转换后的类: $AB_CppArraySet
/// 原始类名: CppArraySet
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/collection.dart

class $AB_CppArraySet<E> extends $AE_CppIterable<E> implements $AB_CppSet<E> {
  late $AB_CppArrayList<E> _list;
$AB_CppArraySet.fromCppArray($AA_CppUserData array) : _list = $AB_CppArrayList<E>.fromCppArray(array), super()   {
    ;
  }
  
$AB_CppArraySet([int capacity = 4]) : _list = $AB_CppArrayList<E>(0, capacity), super()   {
    ;
  }
  
  factory $AB_CppArraySet.identity() {
    return $AB_CppArraySet<E>(4);
  }
  
  factory $AB_CppArraySet.from($AE_CppIterable<dynamic?> elements) {
    {
  $AB_CppArraySet<E> set = $AB_CppArraySet<E>();
  {
  $AE_CppIterator<dynamic?> _sync_for_iterator = elements.iterator;
  for (; _sync_for_iterator.moveNext(); ) {
  set.add(_sync_for_iterator.current as E);
}
}
  return set;
}
  }
  
  factory $AB_CppArraySet.of($AE_CppIterable<E> elements) {
    return $AB_CppArraySet<E>.from(elements);
  }
  
  factory $AB_CppArraySet.unmodifiable($AE_CppIterable<E> elements) {
    {
  $AB_CppArraySet<E> set = $AB_CppArraySet<E>();
  {
  $AE_CppIterator<E> _sync_for_iterator = elements.iterator;
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
  
  void addAll($AE_CppIterable<E> elements) {
    {
  {
  $AE_CppIterator<E> _sync_for_iterator = elements.iterator;
  for (; _sync_for_iterator.moveNext(); ) {
  this.add(_sync_for_iterator.current);
}
}
}
  }
  
  $AE_CppIterable<R> cast<R>() {
    {
  return $AB_CppSet.castFrom<E, R>(this) as $AE_CppIterable<R>;
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
  
  bool containsAll($AE_CppIterable<Object?> other) {
    {
  {
  $AE_CppIterator<Object?> _sync_for_iterator = other.iterator;
  for (; _sync_for_iterator.moveNext(); ) {
  if (!(this.contains(_sync_for_iterator.current))) return false;
}
}
  return true;
}
  }
  
  $AB_CppSet<E> difference($AB_CppSet<Object?> other) {
    {
  $AB_CppArraySet<E> result = $AB_CppArraySet<E>();
  {
  $AE_CppIterator<E> _sync_for_iterator = this._list.iterator;
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
  
  $AB_CppSet<E> intersection($AB_CppSet<Object?> other) {
    {
  $AB_CppArraySet<E> result = $AB_CppArraySet<E>();
  {
  $AE_CppIterator<E> _sync_for_iterator = this._list.iterator;
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
  
  $AE_CppIterator<E> get iterator {
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
  
  void removeAll($AE_CppIterable<Object?> elementsToRemove) {
    {
  {
  $AE_CppIterator<Object?> _sync_for_iterator = elementsToRemove.iterator;
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
  
  void retainAll($AE_CppIterable<Object?> elementsToRetain) {
    {
  $AB_CppSet<dynamic?> retainSet = $AB_CppSet<dynamic?>.from(elementsToRetain);
  this.removeWhere(FunctionWrapper<bool Function(E)>([], (E element) { return !(retainSet.contains(element));}).call());
}
  }
  
  void retainWhere(bool Function(E) test) {
    {
  this._list.retainWhere(test);
}
  }
  
  $AB_CppSet<E> union($AB_CppSet<E> other) {
    {
  $AB_CppArraySet<E> result = $AB_CppArraySet<E>();
  result.addAll(this as $AE_CppIterable<E>);
  result.addAll(other as $AE_CppIterable<E>);
  return result;
}
  }
  
  $AD_CppString toCppString() {
    {
  if (this._list.isEmpty) return $AD_CppString.fromString("{}");
  $AD_CppStringBuffer buffer = $AD_CppStringBuffer("{");
  $AE_CppIterator<E> iterator = this._list.iterator;
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
  
  static $AB_CppSet<R> castFrom<S, R>($AB_CppSet<S> source) {
    {
  $AB_CppArraySet<R> result = $AB_CppArraySet<R>();
  {
  $AE_CppIterator<S> _sync_for_iterator = source.iterator;
  for (; _sync_for_iterator.moveNext(); ) {
  result.add(_sync_for_iterator.current as R);
}
}
  return result;
}
  }
  
  static $AB_CppSet<R> castFromWithFactory<S, R>($AB_CppSet<S> source, $AB_CppSet<R> Function() newSet) {
    {
  $AB_CppSet<R> result = newSet.call();
  {
  $AE_CppIterator<S> _sync_for_iterator = source.iterator;
  for (; _sync_for_iterator.moveNext(); ) {
  result.add(_sync_for_iterator.current as R);
}
}
  return result;
}
  }
  
}

/// 转换后的类: $AB_CppMapEntry
/// 原始类名: CppMapEntry
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/collection.dart

class $AB_CppMapEntry<K, V> extends $AF_CppObject {
  late K key;
  late V value;
$AB_CppMapEntry(K key, V value) : key = key, value = value, super()   {
    ;
  }
  
}

/// 转换后的类: $AB_CppMap
/// 原始类名: CppMap
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/collection.dart

abstract class $AB_CppMap<K, V> extends $AF_CppObject {
  $AB_CppMap();
  
  factory $AB_CppMap.identity() {
    return $AB_CppArrayMap<K, V>.identity();
  }
  
  factory $AB_CppMap.from($AB_CppMap<dynamic?, dynamic?> other) {
    return $AB_CppArrayMap<K, V>.from(other);
  }
  
  factory $AB_CppMap.of($AB_CppMap<K, V> other) {
    return $AB_CppArrayMap<K, V>.of(other);
  }
  
  factory $AB_CppMap.unmodifiable($AB_CppMap<dynamic?, dynamic?> other) {
    {
  return $AB_CppArrayMap<K, V>.unmodifiable(other);
}
  }
  
  factory $AB_CppMap.fromIterable($AE_CppIterable<dynamic?> iterable, {K Function(dynamic?)? key = null, V Function(dynamic?)? value = null}) {
    {
  return $AB_CppArrayMap<K, V>.fromIterable(iterable, key: key, value: value);
}
  }
  
  factory $AB_CppMap.fromIterables($AE_CppIterable<K> keys, $AE_CppIterable<V> values) {
    {
  return $AB_CppArrayMap<K, V>.fromIterables(keys, values);
}
  }
  
  factory $AB_CppMap.fromEntries($AE_CppIterable<MapEntry<K, V>> entries) {
    {
  return $AB_CppArrayMap<K, V>.fromEntries(entries);
}
  }
  
  void addAll($AB_CppMap<K, V> other);
  
  void addEntries($AE_CppIterable<MapEntry<K, V>> entries);
  
  $AB_CppMap<RK, RV> cast<RK, RV>();
  
  void clear();
  
  bool containsKey(Object? key);
  
  bool containsValue(Object? value);
  
  $AE_CppIterable<MapEntry<K, V>> get entries;
  
  void forEach(void Function(K, V) action);
  
  bool get isEmpty;
  
  bool get isNotEmpty;
  
  $AE_CppIterable<K> get keys;
  
  int get length;
  
  V putIfAbsent(K key, V Function() ifAbsent);
  
  V? remove(Object? key);
  
  void removeWhere(bool Function(K, V) test);
  
  V update(K key, V Function(V) update, {V Function()? ifAbsent = null});
  
  void updateAll(V Function(K, V) update);
  
  $AE_CppIterable<V> get values;
  
  $AB_CppMap<K2, V2> map<K2, V2>(MapEntry<K2, V2> Function(K, V) transform);
  
  $AD_CppString toCppString();
  
  static $AB_CppMap<RK, RV> castFrom<K, V, RK, RV>($AB_CppMap<K, V> source) {
    {
  return $AB_CppArrayMap.castFrom<K, V, RK, RV>(source);
}
  }
  
  static $AB_CppMap<RK, RV> castFromWithFactory<K, V, RK, RV>($AB_CppMap<K, V> source, $AB_CppMap<RK, RV> Function() newMap) {
    {
  return $AB_CppArrayMap.castFromWithFactory<K, V, RK, RV>(source, newMap);
}
  }
  
}

/// 转换后的类: $AB_CppArrayMap
/// 原始类名: CppArrayMap
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/collection.dart

class $AB_CppArrayMap<K, V> extends $AF_CppObject implements $AB_CppMap<K, V> {
  late $AB_CppArrayList<MapEntry<K, V>> _list;
$AB_CppArrayMap.fromCppArray($AA_CppUserData array) : _list = $AB_CppArrayList<MapEntry<K, V>>.fromCppArray(array), super()   {
    ;
  }
  
$AB_CppArrayMap([int capacity = 4]) : _list = $AB_CppArrayList<MapEntry<K, V>>(0, capacity), super()   {
    ;
  }
  
  factory $AB_CppArrayMap.identity() {
    return $AB_CppArrayMap<K, V>();
  }
  
  factory $AB_CppArrayMap.from($AB_CppMap<dynamic?, dynamic?> other) {
    return $AB_CppArrayMap<K, V>.unmodifiable(other);
  }
  
  factory $AB_CppArrayMap.of($AB_CppMap<K, V> other) {
    return $AB_CppArrayMap<K, V>.fromEntries(other.entries);
  }
  
  factory $AB_CppArrayMap.unmodifiable($AB_CppMap<dynamic?, dynamic?> other) {
    {
  $AB_CppArrayMap<K, V> map = $AB_CppArrayMap<K, V>();
  other.forEach(FunctionWrapper<void Function(dynamic?, dynamic?)>([], (dynamic? key, dynamic? value) { {
  map[key as K] = value as V;
}}).call());
  return map;
}
  }
  
  factory $AB_CppArrayMap.fromIterable($AE_CppIterable<dynamic?> iterable, {K Function(dynamic?)? key = null, V Function(dynamic?)? value = null}) {
    {
  $AB_CppArrayMap<K, V> map = $AB_CppArrayMap<K, V>();
  {
  $AE_CppIterator<dynamic?> _sync_for_iterator = iterable.iterator;
  for (; _sync_for_iterator.moveNext(); ) {
  dynamic? element = _sync_for_iterator.current;
  dynamic? k = ((() { final K Function(dynamic?)? temp_33289_6857 = key; return temp_33289_6857 == null ? null : temp_33289_6857.call(element); })()) ?? (element);
  dynamic? v = ((() { final V Function(dynamic?)? temp_33336_6867 = value; return temp_33336_6867 == null ? null : temp_33336_6867.call(element); })()) ?? (element);
  map[k as K] = v as V;
}
}
  return map;
}
  }
  
  factory $AB_CppArrayMap.fromIterables($AE_CppIterable<K> keys, $AE_CppIterable<V> values) {
    {
  $AB_CppArrayMap<K, V> map = $AB_CppArrayMap<K, V>();
  $AE_CppIterator<K> keyIter = keys.iterator;
  $AE_CppIterator<V> valueIter = values.iterator;
  while (keyIter.moveNext() && valueIter.moveNext()) {
  map[keyIter.current] = valueIter.current;
}
  return map;
}
  }
  
  factory $AB_CppArrayMap.fromEntries($AE_CppIterable<MapEntry<K, V>> entries) {
    {
  $AB_CppArrayMap<K, V> map = $AB_CppArrayMap<K, V>();
  {
  $AE_CppIterator<MapEntry<K, V>> _sync_for_iterator = entries.iterator;
  for (; _sync_for_iterator.moveNext(); ) {
  MapEntry<K, V> entry = _sync_for_iterator.current;
  map[entry.key] = entry.value;
}
}
  return map;
}
  }
  
  void addAll($AB_CppMap<K, V> other) {
    {
  other.forEach(FunctionWrapper<void Function(K, V)>([], (K k, V v) { return (() { final K temp_34763_7104 = k; return (() { final V temp_34769_7106 = v; return (() { this[temp_34763_7104] = temp_34769_7106; temp_34769_7106; })(); })(); })();}).call());
}
  }
  
  void addEntries($AE_CppIterable<MapEntry<K, V>> entries) {
    {
  {
  $AE_CppIterator<MapEntry<K, V>> _sync_for_iterator = entries.iterator;
  for (; _sync_for_iterator.moveNext(); ) {
  MapEntry<K, V> entry = _sync_for_iterator.current;
  this[entry.key] = entry.value;
}
}
}
  }
  
  $AB_CppMap<RK, RV> cast<RK, RV>() {
    return $AB_CppMap.castFrom<K, V, RK, RV>(this);
  }
  
  void clear() {
    {
  this._list.clear();
}
  }
  
  bool containsKey(Object? key) {
    {
  {
  $AE_CppIterator<MapEntry<K, V>> _sync_for_iterator = this._list.iterator;
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
  $AE_CppIterator<MapEntry<K, V>> _sync_for_iterator = this._list.iterator;
  for (; _sync_for_iterator.moveNext(); ) {
  MapEntry<K, V> entry = _sync_for_iterator.current;
  if (entry.value == value) return true;
}
}
  return false;
}
  }
  
  $AE_CppIterable<MapEntry<K, V>> get entries {
    return this._list;
  }
  
  void forEach(void Function(K, V) action) {
    {
  {
  $AE_CppIterator<MapEntry<K, V>> _sync_for_iterator = this._list.iterator;
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
  
  $AE_CppIterable<K> get keys {
    return this._list.map(FunctionWrapper<K Function(MapEntry<K, V>)>([], (MapEntry<K, V> e) { return e.key;}).call());
  }
  
  int get length {
    return this._list.length;
  }
  
  V putIfAbsent(K key, V Function() ifAbsent) {
    {
  {
  $AE_CppIterator<MapEntry<K, V>> _sync_for_iterator = this._list.iterator;
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
  
  $AE_CppIterable<V> get values {
    return this._list.map(FunctionWrapper<V Function(MapEntry<K, V>)>([], (MapEntry<K, V> e) { return e.value;}).call());
  }
  
  $AB_CppMap<K2, V2> map<K2, V2>(MapEntry<K2, V2> Function(K, V) transform) {
    {
  $AB_CppArrayMap<K2, V2> result = $AB_CppArrayMap<K2, V2>();
  {
  $AE_CppIterator<MapEntry<K, V>> _sync_for_iterator = this._list.iterator;
  for (; _sync_for_iterator.moveNext(); ) {
  MapEntry<K, V> entry = _sync_for_iterator.current;
  MapEntry<K2, V2> newEntry = transform.call(entry.key, entry.value);
  result[newEntry.key] = newEntry.value;
}
}
  return result;
}
  }
  
  $AD_CppString toCppString() {
    {
  if (this._list.isEmpty) return $AD_CppString.fromString("{}");
  $AD_CppStringBuffer buffer = $AD_CppStringBuffer("{");
  $AE_CppIterator<MapEntry<K, V>> iterator = this._list.iterator;
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
  
  static $AB_CppMap<RK, RV> castFrom<K, V, RK, RV>($AB_CppMap<K, V> source) {
    {
  $AB_CppArrayMap<RK, RV> result = $AB_CppArrayMap<RK, RV>();
  source.forEach(FunctionWrapper<void Function(K, V)>([], (K key, V value) { {
  result[key as RK] = value as RV;
}}).call());
  return result;
}
  }
  
  static $AB_CppMap<RK, RV> castFromWithFactory<K, V, RK, RV>($AB_CppMap<K, V> source, $AB_CppMap<RK, RV> Function() newMap) {
    {
  $AB_CppMap<RK, RV> result = newMap.call();
  source.forEach(FunctionWrapper<void Function(K, V)>([], (K key, V value) { {
  result[key as RK] = value as RV;
}}).call());
  return result;
}
  }
  
  V? operator [](Object? key) {
    {
  {
  $AE_CppIterator<MapEntry<K, V>> _sync_for_iterator = this._list.iterator;
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

/// 转换后的类: $AC_CppError
/// 原始类名: CppError
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/error.dart

class $AC_CppError extends $AF_CppObject {
$AC_CppError() : super()   {
    ;
  }
  
  $AC_CppStackTrace? get stackTrace {
    return $AC_CppStackTrace.current;
  }
  
}

/// 转换后的类: $AC_CppStackTrace
/// 原始类名: CppStackTrace
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/error.dart

class $AC_CppStackTrace extends $AF_CppObject {
  static $AC_CppStackTrace _current = $AC_CppStackTrace();
$AC_CppStackTrace() : super()   {
    ;
  }
  
  static $AC_CppStackTrace get current {
    return $AC_CppStackTrace._current;
  }
  
  $AD_CppString toCppString() {
    return $AD_CppString.fromString($AA_CppApi.getCurrentStackTrace());
  }
  
}

/// 转换后的类: $AD_CppStringPool
/// 原始类名: CppStringPool
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/string.dart

class $AD_CppStringPool {
  static final $AD_CppStringPool _instance = $AD_CppStringPool._internal();
  late $AB_CppList<$AA_CppUserData> _pool = $AB_CppList<$AA_CppUserData>.from(<$AA_CppUserData>[ConstantExpression(const CppUserData{CppUserData.data: const <dynamic>[]})] as $AE_CppIterable<dynamic?>);
$AD_CppStringPool._internal() : super()   {
    ;
  }
  
  static $AD_CppStringPool get instance {
    return $AD_CppStringPool._instance;
  }
  
  $AA_CppUserData getOrCreateFromCodeUnits($AB_CppList<int> codeUnits) {
    {
  {
  $AE_CppIterator<$AA_CppUserData> _sync_for_iterator = this._pool.iterator;
  for (; _sync_for_iterator.moveNext(); ) {
  $AA_CppUserData existing = _sync_for_iterator.current;
  if (this._compareUserData(existing, codeUnits)) {
  return existing;
}
}
}
  $AA_CppUserData userData = $AA_CppApi.cppCreateByteArray(codeUnits.length);
  for (int i = 0; (i < codeUnits.length); i = (i + 1)) {
  $AA_CppApi.cppSetByteArrayItem(userData, i, codeUnits[i]);
}
  this._pool.add(userData);
  return userData;
}
  }
  
  $AA_CppUserData getOrCreateFromUserData($AA_CppUserData userData) {
    {
  if (this._pool.contains(userData)) {
  return userData;
}
  this._pool.add(userData);
  return userData;
}
  }
  
  bool _compareUserData($AA_CppUserData userData, $AB_CppList<int> codeUnits) {
    {
  int length = $AA_CppApi.cppGetByteArrayLength(userData);
  if (!(length == codeUnits.length)) return false;
  for (int i = 0; (i < length); i = (i + 1)) {
  if (!($AA_CppApi.cppGetByteArrayItem(userData, i) == codeUnits[i])) {
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
  
  $AD_CppStringPoolStats getStats() {
    {
  int totalMemory = 0;
  {
  $AE_CppIterator<$AA_CppUserData> _sync_for_iterator = this._pool.iterator;
  for (; _sync_for_iterator.moveNext(); ) {
  $AA_CppUserData userData = _sync_for_iterator.current;
  totalMemory = (totalMemory + $AA_CppApi.cppGetByteArrayLength(userData));
}
}
  return $AD_CppStringPoolStats(totalStrings: this._pool.length, totalMemory: totalMemory);
}
  }
  
}

/// 转换后的类: $AD_CppStringPoolStats
/// 原始类名: CppStringPoolStats
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/string.dart

class $AD_CppStringPoolStats {
  late int totalStrings;
  late int totalMemory;
$AD_CppStringPoolStats({required int totalStrings, required int totalMemory}) : totalStrings = totalStrings, totalMemory = totalMemory, super()   {
    ;
  }
  
  String toString() {
    {
  return "CppStringPoolStats{\n" + "  不同字符串数: " + (this.totalStrings).toString() + "\n" + "  总内存使用: " + (this.totalMemory).toString() + " 字符\n" + "}";
}
  }
  
}

/// 转换后的类: $AD_CppStringBuffer
/// 原始类名: CppStringBuffer
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/string.dart

class $AD_CppStringBuffer {
  late $AB_CppList<$AA_CppUserData> _parts;
$AD_CppStringBuffer([Object content = ""]) : _parts = $AB_CppList<$AA_CppUserData>.from(<$AA_CppUserData>[$AD_CppStringBuffer._convertStringToUserData(content)] as $AE_CppIterable<dynamic?>), super()   {
    ;
  }
  
  void write(Object? obj) {
    {
  if (obj == null) return;
  this._parts.add($AD_CppStringBuffer._convertStringToUserData(obj));
}
  }
  
  void writeAll($AE_CppIterable<dynamic?> objects, [$AD_CppString? separator = null]) {
    {
  $AE_CppIterator<dynamic?> iterator = objects.iterator;
  if (iterator.moveNext()) {
  this._parts.add($AD_CppStringBuffer._convertStringToUserData((() { final dynamic? temp_3047 = iterator.current; return temp_3047 == null ? temp_3047 as Object : temp_3047; })()));
  while (iterator.moveNext()) {
  if (!(separator == null) && separator.isNotEmpty) {
  this._parts.add(separator._codeUnits);
}
  this._parts.add($AD_CppStringBuffer._convertStringToUserData((() { final dynamic? temp_3055 = iterator.current; return temp_3055 == null ? temp_3055 as Object : temp_3055; })()));
}
}
}
  }
  
  void writeCharCode(int charCode) {
    {
  this._parts.add($AD_CppStringBuffer._convertStringToUserData($AD_CppString.fromCharCode(charCode)));
}
  }
  
  void writeln([Object? obj = ""]) {
    {
  if (!(obj == null)) {
  this._parts.add($AD_CppStringBuffer._convertStringToUserData(obj));
}
  this._parts.add($AD_CppStringBuffer._convertStringToUserData($AD_CppString.fromCharCode(10)));
}
  }
  
  void clear() {
    {
  this._parts.clear();
}
  }
  
  $AD_CppString toCppString() {
    {
  $AB_CppList<int> codeUnits = $AB_CppList<int>.empty(growable: true);
  {
  $AE_CppIterator<$AA_CppUserData> _sync_for_iterator = this._parts.iterator;
  for (; _sync_for_iterator.moveNext(); ) {
  $AA_CppUserData part = _sync_for_iterator.current;
  int length = $AA_CppApi.cppGetByteArrayLength(part);
  for (int i = 0; (i < length); i = (i + 1)) {
  codeUnits.add($AA_CppApi.cppGetByteArrayItem(part, i));
}
}
}
  return $AD_CppString.fromCodeUnits(codeUnits);
}
  }
  
  int get length {
    {
  int totalLength = 0;
  {
  $AE_CppIterator<$AA_CppUserData> _sync_for_iterator = this._parts.iterator;
  for (; _sync_for_iterator.moveNext(); ) {
  $AA_CppUserData part = _sync_for_iterator.current;
  totalLength = (totalLength + $AA_CppApi.cppGetByteArrayLength(part));
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
  
  static $AA_CppUserData _convertStringToUserData(Object obj) {
    {
  if (obj is $AD_CppString) {
  return obj._codeUnits;
}
  return $AD_CppStringPool.instance.getOrCreateFromCodeUnits($AD_CppStringBuffer._convertStringToCodeUnits(obj.toString()));
}
  }
  
  static $AB_CppList<int> _convertStringToCodeUnits(String str) {
    {
  $AB_CppList<int> codeUnits = $AB_CppList<int>.empty(growable: true);
  for (int i = 0; (i < str.length); i = (i + 1)) {
  codeUnits.add(str.codeUnitAt(i));
}
  return codeUnits;
}
  }
  
}

/// 转换后的类: $AD_CppString
/// 原始类名: CppString
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/string.dart

class $AD_CppString extends $AF_CppObject implements Comparable<$AD_CppString> {
  static $AD_CppString Empty = ConstantExpression(const CppString{CppString._codeUnits: const CppUserData{CppUserData.data: const <dynamic>[]}});
  late $AA_CppUserData _codeUnits;
$AD_CppString.fromCppUserData($AA_CppUserData userData) : _codeUnits = userData, super()   {
    ;
  }
  
$AD_CppString.fromCodeUnits($AB_CppList<int> codeUnits) : _codeUnits = $AD_CppStringPool.instance.getOrCreateFromCodeUnits(codeUnits), super()   {
    ;
  }
  
$AD_CppString.fromCharCode(int charCode) : _codeUnits = $AD_CppStringPool.instance.getOrCreateFromCodeUnits($AB_CppList<int>.filled(1, charCode)), super()   {
    ;
  }
  
$AD_CppString.fromCharCodes($AE_CppIterable<int> charCodes, [int start = 0, int? end = null]) : _codeUnits = $AD_CppStringPool.instance.getOrCreateFromCodeUnits(charCodes.skip(start).take(((end) ?? (charCodes.length) - start)).toList()), super()   {
    ;
  }
  
  String _toExternalString() {
    {
  $AB_CppList<int> codeUnits = $AB_CppList<int>.empty(growable: true);
  for (int i = 0; (i < this.length); i = (i + 1)) {
  codeUnits.add($AA_CppApi.cppGetByteArrayItem(this._codeUnits, i));
}
  return String.fromCharCodes(codeUnits as Iterable<int>);
}
  }
  
  bool _equalCodeUnits($AD_CppString other) {
    {
  int thisLength = this.length;
  int otherLength = other.length;
  if (!(thisLength == otherLength)) return false;
  for (int i = 0; (i < thisLength); i = (i + 1)) {
  if (!($AA_CppApi.cppGetByteArrayItem(this._codeUnits, i) == $AA_CppApi.cppGetByteArrayItem(other._codeUnits, i))) {
  return false;
}
}
  return true;
}
  }
  
  int get length {
    return $AA_CppApi.cppGetByteArrayLength(this._codeUnits);
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
  hash = (((hash * 31) + $AA_CppApi.cppGetByteArrayItem(this._codeUnits, i)) & 2147483647);
}
  return hash;
}
  }
  
  int codeUnitAt(int index) {
    {
  if ((index < 0) || (index >= this.length)) {
  throw IndexError(index, this, "index");
}
  return $AA_CppApi.cppGetByteArrayItem(this._codeUnits, index);
}
  }
  
  $AB_CppList<int> get codeUnits {
    {
  int thisLength = this.length;
  $AB_CppList<int> units = $AB_CppList<int>.empty(growable: true);
  for (int i = 0; (i < thisLength); i = (i + 1)) {
  units.add($AA_CppApi.cppGetByteArrayItem(this._codeUnits, i));
}
  return units;
}
  }
  
  Runes get runes {
    return this._toExternalString().runes;
  }
  
  int compareTo($AD_CppString other) {
    {
  int thisLength = this.length;
  int otherLength = other.length;
  int minLength = (thisLength < otherLength) ? thisLength : otherLength;
  for (int i = 0; (i < minLength); i = (i + 1)) {
  int thisCodeUnit = $AA_CppApi.cppGetByteArrayItem(this._codeUnits, i);
  int otherCodeUnit = $AA_CppApi.cppGetByteArrayItem(other._codeUnits, i);
  if (!(thisCodeUnit == otherCodeUnit)) {
  return (thisCodeUnit - otherCodeUnit);
}
}
  return (thisLength - otherLength);
}
  }
  
  bool startsWith($AD_CppString pattern, [int index = 0]) {
    {
  if ((index < 0) || (index >= this.length)) return false;
  if (((index + pattern.length) > this.length)) return false;
  for (int i = 0; (i < pattern.length); i = (i + 1)) {
  if (!($AA_CppApi.cppGetByteArrayItem(this._codeUnits, (index + i)) == $AA_CppApi.cppGetByteArrayItem(pattern._codeUnits, i))) {
  return false;
}
}
  return true;
}
  }
  
  bool endsWith($AD_CppString other) {
    {
  if ((other.length > this.length)) return false;
  int startIndex = (this.length - other.length);
  for (int i = 0; (i < other.length); i = (i + 1)) {
  if (!($AA_CppApi.cppGetByteArrayItem(this._codeUnits, (startIndex + i)) == $AA_CppApi.cppGetByteArrayItem(other._codeUnits, i))) {
  return false;
}
}
  return true;
}
  }
  
  int indexOf($AD_CppString pattern, [int start = 0]) {
    {
  if ((start < 0)) start = 0;
  if (pattern.isEmpty) return start;
  if (((start + pattern.length) > this.length)) return -1;
  for (int i = start; (i <= (this.length - pattern.length)); i = (i + 1)) {
  bool match = true;
  label: for (int j = 0; (j < pattern.length); j = (j + 1)) {
  if (!($AA_CppApi.cppGetByteArrayItem(this._codeUnits, (i + j)) == $AA_CppApi.cppGetByteArrayItem(pattern._codeUnits, j))) {
  match = false;
  break;
}
}
  if (match) return i;
}
  return -1;
}
  }
  
  int lastIndexOf($AD_CppString pattern, [int? start = null]) {
    {
  if (pattern.isEmpty) return (start) ?? (this.length);
  start == null ? start = this.length : null;
  if ((start < 0)) return -1;
  if (((start + pattern.length) > this.length)) start = (this.length - pattern.length);
  for (int i = start; (i >= 0); i = (i - 1)) {
  bool match = true;
  label: for (int j = 0; (j < pattern.length); j = (j + 1)) {
  if (!($AA_CppApi.cppGetByteArrayItem(this._codeUnits, (i + j)) == $AA_CppApi.cppGetByteArrayItem(pattern._codeUnits, j))) {
  match = false;
  break;
}
}
  if (match) return i;
}
  return -1;
}
  }
  
  bool contains($AD_CppString other, [int startIndex = 0]) {
    {
  return !(this.indexOf(other, startIndex) == -1);
}
  }
  
  $AD_CppString substring(int start, [int? end = null]) {
    {
  end == null ? end = this.length : null;
  if ((start < 0)) start = 0;
  if ((end > this.length)) end = this.length;
  if ((start >= end)) return ConstantExpression(const CppString{CppString._codeUnits: const CppUserData{CppUserData.data: const <dynamic>[]}});
  int newLength = (end - start);
  $AB_CppList<int> newCodeUnits = $AB_CppList<int>.empty(growable: true);
  for (int i = 0; (i < newLength); i = (i + 1)) {
  int codeUnit = $AA_CppApi.cppGetByteArrayItem(this._codeUnits, (start + i));
  newCodeUnits.add(codeUnit);
}
  return $AD_CppString.fromCodeUnits(newCodeUnits);
}
  }
  
  $AD_CppString trim() {
    {
  int start = 0;
  int end = this.length;
  while ((start < end) && this._isWhitespace($AA_CppApi.cppGetByteArrayItem(this._codeUnits, start))) {
  start = (start + 1);
}
  while ((end > start) && this._isWhitespace($AA_CppApi.cppGetByteArrayItem(this._codeUnits, (end - 1)))) {
  end = (end - 1);
}
  return this.substring(start, end);
}
  }
  
  $AD_CppString trimLeft() {
    {
  int start = 0;
  while ((start < this.length) && this._isWhitespace($AA_CppApi.cppGetByteArrayItem(this._codeUnits, start))) {
  start = (start + 1);
}
  return this.substring(start);
}
  }
  
  $AD_CppString trimRight() {
    {
  int end = this.length;
  while ((end > 0) && this._isWhitespace($AA_CppApi.cppGetByteArrayItem(this._codeUnits, (end - 1)))) {
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
  
  $AD_CppString padLeft(int width, [$AD_CppString? padding = null]) {
    {
  if ((width <= this.length)) return this;
  padding == null ? padding = $AD_CppString.fromCharCode(32) : null;
  int padLength = (width - this.length);
  int padCount = (padLength / padding.length).ceil();
  $AD_CppString padString = (padding * padCount);
  $AD_CppString actualPad = padString.substring(0, padLength);
  return (actualPad + this);
}
  }
  
  $AD_CppString padRight(int width, [$AD_CppString? padding = null]) {
    {
  if ((width <= this.length)) return this;
  padding == null ? padding = $AD_CppString.fromCharCode(32) : null;
  int padLength = (width - this.length);
  int padCount = (padLength / padding.length).ceil();
  $AD_CppString padString = (padding * padCount);
  $AD_CppString actualPad = padString.substring(0, padLength);
  return (this + actualPad);
}
  }
  
  $AD_CppString replaceFirst($AD_CppString from, $AD_CppString to, [int startIndex = 0]) {
    {
  int index = this.indexOf(from, startIndex);
  if (index == -1) return this;
  $AD_CppString beforePart = this.substring(0, index);
  $AD_CppString afterPart = this.substring((index + from.length));
  return ((beforePart + to) + afterPart);
}
  }
  
  $AD_CppString replaceAll($AD_CppString from, $AD_CppString replace) {
    {
  if (from.isEmpty) return this;
  $AB_CppList<$AD_CppString> parts = this.split(from);
  if (parts.length == 1) return this;
  $AB_CppList<$AD_CppString> result = $AB_CppList<$AD_CppString>.empty(growable: true);
  for (int i = 0; (i < parts.length); i = (i + 1)) {
  result.add(parts[i]);
  if ((i < (parts.length - 1))) {
  result.add(replace);
}
}
  return $AD_CppString.join(result as $AE_CppIterable<$AD_CppString>);
}
  }
  
  $AD_CppString replaceRange(int start, int? end, $AD_CppString replacement) {
    {
  end == null ? end = this.length : null;
  if ((start < 0)) start = 0;
  if ((end > this.length)) end = this.length;
  if ((start >= end)) return (this + replacement);
  $AD_CppString beforePart = this.substring(0, start);
  $AD_CppString afterPart = this.substring(end);
  return ((beforePart + replacement) + afterPart);
}
  }
  
  $AB_CppList<$AD_CppString> split($AD_CppString separator) {
    {
  if (separator.isEmpty) {
  $AB_CppList<$AD_CppString> result = $AB_CppList<$AD_CppString>.empty(growable: true);
  for (int i = 0; (i < this.length); i = (i + 1)) {
  result.add(this.substring(i, (i + 1)));
}
  return result;
}
  $AB_CppList<$AD_CppString> result = $AB_CppList<$AD_CppString>.empty(growable: true);
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
  
  $AD_CppString toLowerCase() {
    {
  $AB_CppList<int> resultCodeUnits = $AB_CppList<int>.empty(growable: true);
  for (int i = 0; (i < this.length); i = (i + 1)) {
  int codeUnit = $AA_CppApi.cppGetByteArrayItem(this._codeUnits, i);
  if ((codeUnit >= 65) && (codeUnit <= 90)) {
  codeUnit = (codeUnit + 32);
}
  resultCodeUnits.add(codeUnit);
}
  return $AD_CppString.fromCodeUnits(resultCodeUnits);
}
  }
  
  $AD_CppString toUpperCase() {
    {
  $AB_CppList<int> resultCodeUnits = $AB_CppList<int>.empty(growable: true);
  for (int i = 0; (i < this.length); i = (i + 1)) {
  int codeUnit = $AA_CppApi.cppGetByteArrayItem(this._codeUnits, i);
  if ((codeUnit >= 97) && (codeUnit <= 122)) {
  codeUnit = (codeUnit - 32);
}
  resultCodeUnits.add(codeUnit);
}
  return $AD_CppString.fromCodeUnits(resultCodeUnits);
}
  }
  
  $AE_CppIterable<$AD_CppStringMatch> allMatches($AD_CppString string, [int start = 0]) {
    {
  if ((start < 0) || (start > string.length)) {
  throw RangeError.range(start, 0, string.length, "start");
}
  return $AD__CppStringAllMatchesIterable(string, this, start);
}
  }
  
  $AD_CppStringMatch? matchAsPrefix($AD_CppString string, [int start = 0]) {
    {
  if ((start < 0) || (start > string.length)) {
  throw RangeError.range(start, 0, string.length);
}
  if (((start + this.length) > string.length)) return null;
  for (int i = 0; (i < this.length); i = (i + 1)) {
  if (!($AA_CppApi.cppGetByteArrayItem(string._codeUnits, (start + i)) == $AA_CppApi.cppGetByteArrayItem(this._codeUnits, i))) {
  return null;
}
}
  return $AD_CppStringMatch(start, string, this);
}
  }
  
  $AD_CppString toCppString() {
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
  
  bool sharesDataWith($AD_CppString other) {
    {
  return identical(this._codeUnits, other._codeUnits);
}
  }
  
  int get dataHashCode {
    return this._codeUnits.hashCode;
  }
  
  static $AD_CppString fromString(String source) {
    {
  $AB_CppList<int> codeUnits = $AB_CppList<int>.empty(growable: true);
  for (int i = 0; (i < source.length); i = (i + 1)) {
  codeUnits.add(source.codeUnitAt(i));
}
  return $AD_CppString.fromCodeUnits(codeUnits);
}
  }
  
  static $AD_CppString join($AE_CppIterable<$AD_CppString> strings, [$AD_CppString? separator = null]) {
    {
  separator == null ? separator = ConstantExpression(const CppString{CppString._codeUnits: const CppUserData{CppUserData.data: const <dynamic>[]}}) : null;
  $AB_CppList<$AD_CppString> stringList = strings.toList();
  if (stringList.isEmpty) return ConstantExpression(const CppString{CppString._codeUnits: const CppUserData{CppUserData.data: const <dynamic>[]}});
  if (stringList.length == 1) return stringList[0];
  $AB_CppList<int> newCodeUnits = $AB_CppList<int>.empty(growable: true);
  for (int i = 0; (i < stringList.length); i = (i + 1)) {
  $AD_CppString str = stringList[i];
  for (int j = 0; (j < str.length); j = (j + 1)) {
  newCodeUnits.add($AA_CppApi.cppGetByteArrayItem(str._codeUnits, j));
}
  if ((i < (stringList.length - 1))) {
  for (int j = 0; (j < separator.length); j = (j + 1)) {
  newCodeUnits.add($AA_CppApi.cppGetByteArrayItem(separator._codeUnits, j));
}
}
}
  return $AD_CppString.fromCodeUnits(newCodeUnits);
}
  }
  
  $AD_CppString operator [](int index) {
    {
  int thisLength = this.length;
  if ((index < 0) || (index >= thisLength)) {
  throw IndexError(index, this, "index");
}
  int codeUnit = $AA_CppApi.cppGetByteArrayItem(this._codeUnits, index);
  return $AD_CppString.fromCharCode(codeUnit);
}
  }
  
  bool operator ==(Object other) {
    {
  if (identical(this, other)) return true;
  if (other is $AD_CppString) {
  return this._equalCodeUnits(other);
}
  return false;
}
  }
  
  $AD_CppString operator +($AD_CppString other) {
    {
  int thisLength = this.length;
  int otherLength = other.length;
  $AB_CppList<int> newCodeUnits = $AB_CppList<int>.empty(growable: true);
  ;
  for (int i = 0; (i < thisLength); i = (i + 1)) {
  newCodeUnits.add($AA_CppApi.cppGetByteArrayItem(this._codeUnits, i));
}
  for (int i = 0; (i < otherLength); i = (i + 1)) {
  newCodeUnits.add($AA_CppApi.cppGetByteArrayItem(other._codeUnits, i));
}
  return $AD_CppString.fromCodeUnits(newCodeUnits);
}
  }
  
  $AD_CppString operator *(int times) {
    {
  if ((times <= 0)) return ConstantExpression(const CppString{CppString._codeUnits: const CppUserData{CppUserData.data: const <dynamic>[]}});
  if (times == 1) return this;
  int thisLength = this.length;
  $AB_CppList<int> newCodeUnits = $AB_CppList<int>.empty(growable: true);
  for (int repeat = 0; (repeat < times); repeat = (repeat + 1)) {
  for (int i = 0; (i < thisLength); i = (i + 1)) {
  newCodeUnits.add($AA_CppApi.cppGetByteArrayItem(this._codeUnits, i));
}
}
  return $AD_CppString.fromCodeUnits(newCodeUnits);
}
  }
  
}

/// 转换后的类: $AD_CppStringMatch
/// 原始类名: CppStringMatch
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/string.dart

class $AD_CppStringMatch {
  late int start;
  late $AD_CppString input;
  late $AD_CppString pattern;
$AD_CppStringMatch(int start, $AD_CppString input, $AD_CppString pattern) : start = start, input = input, pattern = pattern, super()   {
    ;
  }
  
  int get end {
    return (this.start + this.pattern.length);
  }
  
  $AD_CppString group(int group) {
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
  
  $AD_CppString operator [](int group) {
    return group == 0 ? this.pattern : throw RangeError.value(group);
  }
  
}

/// 转换后的类: $AD__CppStringAllMatchesIterable
/// 原始类名: _CppStringAllMatchesIterable
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/string.dart

class $AD__CppStringAllMatchesIterable extends $AE_CppIterable<$AD_CppStringMatch> {
  late $AD_CppString _input;
  late $AD_CppString _pattern;
  late int _index;
$AD__CppStringAllMatchesIterable($AD_CppString _input, $AD_CppString _pattern, int _index) : _input = _input, _pattern = _pattern, _index = _index, super()   {
    ;
  }
  
  $AE_CppIterator<$AD_CppStringMatch> get iterator {
    return $AD__CppStringAllMatchesIterator(this._input, this._pattern, this._index);
  }
  
  int get length {
    {
  int count = 0;
  $AE_CppIterator<$AD_CppStringMatch> it = this.iterator;
  while (it.moveNext()) {
  count = (count + 1);
}
  return count;
}
  }
  
  $AD_CppStringMatch get first {
    {
  int index = this._input.indexOf(this._pattern, this._index);
  if ((index >= 0)) {
  return $AD_CppStringMatch(index, this._input, this._pattern);
}
  throw StateError("No element");
}
  }
  
}

/// 转换后的类: $AD__CppStringAllMatchesIterator
/// 原始类名: _CppStringAllMatchesIterator
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/string.dart

class $AD__CppStringAllMatchesIterator extends $AF_CppObject implements $AE_CppIterator<$AD_CppStringMatch> {
  late int _index;
  $AD_CppStringMatch? _current = null;
  late $AD_CppString _input;
  late $AD_CppString _pattern;
$AD__CppStringAllMatchesIterator($AD_CppString _input, $AD_CppString _pattern, int _index) : _input = _input, _pattern = _pattern, _index = _index, super()   {
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
  this._current = $AD_CppStringMatch(index, this._input, this._pattern);
  this._index = end == this._index ? (end + 1) : end;
  return true;
}
  }
  
  $AD_CppStringMatch get current {
    return (() { final $AD_CppStringMatch? temp_3063 = this._current; return temp_3063 == null ? temp_3063 as $AD_CppStringMatch : temp_3063; })();
  }
  
}

/// 转换后的类: $AE_CppIterator
/// 原始类名: CppIterator
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/Iterable.dart

abstract class $AE_CppIterator<E> extends $AF_CppObject {
$AE_CppIterator() : super()   {
    ;
  }
  
  E get current;
  
  bool moveNext();
  
}

/// 转换后的类: $AE_CppIterable
/// 原始类名: CppIterable
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/Iterable.dart

abstract class $AE_CppIterable<E> extends $AF_CppObject {
$AE_CppIterable() : super()   {
    ;
  }
  
  $AE_CppIterator<E> get iterator;
  
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
  $AE_CppIterator<E> it = this.iterator;
  if (!(it.moveNext())) throw StateError("No element");
  return it.current;
}
  }
  
  E get last {
    {
  if (this.isEmpty) throw StateError("No element");
  $AE_CppIterator<E> it = this.iterator;
  E? result;
  while (it.moveNext()) {
  result = it.current;
}
  return (() { final E? temp_3071 = result; return temp_3071 == null ? temp_3071 as E : temp_3071; })();
}
  }
  
  E get single {
    {
  if (this.isEmpty) throw StateError("No element");
  $AE_CppIterator<E> it = this.iterator;
  it.moveNext();
  E result = it.current;
  if (it.moveNext()) throw StateError("Too many elements");
  return result;
}
  }
  
  E elementAt(int index) {
    {
  if ((index < 0)) throw ArgumentError("Index cannot be negative");
  $AE_CppIterator<E> it = this.iterator;
  for (int i = 0; (i <= index); i = (i + 1)) {
  if (!(it.moveNext())) throw IndexError(index, this);
  if (i == index) return it.current;
}
  throw IndexError(index, this);
}
  }
  
  bool contains(Object? element) {
    {
  $AE_CppIterator<E> it = this.iterator;
  while (it.moveNext()) {
  if (it.current == element) return true;
}
  return false;
}
  }
  
  void forEach(void Function(E) action) {
    {
  $AE_CppIterator<E> it = this.iterator;
  while (it.moveNext()) {
  action.call(it.current);
}
}
  }
  
  $AE_CppIterable<T> map<T>(T Function(E) toElement) {
    {
  return $AE_CppMappedIterable<E, T>(this, toElement);
}
  }
  
  $AE_CppIterable<E> where(bool Function(E) test) {
    {
  return $AE_CppWhereIterable<E>(this, test);
}
  }
  
  $AE_CppIterable<T> whereType<T>() {
    {
  return $AE_CppWhereTypeIterable<T>(this);
}
  }
  
  $AE_CppIterable<T> expand<T>($AE_CppIterable<T> Function(E) toElements) {
    {
  return $AE_CppExpandIterable<E, T>(this, toElements);
}
  }
  
  bool any(bool Function(E) test) {
    {
  $AE_CppIterator<E> it = this.iterator;
  while (it.moveNext()) {
  if (test.call(it.current)) return true;
}
  return false;
}
  }
  
  bool every(bool Function(E) test) {
    {
  $AE_CppIterator<E> it = this.iterator;
  while (it.moveNext()) {
  if (!(test.call(it.current))) return false;
}
  return true;
}
  }
  
  E firstWhere(bool Function(E) test, {E Function()? orElse = null}) {
    {
  $AE_CppIterator<E> it = this.iterator;
  while (it.moveNext()) {
  if (test.call(it.current)) return it.current;
}
  if (!(orElse == null)) return orElse.call();
  throw StateError("No element");
}
  }
  
  E lastWhere(bool Function(E) test, {E Function()? orElse = null}) {
    {
  $AE_CppIterator<E> it = this.iterator;
  E? result;
  bool found = false;
  while (it.moveNext()) {
  if (test.call(it.current)) {
  result = it.current;
  found = true;
}
}
  if (found) return (() { final E? temp_3079 = result; return temp_3079 == null ? temp_3079 as E : temp_3079; })();
  if (!(orElse == null)) return orElse.call();
  throw StateError("No element");
}
  }
  
  E singleWhere(bool Function(E) test, {E Function()? orElse = null}) {
    {
  $AE_CppIterator<E> it = this.iterator;
  E? result;
  bool found = false;
  while (it.moveNext()) {
  if (test.call(it.current)) {
  if (found) throw StateError("Too many elements");
  result = it.current;
  found = true;
}
}
  if (found) return (() { final E? temp_3087 = result; return temp_3087 == null ? temp_3087 as E : temp_3087; })();
  if (!(orElse == null)) return orElse.call();
  throw StateError("No element");
}
  }
  
  E reduce(E Function(E, E) combine) {
    {
  $AE_CppIterator<E> it = this.iterator;
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
  $AE_CppIterator<E> it = this.iterator;
  while (it.moveNext()) {
  value = combine.call(value, it.current);
}
  return value;
}
  }
  
  $AD_CppString join([$AD_CppString separator = ConstantExpression(const CppString{CppString._codeUnits: const CppUserData{CppUserData.data: const <dynamic>[]}})]) {
    {
  $AE_CppIterator<E> it = this.iterator;
  if (!(it.moveNext())) return ConstantExpression(const CppString{CppString._codeUnits: const CppUserData{CppUserData.data: const <dynamic>[]}});
  $AD_CppStringBuffer buffer = $AD_CppStringBuffer(it.current.toString());
  while (it.moveNext()) {
  buffer.write(separator);
  buffer.write(it.current.toString());
}
  return buffer.toCppString();
}
  }
  
  $AE_CppIterable<E> take(int count) {
    {
  return $AE_CppTakeIterable<E>(this, count);
}
  }
  
  $AE_CppIterable<E> takeWhile(bool Function(E) test) {
    {
  return $AE_CppTakeWhileIterable<E>(this, test);
}
  }
  
  $AE_CppIterable<E> skip(int count) {
    {
  return $AE_CppSkipIterable<E>(this, count);
}
  }
  
  $AE_CppIterable<E> skipWhile(bool Function(E) test) {
    {
  return $AE_CppSkipWhileIterable<E>(this, test);
}
  }
  
  $AE_CppIterable<E> get reversed {
    {
  return $AE_CppReversedIterable<E>(this);
}
  }
  
  $AE_CppIterable<E> followedBy($AE_CppIterable<E> other) {
    {
  return $AE_CppFollowedByIterable<E>(this, other);
}
  }
  
  $AB_CppList<E> toList({bool growable = true}) {
    {
  return $AB_CppList<E>.from(this as $AE_CppIterable<dynamic?>, growable: growable);
}
  }
  
  $AB_CppSet<E> toSet() {
    {
  return $AB_CppSet<E>.from(this);
}
  }
  
  $AE_CppIterable<T> cast<T>() {
    {
  return $AE_CppCastIterable<E, T>(this);
}
  }
  
  static $AE_CppIterable<E> empty<E>() {
    return $AE__CppEmptyIterable<E>();
  }
  
  static $AE_CppIterable<E> generate<E>(int count, E Function(int) generator) {
    {
  return $AE__CppGenerateIterable<E>(count, generator);
}
  }
  
  static $AE_CppIterable<E> unmodifiable<E>($AE_CppIterable<E> elements) {
    {
  return $AE__CppUnmodifiableIterable<E>(elements.toList());
}
  }
  
  static $AE_CppIterable<R> castFrom<S, R>($AE_CppIterable<S> source) {
    {
  return $AE__CppCastFromIterable<S, R>(source);
}
  }
  
}

/// 转换后的类: $AE_CppMappedIterable
/// 原始类名: CppMappedIterable
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/Iterable.dart

class $AE_CppMappedIterable<S, T> extends $AE_CppIterable<T> {
  late $AE_CppIterable<S> _source;
  late T Function(S) _f;
$AE_CppMappedIterable($AE_CppIterable<S> _source, T Function(S) _f) : _source = _source, _f = _f, super()   {
    ;
  }
  
  $AE_CppIterator<T> get iterator {
    return $AE_CppMappedIterator<S, T>(this._source.iterator, this._f);
  }
  
  int get length {
    return this._source.length;
  }
  
}

/// 转换后的类: $AE_CppMappedIterator
/// 原始类名: CppMappedIterator
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/Iterable.dart

class $AE_CppMappedIterator<S, T> extends $AE_CppIterator<T> {
  T? _current = null;
  late $AE_CppIterator<S> _iterator;
  late T Function(S) _f;
$AE_CppMappedIterator($AE_CppIterator<S> _iterator, T Function(S) _f) : _iterator = _iterator, _f = _f, super()   {
    ;
  }
  
  T get current {
    return (() { final T? temp_3095 = this._current; return temp_3095 == null ? temp_3095 as T : temp_3095; })();
  }
  
  bool moveNext() {
    {
  if (this._iterator.moveNext()) {
  this._current = (() { final S temp_6840_1526 = this._iterator.current; return this._f.call(temp_6840_1526); })();
  return true;
}
  return false;
}
  }
  
}

/// 转换后的类: $AE_CppWhereIterable
/// 原始类名: CppWhereIterable
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/Iterable.dart

class $AE_CppWhereIterable<E> extends $AE_CppIterable<E> {
  late $AE_CppIterable<E> _source;
  late bool Function(E) _test;
$AE_CppWhereIterable($AE_CppIterable<E> _source, bool Function(E) _test) : _source = _source, _test = _test, super()   {
    ;
  }
  
  $AE_CppIterator<E> get iterator {
    return $AE_CppWhereIterator<E>(this._source.iterator, this._test);
  }
  
  int get length {
    {
  int count = 0;
  $AE_CppIterator<E> it = this.iterator;
  while (it.moveNext()) {
  count = (count + 1);
}
  return count;
}
  }
  
}

/// 转换后的类: $AE_CppWhereIterator
/// 原始类名: CppWhereIterator
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/Iterable.dart

class $AE_CppWhereIterator<E> extends $AE_CppIterator<E> {
  late $AE_CppIterator<E> _iterator;
  late bool Function(E) _test;
$AE_CppWhereIterator($AE_CppIterator<E> _iterator, bool Function(E) _test) : _iterator = _iterator, _test = _test, super()   {
    ;
  }
  
  E get current {
    return this._iterator.current;
  }
  
  bool moveNext() {
    {
  while (this._iterator.moveNext()) {
  if ((() { final E temp_7648_1612 = this._iterator.current; return this._test.call(temp_7648_1612); })()) {
  return true;
}
}
  return false;
}
  }
  
}

/// 转换后的类: $AE_CppWhereTypeIterable
/// 原始类名: CppWhereTypeIterable
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/Iterable.dart

class $AE_CppWhereTypeIterable<T> extends $AE_CppIterable<T> {
  late $AE_CppIterable<dynamic?> _source;
$AE_CppWhereTypeIterable($AE_CppIterable<dynamic?> _source) : _source = _source, super()   {
    ;
  }
  
  $AE_CppIterator<T> get iterator {
    return $AE_CppWhereTypeIterator<T>(this._source.iterator);
  }
  
  int get length {
    {
  int count = 0;
  $AE_CppIterator<T> it = this.iterator;
  while (it.moveNext()) {
  count = (count + 1);
}
  return count;
}
  }
  
}

/// 转换后的类: $AE_CppWhereTypeIterator
/// 原始类名: CppWhereTypeIterator
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/Iterable.dart

class $AE_CppWhereTypeIterator<T> extends $AE_CppIterator<T> {
  late $AE_CppIterator<dynamic?> _iterator;
$AE_CppWhereTypeIterator($AE_CppIterator<dynamic?> _iterator) : _iterator = _iterator, super()   {
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

/// 转换后的类: $AE_CppExpandIterable
/// 原始类名: CppExpandIterable
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/Iterable.dart

class $AE_CppExpandIterable<S, T> extends $AE_CppIterable<T> {
  late $AE_CppIterable<S> _source;
  late $AE_CppIterable<T> Function(S) _f;
$AE_CppExpandIterable($AE_CppIterable<S> _source, $AE_CppIterable<T> Function(S) _f) : _source = _source, _f = _f, super()   {
    ;
  }
  
  $AE_CppIterator<T> get iterator {
    return $AE_CppExpandIterator<S, T>(this._source.iterator, this._f);
  }
  
  int get length {
    {
  int count = 0;
  $AE_CppIterator<T> it = this.iterator;
  while (it.moveNext()) {
  count = (count + 1);
}
  return count;
}
  }
  
}

/// 转换后的类: $AE_CppExpandIterator
/// 原始类名: CppExpandIterator
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/Iterable.dart

class $AE_CppExpandIterator<S, T> extends $AE_CppIterator<T> {
  $AE_CppIterator<T>? _currentIterator = null;
  late $AE_CppIterator<S> _iterator;
  late $AE_CppIterable<T> Function(S) _f;
$AE_CppExpandIterator($AE_CppIterator<S> _iterator, $AE_CppIterable<T> Function(S) _f) : _iterator = _iterator, _f = _f, super()   {
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
  this._currentIterator = (() { final S temp_9437_1793 = this._iterator.current; return this._f.call(temp_9437_1793); })().iterator;
}
}
  }
  
}

/// 转换后的类: $AE_CppTakeIterable
/// 原始类名: CppTakeIterable
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/Iterable.dart

class $AE_CppTakeIterable<E> extends $AE_CppIterable<E> {
  late $AE_CppIterable<E> _source;
  late int _count;
$AE_CppTakeIterable($AE_CppIterable<E> _source, int _count) : _source = _source, _count = _count, super()   {
    ;
  }
  
  $AE_CppIterator<E> get iterator {
    return $AE_CppTakeIterator<E>(this._source.iterator, this._count);
  }
  
  int get length {
    return min<int>(this._count, this._source.length);
  }
  
}

/// 转换后的类: $AE_CppTakeIterator
/// 原始类名: CppTakeIterator
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/Iterable.dart

class $AE_CppTakeIterator<E> extends $AE_CppIterator<E> {
  late int _remaining;
  late $AE_CppIterator<E> _iterator;
  late int _count;
$AE_CppTakeIterator($AE_CppIterator<E> _iterator, int _count) : _iterator = _iterator, _count = _count, _remaining = _count, super()   {
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

/// 转换后的类: $AE_CppTakeWhileIterable
/// 原始类名: CppTakeWhileIterable
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/Iterable.dart

class $AE_CppTakeWhileIterable<E> extends $AE_CppIterable<E> {
  late $AE_CppIterable<E> _source;
  late bool Function(E) _test;
$AE_CppTakeWhileIterable($AE_CppIterable<E> _source, bool Function(E) _test) : _source = _source, _test = _test, super()   {
    ;
  }
  
  $AE_CppIterator<E> get iterator {
    return $AE_CppTakeWhileIterator<E>(this._source.iterator, this._test);
  }
  
  int get length {
    {
  int count = 0;
  $AE_CppIterator<E> it = this.iterator;
  while (it.moveNext()) {
  count = (count + 1);
}
  return count;
}
  }
  
}

/// 转换后的类: $AE_CppTakeWhileIterator
/// 原始类名: CppTakeWhileIterator
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/Iterable.dart

class $AE_CppTakeWhileIterator<E> extends $AE_CppIterator<E> {
  bool _finished = false;
  late $AE_CppIterator<E> _iterator;
  late bool Function(E) _test;
$AE_CppTakeWhileIterator($AE_CppIterator<E> _iterator, bool Function(E) _test) : _iterator = _iterator, _test = _test, super()   {
    ;
  }
  
  E get current {
    return this._iterator.current;
  }
  
  bool moveNext() {
    {
  if (this._finished) return false;
  if (this._iterator.moveNext()) {
  if ((() { final E temp_11052_1974 = this._iterator.current; return this._test.call(temp_11052_1974); })()) {
  return true;
}
  this._finished = true;
}
  return false;
}
  }
  
}

/// 转换后的类: $AE_CppSkipIterable
/// 原始类名: CppSkipIterable
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/Iterable.dart

class $AE_CppSkipIterable<E> extends $AE_CppIterable<E> {
  late $AE_CppIterable<E> _source;
  late int _count;
$AE_CppSkipIterable($AE_CppIterable<E> _source, int _count) : _source = _source, _count = _count, super()   {
    ;
  }
  
  $AE_CppIterator<E> get iterator {
    return $AE_CppSkipIterator<E>(this._source.iterator, this._count);
  }
  
  int get length {
    return max<int>(0, (this._source.length - this._count));
  }
  
}

/// 转换后的类: $AE_CppSkipIterator
/// 原始类名: CppSkipIterator
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/Iterable.dart

class $AE_CppSkipIterator<E> extends $AE_CppIterator<E> {
  bool _skipped = false;
  late $AE_CppIterator<E> _iterator;
  late int _count;
$AE_CppSkipIterator($AE_CppIterator<E> _iterator, int _count) : _iterator = _iterator, _count = _count, super()   {
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

/// 转换后的类: $AE_CppSkipWhileIterable
/// 原始类名: CppSkipWhileIterable
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/Iterable.dart

class $AE_CppSkipWhileIterable<E> extends $AE_CppIterable<E> {
  late $AE_CppIterable<E> _source;
  late bool Function(E) _test;
$AE_CppSkipWhileIterable($AE_CppIterable<E> _source, bool Function(E) _test) : _source = _source, _test = _test, super()   {
    ;
  }
  
  $AE_CppIterator<E> get iterator {
    return $AE_CppSkipWhileIterator<E>(this._source.iterator, this._test);
  }
  
  int get length {
    {
  int count = 0;
  $AE_CppIterator<E> it = this.iterator;
  while (it.moveNext()) {
  count = (count + 1);
}
  return count;
}
  }
  
}

/// 转换后的类: $AE_CppSkipWhileIterator
/// 原始类名: CppSkipWhileIterator
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/Iterable.dart

class $AE_CppSkipWhileIterator<E> extends $AE_CppIterator<E> {
  bool _skipped = false;
  late $AE_CppIterator<E> _iterator;
  late bool Function(E) _test;
$AE_CppSkipWhileIterator($AE_CppIterator<E> _iterator, bool Function(E) _test) : _iterator = _iterator, _test = _test, super()   {
    ;
  }
  
  E get current {
    return this._iterator.current;
  }
  
  bool moveNext() {
    {
  if (!(this._skipped)) {
  while (this._iterator.moveNext()) {
  if (!((() { final E temp_12762_2176 = this._iterator.current; return this._test.call(temp_12762_2176); })())) {
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

/// 转换后的类: $AE_CppReversedIterable
/// 原始类名: CppReversedIterable
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/Iterable.dart

class $AE_CppReversedIterable<E> extends $AE_CppIterable<E> {
  late $AE_CppIterable<E> _source;
$AE_CppReversedIterable($AE_CppIterable<E> _source) : _source = _source, super()   {
    ;
  }
  
  $AE_CppIterator<E> get iterator {
    return $AE_CppReversedIterator<E>(this._source);
  }
  
  int get length {
    return this._source.length;
  }
  
}

/// 转换后的类: $AE_CppReversedIterator
/// 原始类名: CppReversedIterator
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/Iterable.dart

class $AE_CppReversedIterator<E> extends $AE_CppIterator<E> {
  late int _index;
  late $AB_CppList<E> _elements;
$AE_CppReversedIterator($AE_CppIterable<E> source) : _elements = $AB_CppList<E>.from(source as $AE_CppIterable<dynamic?>), _index = source.length, super()   {
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

/// 转换后的类: $AE_CppFollowedByIterable
/// 原始类名: CppFollowedByIterable
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/Iterable.dart

class $AE_CppFollowedByIterable<E> extends $AE_CppIterable<E> {
  late $AE_CppIterable<E> _first;
  late $AE_CppIterable<E> _second;
$AE_CppFollowedByIterable($AE_CppIterable<E> _first, $AE_CppIterable<E> _second) : _first = _first, _second = _second, super()   {
    ;
  }
  
  $AE_CppIterator<E> get iterator {
    return $AE_CppFollowedByIterator<E>(this._first.iterator, this._second.iterator);
  }
  
  int get length {
    return (this._first.length + this._second.length);
  }
  
}

/// 转换后的类: $AE_CppFollowedByIterator
/// 原始类名: CppFollowedByIterator
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/Iterable.dart

class $AE_CppFollowedByIterator<E> extends $AE_CppIterator<E> {
  bool _usingFirst = true;
  late $AE_CppIterator<E> _first;
  late $AE_CppIterator<E> _second;
$AE_CppFollowedByIterator($AE_CppIterator<E> _first, $AE_CppIterator<E> _second) : _first = _first, _second = _second, super()   {
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

/// 转换后的类: $AE_CppCastIterable
/// 原始类名: CppCastIterable
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/Iterable.dart

class $AE_CppCastIterable<S, T> extends $AE_CppIterable<T> {
  late $AE_CppIterable<S> _source;
$AE_CppCastIterable($AE_CppIterable<S> _source) : _source = _source, super()   {
    ;
  }
  
  $AE_CppIterator<T> get iterator {
    return $AE_CppCastIterator<S, T>(this._source.iterator);
  }
  
  int get length {
    return this._source.length;
  }
  
}

/// 转换后的类: $AE_CppCastIterator
/// 原始类名: CppCastIterator
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/Iterable.dart

class $AE_CppCastIterator<S, T> extends $AE_CppIterator<T> {
  late $AE_CppIterator<S> _iterator;
$AE_CppCastIterator($AE_CppIterator<S> _iterator) : _iterator = _iterator, super()   {
    ;
  }
  
  T get current {
    return this._iterator.current as T;
  }
  
  bool moveNext() {
    return this._iterator.moveNext();
  }
  
}

/// 转换后的类: $AE__CppEmptyIterable
/// 原始类名: _CppEmptyIterable
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/Iterable.dart

class $AE__CppEmptyIterable<E> extends $AE_CppIterable<E> {
$AE__CppEmptyIterable() : super()   {
    ;
  }
  
  $AE_CppIterator<E> get iterator {
    return $AE__CppEmptyIterator<E>();
  }
  
  int get length {
    return 0;
  }
  
}

/// 转换后的类: $AE__CppEmptyIterator
/// 原始类名: _CppEmptyIterator
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/Iterable.dart

class $AE__CppEmptyIterator<E> extends $AE_CppIterator<E> {
$AE__CppEmptyIterator() : super()   {
    ;
  }
  
  E get current {
    throw StateError("No element");
  }
  
  bool moveNext() {
    return false;
  }
  
}

/// 转换后的类: $AE__CppGenerateIterable
/// 原始类名: _CppGenerateIterable
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/Iterable.dart

class $AE__CppGenerateIterable<E> extends $AE_CppIterable<E> {
  late int _count;
  late E Function(int) _generator;
$AE__CppGenerateIterable(int _count, E Function(int) _generator) : _count = _count, _generator = _generator, super()   {
    ;
  }
  
  $AE_CppIterator<E> get iterator {
    return $AE__CppGenerateIterator<E>(this._count, this._generator);
  }
  
  int get length {
    return this._count;
  }
  
}

/// 转换后的类: $AE__CppGenerateIterator
/// 原始类名: _CppGenerateIterator
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/Iterable.dart

class $AE__CppGenerateIterator<E> extends $AE_CppIterator<E> {
  int _index = 0;
  E? _current = null;
  late int _count;
  late E Function(int) _generator;
$AE__CppGenerateIterator(int _count, E Function(int) _generator) : _count = _count, _generator = _generator, super()   {
    ;
  }
  
  E get current {
    return (() { final E? temp_3103 = this._current; return temp_3103 == null ? temp_3103 as E : temp_3103; })();
  }
  
  bool moveNext() {
    {
  if ((this._index < this._count)) {
  this._current = (() { final int temp_16006_2483 = (() { final int temp_16006_2451 = this._index; return (() { final int temp_16000_2456 = this._index = (temp_16006_2451 + 1); return temp_16006_2451; })(); })(); return this._generator.call(temp_16006_2483); })();
  return true;
}
  return false;
}
  }
  
}

/// 转换后的类: $AE__CppUnmodifiableIterable
/// 原始类名: _CppUnmodifiableIterable
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/Iterable.dart

class $AE__CppUnmodifiableIterable<E> extends $AE_CppIterable<E> {
  late $AB_CppList<E> _elements;
$AE__CppUnmodifiableIterable($AB_CppList<E> _elements) : _elements = _elements, super()   {
    ;
  }
  
  $AE_CppIterator<E> get iterator {
    return this._elements.iterator;
  }
  
  int get length {
    return this._elements.length;
  }
  
}

/// 转换后的类: $AE__CppCastFromIterable
/// 原始类名: _CppCastFromIterable
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/Iterable.dart

class $AE__CppCastFromIterable<S, R> extends $AE_CppIterable<R> {
  late $AE_CppIterable<S> _source;
$AE__CppCastFromIterable($AE_CppIterable<S> _source) : _source = _source, super()   {
    ;
  }
  
  $AE_CppIterator<R> get iterator {
    return $AE__CppCastFromIterator<S, R>(this._source.iterator);
  }
  
  int get length {
    return this._source.length;
  }
  
}

/// 转换后的类: $AE__CppCastFromIterator
/// 原始类名: _CppCastFromIterator
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/Iterable.dart

class $AE__CppCastFromIterator<S, R> extends $AE_CppIterator<R> {
  late $AE_CppIterator<S> _iterator;
$AE__CppCastFromIterator($AE_CppIterator<S> _iterator) : _iterator = _iterator, super()   {
    ;
  }
  
  R get current {
    return this._iterator.current as R;
  }
  
  bool moveNext() {
    return this._iterator.moveNext();
  }
  
}

/// 转换后的类: $AF_CppObject
/// 原始类名: CppObject
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/object.dart

class $AF_CppObject {
$AF_CppObject() : super()   {
    ;
  }
  
  $AD_CppString toCppString() {
    {
  return ConstantExpression(const CppString{CppString._codeUnits: const CppUserData{CppUserData.data: const <dynamic>[]}});
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
  $AB_CppList<int> list = $AB_CppList<int>.filled(3, 0);
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
  $AB_CppList<int> iterableList = $AB_CppArrayList<int>.fromCppArray($AA_CppApi.cppArrayConst(5, 1, 2, 3, 4, 5));
  assert(iterableList.first == 1);
  assert(iterableList.last == 5);
  assert(iterableList.length == 5);
  assert(iterableList.any(FunctionWrapper<bool Function(int)>([], (int element) { return (element > 3);}).call()));
  assert(!(iterableList.every(FunctionWrapper<bool Function(int)>([], (int element) { return (element < 3);}).call())));
  $AE_CppIterable<int> mappedList = iterableList.map(FunctionWrapper<int Function(int)>([], (int e) { return (e * 2);}).call());
  assert(mappedList.toList().toString() == <int>[2, 4, 6, 8, 10].toString());
  $AE_CppIterable<int> filteredList = iterableList.where(FunctionWrapper<bool Function(int)>([], (int e) { return (e % 2) == 0;}).call());
  assert(filteredList.toList().toString() == <int>[2, 4].toString());
  print("CppIterable 方法测试通过！");
  $AD_CppStringBuffer buffer = $AD_CppStringBuffer();
  buffer.write("Hello");
  buffer.write("World");
  print(buffer.toString());
  $AC_CppError error = $AC_CppError();
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

$AA_CppUserData cppUserDataEmpty = ConstantExpression(const CppUserData{CppUserData.data: const <dynamic>[]});

