import 'dart:collection';
import 'dart:math';

@pragma("wasm:entry-point")
class CppWasmArray<T> {
  final List<T?> _data;
  CppWasmArray(int capacity)
      : _data = List.empty(growable: true)..length = capacity;
  int getLength() => _data.length;

  void setLength(int len) => _data.length = len;

  T getItem(int index) => _data[index]!;

  void setItem(int index, T value) => _data[index] = value;
}

class CppUnit8Array {
  final int length;
  final CppWasmArray<int> _array;
  CppUnit8Array(this.length) : _array = CppWasmArray((length / 4).ceil()) {
    for (var i = 0; i < _array.getLength(); i++) {
      _array.setItem(i, 0);
    }
  }

  int operator [](int index) {
    var pos = (index / 4).floor();
    int shift = (index % 4) * 8;
    return (_array.getItem(pos) >> shift) & 0xff;
  }

  void operator []=(int index, int value) {
    var pos = (index / 4).floor();
    int shift = (index % 4) * 8;
    // 清除目标字节
    int mask = ~(0xFF << shift);
    int clearedValue = _array.getItem(pos) & mask;
    // 插入新字节
    _array.setItem(pos, clearedValue | (value << shift));
  }
}

int _getSuggestCapacity(int newLen) {
  return newLen > 256 ? newLen : pow(2, (log(newLen) / log(2)).ceil()).toInt();
}

@pragma("wasm:entry-point")
class CppWasmList<E> extends ListBase<E> {
  int _length;
  final CppWasmArray<E> _array;

  CppWasmList.fromCppWasmArray(CppWasmArray<E> array)
      : _length = array.getLength(),
        _array = array;

  CppWasmList(int length, int capacity)
      : _length = length,
        _array = CppWasmArray<E>(capacity);

  factory CppWasmList.empty({bool growable = false}) {
    return growable ? CppWasmList<E>(0, 0) : CppWasmList<E>(0, 0);
  }

  factory CppWasmList.filled(int length, E fill, {bool growable = false}) {
    var array = growable
        ? CppWasmArray<E>(length)
        : CppWasmArray<E>(_getSuggestCapacity(length));
    for (int i = 0; i < length; i++) {
      array.setItem(i, fill);
    }
    return CppWasmList.fromCppWasmArray(array);
  }

  factory CppWasmList.from(Iterable elements, {bool growable = true}) {
    var length = elements.length;
    var array = growable
        ? CppWasmArray<E>(length)
        : CppWasmArray<E>(_getSuggestCapacity(length));
    int i = 0;
    for (var element in elements) {
      array.setItem(i++, element);
    }
    return CppWasmList.fromCppWasmArray(array);
  }

  factory CppWasmList.of(Iterable<E> elements, {bool growable = true}) =>
      CppWasmList.from(elements, growable: growable);

  factory CppWasmList.generate(
    int length,
    E Function(int index) generator, {
    bool growable = true,
  }) {
    var array = growable
        ? CppWasmArray<E>(length)
        : CppWasmArray<E>(_getSuggestCapacity(length));
    for (int i = 0; i < length; i++) {
      array.setItem(i, generator(i));
    }
    return CppWasmList.fromCppWasmArray(array);
  }

  factory CppWasmList.unmodifiable(Iterable elements) {
    var length = elements.length;
    var array = CppWasmArray<E>(_getSuggestCapacity(length));
    int i = 0;
    for (var element in elements) {
      array.setItem(i++, element as E);
    }
    return CppWasmList.fromCppWasmArray(array);
  }

  @override
  get length => _length;

  @override
  set length(int newLen) {
    if (newLen > _array.getLength()) {
      _array.setLength(_getSuggestCapacity(newLen));
    }
    _length = newLen;
  }

  @override
  E operator [](int index) => _array.getItem(index);

  @override
  void operator []=(int index, E value) => _array.setItem(index, value);
}

class CppWasmSet<E> extends SetBase<E> {
  final CppWasmList<E> _list;

  CppWasmSet.fromCppWasmArray(CppWasmArray<E> array)
      : _list = CppWasmList.fromCppWasmArray(array);

  CppWasmSet([int capacity = 4]) : _list = CppWasmList(0, capacity);

  factory CppWasmSet.identity() => CppWasmSet<E>(4);

  factory CppWasmSet.from(Iterable elements) {
    var length = elements.length;
    var array = CppWasmArray<E>(_getSuggestCapacity(length));
    int i = 0;
    for (var element in elements) {
      array.setItem(i++, element as E);
    }
    return CppWasmSet.fromCppWasmArray(array);
  }

  factory CppWasmSet.of(Iterable<E> elements) => CppWasmSet.from(elements);

  factory CppWasmSet.unmodifiable(Iterable<E> elements) {
    var length = elements.length;
    var array = CppWasmArray<E>(_getSuggestCapacity(length));
    int i = 0;
    for (var element in elements) {
      array.setItem(i++, element);
    }
    return CppWasmSet.fromCppWasmArray(array);
  }

  @override
  bool add(E value) {
    if (contains(value)) {
      return false;
    }
    _list.add(value);
    return true;
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
  Set<E> toSet() {
    return this;
  }
}

class CppWasmMap<K, V> extends MapBase<K, V> {
  final CppWasmList<MapEntry<K, V>> _list;

  CppWasmMap.fromCppWasmArray(CppWasmArray<MapEntry<K, V>> array)
      : _list = CppWasmList.fromCppWasmArray(array);

  CppWasmMap([int capacity = 4]) : _list = CppWasmList(0, capacity);

  factory CppWasmMap.from(Map other) => CppWasmMap.unmodifiable(other);

  factory CppWasmMap.of(Map<K, V> other) =>
      CppWasmMap.fromEntries(other.entries);

  factory CppWasmMap.unmodifiable(Map<dynamic, dynamic> other) {
    var length = other.length;
    var array = CppWasmArray<MapEntry<K, V>>(_getSuggestCapacity(length));
    int i = 0;
    for (var entry in other.entries) {
      array.setItem(i++, MapEntry(entry.key as K, entry.value as V));
    }
    return CppWasmMap.fromCppWasmArray(array);
  }

  factory CppWasmMap.identity() => CppWasmMap<K, V>();

  factory CppWasmMap.fromIterable(Iterable iterable,
      {K Function(dynamic element)? key, V Function(dynamic element)? value}) {
    var map = CppWasmMap<K, V>();
    for (var element in iterable) {
      var k = key?.call(element) ?? element;
      var v = value?.call(element) ?? element;
      map[k] = v;
    }
    return map;
  }

  factory CppWasmMap.fromIterables(Iterable<K> keys, Iterable<V> values) {
    var map = CppWasmMap<K, V>();
    var i = 0;
    for (var key in keys) {
      if (i < values.length) {
        map[key] = values.elementAt(i);
      }
      i++;
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
  void clear() {
    _list.clear();
  }

  @override
  Iterable<K> get keys => _list.map((e) => e.key);

  @override
  V? remove(Object? key) {
    V? v;
    for (var i = 0, j = 0; i < _list.length; i++) {
      var entry = _list[i];
      if (entry.key == key) {
        v = entry.value;
        j--;
        continue;
      }
      if (j < i) {
        _list[j] = _list[i];
      }
    }
    return v;
  }
}

void main() {
  // 测试
  CppWasmList<int> list = CppWasmList<int>(0, 8);

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

  CppWasmSet<int> set = CppWasmSet(2);
  set.add(1);
  set.add(2);
  set.add(3);
  set.add(1);
  print(set); // [1, 2, 3]

  var doubled2 = set.map((e) => e * 2);
  print(doubled2); // [2, 4, 6]

  CppUnit8Array aa = CppUnit8Array(3);
  aa[0] = 1;
  aa[1] = 2;
  aa[2] = 3;
  print(aa._array.getItem(0));
  print(aa[2]);

  CppWasmMap<int, String> kk = CppWasmMap<int, String>(8);
  kk[1] = "xxxx1";
  kk[2] = "xxxx2";
  kk[3] = "xxxx3";
  kk[4] = "xxxx4";
}
