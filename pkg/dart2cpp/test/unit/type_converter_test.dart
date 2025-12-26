/// CppTypeConverter单元测试
import 'package:test/test.dart';
import 'package:kernel/ast.dart';
import '../../lib/dart_to_cpp_compiler.dart';

void main() {
  group('CppTypeConverter Tests', () {
    test('基础类型转换', () {
      // int类型
      final intType = InterfaceType(
        Class(name: 'int', fileUri: Uri.parse('test.dart')),
        Nullability.nonNullable,
      );
      expect(CppTypeConverter.convertType(intType), equals('Int'));

      // double类型
      final doubleType = InterfaceType(
        Class(name: 'double', fileUri: Uri.parse('test.dart')),
        Nullability.nonNullable,
      );
      expect(CppTypeConverter.convertType(doubleType), equals('Double'));

      // String类型
      final stringType = InterfaceType(
        Class(name: 'String', fileUri: Uri.parse('test.dart')),
        Nullability.nonNullable,
      );
      expect(CppTypeConverter.convertType(stringType), equals('String'));

      // bool类型
      final boolType = InterfaceType(
        Class(name: 'bool', fileUri: Uri.parse('test.dart')),
        Nullability.nonNullable,
      );
      expect(CppTypeConverter.convertType(boolType), equals('Bool'));
    });

    test('可空类型转换', () {
      // int? 类型
      final nullableIntType = InterfaceType(
        Class(name: 'int', fileUri: Uri.parse('test.dart')),
        Nullability.nullable,
      );
      expect(CppTypeConverter.convertType(nullableIntType), equals('Int'));

      // String? 类型
      final nullableStringType = InterfaceType(
        Class(name: 'String', fileUri: Uri.parse('test.dart')),
        Nullability.nullable,
      );
      expect(
          CppTypeConverter.convertType(nullableStringType), equals('String'));
    });

    test('泛型类型转换', () {
      // List<int>
      final intClass = Class(name: 'int', fileUri: Uri.parse('test.dart'));
      final listClass = Class(name: 'List', fileUri: Uri.parse('test.dart'));
      final listIntType = InterfaceType(
        listClass,
        Nullability.nonNullable,
        [InterfaceType(intClass, Nullability.nonNullable)],
      );
      expect(
        CppTypeConverter.convertType(listIntType),
        equals('ObjectPtr<List<Int>>'),
      );

      // Map<String, int>
      final stringClass =
          Class(name: 'String', fileUri: Uri.parse('test.dart'));
      final mapClass = Class(name: 'Map', fileUri: Uri.parse('test.dart'));
      final mapType = InterfaceType(
        mapClass,
        Nullability.nonNullable,
        [
          InterfaceType(stringClass, Nullability.nonNullable),
          InterfaceType(intClass, Nullability.nonNullable),
        ],
      );
      expect(
        CppTypeConverter.convertType(mapType),
        equals('ObjectPtr<Map<String, Int>>'),
      );
    });

    test('void和dynamic类型', () {
      final voidType = VoidType();
      expect(CppTypeConverter.convertType(voidType), equals('Nullable'));

      final dynamicType = DynamicType();
      expect(CppTypeConverter.convertType(dynamicType), equals('Any'));
    });

    test('字面量转换', () {
      expect(CppTypeConverter.convertLiteral('hello'),
          equals('dart_string("hello")'));
      expect(CppTypeConverter.convertLiteral(42), equals('dart_int(42)'));
      expect(
          CppTypeConverter.convertLiteral(3.14), equals('dart_double(3.14)'));
      expect(CppTypeConverter.convertLiteral(true), equals('dart_bool(true)'));
      expect(
          CppTypeConverter.convertLiteral(false), equals('dart_bool(false)'));
    });

    test('字符串转义', () {
      expect(
        CppTypeConverter.convertLiteral('hello\nworld'),
        equals('dart_string("hello\\nworld")'),
      );
      expect(
        CppTypeConverter.convertLiteral('say "hello"'),
        equals('dart_string("say \\"hello\\"")'),
      );
      expect(
        CppTypeConverter.convertLiteral('path\\to\\file'),
        equals('dart_string("path\\\\to\\\\file")'),
      );
    });
  });
}
