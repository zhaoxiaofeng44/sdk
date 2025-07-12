import 'dart:math';

import 'Iterable.dart';

@pragma("wasm:entry-point")
class CppPointerArray {
  final dynamic _data;
  final int _length;
  CppPointerArray(this._length, dynamic data)
      : _data = data ?? cppCreatePointerArray(_length);

  int get length => _length;

  Object? getItem(int index) => cppGetPointerArrayItem(_data, index);

  void setItem(int index, Object? value) =>
      cppSetPointerArrayItem(_data, index, value);

  @pragma("cpp:native", r"CppApi::cppCreatePointerArray")
  static cppCreatePointerArray(int length) {
    return List<Object?>.filled(length, null, growable: true);
  }

  @pragma("cpp:native", r"CppApi::cppGetPointerArrayItem")
  static Object? cppGetPointerArrayItem(dynamic array, int index) {
    return array[index];
  }

  @pragma("cpp:native", r"CppApi::cppSetPointerArrayItem")
  static Object? cppSetPointerArrayItem(
      dynamic array, int index, Object? value) {
    return array[index] = value;
  }
}

class CppByteArray {
  final dynamic _data;
  final int _length;
  CppByteArray(this._length, dynamic data)
      : _data = data ?? cppCreateByteArray(_length);

  int get length => _length;

  int getItem(int index) => cppGetByteArrayItem(_data, index);

  void setItem(int index, int value) =>
      cppSetByteArrayItem(_data, index, value);

  @pragma("cpp:native", r"CppApi::cppCreateByteArray")
  static cppCreateByteArray(int length) {
    return List.filled(length, 0, growable: true);
  }

  @pragma("cpp:native", r"CppApi::cppGetByteArrayItem")
  static int cppGetByteArrayItem(dynamic array, int index) {
    return array[index];
  }

  @pragma("cpp:native", r"CppApi::cppSetByteArrayItem")
  static int cppSetByteArrayItem(dynamic array, int index, int value) {
    return array[index] = value;
  }
}

@pragma("wasm:entry-point")
@pragma("cpp:patch-factory", "List")
class CppList<E> extends CppIterable<E> implements List<E> {
  int _length;
  CppPointerArray _array;

  @pragma('wasm:entry-point')
  CppList.fromCppArray(CppPointerArray array)
      : _length = array.length,
        _array = array;

  CppList(int length, int capacity)
      : _length = length,
        _array = CppPointerArray(length, null);

  // 标准List工厂方法
  factory CppList.empty({bool growable = false}) {
    return growable ? CppList<E>(0, 0) : CppList<E>(0, 0);
  }

  factory CppList.filled(int length, E fill, {bool growable = false}) {
    var array = CppPointerArray(length, null);
    for (int i = 0; i < length; i++) {
      array.setItem(i, fill);
    }
    return CppList.fromCppArray(array);
  }

  factory CppList.from(Iterable elements, {bool growable = true}) {
    var length = elements.length;
    var array = growable
        ? CppPointerArray(length, null)
        : CppPointerArray(_getSuggestCapacity(length), null);
    int i = 0;
    for (var element in elements) {
      array.setItem(i++, element);
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
        ? CppPointerArray(length, null)
        : CppPointerArray(_getSuggestCapacity(length), null);
    for (int i = 0; i < length; i++) {
      array.setItem(i, generator(i));
    }
    return CppList.fromCppArray(array);
  }

  factory CppList.unmodifiable(Iterable elements) {
    var length = elements.length;
    var array = CppPointerArray(length, null);
    int i = 0;
    for (var element in elements) {
      array.setItem(i++, element as E);
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
    if (newLen > _array.length) {
      var newArray = CppPointerArray(_getSuggestCapacity(newLen), null);
      for (int i = 0; i < _array.length; i++) {
        newArray.setItem(i, _array.getItem(i));
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
  E operator [](int index) => _array.getItem(index) as E;

  @override
  void operator []=(int index, E value) => _array.setItem(index, value);

  @override
  void add(E value) {
    ensureCapacity(_length + 1);
    _array.setItem(_length++, value);
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
      if (test(_array.getItem(i) as E)) return true;
    }
    return false;
  }

  @override
  Map<int, E> asMap() {
    var map = <int, E>{};
    for (int i = 0; i < _length; i++) {
      map[i] = _array.getItem(i) as E;
    }
    return map;
  }

  @override
  List<R> cast<R>() {
    return List.castFrom<E, R>(this);
  }

  @override
  void clear() {
    _length = 0;
  }

  @override
  bool contains(Object? element) {
    for (int i = 0; i < _length; i++) {
      if (_array.getItem(i) == element) return true;
    }
    return false;
  }

  @override
  E elementAt(int index) => _array.getItem(index) as E;

  @override
  bool every(bool Function(E element) test) {
    for (int i = 0; i < _length; i++) {
      if (!test(_array.getItem(i) as E)) return false;
    }
    return true;
  }

  @override
  void fillRange(int start, int end, [E? fillValue]) {
    for (int i = start; i < end; i++) {
      _array.setItem(i, fillValue as E);
    }
  }

  @override
  E firstWhere(bool Function(E element) test, {E Function()? orElse}) {
    for (int i = 0; i < _length; i++) {
      if (test(_array.getItem(i) as E)) return _array.getItem(i) as E;
    }
    if (orElse != null) return orElse();
    throw StateError('No element');
  }

  @override
  T fold<T>(T initialValue, T Function(T previousValue, E element) combine) {
    var value = initialValue;
    for (int i = 0; i < _length; i++) {
      value = combine(value, _array.getItem(i) as E);
    }
    return value;
  }

  @override
  void forEach(void Function(E element) action) {
    for (int i = 0; i < _length; i++) {
      action(_array.getItem(i) as E);
    }
  }

  @override
  Iterable<E> getRange(int start, int end) {
    return CppList.from(
        Iterable.generate(end - start, (i) => _array.getItem(start + i)));
  }

  @override
  int indexOf(E element, [int start = 0]) {
    for (int i = start; i < _length; i++) {
      if (_array.getItem(i) == element) return i;
    }
    return -1;
  }

  @override
  int indexWhere(bool Function(E element) test, [int start = 0]) {
    for (int i = start; i < _length; i++) {
      if (test(_array.getItem(i) as E)) return i;
    }
    return -1;
  }

  @override
  void insert(int index, E element) {
    if (index < 0 || index > _length) throw RangeError.index(index, this);
    ensureCapacity(_length + 1);
    for (int i = _length; i > index; i--) {
      _array.setItem(i, _array.getItem(i - 1));
    }
    _array.setItem(index, element);
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
      _array.setItem(i + insertLength, _array.getItem(i));
    }

    for (int i = 0; i < insertLength; i++) {
      _array.setItem(index + i, elements[i]);
    }
    _length += insertLength;
  }

  @override
  E get first {
    if (_length == 0) throw StateError('No element');
    return _array.getItem(0) as E;
  }

  @override
  set first(E value) {
    if (_length == 0) throw StateError('No element');
    _array.setItem(0, value);
  }

  @override
  E get last {
    if (_length == 0) throw StateError('No element');
    return _array.getItem(_length - 1) as E;
  }

  @override
  set last(E value) {
    if (_length == 0) throw StateError('No element');
    _array.setItem(_length - 1, value);
  }

  @override
  E get single {
    if (_length == 0) throw StateError('No element');
    if (_length > 1) throw StateError('Too many elements');
    return _array.getItem(0) as E;
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
    return cppJoinListString(this._array._data, _length, separator);
  }

  @pragma("cpp:native", r"CppApi::cppJoinListString")
  static String cppJoinListString(
      dynamic strings, int length, String separator) {
    var list = <String>[];
    for (int i = 0; i < length; i++) {
      list.add(strings[i].toString());
    }
    return list.join(separator);
  }

  @override
  int lastIndexOf(E element, [int? start]) {
    var startIndex = start ?? _length - 1;
    for (int i = startIndex; i >= 0; i--) {
      if (_array.getItem(i) == element) return i;
    }
    return -1;
  }

  @override
  int lastIndexWhere(bool Function(E element) test, [int? start]) {
    var startIndex = start ?? _length - 1;
    for (int i = startIndex; i >= 0; i--) {
      if (test(_array.getItem(i) as E)) return i;
    }
    return -1;
  }

  @override
  E lastWhere(bool Function(E element) test, {E Function()? orElse}) {
    for (int i = _length - 1; i >= 0; i--) {
      if (test(_array.getItem(i) as E)) return _array.getItem(i) as E;
    }
    if (orElse != null) return orElse();
    throw StateError('No element');
  }

  @override
  E reduce(E Function(E value, E element) combine) {
    if (_length == 0) throw StateError('No element');
    var value = _array.getItem(0) as E;
    for (int i = 1; i < _length; i++) {
      value = combine(value, _array.getItem(i) as E);
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
    var element = _array.getItem(index);
    for (int i = index; i < _length - 1; i++) {
      _array.setItem(i, _array.getItem(i + 1));
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
      _array.setItem(i, _array.getItem(i + length));
    }
    _length -= length;
  }

  @override
  void removeWhere(bool Function(E element) test) {
    var writeIndex = 0;
    for (int readIndex = 0; readIndex < _length; readIndex++) {
      if (!test(_array.getItem(readIndex) as E)) {
        if (writeIndex != readIndex) {
          _array.setItem(writeIndex, _array.getItem(readIndex));
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
        _array.setItem(i + replacementLength - rangeLength, _array.getItem(i));
      }
    }

    for (int i = 0; i < replacementLength; i++) {
      _array.setItem(start + i, replacementList[i]);
    }

    _length += replacementLength - rangeLength;
  }

  @override
  void retainWhere(bool Function(E element) test) {
    var writeIndex = 0;
    for (int readIndex = 0; readIndex < _length; readIndex++) {
      if (test(_array.getItem(readIndex) as E)) {
        if (writeIndex != readIndex) {
          _array.setItem(writeIndex, _array.getItem(readIndex));
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
        _array.setItem(i, element);
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
      _array.setItem(i, iterator.current);
    }
  }

  @override
  void shuffle([Random? random]) {
    random ??= Random();
    for (int i = _length - 1; i > 0; i--) {
      var j = random.nextInt(i + 1);
      var temp = _array.getItem(i);
      _array.setItem(i, _array.getItem(j));
      _array.setItem(j, temp);
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
    E pivot = _array.getItem(high) as E;
    int i = low - 1;

    for (int j = low; j < high; j++) {
      E current = _array.getItem(j) as E;
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
    E temp = _array.getItem(i) as E;
    _array.setItem(i, _array.getItem(j));
    _array.setItem(j, temp);
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
    return CppList.from(
        Iterable.generate(endIndex - start, (i) => _array.getItem(start + i)));
  }

  @override
  List<E> toList({bool growable = true}) {
    return CppList.from(this, growable: growable);
  }

  @override
  Set<E> toSet() {
    return Set.from(this);
  }

  @override
  E singleWhere(bool Function(E element) test, {E Function()? orElse}) {
    E? result;
    bool found = false;
    for (int i = 0; i < _length; i++) {
      if (test(_array.getItem(i) as E)) {
        if (found) throw StateError('Too many elements');
        result = _array.getItem(i) as E;
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
      result.add(_array.getItem(i) as E);
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
    buffer.write(_array.getItem(0));
    for (int i = 1; i < _length; i++) {
      buffer.write(", ");
      buffer.write(_array.getItem(i));
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
class CppSet<E> extends CppIterable<E> implements Set<E> {
  final CppList<E> _list;

  @pragma('wasm:entry-point')
  CppSet.fromCppArray(CppPointerArray array)
      : _list = CppList.fromCppArray(array);

  CppSet([int capacity = 4]) : _list = CppList(0, capacity);

  // 标准Set工厂方法
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
    return Set.castFrom<E, R>(this);
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
    var retainSet = Set.from(elementsToRetain);
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
  Map<RK, RV> cast<RK, RV>() => Map.castFrom<K, V, RK, RV>(this);

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

@pragma("cpp:patch-class", "StringBuffer")
class CppStringBuffer {
  final CppList<String> _parts;

  CppStringBuffer() : _parts = CppList<String>(0, 16);

  // 标准StringBuffer方法
  void write(Object? obj) {
    _parts.add(obj.toString());
  }

  void writeAll(Iterable objects, [String separator = ""]) {
    var iterator = objects.iterator;
    if (iterator.moveNext()) {
      _parts.add(iterator.current.toString());
      while (iterator.moveNext()) {
        if (separator.isNotEmpty) {
          _parts.add(separator);
        }
        _parts.add(iterator.current.toString());
      }
    }
  }

  void writeCharCode(int charCode) {
    _parts.add(String.fromCharCode(charCode));
  }

  void writeln([Object? obj = ""]) {
    _parts.add(obj.toString());
    _parts.add('\n');
  }

  void clear() {
    _parts.clear();
  }

  @override
  String toString() {
    return _parts.join('');
  }

  int get length {
    return _parts.fold(0, (sum, part) => sum + part.length);
  }

  bool get isEmpty => _parts.isEmpty;

  bool get isNotEmpty => _parts.isNotEmpty;
}

void main() {
  print("=== 测试标准StringBuffer ===");
  StringBuffer sb = StringBuffer();
  sb.write("123");
  print(sb.toString());
  sb.write("456");
  print(sb.toString());
  sb.write("789");
  print(sb.toString());

  print("\n=== 测试CppStringBuffer ===");
  CppStringBuffer cppSb = CppStringBuffer();
  cppSb.write("123");
  print(cppSb.toString());
  cppSb.write("456");
  print(cppSb.toString());
  cppSb.write("789");
  print(cppSb.toString());

  print("\n=== 测试CppList ===");
  // 测试
  CppList<int> list = CppList<int>(0, 8);

  // 添加元素
  list.add(1);
  list.add(2);
  list.add(3);

  // 打印
  print(list); // [1, 2, 3]

  // 映射
  var doubled = list.map((e) => e * 2);
  print(doubled); // [2, 4, 6]

  // 过滤
  var evens = list.where((e) => e % 2 == 0);
  print(evens); // [2]

  CppSet<int> set = CppSet(2);
  set.add(1);
  set.add(2);
  set.add(3);
  set.add(1);
  print(set); // [1, 2, 3]

  var doubled2 = set.map((e) => e * 2);
  print(doubled2); // [2, 4, 6]

  CppMap<int, String> kk = CppMap<int, String>(8);
  kk[1] = "xxxx1";
  kk[2] = "xxxx2";
  kk[3] = "xxxx3";
  kk[4] = "xxxx4";

  CppList<String> list22 = CppList<String>(0, 8);

  // 添加元素
  list22.add("aaaa");
  list22.add("aaaa");
  list22.add("aaaa");
  print(list22.join(" "));

  // print("\n=== 测试CppPointerArray的新方法 ===");
  // // 测试createArrayDirect方法
  // var array1 = CppPointerArray.createArrayDirect(5);
  // print("createArrayDirect(5): $array1");

  // // 测试createArrayRef方法
  // var array2 = CppPointerArray.createArrayRef(3);
  // print("createArrayRef(3): $array2");

  // // 验证它们和原来的cppCreatePointerArray功能一致
  // var array3 = CppPointerArray.cppCreatePointerArray(4);
  // print("cppCreatePointerArray(4): $array3");
}
