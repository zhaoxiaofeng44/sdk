class TestConstructor {
  int _value = 0;

  // 没有名称的构造函数
  TestConstructor();

  // 有名称的构造函数
  TestConstructor.named(int value) {
    _value = value;
  }

  // 有参数的构造函数
  TestConstructor.withValue(int value) {
    _value = value;
  }

  void test() {
    var test1 = TestConstructor();
    var test2 = TestConstructor.named(10);
    var test3 = TestConstructor.withValue(20);
    print('test1: ${test1._value}');
    print('test2: ${test2._value}');
    print('test3: ${test3._value}');
  }
}
