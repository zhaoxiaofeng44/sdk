import 'package:test/test.dart';
import '../lib/demo/num.dart';

void main() {
  group('Bool类测试', () {
    test('基本构造函数和转换', () {
      final bool1 = Bool(true);
      final bool2 = Bool(false);
      
      expect(bool1.value, isTrue);
      expect(bool2.value, isFalse);
      expect(bool1.toBool(), isTrue);
      expect(bool2.toBool(), isFalse);
      expect(bool1.toInt(), equals(1));
      expect(bool2.toInt(), equals(0));
      expect(bool1.toDouble(), equals(1.0));
      expect(bool2.toDouble(), equals(0.0));
      expect(bool1.toString(), equals('true'));
      expect(bool2.toString(), equals('false'));
    });

    test('逻辑运算符', () {
      final true_ = Bool(true);
      final false_ = Bool(false);
      
      expect(true_ & true_, equals(Bool(true)));
      expect(true_ & false_, equals(Bool(false)));
      expect(false_ & true_, equals(Bool(false)));
      expect(false_ & false_, equals(Bool(false)));
      
      expect(true_ | true_, equals(Bool(true)));
      expect(true_ | false_, equals(Bool(true)));
      expect(false_ | true_, equals(Bool(true)));
      expect(false_ | false_, equals(Bool(false)));
      
      expect(true_ ^ true_, equals(Bool(false)));
      expect(true_ ^ false_, equals(Bool(true)));
      expect(false_ ^ true_, equals(Bool(true)));
      expect(false_ ^ false_, equals(Bool(false)));
    });

    test('逻辑运算方法', () {
      final true_ = Bool(true);
      final false_ = Bool(false);
      
      expect(true_.and(true_), equals(Bool(true)));
      expect(true_.and(false_), equals(Bool(false)));
      expect(false_.and(true_), equals(Bool(false)));
      expect(false_.and(false_), equals(Bool(false)));
      
      expect(true_.or(true_), equals(Bool(true)));
      expect(true_.or(false_), equals(Bool(true)));
      expect(false_.or(true_), equals(Bool(true)));
      expect(false_.or(false_), equals(Bool(false)));
      
      expect(true_.xor(true_), equals(Bool(false)));
      expect(true_.xor(false_), equals(Bool(true)));
      expect(false_.xor(true_), equals(Bool(true)));
      expect(false_.xor(false_), equals(Bool(false)));
      
      expect(true_.not(), equals(Bool(false)));
      expect(false_.not(), equals(Bool(true)));
    });

    test('比较运算符', () {
      final true_ = Bool(true);
      final false_ = Bool(false);
      
      expect(false_ < true_, isTrue); // false < true
      expect(true_ > false_, isTrue); // true > false
      expect(false_ <= false_, isTrue);
      expect(true_ >= true_, isTrue);
      expect(true_ == Bool(true), isTrue);
      expect(true_ != false_, isTrue);
    });

    test('条件运算', () {
      final true_ = Bool(true);
      final false_ = Bool(false);
      
      expect(true_.ifTrue(() => 'success'), equals('success'));
      expect(true_.ifFalse(() => 'failure'), isNull);
      expect(false_.ifTrue(() => 'success'), isNull);
      expect(false_.ifFalse(() => 'failure'), equals('failure'));
      
      expect(true_.when(ifTrue: () => 'yes', ifFalse: () => 'no'), equals('yes'));
      expect(false_.when(ifTrue: () => 'yes', ifFalse: () => 'no'), equals('no'));
    });

    test('静态方法', () {
      expect(Bool.parse('true'), equals(Bool(true)));
      expect(Bool.parse('false'), equals(Bool(false)));
      expect(Bool.parse('TRUE'), equals(Bool(true)));
      expect(Bool.parse('FALSE'), equals(Bool(false)));
      
      expect(Bool.tryParse('true'), equals(Bool(true)));
      expect(Bool.tryParse('false'), equals(Bool(false)));
      expect(Bool.tryParse('invalid'), isNull);
    });

    test('工厂构造函数', () {
      expect(Bool.fromInt(1), equals(Bool(true)));
      expect(Bool.fromInt(0), equals(Bool(false)));
      expect(Bool.fromInt(42), equals(Bool(true)));
      expect(Bool.fromInt(-1), equals(Bool(true)));
      
      expect(Bool.fromDouble(1.0), equals(Bool(true)));
      expect(Bool.fromDouble(0.0), equals(Bool(false)));
      expect(Bool.fromDouble(3.14), equals(Bool(true)));
      expect(Bool.fromDouble(-2.5), equals(Bool(true)));
    });

    test('常量值', () {
      expect(Bool.true_, equals(Bool(true)));
      expect(Bool.false_, equals(Bool(false)));
    });

    test('属性', () {
      final true_ = Bool(true);
      final false_ = Bool(false);
      
      expect(true_.isTrue, isTrue);
      expect(true_.isFalse, isFalse);
      expect(false_.isTrue, isFalse);
      expect(false_.isFalse, isTrue);
    });
  });

  group('Bool混合类型操作测试', () {
    test('Bool与Int的混合操作', () {
      final true_ = Bool(true);
      final false_ = Bool(false);
      final int1 = Int(10);
      
      expect(true_.add(int1), equals(Int(11)));
      expect(false_.add(int1), equals(Int(10)));
      expect(true_.subtract(int1), equals(Int(9)));
      expect(false_.subtract(int1), equals(Int(10)));
      expect(true_.multiply(int1), equals(Int(10)));
      expect(false_.multiply(int1), equals(Int(0)));
      expect(true_.divide(int1), equals(10.0));
      expect(false_.divide(int1), equals(0.0));
    });

    test('Bool与Double的混合操作', () {
      final true_ = Bool(true);
      final false_ = Bool(false);
      final double1 = Double(3.5);
      
      expect(true_.addDouble(double1), equals(Double(4.5)));
      expect(false_.addDouble(double1), equals(Double(3.5)));
      expect(true_.subtractDouble(double1), equals(Double(2.5)));
      expect(false_.subtractDouble(double1), equals(Double(3.5)));
      expect(true_.multiplyDouble(double1), equals(Double(3.5)));
      expect(false_.multiplyDouble(double1), equals(Double(0.0)));
    });

    test('Int与Bool的混合操作', () {
      final int1 = Int(10);
      final true_ = Bool(true);
      final false_ = Bool(false);
      
      expect(int1.addBool(true_), equals(Int(11)));
      expect(int1.addBool(false_), equals(Int(10)));
      expect(int1.subtractBool(true_), equals(Int(9)));
      expect(int1.subtractBool(false_), equals(Int(10)));
      expect(int1.multiplyBool(true_), equals(Int(10)));
      expect(int1.multiplyBool(false_), equals(Int(0)));
    });

    test('Double与Bool的混合操作', () {
      final double1 = Double(3.5);
      final true_ = Bool(true);
      final false_ = Bool(false);
      
      expect(double1.addBool(true_), equals(Double(4.5)));
      expect(double1.addBool(false_), equals(Double(3.5)));
      expect(double1.subtractBool(true_), equals(Double(2.5)));
      expect(double1.subtractBool(false_), equals(Double(3.5)));
      expect(double1.multiplyBool(true_), equals(Double(3.5)));
      expect(double1.multiplyBool(false_), equals(Double(0.0)));
    });

    test('比较操作', () {
      final true_ = Bool(true);
      final false_ = Bool(false);
      final int1 = Int(5);
      final double1 = Double(3.5);
      
      expect(false_.lessThan(int1), isTrue);
      expect(true_.lessThan(int1), isFalse);
      expect(false_.lessThanOrEqual(int1), isTrue);
      expect(true_.greaterThan(int1), isFalse);
      expect(true_.greaterThanOrEqual(int1), isTrue);
      
      expect(false_.lessThanDouble(double1), isTrue);
      expect(true_.lessThanDouble(double1), isFalse);
      expect(int1.lessThanBool(true_), isTrue);
      expect(int1.greaterThanBool(false_), isTrue);
    });
  });

  group('Bool扩展方法测试', () {
    test('内置类型转换', () {
      final builtinTrue = true;
      final builtinFalse = false;
      
      final customTrue = builtinTrue.toCustomBool();
      final customFalse = builtinFalse.toCustomBool();
      
      expect(customTrue, equals(Bool(true)));
      expect(customFalse, equals(Bool(false)));
      
      expect(customTrue.toBuiltinBool(), isTrue);
      expect(customFalse.toBuiltinBool(), isFalse);
    });
  });
}
