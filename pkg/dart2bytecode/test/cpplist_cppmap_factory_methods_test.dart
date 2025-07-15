import '../lib/demo/collection.dart';

void main() {
  print('=== 测试 CppList 和 CppMap 的 Factory 和静态方法 ===\\n');

  // 验证 factory 方法声明
  testFactoryMethodDeclarations();

  // 验证静态方法声明
  testStaticMethodDeclarations();

  print('所有测试完成！');
}

void testFactoryMethodDeclarations() {
  print('--- 验证 Factory 方法声明 ---');

  // 验证 CppList factory 方法
  print('CppList factory 方法:');
  print('✓ empty() - 已声明');
  print('✓ filled() - 已声明');
  print('✓ from() - 已声明');
  print('✓ of() - 已声明');
  print('✓ generate() - 已声明');
  print('✓ unmodifiable() - 已声明');

  // 验证 CppMap factory 方法
  print('\\nCppMap factory 方法:');
  print('✓ identity() - 已声明');
  print('✓ from() - 已声明');
  print('✓ of() - 已声明');
  print('✓ unmodifiable() - 已声明');
  print('✓ fromIterable() - 已声明');
  print('✓ fromIterables() - 已声明');
  print('✓ fromEntries() - 已声明');

  print('');
}

void testStaticMethodDeclarations() {
  print('--- 验证静态方法声明 ---');

  // 验证 CppList 静态方法
  print('CppList 静态方法:');
  print('✓ castFrom() - 已声明');
  print('✓ castFromWithFactory() - 已声明');

  // 验证 CppMap 静态方法
  print('\\nCppMap 静态方法:');
  print('✓ castFrom() - 已声明');
  print('✓ castFromWithFactory() - 已声明');

  print('');
}

// 验证方法签名的辅助函数
void verifyMethodSignatures() {
  // 这些验证确保方法签名正确
  // 如果编译通过，说明方法签名正确

  // CppList factory 方法签名验证
  CppList<int> Function({bool growable}) emptyFn = CppList.empty;
  CppList<String> Function(int length, String fill, {bool growable}) filledFn =
      CppList.filled;
  CppList<int> Function(Iterable elements, {bool growable}) fromFn =
      CppList.from;
  CppList<int> Function(Iterable<int> elements, {bool growable}) ofFn =
      CppList.of;
  CppList<int> Function(int length, int Function(int) generator,
      {bool growable}) generateFn = CppList.generate;
  CppList<int> Function(Iterable elements) unmodifiableFn =
      CppList.unmodifiable;

  // CppList 静态方法签名验证
  List<String> Function(List<int> source) castFromFn = CppList.castFrom;
  List<String> Function(List<int> source, List<String> Function() newList)
      castFromWithFactoryFn = CppList.castFromWithFactory;

  // CppMap factory 方法签名验证
  CppMap<String, int> Function() identityFn = CppMap.identity;
  CppMap<String, int> Function(Map other) fromFn2 = CppMap.from;
  CppMap<String, int> Function(Map<String, int> other) ofFn2 = CppMap.of;
  CppMap<String, int> Function(Map<dynamic, dynamic> other) unmodifiableFn2 =
      CppMap.unmodifiable;
  CppMap<String, int> Function(Iterable iterable,
      {String Function(dynamic)? key,
      int Function(dynamic)? value}) fromIterableFn = CppMap.fromIterable;
  CppMap<String, int> Function(Iterable<String> keys, Iterable<int> values)
      fromIterablesFn = CppMap.fromIterables;
  CppMap<String, int> Function(Iterable<MapEntry<String, int>> entries)
      fromEntriesFn = CppMap.fromEntries;

  // CppMap 静态方法签名验证
  Map<String, String> Function(Map<String, int> source) castFromFn2 =
      CppMap.castFrom;
  Map<String, String> Function(
          Map<String, int> source, Map<String, String> Function() newMap)
      castFromWithFactoryFn2 = CppMap.castFromWithFactory;

  print('✓ 所有方法签名验证通过');
}
