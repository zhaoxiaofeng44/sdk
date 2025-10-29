/// 基础功能测试用例
/// 测试dart2cpp的核心编译功能
import 'dart:io';
import 'lib/dart2cpp.dart';

void main() async {
  print('🧪 开始基础功能测试');
  print('=' * 50);

  int passedTests = 0;
  int totalTests = 0;

  // 测试1: 版本信息
  totalTests++;
  print('\n📝 测试1: 版本信息');
  try {
    final version = Dart2CppCompiler.version;
    if (version == '2.0.0') {
      print('✅ 版本信息正确: $version');
      passedTests++;
    } else {
      print('❌ 版本信息错误: 期望 2.0.0，实际 $version');
    }
  } catch (e) {
    print('❌ 版本信息测试失败: $e');
  }

  // 测试2: 支持的特性列表
  totalTests++;
  print('\n📝 测试2: 支持的特性列表');
  try {
    final features = Dart2CppCompiler.supportedFeatures;
    if (features.isNotEmpty && features.length >= 10) {
      print('✅ 特性列表完整: ${features.length} 个特性');
      for (final feature in features) {
        print('  • $feature');
      }
      passedTests++;
    } else {
      print('❌ 特性列表不完整: ${features.length} 个特性');
    }
  } catch (e) {
    print('❌ 特性列表测试失败: $e');
  }

  // 测试3: 简单Dart代码编译
  totalTests++;
  print('\n📝 测试3: 简单Dart代码编译');
  try {
    final result = await UnifiedCompiler.compileSource(
      '''
void main() {
  print('Hello, World!');
}
''',
      config: CompilerConfig(
        includeRuntime: true,
        optimize: false,
        verbose: false,
      ),
    );

    if (result.isSuccess && result.cppCode.isNotEmpty) {
      print('✅ 简单代码编译成功');
      print('  • 代码大小: ${result.codeSize} 字符');
      print('  • 编译时间: ${result.compilationTime.inMilliseconds}ms');
      passedTests++;
    } else {
      print('❌ 简单代码编译失败');
      for (final error in result.errors) {
        print('  • $error');
      }
    }
  } catch (e) {
    print('❌ 简单代码编译测试异常: $e');
  }

  // 测试4: 基础类型转换
  totalTests++;
  print('\n📝 测试4: 基础类型转换');
  try {
    final result = await UnifiedCompiler.compileSource(
      '''
void main() {
  int x = 42;
  double y = 3.14;
  bool flag = true;
  String name = "Alice";
  
  print('x = \$x, y = \$y, flag = \$flag, name = \$name');
}
''',
      config: CompilerConfig(
        includeRuntime: true,
        optimize: false,
        verbose: false,
      ),
    );

    if (result.isSuccess) {
      // 检查生成的C++代码是否包含正确的类型转换
      final cppCode = result.cppCode;
      if (cppCode.contains('dart_int') &&
          cppCode.contains('dart_double') &&
          cppCode.contains('dart_bool') &&
          cppCode.contains('dart_string')) {
        print('✅ 基础类型转换正确');
        print('  • 包含int转换: ${cppCode.contains('dart_int')}');
        print('  • 包含double转换: ${cppCode.contains('dart_double')}');
        print('  • 包含bool转换: ${cppCode.contains('dart_bool')}');
        print('  • 包含string转换: ${cppCode.contains('dart_string')}');
        passedTests++;
      } else {
        print('❌ 基础类型转换不完整');
      }
    } else {
      print('❌ 基础类型转换测试失败');
    }
  } catch (e) {
    print('❌ 基础类型转换测试异常: $e');
  }

  // 测试5: 集合类型转换
  totalTests++;
  print('\n📝 测试5: 集合类型转换');
  try {
    final result = await UnifiedCompiler.compileSource(
      '''
void main() {
  var list = [1, 2, 3];
  var set = {1, 2, 3};
  var map = {'a': 1, 'b': 2};
  
  print('list: \$list');
  print('set: \$set');
  print('map: \$map');
}
''',
      config: CompilerConfig(
        includeRuntime: true,
        optimize: false,
        verbose: false,
      ),
    );

    if (result.isSuccess) {
      final cppCode = result.cppCode;
      if (cppCode.contains('List<') &&
          cppCode.contains('Set<') &&
          cppCode.contains('Map<')) {
        print('✅ 集合类型转换正确');
        print('  • 包含List转换: ${cppCode.contains('List<')}');
        print('  • 包含Set转换: ${cppCode.contains('Set<')}');
        print('  • 包含Map转换: ${cppCode.contains('Map<')}');
        passedTests++;
      } else {
        print('❌ 集合类型转换不完整');
      }
    } else {
      print('❌ 集合类型转换测试失败');
    }
  } catch (e) {
    print('❌ 集合类型转换测试异常: $e');
  }

  // 测试6: 文件编译功能
  totalTests++;
  print('\n📝 测试6: 文件编译功能');
  try {
    // 创建测试文件
    final testFile = File('test_basic.dart');
    await testFile.writeAsString('''
void main() {
  print('File compilation test');
  var x = 10;
  var y = x * 2;
  print('x = \$x, y = \$y');
}
''');

    final result = await UnifiedCompiler.compileFile(
      'test_basic.dart',
      config: CompilerConfig(
        outputPath: 'test_basic.cpp',
        includeRuntime: true,
        optimize: false,
        verbose: false,
      ),
    );

    if (result.isSuccess && File('test_basic.cpp').existsSync()) {
      print('✅ 文件编译功能正常');
      print('  • 输出文件存在: ${File('test_basic.cpp').existsSync()}');
      print('  • 代码大小: ${result.codeSize} 字符');
      passedTests++;

      // 清理测试文件
      await testFile.delete();
      await File('test_basic.cpp').delete();
    } else {
      print('❌ 文件编译功能失败');
    }
  } catch (e) {
    print('❌ 文件编译功能测试异常: $e');
  }

  // 测试7: 优化功能
  totalTests++;
  print('\n📝 测试7: 优化功能');
  try {
    final result1 = await UnifiedCompiler.compileSource(
      '''
void main() {
  print('Optimization test');
}
''',
      config: CompilerConfig(
        includeRuntime: true,
        optimize: false,
        verbose: false,
      ),
    );

    final result2 = await UnifiedCompiler.compileSource(
      '''
void main() {
  print('Optimization test');
}
''',
      config: CompilerConfig(
        includeRuntime: true,
        optimize: true,
        verbose: false,
      ),
    );

    if (result1.isSuccess && result2.isSuccess) {
      print('✅ 优化功能正常');
      print('  • 未优化代码大小: ${result1.codeSize} 字符');
      print('  • 优化后代码大小: ${result2.codeSize} 字符');
      print('  • 优化效果: ${result1.codeSize - result2.codeSize} 字符');
      passedTests++;
    } else {
      print('❌ 优化功能失败');
    }
  } catch (e) {
    print('❌ 优化功能测试异常: $e');
  }

  // 测试8: 错误处理
  totalTests++;
  print('\n📝 测试8: 错误处理');
  try {
    final result = await UnifiedCompiler.compileSource(
      '''
void main() {
  // 故意包含语法错误
  var x = ;
  print('This should fail');
}
''',
      config: CompilerConfig(
        includeRuntime: true,
        optimize: false,
        verbose: false,
      ),
    );

    if (!result.isSuccess && result.errors.isNotEmpty) {
      print('✅ 错误处理正常');
      print('  • 检测到错误: ${result.errors.length} 个');
      for (final error in result.errors) {
        print('  • $error');
      }
      passedTests++;
    } else {
      print('❌ 错误处理异常: 应该检测到错误但没有');
    }
  } catch (e) {
    print('✅ 错误处理正常: 捕获到异常 $e');
    passedTests++;
  }

  // 测试总结
  print('\n' + '=' * 50);
  print('📊 测试总结');
  print('总测试数: $totalTests');
  print('通过测试: $passedTests');
  print('失败测试: ${totalTests - passedTests}');
  print('通过率: ${(passedTests / totalTests * 100).toStringAsFixed(1)}%');

  if (passedTests == totalTests) {
    print('🎉 所有测试通过！');
  } else {
    print('⚠️ 部分测试失败，需要修复');
  }
}
