// 测试前缀逻辑移除是否正确工作
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

/// 继承关系测试
class ChildClass extends TestClass {
  void childMethod() {
    print('child method');
  }
}

/// 接口实现测试
abstract class TestInterface {
  void interfaceMethod();
}

class ImplementationClass implements TestInterface {
  @override
  void interfaceMethod() {
    print('interface implementation');
  }
}

/// 全局函数使用 List 类型
List<T> createList<T>() {
  return <T>[];
}

void main() {
  print('测试前缀移除功能');
  
  // 验证类名不再有前缀
  final testObj = TestClass();
  final childObj = ChildClass();
  final implObj = ImplementationClass();
  
  print('TestClass 类型: ${testObj.runtimeType}');
  print('ChildClass 类型: ${childObj.runtimeType}');
  print('ImplementationClass 类型: ${implObj.runtimeType}');
}