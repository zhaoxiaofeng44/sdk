import 'package:test/test.dart';
import '../lib/demo/string.dart';

/// CppString功能测试
///
/// 验证CppString类实现的所有String方法都能正常工作
void main() {
  group('CppString基础功能', () {
    test('构造函数和基本属性', () {
      final str = CppString('Hello');
      expect(str.length, equals(5));
      expect(str.isEmpty, isFalse);
      expect(str.isNotEmpty, isTrue);
      expect(str.toString(), equals('Hello'));
    });

    test('空字符串处理', () {
      final empty = CppString('');
      expect(empty.length, equals(0));
      expect(empty.isEmpty, isTrue);
      expect(empty.isNotEmpty, isFalse);
    });

    test('字符访问', () {
      final str = CppString('Hello');
      expect(str[0], equals('H'));
      expect(str[4], equals('o'));
      expect(() => str[5], throwsRangeError);
      expect(() => str[-1], throwsRangeError);
    });
  });

  group('CppString运算符', () {
    test('字符串连接', () {
      final str1 = CppString('Hello');
      final str2 = str1 + ' World';
      expect(str2.toString(), equals('Hello World'));
      expect(str2, isA<CppString>());
    });

    test('字符串重复', () {
      final str = CppString('Hi');
      final repeated = str * 3;
      expect(repeated.toString(), equals('HiHiHi'));

      final zero = str * 0;
      expect(zero.toString(), equals(''));

      final negative = str * -1;
      expect(negative.toString(), equals(''));
    });

    test('相等性比较', () {
      final str1 = CppString('Hello');
      final str2 = CppString('Hello');
      final str3 = CppString('World');

      expect(str1 == str2, isTrue);
      expect(str1 == str3, isFalse);
      expect(str1.equalsString('Hello'), isTrue);
      expect(str1.equalsString('World'), isFalse);
    });
  });

  group('CppString查找和匹配', () {
    test('startsWith和endsWith', () {
      final str = CppString('Hello World');
      expect(str.startsWith('Hello'), isTrue);
      expect(str.startsWith('World'), isFalse);
      expect(str.startsWith('llo', 2), isTrue);
      expect(str.endsWith('World'), isTrue);
      expect(str.endsWith('Hello'), isFalse);
    });

    test('indexOf和lastIndexOf', () {
      final str = CppString('Hello World Hello');
      expect(str.indexOf('Hello'), equals(0));
      expect(str.indexOf('Hello', 1), equals(12));
      expect(str.indexOf('NotFound'), equals(-1));
      expect(str.lastIndexOf('Hello'), equals(12));
      expect(str.lastIndexOf('l'), equals(15));
    });

    test('contains', () {
      final str = CppString('Hello World');
      expect(str.contains('World'), isTrue);
      expect(str.contains('NotFound'), isFalse);
      expect(str.contains('orld', 7), isTrue);
    });
  });

  group('CppString操作方法', () {
    test('substring', () {
      final str = CppString('Hello World');
      final sub1 = str.substring(0, 5);
      expect(sub1.toString(), equals('Hello'));
      expect(sub1, isA<CppString>());

      final sub2 = str.substring(6);
      expect(sub2.toString(), equals('World'));
    });

    test('trim方法', () {
      final str = CppString('  Hello World  ');
      expect(str.trim().toString(), equals('Hello World'));
      expect(str.trimLeft().toString(), equals('Hello World  '));
      expect(str.trimRight().toString(), equals('  Hello World'));
    });

    test('padding方法', () {
      final str = CppString('Hi');
      expect(str.padLeft(5).toString(), equals('   Hi'));
      expect(str.padLeft(5, 'x').toString(), equals('xxxHi'));
      expect(str.padRight(5).toString(), equals('Hi   '));
      expect(str.padRight(5, 'x').toString(), equals('Hixxx'));
    });
  });

  group('CppString替换方法', () {
    test('replaceFirst', () {
      final str = CppString('Hello World Hello');
      final result = str.replaceFirst('Hello', 'Hi');
      expect(result.toString(), equals('Hi World Hello'));
      expect(result, isA<CppString>());
    });

    test('replaceAll', () {
      final str = CppString('Hello World Hello');
      final result = str.replaceAll('Hello', 'Hi');
      expect(result.toString(), equals('Hi World Hi'));
    });

    test('replaceRange', () {
      final str = CppString('Hello World');
      final result = str.replaceRange(6, 11, 'Dart');
      expect(result.toString(), equals('Hello Dart'));
    });
  });

  group('CppString分割和转换', () {
    test('split', () {
      final str = CppString('a,b,c,d');
      final parts = str.split(',');
      expect(parts.length, equals(4));
      expect(parts[0].toString(), equals('a'));
      expect(parts[1].toString(), equals('b'));
      // 验证所有部分都是CppString类型
      for (final part in parts) {
        expect(part, isA<CppString>());
      }
    });

    test('大小写转换', () {
      final str = CppString('Hello World');
      expect(str.toLowerCase().toString(), equals('hello world'));
      expect(str.toUpperCase().toString(), equals('HELLO WORLD'));
    });
  });

  group('CppString代码单元和符文', () {
    test('codeUnitAt', () {
      final str = CppString('Hello');
      expect(str.codeUnitAt(0), equals(72)); // 'H'
      expect(str.codeUnitAt(1), equals(101)); // 'e'
      expect(() => str.codeUnitAt(5), throwsRangeError);
    });

    test('codeUnits', () {
      final str = CppString('Hi');
      final codeUnits = str.codeUnits;
      expect(codeUnits, equals([72, 105])); // 'H', 'i'
    });

    test('runes', () {
      final str = CppString('Hi');
      final runes = str.runes.toList();
      expect(runes, equals([72, 105])); // 'H', 'i'
    });
  });

  group('CppString比较', () {
    test('compareTo', () {
      final str1 = CppString('apple');
      final str2 = CppString('banana');
      final str3 = CppString('apple');

      expect(str1.compareTo(str2.toString()), lessThan(0));
      expect(str2.compareTo(str1.toString()), greaterThan(0));
      expect(str1.compareTo(str3.toString()), equals(0));
    });
  });

  group('CppString Pattern接口', () {
    test('allMatches', () {
      final pattern = CppString('ll');
      final matches = pattern.allMatches('Hello World Hello').toList();
      expect(matches.length, equals(2));
    });

    test('matchAsPrefix', () {
      final pattern = CppString('Hello');
      final match = pattern.matchAsPrefix('Hello World');
      expect(match, isNotNull);
      expect(match!.group(0), equals('Hello'));

      final noMatch = pattern.matchAsPrefix('World Hello', 0);
      expect(noMatch, isNull);
    });
  });

  group('CppString便利方法', () {
    test('toStandardString', () {
      final str = CppString('Hello World');
      final standard = str.toStandardString();
      expect(standard, isA<String>());
      expect(standard, equals('Hello World'));
    });

    test('fromString工厂方法', () {
      final str = CppString.fromString('Hello World');
      expect(str, isA<CppString>());
      expect(str.toString(), equals('Hello World'));
    });

    test('equalsString', () {
      final str = CppString('Hello');
      expect(str.equalsString('Hello'), isTrue);
      expect(str.equalsString('World'), isFalse);
    });
  });
}
