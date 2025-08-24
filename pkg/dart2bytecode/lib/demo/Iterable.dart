import 'dart:math' as math;
import 'collection.dart';
import 'object.dart';
import 'string.dart';

/// 基础迭代器接口
@pragma('cpp:patch', 'CppIterator')
abstract class CppIterator<E> extends CppObject {
  /// 当前元素
  E get current;

  /// 移动到下一个元素
  bool moveNext();
}

/// 基础可迭代对象接口
@pragma('cpp:patch', 'CppIterable')
abstract class CppIterable<E> extends CppObject {
  const CppIterable();

  /// 获取迭代器
  CppIterator<E> get iterator;

  /// 长度
  int get length;

  /// 是否为空
  bool get isEmpty => length == 0;

  /// 是否非空
  bool get isNotEmpty => length > 0;

  /// 第一个元素
  E get first {
    if (isEmpty) throw StateError('No element');
    var it = iterator;
    if (!it.moveNext()) throw StateError('No element');
    return it.current;
  }

  /// 最后一个元素
  E get last {
    if (isEmpty) throw StateError('No element');
    var it = iterator;
    E? result;
    while (it.moveNext()) {
      result = it.current;
    }
    return result as E;
  }

  /// 单个元素（仅当只有一个元素时）
  E get single {
    if (isEmpty) throw StateError('No element');
    var it = iterator;
    it.moveNext();
    E result = it.current;
    if (it.moveNext()) throw StateError('Too many elements');
    return result;
  }

  /// 获取指定索引的元素
  E elementAt(int index) {
    if (index < 0) throw ArgumentError('Index cannot be negative');
    var it = iterator;
    for (int i = 0; i <= index; i++) {
      if (!it.moveNext()) throw RangeError.index(index, this);
      if (i == index) return it.current;
    }
    throw RangeError.index(index, this);
  }

  /// 是否包含指定元素
  bool contains(Object? element) {
    var it = iterator;
    while (it.moveNext()) {
      if (it.current == element) return true;
    }
    return false;
  }

  /// 遍历每个元素
  void forEach(void Function(E element) action) {
    var it = iterator;
    while (it.moveNext()) {
      action(it.current);
    }
  }

  /// 映射转换
  CppIterable<T> map<T>(T Function(E element) toElement) {
    return CppMappedIterable<E, T>(this, toElement);
  }

  /// 过滤
  CppIterable<E> where(bool Function(E element) test) {
    return CppWhereIterable<E>(this, test);
  }

  /// 类型过滤
  CppIterable<T> whereType<T>() {
    return CppWhereTypeIterable<T>(this);
  }

  /// 展开
  CppIterable<T> expand<T>(CppIterable<T> Function(E element) toElements) {
    return CppExpandIterable<E, T>(this, toElements);
  }

  /// 是否存在满足条件的元素
  bool any(bool Function(E element) test) {
    var it = iterator;
    while (it.moveNext()) {
      if (test(it.current)) return true;
    }
    return false;
  }

  /// 是否所有元素都满足条件
  bool every(bool Function(E element) test) {
    var it = iterator;
    while (it.moveNext()) {
      if (!test(it.current)) return false;
    }
    return true;
  }

  /// 查找第一个匹配的元素
  E firstWhere(bool Function(E element) test, {E Function()? orElse}) {
    var it = iterator;
    while (it.moveNext()) {
      if (test(it.current)) return it.current;
    }
    if (orElse != null) return orElse();
    throw StateError('No element');
  }

  /// 查找最后一个匹配的元素
  E lastWhere(bool Function(E element) test, {E Function()? orElse}) {
    var it = iterator;
    E? result;
    bool found = false;
    while (it.moveNext()) {
      if (test(it.current)) {
        result = it.current;
        found = true;
      }
    }
    if (found) return result as E;
    if (orElse != null) return orElse();
    throw StateError('No element');
  }

  /// 查找单个匹配的元素
  E singleWhere(bool Function(E element) test, {E Function()? orElse}) {
    var it = iterator;
    E? result;
    bool found = false;
    while (it.moveNext()) {
      if (test(it.current)) {
        if (found) throw StateError('Too many elements');
        result = it.current;
        found = true;
      }
    }
    if (found) return result as E;
    if (orElse != null) return orElse();
    throw StateError('No element');
  }

  /// 归约
  E reduce(E Function(E value, E element) combine) {
    var it = iterator;
    if (!it.moveNext()) throw StateError('No element');
    E value = it.current;
    while (it.moveNext()) {
      value = combine(value, it.current);
    }
    return value;
  }

  /// 折叠
  T fold<T>(T initialValue, T Function(T previousValue, E element) combine) {
    var value = initialValue;
    var it = iterator;
    while (it.moveNext()) {
      value = combine(value, it.current);
    }
    return value;
  }

  /// 连接为字符串
  CppString join([CppString separator = CppString.Empty]) {
    var it = iterator;
    if (!it.moveNext()) return CppString.Empty;
    var buffer = CppStringBuffer(it.current.toString());
    while (it.moveNext()) {
      buffer.write(separator);
      buffer.write(it.current.toString());
    }
    return buffer.toCppString();
  }

  /// 取前n个元素
  CppIterable<E> take(int count) {
    return CppTakeIterable<E>(this, count);
  }

  /// 取满足条件的前n个元素
  CppIterable<E> takeWhile(bool Function(E value) test) {
    return CppTakeWhileIterable<E>(this, test);
  }

  /// 跳过前n个元素
  CppIterable<E> skip(int count) {
    return CppSkipIterable<E>(this, count);
  }

  /// 跳过满足条件的前n个元素
  CppIterable<E> skipWhile(bool Function(E value) test) {
    return CppSkipWhileIterable<E>(this, test);
  }

  /// 反转
  CppIterable<E> get reversed {
    return CppReversedIterable<E>(this);
  }

  /// 连接其他可迭代对象
  CppIterable<E> followedBy(CppIterable<E> other) {
    return CppFollowedByIterable<E>(this, other);
  }

  /// 转换为CppList
  CppList<E> toList({bool growable = true}) {
    return CppList<E>.from(this as CppIterable, growable: growable);
  }

  /// 转换为CppSet
  CppSet<E> toSet() {
    return CppSet<E>.from(this);
  }

  /// 类型转换
  CppIterable<T> cast<T>() {
    return CppCastIterable<E, T>(this);
  }

  /// CppIterable.empty()
  static CppIterable<E> empty<E>() => _CppEmptyIterable<E>();

  /// CppIterable.generate()
  static CppIterable<E> generate<E>(int count, E Function(int) generator) {
    return _CppGenerateIterable<E>(count, generator);
  }

  /// CppIterable.unmodifiable()
  static CppIterable<E> unmodifiable<E>(CppIterable<E> elements) {
    return _CppUnmodifiableIterable<E>(elements.toList());
  }

  /// CppIterable.castFrom()
  static CppIterable<R> castFrom<S, R>(CppIterable<S> source) {
    return _CppCastFromIterable<S, R>(source);
  }
}

/// 映射迭代器
class CppMappedIterable<S, T> extends CppIterable<T> {
  final CppIterable<S> _source;
  final T Function(S element) _f;
  CppMappedIterable(this._source, this._f) : super();

  @override
  CppIterator<T> get iterator => CppMappedIterator<S, T>(_source.iterator, _f);

  @override
  int get length => _source.length;
}

class CppMappedIterator<S, T> extends CppIterator<T> {
  final CppIterator<S> _iterator;
  final T Function(S element) _f;
  T? _current;

  CppMappedIterator(this._iterator, this._f);

  @override
  T get current => _current as T;

  @override
  bool moveNext() {
    if (_iterator.moveNext()) {
      _current = _f(_iterator.current);
      return true;
    }
    return false;
  }
}

/// 过滤迭代器
class CppWhereIterable<E> extends CppIterable<E> {
  final CppIterable<E> _source;
  final bool Function(E element) _test;
  CppWhereIterable(this._source, this._test) : super();

  @override
  CppIterator<E> get iterator => CppWhereIterator<E>(_source.iterator, _test);

  @override
  int get length {
    int count = 0;
    var it = iterator;
    while (it.moveNext()) {
      count++;
    }
    return count;
  }
}

class CppWhereIterator<E> extends CppIterator<E> {
  final CppIterator<E> _iterator;
  final bool Function(E element) _test;

  CppWhereIterator(this._iterator, this._test);

  @override
  E get current => _iterator.current;

  @override
  bool moveNext() {
    while (_iterator.moveNext()) {
      if (_test(_iterator.current)) {
        return true;
      }
    }
    return false;
  }
}

/// 类型过滤迭代器
class CppWhereTypeIterable<T> extends CppIterable<T> {
  final CppIterable<dynamic> _source;
  CppWhereTypeIterable(this._source) : super();

  @override
  CppIterator<T> get iterator => CppWhereTypeIterator<T>(_source.iterator);

  @override
  int get length {
    int count = 0;
    var it = iterator;
    while (it.moveNext()) {
      count++;
    }
    return count;
  }
}

class CppWhereTypeIterator<T> extends CppIterator<T> {
  final CppIterator<dynamic> _iterator;

  CppWhereTypeIterator(this._iterator);

  @override
  T get current => _iterator.current as T;

  @override
  bool moveNext() {
    while (_iterator.moveNext()) {
      if (_iterator.current is T) {
        return true;
      }
    }
    return false;
  }
}

/// 展开迭代器
class CppExpandIterable<S, T> extends CppIterable<T> {
  final CppIterable<S> _source;
  final CppIterable<T> Function(S element) _f;
  CppExpandIterable(this._source, this._f) : super();

  @override
  CppIterator<T> get iterator => CppExpandIterator<S, T>(_source.iterator, _f);

  @override
  int get length {
    int count = 0;
    var it = iterator;
    while (it.moveNext()) {
      count++;
    }
    return count;
  }
}

class CppExpandIterator<S, T> extends CppIterator<T> {
  final CppIterator<S> _iterator;
  final CppIterable<T> Function(S element) _f;
  CppIterator<T>? _currentIterator;

  CppExpandIterator(this._iterator, this._f);

  @override
  T get current => _currentIterator!.current;

  @override
  bool moveNext() {
    while (true) {
      if (_currentIterator != null && _currentIterator!.moveNext()) {
        return true;
      }
      if (!_iterator.moveNext()) {
        return false;
      }
      _currentIterator = _f(_iterator.current).iterator;
    }
  }
}

/// Take迭代器
class CppTakeIterable<E> extends CppIterable<E> {
  final CppIterable<E> _source;
  final int _count;
  CppTakeIterable(this._source, this._count) : super();

  @override
  CppIterator<E> get iterator => CppTakeIterator<E>(_source.iterator, _count);

  @override
  int get length => math.min(_count, _source.length);
}

class CppTakeIterator<E> extends CppIterator<E> {
  final CppIterator<E> _iterator;
  final int _count;
  int _remaining;

  CppTakeIterator(this._iterator, this._count) : _remaining = _count;

  @override
  E get current => _iterator.current;

  @override
  bool moveNext() {
    if (_remaining <= 0) return false;
    if (_iterator.moveNext()) {
      _remaining--;
      return true;
    }
    return false;
  }
}

/// TakeWhile迭代器
class CppTakeWhileIterable<E> extends CppIterable<E> {
  final CppIterable<E> _source;
  final bool Function(E value) _test;
  CppTakeWhileIterable(this._source, this._test) : super();

  @override
  CppIterator<E> get iterator =>
      CppTakeWhileIterator<E>(_source.iterator, _test);

  @override
  int get length {
    int count = 0;
    var it = iterator;
    while (it.moveNext()) {
      count++;
    }
    return count;
  }
}

class CppTakeWhileIterator<E> extends CppIterator<E> {
  final CppIterator<E> _iterator;
  final bool Function(E value) _test;
  bool _finished = false;

  CppTakeWhileIterator(this._iterator, this._test);

  @override
  E get current => _iterator.current;

  @override
  bool moveNext() {
    if (_finished) return false;
    if (_iterator.moveNext()) {
      if (_test(_iterator.current)) {
        return true;
      }
      _finished = true;
    }
    return false;
  }
}

/// Skip迭代器
class CppSkipIterable<E> extends CppIterable<E> {
  final CppIterable<E> _source;
  final int _count;
  CppSkipIterable(this._source, this._count) : super();

  @override
  CppIterator<E> get iterator => CppSkipIterator<E>(_source.iterator, _count);

  @override
  int get length => math.max(0, _source.length - _count);
}

class CppSkipIterator<E> extends CppIterator<E> {
  final CppIterator<E> _iterator;
  final int _count;
  bool _skipped = false;

  CppSkipIterator(this._iterator, this._count);

  @override
  E get current => _iterator.current;

  @override
  bool moveNext() {
    if (!_skipped) {
      for (int i = 0; i < _count; i++) {
        if (!_iterator.moveNext()) return false;
      }
      _skipped = true;
    }
    return _iterator.moveNext();
  }
}

/// SkipWhile迭代器
class CppSkipWhileIterable<E> extends CppIterable<E> {
  final CppIterable<E> _source;
  final bool Function(E value) _test;
  CppSkipWhileIterable(this._source, this._test) : super();

  @override
  CppIterator<E> get iterator =>
      CppSkipWhileIterator<E>(_source.iterator, _test);

  @override
  int get length {
    int count = 0;
    var it = iterator;
    while (it.moveNext()) {
      count++;
    }
    return count;
  }
}

class CppSkipWhileIterator<E> extends CppIterator<E> {
  final CppIterator<E> _iterator;
  final bool Function(E value) _test;
  bool _skipped = false;

  CppSkipWhileIterator(this._iterator, this._test);

  @override
  E get current => _iterator.current;

  @override
  bool moveNext() {
    if (!_skipped) {
      while (_iterator.moveNext()) {
        if (!_test(_iterator.current)) {
          _skipped = true;
          return true;
        }
      }
      return false;
    }
    return _iterator.moveNext();
  }
}

/// 反转迭代器
class CppReversedIterable<E> extends CppIterable<E> {
  final CppIterable<E> _source;
  CppReversedIterable(this._source) : super();

  @override
  CppIterator<E> get iterator => CppReversedIterator<E>(_source);

  @override
  int get length => _source.length;
}

class CppReversedIterator<E> extends CppIterator<E> {
  final CppList<E> _elements;
  int _index;

  CppReversedIterator(CppIterable<E> source)
      : _elements = CppList<E>.from(source as CppIterable),
        _index = source.length;

  @override
  E get current => _elements[_index];

  @override
  bool moveNext() {
    if (_index > 0) {
      _index--;
      return true;
    }
    return false;
  }
}

/// 连接迭代器
class CppFollowedByIterable<E> extends CppIterable<E> {
  final CppIterable<E> _first;
  final CppIterable<E> _second;
  CppFollowedByIterable(this._first, this._second) : super();

  @override
  CppIterator<E> get iterator =>
      CppFollowedByIterator<E>(_first.iterator, _second.iterator);

  @override
  int get length => _first.length + _second.length;
}

class CppFollowedByIterator<E> extends CppIterator<E> {
  final CppIterator<E> _first;
  final CppIterator<E> _second;
  bool _usingFirst = true;

  CppFollowedByIterator(this._first, this._second);

  @override
  E get current => _usingFirst ? _first.current : _second.current;

  @override
  bool moveNext() {
    if (_usingFirst) {
      if (_first.moveNext()) {
        return true;
      }
      _usingFirst = false;
    }
    return _second.moveNext();
  }
}

/// 类型转换迭代器
class CppCastIterable<S, T> extends CppIterable<T> {
  final CppIterable<S> _source;
  CppCastIterable(this._source) : super();

  @override
  CppIterator<T> get iterator => CppCastIterator<S, T>(_source.iterator);

  @override
  int get length => _source.length;
}

class CppCastIterator<S, T> extends CppIterator<T> {
  final CppIterator<S> _iterator;

  CppCastIterator(this._iterator);

  @override
  T get current => _iterator.current as T;

  @override
  bool moveNext() => _iterator.moveNext();
}

/// 空迭代器实现
class _CppEmptyIterable<E> extends CppIterable<E> {
  _CppEmptyIterable() : super();
  @override
  CppIterator<E> get iterator => _CppEmptyIterator<E>();
  @override
  int get length => 0;
}

class _CppEmptyIterator<E> extends CppIterator<E> {
  _CppEmptyIterator() : super();
  @override
  E get current => throw StateError('No element');
  @override
  bool moveNext() => false;
}

/// 生成迭代器实现
class _CppGenerateIterable<E> extends CppIterable<E> {
  final int _count;
  final E Function(int) _generator;
  _CppGenerateIterable(this._count, this._generator) : super();
  @override
  CppIterator<E> get iterator => _CppGenerateIterator<E>(_count, _generator);
  @override
  int get length => _count;
}

class _CppGenerateIterator<E> extends CppIterator<E> {
  final int _count;
  final E Function(int) _generator;
  int _index = 0;
  E? _current;
  _CppGenerateIterator(this._count, this._generator) : super();
  @override
  E get current => _current as E;
  @override
  bool moveNext() {
    if (_index < _count) {
      _current = _generator(_index++);
      return true;
    }
    return false;
  }
}

/// 不可变迭代器实现
class _CppUnmodifiableIterable<E> extends CppIterable<E> {
  final CppList<E> _elements;
  _CppUnmodifiableIterable(this._elements) : super();
  @override
  CppIterator<E> get iterator => _elements.iterator;
  @override
  int get length => _elements.length;
}

/// 类型转换工厂实现
class _CppCastFromIterable<S, R> extends CppIterable<R> {
  final CppIterable<S> _source;
  _CppCastFromIterable(this._source) : super();
  @override
  CppIterator<R> get iterator => _CppCastFromIterator<S, R>(_source.iterator);
  @override
  int get length => _source.length;
}

class _CppCastFromIterator<S, R> extends CppIterator<R> {
  final CppIterator<S> _iterator;
  _CppCastFromIterator(this._iterator) : super();
  @override
  R get current => _iterator.current as R;
  @override
  bool moveNext() => _iterator.moveNext();
}
