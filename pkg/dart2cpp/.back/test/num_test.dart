import 'package:test/test.dart';
import '../lib/demo/num.dart';

void main() {
  group('Int类测试', () {
    test('基本构造函数和转换', () {
      final int1 = Int(42);
      expect(int1.value, equals(42));
      expect(int1.toInt(), equals(42));
      expect(int1.toDouble(), equals(42.0));
      expect(int1.toString(), equals('42'));
      expect(int1.toBool(), isTrue);
    });

    test('算术运算符', () {
      final a = Int(10);
      final b = Int(3);

      expect(a + b, equals(Int(13)));
      expect(a - b, equals(Int(7)));
      expect(a * b, equals(Int(30)));
      expect(a / b, equals(10 / 3));
      expect(a ~/ b, equals(Int(3)));
      expect(a % b, equals(Int(1)));
      expect(-a, equals(Int(-10)));
    });

    test('位运算符', () {
      final a = Int(10); // 1010
      final b = Int(3); // 0011

      expect(a & b, equals(Int(2))); // 0010
      expect(a | b, equals(Int(11))); // 1011
      expect(a ^ b, equals(Int(9))); // 1001
      expect(a << Int(1), equals(Int(20))); // 10100
      expect(a >> Int(1), equals(Int(5))); // 0101
      expect(~a, equals(Int(~10)));
    });

    test('比较运算符', () {
      final a = Int(10);
      final b = Int(5);

      expect(a > b, isTrue);
      expect(a >= b, isTrue);
      expect(a < b, isFalse);
      expect(a <= b, isFalse);
      expect(a == Int(10), isTrue);
      expect(a != b, isTrue);
    });

    test('数学函数', () {
      final a = Int(-5);
      final b = Int(0);

      expect(a.abs(), equals(Int(5)));
      expect(a.sign(), equals(Int(-1)));
      expect(b.sign(), equals(Int(0)));
      expect(Int(6).sign(), equals(Int(1)));

      expect(Int(4).isEven, isTrue);
      expect(Int(5).isOdd, isTrue);
      expect(a.isNegative, isTrue);
      expect(Int(5).isNegative, isFalse);
    });

    test('进制转换', () {
      final num = Int(255);
      expect(num.toHexString(), equals('ff'));
      expect(num.toOctalString(), equals('377'));
      expect(num.toBinaryString(), equals('11111111'));
      expect(num.toRadixString(16), equals('ff'));
    });

    test('静态方法', () {
      expect(Int.parse('42'), equals(Int(42)));
      expect(Int.tryParse('42'), equals(Int(42)));
      expect(Int.tryParse('invalid'), isNull);
      expect(Int.parse('FF', radix: 16), equals(Int(255)));
    });

    test('常量值', () {
      expect(Int.zero, equals(Int(0)));
      expect(Int.one, equals(Int(1)));
      expect(Int.maxValue, equals(Int(9223372036854775807)));
      expect(Int.minValue, equals(Int(-9223372036854775808)));
    });
  });

  group('Double类测试', () {
    test('基本构造函数和转换', () {
      final double1 = Double(3.14);
      expect(double1.value, equals(3.14));
      expect(double1.toInt(), equals(3));
      expect(double1.toDouble(), equals(3.14));
      expect(double1.toString(), equals('3.14'));
      expect(double1.toBool(), isTrue);
    });

    test('算术运算符', () {
      final a = Double(10.5);
      final b = Double(3.2);

      expect(a + b, equals(Double(13.7)));
      expect(a - b, equals(Double(7.3)));
      expect(a * b, equals(Double(33.6)));
      expect(a / b, closeTo(3.28125, 0.001));
      expect(a ~/ b, equals(Double(3.0)));
      expect(a % b, closeTo(0.9, 0.001));
      expect(-a, equals(Double(-10.5)));
    });

    test('比较运算符', () {
      final a = Double(10.5);
      final b = Double(5.2);

      expect(a > b, isTrue);
      expect(a >= b, isTrue);
      expect(a < b, isFalse);
      expect(a <= b, isFalse);
      expect(a == Double(10.5), isTrue);
      expect(a != b, isTrue);
    });

    test('数学函数', () {
      final a = Double(-3.7);
      final b = Double(3.2);

      expect(a.abs(), equals(Double(3.7)));
      expect(a.sign(), equals(Double(-1.0)));
      expect(Double(0.0).sign(), equals(Double(0.0)));
      expect(b.sign(), equals(Double(1.0)));

      expect(a.ceil(), equals(Double(-3.0)));
      expect(a.floor(), equals(Double(-4.0)));
      expect(a.round(), equals(Double(-4.0)));
      expect(a.truncate(), equals(Double(-3.0)));
    });

    test('字符串转换', () {
      final num = Double(3.14159);
      expect(num.toStringAsFixed(2), equals('3.14'));
      expect(num.toStringAsExponential(2), equals('3.14e+0'));
      expect(num.toStringAsPrecision(3), equals('3.14'));
    });

    test('静态方法', () {
      expect(Double.parse('3.14'), equals(Double(3.14)));
      expect(Double.tryParse('3.14'), equals(Double(3.14)));
      expect(Double.tryParse('invalid'), isNull);
    });

    test('特殊值', () {
      expect(Double.infinity.value, equals(double.infinity));
      expect(Double.negativeInfinity.value, equals(double.negativeInfinity));
      expect(Double.nan.value.isNaN, isTrue);
      expect(Double.pi.value, equals(3.1415926535897932));
    });

    test('属性', () {
      expect(Double(3.14).isNegative, isFalse);
      expect(Double(-3.14).isNegative, isTrue);
      expect(Double(3.14).isFinite, isTrue);
      expect(Double.infinity.isInfinite, isTrue);
      expect(Double.nan.isNaN, isTrue);
    });
  });

  group('混合类型操作测试', () {
    test('Int和Double混合运算', () {
      final int1 = Int(10);
      final double1 = Double(3.5);

      expect(int1 + double1, equals(Double(13.5)));
      expect(int1 - double1, equals(Double(6.5)));
      expect(int1 * double1, equals(Double(35.0)));
      expect(int1 / double1, closeTo(2.857, 0.001));
      expect(int1 ~/ double1, equals(Double(2.0)));
      expect(int1 % double1, closeTo(3.0, 0.001));

      expect(double1 + int1, equals(Double(13.5)));
      expect(double1 - int1, equals(Double(-6.5)));
      expect(double1 * int1, equals(Double(35.0)));
      expect(double1 / int1, equals(Double(0.35)));
      expect(double1 ~/ int1, equals(Double(0.0)));
      expect(double1 % int1, equals(Double(3.5)));
    });

    test('比较操作', () {
      final int1 = Int(10);
      final double1 = Double(10.0);
      final double2 = Double(15.5);

      expect(int1 < double2, isTrue);
      expect(int1 <= double1, isTrue);
      expect(int1 > Double(5.0), isTrue);
      expect(int1 >= double1, isTrue);

      expect(double1 < Int(15), isTrue);
      expect(double1 <= int1, isTrue);
      expect(double1 > Int(5), isTrue);
      expect(double1 >= int1, isTrue);
    });
  });

  group('扩展方法测试', () {
    test('内置类型转换', () {
      final builtinInt = 42;
      final builtinDouble = 3.14;

      final customInt = builtinInt.toCustomInt();
      final customDouble = builtinDouble.toCustomDouble();

      expect(customInt, equals(Int(42)));
      expect(customDouble, equals(Double(3.14)));

      expect(customInt.toBuiltinInt(), equals(42));
      expect(customDouble.toBuiltinDouble(), equals(3.14));
    });
  });
}
