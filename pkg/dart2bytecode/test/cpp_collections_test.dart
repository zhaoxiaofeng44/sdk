import '../lib/demo/Iterable.dart';
import '../lib/demo/collection.dart';

// 简单的测试实现类
class SimpleIterable<T> extends CppIterable<T> {
  final List<T> _items;

  SimpleIterable(this._items);

  @override
  Iterator<T> get iterator => _items.iterator;

  @override
  int get length => _items.length;
}

void main() {
  // 测试CppList和CppSet的返回类型
  print("=== 测试CppList和CppSet返回类型 ===");
  var iterable = SimpleIterable([1, 2, 3, 4, 5]);

  // 测试toList返回CppList
  var listResult = iterable.toList();
  print("toList()返回类型: ${listResult.runtimeType}");
  print("是否为CppList: ${listResult is CppList}");
  print("CppList内容: $listResult");

  // 测试toSet返回CppSet
  var setResult = iterable.toSet();
  print("toSet()返回类型: ${setResult.runtimeType}");
  print("是否为CppSet: ${setResult is CppSet}");
  print("CppSet内容: $setResult");

  // 测试CppList的功能
  print("\n=== 测试CppList功能 ===");
  var cppList = CppList<int>.from([1, 2, 3]);
  print("CppList初始内容: $cppList");
  cppList.add(4);
  print("添加元素后: $cppList");
  print("长度: ${cppList.length}");
  print("第一个元素: ${cppList.first}");
  print("最后一个元素: ${cppList.last}");

  // 测试CppSet的功能
  print("\n=== 测试CppSet功能 ===");
  var cppSet = CppSet<int>.from([1, 2, 3, 2, 1]);
  print("CppSet内容(去重): $cppSet");
  cppSet.add(4);
  print("添加元素后: $cppSet");
  print("长度: ${cppSet.length}");
  print("是否包含2: ${cppSet.contains(2)}");
  print("是否包含5: ${cppSet.contains(5)}");

  // 测试CppMap的功能
  print("\n=== 测试CppMap功能 ===");
  var cppMap = CppMap<String, int>();
  cppMap['one'] = 1;
  cppMap['two'] = 2;
  cppMap['three'] = 3;
  print("CppMap内容: $cppMap");
  print("长度: ${cppMap.length}");
  print("键: ${cppMap.keys.toList()}");
  print("值: ${cppMap.values.toList()}");

  // 测试反转迭代器使用CppList
  print("\n=== 测试反转迭代器使用CppList ===");
  var reversed = iterable.reversed;
  print("反转结果: ${reversed.toList()}");
  print("反转结果类型: ${reversed.toList().runtimeType}");

  // 测试链式操作
  print("\n=== 测试链式操作 ===");
  var result = iterable.map((x) => x * 2).where((x) => x > 5).toList();
  print("链式操作结果: $result");
  print("结果类型: ${result.runtimeType}");

  print("\n=== 测试完成 ===");
}
