// 直接成员函数实现功能演示
// 此测试展示了成员函数直接包含实现代码，而不是委托给全局函数

class CyBase {
  int a = 0;
  String aa = "";

  // 构造函数
  CyBase(int c) {
    this.a = c;
  }

  // 普通方法
  void test() {
    print("CyBase test method");
    this.a = this.a + 1;
  }

  // Getter 方法
  int get value {
    return this.a;
  }

  // Setter 方法
  set value(int newValue) {
    this.a = newValue;
  }

  // 带返回值的方法
  int calculate(int x, int y) {
    return x + y + this.a;
  }
}

class CyDerived extends CyBase {
  String name = "";

  // 派生类构造函数
  CyDerived(int c, String n) : super(c) {
    this.name = n;
  }

  // 重写父类方法
  @override
  void test() {
    super.test();
    print("CyDerived test method: " + this.name);
  }

  // 新增方法
  String getInfo() {
    return this.name + ": " + this.a.toString();
  }
}

void main() {
  // 测试基类
  var base = CyBase(10);
  base.test();
  print("Base value: " + base.value.toString());

  base.value = 20;
  print("Updated base value: " + base.value.toString());

  int result = base.calculate(5, 3);
  print("Calculate result: " + result.toString());

  // 测试派生类
  var derived = CyDerived(15, "TestObject");
  derived.test();
  print("Derived info: " + derived.getInfo());
}
