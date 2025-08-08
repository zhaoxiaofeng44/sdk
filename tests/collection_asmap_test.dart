import 'package:test/test.dart';
import '../pkg/dart2bytecode/lib/demo/collection.dart';

void main() {
  group('CppList asMap Tests', () {
    test('asMap should return Map<int, E> with correct generic parameters', () {
      // 创建一个整数列表
      var intList = CppList<int>.filled(3, 0);
      intList[0] = 10;
      intList[1] = 20;
      intList[2] = 30;

      // 调用asMap方法
      var intMap = intList.asMap();

      // 验证返回类型和内容
      expect(intMap, isA<Map<int, int>>());
      expect(intMap[0], equals(10));
      expect(intMap[1], equals(20));
      expect(intMap[2], equals(30));
      expect(intMap.length, equals(3));
    });

    test('asMap should work with string elements', () {
      // 创建一个字符串列表
      var stringList = CppList<String>.filled(2, '');
      stringList[0] = 'hello';
      stringList[1] = 'world';

      // 调用asMap方法
      var stringMap = stringList.asMap();

      // 验证返回类型和内容
      expect(stringMap, isA<Map<int, String>>());
      expect(stringMap[0], equals('hello'));
      expect(stringMap[1], equals('world'));
      expect(stringMap.length, equals(2));
    });

    test('asMap should work with empty list', () {
      // 创建一个空列表
      var emptyList = CppList<String>.empty();

      // 调用asMap方法
      var emptyMap = emptyList.asMap();

      // 验证返回类型和内容
      expect(emptyMap, isA<Map<int, String>>());
      expect(emptyMap.length, equals(0));
      expect(emptyMap.isEmpty, isTrue);
    });

    test('asMap should maintain type safety', () {
      // 创建一个混合类型列表（使用Object作为泛型参数）
      var mixedList = CppList<Object>.filled(3, null);
      mixedList[0] = 42;
      mixedList[1] = 'test';
      mixedList[2] = true;

      // 调用asMap方法
      var mixedMap = mixedList.asMap();

      // 验证返回类型和内容
      expect(mixedMap, isA<Map<int, Object>>());
      expect(mixedMap[0], equals(42));
      expect(mixedMap[1], equals('test'));
      expect(mixedMap[2], equals(true));
    });
  });
}
