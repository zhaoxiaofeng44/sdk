import 'dart:math';
import 'api.dart';
import 'Iterable.dart';

@pragma("wasm:entry-point")
@pragma("cpp:patch-factory", "List")
@pragma('cpp:patch', 'List')
class CppList<E> extends CppIterable<E> implements List<E> {
  int _length;
  CppPointerArray _array;

  @pragma('wasm:entry-point')
  CppList.fromCppArray(CppPointerArray array)
      : _length = CppApi.cppGetPointerArrayLength(array),
        _array = array;

  CppList(int length, int capacity)
      : _length = length,
        _array = CppApi.cppCreatePointerArray(length);

  // 标准List工厂方法
  factory CppList.empty({bool growable = false}) {
    return growable ? CppList<E>(0, 0) : CppList<E>(0, 0);
  }

  factory CppList.filled(int length, E fill, {bool growable = false}) {
    var array = CppApi.cppCreatePointerArray(length);
    for (int i = 0; i < length; i++) {
      CppApi.cppSetPointerArrayItem(array, i, fill);
    }
    return CppList.fromCppArray(array);
  }

  factory CppList.from(Iterable elements, {bool growable = true}) {
    var length = elements.length;
    var array = growable
        ? CppApi.cppCreatePointerArray(length)
        : CppApi.cppCreatePointerArray(_getSuggestCapacity(length));
    int i = 0;
    for (var element in elements) {
      CppApi.cppSetPointerArrayItem(array, i++, element);
    }
    return CppList.fromCppArray(array);
  }

  factory CppList.of(Iterable<E> elements, {bool growable = true}) =>
      CppList.from(elements, growable: growable);

  factory CppList.generate(
    int length,
    E Function(int index) generator, {
    bool growable = true,
  }) {
    var array = growable
        ? CppApi.cppCreatePointerArray(length)
        : CppApi.cppCreatePointerArray(_getSuggestCapacity(length));
    for (int i = 0; i < length; i++) {
      CppApi.cppSetPointerArrayItem(array, i, generator(i));
    }
    return CppList.fromCppArray(array);
  }

  factory CppList.unmodifiable(Iterable elements) {
    var length = elements.length;
    var array = CppApi.cppCreatePointerArray(length);
    int i = 0;
    for (var element in elements) {
      CppApi.cppSetPointerArrayItem(array, i++, element as E);
    }
    return CppList.fromCppArray(array);
  }

  static int _getSuggestCapacity(int newLen) {
    return newLen > 256
        ? newLen
        : pow(2, (log(newLen) / log(2)).ceil()).toInt();
  }

  // List接口实现
  @override
  int get length => _length;

  void ensureCapacity(int newLen) {
    if (newLen > CppApi.cppGetPointerArrayLength(_array)) {
      var newArray = CppApi.cppCreatePointerArray(_getSuggestCapacity(newLen));
      for (int i = 0; i < CppApi.cppGetPointerArrayLength(_array); i++) {
        CppApi.cppSetPointerArrayItem(
            newArray, i, CppApi.cppGetPointerArrayItem(_array, i));
      }
      _array = newArray;
    }
  }

  @override
  set length(int newLen) {
    ensureCapacity(newLen);
    _length = newLen;
  }

  @override
  E operator [](int index) => CppApi.cppGetPointerArrayItem(_array, index) as E;

  @override
  void operator []=(int index, E value) =>
      CppApi.cppSetPointerArrayItem(_array, index, value);

  @override
  void add(E value) {
    ensureCapacity(_length + 1);
    CppApi.cppSetPointerArrayItem(_array, _length++, value);
  }

  @override
  void addAll(Iterable<E> iterable) {
    for (var element in iterable) {
      add(element);
    }
  }

  @override
  bool any(bool Function(E element) test) {
    for (int i = 0; i < _length; i++) {
      if (test(CppApi.cppGetPointerArrayItem(_array, i) as E)) return true;
    }
    return false;
  }

  @override
  Map<int, E> asMap() {
    var map = <int, E>{};
    for (int i = 0; i < _length; i++) {
      map[i] = CppApi.cppGetPointerArrayItem(_array, i) as E;
    }
    return map;
  }

  @override
  List<R> cast<R>() {
    return CppList.castFrom<E, R>(this);
  }

  // 静态方法 - 对应Dart List类的静态方法
  static List<R> castFrom<S, R>(List<S> source) {
    var result = CppList<R>(0, 4);
    for (var element in source) {
      result.add(element as R);
    }
    return result;
  }

  static List<R> castFromWithFactory<S, R>(
      List<S> source, List<R> Function() newList) {
    var result = newList();
    for (var element in source) {
      result.add(element as R);
    }
    return result;
  }

  @override
  void clear() {
    _length = 0;
  }

  @override
  bool contains(Object? element) {
    for (int i = 0; i < _length; i++) {
      if (CppApi.cppGetPointerArrayItem(_array, i) == element) return true;
    }
    return false;
  }

  @override
  E elementAt(int index) => CppApi.cppGetPointerArrayItem(_array, index) as E;

  @override
  bool every(bool Function(E element) test) {
    for (int i = 0; i < _length; i++) {
      if (!test(CppApi.cppGetPointerArrayItem(_array, i) as E)) return false;
    }
    return true;
  }

  @override
  void fillRange(int start, int end, [E? fillValue]) {
    for (int i = start; i < end; i++) {
      CppApi.cppSetPointerArrayItem(_array, i, fillValue as E);
    }
  }

  @override
  E firstWhere(bool Function(E element) test, {E Function()? orElse}) {
    for (int i = 0; i < _length; i++) {
      if (test(CppApi.cppGetPointerArrayItem(_array, i) as E)) {
        return CppApi.cppGetPointerArrayItem(_array, i) as E;
      }
    }
    if (orElse != null) return orElse();
    throw StateError('No element');
  }

  @override
  T fold<T>(T initialValue, T Function(T previousValue, E element) combine) {
    var value = initialValue;
    for (int i = 0; i < _length; i++) {
      value = combine(value, CppApi.cppGetPointerArrayItem(_array, i) as E);
    }
    return value;
  }

  @override
  void forEach(void Function(E element) action) {
    for (int i = 0; i < _length; i++) {
      action(CppApi.cppGetPointerArrayItem(_array, i) as E);
    }
  }

  @override
  Iterable<E> getRange(int start, int end) {
    return CppList.from(Iterable.generate(
        end - start, (i) => CppApi.cppGetPointerArrayItem(_array, start + i)));
  }

  @override
  int indexOf(E element, [int start = 0]) {
    for (int i = start; i < _length; i++) {
      if (CppApi.cppGetPointerArrayItem(_array, i) == element) return i;
    }
    return -1;
  }

  @override
  int indexWhere(bool Function(E element) test, [int start = 0]) {
    for (int i = start; i < _length; i++) {
      if (test(CppApi.cppGetPointerArrayItem(_array, i) as E)) return i;
    }
    return -1;
  }

  @override
  void insert(int index, E element) {
    if (index < 0 || index > _length) throw RangeError.index(index, this);
    ensureCapacity(_length + 1);
    for (int i = _length; i > index; i--) {
      CppApi.cppSetPointerArrayItem(
          _array, i, CppApi.cppGetPointerArrayItem(_array, i - 1));
    }
    CppApi.cppSetPointerArrayItem(_array, index, element);
    _length++;
  }

  @override
  void insertAll(int index, Iterable<E> iterable) {
    if (index < 0 || index > _length) throw RangeError.index(index, this);
    var elements = iterable.toList();
    var insertLength = elements.length;
    if (insertLength == 0) return;

    ensureCapacity(_length + insertLength);

    for (int i = _length - 1; i >= index; i--) {
      CppApi.cppSetPointerArrayItem(
          _array, i + insertLength, CppApi.cppGetPointerArrayItem(_array, i));
    }

    for (int i = 0; i < insertLength; i++) {
      CppApi.cppSetPointerArrayItem(_array, index + i, elements[i]);
    }
    _length += insertLength;
  }

  @override
  E get first {
    if (_length == 0) throw StateError('No element');
    return CppApi.cppGetPointerArrayItem(_array, 0) as E;
  }

  @override
  set first(E value) {
    if (_length == 0) throw StateError('No element');
    CppApi.cppSetPointerArrayItem(_array, 0, value);
  }

  @override
  E get last {
    if (_length == 0) throw StateError('No element');
    return CppApi.cppGetPointerArrayItem(_array, _length - 1) as E;
  }

  @override
  set last(E value) {
    if (_length == 0) throw StateError('No element');
    CppApi.cppSetPointerArrayItem(_array, _length - 1, value);
  }

  @override
  E get single {
    if (_length == 0) throw StateError('No element');
    if (_length > 1) throw StateError('Too many elements');
    return CppApi.cppGetPointerArrayItem(_array, 0) as E;
  }

  @override
  bool get isEmpty => _length == 0;

  @override
  bool get isNotEmpty => _length != 0;

  @override
  Iterator<E> get iterator => _CppListIterator(this);

  @override
  String join([String separator = ""]) {
    if (_length == 0) return "";
    return CppApi.cppJoinListString(this._array, separator);
  }

  @override
  int lastIndexOf(E element, [int? start]) {
    var startIndex = start ?? _length - 1;
    for (int i = startIndex; i >= 0; i--) {
      if (CppApi.cppGetPointerArrayItem(_array, i) == element) return i;
    }
    return -1;
  }

  @override
  int lastIndexWhere(bool Function(E element) test, [int? start]) {
    var startIndex = start ?? _length - 1;
    for (int i = startIndex; i >= 0; i--) {
      if (test(CppApi.cppGetPointerArrayItem(_array, i) as E)) return i;
    }
    return -1;
  }

  @override
  E lastWhere(bool Function(E element) test, {E Function()? orElse}) {
    for (int i = _length - 1; i >= 0; i--) {
      if (test(CppApi.cppGetPointerArrayItem(_array, i) as E)) {
        return CppApi.cppGetPointerArrayItem(_array, i) as E;
      }
    }
    if (orElse != null) return orElse();
    throw StateError('No element');
  }

  @override
  E reduce(E Function(E value, E element) combine) {
    if (_length == 0) throw StateError('No element');
    var value = CppApi.cppGetPointerArrayItem(_array, 0) as E;
    for (int i = 1; i < _length; i++) {
      value = combine(value, CppApi.cppGetPointerArrayItem(_array, i) as E);
    }
    return value;
  }

  @override
  bool remove(Object? value) {
    var index = indexOf(value as E);
    if (index != -1) {
      removeAt(index);
      return true;
    }
    return false;
  }

  @override
  E removeAt(int index) {
    if (index < 0 || index >= _length) throw RangeError.index(index, this);
    var element = CppApi.cppGetPointerArrayItem(_array, index);
    for (int i = index; i < _length - 1; i++) {
      CppApi.cppSetPointerArrayItem(
          _array, i, CppApi.cppGetPointerArrayItem(_array, i + 1));
    }
    _length--;
    return element as E;
  }

  @override
  E removeLast() {
    if (_length == 0) throw StateError('No element');
    return removeAt(_length - 1);
  }

  @override
  void removeRange(int start, int end) {
    if (start < 0 || start > _length || end < start || end > _length) {
      throw RangeError.range(start, 0, _length);
    }
    var length = end - start;
    for (int i = start; i < _length - length; i++) {
      CppApi.cppSetPointerArrayItem(
          _array, i, CppApi.cppGetPointerArrayItem(_array, i + length));
    }
    _length -= length;
  }

  @override
  void removeWhere(bool Function(E element) test) {
    var writeIndex = 0;
    for (int readIndex = 0; readIndex < _length; readIndex++) {
      if (!test(CppApi.cppGetPointerArrayItem(_array, readIndex) as E)) {
        if (writeIndex != readIndex) {
          CppApi.cppSetPointerArrayItem(_array, writeIndex,
              CppApi.cppGetPointerArrayItem(_array, readIndex));
        }
        writeIndex++;
      }
    }
    _length = writeIndex;
  }

  @override
  void replaceRange(int start, int end, Iterable<E> replacements) {
    if (start < 0 || start > _length || end < start || end > _length) {
      throw RangeError.range(start, 0, _length);
    }
    var replacementList = replacements.toList();
    var replacementLength = replacementList.length;
    var rangeLength = end - start;

    if (replacementLength > rangeLength) {
      ensureCapacity(_length + replacementLength - rangeLength);
    }

    if (replacementLength != rangeLength) {
      for (int i = _length - 1; i >= end; i--) {
        CppApi.cppSetPointerArrayItem(
            _array,
            i + replacementLength - rangeLength,
            CppApi.cppGetPointerArrayItem(_array, i));
      }
    }

    for (int i = 0; i < replacementLength; i++) {
      CppApi.cppSetPointerArrayItem(_array, start + i, replacementList[i]);
    }

    _length += replacementLength - rangeLength;
  }

  @override
  void retainWhere(bool Function(E element) test) {
    var writeIndex = 0;
    for (int readIndex = 0; readIndex < _length; readIndex++) {
      if (test(CppApi.cppGetPointerArrayItem(_array, readIndex) as E)) {
        if (writeIndex != readIndex) {
          CppApi.cppSetPointerArrayItem(_array, writeIndex,
              CppApi.cppGetPointerArrayItem(_array, readIndex));
        }
        writeIndex++;
      }
    }
    _length = writeIndex;
  }

  @override
  void setAll(int index, Iterable<E> iterable) {
    if (index < 0 || index > _length) throw RangeError.index(index, this);
    var i = index;
    for (var element in iterable) {
      if (i >= _length) {
        add(element);
      } else {
        CppApi.cppSetPointerArrayItem(_array, i, element);
      }
      i++;
    }
  }

  @override
  void setRange(int start, int end, Iterable<E> iterable, [int skipCount = 0]) {
    if (start < 0 || start > _length || end < start || end > _length) {
      throw RangeError.range(start, 0, _length);
    }
    var iterator = iterable.iterator;
    for (int i = 0; i < skipCount; i++) {
      if (!iterator.moveNext()) return;
    }
    for (int i = start; i < end; i++) {
      if (!iterator.moveNext()) break;
      CppApi.cppSetPointerArrayItem(_array, i, iterator.current);
    }
  }

  @override
  void shuffle([Random? random]) {
    random ??= Random();
    for (int i = _length - 1; i > 0; i--) {
      var j = random.nextInt(i + 1);
      var temp = CppApi.cppGetPointerArrayItem(_array, i);
      CppApi.cppSetPointerArrayItem(
          _array, i, CppApi.cppGetPointerArrayItem(_array, j));
      CppApi.cppSetPointerArrayItem(_array, j, temp);
    }
  }

  @override
  void sort([int Function(E a, E b)? compare]) {
    if (_length <= 1) return;

    // 快速排序实现
    _quickSort(0, _length - 1, compare);
  }

  void _quickSort(int low, int high, int Function(E a, E b)? compare) {
    if (low < high) {
      int pi = _partition(low, high, compare);
      _quickSort(low, pi - 1, compare);
      _quickSort(pi + 1, high, compare);
    }
  }

  int _partition(int low, int high, int Function(E a, E b)? compare) {
    E pivot = CppApi.cppGetPointerArrayItem(_array, high) as E;
    int i = low - 1;

    for (int j = low; j < high; j++) {
      E current = CppApi.cppGetPointerArrayItem(_array, j) as E;
      bool shouldSwap;

      if (compare != null) {
        shouldSwap = compare(current, pivot) <= 0;
      } else {
        // 默认比较，假设E实现了Comparable
        shouldSwap = (current as Comparable).compareTo(pivot) <= 0;
      }

      if (shouldSwap) {
        i++;
        _swap(i, j);
      }
    }

    _swap(i + 1, high);
    return i + 1;
  }

  void _swap(int i, int j) {
    E temp = CppApi.cppGetPointerArrayItem(_array, i) as E;
    CppApi.cppSetPointerArrayItem(
        _array, i, CppApi.cppGetPointerArrayItem(_array, j));
    CppApi.cppSetPointerArrayItem(_array, j, temp);
  }

  @override
  List<E> sublist(int start, [int? end]) {
    var endIndex = end ?? _length;
    if (start < 0 ||
        start > _length ||
        endIndex < start ||
        endIndex > _length) {
      throw RangeError.range(start, 0, _length);
    }
    return CppList.from(Iterable.generate(endIndex - start,
        (i) => CppApi.cppGetPointerArrayItem(_array, start + i)));
  }

  @override
  List<E> toList({bool growable = true}) {
    return CppList.from(this, growable: growable);
  }

  @override
  Set<E> toSet() {
    return CppSet.from(this);
  }

  @override
  E singleWhere(bool Function(E element) test, {E Function()? orElse}) {
    E? result;
    bool found = false;
    for (int i = 0; i < _length; i++) {
      if (test(CppApi.cppGetPointerArrayItem(_array, i) as E)) {
        if (found) throw StateError('Too many elements');
        result = CppApi.cppGetPointerArrayItem(_array, i) as E;
        found = true;
      }
    }
    if (found) return result!;
    if (orElse != null) return orElse();
    throw StateError('No element');
  }

  @override
  List<E> operator +(List<E> other) {
    var result = CppList<E>(0, _length + other.length);
    for (int i = 0; i < _length; i++) {
      result.add(CppApi.cppGetPointerArrayItem(_array, i) as E);
    }
    for (var element in other) {
      result.add(element);
    }
    return result;
  }

  @override
  String toString() {
    if (_length == 0) return "[]";
    var buffer = StringBuffer("[");
    buffer.write(CppApi.cppGetPointerArrayItem(_array, 0));
    for (int i = 1; i < _length; i++) {
      buffer.write(", ");
      buffer.write(CppApi.cppGetPointerArrayItem(_array, i));
    }
    buffer.write("]");
    return buffer.toString();
  }
}

class _CppListIterator<E> implements Iterator<E> {
  final CppList<E> _list;
  int _index = -1;

  _CppListIterator(this._list);

  @override
  E get current => _list[_index];

  @override
  bool moveNext() {
    _index++;
    return _index < _list.length;
  }
}

@pragma("cpp:patch-factory", "Set")
@pragma('cpp:patch', 'Set')
class CppSet<E> extends CppIterable<E> implements Set<E> {
  final CppList<E> _list;

  @pragma('wasm:entry-point')
  CppSet.fromCppArray(CppPointerArray array)
      : _list = CppList.fromCppArray(array);

  CppSet([int capacity = 4]) : _list = CppList(0, capacity);

  // 标准Set工厂方法 - 对应Dart Set类的所有factory方法
  factory CppSet.identity() => CppSet<E>(4);

  factory CppSet.from(Iterable elements) {
    var set = CppSet<E>();
    for (var element in elements) {
      set.add(element as E);
    }
    return set;
  }

  factory CppSet.of(Iterable<E> elements) => CppSet.from(elements);

  factory CppSet.unmodifiable(Iterable<E> elements) {
    var set = CppSet<E>();
    for (var element in elements) {
      set.add(element);
    }
    return set;
  }

  // 静态方法 - 对应Dart Set类的静态方法
  static Set<R> castFrom<S, R>(Set<S> source) {
    var result = CppSet<R>();
    for (var element in source) {
      result.add(element as R);
    }
    return result;
  }

  static Set<R> castFromWithFactory<S, R>(
      Set<S> source, Set<R> Function() newSet) {
    var result = newSet();
    for (var element in source) {
      result.add(element as R);
    }
    return result;
  }

  // Set接口实现
  @override
  bool add(E value) {
    if (contains(value)) {
      return false;
    }
    _list.add(value);
    return true;
  }

  @override
  void addAll(Iterable<E> elements) {
    for (var element in elements) {
      add(element);
    }
  }

  @override
  Set<R> cast<R>() {
    return CppSet.castFrom<E, R>(this);
  }

  @override
  void clear() {
    _list.clear();
  }

  @override
  bool contains(Object? element) {
    for (var i = 0; i < _list.length; i++) {
      if (element == _list[i]) {
        return true;
      }
    }
    return false;
  }

  @override
  bool containsAll(Iterable<Object?> other) {
    for (var element in other) {
      if (!contains(element)) return false;
    }
    return true;
  }

  @override
  Set<E> difference(Set<Object?> other) {
    var result = CppSet<E>();
    for (var element in _list) {
      if (!other.contains(element)) {
        result.add(element);
      }
    }
    return result;
  }

  @override
  E elementAt(int index) => _list.elementAt(index);

  @override
  Set<E> intersection(Set<Object?> other) {
    var result = CppSet<E>();
    for (var element in _list) {
      if (other.contains(element)) {
        result.add(element);
      }
    }
    return result;
  }

  @override
  E get first {
    if (_list.isEmpty) throw StateError('No element');
    return _list.first;
  }

  @override
  E get last {
    if (_list.isEmpty) throw StateError('No element');
    return _list.last;
  }

  @override
  E get single {
    if (_list.isEmpty) throw StateError('No element');
    if (_list.length > 1) throw StateError('Too many elements');
    return _list.single;
  }

  @override
  bool get isEmpty => _list.isEmpty;

  @override
  bool get isNotEmpty => _list.isNotEmpty;

  @override
  Iterator<E> get iterator => _list.iterator;

  @override
  int get length => _list.length;

  @override
  E? lookup(Object? element) {
    for (var i = 0; i < _list.length; i++) {
      if (element == _list[i]) {
        return _list[i];
      }
    }
    return null;
  }

  @override
  bool remove(Object? value) {
    return _list.remove(value);
  }

  @override
  void removeAll(Iterable<Object?> elementsToRemove) {
    for (var element in elementsToRemove) {
      remove(element);
    }
  }

  @override
  void removeWhere(bool Function(E element) test) {
    _list.removeWhere(test);
  }

  @override
  void retainAll(Iterable<Object?> elementsToRetain) {
    var retainSet = CppSet.from(elementsToRetain);
    removeWhere((element) => !retainSet.contains(element));
  }

  @override
  void retainWhere(bool Function(E element) test) {
    _list.retainWhere(test);
  }

  @override
  Set<E> union(Set<E> other) {
    var result = CppSet<E>();
    result.addAll(this);
    result.addAll(other);
    return result;
  }

  @override
  String toString() {
    if (_list.isEmpty) return "{}";
    var buffer = StringBuffer("{");
    var iterator = _list.iterator;
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

@pragma("cpp:patch-factory", "Map")
@pragma('cpp:patch', 'Map')
class CppMap<K, V> implements Map<K, V> {
  final CppList<MapEntry<K, V>> _list;

  @pragma('wasm:entry-point')
  CppMap.fromCppArray(CppPointerArray array)
      : _list = CppList.fromCppArray(array);

  CppMap([int capacity = 4]) : _list = CppList(0, capacity);

  // 标准Map工厂方法
  factory CppMap.identity() => CppMap<K, V>();

  factory CppMap.from(Map other) => CppMap.unmodifiable(other);

  factory CppMap.of(Map<K, V> other) => CppMap.fromEntries(other.entries);

  factory CppMap.unmodifiable(Map<dynamic, dynamic> other) {
    var map = CppMap<K, V>();
    other.forEach((key, value) {
      map[key as K] = value as V;
    });
    return map;
  }

  factory CppMap.fromIterable(
    Iterable iterable, {
    K Function(dynamic element)? key,
    V Function(dynamic element)? value,
  }) {
    var map = CppMap<K, V>();
    for (var element in iterable) {
      var k = key?.call(element) ?? element;
      var v = value?.call(element) ?? element;
      map[k] = v;
    }
    return map;
  }

  factory CppMap.fromIterables(Iterable<K> keys, Iterable<V> values) {
    var map = CppMap<K, V>();
    var keyIter = keys.iterator;
    var valueIter = values.iterator;
    while (keyIter.moveNext() && valueIter.moveNext()) {
      map[keyIter.current] = valueIter.current;
    }
    return map;
  }

  factory CppMap.fromEntries(Iterable<MapEntry<K, V>> entries) {
    var map = CppMap<K, V>();
    for (var entry in entries) {
      map[entry.key] = entry.value;
    }
    return map;
  }

  // Map接口实现
  @override
  V? operator [](Object? key) {
    for (var entry in _list) {
      if (entry.key == key) {
        return entry.value;
      }
    }
    return null;
  }

  @override
  void operator []=(K key, V value) {
    for (var i = 0; i < _list.length; i++) {
      if (_list[i].key == key) {
        _list[i] = MapEntry(key, value);
        return;
      }
    }
    _list.add(MapEntry(key, value));
  }

  @override
  void addAll(Map<K, V> other) {
    other.forEach((k, v) => this[k] = v);
  }

  @override
  void addEntries(Iterable<MapEntry<K, V>> entries) {
    for (var entry in entries) {
      this[entry.key] = entry.value;
    }
  }

  @override
  Map<RK, RV> cast<RK, RV>() => CppMap.castFrom<K, V, RK, RV>(this);

  // 静态方法 - 对应Dart Map类的静态方法
  static Map<RK, RV> castFrom<K, V, RK, RV>(Map<K, V> source) {
    var result = CppMap<RK, RV>();
    source.forEach((key, value) {
      result[key as RK] = value as RV;
    });
    return result;
  }

  static Map<RK, RV> castFromWithFactory<K, V, RK, RV>(
      Map<K, V> source, Map<RK, RV> Function() newMap) {
    var result = newMap();
    source.forEach((key, value) {
      result[key as RK] = value as RV;
    });
    return result;
  }

  @override
  void clear() {
    _list.clear();
  }

  @override
  bool containsKey(Object? key) {
    for (var entry in _list) {
      if (entry.key == key) return true;
    }
    return false;
  }

  @override
  bool containsValue(Object? value) {
    for (var entry in _list) {
      if (entry.value == value) return true;
    }
    return false;
  }

  @override
  Iterable<MapEntry<K, V>> get entries => _list;

  @override
  void forEach(void Function(K key, V value) action) {
    for (var entry in _list) {
      action(entry.key, entry.value);
    }
  }

  @override
  bool get isEmpty => _list.isEmpty;

  @override
  bool get isNotEmpty => _list.isNotEmpty;

  @override
  Iterable<K> get keys => _list.map((e) => e.key);

  @override
  int get length => _list.length;

  @override
  V putIfAbsent(K key, V Function() ifAbsent) {
    for (var entry in _list) {
      if (entry.key == key) return entry.value;
    }
    var v = ifAbsent();
    _list.add(MapEntry(key, v));
    return v;
  }

  @override
  V? remove(Object? key) {
    for (var i = 0; i < _list.length; i++) {
      if (_list[i].key == key) {
        var v = _list[i].value;
        for (var j = i; j < _list.length - 1; j++) {
          _list[j] = _list[j + 1];
        }
        _list.length = _list.length - 1;
        return v;
      }
    }
    return null;
  }

  @override
  void removeWhere(bool Function(K key, V value) test) {
    int i = 0;
    while (i < _list.length) {
      var entry = _list[i];
      if (test(entry.key, entry.value)) {
        remove(entry.key);
      } else {
        i++;
      }
    }
  }

  @override
  V update(K key, V Function(V value) update, {V Function()? ifAbsent}) {
    for (var i = 0; i < _list.length; i++) {
      if (_list[i].key == key) {
        var newValue = update(_list[i].value);
        _list[i] = MapEntry(key, newValue);
        return newValue;
      }
    }
    if (ifAbsent != null) {
      var v = ifAbsent();
      _list.add(MapEntry(key, v));
      return v;
    }
    throw ArgumentError('Key not found');
  }

  @override
  void updateAll(V Function(K key, V value) update) {
    for (var i = 0; i < _list.length; i++) {
      var entry = _list[i];
      _list[i] = MapEntry(entry.key, update(entry.key, entry.value));
    }
  }

  @override
  Iterable<V> get values => _list.map((e) => e.value);

  @override
  Map<K2, V2> map<K2, V2>(MapEntry<K2, V2> Function(K key, V value) transform) {
    var result = CppMap<K2, V2>();
    for (var entry in _list) {
      var newEntry = transform(entry.key, entry.value);
      result[newEntry.key] = newEntry.value;
    }
    return result;
  }

  @override
  String toString() {
    if (_list.isEmpty) return '{}';
    var buffer = StringBuffer('{');
    var iterator = _list.iterator;
    if (iterator.moveNext()) {
      buffer.write('${iterator.current.key}: ${iterator.current.value}');
      while (iterator.moveNext()) {
        buffer.write(', ${iterator.current.key}: ${iterator.current.value}');
      }
    }
    buffer.write('}');
    return buffer.toString();
  }
}
