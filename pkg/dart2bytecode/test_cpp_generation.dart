// 测试 C++ 代码生成的简单示例

@pragma('cpp:native', 'NativeCalculator')
abstract class NativeCalculator {
  static double add(double a, double b) => throw UnimplementedError();
}

class SimpleCalculator {
  double value = 0.0;

  SimpleCalculator(this.value);

  double add(double other) {
    value = value + other;
    return value;
  }

  double multiply(double factor) {
    return value * factor;
  }

  bool isPositive() {
    return value > 0.0;
  }

  String toString() {
    return 'Calculator: $value';
  }

  static SimpleCalculator create() {
    return SimpleCalculator(0.0);
  }
}

void main() {
  SimpleCalculator calc = SimpleCalculator(10.0);
  double result = calc.add(5.0);
  bool positive = calc.isPositive();

  print('Result: $result');
  print('Is positive: $positive');

  // 使用原生方法
  double nativeResult = NativeCalculator.add(10.0, 20.0);
  print('Native result: $nativeResult');
}

