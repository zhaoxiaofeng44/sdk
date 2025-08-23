import '../lib/demo/num.dart';
import '../lib/demo/box.dart';

void main() {
  print('完整闭包装箱测试...');

  // 测试场景1：基本闭包装箱
  testBasicClosureBoxing();

  // 测试场景2：函数参数装箱
  testFunctionParameterBoxing();

  // 测试场景3：嵌套闭包
  testNestedClosureBoxing();

  // 测试场景4：混合类型装箱
  testMixedTypeBoxing();

  print('完整闭包装箱测试完成！');
}

void testBasicClosureBoxing() {
  print('\n=== 测试基本闭包装箱 ===');

  // 模拟转换后的代码
  Box<Int> counter = Box(Int(0));
  Box<String> message = Box("Hello");

  void increment() {
    // 在函数开头应该有：
    // Box<Int> counter = $_counter;
    // Box<String> message = $_message;

    // 使用 .value 访问
    final newCounter = counter.value.add(Int(1));
    print('${message.value}: ${newCounter.value}');
  }

  increment(); // 应该输出: Hello: 1
  increment(); // 应该输出: Hello: 2
}

void testFunctionParameterBoxing() {
  print('\n=== 测试函数参数装箱 ===');

  void processValues(Box<Int> $_value1, Box<String> $_value2) {
    // 在函数开头应该有：
    // Box<Int> value1 = $_value1;
    // Box<String> value2 = $_value2;

    Box<Int> value1 = $_value1;
    Box<String> value2 = $_value2;

    print('处理值: ${value1.value.value}, ${value2.value}');
  }

  final intBox = Box(Int(42));
  final stringBox = Box("World");
  processValues(intBox, stringBox);
}

void testNestedClosureBoxing() {
  print('\n=== 测试嵌套闭包装箱 ===');

  Box<Int> outerCounter = Box(Int(0));
  Box<String> outerMessage = Box("Outer");

  void outerFunction() {
    Box<Int> innerCounter = Box(Int(10));
    Box<String> innerMessage = Box("Inner");

    void innerFunction() {
      // 应该能够访问所有外部变量
      final newOuterCounter = outerCounter.value.add(Int(1));
      final newInnerCounter = innerCounter.value.add(Int(1));

      print('外层: ${outerMessage.value} ${newOuterCounter.value}');
      print('内层: ${innerMessage.value} ${newInnerCounter.value}');
    }

    innerFunction();
  }

  outerFunction();
}

void testMixedTypeBoxing() {
  print('\n=== 测试混合类型装箱 ===');

  Box<Int> number = Box(Int(42));
  Box<String> text = Box("Answer");
  Box<Bool> flag = Box(Bool(true));
  Box<Double> pi = Box(Double(3.14));

  void mixedClosure() {
    // 在函数开头应该有：
    // Box<Int> number = $_number;
    // Box<String> text = $_text;
    // Box<Bool> flag = $_flag;
    // Box<Double> pi = $_pi;

    // 模拟函数参数
    Box<Int> localNumber = number;
    Box<String> localText = text;
    Box<Bool> localFlag = flag;
    Box<Double> localPi = pi;

    if (localFlag.value.toBool()) {
      final result = localText.value + ": " + localNumber.value.toString();
      print(result);
      print('Pi值: ${localPi.value.value}');
    }
  }

  // 模拟函数调用
  mixedClosure();
}
