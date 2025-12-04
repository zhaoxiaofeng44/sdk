import '../lib/demo/num.dart';
import '../lib/demo/box.dart';

void main() {
  print('闭包装箱示例测试...');

  // 示例：闭包函数中的外部变量装箱
  // 原始代码：
  // int g1 = 10;
  // String g2 = "Hello";
  // void example() {
  //   void closure() {
  //     print(g1);  // 应该变成 g1.value
  //     print(g2);  // 应该变成 g2.value
  //   }
  //   closure();
  // }

  // 转换后的代码应该是：
  Box<Int> g1 = Box(Int(10));
  Box<String> g2 = Box("Hello");

  void example() {
    void closure() {
      // 在函数开头应该有：
      // Box<Int> g1 = $_g1;
      // Box<String> g2 = $_g2;

      print(g1.value.value); // 使用 .value 访问
      print(g2.value); // 使用 .value 访问
    }

    closure();
  }

  example();

  print('闭包装箱示例测试完成！');
}
