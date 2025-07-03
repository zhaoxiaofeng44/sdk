class TestClass {
  int? value;
  String? name;

  // 默认构造函数
  TestClass() {
    value = 42;
    name = "default";
  }

  // 带参数的构造函数
  TestClass.withParams(int val, String nm) {
    value = val;
    name = nm;
  }

  void display() {
    print("Value: $value, Name: $name");
  }
}

void main() {
  var obj1 = TestClass();
  obj1.display(); // 应该输出: Value: 42, Name: default

  var obj2 = TestClass.withParams(100, "test");
  obj2.display(); // 应该输出: Value: 100, Name: test
}
