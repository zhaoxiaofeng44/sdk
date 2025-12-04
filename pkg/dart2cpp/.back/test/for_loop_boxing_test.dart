import '../lib/demo/box.dart';

void main() {
  print('测试for循环装箱...');

  // 预期的行为：for循环中被闭包捕获的变量应该装箱
  // 模拟转换后的代码

  var list = <void Function()>[];

  // 原始代码：
  // for (var i = 0; i < 3; i++) {
  //   list.add(() => print(i));
  // }

  // 期望转换后：
  // for (var $_i = 0; $_i < 3; $_i++) {
  //   BoxInt i = BoxInt($_i);
  //   list.add(() => print(i.value));
  // }

  for (var _tempI = 0; _tempI < 3; _tempI++) {
    BoxInt i = BoxInt(_tempI);
    list.add(() => print('Value: ${i.value}'));
  }

  // 之后依次调用
  for (var f in list) {
    f();
  }

  print('for循环装箱测试完成！');
}
