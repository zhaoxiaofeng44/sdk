// 简单函数测试

// 1. 普通函数定义
int add(int a, int b) {
  return a + b;
}

int subtract(int a, int b) {
  return a - b;
}

// 2. Lambda 函数表达式
var multiply = (int a, int b) => a * b;

// 3. 函数作为参数传递
int calculate(int a, int b, Function operation) {
  return operation(a, b);
}

// 主函数
void main() {
  // 测试普通函数
  var result1 = calculate(10, 5, add);
  print('10 + 5 = $result1');
  
  // 测试 Lambda 函数
  var result2 = calculate(10, 5, multiply);
  print('10 * 5 = $result2');
}