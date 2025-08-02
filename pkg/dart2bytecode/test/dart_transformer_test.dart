import 'dart:io';
import 'package:kernel/kernel.dart';
import 'package:kernel/ast.dart';
import 'package:kernel/verifier.dart';
import '../lib/compile_to_dart.dart';

/// 测试Dart转换器
void main() {
  testDartTransformer();
}

/// 测试Dart转换器功能
void testDartTransformer() {
  print('开始测试Dart转换器...');

  // 创建一个简单的测试组件
  final component = createTestComponent();

  // 执行转换
  transformDartToDart(component);

  print('测试完成！');
}

/// 创建测试组件
Component createTestComponent() {
  final component = Component();

  // 创建库
  final library = Library(
    name: Name('test_library'),
    fileUri: Uri.parse('package:test/test.dart'),
  );

  // 创建一个测试类
  final testClass = createTestClass();
  library.classes.add(testClass);

  component.libraries.add(library);

  return component;
}

/// 创建测试类
Class createTestClass() {
  final cls = Class(
    name: Name('TestClass'),
    fileUri: Uri.parse('package:test/test.dart'),
  );

  // 添加字段
  final nameField = Field(
    name: Name('name'),
    type: InterfaceType(ObjectClass(), Nullability.nullable),
    isFinal: true,
  );
  cls.fields.add(nameField);

  // 添加构造方法
  final constructor = Constructor(
    name: Name(''),
    function: FunctionNode(
      body: Block([
        ExpressionStatement(
          InstanceSet(
            InstanceGet(
              ThisExpression(),
              nameField,
              nameField.name,
            ),
            nameField.name,
            StringLiteral('test'),
          ),
        ),
      ]),
    ),
  );
  cls.constructors.add(constructor);

  // 添加成员方法
  final method = Procedure(
    name: Name('sayHello'),
    function: FunctionNode(
      returnType: VoidType(),
      body: Block([
        ExpressionStatement(
          StaticInvocation(
            Procedure(
              name: Name('print'),
              function: FunctionNode(),
            ),
            Arguments([StringLiteral('Hello from TestClass!')]),
          ),
        ),
      ]),
    ),
  );
  cls.procedures.add(method);

  return cls;
}
