class CppString {
  final String value;

  const CppString(this.value);

  static const CppString Empty = CppString("");

  @override
  String toString() => value;

  int get length => value.length;

  bool get isEmpty => value.isEmpty;

  bool get isNotEmpty => value.isNotEmpty;
}
