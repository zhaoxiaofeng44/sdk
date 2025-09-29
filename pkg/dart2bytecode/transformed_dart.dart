import 'dart:core';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'lib/demo/box.dart';
import 'lib/demo/function.dart';

/// cpp:native 类导入
import 'lib/demo/api.dart';

/// 全局Void类型变量，用于替代void返回值
final Void = null;

/// 文件编码映射注解
/// 用于标识不同源文件中的类，避免类名冲突
/// 格式: 编码 -> 源文件路径
///
/// AA -> /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/iterable.dart
/// AB -> /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/object.dart
/// AC -> /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/string.dart
/// AD -> /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/collection.dart
/// AE -> /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/error.dart

/// 转换后的类: CppIterator
/// 原始类名: CppIterator
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/iterable.dart

abstract class CppIterator<E> extends CppAny {
  CppIterator() : super() {
    ;
  }

  E get current;

  bool moveNext();
}

/// 转换后的类: CppIterable
/// 原始类名: CppIterable
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/iterable.dart

abstract class CppIterable<E> extends CppAny {
  const CppIterable() : super();

  CppIterator<E> get iterator;

  int get length;

  bool get isEmpty {
    return this.length == 0;
  }

  bool get isNotEmpty {
    return (this.length > 0);
  }

  E get first {
    {
      if (this.isEmpty) throw CppStateError(const_0);
      CppIterator<E> it = this.iterator;
      if (!(it.moveNext())) throw CppStateError(const_0);
      return it.current;
    }
  }

  E get last {
    {
      if (this.isEmpty) throw CppStateError(const_0);
      CppIterator<E> it = this.iterator;
      E? result;
      while (it.moveNext()) {
        result = it.current;
      }
      return (() {
        final E? temp_3325 = result;
        return temp_3325 == null ? (temp_3325 as E) : temp_3325;
      })();
    }
  }

  E get single {
    {
      if (this.isEmpty) throw CppStateError(const_0);
      CppIterator<E> it = this.iterator;
      it.moveNext();
      E result = it.current;
      if (it.moveNext()) throw CppStateError(const_1);
      return result;
    }
  }

  E elementAt(int index) {
    {
      if ((index < 0)) throw ArgumentError(const_2);
      CppIterator<E> it = this.iterator;
      for (int i = 0; (i <= index); i = (i + 1)) {
        if (!(it.moveNext())) throw CppIndexError(index, this);
        if (i == index) return it.current;
      }
      throw CppIndexError(index, this);
    }
  }

  bool contains(Object? element) {
    {
      CppIterator<E> it = this.iterator;
      while (it.moveNext()) {
        if (it.current == element) return true;
      }
      return false;
    }
  }

  void forEach(FunctionWrapper<void Function(E)> action) {
    {
      CppIterator<E> it = this.iterator;
      while (it.moveNext()) {
        action.call(it.current);
      }
    }
  }

  CppIterable<T> map<T>(FunctionWrapper<T Function(E)> toElement) {
    {
      return CppMappedIterable<E, T>(this, toElement);
    }
  }

  CppIterable<E> where(FunctionWrapper<bool Function(E)> test) {
    {
      return CppWhereIterable<E>(this, test);
    }
  }

  CppIterable<T> whereType<T>() {
    {
      return CppWhereTypeIterable<T>(this);
    }
  }

  CppIterable<T> expand<T>(
      FunctionWrapper<CppIterable<T> Function(E)> toElements) {
    {
      return CppExpandIterable<E, T>(this, toElements);
    }
  }

  bool any(FunctionWrapper<bool Function(E)> test) {
    {
      CppIterator<E> it = this.iterator;
      while (it.moveNext()) {
        if (test.call(it.current)) return true;
      }
      return false;
    }
  }

  bool every(FunctionWrapper<bool Function(E)> test) {
    {
      CppIterator<E> it = this.iterator;
      while (it.moveNext()) {
        if (!(test.call(it.current))) return false;
      }
      return true;
    }
  }

  E firstWhere(FunctionWrapper<bool Function(E)> test,
      {FunctionWrapper<E Function()>? orElse = null}) {
    {
      CppIterator<E> it = this.iterator;
      while (it.moveNext()) {
        if (test.call(it.current)) return it.current;
      }
      if (!(orElse == null)) return orElse.call();
      throw CppStateError(const_0);
    }
  }

  E lastWhere(FunctionWrapper<bool Function(E)> test,
      {FunctionWrapper<E Function()>? orElse = null}) {
    {
      CppIterator<E> it = this.iterator;
      E? result;
      bool found = false;
      while (it.moveNext()) {
        if (test.call(it.current)) {
          result = it.current;
          found = true;
        }
      }
      if (found)
        return (() {
          final E? temp_3333 = result;
          return temp_3333 == null ? (temp_3333 as E) : temp_3333;
        })();
      if (!(orElse == null)) return orElse.call();
      throw CppStateError(const_0);
    }
  }

  E singleWhere(FunctionWrapper<bool Function(E)> test,
      {FunctionWrapper<E Function()>? orElse = null}) {
    {
      CppIterator<E> it = this.iterator;
      E? result;
      bool found = false;
      while (it.moveNext()) {
        if (test.call(it.current)) {
          if (found) throw CppStateError(const_1);
          result = it.current;
          found = true;
        }
      }
      if (found)
        return (() {
          final E? temp_3341 = result;
          return temp_3341 == null ? (temp_3341 as E) : temp_3341;
        })();
      if (!(orElse == null)) return orElse.call();
      throw CppStateError(const_0);
    }
  }

  E reduce(FunctionWrapper<E Function(E, E)> combine) {
    {
      CppIterator<E> it = this.iterator;
      if (!(it.moveNext())) throw CppStateError(const_0);
      E value = it.current;
      while (it.moveNext()) {
        value = combine.call(value, it.current);
      }
      return value;
    }
  }

  T fold<T>(T initialValue, FunctionWrapper<T Function(T, E)> combine) {
    {
      T value = initialValue;
      CppIterator<E> it = this.iterator;
      while (it.moveNext()) {
        value = combine.call(value, it.current);
      }
      return value;
    }
  }

  CppString join(
      [CppString separator = const CppString.fromCppUserData(
          const CppUserData.constant(const_3))]) {
    {
      CppIterator<E> it = this.iterator;
      if (!(it.moveNext()))
        return const CppString.fromCppUserData(
            const CppUserData.constant(const_3));
      CppStringBuffer buffer =
          CppStringBuffer(CppString.convertString(it.current));
      while (it.moveNext()) {
        buffer.write(separator);
        buffer.write(CppString.convertString(it.current));
      }
      return buffer.toCppString();
    }
  }

  CppIterable<E> take(int count) {
    {
      return CppTakeIterable<E>(this, count);
    }
  }

  CppIterable<E> takeWhile(FunctionWrapper<bool Function(E)> test) {
    {
      return CppTakeWhileIterable<E>(this, test);
    }
  }

  CppIterable<E> skip(int count) {
    {
      return CppSkipIterable<E>(this, count);
    }
  }

  CppIterable<E> skipWhile(FunctionWrapper<bool Function(E)> test) {
    {
      return CppSkipWhileIterable<E>(this, test);
    }
  }

  CppIterable<E> get reversed {
    {
      return CppReversedIterable<E>(this);
    }
  }

  CppIterable<E> followedBy(CppIterable<E> other) {
    {
      return CppFollowedByIterable<E>(this, other);
    }
  }

  CppList<E> toList({bool growable = const_4}) {
    {
      return CppList<E>.from((this as CppIterable<dynamic?>),
          growable: growable);
    }
  }

  CppSet<E> toSet() {
    {
      return CppSet<E>.from((this as CppIterable<dynamic?>));
    }
  }

  CppIterable<T> cast<T>() {
    {
      return CppCastIterable<E, T>(this);
    }
  }

  static CppIterable<E> empty<E>() {
    return _CppEmptyIterable<E>();
  }

  static CppIterable<E> generate<E>(
      int count, FunctionWrapper<E Function(int)> generator) {
    {
      return _CppGenerateIterable<E>(count, generator);
    }
  }

  static CppIterable<E> unmodifiable<E>(CppIterable<E> elements) {
    {
      return _CppUnmodifiableIterable<E>(elements.toList());
    }
  }

  static CppIterable<R> castFrom<S, R>(CppIterable<S> source) {
    {
      return _CppCastFromIterable<S, R>(source);
    }
  }
}

/// 转换后的类: CppMappedIterable
/// 原始类名: CppMappedIterable
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/iterable.dart

class CppMappedIterable<S, T> extends CppIterable<T> {
  final CppIterable<S> _source;
  final FunctionWrapper<T Function(S)> _f;
  CppMappedIterable(CppIterable<S> _source, FunctionWrapper<T Function(S)> _f)
      : _source = _source,
        _f = _f,
        super() {
    ;
  }

  CppIterator<T> get iterator {
    return CppMappedIterator<S, T>(this._source.iterator, this._f);
  }

  int get length {
    return this._source.length;
  }
}

/// 转换后的类: CppMappedIterator
/// 原始类名: CppMappedIterator
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/iterable.dart

class CppMappedIterator<S, T> extends CppIterator<T> {
  final CppIterator<S> _iterator;
  final FunctionWrapper<T Function(S)> _f;
  T? _current = null;
  CppMappedIterator(CppIterator<S> _iterator, FunctionWrapper<T Function(S)> _f)
      : _iterator = _iterator,
        _f = _f,
        super() {
    ;
  }

  T get current {
    return (() {
      final T? temp_3349 = this._current;
      return temp_3349 == null ? (temp_3349 as T) : temp_3349;
    })();
  }

  bool moveNext() {
    {
      if (this._iterator.moveNext()) {
        this._current = (() {
          final S temp_6861_3582 = this._iterator.current;
          return this._f.call(temp_6861_3582);
        })();
        return true;
      }
      return false;
    }
  }
}

/// 转换后的类: CppWhereIterable
/// 原始类名: CppWhereIterable
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/iterable.dart

class CppWhereIterable<E> extends CppIterable<E> {
  final CppIterable<E> _source;
  final FunctionWrapper<bool Function(E)> _test;
  CppWhereIterable(
      CppIterable<E> _source, FunctionWrapper<bool Function(E)> _test)
      : _source = _source,
        _test = _test,
        super() {
    ;
  }

  CppIterator<E> get iterator {
    return CppWhereIterator<E>(this._source.iterator, this._test);
  }

  int get length {
    {
      int count = 0;
      CppIterator<E> it = this.iterator;
      while (it.moveNext()) {
        count = (count + 1);
      }
      return count;
    }
  }
}

/// 转换后的类: CppWhereIterator
/// 原始类名: CppWhereIterator
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/iterable.dart

class CppWhereIterator<E> extends CppIterator<E> {
  final CppIterator<E> _iterator;
  final FunctionWrapper<bool Function(E)> _test;
  CppWhereIterator(
      CppIterator<E> _iterator, FunctionWrapper<bool Function(E)> _test)
      : _iterator = _iterator,
        _test = _test,
        super() {
    ;
  }

  E get current {
    return this._iterator.current;
  }

  bool moveNext() {
    {
      while (this._iterator.moveNext()) {
        if ((() {
          final E temp_7669_3668 = this._iterator.current;
          return this._test.call(temp_7669_3668);
        })()) {
          return true;
        }
      }
      return false;
    }
  }
}

/// 转换后的类: CppWhereTypeIterable
/// 原始类名: CppWhereTypeIterable
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/iterable.dart

class CppWhereTypeIterable<T> extends CppIterable<T> {
  final CppIterable<dynamic?> _source;
  CppWhereTypeIterable(CppIterable<dynamic?> _source)
      : _source = _source,
        super() {
    ;
  }

  CppIterator<T> get iterator {
    return CppWhereTypeIterator<T>(this._source.iterator);
  }

  int get length {
    {
      int count = 0;
      CppIterator<T> it = this.iterator;
      while (it.moveNext()) {
        count = (count + 1);
      }
      return count;
    }
  }
}

/// 转换后的类: CppWhereTypeIterator
/// 原始类名: CppWhereTypeIterator
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/iterable.dart

class CppWhereTypeIterator<T> extends CppIterator<T> {
  final CppIterator<dynamic?> _iterator;
  CppWhereTypeIterator(CppIterator<dynamic?> _iterator)
      : _iterator = _iterator,
        super() {
    ;
  }

  T get current {
    return (this._iterator.current as T);
  }

  bool moveNext() {
    {
      while (this._iterator.moveNext()) {
        if ((this._iterator.current is T)) {
          return true;
        }
      }
      return false;
    }
  }
}

/// 转换后的类: CppExpandIterable
/// 原始类名: CppExpandIterable
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/iterable.dart

class CppExpandIterable<S, T> extends CppIterable<T> {
  final CppIterable<S> _source;
  final FunctionWrapper<CppIterable<T> Function(S)> _f;
  CppExpandIterable(
      CppIterable<S> _source, FunctionWrapper<CppIterable<T> Function(S)> _f)
      : _source = _source,
        _f = _f,
        super() {
    ;
  }

  CppIterator<T> get iterator {
    return CppExpandIterator<S, T>(this._source.iterator, this._f);
  }

  int get length {
    {
      int count = 0;
      CppIterator<T> it = this.iterator;
      while (it.moveNext()) {
        count = (count + 1);
      }
      return count;
    }
  }
}

/// 转换后的类: CppExpandIterator
/// 原始类名: CppExpandIterator
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/iterable.dart

class CppExpandIterator<S, T> extends CppIterator<T> {
  final CppIterator<S> _iterator;
  final FunctionWrapper<CppIterable<T> Function(S)> _f;
  CppIterator<T>? _currentIterator = null;
  CppExpandIterator(
      CppIterator<S> _iterator, FunctionWrapper<CppIterable<T> Function(S)> _f)
      : _iterator = _iterator,
        _f = _f,
        super() {
    ;
  }

  T get current {
    return this._currentIterator!.current;
  }

  bool moveNext() {
    {
      while (true) {
        if (!(this._currentIterator == null) &&
            this._currentIterator!.moveNext()) {
          return true;
        }
        if (!(this._iterator.moveNext())) {
          return false;
        }
        this._currentIterator = (() {
          final S temp_9458_3849 = this._iterator.current;
          return this._f.call(temp_9458_3849);
        })()
            .iterator;
      }
    }
  }
}

/// 转换后的类: CppTakeIterable
/// 原始类名: CppTakeIterable
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/iterable.dart

class CppTakeIterable<E> extends CppIterable<E> {
  final CppIterable<E> _source;
  final int _count;
  CppTakeIterable(CppIterable<E> _source, int _count)
      : _source = _source,
        _count = _count,
        super() {
    ;
  }

  CppIterator<E> get iterator {
    return CppTakeIterator<E>(this._source.iterator, this._count);
  }

  int get length {
    return min<int>(this._count, this._source.length);
  }
}

/// 转换后的类: CppTakeIterator
/// 原始类名: CppTakeIterator
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/iterable.dart

class CppTakeIterator<E> extends CppIterator<E> {
  final CppIterator<E> _iterator;
  final int _count;
  late int _remaining;
  CppTakeIterator(CppIterator<E> _iterator, int _count)
      : _iterator = _iterator,
        _count = _count,
        _remaining = _count,
        super() {
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

/// 转换后的类: CppTakeWhileIterable
/// 原始类名: CppTakeWhileIterable
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/iterable.dart

class CppTakeWhileIterable<E> extends CppIterable<E> {
  final CppIterable<E> _source;
  final FunctionWrapper<bool Function(E)> _test;
  CppTakeWhileIterable(
      CppIterable<E> _source, FunctionWrapper<bool Function(E)> _test)
      : _source = _source,
        _test = _test,
        super() {
    ;
  }

  CppIterator<E> get iterator {
    return CppTakeWhileIterator<E>(this._source.iterator, this._test);
  }

  int get length {
    {
      int count = 0;
      CppIterator<E> it = this.iterator;
      while (it.moveNext()) {
        count = (count + 1);
      }
      return count;
    }
  }
}

/// 转换后的类: CppTakeWhileIterator
/// 原始类名: CppTakeWhileIterator
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/iterable.dart

class CppTakeWhileIterator<E> extends CppIterator<E> {
  final CppIterator<E> _iterator;
  final FunctionWrapper<bool Function(E)> _test;
  bool _finished = false;
  CppTakeWhileIterator(
      CppIterator<E> _iterator, FunctionWrapper<bool Function(E)> _test)
      : _iterator = _iterator,
        _test = _test,
        super() {
    ;
  }

  E get current {
    return this._iterator.current;
  }

  bool moveNext() {
    {
      if (this._finished) return false;
      if (this._iterator.moveNext()) {
        if ((() {
          final E temp_11073_4030 = this._iterator.current;
          return this._test.call(temp_11073_4030);
        })()) {
          return true;
        }
        this._finished = true;
      }
      return false;
    }
  }
}

/// 转换后的类: CppSkipIterable
/// 原始类名: CppSkipIterable
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/iterable.dart

class CppSkipIterable<E> extends CppIterable<E> {
  final CppIterable<E> _source;
  final int _count;
  CppSkipIterable(CppIterable<E> _source, int _count)
      : _source = _source,
        _count = _count,
        super() {
    ;
  }

  CppIterator<E> get iterator {
    return CppSkipIterator<E>(this._source.iterator, this._count);
  }

  int get length {
    return max<int>(0, (this._source.length - this._count));
  }
}

/// 转换后的类: CppSkipIterator
/// 原始类名: CppSkipIterator
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/iterable.dart

class CppSkipIterator<E> extends CppIterator<E> {
  final CppIterator<E> _iterator;
  final int _count;
  bool _skipped = false;
  CppSkipIterator(CppIterator<E> _iterator, int _count)
      : _iterator = _iterator,
        _count = _count,
        super() {
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

/// 转换后的类: CppSkipWhileIterable
/// 原始类名: CppSkipWhileIterable
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/iterable.dart

class CppSkipWhileIterable<E> extends CppIterable<E> {
  final CppIterable<E> _source;
  final FunctionWrapper<bool Function(E)> _test;
  CppSkipWhileIterable(
      CppIterable<E> _source, FunctionWrapper<bool Function(E)> _test)
      : _source = _source,
        _test = _test,
        super() {
    ;
  }

  CppIterator<E> get iterator {
    return CppSkipWhileIterator<E>(this._source.iterator, this._test);
  }

  int get length {
    {
      int count = 0;
      CppIterator<E> it = this.iterator;
      while (it.moveNext()) {
        count = (count + 1);
      }
      return count;
    }
  }
}

/// 转换后的类: CppSkipWhileIterator
/// 原始类名: CppSkipWhileIterator
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/iterable.dart

class CppSkipWhileIterator<E> extends CppIterator<E> {
  final CppIterator<E> _iterator;
  final FunctionWrapper<bool Function(E)> _test;
  bool _skipped = false;
  CppSkipWhileIterator(
      CppIterator<E> _iterator, FunctionWrapper<bool Function(E)> _test)
      : _iterator = _iterator,
        _test = _test,
        super() {
    ;
  }

  E get current {
    return this._iterator.current;
  }

  bool moveNext() {
    {
      if (!(this._skipped)) {
        while (this._iterator.moveNext()) {
          if (!((() {
            final E temp_12783_4232 = this._iterator.current;
            return this._test.call(temp_12783_4232);
          })())) {
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

/// 转换后的类: CppReversedIterable
/// 原始类名: CppReversedIterable
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/iterable.dart

class CppReversedIterable<E> extends CppIterable<E> {
  final CppIterable<E> _source;
  CppReversedIterable(CppIterable<E> _source)
      : _source = _source,
        super() {
    ;
  }

  CppIterator<E> get iterator {
    return CppReversedIterator<E>(this._source);
  }

  int get length {
    return this._source.length;
  }
}

/// 转换后的类: CppReversedIterator
/// 原始类名: CppReversedIterator
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/iterable.dart

class CppReversedIterator<E> extends CppIterator<E> {
  final CppList<E> _elements;
  late int _index;
  CppReversedIterator(CppIterable<E> source)
      : _elements = CppList<E>.from((source as CppIterable<dynamic?>)),
        _index = source.length,
        super() {
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

/// 转换后的类: CppFollowedByIterable
/// 原始类名: CppFollowedByIterable
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/iterable.dart

class CppFollowedByIterable<E> extends CppIterable<E> {
  final CppIterable<E> _first;
  final CppIterable<E> _second;
  CppFollowedByIterable(CppIterable<E> _first, CppIterable<E> _second)
      : _first = _first,
        _second = _second,
        super() {
    ;
  }

  CppIterator<E> get iterator {
    return CppFollowedByIterator<E>(
        this._first.iterator, this._second.iterator);
  }

  int get length {
    return (this._first.length + this._second.length);
  }
}

/// 转换后的类: CppFollowedByIterator
/// 原始类名: CppFollowedByIterator
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/iterable.dart

class CppFollowedByIterator<E> extends CppIterator<E> {
  final CppIterator<E> _first;
  final CppIterator<E> _second;
  bool _usingFirst = true;
  CppFollowedByIterator(CppIterator<E> _first, CppIterator<E> _second)
      : _first = _first,
        _second = _second,
        super() {
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

/// 转换后的类: CppCastIterable
/// 原始类名: CppCastIterable
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/iterable.dart

class CppCastIterable<S, T> extends CppIterable<T> {
  final CppIterable<S> _source;
  CppCastIterable(CppIterable<S> _source)
      : _source = _source,
        super() {
    ;
  }

  CppIterator<T> get iterator {
    return CppCastIterator<S, T>(this._source.iterator);
  }

  int get length {
    return this._source.length;
  }
}

/// 转换后的类: CppCastIterator
/// 原始类名: CppCastIterator
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/iterable.dart

class CppCastIterator<S, T> extends CppIterator<T> {
  final CppIterator<S> _iterator;
  CppCastIterator(CppIterator<S> _iterator)
      : _iterator = _iterator,
        super() {
    ;
  }

  T get current {
    return (this._iterator.current as T);
  }

  bool moveNext() {
    return this._iterator.moveNext();
  }
}

/// 转换后的类: _CppEmptyIterable
/// 原始类名: _CppEmptyIterable
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/iterable.dart

class _CppEmptyIterable<E> extends CppIterable<E> {
  _CppEmptyIterable() : super() {
    ;
  }

  CppIterator<E> get iterator {
    return _CppEmptyIterator<E>();
  }

  int get length {
    return 0;
  }
}

/// 转换后的类: _CppEmptyIterator
/// 原始类名: _CppEmptyIterator
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/iterable.dart

class _CppEmptyIterator<E> extends CppIterator<E> {
  _CppEmptyIterator() : super() {
    ;
  }

  E get current {
    throw CppStateError(const_0);
  }

  bool moveNext() {
    return false;
  }
}

/// 转换后的类: _CppGenerateIterable
/// 原始类名: _CppGenerateIterable
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/iterable.dart

class _CppGenerateIterable<E> extends CppIterable<E> {
  final int _count;
  final FunctionWrapper<E Function(int)> _generator;
  _CppGenerateIterable(int _count, FunctionWrapper<E Function(int)> _generator)
      : _count = _count,
        _generator = _generator,
        super() {
    ;
  }

  CppIterator<E> get iterator {
    return _CppGenerateIterator<E>(this._count, this._generator);
  }

  int get length {
    return this._count;
  }
}

/// 转换后的类: _CppGenerateIterator
/// 原始类名: _CppGenerateIterator
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/iterable.dart

class _CppGenerateIterator<E> extends CppIterator<E> {
  final int _count;
  final FunctionWrapper<E Function(int)> _generator;
  int _index = 0;
  E? _current = null;
  _CppGenerateIterator(int _count, FunctionWrapper<E Function(int)> _generator)
      : _count = _count,
        _generator = _generator,
        super() {
    ;
  }

  E get current {
    return (() {
      final E? temp_3357 = this._current;
      return temp_3357 == null ? (temp_3357 as E) : temp_3357;
    })();
  }

  bool moveNext() {
    {
      if ((this._index < this._count)) {
        this._current = (() {
          final int temp_16027_4539 = (() {
            final int temp_16027_4507 = this._index;
            return (() {
              final int temp_16021_4512 = this._index = (temp_16027_4507 + 1);
              return temp_16027_4507;
            })();
          })();
          return this._generator.call(temp_16027_4539);
        })();
        return true;
      }
      return false;
    }
  }
}

/// 转换后的类: _CppUnmodifiableIterable
/// 原始类名: _CppUnmodifiableIterable
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/iterable.dart

class _CppUnmodifiableIterable<E> extends CppIterable<E> {
  final CppList<E> _elements;
  _CppUnmodifiableIterable(CppList<E> _elements)
      : _elements = _elements,
        super() {
    ;
  }

  CppIterator<E> get iterator {
    return this._elements.iterator;
  }

  int get length {
    return this._elements.length;
  }
}

/// 转换后的类: _CppCastFromIterable
/// 原始类名: _CppCastFromIterable
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/iterable.dart

class _CppCastFromIterable<S, R> extends CppIterable<R> {
  final CppIterable<S> _source;
  _CppCastFromIterable(CppIterable<S> _source)
      : _source = _source,
        super() {
    ;
  }

  CppIterator<R> get iterator {
    return _CppCastFromIterator<S, R>(this._source.iterator);
  }

  int get length {
    return this._source.length;
  }
}

/// 转换后的类: _CppCastFromIterator
/// 原始类名: _CppCastFromIterator
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/iterable.dart

class _CppCastFromIterator<S, R> extends CppIterator<R> {
  final CppIterator<S> _iterator;
  _CppCastFromIterator(CppIterator<S> _iterator)
      : _iterator = _iterator,
        super() {
    ;
  }

  R get current {
    return (this._iterator.current as R);
  }

  bool moveNext() {
    return this._iterator.moveNext();
  }
}

/// 转换后的类: CppAny
/// 原始类名: CppAny
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/object.dart

class CppAny {
  const CppAny() : super();

  CppString toCppString() {
    {
      return const CppString.fromCppUserData(
          const CppUserData.constant(const_3));
    }
  }
}

/// 转换后的类: CppStringPool
/// 原始类名: CppStringPool
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/string.dart

class CppStringPool {
  static final CppStringPool _instance = CppStringPool._internal();
  final CppList<CppUserData> _pool = CppList<CppUserData>.from(
      (CppArrayList<CppUserData>.fromCppArray(
              CppApi.cppArrayConst(1, const CppUserData.constant(const_3)))
          as CppIterable<dynamic?>));
  CppStringPool._internal() : super() {
    ;
  }

  static CppStringPool get instance {
    return CppStringPool._instance;
  }

  CppUserData getOrCreateFromCodeUnits(CppList<int> codeUnits) {
    {
      {
        CppIterator<CppUserData> _sync_for_iterator = this._pool.iterator;
        for (; _sync_for_iterator.moveNext();) {
          CppUserData existing = _sync_for_iterator.current;
          if (this._compareUserData(existing, codeUnits)) {
            return existing;
          }
        }
      }
      CppUserData userData = CppApi.cppCreatePointerArray(codeUnits.length);
      for (int i = 0; (i < codeUnits.length); i = (i + 1)) {
        CppApi.cppSetPointerArrayItem(userData, i, codeUnits[i]);
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

  bool _compareUserData(CppUserData userData, CppList<int> codeUnits) {
    {
      int length = CppApi.cppGetPointerArrayLength(userData);
      if (!(length == codeUnits.length)) return false;
      for (int i = 0; (i < length); i = (i + 1)) {
        if (!(CppApi.cppGetPointerArrayItem(userData, i) == codeUnits[i])) {
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

  CppStringPoolStats getStats() {
    {
      int totalMemory = 0;
      {
        CppIterator<CppUserData> _sync_for_iterator = this._pool.iterator;
        for (; _sync_for_iterator.moveNext();) {
          CppUserData userData = _sync_for_iterator.current;
          totalMemory =
              (totalMemory + CppApi.cppGetPointerArrayLength(userData));
        }
      }
      return CppStringPoolStats(
          totalStrings: this._pool.length, totalMemory: totalMemory);
    }
  }
}

/// 转换后的类: CppStringPoolStats
/// 原始类名: CppStringPoolStats
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/string.dart

class CppStringPoolStats {
  final int totalStrings;
  final int totalMemory;
  CppStringPoolStats({required int totalStrings, required int totalMemory})
      : totalStrings = totalStrings,
        totalMemory = totalMemory,
        super() {
    ;
  }

  CppString toCppString() {
    {
      return const_5 +
          const_6 +
          CppString.convertString(this.totalStrings) +
          const_7 +
          const_8 +
          CppString.convertString(this.totalMemory) +
          const_9 +
          const_10;
    }
  }
}

/// 转换后的类: CppStringBuffer
/// 原始类名: CppStringBuffer
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/string.dart

class CppStringBuffer {
  final CppList<CppUserData> _parts;
  CppStringBuffer([Object content = const_11])
      : _parts = CppList<CppUserData>.from(
            (CppArrayList<CppUserData>.fromCppArray(CppApi.cppArrayConst(
                    1, CppStringBuffer._convertStringToUserData(content)))
                as CppIterable<dynamic?>)),
        super() {
    ;
  }

  void write(Object? obj) {
    {
      if (obj == null) return;
      this._parts.add(CppStringBuffer._convertStringToUserData(obj));
    }
  }

  void writeAll(CppIterable<dynamic?> objects, [CppString? separator = null]) {
    {
      CppIterator<dynamic?> iterator = objects.iterator;
      if (iterator.moveNext()) {
        this._parts.add(CppStringBuffer._convertStringToUserData((() {
          final dynamic? temp_3373 = iterator.current;
          return temp_3373 == null ? (temp_3373 as Object) : temp_3373;
        })()));
        while (iterator.moveNext()) {
          if (!(separator == null) && separator.isNotEmpty) {
            this._parts.add(separator._codeUnits);
          }
          this._parts.add(CppStringBuffer._convertStringToUserData((() {
            final dynamic? temp_3381 = iterator.current;
            return temp_3381 == null ? (temp_3381 as Object) : temp_3381;
          })()));
        }
      }
    }
  }

  void writeCharCode(int charCode) {
    {
      this._parts.add(CppStringBuffer._convertStringToUserData(
          CppString.fromCharCode(charCode)));
    }
  }

  void writeln([Object? obj = const_11]) {
    {
      if (!(obj == null)) {
        this._parts.add(CppStringBuffer._convertStringToUserData(obj));
      }
      this._parts.add(
          CppStringBuffer._convertStringToUserData(CppString.fromCharCode(10)));
    }
  }

  void clear() {
    {
      this._parts.clear();
    }
  }

  CppString toCppString() {
    {
      CppList<int> codeUnits = CppList<int>.empty(growable: true);
      {
        CppIterator<CppUserData> _sync_for_iterator = this._parts.iterator;
        for (; _sync_for_iterator.moveNext();) {
          CppUserData part = _sync_for_iterator.current;
          int length = CppApi.cppGetPointerArrayLength(part);
          for (int i = 0; (i < length); i = (i + 1)) {
            codeUnits.add((CppApi.cppGetPointerArrayItem(part, i) as int));
          }
        }
      }
      return CppString.fromCodeUnits(codeUnits);
    }
  }

  int get length {
    {
      int totalLength = 0;
      {
        CppIterator<CppUserData> _sync_for_iterator = this._parts.iterator;
        for (; _sync_for_iterator.moveNext();) {
          CppUserData part = _sync_for_iterator.current;
          totalLength = (totalLength + CppApi.cppGetPointerArrayLength(part));
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
      if ((obj is CppString)) {
        return obj._codeUnits;
      }
      return CppStringPool.instance.getOrCreateFromCodeUnits(
          CppStringBuffer._convertStringToCodeUnits(
              CppString.convertString(obj)));
    }
  }

  static CppList<int> _convertStringToCodeUnits(CppString str) {
    {
      CppList<int> codeUnits = CppList<int>.empty(growable: true);
      for (int i = 0; (i < str.length); i = (i + 1)) {
        codeUnits.add(str.codeUnitAt(i));
      }
      return codeUnits;
    }
  }
}

/// 转换后的类: CppString
/// 原始类名: CppString
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/string.dart

class CppString extends CppAny implements Comparable<CppString> {
  static const CppString Empty =
      const CppString.fromCppUserData(const CppUserData.constant(const_3));
  final CppUserData _codeUnits;
  const CppString.fromCppUserData(CppUserData userData)
      : _codeUnits = userData,
        super();

  CppString.fromCodeUnits(CppList<int> codeUnits)
      : _codeUnits = CppStringPool.instance.getOrCreateFromCodeUnits(codeUnits),
        super() {
    ;
  }

  CppString.fromCharCode(int charCode)
      : _codeUnits = CppStringPool.instance
            .getOrCreateFromCodeUnits(CppList<int>.filled(1, charCode)),
        super() {
    ;
  }

  CppString.fromCharCodes(CppIterable<int> charCodes,
      [int start = const_12, int? end = null])
      : _codeUnits = CppStringPool.instance.getOrCreateFromCodeUnits(charCodes
            .skip(start)
            .take(((end) ?? (charCodes.length) - start))
            .toList()),
        super() {
    ;
  }

  CppString _toExternalString() {
    {
      CppList<int> codeUnits = CppList<int>.empty(growable: true);
      for (int i = 0; (i < this.length); i = (i + 1)) {
        codeUnits
            .add((CppApi.cppGetPointerArrayItem(this._codeUnits, i) as int));
      }
      return CppString.fromCharCodes((codeUnits as CppIterable<int>));
    }
  }

  bool _equalCodeUnits(CppString other) {
    {
      int thisLength = this.length;
      int otherLength = other.length;
      if (!(thisLength == otherLength)) return false;
      for (int i = 0; (i < thisLength); i = (i + 1)) {
        if (!(CppApi.cppGetPointerArrayItem(this._codeUnits, i) ==
            CppApi.cppGetPointerArrayItem(other._codeUnits, i))) {
          return false;
        }
      }
      return true;
    }
  }

  int get length {
    return CppApi.cppGetPointerArrayLength(this._codeUnits);
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
        hash = (((hash * 31) +
                (CppApi.cppGetPointerArrayItem(this._codeUnits, i) as int)) &
            2147483647);
      }
      return hash;
    }
  }

  int codeUnitAt(int index) {
    {
      if ((index < 0) || (index >= this.length)) {
        throw CppIndexError(index, this, const_13);
      }
      return (CppApi.cppGetPointerArrayItem(this._codeUnits, index) as int);
    }
  }

  CppList<int> get codeUnits {
    {
      int thisLength = this.length;
      CppList<int> units = CppList<int>.empty(growable: true);
      for (int i = 0; (i < thisLength); i = (i + 1)) {
        units.add((CppApi.cppGetPointerArrayItem(this._codeUnits, i) as int));
      }
      return units;
    }
  }

  Runes get runes {
    return this._toExternalString().runes;
  }

  int compareTo(CppString other) {
    {
      int thisLength = this.length;
      int otherLength = other.length;
      int minLength = (thisLength < otherLength) ? thisLength : otherLength;
      for (int i = 0; (i < minLength); i = (i + 1)) {
        int thisCodeUnit =
            (CppApi.cppGetPointerArrayItem(this._codeUnits, i) as int);
        int otherCodeUnit =
            (CppApi.cppGetPointerArrayItem(other._codeUnits, i) as int);
        if (!(thisCodeUnit == otherCodeUnit)) {
          return (thisCodeUnit - otherCodeUnit);
        }
      }
      return (thisLength - otherLength);
    }
  }

  bool startsWith(CppString pattern, [int index = const_12]) {
    {
      if ((index < 0) || (index >= this.length)) return false;
      if (((index + pattern.length) > this.length)) return false;
      for (int i = 0; (i < pattern.length); i = (i + 1)) {
        if (!((CppApi.cppGetPointerArrayItem(this._codeUnits, (index + i))
                as int) ==
            (CppApi.cppGetPointerArrayItem(pattern._codeUnits, i) as int))) {
          return false;
        }
      }
      return true;
    }
  }

  bool endsWith(CppString other) {
    {
      if ((other.length > this.length)) return false;
      int startIndex = (this.length - other.length);
      for (int i = 0; (i < other.length); i = (i + 1)) {
        if (!((CppApi.cppGetPointerArrayItem(this._codeUnits, (startIndex + i))
                as int) ==
            (CppApi.cppGetPointerArrayItem(other._codeUnits, i) as int))) {
          return false;
        }
      }
      return true;
    }
  }

  int indexOf(CppString pattern, [int start = const_12]) {
    {
      if ((start < 0)) start = 0;
      if (pattern.isEmpty) return start;
      if (((start + pattern.length) > this.length)) return -1;
      for (int i = start; (i <= (this.length - pattern.length)); i = (i + 1)) {
        bool match = true;
        label:
        for (int j = 0; (j < pattern.length); j = (j + 1)) {
          if (!((CppApi.cppGetPointerArrayItem(this._codeUnits, (i + j))
                  as int) ==
              (CppApi.cppGetPointerArrayItem(pattern._codeUnits, j) as int))) {
            match = false;
            break;
          }
        }
        if (match) return i;
      }
      return -1;
    }
  }

  int lastIndexOf(CppString pattern, [int? start = null]) {
    {
      if (pattern.isEmpty) return (start) ?? (this.length);
      start == null ? start = this.length : null;
      if ((start < 0)) return -1;
      if (((start + pattern.length) > this.length))
        start = (this.length - pattern.length);
      for (int i = start; (i >= 0); i = (i - 1)) {
        bool match = true;
        label:
        for (int j = 0; (j < pattern.length); j = (j + 1)) {
          if (!((CppApi.cppGetPointerArrayItem(this._codeUnits, (i + j))
                  as int) ==
              (CppApi.cppGetPointerArrayItem(pattern._codeUnits, j) as int))) {
            match = false;
            break;
          }
        }
        if (match) return i;
      }
      return -1;
    }
  }

  bool contains(CppString other, [int startIndex = const_12]) {
    {
      return !(this.indexOf(other, startIndex) == -1);
    }
  }

  CppString substring(int start, [int? end = null]) {
    {
      end == null ? end = this.length : null;
      if ((start < 0)) start = 0;
      if ((end > this.length)) end = this.length;
      if ((start >= end))
        return const CppString.fromCppUserData(
            const CppUserData.constant(const_3));
      int newLength = (end - start);
      CppList<int> newCodeUnits = CppList<int>.empty(growable: true);
      for (int i = 0; (i < newLength); i = (i + 1)) {
        int codeUnit =
            (CppApi.cppGetPointerArrayItem(this._codeUnits, (start + i))
                as int);
        newCodeUnits.add(codeUnit);
      }
      return CppString.fromCodeUnits(newCodeUnits);
    }
  }

  CppString trim() {
    {
      int start = 0;
      int end = this.length;
      while ((start < end) &&
          this._isWhitespace(
              (CppApi.cppGetPointerArrayItem(this._codeUnits, start) as int))) {
        start = (start + 1);
      }
      while ((end > start) &&
          this._isWhitespace(
              (CppApi.cppGetPointerArrayItem(this._codeUnits, (end - 1))
                  as int))) {
        end = (end - 1);
      }
      return this.substring(start, end);
    }
  }

  CppString trimLeft() {
    {
      int start = 0;
      while ((start < this.length) &&
          this._isWhitespace(
              (CppApi.cppGetPointerArrayItem(this._codeUnits, start) as int))) {
        start = (start + 1);
      }
      return this.substring(start);
    }
  }

  CppString trimRight() {
    {
      int end = this.length;
      while ((end > 0) &&
          this._isWhitespace(
              (CppApi.cppGetPointerArrayItem(this._codeUnits, (end - 1))
                  as int))) {
        end = (end - 1);
      }
      return this.substring(0, end);
    }
  }

  bool _isWhitespace(int codeUnit) {
    {
      return codeUnit == 9 ||
          codeUnit == 10 ||
          codeUnit == 11 ||
          codeUnit == 12 ||
          codeUnit == 13 ||
          codeUnit == 32 ||
          codeUnit == 160;
    }
  }

  CppString padLeft(int width, [CppString? padding = null]) {
    {
      if ((width <= this.length)) return this;
      padding == null ? padding = CppString.fromCharCode(32) : null;
      int padLength = (width - this.length);
      int padCount = (padLength / padding.length).ceil();
      CppString padString = (padding * padCount);
      CppString actualPad = padString.substring(0, padLength);
      return (actualPad + this);
    }
  }

  CppString padRight(int width, [CppString? padding = null]) {
    {
      if ((width <= this.length)) return this;
      padding == null ? padding = CppString.fromCharCode(32) : null;
      int padLength = (width - this.length);
      int padCount = (padLength / padding.length).ceil();
      CppString padString = (padding * padCount);
      CppString actualPad = padString.substring(0, padLength);
      return (this + actualPad);
    }
  }

  CppString replaceFirst(CppString from, CppString to,
      [int startIndex = const_12]) {
    {
      int index = this.indexOf(from, startIndex);
      if (index == -1) return this;
      CppString beforePart = this.substring(0, index);
      CppString afterPart = this.substring((index + from.length));
      return ((beforePart + to) + afterPart);
    }
  }

  CppString replaceAll(CppString from, CppString replace) {
    {
      if (from.isEmpty) return this;
      CppList<CppString> parts = this.split(from);
      if (parts.length == 1) return this;
      CppList<CppString> result = CppList<CppString>.empty(growable: true);
      for (int i = 0; (i < parts.length); i = (i + 1)) {
        result.add(parts[i]);
        if ((i < (parts.length - 1))) {
          result.add(replace);
        }
      }
      return CppString.join((result as CppIterable<CppString>));
    }
  }

  CppString replaceRange(int start, int? end, CppString replacement) {
    {
      end == null ? end = this.length : null;
      if ((start < 0)) start = 0;
      if ((end > this.length)) end = this.length;
      if ((start >= end)) return (this + replacement);
      CppString beforePart = this.substring(0, start);
      CppString afterPart = this.substring(end);
      return ((beforePart + replacement) + afterPart);
    }
  }

  CppList<CppString> split(CppString separator) {
    {
      if (separator.isEmpty) {
        CppList<CppString> result = CppList<CppString>.empty(growable: true);
        for (int i = 0; (i < this.length); i = (i + 1)) {
          result.add(this.substring(i, (i + 1)));
        }
        return result;
      }
      CppList<CppString> result = CppList<CppString>.empty(growable: true);
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

  CppString toLowerCase() {
    {
      CppList<int> resultCodeUnits = CppList<int>.empty(growable: true);
      for (int i = 0; (i < this.length); i = (i + 1)) {
        int codeUnit =
            (CppApi.cppGetPointerArrayItem(this._codeUnits, i) as int);
        if ((codeUnit >= 65) && (codeUnit <= 90)) {
          codeUnit = (codeUnit + 32);
        }
        resultCodeUnits.add(codeUnit);
      }
      return CppString.fromCodeUnits(resultCodeUnits);
    }
  }

  CppString toUpperCase() {
    {
      CppList<int> resultCodeUnits = CppList<int>.empty(growable: true);
      for (int i = 0; (i < this.length); i = (i + 1)) {
        int codeUnit =
            (CppApi.cppGetPointerArrayItem(this._codeUnits, i) as int);
        if ((codeUnit >= 97) && (codeUnit <= 122)) {
          codeUnit = (codeUnit - 32);
        }
        resultCodeUnits.add(codeUnit);
      }
      return CppString.fromCodeUnits(resultCodeUnits);
    }
  }

  CppIterable<CppStringMatch> allMatches(CppString string,
      [int start = const_12]) {
    {
      if ((start < 0) || (start > string.length)) {
        throw CppRangeError.range(start, 0, string.length, const_14);
      }
      return _CppStringAllMatchesIterable(string, this, start);
    }
  }

  CppStringMatch? matchAsPrefix(CppString string, [int start = const_12]) {
    {
      if ((start < 0) || (start > string.length)) {
        throw CppRangeError.range(start, 0, string.length);
      }
      if (((start + this.length) > string.length)) return null;
      for (int i = 0; (i < this.length); i = (i + 1)) {
        if (!((CppApi.cppGetPointerArrayItem(string._codeUnits, (start + i))
                as int) ==
            (CppApi.cppGetPointerArrayItem(this._codeUnits, i) as int))) {
          return null;
        }
      }
      return CppStringMatch(start, string, this);
    }
  }

  CppString toCppString() {
    {
      return this;
    }
  }

  CppString toStandardString() {
    {
      return this._toExternalString();
    }
  }

  void dispose() {
    {}
  }

  bool sharesDataWith(CppString other) {
    {
      return identical(this._codeUnits, other._codeUnits);
    }
  }

  int get dataHashCode {
    return this._codeUnits.hashCode;
  }

  static CppString convertString(Object? obj) {
    {
      if ((obj is CppString)) {
        return obj;
      }
      return CppString.fromCppUserData(CppApi.cppToString(obj));
    }
  }

  static CppString fromString(CppString source) {
    {
      CppList<int> codeUnits = CppList<int>.empty(growable: true);
      for (int i = 0; (i < source.length); i = (i + 1)) {
        codeUnits.add(source.codeUnitAt(i));
      }
      return CppString.fromCodeUnits(codeUnits);
    }
  }

  static CppString join(CppIterable<CppString> strings,
      [CppString? separator = null]) {
    {
      separator == null
          ? separator = const CppString.fromCppUserData(
              const CppUserData.constant(const_3))
          : null;
      CppList<CppString> stringList = strings.toList();
      if (stringList.isEmpty)
        return const CppString.fromCppUserData(
            const CppUserData.constant(const_3));
      if (stringList.length == 1) return stringList[0];
      CppList<int> newCodeUnits = CppList<int>.empty(growable: true);
      for (int i = 0; (i < stringList.length); i = (i + 1)) {
        CppString str = stringList[i];
        for (int j = 0; (j < str.length); j = (j + 1)) {
          newCodeUnits
              .add((CppApi.cppGetPointerArrayItem(str._codeUnits, j) as int));
        }
        if ((i < (stringList.length - 1))) {
          for (int j = 0; (j < separator.length); j = (j + 1)) {
            newCodeUnits.add(
                (CppApi.cppGetPointerArrayItem(separator._codeUnits, j)
                    as int));
          }
        }
      }
      return CppString.fromCodeUnits(newCodeUnits);
    }
  }

  CppString operator [](int index) {
    {
      int thisLength = this.length;
      if ((index < 0) || (index >= thisLength)) {
        throw CppIndexError(index, this, const_13);
      }
      int codeUnit =
          (CppApi.cppGetPointerArrayItem(this._codeUnits, index) as int);
      return CppString.fromCharCode(codeUnit);
    }
  }

  bool operator ==(Object other) {
    {
      if (identical(this, other)) return true;
      if ((other is CppString)) {
        return this._equalCodeUnits(other);
      }
      return false;
    }
  }

  CppString operator +(CppString other) {
    {
      int thisLength = this.length;
      int otherLength = other.length;
      CppList<int> newCodeUnits = CppList<int>.empty(growable: true);
      ;
      for (int i = 0; (i < thisLength); i = (i + 1)) {
        newCodeUnits
            .add((CppApi.cppGetPointerArrayItem(this._codeUnits, i) as int));
      }
      for (int i = 0; (i < otherLength); i = (i + 1)) {
        newCodeUnits
            .add((CppApi.cppGetPointerArrayItem(other._codeUnits, i) as int));
      }
      return CppString.fromCodeUnits(newCodeUnits);
    }
  }

  CppString operator *(int times) {
    {
      if ((times <= 0))
        return const CppString.fromCppUserData(
            const CppUserData.constant(const_3));
      if (times == 1) return this;
      int thisLength = this.length;
      CppList<int> newCodeUnits = CppList<int>.empty(growable: true);
      for (int repeat = 0; (repeat < times); repeat = (repeat + 1)) {
        for (int i = 0; (i < thisLength); i = (i + 1)) {
          newCodeUnits
              .add((CppApi.cppGetPointerArrayItem(this._codeUnits, i) as int));
        }
      }
      return CppString.fromCodeUnits(newCodeUnits);
    }
  }
}

/// 转换后的类: CppStringMatch
/// 原始类名: CppStringMatch
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/string.dart

class CppStringMatch {
  final int start;
  final CppString input;
  final CppString pattern;
  const CppStringMatch(int start, CppString input, CppString pattern)
      : start = start,
        input = input,
        pattern = pattern,
        super();

  int get end {
    return (this.start + this.pattern.length);
  }

  CppString group(int group) {
    {
      if (!(group == 0)) {
        throw CppRangeError.value(group);
      }
      return this.pattern;
    }
  }

  int get groupCount {
    return 0;
  }

  CppString operator [](int group) {
    return group == 0 ? this.pattern : throw CppRangeError.value(group);
  }
}

/// 转换后的类: _CppStringAllMatchesIterable
/// 原始类名: _CppStringAllMatchesIterable
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/string.dart

class _CppStringAllMatchesIterable extends CppIterable<CppStringMatch> {
  final CppString _input;
  final CppString _pattern;
  final int _index;
  _CppStringAllMatchesIterable(CppString _input, CppString _pattern, int _index)
      : _input = _input,
        _pattern = _pattern,
        _index = _index,
        super() {
    ;
  }

  CppIterator<CppStringMatch> get iterator {
    return _CppStringAllMatchesIterator(
        this._input, this._pattern, this._index);
  }

  int get length {
    {
      int count = 0;
      CppIterator<CppStringMatch> it = this.iterator;
      while (it.moveNext()) {
        count = (count + 1);
      }
      return count;
    }
  }

  CppStringMatch get first {
    {
      int index = this._input.indexOf(this._pattern, this._index);
      if ((index >= 0)) {
        return CppStringMatch(index, this._input, this._pattern);
      }
      throw CppStateError(const_0);
    }
  }
}

/// 转换后的类: _CppStringAllMatchesIterator
/// 原始类名: _CppStringAllMatchesIterator
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/string.dart

class _CppStringAllMatchesIterator extends CppAny
    implements CppIterator<CppStringMatch> {
  final CppString _input;
  final CppString _pattern;
  CppStringMatch? _current = null;
  late int _index;
  _CppStringAllMatchesIterator(CppString _input, CppString _pattern, int _index)
      : _input = _input,
        _pattern = _pattern,
        _index = _index,
        super() {
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
      this._current = CppStringMatch(index, this._input, this._pattern);
      this._index = end == this._index ? (end + 1) : end;
      return true;
    }
  }

  CppStringMatch get current {
    return (() {
      final CppStringMatch? temp_3389 = this._current;
      return temp_3389 == null ? (temp_3389 as CppStringMatch) : temp_3389;
    })();
  }
}

/// 转换后的类: CppList
/// 原始类名: CppList
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/collection.dart

abstract class CppList<E> extends CppIterable<E> {
  CppList();

  factory CppList.empty({bool growable = const_15}) {
    {
      return CppArrayList<E>.empty(growable: growable);
    }
  }

  factory CppList.filled(int length, E fill, {bool growable = const_15}) {
    {
      return CppArrayList<E>.filled(length, fill, growable: growable);
    }
  }

  factory CppList.from(CppIterable<dynamic?> elements,
      {bool growable = const_4}) {
    {
      return CppArrayList<E>.from(elements, growable: growable);
    }
  }

  factory CppList.of(CppIterable<E> elements, {bool growable = const_4}) {
    {
      return CppArrayList<E>.of(elements, growable: growable);
    }
  }

  factory CppList.generate(
      int length, FunctionWrapper<E Function(int)> generator,
      {bool growable = const_4}) {
    {
      return CppArrayList<E>.generate(length, generator, growable: growable);
    }
  }

  factory CppList.unmodifiable(CppIterable<dynamic?> elements) {
    {
      return CppArrayList<E>.unmodifiable(elements);
    }
  }

  int get length;

  set length(int newLen);

  void add(E value);

  void addAll(CppIterable<E> iterable);

  bool any(FunctionWrapper<bool Function(E)> test);

  CppMap<int, E> asMap();

  CppIterable<R> cast<R>();

  void clear();

  bool contains(Object? element);

  E elementAt(int index);

  bool every(FunctionWrapper<bool Function(E)> test);

  void fillRange(int start, int end, [E? fillValue = null]);

  E firstWhere(FunctionWrapper<bool Function(E)> test,
      {FunctionWrapper<E Function()>? orElse = null});

  T fold<T>(T initialValue, FunctionWrapper<T Function(T, E)> combine);

  void forEach(FunctionWrapper<void Function(E)> action);

  CppIterable<E> getRange(int start, int end);

  int indexOf(E element, [int start = const_12]);

  int indexWhere(FunctionWrapper<bool Function(E)> test,
      [int start = const_12]);

  void insert(int index, E element);

  void insertAll(int index, CppIterable<E> iterable);

  E get first;

  set first(E value);

  E get last;

  set last(E value);

  E get single;

  bool get isEmpty;

  bool get isNotEmpty;

  CppIterator<E> get iterator;

  CppString join(
      [CppString separator = const CppString.fromCppUserData(
          const CppUserData.constant(const_3))]);

  int lastIndexOf(E element, [int? start = null]);

  int lastIndexWhere(FunctionWrapper<bool Function(E)> test,
      [int? start = null]);

  E lastWhere(FunctionWrapper<bool Function(E)> test,
      {FunctionWrapper<E Function()>? orElse = null});

  E reduce(FunctionWrapper<E Function(E, E)> combine);

  bool remove(Object? value);

  E removeAt(int index);

  E removeLast();

  void removeRange(int start, int end);

  void removeWhere(FunctionWrapper<bool Function(E)> test);

  void replaceRange(int start, int end, CppIterable<E> replacements);

  void retainWhere(FunctionWrapper<bool Function(E)> test);

  void setAll(int index, CppIterable<E> iterable);

  void setRange(int start, int end, CppIterable<E> iterable,
      [int skipCount = const_12]);

  void shuffle([Random? random = null]);

  void sort([FunctionWrapper<int Function(E, E)>? compare = null]);

  CppList<E> sublist(int start, [int? end = null]);

  CppList<E> toList({bool growable = const_4});

  CppSet<E> toSet();

  E singleWhere(FunctionWrapper<bool Function(E)> test,
      {FunctionWrapper<E Function()>? orElse = null});

  CppString toCppString();

  static CppList<R> castFrom<S, R>(CppList<S> source) {
    {
      return CppArrayList.castFrom<S, R>(source);
    }
  }

  static CppList<R> castFromWithFactory<S, R>(
      CppList<S> source, FunctionWrapper<CppList<R> Function()> newList) {
    {
      return CppArrayList.castFromWithFactory<S, R>(source, newList);
    }
  }

  E operator [](int index);

  void operator []=(int index, E value);

  CppList<E> operator +(CppList<E> other);
}

/// 转换后的类: CppArrayList
/// 原始类名: CppArrayList
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/collection.dart

class CppArrayList<E> extends CppIterable<E> implements CppList<E> {
  late int _length;
  late CppUserData _array;
  CppArrayList.fromCppArray(CppUserData array)
      : _length = CppApi.cppGetPointerArrayLength(array),
        _array = array,
        super() {
    ;
  }

  CppArrayList(int length, int capacity)
      : _length = length,
        _array = CppApi.cppCreatePointerArray(length),
        super() {
    ;
  }

  factory CppArrayList.empty({bool growable = const_15}) {
    {
      return growable ? CppArrayList<E>(0, 0) : CppArrayList<E>(0, 0);
    }
  }

  factory CppArrayList.filled(int length, E fill, {bool growable = const_15}) {
    {
      CppUserData array = CppApi.cppCreatePointerArray(length);
      for (int i = 0; (i < length); i = (i + 1)) {
        CppApi.cppSetPointerArrayItem(array, i, fill);
      }
      return CppArrayList<E>.fromCppArray(array);
    }
  }

  factory CppArrayList.from(CppIterable<dynamic?> elements,
      {bool growable = const_4}) {
    {
      int length = elements.length;
      CppUserData array = growable
          ? CppApi.cppCreatePointerArray(length)
          : CppApi.cppCreatePointerArray(
              CppArrayList._getSuggestCapacity(length));
      int i = 0;
      {
        CppIterator<dynamic?> _sync_for_iterator = elements.iterator;
        for (; _sync_for_iterator.moveNext();) {
          CppApi.cppSetPointerArrayItem(array, (() {
            final int temp_5346_8074 = i;
            return (() {
              final int temp_5346_8078 = i = (temp_5346_8074 + 1);
              return temp_5346_8074;
            })();
          })(), _sync_for_iterator.current);
        }
      }
      return CppArrayList<E>.fromCppArray(array);
    }
  }

  factory CppArrayList.of(CppIterable<E> elements, {bool growable = const_4}) {
    return CppArrayList<E>.from(elements, growable: growable);
  }

  factory CppArrayList.generate(
      int length, FunctionWrapper<E Function(int)> generator,
      {bool growable = const_4}) {
    {
      CppUserData array = growable
          ? CppApi.cppCreatePointerArray(length)
          : CppApi.cppCreatePointerArray(
              CppArrayList._getSuggestCapacity(length));
      for (int i = 0; (i < length); i = (i + 1)) {
        CppApi.cppSetPointerArrayItem(array, i, generator.call(i));
      }
      return CppArrayList<E>.fromCppArray(array);
    }
  }

  factory CppArrayList.unmodifiable(CppIterable<dynamic?> elements) {
    {
      int length = elements.length;
      CppUserData array = CppApi.cppCreatePointerArray(length);
      int i = 0;
      {
        CppIterator<dynamic?> _sync_for_iterator = elements.iterator;
        for (; _sync_for_iterator.moveNext();) {
          CppApi.cppSetPointerArrayItem(array, (() {
            final int temp_6337_8178 = i;
            return (() {
              final int temp_6337_8182 = i = (temp_6337_8178 + 1);
              return temp_6337_8178;
            })();
          })(), (_sync_for_iterator.current as E));
        }
      }
      return CppArrayList<E>.fromCppArray(array);
    }
  }

  int get length {
    return this._length;
  }

  void ensureCapacity(int newLen) {
    {
      if ((newLen > CppApi.cppGetPointerArrayLength(this._array))) {
        CppUserData newArray = CppApi.cppCreatePointerArray(
            CppArrayList._getSuggestCapacity(newLen));
        for (int i = 0;
            (i < CppApi.cppGetPointerArrayLength(this._array));
            i = (i + 1)) {
          CppApi.cppSetPointerArrayItem(
              newArray, i, CppApi.cppGetPointerArrayItem(this._array, i));
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
      CppApi.cppSetPointerArrayItem(this._array, (() {
        final int temp_7465_8337 = this._length;
        return (() {
          final int temp_7458_8342 = this._length = (temp_7465_8337 + 1);
          return temp_7465_8337;
        })();
      })(), value);
    }
  }

  void addAll(CppIterable<E> iterable) {
    {
      {
        CppIterator<E> _sync_for_iterator = iterable.iterator;
        for (; _sync_for_iterator.moveNext();) {
          this.add(_sync_for_iterator.current);
        }
      }
    }
  }

  bool any(FunctionWrapper<bool Function(E)> test) {
    {
      for (int i = 0; (i < this._length); i = (i + 1)) {
        if (test.call((CppApi.cppGetPointerArrayItem(this._array, i) as E)))
          return true;
      }
      return false;
    }
  }

  CppMap<int, E> asMap() {
    {
      CppArrayMap<int, E> map = CppArrayMap<int, E>();
      for (int i = 0; (i < this._length); i = (i + 1)) {
        map[i] = (CppApi.cppGetPointerArrayItem(this._array, i) as E);
      }
      return map;
    }
  }

  CppIterable<R> cast<R>() {
    {
      return (CppArrayList.castFrom<E, R>(this) as CppIterable<R>);
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
        if (CppApi.cppGetPointerArrayItem(this._array, i) == element)
          return true;
      }
      return false;
    }
  }

  E elementAt(int index) {
    return (CppApi.cppGetPointerArrayItem(this._array, index) as E);
  }

  bool every(FunctionWrapper<bool Function(E)> test) {
    {
      for (int i = 0; (i < this._length); i = (i + 1)) {
        if (!(test.call((CppApi.cppGetPointerArrayItem(this._array, i) as E))))
          return false;
      }
      return true;
    }
  }

  void fillRange(int start, int end, [E? fillValue = null]) {
    {
      for (int i = start; (i < end); i = (i + 1)) {
        CppApi.cppSetPointerArrayItem(this._array, i, (() {
          final E? temp_3397 = fillValue;
          return temp_3397 == null ? (temp_3397 as E) : temp_3397;
        })());
      }
    }
  }

  E firstWhere(FunctionWrapper<bool Function(E)> test,
      {FunctionWrapper<E Function()>? orElse = null}) {
    {
      for (int i = 0; (i < this._length); i = (i + 1)) {
        if (test.call((CppApi.cppGetPointerArrayItem(this._array, i) as E))) {
          return (CppApi.cppGetPointerArrayItem(this._array, i) as E);
        }
      }
      if (!(orElse == null)) return orElse.call();
      throw CppStateError(const_0);
    }
  }

  T fold<T>(T initialValue, FunctionWrapper<T Function(T, E)> combine) {
    {
      T value = initialValue;
      for (int i = 0; (i < this._length); i = (i + 1)) {
        value = combine.call(
            value, (CppApi.cppGetPointerArrayItem(this._array, i) as E));
      }
      return value;
    }
  }

  void forEach(FunctionWrapper<void Function(E)> action) {
    {
      for (int i = 0; (i < this._length); i = (i + 1)) {
        action.call((CppApi.cppGetPointerArrayItem(this._array, i) as E));
      }
    }
  }

  CppIterable<E> getRange(int start, int end) {
    {
      return CppArrayList<E>.from(CppIterable.generate<dynamic?>(
          (end - start),
          FunctionWrapper<Object? Function(int)>([], (int i) {
            return CppApi.cppGetPointerArrayItem(this._array, (start + i));
          })));
    }
  }

  int indexOf(E element, [int start = const_12]) {
    {
      for (int i = start; (i < this._length); i = (i + 1)) {
        if (CppApi.cppGetPointerArrayItem(this._array, i) == element) return i;
      }
      return -1;
    }
  }

  int indexWhere(FunctionWrapper<bool Function(E)> test,
      [int start = const_12]) {
    {
      for (int i = start; (i < this._length); i = (i + 1)) {
        if (test.call((CppApi.cppGetPointerArrayItem(this._array, i) as E)))
          return i;
      }
      return -1;
    }
  }

  void insert(int index, E element) {
    {
      if ((index < 0) || (index > this._length))
        throw CppIndexError(index, this);
      this.ensureCapacity((this._length + 1));
      for (int i = this._length; (i > index); i = (i - 1)) {
        CppApi.cppSetPointerArrayItem(this._array, i,
            CppApi.cppGetPointerArrayItem(this._array, (i - 1)));
      }
      CppApi.cppSetPointerArrayItem(this._array, index, element);
      this._length = (this._length + 1);
    }
  }

  void insertAll(int index, CppIterable<E> iterable) {
    {
      if ((index < 0) || (index > this._length))
        throw CppIndexError(index, this);
      CppList<E> elements = iterable.toList();
      int insertLength = elements.length;
      if (insertLength == 0) return;
      this.ensureCapacity((this._length + insertLength));
      for (int i = (this._length - 1); (i >= index); i = (i - 1)) {
        CppApi.cppSetPointerArrayItem(this._array, (i + insertLength),
            CppApi.cppGetPointerArrayItem(this._array, i));
      }
      for (int i = 0; (i < insertLength); i = (i + 1)) {
        CppApi.cppSetPointerArrayItem(this._array, (index + i), elements[i]);
      }
      this._length = (this._length + insertLength);
    }
  }

  E get first {
    {
      if (this._length == 0) throw CppStateError(const_0);
      return (CppApi.cppGetPointerArrayItem(this._array, 0) as E);
    }
  }

  set first(E value) {
    {
      if (this._length == 0) throw CppStateError(const_0);
      CppApi.cppSetPointerArrayItem(this._array, 0, value);
    }
  }

  E get last {
    {
      if (this._length == 0) throw CppStateError(const_0);
      return (CppApi.cppGetPointerArrayItem(this._array, (this._length - 1))
          as E);
    }
  }

  set last(E value) {
    {
      if (this._length == 0) throw CppStateError(const_0);
      CppApi.cppSetPointerArrayItem(this._array, (this._length - 1), value);
    }
  }

  E get single {
    {
      if (this._length == 0) throw CppStateError(const_0);
      if ((this._length > 1)) throw CppStateError(const_1);
      return (CppApi.cppGetPointerArrayItem(this._array, 0) as E);
    }
  }

  bool get isEmpty {
    return this._length == 0;
  }

  bool get isNotEmpty {
    return !(this._length == 0);
  }

  CppIterator<E> get iterator {
    return _CppListIterator<E>(this);
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

  int lastIndexWhere(FunctionWrapper<bool Function(E)> test,
      [int? start = null]) {
    {
      int startIndex = (start) ?? ((this._length - 1));
      for (int i = startIndex; (i >= 0); i = (i - 1)) {
        if (test.call((CppApi.cppGetPointerArrayItem(this._array, i) as E)))
          return i;
      }
      return -1;
    }
  }

  E lastWhere(FunctionWrapper<bool Function(E)> test,
      {FunctionWrapper<E Function()>? orElse = null}) {
    {
      for (int i = (this._length - 1); (i >= 0); i = (i - 1)) {
        if (test.call((CppApi.cppGetPointerArrayItem(this._array, i) as E))) {
          return (CppApi.cppGetPointerArrayItem(this._array, i) as E);
        }
      }
      if (!(orElse == null)) return orElse.call();
      throw CppStateError(const_0);
    }
  }

  E reduce(FunctionWrapper<E Function(E, E)> combine) {
    {
      if (this._length == 0) throw CppStateError(const_0);
      E value = (CppApi.cppGetPointerArrayItem(this._array, 0) as E);
      for (int i = 1; (i < this._length); i = (i + 1)) {
        value = combine.call(
            value, (CppApi.cppGetPointerArrayItem(this._array, i) as E));
      }
      return value;
    }
  }

  bool remove(Object? value) {
    {
      int index = this.indexOf((value as E));
      if (!(index == -1)) {
        this.removeAt(index);
        return true;
      }
      return false;
    }
  }

  E removeAt(int index) {
    {
      if ((index < 0) || (index >= this._length))
        throw CppIndexError(index, this);
      Object? element = CppApi.cppGetPointerArrayItem(this._array, index);
      for (int i = index; (i < (this._length - 1)); i = (i + 1)) {
        CppApi.cppSetPointerArrayItem(this._array, i,
            CppApi.cppGetPointerArrayItem(this._array, (i + 1)));
      }
      this._length = (this._length - 1);
      return (element as E);
    }
  }

  E removeLast() {
    {
      if (this._length == 0) throw CppStateError(const_0);
      return this.removeAt((this._length - 1));
    }
  }

  void removeRange(int start, int end) {
    {
      if ((start < 0) ||
          (start > this._length) ||
          (end < start) ||
          (end > this._length)) {
        throw CppRangeError.range(start, 0, this._length);
      }
      int length = (end - start);
      for (int i = start; (i < (this._length - length)); i = (i + 1)) {
        CppApi.cppSetPointerArrayItem(this._array, i,
            CppApi.cppGetPointerArrayItem(this._array, (i + length)));
      }
      this._length = (this._length - length);
    }
  }

  void removeWhere(FunctionWrapper<bool Function(E)> test) {
    {
      int writeIndex = 0;
      for (int readIndex = 0;
          (readIndex < this._length);
          readIndex = (readIndex + 1)) {
        if (!(test.call(
            (CppApi.cppGetPointerArrayItem(this._array, readIndex) as E)))) {
          if (!(writeIndex == readIndex)) {
            CppApi.cppSetPointerArrayItem(this._array, writeIndex,
                CppApi.cppGetPointerArrayItem(this._array, readIndex));
          }
          writeIndex = (writeIndex + 1);
        }
      }
      this._length = writeIndex;
    }
  }

  void replaceRange(int start, int end, CppIterable<E> replacements) {
    {
      if ((start < 0) ||
          (start > this._length) ||
          (end < start) ||
          (end > this._length)) {
        throw CppRangeError.range(start, 0, this._length);
      }
      CppList<E> replacementList = replacements.toList();
      int replacementLength = replacementList.length;
      int rangeLength = (end - start);
      if ((replacementLength > rangeLength)) {
        this.ensureCapacity(((this._length + replacementLength) - rangeLength));
      }
      if (!(replacementLength == rangeLength)) {
        for (int i = (this._length - 1); (i >= end); i = (i - 1)) {
          CppApi.cppSetPointerArrayItem(
              this._array,
              ((i + replacementLength) - rangeLength),
              CppApi.cppGetPointerArrayItem(this._array, i));
        }
      }
      for (int i = 0; (i < replacementLength); i = (i + 1)) {
        CppApi.cppSetPointerArrayItem(
            this._array, (start + i), replacementList[i]);
      }
      this._length = (this._length + (replacementLength - rangeLength));
    }
  }

  void retainWhere(FunctionWrapper<bool Function(E)> test) {
    {
      int writeIndex = 0;
      for (int readIndex = 0;
          (readIndex < this._length);
          readIndex = (readIndex + 1)) {
        if (test.call(
            (CppApi.cppGetPointerArrayItem(this._array, readIndex) as E))) {
          if (!(writeIndex == readIndex)) {
            CppApi.cppSetPointerArrayItem(this._array, writeIndex,
                CppApi.cppGetPointerArrayItem(this._array, readIndex));
          }
          writeIndex = (writeIndex + 1);
        }
      }
      this._length = writeIndex;
    }
  }

  void setAll(int index, CppIterable<E> iterable) {
    {
      if ((index < 0) || (index > this._length))
        throw CppIndexError(index, this);
      int i = index;
      {
        CppIterator<E> _sync_for_iterator = iterable.iterator;
        for (; _sync_for_iterator.moveNext();) {
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

  void setRange(int start, int end, CppIterable<E> iterable,
      [int skipCount = const_12]) {
    {
      if ((start < 0) ||
          (start > this._length) ||
          (end < start) ||
          (end > this._length)) {
        throw CppRangeError.range(start, 0, this._length);
      }
      CppIterator<E> iterator = iterable.iterator;
      for (int i = 0; (i < skipCount); i = (i + 1)) {
        if (!(iterator.moveNext())) return;
      }
      label:
      for (int i = start; (i < end); i = (i + 1)) {
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
        CppApi.cppSetPointerArrayItem(
            this._array, i, CppApi.cppGetPointerArrayItem(this._array, j));
        CppApi.cppSetPointerArrayItem(this._array, j, temp);
      }
    }
  }

  void sort([FunctionWrapper<int Function(E, E)>? compare = null]) {
    {
      if ((this._length <= 1)) return;
      this._quickSort(0, (this._length - 1), compare);
    }
  }

  void _quickSort(
      int low, int high, FunctionWrapper<int Function(E, E)>? compare) {
    {
      if ((low < high)) {
        int pi = this._partition(low, high, compare);
        this._quickSort(low, (pi - 1), compare);
        this._quickSort((pi + 1), high, compare);
      }
    }
  }

  int _partition(
      int low, int high, FunctionWrapper<int Function(E, E)>? compare) {
    {
      E pivot = (CppApi.cppGetPointerArrayItem(this._array, high) as E);
      int i = (low - 1);
      for (int j = low; (j < high); j = (j + 1)) {
        E current = (CppApi.cppGetPointerArrayItem(this._array, j) as E);
        bool shouldSwap;
        if (!(compare == null)) {
          shouldSwap = (compare.call(current, pivot) <= 0);
        } else {
          shouldSwap =
              ((current as Comparable<dynamic?>).compareTo(pivot) <= 0);
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
      E temp = (CppApi.cppGetPointerArrayItem(this._array, i) as E);
      CppApi.cppSetPointerArrayItem(
          this._array, i, CppApi.cppGetPointerArrayItem(this._array, j));
      CppApi.cppSetPointerArrayItem(this._array, j, temp);
    }
  }

  CppList<E> sublist(int start, [int? end = null]) {
    {
      int endIndex = (end) ?? (this._length);
      if ((start < 0) ||
          (start > this._length) ||
          (endIndex < start) ||
          (endIndex > this._length)) {
        throw CppRangeError.range(start, 0, this._length);
      }
      return CppArrayList<E>.from(CppIterable.generate<dynamic?>(
          (endIndex - start),
          FunctionWrapper<Object? Function(int)>([], (int i) {
            return CppApi.cppGetPointerArrayItem(this._array, (start + i));
          })));
    }
  }

  CppList<E> toList({bool growable = const_4}) {
    {
      return CppArrayList<E>.from((this as CppIterable<dynamic?>),
          growable: growable);
    }
  }

  CppSet<E> toSet() {
    {
      return CppArraySet<E>.from(this);
    }
  }

  E singleWhere(FunctionWrapper<bool Function(E)> test,
      {FunctionWrapper<E Function()>? orElse = null}) {
    {
      E? result;
      bool found = false;
      for (int i = 0; (i < this._length); i = (i + 1)) {
        if (test.call((CppApi.cppGetPointerArrayItem(this._array, i) as E))) {
          if (found) throw CppStateError(const_1);
          result = (CppApi.cppGetPointerArrayItem(this._array, i) as E);
          found = true;
        }
      }
      if (found) return result!;
      if (!(orElse == null)) return orElse.call();
      throw CppStateError(const_0);
    }
  }

  CppString toCppString() {
    {
      if (this._length == 0)
        return CppString.fromCppUserData(CppApi.cppCharCodes("[]"));
      CppStringBuffer buffer = CppStringBuffer(const_16);
      buffer.write(CppApi.cppGetPointerArrayItem(this._array, 0));
      for (int i = 1; (i < this._length); i = (i + 1)) {
        buffer.write(const_17);
        buffer.write(CppApi.cppGetPointerArrayItem(this._array, i));
      }
      buffer.write(const_18);
      return buffer.toCppString();
    }
  }

  static int _getSuggestCapacity(int newLen) {
    {
      return (newLen > 256)
          ? newLen
          : pow(2, (log(newLen) / log(2)).ceil()).toInt();
    }
  }

  static CppList<R> castFrom<S, R>(CppList<S> source) {
    {
      CppArrayList<R> result = CppArrayList<R>(0, 4);
      {
        CppIterator<S> _sync_for_iterator = source.iterator;
        for (; _sync_for_iterator.moveNext();) {
          result.add((_sync_for_iterator.current as R));
        }
      }
      return result;
    }
  }

  static CppList<R> castFromWithFactory<S, R>(
      CppList<S> source, FunctionWrapper<CppList<R> Function()> newList) {
    {
      CppList<R> result = newList.call();
      {
        CppIterator<S> _sync_for_iterator = source.iterator;
        for (; _sync_for_iterator.moveNext();) {
          result.add((_sync_for_iterator.current as R));
        }
      }
      return result;
    }
  }

  E operator [](int index) {
    return (CppApi.cppGetPointerArrayItem(this._array, index) as E);
  }

  void operator []=(int index, E value) {
    CppApi.cppSetPointerArrayItem(this._array, index, value);
  }

  CppList<E> operator +(CppList<E> other) {
    {
      CppArrayList<E> result =
          CppArrayList<E>(0, (this._length + other.length));
      for (int i = 0; (i < this._length); i = (i + 1)) {
        result.add((CppApi.cppGetPointerArrayItem(this._array, i) as E));
      }
      {
        CppIterator<E> _sync_for_iterator = other.iterator;
        for (; _sync_for_iterator.moveNext();) {
          result.add(_sync_for_iterator.current);
        }
      }
      return result;
    }
  }
}

/// 转换后的类: _CppListIterator
/// 原始类名: _CppListIterator
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/collection.dart

class _CppListIterator<E> extends CppAny implements CppIterator<E> {
  final CppArrayList<E> _list;
  int _index = -1;
  _CppListIterator(CppArrayList<E> _list)
      : _list = _list,
        super() {
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

/// 转换后的类: CppSet
/// 原始类名: CppSet
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/collection.dart

abstract class CppSet<E> extends CppAny {
  CppSet();

  factory CppSet.identity() {
    return CppArraySet<E>.identity();
  }

  factory CppSet.from(CppIterable<dynamic?> elements) {
    {
      return CppArraySet<E>.from(elements);
    }
  }

  factory CppSet.of(CppIterable<E> elements) {
    return CppArraySet<E>.of(elements);
  }

  factory CppSet.unmodifiable(CppIterable<E> elements) {
    {
      return CppArraySet<E>.unmodifiable(elements);
    }
  }

  bool add(E value);

  void addAll(CppIterable<E> elements);

  CppIterable<R> cast<R>();

  void clear();

  bool contains(Object? element);

  bool containsAll(CppIterable<Object?> other);

  CppSet<E> difference(CppSet<Object?> other);

  E elementAt(int index);

  CppSet<E> intersection(CppSet<Object?> other);

  E get first;

  E get last;

  E get single;

  bool get isEmpty;

  bool get isNotEmpty;

  CppIterator<E> get iterator;

  int get length;

  E? lookup(Object? element);

  bool remove(Object? value);

  void removeAll(CppIterable<Object?> elementsToRemove);

  void removeWhere(FunctionWrapper<bool Function(E)> test);

  void retainAll(CppIterable<Object?> elementsToRetain);

  void retainWhere(FunctionWrapper<bool Function(E)> test);

  CppSet<E> union(CppSet<E> other);

  CppString toCppString();

  static CppSet<R> castFrom<S, R>(CppSet<S> source) {
    {
      return CppArraySet.castFrom<S, R>(source);
    }
  }

  static CppSet<R> castFromWithFactory<S, R>(
      CppSet<S> source, FunctionWrapper<CppSet<R> Function()> newSet) {
    {
      return CppArraySet.castFromWithFactory<S, R>(source, newSet);
    }
  }
}

/// 转换后的类: CppArraySet
/// 原始类名: CppArraySet
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/collection.dart

class CppArraySet<E> extends CppIterable<E> implements CppSet<E> {
  final CppArrayList<E> _list;
  CppArraySet.fromCppArray(CppUserData array)
      : _list = CppArrayList<E>.fromCppArray(array),
        super() {
    ;
  }

  CppArraySet([int capacity = const_19])
      : _list = CppArrayList<E>(0, capacity),
        super() {
    ;
  }

  factory CppArraySet.identity() {
    return CppArraySet<E>(4);
  }

  factory CppArraySet.from(CppIterable<dynamic?> elements) {
    {
      CppArraySet<E> set = CppArraySet<E>();
      {
        CppIterator<dynamic?> _sync_for_iterator = elements.iterator;
        for (; _sync_for_iterator.moveNext();) {
          set.add((_sync_for_iterator.current as E));
        }
      }
      return set;
    }
  }

  factory CppArraySet.of(CppIterable<E> elements) {
    return CppArraySet<E>.from(elements);
  }

  factory CppArraySet.unmodifiable(CppIterable<E> elements) {
    {
      CppArraySet<E> set = CppArraySet<E>();
      {
        CppIterator<E> _sync_for_iterator = elements.iterator;
        for (; _sync_for_iterator.moveNext();) {
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

  void addAll(CppIterable<E> elements) {
    {
      {
        CppIterator<E> _sync_for_iterator = elements.iterator;
        for (; _sync_for_iterator.moveNext();) {
          this.add(_sync_for_iterator.current);
        }
      }
    }
  }

  CppIterable<R> cast<R>() {
    {
      return (CppSet.castFrom<E, R>(this) as CppIterable<R>);
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

  bool containsAll(CppIterable<Object?> other) {
    {
      {
        CppIterator<Object?> _sync_for_iterator = other.iterator;
        for (; _sync_for_iterator.moveNext();) {
          if (!(this.contains(_sync_for_iterator.current))) return false;
        }
      }
      return true;
    }
  }

  CppSet<E> difference(CppSet<Object?> other) {
    {
      CppArraySet<E> result = CppArraySet<E>();
      {
        CppIterator<E> _sync_for_iterator = this._list.iterator;
        for (; _sync_for_iterator.moveNext();) {
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

  CppSet<E> intersection(CppSet<Object?> other) {
    {
      CppArraySet<E> result = CppArraySet<E>();
      {
        CppIterator<E> _sync_for_iterator = this._list.iterator;
        for (; _sync_for_iterator.moveNext();) {
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
      if (this._list.isEmpty) throw CppStateError(const_0);
      return this._list.first;
    }
  }

  E get last {
    {
      if (this._list.isEmpty) throw CppStateError(const_0);
      return this._list.last;
    }
  }

  E get single {
    {
      if (this._list.isEmpty) throw CppStateError(const_0);
      if ((this._list.length > 1)) throw CppStateError(const_1);
      return this._list.single;
    }
  }

  bool get isEmpty {
    return this._list.isEmpty;
  }

  bool get isNotEmpty {
    return this._list.isNotEmpty;
  }

  CppIterator<E> get iterator {
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

  void removeAll(CppIterable<Object?> elementsToRemove) {
    {
      {
        CppIterator<Object?> _sync_for_iterator = elementsToRemove.iterator;
        for (; _sync_for_iterator.moveNext();) {
          this.remove(_sync_for_iterator.current);
        }
      }
    }
  }

  void removeWhere(FunctionWrapper<bool Function(E)> test) {
    {
      this._list.removeWhere(test);
    }
  }

  void retainAll(CppIterable<Object?> elementsToRetain) {
    {
      CppSet<dynamic?> retainSet = CppSet<dynamic?>.from(elementsToRetain);
      this.removeWhere(FunctionWrapper<bool Function(E)>([], (E element) {
        return !(retainSet.contains(element));
      }));
    }
  }

  void retainWhere(FunctionWrapper<bool Function(E)> test) {
    {
      this._list.retainWhere(test);
    }
  }

  CppSet<E> union(CppSet<E> other) {
    {
      CppArraySet<E> result = CppArraySet<E>();
      result.addAll((this as CppIterable<E>));
      result.addAll((other as CppIterable<E>));
      return result;
    }
  }

  CppString toCppString() {
    {
      if (this._list.isEmpty)
        return CppString.fromCppUserData(CppApi.cppCharCodes("{}"));
      CppStringBuffer buffer = CppStringBuffer(const_20);
      CppIterator<E> iterator = this._list.iterator;
      if (iterator.moveNext()) {
        buffer.write(iterator.current);
        while (iterator.moveNext()) {
          buffer.write(const_17);
          buffer.write(iterator.current);
        }
      }
      buffer.write(const_10);
      return buffer.toCppString();
    }
  }

  static CppSet<R> castFrom<S, R>(CppSet<S> source) {
    {
      CppArraySet<R> result = CppArraySet<R>();
      {
        CppIterator<S> _sync_for_iterator = source.iterator;
        for (; _sync_for_iterator.moveNext();) {
          result.add((_sync_for_iterator.current as R));
        }
      }
      return result;
    }
  }

  static CppSet<R> castFromWithFactory<S, R>(
      CppSet<S> source, FunctionWrapper<CppSet<R> Function()> newSet) {
    {
      CppSet<R> result = newSet.call();
      {
        CppIterator<S> _sync_for_iterator = source.iterator;
        for (; _sync_for_iterator.moveNext();) {
          result.add((_sync_for_iterator.current as R));
        }
      }
      return result;
    }
  }
}

/// 转换后的类: CppMapEntry
/// 原始类名: CppMapEntry
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/collection.dart

class CppMapEntry<K, V> extends CppAny {
  final K key;
  final V value;
  CppMapEntry(K key, V value)
      : key = key,
        value = value,
        super() {
    ;
  }
}

/// 转换后的类: CppMap
/// 原始类名: CppMap
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/collection.dart

abstract class CppMap<K, V> extends CppAny {
  CppMap();

  factory CppMap.identity() {
    return CppArrayMap<K, V>.identity();
  }

  factory CppMap.from(CppMap<dynamic?, dynamic?> other) {
    return CppArrayMap<K, V>.from(other);
  }

  factory CppMap.of(CppMap<K, V> other) {
    return CppArrayMap<K, V>.of(other);
  }

  factory CppMap.unmodifiable(CppMap<dynamic?, dynamic?> other) {
    {
      return CppArrayMap<K, V>.unmodifiable(other);
    }
  }

  factory CppMap.fromIterable(CppIterable<dynamic?> iterable,
      {FunctionWrapper<K Function(dynamic?)>? key = null,
      FunctionWrapper<V Function(dynamic?)>? value = null}) {
    {
      return CppArrayMap<K, V>.fromIterable(iterable, key: key, value: value);
    }
  }

  factory CppMap.fromIterables(CppIterable<K> keys, CppIterable<V> values) {
    {
      return CppArrayMap<K, V>.fromIterables(keys, values);
    }
  }

  factory CppMap.fromEntries(CppIterable<CppMapEntry<K, V>> entries) {
    {
      return CppArrayMap<K, V>.fromEntries(entries);
    }
  }

  void addAll(CppMap<K, V> other);

  void addEntries(CppIterable<CppMapEntry<K, V>> entries);

  CppMap<RK, RV> cast<RK, RV>();

  void clear();

  bool containsKey(Object? key);

  bool containsValue(Object? value);

  CppIterable<CppMapEntry<K, V>> get entries;

  void forEach(FunctionWrapper<void Function(K, V)> action);

  bool get isEmpty;

  bool get isNotEmpty;

  CppIterable<K> get keys;

  int get length;

  V putIfAbsent(K key, FunctionWrapper<V Function()> ifAbsent);

  V? remove(Object? key);

  void removeWhere(FunctionWrapper<bool Function(K, V)> test);

  V update(K key, FunctionWrapper<V Function(V)> update,
      {FunctionWrapper<V Function()>? ifAbsent = null});

  void updateAll(FunctionWrapper<V Function(K, V)> update);

  CppIterable<V> get values;

  CppMap<K2, V2> map<K2, V2>(
      FunctionWrapper<CppMapEntry<K2, V2> Function(K, V)> transform);

  CppString toCppString();

  static CppMap<RK, RV> castFrom<K, V, RK, RV>(CppMap<K, V> source) {
    {
      return CppArrayMap.castFrom<K, V, RK, RV>(source);
    }
  }

  static CppMap<RK, RV> castFromWithFactory<K, V, RK, RV>(
      CppMap<K, V> source, FunctionWrapper<CppMap<RK, RV> Function()> newMap) {
    {
      return CppArrayMap.castFromWithFactory<K, V, RK, RV>(source, newMap);
    }
  }

  V? operator [](Object? key);

  void operator []=(K key, V value);
}

/// 转换后的类: CppArrayMap
/// 原始类名: CppArrayMap
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/collection.dart

class CppArrayMap<K, V> extends CppAny implements CppMap<K, V> {
  final CppArrayList<CppMapEntry<K, V>> _list;
  CppArrayMap.fromCppArray(CppUserData array)
      : _list = CppArrayList<CppMapEntry<K, V>>.fromCppArray(array),
        super() {
    ;
  }

  CppArrayMap([int capacity = const_19])
      : _list = CppArrayList<CppMapEntry<K, V>>(0, capacity),
        super() {
    ;
  }

  factory CppArrayMap.identity() {
    return CppArrayMap<K, V>();
  }

  factory CppArrayMap.from(CppMap<dynamic?, dynamic?> other) {
    return CppArrayMap<K, V>.unmodifiable(other);
  }

  factory CppArrayMap.of(CppMap<K, V> other) {
    return CppArrayMap<K, V>.fromEntries(other.entries);
  }

  factory CppArrayMap.unmodifiable(CppMap<dynamic?, dynamic?> other) {
    {
      CppArrayMap<K, V> map = CppArrayMap<K, V>();
      other.forEach(FunctionWrapper<void Function(dynamic?, dynamic?)>([],
          (dynamic? key, dynamic? value) {
        {
          map[(key as K)] = (value as V);
        }
      }));
      return map;
    }
  }

  factory CppArrayMap.fromIterable(CppIterable<dynamic?> iterable,
      {FunctionWrapper<K Function(dynamic?)>? key = null,
      FunctionWrapper<V Function(dynamic?)>? value = null}) {
    {
      CppArrayMap<K, V> map = CppArrayMap<K, V>();
      {
        CppIterator<dynamic?> _sync_for_iterator = iterable.iterator;
        for (; _sync_for_iterator.moveNext();) {
          dynamic? element = _sync_for_iterator.current;
          dynamic? k = ((() {
                final FunctionWrapper<K Function(dynamic?)>? temp_33078_1742 =
                    key;
                return temp_33078_1742 == null
                    ? null
                    : temp_33078_1742.call(element);
              })()) ??
              (element);
          dynamic? v = ((() {
                final FunctionWrapper<V Function(dynamic?)>? temp_33125_1752 =
                    value;
                return temp_33125_1752 == null
                    ? null
                    : temp_33125_1752.call(element);
              })()) ??
              (element);
          map[(k as K)] = (v as V);
        }
      }
      return map;
    }
  }

  factory CppArrayMap.fromIterables(
      CppIterable<K> keys, CppIterable<V> values) {
    {
      CppArrayMap<K, V> map = CppArrayMap<K, V>();
      CppIterator<K> keyIter = keys.iterator;
      CppIterator<V> valueIter = values.iterator;
      while (keyIter.moveNext() && valueIter.moveNext()) {
        map[keyIter.current] = valueIter.current;
      }
      return map;
    }
  }

  factory CppArrayMap.fromEntries(CppIterable<CppMapEntry<K, V>> entries) {
    {
      CppArrayMap<K, V> map = CppArrayMap<K, V>();
      {
        CppIterator<CppMapEntry<K, V>> _sync_for_iterator = entries.iterator;
        for (; _sync_for_iterator.moveNext();) {
          CppMapEntry<K, V> entry = _sync_for_iterator.current;
          map[entry.key] = entry.value;
        }
      }
      return map;
    }
  }

  void addAll(CppMap<K, V> other) {
    {
      other.forEach(FunctionWrapper<void Function(K, V)>([], (K k, V v) {
        return (() {
          final K temp_34552_1989 = k;
          return (() {
            final V temp_34558_1991 = v;
            return (() {
              this[temp_34552_1989] = temp_34558_1991;
              temp_34558_1991;
            })();
          })();
        })();
      }));
    }
  }

  void addEntries(CppIterable<CppMapEntry<K, V>> entries) {
    {
      {
        CppIterator<CppMapEntry<K, V>> _sync_for_iterator = entries.iterator;
        for (; _sync_for_iterator.moveNext();) {
          CppMapEntry<K, V> entry = _sync_for_iterator.current;
          this[entry.key] = entry.value;
        }
      }
    }
  }

  CppMap<RK, RV> cast<RK, RV>() {
    return CppMap.castFrom<K, V, RK, RV>(this);
  }

  void clear() {
    {
      this._list.clear();
    }
  }

  bool containsKey(Object? key) {
    {
      {
        CppIterator<CppMapEntry<K, V>> _sync_for_iterator = this._list.iterator;
        for (; _sync_for_iterator.moveNext();) {
          CppMapEntry<K, V> entry = _sync_for_iterator.current;
          if (entry.key == key) return true;
        }
      }
      return false;
    }
  }

  bool containsValue(Object? value) {
    {
      {
        CppIterator<CppMapEntry<K, V>> _sync_for_iterator = this._list.iterator;
        for (; _sync_for_iterator.moveNext();) {
          CppMapEntry<K, V> entry = _sync_for_iterator.current;
          if (entry.value == value) return true;
        }
      }
      return false;
    }
  }

  CppIterable<CppMapEntry<K, V>> get entries {
    return this._list;
  }

  void forEach(FunctionWrapper<void Function(K, V)> action) {
    {
      {
        CppIterator<CppMapEntry<K, V>> _sync_for_iterator = this._list.iterator;
        for (; _sync_for_iterator.moveNext();) {
          CppMapEntry<K, V> entry = _sync_for_iterator.current;
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

  CppIterable<K> get keys {
    return this._list.map(FunctionWrapper<K Function(CppMapEntry<K, V>)>([],
            (CppMapEntry<K, V> e) {
          return e.key;
        }));
  }

  int get length {
    return this._list.length;
  }

  V putIfAbsent(K key, FunctionWrapper<V Function()> ifAbsent) {
    {
      {
        CppIterator<CppMapEntry<K, V>> _sync_for_iterator = this._list.iterator;
        for (; _sync_for_iterator.moveNext();) {
          CppMapEntry<K, V> entry = _sync_for_iterator.current;
          if (entry.key == key) return entry.value;
        }
      }
      V v = ifAbsent.call();
      this._list.add(CppMapEntry<K, V>(key, v));
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

  void removeWhere(FunctionWrapper<bool Function(K, V)> test) {
    {
      int i = 0;
      while ((i < this._list.length)) {
        CppMapEntry<K, V> entry = this._list[i];
        if (test.call(entry.key, entry.value)) {
          this.remove(entry.key);
        } else {
          i = (i + 1);
        }
      }
    }
  }

  V update(K key, FunctionWrapper<V Function(V)> update,
      {FunctionWrapper<V Function()>? ifAbsent = null}) {
    {
      for (int i = 0; (i < this._list.length); i = (i + 1)) {
        if (this._list[i].key == key) {
          V newValue = update.call(this._list[i].value);
          this._list[i] = CppMapEntry<K, V>(key, newValue);
          return newValue;
        }
      }
      if (!(ifAbsent == null)) {
        V v = ifAbsent.call();
        this._list.add(CppMapEntry<K, V>(key, v));
        return v;
      }
      throw ArgumentError(const_21);
    }
  }

  void updateAll(FunctionWrapper<V Function(K, V)> update) {
    {
      for (int i = 0; (i < this._list.length); i = (i + 1)) {
        CppMapEntry<K, V> entry = this._list[i];
        this._list[i] =
            CppMapEntry<K, V>(entry.key, update.call(entry.key, entry.value));
      }
    }
  }

  CppIterable<V> get values {
    return this._list.map(FunctionWrapper<V Function(CppMapEntry<K, V>)>([],
            (CppMapEntry<K, V> e) {
          return e.value;
        }));
  }

  CppMap<K2, V2> map<K2, V2>(
      FunctionWrapper<CppMapEntry<K2, V2> Function(K, V)> transform) {
    {
      CppArrayMap<K2, V2> result = CppArrayMap<K2, V2>();
      {
        CppIterator<CppMapEntry<K, V>> _sync_for_iterator = this._list.iterator;
        for (; _sync_for_iterator.moveNext();) {
          CppMapEntry<K, V> entry = _sync_for_iterator.current;
          CppMapEntry<K2, V2> newEntry = transform.call(entry.key, entry.value);
          result[newEntry.key] = newEntry.value;
        }
      }
      return result;
    }
  }

  CppString toCppString() {
    {
      if (this._list.isEmpty)
        return CppString.fromCppUserData(CppApi.cppCharCodes("{}"));
      CppStringBuffer buffer = CppStringBuffer(const_20);
      CppIterator<CppMapEntry<K, V>> iterator = this._list.iterator;
      if (iterator.moveNext()) {
        buffer.write(CppString.convertString(iterator.current.key) +
            const_22 +
            CppString.convertString(iterator.current.value));
        while (iterator.moveNext()) {
          buffer.write(const_17 +
              CppString.convertString(iterator.current.key) +
              const_22 +
              CppString.convertString(iterator.current.value));
        }
      }
      buffer.write(const_10);
      return buffer.toCppString();
    }
  }

  static CppMap<RK, RV> castFrom<K, V, RK, RV>(CppMap<K, V> source) {
    {
      CppArrayMap<RK, RV> result = CppArrayMap<RK, RV>();
      source.forEach(FunctionWrapper<void Function(K, V)>([], (K key, V value) {
        {
          result[(key as RK)] = (value as RV);
        }
      }));
      return result;
    }
  }

  static CppMap<RK, RV> castFromWithFactory<K, V, RK, RV>(
      CppMap<K, V> source, FunctionWrapper<CppMap<RK, RV> Function()> newMap) {
    {
      CppMap<RK, RV> result = newMap.call();
      source.forEach(FunctionWrapper<void Function(K, V)>([], (K key, V value) {
        {
          result[(key as RK)] = (value as RV);
        }
      }));
      return result;
    }
  }

  V? operator [](Object? key) {
    {
      {
        CppIterator<CppMapEntry<K, V>> _sync_for_iterator = this._list.iterator;
        for (; _sync_for_iterator.moveNext();) {
          CppMapEntry<K, V> entry = _sync_for_iterator.current;
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
          this._list[i] = CppMapEntry<K, V>(key, value);
          return;
        }
      }
      this._list.add(CppMapEntry<K, V>(key, value));
    }
  }
}

/// 转换后的类: CppStackTrace
/// 原始类名: CppStackTrace
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/error.dart

class CppStackTrace extends CppAny {
  static CppStackTrace _current = CppStackTrace();
  CppStackTrace() : super() {
    ;
  }

  static CppStackTrace get current {
    return CppStackTrace._current;
  }

  CppString toCppString() {
    return CppString.fromCppUserData(CppApi.getCurrentStackTrace());
  }
}

/// 转换后的类: CppError
/// 原始类名: CppError
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/error.dart

class CppError extends CppAny {
  CppError() : super() {
    ;
  }

  CppStackTrace? get stackTrace {
    return CppStackTrace.current;
  }
}

/// 转换后的类: CppStateError
/// 原始类名: CppStateError
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/error.dart

class CppStateError extends CppError {
  late CppString message;
  CppStateError(CppString message)
      : message = message,
        super() {
    ;
  }
}

/// 转换后的类: CppRangeError
/// 原始类名: CppRangeError
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/error.dart

class CppRangeError extends CppError {
  final num? start;
  final num? end;
  final num? invalidValue;
  final CppString? name;
  final CppString? message;
  CppRangeError(CppString? message)
      : message = message,
        start = null,
        end = null,
        invalidValue = null,
        name = null,
        super() {
    ;
  }

  CppRangeError.value(num invalidValue,
      [CppString? name = null, CppString? message = null])
      : name = name,
        message = message,
        start = null,
        end = null,
        invalidValue = invalidValue,
        super() {
    ;
  }

  CppRangeError.range(num invalidValue, int? minValue, int? maxValue,
      [CppString? name = null, CppString? message = null])
      : name = name,
        message = message,
        start = minValue,
        end = maxValue,
        invalidValue = invalidValue,
        super() {
    ;
  }
}

/// 转换后的类: CppIndexError
/// 原始类名: CppIndexError
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/error.dart

class CppIndexError extends CppError {
  final CppAny? indexable;
  final int length;
  final int invalidValue;
  final CppString? name;
  final CppString? message;
  CppIndexError(int invalidValue, CppAny? indexable,
      [CppString? name = null, CppString? message = null, int? length = null])
      : invalidValue = invalidValue,
        indexable = indexable,
        name = name,
        message = message,
        length = (length) ?? (0),
        super() {
    ;
  }

  CppIndexError.withLength(int invalidValue, int length,
      {CppAny? indexable = null,
      CppString? name = null,
      CppString? message = null})
      : invalidValue = invalidValue,
        length = length,
        indexable = indexable,
        name = name,
        message = message,
        super() {
    ;
  }
}

/// 全局函数和变量
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/hello.dart

void main() {
  {
    testIterableMethods();
  }
}

void testCollectionMethods() {
  {
    Random aa = Random();
    aa.nextDouble();
    aa.nextDouble();
    aa.nextDouble();
    CppList<int> list = CppList<int>.filled(3, 0);
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
    print(const_23);
  }
}

void testIterableMethods() {
  {
    CppList<int> iterableList =
        CppArrayList<int>.fromCppArray(CppApi.cppArrayConst(5, 1, 2, 3, 4, 5));
    assert(iterableList.first == 1);
    assert(iterableList.last == 5);
    assert(iterableList.length == 5);
    assert(
        iterableList.any(FunctionWrapper<bool Function(int)>([], (int element) {
      return (element > 3);
    })));
    assert(!(iterableList
        .every(FunctionWrapper<bool Function(int)>([], (int element) {
      return (element < 3);
    }))));
    CppIterable<int> mappedList =
        iterableList.map(FunctionWrapper<int Function(int)>([], (int e) {
      return (e * 2);
    }));
    assert(CppString.convertString(mappedList.toList()) ==
        CppString.convertString(CppArrayList<int>.fromCppArray(
            CppApi.cppArrayConst(5, 2, 4, 6, 8, 10))));
    CppIterable<int> filteredList =
        iterableList.where(FunctionWrapper<bool Function(int)>([], (int e) {
      return (e % 2) == 0;
    }));
    assert(CppString.convertString(filteredList.toList()) ==
        CppString.convertString(
            CppArrayList<int>.fromCppArray(CppApi.cppArrayConst(2, 2, 4))));
    print(const_24);
    CppStringBuffer buffer = CppStringBuffer();
    buffer.write(const_25);
    buffer.write(const_26);
    print(CppString.convertString(buffer));
    CppError error = CppError();
    CppString.convertString(error);
    CppStringBuffer buffer2 = CppStringBuffer(const_27);
    buffer2.write(const_25);
    buffer2.write(const_26);
    print(CppString.convertString(buffer2));
    CppList<int> list = CppArrayList<int>.generate(
        10,
        FunctionWrapper<int Function(int)>([], (int index) {
          return index;
        }));
    list.add(11);
    print(CppString.convertString(list));
    BoxInt g1 = BoxInt(1);
    BoxInt g2 = BoxInt();
    g2.value = 5;
    FunctionWrapper<Object? Function()> ff =
        FunctionWrapper<Object? Function()>([g1, g2], () {
      {
        g1.value = (g1.value + 1);
        g2.value = (g2.value + 1);
        print(((CppString.convertString(g1.value) + const_28) +
            CppString.convertString(g2.value)));
      }
    });
    ff.call();
    CppList<dynamic?> list2 =
        CppArrayList<dynamic?>.fromCppArray(CppApi.cppArrayConst(0));
    for (int $origin_i = 0; ($origin_i < 10); $origin_i = ($origin_i + 1)) {
      BoxInt i = BoxInt($origin_i);
      list2.add(FunctionWrapper<Object? Function()>([i], () {
        {
          print(i.value);
        }
      }));
      $origin_i = i.value;
    }
    list2.forEach(FunctionWrapper<void Function(dynamic?)>([], (dynamic? f) {
      return f.call();
    }));
    {
      CppList<dynamic?> list3 =
          CppArrayList<dynamic?>.fromCppArray(CppApi.cppArrayConst(0));
      BoxInt i = BoxInt(0);
      for (i = BoxInt(0); (i.value < 10); i.value = (i.value + 1)) {
        list3.add(FunctionWrapper<Object? Function()>([i], () {
          {
            print(i.value);
          }
        }));
      }
      list3.forEach(FunctionWrapper<void Function(dynamic?)>([], (dynamic? f) {
        return f.call();
      }));
    }
    {
      CppList<dynamic?> list4 =
          CppArrayList<dynamic?>.fromCppArray(CppApi.cppArrayConst(0));
      for (int $origin_i = 0; ($origin_i < 3); $origin_i = ($origin_i + 1)) {
        BoxInt i = BoxInt($origin_i);
        list4.add(FunctionWrapper<Object? Function()>([i], () {
          {
            print(i.value);
          }
        }));
        $origin_i = i.value;
      }
      list4.forEach(FunctionWrapper<void Function(dynamic?)>([], (dynamic? f) {
        return f.call();
      }));
    }
  }
}

/// 全局函数和变量
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/api.dart

const CppUserData cppUserDataEmpty = CppUserData.constant([]);

/// 全局函数和变量
/// 源文件路径: /Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2bytecode/lib/demo/object.dart

CppString ObjectExt_toCppString(Object _this) {
  {
    if ((_this is CppAny)) {
      return (_this as CppAny).toCppString();
    }
    throw const_29;
  }
}

FunctionWrapper<CppString Function()> ObjectExt_get_toCppString(Object _this) {
  return FunctionWrapper<CppString Function()>([], () {
    return ObjectExt_toCppString(_this);
  });
}

void testExtensionCall(Object obj) {
  {
    CppString result = ObjectExt_toCppString(obj);
    print(result);
  }
}

void testExtensionGetter(Object obj) {
  {
    FunctionWrapper<CppString Function()> getter =
        ObjectExt_get_toCppString(obj);
    print(getter);
  }
}

/// 全局const常量定义
/// 自动生成的const常量，用于替换重复的const值
const const_0 = CppString.fromCppUserData(
    CppUserData.constant([78, 111, 32, 101, 108, 101, 109, 101, 110, 116]));
const const_1 = CppString.fromCppUserData(CppUserData.constant([
  84,
  111,
  111,
  32,
  109,
  97,
  110,
  121,
  32,
  101,
  108,
  101,
  109,
  101,
  110,
  116,
  115
]));
const const_2 = CppString.fromCppUserData(CppUserData.constant([
  73,
  110,
  100,
  101,
  120,
  32,
  99,
  97,
  110,
  110,
  111,
  116,
  32,
  98,
  101,
  32,
  110,
  101,
  103,
  97,
  116,
  105,
  118,
  101
]));
const const_3 = [];
const const_4 = true;
const const_5 = CppString.fromCppUserData(CppUserData.constant([
  67,
  112,
  112,
  83,
  116,
  114,
  105,
  110,
  103,
  80,
  111,
  111,
  108,
  83,
  116,
  97,
  116,
  115,
  123,
  92,
  110
]));
const const_6 = CppString.fromCppUserData(CppUserData.constant(
    [32, 32, 19981, 21516, 23383, 31526, 20018, 25968, 58, 32]));
const const_7 = CppString.fromCppUserData(CppUserData.constant([92, 110]));
const const_8 = CppString.fromCppUserData(
    CppUserData.constant([32, 32, 24635, 20869, 23384, 20351, 29992, 58, 32]));
const const_9 = CppString.fromCppUserData(
    CppUserData.constant([32, 23383, 31526, 92, 110]));
const const_10 = CppString.fromCppUserData(CppUserData.constant([125]));
const const_11 = CppString.fromCppUserData(CppUserData.constant([]));
const const_12 = 0;
const const_13 =
    CppString.fromCppUserData(CppUserData.constant([105, 110, 100, 101, 120]));
const const_14 =
    CppString.fromCppUserData(CppUserData.constant([115, 116, 97, 114, 116]));
const const_15 = false;
const const_16 = CppString.fromCppUserData(CppUserData.constant([91]));
const const_17 = CppString.fromCppUserData(CppUserData.constant([44, 32]));
const const_18 = CppString.fromCppUserData(CppUserData.constant([93]));
const const_19 = 4;
const const_20 = CppString.fromCppUserData(CppUserData.constant([123]));
const const_21 = CppString.fromCppUserData(CppUserData.constant(
    [75, 101, 121, 32, 110, 111, 116, 32, 102, 111, 117, 110, 100]));
const const_22 = CppString.fromCppUserData(CppUserData.constant([58, 32]));
const const_23 = CppString.fromCppUserData(CppUserData.constant([
  67,
  112,
  112,
  76,
  105,
  115,
  116,
  32,
  26041,
  27861,
  27979,
  35797,
  36890,
  36807,
  65281
]));
const const_24 = CppString.fromCppUserData(CppUserData.constant([
  67,
  112,
  112,
  73,
  116,
  101,
  114,
  97,
  98,
  108,
  101,
  32,
  26041,
  27861,
  27979,
  35797,
  36890,
  36807,
  65281
]));
const const_25 =
    CppString.fromCppUserData(CppUserData.constant([72, 101, 108, 108, 111]));
const const_26 =
    CppString.fromCppUserData(CppUserData.constant([87, 111, 114, 108, 100]));
const const_27 = CppString.fromCppUserData(CppUserData.constant([120, 120]));
const const_28 = CppString.fromCppUserData(CppUserData.constant([32]));
const const_29 = CppString.fromCppUserData(CppUserData.constant([
  67,
  97,
  110,
  110,
  111,
  116,
  32,
  99,
  111,
  110,
  118,
  101,
  114,
  116,
  32,
  116,
  111,
  32,
  67,
  112,
  112,
  83,
  116,
  114,
  105,
  110,
  103
]));
