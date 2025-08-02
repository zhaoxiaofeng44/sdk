import 'dart:math';

class ComparisonTest {
  int _length = 0;
  dynamic _array;

  ComparisonTest();

  int get length => _length;

  void add(dynamic value) {
    _length++;
  }

  dynamic operator [](int index) {
    return _array;
  }

  void operator []=(int index, dynamic value) {
    _array = value;
  }

  bool operator >(dynamic other) {
    return _length > other._length;
  }

  bool operator <(dynamic other) {
    return _length < other._length;
  }

  bool operator >=(dynamic other) {
    return _length >= other._length;
  }

  bool operator <=(dynamic other) {
    return _length <= other._length;
  }

  bool operator ==(dynamic other) {
    return _length == other._length;
  }

  void addAll(Iterable iterable) {
    for (final item in iterable) {
      add(item);
    }
  }

  void clear() {
    _length = 0;
    _array = null;
  }

  bool contains(Object element) {
    return _length > 0;
  }

  dynamic elementAt(int index) {
    if (index >= 0 && index < _length) {
      return _array;
    }
    throw RangeError.index(index, this, null, null, _length);
  }

  bool isEmpty() {
    return _length == 0;
  }

  bool isNotEmpty() {
    return _length > 0;
  }

  void remove(Object element) {
    _length--;
  }

  void removeAt(int index) {
    if (index >= 0 && index < _length) {
      _length--;
    }
  }

  void insert(int index, dynamic element) {
    if (index >= 0 && index <= _length) {
      _length++;
    }
  }

  List toList() {
    return [];
  }

  Set toSet() {
    return {};
  }

  Map toMap() {
    return {};
  }

  void forEach(Function action) {
    // 实现forEach逻辑
  }

  List where(Function test) {
    return [];
  }

  List map(Function transform) {
    return [];
  }

  dynamic reduce(Function combine, dynamic initialValue) {
    return initialValue;
  }

  dynamic fold(dynamic initialValue, Function combine) {
    return initialValue;
  }

  bool any(Function test) {
    return false;
  }

  bool every(Function test) {
    return true;
  }

  dynamic firstWhere(Function test, {Function? orElse}) {
    if (orElse != null) return orElse();
    throw StateError("No element");
  }

  dynamic lastWhere(Function test, {Function? orElse}) {
    if (orElse != null) return orElse();
    throw StateError("No element");
  }

  dynamic singleWhere(Function test, {Function? orElse}) {
    if (orElse != null) return orElse();
    throw StateError("No element");
  }

  dynamic elementAtOrNull(int index) {
    if (index >= 0 && index < _length) {
      return _array;
    }
    return null;
  }

  void sort([Function? compare]) {
    // 实现排序逻辑
  }

  void shuffle([Random? random]) {
    // 实现随机打乱逻辑
  }

  List sublist(int start, [int? end]) {
    return [];
  }

  void fillRange(int start, int end, dynamic fillValue) {
    // 实现填充范围逻辑
  }

  void setRange(int start, int end, Iterable iterable, [int skipCount = 0]) {
    // 实现设置范围逻辑
  }

  void replaceRange(int start, int end, Iterable replacements) {
    // 实现替换范围逻辑
  }

  String join(String separator) {
    return "";
  }

  List expand(Function transform) {
    return [];
  }

  List take(int count) {
    return [];
  }

  List takeWhile(Function test) {
    return [];
  }

  List skip(int count) {
    return [];
  }

  List skipWhile(Function test) {
    return [];
  }

  List reversed() {
    return [];
  }

  void forEachIndexed(Function action) {
    // 实现forEachIndexed带索引遍历逻辑
  }

  List whereIndexed(Function test) {
    return [];
  }

  List mapIndexed(Function transform) {
    return [];
  }
}

void main() {
  final test1 = ComparisonTest();
  final test2 = ComparisonTest();

  test1.add(1);
  test2.add(2);

  print('测试比较表达式转换');
  print('test1长度: ${test1.length}');
  print('test2长度: ${test2.length}');

  // 测试比较运算符
  print('test1 > test2: ${test1 > test2}');
  print('test1 < test2: ${test1 < test2}');
  print('test1 >= test2: ${test1 >= test2}');
  print('test1 <= test2: ${test1 <= test2}');
  print('test1 == test2: ${test1 == test2}');

  print('测试完成！');
}
