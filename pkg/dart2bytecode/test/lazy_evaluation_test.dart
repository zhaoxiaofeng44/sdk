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
  print("=== 测试懒加载功能 ===");

  // 创建一个会打印信息的转换函数来验证懒加载
  int transformCount = 0;
  T doubleWithLog<T extends num>(T x) {
    print("  转换: $x -> ${x * 2}");
    transformCount++;
    return (x * 2) as T;
  }

  var iterable = SimpleIterable([1, 2, 3, 4, 5]);

  // 测试map的懒加载
  print("\n1. 测试map懒加载：");
  transformCount = 0;
  var mapped = iterable.map(doubleWithLog);
  print("创建mapped后，转换次数: $transformCount"); // 应该是0，因为懒加载

  print("开始迭代：");
  var result = mapped.toList();
  print("迭代完成后，转换次数: $transformCount"); // 应该是5
  print("结果: $result");

  // 测试where的懒加载
  print("\n2. 测试where懒加载：");
  int filterCount = 0;
  bool isEvenWithLog(int x) {
    print("  过滤检查: $x");
    filterCount++;
    return x % 2 == 0;
  }

  filterCount = 0;
  var filtered = iterable.where(isEvenWithLog);
  print("创建filtered后，过滤次数: $filterCount"); // 应该是0

  print("开始迭代：");
  var filteredResult = filtered.toList();
  print("迭代完成后，过滤次数: $filterCount"); // 应该是5
  print("结果: $filteredResult");

  // 测试链式懒加载
  print("\n3. 测试链式懒加载：");
  transformCount = 0;
  filterCount = 0;

  var chained = iterable.map(doubleWithLog).where(isEvenWithLog);

  print("创建链式操作后，转换次数: $transformCount, 过滤次数: $filterCount");

  print("开始迭代：");
  var chainedResult = chained.toList();
  print("迭代完成后，转换次数: $transformCount, 过滤次数: $filterCount");
  print("结果: $chainedResult");

  // 测试take的懒加载
  print("\n4. 测试take懒加载：");
  transformCount = 0;
  var taken = iterable.map(doubleWithLog).take(3);
  print("创建taken后，转换次数: $transformCount"); // 应该是0

  print("开始迭代：");
  var takenResult = taken.toList();
  print("迭代完成后，转换次数: $transformCount"); // 应该是3，不是5
  print("结果: $takenResult");

  // 测试skip的懒加载
  print("\n5. 测试skip懒加载：");
  transformCount = 0;
  var skipped = iterable.map(doubleWithLog).skip(2);
  print("创建skipped后，转换次数: $transformCount"); // 应该是0

  print("开始迭代：");
  var skippedResult = skipped.toList();
  print("迭代完成后，转换次数: $transformCount"); // 应该是5
  print("结果: $skippedResult");

  // 测试reversed的懒加载
  print("\n6. 测试reversed懒加载：");
  var reversed = iterable.reversed;
  var reversedResult = reversed.toList();
  print("结果: $reversedResult");

  // 测试followedBy的懒加载
  print("\n7. 测试followedBy懒加载：");
  var other = SimpleIterable([6, 7, 8]);
  var followed = iterable.followedBy(other);
  var followedResult = followed.toList();
  print("结果: $followedResult");

  // 测试expand的懒加载
  print("\n8. 测试expand懒加载：");
  var nestedIterable = SimpleIterable([
    [1, 2],
    [3, 4],
    [5]
  ]);
  var expanded = nestedIterable.expand((x) => x);
  var expandedResult = expanded.toList();
  print("结果: $expandedResult");

  // 验证CppList的方法使用了继承的实现
  print("\n9. 测试CppList使用继承的方法：");
  var cppList = CppList<int>.from([1, 2, 3, 4, 5]);

  transformCount = 0;
  var cppMapped = cppList.map(doubleWithLog);
  print("CppList创建mapped后，转换次数: $transformCount"); // 应该是0

  print("开始迭代：");
  var cppMappedResult = cppMapped.toList();
  print("CppList迭代完成后，转换次数: $transformCount"); // 应该是5
  print("CppList map结果: $cppMappedResult");
  print("CppList map结果类型: ${cppMappedResult.runtimeType}");

  print("\n=== 懒加载测试完成 ===");
}
