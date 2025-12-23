/// 闭包变量捕获功能测试

void main() {
  // 测试1: 基础闭包 - 捕获局部变量
  testBasicClosure();

  // 测试2: 闭包捕获多个变量
  testMultipleCapture();

  // 测试3: 成员函数引用 - 捕获this
  testMemberFunctionCapture();

  // 测试4: 闭包在循环中
  testClosureInLoop();

  // 测试5: 嵌套闭包
  testNestedClosure();
}

// 测试1: 基础闭包捕获
void testBasicClosure() {
  print("Test 1: Basic Closure");

  int x = 10;

  var addX = (int y) {
    return x + y; // 捕获外部变量x
  };

  print(addX(5)); // 应该输出15
}

// 测试2: 捕获多个变量
void testMultipleCapture() {
  print("Test 2: Multiple Variable Capture");

  int a = 5;
  int b = 10;
  String prefix = "Result: ";

  var compute = () {
    int sum = a + b; // 捕获a和b
    return prefix + sum.toString(); // 捕获prefix
  };

  print(compute()); // 应该输出"Result: 15"
}

// 测试3: 成员函数捕获
class Calculator {
  int base;

  Calculator(this.base);

  Function makeAdder() {
    // 这个闭包应该捕获this
    return (int x) => base + x;
  }
}

void testMemberFunctionCapture() {
  print("Test 3: Member Function Capture");

  var calc = Calculator(100);
  var adder = calc.makeAdder();
  print(adder(23)); // 应该输出123
}

// 测试4: 循环中的闭包
void testClosureInLoop() {
  print("Test 4: Closure in Loop");

  List<Function> functions = [];

  for (int i = 0; i < 3; i++) {
    // 每个闭包应该捕获当前的i值
    functions.add(() => i);
  }

  // 注意：Dart的for循环会为每次迭代创建新的i变量
  for (var f in functions) {
    print(f());
  }
}

// 测试5: 嵌套闭包
void testNestedClosure() {
  print("Test 5: Nested Closure");

  int outer = 1;

  var outerFunc = () {
    int middle = 10;

    var innerFunc = () {
      return outer + middle; // 捕获outer和middle
    };

    return innerFunc();
  };

  print(outerFunc()); // 应该输出11
}
