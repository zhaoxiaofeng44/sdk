/// 转换器异常处理系统
///
/// 提供详细的错误报告、友好的错误信息和修复建议
/// 支持转换前验证和转换过程监控

/// 验证结果
class ValidationResult {
  final bool isValid;
  final List<String> errors;
  final List<String> warnings;
  final List<String> suggestions;

  const ValidationResult({
    required this.isValid,
    required this.errors,
    required this.warnings,
    this.suggestions = const [],
  });

  @override
  String toString() {
    final sb = StringBuffer();

    if (!isValid) {
      sb.writeln('❌ 验证失败:');
      for (final error in errors) {
        sb.writeln('  • $error');
      }
    }

    if (warnings.isNotEmpty) {
      sb.writeln('\n⚠️ 警告:');
      for (final warning in warnings) {
        sb.writeln('  • $warning');
      }
    }

    if (suggestions.isNotEmpty) {
      sb.writeln('\n💡 建议:');
      for (final suggestion in suggestions) {
        sb.writeln('  • $suggestion');
      }
    }

    return sb.toString();
  }
}

/// Dart到C++转换异常
class Dart2CppException implements Exception {
  final String message;
  final String? details;
  final List<String>? suggestions;
  final String? codeLocation;

  const Dart2CppException(
    this.message, {
    this.details,
    this.suggestions,
    this.codeLocation,
  });

  @override
  String toString() {
    final sb = StringBuffer();
    sb.writeln('❌ $message');

    if (codeLocation != null) {
      sb.writeln('📍 位置: $codeLocation');
    }

    if (details != null) {
      sb.writeln('\n详情:');
      sb.writeln(details);
    }

    if (suggestions != null && suggestions!.isNotEmpty) {
      sb.writeln('\n建议:');
      for (final suggestion in suggestions!) {
        sb.writeln('  • $suggestion');
      }
    }

    return sb.toString();
  }
}

/// 转换失败异常
class ConversionException extends Dart2CppException {
  final int? lineNumber;
  final int? columnNumber;

  const ConversionException(
    super.message, {
    super.details,
    super.suggestions,
    super.codeLocation,
    this.lineNumber,
    this.columnNumber,
  });

  @override
  String toString() {
    final location = lineNumber != null
        ? '行 $lineNumber${columnNumber != null ? ', 列 $columnNumber' : ''}'
        : codeLocation;

    return '❌ $message\n'
           '${location != null ? '📍 位置: $location\n' : ''}'
           '${details != null ? '\n详情:\n$details\n' : ''}'
           '${suggestions != null && suggestions!.isNotEmpty ? '\n建议:\n${suggestions!.map((s) => '  • $s').join('\n')}\n' : ''}';
  }
}

/// 优化失败异常
class OptimizationException extends Dart2CppException {
  final String optimizationName;
  final dynamic originalError;

  const OptimizationException(
    this.optimizationName,
    super.message, {
    super.details,
    super.suggestions,
    super.codeLocation,
    this.originalError,
  });

  @override
  String toString() {
    return '⚠️ 优化失败 ($optimizationName)\n'
           '${super.toString()}'
           '${originalError != null ? '\n原始错误: $originalError' : ''}';
  }
}

/// 类型分析异常
class TypeAnalysisException extends Dart2CppException {
  final String typeName;

  const TypeAnalysisException(
    this.typeName,
    super.message, {
    super.details,
    super.suggestions,
    super.codeLocation,
  });
}

/// 转换验证器
class ConversionValidator {
  final List<String> _errors = [];
  final List<String> _warnings = [];
  final List<String> _suggestions = [];

  /// 验证组件是否可以被转换
  ValidationResult validate(dynamic component) {
    _errors.clear();
    _warnings.clear();
    _suggestions.clear();

    // 检查不支持的特性
    _checkUnsupportedFeatures(component);

    // 检查潜在问题
    _checkPotentialIssues(component);

    // 检查性能问题
    _checkPerformanceIssues(component);

    // 检查类型问题
    _checkTypeIssues(component);

    return ValidationResult(
      isValid: _errors.isEmpty,
      errors: List.unmodifiable(_errors),
      warnings: List.unmodifiable(_warnings),
      suggestions: List.unmodifiable(_suggestions),
    );
  }

  /// 检查不支持的特性
  void _checkUnsupportedFeatures(dynamic component) {
    try {
      for (final library in component.libraries) {
        // 检查异步生成器
        for (final procedure in library.procedures) {
          final asyncMarker = procedure.function.asyncMarker.toString();
          if (asyncMarker.contains('AsyncStar')) {
            _errors.add(
              '不支持异步生成器: ${procedure.name.text} (行 ${procedure.location?.line ?? 0})',
            );
            _suggestions.add('请使用普通异步函数替代异步生成器');
          }

          // 检查同步生成器
          if (asyncMarker.contains('SyncStar')) {
            _errors.add(
              '不支持同步生成器: ${procedure.name.text} (行 ${procedure.location?.line ?? 0})',
            );
            _suggestions.add('请使用Iterable替代同步生成器');
          }

          // 检查反射
          if (_usesReflection(procedure)) {
            _errors.add(
              '不支持反射: ${procedure.name.text} (行 ${procedure.location?.line ?? 0})',
            );
            _suggestions.add('请移除reflectable、mirrors等反射相关的代码');
          }
        }

        // 检查类
        for (final cls in library.classes) {
          // 检查未支持的注解
          for (final annot in cls.annotations) {
            if (annot.toString().contains('reflectable')) {
              _errors.add(
                '不支持反射注解: ${cls.name} (行 ${cls.location?.line ?? 0})',
              );
            }
          }
        }
      }
    } catch (e) {
      // 忽略解析错误，使用简化验证
      _warnings.add('无法完全验证组件，部分检查可能不准确');
    }
  }

  /// 检查潜在问题
  void _checkPotentialIssues(dynamic component) {
    // 简化实现
    _warnings.add('建议检查代码质量和性能问题');
  }

  /// 检查性能问题
  void _checkPerformanceIssues(dynamic component) {
    // 简化实现
    _warnings.add('建议启用字符串优化和常量折叠以提升性能');
  }

  /// 检查类型问题
  void _checkTypeIssues(dynamic component) {
    // 简化实现
    _warnings.add('建议使用具体类型替代dynamic，提高类型安全性');
  }

  /// 检查是否使用反射
  bool _usesReflection(dynamic procedure) {
    // 简化检查：查找reflectable关键字
    return _hasNodeMatching(procedure, (node) {
      final str = node.toString();
      return str.contains('reflectable') || str.contains('MirrorsUsed');
    });
  }

  /// 查找匹配的节点
  bool _hasNodeMatching(dynamic node, bool Function(dynamic) predicate) {
    try {
      if (predicate(node)) return true;

      if (node.visitChildren != null) {
        bool found = false;
        node.visitChildren((child) {
          if (_hasNodeMatching(child, predicate)) {
            found = true;
          }
        });
        return found;
      }
    } catch (e) {
      // 忽略错误
    }
    return false;
  }
}
