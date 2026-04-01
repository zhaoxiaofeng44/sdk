/// Dart Kernel AST → Dart 源码还原器
///
/// 本文件为兼容层，实际实现已拆分到 restorer/ 目录下：
/// - restorer/dart_restorer.dart       - 主入口 + DartRestorer 类
/// - restorer/type_utils.dart          - 类型还原 + 辅助方法
/// - restorer/constant_restorer.dart   - 常量还原
/// - restorer/expression_restorer.dart - 表达式还原
/// - restorer/statement_restorer.dart  - 语句还原
/// - restorer/declaration_restorer.dart - 声明还原
export 'restorer/dart_restorer.dart';
