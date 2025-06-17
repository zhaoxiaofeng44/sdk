import 'dart:collection';
import 'dart:math';

@pragma("wasm:entry-point")
class CppArray<T> {
  final List<T?> _data;
  CppArray(int capacity)
      : _data = List.empty(growable: true)..length = capacity;
  int getLength() => _data.length;

  void setLength(int len) => _data.length = len;

  T getItem(int index) => _data[index]!;

  void setItem(int index, T value) => _data[index] = value;
}

class CppUnit8Array {
  final int length;
  final CppArray<int> _array;
  CppUnit8Array(this.length) : _array = CppArray((length / 4).ceil()) {
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
class CppList<E> extends ListBase<E> {
  int _length;
  final CppArray<E> _array;

  CppList.fromCppArray(CppArray<E> array)
      : _length = array.getLength(),
        _array = array;

  CppList(int length, int capacity)
      : _length = length,
        _array = CppArray<E>(capacity);

  factory CppList.empty({bool growable = false}) {
    return growable ? CppList<E>(0, 0) : CppList<E>(0, 0);
  }

  factory CppList.filled(int length, E fill, {bool growable = false}) {
    var array = growable
        ? CppArray<E>(length)
        : CppArray<E>(_getSuggestCapacity(length));
    for (int i = 0; i < length; i++) {
      array.setItem(i, fill);
    }
    return CppList.fromCppArray(array);
  }

  factory CppList.from(Iterable elements, {bool growable = true}) {
    var length = elements.length;
    var array = growable
        ? CppArray<E>(length)
        : CppArray<E>(_getSuggestCapacity(length));
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
        ? CppArray<E>(length)
        : CppArray<E>(_getSuggestCapacity(length));
    for (int i = 0; i < length; i++) {
      array.setItem(i, generator(i));
    }
    return CppList.fromCppArray(array);
  }

  factory CppList.unmodifiable(Iterable elements) {
    var length = elements.length;
    var array = CppArray<E>(_getSuggestCapacity(length));
    int i = 0;
    for (var element in elements) {
      array.setItem(i++, element as E);
    }
    return CppList.fromCppArray(array);
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

class CppSet<E> extends SetBase<E> {
  final CppList<E> _list;

  CppSet.fromCppArray(CppArray<E> array) : _list = CppList.fromCppArray(array);

  CppSet([int capacity = 4]) : _list = CppList(0, capacity);

  factory CppSet.identity() => CppSet<E>(4);

  factory CppSet.from(Iterable elements) {
    var length = elements.length;
    var array = CppArray<E>(_getSuggestCapacity(length));
    int i = 0;
    for (var element in elements) {
      array.setItem(i++, element as E);
    }
    return CppSet.fromCppArray(array);
  }

  factory CppSet.of(Iterable<E> elements) => CppSet.from(elements);

  factory CppSet.unmodifiable(Iterable<E> elements) {
    var length = elements.length;
    var array = CppArray<E>(_getSuggestCapacity(length));
    int i = 0;
    for (var element in elements) {
      array.setItem(i++, element);
    }
    return CppSet.fromCppArray(array);
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

class CppMap<K, V> extends MapBase<K, V> {
  final CppList<MapEntry<K, V>> _list;

  CppMap.fromCppArray(CppArray<MapEntry<K, V>> array)
      : _list = CppList.fromCppArray(array);

  CppMap([int capacity = 4]) : _list = CppList(0, capacity);

  factory CppMap.from(Map other) => CppMap.unmodifiable(other);

  factory CppMap.of(Map<K, V> other) => CppMap.fromEntries(other.entries);

  factory CppMap.unmodifiable(Map<dynamic, dynamic> other) {
    var length = other.length;
    var array = CppArray<MapEntry<K, V>>(_getSuggestCapacity(length));
    int i = 0;
    for (var entry in other.entries) {
      array.setItem(i++, MapEntry(entry.key as K, entry.value as V));
    }
    return CppMap.fromCppArray(array);
  }

  factory CppMap.identity() => CppMap<K, V>();

  factory CppMap.fromIterable(Iterable iterable,
      {K Function(dynamic element)? key, V Function(dynamic element)? value}) {
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
    var i = 0;
    for (var key in keys) {
      if (i < values.length) {
        map[key] = values.elementAt(i);
      }
      i++;
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

  CppUnit8Array aa = CppUnit8Array(3);
  aa[0] = 1;
  aa[1] = 2;
  aa[2] = 3;
  print(aa._array.getItem(0));
  print(aa[2]);

  CppMap<int, String> kk = CppMap<int, String>(8);
  kk[1] = "xxxx1";
  kk[2] = "xxxx2";
  kk[3] = "xxxx3";
  kk[4] = "xxxx4";
}
