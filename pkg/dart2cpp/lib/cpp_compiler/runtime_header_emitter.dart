/// Dart→C++ 运行时头部生成器
///
/// 负责生成 C++ 输出的头部：
/// 1. `#include "dart2cpp_lowered.h"`
/// 2. 用户类型的前向声明
/// 3. 静态函数的前向声明
library;

/// 生成 C++ 运行时头部（#include + 前向声明）
class RuntimeHeaderEmitter {
  /// 生成头部代码
  String emit({
    required List<String> forwardDeclStructs,
    required List<String> forwardDeclFunctions,
  }) {
    final buf = StringBuffer();

    // 运行时头文件
    buf.writeln('#include "dart2cpp_lowered.h"');
    buf.writeln();

    // 前向声明：Value structs
    if (forwardDeclStructs.isNotEmpty) {
      buf.writeln('// === Forward declarations: Value structs ===');
      for (final name in forwardDeclStructs) {
        buf.writeln('struct $name;');
      }
      buf.writeln();
    }

    // 前向声明：静态函数
    if (forwardDeclFunctions.isNotEmpty) {
      buf.writeln('// === Forward declarations: static functions ===');
      for (final decl in forwardDeclFunctions) {
        buf.writeln('$decl;');
      }
      buf.writeln();
    }

    return buf.toString();
  }
}
