// 多 package 测试 — 基础包 demo_core：被 demo_pkg 依赖
class Entity {
  final String id;
  Entity(this.id);

  String identify() => 'Entity#$id';
}

int coreHelper(int x) => x + 100;
