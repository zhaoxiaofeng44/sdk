import 'transformed_dart.dart';

void main() {
  final test1 = ComparisonTest();
  final test2 = ComparisonTest();

  ComparisonTest.addElement(test1, 1);
  ComparisonTest.addElement(test2, 2);

  print('测试比较表达式转换');
  print('test1长度: ${test1.length}');
  print('test2长度: ${test2.length}');

  // 测试比较运算符方法
  print('test1 > test2: ${ComparisonTest.greaterThan(test1, test2)}');
  print('test1 < test2: ${ComparisonTest.lessThan(test1, test2)}');
  print('test1 >= test2: ${ComparisonTest.greaterThanOrEqual(test1, test2)}');
  print('test1 <= test2: ${ComparisonTest.lessThanOrEqual(test1, test2)}');
  print('test1 == test2: ${ComparisonTest.equals(test1, test2)}');
  print('test1 != test2: ${ComparisonTest.notEquals(test1, test2)}');

  // 测试其他方法
  print('test1是否为空: ${ComparisonTest.isEmpty(test1)}');
  print('test2是否不为空: ${ComparisonTest.isNotEmpty(test2)}');

  // 测试元素操作
  ComparisonTest.addElement(test1, 10);
  print('添加元素后test1长度: ${test1.length}');

  print('测试完成！');
}
