class SimpleTest {
  int _value = 0;

  int get value => _value;
  void set value(int v) => _value = v;

  SimpleTest operator +(SimpleTest other) {
    return SimpleTest().._value = _value + other._value;
  }

  bool operator <(int other) {
    return _value < other;
  }

  void main() {
    var test = SimpleTest();
    test.value = 10;
    print(test < 15);
    print(test + SimpleTest()
      ..value = 5);
  }
}
