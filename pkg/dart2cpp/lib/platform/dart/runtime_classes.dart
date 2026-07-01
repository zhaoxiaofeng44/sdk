/// Dart2Cpp restorer 运行时基础类定义
///
/// 包含 VPtr 虚函数表基类、TypeFunction 函数值基类族、Box 类型（闭包引用语义）。
/// 由 dart_restorer 生成的还原代码通过 import 引入本文件。
///
/// 注意：本文件完全不依赖 dart:collection，所有集合类自行实现。

// ============================================================================
// TypeFunction 基类族 — 替代 Dart 内建 Function 类型
// ----------------------------------------------------------------------------
// Dart 不支持 variadic generics，因此按 arity 索引展开 TypeFunction0..N。
// 还原后的代码：
//   * 所有函数类型注解（包括 vptr cast）使用 `TypeFunctionN<R, T1..Tn>`，
//     不再出现裸 `Function`；
//   * 所有闭包（含捕获 / 无捕获）和 tear-off 都被还原器生成为
//     `extends TypeFunctionN<...>` 的具名子类实例，而不是 inline lambda。
// 调用语法保持 Dart 原生 `f(a, b, c)` — 因为 TypeFunctionN 是 callable
// class（声明了具名 `call` 方法）。
//
// arity ceiling 当前为 16；超出请在此文件追加 TypeFunction17..N 并同步
// 还原器侧的 ARITY 上限常量。
// ============================================================================

abstract class TypeFunction extends AnyGC {
  TypeFunction();
  late dynamic closureCall;
}

abstract class TypeFunction0<R> extends TypeFunction {
  TypeFunction0();
  R call();
}

abstract class TypeFunction1<R, T1> extends TypeFunction {
  TypeFunction1();
  R call(T1 a1);
}

abstract class TypeFunction2<R, T1, T2> extends TypeFunction {
  TypeFunction2();
  R call(T1 a1, T2 a2);
}

abstract class TypeFunction3<R, T1, T2, T3> extends TypeFunction {
  TypeFunction3();
  R call(T1 a1, T2 a2, T3 a3);
}

abstract class TypeFunction4<R, T1, T2, T3, T4> extends TypeFunction {
  TypeFunction4();
  R call(T1 a1, T2 a2, T3 a3, T4 a4);
}

abstract class TypeFunction5<R, T1, T2, T3, T4, T5> extends TypeFunction {
  TypeFunction5();
  R call(T1 a1, T2 a2, T3 a3, T4 a4, T5 a5);
}

abstract class TypeFunction6<R, T1, T2, T3, T4, T5, T6> extends TypeFunction {
  TypeFunction6();
  R call(T1 a1, T2 a2, T3 a3, T4 a4, T5 a5, T6 a6);
}

abstract class TypeFunction7<R, T1, T2, T3, T4, T5, T6, T7> extends TypeFunction {
  TypeFunction7();
  R call(T1 a1, T2 a2, T3 a3, T4 a4, T5 a5, T6 a6, T7 a7);
}

abstract class TypeFunction8<R, T1, T2, T3, T4, T5, T6, T7, T8> extends TypeFunction {
  TypeFunction8();
  R call(T1 a1, T2 a2, T3 a3, T4 a4, T5 a5, T6 a6, T7 a7, T8 a8);
}

abstract class TypeFunction9<R, T1, T2, T3, T4, T5, T6, T7, T8, T9>
    extends TypeFunction {
  TypeFunction9();
  R call(T1 a1, T2 a2, T3 a3, T4 a4, T5 a5, T6 a6, T7 a7, T8 a8, T9 a9);
}

abstract class TypeFunction10<R, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10>
    extends TypeFunction {
  TypeFunction10();
  R call(T1 a1, T2 a2, T3 a3, T4 a4, T5 a5, T6 a6, T7 a7, T8 a8, T9 a9, T10 a10);
}

abstract class TypeFunction11<R, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11>
    extends TypeFunction {
  TypeFunction11();
  R call(T1 a1, T2 a2, T3 a3, T4 a4, T5 a5, T6 a6, T7 a7, T8 a8, T9 a9, T10 a10,
      T11 a11);
}

abstract class TypeFunction12<R, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12>
    extends TypeFunction {
  TypeFunction12();
  R call(T1 a1, T2 a2, T3 a3, T4 a4, T5 a5, T6 a6, T7 a7, T8 a8, T9 a9, T10 a10,
      T11 a11, T12 a12);
}

abstract class TypeFunction13<R, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13>
    extends TypeFunction {
  TypeFunction13();
  R call(T1 a1, T2 a2, T3 a3, T4 a4, T5 a5, T6 a6, T7 a7, T8 a8, T9 a9, T10 a10,
      T11 a11, T12 a12, T13 a13);
}

abstract class TypeFunction14<R, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14>
    extends TypeFunction {
  TypeFunction14();
  R call(T1 a1, T2 a2, T3 a3, T4 a4, T5 a5, T6 a6, T7 a7, T8 a8, T9 a9, T10 a10,
      T11 a11, T12 a12, T13 a13, T14 a14);
}

abstract class TypeFunction15<R, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15>
    extends TypeFunction {
  TypeFunction15();
  R call(T1 a1, T2 a2, T3 a3, T4 a4, T5 a5, T6 a6, T7 a7, T8 a8, T9 a9, T10 a10,
      T11 a11, T12 a12, T13 a13, T14 a14, T15 a15);
}

abstract class TypeFunction16<R, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16>
    extends TypeFunction {
  TypeFunction16();
  R call(T1 a1, T2 a2, T3 a3, T4 a4, T5 a5, T6 a6, T7 a7, T8 a8, T9 a9, T10 a10,
      T11 a11, T12 a12, T13 a13, T14 a14, T15 a15, T16 a16);
}

// ============================================================================
// AnyGC 基类 — 所有需要 GC 管理的类型（VPtr / Box）的公共基类
// ----------------------------------------------------------------------------
// 提供 _gcFlag 标记位和 gcMark 方法，供标记-清除 GC 使用。
// 子类应覆写 gcMark，在其中递归标记自身持有的 AnyGC 子对象。
// ============================================================================

abstract class AnyGC {
  /// GC 标记位。每轮 GC 使用递增的 flag 值，被标记的对象 gcFlag == 当前 flag，
  /// 未被标记的对象 gcFlag < 当前 flag，即为垃圾。
  /// 使用公开字段以便跨 library 的 restored 代码子类可以访问。
  int gcFlag = 0;

  /// 标记当前对象为存活。子类覆写时应先调用 super，再递归标记子对象。
  /// [flag] 是本轮 GC 的标记值，避免每轮都要重置所有对象的 flag。
  void gcMark(int flag) {
    if (gcFlag == flag) return; // 已标记，防止循环引用无限递归
    gcFlag = flag;
  }
}

// ============================================================================
// GC — 全局标记-清除垃圾回收器
// ----------------------------------------------------------------------------
// 对象分配统一通过 GC.allocateLocal / GC.allocateGlobal 包装 new 表达式。
// 调用 GC.collect() 触发一轮标记-清除：
//   1. 标记阶段：从所有 root 对象出发，递归调用 gcMark(flag)
//   2. 清除阶段：移除未被标记的非 root 对象
// ============================================================================

class GC {
  static int _currentFlag = 0;

  /// 所有已注册的 GC 对象（包括 root 和非 root）
  static final List<AnyGC> _objects = [];

  /// 顶层对象（静态变量 / 全局变量），作为 GC root
  static final List<AnyGC> _roots = [];

  /// 用于去重注册的标识集合（使用 Expando 避免调用未初始化对象的 hashCode）
  static Expando<bool> _registered = Expando<bool>('gc_registered');

  static void _resetRegistered() {
    _registered = Expando<bool>('gc_registered');
  }

  /// 分配一个局部对象（非 root），注册到 GC 并返回该对象。
  /// 用于包装 new 表达式：`GC.allocateLocal(X_new(XValue(), args))`
  static T allocateLocal<T extends AnyGC>(T object) {
    if (_registered[object] == null) {
      _registered[object] = true;
      _objects.add(object);
    }
    return object;
  }

  /// 分配一个全局对象（root），注册到 GC 并标记为 root，返回该对象。
  /// 用于静态变量 / 全局变量：`GC.allocateGlobal(X_new(XValue(), args))`
  static T allocateGlobal<T extends AnyGC>(T object) {
    if (_registered[object] == null) {
      _registered[object] = true;
      _objects.add(object);
    }
    if (!_roots.contains(object)) {
      _roots.add(object);
    }
    return object;
  }

  /// 从 root 集合中移除
  static void removeRoot(AnyGC object) {
    _roots.remove(object);
  }

  /// 执行一轮标记-清除 GC，返回被回收的对象数量
  static int collect() {
    _currentFlag++;
    final flag = _currentFlag;

    // 标记阶段：从每个 root 出发递归标记
    for (final root in _roots) {
      root.gcMark(flag);
    }

    // 清除阶段：移除未被标记的对象
    final beforeCount = _objects.length;
    _objects.removeWhere((obj) => obj.gcFlag != flag);
    // 重建 _registered（Expando 不支持 removeWhere，通过移除旧条目再重新添加实现）
    for (final obj in _objects) {
      _registered[obj] = true;
    }

    // 同步清理 roots 中已被回收的对象（理论上 root 总是被标记的，防御性清理）
    _roots.removeWhere((obj) => obj.gcFlag != flag);

    return beforeCount - _objects.length;
  }

  /// 获取当前管理的对象总数
  static int get objectCount => _objects.length;

  /// 获取当前 root 数量
  static int get rootCount => _roots.length;

  /// 重置 GC 状态（测试用）
  static void reset() {
    _objects.clear();
    _roots.clear();
    _resetRegistered();
    _currentFlag = 0;
  }
}

/// VPtr 基类 - 所有无基类（或继承自 Object）的 Value 类都继承自它。
/// 提供 vptr 抽象 getter 和 toString/operator==/hashCode 的桥接覆写。
///
/// 每个具体 Value 类通过静态 `_vptr` 字段实现 per-type 共享的 vptr，
/// 惰性初始化，所有实例共享同一份虚函数表。
///
/// 注：vptr 槽里存的函数现在统一是 TypeFunctionN 子类实例（由还原器生成的
/// 各种 _Closure_ / _TearOff_ 类）。这里用对应 arity 的 TypeFunctionN 做
/// cast，避免出现 `Function` 字面量。
abstract class VPtr extends AnyGC {
  /// 子类必须实现此 getter，返回 per-type 共享的静态 vptr。
  Map<String, dynamic> get vptr;

  VPtr();

  @override
  String toString() {
    final fn = vptr['toString'];
    if (fn != null) return (fn as Function)(this) as String;
    return super.toString();
  }
  @override
  bool operator ==(Object other) {
    final fn = vptr['operatorEq'];
    if (fn != null) {
      return (fn as Function)(this, other) as bool;
    }
    return identical(this, other);
  }
  @override
  int get hashCode {
    final fn = vptr['get_hashCode'];
    if (fn != null) return (fn as Function)(this) as int;
    return super.hashCode;
  }
}

/// Box 类型定义（闭包引用语义）
/// 用于在闭包中捕获可变的值类型变量。
/// 所有 Box 继承 AnyGC 以参与 GC 管理，构造时自动注册到 GC。

class IntBox extends AnyGC {
  int value;
  IntBox(this.value) {
    GC.allocateLocal(this);
  }
}

class DoubleBox extends AnyGC {
  double value;
  DoubleBox(this.value) {
    GC.allocateLocal(this);
  }
}

class StringBox extends AnyGC {
  String value;
  StringBox(this.value) {
    GC.allocateLocal(this);
  }
}

class BoolBox extends AnyGC {
  bool value;
  BoolBox(this.value) {
    GC.allocateLocal(this);
  }
}

class ObjectBox<T> extends AnyGC {
  T value;
  ObjectBox(this.value) {
    GC.allocateLocal(this);
  }

  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
    // 如果持有的值是 AnyGC 类型，递归标记
    final v = value;
    if (v is AnyGC) {
      v.gcMark(flag);
    }
  }
}

// ============================================================================
// 静态集合类 — 不继承原生 List/Map/Set，基于 Array 统一管理内部存储
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

/// StaticMap<K, V> — implements Map<K,V>，内部基于 Array 独立管理键值对。
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
// 状态机协程基础类 — 替代 async/await
// ============================================================================

enum PromiseState { ready, pending, completed, error }

/// Promise — 统一的异步结果容器，同时也是调度的基本单元
///
/// 职责：
/// - 持有状态（ready/pending/completed/error）和结果
/// - 持有 _onTick 回调，由 GlobalScheduler 每 tick 驱动推进
/// - 提供 complete/completeError 操作
/// - 提供工厂方法（value/delayed）和链式调用（then）
class Promise<T> extends AnyGC {
  PromiseState state = PromiseState.pending;
  T? _result;
  Object? error;
  void Function()? _startCallback;

  /// 每 tick 被 GlobalScheduler 调用来推进此 Promise 的逻辑。
  /// 返回 true 表示已完成，应从活跃列表移除。
  bool Function()? _onTick;

  bool get isCompleted => state == PromiseState.completed;
  bool get isError => state == PromiseState.error;
  bool get isPending => state == PromiseState.pending;
  bool get isReady => state == PromiseState.ready;

  /// gcMark — 递归标记所有 GC 子对象
  /// 标记 _result、error，以及 _onTick/_startCallback（restorer 生成的闭包
  /// 是 TypeFunctionN 子类，继承 AnyGC）。
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
    if (_result is AnyGC) (_result as AnyGC).gcMark(flag);
    if (error is AnyGC) (error as AnyGC).gcMark(flag);
    // 闭包字段：restorer 生成的闭包是 TypeFunctionN（extends AnyGC），
    // 原生 Dart 函数（void Function()）不是 AnyGC，is 检查自动跳过。
    if (_onTick is AnyGC) (_onTick as AnyGC).gcMark(flag);
    if (_startCallback is AnyGC) (_startCallback as AnyGC).gcMark(flag);
  }

  T get result {
    if (state == PromiseState.error) throw error!;
    if (state != PromiseState.completed) {
      throw DartStateError('Promise not yet completed');
    }
    return _result as T;
  }

  /// 设置 tick 回调并注册到 Scheduler 活跃列表。
  /// 每 tick 被 GlobalScheduler 调用，返回 true 表示已完成。
  /// 供 AsyncStateMachine 和外部测试使用。
  void setTickCallback(bool Function() onTick) {
    _onTick = onTick;
    GC.allocateLocal(this);
    GlobalScheduler.instance.registerActivePromise(this);
  }

  /// 设置启动回调并将状态切换为 ready。
  /// GlobalScheduler 在下一轮 tick 时会统一触发所有 ready 状态的 Promise，
  /// 调用其 _startCallback 并将状态改为 pending。
  void setStartCallback(void Function() callback) {
    _startCallback = callback;
    GC.allocateLocal(this);
    state = PromiseState.ready;
    GlobalScheduler.instance.registerReadyPromise(this);
  }

  /// 由 GlobalScheduler 调用：触发启动回调，状态 ready → pending
  void _fireStartCallback() {
    if (state != PromiseState.ready || _startCallback == null) return;
    state = PromiseState.pending;
    _startCallback!();
    _startCallback = null;
  }

  void complete(T value) {
    if (state == PromiseState.completed || state == PromiseState.error) {
      throw DartStateError('Promise already resolved');
    }
    _result = value;
    state = PromiseState.completed;
  }

  void completeError(Object err) {
    if (state == PromiseState.completed || state == PromiseState.error) {
      throw DartStateError('Promise already resolved');
    }
    error = err;
    state = PromiseState.error;
  }

  static Promise<T> value<T>(T val) {
    final promise = Promise<T>();
    promise.complete(val);
    return promise;
  }

  static Promise<T> rejected<T>(Object err) {
    final promise = Promise<T>();
    promise.completeError(err);
    return promise;
  }

  static Promise<T> delayed<T>(int delayTicks, T Function() computation) {
    final promise = GC.allocateLocal(Promise<T>());
    GlobalScheduler.instance.registerDelayedTask(delayTicks, () {
      try {
        promise.complete(computation());
      } catch (e) {
        promise.completeError(e);
      }
    }, promise);
    return promise;
  }

  /// 链式调用：当本 Promise 完成时，执行 onValue 并将结果传递给新 Promise。
  /// 支持 flatMap 语义：若 onValue 返回 Promise<R>，自动展平为 Promise<R>。
  Promise<R> then<R>(dynamic Function(T) onValue) {
    final nextPromise = GC.allocateLocal(Promise<R>());
    nextPromise._onTick = () {
      if (isCompleted) {
        try {
          final dynamic callbackResult = onValue(result);
          if (callbackResult is Promise<R>) {
            // flatMap: 等待内层 Promise 完成后传递
            nextPromise._onTick = () {
              if (callbackResult.isCompleted) {
                nextPromise.complete(callbackResult.result);
                return true;
              }
              if (callbackResult.isError) {
                nextPromise.completeError(callbackResult.error!);
                return true;
              }
              return false;
            };
            return false; // 保持活跃，等内层完成
          }
          nextPromise.complete(callbackResult as R);
        } catch (e) {
          nextPromise.completeError(e);
        }
        return true;
      }
      if (isError) {
        nextPromise.completeError(error!);
        return true;
      }
      return false;
    };
    GlobalScheduler.instance.registerActivePromise(nextPromise);
    return nextPromise;
  }

  /// 错误处理链：当本 Promise 出错时，执行 onError 恢复
  Promise<T> catchError(T Function(Object) onError) {
    final nextPromise = GC.allocateLocal(Promise<T>());
    nextPromise._onTick = () {
      if (isCompleted) {
        nextPromise.complete(result);
        return true;
      }
      if (isError) {
        try {
          nextPromise.complete(onError(error!));
        } catch (e) {
          nextPromise.completeError(e);
        }
        return true;
      }
      return false;
    };
    GlobalScheduler.instance.registerActivePromise(nextPromise);
    return nextPromise;
  }

  /// 无论成功失败都执行 action，然后传递原始结果/错误
  Promise<T> whenComplete(void Function() action) {
    final nextPromise = GC.allocateLocal(Promise<T>());
    nextPromise._onTick = () {
      if (isCompleted) {
        try {
          action();
          nextPromise.complete(result);
        } catch (e) {
          nextPromise.completeError(e);
        }
        return true;
      }
      if (isError) {
        try {
          action();
        } catch (_) {}
        nextPromise.completeError(error!);
        return true;
      }
      return false;
    };
    GlobalScheduler.instance.registerActivePromise(nextPromise);
    return nextPromise;
  }
}

/// 全局调度器 — 统一通过 Promise 驱动所有异步任务
///
/// 继承 AnyGC 并注册为 GC root，确保 Scheduler 持有的所有 Promise
/// 和延迟任务闭包在标记阶段可达。在 C++ 环境中这是防止悬挂指针的关键。
class GlobalScheduler extends AnyGC {
  static final GlobalScheduler instance = GlobalScheduler._();

  GlobalScheduler._() {
    // 将 Scheduler 自身注册为 GC root，确保标记阶段可达所有异步对象
    GC.allocateGlobal(this);
  }

  final List<Promise> _activePromises = [];
  final List<_DelayedTask> _delayedTasks = [];
  final List<Promise> _readyPromises = [];
  int _currentTick = 0;

  int get currentTick => _currentTick;

  /// gcMark — 从 Scheduler root 出发，递归标记所有持有的 Promise
  /// 和延迟任务闭包。这是 C++ 环境防止悬挂指针的关键。
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
    for (final p in _activePromises) {
      p.gcMark(flag);
    }
    for (final p in _readyPromises) {
      p.gcMark(flag);
    }
    for (final t in _delayedTasks) {
      // 标记延迟任务关联的 Promise（通过 targetPromise 字段）
      if (t.targetPromise != null) t.targetPromise!.gcMark(flag);
      // 回调闭包：restorer 生成的闭包是 TypeFunctionN（extends AnyGC）
      if (t.callback is AnyGC) (t.callback as AnyGC).gcMark(flag);
    }
  }

  /// 注册一个有 _onTick 的活跃 Promise，每 tick 被驱动
  void registerActivePromise(Promise promise) {
    _activePromises.add(promise);
  }

  void registerDelayedTask(int delayTicks, void Function() callback,
      [Promise? targetPromise]) {
    _delayedTasks.add(_DelayedTask(_currentTick + delayTicks, callback, targetPromise));
  }

  /// 注册一个 ready 状态的 Promise，等待下一轮 tick 触发其启动回调
  void registerReadyPromise(Promise promise) {
    _readyPromises.add(promise);
  }

  void tick() {
    _currentTick++;

    // 第一阶段：触发所有 ready 状态的 Promise 的启动回调
    final readySnapshot = List.of(_readyPromises);
    _readyPromises.clear();
    for (final promise in readySnapshot) {
      if (promise.isReady) {
        promise._fireStartCallback();
      }
    }

    // 第二阶段：触发到期的延迟任务
    final expired = _delayedTasks.where((t) => t.targetTick <= _currentTick).toList();
    _delayedTasks.removeWhere((t) => t.targetTick <= _currentTick);
    for (final task in expired) {
      task.callback();
    }

    // 第三阶段：驱动所有活跃 Promise
    final snapshot = List.of(_activePromises);
    final finished = <Promise>{};
    for (final promise in snapshot) {
      if (promise.isCompleted || promise.isError) {
        finished.add(promise);
        continue;
      }
      final onTick = promise._onTick;
      if (onTick != null && onTick()) {
        finished.add(promise);
      }
    }
    _activePromises.removeWhere((p) => finished.contains(p));
  }

  void reset() {
    _activePromises.clear();
    _delayedTasks.clear();
    _readyPromises.clear();
    _currentTick = 0;
    // 重置 gcFlag，防止与下一轮 GC flag 值冲突
    gcFlag = 0;
    // 重新注册为 GC root（GC.reset() 会清除所有 root）
    GC.allocateGlobal(this);
  }

  /// 检查是否有活跃的异步工作（Promise、延迟任务等）
  bool hasActiveWork() {
    return _activePromises.isNotEmpty ||
        _delayedTasks.isNotEmpty ||
        _readyPromises.isNotEmpty;
  }
}

class _DelayedTask {
  final int targetTick;
  final void Function() callback;
  /// 延迟任务关联的 Promise（用于 GC 标记，可为 null）
  final Promise? targetPromise;
  _DelayedTask(this.targetTick, this.callback, [this.targetPromise]);
}

/// promiseDelayed — 兼容 Future.delayed(Duration, [computation]) 的异步延迟函数
/// StaticDuration 按 10ms = 1 tick 映射，最小 1 tick。
Promise<T> promiseDelayed<T>(StaticDuration duration, [T Function()? computation]) {
  final ticks = (duration.inMilliseconds / 10).ceil().clamp(1, 100000);
  final promise = GC.allocateLocal(Promise<T>());
  GlobalScheduler.instance.registerDelayedTask(ticks, () {
    try {
      if (computation != null) {
        promise.complete(computation());
      } else {
        promise.complete(null as T);
      }
    } catch (e) {
      promise.completeError(e);
    }
  }, promise);
  return promise;
}

/// smAwait 递归深度计数器（防止 ClosureEnv 模式下深层递归栈溢出）
int _smAwaitDepth = 0;
const int _smAwaitMaxDepth = 500;

/// smAwait — 状态机版 await，循环调 tick() 直到 promise 完成。
/// 也兼容原生 Future（如 async* Stream.toList() 返回的 Future），
/// 通过同步阻塞等待完成。
///
/// 注意：smAwait 内部递归调用 tick()，tick() 可能触发 _startCallback，
/// _startCallback 内部可能再次调用 smAwait，形成栈上递归。
/// 通过 _smAwaitDepth 限制递归深度，防止栈溢出。
T smAwait<T>(dynamic promiseOrFuture) {
  _smAwaitDepth++;
  if (_smAwaitDepth > _smAwaitMaxDepth) {
    _smAwaitDepth--;
    throw DartStateError(
      'smAwait recursion depth exceeded $_smAwaitMaxDepth — '
      'consider using AsyncStateMachine for deep async nesting');
  }
  try {
    return _smAwaitImpl<T>(promiseOrFuture);
  } finally {
    _smAwaitDepth--;
  }
}

T _smAwaitImpl<T>(dynamic promiseOrFuture) {
  if (promiseOrFuture is Promise<T>) {
    int roundCount = 0;
    while (!promiseOrFuture.isCompleted && !promiseOrFuture.isError) {
      GlobalScheduler.instance.tick();
      roundCount++;
      if (roundCount > 100000) {
        throw DartStateError('smAwait exceeded max rounds — possible deadlock');
      }
    }
    if (promiseOrFuture.isError) throw promiseOrFuture.error!;
    return promiseOrFuture.result;
  }
  // 兼容原生 Future（如 async* Stream.toList() 产生的 Future）
  if (promiseOrFuture is Future<T>) {
    T? result;
    Object? error;
    bool done = false;
    promiseOrFuture.then((v) {
      result = v;
      done = true;
    }, onError: (e) {
      error = e;
      done = true;
    });
    int roundCount = 0;
    while (!done) {
      GlobalScheduler.instance.tick();
      roundCount++;
      if (roundCount > 100000) {
        throw DartStateError('smAwait(Future) exceeded max rounds — possible deadlock');
      }
    }
    if (error != null) throw error!;
    return result as T;
  }
  // 如果是 Promise 但泛型不完全匹配（如 Promise<dynamic>）
  if (promiseOrFuture is Promise) {
    int roundCount = 0;
    while (!promiseOrFuture.isCompleted && !promiseOrFuture.isError) {
      GlobalScheduler.instance.tick();
      roundCount++;
      if (roundCount > 100000) {
        throw DartStateError('smAwait exceeded max rounds — possible deadlock');
      }
    }
    if (promiseOrFuture.isError) throw promiseOrFuture.error!;
    return promiseOrFuture.result as T;
  }
  // Dart 语义：await 非 Future/Promise 值 → 自动包装为已完成的 Future 并返回
  // 例如: await 42 等价于 await Future.value(42)
  return promiseOrFuture as T;
}

/// drainScheduler — 运行调度器直到所有 Promise 和原生 Future 完成
/// 模拟 Dart 事件循环在 main() 返回后的行为：继续处理异步任务直到队列为空
///
/// 用法：在 main() 函数末尾调用，确保所有异步操作完成
/// 示例：
/// ```dart
/// void main() {
///   asyncInt().then(print);
///   drainScheduler(); // 等待所有 Promise 完成
/// }
/// ```
///
/// 此函数交替处理两种异步系统：
/// 1. 原生 Dart Future（如 async* 返回的 Future）- 优先处理
/// 2. 自定义 Promise 系统（由 GlobalScheduler 管理）
///
/// 通过多次 `await Future<void>.microtask(() {})` 让出控制权，
/// 让原生 Future 有足够时间完成（模拟真实事件循环行为），
/// 然后继续处理自定义 Promise。
Future<void> drainScheduler() async {
  int roundCount = 0;
  while (true) {
    // 先让出控制权多次，让原生 Future（如 async*）有机会完成
    // async* 生成器需要多次事件循环迭代来 yield 值
    for (int i = 0; i < 10; i++) {
      await Future<void>.microtask(() {});
    }

    // 处理所有自定义 Promise
    while (GlobalScheduler.instance.hasActiveWork()) {
      GlobalScheduler.instance.tick();
      roundCount++;
      if (roundCount > 1000000) {
        throw DartStateError('drainScheduler exceeded max rounds — possible deadlock');
      }
    }

    // 再次让出控制权，处理在 tick() 期间产生的新原生 Future
    for (int i = 0; i < 10; i++) {
      await Future<void>.microtask(() {});
    }

    // 检查是否还有自定义 Promise 需要处理
    // 如果没有，说明所有异步工作都已完成
    if (!GlobalScheduler.instance.hasActiveWork()) {
      break;
    }
  }
}

/// AsyncStateMachine — 异步函数转状态机的基类
///
/// 通过 Promise._onTick 驱动，不再依赖独立的 _stateMachines 列表。
abstract class AsyncStateMachine<T> extends AnyGC {
  int smState = 0;
  final Promise<T> promise = Promise<T>();

  /// 子类实现：推进状态机一步。返回 true 表示已完成。
  bool step();

  void completeWith(T value) { promise.complete(value); }
  void completeWithError(Object error) { promise.completeError(error); }

  /// gcMark — 标记内部 promise，确保从 ASM root 可达
  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
    promise.gcMark(flag);
  }

  Promise<T> start() {
    promise._onTick = step;
    GlobalScheduler.instance.registerActivePromise(promise);
    return promise;
  }
}

// ============================================================================
// 语义脱钩包装类型 — 让生成代码不直接出现裸 dart:core 标识符
// ============================================================================

// ---- IO ----

/// staticPrint — 替代裸 print，便于 C++ 落地时统一替换
void staticPrint(Object? object) => print(object);

/// dart_str_toStringAsFixed — 将 double.toStringAsFixed 静态化
///
/// 用法: `dart_str_toStringAsFixed(value, digits)`
/// 等价于: `value.toStringAsFixed(digits)`
String dart_str_toStringAsFixed(dynamic value, int digits) {
  if (value is double) return value.toStringAsFixed(digits);
  return value.toString();
}

// ---- StringBuffer ----

/// StaticStringBuffer — 委托 StringBuffer
class StaticStringBuffer {
  final StringBuffer _delegate;

  StaticStringBuffer([Object content = '']) : _delegate = StringBuffer(content);

  void write(Object? obj) => _delegate.write(obj);
  void writeln([Object? obj = '']) => _delegate.writeln(obj);
  void writeAll(Iterable objects, [String separator = '']) =>
      _delegate.writeAll(objects, separator);
  void writeCharCode(int charCode) => _delegate.writeCharCode(charCode);

  int get length => _delegate.length;
  bool get isEmpty => _delegate.isEmpty;
  bool get isNotEmpty => _delegate.isNotEmpty;
  void clear() => _delegate.clear();

  @override
  String toString() => _delegate.toString();
}

// ---- MapEntry ----

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

// ---- Iterator ----

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

// ---- 异常体系 ----

/// DartException — 替代裸 Exception
class DartException implements Exception {
  final String? message;
  DartException([this.message]);

  @override
  String toString() => message ?? 'DartException';
}

/// DartStateError — 替代裸 StateError
class DartStateError extends StateError {
  DartStateError(String message) : super(message);
}

/// DartArgumentError — 替代裸 ArgumentError
class DartArgumentError extends ArgumentError {
  DartArgumentError([dynamic message]) : super(message);
}

/// DartRangeError — 替代裸 RangeError
class DartRangeError extends RangeError {
  DartRangeError([dynamic message]) : super(message);

  /// 替代 RangeError.range
  DartRangeError.range(int invalidValue, int minValue, int maxValue,
      [String? name, String? message])
      : super.range(invalidValue, minValue, maxValue, name, message);

  /// 替代 RangeError.value
  DartRangeError.value(num value, [String? name, String? message])
      : super.value(value, name, message);
}

/// 替代 RangeError.index（工厂构造函数，不能用 super.index）
DartRangeError dartRangeErrorIndex(int index, dynamic indexable,
    [String? name, String? message, int? length]) {
  // 触发原生检查逻辑后包装
  try {
    throw RangeError.index(index, indexable, name, message, length);
  } on RangeError catch (e) {
    final wrapped = DartRangeError(e.message);
    return wrapped;
  }
}

/// DartFormatException — 替代裸 FormatException
class DartFormatException extends FormatException {
  const DartFormatException([String message = '', dynamic source, int? offset])
      : super(message, source, offset);
}

/// DartUnsupportedError — 替代裸 UnsupportedError
class DartUnsupportedError extends UnsupportedError {
  DartUnsupportedError([String? message]) : super(message ?? '');
}

/// DartUnimplementedError — 替代裸 UnimplementedError
class DartUnimplementedError extends UnimplementedError {
  DartUnimplementedError([String? message]) : super(message);
}

// ---- RegExp ----

/// StaticRegExp — 委托 RegExp，实现 Pattern 以兼容 String.replaceAll 等
class StaticRegExp implements Pattern {
  final RegExp _delegate;

  StaticRegExp(String source,
      {bool multiLine = false,
      bool caseSensitive = true,
      bool unicode = false,
      bool dotAll = false})
      : _delegate = RegExp(source,
            multiLine: multiLine,
            caseSensitive: caseSensitive,
            unicode: unicode,
            dotAll: dotAll);

  bool hasMatch(String input) => _delegate.hasMatch(input);
  RegExpMatch? firstMatch(String input) => _delegate.firstMatch(input);
  @override
  Iterable<RegExpMatch> allMatches(String string, [int start = 0]) =>
      _delegate.allMatches(string, start);

  @override
  Match? matchAsPrefix(String string, [int start = 0]) =>
      _delegate.matchAsPrefix(string, start);
  String get pattern => _delegate.pattern;
  bool get isMultiLine => _delegate.isMultiLine;
  bool get isCaseSensitive => _delegate.isCaseSensitive;
  bool get isUnicode => _delegate.isUnicode;
  bool get isDotAll => _delegate.isDotAll;

  /// 委托 RegExp.escape 静态方法
  static String escape(String text) => RegExp.escape(text);

  @override
  String toString() => _delegate.toString();
}

// ---- Duration ----

/// StaticDuration — 委托 Duration
class StaticDuration {
  final Duration _delegate;

  StaticDuration(
      {int days = 0,
      int hours = 0,
      int minutes = 0,
      int seconds = 0,
      int milliseconds = 0,
      int microseconds = 0})
      : _delegate = Duration(
            days: days,
            hours: hours,
            minutes: minutes,
            seconds: seconds,
            milliseconds: milliseconds,
            microseconds: microseconds);

  StaticDuration._(this._delegate);

  int get inDays => _delegate.inDays;
  int get inHours => _delegate.inHours;
  int get inMinutes => _delegate.inMinutes;
  int get inSeconds => _delegate.inSeconds;
  int get inMilliseconds => _delegate.inMilliseconds;
  int get inMicroseconds => _delegate.inMicroseconds;

  Duration toDuration() => _delegate;

  @override
  String toString() => _delegate.toString();

  @override
  bool operator ==(Object other) =>
      other is StaticDuration && other._delegate == _delegate;

  @override
  int get hashCode => _delegate.hashCode;
}

// ---- DateTime ----

/// StaticDateTime — 委托 DateTime
class StaticDateTime {
  final DateTime _delegate;

  StaticDateTime(int year,
      [int month = 1,
      int day = 1,
      int hour = 0,
      int minute = 0,
      int second = 0,
      int millisecond = 0,
      int microsecond = 0])
      : _delegate = DateTime(
            year, month, day, hour, minute, second, millisecond, microsecond);

  StaticDateTime._(this._delegate);

  factory StaticDateTime.now() => StaticDateTime._(DateTime.now());
  factory StaticDateTime.utc(int year,
          [int month = 1,
          int day = 1,
          int hour = 0,
          int minute = 0,
          int second = 0,
          int millisecond = 0,
          int microsecond = 0]) =>
      StaticDateTime._(DateTime.utc(
          year, month, day, hour, minute, second, millisecond, microsecond));
  factory StaticDateTime.parse(String formattedString) =>
      StaticDateTime._(DateTime.parse(formattedString));
  factory StaticDateTime.tryParse(String formattedString) {
    final dt = DateTime.tryParse(formattedString);
    if (dt == null) throw DartFormatException('Invalid date format: $formattedString');
    return StaticDateTime._(dt);
  }
  factory StaticDateTime.fromMillisecondsSinceEpoch(int millisecondsSinceEpoch,
          {bool isUtc = false}) =>
      StaticDateTime._(DateTime.fromMillisecondsSinceEpoch(
          millisecondsSinceEpoch,
          isUtc: isUtc));
  factory StaticDateTime.fromMicrosecondsSinceEpoch(int microsecondsSinceEpoch,
          {bool isUtc = false}) =>
      StaticDateTime._(DateTime.fromMicrosecondsSinceEpoch(
          microsecondsSinceEpoch,
          isUtc: isUtc));

  int get year => _delegate.year;
  int get month => _delegate.month;
  int get day => _delegate.day;
  int get hour => _delegate.hour;
  int get minute => _delegate.minute;
  int get second => _delegate.second;
  int get millisecond => _delegate.millisecond;
  int get microsecond => _delegate.microsecond;
  int get weekday => _delegate.weekday;
  int get millisecondsSinceEpoch => _delegate.millisecondsSinceEpoch;
  int get microsecondsSinceEpoch => _delegate.microsecondsSinceEpoch;
  bool get isUtc => _delegate.isUtc;

  StaticDateTime add(StaticDuration duration) =>
      StaticDateTime._(_delegate.add(duration.toDuration()));
  StaticDateTime subtract(StaticDuration duration) =>
      StaticDateTime._(_delegate.subtract(duration.toDuration()));
  StaticDuration difference(StaticDateTime other) =>
      StaticDuration._(_delegate.difference(other._delegate));
  bool isBefore(StaticDateTime other) => _delegate.isBefore(other._delegate);
  bool isAfter(StaticDateTime other) => _delegate.isAfter(other._delegate);
  bool isAtSameMomentAs(StaticDateTime other) =>
      _delegate.isAtSameMomentAs(other._delegate);
  String toIso8601String() => _delegate.toIso8601String();
  StaticDateTime toUtc() => StaticDateTime._(_delegate.toUtc());
  StaticDateTime toLocal() => StaticDateTime._(_delegate.toLocal());

  DateTime toDateTime() => _delegate;

  @override
  String toString() => _delegate.toString();

  @override
  bool operator ==(Object other) =>
      other is StaticDateTime && other._delegate == _delegate;

  @override
  int get hashCode => _delegate.hashCode;
}

// ---- Comparable ----

/// StaticComparable<T> — 替代裸 Comparable<T>
abstract class StaticComparable<T> {
  int compareTo(T other);
}

/// ReachabilityError — 用于 switch 表达式穷尽性检查的运行时错误
class ReachabilityError extends Error {
  final String message;
  ReachabilityError([this.message = '']);
  @override
  String toString() => 'ReachabilityError: $message';
}
