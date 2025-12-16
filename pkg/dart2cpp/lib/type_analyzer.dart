/// 独立的类型分析器 - 提供准确的类型推断和ObjectPtr包装决策
///
/// 这个模块负责：
/// 1. 扫描和识别所有自定义类
/// 2. 判断类型是否需要ObjectPtr包装
/// 3. 提供泛型类型分析
/// 4. 确保类型推断的一致性

import 'package:kernel/kernel.dart';
import 'package:kernel/ast.dart';

/// 类型分析结果
class TypeAnalysisResult {
  final bool needsObjectPtr;
  final String wrappedTypeName;
  final String originalTypeName;

  const TypeAnalysisResult({
    required this.needsObjectPtr,
    required this.wrappedTypeName,
    required this.originalTypeName,
  });

  @override
  String toString() {
    return 'TypeAnalysisResult(needsObjectPtr: $needsObjectPtr, '
           'wrapped: $wrappedTypeName, original: $originalTypeName)';
  }
}

/// 独立的类型分析器
class TypeAnalyzer {
  /// 所有自定义类的集合
  final Set<String> customClasses = {};

  /// 基本类型集合（不需要ObjectPtr包装）
  static const Set<String> _basicTypes = {
    'int', // Dart 原始类型
    'double', // Dart 原始类型
    'bool', // Dart 原始类型
    'String', // Dart 和 C++ 共用
    'Int', // C++ 包装类型
    'Double', // C++ 包装类型
    'Bool', // C++ 包装类型
    'Nullable',
    'Any',
    'void',
    'Null',
  };

  /// 获取基本类型集合
  Set<String> get basicTypes => _basicTypes.toSet();

  /// 静态方法检查是否是基本类型
  static bool isBasicType(String className) {
    return _basicTypes.contains(className);
  }

  /// 容器类型集合（需要ObjectPtr包装）
  final Set<String> containerTypes = {
    'List',
    'Set',
    'Map',
    'Queue',
    'Stack',
  };

  /// 已分析的类型缓存，避免重复计算
  final Map<String, TypeAnalysisResult> _typeCache = {};

  /// 扫描组件中的所有类定义
  void scanClasses(Component component) {
    customClasses.clear();

    for (final library in component.libraries) {
      for (final cls in library.classes) {
        customClasses.add(cls.name);
      }
    }
  }

  /// 分析类型是否需要ObjectPtr包装
  TypeAnalysisResult analyzeType(DartType type) {
    final cacheKey = type.toString();
    if (_typeCache.containsKey(cacheKey)) {
      return _typeCache[cacheKey]!;
    }

    TypeAnalysisResult result;

    if (type is InterfaceType) {
      result = _analyzeInterfaceType(type);
    } else if (type is FunctionType) {
      result = _analyzeFunctionType(type);
    } else if (type is VoidType) {
      result = const TypeAnalysisResult(
        needsObjectPtr: false,
        wrappedTypeName: 'void',
        originalTypeName: 'void',
      );
    } else if (type is DynamicType) {
      result = const TypeAnalysisResult(
        needsObjectPtr: false,
        wrappedTypeName: 'Any',
        originalTypeName: 'Any',
      );
    } else {
      // 默认情况，保守返回需要包装
      result = TypeAnalysisResult(
        needsObjectPtr: true,
        wrappedTypeName: 'ObjectPtr<${type}>',
        originalTypeName: type.toString(),
      );
    }

    _typeCache[cacheKey] = result;
    return result;
  }

  /// 分析接口类型
  TypeAnalysisResult _analyzeInterfaceType(InterfaceType type) {
    final className = type.classNode.name;
    final originalTypeName = _formatTypeName(type);

    // 基本类型不需要ObjectPtr包装
    if (basicTypes.contains(className)) {
      return TypeAnalysisResult(
        needsObjectPtr: false,
        wrappedTypeName: originalTypeName,
        originalTypeName: originalTypeName,
      );
    }

    // 检查泛型类型参数是否需要包装
    bool hasWrappedTypeArgs = false;
    if (type.typeArguments.isNotEmpty) {
      for (final typeArg in type.typeArguments) {
        if (analyzeType(typeArg).needsObjectPtr) {
          hasWrappedTypeArgs = true;
          break;
        }
      }
    }

    // 容器类型需要ObjectPtr包装
    if (containerTypes.contains(className)) {
      final wrappedTypeName = hasWrappedTypeArgs
          ? 'ObjectPtr<$originalTypeName>'
          : 'ObjectPtr<$originalTypeName>';
      return TypeAnalysisResult(
        needsObjectPtr: true,
        wrappedTypeName: wrappedTypeName,
        originalTypeName: originalTypeName,
      );
    }

    // 自定义类型需要ObjectPtr包装
    if (customClasses.contains(className)) {
      return TypeAnalysisResult(
        needsObjectPtr: true,
        wrappedTypeName: 'ObjectPtr<$originalTypeName>',
        originalTypeName: originalTypeName,
      );
    }

    // 其他未知类型，保守处理
    return TypeAnalysisResult(
      needsObjectPtr: true,
      wrappedTypeName: 'ObjectPtr<$originalTypeName>',
      originalTypeName: originalTypeName,
    );
  }

  /// 分析函数类型
  TypeAnalysisResult _analyzeFunctionType(FunctionType type) {
    final returnType = analyzeType(type.returnType);
    final paramTypes = type.positionalParameters
        .map((p) => analyzeType(p))
        .map((r) => r.wrappedTypeName)
        .join(', ');

    return TypeAnalysisResult(
      needsObjectPtr: false,
      wrappedTypeName: 'std::function<$returnType.wrappedTypeName($paramTypes)>',
      originalTypeName: type.toString(),
    );
  }

  /// 格式化类型名称（处理泛型）
  String _formatTypeName(InterfaceType type) {
    final className = type.classNode.name;

    if (type.typeArguments.isEmpty) {
      return className;
    }

    final typeArgs = type.typeArguments
        .map((arg) {
              final result = analyzeType(arg);
              return result.wrappedTypeName;
            })
        .join(', ');

    return '$className<$typeArgs>';
  }

  /// 检查类型是否是自定义类
  bool isCustomClass(DartType type) {
    if (type is! InterfaceType) return false;
    return customClasses.contains(type.classNode.name);
  }

  /// 检查DartType是否是基本类型
  bool isBasicDartType(DartType type) {
    if (type is! InterfaceType) return false;
    return _basicTypes.contains(type.classNode.name);
  }

  /// 检查类型是否是容器类型
  bool isContainerType(DartType type) {
    if (type is! InterfaceType) return false;
    return containerTypes.contains(type.classNode.name);
  }

  /// 获取类型的ObjectPtr包装版本
  String getObjectPtrWrappedType(DartType type) {
    final result = analyzeType(type);
    if (result.needsObjectPtr) {
      return result.wrappedTypeName;
    }
    return result.originalTypeName;
  }

  /// 获取类型的不包装版本
  String getPlainType(DartType type) {
    final result = analyzeType(type);
    return result.originalTypeName;
  }

  /// 清除缓存（用于重新分析）
  void clearCache() {
    _typeCache.clear();
  }

  /// 获取所有自定义类的列表
  List<String> getCustomClassesList() {
    return customClasses.toList()..sort();
  }

  /// 打印分析统计信息
  void printStatistics() {
    print('\n📊 类型分析统计:');
    print('  • 自定义类数量: ${customClasses.length}');
    print('  • 基本类型数量: ${basicTypes.length}');
    print('  • 容器类型数量: ${containerTypes.length}');
    print('  • 缓存类型数量: ${_typeCache.length}');
  }
}

/// 扩展方法：为DartType添加便捷分析
extension DartTypeExtensions on DartType {
  /// 判断是否需要ObjectPtr包装
  bool needsObjectPtr(TypeAnalyzer analyzer) {
    return analyzer.analyzeType(this).needsObjectPtr;
  }

  /// 获取包装后的类型名
  String getWrappedTypeName(TypeAnalyzer analyzer) {
    return analyzer.analyzeType(this).wrappedTypeName;
  }

  /// 获取原始类型名
  String getPlainTypeName() {
    return toString();
  }
}
