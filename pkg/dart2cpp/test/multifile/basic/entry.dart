// 多文件测试 — 入口：同时 import 两个本地库，覆盖
// 同名类消歧 / 跨库继承与虚派发 / 跨库调用 / 跨库泛型 / 闭包 / 枚举 / async
import 'lib_a.dart' as a;
import 'lib_b.dart' as b;
import 'lib_a.dart' show Animal, Box;

// 与 lib_a.whoAmI 同名 —— 测试顶层函数跨库改名消歧
String whoAmI() => 'entry';

Future<void> main() async {
  // ── 同名类（跨库消歧） ──
  final dogA = a.Dog('Rex');
  final dogB = b.Dog('Buddy', 3);
  print(dogA.bark());
  print(dogB.bark());
  print('dogYears: ${dogB.dogYears()}');

  // ── 跨库继承 + 虚派发（Cat 在 lib_b，Animal 在 lib_a） ──
  final animals = <Animal>[Animal('Generic'), b.Cat('Kitty')];
  for (final animal in animals) {
    print(animal.speak());
  }
  print(animals[1].describe());

  // ── 泛型（Box 定义在 lib_a） ──
  final box = Box<int>(21);
  box.put(box.get() + 1);
  print('box: ${box.get()}');
  print('roundtrip: ${b.boxRoundTrip('multi-file')}');

  // ── 跨库顶层函数调用 ──
  print('helperA(5)=${a.helperA(5)}');
  print('helperB(5)=${b.helperB(5)}');

  // ── 同名顶层函数 ──
  print('whoAmI: ${whoAmI()} / ${a.whoAmI()}');

  // ── 跨库接口 ──
  final b.Greeter g = b.FriendlyGreeter();
  print(g.greet('dart2cpp'));

  // ── 枚举（增强枚举，定义在 lib_b） ──
  print(b.describeColor(b.Color.green));
  print(b.describeColor(b.Color.red));
  print('same: ${b.Color.red == b.Color.red}');
  print('hex: ${b.Color.blue.hex}');

  // ── 闭包捕获跨库对象 ──
  final adder = (int x) => x + dogB.dogYears();
  print('closure: ${adder(1)}');

  // ── 跨库 async ──
  final v = await a.computeAsync(4);
  print('async: $v');

  print('done');
}
