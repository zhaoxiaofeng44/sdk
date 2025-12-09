void main() {
  // 测试基础类型的 -> 运算符
  var x = 10;
  var y = 20;
  
  // 测试 Int 类型
  print('x + y = ${x + y}');
  print('x.abs() = ${x.abs()}');
  
  // 测试 Double 类型
  var d1 = 3.14;
  var d2 = 2.71;
  print('d1 + d2 = ${d1 + d2}');
  print('d1.abs() = ${d1.abs()}');
  
  // 测试 Bool 类型
  var b1 = true;
  var b2 = false;
  print('b1 && b2 = ${b1 && b2}');
  print('b1.toString() = ${b1.toString()}');
}
