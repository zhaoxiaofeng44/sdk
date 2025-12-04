class MyTest {
  int a;
  int b;
  MyTest(this.a, this.b);
  void testA() {}

  int getgg() {
    return a + b;
  }
}

class MyTest2 implements MyTest {
  MyTest2(int a, int b) {
    this.a = a;
    this.b = b;
  }
  @override
  noSuchMethod(Invocation invocation) {
    // TODO: implement noSuchMethod
    print(invocation);
    return super.noSuchMethod(invocation);
  }
}

void main() {
  print('🔥 基础语法测试开始');

  MyTest2 myTest2 = MyTest2(1, 3);
}
