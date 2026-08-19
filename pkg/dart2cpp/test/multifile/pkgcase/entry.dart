// 多 package 测试 — 入口：import 两个 package 的库，覆盖
// 跨包继承 / 跨包调用 / 跨包同名类消歧 / package: 库的多文件发射
import 'package:demo_pkg/animal.dart' as pkg;
import 'package:demo_pkg/util.dart';
import 'package:demo_core/base.dart';

// 与 demo_pkg 的 Dog 同名 —— 测试跨包改名消歧
class Dog {
  final String name;
  Dog(this.name);

  String bark() => '$name: woof (entry)';
}

void main() {
  // 同名类（入口 Dog vs demo_pkg Dog）
  final local = Dog('Local');
  final remote = pkg.Dog('Remote');
  print(local.bark());
  print(remote.bark());

  // 跨包继承 + 虚派发（Pet→Entity 跨包）
  final Entity e = pkg.Pet('p1', 'Kitty');
  print(e.identify());
  print(formatPet(pkg.Pet('p2', 'Rex')));

  // 跨包顶层函数调用链（entry→util→core）
  print('coreHelper(5)=${coreHelper(5)}');
  print('pkgHelper(5)=${pkgHelper(5)}');

  print('done');
}
