import 'dart:io';
import 'package:kernel/kernel.dart';
import 'lib/compile_to_cpp.dart';

/// 全面测试 C++ 转换器的各种功能
void main() async {
  print('=== 全面测试 C++ 转换器 ===');

  // 创建测试组件
  final component = Component();
  final library = Library(Uri.parse('test:comprehensive'),
      fileUri: Uri.parse('test:comprehensive'));
  component.libraries.add(library);

  // 1. 创建一个带有 cpp:native 注解的类
  final nativeClass =
      Class(name: 'NativeCalculator', fileUri: Uri.parse('test:comprehensive'));

  // 添加 cpp:native 注解
  final pragmaClass = Class(name: 'pragma', fileUri: Uri.parse('dart:core'));
  final nameField =
      Field.immutable(Name('name'), fileUri: Uri.parse('dart:core'));
  final optionsField =
      Field.immutable(Name('options'), fileUri: Uri.parse('dart:core'));

  final annotation = ConstantExpression(
    InstanceConstant(pragmaClass.reference, [], {
      nameField.fieldReference: StringConstant('cpp:native'),
      optionsField.fieldReference: StringConstant('CppNativeCalculator'),
    }),
  );
  nativeClass.addAnnotation(annotation);
  library.addClass(nativeClass);

  // 2. 创建一个普通的类
  final regularClass =
      Class(name: 'Calculator', fileUri: Uri.parse('test:comprehensive'));
  library.addClass(regularClass);

  // 添加字段
  final valueField = Field.immutable(
    Name('_value'),
    type: InterfaceType(regularClass, Nullability.nonNullable),
    fileUri: Uri.parse('test:comprehensive'),
  );
  regularClass.addField(valueField);

  // 添加构造函数
  final constructor = Constructor(
    FunctionNode(
      Block([]),
      positionalParameters: [
        VariableDeclaration('initialValue',
            type: InterfaceType(regularClass, Nullability.nonNullable))
      ],
    ),
    name: Name(''),
    fileUri: Uri.parse('test:comprehensive'),
  );
  regularClass.addConstructor(constructor);

  // 添加实例方法
  final addMethod = Procedure(
    Name('add'),
    ProcedureKind.Method,
    FunctionNode(
      Block([ReturnStatement(IntLiteral(42))]),
      positionalParameters: [
        VariableDeclaration('other',
            type: InterfaceType(regularClass, Nullability.nonNullable))
      ],
      returnType: InterfaceType(regularClass, Nullability.nonNullable),
    ),
    fileUri: Uri.parse('test:comprehensive'),
  );
  regularClass.addProcedure(addMethod);

  // 添加静态方法
  final staticMethod = Procedure(
    Name('create'),
    ProcedureKind.Method,
    FunctionNode(
      Block([
        ReturnStatement(ConstructorInvocation(
          constructor,
          Arguments([IntLiteral(0)]),
        ))
      ]),
      returnType: InterfaceType(regularClass, Nullability.nonNullable),
    ),
    isStatic: true,
    fileUri: Uri.parse('test:comprehensive'),
  );
  regularClass.addProcedure(staticMethod);

  try {
    // 使用转换器生成 C++ 代码
    final transformer = DartToCppTransformer();
    final cppCode = transformer.transformComponent(component);

    // 写入文件
    final outputFile = File('comprehensive_test_output.cpp');
    await outputFile.writeAsString(cppCode);

    print('✅ 全面测试 C++ 代码生成成功！');
    print('📁 输出文件: ${outputFile.path}');
    print('📊 生成代码长度: ${cppCode.length} 字符');

    // 分析生成的代码
    final lines = cppCode.split('\n');
    print('📊 总行数: ${lines.length}');

    // 检查是否包含我们的类
    final hasNativeClass = cppCode.contains('NativeCalculator');
    final hasRegularClass = cppCode.contains('Calculator');
    final hasNamespace = cppCode.contains('namespace dart_cpp');
    final hasIncludes = cppCode.contains('#include');

    print('\n🔍 代码分析结果:');
    print('  • 包含原生类声明: ${hasNativeClass ? '✅' : '❌'}');
    print('  • 包含普通类实现: ${hasRegularClass ? '✅' : '❌'}');
    print('  • 包含命名空间: ${hasNamespace ? '✅' : '❌'}');
    print('  • 包含头文件: ${hasIncludes ? '✅' : '❌'}');

    // 显示生成的代码预览
    print('\n🔍 生成的 C++ 代码预览:');
    print('=' * 80);
    final previewLines = lines.take(50).toList();
    for (int i = 0; i < previewLines.length; i++) {
      print('${(i + 1).toString().padLeft(3)}: ${previewLines[i]}');
    }
    if (lines.length > 50) {
      print('...');
      print('(总共 ${lines.length} 行，显示前 50 行)');
    }
    print('=' * 80);
  } catch (e, stackTrace) {
    print('❌ C++ 代码生成失败: $e');
    print('堆栈跟踪: $stackTrace');
  }
}
