/// 静态集合类 — 不继承原生 List/Map/Set，基于 Array 统一管理内部存储
///
/// 包含：Array, StaticList, StaticMap, StaticSet, StaticMapEntry, StaticIterator

import '_gc.dart';
import '_exceptions.dart';

// ============================================================================
// Array<T> — 底层存储容器
// ============================================================================

/// Array<T> — 底层存储容器，所有静态集合类的基础。
/// 提供固定大小和动态增长两种模式的元素管理。
class Array<T> extends AnyGC {
  final List<T> _storage;
  int _length;

  /// 创建固定大小的 Array，元素为 null（需要 T 为 nullable）或通过 fill 指定默认值
  Array(int size, {T? fill})
      : _storage = List<T>.filled(size, fill as T),
        _length = size;

  /// 从现有可迭代对象创建 Array
  Array.from(Iterable<T> elements)
      : _storage = List<T>.from(elements),
        _length = elements.length;

  /// 创建空的动态 Array
  Array.empty()
      : _storage = <T>[],
        _length = 0;

  /// gcMark — 递归标记数组中引用的 GC 子对象
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
    for (int i = 0; i < _length; i++) {
      final element = _storage[i];
      if (element is AnyGC) (element as AnyGC).gcMark(flag);
    }
  }

  int get length => _length;

  T operator [](int index) {
    if (index < 0 || index >= _length) {
      throw DartRangeError('Index $index out of range [0..$_length)');
    }
    return _storage[index];
  }

  void operator []=(int index, T value) {
    if (index < 0 || index >= _length) {
      throw DartRangeError('Index $index out of range [0..$_length)');
    }
    _storage[index] = value;
  }

  void add(T element) {
    _storage.add(element);
    _length++;
  }

  void insert(int index, T element) {
    _storage.insert(index, element);
    _length++;
  }

  T removeAt(int index) {
    if (index < 0 || index >= _length) {
      throw DartRangeError('Index $index out of range [0..$_length)');
    }
    final removed = _storage.removeAt(index);
    _length--;
    return removed;
  }

  bool remove(T element) {
    final idx = indexOf(element);
    if (idx == -1) return false;
    removeAt(idx);
    return true;
  }

  int indexOf(T element) {
    for (int i = 0; i < _length; i++) {
      if (_storage[i] == element) return i;
    }
    return -1;
  }

  bool contains(T element) => indexOf(element) != -1;

  void clear() {
    _storage.clear();
    _length = 0;
  }

  Iterable<T> get iterable => _storage.take(_length);

  List<T> toList() => List<T>.from(_storage.take(_length));

  @override
  String toString() => 'Array(${_storage.take(_length).join(', ')})';
}

// ============================================================================
// StaticList<T> — 静态列表
// ============================================================================

/// StaticList<T> — 完全独立的静态列表，不继承 List/ListMixin。
/// 内部基于 Array<T> 管理数据，所有方法自行实现。
/// 通过提供 `Iterator<T> get iterator` 支持 Dart for-in 循环。
class StaticList<T> extends AnyGC implements Iterable<T> {
  final Array<T> _data;

  StaticList._internal(this._data);

  StaticList() : _data = Array<T>.empty();

  StaticList.of(Iterable<T> elements) : _data = Array<T>.from(elements);

  StaticList.filled(int length, T fill) : _data = Array<T>(length, fill: fill);

  StaticList.unmodifiable(Iterable<T> elements) : _data = Array<T>.from(elements);

  StaticList.empty({bool growable = true}) : _data = Array<T>.empty();

  StaticList.generate(int length, T Function(int index) generator)
      : _data = Array<T>.empty() {
    for (int i = 0; i < length; i++) {
      _data.add(generator(i));
    }
  }

  StaticList.from(Iterable elements) : _data = Array<T>.from(elements.cast<T>());

  /// gcMark — 递归标记内部 _data（Array 本身会递归标记其元素）
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
    _data.gcMark(flag);
  }

  // -- 核心属性 --

  int get length => _data.length;

  set length(int newLength) {
    if (newLength < _data.length) {
      while (_data.length > newLength) _data.removeAt(_data.length - 1);
    } else {
      while (_data.length < newLength) _data.add(null as T);
    }
  }

  bool get isEmpty => _data.length == 0;
  bool get isNotEmpty => _data.length > 0;

  T get first {
    if (isEmpty) throw DartStateError('No element');
    return _data[0];
  }

  T get last {
    if (isEmpty) throw DartStateError('No element');
    return _data[_data.length - 1];
  }

  T get single {
    if (_data.length != 1) throw DartStateError('Not single element');
    return _data[0];
  }

  // -- 索引访问 --

  T operator [](int index) => _data[index];
  void operator []=(int index, T value) => _data[index] = value;

  // -- 修改操作 --

  void add(T element) => _data.add(element);

  void addAll(Iterable<T> elements) {
    for (final element in elements) _data.add(element);
  }

  void insert(int index, T element) => _data.insert(index, element);

  void insertAll(int index, Iterable<T> elements) {
    int i = index;
    for (final e in elements) {
      _data.insert(i, e);
      i++;
    }
  }

  T removeAt(int index) => _data.removeAt(index);

  bool remove(Object? element) {
    try {
      return _data.remove(element as T);
    } catch (_) {
      return false;
    }
  }

  void removeLast() {
    if (isEmpty) throw DartRangeError('Cannot removeLast on empty list');
    _data.removeAt(_data.length - 1);
  }

  void removeWhere(bool Function(T) test) {
    for (int i = _data.length - 1; i >= 0; i--) {
      if (test(_data[i])) _data.removeAt(i);
    }
  }

  void retainWhere(bool Function(T) test) {
    for (int i = _data.length - 1; i >= 0; i--) {
      if (!test(_data[i])) _data.removeAt(i);
    }
  }

  void clear() => _data.clear();

  // -- 查询操作 --

  bool contains(Object? element) {
    try {
      return _data.contains(element as T);
    } catch (_) {
      return false;
    }
  }

  int indexOf(Object? element, [int start = 0]) {
    for (int i = start; i < _data.length; i++) {
      if (_data[i] == element) return i;
    }
    return -1;
  }

  int lastIndexOf(Object? element, [int? end]) {
    final endIdx = end ?? _data.length - 1;
    for (int i = endIdx; i >= 0; i--) {
      if (_data[i] == element) return i;
    }
    return -1;
  }

  int indexWhere(bool Function(T) test, [int start = 0]) {
    for (int i = start; i < _data.length; i++) {
      if (test(_data[i])) return i;
    }
    return -1;
  }

  T elementAt(int index) => _data[index];

  // -- 迭代/函数式 --

  StaticIterator<T> get iterator => StaticIterator<T>._fromArray(_data);

  void forEach(void Function(T) action) {
    for (int i = 0; i < _data.length; i++) action(_data[i]);
  }

  StaticList<R> map<R>(R Function(T) convert) {
    final result = StaticList<R>();
    for (int i = 0; i < _data.length; i++) result.add(convert(_data[i]));
    return result;
  }

  StaticList<T> where(bool Function(T) test) {
    final result = StaticList<T>();
    for (int i = 0; i < _data.length; i++) {
      if (test(_data[i])) result.add(_data[i]);
    }
    return result;
  }

  @override
  Iterable<R> whereType<R>() {
    final result = StaticList<R>();
    for (int i = 0; i < _data.length; i++) {
      if (_data[i] is R) result.add(_data[i] as R);
    }
    return result;
  }

  StaticList<R> expand<R>(Iterable<R> Function(T) convert) {
    final result = StaticList<R>();
    for (int i = 0; i < _data.length; i++) {
      for (final r in convert(_data[i])) result.add(r);
    }
    return result;
  }

  T reduce(T Function(T, T) combine) {
    if (isEmpty) throw DartStateError('No element');
    T value = _data[0];
    for (int i = 1; i < _data.length; i++) value = combine(value, _data[i]);
    return value;
  }

  R fold<R>(R initialValue, R Function(R, T) combine) {
    R value = initialValue;
    for (int i = 0; i < _data.length; i++) value = combine(value, _data[i]);
    return value;
  }

  bool any(bool Function(T) test) {
    for (int i = 0; i < _data.length; i++) {
      if (test(_data[i])) return true;
    }
    return false;
  }

  bool every(bool Function(T) test) {
    for (int i = 0; i < _data.length; i++) {
      if (!test(_data[i])) return false;
    }
    return true;
  }

  T firstWhere(bool Function(T) test, {T Function()? orElse}) {
    for (int i = 0; i < _data.length; i++) {
      if (test(_data[i])) return _data[i];
    }
    if (orElse != null) return orElse();
    throw DartStateError('No element');
  }

  T lastWhere(bool Function(T) test, {T Function()? orElse}) {
    for (int i = _data.length - 1; i >= 0; i--) {
      if (test(_data[i])) return _data[i];
    }
    if (orElse != null) return orElse();
    throw DartStateError('No element');
  }

  StaticList<T> take(int count) {
    final result = StaticList<T>();
    final end = count < _data.length ? count : _data.length;
    for (int i = 0; i < end; i++) result.add(_data[i]);
    return result;
  }

  StaticList<T> skip(int count) {
    final result = StaticList<T>();
    for (int i = count; i < _data.length; i++) result.add(_data[i]);
    return result;
  }

  // -- 变换 --

  StaticList<T> sublist(int start, [int? end]) {
    final actualEnd = end ?? _data.length;
    final result = StaticList<T>();
    for (int i = start; i < actualEnd; i++) result.add(_data[i]);
    return result;
  }

  StaticList<T> toStaticList() => StaticList<T>.of(this);

  StaticSet<T> toStaticSet() => StaticSet<T>.of(this);

  StaticList<R> cast<R>() {
    final result = StaticList<R>();
    for (int i = 0; i < _data.length; i++) result.add(_data[i] as R);
    return result;
  }

  StaticList<T> get reversed {
    final result = StaticList<T>();
    for (int i = _data.length - 1; i >= 0; i--) result.add(_data[i]);
    return result;
  }

  StaticList<T> operator +(dynamic other) {
    final result = StaticList<T>.of(this);
    if (other is StaticList<T>) {
      result.addAll(other);
    } else if (other is Iterable<T>) {
      result.addAll(other);
    }
    return result;
  }

  // -- 排序 --

  void sort([int Function(T, T)? compare]) {
    final list = _data.toList();
    list.sort(compare);
    _data.clear();
    for (final e in list) _data.add(e);
  }

  // -- 字符串 --

  String join([String separator = '']) {
    if (isEmpty) return '';
    final buf = StringBuffer();
    buf.write(_data[0]);
    for (int i = 1; i < _data.length; i++) {
      buf.write(separator);
      buf.write(_data[i]);
    }
    return buf.toString();
  }

  // -- Map 辅助 --

  StaticMap<int, T> asMap() {
    final result = StaticMap<int, T>();
    for (int i = 0; i < _data.length; i++) result[i] = _data[i];
    return result;
  }

  // -- Iterable 接口补充 --

  StaticList<T> followedBy(Iterable<T> other) {
    final result = StaticList<T>.of(this);
    for (final e in other) result.add(e);
    return result;
  }

  T singleWhere(bool Function(T) test, {T Function()? orElse}) {
    T? found;
    bool foundMultiple = false;
    for (int i = 0; i < _data.length; i++) {
      if (test(_data[i])) {
        if (found != null) {
          foundMultiple = true;
          break;
        }
        found = _data[i];
      }
    }
    if (foundMultiple) throw DartStateError('Too many elements');
    if (found != null) return found;
    if (orElse != null) return orElse();
    throw DartStateError('No element');
  }

  StaticList<T> takeWhile(bool Function(T) test) {
    final result = StaticList<T>();
    for (int i = 0; i < _data.length; i++) {
      if (!test(_data[i])) break;
      result.add(_data[i]);
    }
    return result;
  }

  StaticList<T> skipWhile(bool Function(T) test) {
    final result = StaticList<T>();
    bool skipping = true;
    for (int i = 0; i < _data.length; i++) {
      if (skipping && test(_data[i])) continue;
      skipping = false;
      result.add(_data[i]);
    }
    return result;
  }

  @override
  List<T> toList({bool growable = true}) => List<T>.from(_data.iterable, growable: growable);

  @override
  Set<T> toSet() => Set<T>.of(_data.iterable);

  @override
  String toString() => '[${join(', ')}]';
}

// ============================================================================
// StaticMap<K, V> — 静态 Map
// ============================================================================

/// StaticMap<K, V> — 完全独立的静态 Map，不继承 Map/MapMixin。
/// entries 返回 StaticMapEntry（不是原生 MapEntry）。
class StaticMap<K, V> extends AnyGC {
  final Array<K> _keys;
  final Array<V> _values;

  StaticMap()
      : _keys = Array<K>.empty(),
        _values = Array<V>.empty();

  StaticMap.of(dynamic source)
      : _keys = Array<K>.empty(),
        _values = Array<V>.empty() {
    if (source is StaticMap<K, V>) {
      for (int i = 0; i < source._keys.length; i++) {
        _keys.add(source._keys[i]);
        _values.add(source._values[i]);
      }
    } else if (source is Map<K, V>) {
      for (final entry in source.entries) {
        _keys.add(entry.key);
        _values.add(entry.value);
      }
    }
  }

  StaticMap.from(dynamic source)
      : _keys = Array<K>.empty(),
        _values = Array<V>.empty() {
    if (source is StaticMap) {
      for (int i = 0; i < source._keys.length; i++) {
        _keys.add(source._keys[i] as K);
        _values.add(source._values[i] as V);
      }
    } else if (source is Map) {
      for (final entry in source.entries) {
        _keys.add(entry.key as K);
        _values.add(entry.value as V);
      }
    }
  }

  StaticMap.fromEntries(Iterable<StaticMapEntry<K, V>> entries)
      : _keys = Array<K>.empty(),
        _values = Array<V>.empty() {
    for (final entry in entries) {
      _keys.add(entry.key);
      _values.add(entry.value);
    }
  }

  StaticMap.fromIterables(Iterable<K> keys, Iterable<V> values)
      : _keys = Array<K>.from(keys),
        _values = Array<V>.from(values);

  /// gcMark — 递归标记 _keys 和 _values（Array 会递归标记其元素）
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
    _keys.gcMark(flag);
    _values.gcMark(flag);
  }

  // -- 核心属性 --

  int get length => _keys.length;
  bool get isEmpty => _keys.length == 0;
  bool get isNotEmpty => _keys.length > 0;

  // -- 访问 --

  V? operator [](Object? key) {
    final idx = _keys.indexOf(key as K);
    if (idx == -1) return null;
    return _values[idx];
  }

  void operator []=(K key, V value) {
    final idx = _keys.indexOf(key);
    if (idx != -1) {
      _values[idx] = value;
    } else {
      _keys.add(key);
      _values.add(value);
    }
  }

  bool containsKey(Object? key) {
    try {
      return _keys.indexOf(key as K) != -1;
    } catch (_) {
      return false;
    }
  }

  bool containsValue(Object? value) {
    try {
      return _values.indexOf(value as V) != -1;
    } catch (_) {
      return false;
    }
  }

  // -- 集合视图 --

  StaticList<K> get keys => StaticList<K>._internal(_keys);
  StaticList<V> get values => StaticList<V>._internal(_values);

  StaticList<StaticMapEntry<K, V>> get entries {
    final result = StaticList<StaticMapEntry<K, V>>();
    for (int i = 0; i < _keys.length; i++) {
      result.add(StaticMapEntry<K, V>(_keys[i], _values[i]));
    }
    return result;
  }

  // -- 修改 --

  V? remove(Object? key) {
    final idx = _keys.indexOf(key as K);
    if (idx == -1) return null;
    _keys.removeAt(idx);
    return _values.removeAt(idx);
  }

  void removeWhere(bool Function(K key, V value) test) {
    for (int i = _keys.length - 1; i >= 0; i--) {
      if (test(_keys[i], _values[i])) {
        _keys.removeAt(i);
        _values.removeAt(i);
      }
    }
  }

  void clear() {
    _keys.clear();
    _values.clear();
  }

  V putIfAbsent(K key, V Function() ifAbsent) {
    final idx = _keys.indexOf(key);
    if (idx != -1) return _values[idx];
    final value = ifAbsent();
    _keys.add(key);
    _values.add(value);
    return value;
  }

  V update(K key, V Function(V) update, {V Function()? ifAbsent}) {
    final idx = _keys.indexOf(key);
    if (idx != -1) {
      final newVal = update(_values[idx]);
      _values[idx] = newVal;
      return newVal;
    }
    if (ifAbsent != null) {
      final newVal = ifAbsent();
      _keys.add(key);
      _values.add(newVal);
      return newVal;
    }
    throw DartArgumentError('Key not found: $key');
  }

  void updateAll(V Function(K key, V value) update) {
    for (int i = 0; i < _keys.length; i++) {
      _values[i] = update(_keys[i], _values[i]);
    }
  }

  void addAll(dynamic other) {
    if (other is StaticMap<K, V>) {
      for (int i = 0; i < other._keys.length; i++) {
        this[other._keys[i]] = other._values[i];
      }
    } else if (other is Map<K, V>) {
      other.forEach((k, v) => this[k] = v);
    }
  }

  void addEntries(Iterable<StaticMapEntry<K, V>> newEntries) {
    for (final entry in newEntries) {
      this[entry.key] = entry.value;
    }
  }

  // -- 函数式 --

  StaticMap<K2, V2> map<K2, V2>(StaticMapEntry<K2, V2> Function(K key, V value) convert) {
    final result = StaticMap<K2, V2>();
    for (int i = 0; i < _keys.length; i++) {
      final entry = convert(_keys[i], _values[i]);
      result[entry.key] = entry.value;
    }
    return result;
  }

  void forEach(void Function(K key, V value) action) {
    for (int i = 0; i < _keys.length; i++) {
      action(_keys[i], _values[i]);
    }
  }

  StaticMap<RK, RV> cast<RK, RV>() {
    final result = StaticMap<RK, RV>();
    for (int i = 0; i < _keys.length; i++) {
      result[_keys[i] as RK] = _values[i] as RV;
    }
    return result;
  }

  @override
  String toString() {
    if (isEmpty) return '{}';
    final buf = StringBuffer('{');
    for (int i = 0; i < _keys.length; i++) {
      if (i > 0) buf.write(', ');
      buf.write('${_keys[i]}: ${_values[i]}');
    }
    buf.write('}');
    return buf.toString();
  }
}

// ============================================================================
// StaticSet<T> — 静态 Set
// ============================================================================

/// StaticSet<T> — 完全独立的静态 Set，不继承 Set/SetMixin。
/// extends Iterable<T> 以兼容 for-in 和 Iterable 参数场景。
class StaticSet<T> extends AnyGC implements Iterable<T> {
  final Array<T> _data;

  StaticSet() : _data = Array<T>.empty();

  StaticSet.of(Iterable<T> elements) : _data = Array<T>.empty() {
    for (final element in elements) add(element);
  }

  StaticSet.from(Iterable elements) : _data = Array<T>.empty() {
    for (final element in elements) add(element as T);
  }

  /// gcMark — 递归标记内部 _data（Array 会递归标记其元素）
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
    _data.gcMark(flag);
  }

  // -- 核心属性 --

  int get length => _data.length;
  bool get isEmpty => _data.length == 0;
  bool get isNotEmpty => _data.length > 0;

  T get first {
    if (isEmpty) throw DartStateError('No element');
    return _data[0];
  }

  T get last {
    if (isEmpty) throw DartStateError('No element');
    return _data[_data.length - 1];
  }

  T get single {
    if (_data.length != 1) throw DartStateError('Not single element');
    return _data[0];
  }

  // -- 修改 --

  bool add(T element) {
    if (_data.contains(element)) return false;
    _data.add(element);
    return true;
  }

  void addAll(Iterable<T> elements) {
    for (final element in elements) add(element);
  }

  bool remove(Object? element) {
    try {
      return _data.remove(element as T);
    } catch (_) {
      return false;
    }
  }

  void removeWhere(bool Function(T) test) {
    for (int i = _data.length - 1; i >= 0; i--) {
      if (test(_data[i])) _data.removeAt(i);
    }
  }

  void retainWhere(bool Function(T) test) {
    for (int i = _data.length - 1; i >= 0; i--) {
      if (!test(_data[i])) _data.removeAt(i);
    }
  }

  void clear() => _data.clear();

  // -- 查询 --

  bool contains(Object? element) {
    try {
      return _data.contains(element as T);
    } catch (_) {
      return false;
    }
  }

  T? lookup(Object? element) {
    try {
      final idx = _data.indexOf(element as T);
      if (idx == -1) return null;
      return _data[idx];
    } catch (_) {
      return null;
    }
  }

  // -- 迭代 --

  StaticIterator<T> get iterator => StaticIterator<T>._fromArray(_data);

  void forEach(void Function(T) action) {
    for (int i = 0; i < _data.length; i++) action(_data[i]);
  }

  // -- 函数式 --

  StaticList<R> map<R>(R Function(T) convert) {
    final result = StaticList<R>();
    for (int i = 0; i < _data.length; i++) result.add(convert(_data[i]));
    return result;
  }

  StaticSet<T> where(bool Function(T) test) {
    final result = StaticSet<T>();
    for (int i = 0; i < _data.length; i++) {
      if (test(_data[i])) result.add(_data[i]);
    }
    return result;
  }

  bool any(bool Function(T) test) {
    for (int i = 0; i < _data.length; i++) {
      if (test(_data[i])) return true;
    }
    return false;
  }

  bool every(bool Function(T) test) {
    for (int i = 0; i < _data.length; i++) {
      if (!test(_data[i])) return false;
    }
    return true;
  }

  T reduce(T Function(T, T) combine) {
    if (isEmpty) throw DartStateError('No element');
    T value = _data[0];
    for (int i = 1; i < _data.length; i++) value = combine(value, _data[i]);
    return value;
  }

  R fold<R>(R initialValue, R Function(R, T) combine) {
    R value = initialValue;
    for (int i = 0; i < _data.length; i++) value = combine(value, _data[i]);
    return value;
  }

  // -- 集合操作 --

  StaticSet<T> union(StaticSet<T> other) {
    final result = StaticSet<T>.of(this);
    for (int i = 0; i < other._data.length; i++) result.add(other._data[i]);
    return result;
  }

  StaticSet<T> intersection(StaticSet<T> other) {
    final result = StaticSet<T>();
    for (int i = 0; i < _data.length; i++) {
      if (other.contains(_data[i])) result.add(_data[i]);
    }
    return result;
  }

  StaticSet<T> difference(StaticSet<T> other) {
    final result = StaticSet<T>();
    for (int i = 0; i < _data.length; i++) {
      if (!other.contains(_data[i])) result.add(_data[i]);
    }
    return result;
  }

  // -- 变换 --

  StaticList<T> toStaticList() {
    final result = StaticList<T>();
    for (int i = 0; i < _data.length; i++) result.add(_data[i]);
    return result;
  }

  StaticSet<T> toStaticSet() => StaticSet<T>.of(this);

  StaticSet<R> cast<R>() {
    final result = StaticSet<R>();
    for (int i = 0; i < _data.length; i++) result.add(_data[i] as R);
    return result;
  }

  // -- Iterable 接口补充 --

  T elementAt(int index) => _data[index];

  StaticList<R> expand<R>(Iterable<R> Function(T) convert) {
    final result = StaticList<R>();
    for (int i = 0; i < _data.length; i++) {
      for (final r in convert(_data[i])) result.add(r);
    }
    return result;
  }

  T firstWhere(bool Function(T) test, {T Function()? orElse}) {
    for (int i = 0; i < _data.length; i++) {
      if (test(_data[i])) return _data[i];
    }
    if (orElse != null) return orElse();
    throw DartStateError('No element');
  }

  T lastWhere(bool Function(T) test, {T Function()? orElse}) {
    for (int i = _data.length - 1; i >= 0; i--) {
      if (test(_data[i])) return _data[i];
    }
    if (orElse != null) return orElse();
    throw DartStateError('No element');
  }

  T singleWhere(bool Function(T) test, {T Function()? orElse}) {
    T? found;
    bool foundMultiple = false;
    for (int i = 0; i < _data.length; i++) {
      if (test(_data[i])) {
        if (found != null) {
          foundMultiple = true;
          break;
        }
        found = _data[i];
      }
    }
    if (foundMultiple) throw DartStateError('Too many elements');
    if (found != null) return found;
    if (orElse != null) return orElse();
    throw DartStateError('No element');
  }

  StaticSet<T> followedBy(Iterable<T> other) {
    final result = StaticSet<T>.of(this);
    for (final e in other) result.add(e);
    return result;
  }

  StaticSet<T> take(int count) {
    final result = StaticSet<T>();
    final end = count < _data.length ? count : _data.length;
    for (int i = 0; i < end; i++) result.add(_data[i]);
    return result;
  }

  StaticSet<T> skip(int count) {
    final result = StaticSet<T>();
    for (int i = count; i < _data.length; i++) result.add(_data[i]);
    return result;
  }

  StaticSet<T> takeWhile(bool Function(T) test) {
    final result = StaticSet<T>();
    for (int i = 0; i < _data.length; i++) {
      if (!test(_data[i])) break;
      result.add(_data[i]);
    }
    return result;
  }

  StaticSet<T> skipWhile(bool Function(T) test) {
    final result = StaticSet<T>();
    bool skipping = true;
    for (int i = 0; i < _data.length; i++) {
      if (skipping && test(_data[i])) continue;
      skipping = false;
      result.add(_data[i]);
    }
    return result;
  }

  Iterable<R> whereType<R>() {
    final result = StaticSet<R>();
    for (int i = 0; i < _data.length; i++) {
      if (_data[i] is R) result.add(_data[i] as R);
    }
    return result;
  }

  @override
  List<T> toList({bool growable = true}) => List<T>.from(_data.iterable, growable: growable);

  @override
  Set<T> toSet() => Set<T>.of(_data.iterable);

  // -- 字符串 --

  String join([String separator = '']) {
    if (isEmpty) return '';
    final buf = StringBuffer();
    buf.write(_data[0]);
    for (int i = 1; i < _data.length; i++) {
      buf.write(separator);
      buf.write(_data[i]);
    }
    return buf.toString();
  }

  @override
  String toString() => '{${join(', ')}}';
}

// ============================================================================
// StaticMapEntry<K,V> — 替代原生 MapEntry
// ============================================================================

/// StaticMapEntry<K,V> — 替代原生 MapEntry（MapEntry 是 final class 无法继承）
class StaticMapEntry<K, V> {
  final K key;
  final V value;
  const StaticMapEntry(this.key, this.value);

  /// 转换为原生 MapEntry（供需要 MapEntry 的 API 使用）
  MapEntry<K, V> toMapEntry() => MapEntry<K, V>(key, value);

  @override
  String toString() => 'StaticMapEntry($key: $value)';

  @override
  bool operator ==(Object other) =>
      other is StaticMapEntry<K, V> && other.key == key && other.value == value;

  @override
  int get hashCode => Object.hash(key, value);
}

// ============================================================================
// StaticIterator<T> — 统一迭代器
// ============================================================================

/// StaticIterator<T> — 统一的迭代器，支持从原生 Iterator 或 Array 构造
class StaticIterator<T> implements Iterator<T> {
  final Iterator<T> _delegate;
  StaticIterator(this._delegate);

  /// 从 Array 直接构造（内部使用，避免依赖原生 List.iterator）
  StaticIterator._fromArray(Array<T> array)
      : _delegate = _ArrayIterator<T>(array);

  @override
  bool moveNext() => _delegate.moveNext();
  @override
  T get current => _delegate.current;
}

/// Array 的原生迭代器实现
class _ArrayIterator<T> implements Iterator<T> {
  final Array<T> _array;
  int _index = -1;
  _ArrayIterator(this._array);

  @override
  T get current => _array[_index];
  @override
  bool moveNext() {
    _index++;
    return _index < _array.length;
  }
}
