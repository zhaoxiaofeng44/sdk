/// 多接口回归：class Doc implements Printable, Serializable
/// 验证 ClassInfo::slots 扁平表能正确派发两个接口的方法，
/// 且不再依赖「只继承第一个接口」的 C++ 结构体布局。
library;

abstract class Printable {
  String render();
}

abstract class Serializable {
  String toJson();
}

class Doc implements Printable, Serializable {
  @override
  String render() => 'RENDER';

  @override
  String toJson() => 'JSON';
}

class Note implements Printable, Serializable {
  final String text;
  Note(this.text);

  @override
  String render() => 'NOTE:$text';

  @override
  String toJson() => '{"text":"$text"}';
}

void main() {
  print('=== multi_iface_test ===');

  // 直接调用
  final doc = Doc();
  print(doc.render());
  print(doc.toJson());

  // 经 Object 擦除 + as 转型（此前会静默调错方法）
  Object o = Doc();
  final p = o as Printable;
  final s = o as Serializable;
  print(p.render());
  print(s.toJson());

  // 另一实现类
  Object n = Note('hi');
  final np = n as Printable;
  final ns = n as Serializable;
  print(np.render());
  print(ns.toJson());

  // is 判定（走 inherits）
  print(doc is Printable);
  print(doc is Serializable);
  print(doc is Note);

  print('=== done ===');
}
