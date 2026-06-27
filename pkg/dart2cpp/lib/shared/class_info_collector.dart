/// 类信息收集器 — 扫描用户库中的类、mixin、枚举。
///
/// 合并自：
/// - `restorer/dart_restorer.dart` 的 `_collectClassInfo`
/// - `cpp_compiler/class_info_collector.dart` 的 `ClassInfoCollector._collectClassInfo`
///
/// 逻辑完全相同，此处为唯一权威实现。
library class_info_collector;

import 'package:kernel/kernel.dart';
import 'analysis_context.dart';

/// 类信息收集器。
///
/// 扫描所有用户库，填充 [AnalysisContext] 中的类信息字段。
/// 不包含虚表构建（由 [VTableBuilder] 负责）。
class ClassInfoCollector {
  final AnalysisContext ctx;

  ClassInfoCollector(this.ctx);

  /// 收集所有用户库的类信息。
  void collect(Component component) {
    for (final lib in component.libraries) {
      final uri = lib.importUri.toString();
      if (uri.startsWith('dart:') || uri.startsWith('package:')) continue;
      _collectLibrary(lib);
    }
  }

  void _collectLibrary(Library lib) {
    for (final cls in lib.classes) {
      // mixin 声明
      if (cls.isMixinDeclaration) {
        ctx.mixinNames.add(cls.name);
        ctx.classNodes[cls.name] = cls;
        continue;
      }

      // enum
      if (_isEnumClass(cls)) {
        ctx.enumNames.add(cls.name);
        ctx.classNodes[cls.name] = cls;
        final hasCustomToString = cls.procedures.any((p) =>
            p.name.text == 'toString' &&
            !p.isAbstract &&
            p.function.body != null);
        if (hasCustomToString) {
          ctx.enumsWithCustomToString.add(cls.name);
        }
        continue;
      }

      // 合成 mixin 中间类（名字含 `&`）
      final isSynthetic = cls.name.contains('&');
      final className =
          isSynthetic ? _sanitizeSyntheticName(cls.name) : cls.name;

      ctx.userClasses.add(className);
      if (isSynthetic) {
        ctx.syntheticLoweredNames.add(className);
      }
      ctx.classNodes[className] = cls;

      // 记录继承关系
      if (cls.supertype != null) {
        final superName = cls.supertype!.classNode.name;
        if (superName.contains('&')) {
          ctx.classHierarchy[className] = _sanitizeSyntheticName(superName);
        } else if (superName != 'Object') {
          ctx.classHierarchy[className] = superName;
        }
      }
    }
  }

  /// 判断类是否为 enum（父类为 `_Enum` 或 `Enum`）。
  static bool _isEnumClass(Class cls) {
    if (cls.supertype == null) return false;
    final superName = cls.supertype!.classNode.name;
    return superName == '_Enum' || superName == 'Enum';
  }

  /// 清洗合成中间类名：去掉前导 `_`，`&` → `_`。
  static String _sanitizeSyntheticName(String name) {
    var result = name;
    if (result.startsWith('_')) result = result.substring(1);
    return result.replaceAll('&', '_');
  }
}
