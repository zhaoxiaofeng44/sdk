import 'package:test/test.dart';
import '../lib/demo/string.dart';

void main() {
  group('CppString Match 实现', () {
    test('matchAsPrefix 命中与未命中', () {
      final pattern = CppString.fromString('Hello');
      final m1 = pattern.matchAsPrefix(CppString.fromString('Hello World'));
      expect(m1, isNotNull);
      expect(m1!.start, 0);
      expect(m1.end, 5);
      expect(m1.group(0), 'Hello');

      final m2 = pattern.matchAsPrefix(CppString.fromString('World Hello'), 0);
      expect(m2, isNull);

      final m3 = pattern.matchAsPrefix(CppString.fromString('Say Hello'), 4);
      expect(m3, isNotNull);
      expect(m3!.start, 4);
      expect(m3.group(0), 'Hello');
    });

    test('allMatches 多次非重叠匹配', () {
      final pattern = CppString.fromString('ll');
      final matches = pattern
          .allMatches(CppString.fromString('Hello World Hello'))
          .toList();
      expect(matches.length, 2);
      expect(matches[0].start, 2);
      expect(matches[1].start, 14);
      expect(matches.map((m) => m.group(0)).toList(), ['ll', 'll']);
    });

    test('allMatches 空模式', () {
      final pattern = CppString.fromString('');
      final xs = pattern.allMatches(CppString.fromString('abc')).toList();
      // 应产生 length+1 个匹配: 索引 0,1,2,3
      expect(xs.length, 4);
      expect(xs[0].start, 0);
      expect(xs[1].start, 1);
      expect(xs[2].start, 2);
      expect(xs[3].start, 3);
    });
  });
}
