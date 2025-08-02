class BitwiseTest {
  int _value = 0;
  
  int operator &(int other) {
    return _value & other;
  }
  
  int operator +(int other) {
    return _value + other;
  }
  
  void test() {
    var test = BitwiseTest();
    test._value = 10;
    print(test & 3);
    print(test + 5);
  }
} 