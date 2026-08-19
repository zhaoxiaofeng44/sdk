// 多文件测试 — 库 A：基础类、泛型、顶层函数
// 与 lib_b.dart 存在同名类 Dog（测试跨库改名消歧）

class Animal {
  final String name;
  Animal(this.name);

  String speak() => '$name makes a sound';
  String describe() => 'Animal($name)';
}

class Dog {
  final String name;
  Dog(this.name);

  String bark() => '$name: Woof!';
}

class Box<T> {
  T value;
  Box(this.value);

  T get() => value;
  void put(T v) {
    value = v;
  }
}

int helperA(int x) => x * 2;

String whoAmI() => 'lib_a';

Future<int> computeAsync(int x) async {
  return x * 10;
}
