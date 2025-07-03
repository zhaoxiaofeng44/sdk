// 直接成员函数实现功能测试
// 验证成员函数直接包含实现代码而不是委托给全局函数

import 'dart:io';

void main() {
  print("=== 直接成员函数实现功能测试 ===");

  // 测试基本类功能
  testBasicClass();

  // 测试继承功能
  testInheritance();

  // 测试 Getter/Setter
  testGetterSetter();

  print("=== 测试完成 ===");
}

void testBasicClass() {
  print("\n--- 测试基本类功能 ---");

  var obj = TestClass(42);
  print("初始值: ${obj.getValue()}");

  obj.increment();
  print("递增后: ${obj.getValue()}");

  obj.setValue(100);
  print("设置新值后: ${obj.getValue()}");
}

void testInheritance() {
  print("\n--- 测试继承功能 ---");

  var derived = DerivedClass(10, "测试对象");
  print("派生类信息: ${derived.getInfo()}");

  derived.increment();
  print("递增后信息: ${derived.getInfo()}");

  derived.setName("新名称");
  print("更新名称后: ${derived.getInfo()}");
}

void testGetterSetter() {
  print("\n--- 测试 Getter/Setter ---");

  var obj = TestClass(0);

  // 使用 setter
  obj.value = 50;
  print("通过 setter 设置: ${obj.value}");

  // 使用 getter
  int current = obj.value;
  print("通过 getter 获取: $current");
}

class TestClass {
  int _value = 0;

  // 构造函数
  TestClass(int initialValue) {
    this._value = initialValue;
  }

  // 普通方法
  void increment() {
    this._value = this._value + 1;
  }

  // 带参数的方法
  void setValue(int newValue) {
    this._value = newValue;
  }

  // 带返回值的方法
  int getValue() {
    return this._value;
  }

  // Getter
  int get value {
    return this._value;
  }

  // Setter
  set value(int newValue) {
    this._value = newValue;
  }
}

class DerivedClass extends TestClass {
  String _name = "";

  // 派生类构造函数
  DerivedClass(int initialValue, String name) : super(initialValue) {
    this._name = name;
  }

  // 新增方法
  String getInfo() {
    return "${this._name}: ${this.getValue()}";
  }

  // 设置名称
  void setName(String newName) {
    this._name = newName;
  }

  // 重写父类方法
  @override
  void increment() {
    super.increment();
    print("DerivedClass: 值已递增");
  }
}
