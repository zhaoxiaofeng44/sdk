// 测试所有函数相关表达式的转换

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

// 4. 函数引用（Tear-off）
Function getAddFunction() {
  return add;
}

// 5. 高阶函数
Function createMultiplier(int factor) {
  return (int value) => value * factor;
}

// 6. 匿名函数
void testAnonymousFunction() {
  var result = calculate(10, 5, (int a, int b) => a + b);
  print('匿名函数结果: $result');
}

// 7. 函数变量赋值
Function? operation;

void testFunctionAssignment() {
  operation = add;
  var result = operation!(10, 5);
  print('函数变量赋值结果: $result');
}

// 8. 函数数组
List<Function> operations = [add, subtract, multiply];

void testFunctionList() {
  var result = operations[0](10, 5);
  print('函数数组结果: $result');
}

// 主函数
void main() {
  // 测试普通函数
  var result1 = calculate(10, 5, add);
  print('10 + 5 = $result1');
  
  // 测试 Lambda 函数
  var result2 = calculate(10, 5, multiply);
  print('10 * 5 = $result2');
  
  // 测试函数引用
  var addFunc = getAddFunction();
  var result3 = addFunc(10, 5);
  print('函数引用结果: $result3');
  
  // 测试高阶函数
  var multiplier = createMultiplier(3);
  var result4 = multiplier(5);
  print('高阶函数结果: $result4');
  
  // 测试匿名函数
  testAnonymousFunction();
  
  // 测试函数变量赋值
  testFunctionAssignment();
  
  // 测试函数数组
  testFunctionList();
}