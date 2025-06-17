import 'dart:math';

// class CppWasmArray<T> {
//   final List<T?> _data;
//   CppWasmArray(int capacity)
//       : _data = List.empty(growable: true)..length = capacity;
//   int getLength() => _data.length;
//   void setLength(int len) => _data.length = len;
//   T getItem(int index) => _data[index]!;
//   void setItem(int index, T value) => _data[index] = value;
// }

// class CppUnit8Array {
//   final int length;
//   final CppWasmArray<int> _array;
//   CppUnit8Array(this.length) : _array = CppWasmArray((length / 4).ceil()) {
//     for (var i = 0; i < _array.getLength(); i++) {
//       _array.setItem(i, 0);
//     }
//   }

//   int operator [](int index) {
//     var pos = (index / 4).floor();
//     int shift = (index % 4) * 8;
//     return (_array.getItem(pos) >> shift) & 0xff;
//   }

//   void operator []=(int index, int value) {
//     var pos = (index / 4).floor();
//     int shift = (index % 4) * 8;
//     int mask = ~(0xFF << shift);
//     int clearedValue = _array.getItem(pos) & mask;
//     _array.setItem(pos, clearedValue | (value << shift));
//   }
// }

// external CppWasmArray cppArrayNew(int length);

// external CppWasmArray cppArrayGrow(
//     List<Object?> array, int length, int newLength);

CppWasmArray cppArrayNew(int length) {
  List<Object?> array = List<Object?>.filled(length, null);
  return CppWasmArray(length, array);
}

CppWasmArray cppArrayGrow(List<Object?> array, int length, int newLength) {
  List<Object?> newArray = List<Object?>.filled(newLength, null);
  for (int i = 0; i < length; i++) {
    newArray[i] = array[i];
  }
  return CppWasmArray(newLength, newArray);
}

class CppUnit8Array {
  final int length;
  final List<int> _array;
  CppUnit8Array(this.length, this._array);

  int operator [](int index) {
    var pos = (index / 4).floor();
    int shift = (index % 4) * 8;
    return (_array[pos] >> shift) & 0xff;
  }

  void operator []=(int index, int value) {
    var pos = (index / 4).floor();
    int shift = (index % 4) * 8;
    int mask = ~(0xFF << shift);
    int clearedValue = _array[pos] & mask;
    _array[pos] = clearedValue | (value << shift);
  }
}

class CppWasmArray {
  final int length;
  final List<Object?> data;
  CppWasmArray(this.length, this.data);

  Object? operator [](int index) {
    return data[index];
  }

  void operator []=(int index, Object? value) {
    data[index] = value;
  }
}

int _getSuggestCapacity(int newLen) {
  return pow(2, ((log(newLen) / log(2)) + 1).ceil()).toInt();
}

@pragma("wasm:entry-point")
class CppWasmList<E> implements List<E> {
  int _length;
  CppWasmArray _array;

  CppWasmList.fromCppWasmArray(CppWasmArray array, int length)
      : _length = length,
        _array = array;

  CppWasmList(int length, int capacity)
      : _length = length,
        _array = cppArrayNew(capacity);

  factory CppWasmList.empty({bool growable = false}) {
    return growable ? CppWasmList<E>(0, 0) : CppWasmList<E>(0, 0);
  }

  factory CppWasmList.filled(int length, E fill, {bool growable = false}) {
    var array = growable
        ? cppArrayNew(length)
        : cppArrayNew(_getSuggestCapacity(length));
    for (int i = 0; i < length; i++) {
      array[i] = fill;
    }
    return CppWasmList.fromCppWasmArray(array, length);
  }

  factory CppWasmList.from(Iterable elements, {bool growable = true}) {
    var length = elements.length;
    var array = growable
        ? cppArrayNew(length)
        : cppArrayNew(_getSuggestCapacity(length));
    int i = 0;
    for (var element in elements) {
      array[i++] = element;
    }
    return CppWasmList.fromCppWasmArray(array, length);
  }

  factory CppWasmList.of(Iterable<E> elements, {bool growable = true}) =>
      CppWasmList.from(elements, growable: growable);

  factory CppWasmList.generate(
    int length,
    E Function(int index) generator, {
    bool growable = true,
  }) {
    var array = growable
        ? cppArrayNew(length)
        : cppArrayNew(_getSuggestCapacity(length));
    for (int i = 0; i < length; i++) {
      array[i] = generator(i);
    }
    return CppWasmList.fromCppWasmArray(array, length);
  }

  factory CppWasmList.unmodifiable(Iterable elements) {
    var length = elements.length;
    var array = cppArrayNew(_getSuggestCapacity(length));
    int i = 0;
    for (var element in elements) {
      array[i++] = element as E;
    }
    return CppWasmList.fromCppWasmArray(array, length);
  }

  @override
  E operator [](int index) => _array[index] as E;

  @override
  void operator []=(int index, E value) => _array[index] = value;

  @override
  List<E> operator +(List<E> other) {
    var result = CppWasmList<E>(length + other.length, length + other.length);
    for (var i = 0; i < length; i++) {
      result[i] = this[i];
    }
    for (var i = 0; i < other.length; i++) {
      result[length + i] = other[i];
    }
    return result;
  }

  @override
  void add(E value) {
    int index = length;
    length++;
    _array[index] = value;
  }

  @override
  void addAll(Iterable<E> iterable) {
    for (var element in iterable) {
      add(element);
    }
  }

  @override
  bool any(bool Function(E element) test) {
    for (var i = 0; i < length; i++) {
      if (test(this[i])) return true;
    }
    return false;
  }

  @override
  Map<int, E> asMap() {
    return Map.fromEntries(
        List.generate(length, (index) => MapEntry(index, this[index])));
  }

  @override
  List<R> cast<R>() => CppWasmList<R>.from(this);

  @override
  void clear() {
    _length = 0;
  }

  @override
  bool contains(Object? element) {
    for (var i = 0; i < length; i++) {
      if (this[i] == element) return true;
    }
    return false;
  }

  @override
  E elementAt(int index) => this[index];

  @override
  bool every(bool Function(E element) test) {
    for (var i = 0; i < length; i++) {
      if (!test(this[i])) return false;
    }
    return true;
  }

  @override
  Iterable<T> expand<T>(Iterable<T> Function(E element) f) {
    return toList().expand(f);
  }

  @override
  void fillRange(int start, int end, [E? fillValue]) {
    for (var i = start; i < end; i++) {
      this[i] = fillValue as E;
    }
  }

  @override
  E firstWhere(bool Function(E element) test, {E Function()? orElse}) {
    for (var i = 0; i < length; i++) {
      if (test(this[i])) return this[i];
    }
    if (orElse != null) return orElse();
    throw StateError('No element');
  }

  @override
  T fold<T>(T initialValue, T Function(T previousValue, E element) combine) {
    var value = initialValue;
    for (var i = 0; i < length; i++) {
      value = combine(value, this[i]);
    }
    return value;
  }

  @override
  Iterable<E> followedBy(Iterable<E> other) => [...this, ...other];

  @override
  void forEach(void Function(E element) f) {
    for (var i = 0; i < length; i++) {
      f(this[i]);
    }
  }

  @override
  Iterable<E> getRange(int start, int end) {
    var list = <E>[];
    for (var i = start; i < end; i++) {
      list.add(this[i]);
    }
    return list;
  }

  @override
  int indexOf(Object? element, [int start = 0]) {
    for (var i = start; i < length; i++) {
      if (this[i] == element) return i;
    }
    return -1;
  }

  @override
  int indexWhere(bool Function(E element) test, [int start = 0]) {
    for (var i = start; i < length; i++) {
      if (test(this[i])) return i;
    }
    return -1;
  }

  @override
  void insert(int index, E element) {
    if (index < 0 || index > length) {
      throw RangeError.range(index, 0, length);
    }
    length++; // First add to ensure capacity
    for (var i = length - 1; i > index; i--) {
      this[i] = this[i - 1];
    }
    this[index] = element;
  }

  @override
  void insertAll(int index, Iterable<E> iterable) {
    var list = iterable.toList();
    var insertLength = list.length;
    if (insertLength == 0) return;

    length += insertLength;
    for (var i = length - 1; i >= index + insertLength; i--) {
      this[i] = this[i - insertLength];
    }
    for (var i = 0; i < insertLength; i++) {
      this[index + i] = list[i];
    }
  }

  @override
  bool get isEmpty => length == 0;

  @override
  bool get isNotEmpty => !isEmpty;

  @override
  Iterator<E> get iterator => _CppWasmListIterator(this);

  @override
  String join([String separator = ""]) {
    if (isEmpty) return "";
    var buffer = StringBuffer();
    buffer.write(this[0]);
    for (var i = 1; i < length; i++) {
      buffer.write(separator);
      buffer.write(this[i]);
    }
    return buffer.toString();
  }

  @override
  int lastIndexOf(Object? element, [int? start]) {
    start ??= length - 1;
    for (var i = start; i >= 0; i--) {
      if (this[i] == element) return i;
    }
    return -1;
  }

  @override
  int lastIndexWhere(bool Function(E element) test, [int? start]) {
    start ??= length - 1;
    for (var i = start; i >= 0; i--) {
      if (test(this[i])) return i;
    }
    return -1;
  }

  @override
  E lastWhere(bool Function(E element) test, {E Function()? orElse}) {
    for (var i = length - 1; i >= 0; i--) {
      if (test(this[i])) return this[i];
    }
    if (orElse != null) return orElse();
    throw StateError('No element');
  }

  @override
  Iterable<T> map<T>(T Function(E e) f) {
    return Iterable.generate(length, (i) => f(this[i]));
  }

  @override
  E reduce(E Function(E value, E element) combine) {
    if (isEmpty) throw StateError('No elements');
    var value = this[0];
    for (var i = 1; i < length; i++) {
      value = combine(value, this[i]);
    }
    return value;
  }

  @override
  bool remove(Object? element) {
    for (var i = 0; i < length; i++) {
      if (this[i] == element) {
        removeAt(i);
        return true;
      }
    }
    return false;
  }

  @override
  E removeAt(int index) {
    final element = this[index];
    for (var i = index; i < length - 1; i++) {
      this[i] = this[i + 1];
    }
    length--;
    return element;
  }

  @override
  E removeLast() {
    if (isEmpty) throw StateError('No elements');
    var lastElement = this[length - 1];
    length--;
    return lastElement;
  }

  @override
  void removeRange(int start, int end) {
    if (start < 0 || end > length || start > end) {
      throw RangeError.range(start, 0, length);
    }
    var rangeLength = end - start;
    for (var i = start; i < length - rangeLength; i++) {
      this[i] = this[i + rangeLength];
    }
    length -= rangeLength;
  }

  @override
  void removeWhere(bool Function(E element) test) {
    for (var i = length - 1; i >= 0; i--) {
      if (test(this[i])) {
        removeAt(i);
      }
    }
  }

  @override
  void replaceRange(int start, int end, Iterable<E> replacements) {
    removeRange(start, end);
    insertAll(start, replacements);
  }

  @override
  void retainWhere(bool Function(E element) test) {
    removeWhere((element) => !test(element));
  }

  @override
  Iterable<E> get reversed {
    return List.generate(length, (index) => this[length - 1 - index]);
  }

  @override
  void setAll(int index, Iterable<E> iterable) {
    var iterator = iterable.iterator;
    var i = index;
    while (iterator.moveNext()) {
      this[i++] = iterator.current;
    }
  }

  @override
  void setRange(int start, int end, Iterable<E> iterable, [int skipCount = 0]) {
    var length = end - start;
    var iterator = iterable.skip(skipCount).iterator;
    for (var i = 0; i < length; i++) {
      if (!iterator.moveNext()) {
        throw StateError('Too few elements');
      }
      this[start + i] = iterator.current;
    }
  }

  @override
  void shuffle([Random? random]) {
    random ??= Random();
    for (var i = length - 1; i > 0; i--) {
      var j = random.nextInt(i + 1);
      var temp = this[i];
      this[i] = this[j];
      this[j] = temp;
    }
  }

  @override
  E get single {
    if (isEmpty) throw StateError('No elements');
    if (length > 1) throw StateError('Too many elements');
    return this[0];
  }

  @override
  E singleWhere(bool Function(E element) test, {E Function()? orElse}) {
    E? result;
    var count = 0;
    for (var i = 0; i < length; i++) {
      if (test(this[i])) {
        result = this[i];
        count++;
        if (count > 1) {
          throw StateError('More than one element');
        }
      }
    }
    if (count == 1) return result as E;
    if (orElse != null) return orElse();
    throw StateError('No element');
  }

  @override
  Iterable<E> skip(int count) {
    if (count < 0) throw ArgumentError('count cannot be negative');
    var start = count > length ? length : count;
    return getRange(start, length);
  }

  @override
  Iterable<E> skipWhile(bool Function(E value) test) {
    var start = 0;
    while (start < length && test(this[start])) {
      start++;
    }
    return getRange(start, length);
  }

  @override
  void sort([int Function(E a, E b)? compare]) {
    compare ??= Comparable.compare as int Function(E, E)?;
    var list = toList();
    list.sort(compare);
    for (var i = 0; i < length; i++) {
      this[i] = list[i];
    }
  }

  @override
  List<E> sublist(int start, [int? end]) {
    end ??= length;
    var newList = CppWasmList<E>(end - start, end - start);
    for (var i = start; i < end; i++) {
      newList[i - start] = this[i];
    }
    return newList;
  }

  @override
  Iterable<E> take(int count) {
    if (count < 0) throw ArgumentError('count cannot be negative');
    var end = count > length ? length : count;
    return getRange(0, end);
  }

  @override
  Iterable<E> takeWhile(bool Function(E value) test) {
    var result = <E>[];
    for (var i = 0; i < length; i++) {
      if (!test(this[i])) break;
      result.add(this[i]);
    }
    return result;
  }

  @override
  List<E> toList({bool growable = true}) {
    return List<E>.generate(length, (i) => this[i], growable: growable);
  }

  @override
  Set<E> toSet() => Set<E>.from(this);

  @override
  Iterable<E> where(bool Function(E element) test) {
    return toList().where(test);
  }

  @override
  Iterable<T> whereType<T>() {
    return toList().whereType<T>();
  }

  @override
  int get length => _length;

  @override
  set length(int newLength) {
    if (newLength > _array.length) {
      _array =
          cppArrayGrow(_array.data, _length, _getSuggestCapacity(newLength));
    }
    _length = newLength;
  }

  @override
  E get first => isEmpty ? throw StateError('No elements') : this[0];

  @override
  E get last => isEmpty ? throw StateError('No elements') : this[length - 1];

  @override
  set first(E value) {
    if (isEmpty) throw StateError('No elements');
    this[0] = value;
  }

  @override
  set last(E value) {
    if (isEmpty) throw StateError('No elements');
    this[length - 1] = value;
  }
}

class _CppWasmListIterator<E> implements Iterator<E> {
  final CppWasmList<E> _list;
  int _index = -1;

  _CppWasmListIterator(this._list);

  @override
  E get current => _list[_index];

  @override
  bool moveNext() {
    _index++;
    return _index < _list.length;
  }
}

class CppWasmSet<E> implements Set<E> {
  final CppWasmList<E> _list;

  CppWasmSet.fromCppWasmArray(CppWasmArray array)
      : _list = CppWasmList.fromCppWasmArray(array, array.length);

  CppWasmSet([int capacity = 4]) : _list = CppWasmList(0, capacity);

  factory CppWasmSet.identity() => CppWasmSet<E>(4);

  factory CppWasmSet.from(Iterable elements) {
    var set = CppWasmSet<E>();
    for (var element in elements) {
      set.add(element as E);
    }
    return set;
  }

  factory CppWasmSet.of(Iterable<E> elements) => CppWasmSet.from(elements);

  @override
  bool add(E value) {
    if (contains(value)) return false;
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
  bool any(bool Function(E element) test) => _list.any(test);

  @override
  Set<R> cast<R>() => Set.from(_list.cast<R>());

  @override
  void clear() => _list.clear();

  @override
  bool contains(Object? element) => _list.contains(element);

  @override
  bool containsAll(Iterable<Object?> other) {
    for (var element in other) {
      if (!contains(element)) return false;
    }
    return true;
  }

  @override
  Set<E> difference(Set<Object?> other) {
    var result = CppWasmSet<E>();
    for (var element in this) {
      if (!other.contains(element)) {
        result.add(element);
      }
    }
    return result;
  }

  @override
  Set<E> intersection(Set<Object?> other) {
    var result = CppWasmSet<E>();
    for (var element in this) {
      if (other.contains(element)) {
        result.add(element);
      }
    }
    return result;
  }

  @override
  E elementAt(int index) => _list[index];

  @override
  bool every(bool Function(E element) test) => _list.every(test);

  @override
  Iterable<T> expand<T>(Iterable<T> Function(E element) f) => _list.expand(f);

  @override
  E get first => _list.first;

  @override
  E firstWhere(bool Function(E element) test, {E Function()? orElse}) =>
      _list.firstWhere(test, orElse: orElse);

  @override
  T fold<T>(T initialValue, T Function(T previousValue, E element) combine) =>
      _list.fold(initialValue, combine);

  @override
  Iterable<E> followedBy(Iterable<E> other) => _list.followedBy(other);

  @override
  void forEach(void Function(E element) f) => _list.forEach(f);

  @override
  bool get isEmpty => _list.isEmpty;

  @override
  bool get isNotEmpty => _list.isNotEmpty;

  @override
  Iterator<E> get iterator => _list.iterator;

  @override
  String join([String separator = ""]) => _list.join(separator);

  @override
  E get last => _list.last;

  @override
  E lastWhere(bool Function(E element) test, {E Function()? orElse}) =>
      _list.lastWhere(test, orElse: orElse);

  @override
  int get length => _list.length;

  @override
  E lookup(Object? element) {
    for (var e in _list) {
      if (e == element) return e;
    }
    throw ArgumentError('Element not found');
  }

  @override
  Iterable<T> map<T>(T Function(E e) f) => _list.map(f);

  @override
  E reduce(E Function(E value, E element) combine) => _list.reduce(combine);

  @override
  bool remove(Object? value) => _list.remove(value);

  @override
  void removeAll(Iterable<Object?> elements) {
    for (var element in elements) {
      remove(element);
    }
  }

  @override
  void removeWhere(bool Function(E element) test) => _list.removeWhere(test);

  @override
  void retainAll(Iterable<Object?> elements) {
    var toKeep = elements.toSet();
    removeWhere((element) => !toKeep.contains(element));
  }

  @override
  void retainWhere(bool Function(E element) test) => _list.retainWhere(test);

  @override
  E get single => _list.single;

  @override
  E singleWhere(bool Function(E element) test, {E Function()? orElse}) =>
      _list.singleWhere(test, orElse: orElse);

  @override
  Iterable<E> skip(int count) => _list.skip(count);

  @override
  Iterable<E> skipWhile(bool Function(E value) test) => _list.skipWhile(test);

  @override
  Iterable<E> take(int count) => _list.take(count);

  @override
  Iterable<E> takeWhile(bool Function(E value) test) => _list.takeWhile(test);

  @override
  List<E> toList({bool growable = true}) => _list.toList(growable: growable);

  @override
  Set<E> toSet() => Set<E>.from(_list);

  @override
  Set<E> union(Set<E> other) {
    var result = CppWasmSet<E>();
    result.addAll(this);
    result.addAll(other);
    return result;
  }

  @override
  Iterable<E> where(bool Function(E element) test) => _list.where(test);

  @override
  Iterable<T> whereType<T>() => _list.whereType<T>();
}

class CppWasmMap<K, V> implements Map<K, V> {
  final CppWasmList<MapEntry<K, V>> _list;

  CppWasmMap.fromCppWasmArray(CppWasmArray array)
      : _list = CppWasmList.fromCppWasmArray(array, array.length);

  CppWasmMap([int capacity = 4]) : _list = CppWasmList(0, capacity);

  factory CppWasmMap.from(Map other) {
    var map = CppWasmMap<K, V>();
    other.forEach((k, v) => map[k as K] = v as V);
    return map;
  }

  factory CppWasmMap.of(Map<K, V> other) => CppWasmMap<K, V>.from(other);

  factory CppWasmMap.fromIterables(Iterable<K> keys, Iterable<V> values) {
    var map = CppWasmMap<K, V>();
    var valueIterator = values.iterator;
    for (var key in keys) {
      if (!valueIterator.moveNext()) {
        throw ArgumentError('Too few values');
      }
      map[key] = valueIterator.current;
    }
    return map;
  }

  factory CppWasmMap.fromEntries(Iterable<MapEntry<K, V>> entries) {
    var map = CppWasmMap<K, V>();
    for (var entry in entries) {
      map[entry.key] = entry.value;
    }
    return map;
  }

  @override
  V? operator [](Object? key) {
    for (var entry in _list) {
      if (entry.key == key) return entry.value;
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
    other.forEach((key, value) => this[key] = value);
  }

  @override
  void addEntries(Iterable<MapEntry<K, V>> entries) {
    for (var entry in entries) {
      this[entry.key] = entry.value;
    }
  }

  @override
  void clear() => _list.clear();

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
  Map<K2, V2> cast<K2, V2>() {
    throw UnsupportedError('cast() is not supported');
  }

  @override
  V? remove(Object? key) {
    for (var i = 0; i < _list.length; i++) {
      if (_list[i].key == key) {
        var value = _list[i].value;
        _list.removeAt(i);
        return value;
      }
    }
    return null;
  }

  @override
  void removeWhere(bool Function(K key, V value) test) {
    _list.removeWhere((entry) => test(entry.key, entry.value));
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
    if (ifAbsent == null) {
      throw ArgumentError('Key not found and no ifAbsent function provided');
    }
    var value = ifAbsent();
    this[key] = value;
    return value;
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
  V putIfAbsent(K key, V Function() ifAbsent) {
    for (var entry in _list) {
      if (entry.key == key) return entry.value;
    }
    var value = ifAbsent();
    this[key] = value;
    return value;
  }

  @override
  Map<K2, V2> map<K2, V2>(MapEntry<K2, V2> Function(K key, V value) convert) {
    var result = <K2, V2>{};
    forEach((key, value) {
      var entry = convert(key, value);
      result[entry.key] = entry.value;
    });
    return result;
  }
}

void main() {
  // Testing CppWasmList
  print("=== Testing CppWasmList ===");
  var wasmList = CppWasmList<int>.filled(5, 0);
  print("Initial CppWasmList: ${wasmList.toList()}");
  wasmList[2] = 42;
  print("After setting index 2 to 42: ${wasmList.toList()}");
  wasmList.add(99);
  print("After adding 99: ${wasmList.toList()}");
  wasmList.insert(1, 88);
  print("After inserting 88 at index 1: ${wasmList.toList()}");
  wasmList.removeAt(3);
  print("After removing element at index 3: ${wasmList.toList()}");
  print("Does the list contain 42? ${wasmList.contains(42)}");
  print("Reversed list: ${wasmList.reversed.toList()}");
  print("Joined list: ${wasmList.join(', ')}");

  // Testing CppWasmMap
  print("\n=== Testing CppWasmMap ===");
  var wasmMap = CppWasmMap<String, int>();
  wasmMap["one"] = 1;
  wasmMap["two"] = 2;
  wasmMap["three"] = 3;
  print("Initial CppWasmMap: ${wasmMap.entries.toList()}");
  wasmMap.update("one", (value) => value + 10);
  print("After updating 'one': ${wasmMap.entries.toList()}");
  wasmMap.remove("two");
  print("After removing 'two': ${wasmMap.entries.toList()}");
  print("Keys: ${wasmMap.keys.toList()}");
  print("Values: ${wasmMap.values.toList()}");
  print("Contains key 'three'? ${wasmMap.containsKey("three")}");
  print("Contains value 3? ${wasmMap.containsValue(3)}");

  // Testing CppWasmSet
  print("\n=== Testing CppWasmSet ===");
  var wasmSet = CppWasmSet<int>();
  wasmSet.add(1);
  wasmSet.add(2);
  wasmSet.add(3);
  wasmSet.add(3); // Duplicate, should not be added
  print("Initial CppWasmSet: ${wasmSet.toList()}");
  wasmSet.remove(2);
  print("After removing 2: ${wasmSet.toList()}");
  wasmSet.addAll([4, 5, 6]);
  print("After adding [4, 5, 6]: ${wasmSet.toList()}");
  print("Does the set contain 5? ${wasmSet.contains(5)}");
  print(
      "Union with {7, 8}: ${wasmSet.union(CppWasmSet.from([7, 8])).toList()}");
  print("Intersection with {4, 5, 9}: ${wasmSet.intersection(CppWasmSet.from([
            4,
            5,
            9
          ])).toList()}");
  print("Difference with {4, 6}: ${wasmSet.difference(CppWasmSet.from([
            4,
            6
          ])).toList()}");
}
