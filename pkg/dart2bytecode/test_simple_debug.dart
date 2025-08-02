class SimpleDebug {
  int _value = 0;

  bool operator <(int other) {
    return _value < other;
  }

  void test() {
    var test = SimpleDebug();
    print(test < 15);
  }
}
