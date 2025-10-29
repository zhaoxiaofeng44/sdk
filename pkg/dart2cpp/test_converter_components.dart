/// 转换器组件单元测试
/// 直接测试DartToCppTransformer的各个方法
import 'dart:io';
import 'package:kernel/kernel.dart';
import 'package:kernel/ast.dart';
import 'lib/dart_to_cpp_compiler.dart';

void main() {
  print('🧪 开始转换器组件单元测试');
  print('=' * 50);

  int passedTests = 0;
  int totalTests = 0;

  // 创建测试用的Component
  final component = Component();
  final uri = Uri.parse('file:///test.dart');
  final library = Library(uri, fileUri: uri);
  component.libraries.add(library);

  // 创建转换器
  final transformer = DartToCppTransformer();

  // 测试1: 转换器初始化
  totalTests++;
  print('\n📝 测试1: 转换器初始化');
  try {
    if (transformer.expressionConverter != null &&
        transformer.statementConverter != null) {
      print('✅ 转换器初始化成功');
      print('  • 表达式转换器: ✅');
      print('  • 语句转换器: ✅');
      passedTests++;
    } else {
      print('❌ 转换器初始化失败');
    }
  } catch (e) {
    print('❌ 转换器初始化异常: $e');
  }

  // 测试2: 基础表达式转换
  totalTests++;
  print('\n📝 测试2: 基础表达式转换');
  try {
    final converter = transformer.expressionConverter;

    // 测试字符串字面量
    final stringLiteral = StringLiteral("Hello");
    final stringResult = converter.convertExpression(stringLiteral);
    print('  • 字符串字面量: $stringResult');

    // 测试整数字面量
    final intLiteral = IntLiteral(42);
    final intResult = converter.convertExpression(intLiteral);
    print('  • 整数字面量: $intResult');

    // 测试布尔字面量
    final boolLiteral = BoolLiteral(true);
    final boolResult = converter.convertExpression(boolLiteral);
    print('  • 布尔字面量: $boolResult');

    // 测试null字面量
    final nullLiteral = NullLiteral();
    final nullResult = converter.convertExpression(nullLiteral);
    print('  • null字面量: $nullResult');

    if (stringResult.contains('dart_string') &&
        intResult.contains('dart_int') &&
        boolResult.contains('dart_bool') &&
        nullResult.contains('nullptr')) {
      print('✅ 基础表达式转换正确');
      passedTests++;
    } else {
      print('❌ 基础表达式转换不完整');
    }
  } catch (e) {
    print('❌ 基础表达式转换异常: $e');
  }

  // 测试3: 集合表达式转换
  totalTests++;
  print('\n📝 测试3: 集合表达式转换');
  try {
    final converter = transformer.expressionConverter;

    // 测试List字面量
    final listLiteral = ListLiteral(
      [IntLiteral(1), IntLiteral(2), IntLiteral(3)],
      typeArgument: InterfaceType(Class(name: 'int')),
    );
    final listResult = converter.convertExpression(listLiteral);
    print('  • List字面量: $listResult');

    // 测试Set字面量
    final setLiteral = SetLiteral(
      [IntLiteral(1), IntLiteral(2), IntLiteral(3)],
      typeArgument: InterfaceType(Class(name: 'int')),
    );
    final setResult = converter.convertExpression(setLiteral);
    print('  • Set字面量: $setResult');

    if (listResult.contains('List<') && setResult.contains('Set<')) {
      print('✅ 集合表达式转换正确');
      passedTests++;
    } else {
      print('❌ 集合表达式转换不完整');
    }
  } catch (e) {
    print('❌ 集合表达式转换异常: $e');
  }

  // 测试4: 变量访问转换
  totalTests++;
  print('\n📝 测试4: 变量访问转换');
  try {
    final converter = transformer.expressionConverter;

    // 创建测试变量
    final variable =
        VariableDeclaration('testVar', type: InterfaceType(Class(name: 'int')));

    // 测试变量获取
    final variableGet = VariableGet(variable);
    final getResult = converter.convertExpression(variableGet);
    print('  • 变量获取: $getResult');

    // 测试变量设置
    final variableSet = VariableSet(variable, IntLiteral(42));
    final setResult = converter.convertExpression(variableSet);
    print('  • 变量设置: $setResult');

    if (getResult.contains('testVar') && setResult.contains('testVar')) {
      print('✅ 变量访问转换正确');
      passedTests++;
    } else {
      print('❌ 变量访问转换不完整');
    }
  } catch (e) {
    print('❌ 变量访问转换异常: $e');
  }

  // 测试5: 方法调用转换
  totalTests++;
  print('\n📝 测试5: 方法调用转换');
  try {
    final converter = transformer.expressionConverter;

    // 测试静态调用
    final staticTarget = Procedure(
      name: Name('print'),
      function: FunctionNode(returnType: VoidType()),
    );
    final staticInvocation = StaticInvocation(
      staticTarget,
      Arguments([StringLiteral('Hello')]),
    );
    final staticResult = converter.convertExpression(staticInvocation);
    print('  • 静态调用: $staticResult');

    if (staticResult.contains('dart_print') || staticResult.contains('print')) {
      print('✅ 方法调用转换正确');
      passedTests++;
    } else {
      print('❌ 方法调用转换不完整');
    }
  } catch (e) {
    print('❌ 方法调用转换异常: $e');
  }

  // 测试6: 语句转换
  totalTests++;
  print('\n📝 测试6: 语句转换');
  try {
    final converter = transformer.statementConverter;

    // 测试变量声明语句
    final variableDecl = VariableDeclaration(
      'testVar',
      type: InterfaceType(Class(name: 'int')),
      initializer: IntLiteral(42),
    );
    final declResult = converter.convertStatement(variableDecl);
    print('  • 变量声明: $declResult');

    // 测试表达式语句
    final exprStmt = ExpressionStatement(StringLiteral('Hello'));
    final exprResult = converter.convertStatement(exprStmt);
    print('  • 表达式语句: $exprResult');

    if (declResult.contains('testVar') && exprResult.contains('dart_string')) {
      print('✅ 语句转换正确');
      passedTests++;
    } else {
      print('❌ 语句转换不完整');
    }
  } catch (e) {
    print('❌ 语句转换异常: $e');
  }

  // 测试7: 类型转换
  totalTests++;
  print('\n📝 测试7: 类型转换');
  try {
    // 测试基础类型转换
    final intType = InterfaceType(Class(name: 'int'));
    final intTypeResult = CppTypeConverter.convertType(intType);
    print('  • int类型: $intTypeResult');

    final stringType = InterfaceType(Class(name: 'String'));
    final stringTypeResult = CppTypeConverter.convertType(stringType);
    print('  • String类型: $stringTypeResult');

    final listType = InterfaceType(
      Class(name: 'List'),
      typeArguments: [InterfaceType(Class(name: 'int'))],
    );
    final listTypeResult = CppTypeConverter.convertType(listType);
    print('  • List<int>类型: $listTypeResult');

    if (intTypeResult == 'Int' &&
        stringTypeResult == 'String' &&
        listTypeResult.contains('List<')) {
      print('✅ 类型转换正确');
      passedTests++;
    } else {
      print('❌ 类型转换不完整');
    }
  } catch (e) {
    print('❌ 类型转换异常: $e');
  }

  // 测试8: 完整转换流程
  totalTests++;
  print('\n📝 测试8: 完整转换流程');
  try {
    final result = transformer.transformComponent(component);

    if (result.isNotEmpty) {
      print('✅ 完整转换流程成功');
      print('  • 生成代码长度: ${result.length} 字符');
      print('  • 包含头文件: ${result.contains('#include')}');
      print('  • 包含主函数: ${result.contains('int main()')}');
      passedTests++;
    } else {
      print('❌ 完整转换流程失败');
    }
  } catch (e) {
    print('❌ 完整转换流程异常: $e');
  }

  // 测试总结
  print('\n' + '=' * 50);
  print('📊 转换器组件单元测试总结');
  print('总测试数: $totalTests');
  print('通过测试: $passedTests');
  print('失败测试: ${totalTests - passedTests}');
  print('通过率: ${(passedTests / totalTests * 100).toStringAsFixed(1)}%');

  if (passedTests == totalTests) {
    print('🎉 所有转换器组件测试通过！');
  } else {
    print('⚠️ 部分转换器组件测试失败，需要修复');
  }

  // 组件状态评估
  print('\n📈 组件状态评估');
  if (passedTests >= totalTests * 0.8) {
    print('🟢 转换器组件状态良好 (通过率 >= 80%)');
    print('   建议: 可以继续集成测试');
  } else if (passedTests >= totalTests * 0.6) {
    print('🟡 转换器组件基本可用 (通过率 >= 60%)');
    print('   建议: 需要修复部分问题');
  } else {
    print('🔴 转换器组件需要重大改进 (通过率 < 60%)');
    print('   建议: 需要重新审视实现');
  }
}
