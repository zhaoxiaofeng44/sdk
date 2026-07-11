/// Dart Kernel AST → C++ 源码生成器
///
/// 与 dart_to_dart_restorer.dart 平级，共享同一个中间表示（Kernel AST），
/// 分别生成静态 Dart 和 C++ 两份输出。
///
/// 用法:
///   import 'package:dart2cpp/dart_to_cpp.dart';
///   final cppSource = emitCppFromComponent(component);
export 'dart_to_dart_restorer.dart' show emitCppFromComponent, CppEmitter;
