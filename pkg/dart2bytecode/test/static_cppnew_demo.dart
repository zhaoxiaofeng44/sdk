// 静态 cppNew 方法功能演示
// 此测试展示了 cppNew 作为类的静态方法而不是全局函数

class Calculator {
  int value = 0;

  // 构造函数
  Calculator(int initialValue) {
    this.value = initialValue;
  }

  // 加法
  int add(int x) {
    this.value = this.value + x;
    return this.value;
  }

  // 减法
  int subtract(int x) {
    this.value = this.value - x;
    return this.value;
  }

  // 获取当前值
  int getValue() {
    return this.value;
  }
}

class ComplexNumber {
  double real = 0.0;
  double imaginary = 0.0;

  // 构造函数
  ComplexNumber(double r, double i) {
    this.real = r;
    this.imaginary = i;
  }

  // 加法
  ComplexNumber add(ComplexNumber other) {
    return ComplexNumber(
        this.real + other.real, this.imaginary + other.imaginary);
  }

  // 获取模长
  double magnitude() {
    return (this.real * this.real + this.imaginary * this.imaginary);
  }
}

void main() {
  print("=== 静态 cppNew 方法测试 ===");

  // 测试基本计算器
  testCalculator();

  // 测试复数
  testComplexNumber();

  // 测试字面量
  testLiterals();

  print("=== 测试完成 ===");
}

void testCalculator() {
  print("\n--- 测试计算器 ---");

  var calc = Calculator(10);
  print("初始值: ${calc.getValue()}");

  calc.add(5);
  print("加5后: ${calc.getValue()}");

  calc.subtract(3);
  print("减3后: ${calc.getValue()}");
}

void testComplexNumber() {
  print("\n--- 测试复数 ---");

  var c1 = ComplexNumber(3.0, 4.0);
  var c2 = ComplexNumber(1.0, 2.0);

  print("c1 模长: ${c1.magnitude()}");
  print("c2 模长: ${c2.magnitude()}");

  var sum = c1.add(c2);
  print("c1 + c2 模长: ${sum.magnitude()}");
}

void testLiterals() {
  print("\n--- 测试字面量 ---");

  int intVal = 42;
  double doubleVal = 3.14;
  String stringVal = "Hello, World!";
  bool boolVal = true;

  print("整数: $intVal");
  print("浮点数: $doubleVal");
  print("字符串: $stringVal");
  print("布尔值: $boolVal");
}
