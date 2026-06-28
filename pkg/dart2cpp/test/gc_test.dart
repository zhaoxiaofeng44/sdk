// ============================================================================
// GC 标记-清除端到端测试
// 模拟 restorer 生成的代码模式，全面验证 GC 能力
// ============================================================================
import 'package:dart2cpp/platform/dart/runtime_classes.dart';

// ============================================================================
// 模拟 restored 代码：Node 类（树结构，验证递归标记）
// ============================================================================
class NodeValue extends VPtr {
  late String name;
  late NodeValue? left;
  late NodeValue? right;

  static Map<String, dynamic>? vptrMap;
  @override
  Map<String, dynamic> get vptr => getVptrMap();
  static Map<String, dynamic> getVptrMap() {
    if (vptrMap == null) {
      vptrMap = <String, dynamic>{'toString': null, 'operatorEq': null, 'get_hashCode': null};
      vptrMap!['toString'] = Node_toString;
    }
    return vptrMap!;
  }

  NodeValue() {}

  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
    if (left is AnyGC) (left as AnyGC).gcMark(flag);
    if (right is AnyGC) (right as AnyGC).gcMark(flag);
  }
}

NodeValue Node_new(dynamic this__, String name, {NodeValue? left, NodeValue? right}) {
  final this_ = this__ as NodeValue;
  this_.name = name;
  this_.left = left;
  this_.right = right;
  return this_;
}

String Node_toString(dynamic this__) {
  final this_ = this__ as NodeValue;
  return 'Node(${this_.name})';
}

// ============================================================================
// 模拟 restored 代码：Container 泛型类
// ============================================================================
class ContainerValue<T> extends VPtr {
  late T value;

  static Map<String, dynamic>? vptrMap;
  @override
  Map<String, dynamic> get vptr => getVptrMap();
  static Map<String, dynamic> getVptrMap() {
    if (vptrMap == null) {
      vptrMap = <String, dynamic>{'toString': null, 'operatorEq': null, 'get_hashCode': null};
    }
    return vptrMap!;
  }

  @override
  void gcMark(int flag) {
    if (gcFlag == flag) return;
    super.gcMark(flag);
    if (value is AnyGC) (value as AnyGC).gcMark(flag);
  }
}

ContainerValue<T> Container_new<T>(dynamic this__, T value) {
  final this_ = this__ as ContainerValue<T>;
  this_.value = value;
  return this_;
}

// ============================================================================
// 模拟 restored 代码：Registry 类（含静态字段 → allocateGlobal）
// ============================================================================
class RegistryValue extends VPtr {
  static Map<String, dynamic>? vptrMap;
  @override
  Map<String, dynamic> get vptr => getVptrMap();
  static Map<String, dynamic> getVptrMap() {
    if (vptrMap == null) {
      vptrMap = <String, dynamic>{'toString': null, 'operatorEq': null, 'get_hashCode': null};
    }
    return vptrMap!;
  }
}

// 静态字段 → allocateGlobal 包裹 Value 创建（与 restorer 生成的格式一致）
NodeValue Registry_defaultNode = Node_new(GC.allocateGlobal(NodeValue()), 'default');

// 顶层变量 → allocateGlobal
NodeValue globalRoot = Node_new(GC.allocateGlobal(NodeValue()), 'globalRoot');

// ============================================================================
// 测试工具
// ============================================================================
int _passed = 0;
int _failed = 0;

void _assert(bool condition, String message) {
  if (!condition) {
    _failed++;
    print('  ❌ FAIL: $message');
  } else {
    _passed++;
    print('  ✅ $message');
  }
}

// ============================================================================
// 测试用例
// ============================================================================
void main() {
  print('=== GC 标记-清除端到端测试 ===\n');

  test1_allocateLocal();
  test2_noRootCollectAll();
  test3_rootPreservesChain();
  test4_allocateGlobalAsRoot();
  test5_genericContainer();
  test6_circularReference();
  test7_multiRoundGC();
  test8_boxGC();
  test9_basicBox();
  test10_deepTree();
  test11_staticFieldAsRoot();
  test12_returnType();

  print('\n=== 结果: $_passed 通过, $_failed 失败 ===');
  if (_failed > 0) throw Exception('$_failed 个测试失败');
}

void test1_allocateLocal() {
  print('--- 1. allocateLocal 注册 ---');
  GC.reset();
  Node_new(GC.allocateLocal(NodeValue()), 'A');
  Node_new(GC.allocateLocal(NodeValue()), 'B');
  Node_new(GC.allocateLocal(NodeValue()), 'C');
  _assert(GC.objectCount == 3, '3 个局部对象已注册');
  _assert(GC.rootCount == 0, '无 root');
}

void test2_noRootCollectAll() {
  print('\n--- 2. 无 root 全部回收 ---');
  GC.reset();
  Node_new(GC.allocateLocal(NodeValue()), 'A');
  Node_new(GC.allocateLocal(NodeValue()), 'B');
  final collected = GC.collect();
  _assert(collected == 2, '回收 2 个 (实际: $collected)');
  _assert(GC.objectCount == 0, '剩余 0');
}

void test3_rootPreservesChain() {
  print('\n--- 3. root 保留引用链 ---');
  GC.reset();
  final root = Node_new(GC.allocateGlobal(NodeValue()), 'root');
  final child1 = Node_new(GC.allocateLocal(NodeValue()), 'child1');
  final child2 = Node_new(GC.allocateLocal(NodeValue()), 'child2');
  Node_new(GC.allocateLocal(NodeValue()), 'orphan');
  root.left = child1;
  root.right = child2;
  _assert(GC.objectCount == 4, '总 4 个对象');

  final collected = GC.collect();
  _assert(collected == 1, '回收 orphan (实际: $collected)');
  _assert(GC.objectCount == 3, '保留 root+child1+child2');
}

void test4_allocateGlobalAsRoot() {
  print('\n--- 4. allocateGlobal 自动成为 root ---');
  GC.reset();
  Node_new(GC.allocateGlobal(NodeValue()), 'global');
  Node_new(GC.allocateLocal(NodeValue()), 'local');
  _assert(GC.rootCount == 1, 'root 数 == 1');
  _assert(GC.objectCount == 2, '总对象数 == 2');

  GC.collect();
  _assert(GC.objectCount == 1, '仅保留 global');
  _assert(GC.rootCount == 1, 'root 仍为 1');
}

void test5_genericContainer() {
  print('\n--- 5. 泛型容器递归标记 ---');
  GC.reset();
  final inner = Node_new(GC.allocateLocal(NodeValue()), 'inner');
  final container = Container_new<NodeValue>(
      GC.allocateGlobal(ContainerValue<NodeValue>()), inner);
  Node_new(GC.allocateLocal(NodeValue()), 'garbage');
  _assert(GC.objectCount == 3, '总 3 个对象');

  final collected = GC.collect();
  _assert(collected == 1, '回收 garbage (实际: $collected)');
  _assert(GC.objectCount == 2, '保留 container+inner');
}

void test6_circularReference() {
  print('\n--- 6. 循环引用不死循环 ---');
  GC.reset();
  final a = Node_new(GC.allocateGlobal(NodeValue()), 'cycleA');
  final b = Node_new(GC.allocateLocal(NodeValue()), 'cycleB');
  a.left = b;
  b.left = a;
  Node_new(GC.allocateLocal(NodeValue()), 'outside');

  final collected = GC.collect();
  _assert(collected == 1, '回收 outside (实际: $collected)');
  _assert(GC.objectCount == 2, '循环对象都保留');
}

void test7_multiRoundGC() {
  print('\n--- 7. 多轮 GC ---');
  GC.reset();
  Node_new(GC.allocateGlobal(NodeValue()), 'persistent');
  Node_new(GC.allocateLocal(NodeValue()), 'temp1');
  Node_new(GC.allocateLocal(NodeValue()), 'temp2');
  _assert(GC.objectCount == 3, '第一轮前 3 个');

  GC.collect();
  _assert(GC.objectCount == 1, '第一轮后 1 个');

  Node_new(GC.allocateLocal(NodeValue()), 'temp3');
  GC.collect();
  _assert(GC.objectCount == 1, '第二轮后仍 1 个');

  Node_new(GC.allocateLocal(NodeValue()), 'temp4');
  Node_new(GC.allocateLocal(NodeValue()), 'temp5');
  GC.collect();
  _assert(GC.objectCount == 1, '第三轮后仍 1 个');
}

void test8_boxGC() {
  print('\n--- 8. ObjectBox 递归标记 ---');
  GC.reset();
  final boxedNode = Node_new(GC.allocateLocal(NodeValue()), 'boxed');
  final objBox = GC.allocateGlobal(ObjectBox<NodeValue>(boxedNode));
  Node_new(GC.allocateLocal(NodeValue()), 'garbage');
  _assert(GC.objectCount == 3, 'Box 测试 3 个对象');

  final collected = GC.collect();
  _assert(collected == 1, '回收 garbage (实际: $collected)');
  _assert(GC.objectCount == 2, '保留 objBox+boxed');
}

void test9_basicBox() {
  print('\n--- 9. 基础 Box 自动注册 ---');
  GC.reset();
  IntBox(42);
  DoubleBox(3.14);
  StringBox('hello');
  BoolBox(true);
  _assert(GC.objectCount == 4, '4 个基础 Box 已注册');

  GC.collect();
  _assert(GC.objectCount == 0, '无 root 全回收');
}

void test10_deepTree() {
  print('\n--- 10. 深层树递归标记 ---');
  GC.reset();
  final leaf = Node_new(GC.allocateLocal(NodeValue()), 'leaf');
  final l3 = Node_new(GC.allocateLocal(NodeValue()), 'L3');
  l3.left = leaf;
  final l2 = Node_new(GC.allocateLocal(NodeValue()), 'L2');
  l2.left = l3;
  final l1 = Node_new(GC.allocateLocal(NodeValue()), 'L1');
  l1.left = l2;
  final deepRoot = Node_new(GC.allocateGlobal(NodeValue()), 'deepRoot');
  deepRoot.left = l1;

  Node_new(GC.allocateLocal(NodeValue()), 'orphan1');
  Node_new(GC.allocateLocal(NodeValue()), 'orphan2');
  Node_new(GC.allocateLocal(NodeValue()), 'orphan3');
  _assert(GC.objectCount == 8, '总 8 个对象');

  final collected = GC.collect();
  _assert(collected == 3, '回收 3 个孤立对象 (实际: $collected)');
  _assert(GC.objectCount == 5, '保留 deepRoot→L1→L2→L3→leaf');
}

void test11_staticFieldAsRoot() {
  print('\n--- 11. 静态字段作为 root ---');
  GC.reset();
  final staticNode = Node_new(GC.allocateGlobal(NodeValue()), 'static');
  final child = Node_new(GC.allocateLocal(NodeValue()), 'staticChild');
  staticNode.left = child;
  Node_new(GC.allocateLocal(NodeValue()), 'garbage');

  final collected = GC.collect();
  _assert(collected == 1, '回收 garbage (实际: $collected)');
  _assert(GC.objectCount == 2, '保留 static+child');
}

void test12_returnType() {
  print('\n--- 12. 返回值泛型类型正确 ---');
  GC.reset();
  NodeValue typedLocal = Node_new(GC.allocateLocal(NodeValue()), 'typed');
  NodeValue typedGlobal = Node_new(GC.allocateGlobal(NodeValue()), 'global');
  ContainerValue<NodeValue> typedContainer = Container_new<NodeValue>(
      GC.allocateLocal(ContainerValue<NodeValue>()), typedLocal);
  _assert(typedLocal.name == 'typed', 'allocateLocal 返回正确类型');
  _assert(typedGlobal.name == 'global', 'allocateGlobal 返回正确类型');
  _assert(typedContainer.value == typedLocal, 'Container 泛型返回正确');
}
