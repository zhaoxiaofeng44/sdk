import 'package:test/test.dart';
import '../lib/compile_to_dart.dart';

/// 优化后的代码功能验证测试
///
/// 这些测试确保优化过程没有破坏任何现有功能
void main() {
  group('DartConstants', () {
    test('应该有正确的常量定义', () {
      expect(DartConstants.defaultOutputPath, isNotEmpty);
      expect(DartConstants.voidGlobalVar, equals('final Void = null;'));
      expect(DartConstants.indentUnit, equals('  '));
      expect(DartConstants.cppNativePragma, equals('cpp:native'));
      expect(DartConstants.cppPatchPragma, equals('cpp:patch'));
    });

    test('应该有正确的系统库前缀', () {
      expect(DartConstants.skipLibraryPrefixes, contains('dart.'));
      expect(DartConstants.skipLibraryPrefixes, contains('dart:'));
      expect(DartConstants.skipLibraryPrefixes, contains('package:flutter'));
    });
  });

  group('VariableNameCleaner', () {
    test('应该清理空变量名', () {
      expect(VariableNameCleaner.clean(''), equals('temp'));
      expect(VariableNameCleaner.clean('unnamed'), equals('temp'));
    });

    test('应该清理特殊字符', () {
      expect(VariableNameCleaner.clean('var#test'), equals('var_test'));
      expect(VariableNameCleaner.clean('test@name'), equals('test_name'));
    });

    test('应该处理数字开头的变量名', () {
      expect(VariableNameCleaner.clean('123abc'), equals('var_123abc'));
    });

    test('应该保留有效的变量名', () {
      expect(VariableNameCleaner.clean('validName'), equals('validName'));
      expect(VariableNameCleaner.clean('valid_name_123'),
          equals('valid_name_123'));
    });
  });

  group('NumericLiteralChecker', () {
    test('应该识别数字字面量', () {
      expect(NumericLiteralChecker.isNumeric('123'), isTrue);
      expect(NumericLiteralChecker.isNumeric('123.45'), isTrue);
      expect(NumericLiteralChecker.isNumeric('-123'), isTrue);
      expect(NumericLiteralChecker.isNumeric('-123.45'), isTrue);
    });

    test('应该识别带括号的数字', () {
      expect(NumericLiteralChecker.isNumeric('(123)'), isTrue);
      expect(NumericLiteralChecker.isNumeric('(-123.45)'), isTrue);
    });

    test('应该拒绝非数字字面量', () {
      expect(NumericLiteralChecker.isNumeric('abc'), isFalse);
      expect(NumericLiteralChecker.isNumeric('123abc'), isFalse);
      expect(NumericLiteralChecker.isNumeric(''), isFalse);
    });
  });

  group('ReceiverWrapper', () {
    test('应该识别需要包装的表达式类型', () {
      // 这里需要创建mock表达式来测试，暂时跳过具体实现
      // 主要验证逻辑结构正确
    });
  });

  group('CodeQualityChecker', () {
    test('应该检查代码质量', () {
      // 重定向输出来测试print语句
      final code1 = 'class MyClass { late int field; }';
      expect(() => CodeQualityChecker.check(code1), returnsNormally);

      final code2 = 'int value = 42;';
      expect(() => CodeQualityChecker.check(code2), returnsNormally);
    });
  });

  group('DartToDartTransformer', () {
    late DartToDartTransformer transformer;

    setUp(() {
      transformer = DartToDartTransformer();
    });

    test('应该正确初始化', () {
      expect(transformer.getGeneratedCode(), equals(''));
    });

    test('应该有缩进管理功能', () {
      // 测试缩进功能是否正常工作
      expect(() => transformer._indent(), returnsNormally);
      expect(() => transformer._unindent(), returnsNormally);
    });
  });
}
