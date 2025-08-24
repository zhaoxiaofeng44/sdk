import 'dart:math';
import 'Iterable.dart';
import 'api.dart';
import 'object.dart';
import 'string.dart';

@pragma("wasm:entry-point")
@pragma("cpp:patch-factory", "CppList")
@pragma('cpp:patch', 'CppList')
abstract class CppList<E> extends CppIterable<E> {
  // 工厂方法
  factory CppList.empty({bool growable = false}) {
    return CppArrayList.empty(growable: growable);
  }

  factory CppList.filled(int length, E fill, {bool growable = false}) {
    return CppArrayList.filled(length, fill, growable: growable);
  }

  factory CppList.from(CppIterable elements, {bool growable = true}) {
    return CppArrayList.from(elements, growable: growable);
  }

  factory CppList.of(CppIterable<E> elements, {bool growable = true}) {
    return CppArrayList.of(elements, growable: growable);
  }

  factory CppList.generate(
    int length,
    E Function(int index) generator, {
    bool growable = true,
  }) {
    return CppArrayList.generate(length, generator, growable: growable);
  }

  factory CppList.unmodifiable(CppIterable elements) {
    return CppArrayList.unmodifiable(elements);
  }

  // 静态方法
  static CppList<R> castFrom<S, R>(CppList<S> source) {
    return CppArrayList.castFrom<S, R>(source);
  }

  static CppList<R> castFromWithFactory<S, R>(
      CppList<S> source, CppList<R> Function() newList) {
    return CppArrayList.castFromWithFactory<S, R>(source, newList);
  }

  // 抽象方法 - 所有List接口方法
  @override
  int get length;

  @override
  set length(int newLen);

  E operator [](int index);

  void operator []=(int index, E value);

  @override
  void add(E value);

  @override
  void addAll(CppIterable<E> iterable);

  @override
  bool any(bool Function(E element) test);

  @override
  CppMap<int, E> asMap();

  @override
  CppIterable<R> cast<R>();

  @override
  void clear();

  @override
  bool contains(Object? element);

  @override
  E elementAt(int index);

  @override
  bool every(bool Function(E element) test);

  @override
  void fillRange(int start, int end, [E? fillValue]);

  @override
  E firstWhere(bool Function(E element) test, {E Function()? orElse});

  @override
  T fold<T>(T initialValue, T Function(T previousValue, E element) combine);

  @override
  void forEach(void Function(E element) action);

  @override
  CppIterable<E> getRange(int start, int end);

  @override
  int indexOf(E element, [int start = 0]);

  @override
  int indexWhere(bool Function(E element) test, [int start = 0]);

  @override
  void insert(int index, E element);

  @override
  void insertAll(int index, CppIterable<E> iterable);

  @override
  E get first;

  @override
  set first(E value);

  @override
  E get last;

  @override
  set last(E value);

  @override
  E get single;

  @override
  bool get isEmpty;

  @override
  bool get isNotEmpty;

  @override
  CppIterator<E> get iterator;

  @override
  CppString join([CppString separator = CppString.Empty]);

  @override
  int lastIndexOf(E element, [int? start]);

  @override
  int lastIndexWhere(bool Function(E element) test, [int? start]);

  @override
  E lastWhere(bool Function(E element) test, {E Function()? orElse});

  @override
  E reduce(E Function(E value, E element) combine);

  @override
  bool remove(Object? value);

  @override
  E removeAt(int index);

  @override
  E removeLast();

  @override
  void removeRange(int start, int end);

  @override
  void removeWhere(bool Function(E element) test);

  @override
  void replaceRange(int start, int end, CppIterable<E> replacements);

  @override
  void retainWhere(bool Function(E element) test);

  @override
  void setAll(int index, CppIterable<E> iterable);

  @override
  void setRange(int start, int end, CppIterable<E> iterable,
      [int skipCount = 0]);

  @override
  void shuffle([Random? random]);

  @override
  void sort([int Function(E a, E b)? compare]);

  @override
  CppList<E> sublist(int start, [int? end]);

  @override
  CppList<E> toList({bool growable = true});

  @override
  CppSet<E> toSet();

  @override
  E singleWhere(bool Function(E element) test, {E Function()? orElse});

  @override
  CppList<E> operator +(CppList<E> other);

  @override
  CppString toCppString();
}

class CppArrayList<E> extends CppIterable<E> implements CppList<E> {
  int _length;
  CppUserData _array;

  @pragma('wasm:entry-point')
  CppArrayList.fromCppArray(CppUserData array)
      : _length = CppApi.cppGetPointerArrayLength(array),
        _array = array;

  CppArrayList(int length, int capacity)
      : _length = length,
        _array = CppApi.cppCreatePointerArray(length);

  // 标准List工厂方法
  factory CppArrayList.empty({bool growable = false}) {
    return growable ? CppArrayList<E>(0, 0) : CppArrayList<E>(0, 0);
  }

  factory CppArrayList.filled(int length, E fill, {bool growable = false}) {
    var array = CppApi.cppCreatePointerArray(length);
    for (int i = 0; i < length; i++) {
      CppApi.cppSetPointerArrayItem(array, i, fill);
    }
    return CppArrayList.fromCppArray(array);
  }

  factory CppArrayList.from(CppIterable elements, {bool growable = true}) {
    var length = elements.length;
    var array = growable
        ? CppApi.cppCreatePointerArray(length)
        : CppApi.cppCreatePointerArray(_getSuggestCapacity(length));
    int i = 0;
    {
      CppIterator<dynamic> _sync_for_iterator = elements.iterator;
      for (; _sync_for_iterator.moveNext();) {
        CppApi.cppSetPointerArrayItem(array, i++, _sync_for_iterator.current);
      }
    }
    return CppArrayList.fromCppArray(array);
  }

  factory CppArrayList.of(CppIterable<E> elements, {bool growable = true}) =>
      CppArrayList.from(elements, growable: growable);

  factory CppArrayList.generate(
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
    return CppArrayList.fromCppArray(array);
  }

  factory CppArrayList.unmodifiable(CppIterable elements) {
    var length = elements.length;
    var array = CppApi.cppCreatePointerArray(length);
    int i = 0;
    {
      CppIterator<dynamic> _sync_for_iterator = elements.iterator;
      for (; _sync_for_iterator.moveNext();) {
        CppApi.cppSetPointerArrayItem(
            array, i++, _sync_for_iterator.current as E);
      }
    }
    return CppArrayList.fromCppArray(array);
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
  void addAll(CppIterable<E> iterable) {
    {
      CppIterator<E> _sync_for_iterator = iterable.iterator;
      for (; _sync_for_iterator.moveNext();) {
        add(_sync_for_iterator.current);
      }
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
  CppMap<int, E> asMap() {
    var map = CppArrayMap<int, E>();
    for (int i = 0; i < _length; i++) {
      map[i] = CppApi.cppGetPointerArrayItem(_array, i) as E;
    }
    return map;
  }

  @override
  CppIterable<R> cast<R>() {
    return CppArrayList.castFrom<E, R>(this) as CppIterable<R>;
  }

  // 静态方法 - 对应Dart List类的静态方法
  static CppList<R> castFrom<S, R>(CppList<S> source) {
    var result = CppArrayList<R>(0, 4);
    {
      CppIterator<S> _sync_for_iterator = source.iterator;
      for (; _sync_for_iterator.moveNext();) {
        result.add(_sync_for_iterator.current as R);
      }
    }
    return result;
  }

  static CppList<R> castFromWithFactory<S, R>(
      CppList<S> source, CppList<R> Function() newList) {
    var result = newList();
    {
      CppIterator<S> _sync_for_iterator = source.iterator;
      for (; _sync_for_iterator.moveNext();) {
        result.add(_sync_for_iterator.current as R);
      }
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
  CppIterable<E> getRange(int start, int end) {
    return CppArrayList.from(CppIterable.generate(
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
  void insertAll(int index, CppIterable<E> iterable) {
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
  CppIterator<E> get iterator => _CppListIterator(this);

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
  void replaceRange(int start, int end, CppIterable<E> replacements) {
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
  void setAll(int index, CppIterable<E> iterable) {
    if (index < 0 || index > _length) throw RangeError.index(index, this);
    var i = index;
    {
      CppIterator<E> _sync_for_iterator = iterable.iterator;
      for (; _sync_for_iterator.moveNext();) {
        var element = _sync_for_iterator.current;
        if (i >= _length) {
          add(element);
        } else {
          CppApi.cppSetPointerArrayItem(_array, i, element);
        }
        i++;
      }
    }
  }

  @override
  void setRange(int start, int end, CppIterable<E> iterable,
      [int skipCount = 0]) {
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
  CppList<E> sublist(int start, [int? end]) {
    var endIndex = end ?? _length;
    if (start < 0 ||
        start > _length ||
        endIndex < start ||
        endIndex > _length) {
      throw RangeError.range(start, 0, _length);
    }
    return CppArrayList.from(CppIterable.generate(endIndex - start,
        (i) => CppApi.cppGetPointerArrayItem(_array, start + i)));
  }

  @override
  CppList<E> toList({bool growable = true}) {
    return CppArrayList.from(this as CppIterable, growable: growable);
  }

  @override
  CppSet<E> toSet() {
    return CppArraySet.from(this);
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
  CppList<E> operator +(CppList<E> other) {
    var result = CppArrayList<E>(0, _length + other.length);
    for (int i = 0; i < _length; i++) {
      result.add(CppApi.cppGetPointerArrayItem(_array, i) as E);
    }
    {
      CppIterator<E> _sync_for_iterator = other.iterator;
      for (; _sync_for_iterator.moveNext();) {
        result.add(_sync_for_iterator.current);
      }
    }
    return result;
  }

  @override
  CppString toCppString() {
    if (_length == 0) return CppString.fromString("[]");
    var buffer = CppStringBuffer("[");
    buffer.write(CppApi.cppGetPointerArrayItem(_array, 0));
    for (int i = 1; i < _length; i++) {
      buffer.write(", ");
      buffer.write(CppApi.cppGetPointerArrayItem(_array, i));
    }
    buffer.write("]");
    return buffer.toCppString();
  }
}

class _CppListIterator<E> extends CppObject implements CppIterator<E> {
  final CppArrayList<E> _list;
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

@pragma("cpp:patch-factory", "CppSet")
@pragma('cpp:patch', 'CppSet')
abstract class CppSet<E> extends CppObject {
  // 工厂方法
  factory CppSet.identity() => CppArraySet.identity();

  factory CppSet.from(CppIterable elements) {
    return CppArraySet.from(elements);
  }

  factory CppSet.of(CppIterable<E> elements) => CppArraySet.of(elements);

  factory CppSet.unmodifiable(CppIterable<E> elements) {
    return CppArraySet.unmodifiable(elements);
  }

  // 静态方法
  static CppSet<R> castFrom<S, R>(CppSet<S> source) {
    return CppArraySet.castFrom<S, R>(source);
  }

  static CppSet<R> castFromWithFactory<S, R>(
      CppSet<S> source, CppSet<R> Function() newSet) {
    return CppArraySet.castFromWithFactory<S, R>(source, newSet);
  }

  // 抽象方法 - 所有Set接口方法
  @override
  bool add(E value);

  @override
  void addAll(CppIterable<E> elements);

  @override
  CppIterable<R> cast<R>();

  @override
  void clear();

  @override
  bool contains(Object? element);

  @override
  bool containsAll(CppIterable<Object?> other);

  @override
  CppSet<E> difference(CppSet<Object?> other);

  @override
  E elementAt(int index);

  @override
  CppSet<E> intersection(CppSet<Object?> other);

  @override
  E get first;

  @override
  E get last;

  @override
  E get single;

  @override
  bool get isEmpty;

  @override
  bool get isNotEmpty;

  @override
  CppIterator<E> get iterator;

  @override
  int get length;

  @override
  E? lookup(Object? element);

  @override
  bool remove(Object? value);

  @override
  void removeAll(CppIterable<Object?> elementsToRemove);

  @override
  void removeWhere(bool Function(E element) test);

  @override
  void retainAll(CppIterable<Object?> elementsToRetain);

  @override
  void retainWhere(bool Function(E element) test);

  @override
  CppSet<E> union(CppSet<E> other);

  @override
  CppString toCppString();
}

class CppArraySet<E> extends CppIterable<E> implements CppSet<E> {
  final CppArrayList<E> _list;

  @pragma('wasm:entry-point')
  CppArraySet.fromCppArray(CppUserData array)
      : _list = CppArrayList.fromCppArray(array);

  CppArraySet([int capacity = 4]) : _list = CppArrayList(0, capacity);

  // 标准Set工厂方法 - 对应Dart Set类的所有factory方法
  factory CppArraySet.identity() => CppArraySet<E>(4);

  factory CppArraySet.from(CppIterable elements) {
    var set = CppArraySet<E>();
    {
      CppIterator<dynamic> _sync_for_iterator = elements.iterator;
      for (; _sync_for_iterator.moveNext();) {
        set.add(_sync_for_iterator.current as E);
      }
    }
    return set;
  }

  factory CppArraySet.of(CppIterable<E> elements) => CppArraySet.from(elements);

  factory CppArraySet.unmodifiable(CppIterable<E> elements) {
    var set = CppArraySet<E>();
    {
      CppIterator<E> _sync_for_iterator = elements.iterator;
      for (; _sync_for_iterator.moveNext();) {
        set.add(_sync_for_iterator.current);
      }
    }
    return set;
  }

  // 静态方法 - 对应Dart Set类的静态方法
  static CppSet<R> castFrom<S, R>(CppSet<S> source) {
    var result = CppArraySet<R>();
    {
      CppIterator<S> _sync_for_iterator = source.iterator;
      for (; _sync_for_iterator.moveNext();) {
        result.add(_sync_for_iterator.current as R);
      }
    }
    return result;
  }

  static CppSet<R> castFromWithFactory<S, R>(
      CppSet<S> source, CppSet<R> Function() newSet) {
    var result = newSet();
    {
      CppIterator<S> _sync_for_iterator = source.iterator;
      for (; _sync_for_iterator.moveNext();) {
        result.add(_sync_for_iterator.current as R);
      }
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
  void addAll(CppIterable<E> elements) {
    {
      CppIterator<E> _sync_for_iterator = elements.iterator;
      for (; _sync_for_iterator.moveNext();) {
        add(_sync_for_iterator.current);
      }
    }
  }

  @override
  CppIterable<R> cast<R>() {
    return CppSet.castFrom<E, R>(this) as CppIterable<R>;
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
  bool containsAll(CppIterable<Object?> other) {
    {
      CppIterator<Object?> _sync_for_iterator = other.iterator;
      for (; _sync_for_iterator.moveNext();) {
        if (!contains(_sync_for_iterator.current)) return false;
      }
    }
    return true;
  }

  @override
  CppSet<E> difference(CppSet<Object?> other) {
    var result = CppArraySet<E>();
    {
      CppIterator<E> _sync_for_iterator = _list.iterator;
      for (; _sync_for_iterator.moveNext();) {
        var element = _sync_for_iterator.current;
        if (!other.contains(element)) {
          result.add(element);
        }
      }
    }
    return result;
  }

  @override
  E elementAt(int index) => _list.elementAt(index);

  @override
  CppSet<E> intersection(CppSet<Object?> other) {
    var result = CppArraySet<E>();
    {
      CppIterator<E> _sync_for_iterator = _list.iterator;
      for (; _sync_for_iterator.moveNext();) {
        var element = _sync_for_iterator.current;
        if (other.contains(element)) {
          result.add(element);
        }
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
  CppIterator<E> get iterator => _list.iterator;

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
  void removeAll(CppIterable<Object?> elementsToRemove) {
    {
      CppIterator<Object?> _sync_for_iterator = elementsToRemove.iterator;
      for (; _sync_for_iterator.moveNext();) {
        remove(_sync_for_iterator.current);
      }
    }
  }

  @override
  void removeWhere(bool Function(E element) test) {
    _list.removeWhere(test);
  }

  @override
  void retainAll(CppIterable<Object?> elementsToRetain) {
    var retainSet = CppSet.from(elementsToRetain);
    removeWhere((element) => !retainSet.contains(element));
  }

  @override
  void retainWhere(bool Function(E element) test) {
    _list.retainWhere(test);
  }

  @override
  CppSet<E> union(CppSet<E> other) {
    var result = CppArraySet<E>();
    result.addAll(this as CppIterable<E>);
    result.addAll(other as CppIterable<E>);
    return result;
  }

  @override
  CppString toCppString() {
    if (_list.isEmpty) return CppString.fromString("{}");
    var buffer = CppStringBuffer("{");
    var iterator = _list.iterator;
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

@pragma("cpp:patch-factory", "MapEntry")
@pragma('cpp:patch', 'MapEntry')
class CppMapEntry<K, V> extends CppObject {
  final K key;
  final V value;
  CppMapEntry(this.key, this.value);
}

@pragma("cpp:patch-factory", "CppMap")
@pragma('cpp:patch', 'CppMap')
abstract class CppMap<K, V> extends CppObject {
  // 工厂方法
  factory CppMap.identity() => CppArrayMap.identity();

  factory CppMap.from(CppMap other) => CppArrayMap.from(other);

  factory CppMap.of(CppMap<K, V> other) => CppArrayMap.of(other);

  factory CppMap.unmodifiable(CppMap<dynamic, dynamic> other) {
    return CppArrayMap.unmodifiable(other);
  }

  factory CppMap.fromIterable(
    CppIterable iterable, {
    K Function(dynamic element)? key,
    V Function(dynamic element)? value,
  }) {
    return CppArrayMap.fromIterable(iterable, key: key, value: value);
  }

  factory CppMap.fromIterables(CppIterable<K> keys, CppIterable<V> values) {
    return CppArrayMap.fromIterables(keys, values);
  }

  factory CppMap.fromEntries(CppIterable<MapEntry<K, V>> entries) {
    return CppArrayMap.fromEntries(entries);
  }

  // 静态方法
  static CppMap<RK, RV> castFrom<K, V, RK, RV>(CppMap<K, V> source) {
    return CppArrayMap.castFrom<K, V, RK, RV>(source);
  }

  static CppMap<RK, RV> castFromWithFactory<K, V, RK, RV>(
      CppMap<K, V> source, CppMap<RK, RV> Function() newMap) {
    return CppArrayMap.castFromWithFactory<K, V, RK, RV>(source, newMap);
  }

  // 抽象方法 - 所有Map接口方法
  @override
  V? operator [](Object? key);

  @override
  void operator []=(K key, V value);

  @override
  void addAll(CppMap<K, V> other);

  @override
  void addEntries(CppIterable<MapEntry<K, V>> entries);

  @override
  CppMap<RK, RV> cast<RK, RV>();

  @override
  void clear();

  @override
  bool containsKey(Object? key);

  @override
  bool containsValue(Object? value);

  @override
  CppIterable<MapEntry<K, V>> get entries;

  @override
  void forEach(void Function(K key, V value) action);

  @override
  bool get isEmpty;

  @override
  bool get isNotEmpty;

  @override
  CppIterable<K> get keys;

  @override
  int get length;

  @override
  V putIfAbsent(K key, V Function() ifAbsent);

  @override
  V? remove(Object? key);

  @override
  void removeWhere(bool Function(K key, V value) test);

  @override
  V update(K key, V Function(V value) update, {V Function()? ifAbsent});

  @override
  void updateAll(V Function(K key, V value) update);

  @override
  CppIterable<V> get values;

  @override
  CppMap<K2, V2> map<K2, V2>(
      MapEntry<K2, V2> Function(K key, V value) transform);

  @override
  CppString toCppString();
}

class CppArrayMap<K, V> extends CppObject implements CppMap<K, V> {
  final CppArrayList<MapEntry<K, V>> _list;

  @pragma('wasm:entry-point')
  CppArrayMap.fromCppArray(CppUserData array)
      : _list = CppArrayList.fromCppArray(array);

  CppArrayMap([int capacity = 4]) : _list = CppArrayList(0, capacity);

  // 标准Map工厂方法
  factory CppArrayMap.identity() => CppArrayMap<K, V>();

  factory CppArrayMap.from(CppMap other) => CppArrayMap.unmodifiable(other);

  factory CppArrayMap.of(CppMap<K, V> other) =>
      CppArrayMap.fromEntries(other.entries);

  factory CppArrayMap.unmodifiable(CppMap<dynamic, dynamic> other) {
    var map = CppArrayMap<K, V>();
    other.forEach((key, value) {
      map[key as K] = value as V;
    });
    return map;
  }

  factory CppArrayMap.fromIterable(
    CppIterable iterable, {
    K Function(dynamic element)? key,
    V Function(dynamic element)? value,
  }) {
    var map = CppArrayMap<K, V>();
    {
      CppIterator<dynamic> _sync_for_iterator = iterable.iterator;
      for (; _sync_for_iterator.moveNext();) {
        var element = _sync_for_iterator.current;
        var k = key?.call(element) ?? element;
        var v = value?.call(element) ?? element;
        map[k] = v;
      }
    }
    return map;
  }

  factory CppArrayMap.fromIterables(
      CppIterable<K> keys, CppIterable<V> values) {
    var map = CppArrayMap<K, V>();
    var keyIter = keys.iterator;
    var valueIter = values.iterator;
    while (keyIter.moveNext() && valueIter.moveNext()) {
      map[keyIter.current] = valueIter.current;
    }
    return map;
  }

  factory CppArrayMap.fromEntries(CppIterable<MapEntry<K, V>> entries) {
    var map = CppArrayMap<K, V>();
    {
      CppIterator<MapEntry<K, V>> _sync_for_iterator = entries.iterator;
      for (; _sync_for_iterator.moveNext();) {
        var entry = _sync_for_iterator.current;
        map[entry.key] = entry.value;
      }
    }
    return map;
  }

  // Map接口实现
  @override
  V? operator [](Object? key) {
    {
      CppIterator<MapEntry<K, V>> _sync_for_iterator = _list.iterator;
      for (; _sync_for_iterator.moveNext();) {
        var entry = _sync_for_iterator.current;
        if (entry.key == key) {
          return entry.value;
        }
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
  void addAll(CppMap<K, V> other) {
    other.forEach((k, v) => this[k] = v);
  }

  @override
  void addEntries(CppIterable<MapEntry<K, V>> entries) {
    {
      CppIterator<MapEntry<K, V>> _sync_for_iterator = entries.iterator;
      for (; _sync_for_iterator.moveNext();) {
        var entry = _sync_for_iterator.current;
        this[entry.key] = entry.value;
      }
    }
  }

  @override
  CppMap<RK, RV> cast<RK, RV>() => CppMap.castFrom<K, V, RK, RV>(this);

  // 静态方法 - 对应Dart Map类的静态方法
  static CppMap<RK, RV> castFrom<K, V, RK, RV>(CppMap<K, V> source) {
    var result = CppArrayMap<RK, RV>();
    source.forEach((key, value) {
      result[key as RK] = value as RV;
    });
    return result;
  }

  static CppMap<RK, RV> castFromWithFactory<K, V, RK, RV>(
      CppMap<K, V> source, CppMap<RK, RV> Function() newMap) {
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
    {
      CppIterator<MapEntry<K, V>> _sync_for_iterator = _list.iterator;
      for (; _sync_for_iterator.moveNext();) {
        var entry = _sync_for_iterator.current;
        if (entry.key == key) return true;
      }
    }
    return false;
  }

  @override
  bool containsValue(Object? value) {
    {
      CppIterator<MapEntry<K, V>> _sync_for_iterator = _list.iterator;
      for (; _sync_for_iterator.moveNext();) {
        var entry = _sync_for_iterator.current;
        if (entry.value == value) return true;
      }
    }
    return false;
  }

  @override
  CppIterable<MapEntry<K, V>> get entries => _list;

  @override
  void forEach(void Function(K key, V value) action) {
    {
      CppIterator<MapEntry<K, V>> _sync_for_iterator = _list.iterator;
      for (; _sync_for_iterator.moveNext();) {
        var entry = _sync_for_iterator.current;
        action(entry.key, entry.value);
      }
    }
  }

  @override
  bool get isEmpty => _list.isEmpty;

  @override
  bool get isNotEmpty => _list.isNotEmpty;

  @override
  CppIterable<K> get keys => _list.map((e) => e.key);

  @override
  int get length => _list.length;

  @override
  V putIfAbsent(K key, V Function() ifAbsent) {
    {
      CppIterator<MapEntry<K, V>> _sync_for_iterator = _list.iterator;
      for (; _sync_for_iterator.moveNext();) {
        var entry = _sync_for_iterator.current;
        if (entry.key == key) return entry.value;
      }
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
  CppIterable<V> get values => _list.map((e) => e.value);

  @override
  CppMap<K2, V2> map<K2, V2>(
      MapEntry<K2, V2> Function(K key, V value) transform) {
    var result = CppArrayMap<K2, V2>();
    {
      CppIterator<MapEntry<K, V>> _sync_for_iterator = _list.iterator;
      for (; _sync_for_iterator.moveNext();) {
        var entry = _sync_for_iterator.current;
        var newEntry = transform(entry.key, entry.value);
        result[newEntry.key] = newEntry.value;
      }
    }
    return result;
  }

  @override
  CppString toCppString() {
    if (_list.isEmpty) return CppString.fromString('{}');
    var buffer = CppStringBuffer('{');
    var iterator = _list.iterator;
    if (iterator.moveNext()) {
      buffer.write('${iterator.current.key}: ${iterator.current.value}');
      while (iterator.moveNext()) {
        buffer.write(', ${iterator.current.key}: ${iterator.current.value}');
      }
    }
    buffer.write('}');
    return buffer.toCppString();
  }
}
