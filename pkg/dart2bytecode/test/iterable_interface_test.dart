import '../lib/demo/Iterable.dart';

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
  // 测试基本功能
  print("=== 测试基本功能 ===");
  var iterable = SimpleIterable([1, 2, 3, 4, 5]);

  print("长度: ${iterable.length}");
  print("是否为空: ${iterable.isEmpty}");
  print("是否非空: ${iterable.isNotEmpty}");
  print("第一个元素: ${iterable.first}");
  print("最后一个元素: ${iterable.last}");
  print("第3个元素: ${iterable.elementAt(2)}");

  // 测试映射
  print("\n=== 测试映射 ===");
  var mapped = iterable.map((x) => x * 2);
  print("映射结果: ${mapped.toList()}");

  // 测试过滤
  print("\n=== 测试过滤 ===");
  var filtered = iterable.where((x) => x > 3);
  print("过滤结果: ${filtered.toList()}");

  // 测试类型过滤
  print("\n=== 测试类型过滤 ===");
  var mixedIterable = SimpleIterable([1, "a", 2, "b", 3]);
  var intOnly = mixedIterable.whereType<int>();
  print("类型过滤结果: ${intOnly.toList()}");

  // 测试展开
  print("\n=== 测试展开 ===");
  var nestedIterable = SimpleIterable([
    [1, 2],
    [3, 4],
    [5]
  ]);
  var expanded = nestedIterable.expand((x) => x);
  print("展开结果: ${expanded.toList()}");

  // 测试take和skip
  print("\n=== 测试take和skip ===");
  var taken = iterable.take(3);
  print("取前3个: ${taken.toList()}");
  var skipped = iterable.skip(2);
  print("跳过前2个: ${skipped.toList()}");

  // 测试takeWhile和skipWhile
  print("\n=== 测试takeWhile和skipWhile ===");
  var takenWhile = iterable.takeWhile((x) => x < 4);
  print("取小于4的: ${takenWhile.toList()}");
  var skippedWhile = iterable.skipWhile((x) => x < 3);
  print("跳过小于3的: ${skippedWhile.toList()}");

  // 测试反转
  print("\n=== 测试反转 ===");
  var reversed = iterable.reversed;
  print("反转结果: ${reversed.toList()}");

  // 测试连接
  print("\n=== 测试连接 ===");
  var other = SimpleIterable([6, 7, 8]);
  var followed = iterable.followedBy(other);
  print("连接结果: ${followed.toList()}");

  // 测试类型转换
  print("\n=== 测试类型转换 ===");
  var numIterable = SimpleIterable<num>([1, 2, 3]);
  var intCast = numIterable.cast<int>();
  print("类型转换结果: ${intCast.toList()}");

  // 测试聚合函数
  print("\n=== 测试聚合函数 ===");
  print("是否包含3: ${iterable.contains(3)}");
  print("是否包含10: ${iterable.contains(10)}");
  print("是否存在大于3的: ${iterable.any((x) => x > 3)}");
  print("是否所有都大于0: ${iterable.every((x) => x > 0)}");
  print("是否所有都大于3: ${iterable.every((x) => x > 3)}");

  // 测试查找
  print("\n=== 测试查找 ===");
  print("第一个大于3的: ${iterable.firstWhere((x) => x > 3)}");
  print("最后一个小于4的: ${iterable.lastWhere((x) => x < 4)}");

  // 测试归约和折叠
  print("\n=== 测试归约和折叠 ===");
  print("求和(reduce): ${iterable.reduce((a, b) => a + b)}");
  print("求和(fold): ${iterable.fold(0, (a, b) => a + b)}");
  print("求积(fold): ${iterable.fold(1, (a, b) => a * b)}");

  // 测试连接字符串
  print("\n=== 测试连接字符串 ===");
  print("连接: ${iterable.join(", ")}");
  print("连接(无分隔符): ${iterable.join()}");

  // 测试forEach
  print("\n=== 测试forEach ===");
  print("元素遍历: ");
  iterable.forEach((x) => print("  $x"));

  print("\n=== 测试完成 ===");
}
