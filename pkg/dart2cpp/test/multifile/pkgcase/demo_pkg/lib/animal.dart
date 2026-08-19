// 多 package 测试 — demo_pkg：依赖 demo_core（跨包继承 / 调用）
import 'package:demo_core/base.dart';

// 跨包继承：父类 Entity 定义在 demo_core
class Pet extends Entity {
  final String name;
  Pet(String id, this.name) : super(id);

  String describe() => '$name (${identify()})';
}

// 与入口库同名的 Dog（测试跨包同名类改名消歧）
class Dog {
  final String name;
  Dog(this.name);

  String bark() => '$name: woof (pkg)';
}
