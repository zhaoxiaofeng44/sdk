import '../lib/demo/num.dart';
import '../lib/demo/box.dart';

void main() {
  print('开始简单测试...');

  // 测试基本类型
  final int1 = Int(42);
  final double1 = Double(3.14);
  final bool1 = Bool(true);

  print('Int: ${int1.value}');
  print('Double: ${double1.value}');
  print('Bool: ${bool1.value}');

  // 测试Box
  final intBox = Box(int1);
  final doubleBox = Box(double1);
  final boolBox = Box(bool1);

  print('IntBox: ${intBox.value.value}');
  print('DoubleBox: ${doubleBox.value.value}');
  print('BoolBox: ${boolBox.value.value}');

  // 测试基本运算
  final int2 = Int(10);
  final result = int1 + int2;
  print('Int运算: ${int1.value} + ${int2.value} = ${result.value}');

  print('测试完成！');
}
