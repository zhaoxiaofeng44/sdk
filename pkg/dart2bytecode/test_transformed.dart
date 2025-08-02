import 'transformed_dart.dart';

void main() {
  // 测试转换后的代码
  final list = CppList();

  // 测试基本功能
  print('初始长度: ${list.length}');

  // 测试添加元素
  CppList.addElement(list, 1);
  print('添加元素后长度: ${list.length}');

  // 测试设置元素
  CppList.setElement(list, 0, 42);
  print('设置元素: ${CppList.getElement(list, 0)}');

  // 测试getter
  print('通过getter获取长度: ${list.length}');

  // 测试其他方法
  print('是否为空: ${CppList.isEmpty(list)}');
  print('是否不为空: ${CppList.isNotEmpty(list)}');

  // 测试添加多个元素
  final items = [1, 2, 3, 4, 5];
  CppList.addAllElements(list, items);
  print('添加多个元素后长度: ${list.length}');

  print('测试完成！');
}
