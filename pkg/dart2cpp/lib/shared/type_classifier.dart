/// 类型分类器 — 判断 Dart 类型的语义类别。
///
/// 提取自 restorer `type_utils.dart` 和 cpp_compiler `type_mapper.dart` 中
/// 共用的类型判断逻辑。目标语言无关。
library type_classifier;

import 'package:kernel/kernel.dart';

/// 类型的语义分类。
enum TypeCategory {
  primitiveInt,
  primitiveDouble,
  primitiveBool,
  primitiveString,
  dynamic_,
  void_,
  never_,
  null_,
  collectionList,
  collectionMap,
  collectionSet,
  collectionIterator,
  collectionIterable,
  promise,
  function,
  userClass,
  typeParameter,
  stringBuffer,
  mapEntry,
  regExp,
  duration,
  dateTime,
  stateError,
  argumentError,
  rangeError,
  formatException,
  unsupportedError,
  unimplementedError,
  comparable,
  record,
  futureOr,
  unknown,
}

/// 类型分类器。
class TypeClassifier {
  /// SDK 类名 → 语义包装类名映射。
  static const Map<String, String> sdkClassNameMap = {
    'StringBuffer': 'StaticStringBuffer',
    'MapEntry': 'StaticMapEntry',
    'RegExp': 'StaticRegExp',
    '_RegExp': 'StaticRegExp',
    'Duration': 'StaticDuration',
    'DateTime': 'StaticDateTime',
    'Exception': 'Exception',
    'StateError': 'DartStateError',
    'ArgumentError': 'DartArgumentError',
    'RangeError': 'DartRangeError',
    'FormatException': 'DartFormatException',
    'UnsupportedError': 'DartUnsupportedError',
    'UnimplementedError': 'DartUnimplementedError',
  };

  /// Set 内部实现类名。
  static const Set<String> _setInternalClasses = {
    '_Set',
    '_CompactLinkedHashSet',
    '_LinkedHashSet',
    'LinkedHashSet',
    '_HashSet',
    'Set',
  };

  /// Map 内部实现类名。
  static const Set<String> _mapInternalClasses = {
    'LinkedHashMap',
    '_CompactLinkedHashMap',
    '_InternalLinkedHashMap',
    '_LinkedHashMap',
    'Map',
    '_Map',
  };

  /// List 内部实现类名。
  static const Set<String> _listInternalClasses = {
    'List',
    '_GrowableList',
    '_List',
    'Iterable',
    '_Iterable',
  };

  /// 分类一个 Dart 类型。
  static TypeCategory classify(DartType type) {
    if (type is VoidType) return TypeCategory.void_;
    if (type is DynamicType) return TypeCategory.dynamic_;
    if (type is NeverType) return TypeCategory.never_;
    if (type is NullType) return TypeCategory.null_;

    if (type is InterfaceType) {
      final name = type.classNode.name;

      // 基础类型
      if (name == 'int') return TypeCategory.primitiveInt;
      if (name == 'double') return TypeCategory.primitiveDouble;
      if (name == 'bool') return TypeCategory.primitiveBool;
      if (name == 'String') return TypeCategory.primitiveString;
      if (name == 'Object') return TypeCategory.dynamic_;
      if (name == 'num') return TypeCategory.dynamic_;
      if (name == 'Null') return TypeCategory.null_;

      // 集合类型
      if (_listInternalClasses.contains(name)) return TypeCategory.collectionList;
      if (_mapInternalClasses.contains(name)) return TypeCategory.collectionMap;
      if (_setInternalClasses.contains(name)) return TypeCategory.collectionSet;
      if (name == 'Iterator' || name == '_Iterator') {
        return TypeCategory.collectionIterator;
      }

      // Promise / Future
      if (name == 'Future' || name == '_Future') return TypeCategory.promise;
      if (name == 'FutureOr') return TypeCategory.futureOr;

      // SDK 包装类
      if (name == 'StringBuffer') return TypeCategory.stringBuffer;
      if (name == 'MapEntry') return TypeCategory.mapEntry;
      if (name == 'RegExp' || name == '_RegExp') return TypeCategory.regExp;
      if (name == 'Duration') return TypeCategory.duration;
      if (name == 'DateTime') return TypeCategory.dateTime;
      if (name == 'Comparable') return TypeCategory.comparable;

      // SDK 异常类
      if (name == 'StateError') return TypeCategory.stateError;
      if (name == 'ArgumentError') return TypeCategory.argumentError;
      if (name == 'RangeError') return TypeCategory.rangeError;
      if (name == 'FormatException') return TypeCategory.formatException;
      if (name == 'UnsupportedError') return TypeCategory.unsupportedError;
      if (name == 'UnimplementedError') return TypeCategory.unimplementedError;

      // 其他 SDK 类 → unknown（保留原名）
      final uri = type.classNode.enclosingLibrary.importUri.toString();
      if (uri.startsWith('dart:') || uri.startsWith('package:')) {
        return TypeCategory.unknown;
      }

      // 用户类
      return TypeCategory.userClass;
    }

    if (type is TypeParameterType) return TypeCategory.typeParameter;
    if (type is FunctionType) return TypeCategory.function;
    if (type is RecordType) return TypeCategory.record;

    return TypeCategory.unknown;
  }

  /// 是否为 Set 内部实现类。
  static bool isSetInternalClass(String name) =>
      _setInternalClasses.contains(name);

  /// 是否为 Map 内部实现类。
  static bool isMapInternalClass(String name) =>
      _mapInternalClasses.contains(name);

  /// 是否为 List 内部实现类。
  static bool isListInternalClass(String name) =>
      _listInternalClasses.contains(name);

  /// 是否为集合类（List/Map/Set/Iterable）。
  static bool isCollectionClass(String name) =>
      _listInternalClasses.contains(name) ||
      _mapInternalClasses.contains(name) ||
      _setInternalClasses.contains(name);

  /// 获取 SDK 类名映射。
  static String? mapSdkClassName(String name) => sdkClassNameMap[name];
}
