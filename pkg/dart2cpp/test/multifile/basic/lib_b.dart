// 多文件测试 — 库 B：依赖库 A（跨库继承 / 调用 / 泛型），
// 并定义与库 A 同名的 Dog 类（测试跨库改名消歧）
import 'lib_a.dart';

class Dog {
  final String name;
  final int age;
  Dog(this.name, this.age);

  String bark() => '$name: Woooof!';
  int dogYears() => age * 7;
}

// 跨库继承：父类 Animal 定义在 lib_a.dart
class Cat extends Animal {
  Cat(String name) : super(name);

  @override
  String speak() => '$name: Meow!';
}

// 跨库接口：抽象类 + 实现
abstract class Greeter {
  String greet(String who);
}

class FriendlyGreeter implements Greeter {
  @override
  String greet(String who) => 'Hello, $who!';
}

// 增强枚举（带成员 + 自定义方法），跨库使用
enum Color {
  red('#ff0000'),
  green('#00ff00'),
  blue('#0000ff');

  final String hex;
  const Color(this.hex);

  String describe() => 'Color($hex)';

  @override
  String toString() => describe();
}

String describeColor(Color c) => c.describe();

// 跨库泛型实例化：Box 定义在 lib_a.dart
String boxRoundTrip(String s) {
  final b = Box<String>(s);
  return b.get();
}

// 跨库顶层函数调用
int helperB(int x) => helperA(x) + 1;
