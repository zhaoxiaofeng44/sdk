/// Dart Kernel AST → C++ 源码生成器
///
/// 用法（单文件模式，向后兼容）:
///   import 'package:dart2cpp/dart_to_cpp.dart';
///   final cppSource = emitCppFromComponent(component);
///
/// 用法（多文件模式，支持多 Dart 文件 / 多 package）:
///   final result = emitCppFilesFromComponent(component, outDir,
///       runtimeIncludeDir: '<dart2cpp>/lib/platform/cpp');
///   // 生成：<outDir>/<program>.h        共享声明头文件
///   //       <outDir>/<lib>.cpp ...      每个用户库一个 .cpp
///   //       <outDir>/build.sh           编译链接脚本
export 'restorer/dart_restorer.dart'
    show
        emitCppFromComponent,
        emitCppFilesFromComponent,
        CppEmitter,
        CppEmissionResult;
