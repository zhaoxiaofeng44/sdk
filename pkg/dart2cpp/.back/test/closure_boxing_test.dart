import 'package:test/test.dart';
import '../lib/demo/num.dart';
import '../lib/demo/box.dart';

void main() {
  group('闭包装箱测试', () {
    test('基本闭包装箱功能', () {
      // 测试基本类型的装箱
      final intBox = Box(Int(42));
      final boolBox = Box(Bool(true));
      final doubleBox = Box(Double(3.14));
      final stringBox = Box("Hello");

      expect(intBox.value, equals(Int(42)));
      expect(boolBox.value, equals(Bool(true)));
      expect(doubleBox.value, equals(Double(3.14)));
      expect(stringBox.value, equals("Hello"));
    });

    test('闭包函数中的变量装箱', () {
      // 模拟闭包函数中的外部变量引用
      Box<Int> counter = Box(Int(0));
      Box<String> message = Box("Hello");

      // 模拟闭包函数
      void increment() {
        // 在闭包中，这些变量应该被装箱
        final localCounter = counter; // 应该变成 Box<Int>
        final localMessage = message; // 应该变成 Box<String>

        // 使用.value访问实际值
        expect(localCounter.value, equals(Int(0)));
        expect(localMessage.value, equals("Hello"));
      }

      increment();
    });

    test('函数参数装箱', () {
      // 模拟函数参数装箱
      void processInt(Box<Int> $_value) {
        // 在函数开头应该定义：Box<Int> value = $_value;
        Box<Int> value = $_value;

        // 使用.value进行实际计算
        final result = value.value.add(Int(10));
        expect(result, equals(Int(52)));
      }

      final intBox = Box(Int(42));
      processInt(intBox);
    });

    test('变量定义装箱', () {
      // 模拟内部变量定义装箱
      Box<Int> localCounter = Box(Int(0));
      Box<String> localMessage = Box("Test");

      // 使用.value访问
      expect(localCounter.value, equals(Int(0)));
      expect(localMessage.value, equals("Test"));
    });

    test('函数调用参数装箱', () {
      // 模拟传递给其他函数的参数装箱
      Box<Int> counter = Box(Int(5));
      Box<String> message = Box("World");

      void printValues(Box<Int> counter, Box<String> message) {
        // 应该传入 counter.value 和 message.value
        expect(counter.value, equals(Int(5)));
        expect(message.value, equals("World"));
      }

      printValues(counter, message);
    });

    test('复杂闭包场景', () {
      // 测试更复杂的闭包场景
      Box<Int> outerCounter = Box(Int(0));
      Box<String> outerMessage = Box("Outer");

      void createClosure() {
        Box<Int> innerCounter = Box(Int(10));
        Box<String> innerMessage = Box("Inner");

        void nestedClosure() {
          // 应该能够访问所有外部变量
          expect(outerCounter.value, equals(Int(0)));
          expect(outerMessage.value, equals("Outer"));
          expect(innerCounter.value, equals(Int(10)));
          expect(innerMessage.value, equals("Inner"));
        }

        nestedClosure();
      }

      createClosure();
    });

    test('算术运算装箱', () {
      // 测试装箱后的算术运算
      Box<Int> a = Box(Int(10));
      Box<Int> b = Box(Int(5));

      // 使用.value进行运算
      final sum = a.value.add(b.value);
      final diff = a.value.subtract(b.value);
      final product = a.value.multiply(b.value);

      expect(sum, equals(Int(15)));
      expect(diff, equals(Int(5)));
      expect(product, equals(Int(50)));
    });

    test('布尔运算装箱', () {
      // 测试装箱后的布尔运算
      Box<Bool> flag1 = Box(Bool(true));
      Box<Bool> flag2 = Box(Bool(false));

      // 使用.value进行运算
      final andResult = flag1.value.and(flag2.value);
      final orResult = flag1.value.or(flag2.value);
      final notResult = flag1.value.not();

      expect(andResult, equals(Bool(false)));
      expect(orResult, equals(Bool(true)));
      expect(notResult, equals(Bool(false)));
    });

    test('字符串操作装箱', () {
      // 测试装箱后的字符串操作
      Box<String> str1 = Box("Hello");
      Box<String> str2 = Box("World");

      // 使用.value进行操作
      final concatenated = str1.value + " " + str2.value;
      expect(concatenated, equals("Hello World"));
    });

    test('混合类型装箱', () {
      // 测试不同类型混合的装箱场景
      Box<Int> number = Box(Int(42));
      Box<String> text = Box("Answer");
      Box<Bool> flag = Box(Bool(true));

      void mixedClosure() {
        // 在闭包中使用不同类型的装箱变量
        if (flag.value.toBool()) {
          final result = text.value + ": " + number.value.toString();
          expect(result, equals("Answer: 42"));
        }
      }

      mixedClosure();
    });
  });
}
