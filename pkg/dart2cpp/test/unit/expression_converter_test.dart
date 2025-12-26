/// ExpressionConverter单元测试
import 'package:test/test.dart';
import '../../lib/code_generator_helpers.dart';

void main() {
  group('ExpressionHelper Tests', () {
    test('运算符类型判断', () {
      // 算术运算符
      expect(ExpressionHelper.isArithmeticOperator('+'), isTrue);
      expect(ExpressionHelper.isArithmeticOperator('-'), isTrue);
      expect(ExpressionHelper.isArithmeticOperator('*'), isTrue);
      expect(ExpressionHelper.isArithmeticOperator('/'), isTrue);
      expect(ExpressionHelper.isArithmeticOperator('%'), isTrue);
      expect(ExpressionHelper.isArithmeticOperator('~/'), isTrue);
      expect(ExpressionHelper.isArithmeticOperator('=='), isFalse);

      // 比较运算符
      expect(ExpressionHelper.isComparisonOperator('=='), isTrue);
      expect(ExpressionHelper.isComparisonOperator('!='), isTrue);
      expect(ExpressionHelper.isComparisonOperator('<'), isTrue);
      expect(ExpressionHelper.isComparisonOperator('<='), isTrue);
      expect(ExpressionHelper.isComparisonOperator('>'), isTrue);
      expect(ExpressionHelper.isComparisonOperator('>='), isTrue);
      expect(ExpressionHelper.isComparisonOperator('+'), isFalse);

      // 逻辑运算符
      expect(ExpressionHelper.isLogicalOperator('&&'), isTrue);
      expect(ExpressionHelper.isLogicalOperator('||'), isTrue);
      expect(ExpressionHelper.isLogicalOperator('!'), isTrue);
      expect(ExpressionHelper.isLogicalOperator('&'), isFalse);

      // 位运算符
      expect(ExpressionHelper.isBitwiseOperator('&'), isTrue);
      expect(ExpressionHelper.isBitwiseOperator('|'), isTrue);
      expect(ExpressionHelper.isBitwiseOperator('^'), isTrue);
      expect(ExpressionHelper.isBitwiseOperator('~'), isTrue);
      expect(ExpressionHelper.isBitwiseOperator('<<'), isTrue);
      expect(ExpressionHelper.isBitwiseOperator('>>'), isTrue);
      expect(ExpressionHelper.isBitwiseOperator('&&'), isFalse);
    });
  });

  group('TypeHelper Tests', () {
    test('类型判断', () {
      // 基础类型
      expect(TypeHelper.isBasicType('int'), isTrue);
      expect(TypeHelper.isBasicType('double'), isTrue);
      expect(TypeHelper.isBasicType('bool'), isTrue);
      expect(TypeHelper.isBasicType('String'), isTrue);
      expect(TypeHelper.isBasicType('Int'), isTrue);
      expect(TypeHelper.isBasicType('Double'), isTrue);
      expect(TypeHelper.isBasicType('Bool'), isTrue);
      expect(TypeHelper.isBasicType('List'), isFalse);
      expect(TypeHelper.isBasicType('MyClass'), isFalse);

      // 容器类型
      expect(TypeHelper.isContainerType('List'), isTrue);
      expect(TypeHelper.isContainerType('Set'), isTrue);
      expect(TypeHelper.isContainerType('Map'), isTrue);
      expect(TypeHelper.isContainerType('Future'), isTrue);
      expect(TypeHelper.isContainerType('Stream'), isTrue);
      expect(TypeHelper.isContainerType('int'), isFalse);
    });

    test('ObjectPtr包装判断', () {
      expect(TypeHelper.needsObjectPtrWrapper('int'), isFalse);
      expect(TypeHelper.needsObjectPtrWrapper('String'), isFalse);
      expect(TypeHelper.needsObjectPtrWrapper('List'), isTrue);
      expect(TypeHelper.needsObjectPtrWrapper('MyClass'), isTrue);
    });

    test('公共类型推断', () {
      expect(TypeHelper.findCommonType('int', 'int'), equals('int'));
      expect(TypeHelper.findCommonType('int', 'double'), equals('double'));
      expect(TypeHelper.findCommonType('double', 'int'), equals('double'));
      expect(TypeHelper.findCommonType('int', 'num'), equals('num'));
      expect(TypeHelper.findCommonType('String', 'int'), equals('Object'));
    });
  });

  group('NamingHelper Tests', () {
    test('标识符清理', () {
      expect(
          NamingHelper.sanitizeIdentifier('valid_name'), equals('valid_name'));
      expect(NamingHelper.sanitizeIdentifier(':invalid'), equals('invalid'));
      expect(NamingHelper.sanitizeIdentifier('#test'), equals('test'));
      expect(NamingHelper.sanitizeIdentifier('123abc'), equals('var_123abc'));
      expect(NamingHelper.sanitizeIdentifier('my-var'), equals('my_var'));
      expect(NamingHelper.sanitizeIdentifier('my.var'), equals('my_var'));
      expect(NamingHelper.sanitizeIdentifier(''), equals('unnamed'));
    });

    test('C++关键字处理', () {
      expect(NamingHelper.sanitizeIdentifier('class'), equals('dart_class'));
      expect(NamingHelper.sanitizeIdentifier('for'), equals('dart_for'));
      expect(NamingHelper.sanitizeIdentifier('while'), equals('dart_while'));
      expect(NamingHelper.sanitizeIdentifier('namespace'),
          equals('dart_namespace'));
      expect(
          NamingHelper.sanitizeIdentifier('template'), equals('dart_template'));
    });

    test('命名风格转换', () {
      expect(NamingHelper.toCamelCase('MyClass'), equals('myClass'));
      expect(NamingHelper.toCamelCase('myClass'), equals('myClass'));

      expect(NamingHelper.toPascalCase('myClass'), equals('MyClass'));
      expect(NamingHelper.toPascalCase('MyClass'), equals('MyClass'));

      expect(NamingHelper.toSnakeCase('MyClassName'), equals('my_class_name'));
      expect(NamingHelper.toSnakeCase('myVariableName'),
          equals('my_variable_name'));
    });
  });

  group('ErrorReporter Tests', () {
    setUp(() {
      ErrorReporter.clear();
    });

    test('错误记录', () {
      expect(ErrorReporter.hasErrors(), isFalse);

      ErrorReporter.addError('测试错误');
      expect(ErrorReporter.hasErrors(), isTrue);
      expect(ErrorReporter.getErrors().length, equals(1));

      ErrorReporter.addError('另一个错误', location: 'file.dart:10', hint: '检查语法');
      expect(ErrorReporter.getErrors().length, equals(2));
    });

    test('警告记录', () {
      expect(ErrorReporter.hasWarnings(), isFalse);

      ErrorReporter.addWarning('测试警告');
      expect(ErrorReporter.hasWarnings(), isTrue);
      expect(ErrorReporter.getWarnings().length, equals(1));
    });

    test('清空记录', () {
      ErrorReporter.addError('错误');
      ErrorReporter.addWarning('警告');

      expect(ErrorReporter.hasErrors(), isTrue);
      expect(ErrorReporter.hasWarnings(), isTrue);

      ErrorReporter.clear();

      expect(ErrorReporter.hasErrors(), isFalse);
      expect(ErrorReporter.hasWarnings(), isFalse);
    });
  });

  group('CodeFormatter Tests', () {
    test('移除多余空行', () {
      final code = 'line1\n\n\n\nline2\n\n\nline3';
      final formatted = CodeFormatter.removeExcessiveBlankLines(code);
      expect(formatted, equals('line1\n\nline2\n\nline3'));
    });

    test('代码格式化', () {
      final code = '''
int main() {
std::cout << "Hello";
return 0;
}''';
      final formatted = CodeFormatter.formatCppCode(code);
      expect(formatted.contains('  std::cout'), isTrue);
      expect(formatted.contains('  return 0;'), isTrue);
    });
  });
}
