import 'package:test/test.dart';
import 'hello.dart';
import 'list.dart';

void main() {
  test('Test class inheritance generation', () {
    // 测试基类
    var base = CyBase(3);
    expect(base.runtimeType.toString(), equals('CyBase'));

    // 测试父类
    var father = CyFather();
    expect(father.runtimeType.toString(), equals('CyFather<dynamic, dynamic>'));
    expect(father is CyBase, isTrue);

    // 测试子类
    var child = CyChild();
    expect(child.runtimeType.toString(), equals('CyChild<dynamic, dynamic>'));
    expect(child is CyFather, isTrue);
    expect(child is CyBase, isTrue);
  });

  test('Test complex class functionality', () {
    var complex = CyComplexTest();

    // 测试条件语句
    complex.testConditionals();

    // 测试switch语句
    complex.testSwitch(1);
    complex.testSwitch(2);
    complex.testSwitch(3);

    // 测试循环
    complex.testLoops();
  });

  test('Test array operations', () {});
}
