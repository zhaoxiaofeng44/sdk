import 'collection.dart';

@pragma("cpp:patch-class", "StringBuffer")
@pragma('cpp:patch', 'StringBuffer')
class CppStringBuffer implements StringBuffer {
  final CppList<String> _parts;

  CppStringBuffer([Object content = ""])
      : _parts = CppList<String>(0, 16)..add(content.toString());

  // 标准StringBuffer方法
  void write(Object? obj) {
    _parts.add(obj.toString());
  }

  void writeAll(Iterable objects, [String separator = ""]) {
    var iterator = objects.iterator;
    if (iterator.moveNext()) {
      _parts.add(iterator.current.toString());
      while (iterator.moveNext()) {
        if (separator.isNotEmpty) {
          _parts.add(separator);
        }
        _parts.add(iterator.current.toString());
      }
    }
  }

  void writeCharCode(int charCode) {
    _parts.add(String.fromCharCode(charCode));
  }

  void writeln([Object? obj = ""]) {
    _parts.add(obj.toString());
    _parts.add('\n');
  }

  void clear() {
    _parts.clear();
  }

  @override
  String toString() {
    return _parts.join('');
  }

  int get length {
    return _parts.fold(0, (sum, part) => sum + part.length);
  }

  bool get isEmpty => _parts.isEmpty;

  bool get isNotEmpty => _parts.isNotEmpty;
}
