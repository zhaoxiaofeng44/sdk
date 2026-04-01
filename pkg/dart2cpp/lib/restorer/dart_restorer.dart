import 'package:kernel/kernel.dart';
import 'package:kernel/ast.dart';

part 'type_utils.dart';
part 'constant_restorer.dart';
part 'expression_restorer.dart';
part 'statement_restorer.dart';
part 'declaration_restorer.dart';

// ============================================================================
// 公共 API
// ============================================================================

/// 将 Dart Kernel Component 还原为 Dart 源码字符串
String restoreDartFromComponent(Component component) {
  return DartRestorer().restore(component);
}

// ============================================================================
// 共享状态基类
// ============================================================================

abstract class _DartRestorerBase {
  StringBuffer _buf = StringBuffer();
  int _indent = 0;
  int _varCounter = 0;
  final Map<String, String> _cleanedNames = {};

  String get _pad => '  ' * _indent;

  // 跨模块方法的抽象声明（打破 mixin 循环依赖）
  String _restoreExpr(Expression expr);
  void _restoreStmt(Statement stmt);
  void _writeTypeParams(List<TypeParameter> params);
  void _writeParams(FunctionNode func, {Procedure? proc});
}

// ============================================================================
// DartRestorer 主类
// ============================================================================

class DartRestorer extends _DartRestorerBase
    with
        _TypeUtils,
        _ConstantRestorer,
        _ExpressionRestorer,
        _StatementRestorer,
        _DeclarationRestorer {
  String restore(Component component) {
    _buf.clear();
    for (final lib in component.libraries) {
      final uri = lib.importUri.toString();
      if (uri.startsWith('dart:') || uri.startsWith('package:')) continue;
      _restoreLibrary(lib);
    }
    return _buf.toString();
  }

  // ---- Library ----

  void _restoreLibrary(Library lib) {
    for (final td in lib.typedefs) _restoreTypedef(td);
    for (final cls in lib.classes) {
      if (_isSyntheticMixinClass(cls)) continue;
      if (cls.isMixinDeclaration) {
        _restoreMixin(cls);
      } else {
        _restoreClass(cls);
      }
    }
    for (final proc in lib.procedures) _restoreProcedure(proc);
    for (final field in lib.fields) _restoreField(field);
  }

  bool _isSyntheticMixinClass(Class cls) {
    return cls.name.contains('&');
  }
}
