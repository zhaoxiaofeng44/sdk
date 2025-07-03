// 继承关系测试
// 测试CyBase -> CyFather -> CyChild的继承链

import 'package:test/test.dart';

void main() {
  test('Test inheritance chain', () {
    print('Testing inheritance relationship:');
    print('CyBase -> CyFather -> CyChild');

    // 测试基类
    var base = CyBase(10);
    base.test();
    print('CyBase created and tested successfully');

    // 测试父类
    var father = CyFather();
    father.test(); // 继承自CyBase的方法
    father.myTest(); // CyFather自己的方法
    print('CyFather created and tested successfully');

    // 测试子类
    var child = CyChild();
    child.test(); // 继承自CyBase的方法
    child.myTest(); // 继承自CyFather的方法
    print('CyChild created and tested successfully');

    // 验证继承关系
    expect(child is CyChild, isTrue);
    expect(child is CyFather, isTrue);
    expect(child is CyBase, isTrue);

    expect(father is CyFather, isTrue);
    expect(father is CyBase, isTrue);

    expect(base is CyBase, isTrue);

    print('All inheritance tests passed!');
  });
}

// 测试类定义
class CyBase {
  int? a;
  String? aa;

  CyBase(int c) {
    this.a = c;
    this.aa = "base";
  }

  void test() {
    print("CyBase.test() called with a=${this.a}");
  }
}

class CyFather extends CyBase {
  int? b;
  Object? base;

  CyFather() : super(5) {
    this.b = 10;
    this.base = "father";
  }

  void myTest() {
    print("CyFather.myTest() called with b=${this.b}");
  }
}

class CyChild extends CyFather {
  int? c;
  Object? e;

  CyChild() : super() {
    this.c = 15;
    this.e = "child";
  }

  void myTest() {
    super.myTest();
    print("CyChild.myTest() called with c=${this.c}");
  }
}
