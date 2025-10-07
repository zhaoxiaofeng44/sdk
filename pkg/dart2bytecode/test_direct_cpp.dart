import 'dart:io';
import 'package:kernel/kernel.dart';
import 'lib/compile_to_cpp.dart';

/// 直接测试 C++ 转换器
void main() async {
  print('=== 直接测试 C++ 转换器 ===');

  // 创建一个简单的测试组件
  final component = Component();
  final library =
      Library(Uri.parse('test:simple'), fileUri: Uri.parse('test:simple'));
  component.libraries.add(library);

  // 创建一个简单的类
  final cls = Class(name: 'TestClass', fileUri: Uri.parse('test:simple'));
  library.addClass(cls);

  // 添加一个字段
  final field = Field.immutable(Name('value'),
      type: InterfaceType(cls, Nullability.nonNullable),
      fileUri: Uri.parse('test:simple'));
  cls.addField(field);

  // 添加一个方法
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

  try {
    // 使用转换器生成 C++ 代码
    final transformer = DartToCppTransformer();
    final cppCode = transformer.transformComponent(component);

    // 写入文件
    final outputFile = File('test_output.cpp');
    await outputFile.writeAsString(cppCode);

    print('✅ C++ 代码生成成功！');
    print('📁 输出文件: ${outputFile.path}');
    print('📊 生成代码长度: ${cppCode.length} 字符');

    // 显示生成的代码预览
    print('\n🔍 生成的 C++ 代码预览:');
    print('=' * 60);
    final lines = cppCode.split('\n');
    final previewLines = lines.take(30).toList();
    for (int i = 0; i < previewLines.length; i++) {
      print('${(i + 1).toString().padLeft(3)}: ${previewLines[i]}');
    }
    if (lines.length > 30) {
      print('...');
      print('(总共 ${lines.length} 行)');
    }
    print('=' * 60);
  } catch (e, stackTrace) {
    print('❌ C++ 代码生成失败: $e');
    print('堆栈跟踪: $stackTrace');
  }
}
