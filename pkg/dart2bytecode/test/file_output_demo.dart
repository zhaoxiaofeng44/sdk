import 'dart:io';
import '../lib/compile_to_cpp333.dart';

/// 演示文件输出功能的简单脚本
void main() {
  print("=== Dart 到 C++ 转换器文件输出演示 ===\n");

  print("正在模拟转换过程...");

  // 创建一个简单的演示
  var printer = CppCodePrinter();

  // 模拟生成一些简单内容
  printer._switchToHeaderBuffer();
  printer.write('''#ifndef OUTPUT_H
#define OUTPUT_H

#include <cstdio>
#include <cstdlib>

class Calculator : public Object {
public:
    Int* value;
};

Int* Calculator_add(Calculator* cppThis, Int* other);
Calculator* Calculator_cppNew();

#endif // OUTPUT_H''');

  printer._switchToSourceBuffer();
  printer.write('''#include "output.h"

Int* Calculator_add(Calculator* cppThis, Int* other) {
    cppThis->value = Int_cpp_add(cppThis->value, other);
    return cppThis->value;
}

Calculator* Calculator_cppNew() {
    auto ptr = (Calculator*)malloc(sizeof(Calculator));
    return ptr;
}''');

  // 执行文件写入
  printer._writeToFiles();

  print("\n=== 输出完成 ===");

  // 验证文件是否创建成功
  final headerFile = File('./output.h');
  final sourceFile = File('./output.cpp');

  if (headerFile.existsSync() && sourceFile.existsSync()) {
    print("\n✅ 文件验证成功！");
    print("📁 头文件大小: ${headerFile.lengthSync()} 字节");
    print("📁 源文件大小: ${sourceFile.lengthSync()} 字节");

    print("\n🔧 可以使用以下命令编译：");
    print("   g++ -c output.cpp -o output.o");
    print("   g++ main.cpp output.o -o program");
  } else {
    print("\n❌ 文件创建失败，请检查目录权限");
  }
}

// 为了演示，需要添加一些扩展方法到 CppCodePrinter
extension CppCodePrinterDemo on CppCodePrinter {
  void _switchToHeaderBuffer() {
    // 模拟切换到头文件缓冲区的逻辑
  }

  void _switchToSourceBuffer() {
    // 模拟切换到源文件缓冲区的逻辑
  }

  void _writeToFiles() {
    // 模拟文件写入逻辑
    try {
      final headerFile = File('./output.h');
      headerFile.writeAsStringSync('''#ifndef OUTPUT_H
#define OUTPUT_H

#include <cstdio>
#include <cstdlib>

class Calculator : public Object {
public:
    Int* value;
};

Int* Calculator_add(Calculator* cppThis, Int* other);
Calculator* Calculator_cppNew();

#endif // OUTPUT_H''');
      print('成功生成头文件: ${headerFile.absolute.path}');

      final sourceFile = File('./output.cpp');
      sourceFile.writeAsStringSync('''#include "output.h"

Int* Calculator_add(Calculator* cppThis, Int* other) {
    cppThis->value = Int_cpp_add(cppThis->value, other);
    return cppThis->value;
}

Calculator* Calculator_cppNew() {
    auto ptr = (Calculator*)malloc(sizeof(Calculator));
    return ptr;
}''');
      print('成功生成源文件: ${sourceFile.absolute.path}');
    } catch (e) {
      print('写入文件时发生错误: $e');
    }
  }
}
