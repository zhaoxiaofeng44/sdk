import 'dart:io';
import 'package:test/test.dart';
import '../lib/compile_to_dart.dart';
import 'package:kernel/kernel.dart';
import 'package:kernel/ast.dart';

void main() {
  group('表达式转换测试', () {
    test('测试基本表达式转换', () {
      // 测试 ThisExpression
      final thisExpr = ThisExpression();
      final result1 = _generateExpressionCode(thisExpr, replaceThis: true);
      expect(result1, equals('self'));

      final result2 = _generateExpressionCode(thisExpr, replaceThis: false);
      expect(result2, equals('this'));
    });

    test('测试变量访问转换', () {
      // 创建测试变量
      final variable = VariableDeclaration(name: 'testVar');
      final varGet = VariableGet(variable);
      final result = _generateExpressionCode(varGet, replaceThis: false);
      expect(result, equals('testVar'));
    });

    test('测试字符串字面量转换', () {
      final stringLit = StringLiteral('Hello World');
      final result = _generateExpressionCode(stringLit, replaceThis: false);
      expect(result, equals("'Hello World'"));
    });

    test('测试整数字面量转换', () {
      final intLit = IntLiteral(42);
      final result = _generateExpressionCode(intLit, replaceThis: false);
      expect(result, equals('42'));
    });

    test('测试布尔字面量转换', () {
      final boolLit = BoolLiteral(true);
      final result = _generateExpressionCode(boolLit, replaceThis: false);
      expect(result, equals('true'));
    });

    test('测试空值字面量转换', () {
      final nullLit = NullLiteral();
      final result = _generateExpressionCode(nullLit, replaceThis: false);
      expect(result, equals('null'));
    });

    test('测试列表字面量转换', () {
      final listLit = ListLiteral([
        IntLiteral(1),
        IntLiteral(2),
        IntLiteral(3),
      ]);
      final result = _generateExpressionCode(listLit, replaceThis: false);
      expect(result, equals('[1, 2, 3]'));
    });

    test('测试映射字面量转换', () {
      final mapLit = MapLiteral([
        MapLiteralEntry(
          key: StringLiteral('key1'),
          value: IntLiteral(1),
        ),
        MapLiteralEntry(
          key: StringLiteral('key2'),
          value: IntLiteral(2),
        ),
      ]);
      final result = _generateExpressionCode(mapLit, replaceThis: false);
      expect(result, equals("{'key1': 1, 'key2': 2}"));
    });

    test('测试逻辑表达式转换', () {
      final left = BoolLiteral(true);
      final right = BoolLiteral(false);
      final logicalExpr = LogicalExpression(
        left: left,
        operator: LogicalExpressionOperator.AND,
        right: right,
      );
      final result = _generateExpressionCode(logicalExpr, replaceThis: false);
      expect(result, equals('true && false'));
    });

    test('测试条件表达式转换', () {
      final condition = BoolLiteral(true);
      final then = IntLiteral(1);
      final otherwise = IntLiteral(0);
      final condExpr = ConditionalExpression(
        condition: condition,
        then: then,
        otherwise: otherwise,
      );
      final result = _generateExpressionCode(condExpr, replaceThis: false);
      expect(result, equals('true ? 1 : 0'));
    });

    test('测试字符串连接转换', () {
      final concat = StringConcatenation([
        StringLiteral('Hello'),
        StringLiteral(' '),
        StringLiteral('World'),
      ]);
      final result = _generateExpressionCode(concat, replaceThis: false);
      expect(result, equals("'Hello' + ' ' + 'World'"));
    });

    test('测试类型转换表达式', () {
      final operand = VariableGet(VariableDeclaration(name: 'value'));
      final type = InterfaceType(Class(name: 'String'));
      final asExpr = AsExpression(operand: operand, type: type);
      final result = _generateExpressionCode(asExpr, replaceThis: false);
      expect(result, equals('value as String'));
    });

    test('测试类型检查表达式', () {
      final operand = VariableGet(VariableDeclaration(name: 'value'));
      final type = InterfaceType(Class(name: 'String'));
      final isExpr = IsExpression(operand: operand, type: type);
      final result = _generateExpressionCode(isExpr, replaceThis: false);
      expect(result, equals('value is String'));
    });

    test('测试否定表达式', () {
      final operand = BoolLiteral(true);
      final notExpr = Not(operand: operand);
      final result = _generateExpressionCode(notExpr, replaceThis: false);
      expect(result, equals('!true'));
    });

    test('测试静态方法调用', () {
      final target = Procedure(name: Name('testMethod'));
      final args = [IntLiteral(1), IntLiteral(2)];
      final staticInvoke = StaticInvocation(
        target: target,
        arguments: Arguments(positional: args),
      );
      final result = _generateExpressionCode(staticInvoke, replaceThis: false);
      expect(result, equals('testMethod(1, 2)'));
    });

    test('测试构造函数调用', () {
      final target = Constructor(name: Name('TestClass'));
      final args = [IntLiteral(1), IntLiteral(2)];
      final constructorInvoke = ConstructorInvocation(
        target: target,
        arguments: Arguments(positional: args),
      );
      final result =
          _generateExpressionCode(constructorInvoke, replaceThis: false);
      expect(result, equals('new TestClass(1, 2)'));
    });

    test('测试常量表达式', () {
      final constant = StringConstant('test');
      final constExpr = ConstantExpression(constant);
      final result = _generateExpressionCode(constExpr, replaceThis: false);
      expect(result, equals('"test"'));
    });

    test('测试复杂表达式组合', () {
      // 创建一个复杂的表达式：this.method(1 + 2, "test")
      final thisExpr = ThisExpression();
      final methodName = Name('method');
      final arg1 = IntLiteral(1);
      final arg2 = IntLiteral(2);
      final addExpr = IntLiteral(3); // 简化为直接值
      final arg3 = StringLiteral('test');

      final instanceInvoke = InstanceInvocation(
        receiver: thisExpr,
        name: methodName,
        arguments: Arguments(positional: [addExpr, arg3]),
      );

      final result = _generateExpressionCode(instanceInvoke, replaceThis: true);
      expect(result, equals('self.method(3, \'test\')'));
    });
  });

  group('语句转换测试', () {
    test('测试返回语句转换', () {
      final returnExpr = IntLiteral(42);
      final returnStmt = ReturnStatement(expression: returnExpr);
      final result = _generateStatementCode(returnStmt, replaceThis: false);
      expect(result, equals('return 42;'));
    });

    test('测试空返回语句转换', () {
      final returnStmt = ReturnStatement();
      final result = _generateStatementCode(returnStmt, replaceThis: false);
      expect(result, equals('return;'));
    });

    test('测试表达式语句转换', () {
      final expr = IntLiteral(42);
      final exprStmt = ExpressionStatement(expression: expr);
      final result = _generateStatementCode(exprStmt, replaceThis: false);
      expect(result, equals('42;'));
    });

    test('测试变量声明语句转换', () {
      final variable = VariableDeclaration(
        name: 'testVar',
        type: InterfaceType(Class(name: 'int')),
        initializer: IntLiteral(42),
      );
      final varDecl = VariableDeclarationStatement(variable);
      final result = _generateStatementCode(varDecl, replaceThis: false);
      expect(result, equals('int testVar = 42;'));
    });

    test('测试空语句转换', () {
      final emptyStmt = EmptyStatement();
      final result = _generateStatementCode(emptyStmt, replaceThis: false);
      expect(result, equals(';'));
    });

    test('测试块语句转换', () {
      final stmt1 = ReturnStatement(expression: IntLiteral(1));
      final stmt2 = ReturnStatement(expression: IntLiteral(2));
      final block = Block(statements: [stmt1, stmt2]);
      final result = _generateStatementCode(block, replaceThis: false);
      expect(result, equals('{\nreturn 1;\nreturn 2;\n}'));
    });

    test('测试if语句转换', () {
      final condition = BoolLiteral(true);
      final thenStmt = ReturnStatement(expression: IntLiteral(1));
      final ifStmt = IfStatement(
        condition: condition,
        then: thenStmt,
      );
      final result = _generateStatementCode(ifStmt, replaceThis: false);
      expect(result, equals('if (true) return 1;'));
    });

    test('测试if-else语句转换', () {
      final condition = BoolLiteral(true);
      final thenStmt = ReturnStatement(expression: IntLiteral(1));
      final elseStmt = ReturnStatement(expression: IntLiteral(2));
      final ifStmt = IfStatement(
        condition: condition,
        then: thenStmt,
        otherwise: elseStmt,
      );
      final result = _generateStatementCode(ifStmt, replaceThis: false);
      expect(result, equals('if (true) return 1; else return 2;'));
    });

    test('测试for语句转换', () {
      final initVar = VariableDeclaration(
        name: 'i',
        type: InterfaceType(Class(name: 'int')),
        initializer: IntLiteral(0),
      );
      final condition = BoolLiteral(true);
      final update = IntLiteral(1);
      final body = ReturnStatement(expression: IntLiteral(0));

      final forStmt = ForStatement(
        variables: [initVar],
        condition: condition,
        updates: [update],
        body: body,
      );

      final result = _generateStatementCode(forStmt, replaceThis: false);
      expect(result, equals('for (int i = 0; true; 1) return 0;'));
    });
  });

  group('类型转换测试', () {
    test('测试基本类型转换', () {
      final dynamicType = DynamicType();
      final result1 = _getDartType(dynamicType);
      expect(result1, equals('dynamic'));

      final voidType = VoidType();
      final result2 = _getDartType(voidType);
      expect(result2, equals('void'));

      final invalidType = InvalidType();
      final result3 = _getDartType(invalidType);
      expect(result3, equals('dynamic'));
    });

    test('测试接口类型转换', () {
      final stringClass = Class(name: 'String');
      final interfaceType = InterfaceType(stringClass);
      final result = _getDartType(interfaceType);
      expect(result, equals('String'));
    });

    test('测试泛型类型转换', () {
      final listClass = Class(name: 'List');
      final stringClass = Class(name: 'String');
      final stringType = InterfaceType(stringClass);
      final listType = InterfaceType(listClass, typeArguments: [stringType]);
      final result = _getDartType(listType);
      expect(result, equals('List<String>'));
    });

    test('测试函数类型转换', () {
      final intType = InterfaceType(Class(name: 'int'));
      final stringType = InterfaceType(Class(name: 'String'));
      final functionType = FunctionType(
        positionalParameters: [intType],
        returnType: stringType,
      );
      final result = _getDartType(functionType);
      expect(result, equals('Function(int) => String'));
    });
  });

  group('变量名清理测试', () {
    test('测试基本变量名清理', () {
      expect(_cleanVariableName('normalVar'), equals('normalVar'));
      expect(_cleanVariableName(''), equals('unnamed'));
    });

    test('测试包含特殊字符的变量名清理', () {
      expect(_cleanVariableName('var#123'), equals('var_123'));
      expect(_cleanVariableName('test#closure'), equals('test_closure'));
    });

    test('测试以数字开头的变量名清理', () {
      expect(_cleanVariableName('123var'), equals('var_123var'));
      expect(_cleanVariableName('0'), equals('var_0'));
    });

    test('测试包含其他特殊字符的变量名清理', () {
      expect(_cleanVariableName('test-var'), equals('test_var'));
      expect(_cleanVariableName('test.var'), equals('test_var'));
    });
  });
}
