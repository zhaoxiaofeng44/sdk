import '../pkg/dart2bytecode/lib/dart_to_cpp_compiler.dart';

void main() async {
  print('测试修复后的 Dart 到 C++ 编译器...');

  try {
    // 创建一个简单的测试用例
    await compileDartToCpp('test/example.dart', 'test/output.cpp');
    print('✅ 编译器运行成功！');
  } catch (e) {
    print('❌ 编译器运行失败: $e');
  }
}
