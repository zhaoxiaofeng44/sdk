/// 测试函数作为参数
int add(int a, int b) {
  return a + b;
}

int subtract(int a, int b) {
  return a - b;
}

int calculate(int a, int b, int Function(int, int) operation) {
  return operation(a, b);
}

void main() {
  int result1 = calculate(10, 5, add);
  print('10 + 5 = $result1');

  int result2 = calculate(10, 5, subtract);
  print('10 - 5 = $result2');
}
