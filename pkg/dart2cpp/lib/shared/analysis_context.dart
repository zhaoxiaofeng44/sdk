/// 共享分析上下文。
///
/// 存储两套管线（Dart→Dart / Dart→C++）共用的分析结果：
/// - 类信息（用户类、mixin、枚举、继承关系、合成中间类）
/// - 虚表（每个类的 vptr 条目）
/// - 方法级泛型特化
/// - Box 化变量
///
/// 所有字段均为 `final` 集合引用，由各个 Collector/Builder 填充。
library analysis_context;

import 'package:kernel/kernel.dart';

import 'operator_names.dart';

// ---------------------------------------------------------------------------
// VTableEntry — 目标无关的虚表条目
// ---------------------------------------------------------------------------

/// 虚表条目类型。
enum VTableEntryKind { method, getter, setter, operator_ }

/// 虚表条目 — 纯语义信息，不含目标语言签名字符串。
///
/// 签名由 [TypeTransformer] 在 AST→IR 阶段从 [proc] 计算，
/// 存储为 [IrFunctionType]，发射器各自解释。
class VTableEntry {
  /// 方法名（原始，如 `speak`）。
  final String name;

  /// 条目类型。
  final VTableEntryKind kind;

  /// 生成的静态函数名（如 `Dog_speak`、`Dog_get_name`）。
  final String staticFuncName;

  /// 原始 Procedure 节点（用于后续计算签名）。
  final Procedure? proc;

  /// 首次声明该方法的类名（用于 this_ 参数类型推断）。
  final String? declaringClassName;

  const VTableEntry({
    required this.name,
    required this.kind,
    required this.staticFuncName,
    this.proc,
    this.declaringClassName,
  });

  /// 生成 vptr key。
  String get vptrKey => OperatorNames.vptrKey(name, kind);

  @override
  String toString() =>
      'VTableEntry($name, $kind, $staticFuncName, declaring=$declaringClassName)';
}

// ---------------------------------------------------------------------------
// MethodSpecEntry — 方法级泛型特化信息
// ---------------------------------------------------------------------------

/// 记录一个方法级泛型调用的特化信息。
///
/// [vptrSuffix] 用于生成 vptr key 后缀（如 `String`、`int`），
/// [typeArgStrs] 是类型实参字符串列表（如 `['String']`、`['int']`）。
class MethodSpecEntry {
  final String vptrSuffix;
  final List<String> typeArgStrs;

  const MethodSpecEntry(this.vptrSuffix, this.typeArgStrs);

  @override
  bool operator ==(Object other) =>
      other is MethodSpecEntry && other.vptrSuffix == vptrSuffix;

  @override
  int get hashCode => vptrSuffix.hashCode;

  @override
  String toString() => 'MethodSpecEntry($vptrSuffix, $typeArgStrs)';
}

// ---------------------------------------------------------------------------
// AnalysisContext — 共享分析结果容器
// ---------------------------------------------------------------------------

/// 分析上下文 — 两套管线共享的分析结果。
///
/// 由 [ClassInfoCollector]、[VTableBuilder]、[GenericSpecializationScanner]
/// 依次填充，供 [IrTransformer] 和各发射器查询。
class AnalysisContext {
  // ---- 类信息 ----

  /// 所有用户自定义类名（排除 `dart:` / `package:` 中的类）。
  final Set<String> userClasses = {};

  /// 所有 mixin 名称。
  final Set<String> mixinNames = {};

  /// 所有 enum 名称。
  final Set<String> enumNames = {};

  /// 有自定义 `toString` 的 enum 名称。
  final Set<String> enumsWithCustomToString = {};

  /// 类继承关系：子类名 → 父类名（仅用户自定义类）。
  final Map<String, String> classHierarchy = {};

  /// 类名 → Class AST 节点。
  final Map<String, Class> classNodes = {};

  /// 合成 mixin 中间类名集合（如 `Dog_Animal_Printable`）。
  final Set<String> syntheticLoweredNames = {};

  // ---- 虚表 ----

  /// 类名 → 虚表条目列表。
  final Map<String, List<VTableEntry>> classVTableEntries = {};

  // ---- 泛型特化 ----

  /// 类名 → { 方法名 → { 特化条目集合 } }。
  final Map<String, Map<String, Set<MethodSpecEntry>>>
      methodTypeSpecializations = {};

  // ---- Box 化 ----

  /// 函数入口 → 需要 Box 化的变量集合。
  final Map<FunctionNode, Set<VariableDeclaration>> boxedVars = {};

  // ---- 查询方法 ----

  /// 是否为用户自定义类。
  bool isUserClass(String name) => userClasses.contains(name);

  /// 是否为 mixin。
  bool isMixin(String name) => mixinNames.contains(name);

  /// 是否为 enum。
  bool isEnum(String name) => enumNames.contains(name);

  /// 是否需要 OOP lowering（用户类、mixin、合成中间类）。
  bool needsLowering(String name) =>
      isUserClass(name) || isMixin(name) || syntheticLoweredNames.contains(name);

  /// 是否为合成 mixin 中间类。
  bool isSyntheticMixin(String name) =>
      syntheticLoweredNames.contains(name);

  /// 获取类的虚表条目。
  List<VTableEntry> getVTableEntries(String className) =>
      classVTableEntries[className] ?? const [];

  /// 获取类的所有虚表条目（含继承）。
  List<VTableEntry> getAllVTableEntries(String className) {
    final result = <VTableEntry>[];
    // 从当前类向上遍历
    var current = className;
    final chain = <String>[];
    while (current.isNotEmpty) {
      chain.add(current);
      final parent = classHierarchy[current];
      if (parent == null) break;
      current = parent;
    }
    // 反向（父→子），后者覆盖前者
    for (final name in chain.reversed) {
      final entries = classVTableEntries[name];
      if (entries != null) {
        for (final entry in entries) {
          result.removeWhere((e) => e.name == entry.name && e.kind == entry.kind);
          result.add(entry);
        }
      }
    }
    return result;
  }

  /// 将合成中间类名映射回真实用户类名。
  /// 如 `Dog_Animal_Printable` → `Dog`。
  String findUserClassForSynthetic(String syntheticName) {
    // 合成名格式：BaseClass_Mixin1_Mixin2_...
    // 真实用户类就是第一段
    final parts = syntheticName.split('_');
    return parts.isNotEmpty ? parts.first : syntheticName;
  }

  /// 清理状态（新一次转换前调用）。
  void clear() {
    userClasses.clear();
    mixinNames.clear();
    enumNames.clear();
    enumsWithCustomToString.clear();
    classHierarchy.clear();
    classNodes.clear();
    syntheticLoweredNames.clear();
    classVTableEntries.clear();
    methodTypeSpecializations.clear();
    boxedVars.clear();
  }
}
