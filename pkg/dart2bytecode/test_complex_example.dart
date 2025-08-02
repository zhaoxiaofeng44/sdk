class ComplexList {
  int _length = 0;
  dynamic _array;
  String _name = "ComplexList";

  ComplexList();

  int get length => _length;
  String get name => _name;

  void add(dynamic value) {
    _length++;
  }

  dynamic operator [](int index) {
    return _array;
  }

  void operator []=(int index, dynamic value) {
    _array = value;
  }

  void operator +(dynamic other) {
    _length += 1;
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
}

void main() {
  final list = ComplexList();
  print('初始状态: ${list.name}, 长度: ${list.length}');

  list.add(1);
  list[0] = 42;
  list + 5;

  print('操作后: ${list.name}, 长度: ${list.length}');
  print('测试完成！');
}
