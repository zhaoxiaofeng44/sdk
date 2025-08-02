class OperatorTest {
  int _value = 0;
  dynamic _array;

  OperatorTest();

  int get value => _value;

  // 算术运算符
  int operator +(int other) {
    return _value + other;
  }

  int operator -(int other) {
    return _value - other;
  }

  int operator *(int other) {
    return _value * other;
  }

  int operator /(int other) {
    return _value ~/ other;
  }

  int operator %(int other) {
    return _value % other;
  }

  // 比较运算符
  bool operator >(int other) {
    return _value > other;
  }

  bool operator <(int other) {
    return _value < other;
  }

  bool operator >=(int other) {
    return _value >= other;
  }

  bool operator <=(int other) {
    return _value <= other;
  }

  bool operator ==(Object other) {
    if (other is OperatorTest) {
      return _value == other._value;
    }
    return false;
  }

  // 位运算符
  int operator &(int other) {
    return _value & other;
  }

  int operator |(int other) {
    return _value | other;
  }

  int operator ^(int other) {
    return _value ^ other;
  }

  int operator <<(int other) {
    return _value << other;
  }

  int operator >>(int other) {
    return _value >> other;
  }

  int operator >>>(int other) {
    return _value >>> other;
  }

  int operator ~() {
    return ~_value;
  }

  // 一元运算符
  int operator -() {
    return -_value;
  }

  int operator +() {
    return _value;
  }

  bool operator !() {
    return _value == 0;
  }

  // 自增自减
  int operator ++() {
    return ++_value;
  }

  int operator --() {
    return --_value;
  }

  // 赋值运算符
  void operator +=(int other) {
    _value += other;
  }

  void operator -=(int other) {
    _value -= other;
  }

  void operator *=(int other) {
    _value *= other;
  }

  void operator /=(int other) {
    _value ~/= other;
  }

  void operator %=(int other) {
    _value %= other;
  }

  void operator &=(int other) {
    _value &= other;
  }

  void operator |=(int other) {
    _value |= other;
  }

  void operator ^=(int other) {
    _value ^= other;
  }

  void operator <<=(int other) {
    _value <<= other;
  }

  void operator >>=(int other) {
    _value >>= other;
  }

  void operator >>>=(int other) {
    _value >>>= other;
  }

  // 索引运算符
  dynamic operator [](int index) {
    return _array;
  }

  void operator []=(int index, dynamic value) {
    _array = value;
  }

  // 逻辑运算符
  bool operator &&(bool other) {
    return _value != 0 && other;
  }

  bool operator ||(bool other) {
    return _value != 0 || other;
  }

  // 空合并运算符
  int operator ??(int other) {
    return _value != 0 ? _value : other;
  }

  void setValue(int value) {
    _value = value;
  }

  void setArray(dynamic array) {
    _array = array;
  }
}

void main() {
  final test = OperatorTest();
  test.setValue(10);
  test.setArray([1, 2, 3]);

  print('测试运算符转换');
  print('初始值: ${test.value}');

  // 测试算术运算符
  print('test + 5: ${test + 5}');
  print('test - 3: ${test - 3}');
  print('test * 2: ${test * 2}');
  print('test / 3: ${test / 3}');
  print('test % 3: ${test % 3}');

  // 测试比较运算符
  print('test > 5: ${test > 5}');
  print('test < 15: ${test < 15}');
  print('test >= 10: ${test >= 10}');
  print('test <= 10: ${test <= 10}');

  // 测试位运算符
  print('test & 3: ${test & 3}');
  print('test | 5: ${test | 5}');
  print('test ^ 7: ${test ^ 7}');
  print('test << 1: ${test << 1}');
  print('test >> 1: ${test >> 1}');
  print('test >>> 1: ${test >>> 1}');
  print('~test: ${~test}');

  // 测试一元运算符
  print('-test: ${-test}');
  print('+test: ${+test}');
  print('!test: ${!test}');

  // 测试自增自减
  print('++test: ${++test}');
  print('--test: ${--test}');

  // 测试赋值运算符
  test += 5;
  print('test += 5: ${test.value}');
  test -= 2;
  print('test -= 2: ${test.value}');
  test *= 3;
  print('test *= 3: ${test.value}');

  // 测试索引运算符
  print('test[0]: ${test[0]}');
  test[1] = 42;
  print('设置test[1] = 42');

  print('测试完成！');
} 