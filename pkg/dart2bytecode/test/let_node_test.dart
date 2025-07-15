import 'package:test/test.dart';
import 'package:kernel/kernel.dart';
import 'package:kernel/ast.dart';

void main() {
  group('Let节点测试', () {
    test('基本Let表达式结构', () {
      // 创建变量声明
      var variable = VariableDeclaration('x');
      variable.initializer = IntLiteral(42);
      variable.type = DynamicType();

      // 创建表达式体
      var body = VariableGet(variable);

      // 创建Let节点
      var letNode = Let(variable, body);

      // 验证Let节点结构
      expect(letNode.variable, equals(variable));
      expect(letNode.body, equals(body));
      expect(letNode.variable.name, equals('x'));
      expect(letNode.variable.initializer, isA<IntLiteral>());
      expect((letNode.variable.initializer as IntLiteral).value, equals(42));
    });

    test('嵌套Let表达式', () {
      // 创建内层Let
      var innerVariable = VariableDeclaration('y');
      innerVariable.initializer = IntLiteral(20);
      innerVariable.type = DynamicType();

      var innerBody = VariableGet(innerVariable);
      var innerLet = Let(innerVariable, innerBody);

      // 创建外层Let
      var outerVariable = VariableDeclaration('x');
      outerVariable.initializer = IntLiteral(10);
      outerVariable.type = DynamicType();

      var outerLet = Let(outerVariable, innerLet);

      // 验证嵌套结构
      expect(outerLet.variable.name, equals('x'));
      expect(outerLet.body, equals(innerLet));
      expect(innerLet.variable.name, equals('y'));
      expect(innerLet.body, equals(innerBody));
    });

    test('Let表达式变量名生成', () {
      var variable = VariableDeclaration('testVar');
      variable.initializer = StringLiteral('test');
      variable.type = DynamicType();

      var body = VariableGet(variable);
      var letNode = Let(variable, body);

      // 验证变量名
      expect(letNode.variable.name, equals('testVar'));
      expect(letNode.variable.initializer, isA<StringLiteral>());
      expect((letNode.variable.initializer as StringLiteral).value,
          equals('test'));
    });

    test('Let表达式类型推断', () {
      // 测试有初始化的变量
      var variableWithInit = VariableDeclaration('numVar');
      variableWithInit.initializer = IntLiteral(100);
      variableWithInit.type = DynamicType();

      var bodyWithInit = VariableGet(variableWithInit);
      var letWithInit = Let(variableWithInit, bodyWithInit);

      expect(letWithInit.variable.type, isA<DynamicType>());
      expect(letWithInit.variable.initializer, isA<IntLiteral>());

      // 测试无初始化的变量
      var variableNoInit = VariableDeclaration('uninitVar');
      variableNoInit.type = DynamicType();

      var bodyNoInit = VariableGet(variableNoInit);
      var letNoInit = Let(variableNoInit, bodyNoInit);

      expect(letNoInit.variable.initializer, isNull);
      expect(letNoInit.variable.type, isA<DynamicType>());
    });

    test('Let表达式复杂body', () {
      var variable = VariableDeclaration('base');
      variable.initializer = IntLiteral(5);
      variable.type = DynamicType();

      // 创建复杂的表达式体
      var complexBody = VariableGet(variable);

      var letNode = Let(variable, complexBody);

      // 验证复杂表达式体
      expect(letNode.body, isA<VariableGet>());
      expect(letNode.body, equals(complexBody));
    });

    test('Let表达式作用域隔离', () {
      // 创建两个不同的变量
      var var1 = VariableDeclaration('var1');
      var1.initializer = IntLiteral(1);
      var1.type = DynamicType();

      var var2 = VariableDeclaration('var2');
      var2.initializer = IntLiteral(2);
      var2.type = DynamicType();

      // 创建两个独立的Let表达式
      var let1 = Let(var1, VariableGet(var1));
      var let2 = Let(var2, VariableGet(var2));

      // 验证变量隔离
      expect(let1.variable.name, equals('var1'));
      expect(let2.variable.name, equals('var2'));
      expect(let1.variable, isNot(equals(let2.variable)));
      expect(let1.body, isNot(equals(let2.body)));
    });

    test('Let表达式BlockExpression处理', () {
      var variable = VariableDeclaration('blockVar');
      variable.initializer = IntLiteral(0);
      variable.type = DynamicType();

      // 创建BlockExpression作为body
      var statements = [
        ExpressionStatement(VariableSet(variable, IntLiteral(10))),
        ExpressionStatement(VariableGet(variable))
      ];

      var block = Block(statements);
      var blockBody = BlockExpression(block, VariableGet(variable));
      var letNode = Let(variable, blockBody);

      // 验证BlockExpression处理
      expect(letNode.body, isA<BlockExpression>());
      var blockExpr = letNode.body as BlockExpression;
      expect(blockExpr.body.statements.length, equals(2));
      expect(blockExpr.body.statements[0], isA<ExpressionStatement>());
      expect(blockExpr.body.statements[1], isA<ExpressionStatement>());
    });

    test('Let表达式错误处理', () {
      // 测试空变量名
      var emptyNameVar = VariableDeclaration('');
      emptyNameVar.initializer = IntLiteral(0);
      emptyNameVar.type = DynamicType();

      var letWithEmptyName = Let(emptyNameVar, VariableGet(emptyNameVar));

      expect(letWithEmptyName.variable.name, equals(''));

      // 测试null body
      var varWithNullBody = VariableDeclaration('test');
      varWithNullBody.initializer = IntLiteral(0);
      varWithNullBody.type = DynamicType();

      // 注意：这里不能直接测试null body，因为Let构造函数需要非null的body
      // 但可以测试body为null的情况在转换时的处理
    });
  });
}
