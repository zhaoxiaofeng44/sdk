// 测试类型替换是否正确工作
import 'package:kernel/kernel.dart';
import 'package:kernel/ast.dart';

/// 测试用的模拟类，带有 @pragma('cpp:patch', 'List') 注解
@pragma('cpp:patch', 'List')
class CppList<E> {
  void add(E element) {}
  E operator [](int index) => throw UnimplementedError();
}

/// 另一个测试类，使用 List 类型参数
class TestClass {
  List<int> numbers = [];

  void addNumber(int value) {
    numbers.add(value);
  }

  List<String> getStringList() {
    return <String>[];
  }

  void processLists(List<dynamic> input) {
    // 这里的 List 类型应该被替换为 CppList
  }
}

/// 全局函数使用 List 类型
List<T> createList<T>() {
  return <T>[];
}

void main() {
  print('测试类型替换功能');
}
