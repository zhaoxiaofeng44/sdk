class TestSplit {
  int? value;
  String? name;

  // 默认构造函数
  TestSplit() {
    value = 42;
    name = "default";
  }

  // 带参数的构造函数
  TestSplit.withParams(int val, String nm) {
    value = val;
    name = nm;
  }

  void display() {
    print("Value: $value, Name: $name");
  }
}

void main() {
  // 使用默认构造函数
  var obj1 = TestSplit(); // 应该被转换为 TestSplit::cppNew()->cppCtr_()
  obj1.display(); // 应该输出: Value: 42, Name: default

  // 使用带参数的构造函数
  var obj2 = TestSplit.withParams(100,
      "test"); // 应该被转换为 TestSplit::cppNew()->cppCtr_withParams(100, "test")
  obj2.display(); // 应该输出: Value: 100, Name: test
}
