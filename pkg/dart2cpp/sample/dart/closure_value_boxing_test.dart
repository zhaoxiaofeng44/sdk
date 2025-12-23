/// 闭包值类型自动装箱测试

void main() {
  testBasicValueBoxing();
  testParameterBoxing();
  testLocalVarBoxing();
  testMixedBoxing();
}

// 测试1: 基础值类型装箱
void testBasicValueBoxing() {
  print("Test 1: Basic Value Type Boxing");

  int x = 10;

  var increment = () {
    x = x + 1; // x被闭包持有，需要装箱
  };

  print("Before: $x");
  increment();
  print("After: $x");
}

// 测试2: 参数装箱
void testParameterBoxing() {
  print("Test 2: Parameter Boxing");

  makeCounter(int start) {
    return () {
      start = start + 1; // start是参数，被闭包持有，需要装箱
      return start;
    };
  }

  var counter = makeCounter(0);
  print(counter());
  print(counter());
  print(counter());
}

// 测试3: 局部变量装箱
void testLocalVarBoxing() {
  print("Test 3: Local Variable Boxing");

  int count = 0;
  String prefix = "Count: ";

  var incrementAndPrint = () {
    count = count + 1; // count被闭包持有，需要装箱
    print(prefix + count.toString()); // prefix也被持有，需要装箱
  };

  incrementAndPrint();
  incrementAndPrint();
  incrementAndPrint();
}

// 测试4: 混合装箱
void testMixedBoxing() {
  print("Test 4: Mixed Boxing");

  makeAccumulator(int initial) {
    double multiplier = 2.0;

    return (int value) {
      initial = initial + value; // initial是参数，需要装箱
      return initial * multiplier; // multiplier是局部变量，需要装箱
    };
  }

  var acc = makeAccumulator(10);
  print(acc(5)); // (10+5)*2 = 30
  print(acc(3)); // (15+3)*2 = 36
}
