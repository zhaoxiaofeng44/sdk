class TestGetterSetter {
  int? _value;
  String? _name;

  // 构造函数
  TestGetterSetter() {
    _value = 42;
    _name = "default";
  }

  // getter
  int? get value => _value;
  String? get name => _name;

  // setter
  set value(int? val) {
    _value = val;
  }

  set name(String? nm) {
    _name = nm;
  }

  void display() {
    print("Value: $value, Name: $name");
  }
}

void main() {
  var obj = TestGetterSetter();

  // 测试getter
  print("Initial value: ${obj.value}"); // 应该输出: Initial value: 42
  print("Initial name: ${obj.name}"); // 应该输出: Initial name: default

  // 测试setter
  obj.value = 100;
  obj.name = "test";

  // 验证setter是否生效
  print("After set value: ${obj.value}"); // 应该输出: After set value: 100
  print("After set name: ${obj.name}"); // 应该输出: After set name: test

  obj.display(); // 应该输出: Value: 100, Name: test
}
