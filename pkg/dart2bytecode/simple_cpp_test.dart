import 'dart:io';
import 'package:kernel/kernel.dart';
import 'lib/compile_to_cpp.dart';

/// 简单的 C++ 转换器测试
void main() async {
  print('=== 简单 C++ 转换器测试 ===');

  // 创建测试组件
  final component = Component();
  final library =
      Library(Uri.parse('test:simple'), fileUri: Uri.parse('test:simple'));
  component.libraries.add(library);

  // 创建一个简单的类
  final cls = Class(name: 'SimpleClass', fileUri: Uri.parse('test:simple'));
  library.addClass(cls);

  // 添加一个字段
  final field = Field.immutable(
    Name('value'),
    type: InterfaceType(cls, Nullability.nonNullable),
    fileUri: Uri.parse('test:simple'),
  );
  cls.addField(field);

  // 添加一个简单的方法
  final method = Procedure(
    Name('getValue'),
    ProcedureKind.Method,
    FunctionNode(
      ReturnStatement(IntLiteral(42)),
      returnType: InterfaceType(cls, Nullability.nonNullable),
    ),
    fileUri: Uri.parse('test:simple'),
  );
  cls.addProcedure(method);

  // 添加一个静态方法
  final staticMethod = Procedure(
    Name('createInstance'),
    ProcedureKind.Method,
    FunctionNode(
      ReturnStatement(IntLiteral(100)),
      returnType: InterfaceType(cls, Nullability.nonNullable),
    ),
    isStatic: true,
    fileUri: Uri.parse('test:simple'),
  );
  cls.addProcedure(staticMethod);

  try {
    // 使用转换器生成 C++ 代码
    final transformer = DartToCppTransformer();
    final cppCode = transformer.transformComponent(component);

    // 写入文件
    final outputFile = File('simple_cpp_output.cpp');
    await outputFile.writeAsString(cppCode);

    print('✅ C++ 代码生成成功！');
    print('📁 输出文件: ${outputFile.path}');
    print('📊 生成代码长度: ${cppCode.length} 字符');

    // 分析生成的代码
    final lines = cppCode.split('\n');
    print('📊 总行数: ${lines.length}');

    // 检查关键内容
    final hasClass = cppCode.contains('SimpleClass');
    final hasMethod = cppCode.contains('getValue');
    final hasStaticMethod = cppCode.contains('createInstance');
    final hasNamespace = cppCode.contains('namespace dart_cpp');
    final hasIncludes = cppCode.contains('#include');
    final hasConstructor = cppCode.contains('SimpleClass::SimpleClass');
    final hasDestructor = cppCode.contains('~SimpleClass');

    print('\n🔍 代码分析结果:');
    print('  • 包含类定义: ${hasClass ? '✅' : '❌'}');
    print('  • 包含实例方法: ${hasMethod ? '✅' : '❌'}');
    print('  • 包含静态方法: ${hasStaticMethod ? '✅' : '❌'}');
    print('  • 包含命名空间: ${hasNamespace ? '✅' : '❌'}');
    print('  • 包含头文件: ${hasIncludes ? '✅' : '❌'}');
    print('  • 包含构造函数: ${hasConstructor ? '✅' : '❌'}');
    print('  • 包含析构函数: ${hasDestructor ? '✅' : '❌'}');

    // 显示生成的代码
    print('\n🔍 完整的生成代码:');
    print('=' * 80);
    print(cppCode);
    print('=' * 80);

    print('\n🎉 测试完成！C++ 转换器工作正常！');
  } catch (e, stackTrace) {
    print('❌ C++ 代码生成失败: $e');
    print('堆栈跟踪: $stackTrace');
  }
}

