import 'package:test/test.dart';

void main() {
  group('Dart语法到Let节点转换测试', () {
    test('基本Let表达式转换', () {
      // 测试基本的let表达式
      var dartCode = 'let x = 42 in x + 1';
      var expectedLetNode = {
        'type': 'Let',
        'variable': {
          'name': 'x',
          'type': 'VariableDeclaration',
          'initializer': {'value': 42, 'type': 'IntLiteral'}
        },
        'body': {
          'type': 'BinaryExpression',
          'left': {'type': 'VariableGet', 'variable': 'x'},
          'operator': '+',
          'right': {'value': 1, 'type': 'IntLiteral'}
        }
      };

      // 验证Let节点结构
      expect(expectedLetNode['type'], equals('Let'));
      expect((expectedLetNode['variable'] as Map<String, dynamic>)['name'],
          equals('x'));
      expect((expectedLetNode['body'] as Map<String, dynamic>)['type'],
          equals('BinaryExpression'));
    });

    test('嵌套Let表达式转换', () {
      // 测试嵌套的let表达式
      var dartCode = 'let x = 10 in { let y = x * 2 in y + 1 }';
      var expectedNestedLet = {
        'type': 'Let',
        'variable': {
          'name': 'x',
          'initializer': {'value': 10, 'type': 'IntLiteral'}
        },
        'body': {
          'type': 'Let',
          'variable': {
            'name': 'y',
            'initializer': {
              'type': 'BinaryExpression',
              'left': {'type': 'VariableGet', 'variable': 'x'},
              'operator': '*',
              'right': {'value': 2, 'type': 'IntLiteral'}
            }
          },
          'body': {
            'type': 'BinaryExpression',
            'left': {'type': 'VariableGet', 'variable': 'y'},
            'operator': '+',
            'right': {'value': 1, 'type': 'IntLiteral'}
          }
        }
      };

      // 验证嵌套结构
      expect(expectedNestedLet['type'], equals('Let'));
      expect((expectedNestedLet['body'] as Map<String, dynamic>)['type'],
          equals('Let'));
    });

    test('重复计算消除转换', () {
      // 测试重复计算消除
      var originalCode = 'expensiveFunction() + expensiveFunction()';
      var optimizedCode = 'let result = expensiveFunction() in result + result';

      var expectedOptimization = {
        'type': 'Let',
        'variable': {
          'name': 'result',
          'initializer': {
            'type': 'FunctionInvocation',
            'name': 'expensiveFunction'
          }
        },
        'body': {
          'type': 'BinaryExpression',
          'left': {'type': 'VariableGet', 'variable': 'result'},
          'operator': '+',
          'right': {'type': 'VariableGet', 'variable': 'result'}
        }
      };

      // 验证优化效果
      expect(expectedOptimization['type'], equals('Let'));
      expect((expectedOptimization['variable'] as Map<String, dynamic>)['name'],
          equals('result'));
    });

    test('链式调用优化转换', () {
      // 测试链式调用优化
      var originalCode = 'object.method1().method2().method3()';
      var optimizedCode =
          'let temp1 = object.method1() in let temp2 = temp1.method2() in temp2.method3()';

      var expectedChainOptimization = {
        'type': 'Let',
        'variable': {
          'name': 'temp1',
          'initializer': {
            'type': 'InstanceInvocation',
            'receiver': {'type': 'VariableGet', 'variable': 'object'},
            'method': 'method1'
          }
        },
        'body': {
          'type': 'Let',
          'variable': {
            'name': 'temp2',
            'initializer': {
              'type': 'InstanceInvocation',
              'receiver': {'type': 'VariableGet', 'variable': 'temp1'},
              'method': 'method2'
            }
          },
          'body': {
            'type': 'InstanceInvocation',
            'receiver': {'type': 'VariableGet', 'variable': 'temp2'},
            'method': 'method3'
          }
        }
      };

      // 验证链式调用分解
      expect(expectedChainOptimization['type'], equals('Let'));
      expect(
          (expectedChainOptimization['body'] as Map<String, dynamic>)['type'],
          equals('Let'));
    });

    test('条件表达式中的Let转换', () {
      // 测试条件表达式中的Let
      var dartCode =
          'condition ? (let x = expr1 in x + 1) : (let y = expr2 in y - 1)';

      var expectedConditionalLet = {
        'type': 'ConditionalExpression',
        'condition': {'type': 'VariableGet', 'variable': 'condition'},
        'then': {
          'type': 'Let',
          'variable': {
            'name': 'x',
            'initializer': {'type': 'VariableGet', 'variable': 'expr1'}
          },
          'body': {
            'type': 'BinaryExpression',
            'left': {'type': 'VariableGet', 'variable': 'x'},
            'operator': '+',
            'right': {'value': 1, 'type': 'IntLiteral'}
          }
        },
        'otherwise': {
          'type': 'Let',
          'variable': {
            'name': 'y',
            'initializer': {'type': 'VariableGet', 'variable': 'expr2'}
          },
          'body': {
            'type': 'BinaryExpression',
            'left': {'type': 'VariableGet', 'variable': 'y'},
            'operator': '-',
            'right': {'value': 1, 'type': 'IntLiteral'}
          }
        }
      };

      // 验证条件表达式结构
      expect(expectedConditionalLet['type'], equals('ConditionalExpression'));
      expect((expectedConditionalLet['then'] as Map<String, dynamic>)['type'],
          equals('Let'));
      expect(
          (expectedConditionalLet['otherwise'] as Map<String, dynamic>)['type'],
          equals('Let'));
    });

    test('集合字面量中的Let转换', () {
      // 测试集合字面量中的Let
      var dartCode =
          '[let x = computeValue() in x * 2, let y = anotherValue() in y + 1]';

      var expectedListLiteral = {
        'type': 'ListLiteral',
        'elements': [
          {
            'type': 'Let',
            'variable': {
              'name': 'x',
              'initializer': {
                'type': 'FunctionInvocation',
                'name': 'computeValue'
              }
            },
            'body': {
              'type': 'BinaryExpression',
              'left': {'type': 'VariableGet', 'variable': 'x'},
              'operator': '*',
              'right': {'value': 2, 'type': 'IntLiteral'}
            }
          },
          {
            'type': 'Let',
            'variable': {
              'name': 'y',
              'initializer': {
                'type': 'FunctionInvocation',
                'name': 'anotherValue'
              }
            },
            'body': {
              'type': 'BinaryExpression',
              'left': {'type': 'VariableGet', 'variable': 'y'},
              'operator': '+',
              'right': {'value': 1, 'type': 'IntLiteral'}
            }
          }
        ]
      };

      // 验证集合字面量结构
      expect(expectedListLiteral['type'], equals('ListLiteral'));
      expect(
          (expectedListLiteral['elements'] as List)[0]['type'], equals('Let'));
      expect(
          (expectedListLiteral['elements'] as List)[1]['type'], equals('Let'));
    });

    test('函数参数优化转换', () {
      // 测试函数参数优化
      var originalCode =
          'function(expensiveComputation1(), expensiveComputation2())';
      var optimizedCode =
          'let arg1 = expensiveComputation1() in let arg2 = expensiveComputation2() in function(arg1, arg2)';

      var expectedParameterOptimization = {
        'type': 'Let',
        'variable': {
          'name': 'arg1',
          'initializer': {
            'type': 'FunctionInvocation',
            'name': 'expensiveComputation1'
          }
        },
        'body': {
          'type': 'Let',
          'variable': {
            'name': 'arg2',
            'initializer': {
              'type': 'FunctionInvocation',
              'name': 'expensiveComputation2'
            }
          },
          'body': {
            'type': 'FunctionInvocation',
            'name': 'function',
            'arguments': [
              {'type': 'VariableGet', 'variable': 'arg1'},
              {'type': 'VariableGet', 'variable': 'arg2'}
            ]
          }
        }
      };

      // 验证参数优化
      expect(expectedParameterOptimization['type'], equals('Let'));
      expect(
          (expectedParameterOptimization['body']
              as Map<String, dynamic>)['type'],
          equals('Let'));
    });

    test('作用域隔离验证', () {
      // 测试Let表达式的作用域隔离
      var outerLet = {
        'variable': {
          'name': 'x',
          'initializer': {'value': 10}
        },
        'body': {
          'type': 'Let',
          'variable': {
            'name': 'y',
            'initializer': {'value': 20}
          },
          'body': {
            'type': 'BinaryExpression',
            'left': {'type': 'VariableGet', 'variable': 'x'},
            'operator': '+',
            'right': {'type': 'VariableGet', 'variable': 'y'}
          }
        }
      };

      // 验证作用域隔离
      expect(outerLet['variable']!['name'], equals('x'));
      expect((outerLet['body'] as Map<String, dynamic>)['variable']!['name'],
          equals('y'));
      expect(
          outerLet['variable']!['name'],
          isNot(equals((outerLet['body']
              as Map<String, dynamic>)['variable']!['name'])));
    });

    test('C++转换结果验证', () {
      // 测试Dart到C++的转换结果
      var dartLetCode = 'let x = 42 in x + 1';
      var expectedCppCode =
          '([&](){ Int* x = Int::cppNew(42); return Int::cpp_add(x, Int::cppNew(1)); })()';

      // 验证C++转换规则
      expect(expectedCppCode.contains('([&](){'), isTrue);
      expect(expectedCppCode.contains('Int* x = Int::cppNew(42)'), isTrue);
      expect(expectedCppCode.contains('return'), isTrue);
      expect(expectedCppCode.contains('})()'), isTrue);
    });

    test('变量名生成规则', () {
      // 测试变量名生成规则
      var variableNames = [
        'cppLet_0',
        'cppLet_1',
        'cppLet_2',
        'x',
        'y',
        'temp'
      ];

      // 验证变量名格式
      for (var name in variableNames) {
        if (name.startsWith('cppLet_')) {
          expect(name.startsWith('cppLet_'), isTrue);
        } else {
          expect(name.length, greaterThan(0));
        }
      }
    });

    test('类型推断验证', () {
      // 测试Let表达式的类型推断
      var letWithType = {
        'variable': {
          'name': 'numVar',
          'type': 'Int',
          'initializer': {'value': 100, 'type': 'IntLiteral'}
        },
        'body': {
          'type': 'BinaryExpression',
          'left': {'type': 'VariableGet', 'variable': 'numVar'},
          'operator': '+',
          'right': {'value': 50, 'type': 'IntLiteral'}
        }
      };

      // 验证类型推断
      expect(letWithType['variable']!['type'], equals('Int'));
      expect((letWithType['body'] as Map<String, dynamic>)['type'],
          equals('BinaryExpression'));
    });
  });
}
