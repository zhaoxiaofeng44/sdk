class CppList {
  int _length = 0;
  dynamic _array;

  CppList();

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

  void addAll(Iterable iterable) {
    for (final item in iterable) {
      add(item);
    }
  }
}

void main() {
  final list = CppList();
  list.add(1);
  list[0] = 2;
  print(list[0]);
}
