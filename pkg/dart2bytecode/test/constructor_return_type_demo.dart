// 构造函数返回类型修复演示

class TestConstructor {
  int? value;
  String? name;

  // 默认构造函数
  TestConstructor();

  // 带参数的构造函数
  TestConstructor.withValue(int val);

  // 带多个参数的构造函数
  TestConstructor.withParams(int val, String nm);

  void display() {
    print('Value: $value, Name: $name');
  }
}

void main() {
  // 测试不同类型的构造函数调用
  var obj1 = TestConstructor();
  var obj2 = TestConstructor.withValue(42);
  var obj3 = TestConstructor.withParams(100, "Test");

  obj1.display();
  obj2.display();
  obj3.display();
}
