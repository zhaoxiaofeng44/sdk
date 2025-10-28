// Example Dart code to test conversion

void main() {
  // 1. 基本类型
  var x = 5;
  int y = 10;
  double pi = 3.14;
  bool flag = true;
  String name = "Dart";

  // 2. 运算符
  var sum = x + y;
  var product = x * 2;
  var isPositive = x > 0;

  // 3. 字符串操作
  String greeting = "Hello, " + name;
  var length = greeting.length;
  var upper = greeting.toUpperCase();

  // 4. 集合
  List<int> numbers = [];
  numbers.add(1);
  numbers.add(2);
  numbers.add(3);

  Set<String> names = {};
  names.add("Alice");
  names.add("Bob");

  Map<String, int> ages = {};
  ages["Alice"] = 25;
  ages["Bob"] = 30;

  // 5. 控制流
  if (flag) {
    print("Flag is true");
  }

  for (int i = 0; i < 5; i++) {
    print(i);
  }

  for (var num in numbers) {
    print(num);
  }

  // 6. 类型转换
  String numStr = x.toString();
  var parsed = int.parse("42");

  // 7. 数学运算
  var division = y ~/ 3;
  var modulo = y % 3;
}
