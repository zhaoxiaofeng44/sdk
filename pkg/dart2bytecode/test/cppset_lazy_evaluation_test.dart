import '../lib/demo/Iterable.dart';
import '../lib/demo/collection.dart';

void main() {
  print("=== 测试CppSet懒加载功能 ===");

  // 创建一个会打印信息的转换函数来验证懒加载
  int transformCount = 0;
  T doubleWithLog<T extends num>(T x) {
    print("  转换: $x -> ${x * 2}");
    transformCount++;
    return (x * 2) as T;
  }

  // 创建一个会打印信息的过滤函数来验证懒加载
  int filterCount = 0;
  bool isEvenWithLog(int x) {
    print("  过滤检查: $x");
    filterCount++;
    return x % 2 == 0;
  }

  var cppSet = CppSet<int>();
  cppSet.add(1);
  cppSet.add(2);
  cppSet.add(3);
  cppSet.add(4);
  cppSet.add(5);

  print("原始CppSet: $cppSet");

  // 测试map的懒加载
  print("\n1. 测试CppSet map懒加载：");
  transformCount = 0;
  var mapped = cppSet.map(doubleWithLog);
  print("创建mapped后，转换次数: $transformCount"); // 应该是0，因为懒加载

  print("开始迭代：");
  var result = mapped.toList();
  print("迭代完成后，转换次数: $transformCount"); // 应该是5
  print("结果: $result");
  print("结果类型: ${result.runtimeType}");

  // 测试where的懒加载
  print("\n2. 测试CppSet where懒加载：");
  filterCount = 0;
  var filtered = cppSet.where(isEvenWithLog);
  print("创建filtered后，过滤次数: $filterCount"); // 应该是0

  print("开始迭代：");
  var filteredResult = filtered.toList();
  print("迭代完成后，过滤次数: $filterCount"); // 应该是5
  print("结果: $filteredResult");
  print("结果类型: ${filteredResult.runtimeType}");

  // 测试链式懒加载
  print("\n3. 测试CppSet链式懒加载：");
  transformCount = 0;
  filterCount = 0;

  var chained = cppSet.map(doubleWithLog).where(isEvenWithLog);

  print("创建链式操作后，转换次数: $transformCount, 过滤次数: $filterCount");

  print("开始迭代：");
  var chainedResult = chained.toList();
  print("迭代完成后，转换次数: $transformCount, 过滤次数: $filterCount");
  print("结果: $chainedResult");
  print("结果类型: ${chainedResult.runtimeType}");

  // 测试other methods
  print("\n4. 测试其他继承的方法：");
  print("any(x > 3): ${cppSet.any((x) => x > 3)}");
  print("every(x > 0): ${cppSet.every((x) => x > 0)}");
  print("firstWhere(x > 3): ${cppSet.firstWhere((x) => x > 3)}");
  print("lastWhere(x < 4): ${cppSet.lastWhere((x) => x < 4)}");
  print("fold(求和): ${cppSet.fold(0, (sum, x) => sum + x)}");
  print("reduce(求和): ${cppSet.reduce((a, b) => a + b)}");
  print("连接字符串: ${cppSet.join(", ")}");

  // 测试expand
  print("\n5. 测试CppSet expand懒加载：");
  var nestedSet = CppSet<List<int>>();
  nestedSet.add([1, 2]);
  nestedSet.add([3, 4]);
  nestedSet.add([5]);

  var expanded = nestedSet.expand((x) => x);
  var expandedResult = expanded.toList();
  print("expand结果: $expandedResult");
  print("expand结果类型: ${expandedResult.runtimeType}");

  // 测试followedBy
  print("\n6. 测试CppSet followedBy懒加载：");
  var otherSet = CppSet<int>();
  otherSet.add(6);
  otherSet.add(7);
  otherSet.add(8);

  var followed = cppSet.followedBy(otherSet);
  var followedResult = followed.toList();
  print("followedBy结果: $followedResult");
  print("followedBy结果类型: ${followedResult.runtimeType}");

  // 测试whereType
  print("\n7. 测试CppSet whereType懒加载：");
  var mixedSet = CppSet<Object>();
  mixedSet.add(1);
  mixedSet.add("hello");
  mixedSet.add(2);
  mixedSet.add("world");
  mixedSet.add(3);

  var intsOnly = mixedSet.whereType<int>();
  var intsOnlyResult = intsOnly.toList();
  print("whereType<int>结果: $intsOnlyResult");
  print("whereType<int>结果类型: ${intsOnlyResult.runtimeType}");

  print("\n=== CppSet懒加载测试完成 ===");
}
