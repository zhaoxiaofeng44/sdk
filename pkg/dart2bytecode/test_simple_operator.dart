class SimpleOperatorTest {
  int _value = 0;

  SimpleOperatorTest();

  int get value => _value;

  int operator +(int other) {
    return _value + other;
  }

  int operator -(int other) {
    return _value - other;
  }

  bool operator >(int other) {
    return _value > other;
  }

  bool operator <(int other) {
    return _value < other;
  }

  void setValue(int value) {
    _value = value;
  }
}

void main() {
  final test = SimpleOperatorTest();
  test.setValue(10);

  print('测试简单运算符转换');
  print('初始值: ${test.value}');
  print('test + 5: ${test + 5}');
  print('test - 3: ${test - 3}');
  print('test > 5: ${test > 5}');
  print('test < 15: ${test < 15}');
  print('测试完成！');
}
