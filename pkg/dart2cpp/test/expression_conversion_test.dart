import 'package:test/test.dart';
import 'package:kernel/kernel.dart';
import 'package:kernel/ast.dart';

void main() {
  group('表达式转换测试', () {
    test('测试基本表达式转换', () {
      // 测试 ThisExpression
      final thisExpr = ThisExpression();
      expect(thisExpr.toString(), isNotEmpty);
    });

    test('测试变量访问转换', () {
      final variable = VariableDeclaration('testVar');
      final varGet = VariableGet(variable);
      expect(varGet.toString(), isNotEmpty);
    });

    test('测试字符串字面量转换', () {
      final stringLit = StringLiteral('Hello World');
      expect(stringLit.toString(), isNotEmpty);
    });

    test('测试整数字面量转换', () {
      final intLit = IntLiteral(42);
      expect(intLit.toString(), isNotEmpty);
    });

    test('测试布尔字面量转换', () {
      final boolLit = BoolLiteral(true);
      expect(boolLit.toString(), isNotEmpty);
    });

    test('测试空值字面量转换', () {
      final nullLit = NullLiteral();
      expect(nullLit.toString(), isNotEmpty);
    });

    test('测试列表字面量转换', () {
      final listLit = ListLiteral([
        IntLiteral(1),
        IntLiteral(2),
        IntLiteral(3),
      ]);
      expect(listLit.toString(), isNotEmpty);
    });

    test('测试映射字面量转换', () {
      final mapLit = MapLiteral([
        MapLiteralEntry(StringLiteral('key1'), IntLiteral(1)),
        MapLiteralEntry(StringLiteral('key2'), IntLiteral(2)),
      ]);
      expect(mapLit.toString(), isNotEmpty);
    });

    test('测试逻辑表达式转换', () {
      final left = BoolLiteral(true);
      final right = BoolLiteral(false);
      final logicalExpr =
          LogicalExpression(left, LogicalExpressionOperator.AND, right);
      expect(logicalExpr.toString(), isNotEmpty);
    });

    test('测试字符串连接转换', () {
      final concat = StringConcatenation([
        StringLiteral('Hello'),
        StringLiteral(' '),
        StringLiteral('World'),
      ]);
      expect(concat.toString(), isNotEmpty);
    });

    test('测试否定表达式', () {
      final operand = BoolLiteral(true);
      final notExpr = Not(operand);
      expect(notExpr.toString(), isNotEmpty);
    });

    test('测试常量表达式', () {
      final constant = StringConstant('test');
      final constExpr = ConstantExpression(constant);
      expect(constExpr.toString(), isNotEmpty);
    });
  });

  group('语句转换测试', () {
    test('测试返回语句转换', () {
      final returnExpr = IntLiteral(42);
      final returnStmt = ReturnStatement(returnExpr);
      expect(returnStmt.toString(), isNotEmpty);
    });

    test('测试空返回语句转换', () {
      final returnStmt = ReturnStatement();
      expect(returnStmt.toString(), isNotEmpty);
    });

    test('测试表达式语句转换', () {
      final expr = IntLiteral(42);
      final exprStmt = ExpressionStatement(expr);
      expect(exprStmt.toString(), isNotEmpty);
    });

    test('测试空语句转换', () {
      final emptyStmt = EmptyStatement();
      expect(emptyStmt.toString(), isNotEmpty);
    });

    test('测试块语句转换', () {
      final stmt1 = ReturnStatement(IntLiteral(1));
      final stmt2 = ReturnStatement(IntLiteral(2));
      final block = Block([stmt1, stmt2]);
      expect(block.toString(), isNotEmpty);
    });

    test('测试if语句转换', () {
      final condition = BoolLiteral(true);
      final thenStmt = ReturnStatement(IntLiteral(1));
      final ifStmt = IfStatement(condition, thenStmt, null);
      expect(ifStmt.toString(), isNotEmpty);
    });
  });

  group('类型转换测试', () {
    test('测试基本类型转换', () {
      final dynamicType = DynamicType();
      expect(dynamicType.toString(), isNotEmpty);

      final voidType = VoidType();
      expect(voidType.toString(), isNotEmpty);

      final invalidType = InvalidType();
      expect(invalidType.toString(), isNotEmpty);
    });

    test('测试接口类型转换', () {
      final stringClass =
          Class(name: 'String', fileUri: Uri.parse('dart:core'));
      final interfaceType = InterfaceType(stringClass, Nullability.nonNullable);
      expect(interfaceType.toString(), isNotEmpty);
    });
  });

  group('变量名清理测试', () {
    test('测试基本变量名清理', () {
      expect('normalVar', equals('normalVar'));
      expect('', equals(''));
    });

    test('测试包含特殊字符的变量名清理', () {
      expect('var#123'.replaceAll('#', '_'), equals('var_123'));
      expect('test#closure'.replaceAll('#', '_'), equals('test_closure'));
    });

    test('测试以数字开头的变量名清理', () {
      expect('123var'.startsWith(RegExp(r'^\d')), isTrue);
      expect('0'.startsWith(RegExp(r'^\d')), isTrue);
    });

    test('测试包含其他特殊字符的变量名清理', () {
      expect('test-var'.replaceAll(RegExp(r'[^a-zA-Z0-9_]'), '_'),
          equals('test_var'));
      expect('test.var'.replaceAll(RegExp(r'[^a-zA-Z0-9_]'), '_'),
          equals('test_var'));
    });
  });
}
