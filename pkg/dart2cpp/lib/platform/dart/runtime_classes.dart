/// Dart2Cpp restorer 运行时基础类定义
///
/// 包含 AnyGC 基类（GC 管理 + 虚函数表桥接）、TypeFunction 函数值基类族、Box 类型（闭包引用语义）。
/// 由 dart_restorer 生成的还原代码通过 import 引入本文件。

import 'dart:collection' show IterableMixin;

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
}

abstract class TypeFunction0<R> extends TypeFunction {
  TypeFunction0();
  late R Function(AnyGC) fnPtr;
  R call();
}

abstract class TypeFunction1<R, T1> extends TypeFunction {
  TypeFunction1();
  late R Function(AnyGC, T1) fnPtr;
  R call(T1 a1);
}

abstract class TypeFunction2<R, T1, T2> extends TypeFunction {
  TypeFunction2();
  late R Function(AnyGC, T1, T2) fnPtr;
  R call(T1 a1, T2 a2);
}

abstract class TypeFunction3<R, T1, T2, T3> extends TypeFunction {
  TypeFunction3();
  late R Function(AnyGC, T1, T2, T3) fnPtr;
  R call(T1 a1, T2 a2, T3 a3);
}

abstract class TypeFunction4<R, T1, T2, T3, T4> extends TypeFunction {
  TypeFunction4();
  late R Function(AnyGC, T1, T2, T3, T4) fnPtr;
  R call(T1 a1, T2 a2, T3 a3, T4 a4);
}

abstract class TypeFunction5<R, T1, T2, T3, T4, T5> extends TypeFunction {
  TypeFunction5();
  late R Function(AnyGC, T1, T2, T3, T4, T5) fnPtr;
  R call(T1 a1, T2 a2, T3 a3, T4 a4, T5 a5);
}

abstract class TypeFunction6<R, T1, T2, T3, T4, T5, T6> extends TypeFunction {
  TypeFunction6();
  late R Function(AnyGC, T1, T2, T3, T4, T5, T6) fnPtr;
  R call(T1 a1, T2 a2, T3 a3, T4 a4, T5 a5, T6 a6);
}

abstract class TypeFunction7<R, T1, T2, T3, T4, T5, T6, T7> extends TypeFunction {
  TypeFunction7();
  late R Function(AnyGC, T1, T2, T3, T4, T5, T6, T7) fnPtr;
  R call(T1 a1, T2 a2, T3 a3, T4 a4, T5 a5, T6 a6, T7 a7);
}

abstract class TypeFunction8<R, T1, T2, T3, T4, T5, T6, T7, T8> extends TypeFunction {
  TypeFunction8();
  late R Function(AnyGC, T1, T2, T3, T4, T5, T6, T7, T8) fnPtr;
  R call(T1 a1, T2 a2, T3 a3, T4 a4, T5 a5, T6 a6, T7 a7, T8 a8);
}

abstract class TypeFunction9<R, T1, T2, T3, T4, T5, T6, T7, T8, T9>
    extends TypeFunction {
  TypeFunction9();
  late R Function(AnyGC, T1, T2, T3, T4, T5, T6, T7, T8, T9) fnPtr;
  R call(T1 a1, T2 a2, T3 a3, T4 a4, T5 a5, T6 a6, T7 a7, T8 a8, T9 a9);
}

abstract class TypeFunction10<R, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10>
    extends TypeFunction {
  TypeFunction10();
  late R Function(AnyGC, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10) fnPtr;
  R call(T1 a1, T2 a2, T3 a3, T4 a4, T5 a5, T6 a6, T7 a7, T8 a8, T9 a9, T10 a10);
}

abstract class TypeFunction11<R, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11>
    extends TypeFunction {
  TypeFunction11();
  late R Function(AnyGC, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11) fnPtr;
  R call(T1 a1, T2 a2, T3 a3, T4 a4, T5 a5, T6 a6, T7 a7, T8 a8, T9 a9, T10 a10,
      T11 a11);
}

abstract class TypeFunction12<R, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12>
    extends TypeFunction {
  TypeFunction12();
  late R Function(AnyGC, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12) fnPtr;
  R call(T1 a1, T2 a2, T3 a3, T4 a4, T5 a5, T6 a6, T7 a7, T8 a8, T9 a9, T10 a10,
      T11 a11, T12 a12);
}

abstract class TypeFunction13<R, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13>
    extends TypeFunction {
  TypeFunction13();
  late R Function(AnyGC, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13) fnPtr;
  R call(T1 a1, T2 a2, T3 a3, T4 a4, T5 a5, T6 a6, T7 a7, T8 a8, T9 a9, T10 a10,
      T11 a11, T12 a12, T13 a13);
}

abstract class TypeFunction14<R, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14>
    extends TypeFunction {
  TypeFunction14();
  late R Function(AnyGC, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14) fnPtr;
  R call(T1 a1, T2 a2, T3 a3, T4 a4, T5 a5, T6 a6, T7 a7, T8 a8, T9 a9, T10 a10,
      T11 a11, T12 a12, T13 a13, T14 a14);
}

abstract class TypeFunction15<R, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15>
    extends TypeFunction {
  TypeFunction15();
  late R Function(AnyGC, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15) fnPtr;
  R call(T1 a1, T2 a2, T3 a3, T4 a4, T5 a5, T6 a6, T7 a7, T8 a8, T9 a9, T10 a10,
      T11 a11, T12 a12, T13 a13, T14 a14, T15 a15);
}

abstract class TypeFunction16<R, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16>
    extends TypeFunction {
  TypeFunction16();
  late R Function(AnyGC, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16) fnPtr;
  R call(T1 a1, T2 a2, T3 a3, T4 a4, T5 a5, T6 a6, T7 a7, T8 a8, T9 a9, T10 a10,
      T11 a11, T12 a12, T13 a13, T14 a14, T15 a15, T16 a16);
}

// ============================================================================
// AnyGC 基类 — 所有需要 GC 管理的类型（Value 类 / Box）的公共基类
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

  /// 结构化虚表。Value 子类覆写此 getter，返回 per-type 共享的静态 ClassInfo
  ///（通过静态 `_classInfo` 字段惰性初始化，所有实例共享同一份虚函数表）。
  /// Box / TypeFunction 等非 Value 类型没有虚表，默认返回 null。
  ClassInfo? get classInfo => null;
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

/// ClassInfo 基类 — 结构化虚表（替代 Map-based vptr）
/// 每个属性都是真实函数类型，调用时无需 as 转换。
class ClassInfo {
  String Function(AnyGC)? toString_;
  bool Function(AnyGC, Object)? operatorEq;
  int Function(AnyGC)? get_hashCode;
  void Function(AnyGC, int)? gcMark;
  // 平台类/runtimeType 的返回类型不一（String/Type），用 Function? 保持兼容
  Function? get_runtimeType;
  // Common method fields (shared across multiple platform types)
  // 这些字段涉及集合元素或可被用户类重定义（如 double get length），
  // 统一用 Function? 避免签名不匹配
  Function? get_length;
  bool Function(AnyGC)? get_isEmpty;
  bool Function(AnyGC)? get_isNotEmpty;
  Function? get_iterator;
  Function? contains;
  Function? compareTo;
  Function? operatorIndex;
  Function? operatorIndexSet;
}

/// ClassInfo 全局缓存管理器。
///
/// Dart 的类静态变量不感知泛型，因此同一泛型类的不同实例化会共享同一个
/// static `_classInfo` 字段，导致不同真实类型共用一份 ClassInfo。
/// 本管理器以 [runtimeType] 为 key 缓存 ClassInfo，保证相同真实类型共享
/// 同一份虚表，不同真实类型各自拥有独立的 ClassInfo。
///
/// 用法：
/// ```dart
/// @override
/// ClassInfo get classInfo =>
///     ClassInfoRegistry.get<StaticListClassInfo>(runtimeType, StaticListClassInfo.new);
/// ```
class ClassInfoRegistry {
  static final Map<Type, ClassInfo> _cache = {};

  /// 获取指定 [type] 对应的 ClassInfo。
  /// [factory] 负责创建并初始化 ClassInfo；首次调用时执行，结果按 [type] 缓存。
  static T get<T extends ClassInfo>(Type type, T Function() factory) {
    final cached = _cache[type];
    if (cached != null) return cached as T;
    final created = factory();
    _cache[type] = created;
    return created;
  }

  /// 清空缓存（主要用于测试隔离）。
  static void clear() => _cache.clear();
}

/// Box 类型定义（闭包引用语义）
/// 用于在闭包中捕获可变的值类型变量。
/// 所有 Box 继承 AnyGC 以参与 GC 管理，构造时自动注册到 GC。

class IntBox extends AnyGC {
  int value;
  IntBox(this.value) {
    GC.allocateLocal(this);
  }
  @override
  String toString() => value.toString();
}

class DoubleBox extends AnyGC {
  double value;
  DoubleBox(this.value) {
    GC.allocateLocal(this);
  }
  @override
  String toString() => value.toString();
}

class StringBox extends AnyGC {
  String value;
  StringBox(this.value) {
    GC.allocateLocal(this);
  }
  @override
  String toString() => value;
}

class BoolBox extends AnyGC {
  bool value;
  BoolBox(this.value) {
    GC.allocateLocal(this);
  }
  @override
  String toString() => value.toString();
}

class ObjectBox<T> extends AnyGC {
  T value;
  ObjectBox(this.value) {
    GC.allocateLocal(this);
  }
  @override
  String toString() => value.toString();

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
// dynAs<T> — 类型安全转换：拆箱 + 向下转型
// ============================================================================

/// 将 AnyGC 对象转换为目标类型 T。
/// 自动处理基本类型的拆箱（IntBox → int 等）和 AnyGC 子类的向下转型。
///
/// 使用场景：
/// - 从 AnyGC 参数中提取基本类型值：`dynAs<int>(param)`
/// - 从 Box 中拆箱：`dynAs<String>(boxedStr)`
/// - AnyGC 子类转型：`dynAs<DogValue>(animal)`
T dynAs<T>(dynamic obj) {
  if (obj == null) return null as T;
  if (obj is T) return obj;
  // 拆箱：IntBox → int
  if (T == int && obj is IntBox) return obj.value as T;
  if (T == double && obj is DoubleBox) return obj.value as T;
  if (T == String && obj is StringBox) return obj.value as T;
  if (T == bool && obj is BoolBox) return obj.value as T;
  // 通用 ObjectBox 拆箱
  if (obj is ObjectBox) return obj.value as T;
  return obj as T;
}

// ============================================================================
// 静态集合类 — 不继承原生 List/Map/Set，基于 Array 统一管理内部存储
// ============================================================================

/// ArrayClassInfo — Array 的结构化虚表（对齐 C++ ArrayClassInfo）
class ArrayClassInfo extends ClassInfo {
  Function? add;
  Function? insert;
  Function? removeAt;
  Function? remove;
  Function? indexOf;
  Function? clear;

  ArrayClassInfo() {
    toString_ = Array_toString;
    gcMark = Array_gcMark;
    get_runtimeType = Array_get_runtimeType;
    get_length = Array_get_length;
    get_isEmpty = Array_get_isEmpty;
    get_isNotEmpty = Array_get_isNotEmpty;
    contains = Array_contains;
    operatorIndex = Array_operatorIndex;
    operatorIndexSet = Array_operatorIndexSet;
    add = Array_add;
    insert = Array_insert;
    removeAt = Array_removeAt;
    remove = Array_remove;
    indexOf = Array_indexOf;
    clear = Array_clear;
  }
}

// Top-level Array functions (lowered from instance methods)
String Array_toString(AnyGC self) {
  final s = (self as Array)._storage;
  return 'Array(${s.join(', ')})';
}
void Array_gcMark(AnyGC self, int flag) => (self as Array).gcMark(flag);
String Array_get_runtimeType(AnyGC self) => 'List';
int Array_get_length(AnyGC self) => (self as Array)._storage.length;
bool Array_get_isEmpty(AnyGC self) => (self as Array)._storage.isEmpty;
bool Array_get_isNotEmpty(AnyGC self) => (self as Array)._storage.isNotEmpty;
dynamic Array_operatorIndex(AnyGC self, dynamic index) =>
    (self as Array)._storage[index as int];
void Array_operatorIndexSet(AnyGC self, dynamic index, dynamic value) {
  (self as Array)._storage[index as int] = value;
}
bool Array_contains(AnyGC self, dynamic element) {
  try {
    return (self as Array)._storage.contains(element as dynamic);
  } catch (_) {
    return false;
  }
}
void Array_add(AnyGC self, dynamic element) {
  (self as Array)._storage.add(element as dynamic);
}
void Array_insert(AnyGC self, dynamic index, dynamic element) {
  (self as Array)._storage.insert(index as int, element as dynamic);
}
dynamic Array_removeAt(AnyGC self, dynamic index) {
  return (self as Array)._storage.removeAt(index as int);
}
bool Array_remove(AnyGC self, dynamic element) {
  return (self as Array)._storage.remove(element as dynamic);
}
int Array_indexOf(AnyGC self, dynamic element) {
  return (self as Array)._storage.indexOf(element as dynamic);
}
void Array_clear(AnyGC self) {
  (self as Array)._storage.clear();
}

/// 将 StaticList/StaticSet 转为 Iterable（它们不再 implements Iterable）
Iterable<dynamic> _toIterable(dynamic obj) {
  if (obj is StaticList) return obj._data._storage;
  if (obj is StaticSet) return obj._data._storage;
  return obj as Iterable;
}

/// Array<T> — 底层存储容器，所有静态集合类的基础。
/// 对齐 C++：纯数据结构 + ClassInfo 分派，仅保留 gcMark/operator[]/operator[]=
class Array<T> extends AnyGC {
  final List<T> _storage;

  Array(int size, {T? fill})
      : _storage = List<T>.filled(size, fill as T);

  Array.from(dynamic elements)
      : _storage = elements is StaticList
            ? List<T>.from((elements as StaticList)._data._storage)
            : List<T>.from(elements);

  Array.empty() : _storage = <T>[];

  @override
  ArrayClassInfo get classInfo =>
      ClassInfoRegistry.get<ArrayClassInfo>(runtimeType, ArrayClassInfo.new);

  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
    for (int i = 0; i < _storage.length; i++) {
      final element = _storage[i];
      if (element is AnyGC) (element as AnyGC).gcMark(flag);
    }
  }

  T operator [](int index) {
    if (index < 0 || index >= _storage.length) {
      throw DartRangeError('Index $index out of range [0..${_storage.length})');
    }
    return _storage[index];
  }

  void operator []=(int index, T value) {
    if (index < 0 || index >= _storage.length) {
      throw DartRangeError('Index $index out of range [0..${_storage.length})');
    }
    _storage[index] = value;
  }
}

/// StaticListClassInfo — StaticList 的结构化虚表
class StaticListClassInfo extends ClassInfo {
  StaticListClassInfo() {
    toString_ = StaticList_toString;
    gcMark = StaticList_gcMark;
    get_runtimeType = StaticList_get_runtimeType;
    get_length = StaticList_get_length;
    get_isEmpty = StaticList_get_isEmpty;
    get_isNotEmpty = StaticList_get_isNotEmpty;
    get_iterator = StaticList_get_iterator;
    contains = StaticList_contains;
    operatorIndex = StaticList_operatorIndex;
    operatorIndexSet = StaticList_operatorIndexSet;
    get_first = StaticList_get_first;
    get_last = StaticList_get_last;
    get_single = StaticList_get_single;
    get_reversed = StaticList_get_reversed;
    add = StaticList_add;
    addAll = StaticList_addAll;
    insert = StaticList_insert;
    insertAll = StaticList_insertAll;
    removeAt = StaticList_removeAt;
    remove = StaticList_remove;
    removeLast = StaticList_removeLast;
    removeWhere = StaticList_removeWhere;
    retainWhere = StaticList_retainWhere;
    clear = StaticList_clear;
    sort = StaticList_sort;
    indexOf = StaticList_indexOf;
    lastIndexOf = StaticList_lastIndexOf;
    indexWhere = StaticList_indexWhere;
    lastIndexWhere = StaticList_lastIndexWhere;
    removeRange = StaticList_removeRange;
    fillRange = StaticList_fillRange;
    getRange = StaticList_getRange;
    forEach = StaticList_forEach;
    where = StaticList_where;
    any = StaticList_any;
    every = StaticList_every;
    firstWhere = StaticList_firstWhere;
    lastWhere = StaticList_lastWhere;
    singleWhere = StaticList_singleWhere;
    reduce = StaticList_reduce;
    take = StaticList_take;
    skip = StaticList_skip;
    takeWhile = StaticList_takeWhile;
    skipWhile = StaticList_skipWhile;
    sublist = StaticList_sublist;
    join = StaticList_join;
    toList = StaticList_toList;
    toSet = StaticList_toSet;
    followedBy = StaticList_followedBy;
    asMap = StaticList_asMap;
    operatorPlus = StaticList_operatorPlus;
    elementAt = StaticList_elementAt;
    map = StaticList_map;
    expand = StaticList_expand;
    cast = StaticList_cast;
    fold = StaticList_fold;
    whereType = StaticList_whereType;
    set_length = StaticList_set_length;
  }

  Function? set_length;
  Function? get_first;
  Function? get_last;
  Function? get_single;
  Function? get_reversed;
  Function? add;
  Function? addAll;
  Function? insert;
  Function? insertAll;
  Function? removeAt;
  Function? remove;
  Function? removeLast;
  Function? removeWhere;
  Function? retainWhere;
  Function? clear;
  Function? sort;
  Function? indexOf;
  Function? lastIndexOf;
  Function? indexWhere;
  Function? lastIndexWhere;
  Function? removeRange;
  Function? fillRange;
  Function? getRange;
  Function? forEach;
  Function? where;
  Function? any;
  Function? every;
  Function? firstWhere;
  Function? lastWhere;
  Function? singleWhere;
  Function? reduce;
  Function? take;
  Function? skip;
  Function? takeWhile;
  Function? skipWhile;
  Function? sublist;
  Function? join;
  Function? toList;
  Function? toSet;
  Function? followedBy;
  Function? asMap;
  Function? operatorPlus;
  Function? elementAt;
  Function? map;
  Function? expand;
  Function? cast;
  Function? fold;
  Function? whereType;
}

// Top-level StaticList functions (lowered from instance methods)
String StaticList_toString(AnyGC self) {
  final d = (self as StaticList)._data;
  if (d._storage.length == 0) return '[]';
  final buf = StringBuffer('[');
  buf.write(d[0]);
  for (int i = 1; i < d._storage.length; i++) {
    buf.write(', ');
    buf.write(d[i]);
  }
  buf.write(']');
  return buf.toString();
}

String StaticList_get_runtimeType(AnyGC self) => 'List';
void StaticList_gcMark(AnyGC self, int flag) => (self as StaticList).gcMark(flag);
int StaticList_get_length(AnyGC self) => (self as StaticList)._data._storage.length;
bool StaticList_contains(AnyGC self, Object? element) {
  final d = (self as StaticList)._data;
  try {
    return d._storage.contains(element as dynamic);
  } catch (_) {
    return false;
  }
}

dynamic StaticList_operatorIndex(AnyGC self, dynamic index) => (self as StaticList)._data[index as int];
void StaticList_operatorIndexSet(AnyGC self, dynamic index, dynamic value) {
  (self as StaticList)._data[index as int] = value;
}

bool StaticList_get_isEmpty(AnyGC self) => (self as StaticList)._data._storage.length == 0;
bool StaticList_get_isNotEmpty(AnyGC self) => (self as StaticList)._data._storage.length > 0;
dynamic StaticList_get_first(AnyGC self) {
  final d = (self as StaticList)._data;
  if (d._storage.length == 0) throw DartStateError('No element');
  return d[0];
}

dynamic StaticList_get_last(AnyGC self) {
  final d = (self as StaticList)._data;
  if (d._storage.length == 0) throw DartStateError('No element');
  return d[d._storage.length - 1];
}

dynamic StaticList_get_single(AnyGC self) {
  final d = (self as StaticList)._data;
  if (d._storage.length != 1) throw DartStateError('Not single element');
  return d[0];
}

StaticList<T> StaticList_get_reversed<T>(AnyGC self) {
  final d = (self as StaticList<T>)._data;
  final result = StaticList<T>();
  for (int i = d._storage.length - 1; i >= 0; i--) result._data._storage.add(d[i]);
  return result;
}

dynamic StaticList_get_iterator(AnyGC self) => StaticIterator._fromArray((self as StaticList)._data);
void StaticList_add(AnyGC self, dynamic element) => (self as StaticList)._data._storage.add(element);
void StaticList_addAll(AnyGC self, dynamic other) {
  final d = (self as StaticList)._data;
  for (final element in _toIterable(other)) d._storage.add(element);
}

void StaticList_insert(AnyGC self, dynamic index, dynamic element) =>
    (self as StaticList)._data._storage.insert(index as int, element);
void StaticList_insertAll(AnyGC self, dynamic index, dynamic other) {
  int i = index as int;
  final d = (self as StaticList)._data;
  for (final e in _toIterable(other)) {
    d._storage.insert(i, e);
    i++;
  }
}

dynamic StaticList_removeAt(AnyGC self, dynamic index) => (self as StaticList)._data._storage.removeAt(index as int);
bool StaticList_remove(AnyGC self, dynamic element) {
  final d = (self as StaticList)._data;
  try {
    return d._storage.remove(element as dynamic);
  } catch (_) {
    return false;
  }
}

void StaticList_removeLast(AnyGC self) {
  final d = (self as StaticList)._data;
  if (d._storage.length == 0) throw DartRangeError('Cannot removeLast on empty list');
  d._storage.removeAt(d._storage.length - 1);
}

void StaticList_removeWhere(AnyGC self, dynamic test) {
  final d = (self as StaticList)._data;
  for (int i = d._storage.length - 1; i >= 0; i--) {
    if (test(d[i])) d._storage.removeAt(i);
  }
}

void StaticList_retainWhere(AnyGC self, dynamic test) {
  final d = (self as StaticList)._data;
  for (int i = d._storage.length - 1; i >= 0; i--) {
    if (!test(d[i])) d._storage.removeAt(i);
  }
}

void StaticList_clear(AnyGC self) => (self as StaticList)._data._storage.clear();
void StaticList_sort(AnyGC self, [dynamic compare]) {
  final d = (self as StaticList)._data;
  final list = d._storage.toList();
  if (compare != null && compare is! Function) {
    list.sort((a, b) => Function.apply(compare.call, [a, b]) as int);
  } else {
    list.sort(compare);
  }
  d._storage.clear();
  for (final e in list) d._storage.add(e);
}

int StaticList_indexOf(AnyGC self, dynamic element, [dynamic start]) {
  final d = (self as StaticList)._data;
  final s = start ?? 0;
  for (int i = s; i < d._storage.length; i++) {
    if (d[i] == element) return i;
  }
  return -1;
}

int StaticList_lastIndexOf(AnyGC self, dynamic element, [dynamic end]) {
  final d = (self as StaticList)._data;
  final endIdx = end ?? d._storage.length - 1;
  for (int i = endIdx; i >= 0; i--) {
    if (d[i] == element) return i;
  }
  return -1;
}

int StaticList_indexWhere(AnyGC self, dynamic test, [dynamic start]) {
  final d = (self as StaticList)._data;
  final s = start ?? 0;
  for (int i = s; i < d._storage.length; i++) {
    if (test(d[i])) return i;
  }
  return -1;
}

int StaticList_lastIndexWhere(AnyGC self, dynamic test, [dynamic start]) {
  final d = (self as StaticList)._data;
  final s = start ?? d._storage.length - 1;
  for (int i = s; i >= 0; i--) {
    if (test(d[i])) return i;
  }
  return -1;
}

void StaticList_removeRange(AnyGC self, dynamic start, dynamic end) {
  final d = (self as StaticList)._data;
  final s = start as int;
  final e = end as int;
  for (int i = e - 1; i >= s; i--) {
    d._storage.removeAt(i);
  }
}

void StaticList_fillRange(AnyGC self, dynamic start, dynamic end, [dynamic fillValue]) {
  final d = (self as StaticList)._data;
  final s = start as int;
  final e = end as int;
  for (int i = s; i < e; i++) {
    d[i] = fillValue;
  }
}

Iterable<T> StaticList_getRange<T>(AnyGC self, dynamic start, dynamic end) {
  final d = (self as StaticList<T>)._data;
  final s = start as int;
  final e = end as int;
  final result = StaticList<T>();
  for (int i = s; i < e; i++) result._data._storage.add(d[i]);
  return result;
}

void StaticList_forEach(AnyGC self, dynamic action) {
  final d = (self as StaticList)._data;
  for (int i = 0; i < d._storage.length; i++) action(d[i]);
}

StaticList<T> StaticList_where<T>(AnyGC self, dynamic test) {
  final d = (self as StaticList<T>)._data;
  final result = StaticList<T>();
  for (int i = 0; i < d._storage.length; i++) {
    if (test(d[i])) result._data._storage.add(d[i]);
  }
  return result;
}

bool StaticList_any(AnyGC self, dynamic test) {
  final d = (self as StaticList)._data;
  for (int i = 0; i < d._storage.length; i++) {
    if (test(d[i])) return true;
  }
  return false;
}

bool StaticList_every(AnyGC self, dynamic test) {
  final d = (self as StaticList)._data;
  for (int i = 0; i < d._storage.length; i++) {
    if (!test(d[i])) return false;
  }
  return true;
}

dynamic StaticList_firstWhere(AnyGC self, dynamic test, [dynamic orElse]) {
  final d = (self as StaticList)._data;
  for (int i = 0; i < d._storage.length; i++) {
    if (test(d[i])) return d[i];
  }
  if (orElse != null) return orElse();
  throw DartStateError('No element');
}

dynamic StaticList_lastWhere(AnyGC self, dynamic test, [dynamic orElse]) {
  final d = (self as StaticList)._data;
  for (int i = d._storage.length - 1; i >= 0; i--) {
    if (test(d[i])) return d[i];
  }
  if (orElse != null) return orElse();
  throw DartStateError('No element');
}

dynamic StaticList_singleWhere(AnyGC self, dynamic test, [dynamic orElse]) {
  final d = (self as StaticList)._data;
  dynamic found;
  bool foundMultiple = false;
  for (int i = 0; i < d._storage.length; i++) {
    if (test(d[i])) {
      if (found != null) {
        foundMultiple = true;
        break;
      }
      found = d[i];
    }
  }
  if (foundMultiple) throw DartStateError('Too many elements');
  if (found != null) return found;
  if (orElse != null) return orElse();
  throw DartStateError('No element');
}

dynamic StaticList_reduce(AnyGC self, dynamic combine) {
  final d = (self as StaticList)._data;
  if (d._storage.length == 0) throw DartStateError('No element');
  dynamic value = d[0];
  for (int i = 1; i < d._storage.length; i++) value = combine(value, d[i]);
  return value;
}

StaticList<T> StaticList_take<T>(AnyGC self, dynamic count) {
  final d = (self as StaticList<T>)._data;
  final result = StaticList<T>();
  final end = count < d._storage.length ? count : d._storage.length;
  for (int i = 0; i < end; i++) result._data._storage.add(d[i]);
  return result;
}

StaticList<T> StaticList_skip<T>(AnyGC self, dynamic count) {
  final d = (self as StaticList<T>)._data;
  final result = StaticList<T>();
  for (int i = count; i < d._storage.length; i++) result._data._storage.add(d[i]);
  return result;
}

StaticList<T> StaticList_takeWhile<T>(AnyGC self, dynamic test) {
  final d = (self as StaticList<T>)._data;
  final result = StaticList<T>();
  for (int i = 0; i < d._storage.length; i++) {
    if (!test(d[i])) break;
    result._data._storage.add(d[i]);
  }
  return result;
}

StaticList<T> StaticList_skipWhile<T>(AnyGC self, dynamic test) {
  final d = (self as StaticList<T>)._data;
  final result = StaticList<T>();
  bool skipping = true;
  for (int i = 0; i < d._storage.length; i++) {
    if (skipping && test(d[i])) continue;
    skipping = false;
    result._data._storage.add(d[i]);
  }
  return result;
}

StaticList<T> StaticList_sublist<T>(AnyGC self, dynamic start, [dynamic end]) {
  final d = (self as StaticList<T>)._data;
  final actualEnd = end ?? d._storage.length;
  final result = StaticList<T>();
  for (int i = start as int; i < actualEnd; i++) result._data._storage.add(d[i]);
  return result;
}

String StaticList_join(AnyGC self, [dynamic separator]) {
  final d = (self as StaticList)._data;
  if (d._storage.length == 0) return '';
  final buf = StringBuffer();
  buf.write(d[0]);
  for (int i = 1; i < d._storage.length; i++) {
    buf.write(separator ?? '');
    buf.write(d[i]);
  }
  return buf.toString();
}

StaticList<dynamic> StaticList_toList(AnyGC self) {
  final d = (self as StaticList)._data;
  final result = StaticList<dynamic>();
  for (int i = 0; i < d._storage.length; i++) result._data._storage.add(d[i]);
  return result;
}
dynamic StaticList_toSet(AnyGC self) => Set<dynamic>.of((self as StaticList)._data._storage);
StaticList<T> StaticList_followedBy<T>(AnyGC self, dynamic other) {
  final d = (self as StaticList<T>)._data;
  final result = StaticList<T>();
  for (int i = 0; i < d._storage.length; i++) result._data._storage.add(d[i]);
  for (final e in _toIterable(other)) result._data._storage.add(e);
  return result;
}

StaticMap<int, T> StaticList_asMap<T>(AnyGC self) {
  final d = (self as StaticList<T>)._data;
  final result = StaticMap<int, T>();
  for (int i = 0; i < d._storage.length; i++) StaticMap_operatorIndexSet(result, i, d[i]);
  return result;
}

StaticList<T> StaticList_operatorPlus<T>(AnyGC self, dynamic other) {
  final sl = self as StaticList<T>;
  final result = StaticList<T>();
  for (int i = 0; i < sl._data._storage.length; i++) result._data._storage.add(sl._data[i]);
  if (other is StaticList<T>) {
    for (int i = 0; i < other._data._storage.length; i++) result._data._storage.add(other._data[i]);
  } else if (other is Iterable) {
    for (final e in other) result._data._storage.add(e);
  }
  return result;
}

dynamic StaticList_elementAt(AnyGC self, dynamic index) =>
    (self as StaticList)._data[index as int];
StaticList<R> StaticList_map<R>(AnyGC self, dynamic convert) {
  final d = (self as StaticList)._data;
  final result = StaticList<R>();
  for (int i = 0; i < d._storage.length; i++) result._data._storage.add(convert(d[i]));
  return result;
}

StaticList<R> StaticList_expand<R>(AnyGC self, dynamic convert) {
  final d = (self as StaticList)._data;
  final result = StaticList<R>();
  for (int i = 0; i < d._storage.length; i++) {
    for (final r in _toIterable(convert(d[i]))) result._data._storage.add(r);
  }
  return result;
}

StaticList<R> StaticList_cast<R>(AnyGC self) {
  final d = (self as StaticList)._data;
  final result = StaticList<R>();
  for (int i = 0; i < d._storage.length; i++) result._data._storage.add(d[i] as R);
  return result;
}

dynamic StaticList_fold(AnyGC self, dynamic initial, dynamic combine) {
  final d = (self as StaticList)._data;
  dynamic value = initial;
  for (int i = 0; i < d._storage.length; i++) value = combine(value, d[i]);
  return value;
}

StaticList<R> StaticList_whereType<R>(AnyGC self) {
  final d = (self as StaticList)._data;
  final result = StaticList<R>();
  for (int i = 0; i < d._storage.length; i++) {
    if (d[i] is R) result._data._storage.add(d[i] as R);
  }
  return result;
}

void StaticList_set_length(AnyGC self, dynamic newLength) {
  final d = (self as StaticList)._data;
  if (newLength < d._storage.length) {
    while (d._storage.length > newLength) {
      d._storage.removeAt(d._storage.length - 1);
    }
  }
}

/// StaticList<T> — 完全独立的静态列表，不继承 List/ListMixin。
/// 内部基于 Array<T> 管理数据，所有方法自行实现。
/// 通过提供 `Iterator<T> get iterator` 支持 Dart for-in 循环。
class StaticList<T> extends AnyGC with IterableMixin<T> {
  final Array<T> _data;

  StaticList._internal(this._data);

  StaticList() : _data = Array<T>.empty();

  StaticList.of(dynamic elements) : _data = Array<T>.from(elements);

  StaticList.filled(int length, T fill) : _data = Array<T>(length, fill: fill);

  StaticList.unmodifiable(dynamic elements) : this.of(elements);

  StaticList.empty() : _data = Array<T>.empty();

  StaticList.generate(int length, T Function(int index) generator)
      : _data = Array<T>.empty() {
    for (int i = 0; i < length; i++) {
      _data._storage.add(generator(i));
    }
  }

  StaticList.from(dynamic elements) : _data = Array<T>.from(_toIterable(elements).cast<T>());

  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
    _data.gcMark(flag);
  }

  @override
  String toString() => StaticList_toString(this);

  @override
  Iterator<T> get iterator => _data._storage.iterator;

  @override
  StaticListClassInfo get classInfo =>
      ClassInfoRegistry.get<StaticListClassInfo>(runtimeType, StaticListClassInfo.new);
}

/// StaticMapClassInfo — StaticMap 的结构化虚表
class StaticMapClassInfo extends ClassInfo {
  StaticMapClassInfo() {
    toString_ = StaticMap_toString;
    gcMark = StaticMap_gcMark;
    get_runtimeType = StaticMap_get_runtimeType;
    get_length = StaticMap_get_length;
    get_isEmpty = StaticMap_get_isEmpty;
    get_isNotEmpty = StaticMap_get_isNotEmpty;
    operatorIndex = StaticMap_operatorIndex;
    operatorIndexSet = StaticMap_operatorIndexSet;
    get_keys = StaticMap_get_keys;
    get_values = StaticMap_get_values;
    get_entries = StaticMap_get_entries;
    containsKey = StaticMap_containsKey;
    containsValue = StaticMap_containsValue;
    remove = StaticMap_remove;
    removeWhere = StaticMap_removeWhere;
    clear = StaticMap_clear;
    forEach = StaticMap_forEach;
    putIfAbsent = StaticMap_putIfAbsent;
    update = StaticMap_update;
    updateAll = StaticMap_updateAll;
    addAll = StaticMap_addAll;
    addEntries = StaticMap_addEntries;
    map = StaticMap_map;
    cast = StaticMap_cast;
  }

  Function? get_keys;
  Function? get_values;
  Function? get_entries;
  Function? containsKey;
  Function? containsValue;
  Function? remove;
  Function? removeWhere;
  Function? clear;
  Function? forEach;
  Function? putIfAbsent;
  Function? update;
  Function? updateAll;
  Function? addAll;
  Function? addEntries;
  Function? map;
  Function? cast;
}

// Top-level StaticMap functions (lowered from instance methods)
String StaticMap_toString(AnyGC self) {
  final m = self as StaticMap;
  if (m._keys._storage.length == 0) return '{}';
  final buf = StringBuffer('{');
  for (int i = 0; i < m._keys._storage.length; i++) {
    if (i > 0) buf.write(', ');
    buf.write('${m._keys[i]}: ${m._values[i]}');
  }
  buf.write('}');
  return buf.toString();
}

String StaticMap_get_runtimeType(AnyGC self) => 'Map';
void StaticMap_gcMark(AnyGC self, int flag) => (self as StaticMap).gcMark(flag);
int StaticMap_get_length(AnyGC self) => (self as StaticMap)._keys._storage.length;
dynamic StaticMap_operatorIndex(AnyGC self, dynamic key) {
  final m = self as StaticMap;
  final idx = m._keys._storage.indexOf(key);
  if (idx == -1) return null;
  return m._values[idx];
}

void StaticMap_operatorIndexSet(AnyGC self, dynamic key, dynamic value) {
  final m = self as StaticMap;
  final idx = m._keys._storage.indexOf(key);
  if (idx != -1) {
    m._values[idx] = value;
  } else {
    m._keys._storage.add(key);
    m._values._storage.add(value);
  }
}

bool StaticMap_get_isEmpty(AnyGC self) => (self as StaticMap)._keys._storage.length == 0;
bool StaticMap_get_isNotEmpty(AnyGC self) => (self as StaticMap)._keys._storage.length > 0;
StaticList<K> StaticMap_get_keys<K>(AnyGC self) =>
    StaticList<K>._internal((self as StaticMap)._keys as Array<K>);
StaticList<V> StaticMap_get_values<V>(AnyGC self) =>
    StaticList<V>._internal((self as StaticMap)._values as Array<V>);
StaticList<StaticMapEntry> StaticMap_get_entries<K, V>(AnyGC self) {
  final m = self as StaticMap;
  final result = StaticList<StaticMapEntry>();
  for (int i = 0; i < m._keys._storage.length; i++) {
    result._data._storage.add(StaticMapEntry(m._keys[i], m._values[i]));
  }
  return result;
}

bool StaticMap_containsKey(AnyGC self, dynamic key) {
  final m = self as StaticMap;
  try {
    return m._keys._storage.indexOf(key) != -1;
  } catch (_) {
    return false;
  }
}

bool StaticMap_containsValue(AnyGC self, dynamic value) {
  final m = self as StaticMap;
  try {
    return m._values._storage.indexOf(value) != -1;
  } catch (_) {
    return false;
  }
}

dynamic StaticMap_remove(AnyGC self, dynamic key) {
  final m = self as StaticMap;
  final idx = m._keys._storage.indexOf(key);
  if (idx == -1) return null;
  m._keys._storage.removeAt(idx);
  return m._values._storage.removeAt(idx);
}

void StaticMap_removeWhere(AnyGC self, dynamic test) {
  final m = self as StaticMap;
  for (int i = m._keys._storage.length - 1; i >= 0; i--) {
    if (test(m._keys[i], m._values[i])) {
      m._keys._storage.removeAt(i);
      m._values._storage.removeAt(i);
    }
  }
}

void StaticMap_clear(AnyGC self) {
  final m = self as StaticMap;
  m._keys._storage.clear();
  m._values._storage.clear();
}

void StaticMap_forEach(AnyGC self, dynamic action) {
  final m = self as StaticMap;
  for (int i = 0; i < m._keys._storage.length; i++) {
    action(m._keys[i], m._values[i]);
  }
}

dynamic StaticMap_putIfAbsent(AnyGC self, dynamic key, dynamic ifAbsent) {
  final m = self as StaticMap;
  final idx = m._keys._storage.indexOf(key);
  if (idx != -1) return m._values[idx];
  final value = ifAbsent();
  m._keys._storage.add(key);
  m._values._storage.add(value);
  return value;
}

dynamic StaticMap_update(AnyGC self, dynamic key, dynamic updateFn, [dynamic ifAbsent]) {
  final m = self as StaticMap;
  final idx = m._keys._storage.indexOf(key);
  if (idx != -1) {
    final newVal = updateFn(m._values[idx]);
    m._values[idx] = newVal;
    return newVal;
  }
  if (ifAbsent != null) {
    final newVal = ifAbsent();
    m._keys._storage.add(key);
    m._values._storage.add(newVal);
    return newVal;
  }
  throw DartArgumentError('Key not found: $key');
}

void StaticMap_updateAll(AnyGC self, dynamic updateFn) {
  final m = self as StaticMap;
  for (int i = 0; i < m._keys._storage.length; i++) {
    m._values[i] = updateFn(m._keys[i], m._values[i]);
  }
}

void StaticMap_addAll(AnyGC self, dynamic other) {
  final m = self as StaticMap;
  if (other is StaticMap) {
    for (int i = 0; i < other._keys._storage.length; i++) {
      StaticMap_operatorIndexSet(m, other._keys[i], other._values[i]);
    }
  } else if (other is Map) {
    other.forEach((k, v) => StaticMap_operatorIndexSet(m, k, v));
  }
}

void StaticMap_addEntries(AnyGC self, dynamic entries) {
  final m = self as StaticMap;
  for (final entry in _toIterable(entries)) {
    StaticMap_operatorIndexSet(m, entry.key, entry.value);
  }
}

StaticMap<K2, V2> StaticMap_map<K2, V2>(AnyGC self, dynamic convert) {
  final m = self as StaticMap;
  final result = StaticMap<K2, V2>();
  for (int i = 0; i < m._keys._storage.length; i++) {
    final entry = convert(m._keys[i], m._values[i]) as StaticMapEntry;
    StaticMap_operatorIndexSet(result, entry.key, entry.value);
  }
  return result;
}

StaticMap<RK, RV> StaticMap_cast<RK, RV>(AnyGC self) {
  final m = self as StaticMap;
  final result = StaticMap<RK, RV>();
  for (int i = 0; i < m._keys._storage.length; i++) {
    StaticMap_operatorIndexSet(result, m._keys[i] as RK, m._values[i] as RV);
  }
  return result;
}

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
    if (source is StaticMap) {
      final src = source as StaticMap;
      for (int i = 0; i < src._keys._storage.length; i++) {
        _keys._storage.add(src._keys[i] as K);
        _values._storage.add(src._values[i] as V);
      }
    } else if (source is Map) {
      for (final entry in source.entries) {
        _keys._storage.add(entry.key as K);
        _values._storage.add(entry.value as V);
      }
    }
  }

  StaticMap.from(dynamic source) : this.of(source);

  StaticMap.fromEntries(Iterable<StaticMapEntry> entries)
      : _keys = Array<K>.empty(),
        _values = Array<V>.empty() {
    for (final entry in entries) {
      _keys._storage.add(entry.key);
      _values._storage.add(entry.value);
    }
  }

  StaticMap.fromIterables(Iterable<K> keys, Iterable<V> values)
      : _keys = Array<K>.from(keys),
        _values = Array<V>.from(values);

  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
    _keys.gcMark(flag);
    _values.gcMark(flag);
  }

  @override
  String toString() => StaticMap_toString(this);

  @override
  StaticMapClassInfo get classInfo =>
      ClassInfoRegistry.get<StaticMapClassInfo>(runtimeType, StaticMapClassInfo.new);
}

/// StaticSetClassInfo — StaticSet 的结构化虚表
class StaticSetClassInfo extends ClassInfo {
  StaticSetClassInfo() {
    toString_ = StaticSet_toString;
    gcMark = StaticSet_gcMark;
    get_runtimeType = StaticSet_get_runtimeType;
    get_length = StaticSet_get_length;
    get_isEmpty = StaticSet_get_isEmpty;
    get_isNotEmpty = StaticSet_get_isNotEmpty;
    get_iterator = StaticSet_get_iterator;
    contains = StaticSet_contains;
    get_first = StaticSet_get_first;
    get_last = StaticSet_get_last;
    get_single = StaticSet_get_single;
    add = StaticSet_add;
    addAll = StaticSet_addAll;
    remove = StaticSet_remove;
    removeWhere = StaticSet_removeWhere;
    retainWhere = StaticSet_retainWhere;
    clear = StaticSet_clear;
    lookup = StaticSet_lookup;
    forEach = StaticSet_forEach;
    where = StaticSet_where;
    any = StaticSet_any;
    every = StaticSet_every;
    firstWhere = StaticSet_firstWhere;
    lastWhere = StaticSet_lastWhere;
    singleWhere = StaticSet_singleWhere;
    reduce = StaticSet_reduce;
    union = StaticSet_union;
    intersection = StaticSet_intersection;
    difference = StaticSet_difference;
    containsAll = StaticSet_containsAll;
    toList = StaticSet_toList;
    toSet = StaticSet_toSet;
    followedBy = StaticSet_followedBy;
    take = StaticSet_take;
    skip = StaticSet_skip;
    takeWhile = StaticSet_takeWhile;
    skipWhile = StaticSet_skipWhile;
    join = StaticSet_join;
    elementAt = StaticSet_elementAt;
    map = StaticSet_map;
    expand = StaticSet_expand;
    cast = StaticSet_cast;
    fold = StaticSet_fold;
    whereType = StaticSet_whereType;
  }

  Function? get_first;
  Function? get_last;
  Function? get_single;
  Function? add;
  Function? addAll;
  Function? remove;
  Function? removeWhere;
  Function? retainWhere;
  Function? clear;
  Function? lookup;
  Function? forEach;
  Function? where;
  Function? any;
  Function? every;
  Function? firstWhere;
  Function? lastWhere;
  Function? singleWhere;
  Function? reduce;
  Function? union;
  Function? intersection;
  Function? difference;
  Function? containsAll;
  Function? toList;
  Function? toSet;
  Function? followedBy;
  Function? take;
  Function? skip;
  Function? takeWhile;
  Function? skipWhile;
  Function? join;
  Function? elementAt;
  Function? map;
  Function? expand;
  Function? cast;
  Function? fold;
  Function? whereType;
}

// Top-level StaticSet functions (lowered from instance methods)
String StaticSet_toString(AnyGC self) {
  final d = (self as StaticSet)._data;
  if (d._storage.length == 0) return '{}';
  final buf = StringBuffer('{');
  buf.write(d[0]);
  for (int i = 1; i < d._storage.length; i++) {
    buf.write(', ');
    buf.write(d[i]);
  }
  buf.write('}');
  return buf.toString();
}

String StaticSet_get_runtimeType(AnyGC self) => 'Set';
void StaticSet_gcMark(AnyGC self, int flag) => (self as StaticSet).gcMark(flag);
int StaticSet_get_length(AnyGC self) => (self as StaticSet)._data._storage.length;
bool StaticSet_contains(AnyGC self, Object? element) {
  final d = (self as StaticSet)._data;
  try {
    return d._storage.contains(element as dynamic);
  } catch (_) {
    return false;
  }
}

bool StaticSet_get_isEmpty(AnyGC self) => (self as StaticSet)._data._storage.length == 0;
bool StaticSet_get_isNotEmpty(AnyGC self) => (self as StaticSet)._data._storage.length > 0;
dynamic StaticSet_get_first(AnyGC self) {
  final d = (self as StaticSet)._data;
  if (d._storage.length == 0) throw DartStateError('No element');
  return d[0];
}

dynamic StaticSet_get_last(AnyGC self) {
  final d = (self as StaticSet)._data;
  if (d._storage.length == 0) throw DartStateError('No element');
  return d[d._storage.length - 1];
}

dynamic StaticSet_get_single(AnyGC self) {
  final d = (self as StaticSet)._data;
  if (d._storage.length != 1) throw DartStateError('Not single element');
  return d[0];
}

dynamic StaticSet_get_iterator(AnyGC self) => StaticIterator._fromArray((self as StaticSet)._data);
bool StaticSet_add(AnyGC self, dynamic element) {
  final d = (self as StaticSet)._data;
  if (d._storage.contains(element)) return false;
  d._storage.add(element);
  return true;
}

void StaticSet_addAll(AnyGC self, dynamic other) {
  final d = (self as StaticSet)._data;
  for (final element in _toIterable(other)) {
    if (!d._storage.contains(element)) d._storage.add(element);
  }
}

bool StaticSet_remove(AnyGC self, dynamic element) {
  final d = (self as StaticSet)._data;
  try {
    return d._storage.remove(element as dynamic);
  } catch (_) {
    return false;
  }
}

void StaticSet_removeWhere(AnyGC self, dynamic test) {
  final d = (self as StaticSet)._data;
  for (int i = d._storage.length - 1; i >= 0; i--) {
    if (test(d[i])) d._storage.removeAt(i);
  }
}

void StaticSet_retainWhere(AnyGC self, dynamic test) {
  final d = (self as StaticSet)._data;
  for (int i = d._storage.length - 1; i >= 0; i--) {
    if (!test(d[i])) d._storage.removeAt(i);
  }
}

void StaticSet_clear(AnyGC self) => (self as StaticSet)._data._storage.clear();
dynamic StaticSet_lookup(AnyGC self, dynamic element) {
  final d = (self as StaticSet)._data;
  try {
    final idx = d._storage.indexOf(element);
    if (idx == -1) return null;
    return d[idx];
  } catch (_) {
    return null;
  }
}

void StaticSet_forEach(AnyGC self, dynamic action) {
  final d = (self as StaticSet)._data;
  for (int i = 0; i < d._storage.length; i++) action(d[i]);
}

StaticSet<T> StaticSet_where<T>(AnyGC self, dynamic test) {
  final d = (self as StaticSet<T>)._data;
  final result = StaticSet<T>();
  for (int i = 0; i < d._storage.length; i++) {
    if (test(d[i])) result._data._storage.add(d[i]);
  }
  return result;
}

bool StaticSet_any(AnyGC self, dynamic test) {
  final d = (self as StaticSet)._data;
  for (int i = 0; i < d._storage.length; i++) {
    if (test(d[i])) return true;
  }
  return false;
}

bool StaticSet_every(AnyGC self, dynamic test) {
  final d = (self as StaticSet)._data;
  for (int i = 0; i < d._storage.length; i++) {
    if (!test(d[i])) return false;
  }
  return true;
}

dynamic StaticSet_firstWhere(AnyGC self, dynamic test, [dynamic orElse]) {
  final d = (self as StaticSet)._data;
  for (int i = 0; i < d._storage.length; i++) {
    if (test(d[i])) return d[i];
  }
  if (orElse != null) return orElse();
  throw DartStateError('No element');
}

dynamic StaticSet_lastWhere(AnyGC self, dynamic test, [dynamic orElse]) {
  final d = (self as StaticSet)._data;
  for (int i = d._storage.length - 1; i >= 0; i--) {
    if (test(d[i])) return d[i];
  }
  if (orElse != null) return orElse();
  throw DartStateError('No element');
}

dynamic StaticSet_singleWhere(AnyGC self, dynamic test, [dynamic orElse]) {
  final d = (self as StaticSet)._data;
  dynamic found;
  bool foundMultiple = false;
  for (int i = 0; i < d._storage.length; i++) {
    if (test(d[i])) {
      if (found != null) {
        foundMultiple = true;
        break;
      }
      found = d[i];
    }
  }
  if (foundMultiple) throw DartStateError('Too many elements');
  if (found != null) return found;
  if (orElse != null) return orElse();
  throw DartStateError('No element');
}

dynamic StaticSet_reduce(AnyGC self, dynamic combine) {
  final d = (self as StaticSet)._data;
  if (d._storage.length == 0) throw DartStateError('No element');
  dynamic value = d[0];
  for (int i = 1; i < d._storage.length; i++) value = combine(value, d[i]);
  return value;
}

StaticSet<T> StaticSet_union<T>(AnyGC self, dynamic other) {
  final sl = self as StaticSet<T>;
  final o = other as StaticSet<T>;
  final result = StaticSet<T>.of(sl._data._storage);
  for (int i = 0; i < o._data._storage.length; i++) {
    if (!result._data._storage.contains(o._data[i])) result._data._storage.add(o._data[i]);
  }
  return result;
}

StaticSet<T> StaticSet_intersection<T>(AnyGC self, dynamic other) {
  final sl = self as StaticSet<T>;
  final o = other as StaticSet<T>;
  final result = StaticSet<T>();
  for (int i = 0; i < sl._data._storage.length; i++) {
    if (o._data._storage.contains(sl._data[i])) result._data._storage.add(sl._data[i]);
  }
  return result;
}

StaticSet<T> StaticSet_difference<T>(AnyGC self, dynamic other) {
  final sl = self as StaticSet<T>;
  final o = other as StaticSet<T>;
  final result = StaticSet<T>();
  for (int i = 0; i < sl._data._storage.length; i++) {
    if (!o._data._storage.contains(sl._data[i])) result._data._storage.add(sl._data[i]);
  }
  return result;
}

StaticList<dynamic> StaticSet_toList(AnyGC self) {
  final d = (self as StaticSet)._data;
  final result = StaticList<dynamic>();
  for (int i = 0; i < d._storage.length; i++) result._data._storage.add(d[i]);
  return result;
}
dynamic StaticSet_toSet(AnyGC self) => Set<dynamic>.of((self as StaticSet)._data._storage);
StaticSet<T> StaticSet_followedBy<T>(AnyGC self, dynamic other) {
  final d = (self as StaticSet<T>)._data;
  final result = StaticSet<T>.of(d._storage);
  for (final e in _toIterable(other)) {
    if (!result._data._storage.contains(e)) result._data._storage.add(e);
  }
  return result;
}

StaticSet<T> StaticSet_take<T>(AnyGC self, dynamic count) {
  final d = (self as StaticSet<T>)._data;
  final result = StaticSet<T>();
  final end = count < d._storage.length ? count : d._storage.length;
  for (int i = 0; i < end; i++) result._data._storage.add(d[i]);
  return result;
}

StaticSet<T> StaticSet_skip<T>(AnyGC self, dynamic count) {
  final d = (self as StaticSet<T>)._data;
  final result = StaticSet<T>();
  for (int i = count; i < d._storage.length; i++) result._data._storage.add(d[i]);
  return result;
}

StaticSet<T> StaticSet_takeWhile<T>(AnyGC self, dynamic test) {
  final d = (self as StaticSet<T>)._data;
  final result = StaticSet<T>();
  for (int i = 0; i < d._storage.length; i++) {
    if (!test(d[i])) break;
    result._data._storage.add(d[i]);
  }
  return result;
}

StaticSet<T> StaticSet_skipWhile<T>(AnyGC self, dynamic test) {
  final d = (self as StaticSet<T>)._data;
  final result = StaticSet<T>();
  bool skipping = true;
  for (int i = 0; i < d._storage.length; i++) {
    if (skipping && test(d[i])) continue;
    skipping = false;
    result._data._storage.add(d[i]);
  }
  return result;
}

String StaticSet_join(AnyGC self, [dynamic separator]) {
  final d = (self as StaticSet)._data;
  if (d._storage.length == 0) return '';
  final buf = StringBuffer();
  buf.write(d[0]);
  for (int i = 1; i < d._storage.length; i++) {
    buf.write(separator ?? '');
    buf.write(d[i]);
  }
  return buf.toString();
}

dynamic StaticSet_elementAt(AnyGC self, dynamic index) =>
    (self as StaticSet)._data[index as int];

bool StaticSet_containsAll(AnyGC self, dynamic other) {
  final d = (self as StaticSet)._data;
  for (final e in _toIterable(other)) {
    if (!d._storage.contains(e)) return false;
  }
  return true;
}

StaticList<R> StaticSet_map<R>(AnyGC self, dynamic convert) {
  final d = (self as StaticSet)._data;
  final result = StaticList<R>();
  for (int i = 0; i < d._storage.length; i++) result._data._storage.add(convert(d[i]));
  return result;
}

StaticList<R> StaticSet_expand<R>(AnyGC self, dynamic convert) {
  final d = (self as StaticSet)._data;
  final result = StaticList<R>();
  for (int i = 0; i < d._storage.length; i++) {
    for (final r in _toIterable(convert(d[i]))) result._data._storage.add(r);
  }
  return result;
}

StaticSet<R> StaticSet_cast<R>(AnyGC self) {
  final d = (self as StaticSet)._data;
  final result = StaticSet<R>();
  for (int i = 0; i < d._storage.length; i++) result._data._storage.add(d[i] as R);
  return result;
}

dynamic StaticSet_fold(AnyGC self, dynamic initial, dynamic combine) {
  final d = (self as StaticSet)._data;
  dynamic value = initial;
  for (int i = 0; i < d._storage.length; i++) value = combine(value, d[i]);
  return value;
}

StaticSet<R> StaticSet_whereType<R>(AnyGC self) {
  final d = (self as StaticSet)._data;
  final result = StaticSet<R>();
  for (int i = 0; i < d._storage.length; i++) {
    if (d[i] is R) result._data._storage.add(d[i] as R);
  }
  return result;
}

/// StaticSet<T> — 完全独立的静态 Set，不继承 Set/SetMixin。
/// uses IterableMixin<T> 以兼容 for-in 和 Iterable 参数场景。
class StaticSet<T> extends AnyGC with IterableMixin<T> {
  final Array<T> _data;

  StaticSet() : _data = Array<T>.empty();

  StaticSet.of(dynamic elements) : _data = Array<T>.empty() {
    final source = elements is StaticSet
        ? (elements as StaticSet)._data._storage
        : elements;
    for (final element in source) {
      if (!_data._storage.contains(element)) _data._storage.add(element);
    }
  }

  StaticSet.from(dynamic elements) : _data = Array<T>.empty() {
    final source = elements is StaticSet
        ? (elements as StaticSet)._data._storage
        : elements;
    for (final element in source) {
      final e = element as T;
      if (!_data._storage.contains(e)) _data._storage.add(e);
    }
  }

  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
    _data.gcMark(flag);
  }

  @override
  String toString() => StaticSet_toString(this);

  @override
  Iterator<T> get iterator => _data._storage.iterator;

  @override
  StaticSetClassInfo get classInfo =>
      ClassInfoRegistry.get<StaticSetClassInfo>(runtimeType, StaticSetClassInfo.new);
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

  // ==========================================================================
  // 静态组合方法 — 对标 Future.wait / Future.any / Future.forEach
  // ==========================================================================

  /// Promise.wait — 等待所有 Promise 完成，返回结果列表。
  /// 等价于 Future.wait(List<Future<T>>)。
  static Promise<StaticList<T>> wait<T>(List<Promise<T>> promises) {
    if (promises.isEmpty) {
      final empty = Promise<StaticList<T>>();
      empty.complete(StaticList<T>.of([]));
      return empty;
    }

    final resultPromise = GC.allocateLocal(Promise<StaticList<T>>());
    final results = List<T?>.filled(promises.length, null);
    var completedCount = 0;

    resultPromise._onTick = () {
      for (var i = 0; i < promises.length; i++) {
        final p = promises[i];
        if (p.isError) {
          resultPromise.completeError(p.error!);
          return true;
        }
        if (p.isCompleted) {
          if (results[i] == null) {
            results[i] = p.result;
            completedCount++;
          }
        }
      }
      if (completedCount == promises.length) {
        resultPromise.complete(StaticList<T>.of(results.cast<T>()));
        return true;
      }
      return false;
    };
    GlobalScheduler.instance.registerActivePromise(resultPromise);
    return resultPromise;
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
  // Promise（包括 Promise<T> 和泛型不完全匹配的情况如 Promise<dynamic>）
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
class StaticMapEntry {
  final dynamic key;
  final dynamic value;
  const StaticMapEntry(this.key, this.value);

  @override
  String toString() => 'StaticMapEntry($key: $value)';

  @override
  bool operator ==(Object other) =>
      other is StaticMapEntry && other.key == key && other.value == value;

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
    return _index < _array._storage.length;
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

  @override
  String toString() => _delegate.toString();

  @override
  bool operator ==(Object other) =>
      other is StaticDateTime && other._delegate == _delegate;

  @override
  int get hashCode => _delegate.hashCode;
}

/// ReachabilityError — 用于 switch 表达式穷尽性检查的运行时错误
class ReachabilityError extends Error {
  final String message;
  ReachabilityError([this.message = '']);
  @override
  String toString() => 'ReachabilityError: $message';
}
